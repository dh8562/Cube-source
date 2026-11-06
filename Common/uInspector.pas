unit uInspector;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Math,
  SyncObjs,
  ExtCtrls,

  foTypes,
  foLists,
  foTimeCounter,
  foDataServer,
  foDataServerUtils,
  foWinUtils,
  foStringUtils,

  voCollection,
  voVision,
  voLiveVision,

  vocore,
  voInspection,

  uEquipmentUtils,
  uEquipmentConsts,
  uEquipment,
  uLogger,

  fLog
  ;

const
  MAX_CAMERA_COUNT = 2;
  MAX_VISION_COUNT = 2;

  MAX_INSP_NO   = 20;
  MAX_MODEL = 20;

  MAX_SEARCH_RESULRT = 100;

  MAX_RESULT_DATA_COUNT = 100;

  MAX_RESULT_DATA_LIMIT = 10;

  MAX_BUFFER_COUNT = 10;


type
  TInspectorMessageEvent = procedure (Sender : TObject; const Msg : string) of object;

  TMeasureDir = (mdLeftToRight,mdRightToLeft, mdTopToBottom, mdBottomToTop);
  TEdgeTransition = (etAuto, etBlackToWhite, etWhiteToBlack);
  TEdgeResultMethod = (ermAverage, ermMean, ermMin, ermMax);
  TFilterKind = (fkNone, fkSobel, fkMean);
  TDetectKind = (dkDetectNG, dkDetectOK);

	TInspAlgoritm = (
    iaBase,
    iaGSearch,      //1
    iaMeasure,
    iaCircle,
    iaBlob,
    iaDetect,
    iaSearchCircle,
    iaSearchRect,
    iaMeasCorner,

    iaMeasPos,        // 9
    iaMeasPosXToPosX, // 10
    iaMeasPosYToPosY, // 11
    iaMeasPosToPos,
    iaMeasLineToPos,
    iaMeasLineCrossPos
  );

  TSearchResult = packed record
    X, Y, Width, Height, Score, Angle, Scale : Double;
  end;

  TDoublePoint = packed record
  	X : Double;
    Y : Double;
  end;

  TMeasureData = packed record
    dpStartPos : TDoublePoint;
    dpEndPos : TDoublePoint;
    dpFoundPos : TDoublePoint;
    bFoundFirst : Boolean;
    bFound : Boolean;
    dFoundAmp : Double;
    dLength : Double;
  end;

  TAngleEdge = packed record
    dAngle : Integer;
    dLength : Double;
    dEdge : Double;
    dpPos : TDoublePoint;
  end;

  TDefect = packed record
    rectSize : TRect;

    dXCenter : Double;
    dYCenter : Double;
    dAngle : Double;
    dLength1 : Double;
    dLength2 : Double;
  end;

  TVisionInspector = record
    hLock : TCriticalSection;

    // 영상관련 Handle
    hBufferView : VOHANDLE; // View Handle

    hBufferSrc : VOHANDLE;  // View Source
    hBufferImageSrc : VOHANDLE;
    hInspectionSrc : VOHANDLE;

    hInspectionGrab : VOHANDLE;

    hBufferBuf : array [0..MAX_BUFFER_COUNT-1] of VOHANDLE;
    hBufferImageBuf : array [0..MAX_BUFFER_COUNT-1] of VOHANDLE;
    hInspectionBuf : array [0..MAX_BUFFER_COUNT-1] of VOHANDLE;



    dCamPosX : Double;
    dCamPosY : Double;

    // Result
    dInspectTimer : Double;
    dGrabTimer    : Double;

    dSearchX : Double;
    dSearchY : Double;
    dSearchT : Double;

    dSearchScore : Double;
    bSearchOk : Boolean;

    dSearchDX : Double;
    dSearchDY : Double;
    dSearchDT : Double;
    dSearchCX : Double;
    dSearchCY : Double;

    bResult : Boolean;
    nNGNo : Integer;

    nResultCount : Integer;
    SR : array [0..MAX_SEARCH_RESULRT] of TSearchResult;

    nCurrInspNo : Integer;
  end;

  TInspItem = record
    nInspNo : Integer;
  	bUse : Boolean;
    szName : String;
  	InspAlgoritm : TInspAlgoritm;

    bDispData : Boolean;

    nModelCount : Integer;
    AModelNo : array [0..MAX_MODEL-1] of Integer;

    nRefCamCount : Integer;
    ARefCamNo : array [0..MAX_MODEL-1] of Integer;

    nRefItemCount : Integer;
    ARefItemNo : array [0..MAX_MODEL-1] of Integer;

    dSpecMin : Double;
    dSpecMax : Double;
    dCorr : Double;
    dOffset : Double;
    nBinNo : Integer;

    dTargetX : Double;
    dTargetY : Double;

    // Result...
  	bResult : Boolean;
    dResultValue : Double;

    dResultX : Double;
    dResultY : Double;

    // for Line
    dResultA : Double;
    dResultB : Double;
    dResultC : Double;

    nContinueNGCount : Integer;
  end;

  TModelInfo = packed record
    ModelName : String;
    InspAlgoritm : TInspAlgoritm;
    AlgoritmIndex : Integer;
  end;


  TDataItem = record
    nIndexNo : Integer;
    bResult : Boolean;
    dValue : Double;
  end;

  TResultData = record
    szItemInform : String;
    dSpecMin : Double;
    dSpecMax : Double;

    bResult : Boolean;
    dValue : Double;
    dAvgValue : Double;

    nTotal : Integer;
    nGood : Integer;
    nNG : Integer;
    dYield : Double;

    nContinueNGCountA : Integer;
    nContinueNGCountB : Integer;

  	Data : array of TDataItem;
  	DataA : array of TDataItem;
  	DataB : array of TDataItem;
  end;


type
  TBaseAlgorithm = class(TvoCustomCollectionItem)
  private
    FUpdateCount : Integer;
    FModified: Boolean;

    FLock : TCriticalSection;
    FInspTime: TfoTimeCounter;
  	FRgnROI : VOHANDLE;
    FRgnTransferROI : VOHANDLE;

    FChNo: Integer;
    FBufferView: VOHANDLE;
    FBufferSrc: VOHANDLE;
    FBufferImageSrc: VOHANDLE;
    FInspectionSrc: VOHANDLE;

    FBufferFilter: VOHANDLE;
    FBufferImageFilter: VOHANDLE;
    FInspectionFilter: VOHANDLE;

    FInspAlgoritm: TInspAlgoritm;

    FRectROI : TRect;
    FItemROI: TvoOverlayItem;

    FOffsetX: Double;
    FOffsetY: Double;
    FOffsetT: Double;
    FOffsetCX: Double;
    FOffsetCY: Double;

    FResult: Boolean;
    FResultX: Double;
    FResultY: Double;
    FResultT: Double;
    FResultScore: Double;
    FCaption: String;

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure DrawText(ASender : TObject; ACanvas : TCanvas; APos : TPoint; szText : String; AColor : TColor; ASize : Integer);
    procedure DrawRect(ASender : TObject; ACanvas : TCanvas; ARect : TRect; AColor : TColor; APenWidth : Integer);
    procedure DrawCross(ASender : TObject; ACanvas : TCanvas; APoint : TPoint; AColor : TColor);
    procedure DrawPlus(ASender : TObject; ACanvas : TCanvas; ARect : TRect; AColor : TColor);
    procedure DrawLine(ASender : TObject; ACanvas : TCanvas; AStart, AEnd : TPoint; AColor : TColor);
    procedure DrawRectOffset(ASender : TObject; ACanvas : TCanvas; ARect : TRect; DX : Double; DY : Double; AColor : TColor);

    function ScaledOffsetRect(const Rect : TRect; const Scale : Double; const Offset : TPoint) : TRect;
    function ScaledOffsetIP(const Point : TPoint; const Scale : Double; const Offset : TPoint) : TPoint;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure LoadFromFile(AFileName : String); virtual;
    procedure SaveToFile(AFileName : String); virtual;
    function Build : Boolean; virtual;
    function Inspect : Boolean; virtual;
    procedure Draw(ASender: TObject; ACanvas: TCanvas); virtual;

    property Modified : Boolean read FModified write FModified;

  published
    property ChNo : Integer read FChNo write FChNo;
    property BufferView: VOHANDLE read FBufferView write FBufferView;
    property BufferSrc: VOHANDLE read FBufferSrc write FBufferSrc;
    property BufferImageSrc: VOHANDLE read FBufferImageSrc write FBufferImageSrc;
    property InspectionSrc: VOHANDLE read FInspectionSrc write FInspectionSrc;
    property BufferFilter: VOHANDLE read FBufferFilter write FBufferFilter;
    property BufferImageFilter: VOHANDLE read FBufferImageFilter write FBufferImageFilter;
    property InspectionFilter: VOHANDLE read FInspectionFilter write FInspectionFilter;

    property Caption : String read FCaption write FCaption;

    property RectROI : TRect read FRectROI write FRectROI;
    property ItemROI : TvoOverlayItem read FItemROI write FItemROI;

    property OffsetX : Double read FOffsetX write FOffsetX;
    property OffsetY : Double read FOffsetY write FOffsetY;
    property OffsetT : Double read FOffsetT write FOffsetT;
    property OffsetCX : Double read FOffsetCX write FOffsetCX;
    property OffsetCY : Double read FOffsetCY write FOffsetCY;

    property Result : Boolean read FResult write FResult;
    property ResultX : Double read FResultX write FResultX;
    property ResultY : Double read FResultY write FResultY;
    property ResultT : Double read FResultT write FResultT;
    property ResultScore : Double read FResultScore write FResultScore;

  end;
  TBaseAlgorithmClass = class of TBaseAlgorithm;

  TBaseAlgorithms = class(TCollection)
  private
    Owner: TPersistent;
    function GetItem(Index: Integer): TBaseAlgorithm;
    procedure SetItem(Index: Integer; Value: TBaseAlgorithm);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TBaseAlgorithmClass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;

    function Add: TBaseAlgorithm; overload;

    property Items[Index: Integer]: TBaseAlgorithm read GetItem write SetItem; default;
  end;

  TMeasureAlgorithm = class(TBaseAlgorithm)
  private
    FMeasCount : Integer;
    FMeasData : array of TMeasureData;

    FDetailMeasCount : Integer;
    FDetailMeasData : array of TMeasureData;

    // For Measure Line Line = Ax + By + C
    FMeasLineA : Double;
    FMeasLineB : Double;
    FMeasLineC : Double;

    FMeasureDir: TMeasureDir;
    FMeasurePos: Integer;
    FMeasureScore: Double;
    FEdgeTransition: TEdgeTransition;
    FEdgeThickness: Integer;
    FEdgeThreshold: Double;
    FEdgeSigma: Double;
    FEdgeInterpolation: Integer;
    FEdgeResultMethod: TEdgeResultMethod;
    FResultAcceptLength: Integer;
    FDetailUseEdge: Boolean;
    FDetailMeasureDir: TMeasureDir;
    FDetailMeasOffset: Integer;
    FDetailMeasTorr: Integer;
    FDetailMeasureScore: Double;
    FDetailEdgeTransition: TEdgeTransition;
    FDetailEdgeThickness: Integer;
    FDetailEdgeThreshold: Double;

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(AFileName : String); override;
    procedure SaveToFile(AFileName : String); override;
    function Build : Boolean; override;
    function Inspect : Boolean; override;
    procedure Draw(ASender: TObject; ACanvas: TCanvas); override;

    property MeasLineA : Double read FMeasLineA write FMeasLineA;
    property MeasLineB : Double read FMeasLineB write FMeasLineB;
    property MeasLineC : Double read FMeasLineC write FMeasLineC;

  published
    property MeasureDir : TMeasureDir read FMeasureDir write FMeasureDir;
    property MeasurePos : Integer read FMeasurePos write FMeasurePos;
    property MeasureScore : Double read FMeasureScore write FMeasureScore;
    property EdgeTransition : TEdgeTransition read FEdgeTransition write FEdgeTransition;
    property EdgeThickness : Integer read FEdgeThickness write FEdgeThickness;
    property EdgeThreshold : Double read FEdgeThreshold write FEdgeThreshold;
    property EdgeSigma : Double read FEdgeSigma write FEdgeSigma;
    property EdgeInterpolation : Integer read FEdgeInterpolation write FEdgeInterpolation;
    property EdgeResultMethod : TEdgeResultMethod read FEdgeResultMethod write FEdgeResultMethod;
    property ResultAcceptLength : Integer read FResultAcceptLength write FResultAcceptLength;

    property DetailUseEdge : Boolean read FDetailUseEdge write FDetailUseEdge;
    property DetailMeasureDir : TMeasureDir read FDetailMeasureDir write FDetailMeasureDir;
    property DetailMeasOffset : Integer read FDetailMeasOffset write FDetailMeasOffset;
    property DetailMeasTorr : Integer read FDetailMeasTorr write FDetailMeasTorr;
    property DetailMeasureScore : Double read FDetailMeasureScore write FDetailMeasureScore;
    property DetailEdgeTransition : TEdgeTransition read FDetailEdgeTransition write FDetailEdgeTransition;
    property DetailEdgeThickness : Integer read FDetailEdgeThickness write FDetailEdgeThickness;
    property DetailEdgeThreshold : Double read FDetailEdgeThreshold write FDetailEdgeThreshold;

  end;
  TMeasureAlgorithmClass = class of TMeasureAlgorithm;

  TMeasureAlgorithms = class(TCollection)
  private
    Owner: TPersistent;
    function GetItem(Index: Integer): TMeasureAlgorithm;
    procedure SetItem(Index: Integer; Value: TMeasureAlgorithm);

  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TMeasureAlgorithmClass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;

    function Add: TMeasureAlgorithm; overload;

    property Items[Index: Integer]: TMeasureAlgorithm read GetItem write SetItem; default;
  end;

  TBlobAlgorithm = class(TBaseAlgorithm)
  private
    FRgnResult : VOHANDLE;

    FArea : Integer;
    FSizeX : Integer;
    FSizeY : Integer;

    FDefectCount : Integer;
    ADefect : array of TDefect;

    FAreaMin: Integer;
    FFilterKind: TFilterKind;
    FScratchLength: Double;
    FSizeXMax: Integer;
    FSizeYMax: Integer;
    FROIIgnoreSize: Integer;
    FROISearchMethod: Integer;
    FROIThresholdMax: Integer;
    FIgnoreSize: Integer;
    FSizeXMin: Integer;
    FThresholdMax: Integer;
    FSizeYMin: Integer;
    FResultShow: Boolean;
    FAreaMax: Integer;
    FROIThresholdMin: Integer;
    FDetectKind: TDetectKind;
    FThresholdMin: Integer;

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(AFileName : String); override;
    procedure SaveToFile(AFileName : String); override;
    function Build : Boolean; override;
    function Inspect : Boolean; override;
    procedure Draw(ASender: TObject; ACanvas: TCanvas); override;

    property Area : Integer read FArea write FArea;
    property SizeX : Integer read FSizeX write FSizeX;
    property SizeY : Integer read FSizeY write FSizeY;

  published
    property ROIThresholdMin : Integer read FROIThresholdMin write FROIThresholdMin;
    property ROIThresholdMax : Integer read FROIThresholdMax write FROIThresholdMax;
    property ROIIgnoreSize : Integer read FROIIgnoreSize write FROIIgnoreSize;

    property ThresholdMin : Integer read FThresholdMin write FThresholdMin;
    property ThresholdMax : Integer read FThresholdMax write FThresholdMax;
    property FilterKind : TFilterKind read FFilterKind write FFilterKind;
    property IgnoreSize : Integer read FIgnoreSize write FIgnoreSize;
    property AreaMin : Integer read FAreaMin write FAreaMin;
    property AreaMax : Integer read FAreaMax write FAreaMax;
    property SizeXMin : Integer read FSizeXMin write FSizeXMin;
    property SizeXMax : Integer read FSizeXMax write FSizeXMax;
    property SizeYMin : Integer read FSizeYMin write FSizeYMin;
    property SizeYMax : Integer read FSizeYMax write FSizeYMax;
    property ScratchLength : Double read FScratchLength write FScratchLength;
    property ROISearchMethod : Integer read FROISearchMethod write FROISearchMethod;
    property DetectKind : TDetectKind read FDetectKind write FDetectKind;
    property ResultShow : Boolean read FResultShow write FResultShow;

  end;
  TBlobAlgorithmClass = class of TBlobAlgorithm;

  TBlobAlgorithms = class(TCollection)
  private
    Owner: TPersistent;

    function GetItem(Index: Integer): TBlobAlgorithm;
    procedure SetItem(Index: Integer; Value: TBlobAlgorithm);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TBlobAlgorithmClass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;

    function Add: TBlobAlgorithm; overload;

    property Items[Index: Integer]: TBlobAlgorithm read GetItem write SetItem; default;
  end;

  TGSearchAlgorithm = class(TBaseAlgorithm)
  private
    FRectModelROI : TRect;
    FItemModelROI: TvoOverlayItem;
  	FRgnModelROI : VOHANDLE;

    FVector : VOHANDLE;
    FSearchTemplate : VOHANDLE;

    FResultCount : Integer;
    FSearchResult : array of TSearchResult;


    FVisionNumLevel: Integer;
    FVisionContrast: Integer;
    FVisionModelSearchScore: Double;
    FVisionOptimization: Integer;
    FVisionScaleMin: Double;
    FVisionAngleStep: Double;
    FVisionSearchSubPixel: Integer;
    FVisionMinContrast: Integer;
    FVisionMetric: Integer;
    FVisionModelCount: Integer;
    FVisionAngleExtent: Double;
    FVisionSearchScore: Double;
    FVisionScaleStep: Double;
    FVisionSearchMaxOverlap: Double;
    FVisionScaleMax: Double;
    FVisionSearchGreediness: Double;
    FVisionAngleStart: Double;
    FResultOffsetX: Double;
    FResultOffsetY: Double;

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(AFileName : String); override;
    procedure SaveToFile(AFileName : String); override;
    function Build : Boolean; override;
    function Inspect : Boolean; override;
    procedure Draw(ASender: TObject; ACanvas: TCanvas); override;

    property ItemModelROI : TvoOverlayItem read FItemModelROI write FItemModelROI;

  published
    property VisionNumLevel : Integer read FVisionNumLevel write FVisionNumLevel;
    property VisionAngleStart : Double read FVisionAngleStart write FVisionAngleStart;
    property VisionAngleExtent : Double read FVisionAngleExtent write FVisionAngleExtent;
    property VisionAngleStep : Double read FVisionAngleStep write FVisionAngleStep;
    property VisionScaleMin : Double read FVisionScaleMin write FVisionScaleMin;
    property VisionScaleMax : Double read FVisionScaleMax write FVisionScaleMax;
    property VisionScaleStep : Double read FVisionScaleStep write FVisionScaleStep;
    property VisionOptimization : Integer read FVisionOptimization write FVisionOptimization;
    property VisionMetric : Integer read FVisionMetric write FVisionMetric;
    property VisionContrast : Integer read FVisionContrast write FVisionContrast;
    property VisionMinContrast : Integer read FVisionMinContrast write FVisionMinContrast;

    property VisionModelSearchScore : Double read FVisionModelSearchScore write FVisionModelSearchScore;
    property VisionSearchMaxOverlap : Double read FVisionSearchMaxOverlap write FVisionSearchMaxOverlap;
    property VisionSearchSubPixel : Integer read FVisionSearchSubPixel write FVisionSearchSubPixel;
    property VisionSearchGreediness : Double read FVisionSearchGreediness write FVisionSearchGreediness;
    property VisionSearchScore : Double read FVisionSearchScore write FVisionSearchScore;
    property VisionModelCount : Integer read FVisionModelCount write FVisionModelCount;

    property ResultOffsetX : Double read FResultOffsetX write FResultOffsetX;
    property ResultOffsetY : Double read FResultOffsetY write FResultOffsetY;

  end;
  TGSearchAlgorithmClass = class of TGSearchAlgorithm;

  TGSearchAlgorithms = class(TCollection)
  private
    Owner: TPersistent;

    function GetItem(Index: Integer): TGSearchAlgorithm;
    procedure SetItem(Index: Integer; Value: TGSearchAlgorithm);

  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TGSearchAlgorithmClass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;

    function Add: TGSearchAlgorithm; overload;

    property Items[Index: Integer]: TGSearchAlgorithm read GetItem write SetItem; default;
  end;

  TMeasCornerAlgorithm = class(TBaseAlgorithm)
  private
    FForgroundRgn : VOHANDLE;
    FOLineX : Double;
    FOLineY : Double;
    FFirstMeasRectV : TRect;
    FFirstMeasRectH : TRect;
    FMeasRectV : TRect;
    FMeasRectH : TRect;

    FVPos : array of TDoublePoint;
    FVFoundPos : array of Boolean;
    FHPos : array of TDoublePoint;
    FHFoundPos : array of Boolean;

    FMeasCount : Integer;
    FMeasData : array of TMeasureData;

    FDetailMeasCount : Integer;
    FDetailMeasData : array of TMeasureData;
    FEdgeFirstThreshold: Double;
    FMeasCountH: Integer;
    FVStartSkip: Integer;
    FEdgeScanLength: Integer;
    FAreaMin: Integer;
    FSearchBlobThresholdMin: Integer;
    FVMaxCount: Integer;
    FHStartSkip: Integer;
    FSizeX: Integer;
    FEdgeSecondThreshold: Double;
    FSizeY: Integer;
    FSizeXMax: Integer;
    FSizeYMax: Integer;
    FBlobSearchMethod: TMeasureDir;
    FReverse: Integer;
    FSearchBlobUse: Boolean;
    FHMaxCount: Integer;
    FVEndSkip: Integer;
    FEdgeFirstTransition: TEdgeTransition;
    FBlobShow: Boolean;
    FHEndSkip: Integer;
    FEdgeScanningStep: Integer;
    FSizeXMin: Integer;
    FSizeYMin: Integer;
    FBlobSearchOffsetX: Integer;
    FBlobSearchOffsetY: Integer;
    FEdgeMeasureScore: Double;
    FRectOffsetX: Integer;
    FEdgeSecondTransition: TEdgeTransition;
    FRectOffsetY: Integer;
    FArea: Integer;
    FAreaMax: Integer;
    FSearchBlobThresholdMax: Integer;
    FMeasCountV: Integer;
    FResultAcceptLength: Double;
    FEdgeBoundSkipOffset: Integer;
    FEdgeThickness: Integer;
    FMeasureDir: TMeasureDir;

  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromFile(AFileName : String); override;
    procedure SaveToFile(AFileName : String); override;
    function Build : Boolean; override;
    function Inspect : Boolean; override;
    procedure Draw(ASender: TObject; ACanvas: TCanvas); override;

  published
    property SearchBlobUse : Boolean read FSearchBlobUse write FSearchBlobUse;
    property BlobShow : Boolean read FBlobShow write FBlobShow;
    property BlobSearchMethod : TMeasureDir read FBlobSearchMethod write FBlobSearchMethod;
    property BlobSearchOffsetX : Integer read FBlobSearchOffsetX write FBlobSearchOffsetX;
    property BlobSearchOffsetY : Integer read FBlobSearchOffsetY write FBlobSearchOffsetY;
    property SearchBlobThresholdMin : Integer read FSearchBlobThresholdMin write FSearchBlobThresholdMin;
    property SearchBlobThresholdMax : Integer read FSearchBlobThresholdMax write FSearchBlobThresholdMax;

    property AreaMin : Integer read FAreaMin write FAreaMin;
    property AreaMax : Integer read FAreaMax write FAreaMax;
    property SizeXMin : Integer read FSizeXMin write FSizeXMin;
    property SizeXMax : Integer read FSizeXMax write FSizeXMax;
    property SizeYMin : Integer read FSizeYMin write FSizeYMin;
    property SizeYMax : Integer read FSizeYMax write FSizeYMax;

    property Area : Integer read FArea write FArea;
    property SizeX : Integer read FSizeX write FSizeX;
    property SizeY : Integer read FSizeY write FSizeY;

    property MeasureDir : TMeasureDir read FMeasureDir write FMeasureDir;

    property EdgeFirstTransition : TEdgeTransition read FEdgeFirstTransition write FEdgeFirstTransition;
    property EdgeFirstThreshold : Double read FEdgeFirstThreshold write FEdgeFirstThreshold;
    property EdgeScanLength : Integer read FEdgeScanLength write FEdgeScanLength;
    property EdgeThickness : Integer read FEdgeThickness write FEdgeThickness;
    property EdgeScanningStep : Integer read FEdgeScanningStep write FEdgeScanningStep;
    property EdgeBoundSkipOffset : Integer read FEdgeBoundSkipOffset write FEdgeBoundSkipOffset;
    property EdgeMeasureScore : Double read FEdgeMeasureScore write FEdgeMeasureScore;
    property Reverse : Integer read FReverse write FReverse;

    property EdgeSecondTransition : TEdgeTransition read FEdgeSecondTransition write FEdgeSecondTransition;
    property EdgeSecondThreshold : Double read FEdgeSecondThreshold write FEdgeSecondThreshold;
    property ResultAcceptLength : Double read FResultAcceptLength write FResultAcceptLength;

    property VStartSkip : Integer read FVStartSkip write FVStartSkip;
    property VEndSkip : Integer read FVEndSkip write FVEndSkip;
    property VMaxCount : Integer read FVMaxCount write FVMaxCount;
    property HStartSkip : Integer read FHStartSkip write FHStartSkip;
    property HEndSkip : Integer read FHEndSkip write FHEndSkip;
    property HMaxCount : Integer read FHMaxCount write FHMaxCount;
    property RectOffsetX : Integer read FRectOffsetX write FRectOffsetX;
    property RectOffsetY : Integer read FRectOffsetY write FRectOffsetY;

    property MeasCountV : Integer read FMeasCountV write FMeasCountV;
    property MeasCountH : Integer read FMeasCountH write FMeasCountH;


  end;
  TMeasCornerAlgorithmClass = class of TMeasCornerAlgorithm;

  TMeasCornerAlgorithms = class(TCollection)
  private
    Owner: TPersistent;

    function GetItem(Index: Integer): TMeasCornerAlgorithm;
    procedure SetItem(Index: Integer; Value: TMeasCornerAlgorithm);

  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TMeasCornerAlgorithmClass);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;

    function Add: TMeasCornerAlgorithm; overload;

    property Items[Index: Integer]: TMeasCornerAlgorithm read GetItem write SetItem; default;
  end;

  TInspector = class(TPersistent)
  private
    FMeasureAlgorithms: TMeasureAlgorithms;
    FBlobAlgorithms: TBlobAlgorithms;
    FGSearchAlgorithms: TGSearchAlgorithms;
    FMeasCornerAlgorithms: TMeasCornerAlgorithms;

    FImageHeight: Integer;
    FImageWidth: Integer;

    FBufferView: VOHANDLE;
    FBufferSrc: VOHANDLE;
    FBufferImageSrc: VOHANDLE;
    FInspectionSrc: VOHANDLE;
    FBufferFilter: VOHANDLE;
    FBufferImageFilter: VOHANDLE;
    FInspectionFilter: VOHANDLE;

    procedure SetMeasureAlgorithms(const Value: TMeasureAlgorithms);
    procedure SetBlobAlgorithms(const Value: TBlobAlgorithms);
    procedure SetGSearchAlgorithms(const Value: TGSearchAlgorithms);
    procedure SetMeasCornerAlgorithms(const Value: TMeasCornerAlgorithms);

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFormFile(AFileName : String);
    procedure SaveToFile(AFileName : String);

    procedure Clear;
    procedure Add(InspAlgoritm : TInspAlgoritm);

    procedure OpenImage(szFileName: AnsiString);
    procedure InitializeVision(AImageWidth, AImageHeight: Integer);
    procedure FinalizeVision;

    function Build(AChNo, AModelNo : Integer) : Boolean; overload;
    function Build(AChNo : Integer) : Boolean; overload;

    function Inspect(AChNo, AModelNo : Integer) : Boolean; overload;
    function Inspect(AChNo : Integer) : Boolean; overload;

    procedure Draw(ASender: TObject; ACanvas: TCanvas; AChNo : Integer);

    procedure LoadInspItemsFromJob(AJobServer : TfoDataServer);
    procedure SaveInspItemsToJob(AJobServer : TfoDataServer);

    function InspItems(nChNo: Integer; nInspNo: Integer): Boolean;


    // For Build
    property ImageWidth : Integer read FImageWidth;
    property ImageHeight : Integer read FImageHeight;

    property BufferView: VOHANDLE read FBufferView write FBufferView;

    property BufferSrc: VOHANDLE read FBufferSrc write FBufferSrc;
    property BufferImageSrc: VOHANDLE read FBufferImageSrc write FBufferImageSrc;
    property InspectionSrc: VOHANDLE read FInspectionSrc write FInspectionSrc;

    property BufferFilter: VOHANDLE read FBufferFilter write FBufferFilter;
    property BufferImageFilter: VOHANDLE read FBufferImageFilter write FBufferImageFilter;
    property InspectionFilter: VOHANDLE read FInspectionFilter write FInspectionFilter;

  published
    property MeasureAlgorithms: TMeasureAlgorithms read FMeasureAlgorithms write SetMeasureAlgorithms;
    property BlobAlgorithms: TBlobAlgorithms read FBlobAlgorithms write SetBlobAlgorithms;
    property GSearchAlgorithms: TGSearchAlgorithms read FGSearchAlgorithms write SetGSearchAlgorithms;
    property MeasCornerAlgorithms: TMeasCornerAlgorithms read FMeasCornerAlgorithms write SetMeasCornerAlgorithms;

  end;

function Inspector: TInspector;

procedure GetAngleOffset(X, Y, CX, CY, DA : Double; var DX, DY : Double);
// 직선 AX + By + C = 0, 과 점(X,Y)의 수직하는 교점의 거리를 구한다.
function GetLineToPos(A, B, C, X, Y: Double): Double;

procedure GetOffsetAngle(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double; var DX: Double; var DY: Double; var DA: Double);
function GetLineLength(X1, Y1, X2, Y2 : Double) : Double;


var
  gInspector : array [0..MAX_VISION_COUNT] of  TVisionInspector;

  gInspCounts : array [0..MAX_VISION_COUNT-1] of Integer;
  gInspItems : array[0..MAX_VISION_COUNT-1, 0..MAX_INSP_NO] of TInspItem;

  gViewLevel : Integer;

  gModelCounts : array[0..MAX_VISION_COUNT-1] of Integer;
  gModelInfos : array[0..MAX_VISION_COUNT-1, 0..MAX_MODEL-1] of TModelInfo;

  gResultDataCount : Integer;
  gResultData : array[0..MAX_RESULT_DATA_COUNT-1] of TResultData;

  gBufferNo : Integer;


implementation

var
  _Instance: TInspector;

function Inspector: TInspector;
begin
  if not Assigned(_Instance) then _Instance := TInspector.Create;
  Result := _Instance;
end;


procedure GetAngleOffset(X, Y, CX, CY, DA: Double; var DX, DY: Double);
var
  cos_th, sin_th : Double;
begin
	X := X - CX;
	Y := Y - CY;
  cos_th := cos(DA * (PI/180));
  sin_th := sin(DA * (PI/180));

  DX := ((cos_th*(X)) - (sin_th*(Y))) + CX;
  DY := ((sin_th*(X)) + (cos_th*(Y))) + CY;
end;

function GetLineToPos(A, B, C, X, Y: Double): Double;
begin
  // 점(x1, y1), 직선(ax + by + c = 0) 사이의 거리 d
  // d = abs(a*x1 + b*y1 + c ) / SQRT( (a*a) + (b*b) );
  Result := 0;
  if sqrt((A * A) + (B * B)) <> 0 then
  begin
    Result := abs((A * X) + (B * Y) + C) / sqrt((A * A) + (B * B));
  end;
end;

function GetLineLength(X1, Y1, X2, Y2: Double): Double;
begin
  Result := Sqrt(Power((X2-X1), 2) + Power((Y2-Y1), 2));
end;

procedure GetOffsetAngle(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double;
  var DX, DY, DA: Double);
var
  dx_model, dy_model, dx_target, dy_target: Double;
  ang_model, ang_target: Double;
  RX1, RY1: Double;
  RX2, RY2: Double;
  OX, OY: Double;
begin
  dx_model := (X2 - X1);
  dy_model := (Y2 - Y1);
  dx_target := (X4 - X3);
  dy_target := (Y4 - Y3);

  if dx_model = 0 then
    ang_model := 0
  else
    ang_model := ArcTan2(dy_model, dx_model);

  if dx_target = 0 then
    ang_target := 0
  else
    ang_target := ArcTan2(dy_target, dx_target);

  DA := ((ang_model - ang_target) * (180 / PI));

  // 두좌표의 중심으로 적용 되도록,,,,
  RX1 := (X2 + X1) / 2;
  RY1 := (Y2 + Y1) / 2;
  RX2 := (X4 + X3) / 2;
  RY2 := (Y4 + Y3) / 2;

  DX := RX1 - RX2;
  DY := RY1 - RY2;
end;



{ TBaseAlgorithm }

constructor TBaseAlgorithm.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FUpdateCount := 0;

  FLock := TCriticalSection.Create;
  FInspTime := TfoTimeCounter.Create;
  FRgnROI := 0;
  FRgnTransferROI := 0;

  FChNo:= 0;
  FBufferView:= 0;
  FBufferSrc:= 0;
  FBufferImageSrc:= 0;
  FInspectionSrc:= 0;
  FBufferFilter:= 0;
  FBufferImageFilter:= 0;
  FInspectionFilter:= 0;

  FCaption := '';

  FInspAlgoritm := iaBase;
  FRectROI := Bounds(0,0,0,0);
  FItemROI:= nil;

  FOffsetX:= 0;
  FOffsetY:= 0;
  FOffsetT:= 0;
  FOffsetCX:= 0;
  FOffsetCY:= 0;

  FResult:= False;
  FResultX:= 0;
  FResultY:= 0;
  FResultT:= 0;
  FResultScore:= 0;
end;

destructor TBaseAlgorithm.Destroy;
begin
  FLock.Free;
  FInspTime.Free;
  if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
  if FRgnTransferROI <> 0 then VoRegionRelease(FRgnTransferROI);

  inherited;
end;

procedure TBaseAlgorithm.Assign(Source: TPersistent);
begin
  if Source is TBaseAlgorithm then
  begin
    FItemROI:= TBaseAlgorithm(Source).ItemROI;

    FOffsetX:= TBaseAlgorithm(Source).OffsetX;
    FOffsetY:= TBaseAlgorithm(Source).OffsetY;
    FOffsetT:= TBaseAlgorithm(Source).OffsetT;
    FOffsetCX:= TBaseAlgorithm(Source).OffsetCX;
    FOffsetCY:= TBaseAlgorithm(Source).OffsetCY;

    FResult:= TBaseAlgorithm(Source).Result;
    FResultX:= TBaseAlgorithm(Source).ResultX;
    FResultY:= TBaseAlgorithm(Source).ResultY;
    FResultT:= TBaseAlgorithm(Source).ResultT;
    FResultScore:= TBaseAlgorithm(Source).ResultScore;
  end
  else
    inherited Assign(Source);
end;

procedure TBaseAlgorithm.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TBaseAlgorithm.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then Changed(False);
end;

function TBaseAlgorithm.ScaledOffsetIP(const Point: TPoint; const Scale: Double; const Offset: TPoint): TPoint;
var
  ScaleOffset : Integer;
begin
  ScaleOffset := Round(Scale / 2);
  Result.X := Round(Point.X * Scale);
  Result.Y := Round(Point.Y * Scale);
  Result.X := Result.X + Offset.X + ScaleOffset;
  Result.Y := Result.Y + Offset.Y + ScaleOffset;
end;

function TBaseAlgorithm.ScaledOffsetRect(const Rect: TRect; const Scale: Double; const Offset: TPoint): TRect;
var
  ScaleOffset : Integer;
begin
  Result := Rect;
  Result.Left := Round(Result.Left * Scale);
  Result.Top := Round(Result.Top * Scale);
  Result.Right := Round(Result.Right * Scale);
  Result.Bottom := Round(Result.Bottom * Scale);
  ScaleOffset := Round(Scale / 2);
  OffsetRect(Result, Offset.X + ScaleOffset, Offset.Y + ScaleOffset);
end;

procedure TBaseAlgorithm.DrawCross(ASender: TObject; ACanvas: TCanvas; APoint: TPoint; AColor: TColor);
var
  Pos : TPoint;
begin
	with TvoLiveVision(ASender) do
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := AColor;
    Pos := ScaledOffsetIP(APoint, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));

    ACanvas.MoveTo(Pos.X - 10, Pos.Y);
    ACanvas.LineTo(Pos.X + 10, Pos.Y);
    ACanvas.MoveTo(Pos.X, Pos.Y - 10);
    ACanvas.LineTo(Pos.X, Pos.Y + 10);
	end;
end;

procedure TBaseAlgorithm.DrawLine(ASender: TObject; ACanvas: TCanvas; AStart, AEnd: TPoint; AColor: TColor);
var
  posStart, posEnd : TPoint;
begin
	with TvoLiveVision(ASender) do
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := AColor;
  	posStart := ScaledOffsetIP(AStart, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));
  	posEnd := ScaledOffsetIP(AEnd, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));

    ACanvas.MoveTo(posStart.X, posStart.Y);
    ACanvas.LineTo(posEnd.X, posEnd.Y);
	end;
end;

procedure TBaseAlgorithm.DrawPlus(ASender: TObject; ACanvas: TCanvas; ARect: TRect; AColor: TColor);
var
  Rect : TRect;
  Pos : TPoint;
begin
	with TvoLiveVision(ASender) do
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := AColor;
    Rect := ScaledOffsetRect(ARect, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));
    Pos := Point(Rect.Left + Trunc(Rect.Width/2), Rect.Top + Trunc(Rect.Height/2));

    ACanvas.MoveTo(Rect.Left, Rect.Top + Trunc(Rect.Height/2));
    ACanvas.LineTo(Rect.Right, Rect.Top + Trunc(Rect.Height/2));

    ACanvas.MoveTo(Rect.Left + Trunc(Rect.Width/2), Rect.Top);
    ACanvas.LineTo(Rect.Left + Trunc(Rect.Width/2), Rect.Bottom);
	end;
end;

procedure TBaseAlgorithm.DrawRect(ASender: TObject; ACanvas: TCanvas; ARect: TRect; AColor: TColor; APenWidth: Integer);
var
  Rect : TRect;
begin
	with TvoLiveVision(ASender) do
  begin
    ACanvas.Pen.Width := APenWidth;
    ACanvas.Pen.Color := AColor;
    Rect := ScaledOffsetRect(ARect, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));

    ACanvas.MoveTo(Rect.Left, Rect.Top);
    ACanvas.LineTo(Rect.Right, Rect.Top);
    ACanvas.LineTo(Rect.Right, Rect.Bottom);
    ACanvas.LineTo(Rect.Left, Rect.Bottom);
    ACanvas.LineTo(Rect.Left, Rect.Top);
	end;
end;

procedure TBaseAlgorithm.DrawRectOffset(ASender: TObject; ACanvas: TCanvas; ARect: TRect; DX, DY: Double; AColor: TColor);
var
  Rect : TRect;
begin
	with TvoLiveVision(ASender) do
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := AColor;
    Rect.Left := Trunc(ARect.Left + DX);
    Rect.Top := Trunc(ARect.Top + DY);
    Rect.Right := Trunc(ARect.Right + DX);
    Rect.Bottom := Trunc(ARect.Bottom + DY);

    Rect := ScaledOffsetRect(Rect, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));

    ACanvas.MoveTo(Rect.Left, Rect.Top);
    ACanvas.LineTo(Rect.Right, Rect.Top);
    ACanvas.LineTo(Rect.Right, Rect.Bottom);
    ACanvas.LineTo(Rect.Left, Rect.Bottom);
    ACanvas.LineTo(Rect.Left, Rect.Top);
	end;
end;

procedure TBaseAlgorithm.DrawText(ASender: TObject; ACanvas: TCanvas; APos: TPoint; szText: String; AColor: TColor; ASize: Integer);
var
	Pos : TPoint;
begin
	with TvoLiveVision(ASender) do
  begin
  	Pos := ScaledOffsetIP(APos, ZoomFactor, Point(-TopLeft.X, -TopLeft.Y));
    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := ASize;
    ACanvas.Font.Color := AColor;
    ACanvas.Brush.Color := AColor;
    SetBkMode(ACanvas.Handle, TRANSPARENT);
    ACanvas.TextOut(Pos.X, Pos.Y, szText);
	end;
end;

function TBaseAlgorithm.Build: Boolean;
begin
  Result := True;
end;

function TBaseAlgorithm.Inspect: Boolean;
begin
  Result := True;
end;

procedure TBaseAlgorithm.LoadFromFile(AFileName: String);
begin
  foObjectFromXmlFile(Self, AFileName);
end;

procedure TBaseAlgorithm.SaveToFile(AFileName: String);
begin
  foObjectToXmlFile(Self, AFileName);
end;

procedure TBaseAlgorithm.Draw(ASender: TObject; ACanvas: TCanvas);
begin
;
end;

{ TBaseAlgorithms }
constructor TBaseAlgorithms.Create(AOwner: TPersistent; ItemClass: TBaseAlgorithmClass);
begin
  Owner := AOwner;
  inherited Create(ItemClass);
end;

destructor TBaseAlgorithms.Destroy;
begin

  inherited;
end;

function TBaseAlgorithms.Add: TBaseAlgorithm;
begin
  Result := TBaseAlgorithm(inherited Add);
  Result.Caption := 'Base';
end;

function TBaseAlgorithms.GetItem(Index: Integer): TBaseAlgorithm;
begin
  Result := TBaseAlgorithm(inherited Items[Index]);
end;

function TBaseAlgorithms.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TBaseAlgorithms.SetItem(Index: Integer; Value: TBaseAlgorithm);
begin
  Items[Index].Assign(Value);
end;

procedure TBaseAlgorithms.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TMeasureAlgorithm }
constructor TMeasureAlgorithm.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FInspAlgoritm := iaMeasure;

  FMeasureDir := mdLeftToRight;
  FMeasurePos := 0;
  FMeasureScore := 0.7;
  FEdgeTransition := etAuto;
  FEdgeThickness := 10;
  FEdgeThreshold := 10;
  FEdgeSigma := 1;
  FEdgeInterpolation := 1;
  FEdgeResultMethod := ermAverage;
  FResultAcceptLength := 1;
  FDetailUseEdge := False;
  FDetailMeasureDir := mdLeftToRight;
  FDetailMeasOffset:= 0;
  FDetailMeasTorr := 10;
  FDetailMeasureScore:= 0.5;
  FDetailEdgeTransition:= etAuto;
  FDetailEdgeThickness:= 10;
  FDetailEdgeThreshold:= 10;

  FMeasCount := 1;
  SetLength(FMeasData, 1);

  FDetailMeasCount := 1;
  SetLength(FDetailMeasData, 1);

  // For Measure Line Line = Ax + By + C
  FMeasLineA := 0;
  FMeasLineB := 0;
  FMeasLineC := 0;

end;

destructor TMeasureAlgorithm.Destroy;
begin

  inherited;
end;

procedure TMeasureAlgorithm.Assign(Source: TPersistent);
begin
  if Source is TMeasureAlgorithm then
  begin
    FMeasureDir := TMeasureAlgorithm(Source).MeasureDir;
    FMeasurePos := TMeasureAlgorithm(Source).MeasurePos;
    FMeasureScore := TMeasureAlgorithm(Source).MeasureScore;
    FEdgeTransition := TMeasureAlgorithm(Source).EdgeTransition;
    FEdgeThickness := TMeasureAlgorithm(Source).EdgeThickness;
    FEdgeThreshold := TMeasureAlgorithm(Source).EdgeThreshold;
    FEdgeSigma := TMeasureAlgorithm(Source).EdgeSigma;
    FEdgeInterpolation := TMeasureAlgorithm(Source).EdgeInterpolation;
    FEdgeResultMethod := TMeasureAlgorithm(Source).EdgeResultMethod;
    FResultAcceptLength := TMeasureAlgorithm(Source).ResultAcceptLength;
    FDetailUseEdge := TMeasureAlgorithm(Source).DetailUseEdge;
    FDetailMeasureDir := TMeasureAlgorithm(Source).DetailMeasureDir;
    FDetailMeasOffset := TMeasureAlgorithm(Source).DetailMeasOffset;
    FDetailMeasTorr := TMeasureAlgorithm(Source).DetailMeasTorr;
    FDetailMeasureScore := TMeasureAlgorithm(Source).DetailMeasureScore;
    FDetailEdgeTransition := TMeasureAlgorithm(Source).DetailEdgeTransition;
    FDetailEdgeThickness := TMeasureAlgorithm(Source).DetailEdgeThickness;
    FDetailEdgeThreshold := TMeasureAlgorithm(Source).DetailEdgeThreshold;
  end
  else
    inherited Assign(Source);
end;

function TMeasureAlgorithm.Build: Boolean;
begin
  Result := False;
  If not Assigned(FItemROI) then exit;

  FRectROI := FItemROI.NormalizedBoundsRect;

  if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
  FRgnROI := VoRegionRectangleCreate(FRectROI.Left, FRectROI.Top, FRectROI.Width, FRectROI.Height);

  Result := True;
end;

function TMeasureAlgorithm.Inspect: Boolean;
var
  W, H: Integer;
  hImgData: VOHANDLE;

  n: Integer;
  nThickness: Double;
  nFirstCount, nSecondCount: Integer;
  dResX, dResY: Double;
  nCount: Integer;

  nSumCount: Integer;
  dSumResX, dSumResY: Double;

  ADataListX, ADataListY: TfoDoubleList;
  ADataList2X, ADataList2Y: TfoDoubleList;
begin
  Result := False;

  FResult := False;
  FResultX := 0;
  FResultY := 0;

  if FBufferImageSrc = 0 then exit;

  FLock.Enter;
  FInspTime.Start;

  VoBufferImageGetRawImageData(FBufferImageSrc, W, H, @hImgData);

  ADataListX := TfoDoubleList.Create;
  ADataListY := TfoDoubleList.Create;

  case FMeasureDir of
    mdLeftToRight : nThickness := abs(FRectROI.Top - FRectROI.Bottom);
    mdRightToLeft: nThickness := abs(FRectROI.Top - FRectROI.Bottom);
    mdTopToBottom: nThickness := abs(FRectROI.Left - FRectROI.Right);
    mdBottomToTop: nThickness := abs(FRectROI.Left - FRectROI.Right);
  end;

  FMeasCount := 0;
  if FEdgeThickness > 0 then FMeasCount := Trunc(nThickness / FEdgeThickness);
  if FMeasCount < 1 then FMeasCount := 1;
  SetLength(FMeasData, FMeasCount);


  for n := 0 to FMeasCount - 1 do
  begin
    case FMeasureDir of
      mdLeftToRight:
        begin
          FMeasData[n].dpStartPos.X := FRectROI.Left;
          FMeasData[n].dpStartPos.Y := FRectROI.Top + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpEndPos.X := FRectROI.Right;
          FMeasData[n].dpEndPos.Y := FRectROI.Top + (n * FEdgeThickness) + (FEdgeThickness / 2);
        end;
      mdRightToLeft:
        begin
          FMeasData[n].dpStartPos.X := FRectROI.Right;
          FMeasData[n].dpStartPos.Y := FRectROI.Top + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpEndPos.X := FRectROI.Left;
          FMeasData[n].dpEndPos.Y := FRectROI.Top + (n * FEdgeThickness) + (FEdgeThickness / 2);
        end;
      mdTopToBottom:
        begin
          FMeasData[n].dpStartPos.X := FRectROI.Left + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpStartPos.Y := FRectROI.Top;
          FMeasData[n].dpEndPos.X := FRectROI.Left + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpEndPos.Y := FRectROI.Bottom;
        end;
      mdBottomToTop:
        begin
          FMeasData[n].dpStartPos.X := FRectROI.Left + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpStartPos.Y := FRectROI.Bottom;
          FMeasData[n].dpEndPos.X := FRectROI.Left + (n * FEdgeThickness) + (FEdgeThickness / 2);
          FMeasData[n].dpEndPos.Y := FRectROI.Top;
        end;
    end;

    FMeasData[n].dpStartPos.X := FMeasData[n].dpStartPos.X + FOffsetX;
    FMeasData[n].dpStartPos.Y := FMeasData[n].dpStartPos.Y + FOffsetY;
    FMeasData[n].dpEndPos.X := FMeasData[n].dpEndPos.X + FOffsetX;
    FMeasData[n].dpEndPos.Y := FMeasData[n].dpEndPos.Y + FOffsetY;

    GetAngleOffset(FMeasData[n].dpStartPos.X, FMeasData[n].dpStartPos.Y, FOffsetCX, FOffsetCY, FOffsetT,
      FMeasData[n].dpStartPos.X, FMeasData[n].dpStartPos.Y);

    GetAngleOffset(FMeasData[n].dpEndPos.X, FMeasData[n].dpEndPos.Y, FOffsetCX, FOffsetCY,
      FOffsetT, FMeasData[n].dpEndPos.X, FMeasData[n].dpEndPos.Y);

    VoMeasureToolLineCreate(FMeasData[n].dpStartPos.X, FMeasData[n].dpStartPos.Y,
                            FMeasData[n].dpEndPos.X, FMeasData[n].dpEndPos.Y,
                            FEdgeThickness, FEdgeInterpolation, W, H);

    VoMeasureToolMeasurePos(FBufferImageSrc, FEdgeSigma, FEdgeThreshold, Ord(FEdgeTransition));
    VoMeasureToolGetEdgeCount(nFirstCount, nSecondCount);

    if nFirstCount > FMeasurePos then
    begin
      VoMeasureToolGetFirstPos(FMeasurePos, dResX, dResY);
      VoMeasureToolGetFirstAmplitude(FMeasurePos, FMeasData[n].dFoundAmp);
      FMeasData[n].bFound := True;
      FMeasData[n].dpFoundPos.X := dResX;
      FMeasData[n].dpFoundPos.Y := dResY;
    end
    else
    begin
      FMeasData[n].bFound := False;
      FMeasData[n].dpFoundPos.X := 0;
      FMeasData[n].dpFoundPos.Y := 0;
    end;
  end;

  // Data Calc
  nCount := 0;
  VoArrayPosClear();
  ADataListX.Clear;
  ADataListY.Clear;
  for n := 0 to FMeasCount - 1 do
  begin
    if FMeasData[n].bFound then
    begin
      dResX := FMeasData[n].dpFoundPos.X;
      dResY := FMeasData[n].dpFoundPos.Y;
      VoArrayPosAdd(dResX, dResY);
      ADataListX.Add(dResX);
      ADataListY.Add(dResY);
      Inc(nCount);
    end;
  end;

  if nCount > 0 then
  begin
    if nCount > 3 then
    begin
      if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
      begin
        VoGetLRLine(1, FMeasLineA, FMeasLineB, FMeasLineC);
      end
      else
      begin
        VoGetLRLine(0, FMeasLineA, FMeasLineB, FMeasLineC);
      end;

      //
      VoArrayPosClear();
      ADataListX.Clear;
      ADataListY.Clear;
      for n := 0 to FMeasCount - 1 do
      begin
        if FMeasData[n].bFound then
        begin
          dResX := FMeasData[n].dpFoundPos.X;
          dResY := FMeasData[n].dpFoundPos.Y;

          if GetLineToPos(FMeasLineA, FMeasLineB, FMeasLineC, dResX, dResY) < FResultAcceptLength then
          begin
            ADataListX.Add(dResX);
            ADataListY.Add(dResY);
            VoArrayPosAdd(dResX, dResY);
          end
          else
          begin
            FMeasData[n].bFound := False;
          end;
        end;
      end;
    end;

    FResultScore := ADataListX.Count / FMeasCount;
    if FResultScore >= FMeasureScore then
    begin
      FResult := True;
      if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
      begin
        VoGetLRLine(1, FMeasLineA, FMeasLineB, FMeasLineC);
      end
      else
      begin
        VoGetLRLine(0, FMeasLineA, FMeasLineB, FMeasLineC);
      end;

      case FEdgeResultMethod of
        ermAverage:
          begin
            FResultX := ADataListX.AvgValue;
            FResultY := ADataListY.AvgValue;
          end;
        ermMean:
          begin
            ADataListX.Sorted := True;
            ADataListY.Sorted := True;
            FResultX := ADataListX[ADataListX.Count div 2];
            FResultY := ADataListY[ADataListY.Count div 2];
          end;
        ermMin:
          begin
            ADataListX.Sorted := True;
            ADataListY.Sorted := True;
            if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
            begin
              FResultX := ADataListX[0];
              FResultY := ADataListY[ADataListY.Count div 2];
            end
            else
            begin
              FResultX := ADataListX[ADataListX.Count div 2];
              FResultY := ADataListY[0];
            end;
          end;
        ermMax:
          begin
            ADataListX.Sorted := True;
            ADataListY.Sorted := True;
            if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
            begin
              FResultX := ADataListX[ADataListX.Count - 1];
              FResultY := ADataListY[ADataListY.Count div 2];
            end
            else
            begin
              FResultX := ADataListX[ADataListX.Count div 2];
              FResultY := ADataListY[ADataListY.Count - 1];
            end;
          end;
      end;

    end
    else
    begin
      FResult := False;
      FResultX := FRectROI.Left;
      FResultY := FRectROI.Top;
    end;
  end
  else
  begin
    FResult := False;
    FResultX := FRectROI.Left;
    FResultY := FRectROI.Top;
  end;

  if FDetailUseEdge and FResult then
  begin
    if FDetailEdgeThickness > 0 then
    begin
      FDetailMeasCount := Trunc(nThickness / FDetailEdgeThickness);
    end
    else
    begin
      FDetailMeasCount := 1;
    end;
    if FDetailMeasCount < 1 then FDetailMeasCount := 1;

    for n := 0 to FDetailMeasCount - 1 do
    begin
      case FDetailMeasureDir of
        mdLeftToRight :
          begin
            FDetailMeasData[n].dpStartPos.X := FResultX - FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpStartPos.Y := FRectROI.Top + (n * FDetailEdgeThickness);
            FDetailMeasData[n].dpEndPos.X := FResultX + FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpEndPos.Y := FRectROI.Top + (n * FDetailEdgeThickness);
          end;
        mdRightToLeft:
          begin
            FDetailMeasData[n].dpStartPos.X := FResultX + FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpStartPos.Y := FRectROI.Top + (n * FDetailEdgeThickness);
            FDetailMeasData[n].dpEndPos.X := FResultX - FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpEndPos.Y := FRectROI.Top + (n * FDetailEdgeThickness);
          end;
        mdTopToBottom:
          begin
            FDetailMeasData[n].dpStartPos.X := FRectROI.Left + (n * FDetailEdgeThickness);
            FDetailMeasData[n].dpStartPos.Y := FResultY - FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpEndPos.X := FRectROI.Left + (n * FDetailEdgeThickness);
           FDetailMeasData[n].dpEndPos.Y := FResultY + FDetailMeasTorr + FDetailMeasOffset;
          end;
        mdBottomToTop:
          begin
            FDetailMeasData[n].dpStartPos.X := FRectROI.Left + (n * FDetailEdgeThickness);
            FDetailMeasData[n].dpStartPos.Y := FResultY + FDetailMeasTorr + FDetailMeasOffset;
            FDetailMeasData[n].dpEndPos.X := FRectROI.Left + (n * FDetailEdgeThickness);
            FDetailMeasData[n].dpEndPos.Y := FResultY - FDetailMeasTorr + FDetailMeasOffset;
          end;
      end;

      VoMeasureToolLineCreate(FDetailMeasData[n]
        .dpStartPos.X, FDetailMeasData[n].dpStartPos.Y,
        FDetailMeasData[n].dpEndPos.X,
        FDetailMeasData[n].dpEndPos.Y,
        FEdgeThickness,
        FEdgeInterpolation, W, H);

      VoMeasureToolMeasurePos(FBufferImageSrc, FEdgeSigma, FDetailEdgeThreshold, Ord(FDetailEdgeTransition));
      VoMeasureToolGetEdgeCount(nFirstCount, nSecondCount);

      if nFirstCount > 0 then
      begin
        VoMeasureToolGetFirstPos(0, dResX, dResY);
        VoMeasureToolGetFirstAmplitude(0, FDetailMeasData[n].dFoundAmp);
        FDetailMeasData[n].bFound := True;
        FDetailMeasData[n].dpFoundPos.X := dResX;
        FDetailMeasData[n].dpFoundPos.Y := dResY;
      end
      else
      begin
        FDetailMeasData[n].bFound := False;
        FDetailMeasData[n].dpFoundPos.X := 0;
        FDetailMeasData[n].dpFoundPos.Y := 0;
      end;
    end;

    // Data Calc
    nCount := 0;
    VoArrayPosClear();
    ADataListX.Clear;
    ADataListY.Clear;
    for n := 0 to FDetailMeasCount - 1 do
    begin
      if FDetailMeasData[n].bFound then
      begin
        dResX := FDetailMeasData[n].dpFoundPos.X;
        dResY := FDetailMeasData[n].dpFoundPos.Y;
        VoArrayPosAdd(dResX, dResY);
        Inc(nCount);
      end;
    end;

    if nCount > 0 then
    begin
      if nCount > 3 then
      begin
        if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
        begin
          VoGetLRLine(1, FMeasLineA, FMeasLineB, FMeasLineC);
        end
        else
        begin
          VoGetLRLine(0, FMeasLineA, FMeasLineB, FMeasLineC);
        end;

        for n := 0 to FDetailMeasCount - 1 do
        begin
          if FDetailMeasData[n].bFound then
          begin
            dResX := FDetailMeasData[n].dpFoundPos.X;
            dResY := FDetailMeasData[n].dpFoundPos.Y;

            VoArrayPosClear();
            ADataListX.Clear;
            ADataListY.Clear;
            if GetLineToPos(FMeasLineA, FMeasLineB, FMeasLineC, dResX, dResY) < FResultAcceptLength then
            begin
              ADataListX.Add(dResX);
              ADataListY.Add(dResY);
              VoArrayPosAdd(dResX, dResY);
            end
            else
            begin
              FMeasData[n].bFound := False;
            end;
          end;
        end;
      end;

      FResultScore := ADataListX.Count / FDetailMeasCount;
      if FResultScore >= FDetailMeasureScore then
      begin
        FResult := True;

        if (FDetailMeasureDir = mdLeftToRight) or (FDetailMeasureDir = mdRightToLeft)  then
        begin
          VoGetLRLine(1, FMeasLineA, FMeasLineB, FMeasLineC);
        end
        else
        begin
          VoGetLRLine(0, FMeasLineA, FMeasLineB, FMeasLineC);
        end;

        case FEdgeResultMethod of
          ermAverage:
            begin
              FResultX := ADataListX.AvgValue;
              FResultY := ADataListY.AvgValue;
            end;
          ermMean:
            begin
              ADataListX.Sorted := True;
              ADataListY.Sorted := True;
              FResultX := ADataListX[ADataListX.Count div 2];
              FResultY := ADataListY[ADataListY.Count div 2];
            end;
          ermMin:
            begin
              ADataListX.Sorted := True;
              ADataListY.Sorted := True;
              if (FDetailMeasureDir = mdLeftToRight) or (FDetailMeasureDir = mdRightToLeft)  then
              begin
                FResultX := ADataListX[0];
                FResultY := ADataListY[ADataListY.Count div 2];
              end
              else
              begin
                FResultX := ADataListX[ADataListX.Count div 2];
                FResultY := ADataListY[0];
              end;
            end;
          ermMax:
            begin
              ADataListX.Sorted := True;
              ADataListY.Sorted := True;
              if (FDetailMeasureDir = mdLeftToRight) or (FDetailMeasureDir = mdRightToLeft)  then
              begin
                FResultX := ADataListX[ADataListX.Count - 1];
                FResultY := ADataListY[ADataListY.Count div 2];
              end
              else
              begin
                FResultX := ADataListX[ADataListX.Count div 2];
                FResultY := ADataListY[ADataListY.Count - 1];
              end;
            end;
        end;
      end
      else
      begin
        FResult := False;
        FResultX := FRectROI.Left;
        FResultY := FRectROI.Top;
      end;
    end;

  end;

  if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft)  then
  begin
    FResultY := (FRectROI.Top + FRectROI.Bottom) / 2;
  end
  else
  begin
    FResultX := (FRectROI.Left + FRectROI.Right) / 2;
  end;


  ADataListX.Free;
  ADataListY.Free;

  FInspTime.Stop;
  FLock.Leave;

end;

procedure TMeasureAlgorithm.Draw(ASender: TObject; ACanvas: TCanvas);
var
  i : Integer;
begin
  inherited;

  if FBufferView = 0 then exit;

  VoBufferViewSetSolidBrush(FBufferView, 255, 255, 0);
  VoBufferViewSetStockBrush(FBufferView, 5);
  VoBufferViewSetPen(FBufferView, 0, 1, 255, 255, 0);
  VoBufferViewDrawRegion(ACanvas.Handle, FBufferView, FRgnROI);
  DrawText(ASender, ACanvas, RectROI.TopLeft, Format('%s', [Caption]), clLime, 8);

  VoBufferViewSetPen(FBufferView, 0, 1, 255, 0, 0);
  VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FResultX, FResultY, 100, 100);

  if gViewLevel = 1 then
  begin
    for i := 0 to Pred(FMeasCount) do
    begin
      VoBufferViewSetPen(FBufferView, 2, 1, 128, 128, 128);
      VoBufferViewDrawLine(ACanvas.Handle, FBufferView,
        FMeasData[i].dpStartPos.X, FMeasData[i].dpStartPos.Y, FMeasData[i].dpEndPos.X, FMeasData[i].dpEndPos.Y);


        if FMeasData[i].bFound then VoBufferViewSetPen(FBufferView, 0, 1, 255, 255, 0)
        else VoBufferViewSetPen(FBufferView, 0, 1, 255, 0, 0);
        VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FMeasData[i].dpFoundPos.X, FMeasData[i].dpFoundPos.Y, 10, 10);
    end;

    DrawRectOffset(ASender, ACanvas, FRectROI, FOffsetX, FOffsetY, clYellow);
    DrawText(ASender, ACanvas, Point(Trunc(FResultX), Trunc(FResultY)), Format('[%s]', [FCaption]), clRed, 12);
  end;

  if gViewLevel = 2 then
  begin
    for i := 0 to FMeasCount - 1 do
    begin
      VoBufferViewSetPen(FBufferView, 2, 1, 255, 255, 255);
      VoBufferViewDrawLine(ACanvas.Handle, FBufferView, FMeasData[i].dpStartPos.X, FMeasData[i].dpStartPos.Y, FMeasData[i].dpEndPos.X, FMeasData[i].dpEndPos.Y);

      VoBufferViewSetPen(FBufferView, 2, 1, 255, 255, 0);
      VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FMeasData[i].dpStartPos.X, FMeasData[i].dpStartPos.Y, 4, 4);
      VoBufferViewSetPen(FBufferView, 2, 1, 0, 255, 255);
      VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FMeasData[i].dpEndPos.X, FMeasData[i].dpEndPos.Y, 4, 4);

      if FMeasData[i].bFound then
      begin
        VoBufferViewSetPen(FBufferView, 2, 1, 255, 0, 0);
        VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FMeasData[i].dpFoundPos.X, FMeasData[i].dpFoundPos.Y, 4, 4);

        DrawText(ASender, ACanvas, Point(Trunc(FMeasData[i].dpFoundPos.X), Trunc(FMeasData[i].dpFoundPos.Y)), Format('%.1f', [FMeasData[i].dFoundAmp]), clLime, 12);
      end;
    end;

    if FDetailUseEdge then
    begin
      for i := 0 to FDetailMeasCount - 1 do
      begin
        VoBufferViewSetPen(FBufferView, 2, 1, 255, 255, 255);
        VoBufferViewDrawLine(ACanvas.Handle, FBufferView, FMeasData[i].dpStartPos.X, FMeasData[i].dpStartPos.Y, FMeasData[i].dpEndPos.X, FMeasData[i].dpEndPos.Y);

        VoBufferViewSetPen(FBufferView, 2, 1, 255, 255, 0);
        VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FDetailMeasData[i].dpStartPos.X, FDetailMeasData[i].dpStartPos.Y, 2, 2);
        VoBufferViewSetPen(FBufferView, 2, 1, 0, 255, 255);
        VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FDetailMeasData[i].dpEndPos.X, FDetailMeasData[i].dpEndPos.Y, 2, 2);

        if FDetailMeasData[i].bFound then
        begin
          VoBufferViewSetPen(FBufferView, 2, 1, 255, 0, 0);
          VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FDetailMeasData[i].dpFoundPos.X, FDetailMeasData[i] .dpFoundPos.Y, 4, 4);

          DrawText(ASender, ACanvas, Point(Trunc(FDetailMeasData[i].dpFoundPos.X), Trunc(FDetailMeasData[i].dpFoundPos.Y)), Format('%.1f', [FDetailMeasData[i].dFoundAmp]), clLime, 12);
        end;
      end;
    end;

    VoBufferViewSetPen(FBufferView, 2, 2, 0, 0, 255);
    VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FResultX, FResultY, 100, 100);
  end;


end;

procedure TMeasureAlgorithm.LoadFromFile(AFileName: String);
begin
  inherited;

end;

procedure TMeasureAlgorithm.SaveToFile(AFileName: String);
begin
  inherited;

end;

{ TMeasureAlgorithms }
constructor TMeasureAlgorithms.Create(AOwner: TPersistent; ItemClass: TMeasureAlgorithmClass);
begin
  Owner := AOwner;
  inherited Create(ItemClass);
end;

destructor TMeasureAlgorithms.Destroy;
begin

  inherited;
end;

function TMeasureAlgorithms.Add: TMeasureAlgorithm;
begin
  Result := TMeasureAlgorithm(inherited Add);
  Result.Caption := 'Measure';
end;

function TMeasureAlgorithms.GetItem(Index: Integer): TMeasureAlgorithm;
begin
  Result := TMeasureAlgorithm(inherited Items[Index]);
end;

function TMeasureAlgorithms.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TMeasureAlgorithms.SetItem(Index: Integer; Value: TMeasureAlgorithm);
begin
  Items[Index].Assign(Value);
end;

procedure TMeasureAlgorithms.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TBlobAlgorithm }
constructor TBlobAlgorithm.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FInspAlgoritm := iaMeasure;

  FRgnResult := 0;

  FAreaMin:= 0;
  FFilterKind:= fkNone;
  FScratchLength:= 0;
  FSizeXMax:= 0;
  FSizeYMax:= 0;
  FROIIgnoreSize:= 0;
  FROISearchMethod:= 0;
  FROIThresholdMax:= 0;
  FIgnoreSize:= 0;
  FSizeXMin:= 0;
  FThresholdMax:= 0;
  FSizeYMin:= 0;
  FResultShow:= False;
  FAreaMax:= 0;
  FROIThresholdMin:= 0;
  FDetectKind:= dkDetectNG;
  FThresholdMin:= 0;
end;

destructor TBlobAlgorithm.Destroy;
begin
  if FRgnResult <> 0 then VoRegionRelease(FRgnResult);

  inherited;
end;

procedure TBlobAlgorithm.Draw(ASender: TObject; ACanvas: TCanvas);
  var
    i : Integer;
    dPos : TPoint;
    dLength : Double;
begin
  inherited;

  if FBufferView = 0 then exit;

  VoBufferViewSetSolidBrush(FBufferView, 0, 0, 255);
  if gViewLevel = 1 then
  begin
    VoBufferViewSetStockBrush(FBufferView, 5);
    VoBufferViewSetPen(FBufferView, 0, 1, 0, 0, 255);
    VoBufferViewDrawRegion(ACanvas.Handle, FBufferView, FRgnResult);

    VoBufferViewSetStockBrush(FBufferView, 5);
    VoBufferViewSetPen(FBufferView, 0, 1, 255, 0, 0);
    VoBufferViewDrawRegion(ACanvas.Handle, FBufferView, FRgnTransferROI);
  end;

  if gViewLevel = 1 then
  begin
    if FResult then
    begin
      DrawText(ASender, ACanvas,
        Point(Trunc(FResultX), Trunc(FResultY)),
        Format('[%s] OK X=%.3f, Y=%.3f, W=%d, H=%d',[FCaption, FResultX, FResultY, FSizeX, FSizeY]), clLime, 8);
    end
    else
    begin
      DrawText(ASender, ACanvas,
        Point(Trunc(FResultX), Trunc(FResultY)),
        Format('[%s] NG X=%.3f, Y=%.3f, W=%d, H=%d',[FCaption, FResultX, FResultY, FSizeX, FSizeY]), clRed, 8);
    end;
  end;

end;

procedure TBlobAlgorithm.Assign(Source: TPersistent);
begin
  if Source is TBlobAlgorithm then
  begin
    FAreaMin:= TBlobAlgorithm(Source).AreaMin;
    FFilterKind:= TBlobAlgorithm(Source).FilterKind;
    FScratchLength:= TBlobAlgorithm(Source).ScratchLength;
    FSizeXMax:= TBlobAlgorithm(Source).SizeXMax;
    FSizeYMax:= TBlobAlgorithm(Source).SizeYMax;
    FROIIgnoreSize:= TBlobAlgorithm(Source).ROIIgnoreSize;
    FROISearchMethod:= TBlobAlgorithm(Source).ROISearchMethod;
    FROIThresholdMax:= TBlobAlgorithm(Source).ROIThresholdMax;
    FIgnoreSize:= TBlobAlgorithm(Source).IgnoreSize;
    FSizeXMin:= TBlobAlgorithm(Source).SizeXMin;
    FThresholdMax:= TBlobAlgorithm(Source).ThresholdMax;
    FSizeYMin:= TBlobAlgorithm(Source).SizeYMin;
    FResultShow:= TBlobAlgorithm(Source).ResultShow;
    FAreaMax:= TBlobAlgorithm(Source).AreaMax;
    FROIThresholdMin:= TBlobAlgorithm(Source).ROIThresholdMin;
    FDetectKind:= TBlobAlgorithm(Source).DetectKind;
    FThresholdMin:= TBlobAlgorithm(Source).ThresholdMin;
  end
  else
    inherited Assign(Source);
end;

function TBlobAlgorithm.Build: Boolean;
var
  i : Integer;
  hBlobRgn, hBlobListRgn, hCircleRingRgn: VOHANDLE;
  nSize : Integer;
begin
  Result := False;
  If not Assigned(FItemROI) then exit;

  FOffsetX := 0;
  FOffsetY := 0;
  FOffsetT := 0;

  FRectROI := FItemROI.NormalizedBoundsRect;

  if FItemROI.ItemType = oitPolygon then
  begin
    VoRegionPolygonArrayClear();
    for i := 0 to Pred(FItemROI.PointCount) do
    begin
      VoRegionPolygonArrayAdd(FItemROI.Points[i].X, FItemROI.Points[i].Y);
    end;

    if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
    FRgnROI := VoRegionPolygonCreate();
  end
  else
  begin
    if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
    FRgnROI := VoRegionRectangleCreate(FRectROI.Left, FRectROI.Top, FRectROI.Width, FRectROI.Height);
  end;

  hBlobRgn := VoRegionCreate();
  hBlobListRgn := VoRegionCreate();

  VoImageProcessingThreshold(FBufferImageSrc, FRgnROI, FROIThresholdMin, FROIThresholdMax, hBlobRgn);

  nSize := FROIIgnoreSize;
  if nSize > 0 then
  begin
    hCircleRingRgn := VoRegionCircleCreate(nSize/2, nSize/2, nSize);
    VoRegionErosion(hBlobRgn, hCircleRingRgn, hBlobRgn);
    VoRegionRelease(hCircleRingRgn);
  end;

  VoRegionIntersection(FRgnROI, hBlobRgn, FRgnROI);

  VoRegionRelease(hBlobRgn);
  VoRegionRelease(hBlobListRgn);

  Result := True;
end;

function TBlobAlgorithm.Inspect: Boolean;
var
  hBlobRgn, hBlobListRgn, hBlobSelectRgn, hBlobFillRgn, hCircleRingRgn,
    FhRgn: VOHANDLE;

  i: Integer;
  nX, nY, nWidth, nHeight: Integer;
  nLeft, nTop, nRight, nBottom: Integer;
  nCount, nArea: Integer;
  DX, DY: Double;
  nSize: Integer;
  szValue: AnsiString;
begin
  Result := False;

  FResult := False;
  FResultX := 0;
  FResultY := 0;
  FArea := 0;
  FSizeX := 0;
  FSizeY := 0;

  if FBufferImageSrc = 0 then exit;

  FLock.Enter;
  FInspTime.Start;

  hBlobRgn := VoRegionCreate();
  hBlobListRgn := VoRegionCreate();
  hBlobSelectRgn := VoRegionCreate();
  hBlobFillRgn := VoRegionCreate();
  FhRgn := VoRegionCreate();

  if FRgnResult <> 0 then VoRegionRelease(FRgnResult);
  FRgnResult := VoRegionCreate();

  if FRgnTransferROI <> 0 then VoRegionRelease(FRgnTransferROI);
  FRgnTransferROI := VoRegionCreate();

  // Offset ROI
  VoRegionTransfer(FRgnROI, FOffsetX, FOffsetY, FOffsetT, FOffsetCX, FOffsetCY, FRgnTransferROI);

  case FFilterKind of
    fkSobel:
      begin
        VoImageSobelFilter(FBufferImageSrc, FRgnTransferROI, 1, FBufferImageFilter);
        VoImageProcessingThreshold(FBufferImageFilter, FRgnTransferROI, FThresholdMin, FThresholdMax, hBlobRgn);
      end;
    fkMean:
      begin
        VoImageMeanFilter(FBufferImageSrc, FRgnTransferROI, 3, 3, FBufferImageFilter);
        VoImageProcessingThreshold(FBufferImageFilter, FRgnTransferROI, FThresholdMin, FThresholdMax, hBlobRgn);
      end;
  else
    begin
      VoImageProcessingThreshold(FBufferImageSrc, FRgnTransferROI, FThresholdMin, FThresholdMax, hBlobRgn);
    end;
  end;

  nSize := FIgnoreSize;

  if nSize > 0 then
  begin
    hCircleRingRgn := VoRegionCircleCreate(nSize / 2, nSize / 2, nSize);
    VoRegionErosion(hBlobRgn, hCircleRingRgn, hBlobRgn);
    VoRegionRelease(hCircleRingRgn);
  end;

  VoRegionSegmentConnected(hBlobRgn, hBlobListRgn);

  szValue := Format('Area[%d-%d],Width[%d-%d],Height[%d-%d]', [FAreaMin, FAreaMax, FSizeXMin, FSizeXMax, FSizeYMin, FSizeYMax]);

  VoRegionSelectRegion(hBlobListRgn, PAnsiChar(szValue), 2, hBlobSelectRgn);
  VoRegionGetRegionCount(hBlobSelectRgn, nCount);

  VoRegionUnionRegionList(hBlobSelectRgn, FRgnResult);

  FDefectCount := nCount;
  SetLength(ADefect, nCount);

  if nCount > 0 then
  begin
    VoRegionGetAreaCenter(FRgnResult, nArea, DX, DY);
    VoRegionGetRectangle(FRgnResult, nLeft, nTop, nRight, nBottom);

    nWidth := nRight - nLeft;
    nHeight := nBottom - nTop;
    FResultX := DX;
    FResultY := DY;
    FArea := nArea;
    FSizeX := nWidth;
    FSizeY := nHeight;

    for i := 0 to Pred(nCount) do
    begin
      VoRegionGetRegion(hBlobSelectRgn, i, FhRgn);
      VoRegionGetRectangle(FhRgn, nLeft, nTop, nRight, nBottom);
      ADefect[i].RectSize := Rect(nLeft, nTop, nRight, nBottom);

      VoRegionGetAngleRectangle(FhRgn, ADefect[i].dXCenter, ADefect[i].dYCenter, ADefect[i].DAngle, ADefect[i].dLength1, ADefect[i].dLength2);
    end;
  end;

  if FDetectKind = dkDetectNG then FResult := (nCount = 0)
  else FResult := (nCount > 0);

  Result := Fresult;

  VoRegionRelease(hBlobRgn);
  VoRegionRelease(hBlobListRgn);
  VoRegionRelease(hBlobSelectRgn);
  VoRegionRelease(hBlobFillRgn);
  VoRegionRelease(FhRgn);

  FInspTime.Stop;
  FLock.Leave;
end;

procedure TBlobAlgorithm.LoadFromFile(AFileName: String);
begin
  inherited;

end;

procedure TBlobAlgorithm.SaveToFile(AFileName: String);
begin
  inherited;

end;

{ TBlobAlgorithms }
constructor TBlobAlgorithms.Create(AOwner: TPersistent; ItemClass: TBlobAlgorithmClass);
begin
  Owner := AOwner;
  inherited Create(ItemClass);
end;

destructor TBlobAlgorithms.Destroy;
begin

  inherited;
end;

function TBlobAlgorithms.Add: TBlobAlgorithm;
begin
  Result := TBlobAlgorithm(inherited Add);
  Result.Caption := 'Blob';
end;

function TBlobAlgorithms.GetItem(Index: Integer): TBlobAlgorithm;
begin
  Result := TBlobAlgorithm(inherited Items[Index]);
end;

function TBlobAlgorithms.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TBlobAlgorithms.SetItem(Index: Integer; Value: TBlobAlgorithm);
begin
  Items[Index].Assign(Value);
end;

procedure TBlobAlgorithms.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TGSearchAlgorithm }
constructor TGSearchAlgorithm.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FInspAlgoritm := iaGSearch;

  FRectModelROI := Bounds(0,0,0,0);
  FItemModelROI:= nil;
  FRgnModelROI := 0;

  FVisionNumLevel:= 3;
  FVisionModelSearchScore:= 0.3;

  FVisionMinContrast:= 5;
  FVisionContrast:= 30;

  FVisionScaleMin:= 1;
  FVisionScaleMax:= 1;
  FVisionScaleStep:= 0;

  FVisionAngleStep:= 0;
  FVisionAngleExtent:= 0;
  FVisionAngleStart:= 0;

  FVisionMetric:= 1;
  FVisionOptimization:= 1;
  FVisionSearchMaxOverlap:= 0.7;
  FVisionSearchGreediness:= 1;
  FVisionSearchSubPixel:= 1;

  FVisionSearchScore:= 0.7;
  FVisionModelCount:= 1;

  FResultOffsetX := 0;
  FResultOffsetY := 0;

end;

destructor TGSearchAlgorithm.Destroy;
begin
  if FRgnModelROI <> 0 then VoRegionRelease(FRgnModelROI);

  if FVector <> 0 then VoVectorRelease(FVector);
  if FSearchTemplate <> 0 then VoSearchToolRelease(FSearchTemplate);

  inherited;
end;

procedure TGSearchAlgorithm.Assign(Source: TPersistent);
begin
  if Source is TGSearchAlgorithm then
  begin
    FVisionNumLevel := TGSearchAlgorithm(Source).VisionNumLevel;
    FVisionModelSearchScore:= TGSearchAlgorithm(Source).VisionModelSearchScore;
    FVisionMinContrast:= TGSearchAlgorithm(Source).VisionMinContrast;
    FVisionContrast:= TGSearchAlgorithm(Source).VisionContrast;
    FVisionScaleMin:= TGSearchAlgorithm(Source).VisionScaleMin;
    FVisionScaleMax:= TGSearchAlgorithm(Source).VisionScaleMax;
    FVisionScaleStep:= TGSearchAlgorithm(Source).VisionScaleStep;
    FVisionAngleStep:= TGSearchAlgorithm(Source).VisionAngleStep;
    FVisionAngleExtent:= TGSearchAlgorithm(Source).VisionAngleExtent;
    FVisionAngleStart:= TGSearchAlgorithm(Source).VisionAngleStart;
    FResultOffsetX:= TGSearchAlgorithm(Source).ResultOffsetX;
    FResultOffsetY:= TGSearchAlgorithm(Source).ResultOffsetY;
    FVisionMetric:= TGSearchAlgorithm(Source).VisionMetric;
    FVisionOptimization:= TGSearchAlgorithm(Source).VisionOptimization;
    FVisionSearchMaxOverlap:= TGSearchAlgorithm(Source).VisionSearchMaxOverlap;
    FVisionSearchGreediness:= TGSearchAlgorithm(Source).VisionSearchGreediness;
    FVisionSearchSubPixel:= TGSearchAlgorithm(Source).VisionSearchSubPixel;
    FVisionSearchScore:= TGSearchAlgorithm(Source).VisionSearchScore;
    FVisionModelCount:= TGSearchAlgorithm(Source).VisionModelCount;
  end
  else
    inherited Assign(Source);
end;

function TGSearchAlgorithm.Build: Boolean;
var
  i : Integer;
  bBuildOk : Boolean;
begin
  Result := False;
  If not Assigned(FItemROI) then exit;

  FOffsetX := 0;
  FOffsetY := 0;
  FOffsetT := 0;

  FRectROI := FItemROI.NormalizedBoundsRect;
  if FItemROI.ItemType = oitPolygon then
  begin
    VoRegionPolygonArrayClear();
    for i := 0 to Pred(FItemROI.PointCount) do
    begin
      VoRegionPolygonArrayAdd(FItemROI.Points[i].X, FItemROI.Points[i].Y);
    end;

    if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
    FRgnROI := VoRegionPolygonCreate();
  end
  else
  begin
    if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
    FRgnROI := VoRegionRectangleCreate(FRectROI.Left, FRectROI.Top, FRectROI.Width, FRectROI.Height);
  end;

  FRectModelROI := FItemModelROI.NormalizedBoundsRect;
  if FItemModelROI.ItemType = oitPolygon then
  begin
    VoRegionPolygonArrayClear();
    for i := 0 to Pred(FItemModelROI.PointCount) do
    begin
      VoRegionPolygonArrayAdd(FItemModelROI.Points[i].X, FItemModelROI.Points[i].Y);
    end;

    if FRgnModelROI <> 0 then VoRegionRelease(FRgnModelROI);
    FRgnModelROI := VoRegionPolygonCreate();
  end
  else
  begin
    if FRgnModelROI <> 0 then VoRegionRelease(FRgnModelROI);
    FRgnModelROI := VoRegionRectangleCreate(FRectModelROI.Left, FRectModelROI.Top, FRectModelROI.Width, FRectModelROI.Height);
  end;

  // Template Create
  if FVector <> 0 then VoVectorRelease(FVector);
  FVector := VoVectorCreate();

  if FSearchTemplate <> 0 then VoSearchToolRelease(FSearchTemplate);

  bBuildOk := Boolean(VoSearchToolScaledShapeCreate(FBufferImageSrc, FRgnModelROI, FVisionNumLevel,
                          FVisionAngleStart, FVisionAngleExtent, FVisionAngleStep,
                          FVisionScaleMin, FVisionScaleMax, FVisionScaleStep,
                          FVisionOptimization, FVisionMetric, FVisionContrast, FVisionMinContrast,
                          @FSearchTemplate, @FVector));

  if not bBuildOk then
  begin
//    FireLog('BuildModel : Build Error...');
  end;

end;

function TGSearchAlgorithm.Inspect: Boolean;
var
  W, H: Integer;
  hImgData: VOHANDLE;

  DX, DY, DScore, DAngle: Double;
  i, n: Integer;
begin
  FResult := False;
  FResultX := 0;
  FResultY := 0;
  FResultT := 0;
  FResultScore := 0;
  Result := False;

  SetLength(FSearchResult, FVisionModelCount);
  for i := 0 to FVisionModelCount - 1 do
  begin
    FSearchResult[i].X := 0;
    FSearchResult[i].Y := 0;
    FSearchResult[i].Angle := 0;
    FSearchResult[i].Score := 0;
    FSearchResult[i].Scale := 0;
  end;


  if FBufferImageSrc = 0 then exit;

  FLock.Enter;
  FInspTime.Start;

  VoBufferImageGetRawImageData(FBufferImageSrc, W, H, @hImgData);

  if FRgnTransferROI <> 0 then VoRegionRelease(FRgnTransferROI);
  FRgnTransferROI := VoRegionCreate();

  // Offset ROI
  VoRegionTransfer(FRgnROI, FOffsetX, FOffsetY, FOffsetT, FOffsetCX, FOffsetCY, FRgnTransferROI);

  if Boolean(VoSearchToolScaledShapeSearch(FBufferImageSrc, FRgnTransferROI, FSearchTemplate,
              FVisionAngleStart, FVisionAngleExtent, FVisionScaleMin, FVisionScaleMax,
              FVisionModelSearchScore, FVisionModelCount,
              FVisionSearchMaxOverlap, FVisionSearchSubPixel, FVisionNumLevel, FVisionSearchGreediness,
              DX, DY, DScore, DAngle, @FVector)) then
  begin
    Result := True;
    n := VoSearchToolResultCount(FSearchTemplate);

    FResultCount := n;
    if FResultCount > 0 then
    begin
      for i := 0 to FResultCount - 1 do
      begin
        VoSearchToolResult(FSearchTemplate, i, DX, DY, DScore, DAngle);
        FSearchResult[i].X := DX + FResultOffsetX;
        FSearchResult[i].Y := DY + FResultOffsetY;
        FSearchResult[i].Angle := DAngle;
        FSearchResult[i].Score := DScore;
        FResult := True;

        FResultX := FResultX + FSearchResult[i].X;
        FResultY := FResultY + FSearchResult[i].Y;
        FResultT := FResultT + FSearchResult[i].Angle;
        FResultScore := FResultScore + FSearchResult[i].Score;

        if DScore >= FVisionSearchScore then
        begin
          //FireLog(Format('Search ok [Vision=%d,Model=%d] X=%.3f,Y=%.3f,Score=%.3f, Time=%.3f', [nChNo, nModelNo, DX, DY, DScore, FInspTime.Stop]));
        end
        else
        begin
          //FireLog(Format('Search score error [Vision=%d, Model=%d] X=%.3f,Y=%.3f,Score=%.3f, Time=%.3f', [nChNo, nModelNo, DX, DY, DScore, FInspTime.Stop]));

          Result := False;
          FResult := False;
        end;
      end;

      FResultX := FResultX / FResultCount;
      FResultY := FResultY / FResultCount;
      FResultT := FResultT / FResultCount;
      FResultScore := FResultScore / FResultCount;
    end;
  end
  else
  begin
    //FireLog(Format('Vision%d, Model Not Found... Time=%.3f', [nChNo, FInspTime.Stop]));
  end;

  FInspTime.Stop;
  FLock.Leave;

  Result := True;
end;

procedure TGSearchAlgorithm.Draw(ASender: TObject; ACanvas: TCanvas);
begin
  inherited;

  if FBufferView = 0 then exit;

  VoBufferViewSetStockBrush(FBufferView, 5);
  VoBufferViewSetPen(FBufferView, 0, 1, 255, 255, 0);
  VoBufferViewDrawRegion(ACanvas.Handle, FBufferView, FRgnROI);

  VoBufferViewSetPen(FBufferView, 2, 2, 255, 0, 0);
  VoBufferViewDrawVector(ACanvas.Handle, FBufferView, FVector);

  VoBufferViewSetPen(FBufferView, 2, 2, 0, 0, 255);
  VoBufferViewDrawCross(FBufferView, ACanvas.Handle, FResultX, FResultY, 50, 50);
  DrawText(ASender, ACanvas, Point(Trunc(FResultX), Trunc(FResultY)),
    Format('[%s], X=%.3f, Y=%.3f, S=%.3f', [FCaption, FResultX, FResultY, FResultScore]), clRed, 8);
end;

procedure TGSearchAlgorithm.LoadFromFile(AFileName: String);
begin
  foObjectFromXmlFile(Self, AFileName);
end;

procedure TGSearchAlgorithm.SaveToFile(AFileName: String);
begin
  foObjectToXmlFile(Self, AFileName);
end;

{ TGSearchAlgorithms}
constructor TGSearchAlgorithms.Create(AOwner: TPersistent; ItemClass: TGSearchAlgorithmClass);
begin
  Owner := AOwner;
  inherited Create(ItemClass);
end;

destructor TGSearchAlgorithms.Destroy;
begin

  inherited;
end;

function TGSearchAlgorithms.Add: TGSearchAlgorithm;
begin
  Result := TGSearchAlgorithm(inherited Add);
  Result.Caption := 'GSearch';
end;

function TGSearchAlgorithms.GetItem(Index: Integer): TGSearchAlgorithm;
begin
  Result := TGSearchAlgorithm(inherited Items[Index]);
end;

function TGSearchAlgorithms.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TGSearchAlgorithms.SetItem(Index: Integer; Value: TGSearchAlgorithm);
begin
  Items[Index].Assign(Value);
end;

procedure TGSearchAlgorithms.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TMeasCornerAlgorithm }
constructor TMeasCornerAlgorithm.Create(Collection: TCollection);
begin
  inherited;

  FInspAlgoritm := iaMeasCorner;
  FOLineX := 0;
  FOLineY := 0;
  FFirstMeasRectV := Rect(0, 0, 0, 0);
  FFirstMeasRectH := Rect(0, 0, 0, 0);
  FMeasRectV := Rect(0, 0, 0, 0);
  FMeasRectH := Rect(0, 0, 0, 0);

  SetLength(FVPos, 0);
  SetLength(FVFoundPos, 0);
  SetLength(FHPos, 0);
  SetLength(FHFoundPos, 0);


  FForgroundRgn := 0;

  FDetailMeasCount := 1;
  SetLength(FDetailMeasData, 1);

  FSearchBlobUse:= False;
  FSearchBlobThresholdMin:= 0;
  FSearchBlobThresholdMax:= 255;
  FAreaMin:= 10;;
  FAreaMax:= 100000;
  FSizeXMin:= 1;
  FSizeXMax:= 1000;
  FSizeYMin:= 1;
  FSizeYMax:= 1000;

  FBlobSearchMethod:= mdLeftToRight;
  FBlobSearchOffsetX:= 0;
  FBlobSearchOffsetY:= 0;
  FSizeX:= 0;
  FSizeY:= 0;
  FArea:= 0;

  FBlobShow:= False;


  FEdgeFirstTransition:= etAuto;
  FEdgeFirstThreshold:= 10;
  FEdgeScanningStep:= 1;

  FEdgeThickness:= 10;
  FMeasureDir:= mdLeftToRight;
  FEdgeScanLength:= 100;
  FEdgeBoundSkipOffset:= 0;

  FMeasCountH:= 10;
  FHMaxCount:= 10;
  FHStartSkip:= 0;
  FHEndSkip:= 0;

  FMeasCountV:= 10;
  FVMaxCount:= 10;
  FVStartSkip:= 0;
  FVEndSkip:= 0;

  FReverse:= 0;

  FEdgeSecondTransition:= etAuto;
  FEdgeSecondThreshold:= 10;

  FEdgeMeasureScore:= 0.5;

  FRectOffsetX:= 0;
  FRectOffsetY:= 0;
  FResultAcceptLength:= 1;

end;

destructor TMeasCornerAlgorithm.Destroy;
begin
  if FForgroundRgn <> 0 then VoRegionRelease(FForgroundRgn);

  inherited;
end;

procedure TMeasCornerAlgorithm.Assign(Source: TPersistent);
begin
  if Source is TMeasCornerAlgorithm then
  begin
    FSearchBlobUse := TMeasCornerAlgorithm(Source).SearchBlobUse;

    FBlobShow := TMeasCornerAlgorithm(Source).BlobShow;
    FBlobSearchMethod := TMeasCornerAlgorithm(Source).BlobSearchMethod;
    FBlobSearchOffsetX := TMeasCornerAlgorithm(Source).BlobSearchOffsetX;
    FBlobSearchOffsetY := TMeasCornerAlgorithm(Source).BlobSearchOffsetY;
    FSearchBlobThresholdMin := TMeasCornerAlgorithm(Source).SearchBlobThresholdMin;
    FSearchBlobThresholdMax := TMeasCornerAlgorithm(Source).SearchBlobThresholdMax;

    FAreaMin := TMeasCornerAlgorithm(Source).AreaMin;
    FAreaMax := TMeasCornerAlgorithm(Source).AreaMax;
    FSizeXMin := TMeasCornerAlgorithm(Source).SizeXMin;
    FSizeXMax := TMeasCornerAlgorithm(Source).SizeXMax;
    FSizeYMin := TMeasCornerAlgorithm(Source).SizeYMin;
    FSizeYMax := TMeasCornerAlgorithm(Source).SizeYMax;

    FArea := TMeasCornerAlgorithm(Source).Area;
    FSizeX := TMeasCornerAlgorithm(Source).SizeX;
    FSizeY := TMeasCornerAlgorithm(Source).SizeY;

    FMeasureDir := TMeasCornerAlgorithm(Source).MeasureDir;

    FEdgeFirstTransition := TMeasCornerAlgorithm(Source).EdgeFirstTransition;
    FEdgeFirstThreshold := TMeasCornerAlgorithm(Source).EdgeFirstThreshold;
    FEdgeScanLength := TMeasCornerAlgorithm(Source).EdgeScanLength;
    FEdgeThickness := TMeasCornerAlgorithm(Source).EdgeThickness;
    FEdgeScanningStep := TMeasCornerAlgorithm(Source).EdgeScanningStep;
    FEdgeBoundSkipOffset := TMeasCornerAlgorithm(Source).EdgeBoundSkipOffset;
    FEdgeMeasureScore := TMeasCornerAlgorithm(Source).EdgeMeasureScore;
    FReverse := TMeasCornerAlgorithm(Source).Reverse;

    FEdgeSecondTransition := TMeasCornerAlgorithm(Source).EdgeSecondTransition;
    FEdgeSecondThreshold := TMeasCornerAlgorithm(Source).EdgeSecondThreshold;
    FResultAcceptLength := TMeasCornerAlgorithm(Source).ResultAcceptLength;

    FVStartSkip := TMeasCornerAlgorithm(Source).VStartSkip;
    FVEndSkip := TMeasCornerAlgorithm(Source).VEndSkip;
    FVMaxCount := TMeasCornerAlgorithm(Source).VMaxCount;
    FHStartSkip := TMeasCornerAlgorithm(Source).HStartSkip;
    FHEndSkip := TMeasCornerAlgorithm(Source).HEndSkip;
    FHMaxCount := TMeasCornerAlgorithm(Source).HMaxCount;
    FRectOffsetX := TMeasCornerAlgorithm(Source).RectOffsetX;
    FRectOffsetY := TMeasCornerAlgorithm(Source).RectOffsetY;

    FMeasCountV := TMeasCornerAlgorithm(Source).MeasCountV;
    FMeasCountH := TMeasCornerAlgorithm(Source).MeasCountH;
  end
  else
    inherited Assign(Source);
end;

function TMeasCornerAlgorithm.Build: Boolean;
begin
  Result := False;
  If not Assigned(FItemROI) then exit;

  FRectROI := FItemROI.NormalizedBoundsRect;

  if FRgnROI <> 0 then VoRegionRelease(FRgnROI);
  FRgnROI := VoRegionRectangleCreate(FRectROI.Left, FRectROI.Top, FRectROI.Width, FRectROI.Height);

  Result := True;
end;

function TMeasCornerAlgorithm.Inspect: Boolean;

  function BlobEdgeSearch(var dLeft : Double; var dTop : Double; var dRight : Double; var dBottom : Double): Boolean;
  var
    W, H  : Integer;
    szValue : AnsiString;

    nArea, nCount : Integer;
    hImgData: VOHANDLE;
    dCX, dCY : Double;
    nAreaLeft, nAreaTop, nAreaRight, nAreaBottom : Integer;
    nAreaWidth, nAreaHeight : Integer;

    hBlobRgn       : VOHANDLE;
    hBlobSelectRgn : VOHANDLE;
    hBlobListRgn   : VOHANDLE;
    hBlobFillRgn   : VOHANDLE;
  begin
    Result := False;
    VoBufferImageGetRawImageData(FBufferImageSrc, W, H, @hImgData);

    dCX := 0;
    dCY := 0;
    nCount := 0;
    dLeft := 0;
    dTop := 0;
    dRight := 0;
    dBottom := 0;

    hBlobRgn       := VoRegionCreate();
    hBlobSelectRgn := VoRegionCreate();
    hBlobListRgn   := VoRegionCreate();
    hBlobFillRgn   := VoRegionCreate();

    VoRegionRelease(FForgroundRgn); FForgroundRgn := VoRegionCreate();

    VoRegionRelease(FRgnROI);
    FRgnROI := VoRegionRectangleCreate(FRectROI.Left, FRectROI.Top, FRectROI.Width, FRectROI.Height);

    VoImageProcessingThreshold(FBufferImageSrc, FRgnROI, FSearchBlobThresholdMin, FSearchBlobThresholdMax, hBlobRgn);

    VoRegionSegmentConnected(hBlobRgn, hBlobListRgn);

    szValue := Format('Area[%d-%d],Width[%d-%d],Height[%d-%d]', [FAreaMin, FAreaMax, FSizeXMin, FSizeXMax, FSizeYMin, FSizeYMax]);

    VoRegionSelectRegion(hBlobListRgn, PAnsiChar(szValue), 2, hBlobSelectRgn);
    VoRegionGetRegionCount(hBlobSelectRgn, nCount);

    VoRegionUnionRegionList(hBlobSelectRgn, FForgroundRgn);

    VoRegionGetAreaCenter(FForgroundRgn, nArea, dCX, dCY);
    VoRegionGetRectangle(FForgroundRgn, nAreaLeft, nAreaTop, nAreaRight, nAreaBottom);

    if (nArea > 100) and (nCount > 0)  then
    begin
      Result := True;
      dLeft := nAreaLeft;
      dTop := nAreaTop;
      dRight := nAreaRight;
      dBottom := nAreaBottom;

      nAreaWidth := nAreaRight - nAreaLeft;
      nAreaHeight := nAreaBottom - nAreaTop;
      FArea := nArea;
      FSizeX := nAreaWidth;
      FSizeY := nAreaHeight;
    end;
    VoRegionRelease(hBlobRgn);
    VoRegionRelease(hBlobSelectRgn);
    VoRegionRelease(hBlobListRgn);
    VoRegionRelease(hBlobFillRgn);
  end;

  procedure CalcPos(nDir : TMeasureDir; dCX, dCY : Double;
  	var dVSX : Double; var dVSY : Double; var dVEX : Double; var dVEY : Double;
    var dHSX : Double; var dHSY : Double; var dHEX : Double; var dHEY : Double);
  begin
  	case nDir of
      mdLeftToRight :
      begin
      	// Left -> Right
        dVSX := FRectROI.Left;
        dVSY := dCY;
        dVEX := dVSX + FEdgeScanLength; // gSearchEdge[nCh, nModel].rectROI.Right;
        dVEY := dCY;

        // Bottom -> Top
      	dHSX := dCX;
        dHSY := FRectROI.Bottom;
        dHEX := dCX;
        dHEY := dHSY - FEdgeScanLength;   //gSearchEdge[nCh, nModel].rectROI.Top;
      end;

      mdRightToLeft	:
      begin
      	// Right -> Left
        dVSX := FRectROI.Right;
        dVSY := dCY;
        dVEX := dVSX - FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Left;;
        dVEY := dCY;

        // Bottom -> Top
      	dHSX := dCX;
        dHSY := FRectROI.Bottom;
        dHEX := dCX;
        dHEY := dHSY - FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Top;
      end;

      mdTopToBottom :
      begin
      	// Left -> Right
        dVSX := FRectROI.Left;
        dVSY := dCY;
        dVEX := dVSX + FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Right;
        dVEY := dCY;

        // Top -> Bottom
      	dHSX := dCX;
        dHSY := FRectROI.Top;
        dHEX := dCX;
        dHEY := dHSY + FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Bottom;
      end;

      mdBottomToTop	:
      begin
      	// Right -> Left
        dVSX := FRectROI.Right;
        dVSY := dCY;
        dVEX := dVSX - FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Left;
        dVEY := dCY;

        // Top -> Bottom
      	dHSX := dCX;
        dHSY := FRectROI.Top;
        dHEX := dCX;
        dHEY := dHSY + FEdgeScanLength; //gSearchEdge[nCh, nModel].rectROI.Bottom;
      end;
    end;
  end;

  function FindSearchEdgeMeasure(hImgSrc: VOHANDLE; W, H : Integer; dSX, dSY, dEX, dEY, dThickness, dThreshold :
           Double; nTransition : Integer; var dResX : Double; var dResY : Double) : Boolean;
  begin
    Result := False;
    dResX := 0;
    dResY := 0;

    VoMeasureToolLineCreate(dSX, dSY, dEX, dEY, dThickness, 1, W, H);
    VoMeasureToolMeasurePos(hImgSrc, 1, dThreshold, nTransition);
    VoMeasureToolGetFirstPos(0, dResX, dResY);

    if (dResX > 0) and (dResY > 0) and (dResX < W) and (dResY < H) then
    begin
      Result := True;
    end;
  end;

var
  n: Integer;
  W, H: Integer;
  hImgData: VOHANDLE;

  dBlobLeft, dBlobTop, dBlobRight, dBlobBottom : Double;

  nScanStart, nScanLimit, nCount, nTotalCount : Integer;
  nVScanStep, nHScanStep : Integer;

  bVLFound, bHLFound : Boolean;

  dCX, dCY : Double;
  dVSX, dVSY, dVEX, dVEY : Double;
  dHSX, dHSY, dHEX, dHEY : Double;
  dResX, dResY, dAmp : Double;

  DA, dB, dC : Double;

  dpA, dpB, dpC, dpD, dpE, dpF, dpA1, dpB1, dpC1, dpD1, dpE1, dpF1 : Double;
  dpX, dpY : Double;
begin
  Result := False;

  FResult := False;
  FResultX := 0;
  FResultY := 0;
  FResultScore := 0;
  FOLineX := 0;
  FOLineY := 0;
  bVLFound := False;
  bHLFound := False;

  if FBufferImageSrc = 0 then exit;

  FLock.Enter;
  FInspTime.Start;

  VoBufferImageGetRawImageData(FBufferImageSrc, W, H, @hImgData);

  if FSearchBlobUse then
  begin
    if BlobEdgeSearch(dBlobLeft, dBlobTop, dBlobRight, dBlobBottom) then
    begin
      case FBlobSearchMethod of
        mdLeftToRight :
        begin
          dCX := dBlobLeft + (FEdgeThickness / 2) + FBlobSearchOffsetX;
          dCY := dBlobBottom - (FEdgeThickness / 2) - FBlobSearchOffsetY;
        end;
        mdRightToLeft :
        begin
          dCX := dBlobRight  - (FEdgeThickness / 2) - FBlobSearchOffsetX;
          dCY := dBlobBottom - (FEdgeThickness / 2) - FBlobSearchOffsetY;
        end;
        mdTopToBottom :
        begin
          dCX := dBlobLeft + (FEdgeThickness / 2) + FBlobSearchOffsetX;
          dCY := dBlobTop + (FEdgeThickness / 2) + FBlobSearchOffsetY;
        end;
        mdBottomToTop :
        begin
          dCX := dBlobRight - (FEdgeThickness / 2) - FBlobSearchOffsetX;
          dCY := dBlobTop + (FEdgeThickness / 2) + FBlobSearchOffsetY;
        end;
      end;
    end
    else
    begin
      dCX := (FrectROI.Left + FrectROI.Right) /2;
      dCY := (FrectROI.Top + FrectROI.Bottom) /2;
    end;
  end
  else
  begin
    dCX := (FrectROI.Left + FrectROI.Right) /2;
    dCY := (FrectROI.Top + FrectROI.Bottom) /2;
  end;

  CalcPos(FMeasureDir, dCX, dCY, dVSX, dVSY, dVEX, dVEY, dHSX, dHSY, dHEX, dHEY);

  FFirstMeasRectV := Rect(Trunc(dVSX), Trunc(dVSY), Trunc(dVEX), Trunc(dVEY));
  FFirstMeasRectH := Rect(Trunc(dHSX), Trunc(dHSY), Trunc(dHEX), Trunc(dHEY));

  dResX := 0;
  dResY := 0;
  dAmp := 0;

  // Vertical Scanning...
  FindSearchEdgeMeasure(FBufferImageSrc, W, H, dVSX, dVSY, dVEX, dVEY, FEdgeThickness, FEdgeFirstThreshold, Ord(FEdgeFirstTransition), dResX, dResY);
  FOLineX := dResX;

  // Horizontal Scanning...
  FindSearchEdgeMeasure(FBufferImageSrc, W, H, dHSX, dHSY, dHEX, dHEY, FEdgeThickness, FEdgeFirstThreshold, Ord(FEdgeFirstTransition), dResX, dResY);
  FOLineY := dResY;

  case FMeasureDir of
    mdLeftToRight :
    begin
      // Left -> Right
      FMeasRectV.Left := Trunc((FOLineX  + FRectOffsetX) - FEdgeBoundSkipOffset);
      FMeasRectV.Top := Trunc(FRectROI.Top + FVEndSkip);
      FMeasRectV.Right := Trunc((FOLineX  + FRectOffsetX) + FEdgeBoundSkipOffset);
      FMeasRectV.Bottom := Trunc(FOLineY - FVStartSkip);
      nVScanStep := -FEdgeScanningStep;

      // Bottom -> Top
      FMeasRectH.Left := Trunc(FOLineX) + FHStartSkip;
      FMeasRectH.Top := Trunc((FOLineY + FRectOffsetY)
                                                    - FEdgeBoundSkipOffset);
      FMeasRectH.Right := FrectROI.Right - FHEndSkip;
      FMeasRectH.Bottom := Trunc((FOLineY + FRectOffsetY) + FEdgeBoundSkipOffset);
      nHScanStep := FEdgeScanningStep;
    end;
    mdRightToLeft	:
    begin
      // Right -> Left
      FMeasRectV.Left := Trunc((FOLineX  + FRectOffsetX) - FEdgeBoundSkipOffset);
      FMeasRectV.Top := FrectROI.Top + FVEndSkip;
      FMeasRectV.Right := Trunc((FOLineX  + FRectOffsetX) + FEdgeBoundSkipOffset);
      FMeasRectV.Bottom := Trunc(FOLineY) - FVStartSkip;
      nVScanStep := -FEdgeScanningStep;

      // Bottom -> Top
      FMeasRectH.Left := FRectROI.Left + FHEndSkip;
      FMeasRectH.Top := Trunc((FOLineY + FRectOffsetY) - FEdgeBoundSkipOffset);
      FMeasRectH.Right := Trunc(FOLineX) - FHStartSkip;
      FMeasRectH.Bottom := Trunc((FOLineY + FRectOffsetY) + FEdgeBoundSkipOffset);
      nHScanStep := -FEdgeScanningStep;
    end;
    mdTopToBottom :
    begin
      // Left -> Right
      FMeasRectV.Left := Trunc((FOLineX + FRectOffsetX) - FEdgeBoundSkipOffset);
      FMeasRectV.Top := Trunc(FOLineY) + FVStartSkip;
      nVScanStep := FEdgeScanningStep;
      FMeasRectV.Right := Trunc((FOLineX + FRectOffsetX) + FEdgeBoundSkipOffset);
      FMeasRectV.Bottom := FRectROI.Bottom - FVEndSkip;

      // Top -> Bottom
      FMeasRectH.Left := Trunc(FOLineX) + FHStartSkip;
      FMeasRectH.Top := Trunc((FOLineY + FRectOffsetY) - FEdgeBoundSkipOffset);
      FMeasRectH.Right := FRectROI.Right - FHEndSkip;
      FMeasRectH.Bottom := Trunc((FOLineY + FRectOffsetY) + FEdgeBoundSkipOffset);
      nHScanStep := FEdgeScanningStep;
    end;
    mdBottomToTop	:
    begin
      // Right -> Left
      FMeasRectV.Left := Trunc((FOLineX  + FRectOffsetX) - FEdgeBoundSkipOffset);
      FMeasRectV.Top := Trunc(FOLineY) + FVStartSkip;
      nVScanStep := FEdgeScanningStep;
      FMeasRectV.Right := Trunc((FOLineX  + FRectOffsetX) + FEdgeBoundSkipOffset);
      FMeasRectV.Bottom := FRectROI.Bottom - FVEndSkip;

      // Top -> Bottom
      FMeasRectH.Left := FRectROI.Left + FHEndSkip;
      FMeasRectH.Top := Trunc((FOLineY  + FRectOffsetY) - FEdgeBoundSkipOffset);
      FMeasRectH.Right := Trunc(FOLineX) - FHStartSkip;
      FMeasRectH.Bottom := Trunc((FOLineY  + FRectOffsetY) + FEdgeBoundSkipOffset);
      nHScanStep := -FEdgeScanningStep;
    end;
  end;

  // Vertical Scanning...
  if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft) then
  begin
    nScanStart := FMeasRectV.Bottom;
    nScanLimit := FMeasRectV.Top;
  end
  else
  begin
    nScanStart := FMeasRectV.Top;
    nScanLimit := FMeasRectV.Bottom;
  end;

  VoArrayPosClear();

  FMeasCountV := 0;
  SetLength(FVPos, FMeasCountV+1);
  SetLength(FVFoundPos, FMeasCountV+1);

  nCount := 0;
  n := 0;
  nTotalCount := Trunc(abs(nScanStart - nScanLimit) / Abs(nVScanStep));
  While (nCount < FVMaxCount) and (n < nTotalCount) do
  begin
    dVSY := nScanStart + (nVScanStep / 2);
    dVEY := nScanStart + (nVScanStep / 2);

    if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdTopToBottom) then
    begin
      if FReverse = 0 then
      begin
        dVSX := FMeasRectV.Left;
        dVEX := FMeasRectV.Right;
      end
      else
      begin
        dVSX := FMeasRectV.Right;
        dVEX := FMeasRectV.Left;
      end;
    end
    else
    begin
      if FReverse = 0 then
      begin
        dVSX := FMeasRectV.Right;
        dVEX := FMeasRectV.Left;
      end
      else
      begin
        dVSX := FMeasRectV.Left;
        dVEX := FMeasRectV.Right;
      end;
    end;

    if FindSearchEdgeMeasure(FBufferImageSrc, W, H, dVSX, dVSY, dVEX, dVEY, FEdgeScanningStep, FEdgeSecondThreshold, Ord(FEdgeSecondTransition), dResX, dResY) then
    begin
      FVPos[FMeasCountV].X := dResX;
      FVPos[FMeasCountV].Y := dResY;
      FVFoundPos[FMeasCountV] := True;
      VoArrayPosAdd(dResX, dResY);
      Inc(nCount);
    end
    else
    begin
      FVPos[FMeasCountV].X := 0;
      FVPos[FMeasCountV].Y := 0;
      FVFoundPos[FMeasCountV] := False;
    end;
    Inc(FMeasCountV);
    SetLength(FVPos, FMeasCountV+1);
    SetLength(FVFoundPos, FMeasCountV+1);

    nScanStart := nScanStart + nVScanStep;
    inc(n);
  end;

  if FMeasCountV > 0 then
  begin
    FResultScore := nCount / FMeasCountV;
  end
  else
  begin
    FResultScore := 0;
  end;

  if (nCount > 3) and
     (FResultScore > FEdgeMeasureScore) then
  begin
    VoGetLRLine(1, dpA1, dpB1, dpC1);

    VoArrayPosClear();
    nCount := 0;

    for n := 0 to FMeasCountV - 1 do
    begin
      if FVFoundPos[n] then
      begin
        dResX := FVPos[n].X;
        dResY := FVPos[n].Y;
        DA := dpA1;
        dB := dpB1;
        dC := dpC1;

        if GetLineToPos(DA, dB, dC, dResX, dResY) < FResultAcceptLength then
        begin
          VoArrayPosAdd(dResX, dResY);
          nCount := nCount +1;
        end
        else
        begin
          FVFoundPos[n] := False;
        end;
      end;
    end;

    FResultScore := nCount / FMeasCountV;
    if (nCount > 3) and
       (FResultScore > FEdgeMeasureScore) then
    begin
      VoGetLRLine(1, dpA, dpB, dpC);
      bVLFound := True;
    end;
  end;

  // Horizontal Scanning...
  if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdTopToBottom) then
  begin
    nScanStart := FMeasRectH.Left;
    nScanLimit := FMeasRectH.Right;
  end
  else
  begin
    nScanStart := FMeasRectH.Right;
    nScanLimit := FMeasRectH.Left;
  end;

  VoArrayPosClear();


  FMeasCountH := 0;
  SetLength(FHPos, FMeasCountH+1);
  SetLength(FHFoundPos, FMeasCountH+1);

  nCount := 0;
  n := 0;
  nTotalCount := Trunc(abs(nScanStart - nScanLimit) / abs(nVScanStep));

  While (nCount < FHMaxCount) and (n < nTotalCount) do
  begin
    dHSX := nScanStart + (nHScanStep / 2);
    dHEX := nScanStart + (nHScanStep / 2);

    if (FMeasureDir = mdLeftToRight) or (FMeasureDir = mdRightToLeft) then
    begin
      if FReverse  = 0 then
      begin
        dHSY := FMeasRectH.Bottom;
        dHEY := FMeasRectH.Top;
      end
      else
      begin
        dHSY := FMeasRectH.Top;
        dHEY := FMeasRectH.Bottom;
      end;
    end
    else
    begin
      if FReverse = 0 then
      begin
        dHSY := FMeasRectH.Top;
        dHEY := FMeasRectH.Bottom;
      end
      else
      begin
        dHSY := FMeasRectH.Bottom;
        dHEY := FMeasRectH.Top;
      end;
    end;


    if FindSearchEdgeMeasure(FBufferImageSrc, W, H, dHSX, dHSY, dHEX, dHEY, FEdgeScanningStep, FEdgeSecondThreshold, Ord(FEdgeSecondTransition), dResX, dResY) then
    begin
      FHPos[FMeasCountH].X := dResX;
      FHPos[FMeasCountH].Y := dResY;
      FHFoundPos[FMeasCountH] := True;
      VoArrayPosAdd(dResX, dResY);
      Inc(nCount);
    end
    else
    begin
      FHPos[FMeasCountH].X := 0;
      FHPos[FMeasCountH].Y := 0;
      FHFoundPos[FMeasCountH] := False;
    end;
    Inc(FMeasCountH);
    SetLength(FHPos, FMeasCountH+1);
    SetLength(FHFoundPos, FMeasCountH+1);

    nScanStart := nScanStart + nHScanStep;
    inc(n);
  end;

  if FMeasCountH > 0 then
  begin
    FResultScore := nCount / FMeasCountH;
  end
  else
  begin
    FResultScore := 0;
  end;

  if (nCount > 3) and (FResultScore > FEdgeMeasureScore) then
  begin
    VoGetLRLine(0, dpD1, dpE1, dpF1);

    VoArrayPosClear();
    nCount := 0;

    for n := 0 to FMeasCountH - 1 do
    begin
      if FHFoundPos[n] then
      begin
        dResX := FHPos[n].X;
        dResY := FHPos[n].Y;
        DA := dpD1;
        dB := dpE1;
        dC := dpF1;

        if GetLineToPos(DA, dB, dC, dResX, dResY) < FResultAcceptLength then
        begin
          VoArrayPosAdd(dResX, dResY);
          nCount := nCount +1;
        end
        else
        begin
          FHFoundPos[n] := False;
        end;
      end;
    end;

    FResultScore := nCount / FMeasCountH;
    if (nCount > 3) and
       (FResultScore > FEdgeMeasureScore) then
    begin
      VoGetLRLine(0, dpD, dpE, dpF);
      bHLFound := True;
    end;
  end;

  if bVLFound and bHLFound then
  begin
    VoGetLineIntersection(dpA, dpB, dpC, dpD, dpE, dpF, dpX, dpY);

    if (dpX > 0) and (dpX < W) and (dpY > 0) and (dpY < H) then
    begin
      FResult := True;
      FResultX := dpX;
      FResultY := dpY;
      result := FResult;
    end;
  end;

  FInspTime.Stop;
  FLock.Leave;

  Result := True;
end;

procedure TMeasCornerAlgorithm.Draw(ASender: TObject; ACanvas: TCanvas);
begin
  inherited;

  if FBufferView = 0 then exit;

end;

procedure TMeasCornerAlgorithm.LoadFromFile(AFileName: String);
begin
  inherited;

end;

procedure TMeasCornerAlgorithm.SaveToFile(AFileName: String);
begin
  inherited;

end;

{ TMeasCornerAlgorithms }

constructor TMeasCornerAlgorithms.Create(AOwner: TPersistent; ItemClass: TMeasCornerAlgorithmClass);
begin
  Owner := AOwner;
  inherited Create(ItemClass);
end;

destructor TMeasCornerAlgorithms.Destroy;
begin

  inherited;
end;

function TMeasCornerAlgorithms.Add: TMeasCornerAlgorithm;
begin

  Result := TMeasCornerAlgorithm(inherited Add);
  Result.Caption := 'MeasCorner';
end;

function TMeasCornerAlgorithms.GetItem(Index: Integer): TMeasCornerAlgorithm;
begin
  Result := TMeasCornerAlgorithm(inherited Items[Index]);
end;

function TMeasCornerAlgorithms.GetOwner: TPersistent;
begin
  Result := Owner;
end;

procedure TMeasCornerAlgorithms.SetItem(Index: Integer; Value: TMeasCornerAlgorithm);
begin
  Items[Index].Assign(Value);
end;

procedure TMeasCornerAlgorithms.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TInspector }
constructor TInspector.Create;
var
  I: Integer;
begin
  FMeasureAlgorithms := TMeasureAlgorithms.Create(Self, TMeasureAlgorithm);
  FBlobAlgorithms := TBlobAlgorithms.Create(Self, TBlobAlgorithm);
  FGSearchAlgorithms := TGSearchAlgorithms.Create(Self, TGSearchAlgorithm);
  FMeasCornerAlgorithms := TMeasCornerAlgorithms.Create(Self, TMeasCornerAlgorithm);

  FBufferView:= 0;
  FBufferSrc:= 0;
  FBufferImageSrc:= 0;
  FInspectionSrc:= 0;
  FBufferFilter:= 0;
  FBufferImageFilter:= 0;
  FInspectionFilter:= 0;

  for I := 0 to MAX_RESULT_DATA_COUNT-1 do
  begin
    SetLength(gResultData[I].Data, 0);
    SetLength(gResultData[I].DataA, 0);
    SetLength(gResultData[I].DataB, 0);
  end;

end;

destructor TInspector.Destroy;
var
  I: Integer;
begin
  FMeasureAlgorithms.Free;
  FBlobAlgorithms.Free;
  FGSearchAlgorithms.Free;
  FMeasCornerAlgorithms.Free;

  for I := 0 to MAX_RESULT_DATA_COUNT-1 do
  begin
    SetLength(gResultData[I].Data, 0);
    SetLength(gResultData[I].DataA, 0);
    SetLength(gResultData[I].DataB, 0);
  end;

  FinalizeVision;

  inherited;
end;

procedure TInspector.Clear;
begin
  FMeasureAlgorithms.Clear;
  FBlobAlgorithms.Clear;
  FGSearchAlgorithms.Clear;
  FMeasCornerAlgorithms.Clear;

end;

procedure TInspector.Add(InspAlgoritm: TInspAlgoritm);
begin
  case InspAlgoritm of
    iaGSearch : FGSearchAlgorithms.Add;
    iaMeasure : FMeasureAlgorithms.Add;
    iaCircle : ;
    iaBlob : FBlobAlgorithms.Add;
    iaDetect : ;
    iaSearchCircle : ;
    iaSearchRect : ;
    iaMeasCorner : FMeasCornerAlgorithms.Add;
  end;
end;

function TInspector.Build(AChNo, AModelNo: Integer): Boolean;
var
  nIndex : Integer;
begin
  nIndex := gModelInfos[AChNo, AModelNo].AlgoritmIndex;
  case gModelInfos[AChNo, AModelNo].InspAlgoritm of
    iaGSearch :
    begin
      with FGSearchAlgorithms[nIndex] do
      begin
        ChNo := AChNo;
        BufferView := FBufferView;
        BufferSrc := FBufferSrc;
        BufferImageSrc := FBufferImageSrc;
        InspectionSrc := FInspectionSrc;
        BufferFilter := FBufferFilter;
        BufferImageFilter := FBufferImageFilter;
        InspectionFilter := FInspectionFilter;

        Build;
      end;
    end;
    iaMeasure :
    begin
      with FMeasureAlgorithms[nIndex] do
      begin
        ChNo := AChNo;
        BufferView := FBufferView;
        BufferSrc := FBufferSrc;
        BufferImageSrc := FBufferImageSrc;
        InspectionSrc := FInspectionSrc;
        BufferFilter := FBufferFilter;
        BufferImageFilter := FBufferImageFilter;
        InspectionFilter := FInspectionFilter;

        Build;
      end;

    end;
    iaCircle : ;
    iaBlob :
    begin
      with FBlobAlgorithms[nIndex] do
      begin
        ChNo := AChNo;
        BufferView := FBufferView;
        BufferSrc := FBufferSrc;
        BufferImageSrc := FBufferImageSrc;
        InspectionSrc := FInspectionSrc;
        BufferFilter := FBufferFilter;
        BufferImageFilter := FBufferImageFilter;
        InspectionFilter := FInspectionFilter;

        Build;
      end;
    end;
    iaDetect : ;
    iaSearchCircle : ;
    iaSearchRect : ;
    iaMeasCorner :
    begin
      with FMeasCornerAlgorithms[nIndex] do
      begin
        ChNo := AChNo;
        BufferView := FBufferView;
        BufferSrc := FBufferSrc;
        BufferImageSrc := FBufferImageSrc;
        InspectionSrc := FInspectionSrc;
        BufferFilter := FBufferFilter;
        BufferImageFilter := FBufferImageFilter;
        InspectionFilter := FInspectionFilter;

        Build;
      end;
    end;
  end;
end;

function TInspector.Inspect(AChNo, AModelNo: Integer): Boolean;
var
  hBufferView: VOHANDLE;
  hBufferSrc: VOHANDLE;
  hBufferImageSrc: VOHANDLE;
  hInspectionSrc: VOHANDLE;

var
  nIndex : Integer;
begin
  hBufferView:= gInspector[AChNo].hBufferView;
  hBufferSrc:= gInspector[AChNo].hBufferSrc;
  hBufferImageSrc:= gInspector[AChNo].hBufferImageSrc;
  hInspectionSrc:= gInspector[AChNo].hInspectionSrc;

  nIndex := gModelInfos[AChNo, AModelNo].AlgoritmIndex;
  case gModelInfos[AChNo, AModelNo].InspAlgoritm of
    iaGSearch :
    begin
      with FGSearchAlgorithms[nIndex] do
      begin
        BufferView := hBufferView;
        BufferSrc := hBufferSrc;
        BufferImageSrc := hBufferImageSrc;
        InspectionSrc := hInspectionSrc;

        Inspect;
      end;
    end;
    iaMeasure :
    begin
      with FMeasureAlgorithms[nIndex] do
      begin
        BufferView := hBufferView;
        BufferSrc := hBufferSrc;
        BufferImageSrc := hBufferImageSrc;
        InspectionSrc := hInspectionSrc;

        Inspect;
      end;
    end;
    iaCircle : ;
    iaBlob :
    begin
      with FBlobAlgorithms[nIndex] do
      begin
        BufferView := hBufferView;
        BufferSrc := hBufferSrc;
        BufferImageSrc := hBufferImageSrc;
        InspectionSrc := hInspectionSrc;

        Inspect;
      end;
    end;
    iaDetect : ;
    iaSearchCircle : ;
    iaSearchRect : ;
    iaMeasCorner :
    begin
      with FMeasCornerAlgorithms[nIndex] do
      begin
        BufferView := hBufferView;
        BufferSrc := hBufferSrc;
        BufferImageSrc := hBufferImageSrc;
        InspectionSrc := hInspectionSrc;

        Inspect;
      end;
    end;
  end;
end;

function TInspector.Build(AChNo : Integer): Boolean;
var
  I : Integer;
  hBufferView: VOHANDLE;
  hBufferSrc: VOHANDLE;
  hBufferImageSrc: VOHANDLE;
  hInspectionSrc: VOHANDLE;

begin
  Result := True;

  hBufferView:= gInspector[AChNo].hBufferView;
  hBufferSrc:= gInspector[AChNo].hBufferSrc;
  hBufferImageSrc:= gInspector[AChNo].hBufferImageSrc;
  hInspectionSrc:= gInspector[AChNo].hInspectionSrc;

  for I := 0 to FMeasureAlgorithms.Count-1 do
  begin
    if FMeasureAlgorithms[I].ChNo = AChNo then
    begin
      FMeasureAlgorithms[I].BufferView := hBufferView;
      FMeasureAlgorithms[I].BufferSrc := hBufferSrc;
      FMeasureAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FMeasureAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FMeasureAlgorithms[I].Build then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FBlobAlgorithms.Count-1 do
  begin
    if FBlobAlgorithms[I].ChNo = AChNo then
    begin
      FBlobAlgorithms[I].BufferView := hBufferView;
      FBlobAlgorithms[I].BufferSrc := hBufferSrc;
      FBlobAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FBlobAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FBlobAlgorithms[I].Build then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FGSearchAlgorithms.Count-1 do
  begin
    if FGSearchAlgorithms[I].ChNo = AChNo then
    begin
      FGSearchAlgorithms[I].BufferView := hBufferView;
      FGSearchAlgorithms[I].BufferSrc := hBufferSrc;
      FGSearchAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FGSearchAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FGSearchAlgorithms[I].Build then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FMeasCornerAlgorithms.Count-1 do
  begin
    if FMeasCornerAlgorithms[I].ChNo = AChNo then
    begin
      FMeasCornerAlgorithms[I].BufferView := hBufferView;
      FMeasCornerAlgorithms[I].BufferSrc := hBufferSrc;
      FMeasCornerAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FMeasCornerAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FMeasCornerAlgorithms[I].Build then
      begin
        Result := False;
      end;
    end;
  end;

end;

procedure TInspector.InitializeVision(AImageWidth, AImageHeight: Integer);
var
  pBuffer: Pointer;
  i, n, nModelNo: Integer;
begin
  FinalizeVision;

  FImageWidth := AImageWidth;
  FImageHeight := AImageHeight;

  FBufferView := VoBufferViewCreate(AImageWidth, AImageHeight);

  VObufferCreate(AImageWidth, AImageHeight, @FBufferSrc); // Create Buffer for Inspection
  pBuffer := VObufferGetData(FBufferSrc);
  FBufferImageSrc := VoBufferImageCreateExtern(AImageWidth, AImageHeight, Integer(pBuffer));
  VoInspectionCreateImageData(pBuffer, AImageWidth, AImageHeight, @FInspectionSrc);

  VObufferCreate(AImageWidth, AImageHeight, @FBufferFilter);
  pBuffer := VObufferGetData(FBufferFilter);
  FBufferImageFilter := VoBufferImageCreateExtern(AImageWidth, AImageHeight, Integer(pBuffer));
  VoInspectionCreateImageData(pBuffer, AImageWidth, AImageHeight, @FInspectionFilter);

end;

procedure TInspector.FinalizeVision;
begin
  if FBufferView <> 0 then VoBufferViewRelease(FBufferView);
  if FBufferSrc <> 0 then VObufferFree(FBufferSrc);
  if FBufferImageSrc <> 0 then VoBufferImageRelease(FBufferImageSrc);
  if FInspectionSrc <> 0 then VoInspectionFreeImageData(FInspectionSrc);
  if FBufferFilter <> 0 then VObufferFree(FBufferFilter);
  if FBufferImageFilter <> 0 then VoBufferImageRelease(FBufferImageFilter);
  if FInspectionFilter <> 0 then VoInspectionFreeImageData(FInspectionFilter);
end;

function TInspector.Inspect(AChNo : Integer): Boolean;
var
  I : Integer;
  hBufferView: VOHANDLE;
  hBufferSrc: VOHANDLE;
  hBufferImageSrc: VOHANDLE;
  hInspectionSrc: VOHANDLE;

begin
  if AChNo = -1 then
  begin
    hBufferView:= FBufferView;
    hBufferSrc:= FBufferSrc;
    hBufferImageSrc:= FBufferImageSrc;
    hInspectionSrc:= FInspectionSrc;
  end
  else
  begin
    hBufferView:= gInspector[AChNo].hBufferView;
    hBufferSrc:= gInspector[AChNo].hBufferSrc;
    hBufferImageSrc:= gInspector[AChNo].hBufferImageSrc;
    hInspectionSrc:= gInspector[AChNo].hInspectionSrc;
  end;
  Result := True;

  for I := 0 to FMeasureAlgorithms.Count-1 do
  begin
    if FMeasureAlgorithms[I].ChNo = AChNo then
    begin
      FMeasureAlgorithms[I].BufferView := hBufferView;
      FMeasureAlgorithms[I].BufferSrc := hBufferSrc;
      FMeasureAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FMeasureAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FMeasureAlgorithms[I].Inspect then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FBlobAlgorithms.Count-1 do
  begin
    if FBlobAlgorithms[I].ChNo = AChNo then
    begin
      FBlobAlgorithms[I].BufferView := hBufferView;
      FBlobAlgorithms[I].BufferSrc := hBufferSrc;
      FBlobAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FBlobAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FBlobAlgorithms[I].Inspect then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FGSearchAlgorithms.Count-1 do
  begin
    if FGSearchAlgorithms[I].ChNo = AChNo then
    begin
      FGSearchAlgorithms[I].BufferView := hBufferView;
      FGSearchAlgorithms[I].BufferSrc := hBufferSrc;
      FGSearchAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FGSearchAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FGSearchAlgorithms[I].Inspect then
      begin
        Result := False;
      end;
    end;
  end;

  for I := 0 to FMeasCornerAlgorithms.Count-1 do
  begin
    if FMeasCornerAlgorithms[I].ChNo = AChNo then
    begin
      FMeasCornerAlgorithms[I].BufferView := hBufferView;
      FMeasCornerAlgorithms[I].BufferSrc := hBufferSrc;
      FMeasCornerAlgorithms[I].BufferImageSrc := hBufferImageSrc;
      FMeasCornerAlgorithms[I].InspectionSrc := hInspectionSrc;

      if not FMeasCornerAlgorithms[I].Inspect then
      begin
        Result := False;
      end;
    end;
  end;

end;

procedure TInspector.Draw(ASender: TObject; ACanvas: TCanvas; AChNo : Integer);
var
  I : Integer;
begin
  for I := 0 to FMeasureAlgorithms.Count-1 do
  begin
    if FMeasureAlgorithms[I].ChNo = AChNo then
    begin
      FMeasureAlgorithms[I].Draw(ASender, ACanvas);
    end;
  end;

  for I := 0 to FBlobAlgorithms.Count-1 do
  begin
    if FBlobAlgorithms[I].ChNo = AChNo then
    begin
      FBlobAlgorithms[I].Draw(ASender, ACanvas);
    end;
  end;

  for I := 0 to FGSearchAlgorithms.Count-1 do
  begin
    if FGSearchAlgorithms[I].ChNo = AChNo then
    begin
      FGSearchAlgorithms[I].Draw(ASender, ACanvas);
    end;
  end;

  for I := 0 to FMeasCornerAlgorithms.Count-1 do
  begin
    if FMeasCornerAlgorithms[I].ChNo = AChNo then
    begin
      FMeasCornerAlgorithms[I].Draw(ASender, ACanvas);
    end;
  end;
end;

procedure TInspector.LoadFormFile(AFileName: String);
begin
  foObjectFromXmlFile(Self, AFileName);
end;

procedure TInspector.SaveToFile(AFileName: String);
begin
  foObjectToXmlFile(Self, AFileName);
end;

procedure TInspector.SetBlobAlgorithms(const Value: TBlobAlgorithms);
begin
  FBlobAlgorithms.Assign(Value);
end;

procedure TInspector.SetGSearchAlgorithms(const Value: TGSearchAlgorithms);
begin
  FGSearchAlgorithms.Assign(Value);
end;

procedure TInspector.SetMeasCornerAlgorithms(const Value: TMeasCornerAlgorithms);
begin
  FMeasCornerAlgorithms.Assign(Value);
end;

procedure TInspector.SetMeasureAlgorithms(const Value: TMeasureAlgorithms);
begin
  FMeasureAlgorithms.Assign(Value);
end;

procedure TInspector.LoadInspItemsFromJob(AJobServer : TfoDataServer);
var
  nNo, i, n: Integer;
  szTemp: String;
  slTemp: TStrings;
begin
  slTemp := TStringList.Create;
  Try
    gResultDataCount := 0;
    for nNo := 0 to MAX_VISION_COUNT - 1 do
    begin
      gInspCounts[nNo] := AJobServer.AsInteger[Format('V%d_INSP_COUNT', [nNo + 1])];
      for i := 0 to gInspCounts[nNo] - 1 do
      begin
        gInspItems[nNo, i].nInspNo := AJobServer.AsInteger[Format('V%dI%.2d_INSP_NO', [nNo + 1, i + 1])];
        gInspItems[nNo, i].bUse := AJobServer.AsBoolean[Format('V%dI%.2d_USE', [nNo + 1, i + 1])];
        gInspItems[nNo, i].bDispData := AJobServer.AsBoolean[Format('V%dI%.2d_DISP_DATA', [nNo + 1, i + 1])];
        gInspItems[nNo, i].szName := AJobServer.AsString[Format('V%dI%.2d_NAME', [nNo + 1, i + 1])];
        gInspItems[nNo, i].InspAlgoritm := TInspAlgoritm(AJobServer.AsInteger[Format('V%dI%.2d_ALGORITHM_NO',[nNo + 1, i + 1])]);

        szTemp := AJobServer.AsString[Format('V%dI%.2d_MODELS', [nNo + 1, i + 1])];
        foSplitWord(szTemp, [','], slTemp);
        gInspItems[nNo, i].nModelCount := slTemp.Count;
        for n := 0 to slTemp.Count - 1 do
        begin
          gInspItems[nNo, i].AModelNo[n] := StrToIntDef(slTemp[n], 0);
        end;

        szTemp := AJobServer.AsString[Format('V%dI%.2d_REF_CAMS', [nNo + 1, i + 1])];
        foSplitWord(szTemp, [','], slTemp);
        gInspItems[nNo, i].nRefCamCount := slTemp.Count;
        for n := 0 to slTemp.Count - 1 do
        begin
          gInspItems[nNo, i].ARefCamNo[n] := StrToIntDef(slTemp[n], 0);
        end;

        szTemp := AJobServer.AsString[Format('V%dI%.2d_REF_ITEMS', [nNo + 1, i + 1])];
        foSplitWord(szTemp, [','], slTemp);
        gInspItems[nNo, i].nRefItemCount := slTemp.Count;
        for n := 0 to slTemp.Count - 1 do
        begin
          gInspItems[nNo, i].ARefItemNo[n] := StrToIntDef(slTemp[n], 0);
        end;

        gInspItems[nNo, i].dSpecMin := AJobServer.AsDouble[Format('V%dI%.2d_SPEC_MIN', [nNo + 1, i + 1])];
        gInspItems[nNo, i].dSpecMax := AJobServer.AsDouble[Format('V%dI%.2d_SPEC_MAX', [nNo + 1, i + 1])];

        gInspItems[nNo, i].dCorr := AJobServer.AsDouble[Format('V%dI%.2d_CORR', [nNo + 1, i + 1])];
        gInspItems[nNo, i].dOffset := AJobServer.AsDouble[Format('V%dI%.2d_OFFSET', [nNo + 1, i + 1])];
        gInspItems[nNo, i].nBinNo := AJobServer.AsInteger[Format('V%dI%.2d_BIN_NO', [nNo + 1, i + 1])];

        gInspItems[nNo, i].dTargetX := AJobServer.AsDouble[Format('V%dI%.2d_TARGET_X', [nNo + 1, i + 1])];
        gInspItems[nNo, i].dTargetY := AJobServer.AsDouble[Format('V%dI%.2d_TARGET_Y', [nNo + 1, i + 1])];


        if gInspItems[nNo, i].bUse and gInspItems[nNo, i].bDispData then
        begin
          gResultData[gResultDataCount].szItemInform := Format('%s',[gInspItems[nNo, i].szName]);
          Inc(gResultDataCount);
        end;
      end;
    end;

    Equipment.BroadcastMessage(UM_REPORT_SETUP, 0, 0);
    Equipment.BroadcastMessage(UM_REPORT_UPDATE, 0, 0);

  Finally
    slTemp.Free;
  End;
end;

procedure TInspector.OpenImage(szFileName: AnsiString);
var
  imgTemp: TImage;
  nWidth, nHeight: Integer;
begin
  // Check Image Width, Height
  if FileExists(szFileName) then
  begin
    imgTemp := TImage.Create(nil);
    imgTemp.Picture.LoadFromFile(szFileName);
    nWidth := imgTemp.Picture.Width;
    nHeight := imgTemp.Picture.Height;
    imgTemp.Free;

    InitializeVision(nWidth, nHeight);
    VoInspectionLoadFromFile(PAnsiChar(szFileName), 0, FInspectionSrc);
  end;
end;

procedure TInspector.SaveInspItemsToJob(AJobServer : TfoDataServer);
var
  nNo, i, n: Integer;
  szTemp: String;
  slTemp: TStrings;
begin
  slTemp := TStringList.Create;
  try
    for nNo := 0 to MAX_VISION_COUNT - 1 do
    begin
      AJobServer.AsInteger[Format('V%d_INSP_COUNT', [nNo + 1])] := gInspCounts[nNo];
      for i := 0 to gInspCounts[nNo] - 1 do
      begin
        AJobServer.AsInteger[Format('V%dI%.2d_INSP_NO', [nNo + 1, i + 1])] := gInspItems[nNo, i].nInspNo;
        AJobServer.AsBoolean[Format('V%dI%.2d_USE', [nNo + 1, i + 1])] := gInspItems[nNo, i].bUse;
        AJobServer.AsBoolean[Format('V%dI%.2d_DISP_DATA', [nNo + 1, i + 1])] := gInspItems[nNo, i].bDispData;
        AJobServer.AsString[Format('V%dI%.2d_NAME', [nNo + 1, i + 1])] := gInspItems[nNo, i].szName;
        AJobServer.AsInteger[Format('V%dI%.2d_ALGORITHM_NO', [nNo + 1, i + 1])] := Ord(gInspItems[nNo, i].InspAlgoritm);

        szTemp := '';
        if gInspItems[nNo, i].nModelCount > 0 then
        begin
          for n := 0 to gInspItems[nNo, i].nModelCount - 2 do
          begin
            szTemp := szTemp + IntToStr(gInspItems[nNo, i].AModelNo[n]) + ',';
          end;
          szTemp := szTemp + IntToStr(gInspItems[nNo, i].AModelNo[gInspItems[nNo, i].nModelCount - 1]);
        end;
        AJobServer.AsString[Format('V%dI%.2d_MODELS', [nNo + 1, i + 1])] := szTemp;

        szTemp := '';
        if gInspItems[nNo, i].nRefCamCount > 0 then
        begin
          for n := 0 to gInspItems[nNo, i].nRefCamCount - 2 do
          begin
            szTemp := szTemp + IntToStr(gInspItems[nNo, i].ARefCamNo[n]) + ',';
          end;
          szTemp := szTemp + IntToStr(gInspItems[nNo, i].ARefCamNo[gInspItems[nNo, i].nRefCamCount - 1]);
        end;
        AJobServer.AsString[Format('V%dI%.2d_REF_ITEMS', [nNo + 1, i + 1])] := szTemp;


        szTemp := '';
        if gInspItems[nNo, i].nRefItemCount > 0 then
        begin
          for n := 0 to gInspItems[nNo, i].nRefItemCount - 2 do
          begin
            szTemp := szTemp + IntToStr(gInspItems[nNo, i].ARefItemNo[n]) + ',';
          end;
          szTemp := szTemp + IntToStr(gInspItems[nNo, i].ARefItemNo[gInspItems[nNo, i].nRefItemCount - 1]);
        end;

        AJobServer.AsString[Format('V%dI%.2d_REF_ITEMS', [nNo + 1, i + 1])] := szTemp;
        AJobServer.AsDouble[Format('V%dI%.2d_SPEC_MIN', [nNo + 1, i + 1])] := gInspItems[nNo, i].dSpecMin;
        AJobServer.AsDouble[Format('V%dI%.2d_SPEC_MAX', [nNo + 1, i + 1])] := gInspItems[nNo, i].dSpecMax;
        AJobServer.AsDouble[Format('V%dI%.2d_CORR', [nNo + 1, i + 1])] := gInspItems[nNo, i].dCorr;
        AJobServer.AsDouble[Format('V%dI%.2d_OFFSET', [nNo + 1, i + 1])] := gInspItems[nNo, i].dOffset;
        AJobServer.AsInteger[Format('V%dI%.2d_BIN_NO', [nNo + 1, i + 1])] := gInspItems[nNo, i].nBinNo;
        AJobServer.AsDouble[Format('V%dI%.2d_TARGET_X', [nNo + 1, i + 1])] := gInspItems[nNo, i].dTargetX;
        AJobServer.AsDouble[Format('V%dI%.2d_TARGET_Y', [nNo + 1, i + 1])] := gInspItems[nNo, i].dTargetY;
      end;
    end;
  Finally
    slTemp.Free;
  End;
end;

function TInspector.InspItems(nChNo: Integer; nInspNo: Integer): Boolean;
var
  i, n: Integer;
  nMNo1, nMNo2, nMNo3, nMNo4: Integer;
  nRNo1, nRNo2: Integer;
  nVNo1, nVNo2: Integer;
  nIndex : Integer;

  GSearchAlgorithm : TGSearchAlgorithm;
  MeasureAlgorithm : TMeasureAlgorithm;
  BlobAlgorithm : TBlobAlgorithm;
  MeasCornerAlgorithm : TMeasCornerAlgorithm;

  AP: array [0 .. 10] of TDoublePoint;

  X, Y: Double;
  RX1, RY1, RX2, RY2, RX3, RY3, RX4, RY4: Double;
  bResult: Boolean;
  DX, DY, DA, CX, CY, dLength: Double;
  DA1, DA2, DA3, DA4: Double;
  dScale: Double;

begin
  gInspector[nChNo].nResultCount := 0;

  gInspector[nChNo].dSearchX := 0;
  gInspector[nChNo].dSearchY := 0;

  gInspector[nChNo].dSearchDX := 0;
  gInspector[nChNo].dSearchDY := 0;
  gInspector[nChNo].dSearchDT := 0;
  gInspector[nChNo].dSearchCX := 0;
  gInspector[nChNo].dSearchCY := 0;
  gInspector[nChNo].nCurrInspNo := nInspNo;

  for i := 0 to gInspCounts[nChNo] - 1 do
  begin
    if not gInspItems[nChNo, i].bUse then
    begin
      gInspItems[nChNo, i].bResult := True;
      gInspItems[nChNo, i].dResultValue := 0;
      gInspItems[nChNo, i].dResultX := 0;
      gInspItems[nChNo, i].dResultY := 0;

      Continue;
    end;

    if gInspItems[nChNo, i].nInspNo <> nInspNo then Continue;

    gInspItems[nChNo, i].bResult := False;
    gInspItems[nChNo, i].dResultValue := 0;
    gInspItems[nChNo, i].dResultX := 0;
    gInspItems[nChNo, i].dResultY := 0;

    // Calc Ref Offset.
    DX := 0;
    DY := 0;
    DA := 0;
    CX := 0;
    CY := 0;
    if gInspItems[nChNo, i].nRefItemCount = 1 then
    begin
      nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];

      if gInspItems[nChNo, nRNo1].bResult then
      begin
        DX := gInspItems[nChNo, nRNo1].dResultX - gInspItems[nChNo, nRNo1].dTargetX;
        DY := gInspItems[nChNo, nRNo1].dResultY - gInspItems[nChNo, nRNo1].dTargetY;
        DA := 0;
        CX := gInspItems[nChNo, nRNo1].dResultX;
        CY := gInspItems[nChNo, nRNo1].dResultY;
      end;
    end
    else if gInspItems[nChNo, i].nRefItemCount = 2 then
    begin
      nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
      nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

      if gInspItems[nChNo, nRNo1].bResult and gInspItems[nChNo, nRNo2].bResult
      then
      begin
        GetOffsetAngle(gInspItems[nChNo, nRNo1].dResultX,
          gInspItems[nChNo, nRNo1].dResultY,
          gInspItems[nChNo, nRNo2].dResultX,
          gInspItems[nChNo, nRNo2].dResultY,
          gInspItems[nChNo, nRNo1].dTargetX,
          gInspItems[nChNo, nRNo1].dTargetY,
          gInspItems[nChNo, nRNo2].dTargetX,
          gInspItems[nChNo, nRNo2].dTargetY, DX, DY, DA);

        CX := (gInspItems[nChNo, nRNo1].dResultX + gInspItems[nChNo, nRNo2].dResultX) / 2;
        CY := (gInspItems[nChNo, nRNo1].dResultY + gInspItems[nChNo, nRNo2].dResultY) / 2;
      end;
    end;

    case gInspItems[nChNo, i].InspAlgoritm of
      iaGSearch:
      begin
        if gInspItems[nChNo, i].nModelCount <> 1 then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Count Error %d', [nChNo + 1, i + 1, gInspItems[nChNo, i].nModelCount]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nMNo1 := gInspItems[nChNo, i].AModelNo[0];
        if gModelInfos[nChNo, nMNo1].InspAlgoritm <> iaGSearch then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Kind Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nIndex := gModelInfos[nChNo, nMNo1].AlgoritmIndex;
        if nIndex >= Inspector.FGSearchAlgorithms.Count then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model No Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        GSearchAlgorithm := Inspector.FGSearchAlgorithms[nIndex];
        GSearchAlgorithm.OffsetX := DX;
        GSearchAlgorithm.OffsetY := DY;
        GSearchAlgorithm.OffsetT := DA;
        GSearchAlgorithm.OffsetCX := CX;
        GSearchAlgorithm.OffsetCY := CY;

        Inspector.Inspect(nChNo, nMNo1);

        gInspItems[nChNo, i].dResultValue := GSearchAlgorithm.ResultScore;
        gInspItems[nChNo, i].dResultX := GSearchAlgorithm.ResultX;
        gInspItems[nChNo, i].dResultY := GSearchAlgorithm.ResultY;

        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) and
          (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasure:
      begin
        if gInspItems[nChNo, i].nModelCount <> 1 then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Count Error %d', [nChNo + 1, i + 1, gInspItems[nChNo, i].nModelCount]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nMNo1 := gInspItems[nChNo, i].AModelNo[0];
        if gModelInfos[nChNo, nMNo1].InspAlgoritm <> iaMeasure then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Kind Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nIndex := gModelInfos[nChNo, nMNo1].AlgoritmIndex;
        if nIndex >= Inspector.FMeasureAlgorithms.Count then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model No Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        MeasureAlgorithm := Inspector.FMeasureAlgorithms[nIndex];
        MeasureAlgorithm.OffsetX := DX;
        MeasureAlgorithm.OffsetY := DY;
        MeasureAlgorithm.OffsetT := DA;
        MeasureAlgorithm.OffsetCX := CX;
        MeasureAlgorithm.OffsetCY := CY;

        Inspect(nChNo, nMNo1);

        gInspItems[nChNo, i].dResultValue := MeasureAlgorithm.ResultScore;
        gInspItems[nChNo, i].dResultX := MeasureAlgorithm.ResultX;
        gInspItems[nChNo, i].dResultY := MeasureAlgorithm.ResultY;

        gInspItems[nChNo, i].dResultA := MeasureAlgorithm.MeasLineA;
        gInspItems[nChNo, i].dResultB := MeasureAlgorithm.MeasLineB;
        gInspItems[nChNo, i].dResultC := MeasureAlgorithm.MeasLineC;

        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo,i].dSpecMin) and
          (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo,i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaCircle:
      begin
      end;

      iaBlob:
      begin
        if gInspItems[nChNo, i].nModelCount < 0 then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Count Error %d', [nChNo + 1, i + 1, gInspItems[nChNo, i].nModelCount]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        gInspItems[nChNo, i].dResultValue := 1;
        gInspItems[nChNo, i].bResult := True;

        for n := 0 to gInspItems[nChNo, i].nModelCount - 1 do
        begin
          nMNo1 := gInspItems[nChNo, i].AModelNo[n];
          if gModelInfos[nChNo, nMNo1].InspAlgoritm <> iaBlob then
          begin
            Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Kind Error', [nChNo + 1, i + 1]), [ldLogViewer]);
            gInspItems[nChNo, i].bResult := False;
            gInspector[nChNo].bResult := False;
            Continue;
          end;

          nIndex := gModelInfos[nChNo, nMNo1].AlgoritmIndex;
          if nIndex >= Inspector.FBlobAlgorithms.Count then
          begin
            Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model No Error', [nChNo + 1, i + 1]), [ldLogViewer]);
            gInspItems[nChNo, i].bResult := False;
            gInspector[nChNo].bResult := False;
            Continue;
          end;

          BlobAlgorithm := Inspector.FBlobAlgorithms[nIndex];
          BlobAlgorithm.OffsetX := DX;
          BlobAlgorithm.OffsetY := DY;
          BlobAlgorithm.OffsetT := DA;
          BlobAlgorithm.OffsetCX := CX;
          BlobAlgorithm.OffsetCY := CY;

          Inspect(nChNo, nMNo1);

          gInspItems[nChNo, i].dResultX := BlobAlgorithm.ResultX;
          gInspItems[nChNo, i].dResultY := BlobAlgorithm.ResultY;

          if not BlobAlgorithm.Result then
          begin
            Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Mdl[%d] Value=%.3f (%.3f ~ %.3f)',
              [nChNo + 1, i + 1, nMNo1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]), [ldLogViewer]);
            gInspItems[nChNo, i].dResultValue := 0;
            gInspItems[nChNo, i].bResult := False;
            gInspector[nChNo].bResult := False;
          end;
        end;
      end;

      iaDetect :
      begin
        gInspItems[nChNo, i].bResult := False;
        gInspector[nChNo].bResult := False;
      end;
      iaSearchCircle :
      begin
        gInspItems[nChNo, i].bResult := False;
        gInspector[nChNo].bResult := False;
      end;
      iaSearchRect :
      begin
        gInspItems[nChNo, i].bResult := False;
        gInspector[nChNo].bResult := False;
      end;
      iaMeasCorner :
      begin
        if gInspItems[nChNo, i].nModelCount <> 1 then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Count Error %d', [nChNo + 1, i + 1, gInspItems[nChNo, i].nModelCount]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nMNo1 := gInspItems[nChNo, i].AModelNo[0];
        if gModelInfos[nChNo, nMNo1].InspAlgoritm <> iaMeasCorner then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model Kind Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nIndex := gModelInfos[nChNo, nMNo1].AlgoritmIndex;
        if nIndex >= Inspector.MeasCornerAlgorithms.Count then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Model No Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        MeasCornerAlgorithm := Inspector.MeasCornerAlgorithms[nIndex];
        MeasCornerAlgorithm.OffsetX := DX;
        MeasCornerAlgorithm.OffsetY := DY;
        MeasCornerAlgorithm.OffsetT := DA;
        MeasCornerAlgorithm.OffsetCX := CX;
        MeasCornerAlgorithm.OffsetCY := CY;

        Inspector.Inspect(nChNo, nMNo1);

        gInspItems[nChNo, i].dResultX := MeasCornerAlgorithm.ResultX;
        gInspItems[nChNo, i].dResultY := MeasCornerAlgorithm.ResultY;
        gInspItems[nChNo, i].bResult := MeasCornerAlgorithm.Result;

        if not gInspItems[nChNo, i].bResult then
        begin
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasPos :
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 1) and (gInspItems[nChNo, i].nRefCamCount <> 1) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];

        if not gInspItems[nVNo1, nRNo1].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        gInspItems[nChNo, i].dResultX := gInspItems[nVNo1, nRNo1].dResultX;
        gInspItems[nChNo, i].dResultX := (gInspItems[nChNo, i].dResultX * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset;

        gInspItems[nChNo, i].dResultY := gInspItems[nVNo1, nRNo1].dResultY;
        gInspItems[nChNo, i].dResultY := (gInspItems[nChNo, i].dResultY * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset;

        gInspItems[nChNo, i].dResultValue := 1;

        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) and
           (gInspItems[nChNo, i].dResultValue < gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasPosXToPosX :
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 2) and (gInspItems[nChNo, i].nRefCamCount <> 2) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];
        nVNo2 := gInspItems[nChNo, i].ARefCamNo[1];

        if not gInspItems[nVNo1, nRNo1].bResult or not gInspItems[nVNo2, nRNo2].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        gInspItems[nChNo, i].dResultValue := gInspItems[nVNo1, nRNo1].dResultX - gInspItems[nVNo2, nRNo2].dResultX;
        gInspItems[nChNo, i].dResultValue := (gInspItems[nChNo, i].dResultValue * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset +
            Abs(gInspector[nVNo1].dCamPosX - gInspector[nVNo2].dCamPosX);


        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) and
           (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasPosYToPosY :
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 2) and (gInspItems[nChNo, i].nRefCamCount <> 2) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];
        nVNo2 := gInspItems[nChNo, i].ARefCamNo[1];

        if not gInspItems[nVNo1, nRNo1].bResult or not gInspItems[nVNo2, nRNo2].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        gInspItems[nChNo, i].dResultValue := gInspItems[nVNo1, nRNo1].dResultY - gInspItems[nVNo2, nRNo2].dResultY;
        gInspItems[nChNo, i].dResultValue := (gInspItems[nChNo, i].dResultValue * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset +
            Abs(gInspector[nVNo1].dCamPosY - gInspector[nVNo2].dCamPosY);


        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) and
           (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasPosToPos:
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 2) and (gInspItems[nChNo, i].nRefCamCount <> 2) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];
        nVNo2 := gInspItems[nChNo, i].ARefCamNo[1];

        if not gInspItems[nVNo1, nRNo1].bResult or not gInspItems[nVNo2, nRNo2].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        RX1 := gInspItems[nVNo1, nRNo1].dResultX + gInspector[nVNo1].dCamPosX;
        RY1 := gInspItems[nVNo1, nRNo1].dResultY + gInspector[nVNo1].dCamPosY;
        RX2 := gInspItems[nVNo1, nRNo2].dResultX + gInspector[nVNo2].dCamPosX;
        RY2 := gInspItems[nVNo1, nRNo2].dResultY + gInspector[nVNo2].dCamPosY;

        gInspItems[nChNo, i].dResultValue := GetLineLength(RX1, RY1, RX2, RY2);

        gInspItems[nChNo, i].dResultValue := (gInspItems[nChNo, i].dResultValue * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset;
        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) or
           (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasLineToPos:
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 2) and (gInspItems[nChNo, i].nRefCamCount <> 2) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];
        nVNo2 := gInspItems[nChNo, i].ARefCamNo[1];

        if not gInspItems[nVNo1, nRNo1].bResult or not gInspItems[nVNo2, nRNo2].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        gInspItems[nChNo, i].dResultValue := GetLineToPos(
            gInspItems[nVNo1, nRNo1].dResultA, gInspItems[nVNo1, nRNo1].dResultB, gInspItems[nVNo1, nRNo1].dResultC,
            gInspItems[nVNo2, nRNo2].dResultX, gInspItems[nVNo2, nRNo2].dResultY);

        gInspItems[nChNo, i].dResultValue := (gInspItems[nChNo, i].dResultValue * gInspItems[nChNo, i].dCorr) + gInspItems[nChNo, i].dOffset;
        if (gInspItems[nChNo, i].dResultValue >= gInspItems[nChNo, i].dSpecMin) and
           (gInspItems[nChNo, i].dResultValue <= gInspItems[nChNo, i].dSpecMax) then
        begin
          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] Value=%.3f (%.3f ~ %.3f)',
            [nChNo + 1, i + 1, gInspItems[nChNo, i].dResultValue, gInspItems[nChNo, i].dSpecMin, gInspItems[nChNo, i].dSpecMax]
            ), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;
      end;

      iaMeasLineCrossPos:
      begin
        if (gInspItems[nChNo, i].nRefItemCount <> 2) and (gInspItems[nChNo, i].nRefCamCount <> 2) then
        begin
          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem & RefCam Count Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        nRNo1 := gInspItems[nChNo, i].ARefItemNo[0];
        nRNo2 := gInspItems[nChNo, i].ARefItemNo[1];

        nVNo1 := gInspItems[nChNo, i].ARefCamNo[0];
        nVNo2 := gInspItems[nChNo, i].ARefCamNo[1];

        if not gInspItems[nVNo1, nRNo1].bResult or not gInspItems[nVNo2, nRNo2].bResult then
        begin
          gInspItems[nChNo, i].dResultX := 0;
          gInspItems[nChNo, i].dResultY := 0;
          gInspItems[nChNo, i].dResultValue := 0;

          Logger.FireLog(ltError, Format('CH=%d, Insp[%d] RefItem Result Error', [nChNo + 1, i + 1]), [ldLogViewer]);
          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
          Continue;
        end;

        if VoGetLineIntersection( gInspItems[nVNo1, nRNo1].dResultA,
          gInspItems[nVNo1, nRNo1].dResultB,
          gInspItems[nVNo1, nRNo1].dResultC,
          gInspItems[nVNo2, nRNo2].dResultA,
          gInspItems[nVNo2, nRNo2].dResultB,
          gInspItems[nVNo2, nRNo2].dResultC, DX, DY) = VO_OK then
        begin
          gInspItems[nChNo, i].dResultX := DX;
          gInspItems[nChNo, i].dResultY := DY;

          gInspItems[nChNo, i].bResult := True;
        end
        else
        begin
          gInspItems[nChNo, i].dResultX := DX;
          gInspItems[nChNo, i].dResultY := DY;

          gInspItems[nChNo, i].bResult := False;
          gInspector[nChNo].bResult := False;
        end;

      end;

    end;
  end;

  Result := gInspector[nChNo].bResult;
end;




initialization


finalization
  if Assigned(_Instance) then _Instance.Free;


end.
