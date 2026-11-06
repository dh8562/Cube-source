unit fLogView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExtCtrls,
  Menus,
  StdCtrls,
  ActnList,
  ImgList,
  Mask,
  AppEvnts,
  Math,
  Actions,

  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxSkinscxPCPainter,
  dxBarBuiltInMenu,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  cxMRUEdit,
  cxButtons,
  cxPC,

  elExplorerBar,
  elMultiLanguage,

  voControls,

  CodeSiteLogging,

  foUserManager,
  foEdit,
  foButton,
  foButtonEdit,
  foControls,
  foChannelSpy,
  foEditCtrls,
  foMotion,
  foIndicator,
  foWinUtils,

  uEquipmentTypes,
  uEquipmentConsts,
  uEquipment,
  fMessageDlg,

  fJog,
  uJob,
  fTouchKBD,
  fNumericKBD,

  dmMachine,
  dmHAL,
  uCommonUtils,

  cxLabel,
  System.ImageList,
  cxImageList,
  VirtualTrees, Vcl.ComCtrls, foSpinEdit, dxGDIPlusClasses;

type
  TfrmLogView = class(TForm)
    ilButtonEdit: TcxImageList;
    ilSmall: TcxImageList;
    ilContainer: TcxImageList;
    alJobEdit: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    SaveDlg: TSaveDialog;
    panClient: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure UMUserLogIn(var Message : TMessage); message UM_USER_LOGIN;

    procedure UpdateActionEnabled;
  public
    { Public declarations }
  end;

var
  frmLogView: TfrmLogView;

implementation

{$R *.dfm}

uses fMain, fAuto, fChannelSpy, fLog;

{$I uSysServer.inc}
{$I uIOServer.inc}
{$I uJobServer.inc}
{$I uStsServer.inc}

procedure TfrmLogView.UMUserLogIn(var Message: TMessage);
begin
  UpdateActionEnabled;
end;

procedure TfrmLogView.UpdateActionEnabled;
begin
end;

procedure TfrmLogView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmLogView.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
end;

procedure TfrmLogView.FormShow(Sender: TObject);
var
  i : Integer;
begin
  elApplyLanguage(Self);
  EmbedTo(frmLog, panClient);
end;


end.
