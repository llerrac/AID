unit u_spiderSql_fb;
(**************************************************************************************************
  Name        :
  Author      : Alex Carrell (ajc)
  Description :
  Note        :
  Modified    : 22 March 2007 Created
**************************************************************************************************)


interface

uses sysutils,db;
resourcestring
  //sql Statements

  //Lookup of Tensor Mismatches
  rs_MisMatchTasksLookup_sql = 'SELECT KEY_LK FROM LOOKUPS WHERE GROUP_LK = ''EMPTKC''';
//  rs_MisMatchTasksLookup_DEFAULTS = 'Sick,U,UL,US,X,Y4,GDN, Comp, Hols, Med, M and SD    FOR LOOKUPS.GROUP_LK = EMPTKC
// based on RESBAS values


  rs_MisMatchTasksInsert_sql = 'INSERT INTO TENSORMISMATCH '
                              + ' (TIMEDELTA,ENTRYTYPE,EMPLOYEECODE,DATEOFENTRY) '
                              + ' VALUES (:TIMEDELTA,:ENTRYTYPE,:EMPLOYEECODE,:DATEOFENTRY) ';
  rs_MisMatchTasksTestSel_sql = 'SELECT * FROM TENSORMISMATCH '
                              + ' WHERE TIMEDELTA = :TIMEDELTA '
                              + ' AND  ENTRYTYPE = :ENTRYTYPE '
                              + ' AND  EMPLOYEECODE = :EMPLOYEECODE '
                              + ' AND  DATEOFENTRY  = :DATEOFENTRY ';



  rs_MisMatchTasks_name      = 'TENSORMISMATCH';
resourcestring
//fields for Tensor Mismatch Tasks - listed in field order

  rs_sf_tmt_TimeDelta   = 'TIMEDELTA';
  rs_sf_tmt_entryType   = 'ENTRYTYPE';
  rs_sf_tmt_EmployeeCode = 'EMPLOYEECODE';
  rs_sf_tmt_DateOfEntry  = 'DATEOFENTRY';

//display names for Tensor Mismatch Task
  rs_dn_tmt_TimeDelta = 'Length of Mismatch';
  rs_dn_tmt_entryType = 'Mismatch Function';
  rs_dn_tmt_EmployeeCode = 'Employee Code';
  rs_dn_tmt_DateOfEntry  = 'Date Of Mismatch';
const
  //Number of Fields for Tensor Mismatch Tasks
  c_fc_tmt = 4;

type


    Tsql_definitionRec = record name : string;dname : string;ft : TfieldType;size : integer;end;
    Tsql_definition = array of Tsql_definitionRec;

  //tmt SQL field description array
    Tsql_ft_tmt = array [0..4] of Tsql_definitionRec;
var
  //rather than a static but dynamically filled array, the whole thing could be static, but that cannot use resourcestring
  sql_ft_tmt : Tsql_ft_tmt;

  //shortcut with range check into sql array
  function sql_tmt(index : integer) : Tsql_definitionRec;
  //SqlFieldType : fieldtype to fieldclass function
  function SqlFieldType(value : TfieldType) : TFieldClass;
implementation

procedure makeRecord(var arec : Tsql_definitionRec; vals : Array of const);
begin
  arec.name   := String(vals[0].VAnsiString);
  arec.dname  := String(vals[1].VAnsiString);
  arec.ft     := TfieldType(vals[2].VINteger);
  arec.size   := vals[3].Vinteger;
end;

procedure FilltmtArray;
begin
  makeRecord(sql_ft_tmt[0],[rs_sf_tmt_TimeDelta,rs_dn_tmt_TimeDelta,ord(ftDatetime),0]);
  makeRecord(sql_ft_tmt[1],[rs_sf_tmt_entryType,rs_dn_tmt_entryType,ord(ftString),10]);
  makeRecord(sql_ft_tmt[2],[rs_sf_tmt_EmployeeCode,rs_dn_tmt_EmployeeCode,ord(ftString),10]);
  makeRecord(sql_ft_tmt[3],[rs_sf_tmt_DateOfEntry,rs_dn_tmt_DateOfEntry,ord(ftDatetime),0]);
end;

function SqlFieldType(value : TfieldType) : TFieldClass;
begin
  result := DefaultFieldClasses[value];
end;

function sql_tmt(index : integer) : Tsql_definitionRec;
begin
  if (index > -1) and (index <= c_fc_tmt) then
    result := sql_ft_tmt[index]
  else
    Exception.create('Range Error, this table does not contain ' +inttostr(index) + ' fields');
end;

initialization
  FilltmtArray;
end.

