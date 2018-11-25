unit uaid_Lookups;

(*******************************************************************************
created by    :alex carrell (ajc)
created on    : 2011 JUne
Purpose       : base class for plugin data modules.
              -basically, a lot of teh software uses lookups requiring data. IN general, it does not matter where this data is, as long as it exists.
              Currently though its all in d_bom.pas. The thought is to abstract the requests for lookups, then provide a mechanism for providers of lookups
              to register the lookups the provide in a central location/class. The lookups as placed in a datamodule that implements the interface provided here.
              IAidSharedLookups.
              Secondly a system to register, resolve, and reply to requests.
              This is encapsulated by TaidSLDataRegsitry (sl = shared lookup)

              differrent data modules could be used to register lookups.


Comments      : version 0.1 9 June 2011
uaid_Lookups


*******************************************************************************)
interface
  uses SysUtils, classes, aidtsimpleDict, db;

const
  IIAidSharedLookups: Tguid = '{95E2C185-82C4-4B11-B86F-5392F2F71261}';

type
  TSlResultFlag  = (tslrfUnknown,tslrfSuccess,tslrfUnregisteredSL,tslrfUnregisteredLookup,tslrfNoDatasource,tslrfLookupNotConfigured,tslrfLookupMaintainanceNotConfigured);

  TRequireLookup = procedure(key : string;id : integer; AbRefreshOnly: Boolean = false) of object;
  TRefreshLookup = procedure(key : string;id : integer) of object;
  IAidSharedLookups = interface(IInterface)
    ['{95E2C185-82C4-4B11-B86F-5392F2F71261}']//[IIAidSharedLookups] //
    procedure RequireLookup (key : string;id : integer; AbRefreshOnly: Boolean = false);stdcall;overload;
    procedure RefreshLookup (key : string;id : integer);stdcall;overload;
    function  AssignLookup(key : string;id : integer;ds : TDataSource) : TSlResultFlag;stdcall;overload;
    function  MaintainLookup(key : string;id : integer) : TSlResultFlag;stdcall;overload;


    procedure RequireLookup (key : string;id : string; AbRefreshOnly: Boolean = false);stdcall;overload;
    procedure RefreshLookup (key : string;id : string);stdcall;overload;
    function  AssignLookup(key : string;id : string;ds : TDataSource) : TSlResultFlag;overload;stdcall;
    function  MaintainLookup(key : string;id : string) : TSlResultFlag;overload;stdcall;
  end;


  TaidSLDataRegsitry = class(TSimpleDictionary)
  private
    function getSLLookup(key: string): IAidSharedLookups;
  protected
    constructor create;reintroduce;
  public
    class function Instance : TaidSLDataRegsitry;
    function  unregisterSL(Databasename : string) : integer;
    function  registerSL(lookupkey : string;SL : IAidSharedLookups) : integer;
    //
    function RequireLookup(key : string;id : integer)     : TSlResultFlag ;overload;
    function RequireLookup(key : string;id : string)      : TSlResultFlag ;overload;
    function RefreshLookup(key : string;id : integer)     : TSlResultFlag ;overload;
    function RefreshLookup(key : string;id : string)      : TSlResultFlag ;overload;
    function AssignLookup(key : string;id : integer;ds : TDataSource)      : TSlResultFlag;overload;
    function AssignLookup(key : string;id : string;ds : TDataSource)       : TSlResultFlag;overload;
    //maintenance
    function  MaintainLookup(key : string;id : integer) : TSlResultFlag;overload;
    //
    property SLLookup[key : string]      : IAidSharedLookups read getSLLookup;
  end;

  function SLRequireLookup(key : string;id : integer)     : TSlResultFlag ;overload;
  function SLRequireLookup(key : string;id : string)      : TSlResultFlag ;overload;
  function SLRefreshLookup(key : string;id : integer)     : TSlResultFlag ;overload;
  function SLRefreshLookup(key : string;id : string)      : TSlResultFlag ;overload;
  function SLAssignLookup(key : string;id : integer;ds : TDataSource)       : TSlResultFlag;overload;
  function SLAssignLookup(key : string;id : string; ds : TDataSource)       : TSlResultFlag;overload;
  function SLRegister(lookupkey : string;SL : IAidSharedLookups) : integer;
  function SLReg         : TaidSLDataRegsitry;

implementation
var
  internalSLReg         : TaidSLDataRegsitry;

(**************************************************************************************************)
{ GLOBAL }
(**************************************************************************************************)
function SLRequireLookup(key : string;id : integer)      : TSlResultFlag ;
begin
  result := TaidSLDataRegsitry.Instance.RequireLookup(key,id);
end;

function SLRequireLookup(key : string;id : string)      : TSlResultFlag ;
begin
  result := TaidSLDataRegsitry.Instance.RequireLookup(key,id);
end;

function SLRefreshLookup(key : string;id : integer)      : TSlResultFlag ;
begin
  result := TaidSLDataRegsitry.Instance.RefreshLookup(key,id);
end;

function SLRefreshLookup(key : string;id : string)      : TSlResultFlag ;
begin
  result := TaidSLDataRegsitry.Instance.RefreshLookup(key,id);
end;

function SLAssignLookup(key : string;id : integer;ds : TDataSource)       : TSlResultFlag;
begin
  result := TaidSLDataRegsitry.Instance.AssignLookup(key,id,ds);
end;

function SLAssignLookup(key : string;id : string; ds : TDataSource)       : TSlResultFlag;
begin
  result := TaidSLDataRegsitry.Instance.AssignLookup(key,id,ds);
end;

function SLRegister(lookupkey : string;SL : IAidSharedLookups) : integer;
begin
  result := TaidSLDataRegsitry.Instance.registerSL(lookupkey,SL);
end;
(**************************************************************************************************)
{UNIT}
(**************************************************************************************************)

{ TaidSLDataRegsitry }

function TaidSLDataRegsitry.AssignLookup(key: string; id: integer;
  ds: TDataSource): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  if not assigned(ds) then
  begin
    result := tslrfNoDatasource;
    exit;
  end;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      result := Isl.AssignLookup(key,id,ds);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.AssignLookup(key, id: string;
  ds: TDataSource): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  if not assigned(ds) then
  begin
    result := tslrfNoDatasource;
    exit;
  end;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      result := Isl.AssignLookup(key,id,ds);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

constructor TaidSLDataRegsitry.create;
begin
  inherited;
end;


function TaidSLDataRegsitry.getSLLookup(key: string): IAidSharedLookups;
var
  data: pointer;
begin
  data := nil;

  if exists(key,data) then
    result := IAidSharedLookups(data)
  else
    result := nil;
end;



class function TaidSLDataRegsitry.Instance: TaidSLDataRegsitry;
begin
  if not assigned(InternalSLReg) then
    InternalSLReg := TaidSLDataRegsitry.create;

  result := InternalSLReg;
end;

function TaidSLDataRegsitry.RefreshLookup(key: string;
  id: integer): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  result := tslrfSuccess;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      Isl.RefreshLookup(key,id);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.MaintainLookup(key: string; id: integer): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  result := tslrfSuccess;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      Isl.MaintainLookup(key,id);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.RefreshLookup(key, id: string): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  result := tslrfSuccess;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      Isl.RefreshLookup(key,id);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.registerSL(lookupkey : string;SL : IAidSharedLookups) : integer;
begin
  if lookupkey <> '' then
    exists(lookupkey,pointer(sl));
  result := indexof(lookupkey);
end;

function TaidSLDataRegsitry.RequireLookup(key: string;
  id: integer): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  result := tslrfSuccess;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      Isl.RequireLookup(key,id);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.RequireLookup(key, id: string): TSlResultFlag;
var
  Isl : IAidSharedLookups;
begin
  result := tslrfSuccess;
  Isl := SLLookup[key];
  if assigned(Isl) then
  begin
    try
      Isl.RequireLookup(key,id);
    except
      result := tslrfUnregisteredLookup;
    end;
  end
  else
    result := tslrfUnregisteredSL;
end;

function TaidSLDataRegsitry.unregisterSL(Databasename: string): integer;
begin
   result := 0;
end;

function SLReg : TaidSLDataRegsitry;
begin
  result :=TaidSLDataRegsitry.Instance;
end;

procedure TearDown;
begin
  if assigned(internalSlReg) then
    internalSlReg.free;
end;

procedure SetUp;
begin
  internalSlReg := nil;
end;

initialization
  setup;

finalization
  teardown;

end.
