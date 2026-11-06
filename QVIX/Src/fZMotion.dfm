object frmZMotion: TfrmZMotion
  Caption = 'Z Motion'
  AutoScroll = False
  ClientHeight = 700
  ClientWidth = 1280
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 32
    Top = 17
    Width = 91
    Height = 29
    Caption = 'Z Motion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpCommunication: TGroupBox
    Left = 32
    Top = 49
    Width = 1216
    Height = 69
    Caption = ' Z Axis Connection '
    TabOrder = 0
    object lblConnectionStatus: TLabel
      Left = 216
      Top = 34
      Width = 200
      Height = 24
      Caption = 'DISCONNECTED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnConnect: TButton
      Left = 24
      Top = 29
      Width = 160
      Height = 40
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnConnectClick
    end
  end
  object grpPosition: TGroupBox
    Left = 32
    Top = 133
    Width = 376
    Height = 152
    Caption = ' Z position '
    TabOrder = 1
    object lblCurrentCaption: TLabel
      Left = 32
      Top = 25
      Width = 133
      Height = 21
      Caption = 'Current Z position'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblCurrentPosition: TLabel
      Left = 32
      Top = 52
      Width = 304
      Height = 54
      AutoSize = False
      Caption = '80.0 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -37
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHomeCaption: TLabel
      Left = 32
      Top = 116
      Width = 102
      Height = 17
      Caption = 'HOME position'
    end
    object lblHomePosition: TLabel
      Left = 176
      Top = 112
      Width = 160
      Height = 29
      Alignment = taRightJustify
      AutoSize = False
      Caption = '80.0 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object grpMove: TGroupBox
    Left = 432
    Top = 133
    Width = 816
    Height = 133
    Caption = ' Position move '
    TabOrder = 2
    object lblTargetCaption: TLabel
      Left = 32
      Top = 25
      Width = 104
      Height = 17
      Caption = 'Target position'
    end
    object lblTargetUnit: TLabel
      Left = 216
      Top = 47
      Width = 24
      Height = 21
      Caption = 'mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtTargetPosition: TEdit
      Left = 32
      Top = 42
      Width = 168
      Height = 40
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '80.0'
    end
    object btnMove: TButton
      Left = 280
      Top = 34
      Width = 152
      Height = 56
      Caption = 'MOVE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnMoveClick
    end
    object btnStop: TButton
      Left = 448
      Top = 34
      Width = 152
      Height = 56
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnStopClick
    end
    object btnHome: TButton
      Left = 616
      Top = 34
      Width = 168
      Height = 56
      Caption = 'HOME 80'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnHomeClick
    end
  end
  object grpJog: TGroupBox
    Left = 32
    Top = 296
    Width = 376
    Height = 116
    Caption = ' Manual JOG '
    TabOrder = 3
    object lblJogStep: TLabel
      Left = 32
      Top = 25
      Width = 304
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = 'JOG step: 1.0 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnJogMinus: TButton
      Left = 32
      Top = 49
      Width = 144
      Height = 64
      Caption = '- 1 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnJogMinusClick
    end
    object btnJogPlus: TButton
      Left = 200
      Top = 49
      Width = 144
      Height = 64
      Caption = '+ 1 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnJogPlusClick
    end
  end
  object grpStatus: TGroupBox
    Left = 432
    Top = 280
    Width = 816
    Height = 132
    Caption = ' PMC-1HS Status '
    TabOrder = 4
    object lblMotionCaption: TLabel
      Left = 32
      Top = 28
      Width = 87
      Height = 17
      Caption = 'Motion status'
    end
    object lblMotionStatus: TLabel
      Left = 160
      Top = 25
      Width = 120
      Height = 24
      Caption = 'IDLE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHomeSensorCaption: TLabel
      Left = 320
      Top = 28
      Width = 83
      Height = 17
      Caption = 'HOME sensor'
    end
    object lblHomeSensorStatus: TLabel
      Left = 448
      Top = 25
      Width = 56
      Height = 24
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblControllerAlarmCaption: TLabel
      Left = 584
      Top = 28
      Width = 98
      Height = 17
      Caption = 'Controller alarm'
    end
    object lblControllerAlarmStatus: TLabel
      Left = 704
      Top = 25
      Width = 80
      Height = 24
      Caption = 'NORMAL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMinusLimitCaption: TLabel
      Left = 32
      Top = 80
      Width = 83
      Height = 17
      Caption = '- Limit sensor'
    end
    object lblMinusLimitStatus: TLabel
      Left = 160
      Top = 77
      Width = 56
      Height = 24
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPlusLimitCaption: TLabel
      Left = 320
      Top = 80
      Width = 83
      Height = 17
      Caption = '+ Limit sensor'
    end
    object lblPlusLimitStatus: TLabel
      Left = 448
      Top = 77
      Width = 56
      Height = 24
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object tmrStatus: TTimer
    Enabled = True
    Interval = 100
    OnTimer = tmrStatusTimer
    Left = 1192
    Top = 624
  end
end
