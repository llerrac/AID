unit aiddbMtnLkpNotes;

{ -------------------------------------------------------------------------------------------------
  Name        : aidldbMtnLkpNotes
  Author      : Chris G. Royle
  Description :
  See also    : aiddbSelLkpNotes
  Note        :
  Modified    :
    CGR20040728, Renamed, and provided a database parameter to allow reuse in other applications.
    CGR20060222, Modified to remove u_Login dependancy from aiddbMtnLkpNotes.
                 Removed "Notes" field. 
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, StdCtrls, DBCtrls, Mask, Controls, Grids, ExtCtrls,
  DB, DBGrids, ComCtrls, Classes,
  IB_Components, IBODataset , IB_Access,
  { 3rd Party Units }
  { Application Units }
  crForms, crIBQry, crDlgFnd, crdbBtns, crCtrls, crdbGrid, crBtns, crPage,
  crdbUtil, ImgList, ActnList, Buttons, Dialogs;

type
  TFrmMtnLookupDropins = class(TcrDlgForm)
    Pge: TcrPageControl;
    TabBrw: TTabSheet;
    TabEdit: TTabSheet;
    BtnBrw: TcrdbBtnBrowse;
    ibTran: TIB_Transaction;
    Grd: TcrdbGrid;
    Fnd: TcrDlgFind;
    qryNte: TcrIBDataset;
    qryNteINC_LKNT: TIntegerField;
    qryNteGROUP_LK: TStringField;
    qryNteDESC_LK: TStringField;
    srcNte: TDataSource;
    genInc: TIBOStoredProc;
    GrpDesc: TcrGroupBox;
    LblDesc: TLabel;
    EdtDesc: TDBEdit;
    GrpNotes: TcrGroupBox;
    MemNte: TDBMemo;
    BtnMtn: TcrdbBtnMaintain;
    qryNteMEMO: TMemoField;
    qryNteCREATEDDTE: TDateTimeField;
    qryNteCREATEDBY: TStringField;
    qryNteALTEREDDTE: TDateTimeField;
    qryNteALTEREDBY: TStringField;
    pnlBtns: TPanel;
    act: TActionList;
    img: TImageList;
    actLoadFromFile: TAction;
    actSaveToFile: TAction;
    SpeedButton1: TSpeedButton;
    btnLoadFromFile: TSpeedButton;
    btnSaveToFile: TSpeedButton;
    dlgLoad: TOpenDialog;
    dlgSave: TSaveDialog;
    procedure crDlgFormCreate(Sender: TObject);
    procedure GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure FndSearch(Sender: TObject; Search: String);
    procedure qryNteNewRecord(DataSet: TDataSet);
    procedure qryNteAfterPost(DataSet: TDataSet);
    procedure qryNteAfterDelete(DataSet: TDataSet);
    procedure crDlgFormActivate(Sender: TObject);
    procedure BtnMtnButtonClick(Sender: TObject; Button: TcrmtnBtn;
      var Handled: Boolean);
    procedure qryNteBeforePost(DataSet: TDataSet);
    procedure crDlgFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure qryNteAfterScroll(DataSet: TDataSet);
    procedure actLoadFromFileExecute(Sender: TObject);
    procedure actSaveToFileExecute(Sender: TObject);
    procedure qryNteAfterOpen(DataSet: TDataSet);
  private
     { Private declarations }
     FsGroup    : string;
     FbModified : Boolean;
     FsUserNo   : String;
    procedure CheckActions;
  public
     { Public declarations }
  end;

var
  FrmMtnLookupDropins: TFrmMtnLookupDropins;

  function Execute(AoDatabase: TIB_connection; AsGroup: string; AsCaption: String = 'Maintain Notes'; AsUserNo: String = ''): Boolean;

implementation

{$R *.DFM}

uses
  { Delphi Units }

  { 3rd Party Units }
  { Application Units }
  crUtil;

var
  Xdb       : TIB_connection;
  XsGroup   : string;
  XsCaption : string;
  XsUserNo  : string;
  XlModified: Boolean;

function Execute(AoDatabase: TIB_connection; AsGroup: string; AsCaption: String = 'Maintain Notes'; AsUserNo: String = ''): Boolean;
begin
  Xdb      := AoDatabase;
  XsGroup  := AsGroup;
  XsCaption:= AsCaption;
  XsUserNo := AsUserNo;
  //
  Result:= False;
  if Assigned(AoDatabase) and (not IsEmptyStr(AsGroup)) then
  begin
    XlModified:= False;
    RunDlgForm(TFrmMtnLookupDropins, FrmMtnLookupDropins);
    Result:= XlModified;
  end;
end;

procedure TFrmMtnLookupDropins.crDlgFormCreate(Sender: TObject);
begin
  FsGroup   := XsGroup;
  Caption   := XsCaption;
  FsUserNo  := XsUserNo;
  FbModified:= False;
  //
  Pge.PreparePage;
  //



  ibTran.IB_Connection:=  Xdb;
  QryNte.ib_connection:=  Xdb;
  ibTran.StartTransaction;
  //
  QryNte.Active:= False;
  QryNte.Params.paramByName('Group_Lk').AsString:= FsGroup;
  QryNte.Active:= True;
end;

procedure TFrmMtnLookupDropins.GrdAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaInsert,
    crbaAppend  :
    begin
      QryNte.Append;
      Pge.ChangeToPage(TabEdit);
      TryToFocus(EdtDesc);
    end;
    crbaEdit,
    crbaView  :
    begin
      Pge.ChangeToPage(TabEdit);
      TryToFocus(EdtDesc);
    end;
    crbaDelete:
      if DeleteAsk then QryNte.Delete;
    crbaSearch: Fnd.Execute(Sender, Arg);
  else
    notyet;
  end;
end;

procedure TFrmMtnLookupDropins.FndSearch(Sender: TObject; Search: String);
begin
  QryNte.Locate(QryNteDesc_Lk.FIeldName, Search, [loPartialKey, loCaseInsensitive]);
end;

procedure TFrmMtnLookupDropins.qryNteNewRecord(DataSet: TDataSet);
begin
    // CGR20010419 Extra Proc statements to prevent Access Violation
  GenInc.Close;
  GenInc.Prepare;
  try
    GenInc.ExecProc;
  finally
    GenInc.Close;
  end;
  QryNteInc_LkNt  .Value:= GenInc.ParamByName('AInc').AsInteger;
  QryNteGroup_Lk  .Value:= FsGroup;
  QryNteCreatedBy .AsString:= FsUserNo;
  GenInc.Close;
end;

procedure TFrmMtnLookupDropins.qryNteAfterPost(DataSet: TDataSet);
begin
  if ibTran.InTransaction then ibTran.CommitRetaining;
  FbModified:= True;
end;

procedure TFrmMtnLookupDropins.qryNteAfterDelete(DataSet: TDataSet);
begin
  if ibTran.InTransaction then ibTran.CommitRetaining;
  FbModified:= True;
end;

procedure TFrmMtnLookupDropins.crDlgFormActivate(Sender: TObject);
begin
  TryToFocus(Grd);
end;

procedure TFrmMtnLookupDropins.BtnMtnButtonClick(Sender: TObject; Button: TcrmtnBtn; var Handled: Boolean);
begin
  if (Button = crmtnClose) then
  begin
    Pge.ChangeToPage(TabBrw);
    Handled:= True;
  end;
end;

procedure TFrmMtnLookupDropins.qryNteBeforePost(DataSet: TDataSet);
begin
  QryNteAlteredBy.AsString:= FsUserNo;
end;

procedure TFrmMtnLookupDropins.crDlgFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  XlModified:= FbModified;
end;

procedure TFrmMtnLookupDropins.qryNteAfterScroll(DataSet: TDataSet);
begin
  CheckActions();
end;

procedure TFrmMtnLookupDropins.CheckActions();
begin
  actLoadFromFile.Enabled:= not qryNte.IsEmpty;
  actSaveToFile  .Enabled:= not qryNte.IsEmpty;
end;

procedure TFrmMtnLookupDropins.actLoadFromFileExecute(Sender: TObject);
begin
  if dlgLoad.Execute then
  begin
    if not (qryNte.State in [dsInsert, dsEdit]) then
      qryNte.Edit;
    qryNteMEMO.LoadFromFile(dlgLoad.FileName);
  end;
end;

procedure TFrmMtnLookupDropins.actSaveToFileExecute(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    qryNteMEMO.SaveToFile(dlgSave.FileName);
  end;
end;

procedure TFrmMtnLookupDropins.qryNteAfterOpen(DataSet: TDataSet);
begin
  CheckActions();
end;

end.
