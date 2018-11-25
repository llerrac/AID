unit aiddbLkpComp;

{ -------------------------------------------------------------------------------------------------
  name        : aiddbLkpComp
  description : Companies lookup
  see also    : aiddbLkpPart crdbCal
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, db,
  IBDatabase,
  { Application Units }
  crdbEdit, crdbEd, crBtn,
  aidTypes;

type
  TvaldbLookupCompany = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpCompEvent : TvalLookedUpCompEvent;
    FDatabase            : TIBDatabase;
    FIsSupplier,
    FIsTransporter,
    FIsCustomer,
    FIsMarketing,
    FIsLMO,
    FIsAgent             : Boolean;
    FCountryNo           : String;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpCompEvent(const Value: TvalLookedUpCompEvent);
    procedure DoLookedUpCompEvent(AValue: TvalCompDef);
    procedure SetDatabase(const Value: TIBDatabase);
    procedure CheckDatabase;
    procedure SetIsAgent(const Value: Boolean);
    procedure SetIsCustomer(const Value: Boolean);
    procedure SetIsLMO(const Value: Boolean);
    procedure SetIsMarketing(const Value: Boolean);
    procedure SetIsSupplier(const Value: Boolean);
    procedure SetIsTransporter(const Value: Boolean);
    procedure SetCountryNo(const Value: String);
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
    property    Database            : TIBDatabase           read FDatabase            write SetDatabase;
    property    OnLookedUpCompEvent : TvalLookedUpCompEvent read FOnLookedUpCompEvent write SetOnLookedUpCompEvent;
    property    IsSupplier          : Boolean               read FIsSupplier          write SetIsSupplier;
    property    IsTransporter       : Boolean               read FIsTransporter       write SetIsTransporter;
    property    IsCustomer          : Boolean               read FIsCustomer          write SetIsCustomer;
    property    IsMarketing         : Boolean               read FIsMarketing         write SetIsMarketing;
    property    IsAgent             : Boolean               read FIsAgent             write SetIsAgent;
    property    IsLMO               : Boolean               read FIsLMO               write SetIsLMO;
    property    CountryNo           : String                read FCountryNo           write SetCountryNo;
  end;
  TaiddbLookupCompany = class(TvaldbLookupCompany);

var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;

implementation

uses
  f_Comp;

constructor TvaldbLookupCompany.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect   := False;
  ButtonVisible:= True;
  ButtonStyle  := crbsDropDown;
  OnButtonClick:= ButtonClicked;
  CharCase     := ecUpperCase;
  Width        := 86;
  // History
  HistoryGroup := 'COMPANY';
  OnHistoryLoad := aiddbLkpComp.OnHistoryLoad;
  OnHistoryStore:= aiddbLkpComp.OnHistoryStore;
end;

procedure TvaldbLookupCompany.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupCompany.DropDown;
var
  CompDef : TvalCompDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      CompDef.CompNo:= Field.AsString;
      //
      CheckDatabase;
      //
      if f_Comp .Execute( Database, CompDef, FIsSupplier, FIsTransporter, FIsCustomer,
                         FIsMarketing, FIsAgent, FCountryNo ) then
      begin
        DataSource.Edit;
        Field.AsString:= CompDef.CompNo;
        //
        DoLookedUpCompEvent(CompDef);
        DoHistoryStore(CompDef.CompNo);
      end;
    end;
end;



procedure TvaldbLookupCompany.KeyDown(var Key: Word; Shift: TShiftState);
begin
  // Enact dropdown
  case Key of
    VK_SPACE,
    VK_DOWN:
    begin
      DropDown;
      Key:= 0;
    end;
  end;
  inherited;
end;

procedure TvaldbLookupCompany.SetOnLookedUpCompEvent(const Value: TvalLookedUpCompEvent);
begin
  FOnLookedUpCompEvent := Value;
end;

procedure TvaldbLookupCompany.SetIsSupplier( const Value : Boolean );
begin
  FIsSupplier := Value;
end;

procedure TvaldbLookupCompany.SetIsTransporter( const Value : Boolean );
begin
  FIsTransporter := Value;
end;

procedure TvaldbLookupCompany.SetIsCustomer( const Value : Boolean );
begin
  FIsCustomer := Value;
end;

procedure TvaldbLookupCompany.SetIsMarketing( const Value : Boolean );
begin
  FIsMarketing := Value;
end;

procedure TvaldbLookupCompany.SetIsAgent( const Value : Boolean );
begin
  FIsAgent := Value;
end;


procedure TvaldbLookupCompany.DoLookedUpCompEvent(AValue: TvalCompDef);
begin
  if Assigned(OnLookedUpCompEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpCompEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupCompany.SetDatabase(const Value: TIBDatabase);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupCompany.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;


procedure TvaldbLookupCompany.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');
end;

procedure TvaldbLookupCompany.SetCountryNo(const Value: String);
begin
  FCountryNo := Value;
end;

procedure TvaldbLookupCompany.SetIsLMO(const Value: Boolean);
begin
  FIsLMO := Value;
end;

initialization
  OnHistoryLoad := nil;
  OnHistoryStore:= nil;

end.
