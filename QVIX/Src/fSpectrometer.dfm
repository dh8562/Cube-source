object frmSpectrometer: TfrmSpectrometer
  Caption = 'Spectrometer'
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
    Width = 131
    Height = 29
    Caption = 'Spectrometer'
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
    Caption = ' Q-OLS Connection '
    TabOrder = 0
    object lblConnectionStatus: TLabel
      Left = 180
      Top = 34
      Width = 240
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
      Width = 132
      Height = 40
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnConnectClick
    end
  end
  object grpMeasurement: TGroupBox
    Left = 32
    Top = 133
    Width = 1216
    Height = 108
    Caption = ' Q-OLS v3.0 '#183' Spectrometer S1 / CH01 '
    TabOrder = 1
    object lblChannelCaption: TLabel
      Left = 24
      Top = 22
      Width = 64
      Height = 17
      Caption = 'CHANNEL'
    end
    object lblChannelValue: TLabel
      Left = 24
      Top = 39
      Width = 128
      Height = 32
      Caption = 'S1 / CH01'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblWavelengthCaption: TLabel
      Left = 200
      Top = 22
      Width = 130
      Height = 17
      Caption = 'PEAK WAVELENGTH'
    end
    object lblWavelengthValue: TLabel
      Left = 200
      Top = 39
      Width = 184
      Height = 32
      Caption = '777.4 nm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIntensityCaption: TLabel
      Left = 416
      Top = 22
      Width = 104
      Height = 17
      Caption = 'PEAK INTENSITY'
    end
    object lblIntensityValue: TLabel
      Left = 416
      Top = 39
      Width = 216
      Height = 32
      Caption = '0 counts'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2171169
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblOpticalStatusCaption: TLabel
      Left = 664
      Top = 22
      Width = 104
      Height = 17
      Caption = 'OPTICAL STATUS'
    end
    object lblOpticalStatusValue: TLabel
      Left = 664
      Top = 39
      Width = 200
      Height = 32
      Caption = 'IDLE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnStart: TButton
      Left = 912
      Top = 29
      Width = 128
      Height = 56
      Caption = 'START'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TButton
      Left = 1056
      Top = 29
      Width = 128
      Height = 56
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnStopClick
    end
  end
  object grpLimits: TGroupBox
    Left = 32
    Top = 255
    Width = 376
    Height = 220
    Caption = ' Optical limits '
    TabOrder = 2
    object lblStartWavelengthCaption: TLabel
      Left = 24
      Top = 20
      Width = 122
      Height = 17
      Caption = 'Start wavelength (nm)'
    end
    object lblEndWavelengthCaption: TLabel
      Left = 200
      Top = 20
      Width = 117
      Height = 17
      Caption = 'End wavelength (nm)'
    end
    object lblMinCaption: TLabel
      Left = 24
      Top = 92
      Width = 121
      Height = 17
      Caption = 'Minimum intensity'
    end
    object lblMaxCaption: TLabel
      Left = 200
      Top = 92
      Width = 125
      Height = 17
      Caption = 'Maximum intensity'
    end
    object edtStartWavelength: TEdit
      Left = 24
      Top = 40
      Width = 144
      Height = 40
      Alignment = taRightJustify
      TabOrder = 0
      Text = '760'
    end
    object edtEndWavelength: TEdit
      Left = 200
      Top = 40
      Width = 144
      Height = 40
      Alignment = taRightJustify
      TabOrder = 1
      Text = '790'
    end
    object edtMinIntensity: TEdit
      Left = 24
      Top = 112
      Width = 144
      Height = 40
      Alignment = taRightJustify
      TabOrder = 2
      Text = '2000'
    end
    object edtMaxIntensity: TEdit
      Left = 200
      Top = 112
      Width = 144
      Height = 40
      Alignment = taRightJustify
      TabOrder = 3
      Text = '8000'
    end
    object btnApplyLimits: TButton
      Left = 24
      Top = 164
      Width = 320
      Height = 44
      Caption = 'Apply optical limits'
      TabOrder = 4
      OnClick = btnApplyLimitsClick
    end
  end
  object grpSpectrum: TGroupBox
    Left = 432
    Top = 255
    Width = 816
    Height = 182
    Caption = ' Spectrum '
    TabOrder = 3
    object pbSpectrum: TPaintBox
      Left = 16
      Top = 17
      Width = 784
      Height = 152
      OnPaint = pbSpectrumPaint
    end
  end
  object tmrMeasurement: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrMeasurementTimer
    Left = 1200
    Top = 516
  end
end
