unit aiddbSelLkpNotes;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbSelLkpNotes
  Author      : Chris G. Royle, 20010912
  Description : View & select a note from LookupNotes for AsGroup
  See Also    : aiddbMtnLkpNotes
  Note        :
  Modified    :
    CGR20040728, Renamed, and provided a database parameter to allow reuse in other applications.
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, DB, DBCtrls, DBGrids, StdCtrls, Grids, Controls, ExtCtrls, ComCtrls, Classes,
  
  { 3rd Party Units }
  { Application Units }
  crForms, crdbUtil, crDlgFnd, crdbGrid, crBtns, crPage, IB_Components,
  IBODataset;

type
  TlkpNote = packed record
    lFound : Boolean;
    sDesc  : String;
    sMemo  : string;
  end;

type
  TFrmSelLookupNote = class(TcrDlgForm)
    Pge: TcrPageControl;
    TabBrw: TTabSheet;
    TabVw: TTabSheet;
    BtnBrw: TcrBtnPanel;
    PnlBtn: TcrBtnPanel;
    qryNte: TIBOQuery;
    qryNteDESC_LK: TStringfield;
    qryNteMEMO: TMemoField;
    srcNote: TDataSource;
    GrdNote: TcrdbGrid;
    BtnViewNote: TButton;
    MemLkpNoteMemo: TDBMemo;
    Fnd: TcrDlgFind;
    tran: tIB_TRANSACTION;
    procedure GrdNoteAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
    procedure PnlBtnButtonClick(Sender: TcrBtnPanel;
      Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure BtnViewNoteClick(Sender: TObject);
    procedure BtnBrwButtonClick(Sender: TcrBtnPanel;
      Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure crDlgFormCreate(Sender: TObject);
    procedure crDlgFormShow(Sender: TObject);
    procedure FndSearch(Sender: TObject; Search: String);
  private
     { Private declarations }
    FsGroup_Lk  : string;
    procedure SelectRow;
  public
     { Public declarations }
  end;

var
  FrmSelLookupNote: TFrmSelLookupNote;

function Execute(AoDatabase: tIB_connection; AsGroup: string; var rNote: TlkpNote): Boolean;

implementation

{$R *.DFM}

uses
  crUtil;

var
  Xdb       : tIB_connection;
  XrNote    : TlkpNote;
  XsGroup_Lk: string;

function Execute(AoDatabase: tIB_connection; AsGroup: string; var rNote: TlkpNote): Boolean;
begin
  Result:= False;
  XsGroup_Lk:= AsGroup;
  Xdb      := AoDatabase;
  FillChar(rNote, SizeOf(TlkpNote), #0);
  //
  if RunDlgForm(TFrmSelLookupNote, FrmSelLookupNote)=mrOk then
  begin
    rNote := XrNote;
    Result:= XrNote.lFound;
  end;
end;

procedure TFrmSelLookupNote.crDlgFormCreate(Sender: TObject);
begin
  FsGroup_Lk:= XsGroup_Lk;
  Pge.PreparePage;
  //
  Tran  .rollback;
  Tran  .IB_connection:=  Xdb;
  QryNte.IB_connection:=  Xdb;
  Tran.StartTransaction;
  //
  qryNte.Close;
  qryNte.ParamByName('AsGroup_Lk').AsString:= FsGroup_Lk;
  qryNte.Open;
end;

procedure TFrmSelLookupNote.GrdNoteAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaEdit,
    crbaView    :
    begin
      SelectRow;
      ModalResult:= mrOk;
    end;
    crbaSearch  :
      Fnd.Execute(Sender, Arg);
  end;
end;


procedure TFrmSelLookupNote.SelectRow;
begin
  XrNote.lFound:= not qryNte.IsEmpty;
  XrNote.sDesc := qryNteDESC_LK.AsString;
  XrNote.sMemo := qryNteMEMO   .AsString;
end;

procedure TFrmSelLookupNote.PnlBtnButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  if Button=crbpClose then
  begin
    Pge.ChangeToPage(TabBrw);
    ModalResult:= mrNone;
  end;
end;

procedure TFrmSelLookupNote.BtnViewNoteClick(Sender: TObject);
begin
  Pge.ChangeToPage(TabVw);
end;

procedure TFrmSelLookupNote.BtnBrwButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpSelect  : SelectRow;
  end;
end;

procedure TFrmSelLookupNote.crDlgFormShow(Sender: TObject);
begin
  TryToFocus(GrdNote);  
end;

procedure TFrmSelLookupNote.FndSearch(Sender: TObject; Search: String);
begin
  qryNte.Locate(qryNteDESC_LK.FieldName, Search, [loPartialKey, loCaseInsensitive]);
end;

end.
