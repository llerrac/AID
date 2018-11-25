unit aiddbCodedColor;

{ crdbColor       CGR20021127, first stab
    Data-aware color picker component}

interface

uses
  { Delphi Units }
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ExtCtrls, Graphics,
  DB, DBCtrls,
  { Application Units }
  aidCodedColor;

type
  TaiddbCodedColorBox = class(TCustomCodedColorBox)
  private
    { Private declarations }
    FoDataLink   : TFieldDataLink;
    FbUpdPending: Boolean;
    //
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value: TDatasource);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMExit (var Message: TWMNoParams); message CM_EXIT;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    { Protected declarations }
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    //
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown ( var Key: word; shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
    property AutoComplete;
    property AutoDropDown;
    property DefaultColorColor;
    property NoneColorColor;
    property Selected;
    property SelectedItem;
    property Style;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnCloseUp;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
    //
    property ReadOnly : Boolean read GetReadOnly write SetReadOnly default false;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;


implementation


{ TaiddbCodedColorBox }
constructor TaiddbCodedColorBox.Create(AOwner: TComponent);
begin
  inherited;
  //
  FbUpdPending:= False;
  FoDataLink:= TFieldDataLink.Create;
  FoDataLink.OnDataChange:=DataChange;
  FoDataLink.OnUpdateData:= UpdateData;
end;


destructor TaiddbCodedColorBox.Destroy;
begin
  if Assigned(FoDataLink) then
  begin
    FoDataLink.OnDataChange:= nil;
    FoDataLink.OnUpdateData:= nil;
    //
    FoDataLink.Free;
  end;
  //
  inherited;
end;


procedure TaiddbCodedColorBox.Change;
begin
  if FoDataLink.CanModify then
  begin
    FbUpdPending:= True;
    try
      FoDataLink.Edit;
      inherited;
      FoDataLink.Modified;
    finally
      FbUpdPending:= False;
    end;
  end
  else
  begin
    Self.SelectedItem := FoDataLink.Field.AsString;
  end;
end;


procedure TaiddbCodedColorBox.Loaded;
begin
  inherited;
  // Forces style after streaming has set parent
  if Assigned(Parent) then
  begin
    NoneColorColor:= clWhite;
  end;
end;



function TaiddbCodedColorBox.GetDataField: string;
begin
  Result:=FoDataLink.fieldname;
end;

function TaiddbCodedColorBox.GetDataSource: TDataSource;
begin
  Result:=FoDataLink.DataSource;
end;

procedure TaiddbCodedColorBox.SetDataField(const Value: string);
begin
  // Validate Integerfield ?
  FoDataLink.FieldName:=Value;
end;

procedure TaiddbCodedColorBox.SetDataSource(Value: TDatasource);
begin
  FoDataLink.DataSource:=Value;
end;

procedure TaiddbCodedColorBox.DataChange(Sender: TObject);
var
  lsColourCode : String;
begin
  if not FbUpdPending then
  begin
    if (FoDataLink.field = nil) then
      Selected:= Self.NoneColorColor
    else
    begin
      lsColourCode := Trim( FoDataLink.Field.AsString );
      if ( lsColourCode <> '' ) then
        SelectedItem := lsColourCode
      else
        Selected:= Self.NoneColorColor;
    end;
  end;
end;

procedure TaiddbCodedColorBox.UpdateData(Sender: TObject);
begin
  if FoDataLink.CanModify then
  begin
//    FoDataLink.Field.AsInteger:= ColorTORGB(Self.Selected);
    FoDataLink.Field.AsString := Self.SelectedItem;
  end;
end;

procedure TaiddbCodedColorBox.CMExit(var Message: TWMNoParams);
begin
  try
    FoDataLink.UpdateRecord;
  except
    on Exception do SetFocus;
  end;
  //
  inherited;
end;


procedure TaiddbCodedColorBox.KeyDown(var Key: word; shift: TShiftState);
begin
  inherited;

end;

procedure TaiddbCodedColorBox.KeyPress(var Key: Char);
begin
  case Ord(Key) of
    VK_BACK:  ItemIndex := 0;
  end;

  inherited;
end;


procedure TaiddbCodedColorBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //
  if (Operation = opRemove) and (FoDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TaiddbCodedColorBox.GetReadOnly: Boolean;
begin
  Result := FoDataLink.ReadOnly;
end;

procedure TaiddbCodedColorBox.SetReadOnly(const Value: Boolean);
begin
  FoDataLink.ReadOnly := Value;
end;



end.
