unit uCommWaterSensors;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, foModbusDevice, uLogger,
  uModbusRtuDevice;

type
  TQVIXIonSensorSnapshot = record
    SlaveAddress: Byte;
    TemperatureC: Double;
    PX: Double;
    Millivolts: Double;
    ConcentrationMgL: Single;
    ConductivityUSCm: Double;
    ORPMillivolts: Double;
    RawRegisters: array[0..4] of Word;
  end;

  TQVIXIonSensorSnapshotEvent = procedure(Sender: TObject;
    const ASnapshot: TQVIXIonSensorSnapshot) of object;

  TQVIXWaterSensorsComm = class(TQVIXModbusRtuDevice)
  private
    FSnapshot: TQVIXIonSensorSnapshot;
    FSnapshots: array[0..247] of TQVIXIonSensorSnapshot;
    FSnapshotValid: array[0..247] of Boolean;
    FLastResponseTick: array[0..247] of UInt64;
    FLastResponseSlave: Integer;
    FOnSnapshot: TQVIXIonSensorSnapshotEvent;
    FResponseCache: TStringList;
    procedure AddPollingPacket(const ASlaveAddress: Byte);
    procedure ModbusLog(Sender: TObject; const ALog: string);
    function ReadRegister(const AResponse: AnsiString;
      const ARegisterIndex: Integer): Word;
    procedure SlaveResponded(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close; override;
    procedure ConfigurePolling; overload;
    procedure ConfigurePolling(const ASlaveIDs: string); overload;
    procedure ConfigureTestRead(const ASlave: Byte;
      const AInputRegisters: Boolean; const AStartingAddress,
      AQuantity: Word);
    function TryGetSnapshot(const ASlaveAddress: Byte;
      out ASnapshot: TQVIXIonSensorSnapshot): Boolean;
    property Snapshot: TQVIXIonSensorSnapshot read FSnapshot;
    property OnSnapshot: TQVIXIonSensorSnapshotEvent read FOnSnapshot
      write FOnSnapshot;
  end;

implementation

const
  CWaterSensorSnapshotTimeoutMs = 7000;

constructor TQVIXWaterSensorsComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'WaterSensorsComm';
  FResponseCache := TStringList.Create;
  FLastResponseSlave := -1;
  Modbus.OnLog := ModbusLog;
  Modbus.OnSlaveResponded := SlaveResponded;
end;

destructor TQVIXWaterSensorsComm.Destroy;
begin
  FResponseCache.Free;
  inherited Destroy;
end;

procedure TQVIXWaterSensorsComm.ModbusLog(Sender: TObject;
  const ALog: string);
var
  HexText: string;
  Separator: Integer;
  Slave: Integer;
begin
  if Copy(ALog, 1, 3) <> 'R :' then
    Exit;
  HexText := Trim(Copy(ALog, 4, MaxInt));
  Separator := Pos(':', HexText);
  if Separator > 0 then
    HexText := Trim(Copy(HexText, Separator + 1, MaxInt));
  Separator := Pos(' ', HexText);
  if Separator > 0 then
    HexText := Copy(HexText, 1, Separator - 1);
  if TryStrToInt('$' + HexText, Slave) and (Slave >= 1) and
     (Slave <= 247) then
    FLastResponseSlave := Slave;
end;

procedure TQVIXWaterSensorsComm.Close;
begin
  FLastResponseSlave := -1;
  FillChar(FSnapshotValid, SizeOf(FSnapshotValid), 0);
  FillChar(FLastResponseTick, SizeOf(FLastResponseTick), 0);
  inherited Close;
end;

procedure TQVIXWaterSensorsComm.AddPollingPacket(
  const ASlaveAddress: Byte);
var
  Packet: TfoModbusPacket;
begin
  Packet := Modbus.PacketsToRead.Add;
  Packet.Name := Format('ION_SENSOR_ID_%d', [ASlaveAddress]);
  Packet.Enabled := True;
  Packet.GroupIndex := 0;
  Packet.SlaveAddress := ASlaveAddress;
  Packet.FunctionCode := mfcReadHoldingRegisters;
  Packet.StartingAddress := 0;
  Packet.Quantity := 5;
  FResponseCache.Add('');
end;

procedure TQVIXWaterSensorsComm.ConfigurePolling;
begin
  FLastResponseSlave := -1;
  FillChar(FSnapshotValid, SizeOf(FSnapshotValid), 0);
  FillChar(FLastResponseTick, SizeOf(FLastResponseTick), 0);
  Modbus.PacketsToRead.Clear;
  Modbus.PacketsToWrite.Clear;
  FResponseCache.Clear;
  AddPollingPacket(Config.SlaveAddress);
end;

function TQVIXWaterSensorsComm.TryGetSnapshot(const ASlaveAddress: Byte;
  out ASnapshot: TQVIXIonSensorSnapshot): Boolean;
begin
  Result := FSnapshotValid[ASlaveAddress] and
    (FLastResponseTick[ASlaveAddress] <> 0) and
    (GetTickCount64 - FLastResponseTick[ASlaveAddress] <=
      CWaterSensorSnapshotTimeoutMs);
  if Result then
    ASnapshot := FSnapshots[ASlaveAddress];
  if not Result then
    FSnapshotValid[ASlaveAddress] := False;
end;

procedure TQVIXWaterSensorsComm.ConfigurePolling(const ASlaveIDs: string);
var
  I: Integer;
  ID: Integer;
  IDs: TStringList;
begin
  FLastResponseSlave := -1;
  FillChar(FSnapshotValid, SizeOf(FSnapshotValid), 0);
  FillChar(FLastResponseTick, SizeOf(FLastResponseTick), 0);
  Modbus.PacketsToRead.Clear;
  Modbus.PacketsToWrite.Clear;
  FResponseCache.Clear;
  IDs := TStringList.Create;
  try
    IDs.StrictDelimiter := True;
    IDs.Delimiter := ',';
    IDs.DelimitedText := StringReplace(ASlaveIDs, ';', ',', [rfReplaceAll]);
    for I := 0 to IDs.Count - 1 do
      if TryStrToInt(Trim(IDs[I]), ID) and (ID >= 1) and (ID <= 247) then
        AddPollingPacket(Byte(ID));
  finally
    IDs.Free;
  end;
  if Modbus.PacketsToRead.Count = 0 then
    AddPollingPacket(Config.SlaveAddress);
end;

procedure TQVIXWaterSensorsComm.ConfigureTestRead(const ASlave: Byte;
  const AInputRegisters: Boolean; const AStartingAddress,
  AQuantity: Word);
var
  Packet: TfoModbusPacket;
begin
  FLastResponseSlave := -1;
  FillChar(FSnapshotValid, SizeOf(FSnapshotValid), 0);
  FillChar(FLastResponseTick, SizeOf(FLastResponseTick), 0);
  Modbus.PacketsToRead.Clear;
  Modbus.PacketsToWrite.Clear;
  Packet := Modbus.PacketsToRead.Add;
  Packet.Name := 'SENSOR_TEST_READ';
  Packet.Enabled := True;
  Packet.GroupIndex := 0;
  Packet.SlaveAddress := ASlave;
  if AInputRegisters then
    Packet.FunctionCode := mfcReadInputRegister
  else
    Packet.FunctionCode := mfcReadHoldingRegisters;
  Packet.StartingAddress := AStartingAddress;
  Packet.Quantity := AQuantity;
end;

function TQVIXWaterSensorsComm.ReadRegister(const AResponse: AnsiString;
  const ARegisterIndex: Integer): Word;
var
  Offset: Integer;
begin
  Offset := 4 + ARegisterIndex * 2;
  if (ARegisterIndex < 0) or (Offset + 1 > Length(AResponse)) then
  begin
    Result := 0;
    Exit;
  end;
  Result := (Word(Byte(AResponse[Offset])) shl 8) or
    Word(Byte(AResponse[Offset + 1]));
end;

procedure TQVIXWaterSensorsComm.SlaveResponded(Sender: TObject);
var
  Bits: Cardinal;
  I: Integer;
  Packet: TfoModbusPacket;
  Response: AnsiString;
  Register3: Word;
  Register4: Word;
begin
  Packet := nil;
  Response := '';
  for I := 0 to Modbus.PacketsToRead.Count - 1 do
    if Modbus.PacketsToRead[I].SlaveAddress = FLastResponseSlave then
    begin
      Packet := Modbus.PacketsToRead[I];
      Response := Packet.LastResponse;
      if I < FResponseCache.Count then
        FResponseCache[I] := Response;
      Break;
    end;
  if not Assigned(Packet) then
    Exit;
  if (Length(Response) < 15) or
     (Byte(Response[1]) <> Packet.SlaveAddress) or
     (Byte(Response[2]) <> 3) or (Byte(Response[3]) < 10) then
    Exit;

  FSnapshot.SlaveAddress := Packet.SlaveAddress;
  for I := 0 to 4 do
    FSnapshot.RawRegisters[I] := ReadRegister(Response, I);
  FSnapshot.ConductivityUSCm := 0;
  FSnapshot.ORPMillivolts := 0;
  if Packet.SlaveAddress in [13, 14] then
  begin
    FSnapshot.ConductivityUSCm := ReadRegister(Response, 0) * 0.1;
    FSnapshot.TemperatureC := ReadRegister(Response, 1) * 0.1;
    FSnapshot.PX := 0;
    FSnapshot.Millivolts := 0;
    FSnapshot.ConcentrationMgL := 0;
  end
  else if Packet.SlaveAddress = 15 then
  begin
    FSnapshot.ORPMillivolts := SmallInt(ReadRegister(Response, 0));
    FSnapshot.TemperatureC := SmallInt(ReadRegister(Response, 1)) * 0.1;
    FSnapshot.PX := 0;
    FSnapshot.Millivolts := 0;
    FSnapshot.ConcentrationMgL := 0;
  end
  else
  begin
    FSnapshot.TemperatureC := ReadRegister(Response, 0) * 0.1;
    FSnapshot.PX := ReadRegister(Response, 1) * 0.001;
    FSnapshot.Millivolts := SmallInt(ReadRegister(Response, 2)) * 0.1;
    Register3 := ReadRegister(Response, 3);
    Register4 := ReadRegister(Response, 4);
    Bits := (Cardinal(Register4) shl 16) or Register3;
    Move(Bits, FSnapshot.ConcentrationMgL, SizeOf(Bits));
  end;
  FSnapshots[FSnapshot.SlaveAddress] := FSnapshot;
  FSnapshotValid[FSnapshot.SlaveAddress] := True;
  FLastResponseTick[FSnapshot.SlaveAddress] := GetTickCount64;
  if FSnapshot.SlaveAddress in [13, 14] then
    QVIXLog('SENSOR', Format(
      '[ID=%d] EC=%.1f uS/cm, Temperature=%.1f C',
      [FSnapshot.SlaveAddress, FSnapshot.ConductivityUSCm,
       FSnapshot.TemperatureC]))
  else if FSnapshot.SlaveAddress = 15 then
    QVIXLog('SENSOR', Format('[ID=15] ORP=%.0f mV, Temperature=%.1f C',
      [FSnapshot.ORPMillivolts, FSnapshot.TemperatureC]))
  else
    QVIXLog('SENSOR', Format(
      '[ID=%d] Temperature=%.1f C, pX=%.3f, mV=%.1f, Concentration=%.3f mg/L',
      [FSnapshot.SlaveAddress, FSnapshot.TemperatureC, FSnapshot.PX,
       FSnapshot.Millivolts, FSnapshot.ConcentrationMgL]));
  if Assigned(FOnSnapshot) then
    FOnSnapshot(Self, FSnapshot);
end;

end.
