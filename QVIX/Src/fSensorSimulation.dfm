object frmSensorSimulation: TfrmSensorSimulation
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Sensor Simulation'
  ClientHeight = 496
  ClientWidth = 520
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 24
    Top = 20
    Width = 188
    Height = 29
    Caption = 'Simulation controls'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNote: TLabel
    Left = 24
    Top = 56
    Width = 472
    Height = 40
    AutoSize = False
    Caption = 'Test values only. These controls do not write to physical sensors.'
    WordWrap = True
  end
  object lblNO3: TLabel
    Left = 24
    Top = 112
    Width = 176
    Height = 17
    Caption = 'NO3- (mg/L)'
  end
  object lblNO2: TLabel
    Left = 272
    Top = 112
    Width = 176
    Height = 17
    Caption = 'NO2- (mg/L)'
  end
  object lblEC: TLabel
    Left = 24
    Top = 184
    Width = 176
    Height = 17
    Caption = 'EC (uS/cm)'
  end
  object lblPH: TLabel
    Left = 272
    Top = 184
    Width = 176
    Height = 17
    Caption = 'pH'
  end
  object lblTemperature: TLabel
    Left = 24
    Top = 256
    Width = 176
    Height = 17
    Caption = 'Temperature (C)'
  end
  object lblWaterLevel: TLabel
    Left = 272
    Top = 256
    Width = 176
    Height = 17
    Caption = 'Water level (%)'
  end
  object lblMessage: TLabel
    Left = 24
    Top = 384
    Width = 472
    Height = 24
    AutoSize = False
  end
  object edtNO3: TEdit
    Left = 24
    Top = 136
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 0
  end
  object edtNO2: TEdit
    Left = 272
    Top = 136
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 1
  end
  object edtEC: TEdit
    Left = 24
    Top = 208
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 2
  end
  object edtPH: TEdit
    Left = 272
    Top = 208
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 3
  end
  object edtTemperature: TEdit
    Left = 24
    Top = 280
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 4
  end
  object edtWaterLevel: TEdit
    Left = 272
    Top = 280
    Width = 224
    Height = 25
    Alignment = taRightJustify
    TabOrder = 5
  end
  object chkNO3Online: TCheckBox
    Left = 160
    Top = 104
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object chkNO2Online: TCheckBox
    Left = 408
    Top = 104
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object chkECOnline: TCheckBox
    Left = 160
    Top = 176
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object chkPHOnline: TCheckBox
    Left = 408
    Top = 176
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 13
  end
  object chkTemperatureOnline: TCheckBox
    Left = 160
    Top = 248
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object chkWaterOnline: TCheckBox
    Left = 408
    Top = 248
    Width = 88
    Height = 25
    Caption = 'Online'
    Checked = True
    State = cbChecked
    TabOrder = 15
  end
  object chkTrend: TCheckBox
    Left = 24
    Top = 328
    Width = 296
    Height = 32
    Caption = 'Automatic demo trend during RUN'
    TabOrder = 6
  end
  object btnRestore: TButton
    Left = 336
    Top = 324
    Width = 160
    Height = 40
    Caption = 'Restore demo values'
    TabOrder = 7
    OnClick = btnRestoreClick
  end
  object btnCancel: TButton
    Left = 216
    Top = 432
    Width = 136
    Height = 40
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 360
    Top = 432
    Width = 136
    Height = 40
    Caption = 'Apply values'
    Default = True
    TabOrder = 9
    OnClick = btnApplyClick
  end
end
