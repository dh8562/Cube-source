unit fPeakDetectEdit;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls, uTouchInput;

type
  TfrmPeakDetectEdit = class(TForm)
    chkUse: TCheckBox;
    lblName: TLabel;
    edtName: TEdit;
    lblWaveStart: TLabel;
    edtWaveStart: TEdit;
    lblWaveEnd: TLabel;
    edtWaveEnd: TEdit;
    lblIntensityMin: TLabel;
    edtIntensityMin: TEdit;
    lblIntensityMax: TLabel;
    edtIntensityMax: TEdit;
    lblGraphColor: TLabel;
    cbGraphColor: TColorBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FValid: Boolean;
  public
    function Execute(const ACaption: string): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmPeakDetectEdit.btnOKClick(Sender: TObject);
var
  WaveStart: Integer;
  WaveEnd: Integer;
  IntensityMin: Double;
  IntensityMax: Double;
begin
  FValid := (Trim(edtName.Text) <> '') and
    TryStrToInt(edtWaveStart.Text, WaveStart) and
    TryStrToInt(edtWaveEnd.Text, WaveEnd) and
    TryStrToFloat(edtIntensityMin.Text, IntensityMin) and
    TryStrToFloat(edtIntensityMax.Text, IntensityMax) and
    (WaveStart >= 340) and (WaveEnd > WaveStart) and
    (IntensityMin >= 0) and (IntensityMax > IntensityMin);
  if FValid then
    ModalResult := mrOk
  else
    Caption := 'Check name, wavelength and intensity ranges';
end;

function TfrmPeakDetectEdit.Execute(const ACaption: string): Boolean;
begin
  Caption := ACaption;
  FValid := False;
  Result := ShowModal = mrOk;
end;

procedure TfrmPeakDetectEdit.FormCreate(Sender: TObject);
begin
  EnableTouchKeyboards(Self);
  cbGraphColor.Selected := clYellow;
end;

end.
