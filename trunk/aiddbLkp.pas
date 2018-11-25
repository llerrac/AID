unit aiddbLkp;

{ -------------------------------------------------------------------------------------------------
  Name        : aiddbLkp
  Author      : Chris G. Royle (20061213)
  Description : Base class for enhanced data lookup controls for BOMs. These descend from StdCtrls.TCustomComboBox.
  Note        :
  Todo        : Work out how to extend the keyboard keypress delay code.
  See Also    : crdbLkp
  Modified    :
    CGR20061229, Added an ApplyChangeImmediately property which improves filtered searching dialogs.
    CGR20070110, Implemented the ChangeScale method for the ItemIndex property.
    CGR20070117, Modified to clearly render controls which have the Enabled property set to false.
    CGR20070119, Added a public DropDownWidth property.
    CGR20070123, Added protected LookupList() function, and protected CheckPopulateList() method so
      that descendents can search the lookup cache.
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Windows, Messages, StdCtrls, Types, Classes, Controls, Graphics,
  DB, DBCtrls,
  { 3rd Party Units }

  { Application Units }
  crdbLkp, crDlgFnd, aidTypes;

type
  TaiddbLookupListPopulateItems = procedure(Sender: TObject; const LookupID: TLookupID; Items: TStrings; AbForcedRefresh: Boolean) of object;

type
  TaiddbCustomLookupList     = class;
  TaiddbCustomLookupListItem = class;
  TaiddbLookupListFilterItem = function(Sender: TObject; const AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean of object;

  TaiddbCustomLookupListItem = class(TObject)
  private
  protected
    procedure DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState); virtual;
  public
  end;

  { TaiddbCustomLookupList
      Base class for the ComboBox based Atlas lookup components.

    The component stores a list of lookup
  }
  TaiddbCustomLookupList = class(TCustomComboBox)
  private
    { Private declarations }
    FbNeedToPopulate  : Boolean;
    FoDataLink        : TFieldDataLink;
    FbUpdPending      : Boolean;
    FoLookupList      : TStringList;
    FiLookupID        : TLookupID;
    FOnLoadListItems  : TaiddbLookupListPopulateItems;
    FOnFilterItem     : TaiddbLookupListFilterItem;
    FApplyChangeImmediately: Boolean;
    FsLastFilteredValue : String;
    FSearchText         : string;

    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    function  GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
    function  GetDataField: string;
    procedure SetDataField(const Value : string);
    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDatasource);
    function  GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetOnLoadListItems(const Value: TaiddbLookupListPopulateItems);
    procedure ApplyFiltersToLookupList(AsKeyValue: String);
    procedure UpdateListSelection(AsKeyValue: String);

    procedure ClearField;
    function  Field: TField;

    procedure SetLookupID(const Value: TLookupID);
    procedure SetOnFilterItem(const Value: TaiddbLookupListFilterItem);
    procedure SetApplyChangeImmediately(const Value: Boolean);

    function  GetDropDownWidth(): Integer;
    procedure SetDropDownWidth(AValue: Integer);

  protected
    { Protected declarations }
    procedure CreateWnd; override;

    procedure WMDestroy(var Msg : TWMDestroy); message WM_DESTROY;
    procedure WMDeleteItem(var Msg : TWMDeleteItem); message WM_DELETEITEM;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure FreeAndClearLookupList();
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure KeyDown ( var Key: word; shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    {}
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean); virtual;
    function  DoFilterItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; virtual;
    { PopulateList()
        Populates the underlying lookup information. }
    procedure PopulateList(AbForcedRefresh: Boolean);
    { CheckPopulateList()
        Calls PopulateList if FbNeedToPopulate indicates that this is required. }
    procedure CheckPopulateList(); virtual;
    {}
    procedure UserSelectedRefresh(); virtual;
    procedure InvalidateLookupList(AbForcedRefresh: Boolean = False); virtual;
    { LookupItemForKey()
        Returns the lookup object for a given key.
        Compound key descendants should override this. }
    function  LookupItemForKey(AoLookupList: TStringList; const AsKey: String): TaiddbCustomLookupListItem; virtual;
    {}
    procedure DropDownList();
    procedure CloseUpList();
    function  IsEnabled(): Boolean;
    {}
    function  CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean; virtual;
    function  AllowDuplicates: Boolean; virtual;
    { LookupList()
        Returns the lookup cache. }
    function  LookupList(): TStringList; virtual;
    {}
    property  SelectedItem  : string      read GetSelectedItem  write SetSelectedItem;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   ChangeScale(M, D: Integer); override;
    {}
    procedure RefreshLookup();
    { ApplyChangeImmediately
        If this property is set, the change will be update applied to the dataset immediately when selected from
        the drop-down list. If this is not set, then the change is applied when the control loses focus. Applying the
        update immediately is useful for filter controls which are reacted to immediately. }
    property  ApplyChangeImmediately: Boolean read FApplyChangeImmediately write SetApplyChangeImmediately default False;
    { DataField
        Field Name of the bound datafield. }
    property  DataField      : string       read GetDataField write SetDataField;
    { DataSource
        Datasource property }
    property  DataSource     : TDataSource  read GetDataSource write SetDataSource;
    { DropDownWidth }
    property  DropDownWidth : Integer       read GetDropDownWidth write SetDropDownWidth default 0;
    { LookupID
        This property is intended to be able to differentiate lookup components when using
        common events - similar to a Tag property. This is NOT an enumerated property to
        allow for re-use of the component in other applications. }
    property  LookupID       : TLookupID   read FiLookupID write SetLookupID;
    property SearchText: string read FSearchText write FSearchText;
    { ReadOnly
        Control is read-only ? }
    property  ReadOnly       : Boolean     read GetReadOnly      write SetReadOnly default false;
  published
    property OnLoadListItems: TaiddbLookupListPopulateItems     read FOnLoadListItems write SetOnLoadListItems;
    property OnFilterItem   : TaiddbLookupListFilterItem        read FOnFilterItem    write SetOnFilterItem;
  end;

var
  GlobalLookupPopulation  : TaiddbLookupListPopulateItems;

implementation

uses
  { Delphi Units }
  SysUtils, Math,
  { 3rd Party Units }

  { Application Units }
  crUtil;

var
  SearchTickCount: Integer = 0;
  
{ TaiddbCustomLookupList }
constructor TaiddbCustomLookupList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style:= csOwnerDrawFixed;

  FsLastFilteredValue:= #255;

  { List of Lookup options. }
  FoLookupList:= TStringList.Create;
  if AllowDuplicates() then
    FoLookupList.Duplicates:= dupAccept
  else
    FoLookupList.Duplicates:= dupError;

  FoLookupList.Sorted    := True;
  PopulateList(False);

  FbUpdPending:= False;
  FoDataLink  := TFieldDataLink.Create;
  FoDataLink.OnDataChange:= DataChange;
  FoDataLink.OnUpdateData:= UpdateData;

  BevelKind   := bkFlat;
  BevelOuter  := bvLowered;
  BevelInner  := bvNone;
  AutoDropDown:= False;

  ItemHeight  := 13; { Force a height of 19, which matches non ctrl3d TdbLookupComboBox }
  { Default Values }
  FiLookupID  := -1;
  FApplyChangeImmediately := False;
end;


function TaiddbCustomLookupList.AllowDuplicates(): Boolean;
begin
  Result:= False;
end;

procedure TaiddbCustomLookupList.CreateWnd;
begin
  inherited CreateWnd;
  CheckPopulateList();
end;

procedure TaiddbCustomLookupList.WMDestroy(var Msg: TWMDestroy);
begin
  Inherited;
end;


procedure TaiddbCustomLookupList.WMDeleteItem(var Msg: TWMDeleteItem);
var
  wItemData : Cardinal;
begin
  { Ensure that the associated objects are freed. }
  wItemData:= msg.DeleteItemStruct^.itemData;
  if (wItemData>0) then
    Dispose(Pointer(msg.DeleteItemStruct^.ItemData));
  {}
  inherited;
end;


procedure TaiddbCustomLookupList.WMGetDlgCode (var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result:= Msg.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;


destructor TaiddbCustomLookupList.Destroy;
begin
  if Assigned(FoDataLink) then
  begin
    FoDataLink.OnDataChange:= nil;
    FoDataLink.OnUpdateData:= nil;
    //
    FoDataLink.Free;
  end;
  { Clear the lookups }
  FreeAndClearLookupList();
  FoLookupList.Free;
  {}
  inherited;
end;


procedure TaiddbCustomLookupList.FreeAndClearLookupList();
var
  iK  : Integer;
begin
  if (LookupList()<>nil) then
    for iK:= 0 to LookupList().Count-1 do
      if Assigned(LookupList().Objects[iK]) then
      begin
        LookupList().Objects[iK].Free;
        LookupList().Objects[iK]:= nil;
      end;
end;


function TaiddbCustomLookupList.GetSelectedItem: string;
begin
  Result:= '';
  if (ItemIndex>=0) and (ItemIndex<ItemCount) then
    Result:= Items[ItemIndex];
end;

procedure TaiddbCustomLookupList.SetSelectedItem(const Value: string);
var
  iK  : Integer;
begin
  for iK:= 0 to ItemCount-1 do
    if SameText(Items[iK], Value) then
    begin
      ItemIndex:= iK;
      break;
    end;
end;

procedure TaiddbCustomLookupList.PopulateList(AbForcedRefresh: Boolean);
begin
  if HandleAllocated then
  begin
    FreeAndClearLookupList();
    {}
    if (LookupList()<>nil) then
    begin
      LookupList().BeginUpdate();
      try
        LookupList().Clear;
        { Call the population method. }
        DoLoadListItems(LookupList(), AbForcedRefresh);
      finally
        LookupList().EndUpdate();
      end;
    end;
  end
  else
    FbNeedToPopulate := True;
end;


procedure TaiddbCustomLookupList.InvalidateLookupList(AbForcedRefresh: Boolean = False);
begin
  FbNeedToPopulate   := True;
  FsLastFilteredValue:= #255;
  {}
  PopulateList(AbForcedRefresh);
end;


procedure TaiddbCustomLookupList.UserSelectedRefresh();
begin
  InvalidateLookupList(True);
  RefreshLookup();
  Self.Invalidate;
end;

procedure TaiddbCustomLookupList.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  oItem : TaiddbCustomLookupListItem;
  sKey  : String;
begin
  inherited;
  if (Index>=0) and (Index<Items.Count) then
  begin
    { Set the font properties if the field or control is disabled. }
    if (not self.IsEnabled) then
    begin
      Canvas.Font.Color:= clGrayText;
    end;
    { Relies on a unique indexed lookup list - requires an additonal subfilter mechanism ?}
    sKey := Items[Index];
    oItem:= LookupItemForKey(LookupList(), sKey);
    if Assigned(oItem) then
      oItem.DrawItem(Self, Canvas, Rect, State);
  end;
end;


{ LookupItemForKey()
    Returns the lookup object for a given key. }
function TaiddbCustomLookupList.LookupItemForKey(AoLookupList: TStringList; const AsKey : String): TaiddbCustomLookupListItem;
var
  iK  : Integer;
begin
  Result:= nil;
  { This code will work on a uniquely indexed key. Compound key descendants should override this. }
  iK    := AoLookupList.IndexOf(AsKey);
  if (iK>=0) and (iK<AoLookupList.Count) then
    if Assigned(AoLookupList.Objects[iK]) and (AoLookupList.Objects[iK] is TaiddbCustomLookupListItem) then
      Result:= TaiddbCustomLookupListItem(AoLookupList.Objects[iK]);
end;


{ Change()
    User has selected a new value. }
procedure TaiddbCustomLookupList.Change();
begin
  if FoDataLink.CanModify then
  begin
    FbUpdPending:= True;
    try
      FoDataLink.Edit;

      inherited;

      FoDataLink.Modified;

      if (ApplyChangeImmediately) then
        FoDataLink.UpdateRecord;
    finally
      FbUpdPending:= False;
    end;
  end
  else
  begin
    if Assigned(FoDataLink) and Assigned(FoDataLink.Field) then
      SelectedItem:= FoDataLink.Field.AsString;
  end;
end;


procedure TaiddbCustomLookupList.Loaded;
begin
  inherited;
  // Forces style after streaming has set parent
end;



function TaiddbCustomLookupList.GetDataField: string;
begin
  Result:= FoDataLink.FieldName;
end;

function TaiddbCustomLookupList.GetDataSource: TDataSource;
begin
  Result:= FoDataLink.DataSource;
end;

procedure TaiddbCustomLookupList.SetDataField(const Value: string);
begin
  FoDataLink.FieldName:= Value;
end;

procedure TaiddbCustomLookupList.SetDataSource(Value: TDatasource);
begin
  FoDataLink.DataSource:= Value;
end;

procedure TaiddbCustomLookupList.DataChange(Sender: TObject);
var
  sK  : String;
begin
  if (not FbUpdPending) then
    if Assigned(FoDataLink.DataSet) and (not FoDataLink.DataSet.ControlsDisabled) then
    begin
      sK:= '';
      if Assigned(FoDataLink.Field) then
        sK:= FoDataLink.Field.AsString;

      { Rebuilds the Items content based upon the value selected. }
      ApplyFiltersToLookupList(sK);

      { Positions the List Selection depending on the value. }
      UpdateListSelection(sK);
    end;
end;

procedure TaiddbCustomLookupList.UpdateData(Sender: TObject);
begin
  if FoDataLink.CanModify then
  begin
    FoDataLink.Field.AsString := Self.SelectedItem;
  end;
end;

procedure TaiddbCustomLookupList.CMExit(var Message: TWMNoParams);
begin
  try
    FoDataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;


procedure TaiddbCustomLookupList.CMEnabledChanged(var Message: TMessage);
begin
  inherited; 
end;



procedure TaiddbCustomLookupList.KeyDown(var Key: word; shift: TShiftState);
begin
  { When tabbing, closeup the drop down. }
  if (Key=VK_TAB) and (Shift = []) and (DroppedDown) then
  begin
    CloseUpList();
    Key:= 0;
  end;
  { Treat a delete or backspace as a field clear. Treat a spacebar when the list is showing as
    a user selection. }
  if (Key=VK_DELETE) or (Key=VK_BACK) or ((Key=VK_SPACE) and (DroppedDown)) {and (not ListVisible)} then
  begin
    ClearField();
    if DroppedDown then
      CloseUpList();
    Key:= 0;
  end;

  { Override standard keyboard arrow behaviour. UP Key now does nothing when not dropped down. }
  if (Key=VK_UP  ) and (Shift=[]) and (not DroppedDown) then
    Key:= 0;
  { Override standard keyboard arrow behaviour. DOWN Key now does drops down the list when not already dropped down. }
  if (Key=VK_DOWN) and (Shift=[]) and (not DroppedDown) then
  begin
    DropDownList();
    Key:= 0;
  end;

  { Treat F5 as a full refresh instruction. }
  if (Key =VK_F5) then
    if (not DroppedDown) then
    begin
      UserSelectedRefresh();
      Key:= 0;
    end;

  inherited;
end;

(* CGR - THE CODE BELOW IS FROM THE VCL - THE KEYBOARD DELAY BETWEEN KEYPRESSES IS HARD CODED IN TO THE KEYPRESS METHOD -
   STILL THINKING ABOUT HOW TO OVERCOME THIS.

ajc: seems to work if onkeypress is working? can extend to much longer, the time. is 2s too long?
*)
procedure TaiddbCustomLookupList.KeyPress(var Key: Char);

  function HasSelectedText(var StartPos, EndPos: DWORD): Boolean;
  begin
    SendMessage(Handle, CB_GETEDITSEL, Integer(@StartPos), Integer(@EndPos));
    Result := EndPos > StartPos;
  end;

  procedure DeleteSelectedText;
  var
    StartPos, EndPos: DWORD;
    OldText: String;
  begin
    OldText := Text;
    SendMessage(Handle, CB_GETEDITSEL, Integer(@StartPos), Integer(@EndPos));
    Delete(OldText, StartPos + 1, EndPos - StartPos);
    SendMessage(Handle, CB_SETCURSEL, -1, 0);
    Text := OldText;
    SendMessage(Handle, CB_SETEDITSEL, 0, MakeLParam(StartPos, StartPos));
  end;

var
  TickCount: Integer;
//  S: string;
//  CharMsg: TMsg;
  //
  StartPos: DWORD;
  EndPos: DWORD;
  OldText: String;
  SaveText: String;
  Msg : TMsg;
  LastByte: Integer;
begin
  //inherited TCustomCombo.KeyPress(Key); -pulls in some code i do want
  //since inherited is commented, add inherited code that is wanted here: (cf TWinControl.KeyPress(var Key: Char);)
  if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
  //end inherited reintroduce
  if not AutoComplete then exit;
  
  if Style in [csDropDown, csSimple] then
    FSearchText := Text
  else
  begin
    TickCount := GetTickCount;
    if TickCount - SearchTickCount >= 2000 then
      FSearchText := '';
    SearchTickCount := TickCount;
  end;

  case Ord(Key) of
    VK_ESCAPE,
    VK_TAB:
      begin
        if AutoDropDown and DroppedDown then
          DroppedDown := False;
        FSearchText := '';
      end;
    VK_BACK:
      begin
        if HasSelectedText(StartPos, EndPos) then
          DeleteSelectedText
        else
          if (Style in [csDropDown, csSimple]) and (Length(Text) > 0) then
          begin
            SaveText := Text;
            LastByte := StartPos;
            while ByteType(SaveText, LastByte) = mbTrailByte do Dec(LastByte);
            OldText := Copy(SaveText, 1, LastByte - 1);
            SendMessage(Handle, CB_SETCURSEL, -1, 0);
            Text := OldText + system. Copy(SaveText, EndPos + 1, System.MaxInt);
            SendMessage(Handle, CB_SETEDITSEL, 0, MakeLParam(LastByte - 1, LastByte - 1));
            FSearchText := Text;
          end
          else
          begin
            while ByteType(FSearchText, Length(FSearchText)) = mbTrailByte do
              Delete(FSearchText, Length(FSearchText), 1);
            Delete(FSearchText, Length(FSearchText), 1);
          end;
        Key := #0;
        Change;
      end;
  else
  //ord(#32)..ord(#255): //space char (32) up to z (122) and to end of ASCII
    begin
      if AutoDropDown and not DroppedDown then
        DroppedDown := True;
      if HasSelectedText(StartPos, EndPos) then
        FSearchText := Copy(FSearchText, 1, StartPos) + Key
      else
        FSearchText := FSearchText + Key;

      if Key in LeadBytes then
      begin
        if PeekMessage(Msg, Handle, 0, 0, PM_NOREMOVE) and (Msg.Message = WM_CHAR) then
        begin
          if SelectItem(FSearchText + Char(Msg.wParam)) then
          begin
            PeekMessage(Msg, Handle, 0, 0, PM_REMOVE);
            Key := #0
          end;
        end;
      end
      else
        if SelectItem(FSearchText) then
          Key := #0
    end;
  end; // case
end;

{
procedure TaiddbCustomLookupList.KeyPress(var Key: Char);
begin
  case Ord(Key) of
    VK_BACK:  ItemIndex := 0;
  end;

  inherited;
end;
}

procedure TaiddbCustomLookupList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if not (csDestroying in self.ComponentState ) then
  if (Operation = opRemove)
    and (FoDataLink <> nil)
    and (AComponent = DataSource) then //fetchng the datasource seems to occur sometimes when FoDataLink is not there.
    DataSource := nil;
end;

function TaiddbCustomLookupList.GetReadOnly: Boolean;
begin
  Result := FoDataLink.ReadOnly;
end;

procedure TaiddbCustomLookupList.SetReadOnly(const Value: Boolean);
begin
  FoDataLink.ReadOnly := Value;
end;

procedure TaiddbCustomLookupList.DoLoadListItems(Items: TStrings; AbForcedRefresh: Boolean);
begin
  if Assigned(self.OnLoadListItems) then
    inherited
  else
    if Assigned(GlobalLookupPopulation) then
      GlobalLookupPopulation(Self, LookupID, Items, AbForcedRefresh);
end;

procedure TaiddbCustomLookupList.SetOnLoadListItems(const Value: TaiddbLookupListPopulateItems);
begin
  FOnLoadListItems := Value;
end;

function TaiddbCustomLookupList.Field: TField;
begin
  Result:= nil;
  if Assigned(FoDataLink) then
    Result:= FoDataLink.Field;
end;


procedure TaiddbCustomLookupList.ClearField();
begin
  if (Field<>nil) and (Assigned(Field.DataSet)) and (Field.DataSet.CanModify) then
  begin
    Field.DataSet.Edit;
    Field.Clear;
  end;
end;


{ ApplyFiltersToLookupList()
    Rebuilds the Items content based upon the value selected. }
procedure TaiddbCustomLookupList.ApplyFiltersToLookupList(AsKeyValue: String);
var
  iK            : Integer;
  sLookupKey    : String;
  uLookupObject : TObject;
  bInclude      : Boolean;
begin
  Items.BeginUpdate;
  try
    Items.Clear;
    if (LookupList() <> nil) then
    begin
      if (not SameText(FsLastFilteredValue, AsKeyValue)) or (FbNeedToPopulate) then
      begin
        for iK:= 0 to LookupList().Count-1 do
        begin
          sLookupKey    := LookupList().Strings[iK];
          uLookupObject := LookupList().Objects[iK];
          bInclude      := True;

          if uLookupObject is TaiddbCustomLookupListItem then
            bInclude:= CanIncludeThisItem(AsKeyValue, TaiddbCustomLookupListItem(uLookupObject));
          {}
          if bInclude then
            Items.AddObject(sLookupKey, nil);
        end;
      end;
      FsLastFilteredValue:= AsKeyValue;
    end;
    SelectedItem:= AsKeyValue;
  finally
    Items.EndUpdate;
  end;
end;

function TaiddbCustomLookupList.CanIncludeThisItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
begin
  Result:= True;
end;

{ UpdateListSelection
    Positions the List Selection depending on the value. }
procedure TaiddbCustomLookupList.UpdateListSelection(AsKeyValue: String);
begin
  if (FoDataLink.field = nil) then
    SelectedItem:= ''
  else
    SelectedItem:= Trim(AsKeyValue);
end;

procedure TaiddbCustomLookupList.DropDownList();
begin
  SendMessage(Handle, CB_SHOWDROPDOWN, 1{TRUE}, 0);
end;

procedure TaiddbCustomLookupList.CloseUpList();
begin
  SendMessage(Handle, CB_SHOWDROPDOWN, 0{FALSE}, 0);
end;

procedure TaiddbCustomLookupList.SetLookupID(const Value: TLookupID);
begin
  if (FiLookupID <> Value) then
  begin
    FiLookupID:= Value;
    InvalidateLookupList();
  end;
end;

function TaiddbCustomLookupList.DoFilterItem(AsDataKey: String; AoLookupItem: TaiddbCustomLookupListItem): Boolean;
begin
  Result:= True;
  if Assigned(FOnFilterItem) then
    Result:= OnFilterItem(Self, AsDataKey, AoLookupItem);
end;

procedure TaiddbCustomLookupList.SetOnFilterItem(const Value: TaiddbLookupListFilterItem);
begin
  FOnFilterItem := Value;
end;

procedure TaiddbCustomLookupList.RefreshLookup();
var
  sField  : String;
begin
  sField:= SelectedItem;
  if Field() <> nil then
    sField:= Field.AsString;

  FsLastFilteredValue:= #255;
  ApplyFiltersToLookupList({SelectedItem}sField);
end;

procedure TaiddbCustomLookupList.SetApplyChangeImmediately(const Value: Boolean);
begin
  FApplyChangeImmediately:= Value;
end;

procedure TaiddbCustomLookupList.ChangeScale(M, D: Integer);
begin
  inherited;
  ItemHeight:= MulDiv(ItemHeight, M, D);
end;

function TaiddbCustomLookupList.IsEnabled: Boolean;
begin
  Result:= Self.Enabled;
end;

procedure TaiddbCustomLookupList.SetDropDownWidth(AValue: Integer);
begin 
  SendMessage(Handle, CB_SETDROPPEDWIDTH, LongInt(AValue), 0); 
end; 


function  TaiddbCustomLookupList.GetDropDownWidth(): Integer; 
begin 
  Result := SendMessage(Handle, CB_GETDROPPEDWIDTH, 0, 0); 
end; 


function TaiddbCustomLookupList.LookupList(): TStringList;
begin
  Result:= FoLookupList;
end;

procedure TaiddbCustomLookupList.CheckPopulateList();
begin
  if FbNeedToPopulate then
    PopulateList(False);
end;

{ TaiddbCustomLookupListItem }
procedure TaiddbCustomLookupListItem.DrawItem(AoOwner: TaiddbCustomLookupList; AoCanvas: TCanvas; ArRect: TRect; AeState: TOwnerDrawState);
begin
  AoCanvas.FillRect(ArRect);
end;


initialization
  GlobalLookupPopulation  := nil;


end.
