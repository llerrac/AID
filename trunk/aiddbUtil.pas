unit aiddbUtil;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbUtil
  Author      : Chris G. Royle (CGR20020419)
  Description : Atlas global db-aware procedures / functions
  See Also    : aidTypes.pas, datastock.sql  data.sql
  Note        :
  Modified    :
    CGR20020529, Only executes QryComp if a well formed search criteria ie 6 or more chars
    CGR20031205, Altered to pull Commodity Code and Country Of Origin from part.
    CGR20040701, GetPartInfo to use Const & Vars in such a way that AQTime does not report memory leaks.
    CGR20051207, Added support for Company.IssuePurchaseLabels field.
    CGR20061102, Extended the qryPart to return an attribute to indicate if an item is a shipping item.
  -------------------------------------------------------------------------------------------------}
interface

uses
  ibDatabase, db, aidTypes;

type
  TFieldCalculatedResolver = function(fieldname : string) : TField of object;

(* GetPurchInfo
      Establish Purchase Order information - typically used in a memory table field.OnChange event to populate
      related fields. See the TvalPurchDef structure.
          AuIBDatabase = Application Database,
          AsTranNo     = Purchase Order Number,
          rPurchDef    = The result record structure
      Returns True if rPurchDef contains a result *)
function GetPurchInfo    (AuIBDatabase: TIBDatabase; AsTranNo: string; var rPurchDef: TvalPurchDef): Boolean;
function GetPurchPartInfo(AuIBDatabase: TIBDatabase; AsTranNo, AsPartNo, AsParam: string; var rPurchItemDef: TvalPurchItemDef): Boolean;

(*  GetCompanyInfo
      Returns information re. company AsCompNo - refer to GetPurchInfo documentation *)
function GetCompanyInfo(AuIBDatabase: TIBDatabase; AsCompNo: string; var rCompDef : TvalCompDef ): Boolean;

(*  GetContractInfo
      Returns information re. company AsCompNo - refer to GetPurchInfo documentation *)
function GetContractInfo(AuIBDatabase: TIBDatabase; AsContNo: string; var rContDef : TvalContDef ): Boolean;

(*  GetPartInfo
      Returns information re. part system (utilises GetPartParametersToString, GetPartOperationsToString)
      see the PROC_Part_GetInfo stored proc, as this documents the Weighting methodology, & which fields are mandatory
          AuIBDatabase  = Application Database
          AsPartNo      = Part No
          AsPartParam   = Part Parameter
          AsPartOp      = Part Operation
          AsPrefSite    = Preferred Site for procurement
          AsPrefSupp    = Preferred Supplier for procurement
          AnWeighting   = bias
          APartDef      = result *)
function GetPartInfo(const AuIBDatabase: TIBDatabase; const AsPartNo, AsPartParam, AsPartOp, AsPrefSite, AsPrefSupp: string; AnWeighting: Integer; var rPartDef: TaidPartDef): Boolean;

(*  GetPartParametersToString
      Returns the available parameters for Part AsPartNo (Using QryPtParam) into a delimited sPartParams *)
function GetPartParametersToString(AuIBDatabase: TIBDatabase; AsPartNo: string; var sPartParams: string): Boolean;


(*  GetPartOperationsToString
      Returns the available operations for Part AsPartNo (Using QryPtParam) into a delimited sPartOps *)
function GetPartOperationsToString(AuIBDatabase: TIBDatabase; AsPartNo: string; var sPartOps: string): Boolean;

(*  GetCountryInfo
      Returns the country information for Country AsCountry *)
function GetCountryInfo(AuIBDatabase: TIBDatabase; AsCountryNo: String; var rCountry: TvalCountry): Boolean;


//returns whether a field can be sorted, on text of fieldname, or sorted by another field
function SortColumnindicator(field : string;ds : Tdataset;Calculatedfield : TFieldCalculatedResolver) : string ;


implementation

uses
  d_AID, crUtil, crTypes, SysUtils;

{ GetPurchInfo }
function GetPurchInfo(AuIBDatabase: TIBDatabase; AsTranNo: string; var rPurchDef: TvalPurchDef): Boolean;
begin
  FillChar(rPurchDef, SizeOf(TvalPurchDef), #0);
  //
  if (not IsEmptyStr(AsTranNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID.ModAID do
    begin
      QryPurch.Close;
      QryPurch.Database:= AuIBDatabase;
      QryPurch.ParamByName('AsTranNo').AsString:= AsTranNo;
      QryPurch.Open;
      try
        if not QryPurch.IsEmpty then
        begin
          rPurchDef.Found    := True;
          rPurchDef.Inc_Purch:= QryPurchInc_Purch.AsInteger;
          rPurchDef.TranNo   := QryPurchTranNo  .AsString;
          rPurchDef.TranRef  := QryPurchTranRef .AsString;
          rPurchDef.SuppNo   := QryPurchSuppNo  .AsString;
          rPurchDef.SuppName := QryPurchSuppName.AsString;
          rPurchDef.SuppRef  := QryPurchSuppRef .AsString;
        end;
      finally
        QryPurch.Close;
      end;
    end;
  end;
  //
  Result:= rPurchDef.Found;
end;

{ GetPurchPartInfo }
function GetPurchPartInfo(AuIBDatabase: TIBDatabase; AsTranNo, AsPartNo, AsParam: string; var rPurchItemDef: TvalPurchItemDef): Boolean;
begin
  FillChar(rPurchItemDef, SizeOf(TvalPurchItemDef), #0);
  //
  if (not IsEmptyStr(AsTranNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID.ModAID do
    begin
      QryPoCost.Close;
      QryPoCost.Database:= AuIBDatabase;
      QryPoCost.ParamByName('AsTranNo')   .AsString:= Trim(AsTranNo);
      QryPoCost.ParamByName('AsPartNo')   .AsString:= Trim(AsPartNo);
      QryPoCost.ParamByName('AsPartParam').AsString:= Trim(AsParam );
      QryPoCost.Open;
      try
        if not QryPoCost.IsEmpty then
        begin
          rPurchItemDef.Found      := QryPoCostIsPartValid.AsBoolean;
          rPurchItemDef.TranNo     := QryPoCostTranNo     .AsString;
          rPurchItemDef.TranStatus := QryPoCostTranStatus .AsString;
          rPurchItemDef.SuppNo     := QryPoCostSuppNo     .AsString;
          rPurchItemDef.SuppName   := QryPoCostSuppName   .AsString;
          rPurchItemDef.IsPartValid:= QryPoCostIsPartValid.AsBoolean;
          rPurchItemDef.PartNo     := QryPoCostPartNo     .AsString;
          rPurchItemDef.PartParam  := QryPoCostPartParam  .AsString;
          rPurchItemDef.JobNo      := QryPoCostJobNo      .AsString;
          rPurchItemDef.DteRequired:= QryPoCostDteRequired.AsDateTime;
          rPurchItemDef.UnitNetGBP := QryPoCostUnitNetGBP .AsCurrency;
        end;
      finally
        QryPoCost.Close;
      end;
    end;
  end;
  //
  Result:= rPurchItemDef.Found;
end;


{GetCompanyInfo
  Modified CGR20020529, Only executes QryComp if a well formed search criteria ie 6 or more chars }
function GetCompanyInfo(AuIBDatabase: TIBDatabase; AsCompNo: string; var rCompDef : TValCompDef): Boolean;
var
  iK  : Integer;
  lOk : Boolean;
begin
  FillChar(rCompDef, SizeOf(TValCompDef), #0);
  AsCompNo:= Trim(AsCompNo);
  lOk     := (not IsEmptyStr(AsCompNo)) and (Length(AsCompNo)>=6);
  //
  if (lOk) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID .ModAID do
    begin
      QryComp.Close;
      QryComp.Database:= AuIBDatabase;
      QryComp.ParamByName('AsCompNo').AsString:= AsCompNo;
      QryComp.Open;
      try
        if not QryComp.IsEmpty then
        begin
          rCompDef.Found           := AnsiCompareText(AsCompNo, QryCompCompNo.AsString)=0;
          rCompDef.CompNo          := QryCompCompNo         .AsString;
          rCompDef.CompName        := QryCompCompName       .AsString;
          //
          rCompDef.TelPre          := QryCompCompTelPre     .AsString;
          rCompDef.TelNo           := QryCompCompTelNo      .AsString;
          rCompDef.FaxPre          := QryCompCompFaxPre     .AsString;
          rCompDef.FaxNo           := QryCompCompFaxNo      .AsString;
          rCompDef.Email           := QryCompCompEmail      .AsString;
          //
          rCompDef.LocCountry      := QryCompLocCountry     .AsString;
          rCompDef.LocCountryName  := QryCompLocCountryName .AsString;
          rCompDef.LocAddress      := QryCompLocAddress     .AsString;
          rCompDef.LocPC           := QryCompLocPC          .AsString;
          //
          rCompDef.CurrencySupply  := QryCompCurrencySupply .AsString;
          rCompDef.ValidSupplySites:= QryCompValidSupplySites.AsString;
          rCompDef.IssuePurchaseLabels:= qryCompIssuePurchaseLabels.AsBoolean;

          rCompDef.CurrencySales   := QryCompCurrencySales  .AsString;
          rCompDef.DivisionSales   := QryCompDivisionSales  .AsString;
          rCompDef.ValidSalesSites := QryCompValidSalesSites.AsString;
          rCompDef.SalesPrompt     := Trim(QryCompSalesPrompt.AsString);
          rCompDef.AgentNo         := Trim(QryCompAgentNo.AsString);
          //
          rCompDef.AllowTracking   := QryCompAllowTracking  .AsBoolean;
          rCompDef.TrackingHttp    := QryCompTrackingHttp   .AsString;
          //
          rCompDef.DrBal           := QryCompDrBal          .AsCurrency;
          rCompDef.DrBalOverDue    := QryCompDrBalOverdue   .AsCurrency;
          rCompDef.DrBalCur        := QryCompDrBalCur       .AsCurrency;
          rCompDef.DrBal30         := QryCompDrBal30        .AsCurrency;
          rCompDef.DrBal60         := QryCompDrBal60        .AsCurrency;
          rCompDef.DrBal90         := QryCompDrBal90        .AsCurrency;
          rCompDef.DrBal120        := QryCompDrBal120       .AsCurrency;
          rCompDef.DrBal150        := QryCompDrBal150       .AsCurrency;
          rCompDef.DrLatestUpdate  := QryCompDrLatestUpdate .AsDateTime;
          rCompDef.DrLatestTran    := QryCompDrLatestTran   .AsDateTime;
          rCompDef.AgentCommission := QryCompAgentCommission.AsFloat;
          rCompDef.OwnCommission   := QryCompOwnCommission.AsFloat;
          rCompDef.RestrictedCountry := QryCompO_RESTRICTED_COUNTRY.asstring = 'T';

          // Formulate address
          with rCompDef do
          begin
            iK:= crUtil.AnsiTextPos(LocCountryName, LocAddress);
            if iK>0 then
            begin
              LocFullAdr:= crUtil.Separated([LocAddress, LocPC], CCRLF);
              LocLineAdr:= crUtil.Separated([LocAddress, LocPC], ' ,');
              LocLineAdr:= StrRepl(LocLineAdr, CCRLF,  ' ,');
            end
            else
            begin
              LocFullAdr:= crUtil.Separated([LocAddress, LocPC, LocCountryName], CCRLF);
              LocLineAdr:= crUtil.Separated([LocAddress, LocPC, LocCountryName], ' ,');
              LocLineAdr:= StrRepl(LocLineAdr, CCRLF,  ' ,');
            end;
          end;
          // Default / tidy other fields
        end;
      finally
        QryComp.Close;
      end;
    end;
  end;
  //
  Result:= rCompDef.Found;
end;

function GetContractInfo(AuIBDatabase: TIBDatabase; AsContNo: string; var rContDef : TvalContDef ): Boolean;
var
  lbOk : Boolean;
begin
  FillChar( rContDef, SizeOf(TValContDef), #0);
  AsContNo:= Trim(AsContNo);
  lbOk     := (not IsEmptyStr(AsContNo)) and (Length(AsContNo)>=6);
  //
  if (lbOk) then
  begin
    CheckAIDModuleIsReady( AuIBDatabase );
    //
    with d_AID .ModAID do
    begin
      QryCont.Close;
      QryCont.Database:= AuIBDatabase;
      QryCont.ParamByName('ContNo').AsString:= AsContNo;
      QryCont.Activate;
      try
        if not QryCont.IsEmpty then
        begin
          rContDef.Found           := AnsiCompareText( AsContNo, Trim( QryContContNo.AsString ) )=0;
          rContDef.ContNo          := QryContContNo   .AsString;
          rContDef.ContDesc        := QryContContDesc .AsString;
          rContDef.CustNo          := QryContCompNo   .AsString;
          rContDef.Status          := QryContKEY_STATUS   .AsString;
          //
        end;
      finally
        QryCont.Close;
      end;
    end;
  end;
  //
  Result:= rContDef.Found;
end;

function GetPartInfo(const AuIBDatabase: TIBDatabase; const AsPartNo, AsPartParam, AsPartOp, AsPrefSite, AsPrefSupp: string; AnWeighting: Integer; var rPartDef: TaidPartDef): Boolean;
var
  rDef  : TaidPartDef;
begin
  FillChar(rDef, SizeOf(TaidPartDef), #0);
  //
  if (not IsEmptyStr(AsPartNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID .ModAID do
    begin
      QryPart.Close;
      QryPart.Database:= AuIBDatabase;
      QryPart.ParamByName('AsPartNo')   .AsString := AsPartNo;
      QryPart.ParamByName('AsPartParam').AsString := AsPartParam;
      QryPart.ParamByName('AsPartOp')   .AsString := AsPartOp;
      QryPart.ParamByName('AsPrefSite') .AsString := AsPrefSite;
      QryPart.ParamByName('AsPrefSupp') .AsString := AsPrefSupp;
      QryPart.ParamByName('AnWeight')   .AsInteger:= AnWeighting;
      QryPart.Active:= True;
      try
        if (not QryPart.IsEmpty) and (QryPartHasPartInfo.AsBoolean) then
        begin
          { Part Properties Info. }
          rDef.HasPartInfo      := QryPartHasPartInfo     .AsBoolean;
          rDef.HasParamInfo     := QryPartHasParamInfo    .AsBoolean;
          rDef.HasPOInfo        := QryPartHasPOInfo       .AsBoolean;
          rDef.HasOpsInfo       := QryPartHasOpsInfo      .AsBoolean;
          rDef.IsAdministrative := QryPartIsAdministrative.AsBoolean;
          rDef.IsGeneric        := QryPartIsGeneric       .AsBoolean;
          rDef.IsParameterized  := QryPartIsParameterized .AsBoolean;
          rDef.IsAssembled      := QryPartIsAssembled     .AsBoolean;
          rDef.IsShipping       := qryPartIsShipping      .AsBoolean;
          { Part / Drawing Info }
          rDef.PartNo           := Trim(QryPartPartNo     .Value);
          rDef.PartParam        := Trim(QryPartPartParam  .Value);
          rDef.SuppNo           := Trim(QryPartSuppNo     .Value);
          rDef.SuppPartNo       := Trim(QryPartSuppPartNo .Value);
          rDef.PartVersion      := QryPartPartVersion     .Value;
          rDef.IssueNo          := QryPartIssueNo         .AsInteger;
          rDef.Engineer         := QryPartKey_Eng         .AsString;
          rDef.PartDesc         := QryPartPartDesc        .Value;
          rDef.PartType         := QryPartPartType        .Value;
          rDef.PartTypeDesc     := QryPartPartTypeDesc    .Value;
          rDef.PriceBand        := QryPartPriceBand       .AsString;
          { Replacements }
          rDef.ReplacedBy       := Trim(QryPartReplacedBy      .Value);
          rDef.ReplacedByParam  := Trim(QryPartReplacedByParam .Value);
          rDef.ReplacedByDesc   := QryPartReplacedByDesc  .Value;
          rDef.ReplacedByOemNo  := QryPartReplacedByOemNo .Value;
          { Sales Info }
          rDef.SaleNote         := QryPartSaleNote        .Value;
          { Tech Info }
          rDef.TechMemo         := QryPartTechMemo        .Value;
          { Stock Info }
          rDef.QtyOnHand        := QryPartQtyOnHand       .Value;
          rDef.LastMovedDte     := QryPartLastMovedDte    .Value;
          { Accounts Info }
          rDef.Department       := QryPartDepartment      .Value;
          rDef.SupplyCode       := QryPartSupplyCode      .Value;
          { Intrastat / Export info }
          rDef.CountryOfOrigin  := QryPartCountryOfOrigin .Value;
          rDef.CommodityCode    := QryPartCommodityCode   .Value;
          { Packaging }
          rDef.Packaged         := QryPartPackaged        .Value;
          rDef.PackSize         := QryPartPackSize        .Value;
          if (IsEmptyStr(rDef.Packaged)) then rDef.Packaged:= 'EACH';



          { Costing Info }
          rDef.BaseCurrency     := QryPartBaseCurrency    .Value;
          rDef.DiscPerc         := QryPartDiscPerc        .Value;
          rDef.PackCostBase     := QryPartPackCostBase    .Value;
          rDef.UnitCostBase     := QryPartUnitCostBase    .Value;
          rDef.UnitCostGBP      := QryPartUnitCostGBP     .Value;
          rDef.DteCosted        := QryPartDteCosted       .Value;
          rDef.CostSiteNo       := QryPartCostSite        .Value;
          rDef.StockingType     := QryPartStockingType    .Value;
          rDef.DteValidFrom     := QryPartDteValidFrom    .Value;
          rDef.DteValidUntil    := QryPartDteValidUntil   .Value;
          // Sell Information
          rDef.UnitSellGBP      := QryPartUnitSellGBP     .Value;
          rDef.IsFixedSellPrice := QryPartIsFixedSellPrice.AsBoolean;
          rDef.UNITSELL_ALT_CURCODE := qryPartUNITSELL_ALT_CURCODE.AsString;
          rDef.UNITSELL_ALT := qryPartUNITSELL_ALT.value;
          // Purchase Info
          rDef.QtyOnOrder       := QryPartOnOrder         .Value;
          rDef.LastOrderedDte   := QryPartLastOrdered     .Value;
          rDef.LastUnitCostGBP  := QryPartLastUnitCostGBP .Value;
          rDef.LastOrderTranNo  := QryPartLastOrderTranNo .Value;
          rDef.NextExpectedDte  := QryPartNextExpected    .Value;
          rDef.NextOrderTranNo  := QryPartNextOrderTranNo .Value;
          //
          rDef.AvgUnitCostGBP   := QryPartAvgUnitCostGBP  .Value;
          // Parameter Info
          // NeedManualParams will be set when there are >= 30 parameters, and dealt with by loading from a separate query
          if QryPartNeedManualParams.AsBoolean then GetPartParametersToString(AuIBDatabase, AsPartNo, rDef.PartParams) else rDef.PartParams:= QryPartParamsForPart.Value;
          // Operations Info
          // NeedManualOps will be set when there are >= 10 parameters, and dealt with by loading from a separate query
          if QryPartNeedManualOps   .AsBoolean then GetPartOperationsToString(AuIBDatabase, AsPartNo, rDef.PartOps)    else rDef.PartOps   := QryPartOpsForPart   .Value;

          rDef.master_id   :=    qrypartMaster_id.asInteger;
        end;
      finally
        QryPart.Close;
      end;
    end;
  end;
  //
  rPartDef:= rDef;
  Result  := rPartDef.HasPartInfo;
end;



function GetCountryInfo(AuIBDatabase: TIBDatabase; AsCountryNo: String; var rCountry: TvalCountry): Boolean;
begin
  Result:= False;
  FillChar(rCountry, SizeOf(TValCountry), #0); 
  //
  if (not IsEmptyStr(AsCountryNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID.ModAID do
    begin
      QryCountry.Close;
      QryCountry.Database:= AuIBDatabase;
      QryCountry.ParamByName('AsCountryNo').AsString:= AsCountryNo;
      QryCountry.Open;
      try
        rCountry.Found         := not QryCountry.IsEmpty;
        rCountry.CountryNo     := QryCountryCountryNo     .AsString;
        rCountry.CountryName   := QryCountryCountryName   .AsString;
        rCountry.TelCode       := QryCountryTelCode       .AsString;
        rCountry.CurrencySupply:= QryCountryCurrencySupply.AsString;
        rCountry.CurrencySales := QryCountryCurrencySales .AsString;
        rCountry.RegionSales   := QryCountryRegionSales   .AsString;
      finally
        QryCountry.Close;
      end;
    end;
  end;
end;



function GetPartParametersToString(AuIBDatabase: TIBDatabase; AsPartNo: string; var sPartParams: string): Boolean;
begin
  Result:= False;
  //
  if (not IsEmptyStr(AsPartNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID .ModAID do
    begin
      QryPtParam.Close;
      QryPtParam.Database:= AuIBDatabase;
      QryPtParam.ParamByName('AsPartNo').AsString:= AsPartNo;
      QryPtParam.Open;
      try
        sPartParams:= '';
        while not QryPtParam.Eof do
        begin
          sPartParams:= sPartParams+QryPtParamPartParam.AsString+';';
          QryPtParam.Next;
          Result:= True;
        end;
      finally
        QryPtParam.Close;
      end;
    end;
  end;
end;


function GetPartOperationsToString(AuIBDatabase: TIBDatabase; AsPartNo: string; var sPartOps: string): Boolean;
begin
  Result:= False;
  //
  if (not IsEmptyStr(AsPartNo)) then
  begin
    CheckAIDModuleIsReady(AuIBDatabase);
    //
    with d_AID .ModAID do
    begin
      QryPtOp.Close;
      QryPtOp.Database:= AuIBDatabase;
      QryPtOp.ParamByName('AsPartNo').AsString:= AsPartNo;
      QryPtOp.Open;
      //
      try
        sPartOps:= '';
        while not QryPtOp.Eof do
        begin
          sPartOps:= sPartOps+Trim(QryPtOpOperation.AsString)+';';
          QryPtOp.Next;
          Result:= True;
        end;
      finally
        QryPtOp.Close;
      end;
    end;                  
  end;
end;

function SortColumnindicator(field : string;ds : Tdataset;Calculatedfield : TFieldCalculatedResolver) : string ;
begin
  if assigned(ds.fieldbyname(field)) then
  begin
    with ds.fieldbyname(field) do
    begin
      result := fieldname;
      if ds.fieldbyname(field).fieldkind <> fkdata then
      begin
        result := '';//its not going to sort on a calculated field at SQL level.
        //check for calculated field resolution to 'real' field
        if assigned(Calculatedfield)
        and assigned(Calculatedfield(field)) then
          result := Calculatedfield(field).FieldName;

        //check if an origin has been set in code.
        if (result = '')
        and (Origin <>'')
        and (Origin <>fieldname) then
          result := origin;
      end
      else if (Origin <>'')
      and (Origin <>fieldname) then
        result := origin;
    end;
  end
  else
    result := '-9999';
end;

  end.
