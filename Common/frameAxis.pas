unit frameAxis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs,
  Menus,
  ImgList,
  StdCtrls,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,

  foMotion,
  foControls,
  foLED,
  foIndicator,

  fJog,
  uEquipment;

type
  TAxisFrame = class(TFrame)
    ledFault: TfoLED;
    ledHome: TfoLED;
    ledMoving: TfoLED;
    ledCWLimit: TfoLED;
    ledCCWLimit: TfoLED;
    btnOrigin: TcxButton;
    btnReady: TcxButton;
    btnStop: TcxButton;
    btnReset: TcxButton;
    btnJog: TcxButton;
    ilAxis: TcxImageList;
    omPos: TfoOdoMeter;
    ledServoOn: TfoLED;
    procedure btnOriginClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnReadyClick(Sender: TObject);
    procedure btnJogClick(Sender: TObject);
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
  end;

implementation

{$R *.dfm}

procedure TAxisFrame.btnJogClick(Sender: TObject);
begin
  ShowJogDialog(FAxis, FJogCaption, FJogCCWCaption, FJogCWCaption);
end;

procedure TAxisFrame.btnOriginClick(Sender: TObject);
begin
  if Assigned(FAxis) then
    FAxis.Origin(False);
end;

procedure TAxisFrame.btnReadyClick(Sender: TObject);
begin
  if asReady in FAxis.Status then
    FAxis.SCurveMove(Equipment.SysServer.AsDouble[FAxis.ChannelPrefix + 'READY_POS'], False);
end;

procedure TAxisFrame.btnResetClick(Sender: TObject);
begin
  if Assigned(FAxis) then
    FAxis.Reset;
end;

procedure TAxisFrame.btnStopClick(Sender: TObject);
begin
  if Assigned(FAxis) then
    FAxis.Stop;
end;

procedure TAxisFrame.SetUp(AAxis : TfoCustomAxis; const ACaption, ACCWCaption, ACWCaption : string);
begin
  if FAxis <> AAxis then
  begin
    ledFault.ChannelLink.DataServer := nil;
    ledMoving.ChannelLink.DataServer := nil;
    ledCWLimit.ChannelLink.DataServer := nil;
    ledCCWLimit.ChannelLink.DataServer := nil;
    ledHome.ChannelLink.DataServer := nil;
    ledServoOn.ChannelLink.DataServer := nil;
    omPos.ChannelLink.DataServer := nil;

    FAxis := AAxis;

    if FAxis <> nil then
    begin
      ledFault.ChannelLink.DataServer := FAxis.DataServer;
      ledFault.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'FAULT';
      ledMoving.ChannelLink.DataServer := FAxis.DataServer;
      ledMoving.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'MOVING';
      ledCWLimit.ChannelLink.DataServer := FAxis.DataServer;
      ledCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CW';
      ledCCWLimit.ChannelLink.DataServer := FAxis.DataServer;
      ledCCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CCW';
      ledHome.ChannelLink.DataServer := FAxis.DataServer;
      ledHome.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'HOME';
      ledServoOn.ChannelLink.DataServer := FAxis.DataServer;
      ledServoOn.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'SERVO_ON';
      omPos.ChannelLink.DataServer := FAxis.DataServer;
      omPos.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'POSITION';
    end;
  end;

  FJogCaption := ACaption;
  FJogCWCaption := ACWCaption;
  FJogCCWCaption := ACCWCaption;
end;

end.
