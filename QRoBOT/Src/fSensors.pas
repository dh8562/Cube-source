unit fSensors;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls, uCommBase, uCommunicationManager,
  uCommWaterSensors;

type
  TfrmSensors = class(TForm)
    lblTitle: TLabel;
    lblConnection: TLabel;
    grpSensors: TGroupBox;
    lblHeaderSensor: TLabel;
    lblHeaderID: TLabel;
    lblHeaderValue: TLabel;
    lblHeaderStatus: TLabel;
    lblNO3Name: TLabel;
    lblNO3ID: TLabel;
    lblNO3Value: TLabel;
    lblNO3Status: TLabel;
    lblNO2Name: TLabel;
    lblNO2ID: TLabel;
    lblNO2Value: TLabel;
    lblNO2Status: TLabel;
    lblECName: TLabel;
    lblECID: TLabel;
    lblECValue: TLabel;
    lblECStatus: TLabel;
    lblEC2Name: TLabel;
    lblEC2ID: TLabel;
    lblEC2Value: TLabel;
    lblEC2Status: TLabel;
    lblORPName: TLabel;
    lblORPID: TLabel;
    lblORPValue: TLabel;
    lblORPStatus: TLabel;
    lblPHName: TLabel;
    lblPHID: TLabel;
    lblPHValue: TLabel;
    lblPHStatus: TLabel;
    lblTemperatureName: TLabel;
    lblTemperatureID: TLabel;
    lblTemperatureValue: TLabel;
    lblTemperatureStatus: TLabel;
    grpRaw: TGroupBox;
    lblPXCaption: TLabel;
    lblPXValue: TLabel;
    lblMVCaption: TLabel;
    lblMVValue: TLabel;
    tmrRefresh: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
  private
    FCommunicationManager: TQVIXCommunicationManager;
    procedure UpdateDisplay;
  public
    property CommunicationManager: TQVIXCommunicationManager
      read FCommunicationManager write FCommunicationManager;
  end;

implementation

{$R *.dfm}

function SnapshotRawText(const ASnapshot: TQVIXIonSensorSnapshot): string;
begin
  Result := Format('R0=%4.4X R1=%4.4X R2=%4.4X R3=%4.4X R4=%4.4X',
    [ASnapshot.RawRegisters[0], ASnapshot.RawRegisters[1],
     ASnapshot.RawRegisters[2], ASnapshot.RawRegisters[3],
     ASnapshot.RawRegisters[4]]);
end;

procedure TfrmSensors.FormCreate(Sender: TObject);
begin
  UpdateDisplay;
end;

procedure TfrmSensors.tmrRefreshTimer(Sender: TObject);
begin
  UpdateDisplay;
end;

procedure TfrmSensors.UpdateDisplay;
var
  Snapshot11: TQVIXIonSensorSnapshot;
  Snapshot12: TQVIXIonSensorSnapshot;
  Snapshot13: TQVIXIonSensorSnapshot;
  Snapshot14: TQVIXIonSensorSnapshot;
  Snapshot15: TQVIXIonSensorSnapshot;
  Online11: Boolean;
  Online12: Boolean;
  Online13: Boolean;
  Online14: Boolean;
  Online15: Boolean;
  AnyOnline: Boolean;
begin
  lblNO2Value.Caption := '--';
  lblECValue.Caption := '--';
  lblPHValue.Caption := '--';
  lblNO2Status.Caption := 'OFFLINE';
  lblECStatus.Caption := 'OFFLINE';
  lblPHStatus.Caption := 'OFFLINE';
  if not Assigned(FCommunicationManager) then
  begin
    lblConnection.Caption := 'COMMUNICATION NOT ASSIGNED';
    lblConnection.Font.Color := clRed;
    Exit;
  end;

  case FCommunicationManager.WaterSensors.State of
    qcsOpening: lblConnection.Caption := 'CONNECTING | COM5';
    qcsOpen: lblConnection.Caption := 'CONNECTED | COM5 | MODBUS RTU';
    qcsError: lblConnection.Caption := 'ERROR | ' +
      FCommunicationManager.WaterSensors.LastMessage;
  else
    lblConnection.Caption := 'DISCONNECTED';
  end;
  if FCommunicationManager.WaterSensors.State = qcsOpen then
    lblConnection.Font.Color := clGreen
  else
    lblConnection.Font.Color := clRed;

  Online11 := (FCommunicationManager.WaterSensors.State = qcsOpen) and
    FCommunicationManager.WaterSensors.TryGetSnapshot(11, Snapshot11);
  Online12 := (FCommunicationManager.WaterSensors.State = qcsOpen) and
    FCommunicationManager.WaterSensors.TryGetSnapshot(12, Snapshot12);
  Online13 := (FCommunicationManager.WaterSensors.State = qcsOpen) and
    FCommunicationManager.WaterSensors.TryGetSnapshot(13, Snapshot13);
  Online14 := (FCommunicationManager.WaterSensors.State = qcsOpen) and
    FCommunicationManager.WaterSensors.TryGetSnapshot(14, Snapshot14);
  Online15 := (FCommunicationManager.WaterSensors.State = qcsOpen) and
    FCommunicationManager.WaterSensors.TryGetSnapshot(15, Snapshot15);
  AnyOnline := Online11 or Online12 or Online13 or Online14 or Online15;
  if (FCommunicationManager.WaterSensors.State = qcsOpen) and
     not AnyOnline then
  begin
    lblConnection.Caption := 'CONNECTED | COM5 | NO SENSOR RESPONSE';
    lblConnection.Font.Color := clRed;
  end;
  if Online11 then
  begin
    lblNO3Value.Caption := Format('%.3f mg/L | %.1f C | pX %.3f | %.1f mV | %s',
      [Snapshot11.ConcentrationMgL, Snapshot11.TemperatureC,
       Snapshot11.PX, Snapshot11.Millivolts, SnapshotRawText(Snapshot11)]);
    lblNO3Status.Caption := 'ONLINE';
    lblNO3Status.Font.Color := clGreen;
  end
  else
  begin
    lblNO3Value.Caption := '--';
    lblNO3Status.Caption := 'OFFLINE';
    lblNO3Status.Font.Color := clRed;
  end;

  lblORPID.Caption := '15';
  if Online15 then
  begin
    lblORPValue.Caption := Format('%.0f mV | %.1f C | %s',
      [Snapshot15.ORPMillivolts, Snapshot15.TemperatureC,
       SnapshotRawText(Snapshot15)]);
    lblORPStatus.Caption := 'ONLINE';
    lblORPStatus.Font.Color := clGreen;
  end
  else
  begin
    lblORPValue.Caption := '--';
    lblORPStatus.Caption := 'OFFLINE';
    lblORPStatus.Font.Color := clRed;
  end;

  lblEC2ID.Caption := '14';
  if Online14 then
  begin
    lblEC2Value.Caption := Format('%.1f uS/cm | %.1f C | %s',
      [Snapshot14.ConductivityUSCm, Snapshot14.TemperatureC,
       SnapshotRawText(Snapshot14)]);
    lblEC2Status.Caption := 'ONLINE';
    lblEC2Status.Font.Color := clGreen;
  end
  else
  begin
    lblEC2Value.Caption := '--';
    lblEC2Status.Caption := 'OFFLINE';
    lblEC2Status.Font.Color := clRed;
  end;

  lblNO2ID.Caption := '12';
  if Online12 then
  begin
    lblNO2Value.Caption := Format('%.3f mg/L | %.1f C | pX %.3f | %.1f mV | %s',
      [Snapshot12.ConcentrationMgL, Snapshot12.TemperatureC,
       Snapshot12.PX, Snapshot12.Millivolts, SnapshotRawText(Snapshot12)]);
    lblPXValue.Caption := FormatFloat('0.000', Snapshot12.PX);
    lblMVValue.Caption := FormatFloat('0.0', Snapshot12.Millivolts) + ' mV';
    lblNO2Status.Caption := 'ONLINE';
    lblNO2Status.Font.Color := clGreen;
  end
  else
  begin
    lblNO2Value.Caption := '--';
    lblPXValue.Caption := '--';
    lblMVValue.Caption := '--';
    lblNO2Status.Caption := 'OFFLINE';
    lblNO2Status.Font.Color := clRed;
  end;

  lblECID.Caption := '13';
  if Online13 then
  begin
    lblECValue.Caption := Format('%.1f uS/cm | %.1f C | %s',
      [Snapshot13.ConductivityUSCm, Snapshot13.TemperatureC,
       SnapshotRawText(Snapshot13)]);
    lblECStatus.Caption := 'ONLINE';
    lblECStatus.Font.Color := clGreen;
  end
  else
  begin
    lblECValue.Caption := '--';
    lblECStatus.Caption := 'OFFLINE';
    lblECStatus.Font.Color := clRed;
  end;

  if Online12 then
  begin
    lblTemperatureID.Caption := '12';
    lblTemperatureValue.Caption := FormatFloat('0.0',
      Snapshot12.TemperatureC) + ' C';
    lblTemperatureStatus.Caption := 'ONLINE';
    lblTemperatureStatus.Font.Color := clGreen;
  end
  else if Online13 then
  begin
    lblTemperatureID.Caption := '13';
    lblTemperatureValue.Caption := FormatFloat('0.0',
      Snapshot13.TemperatureC) + ' C';
    lblTemperatureStatus.Caption := 'ONLINE';
    lblTemperatureStatus.Font.Color := clGreen;
  end
  else if Online14 then
  begin
    lblTemperatureID.Caption := '14';
    lblTemperatureValue.Caption := FormatFloat('0.0',
      Snapshot14.TemperatureC) + ' C';
    lblTemperatureStatus.Caption := 'ONLINE';
    lblTemperatureStatus.Font.Color := clGreen;
  end
  else if Online15 then
  begin
    lblTemperatureID.Caption := '15';
    lblTemperatureValue.Caption := FormatFloat('0.0',
      Snapshot15.TemperatureC) + ' C';
    lblTemperatureStatus.Caption := 'ONLINE';
    lblTemperatureStatus.Font.Color := clGreen;
  end
  else
  begin
    lblTemperatureID.Caption := '--';
    lblTemperatureValue.Caption := '--';
    lblTemperatureStatus.Caption := 'OFFLINE';
    lblTemperatureStatus.Font.Color := clRed;
  end;
end;

end.
