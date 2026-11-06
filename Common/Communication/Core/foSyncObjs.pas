{
  동기화 객체만 사용하기 위해 수정함.
  JCL의 Optex 개체
}
unit foSyncObjs;

{$I foCompilerDefines.inc}

interface

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF MSWINDOWS}
  System.SysUtils,
  System.SyncObjs;

type
  PfoOptexSharedInfo = ^TfoOptexSharedInfo;
  TfoOptexSharedInfo = record
    LockCount: Integer;
    ThreadId: Longword;
    RecursionCount: Integer;
  end;

  {@@TfoOptex
    Summary
    OPTEX(Optimized Mutex) 쓰레드 동기화 객체
    Description
    OPTEX에 대한 자세한 사항은 <extlink http://www.microsoft.com/msj/archive/S1DA0.aspx>MSJ
    1996 July Q&amp;A</extlink> 를 참조.
  }
  TfoOptex = class(TObject)
  private
    FLockCount: Integer;
    FThreadId: Longword;
    FRecurseCount: Integer;
    FEvent: TEvent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Enter;
    procedure Leave;
  end;

procedure foLock;
procedure foUnlock;

implementation

var
  OptexInstance : TfoOptex;

{ TfoOptex }

constructor TfoOptex.Create;
begin
  FLockCount := -1;
  FThreadId := 0;
  FRecurseCount := 0;
  FEvent := TEvent.Create(nil, False, False, '');
end;

destructor TfoOptex.Destroy;
begin
  FreeAndNil(FEvent);
  inherited Destroy;
end;

procedure TfoOptex.Enter;
var
  ThreadId: Longword;
begin
  ThreadId := Winapi.Windows.GetCurrentThreadId;
  if Winapi.Windows.InterlockedIncrement(FLockCount) = 0 then
  begin
    // No thread owns the OPTEX
    FThreadId := ThreadId; // We own it
    FRecurseCount := 1;    // We own it once
  end
  else
  begin
    if FThreadId = ThreadId then
    begin
      // We already owned it, increase ownership count
      Inc(FRecurseCount);
    end
    else
    begin
      // Optex is owner by someone else, wait for it to be released and then
      // immediately take ownership
      FEvent.WaitFor(INFINITE);
      FThreadId := ThreadId;
      FRecurseCount := 1;
    end;
  end;
end;

procedure TfoOptex.Leave;
begin
  Dec(FRecurseCount);
  if FRecurseCount > 0 then
    Winapi.Windows.InterlockedDecrement(FLockCount)
  else
  begin
    FThreadId := 0;
    if Winapi.Windows.InterlockedDecrement(FLockCount) >= 0 then
      FEvent.SetEvent;
  end;
end;

procedure foLock;
begin
  OptexInstance.Enter;
end;

procedure foUnlock;
begin
  OptexInstance.Leave;
end;

initialization
  OptexInstance := TfoOptex.Create;

finalization
  OptexInstance.Free;

end.
