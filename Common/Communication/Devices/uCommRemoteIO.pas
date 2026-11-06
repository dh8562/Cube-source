unit uCommRemoteIO;

interface

uses
  System.Classes, uCommDeferredDevice;

type
  TQVIXRemoteIOComm = class(TQVIXDeferredCommDevice)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TQVIXRemoteIOComm.Create(AOwner: TComponent);
begin
  inherited CreateDeferred(AOwner,
    'Remote I/O mapping is not defined. Communication remains disabled.');
  Name := 'RemoteIOComm';
end;

end.
