unit fContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ImgList,
  Menus,
  ExtCtrls,

  elPanels,

  uJob,
  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,

  elMultiLanguage,

  uCommonUtils,

  uEquipment, System.Actions, Vcl.ActnList, System.ImageList, cxImageList;

type
  TfrmContainer = class(TForm)
    panClient: TPanel;
    panTitle: TelCoolPanel;
    btnClose: TcxButton;
    ilContainer: TcxImageList;
    ilTitle: TcxImageList;
    btnSave: TcxButton;
    SaveDlg: TSaveDialog;
    alJobEdit: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TContainerButtons = set of (
    cbSave
  );

procedure ShowFittedModalWith(ATitle : String; AControlClass : TWinControlClass; AParent : TWinControl; const Buttons : TContainerButtons = []);

implementation

{$R *.dfm}

procedure ShowFittedModalWith(ATitle : String; AControlClass : TWinControlClass; AParent : TWinControl; const Buttons : TContainerButtons);
var
  F : TfrmContainer;
  C : TWinControl;
begin
  F := TfrmContainer.Create(Application);
  try
    ModalFitTo(F, AParent);
    C := AControlClass.Create(nil);
    try
      EmbedTo(C, F.panClient);

      // 임베딩될 콘트롤이 폼이라면 폼의 아이콘을 표시한다.
      if C is TForm then
      begin
        F.panTitle.Body.Picture.Assign(TForm(C).Icon);
      end;

      if ATitle <>'' then
        F.panTitle.Body.Caption := ATitle
      else
      begin
        // 임베딩될 콘트롤이 폼이라면 폼의 캡션을 표시한다.
        if C is TForm then
          F.panTitle.Body.Caption := TForm(C).Caption;
      end;

      F.btnSave.Visible := (cbSave in Buttons);

      F.ShowModal;
    finally
      FreeAndNil(C);
    end;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmContainer.actSaveAsExecute(Sender: TObject);
begin
  SaveDlg.FileName := Job.FileName;
  if SaveDlg.Execute then
  begin
    Job.SaveToFile(SaveDlg.FileName);
  end;
end;

procedure TfrmContainer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmContainer.btnSaveClick(Sender: TObject);
begin
  Equipment.SaveSysInfo;

  if FileExists(Job.FileName) then
    Job.Save
  else
    actSaveAs.Execute;
end;

procedure TfrmContainer.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  panTitle.Body.Font := Self.Font;
  panTitle.Body.Font.Size := panTitle.Body.Font.Size * 2;
end;

procedure TfrmContainer.FormShow(Sender: TObject);
begin
  ApplySkinColor('UserSkin', Self);
  elApplyLanguage(Self);
end;

end.
