unit aidCommsObj;

{ aidCommsObj
    Communications queue object which queues communications, and dispatches these
    via helper threads (aidCommsThread).

    ajc2008dec   Switched the database api used to IBO.
    
    }

interface

uses
  { Delphi Units }
  Classes, Contnrs, crTypes, SysUtils,
  { Application Units }
  aidTypes, aidCommsTypes;

type
  TaidCommunicationArg   = record
    LinkerType  : TaidCommunicationLinker;
    Inc_Linker  : TInc;
    LinkerRef   : string;
    //
    SenderUser  : TUserNo;
    Subject     : string;
    //
    CommSite    : TSiteNo;
    CommType    : TaidCommunicationType;
    //
    CreatedBy   : TUserNo;
  end;

type
  EaidCommunicationsException = class(Exception);

type
  TaidCommunicationsDB = class(TPersistent)
  private
    FsDatabaseName: string; // Database server & database name
    FsDatabaseUser: string; // Database user name
    FsDatabasePswd: string; // Database user password
    FCommsDbAlias : string;
  public
    procedure AssignTo(Dest: TPersistent);override;


  published
    property DatabaseName: string read FsDatabaseName write FsDatabaseName;
    property DatabaseUser: string read FsDatabaseUser write FsDatabaseUser;
    property DatabasePswd: string read FsDatabasePswd write FsDatabasePswd;
    property CommsDbAlias: string read FCommsDbAlias  write FCommsDbAlias;
  end;


type
  TaidCommunications  = class(TComponent)
  private
    FdbConfig : TaidCommunicationsDB;
    FQueue    : TObjectList;
    procedure   SetDatabaseConfiguration(const Value: TaidCommunicationsDB);
  protected
  public
    constructor Create(AControl: TComponent); override;
    destructor  Destroy; override;
    //
    procedure   ClearQueue;
    procedure   QueueEmail(CommArg : TaidCommunicationArg;AQueueEmailItem: TaidCommunicationEmail);
    procedure   DispatchQueuedItems;
    procedure   ThreadException(Sender: TObject; const AsExceptionText: string);
  published
    property    DatabaseConfiguration: TaidCommunicationsDB read FdbConfig write SetDatabaseConfiguration;
  end;

function FileNamesAsDelimitedText(AFileNames: array of string): string;
function FileNamesAsDelimitedTextNew( vsFirstSingle, vsSecondList : String ): string;

implementation

uses
  aidCommsThread, Dialogs;


function FileNamesAsDelimitedText(AFileNames: array of string): string;
var
  iK    : Integer;
  sFile : string;
begin
  Result:= '';
  if Length(AFileNames)>0 then
  begin
    for iK:= Low(AFileNames) to High(AFileNames) do
    begin
      sFile:= Trim(AFileNames[iK]);
      if Length(sFile)>0 then
      begin
//ajc build 64 - commented out the placing of double quotes around attachments, because it is causing an error when attaching files when emailed(file not found)
//adding fix in procedure TaidCommunicationsThread.AddEmailTodbQueue(AConfig: TaidCommunicationArg; AEmailItem: TaidCommunicationEmail; AsXML: string);

        //if (Pos(#32, sFile)>0) then
        //  sFile := '"'+sFile+'"';
        if Length(Result)>0 then
          Result:= Result+';';
        Result:= Result+sFile;
      end;
    end;
  end;
end;

function FileNamesAsDelimitedTextNew( vsFirstSingle, vsSecondList : String ): string;
var
  liK    : Integer;
  lsFile : String;
  lsList : String;
begin
  Result:= '';
//ajc build 64 - commented out the placing of double quotes around attachments, because it is causing an error when attaching files when emailed(file not found)
//adding fix in procedure TaidCommunicationsThread.AddEmailTodbQueue(AConfig: TaidCommunicationArg; AEmailItem: TaidCommunicationEmail; AsXML: string);


{
  if Length(vsFirstSingle)>0 then
  begin
    lsFile:= Trim( vsFirstSingle );
    if ( Pos( #32, lsFile ) > 0 ) then
    begin
      lsFile := '"' + lsFile + '"';
    end;
    Result := lsFile;
  end;
}
  lsList := Trim( vsSecondList );
  while Length( lsList ) > 0 do
  begin
    liK := Pos( ',', lsList );
    if liK = 0 then
    begin
      liK := Pos( ';', lsList );
    end;
    if liK > 0 then
    begin
      lsFile := Copy( lsList, 1, liK - 1 );
      lsList := Copy( lsList, liK + 1, Length( lsList ) - liK );
    end
    else
    begin
      lsFile := lsList;
      lsList := '';
    end;
    {
    if ( Pos( #32, lsFile ) > 0 ) and ( Pos( '"', lsFile ) = 0 ) then
    begin
      lsFile := '"' + lsFile + '"';
    end;
    }
    if Length( Result ) > 0 then
    begin
      Result := Result + ';';
    end;

    Result := Result + lsFile;
  end;
end;

{ TaidCommunications }
constructor TaidCommunications.Create(AControl: TComponent);
begin
  inherited;
  FQueue   := TObjectList.Create(True);
  FdbConfig:= TaidCommunicationsDB.Create;
end;

destructor TaidCommunications.Destroy;
begin
  ClearQueue;
  //
  FreeAndNil(FdbConfig);
  FreeAndNil(FQueue);
  inherited;
end;

procedure TaidCommunications.ClearQueue();
begin
  FQueue.Clear;
end;

procedure TaidCommunications.QueueEmail(CommArg : TaidCommunicationArg; AQueueEmailItem: TaidCommunicationEmail);
var
  oObj  : TaidCommunicationEmailObj;
begin
  if Assigned(FQueue) then
  begin
    oObj:= TaidCommunicationEmailObj.Create(CommArg, AQueueEmailItem);
    FQueue.Add(oObj);
  end;
end;

procedure TaidCommunications.SetDatabaseConfiguration(const Value: TaidCommunicationsDB);
begin
  FdbConfig := Value;
end;

procedure TaidCommunications.DispatchQueuedItems;
begin
  if (FQueue.Count>0) then
  begin
    // Hand the queue over to a communications thread, which will copy FQueue,
    // and then attempt to store this in a database.
    if self.FdbConfig.CommsDbAlias <> '' then
      TaidCommunicationsThread.Create( self.FdbConfig.CommsDbAlias, FQueue, ThreadException)
    else
      TaidCommunicationsThread.Create( self.FdbConfig, FQueue, ThreadException);
    //
    ClearQueue;
  end;
end;


procedure TaidCommunications.ThreadException(Sender: TObject; const AsExceptionText: string);
begin
  // As this code is being run within another thread (albiet synchronized),
  // we cannot simply raise an exception. An idea would be to use the
  // application. variable to do this. For now, a show message will suffice.
  MessageDlg(AsExceptionText, mtError, [mbOk], 0);
end;


{ TaidCommunicationsDB }

procedure TaidCommunicationsDB.AssignTo(Dest: TPersistent);
begin
  if dest is TaidCommunicationsDB then
  begin
    TaidCommunicationsDB(dest).FsDatabaseName := FsDatabaseName;
    TaidCommunicationsDB(dest).FsDatabaseUser := FsDatabaseUser;
    TaidCommunicationsDB(dest).FsDatabasePswd := FsDatabasePswd;
    TaidCommunicationsDB(dest).FCommsDbAlias  := FCommsDbAlias;
  end;
end;

end.
