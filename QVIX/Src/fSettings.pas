unit fSettings;

interface

uses
  System.Classes, System.IniFiles, System.SysUtils, Vcl.ComCtrls, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, uCommBase,
  uCommunicationManager, uCommWaterSensors, uTouchInput;

type
  TfrmSettings = class(TForm)
    lblTitle: TLabel;
    pcSettings: TPageControl;
    tsGeneral: TTabSheet;
    tsZAxis: TTabSheet;
    tsQOLS: TTabSheet;
    tsSafety: TTabSheet;
    tsCommunication: TTabSheet;
    tsSensorRules: TTabSheet;
    tsAccess: TTabSheet;
    tsSensorTest: TTabSheet;
    chkSimulationMode: TCheckBox;
    lblGeneralNote: TLabel;
    lblRuntimeCaption: TLabel;
    lblRuntimeValue: TLabel;
    btnResetRuntime: TButton;
    lblZPort: TLabel;
    cmbZPort: TComboBox;
    lblZBaud: TLabel;
    cmbZBaud: TComboBox;
    lblZMin: TLabel;
    edtZMin: TEdit;
    lblZMax: TLabel;
    edtZMax: TEdit;
    lblZHome: TLabel;
    edtZHome: TEdit;
    lblZJog: TLabel;
    edtZJog: TEdit;
    lblZPulsesPerMm: TLabel;
    edtZPulsesPerMm: TEdit;
    lblQOLSPort: TLabel;
    cmbQOLSPort: TComboBox;
    lblQOLSBaud: TLabel;
    cmbQOLSBaud: TComboBox;
    lblQOLSKind: TLabel;
    cmbQOLSKind: TComboBox;
    lblExposure: TLabel;
    edtExposure: TEdit;
    lblReadTime: TLabel;
    edtReadTime: TEdit;
    lblWaveStart: TLabel;
    edtWaveStart: TEdit;
    lblWaveEnd: TLabel;
    edtWaveEnd: TEdit;
    lblIntensityMin: TLabel;
    edtIntensityMin: TEdit;
    lblIntensityMax: TLabel;
    edtIntensityMax: TEdit;
    lblPeakDevice: TLabel;
    cmbPeakDevice: TComboBox;
    btnPeakAdd: TButton;
    btnPeakEdit: TButton;
    btnPeakDelete: TButton;
    lvPeakList: TListView;
    chkUseSensorStops: TCheckBox;
    lblMinimumWater: TLabel;
    edtMinimumWater: TEdit;
    lblManualLimit: TLabel;
    edtManualLimit: TEdit;
    lblCommDevice: TLabel;
    lblCommPort: TLabel;
    lblCommBaud: TLabel;
    lblCommType: TLabel;
    lblWaterBus: TLabel;
    cmbWaterBusPort: TComboBox;
    cmbWaterBusBaud: TComboBox;
    lblWaterBusType: TLabel;
    lblLevelSensor: TLabel;
    cmbLevelPort: TComboBox;
    cmbLevelBaud: TComboBox;
    lblLevelType: TLabel;
    lblPlasmaPSU: TLabel;
    cmbPlasmaPort: TComboBox;
    cmbPlasmaBaud: TComboBox;
    lblPlasmaType: TLabel;
    lblRemoteIO: TLabel;
    cmbRemoteIOPort: TComboBox;
    lblRemoteIOType: TLabel;
    lblMFM: TLabel;
    cmbMFMPort: TComboBox;
    lblMFMType: TLabel;
    lblCommunicationNote: TLabel;
    chkNO3Rule: TCheckBox;
    cmbNO3Operator: TComboBox;
    edtNO3Target: TEdit;
    chkNO2Rule: TCheckBox;
    cmbNO2Operator: TComboBox;
    edtNO2Target: TEdit;
    chkECRule: TCheckBox;
    cmbECOperator: TComboBox;
    edtECTarget: TEdit;
    chkPHRule: TCheckBox;
    cmbPHOperator: TComboBox;
    edtPHTarget: TEdit;
    chkTemperatureRule: TCheckBox;
    cmbTemperatureOperator: TComboBox;
    edtTemperatureTarget: TEdit;
    lblRuleOperator: TLabel;
    lblRuleTarget: TLabel;
    lblRuleNote: TLabel;
    rbOperator: TRadioButton;
    rbDeveloper: TRadioButton;
    lblPassword: TLabel;
    edtPassword: TEdit;
    lblAccessNote: TLabel;
    lblMessage: TLabel;
    btnCancel: TButton;
    btnApply: TButton;
    lblSensorTestPort: TLabel;
    lblSensorTestSlave: TLabel;
    lblSensorTestFunction: TLabel;
    lblSensorTestAddress: TLabel;
    lblSensorTestQuantity: TLabel;
    lblSensorTestStatus: TLabel;
    cmbSensorTestPort: TComboBox;
    cmbSensorTestBaud: TComboBox;
    edtSensorTestSlave: TEdit;
    cmbSensorTestFunction: TComboBox;
    edtSensorTestAddress: TEdit;
    edtSensorTestQuantity: TEdit;
    btnSensorConnect: TButton;
    btnSensorDisconnect: TButton;
    memSensorTestResult: TMemo;
    procedure FormShow(Sender: TObject);
    procedure AccessClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnResetRuntimeClick(Sender: TObject);
    procedure btnSensorConnectClick(Sender: TObject);
    procedure btnSensorDisconnectClick(Sender: TObject);
    procedure btnPeakAddClick(Sender: TObject);
    procedure btnPeakEditClick(Sender: TObject);
    procedure btnPeakDeleteClick(Sender: TObject);
    procedure cmbPeakDeviceChange(Sender: TObject);
  private
    FDeveloperMode: Boolean;
    FSimulationMode: Boolean;
    FRuntimeReset: Boolean;
    FPeakDeviceIndex: Integer;
    FCommunicationManager: TQVIXCommunicationManager;
    function SettingsFileName: string;
    function FormatDuration(const ASeconds: Int64): string;
    procedure LoadSettings;
    procedure LoadPeakList;
    procedure SavePeakList;
    procedure SaveSettings;
    procedure UpdateAccessControls;
    function ValidateSettings(out AMessage: string): Boolean;
    procedure SensorData(Sender: TObject; const AData: TBytes);
    procedure SensorStatus(Sender: TObject; const AState: TQVIXCommState;
      const AMessage: string);
    procedure SensorSnapshot(Sender: TObject;
      const ASnapshot: TQVIXIonSensorSnapshot);
    procedure UpdateSensorTestButtons;
  public
    function Execute(var ADeveloperMode, ASimulationMode: Boolean): Boolean;
    property RuntimeReset: Boolean read FRuntimeReset;
    property CommunicationManager: TQVIXCommunicationManager
      read FCommunicationManager write FCommunicationManager;
  end;

implementation

uses
  fPeakDetectEdit;

{$R *.dfm}

const
  CTemporaryDeveloperPassword = '1234';

procedure TfrmSettings.AccessClick(Sender: TObject);
begin
  UpdateAccessControls;
end;

procedure TfrmSettings.btnApplyClick(Sender: TObject);
var
  MessageText: string;
begin
  if rbDeveloper.Checked and
     (edtPassword.Text <> CTemporaryDeveloperPassword) then
  begin
    lblMessage.Caption := 'Developer password is incorrect.';
    lblMessage.Font.Color := clRed;
    pcSettings.ActivePage := tsAccess;
    edtPassword.SetFocus;
    Exit;
  end;
  if not ValidateSettings(MessageText) then
  begin
    lblMessage.Caption := MessageText;
    lblMessage.Font.Color := clRed;
    Exit;
  end;

  FDeveloperMode := rbDeveloper.Checked;
  FSimulationMode := chkSimulationMode.Checked;
  SaveSettings;
  ModalResult := mrOk;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSettings.btnPeakAddClick(Sender: TObject);
var
  Dialog: TfrmPeakDetectEdit;
  Item: TListItem;
begin
  if lvPeakList.Items.Count >= 10 then
    Exit;
  Dialog := TfrmPeakDetectEdit.Create(Self);
  try
    if not Dialog.Execute('Add Peak Detect Item') then
      Exit;
    Item := lvPeakList.Items.Add;
    Item.Checked := Dialog.chkUse.Checked;
    Item.Caption := Dialog.edtName.Text;
    Item.SubItems.Add(Dialog.edtWaveStart.Text);
    Item.SubItems.Add(Dialog.edtWaveEnd.Text);
    Item.SubItems.Add(Dialog.edtIntensityMin.Text);
    Item.SubItems.Add(Dialog.edtIntensityMax.Text);
    Item.SubItems.Add(ColorToString(Dialog.cbGraphColor.Selected));
    Item.Data := Pointer(NativeInt(Dialog.cbGraphColor.Selected));
  finally
    Dialog.Free;
  end;
end;

procedure TfrmSettings.btnPeakDeleteClick(Sender: TObject);
begin
  if Assigned(lvPeakList.Selected) then
    lvPeakList.Selected.Delete;
end;

procedure TfrmSettings.btnPeakEditClick(Sender: TObject);
var
  Dialog: TfrmPeakDetectEdit;
  Item: TListItem;
begin
  Item := lvPeakList.Selected;
  if not Assigned(Item) then
    Exit;
  Dialog := TfrmPeakDetectEdit.Create(Self);
  try
    Dialog.chkUse.Checked := Item.Checked;
    Dialog.edtName.Text := Item.Caption;
    Dialog.edtWaveStart.Text := Item.SubItems[0];
    Dialog.edtWaveEnd.Text := Item.SubItems[1];
    Dialog.edtIntensityMin.Text := Item.SubItems[2];
    Dialog.edtIntensityMax.Text := Item.SubItems[3];
    Dialog.cbGraphColor.Selected := TColor(NativeInt(Item.Data));
    if not Dialog.Execute('Edit Peak Detect Item') then
      Exit;
    Item.Checked := Dialog.chkUse.Checked;
    Item.Caption := Dialog.edtName.Text;
    Item.SubItems[0] := Dialog.edtWaveStart.Text;
    Item.SubItems[1] := Dialog.edtWaveEnd.Text;
    Item.SubItems[2] := Dialog.edtIntensityMin.Text;
    Item.SubItems[3] := Dialog.edtIntensityMax.Text;
    Item.SubItems[4] := ColorToString(Dialog.cbGraphColor.Selected);
    Item.Data := Pointer(NativeInt(Dialog.cbGraphColor.Selected));
  finally
    Dialog.Free;
  end;
end;

procedure TfrmSettings.cmbPeakDeviceChange(Sender: TObject);
begin
  if FPeakDeviceIndex >= 0 then
    SavePeakList;
  FPeakDeviceIndex := cmbPeakDevice.ItemIndex;
  LoadPeakList;
end;

procedure TfrmSettings.btnResetRuntimeClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  if not FDeveloperMode then
    Exit;
  Ini := TIniFile.Create(SettingsFileName);
  try
    Ini.WriteString('Runtime', 'PlasmaSeconds', '0');
  finally
    Ini.Free;
  end;
  lblRuntimeValue.Caption := '00:00:00';
  FRuntimeReset := True;
  lblMessage.Caption := 'Cumulative plasma runtime was reset.';
  lblMessage.Font.Color := clGreen;
end;

procedure TfrmSettings.btnSensorConnectClick(Sender: TObject);
var
  Config: TQVIXCommConfig;
  Slave: Integer;
  Address: Integer;
  Quantity: Integer;
begin
  if not Assigned(FCommunicationManager) then
  begin
    lblSensorTestStatus.Caption := 'Communication manager is not assigned.';
    Exit;
  end;
  Slave := StrToIntDef(Trim(Copy(edtSensorTestSlave.Text, 1,
    Pos(',', edtSensorTestSlave.Text + ',') - 1)), 0);
  if (Slave < 1) or (Slave > 247) then
  begin
    lblSensorTestStatus.Caption :=
      'Enter Slave IDs from 1 to 247, separated by commas.';
    Exit;
  end;
  if not TryStrToInt(edtSensorTestAddress.Text, Address) or (Address < 0) or
     (Address > 65535) then
  begin
    lblSensorTestStatus.Caption := 'Register address must be 0 to 65535.';
    Exit;
  end;
  if not TryStrToInt(edtSensorTestQuantity.Text, Quantity) or (Quantity < 1) or
     (Quantity > 32) then
  begin
    lblSensorTestStatus.Caption := 'Register quantity must be 1 to 32.';
    Exit;
  end;

  FCommunicationManager.WaterSensors.Close;
  Config.PortNo := cmbSensorTestPort.ItemIndex + 1;
  Config.BaudRate := StrToIntDef(cmbSensorTestBaud.Text, 9600);
  Config.SlaveAddress := Slave;
  Config.TimeoutMs := 500;
  FCommunicationManager.WaterSensors.Configure(Config);
  if (cmbSensorTestFunction.ItemIndex = 0) and (Address = 0) and
     (Quantity = 5) then
    FCommunicationManager.WaterSensors.ConfigurePolling(
      edtSensorTestSlave.Text)
  else
    FCommunicationManager.WaterSensors.ConfigureTestRead(Slave,
      cmbSensorTestFunction.ItemIndex = 1, Address, Quantity);
  FCommunicationManager.WaterSensors.OnStatus := SensorStatus;
  FCommunicationManager.WaterSensors.OnData := SensorData;
  FCommunicationManager.WaterSensors.OnSnapshot := SensorSnapshot;
  memSensorTestResult.Clear;
  if not FCommunicationManager.WaterSensors.Open then
    lblSensorTestStatus.Caption :=
      FCommunicationManager.WaterSensors.LastMessage;
  UpdateSensorTestButtons;
end;

procedure TfrmSettings.btnSensorDisconnectClick(Sender: TObject);
begin
  if Assigned(FCommunicationManager) then
    FCommunicationManager.WaterSensors.Close;
  UpdateSensorTestButtons;
end;

function TfrmSettings.Execute(var ADeveloperMode,
  ASimulationMode: Boolean): Boolean;
begin
  EnableTouchKeyboards(Self);
  FRuntimeReset := False;
  FDeveloperMode := ADeveloperMode;
  FSimulationMode := ASimulationMode;
  Result := ShowModal = mrOk;
  if Result then
  begin
    ADeveloperMode := FDeveloperMode;
    ASimulationMode := FSimulationMode;
  end;
  if Assigned(FCommunicationManager) then
  begin
    FCommunicationManager.WaterSensors.Close;
    FCommunicationManager.WaterSensors.OnStatus := nil;
    FCommunicationManager.WaterSensors.OnData := nil;
    FCommunicationManager.WaterSensors.OnSnapshot := nil;
  end;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  LoadSettings;
  rbDeveloper.Checked := FDeveloperMode;
  rbOperator.Checked := not FDeveloperMode;
  chkSimulationMode.Checked := FSimulationMode;
  edtPassword.Clear;
  lblMessage.Caption := '';
  pcSettings.ActivePage := tsGeneral;
  UpdateAccessControls;
  cmbSensorTestPort.ItemIndex := cmbWaterBusPort.ItemIndex;
  cmbSensorTestBaud.ItemIndex := cmbWaterBusBaud.ItemIndex;
  UpdateSensorTestButtons;
end;

procedure TfrmSettings.SensorSnapshot(Sender: TObject;
  const ASnapshot: TQVIXIonSensorSnapshot);
begin
  memSensorTestResult.Lines.Add(Format(
    'ID=%d, Temperature=%.1f C, pX=%.3f, mV=%.1f, Concentration=%.3f mg/L',
    [ASnapshot.SlaveAddress, ASnapshot.TemperatureC, ASnapshot.PX, ASnapshot.Millivolts,
     ASnapshot.ConcentrationMgL]));
end;

procedure TfrmSettings.SensorData(Sender: TObject; const AData: TBytes);
var
  I: Integer;
  Line: string;
  Value: Word;
begin
  Line := 'RX:';
  for I := 0 to High(AData) do
    Line := Line + ' ' + IntToHex(AData[I], 2);
  memSensorTestResult.Lines.Add(Line);
  if (Length(AData) >= 5) and (AData[1] in [3, 4]) then
  begin
    Line := 'Registers:';
    I := 3;
    while I + 1 < Length(AData) - 2 do
    begin
      Value := (Word(AData[I]) shl 8) or AData[I + 1];
      Line := Line + Format('  R%d=%d (0x%.4x)',
        [(I - 3) div 2, Value, Value]);
      Inc(I, 2);
    end;
    memSensorTestResult.Lines.Add(Line);
  end;
  if memSensorTestResult.Lines.Count > 100 then
    memSensorTestResult.Lines.Delete(0);
end;

procedure TfrmSettings.SensorStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  lblSensorTestStatus.Caption := AMessage;
  if AState = qcsError then
    lblSensorTestStatus.Font.Color := clRed
  else if AState = qcsOpen then
    lblSensorTestStatus.Font.Color := clGreen
  else
    lblSensorTestStatus.Font.Color := clWindowText;
  UpdateSensorTestButtons;
end;

procedure TfrmSettings.UpdateSensorTestButtons;
var
  Connected: Boolean;
begin
  Connected := Assigned(FCommunicationManager) and
    (FCommunicationManager.WaterSensors.State = qcsOpen);
  btnSensorConnect.Enabled := not Connected;
  btnSensorDisconnect.Enabled := Connected;
end;

function TfrmSettings.FormatDuration(const ASeconds: Int64): string;
begin
  Result := Format('%.2d:%.2d:%.2d',
    [ASeconds div 3600, (ASeconds div 60) mod 60, ASeconds mod 60]);
end;

procedure TfrmSettings.LoadSettings;
var
  Ini: TIniFile;
  RuntimeSeconds: Int64;
begin
  Ini := TIniFile.Create(SettingsFileName);
  try
    FSimulationMode := Ini.ReadBool('General', 'SimulationMode',
      FSimulationMode);
    cmbZPort.ItemIndex := Ini.ReadInteger('ZAxis', 'PortIndex', 0);
    cmbZBaud.ItemIndex := Ini.ReadInteger('ZAxis', 'BaudIndex', 3);
    edtZMin.Text := Ini.ReadString('ZAxis', 'MinimumMm', '0.0');
    edtZMax.Text := Ini.ReadString('ZAxis', 'MaximumMm', '80.0');
    edtZHome.Text := Ini.ReadString('ZAxis', 'HomeMm', '80.0');
    edtZJog.Text := Ini.ReadString('ZAxis', 'JogStepMm', '1.0');
    edtZPulsesPerMm.Text := Ini.ReadString('ZAxis', 'PulsesPerMm', '1000');
    cmbQOLSPort.ItemIndex := Ini.ReadInteger('QOLS', 'PortIndex', 1);
    cmbQOLSBaud.ItemIndex := Ini.ReadInteger('QOLS', 'BaudIndex', 3);
    cmbQOLSKind.ItemIndex := Ini.ReadInteger('QOLS', 'KindIndex', 1);
    edtExposure.Text := Ini.ReadString('QOLS', 'ExposureMs', '10');
    edtReadTime.Text := Ini.ReadString('QOLS', 'ReadTimeMs', '100');
    edtWaveStart.Text := Ini.ReadString('QOLS', 'PeakStartNm', '760');
    edtWaveEnd.Text := Ini.ReadString('QOLS', 'PeakEndNm', '790');
    edtIntensityMin.Text := Ini.ReadString('QOLS', 'IntensityMin', '2000');
    edtIntensityMax.Text := Ini.ReadString('QOLS', 'IntensityMax', '8000');
    FPeakDeviceIndex := -1;
    cmbPeakDevice.ItemIndex := Ini.ReadInteger('QOLS',
      'SelectedSpectrometer', 1);
    if cmbPeakDevice.ItemIndex < 0 then
      cmbPeakDevice.ItemIndex := 0;
    chkUseSensorStops.Checked := Ini.ReadBool('Safety', 'UseSensorStops', True);
    edtMinimumWater.Text := Ini.ReadString('Safety', 'MinimumWaterPercent', '20');
    edtManualLimit.Text := Ini.ReadString('Safety', 'ManualLimitSeconds', '300');
    RuntimeSeconds := StrToInt64Def(
      Ini.ReadString('Runtime', 'PlasmaSeconds', '0'), 0);
    lblRuntimeValue.Caption := FormatDuration(RuntimeSeconds);
    cmbWaterBusPort.ItemIndex := Ini.ReadInteger('Communication', 'WaterBusPortIndex', 4);
    cmbWaterBusBaud.ItemIndex := Ini.ReadInteger('Communication', 'WaterBusBaudIndex', 1);
    edtSensorTestSlave.Text := Ini.ReadString('Communication',
      'WaterBusSlaveIDs', '11');
    cmbLevelPort.ItemIndex := Ini.ReadInteger('Communication', 'LevelPortIndex', 0);
    cmbLevelBaud.ItemIndex := Ini.ReadInteger('Communication', 'LevelBaudIndex', 1);
    cmbPlasmaPort.ItemIndex := Ini.ReadInteger('Communication', 'PlasmaPortIndex', 5);
    cmbPlasmaBaud.ItemIndex := Ini.ReadInteger('Communication', 'PlasmaBaudIndex', 1);
    cmbRemoteIOPort.ItemIndex := Ini.ReadInteger('Communication', 'RemoteIOPortIndex', 4);
    cmbMFMPort.ItemIndex := Ini.ReadInteger('Communication', 'MFMPortIndex', 0);
    chkNO3Rule.Checked := Ini.ReadBool('SensorRules', 'NO3Enabled', True);
    cmbNO3Operator.ItemIndex := Ini.ReadInteger('SensorRules', 'NO3Operator', 0);
    edtNO3Target.Text := Ini.ReadString('SensorRules', 'NO3Target', '10');
    chkNO2Rule.Checked := Ini.ReadBool('SensorRules', 'NO2Enabled', False);
    cmbNO2Operator.ItemIndex := Ini.ReadInteger('SensorRules', 'NO2Operator', 0);
    edtNO2Target.Text := Ini.ReadString('SensorRules', 'NO2Target', '1');
    chkECRule.Checked := Ini.ReadBool('SensorRules', 'ECEnabled', True);
    cmbECOperator.ItemIndex := Ini.ReadInteger('SensorRules', 'ECOperator', 0);
    edtECTarget.Text := Ini.ReadString('SensorRules', 'ECTarget', '500');
    chkPHRule.Checked := Ini.ReadBool('SensorRules', 'PHEnabled', False);
    cmbPHOperator.ItemIndex := Ini.ReadInteger('SensorRules', 'PHOperator', 1);
    edtPHTarget.Text := Ini.ReadString('SensorRules', 'PHTarget', '6.5');
    chkTemperatureRule.Checked := Ini.ReadBool('SensorRules', 'TemperatureEnabled', True);
    cmbTemperatureOperator.ItemIndex := Ini.ReadInteger('SensorRules', 'TemperatureOperator', 0);
    edtTemperatureTarget.Text := Ini.ReadString('SensorRules', 'TemperatureTarget', '35');
  finally
    Ini.Free;
  end;
  FPeakDeviceIndex := cmbPeakDevice.ItemIndex;
  LoadPeakList;
end;

procedure TfrmSettings.LoadPeakList;
var
  Ini: TIniFile;
  Count: Integer;
  I: Integer;
  Section: string;
  Item: TListItem;
  ColorValue: TColor;
begin
  lvPeakList.Items.BeginUpdate;
  try
    lvPeakList.Items.Clear;
    Ini := TIniFile.Create(SettingsFileName);
    try
      Count := Ini.ReadInteger(Format('QOLSPeakList%d',
        [FPeakDeviceIndex + 1]), 'Count', 0);
      if Count > 10 then
        Count := 10;
      for I := 0 to Count - 1 do
      begin
        Section := Format('QOLSPeak%d_%d', [FPeakDeviceIndex + 1, I]);
        Item := lvPeakList.Items.Add;
        Item.Checked := Ini.ReadBool(Section, 'Use', True);
        Item.Caption := Ini.ReadString(Section, 'Name',
          Format('Peak %d', [I + 1]));
        Item.SubItems.Add(Ini.ReadString(Section, 'StartWavelength', '400'));
        Item.SubItems.Add(Ini.ReadString(Section, 'EndWavelength', '500'));
        Item.SubItems.Add(Ini.ReadString(Section, 'MinIntensity', '10000'));
        Item.SubItems.Add(Ini.ReadString(Section, 'MaxIntensity', '30000'));
        ColorValue := TColor(Ini.ReadInteger(Section, 'Color', clYellow));
        Item.SubItems.Add(ColorToString(ColorValue));
        Item.Data := Pointer(NativeInt(ColorValue));
      end;
    finally
      Ini.Free;
    end;
  finally
    lvPeakList.Items.EndUpdate;
  end;
end;

procedure TfrmSettings.SavePeakList;
var
  Ini: TIniFile;
  I: Integer;
  Section: string;
  Item: TListItem;
begin
  if FPeakDeviceIndex < 0 then
    Exit;
  Ini := TIniFile.Create(SettingsFileName);
  try
    Ini.WriteInteger(Format('QOLSPeakList%d', [FPeakDeviceIndex + 1]),
      'Count', lvPeakList.Items.Count);
    for I := 0 to lvPeakList.Items.Count - 1 do
    begin
      Item := lvPeakList.Items[I];
      Section := Format('QOLSPeak%d_%d', [FPeakDeviceIndex + 1, I]);
      Ini.WriteBool(Section, 'Use', Item.Checked);
      Ini.WriteString(Section, 'Name', Item.Caption);
      Ini.WriteString(Section, 'StartWavelength', Item.SubItems[0]);
      Ini.WriteString(Section, 'EndWavelength', Item.SubItems[1]);
      Ini.WriteString(Section, 'MinIntensity', Item.SubItems[2]);
      Ini.WriteString(Section, 'MaxIntensity', Item.SubItems[3]);
      Ini.WriteInteger(Section, 'Color', NativeInt(Item.Data));
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmSettings.SaveSettings;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(SettingsFileName);
  try
    Ini.WriteBool('General', 'SimulationMode', FSimulationMode);
    Ini.WriteInteger('ZAxis', 'PortIndex', cmbZPort.ItemIndex);
    Ini.WriteInteger('ZAxis', 'BaudIndex', cmbZBaud.ItemIndex);
    Ini.WriteString('ZAxis', 'MinimumMm', edtZMin.Text);
    Ini.WriteString('ZAxis', 'MaximumMm', edtZMax.Text);
    Ini.WriteString('ZAxis', 'HomeMm', edtZHome.Text);
    Ini.WriteString('ZAxis', 'JogStepMm', edtZJog.Text);
    Ini.WriteString('ZAxis', 'PulsesPerMm', edtZPulsesPerMm.Text);
    Ini.WriteInteger('QOLS', 'PortIndex', cmbQOLSPort.ItemIndex);
    Ini.WriteInteger('QOLS', 'BaudIndex', cmbQOLSBaud.ItemIndex);
    Ini.WriteInteger('QOLS', 'KindIndex', cmbQOLSKind.ItemIndex);
    Ini.WriteString('QOLS', 'ExposureMs', edtExposure.Text);
    Ini.WriteString('QOLS', 'ReadTimeMs', edtReadTime.Text);
    Ini.WriteString('QOLS', 'PeakStartNm', edtWaveStart.Text);
    Ini.WriteString('QOLS', 'PeakEndNm', edtWaveEnd.Text);
    Ini.WriteString('QOLS', 'IntensityMin', edtIntensityMin.Text);
    Ini.WriteString('QOLS', 'IntensityMax', edtIntensityMax.Text);
    Ini.WriteInteger('QOLS', 'SelectedSpectrometer', cmbPeakDevice.ItemIndex);
    Ini.WriteBool('Safety', 'UseSensorStops', chkUseSensorStops.Checked);
    Ini.WriteString('Safety', 'MinimumWaterPercent', edtMinimumWater.Text);
    Ini.WriteString('Safety', 'ManualLimitSeconds', edtManualLimit.Text);
    Ini.WriteInteger('Communication', 'WaterBusPortIndex', cmbWaterBusPort.ItemIndex);
    Ini.WriteInteger('Communication', 'WaterBusBaudIndex', cmbWaterBusBaud.ItemIndex);
    Ini.WriteInteger('Communication', 'WaterBusSlaveAddress',
      StrToIntDef(Trim(Copy(edtSensorTestSlave.Text, 1,
        Pos(',', edtSensorTestSlave.Text + ',') - 1)), 11));
    Ini.WriteString('Communication', 'WaterBusSlaveIDs',
      edtSensorTestSlave.Text);
    Ini.WriteInteger('Communication', 'LevelPortIndex', cmbLevelPort.ItemIndex);
    Ini.WriteInteger('Communication', 'LevelBaudIndex', cmbLevelBaud.ItemIndex);
    Ini.WriteInteger('Communication', 'PlasmaPortIndex', cmbPlasmaPort.ItemIndex);
    Ini.WriteInteger('Communication', 'PlasmaBaudIndex', cmbPlasmaBaud.ItemIndex);
    Ini.WriteInteger('Communication', 'RemoteIOPortIndex', cmbRemoteIOPort.ItemIndex);
    Ini.WriteInteger('Communication', 'MFMPortIndex', cmbMFMPort.ItemIndex);
    Ini.WriteBool('SensorRules', 'NO3Enabled', chkNO3Rule.Checked);
    Ini.WriteInteger('SensorRules', 'NO3Operator', cmbNO3Operator.ItemIndex);
    Ini.WriteString('SensorRules', 'NO3Target', edtNO3Target.Text);
    Ini.WriteBool('SensorRules', 'NO2Enabled', chkNO2Rule.Checked);
    Ini.WriteInteger('SensorRules', 'NO2Operator', cmbNO2Operator.ItemIndex);
    Ini.WriteString('SensorRules', 'NO2Target', edtNO2Target.Text);
    Ini.WriteBool('SensorRules', 'ECEnabled', chkECRule.Checked);
    Ini.WriteInteger('SensorRules', 'ECOperator', cmbECOperator.ItemIndex);
    Ini.WriteString('SensorRules', 'ECTarget', edtECTarget.Text);
    Ini.WriteBool('SensorRules', 'PHEnabled', chkPHRule.Checked);
    Ini.WriteInteger('SensorRules', 'PHOperator', cmbPHOperator.ItemIndex);
    Ini.WriteString('SensorRules', 'PHTarget', edtPHTarget.Text);
    Ini.WriteBool('SensorRules', 'TemperatureEnabled', chkTemperatureRule.Checked);
    Ini.WriteInteger('SensorRules', 'TemperatureOperator', cmbTemperatureOperator.ItemIndex);
    Ini.WriteString('SensorRules', 'TemperatureTarget', edtTemperatureTarget.Text);
  finally
    Ini.Free;
  end;
  SavePeakList;
end;

function TfrmSettings.SettingsFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.settings.ini');
end;

procedure TfrmSettings.UpdateAccessControls;
begin
  edtPassword.Enabled := rbDeveloper.Checked;
  lblPassword.Enabled := rbDeveloper.Checked;
  btnResetRuntime.Enabled := FDeveloperMode;
end;

function TfrmSettings.ValidateSettings(out AMessage: string): Boolean;
var
  D1, D2, D3: Double;
  N1, N2: Integer;
begin
  Result := False;
  if (not TryStrToFloat(edtZMin.Text, D1)) or
     (not TryStrToFloat(edtZMax.Text, D2)) or
     (not TryStrToFloat(edtZHome.Text, D3)) or
     (D1 < 0) or (D2 <= D1) or (D3 < D1) or (D3 > D2) then
    AMessage := 'Check the Z axis minimum, maximum and HOME positions.'
  else if (not TryStrToFloat(edtZJog.Text, D1)) or (D1 <= 0) then
    AMessage := 'Z axis JOG step must be greater than zero.'
  else if (not TryStrToFloat(edtZPulsesPerMm.Text, D1)) or (D1 <= 0) then
    AMessage := 'Z axis pulses per mm must be greater than zero.'
  else if (not TryStrToInt(edtExposure.Text, N1)) or (N1 <= 0) or
          (not TryStrToInt(edtReadTime.Text, N2)) or (N2 < 50) then
    AMessage := 'Q-OLS exposure and read time settings are invalid.'
  else if (not TryStrToInt(edtWaveStart.Text, N1)) or
          (not TryStrToInt(edtWaveEnd.Text, N2)) or
          (N1 < 340) or (N2 <= N1) then
    AMessage := 'Q-OLS peak wavelength range is invalid.'
  else if (not TryStrToFloat(edtIntensityMin.Text, D1)) or
          (not TryStrToFloat(edtIntensityMax.Text, D2)) or
          (D1 < 0) or (D2 <= D1) then
    AMessage := 'Q-OLS intensity limits are invalid.'
  else if (not TryStrToInt(edtMinimumWater.Text, N1)) or
          (N1 < 0) or (N1 > 100) then
    AMessage := 'Minimum water level must be between 0 and 100%.'
  else if (not TryStrToInt(edtManualLimit.Text, N1)) or
          (N1 < 1) or (N1 > 86400) then
    AMessage := 'MANUAL RUN limit must be 1 to 86400 seconds.'
  else if (not TryStrToFloat(edtNO3Target.Text, D1)) or (D1 < 0) or
          (not TryStrToFloat(edtNO2Target.Text, D1)) or (D1 < 0) or
          (not TryStrToFloat(edtECTarget.Text, D1)) or (D1 < 0) or
          (not TryStrToFloat(edtPHTarget.Text, D1)) or (D1 < 0) or (D1 > 14) or
          (not TryStrToFloat(edtTemperatureTarget.Text, D1)) or
          (D1 < 0) or (D1 > 100) then
    AMessage := 'Check the sensor stop target values.'
  else
  begin
    AMessage := '';
    Result := True;
  end;
end;

end.
