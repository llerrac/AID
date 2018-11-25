unit f_Part;

{
  f_Part
    Lookup Part information

  see also data.sql f_Comp, f_Cont, f_BOM, v_part
}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Mask, Grids,
  crForms, crBtns, crTitle,
  Db, DBCtrls, DBGrids, kbmMemTable,
  crdbGrid, crLabel, crdbUtil,
  IB_Components,IBODataset, crIBQry,
  aiddbLkpPart, Buttons, crDlgLst, crdbEdit, crdbEd, aiddbLkpComp, crInfo,
  crdbInfo, ComCtrls, crPage, crdbLkp,
  aidTypes;

type
  TcrboParts = (boByNo, boByDesc, boBySuppNo, boByAka1, boByAka2);
const
  CcrboParts : array[TcrboParts] of string =
    ('1. by Part #', '2. by Part Description', '3. by Supplier Part #', '4. by Aka 1', '5. by Aka 2');
type
  TvalPartNewPartEvent =
    function (Sender: TObject; var APartDef: TvalPartDef; APartNo: string): Boolean of object;
type
  TFrmFndPart = class(TcrDlgForm)
    Tit: TcrTitle;
    QryPart: TcrIBQuery;
    QryPartINC_PART: TIntegerField;
    QryPartPARTNO: TStringField;
    QryPartPARTDESC: TStringField;
    QryPartREPLACEDBY: TStringField;
    SrcPart: TDataSource;
    MemSrch: TkbmMemTable;
    MemSrchPartNo: TStringField;
    MemSrchSpare: TStringField;
    MemSrchPartDesc: TStringField;
    SrcSrch: TDataSource;
    Tmr: TTimer;
    MemSrchSuppPartNo: TStringField;
    QryPartSUPPPARTNO: TStringField;
    Lst: TcrDlgList;
    MemSrchSuppNo: TStringField;
    MemSrchSuppName: TStringField;
    QryPartSUPPNO: TStringField;
    QryPartSUPPNAME: TStringField;
    QryPartHASPARAM: TStringField;
    Pge: TcrPageControl;
    TabBrw: TTabSheet;
    TabParam: TTabSheet;
    Grd: TcrdbGrid;
    GrpParam: TGroupBox;
    GrdParam: TcrdbGrid;
    TabLevel: TTabSheet;
    QryParam: TcrIBQuery;
    QryParamPARTPARAM: TStringField;
    QryParamCOSTPRICE: TFloatField;
    SrcParam: TDataSource;
    GrpSearch: TGroupBox;
    LblSrchPartNo: TcrLabel;
    LblSrchBOMDesc: TcrLabel;
    LblSrchSupPart: TcrLabel;
    LblSearch: TcrLabel;
    Spd: TSpeedButton;
    LblSupplier: TcrLabel;
    Bvl: TBevel;
    InfSuppName: TcrdBInfo;
    EdtSrchNo: TDBEdit;
    EdtSrchDesc: TDBEdit;
    EdtSrchSuppPartNo: TDBEdit;
    BtnNew: TButton;
    BtnSrch: TButton;
    GrpPart: TGroupBox;
    LblPartNo1: TcrLabel;
    InfPartNo1: TcrdBInfo;
    LblPartDesc1: TcrLabel;
    InfPartDesc1: TcrdBInfo;
    LblOrderBy: TcrLabel;
    LkpOrderBy: TcrdbLookupComboBox;
    MemOrder: TkbmMemTable;
    MemOrderOrderBy: TStringField;
    MemOrderDesc: TStringField;
    SrcOrder: TDataSource;
    MemSrchOrderBy: TStringField;
    QryParam_SellPrice: TFloatField;
    LblAka: TcrLabel;
    EdtAKA: TDBEdit;
    QryPartPARTAKA1: TStringField;
    QryPartPARTAKA2: TStringField;
    MemSrchPartAka: TStringField;
    QryPartPARTTYPE: TStringField;
    QryPartSUPPLYCODE: TStringField;
    QryPartSUPPLYDIVISION: TStringField;
    MemSrchPartType: TStringField;
    LblPartType: TcrLabel;
    LkpPartType: TcrdbLookupComboBox;
    QryLookups: TIBOQuery;
    QryLookupsKEY_LK: TStringField;
    QryLookupsDESC_LK: TStringField;
    MemLkpPartType: TkbmMemTable;
    SrcLkpPartType: TDataSource;
    MemLkpPartTypeKEY_LK: TStringField;
    MemLkpPartTypeDESC_LK: TStringField;
    LblBusDiv: TcrLabel;
    LkpBusDiv: TcrdbLookupComboBox;
    MemSrchSupplyDivision: TStringField;
    MemLkpBusDiv: TkbmMemTable;
    MemLkpBusDivKey_Lk: TStringField;
    MemLkpBusDivDesc_Lk: TStringField;
    SrcLkpBusDiv: TDataSource;
    QryParamDTECOSTED: TDateTimeField;
    QryPartEx: TIBOQuery;
    IBStringField1: TStringField;
    IBStringField2: TStringField;
    IBStringField3: TStringField;
    FloatField1: TFloatField;
    DateTimeField1: TDateTimeField;
    IBStringField4: TStringField;
    QryPartONORDER: TIntegerField;
    QryPartLASTORDERED: TDateTimeField;
    QryPartLASTCOSTGBP: TFloatField;
    QryPartLASTTRANNO: TStringField;
    QryPartNEXTEXPECTED: TDateTimeField;
    QryPartNEXTTRANNO: TStringField;
    QryPartSALENOTE: TStringField;
    QryPartDEPARTMENT: TStringField;
    IBStringField5: TStringField;
    Btns1: TcrBtnPanel;
    BtnLevels1: TButton;
    Btns2: TcrBtnPanel;
    BtnLevels2: TButton;
    BtnsLevels: TcrBtnPanel;
    crLabel1: TLabel;
    QryPartPARTVERSION: TStringField;
    ChkSrchContains: TDBCheckBox;
    MemSrchDescContains: TBooleanField;
    QryPartHASDOCS: TStringField;
    InfLkpSuppNo: TcrInfo;
    QryPartISSUENO: TIntegerField;
    QryPartDRAWING: TStringField;
    QryPartKEY_ENG: TStringField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure Btns1ButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure SrcPartStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure BtnNewClick(Sender: TObject);
    procedure GrpSearchEnter(Sender: TObject);
    procedure GrpSearchExit(Sender: TObject);
    procedure SpdClick(Sender: TObject);
    procedure QryPartCalcFields(DataSet: TDataSet);
    procedure MemSrchSuppNoChange(Sender: TField);
    procedure GrdParamAction(Sender: TObject; Action: TcrdbAction;
      Arg: Word);
    procedure crDlgFormShow(Sender: TObject);
    procedure PgeChange(Sender: TObject);
    procedure QryPartCOSTPRICEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure QryPartSELLPRICEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure QryParamCalcFields(DataSet: TDataSet);
    procedure QryParamCOSTPRICEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure QryParam_SellPriceGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure QryPartHASPARAMGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure BtnsLevelsButtonClick(Sender: TcrBtnPanel;
      Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure BtnLevelsClick(Sender: TObject);
    procedure GrdDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QryPart_CostPriceGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure MemSrchNewRecord(DataSet: TDataSet);
    procedure GrdTitleHint(Sender: TObject; AField: TField;
      var AHint: String);
    procedure EdtSrchNoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
     { Private declarations }
    FrOptions : TvalPartLkpOptions;
    LkpSuppNo : TvaldbLookupCompany;
    //
    procedure CheckSelectEnabled;
    function  SelectRow: Boolean;
    procedure ShowLevels;
    procedure RefreshQuery;
    procedure NormalSearch;
    procedure KeySearch;
    procedure LoadLookups;
    // CGR20010730 - Enabled call-back to data module to centralise TvalPartDef filling to update this code
    procedure DoGetPartInfo(AsPartNo, AsPartParam: string; var ArPartDef: TvalPartDef);

  public
     { Public declarations }
  end;

var
  FrmFndPart      : TFrmFndPart;
  OnNewPartClick  : TvalPartNewPartEvent;
  OnCalcFields    : TDatasetNotifyEvent;

function Execute(ADatabase: TIB_connection; var APartDef: TvalPartDef; AOptions: TvalPartLkpOptions): Boolean;


implementation

{$R *.DFM}

uses
  crUtil, aidUtil, Dialogs, aidLang, aiddbUtil,crDbCommon;

var
  XrPartDef : TvalPartDef;
  XuDatabase: TIB_connection;
  XrOptions : TvalPartLkpOptions;


function Execute(ADatabase: TIB_connection; var APartDef: TvalPartDef; AOptions: TvalPartLkpOptions) : Boolean;
begin
  XrPartDef := APartDef;
  XuDatabase:= ADatabase;
  XrOptions := AOptions;
  //
  Result    := RunDlgForm(TFrmFndPart, FrmFndPart)=mrOk;
  APartDef  := XrPartDef;
end;

procedure TFrmFndPart.crDlgFormCreate(Sender: TObject);
begin
  FrOptions:= XrOptions;
  //
  Pge.PreparePage;
  // Manually creat LkpSuppNo, as this is part of the same library, and should
  // not be done manually
  LkpSuppNo:= TvaldbLookupCompany.Create(Self);
  LkpSuppNo.Parent:= GrpSearch;
  LkpSuppNo.SetBounds(235, 40, 84, 19);
  LkpSuppNo.AutoSelect:= False;
  LkpSuppNo.CharCase:= ecUpperCase;
  LkpSuppNo.Ctl3D := False;
  LkpSuppNo.DataField := MemSrchSuppNo.FieldName;
  LkpSuppNo.DataSource := SrcSrch;
  LkpSuppNo.ParentCtl3D := False;
  LkpSuppNo.TabOrder := 5;
  //
  QryLookups.IB_connection:= XuDatabase;
  LoadLookups;
  //
  MemSrch.Active:= True;
  MemSrch.Append;
  MemSrchOrderBy.Value:= IntToStr(Ord(boByDesc));
  MemSrchPartNo .Value:= Trim(XrPartDef.PartNo);
  QryPart   .IB_connection:= XuDatabase;
  QryPartEx .IB_connection:= XuDatabase;
  QryParam  .IB_connection:= XuDatabase;
  LkpSuppNo .Database:= XuDatabase;
  //
  if Length(Trim(XrPartDef.PartNo))>0 then
  begin
    Tmr.Tag:= 1;
    Tmr.Enabled:= True;
  end;
  //
  Grd.ShowHint:=  True;
  //
  QryPart.StoreSQL;
  CheckSelectEnabled;
end;


procedure TFrmFndPart.BtnSrchClick(Sender: TObject);
begin
  EdtSrchNo.Text := StringReplace( EdtSrchNo.Text, ' ', '', [ rfReplaceAll ] );
  if MemSrch.State in [dsEdit, dsInsert] then MemSrch.Post;
  //
  RefreshQuery;
  //
  if not (QryPart.Eof and QryPart.Bof) then TryToFocus(Grd);
end;

procedure TFrmFndPart.Btns1ButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpSelect:
      if not SelectRow then ModalResult:= mrNone;
    crbpCancel:
      if Pge.ActivePageIndex>0 then
      begin
        Pge.ActivePageIndex:= 0;
        ModalResult:= mrNone;
      end
  end;;
end;


procedure TFrmFndPart.CheckSelectEnabled;
var
  lOk : Boolean;
begin
  lOk:= QryPart.Active and (not QryPart.IsEmpty);
  //
  Btns1.SetEnabledState(crbpSelect, lOk);
  Btns2.SetEnabledState(crbpSelect, lOk);
  //
  BtnLevels1.Enabled:= lOk;
  BtnLevels2.Enabled:= lOk;
end;


procedure TFrmFndPart.SrcPartStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndPart.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
  // If no result, then search within description
  if QryPart.IsEmpty then
  begin
    MemSrch.Active:= True;
    MemSrch.Append;
    MemSrchPartDesc.Value:= Trim(XrPartDef.PartNo);
    //
    BtnSrch.Click;
  end;
  //
  Tmr.Tag:= 0;
end;



function TFrmFndPart.SelectRow: Boolean;
var
  iR    : TModalResult;
  sR    : string;
  //
  sPart : string;
  sParam: string;
begin
  Result:= True;
  FillChar(XrPartDef, SizeOf(TvalPartDef), #0);
  sPart := '';
  sParam:= '';
  //
  iR:= mrNo;
  if (Pge.ActivePage <> TabParam) then
    if not IsEmptyStr(QryPartREPLACEDBY.Value) then
      iR:= MessageDlg(rsPartHasReplacement, mtWarning, mbYesNoCancel, 0);
  //
  case iR of
    mrYes     :
    begin
      sR:= QryPartREPLACEDBY.Value;
      QryPart.Active:= False;
      QryPart.ReStoreSQL;
      QryPart.AddWhereClause(QryPartPARTNO  , sR, cropEqual , 'Part #: %s', crcoAND, False);
      QryPart.Activate;
      //
      sPart:= Trim(QryPartPARTNO.Value);
    end;
    mrNo      :
    begin
      sPart:= Trim(QryPartPARTNO.Value);
    end;
    mrCancel  :
      Abort;
  end;
  //
  if (iR<>mrCancel) then
  begin
    // Has a parameter, deal with separatly
    if QryPartHASPARAM.AsBoolean then
    begin
      if Pge.ActivePageIndex=0 then
      begin
        Pge     .ChangeToPage(TabParam);
        QryParam.Active:= True;
        Result:= False;
      end
      else
        sParam:= Trim(QryParamPARTPARAM.Value);
    end;
  end;
  //
  if Result then
    DoGetPartInfo(sPart, sParam, XrPartDef);
end;


procedure TFrmFndPart.GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaEdit,
    crbaView    :
      if SelectRow then
        ModalResult:= mrOk;
    crbaHeader:
{      if Arg = 1 then
        SortOrder:= boByNo
      else
        if Arg = 2 then
          SortOrder:= boByDesc
        else
          if Arg = 8 then
            SortOrder:= boBySuppNo;}
  end;
end;

procedure TFrmFndPart.BtnNewClick(Sender: TObject);
var
  rNewPart  : TvalPartDef;
begin
  if Assigned(OnNewPartClick) then
    if OnNewPartClick(Self, rNewPart, MemSrchPartNo.AsString) then
    begin
      XrPartDef  := rNewPart;
      ModalResult:= mrOk;
    end;
end;


procedure TFrmFndPart.GrpSearchEnter(Sender: TObject);
begin
  Btns1  .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndPart.GrpSearchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns1  .Default:= True;
end;

procedure TFrmFndPart.SpdClick(Sender: TObject);
begin
  Lst.Execute(QryPart.SQL);
end;


procedure TFrmFndPart.RefreshQuery;
var
  sPtNo : string;
begin
  sPtNo := QryPartPartNo.AsString;
  QryPart.DisableControls;
  try
    if ( ( IsEmptyStr( MemSrchPartNo.AsString ) or ( Trim( MemSrchPartNo.AsString ) = '_' ) ) and
         not( IsEmptyStr( MemSrchPARTDESC.AsString ) ) ) then
    begin
      QryPart.OptionsEx := [];
      KeySearch;
      QryPart.StoreSQL;
      QryPart.ReStoreSQL;
    end
    else
    begin
      QryPart.OptionsEx := [crPreventIfNoParams];
      NormalSearch;
      QryPart.StoreSQL;
      QryPart.ReStoreSQL;
      QryPart.AddWhereClause(QryPartPARTNO    , MemSrchPARTNO    .AsString, cropLike , 'Part #: %s'       , crcoAND, False, 'pm.' );
      if (MemSrchDescContains.Value) then
      begin
        QryPart.AddWhereClause('PartDescUpper', UpperCase( MemSrchPARTDESC.AsString ), cropContains, 'Part Desc.: %s'  , crcoAND, False, 'pm.')
      end
      else
      begin
        QryPart.AddWhereClause('PartDescUpper', UpperCase( MemSrchPARTDESC.AsString ), cropLike , 'Part Desc.: %s'   , crcoAND, False, 'pm.');
      end;
    end;
    // Also known as
    QryPart.AddWhereOpenParenthesis;
    QryPart.AddWhereClause(QryPartPARTAKA1 , MemSrchPARTAka .AsString, cropLike , 'Aka like %s' , crcoOR, False, 'pm.' );
    QryPart.AddWhereClause(QryPartPARTAKA2 , MemSrchPARTAka .AsString, cropLike , 'Aka like %s' , crcoOR, False, 'pm.' );
    QryPart.AddWhereCloseParenthesis;
    //
//    QryPart.AddWhereClause('SuppPartNoLite' , OnlyAlpha(MemSrchSuppPartNo.AsString), cropLike , 'Supp.PartNo: %s'  , crcoAND, False, 'pm.');
//    QryPart.AddWhereClause(QryPartSuppNo    , MemSrchSuppNo    .AsString, cropLike , 'Supplier #: %s'   , crcoAND, False, 'pm.' );
    QryPart.AddWhereClause(QryPartPARTTYPE  , MemSrchPARTTYPE  .AsString, cropEqual, 'Part Type: %s'    , crcoAND, False, 'pm.' );
    //
    if (valloAdministrative in FrOptions) then
    begin
      QryPart.AddWhereClause(QryPartPartType      , 'ADMIN', cropEqual, 'Administrative', crcoAND, False, 'pm.' );
      QryPart.AddWhereClause(QryPartSUPPLYDIVISION, MemSrchSupplyDivision.AsString, cropEqual, 'Supply Division: %s'    , crcoAND, False, 'pm.' );
//      QryPart.AddWhereClause(QryPartSupplyDivision, '1000' , cropEqual, ''              , crcoAND, False);
    end;
    //
    case TcrboParts(StrToInt(MemSrchOrderBy.Value)) of
      boByNo  :
      begin
        QryPart.AddOrderClause('ORDER BY pm.PartNoSeq, pm.PartNo');
        Grd.SortDisplay.SetSortField(QryPartPartNo)
      end;
      boByDesc:
      begin
        QryPart.AddOrderClause('ORDER BY pm.PartDesc, pm.PartNoSeq');
        Grd.SortDisplay.SetSortField(QryPartPartDesc)
      end;
      boBySuppNo:
      begin
        QryPart.AddOrderClause('ORDER BY pm.SuppPartNoLite, pm.PartNoSeq');
        Grd.SortDisplay.SetSortField(QryPartSuppPartNo)
      end;
      boByAka1:
      begin
        QryPart.AddOrderClause('ORDER BY pm.PartAka1, pm.PartNoSeq');
        Grd.SortDisplay.SetSortField(QryPartPartAka1)
      end;
      boByAka2:
      begin
        QryPart.AddOrderClause('ORDER BY pm.PartAka2, pm.PartNoSeq');
        Grd.SortDisplay.SetSortField(QryPartPartAka2)
      end;
    end;
    //
    QryPart.Activate;
    if not IsEmptyStr(sPtNo) then
      QryPart.Locate(QryPartPartNo.FieldName, sPtNo, [loCaseInsensitive, loPartialKey]);
  finally
    QryPart.EnableControls;
  end;
  //
  CheckSelectEnabled;
end;

procedure TFrmFndPart.NormalSearch;
begin
  QryPart.SQL.Clear;
  QryPart.SQL.Add( 'SELECT distinct pm.Inc_Part,' );
  QryPart.SQL.Add( '  pm.PartNo, pm.IssueNo,' );
  QryPart.SQL.Add( '  pm.PartDesc, pm.PartVersion,' );
  QryPart.SQL.Add( '  pm.Drawing, pm.Key_Eng,' );
  QryPart.SQL.Add( '  pm.ReplacedBy, pm.HasDocs,' );
  QryPart.SQL.Add( '  pm.SuppPartNo, pm.SuppNo,' );
  QryPart.SQL.Add( '  pm.PartAka1, pm.PartAka2,' );
  if ( not IsEmptyStr( MemSrchSuppPartNo.AsString ) ) or ( not IsEmptyStr( MemSrchSUPPNO.AsString ) ) then
  begin
    QryPart.SQL.Add( '  ManuName as SuppName,' );
  end
  else
  begin
    QryPart.SQL.Add( '  su.CompName as SuppName,' );
  end;
  QryPart.SQL.Add( '  pm.HasParam,' );
  QryPart.SQL.Add( '  pm.PartType, pm.SupplyCode, pm.SupplyDivision' );

  QryPart.SQL.Add( 'FROM' );
  if ( not IsEmptyStr( MemSrchSuppPartNo.AsString ) ) then
  begin
    QryPart.OptionsEx := [];
    if ( not IsEmptyStr( MemSrchSUPPNO.AsString ) ) then
    begin
      QryPart.SQL.Add(
        Format( 'PROC_Part_SuppPartNo_Search_Ex( ''%s'', ''N'', ''%s'' ) pm',
          [ OnlyAlpha( MemSrchSuppPartNo.AsString ), MemSrchSuppNo.AsString ] ) );
    end
    else
    begin
      QryPart.SQL.Add(
        Format( 'PROC_Part_SuppPartNo_Search( ''%s'', ''N'' ) pm',
          [ OnlyAlpha( MemSrchSuppPartNo.AsString ) ] ) );
    end;
  end
  else
  begin
    if ( not IsEmptyStr( MemSrchSUPPNO.AsString ) ) then
    begin
      QryPart.OptionsEx := [];
      QryPart.SQL.Add(
        Format( 'Proc_Part_Supplier_Search( ''%s'' ) pm',
          [ MemSrchSuppNo.AsString ] ) );
    end
    else
    begin
      QryPart.SQL.Add( '  Part PM' );
    end;
  end;

  if ( IsEmptyStr( MemSrchSuppPartNo.AsString ) ) and ( IsEmptyStr( MemSrchSUPPNO.AsString ) ) then
  begin
    QryPart.SQL.Add( 'LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)' );
  end;
  QryPart.SQL.Add( 'ORDER BY' );
  QryPart.SQL.Add( '  pm.PartNoSeq, pm.PartNo' );
end;

procedure TFrmFndPart.KeySearch;
var
  lsKeyWords : String;
  loStr      : TStrings;
  liK        : Integer;
begin
  QryPart.SQL.Clear;
  QryPart.SQL.Add( 'SELECT distinct pm.Inc_Part,' );
  QryPart.SQL.Add( '       pm.PartNo, pm.IssueNo,' );
  QryPart.SQL.Add( '       pm.PartDesc, pm.PartVersion,' );
  QryPart.SQL.Add( '       pm.Drawing, pm.Key_Eng,' );
  QryPart.SQL.Add( '       pm.ReplacedBy, pm.HasDocs,' );
  QryPart.SQL.Add( '       pm.SuppPartNo, pm.SuppNo,' );
  QryPart.SQL.Add( '       pm.PartAka1, pm.PartAka2,' );
  QryPart.SQL.Add( '       SuppName,' );
  QryPart.SQL.Add( '       pm.HasParam,' );
  QryPart.SQL.Add( '       pm.PartType, pm.SupplyCode, pm.SupplyDivision' );
  QryPart.SQL.Add( 'from   PROC_Part_Keyword_Search_Ex ( ' );
  if ( MemSrchDescContains.AsBoolean ) then
  begin
    QryPart.SQL.Add( '         ''Y''' );
  end
  else
  begin
    QryPart.SQL.Add( '         ''N''' );
  end;

  lsKeyWords := udf_CreateKeywords( MemSrchPARTDESC.AsString );
  loStr:= TStringList.Create;
  try
    crUtil.StringToStrings( lsKeyWords, loStr, '~', False );
    liK := 0;
    while ( ( liK < 6 ) and ( liK < loStr.Count ) ) do
    begin
      QryPart.SQL.Add( Format( '         ,''%s''', [ loStr[liK] ] ) );
      liK := liK + 1;
    end;
    for liK := loStr.Count to 5 do
    begin
      QryPart.SQL.Add( '         ,''''' );
    end;
  finally
    loStr.Free;
  end;
  QryPart.SQL.Add( Format( '         ,''%s''', [ MemSrchSuppNo.AsString ] ) );
  QryPart.SQL.Add( '        ) PM' );
  QryPart.SQL.Add( 'ORDER BY pm.PartNoSeq' );
end;

procedure TFrmFndPart.QryPartCalcFields(DataSet: TDataSet);
begin
  if Assigned(OnCalcFields) then
    OnCalcFields(DataSet);
end;

procedure TFrmFndPart.MemSrchSuppNoChange(Sender: TField);
var
  rCompDef: TvalCompDef;
begin
  aiddbUtil.GetCompanyInfo(QryPart.IB_connection, Sender.AsString, rCompDef);
  MemSrchSuppName.AsString:= rCompDef.CompName;
end;

procedure TFrmFndPart.GrdParamAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaEdit,
    crbaView    :
      if SelectRow then
        ModalResult:= mrOk;
  end;
end;

procedure TFrmFndPart.crDlgFormShow(Sender: TObject);
begin
  BtnNew.Enabled:= Assigned(OnNewPartClick);
  TryToFocus(EdtSrchNo);
end;

procedure TFrmFndPart.PgeChange(Sender: TObject);
begin
{  if (Pge.ActivePage = TabParam) then
  begin
    if not (QryParam.Eof and QryParam.Bof) then
    begin
      GrdParam.SetFocus;
    end;
  end;}
end;

procedure TFrmFndPart.LoadLookups;
var
  iK  : TcrboParts;
  procedure LoadLookupTo(sGroup: String; ADataset: TkbmMemTable);
  begin
    QryLookups.Close;
    QryLookups.ParamByName('AsGroup_Lk').AsString:= sGroup;
    QryLookups.Open;
    //
    ADataset.Close;
    ADataset.Active:= True;
    ADataset.LoadFromDataSet(QryLookups, []);
    QryLookups.Close;
  end;
begin
  MemOrder.Close;
  MemOrder.Active:= True;
  for iK:= Low(TcrboParts) to High(TcrboParts) do
    MemOrder.AppendRecord([IntToStr(Ord(iK)), CcrboParts[iK]]);
  // Part Lookups
  LoadLookupTo('STCKTY', MemLkpPartType);
  LoadLookupTo('BUSDIV', MemLkpBusDIV);
  //
  LkpBusDiv            .Visible:=     (valloAdministrative in FrOptions);
  LblBusDiv            .Visible:=     (valloAdministrative in FrOptions);
  QryPartSUPPPARTNO    .Visible:= not (valloAdministrative in FrOptions);
  QryPartSUPPNAME      .Visible:= not (valloAdministrative in FrOptions);
  QryPartSUPPLYCODE    .Visible:=     (valloAdministrative in FrOptions);
  QryPartSUPPLYDIVISION.Visible:=     (valloAdministrative in FrOptions);
end;

procedure TFrmFndPart.QryPartCOSTPRICEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= PartFormattedPrice(Sender, DisplayText, QryPartHasParam.AsBoolean);
end;

procedure TFrmFndPart.QryPartSELLPRICEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= PartFormattedPrice(Sender, DisplayText, QryPartHasParam.AsBoolean);
end;

procedure TFrmFndPart.QryParamCalcFields(DataSet: TDataSet);
begin
  if Assigned(OnCalcFields) then
    OnCalcFields(DataSet);
end;

procedure TFrmFndPart.QryParamCOSTPRICEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= PartFormattedPrice(Sender, DisplayText, False);
end;

procedure TFrmFndPart.QryParam_SellPriceGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= PartFormattedPrice(Sender, DisplayText, False);
end;

procedure TFrmFndPart.QryPartHASPARAMGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=Sender.AsString;
  if DisplayText then
    if Sender.AsBoolean then Text:= 'Y' else Text:= '-';
end;

procedure TFrmFndPart.BtnsLevelsButtonClick(Sender: TcrBtnPanel;
  Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if Button = crbpDone then
  begin
    Pge.ActivePageIndex:= 1;
    TryToFocus(Grd);
  end;
end;

procedure TFrmFndPart.BtnLevelsClick(Sender: TObject);
begin
  ShowLevels;
end;

procedure TFrmFndPart.ShowLevels;
begin
  Pge.ChangeToPage(TabLevel);
end;

procedure TFrmFndPart.GrdDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if ((Column.Field=QryPartPARTDESC) or (Column.Field=QryPartPARTNO) or (Column.Field=QryPartSUPPPARTNO)) and
    (not IsEmptyStr(QryPartReplacedBy.AsString)) then
  begin
    Grd.DrawGrayTextCell  (Rect, Column, State);
  end;
  // Booleans
  if Assigned(Column) and Assigned(Column.Field) and
    ((Column.Field=QryPartHasDocs) or (Column.Field=QryPartHasParam)) then
  begin
    Grd.DrawBooleanColumn(Rect, Column, State);
  end;
  //  Now highlight the filter (this only underlines, doesn't draw text)
  if Assigned(Column) and (Column.Field = QryPartPARTDESC) and
     ( ( MemSrchDescContains.Value ) or ( IsEmptyStr( MemSrchPartNo.Value ) ) or
       ( Trim( MemSrchPartNo.AsString ) = '_' ) ) and
     ( not IsEmptyStr( Trim( MemSrchPartDesc.Value ) ) ) then
  begin
    Grd.DrawUnderlinedCell(Column, Rect, Trim(MemSrchPartDesc.Value));
  end;
end;

procedure TFrmFndPart.QryPart_CostPriceGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= PartFormattedPrice(Sender, DisplayText, QryPartHasParam.AsBoolean);
end;

procedure TFrmFndPart.MemSrchNewRecord(DataSet: TDataSet);
begin
  MemSrchDescContains.AsBoolean:= False;
end;

procedure TFrmFndPart.DoGetPartInfo(AsPartNo, AsPartParam: string; var ArPartDef: TvalPartDef);
begin
  if Assigned(aiddbLkpPart .OnGetPartInfo) then
    aiddbLkpPart.OnGetPartInfo(Self, AsPartNo, AsPartParam, ArPartDef);
end;

procedure TFrmFndPart.GrdTitleHint(Sender: TObject; AField: TField; var AHint: String);
begin
  // see aidLang
  if (AField = QryPartHASPARAM) then AHint:= rsDC_PartIsParam else
    if (AField = QryPartHasDocs) then AHint:= rsDC_ItemHasDocs else
      if (AField = QryPartPartVersion) then AHint:= rsDC_PartVersion else
          if (AField = QryPartDRAWING) then AHint:= rsDC_PartDrawing else
              if (AField = QryPartISSUENO) then AHint:= rsDC_PartIssueNo;
end;

procedure TFrmFndPart.EdtSrchNoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if IsEmptyStr( EdtSrchNo.Text ) or ( Trim( EdtSrchNo.Text ) = '_' ) then
  begin
    ChkSrchContains.Caption := 'starts with';
    ChkSrchContains.Hint    := 'Search where each Keyword starts with the criteria';
  end
  else
  begin
    ChkSrchContains.Caption := 'contains';
    ChkSrchContains.Hint    := 'Search where description contains the criteria';
  end;
end;

initialization
  OnNewPartClick:= nil;
  OnCalcFields  := nil;

end.
