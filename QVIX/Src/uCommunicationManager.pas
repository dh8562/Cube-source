unit uCommunicationManager;

interface

uses
  System.Classes, System.IniFiles, System.SysUtils, Vcl.Forms,
  uCommBase, uCommLevelSensor, uCommMFM, uCommPlasma, uCommRemoteIO,
  uCommSpectrometer, uCommWaterSensors, uCommZMotion;

type
  TQVIXCommunicationManager = class(TComponent)
  private
    FZMotion: TQVIXZMotionComm;
    FSpectrometer: TQVIXSpectrometerComm;
    FPlasma: TQVIXPlasmaComm;
    FWaterSensors: TQVIXWaterSensorsComm;
    FLevelSensor: TQVIXLevelSensorComm;
    FRemoteIO: TQVIXRemoteIOComm;
    FMFM: TQVIXMFMComm;
    function BaudFromIndex(const AIndex: Integer;
      const AModbusList: Boolean): Integer;
    function SettingsFileName: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadSettings;
    procedure CloseAll;
    property ZMotion: TQVIXZMotionComm read FZMotion;
    property Spectrometer: TQVIXSpectrometerComm read FSpectrometer;
    property Plasma: TQVIXPlasmaComm read FPlasma;
    property WaterSensors: TQVIXWaterSensorsComm read FWaterSensors;
    property LevelSensor: TQVIXLevelSensorComm read FLevelSensor;
    property RemoteIO: TQVIXRemoteIOComm read FRemoteIO;
    property MFM: TQVIXMFMComm read FMFM;
  end;

implementation

function TQVIXCommunicationManager.BaudFromIndex(const AIndex: Integer;
  const AModbusList: Boolean): Integer;
const
  SerialBaud: array[0..3] of Integer = (9600, 19200, 38400, 115200);
  ModbusBaud: array[0..4] of Integer = (4800, 9600, 19200, 38400, 115200);
begin
  if AModbusList then
  begin
    if (AIndex >= Low(ModbusBaud)) and (AIndex <= High(ModbusBaud)) then
      Result := ModbusBaud[AIndex]
    else
      Result := 9600;
  end
  else if (AIndex >= Low(SerialBaud)) and (AIndex <= High(SerialBaud)) then
    Result := SerialBaud[AIndex]
  else
    Result := 9600;
end;

procedure TQVIXCommunicationManager.CloseAll;
begin
  FZMotion.Close;
  FSpectrometer.Close;
  FPlasma.Close;
  FWaterSensors.Close;
  FLevelSensor.Close;
  FRemoteIO.Close;
  FMFM.Close;
end;

constructor TQVIXCommunicationManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZMotion := TQVIXZMotionComm.Create(Self);
  FSpectrometer := TQVIXSpectrometerComm.Create(Self);
  FPlasma := TQVIXPlasmaComm.Create(Self);
  FWaterSensors := TQVIXWaterSensorsComm.Create(Self);
  FLevelSensor := TQVIXLevelSensorComm.Create(Self);
  FRemoteIO := TQVIXRemoteIOComm.Create(Self);
  FMFM := TQVIXMFMComm.Create(Self);
  LoadSettings;
end;

procedure TQVIXCommunicationManager.LoadSettings;
var
  Ini: TIniFile;
  Config: TQVIXCommConfig;
begin
  Config.SlaveAddress := 1;
  Config.TimeoutMs := 300;
  Ini := TIniFile.Create(SettingsFileName);
  try
    Config.PortNo := Ini.ReadInteger('ZAxis', 'PortIndex', 0) + 1;
    Config.BaudRate := BaudFromIndex(
      Ini.ReadInteger('ZAxis', 'BaudIndex', 3), False);
    FZMotion.Configure(Config);

    Config.PortNo := Ini.ReadInteger('QOLS', 'PortIndex', 1) + 1;
    if Ini.ReadInteger('QOLS', 'KindIndex', 1) = 1 then
      Config.BaudRate := 256000
    else
      Config.BaudRate := BaudFromIndex(
        Ini.ReadInteger('QOLS', 'BaudIndex', 3), False);
    FSpectrometer.Configure(Config);

    Config.PortNo := Ini.ReadInteger('Communication',
      'PlasmaPortIndex', 5) + 1;
    Config.BaudRate := BaudFromIndex(Ini.ReadInteger('Communication',
      'PlasmaBaudIndex', 1), True);
    FPlasma.Configure(Config);
    FPlasma.ConfigurePolling;

    Config.PortNo := Ini.ReadInteger('Communication',
      'WaterBusPortIndex', 4) + 1;
    Config.BaudRate := BaudFromIndex(Ini.ReadInteger('Communication',
      'WaterBusBaudIndex', 1), True);
    Config.SlaveAddress := Ini.ReadInteger('Communication',
      'WaterBusSlaveAddress', 11);
    FWaterSensors.Configure(Config);
    FWaterSensors.ConfigurePolling(Ini.ReadString('Communication',
      'WaterBusSlaveIDs', IntToStr(Config.SlaveAddress)));

    Config.PortNo := Ini.ReadInteger('Communication',
      'LevelPortIndex', 0) + 1;
    Config.SlaveAddress := 1;
    Config.BaudRate := BaudFromIndex(Ini.ReadInteger('Communication',
      'LevelBaudIndex', 1), True);
    FLevelSensor.Configure(Config);
  finally
    Ini.Free;
  end;
end;

function TQVIXCommunicationManager.SettingsFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.settings.ini');
end;

end.
