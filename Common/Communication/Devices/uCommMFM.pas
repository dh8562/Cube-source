unit uCommMFM;

interface

uses
  System.Classes, uCommDeferredDevice;

type
  TQVIXMFMComm = class(TQVIXDeferredCommDevice)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TQVIXMFMComm.Create(AOwner: TComponent);
begin
  inherited CreateDeferred(AOwner,
    'MFM protocol is not defined. Communication remains disabled.');
  Name := 'MFMComm';
end;

end.
