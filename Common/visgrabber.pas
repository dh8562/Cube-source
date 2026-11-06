unit visgrabber;

interface

uses
  Windows, Classes;

const
  PARAM_CAEMRA_SHUTTER			= 0;
  PARAM_TRIGGER_SOURCE			= 1;
  PARAM_SET_FLASH				    = 2;
  PARAM_SET_GAIN            = 3;

//  PARAM_TRIGGER_SOURCE = 1;
  TRIGGER_SOURCE_LINE0 = 0;               // Line0
  TRIGGER_SOURCE_LINE1 = 1;               // Line1
  TRIGGER_SOURCE_LINE2 = 2;               // Line2
  TRIGGER_SOURCE_LINE3 = 3;               // Line3
  TRIGGER_SOURCE_COUNTER0 = 4;            // Conuter0
  TRIGGER_SOURCE_SOFTWARE = 7;            // Software
  TRIGGER_SOURCE_FrequencyConverter = 8;  // Frequency Converter

type
  TStatusNotifyProc = procedure (Event : LongInt; lParam : Int64); stdcall;
  TDebugMessageProc = procedure (szMsg : PAnsiChar); stdcall;

	PMVSystem = ^TMVSystem;
	TMVSystem = packed record
    SystemNo : Longint;
    bInitialized : LongInt;
    pCurrent : Pointer;
    nSurfaceWidth : Longint;
    nSurfaceHeight : Longint;
	  bGrabStart : LongInt;
	  bGrabOk : LongInt;
	  bLive : LongInt;
  end;

function vgInitialize(SystemNo : Integer) : Boolean; stdcall;
function vgInitializeWithSystem(SystemType : Pointer; CamNo : LongInt) : Boolean; stdcall;
function vgFinalize  : Boolean; stdcall;
procedure vgGrab(CamNo : Integer); stdcall;
procedure vgStartLive(CamNo : Integer); stdcall;
procedure vgStopLive(CamNo : LongInt); stdcall;
procedure vgSetTrigger(CamNo : LongInt; bOnOff : Boolean); stdcall;
procedure vgRunSoftwareTrigger(CamNo : LongInt); stdcall;

procedure vgSetVerboseMode(VerboseMode : LongInt); stdcall;
procedure vgSetStatusNotifyProc(lpfnStatusNotify : TStatusNotifyProc); stdcall;
procedure vgSetDebugMessageProc(lpfnDebugMessage : TDebugMessageProc); stdcall;
function vgGetInitialized(SystemNo : LongInt) : Boolean; stdcall;
function vgSetParamInt(CamNo : LongInt; nParamNo : LongInt; nValue : Integer) : Boolean; stdcall;


implementation

const
  DLL_NAME = 'visgrabber.dll';

function vgInitialize; external DLL_NAME;
function vgInitializeWithSystem; external DLL_NAME;
function vgFinalize; external DLL_NAME;
procedure vgGrab; external DLL_NAME;
procedure vgStartLive; external DLL_NAME;
procedure vgStopLive; external DLL_NAME;
procedure vgSetTrigger; external DLL_NAME;
procedure vgRunSoftwareTrigger; external DLL_NAME;

procedure vgSetVerboseMode; external DLL_NAME;
procedure vgSetStatusNotifyProc; external DLL_NAME;
procedure vgSetDebugMessageProc; external DLL_NAME;
function vgGetInitialized; external DLL_NAME;

function vgSetParamInt; external DLL_NAME;

end.
