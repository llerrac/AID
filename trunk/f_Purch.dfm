�
 TFRMFNDPURCHASE 0*%  TPF0TFrmFndPurchaseFrmFndPurchaseLeftZTop� BorderStylebsDialogCaptionFind Purchase OrderClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterOnCreatecrDlgFormCreatePixelsPerInch`
TextHeight TcrTitleTitLeft Top Width�Height
StartColorclRedStyletiTitleBordertiNoneCaption%sOptionstiAllowPrintForm   TcrBtnPanelBtnsLeft TopeWidth�AlignalBottomStylecrpsCancelSelectOnButtonClickBtnsButtonClick  	TGroupBox	GrpSearchLeft TopWidth�Height\AlignalTopCaption Search Criteria TabOrder OnEnterGrpSearchEnterOnExitGrpSearchExit
DesignSize�\  TcrSeparatorSepSrchOrderedLeftTop#WidthjHeightCaptionOrdered between  TcrLabel	crLabel12Left� TopWidth3HeightCaptionSupplier #:Shadow.ColorclBtnShadow  	TcrdBInfoInfSrchSuppLeftTop
Width
HeightAutoSize	DataFieldSuppName
DataSourceSrcSrchIndentFont.CharsetDEFAULT_CHARSET
Font.Color
clInfoTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontStyleisSingleResult  TcrLabelLblSrchPartNoLeft� TopWidth.HeightCaption	Order No:AlignTo	EdtSrchNoShadow.ColorclBtnShadow  TcrLabelLabel1Left~Top3Width>HeightCaptionContract/CC:AlignTo
EdtTranRefShadow.ColorclBtnShadow  TcrLabelLabel2Left|TopGWidth@HeightCaptionSupplier Ref.:AlignTo
EdtSuppRefShadow.ColorclBtnShadow  TcrLabel	crLabel10LeftITopWidth1HeightCaption
Issued By:FocusControlLkpSrchIssuedByShadow.ColorclBtnShadow  TcrLabel	crLabel13LeftYTop3Width!HeightCaptionStatus:FocusControlLkpSrchStatusShadow.ColorclBtnShadow  TSpeedButtonSpdLeft�Top	WidthHeightCaption?Flat	Font.CharsetANSI_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSmall Fonts
Font.StylefsBold LayoutblGlyphBottom
ParentFontOnClickSpdClick  TcrSeparator
SepOrderByLeftlTop7Width~HeightCaptionOrder By  TcrInfoInfLkpSuppNoLeft� Top
WidthXHeight	AlignmenttaCenterAutoSizeFont.CharsetDEFAULT_CHARSET
Font.Color
clInfoTextFont.Height�	Font.NameMS Sans Serif
Font.Style Indent
ParentFontWordWrapText<LkpSuppNo>StyleisSingleResult  TcrdbDateEditDteSrchFromLeftTop2HeightHint*This will only allow a six month window...
AutoSelectCtl3D	DataFieldFrom
DataSourceSrcSrchParentCtl3DParentShowHintShowHint	TabOrder   TcrdbDateEditDteSrchUntilLeftTopFHeightHint*This will only allow a six month window...
AutoSelectCtl3D	DataFieldUntil
DataSourceSrcSrchParentCtl3DParentShowHintShowHint	TabOrder  TDBEdit	EdtSrchNoLeft� TopWidthXHeightCharCaseecUpperCaseCtl3D	DataFieldTranNo
DataSourceSrcSrchParentCtl3DTabOrder  TDBEdit
EdtTranRefLeft� Top2WidthXHeightCharCaseecUpperCaseCtl3D	DataFieldTranRef
DataSourceSrcSrchParentCtl3DTabOrder  TDBEdit
EdtSuppRefLeft� TopFWidthXHeightCharCaseecUpperCaseCtl3D	DataFieldSuppRef
DataSourceSrcSrchParentCtl3DTabOrder  TcrdbLookupComboBoxLkpSrchIssuedByLeft|TopWidth� HeightCtl3D	DataFieldTranUser
DataSourceSrcSrchKeyFieldUserName	ListFieldUserLong
ListSource
SrcLkpUserParentCtl3DTabOrder  TcrdbLookupComboBoxLkpSrchStatusLeft|Top2Width� HeightCtl3D	DataField
TranStatus
DataSourceSrcSrchKeyFieldKey_Lk	ListFieldDesc_Lk
ListSourceSrcLkpPurchStatusParentCtl3DTabOrder  TButtonBtnSrchLeft�Top	WidthKHeightAnchorsakTopakRight CaptionS&earchDefault	TabOrderOnClickBtnSrchClick  TButtonBtnClearLeft�Top"WidthKHeightAnchorsakTopakRight CaptionClearTabOrder
  TcrdbLookupComboBoxLkpSrchOrderByLeftmTopFWidth~HeightCtl3D	DataFieldOrderBy
DataSourceSrcSrchKeyField
OrderIndex	ListField	OrderDesc
ListSourceSrcSrchOrderParentCtl3DTabOrder	  TcrdbCheckBoxChkIncludeCompletedLeftTopFWidthqHeight	AlignmenttaLeftJustifyCaptionInclude Completed	DataFieldIncludeCompleted
DataSourceSrcSrchTabOrderValueCheckedTrueValueUncheckedFalse   	TcrdbGridGrdBrwLeft TopyWidth�Height� AlignalClientCtl3D
DataSourceSrcTrOptionsdgTitles
dgColLines
dgRowLinesdgTabsdgRowSelectdgAlwaysShowSelectiondgConfirmDelete ParentCtl3DParentShowHintShowHint	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style DefaultRowHeightOnActionGrdBrwAction  
TcrIBQueryQryTrSQL.StringsSELECT %  pm.SuppNo, su.CompName as SuppName,  pm.TranSite, $  pm.TranNo, pm.TranRef, pm.SuppRef,  pm.TranDte, +  pm.TranUser, um.UserLong as TranUserDesc,  pm.TranStatus, 7  L1.Desc_Lk as TranStatusDesc, L1.Log2 as IsCompleted,  pm.DeliverySite,   pm.DeliveryWare,  pm.ExpectedFROM   PurchMast pm/LEFT JOIN Company su ON (pm.SuppNo = su.CompNo)1LEFT JOIN Users um ON (pm.TranUser = um.UserName)NLEFT JOIN Lookups l1 ON (pm.TranStatus = L1.Key_Lk) and (l1.Group_Lk='POSTAT') 	OptionsEx Left� Top@ TIBStringFieldQryTrTRANNODisplayLabelOrder #DisplayWidth	FieldNameTRANNOSize
  TIBStringFieldQryTrSUPPNODisplayLabel
Supplier #DisplayWidth	FieldNameSUPPNOVisibleSize
  TIBStringFieldQryTrSUPPNAMEDisplayLabelSupplierDisplayWidth	FieldNameSUPPNAMESize2  TIBStringFieldQryTrTRANSITE	AlignmenttaCenterDisplayLabelSteDisplayWidth	FieldNameTRANSITESize  TIBStringFieldQryTrTRANREFDisplayLabelContract/CCDisplayWidth
	FieldNameTRANREF  TIBStringFieldQryTrSUPPREFDisplayLabelSupplier Ref.:DisplayWidth
	FieldNameSUPPREF  TDateTimeFieldQryTrTRANDTEDisplayLabelOrderedDisplayWidth
	FieldNameTRANDTE  TIBStringFieldQryTrTRANUSER	FieldNameTRANUSERVisibleSize  TIBStringFieldQryTrTRANUSERDESCDisplayLabel
Ordered ByDisplayWidth	FieldNameTRANUSERDESCSize2  TIBStringFieldQryTrTRANSTATUS	FieldName
TRANSTATUSVisibleSize
  TIBStringFieldQryTrTRANSTATUSDESCDisplayLabelStatusDisplayWidth	FieldNameTRANSTATUSDESCSize  TIBStringFieldQryTrDELIVERYSITEDisplayLabelSite	FieldNameDELIVERYSITEVisibleSize  TIBStringFieldQryTrDELIVERYWAREDisplayLabelWare	FieldNameDELIVERYWAREVisibleSize  TDateTimeFieldQryTrEXPECTEDDisplayLabelExpectedDisplayWidth
	FieldNameEXPECTED  TIBStringFieldQryTrISCOMPLETED	FieldNameISCOMPLETEDVisibleSize   TDataSourceSrcTrDataSetQryTrOnStateChangeSrcTrStateChangeLeft� TopT  TDataSourceSrcSrchDataSetMemSrchLeft�Top  TTimerTmrEnabledIntervaldOnTimerTmrTimerLeft�Top;  TkbmMemTableMemSrchDesignActivation	AttachedAutoRefresh	AttachMaxCountAutoIncMinValue�	FieldDefsNameFromDataTypeftDate NameUntilDataTypeftDate Name
ExpectFromDataType
ftDateTime NameExpectUntilDataType
ftDateTime NameTranSiteDataTypeftStringSize NameDeliverySiteDataTypeftStringSize NameTranUserDataTypeftStringSize Name
TranStatusDataTypeftStringSize
 NameSuppNoDataTypeftStringSize
 NameSuppDescDataTypeftStringSize2 NameTranNoDataTypeftStringSize
 NameSuppRefDataTypeftStringSize NameTranRefDataTypeftStringSize NameOrderByDataType	ftInteger  	IndexDefs SortOptions PersistentBackupProgressFlagsmtpcLoadmtpcSavemtpcCopy LoadedCompletelySavedCompletelyFilterOptions Version5.50
LanguageID SortID SubLanguageIDLocaleID OnNewRecordMemSrchNewRecordLeft�Top 
TDateFieldMemSrchFrom	FieldNameFromOnChangeMemSrchFromChange  
TDateFieldMemSrchUntil	FieldNameUntilOnChangeMemSrchUntilChange  TDateTimeFieldMemSrchExpectFromDisplayWidth	FieldName
ExpectFromDisplayFormat	ddddd ddd  TDateTimeFieldMemSrchExpectUntilDisplayWidth	FieldNameExpectUntilDisplayFormat	ddddd ddd  TStringFieldMemSrchTranSite	FieldNameTranSiteSize  TIBStringFieldMemSrchDeliverySite	FieldNameDeliverySiteVisibleSize  TStringFieldMemSrchTranUser	FieldNameTranUserSize  TStringFieldMemSrchTranStatus	FieldName
TranStatusSize
  TStringFieldMemSrchSuppNo	FieldNameSuppNoOnChangeMemSrchSuppNoChangeSize
  TStringFieldMemSrchSuppName	FieldNameSuppNameSize2  TStringFieldMemSrchTranNo	FieldNameTranNoSize
  TStringFieldMemSrchSuppRef	FieldNameSuppRef  TIBStringFieldMemSrchTranRefDisplayLabelOur Ref.DisplayWidth	FieldNameTranRef  TIntegerFieldMemSrchOrderBy	FieldNameOrderBy  TBooleanFieldMemSrchIncludeCompleted	FieldNameIncludeCompleted   TDataSource
SrcLkpUserLeft� TopT  TDataSourceSrcLkpPurchStatusLeft,TopT  
TcrDlgListDlgCaption	SQL QueryLeft�Top;  TkbmMemTableMemSrchOrderDesignActivation	AttachedAutoRefresh	AttachMaxCountAutoIncMinValue�	FieldDefs 	IndexDefs SortOptions PersistentBackupProgressFlagsmtpcLoadmtpcSavemtpcCopy LoadedCompletelySavedCompletelyFilterOptions Version5.50
LanguageID SortID SubLanguageIDLocaleID Left�Top TIntegerFieldMemSrchOrderOrderIndex	FieldName
OrderIndex  TStringFieldMemSrchOrderOrderDesc	FieldName	OrderDescSize  TStringFieldMemSrchOrderOrderClause	FieldNameOrderClauseSize�    TDataSourceSrcSrchOrderDataSetMemSrchOrderLeftTop   