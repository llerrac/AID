object ModAid: TModAid
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 400
  Top = 322
  Height = 152
  Width = 309
  object ibTran: TIB_Transaction
    Isolation = tiCommitted
    Left = 15
    Top = 5
  end
  object qryPurch: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsTranNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT '
      '  pm.SuppNo, su.CompName as SuppName,'
      '  pm.TranSite, '
      '  pm.TranNo, pm.TranRef, pm.SuppRef, '
      '  pm.Inc_Purch,'
      '  pm.TranDte, '
      '  pm.TranUser, um.UserLong as TranUserDesc,'
      '  pm.TranStatus, '
      '  L1.Desc_Lk as TranStatusDesc, L1.Log2 as IsCompleted,'
      '  pm.DeliverySite, '
      '  pm.DeliveryWare,'
      '  pm.Expected'
      'FROM '
      '  PurchMast pm'
      'LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)'
      'LEFT JOIN Users um ON (pm.TranUser = um.UserName)'
      
        'LEFT JOIN Lookups L1 ON (pm.TranStatus = L1.Key_Lk) and (l1.Grou' +
        'p_Lk = '#39'POSTAT'#39')'
      'WHERE (pm.TranNo = :AsTranNo)')
    FieldOptions = []
    OptionsEx = []
    Left = 65
    Top = 5
    object qryPurchINC_PURCH: TIntegerField
      FieldName = 'INC_PURCH'
      Origin = 'PURCHMAST.INC_PURCH'
      Required = True
    end
    object qryPurchTRANNO: TStringField
      DisplayLabel = 'Order #'
      DisplayWidth = 11
      FieldName = 'TRANNO'
      Size = 10
    end
    object qryPurchSUPPNO: TStringField
      DisplayLabel = 'Supplier #'
      DisplayWidth = 8
      FieldName = 'SUPPNO'
      Visible = False
      Size = 10
    end
    object qryPurchSUPPNAME: TStringField
      DisplayLabel = 'Supplier'
      DisplayWidth = 30
      FieldName = 'SUPPNAME'
      Size = 50
    end
    object qryPurchTRANSITE: TStringField
      Alignment = taCenter
      DisplayLabel = 'Ste'
      DisplayWidth = 3
      FieldName = 'TRANSITE'
      Size = 1
    end
    object qryPurchTRANREF: TStringField
      DisplayLabel = 'Contract/CC'
      DisplayWidth = 10
      FieldName = 'TRANREF'
    end
    object qryPurchSUPPREF: TStringField
      DisplayLabel = 'Supplier Ref.:'
      DisplayWidth = 10
      FieldName = 'SUPPREF'
    end
    object qryPurchTRANDTE: TDateTimeField
      DisplayLabel = 'Ordered'
      DisplayWidth = 10
      FieldName = 'TRANDTE'
    end
    object qryPurchTRANUSER: TStringField
      FieldName = 'TRANUSER'
      Visible = False
      Size = 15
    end
    object qryPurchTRANUSERDESC: TStringField
      DisplayLabel = 'Ordered By'
      DisplayWidth = 15
      FieldName = 'TRANUSERDESC'
      Size = 50
    end
    object qryPurchTRANSTATUS: TStringField
      FieldName = 'TRANSTATUS'
      Visible = False
      Size = 10
    end
    object qryPurchTRANSTATUSDESC: TStringField
      DisplayLabel = 'Status'
      DisplayWidth = 15
      FieldName = 'TRANSTATUSDESC'
      Size = 30
    end
    object qryPurchDELIVERYSITE: TStringField
      DisplayLabel = 'Site'
      FieldName = 'DELIVERYSITE'
      Visible = False
      Size = 1
    end
    object qryPurchDELIVERYWARE: TStringField
      DisplayLabel = 'Ware'
      FieldName = 'DELIVERYWARE'
      Visible = False
      Size = 4
    end
    object qryPurchEXPECTED: TDateTimeField
      DisplayLabel = 'Expected'
      DisplayWidth = 10
      FieldName = 'EXPECTED'
    end
    object qryPurchISCOMPLETED: TStringField
      FieldName = 'ISCOMPLETED'
      Visible = False
      Size = 1
    end
  end
  object qryComp: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsCompNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  CompNo, CompName, '
      '  CompTelPre, CompTelNo,'
      '  CompFaxPre, CompFaxNo,'
      '  CompEmail, '
      '  LocCountry, LocAddress, LocPC, LocCountryName,'
      '  CurrencySupply, ValidSupplySites, '
      '  CurrencySales, ValidSalesSites, '
      '  IssuePurchaseLabels, '
      '  DivisionSales, SalesPrompt,'
      '  AllowTracking, TrackingHttp,'
      '  DrLatestUpdate, DrLatestTran, DrBal, DrBalOverdue,'
      '  DrBalCur, DrBal30 , DrBal60 ,'
      '  DrBal90 , DrBal120, DrBal150, '
      '  AgentCommission, OwnCommission, AgentNo'
      ',O_RESTRICTED_COUNTRY'
      'FROM'
      '  PROC_Comp_GetSummary (:AsCompNo)')
    FieldOptions = []
    OptionsEx = []
    Left = 125
    Top = 5
    object qryCompCOMPNO: TStringField
      FieldName = 'COMPNO'
      Size = 10
    end
    object qryCompCOMPNAME: TStringField
      FieldName = 'COMPNAME'
      Size = 50
    end
    object qryCompCOMPTELPRE: TStringField
      FieldName = 'COMPTELPRE'
      Size = 10
    end
    object qryCompCOMPTELNO: TStringField
      FieldName = 'COMPTELNO'
      Size = 30
    end
    object qryCompCOMPFAXPRE: TStringField
      FieldName = 'COMPFAXPRE'
      Size = 10
    end
    object qryCompCOMPFAXNO: TStringField
      FieldName = 'COMPFAXNO'
      Size = 30
    end
    object qryCompCOMPEMAIL: TStringField
      FieldName = 'COMPEMAIL'
      Size = 50
    end
    object qryCompLOCCOUNTRY: TStringField
      FieldName = 'LOCCOUNTRY'
      Size = 10
    end
    object qryCompLOCADDRESS: TStringField
      FieldName = 'LOCADDRESS'
      Size = 180
    end
    object qryCompLOCPC: TStringField
      FieldName = 'LOCPC'
    end
    object qryCompLOCCOUNTRYNAME: TStringField
      FieldName = 'LOCCOUNTRYNAME'
      Size = 50
    end
    object qryCompCURRENCYSUPPLY: TStringField
      FieldName = 'CURRENCYSUPPLY'
      Origin = 'PROC_COMP_GETSUMMARY.SUPPLYCURRENCY'
      Size = 10
    end
    object qryCompVALIDSUPPLYSITES: TStringField
      FieldName = 'VALIDSUPPLYSITES'
      Origin = 'PROC_COMP_GETSUMMARY.VALIDSUPPLYSITES'
      Size = 26
    end
    object qryCompIssuePurchaseLabels: TStringField
      FieldName = 'IssuePurchaseLabels'
      Size = 1
    end
    object qryCompCURRENCYSALES: TStringField
      FieldName = 'CURRENCYSALES'
      Origin = 'PROC_COMP_GETSUMMARY.SALESCURRENCY'
      Size = 10
    end
    object qryCompVALIDSALESSITES: TStringField
      FieldName = 'VALIDSALESSITES'
      Origin = 'PROC_COMP_GETSUMMARY.VALIDSALESSITES'
      Size = 26
    end
    object qryCompDIVISIONSALES: TStringField
      FieldName = 'DIVISIONSALES'
      Origin = 'PROC_COMP_GETSUMMARY.DIVISIONSALES'
      Size = 8
    end
    object qryCompSALESPROMPT: TMemoField
      FieldName = 'SALESPROMPT'
      Origin = 'PROC_COMP_GETSUMMARY.SALESPROMPT'
      BlobType = ftMemo
      Size = 8
    end
    object qryCompALLOWTRACKING: TStringField
      FieldName = 'ALLOWTRACKING'
      Origin = 'PROC_COMP_GETSUMMARY.ALLOWTRACKING'
      FixedChar = True
      Size = 1
    end
    object qryCompTRACKINGHTTP: TStringField
      FieldName = 'TRACKINGHTTP'
      Origin = 'PROC_COMP_GETSUMMARY.TRACKINGHTTP'
      Size = 128
    end
    object qryCompDRLATESTUPDATE: TDateTimeField
      DisplayLabel = 'Last Update'
      FieldName = 'DRLATESTUPDATE'
      Origin = 'PROC_COMP_GETSUMMARY.DRLATESTUPDATE'
      DisplayFormat = 'ddddd'
    end
    object qryCompDRLATESTTRAN: TDateTimeField
      DisplayLabel = 'Latest Tran.'
      FieldName = 'DRLATESTTRAN'
      Origin = 'PROC_COMP_GETSUMMARY.DRLATESTTRAN'
      DisplayFormat = 'ddddd'
    end
    object qryCompDRBAL: TFloatField
      DisplayLabel = 'Balance'
      FieldName = 'DRBAL'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBALCUR: TFloatField
      DisplayLabel = 'Current'
      FieldName = 'DRBALCUR'
      Origin = 'PROC_COMP_GETSUMMARY.DRBALCUR'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBAL30: TFloatField
      DisplayLabel = '30 Days'
      FieldName = 'DRBAL30'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL30'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBAL60: TFloatField
      DisplayLabel = '60 Days'
      FieldName = 'DRBAL60'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL60'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBAL90: TFloatField
      DisplayLabel = '90 Days'
      FieldName = 'DRBAL90'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL90'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBAL120: TFloatField
      DisplayLabel = '120 Days'
      FieldName = 'DRBAL120'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL120'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBAL150: TFloatField
      DisplayLabel = '150 Days'
      FieldName = 'DRBAL150'
      Origin = 'PROC_COMP_GETSUMMARY.DRBAL150'
      DisplayFormat = ',0.00'
    end
    object qryCompDRBALOVERDUE: TFloatField
      DisplayLabel = 'Overdue'
      FieldName = 'DRBALOVERDUE'
      Origin = 'PROC_COMP_GETSUMMARY.DRBALOVERDUE'
      DisplayFormat = ',0.00'
    end
    object qryCompAGENTCOMMISSION: TIBOBCDField
      FieldName = 'AGENTCOMMISSION'
      Origin = 'PROC_COMP_GETSUMMARY.AGENTCOMMISSION'
      Precision = 9
      Size = 3
    end
    object qryCompOWNCOMMISSION: TIBOBCDField
      FieldName = 'OWNCOMMISSION'
      Origin = 'PROC_COMP_GETSUMMARY.OWNCOMMISSION'
      Precision = 9
      Size = 3
    end
    object qryCompAGENTNO: TStringField
      FieldName = 'AGENTNO'
      Size = 10
    end
    object qryCompO_RESTRICTED_COUNTRY: TStringField
      FieldName = 'O_RESTRICTED_COUNTRY'
      Size = 1
    end
  end
  object qryPart: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPartParam'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPartOp'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPrefSite'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPrefSupp'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AnWeight'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  HasPartInfo, HasParamInfo, HasPOInfo, HasOpsInfo,'
      
        '  IsAdministrative, IsGeneric, IsParameterized, IsAssembled, IsS' +
        'hipping, '
      '  PartVersion,  IssueNo, Key_Eng,'
      '  NeedManualParams, NeedManualOps,'
      '  SuppNo, SuppPartNo, PartNo, PartParam,'
      '  PartDesc, PartType, PartTypeDesc, '
      '  Packaged, PackSize, DiscPerc, '
      '  ReplacedBy, ReplacedByParam, ReplacedByDesc, ReplacedByOEMNo,'
      '  SaleNote, QtyOnHand, '
      '  LastMovedDte, Department, SupplyCode, '
      '  CostSite,'
      '  BaseCurrency, PackCostBase, UnitCostBase,  '
      '  PriceBand, '
      '  CommodityCode, CountryOfOrigin, '
      '  UnitSellGBP, IsFixedSellPrice,'
      '  UnitCostGBP, DteCosted, OnOrder, '
      '  LastOrdered, LastUnitCostGBP, LastOrderTranNo, '
      '  NextExpected, NextOrderTranNo, '
      '  AvgUnitCostGBP,'
      '  StockingType,'
      '  DteValidFrom, DteValidUntil,'
      '  ParamsForPart,'
      '  OpsForPart, TechMemo'
      'FROM'
      
        '  PROC_Part_GetInfo (:AsPartNo, :AsPartParam, :AsPartOp, :AsPref' +
        'Site, :AsPrefSupp, :AnWeight)')
    FieldOptions = []
    OptionsEx = []
    Left = 65
    Top = 60
    object qryPartHASPARTINFO: TStringField
      FieldName = 'HASPARTINFO'
      Size = 1
    end
    object qryPartHASPARAMINFO: TStringField
      FieldName = 'HASPARAMINFO'
      Size = 1
    end
    object qryPartHASPOINFO: TStringField
      FieldName = 'HASPOINFO'
      Size = 1
    end
    object qryPartHASOPSINFO: TStringField
      FieldName = 'HASOPSINFO'
      Size = 1
    end
    object qryPartISADMINISTRATIVE: TStringField
      FieldName = 'ISADMINISTRATIVE'
      Size = 1
    end
    object qryPartISGENERIC: TStringField
      FieldName = 'ISGENERIC'
      Size = 1
    end
    object qryPartISPARAMETERIZED: TStringField
      FieldName = 'ISPARAMETERIZED'
      Size = 1
    end
    object qryPartISASSEMBLED: TStringField
      FieldName = 'ISASSEMBLED'
      Size = 1
    end
    object qryPartIsShipping: TStringField
      FieldName = 'IsShipping'
      Size = 1
    end
    object qryPartPARTVERSION: TStringField
      FieldName = 'PARTVERSION'
      Size = 1
    end
    object qryPartKey_Eng: TStringField
      FieldName = 'Key_Eng'
      Size = 10
    end
    object qryPartISSUENO: TIntegerField
      FieldName = 'ISSUENO'
      Origin = 'PROC_PART_GETINFO.ISSUENO'
      Visible = False
    end
    object qryPartNEEDMANUALPARAMS: TStringField
      FieldName = 'NEEDMANUALPARAMS'
      Size = 1
    end
    object qryPartNEEDMANUALOPS: TStringField
      FieldName = 'NEEDMANUALOPS'
      Size = 1
    end
    object qryPartSUPPNO: TStringField
      FieldName = 'SUPPNO'
      Size = 10
    end
    object qryPartSUPPPARTNO: TStringField
      FieldName = 'SUPPPARTNO'
      Size = 30
    end
    object qryPartPARTNO: TStringField
      FieldName = 'PARTNO'
      Size = 10
    end
    object qryPartPARTPARAM: TStringField
      FieldName = 'PARTPARAM'
      Size = 10
    end
    object qryPartPARTDESC: TStringField
      FieldName = 'PARTDESC'
      Size = 50
    end
    object qryPartPARTTYPE: TStringField
      FieldName = 'PARTTYPE'
      Size = 10
    end
    object qryPartPARTTYPEDESC: TStringField
      FieldName = 'PARTTYPEDESC'
      Size = 30
    end
    object qryPartPACKAGED: TStringField
      FieldName = 'PACKAGED'
      Size = 10
    end
    object qryPartPACKSIZE: TIntegerField
      FieldName = 'PACKSIZE'
    end
    object qryPartDISCPERC: TIBOBCDField
      FieldName = 'DISCPERC'
      Precision = 9
      Size = 3
    end
    object qryPartREPLACEDBY: TStringField
      FieldName = 'REPLACEDBY'
      Size = 10
    end
    object qryPartREPLACEDBYPARAM: TStringField
      FieldName = 'REPLACEDBYPARAM'
      Size = 10
    end
    object qryPartREPLACEDBYOEMNO: TStringField
      FieldName = 'REPLACEDBYOEMNO'
      Origin = 'PROC_PART_GETINFO.REPLACEDBYOEMNO'
      Size = 30
    end
    object qryPartREPLACEDBYDESC: TStringField
      FieldName = 'REPLACEDBYDESC'
      Size = 50
    end
    object qryPartSALENOTE: TStringField
      FieldName = 'SALENOTE'
      Size = 128
    end
    object qryPartQTYONHAND: TIntegerField
      FieldName = 'QTYONHAND'
    end
    object qryPartLASTMOVEDDTE: TDateTimeField
      FieldName = 'LASTMOVEDDTE'
    end
    object qryPartDEPARTMENT: TStringField
      FieldName = 'DEPARTMENT'
      Size = 1
    end
    object qryPartSUPPLYCODE: TStringField
      FieldName = 'SUPPLYCODE'
      Size = 10
    end
    object qryPartBASECURRENCY: TStringField
      FieldName = 'BASECURRENCY'
      Size = 10
    end
    object qryPartCOSTSITE: TStringField
      FieldName = 'COSTSITE'
      Origin = 'PROC_PART_GETINFO.COSTSITE'
      FixedChar = True
      Size = 1
    end
    object qryPartPACKCOSTBASE: TFloatField
      FieldName = 'PACKCOSTBASE'
      DisplayFormat = ',0.00'
    end
    object qryPartUNITCOSTBASE: TFloatField
      FieldName = 'UNITCOSTBASE'
    end
    object qryPartUNITCOSTGBP: TFloatField
      FieldName = 'UNITCOSTGBP'
    end
    object qryPartDTECOSTED: TDateTimeField
      FieldName = 'DTECOSTED'
    end
    object qryPartUNITSELLGBP: TFloatField
      FieldName = 'UNITSELLGBP'
      Visible = False
      DisplayFormat = ',0.00'
    end
    object qryPartISFIXEDSELLPRICE: TStringField
      FieldName = 'ISFIXEDSELLPRICE'
      Origin = 'PROC_PART_GETINFO.ISFIXEDSELLPRICE'
      FixedChar = True
      Size = 1
    end
    object qryPartONORDER: TIntegerField
      FieldName = 'ONORDER'
    end
    object qryPartLASTORDERED: TDateTimeField
      FieldName = 'LASTORDERED'
    end
    object qryPartLASTUNITCOSTGBP: TFloatField
      FieldName = 'LASTUNITCOSTGBP'
    end
    object qryPartLASTORDERTRANNO: TStringField
      FieldName = 'LASTORDERTRANNO'
      Size = 10
    end
    object qryPartNEXTEXPECTED: TDateTimeField
      FieldName = 'NEXTEXPECTED'
    end
    object qryPartNEXTORDERTRANNO: TStringField
      FieldName = 'NEXTORDERTRANNO'
      Size = 10
    end
    object qryPartPARAMSFORPART: TStringField
      FieldName = 'PARAMSFORPART'
      Size = 330
    end
    object qryPartOPSFORPART: TStringField
      FieldName = 'OPSFORPART'
      Size = 110
    end
    object qryPartAVGUNITCOSTGBP: TFloatField
      FieldName = 'AVGUNITCOSTGBP'
      Origin = 'PROC_PART_GETINFO.AVGUNITCOSTGBP'
      DisplayFormat = ',0.00'
    end
    object qryPartDTEVALIDFROM: TDateTimeField
      FieldName = 'DTEVALIDFROM'
      Origin = 'PROC_PART_GETINFO.DTEVALIDFROM'
    end
    object qryPartDTEVALIDUNTIL: TDateTimeField
      FieldName = 'DTEVALIDUNTIL'
      Origin = 'PROC_PART_GETINFO.DTEVALIDUNTIL'
    end
    object qryPartSTOCKINGTYPE: TStringField
      FieldName = 'STOCKINGTYPE'
      Origin = 'PROC_PART_GETINFO.STOCKINGTYPE'
      FixedChar = True
      Size = 1
    end
    object qryPartPRICEBAND: TStringField
      DisplayWidth = 5
      FieldName = 'PRICEBAND'
      Origin = 'PROC_PART_GETINFO.PRICEBAND'
      FixedChar = True
      Size = 5
    end
    object qryPartCOMMODITYCODE: TStringField
      FieldName = 'COMMODITYCODE'
      Origin = 'PROC_PART_GETINFO.COMMODITYCODE'
      Visible = False
      Size = 15
    end
    object qryPartCOUNTRYOFORIGIN: TStringField
      FieldName = 'COUNTRYOFORIGIN'
      Origin = 'PROC_PART_GETINFO.COUNTRYOFORIGIN'
      Visible = False
      Size = 10
    end
    object qryPartTECHMEMO: TMemoField
      FieldName = 'TECHMEMO'
      Origin = 'PROC_PART_GETINFO.TECHMEMO'
      BlobType = ftMemo
      Size = 8
    end
  end
  object qryPtOp: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT  DISTINCT'
      '  pp.AssmNo as Operation'
      'FROM '
      '  PartAssm pp'
      'WHERE'
      '  (pp.PartNo = :AsPartNo) AND (pp.AssmType='#39'W'#39')'
      'ORDER BY'
      '  pp.AssmNo')
    FieldOptions = []
    OptionsEx = []
    Left = 185
    Top = 60
    object qryPtOpOPERATION: TStringField
      FieldName = 'OPERATION'
      Size = 10
    end
  end
  object qryPtParam: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT  PartParam'
      'FROM PROC_Part_GetParams(:AsPartNo)')
    FieldOptions = []
    OptionsEx = []
    Left = 125
    Top = 60
    object qryPtParamPARTPARAM: TStringField
      FieldName = 'PARTPARAM'
      Size = 10
    end
  end
  object qryCountry: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsCountryNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  CountryNo,'
      '  CountryName, '
      '  TelCode, '
      '  CurrencySupply, CurrencySales,'
      '  RegionSales'
      'FROM'
      '  Country '
      'WHERE '
      '  CountryNo = :AsCountryNo')
    FieldOptions = []
    OptionsEx = []
    Left = 240
    Top = 60
    object qryCountryCOUNTRYNO: TStringField
      FieldName = 'COUNTRYNO'
      Origin = 'COUNTRY.COUNTRYNO'
      FixedChar = True
      Size = 10
    end
    object qryCountryCOUNTRYNAME: TStringField
      FieldName = 'COUNTRYNAME'
      Origin = 'COUNTRY.COUNTRYNAME'
      Size = 50
    end
    object qryCountryTELCODE: TStringField
      FieldName = 'TELCODE'
      Origin = 'COUNTRY.TELCODE'
      FixedChar = True
      Size = 10
    end
    object qryCountryCURRENCYSUPPLY: TStringField
      FieldName = 'CURRENCYSUPPLY'
      Origin = 'COUNTRY.CURRENCYSUPPLY'
      Size = 10
    end
    object qryCountryCURRENCYSALES: TStringField
      FieldName = 'CURRENCYSALES'
      Origin = 'COUNTRY.CURRENCYSALES'
      Size = 10
    end
    object qryCountryREGIONSALES: TStringField
      FieldName = 'REGIONSALES'
      Origin = 'COUNTRY.REGIONSALES'
      Size = 10
    end
  end
  object qryPoCost: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'AsTranNo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AsPartParam'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '  TranNo, TranStatus, '
      '  SuppNo, SuppName, '
      '  IsPartValid, PartNo, PartParam, '
      '  JobNo, DteRequired, UnitNetGBP'
      'FROM'
      '  PROC_Purch_GetLineInfo(:AsTranNo, :AsPartNo, :AsPartParam)')
    FieldOptions = []
    OptionsEx = []
    Left = 185
    Top = 5
    object qryPoCostTRANNO: TStringField
      FieldName = 'TRANNO'
      Origin = 'PROC_PURCH_GETLINEINFO.TRANNO'
      Size = 10
    end
    object qryPoCostTRANSTATUS: TStringField
      FieldName = 'TRANSTATUS'
      Origin = 'PROC_PURCH_GETLINEINFO.TRANSTATUS'
      Size = 10
    end
    object qryPoCostSUPPNO: TStringField
      FieldName = 'SUPPNO'
      Origin = 'PROC_PURCH_GETLINEINFO.SUPPNO'
      Size = 10
    end
    object qryPoCostSUPPNAME: TStringField
      FieldName = 'SUPPNAME'
      Origin = 'PROC_PURCH_GETLINEINFO.SUPPNAME'
      Size = 50
    end
    object qryPoCostISPARTVALID: TStringField
      FieldName = 'ISPARTVALID'
      Origin = 'PROC_PURCH_GETLINEINFO.ISPARTVALID'
      Size = 1
    end
    object qryPoCostPARTNO: TStringField
      FieldName = 'PARTNO'
      Origin = 'PROC_PURCH_GETLINEINFO.PARTNO'
      Size = 10
    end
    object qryPoCostPARTPARAM: TStringField
      FieldName = 'PARTPARAM'
      Origin = 'PROC_PURCH_GETLINEINFO.PARTPARAM'
      Size = 10
    end
    object qryPoCostJOBNO: TStringField
      FieldName = 'JOBNO'
      Origin = 'PROC_PURCH_GETLINEINFO.JOBNO'
      Size = 10
    end
    object qryPoCostDTEREQUIRED: TDateTimeField
      FieldName = 'DTEREQUIRED'
      Origin = 'PROC_PURCH_GETLINEINFO.DTEREQUIRED'
    end
    object qryPoCostUNITNETGBP: TFloatField
      FieldName = 'UNITNETGBP'
      Origin = 'PROC_PURCH_GETLINEINFO.UNITNETGBP'
    end
  end
  object qryCont: TcrIBQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'ContNo'
        ParamType = ptUnknown
      end>
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT'
      '    ContNo,'
      '    ContDesc,'
      '    CompNo'
      'FROM'
      '  Contract'
      'where ContNo = :ContNo ')
    FieldOptions = []
    OptionsEx = []
    Left = 241
    Top = 5
    object qryContCONTNO: TStringField
      FieldName = 'CONTNO'
      Origin = 'CONTRACT.CONTNO'
      Required = True
      FixedChar = True
      Size = 10
    end
    object qryContCONTDESC: TStringField
      FieldName = 'CONTDESC'
      Origin = 'CONTRACT.CONTDESC'
      Size = 50
    end
    object qryContCOMPNO: TStringField
      FieldName = 'COMPNO'
      Origin = 'CONTRACT.COMPNO'
      Size = 10
    end
  end
end
