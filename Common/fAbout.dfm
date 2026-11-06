object frmAbout: TfrmAbout
  Left = 647
  Top = 214
  BorderStyle = bsDialog
  ClientHeight = 348
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Default'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    404
    348)
  PixelsPerInch = 96
  TextHeight = 14
  object imgIcon: TImage
    Left = 9
    Top = 9
    Width = 38
    Height = 38
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = True
  end
  object lblLogo: TelLabel
    Left = 61
    Top = 5
    Width = 337
    Height = 43
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Frame.Visible = False
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object lblVersion: TelLabel
    Left = 61
    Top = 55
    Width = 176
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Version 1.0  (Build No : 0151)'
    Frame.Visible = False
    Transparent = True
  end
  object lblCopyright: TelLabel
    Left = 61
    Top = 78
    Width = 140
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Copyright (c) AcroSoft.'
    Frame.Visible = False
    Transparent = True
  end
  object lblRights: TelLabel
    Left = 61
    Top = 102
    Width = 113
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'All rights reserved.'
    Frame.Visible = False
    Transparent = True
  end
  object lblWWW: TelLabel
    Left = 61
    Top = 125
    Width = 60
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'WWW : '
    Frame.Visible = False
    Transparent = True
  end
  object lblMail: TelLabel
    Left = 61
    Top = 148
    Width = 54
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'E-Mail : '
    Frame.Visible = False
    Transparent = True
  end
  object lblLibraries: TelLabel
    Left = 61
    Top = 176
    Width = 63
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Libraries :'
    Frame.Visible = False
    Transparent = True
  end
  object lblHomePage: TelLabel
    Left = 145
    Top = 125
    Width = 160
    Height = 26
    Cursor = 26000
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'http://www.acrosoft.kr'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Default'
    Font.Style = []
    Frame.Visible = False
    ParentFont = False
    Transparent = True
    OnClick = lblHomePageClick
  end
  object lblEmail: TelLabel
    Left = 145
    Top = 148
    Width = 145
    Height = 26
    Cursor = 26000
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'support@acrosoft.kr'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Default'
    Font.Style = []
    Frame.Visible = False
    ParentFont = False
    Transparent = True
    OnClick = lblEmailClick
  end
  object lvLib: TListView
    Left = 61
    Top = 196
    Width = 332
    Height = 104
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Columns = <
      item
        Caption = 'FileName'
        Width = 152
      end
      item
        Caption = 'Version'
        Width = 152
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
  object btnClose: TcxButton
    Left = 292
    Top = 307
    Width = 102
    Height = 34
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    OptionsImage.Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      08000000000000010000120B0000120B0000000100000000000000000000FFFF
      FF00FF00FF00FCD1D3004E1E1F00C54D4E00C9525300C24F5000D4585900C954
      5500CF575800CB555600D75C5D00D55C5D00D05A5B00CF595A00B74F5200B24D
      4E00B64F5000D55E5F00BD535600D75F6000DD636400C2575A00C6595B00E267
      6800DD656600DA636400E3686900DE666700EB6D6E00E96C6D00F2737400F073
      7400EE727300F7777900D1656600F0757600F6797A00F77A7B00FE7F8000FB7E
      7F00FF818200FC7F8000DA6E6F00FF828300FE818200FF838400E5767700E073
      7400E2757600FF868700FF888900CF6E7000CB6C6D00CC6E7000FE8B8C00EB81
      8200E67E7F009C565700FB9A9C00F8AAAB00F7B5B600FAD3D400A64B4B00A94D
      4D00F8787900D76B6B00CF6E6E00824B4B00FAEBC500FCEFC700FFF2CC00FCFB
      CF00FCFBD100FFFFD300FFFFD400FFFFD500FFFFD700E6FCC700A5D8970050D1
      6F0026B149002AB44D001BBB490023B54A002DC7580042C966000CBC410010BB
      430013C1480013BC450016BD480016BC48001CBF4C001EBC4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000020202020202
      0245040202020202020202020202454540410402020202020202020245451207
      05110445454545454502020245080B09061004383C3D3E3E45020202450C0E0F
      0A1404555A5C583E45020202451615130D1704535E5F5B3E45020202451C1A1B
      1D1804525D54593E45020202451E193A3F3704505157563E4502020245201F39
      033504484E4C4F3E4502020245422522212404474D4B4E3E4502020245282726
      234304474D4B4D3E45020202452F2B29282C04474D4B4D3E4502020245342D2A
      2D3104474D4B4D3E450202024545322E333004464A494A3E450202020202453B
      3644044545454545450202020202020245450402020202020202}
    OptionsImage.Spacing = 8
    TabOrder = 0
  end
end
