unit uDTSModbusTcpDevice;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs,
  foModbusDevice, foModbusTcpDevice;

type
  TDTSModbusTcpDevice = class(TfoModbusTcpDevice)
  private
    FDirectBuffer: AnsiString;
    FDirectLock: TCriticalSection;
    FRequestStart: array[0..65535] of Word;
    FRequestQuantity: array[0..65535] of Word;
    FRequestValid: array[0..65535] of Boolean;
    FHoldingWords: array[0..65535] of Word;
    FHoldingValid: array[0..65535] of Boolean;
    procedure CaptureResponseFrames;
  protected
    function DoSendPacket(const APacketData: AnsiString): Boolean; override;
    procedure DoPacketReceived(const APacketData: AnsiString); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ReadHoldingWord(const AManualAddress: Integer;
      out AValue: Word): Boolean;
    procedure ClearHoldingWords;
  end;

implementation

function ReadBEWord(const AData: AnsiString; const AIndex: Integer): Word;
begin
  Result := (Word(Byte(AData[AIndex])) shl 8) or
    Word(Byte(AData[AIndex + 1]));
end;

constructor TDTSModbusTcpDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirectLock := TCriticalSection.Create;
  FDirectBuffer := '';
  FillChar(FRequestValid, SizeOf(FRequestValid), 0);
  FillChar(FHoldingValid, SizeOf(FHoldingValid), 0);
end;

destructor TDTSModbusTcpDevice.Destroy;
begin
  FDirectLock.Free;
  inherited Destroy;
end;

function TDTSModbusTcpDevice.DoSendPacket(
  const APacketData: AnsiString): Boolean;
var
  TransactionID: Word;
begin
  if (Length(APacketData) >= 12) and (Byte(APacketData[8]) = 3) then
  begin
    TransactionID := ReadBEWord(APacketData, 1);
    FDirectLock.Acquire;
    try
      // PDU carries the zero-based wire address. Convert it back to the
      // one-based 4xxxx address used by GMS DATA.xlsx and the project map.
      FRequestStart[TransactionID] := ReadBEWord(APacketData, 9) + 1;
      FRequestQuantity[TransactionID] := ReadBEWord(APacketData, 11);
      FRequestValid[TransactionID] := True;
    finally
      FDirectLock.Release;
    end;
  end;
  Result := inherited DoSendPacket(APacketData);
end;

procedure TDTSModbusTcpDevice.DoPacketReceived(
  const APacketData: AnsiString);
begin
  FDirectLock.Acquire;
  try
    FDirectBuffer := FDirectBuffer + APacketData;
    CaptureResponseFrames;
  finally
    FDirectLock.Release;
  end;
  inherited DoPacketReceived(APacketData);
end;

procedure TDTSModbusTcpDevice.CaptureResponseFrames;
var
  TransactionID, ProtocolID, DataLength, FrameLength: Word;
  ByteCount, WordCount, I: Integer;
  Frame: AnsiString;
  ManualAddress: Integer;
begin
  while Length(FDirectBuffer) >= 7 do
  begin
    TransactionID := ReadBEWord(FDirectBuffer, 1);
    ProtocolID := ReadBEWord(FDirectBuffer, 3);
    DataLength := ReadBEWord(FDirectBuffer, 5);
    if (ProtocolID <> 0) or (DataLength < 2) or (DataLength > 254) then
    begin
      Delete(FDirectBuffer, 1, 1);
      Continue;
    end;
    FrameLength := 6 + DataLength;
    if Length(FDirectBuffer) < FrameLength then Exit;
    Frame := Copy(FDirectBuffer, 1, FrameLength);
    Delete(FDirectBuffer, 1, FrameLength);

    if not FRequestValid[TransactionID] or
       (Length(Frame) < 9) or (Byte(Frame[8]) <> 3) then
      Continue;
    ByteCount := Byte(Frame[9]);
    WordCount := ByteCount div 2;
    if WordCount > FRequestQuantity[TransactionID] then
      WordCount := FRequestQuantity[TransactionID];
    if Length(Frame) < 9 + ByteCount then Continue;
    for I := 0 to WordCount - 1 do
    begin
      ManualAddress := FRequestStart[TransactionID] + I;
      if (ManualAddress >= 0) and (ManualAddress <= 65535) then
      begin
        FHoldingWords[ManualAddress] := ReadBEWord(Frame, 10 + I * 2);
        FHoldingValid[ManualAddress] := True;
      end;
    end;
    FRequestValid[TransactionID] := False;
  end;
end;

function TDTSModbusTcpDevice.ReadHoldingWord(const AManualAddress: Integer;
  out AValue: Word): Boolean;
begin
  Result := False;
  AValue := 0;
  if (AManualAddress < 0) or (AManualAddress > 65535) then Exit;
  FDirectLock.Acquire;
  try
    Result := FHoldingValid[AManualAddress];
    if Result then AValue := FHoldingWords[AManualAddress];
  finally
    FDirectLock.Release;
  end;
end;

procedure TDTSModbusTcpDevice.ClearHoldingWords;
begin
  FDirectLock.Acquire;
  try
    FillChar(FHoldingValid, SizeOf(FHoldingValid), 0);
    FDirectBuffer := '';
  finally
    FDirectLock.Release;
  end;
end;

end.
