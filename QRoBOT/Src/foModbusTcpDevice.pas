unit foModbusTcpDevice;

interface

uses
  System.Classes,
  System.DateUtils,
  System.SysUtils,
  OverbyteIcsWSocket,
  foModbusDevice;

type
  EfoModbusTcpDevice = class(Exception);

  TfoModbusTcpDevice = class(TfoModbusDevice)
  private
    FSocket: TWSocket;
    FHost: string;
    FPort: string;
    FReceiveBuffer: AnsiString;
    FTransactionId: Word;
    FExpectedTransactionId: Word;
    FLastSocketError: Word;
    FAutoReconnect: Boolean;
    FReconnectInterval: Integer;
    FLastReconnectAttempt: TDateTime;
    FRegisterAddressOffset: Integer;
    procedure SocketDataAvailable(Sender: TObject; Error: Word);
    procedure SocketSessionConnected(Sender: TObject; Error: Word);
    procedure SocketSessionClosed(Sender: TObject; Error: Word);
    procedure SocketError(Sender: TObject);
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: string);
    procedure ProcessTcpFrames;
  protected
    function DoInitialize: Boolean; override;
    function DoFinalize: Boolean; override;
    function DoGetConnected: Boolean; override;
    procedure DoMonitor; override;
    function DoSendPacket(const APacketData: AnsiString): Boolean; override;
    procedure DoCheckPacketReceived; override;
    procedure DoPacketReceived(const APacketData: AnsiString); override;
    function EncodePacket(APacket: TfoModbusPacket): AnsiString; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    property Socket: TWSocket read FSocket;
    property Connected: Boolean read DoGetConnected;
    property LastSocketError: Word read FLastSocketError;
  published
    property Host: string read FHost write SetHost;
    property Port: string read FPort write SetPort;
    property AutoReconnect: Boolean read FAutoReconnect write FAutoReconnect default True;
    { Interval in milliseconds between automatic connection attempts. }
    property ReconnectInterval: Integer read FReconnectInterval
      write FReconnectInterval default 5000;
    { Difference between the address printed in the device manual and the
      zero-based Protocol Data Address sent on the wire. }
    property RegisterAddressOffset: Integer read FRegisterAddressOffset
      write FRegisterAddressOffset default 0;
  end;

implementation

function ReadBEWord(const S: AnsiString; const Index: Integer): Word;
begin
  Result := (Word(Byte(S[Index])) shl 8) or Word(Byte(S[Index + 1]));
end;

function BEWord(const Value: Word): AnsiString;
begin
  SetLength(Result, 2);
  Result[1] := AnsiChar((Value shr 8) and $FF);
  Result[2] := AnsiChar(Value and $FF);
end;

constructor TfoModbusTcpDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHost := '127.0.0.1';
  FPort := '502';
  FAutoReconnect := True;
  FReconnectInterval := 5000;
  FLastReconnectAttempt := 0;
  FRegisterAddressOffset := 0;
  FTransactionId := 0;
  FExpectedTransactionId := 0;
  FReceiveBuffer := '';

  FSocket := TWSocket.Create(Self);
  FSocket.Proto := 'tcp';
  FSocket.LineMode := False;
  FSocket.OnDataAvailable := SocketDataAvailable;
  FSocket.OnSessionConnected := SocketSessionConnected;
  FSocket.OnSessionClosed := SocketSessionClosed;
  FSocket.OnError := SocketError;
end;

destructor TfoModbusTcpDevice.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

procedure TfoModbusTcpDevice.SetHost(const Value: string);
begin
  if FHost <> Trim(Value) then
  begin
    if Connected then
      Disconnect;
    FHost := Trim(Value);
  end;
end;

procedure TfoModbusTcpDevice.SetPort(const Value: string);
begin
  if FPort <> Trim(Value) then
  begin
    if Connected then
      Disconnect;
    FPort := Trim(Value);
  end;
end;

procedure TfoModbusTcpDevice.Connect;
begin
  if FSocket.State in [wsConnecting, wsConnected] then
    Exit;
  if FHost = '' then
    raise EfoModbusTcpDevice.Create('Modbus TCP Host is empty');
  if FPort = '' then
    raise EfoModbusTcpDevice.Create('Modbus TCP Port is empty');

  FReceiveBuffer := '';
  FLastSocketError := 0;
  FLastReconnectAttempt := Now;
  FSocket.Close;
  FSocket.Proto := 'tcp';
  FSocket.Addr := FHost;
  FSocket.Port := FPort;
  FSocket.Connect;
end;

procedure TfoModbusTcpDevice.Disconnect;
begin
  if Assigned(FSocket) then
    FSocket.Close;
  FReceiveBuffer := '';
end;

function TfoModbusTcpDevice.DoInitialize: Boolean;
begin
  Result := inherited DoInitialize;
  if not Result then
    Exit;
  try
    Connect;
  except
    on E: Exception do
    begin
      FLastReconnectAttempt := Now;
      if Assigned(OnLog) then
        OnLog(Self, Format('Initial connection failed [%s:%s] %s',
          [FHost, FPort, E.Message]));
      { Keep the device enabled so DoMonitor can retry the connection. }
      if not FAutoReconnect then
        raise;
    end;
  end;
end;

function TfoModbusTcpDevice.DoFinalize: Boolean;
begin
  Disconnect;
  Result := inherited DoFinalize;
end;

function TfoModbusTcpDevice.DoGetConnected: Boolean;
begin
  Result := Assigned(FSocket) and (FSocket.State = wsConnected);
end;

procedure TfoModbusTcpDevice.DoMonitor;
begin
  if not Enabled then
    Exit;

  if not Connected then
  begin
    if FAutoReconnect and Assigned(FSocket) and
       (FSocket.State <> wsConnecting) and
       ((FLastReconnectAttempt = 0) or
        (MilliSecondSpan(Now, FLastReconnectAttempt) >= FReconnectInterval)) then
    begin
      try
        Connect;
        if Assigned(OnLog) then
          OnLog(Self, Format('Reconnect requested [%s:%s]', [FHost, FPort]));
      except
        on E: Exception do
        begin
          FLastReconnectAttempt := Now;
          if Assigned(OnLog) then
            OnLog(Self, Format('Reconnect failed [%s:%s] %s',
              [FHost, FPort, E.Message]));
        end;
      end;
    end;
    Exit;
  end;

  inherited DoMonitor;
end;

function TfoModbusTcpDevice.EncodePacket(
  APacket: TfoModbusPacket): AnsiString;
var
  RtuFrame: AnsiString;
  Pdu: AnsiString;
  MbapLength: Word;
  ManualAddress: Integer;
begin
  ManualAddress := APacket.StartingAddress;
  if (ManualAddress - FRegisterAddressOffset < 0) or
     (ManualAddress - FRegisterAddressOffset > $FFFF) then
    raise EfoModbusTcpDevice.CreateFmt(
      'Invalid register address: manual=%d, offset=%d',
      [ManualAddress, FRegisterAddressOffset]);

  { Keep packet and Data Channel addresses in the notation used by the device
    manual. Apply the zero-based conversion only while encoding the request. }
  APacket.StartingAddress := ManualAddress - FRegisterAddressOffset;
  try
    RtuFrame := inherited EncodePacket(APacket);
  finally
    APacket.StartingAddress := ManualAddress;
  end;
  if Length(RtuFrame) < 4 then
  begin
    Result := '';
    Exit;
  end;

  { Inherited frame: UnitId + PDU + CRC16.  Modbus TCP uses the same
    UnitId/PDU but replaces CRC16 with a seven-byte MBAP header. }
  Pdu := Copy(RtuFrame, 2, Length(RtuFrame) - 3);
  { Transaction ID is a 16-bit Modbus TCP field.  With Delphi overflow
    checking enabled, Inc(Word($FFFF)) raises EIntOverflow before it can wrap
    to zero.  Reserve zero and explicitly restart at one. }
  if FTransactionId = High(Word) then
    FTransactionId := 1
  else
    Inc(FTransactionId);
  FExpectedTransactionId := FTransactionId;
  MbapLength := Word(1 + Length(Pdu));

  Result := BEWord(FTransactionId) +
            BEWord(0) +
            BEWord(MbapLength) +
            AnsiChar(APacket.SlaveAddress) +
            Pdu;
end;

function TfoModbusTcpDevice.DoSendPacket(
  const APacketData: AnsiString): Boolean;
var
  Sent: Integer;
begin
  Result := False;
  if not Connected then
  begin
    if FAutoReconnect and (FSocket.State <> wsConnecting) then
      Connect;
    Exit;
  end;

  Sent := FSocket.SendStr(APacketData);
  Result := Sent = Length(APacketData);
end;

procedure TfoModbusTcpDevice.DoCheckPacketReceived;
begin
  { ICS delivers data through OnDataAvailable. }
  ProcessTcpFrames;
end;

procedure TfoModbusTcpDevice.DoPacketReceived(
  const APacketData: AnsiString);
begin
  FReceiveBuffer := FReceiveBuffer + APacketData;
  ProcessTcpFrames;
end;

procedure TfoModbusTcpDevice.ProcessTcpFrames;
var
  TransactionId: Word;
  ProtocolId: Word;
  DataLength: Word;
  FrameLength: Integer;
  TcpFrame: AnsiString;
  UnitAndPdu: AnsiString;
begin
  while Length(FReceiveBuffer) >= 7 do
  begin
    TransactionId := ReadBEWord(FReceiveBuffer, 1);
    ProtocolId := ReadBEWord(FReceiveBuffer, 3);
    DataLength := ReadBEWord(FReceiveBuffer, 5);

    if (ProtocolId <> 0) or (DataLength < 2) or (DataLength > 254) then
    begin
      { Invalid MBAP header: discard one byte and search for the next frame. }
      Delete(FReceiveBuffer, 1, 1);
      Continue;
    end;

    FrameLength := 6 + DataLength;
    if Length(FReceiveBuffer) < FrameLength then
      Exit;

    TcpFrame := Copy(FReceiveBuffer, 1, FrameLength);
    Delete(FReceiveBuffer, 1, FrameLength);

    { Only one request is outstanding in TfoModbusDevice's dispatcher. }
    if TransactionId <> FExpectedTransactionId then
      Continue;

    UnitAndPdu := Copy(TcpFrame, 7, DataLength);
    { The inherited parser does not validate CRC. Two placeholder bytes let
      its RTU length/parser logic safely decode UnitId + PDU. }
    inherited DoPacketReceived(UnitAndPdu + #0#0);
  end;
end;

procedure TfoModbusTcpDevice.SocketDataAvailable(Sender: TObject; Error: Word);
var
  Data: AnsiString;
begin
  if Error <> 0 then
  begin
    FLastSocketError := Error;
    Exit;
  end;
  Data := FSocket.ReceiveStrA;
  if Data <> '' then
    DoPacketReceived(Data);
end;

procedure TfoModbusTcpDevice.SocketSessionConnected(Sender: TObject;
  Error: Word);
begin
  FLastSocketError := Error;
  if Error <> 0 then
    FReceiveBuffer := '';
  if Assigned(OnLog) then
  begin
    if Error = 0 then
      OnLog(Self, Format('Connected [%s:%s]', [FHost, FPort]))
    else
      OnLog(Self, Format('Connection failed [%s:%s], error=%d',
        [FHost, FPort, Error]));
  end;
end;

procedure TfoModbusTcpDevice.SocketSessionClosed(Sender: TObject;
  Error: Word);
begin
  FLastSocketError := Error;
  FReceiveBuffer := '';
  FLastReconnectAttempt := Now;
  if Assigned(OnLog) then
    OnLog(Self, Format('Disconnected [%s:%s], error=%d; reconnect in %d ms',
      [FHost, FPort, Error, FReconnectInterval]));
end;

procedure TfoModbusTcpDevice.SocketError(Sender: TObject);
begin
  { Detailed socket errors are also reported by the ICS session events. }
end;

end.
