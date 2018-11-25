unit aidVCSUtil;

{ -------------------------------------------------------------------------------------------------
  Name        : aidVCSUtil
  Author      :
  Description :
  Note        :
  Modified    :
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Classes,
  { 3rd Party Units }
  { Application Units }
  bomTypes, aidTypes,
  crRTTIUtil,objChangeOrder;

type
    TaidOncreateCOS = procedure( aCOS : TaidChangeOrderStep) of object;

function AddPersistentAddition(AoChanges: TaidBOMChangeObject; AeContext: TaidCOChangeContext; AoNewPersistent: TPersistent;
            AsKey: string; AsParam: String = ''; AsIndex: String = ''; AiQuantity: TQuantity = 0; oncreate : TaidOncreateCOS = nil) : TaidChangeOrderStep;
function AddPersistentChanges(AoChanges: TaidBOMChangeObject; AeContext: TaidCOChangeContext; AoFromPersistent, AoToPersistent: TPersistent;
            AsFromKey, AsFromParam, AsFromIndex: String; AiFromQuantity: TQuantity;
            AsToKey  , AsToParam  , AsToIndex  : String; AiToQuantity  : TQuantity;
            AosExcludedProperties: TStrings = nil; oncreate : TaidOncreateCOS = nil): TaidChangeOrderStep;
function AddPersistentDeletion(AoChanges: TaidBOMChangeObject; AeContext: TaidCOChangeContext; AoDeletedPersistent: TPersistent;
            AsKey: string; AsParam: String = ''; AsIndex: String = ''; AiQuantity: Integer = 0;
            oncreate : TaidOncreateCOS = nil): TaidChangeOrderStep;
function AddPropertyValuesTo(AoChangeStep: TaidChangeOrderStep; AoPersistent: TPersistent; AeAction: TaidCOChangeAction): Boolean;


implementation

uses
  { Delphi Units }
  Variants, SysUtils,
  { 3rd Party Units }
  { Application Units }
  crUtil,
  TypInfo;

{ AddPropertyValuesTo
    Adds populated property values to the AoChangeStep.Changes property. }
function AddPropertyValuesTo(AoChangeStep: TaidChangeOrderStep; AoPersistent: TPersistent; AeAction: TaidCOChangeAction): Boolean;
var
  osProperties: TStringList;
  iProperty   : Integer;
  sPropName   : String;
  vProperty   : Variant;
  sPropValue  : String;
  ePropType   : TTypeKind;
  uChange     : TaidChangeOrderFieldItem;
begin
  Result:= False;
  osProperties:= TStringList.Create;
  try
    if RetrievePropertyNames(AoPersistent, osProperties) then
    begin
      for iProperty:= 0 to osProperties.Count-1 do
      begin
        sPropName:= osProperties.Strings[iProperty];
        ePropType:= PropType(AoPersistent, sPropName);
        { Ensure that we're only inspecting rudementary types. }
        if (not (ePropType in [tkUnknown, tkClass, tkMethod, tkArray, tkRecord, tkInterface, tkDynArray])) Then
        begin
          vProperty:= RetrievePropertyValue(AoPersistent, sPropName);

          if (not VarIsEmpty(vProperty)) and (not VarIsNull(vProperty)) Then
          begin
            sPropValue:= VariantAsString(vProperty);
            if not IsEmptyStr(sPropValue) then
            begin
              uChange:= AoChangeStep.AddPropertyChange();
              uChange.PropertyName:= sPropName;
              case AeAction of
                aidCOAdd    :
                begin
                  uChange.ToValue     := vProperty;
                  uChange.ToString    := sPropValue;
                  uChange.Textual     := #39+sPropname+#39+' set to: '+sPropValue;
                end;
                aidCODelete :
                begin
                  uChange.ToValue     := vProperty;
                  uChange.ToString    := sPropValue;
                  uChange.Textual     := #39+sPropname+#39+' was: '+sPropValue;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(osProperties)
  end;
end;

{ AddPersistentAddition }
function {TmodMasterBOM.}AddPersistentAddition(AoChanges: TaidBOMChangeObject; AeContext: TaidCOChangeContext; AoNewPersistent: TPersistent;
    AsKey: string; AsParam: String = ''; AsIndex: String = ''; AiQuantity: TQuantity = 0;
    oncreate : TaidOncreateCOS = nil): TaidChangeOrderStep;
begin
  Result:= nil;
  {}
  if Assigned(AoChanges) and Assigned(AoNewPersistent) then
  begin
    Result:= AoChanges.AddChange();
    Result.ChangeAction   := aidCOAdd;
    Result.ChangeContext  := AeContext;
    //
    Result.ChangeToKey     := AsKey;
    Result.ChangeToParam   := AsParam;
    Result.ChangeToIndex   := AsIndex;
    Result.ChangeToQty     := AiQuantity;

    // ~~~ PK ?
    AddPropertyValuesTo(Result, AoNewPersistent, aidCOAdd);

    if assigned(oncreate) then
      oncreate(result);
  end;
end;


{ AddPersistentChanges
    Compares two Persistent objects & builds a TaidChangeOrderStep item if necessary. }
function AddPersistentChanges(AoChanges : TaidBOMChangeObject;
                AeContext : TaidCOChangeContext;
                AoFromPersistent,
                AoToPersistent  : TPersistent;
                AsFromKey, AsFromParam, AsFromIndex: String; AiFromQuantity: TQuantity;
                AsToKey  , AsToParam  , AsToIndex  : String; AiToQuantity  : TQuantity;
                AosExcludedProperties: TStrings = nil; oncreate : TaidOncreateCOS = nil): TaidChangeOrderStep;
  procedure CreateChangeStep();
  begin
    if not Assigned(Result) then
    begin
      Result:= AoChanges.AddChange();

      Result.ChangeAction   := aidCOChange;{AeAction;}
      Result.ChangeContext  := AeContext;
      Result.ChangeFromKey  := AsFromKey;
      Result.ChangeFromParam:= AsFromParam;
      Result.ChangeFromIndex:= AsFromIndex;
      Result.ChangeFromQty  := AiFromQuantity;
      Result.ChangeToKey    := AsToKey;
      Result.ChangeToParam  := AsToParam;
      Result.ChangeToIndex  := AsToIndex;
      Result.ChangeToQty    := AiToQuantity;
      // ~~~ PK ?
      if assigned(oncreate) then
        oncreate(result);

    end;
  end;

resourcestring
  rsCannotCompareNil        = 'Unable to compare unassigned object(s).';
  rsCannotCompareProperties = 'Unable to compare %s type to %s type - classes must be the same.';
var
  vLeft,
  vRight            : Variant;
  oCommonProperties : TStringList;
  iProperty         : Integer;
  sPropName         : String;
  sLeft,
  sRight            : String;
  eVarCompare       : TVariantRelationship;
  ePropType         : TTypeKind;
  oPropertyChange   : TaidChangeOrderFieldItem;
  bProcess          : Boolean;
  PropInfoFrom      : PPropinfo;
  PropInfoTo       : PPropinfo;
begin
  Result:= nil;
  if (not Assigned(AoFromPersistent)) or (not Assigned(AoToPersistent)) then
    raise Exception.Create(rsCannotCompareNil);
  {}
  oCommonProperties:= TStringList.Create;
  try
    {RetrievePropertyNames(AoFromPersistent, oCommonProperties) then   { AoFromPersistent & AoToPersistent are the same properties }
    if RetrieveCommonPropertyNames(oCommonProperties, AoFromPersistent, AoToPersistent) then
    begin
      for iProperty:= 0 to oCommonProperties.Count-1 do
      begin
        sPropName  := oCommonProperties.Strings[iProperty];
        ePropType  := PropType(AoFromPersistent, sPropName);
        bProcess   := True;
        if Assigned(AosExcludedProperties) then
          bProcess:= AosExcludedProperties.IndexOf(sPropName)<0;
        // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkClass, tkMethod,
        // tkWChar, tkLString, tkWString, tkVariant, tkArray, tkRecord, tkInterface, tkDynArray
        if (bProcess) then
        begin
          { Ensure that we're only inspecting rudementary types. }
          if (not (ePropType in [tkUnknown, tkClass, tkMethod, tkArray, tkRecord, tkInterface, tkDynArray])) Then
          begin
            vLeft      := RetrievePropertyValue(AoFromPersistent, sPropName);
            vRight     := RetrievePropertyValue(AoToPersistent  , sPropName);
            { Handle enumerated values a little differently to have something readible. }
            if (ePropType = tkEnumeration) then
            begin
              PropInfoFrom:= GetPropInfo(AoFromPersistent, sPropName, [tkEnumeration]);
              PropInfoTo  := GetPropInfo(AoToPersistent  , sPropName, [tkEnumeration]);
              if Assigned(PropInfoFrom) and Assigned(PropInfoTo) then
              begin
                vLeft := GetEnumname( PropInfoFrom^.PropType^, GetOrdProp( AoFromPersistent, PropInfoFrom ));
                vRight:= GetEnumname( PropInfoTo^.PropType^  , GetOrdProp( AoToPersistent  , PropInfoTo   ));
              end;
            end;
            { Compare values. }
            eVarCompare:= VarCompareValue(vLeft, vRight);
            if (eVarCompare <> vrEqual) then
            begin
              sLeft    := VariantAsString(vLeft);
              sRight   := VariantAsString(vRight);
              if CompareStr(sLeft, sRight)<>0 then
              begin
                { Ensure that we have a Change Step (Result) }
                CreateChangeStep();//creates the result if not already created
                oPropertyChange             := Result.AddPropertyChange();
                oPropertyChange.PropertyName:= sPropName;
                oPropertyChange.FromValue   := vLeft;
                oPropertyChange.FromString  := sLeft;
                oPropertyChange.ToValue     := vRight;
                oPropertyChange.ToString    := sRight;
                { Response }
                if (not IsEmptyStr(sLeft)) and (IsEmptyStr(sRight)) then
                  oPropertyChange.Textual:= #39+sPropname+#39+' cleared - was: '+sLeft
                else
                  if IsEmptyStr(sLeft) and (not IsEmptyStr(sRight)) then
                    oPropertyChange.Textual:= #39+sPropname+#39+' set to: '+sRight
                  else
                    oPropertyChange.Textual:= #39+sPropname+#39+' from: '+sLeft+' to: '+sRight;

                //call back and record specific differences.
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(oCommonProperties);
  end;
end;

{ AddPersistentDeletion }
function {TmodMasterBOM.}AddPersistentDeletion(
  AoChanges: TaidBOMChangeObject;
  AeContext: TaidCOChangeContext; AoDeletedPersistent: TPersistent;
  AsKey: string; AsParam: String = ''; AsIndex: String = ''; AiQuantity: Integer = 0;
  oncreate : TaidOncreateCOS = nil): TaidChangeOrderStep;
begin
  Result:= nil;
  {}
  if Assigned(AoChanges) and Assigned(AoDeletedPersistent) then
  begin
    Result:= AoChanges.AddChange();
    Result.ChangeAction   := aidCODelete;
    Result.ChangeContext  := AeContext;
    Result.ChangeFromKey  := AsKey;
    Result.ChangeFromParam:= AsParam;
    Result.ChangeFromIndex:= AsIndex;
    Result.ChangeFromQty  := AiQuantity;
    // ~~~ PK ?

    AddPropertyValuesTo(Result, AoDeletedPersistent, aidCODelete);
    if assigned(oncreate) then
      oncreate(result);

  end;
end;


end.
