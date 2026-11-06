object frmLogs: TfrmLogs
  Left = 0
  Top = 0
  Caption = 'Logs'
  AutoScroll = False
  ClientHeight = 700
  ClientWidth = 1280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 32
    Top = 17
    Width = 138
    Height = 29
    Caption = 'Integrated Logs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblFileCaption: TLabel
    Left = 32
    Top = 47
    Width = 50
    Height = 17
    Caption = 'Log file:'
  end
  object lblFileName: TLabel
    Left = 96
    Top = 47
    Width = 1000
    Height = 17
    AutoSize = False
    Caption = 'QRoBOT.log'
  end
  object tlLogs: TcxTreeList
    Left = 32
    Top = 69
    Width = 1216
    Height = 416
    Bands = <
      item
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.ImmediateEditor = False
    OptionsCustomizing.BandCustomizing = False
    OptionsCustomizing.BandMoving = False
    OptionsCustomizing.ColumnMoving = False
    OptionsData.Editing = False
    OptionsData.MultiThreadedSorting = bFalse
    OptionsSelection.CellSelect = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.HeaderAutoHeight = True
    OptionsView.Headers = True
    OptionsView.ShowRoot = False
    ScrollbarAnnotations.CustomAnnotations = <>
    TabOrder = 0
    object colDateTime: TcxTreeListColumn
      Caption.Text = 'Date / Time'
      Options.Editing = False
      Options.Moving = False
      Options.Sorting = False
      Width = 180
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colSource: TcxTreeListColumn
      Caption.Text = 'Source'
      Options.Editing = False
      Options.Moving = False
      Options.Sorting = False
      Width = 140
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colMessage: TcxTreeListColumn
      Caption.Text = 'Message'
      Options.Editing = False
      Options.Moving = False
      Options.Sorting = False
      Width = 860
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object btnClear: TButton
    Left = 1088
    Top = 500
    Width = 160
    Height = 40
    Caption = 'Clear all logs'
    TabOrder = 1
    OnClick = btnClearClick
  end
  object chkShowDateTime: TCheckBox
    Left = 32
    Top = 505
    Width = 200
    Height = 40
    Caption = 'Show date and time'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = chkShowDateTimeClick
  end
  object tmrUpdate: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrUpdateTimer
    Left = 1024
    Top = 500
  end
end
