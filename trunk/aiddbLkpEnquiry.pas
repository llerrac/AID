unit aiddbLkpEnquiry;

(*******************************************************************************
created by    :ajc
created on    :2010Mar17
Purpose       : lookup enquiries

Comments      :


*******************************************************************************)
{ -------------------------------------------------------------------------------------------------
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
  TvaldbLookupEnquiry = class(TcrdbCustomBtnEdit)
  private
    FOnLookedUpCompEvent : TvalLookedUpPurchEvent;
    FDatabase            : TIBDatabase;
    { Private declarations }
    procedure ButtonClicked(Sender: TObject);
    procedure SetOnLookedUpCompEvent(const Value: TvalLookedUpPurchEvent);
    procedure DoLookedUpCompEvent(AValue: TvalPurchDef);
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
    property    OnLookedUpCompEvent : TvalLookedUpPurchEvent read FOnLookedUpCompEvent write SetOnLookedUpCompEvent;
  end;
  TaiddbLookupEnquiry = class(TvaldbLookupEnquiry);

var
  OnHistoryLoad  : TcrDBEditLoadHistoryEvent;
  OnHistoryStore : TcrDBEditStoreHistoryEvent;

implementation

uses
  f_PoEnqItem;

constructor TvaldbLookupEnquiry.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSelect   := False;
  ButtonVisible:= True;
  ButtonStyle  := crbsDropDown;
  OnButtonClick:= ButtonClicked;
  CharCase     := ecUpperCase;
  Width        := 86;
  // History
  HistoryGroup := 'ENQUIRY';
  OnHistoryLoad := aiddbLkpEnquiry  .OnHistoryLoad;
  OnHistoryStore:= aiddbLkpEnquiry  .OnHistoryStore;
end;

procedure TvaldbLookupEnquiry.ButtonClicked(Sender: TObject);
begin
  if Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TvaldbLookupEnquiry.DropDown;
var
  EnqDef : TvalPurchDef;
begin
  if Assigned(Field) and Assigned(DataSource) then
    if (DataSource.State <> dsInactive) then
    begin
      UpdateFieldDatalink;
      EnqDef.TranNo  := Field.AsString;
      //
      CheckDatabase;
      //
      if f_PoEnqItem .Execute( Database, EnqDef,'') then
      begin
        DataSource.Edit;
        Field.AsString:= EnqDef.TranNo;
        //
        DoLookedUpCompEvent(EnqDef);
        DoHistoryStore(EnqDef.TranNo);
      end;
    end;
end;



procedure TvaldbLookupEnquiry.KeyDown(var Key: Word; Shift: TShiftState);
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

procedure TvaldbLookupEnquiry.SetOnLookedUpCompEvent(const Value: TvalLookedUpPurchEvent);
begin
  FOnLookedUpCompEvent := Value;
end;



procedure TvaldbLookupEnquiry.DoLookedUpCompEvent(AValue: TvalPurchDef);
begin
  if Assigned(OnLookedUpCompEvent) then
  begin
    if Assigned(DataSource) then
      OnLookedUpCompEvent(Self, DataSource, AValue);
  end;
end;

procedure TvaldbLookupEnquiry.SetDatabase(const Value: TIBDatabase);
begin
  FDatabase := Value;
end;

procedure TvaldbLookupEnquiry.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent = Database) then
    Database:= nil;
end;


procedure TvaldbLookupEnquiry.CheckDatabase;
begin
  if not Assigned(Database) then
    raise Exception.Create(Name+' - Missing Database property');
end;



initialization
  OnHistoryLoad := nil;
  OnHistoryStore:= nil;

end.
