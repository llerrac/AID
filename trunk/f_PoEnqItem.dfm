object FrmFndPurchEnqItem: TFrmFndPurchEnqItem
  Left = 400
  Top = 354
  BorderStyle = bsDialog
  Caption = 'Find Enquiry Items'
  ClientHeight = 433
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = crDlgFormCreate
  OnShow = crDlgFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Tit: TcrTitle
    Left = 0
    Top = 0
    Width = 624
    Height = 29
    StartColor = 22675
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Btns: TcrBtnPanel
    Left = 0
    Top = 398
    Width = 624
    Align = alBottom
    Style = crpsCancelSelect
    OnButtonClick = BtnsButtonClick
    object BtnViewPart: TButton
      Left = 5
      Top = 8
      Width = 67
      Height = 23
      Caption = '&View Part'
      Enabled = False
      TabOrder = 2
      Visible = False
      OnClick = BtnViewPartClick
    end
  end
  object GrpSearch: TGroupBox
    Left = 0
    Top = 29
    Width = 624
    Height = 117
    Align = alTop
    Caption = ' Search '
    TabOrder = 1
    OnEnter = GrpSearchEnter
    OnExit = GrpSearchExit
    DesignSize = (
      624
      117)
    object Label29: TcrLabel
      Left = 48
      Top = 76
      Width = 55
      Height = 13
      Caption = 'Issued Site:'
      FocusControl = LkpSrchSite
      Shadow.Color = clBtnShadow
    end
    object LblJobNo: TcrLabel
      Left = 286
      Top = 57
      Width = 37
      Height = 13
      Caption = '&Job No:'
      FocusControl = EdtJobNo
      AlignTo = EdtJobNo
      Shadow.Color = clBtnShadow
    end
    object Spd: TSpeedButton
      Left = 557
      Top = 34
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
    object LblSearch: TcrLabel
      Left = 587
      Top = 34
      Width = 29
      Height = 13
      Caption = '<n/a>'
      AlignTo = BtnSrch
      Position = lpBottomRight
      Shadow.Color = clBtnShadow
    end
    object LblLineMemo: TcrLabel
      Left = 54
      Top = 96
      Width = 49
      Height = 13
      Caption = 'Line Note:'
      FocusControl = EdtLineMemo
      AlignTo = EdtLineMemo
      Shadow.Color = clBtnShadow
    end
    object LblNoteInfo: TcrLabel
      Left = 273
      Top = 96
      Width = 314
      Height = 13
      Caption = 
        ' (please be aware that searching the notes field will be very sl' +
        'ow) '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      AlignTo = EdtLineMemo
      Position = lpRight
      Shadow.Color = clBtnShadow
    end
    object crLabel1: TcrLabel
      Left = 43
      Top = 56
      Width = 60
      Height = 13
      Caption = 'Supp Part #:'
      FocusControl = EdtSuppPartNo
      AlignTo = EdtSuppPartNo
      Shadow.Color = clBtnShadow
    end
    object crLabel11: TcrLabel
      Left = 107
      Top = 21
      Width = 51
      Height = 13
      Caption = 'Parameter:'
      FocusControl = EdtParam
      Position = lpTopLeft
      Shadow.Color = clBtnShadow
    end
    object LblPartDesc: TcrLabel
      Left = 187
      Top = 21
      Width = 78
      Height = 13
      Caption = 'Part Description:'
      FocusControl = InfPartDesc
      Position = lpTopLeft
      Shadow.Color = clBtnShadow
    end
    object InfPartDesc: TcrdBInfo
      Left = 185
      Top = 35
      Width = 366
      Height = 19
      AutoSize = False
      DataField = 'ItemDesc'
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
    object crLabel2: TcrLabel
      Left = 107
      Top = 21
      Width = 22
      Height = 13
      Caption = 'Part:'
      FocusControl = EdtParam
      Position = lpTopLeft
      Shadow.Color = clBtnShadow
    end
    object BtnSrch: TButton
      Left = 547
      Top = 11
      Width = 71
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'S&earch'
      Default = True
      TabOrder = 0
      OnClick = BtnSrchClick
    end
    object LkpSrchSite: TcrdbLookupComboBox
      Left = 105
      Top = 75
      Width = 166
      Height = 19
      Ctl3D = False
      DataField = 'TranSite'
      DataSource = SrcSrch
      KeyField = 'SITE'
      ListField = 'SITEDESC'
      ListSource = SrcLkpSite
      ParentCtl3D = False
      TabOrder = 1
    end
    object EdtJobNo: TDBEdit
      Left = 325
      Top = 56
      Width = 106
      Height = 19
      AutoSelect = False
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'JobNo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 2
    end
    object EdtLineMemo: TDBEdit
      Left = 105
      Top = 95
      Width = 166
      Height = 19
      AutoSelect = False
      Ctl3D = False
      DataField = 'LineMemo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 3
    end
    object EdtSuppPartNo: TDBEdit
      Left = 105
      Top = 55
      Width = 166
      Height = 19
      AutoSelect = False
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'SuppPartNo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 4
    end
    object EdtParam: TDBEdit
      Left = 105
      Top = 35
      Width = 79
      Height = 19
      TabStop = False
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'ItemParam'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 5
    end
  end
  object Grd: TcrdbGrid
    Left = 0
    Top = 146
    Width = 624
    Height = 252
    Align = alClient
    Ctl3D = False
    DataSource = SrcPOEnq
    Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = GrdDrawColumnCell
    DefaultRowHeight = 17
    OptionsEx = [crdgBooleanSymbols]
    OnAction = GrdAction
  end
  object MemSrch: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <
      item
        Name = 'ItemNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ItemParam'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ItemDesc'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'TranSite'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'JobNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'LineMemo'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'StatusNote'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SuppPartNo'
        DataType = ftString
        Size = 30
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
    Left = 519
    Top = 6
    object MemSrchItemNo: TStringField
      FieldName = 'ItemNo'
      Size = 10
    end
    object MemSrchItemParam: TStringField
      FieldName = 'ItemParam'
      Size = 10
    end
    object MemSrchItemDesc: TStringField
      FieldName = 'ItemDesc'
      Size = 50
    end
    object MemSrchTranSite: TStringField
      FieldName = 'TranSite'
      Size = 1
    end
    object MemSrchJobNo: TStringField
      DisplayWidth = 10
      FieldName = 'JobNo'
      Size = 10
    end
    object MemSrchLineMemo: TStringField
      FieldName = 'LineMemo'
      Size = 15
    end
    object MemSrchStatusNote: TStringField
      FieldName = 'StatusNote'
      Size = 50
    end
    object MemSrchSuppPartNo: TStringField
      FieldName = 'SuppPartNo'
      Size = 30
    end
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 535
    Top = 20
  end
  object QryPOEnq: TcrIBQuery
    OnCalcFields = QryPOEnqCalcFields
    SQL.Strings = (
      'SELECT'
      '  pt.LineType, '
      '  pt.ItemNo, pt.ItemParam,'
      '  pt.PackQty, pt.ItemQty, '
      '  pt.PoEnqNo,'
      '  pt.JobNo,'
      '  pm.TranSite, pm.TranDivision,'
      '  pm.IssuedDte, '
      '  pm.TranStatus, l1.Desc_Lk as TranStatusDesc, '
      '  pm.SuppRef, pm.SuppNo, '
      '  su.CompName as SuppName,'
      '  pt.LineMemo, pt.SuppPartNo'
      'FROM'
      '  PurchEnqTran pt'
      'LEFT JOIN PurchEnq pm ON (pt.Inc_PoEnqM = pm.Inc_PoEnqM)'
      'LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)'
      
        'LEFT JOIN Lookups l1 ON (pm.TranStatus = l1.Key_Lk) AND (l1.Grou' +
        'p_Lk = '#39'PESTAT'#39')')
    ResultLabel = LblSearch
    Left = 360
    Top = 5
    object QryPOEnqJOBNO: TIBStringField
      DisplayLabel = 'Job No'
      FieldName = 'JOBNO'
      Origin = 'PURCHENQTRAN.JOBNO'
      Size = 10
    end
    object QryPOEnqPOENQNO: TIBStringField
      DisplayLabel = 'Enq #'
      FieldName = 'POENQNO'
      Origin = 'PURCHENQTRAN.POENQNO'
      Size = 10
    end
    object QryPOEnqLINETYPE: TIBStringField
      Alignment = taCenter
      DisplayLabel = 'type'
      DisplayWidth = 5
      FieldName = 'LINETYPE'
      Origin = 'PURCHENQTRAN.LINETYPE'
      OnGetText = QryPOEnqLINETYPEGetText
      FixedChar = True
      Size = 1
    end
    object QryPOEnqITEMNO: TIBStringField
      DisplayLabel = 'Item #'
      FieldName = 'ITEMNO'
      Origin = 'PURCHENQTRAN.ITEMNO'
      Size = 10
    end
    object QryPOEnqITEMPARAM: TIBStringField
      DisplayLabel = 'Param'
      DisplayWidth = 7
      FieldName = 'ITEMPARAM'
      Origin = 'PURCHENQTRAN.ITEMPARAM'
      Size = 10
    end
    object QryPOEnqTRANSITE: TIBStringField
      Alignment = taCenter
      DisplayLabel = 'si'
      DisplayWidth = 2
      FieldName = 'TRANSITE'
      Size = 1
    end
    object QryPOEnqTRANDIVISION: TIBStringField
      DisplayLabel = 'Division'
      DisplayWidth = 7
      FieldName = 'TRANDIVISION'
      Size = 8
    end
    object QryPOEnqISSUEDDTE: TDateTimeField
      DisplayLabel = 'Issued'
      DisplayWidth = 10
      FieldName = 'ISSUEDDTE'
      Origin = 'PURCHENQ.ISSUEDDTE'
      DisplayFormat = 'ddddd'
    end
    object QryPOEnqTRANSTATUS: TIBStringField
      DisplayLabel = 'Status'
      DisplayWidth = 9
      FieldName = 'TRANSTATUS'
      Visible = False
      Size = 10
    end
    object QryPOEnqTRANSTATUSDESC: TIBStringField
      DisplayLabel = 'Status'
      DisplayWidth = 9
      FieldName = 'TRANSTATUSDESC'
      Size = 30
    end
    object QryPOEnqPackQTY: TIntegerField
      DisplayLabel = 'Packs'
      DisplayWidth = 7
      FieldName = 'PackQTY'
      DisplayFormat = ',0'
    end
    object QryPOEnqITEMQTY: TIntegerField
      DisplayLabel = 'Items'
      DisplayWidth = 7
      FieldName = 'ITEMQTY'
      Origin = 'PURCHENQTRAN.ITEMQTY'
      DisplayFormat = ',0'
    end
    object QryPOEnqSUPPNO: TIBStringField
      FieldName = 'SUPPNO'
      Visible = False
      Size = 10
    end
    object QryPOEnqSUPPNAME: TIBStringField
      DisplayLabel = 'Supplier'
      DisplayWidth = 30
      FieldName = 'SUPPNAME'
      Size = 50
    end
    object QryPOEnqSUPPREF: TIBStringField
      DisplayLabel = 'Supplier Ref.'
      DisplayWidth = 10
      FieldName = 'SUPPREF'
    end
    object QryPOEnq_LineMemo: TStringField
      DisplayLabel = 'Line Memo'
      DisplayWidth = 40
      FieldKind = fkCalculated
      FieldName = '_LineMemo'
      Size = 128
      Calculated = True
    end
    object QryPOEnqLINEMEMO: TMemoField
      FieldName = 'LINEMEMO'
      Origin = 'PURCHTRAN.LINEMEMO'
      Visible = False
      BlobType = ftMemo
      Size = 8
    end
    object QryPOEnqSUPPPARTNO: TIBStringField
      DisplayLabel = 'SuppPartNo'
      DisplayWidth = 15
      FieldName = 'SUPPPARTNO'
      Origin = 'PURCHTRAN.SUPPPARTNO'
      Size = 30
    end
  end
  object SrcPOEnq: TDataSource
    DataSet = QryPOEnq
    OnStateChange = SrcPOEnqStateChange
    Left = 370
    Top = 20
  end
  object QrySite: TIBQuery
    SQL.Strings = (
      'SELECT '
      '  si.Site, si.SiteDesc'
      'FROM'
      '  Site si '
      'ORDER BY '
      '  si.Site')
    Left = 310
    Top = 5
    object QrySiteSITE: TIBStringField
      FieldName = 'SITE'
      Origin = 'SITE.SITE'
      FixedChar = True
      Size = 1
    end
    object QrySiteSITEDESC: TIBStringField
      FieldName = 'SITEDESC'
      Origin = 'SITE.SITEDESC'
      Size = 50
    end
  end
  object LkpSite: TkbmMemTable
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
    Left = 320
    Top = 20
    object LkpSiteSITE: TIBStringField
      DisplayLabel = 'Site'
      DisplayWidth = 5
      FieldName = 'SITE'
      Size = 1
    end
    object LkpSiteSITEDESC: TIBStringField
      DisplayLabel = 'Site Description'
      DisplayWidth = 40
      FieldName = 'SITEDESC'
      Size = 50
    end
  end
  object SrcLkpSite: TDataSource
    DataSet = LkpSite
    Left = 330
    Top = 35
  end
  object Lst: TcrDlgList
    Caption = 'View SQL'
    Left = 528
    Top = 100
  end
end
