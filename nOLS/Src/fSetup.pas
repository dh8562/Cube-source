unit fSetup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  foEdit,
  foEditCtrls,
  foCommEx,

  Vcl.ExtCtrls, elPanels, elButton, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinOffice2013LightGray, cxPC, VirtualTrees, Vcl.Menus, cxButtons,
  dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxCustomData, cxStyles,
  dxScrollbarAnnotations, cxTL, cxTextEdit, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxContainer, cxEdit, cxGroupBox, cxCheckBox,
  cxColorComboBox, elBase, elPropSaver;

type
  TfrmSetup = class(TForm)
    pcOption: TcxPageControl;
    tsGeneral: TcxTabSheet;
    cbComPortNo: TfoLabeledComboBox;
    tsSetup: TcxTabSheet;
    btnClose: TcxButton;
    GroupBox1: TGroupBox;
    cbLanguage: TfoLabeledComboBox;
    tsPeakList: TcxTabSheet;
    TreeListPeak: TcxVirtualTreeList;
    cxVirtualTreeList1Column1: TcxTreeListColumn;
    cxVirtualTreeList1Column2: TcxTreeListColumn;
    cxVirtualTreeList1Column3: TcxTreeListColumn;
    cxVirtualTreeList1Column4: TcxTreeListColumn;
    btnAddPeak: TcxButton;
    btnEditPeak: TcxButton;
    btnDeletePeak: TcxButton;
    btnSave: TcxButton;
    gbScannerSetup: TcxGroupBox;
    neExposure: TfoLabeledNumberEdit;
    gbGraphSetup: TcxGroupBox;
    neWavelengthMin: TfoLabeledNumberEdit;
    neWavelengthMax: TfoLabeledNumberEdit;
    neIntensityMin: TfoLabeledNumberEdit;
    neIntensityMax: TfoLabeledNumberEdit;
    neReadTime: TfoLabeledNumberEdit;
    neAlarmTimeSet: TfoLabeledNumberEdit;
    cxVirtualTreeList1Column5: TcxTreeListColumn;
    tsAlarmList: TcxTabSheet;
    TreeListAlarm: TcxVirtualTreeList;
    cxTreeListColumn1: TcxTreeListColumn;
    cxTreeListColumn2: TcxTreeListColumn;
    cxTreeListColumn3: TcxTreeListColumn;
    btnDelAlarm: TcxButton;
    btnDeleteAllAlarm: TcxButton;
    PropSaver: TelPropSaver;
    btnAutoSearch: TcxButton;
    Timer1: TTimer;
    neIntensityFactor: TfoLabeledNumberEdit;
    cxGroupBox1: TcxGroupBox;
    cbIFComPortNo: TfoLabeledComboBox;
    cbUseIF: TcxCheckBox;
    cbIFCommKind: TfoLabeledComboBox;
    neAverageCount: TfoLabeledNumberEdit;
    neAreaIntensityFactor: TfoLabeledNumberEdit;
    cbAlarmMode: TfoLabeledComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure TreeListPeakGetChildCount(Sender: TcxCustomTreeList;
      AParentNode: TcxTreeListNode; var ACount: Integer);
    procedure btnAddPeakClick(Sender: TObject);
    procedure btnEditPeakClick(Sender: TObject);
    procedure TreeListPeakSelectionChanged(Sender: TObject);
    procedure btnDeletePeakClick(Sender: TObject);
    procedure TreeListPeakGetNodeValue(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; AColumn: TcxTreeListColumn; var AValue: Variant);
    procedure TreeListAlarmGetChildCount(Sender: TcxCustomTreeList;
      AParentNode: TcxTreeListNode; var ACount: Integer);
    procedure TreeListAlarmGetNodeValue(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; AColumn: TcxTreeListColumn; var AValue: Variant);
    procedure btnDelAlarmClick(Sender: TObject);
    procedure btnDeleteAllAlarmClick(Sender: TObject);
    procedure TreeListAlarmSelectionChanged(Sender: TObject);
    procedure TreeListPeakDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAutoSearchClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnAutoExposureClick(Sender: TObject);
    procedure btnManualExposureClick(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
  private
    { Private declarations }
    FSearchStep : Integer;
    FCOMPortIndex : Integer;
    FSpectrometerIndex: Integer;
    FOriginalSpectrometerCount: Integer;
    FOriginalExposure: Integer;
    FOriginalComPorts: array [0..9] of Integer; // MAX_SPECTROMETER_COUNT
    cbSpectrometerCount: TComboBox;
    cbSpectrometerSetup: TComboBox;
    lblSpectrometerCount: TLabel;
    lblSpectrometerSetup: TLabel;
    lblSpectrometerName: TLabel;
    edSpectrometerName: TEdit;
    procedure SpectrometerSetupChange(Sender: TObject);
  public
    { Public declarations }
    FSelectIndexPeak : Integer;
    FSelectIndexAlarm : Integer;
  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.dfm}

uses fMain, dmData, fEditPeakItem;

procedure TfrmSetup.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  DesktopFont := False;
  FSelectIndexPeak := -1;
  FSelectIndexAlarm := -1;
  FSearchStep := 0;
  FCOMPortIndex := 0;
  FSpectrometerIndex := 0;

  lblSpectrometerSetup := TLabel.Create(Self);
  lblSpectrometerSetup.Parent := tsGeneral;
  lblSpectrometerSetup.SetBounds(28, 8, 80, 17);
  lblSpectrometerSetup.Caption := 'Spectrometer';
  cbSpectrometerSetup := TComboBox.Create(Self);
  cbSpectrometerSetup.Parent := tsGeneral;
  cbSpectrometerSetup.Style := csDropDownList;
  cbSpectrometerSetup.SetBounds(112, 5, 90, 21);
  cbSpectrometerSetup.OnChange := SpectrometerSetupChange;

  lblSpectrometerCount := TLabel.Create(Self);
  lblSpectrometerCount.Parent := tsGeneral;
  lblSpectrometerCount.SetBounds(285, 8, 110, 17);
  lblSpectrometerCount.Caption := 'Spectrometer Count';
  cbSpectrometerCount := TComboBox.Create(Self);
  cbSpectrometerCount.Parent := tsGeneral;
  cbSpectrometerCount.Style := csDropDownList;
  cbSpectrometerCount.SetBounds(405, 5, 60, 21);
  for I := 1 to MAX_SPECTROMETER_COUNT do
    cbSpectrometerCount.Items.Add(IntToStr(I));

  lblSpectrometerName := TLabel.Create(Self);
  lblSpectrometerName.Parent := tsGeneral;
  lblSpectrometerName.SetBounds(285, 49, 36, 17);
  lblSpectrometerName.Caption := 'Name';
  edSpectrometerName := TEdit.Create(Self);
  edSpectrometerName.Parent := tsGeneral;
  edSpectrometerName.SetBounds(330, 46, 135, 21);

  pcOption.ActivePageIndex := 0;

  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  PropSaver.LoadProperty;
end;

procedure TfrmSetup.FormDestroy(Sender: TObject);
begin
  PropSaver.SaveProperty;
end;

procedure TfrmSetup.FormShow(Sender: TObject);
var
  I: Integer;
begin
  pcOption.ActivePageIndex := 0;

  cbLanguage.ItemIndex := Data.Languages;
  cbSpectrometerCount.ItemIndex := SpectrometerCount - 1;
  FOriginalSpectrometerCount := SpectrometerCount;
  FOriginalExposure := Data.Exposure;
  for I := 0 to SpectrometerCount - 1 do
    FOriginalComPorts[I] := Spectrometers[I].ComPortNo;
  cbSpectrometerSetup.Items.Clear;
  for I := 0 to SpectrometerCount - 1 do
    cbSpectrometerSetup.Items.Add(Format('No. %d', [I + 1]));
  FSpectrometerIndex := -1;
  cbComPortNo.ItemIndex := -1;
  cbSpectrometerSetup.ItemIndex := SelectedSpectrometer;
  cbComPortNo.ItemIndex := GetSpectrometer(FSpectrometerIndex).ComPortNo;
  edSpectrometerName.Text := GetSpectrometer(FSpectrometerIndex).DeviceName;
  cbIFComPortNo.ItemIndex := Data.IFComPortNo;
  cbIFCommKind.ItemIndex := Data.IFCommKind;
  cbUseIF.Checked := Boolean(Data.UseIF);
  neExposure.AsInteger := Data.Exposure;
  neReadTime.AsInteger := Data.ReadTime;
  neAlarmTimeSet.AsInteger := Data.AlarmTimeSet;
  neIntensityFactor.Value := Data.IntensityFactor;
  neAverageCount.AsInteger := Data.AverageCount;

  neWavelengthMin.AsInteger := Data.SpecWavelengthMin;
  neWavelengthMax.AsInteger := Data.SpecWavelengthMax;
  neIntensityMin.Value := Data.SpecIntensityMin;
  neIntensityMax.Value := Data.SpecIntensityMax;
  cbAlarmMode.ItemIndex := Data.AlarmMode;


  TreeListPeak.FullRefresh;
  TreeListAlarm.FullRefresh;

end;

procedure TfrmSetup.btnAddPeakClick(Sender: TObject);
var
  PeakItem : TPeakItem;
begin
  with frmEditPeakItem do
  begin
    if ShowModal = mrOk then
    begin
      PeakItem.szName := leName.Text;
      PeakItem.nStartWavelength := leStartIntensity.AsInteger;
      PeakItem.nEndWavelength := leEndWaveLength.AsInteger;
      PeakItem.nStartIntensity := leStartIntensity.AsInteger;
      PeakItem.nEndIntensity := leEndIntensity.AsInteger;
      PeakItem.bUse := cbUse.Checked;
      PeakItem.nColor := cbColor.ColorValue;
      DATA.AddPeakList(PeakItem);
    end;
  end;
  TreeListPeak.FullRefresh;
end;

procedure TfrmSetup.btnAutoSearchClick(Sender: TObject);
begin
  FCOMPortIndex := 0;
  FSearchStep := 1;
  Timer1.Enabled := True;
end;

procedure TfrmSetup.btnCloseClick(Sender: TObject);
begin
  // Closing Setup without Save must not restart the spectrometers.  The old
  // implementation closed and reopened every COM port here, which could
  // disturb an otherwise healthy stopped communication session.
  Timer1.Enabled := False;
  FSearchStep := 0;
  Close;
end;

procedure TfrmSetup.btnDelAlarmClick(Sender: TObject);
begin
  if FSelectIndexAlarm < 0 then exit;
  DATA.DeleteAlarmList(FSelectIndexAlarm);
  TreeListAlarm.FullRefresh;
end;

procedure TfrmSetup.btnDeleteAllAlarmClick(Sender: TObject);
begin
  DATA.DeleteAllAlarmList;
  TreeListAlarm.FullRefresh;
end;

procedure TfrmSetup.btnDeletePeakClick(Sender: TObject);
begin
  if FSelectIndexPeak < 0 then exit;
  DATA.DeletePeakList(FSelectIndexPeak);
  TreeListPeak.FullRefresh;
end;

procedure TfrmSetup.btnEditPeakClick(Sender: TObject);
var
  PeakItem : TPeakItem;
begin
  if FSelectIndexPeak < 0 then exit;

  with frmEditPeakItem do
  begin
    PeakItem := DATA.FPeakList[FSelectIndexPeak];

    leName.Text := PeakItem.szName;
    leStartWaveLength.AsInteger := PeakItem.nStartWavelength;
    leEndWaveLength.AsInteger := PeakItem.nEndWavelength;
    leStartIntensity.Value := PeakItem.nStartIntensity;
    leEndIntensity.Value := PeakItem.nEndIntensity;
    cbUse.Checked := PeakItem.bUse;
    cbColor.ColorValue := PeakItem.nColor;
    frmEditPeakItem.BringToFront;
    if ShowModal = mrOk then
    begin
      PeakItem.szName := leName.Text;
      PeakItem.nStartWavelength := leStartWaveLength.AsInteger;
      PeakItem.nEndWavelength := leEndWaveLength.AsInteger;
      PeakItem.nStartIntensity := leStartIntensity.Value;
      PeakItem.nEndIntensity := leEndIntensity.Value;
      PeakItem.bUse := cbUse.Checked;
      PeakItem.nColor := cbColor.ColorValue;
      DATA.EditPeakList(FSelectIndexPeak, PeakItem);
    end;
  end;
  TreeListPeak.FullRefresh;

end;

procedure TfrmSetup.btnSaveClick(Sender: TObject);
var
  I, NewCount: Integer;
  NeedReconnect, NeedApplyExposure: Boolean;
begin
  Data.Languages := cbLanguage.ItemIndex;
  GetSpectrometer(FSpectrometerIndex).ComPortNo := cbComPortNo.ItemIndex;
  GetSpectrometer(FSpectrometerIndex).DeviceName := Trim(edSpectrometerName.Text);
  if GetSpectrometer(FSpectrometerIndex).DeviceName = '' then
    GetSpectrometer(FSpectrometerIndex).DeviceName :=
      Format('Spectrometer %d', [FSpectrometerIndex + 1]);
  NewCount := cbSpectrometerCount.ItemIndex + 1;
  NeedReconnect := NewCount <> FOriginalSpectrometerCount;
  if not NeedReconnect then
    for I := 0 to NewCount - 1 do
      if Spectrometers[I].ComPortNo <> FOriginalComPorts[I] then
      begin
        NeedReconnect := True;
        Break;
      end;
  NeedApplyExposure := neExposure.AsInteger <> FOriginalExposure;
  SetSpectrometerCount(NewCount);
  Data.IFComPortNo := cbIFComPortNo.ItemIndex;
  Data.IFCommKind := cbIFCommKind.ItemIndex;
  Data.UseIF := Integer(cbUseIF.Checked);
  Data.MultiLang.ActiveLanguage := Data.Languages;
  Data.Exposure := neExposure.AsInteger;
  Data.ReadTime := neReadTime.AsInteger;
  Data.AlarmTimeSet := neAlarmTimeSet.AsInteger;
  Data.IntensityFactor := neIntensityFactor.Value;
  Data.AverageCount := neAverageCount.AsInteger;
  Data.SpecWavelengthMin := neWavelengthMin.AsInteger;
  Data.SpecWavelengthMax := neWavelengthMax.AsInteger;
  Data.SpecIntensityMin := neIntensityMin.Value;
  Data.SpecIntensityMax := neIntensityMax.Value;
  Data.AlarmMode := cbAlarmMode.ItemIndex;
  for I := 1 to SpectrometerCount - 1 do
    Spectrometers[I].CopySettingsFrom(Data);
  for I := 0 to SpectrometerCount - 1 do
    Spectrometers[I].SaveSetting;
  if NeedReconnect then
    frmMain.ReloadSpectrometers
  else if NeedApplyExposure then
    for I := 0 to SpectrometerCount - 1 do
      Spectrometers[I].ApplyCommunicationSettings;

  FOriginalSpectrometerCount := SpectrometerCount;
  FOriginalExposure := Data.Exposure;
  for I := 0 to SpectrometerCount - 1 do
    FOriginalComPorts[I] := Spectrometers[I].ComPortNo;
end;

procedure TfrmSetup.SpectrometerSetupChange(Sender: TObject);
begin
  if cbSpectrometerSetup.ItemIndex < 0 then Exit;
  if (FSpectrometerIndex >= 0) and (FSpectrometerIndex < SpectrometerCount) then
  begin
    GetSpectrometer(FSpectrometerIndex).ComPortNo := cbComPortNo.ItemIndex;
    GetSpectrometer(FSpectrometerIndex).DeviceName := Trim(edSpectrometerName.Text);
    if GetSpectrometer(FSpectrometerIndex).DeviceName = '' then
      GetSpectrometer(FSpectrometerIndex).DeviceName :=
        Format('Spectrometer %d', [FSpectrometerIndex + 1]);
  end;
  FSpectrometerIndex := cbSpectrometerSetup.ItemIndex;
  cbComPortNo.ItemIndex := GetSpectrometer(FSpectrometerIndex).ComPortNo;
  edSpectrometerName.Text := GetSpectrometer(FSpectrometerIndex).DeviceName;
end;

procedure TfrmSetup.cbLanguageChange(Sender: TObject);
begin
  Data.MultiLang.ActiveLanguage := Data.Languages;
end;

procedure TfrmSetup.btnAutoExposureClick(Sender: TObject);
begin
  DATA.SetAutoExposureMode;
end;

procedure TfrmSetup.btnManualExposureClick(Sender: TObject);
begin
  DATA.SetManualExposureMode;
end;

procedure TfrmSetup.Timer1Timer(Sender: TObject);
begin
  case FSearchStep of
    1 :
    begin
      cbComPortNo.ItemIndex := FCOMPortIndex;
      DATA.FCOMM.Port := TfocPort(FCOMPortIndex);
      DATA.FCOMM.CloseComm;
      DATA.FCOMM.OpenComm;
      FSearchStep := 2;
    end;
    2 :
    begin
      DATA.SetManualExposureMode;
      FSearchStep := 3;
    end;
    3 :
    begin
      if not DATA.FStartMeas then
      begin
        FSearchStep := 4;
      end
      else
      begin
        Inc(FCOMPortIndex);
        if FCOMPortIndex < cbComPortNo.Items.Count  then
        begin
          FSearchStep := 1;
        end
        else
        begin
          FSearchStep := 0;
          Timer1.Enabled := False;
          MessageDlg('Not found', mtWarning, [mbOK], 0);
        end;
      end;
    end;
    4 :
    begin
      FSearchStep := 0;
      Timer1.Enabled := False;
      MessageDlg('found', mtInformation, [mbOK], 0);
    end;

  end;
end;

procedure TfrmSetup.TreeListAlarmGetChildCount(Sender: TcxCustomTreeList;
  AParentNode: TcxTreeListNode; var ACount: Integer);
begin
  if AParentNode.Level = -1 then
  begin
    ACount := DATA.FAlarmListCount;
  end
end;

procedure TfrmSetup.TreeListAlarmGetNodeValue(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AColumn: TcxTreeListColumn; var AValue: Variant);
var
  N : Integer;
begin
  N := ANode.Index;

  if N < 0 then exit;


  case AColumn.ItemIndex of
    0 : AValue := Data.FAlarmList[N].szName;
    1 : AValue := Data.FAlarmList[N].szTime;
    2 : AValue := Format('%.2f',[Data.FAlarmList[N].dIntensity]);
  end;

end;

procedure TfrmSetup.TreeListAlarmSelectionChanged(Sender: TObject);
var
  List: TList;
  Node : TcxTreeListNode;
  szValue : String;
  nIndex : Integer;
begin
  List := TList.Create;
  Node := TreeListAlarm.GetSelections(List);
  if Node <> nil then
  begin
    FSelectIndexAlarm := Node.Index;
  end;
  List.Free;
end;

procedure TfrmSetup.TreeListPeakDblClick(Sender: TObject);
begin
  if FSelectIndexPeak >= 0 then
  begin
    btnEditPeak.Click;
  end;

end;

procedure TfrmSetup.TreeListPeakGetChildCount(Sender: TcxCustomTreeList;
  AParentNode: TcxTreeListNode; var ACount: Integer);
begin
  if AParentNode.Level = -1 then
  begin
    ACount := DATA.FPeakListCount;
  end
end;

procedure TfrmSetup.TreeListPeakGetNodeValue(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AColumn: TcxTreeListColumn; var AValue: Variant);
var
  N : Integer;
begin
  N := ANode.Index;

  case AColumn.ItemIndex of
    0 : AValue := Data.FPeakList[N].bUse;
    1 : AValue := Data.FPeakList[N].szName;
    2 : AValue := Format('%d ~ %d',[Data.FPeakList[N].nStartWavelength, Data.FPeakList[N].nEndWavelength]);
    3 : AValue := Format('%g ~ %g',[Data.FPeakList[N].nStartIntensity, Data.FPeakList[N].nEndIntensity]);
    4 : AValue := Data.FPeakList[N].nColor;
  end;
end;

procedure TfrmSetup.TreeListPeakSelectionChanged(Sender: TObject);
var
  List: TList;
  Node : TcxTreeListNode;
  szValue : String;
  nIndex : Integer;
begin
  List := TList.Create;
  Node := TreeListPeak.GetSelections(List);
  if Node <> nil then
  begin
    FSelectIndexPeak := Node.Index;
  end;
  List.Free;
end;

end.


