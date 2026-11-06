unit fThreader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  ExtCtrls,
  Menus,

  elColorConsts,
  elPanels,
  elButton,
  elLabel,
  elMultiLanguage,

  foThreadTimer,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons;

type
  TfoEventMethod = procedure (Sender : TObject) of Object;
  TJobMethod = procedure of Object;
  TJobProc = procedure;

type
  TThreaderVertPos = (vpCenter, vpTop, vpBottom);

  TfrmThreader = class(TForm)
    tmrTimer: TTimer;
    cpThreader: TelCoolPanel;
    tmrAlternative: TfoThreadTimer;
    btnCancel: TcxButton;
    procedure tmrTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    LastResult : TModalResult;
    JobMethod : TJobMethod;
    JobProc : TJobProc;
    Method : TfoEventMethod;
    CancelMethod : TfoEventMethod;
    tmrThreader : TfoThreadTimer;
    VertPos : TThreaderVertPos;
  public
    { Public declarations }
    procedure CreateParams(var Params : TCreateParams); override;
  end;

procedure StartThreader(Msg : String; ThreadTimer : TfoThreadTimer; Method: TfoEventMethod; CancelMethod: TfoEventMethod; const AInitialStep : Integer; const AVertPos : TThreaderVertPos = vpCenter; const AShowCancelBtn : Boolean = True);
procedure ThreaderMessage(Msg : string);
procedure StopThreader;
function LastThreaderResult : TModalResult;
procedure ExecuteMethodWithMsg(Msg : String; Method: TJobMethod); stdcall;
procedure ExecuteProcWithMsg(Msg : String; Proc: TJobProc); stdcall;

implementation

{$R *.DFM}

var
  frmThreader : TfrmThreader;

procedure StartThreader(Msg : String; ThreadTimer : TfoThreadTimer; Method: TfoEventMethod; CancelMethod: TfoEventMethod; const AInitialStep : Integer; const AVertPos : TThreaderVertPos = vpCenter; const AShowCancelBtn : Boolean = True);
begin
  if frmThreader = nil then
    frmThreader := TfrmThreader.Create(Application);
  frmThreader.cpThreader.Body.Caption := Msg;
  if ThreadTimer = nil then
    frmThreader.tmrThreader := frmThreader.tmrAlternative
  else
    frmThreader.tmrThreader := ThreadTimer;
  frmThreader.tmrThreader.CurrentStep := AInitialStep;
  frmThreader.Method := Method;
  frmThreader.CancelMethod := CancelMethod;
  frmThreader.VertPos := AVertPos;
  frmThreader.btnCancel.Visible := AShowCancelBtn;
  frmThreader.ShowModal;
end;

function LastThreaderResult : TModalResult;
begin
  Result := mrOk;
  if frmThreader <> nil then
    Result := frmThreader.LastResult;
end;

procedure ThreaderMessage(Msg : string);
begin
  if frmThreader <> nil then
  begin
    frmThreader.cpThreader.Body.Caption := frmThreader.cpThreader.Body.Caption + #10#13 + Msg;
  end;
end;

procedure StopThreader;
begin
  if frmThreader <> nil then
  begin
    if frmThreader.tmrThreader <> nil then
    begin
      frmThreader.tmrThreader.OnTimer := nil;
      frmThreader.tmrThreader.Enabled := False;
    end;
    if Assigned(frmThreader.CancelMethod) then
      frmThreader.CancelMethod(frmThreader.btnCancel);
    frmThreader.Close;
  end;
end;

procedure ExecuteMethodWithMsg(Msg : String; Method: TJobMethod);
var
  F : TfrmThreader;
begin
  try
    F := TfrmThreader.Create(Application);
    F.cpThreader.Body.Caption := Msg;
    F.JobMethod := Method;
    F.JobProc := nil;
    F.tmrThreader := nil;
    F.Method := nil;
    F.CancelMethod := nil;
    F.btnCancel.Visible := False;
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure ExecuteProcWithMsg(Msg : String; Proc: TJobProc); stdcall;
var
  F : TfrmThreader;
begin
  try
    F := TfrmThreader.Create(Application);
    F.cpThreader.Body.Caption := Msg;
    F.JobMethod := nil;
    F.JobProc := Proc;
    F.tmrThreader := nil;
    F.Method := nil;
    F.CancelMethod := nil;
    F.btnCancel.Visible := False;
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmThreader.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  tmrThreader := nil;
  VertPos := vpCenter;
  elApplyLanguage(Self);
end;

procedure TfrmThreader.FormShow(Sender: TObject);
begin
  cpThreader.Header.Font.Name := Font.Name;
  cpThreader.Header.Font.Size := Font.Size;
  cpThreader.Body.Font.Name := Font.Name;
  cpThreader.Body.Font.Size := Font.Size;

  cpThreader.Header.Caption := Application.Title;

  if btnCancel.Visible then
    Self.Height := btnCancel.Top + btnCancel.Height + 6
  else
    Self.Height := btnCancel.Top + 8;

  Self.Left := (Screen.Width - Self.Width) div 2;
  if VertPos = vpCenter then
  begin
    Self.Top := (Screen.Height - Self.Height) div 2;
  end
  else if VertPos = vpTop then
  begin
    Self.Top := (Screen.Height div 10);
  end
  else
  begin
    Self.Top := Screen.Height - Self.Height - (Screen.Height div 10);
  end;
  LastResult := mrOk;
  tmrTimer.Enabled := True;
end;

procedure TfrmThreader.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  { 폼의 캡션 바를 보이지 않게 한다. }
  With Params Do
  Begin
    Style := (Style Or WS_POPUP) And (Not WS_DLGFRAME);
  End;
end;

procedure TfrmThreader.tmrTimerTimer(Sender: TObject);
begin
  tmrTimer.Enabled := False;
  if (tmrThreader <> nil) and Assigned(Method) and Assigned(CancelMethod) then
  begin
    tmrThreader.OnTimer := Method;
    tmrThreader.Enabled := True;
  end
  else
  begin
    Screen.Cursor := crHourGlass;
    try
      if Assigned(JobMethod) then
      begin
        JobMethod;
      end;
      if Assigned(JobProc) then
      begin
        JobProc;
      end;
    finally
      Screen.Cursor := crDefault;
      Close;
    end;
  end;
end;

procedure TfrmThreader.btnCancelClick(Sender: TObject);
begin
  StopThreader;
  LastResult := mrCancel;
end;

end.
