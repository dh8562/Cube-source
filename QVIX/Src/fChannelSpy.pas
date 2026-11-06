unit fChannelSpy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ActnList,
  Menus,
  ImgList,
  Buttons,
  Actions,

  ZipForge,

  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxSkinscxPCPainter,
  cxPCdxBarPopupMenu,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxPC,
  cxContainer,
  cxEdit,
  cxCheckBox,
  cxButtons,
  dxSkinsdxBarPainter,
  dxBar,
  cxClasses,
  dxBarExtItems,
  dxBarBuiltInMenu,

  elExplorerBar,
  elLabel,
  elPanels,
  elBase,
  elPropSaver,

  foControls,
  foDataServer,
  foDataServerUtils,
  foChannelSpy,
  foMotion,
  foAlarmManager,
  foWinUtils,
  foProcess,

  fEmergency,
  fObjectInspector,
  fTaskStepTraceInfoViewer,

  dmData,
  dmHAL,
  dmMachine,
  uCommonUtils,
  uEquipmentConsts,
  uEquipment,
  uRecipe,
  uJob,
  uEquipmentUtils, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, System.ImageList, cxImageList;

type
  TfrmChannelSpy = class(TForm)
    pnlCommand: TPanel;
    ActionList: TActionList;
    pmSystem: TPopupMenu;
    mnuViewCategory: TMenuItem;
    mnuViewName: TMenuItem;
    N2: TMenuItem;
    mnuExpandAll: TMenuItem;
    mnuCollapseAll: TMenuItem;
    pcSpy: TcxPageControl;
    tsSystem: TcxTabSheet;
    spySystem: TfoChannelSpy;
    tsIO: TcxTabSheet;
    spyIO: TfoChannelSpy;
    tsJob: TcxTabSheet;
    spyJob: TfoChannelSpy;
    lblChannelName: TelLabel;
    lblChannelDesc: TelLabel;
    ilSpy: TcxImageList;
    btnClose: TcxButton;
    chkAlwaysOnTop: TcxCheckBox;
    chkHex: TcxCheckBox;
    PropSaver: TelPropSaver;
    txtSearchSystem: TEdit;
    txtSearchIO: TEdit;
    txtSearchJob: TEdit;
    BarManager: TdxBarManager;
    tbChannelSpy: TdxBar;
    bsiTools: TdxBarSubItem;
    bbSaveActuatorConfiguration: TdxBarButton;
    actSaveActuatorConfiguration: TAction;
    actSaveSysInfo: TAction;
    dxBarButton1: TdxBarButton;
    mnuSaveSysInfo: TMenuItem;
    N1: TMenuItem;
    actCheckSystemParameters: TAction;
    dxBarButton2: TdxBarButton;
    OpenDialog: TOpenDialog;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    actLangKor: TAction;
    actLangEnu: TAction;
    actLangChs: TAction;
    tsStatistics: TcxTabSheet;
    spyStatistics: TfoChannelSpy;
    actDumpStatus: TAction;
    dxBarButton9: TdxBarButton;
    seVerboseMode: TdxBarSpinEdit;
    actShowDataCenterValues: TAction;
    dxBarButton3: TdxBarButton;
    actLoadImsFile: TAction;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    actSaveJobInfo: TAction;
    mnuSaveJobInfo: TMenuItem;
    actTraceTaskStep: TAction;
    dxBarButton12: TdxBarButton;
    actShowTaskStepTraceInfo: TAction;
    dxBarButton13: TdxBarButton;
    chtStatistics: TChart;
    serCycleTime: TFastLineSeries;
    btnSaveChannel: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure spySystemChannelModified(Sender: TObject; AChannel: TfoChannel);
    procedure spySystemChannelSelected(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkAlwaysOnTopClick(Sender: TObject);
    procedure mnuViewCategoryClick(Sender: TObject);
    procedure mnuViewNameClick(Sender: TObject);
    procedure mnuExpandAllClick(Sender: TObject);
    procedure mnuCollapseAllClick(Sender: TObject);
    procedure chkHexClick(Sender: TObject);
    procedure txtSearchSystemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtSearchJobKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtSearchIOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actSaveSysInfoExecute(Sender: TObject);
    procedure pmSystemPopup(Sender: TObject);
    procedure actCheckSystemParametersExecute(Sender: TObject);
    procedure actLangKorExecute(Sender: TObject);
    procedure actLangEnuExecute(Sender: TObject);
    procedure actLangChsExecute(Sender: TObject);
    procedure seVerboseModeChange(Sender: TObject);
    procedure actDumpStatusExecute(Sender: TObject);
    procedure actSaveJobInfoExecute(Sender: TObject);
    procedure actTraceTaskStepExecute(Sender: TObject);
    procedure actShowTaskStepTraceInfoExecute(Sender: TObject);
    procedure btnSaveChannelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure UMUpdateCycleTime(var AMessage : TMessage); message UM_UPDATE_CYCLE_TIME;
  public
    { Public declarations }
    procedure DumpCurrentStatus(const AFileName : string);
    procedure UpdateVerboseMode;
  end;

var
  frmChannelSpy: TfrmChannelSpy;

implementation

{$R *.dfm}

procedure TfrmChannelSpy.actCheckSystemParametersExecute(Sender: TObject);
begin
  Equipment.CheckSystemParameters;
end;

procedure TfrmChannelSpy.actDumpStatusExecute(Sender: TObject);
begin
  DumpCurrentStatus(Equipment.LogPath + Format('%s%s.zip', [foExtractFileName(Application.ExeName, True), FormatDateTime('yyyyMMddhhnnss', Now)]));
end;

procedure TfrmChannelSpy.actLangChsExecute(Sender: TObject);
begin
  Equipment.MultiLanguage.ActiveLocaleAbbr := 'CHS';
  AlarmManager.SetActiveLocaleAbbr(Equipment.MultiLanguage.ActiveLocaleAbbr);
end;

procedure TfrmChannelSpy.actLangEnuExecute(Sender: TObject);
begin
  Equipment.MultiLanguage.ActiveLocaleAbbr := 'ENU';
  AlarmManager.SetActiveLocaleAbbr(Equipment.MultiLanguage.ActiveLocaleAbbr);
end;

procedure TfrmChannelSpy.actLangKorExecute(Sender: TObject);
begin
  Equipment.MultiLanguage.ActiveLocaleAbbr := 'KOR';
  AlarmManager.SetActiveLocaleAbbr(Equipment.MultiLanguage.ActiveLocaleAbbr);
end;

procedure TfrmChannelSpy.actSaveJobInfoExecute(Sender: TObject);
begin
  Job.Save;
end;

procedure TfrmChannelSpy.actSaveSysInfoExecute(Sender: TObject);
begin
  Equipment.SysServer.SaveToFile(Equipment.SysInfoFile);
end;

procedure TfrmChannelSpy.actShowTaskStepTraceInfoExecute(Sender: TObject);
begin
  ViewTaskStepInfos;
end;

procedure TfrmChannelSpy.actTraceTaskStepExecute(Sender: TObject);
var
  I : Integer;
begin
  actTraceTaskStep.Checked := not actTraceTaskStep.Checked;

  for I := 0 to Machine.ComponentCount - 1 do
  begin
    if Machine.Components[I] is TfoTask then
    begin
      if actTraceTaskStep.Checked then
        TfoTask(Machine.Components[I]).Options := [toTraceStep]
      else
        TfoTask(Machine.Components[I]).Options := [];
    end;
  end;
end;

procedure TfrmChannelSpy.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChannelSpy.btnSaveChannelClick(Sender: TObject);
var
  szDir : String;
begin
  szDir := foAppPath + 'ErrorReport_' + FormatDateTime('yyyy-mm-dd_hh-nn-ss', now) + '\';
  if not DirectoryExists(szDir) then CreateDir(PChar(szDir));

  HAL.IOServer.SaveToCSVFile(szDir + 'IOServer.csv');
  HAL.JobServer.SaveToCSVFile(szDir + 'JobServer.csv');
  HAL.SysServer.SaveToCSVFile(szDir + 'SysServer.csv');
end;

procedure TfrmChannelSpy.chkAlwaysOnTopClick(Sender: TObject);
begin
  if chkAlwaysOnTop.Checked then
    SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, 0)
  else
    SetWindowPos(Handle, HWND_NOTOPMOST, Left, Top, Width, Height, 0);
end;

procedure TfrmChannelSpy.chkHexClick(Sender: TObject);
begin
  spySystem.HexMode := chkHex.Checked;
  spyIO.HexMode := chkHex.Checked;
  spyJob.HexMode := chkHex.Checked;
end;

procedure TfrmChannelSpy.DumpCurrentStatus(const AFileName: string);
var
  szPath : string;
  Stream : TMemoryStream;
  Zip : TZipForge;
  I, J : Integer;
  StepList : TStrings;
begin
  szPath := ExtractFilePath(AFileName);
  if not DirectoryExists(szPath) then
    ForceDirectories(szPath);

  Stream := TMemoryStream.Create;
  try
    Zip := TZipForge.Create(nil);
    try
      Zip.BaseDir := foAppPath;
      Zip.FileName := AFileName;
      Zip.OpenArchive;
      try
        Stream.Clear;
        HAL.SysServer.SaveToStream(Stream);
        Stream.Seek(0, soFromBeginning);
        Zip.AddFromStream('SYSSERVER.CSV', Stream);

        Stream.Clear;
        HAL.IOServer.SaveToStream(Stream);
        Stream.Seek(0, soFromBeginning);
        Zip.AddFromStream('IO.CSV', Stream);

        Stream.Clear;
        HAL.JobServer.SaveToStream(Stream);
        Stream.Seek(0, soFromBeginning);
        Zip.AddFromStream('JOB.CSV', Stream);

        for I := 0 to Machine.Process.TaskCount - 1 do
        begin
          Stream.Clear;
          Machine.Process.Task[I].StepTraceInfos.SaveToStream(Stream);
          Stream.Seek(0, soFromBeginning);
          Zip.AddFromStream(Format('StepTraceInfo-%s.txt', [Machine.Process.Task[I].Name]), Stream);
        end;
      finally
        Zip.CloseArchive;
      end;
    finally
      FreeAndNil(Zip);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TfrmChannelSpy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmChannelSpy.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  PropSaver.INIFileName := Equipment.INIFileName;
  spyJob.DataServer := Job.JobServer;
end;

procedure TfrmChannelSpy.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmChannelSpy.FormShow(Sender: TObject);
begin
  ApplySkinColor('UserSkin', Self);
end;

procedure TfrmChannelSpy.mnuCollapseAllClick(Sender: TObject);
begin
  if pmSystem.PopupComponent is TfoChannelSpy then
    TfoChannelSpy(pmSystem.PopupComponent).CollapseAll;
end;

procedure TfrmChannelSpy.mnuExpandAllClick(Sender: TObject);
begin
  if pmSystem.PopupComponent is TfoChannelSpy then
    TfoChannelSpy(pmSystem.PopupComponent).ExpandAll;
end;

procedure TfrmChannelSpy.mnuViewCategoryClick(Sender: TObject);
begin
  if pmSystem.PopupComponent is TfoChannelSpy then
    TfoChannelSpy(pmSystem.PopupComponent).ArrangeMode := amByCategory;
end;

procedure TfrmChannelSpy.mnuViewNameClick(Sender: TObject);
begin
  if pmSystem.PopupComponent is TfoChannelSpy then
    TfoChannelSpy(pmSystem.PopupComponent).ArrangeMode := amByName;
end;

procedure TfrmChannelSpy.pmSystemPopup(Sender: TObject);
begin
  mnuSaveSysInfo.Visible :=  (pmSystem.PopupComponent = spySystem);
  mnuSaveJobInfo.Visible :=  (pmSystem.PopupComponent = spyJob);
end;

procedure TfrmChannelSpy.seVerboseModeChange(Sender: TObject);
begin
  UpdateVerboseMode;
end;

procedure TfrmChannelSpy.spySystemChannelModified(Sender: TObject;
  AChannel: TfoChannel);
var
  I : Integer;
begin
  Equipment.BroadcastMessage(UM_SYSINFO_MODIFIED, AChannel.Index, LongInt(AChannel));

  if (Pos('VERBOSE_MODE', AChannel.Name) > 0) then
  begin
    UpdateVerboseMode;
  end;
end;

procedure TfrmChannelSpy.spySystemChannelSelected(Sender: TObject);
begin
  if spySystem.SelectedChannel <> nil then
  begin
    lblChannelName.Caption := spySystem.SelectedChannel.Name;
    lblChannelDesc.Caption := spySystem.SelectedChannel.ZDescription;
  end
  else
  begin
    lblChannelName.Caption := '';
    lblChannelDesc.Caption := '';
  end;
end;

procedure TfrmChannelSpy.txtSearchIOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    spyIO.Filter := txtSearchIO.Text;
  end;
end;

procedure TfrmChannelSpy.txtSearchJobKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    spyJob.Filter := txtSearchJob.Text;
  end;
end;

procedure TfrmChannelSpy.txtSearchSystemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    spySystem.Filter := txtSearchSystem.Text;
  end;
end;

procedure TfrmChannelSpy.UMUpdateCycleTime(var AMessage: TMessage);
begin
  if serCycleTime.ValuesList.Count > 10000 then
    serCycleTime.ValuesList.Delete(0);
  serCycleTime.Add(HAL.IOServer.AsDouble[S_CYCLE_TIME_CURRENT]);
end;

procedure TfrmChannelSpy.UpdateVerboseMode;
begin
  Equipment.VerboseMode := seVerboseMode.IntCurValue;
end;

end.
