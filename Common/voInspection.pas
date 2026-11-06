unit voInspection;

interface

uses
  Windows, Classes, vocore;



const
// Types of thresholding
//VoInspectionThreshold Method
CV_THRESH_BINARY      = 0;  // value = value > threshold ? max_value : 0
CV_THRESH_BINARY_INV  = 1;  // value = value > threshold ? 0 : max_value
CV_THRESH_TRUNC       = 2;  // value = value > threshold ? threshold : value
CV_THRESH_TOZERO      = 3;  // value = value > threshold ? value : 0
CV_THRESH_TOZERO_INV  = 4;  // value = value > threshold ? 0 : value           
CV_THRESH_MASK        = 7;

CV_THRESH_OTSU        = 8;  // use Otsu algorithm to choose the optimal threshold value;
                            //      combine the flag with one of the above CV_THRESH_* values

CV_2_THRESH_BINARY      = 10;  //value = value > threshold1 & value < threshold2  ? max_value : 0
CV_2_THRESH_BINARY_INV  = 11;  //value = value > threshold1 & value < threshold2  ? 0 : max_value


const
  CV_BLUR_NO_SCALE  = 0;
  CV_BLUR           = 1;
  CV_GAUSSIAN       = 2;
  CV_MEDIAN         = 3;
  CV_BILATERAL      = 4;


const
	//function VoImageSobelFilter(hImage : VOHANDLE; hROI : VOHANDLE; iFilterType : Integer; hFilterImage : VOHANDLE) : VOSTATUS;
	//iFilterType
	TIB_SE_FT_SUM_ABS      = 1;
	TIB_SE_FT_SUM_SQRT     = 2;
	TIB_SE_FT_X            = 3;
	TIB_SE_FT_Y            = 4;

const
  FLIP_MODE_BOTH          = 1;
  FLIP_MODE_HORIZONTAL    = 2;
  FLIP_MODE_VERTICAL      = 3;


type

	TDoubleArray = array [0..640] of double;
  PDoubleArray = ^TDoubleArray;
  PSingle = ^Single;

  
function VoInspectionFinalize : VOSTATUS; stdcall;
function VoInspectionCreateImage(Width, Height, Depth, Channels: Integer; hImage : PVOHANDLE) : VOHANDLE; stdcall;
function VoInspectionFreeImage(hImage : VOHANDLE) : VOSTATUS; stdcall;
function VoInspectionCreateImageData(pBuffer : PByte; Width, Height : Integer; hImage : PVOHANDLE) : VOHANDLE; stdcall;
function VoInspectionCreateImageDataEx(pBuffer : PByte; Width, Height, Depth, Channels : Integer; hImage : PVOHANDLE) : VOHANDLE; stdcall;
function VoInspectionFreeImageData(hImage : VOHANDLE) : VOSTATUS; stdcall;

function VoInspectionLoadFromFile(szFileName : PAnsiChar; isColor : Integer; hImage : VOHANDLE) : VOSTATUS; stdcall;
function VoInspectionSaveToFile(hImage : VOHANDLE; szFileName : PAnsiChar) : VOHANDLE; stdcall;
function VoBufferImageCopy(hImageSrc, hImageDest : VOHANDLE): VOHANDLE; stdcall;
function VoInspectionGetImageSize(hImgSrc : VOHANDLE; var Width : Integer; var Height : Integer) : VOHANDLE; stdcall;
function VoInspectionGetImageData(hImgSrc : VOHANDLE; pBuffer : PByte) : VOHANDLE; stdcall;

function VoInspectionCopyImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; nType : Integer) : VOHANDLE; stdcall;
function VoInspectionCopyColorCOIToGrayImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; nCOI : Integer) : VOHANDLE; stdcall;
function VoInspectionFlipImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; nFlipMode : Integer) : VOHANDLE; stdcall;
function VoInspectionRotationImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;


function VoInspectionSetImageROI(hImgSrc : VOHANDLE; X, Y, Width, Height : Integer) : VOHANDLE; stdcall;
function VoInspectionGetImageROI(hImgSrc : VOHANDLE; var X : Integer; var Y : Integer; var Width : Integer; var Height : Integer) : VOHANDLE; stdcall;
function VoInspectionSetImageCOI(hImgSrc : VOHANDLE; nCOI : Integer) : VOHANDLE; stdcall;
function VoInspectionSetPixel(hImgSrc : VOHANDLE; X, Y : Integer; Value : Char) : VOHANDLE; stdcall;
function VoInspectionGetPixel(hImgSrc : VOHANDLE; X, Y : Integer; var Value : AnsiChar) : VOHANDLE; stdcall;
function VoInspectionGetMean(hImgSrc : VOHANDLE) : Integer; stdcall;

function VoInspectionSmooth(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; smoothtype, param1, param2 : Integer; param3, param4 : Double) : VOSTATUS; stdcall;

function VoInspectionAddImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE; hImgMask : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionSubImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE; hImgMask : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionAbsDiffImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionOrImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE; hImgMask : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionXorImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE; hImgMask : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionNotImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionMaxImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;
function VoInspectionMinImage(hImgSrc1 : VOHANDLE; hImgSrc2 : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;

//morphology
function VoInspectionErodeImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; iterations : Integer) : VOHANDLE; stdcall;
function VoInspectionDilateImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; iterations : Integer) : VOHANDLE; stdcall;
function VoInspectionOpenImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; iterations : Integer) : VOHANDLE; stdcall;
function VoInspectionCloseImage(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; iterations : Integer) : VOHANDLE; stdcall;

function VoInspectionMakeEdgeMask(hImgSrc : VOHANDLE; hImgDst : VOHANDLE) : VOHANDLE; stdcall;


function VoInspectionThreshold(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; nTh1, nTh2, nMethod : Integer) : VOSTATUS; stdcall;
function VoInspectionGetAutoThreshold(hImgSrc : VOHANDLE; X, Y, Width, Height : Integer) : VOSTATUS; stdcall;

function VoInspectionCreateMarkModel(hImage : VOHANDLE; X, Y, Width, Height, nSearchLayer, nSearchScore, nThreshold : Integer; hMarkModel : PVOHANDLE) : VOHANDLE; stdcall;
function VoInspectionFreeMarkModel(hMarkModel : VOHANDLE) : VOSTATUS; stdcall;
function VoInspectionSearchMarkModel(hMarkModel : VOHANDLE; hImage : VOHANDLE; X, Y, Width, Height : Integer; var Score : Double; var DX : Double; var DY : Double) : VOSTATUS; stdcall;
function VoInspectionAddMarkModel(hMarkModel : VOHANDLE; hImage : VOHANDLE; X, Y, Width, Height : Integer) : VOHANDLE; stdcall;
function VoInspectionUpdateMarkModel(hMarkModel : VOHANDLE; hImage : VOHANDLE) : VOHANDLE; stdcall;

function VoInspectionMarkModelOverPrint(hMarkModel : VOHANDLE; hImage : VOHANDLE; nDontcare, nMinSize, nThreshold : Integer; var nSize : Integer; hRegion : VOHANDLE) : VOSTATUS; stdcall;

function VoInspectionMurgeBlobArea(hImgSrc : VOHANDLE; X, Y, Width, Height, ignore, nColorBlack, nThreshold : Integer; var nBlobSize, BlobX, BlobY, BlobWidth, BlobHeight : Integer) : VOSTATUS; stdcall;
function VoInspectionBubbleDetect(hImgSrc : VOHANDLE; hImgDst : VOHANDLE;  hImgMsk : VOHANDLE;  nColorBlack, nThreshold, nMaskSize, nInterval, nMinThreshold, nMaxThreshold : Integer) : VOSTATUS; stdcall;


function VoInspectionBlobArea(hImgSrc : VOHANDLE; ignore, nColorBlack, nThreshold : Integer) : VOSTATUS; stdcall;
function VoInspectionGetBlobArea(nBlobNo : Integer; var nBlobSize, BlobX, BlobY, BlobWidth, BlobHeight : Integer) : VOSTATUS; stdcall;

function VoInspectionCannyEdge(hImgSrc : VOHANDLE; hImgDst : VOHANDLE; X, Y, Width, Height : Integer; nThreshold1, nThreshold2 : Double; Aperture : Integer) : VOSTATUS; stdcall;

// 3D Profile
function VoInspectionMeasureVerticalEdge(hImgSrc : VOHANDLE; nSrcX, nSrcY, nSrcWidth, nSrcHeight : Integer; nRad :Integer; bEdgeColor : Integer; bReverse : Integer; value : Double;  pData : PDoubleArray; hImgDst : VOHANDLE; nDstX, nDstY : Integer) : VOSTATUS; stdcall;
function VoInspectionMeasureHorizontalEdge(hImgSrc : VOHANDLE; nSrcX, nSrcY, nSrcWidth, nSrcHeight : Integer; nRad :Integer; bEdgeColor : Integer; bReverse : Integer; value : Double;  pData : PDoubleArray; hImgDst : VOHANDLE; nDstX, nDstY : Integer) : VOSTATUS; stdcall;
function VoInspectionCopy3DDataToImage(hImgSrc, hImgDst : VOHANDLE; nSrcX, nSrcY, nSrcWidth, nSrcHeight : Integer; nLevel : Integer; dScale : Double) : VOSTATUS; stdcall;
function VoInspectionCopy3DDataToImageData(hImgSrc : VOHANDLE; pBuffer : PAnsiChar; nSrcX, nSrcY, nSrcWidth, nSrcHeight : Integer) : VOSTATUS; stdcall;
function VoInspection3DThresholdToImage(hImgSrc, hImgDst : VOHANDLE; nSrcX, nSrcY, nSrcWidth, nSrcHeight : Integer; dThreshold1, dThreshold2 : Double) : VOSTATUS; stdcall;
function VoInspection3DGetHeight(hImgSrc : VOHANDLE; dCutLine : Double; var dResultMin : Double; var dResultMax : Double; var dResultMinAvg : Double; var dResultMaxAvg : Double; var dResultAvg : Double) : VOSTATUS; stdcall;
function VoInspection3DGetWidth(hImgSrc : VOHANDLE; dCutLine : Double; nEdgeDir : Integer; var dResutUpperStart : Double; var dResutUpperEnd : Double; var dResutLowerStart : Double; var dResutLowerEnd : Double) : VOSTATUS; stdcall;

function VoInspection3DGetHeightMinAvg(hImgSrc : VOHANDLE; nAvgCnt : Integer; var dResultMinAvg : Double) : VOSTATUS; stdcall;
function VoInspection3DGetHeightMaxAvg(hImgSrc : VOHANDLE; nAvgCnt : Integer; var dResultMaxAvg : Double) : VOSTATUS; stdcall;


//circle

function VoInspectionSetCircleParam(hImgSrc : VOHANDLE; HoleKind : Integer; SamplingInterval : Integer; Arc : Integer; Threshold : Integer; MinBlob : Integer; Circularity : Double) : Integer; stdcall;
function VoInspectionCircleMeasure(hImgSrc : VOHANDLE): Integer; stdcall;//; X, Y, Width, Height : integer): Integer; stdcall;
function VoInspectionGetCircleResult(nCh : integer; hImgSrc : VOHANDLE; X, Y, Width, Height : integer; var nx: Double; var ny: Double; var radius: Double; var circularity : double; var blob : integer) : VOSTATUS; stdcall;


function VoInspectionSet3DData(nIndex : Integer; dX, dY, dZ, dXRef, dYRef : Double) : VOSTATUS; stdcall;
function VoInspectionCoplanarity(nCount : Integer; x1, y1, z1, x2, y2, z2, x3, y3, z3 : Double) : VOSTATUS; stdcall;
function VoInspectionGetCoplanarityError(nIndex : integer; var dX : Double; var dY : Double; var dZ : Double) : VOSTATUS; stdcall;

function VoInspectionSetImageCrossLine(hImgSrc : VOHANDLE; nX, nY, nWidth, nHeight, nLineWidth : Integer): Integer; stdcall;


function VoBufferViewCreate(iWidth, iHeight : Integer) : VOHANDLE; stdcall;
function VoBufferViewRelease(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferViewClearAll() : VOSTATUS; stdcall;

function VoBufferViewIsValid(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferViewSetPen(hBuffer : VOHANDLE; iPenStyle, iThickness, iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetStockPen(hBuffer : VOHANDLE; iPen : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetSolidBrush(hBuffer : VOHANDLE; iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetStockBrush(hBuffer : VOHANDLE; iBrush : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetHatchBrush(hBuffer : VOHANDLE; iStyle, iRed, iGreen, iBlue : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetZoomFactor(hBuffer : VOHANDLE; dZoomFactor : Double) : VOSTATUS; stdcall;
function VoBufferViewSetImageRect(hBuffer : VOHANDLE; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall;
function VoBufferViewSetDrawRect(hBuffer : VOHANDLE; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall;
function VoBufferViewDrawRectangle(hDC : HDC; hBuffer : VOHANDLE; iLeft, iTop, iWidth, iHeight : Integer) : VOSTATUS; stdcall;
function VoBufferViewDrawTo(hBuffer : VOHANDLE; DC : HDC; iX, iY : Integer) : VOSTATUS; stdcall;
function VoBufferViewDrawImage(hDC : HDC; hBufferView, hImage : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferViewDrawCross(hBuffer : VOHANDLE; DC : HDC; dCX, dCY, dXHalfLength, dYHalfLength : Double) : VOSTATUS; stdcall;
function VoBufferViewDrawVector(hDC : HDC; hBuffer, hIVector : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferViewDrawRegion(hDC : HDC; hBuffer, hRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferViewDrawLine(hDC : HDC; hBuffer : VOHANDLE; dX1, dY1, dX2, dY2 : Double) : VOSTATUS; stdcall;

function VoBufferImageCreate(iWidth, iHeight : Integer;  hImage : VOHANDLE) : VOHANDLE; stdcall;
function VoBufferImageCreateExtern(iWidth, iHeight : Integer; hImage : VOHANDLE) : VOHANDLE; stdcall;
function VoBufferImageCreateExternColor(iWidth, iHeight : Integer; hImage : VOHANDLE) : VOHANDLE; stdcall;
function VoBufferImageCreateExternColor4(iWidth, iHeight : Integer; hImage : VOHANDLE) : VOHANDLE; stdcall;
function VoBufferImageRelease(hBuffer : VOHANDLE) : VOSTATUS; stdcall;
function VoBufferImageLoadFromFile(hImage : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall;
function VoBufferImageLoadFromFileExtern(hImage : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall;
function VoBufferImageSaveFromFile(hImage : VOHANDLE; szFileName : PAnsiChar) : VOSTATUS; stdcall;
function VoBufferImageGetRawImageData(hImage : VOHANDLE; var pWidth : Integer; var pHeight : Integer; hImageSrc : PVOHANDLE) : VOHANDLE; stdcall;
function VoImageGetMean(hImage, hROIRegion : VOHANDLE; var pdMean : Double) : VOSTATUS ; stdcall;
function VoImageMeanFilter(hImage : VOHANDLE; hROI : VOHANDLE; nMaskWidth, nMaskHeight : Integer; hFilterImage : VOHANDLE) : VOSTATUS ; stdcall;
function VoImageSobelFilter(hImage : VOHANDLE; hROI : VOHANDLE; iFilterType : Integer; hFilterImage : VOHANDLE) : VOSTATUS ; stdcall;
function VoImageDiffofGaussFilter(hImage : VOHANDLE; hROI : VOHANDLE; dSigma, dSigFactor : Double; hFilterImage : VOHANDLE) : VOSTATUS ; stdcall;

function VoImageSub(hImageSrc, hImageDest, hImageSub : VOHANDLE) : VOSTATUS ; stdcall;

function VoImageProcessingThreshold(hImage, hROIRegion : VOHANDLE; iMin, iMax : Integer; hRegion : VOHANDLE) : VOSTATUS ; stdcall;
function VoImageProcessingAutoThreshold(hImage, hROIRegion : VOHANDLE; dSigma : double; iSelectArea : Integer; hRegion : VOHANDLE) : VOSTATUS; stdcall;

function VoRegionCreate() : VOHANDLE; stdcall;
function VoRegionRectangleCreate(iX, iY, iWidth, iHeight : Integer) : VOHANDLE; stdcall;
function VoRegionRectangle1Create(iLeft, iTop, iRight, iBottom : Integer) : VOHANDLE; stdcall;
function VoRegionTriangleCreate(dPosX1, dPosY1, dPosX2, dPosY2, dPosX3, dPosY3 : Double) : VOHANDLE; stdcall;
function VoRegionRectCreate(dPosX1, dPosY1, dPosX2, dPosY2, dPosX3, dPosY3, dPosX4, dPosY4 : Double) : VOHANDLE; stdcall;
function VoRegionAngleRectangleCreate(dXCenter, dYCenter, dAngle, dLength1, dLength2 : Double) : VOHANDLE; stdcall;
function VoRegionAngleEllipseCreate(dXCenter, dYCenter, dAngle, dLength1, dLength2 : Double) : VOHANDLE; stdcall;
function VoRegionCircleCreate(dCenterX, dCenterY, dRadius : Double) : VOHANDLE; stdcall;
function VoRegionEllipseCreate(iLeft, iTop, iRight, iBottom : Integer) : VOHANDLE; stdcall;
function VoRegionGridCreate(iLeft, iTop, iRight, iBottom, iXDistance, iYDistance, iHalfThickness : Integer) : VOHANDLE; stdcall;
function VoRegionRelease(hPRegion : VOHANDLE) : VOSTATUS; stdcall;

function VoRegionSegmentConnected(hSrcRegion : VOHANDLE; hDestRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionGetRegionCount(hRegionList : VOHANDLE; var iCount : Integer) : VOSTATUS; stdcall;
function VoRegionSelectRegion(hRegion : VOHANDLE; SelCondition : PAnsiChar; LogicalOp : Integer; hSelectRegion :  VOHANDLE) : VOSTATUS; stdcall;
function VoRegionSelectShape(hRegion : VOHANDLE ; SelCondition : PAnsiChar; hSelectRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionSelectMinMax(hRegion : VOHANDLE; Feature : Integer; hSelectRegion :  VOHANDLE) : VOSTATUS; stdcall;
function VoRegionGetRegion(hRegionList : VOHANDLE; iIndex : Integer; hSelectRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionFillUp(hSrcRegion, hDestRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionIntersection(hRegionOne, hRegionTwo : VOHANDLE; hRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionUnion(hRegionOne, hRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionDifference(hRegionOne, hRegionTwo : VOHANDLE; hRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionUnionRegionList(hSrcRegion, hDestRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionErosion(hRegion, hStructElement, hErosionRegion : VOHANDLE) : VOSTATUS; stdcall;
function VoRegionDilation(hRegion, hStructElement, hDilationRegion : VOHANDLE) : VOSTATUS; stdcall;

function VoRegionGetCount(hPRegion : VOHANDLE) : Integer; stdcall;
function VoRegionGetRectangle(hPRegion : VOHANDLE; var ipLeft : Integer; var ipTop : Integer; var ipRight : Integer; var ipBottom : Integer) : VOSTATUS; stdcall;
function VoRegionGetAngleRectangle(hPRegion : VOHANDLE; var dpXCenter : Double; var dpYCenter : Double; var dpAngle : Double; var dpLength1 : Double; var dpLength2 : Double) : VOSTATUS; stdcall;
function VoRegionListGetAngleRectangle(hPRegion : VOHANDLE; iIndex: Integer; var dpXCenter : Double; var dpYCenter : Double; var dpAngle : Double; var dpLength1 : Double; var dpLength2 : Double) : VOSTATUS; stdcall;
function VoRegionGetAreaCenter(hPRegion : VOHANDLE; var ipArea : Integer; var dpX : Double; var dpY : Double) : VOSTATUS; stdcall;
function VoRegionGetTickness(hPRegion : VOHANDLE; iStep : Integer; var dpMeanDiameter : Double; var dpMinDiameter : Double) : VOSTATUS; stdcall;

function VoRegionTransfer(hPRegion : VOHANDLE; dTX : Double; dTY : Double; dTAangle, dRX, dRY : Double; hTransRegion : VOHANDLE) : VOSTATUS; stdcall;

function VoVectorCreate() : VOHANDLE; stdcall;
function VoVectorRelease(hVector : VOHANDLE) : VOSTATUS; stdcall;
function VoVectorClearAll() : VOHANDLE; stdcall;

function VoMeasureToolLineCreate(dXStart, dYStart, dXEnd, dYEnd, dThickness : Double; iInterpolation, iImageWidth, iImageHeight : Integer) : VOHANDLE; stdcall;
function VoMeasureToolArcCreate(dXCenter, dYCenter, dRadius, dAngleStart, dAngleEnd, dThickness : Double; iInterpolation, iImageWidth, iImageHeight : Integer) : VOHANDLE; stdcall;
function VoMeasureToolMeasurePos(hImage : VOHANDLE; dSigma, dThreshold : Double; iTransition : Integer) : VOHANDLE; stdcall;
function VoMeasureToolMeasurePairs(hImage : VOHANDLE; dSigma, dThreshold : Double; iTransition : Integer) : VOHANDLE; stdcall;
function VoMeasureToolGetEdgeCount(var iFirstCount : Integer; var iSecoundCount : Integer) : VOHANDLE; stdcall;
function VoMeasureToolGetFirstPos(iIndex : Integer; var dX : Double; var dY : Double) : VOHANDLE; stdcall;
function VoMeasureToolGetSecondtPos(iIndex : Integer; var dX : Double; var dY : Double) : VOHANDLE; stdcall;
function VoMeasureToolGetFirstAmplitude(iIndex : Integer; var dValue : Double) : VOHANDLE; stdcall;
function VoMeasureToolGetSecondtAmplitude(iIndex : Integer; var dValue : Double) : VOHANDLE; stdcall;

function VoSearchToolTemplateCreate(hImage, hROIRegion : VOHANDLE; iLevel : Integer; hSearchTemplate : PVOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolTemplateSearch(hImage, hSearchROIRegion, hSearchTemplate : VOHANDLE; iSearchLevel : Integer; var dRX : Double; var dRY : Double; var dRScore : Double) : VOSTATUS; stdcall;

function VoSearchToolTemplateRotCreate(hImage, hROIRegion : VOHANDLE; iLevel : Integer; dAngleStart, dAngleExtend, dAngleStep : Double; hSearchTemplate : PVOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolTemplateRotSearch(hImage, hSearchROIRegion, hSearchTemplate : VOHANDLE; iSearchLevel : Integer; dAngleStart, dAngleExtend : Double;  var dRX : Double; var dRY : Double; var dRScore : Double; var dRAngle : Double) : VOSTATUS; stdcall;

function VoSearchToolShapeCreate(hImage, hROIRegion : VOHANDLE; iLevel, iMetric, iContrast, iMinContrast : Integer; dAngleStart, dAngleExtend, dAngleStep : Double; hSearchTemplate : PVOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolShapeSearch(hImage, hSearchROIRegion, hSearchTemplate : VOHANDLE; iSearchLevel, iContrast : Integer; dMinScore, dAngleStart, dAngleExtend : Double; hRegion : PVOHANDLE) : VOSTATUS; stdcall;

function VoSearchToolScaledShapeCreate(hImage, hROIRegion : VOHANDLE; iNumLevel : Integer; dAngleStart,	dAngleExtent, dAngleStep, dScaleMin, dScareMax, dScaleStep : Double; iOptimization, iMetric, iContrast, iMinContrast : Integer; hSearchTemplate : PVOHANDLE; hTemplateVector : PVOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolScaledShapeSearch(hImage, hSearchROIRegion, hSearchTemplate : VOHANDLE; dAngleStart, dAngleExtent, dScaleMin, dScareMax : Double; dMinScore : Double; nNumMatches : Integer ; dMaxOverlap : Double; iSubPixel, iNumLevels : Integer; dGreediness : Double ; var dRX : Double; var dRY : Double; var dRScore : Double; var dRAngle : Double; hSearchVector : PVOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolRelease(hSearchTemplate : VOHANDLE) : VOSTATUS; stdcall;
function VoSearchToolResultCount(hSearchTemplate : VOHANDLE) : Integer; stdcall;
function VoSearchToolResult(hSearchTemplate : VOHANDLE; nIndex : Integer; var dRX : Double; var dRY : Double; var dRScore : Double; var dRAngle : Double) : VOSTATUS; stdcall;
function VoCreateTemplate(nWidth, nHeight, nThickness : Integer; FileName : PAnsiChar) : VOSTATUS; stdcall;
function VoCreateRectTemplate(nImageW, nImageH, nFGray, nBGray : Integer; hRegion : VOHANDLE ; FileName : PAnsiChar) : VOSTATUS; stdcall;
function VoFunctionGetAngle(dSX, dSY, dEX, dEY : Double ; bReverse : Bool) : Double; stdcall;
function VoFunctionGetRotatePoint(dAngle, dCX, dCY : Double; var dX : Double; var dY : Double) : VOSTATUS; stdcall

function VoArrayPosClear() : VOSTATUS; stdcall;
function VoArrayPosAdd(dX, dY : Double) : VOSTATUS; stdcall;
function VoGetLine(dX1, dY1, dX2, dY2 : Double; var dpA : Double; var dpB : Double; var dpC : Double) : VOSTATUS; stdcall;
function VoGetLRLine(nType : Integer; var dpA : Double; var dpB : Double; var dpC : Double) : VOSTATUS; stdcall;
function VoGetLineIntersection(dA1,dB1,dC3,dA2,dB2,dC2 : Double; var dpX : Double; var dpY : Double) : VOSTATUS; stdcall;

function VoRegionPolygonArrayClear() : VOSTATUS; stdcall
function VoRegionPolygonArrayAdd(dX, dY : Double) : VOSTATUS; stdcall
function VoRegionPolygonCreate() : VOHANDLE; stdcall;

function VoGetAngle(dCX, dCY, dX, dY : Double; var dAngle : Double) : VOSTATUS; stdcall
function VoConvertDegree(dAngle : Double; var dDAngle : Double) : VOSTATUS; stdcall
function VoConvertRadian(dAngle : Double; var dRAngle : Double) : VOSTATUS; stdcall
function VoGetRotatePoint(dAngle, dCX, dCY : Double; var dX : Double; var dY : Double) : VOSTATUS; stdcall

function VoPaintRegion(hRegion : VOHANDLE; hImage : VOHANDLE ; dGrayValue : Double) : VOSTATUS; stdcall
function VoGet3PointCircle(X1, Y1, X2, Y2, X3, Y3 : Double; var CX : Double; var CY : Double; var R : Double) : VOSTATUS; stdcall
function VoGetOriginPos2(ATargetX : Double; ATargetY : Double; AAngle : Double; ADestX : Double; ADestY : Double; var AOriginX : Double; var AOriginY : Double) : VOSTATUS; stdcall
function VoRegionGetCircularity(hRegion : VOHANDLE; var dCircularity : Double) : VOSTATUS; stdcall
function VoGetFitCircle(hRegion : VOHANDLE; var dCX : Double; var dCY : Double; var dRadius : Double; var dStartPhi : Double; var dEndPhi : Double) : VOSTATUS; stdcall
function VoGetFitEllipse(hRegion : VOHANDLE; var dCX : Double; var dCY : Double; var dPhi : Double; var dRadius1 : Double; var dRadius2 : double) : VOSTATUS; stdcall
function VoGetFitEllipseA(var dCX : Double; var dCY : Double; var dPhi : Double; var dRadius1 : Double; var dRadius2 : double) : VOSTATUS; stdcall
function VoGetFindSymmetricCenter(wsize : Integer; var mscore : Double) : Integer; stdcall

function VoFlip(nDirection : Integer ;hImage : VOHANDLE) : VOSTATUS; stdcall
function VoBufferImageCreateExternToFlip(nWidth, nHeight: Integer; hBufferPointer : VOHANDLE; iDirection : Integer;  hImage : VOHANDLE) : VOSTATUS; stdcall

function VoBufferImageCrossMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nHeigth, nWidth, nTickness : Integer): VOSTATUS; stdcall;
function VoBufferImageDCrossMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nHeigth, nWidth, nTickness, nOffsetX, nOffsetY : Integer): VOSTATUS; stdcall;
function VoBufferImageRectangleMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nHeigth, nWidth : Integer): VOSTATUS; stdcall;
function VoBufferImageCircleMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nRadius : Double): VOSTATUS; stdcall;
function VoBufferImageEllipseMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nRadiusX : Double; nRadiusY : Double): VOSTATUS; stdcall;
function VoBufferImageEllipseAngleMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, dAngle : Double; dRadiusX : Double; dRadiusY : Double): VOSTATUS; stdcall;
function VoBufferImageGiyeokMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nWidth, nHeigth, nXTickness, nYTickness : Integer) : VOSTATUS; stdcall;
function VoBufferImageReverseGiyeokMarkPaint(hTIPIImage : VOHANDLE; nCX, nCY, nWidth, nHeigth, nXTickness, nYTickness : Integer) : VOSTATUS; stdcall;
function VoBufferImageNieunMarkPaint(hTIPIImage : VOHANDLE; dCX, dCY, nWidth, nHeigth, nXTickness, nYTickness : Integer) : VOSTATUS; stdcall;
function VoBufferImageReverseNieunMarkPaint(hTIPIImage : VOHANDLE; dCX, dCY, nWidth, nHeigth, nXTickness, nYTickness : Integer) : VOSTATUS; stdcall;

implementation

const
  PM_DLL = 'voInspection.dll';

function VoInspectionFinalize; external PM_DLL;
function VoInspectionCreateImage; external PM_DLL;
function VoInspectionFreeImage; external PM_DLL;
function VoInspectionCreateImageData; external PM_DLL;
function VoInspectionCreateImageDataEx; external PM_DLL;
function VoInspectionFreeImageData; external PM_DLL;
function VoInspectionLoadFromFile; external PM_DLL;
function VoInspectionSaveToFile; external PM_DLL;
function VoInspectionGetImageSize; external PM_DLL;
function VoInspectionGetImageData; external PM_DLL;
function VoInspectionSetImageROI; external PM_DLL;
function VoInspectionGetImageROI; external PM_DLL;
function VoInspectionSetImageCOI; external PM_DLL;
function VoInspectionCopyImage; external PM_DLL;
function VoInspectionCopyColorCOIToGrayImage; external PM_DLL;
function VoInspectionFlipImage; external PM_DLL;
function VoInspectionRotationImage; external PM_DLL;
function VoInspectionSetPixel; external PM_DLL;
function VoInspectionGetPixel; external PM_DLL;
function VoInspectionGetMean; external PM_DLL;
function VoInspectionSmooth; external PM_DLL;
function VoInspectionAddImage; external PM_DLL;
function VoInspectionSubImage; external PM_DLL;
function VoInspectionAbsDiffImage; external PM_DLL;
function VoInspectionOrImage; external PM_DLL;
function VoInspectionXorImage; external PM_DLL;
function VoInspectionNotImage; external PM_DLL;
function VoInspectionMaxImage; external PM_DLL;
function VoInspectionMinImage; external PM_DLL;
function VoInspectionErodeImage; external PM_DLL;
function VoInspectionDilateImage; external PM_DLL;
function VoInspectionOpenImage; external PM_DLL;
function VoInspectionCloseImage; external PM_DLL;


function VoInspectionMakeEdgeMask; external PM_DLL;

function VoInspectionCreateMarkModel; external PM_DLL;
function VoInspectionFreeMarkModel; external PM_DLL;
function VoInspectionSearchMarkModel; external PM_DLL;
function VoInspectionAddMarkModel; external PM_DLL;
function VoInspectionUpdateMarkModel; external PM_DLL;

function VoInspectionMarkModelOverPrint; external PM_DLL;
function VoInspectionThreshold; external PM_DLL;
function VoInspectionGetAutoThreshold; external PM_DLL;
function VoInspectionMurgeBlobArea; external PM_DLL;
function VoInspectionBubbleDetect; external PM_DLL;

function VoInspectionBlobArea; external PM_DLL;
function VoInspectionGetBlobArea; external PM_DLL;

function VoInspectionCannyEdge; external PM_DLL;
function VoInspectionMeasureVerticalEdge; external PM_DLL;
function VoInspectionMeasureHorizontalEdge; external PM_DLL;
function VoInspectionCopy3DDataToImage; external PM_DLL;
function VoInspectionCopy3DDataToImageData; external PM_DLL;
function VoInspection3DThresholdToImage; external PM_DLL;
function VoInspection3DGetHeight; external PM_DLL;
function VoInspection3DGetWidth; external PM_DLL;

function VoInspection3DGetHeightMinAvg; external PM_DLL;
function VoInspection3DGetHeightMaxAvg; external PM_DLL;

function VoInspectionSetCircleParam; external PM_DLL;
function VoInspectionCircleMeasure; external PM_DLL;
function VoInspectionGetCircleResult; external PM_DLL;

function VoInspectionSet3DData; external PM_DLL;
function VoInspectionCoplanarity; external PM_DLL;
function VoInspectionGetCoplanarityError; external PM_DLL;
function VoInspectionSetImageCrossLine; external PM_DLL;

function VoBufferViewCreate; external PM_DLL;
function VoBufferViewRelease; external PM_DLL;
function VoBufferViewClearAll; external PM_DLL;

function VoBufferViewIsValid; external PM_DLL;
function VoBufferViewSetPen; external PM_DLL;
function VoBufferViewSetStockPen; external PM_DLL;
function VoBufferViewSetSolidBrush; external PM_DLL;
function VoBufferViewSetStockBrush; external PM_DLL;
function VoBufferViewSetHatchBrush; external PM_DLL;
function VoBufferViewSetZoomFactor; external PM_DLL;
function VoBufferViewSetImageRect; external PM_DLL;
function VoBufferViewSetDrawRect; external PM_DLL;
function VoBufferViewDrawRectangle; external PM_DLL;
function VoBufferViewDrawTo; external PM_DLL;
function VoBufferViewDrawCross; external PM_DLL;
function VoBufferViewDrawImage; external PM_DLL;
function VoBufferViewDrawVector; external PM_DLL;
function VoBufferViewDrawRegion; external PM_DLL;
function VoBufferViewDrawLine; external PM_DLL;

function VoBufferImageCreate; external PM_DLL;
function VoBufferImageCreateExtern; external PM_DLL;
function VoBufferImageCreateExternColor; external PM_DLL;
function VoBufferImageCreateExternColor4; external PM_DLL;
function VoBufferImageRelease; external PM_DLL;
function VoBufferImageLoadFromFile; external PM_DLL;
function VoBufferImageLoadFromFileExtern; external PM_DLL;
function VoBufferImageSaveFromFile; external PM_DLL;
function VoBufferImageCopy; external PM_DLL;
function VoBufferImageGetRawImageData; external PM_DLL;
function VoImageGetMean; external PM_DLL;
function VoImageMeanFilter; external PM_DLL;
function VoImageSobelFilter; external PM_DLL;
function VoImageDiffofGaussFilter; external PM_DLL;
function VoImageSub; external PM_DLL;

function VoImageProcessingThreshold; external PM_DLL;
function VoImageProcessingAutoThreshold; external PM_DLL;

function VoRegionCreate; external PM_DLL;
function VoRegionRectangleCreate; external PM_DLL;
function VoRegionRectangle1Create; external PM_DLL;
function VoRegionAngleRectangleCreate; external PM_DLL;
function VoRegionAngleEllipseCreate; external PM_DLL;
function VoRegionTriangleCreate; external PM_DLL;
function VoRegionRectCreate; external PM_DLL;

function VoRegionCircleCreate; external PM_DLL;
function VoRegionEllipseCreate; external PM_DLL;
function VoRegionGridCreate; external PM_DLL;
function VoRegionRelease; external PM_DLL;

function VoRegionSegmentConnected; external PM_DLL;
function VoRegionGetRegionCount; external PM_DLL;
function VoRegionSelectRegion; external PM_DLL;
function VoRegionSelectShape; external PM_DLL;
function VoRegionSelectMinMax; external PM_DLL;
function VoRegionGetRegion; external PM_DLL;
function VoRegionFillUp; external PM_DLL;
function VoRegionIntersection; external PM_DLL;
function VoRegionUnion; external PM_DLL;
function VoRegionDifference; external PM_DLL;
function VoRegionUnionRegionList; external PM_DLL;
function VoRegionErosion; external PM_DLL;
function VoRegionDilation; external PM_DLL;
function VoRegionGetCount; external PM_DLL;
function VoRegionGetRectangle; external PM_DLL;
function VoRegionGetAngleRectangle; external PM_DLL;
function VoRegionListGetAngleRectangle; external PM_DLL;
function VoRegionGetAreaCenter; external PM_DLL;
function VoRegionGetTickness; external PM_DLL;

function VoRegionTransfer; external PM_DLL;

function VoVectorCreate; external PM_DLL;
function VoVectorRelease; external PM_DLL;
function VoVectorClearAll; external PM_DLL;

function VoMeasureToolLineCreate; external PM_DLL;
function VoMeasureToolArcCreate; external PM_DLL;
function VoMeasureToolMeasurePos; external PM_DLL;
function VoMeasureToolMeasurePairs; external PM_DLL;
function VoMeasureToolGetEdgeCount; external PM_DLL;
function VoMeasureToolGetFirstPos; external PM_DLL;
function VoMeasureToolGetSecondtPos; external PM_DLL;
function VoMeasureToolGetFirstAmplitude; external PM_DLL;
function VoMeasureToolGetSecondtAmplitude; external PM_DLL;

function VoSearchToolTemplateCreate; external PM_DLL;
function VoSearchToolTemplateSearch; external PM_DLL;

function VoSearchToolTemplateRotCreate; external PM_DLL;
function VoSearchToolTemplateRotSearch; external PM_DLL;

function VoSearchToolShapeCreate; external PM_DLL;
function VoSearchToolShapeSearch; external PM_DLL;
function VoSearchToolScaledShapeCreate; external PM_DLL;
function VoSearchToolScaledShapeSearch; external PM_DLL;
function VoSearchToolRelease; external PM_DLL;
function VoSearchToolResultCount; external PM_DLL;
function VoSearchToolResult; external PM_DLL;

function VoCreateTemplate; external PM_DLL;
function VoCreateRectTemplate; external PM_DLL;
function VoFunctionGetAngle; external PM_DLL;
function VoFunctionGetRotatePoint; external PM_DLL;

function VoArrayPosClear; external PM_DLL;
function VoArrayPosAdd; external PM_DLL;
function VoGetLine; external PM_DLL;
function VoGetLRLine; external PM_DLL;
function VoGetLineIntersection; external PM_DLL;

function VoRegionPolygonArrayClear; external PM_DLL;
function VoRegionPolygonArrayAdd; external PM_DLL;
function VoRegionPolygonCreate; external PM_DLL;

function VoGetAngle; external PM_DLL;
function VoConvertDegree; external PM_DLL;
function VoConvertRadian; external PM_DLL;
function VoGetRotatePoint; external PM_DLL;

function VoPaintRegion; external PM_DLL;
function VoGet3PointCircle; external PM_DLL;
function VoGetOriginPos2; external PM_DLL;
function VoRegionGetCircularity; external PM_DLL;
function VoGetFitCircle; external PM_DLL;
function VoGetFitEllipse; external PM_DLL;
function VoGetFitEllipseA; external PM_DLL;
function VoGetFindSymmetricCenter; external PM_DLL;

function VoFlip; external PM_DLL;
function VoBufferImageCreateExternToFlip; external PM_DLL;


function VoBufferImageCrossMarkPaint; external PM_DLL;
function VoBufferImageDCrossMarkPaint; external PM_DLL;
function VoBufferImageRectangleMarkPaint; external PM_DLL;
function VoBufferImageCircleMarkPaint; external PM_DLL;
function VoBufferImageEllipseMarkPaint; external PM_DLL;
function VoBufferImageEllipseAngleMarkPaint; external PM_DLL;
function VoBufferImageGiyeokMarkPaint; external PM_DLL;
function VoBufferImageReverseGiyeokMarkPaint; external PM_DLL;
function VoBufferImageNieunMarkPaint; external PM_DLL;
function VoBufferImageReverseNieunMarkPaint; external PM_DLL;

end.




