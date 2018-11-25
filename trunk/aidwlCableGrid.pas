unit aidwlCableGrid;

{ valCableGrid
    Grid component for viewing Cables in the WireLess system.

  see also
    valRunoutGrid

  modified
    CGR 18/11/2004, Modified the delete storage so that we can also store log information.

    ajc 2008Sept - expanded the wireless program so that it handles 25 cores. 
  }

interface

uses
  Windows, Messages, Forms, Classes, Grids, Types, Graphics, controls,
  aidTypes, aidwlLookups;

const
  CMaxCableWires      =  25;
  CCableNoColWidth    =  70;
  CCableDescColWidth  = 210;
  CCableWireColWidth  =  38;
  //
  CCableRouteRowHeight=  18*2+2;
  CCableWireRowHeight =  18*3+2;
type
  TaidwlCableWireItem = record
    lIsUsed         : Boolean;
    //
    iInc_CableWire  : TInc;
    lModified       : Boolean;
    //
    sWireNo         : string[10];
    //
    iPageNo         : Integer;
    iLineNo         : Integer;
    lIsNumberedEarth: Boolean;
    lIsScreened     : Boolean;
    iInc_Runout     : TInc;
  end;
type
  TaidwlCableRouteItem = record
    sLocSource  : string[10];
    sLocDest    : string[10];
    iLength_mm  : Integer;
  end;
type
  TaidwlWireColorItems = array [1..CMaxCableWires] of TaidwlWireColorItem;
  TaidwlCableWireItems = array [1..CMaxCableWires] of TaidwlCableWireItem;
type
  TaidwlCableGridStyle        = (wlcgsCable, wlcgsRouteBreak);
  TaidwlCableGridSearch       = (wlcgsNone, wlcgsCableNo, wlcgsWireNo, wlcgsCableSource);
  TaidwlCableGridSelectedCell = (wlcgcUnknown, wlcgcCable, wlcgcCableWire);
  TaidwlCableGridSelectedCellOption = (wlscCanMoveLeft, wlscCanMoveRight);
  TaidwlCableGridSelectedCellOptions= set of TaidwlCableGridSelectedCellOption;
type
  TaidwlCableGridCable = record
    iStyle          : TaidwlCableGridStyle;
    // iStyle = wlcgsCable
    // Cable Information
    iInc_Cable      : TInc;
    lModified       : Boolean;
    //
    sCableNo        : string[10];          // Cable ID
    sCableCode      : string[10];          // CableDef.CableCode ~
    sCableDesc      : string[50];          // Cable Description(From CableDef)
    sCableType      : string[10];          // RequiredCableType eg YY, SY
    iCableCore      : Integer;             // Number of wires available in cable (Length(aWires) = number of allocated))
    lIncludeFuncInDesc : Boolean;         // Indicates whether the cable function should be shown with it's description on display / export / etc
    sGroupFunc      : string[10];          // Grouping code for function eg RED&WHITE are grouped together as RED.
    // Wire Configurations
    sWiresFunc      : string[10];          // Function of wires within eg RED, WHITE, etc.
    sWiresDia       : string[10];          // Wire diameter eg 0001.5, 0002.5 etc.
    aWireColors     : TaidwlWireColorItems; // Cable Wire contents
    // Source
    sConnectorSource:string;               // Connector on the source end
    iStripSource_mm : Integer;             // Strip length on the source end
    sGlandSource    : string;              // Gland Size source end
    // Destination
    sConnectorDest  : string;              // Connector on the destination end
    iStripDest_mm   : Integer;             // Strip length on the destination end
    sGlandDest      : string;              // Gland Size destination end
    // Other
    iAdditional_mm  : Integer;             // Additional length to be added.
    sCableComment   : string;              // Comment for this cable
    // Wire Contents
    aWires          : TaidwlCableWireItems; // Actual wires used
    // iStyle = wlcgsRouteBreak
    // Route information
    iInc_CableRoute : TInc;
    iInc_LocSource  : TInc;
    sRouteSource    : string[10];  // eg A1
    sRouteSourceSeq : string[10];  // eg A1
    iInc_LocDest    : TInc;
    sRouteDest      : string[10];  // eg X1
    sRouteDestSeq   : string[10];  // eg X01
    sRouteDesc      : string[50];  // A-C-E
    sRouteComment   : string;      // Comment
    iRoute_mm       : integer;     // cable length in mm
    // Cable Information
    iTotalLength_mm : integer;     // Total of iRoute_mm+iAdditional_mm
  end;
type
  TaidwlCableGridCables = Array of TaidwlCableGridCable;

type
  TaidwlCableGridSelectConnectionEvent = procedure(Sender: TObject; ArCable: TaidwlCableGridCable; AiCableIndex: Integer) of object;
  TaidwlCableGridCableRemoveWireEvent  = procedure(Sender: TObject; ArCable: TaidwlCableGridCable; AiWireIndex: Integer) of object;
type
  TaidwlCableGrid = class(TCustomDrawGrid)
  private
    FaCables: TaidwlCableGridCables;
    FiLastRow: Integer;
    FOnSelectCableEvent: TaidwlCableGridSelectConnectionEvent;
    FlModified: Boolean;
    FOnModifiedChanged: TNotifyEvent;
    // Search
    FiLastSearch : TaidwlCableGridSearch;
    FsLastSearch : string;
    FiSelectedCellType: TaidwlCableGridSelectedCell;
    FOnSelectedCellType: TNotifyEvent;
    FiSelectedCellOptions: TaidwlCableGridSelectedCellOptions;
    //
    FoCableDeletes: TStringList;
    FoWireDeletes : TStringList;
    FOnRemoveCableWire: TaidwlCableGridCableRemoveWireEvent;
    FWireFont: TFont;
    FOnSelectedCellOptionsChanged: TNotifyEvent;
    //
    FrDragCable  : TaidwlCableGridCable;
    FiDragCable  : Integer;
    FiDragWire   : Integer;
    //
    procedure DrawCableCell(ACanvas: TCanvas; ACable: TaidwlCableGridCable; ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure DrawRouteCell(ACanvas: TCanvas; ACable: TaidwlCableGridCable; ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure SetOnSelectCableEvent(const Value: TaidwlCableGridSelectConnectionEvent);
    function GetCableCount: Integer;
    function GetCable(AiIndex: Integer): TaidwlCableGridCable;
    function GetSelectedCable: Integer;
    procedure SetCable(AiIndex: Integer; const Value: TaidwlCableGridCable);
    procedure SetSelectedCable(const Value: Integer);
    procedure SetModified(AlModified: Boolean);
    procedure SetOnModifiedChanged(const Value: TNotifyEvent);
    function  GetModified: Boolean;
    function  CableIsModified(ACableDef: TaidwlCableGridCable): Boolean;
    function GetLastSearchResult: TaidwlCableGridSearch;
    // Selected Cell Type & Changes
    function GetSelectedCellType: TaidwlCableGridSelectedCell;
    procedure SetSelectedCellType(ACellType: TaidwlCableGridSelectedCell);
    procedure DoSelectedCellType;
    procedure SetOnSelectedCellType(const Value: TNotifyEvent);
    // Selected Cell Type Options
    function  GetSelectedCellOptions: TaidwlCableGridSelectedCellOptions;
    procedure SetSelectedCellOptions(const Value: TaidwlCableGridSelectedCellOptions);
    procedure DoSelectedCellOptionsChanged;
    //
    function  GetDeletedCables: TStrings;
    function  GetDeletedWires: TStrings;
    procedure DrawTextCell(ARect: TRect; AAlignment: TAlignment; AsCaption: String; ABGColor: TColor = clWindow; AFGColor: TColor =  clWindowText; ABrushStyle: TBrushStyle = bsSolid);
    procedure DrawLine(ALeft, ATop, ARight, ABottom: Integer;  ALineColor: TColor = clBlack);
    procedure SetOnRemoveCableWire(
      const Value: TaidwlCableGridCableRemoveWireEvent);
    procedure SetWireFont(const Value: TFont);
    procedure SetOnSelectedCellOptionsChanged(const Value: TNotifyEvent);
  protected
    procedure   DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    function    SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure   DoCableChanged(ArCableEntry: TaidwlCableGridCable; AiCableIndex: Integer);
    procedure   DoModifiedChanged;
    function    CableIndexToRow(AiCable: Integer): Integer;
    function    RowToCableIndex(AiRow: Integer): Integer;
    function    WireIndexToColumn(AiWireIndex: Integer): Integer;
    function    ColumnToWireIndex(AiColumn: Integer): Integer;
    procedure   DoCableRemoveWireEvent(ArCable: TaidwlCableGridCable; AiWireIndex: Integer);
    procedure   MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure   DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure   DeleteWire(AiCable, AiWire: Integer; AlDeleteCableIfNoWiresRemain: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   DragDrop(Source: TObject; X, Y: Integer); override;
    //
    procedure   ClearAll;
    procedure   AddCable     (ACableDef: TaidwlCableGridCable);
    procedure   AddRouteBreak(ACableDef: TaidwlCableGridCable);
    property    CableCount: Integer read GetCableCount;
    property    Cable[AiIndex: Integer]: TaidwlCableGridCable read GetCable write SetCable;
    procedure   DeleteSelectedCable;
    procedure   DeleteSelectedWire;
    procedure   MoveSelectedWireLeft;
    procedure   MoveSelectedWireRight;
    property    SelectedCable: Integer read GetSelectedCable write SetSelectedCable;
    property    SelectedCellType: TaidwlCableGridSelectedCell read GetSelectedCellType;
    property    SelectedCellOptions: TaidwlCableGridSelectedCellOptions read GetSelectedCellOptions;
    function    HighestNumericCable: Integer;
    procedure   Sort;
    function    FindCableNo(AsCableNo: string; AlSelectIfFound: Boolean = False; AlFindFirst: Boolean = True): Integer;
    function    FindWireNo (AsWireNo : string; AlSelectIfFound: Boolean = False; AlFindFirst: Boolean = True): Integer;
    function    FindCableSource(AsSourceLoc: string; AlSelectIfFound: Boolean = False; AlFindFirst: Boolean = True): Integer;
    function    FindAgain: Integer;
    property    LastSearchResult: TaidwlCableGridSearch read GetLastSearchResult;
    property    DeletedCables: TStrings read GetDeletedCables;
    property    DeletedWires : TStrings read GetDeletedWires;
    function    ReplaceRouteProperties(AiInc_Source, AiInc_Dest: TInc; ArReplace: TaidwlCableGridCable): Integer;
    property    Modified: Boolean read GetModified;
  published
    property    Align;
    property    Anchors;
    property    Ctl3d;
    property    Font;
    property    ParentCtl3D;
    property    ParentFont;
    property    PopupMenu;
    property    TabOrder;
    property    TabStop;
    property    Visible;
    property    WireFont: TFont read FWireFont write SetWireFont;
    //
    property    OnEnter;
    property    OnExit;
    property    OnKeyDown;
    property    OnKeyPress;
    property    OnKeyUp;
    property    OnMouseUp;
    property    OnMouseMove;
    property    OnMouseDown;
    //
    property    OnSelectCableEvent: TaidwlCableGridSelectConnectionEvent read FOnSelectCableEvent write SetOnSelectCableEvent;
    property    OnRemoveCableWire: TaidwlCableGridCableRemoveWireEvent read FOnRemoveCableWire write SetOnRemoveCableWire;
    property    OnModifiedChanged: TNotifyEvent read FOnModifiedChanged write SetOnModifiedChanged;
    property    OnSelectedCellType: TNotifyEvent read FOnSelectedCellType write SetOnSelectedCellType;
    property    OnSelectedCellOptionsChanged: TNotifyEvent read FOnSelectedCellOptionsChanged write SetOnSelectedCellOptionsChanged;
  end;

function WiresAllocated(ACable: TaidwlCableGridCable): Integer;

implementation

{ TaidwlCableGrid }

uses
  Math, SysUtils,
  crUtil;

constructor TaidwlCableGrid.Create(AOwner: TComponent);
begin
  inherited;
  FWireFont     := TFont.Create;
  FoCableDeletes:= TStringList.Create;
  FoWireDeletes := TStringList.Create;
  //
  SetLength(FaCables, 0);
  DefaultColWidth := CCableWireColWidth;
  DefaultRowHeight:= CCableWireRowHeight;
  FixedCols       :=  0;
  FixedRows       :=  0;
  ColCount        :=  1;
  RowCount        :=  1;
  Options:= [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, {goRangeSelect, }goDrawFocusSelected];
  //
  ClearAll;
end;


destructor TaidwlCableGrid.Destroy;
begin
  FreeAndNil(FWireFont);
  FreeAndNil(FoCableDeletes);
  FreeAndNil(FoWireDeletes );
  inherited;
end;


function TaidwlCableGrid.CableIndexToRow(AiCable: Integer): Integer;
begin
  Result:= AiCable;
end;


function TaidwlCableGrid.RowToCableIndex(AiRow: Integer): Integer;
begin
  Result:= AiRow;
end;


procedure TaidwlCableGrid.ClearAll;
var
  iK,
  iWireCol  : Integer;
begin
  SetLength(FaCables, 0);
  RowCount    := 1;
  ColCount    := 1+1+CMaxCableWires;  // CableNo Column + CableDesc Column + 1..18 Wire Columns
  //
  ColWidths[0]:= CCableNoColWidth;
  ColWidths[1]:= CCableDescColWidth ;
  //
  for iK:= 1 to CMaxCableWires do
  begin
    iWireCol:= (1+1+(iK-1));
    ColWidths[iWireCol]:= CCableWireColWidth;
  end;
  //
  FiLastSearch:= wlcgsNone;
  FsLastSearch:= '';
  SetSelectedCellType(wlcgcUnknown);
  SetSelectedCellOptions([]);
  //
  FoCableDeletes.Clear;
  FoWireDeletes .Clear;
  //
  FiLastRow:= -1;
  FlModified:= False;
end;

{ AddRouteBreak }
procedure TaidwlCableGrid.AddRouteBreak(ACableDef: TaidwlCableGridCable);
var
  lExists : Boolean;
  iK      : Integer;
begin
  // Check that this route-break doesn't already exist
  lExists:= False;
  for iK:= Low(FaCables) to High(FaCables) do
    if (FaCables[iK].iStyle = wlcgsRouteBreak) and
       (FaCables[iK].iInc_LocSource  = ACableDef.iInc_LocSource ) and
       (FaCables[iK].iInc_LocDest    = ACableDef.iInc_LocDest   ) and
       (FaCables[iK].iInc_CableRoute = ACableDef.iInc_CableRoute) then
  begin
    lExists:= True;
    break;
  end;
  // Add if this is a new RouteBreak
  if (not lExists) then
  begin
    ACableDef.iStyle:= wlcgsRouteBreak;
    SetLength(FaCables, Length(FaCables)+1);
    FaCables[High(FaCables)]:= ACableDef;
    RowCount:= Length(FaCables);
    RowHeights[Pred(RowCount)]:= CCableRouteRowHeight;
    if (RowCount>0) then
      InvalidateRow(RowCount-1);
  end;
end;

{ AddCable  }
procedure TaidwlCableGrid.AddCable(ACableDef: TaidwlCableGridCable);
begin
  ACableDef.iStyle          := wlcgsCable;
  SetLength(FaCables, Length(FaCables)+1);
  FaCables[High(FaCables)]  := ACableDef;
  RowCount                  := Length(FaCables);

  RowHeights[Pred(RowCount)]:= CCableWireRowHeight;

  if (RowCount>0) then
    InvalidateRow(RowCount-1);
  // Check if this is modified
  if not Modified then
    SetModified(CableIsModified(ACableDef));
end;


function TaidwlCableGrid.CableIsModified(ACableDef: TaidwlCableGridCable): Boolean;
var
  iK    : Integer;
begin
  // Establish if this is a modified entry
  Result:= ACableDef.lModified;
  iK    := Low(ACableDef.aWires);
  if Length(ACableDef.aWires)>0 then
    while (not Result) and (iK<=High(ACableDef.aWires)) do
    begin
      if ACableDef.aWires[iK].lIsUsed then
        Result:= Result or ACableDef.aWires[iK].lModified;
      inc(iK);
    end;
end;



procedure TaidwlCableGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  rCable  : TaidwlCableGridCable;
begin
//  inherited;

  FillChar(rCable, SizeOf(rCable), #0);
  if ((ARow+1)<= Length(FaCables)) then
    rCable:= FaCables[ARow];

  case rCable.iStyle of
    wlcgsCable     :
    begin
      DrawCableCell(Canvas, rCable, ACol, ARow, ARect, AState);
    end;
    wlcgsRouteBreak:
    begin
      DrawRouteCell(Canvas, rCable, ACol, ARow, ARect, AState);
    end;
  end;
end;

procedure TaidwlCableGrid.DrawCableCell(ACanvas: TCanvas; ACable: TaidwlCableGridCable; ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  iMidH,
  iMidV    : Integer;
  iWire    : Integer;
  iRowH    : Integer;
  rLn1, rLn2,
  rLn3     : TRect;
  rTmp     : TRect;
  iTmp     : Integer;
  sText    : string;
  iHeadBG  : TColor;
  iHeadFG  : TColor;
  iBrushBG : TColor;
  iBrushFG : TColor;
  rStripS  : TRect;
  rStripDC : TRect;
  rStripD  : TRect;
  rWireFunc: TaidwlWireFunction;
  rComment : TRect;
  rAdditHd : TRect;
  rAdditTx : TRect;
  lAddit   : Boolean;
  templeft  : integer;
  tempright : integer;
  offset    : integer;
begin
  // Compute the two rows within a row
  iRowH:= Floor((ARect.Bottom-ARect.Top)/3);
  rLn1 := ARect; {rLn1.Top:= Succ(rLn1.Top);}  rLn1.Bottom:= rLn1.Top+iRowH;
  rLn2 := ARect; rLn2.Top:= Succ(rLn1.Bottom); rLn2.Bottom:= rLn2.Top+iRowH;
  rLn3 := ARect; rLn3.Top:= Succ(rLn2.Bottom);
  //
  iHeadBG := clBtnFace;
  iHeadFG := clBtnText;
  iBrushBG:= Canvas.Brush.Color;
  iBrushFG:= Canvas.Font .Color;
  // Draw seperators
  DrawLine(rLn1.Left , rLn1.Bottom, rLn1.Right, rLn1.Bottom, clSilver);
  DrawLine(rLn2.Left , rLn2.Bottom, rLn2.Right, rLn2.Bottom, clSilver);
  //
  case ACol of
    0:  // Cable No.
    begin
      // Heading
      DrawTextCell(rLn1, taLeftJustify , 'Cable No.'    , iHeadBG, iHeadFG);
      // Cable Type
      if aidwlLookups.FindWireFunc(ACable.sGroupFunc, rWireFunc) then
        DrawTextCell(rLn2, taLeftJustify , ACable.sCableNo, rWireFunc.wBGColor, rWireFunc.wFGColor)
      else
        DrawTextCell(rLn2, taLeftJustify , ACable.sCableNo, iBrushBG , iBrushFG);
      // Strip Source caption
      sText := 'Strip ' + ACable.sRouteSource+':';
      DrawTextCell(rLn3 , taRightJustify , sText, iHeadBG, iHeadFG);
    end;
    1: // Cable Type
    begin
      // Heading
      DrawTextCell(rLn1, taLeftJustify , 'Cable Type'    , iHeadBG, iHeadFG);
      // Cable Type
      if  ACable.lIncludeFuncInDesc then
        sText:= Separated([ACable.sCableDesc, ACable.sWiresFunc], ' ')
      else
        sText:= Separated([ACable.sCableDesc], ' ');
      DrawTextCell(rLn2, taLeftJustify, sText, iBrushBG, iBrushFG);
      // Strip Source, Strip Destination
      iTmp:= Floor((ARect.Right-ARect.Left)/3);
      rStripS := Rect(rLn3    .Left,  rLn3.Top, rLn3   .Left +iTmp, rLn3.Bottom);
      rStripDC:= Rect(rStripS .Right, rLn3.Top, rStripS.Right+iTmp, rLn3.Bottom);
      rStripD := Rect(rStripDC.Right, rLn3.Top, rLn3   .Right     , rLn3.Bottom);
      // Strip Source
      sText:= FormatFloat(',0mm', ACable.iStripSource_mm);
      if (ACable.iStripSource_mm<>0) then
        DrawTextCell(rStripS , taRightJustify , sText, iBrushBG , iBrushFG )
      else
        DrawTextCell(rStripS , taRightJustify , sText, clYellow , clBlack  );
      // Strip Dest caption
      sText:= 'Strip '+ ACable.sRouteDest+':';
      DrawTextCell(rStripDC, taRightJustify , sText, iHeadBG, iHeadFG);
      // Strip Destination
      sText:= FormatFloat(',0mm', ACable.iStripDest_mm);
      if (ACable.iStripDest_mm<>0) then
        DrawTextCell(rStripD , taRightJustify , sText, iBrushBG , iBrushFG )
      else
        DrawTextCell(rStripD , taRightJustify , sText, clYellow , clBlack  );
    end;
    2..2+CMaxCableWires:  // Wires
    begin
      iWire:= (ACol-2)+1;
      if (iWire in [Low(ACable.aWireColors)..High(ACable.aWireColors)]) and
         (iWire in [Low(ACable.aWires     )..High(ACable.aWires     )]) then
      begin
        Canvas.Font.Assign(WireFont);
        // This is a valid wire column, so render.
        if (iWire<=ACable.iCableCore) then
        begin
          // Heading
          Canvas.Brush.Color:= ACable.aWireColors[iWire].BGColor;
          Canvas.Font .Color:= ACable.aWireColors[iWire].FGColor;
          Canvas.Brush.Style:= bsSolid;
          Canvas.FillRect(rLn1);
          sText:= ACable.aWireColors[iWire].Caption;
          // Stripe Color
          if (ACable.aWireColors[iWire].BGColor <> ACable.aWireColors[iWire].StripeColor1) then
          begin
            Canvas.Brush.Color:= ACable.aWireColors[iWire].StripeColor1;
            Canvas.Pen  .Color:= ACable.aWireColors[iWire].StripeColor1;
            iMidH := rLn1.Left+((rLn1.Right-rLn1.Left) div 2);
            Canvas.Polygon([Point(iMidH , rLn1.Top     ), Point(iMidH+4, rLn1.Top     ),
                            Point(iMidH , rLn1.Bottom  ), Point(iMidH-3, rLn1.Bottom  )]);
            sText:= ' '+sText+' ';
          end;
          //
          if ACable.aWires[iWire].lIsNumberedEarth then
          begin
            iMidH:= rLn1.Left+Ceil((rLn1.Right -rLn1.Left) div 2);
            iMidV:= rLn1.Top +Ceil((rLn1.Bottom-rLn1.Top ) div 2);
            Canvas.Pen.Color:= ACable.aWireColors[iWire].FGColor;
            Canvas.MoveTo(iMidH   , iMidV-5);
            Canvas.LineTo(iMidH   , iMidV+1);
            Canvas.MoveTo(iMidH -5, iMidV+1);
            Canvas.LineTo(iMidH +6, iMidV+1);
            Canvas.MoveTo(iMidH -3, iMidV+3);
            Canvas.LineTo(iMidH +4, iMidV+3);
            Canvas.MoveTo(iMidH -1, iMidV+5);
            Canvas.LineTo(iMidH +2, iMidV+5);
          end
          else
            DrawText(Canvas.Handle, PChar(sText), Length(sText), rLn1, DT_SINGLELINE+DT_CENTER+DT_VCENTER+DT_NOPREFIX);
          // Draw the wire no.
          if ACable.aWires[iWire].lIsUsed then
          begin
            sText:= ACable.aWires[iWire].sWireNo;
            if ACable.aWires[iWire].lIsNumberedEarth then
              DrawTextCell(rLn2, taCenter, sText, clGreen, clYellow)
            else
              DrawTextCell(rLn2, taCenter, sText, iBrushBG, iBrushFG);
          end
          else
            // Don't show screen terminal as empty
            if CompareText(ACable.aWireColors[iWire].Caption, 'Screen')=0 then
            begin
              sText:= 'Screen';
              DrawTextCell(rLn2, taCenter, sText, clSilver, clBlack);
            end
            else
            // Wire not allocated, so indicate as spare
            begin
              Canvas.Pen.Color:= clSilver;
              Canvas.MoveTo(rLn2.Left +5, rLn2.Top+Floor((rLn2.Bottom-rLn2.Top)/2));
              Canvas.LineTo(rLn2.Right-5, rLn2.Top+Floor((rLn2.Bottom-rLn2.Top)/2));
            end;
        end
        else
        // Wire not available, so clear.
        begin
          rTmp:= rLn1;
          rTmp.Bottom:= rLn2.Bottom;
          Canvas.Brush.Color:= iHeadBG;
          Canvas.Brush.Style:= bsSolid;
          Canvas.FillRect(rTmp);
        end;
      end;

      //ajc:build - 7 : after making this 25 wires wide the are quite a few columns not showing on screen.
      //Cell rect is valid only for cells that are visible on screen. hence colcount cannot be used.
      //manually place the columns.
      //comments col3 (CCableNoColWidth *4) onward for roughly 13 (CCableNoColWidth *9)
      //addition width : 1,
      //addittion text  width 4 - so that the row is blanked.

      if self.LeftCol > 0  then
        offset := 4 - self.LeftCol -2
      else
        offset := 4;

      begin
        lAddit:= (ACable.iAdditional_mm<>0);
        if lAddit then
        begin
          templeft  := (CCableNoColWidth*offset)  + (CCableNoColWidth*9) + (CCableNoColWidth*1);// CellRect(ColCount-2, ARow).Left
          tempright := (CCableNoColWidth*offset)  + (CCableNoColWidth*9) + (CCableNoColWidth*1) + (CCableNoColWidth*4);// CellRect(ColCount-1, ARow).Left
          rAdditTx  := Rect(templeft , rLn3.Top, tempright, rLn3.Bottom);
          templeft  := (CCableNoColWidth*offset)  + (CCableNoColWidth*9)  ;//- (CCableNoColWidth*(self.LeftCol+5));//
          tempright := (CCableNoColWidth*offset)  + (CCableNoColWidth*9) + (CCableNoColWidth*1) ;//CellRect(ColCount-3, ARow).Right
          rAdditHd  := Rect(templeft, rLn3.Top,tempright , rLn3.Bottom);
          templeft  := (CCableNoColWidth*offset) ;// (CCableNoColWidth*(self.LeftCol-3));//  col2
          tempright := (CCableNoColWidth*offset) + (CCableNoColWidth*9);//col13
          rComment  := Rect(templeft, rLn3.Top, tempright, rLn3.Bottom);
        end
        else
        begin
          templeft  :=  (CCableNoColWidth*offset);
          tempright := (CCableNoColWidth*offset) + (CCableNoColWidth*9);
          rComment  := Rect(templeft , rLn3.Top, tempright , rLn3.Bottom);
        end;
        // Cable Type
        sText:= ACable.sCableComment;
        DrawTextCell(rComment, taLeftJustify, sText, clWhite, clBlack);
        // Additional Length
        if lAddit then
        begin
          // Header
          DrawTextCell(rAdditHd, taRightJustify, 'Add to length:', iHeadBG , iHeadFG);
          // Contents
          sText:= FormatFloat(',0mm', ACable.iAdditional_mm);
          DrawTextCell(rAdditTx, taLeftJustify, sText, iBrushBG, iBrushFG);
        end;
      end;
    end;
  end;
end;


procedure TaidwlCableGrid.DrawTextCell(ARect: TRect; AAlignment: TAlignment; AsCaption: String; ABGColor: TColor = clWindow; AFGColor: TColor =  clWindowText; ABrushStyle: TBrushStyle = bsSolid);
begin
  Canvas.Brush.Color:= ABGColor;
  Canvas.Brush.Style:= ABrushStyle;
  Canvas.Font .Color:= AFGColor;
  Canvas.FillRect(ARect);
  //
  case AAlignment of
    taLeftJustify :
    begin
      InflateRect(ARect, -2, 0);
      DrawText(Canvas.Handle, PChar(AsCaption), Length(AsCaption), ARect, DT_SINGLELINE+DT_LEFT+DT_VCENTER+DT_NOPREFIX);
    end;
    taRightJustify:
    begin
      InflateRect(ARect, -2, 0);
      DrawText(Canvas.Handle, PChar(AsCaption), Length(AsCaption), ARect, DT_SINGLELINE+DT_RIGHT+DT_VCENTER+DT_NOPREFIX);
    end;
    taCenter      :
    begin
      DrawText(Canvas.Handle, PChar(AsCaption), Length(AsCaption), ARect, DT_SINGLELINE+DT_CENTER+DT_VCENTER+DT_NOPREFIX);
    end;
  end;
end;


procedure TaidwlCableGrid.DrawLine(ALeft, ATop, ARight, ABottom: Integer; ALineColor: TColor = clBlack);
begin
  Canvas.Pen.Color:= ALineColor;
  Canvas.MoveTo(ALeft , ATop   );
  Canvas.LineTo(ARight, ABottom);
end;



procedure TaidwlCableGrid.DrawRouteCell(ACanvas: TCanvas; ACable: TaidwlCableGridCable; ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  iMid    : Integer;
  iTmp    : Integer;
  rTop,
  rBottom : TRect;
  rSourceH,
  rDestH  ,
  rLengthH,
  rSourceD,
  rDestD  ,
  rLengthD: TRect;


begin
  // Compute the two rows within a row
  iMid    := ARect.Top + Floor((ARect.Bottom-ARect.Top)/2);
  rTop    := ARect; rTop   .Bottom:= iMid;
  rBottom := ARect; rBottom.Top   := Succ(iMid);
  //
  case ACol of
    0:  // Cable No.
    begin
      // Heading
      DrawTextCell(rTop, taLeftJustify , ''     , clGray, clWhite);
      // Page Number
      DrawTextCell(rBottom, taLeftJustify , ''     , clGray, clWhite);
    end;
    1: // Route Information
    begin
      iTmp:= Floor((ARect.Right-ARect.Left)/3);
      rSourceH:= Rect(ARect   .Left,  rTop   .Top, ARect.Left+iTmp     , rTop   .Bottom);
      rDestH  := Rect(rSourceH.Right, rTop   .Top, rSourceH.Right+iTmp , rTop   .Bottom);
      rLengthH:= Rect(rDestH  .Right, rTop   .Top, ARect.Right,          rTop   .Bottom);
      rSourceD:= Rect(ARect   .Left,  rBottom.Top, ARect.Left+iTmp     , rBottom.Bottom);
      rDestD  := Rect(rSourceH.Right, rBottom.Top, rSourceH.Right+iTmp , rBottom.Bottom);
      rLengthD:= Rect(rDestH  .Right, rBottom.Top, ARect.Right,          rBottom.Bottom);
      //
      DrawTextCell(rSourceH, taLeftJustify , 'Source'     , clGray, clWhite);
      DrawTextCell(rDestH  , taLeftJustify , 'Destination', clGray, clWhite);
      DrawTextCell(rLengthH, taRightJustify, 'Length'     , clGray, clWhite);
      DrawTextCell(rSourceD, taLeftJustify , ACable.sRouteSource, clSkyBlue, clBlack);
      DrawTextCell(rDestD  , taLeftJustify , ACable.sRouteDest, clSkyBlue, clBlack);
      DrawTextCell(rLengthD, taRightJustify, FormatFloat(',0',ACable.iRoute_mm)+'mm', clSkyBlue, clBlack);
      //
      DrawLine(rSourceH.Right, rSourceH.Top, rSourceH.Right, rSourceD.Bottom, clSilver);
      DrawLine(rDestH  .Right, rDestH  .Top, rDestH  .Right, rDestD  .Bottom, clSilver);
    end
  else
    begin
      InflateRect(ARect, 1, 1);
      ACanvas.Brush.Color:= clGray;
      ACanvas.FillRect(ARect);
    end;
  end;
  // Draw seperator
  if ACol in [0..1] then
  begin
    Canvas.Pen.Color:= clSilver;
    Canvas.MoveTo(rTop.Left , iMid);
    Canvas.LineTo(rTop.Right, iMid);
  end;
end;


function TaidwlCableGrid.SelectCell(ACol, ARow: Integer): Boolean;
var
  rCable  : TaidwlCableGridCable;
  iWire   : Integer;
  iOpt    : TaidwlCableGridSelectedCellOptions;
begin
  result:= Inherited SelectCell(ACol, ARow);
  //
  if Result then
  begin
    FillChar(rCable, SizeOf(rCable), #0);
    if ((ARow+1)<= Length(FaCables)) then
      rCable:= FaCables[ARow];
    //
    case rCable.iStyle of
      wlcgsCable      :
      begin
        iOpt:= [];
        iWire := (ACol-2)+1;
        Result:= (ACol in [0..1]) or (iWire in [1..rCable.iCableCore]);
        if (iWire in [1..rCable.iCableCore]) then
        begin
          // Can we move the wire left ?
          if (iWire>1) then
              iOpt:= iOpt+[wlscCanMoveLeft];
          // Can we move the wire right ?
          if (iWire<rCable.iCableCore) then
              iOpt:= iOpt+[wlscCanMoveRight];
          SetSelectedCellOptions(iOpt);
          SetSelectedCellType(wlcgcCableWire);
        end
        else
        begin
          SetSelectedCellOptions([]);
          SetSelectedCellType(wlcgcCable);
        end;
      end;
      wlcgsRouteBreak :
      begin
        Result:= (ACol in [0..1]);
        SetSelectedCellOptions([]);
        SetSelectedCellType(wlcgcUnknown);
      end;
    end;
    //
    if result then
      if (ARow<>FiLastRow) then
      begin
        if rCable.iStyle in [wlcgsCable] then
          DoCableChanged(rCable, ARow);
        FiLastRow:= ARow;
      end;
  end;
end;

procedure TaidwlCableGrid.SetOnSelectCableEvent(const Value: TaidwlCableGridSelectConnectionEvent);
begin
  FOnSelectCableEvent := Value;
end;

procedure TaidwlCableGrid.DoCableChanged(ArCableEntry: TaidwlCableGridCable; AiCableIndex: Integer);
begin
  if Assigned(FOnSelectCableEvent) then
    FOnSelectCableEvent(Self, ArCableEntry, AiCableIndex);
end;



function WiresAllocated(ACable: TaidwlCableGridCable): Integer;
var
  iK  : Integer;
begin
  Result:= 0;
  if (ACable.iStyle in [wlcgsCable]) then
  begin
    for iK:= Low(ACable.aWires) to High(ACable.aWires) do
    begin
      if ACable.aWires[iK].lIsUsed then
        inc(Result);
    end;
  end;
end;

function TaidwlCableGrid.GetCableCount: Integer;
begin
  Result:= Length(FaCables);
end;

function TaidwlCableGrid.GetCable(AiIndex: Integer): TaidwlCableGridCable;
var
  iLow  : Integer;
  iHigh : Integer;
begin
  FillChar(Result, SizeOf(Result), #0);
  //
  iLow := Low (FaCables);
  iHigh:= High(FaCables);
  //
  if (AiIndex>=iLow) and (AiIndex<=iHigh) then
    Result:= FaCables[AiIndex]
end;


procedure TaidwlCableGrid.SetCable(AiIndex: Integer; const Value: TaidwlCableGridCable);
begin
  if (AiIndex>=Low(FaCables)) and (AiIndex<=High(FaCables)) then
  begin
    FaCables[AiIndex]:= Value;
    InvalidateRow(CableIndexToRow(AiIndex));
    // Check if this is modified
    if not Modified then
      SetModified(CableIsModified(Value));
  end;
end;


function TaidwlCableGrid.GetSelectedCable: Integer;
begin
  Result:= -1;
  if Length(FaCables)>0 then
    Result:= RowToCableIndex(Row);
end;


function TaidwlCableGrid.HighestNumericCable: Integer;
var
  iK  : Integer;
  iTmp: Integer;

  function LeadingNumberPortion(sNumber: string): Integer;
  var
    sTmp  : string;
    iK    : Integer;
  begin
    for iK:= 1 to Length(sNumber) do
    begin
      if (sNumber[iK] in ['0'..'9']) then
        sTmp:= sTmp+sNumber[iK]
      else
        break;
    end;
    Result:= StrToInt(sTmp);
  end;

begin
  Result:= 0;
  for iK:= Low(FaCables) to High(FaCables) do
    if (FaCables[iK].iStyle in [wlcgsCable]) then
    begin
      iTmp:= LeadingNumberPortion(FaCables[iK].sCableNo);
      if (iTmp>Result) then
        Result:= iTmp;
    end;
end;

procedure TaidwlCableGrid.SetSelectedCable(const Value: Integer);
begin
  if (Value>=Low(FaCables)) and (Value<=High(FaCables)) then
  begin
    Row:= CableIndexToRow(Value);
  end;
end;

{ Sort
    Sorts the cable entries similar to:
       cls.LocLabelSeq, cld.LocLabelSeq, Route/Cable, cc.CableNoSeq }
procedure TaidwlCableGrid.Sort;
var
  iK, iR  : Integer;
  rCable  : TaidwlCableGridCable;

  procedure QuickSortCableArray(var A: TaidwlCableGridCables; iLo, iHi: Integer);
  var
    Lo,
    Hi  : Integer;
    rTmp: TaidwlCableGridCable;
    sMid: String;

    function CableToSortString(ArCable: TaidwlCableGridCable): string;
    var
      cTmp  : Char;
    begin
      case ArCable.iStyle of
        wlcgsRouteBreak : cTmp:= '1';
        wlcgsCable      : cTmp:= '2';
      else
        cTmp:= '0';
      end;
      //
      Result:= PadL(ArCable.sRouteSource, 10, '0')+
               PadL(ArCable.sRouteDest  , 10, '0')+
               cTmp+
               PadL(ArCable.sCableNo    , 10, '0');
    end;

  begin
    Lo := iLo;
    Hi := iHi;
    sMid:= CableToSortString(A[(Lo + Hi) div 2]);
    repeat
      while (CompareText(CableToSortString(A[Lo]), sMid)<0) do
        Inc(Lo);
      while (CompareText(CableToSortString(A[Hi]), sMid)>0) do
        Dec(Hi);
      //
      if Lo <= Hi then
      begin
        rTmp := A[Lo];
        A[Lo]:= A[Hi];
        A[Hi]:= rTmp;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    //
    if Hi > iLo then QuickSortCableArray(A, iLo,  Hi);
    if Lo < iHi then QuickSortCableArray(A,  Lo, iHi);
  end;
begin
  { Sort the cables array. }
  If Length(FaCables)>0 Then
    QuickSortCableArray(FaCables, Low(FaCables), High(FaCables));
  //
  for iK:= Low(FaCables) to High(FaCables) do
  begin
    rCable:= self.Cable[iK];
    iR    := CableIndexToRow(iK);
    case rCable.iStyle of
      wlcgsCable      : RowHeights[iR]:= CCableWireRowHeight ;
      wlcgsRouteBreak : RowHeights[iR]:= CCableRouteRowHeight;
    end;
  end;
  //
  Self.InvalidateGrid;
end;




procedure TaidwlCableGrid.SetModified(AlModified: Boolean);
begin
  if (AlModified<>FlModified) then
  begin
    FlModified:= AlModified;
    DoModifiedChanged;
  end;
end;

procedure TaidwlCableGrid.DoModifiedChanged;
begin
  if Assigned(FOnModifiedChanged) then
    FOnModifiedChanged(Self);
end;

procedure TaidwlCableGrid.SetOnModifiedChanged(const Value: TNotifyEvent);
begin
  FOnModifiedChanged:= Value;
end;

function TaidwlCableGrid.GetModified: Boolean;
begin
  Result:= FlModified;
end;

function TaidwlCableGrid.FindCableNo(AsCableNo: string; AlSelectIfFound: Boolean = False; AlFindFirst: Boolean = True): Integer;
var
  iK    : Integer;
  iStart: Integer;
begin
  Result:= -1;
  if (Length(FaCables)>0) then
  begin
    if AlFindFirst then
      iStart:= Low(FaCables)
    else
      iStart:= Succ(SelectedCable);
    //
    for iK:= iStart to High(FaCables) do
      if (FaCables[iK].iStyle in [wlcgsCable]) then
      begin
        if SameText(Trim(AsCableNo), Trim(FaCables[iK].sCableNo)) then
        begin
          Result:= iK;
          Break;
        end;
      end;
    // Select / position to the row.
    if (Result>=0) then
    begin
      FiLastSearch:= wlcgsCableNo;
      FsLastSearch:= AsCableNo;
      if (AlSelectIfFound) then
        Row:= Self.CableIndexToRow(Result);
    end
    else
    begin
      FiLastSearch:= wlcgsNone;
      FsLastSearch:= '';
    end;
  end;
end;


function TaidwlCableGrid.FindWireNo(AsWireNo: string; AlSelectIfFound: Boolean = False; AlFindFirst: Boolean = True): Integer;
var
  iK    : Integer;
  iW    : Integer;
  iStart: Integer;
  iC    : Integer;
  lFnd  : Boolean;
begin
  Result:= -1;
  if (Length(FaCables)>0) then
  begin
    if AlFindFirst then
      iStart:= Low(FaCables)
    else
      iStart:= Succ(SelectedCable);
    //
    iW  := -1;
    lFnd:= False;
    iK  := iStart;
    while (iK<=High(FaCables)) and (not lFnd) do
    begin
      if (FaCables[iK].iStyle in [wlcgsCable]) and (Length(FaCables[iK].aWires)>0) then
      begin
        iW:= Low(FaCables[iK].aWires);
        while (iW<=High(FaCables[iK].aWires)) and (not lFnd) do
          if SameText(Trim(AsWireNo), Trim(FaCables[iK].aWires[iW].sWireNo)) then
          begin
            lFnd  := True;
            Result:= iK;
          end
          else
            inc(iW);
      end;
      inc(iK);
    end;
    // Select / position to the row.
    if (Result>=0) then
    begin
      FiLastSearch:= wlcgsWireNo;
      FsLastSearch:= AsWireNo;
      if (AlSelectIfFound) then
      begin
        Row:= Self.CableIndexToRow  (Result);
        iC := Self.WireIndexToColumn(iW);
        if (iC>=0) and (iC<ColCount) then
          Col:= iC;
      end;
    end
    else
    begin
      FiLastSearch:= wlcgsNone;
      FsLastSearch:= '';
    end;
  end;
end;


function TaidwlCableGrid.FindCableSource(AsSourceLoc: string; AlSelectIfFound, AlFindFirst: Boolean): Integer;
var
  iK    : Integer;
  iStart: Integer;
begin
  Result:= -1;
  if (Length(FaCables)>0) then
  begin
    if AlFindFirst then
      iStart:= Low(FaCables)
    else
      iStart:= Succ(SelectedCable);
    //
    for iK:= iStart to High(FaCables) do
      if (FaCables[iK].iStyle in [wlcgsRouteBreak]) then
      begin
        if SameText(Trim(AsSourceLoc), Trim(FaCables[iK].sRouteSource)) then
        begin
          Result:= iK;
          Break;
        end;
      end;
    // Select / position to the row.
    if (Result>=0) then
    begin
      FiLastSearch:= wlcgsCableSource;
      FsLastSearch:= AsSourceLoc;
      if (AlSelectIfFound) then
        Row:= CableIndexToRow(Result);
    end
    else
    begin
      FiLastSearch:= wlcgsNone;
      FsLastSearch:= '';
    end;
  end;
end;


function TaidwlCableGrid.FindAgain: Integer;
begin
  case FiLastSearch of
    wlcgsCableNo: Result:= FindCableNo (FsLastSearch, True, False);
    wlcgsWireNo : Result:= FindWireNo  (FsLastSearch, True, False);
  else
    Result:= -1;
  end;
end;


function TaidwlCableGrid.ColumnToWireIndex(AiColumn: Integer): Integer;
begin
  Result:= AiColumn-(1); // CableNo Column + CableDesc Column.
  if (Result<Low(TaidwlCableWireItems)) or (Result>High(TaidwlCableWireItems)) then
    Result:= -1;
end;


function TaidwlCableGrid.WireIndexToColumn(AiWireIndex: Integer): Integer;
begin
  Result:= -1;
  if (AiWireIndex>=Low(TaidwlCableWireItems)) and (AiWireIndex<=High(TaidwlCableWireItems)) then
    Result:= AiWireIndex+(1); // CableNo Column + CableDesc Column.
end;



function TaidwlCableGrid.GetLastSearchResult: TaidwlCableGridSearch;
begin
  Result:= FiLastSearch;
end;


procedure TaidwlCableGrid.DeleteSelectedCable;
var
  iCableIndex: Integer;
  iK         : Integer;
  rTmp       : TaidwlCableGridCable;
  iWire      : Integer;
  sLog       : string;
begin
  sLog:= '';
  iCableIndex:= SelectedCable;
  if (iCableIndex>=0) then
  begin
    rTmp:= FaCables[iCableIndex];
    // Notify that wires have been removed
    for iWire:= Low(rTmp.aWires) to High(rTmp.aWires) do
      if rTmp.aWires[iWire].lIsUsed then
      begin
        DoCableRemoveWireEvent(rTmp, iWire);
        if length(sLog)>0 then
          sLog:= sLog+', ';
        sLog:= sLog+rTmp.aWires[iWire].sWireNo;
      end;
    if length(sLog)>0 then
      sLog:= 'Cable: '+rTmp.sCableNo+' Wires('+sLog+')'
    else
      sLog:= 'Cable: '+rTmp.sCableNo;    
    // Move other cables down
    iK  := Succ(iCableIndex);
    while (iK<=High(FaCables)) do
    begin
      FaCables[Pred(iK)]:= FaCables[iK];
      inc(iK);
    end;
    // Add to the deletion list
    if (rTmp.iInc_Cable>0) then
    begin
//    FoCableDeletes.Add(IntToStr(rTmp.iInc_Cable));
      FoCableDeletes.Add(IntToStr(rTmp.iInc_Cable)+'='+sLog);
    end;
    //
    SetLength(FaCables, Length(FaCables)-1);
    RowCount:= RowCount-1;
    //
    SetModified(True);
    //
    InvalidateGrid;
  end;
end;


procedure TaidwlCableGrid.DeleteWire(AiCable, AiWire: Integer; AlDeleteCableIfNoWiresRemain: Boolean);
var
  rTmp       : TaidwlCableGridCable;
  rWire      : TaidwlCableWireItem;
  iK         : Integer;
  iCnt       : Integer;
  sLog       : string;
begin
  sLog:= '';
  // Delete the wire
  if (AiCable>=0) then
  begin
    rTmp:= FaCables[AiCable];
    if (AiWire>=Low(rTmp.aWires)) then
    begin
      rWire:= rTmp.aWires[AiWire];
      sLog := 'Cable: '+rTmp.sCableNo+' Wire: '+rWire.sWireNo+' Position: '+IntToStr(AiWire);
      // Notify that wire has been removed
      DoCableRemoveWireEvent(rTmp, AiWire);
      // Move other wires down
      iK  := Succ(AiWire);
      while (iK<=High(rTmp.aWires)) do
      begin
        rTmp.aWires[Pred(iK)]:= rTmp.aWires[iK];
        rTmp.aWires[Pred(iK)].lModified:= True; // Wire offset changes, so mark as modified.
        inc(iK);
      end;
      // Fill the last wire with a blank
      FillChar(rTmp.aWires[High(rTmp.aWires)], SizeOf(TaidwlCableWireItem), #0);
      rTmp.aWires[High(rTmp.aWires)].iInc_CableWire:= -1;
      rTmp.aWires[High(rTmp.aWires)].iInc_Runout   := -1;
      // Add to the deletion list
      if (rWire.iInc_CableWire>0) then
      begin
        FoWireDeletes.Add(IntToStr(rWire.iInc_CableWire)+'='+sLog);
//      FoWireDeletes.Add(IntToStr(rWire.iInc_CableWire));
      end;
      // Update the cable
      FaCables[AiCable]:= rTmp;
      // Count wires in use
      iCnt:= 0;
      for iK:= Low(rTmp.aWires) to High(rTmp.aWires) do
        if rTmp.aWires[iK].lIsUsed then
          Inc(iCnt);
      //
      if (iCnt>0) then
        InvalidateRow(CableIndexToRow(AiCable))
      else // no wires - delete.
        if AlDeleteCableIfNoWiresRemain then
          DeleteSelectedCable;
      //
      SetModified(True);
    end;
  end;
end;



procedure TaidwlCableGrid.DeleteSelectedWire;
var
  iCableIndex: Integer;
  iWireIndex : Integer;
begin
  iCableIndex:= SelectedCable;
  iWireIndex := ColumnToWireIndex(Col);

  DeleteWire(iCableIndex, iWireIndex, True);
end;

function TaidwlCableGrid.GetSelectedCellType: TaidwlCableGridSelectedCell;
begin
  Result:= FiSelectedCellType;
end;


function TaidwlCableGrid.GetSelectedCellOptions: TaidwlCableGridSelectedCellOptions;
begin
  Result:= FiSelectedCellOptions;
end;

procedure TaidwlCableGrid.SetSelectedCellType(ACellType: TaidwlCableGridSelectedCell);
begin
  if (FiSelectedCellType<>ACellType) then
  begin
    FiSelectedCellType:= ACellType;
    DoSelectedCellType;
  end;
end;

procedure TaidwlCableGrid.DoSelectedCellType;
begin
  if Assigned(FOnSelectedCellType) then
    FOnSelectedCellType(Self);
end;

procedure TaidwlCableGrid.SetOnSelectedCellType(const Value: TNotifyEvent);
begin
  FOnSelectedCellType := Value;
end;

function TaidwlCableGrid.GetDeletedCables: TStrings;
begin
  Result:= FoCableDeletes;
end;

function TaidwlCableGrid.GetDeletedWires: TStrings;
begin
  Result:= FoWireDeletes;
end;

procedure TaidwlCableGrid.SetOnRemoveCableWire(const Value: TaidwlCableGridCableRemoveWireEvent);
begin
  FOnRemoveCableWire:= Value;
end;

procedure TaidwlCableGrid.DoCableRemoveWireEvent(ArCable: TaidwlCableGridCable; AiWireIndex: Integer);
begin
  if Assigned(FOnRemoveCableWire) then
    FOnRemoveCableWire(Self, ArCable, AiWireIndex);
end;

function TaidwlCableGrid.ReplaceRouteProperties(AiInc_Source, AiInc_Dest: TInc; ArReplace: TaidwlCableGridCable): Integer;
var
  iCable  : Integer;
  iRow    : Integer;
  rCable  : TaidwlCableGridCable;
begin
  Result:= -1;
  for iCable:= Low(FaCables) to High(FaCables) do
  begin
    iRow:= self.CableIndexToRow(iCable);
    if (FaCables[iCable].iStyle in [wlcgsCable]) then
      if (FaCables[iCable].iInc_LocSource = AiInc_Source) and (FaCables[iCable].iInc_LocDest = AiInc_Dest) then
      begin
        rCable:= FaCables[iCable];
        if (rCable.iStripSource_mm<>ArReplace.iStripSource_mm) or
           (rCable.iStripDest_mm  <>ArReplace.iStripDest_mm) then
        begin
          rCable.iStripSource_mm:= ArReplace.iStripSource_mm;
          rCable.iStripDest_mm  := ArReplace.iStripDest_mm;
          rCable.lModified      := True;
          FaCables[iCable]      := rCable;
        end;
      end;
    //
    InvalidateRow(iRow);
  end;
end;

procedure TaidwlCableGrid.SetWireFont(const Value: TFont);
begin
  FWireFont.Assign(Value);
end;


procedure TaidwlCableGrid.SetSelectedCellOptions(const Value: TaidwlCableGridSelectedCellOptions);
begin
  if (FiSelectedCellOptions<>Value) then
  begin
    FiSelectedCellOptions:= Value;
    DoSelectedCellOptionsChanged;
  end;
end;

procedure TaidwlCableGrid.MoveSelectedWireLeft;
var
  iCableIndex: Integer;
  iWireIndex : Integer;
  rTmp       : TaidwlCableGridCable;
  rLeft      : TaidwlCableWireItem;
  rWire      : TaidwlCableWireItem;
begin
  iCableIndex:= SelectedCable;
  iWireIndex := ColumnToWireIndex(Col);
  // Delete the wire
  if (iCableIndex>=0) then
  begin
    rTmp  := FaCables[iCableIndex];
    rWire := rTmp.aWires[     iWireIndex ];
    rWire.lModified:=   True;
    rLeft:= rTmp.aWires [Pred(iWireIndex)];
    rLeft.lModified:= True;
    //
    rTmp.aWires[Pred(iWireIndex)]:= rWire;
    rTmp.aWires[     iWireIndex ]:= rLeft;

    FaCables[iCableIndex]:= rTmp;
    //
    InvalidateRow(CableIndexToRow(iCableIndex));
    SetModified(True);
    //
    Col:= Col-1;
    SelectCell(Col, Row);
  end;
end;


procedure TaidwlCableGrid.MoveSelectedWireRight;
var
  iCableIndex: Integer;
  iWireIndex : Integer;
  rTmp       : TaidwlCableGridCable;
  rRight     : TaidwlCableWireItem;
  rWire      : TaidwlCableWireItem;
begin
  iCableIndex:= SelectedCable;
  iWireIndex := ColumnToWireIndex(Col);
  // Delete the wire
  if (iCableIndex>=0) then
  begin
    rTmp  := FaCables[iCableIndex];
    rWire := rTmp.aWires[     iWireIndex ];
    rWire.lModified:=   True;
    rRight:= rTmp.aWires[Succ(iWireIndex)];
    rRight.lModified:= True;
    //
    rTmp.aWires[Succ(iWireIndex)]:= rWire;
    rTmp.aWires[     iWireIndex ]:= rRight;

    FaCables[iCableIndex]:= rTmp;
    //
    InvalidateRow(CableIndexToRow(iCableIndex));
    SetModified(True);
    //
    Col:= Col+1;
    SelectCell(Col, Row);
  end;
end;


procedure TaidwlCableGrid.DoSelectedCellOptionsChanged;
begin
  if Assigned(FOnSelectedCellOptionsChanged) then
    FOnSelectedCellOptionsChanged(Self);
end;

procedure TaidwlCableGrid.SetOnSelectedCellOptionsChanged( const Value: TNotifyEvent);
begin
  FOnSelectedCellOptionsChanged:= Value;
end;

procedure TaidwlCableGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol,
  ARow    : integer;
  iCable  : Integer;
  iWire   : Integer;
  rCable  : TaidwlCableGridCable;
begin
  inherited;

  MouseToCell(X, Y, ACol, ARow);  // gets column and row
  //
  iCable:= RowToCableIndex(ARow);
  iWire := ColumnToWireIndex(ACol);
  rCable:= Cable[iCable];
  // Valid
  if (Button = mbLeft) then
    if (iWire>=0) and (rCable.iStyle in [wlcgsCable]) then
    begin
      if rCable.aWires[iWire].lIsUsed then
      begin
        FrDragCable:= rCable;
        FiDragCable:= iCable;
        FiDragWire := iWire;
        //
        BeginDrag(False);
      end;
    end;
end;


procedure TaidwlCableGrid.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  ACol,
  ARow    : integer;
  rCable  : TaidwlCableGridCable;
  iWire   : Integer;
begin
  inherited;

  // Identify cell
  MouseToCell(X, Y, ACol, ARow);  // gets column and row
  rCable:= Cable[RowToCableIndex(ARow)];
  iWire := ColumnToWireIndex(ACol);

  Accept:= False;

  // Check that the source wire (& cable info) matches the destination
  // cable info (Route, Func, Cable Type, Wire Dia, etc)
  if (iWire>0) and (iWire<=rCable.iCableCore) and (rCable.iStyle in [wlcgsCable]) then
  begin
    if (FrDragCable.iInc_LocSource = rCable.iInc_LocSource) and
       (FrDragCable.iInc_LocDest   = rCable.iInc_LocDest  ) and
       (FrDragCable.sCableType     = rCable.sCableType    ) and
       (FrDragCable.sGroupFunc     = rCable.sGroupFunc    ) and
       (FrDragCable.sWiresDia      = rCable.sWiresDia     ) and
       (not rCable.aWires[iWire].lIsUsed) then
      begin
        Accept:= True;
      end;
  end;
end;


procedure TaidwlCableGrid.DragDrop(Source: TObject; X, Y: Integer);
var
  ACol,
  ARow    : integer;
  rCable  : TaidwlCableGridCable;
  iCable  : Integer;
  iWire   : Integer;
  rWire   : TaidwlCableWireItem;
begin
  inherited;
  // Identify cell
  MouseToCell(X, Y, ACol, ARow);  // gets column and row
  // Delete the source wire
  DeleteWire(FiDragCable, FiDragWire, True);
  // As the dragover event has done validation, we assume that this is okay.
  iCable:= RowToCableIndex(ARow);
  iWire := ColumnToWireIndex(ACol);
  rCable:= Cable[iCable];
  rWire := rCable.aWires[iWire];
  // Create in the new drop location
  rCable.aWires[iWire]:= FrDragCable.aWires[FiDragWire];
  rCable.aWires[iWire].iInc_CableWire:= -1;
  rCable.aWires[iWire].lModified:= True;
  rCable.lModified:= True;
  // Assign
  Cable[iCable]:= rCable;
  // Signal a redraw
  self.InvalidateRow(ARow);
end;



end.

