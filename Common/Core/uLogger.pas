unit uLogger;

{$IFNDEF QVIX_LEGACY_LOGGER}

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs, CodeSiteLogging;

type
  TQVIXLogEvent = procedure(const ASource, AMessage: string) of object;

procedure QVIXLog(const ASource, AMessage: string);
procedure ClearQVIXLog;
function QVIXLogFileName: string;
procedure SetQVIXLogHandler(const AHandler: TQVIXLogEvent);

implementation

const
  MAX_QVIX_LOG_ITEMS = 2000;

var
  QVIXLogCS: TCriticalSection;
  QVIXLogHandler: TQVIXLogEvent;

function QVIXLogFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.log');
end;

procedure SaveLogLine(const ALine: string);
var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    if FileExists(QVIXLogFileName) then
      try
        Lines.LoadFromFile(QVIXLogFileName);
      except
        Lines.Clear;
      end;
    Lines.Add(ALine);
    while Lines.Count > MAX_QVIX_LOG_ITEMS do
      Lines.Delete(0);
    Lines.SaveToFile(QVIXLogFileName);
  finally
    Lines.Free;
  end;
end;

procedure QVIXLog(const ASource, AMessage: string);
var
  Handler: TQVIXLogEvent;
  MessageText: string;
begin
  MessageText := StringReplace(AMessage, #9, ' ', [rfReplaceAll]);
  CodeSite.SendFmtMsg('[%s] %s', [ASource, MessageText]);
  QVIXLogCS.Enter;
  try
    try
      SaveLogLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + #9 +
        ASource + #9 + MessageText);
    except
      { Logging must not stop equipment operation. }
    end;
    Handler := QVIXLogHandler;
  finally
    QVIXLogCS.Leave;
  end;
  if Assigned(Handler) then
    Handler(ASource, MessageText);
end;

procedure ClearQVIXLog;
var
  Lines: TStringList;
begin
  QVIXLogCS.Enter;
  try
    Lines := TStringList.Create;
    try
      Lines.SaveToFile(QVIXLogFileName);
    finally
      Lines.Free;
    end;
  finally
    QVIXLogCS.Leave;
  end;
end;

procedure SetQVIXLogHandler(const AHandler: TQVIXLogEvent);
begin
  QVIXLogCS.Enter;
  try
    QVIXLogHandler := AHandler;
  finally
    QVIXLogCS.Leave;
  end;
end;

initialization
  QVIXLogCS := TCriticalSection.Create;
  QVIXLogHandler := nil;

finalization
  QVIXLogHandler := nil;
  QVIXLogCS.Free;

{$ELSE}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,

  CodeSiteLogging,

  elBase,
  elLog,
  elStringUtils,

  foTypes,
  foAlarmManager;

type
  TLogDestinations = set of (
    ldLogViewer,
    ldFile,
    ldAlarmManager
  );

const
  DefaultLogDestinations = [];

type
  TLogEvent = procedure (Sender : TObject; const ALogType : TfoLogType; const ALogMsg : string; const ADestinations : TLogDestinations) of object;

  TLogger = class(TComponent)
  private
    FVerboseMode: Integer;

    FProductionLogger: TelLog;

    FcsProperties: TCodeSiteProperties;
    FcsdGlobal: TCodeSiteDestination;

    FcsdFile: TCodeSiteDestination;
    FcsFile: TCodeSiteLogger;

    FcsdVision: TCodeSiteDestination;
    FcsVision: TCodeSiteLogger;

    FcsdAligner: TCodeSiteDestination;
    FcsAligner: TCodeSiteLogger;

    FOnAlignerLog: TLogEvent;
    FOnVisionLog: TLogEvent;
    FOnLog: TLogEvent;

    function GetLiveLogger: TCodeSiteLogger;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DoFireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const ADestinations : TLogDestinations);

    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : Integer; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : Double; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : TPoint; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : TRect; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : Boolean; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; const AValue : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; AComponent : TComponent; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string; ABitmap : TBitmap; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : Integer; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : Double; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : TPoint; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : TRect; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : Boolean; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const AValue : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; AComponent : TComponent; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; ABitmap : TBitmap; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : Integer; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : Double; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : TPoint; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : TRect; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : Boolean; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; const AValue : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; AComponent : TComponent; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALiveViewerLevel : Integer; const ALogMsg : string; ABitmap : TBitmap; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireLog(const ALogMsg : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : Integer; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : Double; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : TPoint; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : TRect; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : Boolean; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; const AValue : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; AComponent : TComponent; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireLog(const ALogMsg : string; ABitmap : TBitmap; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireFmtLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const AFormat : string; const AArgs : array of const; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;
    procedure FireFmtLog(const AFormat : string; const AArgs : array of const; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireLog(const ALiveViewerLevel : Integer; const AMsgType : Integer; const ALogMsg : string; const ADestinations : TLogDestinations = DefaultLogDestinations); overload;

    procedure FireVisionLog(const ALogType : TfoLogType; const ALogMsg : string); overload;
    procedure FireVisionLog(const ALogMsg : string); overload;

    procedure FireAlignerLog(const ALiveViewerLevel : Integer; const ALogType : TfoLogType; const ALogMsg : string); overload;
    procedure FireAlignerLog(const ALogType : TfoLogType; const ALogMsg : string); overload;
    procedure FireAlignerLog(const ALogMsg : string); overload;
    procedure FireAlignerLog(const ALogMsg : string; const ABitmap : TBitmap); overload;

    procedure LogSystemInfo;
    procedure LogVersionInfo;
    procedure LogMemoryStatus;

    property VerboseMode : Integer read FVerboseMode write FVerboseMode;

    property LiveDestination : TCodeSiteDestination read FcsdGlobal;
    property LiveLogger : TCodeSiteLogger read GetLiveLogger;
    property LiveLoggerProperties : TCodeSiteProperties read FcsProperties;

    property FileDestination : TCodeSiteDestination read FcsdFile;
    property FileLogger : TCodeSiteLogger read FcsFile;

    property VisionDestination : TCodeSiteDestination read FcsdVision;
    property VisionLogger : TCodeSiteLogger read FcsVision;

    property AlignerDestination : TCodeSiteDestination read FcsdAligner;
    property AlignerLogger : TCodeSiteLogger read FcsAligner;

    property ProductionLogger : TelLog read FProductionLogger;

    property OnLog : TLogEvent read FOnLog write FOnLog;
    property OnVisionLog : TLogEvent read FOnVisionLog write FOnVisionLog;
    property OnAlignerLog : TLogEvent read FOnAlignerLog write FOnAlignerLog;
  end;


function Logger : TLogger;

implementation

var
  LoggerInstance : TLogger;

function Logger : TLogger;
begin
  if not Assigned(LoggerInstance) then
    LoggerInstance := TLogger.Create(nil);
  Result := LoggerInstance;
end;

{ TLogger }

constructor TLogger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FVerboseMode := 0;
  
  FcsdGlobal := TCodeSiteDestination.Create(Self);
  with FcsdGlobal do
  begin
    Name := 'csdGlobal';
    Viewer.Active := True;
  end;

  FcsProperties := TCodeSiteProperties.Create(Self);
  with FcsProperties do
  begin
    Name := 'csProperties';
    Category := 'Controller';
    CategoryColor := clWindow;
    CategoryFontColor := clWindowText;
    Destination := FcsdGlobal;
  end;

  FcsdFile := TCodeSiteDestination.Create(Self);
  with FcsdFile do
  begin
    Name := 'csdFile';
    LogFile.FilePath := '$(MyDocs)';
    LogFile.FileName := 'system.csl';
    LogFile.MaxSize := 10240;
    LogFile.Active := True;
  end;

  FcsFile := TCodeSiteLogger.Create(Self);
  with FcsFile do
  begin
    Name := 'csFile';
    Destination := FcsdFile;
  end;

  FcsdVision := TCodeSiteDestination.Create(Self);
  with FcsdVision do
  begin
    Name := 'csdVision';
    Viewer.Active := True;
  end;

  FcsVision := TCodeSiteLogger.Create(Self);
  with FcsVision do
  begin
    Name := 'csVision';
    Category := 'Vision';
    CategoryColor := $00E6E0C4;
    CategoryFontColor := clWindowText;
    Destination := FcsdVision;
  end;

  FcsdAligner := TCodeSiteDestination.Create(Self);
  with FcsdAligner do
  begin
    Name := 'csdAligner';
    Viewer.Active := True;
  end;

  FcsAligner := TCodeSiteLogger.Create(Self);
  with FcsAligner do
  begin
    Name := 'csAligner';
    Category := 'Aligner';
    CategoryColor := $00DEF5DC;
    CategoryFontColor := clWindowText;
    Destination := FcsdAligner;
  end;

  FProductionLogger := TelLog.Create(Self);
  with FProductionLogger do
  begin
    Name := 'ProductionLogger';
    Active := False;
    DateFormat := 'yyyymmdd';
    Delimiter := ',';
    FileName := 'ProductInfo.log';

    LogBy := lbNone;
    Options := [loAppendDate, loAppendTime, loAppendLineBreak, loImmediateFlush];
  end;
end;

destructor TLogger.Destroy;
begin
  inherited;
end;

procedure TLogger.DoFireLog(const ALiveViewerLevel: Integer; const ALogType: TfoLogType;
  const ALogMsg: string; const ADestinations: TLogDestinations);
begin
  if (FVerboseMode > 0) and (FVerboseMode >= ALiveViewerLevel) then
  begin
    case ALogType of
      ltEnter: LiveLogger.EnterMethod(ALogMsg);
      ltExit: LiveLogger.ExitMethod(ALogMsg);

      ltSend,
      ltRecv,
      ltScript,
      ltMessage: LiveLogger.Send(ALogMsg);

      ltWarning: LiveLogger.SendWarning(ALogMsg);
      ltError: LiveLogger.SendError(ALogMsg);
      ltFlag:
        begin
          LiveLogger.Send(ALogMsg);
        end;
      ltInfo: LiveLogger.SendNote(ALogMsg);
      ltSeparator: LiveLogger.AddSeparator;
      ltClear :
      begin
        LiveLogger.Clear;
      end;
    end;
  end;

  if ldFile in ADestinations then
  begin
    case ALogType of
      ltEnter: FileLogger.EnterMethod(ALogMsg);
      ltExit: FileLogger.ExitMethod(ALogMsg);

      ltSend,
      ltRecv,
      ltScript,
      ltMessage: FileLogger.Send(ALogMsg);

      ltWarning: FileLogger.SendWarning(ALogMsg);
      ltError: FileLogger.SendError(ALogMsg);
      ltFlag:
        begin
          FileLogger.Send(ALogMsg);
        end;
      ltInfo: FileLogger.SendNote(ALogMsg);
      ltSeparator: FileLogger.AddSeparator;
    end;
  end;

  if ldAlarmManager in ADestinations then
  begin
    case ALogType of
      ltSend,
      ltRecv,
      ltScript,
      ltInfo,
      ltMessage: AlarmManager.AddMessage(MT_NORMAL, ALogMsg);
      ltWarning: AlarmManager.AddMessage(MT_WARNING, ALogMsg);
      ltError: AlarmManager.AddMessage(MT_ERROR, ALogMsg);
    end;
  end;

  if Assigned(FOnLog) then
    FOnLog(Self, ALogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(FVerboseMode, ALogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ltMessage, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const AValue: TPoint;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const AValue: TRect;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const AValue: Integer;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const AValue: Double;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; AComponent: TComponent;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AComponent, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; ABitmap: TBitmap;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, ABitmap, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogMsg: string; const AValue: Boolean;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer; const ALogMsg,
  AValue: string; const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const AValue: TPoint; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const AValue: TRect; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const AValue: Integer; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const AValue: Double; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  AComponent: TComponent; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AComponent, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  ABitmap: TBitmap; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, ABitmap, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const AValue: Boolean; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogType: TfoLogType; const ALogMsg,
  AValue: string; const ADestinations: TLogDestinations);
begin
  FireLog(FVerboseMode, ALogType, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; const AValue: TPoint;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> (%d, %d)', [ALogMsg, AValue.X, AValue.Y]), ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; const AValue: Double;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> %g', [ALogMsg, AValue]), ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; const AValue: Integer;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> %d', [ALogMsg, AValue]), ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; const AValue: TRect;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> (%d, %d, %d, %d) W:%d, H:%d', [ALogMsg, AValue.Left, AValue.Top, AValue.Right, AValue.Bottom, AValue.Right-AValue.Left, AValue.Bottom-AValue.Top]), ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; ABitmap: TBitmap;
  const ADestinations: TLogDestinations);
begin
  if (FVerboseMode > 0) and (FVerboseMode >= ALiveViewerLevel) then
  begin
    LiveLogger.Send(ALogMsg, ABitmap);
  end;

  if ldFile in ADestinations then
  begin
    FileLogger.Send(ALogMsg, ABitmap);
  end;

  if Assigned(FOnLog) then
    FOnLog(Self, ALogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; AComponent: TComponent;
  const ADestinations: TLogDestinations);
begin
  if (FVerboseMode > 0) and (FVerboseMode >= ALiveViewerLevel) then
  begin
    LiveLogger.SendComponents(ALogMsg, AComponent);
  end;

  if ldFile in ADestinations then
  begin
    FileLogger.SendComponents(ALogMsg, AComponent);
  end;

  if Assigned(FOnLog) then
    FOnLog(Self, ALogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string; const AValue: Boolean;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> %s', [ALogMsg, BoolToStr(AValue, True)]), ADestinations);
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg, AValue: string;
  const ADestinations: TLogDestinations);
begin
  DoFireLog(ALiveViewerLevel, ALogType, Format('%s -> %s', [ALogMsg, AValue]), ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; const AValue: Double;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; const AValue: TPoint;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; const AValue: Integer;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg, AValue: string;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; ABitmap: TBitmap;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, ABitmap, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; const AValue: TRect;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; const AValue: Boolean;
  const ADestinations: TLogDestinations);
begin
  FireLog(ltMessage, ALogMsg, AValue, ADestinations);
end;

procedure TLogger.FireLog(const ALogMsg: string; AComponent: TComponent;
  const ADestinations: TLogDestinations);
begin
  if (FVerboseMode > 0) then
  begin
    LiveLogger.SendComponents(ALogMsg, AComponent);
  end;

  if ldFile in ADestinations then
  begin
    FileLogger.SendComponents(ALogMsg, AComponent);
  end;
end;

procedure TLogger.FireLog(const ALiveViewerLevel: Integer; const AMsgType: Integer; const ALogMsg: string;
  const ADestinations: TLogDestinations);
var
  LogType : TfoLogType;
begin
  case AMsgType of
    MT_WARNING : LogType := ltWarning;
    MT_ERROR : LogType := ltError;
    MT_ENTER_METHOD : LogType := ltEnter;
    MT_EXIT_METHOD : LogType := ltExit;
    else
      LogType := ltMessage;
  end;

  FireLog(ALiveViewerLevel, LogType, ALogMsg, ADestinations);
end;

procedure TLogger.FireAlignerLog(const ALogMsg: string);
begin
  FireAlignerLog(ltMessage, ALogMsg);
end;

procedure TLogger.FireAlignerLog(const ALogType: TfoLogType;
  const ALogMsg: string);
begin
  FireAlignerLog(1, ALogType, ALogMsg);
end;

procedure TLogger.FireAlignerLog(const ALogMsg: string; const ABitmap: TBitmap);
begin
  AlignerLogger.Send(ALogMsg, ABitmap);

  if Assigned(FOnAlignerLog) then
    FOnAlignerLog(Self, ltMessage, ALogMsg, DefaultLogDestinations);
end;

procedure TLogger.FireFmtLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const AFormat: string; const AArgs: array of const;
  const ADestinations: TLogDestinations);
begin
  FireLog(ALiveViewerLevel, ALogType, Format(AFormat, AArgs), ADestinations);
end;

procedure TLogger.FireFmtLog(const AFormat: string;
  const AArgs: array of const; const ADestinations : TLogDestinations);
begin
  FireLog(Format(AFormat, AArgs), ADestinations);
end;

procedure TLogger.FireAlignerLog(const ALiveViewerLevel: Integer;
  const ALogType: TfoLogType; const ALogMsg: string);
begin
  if (FVerboseMode > 0) and (FVerboseMode >= ALiveViewerLevel) then
  begin
    case ALogType of
      ltEnter: AlignerLogger.EnterMethod(ALogMsg);
      ltExit: AlignerLogger.ExitMethod(ALogMsg);
      ltMessage: AlignerLogger.Send(ALogMsg);
      ltWarning: AlignerLogger.SendWarning(ALogMsg);
      ltError: AlignerLogger.SendError(ALogMsg);
      ltFlag:
        begin
          AlignerLogger.Send(ALogMsg);
        end;
      ltInfo: AlignerLogger.SendNote(ALogMsg);
      ltSeparator: AlignerLogger.AddSeparator;
    end;

    if Assigned(FOnAlignerLog) then
      FOnAlignerLog(Self, ALogType, ALogMsg, DefaultLogDestinations);
  end;
end;

procedure TLogger.FireVisionLog(const ALogMsg: string);
begin
  FireVisionLog(ltMessage, ALogMsg);
end;

procedure TLogger.FireVisionLog(const ALogType: TfoLogType;
  const ALogMsg: string);
begin
  case ALogType of
    ltEnter: VisionLogger.EnterMethod(ALogMsg);
    ltExit: VisionLogger.ExitMethod(ALogMsg);
    ltMessage: VisionLogger.Send(ALogMsg);
    ltWarning: VisionLogger.SendWarning(ALogMsg);
    ltError: VisionLogger.SendError(ALogMsg);
    ltFlag:
      begin
        VisionLogger.Send(ALogMsg);
      end;
    ltInfo: VisionLogger.SendNote(ALogMsg);
    ltSeparator: VisionLogger.AddSeparator;
  end;
  if Assigned(FOnVisionLog) then
    FOnVisionLog(Self, ALogType, ALogMsg, DefaultLogDestinations);
end;

function TLogger.GetLiveLogger: TCodeSiteLogger;
begin
  Result := CodeSite;
end;

procedure TLogger.LogMemoryStatus;
begin
  if (FVerboseMode > 0) then
  begin
    LiveLogger.SendMemoryStatus;
  end;
end;

procedure TLogger.LogSystemInfo;
begin
  if (FVerboseMode > 0) then
  begin
    LiveLogger.SendSystemInfo;
  end;
end;

procedure TLogger.LogVersionInfo;
begin
  if (FVerboseMode > 0) then
  begin
    LiveLogger.SendVersionInfo;
  end;
end;

initialization
  LoggerInstance := nil;

finalization
  if Assigned(LoggerInstance) then
    FreeAndNil(LoggerInstance);
{$ENDIF}
end.
