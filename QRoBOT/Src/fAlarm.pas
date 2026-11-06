unit fAlarm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, IniFiles, Math,

  Xml.XMLDoc, Xml.XMLIntf,

  foWinUtils,
  foControls,
  foLCD,
  foAlarmManager,
  foStringUtils,
  uAlarmConsts,
  uEquipment,


  dmHAL, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, elPanels, cxButtons, elBase, elLog,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo,
  dxGDIPlusClasses, Vcl.Imaging.pngimage;

type
  TActiveAlarmInfo = class
  public
    Code: Integer;
    Description: string;
    Severity: Integer;
    OccurredAt: TDateTime;
  end;

  TfrmAlarm = class(TForm)
    Timer1: TTimer;
    btnClose: TcxButton;
    btnBuzzerOff: TcxButton;
    elPanel14: TelPanel;
    elPanel4: TelPanel;
    elPanel5: TelPanel;
    memoNotes: TcxMemo;
    elPanel6: TelPanel;
    elPanel2: TelPanel;
    memoDesc: TcxMemo;
    chkAlwaysOnTop: TCheckBox;
    panError: TelPanel;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDoorOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkAlwaysOnTopClick(Sender: TObject);
  private
    FXMLDoc: IXMLDocument;
    FCurrentAlarmCode: Integer;
    FCurrentSeverity: Integer;
    FCurrentNotes: string;
    FActiveAlarms: TList;
    FRootPanel: TPanel;
    FHeaderLabel: TLabel;
    FMetaLabel: TLabel;
    FWarningPaint: TPaintBox;
    FTitlePanel: TPanel;
    FTitleLabel: TLabel;
    FDetailMemo: TMemo;
    FConfirmButton: TButton;
    FDetailButton: TButton;
    procedure BuildAlarmPopup;
    procedure WarningPaint(Sender: TObject);
    procedure ConfirmButtonClick(Sender: TObject);
    procedure DetailButtonClick(Sender: TObject);
    procedure DragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DisplayAlarm(const AAlarm: TActiveAlarmInfo);
    procedure LoadWindowPosition;
    procedure SaveWindowPosition;
    procedure FindAlarmInfo(const AAlarmCode: Integer;
      out ADescription, ANotes: string; out ASeverity: Integer);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    procedure LoadAlarmsFromXML(const FileName: string);
    procedure AddAlarm(nAlarmNo : Integer);
    procedure ShowAlarm(const AAlarmCode: Integer;
      const AAlarmDesc: string; const ASeverity: Integer);
    procedure RemoveAlarm(const AAlarmCode: Integer);
  end;

var
  frmAlarm: TfrmAlarm;

implementation

{$R *.dfm}

uses fAuto, fMain, dmMachine;

procedure TfrmAlarm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  // 메인 폼의 Owned Window로 생성되면 Windows 정책상 메인 폼 뒤로
  // 이동할 수 없으므로 독립된 최상위 도구 창으로 생성한다.
  Params.WndParent := 0;
  Params.ExStyle := (Params.ExStyle or WS_EX_TOOLWINDOW) and
                    not WS_EX_APPWINDOW;
end;

procedure TfrmAlarm.AddAlarm(nAlarmNo : Integer);
var
  AlarmDesc, AlarmNotes: string;
  AlarmSeverity: Integer;
begin
  FindAlarmInfo(nAlarmNo, AlarmDesc, AlarmNotes, AlarmSeverity);
  ShowAlarm(nAlarmNo, AlarmDesc, AlarmSeverity);
end;

procedure TfrmAlarm.BuildAlarmPopup;
var
  I: Integer;
begin
  for I := ComponentCount - 1 downto 0 do
    if (Components[I] is TControl) and
       (TControl(Components[I]).Parent = Self) then
      TControl(Components[I]).Visible := False;

  BorderStyle := bsNone;
  Position := poMainFormCenter;
  ClientWidth := 500;
  ClientHeight := 550;
  Color := RGB(52, 31, 24);

  FRootPanel := TPanel.Create(Self);
  FRootPanel.Parent := Self;
  FRootPanel.Align := alClient;
  FRootPanel.BevelOuter := bvNone;
  FRootPanel.ParentBackground := False;
  FRootPanel.Color := RGB(52, 31, 24);
  FRootPanel.OnMouseDown := DragMouseDown;

  FHeaderLabel := TLabel.Create(Self);
  FHeaderLabel.Parent := FRootPanel;
  FHeaderLabel.SetBounds(20, 15, 460, 34);
  FHeaderLabel.AutoSize := False;
  FHeaderLabel.Alignment := taCenter;
  FHeaderLabel.Layout := tlCenter;
  FHeaderLabel.Font.Name := 'Malgun Gothic';
  FHeaderLabel.Font.Size := 14;
  FHeaderLabel.Font.Style := [fsBold];
  FHeaderLabel.Font.Color := RGB(235, 220, 208);
  FHeaderLabel.Caption := #$C54C#$B78C' '#$C0C1#$C138' '#$B0B4#$C5ED;
  FHeaderLabel.OnMouseDown := DragMouseDown;

  FMetaLabel := TLabel.Create(Self);
  FMetaLabel.Parent := FRootPanel;
  FMetaLabel.SetBounds(25, 57, 450, 52);
  FMetaLabel.AutoSize := False;
  FMetaLabel.WordWrap := True;
  FMetaLabel.Font.Name := 'Malgun Gothic';
  FMetaLabel.Font.Size := 9;
  FMetaLabel.Font.Color := clWhite;
  FMetaLabel.OnMouseDown := DragMouseDown;

  FWarningPaint := TPaintBox.Create(Self);
  FWarningPaint.Parent := FRootPanel;
  FWarningPaint.SetBounds(150, 112, 200, 160);
  FWarningPaint.OnPaint := WarningPaint;
  FWarningPaint.OnMouseDown := DragMouseDown;

  FTitlePanel := TPanel.Create(Self);
  FTitlePanel.Parent := FRootPanel;
  FTitlePanel.SetBounds(10, 285, 480, 58);
  FTitlePanel.BevelOuter := bvNone;
  FTitlePanel.ParentBackground := False;
  FTitlePanel.OnMouseDown := DragMouseDown;

  FTitleLabel := TLabel.Create(Self);
  FTitleLabel.Parent := FTitlePanel;
  FTitleLabel.Align := alClient;
  FTitleLabel.AutoSize := False;
  FTitleLabel.Alignment := taCenter;
  FTitleLabel.Layout := tlCenter;
  FTitleLabel.Font.Name := 'Malgun Gothic';
  FTitleLabel.Font.Size := 11;
  FTitleLabel.Font.Style := [fsBold];
  FTitleLabel.OnMouseDown := DragMouseDown;

  FDetailMemo := TMemo.Create(Self);
  FDetailMemo.Parent := FRootPanel;
  FDetailMemo.SetBounds(10, 345, 480, 120);
  FDetailMemo.BorderStyle := bsNone;
  FDetailMemo.ReadOnly := True;
  FDetailMemo.ScrollBars := ssVertical;
  FDetailMemo.Font.Name := 'Malgun Gothic';
  FDetailMemo.Font.Size := 10;
  FDetailMemo.Color := RGB(248, 246, 242);
  FDetailMemo.Font.Color := RGB(45, 45, 45);

  FConfirmButton := TButton.Create(Self);
  FConfirmButton.Parent := FRootPanel;
  FConfirmButton.SetBounds(20, 482, 220, 50);
  FConfirmButton.Font.Name := 'Malgun Gothic';
  FConfirmButton.Font.Size := 11;
  FConfirmButton.Font.Style := [fsBold];
  FConfirmButton.Caption := #$D655#$C778' '#$BC0F' '#$C870#$CE58;
  FConfirmButton.OnClick := ConfirmButtonClick;

  FDetailButton := TButton.Create(Self);
  FDetailButton.Parent := FRootPanel;
  FDetailButton.SetBounds(260, 482, 220, 50);
  FDetailButton.Font.Name := 'Malgun Gothic';
  FDetailButton.Font.Size := 11;
  FDetailButton.Caption := #$C0C1#$C138' '#$B0B4#$C5ED' '#$D655#$C778;
  FDetailButton.OnClick := DetailButtonClick;
end;

procedure TfrmAlarm.WarningPaint(Sender: TObject);
var
  P: array[0..2] of TPoint;
  R: TRect;
begin
  FWarningPaint.Canvas.Brush.Color := FRootPanel.Color;
  FWarningPaint.Canvas.FillRect(FWarningPaint.ClientRect);

  P[0] := Point(FWarningPaint.Width div 2, 8);
  P[1] := Point(18, FWarningPaint.Height - 12);
  P[2] := Point(FWarningPaint.Width - 18, FWarningPaint.Height - 12);
  FWarningPaint.Canvas.Brush.Color := RGB(255, 220, 30);
  FWarningPaint.Canvas.Pen.Color := RGB(225, 35, 25);
  FWarningPaint.Canvas.Pen.Width := 8;
  FWarningPaint.Canvas.Polygon(P);

  R := Rect(0, 36, FWarningPaint.Width, FWarningPaint.Height - 12);
  FWarningPaint.Canvas.Brush.Style := bsClear;
  FWarningPaint.Canvas.Font.Name := 'Arial';
  FWarningPaint.Canvas.Font.Height := -86;
  FWarningPaint.Canvas.Font.Style := [fsBold];
  FWarningPaint.Canvas.Font.Color := RGB(220, 35, 25);
  DrawText(FWarningPaint.Canvas.Handle, '!', -1, R,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TfrmAlarm.ConfirmButtonClick(Sender: TObject);
var
  AlarmCode: Integer;
begin
  AlarmCode := FCurrentAlarmCode;
  Hide;
  if AlarmCode >= 0 then
    AlarmManager.ReleaseAlarm(AlarmCode);
end;

procedure TfrmAlarm.DetailButtonClick(Sender: TObject);
begin
  FDetailMemo.SetFocus;
  FDetailMemo.SelStart := 0;
  FDetailMemo.SelLength := 0;
end;

procedure TfrmAlarm.DragMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then
    Exit;
  ReleaseCapture;
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TfrmAlarm.LoadWindowPosition;
var
  Ini: TIniFile;
  IniFile: string;
  SavedLeft, SavedTop: Integer;
  WorkArea: TRect;
  TargetMonitor: TMonitor;
begin
  IniFile := IncludeTrailingPathDelimiter(
    ExtractFilePath(Application.ExeName)) + 'DTS.ini';
  Ini := TIniFile.Create(IniFile);
  try
    SavedLeft := Ini.ReadInteger('UI', 'AlarmPopupLeft', Low(Integer));
    SavedTop := Ini.ReadInteger('UI', 'AlarmPopupTop', Low(Integer));
  finally
    Ini.Free;
  end;

  if (SavedLeft = Low(Integer)) or (SavedTop = Low(Integer)) then
    Exit;

  TargetMonitor := Screen.MonitorFromPoint(Point(SavedLeft, SavedTop), mdNearest);
  WorkArea := TargetMonitor.WorkareaRect;
  Position := poDesigned;
  Left := EnsureRange(SavedLeft, WorkArea.Left,
    Max(WorkArea.Left, WorkArea.Right - Width));
  Top := EnsureRange(SavedTop, WorkArea.Top,
    Max(WorkArea.Top, WorkArea.Bottom - Height));
end;

procedure TfrmAlarm.SaveWindowPosition;
var
  Ini: TIniFile;
  IniFile: string;
begin
  if WindowState <> wsNormal then
    Exit;
  IniFile := IncludeTrailingPathDelimiter(
    ExtractFilePath(Application.ExeName)) + 'DTS.ini';
  Ini := TIniFile.Create(IniFile);
  try
    Ini.WriteInteger('UI', 'AlarmPopupLeft', Left);
    Ini.WriteInteger('UI', 'AlarmPopupTop', Top);
  finally
    Ini.Free;
  end;
end;

procedure TfrmAlarm.WMExitSizeMove(var Message: TMessage);
begin
  inherited;
  SaveWindowPosition;
end;

procedure TfrmAlarm.FindAlarmInfo(const AAlarmCode: Integer;
  out ADescription, ANotes: string; out ASeverity: Integer);
var
  RootNode, AlarmNode, ValueNode: IXMLNode;
  I: Integer;
begin
  ADescription := Format('Alarm %d', [AAlarmCode]);
  ANotes := '';
  ASeverity := 0;
  if not Assigned(FXMLDoc) or not FXMLDoc.Active then
    Exit;

  RootNode := FXMLDoc.DocumentElement;
  if RootNode = nil then
    Exit;

  for I := 0 to RootNode.ChildNodes.Count - 1 do
  begin
    AlarmNode := RootNode.ChildNodes[I];
    ValueNode := AlarmNode.ChildNodes.FindNode('Code');
    if (ValueNode <> nil) and
       (AAlarmCode = StrToIntDef(ValueNode.Text, 0)) then
    begin
      ValueNode := AlarmNode.ChildNodes.FindNode('Description');
      if ValueNode <> nil then
        ADescription := foTrimLeft(ValueNode.Text, [foCharLf]);
      ValueNode := AlarmNode.ChildNodes.FindNode('Notes');
      if ValueNode <> nil then
        ANotes := foTrimLeft(ValueNode.Text, [foCharLf]);
      ValueNode := AlarmNode.ChildNodes.FindNode('Severity');
      if ValueNode <> nil then
        ASeverity := StrToIntDef(ValueNode.Text, 0);
      Exit;
    end;
  end;
end;

procedure TfrmAlarm.DisplayAlarm(const AAlarm: TActiveAlarmInfo);
var
  XMLDesc, XMLNotes: string;
  XMLSeverity: Integer;
begin
  if AAlarm = nil then
    Exit;

  FindAlarmInfo(AAlarm.Code, XMLDesc, XMLNotes, XMLSeverity);
  FCurrentAlarmCode := AAlarm.Code;
  FCurrentSeverity := AAlarm.Severity;
  FCurrentNotes := XMLNotes;

  FMetaLabel.Caption := Format('ALARM %d: %s'#13#10'Timestamp: %s',
    [AAlarm.Code, AAlarm.Description,
     FormatDateTime('yyyy-mm-dd hh:nn:ss', AAlarm.OccurredAt)]);
  if Length(AAlarm.Description) > 34 then
    FTitleLabel.Font.Size := 10
  else
    FTitleLabel.Font.Size := 11;
  if AAlarm.Severity = 0 then
  begin
    FTitlePanel.Color := RGB(128, 34, 31);
    FTitleLabel.Font.Color := clWhite;
    FTitleLabel.Caption := 'CRITICAL - ' + AAlarm.Description;
  end
  else
  begin
    FTitlePanel.Color := RGB(220, 156, 35);
    FTitleLabel.Font.Color := RGB(42, 42, 42);
    FTitleLabel.Caption := 'Warning - ' + AAlarm.Description;
  end;

  if Trim(XMLNotes) <> '' then
    FDetailMemo.Lines.Text := XMLNotes
  else
    FDetailMemo.Lines.Text := Format('%s'#13#10'%s',
      [AAlarm.Description, #$D604#$C7AC' '#$C0C1#$D0DC#$B97C' '#$D655#$C778#$D558' '#$C8FC#$C2ED#$C2DC#$C624'.']);

  Show;
  BringToFront;
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

procedure TfrmAlarm.ShowAlarm(const AAlarmCode: Integer;
  const AAlarmDesc: string; const ASeverity: Integer);
var
  I: Integer;
  AlarmInfo: TActiveAlarmInfo;
begin
  for I := FActiveAlarms.Count - 1 downto 0 do
    if TActiveAlarmInfo(FActiveAlarms[I]).Code = AAlarmCode then
    begin
      TActiveAlarmInfo(FActiveAlarms[I]).Free;
      FActiveAlarms.Delete(I);
    end;

  AlarmInfo := TActiveAlarmInfo.Create;
  AlarmInfo.Code := AAlarmCode;
  AlarmInfo.Description := AAlarmDesc;
  AlarmInfo.Severity := ASeverity;
  AlarmInfo.OccurredAt := Now;
  FActiveAlarms.Add(AlarmInfo);

  HAL.AddAlarmLog(ASeverity, AAlarmCode, AAlarmDesc);
  DisplayAlarm(AlarmInfo);
end;

procedure TfrmAlarm.RemoveAlarm(const AAlarmCode: Integer);
var
  I: Integer;
  WasCurrent: Boolean;
begin
  WasCurrent := FCurrentAlarmCode = AAlarmCode;
  for I := FActiveAlarms.Count - 1 downto 0 do
    if TActiveAlarmInfo(FActiveAlarms[I]).Code = AAlarmCode then
    begin
      TActiveAlarmInfo(FActiveAlarms[I]).Free;
      FActiveAlarms.Delete(I);
    end;

  if WasCurrent then
  begin
    FCurrentAlarmCode := -1;
    if FActiveAlarms.Count > 0 then
      DisplayAlarm(TActiveAlarmInfo(FActiveAlarms[FActiveAlarms.Count - 1]))
    else
      Hide;
  end;
end;

procedure TfrmAlarm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlarm.btnDoorOpenClick(Sender: TObject);
begin
;
end;

procedure TfrmAlarm.chkAlwaysOnTopClick(Sender: TObject);
var
  MainHandle: HWND;
begin
  if not HandleAllocated then
    Exit;

  if chkAlwaysOnTop.Checked then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  end
  else
  begin
    MainHandle := Application.MainForm.Handle;

    // 알람 창의 항상 위 속성을 먼저 해제한다.
    SetWindowPos(
      Handle,
      HWND_NOTOPMOST,
      0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE
    );

    // 최소화되어 있다면 메인 화면을 복원하고 전면에 표시한다.
    if IsIconic(MainHandle) then
      ShowWindow(MainHandle, SW_RESTORE);

    SetWindowPos(
      MainHandle,
      HWND_TOP,
      0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW
    );
    SetForegroundWindow(MainHandle);

    // 독립된 알람 창을 메인 화면 바로 뒤에 배치한다.
    SetWindowPos(
      Handle,
      MainHandle,
      0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE
    );
  end;
end;

procedure TfrmAlarm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveWindowPosition;
  Action := caHide;
end;

procedure TfrmAlarm.FormCreate(Sender: TObject);
begin
  FXMLDoc := TXMLDocument.Create(nil);
  FCurrentAlarmCode := -1;
  FActiveAlarms := TList.Create;
  BuildAlarmPopup;
  LoadWindowPosition;
end;

procedure TfrmAlarm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  frmAlarm := nil;
  SaveWindowPosition;
  if Assigned(FActiveAlarms) then
  begin
    for I := FActiveAlarms.Count - 1 downto 0 do
      TObject(FActiveAlarms[I]).Free;
    FreeAndNil(FActiveAlarms);
  end;
  FXMLDoc := nil;
end;

procedure TfrmAlarm.FormShow(Sender: TObject);
begin
;;
end;

procedure TfrmAlarm.LoadAlarmsFromXML(const FileName: string);
var
  RootNode, AlarmNode: IXMLNode;
  i: Integer;
begin
  FXMLDoc.LoadFromFile(FileName);
  FXMLDoc.Active := True;
end;

end.
