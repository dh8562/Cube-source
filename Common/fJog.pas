unit fJog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons,
  StdCtrls,
  ExtCtrls,
  Mask,
  Menus,
  ImgList,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxButtons,

  foLED,
  foControls,
  foIndicator,
  foTimeCounter,
  foMotion,
  foButton,
  foEdit,
  foLabel,
  foButtonEdit,

  elMultiLanguage,

  fNumericKBD,
  uCommonUtils,
  uEquipmentUtils,
  uEquipment, System.ImageList, cxImageList;

type
  TfrmJog = class(TForm)
    panCommand: TGroupBox;
    panRel: TGroupBox;
    panStatus: TGroupBox;
    panAbs: TGroupBox;
    ledCWLimit: TfoLED;
    ledCCWLimit: TfoLED;
    ledOrigin: TfoLED;
    ledFault: TfoLED;
    ledMoving: TfoLED;
    ledHoming: TfoLED;
    ledInPosition: TfoLED;
    ledEncoderFault: TfoLED;
    ledSWPosLimit: TfoLED;
    ledSWNegLimit: TfoLED;
    ledPosError: TfoLED;
    ledMotionDone: TfoLED;
    lcCurPos: TfoLCDOdoMeter;
    panRepeatMode: TGroupBox;
    tmrRepeat: TTimer;
    lblRelPos: TfoLabel;
    lblAbsPos: TfoLabel;
    lblPos1: TfoLabel;
    lblPos2: TfoLabel;
    lblDelay: TfoLabel;
    fePos1: TfoNumberEdit;
    fePos2: TfoNumberEdit;
    feDelay: TfoNumberEdit;
    gbServo: TGroupBox;
    feRelPos: TfoButtonNumberEdit;
    feAbsPos: TfoButtonNumberEdit;
    btnSearchOrigin: TcxButton;
    btnCW: TcxButton;
    btnStop: TcxButton;
    btnCCW: TcxButton;
    btnReset: TcxButton;
    btnRelCW: TcxButton;
    btnRelCCW: TcxButton;
    btnAbsMove: TcxButton;
    btnStartRepeat: TcxButton;
    btnStopRepeat: TcxButton;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    btnShowBottom: TcxButton;
    btnServoOn: TcxButton;
    btnServoOff: TcxButton;
    ilJog: TcxImageList;
    ilButtonEdit: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchOriginClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnCCWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCCWMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCWMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRelCCWClick(Sender: TObject);
    procedure btnRelCWClick(Sender: TObject);
    procedure btnAbsMoveClick(Sender: TObject);
    procedure btnStartRepeatClick(Sender: TObject);
    procedure btnStopRepeatClick(Sender: TObject);
    procedure tmrRepeatTimer(Sender: TObject);
    procedure btnShowBottomClick(Sender: TObject);
    procedure btnServoOnClick(Sender: TObject);
    procedure btnServoOffClick(Sender: TObject);
    procedure PositionEditButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FormCaption : string;
    CCWCaption, CWCaption : string;
    Axis : TfoCustomAxis;
    LeadWidth : Integer;

    CW : Boolean;
    TC : TfoTimeCounter;

    OldAxisStatusChanged : TNotifyEvent;
    procedure AxisStatusChanged(Sender: TObject);
  end;

procedure ShowJogDialog(AAxis : TfoCustomAxis; ACaption, ACCWCaption, ACWCaption : string);
function JogPosition(AAxis : TfoCustomAxis; ACaption, ACCWCaption, ACWCaption : string; Position : Double) : Double;

implementation

{$R *.DFM}

procedure ShowJogDialog(AAxis: TfoCustomAxis; ACaption, ACCWCaption, ACWCaption: string);
var
  F : TfrmJog;
begin
  F := TfrmJog.Create(Application);
  try
    F.Axis := AAxis;
    F.FormCaption := ACaption;
    F.CCWCaption := ACCWCaption;
    F.CWCaption := ACWCaption;
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

function JogPosition(AAxis: TfoCustomAxis; ACaption, ACCWCaption, ACWCaption: string; Position: Double): Double;
var
  F : TfrmJog;
begin
  F := TfrmJog.Create(Application);
  try
    F.Axis := AAxis;
    F.FormCaption := ACaption;
    F.CCWCaption := ACCWCaption;
    F.CWCaption := ACWCaption;
    F.feAbsPos.Value := Position;
    if F.ShowModal = mrOK then
    begin
      Result := F.lcCurPos.Value;
    end
    else
      Result := Position;
  finally
    FreeAndNil(F);
  end;
end;

procedure TfrmJog.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  Axis := nil;
  CCWCaption := 'CCW';
  CWCaption := 'CW';
  CW := True;

  TC := TfoTimeCounter.Create;
end;

procedure TfrmJog.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TC);
end;

procedure TfrmJog.FormShow(Sender: TObject);
begin
  ApplySkinColor('UserSkin', Self);
  elApplyLanguage(Self);

  btnShowBottom.Visible := True;

  Caption := FormCaption;
  btnCCW.Caption := CCWCaption;
  btnRelCCW.Caption := CCWCaption;
  btnCW.Caption := CWCaption;
  btnRelCW.Caption := CWCaption;

  if Axis <> nil then
  begin
    OldAxisStatusChanged := Axis.OnStatusChanged;
    Axis.OnStatusChanged := AxisStatusChanged;

    if Length(Axis.ChannelPrefix) > 0 then
    begin
      ledCWLimit.ChannelLink.ChannelName := Axis.ChannelPrefix + 'CW';
      ledCCWLimit.ChannelLink.ChannelName := Axis.ChannelPrefix + 'CCW';
      ledOrigin.ChannelLink.ChannelName := Axis.ChannelPrefix + 'HOME';
      ledFault.ChannelLink.ChannelName := Axis.ChannelPrefix + 'FAULT';
      ledMoving.ChannelLink.ChannelName := Axis.ChannelPrefix + 'MOVING';
      ledHoming.ChannelLink.ChannelName := Axis.ChannelPrefix + 'HOMING';
      ledInPosition.ChannelLink.ChannelName := Axis.ChannelPrefix + 'INPOSITION';
      lcCurPos.ChannelLink.ChannelName := Axis.ChannelPrefix + 'POSITION';

      ledCWLimit.ChannelLink.DataServer := Equipment.IOServer;
      ledCCWLimit.ChannelLink.DataServer := Equipment.IOServer;
      ledOrigin.ChannelLink.DataServer := Equipment.IOServer;
      ledFault.ChannelLink.DataServer := Equipment.IOServer;
      ledMoving.ChannelLink.DataServer := Equipment.IOServer;
      ledHoming.ChannelLink.DataServer := Equipment.IOServer;
      ledInPosition.ChannelLink.DataServer := Equipment.IOServer;
      lcCurPos.ChannelLink.DataServer := Equipment.IOServer;
    end;
    Axis.Reset;
  end;
  AxisStatusChanged(nil);
end;

procedure TfrmJog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Axis.OnStatusChanged := OldAxisStatusChanged;
end;

procedure TfrmJog.btnSearchOriginClick(Sender: TObject);
begin
  if Axis <> nil then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.Origin(False);
  end;
end;

procedure TfrmJog.btnServoOffClick(Sender: TObject);
begin
  Axis.ServoOff;
end;

procedure TfrmJog.btnServoOnClick(Sender: TObject);
begin
  Axis.ServoOn;
end;

procedure TfrmJog.btnStopClick(Sender: TObject);
begin
  if Axis <> nil then
  begin
    Axis.Stop;
  end;
end;

procedure TfrmJog.btnResetClick(Sender: TObject);
begin
  if Axis <> nil then
  begin
    Axis.Reset;
  end;
end;

procedure TfrmJog.btnCCWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Axis <> nil then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.JogMove(adCCW);
  end;
end;

procedure TfrmJog.btnCCWMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Axis <> nil then
  begin
    Axis.Stop;
  end;
end;

procedure TfrmJog.btnCWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Axis <> nil then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.JogMove(adCW);
  end;
end;

procedure TfrmJog.btnCWMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Axis <> nil then
  begin
    Axis.Stop;
  end;
end;

procedure TfrmJog.AxisStatusChanged(Sender: TObject);
begin
  if Axis <> nil then
  begin
    if Assigned(OldAxisStatusChanged) then
      OldAxisStatusChanged(Axis);

    ledEncoderFault.LED.Value := (asEncoderFault in Axis.Status);
    ledSWPosLimit.LED.Value := (asSWPosLimit in Axis.Status);
    ledSWNegLimit.LED.Value := (asSWNegLimit in Axis.Status);
    ledPosError.LED.Value := (asPositionError in Axis.Status);
    ledMotionDone.LED.Value := (asMotionDone in Axis.Status);
  end;
end;

procedure TfrmJog.btnRelCCWClick(Sender: TObject);
begin
  if (Axis <> nil) then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.SCurveMove(-feRelPos.Value, True);
  end;
end;

procedure TfrmJog.btnRelCWClick(Sender: TObject);
begin
  if (Axis <> nil) then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.SCurveMove(feRelPos.Value, True);
  end;
end;

procedure TfrmJog.btnAbsMoveClick(Sender: TObject);
begin
  if (Axis <> nil) and (asReady in Axis.Status) then
  begin
    foLoadAxisSpeed(Axis, Equipment.SysServer);
    Axis.SCurveMove(feAbsPos.Value, False);
  end;
end;

procedure TfrmJog.btnShowBottomClick(Sender: TObject);
begin
  if btnShowBottom.Tag = 1 then
  begin
    Self.ClientHeight := btnShowBottom.Top + btnShowBottom.Height + 8;
    btnShowBottom.Tag := 0;
  end
  else
  begin
    Self.ClientHeight := panRepeatMode.Top + panRepeatMode.Height + 8;
    btnShowBottom.Tag := 1;
  end;
end;

procedure TfrmJog.tmrRepeatTimer(Sender: TObject);
begin
  if not Axis.CanMove then
  begin
    btnStopRepeatClick(btnStop);
    Exit;
  end;

  if (asAtTargetPosition in Axis.Status) then
  begin
    if TC.Counting then
    begin
      if TC.ElapsedTime > feDelay.Value then
      begin
        TC.Stop;
        foLoadAxisSpeed(Axis, Equipment.SysServer);
        if fePos1.Tag = 1 then
        begin
          fePos1.Color := clWindow;
          fePos2.Color := clLime;
          fePos1.Tag := 0;
          Axis.SCurveMove(fePos2.value, False)
        end
        else
        begin
          fePos1.Color := clLime;
          fePos2.Color := clWindow;
          fePos1.Tag := 1;
          Axis.SCurveMove(fePos1.value, False);
        end;
      end;
    end
    else
    begin
      TC.Start;
    end;
  end;
end;

procedure TfrmJog.btnStartRepeatClick(Sender: TObject);
begin
  btnStartRepeat.Enabled := False;
  btnStopRepeat.Enabled := True;
  tmrRepeat.Interval := Trunc(feDelay.Value);
  tmrRepeat.Enabled := True;

  foLoadAxisSpeed(Axis, Equipment.SysServer);
  fePos1.Tag := 1;
  fePos1.Color := clLime;
  fePos2.Color := clWindow;
  Axis.SCurveMove(fePos1.Value, False);
end;

procedure TfrmJog.btnStopRepeatClick(Sender: TObject);
begin
  btnStartRepeat.Enabled := True;
  btnStopRepeat.Enabled := False;
  tmrRepeat.Enabled := False;
  fePos1.Color := clWindow;
  fePos2.Color := clWindow;
  TC.Stop;
  Axis.Stop;
end;

procedure TfrmJog.PositionEditButtonClick(Sender: TObject);
begin
  TfoButtonNumberEdit(Sender).Value := GetValueFromTouchKBD(
    TfoButtonNumberEdit(Sender).Value,
    TfoButtonNumberEdit(Sender).Min,
    TfoButtonNumberEdit(Sender).Max
  );
end;

end.
