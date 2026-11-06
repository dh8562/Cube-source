unit uCommPlasma;

interface

uses
  System.Classes, foModbusDevice, uModbusRtuDevice;

type
  TQVIXPlasmaAlarm = (paOverCurrent, paOverTemperature, paOverVoltage,
    paUnderVoltage, paAirPressure, paOpenCircuit, paIGBT1OverCurrent,
    paIGBT2OverCurrent, paInverterOverCurrent, paArcFailure, paMotorStall);
  TQVIXPlasmaAlarms = set of TQVIXPlasmaAlarm;

  TQVIXPlasmaSnapshot = record
    SystemStatus: Word;
    Started: Boolean;
    PowerOn: Boolean;
    ScreenControl: Boolean;
    Running: Boolean;
    AlarmActive: Boolean;
    PowerSetpointW: Word;
    FrequencyKHz: Double;
    DCVoltageV: Double;
    DCCurrentA: Double;
    OutputPowerW: Double;
    MotorSpeedRPM: Word;
    AlarmWord: Word;
    Alarms: TQVIXPlasmaAlarms;
    HardwareVersion: Double;
    SoftwareVersion: Double;
    MotorCurrentA: Double;
    MaintenanceSetHours: Word;
  end;

  TQVIXPlasmaSnapshotEvent = procedure(Sender: TObject;
    const ASnapshot: TQVIXPlasmaSnapshot) of object;

  TQVIXPlasmaComm = class(TQVIXModbusRtuDevice)
  private
    FSnapshot: TQVIXPlasmaSnapshot;
    FOnSnapshot: TQVIXPlasmaSnapshotEvent;
    function ReadRegister(const AResponse: AnsiString;
      const AAddress: Integer): Word;
    procedure SlaveResponded(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ConfigurePolling;
    function SetOutput(const AEnabled: Boolean): Boolean;
    function SetPower(const APowerW: Word): Boolean;
    property Snapshot: TQVIXPlasmaSnapshot read FSnapshot;
    property OnSnapshot: TQVIXPlasmaSnapshotEvent read FOnSnapshot
      write FOnSnapshot;
  end;

implementation

constructor TQVIXPlasmaComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'PlasmaComm';
  Modbus.OnSlaveResponded := SlaveResponded;
end;

procedure TQVIXPlasmaComm.ConfigurePolling;
var
  Packet: TfoModbusPacket;
begin
  Modbus.PacketsToRead.Clear;
  Modbus.PacketsToWrite.Clear;
  Packet := Modbus.PacketsToRead.Add;
  Packet.Name := 'PLASMA_STATUS_0_43';
  Packet.Enabled := True;
  Packet.GroupIndex := 0;
  Packet.SlaveAddress := Config.SlaveAddress;
  Packet.FunctionCode := mfcReadHoldingRegisters;
  Packet.StartingAddress := 0;
  Packet.Quantity := 44;
end;

function TQVIXPlasmaComm.ReadRegister(const AResponse: AnsiString;
  const AAddress: Integer): Word;
var
  Offset: Integer;
begin
  Offset := 4 + AAddress * 2;
  if (AAddress < 0) or (Offset + 1 > Length(AResponse)) then
  begin
    Result := 0;
    Exit;
  end;
  Result := (Word(Byte(AResponse[Offset])) shl 8) or
    Word(Byte(AResponse[Offset + 1]));
end;

function TQVIXPlasmaComm.SetOutput(const AEnabled: Boolean): Boolean;
begin
  if AEnabled then
    Result := WriteSingleRegister(Config.SlaveAddress, 0, 1)
  else
    Result := WriteSingleRegister(Config.SlaveAddress, 0, 0);
end;

function TQVIXPlasmaComm.SetPower(const APowerW: Word): Boolean;
begin
  Result := False;
  if (APowerW < 300) or (APowerW > 1000) then
    Exit;
  Result := WriteSingleRegister(Config.SlaveAddress, 1, APowerW);
end;

procedure TQVIXPlasmaComm.SlaveResponded(Sender: TObject);
var
  Alarm: TQVIXPlasmaAlarm;
  Response: AnsiString;
begin
  if Modbus.PacketsToRead.Count = 0 then
    Exit;
  Response := Modbus.PacketsToRead[0].LastResponse;
  if (Length(Response) < 93) or
     (Byte(Response[1]) <> Config.SlaveAddress) or
     (Byte(Response[2]) <> 3) or (Byte(Response[3]) < 88) then
    Exit;

  FSnapshot.SystemStatus := ReadRegister(Response, 0);
  FSnapshot.Started := (FSnapshot.SystemStatus and $0001) <> 0;
  FSnapshot.PowerOn := (FSnapshot.SystemStatus and $0002) <> 0;
  FSnapshot.ScreenControl := (FSnapshot.SystemStatus and $0004) <> 0;
  FSnapshot.Running := (FSnapshot.SystemStatus and $0008) <> 0;
  FSnapshot.AlarmActive := (FSnapshot.SystemStatus and $0010) <> 0;
  FSnapshot.PowerSetpointW := ReadRegister(Response, 1);
  FSnapshot.FrequencyKHz := ReadRegister(Response, 2) / 10.0;
  FSnapshot.DCVoltageV := ReadRegister(Response, 3) / 10.0;
  FSnapshot.DCCurrentA := ReadRegister(Response, 4) / 1000.0;
  FSnapshot.OutputPowerW := ReadRegister(Response, 5) / 10.0;
  FSnapshot.MotorSpeedRPM := ReadRegister(Response, 6);
  FSnapshot.AlarmWord := ReadRegister(Response, 7);
  FSnapshot.Alarms := [];
  for Alarm := Low(TQVIXPlasmaAlarm) to High(TQVIXPlasmaAlarm) do
    if (FSnapshot.AlarmWord and (Word(1) shl Ord(Alarm))) <> 0 then
      Include(FSnapshot.Alarms, Alarm);
  FSnapshot.HardwareVersion := ReadRegister(Response, 11) / 100.0;
  FSnapshot.SoftwareVersion := ReadRegister(Response, 12) / 100.0;
  FSnapshot.MotorCurrentA := ReadRegister(Response, 13) / 100.0;
  FSnapshot.MaintenanceSetHours := ReadRegister(Response, 17);
  if Assigned(FOnSnapshot) then
    FOnSnapshot(Self, FSnapshot);
end;

end.
