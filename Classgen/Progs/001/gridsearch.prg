**************************************************
*-- Class:        gridsearch (f:\accwin\custclss\gridsearch.prg)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   09/05/01 01:16:06 PM
*-- Copyright (C) 2001, Vladimir Trukhin

* Attach the text constants file for needed language.
* Don't forget to specify the path to this file.
#include GS_ENU.H

DEFINE CLASS gridsearch AS form

	DECLARE Grids(1,2)
	DECLARE Columns(1,4)
	Top = 20
	Left = 29
	Height = 159
	Width = 436
	DoCreate = .T.
	BorderStyle = 2
	Caption = CPT_FORM
	HalfHeightCaption = .F.
	MaxButton = .F.
	MinButton = .F.
	Icon = "sign.ico"
	AlwaysOnTop = .T.
	BackColor = RGB(171,190,211)
	Name = "GridSearch"
	ShowTips = .F.
	parentform = NULL
	NumberOfGrids = 0
	numberofcolumns = 0

	ADD OBJECT label5 AS label WITH ;
		AutoSize = .F., ;
		FontSize = 8, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		Caption = CPT_LBL5, ;
		Height = 16, ;
		Left = 7, ;
		Top = 35, ;
		Width = 185, ;
		ForeColor = RGB(255,255,255), ;
		BackColor = RGB(0,0,160), ;
		Name = "Label5"

	ADD OBJECT label1 AS label WITH ;
		AutoSize = .F., ;
		FontSize = 8, ;
		BorderStyle = 1, ;
		Caption = CPT_LBL1, ;
		Height = 16, ;
		Left = 212, ;
		Top = 53, ;
		Width = 191, ;
		ForeColor = RGB(255,255,255), ;
		BackColor = RGB(0,0,160), ;
		Name = "Label1"

	ADD OBJECT line1 AS line WITH ;
		Height = 0, ;
		Left = 192, ;
		Top = 41, ;
		Width = 96, ;
		Name = "Line1"

	ADD OBJECT line2 AS line WITH ;
		Height = 12, ;
		Left = 288, ;
		Top = 41, ;
		Width = 0, ;
		Name = "Line2"

	ADD OBJECT label2 AS label WITH ;
		FontSize = 10, ;
		BackStyle = 0, ;
		Caption = ">>", ;
		Height = 17, ;
		Left = 198, ;
		Top = 33, ;
		Width = 40, ;
		Name = "Label2"

	ADD OBJECT txtfind AS textbox WITH ;
		Height = 23, ;
		Left = 84, ;
		Top = 8, ;
		Width = 148, ;
		BackColor = RGB(209,220,231), ;
		Name = "txtFind"

	ADD OBJECT label3 AS label WITH ;
		AutoSize = .T., ;
		FontSize = 8, ;
		BackStyle = 0, ;
		Caption = CPT_LBL3, ;
		Height = 16, ;
		Left = 7, ;
		Top = 11, ;
		Width = 76, ;
		Name = "Label3"

	ADD OBJECT label4 AS label WITH ;
		AutoSize = .T., ;
		FontSize = 8, ;
		BackStyle = 0, ;
		Caption = CPT_LBL4, ;
		Height = 16, ;
		Left = 235, ;
		Top = 11, ;
		Width = 46, ;
		Name = "Label4"

	ADD OBJECT cmbCondition AS combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = OPR_CONT+","+OPR_EQU, ;
		Height = 23, ;
		Left = 282, ;
		Style = 2, ;
		Top = 8, ;
		Width = 89, ;
		BackColor = RGB(209,220,231), ;
		ItemBackColor = RGB(209,220,231), ;
		Name = "cmbCondition"

	ADD OBJECT btnlocate AS commandbutton WITH ;
		Top = 136, ;
		Left = 7, ;
		Height = 19, ;
		Width = 138, ;
		FontSize = 8, ;
		Caption = CPT_LOCATE, ;
		Name = "btnLocate"

	ADD OBJECT btncontinue AS commandbutton WITH ;
		Top = 136, ;
		Left = 149, ;
		Height = 19, ;
		Width = 138, ;
		FontSize = 8, ;
		Caption = CPT_BTNCONT, ;
		Enabled = .F., ;
		Name = "btnContinue"

	ADD OBJECT opgoperation AS optiongroup WITH ;
		ButtonCount = 2, ;
		BackStyle = 1, ;
		Value = 1, ;
		Height = 50, ;
		Left = 373, ;
		SpecialEffect = 1, ;
		Top = 8, ;
		Width = 57, ;
		BackColor = RGB(79,79,79), ;
		BorderColor = RGB(255,255,255), ;
		Name = "opgOperation", ;
		Option1.FontSize = 8, ;
		Option1.BackStyle = 0, ;
		Option1.Caption = CPT_FORM, ;
		Option1.Value = 1, ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 61, ;
		Option1.ForeColor = RGB(255,255,255), ;
		Option1.Name = "Find", ;
		Option2.FontSize = 8, ;
		Option2.BackStyle = 0, ;
		Option2.Caption = CPT_OPTSEL, ;
		Option2.Height = 17, ;
		Option2.Left = 5, ;
		Option2.Top = 24, ;
		Option2.Width = 61, ;
		Option2.ForeColor = RGB(255,255,255), ;
		Option2.Name = "Select"

	ADD OBJECT btnclearfilter AS commandbutton WITH ;
		Top = 136, ;
		Left = 291, ;
		Height = 19, ;
		Width = 138, ;
		FontSize = 8, ;
		Caption = CPT_BTNALL, ;
		Name = "btnClearFilter"

	PROCEDURE getcolumns
		lparameters loGrid
		LOCAL lnItems, loColRef, loControl
		this.NumberOfColumns=0
		DIMENSION THIS.Columns(1,4)
		FOR EACH loColRef in loGrid.Columns
			if ALLT(UPPER(loColRef.Tag))=='FIND'
				if this.NumberOfColumns!=0
					DIMENSION THIS.Columns(this.NumberOfColumns+1,4)
				endif
				this.NumberOfColumns=this.NumberOfColumns+1
				FOR EACH loControl IN loColRef.Controls
					IF ALLTRIM(UPPER(loControl.BaseClass))='HEADER'
						THIS.Columns(this.NumberOfColumns,1)=loControl.Caption
					ENDIF
				ENDFOR 
				THIS.Columns(this.NumberOfColumns,2)=ALLT(SUBSTR(loColRef.ControlSource,1,AT('.',loColRef.ControlSource, 1)-1))
				THIS.Columns(this.NumberOfColumns,3)=ALLT(SUBSTR(loColRef.ControlSource,AT('.',loColRef.ControlSource, 1)+1))
				THIS.Columns(this.NumberOfColumns,4)=loColRef
			endif
		ENDFOR
		IF this.NumberOfColumns=0
			THIS.Columns(1,1)=MSG_NOCOLUMN1
		ENDIF
		return
	ENDPROC

	PROCEDURE selectedgridref
		return THIS.Grids(this.lstGrids.ListIndex,2)
	ENDPROC

	PROCEDURE selectedcolumnref
		return THIS.Columns(this.lstColumns.ListIndex,4)
	ENDPROC

	PROCEDURE selectedalias
		return THIS.Columns(this.lstColumns.ListIndex,2)
	ENDPROC

	PROCEDURE selectedfield
		return THIS.Columns(this.lstColumns.ListIndex,3)
	ENDPROC

	PROCEDURE checkselection
		local llResult
		llResult=.T.
		do case
			case this.NumberOfGrids=0
				messagebox(MSG_NOTABLE+chr(13)+;
				           MSG_CANCEL,;
				           48,;
				           this.Caption,;
				           MSG_TIMEOUT;
				          )
				llResult=.F.
			case thisform.lstGrids.ListIndex=0
				messagebox(MSG_NOTABLE1+chr(13)+;
				           MSG_CANCEL,;
				           48,;
				           this.Caption,;
				           MSG_TIMEOUT;
				          )
				llResult=.F.
			case this.NumberOfColumns=0
				messagebox(MSG_NOCOLUMN+chr(13)+;
				           MSG_CANCEL,;
				           48,;
				           this.Caption,;
				           MSG_TIMEOUT;
				          )
				llResult=.F.
			case thisform.lstGrids.ListIndex!=0 and thisform.lstColumns.ListIndex=0
				messagebox(MSG_NOCOLUMN+chr(13)+;
				           MSG_CANCEL,;
				           48,;
				           this.Caption,;
				           MSG_TIMEOUT;
				          )
				llResult=.F.
		endcase
		return llResult
	ENDPROC

	PROCEDURE selectedfiltervariable
		LOCAL loGridRef
		loGridRef=thisform.SelectedGridRef()
		return allt(loGridRef.Tag)
	ENDPROC

	PROCEDURE clearfilter
		IF !THIS.CheckSelection()
			RETURN
		ENDIF
		LOCAL lnArea, lcAlias, loCurrGrid, loCurrColumn
		lnArea=select(0)
		lcAlias=thisform.SelectedAlias()
		SELECT (lcAlias)
		SET FILTER TO 
		GO TOP
		SELECT (ALIAS(lnArea))
		THISFORM.RefreshParent()
	ENDPROC

	PROCEDURE Destroy
	ENDPROC

	PROCEDURE Init
		LPARAMETERS loParentForm
		LOCAL lnElement, loObjRef, lcObjRef
		THIS.ParentForm=loParentForm
		THIS.Caption=allt(CPT_FORM1+loParentForm.Caption)
		this.addobject('lstgrids','GridList')
		WITH this.lstgrids
			.ColumnCount = 1
			.RowSourceType = 5
			.RowSource = "THIS.PARENT.Grids"
			.FirstElement = 1
			.Height = 79
			.Left = 7
			.NumberOfElements = (ALEN(THIS.Grids,1))
			.Top = 53
			.Width = 204
			.ItemBackColor = RGB(209,220,231)
			.Visible=.T.
			.Enabled=.T.
		ENDWITH
		this.addobject('lstcolumns','listbox')
		WITH this.lstcolumns
			.ColumnCount = 1
			.RowSourceType = 5
			.RowSource = "THIS.PARENT.Columns"
			.FirstElement = 1
			.Height = 61
			.Left = 212
			.NumberOfElements = (ALEN(THIS.Columns,1))
			.Top = 71
			.Width = 218
			.ItemBackColor = RGB(209,220,231)
			.Name='lstcolumns'
			.Visible=.T.
			.Enabled=.T.
		ENDWITH
		
		THIS.DetectGrids(loParentForm)
		
		this.lstGrids.NumberOfElements=this.NumberOfGrids
		if this.NumberOfGrids>0
			this.GetColumns(THIS.Grids(1,2))
			this.lstColumns.NumberOfElements=this.NumberOfColumns
		else
			this.lstGrids.NumberOfElements=0
			THIS.Grids(1,1)=MSG_NOTABLE
			this.lstColumns.NumberOfElements=0
			THIS.Columns(1,1)=MSG_NOCOLUMN
		endif
	ENDPROC

	PROCEDURE cmbCondition.Init
		this.Value=OPR_CONT
	ENDPROC

	PROCEDURE btnlocate.Click
		WITH THISFORM
			if !.CheckSelection()
				return
			endif
			local lnRec, lcAlias, lcField
			lcAlias=.SelectedAlias()
			lcField=.SelectedField()
			if bof(lcAlias) or eof(lcAlias)
				return
			endif
			local lnArea
			lnArea=select(0)
			SELECT (lcAlias)
			lnRec=recno()
			LOCAL lcFilterVariableName, lcFindString
			lcFindString=UPPER(allt(.txtFind.Value))
			lcFilterVariableName=.SelectedFilterVariable()
			PUBLIC &lcFilterVariableName
			&lcFilterVariableName = lcFindString
			if .opgOperation.Find.Value=1
				go top
				do case
					case .cmbCondition.Value=OPR_CONT
						locate for &lcFilterVariableName $ upper(&lcField)
					case .cmbCondition.Value=OPR_EQU
						locate for &lcFilterVariableName == allt(upper(&lcField))
				endcase
				if !found()
					messagebox(MSG_NOTFOUND,48,.Caption)
					goto lnRec
				endif
				.btnContinue.Enabled=.T.
			else
				if !empty(lcFindString)
					do case
						case .cmbCondition.Value=OPR_CONT
							set filter to &lcFilterVariableName $ upper(&lcField)
						case .cmbCondition.Value=OPR_EQU
							set filter to &lcFilterVariableName == allt(upper(&lcField))
					endcase
					go top
				else
					set filter to
					goto lnRec
				endif
			endif
			.RefreshParent()
		ENDWITH
		select (alias(lnArea))
	ENDPROC

	PROCEDURE btncontinue.Click
		WITH THISFORM
			if !.CheckSelection()
				return
			endif
			local lnRec, lnArea, lcAlias
			lnArea=select(0)
			lcAlias=.SelectedAlias()
			if bof(lcAlias) or eof(lcAlias)
				return
			endif
			lnRec=recno()
			CONTINUE
			if !found()
				messagebox(MSG_NOTFOUND,48,.Caption)
				goto lnRec
			endif
			.RefreshParent()
		ENDWITH
		select (alias(lnArea))
	ENDPROC

	PROCEDURE opgoperation.Find.Click
		thisform.btnLocate.Caption=CPT_LOCATE
		thisform.ClearFilter()
		thisform.btnContinue.Enabled=.F.
	ENDPROC

	PROCEDURE opgoperation.Find.Init
		THIS.Value=1
	ENDPROC

	PROCEDURE opgoperation.Select.Init
		THIS.Value=0
	ENDPROC

	PROCEDURE opgoperation.Select.Click
		thisform.btnContinue.Enabled=.F.
		thisform.btnLocate.Caption=CPT_SELECT
	ENDPROC
	
	PROCEDURE btnclearfilter.Click
		WITH THISFORM
			if !.CheckSelection()
				return
			endif
			local lnRec, lcAlias, lcField
			lcAlias=.SelectedAlias()
			lcField=.SelectedField()
			if bof(lcAlias) or eof(lcAlias)
				return
			endif
			local lnArea
			lnArea=select(0)
			SELECT (lcAlias)
			lnRec=recno()
			set filter to
			goto lnRec
			.RefreshParent()
		ENDWITH
		select (alias(lnArea))
	ENDPROC
	
	PROCEDURE Release
		RELEASE this
	ENDPROC 
	
	PROCEDURE DetectGrids(loCurObject)
		LOCAL ARRAY laGrids(1)
		LOCAL lnElement, lcObjRef, loObjRef
		IF amembers(laGrids,loCurObject,2)>0
			for lnElement=1 to alen(laGrids,1)
				lcObjRef='loCurObject.'+laGrids(lnElement)
				loObjRef=&lcObjRef
				if upper(allt(loObjRef.BaseClass))=='GRID' and !empty(loObjRef.Comment)
					if this.NumberOfGrids=0
						this.NumberOfGrids=1
					else
						this.NumberOfGrids=this.NumberOfGrids+1
						DIMENSION THIS.Grids(this.NumberOfGrids,2)
					endif
					THIS.Grids(this.NumberOfGrids,1)=loObjRef.Comment
					THIS.Grids(this.NumberOfGrids,2)=loObjRef
					if empty(loObjRef.Tag)
						loObjRef.Tag='gc'+allt(str(int(rand(seconds())*1000000)))+allt(str(this.NumberOfGrids))
					endif
				else
					THIS.DetectGrids(loObjRef)
				endif
			ENDFOR
		ENDIF 
	ENDPROC 
	
	PROCEDURE RefreshParent()
		LOCAL loCurrentGrid, loCurrentColumn, loParent
		*loCurrentGrid=.SelectedGridRef()
		loParent=THIS.ParentForm
		loParent.Refresh()
		loCurrentColumn=this.SelectedColumnRef()
		loCurrentColumn.SetFocus()
	ENDPROC 

ENDDEFINE
*
*-- EndDefine: gridsearch
**************************************************

DEFINE CLASS GridList AS listbox

	PROCEDURE InteractiveChange
		WITH THISFORM
			if .NumberOfGrids>0
				.GetColumns(THIS.PARENT.Grids(this.ListIndex,2))
				.lstColumns.NumberOfElements=.NumberOfColumns
				.lstColumns.Refresh()
			endif
		ENDWITH
	ENDPROC
ENDDEFINE

DEFINE CLASS GridSearchTLF AS GridSearch
	ShowWindow=1
	DeskTop=.T.
ENDDEFINE

DEFINE CLASS GridSearchTLF_MOD AS GridSearch
	ShowWindow=1
	DeskTop=.T.
	WindowType=1
ENDDEFINE