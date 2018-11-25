unit d_aidTemplate;

(*******************************************************************************
created by    :alex carrell (ajc)
created on    : 2011 JUne
Purpose       : base class for plugin data modules.
              -basically, a lot of teh software uses lookups requiring data. IN general, it does not matter where this data is, as long as it exists.
              Currently though its all in d_bom.pas. The thought is to abstract the requests for lookups, then provide a mechanism for providers of lookups
              to register the lookups the provide in a central location/class. The lookups as placed in a datamodule that implements the interface provided here.
              IAidSharedLookups.
              Secondly a system to register, resolve, and reply to requests.
              This is encapulated by TaidDataRegsitry


Comments      :


*******************************************************************************)
interface


uses
  SysUtils, Classes;

type
  TDataModule2 = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.dfm}

end.
