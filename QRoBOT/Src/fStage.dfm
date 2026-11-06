object frmStage: TfrmStage
  Caption = 'Stage (X / Y / Z)'
  AutoScroll = False
  ClientHeight = 700
  ClientWidth = 1280
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object lblTitle: TLabel
    Left = 24
    Top = 16
    Width = 190
    Height = 28
    Caption = 'Stage (X / Y / Z)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2171169
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpConnection: TGroupBox
    Left = 24
    Top = 52
    Width = 1232
    Height = 80
    Caption = ' Stage controller '
    TabOrder = 0
    object lblConnectionCaption: TLabel
      Left = 24
      Top = 34
      Width = 82
      Height = 20
      Caption = 'Connection'
      Visible = False
    end
    object lblConnectionStatus: TLabel
      Left = 216
      Top = 34
      Width = 160
      Height = 25
      Caption = 'DISCONNECTED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblControllerCaption: TLabel
      Left = 480
      Top = 34
      Width = 74
      Height = 20
      Caption = 'Controller'
    end
    object lblControllerValue: TLabel
      Left = 576
      Top = 34
      Width = 235
      Height = 20
      Caption = 'Waiting for controller connection'
    end
    object btnConnect: TButton
      Left = 24
      Top = 29
      Width = 160
      Height = 40
      Caption = 'Connect'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnConnectClick
    end
  end
  object grpPosition: TGroupBox
    Left = 24
    Top = 144
    Width = 1232
    Height = 158
    Caption = ' Current position '
    TabOrder = 1
    object panX: TPanel
      Left = 24
      Top = 30
      Width = 376
      Height = 104
      BevelOuter = bvNone
      Color = 15133170
      ParentBackground = False
      TabOrder = 0
      object lblXCaption: TLabel
        Left = 16
        Top = 12
        Width = 65
        Height = 20
        Caption = 'X position'
      end
      object lblXValue: TLabel
        Left = 16
        Top = 40
        Width = 329
        Height = 45
        AutoSize = False
        Caption = '0.000 mm'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -32
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object panY: TPanel
      Left = 424
      Top = 30
      Width = 376
      Height = 104
      BevelOuter = bvNone
      Color = 15133170
      ParentBackground = False
      TabOrder = 1
      object lblYCaption: TLabel
        Left = 16
        Top = 12
        Width = 65
        Height = 20
        Caption = 'Y position'
      end
      object lblYValue: TLabel
        Left = 16
        Top = 40
        Width = 329
        Height = 45
        AutoSize = False
        Caption = '0.000 mm'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -32
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object panZ: TPanel
      Left = 824
      Top = 30
      Width = 376
      Height = 104
      BevelOuter = bvNone
      Color = 15133170
      ParentBackground = False
      TabOrder = 2
      object lblZCaption: TLabel
        Left = 16
        Top = 12
        Width = 65
        Height = 20
        Caption = 'Z position'
      end
      object lblZValue: TLabel
        Left = 16
        Top = 40
        Width = 329
        Height = 45
        AutoSize = False
        Caption = '0.000 mm'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2171169
        Font.Height = -32
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object grpRecipe: TGroupBox
    Left = 24
    Top = 314
    Width = 600
    Height = 274
    Caption = ' Tool recipe control '
    TabOrder = 2
    object lblRecipeCaption: TLabel
      Left = 24
      Top = 36
      Width = 70
      Height = 20
      Caption = 'Recipe No.'
    end
    object lblRecipeNameCaption: TLabel
      Left = 24
      Top = 84
      Width = 86
      Height = 20
      Caption = 'Active recipe'
    end
    object lblRecipeName: TLabel
      Left = 144
      Top = 84
      Width = 134
      Height = 20
      Caption = 'No recipe selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtRecipeNo: TEdit
      Left = 144
      Top = 29
      Width = 160
      Height = 36
      Alignment = taCenter
      ReadOnly = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'CURRENT'
    end
    object btnHomeAll: TButton
      Left = 24
      Top = 132
      Width = 168
      Height = 72
      Caption = 'ALL HOME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnHomeAllClick
    end
    object btnStart: TButton
      Left = 208
      Top = 132
      Width = 168
      Height = 72
      Caption = 'RECIPE START'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnStartClick
    end
    object btnStop: TButton
      Left = 392
      Top = 132
      Width = 168
      Height = 72
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnStopClick
    end
  end
  object grpStatus: TGroupBox
    Left = 640
    Top = 314
    Width = 616
    Height = 274
    Caption = ' Controller status '
    TabOrder = 3
    object lblRunCaption: TLabel
      Left = 24
      Top = 40
      Width = 77
      Height = 20
      Caption = 'Run status'
    end
    object lblRunStatus: TLabel
      Left = 184
      Top = 40
      Width = 72
      Height = 20
      Caption = 'STOPPED'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHomeCaption: TLabel
      Left = 24
      Top = 78
      Width = 89
      Height = 20
      Caption = 'Home status'
    end
    object lblHomeStatus: TLabel
      Left = 184
      Top = 78
      Width = 88
      Height = 20
      Caption = 'NOT HOMED'
      Font.Color = clRed
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCompleteCaption: TLabel
      Left = 24
      Top = 116
      Width = 75
      Height = 20
      Caption = 'Completion'
    end
    object lblCompleteStatus: TLabel
      Left = 184
      Top = 116
      Width = 18
      Height = 20
      Caption = '---'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblErrorCaption: TLabel
      Left = 24
      Top = 154
      Width = 72
      Height = 20
      Caption = 'Error code'
    end
    object lblErrorStatus: TLabel
      Left = 184
      Top = 154
      Width = 57
      Height = 20
      Caption = 'NORMAL'
      Font.Color = clGreen
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMessageCaption: TLabel
      Left = 24
      Top = 198
      Width = 58
      Height = 20
      Caption = 'Message'
    end
    object lblMessage: TLabel
      Left = 24
      Top = 224
      Width = 560
      Height = 32
      AutoSize = False
      Caption = 'Waiting for controller connection'
    end
  end
end
