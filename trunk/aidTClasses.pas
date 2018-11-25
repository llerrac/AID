unit aidTClasses;
(**************************************************************************************************
  Name        :
  Author      : Alex Carrell (ajc)
  Description : Tclasses specific to Bobst. Generic classes and interface types
  Note        :

  Modified    : 27 March 2007 Created
**************************************************************************************************)

interface
  uses classes;
//type
//IaidDataList
{
  IaidDataList = interface(IInterface)
    procedure AddList(list : Tstrings; listname : string; ListRefresher : TBRefreshlist);
    function  getList(listname : string) : Tstrings;
    function  GetSet(listname: string): tbListSet;
    procedure Refresh(listname : string);overload;
    procedure Refresh;overload;
    function  setList(listname : string) : Tstrings;
    procedure Clear;
  end;
}
implementation
//     guid
end.
