unit uImagePipeClickHandler;

interface

uses
  System.Classes;

procedure ConnectImagePipeClickHandlers(AOwner: TComponent);
procedure ConnectLEDClickHandlers(AOwner: TComponent);
procedure ConnectOdoMeterClickHandlers(AOwner: TComponent);
procedure HandleImagePipeValveOnOff(Sender: TObject);
procedure HandleLEDOnOff(Sender: TObject);
procedure HandleOdoMeterInput(Sender: TObject);

implementation

uses
  System.SysUtils,
  Vcl.Forms,
  foControls,
  dmHAL,
  foTypes,
	foIndicator,
  fNumericKBD,
  foLED,
  uEquipmentConsts,
  uLogger;

type
  TImagePipeClickHandler = class(TComponent)
  public
    procedure ValveOnOffClick(Sender: TObject);
    procedure LEDOnOffClick(Sender: TObject);
    procedure OdoMeterClick(Sender: TObject);
  end;

function GetClickHandler(AOwner: TComponent): TImagePipeClickHandler;
const
  SHandlerName = 'VirtualIOClickHandler';
var
  AComponent: TComponent;
begin
  AComponent := AOwner.FindComponent(SHandlerName);
  if Assigned(AComponent) then
  begin
    if not (AComponent is TImagePipeClickHandler) then
      raise EComponentError.CreateFmt(
        'Component name "%s" is already in use', [SHandlerName]);
    Result := TImagePipeClickHandler(AComponent);
  end
  else
  begin
    Result := TImagePipeClickHandler.Create(AOwner);
    Result.Name := SHandlerName;
  end;
end;

procedure ConnectImagePipeClickHandlers(AOwner: TComponent);
var
  I: Integer;
  ClickHandler: TImagePipeClickHandler;
begin
  if not Assigned(AOwner) then
    Exit;

  ClickHandler := GetClickHandler(AOwner);
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TfoImagePipe then
      TfoImagePipe(AOwner.Components[I]).OnClick :=
        ClickHandler.ValveOnOffClick;
end;

procedure ConnectLEDClickHandlers(AOwner: TComponent);
var
  I: Integer;
  ALED: TfoLED;
  ClickHandler: TImagePipeClickHandler;
begin
  if not Assigned(AOwner) then
    Exit;

  ClickHandler := GetClickHandler(AOwner);
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TfoLED then
    begin
      ALED := TfoLED(AOwner.Components[I]);
      if Assigned(ALED.ChannelLink) and
         Assigned(ALED.ChannelLink.Channel) then
        ALED.OnClick := ClickHandler.LEDOnOffClick;
    end;
end;

procedure ConnectOdoMeterClickHandlers(AOwner: TComponent);
var
  I: Integer;
  OdoMeter: TfoOdoMeter;
  ClickHandler: TImagePipeClickHandler;
begin
  if not Assigned(AOwner) then
    Exit;

  ClickHandler := GetClickHandler(AOwner);
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TfoOdoMeter then
    begin
      OdoMeter := TfoOdoMeter(AOwner.Components[I]);
      if Assigned(OdoMeter.ChannelLink) and
         Assigned(OdoMeter.ChannelLink.Channel) then
        OdoMeter.OnClick := ClickHandler.OdoMeterClick;
    end;
end;

procedure TImagePipeClickHandler.ValveOnOffClick(Sender: TObject);
begin
  HandleImagePipeValveOnOff(Sender);
end;

procedure TImagePipeClickHandler.LEDOnOffClick(Sender: TObject);
begin
  HandleLEDOnOff(Sender);
end;

procedure TImagePipeClickHandler.OdoMeterClick(Sender: TObject);
begin
  HandleOdoMeterInput(Sender);
end;

procedure HandleImagePipeValveOnOff(Sender: TObject);
var
  ImagePipe: TfoImagePipe;
begin
  try
    if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
      Exit;

    if not (Sender is TfoImagePipe) then
      raise EArgumentException.Create('ValveOnOffClick: Invalid Sender');

    ImagePipe := TfoImagePipe(Sender);
    if not Assigned(ImagePipe.ChannelLink) then
      raise Exception.Create('ValveOnOffClick: ChannelLink is not assigned');

    if not Assigned(ImagePipe.ChannelLink.Channel) then
      raise Exception.Create('ValveOnOffClick: Channel is not assigned');

    ImagePipe.ChannelLink.Channel.Value :=
      not ImagePipe.ChannelLink.Channel.Value;
  except
    on E: Exception do
    begin
      Logger.FireLog(ltError,
        Format('[ValveOnOffClick] %s: %s', [E.ClassName, E.Message]),
        [ldLogViewer, ldFile]);
      Application.ShowException(E);
    end;
  end;
end;

procedure HandleLEDOnOff(Sender: TObject);
var
  ALED: TfoLED;
begin
  try
    if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
      Exit;

    if not (Sender is TfoLED) then
      raise EArgumentException.Create('LEDOnOffClick: Invalid Sender');

    ALED := TfoLED(Sender);
    if not Assigned(ALED.ChannelLink) then
      raise Exception.Create('LEDOnOffClick: ChannelLink is not assigned');

    if not Assigned(ALED.ChannelLink.Channel) then
      raise Exception.Create('LEDOnOffClick: Channel is not assigned');

    ALED.ChannelLink.Channel.Value :=
      not ALED.ChannelLink.Channel.Value;
  except
    on E: Exception do
    begin
      Logger.FireLog(ltError,
        Format('[LEDOnOffClick] %s: %s', [E.ClassName, E.Message]),
        [ldLogViewer, ldFile]);
      Application.ShowException(E);
    end;
  end;
end;

procedure HandleOdoMeterInput(Sender: TObject);
var
  OdoMeter: TfoOdoMeter;
  CurrentValue: Double;
begin
  try
    if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
      Exit;

    if not (Sender is TfoOdoMeter) then
      raise EArgumentException.Create('OdoMeterClick: Invalid Sender');

    OdoMeter := TfoOdoMeter(Sender);
    if not Assigned(OdoMeter.ChannelLink) then
      raise Exception.Create('OdoMeterClick: ChannelLink is not assigned');

    if not Assigned(OdoMeter.ChannelLink.Channel) then
      raise Exception.Create('OdoMeterClick: Channel is not assigned');

    CurrentValue := OdoMeter.ChannelLink.Channel.Value;
    OdoMeter.ChannelLink.Channel.Value := GetValueFromTouchKBD(
      CurrentValue,
      OdoMeter.ChannelLink.Channel.Min,
      OdoMeter.ChannelLink.Channel.Max);
  except
    on E: Exception do
    begin
      Logger.FireLog(ltError,
        Format('[OdoMeterClick] %s: %s', [E.ClassName, E.Message]),
        [ldLogViewer, ldFile]);
      Application.ShowException(E);
    end;
  end;
end;

end.
