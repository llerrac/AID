unit aiddbLkpPurch;

{
  aiddbLkpPurch
    Purchs Lookup component

  see also crdbCal, valTypes (TvalPurchDef)
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, db,
  crdbEdit, crdbEd, crBtn,
  IBDatabase, aidTypes;

type
  TvaldbLookupPurch = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpPurchEvent: TvalLookedUpPurchEvent;
    FDatabase: TIBDatabase;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpPurchEvent(const Value: TvalLookedUpPurchEvent);
    procedure DoLookedUpPurchEvent(AValue: TvalPurchDef);
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
    property    Database            : TIBDatabase           read FDatabase            write SetDatabase;
    property    OnLookedUpPurchEvent: TvalLookedUpPurchEvent read FOnLookedUpPurchEvent write SetOnLookedUpPurchEvent;
  end;
  TaiddbLookupPurch = class(TvaldbLookupPurch);


var
  LkpUser,
  LkpPurchStatus : TDataSet;
  // CGR 20010312 History
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;


implementation

uses
  f_Purch;

constructor TvaldbLookupPurch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect    := False;
  ButtonVisible := True;
  ButtonStyle   := crbsDropDown;
  OnButtonClick := ButtonClicked;
  CharCase      := ecUpperCase;
  Width         := 96;
  // CGR 200103 History
  HistoryGroup := 'PURCHASE';
  OnHistoryLoad := aiddbLkpPurch.OnHistoryLoad;
  OnHistoryStore:= aiddbLkpPurch.OnHistoryStore;
end;

procedure TvaldbLookupPurch.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupPurch.DropDown;
var
  PurchDef : TvalPurchDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      PurchDef.TranNo:= Field.AsString;
      //
      CheckDatabase;
      //
      if f_Purch .Execute(Database, PurchDef, LkpUser, LkpPurchStatus) then
      begin
        DataSource.Edit;
        Field.AsString:= PurchDef.TranNo;
        DoLookedUpPurchEvent(PurchDef);
        DoHistoryStore(PurchDef.TranNo);
      end;
    end;
end;



procedure TvaldbLookupPurch.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TvaldbLookupPurch.SetOnLookedUpPurchEvent(const Value: TvalLookedUpPurchEvent);
begin
  FOnLookedUpPurchEvent := Value;
end;

procedure TvaldbLookupPurch.DoLookedUpPurchEvent(AValue: TvalPurchDef);
begin
  if Assigned(OnLookedUpPurchEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpPurchEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupPurch.SetDatabase(const Value: TIBDatabase);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupPurch.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;

procedure TvaldbLookupPurch.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');    
end;

end.
