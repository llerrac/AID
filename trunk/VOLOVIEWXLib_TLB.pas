unit VOLOVIEWXLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:1.2$
// File generated on 10/12/2002 15:35:37 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Volo View Express\avviewx.dll (1)
// LIBID: {8718C64B-8956-11D2-BD21-0060B0A12A50}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\stdvcl40.dll)
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VOLOVIEWXLibMajorVersion = 1;
  VOLOVIEWXLibMinorVersion = 0;

  LIBID_VOLOVIEWXLib: TGUID = '{8718C64B-8956-11D2-BD21-0060B0A12A50}';

  DIID__IAvViewXEvents: TGUID = '{915602D6-6D0D-11D2-9205-0060B0870404}';
  IID_IAvViewX: TGUID = '{8718C657-8956-11D2-BD21-0060B0A12A50}';
  CLASS_AvViewX: TGUID = '{8718C658-8956-11D2-BD21-0060B0A12A50}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum DrawingFormat
type
  DrawingFormat = TOleEnum;
const
  DrawingDWG = $00000000;
  DrawingDXF = $00000001;
  DrawingDWF = $00000002;
  DrawingUnknown = $00000003;
  DrawingNotFound = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IAvViewXEvents = dispinterface;
  IAvViewX = interface;
  IAvViewXDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AvViewX = IAvViewX;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWordBool1 = ^WordBool; {*}
  PWideString1 = ^WideString; {*}
  PInteger1 = ^Integer; {*}
  PUserType1 = ^DrawingFormat; {*}


// *********************************************************************//
// DispIntf:  _IAvViewXEvents
// Flags:     (4096) Dispatchable
// GUID:      {915602D6-6D0D-11D2-9205-0060B0870404}
// *********************************************************************//
  _IAvViewXEvents = dispinterface
    ['{915602D6-6D0D-11D2-9205-0060B0870404}']
    procedure MouseDown(Button: Smallint; Shift: Smallint; x: Double; y: Double); dispid -605;
    procedure MouseUp(Button: Smallint; Shift: Smallint; x: Double; y: Double); dispid -607;
    procedure MouseMove(Button: Smallint; Shift: Smallint; x: Double; y: Double); dispid -606;
    procedure OnProgress(Progress: Integer; ProgressMax: Integer; StatusCode: Integer; 
                         const StatusText: WideString; var bAbort: WordBool); dispid 1;
    procedure DoNavigateToURL(const url: WideString; const window_name: WideString; 
                              var enable_default: WordBool); dispid 2;
    procedure OnFileResolve(const InParentFilename: WideString; const InEmbeddedName: WideString; 
                            var OutFilename: WideString; var eCode: Integer); dispid 3;
    procedure MouseWheel(Button: Smallint; Shift: Smallint; Delta: Smallint; x: Double; y: Double); dispid 4;
    procedure ViewChange; dispid 5;
    procedure UserModeChange(const Mode: WideString); dispid 6;
    procedure OnFileFound(const InParentFilename: WideString; const InFoundPath: WideString; 
                          var OutFilename: WideString; var eCode: Integer); dispid 7;
    procedure OnClearMarkup(var enable_default: WordBool); dispid 8;
    procedure OnSaveMarkup(var enable_default: WordBool); dispid 9;
    procedure SaveMarkupComplete; dispid 10;
    procedure LayoutChanged(const newLayout: WideString); dispid 11;
    procedure ReservedEvent12; dispid 12;
    procedure ReservedEvent13; dispid 13;
    procedure ReservedEvent14; dispid 14;
    procedure ReservedEvent15; dispid 15;
    procedure ReservedEvent16; dispid 16;
    procedure ReservedEvent17; dispid 17;
    procedure ReservedEvent18; dispid 18;
    procedure ReservedEvent19; dispid 19;
    procedure ReservedEvent20; dispid 20;
    procedure ReservedEvent21; dispid 21;
    procedure ReservedEvent22; dispid 22;
    procedure ReservedEvent23; dispid 23;
    procedure ReservedEvent24; dispid 24;
    procedure ReservedEvent25; dispid 25;
    procedure ReservedEvent26; dispid 26;
    procedure ReservedEvent27; dispid 27;
    procedure ReservedEvent28; dispid 28;
    procedure ReservedEvent29; dispid 29;
    procedure ReservedEvent30; dispid 30;
    procedure ReservedEvent31; dispid 31;
    procedure ReservedEvent32; dispid 32;
    procedure ReservedEvent33; dispid 33;
    procedure ReservedEvent34; dispid 34;
    procedure ReservedEvent35; dispid 35;
    procedure ReservedEvent36; dispid 36;
    procedure ReservedEvent37; dispid 37;
    procedure ReservedEvent38; dispid 38;
    procedure ReservedEvent39; dispid 39;
    procedure reservedEvent40; dispid 40;
  end;

// *********************************************************************//
// Interface: IAvViewX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8718C657-8956-11D2-BD21-0060B0A12A50}
// *********************************************************************//
  IAvViewX = interface(IDispatch)
    ['{8718C657-8956-11D2-BD21-0060B0A12A50}']
    procedure Set_BorderStyle(pstyle: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_Enabled(pbool: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Window: Integer; safecall;
    procedure Set_Appearance(pappearance: Smallint); safecall;
    function Get_Appearance: Smallint; safecall;
    function Get_UserMode: WideString; safecall;
    procedure Set_UserMode(const pVal: WideString); safecall;
    function Get_HighlightLinks: WordBool; safecall;
    procedure Set_HighlightLinks(pVal: WordBool); safecall;
    function Get_src: WideString; safecall;
    procedure Set_src(const pVal: WideString); safecall;
    function Get_LayersOn: WideString; safecall;
    procedure Set_LayersOn(const pVal: WideString); safecall;
    function Get_LayersOff: WideString; safecall;
    procedure Set_LayersOff(const pVal: WideString); safecall;
    function Get_SrcTemp: WideString; safecall;
    procedure Set_SrcTemp(const pVal: WideString); safecall;
    function Get_SupportPath: WideString; safecall;
    procedure Set_SupportPath(const pVal: WideString); safecall;
    function Get_FontPath: WideString; safecall;
    procedure Set_FontPath(const pVal: WideString); safecall;
    function Get_NamedView: WideString; safecall;
    procedure Set_NamedView(const pVal: WideString); safecall;
    function Get_GeometryColor: WideString; safecall;
    procedure Set_GeometryColor(const pVal: WideString); safecall;
    function Get_PrintBackgroundColor: WideString; safecall;
    procedure Set_PrintBackgroundColor(const pVal: WideString); safecall;
    function Get_PrintGeometryColor: WideString; safecall;
    procedure Set_PrintGeometryColor(const pVal: WideString); safecall;
    function Get_ShadingMode: WideString; safecall;
    procedure Set_ShadingMode(const pVal: WideString); safecall;
    function Get_ProjectionMode: WideString; safecall;
    procedure Set_ProjectionMode(const pVal: WideString); safecall;
    function Get_EnableUIMode: WideString; safecall;
    procedure Set_EnableUIMode(const pVal: WideString); safecall;
    function Get_Layout: WideString; safecall;
    procedure Set_Layout(const pVal: WideString); safecall;
    procedure Set_BackgroundColor(const pclr: WideString); safecall;
    function Get_BackgroundColor: WideString; safecall;
    procedure Set_DisplayMode(pmode: Integer); safecall;
    function Get_DisplayMode: Integer; safecall;
    function Get_NumMarkupItems: Integer; safecall;
    function Get_Version: WideString; safecall;
    function Get_Layouts: WideString; safecall;
    procedure Set_DisplayPageBackground(b: WordBool); safecall;
    function Get_DisplayPageBackground: WordBool; safecall;
    procedure Reserved26; safecall;
    procedure Reserved27; safecall;
    procedure Reserved28; safecall;
    procedure Reserved29; safecall;
    procedure Reserved30; safecall;
    procedure Reserved31; safecall;
    procedure Reserved32; safecall;
    procedure Reserved33; safecall;
    procedure Reserved34; safecall;
    procedure Reserved35; safecall;
    procedure Reserved36; safecall;
    procedure Reserved37; safecall;
    procedure Reserved38; safecall;
    procedure Reserved39; safecall;
    procedure Reserved40; safecall;
    procedure Reserved41; safecall;
    procedure Reserved42; safecall;
    procedure Reserved43; safecall;
    procedure Reserved44; safecall;
    procedure Reserved45; safecall;
    procedure Reserved46; safecall;
    procedure Reserved47; safecall;
    procedure Reserved48; safecall;
    procedure Reserved49; safecall;
    procedure Reserved50; safecall;
    procedure Reserved51; safecall;
    procedure Reserved52; safecall;
    procedure Reserved53; safecall;
    procedure Reserved54; safecall;
    procedure Reserved55; safecall;
    procedure Reserved56; safecall;
    procedure Reserved57; safecall;
    procedure Reserved58; safecall;
    procedure Reserved59; safecall;
    procedure Update; safecall;
    procedure ShowLayersDialog; safecall;
    procedure ShowNamedViewsDialog; safecall;
    procedure ShowLayoutsDialog; safecall;
    procedure ShowPrintDialog; safecall;
    procedure SetOleObjectHandler(const punk: IUnknown); safecall;
    procedure GetDrawingExtents(out left: Double; out right: Double; out bottom: Double; 
                                out top: Double); safecall;
    procedure GetCurrentView(out left: Double; out right: Double; out bottom: Double; 
                             out top: Double); safecall;
    procedure SetCurrentView(left: Double; right: Double; bottom: Double; top: Double); safecall;
    procedure ShowAboutDialog; safecall;
    procedure _Configure3D; safecall;
    procedure InvokeURL(const url: WideString); safecall;
    procedure ShowSaveAsDialog; safecall;
    procedure ShowOptionsDialog; safecall;
    procedure GetDrawingFormat(const url: WideString; var resolvedUrl: WideString; 
                               var pFormat: DrawingFormat); safecall;
    procedure ShowSaveMarkupDialog; safecall;
    procedure SaveMarkup(const filename: WideString); safecall;
    function ClearMarkup: WordBool; safecall;
    procedure ZoomExtents; safecall;
    procedure Reserved79; safecall;
    procedure Reserved80; safecall;
    procedure Reserved81; safecall;
    procedure Reserved82; safecall;
    procedure Reserved83; safecall;
    procedure Reserved84; safecall;
    procedure Reserved85; safecall;
    procedure Reserved86; safecall;
    procedure Reserved87; safecall;
    procedure Reserved88; safecall;
    procedure Reserved89; safecall;
    procedure Reserved90; safecall;
    procedure Reserved91; safecall;
    procedure Reserved92; safecall;
    procedure Reserved93; safecall;
    procedure Reserved94; safecall;
    procedure Reserved95; safecall;
    procedure Reserved96; safecall;
    procedure Reserved97; safecall;
    procedure Reserved98; safecall;
    procedure Reserved99; safecall;
    procedure Reserved100; safecall;
    procedure Reserved101; safecall;
    procedure Reserved102; safecall;
    procedure Reserved103; safecall;
    procedure Reserved104; safecall;
    procedure Reserved105; safecall;
    procedure Reserved106; safecall;
    procedure Reserved107; safecall;
    procedure Reserved108; safecall;
    procedure Reserved109; safecall;
    procedure Reserved110; safecall;
    procedure Reserved111; safecall;
    procedure Reserved112; safecall;
    procedure Reserved113; safecall;
    procedure Reserved114; safecall;
    procedure Reserved115; safecall;
    procedure Reserved116; safecall;
    procedure Reserved117; safecall;
    procedure Reserved118; safecall;
    procedure Reserved119; safecall;
    procedure Reserved120; safecall;
    procedure Reserved121; safecall;
    procedure Reserved122; safecall;
    procedure Reserved123; safecall;
    procedure Reserved124; safecall;
    procedure Reserved125; safecall;
    procedure Reserved126; safecall;
    procedure Reserved127; safecall;
    procedure Reserved128; safecall;
    procedure Reserved129; safecall;
    procedure Reserved130; safecall;
    procedure Reserved131; safecall;
    procedure Reserved132; safecall;
    procedure Reserved133; safecall;
    procedure Reserved134; safecall;
    procedure Reserved135; safecall;
    procedure Reserved136; safecall;
    procedure Reserved137; safecall;
    procedure Reserved138; safecall;
    procedure Reserved139; safecall;
    procedure Reserved140; safecall;
    procedure Reserved141; safecall;
    procedure Reserved142; safecall;
    procedure Reserved143; safecall;
    procedure Reserved144; safecall;
    procedure Reserved145; safecall;
    procedure Reserved146; safecall;
    procedure Reserved147; safecall;
    procedure Reserved148; safecall;
    procedure Reserved149; safecall;
    procedure Reserved150; safecall;
    procedure Reserved151; safecall;
    procedure Reserved152; safecall;
    procedure Reserved153; safecall;
    procedure Reserved154; safecall;
    procedure Reserved155; safecall;
    procedure Reserved156; safecall;
    procedure Reserved157; safecall;
    procedure Reserved158; safecall;
    procedure Reserved159; safecall;
    procedure Reserved160; safecall;
    procedure Reserved161; safecall;
    procedure Reserved162; safecall;
    procedure Reserved163; safecall;
    procedure Reserved164; safecall;
    procedure Reserved165; safecall;
    procedure Reserved166; safecall;
    procedure Reserved167; safecall;
    procedure Reserved168; safecall;
    procedure Reserved169; safecall;
    procedure Reserved170; safecall;
    procedure Reserved171; safecall;
    procedure Reserved172; safecall;
    procedure Reserved173; safecall;
    procedure Reserved174; safecall;
    procedure Reserved175; safecall;
    procedure Reserved176; safecall;
    procedure Reserved177; safecall;
    procedure Reserved178; safecall;
    procedure Reserved179; safecall;
    procedure Reserved180; safecall;
    procedure Reserved181; safecall;
    procedure Reserved182; safecall;
    procedure Reserved183; safecall;
    procedure Reserved184; safecall;
    procedure Reserved185; safecall;
    procedure Reserved186; safecall;
    procedure Reserved187; safecall;
    procedure Reserved188; safecall;
    procedure Reserved189; safecall;
    procedure Reserved190; safecall;
    procedure Reserved191; safecall;
    procedure Reserved192; safecall;
    procedure Reserved193; safecall;
    procedure Reserved194; safecall;
    procedure Reserved195; safecall;
    function Get__cy: Integer; safecall;
    procedure Set__cy(cy: Integer); safecall;
    function Get__cx: Integer; safecall;
    procedure Set__cx(cx: Integer); safecall;
    procedure Reserved200; safecall;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Window: Integer read Get_Window;
    property Appearance: Smallint read Get_Appearance write Set_Appearance;
    property UserMode: WideString read Get_UserMode write Set_UserMode;
    property HighlightLinks: WordBool read Get_HighlightLinks write Set_HighlightLinks;
    property src: WideString read Get_src write Set_src;
    property LayersOn: WideString read Get_LayersOn write Set_LayersOn;
    property LayersOff: WideString read Get_LayersOff write Set_LayersOff;
    property SrcTemp: WideString read Get_SrcTemp write Set_SrcTemp;
    property SupportPath: WideString read Get_SupportPath write Set_SupportPath;
    property FontPath: WideString read Get_FontPath write Set_FontPath;
    property NamedView: WideString read Get_NamedView write Set_NamedView;
    property GeometryColor: WideString read Get_GeometryColor write Set_GeometryColor;
    property PrintBackgroundColor: WideString read Get_PrintBackgroundColor write Set_PrintBackgroundColor;
    property PrintGeometryColor: WideString read Get_PrintGeometryColor write Set_PrintGeometryColor;
    property ShadingMode: WideString read Get_ShadingMode write Set_ShadingMode;
    property ProjectionMode: WideString read Get_ProjectionMode write Set_ProjectionMode;
    property EnableUIMode: WideString read Get_EnableUIMode write Set_EnableUIMode;
    property Layout: WideString read Get_Layout write Set_Layout;
    property BackgroundColor: WideString read Get_BackgroundColor write Set_BackgroundColor;
    property DisplayMode: Integer read Get_DisplayMode write Set_DisplayMode;
    property NumMarkupItems: Integer read Get_NumMarkupItems;
    property Version: WideString read Get_Version;
    property Layouts: WideString read Get_Layouts;
    property DisplayPageBackground: WordBool read Get_DisplayPageBackground write Set_DisplayPageBackground;
    property _cy: Integer read Get__cy write Set__cy;
    property _cx: Integer read Get__cx write Set__cx;
  end;

// *********************************************************************//
// DispIntf:  IAvViewXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8718C657-8956-11D2-BD21-0060B0A12A50}
// *********************************************************************//
  IAvViewXDisp = dispinterface
    ['{8718C657-8956-11D2-BD21-0060B0A12A50}']
    property BorderStyle: Integer dispid -504;
    property Enabled: WordBool dispid -514;
    property Window: Integer readonly dispid -515;
    property Appearance: Smallint dispid -520;
    property UserMode: WideString dispid 1;
    property HighlightLinks: WordBool dispid 2;
    property src: WideString dispid 3;
    property LayersOn: WideString dispid 4;
    property LayersOff: WideString dispid 5;
    property SrcTemp: WideString dispid 6;
    property SupportPath: WideString dispid 7;
    property FontPath: WideString dispid 8;
    property NamedView: WideString dispid 9;
    property GeometryColor: WideString dispid 10;
    property PrintBackgroundColor: WideString dispid 11;
    property PrintGeometryColor: WideString dispid 12;
    property ShadingMode: WideString dispid 13;
    property ProjectionMode: WideString dispid 14;
    property EnableUIMode: WideString dispid 15;
    property Layout: WideString dispid 17;
    property BackgroundColor: WideString dispid 18;
    property DisplayMode: Integer dispid 19;
    property NumMarkupItems: Integer readonly dispid 20;
    property Version: WideString readonly dispid 21;
    property Layouts: WideString readonly dispid 22;
    property DisplayPageBackground: WordBool dispid 23;
    procedure Reserved26; dispid 26;
    procedure Reserved27; dispid 27;
    procedure Reserved28; dispid 28;
    procedure Reserved29; dispid 29;
    procedure Reserved30; dispid 30;
    procedure Reserved31; dispid 31;
    procedure Reserved32; dispid 32;
    procedure Reserved33; dispid 33;
    procedure Reserved34; dispid 34;
    procedure Reserved35; dispid 35;
    procedure Reserved36; dispid 36;
    procedure Reserved37; dispid 37;
    procedure Reserved38; dispid 38;
    procedure Reserved39; dispid 39;
    procedure Reserved40; dispid 40;
    procedure Reserved41; dispid 41;
    procedure Reserved42; dispid 42;
    procedure Reserved43; dispid 43;
    procedure Reserved44; dispid 44;
    procedure Reserved45; dispid 45;
    procedure Reserved46; dispid 46;
    procedure Reserved47; dispid 47;
    procedure Reserved48; dispid 48;
    procedure Reserved49; dispid 49;
    procedure Reserved50; dispid 50;
    procedure Reserved51; dispid 51;
    procedure Reserved52; dispid 52;
    procedure Reserved53; dispid 53;
    procedure Reserved54; dispid 54;
    procedure Reserved55; dispid 55;
    procedure Reserved56; dispid 56;
    procedure Reserved57; dispid 57;
    procedure Reserved58; dispid 58;
    procedure Reserved59; dispid 59;
    procedure Update; dispid 60;
    procedure ShowLayersDialog; dispid 61;
    procedure ShowNamedViewsDialog; dispid 62;
    procedure ShowLayoutsDialog; dispid 63;
    procedure ShowPrintDialog; dispid 64;
    procedure SetOleObjectHandler(const punk: IUnknown); dispid 66;
    procedure GetDrawingExtents(out left: Double; out right: Double; out bottom: Double; 
                                out top: Double); dispid 67;
    procedure GetCurrentView(out left: Double; out right: Double; out bottom: Double; 
                             out top: Double); dispid 68;
    procedure SetCurrentView(left: Double; right: Double; bottom: Double; top: Double); dispid 69;
    procedure ShowAboutDialog; dispid 65;
    procedure _Configure3D; dispid 70;
    procedure InvokeURL(const url: WideString); dispid 71;
    procedure ShowSaveAsDialog; dispid 72;
    procedure ShowOptionsDialog; dispid 73;
    procedure GetDrawingFormat(const url: WideString; var resolvedUrl: WideString; 
                               var pFormat: DrawingFormat); dispid 74;
    procedure ShowSaveMarkupDialog; dispid 75;
    procedure SaveMarkup(const filename: WideString); dispid 76;
    function ClearMarkup: WordBool; dispid 77;
    procedure ZoomExtents; dispid 78;
    procedure Reserved79; dispid 79;
    procedure Reserved80; dispid 80;
    procedure Reserved81; dispid 81;
    procedure Reserved82; dispid 82;
    procedure Reserved83; dispid 83;
    procedure Reserved84; dispid 84;
    procedure Reserved85; dispid 85;
    procedure Reserved86; dispid 86;
    procedure Reserved87; dispid 87;
    procedure Reserved88; dispid 88;
    procedure Reserved89; dispid 89;
    procedure Reserved90; dispid 90;
    procedure Reserved91; dispid 91;
    procedure Reserved92; dispid 92;
    procedure Reserved93; dispid 93;
    procedure Reserved94; dispid 94;
    procedure Reserved95; dispid 95;
    procedure Reserved96; dispid 96;
    procedure Reserved97; dispid 97;
    procedure Reserved98; dispid 98;
    procedure Reserved99; dispid 99;
    procedure Reserved100; dispid 100;
    procedure Reserved101; dispid 101;
    procedure Reserved102; dispid 102;
    procedure Reserved103; dispid 103;
    procedure Reserved104; dispid 104;
    procedure Reserved105; dispid 105;
    procedure Reserved106; dispid 106;
    procedure Reserved107; dispid 107;
    procedure Reserved108; dispid 108;
    procedure Reserved109; dispid 109;
    procedure Reserved110; dispid 110;
    procedure Reserved111; dispid 111;
    procedure Reserved112; dispid 112;
    procedure Reserved113; dispid 113;
    procedure Reserved114; dispid 114;
    procedure Reserved115; dispid 115;
    procedure Reserved116; dispid 116;
    procedure Reserved117; dispid 117;
    procedure Reserved118; dispid 118;
    procedure Reserved119; dispid 119;
    procedure Reserved120; dispid 120;
    procedure Reserved121; dispid 121;
    procedure Reserved122; dispid 122;
    procedure Reserved123; dispid 123;
    procedure Reserved124; dispid 124;
    procedure Reserved125; dispid 125;
    procedure Reserved126; dispid 126;
    procedure Reserved127; dispid 127;
    procedure Reserved128; dispid 128;
    procedure Reserved129; dispid 129;
    procedure Reserved130; dispid 130;
    procedure Reserved131; dispid 131;
    procedure Reserved132; dispid 132;
    procedure Reserved133; dispid 133;
    procedure Reserved134; dispid 134;
    procedure Reserved135; dispid 135;
    procedure Reserved136; dispid 136;
    procedure Reserved137; dispid 137;
    procedure Reserved138; dispid 138;
    procedure Reserved139; dispid 139;
    procedure Reserved140; dispid 140;
    procedure Reserved141; dispid 141;
    procedure Reserved142; dispid 142;
    procedure Reserved143; dispid 143;
    procedure Reserved144; dispid 144;
    procedure Reserved145; dispid 145;
    procedure Reserved146; dispid 146;
    procedure Reserved147; dispid 147;
    procedure Reserved148; dispid 148;
    procedure Reserved149; dispid 149;
    procedure Reserved150; dispid 150;
    procedure Reserved151; dispid 151;
    procedure Reserved152; dispid 152;
    procedure Reserved153; dispid 153;
    procedure Reserved154; dispid 154;
    procedure Reserved155; dispid 155;
    procedure Reserved156; dispid 156;
    procedure Reserved157; dispid 157;
    procedure Reserved158; dispid 158;
    procedure Reserved159; dispid 159;
    procedure Reserved160; dispid 160;
    procedure Reserved161; dispid 161;
    procedure Reserved162; dispid 162;
    procedure Reserved163; dispid 163;
    procedure Reserved164; dispid 164;
    procedure Reserved165; dispid 165;
    procedure Reserved166; dispid 166;
    procedure Reserved167; dispid 167;
    procedure Reserved168; dispid 168;
    procedure Reserved169; dispid 169;
    procedure Reserved170; dispid 170;
    procedure Reserved171; dispid 171;
    procedure Reserved172; dispid 172;
    procedure Reserved173; dispid 173;
    procedure Reserved174; dispid 174;
    procedure Reserved175; dispid 175;
    procedure Reserved176; dispid 176;
    procedure Reserved177; dispid 177;
    procedure Reserved178; dispid 178;
    procedure Reserved179; dispid 179;
    procedure Reserved180; dispid 180;
    procedure Reserved181; dispid 181;
    procedure Reserved182; dispid 182;
    procedure Reserved183; dispid 183;
    procedure Reserved184; dispid 184;
    procedure Reserved185; dispid 185;
    procedure Reserved186; dispid 186;
    procedure Reserved187; dispid 187;
    procedure Reserved188; dispid 188;
    procedure Reserved189; dispid 189;
    procedure Reserved190; dispid 190;
    procedure Reserved191; dispid 191;
    procedure Reserved192; dispid 192;
    procedure Reserved193; dispid 193;
    procedure Reserved194; dispid 194;
    procedure Reserved195; dispid 195;
    property _cy: Integer dispid 198;
    property _cx: Integer dispid 199;
    procedure Reserved200; dispid 200;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TAvViewX
// Help String      : Autodesk Volo View Control
// Default Interface: IAvViewX
// Def. Intf. DISP? : No
// Event   Interface: _IAvViewXEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TAvViewXOnProgress = procedure(Sender: TObject; Progress: Integer; ProgressMax: Integer; 
                                                  StatusCode: Integer; 
                                                  const StatusText: WideString; var bAbort: WordBool) of object;
  TAvViewXDoNavigateToURL = procedure(Sender: TObject; const url: WideString; 
                                                       const window_name: WideString; 
                                                       var enable_default: WordBool) of object;
  TAvViewXOnFileResolve = procedure(Sender: TObject; const InParentFilename: WideString; 
                                                     const InEmbeddedName: WideString; 
                                                     var OutFilename: WideString; var eCode: Integer) of object;
  TAvViewXMouseWheel = procedure(Sender: TObject; Button: Smallint; Shift: Smallint; 
                                                  Delta: Smallint; x: Double; y: Double) of object;
  TAvViewXUserModeChange = procedure(Sender: TObject; const Mode: WideString) of object;
  TAvViewXOnFileFound = procedure(Sender: TObject; const InParentFilename: WideString; 
                                                   const InFoundPath: WideString; 
                                                   var OutFilename: WideString; var eCode: Integer) of object;
  TAvViewXOnClearMarkup = procedure(Sender: TObject; var enable_default: WordBool) of object;
  TAvViewXOnSaveMarkup = procedure(Sender: TObject; var enable_default: WordBool) of object;
  TAvViewXLayoutChanged = procedure(Sender: TObject; const newLayout: WideString) of object;

  TAvViewX = class(TOleControl)
  private
    FOnProgress: TAvViewXOnProgress;
    FOnDoNavigateToURL: TAvViewXDoNavigateToURL;
    FOnFileResolve: TAvViewXOnFileResolve;
    FOnMouseWheel: TAvViewXMouseWheel;
    FOnViewChange: TNotifyEvent;
    FOnUserModeChange: TAvViewXUserModeChange;
    FOnFileFound: TAvViewXOnFileFound;
    FOnClearMarkup: TAvViewXOnClearMarkup;
    FOnSaveMarkup: TAvViewXOnSaveMarkup;
    FOnSaveMarkupComplete: TNotifyEvent;
    FOnLayoutChanged: TAvViewXLayoutChanged;
    FOnReservedEvent12: TNotifyEvent;
    FOnReservedEvent13: TNotifyEvent;
    FOnReservedEvent14: TNotifyEvent;
    FOnReservedEvent15: TNotifyEvent;
    FOnReservedEvent16: TNotifyEvent;
    FOnReservedEvent17: TNotifyEvent;
    FOnReservedEvent18: TNotifyEvent;
    FOnReservedEvent19: TNotifyEvent;
    FOnReservedEvent20: TNotifyEvent;
    FOnReservedEvent21: TNotifyEvent;
    FOnReservedEvent22: TNotifyEvent;
    FOnReservedEvent23: TNotifyEvent;
    FOnReservedEvent24: TNotifyEvent;
    FOnReservedEvent25: TNotifyEvent;
    FOnReservedEvent26: TNotifyEvent;
    FOnReservedEvent27: TNotifyEvent;
    FOnReservedEvent28: TNotifyEvent;
    FOnReservedEvent29: TNotifyEvent;
    FOnReservedEvent30: TNotifyEvent;
    FOnReservedEvent31: TNotifyEvent;
    FOnReservedEvent32: TNotifyEvent;
    FOnReservedEvent33: TNotifyEvent;
    FOnReservedEvent34: TNotifyEvent;
    FOnReservedEvent35: TNotifyEvent;
    FOnReservedEvent36: TNotifyEvent;
    FOnReservedEvent37: TNotifyEvent;
    FOnReservedEvent38: TNotifyEvent;
    FOnReservedEvent39: TNotifyEvent;
    FOnreservedEvent40: TNotifyEvent;
    FIntf: IAvViewX;
    function  GetControlInterface: IAvViewX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Reserved26;
    procedure Reserved27;
    procedure Reserved28;
    procedure Reserved29;
    procedure Reserved30;
    procedure Reserved31;
    procedure Reserved32;
    procedure Reserved33;
    procedure Reserved34;
    procedure Reserved35;
    procedure Reserved36;
    procedure Reserved37;
    procedure Reserved38;
    procedure Reserved39;
    procedure Reserved40;
    procedure Reserved41;
    procedure Reserved42;
    procedure Reserved43;
    procedure Reserved44;
    procedure Reserved45;
    procedure Reserved46;
    procedure Reserved47;
    procedure Reserved48;
    procedure Reserved49;
    procedure Reserved50;
    procedure Reserved51;
    procedure Reserved52;
    procedure Reserved53;
    procedure Reserved54;
    procedure Reserved55;
    procedure Reserved56;
    procedure Reserved57;
    procedure Reserved58;
    procedure Reserved59;
    procedure Update; override;
    procedure ShowLayersDialog;
    procedure ShowNamedViewsDialog;
    procedure ShowLayoutsDialog;
    procedure ShowPrintDialog;
    procedure SetOleObjectHandler(const punk: IUnknown);
    procedure GetDrawingExtents(out left: Double; out right: Double; out bottom: Double; 
                                out top: Double);
    procedure GetCurrentView(out left: Double; out right: Double; out bottom: Double; 
                             out top: Double);
    procedure SetCurrentView(left: Double; right: Double; bottom: Double; top: Double);
    procedure ShowAboutDialog;
    procedure _Configure3D;
    procedure InvokeURL(const url: WideString);
    procedure ShowSaveAsDialog;
    procedure ShowOptionsDialog;
    procedure GetDrawingFormat(const url: WideString; var resolvedUrl: WideString; 
                               var pFormat: DrawingFormat);
    procedure ShowSaveMarkupDialog;
    procedure SaveMarkup(const filename: WideString);
    function ClearMarkup: WordBool;
    procedure ZoomExtents;
    procedure Reserved79;
    procedure Reserved80;
    procedure Reserved81;
    procedure Reserved82;
    procedure Reserved83;
    procedure Reserved84;
    procedure Reserved85;
    procedure Reserved86;
    procedure Reserved87;
    procedure Reserved88;
    procedure Reserved89;
    procedure Reserved90;
    procedure Reserved91;
    procedure Reserved92;
    procedure Reserved93;
    procedure Reserved94;
    procedure Reserved95;
    procedure Reserved96;
    procedure Reserved97;
    procedure Reserved98;
    procedure Reserved99;
    procedure Reserved100;
    procedure Reserved101;
    procedure Reserved102;
    procedure Reserved103;
    procedure Reserved104;
    procedure Reserved105;
    procedure Reserved106;
    procedure Reserved107;
    procedure Reserved108;
    procedure Reserved109;
    procedure Reserved110;
    procedure Reserved111;
    procedure Reserved112;
    procedure Reserved113;
    procedure Reserved114;
    procedure Reserved115;
    procedure Reserved116;
    procedure Reserved117;
    procedure Reserved118;
    procedure Reserved119;
    procedure Reserved120;
    procedure Reserved121;
    procedure Reserved122;
    procedure Reserved123;
    procedure Reserved124;
    procedure Reserved125;
    procedure Reserved126;
    procedure Reserved127;
    procedure Reserved128;
    procedure Reserved129;
    procedure Reserved130;
    procedure Reserved131;
    procedure Reserved132;
    procedure Reserved133;
    procedure Reserved134;
    procedure Reserved135;
    procedure Reserved136;
    procedure Reserved137;
    procedure Reserved138;
    procedure Reserved139;
    procedure Reserved140;
    procedure Reserved141;
    procedure Reserved142;
    procedure Reserved143;
    procedure Reserved144;
    procedure Reserved145;
    procedure Reserved146;
    procedure Reserved147;
    procedure Reserved148;
    procedure Reserved149;
    procedure Reserved150;
    procedure Reserved151;
    procedure Reserved152;
    procedure Reserved153;
    procedure Reserved154;
    procedure Reserved155;
    procedure Reserved156;
    procedure Reserved157;
    procedure Reserved158;
    procedure Reserved159;
    procedure Reserved160;
    procedure Reserved161;
    procedure Reserved162;
    procedure Reserved163;
    procedure Reserved164;
    procedure Reserved165;
    procedure Reserved166;
    procedure Reserved167;
    procedure Reserved168;
    procedure Reserved169;
    procedure Reserved170;
    procedure Reserved171;
    procedure Reserved172;
    procedure Reserved173;
    procedure Reserved174;
    procedure Reserved175;
    procedure Reserved176;
    procedure Reserved177;
    procedure Reserved178;
    procedure Reserved179;
    procedure Reserved180;
    procedure Reserved181;
    procedure Reserved182;
    procedure Reserved183;
    procedure Reserved184;
    procedure Reserved185;
    procedure Reserved186;
    procedure Reserved187;
    procedure Reserved188;
    procedure Reserved189;
    procedure Reserved190;
    procedure Reserved191;
    procedure Reserved192;
    procedure Reserved193;
    procedure Reserved194;
    procedure Reserved195;
    procedure Reserved200;
    property  ControlInterface: IAvViewX read GetControlInterface;
    property  DefaultInterface: IAvViewX read GetControlInterface;
    property Window: Integer index -515 read GetIntegerProp;
    property DisplayMode: Integer index 19 read GetIntegerProp write SetIntegerProp;
    property NumMarkupItems: Integer index 20 read GetIntegerProp;
    property Version: WideString index 21 read GetWideStringProp;
    property Layouts: WideString index 22 read GetWideStringProp;
    property _cy: Integer index 198 read GetIntegerProp write SetIntegerProp;
    property _cx: Integer index 199 read GetIntegerProp write SetIntegerProp;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property  OnMouseUp;
    property  OnMouseMove;
    property  OnMouseDown;
    property BorderStyle: Integer index -504 read GetIntegerProp write SetIntegerProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property Appearance: Smallint index -520 read GetSmallintProp write SetSmallintProp stored False;
    property UserMode: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property HighlightLinks: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property src: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property LayersOn: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property LayersOff: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property SrcTemp: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property SupportPath: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property FontPath: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property NamedView: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property GeometryColor: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property PrintBackgroundColor: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property PrintGeometryColor: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property ShadingMode: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property ProjectionMode: WideString index 14 read GetWideStringProp write SetWideStringProp stored False;
    property EnableUIMode: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property Layout: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property BackgroundColor: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property DisplayPageBackground: WordBool index 23 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnProgress: TAvViewXOnProgress read FOnProgress write FOnProgress;
    property OnDoNavigateToURL: TAvViewXDoNavigateToURL read FOnDoNavigateToURL write FOnDoNavigateToURL;
    property OnFileResolve: TAvViewXOnFileResolve read FOnFileResolve write FOnFileResolve;
    property OnMouseWheel: TAvViewXMouseWheel read FOnMouseWheel write FOnMouseWheel;
    property OnViewChange: TNotifyEvent read FOnViewChange write FOnViewChange;
    property OnUserModeChange: TAvViewXUserModeChange read FOnUserModeChange write FOnUserModeChange;
    property OnFileFound: TAvViewXOnFileFound read FOnFileFound write FOnFileFound;
    property OnClearMarkup: TAvViewXOnClearMarkup read FOnClearMarkup write FOnClearMarkup;
    property OnSaveMarkup: TAvViewXOnSaveMarkup read FOnSaveMarkup write FOnSaveMarkup;
    property OnSaveMarkupComplete: TNotifyEvent read FOnSaveMarkupComplete write FOnSaveMarkupComplete;
    property OnLayoutChanged: TAvViewXLayoutChanged read FOnLayoutChanged write FOnLayoutChanged;
    property OnReservedEvent12: TNotifyEvent read FOnReservedEvent12 write FOnReservedEvent12;
    property OnReservedEvent13: TNotifyEvent read FOnReservedEvent13 write FOnReservedEvent13;
    property OnReservedEvent14: TNotifyEvent read FOnReservedEvent14 write FOnReservedEvent14;
    property OnReservedEvent15: TNotifyEvent read FOnReservedEvent15 write FOnReservedEvent15;
    property OnReservedEvent16: TNotifyEvent read FOnReservedEvent16 write FOnReservedEvent16;
    property OnReservedEvent17: TNotifyEvent read FOnReservedEvent17 write FOnReservedEvent17;
    property OnReservedEvent18: TNotifyEvent read FOnReservedEvent18 write FOnReservedEvent18;
    property OnReservedEvent19: TNotifyEvent read FOnReservedEvent19 write FOnReservedEvent19;
    property OnReservedEvent20: TNotifyEvent read FOnReservedEvent20 write FOnReservedEvent20;
    property OnReservedEvent21: TNotifyEvent read FOnReservedEvent21 write FOnReservedEvent21;
    property OnReservedEvent22: TNotifyEvent read FOnReservedEvent22 write FOnReservedEvent22;
    property OnReservedEvent23: TNotifyEvent read FOnReservedEvent23 write FOnReservedEvent23;
    property OnReservedEvent24: TNotifyEvent read FOnReservedEvent24 write FOnReservedEvent24;
    property OnReservedEvent25: TNotifyEvent read FOnReservedEvent25 write FOnReservedEvent25;
    property OnReservedEvent26: TNotifyEvent read FOnReservedEvent26 write FOnReservedEvent26;
    property OnReservedEvent27: TNotifyEvent read FOnReservedEvent27 write FOnReservedEvent27;
    property OnReservedEvent28: TNotifyEvent read FOnReservedEvent28 write FOnReservedEvent28;
    property OnReservedEvent29: TNotifyEvent read FOnReservedEvent29 write FOnReservedEvent29;
    property OnReservedEvent30: TNotifyEvent read FOnReservedEvent30 write FOnReservedEvent30;
    property OnReservedEvent31: TNotifyEvent read FOnReservedEvent31 write FOnReservedEvent31;
    property OnReservedEvent32: TNotifyEvent read FOnReservedEvent32 write FOnReservedEvent32;
    property OnReservedEvent33: TNotifyEvent read FOnReservedEvent33 write FOnReservedEvent33;
    property OnReservedEvent34: TNotifyEvent read FOnReservedEvent34 write FOnReservedEvent34;
    property OnReservedEvent35: TNotifyEvent read FOnReservedEvent35 write FOnReservedEvent35;
    property OnReservedEvent36: TNotifyEvent read FOnReservedEvent36 write FOnReservedEvent36;
    property OnReservedEvent37: TNotifyEvent read FOnReservedEvent37 write FOnReservedEvent37;
    property OnReservedEvent38: TNotifyEvent read FOnReservedEvent38 write FOnReservedEvent38;
    property OnReservedEvent39: TNotifyEvent read FOnReservedEvent39 write FOnReservedEvent39;
    property OnreservedEvent40: TNotifyEvent read FOnreservedEvent40 write FOnreservedEvent40;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'valmet';

implementation

uses ComObj;

procedure TAvViewX.InitControlData;
const
  CEventDispIDs: array [0..39] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D, $0000000E, $0000000F, $00000010, $00000011, $00000012,
    $00000013, $00000014, $00000015, $00000016, $00000017, $00000018,
    $00000019, $0000001A, $0000001B, $0000001C, $0000001D, $0000001E,
    $0000001F, $00000020, $00000021, $00000022, $00000023, $00000024,
    $00000025, $00000026, $00000027, $00000028);
  CControlData: TControlData2 = (
    ClassID: '{8718C658-8956-11D2-BD21-0060B0A12A50}';
    EventIID: '{915602D6-6D0D-11D2-9205-0060B0870404}';
    EventCount: 40;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000008;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnProgress) - Cardinal(Self);
end;

procedure TAvViewX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IAvViewX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TAvViewX.GetControlInterface: IAvViewX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TAvViewX.Reserved26;
begin
  DefaultInterface.Reserved26;
end;

procedure TAvViewX.Reserved27;
begin
  DefaultInterface.Reserved27;
end;

procedure TAvViewX.Reserved28;
begin
  DefaultInterface.Reserved28;
end;

procedure TAvViewX.Reserved29;
begin
  DefaultInterface.Reserved29;
end;

procedure TAvViewX.Reserved30;
begin
  DefaultInterface.Reserved30;
end;

procedure TAvViewX.Reserved31;
begin
  DefaultInterface.Reserved31;
end;

procedure TAvViewX.Reserved32;
begin
  DefaultInterface.Reserved32;
end;

procedure TAvViewX.Reserved33;
begin
  DefaultInterface.Reserved33;
end;

procedure TAvViewX.Reserved34;
begin
  DefaultInterface.Reserved34;
end;

procedure TAvViewX.Reserved35;
begin
  DefaultInterface.Reserved35;
end;

procedure TAvViewX.Reserved36;
begin
  DefaultInterface.Reserved36;
end;

procedure TAvViewX.Reserved37;
begin
  DefaultInterface.Reserved37;
end;

procedure TAvViewX.Reserved38;
begin
  DefaultInterface.Reserved38;
end;

procedure TAvViewX.Reserved39;
begin
  DefaultInterface.Reserved39;
end;

procedure TAvViewX.Reserved40;
begin
  DefaultInterface.Reserved40;
end;

procedure TAvViewX.Reserved41;
begin
  DefaultInterface.Reserved41;
end;

procedure TAvViewX.Reserved42;
begin
  DefaultInterface.Reserved42;
end;

procedure TAvViewX.Reserved43;
begin
  DefaultInterface.Reserved43;
end;

procedure TAvViewX.Reserved44;
begin
  DefaultInterface.Reserved44;
end;

procedure TAvViewX.Reserved45;
begin
  DefaultInterface.Reserved45;
end;

procedure TAvViewX.Reserved46;
begin
  DefaultInterface.Reserved46;
end;

procedure TAvViewX.Reserved47;
begin
  DefaultInterface.Reserved47;
end;

procedure TAvViewX.Reserved48;
begin
  DefaultInterface.Reserved48;
end;

procedure TAvViewX.Reserved49;
begin
  DefaultInterface.Reserved49;
end;

procedure TAvViewX.Reserved50;
begin
  DefaultInterface.Reserved50;
end;

procedure TAvViewX.Reserved51;
begin
  DefaultInterface.Reserved51;
end;

procedure TAvViewX.Reserved52;
begin
  DefaultInterface.Reserved52;
end;

procedure TAvViewX.Reserved53;
begin
  DefaultInterface.Reserved53;
end;

procedure TAvViewX.Reserved54;
begin
  DefaultInterface.Reserved54;
end;

procedure TAvViewX.Reserved55;
begin
  DefaultInterface.Reserved55;
end;

procedure TAvViewX.Reserved56;
begin
  DefaultInterface.Reserved56;
end;

procedure TAvViewX.Reserved57;
begin
  DefaultInterface.Reserved57;
end;

procedure TAvViewX.Reserved58;
begin
  DefaultInterface.Reserved58;
end;

procedure TAvViewX.Reserved59;
begin
  DefaultInterface.Reserved59;
end;

procedure TAvViewX.Update;
begin
  DefaultInterface.Update;
end;

procedure TAvViewX.ShowLayersDialog;
begin
  DefaultInterface.ShowLayersDialog;
end;

procedure TAvViewX.ShowNamedViewsDialog;
begin
  DefaultInterface.ShowNamedViewsDialog;
end;

procedure TAvViewX.ShowLayoutsDialog;
begin
  DefaultInterface.ShowLayoutsDialog;
end;

procedure TAvViewX.ShowPrintDialog;
begin
  DefaultInterface.ShowPrintDialog;
end;

procedure TAvViewX.SetOleObjectHandler(const punk: IUnknown);
begin
  DefaultInterface.SetOleObjectHandler(punk);
end;

procedure TAvViewX.GetDrawingExtents(out left: Double; out right: Double; out bottom: Double; 
                                     out top: Double);
begin
  DefaultInterface.GetDrawingExtents(left, right, bottom, top);
end;

procedure TAvViewX.GetCurrentView(out left: Double; out right: Double; out bottom: Double; 
                                  out top: Double);
begin
  DefaultInterface.GetCurrentView(left, right, bottom, top);
end;

procedure TAvViewX.SetCurrentView(left: Double; right: Double; bottom: Double; top: Double);
begin
  DefaultInterface.SetCurrentView(left, right, bottom, top);
end;

procedure TAvViewX.ShowAboutDialog;
begin
  DefaultInterface.ShowAboutDialog;
end;

procedure TAvViewX._Configure3D;
begin
  DefaultInterface._Configure3D;
end;

procedure TAvViewX.InvokeURL(const url: WideString);
begin
  DefaultInterface.InvokeURL(url);
end;

procedure TAvViewX.ShowSaveAsDialog;
begin
  DefaultInterface.ShowSaveAsDialog;
end;

procedure TAvViewX.ShowOptionsDialog;
begin
  DefaultInterface.ShowOptionsDialog;
end;

procedure TAvViewX.GetDrawingFormat(const url: WideString; var resolvedUrl: WideString; 
                                    var pFormat: DrawingFormat);
begin
  DefaultInterface.GetDrawingFormat(url, resolvedUrl, pFormat);
end;

procedure TAvViewX.ShowSaveMarkupDialog;
begin
  DefaultInterface.ShowSaveMarkupDialog;
end;

procedure TAvViewX.SaveMarkup(const filename: WideString);
begin
  DefaultInterface.SaveMarkup(filename);
end;

function TAvViewX.ClearMarkup: WordBool;
begin
  Result := DefaultInterface.ClearMarkup;
end;

procedure TAvViewX.ZoomExtents;
begin
  DefaultInterface.ZoomExtents;
end;

procedure TAvViewX.Reserved79;
begin
  DefaultInterface.Reserved79;
end;

procedure TAvViewX.Reserved80;
begin
  DefaultInterface.Reserved80;
end;

procedure TAvViewX.Reserved81;
begin
  DefaultInterface.Reserved81;
end;

procedure TAvViewX.Reserved82;
begin
  DefaultInterface.Reserved82;
end;

procedure TAvViewX.Reserved83;
begin
  DefaultInterface.Reserved83;
end;

procedure TAvViewX.Reserved84;
begin
  DefaultInterface.Reserved84;
end;

procedure TAvViewX.Reserved85;
begin
  DefaultInterface.Reserved85;
end;

procedure TAvViewX.Reserved86;
begin
  DefaultInterface.Reserved86;
end;

procedure TAvViewX.Reserved87;
begin
  DefaultInterface.Reserved87;
end;

procedure TAvViewX.Reserved88;
begin
  DefaultInterface.Reserved88;
end;

procedure TAvViewX.Reserved89;
begin
  DefaultInterface.Reserved89;
end;

procedure TAvViewX.Reserved90;
begin
  DefaultInterface.Reserved90;
end;

procedure TAvViewX.Reserved91;
begin
  DefaultInterface.Reserved91;
end;

procedure TAvViewX.Reserved92;
begin
  DefaultInterface.Reserved92;
end;

procedure TAvViewX.Reserved93;
begin
  DefaultInterface.Reserved93;
end;

procedure TAvViewX.Reserved94;
begin
  DefaultInterface.Reserved94;
end;

procedure TAvViewX.Reserved95;
begin
  DefaultInterface.Reserved95;
end;

procedure TAvViewX.Reserved96;
begin
  DefaultInterface.Reserved96;
end;

procedure TAvViewX.Reserved97;
begin
  DefaultInterface.Reserved97;
end;

procedure TAvViewX.Reserved98;
begin
  DefaultInterface.Reserved98;
end;

procedure TAvViewX.Reserved99;
begin
  DefaultInterface.Reserved99;
end;

procedure TAvViewX.Reserved100;
begin
  DefaultInterface.Reserved100;
end;

procedure TAvViewX.Reserved101;
begin
  DefaultInterface.Reserved101;
end;

procedure TAvViewX.Reserved102;
begin
  DefaultInterface.Reserved102;
end;

procedure TAvViewX.Reserved103;
begin
  DefaultInterface.Reserved103;
end;

procedure TAvViewX.Reserved104;
begin
  DefaultInterface.Reserved104;
end;

procedure TAvViewX.Reserved105;
begin
  DefaultInterface.Reserved105;
end;

procedure TAvViewX.Reserved106;
begin
  DefaultInterface.Reserved106;
end;

procedure TAvViewX.Reserved107;
begin
  DefaultInterface.Reserved107;
end;

procedure TAvViewX.Reserved108;
begin
  DefaultInterface.Reserved108;
end;

procedure TAvViewX.Reserved109;
begin
  DefaultInterface.Reserved109;
end;

procedure TAvViewX.Reserved110;
begin
  DefaultInterface.Reserved110;
end;

procedure TAvViewX.Reserved111;
begin
  DefaultInterface.Reserved111;
end;

procedure TAvViewX.Reserved112;
begin
  DefaultInterface.Reserved112;
end;

procedure TAvViewX.Reserved113;
begin
  DefaultInterface.Reserved113;
end;

procedure TAvViewX.Reserved114;
begin
  DefaultInterface.Reserved114;
end;

procedure TAvViewX.Reserved115;
begin
  DefaultInterface.Reserved115;
end;

procedure TAvViewX.Reserved116;
begin
  DefaultInterface.Reserved116;
end;

procedure TAvViewX.Reserved117;
begin
  DefaultInterface.Reserved117;
end;

procedure TAvViewX.Reserved118;
begin
  DefaultInterface.Reserved118;
end;

procedure TAvViewX.Reserved119;
begin
  DefaultInterface.Reserved119;
end;

procedure TAvViewX.Reserved120;
begin
  DefaultInterface.Reserved120;
end;

procedure TAvViewX.Reserved121;
begin
  DefaultInterface.Reserved121;
end;

procedure TAvViewX.Reserved122;
begin
  DefaultInterface.Reserved122;
end;

procedure TAvViewX.Reserved123;
begin
  DefaultInterface.Reserved123;
end;

procedure TAvViewX.Reserved124;
begin
  DefaultInterface.Reserved124;
end;

procedure TAvViewX.Reserved125;
begin
  DefaultInterface.Reserved125;
end;

procedure TAvViewX.Reserved126;
begin
  DefaultInterface.Reserved126;
end;

procedure TAvViewX.Reserved127;
begin
  DefaultInterface.Reserved127;
end;

procedure TAvViewX.Reserved128;
begin
  DefaultInterface.Reserved128;
end;

procedure TAvViewX.Reserved129;
begin
  DefaultInterface.Reserved129;
end;

procedure TAvViewX.Reserved130;
begin
  DefaultInterface.Reserved130;
end;

procedure TAvViewX.Reserved131;
begin
  DefaultInterface.Reserved131;
end;

procedure TAvViewX.Reserved132;
begin
  DefaultInterface.Reserved132;
end;

procedure TAvViewX.Reserved133;
begin
  DefaultInterface.Reserved133;
end;

procedure TAvViewX.Reserved134;
begin
  DefaultInterface.Reserved134;
end;

procedure TAvViewX.Reserved135;
begin
  DefaultInterface.Reserved135;
end;

procedure TAvViewX.Reserved136;
begin
  DefaultInterface.Reserved136;
end;

procedure TAvViewX.Reserved137;
begin
  DefaultInterface.Reserved137;
end;

procedure TAvViewX.Reserved138;
begin
  DefaultInterface.Reserved138;
end;

procedure TAvViewX.Reserved139;
begin
  DefaultInterface.Reserved139;
end;

procedure TAvViewX.Reserved140;
begin
  DefaultInterface.Reserved140;
end;

procedure TAvViewX.Reserved141;
begin
  DefaultInterface.Reserved141;
end;

procedure TAvViewX.Reserved142;
begin
  DefaultInterface.Reserved142;
end;

procedure TAvViewX.Reserved143;
begin
  DefaultInterface.Reserved143;
end;

procedure TAvViewX.Reserved144;
begin
  DefaultInterface.Reserved144;
end;

procedure TAvViewX.Reserved145;
begin
  DefaultInterface.Reserved145;
end;

procedure TAvViewX.Reserved146;
begin
  DefaultInterface.Reserved146;
end;

procedure TAvViewX.Reserved147;
begin
  DefaultInterface.Reserved147;
end;

procedure TAvViewX.Reserved148;
begin
  DefaultInterface.Reserved148;
end;

procedure TAvViewX.Reserved149;
begin
  DefaultInterface.Reserved149;
end;

procedure TAvViewX.Reserved150;
begin
  DefaultInterface.Reserved150;
end;

procedure TAvViewX.Reserved151;
begin
  DefaultInterface.Reserved151;
end;

procedure TAvViewX.Reserved152;
begin
  DefaultInterface.Reserved152;
end;

procedure TAvViewX.Reserved153;
begin
  DefaultInterface.Reserved153;
end;

procedure TAvViewX.Reserved154;
begin
  DefaultInterface.Reserved154;
end;

procedure TAvViewX.Reserved155;
begin
  DefaultInterface.Reserved155;
end;

procedure TAvViewX.Reserved156;
begin
  DefaultInterface.Reserved156;
end;

procedure TAvViewX.Reserved157;
begin
  DefaultInterface.Reserved157;
end;

procedure TAvViewX.Reserved158;
begin
  DefaultInterface.Reserved158;
end;

procedure TAvViewX.Reserved159;
begin
  DefaultInterface.Reserved159;
end;

procedure TAvViewX.Reserved160;
begin
  DefaultInterface.Reserved160;
end;

procedure TAvViewX.Reserved161;
begin
  DefaultInterface.Reserved161;
end;

procedure TAvViewX.Reserved162;
begin
  DefaultInterface.Reserved162;
end;

procedure TAvViewX.Reserved163;
begin
  DefaultInterface.Reserved163;
end;

procedure TAvViewX.Reserved164;
begin
  DefaultInterface.Reserved164;
end;

procedure TAvViewX.Reserved165;
begin
  DefaultInterface.Reserved165;
end;

procedure TAvViewX.Reserved166;
begin
  DefaultInterface.Reserved166;
end;

procedure TAvViewX.Reserved167;
begin
  DefaultInterface.Reserved167;
end;

procedure TAvViewX.Reserved168;
begin
  DefaultInterface.Reserved168;
end;

procedure TAvViewX.Reserved169;
begin
  DefaultInterface.Reserved169;
end;

procedure TAvViewX.Reserved170;
begin
  DefaultInterface.Reserved170;
end;

procedure TAvViewX.Reserved171;
begin
  DefaultInterface.Reserved171;
end;

procedure TAvViewX.Reserved172;
begin
  DefaultInterface.Reserved172;
end;

procedure TAvViewX.Reserved173;
begin
  DefaultInterface.Reserved173;
end;

procedure TAvViewX.Reserved174;
begin
  DefaultInterface.Reserved174;
end;

procedure TAvViewX.Reserved175;
begin
  DefaultInterface.Reserved175;
end;

procedure TAvViewX.Reserved176;
begin
  DefaultInterface.Reserved176;
end;

procedure TAvViewX.Reserved177;
begin
  DefaultInterface.Reserved177;
end;

procedure TAvViewX.Reserved178;
begin
  DefaultInterface.Reserved178;
end;

procedure TAvViewX.Reserved179;
begin
  DefaultInterface.Reserved179;
end;

procedure TAvViewX.Reserved180;
begin
  DefaultInterface.Reserved180;
end;

procedure TAvViewX.Reserved181;
begin
  DefaultInterface.Reserved181;
end;

procedure TAvViewX.Reserved182;
begin
  DefaultInterface.Reserved182;
end;

procedure TAvViewX.Reserved183;
begin
  DefaultInterface.Reserved183;
end;

procedure TAvViewX.Reserved184;
begin
  DefaultInterface.Reserved184;
end;

procedure TAvViewX.Reserved185;
begin
  DefaultInterface.Reserved185;
end;

procedure TAvViewX.Reserved186;
begin
  DefaultInterface.Reserved186;
end;

procedure TAvViewX.Reserved187;
begin
  DefaultInterface.Reserved187;
end;

procedure TAvViewX.Reserved188;
begin
  DefaultInterface.Reserved188;
end;

procedure TAvViewX.Reserved189;
begin
  DefaultInterface.Reserved189;
end;

procedure TAvViewX.Reserved190;
begin
  DefaultInterface.Reserved190;
end;

procedure TAvViewX.Reserved191;
begin
  DefaultInterface.Reserved191;
end;

procedure TAvViewX.Reserved192;
begin
  DefaultInterface.Reserved192;
end;

procedure TAvViewX.Reserved193;
begin
  DefaultInterface.Reserved193;
end;

procedure TAvViewX.Reserved194;
begin
  DefaultInterface.Reserved194;
end;

procedure TAvViewX.Reserved195;
begin
  DefaultInterface.Reserved195;
end;

procedure TAvViewX.Reserved200;
begin
  DefaultInterface.Reserved200;
end;

procedure Register;
begin
  RegisterComponents('valmet',[TAvViewX]);
end;

end.
