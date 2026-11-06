unit uModbusRtuDevice;

interface

uses
  System.Classes, System.SysUtils, foComm, foModbusDevice, uCommBase,
  uSerialDevice;

type
  TQVIXModbusRtuDevice = class(TQVIXSerialDevice)
  private
    FModbus: TfoModbusDevice;
    FDirectWritePending: Boolean;
    FDirectWriteRequest: AnsiString;
    function CRC16(const AData: AnsiString): Word;
    procedure GetConnected(Sender: TObject; var AConnected: Boolean);
    procedure ModbusError(Sender: TObject; const AErrorCode: Integer;
      const AErrorMsg: string);
    procedure SendPacket(Sender: TObject; const APacketData: AnsiString;
      var ASuccess: Boolean);
  protected
    procedure Received(Sender: TObject; const ACount: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Configure(const AConfig: TQVIXCommConfig); override;
    function Open: Boolean; override;
    procedure Close; override;
    function WriteSingleRegister(const ASlave: Byte;
      const AAddress, AValue: Word): Boolean;
    property Modbus: TfoModbusDevice read FModbus;
  end;

implementation

function TQVIXModbusRtuDevice.CRC16(const AData: AnsiString): Word;
var
  I: Integer;
  J: Integer;
begin
  Result := $FFFF;
  for I := 1 to Length(AData) do
  begin
    Result := Result xor Byte(AData[I]);
    for J := 0 to 7 do
      if (Result and 1) <> 0 then
        Result := (Result shr 1) xor $A001
      else
        Result := Result shr 1;
  end;
end;

procedure TQVIXModbusRtuDevice.Close;
begin
  FModbus.Monitoring := False;
  FModbus.Enabled := False;
  if FModbus.Initialized then
    FModbus.Finalize;
  inherited Close;
end;

procedure TQVIXModbusRtuDevice.Configure(const AConfig: TQVIXCommConfig);
begin
  inherited Configure(AConfig);
  FComm.RS485Mode := True;
  FDirectWritePending := False;
end;

constructor TQVIXModbusRtuDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComm.RS485Mode := True;
  FModbus := TfoModbusDevice.Create(Self);
  FModbus.OnSendPacket := SendPacket;
  FModbus.OnGetConnected := GetConnected;
  FModbus.OnCommunicationError := ModbusError;
end;

procedure TQVIXModbusRtuDevice.GetConnected(Sender: TObject;
  var AConnected: Boolean);
begin
  AConnected := FComm.PortOpened;
end;

procedure TQVIXModbusRtuDevice.ModbusError(Sender: TObject;
  const AErrorCode: Integer; const AErrorMsg: string);
begin
  SetState(qcsError, Format('Modbus error %d: %s',
    [AErrorCode, AErrorMsg]));
end;

function TQVIXModbusRtuDevice.Open: Boolean;
begin
  Result := inherited Open;
  if Result then
  begin
    FModbus.Enabled := True;
    FModbus.MonitorInterval := 50;
    FModbus.Synchronize := True;
    Result := FModbus.Initialize;
    FModbus.Monitoring := Result;
    if not Result then
    begin
      inherited Close;
      SetState(qcsError, 'Modbus dispatcher initialization failed');
    end;
  end;
end;

procedure TQVIXModbusRtuDevice.Received(Sender: TObject;
  const ACount: Integer);
var
  Data: AnsiString;
  Bytes: TBytes;
  I: Integer;
begin
  { At 9600 bps a 15-byte RTU response needs about 16 ms.  The serial
    receive event can arrive before the final bytes have entered the driver
    queue, so allow the complete RTU frame to accumulate before reading. }
  TThread.Sleep(20);
  Data := FComm.ReadString;
  if Length(Data) = 0 then
    Exit;
  LogFrame('RX', Data);
  if FDirectWritePending then
  begin
    FDirectWritePending := False;
    FModbus.Monitoring := True;
    SetLength(Bytes, Length(Data));
    for I := 1 to Length(Data) do
      Bytes[I - 1] := Byte(Data[I]);
    NotifyData(Bytes);
    Exit;
  end;
  FModbus.PacketReceived(Data);
  SetLength(Bytes, Length(Data));
  for I := 1 to Length(Data) do
    Bytes[I - 1] := Byte(Data[I]);
  NotifyData(Bytes);
end;

function TQVIXModbusRtuDevice.WriteSingleRegister(const ASlave: Byte;
  const AAddress, AValue: Word): Boolean;
var
  CRC: Word;
begin
  Result := False;
  if not FComm.PortOpened or FDirectWritePending then
    Exit;
  SetLength(FDirectWriteRequest, 6);
  FDirectWriteRequest[1] := AnsiChar(ASlave);
  FDirectWriteRequest[2] := AnsiChar(6);
  FDirectWriteRequest[3] := AnsiChar(AAddress shr 8);
  FDirectWriteRequest[4] := AnsiChar(AAddress and $FF);
  FDirectWriteRequest[5] := AnsiChar(AValue shr 8);
  FDirectWriteRequest[6] := AnsiChar(AValue and $FF);
  CRC := CRC16(FDirectWriteRequest);
  FDirectWriteRequest := FDirectWriteRequest + AnsiChar(CRC and $FF) +
    AnsiChar(CRC shr 8);
  FModbus.Monitoring := False;
  FDirectWritePending := True;
  LogFrame('TX', FDirectWriteRequest);
  Result := FComm.WriteString(FDirectWriteRequest);
  if not Result then
  begin
    FDirectWritePending := False;
    FModbus.Monitoring := True;
  end;
end;

procedure TQVIXModbusRtuDevice.SendPacket(Sender: TObject;
  const APacketData: AnsiString; var ASuccess: Boolean);
begin
  LogFrame('TX', APacketData);
  ASuccess := FComm.PortOpened and FComm.WriteString(APacketData);
end;

end.
