unit fIOMonitoring;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.StdCtrls,

  foTypes,
  foControls,
  foLED,
  foButton,
  foDataServer,

  elPanels,


  uEquipment,


  dxSkinsCore,
  dxSkinBasic,
  dxSkinBlack,
  dxSkinBlue,
  dxSkinBlueprint,
  dxSkinCaramel,
  dxSkinCoffee,
  dxSkinDarkroom,
  dxSkinDarkSide,
  dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle,
  dxSkinFoggy,
  dxSkinGlassOceans,
  dxSkinHighContrast,
  dxSkiniMaginary,
  dxSkinLilian,
  dxSkinLiquidSky,
  dxSkinLondonLiquidSky,
  dxSkinMcSkin,
  dxSkinMetropolis,
  dxSkinMetropolisDark,
  dxSkinMoneyTwins,
  dxSkinOffice2007Black,
  dxSkinOffice2007Blue,
  dxSkinOffice2007Green,
  dxSkinOffice2007Pink,
  dxSkinOffice2007Silver,
  dxSkinOffice2010Black,
  dxSkinOffice2010Blue,
  dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray,
  dxSkinOffice2013White,
  dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark,
  dxSkinOffice2019Black,
  dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray,
  dxSkinOffice2019White,
  dxSkinPumpkin,
  dxSkinSeven,
  dxSkinSevenClassic,
  dxSkinSharp,
  dxSkinSharpPlus,
  dxSkinSilver,
  dxSkinSpringtime,
  dxSkinStardust,
  dxSkinSummer2008,
  dxSkinTheAsphaltWorld,
  dxSkinTheBezier,
  dxSkinsDefaultPainters,
  dxSkinValentine,
  dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light,
  dxSkinVS2010,
  dxSkinWhiteprint,
  dxSkinXmas2008Blue,

  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxButtons, elLabel;

const
	MAX_INPUT_COUNT	= 19;
	MAX_OUTPUT_COUNT	= 14;

type
	TIODesc = record
    nName : Integer;
    nAddressNo : Integer;
  end;

type
  TfrmIOMonitoring = class(TForm)
    btnInPrev: TcxButton;
    btnInNext: TcxButton;
    btnOutPrev: TcxButton;
    btnOutNext: TcxButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    ledIn00: TfoLED;
    elLabel4: TelLabel;
    ledIn01: TfoLED;
    ledIn02: TfoLED;
    ledIn03: TfoLED;
    ledIn04: TfoLED;
    ledIn05: TfoLED;
    ledIn06: TfoLED;
    ledIn07: TfoLED;
    ledIn08: TfoLED;
    ledIn09: TfoLED;
    ledIn0A: TfoLED;
    ledIn0B: TfoLED;
    ledIn0C: TfoLED;
    ledIn0D: TfoLED;
    ledIn0E: TfoLED;
    ledIn0F: TfoLED;
    Panel1: TPanel;
    elLabel2: TelLabel;
    Panel7: TPanel;
    ledOut00: TfoLED;
    ledOut01: TfoLED;
    ledOut02: TfoLED;
    ledOut03: TfoLED;
    ledOut04: TfoLED;
    ledOut05: TfoLED;
    ledOut06: TfoLED;
    ledOut07: TfoLED;
    ledOut08: TfoLED;
    ledOut09: TfoLED;
    ledOut0A: TfoLED;
    ledOut0B: TfoLED;
    ledOut0C: TfoLED;
    ledOut0D: TfoLED;
    ledOut0E: TfoLED;
    ledOut0F: TfoLED;
    ledIn10: TfoLED;
    ledIn11: TfoLED;
    ledIn12: TfoLED;
    ledIn13: TfoLED;
    ledIn14: TfoLED;
    ledIn15: TfoLED;
    ledIn16: TfoLED;
    ledIn17: TfoLED;
    ledIn18: TfoLED;
    ledIn19: TfoLED;
    ledIn1A: TfoLED;
    ledIn1B: TfoLED;
    ledIn1C: TfoLED;
    ledIn1D: TfoLED;
    ledIn1E: TfoLED;
    ledIn1F: TfoLED;
    Panel6: TPanel;
    ledOut10: TfoLED;
    ledOut11: TfoLED;
    ledOut12: TfoLED;
    ledOut13: TfoLED;
    ledOut14: TfoLED;
    ledOut15: TfoLED;
    ledOut16: TfoLED;
    ledOut17: TfoLED;
    ledOut18: TfoLED;
    ledOut19: TfoLED;
    ledOut1A: TfoLED;
    ledOut1B: TfoLED;
    ledOut1C: TfoLED;
    ledOut1D: TfoLED;
    ledOut1E: TfoLED;
    ledOut1F: TfoLED;
    procedure btnInPrevClick(Sender: TObject);
    procedure btnInNextClick(Sender: TObject);
    procedure btnOutPrevClick(Sender: TObject);
    procedure btnOutNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutOnOFf(Sender: TObject);
    procedure ledOut00Changed(Sender: TObject);
  private
    { Private declarations }
    FMaxInputCount : Integer;
    FMaxOutputCount : Integer;
    FInIndex : Integer;
    FOutIndex : Integer;

    FInDesc : array [0..MAX_INPUT_COUNT-1] of TIODesc;
    FOutDesc : array [0..MAX_OUTPUT_COUNT-1] of TIODesc;

  public
    { Public declarations }
    procedure SetupInput;
    procedure SetupOutput;
  end;

var
  frmIOMonitoring: TfrmIOMonitoring;

implementation

{$R *.dfm}

uses dmHAL, dmMachine;

procedure TfrmIOMonitoring.btnInNextClick(Sender: TObject);
begin
  Inc(FInIndex, 2);
  if FInIndex >= FMaxInputCount-1 then FInIndex := FMaxInputCount-2;
  SetupInput;
end;

procedure TfrmIOMonitoring.btnInPrevClick(Sender: TObject);
begin
  Dec(FInIndex, 2);
  if FInIndex < 0 then FInIndex := 0;
  SetupInput;
end;

procedure TfrmIOMonitoring.btnOutNextClick(Sender: TObject);
begin
  Inc(FOutIndex, 2);
  if FOutIndex >= FMaxOutputCount-1 then FOutIndex := FMaxOutputCount-2;
  SetupOutput;
end;

procedure TfrmIOMonitoring.btnOutPrevClick(Sender: TObject);
begin
  Dec(FOutIndex, 2);
  if FOutIndex < 0 then FOutIndex := 0;
  SetupOutput;
end;

procedure TfrmIOMonitoring.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
end;

procedure TfrmIOMonitoring.FormShow(Sender: TObject);
var
  I, nInNo, nOutNo: Integer;
  nName : Integer;
  nInAddr, nOutAddr : Integer;
begin
  FMaxInputCount := MAX_INPUT_COUNT;
  FMaxOutputCount := MAX_OUTPUT_COUNT;

  FMaxInputCount := 19;
  FMaxOutputCount := 14;

  FInIndex := 0;
  FOutIndex := 0;

  nInNo := 0;
  nOutNo := 0;

  //------------------------- DIODevice
  nName := 100;
  nInAddr := 0;
  for I := 0 to 4 do
  begin
    FInDesc[nInNo].nName := nName + I;
    FInDesc[nInNo].nAddressNo := nInAddr + (I * 2);
    Inc(nInNo);
  end;

  nName := 100;
  nOutAddr := 0 + 16;
  for I := 0 to 1 do
  begin
    FOutDesc[nOutNo].nName := nName + I;
    FOutDesc[nOutNo].nAddressNo := nOutAddr + (I * 2);
    Inc(nOutNo);
  end;

  //------------------------- DIODevice
  nName := 200;
  nInAddr := 10;
  for I := 0 to 3 do
  begin
    FInDesc[nInNo].nName := nName + I;
    FInDesc[nInNo].nAddressNo := nInAddr + (I * 2);
    Inc(nInNo);
  end;

  nName := 200;
  nOutAddr := 4 + 16;
  for I := 0 to 1 do
  begin
    FOutDesc[nOutNo].nName := nName + I;
    FOutDesc[nOutNo].nAddressNo := nOutAddr + (I * 2);
    Inc(nOutNo);
  end;

  //------------------------- DIODevice
  nName := 300;
  nInAddr := 18;
  for I := 0 to 3 do
  begin
    FInDesc[nInNo].nName := nName + I;
    FInDesc[nInNo].nAddressNo := nInAddr + (I * 2);
    Inc(nInNo);
  end;

  nName := 300;
  nOutAddr := 8 + 16;
  for I := 0 to 1 do
  begin
    FOutDesc[nOutNo].nName := nName + I;
    FOutDesc[nOutNo].nAddressNo := nOutAddr + (I * 2);
    Inc(nOutNo);
  end;

  //------------------------- DIODevice
  nName := 400;
  nInAddr := 26;
  for I := 0 to 5 do
  begin
    FInDesc[nInNo].nName := nName + I;
    FInDesc[nInNo].nAddressNo := nInAddr + (I * 2);
    Inc(nInNo);
  end;

  nName := 400;
  nOutAddr := 12 + 16;
  for I := 0 to 1 do
  begin
    FOutDesc[nOutNo].nName := nName + I;
    FOutDesc[nOutNo].nAddressNo := nOutAddr + (I * 2);
    Inc(nOutNo);
  end;

  //------------------------- DIODevice
  nName := 600;
  nOutAddr := 0;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);

  nName := 602;
  nOutAddr := 12;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);

  nName := 603;
  nOutAddr := 14;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);

  nName := 604;
  nOutAddr := 4;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);

  nName := 605;
  nOutAddr := 6;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);

  nName := 606;
  nOutAddr := 8;
  FOutDesc[nOutNo].nName := nName;
  FOutDesc[nOutNo].nAddressNo := nOutAddr;
  Inc(nOutNo);


  SetupInput;
  SetupOutput;
end;

procedure TfrmIOMonitoring.ledOut00Changed(Sender: TObject);
begin
	if TfoLED(Sender).LED.Value then
  begin
		TfoLED(Sender).Font.Color := clWhite;
  end
  else
  begin
		TfoLED(Sender).Font.Color := clBlack;
  end;
end;

procedure TfrmIOMonitoring.OutOnOFf(Sender: TObject);
var
  szChannelName : string;
begin
	if not Machine.IsAutoRunning(True) then exit;

  szChannelName := tfoLED(Sender).ChannelLink.ChannelName;

  if Length(szChannelName) > 0 then
  begin
  	HAL.IOServer.AsBoolean[szChannelName] := not HAL.IOServer.AsBoolean[szChannelName];
  end;
end;

procedure TfrmIOMonitoring.SetupInput;
var
  Channel : TfoChannel;
  szChannelName : String;
  nName : Integer;
  nAddressNo : Integer;

  ALED : array[0..15] of TfoLED;
  ALED2 : array[0..15] of TfoLED;
  I: Integer;
begin
	exit;

  ALED[00] := ledIn00;
  ALED[01] := ledIn01;
  ALED[02] := ledIn02;
  ALED[03] := ledIn03;
  ALED[04] := ledIn04;
  ALED[05] := ledIn05;
  ALED[06] := ledIn06;
  ALED[07] := ledIn07;
  ALED[08] := ledIn08;
  ALED[09] := ledIn09;
  ALED[10] := ledIn0A;
  ALED[11] := ledIn0B;
  ALED[12] := ledIn0C;
  ALED[13] := ledIn0D;
  ALED[14] := ledIn0E;
  ALED[15] := ledIn0F;
  ALED2[00] := ledIn10;
  ALED2[01] := ledIn11;
  ALED2[02] := ledIn12;
  ALED2[03] := ledIn13;
  ALED2[04] := ledIn14;
  ALED2[05] := ledIn15;
  ALED2[06] := ledIn16;
  ALED2[07] := ledIn17;
  ALED2[08] := ledIn18;
  ALED2[09] := ledIn19;
  ALED2[10] := ledIn1A;
  ALED2[11] := ledIn1B;
  ALED2[12] := ledIn1C;
  ALED2[13] := ledIn1D;
  ALED2[14] := ledIn1E;
  ALED2[15] := ledIn1F;

  nName := FInDesc[FInIndex].nName;
  nAddressNo := FInDesc[FInIndex].nAddressNo;
  for I := 0 to 7 do
  begin
//  	if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
//    	szChannelName := HAL.GetChannelName(ckInput, nAddressNo, I, Channel)
//    else
//    	szChannelName := HAL.GetChannelName(ckVirtual, nAddressNo, I, Channel);

    ALED[I].Caption := Format('X%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED[I].Caption := ALED[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED[I].ChannelLink.ChannelName := szChannelName;
      ALED[I].LED.Invert := Channel.InvertBoolean;
    end
    else
    begin
      ALED[I].ChannelLink.ChannelName := '';
      ALED[I].LED.Invert := False;
      ALED[I].LED.Value := False;
    end;
  end;

  nName := FInDesc[FInIndex].nName;
  nAddressNo := FInDesc[FInIndex].nAddressNo + 1;
  for I := 8 to 15 do
  begin
//  	if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
//    	szChannelName := HAL.GetChannelName(ckInput, nAddressNo, I-8, Channel)
//    else
//    	szChannelName := HAL.GetChannelName(ckVirtual, nAddressNo, I-8, Channel);

    ALED[I].Caption := Format('X%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED[I].Caption := ALED[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED[I].ChannelLink.ChannelName := szChannelName;
      ALED[I].LED.Invert := Channel.InvertBoolean;
    end
    else
    begin
      ALED[I].ChannelLink.ChannelName := '';
      ALED[I].LED.Invert := False;
      ALED[I].LED.Value := False;
    end;
  end;

  nName := FInDesc[FInIndex+1].nName;
  nAddressNo := FInDesc[FInIndex+1].nAddressNo;
  for I := 0 to 7 do
  begin
//  	if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
//    	szChannelName := HAL.GetChannelName(ckInput, nAddressNo, I, Channel)
//    else
//    	szChannelName := HAL.GetChannelName(ckVirtual, nAddressNo, I, Channel);

    ALED2[I].Caption := Format('X%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED2[I].Caption := ALED2[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED2[I].ChannelLink.ChannelName := szChannelName;
      ALED2[I].LED.Invert := Channel.InvertBoolean;
    end
    else
    begin
      ALED2[I].ChannelLink.ChannelName := '';
      ALED2[I].LED.Invert := False;
      ALED2[I].LED.Value := False;
    end;
  end;

  nName := FInDesc[FInIndex+1].nName;
  nAddressNo := FInDesc[FInIndex+1].nAddressNo + 1;
  for I := 8 to 15 do
  begin
//  	if not HAL.SysServer.AsBoolean[S_USE_VIRTUAL_RUNNING] then
//    	szChannelName := HAL.GetChannelName(ckInput, nAddressNo, I-8, Channel)
//    else
//    	szChannelName := HAL.GetChannelName(ckVirtual, nAddressNo, I-8, Channel);

    ALED2[I].Caption := Format('X%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED2[I].Caption := ALED2[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED2[I].ChannelLink.ChannelName := szChannelName;
      ALED2[I].LED.Invert := Channel.InvertBoolean;
    end
    else
    begin
      ALED2[I].ChannelLink.ChannelName := '';
      ALED2[I].LED.Invert := False;
      ALED2[I].LED.Value := False;
    end;
  end;
end;


procedure TfrmIOMonitoring.SetupOutput;
var
  Channel : TfoChannel;
  szChannelName : String;
  nName : Integer;
  nAddressNo : Integer;

  ALED : array[0..15] of TfoLED;
  ALED2 : array[0..15] of TfoLED;
  I: Integer;
begin
exit;
  ALED[00] := ledOut00;
  ALED[01] := ledOut01;
  ALED[02] := ledOut02;
  ALED[03] := ledOut03;
  ALED[04] := ledOut04;
  ALED[05] := ledOut05;
  ALED[06] := ledOut06;
  ALED[07] := ledOut07;
  ALED[08] := ledOut08;
  ALED[09] := ledOut09;
  ALED[10] := ledOut0A;
  ALED[11] := ledOut0B;
  ALED[12] := ledOut0C;
  ALED[13] := ledOut0D;
  ALED[14] := ledOut0E;
  ALED[15] := ledOut0F;

  ALED2[00] := ledOut10;
  ALED2[01] := ledOut11;
  ALED2[02] := ledOut12;
  ALED2[03] := ledOut13;
  ALED2[04] := ledOut14;
  ALED2[05] := ledOut15;
  ALED2[06] := ledOut16;
  ALED2[07] := ledOut17;
  ALED2[08] := ledOut18;
  ALED2[09] := ledOut19;
  ALED2[10] := ledOut1A;
  ALED2[11] := ledOut1B;
  ALED2[12] := ledOut1C;
  ALED2[13] := ledOut1D;
  ALED2[14] := ledOut1E;
  ALED2[15] := ledOut1F;

  nName := FOutDesc[FOutIndex].nName;
  nAddressNo := FOutDesc[FOutIndex].nAddressNo;
  for I := 0 to 7 do
  begin
//    szChannelName := HAL.GetChannelName(ckOutput, nAddressNo, I, Channel);
    ALED[I].Caption := Format('Y%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED[I].Caption := ALED[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED[I].ChannelLink.ChannelName := szChannelName;
    end
    else
    begin
      ALED[I].ChannelLink.ChannelName := '';
      ALED[I].LED.Invert := False;
      ALED[I].LED.Value := False;
    end;
  end;

  nAddressNo := FOutDesc[FOutIndex].nAddressNo + 1;
  for I := 8 to 15 do
  begin
//    szChannelName := HAL.GetChannelName(ckOutput, nAddressNo, I-8, Channel);
    ALED[I].Caption := Format('Y%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED[I].Caption := ALED[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED[I].ChannelLink.ChannelName := szChannelName;
    end
    else
    begin
      ALED[I].ChannelLink.ChannelName := '';
      ALED[I].LED.Invert := False;
      ALED[I].LED.Value := False;
    end;
  end;

  nName := FOutDesc[FOutIndex+1].nName;
  nAddressNo := FOutDesc[FOutIndex+1].nAddressNo;
  for I := 0 to 7 do
  begin
//    szChannelName := HAL.GetChannelName(ckOutput, nAddressNo, I, Channel);
    ALED2[I].Caption := Format('Y%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED2[I].Caption := ALED2[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED2[I].ChannelLink.ChannelName := szChannelName;
    end
    else
    begin
      ALED2[I].ChannelLink.ChannelName := '';
      ALED2[I].LED.Invert := False;
      ALED2[I].LED.Value := False;
    end;
  end;

  nAddressNo := FOutDesc[FOutIndex+1].nAddressNo + 1;
  for I := 8 to 15 do
  begin
//    szChannelName := HAL.GetChannelName(ckOutput, nAddressNo, I-8, Channel);
    ALED2[I].Caption := Format('Y%.03d.%.02d',[nName,I]) + Char(10) + szChannelName;
    if Channel <> nil then
    begin
    	if Channel.ZDescription <> '' then
      begin
    		ALED2[I].Caption := ALED2[I].Caption + ' [' + Channel.ZDescription + ']';
      end;
      ALED2[I].ChannelLink.ChannelName := szChannelName;
    end
    else
    begin
      ALED2[I].ChannelLink.ChannelName := '';
      ALED2[I].LED.Invert := False;
      ALED2[I].LED.Value := False;
    end;
  end;
end;

end.
