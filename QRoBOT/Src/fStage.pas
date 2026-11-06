unit fStage;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  fAlarms, uLogger;

type
  TStageCommandEvent = procedure(Sender: TObject) of object;
  TStageRecipeStartEvent = procedure(Sender: TObject;
    const ARecipeNo: Integer) of object;

  TfrmStage = class(TForm)
    lblTitle: TLabel;
    grpConnection: TGroupBox;
    lblConnectionCaption: TLabel;
    lblConnectionStatus: TLabel;
    lblControllerCaption: TLabel;
    lblControllerValue: TLabel;
    btnConnect: TButton;
    grpPosition: TGroupBox;
    panX: TPanel;
    lblXCaption: TLabel;
    lblXValue: TLabel;
    panY: TPanel;
    lblYCaption: TLabel;
    lblYValue: TLabel;
    panZ: TPanel;
    lblZCaption: TLabel;
    lblZValue: TLabel;
    grpRecipe: TGroupBox;
    lblRecipeCaption: TLabel;
    edtRecipeNo: TEdit;
    lblRecipeNameCaption: TLabel;
    lblRecipeName: TLabel;
    btnStart: TButton;
    btnStop: TButton;
    btnHomeAll: TButton;
    grpStatus: TGroupBox;
    lblRunCaption: TLabel;
    lblRunStatus: TLabel;
    lblHomeCaption: TLabel;
    lblHomeStatus: TLabel;
    lblCompleteCaption: TLabel;
    lblCompleteStatus: TLabel;
    lblErrorCaption: TLabel;
    lblErrorStatus: TLabel;
    lblMessageCaption: TLabel;
    lblMessage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnHomeAllClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
  private
    FAlarmForm: TfrmAlarms;
    FConnected: Boolean;
    FOnHome: TStageCommandEvent;
    FOnConnect: TStageCommandEvent;
    FOnStartRecipe: TStageRecipeStartEvent;
    FOnStop: TStageCommandEvent;
    procedure AddLog(const AMessage: string);
    procedure UpdateButtons;
  public
    procedure HandleHomeRequest(Sender: TObject);
    procedure RequestConnect;
    procedure ReloadSettings;
    procedure SetActiveRecipe(const ARecipeNo: Integer;
      const ARecipeName: string);
    procedure SetConnectionState(const AConnected: Boolean;
      const AMessage: string);
    procedure SetPosition(const AX, AY, AZ: Double);
    procedure SetStageStatus(const ARunning, AHomed, AComplete: Boolean;
      const AErrorCode, AMessage: string);
    property AlarmForm: TfrmAlarms read FAlarmForm write FAlarmForm;
    property OnHome: TStageCommandEvent read FOnHome write FOnHome;
    property OnConnect: TStageCommandEvent read FOnConnect write FOnConnect;
    property OnStartRecipe: TStageRecipeStartEvent read FOnStartRecipe
      write FOnStartRecipe;
    property OnStop: TStageCommandEvent read FOnStop write FOnStop;
  end;

implementation

{$R *.dfm}

procedure TfrmStage.AddLog(const AMessage: string);
begin
  QVIXLog('Stage', AMessage);
end;

procedure TfrmStage.btnHomeAllClick(Sender: TObject);
begin
  AddLog('TX ALL HOME');
  if Assigned(FOnHome) then
    FOnHome(Self);
end;

procedure TfrmStage.btnConnectClick(Sender: TObject);
begin
  if FConnected then
    AddLog('Disconnect requested')
  else
    AddLog('Connect requested');
  if Assigned(FOnConnect) then
    FOnConnect(Self)
  else
    lblControllerValue.Caption := 'Stage communication is not assigned.';
end;

procedure TfrmStage.btnStartClick(Sender: TObject);
var
  RecipeNo: Integer;
begin
  RecipeNo := StrToIntDef(Trim(edtRecipeNo.Text), 0);
  AddLog('TX CURRENT RECIPE START');
  if Assigned(FOnStartRecipe) then
    FOnStartRecipe(Self, RecipeNo);
end;

procedure TfrmStage.btnStopClick(Sender: TObject);
begin
  AddLog('TX STOP');
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

procedure TfrmStage.FormCreate(Sender: TObject);
begin
  FConnected := False;
  SetPosition(0, 0, 0);
  SetActiveRecipe(0, 'No recipe selected');
  SetStageStatus(False, False, False, '', 'Waiting for controller connection');
  SetConnectionState(False, 'DISCONNECTED');
end;

procedure TfrmStage.HandleHomeRequest(Sender: TObject);
begin
  if FConnected then
    btnHomeAllClick(Sender);
end;

procedure TfrmStage.ReloadSettings;
begin
  UpdateButtons;
end;

procedure TfrmStage.RequestConnect;
begin
  if not FConnected then
    btnConnectClick(Self);
end;

procedure TfrmStage.SetActiveRecipe(const ARecipeNo: Integer;
  const ARecipeName: string);
begin
  if ARecipeNo > 0 then
    edtRecipeNo.Text := IntToStr(ARecipeNo)
  else
    edtRecipeNo.Text := 'CURRENT';
  lblRecipeName.Caption := ARecipeName;
end;

procedure TfrmStage.SetConnectionState(const AConnected: Boolean;
  const AMessage: string);
begin
  FConnected := AConnected;
  if AConnected then
  begin
    lblConnectionStatus.Caption := 'CONNECTED';
    lblConnectionStatus.Font.Color := clGreen;
  end
  else
  begin
    lblConnectionStatus.Caption := 'DISCONNECTED';
    lblConnectionStatus.Font.Color := clRed;
  end;
  lblControllerValue.Caption := AMessage;
  UpdateButtons;
end;

procedure TfrmStage.SetPosition(const AX, AY, AZ: Double);
begin
  lblXValue.Caption := FormatFloat('0.000', AX) + ' mm';
  lblYValue.Caption := FormatFloat('0.000', AY) + ' mm';
  lblZValue.Caption := FormatFloat('0.000', AZ) + ' mm';
end;

procedure TfrmStage.SetStageStatus(const ARunning, AHomed,
  AComplete: Boolean; const AErrorCode, AMessage: string);
begin
  if ARunning then
  begin
    lblRunStatus.Caption := 'RUNNING';
    lblRunStatus.Font.Color := clGreen;
  end
  else
  begin
    lblRunStatus.Caption := 'STOPPED';
    lblRunStatus.Font.Color := clWindowText;
  end;
  if AHomed then
  begin
    lblHomeStatus.Caption := 'HOMED';
    lblHomeStatus.Font.Color := clGreen;
  end
  else
  begin
    lblHomeStatus.Caption := 'NOT HOMED';
    lblHomeStatus.Font.Color := clRed;
  end;
  if AComplete then
  begin
    lblCompleteStatus.Caption := 'COMPLETE';
    lblCompleteStatus.Font.Color := clGreen;
  end
  else
  begin
    lblCompleteStatus.Caption := '---';
    lblCompleteStatus.Font.Color := clWindowText;
  end;
  if AErrorCode <> '' then
  begin
    lblErrorStatus.Caption := AErrorCode;
    lblErrorStatus.Font.Color := clRed;
  end
  else
  begin
    lblErrorStatus.Caption := 'NORMAL';
    lblErrorStatus.Font.Color := clGreen;
  end;
  lblMessage.Caption := AMessage;
  UpdateButtons;
end;

procedure TfrmStage.UpdateButtons;
begin
  if FConnected then
    btnConnect.Caption := 'Disconnect'
  else
    btnConnect.Caption := 'Connect';
  btnConnect.Enabled := True;
  btnHomeAll.Enabled := FConnected;
  btnStart.Enabled := FConnected and (lblRunStatus.Caption <> 'RUNNING');
  btnStop.Enabled := FConnected and (lblRunStatus.Caption = 'RUNNING');
  edtRecipeNo.Enabled := FConnected and (lblRunStatus.Caption <> 'RUNNING');
end;

end.
