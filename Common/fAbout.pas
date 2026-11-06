unit fAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  Buttons,
  ExtCtrls,
  Registry,
  ShellApi,
  Menus,
  ComCtrls,

  foWinUtils,

  elLabel,
  elButton,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,
  cxControls,
  cxScrollBox,

  uCommonUtils;

type
  TfrmAbout = class(TForm)
    imgIcon: TImage;
    lblLogo: TelLabel;
    lblVersion: TelLabel;
    lblCopyright: TelLabel;
    lblRights: TelLabel;
    lblWWW: TelLabel;
    lblMail: TelLabel;
    lblLibraries: TelLabel;
    lblHomePage: TelLabel;
    lblEmail: TelLabel;
    lvLib: TListView;
    btnClose: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure lblHomePageClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutBox;
function GetVersionString(const FileName : String) : string;

implementation

{$R *.DFM}

procedure ShowAboutBox;
var
  F : TfrmAbout;
begin
  F := TfrmAbout.Create(Application);
  try
    F.ShowModal;
  finally
    FreeANdNil(F);
  end;
end;

{------------------------------------------------------------------------------}
{ 지정한 파일의 버전 정보를 구한다.                                            }
{------------------------------------------------------------------------------}
function GetBuildVersionInfo(Const FileName : String; var V1, V2, V3, V4: Word) : Boolean;
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
        with VerValue^ do begin
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

function GetFileInfo(const FileName, RetrieveWhat : string) : string;
{   CompanyName
    FileDescription
    FileVersion
    InternalName
    LegalCopyright
    OriginalFilename
    ProductName
    ProductVersion }
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Idiom : string;
  Dummy: DWORD;
begin
  Result:='';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
    begin
      VerQueryValue(VerInfo, '\VarFileInfo\Translation', Pointer(VerValue), VerValueSize);
      Idiom := IntToHex(DWORD(VerValue), 8);
      VerQueryValue(VerInfo, Pchar('\StringFileInfo\' + Idiom + '\' + RetrieveWhat), Pointer(VerValue), VerValueSize);
      if VerValueSize > 0 then
      begin
        Result := Copy(PChar(VerValue), 1, VerValueSize);
      end;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

function GetVersionString(const FileName : String) : string;
var
  V1, V2, V3, V4 : WORD;
begin
  GetBuildVersionInfo(FileName, V1, V2, V3, V4);
  Result := Format('%d.%d.%d.%d', [V1, V2, V3, V4]);
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  lblHomePage.Font.Color := clBlue;
  lblEmail.Font.Color := clBlue;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
Var
  V1, V2, V3, V4 : WORD;
  DLLList : TStrings;
  I : Integer;
begin
  Caption := 'About ' + Application.Title;
  lblLogo.Caption := Application.Title;
  imgIcon.Picture.Assign(Application.Icon);
  { 실행 프로그램의 버전 정보를 구한다. }
  GetBuildVersionInfo(ParamStr(0), V1, V2, V3, V4);
  { 버전 정보 출력 }
  lblVersion.Caption := Format('Version %d.%d (Build : %d.%d.%d.%d)', [V1, V2, V1, V2, V3, V4]);

  DLLList := TStringList.Create;
  try
    foFindFiles(ExtractFilePath(Application.ExeName), '*.dll', DLLList, False);
    TStringList(DLLList).Sort;
    for I := 0 to Pred(DLLList.Count) do
    begin
      with lvLib.Items.Add do
      begin
        Caption := ExtractFileName(DLLList[I]);
        SubItems.Add(GetVersionString(DLLList[I]));
      end;
    end;
  finally
    DLLList.Free;
  end;
end;

procedure TfrmAbout.lblHomePageClick(Sender: TObject);
begin
  ShellExecute(0, 'Open', PChar(lblHomePage.Caption), '', '', SW_SHOWNORMAL);
end;

procedure TfrmAbout.lblEmailClick(Sender: TObject);
begin
  ShellExecute(0, 'Open', PChar('mailto:' + lblEmail.Caption), '', '', SW_SHOWNORMAL);
end;

end.
