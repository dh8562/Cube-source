unit fManual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ActnList,
  ImgList,
  Menus,
  ExtCtrls,
  Mask,
  Actions,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,
  dxSkinscxPCPainter,
  cxPCdxBarPopupMenu,
  cxControls,
  cxPC,
  cxContainer,
  cxEdit,
  cxGroupBox,

  elBase,
  elControls,
  elExplorerBar,
  elPropSaver,
  elMultiLanguage,

  uEquipmentTypes,
  uEquipmentConsts,
  foUserManager,

  fMessageDlg,
  foWinUtils,
  foTypes,
  foControls,
  foChannelSpy,
  foButton,
  foButtonEdit,
  foMotion,
  foEdit,
  foDataServer,
  foIndicator,
  foLED,

  uAlarmConsts,
  fNumericKBD,
  dmHAL,
  dmMachine,
  uCommonUtils,
  uEquipment, Vcl.ComCtrls, foLabel, System.ImageList, cxImageList, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxGDIPlusClasses;

{$I uIOServer.inc}
{$I uJobServer.inc}
{$I uSysServer.inc}
{$I uStsServer.inc}

type
  TfrmManual = class(TForm)
    alDiag: TActionList;
    PropSaver: TelPropSaver;
    ilManual: TcxImageList;
    ilSmall: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
    { Public declarations }
    procedure UpdateForm;

  end;

var
  frmManual: TfrmManual;

implementation

uses
  fChannelSpy, fJog;

{$R *.dfm}


procedure TfrmManual.FormCreate(Sender: TObject);
begin
  DesktopFont := True;

  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  PropSaver.LoadProperty;
  elApplyLanguage(Self);
end;

procedure TfrmManual.UpdateForm;
begin
end;

procedure TfrmManual.FormDestroy(Sender: TObject);
begin
  PropSaver.SaveProperty;
end;

end.
