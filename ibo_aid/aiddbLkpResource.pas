unit aiddbLkpResource;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpResource
  Author      : Chris G. Royle (CGR20070123) (copied from aiddbLkpJob)
  Description : Lookups relating to resource allocation ie Timesheets. 
  Note        :
  See Also    : aiddbLkpWarehouse
  Modified    :
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

type
  TaiddbLkpResourceFunctionFilterStyle =
    ( alResourceFunctionAll, alResourceFunctionActive, alResourceFunctionOrFieldObsolete );
type
  TaiddbLkpResourceFunctionObject = Class;

  TaiddbLkpResourceFunction = Class(TaiddbCustomLookupList)
  private
    FeFilterLookupStyle : TaiddbLkpResourceFunctionFilterStyle;
    FsFunctionGroup: TLookup;
    FsSiteNo: TSiteNo;
    procedure SetFilterLookupStyle(const Value: TaiddbLkpResourceFunctionFilterStyle);
    procedure SetSiteNo(const Value: TSiteNo);
    procedure SetFunctionGroup(const Value: TLookup);
  protected
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
    { AllowDuplicates
        overridden to allow for compound keys. }
    function  AllowDuplicates: Boolean; override;
    { LookupItemForKey
        overridden to allow for compound keys. }
    function  LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem; override;
  public
    property Style;
    property AutoDropDown;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property Ctl3D;
    property ParentCtl3D;

    property OnChange;
    property OnCloseUp;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    {}
    constructor Create(AOwner: TComponent); override;
    { Additional Filter Properties }
    property SiteNo       : TSiteNo read FsSiteNo        write SetSiteNo;
    property FunctionGroup: TLookup read FsFunctionGroup write SetFunctionGroup;
    { LookupItem
        Query routine for use by outside processes. }
    function  LookupItem(const AsSiteNo: TSiteNo; const AsFunctionGroup: TLookup; const AsFunctionCode: String): TaiddbLkpResourceFunctionObject;
  published
    property AutoComplete;
    property ApplyChangeImmediately;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpResourceFunctionFilterStyle  read FeFilterLookupStyle write SetFilterLookupStyle;
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
    {}
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

  TaiddbLkpResourceFunctionObject = class(TaiddbCustomLookupListItem)
  private
    FsFunctionCode     : TLookup;
    FsFunctionDesc     : TDesc50;
    FsFunctionGroup    : TLookup;
    FsSiteNo           : TSiteNo;
    FsFunctionArea     : TLookup;
    FwColorFG          : TColor;
    FwColorBG          : TColor;
    FbIsHoliday        : Boolean;
    FbIsJobNoRequired  : Boolean;
    FbiSJobRefRequired : Boolean;
    FbIsObsolete       : Boolean;
  protected            
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsSiteNo: TSiteNo; AsFunctionCode: TLookup; AsFunctionDesc: TDesc50; AsFunctionGroup: TLookup; AbIsObsolete: Boolean);
    {}
    property FunctionCode     : TLookup read FsFunctionCode;
    property FunctionDesc     : TDesc50 read FsFunctionDesc;
    property FunctionGroup    : TLookup read FsFunctionGroup;
    property SiteNo           : TSiteNo read FsSiteNo           write FsSiteNo;
    property FunctionArea     : TLookup read FsFunctionArea     write FsFunctionArea;
    property ColorFG          : TColor  read FwColorFG          write FwColorFG;
    property ColorBG          : TColor  read FwColorBG          write FwColorBG;
    property IsHoliday        : Boolean read FbIsHoliday        write FbIsHoliday;
    property IsJobNoRequired  : Boolean read FbIsJobNoRequired  write FbIsJobNoRequired;
    property IsJobRefRequired : Boolean read FbiSJobRefRequired write FbIsJobRefRequired;
    property IsObsolete       : Boolean read FbIsObsolete;
  end;

var
  GlobalResourceFunctionLookupPopulation  : TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math,
  { 3rd Party Units }

  { Application Units }
  crUtil;

{ TaiddbLkpResourceFunction }
constructor TaiddbLkpResourceFunction.Create(AOwner: TComponent);
begin
  inherited;
  FeFilterLookupStyle:= alResourceFunctionAll;
end;

procedure TaiddbLkpResourceFunction.SetFilterLookupStyle(const Value: TaiddbLkpResourceFunctionFilterStyle);
begin
  if (FeFilterLookupStyle <> Value) then
  begin
    FeFilterLookupStyle:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpResourceFunction.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(aiddblkpResource.GlobalResourceFunctionLookupPopulation) then
      aiddblkpResource.GlobalResourceFunctionLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;


function TaiddbLkpResourceFunction.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oFuncObj : TaiddbLkpResourceFunctionObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpResourceFunctionObject) then
  begin
    oFuncObj:= TaiddbLkpResourceFunctionObject(AoLookupItem);
    Result:= SameText(oFuncObj.SiteNo       , self.SiteNo) and
             SameText(oFuncObj.FunctionGroup, self.FunctionGroup);
    {}
    if Result then
      case FilterStyle of
        alResourceFunctionAll             :
          Result:=  True;
        alResourceFunctionActive          :
          Result:=  not oFuncObj.IsObsolete;
        alResourceFunctionOrFieldObsolete :
          Result:= (not oFuncObj.IsObsolete) or (SameText(RTrim(AsDataKey), RTrim(oFuncObj.FunctionCode)));
      end;
  end;
end;

procedure TaiddbLkpResourceFunction.SetSiteNo(const Value: TSiteNo);
begin
  if (FsSiteNo <> Value) then
  begin
    FsSiteNo:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpResourceFunction.SetFunctionGroup(const Value: TLookup);
begin
  if (FsFunctionGroup <> Value) then
  begin
    FsFunctionGroup:= Value;
    RefreshLookup();
  end;
end;

{ AllowDuplicates
    overridden to allow for compound keys. }
function TaiddbLkpResourceFunction.AllowDuplicates: Boolean;
begin
  { Functions Codes can be duplicated within Site and Function Group combination. }
  Result:= True;
end;

{ LookupItemForKey
    overridden to allow for compound keys. }
function TaiddbLkpResourceFunction.LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem;
var
  iK  : Integer;
  oTmp: TaiddbLkpResourceFunctionObject;
begin
  Result:= nil;
  { This code will work on a uniquely indexed key. Compound key descendants should override this. }
  for iK:= 0 to AoLookupList.Count-1 do
  begin
    if Assigned(AoLookupList.Objects[iK]) and (AoLookupList.Objects[iK] is TaiddbLkpResourceFunctionObject) then
    begin
      oTmp:= TaiddbLkpResourceFunctionObject(AoLookupList.Objects[iK]);
      if SameText(oTmp.SiteNo       , self.SiteNo       ) and
         SameText(oTmp.FunctionGroup, self.FunctionGroup) and
         SameText(oTmp.FunctionCode , AsKey) then
      begin
        Result:= oTmp;
        Break;
      end;
    end;
  end;
end;


{ LookupItem
    Query routine for use by outside processes. }
function TaiddbLkpResourceFunction.LookupItem(const AsSiteNo: TSiteNo; const AsFunctionGroup: TLookup; const AsFunctionCode: String): TaiddbLkpResourceFunctionObject;
var
  iK      : Integer;
  oTmp    : TaiddbLkpResourceFunctionObject;
  oValues : TStringList;
begin
  Result := nil;
  { Ensure population }
  CheckPopulateList();
  oValues:= self.LookupList();
  if Assigned(oValues) then
    for iK:= 0 to oValues.Count-1 do
      if Assigned(oValues.Objects[iK]) and (oValues.Objects[iK] is TaiddbLkpResourceFunctionObject) then
      begin
        oTmp:= TaiddbLkpResourceFunctionObject(oValues.Objects[iK]);
        {}
        if SameText(oTmp.SiteNo       , self.SiteNo       ) and
           SameText(oTmp.FunctionGroup, self.FunctionGroup) and
           SameText(oTmp.FunctionCode , AsFunctionCode    ) then
        begin
          Result:= oTmp;
          Break;
        end;
      end;
end;


{ TaiddbLkpResourceFunctionObject }
constructor TaiddbLkpResourceFunctionObject.Create(
  AsSiteNo: TSiteNo; AsFunctionCode: TLookup; AsFunctionDesc: TDesc50; AsFunctionGroup: TLookup; AbIsObsolete: Boolean);
begin
  self.FsSiteNo       := AsSiteNo;
  self.FsFunctionCode := AsFunctionCode;
  self.FsFunctionDesc := AsFunctionDesc;
  self.FsFunctionGroup:= AsFunctionGroup;
  self.FbIsObsolete   := AbIsObsolete;
end;


procedure TaiddbLkpResourceFunctionObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iKeyWidth : Integer;
  iGapWidth : Integer;
  iMid      : Integer;
  rKeyRect  : TRect;
  rDescRect : TRect;
  sFuncNo    : String;
  sFuncName  : String;
  wDivColor : TColor;
begin
  inherited;
  wDivColor:= AoCanvas.Font.Color;
  { Establish the Key Width }
  iKeyWidth:= MulDiv(AoCanvas.TextWidth ('MMM'), 11, 10);
  iGapWidth:= MulDiv(AoCanvas.TextWidth ('M')       ,  2,  4);
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);
  { Key Location }
  rKeyRect := ArRect;
  rKeyRect .Right:= rKeyRect .Left+iKeyWidth+iGapWidth;
  { Description Location }
  rDescRect:= ArRect;
  rDescRect.Left := rDescRect.Left+iKeyWidth+(iGapWidth*2);
  { Set the color according to the function type. }
  if (AeState = []) or (AeState = [odComboBoxEdit]) then
  begin
    AoCanvas.Brush.Color:= self.ColorBG;
    AoCanvas.Pen  .Color:= self.ColorFG;
    AoCanvas.Font .Color:= self.ColorFG;
    AoCanvas.FillRect(ArRect);
  end;

  { Draw the Key Field }
  sFuncNo:= self.FunctionCode;
  DrawText(AoCanvas.Handle, PChar(sFuncNo), Length(sFuncNo), rKeyRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw the Description field }
  sFuncName:= Self.FunctionDesc;
  if IsObsolete then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sFuncName), Length(sFuncName), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw a seperator between Job & description. }
  AoCanvas.Pen.Color:= wDivColor;                               
  AoCanvas.MoveTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Top);
  AoCanvas.LineTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Bottom);

  { Now, indicate that this is an obsolete Job. }
  if IsObsolete then
  begin
    AoCanvas.Pen.Color:= clGrayText;
    AoCanvas.MoveTo (rDescRect.Left , iMid);
    AoCanvas.LineTo (rDescRect.Right, iMid);
  end;
end;


initialization
  GlobalResourceFunctionLookupPopulation:= nil;


end.
