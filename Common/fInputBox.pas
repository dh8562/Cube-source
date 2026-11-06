unit fInputBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  ExtCtrls,
  Mask,

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

  foButton,
  foEdit,
  foButtonEdit,
  foWinUtils,

  fTouchKBD,
  fMessageDlg,
  dmData,
  uAOI,
  uCommonUtils;

type
  TfrmInputBox = class(TForm)
    cpMsg: TelCoolPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    ilDlg: TcxImageList;
    beInput: TfoButtonEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure beInputButtonClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function InputBox(const ATitle : string; const ADefaultValue : string) : string;


implementation

{$R *.dfm}

function InputBox(const ATitle : string; const ADefaultValue : string) : string;
var
  F : TfrmInputBox;
begin
  F := TfrmInputBox.Create(Application);
  try
    F.cpMsg.Header.Caption := ATitle;
    F.beInput.Text := ADefaultValue;
    if F.ShowModal = mrOK then
    begin
      Result := F.beInput.Text;
    end
    else
      Result := ADefaultValue;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmInputBox.beInputButtonClick(Sender: TObject);
begin
  TfoLabeledButtonEdit(Sender).Text := GetTextFromTouchKBD(TfoLabeledButtonEdit(Sender).Text, False);
end;

procedure TfrmInputBox.btnOKClick(Sender: TObject);
begin
  if beInput.Text <> '' then
  begin
    ModalResult := mrOK;
  end;
end;

procedure TfrmInputBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmInputBox.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  DesktopFont := True;

  elApplyLanguage(Self);

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

procedure TfrmInputBox.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmInputBox.FormShow(Sender: TObject);
begin
;
end;

end.
