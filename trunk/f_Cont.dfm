�
 TFRMFNDCONTRACT 0  TPF0TFrmFndContractFrmFndContractLeft
Top�BorderStylebsDialogCaptionFind ContractClientHeightDClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterOnCreatecrDlgFormCreatePixelsPerInch`
TextHeight TcrTitleTitLeft Top Width�Height
StartColorclOliveStyletiTitleBordertiNoneCaption%sOptionstiAllowPrintForm   TcrBtnPanelBtnsLeft Top!Width�AlignalBottomStylecrpsCancelSelectOnButtonClickBtnsButtonClick  	TGroupBox	GrpSearchLeft TopWidth�Height<AlignalTopCaption Search Criteria TabOrder  TLabelLblSrchPartNoLeftTopWidth5HeightCaptionContract #:  TcrLabelLblSrchDescLeftaTopWidth8HeightCaptionDescription:AlignToEdtSrchDescPosition	lpTopLeftShadow.ColorclBtnShadow  TButtonBtnSrchLeft�TopWidthKHeightCaptionS&earchDefault	TabOrderOnClickBtnSrchClickOnEnterEdtSrchEnterOnExitEdtSrchExit  TDBEdit	EdtSrchNoLeftTop#WidthNHeightCharCaseecUpperCaseCtl3D	DataFieldContNo
DataSourceSrcSrchParentCtl3DTabOrder OnEnterEdtSrchEnterOnExitEdtSrchExit  TDBEditEdtSrchDescLeft_Top#Width� HeightCtl3D	DataFieldContDesc
DataSourceSrcSrchParentCtl3DTabOrderOnEnterEdtSrchEnterOnExitEdtSrchExit   	TcrdbGridgrdContLeft TopYWidth�Height� AlignalClientCtl3D
DataSourceSrcContOptionsdgTitles
dgColLines
dgRowLinesdgTabsdgRowSelectdgAlwaysShowSelectiondgConfirmDelete ParentCtl3DParentShowHintShowHint	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style OnDrawColumnCellgrdContDrawColumnCellDefaultRowHeightOnActiongrdContAction  
TcrIBQueryQryContSQL.StringsSELECT1  ContNo, ContDesc, CompNo, Key_Status, DteIssuedFROM
  ContractORDER BY  ContNo 	OptionsEx LeftTop
 TIBStringFieldQryContCONTNODisplayLabelCont #DisplayWidth	FieldNameCONTNOSize
  TIBStringFieldQryContCONTDESCDisplayLabelContract DescriptionDisplayWidth#	FieldNameCONTDESCSize2  TIBStringFieldQryContCOMPNODisplayLabelComp #	FieldNameCOMPNOSize
  TIBStringFieldQryContKEY_STATUSDisplayLabelStatusDisplayWidth
	FieldName
KEY_STATUS	OnGetTextQryContKEY_STATUSGetTextSize  TDateTimeFieldQryContDTEISSUEDDisplayLabelIssued DisplayWidth	FieldName	DTEISSUEDDisplayFormat	ddddd ddd   TDataSourceSrcContDataSetQryContOnStateChangeSrcContStateChangeLeft1Top  TkbmMemTableMemSrchDesignActivation	AttachedAutoRefresh	AttachMaxCountAutoIncMinValue�	FieldDefsNamePartNoDataTypeftStringSize
 NameSpareDataTypeftStringSize NamePartDescDataTypeftStringSize2  	IndexDefs SortOptions PersistentBackupProgressFlagsmtpcLoadmtpcSavemtpcCopy LoadedCompletelySavedCompletelyFilterOptions Version5.50
LanguageID SortID SubLanguageIDLocaleID Left� Top
 TStringFieldMemSrchContNo	FieldNameContNoSize
  TStringFieldMemSrchContDescDisplayWidth	FieldNameContDescSize2   TDataSourceSrcSrchDataSetMemSrchLeft� Top  TTimerTmrEnabledIntervaldOnTimerTmrTimerLefthTop
   