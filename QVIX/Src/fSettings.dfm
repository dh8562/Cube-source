object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'QVIX - Settings'
  ClientHeight = 640
  ClientWidth = 760
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 24
    Top = 16
    Width = 80
    Height = 30
    Caption = 'Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblMessage: TLabel
    Left = 24
    Top = 560
    Width = 712
    Height = 24
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pcSettings: TPageControl
    Left = 24
    Top = 56
    Width = 712
    Height = 496
    ActivePage = tsQOLS
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      object lblGeneralNote: TLabel
        Left = 24
        Top = 72
        Width = 640
        Height = 64
        AutoSize = False
        Caption = 
          'Simulation mode prevents commands from being sent to physical eq' +
          'uipment. Restarting QVIX opens in Operator mode.'
        WordWrap = True
      end
      object lblRuntimeCaption: TLabel
        Left = 24
        Top = 176
        Width = 157
        Height = 17
        Caption = 'Cumulative plasma runtime'
      end
      object lblRuntimeValue: TLabel
        Left = 24
        Top = 204
        Width = 240
        Height = 32
        AutoSize = False
        Caption = '00:00:00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -21
        Font.Name = 'Consolas'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object chkSimulationMode: TCheckBox
        Left = 24
        Top = 24
        Width = 240
        Height = 32
        Caption = 'Simulation mode'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object btnResetRuntime: TButton
        Left = 288
        Top = 196
        Width = 176
        Height = 40
        Caption = 'Reset runtime'
        Enabled = False
        TabOrder = 1
        OnClick = btnResetRuntimeClick
      end
    end
    object tsZAxis: TTabSheet
      Caption = 'Z Axis'
      object lblZPort: TLabel
        Left = 24
        Top = 24
        Width = 58
        Height = 17
        Caption = 'COM Port'
      end
      object lblZBaud: TLabel
        Left = 208
        Top = 24
        Width = 56
        Height = 17
        Caption = 'Baud rate'
      end
      object lblZMin: TLabel
        Left = 24
        Top = 104
        Width = 88
        Height = 17
        Caption = 'Minimum (mm)'
      end
      object lblZMax: TLabel
        Left = 208
        Top = 104
        Width = 91
        Height = 17
        Caption = 'Maximum (mm)'
      end
      object lblZHome: TLabel
        Left = 392
        Top = 104
        Width = 72
        Height = 17
        Caption = 'HOME (mm)'
      end
      object lblZJog: TLabel
        Left = 24
        Top = 184
        Width = 87
        Height = 17
        Caption = 'JOG step (mm)'
      end
      object lblZPulsesPerMm: TLabel
        Left = 208
        Top = 184
        Width = 90
        Height = 17
        Caption = 'Pulses per mm'
      end
      object cmbZPort: TComboBox
        Left = 24
        Top = 48
        Width = 152
        Height = 25
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbZBaud: TComboBox
        Left = 208
        Top = 48
        Width = 152
        Height = 25
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object edtZMin: TEdit
        Left = 24
        Top = 128
        Width = 152
        Height = 25
        Alignment = taRightJustify
        TabOrder = 2
        Text = '0.0'
      end
      object edtZMax: TEdit
        Left = 208
        Top = 128
        Width = 152
        Height = 25
        Alignment = taRightJustify
        TabOrder = 3
        Text = '80.0'
      end
      object edtZHome: TEdit
        Left = 392
        Top = 128
        Width = 152
        Height = 25
        Alignment = taRightJustify
        TabOrder = 4
        Text = '80.0'
      end
      object edtZJog: TEdit
        Left = 24
        Top = 208
        Width = 152
        Height = 25
        Alignment = taRightJustify
        TabOrder = 5
        Text = '1.0'
      end
      object edtZPulsesPerMm: TEdit
        Left = 208
        Top = 208
        Width = 152
        Height = 25
        Alignment = taRightJustify
        TabOrder = 6
        Text = '1000'
      end
    end
    object tsQOLS: TTabSheet
      Caption = 'Q-OLS'
      object lblQOLSPort: TLabel
        Left = 24
        Top = 20
        Width = 58
        Height = 17
        Caption = 'COM Port'
      end
      object lblQOLSBaud: TLabel
        Left = 184
        Top = 20
        Width = 56
        Height = 17
        Caption = 'Baud rate'
      end
      object lblQOLSKind: TLabel
        Left = 344
        Top = 20
        Width = 107
        Height = 17
        Caption = 'Spectrometer kind'
      end
      object lblExposure: TLabel
        Left = 24
        Top = 96
        Width = 83
        Height = 17
        Caption = 'Exposure (ms)'
      end
      object lblReadTime: TLabel
        Left = 184
        Top = 96
        Width = 88
        Height = 17
        Caption = 'Read time (ms)'
      end
      object lblWaveStart: TLabel
        Left = 24
        Top = 172
        Width = 126
        Height = 17
        Caption = 'Start wavelength (nm)'
      end
      object lblWaveEnd: TLabel
        Left = 184
        Top = 172
        Width = 121
        Height = 17
        Caption = 'End wavelength (nm)'
      end
      object lblIntensityMin: TLabel
        Left = 344
        Top = 172
        Width = 105
        Height = 17
        Caption = 'Minimum intensity'
      end
      object lblIntensityMax: TLabel
        Left = 504
        Top = 172
        Width = 108
        Height = 17
        Caption = 'Maximum intensity'
      end
      object cmbQOLSPort: TComboBox
        Left = 24
        Top = 44
        Width = 136
        Height = 25
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbQOLSBaud: TComboBox
        Left = 184
        Top = 44
        Width = 136
        Height = 25
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object cmbQOLSKind: TComboBox
        Left = 344
        Top = 44
        Width = 136
        Height = 25
        Style = csDropDownList
        TabOrder = 2
        Items.Strings = (
          'OLD'
          'NEW'
          'QMINI')
      end
      object edtExposure: TEdit
        Left = 24
        Top = 120
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 3
        Text = '10'
      end
      object edtReadTime: TEdit
        Left = 184
        Top = 120
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 4
        Text = '100'
      end
      object edtWaveStart: TEdit
        Left = 24
        Top = 196
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 5
        Text = '760'
      end
      object edtWaveEnd: TEdit
        Left = 184
        Top = 196
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 6
        Text = '790'
      end
      object edtIntensityMin: TEdit
        Left = 344
        Top = 196
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 7
        Text = '2000'
      end
      object edtIntensityMax: TEdit
        Left = 504
        Top = 196
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 8
        Text = '8000'
      end
      object lblPeakDevice: TLabel
        Left = 24
        Top = 236
        Width = 135
        Height = 17
        Caption = 'Peak Detect List / No.'
      end
      object cmbPeakDevice: TComboBox
        Left = 24
        Top = 260
        Width = 152
        Height = 25
        Style = csDropDownList
        TabOrder = 9
        OnChange = cmbPeakDeviceChange
        Items.Strings = (
          'No. 1'
          'No. 2')
      end
      object btnPeakAdd: TButton
        Left = 208
        Top = 252
        Width = 120
        Height = 40
        Caption = 'Add'
        TabOrder = 10
        OnClick = btnPeakAddClick
      end
      object btnPeakEdit: TButton
        Left = 344
        Top = 252
        Width = 120
        Height = 40
        Caption = 'Edit'
        TabOrder = 11
        OnClick = btnPeakEditClick
      end
      object btnPeakDelete: TButton
        Left = 480
        Top = 252
        Width = 120
        Height = 40
        Caption = 'Delete'
        TabOrder = 12
        OnClick = btnPeakDeleteClick
      end
      object lvPeakList: TListView
        Left = 24
        Top = 304
        Width = 640
        Height = 144
        Checkboxes = True
        Columns = <
          item
            Caption = 'Name'
            Width = 130
          end
          item
            Alignment = taRightJustify
            Caption = 'Start nm'
            Width = 75
          end
          item
            Alignment = taRightJustify
            Caption = 'End nm'
            Width = 75
          end
          item
            Alignment = taRightJustify
            Caption = 'Min intensity'
            Width = 105
          end
          item
            Alignment = taRightJustify
            Caption = 'Max intensity'
            Width = 105
          end
          item
            Caption = 'Graph color'
            Width = 120
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 13
        ViewStyle = vsReport
      end
    end
    object tsSafety: TTabSheet
      Caption = 'Safety'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblMinimumWater: TLabel
        Left = 24
        Top = 88
        Width = 143
        Height = 17
        Caption = 'Minimum water level (%)'
      end
      object lblManualLimit: TLabel
        Left = 232
        Top = 88
        Width = 172
        Height = 17
        Caption = 'MANUAL RUN limit (seconds)'
      end
      object chkUseSensorStops: TCheckBox
        Left = 24
        Top = 24
        Width = 240
        Height = 32
        Caption = 'Use sensor stop conditions'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object edtMinimumWater: TEdit
        Left = 24
        Top = 112
        Width = 160
        Height = 25
        Alignment = taRightJustify
        TabOrder = 1
        Text = '20'
      end
      object edtManualLimit: TEdit
        Left = 232
        Top = 112
        Width = 160
        Height = 25
        Alignment = taRightJustify
        TabOrder = 2
        Text = '300'
      end
    end
    object tsCommunication: TTabSheet
      Caption = 'Communication'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblCommDevice: TLabel
        Left = 24
        Top = 20
        Width = 38
        Height = 17
        Caption = 'Device'
      end
      object lblCommPort: TLabel
        Left = 232
        Top = 20
        Width = 43
        Height = 17
        Caption = 'PC Port'
      end
      object lblCommBaud: TLabel
        Left = 368
        Top = 20
        Width = 56
        Height = 17
        Caption = 'Baud rate'
      end
      object lblCommType: TLabel
        Left = 504
        Top = 20
        Width = 27
        Height = 17
        Caption = 'Type'
      end
      object lblWaterBus: TLabel
        Left = 24
        Top = 56
        Width = 176
        Height = 25
        AutoSize = False
        Caption = 'Water sensors x5'
      end
      object lblWaterBusType: TLabel
        Left = 504
        Top = 56
        Width = 152
        Height = 25
        AutoSize = False
        Caption = 'RS-485 Modbus RTU'
      end
      object lblLevelSensor: TLabel
        Left = 24
        Top = 104
        Width = 176
        Height = 25
        AutoSize = False
        Caption = 'Level sensor SEN0311'
      end
      object lblLevelType: TLabel
        Left = 504
        Top = 104
        Width = 152
        Height = 25
        AutoSize = False
        Caption = 'RS-232C to TTL'
      end
      object lblPlasmaPSU: TLabel
        Left = 24
        Top = 152
        Width = 176
        Height = 25
        AutoSize = False
        Caption = 'Plasma PSU'
      end
      object lblPlasmaType: TLabel
        Left = 504
        Top = 152
        Width = 152
        Height = 25
        AutoSize = False
        Caption = 'RS-485 + Remote I/O'
      end
      object lblRemoteIO: TLabel
        Left = 24
        Top = 200
        Width = 176
        Height = 25
        AutoSize = False
        Caption = 'Remote I/O'
      end
      object lblRemoteIOType: TLabel
        Left = 504
        Top = 200
        Width = 152
        Height = 25
        AutoSize = False
        Caption = 'Digital I/O'
      end
      object lblMFM: TLabel
        Left = 24
        Top = 248
        Width = 176
        Height = 25
        AutoSize = False
        Caption = 'MFM x3'
      end
      object lblMFMType: TLabel
        Left = 504
        Top = 248
        Width = 152
        Height = 25
        AutoSize = False
        Caption = 'Protocol TBD'
      end
      object lblCommunicationNote: TLabel
        Left = 24
        Top = 304
        Width = 632
        Height = 48
        AutoSize = False
        Caption = 
          'Basic assignments only. These values do not open ports or transm' +
          'it data. Device protocols will be implemented separately.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object cmbWaterBusPort: TComboBox
        Left = 232
        Top = 52
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 4
        TabOrder = 0
        Text = 'COM5'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbWaterBusBaud: TComboBox
        Left = 368
        Top = 52
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 1
        Text = '9600'
        Items.Strings = (
          '4800'
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object cmbLevelPort: TComboBox
        Left = 232
        Top = 100
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'COM1'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbLevelBaud: TComboBox
        Left = 368
        Top = 100
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 3
        Text = '9600'
        Items.Strings = (
          '4800'
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object cmbPlasmaPort: TComboBox
        Left = 232
        Top = 148
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 5
        TabOrder = 4
        Text = 'COM6'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbPlasmaBaud: TComboBox
        Left = 368
        Top = 148
        Width = 112
        Height = 25
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 5
        Text = '9600'
        Items.Strings = (
          '4800'
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object cmbRemoteIOPort: TComboBox
        Left = 232
        Top = 196
        Width = 248
        Height = 25
        Style = csDropDownList
        ItemIndex = 4
        TabOrder = 6
        Text = 'COM5'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbMFMPort: TComboBox
        Left = 232
        Top = 244
        Width = 248
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 7
        Text = 'COM1'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
    end
    object tsSensorRules: TTabSheet
      Caption = 'Sensor Rules'
      ImageIndex = 5
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblRuleOperator: TLabel
        Left = 288
        Top = 20
        Width = 61
        Height = 17
        Caption = 'Stop when'
      end
      object lblRuleTarget: TLabel
        Left = 456
        Top = 20
        Width = 37
        Height = 17
        Caption = 'Target'
      end
      object lblRuleNote: TLabel
        Left = 24
        Top = 304
        Width = 616
        Height = 48
        AutoSize = False
        Caption = 
          'Enabled rules use OR logic. Water level safety remains active ev' +
          'en when sensor stop conditions are disabled on the Safety tab.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object chkNO3Rule: TCheckBox
        Left = 24
        Top = 52
        Width = 224
        Height = 25
        Caption = 'NO3-  Nitrate (mg/L)'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cmbNO3Operator: TComboBox
        Left = 288
        Top = 52
        Width = 136
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = 'At or above'
        Items.Strings = (
          'At or above'
          'At or below')
      end
      object edtNO3Target: TEdit
        Left = 456
        Top = 52
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 2
        Text = '10'
      end
      object chkNO2Rule: TCheckBox
        Left = 24
        Top = 100
        Width = 224
        Height = 25
        Caption = 'NO2-  Nitrite (mg/L)'
        TabOrder = 3
      end
      object cmbNO2Operator: TComboBox
        Left = 288
        Top = 100
        Width = 136
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'At or above'
        Items.Strings = (
          'At or above'
          'At or below')
      end
      object edtNO2Target: TEdit
        Left = 456
        Top = 100
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 5
        Text = '1'
      end
      object chkECRule: TCheckBox
        Left = 24
        Top = 148
        Width = 224
        Height = 25
        Caption = 'EC  Conductivity (uS/cm)'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object cmbECOperator: TComboBox
        Left = 288
        Top = 148
        Width = 136
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 7
        Text = 'At or above'
        Items.Strings = (
          'At or above'
          'At or below')
      end
      object edtECTarget: TEdit
        Left = 456
        Top = 148
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 8
        Text = '500'
      end
      object chkPHRule: TCheckBox
        Left = 24
        Top = 196
        Width = 224
        Height = 25
        Caption = 'pH  Acidity'
        TabOrder = 9
      end
      object cmbPHOperator: TComboBox
        Left = 288
        Top = 196
        Width = 136
        Height = 25
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 10
        Text = 'At or below'
        Items.Strings = (
          'At or above'
          'At or below')
      end
      object edtPHTarget: TEdit
        Left = 456
        Top = 196
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 11
        Text = '6.5'
      end
      object chkTemperatureRule: TCheckBox
        Left = 24
        Top = 244
        Width = 224
        Height = 25
        Caption = 'Temperature (C)'
        Checked = True
        State = cbChecked
        TabOrder = 12
      end
      object cmbTemperatureOperator: TComboBox
        Left = 288
        Top = 244
        Width = 136
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 13
        Text = 'At or above'
        Items.Strings = (
          'At or above'
          'At or below')
      end
      object edtTemperatureTarget: TEdit
        Left = 456
        Top = 244
        Width = 136
        Height = 25
        Alignment = taRightJustify
        TabOrder = 14
        Text = '35'
      end
    end
    object tsSensorTest: TTabSheet
      Caption = 'Sensor Test'
      ImageIndex = 6
      object lblSensorTestPort: TLabel
        Left = 24
        Top = 20
        Width = 160
        Height = 17
        Caption = 'Water sensor Modbus RTU'
      end
      object lblSensorTestSlave: TLabel
        Left = 24
        Top = 92
        Width = 128
        Height = 17
        Caption = 'Slave IDs (comma)'
      end
      object lblSensorTestFunction: TLabel
        Left = 144
        Top = 92
        Width = 52
        Height = 17
        Caption = 'Function'
      end
      object lblSensorTestAddress: TLabel
        Left = 352
        Top = 92
        Width = 85
        Height = 17
        Caption = 'Start address'
      end
      object lblSensorTestQuantity: TLabel
        Left = 488
        Top = 92
        Width = 52
        Height = 17
        Caption = 'Quantity'
      end
      object lblSensorTestStatus: TLabel
        Left = 24
        Top = 176
        Width = 632
        Height = 24
        AutoSize = False
        Caption = 'Disconnected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cmbSensorTestPort: TComboBox
        Left = 24
        Top = 44
        Width = 136
        Height = 40
        Style = csDropDownList
        ItemIndex = 4
        TabOrder = 0
        Text = 'COM5'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cmbSensorTestBaud: TComboBox
        Left = 176
        Top = 44
        Width = 136
        Height = 40
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 1
        Text = '9600'
        Items.Strings = (
          '4800'
          '9600'
          '19200'
          '38400'
          '115200')
      end
      object edtSensorTestSlave: TEdit
        Left = 24
        Top = 116
        Width = 104
        Height = 40
        TabOrder = 2
        Text = '14'
      end
      object cmbSensorTestFunction: TComboBox
        Left = 144
        Top = 116
        Width = 192
        Height = 40
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = '03 Holding Registers'
        Items.Strings = (
          '03 Holding Registers'
          '04 Input Registers')
      end
      object edtSensorTestAddress: TEdit
        Left = 352
        Top = 116
        Width = 120
        Height = 40
        TabOrder = 4
        Text = '0'
      end
      object edtSensorTestQuantity: TEdit
        Left = 488
        Top = 116
        Width = 80
        Height = 40
        TabOrder = 5
        Text = '5'
      end
      object btnSensorConnect: TButton
        Left = 328
        Top = 36
        Width = 152
        Height = 48
        Caption = 'CONNECT / READ'
        TabOrder = 6
        OnClick = btnSensorConnectClick
      end
      object btnSensorDisconnect: TButton
        Left = 496
        Top = 36
        Width = 152
        Height = 48
        Caption = 'DISCONNECT'
        TabOrder = 7
        OnClick = btnSensorDisconnectClick
      end
      object memSensorTestResult: TMemo
        Left = 24
        Top = 208
        Width = 624
        Height = 224
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 8
      end
    end
    object tsAccess: TTabSheet
      Caption = 'Access'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblPassword: TLabel
        Left = 24
        Top = 120
        Width = 121
        Height = 17
        Caption = 'Developer password'
      end
      object lblAccessNote: TLabel
        Left = 216
        Top = 148
        Width = 213
        Height = 15
        Caption = 'Temporary development password: 1234'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object rbOperator: TRadioButton
        Left = 24
        Top = 24
        Width = 240
        Height = 32
        Caption = 'Operator'
        TabOrder = 0
        OnClick = AccessClick
      end
      object rbDeveloper: TRadioButton
        Left = 280
        Top = 24
        Width = 240
        Height = 32
        Caption = 'Developer'
        TabOrder = 1
        OnClick = AccessClick
      end
      object edtPassword: TEdit
        Left = 24
        Top = 144
        Width = 168
        Height = 25
        PasswordChar = '*'
        TabOrder = 2
      end
    end
  end
  object btnCancel: TButton
    Left = 448
    Top = 592
    Width = 136
    Height = 40
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 600
    Top = 592
    Width = 136
    Height = 40
    Caption = 'Apply settings'
    Default = True
    TabOrder = 2
    OnClick = btnApplyClick
  end
end
