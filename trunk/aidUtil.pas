unit aidUtil;

{ --------------------------------------------------------------------------------------------------
  Name        : aidUtil
  Description : Atlas Global non db-aware utilities
  See Also    : aidTypes.pas
  modified    :
    CGR20031215, Added FormatDecimalisedCurrency function
    CGR20061108, Added procedure DrawStockMovementDirection() for showing stock movement direction.
    CGR20070117, Added code to render a Bin Type icon. 
  --------------------------------------------------------------------------------------------------}
interface

uses
  { Delphi Units }
  Windows, Messages, Graphics, Forms, ShellAPI,
  Grids, dbGrids, ShlObj, ActiveX, SysUtils, Controls,
  { Application Units }
  crTypes, aidTypes, uRegistryEntries_boms;

const
  WM_ICONTRAY = WM_USER + 122;

Type
  TAidFoundEvent = procedure(Path:String; FileFound:TSearchRec) of object;

Type
  TFileAttributes = Set of (faSystem, faHidden, faReadOnly, faArchive);

Type
  TAidFileFinder = Class(TObject)
   private
     FFromPath : String;
     FWildCard : String;
     FOnFound   : TAidFoundEvent;
     Procedure  RecursiveFind(StartPath : String);
   public
     Constructor Create;
     Destructor Destroy; Override;
     Procedure Find;
     property Path : String read FFromPath write FFromPath;
     property OnFind: TAidFoundEvent read FOnFound write FOnFound;
     Property WildCard : String read FWildCard Write FWildCard;
  end;

{ Validation }
function LooksLikeAContractNo(const AsJobNo: String): Boolean;

{ Exception shortcuts }
Procedure RaiseRoutineInvalidArguments(AsRoutineName: String);

{ Environment }
procedure SaveFormPosition( vForm : TForm; vUseRegistry : Boolean = True );
procedure LoadFormPosition( vForm : TForm; vUseRegistry : Boolean = True );
function  CheckRunningAlready : Boolean;
function  GetBitFromContentType( vsContentType : String ) : Integer;
function  GetContentTypeHintFromDocTypes( viDocTypes : Integer ) : String;
procedure SetDocColors( var vaColors : TcrColors; viColorSetting : Integer );

procedure DrawProcureStateCell(AGrid: TdbGrid; AState: TGridDrawState; ARect: TRect; AsReqnState, AsActdState, AsRcvdState: String; AlExcluded: Boolean = False; AlEmpty: Boolean = False; AlCompound: Boolean = False);
procedure DrawContractStatus  (AoCanvas: TCanvas; ArRect: TRect; AsContractStatus: String);
procedure DrawContractBomType (AoCanvas: TCanvas; ArRect: TRect; AsContractBomType: String; AbDrawDesc: Boolean = False);
function  hintContractBomType(AsContractBomType: String) : string;

procedure DrawChangeOrderAction(AoCanvas: TCanvas; ArRect: TRect; AeChangeOrderAction: TaidChangeOrderAction);
procedure DrawChangeOrderPriority(AoCanvas: TCanvas; ArRect: TRect; AiPriority: Integer);
procedure DrawChangeOrderOriginContext(AoCanvas: TCanvas; ArRect: TRect; AeChangeOrderOriginContext: TaidChangeOrderSource);

{ DrawStockMovementDirection
    Draws an icon for- a stock movement datagrid cell. }
procedure DrawStockMovementDirection(AoCanvas: TCanvas; ArRect: TRect; AcDirection: Char; AbDrawDesc: Boolean = False);
{ DrawBinTypeAsIcon
    Renders a summarised cell denoting a BinType. }
procedure DrawBinTypeAsIcon(AoCanvas: TCanvas; const ArRect: TRect; AsBinType: String); overload;
{ DrawBinTypeAsIcon
    Renders a summarised cell denoting a BinType. }
procedure DrawBinTypeAsIcon(AoCanvas: TCanvas; const ArRect: TRect; AeBinType: TBinType); overload;

procedure DrawDrillDownCell(const ACanvas : TCanvas;const ARect : TRect);
function  udf_CreateKeywords( vsArg : String ): String;
FUNCTION  udf_Seps_AsString : string; 
function  RemoveLike( vsQuery : String ) : Boolean;
function  RemoveLikeFirst( vsQuery : String ) : Boolean;
{ FormatCommodityCode
    Formats the 8 digit ICN / Commodity Code / Combined Nomenclature number to display / human readible format }
function  FormatCommodityCode(AsText: String; codetype : string): String;
{ FormatDecimalisedCurrency
    Returns an integerish value formatted to AiDecimalPlaces. Designed for use in the
    Field.OnGetText events. }
function  FormatDecimalisedCurrency(AsCurrency: String; AnCurrencyValue: Currency; AiDecimalPlaces: Byte = 2; AlDisplayText: Boolean = False): string;
function  GetBomsBuildInfo: string;   {AGWM20040315}
function  UpDateShortCut_Lnk( MyHandle : hWnd; LinkNameStr : String; const OldPathStr, NewPathStr : String) : HResult;  {AGWM 20041108}
Function  FileNameHasExtension(AsFileName, AsExtList: String): Boolean; {CGR 20050914}
function  AppRegistrySection(): string;

function  ApplicationTargetBySite(Site : TSiteNo): TApplicationAudience;
function  ApplicationTarget: TApplicationAudience;  { CGR20060403, Added to distingush between Atlas & Apollo }
{ RecurseControlEnabledState
    Recurses a control & child controls setting the enabled property to the value in AbEnabledState.}
procedure RecurseControlEnabledState(AControl: TWinControl; AbEnabledState : Boolean);

var
  gTrayIconData: TNotifyIconData;
const
  C_udf_Seps : set of Char = [#0..#$1F, ' ', '.', ',', '?', ':', ';', '(', ')', '/', '\', '&', '-', '[', ']', ''''];
const
  ProcureEmptyState = ' ';

implementation

uses
  { Delphi Units }
  IniFiles, Types, Dialogs, Registry, Math, StrUtils,
  { Application Units }
  aidLang, crUtil, u_tbomkernel;

const
  CIniForm                = 'Form';
  CIniWindowTop           = 'Top';
  CIniWindowLeft          = 'Left';
  CIniWindowBottom        = 'Bottom';
  CIniWindowRight         = 'Right';
  CIniWindowMaximized     = 'Maximized';
  CIniWindowHasBeenStored = 'HasBeenStored';

resourcestring
  rsDesignedFor800x600 = 'This application was designed to'+#13+
                         'be run at a screen resolution of'+#13+
                         '800 * 600. Please increase your'+#13+
                         'screen resolution. Contact support'+#13+
                         'if you are unsure of how to do this';

var
  sRegSection : string;

function udf_Seps_AsString : string;
begin
  result := ', . ? : ; ( ) / \ & - [ ] " '''' and Space and tab';
end;

procedure SaveFormPosition( vForm : TForm; vUseRegistry : Boolean = True );
var
  loIni    : TIniFile;
  loRegIni : TRegIniFile;
  lsApp    : string;
begin
  if vUseRegistry then
  begin
    // Get Application Name and change the extension to ini
    lsApp := ExtractFileName( Application.ExeName );
    lsApp := ChangeFileExt( lsApp, '' );
    lsApp := 'Software\Valmet\BOM\' + lsApp;

    //Create Registry
    loRegIni := TRegIniFile.Create( lsApp );
    try
      if ( TForm( vForm ).WindowState in [wsNormal, wsMaximized] ) then
      begin
        with TForm( vForm ) do
        begin
          if WindowState = wsNormal then
          begin
            loRegIni.WriteInteger( ClassName + CIniForm, CIniWindowTop   , Top);
            loRegIni.WriteInteger( ClassName + CIniForm, CIniWindowLeft  , Left);
            loRegIni.WriteInteger( ClassName + CIniForm, CIniWindowBottom, Top+Height);
            loRegIni.WriteInteger( ClassName + CIniForm, CIniWindowRight , Left+Width);
          end; //if
          loRegIni.WriteBool( ClassName + CIniForm, CIniWindowMaximized    , WindowState=wsMaximized);
          loRegIni.WriteBool( ClassName + CIniForm, CIniWindowHasBeenStored, True);
        end;  //with
      end; //if
    finally
      loRegIni.Free;
    end;
  end // if vUseRegistry then
  else
  begin
    // Get Application Name and change the extension to ini
    lsApp := ExpandFileName( Application.ExeName );
    lsApp := ChangeFileExt( lsApp, '.ini' );
    //Create Ini file
    loIni := TIniFile.Create( lsApp );

    try
      if ( TForm( vForm ).WindowState in [wsNormal, wsMaximized] ) then
      begin
        with TForm( vForm ) do
        begin
          if WindowState = wsNormal then
          begin
            loIni.WriteInteger( ClassName + CIniForm, CIniWindowTop   , Top);
            loIni.WriteInteger( ClassName + CIniForm, CIniWindowLeft  , Left);
            loIni.WriteInteger( ClassName + CIniForm, CIniWindowBottom, Top+Height);
            loIni.WriteInteger( ClassName + CIniForm, CIniWindowRight , Left+Width);
          end; //if
          loIni.WriteBool( ClassName + CIniForm, CIniWindowMaximized    , WindowState=wsMaximized);
          loIni.WriteBool( ClassName + CIniForm, CIniWindowHasBeenStored, True);
        end;  //with
      end; //if
    finally
      loIni.Free;
    end;
  end; // else if vUseRegistry then
end;

procedure LoadFormPosition( vForm : TForm; vUseRegistry : Boolean = True );
var
  loIni    : TIniFile;
  loRegIni : TRegIniFile;
  lsApp    : string;
  lrBnd    : TRect;
  liHt     : Integer;
  liWd     : Integer;
  liLf     : Integer;
  liTp     : Integer;
  llMax,
  llHasBeen: Boolean;
begin
  if vUseRegistry then
  begin
    // Get Application Name and change the extension to ini
    lsApp := ExtractFileName( Application.ExeName );
    lsApp := ChangeFileExt( lsApp, '' );
    lsApp := 'Software\Valmet\BOM\' + lsApp;

    //Create Registry
    loRegIni := TRegIniFile.Create( lsApp );
    try
      with TForm( vForm ) do
      begin
        // Defaults (works on Primary Monitor, attempts 800 * 600, but considers taskbars )
        liHt := MinMaxInt(480, 600, Screen.WorkAreaHeight);
        liWd := MinMaxInt(640, 800, Screen.WorkAreaWidth );
        liLf := Screen.WorkAreaLeft+((Screen.WorkAreaWidth -liWd) div 2);
        liTp := Screen.WorkAreaTop +((Screen.WorkAreaHeight-liHt) div 2);
        //
        lrBnd.Left  := loRegIni.ReadInteger( ClassName + CIniForm, CIniWindowLeft         , liLf);
        lrBnd.Top   := loRegIni.ReadInteger( ClassName + CIniForm, CIniWindowTop          , liTp);
        lrBnd.Right := loRegIni.ReadInteger( ClassName + CIniForm, CIniWindowRight        , liLf+liWd);
        lrBnd.Bottom:= loRegIni.ReadInteger( ClassName + CIniForm, CIniWindowBottom       , liTp+liHt);
        llMax       := loRegIni.ReadBool   ( ClassName + CIniForm, CIniWindowMaximized    , False);
        llHasBeen   := loRegIni.ReadBool   ( ClassName + CIniForm, CIniWindowHasBeenStored, False);
        //
        if llMax then
        begin
          WindowState:= wsMaximized;
        end  // if
        else
        begin
          SetBounds(lrBnd.Left, lrBnd.Top, lrBnd.Right-lrBnd.Left, lrBnd.Bottom-lrBnd.Top);
        end; // else
        // Check if we have ever stored preferences before - if not, force
        if not llHasBeen then
        begin
          if (Screen.Width<800) or (Screen.Height<600) then
          begin
            MessageDlg(rsDesignedFor800x600, mtWarning, [mbOk], 0);
          end  // if
          else
          begin
            if (Screen.Width=800) and (Screen.Height=600) then
            begin
              WindowState:= wsMaximized;
            end; // if
          end; // else
        end; //if
      end; //with
    finally
      loRegIni.Free;
    end;
  end // if vUseRegistry then
  else
  begin
    // Get Application Name and change the extension to ini
    lsApp := ExpandFileName( Application.ExeName );
    lsApp := ChangeFileExt( lsApp, '.ini' );
    //Create Ini file
    loIni := TIniFile.Create( lsApp );
    try
      with TForm( vForm ) do
      begin
        // Defaults (works on Primary Monitor, attempts 800 * 600, but considers taskbars )
        liHt := MinMaxInt(480, 600, Screen.WorkAreaHeight);
        liWd := MinMaxInt(640, 800, Screen.WorkAreaWidth );
        liLf := Screen.WorkAreaLeft+((Screen.WorkAreaWidth -liWd) div 2);
        liTp := Screen.WorkAreaTop +((Screen.WorkAreaHeight-liHt) div 2);
        //
        lrBnd.Left  := loIni.ReadInteger( ClassName + CIniForm, CIniWindowLeft         , liLf);
        lrBnd.Top   := loIni.ReadInteger( ClassName + CIniForm, CIniWindowTop          , liTp);
        lrBnd.Right := loIni.ReadInteger( ClassName + CIniForm, CIniWindowRight        , liLf+liWd);
        lrBnd.Bottom:= loIni.ReadInteger( ClassName + CIniForm, CIniWindowBottom       , liTp+liHt);
        llMax       := loIni.ReadBool   ( ClassName + CIniForm, CIniWindowMaximized    , False);
        llHasBeen   := loIni.ReadBool   ( ClassName + CIniForm, CIniWindowHasBeenStored, False);
        //
        if llMax then
        begin
          WindowState:= wsMaximized;
        end  // if
        else
        begin
          SetBounds(lrBnd.Left, lrBnd.Top, lrBnd.Right-lrBnd.Left, lrBnd.Bottom-lrBnd.Top);
        end; // else
        // Check if we have ever stored preferences before - if not, force
        if not llHasBeen then
        begin
          if (Screen.Width<800) or (Screen.Height<600) then
          begin
            MessageDlg(rsDesignedFor800x600, mtWarning, [mbOk], 0);
          end  // if
          else
          begin
            if (Screen.Width=800) and (Screen.Height=600) then
            begin
              WindowState:= wsMaximized;
            end; // if
          end; // else
        end; //if
      end; //with
    finally
      loIni.Free;
    end;
  end; // else if vUseRegistry then
end;

function CheckRunningAlready : Boolean;

var
  lsAppName     : String;
  lacAppName    : array[0..MAX_PATH+1] of char;
  lsOrigAppName : String;
  lhAppMutex    : THandle;
  lhOrigApp     : THandle;
begin
  Result := False;
  lsAppName := ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
  StrPCopy( lacAppName, lsAppName );
  lhAppMutex := CreateMutex( nil, True, lacAppName );

  with gTrayIconData do
  begin
    cbSize := SizeOf( gTrayIconData );
    Wnd := Application.Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon := Application.Icon.Handle;
    StrPCopy( szTip, Application.Title );
  end;

  if lhAppMutex <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle( lhAppMutex );
      Result := True;
      lsOrigAppName := Application.Title;
      SetWindowText( Application.Handle, 'Another window name' );
      lhOrigApp := FindWindow( nil, PChar( lsOrigAppName ) );

      if ( lhOrigApp <> 0 ) and IsWindow( lhOrigApp ) then
    	begin
    	// Bring to front or maximize, as needed.
        if IsIconic( lhOrigApp ) then
        begin
          ShowWindow( lhOrigApp, SW_RESTORE );
          ShowWindow( lhOrigApp, SW_SHOW );
        end
        else if IsWindowVisible( lhOrigApp ) then
        begin
        	//BringWindowToTop(hwnd);
          SetForegroundWindow( lhOrigApp );
          ShowWindow( lhOrigApp, SW_SHOW );
        end
        else
        begin
          SetWindowText( Application.Handle, PChar( lsOrigAppName ) );
          MessageDlg( lsOrigAppName + ' is already in the System Tray,' + #10#13 + 'Please right click on it to reactivate the program.',
                      mtInformation, [mbOk], 0 );
        end;
      end;
    end;
  end; 
end;

function GetBitFromContentType( vsContentType : String ) : Integer;
begin
  case StringToChar( vsContentType ) of
    'D' : Result:= 0;
    'S' : Result:= 1;
    'I' : Result:= 3;
    'T' : Result:= 3;
    'M' : Result:= 2;
    'C' : Result:= 4;
  else
    Result := -1;
  end;
end;

function GetContentTypeHintFromDocTypes( viDocTypes : Integer ) : String;
var
  lbFound : Boolean;
begin
  Result := '';
  lbFound := False;
  if crUtil .IsBitSet( viDocTypes, 0 ) then
  begin
    Result := Result + FindDocContentType( 'D' );
    lbFound := True;
  end;
  if crUtil .IsBitSet( viDocTypes, 1 ) then
  begin
    if lbFound then
    begin
      Result := Result + #13;
    end;
    Result := Result + FindDocContentType( 'S' );
    lbFound := True;
  end;
  if crUtil .IsBitSet( viDocTypes, 2 ) then
  begin
    if lbFound then
    begin
      Result := Result + #13;
    end;
    Result := Result + FindDocContentType( 'M' );
    lbFound := True;
  end;
  if crUtil .IsBitSet( viDocTypes, 4 ) then
  begin
    if lbFound then
    begin
      Result := Result + #13;
    end;
    Result := Result + FindDocContentType( 'C' );
    lbFound := True;
  end;
  if crUtil .IsBitSet( viDocTypes, 3 ) then
  begin
    if lbFound then
    begin
      Result := Result + #13;
    end;
    Result := Result + FindDocContentType( '', 'Other' );
//    lbFound := True;
  end;
end;


procedure SetDocColors( var vaColors : TcrColors; viColorSetting : Integer );
const ciColors = 4;
      caColors : array[0..ciColors] of TColor = ( clOlive, clPurple, clNavy, clTeal, clRed );
var
  liCount,
  liArrPos : Integer;

begin
  SetLength( vaColors, ciColors + 1 );
  for liCount := Low(vaColors) to High(vaColors) do
  begin
    vaColors[ liCount ] := clBlack;
  end;
  //
  liArrPos := Low(vaColors);
  for liCount := High( caColors) downto Low(vaColors) do
  begin
    if crUtil .IsBitSet( viColorSetting, liCount ) and (liCount<=High(vaColors)) then
    begin
      vaColors[ liArrPos ] := caColors[ liCount ];
      Inc( liArrPos );
    end;
  end;
end;



{ DrawProcureStateCell
    Paints procurement statuses against Contract Items, Sections, etc. }
procedure DrawProcureStateCell(AGrid: TdbGrid; AState: TGridDrawState; ARect: TRect; AsReqnState, AsActdState, AsRcvdState: String; AlExcluded: Boolean = False; AlEmpty: Boolean = False; AlCompound: Boolean = False);
var
  iReqnColor,
  iActdColor,
  iRcvdColor  : TColor;
  iW, iX, iY  : Integer;
begin
  // Fill background
  AGrid.Canvas.Rectangle(ARect);
  // Requisition State
  if AsReqnState = 'P' then iReqnColor:= clLime else
    if AsReqnState = 'F' then iReqnColor:= clGreen else
      if (AsReqnState = 'N') then iReqnColor:= clSilver else
        iReqnColor:= AGrid.Canvas.Brush.Color;
  // Actioned State
  if AsActdState = 'P' then iActdColor:= clYellow else
    if AsActdState = 'F' then iActdColor:= clOlive else
      if (AsActdState = 'N') then iActdColor:= clSilver else
        iActdColor:= AGrid.Canvas.Brush.Color;
  // Received State
  if AsRcvdState = 'P' then iRcvdColor:= clRed else
    if AsRcvdState = 'F' then iRcvdColor:= clMaroon else
      if (AsRcvdState = 'N') then iRcvdColor:= clSilver else
        iRcvdColor:= AGrid.Canvas.Brush.Color;
  // Draw
  iW:= (ARect.Right-ARect.Left) div 3;
  AGrid.Canvas.Pen  .Color:= AGrid.Canvas.Brush.Color;//clWindow;
  // left
  AGrid.Canvas.Brush.Color:= iReqnColor;
  AGrid.Canvas.Rectangle(ARect.Left    , ARect.Top, ARect.Left +iW, ARect.Bottom);
  // right
  AGrid.Canvas.Brush.Color:= iRcvdColor;
  AGrid.Canvas.Rectangle(ARect.Right-iW, ARect.Top, ARect.Right   , ARect.Bottom);
  // middle
  AGrid.Canvas.Brush.Color:= iActdColor;
  AGrid.Canvas.Rectangle(ARect.Left +iW, ARect.Top, ARect.Right-iW, ARect.Bottom);
  // Pen color for line drawing
  if (gdSelected in AState) then
    if (AGrid.Focused) then
      AGrid.Canvas.Pen.Color:= clHighlightText
    else
      AGrid.Canvas.Pen.Color:= clInactiveCaptionText
  else
    AGrid.Canvas.Pen.Color:= AGrid.Font.Color;
  // Excluded, draw a diagonal cross
  if (AlExcluded) then
  begin
    AGrid.Canvas.Pen.Style:= psSolid;
    AGrid.Canvas.MoveTo(ARect.Left +2, ARect.Top   +2);
    AGrid.Canvas.LineTo(ARect.Right-2, ARect.Bottom-2);
    AGrid.Canvas.MoveTo(ARect.Right-2, ARect.Top   +2);
    AGrid.Canvas.LineTo(ARect.Left +2, ARect.Bottom-2);
  end;
  // Empty contents
  if (AlEmpty) then
  begin
    AGrid.Canvas.Pen.Style:= psSolid;
    iY:=  ARect.Top   + ((ARect.Bottom-ARect.Top) div 2);
    iW:= (ARect.Right -   ARect.Left) div 2;
    AGrid.Canvas.MoveTo(ARect.Left +iW div 2, iY);
    AGrid.Canvas.LineTo(ARect.Right-iW div 2, iY);
  end;
  { Compound / PBOM draw a horizontal/vertical cross }
  if (AlCompound) then
  begin
    iW:= ARect.Bottom-ARect.Top-4;
    iY:= ARect.Top  + ((ARect.Bottom-ARect.Top -iW) div 2);
    iX:= ARect.Left + ((ARect.Right -ARect.Left-iW) div 2);
    //
    AGrid.Canvas.Pen.Style:= psSolid;
    AGrid.Canvas.MoveTo(iX+iW div 2, iY);
    AGrid.Canvas.LineTo(iX+iW div 2, iY+iW);
    AGrid.Canvas.MoveTo(iX   , iY+iW div 2);
    AGrid.Canvas.LineTo(iX+iW, iY+iW div 2);
  end;
end;


procedure DrawDrillDownCell(const ACanvas : TCanvas;const ARect : TRect);
const
  MARGIN = 4;
var
  PenColour   : TColor;
  PenWidth    : Integer;
  PenStyle    : TPenStyle;
  BrushColour : TColor;
  RectHeight  : Integer;
  ThisRect    : TRect;
  CentrePoint : TPoint;
begin
  with ACanvas do begin
    {Save Colours and Stuff}
    PenColour       := Pen.Color;
    PenWidth        := Pen.Width;
    PenStyle        := Pen.Style;
    BrushColour     := Brush.Color;
    Brush.Color     := clBtnFace;
    {Create a Rectangle to Bound the Drawing}
    RectHeight      := ARect.Bottom - ARect.Top;
    if RectHeight mod 2 = 0 then
      Dec(RectHeight); {odd numbers are easier to get centrepoint}
    ThisRect.Top    := ARect.Top;
    ThisRect.Bottom := ARect.Top   + RectHeight;
    ThisRect.Right  := ARect.Right;
    ThisRect.Left   := ARect.Right - RectHeight;
    {Get Some Useful Values}
    CentrePoint.X   := ThisRect.Left  + Trunc(RectHeight/2);
    CentrePoint.Y   := ThisRect.Top   + Trunc(RectHeight/2);
    {Start Drawing}
    try
      FillRect(ThisRect);
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      Rectangle(ThisRect);
      {Highlight}
      Pen.Color := clBtnHighlight;
      MoveTo(ThisRect.Left  + 1 , ThisRect.Bottom - 2);
      LineTo(ThisRect.Left  + 1 , ThisRect.Top    + 1);
      LineTo(ThisRect.Right - 2 , ThisRect.Top    + 1);
      {Lowlight}
      Pen.Color := clBtnShadow;
      LineTo(ThisRect.Right - 2, ThisRect.Bottom - 2);
      LineTo(ThisRect.Left  + 1, ThisRect.Bottom - 2);
      {Add the '+' in Highlight offset by 1 pixel}
      Pen.Color := clWhite;
      Pen.Width := 1;
      MoveTo(CentrePoint.X  + 1  , ThisRect.Top     + MARGIN);
      LineTo(CentrePoint.X  + 1  , ThisRect.Bottom  - MARGIN);
      MoveTo(ThisRect.Left  + MARGIN, CentrePoint.Y + 1     );
      LineTo(ThisRect.Right - MARGIN, CentrePoint.Y + 1     );
      {Add the '+' in Lowlight}
      Pen.Color := clBlack;
      MoveTo(CentrePoint.X       , ThisRect.Top     + MARGIN);
      LineTo(CentrePoint.X       , ThisRect.Bottom  - MARGIN);
      MoveTo(ThisRect.Left  + MARGIN, CentrePoint.Y         );
      LineTo(ThisRect.Right - MARGIN, CentrePoint.Y         );
    finally
      {restore any values}
      Pen.Width   := PenWidth;
      Pen.Style   := PenStyle;
      Pen.Color   := PenColour;
      Brush.Color := BrushColour;
    end
  end
end;

function udf_CreateKeywords( vsArg : String ): String;
const
  CDelim = '~';
var
  sArg  : string;
  sRes,
  sWord : string;
  cPre,
  cNow,
  cNext : Char;
  iX    : Integer;
  lBrk  : Boolean;

  procedure CheckStoreWord;
  begin
    if (Length(sWord)>0) then
    begin
      if Length(sWord)>1 then
        if (Pos(sWord+CDelim, sRes)<=0) and (Copy(sRes, Length(sRes) - Length(sWord) + 1, Length(sWord))<>sWord) then // Ensure no word duplication
        begin
          if Length(sRes)>0 then sRes:= sRes+CDelim;
          sRes:= sRes+sWord;
        end;
      //
      sWord:= '';
    end;
  end;

  procedure TransformSymbol(var AsArg: string; AsNow, AsTo: string; AlLeadingDigit: Boolean = False; AlTrailingDigit: Boolean = False; AlRemoveLeadingSpace: Boolean = False);
  var
    iK      : Integer;
    sCut    : string;
    cLeft,
    cRight  : Char;
  begin
    iK:= Pos(AsNow, AsArg);
    while (iK>0) and (iK+Length(AsNow)<=Length(AsArg)+1) do
    begin
      sCut:= Copy(AsArg, iK, Length(AsNow));
      if (sCut=AsNow) then
      begin
        cLeft := #0; if iK>1                           then cLeft := AsArg[iK-1];
        cRight:= #0; if iK+Length(AsNow)<Length(AsArg) then cRight:= AsArg[iK+Length(AsNow)];
        if ((cLeft  in C_udf_Seps) or ((AlLeadingDigit) and (cLeft  in ['0'..'9']))) and
           ((cRight in C_udf_Seps) or ((AlLeadingDigit) and (cRight in ['0'..'9']))) then
        begin
          Delete(AsArg, iK, Length(AsNow));
          Insert(AsTo, AsArg, iK);
          if AlRemoveLeadingSpace and (cLeft = #32) then
          begin
            dec(iK);
            Delete(AsArg, iK, 1);
          end;
          inc(iK, Length(AsTo));
        end
        else
          inc(iK, Length(AsNow));
      end
      else
        inc(iK);
    end;
  end;

begin
  sArg  := UpperCase( vsArg );
  sWord := '';
  sRes  := '';
  // Preprocess to transform LH, RH, measures, etc
  TransformSymbol (sArg, 'L.H',  'LH');
  TransformSymbol (sArg, 'R.H',  'RH');
  TransformSymbol (sArg, 'O/D',  'OD', True, False, True);
  TransformSymbol (sArg, 'I/D',  'ID', True, False, True);
  TransformSymbol (sArg, 'MM' ,  'MM', True, False, True);
  TransformSymbol (sArg, 'M'  ,  'M', True, False, True);
  TransformSymbol (sArg, 'CM' ,  'CM', True, False, True);
  TransformSymbol (sArg, 'LG' ,  'LG', True, False, True);
  TransformSymbol (sArg, 'KVA',  'KVA', True, False, True);
  // Process string char by char
  iX:= 1;
  while iX <= Length(sArg) do
  begin
    while (iX <= Length(sArg)) and (sArg[iX] in C_udf_Seps) do
      Inc(iX);
    if iX <= Length(sArg) then
    begin
      while (iX <= Length(sArg)) do
      begin
        cPre := #0; if (iX>1) then cPre:= sArg[iX-1];
        cNow := sArg[iX];
        cNext:= #0; if (iX<Length(sArg)) then cNext:= sArg[iX+1];
        lBrk := cNow in C_udf_Seps;
        // Ignore some valid separators, eg numbers
        if (lBrk) then
          if (cNow in ['.', ',', '/']) and (cPre in ['0'..'9']) and (cNext in ['0'..'9']) then
            lBrk:= False
          else
            if (cNow in ['-']) and (cNext in ['0'..'9']) then
              lBrk:= False;
        //
        if lBrk then Break;
        sWord:= sWord+sArg[iX];
        Inc(iX);
      end;
    end;
    CheckStoreWord;
  end;
  CheckStoreWord;
  //
  Result := sRes;
end;

function RemoveLike( vsQuery : String ) : Boolean;
var
  lsQuery : String;
begin
  lsQuery := Trim( vsQuery );
  lsQuery := StringReplace( lsQuery, '_', '', [rfReplaceAll] );
  lsQuery := StringReplace( lsQuery, '%', '', [rfReplaceAll] );
  lsQuery := StringReplace( lsQuery, '^', '', [rfReplaceAll] );
  lsQuery := StringReplace( lsQuery, '[', '', [rfReplaceAll] );
  lsQuery := StringReplace( lsQuery, ']', '', [rfReplaceAll] );
  lsQuery := StringReplace( lsQuery, '&', '', [rfReplaceAll] );
  lsQuery := Trim( lsQuery );
  Result := Length( lsQuery ) > 0;
end;

function RemoveLikeFirst( vsQuery : String ) : Boolean;
var
  lsQuery : String;
begin
  Result := False;
  lsQuery := Trim( vsQuery );
  if Length( lsQuery ) > 0 then
  begin
    Result := not ( ( lsQuery[1] = '_' ) or ( lsQuery[1] = '%' ) or ( lsQuery[1] = '&' ) );
  end;
end;


function  FormatCommodityCode(AsText: String;codetype : string): String;
begin
  Result:= '';
  if not IsEmptyStr(AsText) then
    if not SameText(AsText, Replicate('0', Length(AsText))) then
  begin
    if codetype = 'HSTARI' then //should be HTS tarif
    begin
        //USA format  of like 0000.00.0000 - 10 characters.
        if crUtil .IsDigits(AsText,true) then // weak validation
          Result:= LeftStr(AsText, 4)
                + '.'
                +SubStr (AsText, 5, 2)
                + '.'
                +SubStr (AsText, 7, Length(AsText)-6)
        else
          Result:= asText;
    end
    else
    begin
        //default is ICN code system of Europe 8 characters long
        if crUtil .IsDigits(AsText,true) then // weak validation
          Result:= LeftStr(AsText, 4)+' '+SubStr (AsText, 5, 2)+' '+SubStr(AsText, 7, Length(AsText)-6)
        else
          Result:= asText;
    end;
  end;
end;

{ GetFormattedDecimalisedCurrency
    Returns an integerish value formatted to AiDecimalPlaces. Designed for use in the
    Field.OnGetText events. }
function FormatDecimalisedCurrency(AsCurrency: String; AnCurrencyValue: Currency; AiDecimalPlaces: Byte = 2; AlDisplayText: Boolean = False): string;
var
  lHome : Boolean;
  iDiv  : Extended;
  nVal  : Currency;
  sFmt  : string;
begin
  Result:= '';
  lHome := SameText('GBP', Trim(AsCurrency));
  nVal  := AnCurrencyValue;
  if lHome then
    iDiv:= 100
  else
    iDiv:= Power(10, AiDecimalPlaces);
  if iDiv<>0 then
    nVal:= nVal/iDiv;
  if AlDisplayText then
    sFmt:= ',0.'+ replicate('0', AiDecimalPlaces)
  else
    sFmt:=  '0.'+ replicate('0', AiDecimalPlaces);
  //
  Result:= FormatFloat(sFmt, nVal);
end;

{
  GetBomsBuildInfo
     Returns imbedded version information
}
function   GetBomsBuildInfo: string;   {AGWM20040315}
  procedure  GetBuild(var w1, w2, w3, w4: word);
  {$IFDEF WIN32}
  var
     VerInfoSize : DWORD;
     VerInfo     : Pointer;
     VerValueSize: DWORD;
     VerValue    : PVSFixedFileInfo;
     Dummy       : DWORD;
  {$ENDIF}
  begin
     w1:= 0; w2:= 0; w3:=0; w4:= 0;
     {$IFDEF WIN32}
     VerInfoSize:= GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
     if (VerInfoSize>0) then
     begin
      GetMem(VerInfo, VerInfoSize);
      GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
      if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
      with VerValue^ do
      begin
        w1:= dwFileVersionMS shr 16;
        w2:= dwFileVersionMS and $FFFF;
        w3:= dwFileVersionLS shr 16;
        w4:= dwFileVersionLS and $FFFF;
      end;
      FreeMem(VerInfo, VerInfoSize);
     {$ELSE}
      w1:= 0; w2:= 0; w3:=0; w4:= 0;
     {$ENDIF}
    end;
  end;
var
  w1, w2,
  w3, w4   : Word;
begin
  GetBuild (w1, w2, w3, w4);
  Result:= Format('%d.%d.%d.%d', [w1, w2, w3, w4]);
end;

function UpDateShortCut_Lnk( MyHandle : hWnd; LinkNameStr : String; const OldPathStr, NewPathStr : String) : HResult;
Var
    psl : IShellLink;
    ppf : IPersistFile;
    HRes : HRESULT;
    szGotPath : PChar;
    WFD : WIN32_FIND_DATA;
    wsz : PWideChar; {Max_Path}
    LinkName, ActualName: array[0..Max_Path] of AnsiChar;
    lpszPathObj : array[0..Max_Path] of AnsiChar;
    S1 : String;
    lbSave : Boolean;

  procedure HandleErr(HRes:HResult);
  begin
  end;

begin
  ActualName[0]:=#0;
  StrPCopy( LinkName, LinkNameStr );
  GetMem( Wsz, Max_Path * 2 );
  GetMem( szGotPath, MAX_PATH );
  {
  CoInitialize(Nil);
  }
  Hres := CoCreateInstance( CLSID_ShellLink,
                            Nil,
                            CLSCTX_INPROC_SERVER,
                            IID_IShellLinkA,
                            psl);
  if ( SUCCEEDED( Hres ) ) then
  begin
    Hres:=psl.QueryInterface(IPersistFile,ppf);
    if (SUCCEEDED(Hres)) then
    begin
      MultiByteToWideChar(CP_ACP,
                          0,
                          LinkName,
                          -1,
                           wsz,
                          MAX_PATH);
      Hres := ppf.Load( wsz, STGM_READ );
      lbSave := False;
      if ( SUCCEEDED( Hres ) ) then
      begin
        Hres := psl.GetPath( szGotPath,
                             MAX_PATH,
                             wfd,
                             {SLGP_SHORTPATH}
                             SLGP_RAWPATH );
        if ( NOT SUCCEEDED( Hres ) ) then
            HandleErr( Hres );
        S1 := szGotPath;
        S1 := UpperCase( S1 );
        if S1 = UpperCase( OldPathStr ) then
        begin
          StrPCopy( lpszPathObj, NewPathStr );
          psl.SetPath( lpszPathObj );
          lbSave := True;
        end;
      end;
      if lbSave then
      begin
        Hres := ppf.Save( wsz, True );
      end;
    end;
  end;
  {
  CoUnInitialize;
  }
  FreeMem( szGotPath, MAX_PATH );
  FreeMem( Wsz, Max_Path * 2 );
  Result := Hres;
end;


Function FileNameHasExtension(AsFileName, AsExtList: String): Boolean;
Begin
  Result:= crUtil.FileNameHasExtension(AsFileName, AsExtList);
End;


//**************************************//
//******      TAidFileFinder     *******//
//*************************************//
Constructor TAidFileFinder.Create;
Begin
  Inherited Create;
  FWildCard := '*.*';
  FFromPath := 'C:\';
end;

Destructor TAidFileFinder.Destroy;
begin
  Inherited Destroy;
end;

Procedure TAidFileFinder.Find;
begin
  If Not Assigned(FOnFound) Then Exit;
  RecursiveFind(FFromPath);
end;

Procedure TAidFileFinder.RecursiveFind(StartPath:String);
var
  FSearchRec : TSearchRec;
begin
  FindFirst(StartPath+'\'+FWildCard, faAnyFile, FSearchRec);
  while FindNext(FSearchRec) = 0 do
  begin
    if ((FSearchRec.Name <> '.') AND (FSearchRec.Name <> '..') AND (FSearchRec.Attr <> faDirectory)) Then
       FOnFound(StartPath,FSearchRec);
    if FSearchRec.Attr = faDirectory Then
    Begin
       if (FSearchRec.Name <> '.') AND (FSearchRec.Name <> '..') Then
          RecursiveFind(StartPath+'\'+FSearchRec.Name);
    end;
  end;
  FindClose(FSearchRec);
end;



{ DrawContractStatus
    Draws the Contract Status cell - Contract.KEY_STATUS. }
procedure DrawContractStatus(AoCanvas: TCanvas; ArRect: TRect; AsContractStatus: String);
var
  eContState  : TaidContState;
  rContState  : TaidContractStateRecord;
  wFormat     : Cardinal;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    eContState:= aidTypes .ContStateByString(AsContractStatus);
    rContState:= aidTypes .ContStateRecByOrd(eContState);

    AoCanvas.Brush.Color := rContState.BGColor;
    AoCanvas.Font .Color := rContState.FGColor;
    wFormat:= DT_LEFT	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
    AoCanvas.FillRect(ArRect);
    InflateRect(ArRect, -1, 0);
    DrawText(AoCanvas.Handle, PChar(rContState.Desc), Length(rContState.Desc), ArRect, wFormat);
  end;
end;


procedure DrawContractBomType(AoCanvas: TCanvas; ArRect: TRect; AsContractBomType: String; AbDrawDesc: Boolean = False);
var
  eContractBomType  : TaidContractBomType;
  rContractBomType  : TaidContractBomTypeRecord;
  wFormat           : Cardinal;
  sDraw             : string;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    AoCanvas.FillRect(ArRect);
    eContractBomType:= aidTypes .ContractBomTypeByString(AsContractBomType);
    rContractBomType:= aidTypes .ContractBomTypeByOrd   (eContractBomType);
    AoCanvas.Pen  .Color := rContractBomType.BGColor;
    AoCanvas.Brush.Color := rContractBomType.BGColor;
    AoCanvas.Font .Color := rContractBomType.FGColor;
    wFormat:= DT_CENTER	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
    InflateRect(ArRect, -1, -1);
    sDraw:= rContractBomType.Key;
    if AbDrawDesc then
      sDraw:= rContractBomType.Desc;

    AoCanvas.RoundRect(ArRect.Left, ArRect.Top, ArRect.Right, ArRect.Bottom, 5, 5);
    DrawText(AoCanvas.Handle, PChar(sDraw), Length(sDraw), ArRect, wFormat);
  end;
end;

function  hintContractBomType(AsContractBomType: String) : string;
var
  eContractBomType  : TaidContractBomType;
  rContractBomType  : TaidContractBomTypeRecord;
begin
  eContractBomType:= aidTypes .ContractBomTypeByString(AsContractBomType);
  rContractBomType:= aidTypes .ContractBomTypeByOrd   (eContractBomType);
  result := rContractBomType.Hint;
end;


procedure DrawChangeOrderAction(AoCanvas: TCanvas; ArRect: TRect; AeChangeOrderAction: TaidChangeOrderAction);
var
  rChangeOrder: TaidChangeOrderActionRecord;
  wFormat     : Cardinal;
  sText       : String;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    rChangeOrder:= aidTypes.ChangeOrderActionByOrd(AeChangeOrderAction);
    AoCanvas.Brush.Color := rChangeOrder.BGColor;
    AoCanvas.Font .Color := rChangeOrder.FGColor;
    wFormat:= DT_LEFT	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
    AoCanvas.FillRect(ArRect);
    InflateRect(ArRect, -1, 0);
    sText:= rChangeOrder.Desc;
    DrawText(AoCanvas.Handle, PChar(sText), Length(sText), ArRect, wFormat);
  end;
end;


procedure DrawChangeOrderOriginContext(AoCanvas: TCanvas; ArRect: TRect; AeChangeOrderOriginContext: TaidChangeOrderSource);
var
  rCOSource: TaidChangeOrderSourceRecord;
  wFormat  : Cardinal;
  sText    : String;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    { Default Draw  }
    AoCanvas.FillRect(ArRect);
    rCOSource:= aidTypes .ChangeOrderSourceByOrd(AeChangeOrderOriginContext);
    AoCanvas.Brush.Color := rCOSource.BGColor;
    AoCanvas.Font .Color := rCOSource.FGColor;
    wFormat:= DT_CENTER	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
    InflateRect(ArRect, -1, -1);
    AoCanvas.RoundRect(ArRect.Left, ArRect.Top, ArRect.Right, ArRect.Bottom, 5, 5);
    InflateRect(ArRect, 0, +1);
    sText:= rCOSource.ColumnDesc;
    DrawText(AoCanvas.Handle, PChar(sText), Length(sText), ArRect, wFormat);
  end;
end;



{ DrawChangeOrderPriority
}
procedure DrawChangeOrderPriority(AoCanvas: TCanvas; ArRect: TRect; AiPriority: Integer);
  procedure DrawPriority(AsFontName: string; AsDrawText: String; AiColor: TColor);
  var
    rRect : TRect;
  begin
    if (not IsEmptyStr(AsDrawText)) then
    begin
      if (not IsEmptyStr(AsFontName)) then AoCanvas.Font.Name:= AsFontName;
      AoCanvas.Font.Color:= AiColor;
      rRect:= ArRect;
      rRect.Right:= rRect.Right-2;
      AoCanvas.Font.Height:= (rRect.Bottom-rRect.Top)+1;
      AoCanvas.Font.Style := AoCanvas.Font.Style + [fsBold];
      DrawText(AoCanvas.Handle, PChar(AsDrawText), Length(AsDrawText), rRect, DT_RIGHT);
    end;  
  end;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    { Draw the Change Order No. }
    if (AiPriority<0) then
      DrawPriority('Wingdings', Chr($e2), clBlue)  {blue down-arrow}
    else
      if (AiPriority>0) then
        DrawPriority('Arial', '!', clRed);  {red exclamation}
  end;
end;


{ DrawStockMovementDirection
    Draws an icon for a stock movement datagrid cell. }
procedure DrawStockMovementDirection(AoCanvas: TCanvas; ArRect: TRect; AcDirection: Char; AbDrawDesc: Boolean = False);
var
  rDirection  : TaidStockMovementDirectionRecord;
  wFormat     : Cardinal;
  sDraw       : string;
  wPenColor   : TColor;
  wBrushColor : TColor;
  wFontColor  : TColor;
begin
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    { Background }
    AoCanvas.FillRect(ArRect);

    if StockMovementDirectionByKey(AcDirection, rDirection) then
    begin
      wPenColor   := AoCanvas.Pen  .Color;
      wBrushColor := AoCanvas.Brush.Color;
      wFontColor  := AoCanvas.Font .Color;
      try
        AoCanvas.Pen  .Color := rDirection.ColorBG;
        AoCanvas.Brush.Color := rDirection.ColorBG;
        AoCanvas.Font .Color := rDirection.ColorFG;

        wFormat:= DT_CENTER	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
        InflateRect(ArRect, -1, -1);
        sDraw:= rDirection.Key;
        if AbDrawDesc then
          sDraw:= rDirection.Desc;
        AoCanvas.RoundRect(ArRect.Left, ArRect.Top, ArRect.Right, ArRect.Bottom, 5, 5);
        DrawText(AoCanvas.Handle, PChar(sDraw), Length(sDraw), ArRect, wFormat);
      finally
        AoCanvas.Pen  .Color:= wPenColor  ;
        AoCanvas.Brush.Color:= wBrushColor;
        AoCanvas.Font .Color:= wFontColor ;
      end;
    end;
  end;
end;


{ DrawBinTypeAsIcon
    Renders a summarised cell denoting a BinType.
  modified  :
    CGR20070116, Moved from bomUtil.pas as this is now to be used by a library component. }
procedure DrawBinTypeAsIcon(AoCanvas: TCanvas; const ArRect: TRect; AsBinType: String);
begin
  DrawBinTypeAsIcon(AoCanvas, ArRect, BinTypeFromTypeFromString(AsBinType));
end;

{ DrawBinTypeAsIcon
    Renders a summarised cell denoting a BinType. }
procedure DrawBinTypeAsIcon(AoCanvas: TCanvas; const ArRect: TRect; AeBinType: TBinType); overload;
var
  rBinTypeRecord: TBinTypeRecord;
  rRect         : TRect;
  wFormat       : Cardinal;
  sDraw         : String;
begin
  rBinTypeRecord:= aidTypes.BinTypeRecordByOrd(AeBinType);

  rRect:= ArRect;
  if Assigned(AoCanvas) and (AoCanvas.HandleAllocated) then
  begin
    AoCanvas.FillRect(rRect);
    AoCanvas.Pen  .Color := rBinTypeRecord.ColorBG;
    AoCanvas.Brush.Color := rBinTypeRecord.ColorBG;
    AoCanvas.Font .Color := rBinTypeRecord.ColorFG;
    wFormat:= DT_CENTER	+ DT_NOPREFIX	+ DT_VCENTER + DT_SINGLELINE;
    InflateRect(rRect, -1, -1);
    sDraw:= rBinTypeRecord.Key;
    AoCanvas.RoundRect(rRect.Left, rRect.Top, rRect.Right, rRect.Bottom, 5, 5);
    DrawText(AoCanvas.Handle, PChar(sDraw), Length(sDraw), rRect, wFormat);
  end;
end;

{ RaiseRoutineInvalidArguments
}
procedure RaiseRoutineInvalidArguments(AsRoutineName: String);
begin
  raise EaidException.CreateFmt(rsInvalidArgumentsToProcedure, [AsRoutineName]);
end;


function  AppRegistrySection(): string;
var
  oTest : TRegistry;
const
  CMovedToBobstGroup = 'MovedToBobstGroup';
  CValmetRegistryKey = '\Software\Valmet\';
  CAtlasRegistryKey  = '\Software\BobstGroup\';
begin

  if IsEmptyStr(sRegSection) then
  begin
    // Check the workstation registry to establish if it has old settings - if
    // so, move these to Atlas.
    oTest:= TRegistry.Create;
    try
      oTest.RootKey:= HKEY_CURRENT_USER;
      if oTest.KeyExists(CValmetRegistryKey) then
      begin
        oTest.OpenKey  (CValmetRegistryKey, False);
        if not (oTest.ValueExists(CMovedToBobstGroup)) then
        begin
          oTest.CloseKey;
          oTest.MoveKey    (CValmetRegistryKey, CAtlasRegistryKey, True);
          oTest.OpenKey    (CValmetRegistryKey, True);
          oTest.WriteString(CMovedToBobstGroup, FormatDateTime('DD/MM/YYYY HH:MM:SS', now));
          oTest.CloseKey;
        end;
      end;
      sRegSection:= CAtlasRegistryKey;
    finally
      oTest.Free;
    end;
  end;
  //
  Result:= sRegSection+sRegIndent;
end;

function  ApplicationTargetBySite(site : TSiteNo): TApplicationAudience;
var
  SingleSite : char;
  testOverride : string;
begin
  if rtrim(site) = '' then
    site := 'A';

  testOverride := trim(tbomSettings.instance.value['test']);
  if testOverride <> '' then
    site := testOverride;

  singlesite := copy(site,1,1)[1];
  case singlesite of
     'A','C','P','S','T'  : Result:= aidauAtlas;
     'U'                  : Result:= aidauAtlasNorthAmerica;
     'G','H'              : Result:= aidauBobst;
  else
     result               := ApplicationTarget;
  end;
end;

{ ApplicationTarget()
    Tries to make a decision on which company is the target company. This is computed from the application name, or
    registry tree.

    aidauApolloSheeters, if the Application name is FMApollo.exe, or the registry root starts with Apollo eg Apollo, ApolloLIVE, ApolloLocal. }
function ApplicationTarget(): TApplicationAudience;
var
  sApplicationName          : String;
  sCustomApplicationRegistry: String;

  function GetExtractedApplicationName(): String;
  begin
    { Extract The Application Name }
    Result:= ParamStr(0);
    Result:= ExtractFileName(Result);
    Result:= ChangeFileExt(Result, '');
  end;
  function GetCustomApplicationRegistry(): String;
  var
    iK, iL  : Integer;
    sParam  : String;
    sP1     : String;
    sP2     : String;
  begin
    Result:= '';
    { Loop the run parameters to establish if a registry setting has been supplied. }
    for iK:= 1 to ParamCount do
    begin
      sParam:= ParamStr(iK);
      iL:= Pos('=', sParam);
      if iL=0 then
      begin
        sP1:= Uppercase(OnlyAlpha(sParam));
        sP2:= '';
      end
      else
      begin
        sP1:= LeftStr (sParam, iL-1)             ; sP1:= Uppercase(OnlyAlpha(sP1));
        sP2:= crUtil.RightStr(sParam, Length(sParam)-iL); sP2:= Uppercase(OnlyAlpha(sP2));
      end;

      if (sP1 = 'REG') then
      begin
        Result:= sP2;
        Break;
      end;
    end;
  end;
  function RegisteredCompany : string;
  var
    oReg: TRegIniFile;
  begin
    oReg:= TRegIniFile.Create(AppRegistrySection);
    try
      result    := oReg.ReadString (cReg_defaultCompany, cReg_defaultCompany, '');
    finally
      oReg.free;
    end;


  end;
begin
  //Default to Bobst
  Result:= aidauBobst;
  //If the Application Executable is "Apollo", or the Application registry key is "Apollo", then we're Apollo.
  sApplicationName          := GetExtractedApplicationName();
  sCustomApplicationRegistry:= GetCustomApplicationRegistry();

  if ((CompareText(sApplicationName, 'FMApollo') = 0) or ANSIContainsText(sCustomApplicationRegistry, 'Apollo')) then
    Result:= aidauApolloSheeters
  else if RegisteredCompany = C_DefaultCompany_ATLAS then
    Result:= aidauAtlas;

end;


{  LooksLikeAContractNo()
      Returns True if the argument resembles the format for "modern" contract numbering

      eg A05S001 }
function LooksLikeAContractNo(const AsJobNo: String): Boolean;
var
  sJobNo  : String;
begin
  Result:= False;
  sJobNo:= Trim(AsJobNo);
  if (Length(sJobNo)>=7) then
    Result:= IsAlpha(sJobNo[1]) and IsDigit(sJobNo[2]) and IsDigit(sJobNo[3]) and IsAlpha(sJobNo[4]) and
             IsDigit(sJobNo[5]) and IsDigit(sJobNo[6]) and IsDigit(sJobNo[7]);
end;



{ RecurseControlEnabledState
    Recurses a control & child controls setting the enabled property to the value in AbEnabledState.}
procedure RecurseControlEnabledState(AControl: TWinControl; AbEnabledState : Boolean);
var
  iControl  : Integer;
  oControl  : TControl;
begin
  if Assigned(AControl) then
  begin
    for iControl:= 0 to AControl.ControlCount-1 do
    begin
      oControl:= AControl.Controls[iControl];
      oControl.Enabled:= AbEnabledState;
      if oControl is TWinControl then
        if TWinControl(oControl).ControlCount>0 then
          RecurseControlEnabledState(TWinControl(oControl), AbEnabledState);
    end;
  end;
end;

initialization
  sRegSection := '';
  
end.
