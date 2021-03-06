object FrmFndPart: TFrmFndPart
  Left = 624
  Top = 254
  BorderStyle = bsDialog
  Caption = 'Find Part'
  ClientHeight = 466
  ClientWidth = 752
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = crDlgFormCreate
  OnShow = crDlgFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Tit: TcrTitle
    Left = 0
    Top = 0
    Width = 752
    Height = 29
    StartColor = clGreen
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Pge: TcrPageControl
    Left = 0
    Top = 29
    Width = 752
    Height = 437
    ActivePage = TabParam
    Align = alClient
    HotTrack = True
    TabIndex = 1
    TabOrder = 0
    TabStop = False
    OnChange = PgeChange
    object TabBrw: TTabSheet
      Caption = 'Browse'
      object Grd: TcrdbGrid
        Left = 0
        Top = 85
        Width = 750
        Height = 294
        Align = alClient
        Ctl3D = False
        DataSource = SrcPart
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
        OnDrawColumnCell = GrdDrawColumnCell
        DefaultRowHeight = 17
        OnAction = GrdAction
        OnTitleHint = GrdTitleHint
      end
      object GrpSearch: TGroupBox
        Left = 0
        Top = 0
        Width = 750
        Height = 85
        Align = alTop
        Caption = ' Search Criteria '
        TabOrder = 1
        OnEnter = GrpSearchEnter
        OnExit = GrpSearchExit
        object InfLkpSuppNo: TcrInfo
          Left = 235
          Top = 40
          Width = 81
          Height = 19
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Indent = 1
          ParentFont = False
          WordWrap = False
          Text = '<LkpSuppNo>'
          Style = isSingleResult
        end
        object LblSrchPartNo: TcrLabel
          Left = 46
          Top = 21
          Width = 32
          Height = 13
          Caption = 'Part #:'
          AlignTo = EdtSrchNo
          Shadow.Color = clBtnShadow
        end
        object LblSrchBOMDesc: TcrLabel
          Left = 177
          Top = 21
          Width = 56
          Height = 13
          Caption = 'Description:'
          AlignTo = EdtSrchDesc
          Shadow.Color = clBtnShadow
        end
        object LblSrchSupPart: TcrLabel
          Left = 5
          Top = 41
          Width = 73
          Height = 13
          Caption = 'Supplier Part #:'
          AlignTo = EdtSrchSuppPartNo
          Shadow.Color = clBtnShadow
        end
        object LblSearch: TcrLabel
          Left = 639
          Top = 48
          Width = 29
          Height = 13
          Caption = '<n/a>'
          AlignTo = BtnSrch
          Shadow.Color = clBtnShadow
        end
        object Spd: TSpeedButton
          Left = 620
          Top = 10
          Width = 15
          Height = 15
          Caption = '?'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = [fsBold]
          Layout = blGlyphBottom
          ParentFont = False
          OnClick = SpdClick
        end
        object LblSupplier: TcrLabel
          Left = 192
          Top = 41
          Width = 41
          Height = 13
          Caption = 'Supplier:'
          Shadow.Color = clBtnShadow
        end
        object Bvl: TBevel
          Left = 615
          Top = 10
          Width = 3
          Height = 71
          Shape = bsLeftLine
        end
        object InfSuppName: TcrdBInfo
          Left = 320
          Top = 40
          Width = 291
          Height = 19
          AutoSize = False
          DataField = 'SUPPNAME'
          DataSource = SrcSrch
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object LblOrderBy: TcrLabel
          Left = 690
          Top = 11
          Width = 44
          Height = 13
          Caption = '&Order By:'
          FocusControl = LkpOrderBy
          AlignTo = LkpOrderBy
          Position = lpTopRight
          Shadow.Color = clBtnShadow
        end
        object LblAka: TcrLabel
          Left = 4
          Top = 61
          Width = 74
          Height = 13
          Caption = 'Also Known As:'
          AlignTo = EdtAKA
          Shadow.Color = clBtnShadow
        end
        object LblPartType: TcrLabel
          Left = 184
          Top = 61
          Width = 49
          Height = 13
          Caption = 'Part Type:'
          AlignTo = LkpPartType
          Shadow.Color = clBtnShadow
        end
        object LblBusDiv: TcrLabel
          Left = 388
          Top = 61
          Width = 40
          Height = 13
          Caption = 'Division:'
          FocusControl = LkpBusDiv
          AlignTo = LkpBusDiv
          Shadow.Color = clBtnShadow
        end
        object EdtSrchNo: TDBEdit
          Left = 80
          Top = 20
          Width = 86
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'PartNo'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 0
          OnKeyUp = EdtSrchNoKeyUp
        end
        object EdtSrchDesc: TDBEdit
          Left = 235
          Top = 20
          Width = 146
          Height = 19
          Ctl3D = False
          DataField = 'PartDesc'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 3
        end
        object EdtSrchSuppPartNo: TDBEdit
          Left = 80
          Top = 40
          Width = 108
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'SuppPartNo'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 1
        end
        object BtnNew: TButton
          Left = 535
          Top = 15
          Width = 76
          Height = 24
          Caption = '&New Part'
          TabOrder = 5
          OnClick = BtnNewClick
        end
        object BtnSrch: TButton
          Left = 670
          Top = 45
          Width = 66
          Height = 24
          Caption = 'S&earch'
          Default = True
          TabOrder = 9
          OnClick = BtnSrchClick
        end
        object LkpOrderBy: TcrdbLookupComboBox
          Left = 620
          Top = 25
          Width = 116
          Height = 19
          Ctl3D = False
          DataField = 'OrderBy'
          DataSource = SrcSrch
          KeyField = 'OrderBy'
          ListField = 'Desc'
          ListSource = SrcOrder
          ParentCtl3D = False
          TabOrder = 8
        end
        object EdtAKA: TDBEdit
          Left = 80
          Top = 60
          Width = 86
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'PartAka'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 2
        end
        object LkpPartType: TcrdbLookupComboBox
          Left = 235
          Top = 60
          Width = 145
          Height = 19
          Ctl3D = False
          DataField = 'PARTTYPE'
          DataSource = SrcSrch
          KeyField = 'Key_Lk'
          ListField = 'Desc_Lk'
          ListSource = SrcLkpPartType
          ParentCtl3D = False
          TabOrder = 6
        end
        object LkpBusDiv: TcrdbLookupComboBox
          Left = 430
          Top = 60
          Width = 181
          Height = 19
          Ctl3D = False
          DataField = 'SupplyDivision'
          DataSource = SrcSrch
          KeyField = 'Key_Lk'
          ListField = 'Desc_Lk'
          ListSource = SrcLkpBusDiv
          ParentCtl3D = False
          TabOrder = 7
        end
        object ChkSrchContains: TDBCheckBox
          Left = 385
          Top = 22
          Width = 92
          Height = 17
          Hint = 'Search where description contains the criteria'
          Caption = 'contains'
          DataField = 'DescContains'
          DataSource = SrcSrch
          TabOrder = 4
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
      object Btns1: TcrBtnPanel
        Left = 0
        Top = 379
        Width = 750
        Align = alBottom
        Style = crpsCancelSelect
        OnButtonClick = Btns1ButtonClick
        object BtnLevels1: TButton
          Left = 5
          Top = 8
          Width = 75
          Height = 23
          Caption = '&Levels'
          TabOrder = 0
          OnClick = BtnLevelsClick
        end
      end
    end
    object TabParam: TTabSheet
      Caption = 'Parameters'
      ImageIndex = 1
      object GrpParam: TGroupBox
        Left = 0
        Top = 61
        Width = 750
        Height = 318
        Align = alClient
        Caption = ' Parameters '
        TabOrder = 0
        object GrdParam: TcrdbGrid
          Left = 2
          Top = 15
          Width = 746
          Height = 301
          Align = alClient
          Ctl3D = False
          DataSource = SrcParam
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
          OptionsEx = [crdgBooleanSymbols]
          OnAction = GrdParamAction
        end
      end
      object GrpPart: TGroupBox
        Left = 0
        Top = 0
        Width = 750
        Height = 61
        Align = alTop
        Caption = ' Part '
        TabOrder = 1
        object LblPartNo1: TcrLabel
          Left = 12
          Top = 21
          Width = 32
          Height = 13
          Caption = 'Part #:'
          FocusControl = InfPartNo1
          AlignTo = InfPartNo1
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object InfPartNo1: TcrdBInfo
          Left = 10
          Top = 35
          Width = 81
          Height = 19
          AutoSize = False
          DataField = 'PARTNO'
          DataSource = SrcPart
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object LblPartDesc1: TcrLabel
          Left = 97
          Top = 21
          Width = 56
          Height = 13
          Caption = 'Description:'
          FocusControl = InfPartDesc1
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object InfPartDesc1: TcrdBInfo
          Left = 95
          Top = 35
          Width = 311
          Height = 19
          AutoSize = False
          DataField = 'PARTDESC'
          DataSource = SrcPart
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
      end
      object Btns2: TcrBtnPanel
        Left = 0
        Top = 379
        Width = 750
        Align = alBottom
        Style = crpsCancelSelect
        OnButtonClick = Btns1ButtonClick
        object BtnLevels2: TButton
          Left = 5
          Top = 8
          Width = 75
          Height = 23
          Caption = '&Levels'
          TabOrder = 0
          OnClick = BtnLevelsClick
        end
      end
    end
    object TabLevel: TTabSheet
      Caption = 'Levels'
      ImageIndex = 2
      object crLabel1: TLabel
        Left = 0
        Top = 0
        Width = 750
        Height = 379
        Align = alClient
        Alignment = taCenter
        Caption = 'Reserved'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsItalic]
        ParentFont = False
        Layout = tlCenter
      end
      object BtnsLevels: TcrBtnPanel
        Left = 0
        Top = 379
        Width = 750
        Align = alBottom
        Style = crpsDone
        OnButtonClick = BtnsLevelsButtonClick
      end
    end
  end
  object QryPart: TcrIBQuery
    Params = <>
    RecordCountAccurate = True
    OnCalcFields = QryPartCalcFields
    SQL.Strings = (
      'SELECT'
      '  pm.Inc_Part, pm.PartNo, pm.IssueNo,  '
      '  pm.PartDesc, pm.PartVersion,'
      '  pm.Drawing, pm.Key_Eng, '
      '  pm.ReplacedBy, pm.HasDocs,'
      '  pm.SuppPartNo, pm.SuppNo,'
      '  pm.PartAka1, pm.PartAka2,'
      '  su.CompName as SuppName,'
      '  pm.HasParam,'
      '  pm.PartType, pm.SupplyCode, pm.SupplyDivision'
      'FROM'
      '  Part PM'
      'LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)'
      'ORDER BY'
      '  pm.PartNoSeq, pm.PartNo'
      '')
    FieldOptions = []
    ResultLabel = LblSearch
    OptionsEx = [crPreventIfNoParams]
    Left = 155
    Top = 255
    object QryPartINC_PART: TIntegerField
      FieldName = 'INC_PART'
      Origin = 'DBBOM.PART.INC_PART'
      Visible = False
    end
    object QryPartPARTNO: TStringField
      DisplayLabel = 'Part#'
      DisplayWidth = 11
      FieldName = 'PARTNO'
      Origin = 'DBBOM.PART.PARTNO'
      FixedChar = True
      Size = 10
    end
    object QryPartISSUENO: TIntegerField
      DisplayLabel = 'rev'
      DisplayWidth = 2
      FieldName = 'ISSUENO'
      Origin = 'PART.ISSUENO'
    end
    object QryPartHASPARAM: TStringField
      Alignment = taCenter
      DisplayLabel = 'par'
      DisplayWidth = 2
      FieldName = 'HASPARAM'
      OnGetText = QryPartHASPARAMGetText
      Size = 1
    end
    object QryPartPARTVERSION: TStringField
      Alignment = taCenter
      DisplayLabel = 'pv'
      DisplayWidth = 2
      FieldName = 'PARTVERSION'
      Size = 1
    end
    object QryPartPARTDESC: TStringField
      DisplayLabel = 'Part Description'
      DisplayWidth = 40
      FieldName = 'PARTDESC'
      Origin = 'DBBOM.PART.PARTDESC'
      Size = 50
    end
    object QryPartREPLACEDBY: TStringField
      DisplayLabel = 'ReplacedBy'
      DisplayWidth = 10
      FieldName = 'REPLACEDBY'
      Origin = 'DBBOM.PART.REPLACEDBY'
      FixedChar = True
      Size = 10
    end
    object QryPartSUPPPARTNO: TStringField
      DisplayLabel = 'OEM Part #'
      DisplayWidth = 15
      FieldName = 'SUPPPARTNO'
      Size = 30
    end
    object QryPartSUPPNO: TStringField
      DisplayLabel = 'Supp. #'
      DisplayWidth = 8
      FieldName = 'SUPPNO'
      Visible = False
      Size = 10
    end
    object QryPartSUPPNAME: TStringField
      DisplayLabel = 'Supplier'
      DisplayWidth = 12
      FieldName = 'SUPPNAME'
      Size = 50
    end
    object QryPartPARTAKA1: TStringField
      FieldName = 'PARTAKA1'
      Visible = False
    end
    object QryPartPARTAKA2: TStringField
      FieldName = 'PARTAKA2'
      Visible = False
    end
    object QryPartPARTTYPE: TStringField
      FieldName = 'PARTTYPE'
      Visible = False
      Size = 5
    end
    object QryPartSUPPLYCODE: TStringField
      DisplayLabel = 'Supply Cd'
      DisplayWidth = 9
      FieldName = 'SUPPLYCODE'
      Visible = False
      Size = 8
    end
    object QryPartSUPPLYDIVISION: TStringField
      DisplayLabel = 'Supply Div'
      DisplayWidth = 9
      FieldName = 'SUPPLYDIVISION'
      Visible = False
      Size = 8
    end
    object QryPartDRAWING: TStringField
      Alignment = taCenter
      DisplayLabel = 'drw'
      DisplayWidth = 3
      FieldName = 'DRAWING'
      Origin = 'PART.DRAWING'
      FixedChar = True
      Size = 1
    end
    object QryPartHASDOCS: TStringField
      Alignment = taCenter
      DisplayLabel = 'doc'
      DisplayWidth = 3
      FieldName = 'HASDOCS'
      Origin = 'PART.HASDOCS'
      FixedChar = True
      Size = 1
    end
    object QryPartKEY_ENG: TStringField
      DisplayLabel = 'Engineer'
      FieldName = 'KEY_ENG'
      Origin = 'PART.KEY_ENG'
      Size = 10
    end
  end
  object SrcPart: TDataSource
    DataSet = QryPart
    OnStateChange = SrcPartStateChange
    Left = 170
    Top = 270
  end
  object MemSrch: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <
      item
        Name = 'PartNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Spare'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'PartDesc'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SuppPartNo'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SuppNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SuppName'
        DataType = ftString
        Size = 50
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
    OnNewRecord = MemSrchNewRecord
    Left = 400
    Top = 10
    object MemSrchPartNo: TStringField
      FieldName = 'PartNo'
      Size = 10
    end
    object MemSrchSpare: TStringField
      FieldName = 'Spare'
      Size = 1
    end
    object MemSrchPartDesc: TStringField
      DisplayWidth = 30
      FieldName = 'PartDesc'
      Size = 50
    end
    object MemSrchDescContains: TBooleanField
      FieldName = 'DescContains'
    end
    object MemSrchSuppPartNo: TStringField
      FieldName = 'SuppPartNo'
      Size = 30
    end
    object MemSrchSuppNo: TStringField
      FieldName = 'SuppNo'
      OnChange = MemSrchSuppNoChange
      Size = 10
    end
    object MemSrchSuppName: TStringField
      FieldName = 'SuppName'
      Size = 50
    end
    object MemSrchOrderBy: TStringField
      FieldName = 'OrderBy'
      Size = 1
    end
    object MemSrchPartAka: TStringField
      DisplayLabel = 'Aka'
      FieldName = 'PartAka'
    end
    object MemSrchPartType: TStringField
      FieldName = 'PartType'
      Size = 10
    end
    object MemSrchSupplyDivision: TStringField
      FieldName = 'SupplyDivision'
      Size = 10
    end
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 410
    Top = 30
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrTimer
    Left = 190
    Top = 315
  end
  object Lst: TcrDlgList
    Caption = 'View SQL'
    Left = 600
    Top = 300
  end
  object QryParam: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'PartNo'
        ParamType = ptInput
      end>
    RecordCountAccurate = True
    OnCalcFields = QryParamCalcFields
    DataSource = SrcPart
    SQL.Strings = (
      'SELECT '
      '  pp.PartParam, pp.CostPrice, pp.DteCosted'
      'FROM'
      '  PartParam pp'
      'WHERE'
      '  PartNo = :PartNo'
      'ORDER BY'
      '  pp.PartNo, pp.PartParam')
    FieldOptions = []
    Left = 208
    Top = 251
    object QryParamPARTPARAM: TStringField
      DisplayLabel = 'Parameter'
      FieldName = 'PARTPARAM'
      Size = 10
    end
    object QryParamCOSTPRICE: TFloatField
      DisplayLabel = 'Cost'
      FieldName = 'COSTPRICE'
      OnGetText = QryParamCOSTPRICEGetText
      DisplayFormat = ',0.00'
    end
    object QryParam_SellPrice: TFloatField
      DisplayLabel = 'Quote'
      FieldKind = fkCalculated
      FieldName = '_SellPrice'
      OnGetText = QryParam_SellPriceGetText
      Calculated = True
    end
    object QryParamDTECOSTED: TDateTimeField
      DisplayLabel = 'Date Costed'
      DisplayWidth = 12
      FieldName = 'DTECOSTED'
      DisplayFormat = 'dddddd'
    end
  end
  object SrcParam: TDataSource
    DataSet = QryParam
    Left = 225
    Top = 265
  end
  object MemOrder: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
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
    Left = 19
    Top = 306
    object MemOrderOrderBy: TStringField
      FieldName = 'OrderBy'
      Size = 1
    end
    object MemOrderDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
  end
  object SrcOrder: TDataSource
    DataSet = MemOrder
    Left = 30
    Top = 325
  end
  object QryLookups: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsGroup_Lk'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  L1.Key_Lk, L1.Desc_Lk'
      'FROM'
      '  Lookups L1'
      'WHERE'
      '  L1.Group_Lk = :AsGroup_Lk'
      'ORDER BY'
      '  L1.Str1, L1.Key_Lk')
    FieldOptions = []
    Left = 455
    Top = 310
    object QryLookupsKEY_LK: TStringField
      FieldName = 'KEY_LK'
      Required = True
      Size = 10
    end
    object QryLookupsDESC_LK: TStringField
      FieldName = 'DESC_LK'
      Size = 30
    end
  end
  object MemLkpPartType: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
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
    Left = 284
    Top = 176
    object MemLkpPartTypeKEY_LK: TStringField
      FieldName = 'KEY_LK'
      Required = True
      Size = 10
    end
    object MemLkpPartTypeDESC_LK: TStringField
      FieldName = 'DESC_LK'
      Size = 30
    end
  end
  object SrcLkpPartType: TDataSource
    DataSet = MemLkpPartType
    Left = 295
    Top = 195
  end
  object MemLkpBusDiv: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
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
    Left = 360
    Top = 175
    object MemLkpBusDivKey_Lk: TStringField
      FieldName = 'Key_Lk'
      Size = 10
    end
    object MemLkpBusDivDesc_Lk: TStringField
      FieldName = 'Desc_Lk'
      Size = 30
    end
  end
  object SrcLkpBusDiv: TDataSource
    DataSet = MemLkpBusDiv
    Left = 370
    Top = 195
  end
  object QryPartEx: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsSite'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  pm.PartNo, pm.PartDesc, pm.ReplacedBy, '
      '  pm.CostPrice,  pm.DteCosted,'
      '  pm.PackageDesc,'
      '  pl.OnOrder, pl.LastOrdered, pl.LastCostGBP, pl.LastTranNo,'
      '  pl.NextExpected, pl.NextTranNo,'
      '  pm.SaleNote,'
      '  ps.DepartMent, pm.SupplyCode'
      'FROM'
      '  Part pm'
      
        'LEFT JOIN StockPOLevel pl ON (pl.PartNo = pm.PartNo) and (pl.Sit' +
        'e = :AsSite)'
      'LEFT JOIN PartSeries   ps ON (pm.PartSeries = ps.PSerNo)  '
      'WHERE'
      '  (pm.PartNo = :AsPartNo)')
    FieldOptions = []
    Left = 385
    Top = 315
    object IBStringField1: TStringField
      FieldName = 'PARTNO'
      Required = True
      Size = 10
    end
    object IBStringField2: TStringField
      FieldName = 'PARTDESC'
      Size = 50
    end
    object IBStringField3: TStringField
      FieldName = 'REPLACEDBY'
      Size = 10
    end
    object FloatField1: TFloatField
      FieldName = 'COSTPRICE'
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'DTECOSTED'
    end
    object IBStringField4: TStringField
      FieldName = 'PACKAGEDESC'
      Size = 10
    end
    object QryPartONORDER: TIntegerField
      FieldName = 'ONORDER'
    end
    object QryPartLASTORDERED: TDateTimeField
      FieldName = 'LASTORDERED'
    end
    object QryPartLASTCOSTGBP: TFloatField
      FieldName = 'LASTCOSTGBP'
    end
    object QryPartLASTTRANNO: TStringField
      FieldName = 'LASTTRANNO'
      Size = 10
    end
    object QryPartNEXTEXPECTED: TDateTimeField
      FieldName = 'NEXTEXPECTED'
    end
    object QryPartNEXTTRANNO: TStringField
      FieldName = 'NEXTTRANNO'
      Size = 10
    end
    object QryPartSALENOTE: TStringField
      FieldName = 'SALENOTE'
      Size = 128
    end
    object QryPartDEPARTMENT: TStringField
      FieldName = 'DEPARTMENT'
      Size = 1
    end
    object IBStringField5: TStringField
      FieldName = 'SUPPLYCODE'
      Size = 8
    end
  end
end
