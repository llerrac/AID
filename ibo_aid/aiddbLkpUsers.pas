unit aiddbLkpUsers;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpUsers
  Author      : Chris G. Royle (CGR20061216)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide a
    BOMs User Lookup Component.
  See also    : aiddbLkpSite
  Note        :
  Modified    :
    CGR20061229, Added TaiddbLkpUserEmailRecipients component.
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
  TaiddbLkpUserFilterStyle =
    (aluserAll, aluserOnlyActive, aluserActiveOrFieldObsolete, aluserCustom);

type
  TaiddbLkpCustomUser = Class(TaiddbCustomLookupList)
  private
    FeLookupFilter: TaiddbLkpUserFilterStyle;
    procedure SetFilterStyle(const Value: TaiddbLkpUserFilterStyle);
  protected
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property FilterStyle: TaiddbLkpUserFilterStyle read FeLookupFilter write SetFilterStyle;
  published
  end;


type
  TaiddbLkpUser      = class(TaiddbLkpCustomUser)
  private
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
  public
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
    property FilterStyle;
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
  TaiddbLkpPurchaser = class(TaiddbLkpCustomUser)
  private
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
  public
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
    property FilterStyle;
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
  TaiddbLkpUserEmailRecipients = class(TaiddbLkpCustomUser)
  private
  protected
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); override;
  public
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
    property FilterStyle;
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
  TaiddbLkpUserObject = class(TaiddbCustomLookupListItem)
  private
    FsUserNo      : TUserNo;
    FsUserName    : String;
    FsSite        : TSiteNo;
    FbIsPurchaser : Boolean;
    FbIsInactive  : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsUserNo: TUserNo; AsUserName: String; AsSite: TSiteNo; AbIsPurchaser, AbIsInactive: Boolean);
    property UserNo     : TUserNo read FsUserNo;
    property UserName   : String  read FsUserName;
    property Site       : TSiteNo read FsSite;
    property IsPurchaser: Boolean read FbIsPurchaser;
    property IsInactive : Boolean read FbIsInactive;
  end;


var
  GlobalUsersLookupPopulation     : TaiddbLookupListPopulateItems;
  GlobalPurchasersLookupPopulation: TaiddbLookupListPopulateItems;
  GlobalEmailUsersLookupPopulation: TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math
  { 3rd Party Units }

  { Application Units };


{ TaiddbLkpUserObject }
constructor TaiddbLkpUserObject.Create(AsUserNo: TUserNo; AsUserName: String; AsSite: TSiteNo; AbIsPurchaser, AbIsInactive: Boolean);
begin
  FsUserNo      := AsUserNo;
  FsUserName    := AsUserName;
  FsSite        := AsSite;
  FbIsPurchaser := AbIsPurchaser; 
  FbIsInactive  := AbIsInactive;
end;


procedure TaiddbLkpUserObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iSiteWidth: Integer;
  iGapWidth : Integer;
  iMid      : Integer;
  rSiteRect : TRect;
  rDescRect : TRect;
  sSite     : String;
  sDesc     : String;
begin
  inherited;
  { Paint the name & site }

  { Establish the Site Width }
  iSiteWidth:= AoCanvas.TextWidth ('M');
  iGapWidth:= MulDiv(iSiteWidth, 2, 4);
  iMid     := ArRect.Top + ((ArRect.Bottom-ArRect.Top) div 2);
  { Site Location }
  rSiteRect := ArRect;
  rSiteRect .Left:= rSiteRect.Right-(iSiteWidth+iGapWidth);

  { Description Location }
  rDescRect:= ArRect;
  rDescRect.Right:= rDescRect.Right-(iSiteWidth+(iGapWidth*2));

  { Draw the Site Field }
  sSite:= self.Site;
  DrawText(AoCanvas.Handle, PChar(sSite), Length(sSite), rSiteRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_CENTER);

  { Draw the Description field }
  sDesc:= Self.UserName;
  if IsInactive then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sDesc), Length(sDesc), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw a seperator between User Name & Site. }
  AoCanvas.Pen.Color:= clWindowFrame;
  AoCanvas.MoveTo (ArRect.Right-(iSiteWidth+(iGapWidth  )), ArRect.Top);
  AoCanvas.LineTo (ArRect.Right-(iSiteWidth+(iGapWidth  )), ArRect.Bottom);

  { Now, indicate that this is an obsolete User. }
  if IsInactive then
  begin
    AoCanvas.Pen.Color:= clWindowFrame;
    AoCanvas.MoveTo (rDescRect.Left +iGapWidth, iMid);
    AoCanvas.LineTo (rDescRect.Right, iMid);
  end;
end;

{ TaiddbLkpUser }
constructor TaiddbLkpCustomUser.Create(AOwner: TComponent);
begin
  inherited;
  FeLookupFilter:= aluserAll;
end;

function TaiddbLkpCustomUser.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oUserObject : TaiddbLkpUserObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpUserObject) then
  begin
    oUserObject:= TaiddbLkpUserObject(AoLookupItem);
    case FilterStyle of
      aluserOnlyActive           :
        Result:=  not oUserObject.IsInactive;
      aluserActiveOrFieldObsolete:
        Result:= (not oUserObject.IsInactive) or (SameText(AsDataKey, oUserObject.UserNo));
    else
      Result:= True;
    end;
  end;
end;

procedure TaiddbLkpCustomUser.SetFilterStyle(const Value: TaiddbLkpUserFilterStyle);
begin
  if (FeLookupFilter<> Value) then
  begin
    FeLookupFilter:= Value;
    RefreshLookup();
  end;
end;

{ TaiddbLkpUser }
procedure TaiddbLkpUser.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalUsersLookupPopulation) then
      GlobalUsersLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

{ TaiddbLkpPurchaser }
procedure TaiddbLkpPurchaser.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalPurchasersLookupPopulation) then
      GlobalPurchasersLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

{ TaiddbLkpUserEmailRecipients }
procedure TaiddbLkpUserEmailRecipients.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalEmailUsersLookupPopulation) then
      GlobalEmailUsersLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

initialization
  GlobalUsersLookupPopulation     := nil;
  GlobalPurchasersLookupPopulation:= nil;
  GlobalEmailUsersLookupPopulation:= nil;


end.
