unit aiddbLkpPart;

{ --------------------------------------------------------------------------------------------------
  name        : aiddbLkpPart
  author      : Chris G. Royle
  description : Part Lookup Component.
  note        : Inherits from crdbEdit .TcrdbCustomBtnEdit, which introduces history behaviour.
  see also    : crdbCal, f_Part
  modified    :

  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Classes,
  db, IBDatabase,
  { Application Units }
  crdbEdit, crdbEd, crBtn,
  aidTypes;

type
  TvalPartLkpOption     = (valloPromptForAddIfUnknown, valPromptIfReplaced, valloAdministrative);
  TvalPartLkpOptions    = set of TvalPartLkpOption;

type
  TvaldbLookupPart = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpPartEvent: TvalLookedUpPartEvent;
    FDescField          : string;
    FOptions            : TvalPartLkpOptions;
    FDatabase           : TIBDatabase;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpPartEvent(const Value: TvalLookedUpPartEvent);
    procedure DoLookedUpPartEvent(AValue: TvalPartDef);
    procedure SetDescField(const Value: string);
    procedure SetOptions(const Value: TvalPartLkpOptions);
    procedure SetDatabase(const Value: TIBDatabase);
    procedure CheckDatabase;
  protected
    { Protected declarations }
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure   DropDown;
  published
    { Published declarations }
    property Database           : TIBDatabase           read FDatabase            write SetDatabase;
    property DescField          : String                read FDescField write SetDescField;
    property Options: TvalPartLkpOptions read FOptions write SetOptions;
    property OnLookedUpPartEvent: TvalLookedUpPartEvent read FOnLookedUpPartEvent write SetOnLookedUpPartEvent;
  end;
  TaiddbLookupPart = class(TvaldbLookupPart);

  // Standard formatting for part cost & sell prices
  function PartFormattedPrice(Sender: TField; DisplayText: Boolean; PartHasParameter: Boolean): string;

var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;
  OnGetPartInfo  : TvalPartOnGetPartInfoEvent;

implementation

uses
  { Delphi Units }
  Windows, SysUtils, StdCtrls,
  { Application Units }
  f_Part;

function PartFormattedPrice(Sender: TField; DisplayText: Boolean; PartHasParameter: Boolean): string;
begin
  if DisplayText then
    if PartHasParameter then
      Result:= '<param>'
    else
      Result:= FormatFloat(',0.00', Sender.AsFloat)
  else
    Result:=   FormatFloat( '0.00', Sender.AsFloat);
end;



constructor TvaldbLookupPart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect   := False;
  ButtonVisible:= True;
  ButtonStyle  := crbsDropDown;
  OnButtonClick:= ButtonClicked;
  CharCase     := ecUpperCase;
  Width        := 86;
  // CGR 200103 History
  HistoryGroup := 'PART';
  OnHistoryLoad := aiddbLkpPart .OnHistoryLoad;
  OnHistoryStore:= aiddbLkpPart .OnHistoryStore;
end;

procedure TvaldbLookupPart.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupPart.DropDown;
var
  PartDef : TvalPartDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      PartDef.PartNo    := Field.AsString;
      PartDef.PartParam := '';
      //
      CheckDatabase;
      //
      if f_Part .Execute(Database, PartDef, Options) then
      begin
        UpdateFieldText(PartDef.PartNo);
        DoLookedUpPartEvent(PartDef);
      end;
    end;
end;



procedure TvaldbLookupPart.KeyDown(var Key: Word; Shift: TShiftState);
var
  Opt: TvalPartLkpOptions;
begin
  // Enact dropdown
  case Key of
    VK_SPACE,
    VK_DOWN:
    begin
    // Disable prompt for new here
      Opt:= Self.Options;
      Self.Options:= Self.Options - [valloPromptForAddIfUnknown];
      DropDown;
      Key:= 0;
      Self.Options:= Opt;
    end;
  end;

  inherited;
end;

procedure TvaldbLookupPart.SetOnLookedUpPartEvent(const Value: TvalLookedUpPartEvent);
begin
  FOnLookedUpPartEvent := Value;
end;

procedure TvaldbLookupPart.DoLookedUpPartEvent(AValue: TvalPartDef);
begin
  if Assigned(OnLookedUpPartEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpPartEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupPart.SetDescField(const Value: string);
begin
  FDescField := Value;
end;


procedure TvaldbLookupPart.SetOptions(const Value: TvalPartLkpOptions);
begin
  FOptions := Value;
end;

procedure TvaldbLookupPart.SetDatabase(const Value: TIBDatabase);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupPart.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;

procedure TvaldbLookupPart.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');
end;

initialization
  OnHistoryLoad := nil;
  OnHistoryStore:= nil;
  OnGetPartInfo := nil;

end.
