unit fLightChannel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  Menus,

  cxButtons,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  dxSkinsCore,
  dxSkinOffice2010Silver,
  cxTextEdit,
  cxMaskEdit,
  cxSpinEdit,
  cxTrackBar,
  cxCheckBox,
  dxToggleSwitch,

  elMultiLanguage,

  foButton,
  foDataServer,
  foController,

  fMessageDlg,
  dmHAL,
  uCommonUtils,
  uLogger, Vcl.ExtCtrls;

type
  TfrmLightChannel = class(TForm)
    TrackBar: TcxTrackBar;
    SpinEdit: TcxSpinEdit;
    btnPreset1: TcxButton;
    btnPreset2: TcxButton;
    btnSetPreset2: TcxButton;
    btnSetPreset1: TcxButton;
    tmrDelay: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TrackBarPropertiesChange(Sender: TObject);
    procedure SpinEditPropertiesChange(Sender: TObject);
    procedure btnPreset1Click(Sender: TObject);
    procedure btnPreset2Click(Sender: TObject);
    procedure btnSetPreset1Click(Sender: TObject);
    procedure btnSetPreset2Click(Sender: TObject);
    procedure tmrDelayTimer(Sender: TObject);
  private
    FLightController : TfoCustomLightController;
    FIntensityChannelName: string;
    FDataServer: TfoCustomDataServer;

    FOnChanged: TfoLightIntensityChangeEvent;
    FPreset2ChannelName: string;
    FPreset1ChannelName: string;
    procedure SetDataServer(const Value: TfoCustomDataServer);
    procedure SetIntensityChannelName(const Value: string);
    { Private declarations }
    procedure FireChanged(const AIntensity : Integer);
    function GetIntensityChannel : TfoChannel;
    procedure SetPreset1ChannelName(const Value: string);
    procedure SetPreset2ChannelName(const Value: string);
  protected
  public
    { Public declarations }
    procedure RefreshIntensity;
    procedure SetIntensity(const AValue : Integer);

    property DataServer : TfoCustomDataServer read FDataServer write SetDataServer;
    property IntensityChannelName : string read FIntensityChannelName write SetIntensityChannelName;
    property Preset1ChannelName : string read FPreset1ChannelName write SetPreset1ChannelName;
    property Preset2ChannelName : string read FPreset2ChannelName write SetPreset2ChannelName;
    property LightController : TfoCustomLightController read FLightController write FLightController;
  end;

var
  frmLightChannel: TfrmLightChannel;

implementation

{$R *.dfm}

procedure TfrmLightChannel.btnPreset1Click(Sender: TObject);
begin
  if FDataServer <> nil then
  begin
    if (FPreset1ChannelName <> '') and FDataServer.ChannelExist(FPreset1ChannelName) then
    begin
      SetIntensity(FDataServer.AsInteger[FPreset1ChannelName]);
    end;
  end;
end;

procedure TfrmLightChannel.btnPreset2Click(Sender: TObject);
begin
  if FDataServer <> nil then
  begin
    if (FPreset2ChannelName <> '') and FDataServer.ChannelExist(FPreset2ChannelName) then
    begin
      SetIntensity(FDataServer.AsInteger[FPreset2ChannelName]);
    end;
  end;
end;

procedure TfrmLightChannel.btnSetPreset1Click(Sender: TObject);
begin
  if FDataServer <> nil then
  begin
    if (FPreset1ChannelName <> '') and FDataServer.ChannelExist(FPreset1ChannelName) then
    begin
      if Confirm(ELS('Are you sure?'), Application.Title) = mrOK then
        FDataServer.AsInteger[FPreset1ChannelName] := FLightController.Intensity;
    end;
  end;
end;

procedure TfrmLightChannel.btnSetPreset2Click(Sender: TObject);
begin
  if FDataServer <> nil then
  begin
    if (FPreset2ChannelName <> '') and FDataServer.ChannelExist(FPreset2ChannelName) then
    begin
      if Confirm(ELS('Are you sure?'), Application.Title) = mrOK then
        FDataServer.AsInteger[FPreset2ChannelName] := FLightController.Intensity;
    end;
  end;
end;

procedure TfrmLightChannel.FireChanged(const AIntensity : Integer);
begin
  SpinEdit.Value := AIntensity;
  TrackBar.Position := AIntensity;

  if FLightController <> nil then
  begin
    FLightController.ChangeIntensity(AIntensity);
  end;

  if GetIntensityChannel <> nil then
    GetIntensityChannel.AsInteger := AIntensity;

  if Assigned(FOnChanged) then
    FOnChanged(Self, AIntensity);
end;

procedure TfrmLightChannel.FormCreate(Sender: TObject);
begin
  DesktopFont := True;

  SpinEdit.Properties.MinValue := 0;
  SpinEdit.Properties.MaxValue := 255;
  SpinEdit.Value := 128;
  TrackBar.Properties.Min := 0;
  TrackBar.Properties.Max := 255;
  TrackBar.Position := 128;
  FLightController := nil;
  FIntensityChannelName := '';
  FPreset1ChannelName := '';
  FPreset2ChannelName := '';
end;

function TfrmLightChannel.GetIntensityChannel: TfoChannel;
begin
  Result := nil;

  if FDataServer <> nil then
  begin
    if FIntensityChannelName <> '' then
    begin
      Result := FDataServer.Channel[FIntensityChannelName];
    end;
  end;
end;

procedure TfrmLightChannel.RefreshIntensity;
begin
  if (FLightController <> nil) and (GetIntensityChannel <> nil) then
  begin
    FLightController.Intensity := GetIntensityChannel.AsInteger;

    SpinEdit.Properties.MinValue := FLightController.MinIntensity;
    SpinEdit.Properties.MaxValue := FLightController.MaxIntensity;
    SpinEdit.Value := FLightController.Intensity;
    TrackBar.Properties.Min := FLightController.MinIntensity;
    TrackBar.Properties.Max := FLightController.MaxIntensity;
    TrackBar.Position := FLightController.Intensity;
  end;
end;

procedure TfrmLightChannel.SetDataServer(const Value: TfoCustomDataServer);
begin
  FDataServer := Value;

  RefreshIntensity;
end;

procedure TfrmLightChannel.SetIntensity(const AValue: Integer);
begin
  if (FLightController <> nil) then
  begin
    FLightController.Intensity := AValue;

    SpinEdit.Value := FLightController.Intensity;
    TrackBar.Position := FLightController.Intensity;
  end;
end;

procedure TfrmLightChannel.SetIntensityChannelName(const Value: string);
begin
  FIntensityChannelName := Value;

  RefreshIntensity;
end;

procedure TfrmLightChannel.SetPreset1ChannelName(const Value: string);
begin
  FPreset1ChannelName := Value;
end;

procedure TfrmLightChannel.SetPreset2ChannelName(const Value: string);
begin
  FPreset2ChannelName := Value;
end;

procedure TfrmLightChannel.SpinEditPropertiesChange(Sender: TObject);
begin
  tmrDelay.Enabled := False;
  tmrDelay.Enabled := True;
end;

procedure TfrmLightChannel.tmrDelayTimer(Sender: TObject);
begin
  tmrDelay.Enabled := False;

  if (FLightController <> nil) and (GetIntensityChannel <> nil) then
    FireChanged(TrackBar.Position);
end;

procedure TfrmLightChannel.TrackBarPropertiesChange(Sender: TObject);
begin
  tmrDelay.Enabled := False;
  tmrDelay.Enabled := True;
end;

end.
