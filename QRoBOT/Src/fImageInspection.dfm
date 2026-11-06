object frmImageInspection: TfrmImageInspection
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Vision Inspection'
  ClientHeight = 456
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 317
    Height = 67
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edtDir: TfoLabeledButtonEdit
      AlignWithMargins = True
      Left = 5
      Top = 25
      Width = 307
      Height = 30
      Margins.Left = 5
      Margins.Top = 25
      Margins.Right = 5
      Margins.Bottom = 0
      ChannelLink.Enabled = False
      Text = ''
      Align = alTop
      AutoSelect = False
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ButtonWidth = 17
      ExtraButtonWidth = 17
      OnButtonClick = edtDirButtonClick
      Caption = 'FOLDER NAME'
      EditLabel.Width = 87
      EditLabel.Height = 19
      EditLabel.Caption = 'FOLDER NAME'
      EditLabel.FocusControl = edtDir
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Arial Unicode MS'
      EditLabel.Font.Style = []
      EditLabel.Frame.Visible = False
      EditLabel.Layout = tlBottom
      EditLabel.ParentFont = False
    end
  end
  object listDateTime: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 70
    Width = 311
    Height = 313
    ParentCustomHint = False
    AutoComplete = False
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
  end
  object btnLoad: TcxButton
    AlignWithMargins = True
    Left = 8
    Top = 394
    Width = 142
    Height = 50
    Margins.Top = 30
    Caption = 'LOAD'
    TabOrder = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial Unicode MS'
    Font.Style = []
    ParentFont = False
    OnClick = btnLoadClick
  end
  object btnInspect: TcxButton
    AlignWithMargins = True
    Left = 167
    Top = 394
    Width = 142
    Height = 50
    Margins.Top = 30
    Caption = 'INSPECT'
    TabOrder = 3
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial Unicode MS'
    Font.Style = []
    ParentFont = False
    OnClick = btnInspectClick
  end
  object ImageDlg: TOpenPictureDialog
    DefaultExt = '.jpg'
    Filter = 'Jpg Files(*.jpg)|*.jpg|Bitmap Files (*.bmp)|*.bmp'
    Left = 397
    Top = 127
  end
  object tmrAlignTest: TTimer
    Enabled = False
    Interval = 10
    Left = 307
    Top = 131
  end
end
