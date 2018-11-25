unit aid_database_ibo;

              /// <header>
              /// <name> 			</name>
              /// <author> author       </author>
              /// <description> description
              ///
              /// </description>
              /// <modified> 	 modified	</modified>
              /// </header>
interface
uses
  SysUtils, Classes, DB,
  IB_Components,IBODataset, IB_Access,aidDatbaseLifetime,IB_Script;

//ibo
procedure LookUpDbTrans(name : string; ds : TIB_Query; tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIB_Cursor; tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIB_DSQL; tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TiboUpdateSql; tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIBoStoredProc; tranname : string='') ;overload;
procedure LookUpDbTrans(name: string;   ds: TIB_Script; tranname: string);overload;
//procedure LookUpDbTrans(name: string;   ds: TIB_Script; tranname: string);overload;

//class procedure LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;overload;
//cr
//procedure LookUpDbTrans(name : string; ds : TcrIBQuery; tranname : string='') ;overload;

//
procedure LookUpDbTrans(dbname: string; Database: TIB_Connection; tranname : string='');overload;

//
procedure CheckComponent(dbname : string;Transactionname : string;comp : TObject);
//

implementation

function CastToTIBODatabase(ject : Tobject) : TIBODatabase;
begin
  result := nil;
  if ject is TIBODatabase then
    result := ject as TIBODatabase
  else
    exception.Create('Object is not TIBODatabase, name of object - ' + ject.classname );
end;


function CastToTIB_Connection(ject : Tobject) : TIB_Connection;
begin
  if ject is TIB_Connection then
    result := ject as TIB_Connection
  else
    raise exception.Create('Object is not TIB_Connection, name of object - ' + ject.classname );
end;

function CastToIBOTransaction(ject : Tobject) : TIBOTransaction;
begin
  result := nil;
  if ject is TIBOTransaction then
    result := ject as TIBOTransaction
  else
    exception.Create('Object is not IBOTransaction, name of object - ' + ject.classname );
end;

//TIB_Transaction
function CastToTIB_Transaction(ject : Tobject; default : TIB_Transaction = nil) : TIB_Transaction;
begin
  result := nil;
  if ject is TIB_Transaction then
    result := ject as TIB_Transaction
  else if assigned(default) then
    result := default
  else if assigned(ject) then
    exception.Create('CastToTIB_Transaction : Object is not TIB_Transaction, name of object - ' + ject.classname )
  else
    exception.Create('CastToTIB_Transaction : Object is nil' + ject.classname )
end;

function CastToTIBOQuery(ject : Tobject) : TIBOQuery;
begin
  result := nil;
  if ject is TIBOQuery then
    result := ject as TIBOQuery
  else
    exception.Create('Object is not TIBOQuery, name of object - ' + ject.classname );
end;

procedure CheckComponent(dbname : string;Transactionname : string;comp : TObject);
begin
  try
    //if statement to handle no overloaded version of procedure available.
    if comp is TIBOQuery then
      LookUpDbTrans(dbname,comp as TIBOQuery,Transactionname)
    else if comp is TiboUpdateSql then
      LookUpDbTrans(dbname,comp as TiboUpdateSql,Transactionname)
    else if comp is TIB_Cursor then
     LookUpDbTrans(dbname,comp as TIB_Cursor,Transactionname)
    else if comp is TIB_DSQL then
      LookUpDbTrans(dbname,comp as TIB_DSQL,Transactionname)

    else if comp is TIBoStoredProc then
      LookUpDbTrans(dbname,comp as TIBoStoredProc,Transactionname)
    else if comp is TIB_Query then
      LookUpDbTrans(dbname,comp as TIB_Query,Transactionname)
//    else if comp is TIB_Connection then
    //everything else could be any Tcomponent descendent!

  except
    on e :exception do
    begin
      e.message := 'No DB component found : '+e.message;
      raise;
    end;
  end;
end;

procedure LookUpDbTrans(dbname: string; Database: TIB_Connection; tranname : string);
var
  templateDatabase : TIB_Connection;
begin
  if tranname = '' then
    tranname := dbname;

  templateDatabase    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[dbname]);
  Database.DatabaseName := templateDatabase.DatabaseName;
  Database.Username     := templateDatabase.Username;
  Database.Password     := templateDatabase.Password;
end;

procedure LookUpDbTrans(name : string; ds : TiboUpdateSql; tranname : string='') ;
begin
{
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
}
end;

procedure LookUpDbTrans(name : string; ds : TIB_Query; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;
  if ds.active then
    ds.Close;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;


procedure LookUpDbTrans(name : string; ds : TIBOQuery; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;
  if ds.active then
    ds.Close;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname],ds.IB_Connection.DefaultTransaction);
end;



procedure LookUpDbTrans(name : string; ds : TIBoStoredProc; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;


procedure LookUpDbTrans(name : string; ds : TIB_Cursor;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;

//IB_DSQL;
procedure LookUpDbTrans(name : string; ds : TIB_DSQL;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
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

procedure LookUpDbTrans(name: string; ds: TIB_Script; tranname: string);
begin
  if tranname = '' then
    tranname := name;

  ds.IB_Connection    := CastToTIB_Connection(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.ib_transaction   := CastToTIB_Transaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;


end.
