unit aiddbLkpWarehouse;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpWarehouse
  Author      : Chris G. Royle (CGR20061216)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide a
    BOMs Warehouse Lookup Component.
  See also    : aiddbLkpSite
  Note        :
  Modified    :
    CGR20061229, Removed the requirement to code a custom filter event.
    CGR20070118, Added lookups to handle Rows, Bins, Stock Movement Directions. 
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Messages, StdCtrls, Types, Classes, Controls, Graphics,
  DB, DBCtrls,
  { 3rd Party Units }
  { Application Units }
  aiddbLkp, aidTypes,
  crdbLkp;

{ Warehouse Lookup --------------------------------------------------------------------------------}
type
  TaiddbLkpWarehouseFilterStyle =
    (alwareSiteAll, alwareSiteActiveOnly, alwareSiteActiveOrFieldObsolete, alwareCustom);
type
  TaiddbLkpWarehouse = class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpWarehouseFilterStyle;
    FsSiteNo      : TSiteNo;
    procedure SetFilterStyle(const Value: TaiddbLkpWarehouseFilterStyle);
    procedure SetSiteNo(const Value: TSiteNo);
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    { AllowDuplicates
        overridden to allow for compound keys. }
    function  AllowDuplicates: Boolean; override;
    { LookupItemForKey
        overridden to allow for compound keys. }
    function  LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Additional Filter Properties }
    property SiteNo: TSiteNo read FsSiteNo write SetSiteNo;
  published
    { Published Properties }
    property AutoComplete;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpWarehouseFilterStyle read FeLookupFilter write SetFilterStyle;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    { Published Events }
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

type
  TaiddbLkpWarehouseObject = class(TaiddbCustomLookupListItem)
  private
    FsWarehouseNo   : TWarehouseNo;
    FsWarehouseDesc : String;
    FsSiteNo        : TSiteNo;
    FbIsObsolete    : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsWarehouseNo: TWarehouseNo; AsWarehouseDesc: String; AsSiteNo: TSiteNo; AbIsObsolete: Boolean);
    {}
    property WarehouseNo  : TWarehouseNo read FsWarehouseNo;
    property WarehouseDesc: String       read FsWarehouseDesc;
    property SiteNo       : TSiteNo      read FsSiteNo;
    property IsObsolete   : Boolean      read FbIsObsolete;
  end;


{ Location Row Lookup -----------------------------------------------------------------------------}
type
  TaiddbLkpRowFilterStyle =
    (alrowWarehouseAll, alrowWarehouseActiveOnly, alrowWarehouseActiveOrFieldObsolete);
type
  TaiddbLkpRow = class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpRowFilterStyle;
    FsSiteNo       : TSiteNo;
    FsWarehouseNo : TWarehouseNo;
    procedure SetFilterStyle(const Value: TaiddbLkpRowFilterStyle);
    procedure SetSiteNo     (const Value: TSiteNo);
    procedure SetWarehouseNo(const Value: TWarehouseNo);
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    { AllowDuplicates
        overridden to allow for compound keys. }
    function  AllowDuplicates: Boolean; override;
    { LookupItemForKey
        overridden to allow for compound keys. }
    function  LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Additional Filter Properties }
    property SiteNo     : TSiteNo       read FsSiteNo        write SetSiteNo;
    property WarehouseNo: TWarehouseNo  read FsWarehouseNo  write SetWarehouseNo;
  published
    { Published Properties }
    property AutoComplete;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpRowFilterStyle read FeLookupFilter write SetFilterStyle;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    { Published Events }
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

type
  TaiddbLkpRowObject = class(TaiddbCustomLookupListItem)
  private
    FsSiteNo        : TSiteNo;
    FsWarehouseNo   : TWarehouseNo;
    FsRowNo         : TRowNo;
    FsRowDesc       : String;
    FbIsObsolete    : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsSiteNo: TSiteNo; AsWarehouseNo: TWarehouseNo; AsRowNo: TRowNo; AsRowDesc: String; AbIsObsolete: Boolean);
    {}
    property SiteNo       : TSiteNo       read FsSiteNo;
    property WarehouseNo  : TWarehouseNo  read FsWarehouseNo;
    property RowNo        : TRowNo        read FsRowNo;
    property RowDesc      : String        read FsRowDesc;
    property IsObsolete   : Boolean       read FbIsObsolete;
  end;



{ Bin Lookup --------------------------------------------------------------------------------}
type
  TaiddbLkpBinFilterStyle =
    (alSiteWareRowAll, alSiteWareRowActiveOnly, alSiteWareRowRowActiveOrFieldObsolete);
type
  TaiddbLkpBin = class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpBinFilterStyle;
    FsSiteNo      : TSiteNo;
    FsWarehouseNo : TWarehouseNo;
    FsRowNo       : TRowNo;
    procedure SetFilterStyle(const Value: TaiddbLkpBinFilterStyle);
    procedure SetSiteNo(const Value: TSiteNo);
    procedure SetWarehouseNo(const Value: TWarehouseNo);
    procedure SetRowNo(const Value: TRowNo);
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    { AllowDuplicates
        overridden to allow for compound keys. }
    function  AllowDuplicates: Boolean; override;
    { LookupItemForKey
        overridden to allow for compound keys. }
    function  LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem; override;
  public
    constructor Create(AOwner: TComponent); override;
    { Additional Filter Properties }
    property SiteNo     : TSiteNo       read FsSiteNo       write SetSiteNo;
    property WarehouseNo: TWarehouseNo  read FsWarehouseNo  write SetWarehouseNo;
    property RowNo      : TRowNo        read FsRowNo        write SetRowNo;
  published
    { Published Properties }
    property AutoComplete;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpBinFilterStyle read FeLookupFilter write SetFilterStyle;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    { Published Events }
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

type
  TaiddbLkpBinObject = class(TaiddbCustomLookupListItem)
  private
    FsSiteNo        : TSiteNo;
    FsWarehouseNo   : TWarehouseNo;
    FsRowNo         : TRowNo;
    FsBinNo         : TBinNo;
    FsBinDesc       : String;
    FeBinType       : aidTypes.TBinType;
    FbIsObsolete    : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsSiteNo: TSiteNo; AsWarehouseNo: TWarehouseNo; AsRowNo: TRowNo; AsBinNo: TBinNo; AsBinDesc: String; AeBinType: TBinType; AbIsObsolete: Boolean);
    {}
    property SiteNo       : TSiteNo       read FsSiteNo;
    property WarehouseNo  : TWarehouseNo  read FsWarehouseNo;
    property RowNo        : TRowNo        read FsRowNo;
    property BinNo        : TBinNo        read FsBinNo;
    property BinDesc      : String        read FsBinDesc;
    property BinType      : TBinType      read FeBinType;
    property IsObsolete   : Boolean       read FbIsObsolete;
  end;


{ Stock Movement Direction ------------------------------------------------------------------------}
type
  TaiddbLkpStockMovementFilterStyle =
    (alStockMovementAll, alStockMovementUserSelectableOnly, alStockMovementActiveOrUserSelectableOnly);
type
  TaiddbLkpStockMovement = class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpStockMovementFilterStyle;
    procedure SetFilterStyle(const Value: TaiddbLkpStockMovementFilterStyle);
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    { Published Properties }
    property AutoComplete;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpStockMovementFilterStyle read FeLookupFilter write SetFilterStyle;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    { Published Events }
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

type
  TaiddbLkpStockMovementObject = class(TaiddbCustomLookupListItem)
  private
    FcDirectionKey    : Char;
    FeDirection       : TaidStockMovementDirection;
    FsCaption         : String;
    FbIsUserSelectable: Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AeDirection: TaidStockMovementDirection; AcKey: Char; AsCaption: String; AbIsUserSelectable: Boolean);
    {}
    property Key              : Char                        read FcDirectionKey     write FcDirectionKey;
    property Direction        : TaidStockMovementDirection  read FeDirection        write FeDirection;
    property Caption          : String                      read FsCaption          write FsCaption;
    property IsUserSelectable : Boolean                     read FbIsUserSelectable write FbIsUserSelectable;
  end;


var
  GlobalWarehouseLookupPopulation : TaiddbLookupListPopulateItems;
  GlobalRowLookupPopulation       : TaiddbLookupListPopulateItems;
  GlobalBinLookupPopulation       : TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math,
  { 3rd Party Units }

  { Application Units }
  aidUtil;


{ TaiddbLkpWarehouseObject }
constructor TaiddbLkpWarehouseObject.Create(AsWarehouseNo: TWarehouseNo; AsWarehouseDesc: String; AsSiteNo: TSiteNo; AbIsObsolete: Boolean);
begin
  FsWarehouseNo   := AsWarehouseNo;
  FsWarehouseDesc := AsWarehouseDesc;
  FsSiteNo        := AsSiteNo;
  FbIsObsolete    := AbIsObsolete;
end;


procedure TaiddbLkpWarehouseObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iHeight   : Integer;
  iSiteWidth: Integer;
  iGapWidth : Integer;
  iMid      : Integer;
  rSiteRect : TRect;
  rDescRect : TRect;
  sSite     : String;
  sDesc     : String;
  wDivColor : TColor;
begin
  inherited;
  wDivColor:= AoCanvas.Font.Color;
  { Paint the Warehouse name & site }
  iHeight   := ArRect.Bottom-ArRect.Top;
  { Establish the Site Width }
  iSiteWidth:= iHeight; {AoCanvas.TextWidth ('M');}
  iGapWidth := MulDiv(iSiteWidth, 1, 4);
  iMid      := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);
  { Site Location }
  rSiteRect := ArRect;
  rSiteRect .Left:= rSiteRect.Right-(iSiteWidth+iGapWidth);

  { Description Location }
  rDescRect:= ArRect;
  rDescRect.Right:= rDescRect.Right-(iSiteWidth+(iGapWidth*2));

  { Draw the Site Field }
  sSite:= self.SiteNo;
  DrawText(AoCanvas.Handle, PChar(sSite), Length(sSite), rSiteRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_CENTER);

  { Draw the Description field }
  sDesc:= Self.WarehouseDesc;
  if IsObsolete then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sDesc), Length(sDesc), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw a seperator between Description & Site. }
  AoCanvas.Pen.Color:= wDivColor;
  AoCanvas.MoveTo (ArRect.Right-(iSiteWidth+(iGapWidth  )), ArRect.Top);
  AoCanvas.LineTo (ArRect.Right-(iSiteWidth+(iGapWidth  )), ArRect.Bottom);

  { Now, indicate that this is an obsolete Item. }
  if IsObsolete then
  begin
    AoCanvas.Pen.Color:= clGrayText;
    AoCanvas.MoveTo (rDescRect.Left +iGapWidth, iMid);
    AoCanvas.LineTo (rDescRect.Right, iMid);
  end;
end;

{ TaiddbLkpWarehouse }
constructor TaiddbLkpWarehouse.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alwareSiteAll;
end;

function TaiddbLkpWarehouse.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oItemObject : TaiddbLkpWarehouseObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpWarehouseObject) then
  begin
    oItemObject:= TaiddbLkpWarehouseObject(AoLookupItem);
    Result:= (oItemObject.SiteNo = self.SiteNo);

    case FilterStyle of
      alWareSiteAll                  :
        Result:= Result and True;
      alwareSiteActiveOnly           :
        Result:= Result and  (not oItemObject.IsObsolete);
      alwareSiteActiveOrFieldObsolete:
        Result:= Result and ((not oItemObject.IsObsolete) or (SameText(AsDataKey, oItemObject.WarehouseNo)));
      alwareCustom               :
        Result:= Result and (DoFilterItem(AsDataKey, AoLookupItem));
    else
      Result:= True;
    end;
  end;
end;


procedure TaiddbLkpWarehouse.SetFilterStyle(const Value: TaiddbLkpWarehouseFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

function TaiddbLkpWarehouse.AllowDuplicates: Boolean;
begin
  { Warehouses can have duplicated key fields - compound key Site+Warehouse. }
  Result:= True;
end;

function TaiddbLkpWarehouse.LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem;
var
  iK  : Integer;
  oTmp: TaiddbLkpWarehouseObject;
begin
  Result:= nil;
  { This code will work on a uniquely indexed key. Compound key descendants should override this. }
  for iK:= 0 to AoLookupList.Count-1 do
  begin
    if Assigned(AoLookupList.Objects[iK]) and (AoLookupList.Objects[iK] is TaiddbLkpWarehouseObject) then
    begin
      oTmp:= TaiddbLkpWarehouseObject(AoLookupList.Objects[iK]);
      if SameText(oTmp.SiteNo, self.SiteNo) and SameText(oTmp.WarehouseNo, AsKey) then
      begin
        Result:= oTmp;
        Break;
      end;
    end;
  end;
end;

procedure TaiddbLkpWarehouse.SetSiteNo(const Value: TSiteNo);
begin
  if (FsSiteNo<>Value) then
  begin
    FsSiteNo := Value;
    RefreshLookup();
  end;
end;



{ TaiddbLkpWarehouse }
procedure TaiddbLkpWarehouse.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalWarehouseLookupPopulation) then
      GlobalWarehouseLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;


{ TaiddbLkpRow }
function TaiddbLkpRow.AllowDuplicates: Boolean;
begin
  { Warehouses can have duplicated key fields - compound key Site+Warehouse+Row. }
  Result:= True;
end;

function TaiddbLkpRow.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oItemObject : TaiddbLkpRowObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpRowObject) then
  begin
    oItemObject:= TaiddbLkpRowObject(AoLookupItem);
    Result     :=(oItemObject.SiteNo      = self.SiteNo) and
                 (oItemObject.WarehouseNo = self.WarehouseNo);
    { Apply Filter Style } 
    case FilterStyle of
      alrowWarehouseAll                  :
        Result:= Result and True;
      alrowWarehouseActiveOnly           :
        Result:= Result and  (not oItemObject.IsObsolete);
      alrowWarehouseActiveOrFieldObsolete:
        Result:= Result and ((not oItemObject.IsObsolete) or (SameText(AsDataKey, oItemObject.RowNo)));
    else
      Result:= True;
    end;
  end;
end;

constructor TaiddbLkpRow.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alrowWarehouseAll;
end;

procedure TaiddbLkpRow.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalRowLookupPopulation) then
      GlobalRowLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

function TaiddbLkpRow.LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem;
var
  iK  : Integer;
  oTmp: TaiddbLkpRowObject;
begin
  Result:= nil;
  { This code will work on a uniquely indexed key. Compound key descendants should override this. }
  for iK:= 0 to AoLookupList.Count-1 do
  begin
    if Assigned(AoLookupList.Objects[iK]) and (AoLookupList.Objects[iK] is TaiddbLkpRowObject) then
    begin
      oTmp:= TaiddbLkpRowObject(AoLookupList.Objects[iK]);
      if SameText(oTmp.SiteNo     , self.SiteNo     ) and
         SameText(oTmp.WarehouseNo, self.WarehouseNo) and
         SameText(oTmp.RowNo      , AsKey) then
      begin
        Result:= oTmp;
        Break;
      end;
    end;
  end;
end;


procedure TaiddbLkpRow.SetFilterStyle(const Value: TaiddbLkpRowFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpRow.SetSiteNo(const Value: TSiteNo);
begin
  if (FsSiteNo<>Value) then
  begin
    FsSiteNo := Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpRow.SetWarehouseNo(const Value: TWarehouseNo);
begin
  if (FsWarehouseNo<>Value) then
  begin
    FsWarehouseNo := Value;
    RefreshLookup();
  end;
end;

{ TaiddbLkpRowObject }
constructor TaiddbLkpRowObject.Create(AsSiteNo: TSiteNo; AsWarehouseNo: TWarehouseNo; AsRowNo: TRowNo; AsRowDesc: String; AbIsObsolete: Boolean);
begin
  FsSiteNo        := AsSiteNo;
  FsWarehouseNo   := AsWarehouseNo;
  FsRowNo         := AsRowNo;
  FsRowDesc       := AsRowDesc;
  FbIsObsolete    := AbIsObsolete;
end;

procedure TaiddbLkpRowObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  sRow  : String;
  iMid  : Integer;
begin
  inherited;
  { Establish the Site Width }
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);

  { Draw the Site Field }
  sRow:= self.RowNo;
  {}
  DrawText(AoCanvas.Handle, PChar(sRow), Length(sRow), ArRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);
  { Now, indicate that this is an obsolete Item. }
  if IsObsolete then
  begin
    AoCanvas.Pen.Color:= clWindowFrame;
    AoCanvas.MoveTo (ArRect.Left , iMid);
    AoCanvas.LineTo (ArRect.Right, iMid);
  end;
end;

{ TaiddbLkpBin }
function TaiddbLkpBin.AllowDuplicates: Boolean;
begin
  { Bins can have duplicated key fields - compound key Site+Warehouse+Row+Bin. }
  Result:= True;
end;

function TaiddbLkpBin.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oItemObject : TaiddbLkpBinObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpBinObject) then
  begin
    oItemObject:= TaiddbLkpBinObject(AoLookupItem);
    Result     :=(oItemObject.SiteNo      = self.SiteNo     ) and
                 (oItemObject.WarehouseNo = self.WarehouseNo) and
                 (oItemObject.RowNo       = self.RowNo      );
    { Apply Filter Style }
    case FilterStyle of
      alSiteWareRowAll                      :
        Result:= Result and True;
      alSiteWareRowActiveOnly               :
        Result:= Result and  (not oItemObject.IsObsolete);
      alSiteWareRowRowActiveOrFieldObsolete :
        Result:= Result and ((not oItemObject.IsObsolete) or (SameText(AsDataKey, oItemObject.RowNo)));
    else
      Result:= True;
    end;
  end;
end;


constructor TaiddbLkpBin.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alSiteWareRowAll;
end;

procedure TaiddbLkpBin.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalBinLookupPopulation) then
      GlobalBinLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

function TaiddbLkpBin.LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem;
var
  iK  : Integer;
  oTmp: TaiddbLkpBinObject;
begin
  Result:= nil;
  { This code will work on a uniquely indexed key. Compound key descendants should override this. }
  for iK:= 0 to AoLookupList.Count-1 do
  begin
    if Assigned(AoLookupList.Objects[iK]) and (AoLookupList.Objects[iK] is TaiddbLkpBinObject) then
    begin
      oTmp:= TaiddbLkpBinObject(AoLookupList.Objects[iK]);
      if SameText(oTmp.SiteNo     , self.SiteNo     ) and
         SameText(oTmp.WarehouseNo, self.WarehouseNo) and
         SameText(oTmp.RowNo      , self.RowNo      ) and
         SameText(oTmp.BinNo, AsKey) then
      begin
        Result:= oTmp;
        Break;
      end;
    end;
  end;
end;

procedure TaiddbLkpBin.SetFilterStyle(const Value: TaiddbLkpBinFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpBin.SetSiteNo(const Value: TSiteNo);
begin
  if (FsSiteNo<>Value) then
  begin
    FsSiteNo := Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpBin.SetWarehouseNo(const Value: TWarehouseNo);
begin
  if (FsWarehouseNo<>Value) then
  begin
    FsWarehouseNo := Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpBin.SetRowNo(const Value: TRowNo);
begin
  if (FsRowNo<>Value) then
  begin
    FsRowNo := Value;
    RefreshLookup();
  end;
end;

{ TaiddbLkpBinObject }
constructor TaiddbLkpBinObject.Create(AsSiteNo: TSiteNo; AsWarehouseNo: TWarehouseNo; AsRowNo: TRowNo; AsBinNo: TBinNo; AsBinDesc: String; AeBinType: TBinType; AbIsObsolete: Boolean);
begin
  FsSiteNo        := AsSiteNo;
  FsWarehouseNo   := AsWarehouseNo;
  FsRowNo         := AsRowNo;
  FsBinNo         := AsBinNo;
  FsBinDesc       := AsBinDesc;
  FeBinType       := AeBinType;
  FbIsObsolete    := AbIsObsolete;
end;

procedure TaiddbLkpBinObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iKeyWidth : Integer;
  iGapWidth : Integer;
  sBinNo    : String;
  sBinDesc  : String;
  iMid      : Integer;
  iHeight   : Integer;
  rBinNoRect: TRect;
  rDescRect : TRect;
  rIconRect : TRect;
  wDivColor : TColor;
begin
  inherited;
  wDivColor:= AoCanvas.Font.Color;
  { Establish the Bin Width }
  iKeyWidth:= AoCanvas.TextWidth ('MMM');

  iGapWidth:= MulDiv(AoCanvas.TextWidth ('M'), 1, 4);
  iHeight  :=(ArRect.Bottom-ArRect.Top);
  iMid     := ArRect.Top + ((iHeight) div 2);

  { Establish the captions }
  sBinNo  := self.BinNo;
  sBinDesc:= self.BinDesc;

  { Draw the Bin Number, Bin Description }
  rBinNoRect:= ArRect;
  rDescRect := ArRect;
  rIconRect := ArRect;
  rBinNoRect.Right:= rBinNoRect.Left+iKeyWidth+iGapWidth;

  rDescRect.Left  := rBinNoRect.Right+iGapWidth;
  rIconRect.Left  := rIconRect .Right-iGapWidth-iHeight;
  rDescRect.Right := rIconRect .Left -iGapWidth;
  { Draw the Bin No. }
  DrawText(AoCanvas.Handle, PChar(sBinNo)  , Length(sBinNo)  , rBinNoRect, DT_LEFT+DT_SINGLELINE+DT_NOPREFIX+DT_VCENTER);
  { Draw the Bin Description. }
  DrawText(AoCanvas.Handle, PChar(sBinDesc), Length(sBinDesc), rDescRect , DT_LEFT+DT_SINGLELINE+DT_NOPREFIX+DT_VCENTER);
  { Draw the Bin Icon }
  aidUtil .DrawBinTypeAsIcon(AoCanvas, rIconRect, self.BinType);
  { Draw a seperator between BinNo & Bin Description. }
  AoCanvas.Pen.Color:= wDivColor;
  AoCanvas.MoveTo (rBinNoRect.Right, ArRect.Top);
  AoCanvas.LineTo (rBinNoRect.Right, ArRect.Bottom);
  { Draw a seperator between Bin Description &. }
  AoCanvas.Pen.Color:= wDivColor;
  AoCanvas.MoveTo (rDescRect .Right, ArRect.Top);
  AoCanvas.LineTo (rDescRect .Right, ArRect.Bottom);
  { Now, indicate that this is an obsolete Item. }
  if IsObsolete then
  begin
    AoCanvas.Pen.Color:= clGrayText;
    AoCanvas.MoveTo (ArRect.Left , iMid);
    AoCanvas.LineTo (ArRect.Right, iMid);
  end;
end;


{ TaiddbLkpStockMovement }
constructor TaiddbLkpStockMovement.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alStockMovementUserSelectableOnly;
end;

function TaiddbLkpStockMovement.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oItemObject : TaiddbLkpStockMovementObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpStockMovementObject) then
  begin
    oItemObject:= TaiddbLkpStockMovementObject(AoLookupItem);
    {}
    case FilterStyle of
      alStockMovementAll                        :
        Result:= True;
      alStockMovementUserSelectableOnly         :
        Result:= oItemObject.IsUserSelectable;
      alStockMovementActiveOrUserSelectableOnly :
        Result:= (oItemObject.IsUserSelectable) or (SameText(AsDataKey, oItemObject.Key)) ;
    else
      Result:= True;
    end;
  end;
end;

procedure TaiddbLkpStockMovement.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
var
  eK  : aidTypes.TaidStockMovementDirection;
  rK  : aidTypes.TaidStockMovementDirectionRecord;
begin
  inherited;
  { Create from aidTypes }
  for eK:= Low(eK) to High(eK) do
  begin
    rK:= aidTypes .StockMovementDirectionByOrd(eK);
    Items.AddObject(rK.Key, TaiddbLkpStockMovementObject.Create(eK, rK.Key, rK.Desc, rk.IsUserSelectable) );
  end;
end;

procedure TaiddbLkpStockMovement.SetFilterStyle(const Value: TaiddbLkpStockMovementFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

{ TaiddbLkpStockMovementObject }
constructor TaiddbLkpStockMovementObject.Create(AeDirection: TaidStockMovementDirection; AcKey: Char; AsCaption: String; AbIsUserSelectable: Boolean);
begin
  self.FeDirection       := AeDirection;
  self.FcDirectionKey    := AcKey;
  self.FsCaption         := AsCaption;
  self.FbIsUserSelectable:= AbIsUserSelectable;
end;

procedure TaiddbLkpStockMovementObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iIconWidth  : Integer;
  sCaption    : String;
  rTextRect   : TRect;
  rIconRect   : TRect;
begin
  inherited;
  iIconWidth  := ArRect.Bottom-ArRect.Top;{AoCanvas.TextWidth ('M');}
  sCaption    := self.Caption;
  { Regions }
  rIconRect      := ArRect;
  rIconRect.Right:= rIconRect.Left+iIconWidth;
  rTextRect      := ArRect;
  rTextRect.Left := rTextRect.Left+iIconWidth+1;
  { Draw the caption }
  DrawText(AoCanvas.Handle, PChar(sCaption), Length(sCaption), rTextRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);
  { Draw the item icon }
  aidUtil.DrawStockMovementDirection(AoCanvas, rIconRect, self.Key, False);
end;

initialization
  GlobalWarehouseLookupPopulation:= nil;
  GlobalRowLookupPopulation      := nil;
  GlobalBinLookupPopulation      := nil;


end.
