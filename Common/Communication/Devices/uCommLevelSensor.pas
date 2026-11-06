unit uCommLevelSensor;

interface

uses
  System.Classes, uSerialDevice;

type
  TQVIXLevelSensorComm = class(TQVIXSerialDevice)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TQVIXLevelSensorComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'LevelSensorComm';
end;

end.
