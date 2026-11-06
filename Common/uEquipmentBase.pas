unit uEquipmentBase;

interface

uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  Math,
  JPEG,
  Forms,
  StdCtrls,
  ExtCtrls,
  IniFiles,
  TypInfo,
  ComCtrls,
  ActiveX,
  ComObj,
  OleServer,
  Variants,
  Graphics,
  DateUtils,
  IOUtils,

  CodeSiteLogging,

  foAlarmManager,
  foDataServer,
  foDataServerUtils,
  foWinUtils,
  foLists,
  foTypes,
  foUserManager,
  foStringUtils,
  foRTTIUtils,
  foMotion,

  elMultiLanguage,

  uLogger,
  uUserManager,
  uCommonUtils,
  uEquipmentTypes,
  uEquipmentUtils,
  uEquipmentConsts;

type
  TEquipmentTimeFragment = class(TPersistent)
  private
    FAccumulated: TDateTime;
    FEndAt: TDateTime;
    FTag: Integer;
    FStartAt: TDateTime;
    FCounting: Boolean;
    procedure SetEndAt(const Value: TDateTime);
    procedure SetStartAt(const Value: TDateTime);
    function GetAccumulated: TDateTime;
    procedure SetAccumulated(const Value: TDateTime);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure UpdateAccumulated;
    procedure Clear;
    procedure ClearAccumulated;
    procedure Stop;

    procedure LoadFrom(AIniFile : TCustomIniFile; const ASection : string);
    procedure SaveTo(AIniFile : TCustomIniFile; const ASection : string);

    property StartAt : TDateTime read FStartAt write SetStartAt;
    property EndAt : TDateTime read FEndAt write SetEndAt;
  published
    property Accumulated : TDateTime read GetAccumulated write SetAccumulated;
    property Counting : Boolean read FCounting write FCounting;
    property Tag : Integer read FTag write FTag;
  end;

  // Automated Reliability, Availability, Maintainability Standards
  TEquipmentARAMSState = (
    asStandBy,
    asProductive,
    asEngineering,
    asUnscheduledDownTime,
    asScheduledDownTime,
    asNonScheduledTime
  );

  TEquipmentTime = class(TPersistent)
  private
    FProductiveTime: TEquipmentTimeFragment;
    FUnscheduledDownTime: TEquipmentTimeFragment;
    FNonScheduledTime: TEquipmentTimeFragment;
    FStandbyTime: TEquipmentTimeFragment;
    FEngineeringTime: TEquipmentTimeFragment;
    FScheduledDownTime: TEquipmentTimeFragment;
    procedure SetUnscheduledDownTime(const Value: TEquipmentTimeFragment);
    procedure SetNonScheduledTime(const Value: TEquipmentTimeFragment);
    procedure SetProductiveTime(const Value: TEquipmentTimeFragment);
    procedure SetStandbyTime(const Value: TEquipmentTimeFragment);
    procedure SetEngineeringTime(const Value: TEquipmentTimeFragment);
    procedure SetScheduledDownTime(const Value: TEquipmentTimeFragment);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFrom(AIniFile : TCustomIniFile);
    procedure SaveTo(AIniFile : TCustomIniFile);

    procedure Clear;
    procedure Stop;
  published
    property NonScheduledTime : TEquipmentTimeFragment read FNonScheduledTime write SetNonScheduledTime;
    property ScheduledDownTime : TEquipmentTimeFragment read FScheduledDownTime write SetScheduledDownTime;
    property UnscheduledDownTime : TEquipmentTimeFragment read FUnscheduledDownTime write SetUnscheduledDownTime;
    property EngineeringTime : TEquipmentTimeFragment read FEngineeringTime write SetEngineeringTime;
    property StandbyTime : TEquipmentTimeFragment read FStandbyTime write SetStandbyTime;
    property ProductiveTime : TEquipmentTimeFragment read FProductiveTime write SetProductiveTime;
  end;

  TCustomEquipment = class
  private
    FSysServer: TfoDataServer;
    FIOServer : TfoDataServer;
    FJobServer: TfoDataServer;
    FStsServer: TfoDataServer;
    FRecipeServer: TfoDataServer;

    FActiveUserLevel: Integer;
    FActiveUser: string;
    FStartUpWithHW: Boolean;
    FStartUpWithAligner: Boolean;
    FSystemLoaded: Boolean;
    FVerboseMode: Integer;
    FAutoMode: TEquipmentAutoMode;
    FPrevAutoMode: TEquipmentAutoMode;
    FMultiLanguage: TelMultiLanguage;
    FConfigurationLoaded: Boolean;
    FSaveSysInfoOnClose: Boolean;

    FRecipeFileExtension: string;
    FJobFileExtension: string;

    FUpdateOperationRateTimer : TTimer;
    FOperationRate : TfoDoubleList;
    FOperationTime : TfoDoubleList;
    FRunStartedAt : TDateTime;
    FRunEndedAt : TDateTime;
    FCycleStartedAt : TDateTime;

    FOnSplashMsg: TfoLogEvent;
    FOnLog: TfoTypedLogEvent;
    FOnAlert: TfoTypedLogEvent;

    FOnInitializeHardware: TEquipmentHardwareEvent;
    FOnFinalizeHardware: TEquipmentHardwareEvent;
    FJobFileFilter: string;
    FRecipeFileFilter: string;
    FStartUpWithVision: Boolean;

    FLotAccumulatedAlarmTime: TDateTime;
    FLotAlarmStartAt: TDateTime;
    FLotAlarmEndAt: TDateTime;
    FLotAccumulatedAlarmCount: Integer;

    FOperationsTime: TEquipmentTime;
    FPreviousState: TEquipmentARAMSState;
    FState: TEquipmentARAMSState;
    FMachineStatisticsSavedAt: TDateTime;
    FLotAccumulatedIdleTime: TDateTime;
    FLotIdleStartAt: TDateTime;
    FLotIdleEndAt: TDateTime;

    function GetConfigPath: string;
    function GetSysInfoFile: string;

    function GetIOFile: string;
    function GetLogPath: string;
    function GetMonthLogPath: String;
    procedure SetVerboseMode(const Value: Integer);
    function GetJobPath: string;
    function GetDefaultJobFile: string;
    function GetIniFileName: string;

    procedure DoUpdateOperationRate(Sender : TObject);
    procedure UpdateOperationRate;

    procedure SetAutoMode(const Value: TEquipmentAutoMode);

    function GetRecipePath: string;
    function GetDefaultRecipeFile: string;
    procedure SetOperationsTime(const Value: TEquipmentTime);
    procedure SetState(const Value: TEquipmentARAMSState);
    procedure SetLotIdleEndAt(const Value: TDateTime);
    function GetJobExtractPath: string;
  protected
    function DoLoadConfiguration : Boolean; virtual;
    function DoSaveConfiguration : Boolean; virtual;

    function DoInitializeDIO : Boolean; virtual;
    function DoInitializeAIO : Boolean; virtual;
    function DoInitializeMotion : Boolean; virtual;
    function DoInitializeVision : Boolean; virtual;
    function DoInitializeOther : Boolean; virtual;

    function DoFinalizeDIO : Boolean; virtual;
    function DoFinalizeAIO : Boolean; virtual;
    function DoFinalizeMotion : Boolean; virtual;
    function DoFinalizeVision : Boolean; virtual;
    function DoFinalizeOther : Boolean; virtual;

    function DoSystemFinalize: Boolean; virtual;
    function DoSystemInitialize: Boolean; virtual;
    procedure DoAfterFinalization; virtual;
    procedure DoAfterInitialization; virtual;

    function DoCheckSystemParameters: Boolean; virtual;
    procedure DoUpdateState; virtual;

    procedure UpdateLotAlarmTime;
    procedure SetLotAlarmEndAt(const Value: TDateTime); virtual;

    procedure UpdateLotIdleTime;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure FireError(const AAlarmCode : Integer);
    procedure ReleaseError(const AAlarmCode : Integer);
    procedure FireAlarmMsg(const AMsgType: Integer; const AMsg: string);

    procedure FireSplashMsg(const AMsg : string);
    procedure FireAlert(const AMsg : string);

    procedure SaveSysInfo;

    function LoadConfiguration : Boolean;
    function SaveConfiguration : Boolean;

    function InitializeDIO : Boolean;
    function InitializeAIO : Boolean;
    function InitializeMotion : Boolean;
    function InitializeVision : Boolean;
    function InitializeOther : Boolean;

    function FinalizeDIO : Boolean;
    function FinalizeAIO : Boolean;
    function FinalizeMotion : Boolean;
    function FinalizeVision : Boolean;
    function FinalizeOther : Boolean;

    function SystemFinalize: Boolean;
    function SystemInitialize: Boolean;

    procedure LoadStatistics;
    procedure SaveStatistics;

    procedure EnsurePathExist(const APath : String);

    function GetAppPath: string;

    procedure BroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False);
    function CheckSystemParameters : Boolean;

    function GetRecipeFile(const ARecipeName : string) : string;
    function GetJobFile(const AJobName : string) : string;
    function GetConfigFile(const AFileName : string) : string;

    procedure UpdateJobFileList(AList : TStrings);
    function getJobFileList(Const JobName : String) : Boolean;

    function ParseEnvironmentVariables(const AVar : string) : String;

    procedure AutoLogIn(const AUser : string);
    function LogIn : Boolean;
    procedure LogOut;
    function CheckAdminUser : Boolean;

    property AppPath : string read GetAppPath;
    property ConfigPath : string read GetConfigPath;
    property JobPath : string read GetJobPath;
    property RecipePath : string read GetRecipePath;
    property LogPath : string read GetLogPath;
    property MonthLogPath : string read GetMonthLogPath;
    property SysInfoFile : string read GetSysInfoFile;
    property IOFile : string read GetIOFile;
    property JobExtractPath : string read GetJobExtractPath;

    property IOServer : TfoDataServer read FIOServer write FIOServer;
    property SysServer : TfoDataServer read FSysServer write FSysServer;
    property JobServer : TfoDataServer read FJobServer write FJobServer;
    property RecipeServer : TfoDataServer read FRecipeServer write FRecipeServer;
    property StsServer : TfoDataServer read FStsServer write FStsServer;

    property DefaultJobFile : string read GetDefaultJobFile;
    property DefaultRecipeFile : string read GetDefaultRecipeFile;
    property IniFileName : string read GetIniFileName;

    property SystemLoaded : Boolean read FSystemLoaded;
    property ConfigurationLoaded : Boolean read FConfigurationLoaded;
    property StartUpWithHW : Boolean read FStartUpWithHW;
    property StartUpWithVision : Boolean read FStartUpWithVision;
    property VerboseMode : Integer read FVerboseMode write SetVerboseMode;

    property AutoMode: TEquipmentAutoMode read FAutoMode write SetAutoMode;
    property PrevAutoMode: TEquipmentAutoMode read FPrevAutoMode write FPrevAutoMode;
    property ActiveUser : string read FActiveUser write FActiveUser;
    property ActiveUserLevel : Integer read FActiveUserLevel write FActiveUserLevel;

    property MultiLanguage : TelMultiLanguage read FMultiLanguage write FMultiLanguage;

    property SaveSysInfoOnClose : Boolean read FSaveSysInfoOnClose write FSaveSysInfoOnClose;

    property JobFileExtension : string read FJobFileExtension write FJobFileExtension;
    property JobFileFilter : string read FJobFileFilter write FJobFileFilter;

    property RecipeFileExtension : string read FRecipeFileExtension write FRecipeFileExtension;
    property RecipeFileFilter : string read FRecipeFileFilter write FRecipeFileFilter;

    property OperationRate : TfoDoubleList read FOperationRate;

    property LotAccumulatedAlarmTime : TDateTime read FLotAccumulatedAlarmTime write FLotAccumulatedAlarmTime;
    property LotAlarmStartAt : TDateTime read FLotAlarmStartAt write FLotAlarmStartAt;
    property LotAlarmEndAt : TDateTime read FLotAlarmEndAt write SetLotAlarmEndAt;
    property LotAccumulatedAlarmCount : Integer read FLotAccumulatedAlarmCount write FLotAccumulatedAlarmCount;

    property LotIdleStartAt : TDateTime read FLotIdleStartAt write FLotIdleStartAt;
    property LotIdleEndAt : TDateTime read FLotIdleEndAt write SetLotIdleEndAt;
    property LotAccumulatedIdleTime : TDateTime read FLotAccumulatedIdleTime write FLotAccumulatedIdleTime;

    property State : TEquipmentARAMSState read FState write SetState;

    property OperationsTime : TEquipmentTime read FOperationsTime write SetOperationsTime;
    property MachineStatisticsSavedAt : TDateTime read FMachineStatisticsSavedAt write FMachineStatisticsSavedAt;

    property OnInitializeHardware : TEquipmentHardwareEvent read FOnInitializeHardware write FOnInitializeHardware;
    property OnFinalizeHardware : TEquipmentHardwareEvent read FOnFinalizeHardware write FOnFinalizeHardware;

    property OnAlert : TfoTypedLogEvent read FOnAlert write FOnAlert;
    property OnLog : TfoTypedLogEvent read FOnLog write FOnLog;
    property OnSplashMsg : TfoLogEvent read FOnSplashMsg write FOnSplashMsg;
  end;



implementation

{ TEquipmentTimeFragment }

procedure TEquipmentTimeFragment.Assign(Source: TPersistent);
begin
  if Source is TEquipmentTimeFragment then
  begin
    FAccumulated := TEquipmentTimeFragment(Source).Accumulated;
    FStartAt := TEquipmentTimeFragment(Source).StartAt;
    FEndAt := TEquipmentTimeFragment(Source).EndAt;
    FTag := TEquipmentTimeFragment(Source).Tag;
    FCounting := TEquipmentTimeFragment(Source).Counting;
  end
  else
    inherited;
end;

procedure TEquipmentTimeFragment.Clear;
begin
  FAccumulated := 0.0;
  FStartAt := 0.0;
  FEndAt := 0.0;
end;

procedure TEquipmentTimeFragment.ClearAccumulated;
begin
  FAccumulated := 0.0;
end;

constructor TEquipmentTimeFragment.Create;
begin
  FAccumulated := 0.0;
  FStartAt := 0.0;
  FEndAt := 0.0;
  FTag := 0;
  FCounting := False;
end;

destructor TEquipmentTimeFragment.Destroy;
begin

  inherited;
end;

function TEquipmentTimeFragment.GetAccumulated: TDateTime;
begin
  Result := FAccumulated;
  if FCounting and (FStartAt > 0) then
  begin
    Result := Result + (Now - FStartAt);
  end;
end;

procedure TEquipmentTimeFragment.LoadFrom(AIniFile: TCustomIniFile;
  const ASection: string);
begin
  foIniLoadComponentProperties(Self, AIniFile, ASection);

  // Without Set Function
  FStartAt := AIniFile.ReadFloat(ASection, 'StartAt', FStartAt);
  FEndAt := AIniFile.ReadFloat(ASection, 'EndAt', FEndAt);
end;

procedure TEquipmentTimeFragment.SaveTo(AIniFile: TCustomIniFile;
  const ASection: string);
begin
  foIniSaveComponentProperties(Self, AIniFile, ASection);
  AIniFile.WriteFloat(ASection, 'StartAt', FStartAt);
  AIniFile.WriteFloat(ASection, 'EndAt', FEndAt);
end;

procedure TEquipmentTimeFragment.SetAccumulated(const Value: TDateTime);
begin
  FAccumulated := Value;
end;

procedure TEquipmentTimeFragment.SetEndAt(const Value: TDateTime);
begin
  FEndAt := Value;
  if FCounting then
    UpdateAccumulated;
  FCounting := False;
end;

procedure TEquipmentTimeFragment.SetStartAt(const Value: TDateTime);
begin
  FStartAt := Value;
  FCounting := True;
end;

procedure TEquipmentTimeFragment.Stop;
begin
  EndAt := Now;
end;

procedure TEquipmentTimeFragment.UpdateAccumulated;
begin
  if (FStartAt > 0.0) and (FEndAt > FStartAt) then
    FAccumulated := FAccumulated + (FEndAt - FStartAt);
end;

{ TEquipmentTime }

procedure TEquipmentTime.Assign(Source: TPersistent);
begin
  if Source is TEquipmentTime then
  begin
    NonScheduledTime := TEquipmentTime(Source).NonScheduledTime;
    ProductiveTime := TEquipmentTime(Source).ProductiveTime;
    UnscheduledDownTime  := TEquipmentTime(Source).UnscheduledDownTime;
    StandbyTime  := TEquipmentTime(Source).StandbyTime;
    EngineeringTime  := TEquipmentTime(Source).EngineeringTime;
  end
  else
    inherited;
end;

procedure TEquipmentTime.Clear;
begin
  FNonScheduledTime.Clear;
  FProductiveTime.Clear;
  FUnscheduledDownTime.Clear;
  FScheduledDownTime.Clear;
  FStandbyTime.Clear;
  FEngineeringTime.Clear;
end;

constructor TEquipmentTime.Create;
begin
  FNonScheduledTime := TEquipmentTimeFragment.Create;
  FProductiveTime := TEquipmentTimeFragment.Create;
  FUnscheduledDownTime := TEquipmentTimeFragment.Create;
  FScheduledDownTime := TEquipmentTimeFragment.Create;
  FStandbyTime := TEquipmentTimeFragment.Create;
  FEngineeringTime := TEquipmentTimeFragment.Create;
end;

destructor TEquipmentTime.Destroy;
begin
  FNonScheduledTime.Free;
  FProductiveTime.Free;
  FUnscheduledDownTime.Free;
  FScheduledDownTime.Free;
  FStandbyTime.Free;
  FEngineeringTime.Free;
  inherited;
end;

procedure TEquipmentTime.LoadFrom(AIniFile: TCustomIniFile);
var
  lastPowerDown : TDateTime;
begin
  FNonScheduledTime.LoadFrom(AIniFile, 'NonScheduledTime');
  FProductiveTime.LoadFrom(AIniFile, 'ProductiveTime');
  FUnscheduledDownTime.LoadFrom(AIniFile, 'UnscheduledDownTime');
  FScheduledDownTime.LoadFrom(AIniFile, 'ScheduledDownTime');
  FStandbyTime.LoadFrom(AIniFile, 'StandbyTime');
  FEngineeringTime.LoadFrom(AIniFile, 'EngineeringTime');

  LastPowerDown := AIniFile.ReadFloat('EquipmentTime', 'LastPowerDown', RecodeTime(Now, 0, 0, 0, 0));
  if not IsSameDay(Now, LastPowerDown) then
  begin
    Clear;
    FNonScheduledTime.Accumulated := Now - RecodeTime(Now, 0, 0, 0, 0);
  end
  else
  begin
    FNonScheduledTime.Accumulated := FNonScheduledTime.Accumulated + (Now - LastPowerDown);
  end;
end;

procedure TEquipmentTime.SaveTo(AIniFile: TCustomIniFile);
begin
  FNonScheduledTime.SaveTo(AIniFile, 'NonScheduledTime');
  FProductiveTime.SaveTo(AIniFile, 'ProductiveTime');
  FUnscheduledDownTime.SaveTo(AIniFile, 'UnscheduledDownTime');
  FScheduledDownTime.SaveTo(AIniFile, 'ScheduledDownTime');
  FStandbyTime.SaveTo(AIniFile, 'StandbyTime');
  FEngineeringTime.SaveTo(AIniFile, 'EngineeringTime');
  AIniFile.WriteFloat('EquipmentTime', 'LastPowerDown', Now);
end;

procedure TEquipmentTime.SetUnscheduledDownTime(const Value: TEquipmentTimeFragment);
begin
  FUnscheduledDownTime.Assign(Value);
end;

procedure TEquipmentTime.Stop;
begin
  FNonScheduledTime.Stop;
  FProductiveTime.Stop;
  FUnscheduledDownTime.Stop;
  FScheduledDownTime.Stop;
  FStandbyTime.Stop;
  FEngineeringTime.Stop;
end;

procedure TEquipmentTime.SetStandbyTime(const Value: TEquipmentTimeFragment);
begin
  FStandbyTime.Assign(Value);
end;

procedure TEquipmentTime.SetProductiveTime(
  const Value: TEquipmentTimeFragment);
begin
  FProductiveTime.Assign(Value);
end;

procedure TEquipmentTime.SetScheduledDownTime(
  const Value: TEquipmentTimeFragment);
begin
  FScheduledDownTime.Assign(Value);
end;

procedure TEquipmentTime.SetEngineeringTime(const Value: TEquipmentTimeFragment);
begin
  FEngineeringTime.Assign(Value);
end;

procedure TEquipmentTime.SetNonScheduledTime(
  const Value: TEquipmentTimeFragment);
begin
  FNonScheduledTime.Assign(Value);
end;

const
  // 사전 정의된 채널 이름
  S_JOB_PATH = 'JOB_PATH';
  S_LOG_PATH = 'LOG_PATH';
  S_RECIPE_PATH = 'RECIPE_PATH';
  S_IO_CHANNEL_FILE = 'IO_CHANNEL_FILE';
  S_STARTUP_WITH_HW = 'STARTUP_WITH_HW';
  S_STARTUP_WITH_VISION = 'STARTUP_WITH_VISION';

function TCustomEquipment.LogIn: Boolean;
var
  U : String;
begin
  SetLength(U, 255);
  if Assigned(FMultiLanguage) then
    Result := uUserManager.UserLogIn(FMultiLanguage.ActiveLocaleAbbr, PChar(U), FActiveUserLevel)
  else
    Result := uUserManager.LogIn(0, PChar(U), FActiveUserLevel);
  if FActiveUserLevel <> -1 then
  begin
    FActiveUser := StrPas(PChar(U));
    foUserLoggedIn(TfoUserAuthority(FActiveUserLevel));
    BroadcastMessage(UM_USER_LOGIN, 0, 0);
  end
  else
  begin
    FActiveUser := '';
    FActiveUserLevel := -1;
    foUserLoggedOut;
    BroadcastMessage(UM_USER_LOGOUT, 0, 0);
  end;
end;

procedure TCustomEquipment.LogOut;
begin
  FActiveUser := '';
  FActiveUserLevel := -1;
  foUserLoggedOut;
  BroadcastMessage(UM_USER_LOGOUT, 0, 0);
end;

procedure TCustomEquipment.AutoLogIn(const AUser: string);
begin
  FActiveUser := AUser;
  FActiveUserLevel := Ord(uaAdministrator);
  foUserLoggedIn(uaAdministrator);
  BroadcastMessage(UM_USER_LOGIN, 0, 0);
end;

procedure TCustomEquipment.BroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean);
begin
  foBroadcastMessage(Msg, WordParam, LongParam, AAsync);
end;

function TCustomEquipment.CheckAdminUser: Boolean;
var
  U : String;
  UserLevel : Integer;
begin
  Result := False;

  SetLength(U, 255);
  if Assigned(FMultiLanguage) then
    Result := uUserManager.UserLogIn(FMultiLanguage.ActiveLocaleAbbr, PChar(U), UserLevel)
  else
    Result := uUserManager.LogIn(0, PChar(U), UserLevel);

  if Result then
  begin
    Result := (TfoUserAuthority(UserLevel) <> uaOperator);
  end;
end;

function TCustomEquipment.CheckSystemParameters: Boolean;
begin
  Result := True;

  Logger.FireLog(ltEnter, elLocalizedString('Check System Parameters'), [ldLogViewer]);

	Result := DoCheckSystemParameters;
	if not Result then
  begin
    Logger.FireLog(ltError, elLocalizedString('Check System Parameters Failed!!'), [ldLogViewer, ldAlarmManager]);
  end;

  Logger.FireLog(ltExit, elLocalizedString('Check System Parameters'), [ldLogViewer]);
end;

constructor TCustomEquipment.Create;
begin
  FSysServer := nil;
  FIOServer  := nil;
  FJobServer := nil;
  FRecipeServer := nil;
  FStsServer := nil;

  FSystemLoaded := False;
  FConfigurationLoaded := False;
  FStartUpWithHW := False;

  FVerboseMode := 0;

  FAutoMode := amIdle;
  FPrevAutoMode := amIdle;
  FActiveUserLevel := -1;

  FJobFileExtension := SJobFileExt;
  FJobFileFilter := SJobFileFilter;
  FRecipeFileExtension := SRecipeFileExt;
  FRecipeFileFilter := SRecipeFileFilter;

  FUpdateOperationRateTimer := TTimer.Create(nil);
  FUpdateOperationRateTimer.Enabled := False;
  FUpdateOperationRateTimer.Interval := 10000;
  FUpdateOperationRateTimer.OnTimer := DoUpdateOperationRate;
  FOperationRate := TfoDoubleList.Create;
  FOperationTime := TfoDoubleList.Create;
  FRunStartedAt := Now;
  FRunEndedAt := FRunStartedAt;

  FLotAccumulatedAlarmTime := 0;
  FLotAccumulatedIdleTime := 0;

  FState := asStandBy;
  FPreviousState := asStandBy;
  FOperationsTime := TEquipmentTime.Create;

  MachineStatisticsSavedAt := Now;
end;

destructor TCustomEquipment.Destroy;
begin
  FUpdateOperationRateTimer.Enabled := False;
  FUpdateOperationRateTimer.Free;
  FOperationTime.Free;
  FOperationRate.Free;

  FOperationsTime.Free;
  inherited;
end;

procedure TCustomEquipment.DoAfterFinalization;
begin
;
end;

procedure TCustomEquipment.DoAfterInitialization;
begin
;
end;

function TCustomEquipment.DoCheckSystemParameters: Boolean;
begin
  Result := True;
end;

function TCustomEquipment.DoFinalizeAIO: Boolean;
begin
  Result := True;
  if Assigned(FOnFinalizeHardware) then
    FOnFinalizeHardware(Self, ehAnalogIO, Result);
end;

function TCustomEquipment.DoFinalizeDIO: Boolean;
begin
  Result := True;
  if Assigned(FOnFinalizeHardware) then
    FOnFinalizeHardware(Self, ehDigitalIO, Result);
end;

function TCustomEquipment.DoFinalizeMotion: Boolean;
begin
  Result := True;
  if Assigned(FOnFinalizeHardware) then
    FOnFinalizeHardware(Self, ehMotion, Result);
end;

function TCustomEquipment.DoFinalizeOther: Boolean;
begin
  Result := True;
  if Assigned(FOnFinalizeHardware) then
    FOnFinalizeHardware(Self, ehOther, Result);
end;

function TCustomEquipment.DoFinalizeVision: Boolean;
begin
  Result := True;
  if Assigned(FOnFinalizeHardware) then
    FOnFinalizeHardware(Self, ehVision, Result);
end;

function TCustomEquipment.DoInitializeAIO: Boolean;
begin
  Result := True;
  if Assigned(FOnInitializeHardware) then
    FOnInitializeHardware(Self, ehAnalogIO, Result);
end;

function TCustomEquipment.DoInitializeDIO: Boolean;
begin
  Result := True;
  if Assigned(FOnInitializeHardware) then
    FOnInitializeHardware(Self, ehDigitalIO, Result);
end;

function TCustomEquipment.DoInitializeMotion: Boolean;
begin
  Result := True;
  if Assigned(FOnInitializeHardware) then
    FOnInitializeHardware(Self, ehMotion, Result);
end;

function TCustomEquipment.DoInitializeOther: Boolean;
begin
  Result := True;
  if Assigned(FOnInitializeHardware) then
    FOnInitializeHardware(Self, ehOther, Result);
end;

function TCustomEquipment.DoInitializeVision: Boolean;
begin
  Result := True;
  if Assigned(FOnInitializeHardware) then
    FOnInitializeHardware(Self, ehVision, Result);
end;

function TCustomEquipment.DoLoadConfiguration: Boolean;
begin
  Result := True;
end;

function TCustomEquipment.DoSaveConfiguration: Boolean;
begin
  Result := True;
end;

function TCustomEquipment.DoSystemFinalize: Boolean;
begin
  Result := True;
end;

function TCustomEquipment.DoSystemInitialize: Boolean;
begin
  Result := True;
end;

procedure TCustomEquipment.DoUpdateOperationRate(Sender: TObject);
var
  H, M : Integer;
begin
  H := HourOf(Now);
  M := MinuteOf(Now);

  // 00:00 이면
  if (H = 0) and (M = 0) then
  begin
    FOperationRate.Clear;
  end;

  if M = 0 then
  begin
    if AutoMode in [amRun] then
      FRunStartedAt := Now;
  end;

  UpdateOperationRate;
end;

procedure TCustomEquipment.DoUpdateState;
begin
;
end;

function TCustomEquipment.FinalizeAIO: Boolean;
begin
  Result := DoFinalizeAIO;
end;

function TCustomEquipment.FinalizeDIO: Boolean;
begin
  Result := DoFinalizeDIO;
end;

function TCustomEquipment.FinalizeMotion: Boolean;
begin
  Result := DoFinalizeMotion;
end;

function TCustomEquipment.FinalizeOther: Boolean;
begin
  Result := DoFinalizeOther;
end;

function TCustomEquipment.FinalizeVision: Boolean;
begin
  Result := DoFinalizeVision;
end;

procedure TCustomEquipment.FireAlarmMsg(const AMsgType: Integer; const AMsg: string);
begin
  AlarmManager.AddMessage(AMsgType, AMsg);
end;

procedure TCustomEquipment.FireAlert(const AMsg: string);
begin
  if Assigned(FOnAlert) then FOnAlert(Self, ltMessage, AMsg);
end;

procedure TCustomEquipment.FireError(const AAlarmCode: Integer);
begin
  AlarmManager.AddAlarm(AAlarmCode);
end;

procedure TCustomEquipment.FireSplashMsg(const AMsg: string);
begin
  if Assigned(FOnSplashMsg) then FOnSplashMsg(Self, AMsg);
end;

function TCustomEquipment.GetAppPath: string;
begin
  Result := foAppPath;
end;

function TCustomEquipment.GetConfigFile(const AFileName: string): string;
begin
  Result := ConfigPath + AFileName;
end;

function TCustomEquipment.GetConfigPath: string;
begin
  Result := AppPath + 'Config\';
  EnsurePathExist(Result);
end;

function TCustomEquipment.GetDefaultJobFile: string;
begin
  Result := Format('%sdefault%s', [JobPath, FJobFileExtension]);
end;

function TCustomEquipment.GetDefaultRecipeFile: string;
begin
  Result := Format('%sdefault%s', [GetRecipePath, FRecipeFileExtension]);
end;

function TCustomEquipment.GetIniFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

function TCustomEquipment.GetIOFile: string;
begin
	Result := ConfigPath + SIOChannelFile;
end;

function TCustomEquipment.GetJobFile(const AJobName: string): string;
begin
  Result := Format('%s%s%s', [JobPath, AJobName, FJobFileExtension]);
end;

function TCustomEquipment.GetJobExtractPath: string;
begin
  if not DirectoryExists(Result) then CreateDir(Result);
  Result := AppPath + 'JobExtract\';
end;

function TCustomEquipment.GetJobPath: string;
begin
  Result := AppPath + 'Jobs\';

  if SysServer.ChannelExist(S_JOB_PATH) and (SysServer.AsString[S_JOB_PATH] <> '') then
  begin
    Result := IncludeTrailingBackSlash(SysServer.AsString[S_JOB_PATH]);
  end;

  EnsurePathExist(Result);
end;

function TCustomEquipment.GetLogPath: string;
begin
  Result := AppPath + 'Logs\';

  if SysServer.ChannelExist(S_LOG_PATH) and (SysServer.AsString[S_LOG_PATH] <> '') then
  begin
    Result := SysServer.AsString[S_LOG_PATH];
  end;

  EnsurePathExist(Result);
end;

function TCustomEquipment.GetMonthLogPath: String;
var
  LogDate : String;
begin
  LogDate := FormatDateTime('yyyy-MM',Now);
  Result := GetLogPath + LogDate +'\';
  EnsurePathExist(Result);
end;

function TCustomEquipment.GetRecipeFile(const ARecipeName: string): string;
begin
  Result := Format('%s%s%s', [RecipePath, ARecipeName, SRecipeFileExt]);
end;

function TCustomEquipment.GetRecipePath: string;
begin
  Result := AppPath + 'Recipes\';
  EnsurePathExist(Result);
end;

function TCustomEquipment.GetSysInfoFile: string;
begin
  Result := ConfigPath + SSysInfoFile;
end;

function TCustomEquipment.InitializeAIO: Boolean;
begin
  Result := False;

  FireSplashMsg(elLocalizedString('Initializing Analog I/O Devices...'));

  Result := DoInitializeAIO;

  if Result then
  begin
    Logger.FireLog(ltMessage, elLocalizedString('Analog IO Initialization OK'), [ldLogViewer]);
  end
  else
  begin
    Logger.FireLog(ltError, elLocalizedString('Analog IO Initialization Failed!'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.InitializeDIO: Boolean;
begin
  Result := False;

  FireSplashMsg(elLocalizedString('Initializing Digital I/O Devices...'));

  Result := DoInitializeDIO;

  if Result then
  begin
    Logger.FireLog(ltMessage, elLocalizedString('Digital IO Initialization OK'), [ldLogViewer]);
  end
  else
  begin
    Logger.FireLog(ltError, elLocalizedString('Digital IO Initialization Failed!'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.InitializeMotion: Boolean;
begin
  FireSplashMsg(elLocalizedString('Initializing Motion Devices...'));

  Result := DoInitializeMotion;

  if Result then
  begin
    Logger.FireLog(ltMessage, elLocalizedString('Motion Initialization OK'), [ldLogViewer]);
  end
  else
  begin
    Logger.FireLog(ltError, elLocalizedString('Motion Initialization Failed!'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.InitializeOther: Boolean;
begin
  FireSplashMsg(elLocalizedString('Initializing Various Devices...'));

  Result := DoInitializeOther;

  if Result then
  begin
    Logger.FireLog(ltMessage, elLocalizedString('Various Device Initialization OK'), [ldLogViewer]);
  end
  else
  begin
    Logger.FireLog(ltError, elLocalizedString('Various Device Initialization Failed!'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.InitializeVision: Boolean;
begin
  FireSplashMsg(elLocalizedString('Initializing Vision...'));

  Result := DoInitializeVision;

  if Result then
  begin
    Logger.FireLog(ltMessage, elLocalizedString('Vision System Initialization OK'), [ldLogViewer]);
  end
  else
  begin
    Logger.FireLog(ltError, elLocalizedString('Vision System Initialization Failed!'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.LoadConfiguration: Boolean;
var
  MissingActions : TStrings;
begin
  Result := True;

  FireSplashMsg(elLocalizedString('Loading System Configuration...'));

  LoadStatistics;

  if Assigned(FSysServer) then
  begin
    if not FileExists(SysInfoFile) then
    begin
      SysServer.LoadFromCSVFile(ConfigPath + SSysDefaultFile);

      if FileExists(ConfigPath + SMotionConfigChannelFile) then
      begin
        foUnionChannelsFromCSVFile(ConfigPath + SMotionConfigChannelFile, SysServer);
      end;

      SysServer.SaveToFile(SysInfoFile);
    end;

    if FileExists(SysInfoFile) then
    begin
      SysServer.LoadFromFile(SysInfoFile);
      if VerboseMode > 0 then
      begin
        CodeSite.SendXMLFile(SysInfoFile, SysInfoFile);
      end;


      if SysServer.ChannelExist(S_STARTUP_WITH_HW) then
        FStartUpWithHW := SysServer.AsBoolean[S_STARTUP_WITH_HW]
      else
        FStartUpWithHW := False;

      if SysServer.ChannelExist(S_STARTUP_WITH_VISION) then
        FStartUpWithVision := SysServer.AsBoolean[S_STARTUP_WITH_VISION]
      else
        FStartUpWithVision := False;
    end
    else
    begin
      Result := False;
      Logger.FireLog(ltError, Format('System Configuration File "%s" not found', [SysInfoFile]), [ldLogViewer, ldAlarmManager]);
    end;
  end;

  if Assigned(FIOServer) and
     FileExists(IOFile) then
  begin
    MissingActions := TStringList.Create;
    try
      IOServer.LoadFromCSVFile(IOFile);

      if VerboseMode > 0 then CodeSite.SendTextFile(IOFile, IOFile);

      foDataServerGetMissingActions(IOServer, MissingActions);
      if FileExists(ConfigPath + SVirtualChannelFile) then
      begin
        foUnionChannelsFromCSVFile(ConfigPath + SVirtualChannelFile, IOServer);
      end
      else
      begin
        Result := False;
        Logger.FireLog(ltError, Format('Virtual Channel File "%s" not found', [ConfigPath + SVirtualChannelFile]), [ldLogViewer, ldAlarmManager]);
      end;

      foDataServerGetMissingActions(IOServer, MissingActions);
      if FileExists(ConfigPath + SDIOChannelFile) then
      begin
        foUnionChannelsFromCSVFile(ConfigPath + SDIOChannelFile, IOServer);
      end
      else
      begin
        Result := False;
        Logger.FireLog(ltError, Format('DIO Channel File "%s" not found', [ConfigPath + SDIOChannelFile]), [ldLogViewer, ldAlarmManager]);
      end;


//      if FileExists(ConfigPath + SMotionVirtualChannelFile) then
//      begin
//        foUnionChannelsFromCSVFile(ConfigPath + SMotionVirtualChannelFile, IOServer);
//      end
//      else
//      begin
//        Result := False;
//        Logger.FireLog(ltError, Format('Motion Virtual Channel File "%s" not found', [ConfigPath + SMotionVirtualChannelFile]), [ldLogViewer, ldAlarmManager]);
//      end;
//
      if (VerboseMode > 0) and (MissingActions.Count > 0) then
        CodeSite.Send('IOServer MissingActions', MissingActions);
    finally
      MissingActions.Free;
    end;
  end
  else
  begin
    Result := False;
    Logger.FireLog(ltError, Format('I/O Configuration File "%s" not found', [IOFile]), [ldLogViewer, ldAlarmManager]);
  end;

  Result := DoLoadConfiguration;

  FConfigurationLoaded := Result;
end;

procedure TCustomEquipment.LoadStatistics;
var
  INI : TIniFile;
begin
  if Assigned(FStsServer) then
  begin
    if FileExists(ConfigPath + SStatisticsChannelFile) then
    begin
      FStsServer.LoadFromCSVFile(ConfigPath + SStatisticsChannelFile);
    end;
  end;

  INI := TIniFile.Create(INIFileName);
  try
    FOperationsTime.LoadFrom(INI);
    FOperationsTime.StandbyTime.StartAt := Now;
  finally
    INI.Free;
  end;
end;

function TCustomEquipment.ParseEnvironmentVariables(const AVar: string): String;
var
  I : Integer;
begin
  Result := AVar;

  Result := StringReplace(Result, '%DATE%', FormatDateTime('yyyy-MM-dd', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%SHORTDATE%', FormatDateTime('yy-MM-dd', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%TIME%', FormatDateTime('hhnnss', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%YEAR%', FormatDateTime('yyyy', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%MONTH%', FormatDateTime('MM', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%DAY%', FormatDateTime('dd', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%HOUR%', FormatDateTime('hh', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%MINUTE%', FormatDateTime('nn', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%SEC%', FormatDateTime('ss', Now), [SysUtils.rfReplaceAll]);
  Result := StringReplace(Result, '%MSEC%', FormatDateTime('zzz', Now), [SysUtils.rfReplaceAll]);

  for I := 0 to SysServer.Channels.Count - 1 do
  begin
    Result := StringReplace(Result, '%' + SysServer.Channels[I].Name +'%', SysServer.Channels[I].AsString, [SysUtils.rfReplaceAll]);
  end;

  for I := 0 to JobServer.Channels.Count - 1 do
  begin
    Result := StringReplace(Result, '%' + JobServer.Channels[I].Name +'%', JobServer.Channels[I].AsString, [SysUtils.rfReplaceAll]);
  end;

  for I := 0 to IOServer.Channels.Count - 1 do
  begin
    Result := StringReplace(Result, '%' + IOServer.Channels[I].Name +'%', IOServer.Channels[I].AsString, [SysUtils.rfReplaceAll]);
  end;
end;

procedure TCustomEquipment.EnsurePathExist(const APath: String);
begin
  if not DirectoryExists(APath) then
    ForceDirectories(APath);
end;

procedure TCustomEquipment.ReleaseError(const AAlarmCode: Integer);
begin
  AlarmManager.ReleaseAlarm(AAlarmCode);
end;

function TCustomEquipment.SaveConfiguration: Boolean;
begin
  Result := DoSaveConfiguration;
end;

procedure TCustomEquipment.SaveStatistics;
var
  INI : TIniFile;
begin
  if Assigned(FStsServer) then
  begin
    FStsServer.SaveToCSVFile(ConfigPath + SStatisticsChannelFile);
  end;

  INI := TIniFile.Create(INIFileName);
  try
    FOperationsTime.Stop;
    FOperationsTime.SaveTo(INI);
  finally
    INI.Free;
  end;
end;

procedure TCustomEquipment.SaveSysInfo;
begin
  if Assigned(FSysServer) then
    FSysServer.SaveToFile(SysInfoFile);

  SaveSysInfoOnClose := False;
end;

procedure TCustomEquipment.SetLotAlarmEndAt(const Value: TDateTime);
begin
  FLotAlarmEndAt := Value;
end;

procedure TCustomEquipment.SetLotIdleEndAt(const Value: TDateTime);
begin
  FLotIdleEndAt := Value;
end;

procedure TCustomEquipment.SetAutoMode(const Value: TEquipmentAutoMode);
begin
  if FAutoMode <> Value then
  begin
    FPrevAutoMode := FAutoMode;
    FAutoMode := Value;

    case FAutoMode of
      amIdle:
        begin
          if FPrevAutoMode in [amRun] then
          begin
            FRunEndedAt := Now;
            UpdateOperationRate;
          end;
        end;

      amRun:
        begin
          if FPrevAutoMode in [amIdle, amPaused] then
          begin
            FRunStartedAt := Now;
            UpdateOperationRate;
          end;
        end;

      amPaused:
        begin
          if FPrevAutoMode in [amRun] then
          begin
            FRunEndedAt := Now;
            UpdateOperationRate;
          end;
        end;
    end;
  end;
end;

procedure TCustomEquipment.SetOperationsTime(const Value: TEquipmentTime);
begin
  FOperationsTime.Assign(Value);
end;

procedure TCustomEquipment.SetState(const Value: TEquipmentARAMSState);
begin
  if FState <> Value then
  begin
    FPreviousState := FState;

    FState := Value;

    case FState of
      asStandBy:
        begin
          FOperationsTime.Stop;
          FOperationsTime.StandbyTime.StartAt := Now;
        end;

      asProductive:
        begin
          FOperationsTime.Stop;
          FOperationsTime.ProductiveTime.StartAt := Now;
        end;

      asEngineering:
        begin
          FOperationsTime.Stop;
          FOperationsTime.EngineeringTime.StartAt := Now;
        end;

      asUnscheduledDownTime:
        begin
          FOperationsTime.Stop;
          FOperationsTime.UnscheduledDownTime.StartAt := Now;
        end;

      asScheduledDownTime:
        begin
          FOperationsTime.Stop;
          FOperationsTime.ScheduledDownTime.StartAt := Now;
        end;

      asNonScheduledTime:
        begin
          FOperationsTime.Stop;
          //FOperationsTime.NonScheduledTime.StartAt := Now;
        end;
    end;

    DoUpdateState;
  end;
end;

procedure TCustomEquipment.SetVerboseMode(const Value: Integer);
begin
  FVerboseMode := Value;
  Logger.VerboseMode := FVerboseMode;
end;

function TCustomEquipment.SystemFinalize: Boolean;
begin
  Logger.FireLog(ltEnter, elLocalizedString('System Finalization'), [ldLogViewer]);
  try
    SaveStatistics;

    if ConfigurationLoaded then
    begin
      if SaveSysInfoOnClose then SaveSysInfo;
    end;

    FSystemLoaded := False;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Alarm Manager...'), [ldLogViewer]);
    AlarmManager.Active := False;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Digital IO Devices...'), [ldLogViewer]);
    FinalizeDIO;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Analog IO Devices...'), [ldLogViewer]);
    FinalizeAIO;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Motion Controller...'), [ldLogViewer]);
    FinalizeMotion;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Vision System...'), [ldLogViewer]);
    FinalizeVision;

    Logger.FireLog(ltMessage, elLocalizedString('Finalize Various Devices...'), [ldLogViewer]);
    FinalizeOther;

    DoSystemFinalize;
    Logger.FireLog(ltMessage, elLocalizedString('System Finalization OK.'), [ldLogViewer]);

    DoAfterFinalization;

    Result := True;
  finally
    Logger.FireLog(ltExit, elLocalizedString('System Finalization'), [ldLogViewer]);
  end;
end;

function TCustomEquipment.SystemInitialize: Boolean;
var
  V1, V2, V3, V4 : WORD;
begin
  Result := False;

  Logger.FireLog(ltClear, '', [ldLogViewer]);
  Logger.LogSystemInfo;
  Logger.LogVersionInfo;
  Logger.LogMemoryStatus;

  foGetBuildVersionInfo(ParamStr(0), V1, V2, V3, V4);
  Logger.FireLog(ltMessage, Format(elLocalizedString('Control S/W Version : %d.%d (Build : %d.%d.%d.%d)'), [V1, V2, V1, V2, V3, V4]), [ldLogViewer]);
  Logger.FireLog(ltEnter, elLocalizedString('System Initialization'), [ldLogViewer]);
  try

    if LoadConfiguration then
    begin
      Result := DoSystemInitialize;

      if StartUpWithHW then
      begin
        FireSplashMsg(elLocalizedString('Starting System H/W...'));

        if InitializeDIO then
        begin
          foDelay(300);

          if InitializeMotion then
          begin
            if InitializeOther then
            begin
              FSystemLoaded := True;

              foDelay(300);

              Result := True;

              Logger.FireLog(ltMessage,  elLocalizedString('System Initialization OK.'), [ldLogViewer]);
            end;
          end;
        end;
      end
      else
      begin
      	FSystemLoaded := True;
        Result := True;
      end;

      if StartUpWithVision then
      begin
        if InitializeVision then
        begin
          Result := True;
        end
        else
          Result := False;
      end;
    end;

    DoAfterInitialization;

    AlarmManager.Active := True;
  finally
    Logger.FireLog(ltExit, elLocalizedString('System Initialization'), [ldLogViewer]);
  end;
end;

procedure TCustomEquipment.UpdateLotAlarmTime;
begin
  FLotAccumulatedAlarmTime := FLotAccumulatedAlarmTime + (FLotAlarmEndAt - FLotAlarmStartAt);
end;

procedure TCustomEquipment.UpdateLotIdleTime;
begin
  FLotAccumulatedIdleTime := FLotAccumulatedIdleTime + (FLotIdleEndAt - FLotIdleStartAt);
end;

procedure TCustomEquipment.UpdateJobFileList(AList : TStrings);
var
  TmpList : TStrings;
  nIndex : Integer;
  szTmp : String;
begin
  TmpList := TStringList.Create;
  try
    foFindFiles(JobPath, SJobFileFilter, TmpList, False);

    AList.Clear;
    for nIndex := 0 to Pred(TmpList.Count) do
    begin
      szTmp := TPath.GetFileNameWithoutExtension(TmpList[nIndex]);
      if szTmp <> '' then
        AList.Add(szTmp);
    end;
    if AList.Count = 0 then
    begin
      AList.Add('DEFAULT');
    end;
  finally
    TmpList.Free;
  end;
end;

function TCustomEquipment.getJobFileList(Const JobName : String) : Boolean;
var
  TmpList : TStrings;
  nIndex : Integer;
  szTmp : String;
begin
  Result := False;
  TmpList := TStringList.Create;
  try
    foFindFiles(JobPath, SJobFileFilter, TmpList, False);

    for nIndex := 0 to Pred(TmpList.Count) do
    begin
      szTmp := TPath.GetFileNameWithoutExtension(TmpList[nIndex]);
      if UpperCase(szTmp) = UpperCase(JobName) then Result := True;
    end;
  finally
    TmpList.Free;
  end;
end;

procedure TCustomEquipment.UpdateOperationRate;
var
  Secs : Integer;
  WorkSecs : Double;
  OpRate : Double;
  Hour : Integer;
  I : Integer;
begin
  if FOperationRate.Count <= 23 then
  begin
    for I := 0 to (23 - FOperationRate.Count) do
    begin
      FOperationRate.Add(0.0);
      FOperationTime.Add(0.0);
    end;
  end;

  Hour := HourOf(Now);
  if FRunStartedAt < FRunEndedAt then
  begin
    Secs := SecondsBetween(FRunEndedAt, FRunStartedAt);
    FOperationTime[Hour] := FOperationTime[Hour] + Secs;
    WorkSecs := FOperationTime[Hour];
    FRunEndedAt := FRunStartedAt;
  end
  else if FRunStartedAt > FRunEndedAt then
  begin
    Secs := SecondsBetween(Now, FRunStartedAt);
    WorkSecs := FOperationTime[Hour] + Secs;
  end
  else
    WorkSecs := 0;

  if WorkSecs <> 0 then
  begin
    OpRate := SimpleRoundTo((WorkSecs / 3600) * 100, -3);
    FOperationRate[Hour] := OpRate;
  end;
end;

end.
