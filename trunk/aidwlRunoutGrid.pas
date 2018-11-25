unit aidwlRunoutGrid;

{ valRunoutGrid
    Grid component for displaying a single contract runout page.   }

interface

uses
  Windows, Forms, Classes, Grids, Types, Graphics,
  aidTypes, aidwlTypes;


type
  TaidwlRunoutGridDestination = packed record
    iInc_Loc      : TInc;
    sCaption      : TDestinationDesc;
    sDescription  : TDestinationDesc;
    // Internal
    iColumn       : Integer;
  end;
  TaidwlRunoutGridDestinations = Array of TaidwlRunoutGridDestination;

const
  CwlRunoutWiresPerPage       = 17;
  CwlRunoutExtraColumns       =  4; { Wire Sz; Cable Type; Drawing; IsCabled }
  //
  CwlRunoutConnectionColumnHeight = 21;
  CwlRunoutConnectionColumnWidth  = 35;
  //
  CwlRunoutWireColumnWidth       = 75;
  CwlRunoutCableTypeWidth        = 50;
  CwlRunoutDrawingColumnWidth    = 45;
  CwlRunoutIsCabledColumnWidth   = 15;
type
  TTerminalNo = String[10];
  TWireDia    = TLookupKey;
  TWireDiaDesc= String[50];
  TWireType   = TLookupKey;
  TWireFunc   = TLookupKey;
  TDrawingRef = String[20];

  TaidwlRunoutGridConnection   = packed record
    lIsConnected  : Boolean;  // Used ?
    //
    iInc_Runout   : TInc;
    //
    iInc_Source   : TInc;         // Source
    iInc_Dest     : TInc;         // Destination
    // ~~ these need to be changed to their correct String[] size.
    sTerminal     : TTerminalNo;  // Wire / Terminal no.
    sWireDia      : TWireDia;     // Wire Diameter Code
    sWireDiaDesc  : TWireDiaDesc; // Wire Diameter Description
    sWireType     : TWireType;    // Wire Type - determines values for lIsShielded, lIsAnEarth
    sWireFunc     : TWireFunc;    // Wire Function eg BLACK, RED, etc
    sCableType    : TCableTypeKey;// Cable this needs eg CY, SY, BEL
    sDrawingRef   : TDrawingRef;  // Drawing Reference - typically drawing page #
    sComment      : TGridCellComment;  // Comments specific to this connection.
    //
    lIsShielded,
    lIsAnEarth        : Boolean;
    // Cable
    lIsCabled         : Boolean; // Has this runout already been cabled
    // Internal
    iColumnSource     : Integer;
    iColumnDest       : Integer;
    wFuncBGColor      : TColor;
    wFuncFGColor      : TColor;
    wFuncStripeColor  : TColor;
    //
    lModified         : Boolean;
  end;
  TaidwlRunoutGridConnections = Array[1..CwlRunoutWiresPerPage] of TaidwlRunoutGridConnection;
type
  TaidwlRunoutGridSelectConnectionEvent = procedure (Sender: TObject; AConnection: TaidwlRunoutGridConnection) of object;
type
  TaidwlRunoutGrid = class(TCustomDrawGrid)
  private
    // Columns (X Axis)
    FDestinations : TaidwlRunoutGridDestinations;
    // Rows    (Y Axis)
    FWires        : TaidwlRunoutGridConnections;
    //
    FDeletes : TStringlist;
    FModified: Boolean;
    FiLastRow: Integer;
    FOnSelectConnection: TaidwlRunoutGridSelectConnectionEvent;
    FOnModifiedChanged: TNotifyEvent;
    FPageNo: Integer;
    procedure SetModified(const Value: Boolean);
    procedure SetOnSelectConnection(const Value: TaidwlRunoutGridSelectConnectionEvent);
    function  GetDeletes: TStrings;
    function GetWire(Index: Integer): TaidwlRunoutGridConnection;
    function GetWireCount: Integer;
    procedure DoModifiedChanged;
    procedure SetOnModifiedChanged(const Value: TNotifyEvent);
    procedure SetPageNo(const Value: Integer);
  protected
    procedure   DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    function    SelectCell(ACol, ARow: Longint): Boolean; override;
    function    CheckedConnection(AConnection: TaidwlRunoutGridConnection): TaidwlRunoutGridConnection;
    procedure   DoSelectConnection(AConnection: TaidwlRunoutGridConnection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Loaded; override;
    procedure   ClearAll;
    // Columns
    procedure   ClearDestinations;
    procedure   AddDestination(AConnection: TaidwlRunoutGridDestination);
    function    AsDestination (AiInc_Loc: TInc; AsCaption, AsDescription: String): TaidwlRunoutGridDestination;
    // Rows
    procedure   ClearConnections;
    function    AppendConnection(AConnection: TaidwlRunoutGridConnection): Boolean;
    procedure   RemoveSelectedConnection;
    procedure   RemoveConnection(AiIndex: Integer);
    procedure   SetConnection(ALineNo: Integer; AConnection: TaidwlRunoutGridConnection);
    procedure   SwapLines(const AwSwapFrom, AwSwapTo: Word);
    function    CurrentRowIsConnected: Boolean;
    function    CurrentRowDrawingRef: string;
    //
    property    DeletedRunouts: TStrings read GetDeletes;
    property    PageNo: Integer read FPageNo write SetPageNo;
    property    WireCount: Integer read GetWireCount;
    property    Wire[AiIndex: Integer]: TaidwlRunoutGridConnection read GetWire;
    property    Modified: Boolean read FModified write SetModified;
    property    ColWidths stored False;
    property    RowHeights stored False;
  published
    property    Align;
    property    Anchors;
    property    Ctl3d;
    property    Font;
    property    ParentCtl3D;
    property    ParentFont;
    property    PopupMenu;
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
    property    OnSelectConnection: TaidwlRunoutGridSelectConnectionEvent read FOnSelectConnection write SetOnSelectConnection;
    property    OnModifiedChanged : TNotifyEvent read FOnModifiedChanged write SetOnModifiedChanged;
  end;

implementation

uses
  math, SysUtils,
  aidwlLookups;

{ TaidwlRunoutGrid }
constructor TaidwlRunoutGrid.Create(AOwner: TComponent);
begin
  inherited;
  SetLength(FDestinations, 0);
  //
  FModified:= False;
  FDeletes := TStringlist.Create;
  FDeletes.Duplicates:= dupIgnore;
  FiLastRow:= -1;
  //
  FixedCols       := 0;
  FixedRows       := 1;
  RowCount        := CwlRunoutWiresPerPage+FixedRows{1};
  DefaultRowHeight:= CwlRunoutConnectionColumnHeight;
  DefaultColWidth := CwlRunoutConnectionColumnWidth;
  if Assigned(Parent) then
    ParentCtl3d   := False;
  Ctl3d := False;
  Height:= 2+(CwlRunoutWiresPerPage*(DefaultRowHeight+1))+((2*DefaultRowHeight)+1);// 2 frame, data+border, double height titles
  BorderStyle:= bsSingle;
  Options:= [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect];
  //
  ClearAll;
end;

destructor TaidwlRunoutGrid.Destroy;
begin
  FreeAndNil(FDeletes);
  SetLength(FDestinations, 0);
  inherited;
end;

procedure TaidwlRunoutGrid.Loaded;
begin
  inherited;
  if Assigned(Parent) then
  begin
    ParentCtl3d:= False;
    Ctl3d      := False;
  end;
end;

procedure TaidwlRunoutGrid.ClearAll;
begin
  ClearConnections;
  ClearDestinations;
end;

procedure TaidwlRunoutGrid.ClearDestinations;
begin
  SetLength(FDestinations, 0);
  ColCount:= Length(FDestinations)+CwlRunoutExtraColumns; {Wire Sz; Cable Type; Drawing; IsCabled }
  if (ColCount>=4) then
  begin
    Self.ColWidths[0]:= CwlRunoutWireColumnWidth;    // Wire Description
    Self.ColWidths[1]:= CwlRunoutCableTypeWidth;     // Cable Type
    Self.ColWidths[2]:= CwlRunoutDrawingColumnWidth; // Drawing Info.
    Self.ColWidths[3]:= CwlRunoutIsCabledColumnWidth;// Is Cabled
  end;
end;

procedure TaidwlRunoutGrid.ClearConnections;
var
  iK,
  iR  : Integer;
begin
  if Self.RowCount>0 then
    Self.RowHeights[0]:= 2 * Self.DefaultRowHeight;
  //
  iR:= 1;
  for iK:= Low(FWires) to High(FWires) do
  begin
    FillChar(FWires, SizeOf(FWires), #0);
    Self.InvalidateRow(iR); inc(iR);
  end;
{  //
  if not (csLoading in ComponentState) then
    Modified:= True;}
end;

procedure TaidwlRunoutGrid.AddDestination(AConnection: TaidwlRunoutGridDestination);
var
  iNew      : Integer;
  iWire     : Integer;
  iCableTy  : Integer;
  iDraw     : Integer;
  iIsCabled : Integer;
begin
  // Validate ?
  SetLength(FDestinations, Length(FDestinations)+1);
  FDestinations[High(FDestinations)]:= AConnection;
  ColCount:= Length(FDestinations)+CwlRunoutExtraColumns; {Wire Sz; Cable Type; Drawing; IsCabled }
  // Now, we need to recompute cell widths & invalidate
  // Destinations is a zero based array - the first column in the grid is zero based.
  iNew     := Pred(Length(FDestinations));
  iWire    := Succ(iNew);
  iCableTy := Succ(iWire);
  iDraw    := Succ(iCableTy);
  iIsCabled:= Succ(iDraw);
  //
  ColWidths[iNew     ]:= CwlRunoutConnectionColumnWidth; // Should fit 6
  ColWidths[iWire    ]:= CwlRunoutWireColumnWidth;
  ColWidths[iCableTy ]:= CwlRunoutCableTypeWidth;
  ColWidths[iDraw    ]:= CwlRunoutDrawingColumnWidth;
  ColWidths[iIsCabled]:= CwlRunoutIsCabledColumnWidth;
end;

function TaidwlRunoutGrid.AppendConnection(AConnection: TaidwlRunoutGridConnection): Boolean;
var
  iK  : Integer;
  iL  : Integer;
begin
  Result:= False;
  // Establish first empty spot after the last used line.
  iK:= High(FWires);
  iL:= -1;
  while (iK>=Low(FWires)) do
    if Fwires[iK].lIsConnected then
      break
    else
    begin
      iL:= iK;
      dec(iK);
    end;
  //
  if (iL in [Low(FWires)..High(FWires)]) then
  begin
    Result:= True;
    Fwires[iL]:= CheckedConnection(AConnection);
    Fwires[iL].lIsConnected:= True;
    Fwires[iL].lModified   := True;
    //
    InvalidateRow(iL);  // [0] is title, Line numbers start at 1
    Modified:= True;
    //
    Row:= iL;
  end;
end;



procedure TaidwlRunoutGrid.SetConnection(ALineNo: Integer; AConnection: TaidwlRunoutGridConnection);
begin
  if (ALineNo in [Low(FWires)..High(FWires)]) then
  begin
    // Store the row identifier, as this is an update
    Fwires[ALineNo]:= CheckedConnection(AConnection);
    Fwires[ALineNo].lIsConnected:= True;
    Fwires[ALineNo].lModified   := True;
    //
    InvalidateRow(ALineNo);  // [0] is title, Line numbers start at 1
    Modified:= True;
  end
  else
    // ~ need to raise an exception here
    ;
end;

function TaidwlRunoutGrid.AsDestination(AiInc_Loc: TInc; AsCaption, AsDescription: String): TaidwlRunoutGridDestination;
begin
  FillChar(Result, SizeOf(TaidwlRunoutGridDestination), #0);
  Result.iInc_Loc    := AiInc_Loc;
  Result.sCaption    := AsCaption;
  Result.sDescription:= AsDescription;
end;

procedure TaidwlRunoutGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  iDestCount: Integer;
  iWire     : Integer;
  iCableTy  : Integer;
  iDraw     : Integer;
  iIsCabled : Integer;
  //
  rConn     : TaidwlRunoutGridConnection;
  iConn     : Integer;
  rLine     : TRect;
  iMid      : Integer;
  rSz       : TSize;
  iX        : Integer;
  iY        : Integer;
  //
  aPts  : Array[0..3] of TPoint;
  iMidS : Integer;
const
  CTickChar : Char = Char($FC);

  procedure DrawText(ARect: TRect; AState: TGridDrawState; AsCaption: String);
  var
    rRect     : TRect;
    sCaption  : String;
    iFormat   : Integer;
    iVertOff  : Integer;
    iHeight   : Integer;
  begin
    rRect   := ARect;
    sCaption:= AsCaption;
    iFormat := DT_CENTER+DT_NOPREFIX+DT_WORDBREAK+DT_CALCRECT;
    iHeight := windows.DrawText(Self.Canvas.Handle, PChar(sCaption), Length(sCaption), rRect, iFormat);

    if (iHeight>0) then
    begin
      iVertOff:= ((ARect.Bottom-ARect.Top)-(iHeight)) div 2;
      if (iVertOff>0) then
      begin
        rRect.Left  := ARect.Left;
        rRect.Top   := ARect.Top   +iVertOff;
        rRect.Right := ARect.Right;
        rRect.Bottom:= ARect.Bottom+iVertOff;
      end;
    end;
    //
    iFormat := iFormat-DT_CALCRECT;
    windows.DrawText(Self.Canvas.Handle, PChar(sCaption), Length(sCaption), rRect, iFormat);
  end;

begin
  inherited;
  iDestCount:= Length(FDestinations);
  iWire     := (iDestCount); // zero base remember !
  iCableTy  := Succ(iWire);
  iDraw     := Succ(iCableTy);
  iIsCabled := Succ(iDraw);
  // Titles
  if (ARow = 0) then
  begin
    // Destination Column
    if (iDestCount>0) and (ACol in [Low(FDestinations)..High(FDestinations)]) then
      DrawText(ARect, AState, FDestinations[ACol].sCaption);
    // Wire Column
    if (ACol = iWire) then
      DrawText(ARect, AState, 'Wire Sz'#13'& Colour');
    // Cable Type Column
    if (ACol = iCableTy) then
      DrawText(ARect, AState, 'Cable');
    // Drawing Ref Column
    if (ACol = iDraw) then
      DrawText(ARect, AState, 'Drawing'#13'Pg No');
    // IsCabled
    if (ACol = iIsCabled) then
      DrawText(ARect, AState, 'cbl');
  end;
  // Connections
  if (ARow > 0) then
  begin
    iConn:= ARow;
    if iConn in [Low(FWires)..High(FWires)] then
    begin
      rConn:= FWires[iConn];
      iMid := Floor((ARect.Bottom-ARect.Top)/2);
      if rConn.lIsConnected then
      begin
        // Setup the font
        if gdSelected	in AState then
          Canvas.Font.Color:= clCaptionText
        else
          Canvas.Font.Color:= Self.Font.Color;
        //
        if (ACol = rConn.iColumnSource) or (ACol = rConn.iColumnDest) then
        begin
          // Numbered Earth ?
          if rConn.lIsAnEarth  then
          begin
            Canvas.Brush.Color:= clGreen;
            Canvas.Font .Color:= clYellow;
            Canvas.FillRect(ARect);
          end;
          // Shielded ?
          if rConn.lIsShielded then
          begin
            Canvas.Pen   .Color:= clBlack;
            Canvas.RoundRect(ARect.Left+1, ARect.Top+1, ARect.Right-1, ARect.Bottom-1, 5, 5);
          end;
        end;
        // Colour-in to give appearance of linked cells (Right)
        if (ACol = rConn.iColumnDest) then
        begin
          Canvas.Pen.Color:= rConn.wFuncBGColor;
          Canvas.MoveTo(ARect.Left   , ARect.Top  +iMid-3);
          Canvas.LineTo(ARect.Left   , ARect.Top  +iMid+3);
          Canvas.MoveTo(ARect.Left +1, ARect.Top  +iMid-2);
          Canvas.LineTo(ARect.Left +1, ARect.Top  +iMid+2);
        end;
        // Colour-in to give appearance of linked cells (Left)
        if (ACol = rConn.iColumnSource) then
        begin
          Canvas.Pen.Color:= rConn.wFuncBGColor;
          Canvas.MoveTo(ARect.Right  , ARect.Top  +iMid-3);
          Canvas.LineTo(ARect.Right  , ARect.Top  +iMid+3);
          Canvas.MoveTo(ARect.Right-1, ARect.Top  +iMid-2);
          Canvas.LineTo(ARect.Right-1, ARect.Top  +iMid+2);
        end;
        // Draw wire / terminal no.
        if (ACol = rConn.iColumnSource) or (ACol = rConn.iColumnDest) then
        begin
          DrawText(ARect, AState, rConn.sTerminal);
        end;
        // Draw link across cell
        if (rConn.iColumnSource<>rConn.iColumnDest) and (ACol in [Succ(rConn.iColumnSource)..Pred(rConn.iColumnDest)]) then
        begin
          rLine.Left  := ARect.Left -1;
          rLine.Top   := ARect.Top  +iMid-3;
          rLine.Bottom:= ARect.Top  +iMid+3;
          rLine.Right := ARect.Right+1;
          //
          Canvas.Brush.Color:= rConn.wFuncBGColor; 
          Canvas.Brush.Style:= bsSolid;
          Canvas.Pen  .Color:= clDkGray;
          // Draw Solid
          Canvas.FillRect(rLine);
          Canvas.MoveTo(rLine.Left , rLine.Top);    // top border
          Canvas.LineTo(rLine.Right, rLine.Top);    //  "    "
          Canvas.MoveTo(rLine.Left , rLine.Bottom); // bottom border
          Canvas.LineTo(rLine.Right, rLine.Bottom); //    "     "
          //
          if (rConn.wFuncStripeColor<>clNone) then
          begin
            Canvas.Brush.Color:= rConn.wFuncStripeColor;
            iMidS:= (rLine.Right-rLine.Left) div 2;
            aPts[0]:= Point(rLine.Left+iMidS+8, rLine.Top   );
            aPts[1]:= Point(rLine.Left+iMidS+0, rLine.Bottom);
            aPts[2]:= Point(rLine.Left+iMidS-8, rLine.Bottom);
            aPts[3]:= Point(rLine.Left+iMidS+0, rLine.Top   );
            Canvas.Polygon(aPts);
          end;
        end;
        // Wire Diameter & Colour
        if (ACol = iWire) then
        begin
          if SameText(rConn.sWireDiaDesc, '*Special*') then // ~~~~~~~
            DrawText(ARect, AState, rConn.sWireFunc)
          else
            DrawText(ARect, AState, rConn.sWireDiaDesc+#32+rConn.sWireFunc);
        end;
        // Cable Type
        if (ACol = iCableTy) then
        begin
          aidwlLookups.RenderCableTypeToCanvas(Canvas, ARect, rConn.sCableType, False);
        end;
        // Drawing
        if (ACol = iDraw) then
        begin
          DrawText(ARect, AState, rConn.sDrawingRef);
          // ~~ if there's a not highlight here
        end;
        // IsCabled
        if (ACol = iIsCabled) then
        begin
          if rConn.lIsCabled then
          begin
            Canvas.Font.Name := 'WingDings';
            Canvas.Font.Size := 10;
            Canvas.Font.Style:= [fsBold];
            rSz:= Canvas.TextExtent(CTickChar);

            iX:= ARect.Left+(((ARect.Right -ARect.Left)-rSz.cx) div 2);
            iY:= ARect.Top +(((ARect.Bottom-ARect.Top )-rSz.cy) div 2);
            // Render with drop shadow
            Canvas.Font.Color:= clGrayText  ; Canvas.TextOut(iX+1, iY+1, CTickChar );
            if (gdSelected	in AState) then
              Canvas.Font.Color:= clCaptionText
            else
              Canvas.Font.Color:= clWindowText;
            Canvas.TextOut(iX  , iY  , CTickChar );
          end
          else
          begin
            Canvas.Pen.Color:= clGrayText;
            Canvas.Pen.Style:= psSolid;
            iY:= ARect.Top +((ARect.Bottom-ARect.Top ) div 2);
            Canvas.MoveTo(ARect.Left +3, iY);
            Canvas.LineTo(ARect.Right-3, iY);
          end;
        end;
      end;
    end;
  end;
end;

function TaidwlRunoutGrid.CheckedConnection(AConnection: TaidwlRunoutGridConnection): TaidwlRunoutGridConnection;
var
  iTmpLoc : TInc;
  iTmpCol : Integer;

  function GetColumnForLocation(AiLoc: TInc): Integer;
  var
    iK  : Integer;
    iC  : Integer;
  begin
    Result:= -1;
    iC    :=  0;
    if (Length(FDestinations)>0) then
      for iK:= Low(FDestinations) to High(FDestinations) do
        if (FDestinations[iK].iInc_Loc = AiLoc) then
        begin
          Result:= iC;
          break;
        end
        else
          inc(iC);
  end;

  function SetColorsForWireFunction(AsFunc: String; var wBGColor, wStripeColor, wFGColor: TColor): Boolean;
  var
    rFunc : TaidwlWireFunction;
  begin
    Result:= False;
    wBGColor:= clBlack;
    wFGColor:= clWhite;
    if aidwlLookups.FindWireFunc(AsFunc, rFunc) then
    begin
      wBGColor    := rFunc.wBGColor;
      wStripeColor:= rFunc.wStripeColor;
      wFGColor    := rFunc.wFGColor;
      Result:= True;
    end;
  end;

begin
  Result:= AConnection;
  Result.iColumnSource:= GetColumnForLocation(AConnection.iInc_Source);
  Result.iColumnDest  := GetColumnForLocation(AConnection.iInc_Dest  );
  // Swap to make left to right (if necc.)s
  if (Result.iColumnDest<Result.iColumnSource) then
  begin
    iTmpLoc:= Result.iInc_Dest;
    iTmpCol:= Result.iColumnDest;
    Result.iInc_Dest    := Result.iInc_Source;
    Result.iColumnDest  := Result.iColumnSource;
    Result.iInc_Source  := iTmpLoc;
    Result.iColumnSource:= iTmpCol;
  end;
  SetColorsForWireFunction(AConnection.sWireFunc, Result.wFuncBGColor, Result.wFuncStripeColor, Result.wFuncFGColor);
  // ~ needs to be datadriven or coded into central area !
  Result.lIsShielded  := SameText(AConnection.sWireType, 'Shielded');
  Result.lIsAnEarth   := SameText(AConnection.sWireType, 'Earth');
end;

procedure TaidwlRunoutGrid.SetModified(const Value: Boolean);
var
  iK  : Integer;
begin
  if (FModified <> Value) then
  begin
    FModified := Value;
    if (not FModified) then
    begin
      FDeletes.Clear;
      //
      for iK:= Low(FWires) to High(FWires) do
        FWires[iK].lModified:= False;
    end;
    //
    DoModifiedChanged;
  end;
end;


procedure TaidwlRunoutGrid.DoModifiedChanged;
begin
  if Assigned(FOnModifiedChanged) then
    FOnModifiedChanged(Self);
end;


procedure TaidwlRunoutGrid.RemoveSelectedConnection;
var
  sLog  : string;
begin
  sLog:= '';
  if (Row in [Low(FWires)..High(FWires)]) then
  begin
    FWires[Row].lIsConnected:= False;
    // Add to delete list
    if (FWires[Row].iInc_Runout>0) then
    begin
      sLog:= 'Page: '+IntToStr(PageNo)+' Line: '+IntToStr(Row)+' Wire: '+FWires[Row].sTerminal;
      FDeletes.Add(IntToStr(FWires[Row].iInc_Runout)+'='+sLog);
    end;
    //
    InvalidateRow(Row);
    DoSelectConnection(FWires[Row]);
    //
    Modified:= True;
  end;
end;


procedure TaidwlRunoutGrid.RemoveConnection(AiIndex: Integer);
begin
  if (AiIndex in [Low(FWires)..High(FWires)]) then
  begin
    FWires[AiIndex].lIsConnected:= False;
    // Add to delete list
    if (FWires[AiIndex].iInc_Runout>0) then
      FDeletes.Add(IntToStr(FWires[AiIndex].iInc_Runout));
    //
    InvalidateRow(AiIndex);
    //
    Modified:= True;
  end;
end;



function TaidwlRunoutGrid.GetDeletes: TStrings;
begin
  Result:= FDeletes;
end;

function TaidwlRunoutGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  result:= Inherited SelectCell(ACol, ARow);

  if result then
    if (ARow<>FiLastRow) then
    begin
      if (ARow in [Low(FWires)..High(FWires)]) then
        DoSelectConnection(FWires[ARow]);
      FiLastRow:= ARow;
    end;
end;

procedure TaidwlRunoutGrid.DoSelectConnection(AConnection: TaidwlRunoutGridConnection);
begin
  if Assigned(FOnSelectConnection) then
    FOnSelectConnection(Self, AConnection);
end;

procedure TaidwlRunoutGrid.SetOnSelectConnection(const Value: TaidwlRunoutGridSelectConnectionEvent);
begin
  FOnSelectConnection:= Value;
end;

function TaidwlRunoutGrid.GetWireCount: Integer;
begin
  result:= Length(FWires);
end;


function TaidwlRunoutGrid.GetWire(Index: Integer): TaidwlRunoutGridConnection;
var
  iWire : Integer;
begin
  FillChar(Result, SizeOf(TaidwlRunoutGridConnection), #0);
  iWire:= {Succ}(Index);
  if (iWire in [Low(FWires)..High(FWires)]) then
    Result:= FWires[iWire];
end;


procedure TaidwlRunoutGrid.SetOnModifiedChanged(const Value: TNotifyEvent);
begin
  FOnModifiedChanged := Value;
end;


procedure TaidwlRunoutGrid.SwapLines(const AwSwapFrom, AwSwapTo: Word);
var
  rFrom  : TaidwlRunoutGridConnection;
  rTo    : TaidwlRunoutGridConnection;
begin
  if (AwSwapFrom in [Low(FWires)..High(FWires)]) and
     (AwSwapTo   in [Low(FWires)..High(FWires)]) then
  begin
    rFrom:= FWires[AwSwapFrom];
    rTo  := FWires[AwSwapTo  ];

    // Store the row identifier, as this is an update
    Fwires[AwSwapFrom]:= rTo;
    Fwires[AwSwapFrom].lModified   := True;
    Fwires[AwSwapTo  ]:= rFrom;
    Fwires[AwSwapTo  ].lModified   := True;
    //
    InvalidateRow(AwSwapFrom);  // [0] is title, Line numbers start at 1
    InvalidateRow(AwSwapTo);    // [0] is title, Line numbers start at 1
    Modified:= True;
    //
    Row:= AwSwapTo;
  end;
end;


function TaidwlRunoutGrid.CurrentRowIsConnected: Boolean;
begin
  Result:= False;
  if (Row in [Low(FWires)..High(FWires)]) then
  begin
    Result:= FWires[Row].lIsConnected;
  end;
end;


function TaidwlRunoutGrid.CurrentRowDrawingRef: string;
begin
  Result:= '';
  if (Row in [Low(FWires)..High(FWires)]) then
  begin
    Result:= FWires[Row].sDrawingRef;
  end;
end;

procedure TaidwlRunoutGrid.SetPageNo(const Value: Integer);
begin
  FPageNo := Value;
end;

end.
