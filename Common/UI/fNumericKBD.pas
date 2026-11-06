unit fNumericKBD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Touch.Keyboard;

type
  TfrmNumericKBD = class(TForm)
    feValue: TEdit;
    TouchKeyboard1: TTouchKeyboard;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMinValue: Double;
    FMaxValue: Double;
    FUseRange: Boolean;
    function TryAcceptValue: Boolean;
  public
    { Public declarations }
  end;


function GetValueFromTouchKBD(const AValue : Double;
  const AMinValue : Double = 0; const AMaxValue : Double = 0) : Double;


implementation

{$R *.dfm}

function GetValueFromTouchKBD(const AValue, AMinValue,
  AMaxValue : Double) : Double;
var
  F : TfrmNumericKBD;
begin
  Result := AValue;
  F := TfrmNumericKBD.Create(Application);
  try
    F.FMinValue := AMinValue;
    F.FMaxValue := AMaxValue;
    F.FUseRange := not ((AMinValue = 0) and (AMaxValue = 0));
    F.feValue.Text := FloatToStr(AValue);
    if F.ShowModal = mrOK then
      TryStrToFloat(Trim(F.feValue.Text), Result);
  finally
    FreeAndNil(F);
  end;
end;

function TfrmNumericKBD.TryAcceptValue: Boolean;
var
  Value: Double;
begin
  Result := TryStrToFloat(Trim(feValue.Text), Value);
  if not Result then
  begin
    MessageDlg('올바른 숫자를 입력하십시오.', mtWarning, [mbOK], 0);
    feValue.SetFocus;
    feValue.SelectAll;
    Exit;
  end;

  if not FUseRange then
    Exit;
  Result := (Value >= FMinValue) and (Value <= FMaxValue);
  if not Result then
  begin
    MessageDlg(
      Format('입력값은 %g 이상 %g 이하이어야 합니다.',
        [FMinValue, FMaxValue]),
      mtWarning, [mbOK], 0
    );
    feValue.SetFocus;
    feValue.SelectAll;
  end;
end;

procedure TfrmNumericKBD.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
end;

procedure TfrmNumericKBD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if TryAcceptValue then
      ModalResult := mrOK;
    Key := 0;
  end;
end;

procedure TfrmNumericKBD.FormShow(Sender: TObject);
begin
  feValue.Font.Size := feValue.Font.Size + 4;
  if FUseRange then
    Caption := Format('숫자 입력 (MIN: %g / MAX: %g)',
      [FMinValue, FMaxValue])
  else
    Caption := '숫자 입력';
end;

end.
