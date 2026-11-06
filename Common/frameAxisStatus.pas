unit frameAxisStatus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  foIndicator,
  foControls,
  foLED,

  foMotion;

type
  TAxisStatusFrame = class(TFrame)
    ledFault: TfoLED;
    ledMoving: TfoLED;
    ledCWLimit: TfoLED;
    ledCCWLimit: TfoLED;
    ledHome: TfoLED;
    omPos: TfoOdoMeter;
    ledInPos: TfoLED;
    ledServoOn: TfoLED;
  private
    FOnGetAxis: TNotifyEvent;
    FAxis: TfoCustomaxis;
    procedure SetAxis(const Value: TfoCustomaxis);
    { Private declarations }
  public
    { Public declarations }
    procedure GetAxis;
  published
    property Axis : TfoCustomaxis read FAxis write SetAxis;

    property OnGetAxis : TNotifyEvent read FOnGetAxis write FOnGetAxis;
  end;

implementation

{$R *.dfm}

{ TAxisStatusFrame }

procedure TAxisStatusFrame.GetAxis;
begin
  if Assigned(FOnGetAxis) then
    FOnGetAxis(Self);
end;

procedure TAxisStatusFrame.SetAxis(const Value: TfoCustomaxis);
begin
  if FAxis <> Value then
  begin
    ledFault.ChannelLink.DataServer := nil;
    ledServoOn.ChannelLink.DataServer := nil;
    ledMoving.ChannelLink.DataServer := nil;
    ledCWLimit.ChannelLink.DataServer := nil;
    ledCCWLimit.ChannelLink.DataServer := nil;
    ledInPos.ChannelLink.DataServer := nil;
    ledHome.ChannelLink.DataServer := nil;

    FAxis := Value;

    if FAxis <> nil then
    begin
      ledFault.ChannelLink.DataServer := FAxis.DataServer;
      ledFault.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'FAULT';
      ledServoOn.ChannelLink.DataServer := FAxis.DataServer;
      ledServoOn.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'SERVO_ON';
      ledMoving.ChannelLink.DataServer := FAxis.DataServer;
      ledMoving.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'MOVING';
      ledCWLimit.ChannelLink.DataServer := FAxis.DataServer;
      ledCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CW';
      ledCCWLimit.ChannelLink.DataServer := FAxis.DataServer;
      ledCCWLimit.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'CCW';
      ledInPos.ChannelLink.DataServer := FAxis.DataServer;
      ledInPos.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'IN_POSITION';
      ledHome.ChannelLink.DataServer := FAxis.DataServer;
      ledHome.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'HOME';
      omPos.ChannelLink.DataServer := FAxis.DataServer;
      omPos.ChannelLink.ChannelName := FAxis.ChannelPrefix + 'POSITION';
    end;
  end;
end;

end.
