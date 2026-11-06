unit fJobEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ActnList,
  ImgList,
  Mask,
  StdCtrls,
  ExtCtrls,
  Menus,
  Actions,
  IOUtils,

  cxControls,
  cxContainer,
  cxEdit,
  cxGroupBox,
  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,
  dxSkinscxPCPainter,
  cxPCdxBarPopupMenu,
  cxPC,
  dxBarBuiltInMenu,
  cxListBox,
  dximctrl,

  elExplorerBar,
  elMultiLanguage,
  elWinUtils,

  voControls,
  voVision,
  voImageViewer,

  foUserManager,
  foControls,
  foChannelSpy,
  foEdit,
  foButtonEdit,
  foDataServer,
  foLED,
  foEditCtrls,
  foWinUtils,

  ZipForge,

  fTouchKBD,
  fNumericKBD,
  fMessageDlg,
  dmHAL,
  uJob,
  uAligner,
  uEquipment,
  uCommonUtils, System.ImageList, cxImageList, cxCustomListBox, foIndicator;

type
  TfrmJobEdit = class(TForm)
    ilJobEdit: TcxImageList;
    alJobEdit: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    actClose: TAction;
    SaveDlg: TSaveDialog;
    panTop: TPanel;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    cxButton4: TcxButton;
    actOpen: TAction;
    OpenDlg: TOpenDialog;
    ilSetup: TcxImageList;
    btnClose: TcxButton;
    actEditKeyModelInfo: TAction;
    ExplorerBar: TelExplorerBar;
    ebgJobList: TelebGroup;
    ebgJobProperties: TelebGroup;
    lbJobList: TcxListBox;
    PageControl: TcxPageControl;
    tsBasic: TcxTabSheet;
    ebBasic: TelExplorerBar;
    ebgGeneral: TelebGroup;
    actEditChipModelInfo: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure ValueButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure GetTextValueButtonClick(Sender: TObject);
    procedure SelectFolderButtonClick(Sender: TObject);
  private
    function GetSelectedJob: string;
    procedure SetSelectedJob(const Value: string);

    procedure UMUserLogIn(var Message: TMessage);
    procedure UpdateActionEnabled;
    { Private declarations }
  public
    { Public declarations }
    procedure LoadFromFile(const AFileName : string);
    procedure LoadJob(const AJobName : string);
    procedure UpdateStatus;

    procedure ReloadJobList(const ALastJob : string);
    property SelectedJob : string read GetSelectedJob write SetSelectedJob;
  end;

procedure EditJob(const AJobName : string);

implementation

uses fMain;

procedure EditJob(const AJobName : string);
var
  F : TfrmJobEdit;
begin
  F := TfrmJobEdit.Create(Application);
  try
    F.LoadJob(AJobName);
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;


{$R *.dfm}

procedure TfrmJobEdit.UMUserLogIn(var Message: TMessage);
begin
  UpdateActionEnabled;
end;

procedure TfrmJobEdit.UpdateActionEnabled;
begin
  actOpen.Enabled := True;
  actSave.Enabled := (TfoUserAuthority(Equipment.ActiveUserLevel) <> uaOperator);
  actSaveAs.Enabled := (TfoUserAuthority(Equipment.ActiveUserLevel) <> uaOperator);
end;

procedure TfrmJobEdit.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmJobEdit.actOpenExecute(Sender: TObject);
begin
  if Confirm(ELS('Do you Really want to Open the Selected Job?'), Application.Title) = IDOK then
  begin
    frmMain.LoadJob(SelectedJob);
    frmMain.txtJob.Text := Job.JobName;
    //LoadJob(SelectedJob);
  end;
end;

procedure TfrmJobEdit.actSaveAsExecute(Sender: TObject);
var
  szOldJob : string;
begin
  SaveDlg.FileName := Job.FileName;
  if SaveDlg.Execute then
  begin
    szOldJob := Job.JobName;

    Job.SaveToFile(SaveDlg.FileName);
    Caption := Format(elLocalizedString('Edit Job - %s'), [SaveDlg.FileName]);

    ReloadJobList(szOldJob);
  end;
end;

procedure TfrmJobEdit.actSaveExecute(Sender: TObject);
begin
  if FileExists(Job.FileName) then
    Job.Save
  else
    actSaveAs.Execute;
end;

procedure TfrmJobEdit.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  elApplyLanguage(Self);

  OpenDlg.Filter := Format('Job Files (%s)|%s', [Equipment.JobFileFilter, Equipment.JobFileFilter]);
  SaveDlg.Filter := OpenDlg.Filter;

  lbJobList.Style.Font.Size := 12;
end;

procedure TfrmJobEdit.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmJobEdit.FormShow(Sender: TObject);
begin
  ReloadJobList(SelectedJob);
  UpdateStatus;
end;

function TfrmJobEdit.GetSelectedJob: string;
begin
  if lbJobList.ItemIndex <> -1 then
  begin
    Result := lbJobList.Items[lbJobList.ItemIndex];
  end
  else
  begin
    if lbJobList.Count > 0 then
      Result := lbJobList.Items[0]
    else
      Result := 'DEFAULT';
  end;
end;

procedure TfrmJobEdit.GetTextValueButtonClick(Sender: TObject);
begin
  TfoLabeledButtonEdit(Sender).Text := GetTextFromTouchKBD(TfoLabeledButtonEdit(Sender).Text);
end;

procedure TfrmJobEdit.LoadFromFile(const AFileName: string);
begin
  if Job.LoadFromFile(AFileName) then
  begin
    Job.JobServer.UpdateLinks;

    Caption := Format(elLocalizedString('Edit Job - %s'), [AFileName]);

    UpdateStatus;
  end;
end;

procedure TfrmJobEdit.LoadJob(const AJobName: string);
begin
  LoadFromFile(Equipment.GetJobFile(AJobName));
  SelectedJob := AJobName;
end;

procedure TfrmJobEdit.ReloadJobList(const ALastJob : string);
begin
  Equipment.UpdateJobFileList(lbJobList.Items);
  SelectedJob := ALastJob;
end;

procedure TfrmJobEdit.SelectFolderButtonClick(Sender: TObject);
var
  szFolder : string;
begin
  if foSelectFolder(Self.Handle, ELS('Select Folder'), TfoLabeledButtonEdit(Sender).Text, '', True, szFolder) then
    TfoLabeledButtonEdit(Sender).Text := szFolder;
end;

procedure TfrmJobEdit.SetSelectedJob(const Value: string);
begin
  if (Value <> '') then
  begin
    if lbJobList.Items.Count = 0 then
      Equipment.UpdateJobFileList(lbJobList.Items);

    lbJobList.ItemIndex := lbJobList.Items.IndexOf(Value);
    if lbJobList.ItemIndex = -1 then
      lbJobList.ItemIndex := 0;
  end
  else
  begin
    lbJobList.ItemIndex := 0;
  end;
end;

procedure TfrmJobEdit.UpdateStatus;
begin
end;

procedure TfrmJobEdit.ValueButtonClick(Sender: TObject);
begin
  TfoLabeledButtonNumberEdit(Sender).Value := GetValueFromTouchKBD(
    TfoLabeledButtonNumberEdit(Sender).Value,
    TfoLabeledButtonNumberEdit(Sender).Min,
    TfoLabeledButtonNumberEdit(Sender).Max
  );
end;

end.
