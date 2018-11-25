unit f_Comp;

{ -------------------------------------------------------------------------------------------------
  Name        : f_Comp
  Author      : Chris G. Royle
  Description : Company Search Dialog
  Note        : the two lookups CompType, Country should be loaded externally / cached
  See Also    : data.sql, f_BOM, f_Cont, f_Part
                u_login, bomLang aidLang
  Modified    :
          ajc 15/01/2007 added isLMO
          2010/02/05 added extra info to company record in function TFrmFndComp.SelectRow: Boolean;
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Menus, ExtCtrls, StdCtrls,  Buttons, Grids, Mask, Controls, ComCtrls, Classes,
  DBCtrls, DBGrids, DB, forms,
  IBSQL, IBDatabase, IBCustomDataSet,
  { 3rd Party Units }
  kbmMemTable,
  { Application Units }
  crForms, crDlgLst, crIBQry, crdbCtrl, crInfo, crdbInfo, crBtns, crdbBtns,  crdbGrid,
  crLabel, crCtrls, crPage, crTitle, crdbLkp, crdbUtil, crTypes,
  aidTypes,crdbCommon, JvExDBGrids, JvDBGrid;

type
  TvalCompNewCompEvent =
    function (Sender: TObject; var ACompDef: TvalCompDef; ACompNo: string): Boolean of object;
type
  TFrmFndComp = class(TcrDlgForm)
    Tit: TcrTitle;
    QryComp: TcrIBDataset;
    SrcComp: TDataSource;
    MemSrch: TkbmMemTable;
    MemSrchCompNo: TStringField;
    MemSrchCompName: TStringField;
    SrcSrch: TDataSource;
    Tmr: TTimer;
    QryCompCOMPNO: TStringField;
    QryCompCOMPNAME: TStringField;
    QryCompISSUPPLIER: TStringField;
    QryCompISCUSTOMER: TStringField;
    QryCompCOMPDESC: TStringField;
    QryCompLOCCOUNTRY: TStringField;
    QryCompINC_COMP: TIntegerField;
    QryCompLOCPC: TStringField;
    MemSrchLocPC: TStringField;
    Pge: TcrPageControl;
    TabBrw: TTabSheet;
    TabView: TTabSheet;
    GrdBrw: TcrdbGrid;
    QryCompCOUNTRYNAME: TIBStringField;
    GrpCompany: TGroupBox;
    Label1: TcrLabel;
    Label3: TcrLabel;
    Label4: TcrLabel;
    Label5: TcrLabel;
    EdtCompNo: TcrdBInfo;
    EdtCompName: TDBEdit;
    LkpCompType: TcrdbLookupComboBox;
    EdtCompDesc: TDBEdit;
    ChkSupplier: TcrdbCheckBox;
    ChkCustomer: TcrdbCheckBox;
    Panel1: TPanel;
    GrpTel: TGroupBox;
    Label8: TcrLabel;
    Label9: TcrLabel;
    Label10: TcrLabel;
    Label11: TcrLabel;
    Label12: TcrLabel;
    Label13: TcrLabel;
    Label14: TcrLabel;
    EdtTelPre: TDBEdit;
    EdtTelNo: TDBEdit;
    EdtFaxPre: TDBEdit;
    EdtFaxNo: TDBEdit;
    EdtTelex: TDBEdit;
    EdtEmail: TDBEdit;
    EdtWww: TDBEdit;
    GrpGenNotes: TcrGroupBox;
    MemGeneral: TDBMemo;
    Panel2: TPanel;
    GrpLocAddress: TGroupBox;
    Label18: TcrLabel;
    Label17: TcrLabel;
    Label16: TcrLabel;
    Label19: TcrLabel;
    LkpLocCountry: TcrdbLookupComboBox;
    EdtLocPC: TDBEdit;
    MemLocAddress: TDBMemo;
    MemLocNote: TDBMemo;
    BtnMtn: TcrdbBtnMaintain;
    Btns: TcrBtnPanel;
    QryCompCOMPTYPE: TIBStringField;
    QryCompLOCADDRESS: TIBStringField;
    QryCompLOCNOTE: TMemoField;
    QryCompTELPRE: TIBStringField;
    QryCompTELNO: TIBStringField;
    QryCompFAXPRE: TIBStringField;
    QryCompFAXNO: TIBStringField;
    QryCompTELEX: TIBStringField;
    QryCompEMAIL: TIBStringField;
    QryCompWWW: TIBStringField;
    QryCompGENERALNOTE: TMemoField;
    BtnView: TButton;
    ibTran: TIBTransaction;
    MemSrchCompType: TStringField;
    MemCompType: TkbmMemTable;
    MemCompTypeKey_Lk: TStringField;
    MemCompTypeDesc_Lk: TStringField;
    QryCompType: TIBSQL;
    SrcCompType: TDataSource;
    GrpSearch: TcrGroupBox;
    LblSrchName: TcrLabel;
    LblSrchPartNo: TcrLabel;
    LblPC: TcrLabel;
    Label2: TcrLabel;
    EdtSrchName: TDBEdit;
    EdtSrchNo: TDBEdit;
    EdtSrchPC: TDBEdit;
    LkpSrchCompType: TcrdbLookupComboBox;
    QryCountry: TIBSQL;
    MemCountry: TkbmMemTable;
    MemCountryCountryNo: TStringField;
    MemCountryCountryName: TStringField;
    SrcCountry: TDataSource;
    Pop: TPopupMenu;
    MnuShowIsSupplier: TMenuItem;
    MnuShowIsCustomer: TMenuItem;
    MnuShowCompanyDescription: TMenuItem;
    MnuShowCountry: TMenuItem;
    MnuShowPostcode: TMenuItem;
    MnuShowTelephone: TMenuItem;
    MnuShowAddress: TMenuItem;
    QryComp_Tel: TStringField;
    QryComp_Adr: TStringField;
    ChkSrchContains: TDBCheckBox;
    MemSrchNameContains: TBooleanField;
    Lst: TcrDlgList;
    QryCompDRLATESTUPDATE: TDateTimeField;
    QryCompDRLATESTTRAN: TDateTimeField;
    QryCompDRBAL: TFloatField;
    QryCompDRBALCUR: TFloatField;
    QryCompDRBAL30: TFloatField;
    QryCompDRBAL60: TFloatField;
    QryCompDRBAL90: TFloatField;
    QryCompDRBAL120: TFloatField;
    QryCompDRBAL150: TFloatField;
    QryCompDRBALOVERDUE: TFloatField;
    QryCompVALIDSALESSITES: TIBStringField;
    QryCompVALIDSUPPLYSITES: TIBStringField;
    QryCompISTRANSPORTER: TIBStringField;
    LblSrchInvRefNo: TcrLabel;
    EdtSrchInvRefNo: TDBEdit;
    MemSrchInvRefNo: TStringField;
    QryCompINVREFNO: TIBStringField;
    MemSrchIsSupplier: TBooleanField;
    MemSrchIsCustomer: TBooleanField;
    MemSrchIsTransporter: TBooleanField;
    MemSrchIsMarketing: TBooleanField;
    MemSrchIsAgent: TBooleanField;
    ChkSrchIsSupplier: TDBCheckBox;
    ChkSrchIsCustomer: TDBCheckBox;
    ChkSrchIsTransporter: TDBCheckBox;
    ChkSrchIsMarketing: TDBCheckBox;
    ChkSrchIsAgent: TDBCheckBox;
    MemSrchLocCountry: TStringField;
    LkpSrchCountry: TcrdbLookupComboBox;
    LblSrchCountry: TcrLabel;
    chkTransporter: TcrdbCheckBox;
    chkMarketing: TcrdbCheckBox;
    chkAgent: TcrdbCheckBox;
    QryCompIsMarketing: TStringField;
    QryCompIsAgent: TStringField;
    ChkSrchIsValidSiteComp: TDBCheckBox;
    crLabel1: TcrLabel;
    edtComp4sNo: TDBEdit;
    MemSrchComp4SNo: TStringField;
    QryCompCOMP4SNO: TIBStringField;
    pnlBtns: TPanel;
    Bevel1: TBevel;
    LblSearch: TcrLabel;
    Spd: TSpeedButton;
    BtnSrch: TButton;
    BtnNew: TButton;
    lblComp4SNo: TcrLabel;
    edt4SNo: TDBEdit;
    MemSrchIsValidSiteComp: TBooleanField;
    DBCheckBoxisLMO: TDBCheckBox;
    QryCompISLMO: TIBStringField;
    crdbCheckBoxLmo: TcrdbCheckBox;
    MemSrchisLmo: TBooleanField;
    QryCompINVPC: TIBStringField;
    QryCompINVCOUNTRY: TIBStringField;
    QryCompINVNOTE: TMemoField;
    QryCompINVREFNO1: TIBStringField;
    QryCompEXP_SUPPNO: TIBStringField;
    QryCompEXP_PARTNO: TIBStringField;
    QryCompDISP_COUNTRYONPURCH: TIBStringField;
    QryCompISSUEPURCHASELABELS: TIBStringField;
    QryCompCURRENCYSUPPLY: TIBStringField;
    QryCompCURRENCYSALES: TIBStringField;
    QryCompDIVISIONSALES: TIBStringField;
    QryCompSALESPROMPT: TMemoField;
    QryCompDELMETHOD: TIBStringField;
    QryCompPAYTERMS: TIBStringField;
    QryCompCARRIERNO: TIBStringField;
    QryCompAGENTCOMPNO: TIBStringField;
    QryCompALLOWTRACKING: TIBStringField;
    QryCompTRACKINGHTTP: TIBStringField;
    QryCompVATNO: TIBStringField;
    QryCompLOCPLACEID: TIBStringField;
    QryCompLOCSUBREGION: TIBStringField;
    QryCompINVPLACEID: TIBStringField;
    QryCompINVSUBREGION: TIBStringField;
    QryCompCOMPTYPE1: TIBStringField;
    QryCompCOMPSITE: TIBStringField;
    QryCompCONTACT: TIBStringField;
    QryCompCOMPANY_MARKUP: TIBBCDField;
    QryCompSUPPLIER_PAYTERMS: TIBStringField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure SrcCompStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnMtnButtonClick(Sender: TObject; Button: TcrmtnBtn;
      var Handled: Boolean);
    procedure BtnViewClick(Sender: TObject);
    procedure crDlgFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure QryCompAfterPost(DataSet: TDataSet);
    procedure GrpSearchExit(Sender: TObject);
    procedure GrpSearchEnter(Sender: TObject);
    procedure PopClick(Sender: TObject);
    procedure QryCompCalcFields(DataSet: TDataSet);
    procedure QryCompBeforeEdit(DataSet: TDataSet);
    procedure QryCompAfterOpen(DataSet: TDataSet);
    procedure MemSrchNewRecord(DataSet: TDataSet);
    procedure SpdClick(Sender: TObject);
    procedure QryCompLOCCOUNTRYGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure GrdBrwDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QryCompFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
     { Private declarations }
    FUserInfo : TUserConfig;
    procedure CheckSelectEnabled;
    function  SelectRow: Boolean;
    procedure ViewRow;
    procedure LoadLookups;
    procedure LoadColumns;
    procedure SaveColumns;
    procedure ConfigureGrid;
    procedure LoadUserInfo;
    procedure SearchCompanies;

  public
     { Public declarations }
  end;

var
  FrmFndComp      : TFrmFndComp;
  //
  OnNewCompClick  : TvalCompNewCompEvent;
  OnLoadColumns   : TcrLoadColumnsEvent;
  OnSaveColumns   : TcrSaveColumnsEvent;
  OnGetUserInfo   : TbomGetUserInfoEvent;
  //
  ValidSaleSites,
  ValidSupplySites: String;

function Execute(ADatabase: TIBDatabase; var ACompDef: TvalCompDef): Boolean; Overload;
function Execute(ADatabase: TIBDatabase; var ACompDef: TvalCompDef; AIsSupplier, AIsTransporter, AIsCustomer,
                 AIsMarketing, AIsAgent : Boolean; ACountryNo : String ) : Boolean; Overload;
function Execute_NoScreen(ADatabase: TIBDatabase; atext : string;var ACompDef: TvalCompDef): Boolean; Overload;

implementation

{$R *.DFM}

uses
  { Delphi Units }
  SysUtils, Graphics,
  { Application Units }
  crUtil, aidLang;

var
  XrCompDef     : TvalCompDef;
  XuDatabase    : TIBDatabase;
  XIsSupplier,
  XIsTransporter,
  XIsCustomer,
  XIsMarketing,
  XIsLMO,
  XIsAgent      : Boolean;
  XCountryNo    : String;

function Execute(ADatabase: TIBDatabase; var ACompDef: TvalCompDef) : Boolean;
begin
  XrCompDef := ACompDef;
  XuDatabase:= ADatabase;
  XIsSupplier    := False;
  XIsTransporter := False;
  XIsCustomer    := False;
  XIsMarketing   := False;
  XIsAgent       := False;
  XIsLMO         := False;
  XCountryNo     := '';
  Result    := RunDlgForm(TFrmFndComp, FrmFndComp)=mrOk;
  ACompDef  := XrCompDef;
end;

function Execute(ADatabase: TIBDatabase; var ACompDef: TvalCompDef; AIsSupplier, AIsTransporter, AIsCustomer,
                 AIsMarketing, AIsAgent : Boolean; ACountryNo : String ) : Boolean;
begin
  XrCompDef := ACompDef;
  XuDatabase:= ADatabase;
  XIsSupplier    := AIsSupplier;
  XIsTransporter := AIsTransporter;
  XIsCustomer    := AIsCustomer;
  XIsMarketing   := AIsMarketing;
  XIsAgent       := AIsAgent;
  XCountryNo     := ACountryNo;
  Result    := RunDlgForm(TFrmFndComp, FrmFndComp)=mrOk;
  ACompDef  := XrCompDef;
end;

function Execute_NoScreen(ADatabase: TIBDatabase; atext : string;var ACompDef: TvalCompDef): Boolean; Overload;
begin
  XrCompDef := ACompDef;
  XuDatabase:= ADatabase;
  XIsSupplier    := False;
  XIsTransporter := False;
  XIsCustomer    := False;
  XIsMarketing   := False;
  XIsAgent       := False;
  XIsLMO         := False;
  XCountryNo     := '';

  try
    Application.CreateForm(TFrmFndComp, FrmFndComp);
    StandardiseDialogues(FrmFndComp);

    FrmFndComp.EdtSrchNo.EditText := atext;
    FrmFndComp.SearchCompanies;

    Application.ProcessMessages;
    result := FrmFndComp.SelectRow ;

  finally
     //TObject()
     FrmFndComp.free;
  end;

  ACompDef  := XrCompDef;
end;

function GetPopupChecked(APop: TPopupMenu): LongWord;
var
  iK  : Integer;
begin
  Result:= 0;
  for iK:= 0 to APop.Items.Count-1 do
    Result:= SetBitIf(APop.Items[iK].Checked, Result, iK+1);
end;

procedure SetPopupChecked(APop: TPopupMenu; AChecks: LongWord);
var
  iK  : Integer;
begin
  for iK:= 0 to APop.Items.Count-1 do
    APop.Items[iK].Checked:= IsBitSet(AChecks, iK+1);
end;


procedure TFrmFndComp.crDlgFormCreate(Sender: TObject);
var
  sSrch : string;

  procedure LoadCompTypes;
  begin
    MemCompType.Active:= False;
    MemCompType.Active:= True;
    MemCompType.AppendRecord(['', '<none>']);
    QryCompType.Close;
    QryCompType.ExecQuery;
    while not QryCompType.Eof do
    begin
      MemCompType.AppendRecord([QryCompType.Fields[0].AsString, QryCompType.Fields[1].AsString]);
      QryCompType.Next;
    end;
    QryCompType.Close;
  end;
begin
  ibTran.Active:= False;
  ibTran.DefaultDatabase:= XuDatabase;
  ibTran.StartTransaction;
  //
  QryCompType.Database:= XuDatabase;
  QryCountry .Database:= XuDatabase;
  //
  LoadCompTypes;
  LoadUserInfo;
  //
  sSrch:= Trim(XrCompDef.CompNo);
  //
  MemSrch.Active:= True;
  MemSrch.Append;

  if Length(OnlyChars(sSrch))>3 then
    MemSrchCompName.Value:= sSrch
  else
    MemSrchCompNo  .Value:= sSrch;
  //
  QryComp.Database:= XuDatabase;
  //
  if Length(Trim(XrCompDef.CompNo))>0 then
    Tmr.Enabled:= True;
  //
  QryComp.StoreSQL;
  Pge.PreparePage;
  //
  LoadColumns;
  ConfigureGrid;
  BtnNew.Enabled:= FUserInfo.Permissions[valCompany, upEdit];
  //
  ActiveControl:= EdtSrchName;
  LoadLookups;
end;

procedure TFrmFndComp.LoadLookups;
begin
  if not MemCountry.Active then
  begin
    SrcCountry.DataSet:= nil;
    MemCountry.Active:= False;
    MemCountry.Active:= True;
    MemCountry.AppendRecord(['', '<unknown>']);
    QryCountry.Close;
    QryCountry.ExecQuery;
    while not QryCountry.Eof do
    begin
      MemCountry.Append;
      MemCountryCountryNo  .AsString:= Trim(QryCountry.Fields[0].AsString);
      MemCountryCountryName.AsString:= Trim(QryCountry.Fields[1].AsString);
      MemCountry.Post;
      //
      QryCountry.Next;
    end;
    QryCountry.Close;
    //
//    QryComp.Refresh;
    SrcCountry.DataSet:= MemCountry;
  end;
end;

procedure TFrmFndComp.SearchCompanies;
var
  sTmp  : string;
  iOp   : TcribOperator;
begin
  if MemSrch.State in [dsEdit, dsInsert] then
    MemSrch.Post;
  //
  QryComp.ReStoreSQL;
  QryComp.AddWhereClause(QryCompCompNO  , MemSrchCompNO  .AsString, cropLike , 'Company #: %s'    , crcoAND, False, 'co.' );
  sTmp:= OnlyAlpha(MemSrchCOMPNAME.AsString);
  if MemSrchNameContains.Value then iOp:= cropContains else iOp:= cropLike;
  QryComp.AddWhereClause('CompNameUpper', sTmp, iOp, 'Company Name: %s', crcoAND, False, 'co.');
  //
  QryComp.AddWhereClause(QryCompLocPC   , MemSrchLocPC   .AsString, cropLike , 'Postcode: %s'       , crcoAND, False, 'co.' );
  QryComp.AddWhereClause(QryCompLOCCOUNTRY, MemSrchLOCCOUNTRY.AsString, cropEqual   , 'Country: %s'     , crcoAND, False, 'co.');
  QryComp.AddWhereClause(QryCompCompType, MemSrchCompType.AsString, cropEqual, 'Company Type: %s'   , crcoAND, False, 'co.' );
  QryComp.AddWhereClause(QryCompInvRefNo, MemSrchInvRefNo.AsString, cropLike , 'Alternate a/c #: %s', crcoAND, False, 'co.' );
  QryComp.AddWhereClause(QryCompComp4SNo, MemSrchComp4SNo.AsString, cropLike , '4S #: %s', crcoAND, False, 'co.' );
  //
  if MemSrchIsSupplier   .AsBoolean then
    QryComp.AddWhereClause(QryCompIsSupplier   , 'Y', cropEqual, 'Supplier',    crcoAND, False, 'co.');
  if MemSrchIsCustomer   .AsBoolean then
    QryComp.AddWhereClause(QryCompIsCustomer   , 'Y', cropEqual, 'Customer',    crcoAND, False, 'co.');
  if MemSrchIsTransporter.AsBoolean then
    QryComp.AddWhereClause(QryCompIsTransporter, 'Y', cropEqual, 'Transporter', crcoAND, False, 'co.');
  if MemSrchIsMarketing.AsBoolean then
    QryComp.AddWhereClause(QryCompIsMarketing  , 'Y', cropEqual, 'Marketing'  , crcoAND, False, 'co.');
  if MemSrchIsAgent.AsBoolean then
    QryComp.AddWhereClause(QryCompIsAgent      , 'Y', cropEqual, 'Agent'      , crcoAND, False, 'co.');
  if MemSrchIsLmo.AsBoolean then
    QryComp.AddWhereClause(QryCompIsLMO      , 'Y', cropEqual, 'LMO'      , crcoAND, False, 'co.');


  QryComp.Filtered:= MemSrchIsValidSiteComp.AsBoolean{ChkSrchIsValidSiteComp.Checked};
  QryComp.Activate;
end;

procedure TFrmFndComp.BtnSrchClick(Sender: TObject);
begin
  SearchCompanies;

  //
  if not (QryComp.IsEmpty) then
    TryToFocus(GrdBrw);
end;                                              

procedure TFrmFndComp.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpSelect  : SelectRow;
    crbpCancel  :
      if Pge.ActivePageIndex>0 then
      begin
        Pge.ActivePageIndex:= 0;
        ModalResult:= mrNone;
      end;
  end;
end;


procedure TFrmFndComp.CheckSelectEnabled;
begin
  Btns.SetEnabledState(crbpSelect, QryComp.Active and (not (QryComp.Eof and QryComp.Bof)) );
end;


procedure TFrmFndComp.SrcCompStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndComp.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
end;

procedure TFrmFndComp.GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
//    crbaInsert,
    crbaEdit  :
    begin
      if SelectRow then
        ModalResult:= mrOk;
    end;
    crbaView  : ViewRow;
  end;
end;

function TFrmFndComp.SelectRow: Boolean;
begin
  Result:= True;
  XrCompDef.CompNo  := Trim(QryCompCompNO.Value);
  XrCompDef.CompName:= QryCompCompName   .Value;

  XrCompDef.Inc_Comp   := QryCompINC_COMP.AsInteger;
  XrCompDef.LocCountry := QryCompLocCountry.AsString;
  XrCompDef.LocPC      := QryCompLocPC.asString;
  XrCompDef.LocAddress := QryCompLocAddress.asString;
  XrCompDef.TelPre     := QryCompTelPre.asString;
  XrCompDef.TelNo      := QryCompTelNo.asString;
  XrCompDef.FaxPre     := QryCompFaxPre.asString;
  XrCompDef.FaxNo      := QryCompFaxNo.asString;

  XrCompDef.Email      := QryCompEMAIL.asString;
  XrCompDef.AcCode      := QryCompFaxNo.asString;
  XrCompDef.LocLineAdr  := QryCompLOCSUBREGION.asString;
  XrCompDef.ValidSupplySites := QryCompVALIDSUPPLYSITES.asString;
  XrCompDef.ValidSalesSites  := QryCompVALIDSALESSITES.asString;
  XrCompDef.CurrencySupply   := QryCompCURRENCYSUPPLY.asString;
  XrCompDef.SalesPrompt      := QryCompSALESPROMPT.asString;
  XrCompDef.PayTerms         := QryCompPAYTERMS.asString;

  //lots more can be filled in.
end;

procedure TFrmFndComp.ViewRow;
begin
  Pge.ChangeToPage(TabView);
end;

procedure TFrmFndComp.BtnNewClick(Sender: TObject);
var
  rNewComp  : TvalCompDef;
begin
  if Assigned(OnNewCompClick) then
    if OnNewCompClick(Self, rNewComp, MemSrchCompNo.AsString) then
    begin
      XrCompDef  := rNewComp;
      ModalResult:= mrOk;
    end;
end;

procedure TFrmFndComp.BtnMtnButtonClick(Sender: TObject; Button: TcrmtnBtn; var Handled: Boolean);
begin
  if Button = crmtnClose then
  begin
    Pge.ChangeToPage(TabBrw);
    GrdBrw.SetFocus;
    Handled:= True;
  end;
end;

procedure TFrmFndComp.BtnViewClick(Sender: TObject);
begin
  ViewRow;
end;

procedure TFrmFndComp.crDlgFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ibTran.InTransaction then ibTran.Commit;
  //
  SaveColumns;
end;

procedure TFrmFndComp.QryCompAfterPost(DataSet: TDataSet);
begin
  if ibTran.InTransaction then ibTran.CommitRetaining;
end;

procedure TFrmFndComp.GrpSearchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndComp.GrpSearchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndComp.LoadColumns;
var
  wColumns  : Integer;
begin
  wColumns:= 31; // Default
  if Assigned(OnLoadColumns) then
  begin
    OnLoadColumns(Self, Name, GrdBrw.Name, wColumns);
    SetPopupChecked(Pop, wColumns);
  end;
end;

procedure TFrmFndComp.SaveColumns;
begin
  if Assigned(OnSaveColumns) then
  begin
    OnSaveColumns(Self, Name, GrdBrw.Name, GetPopupChecked(Pop));
  end;
end;

procedure TFrmFndComp.PopClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    with TMenuItem(Sender) do
      if Tag in [1..10] then
      begin
        Checked:= not Checked;
        ConfigureGrid;
      end
      else
        notyet;
end;


procedure TFrmFndComp.ConfigureGrid;
begin
  QryCompIsSupplier  .Visible:= MnuShowIsSupplier.Checked;
  QryCompIsCustomer  .Visible:= MnuShowIsCustomer.Checked;
  QryCompCompDesc    .Visible:= MnuShowCompanyDescription.Checked;
  QryCompCountryName .Visible:= MnuShowCountry   .Checked;
  QryCompLocPC       .Visible:= MnuShowPostcode  .Checked;
  QryComp_Tel        .Visible:= MnuShowTelephone .Checked;
  QryComp_Adr        .Visible:= MnuShowAddress   .Checked;
end;

procedure TFrmFndComp.QryCompCalcFields(DataSet: TDataSet);
begin
  QryComp_Tel.Value:= Trim(Trim(QryCompTelPre.Value)+' '+Trim(QryCompTelNo.Value));
  QryComp_Adr.Value:= StrRepl(QryCompLocAddress.Text, #13#10, ', ');
end;

procedure TFrmFndComp.QryCompBeforeEdit(DataSet: TDataSet);
begin
  if not FUserInfo.Permissions[valCompany, upLimited] then
    crdbUtil.CheckDBError(not FUserInfo.Permissions[valCompany, upEdit], aidLang .rsAccountsDeptOnly, 0);
end;

procedure TFrmFndComp.LoadUserInfo;
begin
  FillChar(FUserInfo, SizeOf(FUserInfo), #0);
  if Assigned(OnGetUserInfo) then
    OnGetUserInfo(Self, FUserInfo);
end;

procedure TFrmFndComp.QryCompAfterOpen(DataSet: TDataSet);
var
  iK    : Integer;
  bLimited,
  bAll  : Boolean;
  uField: TField;
begin
  bAll    := FUserInfo.Permissions[valCompany, upEdit];
  bLimited:= bAll or FUserInfo.Permissions[valCompany, upLimited];
  //
  for iK:= 0 to QryComp.FieldCount-1 do
  begin
    uField:= QryComp.Fields[iK];
    uField.ReadOnly:= (not bAll);
  end;
  //
  qryCompComp4SNo   .ReadOnly:= not bLimited;
  QryCompCompType   .ReadOnly:= not bLimited;
  QryCompCompDesc   .ReadOnly:= not bLimited;
  QryCompTelPre     .ReadOnly:= not bLimited;
  QryCompTelNo      .ReadOnly:= not bLimited;
  QryCompFaxPre     .ReadOnly:= not bLimited;
  QryCompFaxNo      .ReadOnly:= not bLimited;
  QryCompTelex      .ReadOnly:= not bLimited;
  QryCompWWW        .ReadOnly:= not bLimited;
  QryCompEmail      .ReadOnly:= not bLimited;
  QryCompLocNote    .ReadOnly:= not bLimited;
  QryCompGeneralNote.ReadOnly:= not bLimited;
end;

procedure TFrmFndComp.MemSrchNewRecord(DataSet: TDataSet);
begin
  MemSrchNameContains   .Value:= False;
  MemSrchIsSupplier     .Value:= XIsSupplier;
  MemSrchIsCustomer     .Value:= XIsCustomer;
  MemSrchIsTransporter  .Value:= XIsTransporter;
  MemSrchIsMarketing    .Value:= XIsMarketing;
  MemSrchIsAgent        .Value:= XIsAgent;
  MemSrchLocCountry     .Value:= XCountryNo;
  MemSrchisLmo          .Value:= XIsLmo;
  MemSrchIsValidSiteComp.Value:= True;
end;

procedure TFrmFndComp.SpdClick(Sender: TObject);
begin
  Lst.Execute(QryComp.SelectSQL);
end;

procedure TFrmFndComp.QryCompLOCCOUNTRYGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= Trim(Sender.ASString);
end;

procedure TFrmFndComp.GrdBrwDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  lDrawn  : Boolean;
  lOk     : Boolean;
begin
  lDrawn:= False;
  lOk   := (Pos(FUserInfo.Site, QryCompValidSupplySites.AsString)>0) or
           (Pos(FUserInfo.Site, QryCompValidSalesSites .AsString)>0);
  //
  if Assigned(Column) and (Assigned(Column.Field)) then
  begin
    if (not lOk) and (not (gdSelected in State)) then
      GrdBrw.Canvas.Font.Color:= clGrayText;//u_WrkStn.WorkStation.ColorUnemphasized;
    if (not GrdBrw.Focused) and (gdSelected in State) then
    begin
      GrdBrw.Canvas.Brush.Color:= clInactiveCaption;
      GrdBrw.Canvas.Font .Color:= clInactiveCaptionText;
    end;
    // Draw contains underlined fields
    if (Column.Field = QryCompCompName) and (MemSrchNameContains.Value) then
      GrdBrw.DrawUnderlinedCell(Column, Rect, MemSrchCompName.Value);
    // Draw Booleans
    if ((Column.Field=QryCompIsSupplier) or (Column.Field=QryCompIsCustomer) or (Column.Field=QryCompIsTransporter)) then
    begin
      GrdBrw.DrawBooleanColumn(Rect, Column, State);
      lDrawn:= True;
    end;
  end;
  // Default Drawing
  if not lDrawn then
    GrdBrw.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;



procedure TFrmFndComp.QryCompFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:= True;
  if (MemSrchIsValidSiteComp.AsBoolean{ChkSrchIsValidSiteComp.Checked}) then
    Accept:= (Pos(FUserInfo.Site, QryCompValidSupplySites.AsString)>0) or (Pos(FUserInfo.Site, QryCompValidSalesSites .AsString)>0);
end;

initialization
  OnNewCompClick  := nil;
  OnLoadColumns   := nil;
  OnSaveColumns   := nil;
  OnGetUserInfo   := nil;



end.
