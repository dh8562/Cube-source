unit fAlarms;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls, uLogger;

type
  TfrmAlarms = class(TForm)
    lblTitle: TLabel;
    grpLatch: TGroupBox;
    lblLatchCaption: TLabel;
    lblLatchStatus: TLabel;
    lblCauseCaption: TLabel;
    lblCause: TLabel;
    lblAckCaption: TLabel;
    lblAckStatus: TLabel;
    lblHomeCaption: TLabel;
    lblHomeStatus: TLabel;
    btnAcknowledge: TButton;
    btnReset: TButton;
    btnForceReset: TButton;
    btnReturnHome: TButton;
    btnReleaseEStop: TButton;
    grpBlockers: TGroupBox;
    lstBlockers: TListBox;
    grpTest: TGroupBox;
    btnSensorAlarm: TButton;
    btnWaterAlarm: TButton;
    btnEStop: TButton;
    btnClearCondition: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAcknowledgeClick(Sender: TObject);
    procedure btnClearConditionClick(Sender: TObject);
    procedure btnEStopClick(Sender: TObject);
    procedure btnForceResetClick(Sender: TObject);
    procedure btnReleaseEStopClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnReturnHomeClick(Sender: TObject);
    procedure btnSensorAlarmClick(Sender: TObject);
    procedure btnWaterAlarmClick(Sender: TObject);
  private
    FTripCause: string;
    FConditionPresent: Boolean;
    FAcknowledged: Boolean;
    FHomeRequired: Boolean;
    FEStop: Boolean;
    FExternalCondition: Boolean;
    FExternalSource: string;
    FOnAlarm: TNotifyEvent;
    FOnHomeRequest: TNotifyEvent;
    FOnStateChanged: TNotifyEvent;
    procedure AddEvent(const AMessage: string);
    procedure ClearLatch(const AForced: Boolean);
    procedure RaiseAlarm(const ACause: string; const AHomeRequired,
      AEStop: Boolean);
    procedure UpdateDisplay;
  public
    procedure ApplyAccessMode(const ADeveloperMode: Boolean);
    procedure RaiseExternalAlarm(const ACause: string;
      const AHomeRequired: Boolean; const ASource: string = 'Operation');
    procedure ClearExternalCondition(const ASource: string = 'Operation');
    function IsRunBlocked: Boolean;
    function AlarmSummary: string;
    property OnAlarm: TNotifyEvent read FOnAlarm write FOnAlarm;
    property OnHomeRequest: TNotifyEvent read FOnHomeRequest write FOnHomeRequest;
    property OnStateChanged: TNotifyEvent read FOnStateChanged write FOnStateChanged;
  end;

implementation

{$R *.dfm}

procedure TfrmAlarms.ApplyAccessMode(const ADeveloperMode: Boolean);
begin
  grpTest.Enabled := ADeveloperMode;
  grpTest.Visible := ADeveloperMode;
end;

function TfrmAlarms.AlarmSummary: string;
begin
  if FTripCause = '' then
    Result := 'SYSTEM READY - NO LATCHED ALARM'
  else
    Result := 'ALARM - ' + FTripCause;
end;

procedure TfrmAlarms.AddEvent(const AMessage: string);
begin
  QVIXLog('Alarms', AMessage);
end;

procedure TfrmAlarms.btnAcknowledgeClick(Sender: TObject);
begin
  if FTripCause = '' then
    Exit;
  FAcknowledged := True;
  AddEvent('Alarm acknowledged by operator');
  UpdateDisplay;
end;

procedure TfrmAlarms.btnClearConditionClick(Sender: TObject);
begin
  FConditionPresent := False;
  AddEvent('Simulated alarm condition cleared');
  UpdateDisplay;
end;

procedure TfrmAlarms.btnEStopClick(Sender: TObject);
begin
  RaiseAlarm('Emergency stop activated', True, True);
end;

procedure TfrmAlarms.btnForceResetClick(Sender: TObject);
begin
  if (FTripCause = '') or FEStop or FHomeRequired then
    Exit;
  ClearLatch(True);
end;

procedure TfrmAlarms.btnReleaseEStopClick(Sender: TObject);
begin
  if not FEStop then
    Exit;
  FEStop := False;
  FConditionPresent := False;
  AddEvent('Emergency stop released - home return still required');
  UpdateDisplay;
end;

procedure TfrmAlarms.btnResetClick(Sender: TObject);
begin
  if (FTripCause = '') or (not FAcknowledged) or FConditionPresent or
     FHomeRequired or FEStop then
    Exit;
  ClearLatch(False);
end;

procedure TfrmAlarms.btnReturnHomeClick(Sender: TObject);
begin
  if (not FHomeRequired) or FEStop then
    Exit;
  if Assigned(FOnHomeRequest) then
    FOnHomeRequest(Self);
  FHomeRequired := False;
  AddEvent('Z axis returned HOME with output OFF');
  UpdateDisplay;
end;

procedure TfrmAlarms.btnSensorAlarmClick(Sender: TObject);
begin
  RaiseAlarm('Optical monitor outside limits', False, False);
end;

procedure TfrmAlarms.btnWaterAlarmClick(Sender: TObject);
begin
  RaiseAlarm('Water level below safety limit', True, False);
end;

procedure TfrmAlarms.ClearLatch(const AForced: Boolean);
begin
  if AForced then
    AddEvent('Alarm latch force reset')
  else
    AddEvent('Alarm latch reset');
  FTripCause := '';
  FConditionPresent := False;
  FAcknowledged := False;
  FHomeRequired := False;
  FEStop := False;
  FExternalCondition := False;
  FExternalSource := '';
  UpdateDisplay;
end;

procedure TfrmAlarms.FormCreate(Sender: TObject);
begin
  FTripCause := '';
  FConditionPresent := False;
  FAcknowledged := False;
  FHomeRequired := False;
  FEStop := False;
  FExternalCondition := False;
  FExternalSource := '';
  AddEvent('Alarm screen initialized - no latched stop');
  UpdateDisplay;
end;

procedure TfrmAlarms.ClearExternalCondition(const ASource: string);
begin
  if (not FExternalCondition) or (FExternalSource <> ASource) then
    Exit;
  FExternalCondition := False;
  FExternalSource := '';
  FConditionPresent := False;
  AddEvent('Operation alarm condition returned to normal');
  UpdateDisplay;
end;

function TfrmAlarms.IsRunBlocked: Boolean;
begin
  Result := (FTripCause <> '') or FConditionPresent or FHomeRequired or FEStop;
end;

procedure TfrmAlarms.RaiseExternalAlarm(const ACause: string;
  const AHomeRequired: Boolean; const ASource: string);
begin
  FExternalCondition := True;
  FExternalSource := ASource;
  RaiseAlarm(ACause, AHomeRequired, False);
end;

procedure TfrmAlarms.RaiseAlarm(const ACause: string;
  const AHomeRequired, AEStop: Boolean);
begin
  FTripCause := ACause;
  FConditionPresent := True;
  FAcknowledged := False;
  FHomeRequired := AHomeRequired;
  FEStop := AEStop;
  AddEvent('ALARM: ' + ACause);
  UpdateDisplay;
  if Assigned(FOnAlarm) then
    FOnAlarm(Self);
end;

procedure TfrmAlarms.UpdateDisplay;
begin
  lstBlockers.Items.BeginUpdate;
  try
    lstBlockers.Clear;
    if FConditionPresent then
      lstBlockers.Items.Add(FTripCause);
    if FEStop then
      lstBlockers.Items.Add('E-stop must be released');
    if FHomeRequired then
      lstBlockers.Items.Add('Z axis HOME return required');
    if (FTripCause <> '') and not FAcknowledged then
      lstBlockers.Items.Add('Operator acknowledgement required');
  finally
    lstBlockers.Items.EndUpdate;
  end;

  if FTripCause = '' then
  begin
    lblLatchStatus.Caption := 'NO LATCHED STOP';
    lblLatchStatus.Font.Color := clGreen;
    lblCause.Caption := '-';
  end
  else
  begin
    lblLatchStatus.Caption := 'RESET REQUIRED';
    lblLatchStatus.Font.Color := clRed;
    lblCause.Caption := FTripCause;
  end;

  if FAcknowledged then
    lblAckStatus.Caption := 'ACKNOWLEDGED'
  else
    lblAckStatus.Caption := 'NOT ACKNOWLEDGED';
  if FHomeRequired then
    lblHomeStatus.Caption := 'HOME REQUIRED'
  else
    lblHomeStatus.Caption := 'AT HOME / NOT REQUIRED';

  btnAcknowledge.Enabled := (FTripCause <> '') and not FAcknowledged;
  btnReset.Enabled := (FTripCause <> '') and FAcknowledged and
    (not FConditionPresent) and (not FHomeRequired) and (not FEStop);
  btnForceReset.Enabled := (FTripCause <> '') and (not FEStop) and
    (not FHomeRequired);
  btnReturnHome.Enabled := FHomeRequired and not FEStop;
  btnReleaseEStop.Enabled := FEStop;
  btnClearCondition.Enabled := FConditionPresent and not FEStop;
  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self);
end;

end.
