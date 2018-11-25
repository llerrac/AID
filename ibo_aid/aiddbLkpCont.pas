unit aiddbLkpCont;

{
  aiddbLkpCont
    Contracts Lookup component

  see also crdbCal, valdblkpBOM, aiddbLkpPart
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, db,
  crdbEdit, crdbEd, crBtn,
  IB_Components, aidTypes;

type
  TvalLookedUpContEvent = procedure(Sender: TObject; DataSource: TDataSource; ContDef: TvalContDef) of object;
type
  TvaldbLookupCont = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpContEvent: TvalLookedUpContEvent;
    FDatabase: TIB_connection;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpContEvent(const Value: TvalLookedUpContEvent);
    procedure DoLookedUpContEvent(AValue: TvalContDef);
    procedure SetDatabase(const Value: TIB_connection);
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
    property    Database           : TIB_connection           read FDatabase            write SetDatabase;
    property    OnLookedUpContEvent: TvalLookedUpContEvent read FOnLookedUpContEvent write SetOnLookedUpContEvent;
  end;
  TaiddbLookupCont = class(TvaldbLookupCont);


var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;

implementation

uses
  f_Cont;

constructor TvaldbLookupCont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect    := False;
  ButtonVisible := True;
  ButtonStyle   := crbsDropDown;
  OnButtonClick := ButtonClicked;
  CharCase      := ecUpperCase;
  Width         := 86;
  // CGR 200103 History
  HistoryGroup  := 'CONTRACT';
  OnHistoryLoad := aiddbLkpCont.OnHistoryLoad;
  OnHistoryStore:= aiddbLkpCont.OnHistoryStore;
end;

procedure TvaldbLookupCont.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupCont.DropDown;
var
  ContDef : TvalContDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      ContDef.ContNo:= Field.AsString;
      //
      CheckDatabase;
      //
      ContDef.Found := True;
      if f_Cont .Execute(Database, ContDef) then
      begin
{        DataSource.Edit;
        Field.AsString:= ContDef.ContNo;}
        UpdateFieldText(ContDef.ContNo);
        ContDef.Found := True;
        DoLookedUpContEvent(ContDef);
      end;
    end;
end;



procedure TvaldbLookupCont.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TvaldbLookupCont.SetOnLookedUpContEvent(const Value: TvalLookedUpContEvent);
begin
  FOnLookedUpContEvent := Value;
end;

procedure TvaldbLookupCont.DoLookedUpContEvent(AValue: TvalContDef);
begin
  if Assigned(OnLookedUpContEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpContEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupCont.SetDatabase(const Value: TIB_connection);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupCont.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;

procedure TvaldbLookupCont.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');    
end;

end.
