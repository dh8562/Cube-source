{@@
  MODBUS RTU 프로토콜
}
unit foModbusDevice;

interface

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs,
  System.Math,
  System.DateUtils,

  Codesitelogging,

  foSyncObjs,
  foTypes,
  foDataServer,
  foRTTIUtils,
  foBuffer,
  foStream,
  foBits,
  foLists,
  foStringUtils;

const
  MODBUS_MAX_SLAVE_ADDR = 99;

type
  EfoModbusDevice = class(Exception);

  TfoModbusSlaveAddr = 0..MODBUS_MAX_SLAVE_ADDR;

  TfoModbusFunctionCode = (
    mfcNone,
    mfcReadCoils,                    // 1, 1 Bit
    mfcReadDiscreteInputs,           // 2, 1 Bit
    mfcReadHoldingRegisters,         // 3, 16 Bits
    mfcReadInputRegister,            // 4, 16 Bits
    mfcWriteSingleCoil,              // 5, 1 Bit
    mfcWriteSingleRegister,          // 6, 16 Bits
    mfcWriteMultipleCoils,           // 15, 1 Bit
    mfcWriteMultipleRegisters        // 16, 16 Bits
  );

  TfoModbusMemory = (
    mmDiscreteInput,
    mmCoil,
    mmInputRegister,
    mmHoldingRegister
  );

const
  TfoModbusWordMemory : set of TfoModbusMemory = [
    mmInputRegister,
    mmHoldingRegister
  ];

  TfoModbusBitMemory : set of TfoModbusMemory = [
    mmDiscreteInput,
    mmCoil
  ];

type
  TDeviceMemory = record
    FMemory : array[TfoModbusMemory, 0..$FFFF] of Word;
  end;

type
  TfoModbusPacket = class(TCollectionItem)
  private
    FFunctionCode: TfoModbusFunctionCode;
    FGroupIndex: Integer;
    FName: string;
    FSlaveAddress: Byte;
    FData: AnsiString;
    FEnabled: Boolean;
    FQuantity: Word;
    FStartingAddress: Word;
    FExceptionCode: Byte;
    FLastResponse: AnsiString;
    FValues: TfoIntegerList;
  protected
  public
    constructor Create(Collection : TCollection); override;
    destructor  Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName : string; override;

    // 수신된 패킷에 오류 코드가 있는 경우
    property ExceptionCode : Byte read FExceptionCode write FExceptionCode;
    property LastResponse : AnsiString read FLastResponse write FLastResponse;

    property Values : TfoIntegerList read FValues write FValues;
  published
    property Data : AnsiString read FData write FData;

    property Enabled : Boolean read FEnabled write FEnabled default True;
    property GroupIndex : Integer read FGroupIndex write FGroupIndex default 0;
    property Name : string read FName write FName;

    {@@
      0이면 Broadcast
    }
    property SlaveAddress : Byte read FSlaveAddress write FSlaveAddress default 1;

    property FunctionCode : TfoModbusFunctionCode read FFunctionCode write FFunctionCode default mfcNone;
    property StartingAddress : Word read FStartingAddress write FStartingAddress;
    property Quantity : Word read FQuantity write FQuantity;
  end;

  TfoModbusPacketClass = class of TfoModbusPacket;

  TfoModbusPackets = class(TCollection)
  private
    Device : TfoCustomDevice;
    FActiveGroupIndex: Integer;
    function GetItem(Index: Integer): TfoModbusPacket;
    procedure SetItem(Index: Integer; Value: TfoModbusPacket);
    function GetActivePacketCount : Integer;
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ADevice : TfoCustomDevice; ItemClass : TfoModbusPacketClass);
    destructor Destroy; override;
    function GetOwner : TPersistent; override;

    function Add : TfoModbusPacket;

    function IsActivePacket(const AIndex : Integer) : Boolean;
    function FirstActive : Integer;
    function NextActive(const AIndex : Integer) : Integer;

    {@@
      패킷 설정을 파일에서 읽어 들인다.
    }
    procedure LoadFromFile(const FileName : string);

    {@@
      패킷 설정을 파일에 저장한다.
    }
    procedure SaveToFile(const FileName : string);

    {@@
      등록된 패킷 중 사용 가능한 패킷의 개수를 나타낸다.
    }
    property ActivePacketCount : Integer read GetActivePacketCount;

    {@@
      Summary:
      사용할 패킷 그룹 인덱스
      Description:
      등록된 여러가지 패킷 중 모니터링 등에서 사용할 그룹을 설정한다.
      모니터링 할 패킷이 많은 경우 패킷을 그룹으로 나누어서 필요한 패킷만 모니터링 할 수 있다.
      이 값이 -1 이면 모든 패킷을 사용한다.
    }
    property ActiveGroupIndex : Integer read FActiveGroupIndex write FActiveGroupIndex default -1;

    property Items[Index: Integer]: TfoModbusPacket read GetItem write SetItem; default;
  end;

  TfoModbusPacketSendEvent = procedure(Sender : TObject; const APacketData : AnsiString; var ASuccess : Boolean) of object;
  TfoModbusGetConnectedEvent = procedure(Sender : TObject; var AConnected : Boolean) of object;
  TfoModbusCommunicationError = procedure (Sender : TObject; const AErrorCode : Integer; const AErrorMsg : string) of object;

  TfoModbusDevice = class(TfoCustomDispatcherDevice)
  private
    { Private declarations }
    FBuffer : TfoBuffer;

    FDeviceMemory : array[0..MODBUS_MAX_SLAVE_ADDR] of TDeviceMemory;

    FPacketsToRead: TfoModbusPackets;
    FPacketsToWrite: TfoModbusPackets;

    FPacketBeforeSendDelay: Integer;
    FPacketAfterSendDelay: Integer;

    FTransactionFailCounts : array[0..255] of Integer;
    FTransactionStartedAt : TDateTime;

    FOnSendPacket: TfoModbusPacketSendEvent;
    FOnGetConnected: TfoModbusGetConnectedEvent;
    FOnCommunicationError: TfoModbusCommunicationError;
    FOnSlaveResponded: TNotifyEvent;
    FOnCheckPacketReceived: TNotifyEvent;

    procedure SetPacketsToRead(const Value: TfoModbusPackets);
    procedure SetPacketsToWrite(const Value: TfoModbusPackets);

    function DecodeResponsePacket(ASentPacket : TfoModbusPacket; const AResponse : AnsiString) : Boolean;

    function FetchReadResponse(const APacketIndex : Integer) : Boolean;
    function FetchWriteResponse(const APacketIndex : Integer) : Boolean;

    procedure FireError(const AErrorCode : Integer; const AMsg : string);

    function GetMemoryAsWord(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word) : Word;
    function GetMemoryAsLongWord(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word) : LongWord;
    function GetMemoryAsSmallInt(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word) : SmallInt;
    function GetMemoryAsInteger(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word) : Integer;

    procedure SetMemoryAsWord(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word; const AValue : Word);
    procedure SetMemoryAsLongWord(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word; const AValue : LongWord);
    procedure SetMemoryAsSmallInt(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word; const AValue : SmallInt);
    procedure SetMemoryAsInteger(const ASlaveAddr : TfoModbusSlaveAddr; const AMemory : TfoModbusMemory; const AAddress : Word; const AValue : Integer);
  protected
    { Protected declarations }
    procedure RaiseError(const AMsg : string);
    function DoInitialize : Boolean; override;
    function DoFinalize : Boolean; override;
    function DoGetDeviceType : TfoDeviceType; override;
    procedure DoMonitor; override;
    procedure DoChannelWrite(AChannel : TfoChannel; var AProcessed : Boolean); override;

    function EncodePacket(APacket : TfoModbusPacket) : AnsiString; virtual;

    procedure DoPacketBeforeSendDelay;
    procedure DoPacketAfterSendDelay;

    function DoSendPacket(const APacketData : AnsiString) : Boolean; virtual;
    procedure DoCheckPacketReceived; virtual;
    procedure DoPacketReceived(const APacketData : AnsiString); virtual;
    function ReceivedPacketAvailable : Boolean;
    function DoGetConnected : Boolean; virtual;
    procedure UpdateChannel;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    {@@
      시리얼이나 소켓에서 데이터를 수신하면 호출해 줘야 한다.
    }
    procedure PacketReceived(const AData : AnsiString);

    {@@
      쓰기 트랜잭션 추가
    }
    function AddWritePacket(const ASlaveAddress : Byte; const AFuncCode : TfoModbusFunctionCode; const AStartingAddress : Integer; const AQuantity : Integer) : TfoModbusPacket;

  published
    { Published declarations }
    property PacketAfterSendDelay : Integer read FPacketAfterSendDelay write FPacketAfterSendDelay default 10;
    property PacketBeforeSendDelay : Integer read FPacketBeforeSendDelay write FPacketBeforeSendDelay default 10;

    {@@
      읽기 트랜잭션에 사용할 패킷
    }
    property PacketsToRead : TfoModbusPackets read FPacketsToRead Write SetPacketsToRead;

    {@@
      쓰기 트랜잭션에 사용할 패킷
    }
    property PacketsToWrite : TfoModbusPackets read FPacketsToWrite Write SetPacketsToWrite;

    property OnSlaveResponded : TNotifyEvent read FOnSlaveResponded Write FOnSlaveResponded;
    property OnSendPacket : TfoModbusPacketSendEvent read FOnSendPacket write FOnSendPacket;
    property OnGetConnected : TfoModbusGetConnectedEvent read FOnGetConnected write FOnGetConnected;
    property OnCommunicationError : TfoModbusCommunicationError read FOnCommunicationError write FOnCommunicationError;
    property OnCheckPacketReceived : TNotifyEvent read FOnCheckPacketReceived write FOnCheckPacketReceived;
  end;

function foModbusFunctionCode(const ACode : Byte) : TfoModbusFunctionCode;

implementation

const
  // Table of CRC values for high?order byte
  CRCValueHi : array[0..255] of Byte = (
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40
  );

  // Table of CRC values for low?order byte
  CRCValueLo : array[0..255] of Byte = (
    $00, $C0, $C1, $01, $C3, $03, $02, $C2,
    $C6, $06, $07, $C7, $05, $C5, $C4, $04,
    $CC, $0C, $0D, $CD, $0F, $CF, $CE, $0E,
    $0A, $CA, $CB, $0B, $C9, $09, $08, $C8,
    $D8, $18, $19, $D9, $1B, $DB, $DA, $1A,
    $1E, $DE, $DF, $1F, $DD, $1D, $1C, $DC,
    $14, $D4, $D5, $15, $D7, $17, $16, $D6,
    $D2, $12, $13, $D3, $11, $D1, $D0, $10,
    $F0, $30, $31, $F1, $33, $F3, $F2, $32,
    $36, $F6, $F7, $37, $F5, $35, $34, $F4,
    $3C, $FC, $FD, $3D, $FF, $3F, $3E, $FE,
    $FA, $3A, $3B, $FB, $39, $F9, $F8, $38,
    $28, $E8, $E9, $29, $EB, $2B, $2A, $EA,
    $EE, $2E, $2F, $EF, $2D, $ED, $EC, $2C,
    $E4, $24, $25, $E5, $27, $E7, $E6, $26,
    $22, $E2, $E3, $23, $E1, $21, $20, $E0,
    $A0, $60, $61, $A1, $63, $A3, $A2, $62,
    $66, $A6, $A7, $67, $A5, $65, $64, $A4,
    $6C, $AC, $AD, $6D, $AF, $6F, $6E, $AE,
    $AA, $6A, $6B, $AB, $69, $A9, $A8, $68,
    $78, $B8, $B9, $79, $BB, $7B, $7A, $BA,
    $BE, $7E, $7F, $BF, $7D, $BD, $BC, $7C,
    $B4, $74, $75, $B5, $77, $B7, $B6, $76,
    $72, $B2, $B3, $73, $B1, $71, $70, $B0,
    $50, $90, $91, $51, $93, $53, $52, $92,
    $96, $56, $57, $97, $55, $95, $94, $54,
    $9C, $5C, $5D, $9D, $5F, $9F, $9E, $5E,
    $5A, $9A, $9B, $5B, $99, $59, $58, $98,
    $88, $48, $49, $89, $4B, $8B, $8A, $4A,
    $4E, $8E, $8F, $4F, $8D, $4D, $4C, $8C,
    $44, $84, $85, $45, $87, $47, $46, $86,
    $82, $42, $43, $83, $41, $81, $80, $40);

// Cyclical Redundancy Checking
function CRC16(AMsg: AnsiString): WORD;
var
  CRCHi : Byte;
  CRCLo : Byte;
  TableIndex, CharIndex : WORD;
  MsgLen : Integer;
begin
  CRCHi := $FF;
  CRCLo := $FF;
  CharIndex := 1;
  MsgLen := Length(AMsg);
  while MsgLen > 0 do
  begin
    TableIndex := CRCHi xor Byte(AMsg[CharIndex]);
    Inc(CharIndex);

    CRCHi := CRCLo xor CRCValueHi[TableIndex];
    CRCLo := CRCValueLo[TableIndex];

    Dec(MsgLen);
  end;
  Result := ((CRCHi shl 8) or CRCLo);
end;

const
  ModbusFunctionCodeValues : array[TfoModbusFunctionCode] of Byte = (
    00,
    01,
    02,
    03,
    04,
    05,
    06,
    15,
    16
  );

function foModbusFunctionCode(const ACode : Byte) : TfoModbusFunctionCode;
begin
  case ACode of
    1 : Result := mfcReadCoils;
    2 : Result := mfcReadDiscreteInputs;
    3 : Result := mfcReadHoldingRegisters;
    4 : Result := mfcReadInputRegister;
    5 : Result := mfcWriteSingleCoil;
    6 : Result := mfcWriteSingleRegister;
    15 : Result := mfcWriteMultipleCoils;
    16 : Result := mfcWriteMultipleRegisters;
    else
      Result := mfcNone;
  end;
end;

function FunctionCodeToMemory(const AFunctionCode : TfoModbusFunctionCode) : TfoModbusMemory;
begin
  case AFunctionCode of
    mfcReadCoils,
    mfcWriteSingleCoil,
    mfcWriteMultipleCoils:
      Result := mmCoil;

    mfcReadDiscreteInputs :
      Result := mmDiscreteInput;

    mfcReadHoldingRegisters :
      Result := mmHoldingRegister;

    mfcReadInputRegister :
      Result := mmInputRegister;

    mfcWriteSingleRegister,
    mfcWriteMultipleRegisters :
      Result := mmHoldingRegister;

    else
      Result := mmCoil;
  end;
end;


{ TfoModbusPacket }

procedure TfoModbusPacket.Assign(Source: TPersistent);
begin
  if Source is TfoModbusPacket then
  begin
    FFunctionCode := TfoModbusPacket(Source).FunctionCode;
    FGroupIndex := TfoModbusPacket(Source).GroupIndex;
    FName := TfoModbusPacket(Source).Name;
    FData := TfoModbusPacket(Source).Data;
    FSlaveAddress := TfoModbusPacket(Source).SlaveAddress;
    FEnabled := TfoModbusPacket(Source).Enabled;
    FStartingAddress := TfoModbusPacket(Source).StartingAddress;
    FQuantity := TfoModbusPacket(Source).Quantity;
  end
  else
    inherited Assign(Source);
end;

constructor TfoModbusPacket.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFunctionCode := mfcNone;
  FGroupIndex := 0;
  FName := '';
  FData := '';
  FSlaveAddress := 1;
  FEnabled := True;
  FStartingAddress := 0;
  FQuantity := 1;
  FValues := TfoIntegerList.Create;
end;

destructor TfoModbusPacket.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

function TfoModbusPacket.GetDisplayName: string;
begin
  if Length(FName) > 0 then
    Result := FName
  else
    Result := inherited GetDisplayName;
end;

{ TfoModbusPackets }

function TfoModbusPackets.Add: TfoModbusPacket;
begin
  Result := TfoModbusPacket(inherited Add);
end;

constructor TfoModbusPackets.Create(ADevice: TfoCustomDevice;
  ItemClass: TfoModbusPacketClass);
begin
  Device := ADevice;
  inherited Create(ItemClass);
  FActiveGroupIndex := -1;
end;

destructor TfoModbusPackets.Destroy;
begin
  inherited Destroy;
end;

function TfoModbusPackets.FirstActive: Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to Pred(Count) do
  begin
    if IsActivePacket(I) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TfoModbusPackets.GetActivePacketCount: Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Pred(Count) do
  begin
    if IsActivePacket(I) then
      Inc(Result);
  end;
end;

function TfoModbusPackets.GetItem(Index: Integer): TfoModbusPacket;
begin
  Result := TfoModbusPacket(inherited Items[Index]);
end;

function TfoModbusPackets.GetOwner: TPersistent;
begin
  Result := Device;
end;

function TfoModbusPackets.IsActivePacket(const AIndex: Integer): Boolean;
begin
  Result := False;
  if (AIndex >=0) and (AIndex < Count) then
  begin
    if Items[AIndex].Enabled and
       ((FActiveGroupIndex = -1) or
        (Items[AIndex].GroupIndex = FActiveGroupIndex)) then
      Result := True;
  end;
end;

procedure TfoModbusPackets.LoadFromFile(const FileName: string);
begin
  foCollectionFromXMLFile(Self, FileName);
end;

function TfoModbusPackets.NextActive(const AIndex: Integer): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := Succ(AIndex) to Pred(Count) do
  begin
    if IsActivePacket(I) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TfoModbusPackets.SaveToFile(const FileName: string);
begin
  foCollectionToXMLFile(Self, FileName);
end;

procedure TfoModbusPackets.SetItem(Index: Integer; Value: TfoModbusPacket);
begin
  Items[Index].Assign(Value);
end;

procedure TfoModbusPackets.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

{ TfoModbusDevice }

function TfoModbusDevice.AddWritePacket(const ASlaveAddress: Byte;
  const AFuncCode: TfoModbusFunctionCode; const AStartingAddress,
  AQuantity: Integer): TfoModbusPacket;
begin
  foLock;
  try
    Result := FPacketsToWrite.Add;
    with Result do
    begin
      SlaveAddress := ASlaveAddress;
      FunctionCode := AFuncCode;
      StartingAddress := AStartingAddress;
      //nValue := FDeviceMemory[ASlaveAddress].FMemory[FunctionCodeToMemory(AFuncCode)][AStartingAddress];
      //Codesite.SendFmtMsg('nValue=%d',[nValue]);
      Quantity := AQuantity;
    end;
  finally
    foUnlock;
  end;
end;

constructor TfoModbusDevice.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FPacketsToRead := TfoModbusPackets.Create(Self, TfoModbusPacket);
  FPacketsToWrite := TfoModbusPackets.Create(Self, TfoModbusPacket);
  FPacketAfterSendDelay := 10;
  FPacketBeforeSendDelay := 10;
  FBuffer := TfoBuffer.Create;

  FillChar(FDeviceMemory, SizeOf(FDeviceMemory), 0);

  for I := 0 to 255 do
  begin
    FTransactionFailCounts[I] := 0;
  end;
end;

function TfoModbusDevice.DecodeResponsePacket(ASentPacket: TfoModbusPacket;
  const AResponse: AnsiString): Boolean;
var
  PacketStream : TfoStream;
  FunctionCode : TfoModbusFunctionCode;
  SlaveAddr : Byte;
  FuncCode : Byte;
  ByteCount : Byte;
  WordCount : Byte;
  RemainCount : Integer;
  I : Integer;
  BitCheckIndex : Byte;
  AddressIndex : Integer;
  Addr : Word;
  ByteData : Byte;
  WordData : Word;
  nValue : Integer;
begin
  Result := False;

  PacketStream := TfoStream.Create;
  try
    // Modbus 는 Big Endian
    PacketStream.ByteOrder := sboBigEndian;
    PacketStream.WriteString(AResponse);
    PacketStream.Position := 0;


    // 최소 5바이트 이상이어야 함.

    // SlaveAddr(1) + FuncCode(1) + Data(n) + CRC16(2)
    // or
    // SlaveAddr(1) + FuncCode(1) + ErrorCode(1) + CRC16(2)
    if PacketStream.Size >= 5 then
    begin
      SlaveAddr := PacketStream.ReadByte;
      FuncCode := PacketStream.ReadByte;

      if FuncCode > $80 then
      begin
        // 에러가 발생한 경우
        ASentPacket.ExceptionCode := PacketStream.ReadByte;
        FireError(ASentPacket.ExceptionCode, Format('Slave Addr : %d, StartAddr : %d', [ASentPacket.SlaveAddress, ASentPacket.StartingAddress]));
      end
      else
      begin
        ByteCount := PacketStream.ReadByte;

        FunctionCode := foModbusFunctionCode(FuncCode);
        if FunctionCode = ASentPacket.FunctionCode then
        begin
          case FunctionCode of

            mfcReadCoils, mfcReadDiscreteInputs:
              begin

                RemainCount := PacketStream.Size - PacketStream.Position;
                if RemainCount >= ByteCount then
                begin
                  AddressIndex := 0;
                  for I := 0 to ByteCount - 1 do
                  begin
                    ByteData := PacketStream.ReadByte;

                    //        - Start Address
                    // 10110101
                    // 10110101
                    // 00000101

                    for BitCheckIndex := 0 to 7 do
                    begin
                      if SlaveAddr <= MODBUS_MAX_SLAVE_ADDR then
                      begin
                        Addr := ASentPacket.StartingAddress + AddressIndex;
                        nValue := Ord(foCheckBit(ByteData, BitCheckIndex));
                        Codesite.SendFmtMsg('DecodeResponsePacket : SlaveAddr=%d, FunctionCode=%d, Addr=%d Value=%d',[SlaveAddr, Ord(FunctionCode), Addr, nValue]);

                        FDeviceMemory[SlaveAddr].FMemory[FunctionCodeToMemory(FunctionCode)][Addr] := Ord(foCheckBit(ByteData, BitCheckIndex));
                      end;
                      Inc(AddressIndex);
                      if (AddressIndex > ASentPacket.Quantity) then
                        Break;
                    end;
                  end;

                  if Synchronize then
                    SynchronizeMethod(UpdateChannel)
                  else
                    UpdateChannel;
                end
                else
                begin
                  // TODO
                  FireError(0, '');
                end;
              end;

            mfcReadHoldingRegisters, mfcReadInputRegister:
              begin
                WordCount := ByteCount div 2;

                RemainCount := PacketStream.Size - PacketStream.Position;
                if RemainCount >= ByteCount then
                begin
                  AddressIndex := 0;
                  for I := 0 to WordCount - 1 do
                  begin
                    WordData := PacketStream.ReadWord;

                    if SlaveAddr <= MODBUS_MAX_SLAVE_ADDR then
                    begin
                      Addr := ASentPacket.StartingAddress + AddressIndex;
                      FDeviceMemory[SlaveAddr].FMemory[FunctionCodeToMemory(FunctionCode)][Addr] := WordData;
                    end;

                    Inc(AddressIndex);
                    if (AddressIndex > ASentPacket.Quantity) then
                      Break;
                  end;

                  if Synchronize then
                    SynchronizeMethod(UpdateChannel)
                  else
                    UpdateChannel;
                end
                else
                begin
                  // TODO
                  FireError(0, '');
                end;
              end;

            mfcWriteSingleCoil:
              begin
              end;

            mfcWriteSingleRegister:
              begin
              end;

            mfcWriteMultipleCoils:
              begin
              end;

            mfcWriteMultipleRegisters:
              begin
              end;

            else
            begin
            end;
          end;
        end;
      end;
    end;
  finally
    PacketStream.Free;
  end;
end;

destructor TfoModbusDevice.Destroy;
begin
  Enabled := False;

  FPacketsToRead.Free;
  FPacketsToWrite.Free;
  FBuffer.Free;
  inherited;
end;

procedure TfoModbusDevice.DoChannelWrite(AChannel: TfoChannel;
  var AProcessed: Boolean);
var
  SmallIntData : SmallInt;
  IntData : Integer;
begin
  if (csDesigning in ComponentState) or
     (csLoading in ComponentState) or
     (csReading in ComponentState) or
     (csDestroying in ComponentState) then Exit;

  with AChannel do
  begin
    if (BrowseInfo <> -1) and
       (Address <> -1) and
       (Address2 > 0) and
       (ChannelKind = ckOutput) and
       (Device = Self.Name) then
    begin
      if (Address2 < 0) or (Address2 > MODBUS_MAX_SLAVE_ADDR) then Exit;
      if (Address < 0) or (Address > $FFFF) then Exit;

      // 채널의 Address2를 SlaveAddress로 사용
      case DataType of
        dtBoolean :
          begin
            SetMemoryAsWord(Address2, TfoModbusMemory(BrowseInfo), Address, Word(Ord(AsBoolean)));

            if TfoModbusMemory(BrowseInfo) in TfoModbusWordMemory then
            begin
              AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
            end
            else
            begin
              AddWritePacket(Address2, mfcWriteSingleCoil, Address, 1);
            end;
          end;

        { 16 Bits }
        dtSmallInt :
          begin
            SetMemoryAsSmallInt(Address2, FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo)), Address, AsSmallInt);
            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1)
          end;

        { 32 Bits }
        dtInteger :
          begin
            SetMemoryAsInteger(Address2, TfoModbusMemory(BrowseInfo), Address, AsInteger);

            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
            AddWritePacket(Address2, mfcWriteSingleRegister, Succ(Address), 1);
          end;

        { 16 Bits }
        dtWord :
          begin
            SetMemoryAsWord(Address2, TfoModbusMemory(BrowseInfo), Address, AsWord);
            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
          end;

        { 32 Bits }
        dtLongWord :
          begin
            SetMemoryAsLongWord(Address2, TfoModbusMemory(BrowseInfo), Address, AsLongWord);

            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
            AddWritePacket(Address2, mfcWriteSingleRegister, Succ(Address), 1);
          end;

        dtSingle :
          begin
            SmallIntData := Trunc(AsSingle * IntPower(10, PrecisionDigits));
            SetMemoryAsSmallInt(Address2, TfoModbusMemory(BrowseInfo), Address, SmallIntData);

            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
          end;

        dtDouble :
          begin
            IntData := Trunc(AsDouble * IntPower(10, PrecisionDigits));
            SetMemoryAsInteger(Address2, TfoModbusMemory(BrowseInfo), Address, IntData);

            AddWritePacket(Address2, mfcWriteSingleRegister, Address, 1);
            AddWritePacket(Address2, mfcWriteSingleRegister, Succ(Address), 1);
          end;
      end;
      AProcessed := True;
    end;
  end;
end;

procedure TfoModbusDevice.DoCheckPacketReceived;
begin
  if Assigned(FOnCheckPacketReceived) then
    FOnCheckPacketReceived(Self);
end;

function TfoModbusDevice.DoFinalize: Boolean;
begin
  Result := inherited DoFinalize;

  FBuffer.Clear;
end;

function TfoModbusDevice.DoGetConnected: Boolean;
begin
  Result := False;
  if Assigned(FOnGetConnected) then
    FOnGetConnected(Self, Result);
end;

function TfoModbusDevice.DoGetDeviceType: TfoDeviceType;
begin
  Result := dtIntelligent;
end;

function TfoModbusDevice.DoInitialize: Boolean;
begin
  Result := inherited DoInitialize;
  FBuffer.Clear;
end;

procedure TfoModbusDevice.DoMonitor;
var
  szCmd : AnsiString;
  SlaveAddr : Integer;
begin
  if not Enabled then Exit;
  // 연결되어 있지 않으면 종료
  if not DoGetConnected then Exit;

  case PacketDispatchState of
    pdsIdle :
      begin
        if PacketDispatchMode = pdmRegular then
        begin
          if PacketsToWrite.ActivePacketCount > 0 then
          begin
            PacketDispatchState := pdsWriteRequest;
          end
          else if PacketsToRead.ActivePacketCount > 0 then
          begin
            PacketDispatchState := pdsReadRequest;
          end;
        end
        else
        begin
          if (PacketsToWrite.ActivePacketCount > 0) and (PacketsToRead.ActivePacketCount > 0) then
          begin
            if LastPacketDispatchState = pdsWriteRequest then
            begin
              PacketDispatchState := pdsReadRequest;
            end
            else
            begin
              PacketDispatchState := pdsWriteRequest;
            end;
          end
          else
          begin
            // pdmRegular와 같음
            if PacketsToWrite.ActivePacketCount > 0 then
            begin
              PacketDispatchState := pdsWriteRequest;
            end
            else if PacketsToRead.ActivePacketCount > 0 then
            begin
              PacketDispatchState := pdsReadRequest;
            end;
          end;
        end;
      end;

    pdsReadRequest :
      begin
        if not PacketsToRead.IsActivePacket(PacketIndexToRead) then
          PacketIndexToRead := PacketsToRead.FirstActive;

        if PacketsToRead.IsActivePacket(PacketIndexToRead) then
        begin
          FBuffer.Clear;

          szCmd := EncodePacket(PacketsToRead[PacketIndexToRead]);

          DoSendPacket(szCmd);
          if Assigned(OnLog) then OnLog(Self, string('W : ' + foHexifyString16(szCmd)));

          FTransactionStartedAt := Now;
          LastPacketDispatchState := PacketDispatchState;
          PacketDispatchState := pdsWaitReadResponse;
        end
        else
        begin
          PacketDispatchState := pdsIdle;
        end;
      end;

    pdsWaitReadResponse :
      begin
        if MilliSecondSpan(Now, FTransactionStartedAt) < TransactionTimeout then
        begin
          if PacketsToRead.IsActivePacket(PacketIndexToRead) then
          begin
            DoCheckPacketReceived;

            if ReceivedPacketAvailable then
            begin
              if FetchReadResponse(PacketIndexToRead) then
              begin
                if Assigned(OnSlaveResponded) then OnSlaveResponded(Self);

                SlaveAddr := PacketsToRead[PacketIndexToRead].SlaveAddress;
                FTransactionFailCounts[SlaveAddr] := 0;
                PacketDispatchState := pdsIdle;
                PacketIndexToRead := PacketsToRead.NextActive(PacketIndexToRead);
              end;
            end;
          end;
        end
        else
        begin
          if PacketsToRead.IsActivePacket(PacketIndexToRead) then
          begin
            SlaveAddr := PacketsToRead[PacketIndexToRead].SlaveAddress;
            FTransactionFailCounts[SlaveAddr] := FTransactionFailCounts[SlaveAddr] + 1;
            // Transaction이 10회 이상 실패하면 통신에 문제가 있는 것이다.
            if FTransactionFailCounts[SlaveAddr] > TransactionRetryCount then
            begin
              if Assigned(OnMaybeDead) then OnMaybeDead(Self);
              FillChar(FDeviceMemory[SlaveAddr].FMemory, SizeOf(FDeviceMemory[SlaveAddr].FMemory), 0);
              if Synchronize then SynchronizeMethod(UpdateChannel)
              else UpdateChannel;
              FTransactionFailCounts[SlaveAddr] := 0;
            end;
          end;

          PacketDispatchState := pdsIdle;
          PacketIndexToRead := PacketsToRead.NextActive(PacketIndexToRead);
        end;
      end;

    pdsWriteRequest :
      begin
        if (PacketsToWrite.ActivePacketCount > 0) then
        begin
          FBuffer.Clear;

          if PacketsToWrite.FirstActive <>-1 then
          begin
            szCmd := EncodePacket(PacketsToWrite[PacketsToWrite.FirstActive]);

            DoSendPacket(szCmd);

            if Assigned(OnLog) then OnLog(Self, string('W : ' + foHexifyString16(szCmd)));

            FTransactionStartedAt := Now;
            LastPacketDispatchState := PacketDispatchState;
            PacketDispatchState := pdsWaitWriteResponse;

            {$IFDEF SIMUL_MODE}
            FSimulTimer.Enabled := True;
            {$ENDIF}
          end
          else
            PacketDispatchState := pdsIdle;
        end
        else
          PacketDispatchState := pdsIdle;
      end;

    pdsWaitWriteResponse :
      begin
        if MilliSecondSpan(Now, FTransactionStartedAt) < TransactionTimeout then
        begin
          if PacketsToWrite.FirstActive <> -1 then
          begin
            DoCheckPacketReceived;

            if ReceivedPacketAvailable then
            begin
              if FetchWriteResponse(PacketsToWrite.FirstActive) then
              begin
                foLock;
                try
                  PacketsToWrite.Items[PacketsToWrite.FirstActive].Free;
                finally
                  foUnlock;
                end;
                TransactionFailCount := 0;
                PacketDispatchState := pdsIdle;
              end;
            end;
          end;
        end
        else
        begin
          TransactionFailCount := TransactionFailCount + 1;
          if TransactionFailCount > TransactionRetryCount then
          begin
            SlaveAddr := 0;
            if PacketsToWrite.FirstActive <> -1 then
              SlaveAddr := PacketsToWrite[PacketsToWrite.FirstActive].SlaveAddress;
            foLock;
            try
              PacketsToWrite.Clear;
            finally
              foUnlock;
            end;
            if Assigned(OnMaybeDead) then OnMaybeDead(Self);
            FillChar(FDeviceMemory[SlaveAddr].FMemory, SizeOf(FDeviceMemory[SlaveAddr].FMemory), 0);
            if Synchronize then SynchronizeMethod(UpdateChannel)
            else UpdateChannel;
            TransactionFailCount := 0;
          end;
          PacketDispatchState := pdsIdle;
        end;
      end;
  end;
end;

procedure TfoModbusDevice.DoPacketReceived(const APacketData: AnsiString);
begin
  FBuffer.Write(APacketData);
end;

function TfoModbusDevice.DoSendPacket(const APacketData: AnsiString): Boolean;
begin
  Result := False;

  DoPacketBeforeSendDelay;

  if Assigned(FOnSendPacket) then
    FOnSendPacket(Self, APacketData, Result);

  DoPacketAfterSendDelay;
end;

function TfoModbusDevice.EncodePacket(APacket: TfoModbusPacket): AnsiString;
var
  PacketStream : TfoStream;
  CRC : WORD;
  nValue : WORD;
begin
  PacketStream := TfoStream.Create;
  try
    // Modbus 는 Big Endian
    PacketStream.ByteOrder := sboBigEndian;

    case APacket.FunctionCode of
      mfcReadCoils, mfcReadDiscreteInputs:
        begin
          PacketStream.WriteByte(APacket.SlaveAddress);
          PacketStream.WriteByte(ModbusFunctionCodeValues[APacket.FunctionCode]);
          PacketStream.WriteWord(APacket.StartingAddress); // 0 to 65535($FFFF)
          PacketStream.WriteWord(APacket.Quantity);        // 1 to 2000($7D0)
        end;

      mfcReadHoldingRegisters, mfcReadInputRegister:
        begin
          PacketStream.WriteByte(APacket.SlaveAddress);
          PacketStream.WriteByte(ModbusFunctionCodeValues[APacket.FunctionCode]);
          PacketStream.WriteWord(APacket.StartingAddress); // 0 to 65535($FFFF)
          PacketStream.WriteWord(APacket.Quantity);        // 1 to 125($7D)
        end;

      mfcWriteSingleCoil:
        begin
          PacketStream.WriteByte(APacket.SlaveAddress);
          PacketStream.WriteByte(ModbusFunctionCodeValues[APacket.FunctionCode]);
          PacketStream.WriteWord(APacket.StartingAddress); // 0 to 65535($FFFF)

          if FDeviceMemory[APacket.SlaveAddress].FMemory[FunctionCodeToMemory(APacket.FunctionCode)][APacket.StartingAddress] > 0 then
            PacketStream.WriteWord($FF00) // $0000 or $FF00
          else
            PacketStream.WriteWord(0);
        end;

      mfcWriteSingleRegister:
        begin
          PacketStream.WriteByte(APacket.SlaveAddress);
          PacketStream.WriteByte(ModbusFunctionCodeValues[APacket.FunctionCode]);
          PacketStream.WriteWord(APacket.StartingAddress); // 0 to 65535($FFFF)

          nValue := FDeviceMemory[APacket.SlaveAddress].FMemory[FunctionCodeToMemory(APacket.FunctionCode)][APacket.StartingAddress];
          PacketStream.WriteWord(nValue);
        end;

      mfcWriteMultipleCoils:
        begin
        end;

      mfcWriteMultipleRegisters:
        begin
          PacketStream.WriteByte(APacket.SlaveAddress);
          PacketStream.WriteByte(ModbusFunctionCodeValues[APacket.FunctionCode]);
          PacketStream.WriteWord(APacket.StartingAddress); // 0 to 65535($FFFF)
          PacketStream.WriteWord(01);
          PacketStream.WriteByte(02);
          nValue := 300;	//StrToIntDef('$' + APacket.Data, 0);
          PacketStream.WriteWord(nValue);
        end;

      else
      begin
        Result := '';
      end;
    end;

    if PacketStream.Size > 0 then
    begin
      // CRC 추가
      PacketStream.Position := 0;
      CRC := CRC16(PacketStream.ReadString(PacketStream.Size));
      PacketStream.WriteWord(CRC);

      PacketStream.Position := 0;

      Result := PacketStream.ReadString(PacketStream.Size);
    end;
  finally
    PacketStream.Free;
  end;
end;

function TfoModbusDevice.FetchReadResponse(const APacketIndex: Integer) : Boolean;
var
  szResponse : AnsiString;
begin
  Result := False;

  if not Enabled then Exit;

  if (APacketIndex >= 0) and (APacketIndex < PacketsToRead.Count) then
  begin
    with PacketsToRead[APacketIndex] do
    begin
      szResponse := FBuffer.Read(FBuffer.Size);

      // 2025-08-10
      // 마지막으로 수신한 응답과 다를 경우에만 처리한다.
      //if AnsiCompareStr(LastResponse, szResponse) <> 0 then
      begin
        LastResponse := szResponse;

        if Assigned(OnLog) then OnLog(Self, string('R : ' + foHexifyString16(LastResponse)));
        DecodeResponsePacket(PacketsToRead[APacketIndex], szResponse);
        Result := True;
      //end
      //else
      //begin
        //if Assigned(OnLog) then OnLog(Self, string('R : ' + foHexifyString16(LastResponse)));
     //   Result := True;
      end;
    end;
  end;
end;

function TfoModbusDevice.FetchWriteResponse(const APacketIndex: Integer) : Boolean;
var
  szResponse : AnsiString;
begin
  Result := False;

  if not Enabled then Exit;

  if (APacketIndex >= 0) and (APacketIndex < PacketsToWrite.Count) then
  begin
    with PacketsToWrite[APacketIndex] do
    begin
      szResponse := FBuffer.Read(FBuffer.Size);
      if Assigned(OnLog) then OnLog(Self, string('R : ' + foHexifyString16(szResponse)));

      DecodeResponsePacket(PacketsToWrite[APacketIndex], szResponse);

      Result := True;
    end;
  end;
end;

procedure TfoModbusDevice.FireError(const AErrorCode: Integer; const AMsg : string);
var
  szError : string;
begin
  LastError := AErrorCode;

  if Assigned(OnCommunicationError) then
  begin
    case AErrorCode of
      $1 : szError := 'Function Code Error';
      $2 : szError := 'Variable Address Error';
      $3 : szError := 'Variable Data Error';
      $4 : szError := 'Operation Error';
    else
      szError := Format('Unknown Error (%d)', [AErrorCode]);
    end;
    OnCommunicationError(Self, AErrorCode, AMsg + ' ' + szError);
  end;
end;

function TfoModbusDevice.GetMemoryAsInteger(const ASlaveAddr : TfoModbusSlaveAddr;
  const AMemory : TfoModbusMemory; const AAddress : Word): Integer;
begin
  if AAddress < $FFFF then
    System.Move(FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], Result, SizeOf(Result));
end;

function TfoModbusDevice.GetMemoryAsLongWord(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress: Word): LongWord;
begin
  if AAddress < $FFFF then
    System.Move(FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], Result, SizeOf(Result));
end;

function TfoModbusDevice.GetMemoryAsSmallInt(const ASlaveAddr : TfoModbusSlaveAddr;
  const AMemory : TfoModbusMemory; const AAddress : Word): SmallInt;
begin
  System.Move(FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], Result, SizeOf(Result));
end;

function TfoModbusDevice.GetMemoryAsWord(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress: Word): Word;
begin
  Result := FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress];
end;

procedure TfoModbusDevice.DoPacketAfterSendDelay;
begin
  // 3.5 Char Delay
  Sleep(FPacketAfterSendDelay);
end;

procedure TfoModbusDevice.DoPacketBeforeSendDelay;
begin
  // 3.5 Char Delay
  Sleep(FPacketBeforeSendDelay);
end;

procedure TfoModbusDevice.PacketReceived(const AData: AnsiString);
begin
  DoPacketReceived(AData);
end;

procedure TfoModbusDevice.RaiseError(const AMsg: string);
begin
  raise EfoModbusDevice.Create(AMsg);
end;

function TfoModbusDevice.ReceivedPacketAvailable: Boolean;
var
  szResponse : AnsiString;
  PacketStream : TfoStream;
  FuncCode : Byte;
  ByteCount : Byte;
  RemainCount : Integer;
begin
  Result := False;

  // 최소 5바이트 이상이어야 함.

  // SlaveAddr(1) + FuncCode(1) + Data(n) + CRC16(2)
  // or
  // SlaveAddr(1) + FuncCode(1) + ErrorCode(1) + CRC16(2)
  if FBuffer.Size >= 5 then
  begin
    szResponse := FBuffer.Read(FBuffer.Size);

    PacketStream := TfoStream.Create;
    try
      // Modbus 는 Big Endian
      PacketStream.ByteOrder := sboBigEndian;
      PacketStream.WriteString(szResponse);
      PacketStream.Position := 0;

      // SlaveAddr(1) + FuncCode(1) + Data(n) + CRC16(2)
      // or
      // SlaveAddr(1) + FuncCode(1) + ErrorCode(1) + CRC16(2)
      PacketStream.ReadByte;
      FuncCode := PacketStream.ReadByte;

      if FuncCode > $80 then
      begin
        Result := True;
      end
      else
      begin
        if PacketDispatchState in [pdsWaitReadResponse] then
        begin
          ByteCount := PacketStream.ReadByte;
          RemainCount := PacketStream.Size - PacketStream.Position;
          if RemainCount >= ByteCount then
          begin
            Result := True;
          end;
        end
        else if PacketDispatchState in [pdsWaitWriteResponse] then
        begin
          Result := True;
        end;
      end;
    finally
      FreeAndNil(PacketStream);
    end;
  end;
end;

procedure TfoModbusDevice.SetMemoryAsLongWord(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress: Word;
  const AValue: LongWord);
begin
  if AAddress < $FFFF then
    System.Move(AValue, FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], SizeOf(AValue));
end;

procedure TfoModbusDevice.SetMemoryAsWord(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress: Word;
  const AValue: Word);
begin
  System.Move(AValue, FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], SizeOf(AValue));
end;

procedure TfoModbusDevice.SetMemoryAsInteger(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress : Word;
  const AValue: Integer);
begin
  if AAddress < $FFFF then
    System.Move(AValue, FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], SizeOf(AValue));
end;

procedure TfoModbusDevice.SetMemoryAsSmallInt(const ASlaveAddr: TfoModbusSlaveAddr;
  const AMemory: TfoModbusMemory; const AAddress: Word;
  const AValue: SmallInt);
begin
  System.Move(AValue, FDeviceMemory[ASlaveAddr].FMemory[AMemory][AAddress], SizeOf(AValue));
end;


procedure TfoModbusDevice.SetPacketsToRead(const Value: TfoModbusPackets);
begin
  FPacketsToRead.Assign(Value);
end;

procedure TfoModbusDevice.SetPacketsToWrite(const Value: TfoModbusPackets);
begin
  FPacketsToWrite.Assign(Value);
end;

procedure TfoModbusDevice.UpdateChannel;
var
  nIndex : Integer;
  TmpValue : Integer;
begin
  if not Enabled then Exit;
  if not Assigned(DataServer) then Exit;

  nIndex := 0;
  while nIndex < DataServer.Channels.Count do
  begin
    with DataServer.Channels[nIndex] do
    begin
      if Enabled and
         (Address <> -1) and
         (Address2 >= 0) and
         (BrowseInfo <> -1) and
         (ChannelKind <> ckOutput) and
         (Device = Self.Name) then
      begin
        if (Address2 < 0) or (Address2 > MODBUS_MAX_SLAVE_ADDR) then Exit;
        if (Address < 0) or (Address > $FFFF) then Exit;

        LockDeviceWrite := True;
        try
          case DataType of
            dtBoolean :
              begin
                AsBoolean := foCheckBit(GetMemoryAsWord(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address), Tag);
                //Codesite.SendFmtMsg('Address2=%d, BrowseInfo=%d, Address=%d, Tag=%d',[Address2, BrowseInfo, Address, Tag]);
              end;

            dtSmallInt :
              begin
                AsSmallint := GetMemoryAsSmallInt(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
//                Codesite.SendFmtMsg('Address2=%d, BrowseInfo=%d, Address=%d',[Address2, BrowseInfo, Address]);
              end;

            dtInteger :
              begin
                // 12345678인 경우
                // 00 : 5678
                // 01 : 1234 형식으로 저장된다.
                AsInteger := GetMemoryAsInteger(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
//                Codesite.SendFmtMsg('Address2=%d, BrowseInfo=%d, Address=%d',[Address2, BrowseInfo, Address]);
              end;

            dtWord :
              begin
                AsWord := GetMemoryAsWord(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
//                Codesite.SendFmtMsg('Address2=%d, BrowseInfo=%d, Address=%d',[Address2, BrowseInfo, Address]);
              end;

            dtLongWord :
              begin
                // 12345678인 경우
                // 00 : 5678
                // 01 : 1234 형식으로 저장된다.
                AsLongWord := GetMemoryAsLongWord(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
              end;

            dtSingle :
              begin
                TmpValue := GetMemoryAsSmallInt(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
                if PrecisionDigits <> 0 then
                  AsSingle := TmpValue / IntPower(10, PrecisionDigits)
                else
                  AsSingle := TmpValue;
              end;

            dtDouble :
              begin
                // 12345678인 경우
                // 00 : 5678
                // 01 : 1234 형식으로 저장된다.
                TmpValue := GetMemoryAsInteger(Address2,
                	TfoModbusMemory(FunctionCodeToMemory(TfoModbusFunctionCode(BrowseInfo))), Address);
                if PrecisionDigits <> 0 then
                  AsDouble := TmpValue / IntPower(10, PrecisionDigits)
                else
                  AsDouble := TmpValue;
              end;
          end;
        finally
          LockDeviceWrite := False;
        end;
      end;
    end;
    Inc(nIndex);
  end;
end;

end.
