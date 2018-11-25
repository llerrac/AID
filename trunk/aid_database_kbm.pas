  unit aid_database_kbm;

interface

{$IFNDEF RTL200_UP}
uses classes,db, kbmMemTable,IBODataset,ibdatabase;

//function AsClientDataSet(HasOwner : boolean; ds : Tdataset;lookupname : string = '') : TkbmMemTable;overload;//loop owner components and create tkbmTable for query name=lookupname supplied
function AsClientDataSet(owner : Tcomponent; ds : Tdataset;lookupname : string = '') : TkbmMemTable;overload;//loop owner components and create tkbmTable for query name=lookupname supplied

function GetSqlQuery(owner : Tcomponent;sqry_name : string) : TkbmMemTable;overload;
function GetSqlQuery(owner : Tcomponent;sqry_name : string; ds : Tdatasource) : boolean;overload;
function AsClientDataSet(owner : Tcomponent; sql : string; lookupname : string;adatabase : Tibdatabase): TkbmMemTable; overload;
function AsClientDataSet(owner : Tcomponent; sql : string; lookupname : string;dbname : string): TkbmMemTable; overload;
function RefreshLookup(sql : string; lookupname : string;dbname : string): TkbmMemTable;Overload;
function RefreshLookup(ds : TIBOQuery; lookupname : string) : TkbmMemTable;Overload;
{$ENDIF}


implementation

{$IFNDEF RTL200_UP}
uses crIBQry,IBQuery,aidDatbaseLifetime,sysutils;


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
//function AsClientDataSet(HasOwner : boolean; ds : Tdataset;lookupname : string = '') : TkbmMemTable;overload;//loop owner components and create tkbmTable for query name=lookupname supplied


function AsClientDataSet(owner : Tcomponent; ds : Tdataset;lookupname : string) : TkbmMemTable;
begin
  result := lookupClientDataSet(owner, ds.name+lookupname+'_cds');

  if result = nil then
  begin
    if ds is TcrIBQuery then
      TcrIBQuery(ds).OptionsEx := [];

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


function AsClientDataSet(owner : Tcomponent; sql : string;lookupname : string;adatabase : Tibdatabase): TkbmMemTable; overload;
var
  query : TIBQuery;
begin
  query := TIBQuery.create(owner);
  try
    query.Database := adatabase;
    query.sql.text := sql;

    query.open;
    result := AsClientDataSet(owner, query,lookupname);
  finally
    query.Free;
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
{$ENDIF}


end.
