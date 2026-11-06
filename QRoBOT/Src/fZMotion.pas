unit fZMotion;

interface

uses
  System.Classes, System.IniFiles, System.Math, System.SysUtils,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls, fAlarms, uCommBase, uCommZMotion, uLogger,
  uTouchInput;

type
  TfrmZMotion = class(TForm)
    lblTitle: TLabel;
    grpCommunication: TGroupBox;
    btnConnect: TButton;
    lblConnectionStatus: TLabel;
    grpPosition: TGroupBox;
    lblCurrentCaption: TLabel;
    lblCurrentPosition: TLabel;
    lblHomeCaption: TLabel;
    lblHomePosition: TLabel;
    grpMove: TGroupBox;
    lblTargetCaption: TLabel;
    edtTargetPosition: TEdit;
    lblTargetUnit: TLabel;
    btnMove: TButton;
    btnStop: TButton;
    btnHome: TButton;
    grpJog: TGroupBox;
    btnJogMinus: TButton;
    btnJogPlus: TButton;
    lblJogStep: TLabel;
    grpStatus: TGroupBox;
    lblMotionCaption: TLabel;
    lblMotionStatus: TLabel;
    lblHomeSensorCaption: TLabel;
    lblHomeSensorStatus: TLabel;
    lblMinusLimitCaption: TLabel;
    lblMinusLimitStatus: TLabel;
    lblPlusLimitCaption: TLabel;
    lblPlusLimitStatus: TLabel;
    lblControllerAlarmCaption: TLabel;
    lblControllerAlarmStatus: TLabel;
    tmrStatus: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnJogMinusClick(Sender: TObject);
    procedure btnJogPlusClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tmrStatusTimer(Sender: TObject);
  private
    FConnected: Boolean;
    FCurrentPosition: Double;
    FHomePosition: Double;
    FMinPosition: Double;
    FMaxPosition: Double;
    FJogStep: Double;
    FTargetPosition: Double;
    FMoving: Boolean;
    FHomeSearchPhase: Integer;
    FMotionStatus: string;
    FHomeSensor: Boolean;
    FMinusLimitSensor: Boolean;
    FPlusLimitSensor: Boolean;
    FControllerAlarm: Boolean;
    FPortName: string;
    FBaudRate: string;
    FAlarmForm: TfrmAlarms;
    FCommunication: TQVIXZMotionComm;
    FPulsesPerMm: Double;
    FPollPosition: Boolean;
    procedure AddLog(const AMessage: string);
    procedure CommunicationStatus(Sender: TObject;
      const AState: TQVIXCommState; const AMessage: string);
    function MotionAllowed: Boolean;
    procedure MoveTo(const APosition: Double; const AReason: string);
    procedure StartHomeSearch;
    procedure SetCommunication(const Value: TQVIXZMotionComm);
    procedure ZMotionStatus(Sender: TObject; const APositionPulses: Integer;
      const AHome, AMinusLimit, APlusLimit, AAlarm, AMoving: Boolean);
    procedure UpdateSensors;
    procedure UpdateDisplay;
  public
    procedure ReloadSettings;
    procedure HandleHomeRequest(Sender: TObject);
    procedure MoveToPosition(const APosition: Double);
    property AlarmForm: TfrmAlarms read FAlarmForm write FAlarmForm;
    property Communication: TQVIXZMotionComm read FCommunication
      write SetCommunication;
  end;

implementation

{$R *.dfm}

procedure TfrmZMotion.AddLog(const AMessage: string);
begin
  QVIXLog('Z Motion', AMessage);
end;

procedure TfrmZMotion.btnConnectClick(Sender: TObject);
begin
  if not Assigned(FCommunication) then
    Exit;
  if FCommunication.State = qcsOpen then
  begin
    FCommunication.Close;
    FConnected := False;
  end
  else
    FConnected := FCommunication.Open;
  UpdateDisplay;
end;

procedure TfrmZMotion.btnHomeClick(Sender: TObject);
begin
  if not MotionAllowed then
    Exit;
  StartHomeSearch;
end;

procedure TfrmZMotion.btnJogMinusClick(Sender: TObject);
begin
  if not MotionAllowed then
    Exit;
  MoveTo(FCurrentPosition - FJogStep, 'JOG minus');
end;

procedure TfrmZMotion.btnJogPlusClick(Sender: TObject);
begin
  if not MotionAllowed then
    Exit;
  MoveTo(FCurrentPosition + FJogStep, 'JOG plus');
end;

procedure TfrmZMotion.btnMoveClick(Sender: TObject);
var
  TargetPosition: Double;
begin
  if not MotionAllowed then
    Exit;
  if not TryStrToFloat(Trim(edtTargetPosition.Text), TargetPosition) then
  begin
    AddLog('Invalid target position');
    edtTargetPosition.SetFocus;
    Exit;
  end;
  MoveTo(TargetPosition, 'Target move');
end;

procedure TfrmZMotion.HandleHomeRequest(Sender: TObject);
begin
  if FConnected then
    StartHomeSearch;
end;

procedure TfrmZMotion.btnStopClick(Sender: TObject);
begin
  if Assigned(FCommunication) then
    FCommunication.Stop;
  FMoving := False;
  FHomeSearchPhase := 0;
  FTargetPosition := FCurrentPosition;
  FMotionStatus := 'STOPPED';
  AddLog(Format('PMC-1HS STOP requested at %.1f mm', [FCurrentPosition]));
  UpdateDisplay;
end;

procedure TfrmZMotion.FormCreate(Sender: TObject);
begin
  EnableTouchKeyboards(Self);
  FConnected := False;
  FMoving := False;
  FHomeSearchPhase := 0;
  FControllerAlarm := False;
  FMotionStatus := 'IDLE';
  ReloadSettings;
  FCurrentPosition := 0;
  FTargetPosition := FCurrentPosition;
  FHomeSensor := False;
  FMinusLimitSensor := False;
  FPlusLimitSensor := False;
  edtTargetPosition.Text := FormatFloat('0.0', FCurrentPosition);
  AddLog('Z Motion screen initialized - PMC-1HS actual communication mode');
  UpdateDisplay;
end;

procedure TfrmZMotion.MoveTo(const APosition: Double; const AReason: string);
begin
  if APosition < FMinPosition then
  begin
    AddLog(Format('Move rejected: target is below %.1f mm', [FMinPosition]));
    Exit;
  end;
  if APosition > FMaxPosition then
  begin
    AddLog(Format('Move rejected: target is above %.1f mm', [FMaxPosition]));
    Exit;
  end;

  FTargetPosition := APosition;
  FMoving := True;
  FHomeSearchPhase := 0;
  FMotionStatus := AReason;
  AddLog(Format('%s requested: %.1f mm', [AReason, FTargetPosition]));
  if Assigned(FCommunication) then
  begin
    if Pos('JOG minus', AReason) = 1 then
      FCommunication.Jog(False)
    else if Pos('JOG plus', AReason) = 1 then
      FCommunication.Jog(True)
    else
      FCommunication.MoveAbsolute(Round(FtargetPosition * FPulsesPerMm));
  end;
  UpdateDisplay;
end;

procedure TfrmZMotion.StartHomeSearch;
begin
  FMoving := True;
  FHomeSearchPhase := 2;
  FTargetPosition := FHomePosition;
  FMotionStatus := 'HOME SEARCH';
  AddLog('PMC-1HS HOME signal search started');
  if Assigned(FCommunication) then
    FCommunication.HomeSearch;
  UpdateDisplay;
end;

function TfrmZMotion.MotionAllowed: Boolean;
begin
  Result := FConnected;
  if not Result then
  begin
    AddLog('Motion blocked: PMC-1HS is disconnected');
    Exit;
  end;
  Result := not FControllerAlarm and
    (not Assigned(FAlarmForm) or not FAlarmForm.IsRunBlocked);
  if not Result then
    AddLog('Motion blocked: resolve the active alarm first');
end;

procedure TfrmZMotion.ReloadSettings;
var
  Ini: TIniFile;
  Index: Integer;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    Index := Ini.ReadInteger('ZAxis', 'PortIndex', 0);
    if (Index < 0) or (Index > 8) then
      Index := 0;
    FPortName := 'COM' + IntToStr(Index + 1);
    Index := Ini.ReadInteger('ZAxis', 'BaudIndex', 3);
    case Index of
      0: FBaudRate := '9600';
      1: FBaudRate := '19200';
      2: FBaudRate := '38400';
    else
      FBaudRate := '115200';
    end;
    FMinPosition := Ini.ReadFloat('ZAxis', 'MinimumMm', 0.0);
    FMaxPosition := Ini.ReadFloat('ZAxis', 'MaximumMm', 80.0);
    FHomePosition := Ini.ReadFloat('ZAxis', 'HomeMm', 80.0);
    FJogStep := Ini.ReadFloat('ZAxis', 'JogStepMm', 1.0);
    FPulsesPerMm := Ini.ReadFloat('ZAxis', 'PulsesPerMm', 1000.0);
  finally
    Ini.Free;
  end;
  lblHomePosition.Caption := FormatFloat('0.0', FHomePosition) + ' mm';
  btnHome.Caption := 'HOME ' + FormatFloat('0.#', FHomePosition);
  lblJogStep.Caption := Format('JOG Step: %.1f mm', [FJogStep]);
  AddLog('Z axis settings reloaded from Settings');
end;

procedure TfrmZMotion.MoveToPosition(const APosition: Double);
begin
  if (APosition < FMinPosition) or (APosition > FMaxPosition) then
    Exit;
  if Abs(FCurrentPosition - APosition) < 0.001 then
    Exit;
  if FConnected then
    MoveTo(APosition, 'AUTO POSITION');
end;

procedure TfrmZMotion.tmrStatusTimer(Sender: TObject);
begin
  if not FConnected or not Assigned(FCommunication) then
    Exit;
  FPollPosition := not FPollPosition;
  if FPollPosition then
    FCommunication.QueryPosition
  else
    FCommunication.QueryInputs;
end;

procedure TfrmZMotion.CommunicationStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  FConnected := AState = qcsOpen;
  if FConnected then
    FMotionStatus := 'IDLE'
  else
  begin
    FMoving := False;
    FMotionStatus := 'DISCONNECTED';
  end;
  AddLog(AMessage);
  UpdateDisplay;
end;

procedure TfrmZMotion.SetCommunication(const Value: TQVIXZMotionComm);
begin
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := nil;
    FCommunication.OnMotionStatus := nil;
  end;
  FCommunication := Value;
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := CommunicationStatus;
    FCommunication.OnMotionStatus := ZMotionStatus;
    FConnected := FCommunication.State = qcsOpen;
  end;
  UpdateDisplay;
end;

procedure TfrmZMotion.ZMotionStatus(Sender: TObject;
  const APositionPulses: Integer; const AHome, AMinusLimit, APlusLimit,
  AAlarm, AMoving: Boolean);
begin
  if FPulsesPerMm <= 0 then
    FPulsesPerMm := 1000;
  FCurrentPosition := APositionPulses / FPulsesPerMm;
  FHomeSensor := AHome;
  FMinusLimitSensor := AMinusLimit;
  FPlusLimitSensor := APlusLimit;
  FControllerAlarm := AAlarm;
  FMoving := AMoving;
  if FHomeSensor and (FHomeSearchPhase = 2) then
  begin
    FHomeSearchPhase := 0;
    FMotionStatus := 'HOMED';
  end
  else if FMoving then
    FMotionStatus := 'MOVING'
  else
    FMotionStatus := 'IDLE';
  UpdateDisplay;
end;

procedure TfrmZMotion.UpdateSensors;
begin
  FHomeSensor := SameValue(FCurrentPosition, FHomePosition, 0.001);
  FMinusLimitSensor := FCurrentPosition <= FMinPosition;
  FPlusLimitSensor := FCurrentPosition >= FMaxPosition;
end;

procedure TfrmZMotion.UpdateDisplay;
begin
  lblCurrentPosition.Caption := FormatFloat('0.0', FCurrentPosition) + ' mm';
  lblMotionStatus.Caption := FMotionStatus;
  if FMoving then
    lblMotionStatus.Font.Color := clNavy
  else
    lblMotionStatus.Font.Color := clGreen;
  if FHomeSensor then
  begin
    lblHomeSensorStatus.Caption := 'ON';
    lblHomeSensorStatus.Font.Color := clGreen;
  end
  else
  begin
    lblHomeSensorStatus.Caption := 'OFF';
    lblHomeSensorStatus.Font.Color := clGray;
  end;
  if FMinusLimitSensor then
  begin
    lblMinusLimitStatus.Caption := 'ON';
    lblMinusLimitStatus.Font.Color := clRed;
  end
  else
  begin
    lblMinusLimitStatus.Caption := 'OFF';
    lblMinusLimitStatus.Font.Color := clGreen;
  end;
  if FPlusLimitSensor then
  begin
    lblPlusLimitStatus.Caption := 'ON';
    lblPlusLimitStatus.Font.Color := clRed;
  end
  else
  begin
    lblPlusLimitStatus.Caption := 'OFF';
    lblPlusLimitStatus.Font.Color := clGreen;
  end;
  if FControllerAlarm then
  begin
    lblControllerAlarmStatus.Caption := 'ALARM';
    lblControllerAlarmStatus.Font.Color := clRed;
  end
  else
  begin
    lblControllerAlarmStatus.Caption := 'NORMAL';
    lblControllerAlarmStatus.Font.Color := clGreen;
  end;
  if FConnected then
  begin
    lblConnectionStatus.Caption := Format('CONNECTED (%s, %s bps)',
      [FPortName, FBaudRate]);
    lblConnectionStatus.Font.Color := clGreen;
    btnConnect.Caption := 'Disconnect';
  end
  else
  begin
    lblConnectionStatus.Caption := 'DISCONNECTED';
    lblConnectionStatus.Font.Color := clRed;
    btnConnect.Caption := 'Connect';
  end;
  btnMove.Enabled := FConnected and not FMoving;
  btnHome.Enabled := FConnected and not FMoving;
  btnJogMinus.Enabled := FConnected and not FMoving;
  btnJogPlus.Enabled := FConnected and not FMoving;
  btnStop.Enabled := FConnected and FMoving;
end;

end.
