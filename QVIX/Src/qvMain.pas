unit qvMain;

interface

uses
  System.Classes,
  System.IniFiles,
  System.SysUtils,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  fOperation,
  fSensors,
  fZMotion,
  fSpectrometer,
  fPlasma,
  fRecipes,
  fAlarms,
  fLogs,
  fSettings,
  uCommBase,
  uCommunicationManager;

type
  TfrmMain = class(TForm)
    panHeader: TPanel;
    lblTitle: TLabel;
    panNavigation: TPanel;
    btnOperation: TButton;
    btnSensors: TButton;
    btnZMotion: TButton;
    btnSpectrometer: TButton;
    btnPlasma: TButton;
    btnRecipes: TButton;
    btnAlarms: TButton;
    btnLogs: TButton;
    lblAccessMode: TLabel;
    btnSettings: TButton;
    btnAlarmStatus: TButton;
    panWorkspace: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavigationClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnAlarmStatusClick(Sender: TObject);
  private
    FActiveScreen: TForm;
    FOperationForm: TfrmOperation;
    FSensorsForm: TfrmSensors;
    FZMotionForm: TfrmZMotion;
    FSpectrometerForm: TfrmSpectrometer;
    FPlasmaForm: TfrmPlasma;
    FRecipesForm: TfrmRecipes;
    FAlarmsForm: TfrmAlarms;
    FLogsForm: TfrmLogs;
    FDeveloperMode: Boolean;
    FSimulationMode: Boolean;
    FCommunicationStarted: Boolean;
    FCommunicationManager: TQVIXCommunicationManager;
    procedure ShowScreen(const AScreen: TForm);
    procedure UpdateAccessDisplay;
    procedure AlarmStateChanged(Sender: TObject);
    procedure OperationRunningChanged(Sender: TObject);
    procedure OperationZPositionChanged(Sender: TObject;
      const APosition: Double);
    procedure AlarmHomeRequested(Sender: TObject);
    procedure StartPlasmaCommunication;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  FDeveloperMode := False;
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    FSimulationMode := Ini.ReadBool('General', 'SimulationMode', False);
  finally
    Ini.Free;
  end;
  FCommunicationManager := TQVIXCommunicationManager.Create(Self);
  FCommunicationStarted := False;
  FLogsForm := TfrmLogs.Create(Self);
  FOperationForm := TfrmOperation.Create(Self);
  FSensorsForm := TfrmSensors.Create(Self);
  FSensorsForm.CommunicationManager := FCommunicationManager;
  FZMotionForm := TfrmZMotion.Create(Self);
  FZMotionForm.Communication := FCommunicationManager.ZMotion;
  FSpectrometerForm := TfrmSpectrometer.Create(Self);
  FSpectrometerForm.Communication := FCommunicationManager.Spectrometer;
  FPlasmaForm := TfrmPlasma.Create(Self);
  FPlasmaForm.Communication := FCommunicationManager.Plasma;
  FRecipesForm := TfrmRecipes.Create(Self);
  FAlarmsForm := TfrmAlarms.Create(Self);
  FOperationForm.AlarmForm := FAlarmsForm;
  FSpectrometerForm.AlarmForm := FAlarmsForm;
  FZMotionForm.AlarmForm := FAlarmsForm;
  FAlarmsForm.OnAlarm := FOperationForm.HandleAlarm;
  FAlarmsForm.OnHomeRequest := AlarmHomeRequested;
  FAlarmsForm.OnStateChanged := AlarmStateChanged;
  FOperationForm.OnRunningChanged := OperationRunningChanged;
  FOperationForm.OnZPositionChanged := OperationZPositionChanged;
  FAlarmsForm.ApplyAccessMode(FDeveloperMode);
  FOperationForm.ApplyAccessMode(FDeveloperMode);
  AlarmStateChanged(FAlarmsForm);
  OperationRunningChanged(FOperationForm);
  UpdateAccessDisplay;
  ShowScreen(FOperationForm);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if FCommunicationStarted then
    Exit;
  FCommunicationStarted := True;

  { Start hardware polling only after the main form and every child form
    have completed construction.  A sensor can answer immediately after
    the COM port opens, so starting earlier can call a screen event while
    the remaining forms are still being initialized. }
  FOperationForm.ApplyCommunicationMode(FCommunicationManager,
    FSimulationMode);
  StartPlasmaCommunication;
end;

procedure TfrmMain.StartPlasmaCommunication;
begin
  if FSimulationMode or not Assigned(FCommunicationManager) then
    Exit;
  if FCommunicationManager.Plasma.State = qcsOpen then
    Exit;
  FCommunicationManager.Plasma.Open;
end;

procedure TfrmMain.AlarmStateChanged(Sender: TObject);
begin
  btnAlarmStatus.Caption := FAlarmsForm.AlarmSummary;
  if FAlarmsForm.IsRunBlocked then
  begin
    btnAlarmStatus.Font.Color := clRed;
    btnAlarmStatus.Font.Style := [fsBold];
  end
  else
  begin
    btnAlarmStatus.Font.Color := clGreen;
    btnAlarmStatus.Font.Style := [fsBold];
  end;
end;

procedure TfrmMain.AlarmHomeRequested(Sender: TObject);
begin
  FZMotionForm.HandleHomeRequest(Sender);
  FOperationForm.HandleHomeRequest(Sender);
end;

procedure TfrmMain.btnAlarmStatusClick(Sender: TObject);
begin
  ShowScreen(FAlarmsForm);
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
  SettingsForm: TfrmSettings;
  SettingsApplied: Boolean;
begin
  SettingsForm := TfrmSettings.Create(Self);
  try
    SettingsForm.CommunicationManager := FCommunicationManager;
    SettingsApplied := SettingsForm.Execute(FDeveloperMode, FSimulationMode);
    if SettingsForm.RuntimeReset then
      FOperationForm.ResetCumulativeRuntime;
    if SettingsApplied then
    begin
      FOperationForm.ReloadSettings;
      FZMotionForm.ReloadSettings;
      FSpectrometerForm.ReloadSettings;
      FPlasmaForm.ReloadSettings;
      FCommunicationManager.Plasma.Close;
      FCommunicationManager.Spectrometer.Close;
      FCommunicationManager.ZMotion.Close;
      FCommunicationManager.LoadSettings;
      FOperationForm.ApplyCommunicationMode(FCommunicationManager,
        FSimulationMode);
      StartPlasmaCommunication;
      FAlarmsForm.ApplyAccessMode(FDeveloperMode);
      FOperationForm.ApplyAccessMode(FDeveloperMode);
      UpdateAccessDisplay;
    end;
  finally
    SettingsForm.Free;
  end;
  if not SettingsApplied then
    FOperationForm.ApplyCommunicationMode(FCommunicationManager,
      FSimulationMode);
end;

procedure TfrmMain.OperationRunningChanged(Sender: TObject);
begin
  btnSettings.Enabled := not FOperationForm.IsRunning;
  btnRecipes.Enabled := not FOperationForm.IsRunning;
  btnZMotion.Enabled := not FOperationForm.IsRunning;
end;

procedure TfrmMain.OperationZPositionChanged(Sender: TObject;
  const APosition: Double);
begin
  FZMotionForm.MoveToPosition(APosition);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FCommunicationManager.CloseAll;
  FActiveScreen := nil;
end;

procedure TfrmMain.NavigationClick(Sender: TObject);
begin
  if Sender = btnOperation then
    ShowScreen(FOperationForm)
  else if Sender = btnSensors then
    ShowScreen(FSensorsForm)
  else if Sender = btnZMotion then
    ShowScreen(FZMotionForm)
  else if Sender = btnSpectrometer then
    ShowScreen(FSpectrometerForm)
  else if Sender = btnPlasma then
    ShowScreen(FPlasmaForm)
  else if Sender = btnRecipes then
    ShowScreen(FRecipesForm)
  else if Sender = btnAlarms then
    ShowScreen(FAlarmsForm)
  else if Sender = btnLogs then
    ShowScreen(FLogsForm);
end;

procedure TfrmMain.ShowScreen(const AScreen: TForm);
begin
  if FActiveScreen = AScreen then
    Exit;

  if Assigned(FActiveScreen) then
    FActiveScreen.Hide;

  FActiveScreen := AScreen;
  FActiveScreen.BorderStyle := bsNone;
  FActiveScreen.Parent := panWorkspace;
  FActiveScreen.Align := alClient;
  FActiveScreen.Show;
end;

procedure TfrmMain.UpdateAccessDisplay;
var
  AccessText: string;
begin
  if FDeveloperMode then
    AccessText := 'DEVELOPER'
  else
    AccessText := 'OPERATOR';
  if FSimulationMode then
    AccessText := AccessText + '  |  SIMULATION';
  lblAccessMode.Caption := AccessText;
end;

end.
