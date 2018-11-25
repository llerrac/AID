unit aidTsimpleDict;

{ ------------------------------------------------------------------------------------------------------------
  Name        : u_tsimpleDict
  Author      : Alex carrell
  Description : Very simple Dictionary Hash. At some point it ought to be made over to run on turbo power stDictionary class.
                Currently works using a tstrinlist which is slow
  Modified    :
    AJC       : initial version
    22Jan2007 : placed centrally in aid.
    ajc jan200 added deleteKey method

  -------------------------------------------------------------------------------------------------------------}

interface
uses
  sysutils,classes;

type
  TDataObject = class
    info : pointer;
    shortinfo : variant;
    key,value : string;
  end;

  TSimpleDictionary = class(Tstringlist)
  private
    function  AddKey(key,value : string;shortinfo : variant; info : pointer): integer;
    function  getDString(key: string): string;
    procedure SetDString(key: string; const Value: string);
                      //key,value : string; var shortinifo : variant;  var data : pointer);
    procedure UnpackKey(key,value : string; var shortinfo : variant;  var data : pointer);

    function  getDVariant(key: string) : variant;
    procedure SetDVariant(key: string; const Value: Variant);
    function  GetKey(index: integer): TDataObject;
    procedure setKey(index: integer; const Value: TDataObject);
  public
    //lifetime
    constructor create;
    destructor  destroy;override;
    //methods
    function  deleteKey(key : string) : integer;
    procedure Clear;override;
    function exists(key : string;var data: pointer) : boolean;
    property Keys[index : integer]          : TDataObject read GetKey write setKey;
    property KeyValue[key : string]         : string read getDString write SetDString;default;
    property KeyVariant[key : string]       : variant read getDVariant write SetDVariant;

  end;

  TBRefreshlist = procedure(list : Tstrings;name : string);
  //tbListSet
  // container class to hold information about item in tblistsets
  tbListSet = class
    fDoRefresh  : TBRefreshlist;
    FList       : Tstrings;
    Flistname   : string;
    procedure Refresh;
    property  doRefresh : TBRefreshlist read fDoRefresh write fDoRefresh;
  end;

  //TBListSets : lookup managing list system
  //given a list and a name it can refresh the list.

  TBListSets = class
    FLists  :  TStringlist;

    constructor create;
    destructor destroy;override;
    function  GetSet(listname: string):tbListSet;
    procedure Refresh(listname : string);overload;
    procedure Refresh;overload;
    procedure AddList(list : Tstrings; listname : string; ListRefresher : TBRefreshlist);
    function  getList(listname : string) : Tstrings;
    procedure Clear;

    property  List[listname : string] : Tstrings read getList;

  end;

resourcestring
  c_lkUserName      = 'username';
  c_lkPassword      = 'password';
  c_lkDatabaseName  = 'DatabaseName';
  c_lkPagesize      = 'PAGE_SIZE';
  r_FormCaption     = 'formcaption';
  r_databasename    = 'Databasename';

implementation
uses variants;

//*************************************************************************************************//
//        tsimpleDictionary
//*************************************************************************************************//

function tsimpleDictionary.AddKey(key, value: string; shortinfo : variant; info : pointer): integer;
var
  data : TdataObject;
begin
  result := -1;
  data        := TDataObject.create;
  try
    data.info   := info;
    data.key    := key;
    data.value  := value;
    data.shortinfo := shortinfo;
    result      := addobject(key,data);
    if result < count -1 then
    begin
      //add returns count. failing that it returns index of duplicate if sorted.
      data.free;
    end;
  except
    data.free;
  end
end;

procedure TSimpleDictionary.Clear;
//unlike tstringlist, this frees the objects as well.
//Variant values set to null
var
  index : integer;
begin
  for index := count -1 downto 0 do
    if assigned(objects[index]) then
    begin
      objects[index].free;
      objects[index] := nil;
    end;

  inherited;
end;


constructor tsimpleDictionary.create;
begin
  inherited;
  duplicates := dupIgnore;
end;

destructor tsimpleDictionary.destroy;
var
  index : integer;
begin
  for index := 0 to count -1 do
    if assigned(objects[index]) then
    begin
      objects[index].free;
      objects[index] := nil;
    end;
  inherited;
end;

function  tsimpleDictionary.deleteKey(key : string) : integer;
begin
  result := indexof(key);
  if result > 0 then
  begin
    delete(result);
  end;
end;

function tsimpleDictionary.exists(key: string; var data: pointer): boolean;
var
  value       : string;
  shortinfo   : variant;
begin
  result := indexof(key) > -1;
  if (not result) and (data <> nil) then
  begin
    AddKey(key,'',null,data);
    result := indexof(key) > -1;
  end
  else if result then //assign data
    UnpackKey(key,value,shortinfo,data);
end;

function tsimpleDictionary.getDString(key: string): string;
begin
  if indexof(key) > -1 then
  begin
     result := TDataObject(objects[indexof(key)]).value;
  end
  else
    result := '';
end;

function TSimpleDictionary.getDVariant(key: string): variant;
begin
  if indexof(key) > -1 then
    result := TDataObject(objects[indexof(key)]).shortinfo
  else
    result := Null;
end;

function TSimpleDictionary.GetKey(index: integer): TDataObject;
begin
  result := nil;
end;

procedure tsimpleDictionary.SetDString(key: string; const Value: string);
begin
  if indexof(key) > -1 then
  begin
     TDataObject(objects[indexof(key)]).value := value;
  end
  else
    AddKey(key,value,null,nil);
end;


procedure TSimpleDictionary.SetDVariant(key: string; const Value: Variant);
begin
  if indexof(key) > -1 then
    TDataObject(objects[indexof(key)]).shortinfo := value
  else
    AddKey(key,'',value,nil);
end;

procedure TSimpleDictionary.setKey(index: integer;const Value: TDataObject);
begin

end;

procedure tsimpleDictionary.UnpackKey(key,value : string; var shortinfo : variant;  var data : pointer);
var
  dataO : TdataObject;
begin
    dataO    := TDataObject(objects[indexof(key)]);
    data    := dataO.info;
    key     := dataO.key;
    shortinfo := dataO.shortinfo;
    value   := dataO.value;
end;

{ tbListSet }

procedure tbListSet.Refresh;
begin
  if assigned(fDoRefresh) then
      fDoRefresh(Flist,Flistname);
end;

{ TBListSets }

procedure TBListSets.AddList(list: Tstrings; listname: string;
  ListRefresher: TBRefreshlist);
var
  item : tbListSet;
begin
  If Assigned(getList(listname)) then
    exit; //already exists

  item := tbListSet.create;
  item.Flistname  := listname;
  item.doRefresh  := ListRefresher;
  item.FList      := list;
  flists.addobject(listname,item);
  if item.FList.count = 0 then
    Refresh(listname);// --not the best way to force initialisation.  
end;

procedure TBListSets.Clear;
var
  index : integer;
begin
  for index := 0 to flists.count -1 do
    if assigned(flists.Objects[index]) then
      flists.Objects[index].free;
end;

constructor TBListSets.create;
begin
  inherited;
  flists := Tstringlist.create;
end;

destructor TBListSets.destroy;
begin
  clear;
  flists.free;
  inherited;
end;

function TBListSets.getList(listname: string): Tstrings;
var
  item : tbListSet;
begin
  item := GetSet(listname);
  if assigned(item) then
    result := item.FList
  else
    result := nil;
end;

function TBListSets.GetSet(listname: string): tbListSet;
var
  index : integer;
begin
  index := flists.indexof(listname);
  if index > -1 then
    result := flists.objects[index] as tbListSet
  else
    result :=nil;
end;

procedure TBListSets.Refresh(listname: string);
var
  item : tbListSet;
begin
  item := GetSet(listname);
  if assigned(item) then
    item.Refresh;
end;

procedure TBListSets.Refresh;
var
  index : integer;
begin
  for index := 0 to Flists.count -1 do
    GetSet(Flists[index]).refresh;
end;

end.
