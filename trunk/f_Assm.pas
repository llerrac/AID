unit f_Assm;

{
  f_Assm
    see also bom2data.sql bom2proc.sql
}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Mask,
  crForms, crBtns, crTitle,
  Db, DBCtrls, DBGrids, kbmMemTable,
  Grids, crdbGrid, crLabel,
  aiddbLkpAssm,
  crdbUtil, IBCustomDataSet, IBDatabase, IBQuery, crIBQry, IBODataset;

type
  TFrmFndAssm = class(TcrDlgForm)
    Tit: TcrTitle;
    Btns: TcrBtnPanel;
    GrpSearch: TGroupBox;
    BtnSrch: TButton;
    LblSrchItemNo: TLabel;
    EdtSrchNo: TDBEdit;
    Qry: TcrIBQuery;
    Src: TDataSource;
    MemSrch: TkbmMemTable;
    MemSrchItemNo: TStringField;
    MemSrchItemDesc: TStringField;
    SrcSrch: TDataSource;
    GrdBrw: TcrdbGrid;
    LblSrchDesc: TcrLabel;
    EdtSrchDesc: TDBEdit;
    Tmr: TTimer;
    LblSearch: TcrLabel;
    QryINC_ASSM: TIntegerField;
    QryITEMNO: TIBStringField;
    QryITEMDESC: TIBStringField;
    QryVISIBILITY: TIBStringField;
    QryMODEL: TIBStringField;
    QryENGINEER: TIBStringField;
    QrySTATUS: TIBStringField;
    QryISSUENO: TIntegerField;
    QryITEMMEMO: TMemoField;
    QryCREATEDDTE: TDateTimeField;
    QryCREATEDBY: TIBStringField;
    QryALTEREDDTE: TDateTimeField;
    QryALTEREDBY: TIBStringField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure EdtSrchEnter(Sender: TObject);
    procedure EdtSrchExit(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure SrcStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
  private
     { Private declarations }
     procedure CheckSelectEnabled;
     procedure SelectRow;
  public
     { Public declarations }
  end;

var
  FrmFndAssm: TFrmFndAssm;

function Execute(ADatabase: TIBDatabase; var AAssmDef: TvalAssmDef): Boolean;

implementation

{$R *.DFM}

uses
  crUtil,crDbCommon;

var
  XrAssmDef : TvalAssmDef;
  XuDatabase: TIBDatabase;

function Execute(ADatabase: TIBDatabase; var AAssmDef: TvalAssmDef) : Boolean;
begin
  XrAssmDef  := AAssmDef;
  XuDatabase:= ADatabase;
  Result    := RunDlgForm(TFrmFndAssm, FrmFndAssm)=mrOk;
  AAssmDef   := XrAssmDef;
end;

procedure TFrmFndAssm.crDlgFormCreate(Sender: TObject);
begin
  MemSrch.Active:= True;
  MemSrch.Append;
  MemSrchItemNo.Value:= Trim(XrAssmDef.ItemNo);
  //
  Qry.Database:= XuDatabase;
  //
  if Length(Trim(XrAssmDef.ItemNo))>0 then
    Tmr.Enabled:= True;
  //
  Qry.StoreSQL;
end;

procedure TFrmFndAssm.BtnSrchClick(Sender: TObject);
begin
  if MemSrch.State in [dsEdit, dsInsert] then
    MemSrch.Post;
  //
  Qry.ReStoreSQL;
  Qry.AddWhereClause(QryItemNO  , MemSrchItemNo  .AsString, cropLike , 'Item #: %s'     , crcoAND, False, 'am.' );
  Qry.AddWhereClause('ItemDescUpper', MemSrchItemDesc.AsString, cropLike , 'Item Desc.: %s' , crcoAND, False, 'am.' );
  Qry.Activate;
  //
  if not (Qry.Eof and Qry.Bof) then
    TryToFocus(GrdBrw);
end;

procedure TFrmFndAssm.EdtSrchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndAssm.EdtSrchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndAssm.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if (Button=crbpSelect) then
    SelectRow;
end;


procedure TFrmFndAssm.CheckSelectEnabled;
begin
  Btns.SetEnabledState(crbpSelect, Qry.Active and (not (Qry.Eof and Qry.Bof)) );
end;


procedure TFrmFndAssm.SrcStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndAssm.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
end;

procedure TFrmFndAssm.GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaEdit,
    crbaView  : SelectRow;
  end;
end;

procedure TFrmFndAssm.SelectRow;
begin
  XrAssmDef.ItemNo  := QryItemNO  .Value;
  XrAssmDef.ItemDesc:= QryItemDesc.Value;
end;

end.
