unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  StdCtrls,

  foTypes,
  foWinUtils,

  uLogger,
  uCommonUtils,
  uEquipment;

type
  TfrmSplash = class(TForm)
    imgSplash: TImage;
    lblMsg: TLabel;
    lblVersion: TLabel;
    lblDesc: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoSplashMsg(Sender : TObject; const AMsg : string);

    procedure ShowMsg(const Msg : string);
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

procedure TfrmSplash.FormCreate(Sender: TObject);
var
  V1, V2, V3, V4 : WORD;
begin
  DesktopFont := True;
  if FileExists(foAppPath + 'splash.bmp') then
  begin
    imgSplash.Picture.LoadFromFile(foAppPath + 'splash.bmp');
    ClientWidth := imgSplash.Picture.Width;
    ClientHeight := imgSplash.Picture.Height;
  end;

  { 실행 프로그램의 버전 정보를 구한다. }
  GetBuildVersionInfo(ParamStr(0), V1, V2, V3, V4);
  { 버전 정보 출력 }
  lblVersion.Caption := Format('Version %d.%d (Build : %d.%d.%d.%d)', [V1, V2, V1, V2, V3, V4]);
  lblMsg.Font.Size := 8;
  Equipment.OnSplashMsg := DoSplashMsg;
end;

procedure TfrmSplash.DoSplashMsg(Sender : TObject; const AMsg: string);
begin
  ShowMsg(AMsg);
end;

procedure TfrmSplash.ShowMsg(const Msg: string);
begin
  lblMsg.Caption := Msg;
  lblMsg.Refresh;
end;

end.
