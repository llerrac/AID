object FrmFndAssm: TFrmFndAssm
  Left = 428
  Top = 91
  BorderStyle = bsDialog
  Caption = 'Find Assembly'
  ClientHeight = 324
  ClientWidth = 581
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
    Width = 581
    Height = 29
    StartColor = clSilver
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Btns: TcrBtnPanel
    Left = 0
    Top = 289
    Width = 581
    Align = alBottom
    Style = crpsCancelSelect
    OnButtonClick = BtnsButtonClick
  end
  object GrpSearch: TGroupBox
    Left = 0
    Top = 29
    Width = 581
    Height = 60
    Align = alTop
    Caption = ' Search Criteria '
    TabOrder = 0
    DesignSize = (
      581
      60)
    object LblSrchItemNo: TLabel
      Left = 5
      Top = 20
      Width = 57
      Height = 13
      Caption = 'Assembly #:'
    end
    object LblSrchDesc: TcrLabel
      Left = 87
      Top = 21
      Width = 56
      Height = 13
      Caption = 'Description:'
      AlignTo = EdtSrchDesc
      Position = lpTopLeft
      Shadow.Color = clBtnShadow
    end
    object LblSearch: TcrLabel
      Left = 545
      Top = 16
      Width = 29
      Height = 13
      Caption = '<n/a>'
      AlignTo = BtnSrch
      Position = lpTopRight
      Shadow.Color = clBtnShadow
    end
    object BtnSrch: TButton
      Left = 501
      Top = 30
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'S&earch'
      Default = True
      TabOrder = 2
      OnClick = BtnSrchClick
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
    object EdtSrchNo: TDBEdit
      Left = 5
      Top = 35
      Width = 78
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'ItemNo'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 0
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
    object EdtSrchDesc: TDBEdit
      Left = 85
      Top = 35
      Width = 151
      Height = 19
      CharCase = ecUpperCase
      Ctl3D = False
      DataField = 'ItemDesc'
      DataSource = SrcSrch
      ParentCtl3D = False
      TabOrder = 1
      OnEnter = EdtSrchEnter
      OnExit = EdtSrchExit
    end
  end
  object GrdBrw: TcrdbGrid
    Left = 0
    Top = 89
    Width = 581
    Height = 200
    Align = alClient
    Ctl3D = False
    DataSource = Src
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
  object Qry: TcrIBQuery
    SQL.Strings = (
      'SELECT'
      '  am.Inc_Assm, '
      '  am.ItemNo, am.ItemDesc, '
      '  am.Visibility,'
      '  am.Model, am.Engineer, '
      '  am.Status, am.IssueNo, '
      '  am.ItemMemo,'
      '  am.CreatedDte, am.CreatedBy,'
      '  am.AlteredDte, am.AlteredBy'
      'FROM'
      '  Assm am'
      'WHERE '
      '  am.ItemIsMaster = '#39'Y'#39
      'ORDER BY'
      ' am.ItemNo,  am.ItemDescUpper')
    ResultLabel = LblSearch
    OptionsEx = [crPreventIfNoParams]
    Left = 290
    Top = 6
    object QryINC_ASSM: TIntegerField
      FieldName = 'INC_ASSM'
      Required = True
      Visible = False
    end
    object QryITEMNO: TIBStringField
      DisplayLabel = 'Item #'
      DisplayWidth = 10
      FieldName = 'ITEMNO'
    end
    object QryITEMDESC: TIBStringField
      DisplayLabel = 'Assembly'
      DisplayWidth = 40
      FieldName = 'ITEMDESC'
      Size = 50
    end
    object QryVISIBILITY: TIBStringField
      Alignment = taCenter
      DisplayLabel = 'Vis'
      DisplayWidth = 3
      FieldName = 'VISIBILITY'
      Size = 1
    end
    object QryMODEL: TIBStringField
      DisplayLabel = 'Model'
      FieldName = 'MODEL'
      Size = 10
    end
    object QryENGINEER: TIBStringField
      DisplayLabel = 'Engineer'
      FieldName = 'ENGINEER'
      Size = 10
    end
    object QrySTATUS: TIBStringField
      DisplayLabel = 'Status#'
      FieldName = 'STATUS'
      Size = 10
    end
    object QryISSUENO: TIntegerField
      DisplayLabel = 'Issue'
      DisplayWidth = 5
      FieldName = 'ISSUENO'
    end
    object QryITEMMEMO: TMemoField
      FieldName = 'ITEMMEMO'
      Visible = False
      BlobType = ftMemo
      Size = 8
    end
    object QryCREATEDDTE: TDateTimeField
      FieldName = 'CREATEDDTE'
      Visible = False
    end
    object QryCREATEDBY: TIBStringField
      FieldName = 'CREATEDBY'
      Visible = False
      Size = 15
    end
    object QryALTEREDDTE: TDateTimeField
      FieldName = 'ALTEREDDTE'
      Visible = False
    end
    object QryALTEREDBY: TIBStringField
      FieldName = 'ALTEREDBY'
      Visible = False
      Size = 15
    end
  end
  object Src: TDataSource
    DataSet = Qry
    OnStateChange = SrcStateChange
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
    Left = 95
    Top = 105
    object MemSrchItemNo: TStringField
      DisplayLabel = 'Item #'
      DisplayWidth = 10
      FieldName = 'ItemNo'
    end
    object MemSrchItemDesc: TStringField
      DisplayWidth = 30
      FieldName = 'ItemDesc'
      Size = 50
    end
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 105
    Top = 125
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrTimer
    Left = 360
    Top = 10
  end
end
