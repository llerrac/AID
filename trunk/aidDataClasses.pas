unit aidDataClasses;

(*******************************************************************************
created by    : alex carrell(ajc)
created on    : 2009nov09
Purpose       : data abstraction

Comments      :


*******************************************************************************)
interface
  uses classes,sysutils;

type

tdataN = class
private
  value : variant;
  vt    : Integer;//Variant type code
  fieldname : string;
    FEdited: boolean;
  procedure getValue(var destvalue : string);overload;
  procedure getValue(var destvalue : double);overload;
  procedure getValue(var destvalue : Tdatetime);overload;
  procedure getValue(var destvalue : longint);overload;
  procedure getValue(var destvalue : boolean);overload;

  procedure Setvalue(const newValue : variant);

  procedure SetEdited(const Value: boolean);
public
  constructor create;virtual;
  procedure clear;
  function  GetAsInteger: Longint; virtual;
  function  GetAsFloat: Double; virtual;
  function  GetAsString : string; virtual;
  function  GetAsDatetime  : Tdatetime;
  function  GetAsMemo : string;

  function  GetAsBool     : boolean;
  procedure setAsBool(valueb : boolean);

  procedure SetAsFloat(valuef : Double);virtual;
  procedure SetAsInteger(valuei : Longint);virtual;
  procedure SetAsString(values  : string);virtual;
  procedure SetAsDatetime(valued : Tdatetime);virtual;
  procedure setAsmemo(memo : string);

  property asinteger  : integer   read GetAsInteger   write SetAsInteger;
  property asstring   : string    read GetAsString    write SetAsString;
  property asdatetime : Tdatetime read GetAsDatetime  write SetAsDatetime;
  property asMemo     : string    read GetAsmemo      write setAsmemo;
  property asFloat    : double    read GetAsFloat     write setAsFloat;
  property asBoolean  : boolean   read GetAsBool      write setAsBool;

  property basevalue  : variant read value write Setvalue;
  property Edited     : boolean read FEdited write SetEdited;
end;

TdataClass = class(tstringlist)
public
  procedure AssignDeep(assigner : TdataClass);
  function  newDataN(fieldname : string) : TdataN;
  function  getDataN(value : string) : tdataN;
  procedure setDataN(value : string; data : tdataN) ;

  property  dataN[value : string] : tdataN read getDataN write setDataN; default;

end;

implementation
uses variants;

(****************************************************************************
{tdataN}
****************************************************************************)
constructor tdataN.create;
begin
  inherited;
  clear;

end;

procedure tdataN.clear;
begin
  value  := null;
  vt     := varNull;
end;

procedure tdataN.getValue(var destvalue : string);
begin
  case vt of
    varNull   : destvalue := '';
    varString : destvalue := VarToStr(value)
  else
    destvalue := VarToStr(value);
  end;
end;

procedure tdataN.getValue(var destvalue : double);
begin
  case vt of
    varNull   : destvalue := 0;
    varString :
                try
                  destvalue := strtodate(value)
                except
                  on e : EconvertError do
                    destvalue := 0;
                end;
  else
    destvalue := value;
  end;
end;

procedure tdataN.getValue(var destvalue : Tdatetime);
begin
  case vt of
    varNull   : destvalue := 0;
    varString :
                try
                  destvalue := strtodate(value)
                except
                  on e : EconvertError do
                    destvalue := 0;
                end;
  else
    destvalue := value;
  end;
end;


procedure tdataN.getValue(var destvalue : longint);
begin
  case vt of
    varNull   : destvalue := 0;
    varString :
                try
                  destvalue := strtoint(value)
                except
                  on e : EconvertError do
                    destvalue := 0;
                end;
  else
    destvalue := value;
  end;
end;


function  tdataN.GetAsFloat: Double;
begin
  getValue(result);
end;

function  tdataN.GetAsMemo : string;
begin
  getValue(result);
end;


function tdataN.GetAsInteger: Longint;
begin
  getValue(result);
end;

function  tdataN.GetAsString : string;
begin
  getValue(result);
end;

function  tdataN.GetAsDatetime  : Tdatetime;
begin
  getValue(result);
end;

procedure tdataN.SetAsDatetime(valued : Tdatetime);
begin
  vt    := varDate;
  value := valued;
  edited:= true;
end;

procedure tdataN.SetAsFloat(valuef: Double);
begin
  vt    := varDouble;
  value := valuef;
  edited:= true;
end;

procedure tdataN.SetAsInteger(valuei : Longint);
begin
  vt    := varInteger;
  value := valuei;
  edited:= true;
end;

procedure tdataN.SetAsString(values  : string);
begin
  vt    := varString;
  value := values;
  edited:= true;
end;

procedure tdataN.setAsmemo(memo : string);
begin
  vt    := varString;
  value := memo;
  edited:= true;
end;

(****************************************************************************
{TdataClass}
****************************************************************************)
Procedure TdataClass.AssignDeep(assigner : TdataClass);
var
  index : integer;
//  temp  : TdataN;
begin
  for index := 0 to assigner.count -1 do
  begin
    DataN[assigner.Strings[index]] := assigner.dataN[assigner.Strings[index]];
  end;
{
  for index := 0 to count -1 do
  begin
    if assigned(objects[index]) then
    begin
      objects[index].Free;
    end;
  end;
  clear;
  for index := 0 to assigner.count -1 do
  begin
    DataN[assigner.Strings[index]] := assigner.dataN[assigner.Strings[index]];
  end;
  }
end;

function  TdataClass.getDataN(value : string) : tdataN;
var
  index : integer;
begin
  index := indexof(value);
  if index < 0 then
  begin
    index := addobject(value,    newDataN(value));
  end;

  result := tdataN(objects[index]);
end;

function  TdataClass.newDataN(fieldname : string) : TdataN;
begin
  result := TdataN.create;
  result.fieldname := fieldname;
end;

procedure TdataClass.setDataN(value : string;data : tdataN) ;
var
  index : integer;
begin
  index := indexof(value);
  if index < 0 then
  begin
    index := addobject(value,    newDataN(value));
  end;

  tdataN(objects[index]).value  := data.value;
  tdataN(objects[index]).vt     := data.vt;
  tdataN(objects[index]).fieldname := data.fieldname;
end;

procedure tdataN.SetEdited(const Value: boolean);
begin
  FEdited := Value;
end;

function tdataN.GetAsBool: boolean;
begin
  getValue(result);
end;

procedure tdataN.setAsBool(valueb : boolean);
begin
  vt    := varString;
  value := valueb;
  edited:= true;
end;

procedure tdataN.getValue(var destvalue: boolean);
begin
  case vt of
    varNull     : destvalue := false;
    varString   :
                try
                  destvalue := value = 'T'
                except
                  on e : EconvertError do
                    destvalue := false;
                end;

    varBoolean : destvalue := value;
  else
    destvalue := false
  end;

end;

procedure tdataN.Setvalue(const newValue: variant);
begin
  value := newValue;
  vt    := vartype(newvalue); //VType;
end;

end.
