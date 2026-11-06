object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'QRoBOT'
  ClientHeight = 700
  ClientWidth = 1280
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1280
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    Color = 2171169
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 28
      Top = 21
      Width = 51
      Height = 30
      Caption = 'QRoBOT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAccessMode: TLabel
      Left = 872
      Top = 24
      Width = 216
      Height = 24
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'OPERATOR  |  SIMULATION'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnAlarmStatus: TButton
      Left = 120
      Top = 16
      Width = 640
      Height = 40
      Caption = 'SYSTEM READY - NO LATCHED ALARM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnAlarmStatusClick
    end
    object btnSettings: TButton
      Left = 1104
      Top = 16
      Width = 152
      Height = 40
      Caption = 'Settings'
      TabOrder = 0
      OnClick = btnSettingsClick
    end
  end
  object panWorkspace: TPanel
    Left = 0
    Top = 128
    Width = 1280
    Height = 572
    Align = alClient
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 2
    ExplicitTop = 130
  end
  object panNavigation: TPanel
    Left = 0
    Top = 72
    Width = 1280
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = 3355443
    ParentBackground = False
    TabOrder = 2
    object btnOperation: TButton
      Left = 16
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Operation'
      TabOrder = 0
      OnClick = NavigationClick
    end
    object btnStage: TButton
      Left = 148
      Top = 10
      Width = 160
      Height = 36
      Caption = 'Stage (X / Y / Z)'
      TabOrder = 1
      OnClick = NavigationClick
    end
    object btnSpectrometer: TButton
      Left = 316
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Spectrometer'
      TabOrder = 2
      OnClick = NavigationClick
    end
    object btnPlasma: TButton
      Left = 448
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Plasma'
      TabOrder = 3
      OnClick = NavigationClick
    end
    object btnRecipes: TButton
      Left = 580
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Recipes'
      TabOrder = 4
      OnClick = NavigationClick
    end
    object btnAlarms: TButton
      Left = 712
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Alarms'
      TabOrder = 5
      OnClick = NavigationClick
    end
    object btnLogs: TButton
      Left = 844
      Top = 10
      Width = 124
      Height = 36
      Caption = 'Logs'
      TabOrder = 6
      OnClick = NavigationClick
    end
  end
end
