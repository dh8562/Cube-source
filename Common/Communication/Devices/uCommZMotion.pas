unit uCommZMotion;

interface

uses
  System.Classes, System.SysUtils, uSerialDevice;

type
  TQVIXZMotionStatusEvent = procedure(Sender: TObject;
    const APositionPulses: Integer; const AHome, AMinusLimit,
    APlusLimit, AAlarm, AMoving: Boolean) of object;

  TQVIXZMotionComm = class(TQVIXSerialDevice)
  private
    FResponse: AnsiString;
    FPositionPulses: Integer;
    FHome: Boolean;
    FMinusLimit: Boolean;
    FPlusLimit: Boolean;
    FAlarm: Boolean;
    FMoving: Boolean;
    FOnMotionStatus: TQVIXZMotionStatusEvent;
    procedure ParseLine(const ALine: string);
    function SendCommand(const ACommand: AnsiString): Boolean;
  protected
    procedure Received(Sender: TObject; const ACount: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    function HomeSearch: Boolean;
    function Jog(const APositive: Boolean): Boolean;
    function MoveAbsolute(const APulses: Integer): Boolean;
    function QueryInputs: Boolean;
    function QueryPosition: Boolean;
    function Stop: Boolean;
    property OnMotionStatus: TQVIXZMotionStatusEvent read FOnMotionStatus
      write FOnMotionStatus;
  end;

implementation

constructor TQVIXZMotionComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'ZMotionComm';
end;

function TQVIXZMotionComm.HomeSearch: Boolean;
begin
  Result := SendCommand('HOM X');
end;

function TQVIXZMotionComm.Jog(const APositive: Boolean): Boolean;
begin
  if APositive then
    Result := SendCommand('JOG X')
  else
    Result := SendCommand('JOG -X');
end;

function TQVIXZMotionComm.MoveAbsolute(const APulses: Integer): Boolean;
begin
  Result := SendCommand(AnsiString(Format('PAB %d', [APulses])));
end;

procedure TQVIXZMotionComm.ParseLine(const ALine: string);
var
  Text: string;
  P: Integer;
  ValueText: string;
  RawPosition: Cardinal;
  InputBits: Cardinal;
  ConnectorBits: Cardinal;
begin
  Text := Trim(ALine);
  if SameText(Copy(Text, 1, 3), 'POS') then
  begin
    ValueText := Trim(Copy(Text, 4, MaxInt));
    if TryStrToUInt('$' + ValueText, RawPosition) then
      FPositionPulses := Integer(RawPosition);
  end
  else if SameText(Copy(Text, 1, 3), 'INR') then
  begin
    ValueText := Trim(Copy(Text, 4, MaxInt));
    if (ValueText <> '') and (UpCase(ValueText[1]) = 'X') then
      Delete(ValueText, 1, 1);
    ValueText := Trim(ValueText);
    P := Pos(',', ValueText);
    if P > 0 then
    begin
      if TryStrToUInt('$' + Trim(Copy(ValueText, 1, P - 1)), InputBits) and
         TryStrToUInt('$' + Trim(Copy(ValueText, P + 1, MaxInt)),
           ConnectorBits) then
      begin
        FPlusLimit := (InputBits and $0010) <> 0;
        FMinusLimit := (InputBits and $0020) <> 0;
        FAlarm := (InputBits and $0040) <> 0;
        FMoving := (InputBits and $0100) <> 0;
        FHome := (ConnectorBits and $0001) <> 0;
      end;
    end;
  end;
  if Assigned(FOnMotionStatus) then
    FOnMotionStatus(Self, FPositionPulses, FHome, FMinusLimit,
      FPlusLimit, FAlarm, FMoving);
end;

function TQVIXZMotionComm.QueryInputs: Boolean;
begin
  Result := SendCommand('INR X');
end;

function TQVIXZMotionComm.QueryPosition: Boolean;
begin
  Result := SendCommand('POS');
end;

procedure TQVIXZMotionComm.Received(Sender: TObject;
  const ACount: Integer);
var
  Data: AnsiString;
  P: Integer;
  Line: string;
begin
  Data := Comm.ReadString;
  if Data = '' then
    Exit;
  LogFrame('RX', Data);
  FResponse := FResponse + Data;
  repeat
    P := Pos(#13, FResponse);
    if P = 0 then
      Break;
    Line := string(Copy(FResponse, 1, P - 1));
    Delete(FResponse, 1, P);
    if (FResponse <> '') and (FResponse[1] = #10) then
      Delete(FResponse, 1, 1);
    ParseLine(Line);
  until False;
end;

function TQVIXZMotionComm.SendCommand(
  const ACommand: AnsiString): Boolean;
var
  Data: TBytes;
  I: Integer;
begin
  SetLength(Data, Length(ACommand) + 1);
  for I := 1 to Length(ACommand) do
    Data[I - 1] := Byte(ACommand[I]);
  Data[High(Data)] := $0D;
  Result := Send(Data);
end;

function TQVIXZMotionComm.Stop: Boolean;
begin
  Result := SendCommand('STO X');
end;

end.
