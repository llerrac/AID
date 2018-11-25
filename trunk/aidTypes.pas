unit aidTypes;

{ -------------------------------------------------------------------------------------------------
  name        : aidTypes
  description : types used within the BOM Application, AID Library, and related applications.
  see also    : aidUtil.pas
  modified    :
    2003/11/06 CGR Added valSalesRaiseFinancialTrans for use with SOP module.
    2003/12/01 CGR Added valIntegratePurchases, valIntegrateSalesLedger for password protected
                    Integrator.
    2003/12/03 CGR Added Signature info. into TUserConfig record
    2003/12/05 CGR Added Commodity Code / CountryOfOrigin to PartDef
    2004/01/16 CGR Added MIR(Machine Issue Reporting) security attributes, and security levels.
    2004/05/11 CGR Added MIR valMachineIssueCanEnterCosts attribute. Added Udf4-6
    2004/07/20 CGR moved function SiteToBookkeepingCompany into this unit.
    2004/09/23 CGR Added a whole bunch of aliases due to the unit rename.
    2004/08/11 CGR Added a generic exception event TaidExceptionEvent for use in non-blocking
                   exception reporting.
    2004/11/17 CGR Added UseCommsQueue flag to determine if the Comms Queue functionality is
                   used. Added additional comments to the TUserConfig record structure.
    2004/12/20 CGR Moved SiteToBookkeepingCompany to new unit aidOperaCompanies.
    2006/01/14 CGR Added ContractBOMType stuff, Added Version Control Stuff.
    CGR20060619, Added aidPurchaseCanMtnInvoiceInfo attribute to allow supplier invoice entry against
            purchase invoice information.
    CGR20061011, Modified ExtensionAsContentType to accomodate Catia documents - NOTE: this needs to be made
            data driven.
    CGR20061108, Added code for dealing with Stock Movement Directions as an enumeration. 
    CGR20061128, Added support for seperate security properties for ContractInfo Spares information. 
    CGR20061212, Added support for data-driven DestAcPackage population.
    CGR20061215, Removed PURCHANALALGORITHM field - this is defined at Site Level (and each Job is
      assigned a site).
    CGR20061219, Moved TLookup from bomTypes.
    ajc2009Jul30 Changes covering Chanr orders, addition of new change state, and some refactoring.
    ajc2010Sept  Stripped shortstrings out as they simple chop length of strigs silently, plus they are not unicode

  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  db, Graphics, SysUtils,
  { Application Units }
  crTypes, aidLang;

type
  TApplicationAudience = (aidauBobst, aidauApolloSheeters,aidauAtlas,aidauAtlasNorthAmerica);

type
  TLnk    = String;
  TInc    = LongInt;
  TKey10  = String;

type  { see BomTypes }
  TContNo      = String;
  TSectNo      = String;
  TBOMNo       = String;
  TPartNo      = String; // VarChar(10)
  TPartParam   = String; // VarChar(10)

  TJobNo          = String; // VarChar(10)

  TSiteNo         = String; // Char(1)
  TSiteCollection = String; // VarChar(26) - A string containing an undelimited list of site IDs.

  TWarehouseNo    = String;
  TRowNo          = String;
  TBinNo          = String;

  TCompNo      = String ; // VarChar(10)
  TDesc50      = String ; // VarChar(50)
  TName        = String ;
  TDesc20      = String ;
  TModel       = String ;
  TWeeks       = Integer;
  TUserNo      = String ;
  TUserLong    = String ;
  TGroup       = String ;
  TLookup      = String ;
  TLookupID    = Integer;      { Used for storing enumerated lookup indicators. }
  TKey1        = String;
  TDesc30      = String;

  TAnalysisCoding = string;
  TAnalysisCode   = String;
  

type
  EACEException       = class(Exception);//atlas converting equipment
  EaidException       = class(EACEException);
  TaidExceptionEvent  = procedure(Sender: TObject; const AsExceptionText: string) of object;
  TaidLogEvent        = procedure(Sender: TObject; const AsLogText      : string) of object;
  TaidStatisticsEvent = procedure(Sender: TObject; const AStatisticIndex: Integer; const AStatisticValue: Single) of object;
  TaidIncNotifyEvent  = procedure(Sender: TObject; const AiInc: TInc) of object;

{
    Spares
}
type
  TvalmulRange = packed record
    ValueFr   : Currency;
    ValueTo   : Currency;
    Multiplier: Single;
  end;
  TSparesUplift = Array[1..5] of TvalmulRange;        // Spares uplift prices

(*******************************************************************************
  User Security
 *******************************************************************************)
type
  TUserPermissionClass = (upAttr01, upAttr02, upAttr03, upAttr04, upAttr05,
                          upAttr06, upAttr07, upAttr08, upAttr09, upAttr10,
                          upAttr11, upAttr12, upAttr13, upAttr14, upAttr15,
                          upAttr16, upAttr17, upAttr18, upAttr19, upAttr20,
                          upAttr21, upAttr22, upAttr23, upAttr24, upAttr25,
                          upAttr26, upAttr27, upAttr28, upAttr29, upAttr30,
                          upAttr31);
  TUserPermissionIndex = (upRead  {bit 0}, upEdit   {bit  1}, upCreate {bit  2},
                          upDelete{bit 3}, upLimited{bit  4}, upManager{bit  5},
                          upUdf1  {bit 6}, upUdf2   {bit  7}, upUdf3   {bit  8},
                          upUdf4  {bit 9}, upUdf5   {bit 10}, upUdf6   {bit 11});
const
  upBit0  = upRead;
  upBit1  = upEdit;
  upBit2  = upCreate;
  upBit3  = upDelete;
  upBit4  = upLimited;
  upBit5  = upManager;
  upBit6  = upUdf1;
  upBit7  = upUdf2;
  upBit8  = upUdf3;
  upBit9  = upUdf4;
  upBit10 = upUdf5;
  upBit11 = upUdf6;

type
  TUserAttributes        = Array[TUserPermissionIndex] of Boolean;
  TUserPermissions       = Array[TUserPermissionClass] of TUserAttributes;
  TaidUserIntegerPerms   = Array[TUserPermissionClass] of Integer; {TUserPermissionIndex are stored in db as Integers}
  TUserIntegerPerms      = TaidUserIntegerPerms;
  TUserPermissionIndexes = Set of TUserPermissionIndex;

{ Used by u_login . HasPermission,HasOneOfThesePermissions, etc  }

const // Atlas Specific
  aidCompany        = upAttr01; valCompany        = upAttr01; // Company maintenance
  aidPurchase       = upAttr02; valPurchase       = upAttr02; // Purchase Order Maintenance
  aidPart           = upAttr03; valPart           = upAttr03; // Parts Maintenance
  aidAssembly       = upAttr04; valAssembly       = upAttr04; // Assemblies / BOMs Maintenance
  aidStock          = upAttr05; valStock          = upAttr05; // Stock Maintanance
  aidJob            = upAttr06; valJob            = upAttr06; // Jobs Maintenance
  aidCosts          = upAttr07; valCosts          = upAttr07; // Costs Maintenance
  aidBOM            = upAttr08; {valBOM            = upAttr08; }// BOMs Maintenance
  aidSales          = upAttr09; valSales          = upAttr09; // Sales Maintenance
  aidTechCont       = upAttr10; valTechCont       = upAttr10; // Technical Contacts
  aidPurchReqn      = upAttr11; valPurchReqn      = upAttr11; // Purchase Requisition
  aidPurchEnq       = upAttr12; valPurchEnq       = upAttr12; // Purchase Enquiries
  aidRepRet         = upAttr13; valRepRet         = upAttr13; // Repairs and Returns
  aidContract       = upAttr14; {valContract       = upAttr14; }// Contracts
  aidDocLinks       = upAttr15; valDocLinks       = upAttr15; // Document Management
  aidResourceAlloc  = upAttr16; valResourceAlloc  = upAttr16; // Resource Allocation
  aidContractSpares = upAttr17; {valContractSpares = upAttr17;} // Contract Spares
  aidIntegration    = upAttr18; valIntegration    = upAttr18; // Integrator Permissions
  aidMachineIssues  = upAttr19; valMachineIssues  = upAttr19; // Machine Issues
  aidMRP            = upAttr20; valMRP            = upAttr20; // MRP
  aidContractInfo   = upAttr21; {valContractInfo   = upAttr21;} // Contract Information
  aidWireLess       = upAttr22; {valWireLess       = upAttr22;} // Wire-Less System aka Runouts & Interconnects.
  aidEndUserReport  = upAttr23;                               // End-User reporting module.
  aidCommission     = upAttr31; aidStockingLevels = upAttr24;
  //
  CUserPermissionClassFieldName : Array[TUserPermissionClass] of string
    = ('Attr01', 'Attr02', 'Attr03', 'Attr04', 'Attr05',
       'Attr06', 'Attr07', 'Attr08', 'Attr09', 'Attr10',
       'Attr11', 'Attr12', 'Attr13', 'Attr14', 'Attr15',
       'Attr16', 'Attr17', 'Attr18', 'Attr19', 'Attr20',
       'Attr21', 'Attr22', 'Attr23', 'Attr24', 'Attr25',
       'Attr26', 'Attr27', 'Attr28', 'Attr29', 'Attr30',
       'Attr31');
  CUserPermissionClass          : Array[TUserPermissionClass] of string
    = ({ 1- 5} 'Company'      , 'Purchase'    , 'Part'       , 'Assembly'    , 'Stock',
       { 6-10} 'Job'          , 'Costs'       , 'BOMs'       , 'Sales'       , 'TCNs',
       {11-15} 'Requisition'  , 'Supp.Enq'    , 'Return'     , 'Contract'    , 'DocLinks',
       {16-20} 'ResAlloc'     , 'ContSpares'  , 'Integration', 'MachineIssue', 'MRP',
       {21-25} 'Contract Info', 'Wire-Less'   , 'User Report', 'Stock Levels', '** Spare **' ,
       {26-30} '** Spare **'  , '** Spare **' , '** Spare **', '** Spare **' , '** Spare **' ,
       'Commission');//31

    CUserPermissionIndex  : Array[TUserPermissionIndex] of string
    = ('Read', 'Edit', 'Create', 'Delete', 'Limited', 'Manager', 'Udf01', 'Udf02', 'Udf03', 'Udf04', 'Udf05', 'Udf06');
    //=  0     1        2         3         4           5         6         7       8         9       10        11



  function UserPermissionClassNameByFieldName(AsFieldName: string): string;

  //CUserPermissionDesc  : Array[TUserPermissionIndex] of CUserPermissionIndex;

const
  // aidCompany (upAttr01)
  aidCompanyViewFinancial       : TUserPermissionIndex =  upUdf1;   // bit 6, Companies , view financials
  // aidPurchase (upAttr02)
  aidPurchaseDynamicPricing     : TUserPermissionIndex =  upUdf1;   // bit 6, Purchasing, dynamic price updating
  aidPurchaseMaintainNotes      : TUserPermissionIndex =  upUdf2;   // bit 7, Allows users to maintain the notes within purchasing eg for chasing
  aidPurchaseMaintainEcComm     : TUserPermissionIndex =  upUdf3;   // bit 8, Allows users to maintain the Commodity Codes lookup
  aidPurchaseCanMtnAfterInvoice : TUserPermissionIndex =  upUdf4;   // bit 9, Can this user maintain a purchase order after it's been invoiced.
  aidPurchaseCanMtnInvoiceInfo  : TUserPermissionIndex =  upUdf5;   // bit10, Can this user maintain invoice information.

  // aidPart (upAttr03)
  aidPartMaintainForex          : TUserPermissionIndex =  upUdf1;   // bit 6, Parts, Maintain Foreign Exchange rates (added CGR20020522)
  aidMaintainItemCategories     : TUserPermissionIndex =  upUdf2;   // bit 7, Check / Uncheck item categories.
  // aidStock (upAttr05)
  aidStockGoodsInProcessing     : TUserPermissionIndex =  upUdf1;   // Stock, Goods-in processing
  aidStockRecomputeStockLevels  : TUserPermissionIndex =  upUdf2;   // Stock, Recompute Stock Levels
  aidStockZeroStockLevels       : TUserPermissionIndex =  upUdf3;   // Stock, Zero Stock Levels
  // aidBOM (upAttr08)
  aidBOMUseVCS                  : TUserPermissionIndex =  upUdf1;   // bit 6, BOMs, editing should use VCS.
  // aidSales (upAttr09)
  aidSalesSellPriceProcessing   : TUserPermissionIndex =  upUdf1;   // Sales, Selling Price in processing
  aidSalesRaiseFinancialTrans   : TUserPermissionIndex =  upUdf2;   // Sales, Raise Financial Transactions
  // aidRequisitioning (upAttr11)
  aidPurchReqnUseEmergencyStock : TUserPermissionIndex =  upUdf1;   // bit 6, Requisition, allows the requisitioner to use emergency stock.
  aidReqnAllowUnbinding         : TUserPermissionIndex =  upUdf2;   // bit 7, Allow the user to unbind requisitions.
  // aidContract (upAttr14)
  aidContractRequisition        : TUserPermissionIndex =  upUdf1;   // bit 6, Contracts, requisition submission
  aidContractEditNonDesign      : TUserPermissionIndex =  upUdf2;   // bit 7, Contracts, maintain non-design lines
  aidContractUseVCS             : TUserPermissionIndex =  upUdf3;   // bit 8, Contract, editing should use VCS.
  aidContractListChangeOrder    : TUserPermissionIndex =  upUdf4;   // bit 9, Change Orders, Summary Reporting.
  // aidContractSpares (upAttr17)
  aidContractSparesSetSpares    : TUserPermissionIndex =  upUdf1;   // bit 6, Contract Spares, set spares flags
  // Machine Issues Reporting (upAttr19)
  aidMachineIssueProblemManager : TUserPermissionIndex =  upUdf1;   // bit 6, Machine Issues - Is a problem manager ?
  aidMachineIssueCanCookiePswd  : TUserPermissionIndex =  upUdf2;   // bit 7, Machine Issues - Can store auto login cookie ?
  aidMachineIssueCanEnterCosts  : TUserPermissionIndex =  upUdf3;   // bit 8, Can enter extended costs
  // Jobs (upAttr06)
  aidJobsCostingAnalysis        : TUserPermissionIndex =  upUdf1;   // Jobs, Allow printing of the Job Costing Analysis (added AGWM20021008)
  // Integrator (upAttr18)
  aidIntegratePurchases         : TUserPermissionIndex =  upUdf1;   // Allows Purchase Order integration with Integrator (added CGR20031202)
  aidIntegrateSalesLedger       : TUserPermissionIndex =  upUdf2;   // Allows Sales Ledger integration with Integrator (added CGR20031202)
  // Contract Information (upAttr21)
  aidContInfoReadProjectInfo    : TUserPermissionIndex =  upBit0;   // Read Contract Project Info
  aidContInfoMtnProjectInfo     : TUserPermissionIndex =  upBit1;   // Maintain Contract Project Info
  aidContInfoReadComputerInfo   : TUserPermissionIndex =  upBit2;   // Read Contract Computer Info
  aidContInfoMtnComputerInfo    : TUserPermissionIndex =  upBit3;   // Maintain Contract Computer Info
  aidContInfoReadSparesInfo     : TUserPermissionIndex =  upBit4;   // Read Contract Spares Info (added CGR20061128)
  aidContInfoMtnSparesInfo      : TUserPermissionIndex =  upBit5;   // Maintain Contract Spares Info (added CGR20061128)
  aidContInfoReadManualInfo     : TUserPermissionIndex =  upBit6;   // Read Contract Manuals Info (added CGR20061128)
  aidContInfoMtnManualInfo      : TUserPermissionIndex =  upBit7;   // Maintain Contract Manuals Info (added CGR20061128)
  //  End-User Reporting (upAttr23)
  //Stock Levels #24



Type
  { TaidDocumentItem
      Dynamic array for storing details re. permissable user documents. }
  TaidDocumentItem = packed record
    Key_Doc    : String;
    Desc_Doc   : String;
    Filters    : String;
    IsInherited: Boolean;
  end;
  TaidDocumentList = Array of TaidDocumentItem;

type
  { TUserConfig
      Record containing logged-in user information - see Data.sql for the fields. }
  TUserConfig = packed record // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ modify to use types & not shortstrings.
    HasBeenLoaded         : Boolean;// * Is this record structure populated ?
    Inc_Login             : TInc;   // Inc within UserLog. The login produces a number which must be used when logging out in order that the 'current users' list is accurate.
    // User Name
    UserName              : TUserNo;     // Key field
    UserLong              : TUserLong;   // Full Name
    Security              : ShortString; // Security Role - [0] Guest, [1] Standard User, [5] System Administrator [6] Developer.
    eMail                 : ShortString; // Email address used for From, Reply To when emailing.
    // Organisational
    PrimaryOU             : TLookup;     // User's primary organisational unit.
    PrimaryOUDesc         : TName;       // User's primary organisational unit description.
    // Site / Division Info
    Site                  : TSiteNo;     // Site Code eg [A] [C] [T]
    SiteDesc              : TName;       // Site Description eg Bedford
    Division              : TLookup;     // Default Business Division code (note necessarily filled)
    DivisionDesc          : TName;       // Default Business Division Description (note necessarily filled)
    Ware                  : TLookup;     // Default warehouse for stock
    DestAcPackage         : String[1];       { Destination Accounting Package }
    // SMTP Mail Server Information (derived from Site info, but may be extended to be user specific later)
    SMTPHost              : TName;       // Host address for SMTP server capabale of emailing to external targets.
    SMTPUseAuthentication : Boolean;     // Does this server require login authentication
    SMTPAuthAccount       : ShortString; // Authentication account
    SMTPAuthEncryptedPswd : ShortString; // Authentication password
    SMTPLocalHost         : ShortString; // Host address for SMTP server capabale of emailing to internal targets.
    // Environment specific
    InitialFolder         : ShortString; // Initial folder when browsing for documents - may be obsoleted.
    www                   : ShortString; // Default home page when launching the built-in web browser.
    UseCommsQueue         : Boolean;// Is the communications queue used rather than Fax / Email components ?
    // Company Account creators (This restricts company creation scope due to accounting system issues)
    ValidSupplySites,               // This will default the sites for which a supplier account is visible / transactionable.
    ValidSalesSites       : ShortString; // This will default the sites for which a customer account is visible / transactionable.
    // Signature Information (used on spares documentation (Commercial Invoices))
    SignName              : ShortString; // Signature name
    SignLocation          : ShortString; // Signature location eg Bedford
    // Machine Issue Reporting
    ProbCatManaged        : ShortString; // Problem category which the user manages (if a MIR Manager)
    // Purchasing Default(s)
    PurchJobNo            : ShortString; // Default job number when creating purchase orders.
    PurchSites            : ShortString; // TSiteCollection - This indicates which sites a purchaser can purchase against i.e. JobMast.Site. If this field is empty all Sites' jobs can be purchased again. */
    // Sales Default(s)
    // * The original purpose of SalesCurrency was as default currency when raising sales - this may have been obsoleted by
    // company specific settings. This field is still used for currency conversion for display purposes.
    SalesCurrency         : ShortString;
//    SalesAnalAlgorithm    : Char;   // Indicates how the Sales Analysis Codes are applied against Sales Invoices.
    //
    SparesUplifts         : TSparesUplift;// Markup structures applicable to this users - gathered from site related info.
    // Payroll
    PayrollNo             : ShortString;  // Employee's payroll number - used for job costing.
    // Document Attributes
    ViewableDocuments     : TaidDocumentList;
    ViewableDocFilters    : ShortString;
    // Security
    Permissions : TUserPermissions;       // Security Attributes (permissions set as bits)
  end;

type
  TbomGetUserInfoEvent = procedure (Sender: TObject; var UserInfo: TUserConfig) of object;

{ Purchasing - PO lookup }
type
  TvalPurchDef = packed record
    Found     : Boolean;
    // Info from PurchMast
    Inc_Purch : TInc;
    TranNo,
    TranRef,
    TranStatusDesc,
    SuppNo,
    SuppName,
    SuppRef   : string;
    // The following will not always be populated.
    PartNo,
    PartParam : string;
    Inc_PurchP : TInc;
  end;
  TaidPurchDef = TvalPurchDef;

  { Purchasing - PO Line lookup }
  TvalPurchItemDef = packed record // CGR 200207703
    Found       : Boolean;
    //
    TranNo,
    TranStatus  : string;
    SuppNo,
    SuppName    : string;
    IsPartValid : Boolean;
    PartNo,
    PartParam   : string;
    JobNo       : string;
    DteRequired : TDateTime;
    UnitNetGBP  : Single;
  end;
  TaidPurchItemDef = TvalPurchItemDef;

type
  TvalLookedUpPurchEvent  = procedure(Sender: TObject; DataSource: TDataSource; PurchDef: TvalPurchDef) of object;


{ Companies
    Company definition }
type
  TaidCompDef = packed record
    Found           : Boolean;  // Company account found
    //
    Inc_Comp        : TInc;
    CompNo          : string;   // Company Number
    CompName        : string;   // Company Name
    AcCode          : string;   // Accounting Code
    // Telephony Data
    TelPre,                     // Contact Telephony
    TelNo,
    FaxPre,
    FaxNo,
    Email           : string;     // Email Address
    // Location Address data
    LocCountry      : string;     // Location Country
    LocCountryName  : string;     // Location Country Name
    LocPC           : string;     // Location PC
    LocAddress      : string;     // Location Address
    // Formatted address
    LocFullAdr      : string;     // Location Full Address (wrapped)
    LocLineAdr      : string;     // Location Full Address (comma-separated)
    // Transaction Defaults (Procurement)
    ValidSupplySites,             // Valid Sites for initiating supply
    CurrencySupply     : string;  // Purchase order default currencies
    IssuePurchaseLabels: Boolean; // Print Purchase Order labels
    // Transaction Defaults (Sales)
    ValidSalesSites : string;     // Valid Sites for initiating sales
    CurrencySales   : string;     // Quotation, Customer order currencies
    SalesPrompt     : string;     // Sales Prompt
    DivisionSales   : string;     // Quotation, Customer order default division
    DelMethod       : string;     // Default Delivery method - see Sales
    PayTerms        : string;     // Default Payment Terms - see Sales */
    CarrierNo       : string;     // Default Carrier - see SaleDelivery */
    AgentNo         : String;     // Default Agent - Sales
    // Tracking Information
    AllowTracking   : Boolean;    // Has http tracking info.
    TrackingHttp    : String;     // http tracking info.
    // Balances
    DrBal,                        // total of balances
    DrBalOverDue,                 // total of balances in excess of 30 days
    DrBalCur,                     // current balance
    DrBal30,                      //  30 days balance
    DrBal60,                      //  60 days balance
    DrBal90,                      //  90 days balance
    DrBal120,                     // 120 days balance
    DrBal150        : Currency;   // 150 days balance
    DrLatestUpdate,               // last time data was read
    DrLatestTran    : TDateTime;  // latest transaction within read
    AgentCommission : Double;
    OwnCommission   : Double;
    RestrictedCountry : boolean;
  end;
  TvalCompDef = TaidCompDef;

type
  TvalLookedUpCompEvent = procedure(Sender: TObject; DataSource: TDataSource; CompDef: TvalCompDef) of object;

{ Individuals / Contacts }
type
  TaidIndividualDef = packed record
    Found       : Boolean;
    Inc_Indv    : TInc;
    CompNo      : TCompNo;
    FullName    : string;
    Title       : string;
  end;
  TvalIndividualDef = TaidIndividualDef;  { Legacy }
{
  Contract
}
type
  TvalContDef = packed record
    Inc_Cont  : Integer;
    ContNo    : string;
    ContDesc  : string;
    CustNo    : string;
    Found     : boolean;
    Status    : string;
  end;
  TaidContDef = TvalContDef;

{
  Parts
}
type
  { TaidPartSeriesDef
      Part Series Information }
  TaidPartSeriesDef = packed record
    Found: Boolean;
    // Series ID
    SeriesNo,
    SeriesDesc,
    SeriesNote,
    // Templates
    PartDesc,
    PartLong     : String;
    // Defaults
    PartType     : String;
    IsCAD        : Boolean;
    IssueNo      : Integer;
    IsSuspended  : Boolean;
    //
    ItemCategory : String;
  end;
  TvalPartSeriesDef = TaidPartSeriesDef;
type
  { TvalPartDef
      Contains information relavant to a single part or part/parameter combination entry. }
  TvalPartDef = packed record
    { Part Properties info }
    HasPartInfo      : Boolean;      // Contains part info
    HasParamInfo     : Boolean;      // Contains parameter info
    HasOpsInfo       : Boolean;      // Result contains Operation info
    HasPOInfo        : Boolean;      // Contains purchase order info
    IsAdministrative : Boolean;      // Is an administrative part
    IsGeneric        : Boolean;      // Is a generic part
    IsParameterized  : Boolean;      // Is a paramaterized part
    IsAssembled      : Boolean;      // Is an assembled part (refer to HasOpsInfo)
    IsShipping       : Boolean;      // Is this a shipping item. ?
    { Part / Drawing info. }
    PartNo           : TPartNo;      // Part No
    PartParam        : TPartParam;   // Part parameter
    SuppPartNo       : String[30];   // Suppliers part #
    PartVersion      : string[ 1];   // [0]
    Engineer         : String[10];   // Engineer where drawn
    IssueNo          : Integer;      // Part Revision No.
    PartDesc         : string[50];   // Part Description
    PartType         : string[ 5];   // Part Type
    PartTypeDesc     : string[30];   // Part Type Description
    { Replacements }
    ReplacedBy       : TPartNo;      // ReplacedBy Part: PartNo
    ReplacedByParam  : TPartParam;   // ReplacedBy Part: Parameter
    ReplacedByDesc   : string;       // ReplacedBy Part: Description
    ReplacedByOEMNo  : string;       // ReplacedBy Part: OEM #
    { Sales Info }
    SaleNote         : string[128];  // Sales Reminders
    { Technical Info }
    TechMemo         : string;       // Technical Memo - printable on the Purchase Order
    { Stock Info }
    QtyOnHand        : Integer;      // On-hand in site
    LastMovedDte     : TDateTime;    // Last date of movement
    { Accounts }
    Department       : string[ 1];   // [E]lectrical [M]echanical
    SupplyCode       : string[10];   // Supply Code Analysis
    { Intrastat / Export info }
    CountryOfOrigin  : string[10];   // Country Of Origin (can vary per part (and potentially for the same supplier)
    CommodityCode    : string[15];
    { Packaging }
    Packaged         : string[10];   // Package Type (LkpPACKTY)
    PackSize         : Integer;      // Package Size (items in pack)
    DiscPerc         : Single;       // Standard cost
    { Costing Info }
    SuppNo           : string[10];   // suppliers no
    CostSiteNo       : TSiteNo;
    BaseCurrency     : string[10];   // Part costed in currency ?
    PackCostBase     : Currency;     // Package Price
    UnitCostBase,                    // Part price in BaseCurrency
    UnitCostGBP      : Currency;     // Part cost in GBP
    DteCosted        : TDateTime;    // Date part costed
    AvgUnitCostGBP   : Currency;     // Average unit cost £
    StockingType     : String[1];    // [U]nknown *, [S]tock, [B]Consumable (C is call off in AP), [A]SA, [P]urchase */
    DteValidFrom,                    // Date the cost is valid from
    DteValidUntil    : TDateTime;    // Date the cost is valid until
    { Selling Info }
    PriceBand        : string[1];
    UnitSellGBP      : Currency;     // Part selling price (either fixed or calculated)
    IsFixedSellPrice : Boolean;      // Selling price based upon fixed
    UNITSELL_ALT_CURCODE  : string[10];
    UNITSELL_ALT        : Currency;
    { Purchase Order Information }
    QtyOnOrder       : Integer;      // On Order
    LastOrderedDte   : TDateTime;    // Date of last order
    LastUnitCostGBP  : Currency;     // Last order, unit cost GBP
    LastOrderTranNo  : string[10];   // Last order, Purch No
    NextExpectedDte  : TDateTime;    // Next expected delivery: Date
    NextOrderTranNo  : string[10];   // Next expected delivery: Purch No
    { Parameters }
    PartParams       : string;       // List of available parameters ';' separated
    { Operations }
    PartOps          : string;       // List of available operations ';' separated
    master_id        : Tinc;         //item master id, across all items
  end;
  TaidPartDef = TvalPartDef;

  TaidPartDefArg = packed record
    { Arguments to costing }
    PreferenceArgs   : Boolean;      // Has arguments ?
    PreferredSite    : String[ 1];   // Preferred Site
    PreferredSuppNo  : string[10];   // Preferred Supplier
  end;

type
  TvalLookedUpPartEvent =
      procedure(Sender: TObject; DataSource: TDataSource; PartDef: TvalPartDef) of object;
  TvalPartOnGetPartInfoEvent =
      procedure(Sender: TObject; AsPartNo, AsPartParam: string; var APartDef: TvalPartDef) of object;
{ Country Info }
type
  TvalCountry = packed record
    Found           : Boolean;
    CountryNo       : string;
    CountryName     : string;
    TelCode         : string;
    CurrencySupply  : string;
    CurrencySales   : string;
    RegionSales     : string;
  end;
  TaidCountry = TvalCountry;
{}
function FindDocContentType(AsDocType: string; AsUnknown: string = ''): string;
function ExtractFileExtAsDocType(AsFileName: string): string;
function LoadUserAttr(iArg: Integer): TUserAttributes;

{ Contract States **************************************************************************************** }
type { States per Contract }
  TaidContState = ( aidCSDesign, aidCSBuild, aidCSProcure, aidCSActive,  aidCSShipped, aidCSCommissioning, aidCSWarranty, aidCSSpares, AidCsCancelled,
    aidCSInstallation,aidCSExWorks , aidCSAtPackers, aidCSServiceAccepted);
//                ( 'D'           , 'P'       , 'B'         , 'A'       ,'I'                  , 'M'             , 'W'         , 'S'               , 'X'             ,'N'            ,'E'        ,'K',           'C' );
//                  rsCSDesign,   rsCSProcure, rsCSBuild,   rsaidCSActive , rsCSShipped,      rsCSCommissioning,  rsCSWarranty, rsCSSpares,     rsCSCancelled,      rsCSINstallation, rsCSExWorks,  rsCSAtPackers,rsCSServiceAccepted );
  //gv -> Design Build Procure, Test, Strip Down, At Packers, Shipped, Installation, Commissioning Warranty Cancelled

//  TvalContState = TaidContState;
  TaidContractStateRecord = packed record
    Key     : Char;
    Desc    : String;
    Hint    : String;
    BGColor : TColor;
    FGColor : TColor;
  end;
// Contract State
  function ContStateByString (vsArg: string ): TaidContState;
  function ContStateRecByOrd (AeState: TaidContState): TaidContractStateRecord;
  function ContStateRecByKey (AsArg  : String): TaidContractStateRecord;

{ Contract BOM Types ************************************************************************************* }
type
  TaidContractBomType = (aidBTMaster, aidBTCustom);
  TaidContractBomTypeRecord = packed record
    Key     : Char;
    Desc    : String;
    Hint    : String;
    BGColor : TColor;
    FGColor : TColor;
  end;
  function ContractBOMTypeByString(AsArg: string ): TaidContractBomType;
  function ContractBOMTypeByOrd   (AeBOMType: TaidContractBomType): TaidContractBomTypeRecord;
  function ContractBOMTypeByKey   (AsBOMType: String)             : TaidContractBomTypeRecord;

{ Document Content Types  }
type
  TaidDocumentType    = (aidDocTypeUnknown, aidDocTypeDrawing, aidDocTypeScan, aidDocTypeInfo, aidDocTypeDocument, aidDocTypeManual, aidDocTypeCertificate, aidDocTypeLink,aidDocTypePO);
  TaidDocumentTypeRec = packed record
    Key : Char;
    Desc: String;
  end;
const
  CaidDocumentTypes : Array [TaidDocumentType] of TaidDocumentTypeRec =
    ((Key: '?'; Desc: rsUnknown),
     (Key: 'D'; Desc: rsDocDrawing),
     (Key: 'S'; Desc: rsDocScan),
     (Key: 'I'; Desc: rsDocInfo),
     (Key: 'T'; Desc: rsDocDocument),
     (Key: 'M'; Desc: rsDocManual),
     (Key: 'C'; Desc: rsDocCertificate),
     (Key: 'L'; Desc: rsDocLink),
     (Key: 'U'; Desc: rsPurchaseOrder)  );


{ Version Control Types & Consts }
Type
  { TaidCheckoutState
      VCS status of a record }
  TaidCheckoutState = (aidUnlocked, aidCheckedOut, aidUpIssuePending, aidDeletionPending, aidCOAddition,aidCOReset,aidCOUndo, aidCheckedOutEdit );
  TaidCheckoutStateRecord = record
    Key       : Char;
    Hint      : String;
    ColorFG,
    ColorBG   : TColor;
    state     : TaidCheckoutState;
  end;
  PTaidCheckoutStateRecord = ^TaidCheckoutStateRecord;

  EaidVCSException  = class(EaidException);

const
  aidCl_NewItem = $00C000;

function  StringToCheckoutState(AsArg: String): TaidCheckoutState; overload;
function  StringToCheckoutState(AsArg: String; var eResult: TaidCheckoutState): Boolean; overload;
function  CheckoutStateToKey   (AeState: TaidCheckoutState): String;
function  CheckoutStateToHint  (AeState: TaidCheckoutState): String;
function  CheckoutStateRecord  (AeState: TaidCheckoutState): TaidCheckoutStateRecord;
procedure RaiseVCSException(AsMessage: String); overload;
procedure RaiseVCSException(AsMessage: String; const Args: array of const); overload;

{ Change Order originations. (ChangeOrder.ORIGINCONTEXT) (CGR20060503) }
type
  TaidChangeOrderSource = (acosMasterBOM, acosContractBOM);
  TaidChangeOrderSourceRecord = packed record
    Key        : Char;
    ColumnDesc : String;
    LabelDesc  : String;
    Hint       : String;
    FGColor,
    BGColor    : TColor;
  end;
function ChangeOrderSourceOrdByKey(AsSource: String): TaidChangeOrderSource; overload;
function ChangeOrderSourceOrdByKey(AsSource: String; var eResult: TaidChangeOrderSource): Boolean; overload;
function ChangeOrderSourceByOrd   (AeSource: TaidChangeOrderSource): TaidChangeOrderSourceRecord;
function ChangeOrderSourceByKey   (AsSource: String): TaidChangeOrderSourceRecord;

type TAidCOBomSourceCode =   (aidcobSMasterBOM, aidcobSContractBOM);
//     TAidCOBomSourceCodeStr = ('B','CD');
//     TAidCOBomSourceCodeDecript = ('Master Bom','Contract Bom');
     TAidCOBomSourceCodeRec  = packed record
        Key     : String;
        descrip : string;
        enum    : TAidCOBomSourceCode;
      end;

const
     AidCOBomSourceCodeLookups : Array [TAidCOBomSourceCode] of TAidCOBomSourceCodeRec =
    ((Key: 'B'; descrip: 'Master Bom';enum : aidcobSMasterBOM),
     (Key: 'CD'; descrip: 'Contract Bom'; enum : aidcobSContractBOM));



{ Change Order Types & Consts  (CGR20060113) ------------------------------------------------------}
{     Change Order Actions. }
type

  TaidChangeOrderAction  = (aidCO_None, aidCO_ECN, aidCO_ECO, aidCO_FMO,aidCO_DCO);
  TaidChangeOrderActions = set of TaidChangeOrderAction;
  TaidChangeOrderActionRecord = packed record
    Key     : Char;
    Desc    : String;
    Hint    : String;
    Explanation : string;
    FGColor,
    BGColor : TColor;
  end;
resourcestring
  rsUnhandledChangeOrderAction =
    'Unhandled Change Order Action encountered:'#13#10'  (%s)';
function ChangeOrderActionByOrd   (AeState: TaidChangeOrderAction): TaidChangeOrderActionRecord;
function ChangeOrderActionOrdByKey(AsState: String): TaidChangeOrderAction;
function ChangeOrderActionByKey   (AsState: String): TaidChangeOrderActionRecord;
{     Change Order Priorities. }
type
  TaidChangeOrderPriority  = (aidCO_LowPriority, aidCO_NormalPriority, aidCO_HighPriority);
  TaidChangeOrderPriorityRecord = packed record
    PriorityIndex : Integer;
    Desc          : String;
    Hint          : String;
    RptFGColor    : TColor;
    FGColor,
    BGColor       : TColor;
  end;
function ChangeOrderPriorityByOrd   (AePriority: TaidChangeOrderPriority): TaidChangeOrderPriorityRecord;
function ChangeOrderPriorityOrdByKey(AiPriority: Integer): TaidChangeOrderPriority;
function ChangeOrderPriorityByKey   (AiPriority: Integer): TaidChangeOrderPriorityRecord;
{     Change Order Watermarks. }
type
  TaidChangeOrderWatermark  = (aidCO_NoWatermark, aidCO_Action, aidCO_RecordOnly);
  TaidChangeOrderWatermarkRecord = packed record
    Key   : Char;
    Desc  : String;
  end;
function ChangeOrderWatermarkByOrd   (AeWatermarkOrd: TaidChangeOrderWatermark): TaidChangeOrderWatermarkRecord;
function ChangeOrderWatermarkOrdByKey(AcWatermark: Char): TaidChangeOrderWatermark;
function ChangeOrderWatermarkByKey   (AcWatermark: Char): TaidChangeOrderWatermarkRecord;
{--------------------------------------------------------------------------------------------------}

{ Color constants for distinguishing the different modules }
const
  CaidPartModule_Color     = clGreen;
  CaidBOMsModule_Color     = clMaroon;
  CaidContractModule_Color = clOlive;
  CaidSparesModule_Color   = $008F4F4F;
  CaidCompanyModule_Color  = clTeal;
  CaidECN_Colour           = $00d7ffff;//light cyan

{ Models }
type
  TaidBOMModelInfo = packed record
    Model         : TModel;
    Description   : String;
    BuildDuration : TWeeks;
    TestDuration  : TWeeks;
  end;

type
  TaidContractBOMSearch = packed record
    Found    : Boolean;
    ContNo   : TContNo;
    SectNo   : TSectNo;
    BOMNo    : TBOMNo;
    Inc_ContD: TInc;
  end;

const
  CNotificationGroupEMAILItem = 'E';
  CNotificationGroupUserItem  = 'U';


{ Stock Movement (see aidUtil DrawStockMovementDirection()  ) }
type
  TaidStockMovementDirection  = (aidsmInbound, aidsmOutbound, aidsmReserved, aidsmOpeningStock);
  TaidStockMovementDirectionRecord = packed record
    Ord               : TaidStockMovementDirection;
    Key               : Char;
    Desc              : String[30];
    Hint              : String[30];
    ColorFG,
    ColorBG           : TColor;
    IsUserSelectable  : Boolean;
  end;

function StockMovementDirectionByOrd(AeDirection: TaidStockMovementDirection): TaidStockMovementDirectionRecord;
function StockMovementDirectionByKey(AcDirection: Char; out ArStockMovement: TaidStockMovementDirectionRecord): Boolean;
function StockMovementDirectionOrdByKey(AcDirection: String): TaidStockMovementDirection;


{ Bin Types CGR20020321 }
type
  TBinType = (binStock, binASA, binConsumable, binConvert, binContract, binReserved, binTemporary,binInTransit);
  TBinTypes = set of TBinType;
  TBinTypeRecord = packed record
    Key     : TKey1;
    Desc    : TDesc30;
    ColorFG : TColor;
    ColorBG : TColor;
  end;
  function BinTypeRecordByOrd(AeBinType   : TBinType): TBinTypeRecord;
  function BinTypeRecordFromKey(AcBinTypeKey: TKey1; out rBinType: TBinTypeRecord): Boolean;
  function BinTypeFromTypeFromString(Value: string): TBinType;


{ Purchase Enquiries (dataPurch.sql) }
type
  TpoenqLine = (poenqText, poenqPart, poenqBOM, poenqAsm);
const
  CpoenqLineKey  : Array[TpoenqLine] of string = ('F', 'P', 'B', 'A');
  CpoenqLineDesc : Array[TpoenqLine] of string = ('Text', 'Part', 'BOM', 'Assembly');

  function PoEnqLineTypeFromString  (Value: string): TPoEnqLine;
  function PoEnqLineShortFromString (Value: string): String;


implementation

uses
  crUtil;

function FindDocContentType(AsDocType: string; AsUnknown: string = ''): string;
var
  iDocType  : TaidDocumentType;
begin
  if IsEmptyStr(AsUnknown) then Result:= rsUnknown else Result:= AsUnknown;

  for iDocType:= Low(TaidDocumentType) to High(TaidDocumentType) do
    if CaidDocumentTypes[iDocType].Key = AsDocType Then
    begin
      Result:= CaidDocumentTypes[iDocType].Desc;
    end;
end;

function ExtensionAsContentType(AsFileExtension: String): TaidDocumentType;
var
  sExt : string;

  function NotMatchesExtension(out AeResult: TaidDocumentType; const AeMatchResult: TaidDocumentType; const AsExtensions: Array of String): Boolean;
  var
    bMatches  : Boolean;
    iExt      : Integer;
  begin
    bMatches:= False;
    If Length(AsExtensions)>0 Then
      for iExt:= Low(AsExtensions) to High(AsExtensions) do
        if CompareText(AsExtensions[iExt], AsFileExtension) = 0 Then
        begin
          bMatches:= True;
          AeResult:= AeMatchResult;
          Break;
        end;
    //
    Result:= not bMatches;
  end;

begin
  sExt  := ExtractFileExt(AsFileExtension);
  if      NotMatchesExtension(Result, aidDocTypeDrawing,
      ['.dwg', '.dxf', '.dwf', '.idw', '.catPart', '.catProduct', '.catDrawing', '.ipt', '.iam', '.idw']) then
  else if NotMatchesExtension(Result, aidDocTypeScan,        ['.tif', '.tiff', '.101']) then
  else if NotMatchesExtension(Result, aidDocTypeInfo,        ['.pdf']) then
  else if NotMatchesExtension(Result, aidDocTypeDocument,    ['.doc', '.xls', '.txt', '.cdr']) then
  else if NotMatchesExtension(Result, aidDocTypeManual,      []) then
  else if NotMatchesExtension(Result, aidDocTypeCertificate, []) then
  else if NotMatchesExtension(Result, aidDocTypeLink       , ['.lnk', '.xlnk']) then
  else Result:= aidDocTypeUnknown;
end;


function ExtractFileExtAsDocType(AsFileName: string): string;
var
  sTmp  : string;
  iType : TaidDocumentType;
begin
  sTmp  := ExtractFileExt(asFileName);
  iType := ExtensionAsContentType(sTmp);
  Result:= CaidDocumentTypes[iType].Key;
end;

function UserPermissionClassNameByFieldName(AsFieldName: string): string;
var
  iK  : TUserPermissionClass;
begin
  Result:= '';
  for iK:= Low(iK) to High(iK) do
    if CompareText(AsFieldName, CUserPermissionClassFieldName[iK])=0 then
    begin
      Result:= CUserPermissionClass[iK];
      Break;
    end;
end;


function LoadUserAttr(iArg: Integer): TUserAttributes;
var
  iK  : TUserPermissionIndex;
begin
  FillChar(Result, SizeOf(TUserAttributes), #0);
  //
  for iK:= Low(TUserPermissionIndex) to High(TUserPermissionIndex) do
  begin
    Result[iK]:= IsBitSet(iArg, Ord(iK));
  end;
end;


{ ContStateByString    }
function ContStateByString( vsArg: string ): TaidContState;
var
  lcK  : Char;
  liK  : TaidContState;
begin
  Result := aidCSDesign;
  lcK := StringToChar( vsArg );
  for liK := Low( liK ) to High( liK ) do
  begin
    if ContStateRecByOrd(liK).Key = lcK then
    begin
      Result := liK;
      Break;
    end;
  end;
end;


function ContStateRecByOrd (AeState: TaidContState): TaidContractStateRecord;
{ Contract Status Constants }
resourcestring
  rsCSDesign            = 'Design';
  rsCSProcure           = 'Procure';
  rsCSBuild             = 'Build';
  rsaidCSActive         = 'Test'; //was 'Active';
  rsCSShipped           = 'Shipped';
  rsCSCommissioning     = 'Commissioning';
  rsCSWarranty          = 'Warranty';
  rsCSSpares            = 'Spares';
  rsCSCancelled         = 'Cancelled';
  rsCSInstallation      = 'Installation';
  rsCSExWorks           = 'Ex Works';
  rsCSAtPackers         = 'At Packers';
  rsCSServiceAccepted   = 'Strip Down';// was 'Accepted';
  //hints
  rsCSHintDesign        = 'This Contract is in the Design stage only.';
  rsCSHintProcure       = 'This Contract is in the Procure stage and previous stages are still possible.';
  rsCSHintBuild         = 'This Contract is in the Build stage and previous stages are still possible.';
  rsCSHintActive        = 'This Contract is in Test';//Active, all changes will need to be accepted';
  rsCSHintShipped       = 'This Contract is in the Shipped state only.';
  rsCSHintCommissioning = 'This Contract is in the Commissioning stage and previous stages are still possible.';
  rsCSHintWarranty      = 'This Contract is in the Warranty stage and previous stages are still possible.';
  rsCSHintSpares        = 'This Contract is in the Spares stage only.';
  rsCSHintCancelled     = 'This Contract has been cancelled.';
  rsCSHintInstallation  = 'This Contract is being Installed';
  rsCSHintExWorks       = 'This Contract is Ex Works';
  rsCSHintAtPackers     = 'This contract is At the Packers';
  rsCSHintServiceAccepted = 'Strip Down';

Const
  CaidContState       : Array[TaidContState ] of char   = ( 'D', 'P', 'B', 'A','I', 'M', 'W', 'S', 'X','N','E','K','C' );
  CaidContStateDesc   : Array[TaidContState ] of string = ( rsCSDesign, rsCSProcure, rsCSBuild,rsaidCSActive , rsCSShipped, rsCSCommissioning, rsCSWarranty, rsCSSpares, rsCSCancelled, rsCSINstallation,rsCSExWorks,rsCSAtPackers,rsCSServiceAccepted );
  CaidContStateHint   : Array[TaidContState ] of string = ( rsCSHintDesign, rsCSHintProcure, rsCSHintBuild,rsCSHintActive, rsCSHintShipped, rsCSHintCommissioning, rsCSHintWarranty, rsCSHintSpares, rsCSHintCancelled ,rsCSHintInstallation,rsCSHintExWorks,rsCSHintAtPackers,rsCSHintServiceAccepted);
  CaidContStateBGColor: Array[TaidContState ] of TColor = ( clWhite, clYellow, clSkyBlue, clRed  ,clRed  , clLime , clTeal , clMoneyGreen, clOlive, clGreen  ,clRed ,clRed,$FF6600);
  CaidContStateFGColor: Array[TaidContState ] of TColor = ( clBlack, clBlack , clBlack  , clWhite,clWhite, clBlack, clBlack, clBlack     , clBlack ,clBlack, ClBlack , ClBlack , ClBlack);
begin
  FillChar(Result, SizeOf(TaidContractStateRecord), #0);
  Result.Key    := CaidContState       [AeState];
  Result.Desc   := CaidContStateDesc   [AeState];
  Result.Hint   := CaidContStateHint   [AeState];
  Result.BGColor:= CaidContStateBGColor[AeState];
  Result.FGColor:= CaidContStateFGColor[AeState];
end;


function ContStateRecByKey(AsArg: String): TaidContractStateRecord;
begin
  Result:= ContStateRecByOrd(ContStateByString(AsArg));
end;


function  StringToCheckoutState(AsArg: String; var eResult: TaidCheckoutState): Boolean; overload;
var
  eK  : TaidCheckoutState;
begin
  Result:= False;
  for eK:= Low(TaidCheckoutState) to High(TaidCheckoutState) do
    if (CheckoutStateRecord(eK).Key = AsArg) then
    begin
      eResult:= eK;
      Result := True;
      Break;
    end;
end;


function StringToCheckoutState(AsArg: String): TaidCheckoutState;
var
  eK  : TaidCheckoutState;
begin
  Result:= aidUnlocked;
  if StringToCheckoutState(AsArg, eK) then
    Result:= eK;
end;

function CheckoutStateToKey(AeState: TaidCheckoutState): String;
begin
  Result:= CheckoutStateRecord(AeState).Key;
//  Result:= CaidCheckoutStateKey [AeState];
end;

function CheckoutStateToHint(AeState: TaidCheckoutState): String;
begin
  Result:= CheckoutStateRecord(AeState).Hint;
//  Result:= CaidCheckoutStateDesc[];
end;

function  CheckoutStateRecord  (AeState: TaidCheckoutState): TaidCheckoutStateRecord;
const
  CaidCheckoutStateKey : Array[TaidCheckoutState] of Char   = ('U', 'O', 'P', 'D', 'A' , 'R' ,'S', 'E');
  CaidCheckoutStateHint: Array[TaidCheckoutState] of String = ('Checked in', 'Checked out', 'Pending up-issue', 'Pending Deletion','New Item','Reset, pending applied','Undo Check Out','Check Out Edited');
  CaidCheckoutColorBG  : Array[TaidCheckoutState] of TColor = (clWindow    , clBlack, clYellow, clRed  , aidCl_NewItem,clAqua,clAqua ,clYellow );
  CaidCheckoutColorFG  : Array[TaidCheckoutState] of TColor = (clWindowText, clWhite, clBlack , clWhite, clGreen, clBlack,clBlack ,clBlack );
begin
  FillChar(Result, SizeOf(Result), #0);
  Result.Key    := CaidCheckoutStateKey [AeState];
  Result.Hint   := CaidCheckoutStateHint[AeState];
  Result.ColorFG:= CaidCheckoutColorFG  [AeState];
  Result.ColorBG:= CaidCheckoutColorBG  [AeState];
  Result.state  := AeState;
end;


procedure RaiseVCSException(AsMessage: String);
begin
  raise EaidVCSException.Create(AsMessage);
end;

procedure RaiseVCSException(AsMessage: String; const Args: array of const);
begin
  raise EaidVCSException.CreateFmt(AsMessage, Args);
end;

function ContractBOMTypeByString(AsArg: string ): TaidContractBomType;
var
  cK  : Char;
  iK  : TaidContractBomType;
begin
  Result := aidBTCustom;
  cK := StringToChar(AsArg);
  for iK := Low(TaidContractBomType) to High(TaidContractBomType) do
    if ContractBOMTypeByOrd(iK).Key = cK then
    begin
      Result := iK;
      Break;
    end;
end;


function ContractBOMTypeByOrd(AeBOMType: TaidContractBomType): TaidContractBomTypeRecord;
resourcestring
  rsContractBomTypeMasterDesc = 'Master';
  rsContractBomTypeCustomDesc = 'Custom';
  rsContractBomTypeMasterHint = 'Based upon a Master BOM Issue.';
  rsContractBomTypeCustomHint = 'Customised BOM';
Const { Contract BOM Type constants }
  CaidContBomTypeKey    : Array[TaidContractBomType ] of char   = ( 'A', 'C');
  CaidContBomTypeDesc   : Array[TaidContractBomType ] of string = ( rsContractBomTypeMasterDesc, rsContractBomTypeCustomDesc);
  CaidContBomTypeHint   : Array[TaidContractBomType ] of string = ( rsContractBomTypeMasterHint, rsContractBomTypeCustomHint);
  CaidContBomTypeBGColor: Array[TaidContractBomType ] of TColor = ( CaidBOMsModule_Color, CaidContractModule_Color );
  CaidContBomTypeFGColor: Array[TaidContractBomType ] of TColor = ( clWhite , clWhite );
begin
  FillChar(Result, SizeOf(TaidContractBomTypeRecord), #0);
  Result.Key    := CaidContBomTypeKey    [AeBOMType];
  Result.Desc   := CaidContBomTypeDesc   [AeBOMType];
  Result.Hint   := CaidContBomTypeHint   [AeBOMType];
  Result.BGColor:= CaidContBomTypeBGColor[AeBOMType];
  Result.FGColor:= CaidContBomTypeFGColor[AeBOMType];
end;

function ContractBOMTypeByKey(AsBOMType: String): TaidContractBomTypeRecord;
begin
  Result:= ContractBOMTypeByOrd(ContractBOMTypeByString(AsBOMType));
end;



{resourcestring
  rsUnhandledChangeOrderAction =
    'Unhandled Change Order Action encountered:'#13#10'  (%s)';}
function ChangeOrderSourceByOrd(AeSource: TaidChangeOrderSource): TaidChangeOrderSourceRecord;
const
  CChangeOrderSourceKey       : Array[TaidChangeOrderSource] of Char   = ('B', 'C');
  CChangeOrderSourceColumnDesc: Array[TaidChangeOrderSource] of String = ('M', 'C');
  CChangeOrderSourceLabelDesc : Array[TaidChangeOrderSource] of String = ('Master', 'Contract');
  CChangeOrderSourceHint      : Array[TaidChangeOrderSource] of String = ('Master BOM', 'Contract BOM');
  CChangeOrderSourceBG        : Array[TaidChangeOrderSource] of TColor = (clMaroon, clOlive);
  CChangeOrderSourceFG        : Array[TaidChangeOrderSource] of TColor = (clWhite , clWhite  );
begin
  FillChar(Result, SizeOf(TaidChangeOrderSourceRecord), #0);
  Result.Key       := CChangeOrderSourceKey       [AeSource];
  Result.ColumnDesc:= CChangeOrderSourceColumnDesc[AeSource];
  Result.LabelDesc := CChangeOrderSourceLabelDesc [AeSource];
  Result.Hint      := CChangeOrderSourceHint      [AeSource];
  Result.BGColor   := CChangeOrderSourceBG        [AeSource];
  Result.FGColor   := CChangeOrderSourceFG        [AeSource];
end;

function ChangeOrderSourceOrdByKey(AsSource: String; var eResult: TaidChangeOrderSource): Boolean; 
var
  eK  : TaidChangeOrderSource;
begin
  Result := False;
  eResult:= Low(TaidChangeOrderSource);
  //
  for eK:= Low(TaidChangeOrderSource) to High(TaidChangeOrderSource) do
    if ChangeOrderSourceByOrd(eK).Key = AsSource then
    begin
      eResult:= eK;
      Result := True;
      Break;
    end;
end;

function ChangeOrderSourceOrdByKey(AsSource: String): TaidChangeOrderSource;
begin
  ChangeOrderSourceOrdByKey(AsSource, Result);
end;

function ChangeOrderSourceByKey(AsSource: String): TaidChangeOrderSourceRecord;
var
  eK  : TaidChangeOrderSource;
begin
  FillChar(Result, SizeOf(TaidChangeOrderSourceRecord), #0);
  Result.BGColor:= clWindow;
  Result.FGColor:= clWindowText;
  {}
  if ChangeOrderSourceOrdByKey(AsSource, eK) then
    Result:= ChangeOrderSourceByOrd( eK);
end;


function ChangeOrderActionByOrd (AeState: TaidChangeOrderAction): TaidChangeOrderActionRecord;
const
  CChangeOrderActionKey : Array[TaidChangeOrderAction] of Char   = (#0,'A' ,'E', 'F','D');
  CChangeOrderActionDesc: Array[TaidChangeOrderAction] of String = ('n/a','ECN', 'ECO', 'FMO','DCO');
  CChangeOrderActionHint: Array[TaidChangeOrderAction] of String = ('','Engineering Change Note', 'Engineering Change Order', 'Field Modification Order','Design Change Order');
  CChangeOrderActionExplanation: Array[TaidChangeOrderAction] of String = ('', 'Machine IN Design', 'Machine IN factory', 'Machine HAS LEFT factory','Part IN design');
  CChangeOrderActionBG  : Array[TaidChangeOrderAction] of TColor = (clWhite, CaidECN_Colour, CaidContractModule_Color, CaidSparesModule_Color,clCream);
  CChangeOrderActionFG  : Array[TaidChangeOrderAction] of TColor = (clGray , clBlack,         clWhite                 , clWhite  ,       clBlack);
begin
  FillChar(Result, SizeOf(TaidChangeOrderActionRecord), #0);
  Result.Key    := CChangeOrderActionKey [AeState];
  Result.Desc   := CChangeOrderActionDesc[AeState];
  Result.Hint   := CChangeOrderActionHint[AeState];
  Result.BGColor:= CChangeOrderActionBG  [AeState];
  Result.FGColor:= CChangeOrderActionFG  [AeState];
  Result.Explanation := CChangeOrderActionExplanation[AeState];
end;


function ChangeOrderActionOrdByKey(AsState: String): TaidChangeOrderAction;
var
  eK  : TaidChangeOrderAction;
begin
  Result:= Low(TaidChangeOrderAction);
  for eK:= Low(TaidChangeOrderAction) to High(TaidChangeOrderAction) do
  begin
    if ChangeOrderActionByOrd(eK).Key = AsState then
    begin
      Result:= eK;
      Break;
    end;
  end;
end;

function ChangeOrderActionByKey(AsState: String): TaidChangeOrderActionRecord;
begin
  Result:= ChangeOrderActionByOrd( ChangeOrderActionOrdByKey(AsState) );
end;

function ChangeOrderPriorityByOrd(AePriority: TaidChangeOrderPriority): TaidChangeOrderPriorityRecord;
const
  CChangeOrderPriorityKey : Array[TaidChangeOrderPriority] of Integer= (-5, 0, +5);
  CChangeOrderPriorityDesc: Array[TaidChangeOrderPriority] of String = ('Low', 'Normal', 'Urgent');
  CChangeOrderPriorityHint: Array[TaidChangeOrderPriority] of String = ('Low Priority', 'Normal Priority', 'High Priority (Urgent)');
  CChangeOrderPriorityRptFG
                          : Array[TaidChangeOrderPriority] of TColor = (clGreen , clWhite, clRed  );
  CChangeOrderPriorityBG  : Array[TaidChangeOrderPriority] of TColor = (clGreen , clWhite, clRed  );
  CChangeOrderPriorityFG  : Array[TaidChangeOrderPriority] of TColor = (clYellow, clGray , clWhite);
begin
  FillChar(Result, SizeOf(TaidChangeOrderPriorityRecord), #0);

  Result.PriorityIndex:= CChangeOrderPriorityKey  [AePriority];
  Result.Desc         := CChangeOrderPriorityDesc [AePriority];
  Result.Hint         := CChangeOrderPriorityHint [AePriority];
  Result.RptFGColor   := CChangeOrderPriorityRptFG[AePriority];
  Result.FGColor      := CChangeOrderPriorityFG   [AePriority];
  Result.BGColor      := CChangeOrderPriorityBG   [AePriority];
end;

function ChangeOrderPriorityOrdByKey(AiPriority: Integer): TaidChangeOrderPriority;
var
  eK  : TaidChangeOrderPriority;
begin
  Result:= aidCO_NormalPriority;
  for eK:= Low(TaidChangeOrderPriority) to High(TaidChangeOrderPriority) do
  begin
    if (ChangeOrderPriorityByOrd(eK).PriorityIndex = AiPriority) then
    begin
      Result:= eK;
      Break;
    end;
  end;
end;

function ChangeOrderPriorityByKey(AiPriority: Integer): TaidChangeOrderPriorityRecord;
begin
  Result:= ChangeOrderPriorityByOrd( ChangeOrderPriorityOrdByKey(AiPriority) );
end;


function ChangeOrderWatermarkByOrd   (AeWatermarkOrd: TaidChangeOrderWatermark): TaidChangeOrderWatermarkRecord;
const
  CChangeOrderWatermarkKey : Array[TaidChangeOrderWatermark] of Char   = (#0, 'A', 'R');
  CChangeOrderWatermarkDesc: Array[TaidChangeOrderWatermark] of String = ('', 'Action', 'Record'#13#10+'only');
begin
  FillChar(Result, SizeOf(TaidChangeOrderWatermarkRecord), #0);

  Result.Key          := CChangeOrderWatermarkKey  [AeWatermarkOrd];
  Result.Desc         := CChangeOrderWatermarkDesc [AeWatermarkOrd];
end;

function ChangeOrderWatermarkOrdByKey(AcWatermark: Char): TaidChangeOrderWatermark;
var
  eK  : TaidChangeOrderWatermark;
begin
  Result:= aidCO_NoWatermark;
  for eK:= Low(TaidChangeOrderWatermark) to High(TaidChangeOrderWatermark) do
  begin
    if (ChangeOrderWatermarkByOrd(eK).Key = AcWatermark) then
    begin
      Result:= eK;
      Break;
    end;
  end;
end;

function ChangeOrderWatermarkByKey(AcWatermark: Char): TaidChangeOrderWatermarkRecord;
begin
  Result:= ChangeOrderWatermarkByOrd(ChangeOrderWatermarkOrdByKey(AcWatermark));
end;


{ StockMovementDirectionByOrd
    Returns a definition for a stock movement transaction direction. }
function StockMovementDirectionByOrd(AeDirection: TaidStockMovementDirection): TaidStockMovementDirectionRecord;
{ see dataStock.sql (StockTran) [I]nbound, [O]utbound, [R]eserved, [A]bsolute (Opening Stock) }
const
  rsStockMovementInbound  = 'Inbound';
  rsStockMovementOutbound = 'Outbound';
  rsStockMovementReserved = 'Reserved';
  rsStockMovementOpening  = 'Opening';
const
  CaidStockMovementDirectionKey     : Array[TaidStockMovementDirection] of Char
    = ('I', 'O', 'R', 'A');
  CaidStockMovementDirectionHint    : Array[TaidStockMovementDirection] of String[30]
    = (rsStockMovementInbound, rsStockMovementOutbound, rsStockMovementReserved, rsStockMovementOpening);
  CaidStockMovementDirectionDesc    : Array[TaidStockMovementDirection] of String[30]
    = (rsStockMovementInbound, rsStockMovementOutbound, rsStockMovementReserved, rsStockMovementOpening);
  CaidStockMovementDirectionColorBG : Array[TaidStockMovementDirection] of TColor
    = (clGreen , clRed  , clTeal , clBlack);
  CaidStockMovementDirectionColorFG : Array[TaidStockMovementDirection] of TColor
    = (clYellow, clWhite, clWhite, clWhite);
  CaidStockMovementDirectionIsUserSelectable : Array[TaidStockMovementDirection] of Boolean
    = (True, True, False, False);
begin
  FillChar(Result, SizeOf(TaidStockMovementDirectionRecord), #0);
  Result.Ord              := AeDirection;
  Result.Key              := CaidStockMovementDirectionKey             [AeDirection];
  Result.Desc             := CaidStockMovementDirectionDesc            [AeDirection];
  Result.Hint             := CaidStockMovementDirectionHint            [AeDirection];
  Result.ColorBG          := CaidStockMovementDirectionColorBG         [AeDirection];
  Result.ColorFG          := CaidStockMovementDirectionColorFG         [AeDirection];
  Result.IsUserSelectable := CaidStockMovementDirectionIsUserSelectable[AeDirection];
end;


function StockMovementDirectionByKey(AcDirection: Char; out ArStockMovement: TaidStockMovementDirectionRecord): Boolean;
var
  eK  : TaidStockMovementDirection;
begin
  Result:= False;
  FillChar(ArStockMovement, SizeOf(TaidStockMovementDirectionRecord), #0);
  {}
  for eK:= Low(TaidStockMovementDirection) to High(TaidStockMovementDirection) do
    if StockMovementDirectionByOrd(eK).Key = AcDirection then
    begin
      ArStockMovement:= StockMovementDirectionByOrd(eK);
      Result:= True;
      Break;
    end;
end;


function StockMovementDirectionOrdByKey(AcDirection: String): TaidStockMovementDirection;
var
  eK  : TaidStockMovementDirection;
begin
  Result:= aidsmInbound;
  for eK:= Low(TaidStockMovementDirection) to High(TaidStockMovementDirection) do
    if StockMovementDirectionByOrd(eK).Key = AcDirection then
    begin
      Result:= eK;
      Break;
    end;
end;


function BinTypeFromTypeFromString(Value: string): TBinType;
var
  eK  : TBinType;
begin
  Result:= binTemporary;
  for eK:= Low(TBinType) to High(TBinType) do
  if SameText(BinTypeRecordByOrd(eK).Key, Value) then
  begin
    Result:= eK;
    Break;
  end;
end;


function BinTypeRecordByOrd(AeBinType: TBinType): TBinTypeRecord;
const
  CBinTypeKey   : Array [TBinType] of string = ('S', 'A', 'O', 'V', 'C', 'R', 'T','I');
  CBinTypeDesc  : Array [TBinType] of string = ('Stock', 'ASA', 'cOnsumable', 'conVerting', 'Contract', 'Reserved', 'Temporary','In Transit');
  CBinTypeBG    : Array [TBinType] of TColor =
    (clYellow, clPurple, clPurple, clMaroon, clOlive, clTeal , clCream, clCream);
  CBinTypeFG    : Array [TBinType] of TColor =
    (clBlack , clWhite,  clYellow, clWhite,  clWhite, clWhite, clBlack, clBlack);
begin
  FillChar(Result, SizeOf(Result), #0);
  Result.Key    := copy(CBinTypeKey [AeBinType],1,1)[1];
  Result.Desc   := copy(CBinTypeDesc[AeBinType],1,30);
  Result.ColorFG:= CBinTypeFG  [AeBinType];
  Result.ColorBG:= CBinTypeBG  [AeBinType];
end;


function BinTypeRecordFromKey(AcBinTypeKey: TKey1; out rBinType: TBinTypeRecord): Boolean;
var
  eK    : TBinType;
  rTmp  : TBinTypeRecord;
begin
  Result:= False;
  FillChar(rBinType, SizeOf(rBinType), #0);
  {}
  for eK:= Low(TBinType) to High(TBinType) do
  begin
    rTmp:= BinTypeRecordByOrd(eK);
    if rTmp.Key = AcBinTypeKey then
    begin
      rBinType:= rTmp;
      Result  := True;
    end;
  end;
end;


function PoEnqLineTypeFromString  (Value: string): TPoEnqLine;
var
  iK  : TpoenqLine;
begin
  Result:= poenqPart;
  for iK:= Low(TpoenqLine) to High(TpoenqLine) do
    if Value = CpoenqLineKey[iK] then
    begin
      Result:= iK;
      break;
    end;
end;

function PoEnqLineShortFromString (Value: string): String;
begin
  Result:= '';
  if not IsEmptyStr(Value) then
    Result:= CpoenqLineDesc[PoEnqLineTypeFromString(Value)];
end;


Initialization

Finalization

end.
