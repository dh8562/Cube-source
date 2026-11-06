unit frameJog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  AppEvnts,
  Menus,
  Mask,
  ImgList,
  StdCtrls,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,

  foButton,
  foMotion,
  foEdit,
  foButtonEdit,

  fNumericKBD,
  dmMachine,
  dmHAL,
  uEquipmentTypes;

type
  TJogFrameGetStepMoveEvent = procedure(Sender : TObject; var AValue : Boolean) of object;
  TJogFrameGetStepDistanceEvent = procedure(Sender : TObject; var AValue : Double) of object;

  TXYJogFrame = class(TFrame)
    btnJogBwd: TcxButton;
    btnJogFwd: TcxButton;
    btnJogLeft: TcxButton;
    btnJogRight: TcxButton;
    btnLeftTop: TcxButton;
    btnLeftBottom: TcxButton;
    btnRightBottom: TcxButton;
    btnRightTop: TcxButton;
    ilStageMove: TcxImageList;
    ApplicationEvents: TApplicationEvents;
    btnJogVelLow: TfoLEDBtn;
    btnJogVelMid: TfoLEDBtn;
    btnJogVelHigh: TfoLEDBtn;
    btnJogStepMove: TfoLEDBtn;
    feStepPos: TfoLabeledButtonNumberEdit;
    btn1mm: TcxButton;
    btn10mm: TcxButton;
    btn100mm: TcxButton;
    btn100um: TcxButton;
    btn10um: TcxButton;
    btn1um: TcxButton;
    btnRotateLeft: TcxButton;
    btnRotateRight: TcxButton;
    procedure btnLeftTopClick(Sender: TObject);
    procedure btnJogBwdClick(Sender: TObject);
    procedure btnRightTopClick(Sender: TObject);
    procedure btnJogLeftClick(Sender: TObject);
    procedure btnJogRightClick(Sender: TObject);
    procedure btnLeftBottomClick(Sender: TObject);
    procedure btnJogFwdClick(Sender: TObject);
    procedure btnRightBottomClick(Sender: TObject);
    procedure JogMouseLeave(Sender: TObject);
    procedure JogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLeftTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnJogBwdMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRightTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnJogLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnJogRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLeftBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnJogFwdMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRightBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure btnJogStepMoveClick(Sender: TObject);
    procedure JogVelClick(Sender: TObject);
    procedure StepDistancePresetClick(Sender: TObject);
    procedure feStepPosButtonClick(Sender: TObject);
    procedure btnRotateLeftClick(Sender: TObject);
    procedure btnRotateRightClick(Sender: TObject);
    procedure btnRotateLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRotateRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FAxisX: TfoCustomaxis;
    FAxisY: TfoCustomaxis;
    FAxisT: TfoCustomaxis;
    FReverseX: Boolean;
    FOnGetAxis: TNotifyEvent;
    FReverseT: Boolean;
    FReverseY: Boolean;
    { Private declarations }
  public
    { Public declarations }
    function GetStepMove : Boolean;
    function GetStepDistance : Double;
    procedure GetAxis;
    function GetXDirectionCCW : TfoAxisDirection;
    function GetXDirectionCW : TfoAxisDirection;
    function GetXStepDistance : Double;
    function GetYDirectionCCW : TfoAxisDirection;
    function GetYDirectionCW : TfoAxisDirection;
    function GetYStepDistance : Double;
    function GetTDirectionCCW : TfoAxisDirection;
    function GetTDirectionCW : TfoAxisDirection;
    function GetTStepDistance : Double;
  published
    property AxisX : TfoCustomaxis read FAxisX write FAxisX;
    property AxisY : TfoCustomaxis read FAxisY write FAxisY;
    property AxisT : TfoCustomaxis read FAxisT write FAxisT;
    property ReverseX : Boolean read FReverseX write FReverseX;
    property ReverseY : Boolean read FReverseY write FReverseY;
    property ReverseT : Boolean read FReverseT write FReverseT;

    property OnGetAxis : TNotifyEvent read FOnGetAxis write FOnGetAxis;
  end;

implementation

{$R *.dfm}

procedure TXYJogFrame.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  btnJogBwd.Enabled := (Machine.AutoMode = amIdle);
  btnJogFwd.Enabled := (Machine.AutoMode = amIdle);
  btnJogLeft.Enabled := (Machine.AutoMode = amIdle);
  btnJogRight.Enabled := (Machine.AutoMode = amIdle);
  btnLeftTop.Enabled := (Machine.AutoMode = amIdle);
  btnLeftBottom.Enabled := (Machine.AutoMode = amIdle);
  btnRightTop.Enabled := (Machine.AutoMode = amIdle);
  btnRightBottom.Enabled := (Machine.AutoMode = amIdle);
  btnRotateLeft.Enabled := (Machine.AutoMode = amIdle);
  btnRotateRight.Enabled := (Machine.AutoMode = amIdle);
end;

procedure TXYJogFrame.btnJogBwdClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisY, -GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnJogBwdMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisY, GetYDirectionCCW);
  end;
end;

procedure TXYJogFrame.btnJogFwdClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisY, GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnJogFwdMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisY, GetYDirectionCW);
  end;
end;

procedure TXYJogFrame.btnJogLeftClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) then
  begin
    Machine.MoveAxisTo(AxisX, -GetXStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnJogLeftMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCCW);
  end;
end;

procedure TXYJogFrame.btnJogRightClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) then
  begin
    Machine.MoveAxisTo(AxisX, GetXStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnJogRightMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCW);
  end;
end;

procedure TXYJogFrame.btnJogStepMoveClick(Sender: TObject);
begin
  TfoLEDBtn(Sender).LED.Value := not TfoLEDBtn(Sender).LED.Value;
end;

procedure TXYJogFrame.btnLeftBottomClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisX, -GetXStepDistance, True, False);
    Machine.MoveAxisTo(AxisY, GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnLeftBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCCW);
    Machine.JogAxis(AxisY, GetYDirectionCW);
  end;
end;

procedure TXYJogFrame.btnLeftTopClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisX, -GetXStepDistance, True, False);
    Machine.MoveAxisTo(AxisY, -GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnLeftTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCCW);
    Machine.JogAxis(AxisY, GetYDirectionCCW);
  end;
end;

procedure TXYJogFrame.btnRightBottomClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisX, GetXStepDistance, True, False);
    Machine.MoveAxisTo(AxisY, GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnRightBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCW);
    Machine.JogAxis(AxisY, GetYDirectionCW);
  end;
end;

procedure TXYJogFrame.btnRightTopClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.MoveAxisTo(AxisX, GetXStepDistance, True, False);
    Machine.MoveAxisTo(AxisY, -GetYStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnRightTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisX) and Assigned(AxisY) then
  begin
    Machine.JogAxis(AxisX, GetXDirectionCW);
    Machine.JogAxis(AxisY, GetYDirectionCCW);
  end;
end;

procedure TXYJogFrame.btnRotateLeftClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisT) then
  begin
    Machine.MoveAxisTo(AxisT, -GetTStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnRotateLeftMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisT) then
  begin
    Machine.JogAxis(AxisT, GetXDirectionCCW);
  end;
end;

procedure TXYJogFrame.btnRotateRightClick(Sender: TObject);
begin
  GetAxis;
  if GetStepMove and Assigned(AxisT) then
  begin
    Machine.MoveAxisTo(AxisT, GetTStepDistance, True, False);
  end;
end;

procedure TXYJogFrame.btnRotateRightMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetAxis;
  if not GetStepMove and Assigned(AxisT) then
  begin
    Machine.JogAxis(AxisT, GetXDirectionCW);
  end;
end;

procedure TXYJogFrame.feStepPosButtonClick(Sender: TObject);
begin
  TfoButtonNumberEdit(Sender).Value := GetValueFromTouchKBD(
    TfoButtonNumberEdit(Sender).Value,
    TfoButtonNumberEdit(Sender).Min,
    TfoButtonNumberEdit(Sender).Max
  );
end;

procedure TXYJogFrame.GetAxis;
begin
  if Assigned(FOnGetAxis) then
    FOnGetAxis(Self);
end;

function TXYJogFrame.GetStepDistance: Double;
begin
  Result := feStepPos.Value;
end;

function TXYJogFrame.GetStepMove: Boolean;
begin
  Result := btnJogStepMove.LED.Value;
end;

function TXYJogFrame.GetTDirectionCCW: TfoAxisDirection;
begin
  if FReverseT then
    Result := adCW
  else
    Result := adCCW;
end;

function TXYJogFrame.GetTDirectionCW: TfoAxisDirection;
begin
  if FReverseT then
    Result := adCCW
  else
    Result := adCW;
end;

function TXYJogFrame.GetTStepDistance: Double;
begin
  if FReverseT then
    Result := -GetStepDistance
  else
    Result := GetStepDistance;
end;

function TXYJogFrame.GetXDirectionCCW: TfoAxisDirection;
begin
  if FReverseX then
    Result := adCW
  else
    Result := adCCW;
end;

function TXYJogFrame.GetXDirectionCW: TfoAxisDirection;
begin
  if FReverseX then
    Result := adCCW
  else
    Result := adCW;
end;

function TXYJogFrame.GetXStepDistance: Double;
begin
  if FReverseX then
    Result := -GetStepDistance
  else
    Result := GetStepDistance;
end;

function TXYJogFrame.GetYDirectionCCW: TfoAxisDirection;
begin
  if FReverseY then
    Result := adCW
  else
    Result := adCCW;
end;

function TXYJogFrame.GetYDirectionCW: TfoAxisDirection;
begin
  if FReverseY then
    Result := adCCW
  else
    Result := adCW;
end;

function TXYJogFrame.GetYStepDistance: Double;
begin
  if FReverseY then
    Result := -GetStepDistance
  else
    Result := GetStepDistance;
end;

procedure TXYJogFrame.JogMouseLeave(Sender: TObject);
begin
  if not GetStepMove then
  begin
    if Assigned(AxisX) then AxisX.Stop;
    if Assigned(AxisY) then AxisY.Stop;
    if Assigned(AxisT) then AxisT.Stop;
  end;
end;

procedure TXYJogFrame.JogMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not GetStepMove then
  begin
    if Assigned(AxisX) then AxisX.Stop;
    if Assigned(AxisY) then AxisY.Stop;
    if Assigned(AxisT) then AxisT.Stop;
  end;
end;

procedure TXYJogFrame.JogVelClick(Sender: TObject);
begin
  TfoLEDBtn(Sender).LED.Value := True;
  HAL.IOServer.AsBoolean['STAGE_JOG_VEL_LOW'] := False;
  HAL.IOServer.AsBoolean['STAGE_JOG_VEL_MID'] := False;
  HAL.IOServer.AsBoolean['STAGE_JOG_VEL_HIGH'] := False;
  TfoLEDBtn(Sender).ChannelLink.Channel.AsBoolean := True;
end;

procedure TXYJogFrame.StepDistancePresetClick(Sender: TObject);
begin
  feStepPos.Value := StrToFloatDef(TcxButton(Sender).Caption, 1);
  btnJogStepMove.LED.Value := True;
end;

end.
