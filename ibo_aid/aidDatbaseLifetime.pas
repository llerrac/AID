unit aidDatbaseLifetime;

{ ------------------------------------------------------------------------------------------------------------
  Name        : d_tDatbaseLifetime
  Author      : Alex carrell
  Description : Database abstraction.

  Modified    :
    AJC       : initial version
    22Jan2007 : placed centrally in aid.

    17Oct2008 : (boms build 64)
                Transaction look ups changed to handle dynamic loading of DB.
                Addition of TIBO* classes to assignment code
                NOTE, this unit must be in the INTERFACE uses clause of used, it relies on initilialization/finalization code.
    2009Nov   : another class type added
    2009nov06 : adding overrides for default database.
  -------------------------------------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DB, aidtsimpleDict, kbmMemTable,IBStoredProc,
  IB_Components, IBODataset , IB_Access;

type
  //class that test applicatins register database(s) so that code can link to databases etc without
  //relying on extant application code.
  TLiveDatabaseRegistry = class(tsimpleDictionary)
  //to do: remove reference to specific classes of connection,query. So that the different connection,
  //database engines are registered and resolved, rather than straight assignments.
  private
    constructor create;reintroduce;
    function    getDatabase(keyname : string) : Tobject;

    function    getIbTransaction(keyname : string) : Tobject;
  public
    class function Instance : TLiveDatabaseRegistry;
    function  RegisterDatabase(lookupkey,Databasename : string;Database : Tcomponent) : integer;
//    function  RegisterDatabase(lookupkey,Databasename : string;Database : TcustomConnection) : integer;
//    function  RegisterDatabase(lookupkey,Databasename : string;Database : TcustomConnection) : integer;
    function  RegisterTransaction(lookupkey,transtype : string;trans : TComponent) : integer;
    function  unregisterTransaction(transactionName : string) : integer;
    function unregisterDataBase(Databasename : string) : integer;

    class function  BomsDatabasename : string;
    //ib

    //ibo
    class procedure LookUpDbTrans(name : string; ds : TIB_Query; tranname : string='') ;overload;
    class procedure LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;overload;
    class procedure LookUpDbTrans(name : string; ds : TIB_Cursor; tranname : string='') ;overload;
    class procedure LookUpDbTrans(name : string; ds : TIB_DSQL; tranname : string='') ;overload;
    class procedure LookUpDbTrans(name : string; ds : TiboUpdateSql; tranname : string='') ;overload;
    class procedure LookUpDbTrans(name : string; ds : TIBoStoredProc; tranname : string='') ;overload;
    //class procedure LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;overload;

    class procedure LookUpDbTrans(dbname: string; var Database: TIB_Connection; var transaction: TIB_Transaction;tranname : string='');overload;
                    //LookUpDbTrans(name : string; ds : TIBOQuery;tranname : string='') ;overload;
    property  Database[key : string]      : Tobject read getDatabase;
    property  ibTransaction[key : string] : Tobject read getIbTransaction;

  end;


  TDatabaseLifetime = class(TComponent)
  private

    fSettings : tsimpleDictionary;
    procedure setup;
    procedure teardown;

  public

    constructor create(AOwner : TComponent; Settings : tsimpleDictionary);reintroduce;

    destructor  destroy;override;
    function    Createdb(): Boolean;
    function    Initialise(Settings : tsimpleDictionary) : string;
    function    SetUpAtlasIbEnvironment : boolean;
    function    RunScript(script : Tstrings) : boolean;
    class function ReplicateDatabase(settings : tsimpleDictionary; uniqueDDL: Tstrings) : boolean;

  end;

procedure AssignTransactionToComponents(comp : Tcomponent;trans : Tib_transaction);
procedure AssignDatabaseToComponents(owner :tcomponent;dbname : string = '');overload;//loop components and assign a registered database
procedure AssignDatabaseToComponents(dbname : string;owner :tObject);overload;

function AssignDatabaseDetails(target :tcomponent;dbname : string = '') : boolean;

function AsClientDataSet(owner : Tcomponent; ds : Tdataset;lookupname : string = '') : TkbmMemTable;overload;//loop owner components and create tkbmTable for query name=lookupname supplied
function GetSqlQuery(owner : Tcomponent;sqry_name : string; ds : Tdatasource) : boolean;overload;
function GetSqlQuery(owner : Tcomponent;sqry_name : string) : TkbmMemTable;overload;

function AsClientDataSet(owner : Tcomponent; sql : string; lookupname : string;dbname : string): TkbmMemTable; overload;
function RefreshLookup(sql : string; lookupname : string;dbname : string): TkbmMemTable;Overload;
function RefreshLookup(ds : TIBOQuery; lookupname : string) : TkbmMemTable;Overload;

procedure RegisetrDefaultDatabaseName(DBname : string;transName : string);
procedure RegisterDataBase(Databasename : string;Database : TComponent;transname : string='';transaction :TComponent=nil);
procedure unregisterDataBase(Databasename : string);
function  RegisterTransaction(transname : string;transaction :TComponent) : integer;
function  UnRegisterTransaction(transname : string;transaction :TComponent) : integer;


procedure SetDefaultTransaction (transactionName : string);

resourcestring
  c_IBOBomsDatabase = 'IBOBOMS';


implementation
uses IBCustomDataSet, crIBQry;

var
  regnil: Integer = 0;

  regcreatcount : Integer = 0;
  DefaultDatabaseName : string = 'bomsdb';
resourcestring
  c_BomsDatabase = 'BOMS';

//*****************UNIT LOCAL*****************
var
  _current_transaction : string;

function CastToTcustomConnection(ject : Tobject) : TcustomConnection;
begin
  result := nil;
  if ject is TcustomConnection then
    result := ject as TcustomConnection
  else
    exception.Create('database connection is not TcustomConnection, name of connection - ' + ject.classname);
end;


function CastToTIBODatabase(ject : Tobject) : TIBODatabase;
begin
  result := nil;
  if ject is TIBODatabase then
    result := ject as TIBODatabase
  else
    exception.Create('Object is not TIBODatabase, name of object - ' + ject.classname );
end;

function CastToIBOTransaction(ject : Tobject) : TIBOTransaction;
begin
  result := nil;
  if ject is TIBOTransaction then
    result := ject as TIBOTransaction
  else
    exception.Create('Object is not IBOTransaction, name of object - ' + ject.classname );
end;

function CastToTIB_Connection(ject : Tobject) : TIB_Connection;
begin
  if ject is TIB_Connection then
    result := ject as TIB_Connection
  else
    raise exception.Create('Object is not TIB_Connection, name of object - ' + ject.classname );
end;

//TIB_Transaction
function CastToTIB_Transaction(ject : Tobject) : TIB_Transaction;
begin
  result := nil;
  if ject is TIB_Transaction then
    result := ject as TIB_Transaction
  else
    exception.Create('Object is not TIB_Transaction, name of object - ' + ject.classname );
end;


function CastToTIBOQuery(ject : Tobject) : TIBOQuery;
begin
  result := nil;
  if ject is TIBOQuery then
    result := ject as TIBOQuery
  else
    exception.Create('Object is not TIBOQuery, name of object - ' + ject.classname );
end;





//****GLOBAL METHODS*****************************************************************************************/


procedure RegisetrDefaultDatabaseName(DBname : string;transName : string);
begin
  DefaultDatabaseName := DbName;
end;
procedure RegisterDataBase(Databasename : string;Database : TComponent;transname : string='';transaction :TComponent=nil);
begin
  TLiveDatabaseRegistry.Instance.RegisterDatabase(Databasename,'DATABASE',database);
  if assigned(transaction) then
    TLiveDatabaseRegistry.Instance.RegisterTransaction(transname,'TRANSACTIONS',transaction);
end;

procedure unregisterDataBase(Databasename : string);
begin
  TLiveDatabaseRegistry.Instance.unregisterDataBase(Databasename);
end;

{
procedure AssignDefaultDatabase(qry : Tibsql);
begin

end;

procedure AssignDefaultTransaction(ds : Tibsql);
begin

end;
}

procedure SetDefaultTransaction (transactionName : string);
begin
  _current_transaction := transactionName;
end;

function RegisterTransaction(transname : string;transaction :TComponent) : integer;
begin
  result := -1;
  if assigned(transaction) then
    result := TLiveDatabaseRegistry.Instance.RegisterTransaction(transname,'TRANSACTIONS',transaction);
end;

function UnRegisterTransaction(transname : string;transaction :TComponent) : integer;
begin
  result := -1;
  if  transname <> '' then
   result := TLiveDatabaseRegistry.Instance.unRegisterTransaction(transname);
end;


function  isDataSetSafeType(comp: Tcomponent) : boolean;
begin
  result := (comp is Tdataset) ;
end;

function  lookupClientDataSet(owner : tcomponent; valuetofind : string ) : TkbmMemTable;
var
  index           : integer;
begin
  result := nil;
  if assigned(owner) then
    for index := 0 to owner.Componentcount -1 do//dmLookups
    begin
      //if statement to handle no overloaded version of procedure available.
      if  (owner.Components[index].name  = valuetofind)  and
          (owner.Components[index] is TkbmMemTable) then
      begin
        result := owner.Components[index] as TkbmMemTable;
        if (not result.active ) then
          result.Active := true;
      end;
    end;

end;

procedure CopyFields(target : TkbmMemTable;ds : Tdataset);overload;
var
  fieldi : integer;
begin
  for fieldi := 0 to ds.fieldcount -1 do
    target.CreateFieldAs(ds.fields[fieldi]);
end;

function AsClientDataSet(owner : Tcomponent; ds : Tdataset;lookupname : string) : TkbmMemTable;
begin
  result := lookupClientDataSet(owner, ds.name+lookupname+'_cds');

  if result = nil then
  begin
    if ds is TcrIBQuery then
      TcrIBQuery(ds).OptionsEx:= [];

    if not ds.active then
      ds.Active := true;
    result := TkbmMemTable.create(owner);
    try
      result.name := ds.name+lookupname+'_cds';

      CopyFields(result,ds);
      result.LoadFromDataSet(ds,[mtcpoProperties]);
    finally
      ds.Active :=false;
    end;

    if not result.active then
      result.Active := true;
  end;
end;


function AsClientDataSet(owner : Tcomponent; sql : string; lookupname : string;dbname : string): TkbmMemTable; overload;
var
  query : TIBOQuery;
begin
  query := TIBOQuery.create(owner);
  try
    AssignDatabaseToComponents(query,dbname);

    query.sql.text := sql;

    query.open;
    result := AsClientDataSet(owner, query,lookupname);
  finally
    query.Free;
  end;
end;

function RefreshLookup(sql : string; lookupname : string;dbname : string) : TkbmMemTable;Overload;
//refresh a cached dataset - returns nil if the is nothing to refresh.
var
  query : TIBOQuery;

begin
  query := TIBOQuery.create(nil);
  try
    AssignDatabaseToComponents(query,dbname);

    query.sql.text := sql;

    query.open;
    result := RefreshLookup(query,lookupname);


  finally
    query.Free;
  end;

end;


function RefreshLookup(ds : TIBOQuery; lookupname : string) : TkbmMemTable;Overload;
begin
  result := lookupClientDataSet(nil, ds.name+lookupname+'_cds');
  if assigned(result) then
  begin
    result.emptyTable;

    CopyFields(result,ds);
    result.LoadFromDataSet(ds,[mtcpoProperties]);
  end;
end;

procedure AssignTransactionToComponent(comp : Tcomponent;trans : Tib_transaction);
begin
  try
    //if statement to handle no overloaded version of procedure available.
    if comp is TIBOQuery then
       (comp as TIBOQuery).IB_Transaction := trans
//    else if comp is TiboUpdateSql then
//      (comp as TiboUpdateSql).IB_Transaction := trans
    else if comp is TIB_Cursor then
      (comp as TIB_Cursor).IB_Transaction := trans
    else if comp is TIB_DSQL then
      (comp as TIB_DSQL).IB_Transaction := trans
    else if comp is TIBOQuery then
      (comp as TIBOQuery).IB_Transaction := trans
    else if comp is TIBoStoredProc then
      (comp as TIBoStoredProc).IB_Transaction := trans
    else if comp is TIB_Query then
      (comp as TIB_Query).IB_Transaction := trans
//
//    else if comp is Tdataset then
//      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as Tdataset,_current_transaction);
    //everything else could be any Tcomponent descendent!
  except
    on e :exception do
    begin
      e.message := 'No DB component found : '+e.message;
      raise;
    end;
  end;
end;

procedure AssignTransactionToComponents(comp : Tcomponent;trans : Tib_transaction);
var
  index : integer;
begin
  for index := 0 to comp.ComponentCount -1 do
    AssignTransactionToComponent(comp.Components[index],trans);
end;

procedure CheckComponent(dbname : string;comp : TObject);
begin
  //__currenttran = '' allows overriding of the tran by direct call.
  try
    //if statement to handle no overloaded version of procedure available.
    if comp is TIBOQuery then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIBOQuery,_current_transaction)
    {
    else if (comp is TIBOInternalDataset) or
            (comp is TIB_KeyDataLink)  or
            (comp is TIB_ConnectionLink ) or
            (comp is TIB_TransactionLink) or
            (comp is TIB_MasterDataLink) or
            (comp is TIB_UpdateSQL) then
    begin
      //ignore internal ibo   //
    end
    else if (comp is TDataModule) then
    begin
      //ignore owner classes.
    end
    }
    else if comp is TiboUpdateSql then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TiboUpdateSql,_current_transaction)
    else if comp is TIB_Cursor then
     TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIB_Cursor,_current_transaction)
    else if comp is TIB_DSQL then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIB_DSQL,_current_transaction)
    else if comp is TIBOQuery then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIBOQuery,_current_transaction)
    else if comp is TIBoStoredProc then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIBoStoredProc,_current_transaction)
    else if comp is TIB_Query then
      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as TIB_Query,_current_transaction)
//
//    else if comp is Tdataset then
//      TLiveDatabaseRegistry.LookUpDbTrans(dbname,comp as Tdataset,_current_transaction);

    //everything else could be any Tcomponent descendent!



  except
    on e :exception do
    begin
      e.message := 'No DB component found : '+e.message;
      raise;
    end;
  end;


end;
procedure AssignDatabaseToComponents(owner :tcomponent;dbname : string = '');
var
  index     : integer;
  breakout  : boolean;
begin
  breakout := false;
  if dbname = '' then
    dbname :=  TLiveDatabaseRegistry.BomsDatabasename;

  CheckComponent(dbname,owner);
  if not breakout then
    for index := 0 to owner.Componentcount -1 do
    begin
      AssignDatabaseToComponents(owner.Components[index],dbname);
    end;
end;

procedure AssignDatabaseToComponents(dbname : string;owner : tObject);
begin
  if dbname = '' then
    dbname :=  TLiveDatabaseRegistry.BomsDatabasename;

  CheckComponent(dbname,owner);
end;

function AssignDatabaseDetails(target :tcomponent;dbname : string = '') : boolean;
var
  existingConnection : Tobject;
begin
  if dbname = '' then
    dbname := TLiveDatabaseRegistry.BomsDatabasename;

  result := (target is TIB_Connection);
  if result then
  begin
    existingConnection :=TLiveDatabaseRegistry.Instance.Database[dbname];
    result := assigned(existingConnection);

    if result then
    with CastToTIB_Connection(existingConnection) do
    begin
      (target as TIB_Connection).Disconnect;
      (target as TIB_Connection).Server       := server;
      (target as TIB_Connection).path         := path;
      (target as TIB_Connection).DatabaseName := DatabaseName;
      (target as TIB_Connection).Username     := username;
      (target as TIB_Connection).Password     := password;
      (target as TIB_Connection).loginprompt  := false;
    end;
  end;
end;


function GetSqlQuery(owner : Tcomponent;sqry_name : string; ds : Tdatasource) : boolean;
var
  aval : TkbmMemTable;
begin
  result := false;
  if not assigned(ds) then
    exit;

  aval := GetSqlQuery(owner,sqry_name);
  result := assigned(aval);
  if result  then
    ds.dataset := aval;
end;

function GetSqlQuery(owner : Tcomponent;sqry_name : string) : TkbmMemTable;
var
  index : integer;
begin
  result := nil;

  for index := 0 to owner.Componentcount -1 do
  begin
    //if statement to handle no overloaded version of procedure available.
    if owner.Components[index].name  = sqry_name  then
    begin
      if (owner.Components[index] is Tdataset) then
        result := AsClientDataSet(owner,owner.Components[index] as Tdataset)
      else
        raise exception.create('Invalid Lookup name,'+ sqry_name + ' in ' +owner.name+' given. Please close program and report error.');

      break;
    end;
  end;
end;



//****GLOBAL classes*****************************************************************************************/
{ TDatabaseLifetime }

constructor TDatabaseLifetime.create(AOwner : TComponent; Settings : tsimpleDictionary);
begin
  inherited create(AOwner);
  fSettings   := Settings; //reference settings. Could instantiate a copy, but objects need copying as well.
end;

function TDatabaseLifetime.Createdb: Boolean;
begin

  // Create the database
  setup;
  Result:= True;
  try
{
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
}
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
  
end;

procedure TDatabaseLifetime.teardown;
begin
end;


class function TDatabaseLifetime.ReplicateDatabase(settings : tsimpleDictionary; uniqueDDL: Tstrings): boolean;
begin
    with TDatabaseLifetime.create(nil,settings) do
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
//    RunScript(Dm_databaseScripts.IBScriptDomains.Script);
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
  inc(regcreatcount);
end;

function    TLiveDatabaseRegistry.getDatabase(keyname : string) : Tobject;
var
  data: pointer;
begin
  data := nil;

  if exists(keyname,data) then
    result := Tobject(data)
  else
    result := nil;
end;


function TLiveDatabaseRegistry.getIbTransaction( keyname: string): Tobject;
var
  data: pointer;
begin

  data := nil;

  if exists(keyname+'_TRAN',data) then
  begin
    result := Tobject(data)
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


function TLiveDatabaseRegistry.RegisterDatabase(lookupkey, Databasename: string; Database: Tcomponent): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey,pointer(database));
  result := indexof(lookupkey);
end;


function TLiveDatabaseRegistry.unregisterDataBase(Databasename : string) : integer;
begin
  result := deleteKey(Databasename);
end;

function TLiveDatabaseRegistry.RegisterTransaction(lookupkey, transtype: string; trans: TComponent): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey+'_TRAN',pointer(trans));
  result := indexof(lookupkey);
end;

function TLiveDatabaseRegistry.unregisterTransaction(transactionName : string) : integer;
begin
  result := deleteKey(transactionName+'_TRAN'); //,pointer(trans));

//  result := indexof(lookupkey);
end;

class function TLiveDatabaseRegistry.BomsDatabasename: string;
begin
  result := DefaultDatabaseName;  
end;



class procedure TLiveDatabaseRegistry.LookUpDbTrans(dbname: string; var Database: TIB_Connection; var transaction: TIB_Transaction;tranname : string);
begin
  if tranname = '' then
    tranname := dbname;

  database    := CastToTIB_Connection(Instance.Database[dbname]);
  transaction := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;





//TIBOQuery
{class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIBOQuery;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name ;

  ds.IB_Connection    := CastToTIBODatabase(Instance.Database[name]);
  ds.ib_transaction   := CastToIBOTransaction(Instance.ibTransaction[tranname]);
end;
}


class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TiboUpdateSql; tranname : string='') ;
begin
{
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
}
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIB_Query; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;


class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIBoStoredProc; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;

class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIB_Cursor;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;

//IB_DSQL;
class procedure TLiveDatabaseRegistry.LookUpDbTrans(name : string; ds : TIB_DSQL;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(Instance.ibTransaction[tranname]);
end;

//******************************************************************************/
// {TDatabaseLifetime}
//******************************************************************************/
function  TDatabaseLifetime.RunScript(script : Tstrings) : boolean;
begin

  setup;

  try
  {
    fdbNew.Connected   := True;

    fscrNew.Script.assign(script);
    fscrNew.ExecuteScript;

    fdbNew.Connected   := false;
  }
  finally
    teardown;
  end;
  result := true;

end;

(*********************************************************************************************
UNIT local
*********************************************************************************************)

procedure TearDown;
begin
  _current_transaction := '';
//  if assigned(DataLookupStrings) then
//    DataLookupStrings.free;
  if assigned(dbreg) then
    dbreg.free;
end;

procedure SetUp;
begin
  _current_transaction := '';
  DBreg := nil;
//  DataLookupStrings := TBListSets.create;

  regnil := 1;
end;

initialization
  setup;

finalization
  teardown;
end.
