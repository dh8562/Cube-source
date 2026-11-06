unit fEditPeakItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinOffice2013LightGray, Vcl.Menus, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxColorComboBox, Vcl.StdCtrls, foEdit, cxButtons, Vcl.Mask, cxGroupBox,

  dmData, elBase, elPropSaver;

type
  TfrmEditPeakItem = class(TForm)
    gbGraphSetup: TcxGroupBox;
    leStartIntensity: TfoLabeledNumberEdit;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    leName: TfoLabeledEdit;
    leEndIntensity: TfoLabeledNumberEdit;
    leStartWaveLength: TfoLabeledNumberEdit;
    leEndWaveLength: TfoLabeledNumberEdit;
    cbUse: TCheckBox;
    cbColor: TcxColorComboBox;
    PropSaver: TelPropSaver;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditPeakItem: TfrmEditPeakItem;

implementation

{$R *.dfm}

procedure TfrmEditPeakItem.FormCreate(Sender: TObject);
begin
  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  PropSaver.LoadProperty;
end;

procedure TfrmEditPeakItem.FormDestroy(Sender: TObject);
begin
  PropSaver.SaveProperty;
end;

end.
