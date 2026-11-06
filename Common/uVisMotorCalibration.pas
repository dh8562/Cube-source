unit uVisMotorCalibration;

interface

type
  TCalData = Record
    // XY Cal
    AX : Array [0..3, 0..8] of Double;
    AY : Array [0..3, 0..8] of Double;

    // Plus Angle
    APAX : Array [0..3, 0..9] of Double;
    APAY : Array [0..3, 0..9] of Double;

    // Minus Angle
    AMAX : Array [0..3, 0..9] of Double;
    AMAY : Array [0..3, 0..9] of Double;
  end;

function VisMotorSetCalibration(ch : Integer; nx : Integer; ny : Integer; startX : Double; startY : Double; dPitchX : Double; dPitchY : Double; method : Integer) : Integer; stdcall;
function VisMotorSetPoint(ch : Integer; nIndexX : Integer; nIndexY : Integer; x : Double; y : Double) : Integer; stdcall;
function VisMotorDoCalibration(ch : Integer) : Integer; stdcall;
function VisMotorGetRealPoint(ch : Integer; ix : Double; iy : Double; var wx : Double; var wy : Double) : Integer; stdcall;
function VisMotorSetAngleCalibration(ch : Integer; nx : Integer; StartPoint : Double; dAnglePitch : Double; method : Integer) : Integer; stdcall;
function VisMotorSetAnglePoint(ch : Integer; nIndex : Integer; dAngle : Double) : Integer; stdcall;
function VisMotorDoAngleCalibration(ch : Integer) : Integer; stdcall;
function VisMotorGetAngleRealPoint(ch : Integer; iAngle : Double; var wAngle : Double) : Integer; stdcall;
function VisTwoPointAngle(ch : Integer; dFirstX : Double; dFirstY : Double; dSecondX : Double; dSecondY : Double; dPitchX : Double; dPitchY : Double; var dIAngle : Double) : Integer; stdcall;
function VisAngleToPosition(dCenterX : Double; dCenterY : Double; dPosX : Double; dPosY : Double; dAngleTh : Double; var dResultPosX : Double; var dResultPosY : Double) : Integer; stdcall;
function VisGetCenterPoint(dPoint1X : Double; dPoint1Y : Double; dPoint2X : Double; dPoint2Y : Double; dPoint3X : Double; dPoint3Y : Double;var dCenterPointX : Double; var dCenterPointY : Double) : Integer; stdcall;

implementation

const
  DLL_NAME = 'VisMotorCalibration.dll';

function VisMotorSetCalibration; external DLL_NAME;
function VisMotorSetPoint; external DLL_NAME;
function VisMotorDoCalibration; external DLL_NAME;
function VisMotorGetRealPoint; external DLL_NAME;
function VisMotorSetAngleCalibration; external DLL_NAME;
function VisMotorSetAnglePoint; external DLL_NAME;
function VisMotorDoAngleCalibration; external DLL_NAME;
function VisMotorGetAngleRealPoint; external DLL_NAME;
function VisTwoPointAngle; external DLL_NAME;
function VisAngleToPosition; external DLL_NAME;
function VisGetCenterPoint; external DLL_NAME;

end.
