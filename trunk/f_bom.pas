unit f_BOM;

{ --------------------------------------------------------------------------------------------
  name        : f_BOM
  author      : Chris G. Royle, 2001
  description : Master BOM Search dialog.
  see also    : data.sql dataBOM.sql
  modified    :
    CGR 20060111, Added the display of Version Control Information.
                  Removed the searching of Assy - this is redundant due to Assy being moved to a
                    seperate table.
                  Fixed a bug where the contains clause was searching on the wrong field. 
  --------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, ExtCtrls, Grids, StdCtrls, Mask, Controls, Classes, Graphics,
  DB, DBGrids, DBCtrls,
  IBDatabase, IBCustomDataSet, IBQuery, crIBQry,
  { 3rd Party Units }
  kbmMemTable,
  { Application Units }
  crForms, crdbGrid, crLabel, crdbUtil, crBtns, crTitle,
  aiddbLkpBOM, ImgList;

type
  TFrmFndBOM = class(TcrDlgForm)
    Tit: TcrTitle;
    Btns: TcrBtnPanel;
    GrpSearch: TGroupBox;
    BtnSrch: TButton;
    LblSrchPartNo: TLabel;
    EdtSrchNo: TDBEdit;
    qryBOM: TcrIBQuery;
    srcBOM: TDataSource;
    memSrch: TkbmMemTable;
    memSrchBOMNo: TStringField;
    memSrchBomDesc: TStringField;
    srcSrch: TDataSource;
    GrdBrw: TcrdbGrid;
    LblSrchBomDesc: TcrLabel;
    EdtSrchDesc: TDBEdit;
    qryBOMINC_BOM: TIntegerField;
    qryBOMBOMNO: TStringField;
    qryBOMBomDesc: TStringField;
    qryBOMMODEL: TStringField;
    qryBOMKEY_ENG: TStringField;
    qryBOMASSY: TStringField;
    qryBOMDTEADDED: TDateTimeField;
    qryBOMISSUE: TIntegerField;
    qryBOMBOMNOTE: TStringField;
    Tmr: TTimer;
    ChkSrchContains: TDBCheckBox;
    memSrchBomDescContains: TBooleanField;
    qryBOMISOBSOLETE: TIBStringField;
    qryBOMHASOPTIONS: TIBStringField;
    memSrchBOMAka1: TStringField;
    memSrchModel: TStringField;
    memSrchKey_Eng: TStringField;
    LblSrchAKA: TcrLabel;
    EdtSrchAKA: TDBEdit;
    crLabel29: TcrLabel;
    EdtSrchEngineer: TDBEdit;
    LblModel: TcrLabel;
    EdtSrchModel: TDBEdit;
    qryBOMMODELLITE: TIBStringField;
    qryBOMKEY_ENGLITE: TIBStringField;
    qryBOMBOMAKA1: TIBStringField;
    qryBOMCHECKOUTSTATE: TIBStringField;
    qryBOMCHECKEDOUTBY: TIBStringField;
    qryBOMCHECKEDOUTAT: TDateTimeField;
    qryBOMCHECKOUTREASON: TIBStringField;
    imgVCS: TImageList;
    qryBOMCHECKEDOUTBYNAME: TIBStringField;
    procedure crDlgFormCreate(Sender: TObject);
    procedure BtnSrchClick(Sender: TObject);
    procedure EdtSrchEnter(Sender: TObject);
    procedure EdtSrchExit(Sender: TObject);
    procedure BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure srcBOMStateChange(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure GrdBrwTitleHint(Sender: TObject; AField: TField; var AHint: String);
    procedure GrdBrwDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure memSrchNewRecord(DataSet: TDataSet);
    procedure GrdBrwCellHint(Sender: TObject; AField: TField;
      var AHint: String);
  private
     { Private declarations }
    procedure CheckSelectEnabled();
    procedure SelectRow();
    procedure RenderVCSStateToCanvas(ACanvas: TCanvas; ArRect: TRect; AsVCSState: String);
    function  VCSStateAsHintText(AsCheckoutState, AsCheckoutBy: String; AdCheckedAt: TDateTime; AsCheckoutReason: String): String;
  public
     { Public declarations }
  end;

var
  FrmFndBOM: TFrmFndBOM;

function Execute(ADatabase: TIBDatabase; var ArBOMDef: TaidBOMDef): Boolean;

implementation

{$R *.DFM}

uses
  { Delphi Units }
  SysUtils,
  { Application Units }
  crUtil,crDbCommon,
  aidLang, aidTypes;

var
  XrBOMDef  : TaidBOMDef;
  XuDatabase: TIBDatabase;

function Execute(ADatabase: TIBDatabase; var ArBOMDef: TaidBOMDef) : Boolean;
begin
  XrBOMDef  := ArBOMDef;
  XuDatabase:= ADatabase;
  Result    := RunDlgForm(TFrmFndBOM, FrmFndBOM)=mrOk;
  { Return the result }
  ArBOMDef  := XrBOMDef;
end;

procedure TFrmFndBOM.crDlgFormCreate(Sender: TObject);
begin
  MemSrch.Active:= True;
  MemSrch.Append;
  MemSrchBOMNo.Value:= Trim(XrBOMDef.BOMNo);
  //
  QryBOM.Database:= XuDatabase;
  //
  if Length(Trim(XrBOMDef.BOMNo))>0 then
    Tmr.Enabled:= True;
  //
  QryBOM.StoreSQL;
end;

procedure TFrmFndBOM.BtnSrchClick(Sender: TObject);
begin
  if MemSrch.State in [dsEdit, dsInsert] then
    MemSrch.Post;
  //
  QryBOM.ReStoreSQL;
  { BOM # }
  QryBOM.AddWhereClause(QryBOMBOMNO  , MemSrchBOMNO  .AsString, cropLike    , 'BOM #: %s'           , crcoAND, False, 'bm.');
  { BOM Description }
  if MemSrchBomDescContains.AsBoolean then
    QryBOM.AddWhereClause(QryBOMBomDesc , MemSrchBomDesc.AsString, cropContains, 'BOM Description: %s', crcoAND, True, 'bm.')
  else
    QryBOM.AddWhereClause(QryBOMBomDesc , MemSrchBomDesc.AsString, cropLike    , 'BOM Description: %s', crcoAND, True, 'bm.');
  { Model }
  QryBOM.AddWhereClause  (QryBOMMODELLITE, OnlyAlpha(MemSrchModel.AsString), cropLike, 'BOM Model: %s', crcoAND, False, 'bm.');
  { AKA }
  QryBOM.AddWhereClause  (QryBOMBOMAka1 , MemSrchBOMAKA1.AsString, cropLike, 'AKA: %s', crcoAND, False, 'bm.' );
  { Engineer }
  QryBOM.AddWhereClause  (QryBOMKey_EngLite, OnlyAlpha(MemSrchKey_Eng.AsString), cropLike, 'Engineer:', crcoAND, False, 'bm.');
  //
  QryBOM.Activate;
  //
  if (not QryBOM.IsEmpty) then
    TryToFocus(GrdBrw);
end;

procedure TFrmFndBOM.EdtSrchEnter(Sender: TObject);
begin
  Btns   .Default:= False;
  BtnSrch.Default:= True;
end;

procedure TFrmFndBOM.EdtSrchExit(Sender: TObject);
begin
  BtnSrch.Default:= False;
  Btns   .Default:= True;
end;

procedure TFrmFndBOM.BtnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if (Button=crbpSelect) then
    SelectRow;
end;


procedure TFrmFndBOM.CheckSelectEnabled;
begin
  Btns.SetEnabledState(crbpSelect, QryBOM.Active and (not (QryBOM.Eof and QryBOM.Bof)) );
end;


procedure TFrmFndBOM.srcBOMStateChange(Sender: TObject);
begin
  CheckSelectEnabled;
end;

procedure TFrmFndBOM.TmrTimer(Sender: TObject);
begin
  Tmr.Enabled:= False;
  BtnSrch.Click;
end;

procedure TFrmFndBOM.GrdBrwAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
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

procedure TFrmFndBOM.SelectRow;
begin
  XrBOMDef.BOMNo  := Trim(QryBOMBOMNO  .Value);
  XrBOMDef.BomDesc:= Trim(QryBOMBomDesc.Value);
end;


procedure TFrmFndBOM.GrdBrwDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  bDrawn  : Boolean;
begin
  bDrawn:= False;
  //
  if Assigned(Column) and (Assigned(Column.Field)) then
  begin
    { De-emphasise Obsolete BOMs }
    if (qryBOMIsObsolete.AsBoolean) then
      grdBrw.Canvas.Font.Color:= clGrayText;

    { Draw Boolean Fields }
    if (Column.Field = QryBOMIsObsolete) or (Column.Field = QryBOMHasOptions) then
    begin
      GrdBrw.DrawBooleanColumn(Rect, Column, State);
      bDrawn:= True;
    end;
  end;
  { Perform Default Drawing }
  if not bDrawn then
    GrdBrw.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  { Now, deal with overlays }
  if Assigned(Column) then
  begin
    { BOM No. Field, reflect the lock state. }
    if (Column.Field = qryBOMBomNo) then
      RenderVCSStateToCanvas(GrdBrw.Canvas, Rect, qryBOMCheckoutState.AsString);
  end;
end;


procedure TFrmFndBOM.GrdBrwTitleHint(Sender: TObject; AField: TField; var AHint: String);
begin
  // aidLang bomlang
  if (AField = QryBOMISSUE) then AHint:= rsDC_BOMIssueNo else
    if (AField = QryBOMIsObsolete) then AHint:= rsDC_BOMIsObsolete else
      if (AField = QryBOMHASOPTIONS) then AHint:= rsDC_BOMHasOptions;
end;

procedure TFrmFndBOM.memSrchNewRecord(DataSet: TDataSet);
begin
  MemSrchBomDescContains.AsBoolean:= False;
end;

{ GrdBrwCellHint
    Show Cell hints }
procedure TFrmFndBOM.GrdBrwCellHint(Sender: TObject; AField: TField; var AHint: String);
begin
  { Needs the hint stuff here. }
  if (AField = qryBOMBomNo) Then
    AHint:= VCSStateAsHintText(qryBOMCheckoutState.AsString, qryBOMCheckedOutByName.AsString, qryBOMCheckedOutAt.AsDateTime, qryBOMCheckOutReason.AsString);
end;

{ RenderVCSStateToCanvas
    Renders a glyph to a canvas based on a TCheckOutState field value. }
{ NOTE: *** THIS IS DUPLICATED FROM d_BOM *** }
procedure TFrmFndBOM.RenderVCSStateToCanvas(ACanvas: TCanvas; ArRect: TRect; AsVCSState: String);
var
  eCheckoutState  : TaidCheckoutState;
begin
  eCheckoutState:= aidTypes.StringToCheckoutState(AsVCSState);
  //
  case eCheckoutState of
    aidCheckedOut:
    begin
      imgVCS.Draw(ACanvas, ArRect.Right-imgVCS.Width, ArRect.Top + (((ArRect.Bottom-ArRect.Top)-imgVCS.Height) div 2),  0, True);
    end;
  end;
end;


{ VCSStateAsHintText
    Formats the checkout state & related fields for display in the dbGrid hints. }
{ NOTE: *** THIS IS DUPLICATED FROM d_BOM *** }
function TFrmFndBOM.VCSStateAsHintText(AsCheckoutState: String; AsCheckoutBy: String; AdCheckedAt: TDateTime; AsCheckoutReason: String): String;
resourcestring
  rsCheckoutInformationHint =
    'Checked out by %s at %s'#13#10+
    'Reason:'#13#10'%s';
var
  sUserName     : String;
  sCheckedAt    : String;
  sReason       : String;
  eCheckoutState: TaidCheckoutState;
begin
  Result:= '';
  eCheckoutState:= aidTypes.StringToCheckoutState(AsCheckoutState);
  if eCheckoutState in [aidCheckedOut] then
  begin
    sUserName := {FindUserLong}(AsCheckoutBy);
    sCheckedAt:= '';
    if (AdCheckedAt<>0) then
      sCheckedAt:= FormatDateTime('ddddd t ddd', AdCheckedAt);
    sReason   := AsCheckoutReason;
    Result    := Format(rsCheckoutInformationHint, [sUserName, sCheckedAt, sReason]);
  end;
end;




end.
