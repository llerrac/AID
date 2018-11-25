unit aidListView;
{ -----------------------------------------------------------------------------------
  name:         aidListView
  author:       Chris G. Royle, 27 Oct 2005
  description:  Fairly rudimentary ListView descendants
  modified:
  todo: add ctrl-a support.
  -----------------------------------------------------------------------------------}

interface

uses
  ComCtrls, Classes;

Type
  ThackListView = class(TListview) public property OnCreateItemClass; end;

Type
  { TaidFileListViewItem
      List View item for storing file / folder information. }
  TaidFileListViewItem = Class(TListItem)
  Public
  Private
    FsExtension : String;
    FsFolderName: String;
    FsFileName  : String;
  Protected
    Procedure AssignTo(Dest: TPersistent); override;
  Public
    Procedure Assign  (Source: TPersistent); override;
    Function  FolderFileName(): String;
    //
    Property  FileName    : String read FsFileName   write FsFileName;
    Property  FolderName  : String read FsFolderName write FsFolderName;
    Property  Extension   : String read FsExtension  write FsExtension;
  End;

  { TaidFileListView component
      List View component which defaults to creating TaidFileListViewItem list items. }
  TaidFileListView = class(TListView)
  Protected
    Function  CreateListItem: TListItem; override;
  Public
    Property  OnCreateItemClass;
    Procedure Assign(ASource: TPersistent); override;
    Function  AddFileItem(AsFolderName, AsFileName: String): TaidFileListViewItem; overload;
    Function  AddFileItem(const AsFolderFileName: String): TaidFileListViewItem; overload;
    Function  FileItem(AiIndex: Integer): TaidFileListViewItem;
    Procedure CopySelectedItems(AoSelected: TStrings);
  End;


implementation

uses
  SysUtils;

{procedure Register }

{ TaidFileListViewItem }
procedure TaidFileListViewItem.Assign(Source: TPersistent);
begin
  inherited;
  { TListItem Assign method is overridden in the base class - we need to work around this. }
  If Source is TaidFileListViewItem then
    TaidFileListViewItem(Source).AssignTo(Self);
end;

procedure TaidFileListViewItem.AssignTo(Dest: TPersistent);
begin
  { Caption, Data, Index, etc are all assigned by TListItem }
  if Dest is TaidFileListViewItem then
    with TaidFileListViewItem(Dest) do
    Begin
      FileName  := Self.FileName;
      FolderName:= Self.FolderName;
      Extension := Self.Extension;
      Caption   := FileName;
    End
  else
    inherited;
end;


function TaidFileListView.AddFileItem(AsFolderName, AsFileName: String): TaidFileListViewItem;
var
  oItem : TListItem;
begin
  oItem:= self.Items.Add();

  Result:= TaidFileListViewItem(oItem);
  Result.FolderName:= AsFolderName;
  Result.FileName  := AsFileName;
  Result.Extension := ExtractFileExt(AsFileName);
  Result.Caption   := AsFileName;
end;

function TaidFileListView.AddFileItem(const AsFolderFileName: String): TaidFileListViewItem;
var
  sFolderName,
  sFileName   : String;
begin
  sFolderName:= ExtractFilePath(AsFolderFileName);
  sFileName  := ExtractFileName(AsFolderFileName);
  Result:= AddFileItem(sFolderName, sFileName);
end;

procedure TaidFileListView.Assign(ASource: TPersistent);
var
  iK        : Integer;
  sFileName : String;
begin
  Items.BeginUpdate;
  try
    Clear;
    { Assign string list }
    if ASource is TStringList then
    begin
      with TStringList(ASource) do
        for iK:= 0 to Count-1 Do
        Begin
          sFileName:= Strings[iK];
          AddFileItem(sFileName);
        End;
    end
    else
      inherited;
  finally
    Items.EndUpdate;
  end;
end;

function TaidFileListView.CreateListItem: TListItem;
var
  oClass: TListItemClass;
begin
  oClass := TaidFileListViewItem;
  if Assigned(OnCreateItemClass) then
    OnCreateItemClass(Self, oClass);
  Result := oClass.Create(Items);
end;

function TaidFileListViewItem.FolderFileName: String;
begin
  Result:= IncludeTrailingPathDelimiter(FolderName)+FileName;
end;

function TaidFileListView.FileItem(AiIndex: Integer): TaidFileListViewItem;
begin
  Result:= nil;
  if (AiIndex>=0) and (AiIndex<Items.Count) Then
    if Items[AiIndex] is TaidFileListViewItem then
      Result:= TaidFileListViewItem(Items[AiIndex]);
end;


procedure TaidFileListView.CopySelectedItems(AoSelected: TStrings);
var
  iK  : Integer;
begin
  If Assigned(AoSelected) Then
  Begin
    AoSelected.Clear();
    for iK:= 0 to Items.Count-1 Do
      AoSelected.Add(FileItem(iK).FolderFileName())
  End;
end;

end.
