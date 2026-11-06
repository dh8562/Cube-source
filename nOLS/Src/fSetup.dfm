object frmSetup: TfrmSetup
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Setup'
  ClientHeight = 416
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcOption: TcxPageControl
    Left = 3
    Top = 8
    Width = 513
    Height = 345
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Properties.ActivePage = tsGeneral
    Properties.CustomButtons.Buttons = <>
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    ClientRectBottom = 343
    ClientRectLeft = 2
    ClientRectRight = 511
    ClientRectTop = 28
    object tsGeneral: TcxTabSheet
      Caption = 'General'
      ImageIndex = 0
      object cbComPortNo: TfoLabeledComboBox
        Left = 28
        Top = 46
        Width = 150
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'COM01'
        Items.Strings = (
          'COM01'
          'COM02'
          'COM03'
          'COM04'
          'COM05'
          'COM06'
          'COM07'
          'COM08'
          'COM09'
          'COM10')
        Caption = 'Com Port No'
        EditLabel.Width = 68
        EditLabel.Height = 17
        EditLabel.Caption = 'Com Port No'
        EditLabel.FocusControl = cbComPortNo
        EditLabel.Frame.Visible = False
        EditLabel.Layout = tlBottom
      end
      object cbLanguage: TfoLabeledComboBox
        Left = 28
        Top = 142
        Width = 150
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'English'
        Visible = False
        OnChange = cbLanguageChange
        Items.Strings = (
          'English'
          'Korean'
          'China'
          'Japan'
          'vietnam')
        Caption = 'Language'
        EditLabel.Width = 55
        EditLabel.Height = 17
        EditLabel.Caption = 'Language'
        EditLabel.FocusControl = cbLanguage
        EditLabel.Frame.Visible = False
        EditLabel.Layout = tlBottom
        EditLabel.Visible = False
      end
      object btnAutoSearch: TcxButton
        Left = 192
        Top = 44
        Width = 75
        Height = 25
        Caption = 'Search'
        TabOrder = 2
        OnClick = btnAutoSearchClick
      end
      object cxGroupBox1: TcxGroupBox
        Left = 28
        Top = 185
        Caption = 'Interface'
        TabOrder = 3
        Height = 116
        Width = 461
        object cbIFComPortNo: TfoLabeledComboBox
          Left = 24
          Top = 70
          Width = 105
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          TabOrder = 0
          Text = 'COM01'
          Items.Strings = (
            'COM01'
            'COM02'
            'COM03'
            'COM04'
            'COM05'
            'COM06'
            'COM07'
            'COM08'
            'COM09'
            'COM10')
          Caption = 'Com Port No'
          EditLabel.Width = 68
          EditLabel.Height = 17
          EditLabel.Caption = 'Com Port No'
          EditLabel.FocusControl = cbIFComPortNo
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object cbUseIF: TcxCheckBox
          Left = 24
          Top = 26
          Caption = 'Use'
          Style.TransparentBorder = False
          TabOrder = 1
        end
        object cbIFCommKind: TfoLabeledComboBox
          Left = 154
          Top = 70
          Width = 105
          Height = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          TabOrder = 2
          Text = 'COMMAND'
          Items.Strings = (
            'COMMAND'
            'TOWER LAMP')
          Caption = 'Comm Kind'
          EditLabel.Width = 60
          EditLabel.Height = 17
          EditLabel.Caption = 'Comm Kind'
          EditLabel.FocusControl = cbIFCommKind
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
      end
      object cbAlarmMode: TfoLabeledComboBox
        Left = 28
        Top = 94
        Width = 150
        Height = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 4
        Text = 'Process'
        OnChange = cbLanguageChange
        Items.Strings = (
          'Process'
          'Monitor')
        Caption = 'Alarm Mode'
        EditLabel.Width = 64
        EditLabel.Height = 17
        EditLabel.Caption = 'Alarm Mode'
        EditLabel.FocusControl = cbAlarmMode
        EditLabel.Frame.Visible = False
        EditLabel.Layout = tlBottom
      end
    end
    object tsSetup: TcxTabSheet
      Caption = 'Setup'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 271
        Top = 26
        Width = 219
        Height = 223
        Margins.Left = 5
        Margins.Right = 5
        Caption = 'ssss'
        TabOrder = 0
      end
      object gbScannerSetup: TcxGroupBox
        Left = 30
        Top = 3
        Caption = 'Scanner Setup'
        TabOrder = 1
        Height = 302
        Width = 227
        object neExposure: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 35
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 0
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Exposure (ms)'
          EditLabel.Width = 77
          EditLabel.Height = 17
          EditLabel.Caption = 'Exposure (ms)'
          EditLabel.FocusControl = neExposure
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neReadTime: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 79
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 1
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Read Time (ms)'
          EditLabel.Width = 82
          EditLabel.Height = 17
          EditLabel.Caption = 'Read Time (ms)'
          EditLabel.FocusControl = neReadTime
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neAlarmTimeSet: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 123
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 2
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Alarm Time Set (ms)'
          EditLabel.Width = 103
          EditLabel.Height = 17
          EditLabel.Caption = 'Alarm Time Set (ms)'
          EditLabel.FocusControl = neAlarmTimeSet
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neIntensityFactor: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 167
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 3
          FormatString = '%g'
          Caption = 'Intensity Factor'
          EditLabel.Width = 85
          EditLabel.Height = 17
          EditLabel.Caption = 'Intensity Factor'
          EditLabel.FocusControl = neIntensityFactor
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neAverageCount: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 211
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 4
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Average Count'
          EditLabel.Width = 81
          EditLabel.Height = 17
          EditLabel.Caption = 'Average Count'
          EditLabel.FocusControl = neAverageCount
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neAreaIntensityFactor: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 255
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 5
          FormatString = '%g'
          Caption = 'Area Intensity Factor'
          EditLabel.Width = 111
          EditLabel.Height = 17
          EditLabel.Caption = 'Area Intensity Factor'
          EditLabel.FocusControl = neAreaIntensityFactor
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
      end
      object gbGraphSetup: TcxGroupBox
        Left = 263
        Top = 12
        Caption = 'Graph Setup'
        TabOrder = 2
        Height = 293
        Width = 227
        object neWavelengthMin: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 35
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 0
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Wavelength Min'
          EditLabel.Width = 85
          EditLabel.Height = 17
          EditLabel.Caption = 'Wavelength Min'
          EditLabel.FocusControl = neWavelengthMin
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neWavelengthMax: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 79
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 1
          AllowFloat = False
          FormatString = '%d'
          Caption = 'Wavelength Max'
          EditLabel.Width = 89
          EditLabel.Height = 17
          EditLabel.Caption = 'Wavelength Max'
          EditLabel.FocusControl = neWavelengthMax
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neIntensityMin: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 123
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 2
          FormatString = '%g'
          Caption = 'Intensity Min'
          EditLabel.Width = 70
          EditLabel.Height = 17
          EditLabel.Caption = 'Intensity Min'
          EditLabel.FocusControl = neIntensityMin
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
        object neIntensityMax: TfoLabeledNumberEdit
          AlignWithMargins = True
          Left = 23
          Top = 167
          Width = 181
          Height = 21
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Align = alTop
          Alignment = taRightJustify
          TabOrder = 3
          FormatString = '%g'
          Caption = 'Intensity Max'
          EditLabel.Width = 74
          EditLabel.Height = 17
          EditLabel.Caption = 'Intensity Max'
          EditLabel.FocusControl = neIntensityMax
          EditLabel.Frame.Visible = False
          EditLabel.Layout = tlBottom
        end
      end
    end
    object tsPeakList: TcxTabSheet
      Caption = 'Peak List'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TreeListPeak: TcxVirtualTreeList
        Left = 12
        Top = 47
        Width = 487
        Height = 250
        Bands = <
          item
          end>
        Navigator.Buttons.CustomButtons = <>
        OptionsData.Editing = False
        OptionsData.Deleting = False
        OptionsSelection.CellSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.ShowRoot = False
        ScrollbarAnnotations.CustomAnnotations = <>
        TabOrder = 0
        OnDblClick = TreeListPeakDblClick
        OnGetChildCount = TreeListPeakGetChildCount
        OnGetNodeValue = TreeListPeakGetNodeValue
        OnSelectionChanged = TreeListPeakSelectionChanged
        object cxVirtualTreeList1Column1: TcxTreeListColumn
          PropertiesClassName = 'TcxCheckBoxProperties'
          Caption.Text = 'Use'
          DataBinding.ValueType = 'Boolean'
          Width = 45
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxVirtualTreeList1Column2: TcxTreeListColumn
          Caption.Text = 'Name'
          Width = 108
          Position.ColIndex = 1
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxVirtualTreeList1Column3: TcxTreeListColumn
          Caption.Text = 'WaveLength Range'
          Width = 119
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxVirtualTreeList1Column4: TcxTreeListColumn
          Caption.Text = 'Intensity Range'
          Width = 119
          Position.ColIndex = 3
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxVirtualTreeList1Column5: TcxTreeListColumn
          PropertiesClassName = 'TcxColorComboBoxProperties'
          Properties.CustomColors = <>
          Caption.Text = 'Graph Color'
          DataBinding.ValueType = 'Integer'
          Width = 94
          Position.ColIndex = 4
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
      object btnAddPeak: TcxButton
        Left = 12
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddPeakClick
      end
      object btnEditPeak: TcxButton
        Left = 93
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Edit'
        TabOrder = 2
        OnClick = btnEditPeakClick
      end
      object btnDeletePeak: TcxButton
        Left = 174
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnDeletePeakClick
      end
    end
    object tsAlarmList: TcxTabSheet
      Caption = 'Alarm'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TreeListAlarm: TcxVirtualTreeList
        Left = 12
        Top = 47
        Width = 487
        Height = 250
        Bands = <
          item
          end>
        Navigator.Buttons.CustomButtons = <>
        OptionsData.Editing = False
        OptionsData.Deleting = False
        OptionsSelection.CellSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.ShowRoot = False
        ScrollbarAnnotations.CustomAnnotations = <>
        TabOrder = 0
        OnGetChildCount = TreeListAlarmGetChildCount
        OnGetNodeValue = TreeListAlarmGetNodeValue
        OnSelectionChanged = TreeListAlarmSelectionChanged
        object cxTreeListColumn1: TcxTreeListColumn
          Caption.Text = 'Peak'
          Width = 190
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxTreeListColumn2: TcxTreeListColumn
          Caption.Text = 'Time'
          Width = 163
          Position.ColIndex = 1
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object cxTreeListColumn3: TcxTreeListColumn
          Caption.Text = 'Intensity(nW)'
          Width = 132
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
      object btnDelAlarm: TcxButton
        Left = 12
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 1
        OnClick = btnDelAlarmClick
      end
      object btnDeleteAllAlarm: TcxButton
        Left = 93
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Delete All'
        TabOrder = 2
        OnClick = btnDeleteAllAlarmClick
      end
    end
  end
  object btnClose: TcxButton
    Left = 441
    Top = 369
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnSave: TcxButton
    Left = 360
    Top = 369
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object PropSaver: TelPropSaver
    FormStateSection = 'SetupForm'
    ManageFormState = True
    SaveToRegistry = False
    Left = 230
    Top = 12
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 284
    Top = 10
  end
end
