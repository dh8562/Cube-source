unit fTouchKBD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Touch.Keyboard;

type
  TfrmTouchKBD = class(TForm)
    feValue: TEdit;
    TouchKeyboard: TTouchKeyboard;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function GetTextFromTouchKBD(const AValue : string; const APassword : Boolean = False) : string;


implementation

{$R *.dfm}

function GetTextFromTouchKBD(const AValue : string; const APassword : Boolean) : string;
var
  F : TfrmTouchKBD;
begin
  Result := AValue;

  F := TfrmTouchKBD.Create(Application);
  try
    if APassword then
      F.feValue.PasswordChar := '*'
    else
      F.feValue.PasswordChar := #0;
    F.feValue.Text := AValue;
    if F.ShowModal = mrOK then
    begin
      Result := F.feValue.Text;
    end;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmTouchKBD.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
end;

procedure TfrmTouchKBD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ModalResult := mrOK;
end;

procedure TfrmTouchKBD.FormShow(Sender: TObject);
begin
  feValue.Font.Size := feValue.Font.Size + 4;
end;

end.
