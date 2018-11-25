unit aiddbLkpBOM;

{ --------------------------------------------------------------------------------------------------------
  name        : aiddbLkpBom
  author      : Chris G. Royle, 2001
  description : A visual component for entering BOM numbers, with the ability to launch a find dialog.
  see also    : dataBOM.sql
  modified    :
    CGR20060111 Renamed TvalBOMDef to TaidBOMDef
  --------------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Classes,
  db,
  { Application Units }
  crdbEdit, crdbEd, crBtn,
  IB_Components;

type
  TaidBOMDef = record
    BOMNo    : string;  { VarChar(10) }
    BOMDesc  : string;  { VarChar(50) }
  end;
  TvalBOMDef = TaidBOMDef;
type
  TvalLookedUpBOMEvent = procedure(Sender: TObject; DataSource: TDataSource; ArBOMDef: TaidBOMDef) of object;
type
  TvaldbLookupBOM = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpBOMEvent: TvalLookedUpBOMEvent;
    FDatabase: tib_connection;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpBOMEvent(const Value: TvalLookedUpBOMEvent);
    procedure DoLookedUpBOMEvent(AValue: TvalBOMDef);
    procedure SetDatabase(const Value: tib_connection);
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
    property    Database            : tib_connection           read FDatabase            write SetDatabase;
    property    OnLookedUpBOMEvent: TvalLookedUpBOMEvent read FOnLookedUpBOMEvent write SetOnLookedUpBOMEvent;
  end;
  TAiddbLookupBOM = class(TValdbLookupBOM);


var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;

implementation

uses
  { Delphi Units }
  StdCtrls, SysUtils,
  { Application Units }
  f_BOM;


constructor TvaldbLookupBOM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect   := False;
  ButtonVisible:= True;
  ButtonStyle:= crbsDropDown;
  OnButtonClick:= ButtonClicked;
  CharCase     := stdCtrls.ecUpperCase;
  Width        := 86;
  // CGR 200103 History
  HistoryGroup := 'BOM';
  OnHistoryLoad := aiddbLkpBOM.OnHistoryLoad;
  OnHistoryStore:= aiddbLkpBOM.OnHistoryStore;
end;

procedure TvaldbLookupBOM.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupBOM.DropDown;
var
  BOMDef : TvalBOMDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      BOMDef.BOMNo:= Field.AsString;
      //
      CheckDatabase;
      //
      if f_BOM.Execute(Database, BOMDef) then
      begin
        Self.UpdateFieldText(BOMDef.BOMNo);
        DoLookedUpBOMEvent(BOMDef);
      end;
    end;
end;



procedure TvaldbLookupBOM.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TvaldbLookupBOM.SetOnLookedUpBOMEvent(const Value: TvalLookedUpBOMEvent);
begin
  FOnLookedUpBOMEvent := Value;
end;

procedure TvaldbLookupBOM.DoLookedUpBOMEvent(AValue: TvalBOMDef);
begin
  if Assigned(OnLookedUpBOMEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpBOMEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupBOM.SetDatabase(const Value: tib_connection);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupBOM.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;

procedure TvaldbLookupBOM.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');
end;

end.
