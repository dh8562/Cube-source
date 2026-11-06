unit uCommStageController;

interface

uses
  System.Classes, System.SysUtils, uSerialDevice;

type
  TQRoBOTStageStatusEvent = procedure(Sender: TObject;
    const AX, AY, AZ: Double; const ARunning, AHomed, AComplete: Boolean;
    const AErrorCode, AMessage: string) of object;

  TQRoBOTStageComm = class(TQVIXSerialDevice)
  private
    FBuffer: AnsiString;
    FX: Double;
    FY: Double;
    FZ: Double;
    FRunning: Boolean;
    FHomed: Boolean;
    FComplete: Boolean;
    FErrorCode: string;
    FOnStageStatus: TQRoBOTStageStatusEvent;
    function CommandFrame(const ACommand: Byte): TBytes;
    procedure NotifyStageStatus(const AMessage: string);
    procedure ParseFrame(const AFrame: AnsiString);
    function SendCommand(const ACommand: Byte): Boolean;
  protected
    procedure Received(Sender: TObject; const ACount: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    function HomeAll: Boolean;
    function QueryCoordinates: Boolean;
    function StartCurrentRecipe: Boolean;
    function Stop: Boolean;
    property OnStageStatus: TQRoBOTStageStatusEvent read FOnStageStatus
      write FOnStageStatus;
  end;

implementation

function TQRoBOTStageComm.CommandFrame(const ACommand: Byte): TBytes;
begin
  SetLength(Result, 6);
  Result[0] := $AA;
  Result[1] := $FF;
  Result[2] := $55;
  Result[3] := ACommand;
  Result[4] := $0D;
  Result[5] := $0A;
end;

constructor TQRoBOTStageComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'StageControllerComm';
end;

function TQRoBOTStageComm.HomeAll: Boolean;
begin
  FComplete := False;
  Result := SendCommand($07);
end;

procedure TQRoBOTStageComm.NotifyStageStatus(const AMessage: string);
begin
  if Assigned(FOnStageStatus) then
    FOnStageStatus(Self, FX, FY, FZ, FRunning, FHomed, FComplete,
      FErrorCode, AMessage);
end;

procedure TQRoBOTStageComm.ParseFrame(const AFrame: AnsiString);
var
  Command: Byte;
  Payload: string;
  PX, PY, PZ: Integer;
  XText, YText, ZText: string;
begin
  if (Length(AFrame) < 4) or (Byte(AFrame[1]) <> $AA) or
     (Byte(AFrame[2]) <> $FF) or (Byte(AFrame[3]) <> $55) then
    Exit;
  Command := Byte(AFrame[4]);
  Payload := string(Copy(AFrame, 5, Length(AFrame) - 4));
  case Command of
    $04:
      begin
        FRunning := True;
        FComplete := False;
        NotifyStageStatus('Recipe started');
      end;
    $05:
      begin
        FRunning := False;
        NotifyStageStatus('Stage stopped');
      end;
    $07, $13:
      begin
        FRunning := False;
        FHomed := True;
        NotifyStageStatus('All axes homed');
      end;
    $15:
      begin
        FRunning := False;
        FComplete := True;
        NotifyStageStatus('Position reached');
      end;
    $18:
      begin
        if (Length(Payload) > 0) and (Byte(Payload[1]) = $01) then
          FRunning := True
        else if (Length(Payload) > 0) and (Byte(Payload[1]) = $02) then
          FRunning := False;
        NotifyStageStatus('Operating status received');
      end;
    $60:
      begin
        PX := Pos('x', Payload);
        PY := Pos('y', Payload);
        PZ := Pos('z', Payload);
        if (PX > 0) and (PY > PX) and (PZ > PY) then
        begin
          XText := Copy(Payload, PX + 1, PY - PX - 1);
          YText := Copy(Payload, PY + 1, PZ - PY - 1);
          ZText := Copy(Payload, PZ + 1, MaxInt);
          if Pos('U', ZText) > 0 then
            ZText := Copy(ZText, 1, Pos('U', ZText) - 1);
          TryStrToFloat(XText, FX);
          TryStrToFloat(YText, FY);
          TryStrToFloat(ZText, FZ);
          NotifyStageStatus('Coordinates updated');
        end;
      end;
  end;
end;

function TQRoBOTStageComm.QueryCoordinates: Boolean;
var
  Data: TBytes;
begin
  SetLength(Data, 7);
  Data[0] := $AA;
  Data[1] := $FF;
  Data[2] := $55;
  Data[3] := $06;
  Data[4] := $60;
  Data[5] := $0D;
  Data[6] := $0A;
  Result := Send(Data);
end;

procedure TQRoBOTStageComm.Received(Sender: TObject; const ACount: Integer);
var
  Data: AnsiString;
  P: Integer;
  Frame: AnsiString;
begin
  Data := Comm.ReadString;
  if Data = '' then
    Exit;
  LogFrame('RX', Data);
  FBuffer := FBuffer + Data;
  repeat
    P := Pos(#13#10, FBuffer);
    if P = 0 then
      Break;
    Frame := Copy(FBuffer, 1, P - 1);
    Delete(FBuffer, 1, P + 1);
    ParseFrame(Frame);
  until False;
end;

function TQRoBOTStageComm.SendCommand(const ACommand: Byte): Boolean;
begin
  Result := Send(CommandFrame(ACommand));
end;

function TQRoBOTStageComm.StartCurrentRecipe: Boolean;
begin
  FComplete := False;
  Result := SendCommand($04);
end;

function TQRoBOTStageComm.Stop: Boolean;
begin
  Result := SendCommand($05);
end;

end.
