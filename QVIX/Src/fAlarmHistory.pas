unit fAlarmHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExtCtrls,
  Menus,
  StdCtrls,
  ActnList,
  ImgList,
  Mask,
  AppEvnts,
  Math,
  Actions,

  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxSkinscxPCPainter,
  dxBarBuiltInMenu,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  cxMRUEdit,
  cxButtons,
  cxPC,

  elExplorerBar,
  elMultiLanguage,

  voControls,

  CodeSiteLogging,

  foUserManager,
  foEdit,
  foButton,
  foButtonEdit,
  foControls,
  foChannelSpy,
  foEditCtrls,
  foMotion,
  foIndicator,
  foWinUtils,

  uEquipmentTypes,
  uEquipmentConsts,
  uEquipment,
  fMessageDlg,

  fJog,
  uJob,
  fTouchKBD,
  fNumericKBD,

  dmMachine,
  dmHAL,
  uCommonUtils,

  foAlarmManager,
  cxLabel,
  System.ImageList,
  cxImageList,
  VirtualTrees, Vcl.ComCtrls, foSpinEdit, dxGDIPlusClasses;

type
  TfrmAlarmHistory = class(TForm)
    ilButtonEdit: TcxImageList;
    ilSmall: TcxImageList;
    ilContainer: TcxImageList;
    alJobEdit: TActionList;
    actSave: TAction;
    actSaveAs: TAction;
    SaveDlg: TSaveDialog;
    btnShowAlarmHistory: TcxButton;
    btnAlarmSummary: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnShowAlarmHistoryClick(Sender: TObject);
    procedure btnAlarmSummaryClick(Sender: TObject);
  private
    { Private declarations }
    FAlarmHost: TPanel;
    FEmbedTimer: TTimer;
    FAlarmWindow: HWND;
    FAlarmOriginalParent: HWND;
    FAlarmOriginalStyle: NativeInt;
    FAlarmOriginalExStyle: NativeInt;
    FAlarmOriginalRect: TRect;
    FRestoringForShutdown: Boolean;
    procedure EmbedTimer(Sender: TObject);
    procedure ResizeEmbeddedWindow(Sender: TObject);
    function FindAlarmHistoryWindow: HWND;
    procedure EmbedAlarmHistoryWindow(const AHandle: HWND);
    procedure CloseAlarmHistoryWindow;
    procedure RestoreEmbeddedAlarmHistoryWindow;
    procedure UMUserLogIn(var Message : TMessage); message UM_USER_LOGIN;

    procedure UpdateActionEnabled;
  public
    { Public declarations }
    procedure ShutdownAlarmHistory;
    procedure RestoreAlarmHistoryOnShutdown;
  end;

var
  frmAlarmHistory: TfrmAlarmHistory;

implementation

{$R *.dfm}

uses fMain, fAuto, fChannelSpy;

{$I uSysServer.inc}
{$I uIOServer.inc}
{$I uJobServer.inc}
{$I uStsServer.inc}

procedure TfrmAlarmHistory.UMUserLogIn(var Message: TMessage);
begin
  UpdateActionEnabled;
end;

procedure TfrmAlarmHistory.UpdateActionEnabled;
begin
end;

procedure TfrmAlarmHistory.btnShowAlarmHistoryClick(Sender: TObject);
begin
	AlarmManager.ShowAlarmHistory;
end;

procedure TfrmAlarmHistory.btnAlarmSummaryClick(Sender: TObject);
begin
  AlarmManager.ShowAlarmSummary;
end;

procedure TfrmAlarmHistory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseAlarmHistoryWindow;
end;

procedure TfrmAlarmHistory.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  btnShowAlarmHistory.Visible := False;
  btnAlarmSummary.Visible := False;

  FAlarmHost := TPanel.Create(Self);
  FAlarmHost.Parent := Self;
  FAlarmHost.Align := alClient;
  FAlarmHost.BevelOuter := bvNone;
  FAlarmHost.Color := clWhite;

  FEmbedTimer := TTimer.Create(Self);
  FEmbedTimer.Enabled := False;
  FEmbedTimer.Interval := 100;
  FEmbedTimer.OnTimer := EmbedTimer;
  FAlarmWindow := 0;
  FAlarmOriginalParent := 0;
  FAlarmOriginalStyle := 0;
  FAlarmOriginalExStyle := 0;
  FRestoringForShutdown := False;
  OnResize := ResizeEmbeddedWindow;
  OnHide := FormHide;
end;

procedure TfrmAlarmHistory.CloseAlarmHistoryWindow;
var
  AlarmHandle: HWND;
  MessageResult: DWORD_PTR;
begin
  if Assigned(FEmbedTimer) then
    FEmbedTimer.Enabled := False;
  AlarmHandle := FAlarmWindow;
  if (AlarmHandle = 0) or not IsWindow(AlarmHandle) then
    AlarmHandle := FindAlarmHistoryWindow;
  if (AlarmHandle <> 0) and IsWindow(AlarmHandle) then
  begin
    MessageResult := 0;
    SendMessageTimeout(AlarmHandle, WM_CLOSE, 0, 0,
      SMTO_ABORTIFHUNG or SMTO_BLOCK, 1000, @MessageResult);
  end;
  FAlarmWindow := 0;
end;

procedure TfrmAlarmHistory.ShutdownAlarmHistory;
begin
  CloseAlarmHistoryWindow;
end;

procedure TfrmAlarmHistory.RestoreEmbeddedAlarmHistoryWindow;
var
  W, H: Integer;
begin
  if Assigned(FEmbedTimer) then
    FEmbedTimer.Enabled := False;
  if (FAlarmWindow = 0) or not IsWindow(FAlarmWindow) then Exit;

  Windows.SetParent(FAlarmWindow, FAlarmOriginalParent);
  SetWindowLongPtr(FAlarmWindow, GWL_STYLE, FAlarmOriginalStyle);
  SetWindowLongPtr(FAlarmWindow, GWL_EXSTYLE, FAlarmOriginalExStyle);
  W := Max(100, FAlarmOriginalRect.Right - FAlarmOriginalRect.Left);
  H := Max(100, FAlarmOriginalRect.Bottom - FAlarmOriginalRect.Top);
  SetWindowPos(FAlarmWindow, HWND_TOP, FAlarmOriginalRect.Left,
    FAlarmOriginalRect.Top, W, H,
    SWP_FRAMECHANGED or SWP_SHOWWINDOW or SWP_NOACTIVATE);
  FAlarmWindow := 0;
end;

procedure TfrmAlarmHistory.RestoreAlarmHistoryOnShutdown;
begin
  FRestoringForShutdown := True;
  RestoreEmbeddedAlarmHistoryWindow;
  CloseAlarmHistoryWindow;
end;

procedure TfrmAlarmHistory.FormHide(Sender: TObject);
begin
  if not FRestoringForShutdown then
    CloseAlarmHistoryWindow;
end;

procedure TfrmAlarmHistory.FormShow(Sender: TObject);
begin
  elApplyLanguage(Self);
  if (FAlarmWindow <> 0) and IsWindow(FAlarmWindow) then
  begin
    ShowWindow(FAlarmWindow, SW_SHOW);
    ResizeEmbeddedWindow(nil);
  end
  else
  begin
    FAlarmWindow := 0;
    AlarmManager.ShowAlarmHistory;
    FEmbedTimer.Enabled := True;
  end;
end;

function EnumAlarmHistoryWindow(AHandle: HWND; AParam: LPARAM): BOOL; stdcall;
var
  Caption: array[0..255] of Char;
  WindowProcessID: DWORD;
begin
  Result := True;
  if not IsWindowVisible(AHandle) then Exit;
  // DTS의 내장 폼도 제목이 '알람 이력'이므로 종료 대상에서 제외한다.
  WindowProcessID := 0;
  GetWindowThreadProcessId(AHandle, @WindowProcessID);
  if WindowProcessID = GetCurrentProcessId then Exit;
  Caption[0] := #0;
  GetWindowText(AHandle, Caption, Length(Caption));
  if (Pos('알람 이력', string(Caption)) > 0) or
     (Pos('Alarm History', string(Caption)) > 0) then
  begin
    PHandle(AParam)^ := AHandle;
    Result := False;
  end;
end;

function TfrmAlarmHistory.FindAlarmHistoryWindow: HWND;
begin
  Result := 0;
  EnumWindows(@EnumAlarmHistoryWindow, LPARAM(@Result));
end;

procedure TfrmAlarmHistory.EmbedAlarmHistoryWindow(const AHandle: HWND);
var
  Style: NativeInt;
begin
  if (AHandle = 0) or not IsWindow(AHandle) then Exit;
  FAlarmWindow := AHandle;
  FAlarmOriginalParent := GetParent(AHandle);
  FAlarmOriginalStyle := GetWindowLongPtr(AHandle, GWL_STYLE);
  FAlarmOriginalExStyle := GetWindowLongPtr(AHandle, GWL_EXSTYLE);
  GetWindowRect(AHandle, FAlarmOriginalRect);
  Style := GetWindowLongPtr(AHandle, GWL_STYLE);
  Style := (Style and not (WS_CAPTION or WS_THICKFRAME or WS_POPUP)) or
    WS_CHILD or WS_VISIBLE;
  SetWindowLongPtr(AHandle, GWL_STYLE, Style);
  Windows.SetParent(AHandle, FAlarmHost.Handle);
  SetWindowPos(AHandle, HWND_TOP, 0, 0, FAlarmHost.ClientWidth,
    FAlarmHost.ClientHeight, SWP_FRAMECHANGED or SWP_SHOWWINDOW);
  FEmbedTimer.Enabled := False;
end;

procedure TfrmAlarmHistory.EmbedTimer(Sender: TObject);
var
  AlarmHandle: HWND;
begin
  AlarmHandle := FindAlarmHistoryWindow;
  if AlarmHandle <> 0 then
    EmbedAlarmHistoryWindow(AlarmHandle);
end;

procedure TfrmAlarmHistory.ResizeEmbeddedWindow(Sender: TObject);
begin
  if (FAlarmWindow <> 0) and IsWindow(FAlarmWindow) and Assigned(FAlarmHost) then
    SetWindowPos(FAlarmWindow, HWND_TOP, 0, 0, FAlarmHost.ClientWidth,
      FAlarmHost.ClientHeight, SWP_NOACTIVATE or SWP_SHOWWINDOW);
end;

end.
