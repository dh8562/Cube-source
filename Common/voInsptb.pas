unit voInsptb;

interface

uses
  Windows, Classes, vocore;

const
  MARKER_CROSS = 0;           //!< A crosshair marker shape
  MARKER_TILTED_CROSS = 1;    //!< A 45 degree tilted crosshair marker shape
  MARKER_STAR = 2;            //!< A star marker shape, combination of cross and tilted cross
  MARKER_DIAMOND = 3;         //!< A diamond marker shape
  MARKER_SQUARE = 4;          //!< A square marker shape
  MARKER_TRIANGLE_UP = 5;     //!< An upwards pointing triangle marker shape
  MARKER_TRIANGLE_DOWN = 6;   //!< A downwards pointing triangle marker shape


//VoCVImageThreshold
//! type of the threshold operation
  THRESH_BINARY     = 0;      //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{maxval}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
  THRESH_BINARY_INV = 1;      //!< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{maxval}}{otherwise}\f]
  THRESH_TRUNC      = 2;      //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{threshold}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
  THRESH_TOZERO     = 3;      //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{src}(x,y)}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
  THRESH_TOZERO_INV = 4;      //!< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
  THRESH_MASK       = 7;
  THRESH_OTSU       = 8;      //!< flag, use Otsu algorithm to choose the optimal threshold value
  THRESH_TRIANGLE   = 16;     //!< flag, use Triangle algorithm to choose the optimal threshold value


  COLOR_BGR2GRAY     = 6;     //!< convert between RGB/BGR and grayscale, @ref color_convert_rgb_gray "color conversions"

  COLOR_GRAY2BGR     = 8;

//VoCVImageMorphologyEx
  MORPH_ERODE    = 0;       //!< see #erode
  MORPH_DILATE   = 1;       //!< see #dilate
  MORPH_OPEN     = 2;       //!< an opening operation
                            //!< \f[\texttt{dst} = \mathrm{open} ( \texttt{src} , \texttt{element} )= \mathrm{dilate} ( \mathrm{erode} ( \texttt{src} , \texttt{element} ))\f]
  MORPH_CLOSE    = 3;       //!< a closing operation
                            //!< \f[\texttt{dst} = \mathrm{close} ( \texttt{src} , \texttt{element} )= \mathrm{erode} ( \mathrm{dilate} ( \texttt{src} , \texttt{element} ))\f]
  MORPH_GRADIENT = 4;       //!< a morphological gradient
                            //!< \f[\texttt{dst} = \mathrm{morph\_grad} ( \texttt{src} , \texttt{element} )= \mathrm{dilate} ( \texttt{src} , \texttt{element} )- \mathrm{erode} ( \texttt{src} , \texttt{element} )\f]
  MORPH_TOPHAT   = 5;       //!< "top hat"
                            //!< \f[\texttt{dst} = \mathrm{tophat} ( \texttt{src} , \texttt{element} )= \texttt{src} - \mathrm{open} ( \texttt{src} , \texttt{element} )\f]
  MORPH_BLACKHAT = 6;       //!< "black hat"
                            //!< \f[\texttt{dst} = \mathrm{blackhat} ( \texttt{src} , \texttt{element} )= \mathrm{close} ( \texttt{src} , \texttt{element} )- \texttt{src}\f]
  MORPH_HITMISS  = 7;       //!< "hit or miss"
                            //!<   .- Only supported for CV_8UC1 binary images. A tutorial can be found in the documentation



//VoCVFeature2DCreate

  FEATURE2D_AKAZE_DESCRIPTOR_KAZE_UPRIGHT = 0;

  FEATURE2D_AKAZE = 1;
  FEATURE2D_ORB = 2;
  FEATURE2D_BRISK = 3;

  CONTOUR_POINT_2I	= 0;
  CONTOUR_POINT_2F	= 1;

//VoCVDescriptorMatcherCreate
  FLANNBASED = 1;
  BRUTEFORCE= 2;
  BRUTEFORCE_L1	= 3;
  BRUTEFORCE_HAMMING = 4;
  BRUTEFORCE_HAMMINGLUT	= 5;
  BRUTEFORCE_SL2 = 6;

  FILLED  = -1;
  LINE_4  = 4;    //!< 4-connected line
  LINE_8  = 8;    //!< 8-connected line
  LINE_AA = 16;   //!< antialiased line

  FONT_HERSHEY_SIMPLEX        = 0; //!< normal size sans-serif font
  FONT_HERSHEY_PLAIN          = 1; //!< small size sans-serif font
  FONT_HERSHEY_DUPLEX         = 2; //!< normal size sans-serif font (more complex than FONT_HERSHEY_SIMPLEX)
  FONT_HERSHEY_COMPLEX        = 3; //!< normal size serif font
  FONT_HERSHEY_TRIPLEX        = 4; //!< normal size serif font (more complex than FONT_HERSHEY_COMPLEX)
  FONT_HERSHEY_COMPLEX_SMALL  = 5; //!< smaller version of FONT_HERSHEY_COMPLEX
  FONT_HERSHEY_SCRIPT_SIMPLEX = 6; //!< hand-writing style font
  FONT_HERSHEY_SCRIPT_COMPLEX = 7; //!< more complex variant of FONT_HERSHEY_SCRIPT_SIMPLEX
  FONT_ITALIC                 = 16; //!< flag for italic font

  INT_MAX         = 2147483647;

  //mode for VoCVFindContours
  // mode of the contour retrieval algorithm
  // retrieves only the extreme outer contours. It sets `hierarchy[i][2]=hierarchy[i][3]=-1` for all the contours.
  // 극단적 인 외부 윤곽 만 검색합니다. 모든 윤곽에 대해`hierarchy[i][2]=hierarchy[i][3]=-1`을 설정합니다.
  RETR_EXTERNAL  = 0;

  // retrieves all of the contours without establishing any hierarchical relationships.
  //계층 적 관계를 설정하지 않고 모든 윤곽을 검색합니다.
  RETR_LIST      = 1;

  // retrieves all of the contours and organizes them into a two-level hierarchy. At the top
  // level, there are external boundaries of the components. At the second level, there are
  // boundaries of the holes. If there is another contour inside a hole of a connected component, it
  // is still put at the top level.
  //모든 등고선을 검색하여 2 단계 계층으로 구성합니다.
  //최상위 수준에는 구성 요소의 외부 경계가 있습니다.
  //두 번째 수준에는 구멍의 경계가 있습니다.
  //연결된 구성 요소의 구멍 안에 다른 윤곽이있는 경우 여전히 최상위 수준에 배치됩니다.
  RETR_CCOMP     = 2;

  // retrieves all of the contours and reconstructs a full hierarchy of nested contours.
  //모든 등고선을 검색하고 중첩 된 등고선의 전체 계층을 재구성합니다.
  RETR_TREE      = 3;

  RETR_FLOODFILL = 4;   // 문제가 있는거 같음...

  //! the contour approximation algorithm
  // stores absolutely all the contour points. That is, any 2 subsequent points (x1,y1) and
  // (x2,y2) of the contour will be either horizontal, vertical or diagonal neighbors, that is,
  // max(abs(x1-x2),abs(y2-y1))==1.
  //절대적으로 모든 윤곽 점을 저장합니다.
  //즉, 등고선의 2 개의 후속 점 (x1, y1) 및 (x2, y2)는 수평, 수직 또는 대각선 인접,
  // 즉 max (abs (x1-x2), abs (y2-y1))입니다. == 1
  CHAIN_APPROX_NONE      = 1;

  // compresses horizontal, vertical, and diagonal segments and leaves only their end points.
  //For example, an up-right rectangular contour is encoded with 4 points.
  //수평, 수직 및 대각선 세그먼트를 압축하고 끝점 만 남습니다.
  // 예를 들어, 직각 직사각형 형상은 4 포인트로 인코딩됩니다.
  CHAIN_APPROX_SIMPLE    = 2;

  // applies one of the flavors of the Teh-Chin chain approximation algorithm @cite TehChin89
  // Teh-Chin chain approximation algorithm @cite TehChin89의 풍미 중 하나를 적용합니다.
  CHAIN_APPROX_TC89_L1   = 3;

  // applies one of the flavors of the Teh-Chin chain approximation algorithm @cite TehChin89
  // Teh-Chin chain approximation algorithm @cite TehChin89의 풍미 중 하나를 적용합니다.
  CHAIN_APPROX_TC89_KCOS = 4;


  // Best Fit
  // VoBestFitDoFit(hBestFit : VOHANDLE; nFitType : Integer);
  // nFitType 인자 정의
  FIT_TYPE_LINE				  = 0;
  FIT_TYPE_CIRCLE				= 1;
  FIT_TYPE_ELLIPSE			= 2;

  // VoBestFitGetResult(hBestFit : VOHANDLE; nResult : Integer);
  // nResult 인자 정의
  FIT_RESULT_LINE_GRADIENT	  = 0;
  FIT_RESULT_LINE_Y_INTERCEPT	= 1;

  FIT_RESULT_CIRCLE_CENTER_X	= 0;
  FIT_RESULT_CIRCLE_CENTER_Y	= 1;
  FIT_RESULT_CIRCLE_RADIUS	  = 2;

  FIT_RESULT_ELLIPSE_CENTER_X		= 0;
  FIT_RESULT_ELLIPSE_CENTER_Y		= 1;
  FIT_RESULT_ELLIPSE_MAJOR_AXIS	= 2;
  FIT_RESULT_ELLIPSE_MINOR_AXIS	= 3;
  FIT_RESULT_ELLIPSE_ROTATION		= 4;

const
  VO_INSP_TB_DLL = 'voInsptb.dll';



type

  TCamStatusNotifyProc = procedure (Event : LongInt; lParam : Integer); stdcall;
  TDebugMessageProc = procedure (szMsg : PAnsiChar); stdcall;

  TDrillEntity = packed record
    Layer: array[0..63] of AnsiChar;
    X, Y, R: Double;
  end;
  PDrillEntity = ^TDrillEntity;

  TStepResult = (
    srOK = 0,
    srFail = 1,
    srAbort = 2
  );

  TStepType = (
    stStageMove    = 0,
    stRobotMove    = 1,
    stCapture2D    = 2,
    stCapture3D    = 3,
    stHeightMeasure= 4,
    stIOControl    = 5,
    stWait         = 6
  );



  TStepExecuteCallback = function(
    StepPtr: Pointer;   // MotionStep*
    UserCtx: Pointer    // 사용자 컨텍스트
  ): TStepResult; stdcall;

  PInspectionCtx = ^TInspectionCtx;
  TInspectionCtx = record
    Handle: VOHANDLE;   // C++ Inspection 핸들
    // 필요 시 장비 포인터, 플래그 등 추가
    // Device: Pointer;
  end;



procedure voSetVerboseMode(VerboseMode : LongInt); stdcall;  external VO_INSP_TB_DLL;
procedure voSetDebugMessageProc(lpfnDebugMessage : TDebugMessageProc); stdcall;  external VO_INSP_TB_DLL;


function voInspTbInitialize(nValue : Integer) : Boolean; stdcall;  external VO_INSP_TB_DLL;
function voCheckLock(szCode : PAnsiChar) : Boolean; stdcall;  external VO_INSP_TB_DLL;

//function VoBufferViewCreate(iWidth, iHeight : Integer) : VOHANDLE; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewRelease(hBuffer : VOHANDLE) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;

//function VoBufferViewSetPen(hBuffer : VOHANDLE; iPenStyle, iThickness, iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewSetStockPen(hBuffer : VOHANDLE; iPen : Integer) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewSetSolidBrush(hBuffer : VOHANDLE; iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewSetStockBrush(hBuffer : VOHANDLE; iBrush : Integer) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewSetHatchBrush(hBuffer : VOHANDLE; iStyle, iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;  external VO_INSP_TB_DLL;
//function VoBufferViewSetZoomFactor(hBuffer : VOHANDLE; dZoomFactor : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewSetImageRect(hBuffer : VOHANDLE; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewSetDrawRect(hBuffer : VOHANDLE; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//
//function VoBufferViewDrawRectangle(hBuffer : VOHANDLE; hDC : HDC; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewDrawTo(hBuffer : VOHANDLE; DC : HDC; iX, iY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewDrawCVImage(hBuffer : VOHANDLE; hDC : HDC; hImage : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewDrawCross(hBuffer : VOHANDLE; DC : HDC; dCX, dCY, dXHalfLength, dYHalfLength : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
//function VoBufferViewDrawLine(hBuffer : VOHANDLE; hDC : HDC; dX1, dY1, dX2, dY2 : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageCreate(iWidth, iHeight : Integer) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVImageCreateEx(iWidth, iHeight, iChannels : Integer) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVImageRelease(hBuffer : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageCreateExtern(iWidth, iHeight : Integer; hImage : VOHANDLE) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVImageCreateROI(hImage : VOHANDLE; nX, nY, nWidth, nHeight : Integer) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;

function VoCVImageGetRawData(hImage : VOHANDLE; nWidth : PInteger; nHeight : PInteger; nChannels : PInteger; pData : PVOHANDLE) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;

function VoCVImageLoadFromFile(hImage : VOHANDLE; szFileName : PAnsiChar; nColor : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageLoadFromFileEx(hImage : VOHANDLE; szFileName : PAnsiChar; nColor : Integer; var nChannels : Integer; var nWidth : Integer; var nHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageSaveToFile(hImage : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageSetTo(hImage : VOHANDLE; nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageCopy(hImageSrc : VOHANDLE; hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageConvertColor(hImageSrc, hImageDest : VOHANDLE; nType : Integer)  : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageResize(hImageSrc : VOHANDLE; hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageDrawLine(hImage : VOHANDLE; nX1, nY1, nX2, nY2, nThickness, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawRectangle(hImage : VOHANDLE; nX1, nY1, nX2, nY2, nThickness, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawMarker(hImage : VOHANDLE; nX, nY, nType, nSize, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawCircle(hImage : VOHANDLE; nCX, nCY, nRadius, nThickness, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageDrawEllipse(hImage : VOHANDLE; nCX, nCY, nWidth, nHeight : Integer;
		dAngle, dAngleStart, dAngleEnd : Double; nThickness, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageDrawPolylines(hImage : VOHANDLE; hContour : VOHANDLE; nThickness, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawFillContour(hImage : VOHANDLE; hContour : VOHANDLE; nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawContours(hImage, hContours, hHierarchy : VOHANDLE;
	nMaxLevel, nIndex, nLineType, nThickness, nOffsetX, nOffsetY, nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageDrawText(hImage : VOHANDLE; szText : pAnsiChar; nPosX : Integer; nPosY : Integer; nFontKind : Integer; nFontSize : Integer;
	nBlue : Integer; nGreen : Integer; nRed : Integer; nFontThickness : Integer; nLineType : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageGetValue(hImage : VOHANDLE ; X, Y : Integer; nBlueValue : PInteger; nGreenValue : PInteger; nRedValue : PInteger) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageSetValue(hImage : VOHANDLE ; X, Y : Integer; nBlueValue : Integer; nGreenValue : Integer; nRedValue : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageThreshold(hImageSrc, hImageDst : VOHANDLE; nThreshold, nMaxValue, nType : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageThresholdOTUS(hImageSrc, hImageDst : VOHANDLE) : Integer; stdcall; external VO_INSP_TB_DLL;
function VoCVImageAdaptiveThreshold(hImageSrc, hImageDst : VOHANDLE; nThreshold, nBlockSize, nType : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageBitwise_And(hImageSrc1, hImageSrc2, hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageBitwise_Or(hImageSrc1, hImageSrc2, hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageBitwise_Xor(hImageSrc1, hImageSrc2, hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageBitwise_Not(hImageSrc1, hImageSrc2, hImageDst : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVImageBlur(hImageSrc, hImageDst : VOHANDLE; nSizeX, nSizeY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageCanny(hImageSrc, hImageDst : VOHANDLE; nLowThreshold, nHighThreshold, nSize : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVImageMorphologyEx(hImageSrc, hImageDst : VOHANDLE; nOper, nSizeX, nSizeY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVFeature2DCreate(nAlgorithmName : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVFeature2DRelease(hFeature2D : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVFeature2DDetect(hFeature2D, hImage, hKeyPoint : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVFeature2DCompute(hFeature2D, hImage, hKeyPoint, hDesc : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVFeature2DDetectAndCompute(hFeature2D, hImage, hKeyPoint, hDesc : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDescriptorMatcherMatch(hDMatcher, hDesc1, hDesc2, hMatches : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;


function VoCVMatCreate : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVMatRelease(hMat : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDescriptorMatcherCreate(nMatcherType : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDescriptorMatcherRelease(hDMatcher : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDMatchCreate(nCount : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDMatchRelease(hDMatch : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVKeyPointCreate(nCount : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVKeyPointRelease(hKeyPoint : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDrawKeypoints(hImageSrc, hKeyPoint, hImageDst : VOHANDLE; nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVDrawMatches(hImageModel, hKeyPointModel, hImage, hKeyPoint, hMatches, hImageDst : VOHANDLE; nBlue, nGreen, nRed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;


function VoCVHierarchyCreate : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVHierarchyRelease(hHierarchy : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVContourSetType(nType : Integer) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVContourCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVContourRelease(hContour : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContourClear(hContour : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContourCopy(hContourSrc : VOHANDLE; pContourDst : PVOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVContourAdd(hContour : VOHANDLE; nX, nY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVContoursCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursRelease(hContours : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursClear(hContours : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursCopy(hContoursSrc : VOHANDLE; pContoursDst : PVOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursAddContour(hContours : VOHANDLE; hContour : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursGetCount(hContours : VOHANDLE) : Integer; stdcall; external VO_INSP_TB_DLL;
function VoCVContoursGetContourByIndex(hContours : VOHANDLE; nIndex : Integer; pContour : PVOHANDLE) : VOHANDLE; stdcall; external VO_INSP_TB_DLL;

function VoCVFindContours(hImageSrc, hContours, hHierarchy : VOHANDLE; nMode, nMethod, nOffsetX, nOffsetY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVApproxPolyDP(hContoursSrc, hContoursDst : VOHANDLE; dEpsilon : Double; nClosed : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVConvexHull(hContourSrc : VOHANDLE; pContourDst : PVOHANDLE; nClockwise, nReturnPoints : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVContoursLargestContour(hContours : VOHANDLE; pContour : PVOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoCVContourGetArea(hContour : VOHANDLE; var dArea : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContourBoundRect(hContour : VOHANDLE; var nLeft, nTop, nRight, nBottom : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVContourMinAreaRect(hContour : VOHANDLE; var nCX, nCY, nSizeX, nSizeY : Integer; var pAngle : Double; pContourRes : PVOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoSubPixelCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelRelease(hSubPixel : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelContoursCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelContoursRelease(hContours : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelSetCvImage(hSubPixel : VOHANDLE; hImage : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelSetImage(hSubPixel : VOHANDLE; pData : PBYTE; nWidth : Integer; nHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelDevernay(hSubPixel : VOHANDLE; hContours : VOHANDLE; nX : Integer; nY : Integer; nWidth : Integer; nHeight : Integer; sigma : Double; th_h : Double; th_l : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoSubPixelGetContoursCount(hContours : VOHANDLE) : Integer; stdcall external VO_INSP_TB_DLL;
function VoSubPixelGetContourArea(hContours : VOHANDLE; nIndex : Integer) : Double; stdcall external VO_INSP_TB_DLL;
function VoSubPixelGetContourPoints(hContours : VOHANDLE; nIndex : Integer) : Integer; stdcall external VO_INSP_TB_DLL;
function VoSubPixelGetContourPointData(hContours : VOHANDLE; nIndex : Integer; nPos : Integer; var pX : Double; var pY : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoFMMRelease(hFMM : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMSetImage(hFMM : VOHANDLE; pData : PBYTE; nWidth : Integer; nHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMResetROI(hFMM : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMSetROIPos(hFMM : VOHANDLE; nPosX : Integer; PosY : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMSetHoleInform(hFMM : VOHANDLE; nSizeX, nSizeY, nPitchX, nPitchY, nAreaMin, nAreaMax : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMSetHoleBinThreshold(hFMM : VOHANDLE; nMin, nMax : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMSetHoleCompareMethod(hFMM : VOHANDLE; nMethod : Integer; nIgnoreHole : Integer; nIgnoreHoleEdge : Integer; nIgnoreMetal : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMSetSubPixel(hFMM : VOHANDLE; dSigma : Double; dThresholdHigh : Double; dThresholdLow : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoFMMSetSpec(hFMM : VOHANDLE; nAreaMin, nAreaMax : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMDoDefectHole(hFMM : VOHANDLE) : Integer; stdcall; external VO_INSP_TB_DLL;
function VoFMMGetHoleData(hFMM : VOHANDLE; nIndex : Integer; var dPosX : Double; var dPosY : Double; var nArea : Integer; var dDefectArea : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMGetDefectHoleCount(hFMM : VOHANDLE) : Integer; stdcall; external VO_INSP_TB_DLL;
function VoFMMGetDefectHoleData(hFMM : VOHANDLE; nIndex : Integer; var dPosX : Double; var dPosY : Double; var dDefectArea : Double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoFMMGetDefectHoleRawData(hFMM : VOHANDLE; nIndex : Integer; var pData : VOHANDLE; var nWidth : Integer; var nHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

procedure voCVCamSetStatusNotifyProc(lpfnStatusNotify : TCamStatusNotifyProc); stdcall; external VO_INSP_TB_DLL;
function VoCVCamCreate() : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoCVCamRelease(hCam : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVCamConnect(hCam : VOHANDLE; nDeviceID : Integer; var nWidth : Integer; var nHeight : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVCamDisonnect(hCam : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVCamGrab(hCam : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoCVCamRetrieve(hCam : VOHANDLE; hImage : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;

function VoBestFitCreate : VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoBestFitRelease(hBestFit : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoBestFitClearPoints(hBestFit : VOHANDLE) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoBestFitAddPoint(hBestFit : VOHANDLE; dPosX : double; dPosY : double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoBestFitRemoveNearestPoint(hBestFit : VOHANDLE; dPosX : double; dPosY : double) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoBestFitGetPointCount(hBestFit : VOHANDLE) : Integer; stdcall; external VO_INSP_TB_DLL;
function VoBestFitDoFit(hBestFit : VOHANDLE; nFitType : Integer) : VOSTATUS; stdcall; external VO_INSP_TB_DLL;
function VoBestFitGetResult(hBestFit : VOHANDLE; nResult : Integer) : double; stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Inspection Life Cycle
// ==================================================
function VoInspectionCreate: VOHANDLE; stdcall; external VO_INSP_TB_DLL;
procedure VoInspectionRelease(h: VOHANDLE); stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Feature Add
// ==================================================
function VoInspectionAddHoleFeature(h: VOHANDLE; id: PAnsiChar; x, y, z: Double; nomDiameter: Double; tolMinus, tolPlus: Double; stepIndex: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddHeightFeature(h: VOHANDLE; id: PAnsiChar; x, y, z: Double; tolMinus, tolPlus: Double; stepIndex: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddSurfaceFeature(h: VOHANDLE; id: PAnsiChar; x, y: Double; roiW, roiH: Double; maxDefectArea: Double; stepIndex: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Step Add
// ==================================================
function VoInspectionAddStepStageMove(h: VOHANDLE; name: PAnsiChar; x, y, z: Double; speed: Double): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepRobotMove(h: VOHANDLE; name: PAnsiChar; j1, j2, j3, j4, j5, j6: Double; speedPercent: Double): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepCapture2D(h: VOHANDLE; name: PAnsiChar; cameraID: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepCapture3D(h: VOHANDLE; name: PAnsiChar; scannerID: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepHeightMeasure(h: VOHANDLE; name: PAnsiChar; gaugeID: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepIO(h: VOHANDLE; name: PAnsiChar; ioChannel: Integer; value: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionAddStepWait(h: VOHANDLE; name: PAnsiChar; milliseconds: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Feature ↔ Step Mapping
// ==================================================
function VoInspectionAddFeatureToStep(h: VOHANDLE; stepIndex: Integer; featureIndex: Integer): Boolean; stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Recipe Control
// ==================================================
procedure VoInspectionNewRecipe(h: VOHANDLE); stdcall; external VO_INSP_TB_DLL;
function VoInspectionSaveRecipe(h: VOHANDLE; fileName: PAnsiChar): Boolean; stdcall; external VO_INSP_TB_DLL;
function VoInspectionLoadRecipe(h: VOHANDLE; fileName: PAnsiChar): Boolean; stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Feature List Handling
// ==================================================
function VoInspectionGetFeatureCount(h: VOHANDLE): Integer; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetFeature(h: VOHANDLE; index: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionRemoveFeature(h: VOHANDLE; index: Integer): Boolean; stdcall; external VO_INSP_TB_DLL;

procedure VoInspectionClearFeature(h: VOHANDLE); stdcall; external VO_INSP_TB_DLL;
// ==================================================
// Step List Handling
// ==================================================
function VoInspectionGetStepCount(h: VOHANDLE): Integer; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetStep(h: VOHANDLE;index: Integer): VOHANDLE; stdcall; external VO_INSP_TB_DLL;
function VoInspectionRemoveStep(h: VOHANDLE;index: Integer): Boolean; stdcall; external VO_INSP_TB_DLL;
procedure VoInspectionClearStep(h: VOHANDLE); stdcall; external VO_INSP_TB_DLL;

// ==================================================
// Safe Feature Remove (Fix Step Mapping)
// ==================================================
function VoInspectionRemoveFeatureAndFixStep(h: VOHANDLE; featureIndex: Integer): Boolean; stdcall; external VO_INSP_TB_DLL;

function VoInspectionGetCurrentStep(h: VOHANDLE; out StepIndex: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetState(h: VOHANDLE): Integer; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetStepType(h: VOHANDLE; StepIndex: Integer): Integer; stdcall; external VO_INSP_TB_DLL;

function VoInspectionGetStageMoveStep(h: VOHANDLE; StepIndex: Integer; out X, Y, Z, Speed: Double): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetRobotMoveStep(h: VOHANDLE; StepIndex: Integer; out J1, J2, J3, J4, J5, J6, SpeedPercent: Double): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetCapture2DStep(h: VOHANDLE; StepIndex: Integer; out CameraID: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetCapture3DStep(h: VOHANDLE; StepIndex: Integer; out ScannerID: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetHeightMeasureStep(h: VOHANDLE; StepIndex: Integer; out GaugeID: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetIOStep(h: VOHANDLE; StepIndex: Integer; out IOChannel: Integer; out Value: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;
function VoInspectionGetWaitStep(h: VOHANDLE; StepIndex: Integer; out Milliseconds: Integer): BOOL; stdcall; external VO_INSP_TB_DLL;

function VoInspectionSetStepCallback(h: VOHANDLE; StepIndex: Integer; cb: TStepExecuteCallback; userCtx: Pointer): Boolean; stdcall; external VO_INSP_TB_DLL;

function VoInspectionRun(h: VOHANDLE): Boolean; stdcall; external VO_INSP_TB_DLL;
function VoInspectionStop(h: VOHANDLE): Boolean; stdcall; external VO_INSP_TB_DLL;
function VoInspectionPause(h: VOHANDLE): Boolean; stdcall; external VO_INSP_TB_DLL;
function VoInspectionResume(h: VOHANDLE): Boolean; stdcall; external VO_INSP_TB_DLL;


implementation



end.




