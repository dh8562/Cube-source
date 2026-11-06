unit fTaskStepTraceInfoViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  Menus,
  ActnList,
  Actions,
  ImgList,

  cxContainer,
  cxEdit,
  cxTextEdit,
  cxMemo,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxSkinscxPCPainter,
  dxBarBuiltInMenu,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxPC,
  dxSkinsdxBarPainter,
  dxBar,
  cxClasses,

  elBase,
  elPropSaver,

  foProcess,

  dmMachine,
  uEquipment,
  uCommonUtils, System.ImageList, cxImageList;

type
  TfrmTaskStepTraceViewer = class(TForm)
    FontDlg: TFontDialog;
    PropSaver: TelPropSaver;
    pcReports: TcxPageControl;
    pmMemo: TPopupMenu;
    tbiFont: TMenuItem;
    ActionList: TActionList;
    actFont: TAction;
    BarManager: TdxBarManager;
    ImageList: TcxImageList;
    BarManagerBar: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    actRefresh: TAction;
    actClose: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure actFontExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RetrieveTraceInfos;
  end;

procedure ViewTaskStepInfos;

implementation

{$R *.dfm}

procedure ViewTaskStepInfos;
var
  F : TfrmTaskStepTraceViewer;
begin
  F := TfrmTaskStepTraceViewer.Create(nil);
  try
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmTaskStepTraceViewer.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  PropSaver.INIFileName := Equipment.INIFileName;
  PropSaver.LoadProperty;
end;

procedure TfrmTaskStepTraceViewer.FormShow(Sender: TObject);
begin
  RetrieveTraceInfos;
end;

procedure TfrmTaskStepTraceViewer.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmTaskStepTraceViewer.actFontExecute(Sender: TObject);
var
  I : Integer;
begin
  if FontDlg.Execute then
  begin
    for I := 0 to Pred(ComponentCount) do
    begin
      if Components[I] is TMemo then
      begin
        TMemo(Components[I]).Font := FontDlg.Font;
      end;
    end;
  end;
end;

procedure TfrmTaskStepTraceViewer.actRefreshExecute(Sender: TObject);
var
  I : Integer;
  TS : TcxTabSheet;
  Memo : TcxMemo;
  Task : TfoTask;
begin
  for I := 0 to pcReports.PageCount - 1 do
  begin
    TS := pcReports.Pages[I];
    Memo := TcxMemo(TS.Tag);
    Task := TfoTask(Memo.Tag);

    TS.Caption := Task.Name;
    TS.Hint := TS.Caption;
    Memo.Lines.Assign(Task.StepTraceInfos);
    Memo.InnerControl.Perform(EM_LINESCROLL, 0,  Memo.Lines.Count);
  end;
end;

procedure TfrmTaskStepTraceViewer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
;
end;

procedure TfrmTaskStepTraceViewer.FormDestroy(Sender: TObject);
begin
  PropSaver.SaveProperty;
end;

procedure TfrmTaskStepTraceViewer.RetrieveTraceInfos;
var
  I : Integer;
  TS : TcxTabSheet;
  Memo : TcxMemo;
begin
  for I := 0 to Machine.ComponentCount - 1 do
  begin
    if Machine.Components[I] is TfoTask then
    begin
      TS := TcxTabSheet.Create(Self);
      TS.Caption := TfoTask(Machine.Components[I]).Name;
      TS.Hint := TS.Caption;
      TS.PageControl := pcReports;
      Memo := TcxMemo.Create(Self);
      Memo.Parent := TS;
      Memo.Align := alClient;
      Memo.Style.Font := FontDlg.Font;
      Memo.PopupMenu := pmMemo;
      Memo.Properties.ScrollBars := ssBoth;
      Memo.Lines.Assign(TfoTask(Machine.Components[I]).StepTraceInfos);
      Memo.InnerControl.Perform(EM_LINESCROLL, 0,  Memo.Lines.Count);

      TS.Tag := Integer(Memo);
      Memo.Tag := Integer(TfoTask(Machine.Components[I]));
    end;
  end;

  if pcReports.PageCount > 0 then
    pcReports.ActivePage := pcReports.Pages[0];
end;

end.
