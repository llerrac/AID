unit aidCommsTypes;
(*******************************************************************************
created by    :?
created on    :?
Purpose       :?

Comments      : type definitions for COMMS system in Bobst Boms software
                along with type functions for type serialisation

  ajc2008dec   Switched the database api used to IBO.


*******************************************************************************)
interface

uses
  Classes, Types;

{ Email Formats }
type
  TaidEmailFormat    = (aidEmailPlainText, aidEmailHTML);
const
  CaidEmailFormat    : array[TaidEmailFormat] of string = ('Text', 'HTML');
{ Communication Types }
type
  TaidCommunicationType = (aidCommEmail);
const
  CaidCommunicationType : Array[TaidCommunicationType] of string = ('E');
{ Communication Links eg Purchase Order}
type
  TaidCommunicationLinker = (aidCommUnknown);
{ Communications Content Type }
type
  TaidCommContentType     = (aidCommEmailXMLWrapped, aidCommEmailAttachment);
const
  CaidCommContentType     : array[TaidCommContentType] of string
                          = ('E', 'A');
{}
type
  TaidCommunicationEmail = record
    HdrTo           : string; // CSV style TO list
    HdrCC           : string; // CSV style CC list
    HdrBCC         : string; // CSV style CC list
    HdrSubject      : string; // Communication Subject
    HdrFrom         : string; // From email address
    HdrReplyTo      : string; // single reply to - if blank, HdrFrom is used.
    MessageFormat   : TaidEmailFormat;
    MailMessage     : string; // Email Body
    Attachments     : string; // CSV style filenames  (Deletable ?) )
    Recipients      : string; // CSV style recipients list (should be the same as HdrTo+HdrCC + and BCCs)
    RequestReceipt  : Boolean;// Request read receipt ?
    __UNDERLYINGUSER : string;
  end;
{ TEmailStringList
    Helper class for dealing with strings containing email addresses  }

type
  TEmailStringList = class(TStringList)
  private
  protected
  public
    constructor Create;
    procedure AddEmails(AsNames: string; AlClearFirst: Boolean = True); overload;
    procedure AddEmails(AasNames: Array of string; AlClearFirst: Boolean = True); overload;
    function  AllEmailHaveDomain(AsDomain: string): Boolean;
    procedure TidyEmailsForExchangeSMTP();
  end;



function CommunicationTypeAsOrder(AsCommunicationType: string): TaidCommunicationType;
function EmailFormatAsOrder(AsEmailFormat: string): TaidEmailFormat;
function AddressContainsDomain(emailaddress : string; domain : string) : boolean;



implementation

uses
  SysUtils, crUtil;

//******************************************************************************/
//Global*************************************************************************/
function AddressContainsDomain(emailaddress : string; domain : string) : boolean;
var
  iAt     : Integer;
  sDomain : string;
begin
  //Result:= False;
  if SubStr(domain, 1, 1) = '@' then
    Domain:= Copy(domain, 2, Length(domain)-1);

  //emailaddress
  iAt    := Pos('@', emailaddress);
  sDomain:= Copy(emailaddress, Succ(iAt), Length(emailaddress)-iAt);

  Result:= SameText(Domain, sDomain);
end;

{ Communication Links }
function CommunicationTypeAsOrder(AsCommunicationType: string): TaidCommunicationType;
var
  iK  : TaidCommunicationType;
begin
  Result:= Low(TaidCommunicationType);
  for iK:= Low(TaidCommunicationType) to High(TaidCommunicationType) do
    if (CaidCommunicationType[iK] = AsCommunicationType) then
    begin
      Result:= iK;
      Break;
    end;
end;


function EmailFormatAsOrder(AsEmailFormat: string): TaidEmailFormat;
var
  iK  : TaidEmailFormat;
begin
  Result:= aidEmailPlainText;
  for iK:= Low(TaidEmailFormat) to High(TaidEmailFormat) do
    if SameText(CaidEmailFormat[iK], AsEmailFormat) then
    begin
      Result:= iK;
      Break;
    end;
end;


{ TEmailStringList }
procedure TEmailStringList.AddEmails(AsNames: string; AlClearFirst: Boolean = True);
// email format (roughly) [0-9a-zA-Z\-\.]+@[0-9a-zA-Z\-\.]+\.[a-zA-Z]
var
  sBuffer : string;
  sEmail  : string;
  iAt     : Integer;
  iPos    : Integer;
begin
  if AlClearFirst then
    self.Clear;
  //
  if (not IsEmptyStr(AsNames)) then
  begin
    sBuffer:= AsNames;
    // @ sign should always exist.
    repeat
      sEmail:= '';
      iAt   := Pos('@', sBuffer);
      // Assume any thing prior to @, and anything subsequent UNTIL EOS / whitespace / delimiter is part of the email.
      // Note that the following is valid, so the algorythm should handle these:
      if (iAt>0) then
      begin
        sEmail:= Copy(sBuffer, 1, iAt);
        iPos  := Succ(iAt);
        while iPos<=Length(sBuffer) do
        begin
          case sBuffer[iPos] of
            ',',
            ';',
            ' ' : // treat as a delimiter
            begin
              self.Add(Trim(sEmail));
              sEmail:= '';
              inc(iPos);
              break;
            end;
          else
            sEmail:= sEmail+sBuffer[iPos];
            inc(iPos);
          end;
        end;

        if (iPos>=Length(sBuffer)) and (not isEmptyStr(sEmail)) then
        begin
          self.Add(Trim(sEmail));
          sBuffer:= '';
        end
        else
          sBuffer:= Copy(sBuffer, iPos, (Length(sBuffer)-iPos)+1);

      end;
    until (iAt<=0);
  end;
end;

procedure TEmailStringList.AddEmails(AasNames: array of string; AlClearFirst: Boolean = True);
var
  iK  : Integer;
begin
  if AlClearFirst then
    self.Clear;
  //
  if Length(AasNames)>0 then
    for iK:= Low(AasNames) to High(AasNames) do
      self.AddEmails(AasNames[iK], False);
end;

function TEmailStringList.AllEmailHaveDomain(AsDomain: string): Boolean;
var
  sEmail  : string;
  iK      : integer;
begin
  Result:= False;
  if SubStr(AsDomain, 1, 1) = '@' then
    AsDomain:= Copy(AsDomain, 2, Length(AsDomain)-1);
  //
  for iK:= 0 to Count-1 do
  begin
    sEmail := Strings[iK];
    result := AddressContainsDomain(sEmail, Asdomain );
    if not result then
      break;
  end;
end;

constructor TEmailStringList.Create;
begin
  inherited;
  Delimiter := ';';
  Duplicates:= dupIgnore;
end;


{ TidyEmailsForExchangeSMTP()
    Convert for submission to Exchange SMTP server.}
procedure TEmailStringList.TidyEmailsForExchangeSMTP();
var
  iK    : Integer;
  iL    : Integer;
  iR    : Integer;
  iAt   : Integer;
  sEmail: String;
begin
  for iK:= 0 to Count-1 do
  begin
    sEmail:= Strings[iK];
    { Dragging an address from Outlook, the system uses [ ] to delimit the mail address WHEN a friendly name is known. We simply test for this and replace with < > }
    iL := Pos('[', sEmail);
    iR := Pos(']', sEmail);
    iAt:= Pos('@', sEmail);
    if (iL>0) and (iAt>iL) and (iR>iAt) then
    begin
      sEmail [iL]:= '<';
      sEmail [iR]:= '>';
      Strings[iK]:= sEmail;
    end;
  end;
  { Remove blank strings. }
  iK:= 0;
  while iK<(Count-1) do
  begin
    if IsEmptyStr(Strings[iK]) then
      Delete(iK)
    else
      Inc(iK);
  end;
end;

end.
