object Data: TData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 261
  Width = 356
  object MultiLang: TelMultiLanguage
    ActiveLanguage = 0
    ActiveLocale = 1033
    ActiveLocaleAbbr = 'ENU'
    AutoLoad = True
    Languages = <
      item
        Locale = 1033
        FileExtension = 'ENU'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      item
        Locale = 1042
        FileExtension = 'KOR'
        Default = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      item
        Locale = 2052
        FileExtension = 'CHS'
        Default = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      item
        Locale = 1041
        FileExtension = 'JPN'
        Default = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      item
        Locale = 1066
        FileExtension = 'VIT'
        Default = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end>
    LanguageFilePrefix = 'contactanglemeas'
    Options = []
    Left = 78
    Top = 26
  end
  object PropSaver: TelPropSaver
    FormStateSection = 'MainForm'
    SaveToRegistry = False
    Left = 24
    Top = 24
  end
end
