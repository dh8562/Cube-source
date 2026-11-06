unit fLog;

{$I foCompilerDefines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Menus,
  ImgList,
  ActnList,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  SyncObjs,
  GraphUtil,
  ImageList,
  Actions,

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
  dxSkinOffice2013LightGray,
	cxImageList,
  cxDataControllerConditionalFormattingRulesManagerDialog,

  OtlCommon,
  OtlContainers,
  OtlComm,

  elBase,
  elPropSaver,
  elMultiLanguage,

  foTypes,

  uEquipment, dxSkinVisualStudio2013Light, dxSkinOffice2010Silver,
  dxScrollbarAnnotations;


const
  MAX_LOG_QUEUE_ITEMS = 3000;
  MAX_LOG_LIST_ITEMS = 2000;

  UM_LOG_ITEM_QUEUED = WM_USER + 1453;

type
  TLogEvent = procedure (Sender : TObject; const ALogType : TfoLogType; const AMsg : string) of object;

  TfrmLog = class(TForm)
    alLog: TActionList;
    actClear: TAction;
    ilLog: TcxImageList;
    pmLog: TPopupMenu;
    Clear1: TMenuItem;
    tlLog: TcxTreeList;
    tlcMessage: TcxTreeListColumn;
    tlcDateTime: TcxTreeListColumn;
    actSave: TAction;
    ilMenus: TcxImageList;
    actShowDateTime: TAction;
    N1: TMenuItem;
    ShowDateTime1: TMenuItem;
    PropSaver: TelPropSaver;
    tmrUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actShowDateTimeExecute(Sender: TObject);
    procedure tlLogCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure tmrUpdateTimer(Sender: TObject);
  private
    { Private declarations }
    MethodNode : TcxTreeListNode;
		FLogQueue : TOmniMessageQueue;
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

    procedure DoDequeueMessages;
    procedure DequeueMessages;
    procedure StartDequeue;
    procedure StopDequeue;

    procedure UMLogItemQueued(var AMessage : TMessage); message UM_LOG_ITEM_QUEUED;
  end;


var
  frmLog: TfrmLog;

procedure LogAdd(ALogType : TfoLogType; const ALogMessage : string); overload;
procedure LogAdd(const ALogMessage : string); overload;
procedure LogEnterMethod(const AMethodName : string);
procedure LogExitMethod(const AMethodName : string);

implementation

{$R *.dfm}

procedure LogAdd(ALogType : TfoLogType; const ALogMessage : string); overload;
begin
  if frmLog <> nil then
  begin
    if not (csDestroying in frmLog.ComponentState) and
       not (csDestroyingHandle in frmLog.ControlState) then
      frmLog.Add(ALogType, ALogMessage);
  end;
end;

procedure LogAdd(const ALogMessage : string); overload;
begin
  LogAdd(ltMessage, ALogMessage);
end;

procedure LogEnterMethod(const AMethodName : string);
begin
  if frmLog <> nil then
    frmLog.EnterMethod(AMethodName);
end;

procedure LogExitMethod(const AMethodName : string);
begin
  if frmLog <> nil then
    frmLog.ExitMethod(AMethodName);
end;


procedure TfrmLog.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  elApplyLanguage(Self);

	FLogQueue := TOmniMessageQueue.Create(MAX_LOG_QUEUE_ITEMS);
  FCS := TCriticalSection.Create;

  MethodNode := nil;

  PropSaver.INIFileName := Equipment.IniFileName;
  PropSaver.LoadProperty;

  tlcDateTime.Visible := actShowDateTime.Checked;
end;

procedure TfrmLog.FormShow(Sender: TObject);
begin
;
end;

procedure TfrmLog.StartDequeue;
begin
  tmrUpdate.OnTimer := tmrUpdateTimer;
  tmrUpdate.Enabled := True;
end;

procedure TfrmLog.StopDequeue;
begin
  tmrUpdate.OnTimer := nil;
  tmrUpdate.Enabled := False;
end;

procedure TfrmLog.UMLogItemQueued(var AMessage: TMessage);
begin
  DequeueMessages;
end;

procedure TfrmLog.tlLogCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  if AViewInfo.Node.ImageIndex = -1 then
  begin
    DrawSeparator(ACanvas.Canvas, AViewInfo.BoundsRect);
    ADone := True;
  end;
end;

procedure TfrmLog.tmrUpdateTimer(Sender: TObject);
begin
  DequeueMessages;
end;

procedure TfrmLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopDequeue;
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  StopDequeue;

  FCS.Free;
  FLogQueue.Free;

  PropSaver.SaveProperty;
end;

procedure TfrmLog.Add(ALogType: TfoLogType; const ALogMessage: string);
var
  LogMsg : TOmniMessage;
begin
  LogMsg.MsgID := Ord(ALogType);
  LogMsg.MsgData.AsString := ALogMessage;

  if FLogQueue.Enqueue(LogMsg) then
    StartDequeue;
    PostMessage(Self.Handle, UM_LOG_ITEM_QUEUED, 0, 0);
end;

procedure TfrmLog.actShowDateTimeExecute(Sender: TObject);
begin
  actShowDateTime.Checked := not actShowDateTime.Checked;
  tlcDateTime.Visible := actShowDateTime.Checked;
end;

procedure TfrmLog.Add(const ALogMessage: string);
begin
  Add(ltMessage, ALogMessage);
end;

procedure TfrmLog.Clear;
begin
  FCS.Enter;
  try
    FLogQueue.Empty;

    MethodNode := nil;
    tlLog.Clear;
  finally
    FCS.Leave;
  end;
end;

procedure TfrmLog.DoDequeueMessages;
var
  Node : TcxTreeListNode;
	LogMsg : TOmniMessage;
begin
  Node := nil;

  while not FLogQueue.IsEmpty do
  begin
    if FLogQueue.TryDequeue(LogMsg) then
    begin
      if tlLog.Count > MAX_LOG_LIST_ITEMS then
      begin
        Node := tlLog.Root.getFirstChild;

        if Node <> nil then
        begin
          Node.Delete;
          Node := nil;
        end;
      end;

      if TfoLogType(LogMsg.MsgID) = ltEnter then
      begin
        MethodNode := tlLog.AddChild(MethodNode);
        MethodNode.ImageIndex := LogMsg.MsgID;
        MethodNode.StateIndex := MethodNode.ImageIndex;
        MethodNode.SelectedIndex := MethodNode.ImageIndex;
        MethodNode.Values[0] := LogMsg.MsgData.AsString;
        MethodNode.Values[1] := Now;
      end
      else if TfoLogType(LogMsg.MsgID) = ltExit then
      begin
        if MethodNode <> nil then
        begin
          MethodNode.StateIndex := MethodNode.ImageIndex;
          MethodNode.SelectedIndex := MethodNode.ImageIndex;
          MethodNode.Values[0] := LogMsg.MsgData.AsString;
          MethodNode.Values[1] := Now;
          MethodNode := MethodNode.Parent;
        end;
      end
      else if TfoLogType(LogMsg.MsgID) = ltClear then
      begin
        Clear;
      end
      else if TfoLogType(LogMsg.MsgID) = ltSeparator then
      begin
        Node := tlLog.AddChild(MethodNode);
        Node.ImageIndex := -1;
        Node.StateIndex := -1;
        Node.SelectedIndex := -1;
        Node.Values[0] := '';
        Node.Values[1] := Now;
      end
      else
      begin
        Node := tlLog.AddChild(MethodNode);
        Node.ImageIndex := LogMsg.MsgID;
        Node.StateIndex := Node.ImageIndex;
        Node.SelectedIndex := Node.ImageIndex;
        Node.Values[0] := LogMsg.MsgData.AsString;
        Node.Values[1] := Now;
      end;
    end
    else
      Break;
  end;

  if Node <> nil then
    Node.MakeVisible;
end;

procedure TfrmLog.DequeueMessages;
begin
	TThread.Queue(nil, DoDequeueMessages);
end;

procedure TfrmLog.DoLog(Sender: TObject; const ALogType : TfoLogType; const AMsg: string);
begin
  Add(ALogType, AMsg);
end;

procedure TfrmLog.DrawSeparator(ACanvas : TCanvas; const ARect : TRect);
var
  rDraw : TRect;
begin
  ACanvas.Pen.Color := clHighlight;
  ACanvas.Pen.Style := psDot;

  rDraw := ARect;
  InflateRect(rDraw, -4, -4);
  ACanvas.MoveTo(rDraw.Left, (rDraw.Top + rDraw.Bottom) div 2);
  ACanvas.LineTo(rDraw.Right, (rDraw.Top + rDraw.Bottom) div 2);
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
  Add(ltEnter, AMethodName);
end;

procedure TfrmLog.ExitMethod(const AMethodName: string);
begin
  Add(ltExit, AMethodName);
end;

procedure TfrmLog.actClearExecute(Sender: TObject);
begin
  Clear;
end;

end.
