object frmObjectInspector: TfrmObjectInspector
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Object Inspector'
  ClientHeight = 624
  ClientWidth = 373
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
  object pcViewers: TcxPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 367
    Height = 582
    Align = alClient
    TabOrder = 0
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 580
    ClientRectLeft = 2
    ClientRectRight = 365
    ClientRectTop = 2
  end
  object pnlCommand: TPanel
    Left = 0
    Top = 588
    Width = 373
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnClose: TcxButton
      AlignWithMargins = True
      Left = 280
      Top = 3
      Width = 90
      Height = 30
      Align = alRight
      Caption = 'Close'
      OptionsImage.ImageIndex = 0
      OptionsImage.Images = ImageList
      OptionsImage.Spacing = 8
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnRefresh: TcxButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 90
      Height = 30
      Align = alLeft
      Caption = 'Refresh'
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = ImageList
      OptionsImage.Spacing = 8
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnSyncTo: TcxButton
      AlignWithMargins = True
      Left = 99
      Top = 3
      Width = 98
      Height = 30
      Align = alLeft
      Caption = 'Sync To'
      OptionsImage.ImageIndex = 2
      OptionsImage.Images = ImageList
      OptionsImage.Spacing = 8
      TabOrder = 2
      OnClick = btnSyncToClick
    end
  end
  object ImageList: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 27525360
  end
  object PropSaver: TelPropSaver
    FormStateSection = 'DataCenterViewer'
    ManageFormState = True
    SaveToRegistry = False
    Left = 208
    Top = 420
  end
  object OpenDialog: TOpenDialog
    Filter = 'CSV Files (*.csv)|*.csv'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 275
    Top = 419
  end
end
