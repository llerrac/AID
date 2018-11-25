unit aidReg_2010;

{ -------------------------------------------------------------------------------------------------
  Name        : aidReg
  Author      : Chris G. Royle
  Description : Registration Unit for Atlas Internal Development (AID) components. 
  Note        :
  Modified    :
    CGR20070117, added registration of Row, Bin, Stock Movement Direction lookups.
    CGR20070123, added registration of Resource Allocation, Resource Function Lookup. 
  -------------------------------------------------------------------------------------------------}

interface

{$R aidReg.dcr}

uses
  Classes;

  procedure Register;

implementation

uses
  { Lookup Components which launch custom search dialogs }
//  aiddbLkpAssm,
//  aiddbLkpBOM, aiddbLkpPurch,
//  aiddbLkpCont, aiddbLkpPart,
//  aiddblkpComp, aiddbLkpEnquiry
  { Lookup components which descend from CustomComboBox }
//  ,aiddbLkpSite,
//  aiddbLkpGeneric,
//  aiddbLkpUsers,
//  aiddbLkpWarehouse,
//  aiddbLkpJob, aiddblkpAnalysisCode,
//  aiddbLkpResource,
  { Wire-Less components}
//  aidwlRunOutGrid, aidwlCableGrid, aidwlLookups,
  { Version Component 3rd Party ?}
//  CEVersioninfo,
  { Color Lookups }
//  aidCodedColor, aiddbCodedColor,
  { Communications Server Client }
  aidCommsObj;

const
  CRegSection = 'AID';

procedure Register;
begin
  { Custom lookup components which launch search screens }
//  RegisterComponents(CRegSection,
//    [TaiddbLookupAssm, TaiddbLookupBOM, TaiddbLookupPurch,
//     TaiddbLookupCont, TaiddbLookupPart, TaiddbLookupCompany,TvaldbLookupEnquiry]);
  { Wire-Less application Components }
//  RegisterComponents(CRegSection,
//    [aidwlRunOutGrid .TaidwlRunoutGrid,
//     aidwlCableGrid  .TaidwlCableGrid,
//     aidwlLookups    .TaidwldbWireTypeComboBox,
//     aidwlLookups    .TaidwldbWireFuncComboBox,
//     aidwlLookups    .TaidwldbCableTypeComboBox,
//     aidwlLookups    .TaidwldbWireColorComboBox]);
  { New style lookups. }
//  RegisterComponents(CRegSection, [aiddbLkpSite .TaiddbLkpSite, aiddbLkpGeneric.TaiddbLkpGeneric]);

//  RegisterComponents(CRegSection, [
//    aiddbLkpJob         .TaiddbLkpJob,
//    aiddblkpAnalysisCode.TaiddbLkpSupplyAnalysisCode]);

//  RegisterComponents(CRegSection, [
//    aiddbLkpUsers.TaiddbLkpUser,
//    aiddbLkpUsers.TaiddbLkpPurchaser,
//    aiddbLkpUsers.TaiddbLkpUserEmailRecipients]);

//  RegisterComponents(CRegSection, [
//    aiddbLkpWarehouse.TaiddbLkpWarehouse,
//    aiddbLkpWarehouse.TaiddbLkpRow,
//    aiddbLkpWarehouse.TaiddbLkpBin,
//    aiddbLkpWarehouse.TaiddbLkpStockMovement]);

//  RegisterComponents(CRegSection, [
//    aiddbLkpResource.TaiddbLkpResourceFunction]);
  { Communications Server }
  RegisterComponents(CRegSection,
    [aidCommsObj .TaidCommunications]);
  { 3rd Party Version Component. }
//  RegisterComponents(CRegSection, [TCEVersionInfo]);
  { Colour Selection Lookups for Contracts. }
//  RegisterComponents(CRegSection, [TaidCodedColorBox]);
//  RegisterComponents(CRegSection, [TaiddbCodedColorBox]);
end;



end.
