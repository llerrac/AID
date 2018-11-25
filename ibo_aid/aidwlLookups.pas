unit aidwlLookups;

{ -------------------------------------------------------------------------------------------------
  Name        : aidwlLookups
  Author      : Chris G. Royle
  Description : Wire-Less lookup components.
  Note        :
  to do       :
    Rationalise this unit - common descendants for item objects, common descendants for objects,
      seperate into individual units.
  Modified    :
    CGR20060721, Tidied
                 Added code to support obsolete cable types.
    CGR20060803, Moved obsolete cable types to the end of the drop-down list.
    CGR20061221, Made a number of changes to improve memory management esp. wrt. the introcduction of
      FastMM4.
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Messages, Classes, Types, Graphics, StdCtrls, Controls,
  DB, DBCtrls,
  { 3rd Party Units }
  { Application Units }
  aidwlTypes;


{ TaidwlWireTypeComboBox
    Wire Type drop down }
type
  TaidwlCustomWireTypeComboBox = class(TCustomComboBox)
  private
    FlNeedToPopulate: Boolean;
    procedure PopulateList();
    function  GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure WMDestroy(var Msg : TWMDestroy); message WM_DESTROY;
    procedure WMDeleteItem(var Msg : TWMDeleteItem); message WM_DELETEITEM;
    procedure FreeObjects();
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
  published
    property Anchors;
    property ItemHeight;
    property TabOrder;
    property TabStop;
    property Visible;
  end;
type
  TaidwlWireTypeComboBox = class(TaidwlCustomWireTypeComboBox)
  private
  protected
  public
  published
    property ItemIndex;
  end;
type
  TaidwldbWireTypeComboBox = class(TaidwlCustomWireTypeComboBox)
  private
    FDataLink: TFieldDataLink;
    FlUpdPending: Boolean;
    function  GetDataField: string;
    function  GetDataSource: TDataSource;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value: TDatasource);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure Change; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property ReadOnly  : Boolean read GetReadOnly write SetReadOnly default false;
    property DataField : string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;
  
{ TaidwlWireFuncComboBox
    Functions lookup for wires & terminals. eg GREY is signal}
type
  TaidwlCustomWireFuncComboBox = class(TCustomComboBox)
  private
    FlNeedToPopulate: Boolean;
    procedure PopulateList;
    procedure SetDropDownWidth(const AValue: Integer);
    function  GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
  protected
    procedure CreateWnd; override;
    procedure AdjustDropDown; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure WMDestroy(var Msg : TWMDestroy); message WM_DESTROY;
    procedure WMDeleteItem(var Msg : TWMDeleteItem); message WM_DELETEITEM;
    procedure FreeObjects();
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
  published
    property Anchors;
    property ItemHeight;
    property TabOrder;
    property TabStop;
    property Visible;
  end;
{ TaidwlWireFuncComboBox }
type
  TWireFuncKey = String[10];
  TWireFuncDesc= String[50];
type
  TaidwlWireFuncComboBox = class(TaidwlCustomWireFuncComboBox)
  private
  protected
  public
  published
    property ItemIndex;
  end;
{ TaidwldbWireFuncComboBox }
type
  TaidwldbWireFuncComboBox = class(TaidwlCustomWireFuncComboBox)
  private
    FDataLink: TFieldDataLink;
    FlUpdPending: Boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value: TDatasource);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure Change; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property ReadOnly : Boolean read GetReadOnly write SetReadOnly default false;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

{ TaidwlCableTypeComboBox
    Painted drop-down combo box for Cable types }
type
  TaidwlCustomCableTypeComboBox = class(TCustomComboBox)
  private
    FlNeedToPopulate: Boolean;
    procedure PopulateList();
    procedure SetDropDownWidth(const AValue: Integer);
    function  GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
  protected
    procedure CreateWnd; override;
    procedure AdjustDropDown; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure WMDestroy(var Msg : TWMDestroy); message WM_DESTROY;
    procedure WMDeleteItem(var Msg : TWMDeleteItem); message WM_DELETEITEM;
    procedure FreeObjects();
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property    SelectedItem: string read GetSelectedItem write SetSelectedItem;
  published
    property Anchors;
    property ItemIndex;
    property TabOrder;
    property TabStop;
    property Visible;
  end;
type
  TaidwlCableTypeComboBox = class(TaidwlCustomCableTypeComboBox)
  private
  protected
  public
  published
    property ItemHeight;
  end;
type
  TaidwldbCableTypeComboBox = class(TaidwlCustomCableTypeComboBox)
  private
    FDataLink: TFieldDataLink;
    FlUpdPending: Boolean;
    function  GetDataField: string;
    function  GetDataSource: TDataSource;
    function  GetReadOnly: Boolean;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value: TDatasource);
    procedure SetReadOnly(const Value: Boolean);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
  protected
    procedure Change; override;
    procedure CloseUp; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property ReadOnly : Boolean read GetReadOnly write SetReadOnly default false;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

{ TaidwlWireColorComboBox
    Functions lookup for colors (use in conjunction with values from Lookups.WLCOLR)}
type
  TaidwlWireColorItem = packed record
    Value       : string;
    Caption     : string;
    BGColor     : TColor;   // Background color
    StripeColor1: TColor;   // Stripe 01 color;
    FGColor     : TColor;   // Text Color
    IsScreen    : Boolean;  // Is this core a screen ?
  end;
type
  TaidwlCustomWireColorComboBox = class(TCustomComboBox)
  private
    FlNeedToPopulate: Boolean;
    procedure PopulateList;
    procedure SetDropDownWidth(const AValue: Integer);
    function  GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
    procedure WMDestroy(var Msg : TWMDestroy); message WM_DESTROY;
    procedure WMDeleteItem(var Msg : TWMDeleteItem); message WM_DELETEITEM;
    procedure FreeObjects();
  protected
    procedure CreateWnd; override;
    procedure AdjustDropDown; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
    procedure ClearItems;
    procedure AddColorItem(ArItem: TaidwlWireColorItem);
  published
    property Anchors;
    property ItemHeight;
    property TabOrder;
    property TabStop;
    property Visible;
  end;
{ TaidwlWireColorComboBox }
type
  TaidwlWireColorComboBox = class(TaidwlCustomWireColorComboBox)
  private
  protected
  public
  published
    property ItemIndex;
  end;
{ TaidwldbWireColorComboBox }
type
  TaidwldbWireColorComboBox = class(TaidwlCustomWireColorComboBox)
  private
    FDataLink: TFieldDataLink;
    FlUpdPending: Boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value: TDatasource);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure Change; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property ReadOnly : Boolean read GetReadOnly write SetReadOnly default false;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

{ Wire Functions }
type
  TaidwlWireFunction = packed record
    sWireFunc   : TWireFuncKey; // Function eg RED
    sWireDesc   : TWireFuncDesc; // Caption eg Red - a/c Control
    sPrintDesc  : TWireFuncDesc; // Printing caption when printing interconnects
    wBGColor    : TColor; // Background color eg clRed
    wStripeColor: TColor; // Stripe Color
    wFGColor    : TColor; // Text color eg clWhite
    sGroupFunc  : TLookupKey; // Group with another function ie cable these together eg WHITE
  end;
{ Cable Types }
type
  TaidwlCableDrawAs = (vawlctYY, vawlctYYpwr, vawlctSY, vawlctSYpwr, vawlctCY, vawlctCYpwr, vawlctDATA, vawlctSINGLE, vawlctCLIQ);
  
type
  TaidwlCableType = packed record
    iCableType      : TaidwlCableDrawAs;
    sCableType      : TCableTypeKey;
    sCableDesc      : TCableTypeDesc;
    bIsObsolete     : Boolean;
    //
    sForceWireDia   : TLookupKey;
    sForceWireFunc  : TLookupKey;
    sForceWireType  : TLookupKey;
  end;

type
  TwlLookupList = Class(TStringList)
  private
    procedure FreeObjects();
  public
    destructor Destroy; override;
  end;

function  WireType(AlShielded, AlEarth: Boolean): string;
procedure RenderWireFuncToCanvas(ACanvas: TCanvas; ARect: TRect; AValue: string; AlVerbose: Boolean);
procedure RenderCableTypeToCanvas(ACanvas: TCanvas; ARect: TRect; AValue: string; AlVerbose: Boolean);
function  FindWireFunc(AsWireFunc: string; var ArWireFunc: TaidwlWireFunction): Boolean;
function  FindCableType(AsCableType: string; var ArCableType: TaidwlCableType): Boolean;

implementation

{ TaidwlWireType }

uses
  { Delphi Units }
  SysUtils, Math, Contnrs,
  { 3rd Party Units }
  { Application Units }
  crUtil;

var
  FoWireFuncs : TwlLookupList;
  FoCableTypes: TwlLookupList;

type  // Individual function
  TaidwlWireFunctionObj  = class(TObject)
  private
    FWireFuncInfo : TaidwlWireFunction;
    function GetGroupFunc: TLookupKey;
  protected
  public
    constructor Create(AFunc: TaidwlWireFunction);
    procedure RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
    //
    property  Data       : TaidwlWireFunction read FWireFuncInfo;
    property  WireFunc   : TWireFuncKey       read FWireFuncInfo.sWireFunc;
    property  WireDesc   : TWireFuncDesc      read FWireFuncInfo.sWireDesc;
    property  PrintDesc  : TWireFuncDesc      read FWireFuncInfo.sPrintDesc;
    property  BGColor    : TColor             read FWireFuncInfo.wBGColor;
    property  StripeColor: TColor             read FWireFuncInfo.wStripeColor;
    property  FGColor    : TColor             read FWireFuncInfo.wFGColor;
    property  GroupFunc  : TLookupKey         read GetGroupFunc;
  end;
{ Wire Colors }
type
  TaidwlCustomWireColorObj = class(TObject)
  private
    FrWireColorInfo: TaidwlWireColorItem;
  protected
  public
    constructor Create(ArItem: TaidwlWireColorItem);
    procedure RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
    //
    property  Data    : TaidwlWireColorItem read FrWireColorInfo;
    property  Value   : string read FrWireColorInfo.Value;
    property  Caption : string read FrWireColorInfo.Caption;
    property  BGColor : TColor read FrWireColorInfo.BGColor;
    property  FGColor : TColor read FrWireColorInfo.FGColor;
  end;

type
  TaidwlCableTypeObj  = class(TObject)
  private
    FCableTypeInfo  : TaidwlCableType;
  protected
  public
    constructor Create(AFunc: TaidwlCableType);
    //
    procedure RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
    //
    property  Data         : TaidwlCableType   read FCableTypeInfo;
    property  CableOrd     : TaidwlCableDrawAs read FCableTypeInfo.iCableType;
    property  CableType    : TCableTypeKey     read FCableTypeInfo.sCableType;
    property  CableDesc    : TCableTypeDesc    read FCableTypeInfo.sCableDesc;
    property  ForceWireDia : TLookupKey        read FCableTypeInfo.sForceWireDia;
    property  ForceWireFunc: TLookupKey        read FCableTypeInfo.sForceWireFunc;
    property  ForceWireType: TLookupKey        read FCableTypeInfo.sForceWireType;
    property  IsObsolete   : Boolean           read FCableTypeInfo.bIsObsolete;
  end;
  
{  TaidwlWireFunction = packed record
    sWireFunc   : TWireFuncKey; // Function eg RED
    sWireDesc   : TWireFuncDesc; // Caption eg Red - a/c Control
    sPrintDesc  : TWireFuncDesc; // Printing caption when printing interconnects
    wBGColor    : TColor; // Background color eg clRed
    wStripeColor: TColor; // Stripe Color
    wFGColor    : TColor; // Text color eg clWhite
    sGroupFunc  : TLookupKey; // Group with another function ie cable these together eg WHITE
  end;
}
  function WireFunction(AsWireFunc: TWireFuncKey; AsWireDesc: TWireFuncDesc;
    AwBGColor, AwStripeColor, AwFGColor: TColor;
    AsGroupFunc: TLookupKey = ''; AsPrintDesc: TWireFuncDesc = ''): TaidwlWireFunction;
  begin
    FillChar(Result, SizeOf(Result), #0);
    Result.sWireFunc   := AsWireFunc;
    Result.sWireDesc   := AsWireDesc;
    Result.wBGColor    := AwBGColor;
    Result.wStripeColor:= AwStripeColor;
    Result.wFGColor    := AwFGColor;
    Result.sPrintDesc  := AsPrintDesc;
    if IsEmptyStr(AsGroupFunc) then
      Result.sGroupFunc:= AsWireFunc
    else
      Result.sGroupFunc:= AsGroupFunc;
  end;

  function CableType(AiCableOrd: TaidwlCableDrawAs; AsCableType: TCableTypeKey; AsCableDesc: TCableTypeDesc; AsForceWireDia: TLookupKey = '';
    AsForceWireFunc: TLookupKey = ''; AsForceWireType: TLookupKey = ''; AbIsObsolete: Boolean = False): TaidwlCableType;
  begin
    FillChar(Result, SizeOf(Result), #0);
    Result.iCableType    := AiCableOrd;
    Result.sCableType    := AsCableType;
    Result.sCableDesc    := AsCableDesc;
    Result.sForceWireDia := AsForceWireDia;
    Result.sForceWireFunc:= AsForceWireFunc;
    Result.sForceWireType:= AsForceWireType;
    Result.bIsObsolete   := AbIsObsolete;
  end;

constructor TaidwlCustomWireTypeComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csOwnerDrawFixed;
  PopulateList;
end;

destructor TaidwlCustomWireTypeComboBox.Destroy;
begin

  inherited;
end;

procedure TaidwlCustomWireTypeComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if FlNeedToPopulate then
    PopulateList;
end;

function  WireType(AlShielded, AlEarth: Boolean): string;
begin
  Result:= 'Normal';
  if AlShielded then
    Result:= 'Shielded'
  else
    if AlEarth then
      Result:= 'Earth';
end;

procedure TaidwlCustomWireTypeComboBox.PopulateList;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
      self.Items.Clear;
      self.Items.Add('Normal');
      self.Items.Add('Shielded');
      self.Items.Add('Earth');
    finally
      Items.EndUpdate;
      FlNeedToPopulate := False;
    end;
  end
  else
    FlNeedToPopulate := True;
end;

procedure TaidwlCustomWireTypeComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  rRct  : TRect;
  rMid  : TRect;
  wBG   : TColor;
  iMid  : Integer;
begin
  with Canvas do
  begin
    FillRect(Rect);
    wBG := Brush.Color;

    rRct      := Rect;
    rRct.Right:= (rRct.Bottom - rRct.Top) + rRct.Left; // Height Square
    InflateRect(rRct, -1, -1);
    //
    case Index of
      0:
      begin
        // Core
        Brush.Color:= clBlack;
        rMid:= rRct;
        InflateRect(rMid, -4, -4);
        Ellipse(rMid);
      end;
      1:  // Shielded / Screened
      begin
        // Core
        Brush.Color:= clBlack;
        rMid:= rRct;
        InflateRect(rMid, -4, -4);
        Ellipse(rMid);
        // Screen
        Brush.Style:= bsClear;
        rMid:= rRct;
        Ellipse(rMid);
      end;
      2:  // Earthed
      begin
        iMid:= rRct.Left+Ceil((rRct.Right-rRct.Left) div 2);
        MoveTo(iMid   , rRct.Top   +1);
        LineTo(iMid   , rRct.Bottom-6);
        MoveTo(iMid -1, rRct.Bottom-2);
        LineTo(iMid +2, rRct.Bottom-2);
        MoveTo(iMid -3, rRct.Bottom-4);
        LineTo(iMid +4, rRct.Bottom-4);
        MoveTo(iMid -5, rRct.Bottom-6);
        LineTo(iMid +6, rRct.Bottom-6);
      end;
    end;
    // Restore Brush & Canvas
    Brush.Color:= wBG;
    Rect.Left  := rRct.Right + 5; // Indent from draw position
    // Draw the text
    TextRect(Rect, Rect.Left,  Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(Items[Index])) div 2, Items[Index]);
  end;
end;


function TaidwlCustomWireTypeComboBox.GetSelectedItem: string;
begin
  Result:= '';
  if (ItemIndex>=0) and (ItemIndex<ItemCount) then
    Result:= Items[ItemIndex];
end;

{ TaidwlWireFunctionObj }
constructor TaidwlWireFunctionObj.Create(AFunc: TaidwlWireFunction);
begin
  FWireFuncInfo:= AFunc;
end;

{ TaidwlWireFunc }
constructor TaidwlCustomWireFuncComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csOwnerDrawFixed;
  PopulateList;
end;

destructor TaidwlCustomWireFuncComboBox.Destroy;
begin
  inherited;
end;

procedure TaidwlCustomWireFuncComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if FlNeedToPopulate then
    PopulateList;
end;


procedure TaidwlCustomWireFuncComboBox.PopulateList;
var
  iK  : Integer;
  oObj: TaidwlWireFunctionObj;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
      with Self.Items do
      begin
        Clear;
        // Populate from the master list
        for iK:= 0 to FoWireFuncs.Count-1 do
        begin
          if Assigned(FoWireFuncs.Objects[iK]) then
            if FoWireFuncs.Objects[iK] is TaidwlWireFunctionObj then
            begin
              oObj:= TaidwlWireFunctionObj(FoWireFuncs.Objects[iK]);
              self.items.AddObject(oObj.WireFunc, TaidwlWireFunctionObj.Create(
                WireFunction(oObj.WireFunc, oObj.WireDesc, oObj.BGColor, oObj.StripeColor, oObj.FGColor)));
            end;
        end;
      end;
    finally
      Items.EndUpdate;
      FlNeedToPopulate := False;
    end;
  end
  else
    FlNeedToPopulate := True;
end;


procedure TaidwlCustomWireFuncComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // Ensure that focus is rendered.
  Canvas.FillRect(Rect);
  //
  if Assigned(Items.Objects[Index]) then
    with TaidwlWireFunctionObj(Items.Objects[Index]) do
      RenderToCanvas(Canvas, Rect, DroppedDown and (not (odComboBoxEdit in State)));
end;

procedure TaidwlCustomWireFuncComboBox.SetDropDownWidth(const AValue: Integer);
var
  iWide : Integer;
begin
  if (AValue = 0) then iWide:= Self.Width else iWide:= AValue;
  SendMessage(Handle, CB_SETDROPPEDWIDTH, Longint(iWide), 0);
end;


procedure TaidwlCustomWireFuncComboBox.AdjustDropDown;
begin
  inherited;
  SetDropDownWidth(171);
end;

function TaidwlCustomWireFuncComboBox.GetSelectedItem: string;
begin
  Result:= '';
  if (ItemIndex>=0) and (ItemIndex<ItemCount) then
    Result:= Items[ItemIndex];
end;

{ TaidwlCableType }

procedure TaidwlCustomCableTypeComboBox.AdjustDropDown;
begin
  inherited;
  SetDropDownWidth(171);
end;

constructor TaidwlCustomCableTypeComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csOwnerDrawFixed;
  PopulateList;
end;

destructor TaidwlCustomCableTypeComboBox.Destroy;
begin

  inherited;
end;

procedure TaidwlCustomCableTypeComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if FlNeedToPopulate then
    PopulateList;
end;

function TaidwlCustomCableTypeComboBox.GetSelectedItem: string;
begin
  Result:= '';
  if (ItemIndex>=0) and (ItemIndex<ItemCount) then
    Result:= Items[ItemIndex];
end;

procedure TaidwlCustomCableTypeComboBox.PopulateList();
var
  iK     : Integer;
  oSource: TaidwlCableTypeObj;
  oDest  : TaidwlCableTypeObj;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
      with Self.Items do
      begin
        Clear;
        // Populate from the master list
        for iK:= 0 to FoCableTypes.Count-1 do
        begin
          if Assigned(FoCableTypes.Objects[iK]) then
            if FoCableTypes.Objects[iK] is TaidwlCableTypeObj then
            begin
              oSource:= TaidwlCableTypeObj(FoCableTypes.Objects[iK]);
              oDest  := TaidwlCableTypeObj.Create(
                CableType(oSource.CableOrd, oSource.CableType, oSource.CableDesc,
                  oSource.ForceWireDia, oSource.ForceWireFunc, oSource.ForceWireType, oSource.IsObsolete));
              Items.AddObject(oSource.CableType, oDest);
            end;
        end;
      end;
    finally
      Items.EndUpdate;
      FlNeedToPopulate := False;
    end;
  end
  else
    FlNeedToPopulate := True;
end;


procedure TaidwlCustomCableTypeComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  oObj  : TaidwlCableTypeObj;
begin
  with Canvas do
  begin
    if Assigned(Items.Objects[Index]) and (Items.Objects[Index] is TaidwlCableTypeObj) then
    begin
      oObj:= TaidwlCableTypeObj(Items.Objects[Index]);
      oObj.RenderToCanvas(Canvas, Rect, DroppedDown);
    end;
  end;
end;

function TaidwlWireFunctionObj.GetGroupFunc: TLookupKey;
begin
  Result:= FWireFuncInfo.sGroupFunc;
  if IsEmptyStr(Result) then
    Result:= FWireFuncInfo.sWireFunc;
end;

procedure TaidwlWireFunctionObj.RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
var
  rRct  : TRect;
  iMid  : Integer;
  iMidS : Integer;
  sCap  : string;
  aPts  : Array[0..3] of TPoint;
begin
  if Assigned(ACanvas) then
  begin
    ACanvas.FillRect(ARect);
    rRct:= ARect;
    InflateRect(rRct, -1, -1);
    if not Odd(rRct.Bottom-rRct.Top) then
      dec(rRct.Bottom);
    //
    with ACanvas do
    begin
      Pen  .Color:= clDkGray;
      Brush.Color:= self.BGColor;
      //
      iMid:= ((rRct.Bottom-rRct.Top) div 2);
      Ellipse (rRct.Left, rRct.Top, rRct.Left+(rRct.Bottom-rRct.Top)  , rRct.Bottom); // rounded left-hand side
      Ellipse (rRct.Right-(rRct.Bottom-rRct.Top), rRct.Top, rRct.Right, rRct.Bottom); // rounded right-hand side
      FillRect(Types.Rect(rRct.Left +iMid, rRct.Top, rRct.Right-iMid, rRct.Bottom )); // Center
      // Stripe
      if (FWireFuncInfo.wStripeColor<>clNone) then
      begin
        Brush.Color:= FWireFuncInfo.wStripeColor;
        iMidS:= (rRct.Right-rRct.Left) div 2;
        aPts[0]:= Point(rRct.Left+iMidS+8, rRct.Top     );
        aPts[1]:= Point(rRct.Left+iMidS+0, rRct.Bottom-1);
        aPts[2]:= Point(rRct.Left+iMidS-8, rRct.Bottom-1);
        aPts[3]:= Point(rRct.Left+iMidS+0, rRct.Top     );
        Polygon(aPts);
      end;
      //
      Pen  .Color:= clDkGray;
      Brush.Color:= self.BGColor;
      MoveTo(rRct.Left +iMid, rRct.Top);    // Top Border
      LineTo(rRct.Right-iMid, rRct.Top);    //   "    "
      MoveTo(rRct.Left +iMid, rRct.Bottom); // Bottom Border
      LineTo(rRct.Right-iMid, rRct.Bottom); //    "     "
      //
      Brush.Style:= bsClear;
      Font .Color:= self.FGColor;
      if AlVerbose then
        sCap:= FWireFuncInfo.sWireDesc
      else
        sCap:= FWireFuncInfo.sWireFunc;

      TextRect(ARect, ARect.Left+iMid+2,  ARect.Top + (ARect.Bottom - ARect.Top - TextHeight(sCap)) div 2, sCap);
    end;
  end;
end;

{ TaidwlCableTypeObj
procedure TaidwlCableTypeObj.AssignTo(Dest: TPersistent);
var
  oDest : TaidwlCableTypeObj;
begin
  inherited;
  if Assigned(Dest) and (Dest is TaidwlCableTypeObj) then
  begin
    oDest:= TaidwlCableTypeObj(Dest);
    oDest.CableOrd     := CableOrd;
    oDest.CableType    := CableType;
    oDest.CableDesc    := CableDesc;
    oDest.ForceWireDia := ForceWireDia;
    oDest.ForceWireFunc:= ForceWireFunc;
    oDest.ForceWireType:= ForceWireType;
    oDest.IsObsolete   := IsObsolete;
  end;
end;  }

constructor TaidwlCableTypeObj.Create(AFunc: TaidwlCableType);
begin
  FCableTypeInfo:= AFunc;
end;


procedure TaidwlCableTypeObj.RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
var
  rCable: TRect;
  iFont : TColor;
  rRct  : TRect;
  iT,
  iL    : Integer;
  iMX,
  iMY   : Integer;
  iY    : Integer;
  sCap  : String;
const
  CMultiColor : Array[0..3] of TColor
    = (clRed, clGreen, clYellow, clAqua);
begin
  if Assigned(ACanvas) then
  begin
    ACanvas.FillRect(ARect);
    rRct  := ARect;
    iFont := ACanvas.Font.Color;
    rCable:= ARect; rCable.Right:= rCable.Left+25;
    case CableOrd of
      vawlctYY,
      vawlctYYPwr :
      begin
        // Inner
        rRct:= rCable;
        InflateRect(rRct, -1 , -5);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.Pen  .Color:= clDkGray;
        ACanvas.Rectangle(rRct);
        // Outer
        rRct:= rCable;
        InflateRect(rRct, -5, -2);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clDkGray{Silver};
        ACanvas.FillRect(rRct);
        // Frame
        ACanvas.Brush.Style:= bsClear;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.FrameRect(rRct);
        // Power
        if (CableOrd=vawlctYYPwr) then
        begin
          iMX := rCable.Left+((rCable.Right -rCable.Left) div 2);
          iMY := rCable.Top +((rCable.Bottom-rCable.Top ) div 2);
          ACanvas.Brush.Color:= clYellow;
          ACanvas.Pen  .Color:= clBlack;
          ACanvas.Polygon([Point(iMX, iMY-5), Point(iMX+4, iMY+3), Point(iMX-4, iMY+3)]);
        end;
      end;
      vawlctSY,
      vawlctSYpwr :
      begin
        // Inner
        rRct:= rCable;
        InflateRect(rRct, -1 , -5);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.Pen  .Color:= clDkGray;
        ACanvas.Rectangle(rRct);
        // Outer
        rRct:= rCable;
        InflateRect(rRct, -5, -2);
        ACanvas.Brush.Style:= bsDiagCross;
        ACanvas.Brush.Color:= clDkGray;
        SetBKColor(ACanvas.Handle, clSilver);
        ACanvas.FillRect(rRct);
        // Frame
        ACanvas.Brush.Style:= bsClear;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.FrameRect(rRct);
        // Power
        if (CableOrd=vawlctSYPwr) then
        begin
          iMX := rCable.Left+((rCable.Right -rCable.Left) div 2);
          iMY := rCable.Top +((rCable.Bottom-rCable.Top ) div 2);
          ACanvas.Brush.Color:= clYellow;
          ACanvas.Pen  .Color:= clBlack;
          ACanvas.Polygon([Point(iMX, iMY-5), Point(iMX+4, iMY+3), Point(iMX-4, iMY+3)]);
        end;
      end;
      vawlctCY,
      vawlctCYpwr  :
      begin
        // Inner
        rRct:= rCable;
        InflateRect(rRct, -1 , -5);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.Pen  .Color:= clDkGray;
        ACanvas.Rectangle(rRct);
        // Outer
        rRct:= rCable;
        InflateRect(rRct, -5, -2);
        ACanvas.Brush.Style:= bsDiagCross;
        ACanvas.Brush.Color:= clDkGray;
        SetBKColor(ACanvas.Handle,  $004080);
        ACanvas.FillRect(rRct);
        // Frame
        ACanvas.Brush.Style:= bsClear;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.FrameRect(rRct);
        // Power
        if (CableOrd=vawlctCYPwr) then
        begin
          iMX := rCable.Left+((rCable.Right -rCable.Left) div 2);
          iMY := rCable.Top +((rCable.Bottom-rCable.Top ) div 2);
          ACanvas.Brush.Color:= clYellow;
          ACanvas.Pen  .Color:= clBlack;
          ACanvas.Polygon([Point(iMX, iMY-5), Point(iMX+4, iMY+3), Point(iMX-4, iMY+3)]);
        end;
      end;
      vawlctDATA  :
      begin
        // Inner
        rRct:= rCable;
        InflateRect(rRct, -1 , -3);
        iT:= rRct.Top+1;
        iL:= Low(CMultiColor);
        while iT<(rRct.Bottom-1) do
        begin
          ACanvas.Pen.Color:= CMultiColor[iL];
          ACanvas.MoveTo(rRct.Left, iT);
          ACanvas.LineTo(rRct.Right, iT);
          inc(iT);
          ACanvas.Pen.Color:= clBlack;
          ACanvas.MoveTo(rRct.Left, iT);
          ACanvas.LineTo(rRct.Right, iT);
          inc(iT);
          if iL=High(CMultiColor) then iL:= Low(CMultiColor) else inc(iL);
        end;
        // Inner
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.FrameRect(rRct);
        // Outer
        rRct:= rCable;
        InflateRect(rRct, -5, -2);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clDkGray;
        ACanvas.FillRect(rRct);
        // Frame
        ACanvas.Brush.Style:= bsClear;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.FrameRect(rRct);
      end;
      vawlctSINGLE:
      begin
        // Inner
        rRct:= rCable;
        InflateRect(rRct, -1 , -5);
        ACanvas.Brush.Style:= bsSolid;
        ACanvas.Brush.Color:= clBlack;
        ACanvas.Pen  .Color:= clDkGray;
        ACanvas.Rectangle(rRct);
      end;
    end;
    // Draw the text
    ACanvas.Brush.Style:= bsClear;
    ACanvas.Font .Color:= iFont;
    if Data.bIsObsolete then
      ACanvas.Font .Color:= clGrayText;
    if AlVerbose then sCap:= CableDesc else sCap:= CableType;
    ACanvas.TextRect(ARect, rCable.Right+2,  ARect.Top + (ARect.Bottom - ARect.Top - ACanvas.TextHeight(sCap)) div 2, sCap);
    if Data.bIsObsolete then
    begin
      iY:= ARect.Top + ((ARect.Bottom-ARect.Top) div 2);
      ACanvas.Pen.Color:= clDkGray;
      ACanvas.MoveTo(rCable.Right+2, iY);
      ACanvas.LineTo(ARect .Right-1, iY);
    end;
  end;
end;

procedure TaidwlCustomCableTypeComboBox.SetDropDownWidth(const AValue: Integer);
var
  iWide : Integer;
begin
  if (AValue = 0) then iWide:= Self.Width else iWide:= AValue;
  SendMessage(Handle, CB_SETDROPPEDWIDTH, Longint(iWide), 0);
end;

procedure TaidwlCustomWireTypeComboBox.SetSelectedItem(const Value: string);
var
  iK  : Integer;
begin
  for iK:= 0 to ItemCount-1 do
    if SameText(Items[iK], Value) then
    begin
      ItemIndex:= iK;
      break;
    end;
end;


procedure TaidwlCustomWireFuncComboBox.SetSelectedItem(const Value: string);
var
  iK  : Integer;
  lFnd: Boolean;
begin
  lFnd:= False;
  for iK:= 0 to ItemCount-1 do
    if SameText(Items[iK], Value) then
    begin
      ItemIndex:= iK;
      lFnd:= True;
      Break;
    end;
  //
  if not lFnd then
    ItemIndex:= -1;
end;

procedure TaidwlCustomCableTypeComboBox.SetSelectedItem(const Value: string);
var
  iK  : Integer;
begin
  for iK:= 0 to ItemCount-1 do
    if SameText(Items[iK], Value) then
    begin
      ItemIndex:= iK;
      break;
    end;
end;



{ TaidwldbWireFuncComboBox }
constructor TaidwldbWireFuncComboBox.Create(AOwner: TComponent);
begin
  inherited;
  //
  FlUpdPending:= False;
  FDataLink:= TFieldDataLink.Create;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnUpdateData:= UpdateData;
end;


destructor TaidwldbWireFuncComboBox.Destroy;
begin
  if Assigned(FDataLink) then
  begin
    FDataLink.OnDataChange:= nil;
    FDataLink.OnUpdateData:= nil;
    //
    FDataLink.Free;
  end;
  inherited;
end;

procedure TaidwldbWireFuncComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TaidwldbWireFuncComboBox.Change;
begin
  inherited;
  //
  if FDataLink.CanModify then
  begin
    FlUpdPending:= True;
    try
      FDataLink.Edit;
      inherited;
      FDataLink.Modified;
    finally
      FlUpdPending:= False;
    end;
  end;
{~  else
    Selected:= Self.NoneColorColor;}
end;

procedure TaidwldbWireFuncComboBox.CMExit(var Message: TWMNoParams);
begin
  try
    FdataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;

procedure TaidwldbWireFuncComboBox.DataChange(Sender: TObject);
begin
  if not FlUpdPending then
  begin
    if (FDataLink.field = nil) then
      SelectedItem:= ''
    else
      SelectedItem:= FDataLink.Field.AsString;
  end;
end;

function TaidwldbWireFuncComboBox.GetDataField: string;
begin
  Result:= FDataLink.FieldName;
end;

function TaidwldbWireFuncComboBox.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TaidwldbWireFuncComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TaidwldbWireFuncComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName:= Value;
end;

procedure TaidwldbWireFuncComboBox.SetDataSource(Value: TDatasource);
begin
  FDataLink.DataSource:= Value;
end;

procedure TaidwldbWireFuncComboBox.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TaidwldbWireFuncComboBox.UpdateData(Sender: TObject);
begin
  if FDataLink.CanModify then
    FDataLink.Field.AsString:= Self.SelectedItem;
end;

procedure RenderWireFuncToCanvas(ACanvas: TCanvas; ARect: TRect; AValue: string; AlVerbose: Boolean);
var
  iK    : Integer;
  oFunc : TaidwlWireFunctionObj;
begin
  if Assigned(FoWireFuncs) then
  begin
    iK:= FoWireFuncs.IndexOf(AValue);
    if (iK>=0) then
      if (Assigned(FoWireFuncs.Objects[iK])) and (FoWireFuncs.Objects[iK] is TaidwlWireFunctionObj) then
      begin
        oFunc:= TaidwlWireFunctionObj(FoWireFuncs.Objects[iK]);
        oFunc.RenderToCanvas(ACanvas, ARect, AlVerbose);
      end;
  end;
end;


procedure RenderCableTypeToCanvas(ACanvas: TCanvas; ARect: TRect; AValue: string; AlVerbose: Boolean);
var
  iK    : Integer;
  oFunc : TaidwlCableTypeObj;
begin
  if Assigned(FoCableTypes) then
  begin
    iK:= FoCableTypes.IndexOf(AValue);
    if (iK>=0) then
      if (Assigned(FoCableTypes.Objects[iK])) and (FoCableTypes.Objects[iK] is TaidwlCableTypeObj) then
      begin
        oFunc:= TaidwlCableTypeObj(FoCableTypes.Objects[iK]);
        oFunc.RenderToCanvas(ACanvas, ARect, AlVerbose);
      end;
  end;
end;


{ TaidwldbCableTypeComboBox }
constructor TaidwldbCableTypeComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FlUpdPending:= False;
  FDataLink:= TFieldDataLink.Create;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnUpdateData:= UpdateData;
end;


destructor TaidwldbCableTypeComboBox.Destroy;
begin
  if Assigned(FDataLink) then
  begin
    FDataLink.OnDataChange:= nil;
    FDataLink.OnUpdateData:= nil;
    //
    FDataLink.Free;
  end;
  inherited;
end;


procedure TaidwldbCableTypeComboBox.Change;
begin
  inherited;
  //
  if FDataLink.CanModify then
  begin
    FlUpdPending:= True;
    try
      FDataLink.Edit;
      inherited;
      FDataLink.Modified;
      FdataLink.UpdateRecord;
    finally
      FlUpdPending:= False;
    end;
  end;
end;


procedure TaidwldbCableTypeComboBox.CMExit(var Message: TWMNoParams);
begin
  try
    FdataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;


procedure TaidwldbCableTypeComboBox.DataChange(Sender: TObject);
begin
  if not FlUpdPending then
  begin
    if (FDataLink.field = nil) then
      SelectedItem:= ''
    else
      SelectedItem:= FDataLink.Field.AsString;
  end;
end;


function TaidwldbCableTypeComboBox.GetDataField: string;
begin
  Result:= FDataLink.FieldName;
end;

function TaidwldbCableTypeComboBox.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TaidwldbCableTypeComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TaidwldbCableTypeComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TaidwldbCableTypeComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName:= Value;
end;

procedure TaidwldbCableTypeComboBox.SetDataSource(Value: TDatasource);
begin
  FDataLink.DataSource:= Value;
end;

procedure TaidwldbCableTypeComboBox.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TaidwldbCableTypeComboBox.UpdateData(Sender: TObject);
begin
  if FDataLink.CanModify then
    FDataLink.Field.AsString:= Self.SelectedItem;
end;

procedure TaidwldbCableTypeComboBox.CloseUp;
begin
  inherited;
{  UpdateData(Self);
  FDataLink.UpdateRecord;}
{  Perform(CM_Exit,0,0);}
end;

{ TaidwldbWireTypeComboBox }
constructor TaidwldbWireTypeComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FlUpdPending:= False;
  FDataLink:= TFieldDataLink.Create;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnUpdateData:= UpdateData;
end;

destructor TaidwldbWireTypeComboBox.Destroy;
begin
  if Assigned(FDataLink) then
  begin
    FDataLink.OnDataChange:= nil;
    FDataLink.OnUpdateData:= nil;
    //
    FDataLink.Free;
  end;
  inherited;
end;

procedure TaidwldbWireTypeComboBox.Change;
begin
  inherited;
  //
  if FDataLink.CanModify then
  begin
    FlUpdPending:= True;
    try
      FDataLink.Edit;
      inherited;
      FDataLink.Modified;
    finally
      FlUpdPending:= False;
    end;
  end;
end;

procedure TaidwldbWireTypeComboBox.CMExit(var Message: TWMNoParams);
begin
  try
    FdataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;

procedure TaidwldbWireTypeComboBox.DataChange(Sender: TObject);
begin
  if not FlUpdPending then
  begin
    if (FDataLink.field = nil) then
      SelectedItem:= ''
    else
      SelectedItem:= FDataLink.Field.AsString;
  end;
end;


function TaidwldbWireTypeComboBox.GetDataField: string;
begin
  Result:= FDataLink.FieldName;
end;

function TaidwldbWireTypeComboBox.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TaidwldbWireTypeComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TaidwldbWireTypeComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TaidwldbWireTypeComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName:= Value;
end;

procedure TaidwldbWireTypeComboBox.SetDataSource(Value: TDatasource);
begin
  FDataLink.DataSource:= Value;
end;

procedure TaidwldbWireTypeComboBox.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TaidwldbWireTypeComboBox.UpdateData(Sender: TObject);
begin
  if FDataLink.CanModify then
    FDataLink.Field.AsString:= Self.SelectedItem;
end;

{ TaidwlCustomWireColorComboBox }

procedure TaidwlCustomWireColorComboBox.AdjustDropDown;
begin
  inherited;
  SetDropDownWidth(171);
end;

constructor TaidwlCustomWireColorComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csOwnerDrawFixed;
  PopulateList;
end;

destructor TaidwlCustomWireColorComboBox.Destroy;
begin
  inherited;
end;

procedure TaidwlCustomWireColorComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if FlNeedToPopulate then
    PopulateList;
end;

procedure TaidwlCustomWireColorComboBox.WMDestroy(var Msg: TWMDestroy);
begin
  {FreeObjects();}
  inherited;
end;


procedure TaidwlCustomWireColorComboBox.PopulateList;
begin

end;

procedure TaidwlCustomWireColorComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  inherited;
  // Ensure that focus is rendered.
  Canvas.FillRect(Rect);
  //
  if Assigned(Items.Objects[Index]) then
    with TaidwlCustomWireColorObj(Items.Objects[Index]) do
      RenderToCanvas(Canvas, Rect, DroppedDown and (not (odComboBoxEdit in State)));
end;

procedure TaidwlCustomWireColorComboBox.SetDropDownWidth(const AValue: Integer);
var
  iWide : Integer;
begin
  if (AValue = 0) then iWide:= Self.Width else iWide:= AValue;
  SendMessage(Handle, CB_SETDROPPEDWIDTH, Longint(iWide), 0);
end;

function TaidwlCustomWireColorComboBox.GetSelectedItem: string;
begin
  Result:= '';
  if (ItemIndex>=0) and (ItemIndex<ItemCount) then
    Result:= Items[ItemIndex];
end;


procedure TaidwlCustomWireColorComboBox.SetSelectedItem(const Value: string);
var
  iK  : Integer;
  lFnd: Boolean;
begin
  lFnd:= False;
  for iK:= 0 to ItemCount-1 do
    if SameText(Items[iK], Value) then
    begin
      ItemIndex:= iK;
      lFnd:= True;
      Break;
    end;
  //
  if not lFnd then
    ItemIndex:= -1;
end;

procedure TaidwlCustomWireColorComboBox.ClearItems();
begin
  FreeObjects();
  Items.Clear;
end;


procedure TaidwlCustomWireColorComboBox.FreeObjects();
var
  iK  : Integer;
begin
  for iK:= 0 to Items.Count-1 do
    if Assigned(Items.Objects[iK]) then
    begin
      Items.Objects[iK].Free;
      Items.Objects[iK]:= nil;
    end;
end;

procedure TaidwlCustomWireColorComboBox.AddColorItem(ArItem: TaidwlWireColorItem);
begin
  if Items.IndexOf(ArItem.Value)<0 then
    Items.AddObject(ArItem.Value, TaidwlCustomWireColorObj.Create(ArItem));
end;



procedure TaidwlCustomWireColorComboBox.WMDeleteItem(var Msg: TWMDeleteItem);
var
  wItemData : Cardinal;
begin
  { Ensure that the associated objects are freed. }
  wItemData:= msg.DeleteItemStruct^.itemData;
  if (wItemData>0) then
    Dispose(Pointer(msg.DeleteItemStruct^.ItemData));
  inherited;
   
end;

{ TaidwldbWireColorComboBox }
constructor TaidwldbWireColorComboBox.Create(AOwner: TComponent);
begin
  inherited;
  //
  FlUpdPending:= False;
  FDataLink:= TFieldDataLink.Create;
  FDataLink.OnDataChange:=DataChange;
  FDataLink.OnUpdateData:= UpdateData;
end;


destructor TaidwldbWireColorComboBox.Destroy;
begin
  if Assigned(FDataLink) then
  begin
    FDataLink.OnDataChange:= nil;
    FDataLink.OnUpdateData:= nil;
    //
    FDataLink.Free;
  end;
  inherited;
end;

procedure TaidwldbWireColorComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then
    DataSource := nil;
end;


procedure TaidwldbWireColorComboBox.Change;
begin
  inherited;
  //
  if FDataLink.CanModify then
  begin
    FlUpdPending:= True;
    try
      FDataLink.Edit;
      inherited;
      FDataLink.Modified;
    finally
      FlUpdPending:= False;
    end;
  end;
end;

procedure TaidwldbWireColorComboBox.CMExit(var Message: TWMNoParams);
begin
  try
    FdataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;

procedure TaidwldbWireColorComboBox.DataChange(Sender: TObject);
begin
  if not FlUpdPending then
  begin
    if (FDataLink.field = nil) then
      SelectedItem:= ''
    else
      SelectedItem:= FDataLink.Field.AsString;
  end;
end;

function TaidwldbWireColorComboBox.GetDataField: string;
begin
  Result:= FDataLink.FieldName;
end;

function TaidwldbWireColorComboBox.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TaidwldbWireColorComboBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TaidwldbWireColorComboBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName:= Value;
end;

procedure TaidwldbWireColorComboBox.SetDataSource(Value: TDatasource);
begin
  FDataLink.DataSource:= Value;
end;

procedure TaidwldbWireColorComboBox.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TaidwldbWireColorComboBox.UpdateData(Sender: TObject);
begin
  if FDataLink.CanModify then
    FDataLink.Field.AsString:= Self.SelectedItem;
end;

{ TaidwlCustomWireColorObj }

constructor TaidwlCustomWireColorObj.Create(ArItem: TaidwlWireColorItem);
begin
  FrWireColorInfo:= ArItem;
end;

procedure TaidwlCustomWireColorObj.RenderToCanvas(ACanvas: TCanvas; ARect: TRect; AlVerbose: Boolean);
var
  rRct  : TRect;
  iMid  : Integer;
  sCap  : string;
begin
  if Assigned(ACanvas) then
  begin
    ACanvas.FillRect(ARect);
    rRct:= ARect;
    InflateRect(rRct, -1, -1);
    if not Odd(rRct.Bottom-rRct.Top) then
      dec(rRct.Bottom);
    //
    with ACanvas do
    begin
      iMid:= ((rRct.Bottom-rRct.Top) div 2);
      sCap:= Caption;
      // Colour
      Pen  .Color:= clDkGray;
      Brush.Color:= BGColor;
      FillRect(rRct);
      // Caption
      Brush.Style:= bsClear;
      Font .Color:= FGColor;
      TextRect(ARect, ARect.Left+iMid+2,  ARect.Top + (ARect.Bottom - ARect.Top - TextHeight(sCap)) div 2, sCap);
    end;
  end;
end;


{ FindWireFunc
    Returns the wire function definition for the supplied parameter. }
function FindWireFunc(AsWireFunc: string; var ArWireFunc: TaidwlWireFunction): Boolean;
var
  iK  : Integer;
begin
  Result:= False;
  FillChar(ArWireFunc, SizeOf(ArWireFunc), #0);
  if Assigned(FoWireFuncs) then
    for iK:= 0 to FoWireFuncs.Count-1 do
    begin
      if SameText(AsWireFunc, FoWireFuncs.Strings[iK]) then
      begin
        if (FoWireFuncs.Objects[iK] is TaidwlWireFunctionObj) then
        begin
          ArWireFunc:= TaidwlWireFunctionObj(FoWireFuncs.Objects[iK]).Data;
          Result:= True;
        end;
        break;
      end;
    end;
end;


function  FindCableType(AsCableType: string; var ArCableType: TaidwlCableType): Boolean;
var
  iK  : Integer;
begin
  Result:= False;
  FillChar(ArCableType, SizeOf(TaidwlCableType), #0);
  //
  if Assigned(FoCableTypes) then
    for iK:= 0 to FoCableTypes.Count-1 do
    begin
      if SameText(AsCableType, FoCableTypes.Strings[iK]) then
      begin
        if (FoCableTypes.Objects[iK] is TaidwlCableTypeObj) then
        begin
          ArCableType:= TaidwlCableTypeObj(FoCableTypes.Objects[iK]).Data;
          Result:= True;
        end;
        break;
      end;
    end;
end;



{ TwlLookupList }
destructor TwlLookupList.Destroy;
begin
  FreeObjects();
  inherited;
end;

procedure TwlLookupList.FreeObjects;
var
  iK  : Integer;
begin
  for iK:= 0 to Count-1 do
    if Assigned(Objects[iK]) then
    begin
      Objects[iK].Free;
      Objects[iK]:= nil;
    end;
end;

procedure TaidwlCustomWireTypeComboBox.FreeObjects;
var
  iK  : Integer;
begin
  for iK:= 0 to Items.Count-1 do
    if Assigned(Items.Objects[iK]) then
    begin
      Items.Objects[iK].Free;
      Items.Objects[iK]:= nil;
    end;
end;

procedure TaidwlCustomWireTypeComboBox.WMDestroy(var Msg: TWMDestroy);
begin
{  FreeObjects(); }
  Inherited;
end;

procedure TaidwlCustomWireFuncComboBox.FreeObjects;
var
  iK  : Integer;
begin
  for iK:= 0 to Items.Count-1 do
    if Assigned(Items.Objects[iK]) then
    begin
      Items.Objects[iK].Free;
      Items.Objects[iK]:= nil;
    end;
end;

procedure TaidwlCustomWireFuncComboBox.WMDestroy(var Msg: TWMDestroy);
begin
  {  FreeObjects(); }
  inherited;
end;

procedure TaidwlCustomWireFuncComboBox.WMDeleteItem(var Msg: TWMDeleteItem);
var
  wItemData : Cardinal;
begin
  { Ensure that the associated objects are freed. }
  wItemData:= msg.DeleteItemStruct^.itemData;
  if (wItemData>0) then
    Dispose(Pointer(msg.DeleteItemStruct^.ItemData));
  inherited;
end;

procedure TaidwlCustomCableTypeComboBox.FreeObjects;
var
  iK  : Integer;
begin
  for iK:= 0 to Items.Count-1 do
    if Assigned(Items.Objects[iK]) then
    begin
      Items.Objects[iK].Free;
      Items.Objects[iK]:= nil;
    end;
end;

procedure TaidwlCustomCableTypeComboBox.WMDestroy(var Msg: TWMDestroy);
begin
  {FreeObjects();}
  inherited;
end;

procedure TaidwlCustomWireTypeComboBox.WMDeleteItem( var Msg: TWMDeleteItem);
var
  wItemData : Cardinal;
begin
  { Ensure that the associated objects are freed. }
  wItemData:= msg.DeleteItemStruct^.itemData;
  if (wItemData>0) then
    Dispose(Pointer(msg.DeleteItemStruct^.ItemData));
  inherited;
end;

procedure TaidwlCustomCableTypeComboBox.WMDeleteItem(var Msg: TWMDeleteItem);
var
  wItemData : Cardinal;
begin
  { Ensure that the associated objects are freed. }
  wItemData:= msg.DeleteItemStruct^.itemData;
  if (wItemData>0) then
    Dispose(Pointer(msg.DeleteItemStruct^.ItemData));
  inherited;
end;

initialization
  // Creates the list of Wire & Terminal
  FoWireFuncs:= TwlLookupList.Create;
  FoWireFuncs.Sorted:= False;
  with FoWireFuncs do
  begin
    AddObject('BLACK' , TaidwlWireFunctionObj.Create(
      WireFunction('BLACK' , 'BLACK - Power'                      , clBlack , clNone  , clWhite , ''  , 'Black')));
    AddObject('RED'   , TaidwlWireFunctionObj.Create(
      WireFunction('RED'   , 'RED - a/c Control'                  , clRed   , clNone  , clWhite , ''  , 'Red')));
    AddObject('WHITE' , TaidwlWireFunctionObj.Create(
      WireFunction('WHITE' , 'WHITE - a/c Neutral'                , clWhite , clNone  , clBlack ,'RED', 'White')));
    AddObject('BLUE'  , TaidwlWireFunctionObj.Create(
      WireFunction('BLUE'  , 'BLUE - d/c Control'                 , clBlue  , clNone  , clWhite ,''   , 'Blue')));
    AddObject('GREY'  , TaidwlWireFunctionObj.Create(
      WireFunction('GREY'  , 'GREY - Electronic'                  , clGray  , clNone  , clBlack ,''   , 'Grey')));
    AddObject('GREEN' , TaidwlWireFunctionObj.Create(
      WireFunction('GREEN' , 'GREEN - Earth'                      , clGreen , clNone  , clYellow,''   , 'Green/Yellow')));
    AddObject('ORANGE', TaidwlWireFunctionObj.Create(
      WireFunction('ORANGE', 'ORANGE - Not Isolated'              , $999999 , clNone  , clBlack ,''   , 'Orange')));
    AddObject('YELLOW', TaidwlWireFunctionObj.Create(
      WireFunction('YELLOW', 'YELLOW - Not Isolated'              , clYellow, clNone  , clBlack ,''   , 'Yellow')));
    AddObject('WT/YE' , TaidwlWireFunctionObj.Create(
      WireFunction('WT/YE' , 'WHITE/YELLOW - Neutral not Isolated', clWhite , clYellow, clBlack ,''   , 'White/Yellow')));
    AddObject('WT/BL' , TaidwlWireFunctionObj.Create(
      WireFunction('WT/BL' , 'WHITE/BLUE - d/c Neutral Control'   , clWhite , clBlue  , clBlack ,''   , 'White/Blue')));
  end;
  // Cable Types
  FoCableTypes:= TwlLookupList.Create;
  FoCableTypes.Sorted:= False;
  with FoCableTypes do
  begin
    AddObject('YY'   , TaidwlCableTypeObj.Create(CableType(vawlctYY    , 'YY'  , 'YY'                       , ''      , ''     ,  ''       , False)));
    AddObject('SY'   , TaidwlCableTypeObj.Create(CableType(vawlctSY    , 'SY'  , 'SY - Steel Yarn'          , ''      , ''     ,  ''       , False)));
    AddObject('CY'   , TaidwlCableTypeObj.Create(CableType(vawlctCY    , 'CY'  , 'CY - Copper Yarn'         , ''      , ''     ,  ''       , False)));
    AddObject('BEL'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'BEL' , 'Belden'                   , 'SPECIAL', 'GREY', 'Shielded', False)));
    AddObject('DEF'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'DEF' , 'Def'                      , 'SPECIAL', 'GREY', 'Shielded', False)));
    AddObject('SIN'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'SIN' , 'Sinec'                    , 'SPECIAL', 'GREY', ''        , False)));
    AddObject('TOP'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'TOP' , 'Topflex'                  , 'SPECIAL', 'GREY', ''        , False)));
    AddObject('CAM'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'CAM' , 'PS2P22 Cambus'            , 'SPECIAL', 'GREY', ''        , False)));
    AddObject('AEC'  , TaidwlCableTypeObj.Create(CableType(vawlctDATA  , 'AEC' , 'Absolute Encoder Cable'   , 'SPECIAL', 'GREY', ''        , False)));
    AddObject('TRI'  , TaidwlCableTypeObj.Create(CableType(vawlctSINGLE, 'TRI' , 'Tri-rated'                , ''       , ''    , ''        , False)));
    AddObject('SCwb' , TaidwlCableTypeObj.Create(CableType(vawlctSINGLE, 'SCwb', 'Single Core(White/Blue)'  , ''       , ''    , ''        , False)));
    AddObject('SCwy' , TaidwlCableTypeObj.Create(CableType(vawlctSINGLE, 'SCwy', 'Single Core(White/Yellow)', ''       , ''    , ''        , False)));
    AddObject('SCye' , TaidwlCableTypeObj.Create(CableType(vawlctSINGLE, 'SCye', 'Single Core(Yellow)'      , ''       , ''    , ''        , False)));
    AddObject('CLIQ' , TaidwlCableTypeObj.Create(CableType(vawlctCLIQ  , 'CLIQ'  , 'CLIQ'                       , ''      , ''     ,  ''   , False)));
    //Obsolete Cable Types -->
    AddObject('YYp'  , TaidwlCableTypeObj.Create(CableType(vawlctYYpwr , 'YYp' , 'YY - Power'               , ''      , ''     ,  ''       , True )));
    AddObject('SYp'  , TaidwlCableTypeObj.Create(CableType(vawlctSYpwr , 'SYp' , 'SY - Steel Yarn Power'    , ''      , ''     ,  ''       , True )));
    AddObject('CYp'  , TaidwlCableTypeObj.Create(CableType(vawlctCYpwr , 'CYp' , 'CY - Copper Yarn Power'   , ''      , ''     ,  ''       , True )));
    //Obsolete Cable Types <--
  end;

finalization
  FreeAndNil(FoWireFuncs );
  FreeAndNil(FoCableTypes);


end.
