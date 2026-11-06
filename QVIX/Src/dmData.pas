unit dmData;

interface

uses
  Forms,
  SysUtils, Classes,
  Variants,
  IniFiles,
  System.Generics.Collections,
  System.JSON, System.IOUtils,

  CodeSiteLogging,

  foLists,

  elBase,
  elPropSaver,
  elMultiLanguage,

  voCustomDefectViewer,
  voStripViewer;

type
  TDATA = class(TDataModule)
    PropSaver: TelPropSaver;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  DATA: TDATA;

implementation

{$R *.dfm}

{ TDATA }

procedure TDATA.DataModuleCreate(Sender: TObject);
begin
  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  PropSaver.LoadProperty;

end;

procedure TDATA.DataModuleDestroy(Sender: TObject);
begin
;
end;



end.
