�
 TFRMSELLOOKUPNOTE 0?	  TPF0TFrmSelLookupNoteFrmSelLookupNoteLeft~Top�BorderStylebsDialogCaptionSelect Insertion NoteClientHeightClientWidth� Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoMainFormCenterOnCreatecrDlgFormCreateOnShowcrDlgFormShowPixelsPerInch`
TextHeight TcrPageControlPgeLeft Top Width� Height
ActivePageTabBrwAlignalClientHotTrack	TabIndex TabOrder TabStop 	TTabSheetTabBrwCaptionbrw TcrBtnPanelBtnBrwLeft Top� Width� AlignalBottomStylecrpsCancelSelectOnButtonClickBtnBrwButtonClick TButtonBtnViewNoteLeftTopWidth:HeightCaptionViewTabOrderOnClickBtnViewNoteClick   	TcrdbGridGrdNoteLeft Top Width� Height� AlignalClientCtl3D
DataSourcesrcNoteOptionsdgTitles
dgColLines
dgRowLinesdgTabsdgRowSelectdgAlwaysShowSelectiondgConfirmDelete ParentCtl3DParentShowHintShowHint	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style "SelectColumnsDialogStrings.CaptionSelect columnsSelectColumnsDialogStrings.OK&OK-SelectColumnsDialogStrings.NoSelectionWarning$At least one column must be visible!EditControls 
RowsHeightTitleRowHeightDefaultRowHeightOnActionGrdNoteAction   	TTabSheetTabVwCaptionvw
ImageIndex TcrBtnPanelPnlBtnLeft Top� Width� AlignalBottomStyle	crpsCloseOnButtonClickPnlBtnButtonClick  TDBMemoMemLkpNoteMemoLeft Top Width� Height� TabStopAlignalClientCtl3D	DataFieldMEMO
DataSourcesrcNoteParentCtl3DReadOnly	TabOrder    TIBQueryqryNteTransactiontranSQL.StringsSELECT ln.Desc_Lk, ln.MemoFROM    LookupNotes ln!WHERE (ln.Group_Lk = :AsGroup_Lk)ORDER BY ln.Desc_Lk LeftsTop
	ParamDataDataType	ftUnknownName
AsGroup_Lk	ParamType	ptUnknown   TIBStringFieldqryNteDESC_LKDisplayLabelDescriptionDisplayWidth#	FieldNameDESC_LKOriginLOOKUPNOTES.DESC_LKSize  
TMemoField
qryNteMEMO	FieldNameMEMOOriginLOOKUPNOTES.MEMOVisibleBlobTypeftMemoSize   TDataSourcesrcNoteDataSetqryNteLeft� Top  
TcrDlgFindFndOnSearch	FndSearchLeftTop
  TIBTransactiontranParams.Stringsread_committedrec_versionnowait LeftATop
   