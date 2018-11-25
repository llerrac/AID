unit aidwlTypes;

{ valWireTypes
    Wireless stuff


  see
    dataCont.sql, valWireLookups }

interface

const
  CChgREMOVE  = 'R';
  CChgADD     = 'A';


type
  TLookupKey      = String[10];
type
  TDestinationDesc= String[50];
type
  TCableTypeKey   = String[ 4];
  TCableTypeDesc  = String[30];
  
type
  TGridCellComment= ShortString;



{ Cabling States  }
type
  TaidwlCablingState = (aidwlNoCabling, aidwlWIP, aidwlIssued, aidwlFinalised);
const
  CLoggableCablingStates  = [aidwlIssued, aidwlFinalised];
{ Cabling Styles  }
type
  TaidwlCablingStyle = (aidwlCabled, aidwlLoomed);

const // used by addtolog
  CLogRunout       = 'RO';
  CLogCableWire    = 'CW';
  CLogCable        = 'CC';
  CLogContractMast = 'CM';
  CLogContTerminals= 'CT';
  CLogContRoutes   = 'CR';
  CLogContLocations= 'LO';
  //
  CLogAddition     = 'A';
  CLogUpdate       = 'U';
  CLogDeletion     = 'D';

{ Cabling State }
function  CablingStateDesc(AsCablingState: string): string;
function  CablingStateOrd (AsCablingState: string): TaidwlCablingState;
function  CablingStateCode(AiState: TaidwlCablingState): string;
{ Cabling Style }
function  CablingStyleDesc(AsCablingStyle: string): string;
function  CablingStyleOrd (AsCablingStyle: string): TaidwlCablingStyle;
function  CablingStyleCode(AiStyle: TaidwlCablingStyle): string;
{ Logging }
function  LogContextDesc  (AsKey: string): string;
function  LogOperationDesc(AsKey: string): string;

implementation

uses
  SysUtils;

{ Cabling State }
const
  CaidwlCablingState     : Array[TaidwlCablingState] of Char
                        = ('N'   , 'W'  , 'I'     , 'F'    );
  CaidwlCablingStateDesc : Array[TaidwlCablingState] of string
                        = ('None', 'WIP', 'Issued', 'Final');
{ Cabling Style }
const
  CaidwlCablingStyle     : Array[TaidwlCablingStyle] of Char
                        = ('N'   , 'S');
  CaidwlCablingStyleDesc : Array[TaidwlCablingStyle] of string
                        = ('Cabled', 'Loom');

function  CablingStateDesc(AsCablingState: string): string;
var
  iK  : TaidwlCablingState;
begin
  Result:= AsCablingState;
  for iK:= Low(TaidwlCablingState) to High(TaidwlCablingState) do
    if CaidwlCablingState[iK] = AsCablingState then
    begin
      Result:= CaidwlCablingStateDesc[iK];
      Break;
    end;
end;


function  CablingStateOrd (AsCablingState: string): TaidwlCablingState;
var
  iK  : TaidwlCablingState;
begin
  Result:= aidwlNoCabling;
  for iK:= Low(TaidwlCablingState) to High(TaidwlCablingState) do
    if CaidwlCablingState[iK] = AsCablingState then
    begin
      Result:= iK;
      Break;
    end;
end;


function  CablingStateCode(AiState: TaidwlCablingState): string;
begin
  Result:= CaidwlCablingState[AiState];
end;


function LogContextDesc  (AsKey: string): string;
begin
  if      SameText(AsKey, CLogRunout)        then Result:= 'Runout'
  else if SameText(AsKey, CLogCableWire)     then Result:= 'CableWire'
  else if SameText(AsKey, CLogCable)         then Result:= 'Cable'
  else if SameText(AsKey, CLogContractMast)  then Result:= 'Contract'
  else if SameText(AsKey, CLogContTerminals) then Result:= 'Terminals'
  else if SameText(AsKey, CLogContRoutes)    then Result:= 'Routes'
  else if SameText(AsKey, CLogContLocations) then Result:= 'Locations'
  else    Result:= '';
end;


function LogOperationDesc(AsKey: string): string;
begin
  if      SameText(AsKey, CLogAddition) then Result:= 'Added'
  else if SameText(AsKey, CLogUpdate  ) then Result:= 'Updated'
  else if SameText(AsKey, CLogDeletion) then Result:= 'Deleted'
  else    Result:= '';
end;


function  CablingStyleCode(AiStyle: TaidwlCablingStyle): string;
begin
  Result:= CaidwlCablingStyle[AiStyle];
end;

function  CablingStyleDesc(AsCablingStyle: string): string;
begin
  Result:= CaidwlCablingStyleDesc[CablingStyleOrd(AsCablingStyle)];
end;

function  CablingStyleOrd (AsCablingStyle: string): TaidwlCablingStyle;
var
  iK  : TaidwlCablingStyle;
begin
  Result:= aidwlCabled;
  for iK:= Low(TaidwlCablingStyle) to High(TaidwlCablingStyle) do
    if CaidwlCablingStyle[iK] = AsCablingStyle then
    begin
      Result:= iK;
      Break;
    end;
end;






end.
