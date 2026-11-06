object frmEditPeakItem: TfrmEditPeakItem
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit'
  ClientHeight = 326
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object gbGraphSetup: TcxGroupBox
    Left = 8
    Top = 8
    TabOrder = 0
    Height = 267
    Width = 217
    object leStartIntensity: TfoLabeledNumberEdit
      AlignWithMargins = True
      Left = 23
      Top = 157
      Width = 171
      Height = 21
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Align = alTop
      Alignment = taRightJustify
      TabOrder = 0
      FormatString = '%g'
      Caption = 'Start Intensity (mW)'
      EditLabel.Width = 107
      EditLabel.Height = 17
      EditLabel.Caption = 'Start Intensity (mW)'
      EditLabel.FocusControl = leStartIntensity
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
    end
    object leName: TfoLabeledEdit
      AlignWithMargins = True
      Left = 23
      Top = 25
      Width = 171
      Height = 21
      Margins.Left = 20
      Margins.Right = 20
      Text = ''
      Align = alTop
      TabOrder = 1
      Caption = 'Name'
      EditLabel.Width = 35
      EditLabel.Height = 17
      EditLabel.Caption = 'Name'
      EditLabel.FocusControl = leName
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
    end
    object leEndIntensity: TfoLabeledNumberEdit
      AlignWithMargins = True
      Left = 23
      Top = 201
      Width = 171
      Height = 21
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Align = alTop
      Alignment = taRightJustify
      TabOrder = 2
      FormatString = '%g'
      Caption = 'End Intensity (mW)'
      EditLabel.Width = 101
      EditLabel.Height = 17
      EditLabel.Caption = 'End Intensity (mW)'
      EditLabel.FocusControl = leEndIntensity
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
    end
    object leStartWaveLength: TfoLabeledNumberEdit
      AlignWithMargins = True
      Left = 23
      Top = 69
      Width = 171
      Height = 21
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Align = alTop
      Alignment = taRightJustify
      TabOrder = 3
      AllowFloat = False
      FormatString = '%d'
      Max = 1000.000000000000000000
      Min = 340.000000000000000000
      Value = 340.000000000000000000
      Caption = 'Start Wave Length (nm)'
      EditLabel.Width = 124
      EditLabel.Height = 17
      EditLabel.Caption = 'Start Wave Length (nm)'
      EditLabel.FocusControl = leStartWaveLength
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
    end
    object leEndWaveLength: TfoLabeledNumberEdit
      AlignWithMargins = True
      Left = 23
      Top = 113
      Width = 171
      Height = 21
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Align = alTop
      Alignment = taRightJustify
      TabOrder = 4
      AllowFloat = False
      FormatString = '%d'
      Max = 1000.000000000000000000
      Min = 340.000000000000000000
      Value = 340.000000000000000000
      Caption = 'End Wave Length (nm)'
      EditLabel.Width = 118
      EditLabel.Height = 17
      EditLabel.Caption = 'End Wave Length (nm)'
      EditLabel.FocusControl = leEndWaveLength
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
    end
    object cbUse: TCheckBox
      Left = 23
      Top = 238
      Width = 50
      Height = 17
      Caption = 'Use'
      TabOrder = 5
    end
    object cbColor: TcxColorComboBox
      Left = 96
      Top = 235
      ColorValue = clRed
      Properties.AllowSelectColor = True
      Properties.CustomColors = <>
      TabOrder = 6
      Width = 110
    end
  end
  object btnOk: TcxButton
    Left = 68
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TcxButton
    Left = 149
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PropSaver: TelPropSaver
    FormStateSection = 'EditPeakForm'
    ManageFormState = True
    SaveToRegistry = False
    Left = 108
    Top = 20
  end
end
