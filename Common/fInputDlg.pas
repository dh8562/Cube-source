unit fInputDlg;

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

  uCommonUtils,
  System.ImageList,
  cxImageList,
  Vcl.Mask,
  foEdit;

type
  TfrmInputDlg = class(TForm)
    cpMsg: TelCoolPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    ilDlg: TcxImageList;
    imgInfo: TImage;
    imgError: TImage;
    feValue: TfoEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure feValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetTextFromInput(const AValue : string; const AText : string) : string;


implementation

{$R *.dfm}

function GetTextFromInput(const AValue : string; const AText : string) : string;
var
  F : TfrmInputDlg;
begin
  Result := AValue;

  F := TfrmInputDlg.Create(Application);
  try
    F.feValue.Text := AValue;
    F.cpMsg.Header.Picture := F.imgInfo.Picture;
    F.cpMsg.Header.Caption := AValue;
		F.feValue.Text := AText;

    F.btnCancel.Visible := False;
    F.btnOK.Left := (F.ClientWidth - F.btnOK.Width) div 2;

    if F.ShowModal = mrOK then
    begin
      Result := F.feValue.Text;
    end;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmInputDlg.feValueKeyPress(Sender: TObject; var Key: Char);
begin
	if Key = Char(13) then
  begin
    Close;
  end;

end;

procedure TfrmInputDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmInputDlg.FormCreate(Sender: TObject);
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

procedure TfrmInputDlg.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmInputDlg.FormShow(Sender: TObject);
begin
;
end;

end.
