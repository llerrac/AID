object FrmFndContract: TFrmFndContract
  Left = 266
  Top = 390
  BorderStyle = bsDialog
  Caption = 'Find Contract'
  ClientHeight = 324
  ClientWidth = 507
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
    Width = 507
    Height = 29
    StartColor = clOlive
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Btns: TcrBtnPanel
    Left = 0
    Top = 289
    Width = 507
    Align = alBottom
    Style = crpsCancelSelect
    OnButtonClick = BtnsButtonClick
  end
  object GrpSearch: TGroupBox
    Left = 0
    Top = 29
    Width = 507
    Height = 60
    Align = alTop
    Caption = ' Search Criteria '
    TabOrder = 0
    object LblSrchPartNo: TLabel
      Left = 15
      Top = 20
      Width = 53
      Height = 13
      Caption = 'Contract #:'
    end
    object LblSrchDesc: TcrLabel
      Left = 97
      Top = 21
      Width = 56
      Height = 13
      Caption = 'Description:'
      AlignTo = EdtSrchDesc
      Position = lpTopLeft
      Shadow.Color = clBtnShadow
    end
    object BtnSrch: TButton
      Left = 425
      Top = 30
      Width = 75
      Height = 25
      Caption = 'S&earch'
      Default = True
      TabOrder = 2
      OnClick = BtnSrchClick
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
    object EdtSrchNo: TDBEdit
      Left = 15
      Top = 35
      Width = 78
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'ContNo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 0
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
    object EdtSrchDesc: TDBEdit
      Left = 95
      Top = 35
      Width = 151
      Height = 19
      Ctl3D = False
      DataField = 'ContDesc'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 1
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
  end
  object grdCont: TcrdbGrid
    Left = 0
    Top = 89
    Width = 507
    Height = 200
    Align = alClient
    Ctl3D = False
    DataSource = SrcCont
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
    OnDrawColumnCell = grdContDrawColumnCell
    DefaultRowHeight = 17
    OnAction = grdContAction
  end
  object QryCont: TcrIBQuery
    Params = <>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  ContNo, ContDesc, CompNo, Key_Status, DteIssued'
      'FROM'
      '  Contract'
      'ORDER BY'
      '  ContNo')
    FieldOptions = []
    OptionsEx = []
    Left = 285
    Top = 10
    object QryContCONTNO: TStringField
      DisplayLabel = 'Cont #'
      DisplayWidth = 8
      FieldName = 'CONTNO'
      Size = 10
    end
    object QryContCONTDESC: TStringField
      DisplayLabel = 'Contract Description'
      DisplayWidth = 35
      FieldName = 'CONTDESC'
      Size = 50
    end
    object QryContCOMPNO: TStringField
      DisplayLabel = 'Comp #'
      FieldName = 'COMPNO'
      Size = 10
    end
    object QryContKEY_STATUS: TStringField
      DisplayLabel = 'Status'
      DisplayWidth = 10
      FieldName = 'KEY_STATUS'
      OnGetText = QryContKEY_STATUSGetText
      Size = 5
    end
    object QryContDTEISSUED: TDateTimeField
      DisplayLabel = 'Issued '
      DisplayWidth = 14
      FieldName = 'DTEISSUED'
      DisplayFormat = 'ddddd ddd'
    end
  end
  object SrcCont: TDataSource
    DataSet = QryCont
    OnStateChange = SrcContStateChange
    Left = 305
    Top = 30
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
    Left = 235
    Top = 10
    object MemSrchContNo: TStringField
      FieldName = 'ContNo'
      Size = 10
    end
    object MemSrchContDesc: TStringField
      DisplayWidth = 30
      FieldName = 'ContDesc'
      Size = 50
    end
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 245
    Top = 30
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrTimer
    Left = 360
    Top = 10
  end
end
