unit f_Cont;

{ f_Cont
    Find Contract dialog box - used by aiddbLkpCont. }


interface

uses
  Windows, Forms, ExtCtrls, Grids, kbmMemTable, StdCtrls, Mask, Controls, Classes, Graphics,
  DB, IBCustomDataSet, IBQuery, IBDatabase, DBGrids, DBCtrls,
  crdbGrid, crIBQry, crdbUtil,
  crForms, crLabel, crBtns, crTitle,
  aidTypes, JvExDBGrids, JvDBGrid;

type
  TFrmFndContract = class(TcrDlgForm)
    Tit: TcrTitle;
    Btns: TcrBtnPanel;
    GrpSearch: TGroupBox;
    BtnSrch: TButton;
    LblSrchPartNo: TLabel;
    EdtSrchNo: TDBEdit;
    QryCont: TcrIBQuery;
    SrcCont: TDataSource;
    MemSrch: TkbmMemTable;
    MemSrchContNo: TStringField;
    MemSrchContDesc: TStringField;
    SrcSrch: TDataSource;
    grdCont: TcrdbGrid;
    LblSrchDesc: TcrLabel;
    EdtSrchDesc: TDBEdit;
    Tmr: TTimer;
    QryContCONTNO: TIBStringField;
    QryContCONTDESC: TIBStringField;
    QryContCOMPNO: TIBStringField;
    QryContKEY_STATUS: TIBStringField;
    QryContDTEISSUED: TDateTimeField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure EdtSrchEnter(Sender: TObject);
    procedure EdtSrchExit(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure SrcContStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure grdContAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure grdContDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QryContKEY_STATUSGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
     { Private declarations }
     procedure CheckSelectEnabled;
     procedure SelectRow;
  public
     { Public declarations }
  end;

var
  FrmFndContract: TFrmFndContract;

function Execute(ADatabase: TIBDatabase; var AContDef: TvalContDef): Boolean;

implementation

{$R *.DFM}

uses
  { Delphi Units }
  sysUtils,
  { Application Units }
  crUtil,crDbCommon, aidUtil;

var
  XrContDef : TvalContDef;
  XuDatabase: TIBDatabase;

function Execute(ADatabase: TIBDatabase; var AContDef: TvalContDef) : Boolean;
begin
  XrContDef  := AContDef;
  XuDatabase:= ADatabase;
  Result    := RunDlgForm(TFrmFndContract, FrmFndContract)=mrOk;
  AContDef   := XrContDef;
end;

procedure TFrmFndContract.crDlgFormCreate(Sender: TObject);
begin
  MemSrch.Active:= True;
  MemSrch.Append;
  MemSrchContNo.Value:= Trim(XrContDef.ContNo);
  //
  QryCont.Database:= XuDatabase;
  //
  if Length(Trim(XrContDef.ContNo))>0 then
    Tmr.Enabled:= True;
  //
  QryCont.StoreSQL;
end;

procedure TFrmFndContract.BtnSrchClick(Sender: TObject);
begin
  if MemSrch.State in [dsEdit, dsInsert] then
    MemSrch.Post;
  //
  QryCont.ReStoreSQL;
  QryCont.AddWhereClause(QryContCONTNO  , MemSrchCONTNO  .AsString, cropLike , 'Contract #: %s'     , crcoAND, False);
  QryCont.AddWhereClause(QryContCONTDESC, MemSrchCONTDESC.AsString, cropLike , 'Contract Desc.: %s' , crcoAND, False);
  QryCont.Activate;
  //
  if not (QryCont.Eof and QryCont.Bof) then
    TryToFocus(grdCont);
end;

procedure TFrmFndContract.EdtSrchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndContract.EdtSrchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndContract.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if (Button=crbpSelect) then
    SelectRow;
end;


procedure TFrmFndContract.CheckSelectEnabled;
begin
  Btns.SetEnabledState(crbpSelect, QryCont.Active and (not (QryCont.Eof and QryCont.Bof)) );
end;


procedure TFrmFndContract.SrcContStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndContract.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
end;

procedure TFrmFndContract.grdContAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
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

procedure TFrmFndContract.SelectRow;
begin
  XrContDef.ContNo  := Trim(QryContContNO.Value);
  XrContDef.ContDesc:=      QryContContDESC.Value;
end;

procedure TFrmFndContract.grdContDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (Column.Field = QryContKey_Status) then
    aidUtil.DrawContractStatus(grdCont.Canvas, Rect, QryContKey_Status.AsString);
end;

procedure TFrmFndContract.QryContKEY_STATUSGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if DisplayText then
    Text:= aidTypes.ContStateRecByKey(Text).Desc;
end;

end.
