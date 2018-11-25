unit aiddbLkpAssm;

{
  aiddbLkpAssm
    BOMs Lookup component

  see also crdbCal
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, db,
  crdbEdit, crdbEd, crBtn,
  IB_Components;

type
  TvalAssmDef = record
    ItemNo    : string;
    ItemType  : string;
    ItemDesc  : string;
  end;

type
  TvalLookedUpAssmEvent = procedure(Sender: TObject; DataSource: TDataSource; AssmDef: TvalAssmDef) of object;

type
  TvaldbLookupAssm = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpBOMEvent: TvalLookedUpAssmEvent;
    FDatabase: tib_connection;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpBOMEvent(const Value: TvalLookedUpAssmEvent);
    procedure DoLookedUpBOMEvent(AValue: TvalAssmDef);
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
    property    OnLookedUpBOMEvent: TvalLookedUpAssmEvent read FOnLookedUpBOMEvent write SetOnLookedUpBOMEvent;
  end;
  TaiddbLookupAssm = class(TvaldbLookupAssm);

var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;

implementation

uses
  f_Assm;


constructor TvaldbLookupAssm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect   := False;
  ButtonVisible:= True;
  ButtonStyle  := crbsDropDown;
  OnButtonClick:= ButtonClicked;
  CharCase     := ecUpperCase;
  Width        := 86;
  // CGR 20010628 History
  HistoryGroup := 'ASM';
  OnHistoryLoad := aiddbLkpAssm.OnHistoryLoad;
  OnHistoryStore:= aiddbLkpAssm.OnHistoryStore;
end;

procedure TvaldbLookupAssm.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupAssm.DropDown;
var
  AssmDef : TvalAssmDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      AssmDef.ItemNo:= Field.AsString;
      //
      CheckDatabase;
      //
      if f_Assm .Execute(Database, AssmDef) then
      begin
        DataSource.Edit;
        Field.AsString:= AssmDef.ItemNo;
        DoLookedUpBOMEvent(AssmDef);
      end;
    end;
end;



procedure TvaldbLookupAssm.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TvaldbLookupAssm.SetOnLookedUpBOMEvent(const Value: TvalLookedUpAssmEvent);
begin
  FOnLookedUpBOMEvent := Value;
end;

procedure TvaldbLookupAssm.DoLookedUpBOMEvent(AValue: TvalAssmDef);
begin
  if Assigned(OnLookedUpBOMEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpBOMEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupAssm.SetDatabase(const Value: tib_connection);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupAssm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;

procedure TvaldbLookupAssm.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');    
end;

end.
