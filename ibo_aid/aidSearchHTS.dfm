object frmSearchHTS: TfrmSearchHTS
  Left = 1
  Top = 116
  Width = 730
  Height = 563
  Caption = 'Search Harmonised Tariff Schedule'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tit: TcrTitle
    Left = 0
    Top = 0
    Width = 722
    Height = 29
    StartColor = clSilver
    Style = tiTitle
    Border = tiNone
    Caption = 'Search Harmonized Tariff Schedule'
    Options = [tiAllowPrintForm]
  end
  object pge: TcrPageControl
    Left = 0
    Top = 29
    Width = 722
    Height = 507
    ActivePage = tabBrw
    Align = alClient
    HotTrack = True
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    object tabBrw: TTabSheet
      Caption = 'brw'
      object grdHTS: TcrdbGrid
        Left = 0
        Top = 105
        Width = 720
        Height = 342
        Align = alClient
        Ctl3D = False
        DataSource = srcTariff
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
        ParentCtl3D = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        DefaultRowHeight = 17
        OnAction = grdHTSAction
      end
      object grpSearch: TGroupBox
        Left = 0
        Top = 0
        Width = 720
        Height = 105
        Align = alTop
        Caption = '&Search'
        TabOrder = 1
        OnEnter = grpSearchEnter
        OnExit = grpSearchExit
        DesignSize = (
          720
          105)
        object lblSrchSection: TcrLabel
          Left = 49
          Top = 21
          Width = 39
          Height = 13
          Caption = 'Section:'
          AlignTo = lkpSrchSection
          Shadow.Color = clBtnShadow
        end
        object lblSrchChapter: TcrLabel
          Left = 48
          Top = 41
          Width = 40
          Height = 13
          Caption = 'Chapter:'
          AlignTo = lkpSrchChapter
          Shadow.Color = clBtnShadow
        end
        object lblSrchParagraph: TcrLabel
          Left = 26
          Top = 61
          Width = 62
          Height = 13
          Caption = 'Sub-Chapter:'
          AlignTo = lkpSrchParagraph
          Shadow.Color = clBtnShadow
        end
        object crLabel1: TcrLabel
          Left = 10
          Top = 81
          Width = 78
          Height = 13
          Caption = 'Code starts with:'
          AlignTo = edtSrchCode
          Shadow.Color = clBtnShadow
        end
        object crLabel2: TcrLabel
          Left = 187
          Top = 81
          Width = 36
          Height = 13
          Caption = 'Coding:'
          AlignTo = lkpTariffCoding
          Shadow.Color = clBtnShadow
        end
        object lblSrchContains: TcrLabel
          Left = 388
          Top = 81
          Width = 100
          Height = 13
          Caption = 'Description Contains:'
          AlignTo = edtSrchContains
          Shadow.Color = clBtnShadow
        end
        object lkpSrchSection: TcrdbLookupComboBox
          Left = 90
          Top = 20
          Width = 521
          Height = 19
          Anchors = [akLeft, akTop, akRight]
          Ctl3D = False
          DataField = 'Filter01'
          DataSource = srcEntry
          DropDownRows = 15
          KeyField = 'FILTERKEY'
          ListField = 'FILTERDESC'
          ListSource = slkFilter01
          ParentCtl3D = False
          TabOrder = 0
        end
        object lkpSrchChapter: TcrdbLookupComboBox
          Left = 90
          Top = 40
          Width = 521
          Height = 19
          Anchors = [akLeft, akTop, akRight]
          Ctl3D = False
          DataField = 'Filter02'
          DataSource = srcEntry
          DropDownRows = 15
          KeyField = 'FILTERKEY'
          ListField = 'FILTERKEY;FILTERDESC; FILTERKEY'
          ListFieldIndex = 1
          ListSource = slkFilter02
          ParentCtl3D = False
          TabOrder = 1
        end
        object lkpSrchParagraph: TcrdbLookupComboBox
          Left = 90
          Top = 60
          Width = 521
          Height = 19
          Anchors = [akLeft, akTop, akRight]
          Ctl3D = False
          DataField = 'Filter03'
          DataSource = srcEntry
          DropDownRows = 15
          KeyField = 'FILTERKEY'
          ListField = 'FILTERKEY;FILTERDESC'
          ListFieldIndex = 1
          ListSource = slkFilter03
          ParentCtl3D = False
          TabOrder = 2
        end
        object edtSrchCode: TDBEdit
          Left = 90
          Top = 80
          Width = 76
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'CodeStartsWith'
          DataSource = srcEntry
          ParentCtl3D = False
          TabOrder = 3
        end
        object lkpTariffCoding: TDBLookupComboBox
          Left = 225
          Top = 80
          Width = 145
          Height = 19
          Ctl3D = False
          DataField = 'TariffCoding'
          DataSource = srcEntry
          KeyField = 'CodingKey'
          ListField = 'CodingDesc'
          ListSource = slkCoding
          ParentCtl3D = False
          TabOrder = 4
        end
        object edtSrchContains: TDBEdit
          Left = 490
          Top = 80
          Width = 121
          Height = 19
          Anchors = [akTop, akRight]
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'DescContains'
          DataSource = srcEntry
          ParentCtl3D = False
          TabOrder = 5
        end
        object btnSearch: TButton
          Left = 631
          Top = 20
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '&Search'
          TabOrder = 6
          OnClick = btnSearchClick
        end
        object btnSrchClear: TButton
          Left = 631
          Top = 75
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '&Clear'
          TabOrder = 7
          OnClick = btnSrchClearClick
        end
      end
      object btns: TcrBtnPanel
        Left = 0
        Top = 447
        Width = 720
        Height = 37
        Align = alBottom
        Style = crpsCancelProceed
        ButtonHeight = 25
        OnButtonClick = btnsButtonClick
      end
    end
    object tabView: TTabSheet
      Caption = 'view'
      ImageIndex = 1
      object grpInfo: TcrGroupBox
        Left = 0
        Top = 0
        Width = 720
        Height = 411
        Align = alTop
        Caption = ' Entry '
        TabOrder = 0
        DesignSize = (
          720
          411)
        object crdBInfo1: TcrdBInfo
          Left = 10
          Top = 20
          Width = 106
          Height = 19
          AutoSize = False
          DataField = 'SectionNo'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object crdBInfo2: TcrdBInfo
          Left = 120
          Top = 20
          Width = 521
          Height = 60
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          DataField = 'SectionDesc'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          Style = isMultiResult
        end
        object crdBInfo3: TcrdBInfo
          Left = 25
          Top = 85
          Width = 106
          Height = 19
          AutoSize = False
          DataField = 'ChapterNo'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object infChapterDesc: TcrdBInfo
          Left = 135
          Top = 85
          Width = 521
          Height = 90
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          DataField = 'ChapterDesc'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          Style = isMultiResult
        end
        object InfParagraphNo: TcrdBInfo
          Left = 45
          Top = 180
          Width = 106
          Height = 19
          AutoSize = False
          DataField = 'ParagraphNo'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object InfParagraphDesc: TcrdBInfo
          Left = 155
          Top = 180
          Width = 521
          Height = 100
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          DataField = 'ParagraphDesc'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          Style = isMultiResult
        end
        object infCommodityNo: TcrdBInfo
          Left = 70
          Top = 285
          Width = 106
          Height = 19
          AutoSize = False
          DataField = 'CommodityNo'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object infCommodityDesc: TcrdBInfo
          Left = 180
          Top = 285
          Width = 521
          Height = 121
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoSize = False
          DataField = 'CommodityDesc'
          DataSource = srcHSC
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          Style = isMultiResult
        end
        object Bevel1: TBevel
          Left = 5
          Top = 27
          Width = 5
          Height = 266
          Shape = bsLeftLine
        end
        object Bevel2: TBevel
          Left = 6
          Top = 93
          Width = 19
          Height = 5
          Shape = bsTopLine
        end
        object Bevel3: TBevel
          Left = 6
          Top = 188
          Width = 39
          Height = 5
          Shape = bsTopLine
        end
        object Bevel4: TBevel
          Left = 5
          Top = 293
          Width = 65
          Height = 5
          Shape = bsTopLine
        end
      end
      object btnsView: TcrBtnPanel
        Left = 0
        Top = 447
        Width = 720
        Height = 37
        Align = alBottom
        Style = crpsCancelSelect
        ButtonHeight = 25
        OnButtonClick = btnsViewButtonClick
      end
    end
  end
  object qryTariff: TcrIBQuery
    ib_transaction = tran
    SQL.Strings = (
      'SELECT '
      '  tc.TariffNo, tc.TariffCoding, '
      '  tc.TariffDesc, tc.TariffDescUpper'
      'FROM'
      '  TariffCode tc'
      'WHERE '
      '  (tc.DataGroup = :AsDataGroup) '
      'ORDER BY'
      '  tc.TariffNo')
    Left = 285
    Top = 240
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsDataGroup'
        ParamType = ptUnknown
      end>
    object qryTariffTARIFFNO: TStringField
      DisplayLabel = 'Tariff No.'
      DisplayWidth = 10
      FieldName = 'TARIFFNO'
      Origin = 'TARIFFCODE.TARIFFNO'
      Required = True
      Size = 15
    end
    object qryTariffTARIFFCODING: TStringField
      DisplayLabel = 'Format'
      FieldName = 'TARIFFCODING'
      Origin = 'TARIFFCODE.TARIFFCODING'
      Required = True
      Size = 10
    end
    object qryTariffTARIFFDESC: TStringField
      DisplayLabel = 'Description'
      DisplayWidth = 93
      FieldName = 'TARIFFDESC'
      Origin = 'TARIFFCODE.TARIFFDESC'
      Size = 255
    end
    object qryTariffTARIFFDESCUPPER: TStringField
      FieldName = 'TARIFFDESCUPPER'
      Origin = 'TARIFFCODE.TARIFFDESCUPPER'
      Visible = False
      Size = 255
    end
  end
  object srcTariff: TDataSource
    DataSet = qryTariff
    Left = 300
    Top = 260
  end
  object tran: TIB_TRANSACTION
    Left = 70
  end
  object mlkFilter01: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 20
    Top = 280
    object mlkFilter01FILTERKEY: TStringField
      DisplayLabel = 'Code'
      DisplayWidth = 10
      FieldName = 'FILTERKEY'
      Origin = 'LOOKUPFILTER.FILTERKEY'
      Required = True
      Size = 15
    end
    object mlkFilter01FILTERDESC: TStringField
      DisplayLabel = 'Desc'
      FieldName = 'FILTERDESC'
      Origin = 'LOOKUPFILTER.FILTERDESC'
      Size = 255
    end
    object mlkFilter01FILTERWHERE: TStringField
      FieldName = 'FILTERWHERE'
      Origin = 'LOOKUPFILTER.FILTERWHERE'
      Required = True
      Visible = False
      Size = 15
    end
  end
  object mlkFilter02: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'FILTERKEY'
        Attributes = [faRequired]
        DataType = ftString
        Size = 15
      end
      item
        Name = 'FILTERDESC'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'FILTERWHERE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 15
      end>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 20
    Top = 325
    object mlkFilter02FILTERKEY: TStringField
      DisplayLabel = 'Code'
      DisplayWidth = 10
      FieldName = 'FILTERKEY'
      Origin = 'LOOKUPFILTER.FILTERKEY'
      Required = True
      Size = 15
    end
    object mlkFilter02FILTERDESC: TStringField
      DisplayLabel = 'Desc'
      FieldName = 'FILTERDESC'
      Origin = 'LOOKUPFILTER.FILTERDESC'
      Size = 255
    end
    object mlkFilter02FILTERWHERE: TStringField
      FieldName = 'FILTERWHERE'
      Origin = 'LOOKUPFILTER.FILTERWHERE'
      Required = True
      Visible = False
      Size = 15
    end
  end
  object mlkFilter03: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 20
    Top = 370
    object mlkFilter03FILTERKEY: TStringField
      DisplayLabel = 'Code'
      DisplayWidth = 10
      FieldName = 'FILTERKEY'
      Origin = 'LOOKUPFILTER.FILTERKEY'
      Required = True
      Size = 15
    end
    object mlkFilter03FILTERDESC: TStringField
      DisplayLabel = 'Desc'
      FieldName = 'FILTERDESC'
      Origin = 'LOOKUPFILTER.FILTERDESC'
      Size = 255
    end
    object mlkFilter03FILTERWHERE: TStringField
      FieldName = 'FILTERWHERE'
      Origin = 'LOOKUPFILTER.FILTERWHERE'
      Required = True
      Visible = False
      Size = 15
    end
  end
  object slkFilter01: TDataSource
    DataSet = mlkFilter01
    Left = 35
    Top = 290
  end
  object slkFilter02: TDataSource
    DataSet = mlkFilter02
    Left = 35
    Top = 335
  end
  object slkFilter03: TDataSource
    DataSet = mlkFilter03
    Left = 35
    Top = 385
  end
  object qryFilter: TcrIBQuery
    ib_transaction = tran
    SQL.Strings = (
      'SELECT '
      '  lf.FilterKey, lf.FilterDesc,'
      '  lf.ParentSection, lf.ParentKey, '
      '  lf.FilterWHERE'
      'FROM '
      '  LookupFilter lf'
      'WHERE '
      
        '  (lf.DataGroup = :AsDataGroup) AND (lf.FilterSection = :AsFilte' +
        'rSection) ORDER BY'
      '  lf.FilterKey, lf.FilterDesc'
      '')
    Left = 215
    Top = 240
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsDataGroup'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsFilterSection'
        ParamType = ptUnknown
      end>
    object qryFilterFILTERKEY: TStringField
      FieldName = 'FILTERKEY'
      Origin = 'LOOKUPFILTER.FILTERKEY'
      Required = True
      Size = 15
    end
    object qryFilterFILTERDESC: TStringField
      FieldName = 'FILTERDESC'
      Origin = 'LOOKUPFILTER.FILTERDESC'
      Size = 255
    end
    object qryFilterFILTERWHERE: TStringField
      FieldName = 'FILTERWHERE'
      Origin = 'LOOKUPFILTER.FILTERWHERE'
      Required = True
      Size = 15
    end
    object qryFilterPARENTSECTION: TStringField
      FieldName = 'PARENTSECTION'
      Origin = 'LOOKUPFILTER.PARENTSECTION'
      FixedChar = True
      Size = 10
    end
    object qryFilterPARENTKEY: TStringField
      FieldName = 'PARENTKEY'
      Origin = 'LOOKUPFILTER.PARENTKEY'
      Size = 15
    end
  end
  object memEntry: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 80
    Top = 185
    object memEntryFilter01: TStringField
      FieldName = 'Filter01'
      OnChange = memEntryFilter01Change
      Size = 15
    end
    object memEntryFilter02: TStringField
      FieldName = 'Filter02'
      OnChange = memEntryFilter02Change
      Size = 15
    end
    object memEntryFilter03: TStringField
      FieldName = 'Filter03'
      Size = 15
    end
    object memEntryCodeStartsWith: TStringField
      FieldName = 'CodeStartsWith'
      Size = 15
    end
    object memEntryDescContains: TStringField
      FieldName = 'DescContains'
      Size = 10
    end
    object memEntryTariffCoding: TStringField
      FieldName = 'TariffCoding'
      Size = 10
    end
  end
  object srcEntry: TDataSource
    DataSet = memEntry
    Left = 90
    Top = 200
  end
  object memHSC: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 115
    Top = 390
    object memHSCSectionNo: TStringField
      FieldName = 'SectionNo'
      Size = 10
    end
    object memHSCSectionDesc: TStringField
      FieldName = 'SectionDesc'
      Size = 255
    end
    object memHSCChapterNo: TStringField
      FieldName = 'ChapterNo'
      OnGetText = memHSCChapterNoGetText
      Size = 10
    end
    object memHSCChapterDesc: TStringField
      FieldName = 'ChapterDesc'
      Size = 255
    end
    object memHSCParagraphNo: TStringField
      FieldName = 'ParagraphNo'
      OnGetText = memHSCChapterNoGetText
      Size = 10
    end
    object memHSCParagraphDesc: TStringField
      FieldName = 'ParagraphDesc'
      Size = 255
    end
    object memHSCCommodityNo: TStringField
      FieldName = 'CommodityNo'
      OnGetText = memHSCChapterNoGetText
      Size = 10
    end
    object memHSCCommodityDesc: TStringField
      FieldName = 'CommodityDesc'
      Size = 255
    end
  end
  object srcHSC: TDataSource
    DataSet = memHSC
    Left = 125
    Top = 405
  end
  object mlkCoding: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 400
    Top = 310
    object mlkCodingCodingKey: TStringField
      FieldName = 'CodingKey'
      Size = 10
    end
    object mlkCodingCodingDesc: TStringField
      FieldName = 'CodingDesc'
      Size = 30
    end
  end
  object slkCoding: TDataSource
    DataSet = mlkCoding
    Left = 415
    Top = 325
  end
end
