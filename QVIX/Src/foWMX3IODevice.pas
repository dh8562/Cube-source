unit foWMX3IODevice;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  Codesitelogging,

  foTypes,
  foBits,
  foDataServer,

  uvisWMX3Dll,
  foWMX3Base;

type
  TfoWMX3DIODevice = class(TfoCustomMonitoringDevice)
  private
    FConnected: Boolean;
    FWMXPath: string;
    FSlaveNo: Integer;
    FModuleId: Integer;
    FSlaveCount: Integer;
    FConnectRetry: Integer;

    function GetBoolChannelValue(AChannel: TfoChannel): Integer;
    function GetChannelBitNo(AChannel: TfoChannel): Integer;
    function GetConnected: Boolean;
  protected
    function DoInitialize: Boolean; override;
    function DoFinalize: Boolean; override;
    procedure DoMonitor; override;
    procedure DoChannelWrite(AChannel: TfoChannel; var AProcessed: Boolean); override;

    procedure UpdateChannel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AllOutChannelOff;


  published
    property WMXPath: string read FWMXPath write FWMXPath;
    property SlaveNo: Integer read FSlaveNo write FSlaveNo default 0;
    property ModuleId: Integer read FModuleId write FModuleId default 0;
    property Connected: Boolean read GetConnected;
    property SlaveCount: Integer read FSlaveCount;
    property ConnectRetry : Integer read FConnectRetry write FConnectRetry;
  end;

implementation

{ TfoWMX3DIODevice }

procedure TfoWMX3DIODevice.AllOutChannelOff;
var
  NIndex: Integer;
  Channel: TfoChannel;
  Ret, Ret2: Integer;
  nValue, nValue2: Integer;
  BitNo: Integer;
begin
  NIndex := 0;
  while NIndex < ChannelList.Count do
  begin
    Channel := TfoChannel(ChannelList[NIndex]);

    with Channel do
    begin
      if (Device = Self.Name) and
      	 (Address <> -1) and
         (ChannelKind = ckOutput) then
      begin
        case DataType of
          dtBoolean:
          begin
            AsBoolean := False;
          end;
        end;
      end;
    end;
    Inc(NIndex);
  end;

end;

constructor TfoWMX3DIODevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FConnected := False;
  FWMXPath := '';
  FSlaveNo := 0;
  FModuleId := 0;
  FSlaveCount := 0;
end;

destructor TfoWMX3DIODevice.Destroy;
begin
  if FConnected then
    DoFinalize;

  inherited Destroy;
end;

function TfoWMX3DIODevice.GetChannelBitNo(AChannel: TfoChannel): Integer;
begin
  // 기존 Ezi IO 소스에서 BrowseInfo를 bit 번호로 사용했으므로 그대로 유지한다.
  Result := AChannel.BrowseInfo;
end;

function TfoWMX3DIODevice.GetConnected: Boolean;
var
  WmxHandle: VWHANDLE;
	State: Integer;
begin
  FConnected := False;
  Result := FConnected;

  WmxHandle := foWMX3Handle;
  if WmxHandle = nil then exit;

	vwWMXGetEngineStatus(WmxHandle, State);
  FConnected := State = Ord(VW_WMX_ENGINE_COMMUNICATING);
  Result := FConnected;
end;

function TfoWMX3DIODevice.GetBoolChannelValue(AChannel: TfoChannel): Integer;
begin
  Result := 0;

  case AChannel.DataType of
    dtBoolean:
      begin
        if AChannel.InvertBoolean then
          Result := Ord(not AChannel.AsBoolean)
        else
          Result := Ord(AChannel.AsBoolean);
      end;

    dtByte:
      Result := Ord(AChannel.AsByte <> 0);

    dtShortInt:
      Result := Ord(AChannel.AsShortInt <> 0);

    dtSmallInt:
      Result := Ord(AChannel.AsSmallInt <> 0);

    dtInteger:
      Result := Ord(AChannel.AsInteger <> 0);

    dtWord:
      Result := Ord(AChannel.AsWord <> 0);

    dtLongWord:
      Result := Ord(AChannel.AsLongWord <> 0);
  end;
end;

procedure TfoWMX3DIODevice.DoChannelWrite(AChannel: TfoChannel; var AProcessed: Boolean);
var
  Ret: Integer;
  BitNo: Integer;
  Value: Integer;
begin
  if (csDesigning in ComponentState) or
     (csLoading in ComponentState) or
     (csReading in ComponentState) or
     (csDestroying in ComponentState) then
    Exit;

  if not FConnected then
    Exit;

  with AChannel do
  begin
    if (Device = Self.Name) and (Address <> -1) and (ChannelKind = ckOutput) then
    begin
      BitNo := GetChannelBitNo(AChannel);
      Value := GetBoolChannelValue(AChannel);

      Ret := vwWMXWriteDOBit(foWMX3Handle, Address, BitNo, Value);
      if not foWMX3CheckResult(Ret) then
      begin
        // CodeSite.SendError('DoChannelWrite: vwWMXWriteDO Fail - ' + foWMX3LastError(foWMX3Handle));
      end;

      AProcessed := True;
    end;
  end;

  inherited DoChannelWrite(AChannel, AProcessed);
end;

function TfoWMX3DIODevice.DoFinalize: Boolean;
var
  WmxHandle: VWHANDLE;
begin
  Monitoring := False;
  FConnected := False;

  WmxHandle := foWMX3Handle;
  foWMX3Finalize(WmxHandle);

  Result := True;
end;

function TfoWMX3DIODevice.DoInitialize: Boolean;
var
  Ret: Integer;
  WmxHandle: VWHANDLE;
begin
  if FConnected then
    Exit(True);

  Result := False;
  FConnected := False;
  FSlaveCount := 0;

  if foWMX3Initialize(FWMXPath,  FConnectRetry, WmxHandle, FSlaveCount) then
  begin
  	CodeSite.SendFmtMsg('TfoWMX3DIODevice.DoInitialize [%s, %d] ok',[FWMXPath, FConnectRetry]);
    FConnected := True;
    Monitoring := True;
    Result := True;
  end;
end;

procedure TfoWMX3DIODevice.DoMonitor;
begin
  inherited;

  try
    if Synchronize then
      SynchronizeMethod(UpdateChannel)
    else
      UpdateChannel;
  finally
  end;
end;

procedure TfoWMX3DIODevice.UpdateChannel;
var
  NIndex: Integer;
  Channel: TfoChannel;
  Ret, Ret2: Integer;
  nValue, nValue2: Integer;
  BitNo: Integer;
begin
  if (csDesigning in ComponentState) or
     (csLoading in ComponentState) or
     (csReading in ComponentState) or
     (csDestroying in ComponentState) then
    Exit;

  if not FConnected then
    Exit;

  NIndex := 0;
  while NIndex < ChannelList.Count do
  begin
    if not MonitorTimer.Enabled then
      Break;

    Channel := TfoChannel(ChannelList[NIndex]);

    with Channel do
    begin
      if (Device = Self.Name) and
      	 (Address <> -1) and
         (ChannelKind = ckInput) then
      begin
        case DataType of
          dtBoolean:
          begin
            BitNo := GetChannelBitNo(Channel);
            Ret := vwWMXReadDIBit(foWMX3Handle, Address, BitNo, nValue);
            if foWMX3CheckResult(Ret) then
            begin
              if InvertBoolean then AsBoolean := (nValue = 0)
              else AsBoolean := (nValue <> 0);
            end
            else
            begin
              CodeSite.SendError('UpdateChannel: vwWMXReadDIBit Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtByte:
          begin
            Ret := vwWMXReadDIByte(foWMX3Handle, Address, nValue);
            if foWMX3CheckResult(Ret) then
            begin
            	AsByte := Byte(nValue);
            end
            else
            begin
            	CodeSite.SendError('UpdateChannel: vwWMXReadDIByte Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtShortInt:
          begin
            Ret := vwWMXReadDIByte(foWMX3Handle, Address, nValue);
            if foWMX3CheckResult(Ret) then
            begin
            	AsShortInt := ShortInt(nValue);
            end
            else
            begin
            	CodeSite.SendError('UpdateChannel: vwWMXReadDIByte Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtSmallInt:
          begin
            Ret := vwWMXReadDIByte(foWMX3Handle, Address, nValue);
            if foWMX3CheckResult(Ret) then
            begin
            	AsSmallInt := SmallInt(nValue);
            end
            else
            begin
            	CodeSite.SendError('UpdateChannel: vwWMXReadDIByte Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtInteger:
          begin
            Ret := vwWMXReadDIByte(foWMX3Handle, Address, nValue);
            Ret2 := vwWMXReadDIByte(foWMX3Handle, Address+1, nValue2);
            if foWMX3CheckResult(Ret) and foWMX3CheckResult(Ret2) then
            begin
							AsInteger := Integer((nValue and $FF) or ((nValue2 and $FF) shl 8));
            end
            else
            begin
            	CodeSite.SendError('UpdateChannel-dtWord : vwWMXReadDIByte Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtWord:
          begin
            Ret := vwWMXReadDIByte(foWMX3Handle, Address, nValue);
            Ret2 := vwWMXReadDIByte(foWMX3Handle, Address + 1, nValue2);
            if foWMX3CheckResult(Ret) and foWMX3CheckResult(Ret2) then
            begin
							AsWord := Word((nValue and $FF) or ((nValue2 and $FF) shl 8));
            end
            else
            begin
            	CodeSite.SendError('UpdateChannel-dtWord : vwWMXReadDIByte Fail - ' + foWMX3LastError(foWMX3Handle));
            end;
          end;

          dtLongWord:
            AsLongWord := LongWord(nValue);
        end;
      end;
    end;

    Inc(NIndex);
  end;
end;

end.

