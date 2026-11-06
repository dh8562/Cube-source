unit dmHAL;

interface

uses
  Forms,
  SysUtils,
  Classes,
  Variants,
  ImgList,
  Controls,
  Windows,
  Math,
  TypInfo,
  IOUtils,
  DateUtils,
  ExtCtrls,

  CodeSiteLogging,

  ScktComp,

  foWinUtils,
  foTypes,
  foDataServer,
  foDataServerUtils,
  foChannelChecker,
  foAlarmManager,
  foActuator,
  foController,
  foComm,
  foRTTIUtils,
  foStringUtils,
  foThreadTimer,
  foLists,
  foTimeCounter,
  foMotion,
  foGenericIODevice,
  foWinIODevice,
  foBits,

  foIpcConsts,
  foIpcEngine,
  foIpcMessage,
  foIpcTypes,
  foIpcStream,


  elMultiLanguage,
  elPropSaver,

  OverbyteIcsWSocket,

  fFTPProgress,


  uLogger,
  uCommonUtils,
  uEquipmentTypes,
  uEquipmentUtils,
  uEquipmentConsts,
  uEquipmentBase,
  uAlarmConsts,
  uJob,
  uRecipe,
  foModbusDevice,
  foModbusTcpDevice,
  uDTSModbusTcpDevice,
  elBase, elLog;


{$I uIOServer.inc}
{$I uSysServer.inc}
{$I uStsServer.inc}
{$I uJobServer.inc}


type
  THAL = class(TDataModule)
    SysServer: TfoDataServer;
    IOServer: TfoDataServer;
    ChannelChecker: TfoChannelChecker;
    JobServer: TfoDataServer;
    RecipeServer: TfoDataServer;
    StsServer: TfoDataServer;
    elAlarmLog: TelLog;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MotionLog(Sender: TObject; const ALog: string);

    procedure DataServerError(Sender: TObject; Code: Integer; ChannelName: string; AChannel: TfoChannel);
    procedure ChannelCheckerCompletionError(Sender: TObject; const AWaitChannel, AWaitValue: string; const AErrorCode: Integer);
    procedure SysServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
    procedure JobServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
    procedure DIODeviceFinalize(Sender: TObject; var ASuccess: Boolean);
    procedure DIODeviceInitialize(Sender: TObject; var ASuccess: Boolean);
    procedure lcGetControlCommandPacket(Sender: TObject; const ACommand: TfoLightControlCommand; const AIntensity: Integer; var APacket: AnsiString);
    procedure lcLog(Sender: TObject; const ALogMsg: string);
    procedure lcBinTableLog(Sender: TObject; const ALogMsg: string);
    procedure lcBinTableGetControlCommandPacket(Sender: TObject; const ACommand: TfoLightControlCommand; const AIntensity: Integer; var APacket: AnsiString);
    procedure IOServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
    procedure IOServerChanged(Sender: TObject);
    procedure IODeviceLog(Sender: TObject; const ALog: string);

  private
    { Private declarations }
    FDTSControl : TDTSModbusTcpDevice;
    FDTSProjectReady: Boolean;
    FDTSProjectPipeCount: Integer;
    FDTSConnectionKnown: Boolean;
    FDTSLastResponseTick: UInt64;
    FDTSWatchdogTimer: TTimer;


    FIOServerChangedAt : TDateTime;
    FIOServerReportedAt : TDateTime;

    UpLoadNameList : TStrings;
    RemoteNameList : TStrings;

    FJobLoaded : Boolean;

    procedure DTSControlSlaveResponded(Sender: TObject);
    procedure DTSControlMaybeDead(Sender: TObject);
    procedure DTSControlLog(Sender: TObject; const ALog: string);
    procedure DTSControlCommunicationError(Sender: TObject; const AErrorCode: Integer; const AErrorMsg: string);
    procedure UpdateDTSStatusChannels;
    procedure ClearDTSStatusChannels;
    procedure SetDTSStatusChannel(const AName: string;
      const AValue: Boolean);
    procedure SetDTSConnectionState(const AConnected: Boolean);
    procedure DTSWatchdogTimer(Sender: TObject);

  public
    { Public declarations }
    function AfterInitialization : Boolean;
    function AfterFinalization : Boolean;

  	procedure CreateDIO();
    function DIOInitialize : Boolean;
    function DIOFinalize  : Boolean;

    function AIOInitialize : Boolean;
    function AIOFinalize  : Boolean;

    function DTSCommInitialize : Boolean;
    function DTSCommFinalize : Boolean;
    function ReconfigureDTSCommunication: Boolean;
    procedure BeginProjectCommunicationLoad;
    function StartProjectCommunication(const APipeCount: Integer): Boolean;
    function ReadDTSHoldingWord(const AAddress: Integer;
      out AValue: Word): Boolean;
    procedure RecheckAlarmInputs;

    procedure AddAlarmLog(ASeverity, ACode : Integer; AMsg:String);


    property JobLoaded : Boolean read FJobLoaded write FJobLoaded;

  end;

var
  HAL: THAL;

implementation

uses
  uEquipment, dmMachine;

{$R *.dfm}

const
  SIPC_StateStrings : array[TfoIpcState] of string = (
    SIPC_StateNotConnected,
    SIPC_StateNotSelected,
    SIPC_StateSelected
  );
  SVirtualIOValueFile = 'Config\VirtualIOValues.csv';

{ THAL }


procedure THAL.DataModuleCreate(Sender: TObject);
var
  I : Integer;
begin
  Equipment.SysServer := SysServer;
  Equipment.IOServer := IOServer;
  Equipment.JobServer := JobServer;
  Equipment.RecipeServer := RecipeServer;
  Equipment.StsServer := StsServer;

  Job.SysServer := SysServer;
  Job.JobServer := JobServer;

  UploadNameList := TStringList.Create;
  RemoteNameList := TStringList.Create;

//  CreateDIO(FDIODevice, 'DIODevice');
//  FDIODevice := FDIODevice;

  FDTSControl := TDTSModbusTcpDevice.Create(Self);
  FDTSProjectReady := False;
  FDTSProjectPipeCount := 0;
  FDTSConnectionKnown := False;
  FDTSLastResponseTick := 0;
  FDTSWatchdogTimer := TTimer.Create(Self);
  FDTSWatchdogTimer.Enabled := False;
  FDTSWatchdogTimer.Interval := 500;
  FDTSWatchdogTimer.OnTimer := DTSWatchdogTimer;

  FJobLoaded := False;
end;

procedure THAL.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(UploadNameList);
  FreeAndNil(RemoteNameList);

//  FreeAndNil(FDIODevice);

  FreeAndNil(FDTSControl);

end;

procedure THAL.DataServerError(Sender: TObject; Code: Integer; ChannelName: string; AChannel: TfoChannel);
var
  szMsg: string;
begin
  szMsg := Format('(%s : %s)', [TfoCustomDataServer(Sender).Name, ChannelName]);
  case Code of
    ERR_DIFFERENT_CHANNELTYPE:
    begin
      szMsg := elLocalizedString('Different channel data type.') + szMsg;
      if Equipment.VerboseMode > 0 then
        LogCallStack(szMsg);
    end;

    ERR_NON_EXIST_CHANNEL:
      szMsg := elLocalizedString('The channel does not exist.') + szMsg;
  end;

  Codesite.SendError(Format('%s',[szMsg]));
  AlarmManager.AddMessage(MT_ERROR, szMsg);
end;

function THAL.DIOFinalize: Boolean;
var
  I: Integer;
begin
  Result := True;
end;

function THAL.DIOInitialize: Boolean;
var
  I: Integer;
begin
  Result := True;

end;

procedure THAL.DIODeviceFinalize(Sender: TObject;
  var ASuccess: Boolean);
begin
  ASuccess := True;
end;

procedure THAL.DIODeviceInitialize(Sender: TObject; var ASuccess: Boolean);
begin
  ASuccess := True;
end;


procedure THAL.IODeviceLog(Sender: TObject; const ALog: string);
begin
  //Codesite.SendMsg(ALog);
end;

procedure THAL.IOServerChanged(Sender: TObject);
begin
  FIOServerChangedAt := Now;
end;

procedure THAL.IOServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
var
  AlarmCode: Integer;
begin
  FIOServerChangedAt := Now;
  if not Assigned(AChannel) then Exit;

  AlarmCode := 0;
  if SameText(AChannel.Name, 'I_PLC_POWER_LIFE_TIME_LOW_ALARM') then
    AlarmCode := ERR_PLC_POWER_LIFE_TIME_LOW
  else if SameText(AChannel.Name, 'I_SMPS01_BATTERY_LOW_ALARM') then
    AlarmCode := ERR_SMPS01_BATTERY_LOW
  else if SameText(AChannel.Name, 'I_SMPS01_LIFE_TIME_LOW_ALARM') then
    AlarmCode := ERR_SMPS01_LIFE_TIME_LOW
  else if SameText(AChannel.Name, 'I_SMPS02_BATTERY_LOW_ALARM') then
    AlarmCode := ERR_SMPS02_BATTERY_LOW
  else if SameText(AChannel.Name, 'I_SMPS02_LIFE_TIME_LOW_ALARM') then
    AlarmCode := ERR_SMPS02_LIFE_TIME_LOW
  else if SameText(AChannel.Name, 'I_DOOR_OPEN_01_ALARM') then
    AlarmCode := ERR_DOOR_OPEN_01;

  if AlarmCode = 0 then Exit;
  if AChannel.AsBoolean then
    Machine.AddAlarm(AlarmCode)
  else
    AlarmManager.ReleaseAlarm(AlarmCode);
end;

procedure THAL.RecheckAlarmInputs;

  procedure RecheckChannel(const AChannelName: string;
    const AAlarmCode: Integer);
  begin
    if IOServer.AsBoolean[AChannelName] then
      Machine.AddAlarm(AAlarmCode);
  end;

begin
  if not Assigned(IOServer) then
    Exit;

  RecheckChannel('I_PLC_POWER_LIFE_TIME_LOW_ALARM',
    ERR_PLC_POWER_LIFE_TIME_LOW);
  RecheckChannel('I_SMPS01_BATTERY_LOW_ALARM',
    ERR_SMPS01_BATTERY_LOW);
  RecheckChannel('I_SMPS01_LIFE_TIME_LOW_ALARM',
    ERR_SMPS01_LIFE_TIME_LOW);
  RecheckChannel('I_SMPS02_BATTERY_LOW_ALARM',
    ERR_SMPS02_BATTERY_LOW);
  RecheckChannel('I_SMPS02_LIFE_TIME_LOW_ALARM',
    ERR_SMPS02_LIFE_TIME_LOW);
  RecheckChannel('I_DOOR_OPEN_01_ALARM', ERR_DOOR_OPEN_01);

  if FDTSProjectReady and
     not IOServer.AsBoolean[S_DTS_CONNECTED] then
    Machine.AddAlarm(ERR_DTS_COMMUNICATION_LOST);
end;

procedure THAL.AddAlarmLog(ASeverity, ACode: Integer; AMsg: String);
var
  szDir : String;
  szData : String;
  szFolderName : String;
  szFilename : String;
begin
  szDir := foAppPath;
  if not DirectoryExists(szDir) then CreateDir(PChar(szDir));

  szFolderName := szDir + 'LogData\';
  if not DirectoryExists(szFolderName) then CreateDir(szFolderName);

  szFolderName := szFolderName + FormatDateTime('yyyy',Now) + '\';
  if not DirectoryExists(szFolderName) then CreateDir(szFolderName);

  szFolderName := szFolderName + FormatDateTime('mm',Now) + '\';
  if not DirectoryExists(szFolderName) then CreateDir(szFolderName);

  szFolderName := szFolderName + FormatDateTime('dd',Now) + '\';
  if not DirectoryExists(szFolderName) then CreateDir(szFolderName);

  szFilename := 'AlarmData' + '.csv';

  szData := Format('%d'#9'%d'#9'%s',[ASeverity, ACode, AMsg]);

  elAlarmLog.FileName := szFilename;
  elAlarmLog.LogPath := szFolderName;
  elAlarmLog.Header := 'Date'#9'Time'#9'Severity'#9'Code'#9'Description';
  elAlarmLog.Active := True;
  elAlarmLog.Add(szData);
  elAlarmLog.Active := False;
end;

function THAL.AfterFinalization: Boolean;
begin
  FDTSProjectReady := False;
  DTSCommFinalize;

  IOServer.OnChannelChanged := nil;
  IOServer.OnChanged := nil;

  Result := True;
end;

function THAL.AfterInitialization: Boolean;
begin
  IOServer.AsBoolean[S_DTS_CONNECTED] := False;
  Result := True;
end;

function THAL.AIOFinalize : Boolean;
begin
  Result := True;
end;

function THAL.AIOInitialize : Boolean;
begin
  Result := True;
end;

procedure THAL.JobServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
begin
  if Equipment.ConfigurationLoaded and (AChannel <> nil) then
  begin
    Logger.FireLog(ltInfo, Format('JOB : %s -> %s', [AChannel.Name, AChannel.AsString]), [ldFile]);
    foBroadcastMessage(UM_JOBINFO_MODIFIED, 0, 0, True);
  end;
end;

procedure THAL.lcBinTableGetControlCommandPacket(Sender: TObject;
  const ACommand: TfoLightControlCommand; const AIntensity: Integer;
  var APacket: AnsiString);
begin
  with TfoGenericSerialLightController(Sender) do
  begin
    case ACommand of
      lccTurnOn,
      lccChangeIntensity: APacket := Format('F%d%d', [ChannelNo, AIntensity]);
      lccTurnOff: APacket := Format('F%d%d', [ChannelNo, 0]);
    end;
  end;
end;

procedure THAL.lcBinTableLog(Sender: TObject; const ALogMsg: string);
begin
  Logger.FireLog(ltMessage, ALogMsg);
end;

procedure THAL.lcGetControlCommandPacket(Sender: TObject;
  const ACommand: TfoLightControlCommand; const AIntensity: Integer;
  var APacket: AnsiString);
begin
  with TfoGenericSerialLightController(Sender) do
  begin
    case ACommand of
      lccTurnOn,
      lccChangeIntensity: APacket := foCharSTX + Format('%d%.03d', [ChannelNo, AIntensity]) + foCharETX;
      lccTurnOff: APacket := foCharSTX + Format('%d%.03d', [ChannelNo, 0]) + foCharETX;
    end;
  end;
end;

procedure THAL.lcLog(Sender: TObject; const ALogMsg: string);
begin
  Logger.FireLog(ltMessage, ALogMsg);
end;

procedure THAL.DTSControlCommunicationError(Sender: TObject;
  const AErrorCode: Integer; const AErrorMsg: string);
begin
  Codesite.SendFmtMsg('DTSControlCommunicationError AErrorCode=[%d], AErrorMsg=[%s]',[AErrorCode, AErrorMsg]);
  if Assigned(FDTSControl) then FDTSControl.ClearHoldingWords;
  SetDTSConnectionState(False);
end;

procedure THAL.DTSControlLog(Sender: TObject; const ALog: string);
begin
	if Equipment.VerboseMode > 10 then CodeSite.SendFmtMsg('DTSControlLog [%s]',[ALog]);
end;

procedure THAL.DTSControlMaybeDead(Sender: TObject);
begin
  Codesite.Send('DTSControlMaybeDead');
  if Assigned(FDTSControl) then FDTSControl.ClearHoldingWords;
  SetDTSConnectionState(False);
end;

procedure THAL.DTSControlSlaveResponded(Sender: TObject);
begin
  FDTSLastResponseTick := GetTickCount64;
  SetDTSConnectionState(True);
  UpdateDTSStatusChannels;
  //Codesite.Send('DTSControlSlaveResponded');
end;

procedure THAL.DTSWatchdogTimer(Sender: TObject);
const
  CDTSResponseTimeoutMs = 3000;
begin
  if not FDTSProjectReady then Exit;
  if (FDTSLastResponseTick = 0) or
     (GetTickCount64 - FDTSLastResponseTick >= CDTSResponseTimeoutMs) then
    SetDTSConnectionState(False);
end;

procedure THAL.UpdateDTSStatusChannels;
var
  StatusWord: Word;
begin
  if ReadDTSHoldingWord(5000, StatusWord) then
  begin
    SetDTSStatusChannel('I_CPU_RUN', (StatusWord and $0001) <> 0);
    SetDTSStatusChannel('I_ALARM_STATUS', (StatusWord and $0002) <> 0);
    SetDTSStatusChannel('I_EMERGENCY_STATUS',
      (StatusWord and $0004) <> 0);
    SetDTSStatusChannel('I_FAN_ON', (StatusWord and $0008) <> 0);
  end;
  if ReadDTSHoldingWord(5001, StatusWord) then
  begin
    SetDTSStatusChannel('I_PLC_POWER_LIFE_TIME_LOW_ALARM',
      (StatusWord and $0001) <> 0);
    SetDTSStatusChannel('I_SMPS01_BATTERY_LOW_ALARM',
      (StatusWord and $0002) <> 0);
    SetDTSStatusChannel('I_SMPS01_LIFE_TIME_LOW_ALARM',
      (StatusWord and $0004) <> 0);
    SetDTSStatusChannel('I_SMPS02_BATTERY_LOW_ALARM',
      (StatusWord and $0008) <> 0);
    SetDTSStatusChannel('I_SMPS02_LIFE_TIME_LOW_ALARM',
      (StatusWord and $0010) <> 0);
    SetDTSStatusChannel('I_DOOR_OPEN_01_ALARM',
      (StatusWord and $0020) <> 0);
  end;
end;

procedure THAL.SetDTSStatusChannel(const AName: string;
  const AValue: Boolean);
var
  Channel: TfoChannel;
begin
  Channel := IOServer.Channels.SilentFind(AName);
  if not Assigned(Channel) or (Channel.AsBoolean = AValue) then Exit;
  Channel.AsBoolean := AValue;
end;

procedure THAL.SetDTSConnectionState(const AConnected: Boolean);
begin
  if not FDTSProjectReady then
  begin
    SetDTSStatusChannel(S_DTS_CONNECTED, AConnected);
    FDTSConnectionKnown := False;
    Exit;
  end;
  if FDTSConnectionKnown and
     (IOServer.AsBoolean[S_DTS_CONNECTED] = AConnected) then Exit;
  SetDTSStatusChannel(S_DTS_CONNECTED, AConnected);
  FDTSConnectionKnown := True;
  if AConnected then
    AlarmManager.ReleaseAlarm(ERR_DTS_COMMUNICATION_LOST)
  else
    Machine.AddAlarm(ERR_DTS_COMMUNICATION_LOST);
end;

procedure THAL.ClearDTSStatusChannels;
begin
  SetDTSStatusChannel('I_CPU_RUN', False);
  SetDTSStatusChannel('I_ALARM_STATUS', False);
  SetDTSStatusChannel('I_EMERGENCY_STATUS', False);
  SetDTSStatusChannel('I_FAN_ON', False);
  SetDTSStatusChannel('I_PLC_POWER_LIFE_TIME_LOW_ALARM', False);
  SetDTSStatusChannel('I_SMPS01_BATTERY_LOW_ALARM', False);
  SetDTSStatusChannel('I_SMPS01_LIFE_TIME_LOW_ALARM', False);
  SetDTSStatusChannel('I_SMPS02_BATTERY_LOW_ALARM', False);
  SetDTSStatusChannel('I_SMPS02_LIFE_TIME_LOW_ALARM', False);
  SetDTSStatusChannel('I_DOOR_OPEN_01_ALARM', False);
end;

procedure THAL.MotionLog(Sender: TObject; const ALog: string);
begin
  Logger.FireLog(ltMessage, ALog, [ldFile]);
end;

procedure THAL.SysServerChannelChanged(Sender: TObject; AChannel: TfoChannel);
begin
  if Equipment.ConfigurationLoaded and (AChannel <> nil) then
  begin
    Logger.FireLog(ltInfo, Format('SYS : %s -> %s', [AChannel.Name, AChannel.AsString]), [ldFile]);
    if (Pos('DTS_PIPE_', UpperCase(AChannel.Name)) = 1) and
       ((Pos('_START_ADDRESS', UpperCase(AChannel.Name)) > 0) or
        (Pos('_READ_QUANTITY', UpperCase(AChannel.Name)) > 0)) then
      if FDTSProjectReady then
        ReconfigureDTSCommunication;
  end;

end;

function THAL.DTSCommFinalize: Boolean;
begin
	FDTSWatchdogTimer.Enabled := False;
  FDTSLastResponseTick := 0;
	if not Assigned(FDTSControl) then
  begin
    SetDTSConnectionState(False);
    Result := True;
    Exit;
  end;
	FDTSControl.Monitoring := False;
	FDTSControl.Enabled := False;
  FDTSControl.Disconnect;
  FDTSControl.ClearHoldingWords;
  ClearDTSStatusChannels;
  SetDTSConnectionState(False);
  Result := True;
end;

function THAL.DTSCommInitialize: Boolean;
var
  I, PacketIndex, StartAddress, ReadQuantity, Remaining,
    PacketQuantity: Integer;
  Packet: TfoModbusPacket;
begin
  Result := False;
  IOServer.AsBoolean[S_DTS_CONNECTED] := False;

  FDTSControl.Tag := 0;
  FDTSControl.Name := 'DTSControl';
  FDTSControl.Host := SysServer.AsString[S_DTS_CONTROL_HOST];
  FDTSControl.Port := SysServer.AsString[S_DTS_CONTROL_PORT];
  FDTSControl.AutoReconnect := True;
  FDTSControl.ReconnectInterval := 5000;
  { Packet and Channel addresses use the one-based 4xxxx notation shown to
    the operator.  The TCP encoder alone converts them to zero-based wire
    addresses.  Keeping the packet address unchanged lets inherited Channel
    updates and the direct holding-word cache reference the same register. }
  FDTSControl.RegisterAddressOffset := 1;
  FDTSControl.DataServer := IOServer;
  FDTSControl.MonitorInterval := 20;
  FDTSControl.Synchronize := False;
  FDTSControl.TransactionTimeout := 1000;
  FDTSControl.TransactionRetryCount := 10;

  FDTSControl.ClearHoldingWords;
  FDTSControl.PacketsToRead.Clear;
  Packet := FDTSControl.PacketsToRead.Add;
  Packet.Name := 'DTS_STATUS';
  Packet.Enabled := True;
  Packet.FunctionCode := mfcReadHoldingRegisters;
  Packet.GroupIndex := 0;
  Packet.SlaveAddress := 1;
  Packet.StartingAddress := 5000;
  Packet.Quantity := 2;
  PacketIndex := 1;
  for I := 0 to Min(FDTSProjectPipeCount, 10) - 1 do
  begin
    StartAddress := SysServer.AsInteger[
      Format('DTS_PIPE_%.3d_START_ADDRESS', [I + 1])];
    ReadQuantity := SysServer.AsInteger[
      Format('DTS_PIPE_%.3d_READ_QUANTITY', [I + 1])];
    if (StartAddress <= 0) or (ReadQuantity <= 0) or
       (StartAddress + ReadQuantity > 65536) then
      Continue;
    Remaining := ReadQuantity;
    while Remaining > 0 do
    begin
      PacketQuantity := Min(100, Remaining);
      Packet := FDTSControl.PacketsToRead.Add;
      Packet.Name := Format('DTS_%.3d', [PacketIndex + 1]);
      Packet.Enabled := True;
      Packet.FunctionCode := mfcReadHoldingRegisters;
      Packet.GroupIndex := PacketIndex;
      Packet.SlaveAddress := 1;
      Packet.StartingAddress := StartAddress +
        (ReadQuantity - Remaining);
      Packet.Quantity := PacketQuantity;
      Inc(PacketIndex);
      Dec(Remaining, PacketQuantity);
    end;
    CodeSite.Send(Format(
      'DTS Modbus pipe configured | PipeIndex=%d Start=%d Quantity=%d',
      [I + 1, StartAddress, ReadQuantity]));
  end;
  if PacketIndex = 0 then
  begin
    CodeSite.SendError('No valid DTS pipe Modbus settings in SysServer');
    Exit;
  end;

  FDTSControl.OnSlaveResponded := DTSControlSlaveResponded;
  FDTSControl.OnMaybeDead := DTSControlMaybeDead;
  FDTSControl.OnLog := DTSControlLog;
  FDTSControl.OnCommunicationError := DTSControlCommunicationError;

  CodeSite.SendFmtMsg('DTS Modbus TCP connect [%s:%s]',
    [FDTSControl.Host, FDTSControl.Port]);
  FDTSControl.Enabled := True;
  FDTSControl.Monitoring := True;
  FDTSLastResponseTick := GetTickCount64;
  FDTSWatchdogTimer.Enabled := True;
  Result := True;
end;

function THAL.ReconfigureDTSCommunication: Boolean;
var
  ProjectReady: Boolean;
begin
  ProjectReady := FDTSProjectReady;
  FDTSProjectReady := False;
  DTSCommFinalize;
  FDTSProjectReady := ProjectReady;
  Result := FDTSProjectReady and DTSCommInitialize;
end;

procedure THAL.BeginProjectCommunicationLoad;
begin
  FDTSProjectReady := False;
  FDTSProjectPipeCount := 0;
  FDTSWatchdogTimer.Enabled := False;
  FDTSLastResponseTick := 0;
  DTSCommFinalize;
end;

function THAL.StartProjectCommunication(const APipeCount: Integer): Boolean;
begin
  FDTSProjectPipeCount := Min(Max(APipeCount, 0), 10);
  FDTSProjectReady := True;
  Result := ReconfigureDTSCommunication;
end;

function THAL.ReadDTSHoldingWord(const AAddress: Integer;
  out AValue: Word): Boolean;
begin
  Result := Assigned(FDTSControl) and
    FDTSControl.ReadHoldingWord(AAddress, AValue);
end;

procedure THAL.ChannelCheckerCompletionError(Sender: TObject;
  const AWaitChannel, AWaitValue: string; const AErrorCode: Integer);
begin
  Equipment.FireError(AErrorCode);
end;

procedure THAL.CreateDIO();
begin
//  ADIO := TfoWMX3DIODevice.Create(self);
//  with TfoWMX3DIODevice(ADIO) do
//  begin
//    Synchronize := False;
//    MonitorInterval := 10;
//    DataServer := IOServer;
//    Name := AName;
//    DisplayName := AName;
//  end;

end;

end.








