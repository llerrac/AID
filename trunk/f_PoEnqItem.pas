unit f_PoEnqItem;

{ f_PoEnqItem
    Find purchase enquiry items

  see data.sql, datapurch.sql
}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, crForms, crBtns, crTitle, crInfo, crdbInfo,
  DBCtrls, Mask, crdbEdit, crdbEd, crLabel, Db, kbmMemTable,
  Grids, DBGrids, crdbGrid, IBCustomDataSet,
  crIBQry, crdbUtil,
  IBDatabase, crdbLkp, crdbCtrl, Buttons,
  aidTypes, aiddbLkpPurch,aiddbLkpPart, IBQuery, crDlgLst;

type
  TFrmFndPurchEnqItem = class(TcrDlgForm)
    Tit: TcrTitle;
    Btns: TcrBtnPanel;
    GrpSearch: TGroupBox;
    BtnSrch: TButton;
    MemSrch: TkbmMemTable;
    SrcSrch: TDataSource;
    MemSrchItemNo: TStringField;
    MemSrchItemParam: TStringField;
    MemSrchItemDesc: TStringField;
    Grd: TcrdbGrid;
    QryPOEnq: TcrIBQuery;
    SrcPOEnq: TDataSource;
    QryPOEnqPackQTY: TIntegerField;
    QryPOEnqTRANSITE: TIBStringField;
    QryPOEnqTRANDIVISION: TIBStringField;
    QryPOEnqTRANSTATUS: TIBStringField;
    QryPOEnqSUPPREF: TIBStringField;
    QryPOEnqSUPPNO: TIBStringField;
    QryPOEnqSUPPNAME: TIBStringField;
    MemSrchTranSite: TStringField;
    Label29: TcrLabel;
    LkpSrchSite: TcrdbLookupComboBox;
    QrySite: TIBQuery;
    LkpSite: TkbmMemTable;
    LkpSiteSITE: TIBStringField;
    LkpSiteSITEDESC: TIBStringField;
    SrcLkpSite: TDataSource;
    QryPOEnqTRANSTATUSDESC: TIBStringField;
    LblJobNo: TcrLabel;
    EdtJobNo: TDBEdit;
    Spd: TSpeedButton;
    LblSearch: TcrLabel;
    MemSrchJobNo: TStringField;
    BtnViewPart: TButton;
    MemSrchLineMemo: TStringField;
    LblLineMemo: TcrLabel;
    EdtLineMemo: TDBEdit;
    LblNoteInfo: TcrLabel;
    QryPOEnqLINEMEMO: TMemoField;
    QryPOEnq_LineMemo: TStringField;
    MemSrchStatusNote: TStringField;
    QryPOEnqSUPPPARTNO: TIBStringField;
    crLabel1: TcrLabel;
    EdtSuppPartNo: TDBEdit;
    MemSrchSuppPartNo: TStringField;
    QrySiteSITE: TIBStringField;
    QrySiteSITEDESC: TIBStringField;
    QryPOEnqITEMNO: TIBStringField;
    QryPOEnqITEMPARAM: TIBStringField;
    QryPOEnqITEMQTY: TIntegerField;
    QryPOEnqPOENQNO: TIBStringField;
    QryPOEnqJOBNO: TIBStringField;
    QryPOEnqISSUEDDTE: TDateTimeField;
    QryPOEnqLINETYPE: TIBStringField;
    crLabel11: TcrLabel;
    EdtParam: TDBEdit;
    LblPartDesc: TcrLabel;
    InfPartDesc: TcrdBInfo;
    crLabel2: TcrLabel;
    Lst: TcrDlgList;
    procedure BtnSrchClick(Sender: TObject);
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType;
      var ModalResult: TModalResult);
    procedure GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure GrpSearchEnter(Sender: TObject);
    procedure GrpSearchExit(Sender: TObject);
    procedure crDlgFormShow(Sender: TObject);
    procedure GrdDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SpdClick(Sender: TObject);
    procedure BtnViewPartClick(Sender: TObject);
    procedure SrcPOEnqStateChange(Sender: TObject);
    procedure QryPOEnqCalcFields(DataSet: TDataSet);
    procedure QryPOEnqLINETYPEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure aiddbLookupPartLookedUpPartEvent(Sender: TObject;
      DataSource: TDataSource; PartDef: TvalPartDef);
  private
     { Private declarations }
    procedure PerformSearch;
    procedure LoadLookups;
    procedure SelectRow;
  public
     { Public declarations }
  end;

var
  FrmFndPurchEnqItem: TFrmFndPurchEnqItem;

function Execute(ADatabase: TIBDatabase; var APurchDef: TvalPurchDef; AsSite: String): Boolean;

implementation

{$R *.DFM}

uses
  aiddbUtil, crDbCommon;

var
  XrPurchDef  : TvalPurchDef;
  XuDatabase  : TIBDatabase;
  XsSite      : string;

function Execute(ADatabase: TIBDatabase; var APurchDef: TvalPurchDef; AsSite: String) : Boolean;
begin
  XrPurchDef  := APurchDef;
  XuDatabase  := ADatabase;
  XsSite      := AsSite;
  //
  Result      := RunDlgForm(TFrmFndPurchEnqItem, FrmFndPurchEnqItem)=mrOk;
  APurchDef   := XrPurchDef;
end;

procedure TFrmFndPurchEnqItem.BtnSrchClick(Sender: TObject);
begin
  if MemSrch.State in [dsEdit, dsInsert] then MemSrch.Post;
  //
  PerformSearch;
  //
  if not QryPoEnq.IsEmpty then
    Grd.SetFocus;
end;

procedure TFrmFndPurchEnqItem.crDlgFormCreate(Sender: TObject);
begin
  QryPoEnq.Close;
  QryPoEnq.Database:= XuDatabase;
  QryPoEnq.StoreSQL;
  QrySite .Close;
  QrySite .Database:= XuDatabase;
  //
  LoadLookups;
  //
  MemSrch.Active:= True;
  MemSrch.Append;
  MemSrchTranSite        .Value:= XsSite;
end;

procedure TFrmFndPurchEnqItem.PerformSearch;
begin
  QryPoEnq.ReStoreSQL;
  QryPoEnq.AddWhereClause(QryPoEnqItemNo    , MemSrchItemNo   .AsString, cropLike , 'Part # like %s' , crcoAND, False, 'pt.');
  QryPoEnq.AddWhereClause(QryPoEnqItemParam , MemSrchItemParam.AsString, cropLike , 'Param # like %s', crcoAND, False, 'pt.');
  QryPoEnq.AddWhereClause(QryPoEnqTranSite  , MemSrchTranSite .AsString, cropEqual, 'Site %s'        , crcoAND, False, 'pm.');
  QryPoEnq.AddWhereClause(QryPoEnqJobNo     , MemSrchJobNo    .AsString, cropLike , 'Job # like %s'  , crcoAND, False, 'pt.');
  QryPoEnq.AddWhereClause(QryPoEnqLineMemo  , MemSrchLineMemo .AsString  , cropContains, 'Line memo contains %s', crcoAND, False, 'pt.');
  QryPoEnq.AddWhereClause(QryPoEnqSuppPartNo, MemSrchSuppPartNo.AsString, cropLike    , 'Supp.Part # like %s' , crcoAND, False, 'pt.');
  QryPoEnq.AddOrderClause('ORDER BY pt.PoEnqNo Desc');
  QryPoEnq.Activate;
  //
  if not (QryPoEnq.Eof and QryPoEnq.Bof) then
    Grd .setFocus;
end;

procedure TFrmFndPurchEnqItem.LoadLookups;
begin
  // Site Lookups
  LkpSite.Close;
  LkpSite.Active:= True;
  LkpSite.AppendRecord(['', '<none>']);
  //
  QrySite.Close;
  QrySite.Open;
  while not QrySite.Eof do
  begin
    LkpSite.Append;
    LkpSiteSite    .Assign(QrySiteSite);
    LkpSiteSiteDesc.Assign(QrySiteSiteDesc);
    LkpSite.Post;
    //
    QrySite.Next;
  end;
  QrySite.Close;
end;

procedure TFrmFndPurchEnqItem.SelectRow;
begin
  XrPurchDef.TranNo   := QryPoEnqPoEnqNo  .Value;
  XrPurchDef.TranRef  := QryPoEnqJobNo    .Value;
  XrPurchDef.SuppNo   := QryPoEnqSuppNo   .Value;
  XrPurchDef.SuppName := QryPoEnqSuppName .Value;
  XrPurchDef.SuppRef  := QryPoEnqSuppRef  .Value;
  XrPurchDef.PartNo   := QryPoEnqItemNo   .Value;
  XrPurchDef.PartParam:= QryPoEnqItemParam.Value;
end;


procedure TFrmFndPurchEnqItem.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpSelect  :
      SelectRow;
  end;
end;

procedure TFrmFndPurchEnqItem.GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
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


procedure TFrmFndPurchEnqItem.GrpSearchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndPurchEnqItem.GrpSearchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndPurchEnqItem.crDlgFormShow(Sender: TObject);
begin
  //LkpItemNo.setFocus;
end;

procedure TFrmFndPurchEnqItem.GrdDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  // Overdue ?
  if (QryPoEnq.Active) and (Assigned(Column)) {and (QryPoEnqIsOutstanding.AsBoolean)} then
  begin
{    if (Column.Field=QryPoEnqExpected) then
    begin
      if (not QryPoEnqExpected.IsNull) and (QryPoEnqExpected.Value < Date) then
        if (QryPoEnqPackQty.Value>QryPoEnqQtyRcvd.Value) then
          Grd.DrawColorCell(Rect, Column, State, clYellow);
    end;

    if (Column.Field=QryPoEnqQtyRcvd) then
    begin
      if (QryPoEnqPackQty.Value>QryPoEnqQtyRcvd.Value) then
        Grd.DrawColorCell(Rect, Column, State, clYellow);
    end;}
    // Colour the lone type
{
    if (Column.Field=QryPoEnqLineType) then
      Grd.DrawColorCell(Rect, Column, State, BomTypes.BomItemTypeColorbyChar(StringToChar(QryPoEnqLineType.AsString)));
    // Highlight note contains
    if (Column.Field=QryPoEnq_LineMemo) then
      Grd.DrawUnderlinedCell(Column, Rect, Trim(MemSrchLineMemo.Value));
}  end;
end;

procedure TFrmFndPurchEnqItem.SpdClick(Sender: TObject);
begin
  Lst.Execute(QryPoEnq.SQL);
end;

procedure TFrmFndPurchEnqItem.BtnViewPartClick(Sender: TObject);
begin
 // v_Part.Execute(QryPoEnqItemNo.AsString);
end;

procedure TFrmFndPurchEnqItem.SrcPOEnqStateChange(Sender: TObject);
begin
  BtnViewPart.Enabled:= QryPoEnq.Active and (not QryPoEnq.IsEmpty);
end;

procedure TFrmFndPurchEnqItem.QryPoEnqCalcFields(DataSet: TDataSet);
begin
  QryPoEnq_LineMemo.AsString:= QryPoEnqLineMemo.AsString;
end;

procedure TFrmFndPurchEnqItem.QryPOEnqLINETYPEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= Sender.AsString;
  if DisplayText then
    Text:= AidTypes.PoEnqLineShortFromString(Text);
end;

procedure TFrmFndPurchEnqItem.aiddbLookupPartLookedUpPartEvent(
  Sender: TObject; DataSource: TDataSource; PartDef: TvalPartDef);
//var
//  PartDef : TvalPartDef;
begin
  //ModData. ResolveLookupPart(Sender, nil, MemSrchItemDesc, PartDef, LkpItemNo.Options);
  MemSrchItemParam.Value:= PartDef.PartParam;
  MemSrchItemDesc .Value:= PartDef.PartDesc;
end;

end.
