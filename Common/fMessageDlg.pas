unit fMessageDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  ExtCtrls,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  Menus,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,
  cxControls,
  dxSkinsdxNavBarPainter,

  elPanels,
  elButton,
  elMultiLanguage,

  uCommonUtils, System.ImageList, cxImageList;

type
  TfrmMessageDlg = class(TForm)
    cpMsg: TelCoolPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    ilDlg: TcxImageList;
    imgInfo: TImage;
    imgError: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function Confirm(AText, ACaption : string) : Integer;
procedure Warning(AText, ACaption : string);


implementation

{$R *.dfm}

function Confirm(AText, ACaption : string) : Integer;
var
  F : TfrmMessageDlg;
begin
  F := TfrmMessageDlg.Create(Application);
  try
    F.cpMsg.Header.Picture := F.imgInfo.Picture;
    F.cpMsg.Header.Caption := ACaption;
    F.cpMsg.Body.Caption := AText;
    Result := F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure Warning(AText, ACaption : string);
var
  F : TfrmMessageDlg;
begin
  F := TfrmMessageDlg.Create(Application);
  try
    F.cpMsg.Header.Picture := F.imgError.Picture;
    F.cpMsg.Header.Caption := ACaption;
    F.cpMsg.Body.Caption := AText;
    F.btnCancel.Visible := False;
    F.btnOK.Left := (F.ClientWidth - F.btnOK.Width) div 2;
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmMessageDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmMessageDlg.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  DesktopFont := True;
  elApplyLanguage(Self);
  ApplySkinColor('UserSkin', Self);

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TelCoolPanel then
    begin
      TelCoolPanel(Components[I]).Header.Font.Size := Font.Size;
      TelCoolPanel(Components[I]).Header.Font.Name := Font.Name;
      TelCoolPanel(Components[I]).Header.Font.Style := TelCoolPanel(Components[I]).Header.Font.Style + [fsBold];
      TelCoolPanel(Components[I]).Body.Font.Size := Font.Size;
      TelCoolPanel(Components[I]).Body.Font.Name := Font.Name;
    end;
  end;
end;

procedure TfrmMessageDlg.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmMessageDlg.FormShow(Sender: TObject);
begin
;
end;

end.
