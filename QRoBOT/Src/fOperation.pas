unit fOperation;

interface

uses
  System.Classes, System.IniFiles, System.Math, System.SysUtils, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls, fAlarms, fSensorSimulation, uCommBase,
  uCommunicationManager, uCommWaterSensors, uLogger;

type
  TZPositionChangedEvent = procedure(Sender: TObject;
    const APosition: Double) of object;

  TfrmOperation = class(TForm)
    lblTitle: TLabel;
    lblConnection: TLabel;
    grpMode: TGroupBox;
    rbManual: TRadioButton;
    rbAuto: TRadioButton;
    grpStatus: TGroupBox;
    lblModeCaption: TLabel;
    lblModeValue: TLabel;
    lblPhaseCaption: TLabel;
    lblPhaseValue: TLabel;
    lblPlasmaCaption: TLabel;
    lblPlasmaValue: TLabel;
    lblZCaption: TLabel;
    lblZValue: TLabel;
    lblWaterCaption: TLabel;
    lblWaterValue: TLabel;
    lblElapsedCaption: TLabel;
    lblElapsedValue: TLabel;
    lblManualLimitCaption: TLabel;
    lblManualLimitValue: TLabel;
    lblCumulativeCaption: TLabel;
    lblCumulativeValue: TLabel;
    lblActiveRecipeCaption: TLabel;
    lblActiveRecipeValue: TLabel;
    lblGasCaption: TLabel;
    lblGasValue: TLabel;
    lblPowerCaption: TLabel;
    lblPowerValue: TLabel;
    lblProcessZCaption: TLabel;
    lblProcessZValue: TLabel;
    grpControl: TGroupBox;
    btnRun: TButton;
    btnStop: TButton;
    lblControlNote: TLabel;
    grpSensors: TGroupBox;
    lblNO3Caption: TLabel;
    lblNO3Value: TLabel;
    lblNO2Caption: TLabel;
    lblNO2Value: TLabel;
    lblECCaption: TLabel;
    lblECValue: TLabel;
    lblEC2Caption: TLabel;
    lblEC2Value: TLabel;
    lblORPCaption: TLabel;
    lblORPValue: TLabel;
    lblPHCaption: TLabel;
    lblPHValue: TLabel;
    lblTemperatureCaption: TLabel;
    lblTemperatureValue: TLabel;
    lblSensorWaterCaption: TLabel;
    lblSensorWaterValue: TLabel;
    lblSensorNote: TLabel;
    tmrSensors: TTimer;
    tmrRuntime: TTimer;
    btnSensorSimulation: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ModeClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tmrSensorsTimer(Sender: TObject);
    procedure tmrRuntimeTimer(Sender: TObject);
    procedure btnSensorSimulationClick(Sender: TObject);
  private
    FRunning: Boolean;
    FSampleIndex: Integer;
    FMinimumWaterLevel: Integer;
    FManualLimitSeconds: Integer;
    FCurrentRunSeconds: Integer;
    FCumulativeRunSeconds: Int64;
    FAutoOnSeconds: Integer;
    FAutoOffSeconds: Integer;
    FAutoTotalSeconds: Integer;
    FActiveRecipeName: string;
    FRecipeGases: string;
    FRecipePower: Double;
    FRecipeProcessZ: Double;
    FRecipeMinimumWater: Integer;
    FUseSensorStops: Boolean;
    FNO3Enabled, FNO2Enabled, FECEnabled, FPHEnabled,
      FTemperatureEnabled: Boolean;
    FNO3Operator, FNO2Operator, FECOperator, FPHOperator,
      FTemperatureOperator: Integer;
    FNO3Target, FNO2Target, FECTarget, FPHTarget,
      FTemperatureTarget: Double;
    FAlarmForm: TfrmAlarms;
    FOnRunningChanged: TNotifyEvent;
    FSensorNO3: Double;
    FSensorNO2: Double;
    FSensorEC: Double;
    FSensorEC2: Double;
    FSensorORP: Double;
    FSensorPH: Double;
    FSensorTemperature: Double;
    FSensorWaterLevel: Double;
    FSensorTrend: Boolean;
    FSensorNO3Online, FSensorNO2Online, FSensorECOnline, FSensorEC2Online,
      FSensorORPOnline, FSensorPHOnline, FSensorTemperatureOnline,
      FSensorWaterOnline: Boolean;
    FAutoStage: string;
    FAutoStageSeconds: Integer;
    FDisplayedZ: Double;
    FOnZPositionChanged: TZPositionChangedEvent;
    FCommunicationManager: TQVIXCommunicationManager;
    FSimulationMode: Boolean;
    procedure SensorSnapshot(Sender: TObject;
      const ASnapshot: TQVIXIonSensorSnapshot);
    procedure SensorStatus(Sender: TObject; const AState: TQVIXCommState;
      const AMessage: string);
    procedure AddEvent(const AMessage: string);
    procedure LoadSafetySettings;
    procedure LoadActiveRecipe;
    procedure SaveRuntime;
    function FormatDuration(const ASeconds: Int64): string;
    procedure UpdateSensorDisplay;
    procedure UpdateDisplay;
    procedure SetDisplayedZ(const APosition: Double);
  public
    procedure ReloadSettings;
    procedure HandleAlarm(Sender: TObject);
    procedure HandleHomeRequest(Sender: TObject);
    procedure ResetCumulativeRuntime;
    procedure ApplyAccessMode(const ADeveloperMode: Boolean);
    procedure ApplyCommunicationMode(
      const ACommunicationManager: TQVIXCommunicationManager;
      const ASimulationMode: Boolean);
    property AlarmForm: TfrmAlarms read FAlarmForm write FAlarmForm;
    property IsRunning: Boolean read FRunning;
    property OnRunningChanged: TNotifyEvent read FOnRunningChanged
      write FOnRunningChanged;
    property OnZPositionChanged: TZPositionChangedEvent read FOnZPositionChanged
      write FOnZPositionChanged;
  end;

implementation

{$R *.dfm}

procedure TfrmOperation.AddEvent(const AMessage: string);
begin
  QVIXLog('Operation', AMessage);
end;

procedure TfrmOperation.btnRunClick(Sender: TObject);
begin
  if FRunning then
    Exit;
  if Assigned(FAlarmForm) and FAlarmForm.IsRunBlocked then
  begin
    AddEvent('RUN blocked: reset the active alarm first');
    Exit;
  end;

  LoadActiveRecipe;
  FCurrentRunSeconds := 0;
  FAutoStageSeconds := 0;
  if rbAuto.Checked then
  begin
    FAutoStage := 'HOMING';
    AddEvent('AUTO sequence: HOME check started');
  end
  else
    FAutoStage := 'MANUAL';
  FRunning := True;
  AddEvent(lblModeValue.Caption + ' operation started');
  UpdateDisplay;
end;

procedure TfrmOperation.LoadActiveRecipe;
var
  Ini: TIniFile;
  Section: string;

  procedure AddGas(const AGas: string);
  begin
    if FRecipeGases <> '' then
      FRecipeGases := FRecipeGases + ', ';
    FRecipeGases := FRecipeGases + AGas;
  end;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.recipes.ini'));
  try
    FActiveRecipeName := Ini.ReadString('Active', 'Name', 'Default');
    Section := 'Recipe.' + FActiveRecipeName;
    FAutoOnSeconds := Ini.ReadInteger(Section, 'PlasmaOnSeconds', 10);
    FAutoOffSeconds := Ini.ReadInteger(Section, 'PlasmaOffSeconds', 0);
    FAutoTotalSeconds := Ini.ReadInteger(Section, 'AutoTotalSeconds', 60);
    FRecipePower := Ini.ReadFloat(Section, 'PowerW', 100);
    FRecipeProcessZ := Ini.ReadFloat(Section, 'ProcessZMm', 20);
    FRecipeMinimumWater := Ini.ReadInteger(Section,
      'MinimumWaterLevelPercent', FMinimumWaterLevel);
    FRecipeGases := '';
    if Ini.ReadBool(Section, 'GasH2', False) then AddGas('H2');
    if Ini.ReadBool(Section, 'GasN2', False) then AddGas('N2');
    if Ini.ReadBool(Section, 'GasAr', True) then AddGas('Ar');
    if Ini.ReadBool(Section, 'GasO2', False) then AddGas('O2');
  finally
    Ini.Free;
  end;
  if FAutoOnSeconds < 1 then
    FAutoOnSeconds := 1;
  if FAutoOffSeconds < 0 then
    FAutoOffSeconds := 0;
  if FAutoTotalSeconds < 1 then
    FAutoTotalSeconds := 1;
  if FRecipeGases = '' then
    FRecipeGases := 'Ar';
  if FRecipeMinimumWater < 0 then
    FRecipeMinimumWater := 0
  else if FRecipeMinimumWater > 100 then
    FRecipeMinimumWater := 100;
  UpdateSensorDisplay;
end;

procedure TfrmOperation.btnStopClick(Sender: TObject);
begin
  if not FRunning then
    Exit;

  FRunning := False;
  SaveRuntime;
  AddEvent('Operator STOP - plasma output OFF');
  UpdateDisplay;
end;

procedure TfrmOperation.btnSensorSimulationClick(Sender: TObject);
var
  SimulationForm: TfrmSensorSimulation;
begin
  SimulationForm := TfrmSensorSimulation.Create(Self);
  try
    if SimulationForm.Execute(FSensorNO3, FSensorNO2, FSensorEC,
      FSensorPH, FSensorTemperature, FSensorWaterLevel, FSensorTrend,
      FSensorNO3Online, FSensorNO2Online, FSensorECOnline, FSensorPHOnline,
      FSensorTemperatureOnline, FSensorWaterOnline) then
    begin
      AddEvent('Developer applied simulated sensor values');
      UpdateSensorDisplay;
    end;
  finally
    SimulationForm.Free;
  end;
end;

procedure TfrmOperation.ApplyAccessMode(const ADeveloperMode: Boolean);
begin
  btnSensorSimulation.Visible := ADeveloperMode;
  btnSensorSimulation.Enabled := ADeveloperMode and not FRunning;
end;

procedure TfrmOperation.ApplyCommunicationMode(
  const ACommunicationManager: TQVIXCommunicationManager;
  const ASimulationMode: Boolean);
begin
  FCommunicationManager := ACommunicationManager;
  FSimulationMode := ASimulationMode;
  FSensorTrend := ASimulationMode;
  if not Assigned(FCommunicationManager) then
    Exit;

  FCommunicationManager.WaterSensors.Close;
  FCommunicationManager.WaterSensors.OnSnapshot := nil;
  FCommunicationManager.WaterSensors.OnStatus := nil;
  if ASimulationMode then
  begin
    lblConnection.Caption := 'SIMULATION';
    lblConnection.Font.Color := clNavy;
    Exit;
  end;

  FSensorNO3Online := False;
  FSensorNO2Online := False;
  FSensorECOnline := False;
  FSensorEC2Online := False;
  FSensorORPOnline := False;
  FSensorPHOnline := False;
  FSensorTemperatureOnline := False;
  FCommunicationManager.WaterSensors.OnSnapshot := SensorSnapshot;
  FCommunicationManager.WaterSensors.OnStatus := SensorStatus;
  if not FCommunicationManager.WaterSensors.Open then
  begin
    lblConnection.Caption := FCommunicationManager.WaterSensors.LastMessage;
    lblConnection.Font.Color := clRed;
  end;
  UpdateSensorDisplay;
end;

procedure TfrmOperation.FormCreate(Sender: TObject);
begin
  grpSensors.Visible := False;
  tmrSensors.Enabled := False;
  FRunning := False;
  FSampleIndex := 0;
  FCurrentRunSeconds := 0;
  FSensorNO3 := 2.0;
  FSensorNO2 := 0.1;
  FSensorEC := 194;
  FSensorEC2 := 0;
  FSensorORP := 285;
  FSensorPH := 7.8;
  FSensorTemperature := 22;
  FSensorWaterLevel := 75;
  FSensorTrend := True;
  FDisplayedZ := 80.0;
  FSensorNO3Online := True;
  FSensorNO2Online := True;
  FSensorECOnline := True;
  FSensorEC2Online := True;
  FSensorORPOnline := True;
  FSensorPHOnline := True;
  FSensorTemperatureOnline := True;
  FSensorWaterOnline := True;
  LoadSafetySettings;
  LoadActiveRecipe;
  rbManual.Checked := True;
  AddEvent('Operation screen initialized - no hardware connection');
  UpdateDisplay;
end;

procedure TfrmOperation.FormDestroy(Sender: TObject);
begin
  if Assigned(FCommunicationManager) then
  begin
    FCommunicationManager.WaterSensors.OnSnapshot := nil;
    FCommunicationManager.WaterSensors.OnStatus := nil;
    FCommunicationManager.WaterSensors.Close;
  end;
  SaveRuntime;
end;

procedure TfrmOperation.SensorSnapshot(Sender: TObject;
  const ASnapshot: TQVIXIonSensorSnapshot);
begin
  if FSimulationMode then
    Exit;
  case ASnapshot.SlaveAddress of
    11:
      begin
        FSensorNO3 := ASnapshot.ConcentrationMgL;
        FSensorNO3Online := True;
      end;
    12:
      begin
        FSensorNO2 := ASnapshot.ConcentrationMgL;
        FSensorNO2Online := True;
        FSensorTemperature := ASnapshot.TemperatureC;
        FSensorTemperatureOnline := True;
      end;
    13:
      begin
        FSensorEC := ASnapshot.ConductivityUSCm;
        FSensorECOnline := True;
        FSensorTemperature := ASnapshot.TemperatureC;
        FSensorTemperatureOnline := True;
      end;
    14:
      begin
        FSensorEC2 := ASnapshot.ConductivityUSCm;
        FSensorEC2Online := True;
        FSensorTemperature := ASnapshot.TemperatureC;
        FSensorTemperatureOnline := True;
      end;
    15:
      begin
        FSensorORP := ASnapshot.ORPMillivolts;
        FSensorORPOnline := True;
        FSensorTemperature := ASnapshot.TemperatureC;
        FSensorTemperatureOnline := True;
      end;
  else
    Exit;
  end;
  lblConnection.Caption := Format(
    'WATER SENSOR: CONNECTED | COM%d | ID %d | DATA OK',
    [FCommunicationManager.WaterSensors.Config.PortNo,
     ASnapshot.SlaveAddress]);
  lblConnection.Font.Color := clGreen;
  if ASnapshot.SlaveAddress = 11 then
    QVIXLog('SENSOR', Format(
      'ID 11 applied to Operation: NO3=%.3f mg/L', [FSensorNO3]))
  else if ASnapshot.SlaveAddress = 12 then
    QVIXLog('SENSOR', Format(
      'ID 12 applied to Operation: NO2=%.3f mg/L, Temperature=%.1f C',
      [FSensorNO2, FSensorTemperature]))
  else if ASnapshot.SlaveAddress = 13 then
    QVIXLog('SENSOR', Format(
      'ID 13 applied to Operation: EC=%.1f uS/cm, Temperature=%.1f C',
      [FSensorEC, FSensorTemperature]))
  else if ASnapshot.SlaveAddress = 14 then
    QVIXLog('SENSOR', Format(
      'ID 14 applied to Operation: EC2=%.1f uS/cm, Temperature=%.1f C',
      [FSensorEC2, FSensorTemperature]))
  else
    QVIXLog('SENSOR', Format(
      'ID 15 applied to Operation: ORP=%.0f mV, Temperature=%.1f C',
      [FSensorORP, FSensorTemperature]));
end;

procedure TfrmOperation.SensorStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  QVIXLog('COMM', Format('[WaterSensors][STATE=%d] %s',
    [Ord(AState), AMessage]));
  case AState of
    qcsOpening:
      lblConnection.Caption := Format(
        'WATER SENSOR: CONNECTING | COM%d | ID 11',
        [FCommunicationManager.WaterSensors.Config.PortNo]);
    qcsOpen:
      lblConnection.Caption := Format(
        'WATER SENSOR: CONNECTED | COM%d | ID 11 | WAITING DATA',
        [FCommunicationManager.WaterSensors.Config.PortNo]);
    qcsError:
      lblConnection.Caption := 'WATER SENSOR: ERROR | ' + AMessage;
  else
    lblConnection.Caption := 'WATER SENSOR: DISCONNECTED';
  end;
  if AState = qcsOpen then
    lblConnection.Font.Color := clGreen
  else if AState = qcsError then
  begin
    lblConnection.Font.Color := clRed;
    FSensorNO3Online := False;
    FSensorTemperatureOnline := False;
  end
  else
    lblConnection.Font.Color := clWindowText;
end;

procedure TfrmOperation.HandleAlarm(Sender: TObject);
begin
  if not FRunning then
    Exit;
  FRunning := False;
  SaveRuntime;
  AddEvent('Operation stopped by alarm latch');
  UpdateDisplay;
end;

procedure TfrmOperation.HandleHomeRequest(Sender: TObject);
begin
  SetDisplayedZ(80.0);
  AddEvent('Z position synchronized to HOME after alarm return');
  UpdateDisplay;
end;

function TfrmOperation.FormatDuration(const ASeconds: Int64): string;
begin
  Result := Format('%.2d:%.2d:%.2d',
    [ASeconds div 3600, (ASeconds div 60) mod 60, ASeconds mod 60]);
end;

procedure TfrmOperation.LoadSafetySettings;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    FMinimumWaterLevel := Ini.ReadInteger('Safety',
      'MinimumWaterPercent', 20);
    FManualLimitSeconds := Ini.ReadInteger('Safety', 'ManualLimitSeconds', 300);
    FCumulativeRunSeconds := StrToInt64Def(
      Ini.ReadString('Runtime', 'PlasmaSeconds', '0'), 0);
    FUseSensorStops := Ini.ReadBool('Safety', 'UseSensorStops', True);
    FNO3Enabled := Ini.ReadBool('SensorRules', 'NO3Enabled', True);
    FNO3Operator := Ini.ReadInteger('SensorRules', 'NO3Operator', 0);
    FNO3Target := Ini.ReadFloat('SensorRules', 'NO3Target', 10);
    FNO2Enabled := Ini.ReadBool('SensorRules', 'NO2Enabled', False);
    FNO2Operator := Ini.ReadInteger('SensorRules', 'NO2Operator', 0);
    FNO2Target := Ini.ReadFloat('SensorRules', 'NO2Target', 1);
    FECEnabled := Ini.ReadBool('SensorRules', 'ECEnabled', True);
    FECOperator := Ini.ReadInteger('SensorRules', 'ECOperator', 0);
    FECTarget := Ini.ReadFloat('SensorRules', 'ECTarget', 500);
    FPHEnabled := Ini.ReadBool('SensorRules', 'PHEnabled', False);
    FPHOperator := Ini.ReadInteger('SensorRules', 'PHOperator', 1);
    FPHTarget := Ini.ReadFloat('SensorRules', 'PHTarget', 6.5);
    FTemperatureEnabled := Ini.ReadBool('SensorRules', 'TemperatureEnabled', True);
    FTemperatureOperator := Ini.ReadInteger('SensorRules', 'TemperatureOperator', 0);
    FTemperatureTarget := Ini.ReadFloat('SensorRules', 'TemperatureTarget', 35);
  finally
    Ini.Free;
  end;
  UpdateSensorDisplay;
end;

procedure TfrmOperation.SaveRuntime;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    Ini.WriteString('Runtime', 'PlasmaSeconds',
      IntToStr(FCumulativeRunSeconds));
  finally
    Ini.Free;
  end;
end;

procedure TfrmOperation.SetDisplayedZ(const APosition: Double);
begin
  if Abs(FDisplayedZ - APosition) < 0.001 then
    Exit;
  FDisplayedZ := APosition;
  if Assigned(FOnZPositionChanged) then
    FOnZPositionChanged(Self, FDisplayedZ);
end;

procedure TfrmOperation.ModeClick(Sender: TObject);
begin
  if FRunning then
  begin
    if lblModeValue.Caption = 'MANUAL' then
      rbManual.Checked := True
    else
      rbAuto.Checked := True;
    AddEvent('Mode change blocked while running');
    Exit;
  end;

  if rbAuto.Checked then
    AddEvent('Mode changed to AUTO')
  else
    AddEvent('Mode changed to MANUAL');
  UpdateDisplay;
end;

procedure TfrmOperation.ReloadSettings;
begin
  LoadSafetySettings;
  LoadActiveRecipe;
  AddEvent('Safety settings reloaded from Settings');
end;

procedure TfrmOperation.ResetCumulativeRuntime;
begin
  FCumulativeRunSeconds := 0;
  SaveRuntime;
  AddEvent('Cumulative plasma runtime reset by developer');
  UpdateDisplay;
end;

procedure TfrmOperation.tmrSensorsTimer(Sender: TObject);
var
  Snapshot: TQVIXIonSensorSnapshot;
  Online11: Boolean;
  Online12: Boolean;
  Online13: Boolean;
  Online14: Boolean;
  Online15: Boolean;
begin
  Inc(FSampleIndex);
  if not FSimulationMode and Assigned(FCommunicationManager) then
  begin
    Online11 := FCommunicationManager.WaterSensors.TryGetSnapshot(11,
      Snapshot);
    Online12 := FCommunicationManager.WaterSensors.TryGetSnapshot(12,
      Snapshot);
    Online13 := FCommunicationManager.WaterSensors.TryGetSnapshot(13,
      Snapshot);
    Online14 := FCommunicationManager.WaterSensors.TryGetSnapshot(14,
      Snapshot);
    Online15 := FCommunicationManager.WaterSensors.TryGetSnapshot(15,
      Snapshot);
    FSensorNO3Online := Online11;
    FSensorNO2Online := Online12;
    FSensorECOnline := Online13;
    FSensorEC2Online := Online14;
    FSensorORPOnline := Online15;
    FSensorTemperatureOnline := Online11 or Online12 or Online13 or
      Online14 or Online15;
    if FCommunicationManager.WaterSensors.State = qcsOpen then
    begin
      if FSensorTemperatureOnline then
        lblConnection.Font.Color := clGreen
      else
      begin
        lblConnection.Caption := Format(
          'WATER SENSOR: CONNECTED | COM%d | NO SENSOR RESPONSE',
          [FCommunicationManager.WaterSensors.Config.PortNo]);
        lblConnection.Font.Color := clRed;
      end;
    end;
  end;
  UpdateSensorDisplay;
end;

procedure TfrmOperation.tmrRuntimeTimer(Sender: TObject);
var
  CycleLength: Integer;
  CyclePosition: Integer;
  PlasmaIsOn: Boolean;
begin
  if not FRunning then
    Exit;

  if rbAuto.Checked and (FAutoStage = 'HOMING') then
  begin
    Inc(FAutoStageSeconds);
    if FAutoStageSeconds >= 2 then
    begin
      FAutoStage := 'POSITION';
      FAutoStageSeconds := 0;
      AddEvent('AUTO sequence: HOME confirmed, plasma ON and positioning');
    end;
    UpdateDisplay;
    Exit;
  end;

  if rbAuto.Checked and (FAutoStage = 'POSITION') then
  begin
    Inc(FAutoStageSeconds);
    Inc(FCumulativeRunSeconds);
    if FAutoStageSeconds >= 2 then
    begin
      FAutoStage := 'PROCESS';
      FAutoStageSeconds := 0;
      AddEvent('AUTO sequence: process Z reached, treatment timer started');
    end;
    UpdateDisplay;
    Exit;
  end;

  if rbAuto.Checked and (FAutoStage = 'RETURN') then
  begin
    Inc(FAutoStageSeconds);
    Inc(FCumulativeRunSeconds);
    if FAutoStageSeconds >= 2 then
    begin
      SetDisplayedZ(80.0);
      FRunning := False;
      FAutoStage := 'COMPLETE';
      SaveRuntime;
      AddEvent('AUTO sequence completed at HOME - plasma output OFF');
    end;
    UpdateDisplay;
    Exit;
  end;

  Inc(FCurrentRunSeconds);
  PlasmaIsOn := True;
  if rbAuto.Checked then
  begin
    CycleLength := FAutoOnSeconds + FAutoOffSeconds;
    if CycleLength > 0 then
    begin
      CyclePosition := (FCurrentRunSeconds - 1) mod CycleLength;
      PlasmaIsOn := CyclePosition < FAutoOnSeconds;
    end;
    if FCurrentRunSeconds >= FAutoTotalSeconds then
    begin
      FAutoStage := 'RETURN';
      FAutoStageSeconds := 0;
      PlasmaIsOn := True;
      AddEvent('AUTO treatment complete - returning HOME with plasma ON');
    end;
  end;
  if PlasmaIsOn then
    Inc(FCumulativeRunSeconds);
  if (FCurrentRunSeconds mod 10) = 0 then
    SaveRuntime;

  if FRunning and rbManual.Checked and
    (FCurrentRunSeconds >= FManualLimitSeconds) then
  begin
    FRunning := False;
    SaveRuntime;
    AddEvent('MANUAL RUN time limit reached - plasma output OFF');
  end;
  UpdateDisplay;
end;

procedure TfrmOperation.UpdateSensorDisplay;
var
  Nitrate: Double;
  Nitrite: Double;
  Conductivity: Double;
  PH: Double;
  Temperature: Double;
  WaterLevel: Double;
  StopReason: string;

  function RuleReached(const AValue, ATarget: Double;
    const AOperator: Integer): Boolean;
  begin
    if AOperator = 1 then
      Result := AValue <= ATarget
    else
      Result := AValue >= ATarget;
  end;
begin
  if FSensorTrend and FRunning then
  begin
    FSensorNO3 := 2.0 + 0.18 * Sin(FSampleIndex / 6);
    FSensorNO2 := 0.10 + 0.02 * Sin(FSampleIndex / 8);
    FSensorEC := 194 + 8 * Sin(FSampleIndex / 7);
    FSensorPH := 7.8 + 0.12 * Sin(FSampleIndex / 9);
    FSensorTemperature := 22.0 + 0.4 * Sin(FSampleIndex / 10);
    FSensorWaterLevel := 75.0 + 2.0 * Sin(FSampleIndex / 12);
  end;
  Nitrate := FSensorNO3;
  Nitrite := FSensorNO2;
  Conductivity := FSensorEC;
  PH := FSensorPH;
  Temperature := FSensorTemperature;
  WaterLevel := FSensorWaterLevel;

  lblNO3Value.Caption := FormatFloat('0.00', Nitrate) + ' mg/L';
  lblNO2Value.Caption := FormatFloat('0.00', Nitrite) + ' mg/L';
  lblECValue.Caption := FormatFloat('0', Conductivity) + ' uS/cm';
  lblEC2Value.Caption := FormatFloat('0.0', FSensorEC2) + ' uS/cm';
  lblORPValue.Caption := FormatFloat('0', FSensorORP) + ' mV';
  lblPHValue.Caption := FormatFloat('0.00', PH) + ' pH';
  lblTemperatureValue.Caption := FormatFloat('0.0', Temperature) + ' C';
  lblSensorWaterValue.Caption := FormatFloat('0', WaterLevel) + ' %';
  lblWaterValue.Caption := lblSensorWaterValue.Caption;
  if FUseSensorStops then
    lblSensorNote.Caption := Format('Sensor rules ON | Water safety >= %d%%',
      [FRecipeMinimumWater])
  else
    lblSensorNote.Caption := Format('Sensor rules bypassed | Water safety >= %d%%',
      [FRecipeMinimumWater]);

  lblNO3Value.Font.Color := clWindowText;
  lblNO2Value.Font.Color := clWindowText;
  lblECValue.Font.Color := clWindowText;
  lblEC2Value.Font.Color := clWindowText;
  lblORPValue.Font.Color := clWindowText;
  lblPHValue.Font.Color := clWindowText;
  lblTemperatureValue.Font.Color := clWindowText;
  StopReason := '';
  if not FSensorNO3Online then
  begin
    lblNO3Value.Caption := 'OFFLINE';
    lblNO3Value.Font.Color := clRed;
  end;
  if not FSensorNO2Online then
  begin
    lblNO2Value.Caption := 'OFFLINE';
    lblNO2Value.Font.Color := clRed;
  end;
  if not FSensorECOnline then
  begin
    lblECValue.Caption := 'OFFLINE';
    lblECValue.Font.Color := clRed;
  end;
  if not FSensorEC2Online then
  begin
    lblEC2Value.Caption := 'OFFLINE';
    lblEC2Value.Font.Color := clRed;
  end;
  if not FSensorORPOnline then
  begin
    lblORPValue.Caption := 'OFFLINE';
    lblORPValue.Font.Color := clRed;
  end;
  if not FSensorPHOnline then
  begin
    lblPHValue.Caption := 'OFFLINE';
    lblPHValue.Font.Color := clRed;
  end;
  if not FSensorTemperatureOnline then
  begin
    lblTemperatureValue.Caption := 'OFFLINE';
    lblTemperatureValue.Font.Color := clRed;
  end;
  if FUseSensorStops then
  begin
    if FNO3Enabled and not FSensorNO3Online then
    begin
      StopReason := 'NO3 sensor offline';
      lblNO3Value.Caption := 'OFFLINE';
      lblNO3Value.Font.Color := clRed;
    end
    else if FNO2Enabled and not FSensorNO2Online then
    begin
      StopReason := 'NO2 sensor offline';
      lblNO2Value.Caption := 'OFFLINE';
      lblNO2Value.Font.Color := clRed;
    end
    else if FECEnabled and not FSensorECOnline then
    begin
      StopReason := 'EC sensor offline';
      lblECValue.Caption := 'OFFLINE';
      lblECValue.Font.Color := clRed;
    end
    else if FPHEnabled and not FSensorPHOnline then
    begin
      StopReason := 'pH sensor offline';
      lblPHValue.Caption := 'OFFLINE';
      lblPHValue.Font.Color := clRed;
    end
    else if FTemperatureEnabled and not FSensorTemperatureOnline then
    begin
      StopReason := 'Temperature sensor offline';
      lblTemperatureValue.Caption := 'OFFLINE';
      lblTemperatureValue.Font.Color := clRed;
    end
    else if FNO3Enabled and RuleReached(Nitrate, FNO3Target, FNO3Operator) then
    begin
      StopReason := 'NO3 sensor stop condition';
      lblNO3Value.Font.Color := clRed;
    end
    else if FNO2Enabled and RuleReached(Nitrite, FNO2Target, FNO2Operator) then
    begin
      StopReason := 'NO2 sensor stop condition';
      lblNO2Value.Font.Color := clRed;
    end
    else if FECEnabled and RuleReached(Conductivity, FECTarget, FECOperator) then
    begin
      StopReason := 'EC sensor stop condition';
      lblECValue.Font.Color := clRed;
    end
    else if FPHEnabled and RuleReached(PH, FPHTarget, FPHOperator) then
    begin
      StopReason := 'pH sensor stop condition';
      lblPHValue.Font.Color := clRed;
    end
    else if FTemperatureEnabled and
      RuleReached(Temperature, FTemperatureTarget, FTemperatureOperator) then
    begin
      StopReason := 'Temperature sensor stop condition';
      lblTemperatureValue.Font.Color := clRed;
    end;
  end;

  if not FSensorWaterOnline then
  begin
    lblSensorWaterValue.Caption := 'OFFLINE';
    lblWaterValue.Caption := 'OFFLINE';
    lblSensorWaterValue.Font.Color := clRed;
    lblWaterValue.Font.Color := clRed;
    if StopReason = '' then
      StopReason := 'Water level sensor offline';
  end;

  if FSensorWaterOnline and (WaterLevel < FRecipeMinimumWater) then
  begin
    lblSensorWaterValue.Font.Color := clRed;
    lblWaterValue.Font.Color := clRed;
    if FRunning then
    begin
      FRunning := False;
      SaveRuntime;
      AddEvent('Safety stop: water level is below the configured minimum');
      if Assigned(FAlarmForm) then
        FAlarmForm.RaiseExternalAlarm(
          'Water level below active recipe safety limit', True);
      UpdateDisplay;
    end;
  end
  else if FSensorWaterOnline then
  begin
    lblSensorWaterValue.Font.Color := clGreen;
    lblWaterValue.Font.Color := clGreen;
  end;

  if FRunning and (StopReason <> '') then
  begin
    FRunning := False;
    SaveRuntime;
    AddEvent('Safety stop: ' + StopReason);
    if Assigned(FAlarmForm) then
      FAlarmForm.RaiseExternalAlarm(StopReason,
        Pos('Water level', StopReason) = 1);
    UpdateDisplay;
  end;
  if Assigned(FAlarmForm) and (StopReason = '') and FSensorWaterOnline and
    (WaterLevel >= FRecipeMinimumWater) then
    FAlarmForm.ClearExternalCondition;
end;

procedure TfrmOperation.UpdateDisplay;
var
  CycleLength: Integer;
begin
  if rbAuto.Checked then
    lblModeValue.Caption := 'AUTO'
  else
    lblModeValue.Caption := 'MANUAL';

  if FRunning then
  begin
    if rbAuto.Checked then
    begin
      if FAutoStage = 'HOMING' then
        lblPhaseValue.Caption := 'HOMING'
      else if FAutoStage = 'POSITION' then
        lblPhaseValue.Caption := 'POSITIONING'
      else if FAutoStage = 'RETURN' then
        lblPhaseValue.Caption := 'RETURN HOME'
      else
      begin
        CycleLength := FAutoOnSeconds + FAutoOffSeconds;
        if (FCurrentRunSeconds > 0) and (CycleLength > 0) and
          (((FCurrentRunSeconds - 1) mod CycleLength) >= FAutoOnSeconds) then
          lblPhaseValue.Caption := 'OFF DWELL'
        else
          lblPhaseValue.Caption := 'AUTO ON';
      end;
    end
    else
      lblPhaseValue.Caption := 'RUNNING';
    lblPhaseValue.Font.Color := clGreen;
    if (lblPhaseValue.Caption = 'OFF DWELL') or
      (lblPhaseValue.Caption = 'HOMING') then
    begin
      lblPlasmaValue.Caption := 'OFF';
      lblPlasmaValue.Font.Color := clGray;
    end
    else
    begin
      lblPlasmaValue.Caption := 'ON';
      lblPlasmaValue.Font.Color := clRed;
    end;
  end
  else
  begin
    lblPhaseValue.Caption := 'READY';
    lblPhaseValue.Font.Color := clNavy;
    lblPlasmaValue.Caption := 'OFF';
    lblPlasmaValue.Font.Color := clGray;
  end;

  rbManual.Enabled := not FRunning;
  rbAuto.Enabled := not FRunning;
  btnRun.Enabled := not FRunning;
  btnStop.Enabled := FRunning;
  btnSensorSimulation.Enabled := btnSensorSimulation.Visible and not FRunning;
  lblElapsedValue.Caption := FormatDuration(FCurrentRunSeconds);
  lblActiveRecipeValue.Caption := FActiveRecipeName;
  lblGasValue.Caption := FRecipeGases;
  lblPowerValue.Caption := FormatFloat('0', FRecipePower) + ' W';
  lblProcessZValue.Caption := FormatFloat('0.0', FRecipeProcessZ) + ' mm';
  if FRunning and rbAuto.Checked then
  begin
    if FAutoStage = 'HOMING' then
      SetDisplayedZ(80.0)
    else if FAutoStage = 'RETURN' then
    begin
      if FAutoStageSeconds >= 2 then
        SetDisplayedZ(80.0);
    end
    else
      SetDisplayedZ(FRecipeProcessZ);
  end;
  lblZValue.Caption := FormatFloat('0.0', FDisplayedZ) + ' mm';
  if rbAuto.Checked then
  begin
    lblManualLimitCaption.Caption := 'AUTO TOTAL';
    lblManualLimitValue.Caption := FormatDuration(FAutoTotalSeconds);
    lblControlNote.Caption := 'Active recipe: ' + FActiveRecipeName +
      Format(' | ON %ds / OFF %ds', [FAutoOnSeconds, FAutoOffSeconds]);
  end
  else
  begin
    lblManualLimitCaption.Caption := 'MANUAL LIMIT';
    lblManualLimitValue.Caption := FormatDuration(FManualLimitSeconds);
    if FSimulationMode then
      lblControlNote.Caption :=
        'Simulation only. RUN does not write to real equipment.'
    else
      lblControlNote.Caption := 'LIVE SENSOR: COM5 / ID 11';
  end;
  lblCumulativeValue.Caption := FormatDuration(FCumulativeRunSeconds);
  if Assigned(FOnRunningChanged) then
    FOnRunningChanged(Self);
end;

end.
