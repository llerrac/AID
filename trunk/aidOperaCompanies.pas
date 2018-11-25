unit aidOperaCompanies;

{ -------------------------------------------------------------------------------------------------
  Name        : aidOperaCompanies
  Author      : Chris G. Royle
  Description :
    ToperaCompanies
      Component to read & store Opera Company configurations. The information for this
      is collected from the Opera System folder, table SeqCO.dbf.

    BookkeepingCompanyToSite
      These routines map BOMs sites to Opera companies & vice-versa. Currently this is
      hard-coded, but it could be populated from BOMs database, SiteAc table.
  Note        :
  Modified    :
    CGR20061213, Modified the MangleFolderName routine to support (not change) UNC file names.
    CGR20070102, Modified the routines to support Site 'B'.
    CGR20070105, Modified to return a Creditors Account suffices, and error messages which
      have been returned by failed connections.
    ajc20110307, added training and Usa Opera entries
    ajc20110401 : **NOTES**
                  Long ago I changed how Opera company information is passed from Boms to Opera.
                    *key Insure command line switch 'Test' is not in operation.
                    *What out the Boms company type -aidauBobst,aidauAtlas is in operation for an event.
                    *Make sure Loop back is not on.
                      -Sales order with loop back will have loop back ACCNo, Delno and Vat values of something like NNS,
                    *Make sure the dynamic DDI, file for purchase importants is set up to handle teh company, the DDI_opera.INI in FMOpera.exe root.
                      -Each Opera Company has a section by table. The is no system wide default, but only company table set ups. 
  -------------------------------------------------------------------------------------------------}

interface

uses
  { Delphi Units }
  Classes,
  { 3rd Party Units }
  { Application Units }
  aidTypes, aidOperaTypes, ADODB;

type
  ToperaCompanyNo    = Char{'A'..'Z'};
type
  TAccountingPackage = Char{'O', '2'};

const
  CAccountingPackageOperaI  = 'O';  { Opera Version I }
  CAccountingPackageOperaII = '2';  { Opera Version 2 }

type
  ToperaCompanies = class(TObject)
  private
    FOperaSystemFolderName: string;
    FOnLogEvent: TaidLogEvent;
    FCompanies  : TStringList;
    FlPopulated : Boolean;
    FsLastError : String;
    procedure AddOperaCompany(Company: ToperaCompany);
    procedure SetOperaSystemFolderName(const Value: string);
    procedure SetOnLogEvent(const Value: TaidLogEvent);
    procedure DoLog(AsLog: string);
    function  MangleFolderName(AsOperaSystemFolder, AsFolderToMangle: string): string;
    procedure AddCompany(AcCompany: Char; ArCompany: ToperaCompany);
    function  GetCount : Integer;
  protected
    procedure AddToLog(AsLog: string);
    procedure AddToLogBreak;
  public
    constructor Create();
    destructor  Destroy; override;
    //
    procedure   Clear();
    procedure   ReadCompanies();
    //
    function    Company(AcCompany: Char   ): ToperaCompany; overload;
    function    Company(AiCompany: Integer): ToperaCompany; overload;
    {}
    property    Count                : Integer      read GetCount;
    property    LastError            : String       read FsLastError;
    property    Populated            : Boolean      read FlPopulated;
  published
    property    OperaSystemFolderName: string       read FOperaSystemFolderName write SetOperaSystemFolderName;
    property    OnLogEvent           : TaidLogEvent read FOnLogEvent            write SetOnLogEvent;
  end;


{ SiteToBookkeepingCompany
    Converts the BOM's site codes to the opera company prefix }
function SiteToBookkeepingCompany(AcSite   : TSiteNo): ToperaCompanyNo;
{ BookkeepingCompanyToSite
    Converts the Opera Bookkeeping code to a BOMs site ID.  }
function BookkeepingCompanyToSite(AcCompany: ToperaCompanyNo): TSiteNo;
{ BookkeepingCompanyDebtorsAccountSuffix  (CGR20070102)
    Returns the suffix to use against debtor accounts for a specific set of Opera books.}
function BookkeepingCompanyDebtorsAccountSuffix(AcCompany: ToperaCompanyNo): String;
{ BookkeepingCompanyCreditorsAccountSuffix  (CGR20070102)
    Returns the suffix to use against debtor accounts for a specific set of Opera books.}
function BookkeepingCompanyCreditorsAccountSuffix(AcCompany: ToperaCompanyNo): String;


implementation

uses
  { Delphi Units }
  SysUtils, db,
  { 3rd Party Units }
  { Application Units }
  crUtil, crdbUtil;

type
  TOperaCompanyObj = class(TObject)
  private
    FCompany: ToperaCompany;
  public
    constructor Create(ACompany: ToperaCompany);
    property    Company: ToperaCompany read FCompany;
  end;
  TAddOperaCompany = procedure(Company: ToperaCompany) of object;

resourcestring
  SourceMark  = '<<Sourcepathname.database>>';

  adoConnectionString
  //'Provider=VFPOLEDB.1;Data Source='
//                        +'<<Sourcepathname.database>>' //note same as 'SourceMark'
//                        +';Mode=Share Deny None;Extended Properties="";User ID="";Password="";Mask Password=False;Cache Authentication=False;Encrypt Password=False;Collating Sequence=MACHINE;DSN=""';
                        ='Provider=VFPOLEDB.1;Data Source=<<Sourcepathname.database>>;Password="";Collating Sequence=MACHINE';
(****************************************************************************
{ToperaCompanies}
****************************************************************************)
constructor ToperaCompanies.Create;
begin
  FCompanies:= TStringList.Create;
  FCompanies.Sorted:= True;
  FlPopulated:= False;
  FsLastError:= '';
end;

destructor ToperaCompanies.Destroy;
begin
  try
    self.Clear;
  finally
    FreeAndNil(FCompanies);
  end;
  inherited;
end;

procedure ToperaCompanies.AddOperaCompany(Company: ToperaCompany);
begin
  if not IsEmptyStr(Company.Co_Code) then
  begin
    Company.Populated := True;
    AddCompany(Company.Co_Code, Company);
    AddToLog('Read: '+Company.Co_Code+'= '+Company.co_SubDir+' '+Bracket(Company.co_Name));
  end;
end;

function ToperaCompanies.Company(AiCompany: Integer): ToperaCompany;
begin
  FillChar(Result, SizeOf(ToperaCompany), #0);
  if ((AiCompany>=0) and (AiCompany<FCompanies.Count)) then
  begin
    if Assigned(FCompanies.Objects[AiCompany]) and (FCompanies.Objects[AiCompany] is TOperaCompanyObj) then
      Result:= TOperaCompanyObj(FCompanies.Objects[AiCompany]).Company;
  end;
end;



function ToperaCompanies.Company(AcCompany: Char): ToperaCompany;
var
  iK  : Integer;
begin
  FillChar(Result, SizeOf(ToperaCompany), #0);
  iK:= FCompanies.IndexOf(AcCompany);
  if (iK>=0) then
    if Assigned(FCompanies.Objects[iK]) and (FCompanies.Objects[iK] is TOperaCompanyObj) then
    begin
      Result:= TOperaCompanyObj(FCompanies.Objects[iK]).Company;
    end;
end;


procedure ToperaCompanies.SetOnLogEvent(const Value: TaidLogEvent);
begin
  FOnLogEvent := Value;
end;

procedure ToperaCompanies.SetOperaSystemFolderName(const Value: string);
begin
  FOperaSystemFolderName := Value;
end;


{ ReadCompanies()
    Attempts to load the company information in to the object. }
procedure ToperaCompanies.ReadCompanies();
var
  sSystem   : string;


  rCompany  : ToperaCompany;
  uCO_Code,
  uCO_Name,
  uCO_SubDir,
  uCO_SlNlCo,
  uCO_PlNlCo: TField;
  procedure loadVia_Ado_VFP9(rCompany  : ToperaCompany;p_addCompany : TAddOperaCompany);
  var
    ADOTable_SeqCo: TADOTable;
    acs : string;
    procedure exceptAndOpen(path : string);
    begin
      ADOTable_SeqCo.ConnectionString := stringreplace(adoConnectionString,SourceMark,path,[]);
      ADOTable_SeqCo.TableName   := 'SEQCO.DBF';
      ADOTable_SeqCo.Open;
    end;

  begin
    // Create a temporary table to inspect the companies config.
    // note that this is done in code, as there are structure
    // diffences between Opera I & Opera II.
    ADOTable_SeqCo := TADOTable.Create(nil);
    try
        //FOperaSystemFolderName
      try
        exceptAndOpen(FOperaSystemFolderName)
      except
        try
          exceptAndOpen(ExpandUNCFileName(FOperaSystemFolderName));
        except
          raise;
        end;
      end;
      acs := FOperaSystemFolderName;
      try
        while not ADOTable_SeqCo.Eof do
        begin
          uCO_Code  := ADOTable_SeqCo.FindField('CO_CODE'  );
          uCO_Name  := ADOTable_SeqCo.FindField('CO_NAME'  );
          uCO_SubDir:= ADOTable_SeqCo.FindField('CO_SUBDIR');
          uCO_SlNlCo:= ADOTable_SeqCo.FindField('CO_SLNLCO');
          uCO_PlNlCo:= ADOTable_SeqCo.FindField('CO_PLNLCO');

          FillChar(rCompany, SizeOf(ToperaCompany), #0);
          //ajc - added trim in, appears that ABC add crap into the paths. white space and new line feeds
          if Assigned(uCO_Code  ) then rCompany.Co_Code  := StringToChar(trim(uCO_Code  .AsString));
          if Assigned(uCO_Name  ) then rCompany.Co_Name  := trim(uCO_Name  .AsString);
          if Assigned(uCO_SubDir) then rCompany.Co_SubDir:= trim(uCO_SubDir.AsString);
          if Assigned(uCO_SlNlCo) then rCompany.Co_SlNlCo:= StringToChar(trim(uCO_SlNlCo.AsString));
          if Assigned(uCO_PlNlCo) then rCompany.Co_PlNlCo:= StringToChar(uCO_PlNlCo.AsString);
          rCompany.DataPath:= MangleFolderName(trim(sSystem), trim(rCompany.Co_SubDir));
          // Handle blank/missing Sales Ledger / Purchase Ledger information. Default these to the Opera Company Code.
          if IsEmptyStr(rCompany.Co_SlNlCo) then rCompany.Co_SlNlCo:= rCompany.Co_Code;
          if IsEmptyStr(rCompany.Co_PlNlCo) then rCompany.Co_PlNlCo:= rCompany.Co_Code;

          p_addCompany(rCompany);

          ADOTable_SeqCo.Next;
        end;
      finally
        ADOTable_SeqCo.Close;
      end;
    finally
      FreeAndNil(ADOTable_SeqCo);
    end;

  end;
begin
  if not IsEmptyStr(OperaSystemFolderName) then
  begin
    sSystem:= Self.OperaSystemFolderName;
    AddToLogBreak;
    AddToLog('Reading System Company Configuration(s): '+sSystem);
    //
    try
      Clear;
      //Loadvia_Apollo;
      loadVia_Ado_VFP9(rCompany,AddOperaCompany);

      //
      AddToLog(Int2Plural(self.Count, ' Company configuration')+' read.');
      AddToLogBreak;
      //
      FlPopulated:= True;
    except
      on E:Exception do
      begin
        FsLastError:= 'Exception reading System Company Configuration: '+e.Message;
        AddToLog(FsLastError);
      end;
    end;
  end;
end;

procedure ToperaCompanies.AddToLog(AsLog: string);
begin
  DoLog(AsLog);
end;

procedure ToperaCompanies.AddToLogBreak;
begin
  AddToLog(crUtil.Replicate('-', 80));
end;

procedure ToperaCompanies.DoLog(AsLog: string);
begin
  if Assigned(FOnLogEvent) and (not IsEmptyStr(AsLog)) then
    FOnLogEvent(Self, AsLog);
end;

/// <summary>
///     This routine attempts to match the server drive settings to any local shares. Not
///    required when the data folder names are UNC.
///    Not required if system folder is local .
/// </summary>
/// <param name="AsOperaSystemFolder"></param>
/// <param name="AsFolderToMangle"></param>
/// <returns>string</returns>

function ToperaCompanies.MangleFolderName(AsOperaSystemFolder, AsFolderToMangle: string): string;
var
  sParent : string;
  sDataDrv: string;
  sDataOff: string;
begin
  // Input to this function is the location of the system folder eg p:\SYSTEM
  Result  := AsFolderToMangle;
  // Establish the parent folder from the AsOperaSystemFolder argument
  sParent := ExtractFilePath (ExcludeTrailingPathDelimiter(AsOperaSystemFolder)+'abc.pas'); // dodgy trick - treat the SYSTEM folder name as a file, & then extract the parent folder.
  sDataDrv:= ExtractFileDrive(AsFolderToMangle);    // establish the drive
  if (LeftStr(sDataDrv, 2) = '\\') then
    Result:= IncludeTrailingPathDelimiter(AsFolderToMangle)
  else if (pos(sParent,AsFolderToMangle) > 0) then
  //the folder to be mangled is already has correct path....Assume it is the path to data directory.
  begin
    Result:= IncludeTrailingPathDelimiter(trim(AsFolderToMangle))
  end
  else
  begin
    sDataOff:= Trim(RightStr(AsFolderToMangle, Length(AsFolderToMangle)-Length(sDataDrv)));         // remove the drive part
    // Add a / or \ to the offset before suffixing to the Parent
    if (Length(sDataOff)=0) or ((Length(sDataOff)>0) and (not IsPathDelimiter(sDataOff, 1) )) then
      sDataOff:= IncludeTrailingPathDelimiter('')+sDataOff;
    //
    Result  := IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(sParent)+sDataOff);
  end;
end;

procedure ToperaCompanies.Clear;
var
  iK    : Integer;
begin
  for iK:= 0 to FCompanies.Count-1 do
  begin
    if Assigned(FCompanies.Objects[iK]) then
    begin
      FCompanies.Objects[iK].Free;
      FCompanies.Objects[iK]:= nil;
    end;
  end;
  FCompanies.Clear;
end;

procedure ToperaCompanies.AddCompany(AcCompany: Char; ArCompany: ToperaCompany);
var
  iK  : Integer;
begin
  iK:= FCompanies.IndexOf(AcCompany);
  if (iK<0) then
  begin
    FCompanies.AddObject(AcCompany, ToperaCompanyObj.Create(ArCompany));
  end;
end;

function ToperaCompanies.GetCount: Integer;
begin
  Result:= FCompanies.Count;
end;


{ TOperaCompanyObj }
constructor TOperaCompanyObj.Create(ACompany: ToperaCompany);
begin
  FCompany:= ACompany;
end;



{ SiteToBookkeepingCompany
    Converts the BOM's site codes to the opera company prefix }
function SiteToBookkeepingCompany(AcSite: TSiteNo): ToperaCompanyNo;
begin
  result:= #0;
  case StringToChar(acSite) of
    { Bedfordshire }
    'A',
    'B',
    'C' : Result:= 'B';
    'T' : Result:= 'T'; //  Bedford (Atlas Converting Limited    ( in 2007 Consolidation of A & T ) and in 2011 T was made a Test database.
(*  Modified CGR20070201 to accomodate the consolidation of A & T Opera books to Company 'B'.
    'B' : Result:= 'B'; // Bedford (Atlas Converting Limited    ( 2007 Consolidation of A & T )
    'A' : Result:= 'A'; // Bedford (Atlas Machines)             ( Obsolete as of y/e end 2006 )
    'C' : Result:= 'A'; // Bedford Call Centre (Spares & Service)
    'T' : Result:= 'T'; // Biggleswade (Titan / Sheeters)       ( Obsolete as of y/e end 2006 ) *)
    { Manchester }
    'G',                // General Vacuum (Heywood)
    'H' : Result:= 'G'; // General Vacuum (Heywood) Spares
    //USA
    'U' : Result:= 'C'; //T for training/test but will be 'C' for Charlotte USA when LIVE
  else
    // Need to show an error message here ~
    // ~~~~~~~
  end;
end;


{ BookkeepingCompanyToSite
    Converts the Opera Bookkeeping code to a BOMs site ID.  }
function BookkeepingCompanyToSite(AcCompany: ToperaCompanyNo): TSiteNo;
begin
  result:= #0;
  case AcCompany of
    { Bedfordshire }
    'B' : Result:= 'A'; // Bedford ( 2007 Consolidation of A & T )
(*  Modified CGR20070201 to accomodate the consolidation of A & T Opera books to Company 'B'.
    'B' : Result:= 'B'; // Bedford ( 2007 Consolidation of A & T )
    'A' : Result:= 'A'; // Bedford (Atlas'ish)
    'T' : Result:= 'T'; // Biggleswade (Titan'ish  / Sheeters) *)
    { Manchester }
    'G' : Result:= 'G'; // General Vacuum (Heywood)
    //USA
    'C' : Result := 'U';
    //Training
    'T' : Result := 'U';
  else
    // Need to show an error message here ~
    // ~~~~~~~
  end;
end;


{ BookkeepingCompanyDebtorsAccountSuffix  (CGR20070102)
    Returns the suffix to use against debtor accounts for a specific set of Opera books.}
function BookkeepingCompanyDebtorsAccountSuffix(AcCompany: ToperaCompanyNo): String;
begin
  Result:= AcCompany;
  if SameText('B', AcCompany) then
    Result:= 'A'; { Accounts in the Debtors & Creditors ledgers in 2007 'B' books are suffixed by 'A'. This may change ! }
  if SameText('T', AcCompany) then
    Result:= 'T'; { Accounts in the Debtors & Creditors ledgers in 2007 'B' books are suffixed by 'A'. This may change ! }
  if SameText('C', AcCompany) then
    Result:= 'C'; { Accounts in the Debtors & Creditors ledgers in 2007 'B' books are suffixed by 'A'. This may change ! }

end;


{ BookkeepingCompanyCreditorsAccountSuffix  (CGR20070102)
    Returns the suffix to use against debtor accounts for a specific set of Opera books.}
function BookkeepingCompanyCreditorsAccountSuffix(AcCompany: ToperaCompanyNo): String;
begin
  Result:= AcCompany;
  if SameText('B', AcCompany) then
    Result:= 'A'; { Accounts in the Debtors & Creditors ledgers in 2007 'B' books are suffixed by 'A'. This may change ! }
  if SameText('T', AcCompany) then
    Result:= 'T'; //T - tEST GOEING TO TEST
  if SameText('C', AcCompany) then
    Result:= 'C'; //C- cHARLOTTE GOING TO TEST data

end;


end.
