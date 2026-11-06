object frmPeakDetectEdit: TfrmPeakDetectEdit
  BorderStyle = bsDialog
  Caption = 'Peak Detect Item'
  ClientHeight = 420
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object chkUse: TCheckBox
    Left = 24
    Top = 20
    Width = 120
    Height = 32
    Caption = 'Use'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object lblName: TLabel
    Left = 24
    Top = 64
    Width = 39
    Height = 19
    Caption = 'Name'
  end
  object edtName: TEdit
    Left = 24
    Top = 88
    Width = 472
    Height = 36
    TabOrder = 1
  end
  object lblWaveStart: TLabel
    Left = 24
    Top = 140
    Width = 137
    Height = 19
    Caption = 'Start wavelength (nm)'
  end
  object edtWaveStart: TEdit
    Left = 24
    Top = 164
    Width = 216
    Height = 36
    Alignment = taRightJustify
    TabOrder = 2
    Text = '400'
  end
  object lblWaveEnd: TLabel
    Left = 280
    Top = 140
    Width = 132
    Height = 19
    Caption = 'End wavelength (nm)'
  end
  object edtWaveEnd: TEdit
    Left = 280
    Top = 164
    Width = 216
    Height = 36
    Alignment = taRightJustify
    TabOrder = 3
    Text = '500'
  end
  object lblIntensityMin: TLabel
    Left = 24
    Top = 216
    Width = 118
    Height = 19
    Caption = 'Minimum intensity'
  end
  object edtIntensityMin: TEdit
    Left = 24
    Top = 240
    Width = 216
    Height = 36
    Alignment = taRightJustify
    TabOrder = 4
    Text = '10000'
  end
  object lblIntensityMax: TLabel
    Left = 280
    Top = 216
    Width = 122
    Height = 19
    Caption = 'Maximum intensity'
  end
  object edtIntensityMax: TEdit
    Left = 280
    Top = 240
    Width = 216
    Height = 36
    Alignment = taRightJustify
    TabOrder = 5
    Text = '30000'
  end
  object lblGraphColor: TLabel
    Left = 24
    Top = 292
    Width = 76
    Height = 19
    Caption = 'Graph color'
  end
  object cbGraphColor: TColorBox
    Left = 24
    Top = 316
    Width = 472
    Height = 36
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor]
    TabOrder = 6
  end
  object btnOK: TButton
    Left = 248
    Top = 368
    Width = 120
    Height = 40
    Caption = 'OK'
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 376
    Top = 368
    Width = 120
    Height = 40
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
end
