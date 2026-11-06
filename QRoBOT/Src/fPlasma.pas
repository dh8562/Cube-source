unit fPlasma;

interface

uses
  System.Classes, System.IniFiles, System.Math, System.SysUtils,
  Winapi.Windows,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  uCommBase, uCommPlasma, uLogger, uTouchInput;

type
  TfrmPlasma = class(TForm)
    lblTitle: TLabel;
    grpConnection: TGroupBox;
    lblConnectionStatus: TLabel;
    lblModel: TLabel;
    lblControlMode: TLabel;
    btnConnect: TButton;
    grpStatus: TGroupBox;
    lblOutputCaption: TLabel;
    lblOutputValue: TLabel;
    lblVoltageCaption: TLabel;
    lblVoltageValue: TLabel;
    lblCurrentCaption: TLabel;
    lblCurrentValue: TLabel;
    lblPowerCaption: TLabel;
    lblPowerValue: TLabel;
    lblFrequencyCaption: TLabel;
    lblFrequencyValue: TLabel;
    lblHeadSpeedCaption: TLabel;
    lblHeadSpeedValue: TLabel;
    lblPressureCaption: TLabel;
    lblPressureValue: TLabel;
    lblAlarmCaption: TLabel;
    lblAlarmValue: TLabel;
    grpControl: TGroupBox;
    btnOutputOn: TButton;
    btnOutputOff: TButton;
    grpRuntime: TGroupBox;
    lblRuntimeValue: TLabel;
    lblRuntimeUnit: TLabel;
    lblRuntimeNote: TLabel;
    grpDeviceSettings: TGroupBox;
    lblSetPowerCaption: TLabel;
    edtSetPower: TEdit;
    lblSetPowerUnit: TLabel;
    lblSetFrequencyCaption: TLabel;
    edtSetFrequency: TEdit;
    lblSetFrequencyUnit: TLabel;
    lblModeCaption: TLabel;
    cmbControlMode: TComboBox;
    btnApply: TButton;
    lblSettingsNote: TLabel;
    grpAlarmMonitor: TGroupBox;
    lblAlarmMonitor: TLabel;
    tmrStatus: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnOutputOnClick(Sender: TObject);
    procedure btnOutputOffClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure tmrStatusTimer(Sender: TObject);
  private
    FCommunication: TQVIXPlasmaComm;
    FSnapshot: TQVIXPlasmaSnapshot;
    FConnected: Boolean;
    FDeviceOnline: Boolean;
    FLastResponseTick: UInt64;
    FOutputOn: Boolean;
    FPortName: string;
    FBaudRate: string;
    FSetPower: Double;
    FSetFrequency: Double;
    FControlModeIndex: Integer;
    FActualPower: Double;
    FActualVoltage: Double;
    FActualCurrent: Double;
    FActualPressure: Double;
    FHeadSpeed: Integer;
    FSampleIndex: Integer;
    FRuntimeSeconds: Int64;
    FRuntimePulse: Integer;
    procedure AddLog(const AMessage: string);
    function AlarmText: string;
    procedure CommunicationSnapshot(Sender: TObject;
      const ASnapshot: TQVIXPlasmaSnapshot);
    procedure CommunicationStatus(Sender: TObject;
      const AState: TQVIXCommState; const AMessage: string);
    function FormatDuration(const ASeconds: Int64): string;
    procedure SaveRuntime;
    procedure SetDeviceOffline;
    function SettingsFileName: string;
    procedure UpdateDisplay;
    procedure SetCommunication(const AValue: TQVIXPlasmaComm);
  public
    procedure ReloadSettings;
    property Communication: TQVIXPlasmaComm read FCommunication
      write SetCommunication;
  end;

implementation

{$R *.dfm}

procedure TfrmPlasma.AddLog(const AMessage: string);
begin
  QVIXLog('Plasma', AMessage);
end;

function TfrmPlasma.AlarmText: string;
begin
  Result := '';
  if paOverCurrent in FSnapshot.Alarms then Result := Result + 'Overcurrent, ';
  if paOverTemperature in FSnapshot.Alarms then Result := Result + 'Over-temperature, ';
  if paOverVoltage in FSnapshot.Alarms then Result := Result + 'Overvoltage, ';
  if paUnderVoltage in FSnapshot.Alarms then Result := Result + 'Undervoltage, ';
  if paAirPressure in FSnapshot.Alarms then Result := Result + 'Air pressure, ';
  if paOpenCircuit in FSnapshot.Alarms then Result := Result + 'Open circuit, ';
  if paIGBT1OverCurrent in FSnapshot.Alarms then Result := Result + 'IGBT1 overcurrent, ';
  if paIGBT2OverCurrent in FSnapshot.Alarms then Result := Result + 'IGBT2 overcurrent, ';
  if paInverterOverCurrent in FSnapshot.Alarms then Result := Result + 'Inverter overcurrent, ';
  if paArcFailure in FSnapshot.Alarms then Result := Result + 'Arc failure, ';
  if paMotorStall in FSnapshot.Alarms then Result := Result + 'Motor stall, ';
  if Result = '' then
    Result := 'NORMAL'
  else
    Delete(Result, Length(Result) - 1, 2);
end;

procedure TfrmPlasma.btnApplyClick(Sender: TObject);
var
  NewPower: Double;
  Ini: TIniFile;
begin
  if (not TryStrToFloat(Trim(edtSetPower.Text), NewPower)) or
     (NewPower < 300) or (NewPower > 1000) then
  begin
    AddLog('Plasma setting rejected: power must be 300-1000 W');
    edtSetPower.SetFocus;
    Exit;
  end;
  FSetPower := NewPower;
  FControlModeIndex := cmbControlMode.ItemIndex;
  Ini := TIniFile.Create(SettingsFileName);
  try
    Ini.WriteFloat('Plasma', 'PowerW', FSetPower);
    Ini.WriteInteger('Plasma', 'ControlModeIndex', FControlModeIndex);
  finally
    Ini.Free;
  end;
  if Assigned(FCommunication) and (FCommunication.State = qcsOpen) and
     not FCommunication.SetPower(Round(FSetPower)) then
    AddLog('Power setpoint transmission failed')
  else
    AddLog(Format('Excitair-0219 power setting applied: %.0f W, %s',
      [FSetPower, cmbControlMode.Text]));
  UpdateDisplay;
end;

procedure TfrmPlasma.btnConnectClick(Sender: TObject);
begin
  if FOutputOn then
  begin
    AddLog('Disconnect blocked while plasma output is ON');
    Exit;
  end;
  if not Assigned(FCommunication) then
  begin
    AddLog('Plasma communication unit is not assigned');
    Exit;
  end;
  if FCommunication.State = qcsOpen then
    FCommunication.Close
  else if not FCommunication.Open then
    AddLog(Format('Plasma connection failed: %s',
      [FCommunication.LastMessage]));
  UpdateDisplay;
end;

procedure TfrmPlasma.btnOutputOffClick(Sender: TObject);
begin
  if not FOutputOn then
    Exit;
  if not Assigned(FCommunication) or not FCommunication.SetOutput(False) then
  begin
    AddLog('Plasma output OFF transmission failed');
    Exit;
  end;
  AddLog('Plasma output OFF requested');
  UpdateDisplay;
end;

procedure TfrmPlasma.btnOutputOnClick(Sender: TObject);
begin
  if not FConnected then
  begin
    AddLog('Plasma output ON rejected: PSU is disconnected');
    Exit;
  end;
  if FControlModeIndex <> 1 then
  begin
    AddLog('Plasma output ON rejected: select Remote control mode');
    Exit;
  end;
  if FOutputOn then
    Exit;
  if not Assigned(FCommunication) or not FCommunication.SetOutput(True) then
  begin
    AddLog('Plasma output ON transmission failed');
    Exit;
  end;
  AddLog(Format('Plasma output ON requested at %.0f W', [FSetPower]));
  UpdateDisplay;
end;

procedure TfrmPlasma.FormCreate(Sender: TObject);
begin
  EnableTouchKeyboards(Self);
  FConnected := False;
  FDeviceOnline := False;
  FLastResponseTick := 0;
  FOutputOn := False;
  FSampleIndex := 0;
  FRuntimePulse := 0;
  ReloadSettings;
  edtSetFrequency.ReadOnly := True;
  AddLog('Plasma screen initialized');
  UpdateDisplay;
end;

procedure TfrmPlasma.CommunicationSnapshot(Sender: TObject;
  const ASnapshot: TQVIXPlasmaSnapshot);
begin
  FSnapshot := ASnapshot;
  FDeviceOnline := True;
  FLastResponseTick := GetTickCount64;
  FOutputOn := ASnapshot.PowerOn or ASnapshot.Running;
  FActualPower := ASnapshot.OutputPowerW;
  FActualVoltage := ASnapshot.DCVoltageV;
  FActualCurrent := ASnapshot.DCCurrentA;
  FHeadSpeed := ASnapshot.MotorSpeedRPM;
  FSetFrequency := ASnapshot.FrequencyKHz;
  edtSetFrequency.Text := FormatFloat('0.0', FSetFrequency);
  UpdateDisplay;
end;

procedure TfrmPlasma.CommunicationStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  FConnected := AState = qcsOpen;
  if not FConnected then
    SetDeviceOffline;
  if AMessage <> '' then
    AddLog(AMessage);
  UpdateDisplay;
end;

procedure TfrmPlasma.ReloadSettings;
const
  BaudRates: array[0..4] of string = ('4800', '9600', '19200',
    '38400', '115200');
var
  Ini: TIniFile;
  Index: Integer;
begin
  Ini := TIniFile.Create(SettingsFileName);
  try
    Index := Ini.ReadInteger('Communication', 'PlasmaPortIndex', 5);
    if (Index < 0) or (Index > 8) then
      Index := 5;
    FPortName := 'COM' + IntToStr(Index + 1);
    Index := Ini.ReadInteger('Communication', 'PlasmaBaudIndex', 1);
    if (Index < Low(BaudRates)) or (Index > High(BaudRates)) then
      Index := 1;
    FBaudRate := BaudRates[Index];
    FSetPower := Ini.ReadFloat('Plasma', 'PowerW', 600);
    FSetFrequency := Ini.ReadFloat('Plasma', 'FrequencyKHz', 27.0);
    FControlModeIndex := Ini.ReadInteger('Plasma', 'ControlModeIndex', 1);
    FRuntimeSeconds := StrToInt64Def(
      Ini.ReadString('Runtime', 'PlasmaSeconds', '0'), 0);
  finally
    Ini.Free;
  end;
  if (FSetPower < 300) or (FSetPower > 1000) then
    FSetPower := 600;
  if (FSetFrequency < 25) or (FSetFrequency > 30) then
    FSetFrequency := 27.0;
  edtSetPower.Text := FormatFloat('0', FSetPower);
  edtSetFrequency.Text := FormatFloat('0.0', FSetFrequency);
  if (FControlModeIndex < 0) or
     (FControlModeIndex >= cmbControlMode.Items.Count) then
    FControlModeIndex := 1;
  cmbControlMode.ItemIndex := FControlModeIndex;
  AddLog('Plasma settings reloaded');
  UpdateDisplay;
end;

function TfrmPlasma.SettingsFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.settings.ini');
end;

function TfrmPlasma.FormatDuration(const ASeconds: Int64): string;
begin
  Result := Format('%.2d:%.2d:%.2d',
    [ASeconds div 3600, (ASeconds div 60) mod 60, ASeconds mod 60]);
end;

procedure TfrmPlasma.SaveRuntime;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(SettingsFileName);
  try
    Ini.WriteString('Runtime', 'PlasmaSeconds', IntToStr(FRuntimeSeconds));
  finally
    Ini.Free;
  end;
end;

procedure TfrmPlasma.tmrStatusTimer(Sender: TObject);
begin
  if FConnected and FDeviceOnline and
     (GetTickCount64 - FLastResponseTick > 3000) then
  begin
    SetDeviceOffline;
    AddLog('Plasma response timeout - device OFFLINE');
  end;
  if FConnected and FDeviceOnline and FOutputOn then
  begin
    Inc(FRuntimePulse);
    if FRuntimePulse >= 2 then
    begin
      FRuntimePulse := 0;
      Inc(FRuntimeSeconds);
      if (FRuntimeSeconds mod 10) = 0 then
        SaveRuntime;
    end;
  end
  else
    FRuntimePulse := 0;
  UpdateDisplay;
end;

procedure TfrmPlasma.SetDeviceOffline;
begin
  FDeviceOnline := False;
  FLastResponseTick := 0;
  FOutputOn := False;
  FActualPower := 0;
  FActualVoltage := 0;
  FActualCurrent := 0;
  FActualPressure := 0;
  FHeadSpeed := 0;
  FSetFrequency := 0;
  FSnapshot := Default(TQVIXPlasmaSnapshot);
end;

procedure TfrmPlasma.SetCommunication(const AValue: TQVIXPlasmaComm);
begin
  if FCommunication = AValue then
    Exit;
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := nil;
    FCommunication.OnSnapshot := nil;
  end;
  FCommunication := AValue;
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := CommunicationStatus;
    FCommunication.OnSnapshot := CommunicationSnapshot;
    FConnected := FCommunication.State = qcsOpen;
  end;
  UpdateDisplay;
end;

procedure TfrmPlasma.UpdateDisplay;
begin
  if FConnected and FDeviceOnline then
  begin
    lblConnectionStatus.Caption := 'CONNECTED';
    lblConnectionStatus.Font.Color := clGreen;
    btnConnect.Caption := 'Disconnect';
  end
  else if FConnected then
  begin
    lblConnectionStatus.Caption := 'OFFLINE';
    lblConnectionStatus.Font.Color := clRed;
    btnConnect.Caption := 'Disconnect';
  end
  else
  begin
    lblConnectionStatus.Caption := 'DISCONNECTED';
    lblConnectionStatus.Font.Color := clRed;
    btnConnect.Caption := 'Connect';
  end;

  if not FDeviceOnline then
  begin
    lblOutputValue.Caption := 'OFFLINE';
    lblOutputValue.Font.Color := clRed;
  end
  else if FOutputOn then
  begin
    lblOutputValue.Caption := 'ON';
    lblOutputValue.Font.Color := clRed;
  end
  else
  begin
    lblOutputValue.Caption := 'OFF';
    lblOutputValue.Font.Color := clGray;
  end;
  if FDeviceOnline then
  begin
    lblVoltageValue.Caption := FormatFloat('0.0', FActualVoltage) + ' V';
    lblCurrentValue.Caption := FormatFloat('0.00', FActualCurrent) + ' A';
    lblPowerValue.Caption := FormatFloat('0', FActualPower) + ' W';
    lblHeadSpeedValue.Caption := IntToStr(FHeadSpeed) + ' rpm';
    lblPressureValue.Caption := FormatFloat('0.000', FActualPressure) + ' MPa';
  end
  else
  begin
    lblVoltageValue.Caption := '-- V';
    lblCurrentValue.Caption := '-- A';
    lblPowerValue.Caption := '-- W';
    lblHeadSpeedValue.Caption := '-- rpm';
    lblPressureValue.Caption := '-- MPa';
  end;
  if FConnected and FDeviceOnline then
    lblFrequencyValue.Caption := FormatFloat('0.0', FSetFrequency) + ' kHz'
  else
    lblFrequencyValue.Caption := '-- kHz';
  lblModel.Caption := 'MODEL  Excitair-0219  |  RS-485 + Remote I/O';
  if FControlModeIndex = 1 then
    lblControlMode.Caption := 'CONTROL  REMOTE'
  else
    lblControlMode.Caption := 'CONTROL  LOCAL';
  lblRuntimeValue.Caption := FormatDuration(FRuntimeSeconds);
  if FDeviceOnline then
    lblAlarmValue.Caption := AlarmText
  else
    lblAlarmValue.Caption := 'OFFLINE';
  if not FDeviceOnline or FSnapshot.AlarmActive or
     (FSnapshot.Alarms <> []) then
    lblAlarmValue.Font.Color := clRed
  else
    lblAlarmValue.Font.Color := clGreen;
  lblAlarmMonitor.Caption := lblAlarmValue.Caption;
  btnOutputOn.Enabled := FConnected and FDeviceOnline and not FOutputOn;
  btnOutputOff.Enabled := FDeviceOnline and FOutputOn;
  btnApply.Enabled := FDeviceOnline and not FOutputOn;
end;

end.
