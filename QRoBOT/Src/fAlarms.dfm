object frmAlarms: TfrmAlarms
  AutoScroll = False
  Caption = 'Alarms'
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
    Width = 70
    Height = 29
    Caption = 'Alarms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpLatch: TGroupBox
    Left = 32
    Top = 49
    Width = 1216
    Height = 232
    Caption = ' Stop latch & interlocks '
    TabOrder = 0
    object lblLatchCaption: TLabel
      Left = 24
      Top = 24
      Width = 89
      Height = 17
      Caption = 'LATCH STATUS'
    end
    object lblLatchStatus: TLabel
      Left = 24
      Top = 48
      Width = 280
      Height = 32
      Caption = 'NO LATCHED STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCauseCaption: TLabel
      Left = 344
      Top = 24
      Width = 86
      Height = 17
      Caption = 'ALARM CAUSE'
    end
    object lblCause: TLabel
      Left = 344
      Top = 48
      Width = 520
      Height = 32
      AutoSize = False
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAckCaption: TLabel
      Left = 24
      Top = 96
      Width = 119
      Height = 17
      Caption = 'ACKNOWLEDGEMENT'
    end
    object lblAckStatus: TLabel
      Left = 24
      Top = 120
      Width = 248
      Height = 25
      Caption = 'NOT ACKNOWLEDGED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHomeCaption: TLabel
      Left = 344
      Top = 96
      Width = 93
      Height = 17
      Caption = 'HOME STATUS'
    end
    object lblHomeStatus: TLabel
      Left = 344
      Top = 120
      Width = 320
      Height = 25
      Caption = 'AT HOME / NOT REQUIRED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnAcknowledge: TButton
      Left = 24
      Top = 160
      Width = 176
      Height = 56
      Caption = 'Acknowledge'
      TabOrder = 0
      OnClick = btnAcknowledgeClick
    end
    object btnReset: TButton
      Left = 216
      Top = 160
      Width = 160
      Height = 56
      Caption = 'Reset latch'
      TabOrder = 1
      OnClick = btnResetClick
    end
    object btnForceReset: TButton
      Left = 392
      Top = 160
      Width = 160
      Height = 56
      Caption = 'Force reset'
      TabOrder = 2
      OnClick = btnForceResetClick
    end
    object btnReturnHome: TButton
      Left = 568
      Top = 160
      Width = 208
      Height = 56
      Caption = 'Return HOME '#183' output OFF'
      TabOrder = 3
      OnClick = btnReturnHomeClick
    end
    object btnReleaseEStop: TButton
      Left = 792
      Top = 160
      Width = 176
      Height = 56
      Caption = 'Release E-stop'
      TabOrder = 4
      OnClick = btnReleaseEStopClick
    end
  end
  object grpBlockers: TGroupBox
    Left = 32
    Top = 296
    Width = 376
    Height = 128
    Caption = ' Present start blockers '
    TabOrder = 1
    object lstBlockers: TListBox
      Left = 16
      Top = 17
      Width = 344
      Height = 98
      ItemHeight = 17
      TabOrder = 0
    end
  end
  object grpTest: TGroupBox
    Left = 432
    Top = 296
    Width = 376
    Height = 128
    Caption = ' Alarm simulation '
    TabOrder = 2
    object btnSensorAlarm: TButton
      Left = 16
      Top = 20
      Width = 160
      Height = 48
      Caption = 'Optical alarm'
      TabOrder = 0
      OnClick = btnSensorAlarmClick
    end
    object btnWaterAlarm: TButton
      Left = 200
      Top = 20
      Width = 160
      Height = 48
      Caption = 'Water alarm'
      TabOrder = 1
      OnClick = btnWaterAlarmClick
    end
    object btnEStop: TButton
      Left = 16
      Top = 76
      Width = 160
      Height = 48
      Caption = 'Simulate E-stop'
      TabOrder = 2
      OnClick = btnEStopClick
    end
    object btnClearCondition: TButton
      Left = 200
      Top = 76
      Width = 160
      Height = 48
      Caption = 'Clear condition'
      TabOrder = 3
      OnClick = btnClearConditionClick
    end
  end
end
