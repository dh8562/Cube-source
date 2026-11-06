unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ShellApi,
  ExtCtrls,
  Menus,
  ImgList,
  AppEvnts,
  ActnList,
  StdCtrls,
  Mask,
  Actions,
  IniFiles,
  StrUtils,
  Math,
  ImageList,
  SyncObjs,

  elBase,
  elPropSaver,
  elMultiLanguage,
  elWinUtils,
  elHotKey,
  elExplorerBar,

  CodeSiteLogging,

  dmData,
  uCommonUtils,

  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsDefaultPainters,
  dxRibbonSkins,
  dxSkinsCore,
  dxSkinOffice2013LightGray,
  dxBarBuiltInMenu,
  dxAlertWindow,
  dxSkinsForm,
  cxImageList,
  dxBarExtItems,
  dxBar,
  cxClasses,
  dxStatusBar,
  dxRibbon,
  dxRibbonCustomizationForm,
  foEdit,
  foButtonEdit,
  voControls,
  voVision,
  cxButtons,
  cxBarEditItem,
  cxSpinEdit,
  cxContainer,
  cxEdit,
  cxLabel,
  cxTextEdit,
  cxMaskEdit,

  foControls,
  foIndicator,
  foStringUtils,

  USB_RELAY_DEVICE,

  voGeometry,
  voLiveVision,

  Vcl.Buttons,
  cxDropDownEdit,
  dxCore,
  elButton,
  elPanels,
  VirtualTrees,
  cxTrackBar,
  elLog,
  cxImage,
  dxGDIPlusClasses, voThreadTimer, foCommEx, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, dxSkinBasic, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black,
  dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, foLED, cxGroupBox, cxRadioGroup;

const
  UM_TRAYICON = WM_USER + 10003;
  MAX_RESULT_DATA = 1000;

  POS_BASE1 = 0;
  POS_BASE2 = 1;
  POS_LEFT 	= 2;
  POS_RIGHT = 3;
  POS_COUNT = 4;

  MEAS_MODE_NONE  = 0;
  MEAS_MODE_LINE  = 1;
  MEAS_MODE_MEAS  = 2;
  MEAS_MODE_CAL   = 3;
  MEAS_MODE_DROP_SIZE = 4;

type
  TRunState = (rsNone, rsRun, rsRunOk, rsStop, rsStopOk, rsError, rsErrorOk);

  PCopyDataStruct = ^TCopyDataStruct;

  TCopyDataStruct = record
    dwData: ULONG_PTR;
    cbData: DWORD;
    lpData: Pointer;
  end;

type
  TfrmMain = class(TForm)
    ApplicationEvents: TApplicationEvents;
    ActionList: TActionList;
    ilLarge: TcxImageList;
    SkinController: TdxSkinController;
    OpenDialog: TOpenDialog;
    ilSmall: TcxImageList;
    AlertWindowManager: TdxAlertWindowManager;
    ilAlertMessage: TcxImageList;
    ilAlertButtons: TcxImageList;
    actChangeSkin: TAction;
    OpenSkinDialog: TOpenDialog;
    SB: TdxStatusBar;
    elResultData: TelLog;
    SaveDialog: TSaveDialog;
    SaveExportDialog: TSaveDialog;
    tmrContMeasure: TTimer;
    panClient: TelPanel;
    cxImageList1: TcxImageList;
    alMain: TActionList;
    actClose: TAction;
    ilMain: TcxImageList;
    actAlwaysOnTop: TAction;
    actSetup: TAction;
    actStop: TAction;
    actStart: TAction;
    tmrCheckLock: TTimer;
    actABC: TAction;
    panCommand: TPanel;
    btnClose: TcxButton;
    btnABC: TcxButton;
    imgCustomer: TcxImage;
    btnStart: TcxButton;
    PropSaver: TelPropSaver;
    pmSkin: TPopupMenu;
    NativeStyle1: TMenuItem;
    ChangeSkin1: TMenuItem;
    N1: TMenuItem;
    actNativeStyle: TAction;
    btnSetup: TcxButton;
    btnStop: TcxButton;
    tmrSetup: TTimer;
    panTitle: TPanel;
    panTotalScan: TPanel;
    panPeakScan: TPanel;
    panPeakScanLeft: TPanel;
    chtPeakScan: TChart;
    chtTotalScan: TChart;
    Series1: TFastLineSeries;
    elPanel1: TelPanel;
    ledResultFault: TfoLED;
    Series2: TFastLineSeries;
    panIntensityName: TelPanel;
    panPeakIntensity: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    tmrRunStatus: TTimer;
    btnSave: TcxButton;
    actSave: TAction;
    SaveDialogCSV: TSaveDialog;
    elPanel2: TelPanel;
    foLED1: TfoLED;
    Panel3: TPanel;
    ledProcess: TfoLED;
    ledMonitor: TfoLED;
    cbSpectrometer: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure AlertWindowManagerShow(Sender: TObject;
      AAlertWindow: TdxAlertWindow);
    procedure AlertWindowManagerButtonClick(Sender: TObject;
      AAlertWindow: TdxAlertWindow; AButtonIndex: Integer);
    procedure actChangeSkinExecute(Sender: TObject);
    procedure actNoiseReductionExecute(Sender: TObject);
    procedure tmrContMeasureTimer(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actAlwaysOnTopExecute(Sender: TObject);
    procedure actSetupExecute(Sender: TObject);
    procedure actABCExecute(Sender: TObject);
    procedure chtTotalScanAfterDraw(Sender: TObject);
    procedure actNativeStyleExecute(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure tmrSetupTimer(Sender: TObject);
    procedure panClientResize(Sender: TObject);
    procedure ledResultFaultDblClick(Sender: TObject);
    procedure tmrRunStatusTimer(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure SpectrometerChange(Sender: TObject);
  private
    { Private declarations }
    FLockCount : Integer;
    FKeyLockError : Boolean;

    FSetupSeqNo : Integer;
    FRunState : TRunState;
    FRunCount : Integer;
    FRunFlashOn : Boolean;
    FRunError : Boolean;

    procedure ChangeSkin(const ASkinName : string);

    function CheckUsbKey : Boolean;
    procedure LoadSetting;
    procedure SaveSetting;

    procedure LoadSkin(const ASkinFileName: string);
    procedure ApplySkinColors(const ASkinName: string);
    procedure RefreshSpectrometerList;
    procedure EvaluateAlarm(AData: TData);
    procedure OpenSpectrometer(AData: TData);
    function AnyAlarmActive: Boolean;

  public
    function GetAngle(X1, Y1, X2, Y2: Double): Double;
    procedure GetAnglePos(X1, Y1, CX, CY, DA : Double; var DX : Double; Var DY : Double);

    function GetConsts(const ConstID : Integer) : string;

    procedure Clear(AChart : TChart);
    procedure SetupChart;
    procedure FillSeries;
    procedure CreateSeries(AParentChart : TChart; const ATitle : string; const AColor : TColor);
    procedure ReloadSpectrometers;

    procedure UMUpdateGraphChanged(var AMessage : TMessage); message UM_UPDATE_GRAPH_CHANGED;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;

  end;

var
  frmMain: TfrmMain;

procedure DebugMessageProc(szMsg: PAnsiChar); stdcall;

implementation

{$R *.dfm}

uses fSetup;

procedure DebugMessageProc(szMsg: PAnsiChar); stdcall;
begin
  if LogLevel >= 1 then
    Codesite.SendFmtMsg('DebugMessageProc = %s', [szMsg]);
end;

function IsOrWasUnderDebugger: Boolean;
begin
  Result := DebugHook <> 0;
end;

procedure EmbedFormTo(AForm : TCustomForm ; AParent : TWinControl);
begin
  AForm.Parent := AParent;
  AForm.BorderStyle := bsNone;
  AForm.Align := alClient;
  AForm.Visible := True;
end;


function TfrmMain.GetConsts(const ConstID : Integer) : string;
begin
  Result := Data.MultiLang.GetMessage(ConstID);
end;

procedure TfrmMain.ledResultFaultDblClick(Sender: TObject);
var
  D: TData;
begin
  D := CurrentSpectrometer;
  FRunError := False;
  FRunCount := 0;

  if tmrContMeasure.Enabled then
  begin
    FRunState := rsRun;
  end
  else
  begin
    FRunState := rsStop;
  end;

  D.FFaultTimeer.Start;
  D.FFaultMeasString := True;
  D.AlarmActive := False;
  FRunError := AnyAlarmActive;

  if Data.IFCommKind = 0 then
  begin
    D.WriteIFComm(False);
  end;
end;

procedure TfrmMain.ChangeSkin(const ASkinName: string);
var
  I : Integer;
begin
  if ASkinName <> '' then
  begin
    SkinController.SkinName := 'UserSkin';
    SkinController.NativeStyle := False;
    dxSkinsUserSkinLoadFromFile(ASkinName);
  end
  else
  begin
    SkinController.SkinName := '';
    SkinController.NativeStyle := True;
  end;

  PropSaver.WriteString('General', 'Skin', ASkinName);
  for I := 0 to Screen.FormCount - 1 do
  begin
    ApplySkinColor(SkinController.SkinName, Screen.Forms[I]);
  end;
end;

function TfrmMain.CheckUsbKey : Boolean;
begin
  if FKeyLockError then
  begin
    elWarning(Handle, 'Warning', 'USB Lock Key is not found.');
    Result := False;
    exit;
  end;
  Result := True;
end;

procedure TfrmMain.chtTotalScanAfterDraw(Sender: TObject);
var
  tmpY1, tmpY2 : LongInt;
  tmpAY1, tmpAY2 : LongInt;
  I : Integer;
begin
//  if gResultDataCount = 0 then exit;
//  if FReportIndex >= gResultDataCount then exit;
//
//  I :=  FReportIndex;
//
//  tmpY1 := TChart(Sender).Series[0].GetVertAxis.CalcPosValue(gResultData[I].dSpecMin);
//  tmpY2 := TChart(Sender).Series[0].GetVertAxis.CalcPosValue(gResultData[I].dSpecMax);
//
//  with TChart(Sender) do
//  begin
//    if gResultData[I].bGraphView then
//    begin
//      Canvas.Pen.Width := 2;
//      Canvas.Pen.Color := clPurple;
//      Canvas.MoveTo(ChartRect.Left, tmpY1);
//      Canvas.LineTo(ChartRect.Right, tmpY1);
//
//      Canvas.Pen.Color := clRed;
//      Canvas.MoveTo(ChartRect.Left, tmpY2);
//      Canvas.LineTo(ChartRect.Right, tmpY2);
//    end;
//  end;
end;

procedure TfrmMain.Clear(AChart: TChart);
var
  Series : TChartSeries;
  I : Integer;
begin
  if AChart.SeriesList.Count > 0 then
  begin
    for I := AChart.SeriesList.Count - 1 downto 0 do
    begin
      Series := AChart.Series[I];
      AChart.RemoveSeries(AChart.Series[I]);
      Series.Free;
    end;
  end;
end;

procedure TfrmMain.CreateSeries(AParentChart: TChart; const ATitle: string;
  const AColor: TColor);
var
  S : TFastLineSeries;
begin
  S := TFastLineSeries.Create(Self);
  S.ParentChart := AParentChart;
  S.Title := ATitle;
  S.SeriesColor := AColor;

  S.Pen.Width := 2;
  S.FillSampleValues(0);
  AParentChart.AddSeries(S);
end;

procedure TfrmMain.actABCExecute(Sender: TObject);
begin
  Data.MultiLang.ActiveLanguage := 0;
end;

procedure TfrmMain.actAlwaysOnTopExecute(Sender: TObject);
begin
  if actAlwaysOnTop.Checked then
    SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, 0)
  else
    SetWindowPos(Handle, HWND_NOTOPMOST, Left, Top, Width, Height, 0);
end;

procedure TfrmMain.actChangeSkinExecute(Sender: TObject);
begin
  if OpenSkinDialog.Execute then
  begin
    ChangeSkin(OpenSkinDialog.FileName);
  end;
end;

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actNativeStyleExecute(Sender: TObject);
begin
  ChangeSkin('');
end;

procedure TfrmMain.actNoiseReductionExecute(Sender: TObject);
begin
;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  if SaveDialogCSV.Execute then
  begin
    DATA.SavePeakData(SaveDialogCSV.FileName);
  end;
end;

procedure TfrmMain.actSetupExecute(Sender: TObject);
begin
  actStop.Execute;
  frmSetup.Show;
end;

procedure TfrmMain.actStartExecute(Sender: TObject);
var
  I: Integer;
begin
  tmrContMeasure.Interval := CurrentSpectrometer.ReadTime;
  tmrContMeasure.Enabled := True;
  for I := 0 to SpectrometerCount - 1 do
    Spectrometers[I].FMeasTimeer.Start;
  btnStart.Enabled := False;
  btnStop.Enabled := True;

  if not FRunError then FRunState := rsRun;
end;

procedure TfrmMain.actStopExecute(Sender: TObject);
begin
  //DATA.StopContData;
  tmrContMeasure.Enabled := False;
  btnStart.Enabled := True;
  btnStop.Enabled := False;

  if not FRunError then FRunState := rsStop;
end;

procedure TfrmMain.AlertWindowManagerButtonClick(Sender: TObject;
  AAlertWindow: TdxAlertWindow; AButtonIndex: Integer);
begin
  AAlertWindow.Close;
end;

procedure TfrmMain.AlertWindowManagerShow(Sender: TObject;
  AAlertWindow: TdxAlertWindow);
begin
  AAlertWindow.Pinned := True;
end;

procedure TfrmMain.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
//  if DataCenter.ImageFileName = '' then
//    Caption := Format('%s - %s', [Application.Title, 'NO IMAGE'])
//  else
//    Caption := Format('%s - %s', [Application.Title, DataCenter.ImageFileName]);
end;

procedure TfrmMain.FillSeries;
var
  S, SRange : TFastLineSeries;

  I, N, SeriesIndex : Integer;
  dMin, dMax : Double;
  dTime, dValue : Double;
  dAxisMin, dAxisMax: Double;
  bFirstPeak : Boolean;
  D: TData;
begin
  D := CurrentSpectrometer;
  S := TFastLineSeries(chtTotalScan.Series[0]);
  S.Clear;

  for N := 0 to D.FDataCount - 1 do
  begin
    S.AddXY(D.FWAVE[N], D.FDATA[N]);
  end;

  dAxisMin := D.SpecWavelengthMin;
  dAxisMax := D.SpecWavelengthMax;
  if IsNan(dAxisMin) or IsInfinite(dAxisMin) then dAxisMin := 0;
  if IsNan(dAxisMax) or IsInfinite(dAxisMax) or (dAxisMax <= dAxisMin) then
    dAxisMax := dAxisMin + 1;
  chtTotalScan.BottomAxis.SetMinMax(dAxisMin, dAxisMax);

  dAxisMax := D.SpecIntensityMax;
  if IsNan(dAxisMax) or IsInfinite(dAxisMax) or (dAxisMax <= 0) then
    dAxisMax := 1;
  chtTotalScan.LeftAxis.SetMinMax(0, dAxisMax);

  bFirstPeak := True;
  dMin := 9999;
  dMax := 0;
  SRange := TFastLineSeries(chtPeakScan.Series[0]);
  SRange.Clear;
  SeriesIndex := 1;
  for I := 0 to D.FPeakListCount - 1 do
  begin
    if D.FPeakList[I].bUse then
    begin
      if dMin > D.FPeakList[I].nStartIntensity then dMin := D.FPeakList[I].nStartIntensity;
      if dMax < D.FPeakList[I].nEndIntensity then dMax := D.FPeakList[I].nEndIntensity;

      if SeriesIndex >= chtPeakScan.SeriesCount then Continue;
      S := TFastLineSeries(chtPeakScan.Series[SeriesIndex]);
      Inc(SeriesIndex);
      S.Clear;
      for N := 0 to D.FPeakDataCount - 1 do
      begin
        dValue := D.FPeakList[I].nStartIntensity;
        dTime := D.FPeakData[I, N].dTime;
        SRange.AddXY(dTime, dValue);

        dValue := D.FPeakData[I, N].dValue;
        dTime := D.FPeakData[I, N].dTime;
        S.AddXY(dTime, dValue);
      end;

      if bFirstPeak then
      begin
        bFirstPeak := False;
        dValue := D.FPeakList[I].dIntensity;
        if IsNan(dValue) or IsInfinite(dValue) then dValue := 0;
        panPeakIntensity.Caption := FormatFloat('#,##0', Trunc(dValue));

        if D.FPeakDataCount > 0 then
        begin
          dAxisMin := D.FPeakData[I, 0].dTime;
          dAxisMax := D.FPeakData[I, D.FPeakDataCount - 1].dTime;
          if IsNan(dAxisMin) or IsInfinite(dAxisMin) then dAxisMin := 0;
          if IsNan(dAxisMax) or IsInfinite(dAxisMax) or
             (dAxisMax <= dAxisMin) then
            dAxisMax := dAxisMin + Max(0.001, D.ReadTime / 1000);
          chtPeakScan.BottomAxis.SetMinMax(dAxisMin, dAxisMax);
        end;
      end;
    end;
  end;


  if IsNan(dMax) or IsInfinite(dMax) or (dMax <= 0) then
    dMax := 1;
  chtPeakScan.LeftAxis.SetMinMax(0, dMax);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  // Stop all UI-driven communication before releasing device objects.
  tmrRunStatus.Enabled := False;
  tmrCheckLock.Enabled := False;
  tmrContMeasure.Enabled := False;
  tmrSetup.Enabled := False;

  for I := 0 to SpectrometerCount - 1 do
  case Spectrometers[I].SpectrometerKind of
    SPECTROMETER_KIND_OLD, SPECTROMETER_KIND_NEW:
      begin
        Spectrometers[I].CloseComm;
      end;
    SPECTROMETER_KIND_QMINI:
      begin
        Spectrometers[I].SendToRgbServer(MSG_FINALIZE, '');
      end;
  end;

  if Boolean(DATA.UseIF) then
  begin
    DATA.WriteTowerLampOff;
    Sleep(30);
    DATA.FIFCOMM.CloseComm;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: Integer;
  pixelCount: Integer;
begin
  DesktopFont := False;

  Data.PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  Data.PropSaver.LoadProperty;
  Data.PropSaver.LoadFormState;

  DesktopFont := True;
  Self.Caption := Application.Title;

  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  PropSaver.LoadProperty;

  LoadSetting;
  LoadSkin(Data.PropSaver.ReadString('General', 'Skin', ''));

  AlertWindowManager.OptionsMessage.Caption.Font := Screen.IconFont;
  AlertWindowManager.OptionsMessage.Text.Font := Screen.IconFont;

  FLockCount := 0;
  FKeyLockError := False;
  FSetupSeqNo := 0;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  PropSaver.SaveProperty;

  Data.PropSaver.SaveProperty;
  Data.PropSaver.SaveFormState;
  SaveSetting;
  for I := 1 to SpectrometerCount - 1 do
    Spectrometers[I].SaveSetting;
  FinalizeSpectrometers;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  LangAbbr : string;
  FileName : String;
  I: Integer;
begin
  ApplySkinColors(SkinController.SkinName);

  if Data.Languages = -1 then
  begin
    if SysLocale.PriLangID = LANG_KOREAN then
      LangAbbr := 'KOR'
    else if SysLocale.PriLangID = LANG_JAPANESE then
      LangAbbr := 'JPN'
    else if (SysLocale.PriLangID = LANG_CHINESE) and (SysLocale.SubLangID = SUBLANG_CHINESE_TRADITIONAL) then
      LangAbbr := 'CHT'
    else if (SysLocale.PriLangID = LANG_CHINESE) and (SysLocale.SubLangID = SUBLANG_CHINESE_SIMPLIFIED) then
      LangAbbr := 'CHS'
    else
      LangAbbr := 'ENU';

    Data.MultiLang.ActiveLocaleAbbr := Data.PropSaver.ReadString('General', 'ActiveLanguage', LangAbbr);
  end
  else
  begin
    Data.MultiLang.ActiveLanguage := Data.Languages;
  end;

  tmrCheckLock.Enabled := True;

  RefreshSpectrometerList;
  for I := 0 to SpectrometerCount - 1 do
    OpenSpectrometer(Spectrometers[I]);
  {
  case Data.SpectrometerKind of
    SPECTROMETER_KIND_OLD:
      begin
        Data.FCOMM.BaudRate := _921600;
        Data.FCOMM.Port := TfocPort(Data.ComPortNo);
        Data.OpenComm;
      end;
    SPECTROMETER_KIND_NEW:
      begin
        Data.FCOMM.BaudRate := _256000;
        Data.FCOMM.Port := TfocPort(Data.ComPortNo);
        Data.OpenComm;
      end;
    SPECTROMETER_KIND_QMINI:
      begin
        if not Data.SendToRgbServer(MSG_INITIALIZE, Caption) then
        begin
          FileName := elAppPath + 'RgbDriverKitExe.exe';
          ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_HIDE);
          Sleep(1000);
          Data.SendToRgbServer(MSG_INITIALIZE, Caption);
        end;

        Data.SendToRgbServer(MSG_GET_EXPOSURE, '');
        Data.SendToRgbServer(MSG_GET_PIXEL_COUNT, '');
        Data.SendToRgbServer(MSG_GET_WAVELENGTHS, '');
      end;
  end;
  }
  
  if Boolean(DATA.UseIF) then
  begin
    DATA.FIFCOMM.BaudRate := ___9600;
    DATA.FIFCOMM.Port := TfocPort(DATA.IFComPortNo);
    DATA.FIFCOMM.OpenComm;
    tmrRunStatus.Enabled := True;
  end;

  ledProcess.LED.Value := (Data.AlarmMode = 0);
  ledMonitor.LED.Value := (Data.AlarmMode = 1);

  SetupChart;
  FillSeries;

  FRunError := False;
  FRunCount := 0;
  FRunState := rsStop;
  actStop.Execute;

  tmrRunStatus.Enabled := True;
  tmrSetup.Enabled := True;
  FSetupSeqNo := 1;

end;

function TfrmMain.GetAngle(X1, Y1, X2, Y2: Double): Double;
var
  DX, DY: Double;
begin
  DX := (X2 - X1);
  DY := (Y2 - Y1);

  // if dx = 0 then Result := 0
  // else Result := ArcTan2(dy, dx) * (180/PI);
  Result := ArcTan2(DY, DX) * (180 / PI);
end;

procedure TfrmMain.GetAnglePos(X1, Y1, CX, CY, DA: Double; var DX, DY: Double);
var
  cos_th, sin_th: Double;
  X, Y: Double;
begin
  cos_th := cos(DA * (PI / 180));
  sin_th := sin(DA * (PI / 180));

  X := X1 - CX;
  Y := Y1 - CY;
  DX := ((cos_th * (X)) - (sin_th * (Y)));
  DY := ((sin_th * (X)) + (cos_th * (Y)));
  DX := DX + CX;
  DY := DY + CY;
end;

procedure TfrmMain.LoadSetting;
begin
  Data.LoadSetting;
  InitializeSpectrometers;
end;

procedure TfrmMain.SaveSetting;
begin
  Data.SaveSetting;
end;

procedure TfrmMain.SetupChart;
var
  I: Integer;
  D: TData;
begin
  D := CurrentSpectrometer;
  Clear(chtTotalScan);
  CreateSeries(chtTotalScan, 'Total Scan', clLime);
  chtTotalScan.Title.Text.Text := 'Total Scan';

  Clear(chtPeakScan);
  CreateSeries(chtPeakScan, 'Range', clRed);
  if D.MeasMethod = 0 then
  begin
    chtPeakScan.Title.Text.Text := 'Peak Scan';
    panIntensityName.Caption := 'Peak Intensity';
    chtPeakScan.LeftAxis.Title.Caption := 'Peak Intensity';
  end
  else
  begin
    chtPeakScan.Title.Text.Text := 'Area Scan';
    panIntensityName.Caption := 'Area Intensity';
    chtPeakScan.LeftAxis.Title.Caption := 'Area Intensity';
  end;
  for I := 0 to D.FPeakListCount - 1 do
  begin
    if D.FPeakList[I].bUse then
    begin
      CreateSeries(chtPeakScan, D.FPeakList[I].szName, D.FPeakList[I].nColor);
    end;
  end;

end;

procedure TfrmMain.tmrContMeasureTimer(Sender: TObject);
var
  I: Integer;
  D: TData;
begin
  for I := 0 to SpectrometerCount - 1 do
  begin
    D := Spectrometers[I];
    D.RecoverTimedOutRequest(Cardinal(Max(2000, D.ReadTime * 5)));
    if D.FStartMeas then
      Continue;
    case D.SpectrometerKind of
      SPECTROMETER_KIND_OLD, SPECTROMETER_KIND_NEW:
        begin
          D.ReadSingleFrame;
        end;

      SPECTROMETER_KIND_QMINI:
        begin
          if D.SendToRgbServer(MSG_START_EXPOSURE, '') then
          begin
            D.SendToRgbServer(MSG_WAIT_EXPOSURE_DONE, '1');

            D.SendToRgbServer(MSG_GET_WAVELENGTHS, '');
            D.SendToRgbServer(MSG_GET_INTENSITIES, '');
          end;
        end;
    end;
  end;
end;

procedure TfrmMain.tmrRunStatusTimer(Sender: TObject);
begin
  case FRunState of
    rsNone :
    begin

    end;
    rsRun :
    begin
      FRunState := rsRunOk;
    end;
    rsRunOk :
    begin
      DATA.WriteTowerLampGreen;
      ledResultFault.LED.OnColor := clLime;
      FRunState := rsNone;
    end;

    rsStop :
    begin
      FRunState := rsStopOk;
    end;
    rsStopOk :
    begin
      DATA.WriteTowerLampYellow;
      ledResultFault.LED.OnColor := clYellow;
      FRunState := rsNone;
    end;

    rsError :
    begin
      FRunCount := FRunCount + 1;
      if FRunCount > 5 then
      begin
        FRunFlashOn := not FRunFlashOn;
        FRunState := rsErrorOk;
      end;
    end;
    rsErrorOk :
    begin
      if FRunFlashOn then
      begin
        DATA.WriteTowerLampRed;
        ledResultFault.LED.OnColor := clRed;
      end
      else
      begin
        DATA.WriteTowerLampYellow;
        ledResultFault.LED.OnColor := clYellow;
      end;

      FRunCount := 0;
      FRunState := rsError;
    end;
  end;
end;

procedure TfrmMain.tmrSetupTimer(Sender: TObject);
begin
  case Data.SpectrometerKind of
    SPECTROMETER_KIND_OLD, SPECTROMETER_KIND_NEW:
      begin
        case FSetupSeqNo of
          1:
            begin
              Data.SetManualExposureMode;
              Inc(FSetupSeqNo);
            end;
          2:
            begin
              if not Data.FStartMeas then
              begin
                Data.SetExposure(Data.Exposure);
                Inc(FSetupSeqNo);
              end;
            end;
          3:
            begin
              if not Data.FStartMeas then
              begin
                actStart.Execute;
                FSetupSeqNo := 0;
              end;
            end;

        end;
      end;
    SPECTROMETER_KIND_QMINI:
      begin
        case FSetupSeqNo of
          1:
            begin
              Data.SetExposure(Data.Exposure);

              actStart.Execute;
              FSetupSeqNo := 0;
            end;
        end;
      end;
  end;
end;

procedure TfrmMain.UMUpdateGraphChanged(var AMessage: TMessage);
var
  D: TData;
begin
  D := GetSpectrometer(AMessage.WParam);
  EvaluateAlarm(D);
  if AMessage.WParam = SelectedSpectrometer then
    FillSeries;
end;

procedure TfrmMain.RefreshSpectrometerList;
var
  I: Integer;
begin
  cbSpectrometer.Items.BeginUpdate;
  try
    cbSpectrometer.Items.Clear;
    for I := 0 to SpectrometerCount - 1 do
      cbSpectrometer.Items.Add(Format('%d. %s',
        [I + 1, Spectrometers[I].DeviceName]));
    cbSpectrometer.ItemIndex := SelectedSpectrometer;
  finally
    cbSpectrometer.Items.EndUpdate;
  end;
end;

procedure TfrmMain.ReloadSpectrometers;
var
  I: Integer;
begin
  RefreshSpectrometerList;

  // Release every old COM-port assignment first.  Reopening one device while
  // another device still owns its old port makes port swaps fail depending on
  // device order (typically SPEC 1 fails and SPEC 2 succeeds).
  for I := 0 to SpectrometerCount - 1 do
    Spectrometers[I].CloseComm;

  for I := 0 to SpectrometerCount - 1 do
    OpenSpectrometer(Spectrometers[I]);

  tmrContMeasure.Interval := CurrentSpectrometer.ReadTime;
  SetupChart;
  FillSeries;
end;

procedure TfrmMain.SpectrometerChange(Sender: TObject);
begin
  if cbSpectrometer.ItemIndex < 0 then Exit;
  SelectedSpectrometer := cbSpectrometer.ItemIndex;
  SetupChart;
  FillSeries;
end;

procedure TfrmMain.OpenSpectrometer(AData: TData);
const
  OPEN_RETRY_COUNT = 5;
var
  Attempt: Integer;
  Opened: Boolean;
begin
  case AData.SpectrometerKind of
    SPECTROMETER_KIND_OLD:
      AData.FCOMM.BaudRate := _921600;
    SPECTROMETER_KIND_NEW:
      AData.FCOMM.BaudRate := _256000;
  end;
  if AData.SpectrometerKind in [SPECTROMETER_KIND_OLD, SPECTROMETER_KIND_NEW] then
  begin
    AData.FCOMM.Port := TfocPort(AData.ComPortNo);
    for Attempt := 1 to OPEN_RETRY_COUNT do
    begin
      Opened := AData.OpenComm;
      if Opened then
        Break;
      if Attempt < OPEN_RETRY_COUNT then
        Sleep(200);
    end;

    if Opened then
      AData.ApplyCommunicationSettings
    else
      if LogLevel >= 1 then
        CodeSite.SendFmtMsg('[SPEC %d][%s] OpenComm failed [COM%d, Attempts=%d]',
          [AData.DeviceIndex + 1, AData.DeviceName, AData.ComPortNo + 1,
           OPEN_RETRY_COUNT]);
  end;
end;

procedure TfrmMain.EvaluateAlarm(AData: TData);
var
  I, AlarmTime: Integer;
  AlarmItem: TAlarmItem;
begin
  if not AData.FFaultMeasString then
  begin
    if not AData.FPekaResult then
    begin
      AData.FFaultTimeer.Start;
      AData.FFaultMeasString := True;
    end;
    Exit;
  end;

  if AData.FPekaResult then
  begin
    AData.FFaultTimeer.Stop;
    AData.FFaultMeasString := False;
    if (AData.AlarmMode = 1) and AData.AlarmActive then
    begin
      AData.AlarmActive := False;
      AData.WriteIFComm(False);
      FRunError := AnyAlarmActive;
      if not FRunError then
      begin
        FRunCount := 0;
        if tmrContMeasure.Enabled then
          FRunState := rsRun
        else
          FRunState := rsStop;
      end;
    end;
    Exit;
  end;

  if AData.AlarmActive then Exit;
  AlarmTime := Trunc(AData.FFaultTimeer.ElapsedTime * 1000);
  if AlarmTime <= AData.AlarmTimeSet then Exit;

  AData.AlarmActive := True;
  FRunError := True;
  FRunState := rsError;
  if Data.IFCommKind = 0 then
    AData.WriteIFComm(True);

  for I := 0 to AData.FPeakListCount - 1 do
    if not AData.FPeakList[I].bResult then
    begin
      AlarmItem.szName := Format('%s - %s',
        [AData.DeviceName, AData.FPeakList[I].szName]);
      AlarmItem.szTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
      AlarmItem.dIntensity := AData.FPeakList[I].dIntensity;
      AData.AddAlarmList(AlarmItem);
    end;
end;

function TfrmMain.AnyAlarmActive: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to SpectrometerCount - 1 do
    if Assigned(Spectrometers[I]) and Spectrometers[I].AlarmActive then
      Exit(True);
end;

procedure TfrmMain.WMCopyData(var Msg: TWMCopyData);
var
  S: AnsiString;
  TmpList: TStrings;
  I: Integer;
begin
  S := PAnsiChar(Msg.CopyDataStruct.lpData);
  case Msg.CopyDataStruct.dwData of
    MSG_INITIALIZE:
      begin
      end;
    MSG_FINALIZE:
      begin
      end;
    MSG_SET_EXPOSURE:
      begin
      end;
    MSG_GET_EXPOSURE:
      begin
      end;
    MSG_GET_PIXEL_COUNT:
      begin
        Data.FDataCount := StrToIntDef(S, 0);
      end;
    MSG_GET_WAVELENGTHS:
      begin
        TmpList := TStringList.Create;
        try
          foSplitWord(S, [','], TmpList);
          if Data.FDataCount = TmpList.Count then
          begin
            for I := 0 to TmpList.Count - 1 do
            begin
              Data.FWAVE[I] := StrToFloatDef(TmpList[I], 0);
            end;
          end;

        finally
          TmpList.Free;
        end;

      end;
    MSG_GET_INTENSITIES:
      begin
        TmpList := TStringList.Create;
        try
          foSplitWord(S, [','], TmpList);

          if Data.FDataCount = TmpList.Count then
          begin
            for I := 0 to TmpList.Count - 1 do
            begin
              Data.FDATA[I] := StrToFloatDef(TmpList[I], 0);
            end;
          end;
          Data.MeasPeak;
          Data.BroadcastMessage(UM_UPDATE_GRAPH_CHANGED, 0, 0);

        finally
          TmpList.Free;
        end;

      end;
    MSG_START_EXPOSURE:
      begin
      end;
    MSG_WAIT_EXPOSURE_DONE:
      begin
      end;
  end;
end;

procedure TfrmMain.LoadSkin(const ASkinFileName: string);
begin
  if (ASkinFileName <> '') and FileExists(ASkinFileName) then
  begin
    SkinController.SkinName := 'UserSkin';
    dxSkinsUserSkinLoadFromFile(ASkinFileName);

    ApplySkinColors(SkinController.SkinName);
  end;
end;

procedure TfrmMain.panClientResize(Sender: TObject);
begin
  panTotalScan.Height := panClient.Height div 2;
  panPeakScan.Height := panClient.Height div 2;
end;

procedure TfrmMain.ApplySkinColors(const ASkinName: string);
var
  I : Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
  begin
    ApplySkinColor(SkinController.SkinName, Screen.Forms[I]);
  end;
end;

end.

