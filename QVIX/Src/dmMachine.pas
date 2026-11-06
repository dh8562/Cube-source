unit dmMachine;

interface

uses
  Windows,
  SysUtils,
  Classes,
  ImgList,
  Controls,
  ExtCtrls,
  ActnList,
  Forms,
  TypInfo,
  Math,
  DateUtils,
  AppEvnts,
  Actions,
  IOUtils,
  SyncObjs,

  ShellAPI,
  ZipForge,

  CodeSiteLogging,

  cxLookAndFeelPainters,
  cxGraphics,
  cxClasses,

  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxAlertWindow,

  foTypes,
  foDataServer,
  foProcess,
  foThreadTimer,
  foChannelChecker,

  foBits,
  foMotion,
  foAlarmManager,
  foRTTIUtils,
  foWinUtils,
  foActuator,
  foStringUtils,
  foLists,
  foTimeCounter,

  elBase,
  elLog,
  elMultiLanguage,
  elPropSaver,

  voCustomDefectViewer,
  voStripViewer,

  fEmergency,
  fThreader,
  fMessageDlg,
  fLog,

  dmData,
  dmHAL,

  uEquipment,
  uAlarmConsts,
  uJob,
  uRecipe,
  uLogger,

  uCommonUtils,
  uEquipmentTypes,
  uEquipmentConsts,
  uEquipmentUtils,
  uEquipmentBase,

  cxImageList,
  System.ImageList,
  foComm, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, foMultimediaTimer;

{$I uIOServer.inc}
{$I uJobServer.inc}
{$I uSysServer.inc}
{$I uStsServer.inc}
{$I uRecipeServer.inc}

type
  TRunningStatus = ( rsNone,
                    rsStartInitialize, rsInitializeOk,
                    rsRunning, rsRunningOk,
                    rsStop, rsStopOk,
                    rsError, rsErrorOk

  );

  TMachine = class(TDataModule)
    Process: TfoProcess;
    ilSmall: TImageList;
    ilLarge: TImageList;
    alChannels: TActionList;
    TaskAuto: TfoTask;
    AlertWindowManager: TdxAlertWindowManager;
    ilAlertButton: TcxImageList;
    ilAlertMessage: TcxImageList;
    tmrAlertAlarm: TTimer;
    PropSaver: TelPropSaver;
    tmrMonitoring: TTimer;
    tmr1000ms: TfoThreadTimer;
    tmr500ms: TTimer;
    tmrConnectCheck: TTimer;
    actPLCWrite: TfoChannelAction;
    logData: TelLog;
    actSafetyOutput: TfoChannelAction;
    actSafetyInput: TfoChannelAction;
    actChemAReady: TfoChannelAction;
    actChemBReady: TfoChannelAction;
    actH2O2AReady: TfoChannelAction;
    actH2O2BReady: TfoChannelAction;
    tmrFMControl: TfoMultimediaTimer;
    actBuzzerOff: TfoChannelAction;
    actAlarmReset: TfoChannelAction;
    actDoorOpen: TfoChannelAction;
    tmrReadStatus: TfoMultimediaTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure AlertWindowManagerButtonClick(Sender: TObject; AAlertWindow: TdxAlertWindow; AButtonIndex: Integer);
    procedure tmrAlertAlarmTimer(Sender: TObject);
    procedure AlertWindowManagerShow(Sender: TObject; AAlertWindow: TdxAlertWindow);
    procedure tmrConnectCheckTimer(Sender: TObject);

    procedure tmr500msTimer(Sender: TObject);
  private
    { Private declarations }
    FAlertAlarms : TStrings;
    FTimeCycle : TfoTimeCounter;
    FAlarmWindowHideTimer: TTimer;
    FAlarmWindowHideAttempts: Integer;
    FShuttingDown: Boolean;

    FHasError: Boolean;
    FFirstPowerUp : Boolean;

    FAlarmOccurCodeNew : array [0..MAX_ALARM_CODE-1] of Boolean;
    FAlarmOccurCodeOld : array [0..MAX_ALARM_CODE-1] of Boolean;

    function GetAutoMode: TEquipmentAutoMode;
    procedure AlarmWindowHideTimer(Sender: TObject);
    procedure SetAutoMode(const Value: TEquipmentAutoMode);
    procedure DoLog(Sender: TObject; const ALogType: TfoLogType; const ALogMsg: string; const ADestinations : TLogDestinations);

    procedure AlarmOccured(Sender: TObject; const AlarmCode: Integer; const AlarmDesc: string; const AlarmSeverity: Integer);
    procedure AlarmReleased(Sender: TObject; const AlarmCode: Integer; const AlarmDesc: string; const AlarmSeverity: Integer);
    procedure AlarmBuzzerOff(Sender: TObject);
  public
    { Public declarations }
    procedure AfterInitialize;
    procedure BeforeFinalize;

    procedure UpdateCycleTime(const ACycleTime, AAvgCycleTime : Double);

    // Command
    procedure DoInitialize;

    procedure StartProcess;
    procedure PauseProcess;
    procedure StopProcess;
    procedure ResetProcess;

    function IsAutoRunning(Alert : Boolean) : Boolean;
    function IsEmergencyStop(const Alert : Boolean) : Boolean;

    procedure AddAlarm(const nErrorCode : Integer);

    property AutoMode: TEquipmentAutoMode read GetAutoMode write SetAutoMode;

    property HasError : Boolean read FHasError write FHasError;
  end;

var
  Machine: TMachine;

implementation

{$R *.dfm}

uses fMain, fAuto, fManual, dmHandler, fAlarm;


procedure HideAlarmManagerWindow;
var
  AlarmManagerWnd: HWND;
begin
  // Keep AlarmManager active for its occurrence/release events and hide only
  // the external alarm list window.
  // AlarmManager.exe uses TfrmAlarmSummary for the "current alarms"
  // window.  Fall back to the Korean caption for installations where the
  // form class differs by version.
  AlarmManagerWnd := FindWindow('TfrmAlarmSummary', nil);
  if AlarmManagerWnd = 0 then
    AlarmManagerWnd := FindWindow(nil, '현재 발생한 알람');
  if (AlarmManagerWnd <> 0) and
     ((GetWindowLongPtr(AlarmManagerWnd, GWL_STYLE) and WS_CHILD) = 0) then
    ShowWindow(AlarmManagerWnd, SW_HIDE);
end;


function DateTimeToString(const D : TDateTime) : string;
begin
  Result := FormatDateTime('yyyymmddhhnnss', Now);
end;

function StringToDateTime(const S: string): TDateTime;
var
  Y, M, D, H, N, Sec: Word;
begin
  if Length(S) <> 14 then
  begin
    //Codesite.SendError('DateTime format Error...');
  	Result := Now;
  end;

  Y   := StrToInt(Copy(S, 1, 4));
  M   := StrToInt(Copy(S, 5, 2));
  D   := StrToInt(Copy(S, 7, 2));
  H   := StrToInt(Copy(S, 9, 2));
  N   := StrToInt(Copy(S,11, 2));
  Sec := StrToInt(Copy(S,13, 2));

  Result := EncodeDate(Y, M, D) + EncodeTime(H, N, Sec, 0);
end;

function TimeDiffToSec(StartTime, EndTime : TDateTime) : Double;
begin
  Result := MilliSecondsBetween(EndTime, StartTime) / 1000.0;
end;

procedure TMachine.DataModuleCreate(Sender: TObject);
var
  I : Integer;
begin
	for I := 0 to MAX_ALARM_CODE-1 do
  begin
    FAlarmOccurCodeNew[I] := False;
    FAlarmOccurCodeOld[I] := False;
  end;

  AlarmManager.OnAlarmOccured := AlarmOccured;
  AlarmManager.OnAlarmReleased := AlarmReleased;
  AlarmManager.OnBuzzerOff := AlarmBuzzerOff;
  AlarmManager.Active := False;

  Logger.OnLog := DoLog;

  Job.LoadDefault;

  Recipe.OnLog := DoLog;
  Recipe.DefaultRecipeFile := Equipment.DefaultRecipeFile;

  // TODO
//  Recipe.DefaultRecipeDataFile := Equipment.DefaultRecipeDataFile;
  Recipe.RecipeServer := HAL.RecipeServer;
  Recipe.LoadDefault;

  FAlertAlarms := TStringList.Create;
  AlertWindowManager.OptionsMessage.Caption.Font := Screen.IconFont;
  AlertWindowManager.OptionsMessage.Text.Font := Screen.IconFont;

  FTimeCycle := TfoTimeCounter.Create;

  // AlarmManager shows its summary after sending the occurrence callback.
  // Retry briefly so its later Show call cannot leave the external window up.
  FAlarmWindowHideTimer := TTimer.Create(Self);
  FAlarmWindowHideTimer.Enabled := False;
  FAlarmWindowHideTimer.Interval := 100;
  FAlarmWindowHideTimer.OnTimer := AlarmWindowHideTimer;
  FAlarmWindowHideAttempts := 0;
  FShuttingDown := False;

  FFirstPowerUp := False;

end;

procedure TMachine.DataModuleDestroy(Sender: TObject);
var
  I : Integer;
begin
  FShuttingDown := True;
  AlarmManager.OnAlarmOccured := nil;
  AlarmManager.OnAlarmReleased := nil;
  AlarmManager.OnBuzzerOff := nil;
  FAlarmWindowHideTimer.Enabled := False;
  Logger.OnLog := nil;
  Recipe.OnLog := nil;

  AlarmManager.Active := False;
  tmrAlertAlarm.Enabled := False;
  FAlertAlarms.Free;

  FTimeCycle.Free;
end;

procedure TMachine.BeforeFinalize;
begin
  FShuttingDown := True;
  AlarmManager.OnAlarmOccured := nil;
  AlarmManager.OnAlarmReleased := nil;
  AlarmManager.OnBuzzerOff := nil;
  FAlarmWindowHideTimer.Enabled := False;
  if Assigned(frmAlarm) then
    frmAlarm.Hide;

  TaskAuto.Enabled := False;

  Process.Enabled := False;

  tmrReadStatus.Enabled := False;

  tmrMonitoring.Enabled := False;
  tmr500ms.Enabled := False;
  tmr1000ms.Enabled := False;
  tmrConnectCheck.Enabled := False;
  tmrFMControl.Enabled := False;
end;

function TMachine.IsAutoRunning(Alert: Boolean): Boolean;
begin
	Result := True;
end;

function TMachine.IsEmergencyStop(const Alert: Boolean): Boolean;
begin
  Result := True;

  if not Equipment.SystemLoaded then exit;
end;

procedure TMachine.AddAlarm(const nErrorCode: Integer);
begin
	if nErrorCode > MAX_ALARM_CODE-1 then exit;

	FAlarmOccurCodeNew[nErrorCode] := True;
  if FAlarmOccurCodeNew[nErrorCode] <> FAlarmOccurCodeOld[nErrorCode] then
  begin
  	FAlarmOccurCodeOld[nErrorCode] := FAlarmOccurCodeNew[nErrorCode];
	  Equipment.FireError(nErrorCode);
  end;
end;

procedure TMachine.AfterInitialize;
begin
  PropSaver.INIFileName := Equipment.IniFileName;

  tmrMonitoring.Enabled := True;
  tmr500ms.Enabled := True;
  tmr1000ms.Enabled := True;
  tmrConnectCheck.Enabled := True;
  tmrFMControl.Enabled := True;


  TaskAuto.Enabled := True;

  Process.Enabled := True;

  tmrReadStatus.Enabled := True;
  Machine.StopProcess;
end;

procedure TMachine.AlarmBuzzerOff(Sender: TObject);
begin
end;

procedure TMachine.AlarmOccured(Sender: TObject; const AlarmCode: Integer; const AlarmDesc: string; const AlarmSeverity: Integer);
begin
  if FShuttingDown then
    Exit;

  if AlarmSeverity = 0 then
  begin
    Logger.FireLog(ltError, Format('AlarmOccured -> %d : %s', [AlarmCode, AlarmDesc]), [ldLogViewer, ldFile]);
    StopProcess;
  end
  else
  begin
    Logger.FireLog(ltWarning, Format('WarningOccured -> %d : %s', [AlarmCode, AlarmDesc]), [ldLogViewer, ldFile]);
  end;

  HAL.IOServer.AsString[S_SYS_MESSAGE_CAPTION] := Format('[%d] %s',[AlarmCode, AlarmDesc]);
  if Assigned(frmAuto) then frmAuto.AddActiveAlarm(AlarmCode, AlarmDesc, AlarmSeverity);
  if Assigned(frmAlarm) then
    frmAlarm.ShowAlarm(AlarmCode, AlarmDesc, AlarmSeverity);
  HideAlarmManagerWindow;
  FAlarmWindowHideAttempts := 10;
  FAlarmWindowHideTimer.Enabled := True;
end;

procedure TMachine.AlarmReleased(Sender: TObject; const AlarmCode: Integer; const AlarmDesc: string; const AlarmSeverity: Integer);
begin
	if FShuttingDown then
	  Exit;

	if Assigned(frmAuto) then
	  frmAuto.RemoveActiveAlarm(AlarmCode);
  if Assigned(frmAlarm) then
    frmAlarm.RemoveAlarm(AlarmCode);

	FAlarmOccurCodeNew[AlarmCode] := False;
	FAlarmOccurCodeOld[AlarmCode] := False;

  if AlarmManager.GetAlarmCount = 0 then
  begin
    //if AlarmSeverity in [0, 1, 2] then
    begin
    end;
  end;

	if AlarmSeverity = 0 then
  begin
  	Logger.FireLog(ltError, Format('AlarmReleased -> %d : %s', [AlarmCode, AlarmDesc]), [ldLogViewer, ldFile]);
  end
  else
  begin
  	Logger.FireLog(ltWarning, Format('WarningReleased -> %d : %s', [AlarmCode, AlarmDesc]), [ldLogViewer, ldFile]);
  end;


end;

procedure TMachine.tmr500msTimer(Sender: TObject);
begin
	HAL.IOServer.AsBoolean[S_BLINK_SW] := not HAL.IOServer.AsBoolean[S_BLINK_SW];
	HAL.RecheckAlarmInputs;
end;

procedure TMachine.AlarmWindowHideTimer(Sender: TObject);
begin
  HideAlarmManagerWindow;
  Dec(FAlarmWindowHideAttempts);
  if FAlarmWindowHideAttempts <= 0 then
    FAlarmWindowHideTimer.Enabled := False;
end;

procedure TMachine.tmrAlertAlarmTimer(Sender: TObject);
var
  I : Integer;
  AlarmCode : Integer;
  AlarmDesc : String;
begin
  if FAlertAlarms.Count > 0 then
  begin
    tmrAlertAlarm.Enabled := False;

    for I := FAlertAlarms.Count - 1 downto 0 do
    begin
      AlarmCode := StrToIntDef(foGetWord(FAlertAlarms[I], 1, ['=']), 0);
      AlarmDesc := foGetWord(FAlertAlarms[I], 2, ['=']);
    end;

    FAlertAlarms.Clear;
  end;
end;

procedure TMachine.tmrConnectCheckTimer(Sender: TObject);
begin
//
end;

procedure TMachine.AlertWindowManagerButtonClick(Sender: TObject; AAlertWindow: TdxAlertWindow; AButtonIndex: Integer);
begin
  AAlertWindow.Close;
end;

procedure TMachine.AlertWindowManagerShow(Sender: TObject; AAlertWindow: TdxAlertWindow);
begin
  AAlertWindow.Pinned := True;
end;

procedure TMachine.DoInitialize;
begin
  if Equipment.SystemLoaded and (AutoMode = amIdle) then
  begin
    // Check Alarm
    if AlarmManager.GetAlarmCount > 0 then
    begin
      AlarmManager.AddMessage(MT_WARNING, elLocalizedString('Please clear all alarms'));
      Exit;
    end;

    Machine.TaskAuto.CurrentStep := Ord(rsStartInitialize);
  end;
end;

procedure TMachine.DoLog(Sender: TObject; const ALogType: TfoLogType;
  const ALogMsg: string; const ADestinations : TLogDestinations);
begin
  if (ldLogViewer in ADestinations) and (frmLog <> nil) then
  begin
    if ALogType = ltEnter then
      frmLog.EnterMethod(ALogMsg)
    else if ALogType = ltExit then
      frmLog.ExitMethod(ALogMsg)
    else if ALogType = ltClear then
      frmLog.Clear
    else
    begin
      frmLog.Add(ALogType, ALogMsg);
    end;
  end;
end;

function TMachine.GetAutoMode: TEquipmentAutoMode;
begin
  Result := Equipment.AutoMode;
end;

procedure TMachine.SetAutoMode(const Value: TEquipmentAutoMode);
var
  szAutoMode: string;
begin
  if (Equipment.AutoMode <> Value) then
  begin
    Equipment.AutoMode := Value;
    Equipment.BroadcastMessage(UM_AUTO_MODE_CHANGED, 0, 0);
    szAutoMode := foEnumName(Ord(Equipment.AutoMode),
      TypeInfo(TEquipmentAutoMode));
    Delete(szAutoMode, 1, 2);
    Logger.FireLog(ltSeparator, '', [ldFile]);
    Logger.FireLog(ltFlag, Format(elLocalizedString('Changed Auto Mode To %s'), [szAutoMode]), [ldFile]);
  end;

  case Equipment.AutoMode of
    amIdle:
      begin
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION] := elLocalizedString('IDLE');
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION_LCD] := 'IDLE';
      end;

    amOriginAll:
      begin
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION] := elLocalizedString('INITIALIZING...');
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION_LCD] := 'INITIALIZING';
      end;

    amRun:
      begin
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION] := elLocalizedString('RUNNING');
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION_LCD] := 'RUNNING';
      end;

    amManualRun:
      begin
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION] := elLocalizedString('MANUAL RUN...');
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION_LCD] := 'MANUAL RUN';
      end;

    amPaused:
      begin
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION] := elLocalizedString('PAUSED');
        HAL.IOServer.AsString[S_SYS_STATUS_CAPTION_LCD] := 'PAUSED';
      end;
  end;
end;

procedure TMachine.StartProcess;
begin
  if AlarmManager.GetAlarmCount > 0 then
  begin
    AlarmManager.AddMessage(MT_WARNING, elLocalizedString('Please release all alarms.'));
    exit;
  end;
	AlarmManager.DeleteAllAlarm;

  if not IsEmergencyStop(True) then exit;

  TaskAuto.CurrentStep := Ord(rsRunning);
end;

procedure TMachine.PauseProcess;
begin
  AlarmManager.ReleaseAllAlarm;
  AlarmManager.DeleteAllAlarm;
  TaskAuto.CurrentStep := Ord(rsStop);
end;

procedure TMachine.ResetProcess;
begin
  AlarmManager.ReleaseAllAlarm;
  AlarmManager.DeleteAllAlarm;

  HAL.IOServer.AsString[S_SYS_MESSAGE_CAPTION] := '';
end;

procedure TMachine.StopProcess;
begin
  TaskAuto.CurrentStep := Ord(rsStop);
end;

procedure TMachine.UpdateCycleTime(const ACycleTime, AAvgCycleTime: Double);
begin
  if (ACycleTime > 0) then
  begin
    HAL.IOServer.AsDouble[S_CYCLE_TIME_AVG] := AAvgCycleTime;
    if Abs(AAvgCycleTime) > 1.0E-12 then
      HAL.IOServer.AsDouble[S_CYCLE_TIME_UPH] := (3600.0 / AAvgCycleTime) * 2.0
    else
      HAL.IOServer.AsDouble[S_CYCLE_TIME_UPH] := 0.0;

    if Equipment.VerboseMode > 0 then
      foBroadcastMessage(UM_UPDATE_CYCLE_TIME, 0, 0);
  end;
end;

end.
