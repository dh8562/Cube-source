unit foWMX3Base;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.SyncObjs,
  Codesitelogging,
  uvisWMX3Dll;

function foWMX3Initialize(
  const AWMXPath: string;
  const nRetry : Integer;
  out AWmxHandle: VWHANDLE;
  out ASlaveCount: Integer
): Boolean;

procedure foWMX3Finalize(var AWmxHandle: VWHANDLE);

function foWMX3CheckResult(const AResult: Integer): Boolean;
function foWMX3LastError(AWmxHandle: VWHANDLE): string;

function foWMX3Handle: VWHANDLE;
function foWMX3SlaveCount: Integer;
function foWMX3IsInitialized: Boolean;
function foWMX3InitializeCount: Integer;

implementation

var
  GLock: TCriticalSection;
  GWmxHandle: VWHANDLE = nil;
  GWmxPath: string = 'C:\Program Files\SoftServo\WMX3\';
  GSlaveCount: Integer = 0;
  GInitializeCount: Integer = 0;

function foWMX3CheckResult(const AResult: Integer): Boolean;
begin
  Result := (AResult = 0);
end;

function foWMX3Handle: VWHANDLE;
begin
  GLock.Enter;
  try
    Result := GWmxHandle;
  finally
    GLock.Leave;
  end;
end;

function foWMX3SlaveCount: Integer;
begin
  GLock.Enter;
  try
    Result := GSlaveCount;
  finally
    GLock.Leave;
  end;
end;

function foWMX3IsInitialized: Boolean;
begin
  GLock.Enter;
  try
    Result := (GWmxHandle <> nil);
  finally
    GLock.Leave;
  end;
end;

function foWMX3InitializeCount: Integer;
begin
  GLock.Enter;
  try
    Result := GInitializeCount;
  finally
    GLock.Leave;
  end;
end;

function foWMX3Initialize(
  const AWMXPath: string;
  const nRetry : Integer;
  out AWmxHandle: VWHANDLE;
  out ASlaveCount: Integer
): Boolean;
var
  Ret: Integer;
  AnsiPath: AnsiString;
  NewHandle: VWHANDLE;
begin
  Result := False;
  AWmxHandle := nil;
  ASlaveCount := 0;

  GLock.Enter;
  try
    // 이미 초기화되어 있으면 아래 Create/Init/Start/Scan/Build는 실행하지 않는다.
    if GWmxHandle <> nil then
    begin
      Inc(GInitializeCount);

      AWmxHandle := GWmxHandle;
      ASlaveCount := GSlaveCount;

    	Codesite.Send('foWMX3Initialize, Already initialize');
      Exit(True);
    end;

    // 여기부터는 최초 1회만 실행된다.
    NewHandle := vwWMXCreate;
    if NewHandle = nil then
      Exit;

    if AWMXPath <> '' then
      AnsiPath := AnsiString(AWMXPath)
    else
      AnsiPath := AnsiString(GWmxPath);

    Ret := vwWMXInitEngine(NewHandle, PAnsiChar(AnsiPath));
    if not foWMX3CheckResult(Ret) then
    begin
    	Codesite.SendError('foWMX3Initialize, vwWMXInitEngine error ');
      //vwWMXDestroy(NewHandle);
      Exit;
    end;

    Ret := vwWMXStartCommunication(NewHandle, nRetry);
    if not foWMX3CheckResult(Ret) then
    begin
    	Codesite.SendError('foWMX3Initialize, vwWMXStartCommunication error ');
//      vwWMXCloseEngine(NewHandle);
//      vwWMXDestroy(NewHandle);
      Exit;
    end;

    GWmxHandle := NewHandle;
    GWmxPath := AWMXPath;
    GInitializeCount := 1;

    Codesite.SendFmtMsg('foWMX3Initialize : %s', [AnsiPath]);

    AWmxHandle := GWmxHandle;
    ASlaveCount := GSlaveCount;

    Result := True;
  finally
    GLock.Leave;
  end;
end;

procedure foWMX3Finalize(var AWmxHandle: VWHANDLE);
var
  HandleToClose: VWHANDLE;
begin
  HandleToClose := nil;

  GLock.Enter;
  try
    if (AWmxHandle = nil) or (GWmxHandle = nil) then
    begin
      AWmxHandle := nil;
      Exit;
    end;

    // 공유 Handle이 아닌 값은 닫지 않는다.
    if AWmxHandle <> GWmxHandle then
    begin
      AWmxHandle := nil;
      Exit;
    end;

    if GInitializeCount > 0 then
      Dec(GInitializeCount);

    AWmxHandle := nil;

    // 마지막 IO Device가 Finalize할 때만 실제 WMX 종료 처리한다.
    if GInitializeCount = 0 then
    begin
      HandleToClose := GWmxHandle;
      GWmxHandle := nil;
      GWmxPath := '';
      GSlaveCount := 0;
    end;
  finally
    GLock.Leave;
  end;

  if HandleToClose <> nil then
  begin
    vwWMXStopCommunication(HandleToClose);
    vwWMXCloseEngine(HandleToClose);
    vwWMXDestroy(HandleToClose);
  end;
end;

function foWMX3LastError(AWmxHandle: VWHANDLE): string;
begin
  if AWmxHandle = nil then
    AWmxHandle := foWMX3Handle;

  if AWmxHandle = nil then
    Result := 'WMX is not initialized'
  else
    Result := GetWMXLastError(AWmxHandle);
end;

initialization
  GLock := TCriticalSection.Create;

finalization
  // 비정상 종료 또는 Finalize 누락 방지용 최종 정리.
  if GWmxHandle <> nil then
  begin
    vwWMXStopCommunication(GWmxHandle);
    vwWMXCloseEngine(GWmxHandle);
    vwWMXDestroy(GWmxHandle);
    GWmxHandle := nil;
  end;

  GLock.Free;

end.

