{@@
  Description:
    비동기 시리얼 통신 콤포넌트

  History:
  <TABLE>
  일자         변경 내용
  -----------  ---------------------------------------------------------
  1997.05.15   Start
  1997.05.19   1차 버전 완료
  1997.06.02   -. ReadString이나 WriteComm등은 Pascal Style String을
                  쓰기 때문에 Null Character는 송수신 할 수 없다.
                  그래서 Null Character($00)을 송수산하기 위해서 SendCharArray
                  , ReadCharArray function을 추가 했다.
               -. DCB Setting과 관련해서 DiscardNull, BinaryMode,
                  CheckParity property를 추가해서 사용자가 임의로 설정할
                   수 있게 했다.
               -. SetCommMask에서 사용할 Comm Event Mask를 Set property로
                  설정할 수 있게 변경함.
  1997.07.28   -. ClearBuffer procedure 추가
  1998.09.08   -. InQueue ReadOnly property 추가
  1998.09.15   -. WaitEventChar function 추가
                  TEvent Object를 사용하지 않고 내부 변수를 사용해서
                  기다린다.
               -. Read, Write function 추가 (인자가 PChar나 String이 아니고
                  Untyped Pointer이다)
  2005.10.10   -. CloseComm시 상황에 따라 A/V에러가 나는 문제를 수정
  2005.11.07   -. SetDTRState, SetRTSState 함수 추가
               -. DTRState, RTSState 읽기 전용 프로퍼티 추가
  </TABLE>
}
unit foCommEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Registry;


const
  CBR_460800  = $70800;
  CBR_921600  = $E1000;

type
  {@@
    통신 포트
  }
  TfocPort = (
    COM01, COM02, COM03, COM04, COM05, COM06, COM07, COM08,
    COM09, COM10, COM11, COM12, COM13, COM14, COM15, COM16,
    COM17, COM18, COM19, COM20, COM21, COM22, COM23, COM24,
    COM25, COM26, COM27, COM28, COM29, COM30, COM31, COM32,
    COM33, COM34, COM35, COM36, COM37, COM38, COM39, COM40
  );

  {@@
    전송 속도
  }
  TfocBaudRate = (
    ___2400,
    ___4800, 
    ___9600, 
    __14400, 
    __19200, 
    __38400, 
    __56000, 
    __57600, 
    _115200, 
    _128000,
    _256000,
    _460800,
    _921600
  );
  
  {@@
    패리티
  }
  TfocParity = (
    cpNone, 
    cpOdd,
    cpEven,
    cpMark,
    cpSpace
  );

  {@@
    데이터 크기
  }
  TfocByteSize = (
    _7,
    _8
  );

  {@@
    정지 비트
  }
  TfocStopBits = (
    _1,
    _1_5,
    _2
  );

  {@@
    흐름 제어 방법
  }
  TfocFlowControl = (
    cfcNone,
    cfcXonXoff,
    cfcRtsCts,
    cfcDtrDsr
  );

  {@@
    시리얼 드라이버에서 발생 가능한 통신 이벤트
  }
  TfocCommEvent = (
    cceRxChar,
    cceRxFlag,
    cceTxEmpty,
    cceCts,
    cceDsr,
    ccwRlsd,
    cceBreak,
    cceErr,
    cceRing
  );

const
  CM_EVENTCHAR_RECEIVED = CM_BASE + 2000;
  CM_CHAR_RECEIVED = CM_BASE + 2001;
  CM_COMM_EVENTS = CM_BASE + 2002;

type

  {@@
    시리얼 드라이버에서 발생 가능한 통신 이벤트의 집합
  }
  TfocCommEvents  = set of TfocCommEvent;

  TfoNotifyMsg = procedure (Sender: TObject; Msg : String) of object;
  TfoNotifyError = procedure (Sender: TObject; ErrCode : Integer; ErrDesc : String) of object;
  TfoNotifyAlarm = procedure (Sender: TObject; AlarmCode : Integer) of object;
  TfoNotifyStatusChange = procedure (Sender : Tobject; State : Boolean) of object;
  TfoNotifyCommEvents = procedure (Sender : Tobject; dwCommEvent : DWORD) of object;
  TfoNotifyReceiveEvent = procedure (Sender : Tobject; const ACount : Integer) Of object;

  TfoCustomComm = class;

  {@@
    시리얼 드라이버의 각종 이벤트를 감시하는 쓰레드 객체
  }
  TfoCommReadThread = class(TThread)
  private
    FEventMask : DWORD;
    FComm : TfoCustomComm;

    function ThreadTerminated : Boolean;
    procedure DoCommEvent;
  protected
    procedure Execute; override;
  end;

  {@@
    시리얼 통신 콤포넌트
  }
  TfoCustomComm = class(TComponent)
  private
    FCommTimeouts   : TCommTimeouts;
    FComStat        : TComStat;
    FDCB            : TDCB;
    FEventMask      : DWORD;
    FHandle         : THandle;
    FOVRead, FOVWrite : TOverlapped;
    FPortOpened     : Boolean;
    FReadThread : TfoCommReadThread;
    FReadThreadPriority : TThreadPriority;
    FWaitingEventChar : Boolean;
    FRTSState: Boolean;
    FDTRState: Boolean;
    FWindowHandle : THandle;

    FBaudRate       : TfocBaudRate;
    FBinaryMode     : Boolean;
    FByteSize       : TfocByteSize;
    FCheckParity    : Boolean;
    FCommEvents      : TfocCommEvents;
    FDiscardNull    : Boolean;
    FEventChar      : AnsiChar;
    FFlowControl    : TfocFlowControl;
    FMaxInQueue     : DWORD;
    FMaxOutQueue    : DWORD;
    FParity         : TfocParity;
    FPort           : TfocPort;
    FPortNo         : Integer;
    FStopBits       : TfocStopBits;
    FTimeout        : DWORD;
    FRS485Mode: Boolean;
    FReceivedBytesThreshold: Cardinal;

    FOnCommError    : TfoNotifyError;
    FOnCommEvents   : TfoNotifyCommEvents;
    FOnEventCharReceived     : TfoNotifyReceiveEvent;
    FOnMessage      : TfoNotifyMsg;
    FOnOpenStatus   : TfoNotifyStatusChange;
    FOnReceived     : TfoNotifyReceiveEvent;
    FOnRXStatus     : TfoNotifyStatusChange;
    FOnTXStatus     : TfoNotifyStatusChange;

    function GetBaudRate : TfocBaudRate;
    function GetByteSize : TfocByteSize;
    function GetInQueue : DWORD;
    function GetParity : TfocParity;
    function GetPort : TfocPort;
    function GetStopBits : TfocStopBits;

    procedure SetBaudRate(Value : TfocBaudRate);
    procedure SetByteSize(Value : TfocByteSize);
    procedure SetCommEvents(Value : TfocCommEvents);
    procedure SetFlowControl(Value : TfocFlowControl);
    procedure SetParity(Value : TfocParity);
    procedure SetPort(Value : TfocPort);
    procedure SetStopBits(Value : TfocStopBits);
    procedure SetThreadPriority(Value : TThreadPriority);
    procedure SetTimeout(Value : DWORD);

    function InitDCB  : Boolean;
    function InitTimeout  : Boolean;
    procedure FireCommError(const AErrCode : Integer; const AErrDesc : String);
    procedure FireEventCharReceived(const ACount : Integer);
    procedure FireReceived(const ACount : Integer);
    procedure ProcessCommError(dwCommError : DWORD);
    procedure ReadThreadTerminateProc(Sender : Tobject);
    function GetPortNo: Cardinal;
    procedure SetPortNo(const Value: Cardinal);
    function GetPortName: string;
  protected
    { Protected declarations }
    procedure WndProc(var Message: TMessage); virtual;

    procedure FireCommEvents(dwCommEvents : DWORD);
    procedure FireMessage(const AMsg : String);
    procedure FireRXStatus(Value : Boolean);
    procedure FireTXStatus(Value : Boolean);

    property WindowHandle : THandle read FWindowHandle;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure ClearBuffer;
    function CloseComm : Boolean;
    function ConfigDialog : Boolean;
    function OpenComm : Boolean;
    function Read(var ABuffer; const ACount : Cardinal) : Integer;
    function ReadString : AnsiString;
    function WaitEventChar : Boolean; overload;
    function WaitEventChar(const ATimeout : Integer) : Boolean; overload;
    function Write(const ADataToSend; const ACount : Cardinal) : Integer;
    function WriteChar(const ADataToSend : PAnsiChar; const ACount : Cardinal; var AWrittenBytes : Cardinal) : Boolean;
    function WriteString(const ADataToSend : AnsiString) : Boolean;
    function SetDTRState(const AOnOff : Boolean) : Boolean;
    function SetRTSState(const AOnOff : Boolean) : Boolean;


    {@@
      통신 포트의 파일 핸들
    }
    property Handle : THandle read FHandle;

    {@@
      통신 드라이버의 수신 버퍼에 수신된 데이터의 길이
    }
    property InQueue : DWORD read GetInQueue;

    {@@
      통신 포트의 활성화 여부
    }
    property PortOpened : Boolean read FPortOpened;

    property PortName : string read GetPortName;

    {@@
      Summary
        DTR 신호의 상태
      Description
        마지막으로 설정한 DTR 신호의 상태
    }
    property DTRState : Boolean read FDTRState;

    {@@
      Summary
        RTS 신호의 상태
      Description
        마지막으로 설정한 RTS 신호의 상태
    }
    property RTSState : Boolean read FRTSState;

    {@@
      전송 속도
    }
    property BaudRate : TfocBaudRate read GetBaudRate write SetBaudRate default ___9600;

    {@@
      이진 모드
    }
    property BinaryMode : Boolean read FBinaryMode write FBinaryMode;

    {@@
      통신 바이트 크기
    }
    property ByteSize : TfocByteSize read GetByteSize write SetByteSize default _8;

    {@@
      송수신시 패리티 비트 체크 여부
    }
    property CheckParity : Boolean read FCheckParity write FCheckParity;

    {@@
      쓰레드에서 감시할 통신 에벤트
    }
    property CommEvents : TfocCommEvents read FCommEvents write SetCommEvents;

    {@@
      수신 버퍼에 들어 온 NULL 문자 삭제 여부
    }
    property DiscardNull : Boolean read FDiscardNull write FDiscardNull;

    {@@
      이벤트 문자
    }
    property EventChar : AnsiChar read FEventChar write FEventChar;

    {@@
      흐름 제어
    }
    property FlowControl : TfocFlowControl read FFlowControl write SetFlowControl default cfcNone;

    {@@
      통신 드라이버의 수신 버퍼 크기
    }
    property MaxInQueue : DWORD read FMaxInQueue write FMaxInQueue default 4096;

    {@@
      통신 드라이버의 송신 버퍼 크기
    }
    property MaxOutQueue : DWORD read FMaxOutQueue write FMaxOutQueue default 2048;

    {@@
      패리티 비트
    }
    property Parity : TfocParity read GetParity write SetParity default cpNone;

    {@@
      사용할 통신 포트
    }
    property Port : TfocPort read GetPort write SetPort default COM01;

    {@@
      사용할 통신 포트 번호
    }
    property PortNo : Cardinal read GetPortNo write SetPortNo default 1;

    {@@
      통신 이벤트 감시 쓰레드의 우선순위
    }
    property Priority : TThreadPriority read FreadThreadPriority write SetThreadPriority;

    {@@
      수신된 데이터의 량이 이 값을 넘을 경우에만 OnReceived 이벤트가 발생된다.
    }
    property ReceivedBytesThreshold : Cardinal read FReceivedBytesThreshold  write FReceivedBytesThreshold default 0;

    {@@
      Write하기 전에 RTS 신호를 켜고 Write가 완료되면 RTS 신호를 끈다.
    }
    property RS485Mode : Boolean read FRS485Mode write FRS485Mode default False;

    {@@
      정지 비트
    }
    property StopBits : TfocStopBits read GetStopBits write SetStopBits default _1;

    {@@
      송수신 시간 초과
    }
    property Timeout : DWORD read FTimeout write SetTimeout default 300;

    {@@
      통신 에러가 발생하면 발생하는 이벤트
    }
    property OnCommError : TfoNotifyError read FOnCommError write FOnCommError;

    {@@
      통신 이벤트가 발생할 때 마다 호출되는 이벤트
    }
    property OnCommEvents : TfoNotifyCommEvents read FOnCommEvents write FOnCommEvents;

    {@@
      이벤트 문자가 수신 버퍼에 들어오면 발생하는 이벤트
    }
    property OnEventCharReceived : TfoNotifyReceiveEvent read FOnEventCharReceived write FOnEventCharReceived;

    {@@
      일반적인 메시지 이벤트
    }
    property OnMessage : TfoNotifyMsg read FOnMessage write FOnMessage;

    {@@
      통신 포트의 오픈 상태
    }
    property OnOpenStatus : TfoNotifyStatusChange read FOnOpenStatus write FOnOpenStatus;

    {@@
      통신 드라이버의 수신 버퍼에 데이터가 들어 오면 발생하는 이벤트
    }
    property OnReceived : TfoNotifyReceiveEvent read FOnReceived write FOnReceived;

    {@@
      수신 상태
    }
    property OnRXStatus : TfoNotifyStatusChange read FOnRXStatus write FOnRXStatus;

    {@@
      송신 상태
    }
    property OnTXStatus : TfoNotifyStatusChange read FOnTXStatus write FOnTXStatus;
  end;

  {@@
    시리얼 통신 콤포넌트
  }
  TfoCommEx = Class(TfoCustomComm)
  published
    property BaudRate;
    property BinaryMode;
    property ByteSize;
    property CheckParity;
    property CommEvents;
    property DiscardNull;
    property EventChar;
    property FlowControl;
    property MaxInQueue;
    property MaxOutQueue;
    property Parity;
    property Port;
    property Priority;
    property ReceivedBytesThreshold;
    property RS485Mode;
    property StopBits;
    property Timeout;

    // Event Definition
    property OnCommError;
    property OnCommEvents;
    property OnEventCharReceived;
    property OnMessage;
    property OnOpenStatus;
    property OnReceived;
    property OnRXStatus;
    property OnTXStatus;
  end;

function foGetAvailableSerialPortNames : string;

implementation

const
  // constants For DCB Flags
  DCB_FLAG_BINARY               = $00000001;
  DCB_FLAG_PARITY               = $00000002;
  DCB_FLAG_OUTXCTSFLOW          = $00000004;
  DCB_FLAG_OUTXDSRFLOW          = $00000008;
  DCB_FLAG_DTRCONTROL           = $00000030;
  DCB_FLAG_DTRCONTROLDISABLE    = $00000000;
  DCB_FLAG_DTRCONTROLENABLE     = $00000010;
  DCB_FLAG_DTRCONTROLHANDSHAKE  = $00000020;
  DCB_FLAG_DSRSENSETIVITY       = $00000040;
  DCB_FLAG_TXCONTINUEONXofF     = $00000080;
  DCB_FLAG_OUTX                 = $00000100;
  DCB_FLAG_INX                  = $00000200;
  DCB_FLAG_ERRORCHAR            = $00000400;
  DCB_FLAG_NULL                 = $00000800;
  DCB_FLAG_RTSCONTROL           = $00003000;
  DCB_FLAG_RTSCONTROLDISABLE    = $00000000;
  DCB_FLAG_RTSCONTROLENABLE     = $00001000;
  DCB_FLAG_RTSCONTROLHANDSHAKE  = $00002000;
  DCB_FLAG_RTSCONTROLTOGGLE     = $00003000;
  DCB_FLAG_ABORTONERROR         = $00004000;
  DCB_FLAG_DUMMY                = $FFFF8000;

  XON_CHAR    = $11;
  XOFF_CHAR   = $13;

function foGetAvailableSerialPortNames: string;
var
  Reg : TRegistry;
  KeyList : TStringList;
  ValueList : TStringList;
  I: integer;
begin
  KeyList := nil;
  ValueList := nil;
  Reg := nil;
  try
    KeyList := TStringList.Create;
    ValueList := TStringList.Create;
    Reg := TRegistry.Create;

    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      Reg.GetValueNames(KeyList);
      for I := 0 to KeyList.Count - 1 do
        ValueList.Add(Reg.ReadString(KeyList[I]));
    end;

    ValueList.Sort;
    Result := ValueList.Text;
  finally
    FreeAndNil(KeyList);
    FreeAndNil(ValueList);
    FreeAndNil(Reg);
  end;
end;

procedure TfoCommReadThread.DoCommEvent;
begin
  if ThreadTerminated then Exit;
  if FComm.WindowHandle = INVALID_HANDLE_VALUE then Exit;

  if (FEventMask and EV_RXFLAG) = EV_RXFLAG then
  begin
    SendMessage(FComm.WindowHandle, CM_EVENTCHAR_RECEIVED, 0, FComm.InQueue);
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_RXFLAG);
  end;

  if (FEventMask and EV_RXCHAR) = EV_RXCHAR then
  begin
    if FComm.InQueue >= FComm.ReceivedBytesThreshold then
      SendMessage(FComm.WindowHandle, CM_CHAR_RECEIVED, 0, FComm.InQueue);

    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_RXFLAG);
  end;

  if (FEventMask and EV_BREAK) = EV_BREAK then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_BREAK);

  if (FEventMask and EV_CTS) = EV_CTS then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_CTS);

  if (FEventMask and EV_DSR) = EV_DSR then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_DSR);

  if (FEventMask and EV_ERR) = EV_ERR then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_ERR);

  if (FEventMask and EV_RING) = EV_RING then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_RING);

  if (FEventMask and EV_RLSD) = EV_RLSD then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_RLSD);

  if (FEventMask and EV_TXEMPTY) = EV_TXEMPTY then
    SendMessage(FComm.WindowHandle, CM_COMM_EVENTS, 0, EV_TXEMPTY);
end;

procedure TfoCommReadThread.Execute;
var
  ov : TOverlapped;
  WaitResult : Boolean;
begin
  FillMemory(@ov, Sizeof(ov), 0);
  ov.hEvent := CreateEvent(nil, True, False, nil);
  if ov.hEvent = INVALID_HANDLE_VALUE then
  begin
    FComm.FireMessage(SysErrorMessage(GetLastError));
    Exit;
  end;

  if not SetCommMask(FComm.FHandle, FComm.FEventMask) then
  begin
    FComm.FireMessage(SysErrorMessage(GetLastError));
    Exit;
  end;

  try
    while not ThreadTerminated do
    begin
      FEventMask := 0;
      WaitResult := WaitCommEvent(FComm.FHandle, FEventMask, @ov);
      if GetLastError = ERROR_IO_PENDING then
        WaitResult := (WaitForSingleObject(ov.hEvent, INFINITE) = WAIT_OBJECT_0);
        
      if not ThreadTerminated then
      begin
        if WaitResult then
          DoCommEvent
        else
          FComm.FireMessage(SysErrorMessage(GetLastError));
      end;
    end;
  finally
    CloseHandle(ov.hEvent);
  end;
end;

function TfoCommReadThread.ThreadTerminated : Boolean;
begin
  Result := Terminated or 
            (FComm = nil) or
            (not FComm.PortOpened) or
            (FComm.Handle = INVALID_HANDLE_VALUE);
end;

constructor TfoCustomComm.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  
  FHandle := INVALID_HANDLE_VALUE;
  FPortOpened := False;
  FPort := COM01;
  FPortNo := 1;
  FMaxInQueue := 4096;
  FMaxOutQueue := 2048;
  FTimeout := 300;
  FEventChar := AnsiChar(13);
  FBaudRate := ___9600;
  FByteSize := _8;
  FStopBits := _1;
  FParity := cpNone;
  FFlowControl := cfcNone;
  FDiscardNull := True;
  FCheckParity := False;
  FBinaryMode  := True;
  FWaitingEventChar := False;
  FRS485Mode := False;
  FReadThreadPriority := tpNormal;
  FReceivedBytesThreshold := 0;
  SetCommEvents([cceRxChar, cceRxFlag, cceTxEmpty]);

  FReadThread := nil;

  FOVRead.offset := 0;
  FOVRead.offsetHigh := 0;
  FOVRead.hEvent := CreateEvent(nil, True, False, nil);

  FOVWrite.offset := 0;
  FOVWrite.offsetHigh := 0;
  FOVWrite.hEvent := CreateEvent(nil, True, False, nil);

  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TfoCustomComm.Destroy;
begin
  CloseComm;

  CloseHandle(FOVRead.hEvent);
  CloseHandle(FOVWrite.hEvent);
  DeallocateHWND(Handle);
  inherited Destroy;
end;

procedure TfoCustomComm.SetCommEvents(Value : TfocCommEvents);
begin
  FCommEvents := Value;
  FEventMask:=0;
  if cceBreak in FCommEvents then FEventMask := FEventMask + EV_BREAK;
  if cceCts in FCommEvents then FEventMask := FEventMask + EV_CTS;
  if cceDsr in FCommEvents then FEventMask := FEventMask + EV_DSR;
  if cceErr in FCommEvents then FEventMask := FEventMask + EV_ERR;
  if cceRing in FCommEvents then FEventMask := FEventMask + EV_RING;
  if ccwRlsd in FCommEvents then FEventMask := FEventMask + EV_RLSD;
  if cceRxChar in FCommEvents then FEventMask := FEventMask + EV_RXCHAR;
  if cceRxFlag in FCommEvents then FEventMask := FEventMask + EV_RXFLAG;
  if cceTxEmpty in FCommEvents then FEventMask := FEventMask + EV_TXEMPTY;
end;

procedure TfoCustomComm.FireCommEvents(dwCommEvents : DWORD);
begin
  if Assigned(FOnCommEvents) then
    FOnCommEvents(Self, dwCommEvents);
end;

procedure TfoCustomComm.FireCommError(const AErrCode : Integer; const AErrDesc : String);
begin
  if Assigned(FOnCommError) then
    FOnCommError(Self, AErrCode, AErrDesc);
end;

procedure TfoCustomComm.FireMessage(const AMsg : String);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, AMsg);
end;

procedure TfoCustomComm.FireTXStatus(Value : Boolean);
begin
  if Assigned(FOnTXStatus) then
    FOnTXStatus(Self, Value);
end;

procedure TfoCustomComm.FireRXStatus(Value : Boolean);
begin
  if Assigned(FOnRXStatus) then
    FOnRXStatus(Self, Value);
end;

procedure TfoCustomComm.FireReceived(const ACount : Integer);
begin
  if Assigned(FOnReceived) then
    FOnReceived(Self, ACount);
end;

procedure TfoCustomComm.FireEventCharReceived(const ACount : Integer);
begin
  if FWaitingEventChar then
    FWaitingEventChar := False
  else
  begin
    if Assigned(FOnEventCharReceived) then
      FOnEventCharReceived(Self, ACount);
  end;
end;

function TfoCustomComm.GetPort : TfocPort;
begin
  Result := FPort;
end;

function TfoCustomComm.GetPortName: string;
begin
  if FPortNo > 9 then
    Result := '\\.\COM' + IntToStr(FPortNo)
  else
    Result := 'COM' + IntToStr(FPortNo);
end;

function TfoCustomComm.GetPortNo: Cardinal;
begin
  Result := FPortNo;
end;

procedure TfoCustomComm.SetPort(Value : TfocPort);
begin
  if FPort <> Value then
  begin
    FPort := Value;
    PortNo := Succ(Ord(FPort));
  end;
end;

procedure TfoCustomComm.SetPortNo(const Value: Cardinal);
begin
  if (FPortNo <> Value) and (Value > 0) then
  begin
    FPortNo := Value;

    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

function TfoCustomComm.GetBaudRate : TfocBaudRate;
begin
  Result := FBaudRate;
end;

procedure TfoCustomComm.SetBaudRate(Value : TfocBaudRate);
begin
  if FBaudRate <> Value then
  begin
    FBaudRate := Value;
    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

function TfoCustomComm.GetParity : TfocParity;
begin
  Result := FParity;
end;

procedure TfoCustomComm.SetParity(Value : TfocParity);
begin
  if FParity <> Value then
  begin
    FParity := Value;
    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

function TfoCustomComm.GetByteSize : TfocByteSize;
begin
  Result := FByteSize;
end;

procedure TfoCustomComm.SetByteSize(Value : TfocByteSize);
begin
  if FByteSize <> Value then
  begin
    FByteSize := Value;
    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

function TfoCustomComm.GetStopBits : TfocStopBits;
begin
  Result := FStopBits;
end;

procedure TfoCustomComm.SetStopBits(Value : TfocStopBits);
begin
  if FStopBits <> Value then
  begin
    FStopBits := Value;
    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

procedure TfoCustomComm.SetFlowControl(Value : TfocFlowControl);
begin
  if FFlowControl <> Value then
  begin
    FFlowControl := Value;
    if FPortOpened then
    begin
      CloseComm;
      OpenComm;
    end;
  end;
end;

procedure TfoCustomComm.SetTimeout(Value : DWORD);
begin
  if FTimeout <> Value then
  begin
    FTimeout := Value;
  end;
end;

procedure TfoCustomComm.SetThreadPriority(Value : TThreadPriority);
begin
  if FReadThreadPriority <> Value then
  begin
    FReadThreadPriority := Value;
  end;
end;

procedure TfoCustomComm.ReadThreadTerminateProc(Sender : Tobject);
begin
  FReadThread := nil;
end;

function TfoCustomComm.InitDCB : Boolean;
const
  BaudRateValues : array[TfocBaudRate] of DWORD = (
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_14400,
    CBR_19200,
    CBR_38400,
    CBR_56000,
    CBR_57600,
    CBR_115200,
    CBR_128000,
    CBR_256000,
    CBR_460800,
    CBR_921600
  );

  Parityvalues :array[TfocParity] of Byte = (
    NOPARITY,
    ODDPARITY,
    EVENPARITY,
    MARKPARITY,
    SPACEPARITY
  );

  ByteSizeValues : array[TfocByteSize] of Byte = (7, 8);

  StopBitsValues : array[TfocStopBits] of Byte = (
    ONESTOPBIT,
    ONE5STOPBITS,
    TWOSTOPBITS
  );

begin
  Result := False;
  
  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    if GetCommState(FHandle, FDCB) then
    begin
      FDCB.BaudRate := BaudRateValues[FBaudRate];
      FDCB.Parity := ParityValues[FParity];
      FDCB.ByteSize := ByteSizeValues[FByteSize];
      FDCB.StopBits := StopBitsValues[FStopBits];

      FDCB.Flags := 0;
      if FFlowControl = cfcXonXoff then
      begin
        FDCB.Flags := FDCB.Flags or DCB_FLAG_INX or DCB_FLAG_OUTX
      end
      else if FFlowControl = cfcRtsCts then
      begin
        FDCB.Flags := FDCB.Flags or DCB_FLAG_OUTXCTSFLOW or DCB_FLAG_RTSCONTROLHANDSHAKE;
      end
      else if FFlowControl = cfcDtrDsr then
      begin
        FDCB.Flags := FDCB.Flags or DCB_FLAG_OUTXDSRFLOW or DCB_FLAG_DTRCONTROLHANDSHAKE;
      end
      else
      begin
        if DTRState then
          FDCB.Flags := FDCB.Flags or DCB_FLAG_DTRCONTROLENABLE;
        if RTSState then
          FDCB.Flags := FDCB.Flags or DCB_FLAG_RTSCONTROLENABLE;
      end;

      if FBinaryMode then
        FDCB.Flags := FDCB.Flags or DCB_FLAG_BINARY;

      if FCheckParity then
        FDCB.Flags := FDCB.Flags or DCB_FLAG_PARITY;

      if FDiscardNull then
        FDCB.Flags := FDCB.Flags or DCB_FLAG_NULL;

      FDCB.XonChar := Chr(XON_CHAR);
      FDCB.XOFFChar := Chr(XOFF_CHAR);
      FDCB.EvtChar := FEventChar;

      if SetCommState(FHandle, FDCB) then
        Result := True
      else
        FireCommError(GetLastError, SysErrorMessage(GetLastError));
    end
    else
      FireCommError(GetLastError, SysErrorMessage(GetLastError));
  end
  else
    FireCommError(GetLastError, SysErrorMessage(GetLastError));
end;

function TfoCustomComm.InitTimeout : Boolean;
begin
  Result := False;

  // 입력버퍼에 데이타가 있을 경우 ReadFile은 입력버퍼의 내용과 함께 바로 Return한다.
  // 입력버퍼에 데이타가 없을 경우 ReadFile은 내용이 올 대까지 기다렸다가 내용과 함께
  // Return한다.
  // ReadTotalTimeoutconstant만큼 기다려도 데이타가 오지 않을 경우 Timeout으로 끝난다.
  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    GetCommTimeouts(FHandle, FCommTimeouts);
    FCommTimeouts.ReadIntervalTimeout := MAXDWORD;
    FCommTimeouts.ReadTotalTimeoutMultiplier := 0;
    FCommTimeouts.ReadTotalTimeoutconstant := FTimeout;
    // Write Timeout은 2 ms
    FCommTimeouts.WriteTotalTimeoutMultiplier := 2;
    FCommTimeouts.WriteTotalTimeoutconstant := 0;
    Result := SetCommTimeouts(FHandle, FCommTimeouts);
    if not Result then
      FireCommError(GetLastError, SysErrorMessage(GetLastError));
  end;
end;

{@@
  Description:
    통신 포트를 연다. 이미 열려있으면 False를 반환한다.

  Returns:
    통신 포트 열기에 성공하면 True를 반환한다.
}
function TfoCustomComm.OpenComm : Boolean;
begin
  Result := False;

  if not FPortOpened then
  begin
    FHandle := CreateFile(PChar(PortName),                      // Port Name
                          GENERIC_READ or GENERIC_WRITE,  // Access Mode
                          0,                              // Share Mode (No share)
                          nil,                            // Address of Security Descriptor
                          OPEN_EXISTING,                  // How to create
                          FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,           // File Attributes
                          0);                           // Handle of file with attributes to copy
    if FHandle = INVALID_HANDLE_VALUE then
    begin
      FireCommError(GetLastError, SysErrorMessage(GetLastError));
    end
    else
    begin
      SetCommMask(FHandle, EV_RXCHAR);
      SetupComm(FHandle, FMaxInQueue, FMaxOutQueue);
      PurgeComm(FHandle, PURGE_RXABORT + PURGE_RXCLEAR + PURGE_TXABORT + PURGE_TXCLEAR);
      if InitTimeout then
      begin
        if InitDCB then
        begin
          FPortOpened := True;

          FReadThread := TfoCommReadThread.Create(False);
          FReadThread.FComm := Self;
          FReadThread.Priority := FReadThreadPriority;
          FReadThread.FreeOnTerminate := True;
          FReadThread.OnTerminate := ReadThreadTerminateProc;

          SetDTRState(True);

          if Assigned(FOnOpenStatus) then
            FOnOpenStatus(Self, True);
          Result := True;
        end
        else
				begin
					CloseHandle(FHandle);
				end;
      end
      else
			begin
				CloseHandle(FHandle);
			end;
    end;
  end;
end;

{@@
  열려 있는 통신 포트를 닫는다.
}
function TfoCustomComm.CloseComm : Boolean;
begin
  if FPortOpened then
  begin
    if Assigned(FReadThread) then
      FReadThread.Terminate;
		SetDTRState(False);
    PurgeComm(FHandle, PURGE_RXABORT + PURGE_RXCLEAR + PURGE_TXABORT + PURGE_TXCLEAR);
    SetCommMask(FHandle, 0);

    if CloseHandle(FHandle) then
    begin
      if Assigned(FOnOpenStatus) then
        FOnOpenStatus(Self, False);
      FPortOpened := False;
      FHandle := INVALID_HANDLE_VALUE;
      Result := True;
    end
    else
    begin
      FireCommError(GetLastError, SysErrorMessage(GetLastError));
      Result := False;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

{@@
  dwCommError가 0이 아니면 해당 통신 에러에 대한 OnCommError 이벤트를 발생시킨다.
}
procedure TfoCustomComm.ProcessCommError(dwCommError : DWORD);
begin
  if dwCommError > 0 then
  begin
    if (dwCommError and CE_BREAK) = 1 then
    begin
      FireCommError(CE_BREAK, 'The hardware detected a break condition.');
    end
    else if (dwCommError and CE_DNS) = 1 then
    begin
      FireCommError(CE_DNS, 'A parallel device is not selected.');
    end
    else if (dwCommError and CE_FRAME) = 1 then
    begin
      FireCommError(CE_FRAME, 'The hardware detected a framing error.');
    end
    else if (dwCommError and CE_IOE) = 1 then
    begin
      FireCommError(CE_IOE, 'An I/O error occurred during communications with the device.');
    end
    else if (dwCommError and CE_MODE) = 1 then
    begin
      FireCommError(CE_MODE, 'The requested mode is not supported, or the hFile parameter is invalid. if this value is specified, it is the only valid error.');
    end
    else if (dwCommError and CE_OOP) = 1 then
    begin
      FireCommError(CE_OOP, 'A parallel device signaled that it is out of paper.');
    end
    else if (dwCommError and CE_OVERRUN) = 1 then
    begin
      FireCommError(CE_OVERRUN, 'A character-buffer overrun has occurred. The next character is lost.');
    end
    else if (dwCommError and CE_PTO) = 1 then
    begin
      FireCommError(CE_PTO, 'A time-out occurred on a parallel device.');
    end
    else if (dwCommError and CE_RXOVER) = 1 then
    begin
      FireCommError(CE_RXOVER, 'An input buffer overflow has occurred. There is either no room in the input buffer, or a character was received after the end-of-file (Eof) character.');
    end
    else if (dwCommError and CE_RXPARITY) = 1 then
    begin
      FireCommError(CE_RXPARITY, 'The hardware detected a parity error.');
    end
    else if (dwCommError and CE_TXFULL) = 1 then
    begin
      FireCommError(CE_TXFULL, 'The application tried to transmit a character, but the output buffer was full.');
    end;
  end;
end;

{@@
  Description:
    지정한 버퍼의 내용을 송신한다.
  Parameters:
    ADataToSend - 송신할 버퍼
    ACount - 송신할 버퍼의 바이트 수
  Returns:
    송신에 성공하면 송신한 바이트 수를 반환한다. 송신에 실패하면 -1을 반환한다.
}
function TfoCustomComm.Write(const ADataToSend; const ACount : Cardinal) : Integer;
var
  dwErrorMask, dwWritten, dwWriteNo : DWORD;
begin
  Result := -1;

  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    FireTXStatus(True);

    if FRS485Mode then SetRTSState(True);

    dwWriteNo := 0;
    if not WriteFile(FHandle, ADataToSend, ACount, dwWritten, @FOVWrite) then
    begin
      if GetLastError = ERROR_IO_PENDING then
      begin
        while not GetOverlappedResult(FHandle, FOVWrite, dwWritten, TRUE) do
        begin
          if GetLastError <> ERROR_IO_INCOMPLETE then
          begin
    				ClearCommError(FHandle, dwErrorMask, @FComStat);
            ProcessCommError(dwErrorMask);
            Break;
          end
          else
            dwWriteNo := dwWriteNo + dwWritten;
        end;
        dwWriteNo := dwWriteNo + dwWritten;
        Result := dwWriteNo;
      end
      else
      begin
				ClearCommError(FHandle, dwErrorMask, @FComStat);
        ProcessCommError(dwErrorMask);
      end;
    end;

    if FRS485Mode then SetRTSState(False);

    FireTXStatus(False);
  end
end;

{@@
  Description:
    지정한 버퍼를 송신한다.
  Parameters:
    ADataToSend - 송신할 버퍼
    ACount - 송신할 버퍼의 바이트 수
    AWrittenBytes - 송신한 바이트 수
  Returns:
    송신에 성공하면 True, 실패하면 False를 반환한다.
}
function TfoCustomComm.WriteChar(const ADataToSend : PAnsiChar;
  const ACount : Cardinal;
  var AWrittenBytes : Cardinal) : Boolean;
var
  dwRead : Integer;
begin
  AWrittenBytes := 0;
  dwRead := Write(ADataToSend, ACount);
  Result := (dwRead <> -1);
  if Result then
    AWrittenBytes := dwRead;
end;

{@@
  Description:
    지정한 문자열을 송신한다.
  Parameters:
    ADataToSend - 송신할 문자열
  Returns:
    송신에 성공하면 True, 실패하면 False를 반환한다.
}
function TfoCustomComm.WriteString(const ADataToSend : AnsiString) : Boolean;
begin
  Result := Write(PAnsiChar(ADataToSend)^, Length(ADataToSend)) <> -1;
end;

{@@
  Description:
    통신 버퍼에 수신된 내용을 읽어온다.
  Parameters:
    ABuffer - 수신 버퍼
    ACount - 수신할 바이트 수
  Returns:
    수신에 성공하면 수신된 바이트 수, 실패하면 -1 을 반환한다.
}
function TfoCustomComm.Read(var ABuffer; const ACount : Cardinal) : Integer;
var
  dwRead : DWORD;
  dwErrorMask : DWORD;
  dwError : DWORD;
  bReadState : Boolean;
begin
  Result := -1;

  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    bReadState := ReadFile(FHandle, ABuffer, ACount, dwRead, @FOVRead);
    if (not bReadState) then
    begin
      if (GetLastError = ERROR_IO_PENDING) then
      begin
        while(not GetOverlappedResult(FHandle, FOVRead, dwRead, TRUE)) do
        begin
          dwError := GetLastError;
          if(dwError <> ERROR_IO_INCOMPLETE) then
          begin
            ClearCommError(FHandle, dwErrorMask, @FComStat);
            ProcessCommError(dwErrorMask);
            Exit;
          end;
        end;
        Result := dwRead;
      end
      else
      begin
        ClearCommError(FHandle, dwErrorMask, @FComStat);
        ProcessCommError(dwErrorMask);
      end
    end
    else
    begin
      Result := dwRead;
    end;
  end;
end;

{@@
  Description:
    통신 버퍼에 수신된 내용을 읽어들여서 문자열로 반환한다.
}
function TfoCustomComm.ReadString : AnsiString;
var
  dwToRead : DWORD;
begin
  Result := '';

  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    dwToRead := GetInQueue;
    if dwToRead > 0 then
    begin
      FireRXStatus(True);

      SetLength(Result, dwToRead);
      Read(PAnsiChar(Result)^, dwToRead);
      FireRXStatus(False);
    end;
  end;
end;

{@@
  Description:
    통신 드라이버의 송수신 버퍼에 있는 내용을 삭제하고 진행중인 송수신작업을
    모두 취소한다.
}
procedure TfoCustomComm.ClearBuffer;
begin
  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR or PURGE_TXABORT or PURGE_TXCLEAR);
  end;
end;

{@@
  Description:
    통신 드라이버에 수신된 데이터의 길이를 반환한다.
}
function TfoCustomComm.GetInQueue : DWORD;
var
  dwErrorMask : DWORD;
begin
	Result := 0;
  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    ClearCommError(FHandle, dwErrorMask, @FComStat);
    Result := FComStat.cbInQue;
  end;
end;

{@@
  Description:
    EventChar에 지정된 문자가 수신될 때까지 Timeout 시간 동안 기다린다.
}
function TfoCustomComm.WaitEventChar : Boolean;
begin
  Result := WaitEventChar(FTimeout);
end;

{@@
  Description:
    통신 포트의 설정 대화 상자를 연다.
}
function TfoCustomComm.ConfigDialog: Boolean;
var
  CC : TCommConfig;
begin
  Result := True;
  if CommConfigDialog(PChar(PortName), 0, CC) then
  begin
  end;
end;

{@@
  Summary
    DTR 신호 상태 변경
  Description
    DTR(Data Terminal Ready) 신호의 상태를 변경한다.
  See Also
    DTRState
}
function TfoCustomComm.SetDTRState(const AOnOff: Boolean): Boolean;
begin
  Result := False;
  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    if AOnOff then
      Result := EscapeCommfunction(FHandle, Windows.SETDTR)
    else
      Result := EscapeCommfunction(FHandle, Windows.CLRDTR);
    FDTRState := AOnOff;
  end;
end;

{@@
  Summary
    RTS 신호 상태 변경
  Description
    RTS(Request To Send) 신호의 상태를 변경한다.
  See Also
    RTSState
}
function TfoCustomComm.SetRTSState(const AOnOff: Boolean): Boolean;
begin
  Result := False;
  if FPortOpened and (FHandle <> INVALID_HANDLE_VALUE) then
  begin
    if AOnOff then
      Result := EscapeCommfunction(FHandle, Windows.SETRTS)
    else
      Result := EscapeCommfunction(FHandle, Windows.CLRRTS);
    FRTSState := AOnOff;
  end;
end;

function TfoCustomComm.WaitEventChar(const ATimeout: Integer): Boolean;
var
  NeedTick : Cardinal;
  FContinue : Boolean;
begin
  Result := False;
  FWaitingEventChar := True;
  FContinue := True;
  NeedTick := GetTickCount + ATimeout;
  while FContinue do
  begin
    Application.ProcessMessages;
    if not FWaitingEventChar then
    begin
      FContinue := False;
      Result := True;
    end
    else if (GetTickCount > NeedTick) then
    begin
      FContinue := False;
      Result := False;
    end;
    Application.ProcessMessages;
  end;
end;

procedure TfoCustomComm.WndProc(var Message: TMessage);
begin
  if (csDestroying in ComponentState) then Exit;

  try
    case Message.Msg of
      CM_EVENTCHAR_RECEIVED:
        begin
          FireEventCharReceived(Message.LParam);
        end;

      CM_CHAR_RECEIVED:
        begin
          FireReceived(Message.LParam);
        end;

      CM_COMM_EVENTS:
        begin
          FireCommEvents(Message.LParam);
        end;
    end;
  except
    Application.HandleException(Self);
  end;
end;

end.
