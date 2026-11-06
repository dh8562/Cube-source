unit uCommSpectrometer;

interface

uses
  System.Classes, System.Math, System.SysUtils, uSerialDevice;

const
  QVIX_SPECTROMETER_NEW_PACKET_LENGTH = 1418;

type
  TQVIXDoubleArray = array of Double;
  TQVIXSpectrumEvent = procedure(Sender: TObject;
    const AWavelengths, AIntensities: TQVIXDoubleArray;
    const APeakWavelength, APeakIntensity: Double) of object;
  TQVIXSpectrometerCommand = (scIdle, scManualExposure, scSetExposure,
    scReadFrame);

  TQVIXSpectrometerComm = class(TQVIXSerialDevice)
  private
    FCommand: TQVIXSpectrometerCommand;
    FResponse: TBytes;
    FExposureMs: Integer;
    FInitialized: Boolean;
    FOnSpectrum: TQVIXSpectrumEvent;
    function BuildCommand(const APayload: array of Byte): TBytes;
    function HasTerminator: Boolean;
    function ParseSpectrum(const AFrame: TBytes): Boolean;
    procedure SendExposure;
  protected
    procedure Received(Sender: TObject; const ACount: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Close; override;
    function InitializeDevice(const AExposureMs: Integer): Boolean;
    function RequestSpectrum: Boolean;
    property Initialized: Boolean read FInitialized;
    property OnSpectrum: TQVIXSpectrumEvent read FOnSpectrum write FOnSpectrum;
  end;

implementation

function TQVIXSpectrometerComm.BuildCommand(
  const APayload: array of Byte): TBytes;
var
  I: Integer;
  Sum: Byte;
begin
  SetLength(Result, Length(APayload) + 5);
  Result[0] := $CC;
  Result[1] := $01;
  Sum := Result[0] + Result[1];
  for I := 0 to High(APayload) do
  begin
    Result[I + 2] := APayload[I];
    Sum := Sum + APayload[I];
  end;
  Result[Length(Result) - 3] := Sum;
  Result[Length(Result) - 2] := $0D;
  Result[Length(Result) - 1] := $0A;
end;

procedure TQVIXSpectrometerComm.Close;
begin
  FCommand := scIdle;
  FInitialized := False;
  SetLength(FResponse, 0);
  inherited Close;
end;

constructor TQVIXSpectrometerComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'SpectrometerComm';
  FCommand := scIdle;
  FExposureMs := 10;
end;

function TQVIXSpectrometerComm.HasTerminator: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to High(FResponse) do
    if (FResponse[I - 1] = $0D) and (FResponse[I] = $0A) then
      Exit(True);
end;

function TQVIXSpectrometerComm.InitializeDevice(
  const AExposureMs: Integer): Boolean;
begin
  Result := False;
  if not Comm.PortOpened then
    Exit;
  FExposureMs := Max(1, AExposureMs);
  FInitialized := False;
  SetLength(FResponse, 0);
  FCommand := scManualExposure;
  Result := Send(BuildCommand([$0A, $00, $00, $0A, $00]));
  if not Result then
    FCommand := scIdle;
end;

function TQVIXSpectrometerComm.ParseSpectrum(const AFrame: TBytes): Boolean;
var
  Coefficient: SmallInt;
  DataCount: Integer;
  I: Integer;
  Offset: Integer;
  Scale: Double;
  RawValue: Word;
  Waves: TQVIXDoubleArray;
  Values: TQVIXDoubleArray;
  PeakWave: Double;
  PeakValue: Double;
begin
  Result := False;
  if (Length(AFrame) < QVIX_SPECTROMETER_NEW_PACKET_LENGTH) or
     (AFrame[0] <> $CC) or (AFrame[1] <> $81) then
    Exit;

  DataCount := (AFrame[4] * $10000 + AFrame[3] * $100 + AFrame[2] - 16) div 2;
  if DataCount > 999 then
    DataCount := 999;
  if DataCount <= 0 then
    Exit;

  Coefficient := SmallInt(AFrame[10] or (AFrame[11] shl 8));
  if (Coefficient < -100) or (Coefficient > 100) then
    Exit;
  Scale := Power(10, Coefficient);
  if (Scale = 0) or IsNan(Scale) or IsInfinite(Scale) then
    Exit;

  Offset := 12;
  if Offset + DataCount * 2 > Length(AFrame) then
    Exit;
  SetLength(Waves, DataCount);
  SetLength(Values, DataCount);
  PeakWave := 340;
  PeakValue := 0;
  for I := 0 to DataCount - 1 do
  begin
    RawValue := AFrame[Offset + I * 2] or
      (AFrame[Offset + I * 2 + 1] shl 8);
    Waves[I] := 340 + I;
    Values[I] := RawValue / Scale;
    if Values[I] > PeakValue then
    begin
      PeakValue := Values[I];
      PeakWave := Waves[I];
    end;
  end;

  if Assigned(FOnSpectrum) then
    FOnSpectrum(Self, Waves, Values, PeakWave, PeakValue);
  Result := True;
end;

procedure TQVIXSpectrometerComm.Received(Sender: TObject;
  const ACount: Integer);
var
  Data: AnsiString;
  OldLength: Integer;
  I: Integer;
  Frame: TBytes;
begin
  Data := Comm.ReadString;
  if Data = '' then
    Exit;
  LogFrame('RX', Data);
  OldLength := Length(FResponse);
  SetLength(FResponse, OldLength + Length(Data));
  for I := 1 to Length(Data) do
    FResponse[OldLength + I - 1] := Byte(Data[I]);

  if FCommand = scReadFrame then
  begin
    if Length(FResponse) < QVIX_SPECTROMETER_NEW_PACKET_LENGTH then
      Exit;
    SetLength(Frame, QVIX_SPECTROMETER_NEW_PACKET_LENGTH);
    Move(FResponse[0], Frame[0], Length(Frame));
    ParseSpectrum(Frame);
    SetLength(FResponse, 0);
    FCommand := scIdle;
  end
  else if HasTerminator then
  begin
    SetLength(FResponse, 0);
    if FCommand = scManualExposure then
      SendExposure
    else if FCommand = scSetExposure then
    begin
      FCommand := scIdle;
      FInitialized := True;
    end
    else
      FCommand := scIdle;
  end;
end;

function TQVIXSpectrometerComm.RequestSpectrum: Boolean;
begin
  Result := False;
  if not Comm.PortOpened or not FInitialized or (FCommand <> scIdle) then
    Exit;
  SetLength(FResponse, 0);
  FCommand := scReadFrame;
  Result := Send(BuildCommand([$09, $00, $00, $02]));
  if not Result then
    FCommand := scIdle;
end;

procedure TQVIXSpectrometerComm.SendExposure;
var
  ExposureUs: Cardinal;
begin
  ExposureUs := Cardinal(FExposureMs) * 1000;
  FCommand := scSetExposure;
  if not Send(BuildCommand([$0D, $00, $00, $0C,
    Byte(ExposureUs), Byte(ExposureUs shr 8), Byte(ExposureUs shr 16),
    Byte(ExposureUs shr 24)])) then
    FCommand := scIdle;
end;

end.
