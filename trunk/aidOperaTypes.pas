unit aidOperaTypes;

{ aidOperaTypes
    Data Types relevant for Opera I & II Integration.
}

interface

type
  ToperaCompany = record
    Populated : Boolean;
    //
    Co_Code   : Char;        // Company Code
    Co_Name   : String[255]; // Company Name
    Co_SubDir : string[255]; // Data Folder
    Co_SlNlCo : Char;        // Sales Ledger Nominal Company
    Co_PlNlCo : Char;        // Purchase Ledger Nominal Company
    //
    DataPath  : string[255]; // Mangled Co_SubDir
  end;

implementation


end.
