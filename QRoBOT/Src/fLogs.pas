unit fLogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils,
  System.SyncObjs, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics,
  Vcl.StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxTextEdit,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, OtlComm, OtlContainers, uLogger;

const
  MAX_LOG_QUEUE_ITEMS = 3000;
  MAX_LOG_LIST_ITEMS = 2000;
  UM_LOG_ITEM_QUEUED = WM_USER + 1453;

type
  TfrmLogs = class(TForm)
    lblTitle: TLabel;
    lblFileCaption: TLabel;
    lblFileName: TLabel;
    tlLogs: TcxTreeList;
    colDateTime: TcxTreeListColumn;
    colSource: TcxTreeListColumn;
    colMessage: TcxTreeListColumn;
    btnClear: TButton;
    chkShowDateTime: TCheckBox;
    tmrUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure chkShowDateTimeClick(Sender: TObject);
    procedure tmrUpdateTimer(Sender: TObject);
  private
    FLogQueue: TOmniMessageQueue;
    FCS: TCriticalSection;
    function LogFileName: string;
    procedure AddNode(const ADateTime, ASource, AMessage: string);
    procedure DequeueLogs;
    procedure HandleLoggerLog(const ASource, AMessage: string);
    procedure LoadLogs;
    procedure UMLogItemQueued(var AMessage: TMessage); message UM_LOG_ITEM_QUEUED;
  public
    procedure AddLog(const ASource, AMessage: string);
    procedure Clear;
  end;

var
  frmLogs: TfrmLogs;

implementation

{$R *.dfm}

procedure TfrmLogs.AddLog(const ASource, AMessage: string);
begin
  QVIXLog(ASource, AMessage);
end;

procedure TfrmLogs.HandleLoggerLog(const ASource, AMessage: string);
var
  LogMsg: TOmniMessage;
begin
  if csDestroying in ComponentState then
    Exit;
  LogMsg.MsgID := 0;
  LogMsg.MsgData.AsString := ASource + #9 +
    StringReplace(AMessage, #9, ' ', [rfReplaceAll]);
  if FLogQueue.Enqueue(LogMsg) then
  begin
    tmrUpdate.Enabled := True;
    PostMessage(Handle, UM_LOG_ITEM_QUEUED, 0, 0);
  end;
end;

procedure TfrmLogs.AddNode(const ADateTime, ASource, AMessage: string);
var
  Node: TcxTreeListNode;
begin
  Node := tlLogs.AddChild(nil);
  Node.Values[0] := ADateTime;
  Node.Values[1] := ASource;
  Node.Values[2] := AMessage;
  while tlLogs.Count > MAX_LOG_LIST_ITEMS do
    tlLogs.Root.GetFirstChild.Delete;
  Node.MakeVisible;
end;

procedure TfrmLogs.btnClearClick(Sender: TObject);
begin
  Clear;
  QVIXLog('System', 'Integrated log cleared');
end;

procedure TfrmLogs.chkShowDateTimeClick(Sender: TObject);
begin
  colDateTime.Visible := chkShowDateTime.Checked;
end;

procedure TfrmLogs.Clear;
begin
  FCS.Enter;
  try
    FLogQueue.Empty;
    tlLogs.Clear;
    ClearQVIXLog;
  finally
    FCS.Leave;
  end;
end;

procedure TfrmLogs.DequeueLogs;
var
  DateTimeText, MessageText, SourceText: string;
  LogMsg: TOmniMessage;
  P: Integer;
begin
  while not FLogQueue.IsEmpty do
  begin
    if not FLogQueue.TryDequeue(LogMsg) then
      Break;
    MessageText := LogMsg.MsgData.AsString;
    P := Pos(#9, MessageText);
    if P > 0 then
    begin
      SourceText := Copy(MessageText, 1, P - 1);
      Delete(MessageText, 1, P);
    end
    else
      SourceText := 'System';
    DateTimeText := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    AddNode(DateTimeText, SourceText, MessageText);
  end;
  tmrUpdate.Enabled := not FLogQueue.IsEmpty;
end;

procedure TfrmLogs.FormCreate(Sender: TObject);
begin
  FLogQueue := TOmniMessageQueue.Create(MAX_LOG_QUEUE_ITEMS);
  FCS := TCriticalSection.Create;
  frmLogs := Self;
  SetQVIXLogHandler(HandleLoggerLog);
  lblFileName.Caption := LogFileName;
  LoadLogs;
  QVIXLog('System', 'Integrated log screen initialized');
end;

procedure TfrmLogs.FormDestroy(Sender: TObject);
begin
  tmrUpdate.Enabled := False;
  DequeueLogs;
  SetQVIXLogHandler(nil);
  if frmLogs = Self then
    frmLogs := nil;
  FCS.Free;
  FLogQueue.Free;
end;

function TfrmLogs.LogFileName: string;
begin
  Result := QVIXLogFileName;
end;

procedure TfrmLogs.LoadLogs;
var
  I, P1, P2: Integer;
  Line: string;
begin
  with TStringList.Create do
  try
    if FileExists(LogFileName) then
      try
        LoadFromFile(LogFileName);
      except
        Clear;
      end;
    while Count > MAX_LOG_LIST_ITEMS do
      Delete(0);
  tlLogs.BeginUpdate;
  try
    for I := 0 to Count - 1 do
    begin
      Line := Strings[I];
      P1 := Pos(#9, Line);
      P2 := Pos(#9, Copy(Line, P1 + 1, MaxInt));
      if (P1 = 0) or (P2 = 0) then
        Continue;
      P2 := P1 + P2;
      AddNode(Copy(Line, 1, P1 - 1),
        Copy(Line, P1 + 1, P2 - P1 - 1),
        Copy(Line, P2 + 1, MaxInt));
    end;
  finally
    tlLogs.EndUpdate;
  end;
  finally
    Free;
  end;
end;

procedure TfrmLogs.tmrUpdateTimer(Sender: TObject);
begin
  DequeueLogs;
end;

procedure TfrmLogs.UMLogItemQueued(var AMessage: TMessage);
begin
  DequeueLogs;
end;

end.
