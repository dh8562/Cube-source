unit dmData;

interface

uses
  Windows, Messages, System.SysUtils, System.Classes, System.Actions, Vcl.ActnList, IniFiles, Forms,

  Controls,
  ShellAPI,
  math,
  elPropSaver,
  elBase,
  elMultiLanguage,

  SyncObjs,

  Codesitelogging,

  foStringUtils,
  foCommEx,
  foStream,
  foTimeCounter
;

const
  PACKET_LENGTH = 1338;
  PACKET_LENGTH2 = 1418;

  MAX_DATA_COUNT   = 10000;
  MAX_PEAK_LIST_COUNT = 10;
  MAX_PEAK_DATA_COUNT = 100;
  MAX_ALARM_LIST_COUNT = 100;

  MAX_AVERAGE_COUNT = 100;
  MAX_SPECTROMETER_COUNT = 10;

  UM_BASE = WM_USER;
  UM_UPDATE_GRAPH_CHANGED = UM_BASE + 101;

  SPECTROMETER_KIND_OLD = 0;
  SPECTROMETER_KIND_NEW = 1;
  SPECTROMETER_KIND_QMINI = 2;

const
  MSG_INITIALIZE          = 1001;
  MSG_FINALIZE            = 1002;
  MSG_SET_EXPOSURE        = 1003;
  MSG_GET_EXPOSURE        = 1004;
  MSG_GET_PIXEL_COUNT     = 1005;
  MSG_GET_WAVELENGTHS		  = 1006;
  MSG_GET_INTENSITIES		  = 1007;
  MSG_START_EXPOSURE		  = 1008;
  MSG_WAIT_EXPOSURE_DONE	= 1009;



type
  TCommandState = (csNone, csSingleFrame, csStartFrame, csStopFrame, csAutoExposure, csManualExposure, csSetExposure);

  TPeakItem = record
    bUse : Boolean;
    szName : String;
    nStartWavelength : Integer;
    nEndWavelength : Integer;
    nStartIntensity : Double;
    nEndIntensity : Double;
    nColor : Integer;

    //
    dIntensity : Double;
    dTime : Double;
    bResult : Boolean;
  end;

  TAlarmItem = record
    szName : String;
    szTime : String;
    dIntensity : Double;
  end;

  TPeakData = record
    dTime : Double;
    dValue : Double;
  end;



  TData = class(TDataModule)
    MultiLang: TelMultiLanguage;
    PropSaver: TelPropSaver;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

    FSystemNo : Integer;
    FLanguages : Integer;
    FExposure: Integer;

    FResponsePacket : AnsiString;
    FReadStream : TfoStream;

    FCommandState : TCommandState;
    FSpecWavelengthMin: Integer;
    FSpecWavelengthMax: Integer;
    FSpecIntensityMin: Double;
    FSpecIntensityMax: Double;
    FComPortNo: Integer;
    FAlarmTimeSet: Integer;
    FReadTime: Integer;
    FSpectrometerKind: Integer;
    FIntensityFactor: Double;
    FIFComPortNo: Integer;
    FUseIF: Integer;
    FIFCommKind: Integer;
    FMeasMethod: Integer;
    FAverageCount: Integer;
    FIntensityArray : array [0..MAX_PEAK_LIST_COUNT-1, 0..MAX_AVERAGE_COUNT-1] of Double;
    FIntensityNo : array [0..MAX_PEAK_LIST_COUNT-1] of Integer;
    FAverageIntersity : array [0..MAX_PEAK_LIST_COUNT-1] of Boolean;
    FAreaIntensityFactor: Double;
    FLEDLightValue: Integer;
    FAlarmMode: Integer;
    FDeviceIndex: Integer;
    FDeviceName: String;
    FAlarmActive: Boolean;
    FLastRequestTick: Cardinal;
    FApplyExposureAfterMode: Boolean;

    { Private declarations }
  public
    FCOMM : TfoCommEx;
    FIFCOMM : TfoCommEx;

    FDataCount : Integer;
    FWAVE : array [0..MAX_DATA_COUNT] of Double;
    FDATA : array [0..MAX_DATA_COUNT] of Double;
    FPeakWaveLength : Double;
    FPeakIntensity : Double;
    FPekaResult : Boolean;

    FStartMeas : Boolean;
    FMeasTimeer : TfoTimeCounter;

    FFaultTimeer : TfoTimeCounter;
    FFaultMeasString : Boolean;

    FPeakListCount : Integer;
    FPeakList : array [0..MAX_PEAK_LIST_COUNT-1] of TPeakItem;

    FAlarmListCount : Integer;
    FAlarmList : array [0.. MAX_ALARM_LIST_COUNT-1] of TAlarmItem;

    FPeakDataCount : Integer;
    FPeakData : array [0..MAX_PEAK_LIST_COUNT-1, 0..MAX_PEAK_DATA_COUNT] of TPeakData;

    procedure foSendMessage(AControl : TWinControl; Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False; const ATimeout : Integer = 1000);
    procedure foBroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False; const ATimeout : Integer = 1000);
    procedure BroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False);

    procedure LoadSetting;
    procedure SaveSetting;
    procedure CopySettingsFrom(ASource: TData);

    function CheckSum(AMsg: AnsiString): Byte;
    function SendCommand(szCommand : AnsiString) : Boolean;

    function OpenComm : Boolean;
    function CloseComm : Boolean;
    function ReadSingleFrame : Boolean;
    function StartContData : Boolean;
    function StopContData : Boolean;
    function SetManualExposureMode : Boolean;
    function SetAutoExposureMode : Boolean;
    function SetExposure(AValue : Integer) : Boolean;
    procedure ApplyCommunicationSettings;
    procedure RecoverTimedOutRequest(const ATimeout: Cardinal);

    procedure AddPeakList(APeakItem : TPeakItem);
    procedure EditPeakList(AIndex : Integer; APeakItem : TPeakItem);
    procedure DeletePeakList(AIndex : Integer);

    procedure AddAlarmList(AAlarmItem : TAlarmItem);
    procedure DeleteAlarmList(AIndex : Integer);
    procedure DeleteAllAlarmList;

    procedure WriteIFComm(AOnOff : Boolean);

    procedure WriteTowerLampOff;
    procedure WriteTowerLampYellow;
    procedure WriteTowerLampGreen;
    procedure WriteTowerLampRed;

    function SendToRgbServer(const ACommand : Integer; const Param: AnsiString) : Boolean;


    procedure ClearPeakData;
    procedure AddPeakData(AIndex : Integer; ATime : Double; AValue : Double);
    procedure SavePeakData(AFileName : String);

    procedure OnReceived(Sender: TObject; const ACount: Integer);
    procedure OnEventCharReceived(Sender: TObject; const ACount: Integer);
    function ReciveParse : Boolean;
    function ParseFrameData : Boolean;
    function ParseFrameData2 : Boolean;

    function MeasPeak : Boolean;

    property SpectrometerKind : Integer read FSpectrometerKind write FSpectrometerKind;
    property MeasMethod : Integer read FMeasMethod write FMeasMethod;
    property SystemNo : Integer read FSystemNo write FSystemNo;
    property Languages : Integer read FLanguages write FLanguages;
    property ComPortNo : Integer read FComPortNo write FComPortNo;
    property IFCommKind : Integer read FIFCommKind write FIFCommKind;
    property IFComPortNo : Integer read FIFComPortNo write FIFComPortNo;
    property UseIF : Integer read FUseIF write FUseIF;
    property AlarmMode : Integer read FAlarmMode write FAlarmMode;
    property Exposure : Integer read FExposure write FExposure;
    property ReadTime : Integer read FReadTime write FReadTime;
    property IntensityFactor : Double read FIntensityFactor write FIntensityFactor;
    property AreaIntensityFactor : Double read FAreaIntensityFactor write FAreaIntensityFactor;
    property AverageCount : Integer read FAverageCount write FAverageCount;
    property LEDLightValue : Integer read FLEDLightValue write FLEDLightValue;


    property AlarmTimeSet : Integer read FAlarmTimeSet write FAlarmTimeSet;
    property DeviceIndex : Integer read FDeviceIndex write FDeviceIndex;
    property DeviceName : String read FDeviceName write FDeviceName;
    property AlarmActive : Boolean read FAlarmActive write FAlarmActive;
    property SpecWavelengthMin : Integer read FSpecWavelengthMin write FSpecWavelengthMin;
    property SpecWavelengthMax : Integer read FSpecWavelengthMax write FSpecWavelengthMax;

    property SpecIntensityMin : Double read FSpecIntensityMin write FSpecIntensityMin;
    property SpecIntensityMax : Double read FSpecIntensityMax write FSpecIntensityMax;

  end;

var
  Data: TData;
  Spectrometers: array [0..MAX_SPECTROMETER_COUNT-1] of TData;
  SpectrometerCount: Integer = 1;
  SelectedSpectrometer: Integer = 0;
  LogLevel: Integer = 1;

procedure InitializeSpectrometers;
procedure FinalizeSpectrometers;
procedure SetSpectrometerCount(const ACount: Integer);
function GetSpectrometer(const AIndex: Integer): TData;
function CurrentSpectrometer: TData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TData.OnEventCharReceived(Sender: TObject; const ACount: Integer);
var
  nLen : Integer;
  szRead, szTemp : AnsiString;
  szHexData : AnsiString;
  nPacketLen : Integer;
  bFrameCompleted: Boolean;
begin
  bFrameCompleted := False;
  if (FCommandState = csSingleFrame) or (FCommandState = csStartFrame) then
  begin
    szRead := FCOMM.ReadString;
    FResponsePacket := FResponsePacket + szRead;

    nLen := Length(FResponsePacket);

    case SpectrometerKind of
      SPECTROMETER_KIND_OLD : nPacketLen := PACKET_LENGTH;
      SPECTROMETER_KIND_NEW : nPacketLen := PACKET_LENGTH2;
    else
      nPacketLen := 0;
    end;

    if (nPacketLen > 0) and (nLen >= nPacketLen) then
    begin
      szTemp := Copy(FResponsePacket, 1, nPacketLen);

      Delete(FResponsePacket, 1, nPacketLen);
      FReadStream.WriteString(szTemp);
      if (Length(szTemp) >= 2) and
         (szTemp[Length(szTemp)-1] = #13) and
         (szTemp[Length(szTemp)] = #10) then
      begin
        bFrameCompleted := ReciveParse;
        szHexData := foHexifyString16(szTemp);
        if LogLevel >= 10 then
          CodeSite.SendFmtMsg('[SPEC %d][%s] OnEventCharReceived [%d] [%s]',
            [FDeviceIndex + 1, FDeviceName, nLen, szHexData]);
      end
      else
      begin
        szHexData := foHexifyString16(szTemp);
        if LogLevel >= 10 then
          CodeSite.SendFmtMsg('[SPEC %d][%s] OnEventCharReceived [%d] [%s]',
            [FDeviceIndex + 1, FDeviceName, nLen, szHexData]);
        Sleep(100);
        FCOMM.ClearBuffer;
        FResponsePacket := '';
        bFrameCompleted := True;
      end;
    end;
  end
  else
  begin
    Sleep(100);
    szTemp := FCOMM.ReadString;
    nLen := Length(szTemp);
    szHexData := foHexifyString16(szTemp);
    if LogLevel >= 10 then
      CodeSite.SendFmtMsg('[SPEC %d][%s] OnEventCharReceived [%d] [%s]',
        [FDeviceIndex + 1, FDeviceName, nLen, szHexData]);
    bFrameCompleted := True;
  end;
  if bFrameCompleted then
  begin
    FStartMeas := False;
    // Configuration commands must be serialized.  Sending SetExposure before
    // the manual-mode response is consumed can leave the port/request state
    // out of sync after a settings reload.
    if (FCommandState = csManualExposure) and FApplyExposureAfterMode then
    begin
      FApplyExposureAfterMode := False;
      if not SetExposure(FExposure) then
      begin
        FStartMeas := False;
        FCommandState := csNone;
      end;
    end
    else
      FCommandState := csNone;
  end;

end;

procedure TData.OnReceived(Sender: TObject; const ACount: Integer);
begin
  //CodeSite.Send('OnReceived...');
end;

function TData.ParseFrameData : Boolean;
var
  I : Integer;
  nData : Integer;
  nByte1 : Byte;
  nByte2 : Byte;
  nByte3 : Byte;
  nByte4 : Byte;
  dValue : Double;

  nTotalDataLen, nDataLen : Integer;
  nExposureStatus : Byte;
  nCurrExposure : UInt32;
  nCoefficient : SmallInt;
  nTemp : Integer;
  dTemp1, dTemp2 : Double;
  nPacketLen : Integer;
  dSingle : Single;
begin
  Result := False;
  nPacketLen := PACKET_LENGTH;

  if FReadStream.Size = nPacketLen then
  begin
    FReadStream.Position := 0;
    nByte1 := FReadStream.ReadByte;
    nByte2 := FReadStream.ReadByte;

    //2 Byte : Command header identification
    if (nByte1 = $CC) and (nByte2 = $81) then
    begin
      //Total Packet Length
      //3 Byte : General Contractor(Unit :byte) = 9 + 1 + 4 +2+Spectral Data Length
      nByte1 := FReadStream.ReadByte;
      nByte2 := FReadStream.ReadByte;
      nByte3 := FReadStream.ReadByte;
      nTotalDataLen := (nByte3 * $10000) + (nByte2 * $100) + nByte1;

      nDataLen := (nTotalDataLen - 16) div 2;

      //1 Byte : Command Type
      nByte1 := FReadStream.ReadByte;
      //[Returned data]
      // 1 Byte : exposure status (1byte) +
      //          Exposure state(uint8)： 0x00--Normal；0x01--Overexposure；0x02--Underexposure

      //Command Data

      nExposureStatus := FReadStream.ReadByte;
      // 4 Byte : current exposure time(4bytes)+

      nByte1 := FReadStream.ReadByte;
      nByte2 := FReadStream.ReadByte;
      nByte3 := FReadStream.ReadByte;
      nByte4 := FReadStream.ReadByte;
      nCurrExposure := (nByte4 * $1000000) + (nByte3 * $10000) + (nByte2 * $100) + nByte1;

      // 2 Byte : spectral coefficient (2bytes) +
      //          Spectral coefficient(int16)：The spectral coefficient N indicates that the spectral data is magnified by 10 to the NTH power than the actual value
      nByte1 := FReadStream.ReadByte;
      nByte2 := FReadStream.ReadByte;

      nCoefficient := SmallInt((nByte2 * $100) + nByte1);

      if (nCoefficient < -100) or (nCoefficient > 100) then Exit;
      dTemp1 := Power(10, nCoefficient);
      if IsNan(dTemp1) or IsInfinite(dTemp1) or (dTemp1 = 0) then Exit;

      if nDataLen < 0 then Exit;
      if nDataLen > 999 then nDataLen := 999;

      FDataCount := nDataLen;
      for I := 0 to nDataLen-1 do
      begin
        nByte1 := FReadStream.ReadByte;
        nByte2 := FReadStream.ReadByte;
        FDATA[I] := (((nByte2 * $100) + nByte1) / dTemp1) * FIntensityFactor;
      end;
      MeasPeak;

      BroadcastMessage(UM_UPDATE_GRAPH_CHANGED, FDeviceIndex, 0);
      Result := True;

    end;
  end;
end;

function TData.ParseFrameData2: Boolean;
var
  I : Integer;
  nData : Integer;
  nByte1 : Byte;
  nByte2 : Byte;
  nByte3 : Byte;
  nByte4 : Byte;
  dValue : Double;

  nTotalDataLen, nDataLen : Integer;
  nExposureStatus : Byte;
  nCurrExposure : UInt32;
  nCoefficient : SmallInt;
  nTemp : Integer;
  dTemp1, dTemp2 : Double;
  nPacketLen : Integer;
  dSingle : Single;
begin
  Result := False;
  nPacketLen := PACKET_LENGTH2;

  if FReadStream.Size = nPacketLen then
  begin
    FReadStream.Position := 0;
    nByte1 := FReadStream.ReadByte;
    nByte2 := FReadStream.ReadByte;

    //2 Byte : Command header identification
    if (nByte1 = $CC) and (nByte2 = $81) then
    begin
      //Total Packet Length
      //3 Byte : General Contractor(Unit :byte) = 9 + 1 + 4 +2+Spectral Data Length
      nByte1 := FReadStream.ReadByte;
      nByte2 := FReadStream.ReadByte;
      nByte3 := FReadStream.ReadByte;
      nTotalDataLen := (nByte3 * $10000) + (nByte2 * $100) + nByte1;

      nDataLen := (nTotalDataLen - 16) div 2;
//      case SpectrometerKind of
//        1 : nDataLen := (nTotalDataLen - (16 + (27*4))) div 2;
//      end;

      //1 Byte : Command Type $02
      nByte1 := FReadStream.ReadByte;

      //Command Data =
//          Exposure Status +
//          Current Exposure Time +
//          Photometric Parameters +
//          Spectral Coefficient +
//          Spectrum Data

      //Exposure Status (uint8): 0x00 – Normal; 0x01 – Overexposed; 0x02 – Underexposed
      nExposureStatus := FReadStream.ReadByte;
      // 4 Byte : current exposure time(4bytes)+

      //Exposure Time (uint32): Unit: us, with the lower byte first and the higher byte last
      nByte1 := FReadStream.ReadByte;
      nByte2 := FReadStream.ReadByte;
      nByte3 := FReadStream.ReadByte;
      nByte4 := FReadStream.ReadByte;
      nCurrExposure := (nByte4 * $1000000) + (nByte3 * $10000) + (nByte2 * $100) + nByte1;

//      Photometric Parameters (float): 27 photometric parameters,
//        the specific meaning of each value is shown in Appendix 1 Photometric Parameter Description:
//        [cct, lux, ee, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, ra, X, Y, Z, duv, u, v, x, y]
//      for I := 0 to 26 do
//      begin
////        dSingle := FReadStream.ReadSingle;
//        nByte1 := FReadStream.ReadByte;
//        nByte2 := FReadStream.ReadByte;
//        nByte3 := FReadStream.ReadByte;
//        nByte4 := FReadStream.ReadByte;
//      end;

      // 2 Byte : Spectral Coefficient (int16):
      //          The spectral coefficient N indicates that the spectral data is magnified by 10 to the NTH power than the actual value

//      nByte1 := FReadStream.ReadByte;
//      nByte2 := FReadStream.ReadByte;
//      nCoefficient := (nByte2 * $100) + nByte1;
      nCoefficient := SmallInt(FReadStream.ReadWord);

//      Codesite.SendFmtMsg('nDataLen=%d, nCoefficient = %d, nCurrExposure=%d, nExposureStatus=%d',[nDataLen, nCoefficient, nCurrExposure, nExposureStatus]);

      if (nCoefficient < -100) or (nCoefficient > 100) then Exit;
      dTemp1 := Power(10, nCoefficient);
      if IsNan(dTemp1) or IsInfinite(dTemp1) or (dTemp1 = 0) then Exit;

      if nDataLen < 0 then Exit;
      if nDataLen > 999 then nDataLen := 999;

      FDataCount := nDataLen;
      for I := 0 to nDataLen-1 do
      begin
        nByte1 := FReadStream.ReadByte;
        nByte2 := FReadStream.ReadByte;
        FDATA[I] := (((nByte2 * $100) + nByte1) / dTemp1) * FIntensityFactor;
      end;
      MeasPeak;

      BroadcastMessage(UM_UPDATE_GRAPH_CHANGED, FDeviceIndex, 0);
      Result := True;

    end;
  end;
end;

function TData.ReciveParse : Boolean;
begin
  Result := False;
  case FCommandState of
    csNone :
    begin

    end;
    csSingleFrame :
    begin
      case SpectrometerKind of
        SPECTROMETER_KIND_OLD : Result := ParseFrameData;
        SPECTROMETER_KIND_NEW : Result := ParseFrameData2;
      end;
      FReadStream.Clear;
    end;
    csStartFrame :
    begin
      case SpectrometerKind of
        SPECTROMETER_KIND_OLD : Result := ParseFrameData;
        SPECTROMETER_KIND_NEW : Result := ParseFrameData2;
      end;
      FReadStream.Clear;
    end;
    csStopFrame :
    begin

    end;
  end;
end;

function TData.OpenComm: Boolean;
begin
  Result := FCOMM.OpenComm;
end;

procedure TData.AddAlarmList(AAlarmItem: TAlarmItem);
var
  I : Integer;
begin
  if FAlarmListCount >= MAX_ALARM_LIST_COUNT then
  begin
    for I := 0 to MAX_ALARM_LIST_COUNT - 2 do
      FAlarmList[I] := FAlarmList[I + 1];
    FAlarmListCount := MAX_ALARM_LIST_COUNT - 1;
  end;
  I := FAlarmListCount;
  FAlarmList[I].szName := AAlarmItem.szName;
  FAlarmList[I].szTime := AAlarmItem.szTime;
  FAlarmList[I].dIntensity := AAlarmItem.dIntensity;
  Inc(FAlarmListCount);
end;

procedure TData.AddPeakData(AIndex: Integer; ATime : Double; AValue: Double);
var
  I : Integer;
begin
  if (AIndex < 0) or (AIndex >= MAX_PEAK_LIST_COUNT) then Exit;
  FPeakData[AIndex, FPeakDataCount].dTime := ATime;
  FPeakData[AIndex, FPeakDataCount].dValue := AValue;

  if FPeakDataCount >= MAX_PEAK_DATA_COUNT-1 then
  begin
    for I := 0 to FPeakDataCount-1 do
    begin
      FPeakData[AIndex, I] := FPeakData[AIndex, I+1];
    end;
  end;
end;

procedure TData.AddPeakList(APeakItem: TPeakItem);
var
  I : Integer;
begin
  if FPeakListCount >= MAX_PEAK_LIST_COUNT then Exit;
  I := FPeakListCount;
  FPeakList[I].bUse := APeakItem.bUse;
  FPeakList[I].szName := APeakItem.szName;
  FPeakList[I].nStartWavelength := APeakItem.nStartWavelength;
  FPeakList[I].nEndWavelength := APeakItem.nEndWavelength;
  FPeakList[I].nStartIntensity := APeakItem.nStartIntensity;
  FPeakList[I].nEndIntensity := APeakItem.nEndIntensity;
  FPeakList[I].nColor := APeakItem.nColor;
  Inc(FPeakListCount);
end;

procedure TData.BroadcastMessage(Msg: UINT; WordParam: WPARAM;
  LongParam: LPARAM; const AAsync: Boolean);
begin
  foBroadcastMessage(Msg, WordParam, LongParam, AAsync);
end;

function TData.CheckSum(AMsg: AnsiString): Byte;
var
  nSum : Integer;
  MsgLen : Integer;
  I: Integer;
begin
  nSum := 0;
  MsgLen := Length(AMsg);

  for I := 1 to MsgLen do
  begin
    nSum := nSum + Byte(AMsg[I])
  end;

  Result := (nSum and $FF);
end;

function TData.ReadSingleFrame: Boolean;
var
  szTemp : AnsiString;
begin
  Result := False;
    case SpectrometerKind of
      SPECTROMETER_KIND_OLD,
      SPECTROMETER_KIND_NEW :
      begin
        FCOMM.ClearBuffer;
        FReadStream.Clear;
        FCommandState := csSingleFrame;
        FStartMeas := True;
        FLastRequestTick := GetTickCount;

        szTemp := #09#00#00#02;
        Result := SendCommand(sztemp);
        if not Result then
        begin
          // A write failure (for example, a port that did not reopen) is not
          // a response timeout.  Do not leave a phantom request pending.
          FStartMeas := False;
          FCommandState := csNone;
        end;
      end;
      SPECTROMETER_KIND_QMINI :
      begin

      end;
    end;
end;

procedure TData.ClearPeakData;
var
  I, N : Integer;
begin
  FPeakDataCount := 0;
  for I := 0 to MAX_PEAK_LIST_COUNT-1 do
  begin
    FIntensityNo[I] := 0;
    FAverageIntersity[I] := False;
    for N := 0 to MAX_AVERAGE_COUNT-1 do
      FIntensityArray[I, N] := 0;
  end;
end;

procedure TData.RecoverTimedOutRequest(const ATimeout: Cardinal);
begin
  if FStartMeas and (Cardinal(GetTickCount - FLastRequestTick) >= ATimeout) then
  begin
    FStartMeas := False;
    FResponsePacket := '';
    FReadStream.Clear;
    FCOMM.ClearBuffer;
    if LogLevel >= 1 then
      CodeSite.SendFmtMsg('[SPEC %d][%s] Response timeout',
        [FDeviceIndex + 1, FDeviceName]);
  end;
end;

function TData.CloseComm: Boolean;
begin
  // A response belonging to the old port session must never block the newly
  // opened session or be reported later as a false timeout.
  FStartMeas := False;
  FApplyExposureAfterMode := False;
  FCommandState := csNone;
  FResponsePacket := '';
  if Assigned(FReadStream) then
    FReadStream.Clear;
  Result := FCOMM.CloseComm;
end;

procedure TData.DataModuleCreate(Sender: TObject);
var
  I, N : Integer;
begin
  SystemNo := 0;
  FDeviceIndex := 0;
  FDeviceName := 'Spectrometer 1';
  FAlarmActive := False;
  FLanguages := -1;
  FExposure := 10;
  FReadTime := 100;
  FAlarmTimeSet := 1000;
  FIntensityFactor := 1;
  FAreaIntensityFactor := 1;
  FAverageCount := 1;
  FLEDLightValue := 100;

  FResponsePacket := '';

  FPeakListCount := 0;
  FPeakDataCount := 0;
  for I := 0 to MAX_PEAK_LIST_COUNT-1 do
  begin
    FPeakList[I].bUse := False;
    FPeakList[I].szName := '';
    FPeakList[I].nStartWavelength := 0;
    FPeakList[I].nEndWavelength := 0;
    FPeakList[I].nStartIntensity := 0;
    FPeakList[I].nEndIntensity := 0;
    FPeakList[I].nColor := 0;

    for N := 0 to MAX_PEAK_DATA_COUNT-1  do
    begin
      FPeakData[I, N].dTime := 0;
      FPeakData[I, N].dValue := 0;
    end;
  end;

  FAlarmListCount := 0;
  for I := 0 to MAX_ALARM_LIST_COUNT-1 do
  begin
    FAlarmList[I].szName := '';
    FAlarmList[I].szTime := '';
    FAlarmList[I].dIntensity := 0;
  end;

  FDataCount := 0;
  for I := 0 to MAX_DATA_COUNT-1 do
  begin
    FDATA[I] := 0;
  end;

  for I := 0 to MAX_PEAK_LIST_COUNT-1 do
  begin
    FIntensityNo[I] := 0;
    FAverageIntersity[I] := False;
    for N := 0 to MAX_AVERAGE_COUNT-1 do
      FIntensityArray[I, N] := 0;
  end;

  FPeakWaveLength := 0;
  FPeakIntensity := 0;
  FPekaResult := false;
  FStartMeas := False;
  FApplyExposureAfterMode := False;
  FLastRequestTick := 0;
  FFaultMeasString := False;

  FReadStream := TfoStream.Create;

  FFaultTimeer := TfoTimeCounter.Create;
  FMeasTimeer := TfoTimeCounter.Create;


  FCOMM := TfoCommEx.Create(self);
  FCOMM.Port := TfocPort(COM01);

  FCOMM.EventChar := #10;
  FCOMM.DiscardNull := False;

  FCommandState := csNone;
  FCOMM.OnReceived := OnReceived;
  FCOMM.OnEventCharReceived := OnEventCharReceived;

  FIFCOMM := TfoCommEx.Create(self);


end;

procedure TData.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FCOMM) then
  begin
    FCOMM.OnReceived := nil;
    FCOMM.OnEventCharReceived := nil;
    FCOMM.CloseComm;
  end;
  if Assigned(FIFCOMM) then
    FIFCOMM.CloseComm;

  FreeAndNil(FCOMM);
  FreeAndNil(FIFCOMM);

  FReadStream.Free;
  FFaultTimeer.Free;
  FMeasTimeer.Free;
end;

procedure TData.DeleteAlarmList(AIndex: Integer);
var
  I: Integer;
begin
  if (AIndex < 0) or (AIndex >= FAlarmListCount) then Exit;
  for I := AIndex to FAlarmListCount-2 do
  begin
    FAlarmList[I].szName := FAlarmList[I+1].szName;
    FAlarmList[I].szTime := FAlarmList[I+1].szTime;
    FAlarmList[I].dIntensity := FAlarmList[I+1].dIntensity;
  end;
  Dec(FAlarmListCount);
end;

procedure TData.DeleteAllAlarmList;
begin
  FAlarmListCount := 0;
end;

procedure TData.DeletePeakList(AIndex: Integer);
var
  I: Integer;
begin
  if (AIndex < 0) or (AIndex >= FPeakListCount) then Exit;
  for I := AIndex to FPeakListCount-2 do
  begin
    FPeakList[I].bUse := FPeakList[I+1].bUse;
    FPeakList[I].szName := FPeakList[I+1].szName;
    FPeakList[I].nStartWavelength := FPeakList[I+1].nStartWavelength;
    FPeakList[I].nEndWavelength := FPeakList[I+1].nEndWavelength;
    FPeakList[I].nStartIntensity := FPeakList[I+1].nStartIntensity;
    FPeakList[I].nEndIntensity := FPeakList[I+1].nEndIntensity;
    FPeakList[I].nColor := FPeakList[I+1].nColor;
  end;
  Dec(FPeakListCount);
end;

procedure TData.EditPeakList(AIndex: Integer; APeakItem: TPeakItem);
var
  I : Integer;
begin
  if (AIndex < 0) or (AIndex >= FPeakListCount) then Exit;
  I := AIndex;
  FPeakList[I].bUse := APeakItem.bUse;
  FPeakList[I].szName := APeakItem.szName;
  FPeakList[I].nStartWavelength := APeakItem.nStartWavelength;
  FPeakList[I].nEndWavelength := APeakItem.nEndWavelength;
  FPeakList[I].nStartIntensity := APeakItem.nStartIntensity;
  FPeakList[I].nEndIntensity := APeakItem.nEndIntensity;
  FPeakList[I].nColor := APeakItem.nColor;
end;

procedure TData.foBroadcastMessage(Msg: UINT; WordParam: WPARAM;
  LongParam: LPARAM; const AAsync: Boolean; const ATimeout: Integer);
var
  I : Integer;
  dwResult : DWORD;
begin
  if csDestroying in Application.ComponentState then Exit;

  foSendMessage(Application.MainForm, Msg, WordParam, LongParam, AAsync, ATimeout);

  for I := Pred(Screen.FormCount) downto 0 do
  begin
    if Screen.Forms[I] <> Application.MainForm then
    begin
      foSendMessage(Screen.Forms[I], Msg, WordParam, LongParam, AAsync, ATimeout);
    end;
  end;
end;

procedure TData.foSendMessage(AControl: TWinControl; Msg: UINT;
  WordParam: WPARAM; LongParam: LPARAM; const AAsync: Boolean;
  const ATimeout: Integer);
var
  I : Integer;
  dwResult : DWORD;
begin
  if csDestroying in Application.ComponentState then Exit;

  if AControl.HandleAllocated then
  begin
 //   if AAsync then
      PostMessage(AControl.Handle, Msg, WordParam, LongParam)
//    else
//      SendMessageTimeout(AControl.Handle, Msg, WordParam, LongParam, SMTO_NORMAL, ATimeout, dwResult);
  end;
end;

procedure TData.LoadSetting;
var
  INI : TIniFile;
  I : Integer;
  SetupSection : String;
begin
  INI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    FLanguages := INI.ReadInteger('General', 'Languages', FLanguages);
    FSystemNo := INI.ReadInteger('General', 'SystemNo', FSystemNo);
    FSpectrometerKind := INI.ReadInteger('General', 'SpectrometerKind', FSpectrometerKind);
    FMeasMethod := INI.ReadInteger('General', 'MeasMethod', FMeasMethod);


    if FDeviceIndex = 0 then
    begin
      LogLevel := Max(0, INI.ReadInteger('General', 'LogLevel', LogLevel));
      SpectrometerCount := EnsureRange(INI.ReadInteger('General', 'SpectrometerCount', SpectrometerCount), 1, MAX_SPECTROMETER_COUNT);
      SelectedSpectrometer := EnsureRange(INI.ReadInteger('General', 'SelectedSpectrometer', SelectedSpectrometer), 0, SpectrometerCount-1);
    end;
    SetupSection := Format('Spectrometer%d', [FDeviceIndex + 1]);
    FDeviceName := INI.ReadString(SetupSection, 'Name',
      Format('Spectrometer %d', [FDeviceIndex + 1]));
    FComPortNo := INI.ReadInteger(SetupSection, 'ComPortNo',
      INI.ReadInteger('Setup', 'ComPortNo', FComPortNo));
    FIFComPortNo := INI.ReadInteger('Setup', 'IFComPortNo', FIFComPortNo);
    FIFCommKind := INI.ReadInteger('Setup', 'IFCommKind', FIFCommKind);
    FUseIF := INI.ReadInteger('Setup', 'UseIF', FUseIF);
    FAlarmMode := INI.ReadInteger('Setup', 'AlarmMode', FAlarmMode);

    FExposure := INI.ReadInteger('Setup', 'Exposure', FExposure);
    FReadTime := INI.ReadInteger('Setup', 'ReadTime', FReadTime);
    FIntensityFactor := INI.ReadFloat('Setup', 'IntensityFactor', FIntensityFactor);
    FAreaIntensityFactor := INI.ReadFloat('Setup', 'AreaIntensityFactor', FAreaIntensityFactor);
    FAverageCount := EnsureRange(INI.ReadInteger('Setup', 'AverageCount', FAverageCount), 1, MAX_AVERAGE_COUNT);
    FLEDLightValue := INI.ReadInteger('Setup', 'LEDLightValue', FLEDLightValue);
    FAlarmTimeSet := INI.ReadInteger('Setup', 'AlarmTimeSet', FAlarmTimeSet);

    FSpecWavelengthMin := INI.ReadInteger('Setup', 'SpecWavelengthMin', FSpecWavelengthMin);
    FSpecWavelengthMax := INI.ReadInteger('Setup', 'SpecWavelengthMax', FSpecWavelengthMax);
    FSpecIntensityMin := INI.ReadFloat('Setup', 'SpecIntensityMin', FSpecIntensityMin);
    FSpecIntensityMax := INI.ReadFloat('Setup', 'SpecIntensityMax', FSpecIntensityMax);

    FPeakListCount := EnsureRange(INI.ReadInteger('Peak', 'PeakListCount', FPeakListCount), 0, MAX_PEAK_LIST_COUNT);
    for I := 0 to FPeakListCount-1 do
    begin
      FPeakList[I].bUse := Boolean(INI.ReadInteger(Format('Peak%d',[I]), 'Use', 0));
      FPeakList[I].szName := INI.ReadString(Format('Peak%d',[I]), 'Name', '');
      FPeakList[I].nStartWavelength := INI.ReadInteger(Format('Peak%d',[I]), 'StartWavelength', 0);
      FPeakList[I].nEndWavelength := INI.ReadInteger(Format('Peak%d',[I]), 'EndWavelength', 0);
      FPeakList[I].nStartIntensity := INI.ReadFloat(Format('Peak%d',[I]), 'StartIntensity', 0);
      FPeakList[I].nEndIntensity := INI.ReadFloat(Format('Peak%d',[I]), 'EndIntensity', 0);
      FPeakList[I].nColor := INI.ReadInteger(Format('Peak%d',[I]), 'Color', 0);
    end;

  finally
    INI.Free;
  end;
end;

function TData.MeasPeak: Boolean;

function GetPeakIntensity(AStart, AEnd : Integer) : Double;
var
  I : Integer;
  nStart, nEnd : Integer;
  dPeak : Double;
begin
  Result := 0;
  nStart := -1;
  nEnd := FDataCount - 1;

  if (FDataCount <= 0) or (AEnd < AStart) then exit;

  for I := 0 to FDataCount-1 do
  begin
    if FWAVE[I] >= AStart then
    begin
      nStart := I;
      Break;
    end;
  end;

  for I := 0 to FDataCount-1 do
  begin
    if FWAVE[I] >= AEnd then
    begin
      nEnd := I;
      Break;
    end;
  end;
  if (nStart < 0) or (nEnd < nStart) then exit;


  dPeak := 0;
  for I := nStart to nEnd do
  begin
    if dPeak < FDATA[I] then dPeak := FDATA[I];
  end;
  Result := dPeak;
end;

function GetSumIntensity(AStart, AEnd : Integer) : Double;
var
  I : Integer;
  nStart, nEnd : Integer;
  dSum : Double;
begin
  Result := 0;
  nStart := 0;
  nEnd := FDataCount-1;

  if (FDataCount <= 0) or (AEnd < AStart) then exit;

  for I := 0 to FDataCount-1 do
  begin
    if FWAVE[I] >= AStart then
    begin
      nStart := I;
      Break;
    end;
  end;

  for I := 0 to FDataCount-1 do
  begin
    if FWAVE[I] >= AEnd then
    begin
      nEnd := I;
      Break;
    end;
  end;
//  if (nStart = 0) or (nEnd = 0) then exit;

  dSum := 0;
  for I := nStart to nEnd do
  begin
    dSum := dSum + FDATA[I];
  end;
  Result := dSum;
end;

function AverageSumIntensity(AIndex: Integer; dValue : Double) : Double;
var
  I, SampleCount, ConfiguredCount : Integer;
  dSum : Double;
begin
  ConfiguredCount := EnsureRange(FAverageCount, 1, MAX_AVERAGE_COUNT);
  if (AIndex < 0) or (AIndex >= MAX_PEAK_LIST_COUNT) then
  begin
    Result := dValue;
    Exit;
  end;

  FIntensityArray[AIndex, FIntensityNo[AIndex]] := dValue;
  Inc(FIntensityNo[AIndex]);
  if FIntensityNo[AIndex] >= ConfiguredCount then
  begin
    FAverageIntersity[AIndex] := True;
    FIntensityNo[AIndex] := 0;
  end;

  if FAverageIntersity[AIndex] then
    SampleCount := ConfiguredCount
  else
    SampleCount := FIntensityNo[AIndex];
  if SampleCount < 1 then SampleCount := 1;

  dSum := 0;
  for I := 0 to SampleCount-1 do
  begin
    dSum := dSum + FIntensityArray[AIndex, I];
  end;
  Result := dSum / SampleCount;
end;

var
  I, N : Integer;
  dValue : Double;
begin
  Result := True;
  FPeakIntensity := 0;

  case FSpectrometerKind of
    SPECTROMETER_KIND_OLD, SPECTROMETER_KIND_NEW:
      begin
        for N := 0 to FDataCount - 1 do
        begin
          FWAVE[N] := 340 + N;
        end;
      end;
  end;


  for I := 0 to FDataCount-1 do
  begin
    if FDATA[I] > FPeakIntensity then
    begin
      FPeakWaveLength := 340 + I;
      FPeakIntensity := FDATA[I];
    end;
  end;

  for I := 0 to FPeakListCount-1 do
  begin
    FPeakList[I].bResult := True;
    if FPeakList[I].bUse then
    begin
      if FMeasMethod = 0 then
      begin
        dValue := GetPeakIntensity(FPeakList[I].nStartWavelength, FPeakList[I].nEndWavelength);
      end
      else
      begin
        dValue := GetSumIntensity(FPeakList[I].nStartWavelength, FPeakList[I].nEndWavelength) * FAreaIntensityFactor;
        dValue := AverageSumIntensity(I, dValue);
      end;

      FPeakList[I].dIntensity := dValue;
      FPeakList[I].dTime := FMeasTimeer.ElapsedTime;

      AddPeakData(I, FPeakList[I].dTime, dValue);

      if (FPeakList[I].dIntensity < FPeakList[I].nStartIntensity) or (FPeakList[I].dIntensity > FPeakList[I].nEndIntensity) then
      begin
        FPeakList[I].bResult := False;
        Result := False;
      end;
    end;
  end;
  Inc(FPeakDataCount);
  if FPeakDataCount >= MAX_PEAK_DATA_COUNT-1 then FPeakDataCount := MAX_PEAK_DATA_COUNT-1;

  if Result then
  begin
    FPekaResult := True;
  end
  else
  begin
    FPekaResult := False;
  end;
end;

procedure TData.SavePeakData(AFileName: String);
var
  SL : TStringList;
  I, N : Integer;
  szTemp : String;
begin
  SL := TStringList.Create;
  try
    szTemp := 'Time';
    for N := 0 to FPeakListCount-1 do
      if FPeakList[N].bUse then
        szTemp := szTemp + foCharTab + FPeakList[N].szName;
    SL.Add(szTemp);

    for I := 0 to FPeakDataCount-1 do
    begin
      szTemp := '';
      for N := 0 to FPeakListCount-1 do
      begin
        if FPeakList[N].bUse then
        begin
          if szTemp = '' then
            szTemp := Format('%.3f', [FPeakData[N, I].dTime]);
          szTemp := szTemp + foCharTab + Format('%.2f', [FPeakData[N, I].dValue]);
        end;
      end;
      if szTemp <> '' then
        SL.Add(szTemp);
    end;
    SL.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

procedure TData.SaveSetting;
var
  INI : TIniFile;
  I : Integer;
  SetupSection : String;
begin
  INI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    INI.WriteInteger('General', 'Languages', FLanguages);
    INI.WriteInteger('General', 'SpectrometerKind', FSpectrometerKind);
    INI.WriteInteger('General', 'MeasMethod', FMeasMethod);
    INI.WriteInteger('General', 'SpectrometerCount', SpectrometerCount);
    INI.WriteInteger('General', 'SelectedSpectrometer', SelectedSpectrometer);
    INI.WriteInteger('General', 'LogLevel', LogLevel);

    INI.WriteInteger('Setup', 'Exposure', FExposure);
    SetupSection := Format('Spectrometer%d', [FDeviceIndex + 1]);
    INI.WriteString(SetupSection, 'Name', FDeviceName);
    INI.WriteInteger(SetupSection, 'ComPortNo', FComPortNo);
    INI.WriteInteger('Setup', 'IFCommKind', FIFCommKind);
    INI.WriteInteger('Setup', 'IFComPortNo', FIFComPortNo);
    INI.WriteInteger('Setup', 'UseIF', FUseIF);
    INI.WriteInteger('Setup', 'AlarmMode', FAlarmMode);
    INI.WriteInteger('Setup', 'Exposure', FExposure);
    INI.WriteInteger('Setup', 'ReadTime', FReadTime);
    INI.WriteFloat('Setup', 'IntensityFactor', FIntensityFactor);
    INI.WriteFloat('Setup', 'AreaIntensityFactor', FAreaIntensityFactor);
    INI.WriteInteger('Setup', 'AverageCount', FAverageCount);
    INI.WriteInteger('Setup', 'LEDLightValue', FLEDLightValue);

    INI.WriteInteger('Setup', 'AlarmTimeSet', FAlarmTimeSet);

    INI.WriteInteger('Setup', 'SpecWavelengthMin', FSpecWavelengthMin);
    INI.WriteInteger('Setup', 'SpecWavelengthMax', FSpecWavelengthMax);
    INI.WriteFloat('Setup', 'SpecIntensityMin', FSpecIntensityMin);
    INI.WriteFloat('Setup', 'SpecIntensityMax', FSpecIntensityMax);

    INI.WriteInteger('Peak', 'PeakListCount', FPeakListCount);
    for I := 0 to FPeakListCount-1 do
    begin
      INI.WriteInteger(Format('Peak%d',[I]), 'Use', Integer(FPeakList[I].bUse));
      INI.WriteString(Format('Peak%d',[I]), 'Name', FPeakList[I].szName);
      INI.WriteInteger(Format('Peak%d',[I]), 'StartWavelength', FPeakList[I].nStartWavelength);
      INI.WriteInteger(Format('Peak%d',[I]), 'EndWavelength', FPeakList[I].nEndWavelength);
      INI.WriteFloat(Format('Peak%d',[I]), 'StartIntensity', FPeakList[I].nStartIntensity);
      INI.WriteFloat(Format('Peak%d',[I]), 'EndIntensity', FPeakList[I].nEndIntensity);
      INI.WriteInteger(Format('Peak%d',[I]), 'Color', FPeakList[I].nColor);
    end;

  finally
    INI.Free;
  end;
end;



function TData.SendCommand(szCommand: AnsiString): Boolean;
var
  PacketStream : TfoStream;
  nChackCum : Byte;
  CRC : WORD;
  szTemp, szHexData : AnsiString;
begin
  Result := False;
  PacketStream := nil;
  try
    PacketStream := TfoStream.Create;

    // Modbus 는 Big Endian
    PacketStream.ByteOrder := sboBigEndian;

    //Command Header
    PacketStream.WriteByte($CC);
    PacketStream.WriteByte($01);

    PacketStream.WriteString(szCommand);

    PacketStream.Position := 0;
    nChackCum := CheckSum(PacketStream.ReadString(PacketStream.Size));
    PacketStream.WriteByte(nChackCum);

    //Naming end mark
    PacketStream.WriteByte($0D);
    PacketStream.WriteByte($0A);

    PacketStream.Position := 0;

    szTemp := PacketStream.ReadString(PacketStream.Size);
    Result := FCOMM.WriteString(szTemp);

    szHexData := foHexifyString16(szTemp);
    if LogLevel >= 10 then
      CodeSite.SendFmtMsg('[SPEC %d][%s] SendData [%s]',
        [FDeviceIndex + 1, FDeviceName, szHexData]);

  finally
    FreeAndNil(PacketStream);
  end;
end;

function TData.SendToRgbServer(const ACommand: Integer; const Param: AnsiString) : Boolean;
var
  cds: TCopyDataStruct;
  hWindow: HWND;
begin
  Result := false;
  hWindow := FindWindow(nil, 'RgbServer'); // MFC 서버 윈도우
  if hWindow = 0 then
  begin
    Exit;
  end;

  // "FormName|Message" 형식으로 전송
  cds.dwData := ACommand;
  cds.cbData := (Length(Param) + 1) * SizeOf(PAnsiChar);
  cds.lpData := PAnsiChar(Param);
  SendMessage(hWindow, WM_COPYDATA, 0, LPARAM(@cds));
  Result := True;
end;

function TData.SetAutoExposureMode: Boolean;
var
  szTemp : AnsiString;
begin
  FReadStream.Clear;
  FCommandState := csAutoExposure;
  FStartMeas := True;
  FLastRequestTick := GetTickCount;

  case FSpectrometerKind of
    SPECTROMETER_KIND_OLD : szTemp := #$09#$00#$00#$0B;
    SPECTROMETER_KIND_NEW : szTemp := #$0A#$00#$00#$0A#$01;
  end;

  Result := SendCommand(sztemp);
end;

function TData.SetManualExposureMode: Boolean;
var
  szTemp : AnsiString;
begin
  FReadStream.Clear;
  FCommandState := csManualExposure;
  FStartMeas := True;
  FLastRequestTick := GetTickCount;

  case FSpectrometerKind of
    SPECTROMETER_KIND_OLD : szTemp := #$09#$00#$00#$0A;
    SPECTROMETER_KIND_NEW : szTemp := #$0A#$00#$00#$0A#$00;
  end;

  Result := SendCommand(sztemp);
end;

procedure TData.ApplyCommunicationSettings;
begin
  FApplyExposureAfterMode := True;
  if not SetManualExposureMode then
  begin
    FApplyExposureAfterMode := False;
    FStartMeas := False;
    FCommandState := csNone;
  end;
end;

function TData.SetExposure(AValue: Integer): Boolean;
var
  szTemp : AnsiString;
  szValue : AnsiString;
begin
  case FSpectrometerKind of
    SPECTROMETER_KIND_OLD,
    SPECTROMETER_KIND_NEW :
    begin
      FReadStream.Clear;
      FCommandState := csSetExposure;
      FStartMeas := True;
      FLastRequestTick := GetTickCount;

      szValue := IntToHex(AValue * 1000, 8);

      szTemp := #$0D#00#00#$0C +
        Char(StrToIntDef('$' + Copy(szValue, 7, 2), 0)) +
        Char(StrToIntDef('$' + Copy(szValue, 5, 2), 0)) +
        Char(StrToIntDef('$' + Copy(szValue, 3, 2), 0)) +
        Char(StrToIntDef('$' + Copy(szValue, 1, 2), 0));
      Result := SendCommand(sztemp);
    end;
    SPECTROMETER_KIND_QMINI :
    begin
      Result := SendToRgbServer(MSG_SET_EXPOSURE, Format('%.3f', [(AValue / 1000)]));
    end;
  end;
end;

function TData.StartContData: Boolean;
var
  szTemp : AnsiString;
begin
  FCOMM.ClearBuffer;
  FReadStream.Clear;
  FCommandState := csStartFrame;
  FStartMeas := True;
  FLastRequestTick := GetTickCount;

  szTemp := #09#00#00#03;
  Result := SendCommand(sztemp);
end;

function TData.StopContData: Boolean;
var
  szTemp : AnsiString;
begin
  FReadStream.Clear;
  FCommandState := csStopFrame;
  FStartMeas := True;
  FLastRequestTick := GetTickCount;

  szTemp := #09#00#00#04;
  Result := SendCommand(sztemp);
end;

procedure TData.WriteIFComm(AOnOff: Boolean);
var
  szData : AnsiString;
  szStatus: AnsiString;
begin
  if Data.UseIF <> 1 then exit;
  if Data.IFCommKind <> 0 then exit;

  if AOnOff then
    szStatus := 'ON'
  else
    szStatus := 'OFF';

  // Upper interface protocol: STX + device index + ',' + status + ETX.
  // DeviceIndex is zero based (Spectrometer 1 = index 0).
  szData := foCharSTX + AnsiString(IntToStr(FDeviceIndex)) + ',' +
    szStatus + foCharETX;
  if LogLevel >= 1 then
    CodeSite.SendFmtMsg('[SPEC %d][%s] Write IF Comm [Index=%d, Status=%s]',
      [FDeviceIndex + 1, FDeviceName, FDeviceIndex, String(szStatus)]);
  Data.FIFCOMM.WriteString(szData);

end;

procedure TData.WriteTowerLampRed;
var
  szData : AnsiString;
begin
  if FUseIF <> 1 then exit;
  if Data.IFCommKind <> 1 then exit;


  // RED
//  szData := #$55#$56#$00#$00#$00#$01#$01#$AD; // Off
  szData := #$55#$56#$00#$00#$00#$01#$02#$AE; // On
//  szData := #$55#$56#$00#$00#$00#$01#$03#$AF; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // YELLOW
  szData := #$55#$56#$00#$00#$00#$02#$01#$AE; // Off
//  szData := #$55#$56#$00#$00#$00#$02#$02#$AF; // On
//  szData := #$55#$56#$00#$00#$00#$02#$03#$B0; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // GREEN
  szData := #$55#$56#$00#$00#$00#$03#$01#$AF; // Off
//  szData := #$55#$56#$00#$00#$00#$03#$02#$B0; // On
//  szData := #$55#$56#$00#$00#$00#$03#$03#$B1; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // BUZZER
//  szData := #$55#$56#$00#$00#$00#$04#$01#$B0; // Off
  szData := #$55#$56#$00#$00#$00#$04#$02#$B1; // On
//  szData := #$55#$56#$00#$00#$00#$04#$03#$B2; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
end;

procedure TData.WriteTowerLampYellow;
var
  szData : AnsiString;
begin
  if FUseIF <> 1 then exit;
  if Data.IFCommKind <> 1 then exit;

  // RED
  szData := #$55#$56#$00#$00#$00#$01#$01#$AD; // Off
//  szData := #$55#$56#$00#$00#$00#$01#$02#$AE; // On
//  szData := #$55#$56#$00#$00#$00#$01#$03#$AF; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // YELLOW
//  szData := #$55#$56#$00#$00#$00#$02#$01#$AE; // Off
  szData := #$55#$56#$00#$00#$00#$02#$02#$AF; // On
//  szData := #$55#$56#$00#$00#$00#$02#$03#$B0; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // GREEN
  szData := #$55#$56#$00#$00#$00#$03#$01#$AF; // Off
//  szData := #$55#$56#$00#$00#$00#$03#$02#$B0; // On
//  szData := #$55#$56#$00#$00#$00#$03#$03#$B1; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // BUZZER
  szData := #$55#$56#$00#$00#$00#$04#$01#$B0; // Off
//  szData := #$55#$56#$00#$00#$00#$04#$02#$B1; // On
//  szData := #$55#$56#$00#$00#$00#$04#$03#$B2; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
end;

procedure TData.WriteTowerLampGreen;
var
  szData : AnsiString;
begin
  if FUseIF <> 1 then exit;
  if Data.IFCommKind <> 1 then exit;

  // RED
  szData := #$55#$56#$00#$00#$00#$01#$01#$AD; // Off
//  szData := #$55#$56#$00#$00#$00#$01#$02#$AE; // On
//  szData := #$55#$56#$00#$00#$00#$01#$03#$AF; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // YELLOW
  szData := #$55#$56#$00#$00#$00#$02#$01#$AE; // Off
//  szData := #$55#$56#$00#$00#$00#$02#$02#$AF; // On
//  szData := #$55#$56#$00#$00#$00#$02#$03#$B0; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // GREEN
//  szData := #$55#$56#$00#$00#$00#$03#$01#$AF; // Off
  szData := #$55#$56#$00#$00#$00#$03#$02#$B0; // On
//  szData := #$55#$56#$00#$00#$00#$03#$03#$B1; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // BUZZER
  szData := #$55#$56#$00#$00#$00#$04#$01#$B0; // Off
//  szData := #$55#$56#$00#$00#$00#$04#$02#$B1; // On
//  szData := #$55#$56#$00#$00#$00#$04#$03#$B2; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
end;

procedure TData.WriteTowerLampOff;
var
  szData : AnsiString;
begin
  if FUseIF <> 1 then exit;
  if Data.IFCommKind <> 1 then exit;

  // RED
  szData := #$55#$56#$00#$00#$00#$01#$01#$AD; // Off
//  szData := #$55#$56#$00#$00#$00#$01#$02#$AE; // On
//  szData := #$55#$56#$00#$00#$00#$01#$03#$AF; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // YELLOW
  szData := #$55#$56#$00#$00#$00#$02#$01#$AE; // Off
//  szData := #$55#$56#$00#$00#$00#$02#$02#$AF; // On
//  szData := #$55#$56#$00#$00#$00#$02#$03#$B0; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // GREEN
  szData := #$55#$56#$00#$00#$00#$03#$01#$AF; // Off
//  szData := #$55#$56#$00#$00#$00#$03#$02#$B0; // On
//  szData := #$55#$56#$00#$00#$00#$03#$03#$B1; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
  Sleep(30);

  // BUZZER
  szData := #$55#$56#$00#$00#$00#$04#$01#$B0; // Off
//  szData := #$55#$56#$00#$00#$00#$04#$02#$B1; // On
//  szData := #$55#$56#$00#$00#$00#$04#$03#$B2; // Flash
	if LogLevel >= 1 then CodeSite.SendFmtMsg('Write Comm [%s]',[szData]);
  FIFCOMM.WriteString(szData);
end;

procedure TData.CopySettingsFrom(ASource: TData);
var
  I: Integer;
begin
  if ASource = Self then Exit;
  FSpectrometerKind := ASource.FSpectrometerKind;
  FMeasMethod := ASource.FMeasMethod;
  FExposure := ASource.FExposure;
  FReadTime := ASource.FReadTime;
  FAlarmTimeSet := ASource.FAlarmTimeSet;
  FIntensityFactor := ASource.FIntensityFactor;
  FAreaIntensityFactor := ASource.FAreaIntensityFactor;
  FAverageCount := ASource.FAverageCount;
  FAlarmMode := ASource.FAlarmMode;
  FSpecWavelengthMin := ASource.FSpecWavelengthMin;
  FSpecWavelengthMax := ASource.FSpecWavelengthMax;
  FSpecIntensityMin := ASource.FSpecIntensityMin;
  FSpecIntensityMax := ASource.FSpecIntensityMax;
  FPeakListCount := ASource.FPeakListCount;
  for I := 0 to MAX_PEAK_LIST_COUNT - 1 do
    FPeakList[I] := ASource.FPeakList[I];
end;

function GetSpectrometer(const AIndex: Integer): TData;
begin
  if (AIndex >= 0) and (AIndex < SpectrometerCount) then
    Result := Spectrometers[AIndex]
  else
    Result := Spectrometers[0];
end;

function CurrentSpectrometer: TData;
begin
  Result := GetSpectrometer(SelectedSpectrometer);
end;

procedure InitializeSpectrometers;
var
  I: Integer;
begin
  Spectrometers[0] := Data;
  Data.DeviceIndex := 0;
  for I := 1 to SpectrometerCount - 1 do
  begin
    if not Assigned(Spectrometers[I]) then
    begin
      // Additional devices are owned and released by the spectrometer manager.
      // Using Application as owner and also freeing them explicitly during the
      // main form shutdown can cause an access violation in finalization.
      Spectrometers[I] := TData.Create(nil);
      Spectrometers[I].DeviceIndex := I;
      Spectrometers[I].LoadSetting;
    end;
  end;
end;

procedure SetSpectrometerCount(const ACount: Integer);
var
  I, NewCount: Integer;
begin
  NewCount := EnsureRange(ACount, 1, MAX_SPECTROMETER_COUNT);
  if NewCount < SpectrometerCount then
    for I := NewCount to SpectrometerCount - 1 do
    begin
      if Assigned(Spectrometers[I]) then
        Spectrometers[I].CloseComm;
      FreeAndNil(Spectrometers[I]);
    end;
  SpectrometerCount := NewCount;
  if SelectedSpectrometer >= SpectrometerCount then
    SelectedSpectrometer := SpectrometerCount - 1;
  InitializeSpectrometers;
end;

procedure FinalizeSpectrometers;
var
  I: Integer;
begin
  for I := 1 to MAX_SPECTROMETER_COUNT - 1 do
  begin
    if Assigned(Spectrometers[I]) then
      Spectrometers[I].CloseComm;
    FreeAndNil(Spectrometers[I]);
  end;
  Spectrometers[0] := nil;
end;

end.
