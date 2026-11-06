unit uJobBase;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  Variants,
  JPEG,
  Math,
  IOUtils,

  ZipForge,

  elMultiLanguage,

  foWinUtils,
  foDataServer,
  foDataServerUtils,
  foRectUtils,
  foLists,
  foTypes,

  uLogger,
  uEquipmentConsts,
  uEquipmentTypes,
  uEquipmentUtils,
  uEquipment;

type
  TCustomJob = class(TPersistent)
  private
    FJobServer: TfoDataServer;
    FFileName: string;
    FSysServer: TfoDataServer;
    FModified: Boolean;

    procedure SetJobServer(const Value: TfoDataServer);
    procedure SaveBitmap(AZip: TZipForge; const ArchiveFileName: string;
      ABitmap: TBitmap);
    procedure SavePersistent(AZip: TZipForge; const ArchiveFileName: string;
      AData: TPersistent);
    function GetJobName: string;
  protected
    function DefaultFileName : string;

    function DoExtractToStream(AZip : TZipForge; const ArchiveFileName : string; S : TMemoryStream) : Boolean;
    procedure DoLoadBitmap(AZip : TZipForge; const ArchiveFileName : string; ABitmap : TBitmap);
    procedure DoLoadPersistent(AZip : TZipForge; const ArchiveFileName : string; AData : TPersistent);
    procedure DoSaveBitmap(AZip : TZipForge; const ArchiveFileName : string; ABitmap : TBitmap);
    procedure DoSavePersistent(AZip : TZipForge; const ArchiveFileName : string; AData : TPersistent);
    procedure DoLoadStrings(AZip : TZipForge; const ArchiveFileName : string; AData : TStrings);
    procedure DoSaveStrings(AZip : TZipForge; const ArchiveFileName : string; AData : TStrings);

    procedure DoClear; virtual;
    procedure DoLoadFromFile(AZip : TZipForge); virtual;
    procedure DoSaveToFile(AZip : TZipForge); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadFromFile(const AFileName : string) : Boolean;
    function SaveToFile(const AFileName : string) : Boolean;
    function ExtractTo(const AFileName : string; const APath : string) : Boolean;
    function LoadDefault : Boolean;
    procedure SaveAsDefault;
    function Save : Boolean;
    procedure Clear;

    property JobName : string read GetJobName;
    property FileName : string read FFileName write FFileName;

    // 소유하는 객체가 아니고  반드시 외부 객체를 설정해야 함.
    property JobServer : TfoDataServer read FJobServer write SetJobServer;
    property SysServer : TfoDataServer read FSysServer write FSysServer;

    property Modified : Boolean read FModified write FModified;
  end;

implementation

procedure TCustomJob.Clear;
begin
  if not Assigned(FJobServer) then Exit;

  FJobServer.LoadFromCSVFile(Equipment.ConfigPath + SJobBaseFile);

  DoClear;
end;

constructor TCustomJob.Create;
begin
  inherited Create;

  FJobServer := nil;

  Clear;
end;

function TCustomJob.DefaultFileName: string;
begin
  Result := Equipment.DefaultJobFile;
end;

destructor TCustomJob.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomJob.DoClear;
begin
;
end;

function TCustomJob.DoExtractToStream(AZip: TZipForge; const ArchiveFileName: string;
  S: TMemoryStream): Boolean;
var
  AI : TZFArchiveItem;
begin
  Result := False;
  S.Clear;
  if AZip.FindFirst(ArchiveFileName, AI) then
  begin
    AZip.ExtractToStream(ArchiveFileName, S);
    S.Position := 0;
    Result := True;
  end;
end;

procedure TCustomJob.DoLoadBitmap(AZip: TZipForge; const ArchiveFileName: string;
  ABitmap: TBitmap);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    ABitmap.SetSize(0, 0);
    if DoExtractToStream(AZip, ArchiveFileName, MS) then
      ABitmap.LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoLoadFromFile(AZip: TZipForge);
begin
;
end;

procedure TCustomJob.DoLoadPersistent(AZip: TZipForge; const ArchiveFileName: string;
  AData: TPersistent);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    if DoExtractToStream(AZip, ArchiveFileName, MS) then
      foObjectFromXmlStream(AData, MS);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoLoadStrings(AZip: TZipForge;
  const ArchiveFileName: string; AData: TStrings);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    AData.Clear;
    if DoExtractToStream(AZip, ArchiveFileName, MS) then
      AData.LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoSaveBitmap(AZip: TZipForge; const ArchiveFileName: string;
  ABitmap: TBitmap);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    if (ABitmap.Width > 0) and (ABitmap.Height > 0) then
    begin
      MS.Clear;
      ABitmap.SaveToStream(MS);
      MS.Position := 0;
      AZip.AddFromStream(ArchiveFileName, MS);
    end;
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoSavePersistent(AZip: TZipForge; const ArchiveFileName: string;
  AData: TPersistent);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.Clear;
    foObjectToXmlStream(AData, MS);
    MS.Position := 0;
    AZip.AddFromStream(ArchiveFileName, MS);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoSaveStrings(AZip: TZipForge; const ArchiveFileName: string; AData: TStrings);
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.Clear;
    AData.SaveToStream(MS);
    MS.Position := 0;
    AZip.AddFromStream(ArchiveFileName, MS);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.DoSaveToFile(AZip: TZipForge);
begin
end;

function TCustomJob.ExtractTo(const AFileName : string; const APath: string): Boolean;
var
  Zip : TZipForge;
begin
  Result := False;
  if FileExists(AFileName) and DirectoryExists(APath) then
  begin
    Zip := TZipForge.Create(nil);
    try
      Zip.BaseDir := APath;
      Zip.FileName := AFileName;
      Zip.OpenArchive;
      try
        Zip.ExtractFiles('*.*');
        Logger.FireLog(ltMessage, Format(elLocalizedString('Extracted %s To %s'), [AFileName, APath]));
      finally
        Zip.CloseArchive;
      end;
    finally
      Zip.Free;
    end;
  end
  else
  begin
    if not FileExists(AFileName) then
      Logger.FireLog(ltError, Format(elLocalizedString('%s does not exist.'), [AFileName]));
    if not DirectoryExists(APath) then
      Logger.FireLog(ltError, Format(elLocalizedString('%s does not exist.'), [APath]));
  end;
end;

function TCustomJob.GetJobName: string;
begin
  Result := TPath.GetFileNameWithoutExtension(FFileName);
end;

function TCustomJob.LoadDefault: Boolean;
begin
  if FileExists(DefaultFileName) then
  begin
    LoadFromFile(DefaultFileName);
  end
  else
  begin
    Clear;
  end;
  Result := True;
end;

function TCustomJob.LoadFromFile(const AFileName: string) : Boolean;
var
  MS : TMemoryStream;
  DS : TfoDataServer;
  I : Integer;
  Zip : TZipForge;
begin
  ASSERT(Assigned(FJobServer), 'Not Assigned JobServer');

  Result := False;

  if FileExists(AFileName) then
  begin
    FFileName := AFileName;
    MS := TMemoryStream.Create;
    DS := TfoDataServer.Create(nil);
    try
      Zip := TZipForge.Create(nil);
      try
        Zip.BaseDir := Equipment.JobExtractPath;
        Zip.FileName := AFileName;
        Zip.OpenArchive;
        try
          if DoExtractToStream(Zip, SJobInfoFile, MS) then
          begin
            MS.Position := 0;
            JobServer.LoadFromStream(MS);

            DS.LoadFromCSVFile(Equipment.ConfigPath + SJobBaseFile);
            foSynchronizeChannels(DS, JobServer);
          end;

          DoLoadFromFile(Zip);
        finally
          Zip.CloseArchive;
        end;
      finally
        Zip.Free;
      end;
      Logger.FireLog(ltMessage, Format(elLocalizedString('Job Loaded - %s'), [TPath.GetFileNameWithoutExtension(AFileName)]), [ldLogViewer]);
      FModified := False;
      Result := True;
    finally
      DS.Free;
      MS.Free;
    end;
  end;
end;

function TCustomJob.Save: Boolean;
begin
  if FFileName <> '' then
    Result := SaveToFile(FFileName)
  else
  begin
    SaveAsDefault;
    Result := True;
  end;
end;

procedure TCustomJob.SaveAsDefault;
begin
  SaveToFile(DefaultFileName);
end;

procedure TCustomJob.SaveBitmap(AZip: TZipForge; const ArchiveFileName: string;
  ABitmap: TBitmap);
begin

end;

procedure TCustomJob.SavePersistent(AZip: TZipForge; const ArchiveFileName: string; AData: TPersistent);
begin

end;

function TCustomJob.SaveToFile(const AFileName: string) : Boolean;
var
  MS : TMemoryStream;
  I : Integer;
  Zip : TZipForge;
begin
  ASSERT(Assigned(FJobServer), 'Not Assigned JobServer');
  Result := False;

  FFileName := AFileName;

  MS := TMemoryStream.Create;
  try
    Zip := TZipForge.Create(nil);
    try
      Zip.BaseDir := Equipment.JobExtractPath;
      Zip.FileName := AFileName;
      Zip.OpenArchive;
      try
        JobServer.SaveToStream(MS);
        MS.Position := 0;
        Zip.AddFromStream(SJobInfoFile, MS);

        DoSaveToFile(Zip);
      finally
        Zip.CloseArchive;
      end;
    finally
      Zip.Free;
    end;
    FModified := False;
    Logger.FireLog(ltMessage, Format(elLocalizedString('Job Saved - %s'), [TPath.GetFileNameWithoutExtension(AFileName)]), [ldLogViewer]);
  finally
    MS.Free;
  end;
end;

procedure TCustomJob.SetJobServer(const Value: TfoDataServer);
begin
  FJobServer := Value;
end;

end.
