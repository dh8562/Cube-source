object frmPlasma: TfrmPlasma
  Left = 0
  Top = 0
  Caption = 'Plasma'
  ClientHeight = 700
  ClientWidth = 1280
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 32
    Top = 17
    Width = 69
    Height = 30
    Caption = 'Plasma'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpConnection: TGroupBox
    Left = 32
    Top = 49
    Width = 1216
    Height = 88
    Caption = ' Plasma PSU Connection '
    TabOrder = 0
    object lblConnectionStatus: TLabel
      Left = 216
      Top = 34
      Width = 280
      Height = 24
      AutoSize = False
      Caption = 'DISCONNECTED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblModel: TLabel
      Left = 520
      Top = 18
      Width = 440
      Height = 21
      AutoSize = False
      Caption = 'MODEL  Excitair-0219  |  RS-485 + Remote I/O'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblControlMode: TLabel
      Left = 520
      Top = 48
      Width = 240
      Height = 21
      AutoSize = False
      Caption = 'CONTROL  REMOTE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
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
  object grpStatus: TGroupBox
    Left = 32
    Top = 145
    Width = 760
    Height = 148
    Caption = ' Plasma PSU Status '
    TabOrder = 1
    object lblOutputCaption: TLabel
      Left = 32
      Top = 25
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'OUTPUT'
    end
    object lblOutputValue: TLabel
      Left = 184
      Top = 22
      Width = 200
      Height = 29
      AutoSize = False
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblVoltageCaption: TLabel
      Left = 32
      Top = 54
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'VOLTAGE'
    end
    object lblVoltageValue: TLabel
      Left = 184
      Top = 52
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '0.0 V'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCurrentCaption: TLabel
      Left = 400
      Top = 54
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'CURRENT'
    end
    object lblCurrentValue: TLabel
      Left = 552
      Top = 52
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '0.00 A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblFrequencyCaption: TLabel
      Left = 400
      Top = 25
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'FREQUENCY'
    end
    object lblFrequencyValue: TLabel
      Left = 552
      Top = 22
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '-- kHz'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPowerCaption: TLabel
      Left = 32
      Top = 88
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'POWER'
    end
    object lblPowerValue: TLabel
      Left = 184
      Top = 86
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '0 W'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAlarmCaption: TLabel
      Left = 400
      Top = 88
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'ALARM'
    end
    object lblAlarmValue: TLabel
      Left = 552
      Top = 86
      Width = 160
      Height = 29
      AutoSize = False
      Caption = 'NORMAL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHeadSpeedCaption: TLabel
      Left = 32
      Top = 118
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'HEAD SPEED'
    end
    object lblHeadSpeedValue: TLabel
      Left = 184
      Top = 115
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '0 rpm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPressureCaption: TLabel
      Left = 400
      Top = 118
      Width = 128
      Height = 21
      AutoSize = False
      Caption = 'GAS PRESSURE'
    end
    object lblPressureValue: TLabel
      Left = 552
      Top = 115
      Width = 160
      Height = 29
      AutoSize = False
      Caption = '0.000 MPa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object grpControl: TGroupBox
    Left = 816
    Top = 145
    Width = 432
    Height = 80
    Caption = ' Manual Control '
    TabOrder = 2
    object btnOutputOn: TButton
      Left = 32
      Top = 20
      Width = 168
      Height = 56
      Caption = 'OUTPUT ON'
      TabOrder = 0
      OnClick = btnOutputOnClick
    end
    object btnOutputOff: TButton
      Left = 232
      Top = 20
      Width = 168
      Height = 56
      Caption = 'OUTPUT OFF'
      TabOrder = 1
      OnClick = btnOutputOffClick
    end
  end
  object grpRuntime: TGroupBox
    Left = 816
    Top = 233
    Width = 432
    Height = 64
    Caption = ' Cumulative plasma runtime '
    TabOrder = 3
    object lblRuntimeValue: TLabel
      Left = 24
      Top = 17
      Width = 176
      Height = 29
      AutoSize = False
      Caption = '00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblRuntimeUnit: TLabel
      Left = 216
      Top = 14
      Width = 52
      Height = 15
      Caption = 'hh:mm:ss'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblRuntimeNote: TLabel
      Left = 216
      Top = 40
      Width = 122
      Height = 15
      Caption = 'Plasma ON - all recipes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object grpDeviceSettings: TGroupBox
    Left = 32
    Top = 304
    Width = 1216
    Height = 176
    Caption = ' Device Settings '
    TabOrder = 4
    object lblSetPowerCaption: TLabel
      Left = 32
      Top = 30
      Width = 160
      Height = 21
      AutoSize = False
      Caption = 'Power Setpoint'
    end
    object lblSetPowerUnit: TLabel
      Left = 344
      Top = 30
      Width = 12
      Height = 17
      Caption = 'W'
    end
    object lblSetFrequencyCaption: TLabel
      Left = 32
      Top = 78
      Width = 160
      Height = 21
      AutoSize = False
      Caption = 'Frequency Monitor'
    end
    object lblSetFrequencyUnit: TLabel
      Left = 344
      Top = 78
      Width = 21
      Height = 17
      Caption = 'kHz'
    end
    object lblModeCaption: TLabel
      Left = 32
      Top = 126
      Width = 160
      Height = 21
      AutoSize = False
      Caption = 'Control mode'
    end
    object lblSettingsNote: TLabel
      Left = 456
      Top = 28
      Width = 704
      Height = 64
      AutoSize = False
      Caption = 
        'Excitair-0219: power 300-1000 W, excitation frequency 25-30 kHz,' +
        ' gas pressure 0.10-0.25 MPa. RS-485 port, baud rate and slave ad' +
        'dress are managed in Settings. Frequency is monitored from the d' +
        'evice.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object edtSetPower: TEdit
      Left = 200
      Top = 20
      Width = 128
      Height = 25
      Alignment = taRightJustify
      TabOrder = 0
      Text = '600'
    end
    object edtSetFrequency: TEdit
      Left = 200
      Top = 68
      Width = 128
      Height = 25
      Alignment = taRightJustify
      ReadOnly = True
      TabOrder = 1
      Text = '27.0'
    end
    object cmbControlMode: TComboBox
      Left = 200
      Top = 116
      Width = 128
      Height = 25
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 2
      Text = 'Remote'
      Items.Strings = (
        'Local'
        'Remote')
    end
    object btnApply: TButton
      Left = 456
      Top = 116
      Width = 160
      Height = 48
      Caption = 'Apply settings'
      TabOrder = 3
      OnClick = btnApplyClick
    end
  end
  object grpAlarmMonitor: TGroupBox
    Left = 32
    Top = 484
    Width = 1216
    Height = 88
    Caption = ' Alarm and Interlock Monitor '
    TabOrder = 5
    object lblAlarmMonitor: TLabel
      Left = 26
      Top = 20
      Width = 1160
      Height = 64
      AutoSize = False
      Caption = 
        'Overcurrent: NORMAL    Over-temperature: NORMAL    Overvoltage: ' +
        'NORMAL    Undervoltage: NORMAL'#13#10'Air pressure: NORMAL    Phase: N' +
        'ORMAL    Arc: NORMAL    Motor: NORMAL    Interlock: READY'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object tmrStatus: TTimer
    Interval = 500
    OnTimer = tmrStatusTimer
    Left = 1184
    Top = 15
  end
end
