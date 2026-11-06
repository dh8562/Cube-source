unit uEquipment;

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
  IniFiles,
  Registry,
  TypInfo,
  ComCtrls,
  ActiveX,
  ComObj,
  OleServer,
  Variants,
  Graphics,
  DateUtils,

  CodeSiteLogging,

  foAlarmManager,
  foDataServer,
  foDataServerUtils,
  foMotion,
  foWinUtils,
  foLists,
  foTypes,
  foUserManager,
  foStringUtils,

  elMultiLanguage,
  elLog,

  voGeometry,
  voCustomDefectViewer,
  voStripViewer,
  voVision,
  voLiveVision,
  voRectUtils,

  uLogger,
  uUserManager,
  uAlarmConsts,
  uRecipe,
  uEquipmentConsts,
  uEquipmentUtils,
  uEquipmentTypes,
  uEquipmentBase;

{$I uJobServer.inc}
{$I uSysServer.inc}
{$I uIOServer.inc}
{$I uRecipeServer.inc}

const
  ALL_IMAGE_SAVE = 0;
  FAIL_IMAGE_SAVE = 1;

  SDefaultProductionSettingFile = 'DefProductionSetting.csv';
  SProductionSettingFile = 'ProductionSetting.xml';

type
  TAlignEquipment = class(TCustomEquipment)
  private
    FMultiLanguage: TelMultiLanguage;
    FProductionSetting: TfoDataServer;
    FActiveRecipeName: string;

    FActiveLanguage : Integer;
  protected
    function DoLoadConfiguration : Boolean; override;
    function DoSaveConfiguration : Boolean; override;
//    function DoInitializeAIO : Boolean; override;
//    function DoFinalizeAIO : Boolean; override;
//    function DoInitializeMotion : Boolean; override;
//    function DoFinalizeMotion : Boolean; override;

    function DoSystemFinalize : Boolean; override;
    procedure DoAfterInitialization; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function CheckJobParameters : Boolean;
    function SaveProductionSetting : Boolean;

    procedure LogCurrentProductionInfo(const hGrabTime : TDateTime; const nCount : Integer; const logData : TelLog);

    property ProductionSetting: TfoDataServer read FProductionSetting write FProductionSetting;
    property PS : TfoDataServer read FProductionSetting write FProductionSetting;

    property ActiveLanguage : Integer read FActiveLanguage write FActiveLanguage;
  end;

function Equipment : TAlignEquipment;

implementation

uses
  uJob,
  dmHAL;

var
  _Instance : TAlignEquipment;

function Equipment : TAlignEquipment;
begin
  if not Assigned(_Instance) then
    _Instance := TAlignEquipment.Create;
  Result := _Instance;
end;

{ TAlignEquipment }
function TAlignEquipment.CheckJobParameters: Boolean;
begin
  Result := True;
end;

constructor TAlignEquipment.Create;
var
  I: Integer;
begin
  inherited;

  FActiveLanguage := 2;

end;

destructor TAlignEquipment.Destroy;
begin
  inherited;
end;

procedure TAlignEquipment.DoAfterInitialization;
begin
  HAL.AfterInitialization;
end;

//function TAlignEquipment.DoFinalizeAIO: Boolean;
//begin
//  Result := True;
//end;
//
//function TAlignEquipment.DoFinalizeMotion: Boolean;
//begin
//  Result := True;
//end;
//
//function TAlignEquipment.DoInitializeAIO: Boolean;
//begin
//  Result := True;
//end;
//
//function TAlignEquipment.DoInitializeMotion: Boolean;
//begin
//  Result := True;
//end;

function TAlignEquipment.DoLoadConfiguration: Boolean;
var
  ProductionSettingFile : string;
  DS : TfoDataServer;
begin
	Result := True;
  exit;

  if Assigned(FProductionSetting) then
  begin
    ProductionSettingFile := ConfigPath + SProductionSettingFile;

    if not FileExists(ProductionSettingFile) then
    begin
      FProductionSetting.LoadFromCSVFile(ConfigPath + SDefaultProductionSettingFile);

      Logger.FireLog(ltMessage, Format('Create Production Setting File "%s"', [ProductionSettingFile]), [ldLogViewer]);
      FProductionSetting.SaveToFile(ProductionSettingFile);
    end;

    if FileExists(ConfigPath + SProductionSettingFile) then
    begin
      DS := TfoDataServer.Create(nil);
      try
        foUnionChannelsFromCSVFile(ConfigPath + SDefaultProductionSettingFile, DS);
        foUnionChannelsFromCSVFile(ConfigPath + 'DefSortSetting.csv', DS);
        foUnionChannelsFromCSVFile(ConfigPath + 'DefSortTiming.csv', DS);
        foUnionChannelsFromCSVFile(ConfigPath + 'DefLoaderTiming.csv', DS);

        FProductionSetting.LoadFromFile(ProductionSettingFile);
        foSynchronizeChannels(DS, FProductionSetting);
      finally
        DS.Free;
      end;

      Result := True;
    end
    else
    begin
      Result := False;
      Logger.FireLog(ltError, Format('Production Setting File "%s" not found', [ProductionSettingFile]), [ldLogViewer, ldAlarmManager]);
    end;
  end;
end;

function TAlignEquipment.DoSaveConfiguration: Boolean;
begin
  SaveProductionSetting;
end;

function TAlignEquipment.DoSystemFinalize: Boolean;
begin
  Result := HAL.AfterFinalization;
end;

procedure TAlignEquipment.LogCurrentProductionInfo(const hGrabTime : TDateTime; const nCount : Integer; const logData : TelLog);
var
  szDir : String;
  szFileName : String;
  szHeader : String;
  Strs : TStrings;
  I: Integer;
begin
  Strs := TStringList.Create;
  try
    szHeader := 'DATE,TIME,COUNT,';
    Strs.Add(FormatDateTime('yyyy-mm-dd', hGrabTime));
    Strs.Add(FormatDateTime('hh:nn:ss', hGrabTime));
    Strs.Add(Format('%d',[nCount]));

    szDir := Trim(HAL.SysServer.AsString[S_PRODUCT_LOG_FILE_PATH]);
    if szDir = '' then szDir := 'c:\data\' else szDir := szDir + '\';
    EnsurePathExist(szDir);

    szDir := szDir + formatDateTime('yyyy\', now);
    EnsurePathExist(szDir);

    szDir := szDir + formatDateTime('MM\', now);
    EnsurePathExist(szDir);

    szDir := szDir + formatDateTime('dd\', now);
    EnsurePathExist(szDir);

    szFileName := 'report.csv';

    logData.LogPath := szDir;
    logData.FileName := szFileName; //ParseEnvironmentVariables(HAL.SysServer.AsString[S_PRODUCT_LOG_FILE_NAME]);
    logData.Header := szHeader;

    logData.Active := True;
    logData.Add(Strs.CommaText);
    logData.Active := False;
  finally
    Strs.Free;
  end;
end;

function TAlignEquipment.SaveProductionSetting: Boolean;
begin
  if Assigned(FProductionSetting) then
  begin
    FProductionSetting.SaveToFile(ConfigPath + SProductionSettingFile);
  end;
end;

initialization

finalization
  if Assigned(_Instance) then
    _Instance.Free;

end.
