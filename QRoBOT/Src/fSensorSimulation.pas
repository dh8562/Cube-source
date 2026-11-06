unit fSensorSimulation;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Forms, Vcl.Graphics,
  Vcl.StdCtrls, uTouchInput;

type
  TfrmSensorSimulation = class(TForm)
    lblTitle: TLabel;
    lblNote: TLabel;
    lblNO3: TLabel;
    edtNO3: TEdit;
    lblNO2: TLabel;
    edtNO2: TEdit;
    lblEC: TLabel;
    edtEC: TEdit;
    lblPH: TLabel;
    edtPH: TEdit;
    lblTemperature: TLabel;
    edtTemperature: TEdit;
    lblWaterLevel: TLabel;
    edtWaterLevel: TEdit;
    chkNO3Online: TCheckBox;
    chkNO2Online: TCheckBox;
    chkECOnline: TCheckBox;
    chkPHOnline: TCheckBox;
    chkTemperatureOnline: TCheckBox;
    chkWaterOnline: TCheckBox;
    chkTrend: TCheckBox;
    btnRestore: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    lblMessage: TLabel;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
  private
    FNO3: Double;
    FNO2: Double;
    FEC: Double;
    FPH: Double;
    FTemperature: Double;
    FWaterLevel: Double;
    FTrend: Boolean;
    FNO3Online, FNO2Online, FECOnline, FPHOnline,
      FTemperatureOnline, FWaterOnline: Boolean;
    procedure LoadControls;
  public
    function Execute(var ANO3, ANO2, AEC, APH, ATemperature,
      AWaterLevel: Double; var ATrend, ANO3Online, ANO2Online, AECOnline,
      APHOnline, ATemperatureOnline, AWaterOnline: Boolean): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmSensorSimulation.btnApplyClick(Sender: TObject);
begin
  if (not TryStrToFloat(edtNO3.Text, FNO3)) or (FNO3 < 0) or
     (not TryStrToFloat(edtNO2.Text, FNO2)) or (FNO2 < 0) or
     (not TryStrToFloat(edtEC.Text, FEC)) or (FEC < 0) or
     (not TryStrToFloat(edtPH.Text, FPH)) or (FPH < 0) or (FPH > 14) or
     (not TryStrToFloat(edtTemperature.Text, FTemperature)) or
       (FTemperature < 0) or (FTemperature > 100) or
     (not TryStrToFloat(edtWaterLevel.Text, FWaterLevel)) or
       (FWaterLevel < 0) or (FWaterLevel > 100) then
  begin
    lblMessage.Caption := 'Check the simulated sensor values.';
    lblMessage.Font.Color := clRed;
    Exit;
  end;
  FTrend := chkTrend.Checked;
  FNO3Online := chkNO3Online.Checked;
  FNO2Online := chkNO2Online.Checked;
  FECOnline := chkECOnline.Checked;
  FPHOnline := chkPHOnline.Checked;
  FTemperatureOnline := chkTemperatureOnline.Checked;
  FWaterOnline := chkWaterOnline.Checked;
  ModalResult := mrOk;
end;

procedure TfrmSensorSimulation.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSensorSimulation.btnRestoreClick(Sender: TObject);
begin
  FNO3 := 2.0;
  FNO2 := 0.1;
  FEC := 194;
  FPH := 7.8;
  FTemperature := 22;
  FWaterLevel := 75;
  FTrend := True;
  FNO3Online := True;
  FNO2Online := True;
  FECOnline := True;
  FPHOnline := True;
  FTemperatureOnline := True;
  FWaterOnline := True;
  LoadControls;
  lblMessage.Caption := 'Demo values restored.';
  lblMessage.Font.Color := clGreen;
end;

function TfrmSensorSimulation.Execute(var ANO3, ANO2, AEC, APH,
  ATemperature, AWaterLevel: Double; var ATrend, ANO3Online, ANO2Online,
  AECOnline, APHOnline, ATemperatureOnline, AWaterOnline: Boolean): Boolean;
begin
  EnableTouchKeyboards(Self);
  FNO3 := ANO3;
  FNO2 := ANO2;
  FEC := AEC;
  FPH := APH;
  FTemperature := ATemperature;
  FWaterLevel := AWaterLevel;
  FTrend := ATrend;
  FNO3Online := ANO3Online;
  FNO2Online := ANO2Online;
  FECOnline := AECOnline;
  FPHOnline := APHOnline;
  FTemperatureOnline := ATemperatureOnline;
  FWaterOnline := AWaterOnline;
  LoadControls;
  Result := ShowModal = mrOk;
  if Result then
  begin
    ANO3 := FNO3;
    ANO2 := FNO2;
    AEC := FEC;
    APH := FPH;
    ATemperature := FTemperature;
    AWaterLevel := FWaterLevel;
    ATrend := FTrend;
    ANO3Online := FNO3Online;
    ANO2Online := FNO2Online;
    AECOnline := FECOnline;
    APHOnline := FPHOnline;
    ATemperatureOnline := FTemperatureOnline;
    AWaterOnline := FWaterOnline;
  end;
end;

procedure TfrmSensorSimulation.LoadControls;
begin
  edtNO3.Text := FormatFloat('0.00', FNO3);
  edtNO2.Text := FormatFloat('0.00', FNO2);
  edtEC.Text := FormatFloat('0', FEC);
  edtPH.Text := FormatFloat('0.00', FPH);
  edtTemperature.Text := FormatFloat('0.0', FTemperature);
  edtWaterLevel.Text := FormatFloat('0', FWaterLevel);
  chkTrend.Checked := FTrend;
  chkNO3Online.Checked := FNO3Online;
  chkNO2Online.Checked := FNO2Online;
  chkECOnline.Checked := FECOnline;
  chkPHOnline.Checked := FPHOnline;
  chkTemperatureOnline.Checked := FTemperatureOnline;
  chkWaterOnline.Checked := FWaterOnline;
end;

end.
