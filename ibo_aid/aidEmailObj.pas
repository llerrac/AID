unit aidEmailObj;

{ name        : aidEmailObj.pas
  description : Object for wrappering an email.
}

interface

uses
  aidCommsObj, Classes;


type
  TaidEmailFormat   = (aidEmailPlainText, aidEmailRichText);
  TaidEmailPriority = (aidEmailNormal, aidEmailHighPriority);

type
  TaidEmailArgument = Class(TPersistent)
  Public
    constructor Create();
    destructor  Destroy; override;
  Private
    FoToAddresses: TStrings;
    FoCCAddresses: TStrings;
    FSender      : String;
    FSubject     : String;
    FFormat      : TaidEmailFormat;
    FoBody       : TStrings;
    FPriority    : TaidEmailPriority;
    FoAttachments: TStrings;
    FoTemporaryFiles: TStrings;
    {}
    FLogTransmission: Boolean;
    FRequestReadReceipt: Boolean;
    FBCCAddresses: TStrings;
    procedure SetToAddresses(const Value: TStrings);
    procedure SetCCAddresses(const Value: TStrings);
    procedure SetSender(const Value: String);
    procedure SetSubject(const Value: String);
    procedure SetFormat(const Value: TaidEmailFormat);
    procedure SetBody(const Value: TStrings);
    procedure SetPriority(const Value: TaidEmailPriority);
    procedure SetAttachments(const Value: TStrings);
    procedure SetLogTransmission(const Value: Boolean);
    procedure SetRequestReadReceipt(const Value: Boolean);
    procedure SetTemporaryFiles(const Value: TStrings);
    procedure SetBCCAddresses(const Value: TStrings);
  Protected
    Procedure AssignTo(Dest: TPersistent); override;
  Public
  Published
    // procedure SendEmail(sTo, sFrom, sSubj, sBody: string; sCC: string = ''; sAttach: string = ''; lCleanUp: Boolean = False; lLogSends: Boolean = False; AuAttachments: TStrings = nil; AlRequestReadReceipt: Boolean = False); overload;
    property ToAddresses: TStrings read FoToAddresses write SetToAddresses;
    property CCAddresses: TStrings read FoCCAddresses write SetCCAddresses;
    property BCCAddresses: TStrings read FBCCAddresses write SetBCCAddresses;
    property Sender     : String read FSender write SetSender;
    property Subject    : String read FSubject write SetSubject;
    property Format     : TaidEmailFormat read FFormat write SetFormat;
    property Body       : TStrings read FoBody write SetBody;
    property Priority   : TaidEmailPriority read FPriority write SetPriority;
    property Attachments: TStrings read FoAttachments Write SetAttachments;
    property TemporaryFiles: TStrings read FoTemporaryFiles Write SetTemporaryFiles;
    { functions }
    property RequestReadReceipt : Boolean read FRequestReadReceipt write SetRequestReadReceipt;
    property LogTransmission    : Boolean read FLogTransmission write SetLogTransmission;
  End;

implementation

{ TaidEmailArgument }

uses
  SysUtils;

procedure TaidEmailArgument.AssignTo(Dest: TPersistent);
begin
  if Dest is TaidEmailArgument then
    with TaidEmailArgument(Dest) do
    Begin
      Attachments.Assign(Self.Attachments);
      ToAddresses.assign(self.ToAddresses);
      CCAddresses.assign(self.CCAddresses);
      BCCAddresses.assign(self.BCCAddresses);
      Format      := self.format;//ailPlainText;
      Body.assign(self.body);
      Priority    := self.priority;
      subject     := self.subject;
    End
  else
    inherited;
end;

constructor TaidEmailArgument.Create;
begin
  inherited;
  FoToAddresses := TStringList.Create;
  FoCCAddresses := TStringList.Create;
  FBCCAddresses := TStringList.Create;
  FFormat      := aidEmailPlainText;
  FoBody        := TStringList.Create;
  FPriority    := aidEmailNormal;
  FoAttachments:= TStringList.Create;
  FoTemporaryFiles:= TStringList.Create;
end;

destructor TaidEmailArgument.Destroy;
begin
  FreeAndNil(FoToAddresses);
  FreeAndNil(FoCCAddresses);
  FreeAndNil(FBCCAddresses);
  FreeAndNil(FoBody);
  FreeAndNil(FoAttachments);
  FreeAndNil(FoTemporaryFiles);
  inherited;
end;

procedure TaidEmailArgument.SetAttachments(const Value: TStrings);
begin
  FoAttachments := Value;
end;

procedure TaidEmailArgument.SetTemporaryFiles(const Value: TStrings);
begin
  FoTemporaryFiles := Value;
end;

procedure TaidEmailArgument.SetToAddresses(const Value: TStrings);
begin
  FoToAddresses := Value;
end;

procedure TaidEmailArgument.SetBody(const Value: TStrings);
begin
  FoBody.assign(Value);
end;

procedure TaidEmailArgument.SetCCAddresses(const Value: TStrings);
begin
  FoCCAddresses := Value;
end;

procedure TaidEmailArgument.SetFormat(const Value: TaidEmailFormat);
begin
  FFormat := Value;
end;

procedure TaidEmailArgument.SetLogTransmission(const Value: Boolean);
begin
  FLogTransmission := Value;
end;

procedure TaidEmailArgument.SetPriority(const Value: TaidEmailPriority);
begin
  FPriority := Value;
end;

procedure TaidEmailArgument.SetRequestReadReceipt(const Value: Boolean);
begin
  FRequestReadReceipt := Value;
end;

procedure TaidEmailArgument.SetSender(const Value: String);
begin
  FSender := Value;
end;

procedure TaidEmailArgument.SetSubject(const Value: String);
begin
  FSubject := Value;
end;

procedure TaidEmailArgument.SetBCCAddresses(const Value: TStrings);
begin
  FBCCAddresses := Value;
end;
end.
