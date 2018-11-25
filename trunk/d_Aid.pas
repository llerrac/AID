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
  IBDatabase, DB, IBCustomDataSet, IBQuery,
  crIBQry,
  aidTypes, kbmMemTable;

type
  TModAid = class(TDataModule)
    ibTran: TIBTransaction;
    qryPurch: TcrIBQuery;
    qryPurchTRANNO: TIBStringField;
    qryPurchSUPPNO: TIBStringField;
    qryPurchSUPPNAME: TIBStringField;
    qryPurchTRANSITE: TIBStringField;
    qryPurchTRANREF: TIBStringField;
    qryPurchSUPPREF: TIBStringField;
    qryPurchTRANDTE: TDateTimeField;
    qryPurchTRANUSER: TIBStringField;
    qryPurchTRANUSERDESC: TIBStringField;
    qryPurchTRANSTATUS: TIBStringField;
    qryPurchTRANSTATUSDESC: TIBStringField;
    qryPurchDELIVERYSITE: TIBStringField;
    qryPurchDELIVERYWARE: TIBStringField;
    qryPurchEXPECTED: TDateTimeField;
    qryPurchISCOMPLETED: TIBStringField;
    qryComp: TcrIBQuery;
    qryCompCOMPNO: TIBStringField;
    qryCompCOMPNAME: TIBStringField;
    qryCompCOMPTELPRE: TIBStringField;
    qryCompCOMPTELNO: TIBStringField;
    qryCompCOMPFAXPRE: TIBStringField;
    qryCompCOMPFAXNO: TIBStringField;
    qryCompCOMPEMAIL: TIBStringField;
    qryCompLOCCOUNTRY: TIBStringField;
    qryCompLOCADDRESS: TIBStringField;
    qryCompLOCPC: TIBStringField;
    qryCompLOCCOUNTRYNAME: TIBStringField;
    qryCompCURRENCYSUPPLY: TIBStringField;
    qryCompCURRENCYSALES: TIBStringField;
    qryCompDIVISIONSALES: TIBStringField;
    qryCompALLOWTRACKING: TIBStringField;
    qryCompTRACKINGHTTP: TIBStringField;
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
    qryPartHASPARTINFO: TIBStringField;
    qryPartHASPARAMINFO: TIBStringField;
    qryPartHASPOINFO: TIBStringField;
    qryPartHASOPSINFO: TIBStringField;
    qryPartISADMINISTRATIVE: TIBStringField;
    qryPartISGENERIC: TIBStringField;
    qryPartISPARAMETERIZED: TIBStringField;
    qryPartISASSEMBLED: TIBStringField;
    qryPartPARTVERSION: TIBStringField;
    qryPartISSUENO: TIntegerField;
    qryPartNEEDMANUALPARAMS: TIBStringField;
    qryPartNEEDMANUALOPS: TIBStringField;
    qryPartSUPPNO: TIBStringField;
    qryPartSUPPPARTNO: TIBStringField;
    qryPartPARTNO: TIBStringField;
    qryPartPARTPARAM: TIBStringField;
    qryPartPARTDESC: TIBStringField;
    qryPartPARTTYPE: TIBStringField;
    qryPartPARTTYPEDESC: TIBStringField;
    qryPartPACKAGED: TIBStringField;
    qryPartPACKSIZE: TIntegerField;
    qryPartDISCPERC: TIBBCDField;
    qryPartREPLACEDBY: TIBStringField;
    qryPartREPLACEDBYPARAM: TIBStringField;
    qryPartREPLACEDBYOEMNO: TIBStringField;
    qryPartREPLACEDBYDESC: TIBStringField;
    qryPartSALENOTE: TIBStringField;
    qryPartQTYONHAND: TIntegerField;
    qryPartLASTMOVEDDTE: TDateTimeField;
    qryPartDEPARTMENT: TIBStringField;
    qryPartSUPPLYCODE: TIBStringField;
    qryPartBASECURRENCY: TIBStringField;
    qryPartCOSTSITE: TIBStringField;
    qryPartPACKCOSTBASE: TFloatField;
    qryPartUNITCOSTBASE: TFloatField;
    qryPartUNITCOSTGBP: TFloatField;
    qryPartDTECOSTED: TDateTimeField;
    qryPartUNITSELLGBP  : TFloatField;
    qryPartISFIXEDSELLPRICE: TIBStringField;
    qryPartONORDER: TIntegerField;
    qryPartLASTORDERED: TDateTimeField;
    qryPartLASTUNITCOSTGBP: TFloatField;
    qryPartLASTORDERTRANNO: TIBStringField;
    qryPartNEXTEXPECTED: TDateTimeField;
    qryPartNEXTORDERTRANNO: TIBStringField;
    qryPartPARAMSFORPART: TIBStringField;
    qryPartOPSFORPART: TIBStringField;
    qryPartAVGUNITCOSTGBP: TFloatField;
    qryPtOp: TcrIBQuery;
    qryPtOpOPERATION: TIBStringField;
    qryPtParam: TcrIBQuery;
    qryPtParamPARTPARAM: TIBStringField;
    qryPurchINC_PURCH: TIntegerField;
    qryCompVALIDSUPPLYSITES: TIBStringField;
    qryCompVALIDSALESSITES: TIBStringField;
    qryCompSALESPROMPT: TMemoField;
    qryCountry: TcrIBQuery;
    qryCountryCOUNTRYNO: TIBStringField;
    qryCountryCOUNTRYNAME: TIBStringField;
    qryCountryTELCODE: TIBStringField;
    qryCountryCURRENCYSUPPLY: TIBStringField;
    qryCountryCURRENCYSALES: TIBStringField;
    qryCountryREGIONSALES: TIBStringField;
    qryPoCost: TcrIBQuery;
    qryPoCostTRANNO: TIBStringField;
    qryPoCostTRANSTATUS: TIBStringField;
    qryPoCostSUPPNO: TIBStringField;
    qryPoCostSUPPNAME: TIBStringField;
    qryPoCostISPARTVALID: TIBStringField;
    qryPoCostPARTNO: TIBStringField;
    qryPoCostPARTPARAM: TIBStringField;
    qryPoCostJOBNO: TIBStringField;
    qryPoCostDTEREQUIRED: TDateTimeField;
    qryPoCostUNITNETGBP: TFloatField;
    qryPartDTEVALIDFROM: TDateTimeField;
    qryPartDTEVALIDUNTIL: TDateTimeField;
    qryPartSTOCKINGTYPE: TIBStringField;
    qryPartKey_Eng: TStringField;
    qryPartPRICEBAND: TIBStringField;
    qryCont: TcrIBQuery;
    qryContCONTNO: TIBStringField;
    qryContCONTDESC: TIBStringField;
    qryContCOMPNO: TIBStringField;
    qryCompAGENTNO: TStringField;
    qryCompOWNCOMMISSION: TIBBCDField;
    qryCompAGENTCOMMISSION: TIBBCDField;
    qryPartCOMMODITYCODE: TIBStringField;
    qryPartCOUNTRYOFORIGIN: TIBStringField;
    qryPartTECHMEMO: TMemoField;
    qryCompIssuePurchaseLabels: TStringField;
    qryPartIsShipping: TIBStringField;
    qryCompO_RESTRICTED_COUNTRY: TStringField;
    kbmMemTabke: TkbmMemTable;
    kbmMemTabkeKey_Lk: TStringField;
    kbmMemTabkeDesc_Lk: TStringField;
    qryPtParammaster_id: TIntegerField;
    qryPartMASTER_ID: TIntegerField;
    qryPartUNITSELL_ALT: TFloatField;
    qryPartUNITSELL_ALT_CURCODE: TIBStringField;
    qryContKEY_STATUS: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModAid: TModAid;

procedure CheckAIDModuleIsReady(ADatabase: TIBDatabase);

implementation

{$R *.dfm}

uses
  crUtil;


procedure CheckAIDModuleIsReady(ADatabase: TIBDatabase);
begin
  if not Assigned(ModAID) then
    Application.CreateForm(TModAID, ModAID);
  //
  if (ModAID.ibTran.DefaultDatabase <> ADatabase) then
  begin
    if ModAID.ibTran.InTransaction then ModAID.ibTran.Commit;
    ModAID.ibTran.DefaultDatabase:= ADatabase;
  end;
end;


procedure TModAid.DataModuleDestroy(Sender: TObject);
begin
  ModAID := nil;
end;

end.
