unit uJob;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  Variants,
  JPEG,
  Math,

  ZipForge,

  elMultiLanguage,

  foWinUtils,
  foDataServer,
  foDataServerUtils,
  foRectUtils,
  foLists,
  foTypes,

  voVision,

  uLogger,
  uEquipmentConsts,
  uEquipmentTypes,
  uEquipmentUtils,
  uEquipment,
  uJobBase;

{$I uSysServer.inc}
{$I uJobServer.inc}

type
  TJob = class(TCustomJob)
  private

  protected
    procedure DoClear; override;
    procedure DoLoadFromFile(AZip : TZipForge); override;
    procedure DoSaveToFile(AZip : TZipForge); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function Job : TJob;

implementation

var
  _Job : TJob;

{ TJob }

function Job : TJob;
begin
  if not Assigned(_Job) then
    _Job := TJob.Create;

  Result := _Job;
end;

constructor TJob.Create;
var
  I : Integer;
begin
  inherited Create;

end;

destructor TJob.Destroy;
begin

  inherited Destroy;
end;

procedure TJob.DoClear;
begin
  inherited;
end;

procedure TJob.DoLoadFromFile(AZip: TZipForge);
var
  N, I : Integer;
  szFileName : AnsiString;
begin
  inherited;

//  for N := 0 to MAX_VISION_NO-1 do
//  begin
//    for I := 0 to MAX_ALIGN_MODEL - 1 do
//    begin
//      DoLoadPersistent(AZip, Format(SModelInfo, ['Aligner', N, I]), Aligner(N).ModelInfo[I]);
//      DoLoadBitmap(AZip, Format(SModelImage, ['Aligner', N, I]), Aligner(N).ModelImage[I]);
//
//      if Aligner(N).ModelImage[I].Width > 0 then
//      begin
//        szFileName := foAppPath + 'Temp.bmp';
//        Aligner(N).ModelImage[I].SaveToFile(szFileName);
//        Aligner(N).LoadModelImage(I, szFileName);
//        Aligner(N).BuildModel(I);
//      end;
//    end;
//  end;

  AZip.ExtractFiles('Vision*.bmp');
  AZip.ExtractFiles('model*.mdl');
end;

procedure TJob.DoSaveToFile(AZip: TZipForge);
var
  N, I : Integer;
begin
  inherited;

//  for N := 0 to MAX_VISION_NO-1 do
//  begin
//    for I := 0 to MAX_ALIGN_MODEL - 1 do
//    begin
//      DoSaveBitmap(AZip, Format(SModelImage, ['Aligner', N, I]), Aligner(N).ModelImage[I]);
//      DoSavePersistent(AZip, Format(SModelInfo, ['Aligner', N, I]), Aligner(N).ModelInfo[I]);
//    end;
//  end;
  AZip.AddFiles('Vision*.bmp');
  AZip.AddFiles('model*.mdl');
end;

initialization

finalization
  if Assigned(_Job) then
    _Job.Free;
end.
