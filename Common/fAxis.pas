unit fAxis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  Menus,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,

  foLED,
  foMotion,
  foControls,
  foIndicator,
  foButton,

  elMultiLanguage,

  fJog,
  dmMachine,
  dmHAL,
  uCommonUtils, System.ImageList, cxImageList;

type
  TfrmAxis = class(TForm)
    ledFault: TfoLED;
    ledHoming: TfoLED;
    ledMoving: TfoLED;
    ledCWLimit: TfoLED;
    ledCCWLimit: TfoLED;
    ilAxis: TcxImageList;
    btnOrigin: TcxButton;
    btnReady: TcxButton;
    btnStop: TcxButton;
    btnReset: TcxButton;
    btnJog: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnOriginClick(Sender: TObject);
    procedure btnReadyClick(Sender: TObject);
    procedure btnJogClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    { Private declarations }
    FAxis : TfoCustomAxis;
    FJogCaption : string;
    FJogCWCaption : string;
    FJogCCWCaption : string;
  public
    { Public declarations }
    procedure SetUp(AAxis : TfoCustomAxis; const ACaption, ACCWCaption, ACWCaption : string);
    procedure EmbedTo(AParent : TWinControl);
  end;

implementation

{$R *.dfm}

procedure TfrmAxis.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
end;

procedure TfrmAxis.FormShow(Sender: TObject);
begin
  elApplyLanguage(Self);
  ApplySkinColor('UserSkin', Self);
end;

procedure TfrmAxis.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

procedure TfrmAxis.FormDestroy(Sender: TObject);
begin
;
end;

procedure TfrmAxis.SetUp(AAxis: TfoCustomAxis; const ACaption, ACCWCaption, ACWCaption : string);
begin
  FAxis := AAxis;
  ledFault.ChannelLink.DataServer := HAL.IOServer;
  ledFault.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'FAULT';
  ledHoming.ChannelLink.DataServer := HAL.IOServer;
  ledHoming.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'HOMING';
  ledMoving.ChannelLink.DataServer := HAL.IOServer;
  ledMoving.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'MOVING';
  ledCWLimit.ChannelLink.DataServer := HAL.IOServer;
  ledCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CW';
  ledCCWLimit.ChannelLink.DataServer := HAL.IOServer;
  ledCCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CCW';
  FJogCaption := ACaption;
  FJogCWCaption := ACWCaption;
  FJogCCWCaption := ACCWCaption;
end;

procedure TfrmAxis.btnOriginClick(Sender: TObject);
begin
  FAxis.Origin(False);
end;

procedure TfrmAxis.btnReadyClick(Sender: TObject);
begin
  if asReady in FAxis.Status then
    FAxis.TrapezoidalMove(HAL.SysServer.AsDouble[FAxis.ChannelPrefix + 'READY_POS'], False);
end;

procedure TfrmAxis.btnJogClick(Sender: TObject);
begin
  ShowJogDialog(FAxis, FJogCaption, FJogCCWCaption, FJogCWCaption);
end;

procedure TfrmAxis.btnStopClick(Sender: TObject);
begin
  FAxis.Stop;
end;

procedure TfrmAxis.btnResetClick(Sender: TObject);
begin
  FAxis.Reset;
end;

procedure TfrmAxis.EmbedTo(AParent: TWinControl);
begin
  AParent.Visible := False;
  Self.BorderStyle := bsNone;
  Self.Parent := AParent;
  Self.Align := alClient;
  Self.Show;
  AParent.Visible := True;
end;

end.
