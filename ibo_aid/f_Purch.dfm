object FrmFndPurchase: TFrmFndPurchase
  Left = 417
  Top = 200
  BorderStyle = bsDialog
  Caption = 'Find Purchase Order'
  ClientHeight = 392
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
  PixelsPerInch = 96
  TextHeight = 13
  object Tit: TcrTitle
    Left = 0
    Top = 0
    Width = 752
    Height = 29
    StartColor = clRed
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Btns: TcrBtnPanel
    Left = 0
    Top = 357
    Width = 752
    Align = alBottom
    Style = crpsCancelSelect
    OnButtonClick = BtnsButtonClick
  end
  object GrpSearch: TGroupBox
    Left = 0
    Top = 29
    Width = 752
    Height = 92
    Align = alTop
    Caption = ' Search Criteria '
    TabOrder = 0
    OnEnter = GrpSearchEnter
    OnExit = GrpSearchExit
    DesignSize = (
      752
      92)
    object SepSrchOrdered: TcrSeparator
      Left = 5
      Top = 35
      Width = 106
      Height = 15
      Caption = 'Ordered between'
    end
    object crLabel12: TcrLabel
      Left = 137
      Top = 11
      Width = 51
      Height = 13
      Caption = 'Supplier #:'
      Shadow.Color = clBtnShadow
    end
    object InfSrchSupp: TcrdBInfo
      Left = 280
      Top = 10
      Width = 266
      Height = 19
      AutoSize = False
      DataField = 'SuppName'
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
    object LblSrchPartNo: TcrLabel
      Left = 142
      Top = 31
      Width = 46
      Height = 13
      Caption = 'Order No:'
      AlignTo = EdtSrchNo
      Shadow.Color = clBtnShadow
    end
    object Label1: TcrLabel
      Left = 126
      Top = 51
      Width = 62
      Height = 13
      Caption = 'Contract/CC:'
      AlignTo = EdtTranRef
      Shadow.Color = clBtnShadow
    end
    object Label2: TcrLabel
      Left = 124
      Top = 71
      Width = 64
      Height = 13
      Caption = 'Supplier Ref.:'
      AlignTo = EdtSuppRef
      Shadow.Color = clBtnShadow
    end
    object crLabel10: TcrLabel
      Left = 329
      Top = 31
      Width = 49
      Height = 13
      Caption = 'Issued By:'
      FocusControl = LkpSrchIssuedBy
      Shadow.Color = clBtnShadow
    end
    object crLabel13: TcrLabel
      Left = 345
      Top = 51
      Width = 33
      Height = 13
      Caption = 'Status:'
      FocusControl = LkpSrchStatus
      Shadow.Color = clBtnShadow
    end
    object Spd: TSpeedButton
      Left = 650
      Top = 9
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
    object SepOrderBy: TcrSeparator
      Left = 620
      Top = 55
      Width = 126
      Height = 15
      Caption = 'Order By'
    end
    object InfLkpSuppNo: TcrInfo
      Left = 190
      Top = 10
      Width = 88
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
    object DteSrchFrom: TcrdbDateEdit
      Left = 5
      Top = 50
      Height = 19
      Hint = 'This will only allow a six month window...'
      AutoSelect = False
      Ctl3D = False
      DataField = 'From'
      DataSource = SrcSrch
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object DteSrchUntil: TcrdbDateEdit
      Left = 5
      Top = 70
      Height = 19
      Hint = 'This will only allow a six month window...'
      AutoSelect = False
      Ctl3D = False
      DataField = 'Until'
      DataSource = SrcSrch
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object EdtSrchNo: TDBEdit
      Left = 190
      Top = 30
      Width = 88
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'TranNo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 2
    end
    object EdtTranRef: TDBEdit
      Left = 190
      Top = 50
      Width = 88
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'TranRef'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 3
    end
    object EdtSuppRef: TDBEdit
      Left = 190
      Top = 70
      Width = 88
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'SuppRef'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 4
    end
    object LkpSrchIssuedBy: TcrdbLookupComboBox
      Left = 380
      Top = 30
      Width = 166
      Height = 19
      Ctl3D = False
      DataField = 'TranUser'
      DataSource = SrcSrch
      KeyField = 'UserName'
      ListField = 'UserLong'
      ListSource = SrcLkpUser
      ParentCtl3D = False
      TabOrder = 5
    end
    object LkpSrchStatus: TcrdbLookupComboBox
      Left = 380
      Top = 50
      Width = 166
      Height = 19
      Ctl3D = False
      DataField = 'TranStatus'
      DataSource = SrcSrch
      KeyField = 'Key_Lk'
      ListField = 'Desc_Lk'
      ListSource = SrcLkpPurchStatus
      ParentCtl3D = False
      TabOrder = 6
    end
    object BtnSrch: TButton
      Left = 670
      Top = 9
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'S&earch'
      Default = True
      TabOrder = 8
      OnClick = BtnSrchClick
    end
    object BtnClear: TButton
      Left = 670
      Top = 34
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 10
    end
    object LkpSrchOrderBy: TcrdbLookupComboBox
      Left = 621
      Top = 70
      Width = 126
      Height = 19
      Ctl3D = False
      DataField = 'OrderBy'
      DataSource = SrcSrch
      KeyField = 'OrderIndex'
      ListField = 'OrderDesc'
      ListSource = SrcSrchOrder
      ParentCtl3D = False
      TabOrder = 9
    end
    object ChkIncludeCompleted: TcrdbCheckBox
      Left = 280
      Top = 70
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Include Completed'
      DataField = 'IncludeCompleted'
      DataSource = SrcSrch
      TabOrder = 7
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
  object GrdBrw: TcrdbGrid
    Left = 0
    Top = 121
    Width = 752
    Height = 236
    Align = alClient
    Ctl3D = False
    DataSource = SrcTr
    Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    DefaultRowHeight = 17
    OnAction = GrdBrwAction
  end
  object QryTr: TcrIBQuery
    Params = <>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT '
      '  pm.SuppNo, su.CompName as SuppName,'
      '  pm.TranSite, '
      '  pm.TranNo, pm.TranRef, pm.SuppRef,'
      '  pm.TranDte, '
      '  pm.TranUser, um.UserLong as TranUserDesc,'
      '  pm.TranStatus, '
      '  L1.Desc_Lk as TranStatusDesc, L1.Log2 as IsCompleted,'
      '  pm.DeliverySite, '
      '  pm.DeliveryWare,'
      '  pm.Expected'
      'FROM '
      '  PurchMast pm'
      'LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)'
      'LEFT JOIN Users um ON (pm.TranUser = um.UserName)'
      
        'LEFT JOIN Lookups l1 ON (pm.TranStatus = L1.Key_Lk) and (l1.Grou' +
        'p_Lk='#39'POSTAT'#39')')
    FieldOptions = []
    OptionsEx = []
    Left = 135
    Top = 320
    object QryTrTRANNO: TStringField
      DisplayLabel = 'Order #'
      DisplayWidth = 11
      FieldName = 'TRANNO'
      Size = 10
    end
    object QryTrSUPPNO: TStringField
      DisplayLabel = 'Supplier #'
      DisplayWidth = 8
      FieldName = 'SUPPNO'
      Visible = False
      Size = 10
    end
    object QryTrSUPPNAME: TStringField
      DisplayLabel = 'Supplier'
      DisplayWidth = 30
      FieldName = 'SUPPNAME'
      Size = 50
    end
    object QryTrTRANSITE: TStringField
      Alignment = taCenter
      DisplayLabel = 'Ste'
      DisplayWidth = 3
      FieldName = 'TRANSITE'
      Size = 1
    end
    object QryTrTRANREF: TStringField
      DisplayLabel = 'Contract/CC'
      DisplayWidth = 10
      FieldName = 'TRANREF'
    end
    object QryTrSUPPREF: TStringField
      DisplayLabel = 'Supplier Ref.:'
      DisplayWidth = 10
      FieldName = 'SUPPREF'
    end
    object QryTrTRANDTE: TDateTimeField
      DisplayLabel = 'Ordered'
      DisplayWidth = 10
      FieldName = 'TRANDTE'
    end
    object QryTrTRANUSER: TStringField
      FieldName = 'TRANUSER'
      Visible = False
      Size = 15
    end
    object QryTrTRANUSERDESC: TStringField
      DisplayLabel = 'Ordered By'
      DisplayWidth = 15
      FieldName = 'TRANUSERDESC'
      Size = 50
    end
    object QryTrTRANSTATUS: TStringField
      FieldName = 'TRANSTATUS'
      Visible = False
      Size = 10
    end
    object QryTrTRANSTATUSDESC: TStringField
      DisplayLabel = 'Status'
      DisplayWidth = 15
      FieldName = 'TRANSTATUSDESC'
      Size = 30
    end
    object QryTrDELIVERYSITE: TStringField
      DisplayLabel = 'Site'
      FieldName = 'DELIVERYSITE'
      Visible = False
      Size = 1
    end
    object QryTrDELIVERYWARE: TStringField
      DisplayLabel = 'Ware'
      FieldName = 'DELIVERYWARE'
      Visible = False
      Size = 4
    end
    object QryTrEXPECTED: TDateTimeField
      DisplayLabel = 'Expected'
      DisplayWidth = 10
      FieldName = 'EXPECTED'
    end
    object QryTrISCOMPLETED: TStringField
      FieldName = 'ISCOMPLETED'
      Visible = False
      Size = 1
    end
  end
  object SrcTr: TDataSource
    DataSet = QryTr
    OnStateChange = SrcTrStateChange
    Left = 150
    Top = 340
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 465
    Top = 15
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrTimer
    Left = 395
    Top = 315
  end
  object MemSrch: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <
      item
        Name = 'From'
        DataType = ftDate
      end
      item
        Name = 'Until'
        DataType = ftDate
      end
      item
        Name = 'ExpectFrom'
        DataType = ftDateTime
      end
      item
        Name = 'ExpectUntil'
        DataType = ftDateTime
      end
      item
        Name = 'TranSite'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'DeliverySite'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'TranUser'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'TranStatus'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SuppNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SuppDesc'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'TranNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SuppRef'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'TranRef'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'OrderBy'
        DataType = ftInteger
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
    Left = 449
    Top = 1
    object MemSrchFrom: TDateField
      FieldName = 'From'
      OnChange = MemSrchFromChange
    end
    object MemSrchUntil: TDateField
      FieldName = 'Until'
      OnChange = MemSrchUntilChange
    end
    object MemSrchExpectFrom: TDateTimeField
      DisplayWidth = 14
      FieldName = 'ExpectFrom'
      DisplayFormat = 'ddddd ddd'
    end
    object MemSrchExpectUntil: TDateTimeField
      DisplayWidth = 14
      FieldName = 'ExpectUntil'
      DisplayFormat = 'ddddd ddd'
    end
    object MemSrchTranSite: TStringField
      FieldName = 'TranSite'
      Size = 1
    end
    object MemSrchDeliverySite: TStringField
      FieldName = 'DeliverySite'
      Visible = False
      Size = 1
    end
    object MemSrchTranUser: TStringField
      FieldName = 'TranUser'
      Size = 15
    end
    object MemSrchTranStatus: TStringField
      FieldName = 'TranStatus'
      Size = 10
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
    object MemSrchTranNo: TStringField
      FieldName = 'TranNo'
      Size = 10
    end
    object MemSrchSuppRef: TStringField
      FieldName = 'SuppRef'
    end
    object MemSrchTranRef: TStringField
      DisplayLabel = 'Our Ref.'
      DisplayWidth = 15
      FieldName = 'TranRef'
    end
    object MemSrchOrderBy: TIntegerField
      FieldName = 'OrderBy'
    end
    object MemSrchIncludeCompleted: TBooleanField
      FieldName = 'IncludeCompleted'
    end
  end
  object SrcLkpUser: TDataSource
    Left = 210
    Top = 340
  end
  object SrcLkpPurchStatus: TDataSource
    Left = 300
    Top = 340
  end
  object Dlg: TcrDlgList
    Caption = 'SQL Query'
    Left = 450
    Top = 315
  end
  object MemSrchOrder: TkbmMemTable
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
    Left = 504
    Top = 2
    object MemSrchOrderOrderIndex: TIntegerField
      FieldName = 'OrderIndex'
    end
    object MemSrchOrderOrderDesc: TStringField
      FieldName = 'OrderDesc'
      Size = 30
    end
    object MemSrchOrderOrderClause: TStringField
      FieldName = 'OrderClause'
      Size = 128
    end
  end
  object SrcSrchOrder: TDataSource
    DataSet = MemSrchOrder
    Left = 520
    Top = 15
  end
end
