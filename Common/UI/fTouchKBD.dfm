object frmTouchKBD: TfrmTouchKBD
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Virtual Keyboard'
  ClientHeight = 363
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Padding.Left = 4
  Padding.Top = 4
  Padding.Right = 4
  Padding.Bottom = 4
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object feValue: TEdit
    AlignWithMargins = True
    Left = 4
    Top = 4
    Width = 859
    Height = 21
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 8
    Text = ''
    Align = alTop
    ImeName = '<'#45216#44060#49483'> '#54620#44544' '#51077#47141#44592' (IME)'
    TabOrder = 0
    ExplicitTop = 6
  end
  object TouchKeyboard: TTouchKeyboard
    Left = 4
    Top = 33
    Width = 859
    Height = 326
    Align = alClient
    Color = clBtnFace
    GradientEnd = clSilver
    GradientStart = clGray
    Layout = 'Standard'
    ParentColor = False
  end
end
