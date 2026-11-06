object frmEmergency: TfrmEmergency
  Left = 393
  Top = 413
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Emergency Stop'
  ClientHeight = 443
  ClientWidth = 950
  Color = clBtnFace
  TransparentColorValue = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object liEmergency: TfoLCDLabel
    Left = 0
    Top = 0
    Width = 950
    Height = 443
    Align = alClient
    Alignment = taCenter
    Caption = 'EMERGENCY'
    ChannelLink.DataServer = HAL.IOServer
    Frame.Visible = False
    Layout = tlCenter
    LCD.BlinkInterval = 0.500000000000000000
    LCD.DotOnColor = 4342527
    LCD.DotPitch = 2
    LCD.DotSize = 16
    LCD.Spacing = 12
    LCD.RoundDot = True
    ExplicitWidth = 896
    ExplicitHeight = 132
  end
end
