unit fSpectrometer;

interface

uses
  System.Classes, System.IniFiles, System.Math, System.SysUtils, System.Types, Winapi.Windows,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  fAlarms, uCommBase, uCommSpectrometer, uLogger, uTouchInput;

type
  TQVIXPeakDisplayItem = record
    Enabled: Boolean;
    StartWavelength: Integer;
    EndWavelength: Integer;
    Color: TColor;
  end;

  TfrmSpectrometer = class(TForm)
    lblTitle: TLabel;
    grpCommunication: TGroupBox;
    btnConnect: TButton;
    lblConnectionStatus: TLabel;
    grpMeasurement: TGroupBox;
    lblChannelCaption: TLabel;
    lblChannelValue: TLabel;
    lblWavelengthCaption: TLabel;
    lblWavelengthValue: TLabel;
    lblIntensityCaption: TLabel;
    lblIntensityValue: TLabel;
    lblOpticalStatusCaption: TLabel;
    lblOpticalStatusValue: TLabel;
    btnStart: TButton;
    btnStop: TButton;
    grpLimits: TGroupBox;
    lblStartWavelengthCaption: TLabel;
    edtStartWavelength: TEdit;
    lblEndWavelengthCaption: TLabel;
    edtEndWavelength: TEdit;
    lblMinCaption: TLabel;
    edtMinIntensity: TEdit;
    lblMaxCaption: TLabel;
    edtMaxIntensity: TEdit;
    btnApplyLimits: TButton;
    grpSpectrum: TGroupBox;
    pbSpectrum: TPaintBox;
    tmrMeasurement: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyLimitsClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure pbSpectrumPaint(Sender: TObject);
    procedure tmrMeasurementTimer(Sender: TObject);
  private
    FConnected: Boolean;
    FMeasuring: Boolean;
    FPeakWavelength: Double;
    FPeakIntensity: Double;
    FMinIntensity: Double;
    FMaxIntensity: Double;
    FStartWavelength: Integer;
    FEndWavelength: Integer;
    FPortName: string;
    FBaudRate: string;
    FSpectrometerKind: string;
    FExposureMs: Integer;
    FReadTimeMs: Integer;
    FAlarmForm: TfrmAlarms;
    FOpticalAlarmRaised: Boolean;
    FCommunication: TQVIXSpectrometerComm;
    FWavelengths: TQVIXDoubleArray;
    FIntensities: TQVIXDoubleArray;
    FPeakDisplayCount: Integer;
    FPeakDisplay: array[0..9] of TQVIXPeakDisplayItem;
    procedure AddLog(const AMessage: string);
    procedure CommunicationStatus(Sender: TObject;
      const AState: TQVIXCommState; const AMessage: string);
    procedure SetCommunication(const Value: TQVIXSpectrometerComm);
    procedure SpectrumReceived(Sender: TObject;
      const AWavelengths, AIntensities: TQVIXDoubleArray;
      const APeakWavelength, APeakIntensity: Double);
    procedure UpdateDisplay;
  public
    procedure ReloadSettings;
    property AlarmForm: TfrmAlarms read FAlarmForm write FAlarmForm;
    property Communication: TQVIXSpectrometerComm read FCommunication
      write SetCommunication;
  end;

implementation

{$R *.dfm}

procedure TfrmSpectrometer.AddLog(const AMessage: string);
begin
  QVIXLog('Spectrometer', AMessage);
end;

procedure TfrmSpectrometer.btnApplyLimitsClick(Sender: TObject);
var
  NewMin: Double;
  NewMax: Double;
  NewStartWavelength: Integer;
  NewEndWavelength: Integer;
begin
  if (not TryStrToFloat(Trim(edtMinIntensity.Text), NewMin)) or
     (not TryStrToFloat(Trim(edtMaxIntensity.Text), NewMax)) or
     (not TryStrToInt(Trim(edtStartWavelength.Text), NewStartWavelength)) or
     (not TryStrToInt(Trim(edtEndWavelength.Text), NewEndWavelength)) or
     (NewMin < 0) or (NewMax <= NewMin) then
  begin
    AddLog('Optical limits rejected: check minimum and maximum values');
    Exit;
  end;
  if (NewStartWavelength < 340) or
     (NewEndWavelength <= NewStartWavelength) then
  begin
    AddLog('Peak wavelength range rejected');
    Exit;
  end;

  FMinIntensity := NewMin;
  FMaxIntensity := NewMax;
  FStartWavelength := NewStartWavelength;
  FEndWavelength := NewEndWavelength;
  AddLog(Format('Peak range %d-%d nm, intensity %.0f-%.0f applied',
    [FStartWavelength, FEndWavelength, FMinIntensity, FMaxIntensity]));
  UpdateDisplay;
end;

procedure TfrmSpectrometer.btnConnectClick(Sender: TObject);
begin
  if FMeasuring then
  begin
    AddLog('Disconnect blocked while measuring');
    Exit;
  end;

  if not Assigned(FCommunication) then
    Exit;
  if FCommunication.State = qcsOpen then
  begin
    FCommunication.Close;
    FConnected := False;
  end
  else if FCommunication.Open then
  begin
    FConnected := True;
    FCommunication.InitializeDevice(FExposureMs);
  end;
  UpdateDisplay;
end;

procedure TfrmSpectrometer.btnStartClick(Sender: TObject);
begin
  if FMeasuring then
    Exit;
  if Assigned(FAlarmForm) and FAlarmForm.IsRunBlocked then
  begin
    AddLog('Measurement start rejected: reset the active alarm first');
    Exit;
  end;
  if not FConnected then
  begin
    AddLog('Measurement start rejected: Q-OLS is disconnected');
    Exit;
  end;

  FMeasuring := True;
  tmrMeasurement.Enabled := True;
  AddLog('S1 / CH01 measurement started');
  UpdateDisplay;
end;

procedure TfrmSpectrometer.btnStopClick(Sender: TObject);
begin
  if FOpticalAlarmRaised then
  begin
    lblOpticalStatusValue.Caption := 'ALARM LATCHED';
    lblOpticalStatusValue.Font.Color := clRed;
  end
  else if not FMeasuring then
    Exit;
  FMeasuring := False;
  tmrMeasurement.Enabled := False;
  AddLog('S1 / CH01 measurement stopped');
  UpdateDisplay;
end;

procedure TfrmSpectrometer.FormCreate(Sender: TObject);
begin
  EnableTouchKeyboards(Self);
  FConnected := False;
  FMeasuring := False;
  FPeakWavelength := 777.4;
  FPeakIntensity := 0;
  FOpticalAlarmRaised := False;
  ReloadSettings;
  AddLog('Spectrometer screen initialized - Kind 1 communication mode');
  UpdateDisplay;
end;

procedure TfrmSpectrometer.ReloadSettings;
var
  Ini: TIniFile;
  Index: Integer;
  I: Integer;
  PeakSection: string;
  PeakDevice: Integer;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.settings.ini'));
  try
    Index := Ini.ReadInteger('QOLS', 'PortIndex', 1);
    if (Index < 0) or (Index > 8) then
      Index := 1;
    FPortName := 'COM' + IntToStr(Index + 1);
    Index := Ini.ReadInteger('QOLS', 'BaudIndex', 3);
    case Index of
      0: FBaudRate := '9600';
      1: FBaudRate := '19200';
      2: FBaudRate := '38400';
    else
      FBaudRate := '115200';
    end;
    Index := Ini.ReadInteger('QOLS', 'KindIndex', 1);
    case Index of
      0: FSpectrometerKind := 'OLD';
      2: FSpectrometerKind := 'QMINI';
    else
      FSpectrometerKind := 'NEW';
    end;
    if Index = 1 then
      FBaudRate := '256000';
    FExposureMs := Ini.ReadInteger('QOLS', 'ExposureMs', 10);
    FReadTimeMs := Ini.ReadInteger('QOLS', 'ReadTimeMs', 100);
    FStartWavelength := Ini.ReadInteger('QOLS', 'PeakStartNm', 760);
    FEndWavelength := Ini.ReadInteger('QOLS', 'PeakEndNm', 790);
    FMinIntensity := Ini.ReadFloat('QOLS', 'IntensityMin', 2000);
    FMaxIntensity := Ini.ReadFloat('QOLS', 'IntensityMax', 8000);
    PeakDevice := Ini.ReadInteger('QOLS', 'SelectedSpectrometer', 1) + 1;
    lblChannelValue.Caption := Format('S%d / CH01', [PeakDevice]);
    grpMeasurement.Caption := Format(
      ' Q-OLS v3.0 · Spectrometer S%d / CH01 ', [PeakDevice]);
    FPeakDisplayCount := Ini.ReadInteger(Format('QOLSPeakList%d',
      [PeakDevice]), 'Count', 0);
    if FPeakDisplayCount > Length(FPeakDisplay) then
      FPeakDisplayCount := Length(FPeakDisplay);
    for I := 0 to FPeakDisplayCount - 1 do
    begin
      PeakSection := Format('QOLSPeak%d_%d', [PeakDevice, I]);
      FPeakDisplay[I].Enabled := Ini.ReadBool(PeakSection, 'Use', True);
      FPeakDisplay[I].StartWavelength := Ini.ReadInteger(PeakSection,
        'StartWavelength', 400);
      FPeakDisplay[I].EndWavelength := Ini.ReadInteger(PeakSection,
        'EndWavelength', 500);
      FPeakDisplay[I].Color := TColor(Ini.ReadInteger(PeakSection,
        'Color', clYellow));
    end;
  finally
    Ini.Free;
  end;
  edtStartWavelength.Text := IntToStr(FStartWavelength);
  edtEndWavelength.Text := IntToStr(FEndWavelength);
  edtMinIntensity.Text := FormatFloat('0', FMinIntensity);
  edtMaxIntensity.Text := FormatFloat('0', FMaxIntensity);
  if FReadTimeMs < 50 then
    FReadTimeMs := 50;
  tmrMeasurement.Interval := FReadTimeMs;
  edtStartWavelength.ReadOnly := True;
  edtEndWavelength.ReadOnly := True;
  edtMinIntensity.ReadOnly := True;
  edtMaxIntensity.ReadOnly := True;
  btnApplyLimits.Visible := False;
  AddLog('Q-OLS settings reloaded from Settings');
  UpdateDisplay;
end;

procedure TfrmSpectrometer.pbSpectrumPaint(Sender: TObject);
var
  I: Integer;
  X: Integer;
  Y: Integer;
  PlotRect: TRect;
  Value: Double;
  GraphMax: Double;
  RangeLeft: Integer;
  RangeRight: Integer;
begin
  PlotRect := pbSpectrum.ClientRect;
  InflateRect(PlotRect, -24, -20);
  pbSpectrum.Canvas.Brush.Color := clWhite;
  pbSpectrum.Canvas.FillRect(pbSpectrum.ClientRect);
  pbSpectrum.Canvas.Pen.Color := clSilver;
  pbSpectrum.Canvas.Rectangle(PlotRect);

  if Length(FIntensities) = 0 then
    Exit;
  GraphMax := 1;
  for I := 0 to High(FIntensities) do
    if FIntensities[I] > GraphMax then
      GraphMax := FIntensities[I];

  pbSpectrum.Canvas.Pen.Color := RGB(24, 105, 180);
  for I := 0 to High(FIntensities) do
  begin
    if High(FIntensities) > 0 then
      X := PlotRect.Left + MulDiv(I, PlotRect.Width, High(FIntensities))
    else
      X := PlotRect.Left;
    Value := FIntensities[I] / GraphMax;
    Y := PlotRect.Bottom - Round(Value * (PlotRect.Height - 8));
    if I = 0 then
      pbSpectrum.Canvas.MoveTo(X, Y)
    else
      pbSpectrum.Canvas.LineTo(X, Y);
  end;

  for I := 0 to FPeakDisplayCount - 1 do
    if FPeakDisplay[I].Enabled then
    begin
      RangeLeft := PlotRect.Left + MulDiv(
        FPeakDisplay[I].StartWavelength - 340, PlotRect.Width,
        High(FIntensities));
      RangeRight := PlotRect.Left + MulDiv(
        FPeakDisplay[I].EndWavelength - 340, PlotRect.Width,
        High(FIntensities));
      pbSpectrum.Canvas.Pen.Color := FPeakDisplay[I].Color;
      pbSpectrum.Canvas.Pen.Width := 2;
      pbSpectrum.Canvas.MoveTo(RangeLeft, PlotRect.Top);
      pbSpectrum.Canvas.LineTo(RangeLeft, PlotRect.Bottom);
      pbSpectrum.Canvas.MoveTo(RangeRight, PlotRect.Top);
      pbSpectrum.Canvas.LineTo(RangeRight, PlotRect.Bottom);
    end;
  pbSpectrum.Canvas.Pen.Width := 1;
end;

procedure TfrmSpectrometer.tmrMeasurementTimer(Sender: TObject);
begin
  if Assigned(FCommunication) then
    FCommunication.RequestSpectrum;
end;

procedure TfrmSpectrometer.CommunicationStatus(Sender: TObject;
  const AState: TQVIXCommState; const AMessage: string);
begin
  FConnected := AState = qcsOpen;
  if not FConnected then
  begin
    FMeasuring := False;
    tmrMeasurement.Enabled := False;
  end;
  AddLog(AMessage);
  UpdateDisplay;
end;

procedure TfrmSpectrometer.SetCommunication(
  const Value: TQVIXSpectrometerComm);
begin
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := nil;
    FCommunication.OnSpectrum := nil;
  end;
  FCommunication := Value;
  if Assigned(FCommunication) then
  begin
    FCommunication.OnStatus := CommunicationStatus;
    FCommunication.OnSpectrum := SpectrumReceived;
    FConnected := FCommunication.State = qcsOpen;
  end;
  UpdateDisplay;
end;

procedure TfrmSpectrometer.SpectrumReceived(Sender: TObject;
  const AWavelengths, AIntensities: TQVIXDoubleArray;
  const APeakWavelength, APeakIntensity: Double);
begin
  FWavelengths := Copy(AWavelengths);
  FIntensities := Copy(AIntensities);
  FPeakWavelength := APeakWavelength;
  FPeakIntensity := APeakIntensity;
  UpdateDisplay;
  pbSpectrum.Invalidate;
end;

procedure TfrmSpectrometer.UpdateDisplay;
var
  OpticalOutOfRange: Boolean;
begin
  lblWavelengthValue.Caption := FormatFloat('0.0', FPeakWavelength) + ' nm';
  lblIntensityValue.Caption := FormatFloat('0', FPeakIntensity) + ' counts';

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

  OpticalOutOfRange := FMeasuring and
    ((FPeakIntensity < FMinIntensity) or (FPeakIntensity > FMaxIntensity));

  if OpticalOutOfRange and not FOpticalAlarmRaised then
  begin
    FOpticalAlarmRaised := True;
    FMeasuring := False;
    tmrMeasurement.Enabled := False;
    AddLog('Optical limit alarm - measurement stopped');
    if Assigned(FAlarmForm) then
      FAlarmForm.RaiseExternalAlarm('Q-OLS optical intensity outside limits',
        False, 'Spectrometer');
  end
  else if (not OpticalOutOfRange) and FOpticalAlarmRaised then
  begin
    FOpticalAlarmRaised := False;
    if Assigned(FAlarmForm) then
      FAlarmForm.ClearExternalCondition('Spectrometer');
  end;

  if not FMeasuring then
  begin
    lblOpticalStatusValue.Caption := 'IDLE';
    lblOpticalStatusValue.Font.Color := clGray;
  end
  else if OpticalOutOfRange then
  begin
    lblOpticalStatusValue.Caption := 'OUTSIDE LIMITS';
    lblOpticalStatusValue.Font.Color := clRed;
  end
  else
  begin
    lblOpticalStatusValue.Caption := 'NORMAL';
    lblOpticalStatusValue.Font.Color := clGreen;
  end;

  btnStart.Enabled := FConnected and not FMeasuring;
  btnStop.Enabled := FMeasuring;
end;

end.
