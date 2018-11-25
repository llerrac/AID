unit aidCountryObj;

{ aidCountryObj
    An object for caching country information. The intention is to build
    formatting procs. into this at a later time.
}

interface

uses
  Classes, Controls, StdCtrls, db, dbCtrls;

type
  TCountryRegionObj = class(TObject)  //  Single Country Region object
  private
    FsRegionKey        : string;
    FsRegionDesc       : string;
  public
    property RegionKey  : string read FsRegionKey  write FsRegionKey;
    property RegionDesc : string read FsRegionDesc write FsRegionDesc;
  end;
type
  TCountryCacheRequest = procedure(AoSender: TObject; AsCountryNo: string) of object;
type
  TCountryObj = class(TObject)      // Single Country Object
  private
    FsCountryNo        : string;
    FsCountryName      : string;
    //
    FlHasRegions       : Boolean;
    FsRegionDesc       : string;
    FlRegionIsMandatory: Boolean;
    FoRegions          : TStringList;
    //
    FsPostalCodeCaption: string;
    function GetPostalCodeCaption: string;
    function ValidatedCountryRegionNo(AsRegionNo: string): string;
    function GetIsRegionCached: Boolean;
    function GetRegionCount: Integer;
    function GetRegion(Index: Integer): TCountryRegionObj;
  protected
    //
  public
    constructor Create;
    destructor  Destroy; override;
    //
    function  AddRegion (AsRegionKey: string): TCountryRegionObj;
    function  FindRegion(AsRegionKey: string): TCountryRegionObj;
    procedure ClearRegions;
    //
    property  CountryNo        : string  read FsCountryNo          write FsCountryNo;
    property  CountryName      : string  read FsCountryName        write FsCountryName;
    //
    property  HasRegions       : Boolean read FlHasRegions         write FlHasRegions;
    property  IsRegionCached   : Boolean read GetIsRegionCached;
    property  RegionDescription: string  read FsRegionDesc         write FsRegionDesc;
    property  RegionIsMandatory: Boolean read FlRegionIsMandatory  write FlRegionIsMandatory;
    property  PostalCodeCaption: string  read GetPostalCodeCaption write FsPostalCodeCaption;
    property  RegionCount      : Integer read GetRegionCount;
    property  Regions[Index: Integer]: TCountryRegionObj read GetRegion;
  end;

type
  TAddressEntryRec = record
    AddresseeLabel  : TCustomLabel;
    AddresseeEntry  : TCustomEdit;
//    AddresseeCaption: String;
    AddressLabel    : TCustomLabel;
    AddressEntry    : TCustomEdit;
    PostCodeLabel   : TCustomLabel;
    PostCodeEntry   : TCustomEdit;
    RegionLabel     : TCustomLabel;
    RegionEntry     : TdbLookupCombobox;
    RegionLkpDataset: TDataset;
  end;

type
  TaidCountryCache = class(TComponent)
  private
    FoCache          : TStringList;
    FOnCountryRequest: TCountryCacheRequest;
    function  ValidatedCountryNo(AsCountryNo: string): string;
    procedure SetOnCountryRequest(const Value: TCountryCacheRequest);
  protected
    procedure ClearCache;
    procedure DoCountryCacheRequest(AsCountryNo: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    //
    //
    procedure Clear;
    procedure ClearCountry     (AsCountryNo: string);
    procedure PrepareForDataEntry(AsCountryNo: string; rEntry: TAddressEntryRec);
    function  IsCountryCached  (AsCountryNo: string): Boolean;
    function  AddCountry       (AsCountryNo: string): TCountryObj;
    function  FindCountry      (AsCountryNo: string): TCountryObj;
  published
    property  OnCountryRequest: TCountryCacheRequest read FOnCountryRequest write SetOnCountryRequest;
  end;

{var
  CountryCache: TCountryCache;}

implementation

uses
  SysUtils, crUtil;

{ TCountryCache }
constructor TaidCountryCache.Create;
begin
  inherited;
  //
  FoCache:= TStringList.Create;
  FoCache.Sorted:= True;
  FoCache.Duplicates:= dupIgnore;
end;

destructor TaidCountryCache.Destroy;
begin
  FreeAndNil(FoCache);
  inherited;
end;

function TaidCountryCache.AddCountry(AsCountryNo: string): TCountryObj;
var
  iK    : Integer;
  sCo   : String;
begin
  sCo:= ValidatedCountryNo(AsCountryNo);
  iK := FoCache.IndexOf(sCo);
  //
  if (iK<0) then
  begin
    Result:= TCountryObj.Create;
    Result.CountryNo:= AsCountryNo;
    iK:= FoCache.AddObject(AsCountryNo, Result);
  end;
  //
  Result:= TCountryObj(FoCache.Objects[iK]);
end;

procedure TaidCountryCache.ClearCountry(AsCountryNo: string);
var
  iK    : Integer;
  oObj  : TObject;
begin
  iK:= FoCache.IndexOf(ValidatedCountryNo(AsCountryNo));
  if (iK>=0) then
  begin
    oObj:= FoCache.Objects[iK];
    FoCache.Delete(iK);
    if Assigned(oObj) then FreeAndNil(oObj);
  end;
end;


function TaidCountryCache.IsCountryCached(AsCountryNo: string): Boolean;
begin
  Result:= FoCache.IndexOf(ValidatedCountryNo(AsCountryNo))>=0;
end;


function TaidCountryCache.ValidatedCountryNo(AsCountryNo: string): string;
begin
  Result:= UpperCase(Trim(AsCountryNo));
end;


procedure TaidCountryCache.ClearCache;
var
  iK    : Integer;
  oObj  : TObject;
begin
  for iK:= 0 to FoCache.Count-1 do
  begin
    oObj:= FoCache.Objects[iK];
    FoCache.Delete(iK);
    if Assigned(oObj) then
      FreeAndNil(oObj);
  end;
end;


function TaidCountryCache.FindCountry(AsCountryNo: string): TCountryObj;
var
  iK  : Integer;
begin
  Result:= nil;
  iK:= FoCache.IndexOf(ValidatedCountryNo(AsCountryNo));
  if (iK>=0) then
    Result:= TCountryObj(FoCache.Objects[iK]);
end;


procedure TaidCountryCache.Clear;
begin
  ClearCache;
end;


function TCountryObj.AddRegion(AsRegionKey: string): TCountryRegionObj;
var
  iK: Integer;
begin
  iK:= FoRegions.IndexOf(ValidatedCountryRegionNo(AsRegionKey));
  if iK<0 then
  begin
    Result:= TCountryRegionObj.Create;
    Result.RegionKey:= AsRegionKey;
    //
    iK:= FoRegions.AddObject(AsRegionKey, Result);
  end;
  //
  Result:=  TCountryRegionObj(FoRegions.Objects[iK]);
end;


function TCountryObj.FindRegion(AsRegionKey: string): TCountryRegionObj;
var
  iK: Integer;
begin
  Result:= nil;
  //
  iK:= FoRegions.IndexOf(ValidatedCountryRegionNo(AsRegionKey));
  if iK>=0 then
    if Assigned(FoRegions.Objects[iK]) then
      Result:=  TCountryRegionObj(FoRegions.Objects[iK]);
end;


procedure TCountryObj.ClearRegions;
var
  iK  : Integer;
begin
  try
    for iK:= 0 to FoRegions.Count-1 do
    begin
      FoRegions.Objects[iK].Free;
      FoRegions.Objects[iK]:= nil;
    end;
  finally
    FoRegions.Clear;
  end;
end;

constructor TCountryObj.Create;
begin
  FoRegions:= TStringList.Create;
  FoRegions.Sorted:= True;
  FoRegions.Duplicates:= dupIgnore;
end;

destructor TCountryObj.Destroy;
begin
  ClearRegions;
  FreeAndNil(FoRegions);
  inherited;
end;

function TCountryObj.GetIsRegionCached: Boolean;
begin
  Result:= (FoRegions.Count>0) or (not HasRegions);
end;

function TCountryObj.GetPostalCodeCaption: string;
const
  CPOSTCODE = 'Post Code';
begin
  if IsEmptyStr(FsPostalCodeCaption) then
    Result:= CPOSTCODE
  else
    Result := FsPostalCodeCaption;
end;


function TCountryObj.ValidatedCountryRegionNo(AsRegionNo: string): string;
begin
  Result:= UpperCase(AsRegionNo);
end;

procedure TaidCountryCache.SetOnCountryRequest(const Value: TCountryCacheRequest);
begin
  FOnCountryRequest := Value;
end;

procedure TaidCountryCache.PrepareForDataEntry(AsCountryNo: string; rEntry: TAddressEntryRec);
var
  sCntry  : string;
  oCntry  : TCountryObj;

  procedure LoadControlLabel(ALabel: TCustomLabel; ADataEntry: TControl; sCaption: string);
  begin
    if Assigned(ALabel)     then ALabel.Caption:= Coloned(sCaption);
    if Assigned(ADataEntry) then ALabel.Left:= ADataEntry.Left - (ALabel.Width + 3);
  end;


  procedure LoadRegionsFromTo(ACountry: TCountryObj; AuLookup: TDataSet);
  var
    uKey,
    uDesc : TField;
    iK    : Integer;
    uRgn  : TCountryRegionObj;
  begin
    if Assigned(ACountry) and Assigned(AuLookup) then
    begin
      AuLookup.Close;
      if ACountry.HasRegions then
      begin
        AuLookup.Open;
        uKey := AuLookup.FindField('RegionKey' );
        uDesc:= AuLookup.FindField('RegionDesc');
        for iK:= 0 to Pred(ACountry.RegionCount) do
        begin
          uRgn:= ACountry.Regions[iK];
          if Assigned(uRgn) then
          begin
            AuLookup.Append;
            if Assigned(uKey ) then uKey  .AsString:= uRgn.RegionKey;
            if Assigned(uDesc) then uDesc .AsString:= uRgn.RegionDesc;
            AuLookup.Post;
          end;
        end;
      end;
    end;
  end;


begin
  sCntry:= self.ValidatedCountryNo(AsCountryNo);
  if not IsEmptyStr(sCntry) then
  begin
    oCntry:= self.FindCountry(sCntry);
    if not Assigned(oCntry) then
    begin
      DoCountryCacheRequest(sCntry);
      oCntry:= self.FindCountry(sCntry);
    end;
    //
    if Assigned(oCntry) then
    begin
      { Addressee }
      if Assigned(rEntry.AddresseeLabel)    then
        rEntry.AddresseeLabel.Caption:= Coloned('Addressee');
      { Address   }
      if Assigned(rEntry.AddressLabel)      then
        rEntry.AddressLabel  .Caption:= Coloned('Address');
      { Postcode  }
      if Assigned(rEntry.PostCodeLabel)     then
        rEntry.PostCodeLabel .Caption := Coloned(oCntry.PostalCodeCaption);
      { Regions }
      if Assigned(rEntry.RegionLabel      ) then rEntry.RegionLabel.Visible:= oCntry.HasRegions;
      if Assigned(rEntry.RegionEntry      ) then rEntry.RegionEntry.Visible:= oCntry.HasRegions;
      //
      if oCntry.HasRegions then
      begin
        LoadControlLabel(rEntry.RegionLabel, rEntry.RegionEntry, oCntry.RegionDescription);
        LoadRegionsFromTo(oCntry, rEntry.RegionLkpDataset);
      end;
    end;
  end;
end;

procedure TaidCountryCache.DoCountryCacheRequest(AsCountryNo: string);
begin
  if Assigned(FOnCountryRequest) then
    FOnCountryRequest(Self, AsCountryNo);
end;

function TCountryObj.GetRegionCount: Integer;
begin
  if Self.HasRegions then
    Result:= FoRegions.Count
  else
    Result:= -1;
end;

function TCountryObj.GetRegion(Index: Integer): TCountryRegionObj;
begin
  Result:= nil;
  if (Index>=0) and (Index<FoRegions.Count) then
  begin
    Result:= TCountryRegionObj(FoRegions.Objects[Index]);
  end;
end;

{initialization
  CountryCache:= TaidCountryCache.Create;

finalization
  FreeAndNil(CountryCache);}

end.
