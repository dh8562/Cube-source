unit uAlignerHelper;

interface

uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  Graphics,
  Math;

type
  TfoHorzMoveDirection = (
    // -1 -> +1
    hmdLeftToRight,
    // +1 <- -1
    hmdRightToLeft
  );

  TfoVertMoveDirection = (
    // -1 -> +1
    vmdTopToBottom,
    // +1 <- -1
    vmdBottomToTop
  );

  TfoMovableTarget = (
    mtRobot,
    mtTarget
  );

  TfoAlignerHelper = class(TComponent)
  private
    FHorzMoveDirection: TfoHorzMoveDirection;
    FVertMoveDirection: TfoVertMoveDirection;
    FImageHeight: Integer;
    FImageWidth: Integer;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    constructor Destroy; override;
    function GetAlignOffsetX(const ATargetCenter : Double) : Double;
    function GetAlignOffsetY(const ATargetCenter : Double) : Double;
  published
    property ImageWidth : Integer read FImageWidth write FImageWidth default 640;
    property ImageHeight : Integer read FImageHeight write FImageHeight default 480;
    property HorzMoveDirection : TfoHorzMoveDirection read FHorzMoveDirection write FHorzMoveDirection;
    property VertMoveDirection : TfoVertMoveDirection read FVertMoveDirection write FVertMoveDirection;
    property HorzMoveDirection : TfoHorzMoveDirection read FHorzMoveDirection write FHorzMoveDirection;
    property VertMoveDirection : TfoVertMoveDirection read FVertMoveDirection write FVertMoveDirection;
  end;

implementation

{ TfoAlignerHelper }

constructor TfoAlignerHelper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHorzMoveDirection := hmdLeftToRight;
  FVertMoveDirection := vmdTopToBottom;
  FImageWidth := 640;
  FImageHeight := 480;
end;

constructor TfoAlignerHelper.Destroy;
begin
  inherited Destroy;
end;

function TfoAlignerHelper.GetAlignOffsetX(const ATargetCenter: Double): Double;
var
  ImageCenter : Double;
begin
  ImageCenter := FImageWidth / 2;
  Result := ATargetCenter - ImageCenter;

end;

function TfoAlignerHelper.GetAlignOffsetY(const ATargetCenter: Double): Double;
var
  ImageCenter : Double;
begin
  ImageCenter := FImageHeight / 2;
  Result := ATargetCenter - ImageCenter;

end;

end.
