unit uRecipe;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  Variants,
  JPEG,
  Math,
  Forms,

  ZipForge,

  elMultiLanguage,

  foWinUtils,
  foDataServer,
  foDataServerUtils,
  foRectUtils,
  foLists,
  foButtonEdit,
  foChannelSpy,
  foEditCtrls,
  foTypes,

  voVision,

  uLogger,
  uEquipmentTypes,
  uEquipmentConsts;

const
  MAX_RECIPE_OPERATION_COUNT = 10;

type
  TMagnetOperationType = (
    otTime,
    otCycle
  );

  TRecipe = class(TPersistent)
  private
    FRecipeServer : TfoDataServer;
    FFileName: string;
    FDefaultRecipeFile: string;
    FDefaultRecipeDataFile: string;
    FOnChannelChanged: TfoChannelChanged;
    FOnLog: TLogEvent;

    procedure DataServerChannelChanged(Sender: TObject; AChannel: TfoChannel);

    function GetUpperHeaterTemp(Index: Integer): Double;


    procedure FireLog(const ALogType : TfoLogType; const ALogMsg : string; const ADestinations : TLogDestinations); overload;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadFromFile(const AFileName : string) : Boolean;
    function SaveToFile(const AFileName : string) : Boolean;
    function LoadDefault : Boolean;
    procedure SaveAsDefault;
    procedure Save;
    procedure AssignRecipeServer(AForm : TCustomForm; ADataServer : TfoDataServer);

    property DefaultRecipeFile : string read FDefaultRecipeFile write FDefaultRecipeFile;
    property DefaultRecipeDataFile : string read FDefaultRecipeDataFile write FDefaultRecipeDataFile;
    property FileName : string read FFileName write FFileName;
    property RecipeServer : TfoDataServer read FRecipeServer write FRecipeServer;

    property UpperHeaterTemp[Index : Integer] : Double read GetUpperHeaterTemp;

    property OnChannelChanged : TfoChannelChanged read FOnChannelChanged write FOnChannelChanged;
    property OnLog : TLogEvent read FOnLog write FOnLog;
  end;

function Recipe : TRecipe;

implementation

var
  _Recipe : TRecipe;


function Recipe : TRecipe;
begin
  if not Assigned(_Recipe) then
    _Recipe := TRecipe.Create;

  Result := _Recipe;
end;

{ TRecipe }

procedure TRecipe.AssignRecipeServer(AForm: TCustomForm;
  ADataServer: TfoDataServer);
var
  I : Integer;
begin
  for I := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[I] is TfoButtonEdit then
    begin
      TfoButtonEdit(AForm.Components[I]).ChannelLink.DataServer := ADataServer;
    end
    else if AForm.Components[I] is TfoChannelSpy then
    begin
      TfoChannelSpy(AForm.Components[I]).DataServer := ADataServer;
    end
    else if AForm.Components[I] is TfoCheckBox then
    begin
      TfoCheckBox(AForm.Components[I]).ChannelLink.DataServer := ADataServer;
    end;
  end;
end;

constructor TRecipe.Create;
begin
  inherited Create;
end;

procedure TRecipe.DataServerChannelChanged(Sender: TObject;
  AChannel: TfoChannel);
begin
  if Assigned(FOnChannelChanged) then
    FOnChannelChanged(Sender, AChannel);
end;

destructor TRecipe.Destroy;
begin
  inherited Destroy;
end;

procedure TRecipe.FireLog(const ALogType: TfoLogType; const ALogMsg: string;
  const ADestinations: TLogDestinations);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, ALogType, ALogMsg, ADestinations);
end;

function TRecipe.GetUpperHeaterTemp(Index: Integer): Double;
begin
//  if (Index >= 0) and (Index < MAX_RECIPE_OPERATION_COUNT) then
//    Result := RecipeServer.AsDouble[Format('MAGNET_%d_UPPER_HEATER_TEMP', [Index])]
//  else
//    Result := 0.0;
end;

function TRecipe.LoadDefault: Boolean;
begin
  Result := LoadFromFile(FDefaultRecipeFile);
end;

function TRecipe.LoadFromFile(const AFileName: string): Boolean;
var
  MS : TMemoryStream;
  DS : TfoDataServer;
  Zip : TZipForge;

  function ExtractToStream(const ArchiveFileName : string; S : TMemoryStream) : Boolean;
  var
    AI : TZFArchiveItem;
  begin
    Result := False;
    S.Clear;
    if Zip.FindFirst(ArchiveFileName, AI) then
    begin
      Zip.ExtractToStream(ArchiveFileName, S);
      S.Position := 0;
      Result := True;
    end;
  end;
begin

  Result := False;

  if FileExists(AFileName) then
  begin
    FFileName := AFileName;
    MS := TMemoryStream.Create;
    DS := TfoDataServer.Create(nil);
    try
      Zip := TZipForge.Create(nil);
      try
        Zip.BaseDir := foAppPath;
        Zip.FileName := AFileName;
        Zip.OpenArchive;
        try
          // 공통으로 사용하는 데이터
          if FRecipeServer <> nil then
          begin
            if ExtractToStream(SRecipeInfoFile, MS) then
            begin
              if FileExists(FDefaultRecipeDataFile) then
              begin
                DS.LoadFromCSVFile(FDefaultRecipeDataFile);
                MS.Position := 0;
                FRecipeServer.LoadFromStream(MS);

                foSynchronizeChannels(DS, FRecipeServer);
              end
              else
              begin
                FireLog(ltError, Format('Default Recipe File Not Found -> %s', [FDefaultRecipeDataFile]), []);
              end;
            end
            else
            begin
              if FileExists(FDefaultRecipeDataFile) then
              begin
                FRecipeServer.LoadFromCSVFile(FDefaultRecipeDataFile);
              end;
            end;
          end;
          FireLog(ltMessage, Format('Load Recipe File -> %s', [AFileName]), []);
        finally
          Zip.CloseArchive;
        end;
      finally
        Zip.Free;
      end;
      Result := True;
    finally
      DS.Free;
      MS.Free;
    end;
  end
  else
  begin
    FFileName := AFileName;

    if FRecipeServer <> nil then
    begin
      if FileExists(FDefaultRecipeDataFile) then
        FRecipeServer.LoadFromCSVFile(FDefaultRecipeDataFile);
    end;

    Result := True;
  end;
end;

procedure TRecipe.Save;
begin
  SaveToFile(FFileName);
end;

procedure TRecipe.SaveAsDefault;
begin
  SaveToFile(FDefaultRecipeFile);
end;

function TRecipe.SaveToFile(const AFileName: string): Boolean;
var
  MS : TMemoryStream;
  Zip : TZipForge;
begin
  Result := False;

  FFileName := AFileName;

  if FileExists(AFileName) then
    DeleteFile(AFileName);

  MS := TMemoryStream.Create;
  try
    Zip := TZipForge.Create(nil);
    try
      Zip.BaseDir := foAppPath;
      Zip.FileName := AFileName;
      Zip.OpenArchive;
      try

        if FRecipeServer <> nil then
        begin
          MS.Clear;
          FRecipeServer.SaveToStream(MS);
          MS.Position := 0;
          Zip.AddFromStream(SRecipeInfoFile, MS);
        end;

        FireLog(ltMessage, Format('Save Recipe File -> %s', [AFileName]), []);
      finally
        Zip.CloseArchive;
      end;
    finally
      Zip.Free;
    end;
  finally
    MS.Free;
  end;
end;

initialization

finalization
  if Assigned(_Recipe) then
    _Recipe.Free;

end.
