unit aidSearchHTS;

{ aidSearchHTS
    A specific "Harmonized Commodity Coding System" search dialog screen.

  In theory, this could be used to search codings which descend from the HS,
  eg the US-ITC.

    see dataOpera.sql          }

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, crForms, crTitle, crLabel, DBCtrls, crdbLkp,
  Grids, DBGrids, crdbGrid, crBtns, DB, crIBQry,
  kbmMemTable,IB_Components, IBODataset,  Mask, ComCtrls, crPage, crCtrls, crInfo,
  crdbInfo, crdbUtil;

type
  TfrmSearchHTS = class(TcrDlgForm)
    tit: TcrTitle;
    qryTariff: TcrIBQuery;
    srcTariff: TDataSource;
    tran: TIB_TRANSACTION;
    qryTariffTARIFFNO: TStringField;
    qryTariffTARIFFCODING: TStringField;
    qryTariffTARIFFDESC: TStringField;
    mlkFilter01: TkbmMemTable;
    mlkFilter02: TkbmMemTable;
    mlkFilter03: TkbmMemTable;
    slkFilter01: TDataSource;
    slkFilter02: TDataSource;
    slkFilter03: TDataSource;
    qryFilter: TcrIBQuery;
    qryFilterFILTERKEY: TStringField;
    qryFilterFILTERDESC: TStringField;
    qryFilterFILTERWHERE: TStringField;
    memEntry: TkbmMemTable;
    srcEntry: TDataSource;
    memEntryFilter01: TStringField;
    memEntryFilter02: TStringField;
    memEntryFilter03: TStringField;
    memEntryDescContains: TStringField;
    mlkFilter01FILTERKEY: TStringField;
    mlkFilter01FILTERDESC: TStringField;
    mlkFilter01FILTERWHERE: TStringField;
    mlkFilter02FILTERKEY: TStringField;
    mlkFilter02FILTERDESC: TStringField;
    mlkFilter02FILTERWHERE: TStringField;
    mlkFilter03FILTERKEY: TStringField;
    mlkFilter03FILTERDESC: TStringField;
    mlkFilter03FILTERWHERE: TStringField;
    qryTariffTARIFFDESCUPPER: TStringField;
    pge: TcrPageControl;
    tabBrw: TTabSheet;
    tabView: TTabSheet;
    grdHTS: TcrdbGrid;
    grpSearch: TGroupBox;
    grpInfo: TcrGroupBox;
    btns: TcrBtnPanel;
    btnsView: TcrBtnPanel;
    crdBInfo1: TcrdBInfo;
    crdBInfo2: TcrdBInfo;
    crdBInfo3: TcrdBInfo;
    infChapterDesc: TcrdBInfo;
    InfParagraphNo: TcrdBInfo;
    InfParagraphDesc: TcrdBInfo;
    infCommodityNo: TcrdBInfo;
    infCommodityDesc: TcrdBInfo;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    memHSC: TkbmMemTable;
    memHSCSectionNo: TStringField;
    memHSCChapterNo: TStringField;
    memHSCParagraphNo: TStringField;
    memHSCCommodityNo: TStringField;
    memHSCCommodityDesc: TStringField;
    memHSCParagraphDesc: TStringField;
    memHSCChapterDesc: TStringField;
    memHSCSectionDesc: TStringField;
    srcHSC: TDataSource;
    qryFilterPARENTSECTION: TStringField;
    qryFilterPARENTKEY: TStringField;
    lblSrchSection: TcrLabel;
    lkpSrchSection: TcrdbLookupComboBox;
    lblSrchChapter: TcrLabel;
    lkpSrchChapter: TcrdbLookupComboBox;
    lblSrchParagraph: TcrLabel;
    lkpSrchParagraph: TcrdbLookupComboBox;
    crLabel1: TcrLabel;
    edtSrchCode: TDBEdit;
    memEntryCodeStartsWith: TStringField;
    mlkCoding: TkbmMemTable;
    mlkCodingCodingKey: TStringField;
    mlkCodingCodingDesc: TStringField;
    slkCoding: TDataSource;
    memEntryTariffCoding: TStringField;
    lkpTariffCoding: TDBLookupComboBox;
    crLabel2: TcrLabel;
    lblSrchContains: TcrLabel;
    edtSrchContains: TDBEdit;
    btnSearch: TButton;
    btnSrchClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure memEntryFilter01Change(Sender: TField);
    procedure memEntryFilter02Change(Sender: TField);
    procedure btnSearchClick(Sender: TObject);
    procedure grpSearchEnter(Sender: TObject);
    procedure grpSearchExit(Sender: TObject);
    procedure grdHTSAction(Sender: TObject; Action: TcrdbAction;
      Arg: Word);
    procedure btnsViewButtonClick(Sender: TcrBtnPanel;
      Button: TcrBtnPanelType; var ModalResult: TModalResult);
    procedure btnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType;
      var ModalResult: TModalResult);
    procedure memHSCChapterNoGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnSrchClearClick(Sender: TObject);
  private
     { Private declarations }
    FsTariffCode  : string;
    FsTariffCoding: string;
    Fudb          : TIB_Connection;
    //
    procedure LoadFilter01;
    procedure LoadFilter02;
    procedure LoadFilter03;
    procedure CloseFilter02;
    procedure CloseFilter03;
    procedure PerformSearch;
    procedure ShowInformation;
    function  HSCAsUSITCDisplay(AsDisplay: string): string;
    function  HSCDescAsDisplay (AsArg: string): string;
    procedure SelectTariff;
    procedure LookLookups;
  public
     { Public declarations }
    constructor CreateEx(Adb: TIB_Connection; AsTariffCoding, AsTariffCode: string);
  end;

function Execute(Adb: TIB_Connection; var sTariffCoding, sTariffCode: string): Boolean;

implementation

{$R *.DFM}

uses
  crDbCommon,crUtil;

var
  xsTariffCode  : string;
  xsTariffCoding: string;

function Execute(Adb: TIB_Connection; var sTariffCoding, sTariffCode: string): Boolean;
begin
  Result:= False;
  with TfrmSearchHTS.CreateEx(Adb, sTariffCoding, sTariffCode) do
  begin
    if (ShowModal = mrOk) then
    begin
      sTariffCode  := xsTariffCode;
      sTariffCoding:= xsTariffCoding;
      //
      Result:= True;
    end;
  end;
end;

procedure TfrmSearchHTS.FormCreate(Sender: TObject);
begin
  pge.PreparePage;
  tran.rollback;
  tran.ib_connection:= Fudb;
  if not tran.InTransaction then tran.StartTransaction;
  //
  qryFilter.StoreSQL;
  qryFilter.OptionsEx:= qryFilter.OptionsEx - [crWarnIfNoParams];
  //
  qryTariff.StoreSQL;
  memEntry .Close;
  //
  LookLookups;
  //
  memEntry.Open;
  memEntry.Append;
  memEntryCodeStartsWith.AsString:= LeftStr(Trim(FsTariffCode), 6);   // HTS first 6 digits are always the same for all countries.
  memEntryTariffCoding  .AsString:= FsTariffCoding;
  //
  LoadFilter01;
end;


procedure TfrmSearchHTS.LookLookups;
begin
  mlkCoding.Close;
  mlkCoding.Open;
  mlkCoding.AppendRecord(['US-ITC08' , 'US  8 Digit Statistical']);
  mlkCoding.AppendRecord(['US-ITC10' , 'US 10 Digit']);
  mlkCoding.AppendRecord(['INTRASTAT', 'Intrastat']);
end;


procedure TfrmSearchHTS.LoadFilter01;
begin
  qryFilter.RestoreSQL;
  qryFilter.ParamByName('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName('AsFilterSection').AsString:= 'HTS-SECT';
  qryFilter.Activate;
  //
  try
    mlkFilter01.DisableControls;
    mlkFilter01.Close;
    mlkFilter01.Open;
    while not qryFilter.EOF do
    begin
      mlkFilter01.Append;
      crdbUtil   .CopyFieldsFromTo(qryFilter, mlkFilter01);
      mlkFilter01FILTERDESC.AsString:= HSCDescAsDisplay(mlkFilter01FILTERDESC.AsString);
      mlkFilter01.Post;
      //
      qryFilter  .Next;
    end;
  finally
    qryFilter  .Close;
    mlkFilter01.First;
    mlkFilter01.EnableControls;
  end;
end;


procedure TfrmSearchHTS.LoadFilter02;
begin
  qryFilter.RestoreSQL;
  qryFilter.ParamByName   ('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName   ('AsFilterSection').AsString:= 'HTS-CHAP';
  qryFilter.AddWhereClause('ParentSection', 'HTS-SECT'               , cropEqual, '', crcoAnd, False, 'lf.');
  qryFilter.AddWhereClause('ParentKey'    , memEntryFilter01.AsString, cropEqual, '', crcoAnd, False, 'lf.');
  qryFilter.Activate;
  //
  try
    mlkFilter02.DisableControls;
    mlkFilter02.Close;
    mlkFilter02.Open;
    while not qryFilter.EOF do
    begin
      mlkFilter02.Append;
      crdbUtil   .CopyFieldsFromTo(qryFilter, mlkFilter02);
      mlkFilter02FILTERDESC.AsString:= HSCDescAsDisplay(mlkFilter02FILTERDESC.AsString);
      mlkFilter02.Post;
      //
      qryFilter  .Next;
    end;
  finally
    qryFilter  .Close;
    mlkFilter02.First;
    mlkFilter02.EnableControls;
  end;
end;



procedure TfrmSearchHTS.memEntryFilter01Change(Sender: TField);
begin
  CloseFilter03;
  CloseFilter02;
  LoadFilter02;
end;

procedure TfrmSearchHTS.memEntryFilter02Change(Sender: TField);
begin
  CloseFilter03;
  LoadFilter03;
end;


procedure TfrmSearchHTS.CloseFilter02;
begin
  mlkFilter02.Close;
end;


procedure TfrmSearchHTS.CloseFilter03;
begin
  mlkFilter03.Close;
end;



procedure TfrmSearchHTS.LoadFilter03;
begin
  qryFilter.RestoreSQL;
  qryFilter.ParamByName   ('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName   ('AsFilterSection').AsString:= 'HTS-PARA';
  qryFilter.AddWhereClause('ParentSection', 'HTS-CHAP'               , cropEqual, '', crcoAnd, False, 'lf.');
  qryFilter.AddWhereClause('ParentKey'    , memEntryFilter02.AsString, cropEqual, '', crcoAnd, False, 'lf.');
  qryFilter.Activate;
  //
  try
    mlkFilter03.DisableControls;
    mlkFilter03.Close;
    mlkFilter03.Open;
    while not qryFilter.EOF do
    begin
      mlkFilter03.Append;
      crdbUtil   .CopyFieldsFromTo(qryFilter, mlkFilter03);
      mlkFilter03FILTERDESC.AsString:= HSCDescAsDisplay(mlkFilter03FILTERDESC.AsString);
      mlkFilter03.Post;
      //
      qryFilter  .Next;
    end;
  finally
    qryFilter  .Close;
    mlkFilter03.First;
    mlkFilter03.EnableControls;
  end;
end;


procedure TfrmSearchHTS.btnSearchClick(Sender: TObject);
begin
  PerformSearch;
  if not qryTariff.IsEmpty then
    TryToFocus(grdHTS);
end;


procedure TfrmSearchHTS.PerformSearch;
var
  sStartsWith : string;
begin
  if memEntry.State in [dsEdit, dsInsert] then
    memEntry.Post;
  //
  sStartsWith:= memEntryFilter03.AsString;
  if IsEmptyStr(sStartsWith) then
    sStartsWith:= memEntryFilter02.AsString;
  if not IsEmptyStr(memEntryCodeStartsWith.AsString) then
    sStartsWith:= memEntryCodeStartsWith.AsString;
  //
  qryTariff.Close;
  qryTariff.ReStoreSQL;
  qryTariff.ParamByName   ('AsDataGroup'    ).AsString:= 'HTS';
  qryTariff.AddWhereClause(qryTariffTARIFFNO       , sStartsWith, cropLike, '', crcoAND, False, 'tc.');
  qryTariff.AddWhereClause(qryTariffTARIFFDESCUPPER, memEntryDescContains, cropContains, '', crcoAND, False, 'tc.');
  qryTariff.AddWhereClause(qryTariffTARIFFCODING   , memEntryTariffCoding, cropEqual   , '', crcoAND, False, 'tc.');
  qryTariff.Activate;
end;

procedure TfrmSearchHTS.grpSearchEnter(Sender: TObject);
begin
  btnSearch.Default:= True;
  btns     .Default:= False;
end;

procedure TfrmSearchHTS.grpSearchExit(Sender: TObject);
begin
  btnSearch.Default:= False;
  btns     .Default:= True;
end;

procedure TfrmSearchHTS.grdHTSAction(Sender: TObject; Action: TcrdbAction; Arg: Word);
begin
  case Action of
    crbaView,
    crbaEdit  :
    begin
      if not qryTariff.IsEmpty then
        ShowInformation;
    end;
  end;
end;


procedure TfrmSearchHTS.ShowInformation;
var
  sSect,
  sChap,
  sPara : string;
begin
  // from the tariff code, back-track to 4 digits, 2 digits, section, query all of these for
  // the display.
  memHSC.Open;
  memHSC.Append;
  memHSCCommodityNo  .AsString:= qryTariffTariffNo  .AsString;
  memHSCCommodityDesc.AsString:= qryTariffTariffDesc.AsString;
  //
  sPara:= LeftStr(qryTariffTariffNo  .AsString, 4);
  qryFilter.Close;
  qryFilter.ReStoreSQL;
  qryFilter.ParamByName('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName('AsFilterSection').AsString:= 'HTS-PARA';
  qryFilter.AddWhereClause(qryFilterFilterKey, sPara, cropEqual, '', crcoAND, False, 'lf.');
  qryFilter.Activate;
  memHSCParagraphNo  .AsString:= qryFilterFilterKey .AsString;
  memHSCParagraphDesc.AsString:= HSCDescAsDisplay(qryFilterFilterDesc.AsString);
  //
  sChap:= Trim(qryFilterParentKey.AsString);
  qryFilter.Close;
  qryFilter.ReStoreSQL;
  qryFilter.ParamByName('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName('AsFilterSection').AsString:= 'HTS-CHAP';
  qryFilter.AddWhereClause(qryFilterFilterKey, sChap, cropEqual, '', crcoAND, False, 'lf.');
  qryFilter.Activate;
  memHSCChapterNo  .AsString:= qryFilterFilterKey .AsString;
  memHSCChapterDesc.AsString:= HSCDescAsDisplay(qryFilterFilterDesc.AsString);
  //
  sSect:= Trim(qryFilterParentKey.AsString);
  qryFilter.Close;
  qryFilter.ReStoreSQL;
  qryFilter.ParamByName('AsDataGroup'    ).AsString:= 'HTS';
  qryFilter.ParamByName('AsFilterSection').AsString:= 'HTS-SECT';
  qryFilter.AddWhereClause(qryFilterFilterKey, sSect, cropEqual, '', crcoAND, False, 'lf.');
  qryFilter.Activate;
  memHSCSectionNo  .AsString:= qryFilterFilterKey .AsString;
  memHSCSectionDesc.AsString:= HSCDescAsDisplay(qryFilterFilterDesc.AsString);
  //
  qryFilter.Close;
  //
  memHSC.Post;
  //
  pge.ChangeToPage(tabView);
end;


procedure TfrmSearchHTS.btnsViewButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpCancel:
    begin
      pge.ChangeToPage(tabBrw);
      ModalResult:= mrNone;
    end;
    crbpSelect:
    begin
      SelectTariff;
      ModalResult:= mrOk;
    end;
  end;
end;


procedure TfrmSearchHTS.SelectTariff;
begin
  xsTariffCode  := qryTariffTariffNo    .AsString;
  xsTariffCoding:= qryTariffTariffCoding.AsString
end;

procedure TfrmSearchHTS.btnsButtonClick(Sender: TcrBtnPanel; Button: TcrBtnPanelType; var ModalResult: TModalResult);
begin
  case Button of
    crbpProceed:
    begin
      if not qryTariff.IsEmpty then
        ShowInformation;
      //
      ModalResult:= mrNone;
    end;
  end;
end;

procedure TfrmSearchHTS.memHSCChapterNoGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text:= Sender.AsString;
  if DisplayText then
    Text:= HSCAsUSITCDisplay(Text);
end;

function TfrmSearchHTS.HSCAsUSITCDisplay(AsDisplay: string): string;
var
  sTmp    : string;
  iParts  : Integer;
  iK      : Integer;
begin
  sTmp  := Trim(AsDisplay);
  Result:= '';
  iParts:= Length(sTmp) div 2;
  for iK:= 1 to iParts do
  begin
    if Result>'' then Result:= Result+'.';
    Result:= Result+SubStr(sTmp, (iK*2-1), 2);
  end;
end;


function  TfrmSearchHTS.HSCDescAsDisplay(AsArg: string): string;
begin
  Result:= crUtil.MixedCase(AsArg, ['NESOI']);
end;


constructor TfrmSearchHTS.CreateEx(Adb: TIB_Connection; AsTariffCoding, AsTariffCode: string);
begin
  FsTariffCoding:= AsTariffCoding;
  FsTariffCode  := AsTariffCode;
  Fudb          := Adb;
  inherited Create(Application);
end;

procedure TfrmSearchHTS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmSearchHTS.FormShow(Sender: TObject);
begin
  trytofocus(lkpSrchSection);
end;

procedure TfrmSearchHTS.btnSrchClearClick(Sender: TObject);
begin
  memEntry.Close;
  memEntry.Open;
  memEntry.Append;
end;

end.
