unit uCommDeferredDevice;

interface

uses
  System.Classes, System.SysUtils, uCommBase;

type
  TQVIXDeferredCommDevice = class(TQVIXCommDevice)
  private
    FReason: string;
  public
    constructor CreateDeferred(AOwner: TComponent; const AReason: string);
    function Open: Boolean; override;
    procedure Close; override;
    function Send(const AData: TBytes): Boolean; override;
    property Reason: string read FReason;
  end;

implementation

procedure TQVIXDeferredCommDevice.Close;
begin
  SetState(qcsClosed, FReason);
end;

constructor TQVIXDeferredCommDevice.CreateDeferred(AOwner: TComponent;
  const AReason: string);
begin
  inherited Create(AOwner);
  FReason := AReason;
end;

function TQVIXDeferredCommDevice.Open: Boolean;
begin
  Result := False;
  SetState(qcsError, FReason);
end;

function TQVIXDeferredCommDevice.Send(const AData: TBytes): Boolean;
begin
  Result := False;
  SetState(qcsError, FReason);
end;

end.
