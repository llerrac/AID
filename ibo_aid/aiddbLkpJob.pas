unit aiddbLkpJob;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpJob
  Author      : Chris G. Royle (CGR20070117) (copied from aiddbLkpSite)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide a
    Job No. Lookup Component.
  Note        :
  See Also    : dataJob.sql, aiddblkpWarehouse
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
  TaiddbLkpJobFilterStyle  =
    ( aljobAllJobs, aljobIncludeCurrentData, 
      aljobIncludeResourceAllocationJobs, alJobIncludePurchasingAnalysisJobs, aljobIncludeSalesAnalysisJobs, aljobIncludeMachineJobs);
  TaiddbLkpJobFilterElements = set of TaiddbLkpJobFilterStyle;
type
  TaiddbLkpJob = Class(TaiddbCustomLookupList)
  private
    FeFilterLookupElements: TaiddbLkpJobFilterElements;
    FsFilterOwnershipSites: TSiteCollection;
    {}
    procedure SetFilterLookupElements(const Value: TaiddbLkpJobFilterElements);
    procedure SetFilterOwnershipSites(const Value: TSiteCollection);
  protected
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
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
    property FilterOwnershipSites : TSiteCollection             read FsFilterOwnershipSites write SetFilterOwnershipSites;
    property FilterElements       : TaiddbLkpJobFilterElements  read FeFilterLookupElements write SetFilterLookupElements;
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


type
  TaiddbLkpJobObject = class(TaiddbCustomLookupListItem)
  private
    FsJobNo           : TJobNo;
    FsJobName         : String;
    FbIsObsolete      : Boolean;   { Hidden / cancelled Job. }
    {}
    FsOwnerSiteNo     : TSiteNo;
    FsPurchasingSiteNo: TSiteNo;
    {}
    FbVisibleToResourceAllocation,
    FbVisibleToPurchasing,
    FbVisibleToSales,
    FbIsAMachineJob   : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsJobNo : TJobNo; AsJobName: String; AbIsObsolete: Boolean);
    {}
    property JobNo                      : TJobNo  read FsJobNo;
    property JobName                    : String  read FsJobName;
    property IsObsolete                 : Boolean read FbIsObsolete;
    {}
    property OwnerSite                  : TSiteNo read FsOwnerSiteNo                 write FsOwnerSiteNo;
    property PurchasingSite             : TSiteNo read FsPurchasingSiteNo            write FsPurchasingSiteNo;
    {}
    property VisibleToResourceAllocation: Boolean read FbVisibleToResourceAllocation write FbVisibleToResourceAllocation;
    property VisibleToPurchasing        : Boolean read FbVisibleToPurchasing         write FbVisibleToPurchasing;
    property VisibleToSales             : Boolean read FbVisibleToSales              write FbVisibleToSales;
    property IsAMachineJob              : Boolean read FbIsAMachineJob               write FbIsAMachineJob;
  end;

var
  GlobalLookupPopulation  : TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math
  { 3rd Party Units }

  { Application Units };

{ TaiddbLkpJob }
constructor TaiddbLkpJob.Create(AOwner: TComponent);
begin
  inherited;
  FeFilterLookupElements:= [aljobAllJobs];
end;

procedure TaiddbLkpJob.SetFilterLookupElements(const Value: TaiddbLkpJobFilterElements);
begin
  if (FeFilterLookupElements <> Value) then
  begin
    FeFilterLookupElements:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpJob.SetFilterOwnershipSites(const Value: TSiteCollection);
begin
  if (FsFilterOwnershipSites <> Value) then
  begin
    FsFilterOwnershipSites:= Value;
    RefreshLookup();
  end;
end;


procedure TaiddbLkpJob.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalLookupPopulation) then
      GlobalLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;


function TaiddbLkpJob.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oJobObject : TaiddbLkpJobObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpJobObject) then
  begin
    oJobObject:= TaiddbLkpJobObject(AoLookupItem);
    {}
    if  (aljobAllJobs in FilterElements) then
      Result:= True
    else
    begin
      Result:= False;
      Result:= Result or (oJobObject.VisibleToResourceAllocation and (aljobIncludeResourceAllocationJobs in FilterElements));
      Result:= Result or (oJobObject.VisibleToPurchasing         and (alJobIncludePurchasingAnalysisJobs in FilterElements));
      Result:= Result or (oJobObject.VisibleToSales              and (aljobIncludeSalesAnalysisJobs      in FilterElements));
      Result:= Result or (oJobObject.IsAMachineJob               and (aljobIncludeMachineJobs            in FilterElements));
      if (aljobIncludeCurrentData in  FilterElements) then
        Result:= Result or (SameText(Trim(oJobObject.JobNo), Trim(AsDataKey) ));
    end;
  end;
end;

{ TaiddbLkpJobObject }
constructor TaiddbLkpJobObject.Create(AsJobNo : TJobNo; AsJobName: String; AbIsObsolete: Boolean);
begin
  self.FsJobNo     := AsJobNo;
  self.FsJobName   := AsJobName;
  self.FbIsObsolete:= AbIsObsolete;
end;


procedure TaiddbLkpJobObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iKeyWidth : Integer;
  iGapWidth : Integer;
  iMid      : Integer;
  rKeyRect  : TRect;
  rDescRect : TRect;
  sJobNo    : String;
  sJobName  : String;
  wDivColor : TColor;
begin
  inherited;
  wDivColor:= AoCanvas.Font.Color;
  { Establish the Key Width }
  iKeyWidth:= MulDiv(AoCanvas.TextWidth ('BEDMSC09'), 11, 10);
  iGapWidth:= MulDiv(AoCanvas.TextWidth ('M')       ,  2,  4);
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);
  { Key Location }
  rKeyRect := ArRect;
  rKeyRect .Right:= rKeyRect .Left+iKeyWidth+iGapWidth;
  { Description Location }
  rDescRect:= ArRect;
  rDescRect.Left := rDescRect.Left+iKeyWidth+(iGapWidth*2);

  { Draw the Key Field }
  sJobNo:= self.JobNo;
  DrawText(AoCanvas.Handle, PChar(sJobNo), Length(sJobNo), rKeyRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw the Description field }
  sJobName:= Self.JobName;
  if IsObsolete then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sJobName), Length(sJobName), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

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
  GlobalLookupPopulation  := nil;


end.
