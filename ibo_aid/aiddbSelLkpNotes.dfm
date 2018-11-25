object FrmSelLookupNote: TFrmSelLookupNote
  Left = 126
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Select Insertion Note'
  ClientHeight = 264
  ClientWidth = 244
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
  object Pge: TcrPageControl
    Left = 0
    Top = 0
    Width = 244
    Height = 264
    ActivePage = TabBrw
    Align = alClient
    HotTrack = True
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    object TabBrw: TTabSheet
      Caption = 'brw'
      object BtnBrw: TcrBtnPanel
        Left = 0
        Top = 206
        Width = 242
        Align = alBottom
        Style = crpsCancelSelect
        OnButtonClick = BtnBrwButtonClick
        object BtnViewNote: TButton
          Left = 5
          Top = 8
          Width = 58
          Height = 23
          Caption = 'View'
          TabOrder = 2
          OnClick = BtnViewNoteClick
        end
      end
      object GrdNote: TcrdbGrid
        Left = 0
        Top = 0
        Width = 242
        Height = 206
        Align = alClient
        Ctl3D = False
        DataSource = srcNote
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
        OnAction = GrdNoteAction
      end
    end
    object TabVw: TTabSheet
      Caption = 'vw'
      ImageIndex = 1
      object PnlBtn: TcrBtnPanel
        Left = 0
        Top = 206
        Width = 242
        Align = alBottom
        Style = crpsClose
        OnButtonClick = PnlBtnButtonClick
      end
      object MemLkpNoteMemo: TDBMemo
        Left = 0
        Top = 0
        Width = 242
        Height = 206
        TabStop = False
        Align = alClient
        Ctl3D = False
        DataField = 'MEMO'
        DataSource = srcNote
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object qryNte: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsGroup_Lk'
        ParamType = ptUnknown
      end>
    IB_Transaction = tran
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT ln.Desc_Lk, ln.Memo'
      'FROM    LookupNotes ln'
      'WHERE (ln.Group_Lk = :AsGroup_Lk)'
      'ORDER BY ln.Desc_Lk')
    FieldOptions = []
    Left = 115
    Top = 10
    object qryNteDESC_LK: TStringField
      DisplayLabel = 'Description'
      DisplayWidth = 35
      FieldName = 'DESC_LK'
      Origin = 'LOOKUPNOTES.DESC_LK'
      Size = 30
    end
    object qryNteMEMO: TMemoField
      FieldName = 'MEMO'
      Origin = 'LOOKUPNOTES.MEMO'
      Visible = False
      BlobType = ftMemo
      Size = 8
    end
  end
  object srcNote: TDataSource
    DataSet = qryNte
    Left = 130
    Top = 25
  end
  object Fnd: TcrDlgFind
    OnSearch = FndSearch
    Left = 20
    Top = 10
  end
  object tran: TIB_Transaction
    Isolation = tiCommitted
    Left = 65
    Top = 10
  end
end
