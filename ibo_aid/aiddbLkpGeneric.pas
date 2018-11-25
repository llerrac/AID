unit aiddbLkpGeneric;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpGeneric
  Author      : Chris G. Royle (CGR20061216)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide a
    Lookup Component on to the Generic Lookups table.
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
  TaiddbLkpGenericFilterStyle  =
    (alkgenAll, alkgenActiveOnly, alkgenActiveOrFieldObsolete, alkgenCustom);
  TaiddbLkpGenericDisplayStyle =
    (alkgenDisplayKeyAndDescription, alkgenDisplayDescription);

  TaiddbLkpGeneric = Class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpGenericFilterStyle;
    FeDisplayStyle: TaiddbLkpGenericDisplayStyle;
    procedure SetFilterStyle(const Value: TaiddbLkpGenericFilterStyle);
    procedure SetDisplayStyle(const Value: TaiddbLkpGenericDisplayStyle);
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
    { Published declarations }
    property AutoComplete;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DisplayStyle : TaiddbLkpGenericDisplayStyle read FeDisplayStyle write SetDisplayStyle;
    property DropDownCount;
    property Enabled;
    property FilterStyle: TaiddbLkpGenericFilterStyle read FeLookupFilter write SetFilterStyle;
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
  TaiddbLkpGenericObject = class(TaiddbCustomLookupListItem)
  private
    FsLookupNo  : TLookup;
    FsLookupDesc: String;
    FbIsObsolete: Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsLookupNo : TLookup; AsLookupDesc: String; AbIsObsolete: Boolean);
    property LookupNo   : TLookup read FsLookupNo;
    property LookupDesc : String  read FsLookupDesc;
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


constructor TaiddbLkpGeneric.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= alkgenAll;
  FeDisplayStyle:= alkgenDisplayKeyAndDescription;
end;



{ TaiddbLkpGenericObject }
constructor TaiddbLkpGenericObject.Create(AsLookupNo: TLookup; AsLookupDesc: String; AbIsObsolete: Boolean);
begin
  FsLookupNo   := AsLookupNo;
  FsLookupDesc := AsLookupDesc;
  FbIsObsolete := AbIsObsolete;
end;


procedure TaiddbLkpGenericObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  eStyle    : TaiddbLkpGenericDisplayStyle;
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
  iKeyWidth:= AoCanvas.TextWidth ('12345');
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);

  eStyle:=  alkgenDisplayKeyAndDescription;
  if AoOwner is TaiddbLkpGeneric then
    eStyle:=  TaiddbLkpGeneric(AoOwner).DisplayStyle;

  case eStyle of
    alkgenDisplayKeyAndDescription  :
    begin
      { Key Location }
      rKeyRect := ArRect;
      rKeyRect .Right:= rKeyRect .Left+iKeyWidth+iGapWidth;

      { Description Location }
      rDescRect:= ArRect;
      rDescRect.Left := rDescRect.Left+iKeyWidth+(iGapWidth*2);

      { Draw the Key Field }
      sKey:= self.LookupNo;
      DrawText(AoCanvas.Handle, PChar(sKey), Length(sKey), rKeyRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_CENTER);

      { Draw the Description field }
      sDesc:= Self.LookupDesc;
      if IsObsolete then
        AoCanvas.Font.Color:= clGrayText;
      DrawText(AoCanvas.Handle, PChar(sDesc), Length(sDesc), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

      { Draw a seperator between Generic & description. }
      AoCanvas.Pen.Color:= clWindowFrame;
      AoCanvas.MoveTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Top);
      AoCanvas.LineTo (ArRect.Left+iKeyWidth+(iGapWidth  ), ArRect.Bottom);

      { Now, indicate that this is an obsolete Generic. }
      if IsObsolete then
      begin
        AoCanvas.Pen.Color:= clWindowFrame;
        AoCanvas.MoveTo (rDescRect.Left , iMid);
        AoCanvas.LineTo (rDescRect.Right, iMid);
      end;
    end;
    
    alkgenDisplayDescription        :
    begin
      { Draw the Description field }
      sDesc:= Self.LookupDesc;
      if IsObsolete then
        AoCanvas.Font.Color:= clGrayText;
      DrawText(AoCanvas.Handle, PChar(sDesc), Length(sDesc), ArRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);
      { Now, indicate that this is an obsolete Generic. }
      if IsObsolete then
      begin
        AoCanvas.Pen.Color:= clWindowFrame;
        AoCanvas.MoveTo (ArRect.Left , iMid);
        AoCanvas.LineTo (ArRect.Right, iMid);
      end;
    end;
  end;
end;

{ TaiddbLkpGeneric }
function TaiddbLkpGeneric.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oGenericObject : TaiddbLkpGenericObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpGenericObject) then
  begin
    oGenericObject:= TaiddbLkpGenericObject(AoLookupItem); 
    case FilterStyle of
      alkgenActiveOnly           :
        Result:=  not oGenericObject.IsObsolete;
      alkgenActiveOrFieldObsolete:
        Result:= (not oGenericObject.IsObsolete) or (SameText(AsDataKey, oGenericObject.LookupNo));
    else
      Result:= True;
    end;
  end;
end;

procedure TaiddbLkpGeneric.SetFilterStyle(const Value: TaiddbLkpGenericFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;


procedure TaiddbLkpGeneric.SetDisplayStyle(const Value: TaiddbLkpGenericDisplayStyle);
begin
  if (FeDisplayStyle<> Value) then
  begin
    FeDisplayStyle:= Value;
    Invalidate();
  end;
end;


procedure TaiddbLkpGeneric.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
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
