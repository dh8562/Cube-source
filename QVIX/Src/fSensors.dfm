object frmSensors: TfrmSensors
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Sensors'
  ClientHeight = 572
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
    Top = 24
    Width = 88
    Height = 30
    Caption = 'Sensors'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblConnection: TLabel
    Left = 736
    Top = 28
    Width = 496
    Height = 24
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'DISCONNECTED'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpSensors: TGroupBox
    Left = 32
    Top = 72
    Width = 1200
    Height = 448
    Caption = 'Water sensors'
    TabOrder = 0
    object lblHeaderSensor: TLabel
      Left = 32
      Top = 40
      Width = 160
      Height = 20
      Caption = 'SENSOR'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHeaderID: TLabel
      Left = 264
      Top = 40
      Width = 64
      Height = 20
      Caption = 'ID'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHeaderValue: TLabel
      Left = 330
      Top = 40
      Width = 760
      Height = 20
      Caption = 'READ DATA (calculated values | raw Modbus registers)'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHeaderStatus: TLabel
      Left = 1100
      Top = 40
      Width = 80
      Height = 20
      Caption = 'STATUS'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNO3Name: TLabel
      Left = 32
      Top = 80
      Width = 180
      Height = 25
      Caption = 'NO3-  Nitrate'
      Font.Height = -17
      ParentFont = False
    end
    object lblNO3ID: TLabel
      Left = 264
      Top = 80
      Width = 40
      Height = 25
      Caption = '11'
      Font.Height = -17
      ParentFont = False
    end
    object lblNO3Value: TLabel
      Left = 330
      Top = 80
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblNO3Status: TLabel
      Left = 1100
      Top = 80
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNO2Name: TLabel
      Left = 32
      Top = 136
      Width = 180
      Height = 25
      Caption = 'NO2-  Nitrite'
      Font.Height = -17
      ParentFont = False
    end
    object lblNO2ID: TLabel
      Left = 264
      Top = 136
      Width = 40
      Height = 25
      Caption = '--'
      Font.Height = -17
      ParentFont = False
    end
    object lblNO2Value: TLabel
      Left = 330
      Top = 136
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblNO2Status: TLabel
      Left = 1100
      Top = 136
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblECName: TLabel
      Left = 32
      Top = 192
      Width = 180
      Height = 25
      Caption = 'EC  Conductivity'
      Font.Height = -17
      ParentFont = False
    end
    object lblECID: TLabel
      Left = 264
      Top = 192
      Width = 40
      Height = 25
      Caption = '--'
      Font.Height = -17
      ParentFont = False
    end
    object lblECValue: TLabel
      Left = 330
      Top = 192
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblECStatus: TLabel
      Left = 1100
      Top = 192
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEC2Name: TLabel
      Left = 32
      Top = 248
      Width = 180
      Height = 25
      Caption = 'EC 2  Conductivity'
      Font.Height = -17
      ParentFont = False
    end
    object lblEC2ID: TLabel
      Left = 264
      Top = 248
      Width = 40
      Height = 25
      Caption = '14'
      Font.Height = -17
      ParentFont = False
    end
    object lblEC2Value: TLabel
      Left = 330
      Top = 248
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblEC2Status: TLabel
      Left = 1100
      Top = 248
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblORPName: TLabel
      Left = 32
      Top = 304
      Width = 180
      Height = 25
      Caption = 'ORP'
      Font.Height = -17
      ParentFont = False
    end
    object lblORPID: TLabel
      Left = 264
      Top = 304
      Width = 40
      Height = 25
      Caption = '15'
      Font.Height = -17
      ParentFont = False
    end
    object lblORPValue: TLabel
      Left = 330
      Top = 304
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblORPStatus: TLabel
      Left = 1100
      Top = 304
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPHName: TLabel
      Left = 32
      Top = 360
      Width = 180
      Height = 25
      Caption = 'pH  Acidity'
      Font.Height = -17
      ParentFont = False
    end
    object lblPHID: TLabel
      Left = 264
      Top = 360
      Width = 40
      Height = 25
      Caption = '--'
      Font.Height = -17
      ParentFont = False
    end
    object lblPHValue: TLabel
      Left = 330
      Top = 360
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblPHStatus: TLabel
      Left = 1100
      Top = 360
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTemperatureName: TLabel
      Left = 32
      Top = 416
      Width = 180
      Height = 25
      Caption = 'Temperature'
      Font.Height = -17
      ParentFont = False
    end
    object lblTemperatureID: TLabel
      Left = 264
      Top = 416
      Width = 40
      Height = 25
      Caption = '11'
      Font.Height = -17
      ParentFont = False
    end
    object lblTemperatureValue: TLabel
      Left = 330
      Top = 416
      Width = 760
      Height = 25
      AutoSize = False
      Caption = '--'
      Font.Height = -15
      ParentFont = False
    end
    object lblTemperatureStatus: TLabel
      Left = 1100
      Top = 416
      Width = 88
      Height = 25
      Caption = 'OFFLINE'
      Font.Color = clRed
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object grpRaw: TGroupBox
    Left = 824
    Top = 72
    Width = 408
    Height = 232
    Caption = 'ID 11 raw measurement'
    TabOrder = 1
    Visible = False
    object lblPXCaption: TLabel
      Left = 32
      Top = 56
      Width = 120
      Height = 25
      Caption = 'pX'
      Font.Height = -17
      ParentFont = False
    end
    object lblPXValue: TLabel
      Left = 192
      Top = 56
      Width = 160
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = '--'
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMVCaption: TLabel
      Left = 32
      Top = 120
      Width = 120
      Height = 25
      Caption = 'Electrode mV'
      Font.Height = -17
      ParentFont = False
    end
    object lblMVValue: TLabel
      Left = 192
      Top = 120
      Width = 160
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = '--'
      Font.Height = -17
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object tmrRefresh: TTimer
    Interval = 500
    OnTimer = tmrRefreshTimer
    Left = 1200
    Top = 528
  end
end
