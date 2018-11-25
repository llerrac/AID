unit aidDatbaseLifetime;

{ ------------------------------------------------------------------------------------------------------------
  Name        : d_tDatbaseLifetime
  Author      : Alex carrell
  Description : Database abstraction.

  Modified    :
  AJC       : initial version
  2009Nov06   : another class type added
  2009nov06 : adding overrides for default database.
  22Jan2007 : placed centrally in aid.
  17Oct2008 : (boms build 64)
  Transaction look ups changed to handle dynamic loading of DB.
  Addition of TIBO* classes to assignment code
  NOTE, this unit must be in the INTERFACE uses clause of used, it relies on initilialization/finalization code.

  ------------------------------------------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes, DB, aidtsimpleDict;

type
  TCheckDBComponent = procedure(dbname: string; Transactionname: string; comp: TObject);
  TCheckDBComponents = Array of TCheckDBComponent;

  // TCheckDBComponent   = procedure(dbname : string;Transactionname : string;comp : TObject);

  // class that test applications register database(s) so that code can link to databases etc without
  // relying on extant application code.
  TLiveDatabaseRegistry = class(tsimpleDictionary)
    // to do: remove reference to specific classes of connection,query. So that the different connection,
    // database engines are registered and resolved, rather than straight assignments.
  private
    FCheckers: TCheckDBComponents;
    constructor create; reintroduce;
    function getDatabase(keyname: string): TObject;

    function getIbTransaction(keyname: string): TObject;

  public
    class function Instance: TLiveDatabaseRegistry;
    function RegisterDatabase(lookupkey, Databasename: string; Database: Tcomponent): integer;
    function RegisterTransaction(lookupkey, transtype: string; trans: Tcomponent): integer;
    function unregisterTransaction(Transactionname: string): integer;
    function unregisterDataBase(Databasename: string): integer;

    class function BomsDatabasename: string;
    procedure RegisterChecker(value: TCheckDBComponent);

    property Database[key: string]: TObject read getDatabase;
    property ibTransaction[key: string]: TObject read getIbTransaction;
    property Checkers: TCheckDBComponents read FCheckers;
  end;



procedure AssignDatabaseToComponents(owner: Tcomponent; dbname: string; Transactionname: string; checker: TCheckDBComponent= nil); overload;
procedure AssignDatabaseToComponents(owner: Tcomponent; dbname: string = ''; checker: TCheckDBComponent = nil); overload; // loop components and assign a registered database
procedure AssignDatabaseToComponents(dbname: string; owner: TObject; checker: TCheckDBComponent); overload;
function  AssignDatabaseDetails(target: Tcomponent; dbname: string = ''): Boolean;
//
procedure RegisetrDefaultDatabaseName(dbname: string; transName: string);
procedure RegisterDatabase(Databasename: string; Database: Tcomponent; transName: string = ''; transaction: Tcomponent = nil);
procedure unregisterDataBase(Databasename: string);
function  RegisterTransaction(transName: string; transaction: Tcomponent): integer;
function  unregisterTransaction(transName: string; transaction: Tcomponent): integer;
//
procedure RegisterChecker(checker: TCheckDBComponent);
//
procedure SetDefaultTransaction(Transactionname: string);
//

resourcestring
  c_IBOBomsDatabase = 'ibobomsdb'; // nb kept same as u_tBOMKernel. ibobomsDbName

implementation

var
  regnil              : integer = 0;
  regcreatcount       : integer = 0;
  DefaultDatabaseName : string = 'bomsdb';

resourcestring
  c_BomsDatabase = 'BOMS';

// *****************UNIT LOCAL*****************

var
  _current_transaction      : string;
// ****GLOBAL METHODS*****************************************************************************************/
procedure RegisetrDefaultDatabaseName(dbname: string; transName: string);
begin
  DefaultDatabaseName := dbname;
end;

procedure RegisterDatabase(Databasename: string; Database: Tcomponent;
                            transName: string = ''; transaction: Tcomponent = nil);
begin
  TLiveDatabaseRegistry.Instance.RegisterDatabase(Databasename, 'DATABASE', Database);
  if assigned(transaction) then
    TLiveDatabaseRegistry.Instance.RegisterTransaction(transName, 'TRANSACTIONS', transaction)
end;

procedure unregisterDataBase(Databasename: string);
begin
  TLiveDatabaseRegistry.Instance.unregisterDataBase(Databasename);
end;

procedure SetDefaultTransaction(Transactionname: string);
begin
  _current_transaction := Transactionname;
end;

function RegisterTransaction(transName: string;
  transaction: Tcomponent): integer;
begin
  result := -1;
  if assigned(transaction) then
    result := TLiveDatabaseRegistry.Instance.RegisterTransaction(transName, 'TRANSACTIONS', transaction);
end;

function unregisterTransaction(transName: string;
  transaction: Tcomponent): integer;
begin
  result := -1;
  if transName <> '' then
    result := TLiveDatabaseRegistry.Instance.unregisterTransaction(transName);
end;

procedure AssignDatabaseToComponents(owner: Tcomponent; dbname: string; Transactionname: string; checker: TCheckDBComponent= nil);
var
  regIndex : integer;
  //breakout: Boolean; -- the depth of the recursion may go too deep. I had a breakout, but have since been looking for deep recursion.
  procedure internalAssign(owner: Tcomponent; dbname: string; Transactionname: string; checker: TCheckDBComponent);
  var
    index: integer;
  begin
    if assigned(checker) then
    begin
      checker(dbname, Transactionname, owner);

      for index := 0 to owner.Componentcount - 1 do
      begin
        AssignDatabaseToComponents(owner.Components[index], dbname, Transactionname, checker);
      end;
    end;
  end;
begin
  //breakout := false;
  if dbname = '' then
    dbname := TLiveDatabaseRegistry.BomsDatabasename;
  //leave Transactionname to handled by checker
  if not assigned(checker) then
  for regIndex := low(TLiveDatabaseRegistry.Instance.Checkers) to
                  high(TLiveDatabaseRegistry.Instance.Checkers) do
  begin
    checker := TLiveDatabaseRegistry.Instance.Checkers[regIndex];

    internalAssign(owner, dbname, Transactionname, checker);
  end
  else
    internalAssign(owner, dbname, Transactionname, checker );
end;

procedure AssignDatabaseToComponents(owner: Tcomponent; dbname: string = '';
  checker: TCheckDBComponent = nil);
var
  regIndex: integer;

begin
  if dbname = '' then
    dbname := TLiveDatabaseRegistry.BomsDatabasename;
  for regIndex := low(TLiveDatabaseRegistry.Instance.Checkers) to high
    (TLiveDatabaseRegistry.Instance.Checkers) do
  begin
    checker := TLiveDatabaseRegistry.Instance.Checkers[regIndex];
    AssignDatabaseToComponents(dbname, owner, checker);
  end;
end;

procedure AssignDatabaseToComponents(dbname: string; owner: TObject;
  checker: TCheckDBComponent);
var
  index: integer;
begin
  if dbname = '' then
    dbname := TLiveDatabaseRegistry.BomsDatabasename;

  checker(dbname, _current_transaction, owner);
  if (owner is Tcomponent) then
    for index := 0 to (owner as Tcomponent).Componentcount - 1 do
    begin
      AssignDatabaseToComponents(dbname,
        (owner as Tcomponent).Components[index], checker);
    end;
end;

function AssignDatabaseDetails(target: Tcomponent; dbname: string = ''): Boolean;
var
  regIndex: integer;
begin
  result := false;
  if dbname = '' then
    dbname := TLiveDatabaseRegistry.BomsDatabasename;

  for regIndex := low(TLiveDatabaseRegistry.Instance.Checkers) to high
    (TLiveDatabaseRegistry.Instance.Checkers) do
  begin
    // TLiveDatabaseRegistry.Instance.Checkers[regIndex](dbname,'',target);
  end;

end;

// ****GLOBAL classes*****************************************************************************************/

// *************************************************************************************************//
// TLiveDatabaseRegistry
// *************************************************************************************************//
// singleton instance
var
  DBreg: TLiveDatabaseRegistry = nil;

constructor TLiveDatabaseRegistry.create;
begin
  inherited;
  inc(regcreatcount);
end;

function TLiveDatabaseRegistry.getDatabase(keyname: string): TObject;
var
  data: pointer;
begin
  data := nil;

  if exists(keyname, data) then
    result := TObject(data)
  else
    result := nil;
end;

function TLiveDatabaseRegistry.getIbTransaction(keyname: string): TObject;
var
  data: pointer;
begin

  data := nil;

  if exists(keyname + '_TRAN', data) then
  begin
    result := TObject(data)
  end
  else
    result := nil;
end;

class function TLiveDatabaseRegistry.Instance: TLiveDatabaseRegistry;
begin
  if not assigned(DBreg) then
    DBreg := TLiveDatabaseRegistry.create;

  result := DBreg;
end;

function TLiveDatabaseRegistry.RegisterDatabase(lookupkey,
  Databasename: string; Database: Tcomponent): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey, pointer(Database));
  result := indexof(lookupkey);
end;

function TLiveDatabaseRegistry.unregisterDataBase(Databasename: string)
  : integer;
begin
  result := deleteKey(Databasename);
end;

function TLiveDatabaseRegistry.RegisterTransaction(lookupkey,
  transtype: string; trans: Tcomponent): integer;
begin
  if lookupkey <> '' then
    exists(lookupkey + '_TRAN', pointer(trans));
  result := indexof(lookupkey);
end;

function TLiveDatabaseRegistry.unregisterTransaction(Transactionname: string)
  : integer;
begin
  result := deleteKey(Transactionname + '_TRAN'); // ,pointer(trans));
end;

class function TLiveDatabaseRegistry.BomsDatabasename: string;
begin
  result := DefaultDatabaseName;
end;

(* ********************************************************************************************
  UNIT local
  ******************************************************************************************** *)

procedure teardown;
begin
  _current_transaction := '';
  if assigned(DBreg) then
    DBreg.free;
end;

procedure setup;
begin
  _current_transaction     := '';
  DBreg                    := nil;
  
  regnil := 1;
end;

procedure TLiveDatabaseRegistry.RegisterChecker(value: TCheckDBComponent);
begin

  setLength(FCheckers, high(FCheckers) + 2);

  FCheckers[ high(FCheckers)] := value;
end;

procedure RegisterChecker(checker: TCheckDBComponent);
begin
  TLiveDatabaseRegistry.Instance.RegisterChecker(checker);
end;

initialization

setup;

finalization

teardown;

end.
