unit fLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Menus,
  System.Generics.Collections,
  ImgList,
  Actions,
  ActnList,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  SyncObjs,
  GraphUtil,

  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxCustomData,
  cxStyles,
  cxTL,
  cxTLExportLink,
  cxTextEdit,
  cxTLdxBarBuiltInMenu,
  dxSkinsCore,
  cxInplaceContainer,
  dxSkinOffice2010Silver,

  elBase,
  elPropSaver,
  elMultiLanguage,

  foTypes,
  uLogger,
  uEquipment, cxDataControllerConditionalFormattingRulesManagerDialog,
  System.ImageList, cxImageList;


const
  UM_LOG_ITEM_QUEUED = WM_USER + 1453;

type
  TLogItem = record
    LogType : TfoLogType;
    LogMessage : String;
    LogDate : TDateTime;

    constructor Create(const ALogType : TfoLogType; const AMsg : string; const ADate : TDateTime);
  end;
  PLogItem = ^TLogItem;

  TLogQueue = TThreadedQueue<TLogItem>;

  TLogEvent = procedure (Sender : TObject; const ALogType : TfoLogType; const AMsg : string) of object;

  TfrmLog = class(TForm)
    alLog: TActionList;
    actClear: TAction;
    ilLog: TcxImageList;
    pmLog: TPopupMenu;
    Clear1: TMenuItem;
    actSave: TAction;
    Save1: TMenuItem;
    ilMenus: TcxImageList;
    actShowDateTime: TAction;
    N1: TMenuItem;
    ShowDateTime1: TMenuItem;
    PropSaver: TelPropSaver;
    memoLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actShowDateTimeExecute(Sender: TObject);
    procedure memoLogChange(Sender: TObject);
  private
    { Private declarations }
    MethodNode : TcxTreeListNode;
    FLogQueue : TLogQueue;
    FCS : TCriticalSection;

    procedure DrawSeparator(ACanvas : TCanvas; const ARect : TRect);
  public
    { Public declarations }
    procedure Clear;
    procedure Add(ALogType : TfoLogType; const ALogMessage : string); overload;
    procedure Add(const ALogMessage : string); overload;
    procedure EnterMethod(const AMethodName : string);
    procedure ExitMethod(const AMethodName : string);

    procedure DoLog(Sender : TObject; const ALogType : TfoLogType; const AMsg : string);

    procedure EmbedTo(AParent : TWinControl);
  end;


var
  frmLog: TfrmLog;

implementation

{$R *.dfm}

{ TLogItem }

constructor TLogItem.Create(const ALogType: TfoLogType; const AMsg: string;
  const ADate: TDateTime);
begin
  LogType := ALogType;
  LogMessage := AMsg;
  LogDate := ADate;
end;

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  elApplyLanguage(Self);

  FLogQueue := TLogQueue.Create(1000, 200, 200);
  FCS := TCriticalSection.Create;

  MethodNode := nil;

  PropSaver.INIFileName := Equipment.IniFileName;
  PropSaver.LoadProperty;

  //tlcDateTime.Visible := actShowDateTime.Checked;
end;

procedure TfrmLog.FormShow(Sender: TObject);
begin
;
end;

procedure TfrmLog.memoLogChange(Sender: TObject);
begin
  if memoLog.Lines.Count > 10000 then memoLog.Clear;
end;

procedure TfrmLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  FCS.Free;
  FLogQueue.Free;

  PropSaver.SaveProperty;
end;

procedure TfrmLog.Add(ALogType: TfoLogType; const ALogMessage: string);
begin
  FCS.Enter;
  try
    memoLog.Lines.Add(FormatDateTime('[hh:MM:ss:zzz] ',Now) + ALogMessage);
  finally
    FCS.Leave;
  end;
end;

procedure TfrmLog.actSaveExecute(Sender: TObject);
var
  D : TSaveDialog;
  FileExt : string;
begin
{
  D := TSaveDialog.Create(Self);
  try
    D.DefaultExt := 'txt';
//    D.Filter := SDefaultExportFilter;
    if D.Execute then
    begin
      FileExt := ExtractFileExt(D.FileName);
      if FileExt <> '' then
        Delete(FileExt, 1, 1);
      FileExt := AnsiLowerCase(FileExt);

      if FileExt = 'html' then
        cxExportTLToHTML(D.FileName, tlLog)
      else if FileExt = 'xml' then
        cxExportTLToXML(D.FileName, tlLog)
      else if FileExt = 'xls' then
        cxExportTLToExcel(D.FileName, tlLog)
      else
        cxExportTLToText(D.FileName, tlLog);
    end;
  finally
    FreeAndNil(D);
  end;
}
end;

procedure TfrmLog.actShowDateTimeExecute(Sender: TObject);
begin
//  actShowDateTime.Checked := not actShowDateTime.Checked;
//  tlcDateTime.Visible := actShowDateTime.Checked;
end;

procedure TfrmLog.Add(const ALogMessage: string);
begin
  Add(ltMessage, ALogMessage);
end;

procedure TfrmLog.Clear;
var
  LogItem : TLogItem;
begin
  FCS.Enter;
  try
    memoLog.Lines.Clear;
//    while (FLogQueue.PopItem(LogItem) = wrSignaled) do;
//
//    MethodNode := nil;
//
//    tlLog.Clear;
  finally
    FCS.Leave;
  end;
end;

procedure TfrmLog.DoLog(Sender: TObject; const ALogType : TfoLogType; const AMsg: string);
begin
  Add(ALogType, AMsg);
end;

procedure TfrmLog.DrawSeparator(ACanvas : TCanvas; const ARect : TRect);
var
  rDraw : TRect;
begin
  rDraw := ARect;
  InflateRect(rDraw, -4, -7);
  GradientFillCanvas(ACanvas, clWhite, clHighlight, ARect, gdHorizontal);
end;

procedure TfrmLog.EmbedTo(AParent: TWinControl);
begin
  Self.Parent := AParent;
  Self.BorderStyle := bsNone;
  Self.Align := alClient;
  Self.Visible := True;
end;

procedure TfrmLog.EnterMethod(const AMethodName: string);
begin
//  Add(ltEnter, AMethodName);
end;

procedure TfrmLog.ExitMethod(const AMethodName: string);
begin
//  Add(ltExit, AMethodName);
end;

procedure TfrmLog.actClearExecute(Sender: TObject);
begin
  Clear;
end;

end.
