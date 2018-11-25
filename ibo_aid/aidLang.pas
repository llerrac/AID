unit aidLang;

{ -------------------------------------------------------------------------------------------------
  Name        : aidLang
  Author      : Chris G. Royle
  Description : Language Items for Atlas applications. 
  Note        :
  See Also    : bomLang.pas
  Modified    :
    CGR20061011, Added rsDocLink.
  -------------------------------------------------------------------------------------------------}

interface

uses
  crTypes;

resourcestring
  rsInvalidArgumentsToProcedure =
          'Invalid or unexpected arguments were passed to %s.'#13#10#13#10+
          'Please notify the support department, quoting the above, and'#13#10+
          'describe the steps which lead up to this message being displayed.';
resourcestring
  rsPartHasReplacement=
          'This part has a replacement - would you rather select the'+#13+
          'replacement ?';

  rsAccountsDeptOnly  = 'This function can only be performed by  '+#13+
                        'the Accounts department - please contact:'+CCRCR+
                        'Norma Williams'+#13+
                        '     email: Myrna.James@atlasconverting.com'+#13+
                        '     dial : extension 221';
          
  rsFullDelivery  = 'Full Delivery';
  rsPartDelivery  = 'Part Delivery';
  rsDeletedRecord = 'DELETED RECORD';
  rsConnected     = 'Connected';
  rsDisconnected  = 'Disconnected';
  rsXMLServerAddressInvalid =
    'Invalid XML server address - please'+#13+
    'check workstation settings.';

resourcestring
  rsDocDrawing     = 'Drawn';
  rsDocScan        = 'Scan';
  rsDocInfo        = 'Info';
  rsDocDocument    = 'Document';
  rsDocManual      = 'Manual';
  rsDocCertificate = 'Certificate';
  rsDocLink        = 'Link';
  rsUnknown        = '<unknown>';
resourcestring // for user maintenance
  rsBlankUserNotAllowed   = 'Blank User Names are not allowed'; 
  rsUserNoTooShort        = 'The user name needs to be 3 or more characters long';
resourcestring
  rsValidCompanyRequired  = 'A valid company account is required.';
  //
  rsCompanyInvalidWarning = 'Warning: The company account entered is incorrect';
  rsCompanyNotSiteWarning = 'Warning: The company account entered is not valid'#13+
                            'for this site.';
  //
  rsValidCustomerRequired = 'A valid Customer Company Account'#13'is required.';
  rsValidSupplierRequired = 'A valid Supplier Company Account'#13'is required.';
  rsValidBusinessDivisionRequired = 'A valid Business Division entry is required.';
  rsValidCurrencyRequired = 'A valid Currency entry is required.';
  rsSupplierInvalidForSite= 'This Company has not been configured as a Supplier'#13+
                            'for this site (%s).'#13#13+
                            'Please contact ''Accounts Payable'' for further information.';
  rsCustomerInvalidForSite= 'This Company has not been configured as a Customer'#13+
                            'for this site (%s).'#13#13+
                            'Please contact ''Accounts Receivable'' for further information.';


{ Column Names - Used by dbGrids as popup hints to aid recoqnition }
resourcestring
  rsDC_BOMIssueNo    = 'BOM Issue No.';
  rsDC_BOMIsObsolete = 'Obsolete BOM';
  rsDC_BOMHasOptions = 'Optioned BOM';

resourcestring
  rsDC_PartIsParam    = 'Parameterised Part';
  rsDC_PartVersion    = 'Part Version';
  rsDC_PartRevision   = 'Item Revision';
  rsDC_ItemHasDocs    = 'Contains links'#13'to Documents';
  rsDC_PartDrawing    = 'Drawing Size';
  rsDC_PartIssueNo    = 'Drawing Revision'#13'Number';

resourcestring
  rsDC_CopyrightHolder= 'Atlas Converting Equipment Limited';

resourcestring
  rsValidation_FromDateInvalid=
    'The ''From'' date is required, and is currently invalid';
  rsValidation_ToDateInvalid=
    'The ''To'' date is required, and is currently invalid';
  rsValidation_FromToDatesInvalid=
    'The ''To'' date must be the same as, or fall after the ''From'' date.';


implementation


end.
