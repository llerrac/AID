object ModAid: TModAid
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 83
  Top = 147
  Height = 331
  Width = 366
  object ibTran: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 15
    Top = 5
  end
  object qryPurch: TcrIBQuery
    Transaction = ibTran
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
    OptionsEx = []
    Left = 65
    Top = 5
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsTranNo'
        ParamType = ptUnknown
      end>
    object qryPurchINC_PURCH: TIntegerField
      FieldName = 'INC_PURCH'
      Origin = 'PURCHMAST.INC_PURCH'
      Required = True
    end
    object qryPurchTRANNO: TIBStringField
      DisplayLabel = 'Order #'
      DisplayWidth = 11
      FieldName = 'TRANNO'
      Size = 10
    end
    object qryPurchSUPPNO: TIBStringField
      DisplayLabel = 'Supplier #'
      DisplayWidth = 8
      FieldName = 'SUPPNO'
      Visible = False
      Size = 10
    end
    object qryPurchSUPPNAME: TIBStringField
      DisplayLabel = 'Supplier'
      DisplayWidth = 30
      FieldName = 'SUPPNAME'
      Size = 50
    end
    object qryPurchTRANSITE: TIBStringField
      Alignment = taCenter
      DisplayLabel = 'Ste'
      DisplayWidth = 3
      FieldName = 'TRANSITE'
      Size = 1
    end
    object qryPurchTRANREF: TIBStringField
      DisplayLabel = 'Contract/CC'
      DisplayWidth = 10
      FieldName = 'TRANREF'
    end
    object qryPurchSUPPREF: TIBStringField
      DisplayLabel = 'Supplier Ref.:'
      DisplayWidth = 10
      FieldName = 'SUPPREF'
    end
    object qryPurchTRANDTE: TDateTimeField
      DisplayLabel = 'Ordered'
      DisplayWidth = 10
      FieldName = 'TRANDTE'
    end
    object qryPurchTRANUSER: TIBStringField
      FieldName = 'TRANUSER'
      Visible = False
      Size = 15
    end
    object qryPurchTRANUSERDESC: TIBStringField
      DisplayLabel = 'Ordered By'
      DisplayWidth = 15
      FieldName = 'TRANUSERDESC'
      Size = 50
    end
    object qryPurchTRANSTATUS: TIBStringField
      FieldName = 'TRANSTATUS'
      Visible = False
      Size = 10
    end
    object qryPurchTRANSTATUSDESC: TIBStringField
      DisplayLabel = 'Status'
      DisplayWidth = 15
      FieldName = 'TRANSTATUSDESC'
      Size = 30
    end
    object qryPurchDELIVERYSITE: TIBStringField
      DisplayLabel = 'Site'
      FieldName = 'DELIVERYSITE'
      Visible = False
      Size = 1
    end
    object qryPurchDELIVERYWARE: TIBStringField
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
    object qryPurchISCOMPLETED: TIBStringField
      FieldName = 'ISCOMPLETED'
      Visible = False
      Size = 1
    end
  end
  object qryComp: TcrIBQuery
    Transaction = ibTran
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
    OptionsEx = []
    Left = 125
    Top = 5
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsCompNo'
        ParamType = ptUnknown
      end>
    object qryCompCOMPNO: TIBStringField
      FieldName = 'COMPNO'
      Size = 10
    end
    object qryCompCOMPNAME: TIBStringField
      FieldName = 'COMPNAME'
      Size = 50
    end
    object qryCompCOMPTELPRE: TIBStringField
      FieldName = 'COMPTELPRE'
      Size = 10
    end
    object qryCompCOMPTELNO: TIBStringField
      FieldName = 'COMPTELNO'
      Size = 30
    end
    object qryCompCOMPFAXPRE: TIBStringField
      FieldName = 'COMPFAXPRE'
      Size = 10
    end
    object qryCompCOMPFAXNO: TIBStringField
      FieldName = 'COMPFAXNO'
      Size = 30
    end
    object qryCompCOMPEMAIL: TIBStringField
      FieldName = 'COMPEMAIL'
      Size = 50
    end
    object qryCompLOCCOUNTRY: TIBStringField
      FieldName = 'LOCCOUNTRY'
      Size = 10
    end
    object qryCompLOCADDRESS: TIBStringField
      FieldName = 'LOCADDRESS'
      Size = 180
    end
    object qryCompLOCPC: TIBStringField
      FieldName = 'LOCPC'
    end
    object qryCompLOCCOUNTRYNAME: TIBStringField
      FieldName = 'LOCCOUNTRYNAME'
      Size = 50
    end
    object qryCompCURRENCYSUPPLY: TIBStringField
      FieldName = 'CURRENCYSUPPLY'
      Origin = 'PROC_COMP_GETSUMMARY.SUPPLYCURRENCY'
      Size = 10
    end
    object qryCompVALIDSUPPLYSITES: TIBStringField
      FieldName = 'VALIDSUPPLYSITES'
      Origin = 'PROC_COMP_GETSUMMARY.VALIDSUPPLYSITES'
      Size = 26
    end
    object qryCompIssuePurchaseLabels: TStringField
      FieldName = 'IssuePurchaseLabels'
      Size = 1
    end
    object qryCompCURRENCYSALES: TIBStringField
      FieldName = 'CURRENCYSALES'
      Origin = 'PROC_COMP_GETSUMMARY.SALESCURRENCY'
      Size = 10
    end
    object qryCompVALIDSALESSITES: TIBStringField
      FieldName = 'VALIDSALESSITES'
      Origin = 'PROC_COMP_GETSUMMARY.VALIDSALESSITES'
      Size = 26
    end
    object qryCompDIVISIONSALES: TIBStringField
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
    object qryCompALLOWTRACKING: TIBStringField
      FieldName = 'ALLOWTRACKING'
      Origin = 'PROC_COMP_GETSUMMARY.ALLOWTRACKING'
      FixedChar = True
      Size = 1
    end
    object qryCompTRACKINGHTTP: TIBStringField
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
    object qryCompAGENTCOMMISSION: TIBBCDField
      FieldName = 'AGENTCOMMISSION'
      Origin = 'PROC_COMP_GETSUMMARY.AGENTCOMMISSION'
      Precision = 9
      Size = 3
    end
    object qryCompOWNCOMMISSION: TIBBCDField
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
    Transaction = ibTran
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
      
        '  UnitSellGBP, IsFixedSellPrice, UNITSELL_ALT,   UNITSELL_ALT_CU' +
        'RCODE,'
      '  UnitCostGBP, DteCosted, OnOrder, '
      '  LastOrdered, LastUnitCostGBP, LastOrderTranNo, '
      '  NextExpected, NextOrderTranNo, '
      '  AvgUnitCostGBP,'
      '  StockingType,'
      '  DteValidFrom, DteValidUntil,'
      '  ParamsForPart,'
      '  OpsForPart, TechMemo,'
      '  master_id'
      'FROM'
      
        '  PROC_Part_GetInfo (:AsPartNo, :AsPartParam, :AsPartOp, :AsPref' +
        'Site, :AsPrefSupp, :AnWeight)')
    OptionsEx = []
    Left = 65
    Top = 64
    ParamData = <
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
    object qryPartHASPARTINFO: TIBStringField
      FieldName = 'HASPARTINFO'
      Size = 1
    end
    object qryPartHASPARAMINFO: TIBStringField
      FieldName = 'HASPARAMINFO'
      Size = 1
    end
    object qryPartHASPOINFO: TIBStringField
      FieldName = 'HASPOINFO'
      Size = 1
    end
    object qryPartHASOPSINFO: TIBStringField
      FieldName = 'HASOPSINFO'
      Size = 1
    end
    object qryPartISADMINISTRATIVE: TIBStringField
      FieldName = 'ISADMINISTRATIVE'
      Size = 1
    end
    object qryPartISGENERIC: TIBStringField
      FieldName = 'ISGENERIC'
      Size = 1
    end
    object qryPartISPARAMETERIZED: TIBStringField
      FieldName = 'ISPARAMETERIZED'
      Size = 1
    end
    object qryPartISASSEMBLED: TIBStringField
      FieldName = 'ISASSEMBLED'
      Size = 1
    end
    object qryPartIsShipping: TIBStringField
      FieldName = 'IsShipping'
      Size = 1
    end
    object qryPartPARTVERSION: TIBStringField
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
    object qryPartNEEDMANUALPARAMS: TIBStringField
      FieldName = 'NEEDMANUALPARAMS'
      Size = 1
    end
    object qryPartNEEDMANUALOPS: TIBStringField
      FieldName = 'NEEDMANUALOPS'
      Size = 1
    end
    object qryPartSUPPNO: TIBStringField
      FieldName = 'SUPPNO'
      Size = 10
    end
    object qryPartSUPPPARTNO: TIBStringField
      FieldName = 'SUPPPARTNO'
      Size = 30
    end
    object qryPartPARTNO: TIBStringField
      FieldName = 'PARTNO'
      Size = 10
    end
    object qryPartPARTPARAM: TIBStringField
      FieldName = 'PARTPARAM'
      Size = 10
    end
    object qryPartPARTDESC: TIBStringField
      FieldName = 'PARTDESC'
      Size = 50
    end
    object qryPartPARTTYPE: TIBStringField
      FieldName = 'PARTTYPE'
      Size = 10
    end
    object qryPartPARTTYPEDESC: TIBStringField
      FieldName = 'PARTTYPEDESC'
      Size = 30
    end
    object qryPartPACKAGED: TIBStringField
      FieldName = 'PACKAGED'
      Size = 10
    end
    object qryPartPACKSIZE: TIntegerField
      FieldName = 'PACKSIZE'
    end
    object qryPartDISCPERC: TIBBCDField
      FieldName = 'DISCPERC'
      Precision = 9
      Size = 3
    end
    object qryPartREPLACEDBY: TIBStringField
      FieldName = 'REPLACEDBY'
      Size = 10
    end
    object qryPartREPLACEDBYPARAM: TIBStringField
      FieldName = 'REPLACEDBYPARAM'
      Size = 10
    end
    object qryPartREPLACEDBYOEMNO: TIBStringField
      FieldName = 'REPLACEDBYOEMNO'
      Origin = 'PROC_PART_GETINFO.REPLACEDBYOEMNO'
      Size = 30
    end
    object qryPartREPLACEDBYDESC: TIBStringField
      FieldName = 'REPLACEDBYDESC'
      Size = 50
    end
    object qryPartSALENOTE: TIBStringField
      FieldName = 'SALENOTE'
      Size = 128
    end
    object qryPartQTYONHAND: TIntegerField
      FieldName = 'QTYONHAND'
    end
    object qryPartLASTMOVEDDTE: TDateTimeField
      FieldName = 'LASTMOVEDDTE'
    end
    object qryPartDEPARTMENT: TIBStringField
      FieldName = 'DEPARTMENT'
      Size = 1
    end
    object qryPartSUPPLYCODE: TIBStringField
      FieldName = 'SUPPLYCODE'
      Size = 10
    end
    object qryPartBASECURRENCY: TIBStringField
      FieldName = 'BASECURRENCY'
      Size = 10
    end
    object qryPartCOSTSITE: TIBStringField
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
    object qryPartISFIXEDSELLPRICE: TIBStringField
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
    object qryPartLASTORDERTRANNO: TIBStringField
      FieldName = 'LASTORDERTRANNO'
      Size = 10
    end
    object qryPartNEXTEXPECTED: TDateTimeField
      FieldName = 'NEXTEXPECTED'
    end
    object qryPartNEXTORDERTRANNO: TIBStringField
      FieldName = 'NEXTORDERTRANNO'
      Size = 10
    end
    object qryPartPARAMSFORPART: TIBStringField
      FieldName = 'PARAMSFORPART'
      Size = 330
    end
    object qryPartOPSFORPART: TIBStringField
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
    object qryPartSTOCKINGTYPE: TIBStringField
      FieldName = 'STOCKINGTYPE'
      Origin = 'PROC_PART_GETINFO.STOCKINGTYPE'
      FixedChar = True
      Size = 1
    end
    object qryPartPRICEBAND: TIBStringField
      DisplayWidth = 5
      FieldName = 'PRICEBAND'
      Origin = 'PROC_PART_GETINFO.PRICEBAND'
      FixedChar = True
      Size = 5
    end
    object qryPartCOMMODITYCODE: TIBStringField
      FieldName = 'COMMODITYCODE'
      Origin = 'PROC_PART_GETINFO.COMMODITYCODE'
      Visible = False
      Size = 15
    end
    object qryPartCOUNTRYOFORIGIN: TIBStringField
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
    object qryPartMASTER_ID: TIntegerField
      FieldName = 'MASTER_ID'
      Origin = 'PROC_PART_GETINFO.MASTER_ID'
    end
    object qryPartUNITSELL_ALT: TFloatField
      FieldName = 'UNITSELL_ALT'
      Origin = 'PROC_PART_GETINFO.UNITSELL_ALT'
    end
    object qryPartUNITSELL_ALT_CURCODE: TIBStringField
      FieldName = 'UNITSELL_ALT_CURCODE'
      Origin = 'PROC_PART_GETINFO.UNITSELL_ALT_CURCODE'
      Size = 10
    end
  end
  object qryPtOp: TcrIBQuery
    Transaction = ibTran
    SQL.Strings = (
      'SELECT  DISTINCT'
      '  pp.AssmNo as Operation'
      'FROM '
      '  PartAssm pp'
      'WHERE'
      '  (pp.PartNo = :AsPartNo) AND (pp.AssmType='#39'W'#39')'
      'ORDER BY'
      '  pp.AssmNo')
    OptionsEx = []
    Left = 185
    Top = 60
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end>
    object qryPtOpOPERATION: TIBStringField
      FieldName = 'OPERATION'
      Size = 10
    end
  end
  object qryPtParam: TcrIBQuery
    Transaction = ibTran
    SQL.Strings = (
      'SELECT  PartParam, master_id'
      'FROM PROC_Part_GetParams(:AsPartNo)')
    OptionsEx = []
    Left = 125
    Top = 60
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsPartNo'
        ParamType = ptUnknown
      end>
    object qryPtParamPARTPARAM: TIBStringField
      FieldName = 'PARTPARAM'
      Size = 10
    end
    object qryPtParammaster_id: TIntegerField
      FieldName = 'master_id'
    end
  end
  object qryCountry: TcrIBQuery
    Transaction = ibTran
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
    OptionsEx = []
    Left = 240
    Top = 60
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AsCountryNo'
        ParamType = ptUnknown
      end>
    object qryCountryCOUNTRYNO: TIBStringField
      FieldName = 'COUNTRYNO'
      Origin = 'COUNTRY.COUNTRYNO'
      FixedChar = True
      Size = 10
    end
    object qryCountryCOUNTRYNAME: TIBStringField
      FieldName = 'COUNTRYNAME'
      Origin = 'COUNTRY.COUNTRYNAME'
      Size = 50
    end
    object qryCountryTELCODE: TIBStringField
      FieldName = 'TELCODE'
      Origin = 'COUNTRY.TELCODE'
      FixedChar = True
      Size = 10
    end
    object qryCountryCURRENCYSUPPLY: TIBStringField
      FieldName = 'CURRENCYSUPPLY'
      Origin = 'COUNTRY.CURRENCYSUPPLY'
      Size = 10
    end
    object qryCountryCURRENCYSALES: TIBStringField
      FieldName = 'CURRENCYSALES'
      Origin = 'COUNTRY.CURRENCYSALES'
      Size = 10
    end
    object qryCountryREGIONSALES: TIBStringField
      FieldName = 'REGIONSALES'
      Origin = 'COUNTRY.REGIONSALES'
      Size = 10
    end
  end
  object qryPoCost: TcrIBQuery
    Transaction = ibTran
    SQL.Strings = (
      'SELECT'
      '  TranNo, TranStatus, '
      '  SuppNo, SuppName, '
      '  IsPartValid, PartNo, PartParam, '
      '  JobNo, DteRequired, UnitNetGBP'
      'FROM'
      '  PROC_Purch_GetLineInfo(:AsTranNo, :AsPartNo, :AsPartParam)')
    OptionsEx = []
    Left = 185
    Top = 5
    ParamData = <
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
    object qryPoCostTRANNO: TIBStringField
      FieldName = 'TRANNO'
      Origin = 'PROC_PURCH_GETLINEINFO.TRANNO'
      Size = 10
    end
    object qryPoCostTRANSTATUS: TIBStringField
      FieldName = 'TRANSTATUS'
      Origin = 'PROC_PURCH_GETLINEINFO.TRANSTATUS'
      Size = 10
    end
    object qryPoCostSUPPNO: TIBStringField
      FieldName = 'SUPPNO'
      Origin = 'PROC_PURCH_GETLINEINFO.SUPPNO'
      Size = 10
    end
    object qryPoCostSUPPNAME: TIBStringField
      FieldName = 'SUPPNAME'
      Origin = 'PROC_PURCH_GETLINEINFO.SUPPNAME'
      Size = 50
    end
    object qryPoCostISPARTVALID: TIBStringField
      FieldName = 'ISPARTVALID'
      Origin = 'PROC_PURCH_GETLINEINFO.ISPARTVALID'
      Size = 1
    end
    object qryPoCostPARTNO: TIBStringField
      FieldName = 'PARTNO'
      Origin = 'PROC_PURCH_GETLINEINFO.PARTNO'
      Size = 10
    end
    object qryPoCostPARTPARAM: TIBStringField
      FieldName = 'PARTPARAM'
      Origin = 'PROC_PURCH_GETLINEINFO.PARTPARAM'
      Size = 10
    end
    object qryPoCostJOBNO: TIBStringField
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
    Transaction = ibTran
    SQL.Strings = (
      'SELECT'
      '    ContNo,'
      '    ContDesc,'
      '    CompNo, '
      '    KEY_STATUS'
      'FROM'
      '  Contract'
      'where ContNo = :ContNo ')
    OptionsEx = []
    Left = 241
    Top = 5
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ContNo'
        ParamType = ptUnknown
      end>
    object qryContCONTNO: TIBStringField
      FieldName = 'CONTNO'
      Origin = 'CONTRACT.CONTNO'
      Required = True
      FixedChar = True
      Size = 10
    end
    object qryContCONTDESC: TIBStringField
      FieldName = 'CONTDESC'
      Origin = 'CONTRACT.CONTDESC'
      Size = 50
    end
    object qryContCOMPNO: TIBStringField
      FieldName = 'COMPNO'
      Origin = 'CONTRACT.COMPNO'
      Size = 10
    end
    object qryContKEY_STATUS: TStringField
      FieldName = 'KEY_STATUS'
      Size = 5
    end
  end
  object kbmMemTabke: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    AutoIncMinValue = -1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.50'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 11
    Top = 129
    object kbmMemTabkeKey_Lk: TStringField
      FieldName = 'Key_Lk'
      Size = 10
    end
    object kbmMemTabkeDesc_Lk: TStringField
      FieldName = 'Desc_Lk'
      Size = 30
    end
  end
end
