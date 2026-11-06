unit uTouchInput;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

procedure EnableTouchKeyboards(const AForm: TCustomForm);

implementation

uses
  fNumericKBD, fTouchKBD;

type
  TTouchInputBinder = class(TComponent)
  private
    procedure BindControls(const AParent: TWinControl);
    procedure EditDblClick(Sender: TObject);
  public
    procedure Bind(const AForm: TCustomForm);
  end;

procedure EnableTouchKeyboards(const AForm: TCustomForm);
var
  Binder: TTouchInputBinder;
begin
  if AForm.FindComponent('TouchInputBinder') <> nil then
    Exit;
  Binder := TTouchInputBinder.Create(AForm);
  Binder.Name := 'TouchInputBinder';
  Binder.Bind(AForm);
end;

procedure TTouchInputBinder.Bind(const AForm: TCustomForm);
begin
  BindControls(AForm);
end;

procedure TTouchInputBinder.BindControls(const AParent: TWinControl);
var
  I: Integer;
  Edit: TEdit;
begin
  for I := 0 to AParent.ControlCount - 1 do
  begin
    if AParent.Controls[I] is TEdit then
    begin
      Edit := TEdit(AParent.Controls[I]);
      if not Edit.ReadOnly then
        Edit.OnDblClick := EditDblClick;
    end;
    if AParent.Controls[I] is TWinControl then
      BindControls(TWinControl(AParent.Controls[I]));
  end;
end;

procedure TTouchInputBinder.EditDblClick(Sender: TObject);
var
  Edit: TEdit;
  Value: Double;
begin
  Edit := TEdit(Sender);
  if SameText(Edit.Name, 'edtName') or
     SameText(Edit.Name, 'edtPassword') then
  begin
    Edit.Text := GetTextFromTouchKBD(Edit.Text, Edit.PasswordChar <> #0);
    Exit;
  end;
  if not TryStrToFloat(Edit.Text, Value) then
    Value := 0;
  Edit.Text := FloatToStr(GetValueFromTouchKBD(Value));
end;

end.
