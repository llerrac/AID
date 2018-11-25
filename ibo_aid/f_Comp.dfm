object FrmFndComp: TFrmFndComp
  Left = 509
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Find Company'
  ClientHeight = 471
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = crDlgFormCloseQuery
  OnCreate = crDlgFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Tit: TcrTitle
    Left = 0
    Top = 0
    Width = 789
    Height = 29
    StartColor = clTeal
    Style = tiTitle
    Border = tiNone
    Caption = '%s'
    Options = [tiAllowPrintForm]
  end
  object Pge: TcrPageControl
    Left = 0
    Top = 29
    Width = 789
    Height = 442
    ActivePage = TabBrw
    Align = alClient
    HotTrack = True
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    object TabBrw: TTabSheet
      Caption = 'TabBrw'
      object GrdBrw: TcrdbGrid
        Left = 0
        Top = 89
        Width = 787
        Height = 295
        Align = alClient
        Ctl3D = False
        DataSource = SrcComp
        DefaultDrawing = False
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = Pop
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = GrdBrwDrawColumnCell
        DefaultRowHeight = 17
        OptionsEx = [crdgBooleanSymbols]
        OnAction = GrdBrwAction
      end
      object Btns: TcrBtnPanel
        Left = 0
        Top = 384
        Width = 787
        Align = alBottom
        Style = crpsCancelSelect
        OnButtonClick = BtnsButtonClick
        object BtnView: TButton
          Left = 5
          Top = 8
          Width = 75
          Height = 23
          Caption = '&View'
          TabOrder = 2
          OnClick = BtnViewClick
        end
      end
      object GrpSearch: TcrGroupBox
        Left = 0
        Top = 0
        Width = 787
        Height = 89
        Align = alTop
        Caption = ' Search Criteria '
        TabOrder = 2
        OnEnter = GrpSearchEnter
        OnExit = GrpSearchExit
        object LblSrchName: TcrLabel
          Left = 7
          Top = 15
          Width = 78
          Height = 13
          Caption = 'Company Name:'
          AlignTo = EdtSrchName
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object LblSrchPartNo: TcrLabel
          Left = 162
          Top = 15
          Width = 57
          Height = 13
          Caption = 'Company #:'
          AlignTo = EdtSrchNo
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object LblPC: TcrLabel
          Left = 244
          Top = 15
          Width = 48
          Height = 13
          Caption = 'Postcode:'
          AlignTo = EdtSrchPC
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object Label2: TcrLabel
          Left = 309
          Top = 15
          Width = 74
          Height = 13
          Caption = 'Company Type:'
          AlignTo = LkpSrchCompType
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object LblSrchInvRefNo: TcrLabel
          Left = 245
          Top = 49
          Width = 76
          Height = 13
          Caption = 'Alternate A/c #:'
          AlignTo = EdtSrchInvRefNo
          Position = lpTopRight
          Shadow.Color = clBtnShadow
        end
        object LblSrchCountry: TcrLabel
          Left = 8
          Top = 49
          Width = 83
          Height = 13
          Caption = 'Location Country:'
          AlignTo = LkpSrchCountry
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object crLabel1: TcrLabel
          Left = 329
          Top = 49
          Width = 26
          Height = 13
          Caption = '4S #:'
          AlignTo = edtComp4sNo
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object EdtSrchName: TDBEdit
          Left = 5
          Top = 29
          Width = 153
          Height = 19
          Ctl3D = False
          DataField = 'CompName'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 0
        end
        object EdtSrchNo: TDBEdit
          Left = 160
          Top = 29
          Width = 81
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'CompNo'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 2
        end
        object EdtSrchPC: TDBEdit
          Left = 242
          Top = 29
          Width = 64
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'LocPC'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 3
        end
        object LkpSrchCompType: TcrdbLookupComboBox
          Left = 307
          Top = 29
          Width = 159
          Height = 19
          Ctl3D = False
          DataField = 'CompType'
          DataSource = SrcSrch
          KeyField = 'Key_Lk'
          ListField = 'Desc_Lk'
          ListSource = SrcCompType
          ParentCtl3D = False
          TabOrder = 4
        end
        object ChkSrchContains: TDBCheckBox
          Left = 95
          Top = 11
          Width = 61
          Height = 17
          Caption = 'c&ontains'
          DataField = 'NameContains'
          DataSource = SrcSrch
          TabOrder = 1
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object EdtSrchInvRefNo: TDBEdit
          Left = 242
          Top = 63
          Width = 81
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'InvRefNo'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 6
        end
        object ChkSrchIsSupplier: TDBCheckBox
          Left = 478
          Top = 10
          Width = 97
          Height = 17
          Caption = '&1. Suppliers'
          DataField = 'IsSupplier'
          DataSource = SrcSrch
          TabOrder = 8
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object ChkSrchIsCustomer: TDBCheckBox
          Left = 478
          Top = 45
          Width = 97
          Height = 17
          Caption = '&3. Customers'
          DataField = 'IsCustomer'
          DataSource = SrcSrch
          TabOrder = 10
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object ChkSrchIsTransporter: TDBCheckBox
          Left = 478
          Top = 28
          Width = 97
          Height = 17
          Caption = '&2. Transporters'
          DataField = 'IsTransporter'
          DataSource = SrcSrch
          TabOrder = 9
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object ChkSrchIsMarketing: TDBCheckBox
          Left = 583
          Top = 10
          Width = 97
          Height = 18
          Caption = '&4. Marketing'
          DataField = 'IsMarketing'
          DataSource = SrcSrch
          TabOrder = 11
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object ChkSrchIsAgent: TDBCheckBox
          Left = 583
          Top = 28
          Width = 97
          Height = 18
          Caption = '&5. Agents'
          DataField = 'IsAgent'
          DataSource = SrcSrch
          TabOrder = 12
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object LkpSrchCountry: TcrdbLookupComboBox
          Left = 6
          Top = 63
          Width = 231
          Height = 19
          Ctl3D = False
          DataField = 'LocCountry'
          DataSource = SrcSrch
          KeyField = 'CountryNo'
          ListField = 'CountryName'
          ListSource = SrcCountry
          ParentCtl3D = False
          TabOrder = 5
        end
        object ChkSrchIsValidSiteComp: TDBCheckBox
          Left = 478
          Top = 65
          Width = 183
          Height = 17
          Caption = 'Show &own site only'
          DataField = 'IsValidSiteComp'
          DataSource = SrcSrch
          TabOrder = 13
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object edtComp4sNo: TDBEdit
          Left = 327
          Top = 63
          Width = 81
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'Comp4SNo'
          DataSource = SrcSrch
          ParentCtl3D = False
          TabOrder = 7
        end
        object pnlBtns: TPanel
          Left = 687
          Top = 15
          Width = 98
          Height = 72
          Align = alRight
          Anchors = [akLeft, akTop, akBottom]
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 14
          object Bevel1: TBevel
            Left = 0
            Top = 0
            Width = 5
            Height = 72
            Align = alLeft
            Shape = bsRightLine
          end
          object LblSearch: TcrLabel
            Left = 62
            Top = 6
            Width = 29
            Height = 13
            Caption = '<n/a>'
            AlignTo = BtnSrch
            Position = lpTopRight
            Shadow.Color = clBtnShadow
          end
          object Spd: TSpeedButton
            Left = 10
            Top = 4
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
          object BtnSrch: TButton
            Left = 10
            Top = 20
            Width = 83
            Height = 25
            Caption = 'S&earch'
            Default = True
            TabOrder = 0
            OnClick = BtnSrchClick
          end
          object BtnNew: TButton
            Left = 10
            Top = 46
            Width = 83
            Height = 25
            Caption = '&New Company'
            TabOrder = 1
            OnClick = BtnNewClick
          end
        end
        object DBCheckBoxisLMO: TDBCheckBox
          Left = 583
          Top = 46
          Width = 97
          Height = 18
          Caption = '&6. LMOs'
          DataField = 'ISLMO'
          DataSource = SrcSrch
          TabOrder = 15
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
    end
    object TabView: TTabSheet
      Caption = 'TabView'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 281
        Top = 78
        Width = 506
        Height = 341
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        TabOrder = 2
        object GrpLocAddress: TGroupBox
          Left = 0
          Top = 0
          Width = 506
          Height = 341
          Align = alClient
          Caption = ' &Location Address '
          TabOrder = 0
          DesignSize = (
            506
            341)
          object Label18: TcrLabel
            Left = 14
            Top = 21
            Width = 39
            Height = 13
            Caption = 'Country:'
            FocusControl = LkpLocCountry
            Shadow.Color = clBtnShadow
          end
          object Label17: TcrLabel
            Left = 5
            Top = 41
            Width = 48
            Height = 13
            Caption = 'Postcode:'
            FocusControl = EdtLocPC
            Shadow.Color = clBtnShadow
          end
          object Label16: TcrLabel
            Left = 12
            Top = 67
            Width = 41
            Height = 13
            Caption = 'Address:'
            FocusControl = MemLocAddress
            Shadow.Color = clBtnShadow
          end
          object Label19: TcrLabel
            Left = 27
            Top = 132
            Width = 26
            Height = 13
            Caption = 'Note:'
            FocusControl = MemLocNote
            Shadow.Color = clBtnShadow
          end
          object LkpLocCountry: TcrdbLookupComboBox
            Left = 55
            Top = 20
            Width = 236
            Height = 19
            Ctl3D = False
            DataField = 'LOCCOUNTRY'
            DataSource = SrcComp
            KeyField = 'CountryNo'
            ListField = 'CountryName'
            ListSource = SrcCountry
            ParentCtl3D = False
            TabOrder = 0
          end
          object EdtLocPC: TDBEdit
            Left = 55
            Top = 40
            Width = 66
            Height = 19
            CharCase = ecUpperCase
            Ctl3D = False
            DataField = 'LOCPC'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 1
          end
          object MemLocAddress: TDBMemo
            Left = 55
            Top = 65
            Width = 440
            Height = 64
            Anchors = [akLeft, akTop, akRight]
            Ctl3D = False
            DataField = 'LOCADDRESS'
            DataSource = SrcComp
            ParentCtl3D = False
            ScrollBars = ssVertical
            TabOrder = 2
          end
          object MemLocNote: TDBMemo
            Left = 55
            Top = 130
            Width = 440
            Height = 169
            Anchors = [akLeft, akTop, akRight, akBottom]
            Ctl3D = False
            DataField = 'LOCNOTE'
            DataSource = SrcComp
            ParentCtl3D = False
            ScrollBars = ssVertical
            TabOrder = 3
          end
          object BtnMtn: TcrdbBtnMaintain
            Left = 2
            Top = 307
            Width = 502
            Height = 32
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 4
            Default = True
            DataSource = SrcComp
            FocusControl = EdtCompName
            OptionsEx = []
            OnButtonClick = BtnMtnButtonClick
          end
        end
      end
      object GrpCompany: TGroupBox
        Left = 0
        Top = 0
        Width = 787
        Height = 78
        Align = alTop
        Caption = ' &Company Name '
        TabOrder = 0
        object Label1: TcrLabel
          Left = 12
          Top = 21
          Width = 40
          Height = 13
          Caption = 'Comp #:'
          FocusControl = EdtCompNo
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object Label3: TcrLabel
          Left = 77
          Top = 21
          Width = 78
          Height = 13
          Caption = 'Company Name:'
          FocusControl = EdtCompName
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object Label4: TcrLabel
          Left = 422
          Top = 21
          Width = 27
          Height = 13
          Caption = 'Type:'
          FocusControl = LkpCompType
          Position = lpTopLeft
          Shadow.Color = clBtnShadow
        end
        object Label5: TcrLabel
          Left = 17
          Top = 56
          Width = 56
          Height = 13
          Caption = 'Description:'
          FocusControl = EdtCompDesc
          Shadow.Color = clBtnShadow
        end
        object EdtCompNo: TcrdBInfo
          Left = 10
          Top = 35
          Width = 63
          Height = 19
          AutoSize = False
          DataField = 'COMPNO'
          DataSource = SrcComp
          Indent = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = isSingleResult
        end
        object lblComp4SNo: TcrLabel
          Left = 392
          Top = 56
          Width = 26
          Height = 13
          Caption = '4S #:'
          FocusControl = edt4SNo
          Shadow.Color = clBtnShadow
        end
        object EdtCompName: TDBEdit
          Left = 75
          Top = 35
          Width = 341
          Height = 19
          Ctl3D = False
          DataField = 'COMPNAME'
          DataSource = SrcComp
          ParentCtl3D = False
          TabOrder = 0
        end
        object LkpCompType: TcrdbLookupComboBox
          Left = 420
          Top = 35
          Width = 124
          Height = 19
          Ctl3D = False
          DataField = 'COMPTYPE'
          DataSource = SrcComp
          KeyField = 'Key_Lk'
          ListField = 'Desc_Lk'
          ListSource = SrcCompType
          ParentCtl3D = False
          TabOrder = 1
        end
        object EdtCompDesc: TDBEdit
          Left = 75
          Top = 55
          Width = 96
          Height = 19
          Ctl3D = False
          DataField = 'COMPDESC'
          DataSource = SrcComp
          ParentCtl3D = False
          TabOrder = 2
        end
        object ChkSupplier: TcrdbCheckBox
          Left = 585
          Top = 15
          Width = 61
          Height = 17
          Caption = 'Supplier'
          DataField = 'ISSUPPLIER'
          DataSource = SrcComp
          TabOrder = 5
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object ChkCustomer: TcrdbCheckBox
          Left = 585
          Top = 35
          Width = 71
          Height = 17
          Caption = 'Customer'
          DataField = 'ISCUSTOMER'
          DataSource = SrcComp
          TabOrder = 4
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object chkTransporter: TcrdbCheckBox
          Left = 585
          Top = 55
          Width = 75
          Height = 17
          Caption = 'Transporter'
          DataField = 'ISTRANSPORTER'
          DataSource = SrcComp
          TabOrder = 6
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object chkMarketing: TcrdbCheckBox
          Left = 662
          Top = 15
          Width = 71
          Height = 17
          Caption = 'Marketing'
          DataField = 'IsMarketing'
          DataSource = SrcComp
          TabOrder = 7
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object chkAgent: TcrdbCheckBox
          Left = 662
          Top = 35
          Width = 71
          Height = 17
          Caption = 'Agent'
          DataField = 'IsAgent'
          DataSource = SrcComp
          TabOrder = 8
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object edt4SNo: TDBEdit
          Left = 420
          Top = 55
          Width = 91
          Height = 19
          CharCase = ecUpperCase
          Ctl3D = False
          DataField = 'COMP4SNO'
          DataSource = SrcComp
          ParentCtl3D = False
          TabOrder = 3
        end
        object crdbCheckBoxLmo: TcrdbCheckBox
          Left = 662
          Top = 55
          Width = 71
          Height = 17
          Caption = 'LMO'
          DataField = 'ISLMO'
          DataSource = SrcComp
          TabOrder = 9
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 78
        Width = 281
        Height = 341
        Align = alLeft
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object GrpTel: TGroupBox
          Left = 0
          Top = 0
          Width = 281
          Height = 134
          Align = alTop
          Caption = ' &Telephony '
          TabOrder = 0
          object Label8: TcrLabel
            Left = 67
            Top = 16
            Width = 29
            Height = 13
            Caption = 'Prefix:'
            FocusControl = EdtTelPre
            Position = lpTopLeft
            Shadow.Color = clBtnShadow
          end
          object Label9: TcrLabel
            Left = 132
            Top = 16
            Width = 40
            Height = 13
            Caption = 'Number:'
            FocusControl = EdtTelNo
            Position = lpTopLeft
            Shadow.Color = clBtnShadow
          end
          object Label10: TcrLabel
            Left = 9
            Top = 31
            Width = 54
            Height = 13
            Caption = 'Telephone:'
            FocusControl = EdtFaxPre
            AlignTo = EdtTelPre
            Shadow.Color = clBtnShadow
          end
          object Label11: TcrLabel
            Left = 17
            Top = 51
            Width = 46
            Height = 13
            Caption = 'Facsimile:'
            FocusControl = EdtFaxNo
            AlignTo = EdtFaxPre
            Shadow.Color = clBtnShadow
          end
          object Label12: TcrLabel
            Left = 34
            Top = 71
            Width = 29
            Height = 13
            Caption = 'Telex:'
            FocusControl = EdtTelex
            Shadow.Color = clBtnShadow
          end
          object Label13: TcrLabel
            Left = 35
            Top = 91
            Width = 28
            Height = 13
            Caption = 'Email:'
            FocusControl = EdtEmail
            Shadow.Color = clBtnShadow
          end
          object Label14: TcrLabel
            Left = 33
            Top = 111
            Width = 30
            Height = 13
            Caption = 'www.:'
            FocusControl = EdtWww
            Shadow.Color = clBtnShadow
          end
          object EdtTelPre: TDBEdit
            Left = 65
            Top = 30
            Width = 64
            Height = 19
            Ctl3D = False
            DataField = 'TELPRE'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 0
          end
          object EdtTelNo: TDBEdit
            Left = 130
            Top = 30
            Width = 146
            Height = 19
            Ctl3D = False
            DataField = 'TELNO'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 1
          end
          object EdtFaxPre: TDBEdit
            Left = 65
            Top = 50
            Width = 64
            Height = 19
            Ctl3D = False
            DataField = 'FAXPRE'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 2
          end
          object EdtFaxNo: TDBEdit
            Left = 130
            Top = 50
            Width = 146
            Height = 19
            Ctl3D = False
            DataField = 'FAXNO'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 3
          end
          object EdtTelex: TDBEdit
            Left = 65
            Top = 70
            Width = 64
            Height = 19
            Ctl3D = False
            DataField = 'TELEX'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 4
          end
          object EdtEmail: TDBEdit
            Left = 65
            Top = 90
            Width = 211
            Height = 19
            Ctl3D = False
            DataField = 'EMAIL'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 5
          end
          object EdtWww: TDBEdit
            Left = 65
            Top = 110
            Width = 211
            Height = 19
            Ctl3D = False
            DataField = 'WWW'
            DataSource = SrcComp
            ParentCtl3D = False
            TabOrder = 6
          end
        end
        object GrpGenNotes: TcrGroupBox
          Left = 0
          Top = 134
          Width = 281
          Height = 207
          Align = alClient
          Caption = ' &General Notes '
          TabOrder = 1
          object MemGeneral: TDBMemo
            Left = 2
            Top = 15
            Width = 277
            Height = 190
            Align = alClient
            Ctl3D = False
            DataField = 'GENERALNOTE'
            DataSource = SrcComp
            ParentCtl3D = False
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
  end
  object QryComp: TcrIBDataset
    RecordCountAccurate = True
    BeforeEdit = QryCompBeforeEdit
    AfterOpen = QryCompAfterOpen
    AfterPost = QryCompAfterPost
    OnCalcFields = QryCompCalcFields
    OnFilterRecord = QryCompFilterRecord
    FieldOptions = []
    ResultLabel = LblSearch
    OptionsEx = []
    Left = 75
    Top = 255
    object QryCompINC_COMP: TIntegerField
      FieldName = 'INC_COMP'
      Visible = False
    end
    object QryCompCOMPNO: TStringField
      DisplayLabel = 'Comp #'
      DisplayWidth = 8
      FieldName = 'COMPNO'
      FixedChar = True
      Size = 10
    end
    object QryCompCOMPNAME: TStringField
      DisplayLabel = 'Company Name'
      DisplayWidth = 30
      FieldName = 'COMPNAME'
      Size = 50
    end
    object QryCompISSUPPLIER: TStringField
      Alignment = taCenter
      DisplayLabel = 'su'
      DisplayWidth = 2
      FieldName = 'ISSUPPLIER'
      FixedChar = True
      Size = 1
    end
    object QryCompISCUSTOMER: TStringField
      Alignment = taCenter
      DisplayLabel = 'cu'
      DisplayWidth = 2
      FieldName = 'ISCUSTOMER'
      FixedChar = True
      Size = 1
    end
    object QryCompISTRANSPORTER: TStringField
      Alignment = taCenter
      DisplayLabel = 'tr'
      DisplayWidth = 2
      FieldName = 'ISTRANSPORTER'
      Origin = 'COMPANY.ISTRANSPORTER'
      FixedChar = True
      Size = 1
    end
    object QryCompCOMPDESC: TStringField
      DisplayLabel = 'Description'
      DisplayWidth = 10
      FieldName = 'COMPDESC'
      Size = 25
    end
    object QryCompLOCCOUNTRY: TStringField
      DisplayLabel = 'Country'
      DisplayWidth = 15
      FieldName = 'LOCCOUNTRY'
      Visible = False
      OnGetText = QryCompLOCCOUNTRYGetText
      Size = 10
    end
    object QryCompCOUNTRYNAME: TStringField
      DisplayLabel = 'Country'
      DisplayWidth = 15
      FieldName = 'COUNTRYNAME'
      Size = 50
    end
    object QryCompLOCPC: TStringField
      DisplayLabel = 'Postcode'
      FieldName = 'LOCPC'
      FixedChar = True
    end
    object QryCompCOMPTYPE: TStringField
      FieldName = 'COMPTYPE'
      Visible = False
      Size = 1
    end
    object QryCompLOCADDRESS: TStringField
      FieldName = 'LOCADDRESS'
      Visible = False
      Size = 180
    end
    object QryCompLOCNOTE: TMemoField
      FieldName = 'LOCNOTE'
      Visible = False
      BlobType = ftMemo
      Size = 8
    end
    object QryCompTELPRE: TStringField
      FieldName = 'TELPRE'
      Visible = False
      Size = 10
    end
    object QryCompTELNO: TStringField
      FieldName = 'TELNO'
      Visible = False
      Size = 30
    end
    object QryComp_Tel: TStringField
      DisplayLabel = 'Tel.'
      DisplayWidth = 15
      FieldKind = fkCalculated
      FieldName = '_Tel'
      Visible = False
      Size = 40
      Calculated = True
    end
    object QryCompFAXPRE: TStringField
      FieldName = 'FAXPRE'
      Visible = False
      Size = 10
    end
    object QryCompFAXNO: TStringField
      FieldName = 'FAXNO'
      Visible = False
      Size = 30
    end
    object QryCompTELEX: TStringField
      FieldName = 'TELEX'
      Visible = False
      Size = 30
    end
    object QryCompEMAIL: TStringField
      FieldName = 'EMAIL'
      Visible = False
      Size = 50
    end
    object QryCompWWW: TStringField
      FieldName = 'WWW'
      Visible = False
      Size = 50
    end
    object QryCompGENERALNOTE: TMemoField
      FieldName = 'GENERALNOTE'
      Visible = False
      BlobType = ftMemo
      Size = 8
    end
    object QryCompDRBAL: TFloatField
      DisplayLabel = 'Bal ('#163'):'
      FieldName = 'DRBAL'
      Origin = 'COMPANY.DRBAL'
      DisplayFormat = ',0.00'
    end
    object QryCompDRBALOVERDUE: TFloatField
      DisplayLabel = 'Overdue'
      FieldName = 'DRBALOVERDUE'
      Origin = 'COMPANY.DRBALOVERDUE'
      DisplayFormat = ',0.00'
    end
    object QryCompDRBALCUR: TFloatField
      DisplayLabel = 'Current:'
      FieldName = 'DRBALCUR'
      Origin = 'COMPANY.DRBALCUR'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRBAL30: TFloatField
      DisplayLabel = '30 days'
      FieldName = 'DRBAL30'
      Origin = 'COMPANY.DRBAL30'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRBAL60: TFloatField
      DisplayLabel = '60 days'
      FieldName = 'DRBAL60'
      Origin = 'COMPANY.DRBAL60'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRBAL90: TFloatField
      DisplayLabel = '90 days'
      FieldName = 'DRBAL90'
      Origin = 'COMPANY.DRBAL90'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRBAL120: TFloatField
      DisplayLabel = '120 days'
      FieldName = 'DRBAL120'
      Origin = 'COMPANY.DRBAL120'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRBAL150: TFloatField
      DisplayLabel = '150 days'
      FieldName = 'DRBAL150'
      Origin = 'COMPANY.DRBAL150'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object QryCompDRLATESTTRAN: TDateTimeField
      DisplayLabel = 'Last Trans.:'
      FieldName = 'DRLATESTTRAN'
      Origin = 'COMPANY.DRLATESTTRAN'
      Visible = False
      DisplayFormat = 'ddddd ddd'
    end
    object QryCompDRLATESTUPDATE: TDateTimeField
      DisplayLabel = 'Last Updated:'
      FieldName = 'DRLATESTUPDATE'
      Origin = 'COMPANY.DRLATESTUPDATE'
      Visible = False
      DisplayFormat = 'ddddd ddd'
    end
    object QryCompVALIDSALESSITES: TStringField
      FieldName = 'VALIDSALESSITES'
      Origin = 'COMPANY.VALIDSALESSITES'
      Visible = False
      FixedChar = True
      Size = 26
    end
    object QryCompVALIDSUPPLYSITES: TStringField
      FieldName = 'VALIDSUPPLYSITES'
      Origin = 'COMPANY.VALIDSUPPLYSITES'
      Visible = False
      FixedChar = True
      Size = 26
    end
    object QryCompCOMP4SNO: TStringField
      DisplayLabel = '4S #'
      DisplayWidth = 9
      FieldName = 'COMP4SNO'
      Origin = 'COMPANY.COMP4SNO'
      Size = 10
    end
    object QryCompINVREFNO: TStringField
      DisplayLabel = 'Alt. a/c #'
      FieldName = 'INVREFNO'
      Origin = 'COMPANY.INVREFNO'
      FixedChar = True
      Size = 10
    end
    object QryComp_Adr: TStringField
      DisplayLabel = 'Address'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = '_Adr'
      Size = 100
      Calculated = True
    end
    object QryCompIsMarketing: TStringField
      FieldName = 'IsMarketing'
      Visible = False
      Size = 1
    end
    object QryCompIsAgent: TStringField
      FieldName = 'IsAgent'
      Visible = False
      Size = 1
    end
    object QryCompISLMO: TStringField
      FieldName = 'ISLMO'
      Origin = 'COMPANY.ISLMO'
      FixedChar = True
      Size = 1
    end
  end
  object SrcComp: TDataSource
    DataSet = QryComp
    OnStateChange = SrcCompStateChange
    Left = 80
    Top = 275
  end
  object MemSrch: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <
      item
        Name = 'CompNo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'CompName'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LocPC'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CompType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'NameContains'
        DataType = ftBoolean
      end
      item
        Name = 'InvRefNo'
        DataType = ftString
        Size = 10
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
    Left = 20
    Top = 255
    object MemSrchCompNo: TStringField
      FieldName = 'CompNo'
      Size = 10
    end
    object MemSrchCompName: TStringField
      DisplayWidth = 30
      FieldName = 'CompName'
      Size = 50
    end
    object MemSrchLocPC: TStringField
      FieldName = 'LocPC'
    end
    object MemSrchLocCountry: TStringField
      FieldName = 'LocCountry'
      Size = 10
    end
    object MemSrchCompType: TStringField
      FieldName = 'CompType'
      Size = 10
    end
    object MemSrchNameContains: TBooleanField
      FieldName = 'NameContains'
    end
    object MemSrchInvRefNo: TStringField
      FieldName = 'InvRefNo'
      Size = 10
    end
    object MemSrchComp4SNo: TStringField
      FieldName = 'Comp4SNo'
      Size = 10
    end
    object MemSrchIsTransporter: TBooleanField
      FieldName = 'IsTransporter'
    end
    object MemSrchIsCustomer: TBooleanField
      FieldName = 'IsCustomer'
    end
    object MemSrchIsSupplier: TBooleanField
      FieldName = 'IsSupplier'
    end
    object MemSrchIsAgent: TBooleanField
      FieldName = 'IsAgent'
    end
    object MemSrchIsMarketing: TBooleanField
      FieldName = 'IsMarketing'
    end
    object MemSrchIsValidSiteComp: TBooleanField
      FieldName = 'IsValidSiteComp'
    end
    object MemSrchisLmo: TBooleanField
      FieldName = 'isLmo'
    end
  end
  object SrcSrch: TDataSource
    DataSet = MemSrch
    Left = 30
    Top = 275
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrTimer
    Left = 440
    Top = 10
  end
  object ibTran: TIB_Transaction
    Isolation = tiCommitted
    Left = 14
    Top = 356
  end
  object MemCompType: TkbmMemTable
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
    Left = 170
    Top = 230
    object MemCompTypeKey_Lk: TStringField
      FieldName = 'Key_Lk'
      Size = 10
    end
    object MemCompTypeDesc_Lk: TStringField
      DisplayWidth = 20
      FieldName = 'Desc_Lk'
      Size = 30
    end
  end
  object QryCompType: TIBOQuery
    Params = <>
    IB_Transaction = ibTran
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  Key_Lk, Desc_Lk '
      'FROM'
      '  Lookups'
      'WHERE'
      '  Group_Lk = '#39'COTYPE'#39
      'ORDER BY'
      '  Desc_Lk, Key_Lk')
    FieldOptions = []
    Left = 170
    Top = 305
  end
  object SrcCompType: TDataSource
    DataSet = MemCompType
    Left = 190
    Top = 245
  end
  object QryCountry: TIBOQuery
    Params = <>
    IB_Transaction = ibTran
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  co.CountryNo, co.CountryName'
      'FROM'
      '  Country co'
      'ORDER BY'
      '  co.CountryNo')
    FieldOptions = []
    Left = 250
    Top = 305
  end
  object MemCountry: TkbmMemTable
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
    Left = 250
    Top = 230
    object MemCountryCountryNo: TStringField
      FieldName = 'CountryNo'
      Size = 10
    end
    object MemCountryCountryName: TStringField
      FieldName = 'CountryName'
      Size = 50
    end
  end
  object SrcCountry: TDataSource
    DataSet = MemCountry
    Left = 265
    Top = 245
  end
  object Pop: TPopupMenu
    Left = 510
    Top = 206
    object MnuShowIsSupplier: TMenuItem
      Tag = 1
      Caption = '&1. Show '#39'Is Supplier'#39
      Checked = True
      OnClick = PopClick
    end
    object MnuShowIsCustomer: TMenuItem
      Tag = 2
      Caption = '&2. Show '#39'Is Customer'#39
      Checked = True
      OnClick = PopClick
    end
    object MnuShowCompanyDescription: TMenuItem
      Tag = 3
      Caption = '&3. Show Company Description'
      Checked = True
      OnClick = PopClick
    end
    object MnuShowCountry: TMenuItem
      Tag = 4
      Caption = '&4. Show Country'
      Checked = True
      OnClick = PopClick
    end
    object MnuShowPostcode: TMenuItem
      Tag = 5
      Caption = '&5. Show Postcode'
      Checked = True
      OnClick = PopClick
    end
    object MnuShowTelephone: TMenuItem
      Tag = 6
      Caption = '&6. Show Telephone'
      OnClick = PopClick
    end
    object MnuShowAddress: TMenuItem
      Tag = 7
      Caption = '&7. Show Address'
      OnClick = PopClick
    end
  end
  object Lst: TcrDlgList
    Caption = 'View SQL'
    Left = 349
    Top = 201
  end
end
