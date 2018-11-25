unit aiddbLkpSite;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpSite
  Author      : Chris G. Royle (CGR20061216)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide a
    Site Lookup Component.
  Note        :
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
  TaiddbLkpSiteFilterStyle =
    (alsiAll, alsiOnlyActive, alsiActiveOrFieldObsolete, alsiCustom);
type
  TaiddbLkpSite = Class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpSiteFilterStyle;
    procedure SetFilterStyle(const Value: TaiddbLkpSiteFilterStyle);
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
    property FilterStyle: TaiddbLkpSiteFilterStyle read FeLookupFilter write SetFilterStyle;
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
  TaiddbLkpSiteObject = class(TaiddbCustomLookupListItem)
  private
    FsSiteNo    : TSiteNo;
    FsSiteDesc  : String;
    FsRegion    : String;
    FbIsObsolete: Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsSiteNo : TSiteNo; AsSiteDesc, AsRegion: String; AbIsObsolete: Boolean);
    property SiteNo     : TSiteNo read FsSiteNo;
    property SiteDesc   : String  read FsSiteDesc;
    property Region     : String  read FsRegion;
    property IsObsolete : Boolean read FbIsObsolete;
  end;

var
  GlobalLookupPopulation  : TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math
  { 3rd Party Units }

  { Application Units };

constructor TaiddbLkpSite.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alsiAll;
end;



{ TaiddbLkpSiteObject }
constructor TaiddbLkpSiteObject.Create(AsSiteNo: TSiteNo; AsSiteDesc, AsRegion: String; AbIsObsolete: Boolean);
begin
  FsSiteNo      := AsSiteNo;
  FsSiteDesc    := AsSiteDesc;
  FsRegion      := AsRegion;
  FbIsObsolete  := AbIsObsolete;
end;


procedure TaiddbLkpSiteObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iKeyWidth : Integer;
  iGapWidth : Integer;
  iMid      : Integer;
  rKeyRect  : TRect;
  rDescRect : TRect;
  sKey      : String;
  sDesc     : String;
begin
  inherited;
  { Establish the Key Width }
  iKeyWidth:= AoCanvas.TextWidth ('M');
  iGapWidth:= MulDiv(iKeyWidth, 2, 4);
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);
  { Key Location }
  rKeyRect := ArRect;
  rKeyRect .Right:= rKeyRect .Left+iKeyWidth+iGapWidth;

  { Description Location }
  rDescRect:= ArRect;
  rDescRect.Left := rDescRect.Left+iKeyWidth+(iGapWidth*2);

  { Draw the Key Field }
  sKey:= self.SiteNo;
  DrawText(AoCanvas.Handle, PChar(sKey), Length(sKey), rKeyRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_CENTER);

  { Draw the Description field }
  sDesc := Self.SiteDesc;
  if IsObsolete then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sDesc), Length(sDesc), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw a seperator between site & description. }
  AoCanvas.Pen.Color:= clWindowFrame;
  AoCanvas.MoveTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Top);
  AoCanvas.LineTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Bottom);

  { Now, indicate that this is an obsolete site. }
  if IsObsolete then
  begin
    AoCanvas.Pen.Color:= clWindowFrame;
    AoCanvas.MoveTo (rDescRect.Left , iMid);
    AoCanvas.LineTo (rDescRect.Right, iMid);
  end;
end;

{ TaiddbLkpSite }
function TaiddbLkpSite.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oSiteObject : TaiddbLkpSiteObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpSiteObject) then
  begin
    oSiteObject:= TaiddbLkpSiteObject(AoLookupItem); 
    case FilterStyle of
      alsiOnlyActive           :
        Result:=  not oSiteObject.IsObsolete;
      alsiActiveOrFieldObsolete:
        Result:= (not oSiteObject.IsObsolete) or (SameText(AsDataKey, oSiteObject.SiteNo));
    else
      Result:= True;
    end;
  end;
end;

procedure TaiddbLkpSite.SetFilterStyle(const Value: TaiddbLkpSiteFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

procedure TaiddbLkpSite.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalLookupPopulation) then
      GlobalLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

initialization
  GlobalLookupPopulation  := nil;


end.
