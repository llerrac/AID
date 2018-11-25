unit d_AID;

{ ------------------------------------------------------------------------------------------------
  Name:         d_AID.pas
  Description:  Data Module for Atlas specific lookups.
  See also:     aiddbUtil which interfaces to this data module
                ProcPart.sql (PROC_Part_GetInfo)
                procComp.sql (PROC_Comp_GetSummary - Company Item Retrieval )
  Modified:     CGR20051207, Added IssuePurchaseLabels field retrieval to company record.
  ------------------------------------------------------------------------------------------------ }

interface

uses
  SysUtils, Forms, Classes,
  DB, IB_Components,IBODataset,
  crIBQry,
  aidTypes;

type
  TModAid = class(TDataModule)
    ibTran: TIB_Transaction;
    qryPurch: TcrIBQuery;
    qryPurchTRANNO: TStringField;
    qryPurchSUPPNO: TStringField;
    qryPurchSUPPNAME: TStringField;
    qryPurchTRANSITE: TStringField;
    qryPurchTRANREF: TStringField;
    qryPurchSUPPREF: TStringField;
    qryPurchTRANDTE: TDateTimeField;
    qryPurchTRANUSER: TStringField;
    qryPurchTRANUSERDESC: TStringField;
    qryPurchTRANSTATUS: TStringField;
    qryPurchTRANSTATUSDESC: TStringField;
    qryPurchDELIVERYSITE: TStringField;
    qryPurchDELIVERYWARE: TStringField;
    qryPurchEXPECTED: TDateTimeField;
    qryPurchISCOMPLETED: TStringField;
    qryComp: TcrIBQuery;
    qryCompCOMPNO: TStringField;
    qryCompCOMPNAME: TStringField;
    qryCompCOMPTELPRE: TStringField;
    qryCompCOMPTELNO: TStringField;
    qryCompCOMPFAXPRE: TStringField;
    qryCompCOMPFAXNO: TStringField;
    qryCompCOMPEMAIL: TStringField;
    qryCompLOCCOUNTRY: TStringField;
    qryCompLOCADDRESS: TStringField;
    qryCompLOCPC: TStringField;
    qryCompLOCCOUNTRYNAME: TStringField;
    qryCompCURRENCYSUPPLY: TStringField;
    qryCompCURRENCYSALES: TStringField;
    qryCompDIVISIONSALES: TStringField;
    qryCompALLOWTRACKING: TStringField;
    qryCompTRACKINGHTTP: TStringField;
    qryCompDRLATESTUPDATE: TDateTimeField;
    qryCompDRLATESTTRAN: TDateTimeField;
    qryCompDRBAL: TFloatField;
    qryCompDRBALCUR: TFloatField;
    qryCompDRBAL30: TFloatField;
    qryCompDRBAL60: TFloatField;
    qryCompDRBAL90: TFloatField;
    qryCompDRBAL120: TFloatField;
    qryCompDRBAL150: TFloatField;
    qryCompDRBALOVERDUE: TFloatField;
    qryPart: TcrIBQuery;
    qryPartHASPARTINFO: TStringField;
    qryPartHASPARAMINFO: TStringField;
    qryPartHASPOINFO: TStringField;
    qryPartHASOPSINFO: TStringField;
    qryPartISADMINISTRATIVE: TStringField;
    qryPartISGENERIC: TStringField;
    qryPartISPARAMETERIZED: TStringField;
    qryPartISASSEMBLED: TStringField;
    qryPartPARTVERSION: TStringField;
    qryPartISSUENO: TIntegerField;
    qryPartNEEDMANUALPARAMS: TStringField;
    qryPartNEEDMANUALOPS: TStringField;
    qryPartSUPPNO: TStringField;
    qryPartSUPPPARTNO: TStringField;
    qryPartPARTNO: TStringField;
    qryPartPARTPARAM: TStringField;
    qryPartPARTDESC: TStringField;
    qryPartPARTTYPE: TStringField;
    qryPartPARTTYPEDESC: TStringField;
    qryPartPACKAGED: TStringField;
    qryPartPACKSIZE: TIntegerField;
    qryPartDISCPERC: TIBOBCDField;// TBCDField//TIBBCDField;
    qryPartREPLACEDBY: TStringField;
    qryPartREPLACEDBYPARAM: TStringField;
    qryPartREPLACEDBYOEMNO: TStringField;
    qryPartREPLACEDBYDESC: TStringField;
    qryPartSALENOTE: TStringField;
    qryPartQTYONHAND: TIntegerField;
    qryPartLASTMOVEDDTE: TDateTimeField;
    qryPartDEPARTMENT: TStringField;
    qryPartSUPPLYCODE: TStringField;
    qryPartBASECURRENCY: TStringField;
    qryPartCOSTSITE: TStringField;
    qryPartPACKCOSTBASE: TFloatField;
    qryPartUNITCOSTBASE: TFloatField;
    qryPartUNITCOSTGBP: TFloatField;
    qryPartDTECOSTED: TDateTimeField;
    qryPartUNITSELLGBP: TFloatField;
    qryPartISFIXEDSELLPRICE: TStringField;
    qryPartONORDER: TIntegerField;
    qryPartLASTORDERED: TDateTimeField;
    qryPartLASTUNITCOSTGBP: TFloatField;
    qryPartLASTORDERTRANNO: TStringField;
    qryPartNEXTEXPECTED: TDateTimeField;
    qryPartNEXTORDERTRANNO: TStringField;
    qryPartPARAMSFORPART: TStringField;
    qryPartOPSFORPART: TStringField;
    qryPartAVGUNITCOSTGBP: TFloatField;
    qryPtOp: TcrIBQuery;
    qryPtOpOPERATION: TStringField;
    qryPtParam: TcrIBQuery;
    qryPtParamPARTPARAM: TStringField;
    qryPurchINC_PURCH: TIntegerField;
    qryCompVALIDSUPPLYSITES: TStringField;
    qryCompVALIDSALESSITES: TStringField;
    qryCompSALESPROMPT: TMemoField;
    qryCountry: TcrIBQuery;
    qryCountryCOUNTRYNO: TStringField;
    qryCountryCOUNTRYNAME: TStringField;
    qryCountryTELCODE: TStringField;
    qryCountryCURRENCYSUPPLY: TStringField;
    qryCountryCURRENCYSALES: TStringField;
    qryCountryREGIONSALES: TStringField;
    qryPoCost: TcrIBQuery;
    qryPoCostTRANNO: TStringField;
    qryPoCostTRANSTATUS: TStringField;
    qryPoCostSUPPNO: TStringField;
    qryPoCostSUPPNAME: TStringField;
    qryPoCostISPARTVALID: TStringField;
    qryPoCostPARTNO: TStringField;
    qryPoCostPARTPARAM: TStringField;
    qryPoCostJOBNO: TStringField;
    qryPoCostDTEREQUIRED: TDateTimeField;
    qryPoCostUNITNETGBP: TFloatField;
    qryPartDTEVALIDFROM: TDateTimeField;
    qryPartDTEVALIDUNTIL: TDateTimeField;
    qryPartSTOCKINGTYPE: TStringField;
    qryPartKey_Eng: TStringField;
    qryPartPRICEBAND: TStringField;
    qryCont: TcrIBQuery;
    qryContCONTNO: TStringField;
    qryContCONTDESC: TStringField;
    qryContCOMPNO: TStringField;
    qryCompAGENTNO: TStringField;
    qryCompOWNCOMMISSION: TIBOBCDField;
    qryCompAGENTCOMMISSION: TIBOBCDField;
    qryPartCOMMODITYCODE: TStringField;
    qryPartCOUNTRYOFORIGIN: TStringField;
    qryPartTECHMEMO: TMemoField;
    qryCompIssuePurchaseLabels: TStringField;
    qryPartIsShipping: TStringField;
    qryCompO_RESTRICTED_COUNTRY: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModAid: TModAid;

procedure CheckAIDModuleIsReady(ADatabase: TIB_connection);

implementation

{$R *.dfm}

uses
  crUtil;


procedure CheckAIDModuleIsReady(ADatabase: TIB_connection);
begin
  if not Assigned(ModAID) then
    Application.CreateForm(TModAID, ModAID);
  //
  if (ModAID.ibTran.IB_Connection <> ADatabase) then
  begin
    if ModAID.ibTran.InTransaction then ModAID.ibTran.Commit;
    ModAID.ibTran.IB_Connection:= ADatabase;
  end;
end;


procedure TModAid.DataModuleDestroy(Sender: TObject);
begin
  ModAID := nil;
end;

end.
