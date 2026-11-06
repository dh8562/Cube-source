object frmFTPProgress: TfrmFTPProgress
  Left = 622
  Top = 243
  BorderStyle = bsDialog
  Caption = 'FTP Progress'
  ClientHeight = 299
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblFileNameLabel: TLabel
    Left = 23
    Top = 8
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Remote File'
    Layout = tlCenter
  end
  object lblProgressLabel: TLabel
    Left = 23
    Top = 80
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Progress'
    Layout = tlCenter
  end
  object lblFileSizeLabel: TLabel
    Left = 271
    Top = 8
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'File Size'
    Layout = tlCenter
  end
  object lblTransferredSizeLabel: TLabel
    Left = 23
    Top = 32
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Transferred'
    Layout = tlCenter
  end
  object lblTotalTimeLabel: TLabel
    Left = 271
    Top = 32
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Total Time'
    Layout = tlCenter
  end
  object lblRemainingTimeLabel: TLabel
    Left = 23
    Top = 56
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Remaining Time'
    Layout = tlCenter
  end
  object lblAvrSpeedLabel: TLabel
    Left = 271
    Top = 56
    Width = 81
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Average Speed'
    Layout = tlCenter
  end
  object PB: TProgressBar
    Left = 107
    Top = 80
    Width = 401
    Height = 21
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 431
    Top = 269
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Enabled = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object lblFileName: TEdit
    Left = 107
    Top = 8
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 2
  end
  object lblFileSIze: TEdit
    Left = 355
    Top = 8
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 3
  end
  object lblTransferredSize: TEdit
    Left = 107
    Top = 32
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 4
  end
  object lblTotalTime: TEdit
    Left = 355
    Top = 32
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 5
  end
  object lblRemainingTime: TEdit
    Left = 107
    Top = 56
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
  end
  object lblAvrSpeed: TEdit
    Left = 355
    Top = 56
    Width = 153
    Height = 21
    AutoSize = False
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentColor = True
    ReadOnly = True
    TabOrder = 7
  end
  object reMessage: TRichEdit
    Left = 104
    Top = 107
    Width = 399
    Height = 156
    TabStop = False
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    Zoom = 100
  end
  object tmrFTP: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrFTPTimer
    Left = 75
    Top = 108
  end
end
