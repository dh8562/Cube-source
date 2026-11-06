object frmOperation: TfrmOperation
  Caption = 'Operation'
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 32
    Top = 17
    Width = 100
    Height = 29
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblConnection: TLabel
    Left = 1048
    Top = 20
    Width = 200
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'SIMULATOR '#183' No hardware connection'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8421504
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object grpMode: TGroupBox
    Left = 32
    Top = 49
    Width = 360
    Height = 74
    Caption = ' Operation mode '
    TabOrder = 0
    object rbManual: TRadioButton
      Left = 32
      Top = 28
      Width = 125
      Height = 32
      Caption = 'MANUAL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = ModeClick
    end
    object rbAuto: TRadioButton
      Left = 196
      Top = 28
      Width = 125
      Height = 32
      Caption = 'AUTO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ModeClick
    end
  end
  object grpStatus: TGroupBox
    Left = 416
    Top = 49
    Width = 832
    Height = 184
    Caption = ' Equipment status '
    TabOrder = 1
    object lblModeCaption: TLabel
      Left = 32
      Top = 24
      Width = 80
      Height = 17
      Caption = 'MODE'
    end
    object lblModeValue: TLabel
      Left = 32
      Top = 44
      Width = 135
      Height = 32
      AutoSize = False
      Caption = 'MANUAL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPhaseCaption: TLabel
      Left = 195
      Top = 24
      Width = 80
      Height = 17
      Caption = 'PHASE'
    end
    object lblPhaseValue: TLabel
      Left = 195
      Top = 44
      Width = 135
      Height = 32
      AutoSize = False
      Caption = 'READY'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPlasmaCaption: TLabel
      Left = 358
      Top = 24
      Width = 80
      Height = 17
      Caption = 'PLASMA'
    end
    object lblPlasmaValue: TLabel
      Left = 358
      Top = 44
      Width = 135
      Height = 32
      AutoSize = False
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblZCaption: TLabel
      Left = 521
      Top = 24
      Width = 120
      Height = 17
      Caption = 'CURRENT Z'
    end
    object lblZValue: TLabel
      Left = 521
      Top = 44
      Width = 135
      Height = 32
      AutoSize = False
      Caption = '80.0 mm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblWaterCaption: TLabel
      Left = 684
      Top = 24
      Width = 120
      Height = 17
      Caption = 'WATER LEVEL'
    end
    object lblWaterValue: TLabel
      Left = 684
      Top = 44
      Width = 115
      Height = 32
      AutoSize = False
      Caption = '100 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblElapsedCaption: TLabel
      Left = 32
      Top = 88
      Width = 120
      Height = 17
      Caption = 'CURRENT RUN'
    end
    object lblElapsedValue: TLabel
      Left = 32
      Top = 108
      Width = 200
      Height = 29
      AutoSize = False
      Caption = '00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblManualLimitCaption: TLabel
      Left = 280
      Top = 88
      Width = 120
      Height = 17
      Caption = 'MANUAL LIMIT'
    end
    object lblManualLimitValue: TLabel
      Left = 280
      Top = 108
      Width = 200
      Height = 29
      AutoSize = False
      Caption = '00:05:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCumulativeCaption: TLabel
      Left = 528
      Top = 88
      Width = 160
      Height = 17
      Caption = 'CUMULATIVE PLASMA'
    end
    object lblCumulativeValue: TLabel
      Left = 528
      Top = 108
      Width = 240
      Height = 29
      AutoSize = False
      Caption = '00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblActiveRecipeCaption: TLabel
      Left = 32
      Top = 154
      Width = 88
      Height = 17
      Caption = 'ACTIVE RECIPE'
    end
    object lblActiveRecipeValue: TLabel
      Left = 128
      Top = 154
      Width = 144
      Height = 17
      AutoSize = False
      Caption = 'Default'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblGasCaption: TLabel
      Left = 288
      Top = 154
      Width = 32
      Height = 17
      Caption = 'GAS'
    end
    object lblGasValue: TLabel
      Left = 328
      Top = 154
      Width = 120
      Height = 17
      AutoSize = False
      Caption = 'Ar'
    end
    object lblPowerCaption: TLabel
      Left = 472
      Top = 154
      Width = 45
      Height = 17
      Caption = 'POWER'
    end
    object lblPowerValue: TLabel
      Left = 528
      Top = 154
      Width = 96
      Height = 17
      AutoSize = False
      Caption = '100 W'
    end
    object lblProcessZCaption: TLabel
      Left = 648
      Top = 154
      Width = 61
      Height = 17
      Caption = 'PROCESS Z'
    end
    object lblProcessZValue: TLabel
      Left = 720
      Top = 154
      Width = 88
      Height = 17
      AutoSize = False
      Caption = '20.0 mm'
    end
  end
  object grpControl: TGroupBox
    Left = 32
    Top = 138
    Width = 360
    Height = 147
    Caption = ' Operator control '
    TabOrder = 2
    object lblControlNote: TLabel
      Left = 24
      Top = 20
      Width = 312
      Height = 42
      AutoSize = False
      Caption = 'Simulation only. RUN does not write to real equipment.'
      WordWrap = True
    end
    object btnRun: TButton
      Left = 24
      Top = 72
      Width = 145
      Height = 64
      Caption = 'RUN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnRunClick
    end
    object btnStop: TButton
      Left = 191
      Top = 72
      Width = 145
      Height = 64
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnStopClick
    end
  end
  object grpSensors: TGroupBox
    Left = 32
    Top = 300
    Width = 360
    Height = 264
    Caption = ' Water sensor monitor '
    TabOrder = 4
    object lblNO3Caption: TLabel
      Left = 24
      Top = 25
      Width = 120
      Height = 17
      Caption = 'NO3-  Nitrate'
    end
    object lblNO3Value: TLabel
      Left = 184
      Top = 25
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '2.00 mg/L'
    end
    object lblNO2Caption: TLabel
      Left = 24
      Top = 49
      Width = 120
      Height = 17
      Caption = 'NO2-  Nitrite'
    end
    object lblNO2Value: TLabel
      Left = 184
      Top = 49
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0.10 mg/L'
    end
    object lblECCaption: TLabel
      Left = 24
      Top = 74
      Width = 120
      Height = 17
      Caption = 'EC  Conductivity'
    end
    object lblECValue: TLabel
      Left = 184
      Top = 74
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '194 uS/cm'
    end
    object lblPHCaption: TLabel
      Left = 24
      Top = 146
      Width = 120
      Height = 17
      Caption = 'pH  Acidity'
    end
    object lblPHValue: TLabel
      Left = 184
      Top = 146
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '7.80 pH'
    end
    object lblTemperatureCaption: TLabel
      Left = 24
      Top = 170
      Width = 120
      Height = 17
      Caption = 'Temperature'
    end
    object lblTemperatureValue: TLabel
      Left = 184
      Top = 170
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '22.0 C'
    end
    object lblSensorWaterCaption: TLabel
      Left = 24
      Top = 194
      Width = 120
      Height = 17
      Caption = 'Water level'
    end
    object lblSensorWaterValue: TLabel
      Left = 184
      Top = 194
      Width = 144
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = '75 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSensorNote: TLabel
      Left = 24
      Top = 224
      Width = 304
      Height = 32
      AutoSize = False
      Caption = 'Simulation readings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblORPCaption: TLabel
      Left = 24
      Top = 122
      Width = 120
      Height = 17
      Caption = 'ORP'
    end
    object lblORPValue: TLabel
      Left = 184
      Top = 122
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '285 mV'
    end
    object lblEC2Caption: TLabel
      Left = 24
      Top = 98
      Width = 120
      Height = 17
      Caption = 'EC 2  Conductivity'
    end
    object lblEC2Value: TLabel
      Left = 184
      Top = 98
      Width = 144
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0.0 uS/cm'
    end
    object btnSensorSimulation: TButton
      Left = 24
      Top = 216
      Width = 304
      Height = 44
      Caption = 'Simulation controls'
      TabOrder = 0
      Visible = False
      OnClick = btnSensorSimulationClick
    end
  end
  object tmrSensors: TTimer
    Enabled = True
    Interval = 1000
    OnTimer = tmrSensorsTimer
    Left = 344
    Top = 270
  end
  object tmrRuntime: TTimer
    Enabled = True
    Interval = 1000
    OnTimer = tmrRuntimeTimer
    Left = 296
    Top = 270
  end
end
