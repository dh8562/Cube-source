object frmRecipes: TfrmRecipes
  Caption = 'Recipes'
  AutoScroll = False
  ClientHeight = 700
  ClientWidth = 1280
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object lblTitle: TLabel
    Left = 32
    Top = 17
    Width = 76
    Height = 29
    Caption = 'Recipes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblStorage: TLabel
    Left = 32
    Top = 536
    Width = 1216
    Height = 24
    AutoSize = False
    Caption = 'Recipe storage'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object grpLibrary: TGroupBox
    Left = 32
    Top = 49
    Width = 360
    Height = 480
    Caption = ' Recipe library '
    TabOrder = 0
    object lblActiveCaption: TLabel
      Left = 16
      Top = 17
      Width = 79
      Height = 17
      Caption = 'Active recipe:'
    end
    object lblActiveRecipe: TLabel
      Left = 104
      Top = 17
      Width = 240
      Height = 17
      AutoSize = False
      Caption = 'Default'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lstRecipes: TListBox
      Left = 16
      Top = 48
      Width = 328
      Height = 304
      ItemHeight = 17
      TabOrder = 0
      OnClick = lstRecipesClick
      OnDblClick = lstRecipesDblClick
    end
    object btnRefresh: TButton
      Left = 16
      Top = 360
      Width = 96
      Height = 48
      Caption = 'Refresh'
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object btnLoad: TButton
      Left = 128
      Top = 360
      Width = 96
      Height = 48
      Caption = 'Load'
      TabOrder = 2
      OnClick = btnLoadClick
    end
    object btnDelete: TButton
      Left = 240
      Top = 360
      Width = 104
      Height = 48
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
    object btnActivate: TButton
      Left = 16
      Top = 416
      Width = 328
      Height = 48
      Caption = 'Activate selected recipe'
      TabOrder = 4
      OnClick = btnActivateClick
    end
  end
  object grpRecipe: TGroupBox
    Left = 416
    Top = 49
    Width = 832
    Height = 292
    Caption = ' Recipe parameters '
    TabOrder = 1
    object lblName: TLabel
      Left = 24
      Top = 20
      Width = 78
      Height = 17
      Caption = 'Recipe name'
    end
    object lblGas: TLabel
      Left = 24
      Top = 88
      Width = 81
      Height = 17
      Caption = 'Process gases'
    end
    object lblPower: TLabel
      Left = 24
      Top = 160
      Width = 70
      Height = 17
      Caption = 'Power (W)'
    end
    object lblSpeed: TLabel
      Left = 224
      Top = 160
      Width = 89
      Height = 17
      Caption = 'Speed (mm/s)'
    end
    object lblProcessZ: TLabel
      Left = 424
      Top = 160
      Width = 94
      Height = 17
      Caption = 'Process Z (mm)'
    end
    object lblMinLevel: TLabel
      Left = 624
      Top = 160
      Width = 145
      Height = 17
      Caption = 'Minimum water level (%)'
    end
    object edtName: TEdit
      Left = 24
      Top = 40
      Width = 776
      Height = 40
      MaxLength = 60
      TabOrder = 0
    end
    object chkH2: TCheckBox
      Left = 24
      Top = 108
      Width = 120
      Height = 40
      Caption = 'H2'
      TabOrder = 1
    end
    object chkN2: TCheckBox
      Left = 168
      Top = 108
      Width = 120
      Height = 40
      Caption = 'N2'
      TabOrder = 2
    end
    object chkAr: TCheckBox
      Left = 312
      Top = 108
      Width = 120
      Height = 40
      Caption = 'Ar'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chkO2: TCheckBox
      Left = 456
      Top = 108
      Width = 120
      Height = 40
      Caption = 'O2'
      TabOrder = 4
    end
    object edtPower: TEdit
      Left = 24
      Top = 180
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 5
      Text = '100'
    end
    object edtSpeed: TEdit
      Left = 224
      Top = 180
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 6
      Text = '10'
    end
    object edtProcessZ: TEdit
      Left = 424
      Top = 180
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 7
      Text = '20.0'
    end
    object edtMinLevel: TEdit
      Left = 624
      Top = 180
      Width = 176
      Height = 40
      Alignment = taRightJustify
      TabOrder = 8
      Text = '20'
    end
    object btnNew: TButton
      Left = 456
      Top = 232
      Width = 160
      Height = 48
      Caption = 'New recipe'
      TabOrder = 9
      OnClick = btnNewClick
    end
    object btnSaveCopy: TButton
      Left = 272
      Top = 232
      Width = 160
      Height = 48
      Caption = 'Save as copy'
      TabOrder = 10
      OnClick = btnSaveCopyClick
    end
    object btnSave: TButton
      Left = 640
      Top = 232
      Width = 160
      Height = 48
      Caption = 'Save recipe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = btnSaveClick
    end
  end
  object grpTiming: TGroupBox
    Left = 416
    Top = 356
    Width = 832
    Height = 112
    Caption = ' Plasma timing '
    TabOrder = 2
    object lblOnTime: TLabel
      Left = 24
      Top = 20
      Width = 151
      Height = 17
      Caption = 'Plasma ON time (seconds)'
    end
    object lblOffTime: TLabel
      Left = 224
      Top = 20
      Width = 156
      Height = 17
      Caption = 'Plasma OFF time (seconds)'
    end
    object lblTotalTime: TLabel
      Left = 424
      Top = 20
      Width = 147
      Height = 17
      Caption = 'AUTO total time (seconds)'
    end
    object lblManualLimit: TLabel
      Left = 624
      Top = 20
      Width = 164
      Height = 17
      Caption = 'MANUAL RUN limit (seconds)'
    end
    object edtOnTime: TEdit
      Left = 24
      Top = 44
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 0
      Text = '10'
    end
    object edtOffTime: TEdit
      Left = 224
      Top = 44
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 1
      Text = '0'
    end
    object edtTotalTime: TEdit
      Left = 424
      Top = 44
      Width = 160
      Height = 40
      Alignment = taRightJustify
      TabOrder = 2
      Text = '60'
    end
    object edtManualLimit: TEdit
      Left = 624
      Top = 44
      Width = 176
      Height = 40
      Alignment = taRightJustify
      TabOrder = 3
      Text = '300'
    end
  end
end
