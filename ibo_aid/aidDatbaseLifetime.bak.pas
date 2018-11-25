unit AidTdmDatbaseLifetime;


{ ------------------------------------------------------------------------------------------------------------
  Name        : d_tDatbaseLifetime
  Author      : Alex carrell
  Description : Database abstraction.

  Modified    :
    AJC       : initial version
    22Jan2007 : placed centrally in aid.

  -------------------------------------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, IBDatabase, DB, ibsql, aidtsimpleDict,ibquery;

type
  //class that test applicatins register database(s) so that code can link to databases etc without
  //relying on extant application code.

  TLiveDatabaseRegistry = class(tsimpleDictionary)
  private
    constructor create;reintroduce;
    function    getDatabase(keyname : string) : TcustomConnection;
    function    getIbTransaction(keyname : string) : TIBtransaction;
  public
    class function Instance : TLiveDatabaseRegistry;
    function  RegisterDatabase(lookupkey,Databasename : string;Database : TcustomConnection) : integer;
    function  RegisterTransaction(lookupkey,transtype : string;trans : TComponent) : integer;
    class function  BomsDatabasename : string;
    class procedure LookUpDbTrans(name : string; var Database : TcustomConnection;var transaction : TIBtransaction) ;overload;
    class procedure LookUpDbTrans(name : string; qry : Tibsql) ;overload;
    class procedure LookUpDbTrans(name : string; qry : Tibquery) ;overload;
    class procedure LookUpDbTrans(name : string; ds : TDataset) ;overload;
    class procedure LookUpDbTrans(name : string; ds : TIBtransaction) ;overload;

    property  Database[key : string] : TcustomConnection read getDatabase;
    property  ibTransaction[key : string] : TIBtransaction read getIbTransaction;

  end;


  TDatabaseLifetime = class(Tobject)
  private
    fdbNew:   TIBDatabase;
    fTran:    TIBTransaction;
    fScrNew:  TIBScript;

    fSettings : tsimpleDictionary;
    procedure setup;
    procedure teardown;

  public
    constructor create(Settings : tsimpleDictionary);
    destructor  destroy;override;
    function    Createdb(): Boolean;

    function    Initialise(Settings : tsimpleDictionary) : string;
    function    SetUpAtlasIbEnvironment : boolean;
    class function ReplicateDatabase(settings : tsimpleDictionary; uniqueDDL: Tstrings) : boolean;

  end;
{
procedure AssignDefaultDatabase(qry : Tibsql);

procedure AssignDefaultTransaction(ds : Tibsql);
}
procedure RegisterDataBase(Databasename : string;Database : TcustomConnection;transname : string='';transaction :TComponent=nil);



implementation
uses IBCustomDataSet;

resourcestring
  c_BomsDatabase = 'BOMS';

//****GLOBAL METHODS*****************************************************************************************/



procedure RegisterDataBase(Databasename : string;Database : TcustomConnection;transname : string='';transaction :TComponent=nil);
begin
  TLiveDatabaseRegistry.Instance.RegisterDatabase(Databasename,'DATABASE',database);
  if assigned(transaction) then
    TLiveDatabaseRegistry.Instance.RegisterTransaction(transname+'TRANS','TRANSACTIONS',transaction);
end;
{
procedure AssignDefaultDatabase(qry : Tibsql);
begin

end;

procedure AssignDefaultTransaction(ds : Tibsql);
begin

end;
}
//****GLOBAL classes*****************************************************************************************/
{ TDatabaseLifetime }

constructor TDatabaseLifetime.create(Settings : tsimpleDictionary);
begin
  inherited create;
  fSettings   := Settings; //reference settings. Could instantiate a copy, but objects need copying as well.
end;

function TDatabaseLifetime.Createdb: Boolean;
begin
  // Create the database
  setup;
  Result:= True;
  try
    //for Creation of database the parms hold sql commands.
    fdbNew.Params.Clear;
    fdbNew.Params.append('USER '    +#39+fSettings[c_lkUserName]+#39);
    fdbNew.Params.append('PASSWORD '+#39+fSettings[c_lkPassword]+#39);
    fdbNew.Params.append('PAGE_SIZE '+fSettings[c_lkPagesize]);
    fdbNew.Params.append('DEFAULT CHARACTER SET ISO8859_1 ');//Latin 1 charset


    try
      fdbNew.CreateDatabase;
    except
      Result:= false;
    end;

  finally
    teardown;
  end;
end;

destructor TDatabaseLifetime.destroy;
begin
//  fsettings.free;

  inherited;
end;

function TDatabaseLifetime.Initialise(Settings: tsimpleDictionary): string;
begin
  fSettings := settings;
end;

procedure TDatabaseLifetime.setup;
begin
  fdbNew    :=  TIBDatabase.create(nil);
  fscrnew   :=  TIBScript.create(nil);
  ftran     :=  TIBTransaction.create(nil);
  ftran.defaultaction := taCommit;
  ftran.allowautostart := true;
  fdbNew.DataBaseName := fSettings[c_lkDatabaseName];
  if fdbNew.DatabaseName <> '' then
  begin
    fdbNew.Params.Clear;
    fdbNew.Params.append('user_name='+fSettings[c_lkUserName]);
    fdbNew.Params.append('password='+fSettings[c_lkPassword]);
    fdbNew.LoginPrompt := False;
    fdbNew.SQLDialect  := 1;
  end;

  ftran.DefaultDatabase := fdbnew;
  fscrnew.Transaction := ftran;
  fscrnew.Database    := fdbNew;
end;

procedure TDatabaseLifetime.teardown;
begin
  fdbNew.Close;
  fTran.free;
  fScrNew.free;
  fdbNew.free;
  fdbNew  := nil;
  fScrNew := nil;
  fTran   := nil;
end;


class function TDatabaseLifetime.ReplicateDatabase(settings : tsimpleDictionary; uniqueDDL: Tstrings): boolean;
begin

    with TDatabaseLifetime.create(settings) do
    try
      Createdb();
      SetUpAtlasIbEnvironment;
      RunScript(uniqueDDL);
      result :=true;
    finally
      free;
    end;
end;

function TDatabaseLifetime.SetUpAtlasIbEnvironment: boolean;
begin
    RunScript(Dm_databaseScripts.IBScriptDomains.Script);
//    RunScript(Dm_databaseScripts.IBScriptProcTriggers.Script);
    result := true;
end;

//*************************************************************************************************//
//        TLiveDatabaseRegistry
//*************************************************************************************************//
//singleton instance
var
  DBreg : TLiveDatabaseRegistry = nil;

constructor TLiveDatabaseRegistry.create;
begin
  inherited;

end;

function    TLiveDatabaseRegistry.getDatabase(keyname : string) : TcustomConnection;
var
  data: pointer;
begin
  data := nil;

  if exists(keyname,data) then
    result := TcustomConnection(data)
  else
    result := nil;
end;


function TLiveDatabaseRegistry.getIbTransaction( keyname: string): TIBtransaction;
var
  data: pointer;
begin
  data := nil;

  if exists(keyname,data) then
  begin
    if tobject(data) is TIBtransaction then
      result := TIBtransaction(data)
    else
      result := nil;
  end
  else
    result := nil;
end;

class function TLiveDatabaseRegistry.Instance : TLiveDatabaseRegistry;
begin
  if not assigned(DBreg) then
    dbreg := TLiveDatabaseRegistry.create;

  result := dbreg;
end;


function TLiveDatabaseRegistry.RegisterDatabase(lookupkey, Databasename: string; Database: TcustomConnection): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey,pointer(database));
  result := indexof(lookupkey);
end;

function TLiveDatabaseRegistry.RegisterTransaction(lookupkey,
  transtype: string; trans: TComponent): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey,pointer(trans));
  result := indexof(lookupkey);
end;

class function TLiveDatabaseRegistry.BomsDatabasename: string;
begin
  result := c_BomsDatabase;
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name: string; var Database: TcustomConnection; var transaction: TIBtransaction);
begin
  database    := Instance.Database[name];
  transaction := Instance.ibTransaction[name+'TRANS'];
end;


class procedure TLiveDatabaseRegistry.LookUpDbTrans(name: string;ds: TDataset);
begin
  if ds is TIBCustomDataSet then
  begin //if ds.database is Tibdatabase then
    TIBCustomDataSet(ds).database    := Tibdatabase(Instance.Database[name]);
    TIBCustomDataSet(ds).transaction := Instance.ibTransaction[name+'TRANS'];
  end;
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name: string; qry: Tibsql);
begin
  qry.database    := Tibdatabase(Instance.Database[name]);
  qry.transaction := Instance.ibTransaction[name+'TRANS'];
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIBtransaction) ;
begin
  ds.defaultdatabase := Tibdatabase(Instance.Database[name]);
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name: string;qry: Tibquery);
begin
  qry.database    := Tibdatabase(Instance.Database[name]);
  qry.transaction := Instance.ibTransaction[name+'TRANS'];
end;

initialization
  DBreg := nil;

finalization
  dbreg.free;

end.
