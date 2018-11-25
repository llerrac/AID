unit aiddbLkpAnalysisCode;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkpAnalysisCode
  Author      : Chris G. Royle (CGR20070119) (copied from aiddbLkpJob)
  Description : Hi-Level Component which is intended to be used by Atlas Applications to provide
    AnalysisCodeLookupComponents. 
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
  TaiddbLkpSupplyAnalysisFilterStyle  =
    ( alsaAnalysisGroupAll, alsaAnalysisGroupActiveOnly, alsaAnalysisGroupActiveOrCurrentValue);

  TaiddbLkpSupplyAnalysisFilterProperty   = ( alsaIncludeMachineCodes );
  TaiddbLkpSupplyAnalysisFilterProperties = set of TaiddbLkpSupplyAnalysisFilterProperty;

type
  TaiddbLkpAnalysisCodesPopulateItems = procedure(Sender: TObject; const LookupID: TLookupID; AsAnalysisCoding: TAnalysisCoding; Items: TStrings; AbForcedRefresh: Boolean) of object;

type
  TaiddbLkpSupplyAnalysisCode = Class(TaiddbCustomLookupList)
  private
    FsAnalysisCoding  : TAnalysisCoding;
    FeFilterStyle     : TaiddbLkpSupplyAnalysisFilterStyle;
    FeFilterProperties: TaiddbLkpSupplyAnalysisFilterProperties;
    {}
    procedure SetAnalysisCoding(const Value: TAnalysisCoding);
    procedure SetFilterLookupStyle     (const Value: TaiddbLkpSupplyAnalysisFilterStyle);
    procedure SetFilterLookupProperties(const Value: TaiddbLkpSupplyAnalysisFilterProperties);
  protected
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; override;
    procedure DoLoadListItems   (Items: TStrings; AbForcedRefresh: Boolean); override;
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
    procedure ForcedRefresh();
  published
    property AutoComplete;
    property ApplyChangeImmediately;
    property AnalysisCoding   : TAnalysisCoding read FsAnalysisCoding write SetAnalysisCoding;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DropDownCount;
    property Enabled;
    property FilterStyle      : TaiddbLkpSupplyAnalysisFilterStyle      read FeFilterStyle      write SetFilterLookupStyle;
    property FilterProperties : TaiddbLkpSupplyAnalysisFilterProperties read FeFilterProperties write SetFilterLookupProperties;
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
  TaiddbLkpSupplyAnalysisCodeObject = class(TaiddbCustomLookupListItem)
  private
    FsAnalysisCoding  : TAnalysisCoding;
    FsAnalysisCode    : TAnalysisCode;
    FsDescription     : TDesc50;
    FbIsMachineJob    : Boolean;
    FbIsObsolete      : Boolean;
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); override;
  public
    Constructor Create(AsAnalysisCoding: TAnalysisCoding; AsAnalysisCode: TAnalysisCode; AbIsObsolete: Boolean);
    {}
    property AnalysisCoding : TAnalysisCoding   read FsAnalysisCoding;
    property AnalysisCode   : TAnalysisCode     read FsAnalysisCode;
    property Description    : TDesc50           read FsDescription      write FsDescription;
    property IsMachineJob   : Boolean           read FbIsMachineJob     write FbIsMachineJob;
    property IsObsolete     : Boolean           read FbIsObsolete;
  end;

var
  GlobalLookupSupplyCodesPopulation  : TaiddbLkpAnalysisCodesPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math
  { 3rd Party Units }

  { Application Units };

{ TaiddbLkpSupplyAnalysisCode }
constructor TaiddbLkpSupplyAnalysisCode.Create(AOwner: TComponent);
begin
  inherited;
  {}
  FsAnalysisCoding   := '';
  FeFilterStyle      := alsaAnalysisGroupActiveOnly;
  FeFilterProperties := [alsaIncludeMachineCodes];
end;


procedure TaiddbLkpSupplyAnalysisCode.SetFilterLookupStyle(const Value: TaiddbLkpSupplyAnalysisFilterStyle);
begin
  if (FeFilterStyle <> Value) then
  begin
    FeFilterStyle:= Value;
    RefreshLookup();
  end;
end;


procedure TaiddbLkpSupplyAnalysisCode.SetFilterLookupProperties(const Value: TaiddbLkpSupplyAnalysisFilterProperties);
begin
  if (FilterProperties <> Value) then
  begin
    FeFilterProperties:= Value;
    RefreshLookup();
  end;
end;


procedure TaiddbLkpSupplyAnalysisCode.SetAnalysisCoding(const Value: TAnalysisCoding);
begin
  if (FsAnalysisCoding <> Value) then
  begin
    FsAnalysisCoding:= Value;
    RefreshLookup();
  end;
end;


procedure TaiddbLkpSupplyAnalysisCode.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  inherited;
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalLookupSupplyCodesPopulation) then
      GlobalLookupSupplyCodesPopulation(Self, LookupID, self.AnalysisCoding, Items, AbForcedRefresh); 
end;


function TaiddbLkpSupplyAnalysisCode.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
var
  oAnalysisCodeObject : TaiddbLkpSupplyAnalysisCodeObject;
begin
  Result:= True;
  if Assigned(AoLookupItem) and (AoLookupItem is TaiddbLkpSupplyAnalysisCodeObject) then
  begin
    oAnalysisCodeObject:= TaiddbLkpSupplyAnalysisCodeObject(AoLookupItem);
    { Process the filter Style }
    Result:=  SameText(oAnalysisCodeObject.AnalysisCoding, self.AnalysisCoding);
    if Result then
    begin
      case FilterStyle of
        alsaAnalysisGroupAll                  : Result:= True;
        alsaAnalysisGroupActiveOnly           : Result:=  not oAnalysisCodeObject.IsObsolete;
        alsaAnalysisGroupActiveOrCurrentValue : Result:= (not oAnalysisCodeObject.IsObsolete) and SameText(oAnalysisCodeObject.AnalysisCode, AsDataKey);
      end;
      { Process the filter properties. }
      if (alsaIncludeMachineCodes in FilterProperties) then
      begin
        Result:= Result and oAnalysisCodeObject.IsMachineJob;
      end;
    end;
  end;
end;



procedure TaiddbLkpSupplyAnalysisCode.ForcedRefresh;
begin
  UserSelectedRefresh();
end;

{ TaiddbLkpSupplyAnalysisCodeObject }
constructor TaiddbLkpSupplyAnalysisCodeObject.Create(AsAnalysisCoding: TAnalysisCoding; AsAnalysisCode: TAnalysisCode; AbIsObsolete: Boolean);
begin
  self.FsAnalysisCoding:= AsAnalysisCoding;
  self.FsAnalysisCode  := AsAnalysisCode;
  self.FbIsObsolete    := AbIsObsolete;
end;


procedure TaiddbLkpSupplyAnalysisCodeObject.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
var
  iKeyWidth     : Integer;
  iGapWidth     : Integer;
  iMid          : Integer;
  rKeyRect      : TRect;
  rDescRect     : TRect;
  sAnalysis     : String;
  sDescription  : String;
  wDivColor     : TColor;
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
  sAnalysis:= self.AnalysisCode;
  DrawText(AoCanvas.Handle, PChar(sAnalysis), Length(sAnalysis), rKeyRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

  { Draw the Description field }
  sDescription:= Self.Description;
  if IsObsolete then
    AoCanvas.Font.Color:= clGrayText;
  DrawText(AoCanvas.Handle, PChar(sDescription), Length(sDescription), rDescRect, DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX+DT_LEFT);

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
  GlobalLookupSupplyCodesPopulation:= nil;


end.
