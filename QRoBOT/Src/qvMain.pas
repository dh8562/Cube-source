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
  fStage,
  fSpectrometer,
  fPlasma,
  fRecipes,
  fAlarms,
  fLogs,
  fSettings,
  uCommBase,
  uCommStageController,
  uCommunicationManager;

type
  TfrmMain = class(TForm)
    panHeader: TPanel;
    lblTitle: TLabel;
    panNavigation: TPanel;
    btnOperation: TButton;
    btnStage: TButton;
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
    FStageForm: TfrmStage;
    FSpectrometerForm: TfrmSpectrometer;
    FPlasmaForm: TfrmPlasma;
    FRecipesForm: TfrmRecipes;
    FAlarmsForm: TfrmAlarms;
    FLogsForm: TfrmLogs;
    FDeveloperMode: Boolean;
    FSimulationMode: Boolean;
    FCommunicationStarted: Boolean;
    FCommunicationManager: TQVIXCommunicationManager;
    FStageCommunication: TQRoBOTStageComm;
    FStagePollTimer: TTimer;
    procedure ShowScreen(const AScreen: TForm);
    procedure UpdateAccessDisplay;
    procedure AlarmStateChanged(Sender: TObject);
    procedure OperationRunningChanged(Sender: TObject);
    procedure AlarmHomeRequested(Sender: TObject);
    procedure StartPlasmaCommunication;
    procedure StageConnectRequest(Sender: TObject);
    procedure StageConnectionStatus(Sender: TObject;
      const AState: TQVIXCommState; const AMessage: string);
    procedure StageHomeRequest(Sender: TObject);
    procedure StagePollTimer(Sender: TObject);
    procedure StageStartRequest(Sender: TObject; const ARecipeNo: Integer);
    procedure StageStatus(Sender: TObject; const AX, AY, AZ: Double;
      const ARunning, AHomed, AComplete: Boolean;
      const AErrorCode, AMessage: string);
    procedure StageStopRequest(Sender: TObject);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  StageConfig: TQVIXCommConfig;
begin
  FDeveloperMode := False;
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    FSimulationMode := Ini.ReadBool('General', 'SimulationMode', False);
    StageConfig.PortNo := Ini.ReadInteger('Stage', 'PortNo', 1);
    StageConfig.BaudRate := Ini.ReadInteger('Stage', 'BaudRate', 115200);
    StageConfig.SlaveAddress := 1;
    StageConfig.TimeoutMs := Ini.ReadInteger('Stage', 'TimeoutMs', 500);
  finally
    Ini.Free;
  end;
  FCommunicationManager := TQVIXCommunicationManager.Create(Self);
  FCommunicationStarted := False;
  FLogsForm := TfrmLogs.Create(Self);
  FOperationForm := TfrmOperation.Create(Self);
  FStageForm := TfrmStage.Create(Self);
  FStageCommunication := TQRoBOTStageComm.Create(Self);
  FStageCommunication.Configure(StageConfig);
  FStageCommunication.OnStatus := StageConnectionStatus;
  FStageCommunication.OnStageStatus := StageStatus;
  FStageForm.OnConnect := StageConnectRequest;
  FStageForm.OnHome := StageHomeRequest;
  FStageForm.OnStartRecipe := StageStartRequest;
  FStageForm.OnStop := StageStopRequest;
  FStagePollTimer := TTimer.Create(Self);
  FStagePollTimer.Enabled := False;
  FStagePollTimer.Interval := 500;
  FStagePollTimer.OnTimer := StagePollTimer;
  FSpectrometerForm := TfrmSpectrometer.Create(Self);
  FSpectrometerForm.Communication := FCommunicationManager.Spectrometer;
  FPlasmaForm := TfrmPlasma.Create(Self);
  FPlasmaForm.Communication := FCommunicationManager.Plasma;
  FRecipesForm := TfrmRecipes.Create(Self);
  FAlarmsForm := TfrmAlarms.Create(Self);
  FOperationForm.AlarmForm := FAlarmsForm;
  FSpectrometerForm.AlarmForm := FAlarmsForm;
  FStageForm.AlarmForm := FAlarmsForm;
  FAlarmsForm.OnAlarm := FOperationForm.HandleAlarm;
  FAlarmsForm.OnHomeRequest := AlarmHomeRequested;
  FAlarmsForm.OnStateChanged := AlarmStateChanged;
  FOperationForm.OnRunningChanged := OperationRunningChanged;
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
  StartPlasmaCommunication;
  FStageForm.RequestConnect;
end;

procedure TfrmMain.StartPlasmaCommunication;
begin
  if FSimulationMode or not Assigned(FCommunicationManager) then
    Exit;
  if FCommunicationManager.Plasma.State = qcsOpen then
    Exit;
  FCommunicationManager.Plasma.Open;
end;

procedure TfrmMain.StageConnectionStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  FStageForm.SetConnectionState(AState = qcsOpen, AMessage);
  FStagePollTimer.Enabled := AState = qcsOpen;
end;

procedure TfrmMain.StageConnectRequest(Sender: TObject);
begin
  if FStageCommunication.State = qcsOpen then
    FStageCommunication.Close
  else
    FStageCommunication.Open;
end;

procedure TfrmMain.StageHomeRequest(Sender: TObject);
begin
  FStageCommunication.HomeAll;
end;

procedure TfrmMain.StagePollTimer(Sender: TObject);
begin
  if FStageCommunication.State = qcsOpen then
    FStageCommunication.QueryCoordinates;
end;

procedure TfrmMain.StageStartRequest(Sender: TObject;
  const ARecipeNo: Integer);
begin
  FStageCommunication.StartCurrentRecipe;
end;

procedure TfrmMain.StageStatus(Sender: TObject; const AX, AY, AZ: Double;
  const ARunning, AHomed, AComplete: Boolean;
  const AErrorCode, AMessage: string);
begin
  FStageForm.SetPosition(AX, AY, AZ);
  FStageForm.SetStageStatus(ARunning, AHomed, AComplete, AErrorCode,
    AMessage);
end;

procedure TfrmMain.StageStopRequest(Sender: TObject);
begin
  FStageCommunication.Stop;
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
  FStageForm.HandleHomeRequest(Sender);
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
      FStageForm.ReloadSettings;
      FSpectrometerForm.ReloadSettings;
      FPlasmaForm.ReloadSettings;
      FCommunicationManager.Plasma.Close;
      FCommunicationManager.Spectrometer.Close;
      FCommunicationManager.LoadSettings;
      StartPlasmaCommunication;
      FAlarmsForm.ApplyAccessMode(FDeveloperMode);
      FOperationForm.ApplyAccessMode(FDeveloperMode);
      UpdateAccessDisplay;
    end;
  finally
    SettingsForm.Free;
  end;
end;

procedure TfrmMain.OperationRunningChanged(Sender: TObject);
begin
  btnSettings.Enabled := not FOperationForm.IsRunning;
  btnRecipes.Enabled := not FOperationForm.IsRunning;
  btnStage.Enabled := not FOperationForm.IsRunning;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FStagePollTimer.Enabled := False;
  FStageCommunication.Close;
  FCommunicationManager.CloseAll;
  FActiveScreen := nil;
end;

procedure TfrmMain.NavigationClick(Sender: TObject);
begin
  if Sender = btnOperation then
    ShowScreen(FOperationForm)
  else if Sender = btnStage then
    ShowScreen(FStageForm)
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
