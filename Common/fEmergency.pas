unit fEmergency;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,

  foControls,
  foLCD,

  dmHAL;

{$I uIOServer.inc}

type
  TfrmEmergency = class(TForm)
    liEmergency: TfoLCDLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmergency: TfrmEmergency;

implementation

{$R *.dfm}

procedure TfrmEmergency.FormCreate(Sender: TObject);
begin
  liEmergency.ChannelLink.DataServer := HAL.IOServer;
  liEmergency.ChannelLink.ChannelName := S_BLINK_EMG_STOP;
end;

procedure TfrmEmergency.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, 0)
end;

end.
