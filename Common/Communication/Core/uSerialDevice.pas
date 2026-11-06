unit uSerialDevice;

interface

uses
  System.Classes, System.SysUtils, foComm, uCommBase, uLogger;

type
  TQVIXSerialDevice = class(TQVIXCommDevice)
  private
    procedure CommError(Sender: TObject; ErrCode: Integer; ErrDesc: string);
    procedure OpenStatus(Sender: TObject; State: Boolean);
  protected
    FComm: TfoComm;
    function BaudRateValue(const ABaudRate: Integer): TfocBaudRate;
    function FrameToHex(const AData: AnsiString): string;
    procedure LogFrame(const ADirection: string; const AData: AnsiString);
    procedure Received(Sender: TObject; const ACount: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Configure(const AConfig: TQVIXCommConfig); override;
    function Open: Boolean; override;
    procedure Close; override;
    function Send(const AData: TBytes): Boolean; override;
    property Comm: TfoComm read FComm;
  end;

implementation

function TQVIXSerialDevice.BaudRateValue(
  const ABaudRate: Integer): TfocBaudRate;
begin
  case ABaudRate of
    2400: Result := ___2400;
    4800: Result := ___4800;
    14400: Result := __14400;
    19200: Result := __19200;
    38400: Result := __38400;
    56000: Result := __56000;
    57600: Result := __57600;
    115200: Result := _115200;
    128000: Result := _128000;
    256000: Result := _256000;
  else
    Result := ___9600;
  end;
end;

function TQVIXSerialDevice.FrameToHex(const AData: AnsiString): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AData) do
  begin
    if I > 1 then
      Result := Result + ' ';
    Result := Result + IntToHex(Byte(AData[I]), 2);
  end;
end;

procedure TQVIXSerialDevice.LogFrame(const ADirection: string;
  const AData: AnsiString);
var
  DeviceName: string;
begin
  DeviceName := Name;
  if DeviceName = '' then
    DeviceName := ClassName;
  QVIXLog('COMM', Format('[%s][COM%d][%s] %s',
    [DeviceName, Config.PortNo, ADirection, FrameToHex(AData)]));
end;

procedure TQVIXSerialDevice.Close;
begin
  if FComm.PortOpened then
    FComm.CloseComm;
  SetState(qcsClosed, 'Communication closed');
end;

procedure TQVIXSerialDevice.CommError(Sender: TObject; ErrCode: Integer;
  ErrDesc: string);
begin
  SetState(qcsError, Format('Serial error %d: %s', [ErrCode, ErrDesc]));
end;

procedure TQVIXSerialDevice.Configure(const AConfig: TQVIXCommConfig);
begin
  inherited Configure(AConfig);
  FComm.PortNo := AConfig.PortNo;
  FComm.BaudRate := BaudRateValue(AConfig.BaudRate);
  FComm.Timeout := AConfig.TimeoutMs;
end;

constructor TQVIXSerialDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComm := TfoComm.Create(Self);
  FComm.ByteSize := _8;
  FComm.Parity := cpNone;
  FComm.StopBits := _1;
  FComm.FlowControl := cfcNone;
  FComm.BinaryMode := True;
  FComm.DiscardNull := False;
  FComm.OnCommError := CommError;
  FComm.OnOpenStatus := OpenStatus;
  FComm.OnReceived := Received;
end;

function TQVIXSerialDevice.Open: Boolean;
begin
  SetState(qcsOpening, Format('Opening COM%d at %d bps',
    [Config.PortNo, Config.BaudRate]));
  Result := FComm.OpenComm;
  if Result then
    SetState(qcsOpen, Format('COM%d open', [Config.PortNo]))
  else
    SetState(qcsError, Format('Unable to open COM%d', [Config.PortNo]));
end;

procedure TQVIXSerialDevice.OpenStatus(Sender: TObject; State: Boolean);
begin
  if State then
    SetState(qcsOpen, Format('COM%d open', [Config.PortNo]))
  else if Self.State <> qcsError then
    SetState(qcsClosed, Format('COM%d closed', [Config.PortNo]));
end;

procedure TQVIXSerialDevice.Received(Sender: TObject; const ACount: Integer);
var
  Data: AnsiString;
  Bytes: TBytes;
  I: Integer;
begin
  Data := FComm.ReadString;
  if Length(Data) > 0 then
    LogFrame('RX', Data);
  SetLength(Bytes, Length(Data));
  for I := 1 to Length(Data) do
    Bytes[I - 1] := Byte(Data[I]);
  if Length(Bytes) > 0 then
    NotifyData(Bytes);
end;

function TQVIXSerialDevice.Send(const AData: TBytes): Boolean;
var
  Data: AnsiString;
  I: Integer;
begin
  Result := False;
  if not FComm.PortOpened then
    Exit;
  SetLength(Data, Length(AData));
  for I := 0 to High(AData) do
    Data[I + 1] := AnsiChar(AData[I]);
  LogFrame('TX', Data);
  Result := FComm.WriteString(Data);
end;

end.
