unit aidCheckList;

{ Name         : aidCheckList
  Description  : customised ChecklistBox components and routines.
  Author       : Chris G. Royle 11 Sep 2005
  Note         :
  see          :
  modifications:
}

interface

uses
  Windows, Graphics, CheckLst, Classes, Controls, Types;

type
  TaidCustomCheckListBoxItem = class(TObject)
  Private
    FbWasSelected: Boolean;
  Public
    Property WasSelected: Boolean read FbWasSelected write FbWasSelected;
  End;

  TaidCustomCheckListBox = class(TCheckListBox)

  End;

  //
  TaidLookupCheckListBoxItem = class(TaidCustomCheckListBoxItem)
  Public
    Constructor CreateWithParams(Const AsKey_Lk, AsDesc_Lk: String; Const AbIsSelected: Boolean = False; Const AbIsInherited: Boolean = False);
    Destructor Destroy; override;
  Private
    FsKey_Lk        : String;
    FsDesc_Lk       : String;
    FbIsInherited   : Boolean;
  Public
    Property Key_Lk       : String  read FsKey_Lk         write FsKey_Lk;
    Property Desc_Lk      : String  read FsDesc_Lk        write FsDesc_Lk;
    Property IsInherited  : Boolean read FbIsInherited    write FbIsInherited;
    Property WasSelected;
  End;

  TaidLookupCheckListBox = class(TaidCustomCheckListBox)
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; override;
  Protected
    FiVScroll : Integer;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyPress(var Key: Char); override;
    procedure DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState); override;
  Public
    Procedure ClearItems;
    Function  AddLookupItem(Const AsKey, AsDesc: String): TaidLookupCheckListBoxItem;
    Function  Item(AsKey  : String) : TaidLookupCheckListBoxItem; overload;
    Function  Item(AiIndex: Integer): TaidLookupCheckListBoxItem; overload;
    Function  SelectedItem: TaidLookupCheckListBoxItem;
    Function  IndexOf(AsKey: String): Integer;
  End;



implementation

uses
  SysUtils;

{ TaidLookupCheckListBox }
destructor TaidLookupCheckListBox.Destroy;
begin
  ClearItems;
  inherited;
end;

procedure TaidLookupCheckListBox.ClearItems;
Var
  iK  : Integer;
Begin
  for iK:= 0 to Items.Count-1 Do
  begin
    If Assigned(Items.Objects[iK]) Then
    begin
      Items.Objects[iK].Free;
      Items.Objects[iK]:= Nil;
    end;
  end;
  //
  Clear;
End;


Function TaidLookupCheckListBox.AddLookupItem(Const AsKey, AsDesc: String): TaidLookupCheckListBoxItem;
var
  oRes  : TaidLookupCheckListBoxItem;
Begin
  oRes:= TaidLookupCheckListBoxItem.Create;
  oRes.Key_Lk     := AsKey;
  oRes.Desc_Lk    := AsDesc;
  oRes.IsInherited:= False;
  oRes.WasSelected:= False;
  //
  inherited AddItem(AsDesc, oRes);
  //
  Result:= oRes;
End;


Function  TaidLookupCheckListBox.Item(AsKey  : String): TaidLookupCheckListBoxItem;
var
  iIndex  : Integer;
Begin
  iIndex:= IndexOf(AsKey);
  Result:= Item(iIndex);
End;


function  TaidLookupCheckListBox.Item(AiIndex: Integer): TaidLookupCheckListBoxItem;
begin
  Result:= nil;
  If (AiIndex>=0) and (AiIndex<Count) Then
    if Assigned(Items.Objects[AiIndex]) Then
      Result:= TaidLookupCheckListBoxItem(Items.Objects[AiIndex]);
end;

Function  TaidLookupCheckListBox.IndexOf(AsKey: String): Integer;
var
  iK  : Integer;
Begin
  Result:= -1;
  for iK:= 0 to Items.Count-1 Do
    if Assigned(Items.Objects[iK]) and (Items.Objects[iK] is TaidLookupCheckListBoxItem) Then
      If CompareText(TaidLookupCheckListBoxItem(Items.Objects[iK]).Key_Lk, AsKey)=0 Then
      begin
        Result:= iK;
        Break;
      end;
end;

procedure TaidLookupCheckListBox.KeyPress(var Key: Char);
var
  uSelected : TaidLookupCheckListBoxItem;
begin
  uSelected:= SelectedItem;
  if Assigned(uSelected) and (uSelected.IsInherited) Then
  else
    inherited;
end;

procedure TaidLookupCheckListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  uSelected : TaidLookupCheckListBoxItem;
begin
  uSelected:= SelectedItem;
  if Assigned(uSelected) and (uSelected.IsInherited) Then
  else
    inherited;
end;

function TaidLookupCheckListBox.SelectedItem: TaidLookupCheckListBoxItem;
begin
  Result:= Self.Item(ItemIndex);
end;

procedure TaidLookupCheckListBox.DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  rRect : TRect;
  iH    : Integer;
  uItem : TaidLookupCheckListBoxItem;
{const
  CsI   : string = 'i';}
begin
  inherited;
  uItem:= Item(Index);
  If Assigned(uItem) and (uItem.IsInherited) Then
  Begin
    rRect:= ARect;
    InflateRect(rRect, 0, -2);
    iH:= rRect.Bottom - rRect.Top;
    rRect.Right:= rRect.Right - FiVScroll-2;
    rRect.Left := rRect.Right - iH;

    Canvas.Brush.Color:= clGray;
    Canvas.Brush.Style:= bsSolid;
  //  Canvas.FillRect(Rect(ARect.Right-10, ARect.Top, ARect.Right, ARect.Bottom));
    Canvas.Ellipse(rRect);
  {  Canvas.Brush.Style:= bsClear;
    Canvas.Pen.Color:= clWhite;
    Canvas.Font.Style:= Canvas.Font.Style + [fsBold, fsItalic];
    DrawText(Canvas.Handle, PChar(CsI), Length(PChar(CsI)), rRect, DT_CENTER+DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX );}
  end;
end;

constructor TaidLookupCheckListBox.Create(AOwner: TComponent);
begin
  FiVScroll:= GetSystemMetrics(SM_CXVSCROLL);
  inherited;
end;

{ TaidLookupCheckListBoxItem }

constructor TaidLookupCheckListBoxItem.CreateWithParams(Const AsKey_Lk, AsDesc_Lk: String; Const AbIsSelected: Boolean = False; Const AbIsInherited: Boolean = False);
begin
  inherited Create;
  Key_Lk       := AsKey_Lk;
  Desc_Lk      := AsDesc_Lk;
  WasSelected  := AbIsSelected;
  IsInherited  := AbIsInherited;
end;

destructor TaidLookupCheckListBoxItem.Destroy;
begin

  inherited;
end;


end.
