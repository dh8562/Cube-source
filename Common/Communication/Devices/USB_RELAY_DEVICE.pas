unit USB_RELAY_DEVICE;

interface

uses
  Windows, Classes;

type

  TStatusNotifyProc = procedure (Event : Integer; lParam : Integer); stdcall;
  TDebugMessageProc = procedure (szMsg : PChar); stdcall;
  TErrorNotifyProc = procedure (nCode : Integer; szMsg : PChar); stdcall;
  PVOHANDLE = ^VOHANDLE;
  VOHANDLE = Integer;
  VOSTATUS = Integer;

const
  VO_INVALID_HANDLE = -1;
  VO_NOT_FOUND      = -1;
  VO_FAIL = 0;
  VO_OK = 1;
  VO_NULL = 0;


function usb_realy_initialize : Boolean; stdcall;
function usb_realy_finalize : Boolean; stdcall;
function usb_realy_on(nCh : UINT) : Boolean; stdcall;
function usb_realy_off(nCh : UINT) : Boolean; stdcall;


implementation

const
  CORE_DLL = 'USB_RELAY_DEVICE.dll';

function usb_realy_initialize; external CORE_DLL;
function usb_realy_finalize; external CORE_DLL;
function usb_realy_on; external CORE_DLL;
function usb_realy_off; external CORE_DLL;

end.
