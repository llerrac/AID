unit aid_database_ib;
(*
  /// <header>
  /// <name> 	 aid_database_ib		</name>
  /// <author> ajc alex carrell </author>
  /// <description> Delphi 6 ib components interface to taiddatabaselifetime
  ///
  /// </description>
  /// <modified> 	 modified	</modified>
  /// </header>
*)
interface

uses
    SysUtils, Classes, IBDatabase, DB, ibsql, IBScript,
    ibquery,IBStoredProc, crIBQry, aidDatbaseLifetime;

    //ib
procedure LookUpDbTrans(name : string; var Database : TcustomConnection;var transaction : TIBtransaction;tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; qry : Tibsql;tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; qry : Tibquery;tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TDataset;tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIBtransaction;tranname : string='') ;overload;
procedure LookUpDbTrans(name : string; ds : TIBStoredProc;tranname : string='') ;overload;
//cr
procedure LookUpDbTrans(name : string; ds : TcrIBQuery; tranname : string='') ;overload;
//
procedure CheckComponent(dbname : string;Transactionname : string;comp : TObject);

implementation

uses IBCustomDataSet,IB_Script
;

function CastToTIBtransaction(ject : Tobject) : TIBtransaction;
begin
  result := nil;
  if ject is TIBtransaction then
    result := ject as TIBtransaction
  else
    exception.Create('Object is not TIBtransaction, name of object - ' + ject.classname );
end;

//Tibdatabase
function CastToTibdatabase(ject : Tobject) : Tibdatabase;
begin
  result := nil;
  if ject is Tibdatabase then
    result := ject as Tibdatabase
  else
    exception.Create('Object is not Tibdatabase, name of object - ' + ject.classname );
end;

procedure CheckComponent(dbname : string;Transactionname : string;comp : TObject);
begin
  try
    //if statement to handle no overloaded version of procedure available.
    if comp is TIBSQL then
      LookUpDbTrans(dbname,comp as TIBSQL,Transactionname)
    else if comp is TIBTransaction then
      LookUpDbTrans(dbname,comp as TIBTransaction,Transactionname)
    else if comp is TIBStoredProc then
      LookUpDbTrans(dbname,comp as TIBStoredProc,Transactionname)
    else if comp is Tibquery then
      LookUpDbTrans(dbname,comp as Tibquery,Transactionname)
    else if comp is Tdataset then
      LookUpDbTrans(dbname,comp as Tdataset,Transactionname);

    //everything else could be any Tcomponent descendent!



  except
    on e :exception do
    begin
      e.message := 'No DB component found : '+e.message;
      raise;
    end;
  end;


end;

function CastToTcustomConnection(ject : Tobject) : TcustomConnection;
begin
  result := nil;
  if ject is TcustomConnection then
    result := ject as TcustomConnection
  else
    exception.Create('database connection is not TcustomConnection, name of connection - ' + ject.classname);
end;


procedure LookUpDbTrans(name: string; var Database: TcustomConnection; var transaction: TIBtransaction;tranname : string='');
begin
  if tranname = '' then
    tranname := name;

  database    := CastToTcustomConnection(TLiveDatabaseRegistry.Instance.Database[name]);
  transaction := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;

procedure LookUpDbTrans(name: string;ds: TDataset;tranname : string='');
begin
  if tranname = '' then
    tranname := name;

  if ds is TIBCustomDataSet then
  begin //if ds.database is Tibdatabase then
    TIBCustomDataSet(ds).database    := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
    TIBCustomDataSet(ds).transaction := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
  end;
end;

procedure LookUpDbTrans(name: string; qry: Tibsql;tranname : string='');
begin
  if tranname = '' then
    tranname := name;

  qry.database    := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
  qry.transaction := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;


procedure LookUpDbTrans(name : string; ds : TIBtransaction;tranname : string='') ;
begin
  ds.defaultdatabase := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
end;


procedure LookUpDbTrans(name : string; ds : TIBStoredProc;tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.Database       := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.Transaction    := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;

procedure LookUpDbTrans(name: string;qry: Tibquery;tranname : string='');
begin
  if tranname = '' then
    tranname := name;

  qry.database    := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
  qry.transaction := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;


procedure LookUpDbTrans(name : string; ds : TcrIBQuery; tranname : string='') ;
begin
  if tranname = '' then
    tranname := name;

  ds.database       := CastToTibdatabase(TLiveDatabaseRegistry.Instance.Database[name]);
  ds.Transaction    := CastToTIBtransaction(TLiveDatabaseRegistry.Instance.ibTransaction[tranname]);
end;





end.
