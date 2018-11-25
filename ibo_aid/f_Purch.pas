unit f_Purch;

{ f_Purch

  see
    DataPurch.sql ProcPurch.sql}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Mask,
  crForms, crBtns, crTitle,
  Db, DBCtrls, DBGrids, kbmMemTable,
  Grids,IB_Components,IBODataset,

  crdbGrid, crLabel,
  aiddbLkpPurch,
  crdbUtil, crIBQry, crInfo,
  crdbInfo, crdbEdit, crdbEd, aiddbLkpComp, crdbLkp, crdbCal, Buttons,
  crdbCtrl, crDlgLst,
  aidTypes;

type
  TFrmFndPurchase = class(TcrDlgForm)
    Tit: TcrTitle;
    Btns: TcrBtnPanel;
    GrpSearch: TGroupBox;
    QryTr: TcrIBQuery;
    SrcTr: TDataSource;
    SrcSrch: TDataSource;
    GrdBrw: TcrdbGrid;
    Tmr: TTimer;
    QryTrSUPPNO: TStringField;
    QryTrSUPPNAME: TStringField;
    QryTrTRANSITE: TStringField;
    QryTrTRANNO: TStringField;
    QryTrTRANREF: TStringField;
    QryTrSUPPREF: TStringField;
    QryTrTRANDTE: TDateTimeField;
    QryTrTRANUSER: TStringField;
    QryTrTRANSTATUS: TStringField;
    QryTrDELIVERYSITE: TStringField;
    QryTrDELIVERYWARE: TStringField;
    QryTrEXPECTED: TDateTimeField;
    QryTrTRANUSERDESC: TStringField;
    QryTrTRANSTATUSDESC: TStringField;
    SepSrchOrdered: TcrSeparator;
    DteSrchFrom: TcrdbDateEdit;
    DteSrchUntil: TcrdbDateEdit;
    crLabel12: TcrLabel;
    InfSrchSupp: TcrdBInfo;
    LblSrchPartNo: TcrLabel;
    EdtSrchNo: TDBEdit;
    Label1: TcrLabel;
    EdtTranRef: TDBEdit;
    Label2: TcrLabel;
    EdtSuppRef: TDBEdit;
    crLabel10: TcrLabel;
    LkpSrchIssuedBy: TcrdbLookupComboBox;
    crLabel13: TcrLabel;
    LkpSrchStatus: TcrdbLookupComboBox;
    Spd: TSpeedButton;
    BtnSrch: TButton;
    BtnClear: TButton;
    SepOrderBy: TcrSeparator;
    LkpSrchOrderBy: TcrdbLookupComboBox;
    MemSrch: TkbmMemTable;
    MemSrchFrom: TDateField;
    MemSrchUntil: TDateField;
    MemSrchExpectFrom: TDateTimeField;
    MemSrchExpectUntil: TDateTimeField;
    MemSrchTranSite: TStringField;
    MemSrchDeliverySite: TStringField;
    MemSrchTranUser: TStringField;
    MemSrchTranStatus: TStringField;
    MemSrchSuppNo: TStringField;
    MemSrchSuppName: TStringField;
    MemSrchTranNo: TStringField;
    MemSrchSuppRef: TStringField;
    MemSrchTranRef: TStringField;
    MemSrchOrderBy: TIntegerField;
    SrcLkpUser: TDataSource;
    SrcLkpPurchStatus: TDataSource;
    ChkIncludeCompleted: TcrdbCheckBox;
    MemSrchIncludeCompleted: TBooleanField;
    QryTrISCOMPLETED: TStringField;
    Dlg: TcrDlgList;
    InfLkpSuppNo: TcrInfo;
    MemSrchOrder: TkbmMemTable;
    MemSrchOrderOrderIndex: TIntegerField;
    MemSrchOrderOrderDesc: TStringField;
    SrcSrchOrder: TDataSource;
    MemSrchOrderOrderClause: TStringField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure SrcTrStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure GrpSearchEnter(Sender: TObject);
    procedure GrpSearchExit(Sender: TObject);
    procedure SpdClick(Sender: TObject);
    procedure MemSrchNewRecord(DataSet: TDataSet);
    procedure MemSrchSuppNoChange(Sender: TField);
    procedure MemSrchFromChange(Sender: TField);
    procedure MemSrchUntilChange(Sender: TField);
  private
     { Private declarations }
    LkpSrchSupp: TvaldbLookupCompany;
    procedure CheckSelectEnabled;
    procedure SelectRow;
    procedure SetDate( vdDate : TDateTime; vbStart : Boolean );
  public
     { Public declarations }
  end;

var
  FrmFndPurchase: TFrmFndPurchase;

function Execute(ADatabase: TIB_Connection; var APurchDef: TvalPurchDef; ALkpUser, ALkpStatus: TDataSet): Boolean;

implementation

{$R *.DFM}

uses
  crUtil, aiddbUtil,crDbCommon;

var
  XrPurchDef  : TvalPurchDef;
  XuDatabase  : TIB_Connection;
  XuLkpUser,
  XuLkpStatus : TDataSet;

function Execute(ADatabase: TIB_Connection; var APurchDef: TvalPurchDef; ALkpUser, ALkpStatus: TDataSet) : Boolean;
begin
  XrPurchDef  := APurchDef;
  XuDatabase  := ADatabase;
  XuLkpUser   := ALkpUser;
  XuLkpStatus := ALkpStatus;
  //
  Result      := RunDlgForm(TFrmFndPurchase, FrmFndPurchase)=mrOk;
  APurchDef   := XrPurchDef;
end;

procedure TFrmFndPurchase.crDlgFormCreate(Sender: TObject);
begin
  // Manually creat LkpSuppNo, as this is part of the same library, and should
  // not be done manually
  LkpSrchSupp:= TvaldbLookupCompany.Create(Self);
  LkpSrchSupp.Parent:= GrpSearch;
  LkpSrchSupp.SetBounds(190, 10, 88, 19);
  LkpSrchSupp.AutoSelect  := False;
  LkpSrchSupp.CharCase    := ecUpperCase;
  LkpSrchSupp.Ctl3D       := False;
  LkpSrchSupp.DataField   := MemSrchSuppNo.FieldName;
  LkpSrchSupp.DataSource  := SrcSrch;
  LkpSrchSupp.ParentCtl3D := False;
  LkpSrchSupp.TabOrder    := 2;
  // PO Display Order CGR20020809
  MemSrchOrder.Close;
  MemSrchOrder.Active:= True;
  MemSrchOrder.AppendRecord([1, 'Order No (Desc)'           , 'ORDER BY pm.TranNo Descending']);
  MemSrchOrder.AppendRecord([2, 'Required By (Desc)'        , 'ORDER BY pm.Expected Descending, pm.TranNo Descending']);
  MemSrchOrder.AppendRecord([3, 'Status (Desc)'             , 'ORDER BY pm.TranStatus Descending, pm.TranNo Descending']);
  MemSrchOrder.AppendRecord([4, 'Supplier(+), Order No.(-)' , 'ORDER BY pm.SuppNo Descending, pm.TranNo Descending']);
  MemSrchOrder.First;
  // CGR20020423, Changed database assignment order, as events raised by MemSrch.Datachange look at the database property
  QryTr      .IB_Connection:= XuDatabase;
  LkpSrchSupp.Database:= XuDatabase;
  SrcLkpUser .DataSet := XuLkpUser;
  SrcLkpPurchStatus.DataSet := XuLkpStatus;
  //
  MemSrch.Active:= True;
  MemSrch.Append;
  // BOMs purchase order ?
  if (Length(Trim(XrPurchDef.TranNo))>=2) and (LeftStr(XrPurchDef.TranNo,2)='P-') then
    MemSrchTranNo.Value:= Trim(XrPurchDef.TranNo)
  else // Titan Tetra order ?
    if (Length(Trim(XrPurchDef.TranNo))>=2) and (LeftStr(XrPurchDef.TranNo,2)='TP') then
      MemSrchSuppRef.Value:= Trim(XrPurchDef.TranNo)
    else
      MemSrchSuppNo .Value:= Trim(XrPurchDef.TranNo);
  //
  if not IsEmptyStr(XrPurchDef.TranNo) then
    MemSrchIncludeCompleted.AsBoolean:= True;
  //
  if (not IsEmptyStr(MemSrchTranNo.Value)) or (not IsEmptyStr(MemSrchSuppRef.Value)) then
    Tmr.Enabled:= True;
  //
  QryTr.StoreSQL;
end;

procedure TFrmFndPurchase.BtnSrchClick(Sender: TObject);
begin
  if MemSrch.State in [dsEdit, dsInsert] then
    MemSrch.Post;
  //
  QryTr.ReStoreSQL;
  QryTr.AddWhereClause(QryTrTranNo      , MemSrchTranNo       .AsString, cropLike          , 'Purch #: %s'                 , crcoAND, False, 'pm.');
  QryTr.AddWhereClause(QryTrTRANDTE     , MemSrchFrom                  , MemSrchUntil      , 'Transaction between %s - %%s', crcoAnd, 'pm.');
  QryTr.AddWhereClause(QryTrEXPECTED    , MemSrchExpectFrom            , MemSrchExpectUntil, 'Expected between %s - %%s'   , crcoAnd, 'pm.');
  QryTr.AddWhereClause(QryTrTRANSITE    , MemSrchTranSite     .AsString, cropEqual         , 'Transaction Site %s'         , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrDELIVERYSITE, MemSrchDeliverySite .AsString, cropEqual         , 'Delivery Site %s'            , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrTRANUser    , MemSrchTranUser     .AsString, cropEqual         , 'Issued by %s'                , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrTRANSTATUS  , MemSrchTranStatus   .AsString, cropEqual         , 'Status %s'                   , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrSUPPNo      , MemSrchSuppNo       .AsString, cropEqual         , 'Supplier #: %s'              , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrTRANREF     , MemSrchTranRef      .AsString, cropLike          , 'Contract/CC like %s'         , crcoAnd, False, 'pm.');
  QryTr.AddWhereClause(QryTrSUPPREF     , MemSrchSuppRef      .AsString, cropLike          , 'Supplier Ref. like %s'       , crcoAnd, False, 'pm.');
  if not MemSrchIncludeCompleted.AsBoolean then
  begin
    QryTr.AddWhereTFClause('L1.Log2', 'T', cropUnequal, 'Excluding Completed');
  end;
  //
  QryTr.AddOrderClause(MemSrchOrderOrderClause.AsString);
  QryTr.Activate;
  //
  if not (QryTr.IsEmpty) then
    TryToFocus(GrdBrw);
end;

procedure TFrmFndPurchase.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if (Button=crbpSelect) then
    SelectRow;
end;


procedure TFrmFndPurchase.CheckSelectEnabled;
begin
  Btns.SetEnabledState(crbpSelect, QryTr.Active and (not (QryTr.Eof and QryTr.Bof)) );
end;


procedure TFrmFndPurchase.SrcTrStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndPurchase.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
end;

procedure TFrmFndPurchase.GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaEdit,
    crbaView  :
    begin
      SelectRow;
      ModalResult:= mrOk;
    end;
  end;
end;

procedure TFrmFndPurchase.SelectRow;
begin
  XrPurchDef.TranNo   := QryTrTranNo  .Value;
  XrPurchDef.TranRef  := QryTrTranRef .Value;
  XrPurchDef.SuppNo   := QryTrSuppNo  .Value;
  XrPurchDef.SuppName := QryTrSuppName.Value;
  XrPurchDef.SuppRef  := QryTrSuppRef .Value;
//  XrPurchDef.PartNo   := '';
//  XrPurchDef.PartParam:= '';
end;

procedure TFrmFndPurchase.GrpSearchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndPurchase.GrpSearchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndPurchase.SpdClick(Sender: TObject);
begin
  Dlg.Execute(QryTr.SQL);
end;

procedure TFrmFndPurchase.MemSrchNewRecord(DataSet: TDataSet);
begin
  MemSrchIncludeCompleted.Value:= False;
  MemSrchOrderBy         .AsInteger:= MemSrchOrderOrderIndex.AsInteger;  
  MemSrchFrom            .Value := AddMonths( now + 1,  -6 );
  MemSrchUntil           .Value := now + 1;
end;

procedure TFrmFndPurchase.MemSrchSuppNoChange(Sender: TField);
var
  rCompDef: TvalCompDef;
begin
  aiddbUtil . GetCompanyInfo(QryTr.IB_Connection, Sender.AsString, rCompDef);
  MemSrchSuppName.AsString:= rCompDef.CompName;
end;

procedure TFrmFndPurchase.SetDate( vdDate : TDateTime; vbStart : Boolean );
var
  ldTempDate : TDateTime;
begin
  MemSrchFrom.OnChange  := nil;
  MemSrchUntil.OnChange := nil;

  if IsEmptyStr( MemSrchTranRef.AsString ) then
  begin
    if vbStart then
    begin
      ldTempDate := AddMonths( Trunc( MemSrchFrom.AsDateTime) , 6 );
      if MemSrchUntil.AsDateTime > ldTempDate then
      begin
        MemSrchUntil.AsDateTime := ldTempDate;
      end;
    end
    else
    begin
      ldTempDate := AddMonths( Trunc( MemSrchUntil.AsDateTime ), -6 );
      if MemSrchFrom.AsDateTime < ldTempDate then
      begin
        MemSrchFrom.AsDateTime := ldTempDate;
      end;
    end;
  end;

  MemSrchFrom.OnChange   := MemSrchFromChange;
  MemSrchUntil.OnChange := MemSrchUntilChange;
end;


procedure TFrmFndPurchase.MemSrchFromChange(Sender: TField);
begin
  SetDate( MemSrchFrom.AsDateTime, True );
end;

procedure TFrmFndPurchase.MemSrchUntilChange(Sender: TField);
begin
  SetDate( MemSrchUntil.AsDateTime, False );
end;

end.
