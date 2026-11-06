unit vocore;

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
  // VOSTATUS
  VO_INVALID_HANDLE = -1;
  VO_NOT_FOUND      = -1;
  VO_FAIL = 0;
  VO_OK = 1;
  
const
  VO_NULL = 0;


// VOCORE
procedure VOSetVerboseMode(VerboseMode : Integer); stdcall;
procedure VOSetStatusNotifyProc(lpfnStatusNotify : TStatusNotifyProc); stdcall;
procedure VOSetDebugMessageProc(lpfnDebugMessage : TDebugMessageProc); stdcall;
procedure VOSetErrorNotifyProc(lpfnErrorNotify : TErrorNotifyProc); stdcall;

// 버퍼 관련
function VObufferCreate(nWidth, nHeight : Integer; hBuffer : PVOHANDLE) : VOHANDLE; stdcall;
function VObufferCreateFrom(nWidth, nHeight : Integer; pBufferData : PAnsiChar; hBuffer : PVOHANDLE) : VOHANDLE; stdcall;
function VObufferCreateFromHandle(BitmapHandle : HBITMAP; hBuffer : PVOHANDLE) : VOHANDLE; stdcall;
function VObufferFree(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VObufferGetData(hBuffer : VOHANDLE) : PByte; stdcall;
function VObufferSetSize(hBuffer : VOHANDLE; nWidth, nHeight : Integer) : VOSTATUS; stdcall;
function VObufferFillWith(hBuffer : VOHANDLE; nValue : Byte) : VOSTATUS; stdcall;
function VObufferClear(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VObufferCopy(hSrcBuffer, hDestBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VObufferCopyRect(hSrcBuffer, hDestBuffer : VOHANDLE; rClip : TRect; nDestX, nDestY : Integer) : VOSTATUS; stdcall;
function VObufferLoad(hBuffer : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall;
function VObufferSave(hBuffer : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall;
procedure VObufferDrawTo(hBuffer : VOHANDLE; DC : HDC; X, Y : Integer); stdcall;
procedure VObufferStretchDrawTo(hBuffer : VOHANDLE; DC : HDC; X, Y, Width, Height : Integer); stdcall;
function VObufferGetSize(hBuffer : VOHANDLE; var nWidth, nHeight : Integer) : VOSTATUS; stdcall;
function VObufferValid(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VObufferSetData(hBuffer : VOHANDLE; pData : PByte; nWidth, nHeight : Integer) : VOSTATUS; stdcall;


const
  // Fixed Filter
  VO_FILTER_SOBEL_3X3_H = 0;
  VO_FILTER_SOBEL_3X3_V = 1;

// 이미지 조작 관련
function VOimBinarize(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nThreshold : Integer) : VOSTATUS; stdcall;
function VOimCustomFilter(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; pFilter : PInteger) : VOSTATUS; stdcall;
function VOimFilter(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nFilter : Integer) : VOSTATUS; stdcall;
function VOimErode(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nIteration: Integer) : VOSTATUS; stdcall;
function VOimDilate(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nIteration: Integer) : VOSTATUS; stdcall;
function VOimEdgeDetect(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VOimOpen(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nIteration: Integer) : VOSTATUS; stdcall;
function VOimClose(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; nIteration: Integer) : VOSTATUS; stdcall;
function VOimReduceSize(hSrcBuffer : VOHANDLE; hDestBuffer : VOHANDLE; Method : Integer; Scale : Double) : VOSTATUS; stdcall;

implementation

const
  CORE_DLL = 'vocore.dll';

procedure VOSetStatusNotifyProc; external CORE_DLL;
procedure VOSetDebugMessageProc; external CORE_DLL;
procedure VOSetErrorNotifyProc; external CORE_DLL;
procedure VOSetVerboseMode; external CORE_DLL;

function VObufferCreate; external CORE_DLL;
function VObufferCreateFrom; external CORE_DLL;
function VObufferCreateFromHandle; external CORE_DLL;
function VObufferFree; external CORE_DLL;
function VObufferGetData; external CORE_DLL;
function VObufferSetSize; external CORE_DLL;
function VObufferFillWith; external CORE_DLL;
function VObufferClear; external CORE_DLL;
function VObufferCopy; external CORE_DLL;
function VObufferCopyRect; external CORE_DLL;
function VObufferLoad; external CORE_DLL;
function VObufferSave; external CORE_DLL;
procedure VObufferDrawTo; external CORE_DLL;
procedure VObufferStretchDrawTo; external CORE_DLL;
function VObufferGetSize; external CORE_DLL;
function VObufferValid; external CORE_DLL;
function VObufferSetData; external CORE_DLL;

function VOimBinarize; external CORE_DLL;
function VOimCustomFilter; external CORE_DLL;
function VOimFilter; external CORE_DLL;
function VOimErode; external CORE_DLL;
function VOimDilate; external CORE_DLL;
function VOimEdgeDetect; external CORE_DLL;
function VOimOpen; external CORE_DLL;
function VOimClose; external CORE_DLL;
function VOimReduceSize; external CORE_DLL;

end.
