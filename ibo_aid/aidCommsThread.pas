unit aidCommsThread;

{ -------------------------------------------------------------------------------------------------
  Name        : aidCommsThread
  Author      :
  Description : Thread object for creating records in the comunications database.
  see also    :
    aidCommsObj.pas, dataQueue.sql
  Note        :
  Modified    :
    CGR 08/12/2004 Added support for 'Request Read Receipt'
    CGR20061114, Modified to handle long file names.
    ajc2008oct23 Edited how this maneges attachements and included files. Not sure how this ever worked before imo.
    ajc2008dec   Switched the database api used to IBO. 
  -------------------------------------------------------------------------------------------------}

interface

uses
  classes, contnrs,
  aidTypes, aidCommsObj, aidCommsTypes, IBODataset, IB_Components;

type
  TaidCommunicationEmailObj = class(TObject)
  private
    FComm : TaidCommunicationArg;
    FEmail: TaidCommunicationEmail;

  public
    constructor Create(AQueueArgs: TaidCommunicationArg;AEmail: TaidCommunicationEmail);
    function EmailAsXML: string;
  published
    property Communication: TaidCommunicationArg   read FComm;
    property Email        : TaidCommunicationEmail read FEmail;
  end;

type
  TaidCommunicationsThread = class(TThread)
  private
    FCommsData : TaidCommunicationsDB;
    FQueue            : TObjectList;
    FOnThreadException: TaidExceptionEvent;

    IB_ConnectionComms    : TIB_Connection;
    IB_TransactionComms   : TIB_Transaction;
    FIBGen            : TIBOQuery;
    FIBHdr            : TIBOQuery;
    FIBDtl            : TIBOQuery;
    FsLastException   : string;
    //
    procedure ConnectToTheQueue;
    procedure DisconnectFromQueue;
    procedure SynchronizedExceptionEvent;
    procedure AddEmailTodbQueue(AConfig: TaidCommunicationArg;AEmailItem: TaidCommunicationEmail; AsXML: string);
    procedure DoExceptionEvent(AsExceptionText: string);
    procedure CopyQueue(AQueue: TObjectList);
  protected
    procedure initialiseConn();
    procedure initialise(AQueue: TObjectList; AOnException: TaidExceptionEvent);
  public
    constructor Create(databasename : string; AQueue: TObjectList; AOnException: TaidExceptionEvent);overload;
    constructor Create(Comm : TaidCommunicationsDB;AQueue: TObjectList; AOnException: TaidExceptionEvent);overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses
  SysUtils, StrUtils, crUtil,aidDatbaseLifetime,MimeUtil,db,u_tBOMKernel;

{ TaidCommunicationEmailObj }
function TaidCommunicationEmailObj.EmailAsXML: string;
var
  sRecipients : string;
  oEmailNames : TEmailStringList;
begin
  { Ensure that recipients has been specified.  }
  sRecipients:= email.Recipients;
  if IsEmptyStr(sRecipients) then
  begin
    oEmailNames:= TEmailStringList.Create;
    try
      oEmailNames.AddEmails(email.HdrTo);
      oEmailNames.AddEmails(email.HdrCC);
      oEmailNames.AddEmails(email.HdrBCC);
      sRecipients:= oEmailNames.DelimitedText;
    finally
      freeAndNil(oEmailNames);
    end;
  end;
  {}
  result:= '<?xml version="1.0" encoding="UTF-8"?>';
  result:= result+'<email format="'+CaidEmailFormat[Email.MessageFormat]+'" >'#13#10;
  result:= result+  '<header '#13#10;
  result:= result+     'to="'        +              DeAmp(email.HdrTo      )+'"'#13#10;// 1..n
  result:= result+     'cc="'        +              DeAmp(email.HdrCC      )+'"'#13#10;// 1..n
  result:= result+     'bcc="'        +             DeAmp(email.HdrBCC     )+'"'#13#10;// 1..n
  result:= result+     'subject="'   +              DeAmp(email.HdrSubject )+'"'#13#10;// 1
  result:= result+     'from="'      +              DeAmp(email.HdrFrom    )+'"'#13#10;// 1..n
  result:= result+     'replyto="'   +              DeAmp(email.HdrReplyTo )+'"'#13#10;// 1..n
  result:= result+     'recipients="'+              DeAmp(sRecipients      )+'"'#13#10;// 1..n
  result:= result+     'requestreceipt="'+ BooleanAsYN(email.RequestReceipt)+'"'#13#10;// 1..n
  result:= result+  '> </header>';

  case Email.MessageFormat of
    aidEmailPlainText: result:= result+  '<body message="'+DeAmp(email.MailMessage)+'" > </body>'#13#10;
    aidEmailHTML     : result:= result+  '<body message="'+MimeUtil.Base64Encode(email.MailMessage)+'" > </body>'#13#10;
  end;

  result:= result+'</email>';
  //
  // & -> &#038;
  // & -> &amp;

end;

constructor TaidCommunicationEmailObj.Create(AQueueArgs: TaidCommunicationArg;AEmail: TaidCommunicationEmail);
begin
  inherited Create;
  FComm := AQueueArgs;
  FEmail:= AEmail;

end;


{ TaidCommunicationsThread }
procedure TaidCommunicationsThread.initialise(AQueue: TObjectList; AOnException: TaidExceptionEvent);
begin
  FQueue            := TObjectList.create;
  FOnThreadException:= AOnException;

  fCommsData := TaidCommunicationsDB.create;

  CopyQueue(AQueue);
end;

constructor TaidCommunicationsThread.Create(databasename : string; AQueue: TObjectList; AOnException: TaidExceptionEvent);
begin
  inherited Create(True); // Create Suspended

  initialise(aQueue,aOnException);

  FCommsData.CommsDbAlias := databasename;

  //IN MAIN THREAD UNTIL RESUME IS CALLED
  Resume;
end;

constructor TaidCommunicationsThread.Create(Comm: TaidCommunicationsDB; AQueue: TObjectList; AOnException: TaidExceptionEvent);
begin
  inherited Create(True); // Create Suspended
  FreeOnTerminate := true;

  inItialise(Aqueue,aOnException);;

  FCommsData.assign(comm);
  
  //IN MAIN THREAD UNTIL RESUME IS CALLED
  Resume;
end;


procedure TaidCommunicationsThread.CopyQueue(AQueue: TObjectList);
var
  iK  : Integer;
begin
  if Assigned(AQueue) then
    for iK:= 0 to AQueue.Count-1 do
    begin
      if AQueue.Items[iK] is TaidCommunicationEmailObj then
        FQueue.Add(TaidCommunicationEmailObj.Create(
          TaidCommunicationEmailObj(AQueue.Items[iK]).Communication,
          TaidCommunicationEmailObj(AQueue.Items[iK]).Email)        );
    end;
end;


destructor TaidCommunicationsThread.Destroy;
begin
  FreeAndNil(FQueue );
  FCommsData.free;
  //
  inherited;
end;


procedure TaidCommunicationsThread.Execute();
var
  iPos  : Integer;
begin
  inherited;
  //
  try
    initialiseConn();
    ConnectToTheQueue();  // Create & connect to the database, transaction etc.
    try
      IB_TransactionComms.StartTransaction;
      try
        iPos:= 0;
        while (not Terminated) and (iPos<FQueue.Count) do
        begin
          if Assigned(FQueue.Items[iPos]) then
          begin
            if FQueue.Items[iPos] is TaidCommunicationEmailObj then
            begin
              AddEmailTodbQueue(
                TaidCommunicationEmailObj(FQueue.Items[iPos]).Communication,
                TaidCommunicationEmailObj(FQueue.Items[iPos]).Email,
                TaidCommunicationEmailObj(FQueue.Items[iPos]).EmailAsXML);
            end;
          end;
          inc(iPos);
        end;
        IB_TransactionComms.CommitRetaining;
      except
        IB_TransactionComms.RollBack;
        raise;
      end;
    finally
      DisconnectFromQueue;  // Disconnect
    end;
  except
    // Re-raise exception in main thread.
    on E:Exception do
    begin
      // ~ report exception back to mainthread
      e.Message:= 'TaidCommunicationsThread.Execute Exception:'#13#10+e.Message;
      DoExceptionEvent(e.Message);
    end;
  end;
end;


procedure TaidCommunicationsThread.DoExceptionEvent(AsExceptionText: string);
begin
  FsLastException:= AsExceptionText;
  Synchronize(SynchronizedExceptionEvent);
end;


procedure TaidCommunicationsThread.SynchronizedExceptionEvent;
begin
  if Assigned(FOnThreadException) then
    FOnThreadException(Self, FsLastException);
end;


procedure TaidCommunicationsThread.ConnectToTheQueue;
begin

  // SQL Statements
  FibGen.SQL.Text:= 'SELECT Inc_CommsDetail FROM proc_genid_CommsMast';
  FibHdr.SQL.Text:= 'INSERT INTO CommsMast'#13+
                    ' ( Inc_CommsMast,  LinkerType,  Inc_Linker,  LinkerRef,  SenderUserNo,  Subject,'#13+
                    '   ContentSize,  CommsSite,  CommsType,  CreatedBy)'#13+
                    'VALUES'#13+
                    ' (:Inc_CommsMast, :LinkerType, :Inc_Linker, :LinkerRef, :SenderUserNo, :Subject,'#13+
                    '  :ContentSize, :CommsSite, :CommsType, :CreatedBy)';
  FibDtl.SQL.Text:= 'INSERT INTO CommsDetail'#13+
                    ' ( Inc_CommsMast,  ContentType,  ContentDesc,'#13+
                    '   ContentBlobSize,  ContentBlob,  CreatedBy)'#13+
                    'VALUES'#13+
                    ' (:Inc_CommsMast, :ContentType, :ContentDesc,'#13+
                    '  :ContentBlobSize, :ContentBlob, :CreatedBy)';
  IB_ConnectionComms  .Open;
end;

procedure TaidCommunicationsThread.DisconnectFromQueue;
begin
  FIBGen .Close;
  FIBHdr .Close;
  FIBDtl .Close;
  IB_TransactionComms.Close;
  IB_ConnectionComms  .Close;
  //CLEAR

  FreeAndNil(FIBGen );
  FreeAndNil(FIBHdr );
  FreeAndNil(FIBDtl );
  FreeAndNil(IB_TransactionComms);
  FreeAndNil(IB_ConnectionComms);

end;


procedure TaidCommunicationsThread.AddEmailTodbQueue(AConfig: TaidCommunicationArg;AEmailItem: TaidCommunicationEmail; AsXML: string);
var
  iInc          : Integer;
  iK            : Integer;
  oStr          : TStringStream;
  oFiles        : TStringlist;
  oFile         : TFileStream;
  sFileName     : string;
  iSize         : Integer;
  sAttachments  : String;
begin
  iSize:= 0;
  //
  FibGen.Prepare;
  FibHdr.Prepare;
  FibDtl.Prepare;

  // Generate master Inc
  FibGen.ExecSQL;
  iInc:= FibGen.Fields[0].AsInteger;
  FibGen.Close;

  // Generate detail for email
  oStr:= TStringStream.Create(AsXML);
  try
    FibDtl.Close;
    FibDtl.ParamByName('Inc_CommsMast'  ).AsInteger:= iInc;
    FibDtl.ParamByName('ContentType'    ).AsString := 'E';
    FibDtl.ParamByName('ContentBlobSize').AsInteger:= oStr.Size;
    FibDtl.ParamByName('ContentBlob'    ).LoadFromStream(oStr,ftMemo);
    FibDtl.ParamByName('CreatedBy'      ).AsString := aconfig.CreatedBy;
    FibDtl.ExecSQL;
    FibDtl.Close;
    iSize:= iSize+oStr.Size;
  finally
    oStr.Free;
  end;

  // Generate 1..n detail for attachments
  if not IsEmptyStr(AEmailItem.Attachments) then
  begin
    oFiles:= TStringlist.Create;
    try
      sAttachments:= AEmailItem.Attachments;
      // Split files which have been delimited by either comma(s) or semi-colon(s).
      crUtil.StringToStrings(sAttachments, oFiles, [';', ','], False, True, True);
      //
      for iK:= 0 to oFiles.Count-1 do
      begin
        sFileName:= oFiles.Strings[iK];                                   //fmOpenRead {$WARNINGS OFF} or fmShareCompat{$WARNINGS ON} );

        try
          if (length(sFileName) > 0) and (sFileName[1] = '"') and (sFileName[length(sFileName)] = '"') then
            sFileName := copy(sFileName,2,length(sFileName)-2);
          oFile := TFileStream.Create(sFileName,  fmShareDenyNone	); //{$WARNINGS OFF}  fmShareCompat{$WARNINGS ON} );

        except
          try
            oFile := TFileStream.Create('"'+sFileName +'"',  fmShareDenyNone	); //{$WARNINGS OFF}  fmShareCompat{$WARNINGS ON} );
          except
          //file path probably has a comma in it! oh well.
            oFile := nil;
          end;
        end;
        if assigned(ofile) then
        try
          FibDtl.Close;
          FibDtl.ParamByName('Inc_CommsMast'  ).AsInteger:= iInc;
          FibDtl.ParamByName('ContentType'    ).AsString := 'A';
          FibDtl.ParamByName('ContentDesc'    ).AsString := ExtractFileName(sFileName);
          FibDtl.ParamByName('ContentBlobSize').AsInteger:= oFile.Size;
          FibDtl.ParamByName('ContentBlob'    ).LoadFromStream(oFile,ftMemo);
          FibDtl.ParamByName('CreatedBy'      ).AsString := aconfig.CreatedBy;
          FibDtl.ExecSql;
          FibDtl.Close;
          iSize:= iSize+oFile.Size;
        finally
          oFile.Free;
        end;


      end;
    finally
      oFiles.Free;
    end;
  end;

  // Generate header
  FibHdr.Close;
  FibHdr.ParamByName('Inc_CommsMast').AsInteger:= iInc;
  FibHdr.ParamByName('LinkerType')  .AsString := '';
  FibHdr.ParamByName('Inc_Linker')  .AsInteger:= AConfig.Inc_Linker;
  FibHdr.ParamByName('LinkerRef')   .AsString := AConfig.LinkerRef;
  FibHdr.ParamByName('SenderUserNo').AsString := AConfig.SenderUser;
  FibHdr.ParamByName('Subject')     .AsString := LeftStr(AEmailItem.HdrSubject, 128);
  FibHdr.ParamByName('ContentSize') .AsInteger:= iSize;
  FibHdr.ParamByName('CommsSite')   .AsString := AConfig.CommSite;
  FibHdr.ParamByName('CommsType')   .AsString := CaidCommunicationType[AConfig.CommType];; // Email
  FibHdr.ParamByName('CreatedBy')   .AsString := aconfig.CreatedBy;
  FibHdr.ExecSql;
  FibHdr.Close;
end;




procedure TaidCommunicationsThread.initialiseConn();
begin

  IB_ConnectionComms    := TIB_Connection   .Create(nil);
  IB_TransactionComms   := TIB_Transaction  .Create(IB_ConnectionComms);

  IB_ConnectionComms  .DefaultTransaction := IB_TransactionComms;
  IB_TransactionComms.IB_Connection       := IB_ConnectionComms;
  if FCommsData.DatabaseName = '' then
  begin
    if not AssignDatabaseDetails(IB_ConnectionComms , FCommsData.CommsDbAlias) then
    begin
      raise Exception.create('Database has not been registered');
    end;
  end  
  else
  begin
    IB_ConnectionComms.DatabaseName := FCommsData.databasename;
    IB_ConnectionComms.Username     := FCommsData.DatabaseUser;
    IB_ConnectionComms.password     := FCommsData.DatabasePswd;
  end;

  IB_ConnectionComms.loginprompt  := false;
  IB_ConnectionComms.SQLDialect   := 1;
  // Transaction Parameters

  IB_TransactionComms.RecVersion  :=  true;
  IB_TransactionComms.lockwait    := false;
  IB_TransactionComms.Isolation   := tiCommitted ;

  FIBGen  := TIBOQuery        .Create(IB_ConnectionComms);
  FIBHdr  := TIBOQuery        .Create(IB_ConnectionComms);
  FIBDtl  := TIBOQuery        .Create(IB_ConnectionComms);
  // Cross-link components
  FIBGen.IB_Connection:= IB_ConnectionComms; FIBGen.ib_Transaction:= IB_TransactionComms;
  FIBHdr.IB_Connection:= IB_ConnectionComms; FIBHdr.ib_Transaction:= IB_TransactionComms;
  FIBDtl.IB_Connection:= IB_ConnectionComms; FIBDtl.ib_Transaction:= IB_TransactionComms;
end;



end.



