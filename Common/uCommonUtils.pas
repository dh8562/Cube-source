unit uCommonUtils;

interface

uses
  Windows,
  Controls,
  Forms,
  Classes,
  SysUtils,
  Graphics,
  StdCtrls,
  Menus,
  TypInfo,

  ShellAPI,
//  ECallStack,
//  ExceptionLog7,

  CodeSiteLogging,

  dxSkinsForm,
  dxSkinsDefaultPainters,
  dxSkinInfo,
  dxSkinsCore,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxStatusBar,

  elPanels,
  elColorConsts,
  elExplorerBar,
  elMultiLanguage,

  foButton,
  foLabel,
  foChannelSpy,
  foWinUtils,
  foStringUtils,
  foFrame,
  foLED,
  foIndicator,
  foRectUtils,
  foCaptionStyle,
  foGraphicUtils,
  foRTTIUtils,
  foTypes,
  foDataServer,

  voCustomDefectViewer;

const
  SCREEN_FONT_SIZE = 12;

procedure CenterizeControl(AControl: TControl);
procedure EmbedTo(AControl: TWinControl; AParent: TWinControl);
procedure ModalFitTo(AControl: TWinControl; AParent: TWinControl);
function GetBuildVersionInfo(Const FileName: String;
  var V1, V2, V3, V4: Word): Boolean;
function TempFileName(const ARootPath: String; const APrefix: string): string;
function CheckDiskFreeSpace: Boolean;
procedure ApplySkinColor(ASkinName: string; AForm: TForm);
function GetSkinBackColor(ASkinName: string): TColor;
function GetSkinTextColor(ASkinName: string): TColor;
function GetSkinTextDisabledColor(ASkinName: string): TColor;
function DeleteFiles(const Folder: string; const Exts: string): Boolean;
function ChangeToUNCPath(const Path: string): string;
procedure LogCallStack(const AMsg: string);

procedure NormalCursor;
procedure WaitCursor;

procedure MakeApplicationForeground;
function ShellExecAndWait(const FileName: string; const Parameters: string;
  const Verb: string; CmdShow: Integer; const Directory: string): Boolean;

function UMtoMM(const AValue: Double): Double;
function MMtoUM(const AValue: Double): Double;

procedure LoadComponentFromFile(const AFileName : string; AComponent : TComponent);
procedure SaveComponentToFile(const AFileName : string; AComponent : TComponent);

implementation

procedure LoadComponentFromFile(const AFileName : string; AComponent : TComponent);
var
  BS, TS : TMemoryStream;
begin
  BS := TMemoryStream.Create;
  TS := TMemoryStream.Create;
  try
    TS.LoadFromFile(AFileName);
    TS.Seek(0, soFromBeginning);

    ObjectTextToBinary(TS, BS);

    BS.Seek(0, soFromBeginning);
    BS.ReadComponent(AComponent);
  finally
    BS.Free;
    TS.Free;
  end;
end;

{@@
  콤포넌트 속성을 DFM 형태로 저장한다.
}
procedure SaveComponentToFile(const AFileName : string; AComponent : TComponent);
var
  BS, TS : TMemoryStream;
begin
  BS := TMemoryStream.Create;
  TS := TMemoryStream.Create;
  try
    BS.WriteComponent(AComponent);
    BS.Seek(0, soFromBeginning);
    ObjectBinaryToText(BS, TS);
    TS.SaveToFile(AFileName);
  finally
    BS.Free;
    TS.Free;
  end;
end;


procedure CenterizeControl(AControl: TControl);
begin
  if AControl.Parent <> nil then
  begin
    AControl.SetBounds((AControl.Parent.Width - AControl.Width) div 2,
      (AControl.Parent.Height - AControl.Height) div 2, AControl.Width,
      AControl.Height);
  end;
end;

procedure EmbedTo(AControl: TWinControl; AParent: TWinControl);
begin
  if AControl is TCustomForm then
    TCustomForm(AControl).BorderStyle := bsNone;
  AControl.Parent := AParent;
  AControl.Show;
  AControl.Align := alClient;
  AParent.Realign;
end;

procedure ModalFitTo(AControl: TWinControl; AParent: TWinControl);
var
  PT: TPoint;
begin
  if AControl is TCustomForm then
    TCustomForm(AControl).BorderStyle := bsNone;

  PT := AParent.ClientToScreen(POINT(0, 0));
  AControl.Left := PT.X;
  AControl.Top := PT.Y;
  AControl.Width := AParent.Width;
  AControl.Height := AParent.Height;
end;

function GetBuildVersionInfo(Const FileName: String;
  var V1, V2, V3, V4: Word): Boolean;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := False;
  V1 := 0;
  V2 := 0;
  V3 := 0;
  V4 := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
      begin
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        with VerValue^ do
        begin
          V1 := dwFileVersionMS shr 16;
          V2 := dwFileVersionMS and $FFFF;
          V3 := dwFileVersionLS shr 16;
          V4 := dwFileVersionLS and $FFFF;
        end;
        Result := True;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

function GetFileInfo(const FileName, RetrieveWhat: string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Idiom: string;
  Dummy: DWORD;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
    begin
      VerQueryValue(VerInfo, '\VarFileInfo\Translation', Pointer(VerValue),
        VerValueSize);
      Idiom := IntToHex(DWORD(VerValue), 8);
      VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Idiom + '\' +
        RetrieveWhat), Pointer(VerValue), VerValueSize);
      if VerValueSize > 0 then
      begin
        Result := Copy(PChar(VerValue), 1, VerValueSize);
      end;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

function GetVersionString(const FileName: String): string;
var
  V1, V2, V3, V4: Word;
begin
  GetBuildVersionInfo(FileName, V1, V2, V3, V4);
  Result := Format('%d.%d.%d.%d', [V1, V2, V3, V4]);
end;

function TempFileName(const ARootPath: String; const APrefix: string): string;
var
  TmpName: PChar;
begin
  Result := '';
  GetMem(TmpName, MAX_PATH);
  try
    FillChar(TmpName^, MAX_PATH, #0);
    GetTempFileName(PChar(ARootPath), PChar(APrefix), 0, TmpName);
    Result := TmpName;
  finally
    FreeMem(TmpName, MAX_PATH);
  end;
end;

function CheckDiskFreeSpace: Boolean;
var
  FreeAvailable, TotalSpace: Int64;
  TotalFree: LARGE_INTEGER;
begin
  Result := GetDiskFreeSpaceEx(PChar(foAppPath), FreeAvailable, TotalSpace,
    @TotalFree);
  if Result then
  begin
    if FreeAvailable > 3000000000 then
    begin
      Result := True;
    end
    else
      Result := False;
  end;
end;

function GetSkinBackColor(ASkinName: string): TColor;
var
  APainter: TcxCustomLookAndFeelPainter;
  ASkinInfo: TdxSkinInfo;
begin
  Result := clWindow;
  if cxLookAndFeelPaintersManager.GetPainter(ASkinName, APainter) then
  begin
    APainter.GetPainterData(ASkinInfo);
    Result := ASkinInfo.ContentColor.Value;
  end;
end;

function GetSkinTextColor(ASkinName: string): TColor;
var
  APainter: TcxCustomLookAndFeelPainter;
  ASkinInfo: TdxSkinInfo;
begin
  Result := clWindowText;
  if cxLookAndFeelPaintersManager.GetPainter(ASkinName, APainter) then
  begin
    APainter.GetPainterData(ASkinInfo);
    Result := ASkinInfo.EditorTextColors[esckNormal].Value;
  end;
end;

function GetSkinTextDisabledColor(ASkinName: string): TColor;
var
  APainter: TcxCustomLookAndFeelPainter;
  ASkinInfo: TdxSkinInfo;
begin
  Result := clWindowText;
  if cxLookAndFeelPaintersManager.GetPainter(ASkinName, APainter) then
  begin
    APainter.GetPainterData(ASkinInfo);
    Result := ASkinInfo.EditorTextColors[esckDisabled].Value;
  end;
end;

procedure ApplySkinColor(ASkinName: string; AForm: TForm);
var
  APainter: TcxCustomLookAndFeelPainter;
  ASkinInfo: TdxSkinInfo;
  I: Integer;
begin
  if cxLookAndFeelPaintersManager.GetPainter(ASkinName, APainter) then
  begin
    // Getting a painter's skin data
    APainter.GetPainterData(ASkinInfo);

    for I := 0 to AForm.ComponentCount - 1 do
    begin
      if AForm.Components[I] is TelExplorerBar then
      begin
        with TelExplorerBar(AForm.Components[I]) do
        begin
          if VisualStyles.Count > 0 then
          begin
            VisualStyles[0].BackgroundColorStart :=
              ASkinInfo.ContentColor.Value;
            VisualStyles[0].BackgroundColorEnd := ASkinInfo.ContentColor.Value;
            VisualStyles[0].NormalBorderColor :=
              ASkinInfo.ContainerBorderColor.Value;
            VisualStyles[0].NormalBackgroundColor :=
              ASkinInfo.ContentColor.Value;
            VisualStyles[0].NormalCaptionColor := ASkinInfo.EditorTextColors
              [esckNormal].Value;
            VisualStyles[0].NormalCaptionHotColor := ASkinInfo.EditorTextColors
              [esckNormal].Value;
            VisualStyles[0].NormalTitleColorStart :=
              ASkinInfo.ContainerHighlightBorderColor.Value;
            VisualStyles[0].NormalTitleColorEnd :=
              ASkinInfo.ContainerHighlightBorderColor.Value;
          end;
          Color := ASkinInfo.ContentColor.Value;
        end;
      end
      else if AForm.Components[I] is TelebGroup then
      begin
        with TelebGroup(AForm.Components[I]) do
        begin
          Color := ASkinInfo.ContentColor.Value;
        end;
      end
      else if AForm.Components[I] is TelCoolPanel then
      begin
        with TelCoolPanel(AForm.Components[I]) do
        begin
          BorderColor := ASkinInfo.ContainerBorderColor.Value;
          Body.ColorCaption := ASkinInfo.EditorTextColors[esckNormal].Value;
          Body.ColorStart := ASkinInfo.ContentColor.Value;
          Body.ColorEnd := ASkinInfo.ContentColor.Value;
          Header.ColorCaption := ASkinInfo.EditorTextColors[esckNormal].Value;
          Header.ColorStart := ASkinInfo.ContentColor.Value;
          Header.ColorEnd := ASkinInfo.ContentColor.Value;
          Footer.ColorCaption := ASkinInfo.EditorTextColors[esckNormal].Value;
          Footer.ColorStart := ASkinInfo.ContentColor.Value;
          Footer.ColorEnd := ASkinInfo.ContentColor.Value;
        end;
      end
      else if AForm.Components[I] is TfoLabel then
      begin
        with TfoLabel(AForm.Components[I]) do
        begin
          Color := ASkinInfo.ContentColor.Value;
          if Parent is TdxStatusBarContainerControl then
            Font.Color := ASkinInfo.FormStatusBar.TextColor
          else
            Font.Color := ASkinInfo.ButtonElements.TextColor;
          Frame.Style := fsFlat;
          Frame.FlatColor := ASkinInfo.ContainerBorderColor.Value;
        end;
      end
      else if AForm.Components[I] is TfoLEDBtn then
      begin
        with TfoLEDBtn(AForm.Components[I]) do
        begin
          LED.OffColor := ASkinInfo.ContentColor.Value;
          LED.BorderColor := ASkinInfo.ContainerBorderColor.Value;
          LED.Style := lsFlat;
          Font.Color := ASkinInfo.ButtonElements.TextColor;
        end;
      end
      else if AForm.Components[I] is TfoLED then
      begin
        with TfoLED(AForm.Components[I]) do
        begin
          if Tag <> -1 then
          begin
            LED.OffColor := ASkinInfo.ContentColor.Value;
            LED.BorderColor := ASkinInfo.ContainerBorderColor.Value;
            Font.Color := ASkinInfo.ButtonElements.TextColor;
            Frame.Style := fsFlat;
            Frame.FlatColor := ASkinInfo.ContainerBorderColor.Value;
          end;
        end;
      end
      else if AForm.Components[I] is TfoChannelSpy then
      begin
        with TfoChannelSpy(AForm.Components[I]) do
        begin
          Color := ASkinInfo.ContentColor.Value;
          Font.Color := ASkinInfo.ButtonElements.TextColor;
        end;
      end
      else if AForm.Components[I] is TfoCustomIndicator then
      begin
        with TfoCustomIndicator(AForm.Components[I]) do
        begin
          Color := ASkinInfo.ContentColor.Value;
          FrameViewPort.FlatColor := ASkinInfo.ContainerBorderColor.Value;
          FrameViewPort.Style := fsFlat;
          Font.Color := ASkinInfo.ButtonElements.TextColor;
        end;
        // end
        // else if AForm.Components[I] is TvoCustomDefectViewer then
        // begin
        // with TvoCustomDefectViewer(AForm.Components[I]) do
        // begin
        // Color := ASkinInfo.ContentColor.Value;
        // end;
      end;
    end;
  end;
end;

function DeleteFiles(const Folder: string; const Exts: string): Boolean;
var
  DirInfo: TSearchRec;
  Ret: Integer;
  szTmp: string;
begin
  Result := False;
  if not DirectoryExists(Folder) then
    Exit;
  szTmp := Folder;
  if szTmp[Length(szTmp)] <> '\' then
    szTmp := szTmp + '\';
  Ret := FindFirst(Folder + Exts, faAnyfile, DirInfo);
  while Ret = 0 do
  begin
    if ((DirInfo.Attr and faDirectory <> faDirectory) and
      (DirInfo.Attr and faVolumeId <> faVolumeId)) then
    begin
      DeleteFile(PChar(szTmp + DirInfo.Name));
    end;
    Ret := FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
  Result := True;
end;

function ComputerName: string;
var
  cName: array [0 .. MAX_COMPUTERNAME_LENGTH] of char;
  nSize: Cardinal;
begin
  nSize := MAX_COMPUTERNAME_LENGTH;
  GetComputerName(cName, nSize);
  Result := StrPas(cName);
end;

function ChangeToUNCPath(const Path: string): string;
begin
  if Pos(':\', Path) = 2 then
  begin
    Result := Path;
    Delete(Result, 2, 1);
    Insert('$', Result, 2);
    Result := IncludeTrailingBackslash('\\' + ComputerName + '\' + Result);
  end
  else
    Result := IncludeTrailingBackslash(Path);
end;

procedure LogCallStack(const AMsg: string);
//var
//  CallStackList: TStrings;
//  StackList: TEurekaBaseStackList;
begin
//  CallStackList := TStringList.Create;
//  try
//    StackList := GetCurrentCallStack;
//    CallStackToStrings(StackList, CallStackList);
//    StackList.Free;
//    CodeSite.Send('CallStack : ' + AMsg, CallStackList);
//  finally
//    CallStackList.Free;
//  end;
end;

procedure NormalCursor;
begin
  Screen.Cursor := crArrow;
end;

procedure WaitCursor;
begin
  Screen.Cursor := crHourGlass;
end;

function ForceForegroundWindow(hWnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hWnd) then
    ShowWindow(hWnd, SW_RESTORE);

  if GetForegroundWindow = hWnd then
    Result := True
  else
  begin

    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin

      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadProcessID(hWnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hWnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hWnd);
      end;
      if not Result then
      begin

        // Code by Daniel P. Stasinski

        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hWnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout),
          SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hWnd); // IE 5.5 related hack
      SetForegroundWindow(hWnd);
    end;

    Result := (GetForegroundWindow = hWnd);
  end;
end;

procedure MakeApplicationForeground;
var
  TopWindow: hWnd;
begin
  Application.Restore;
  Application.BringToFront;
  if Application.MainFormHandle <> 0 then
  begin
    TopWindow := GetLastActivePopup(Application.Handle);
    if (TopWindow <> 0) and (TopWindow <> Application.Handle) and
      IsWindowVisible(TopWindow) and IsWindowEnabled(TopWindow) then
      ForceForegroundWindow(TopWindow);
  end;
  SetWindowPos(TopWindow, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(TopWindow, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(TopWindow, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or
    SWP_NOMOVE or SWP_NOSIZE);
end;

function ShellExecAndWait(const FileName: string; const Parameters: string;
  const Verb: string; CmdShow: Integer; const Directory: string): Boolean;
var
  Sei: TShellExecuteInfo;
  Res: LongBool;
  Msg: tagMSG;
begin
  FillChar(Sei, SizeOf(Sei), 0);
  Sei.cbSize := SizeOf(Sei);
  Sei.fMask := SEE_MASK_DOENVSUBST or SEE_MASK_FLAG_NO_UI or
    SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;

  Sei.lpFile := PChar(FileName);
  Sei.lpParameters := PChar(Parameters);
  Sei.lpVerb := PChar(Verb);
  Sei.nShow := CmdShow;
  Sei.lpDirectory := PChar(Directory);
{$TYPEDADDRESS ON}
  Result := ShellExecuteEx(@Sei);
{$IFNDEF TYPEDADDRESS_ON}
{$TYPEDADDRESS OFF}
{$ENDIF ~TYPEDADDRESS_ON}
  if Result then
  begin
    WaitForInputIdle(Sei.hProcess, INFINITE);
    while WaitForSingleObject(Sei.hProcess, 10) = WAIT_TIMEOUT do
    begin
      repeat
        Msg.hWnd := 0;
        Res := PeekMessage(Msg, Sei.Wnd, 0, 0, PM_REMOVE);
        if Res then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      until not Res;
    end;
    CloseHandle(Sei.hProcess);
  end;
end;

function UMtoMM(const AValue: Double): Double;
begin
  Result := AValue / 1000;
end;

function MMtoUM(const AValue: Double): Double;
begin
  Result := AValue * 1000;
end;

end.
