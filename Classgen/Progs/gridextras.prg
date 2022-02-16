**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\gridextras.vcx
**************************************************


**************************************************
*-- Class:        checkform (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  timer
*-- BaseClass:    timer
*-- Time Stamp:   12/10/08 03:22:07 AM
*
DEFINE CLASS checkform AS timer


	Height = 23
	Width = 23
	Name = "checkform"


	PROCEDURE Timer
		LOCAL lnDifference, lnIntervalWas
		m.lnIntervalWas = This.Interval
		this.Interval = 0
		TRY && Ignor errors for this feature (though there shouldn't be any errors thrown)
			m.lnDifference = SECONDS() - Thisform.LastUserAction
			IF MROW(ThisForm.Name,3) = -1 OR MCOL(ThisForm.Name,3) = -1
				IF m.lnDifference >= Thisform.GridExtraObject.FadeWait
					IF This.Parent._InForm
						This.Parent._InForm = .F.
						This.Parent.tmrFadeForm.Interval = 50
						This.Parent._Fade = 255
					ENDIF
				ELSE
					IF !This.Parent._InForm
						This.Parent._InForm = .T.
						This.Parent.tmrFadeForm.Interval = 50
					ENDIF
				ENDIF
			ELSE
				IF !This.Parent._InForm
					This.Parent._InForm = .T.
					This.Parent.tmrFadeForm.Interval = 50
				ENDIF
			ENDIF
		CATCH
		ENDTRY
		this.Interval = m.lnIntervalWas
	ENDPROC


ENDDEFINE
*
*-- EndDefine: checkform
**************************************************


**************************************************
*-- Class:        fadeform (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  timer
*-- BaseClass:    timer
*-- Time Stamp:   12/10/08 03:10:13 AM
*
DEFINE CLASS fadeform AS timer


	Height = 23
	Width = 23
	Name = "fadeform"


	PROCEDURE Timer
		LOCAL lnFadeLevel, lnIntervalWas
		m.lnIntervalWas = This.Interval
		this.Interval = 0
		m.lnFadeLevel = MAX(MIN(This.Parent.GridExtraObject.FadeLevel, 255), 0)
		IF This.Parent._InForm
			This.Parent._Fade = MIN(This.Parent._Fade + 60, 255)
		ELSE
			This.Parent._Fade = MAX(This.Parent._Fade - 20, m.lnFadeLevel)
		ENDIF

		_Sol_SetLayeredWindowAttributes(thisform.hwnd, 0, This.Parent._Fade, 2)

		IF m.lnFadeLevel > 254 OR !BETWEEN(This.Parent._Fade,m.lnFadeLevel + 1, 254)
			This.Interval = 0
		ENDIF
		this.Interval = m.lnIntervalWas
	ENDPROC


ENDDEFINE
*
*-- EndDefine: fadeform
**************************************************


**************************************************
*-- Class:        gridcolumns (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   05/01/14 03:59:13 PM
*
DEFINE CLASS gridcolumns AS form


	DataSession = 2
	Height = 417
	Width = 360
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Escoger Columnas"
	AlwaysOnTop = .T.
	*-- INTERNAL USE: Used by the columns form to hold a reference to the target grid that was sent in when the columns form object was created.
	gridobject = .NULL.
	*-- INTERNAL USE: Used by the columns form to specify a unique cursor name for displaying in the grid.
	columncursorname = ""
	Name = "gridcolumns"


	ADD OBJECT grdcolumns AS grid WITH ;
		ColumnCount = 2, ;
		Anchor = 15, ;
		AllowHeaderSizing = .F., ;
		AllowRowSizing = .F., ;
		DeleteMark = .F., ;
		GridLines = 0, ;
		HeaderHeight = 0, ;
		Height = 273, ;
		HighlightRowLineWidth = 0, ;
		Left = 13, ;
		Panel = 1, ;
		RecordMark = .F., ;
		ScrollBars = 2, ;
		SplitBar = .F., ;
		TabIndex = 2, ;
		Top = 44, ;
		Width = 240, ;
		HighlightBackColor = RGB(255,255,128), ;
		HighlightForeColor = RGB(0,0,0), ;
		HighlightStyle = 2, ;
		Name = "grdColumns", ;
		Column1.Alignment = 2, ;
		Column1.Width = 23, ;
		Column1.Sparse = .F., ;
		Column1.Name = "Column1", ;
		Column2.Width = 195, ;
		Column2.ReadOnly = .T., ;
		Column2.Name = "Column2"


	ADD OBJECT gridcolumns.grdcolumns.column1.header1 AS header WITH ;
		Caption = "", ;
		Name = "Header1"


	ADD OBJECT gridcolumns.grdcolumns.column1.check1 AS checkbox WITH ;
		Top = 54, ;
		Left = 10, ;
		Height = 17, ;
		Width = 60, ;
		Alignment = 0, ;
		Centered = .T., ;
		Caption = "", ;
		Name = "Check1"


	ADD OBJECT gridcolumns.grdcolumns.column2.header1 AS header WITH ;
		Caption = "Columns", ;
		Name = "Header1"


	ADD OBJECT gridcolumns.grdcolumns.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT label1 AS label WITH ;
		AutoSize = .T., ;
		Anchor = 3, ;
		BackStyle = 0, ;
		Caption = "Seleccionar las columnas a mostrar", ;
		Height = 17, ;
		Left = 13, ;
		Top = 8, ;
		Width = 201, ;
		TabIndex = 1, ;
		Name = "Label1"


	ADD OBJECT cmdexit AS commandbutton WITH ;
		Top = 376, ;
		Left = 264, ;
		Height = 32, ;
		Width = 84, ;
		Anchor = 12, ;
		Picture = "..\..\grafgen\iconos\exit.png", ;
		Caption = "\<Cerrar", ;
		TabIndex = 9, ;
		PicturePosition = 4, ;
		PictureMargin = 2, ;
		Name = "cmdExit"


	ADD OBJECT cmdup AS commandbutton WITH ;
		Top = 43, ;
		Left = 264, ;
		Height = 32, ;
		Width = 84, ;
		Anchor = 9, ;
		Picture = "..\..\grafgen\iconos\arrow_up_blue.png", ;
		Caption = "\<Subir", ;
		TabIndex = 3, ;
		PicturePosition = 4, ;
		PictureMargin = 2, ;
		Name = "cmdUp"


	ADD OBJECT cmddown AS commandbutton WITH ;
		Top = 78, ;
		Left = 264, ;
		Height = 32, ;
		Width = 84, ;
		Anchor = 9, ;
		Picture = "..\..\grafgen\iconos\arrow_down_blue.png", ;
		Caption = "\<Bajar", ;
		TabIndex = 4, ;
		PicturePosition = 4, ;
		PictureMargin = 2, ;
		Name = "cmdDown"


	ADD OBJECT label2 AS label WITH ;
		AutoSize = .F., ;
		Anchor = 6, ;
		WordWrap = .T., ;
		BackStyle = 0, ;
		Caption = "Ancho de las columnas seleccionadas (en pixeles):", ;
		Height = 28, ;
		Left = 13, ;
		Top = 328, ;
		Width = 215, ;
		TabIndex = 6, ;
		Name = "Label2"


	ADD OBJECT txtcolumnwidth AS textbox WITH ;
		Anchor = 6, ;
		Height = 23, ;
		InputMask = "999", ;
		Left = 232, ;
		TabIndex = 7, ;
		Top = 329, ;
		Width = 40, ;
		DisabledBackColor = RGB(255,255,255), ;
		DisabledForeColor = RGB(128,128,128), ;
		Name = "txtColumnWidth"


	ADD OBJECT shape6 AS shape WITH ;
		Top = 364, ;
		Left = -75, ;
		Height = 56, ;
		Width = 441, ;
		Anchor = 14, ;
		BackStyle = 0, ;
		SpecialEffect = 0, ;
		ZOrderSet = 8, ;
		Name = "Shape6"


	ADD OBJECT label3 AS label WITH ;
		AutoSize = .T., ;
		Anchor = 9, ;
		WordWrap = .T., ;
		Alignment = 2, ;
		BackStyle = 0, ;
		Caption = "Posición de las columnas", ;
		Height = 47, ;
		Left = 283, ;
		Top = 115, ;
		Width = 57, ;
		TabIndex = 5, ;
		Name = "Label3"


	ADD OBJECT chkselectall AS checkbox WITH ;
		Top = 24, ;
		Left = 19, ;
		Height = 17, ;
		Width = 149, ;
		AutoSize = .F., ;
		Alignment = 0, ;
		BackStyle = 0, ;
		Caption = " Seleccionar todo", ;
		Value = .F., ;
		TabIndex = 8, ;
		Name = "chkSelectAll"


	*-- INTERNAL USE: Used by the columns form to fill the grid (columncursorname) with information regarding the columns in the target grid.
	PROCEDURE fillgrid
		LOCAL lnColumnCounter, loColumn, loHeader, llInvisibleFound
		WITH THIS
			.ColumnCursorName = SYS(2015)
			DO WHILE USED(.ColumnCursorName) && Ensure Uniqueness
				.ColumnCursorName = SYS(2015)
			ENDDO
			CREATE CURSOR (.ColumnCursorName) (isvisible L, columncaption C(150), columnname C(50), ColumnWidth I, ColumnOrd I, ColResize L, ColMove L)
			SELECT (.ColumnCursorName)
			INDEX ON ColumnOrd TAG ColumnOrd ASCENDING
			m.llInvisibleFound = .F.
			FOR m.lnColumnCounter = 1 TO .GridObject.COLUMNCOUNT
				m.loColumn = .GridObject.COLUMNS(m.lnColumnCounter)
				m.loHeader = m.loColumn.CONTROLS(1)
				INSERT INTO (.ColumnCursorName) VALUES (m.loColumn.VISIBLE, m.loHeader.CAPTION, m.loColumn.NAME, m.loColumn.WIDTH, m.loColumn.COLUMNORDER, m.loColumn.RESIZABLE, m.loColumn.MOVABLE)
				IF !m.llInvisibleFound AND !m.loColumn.VISIBLE
					m.llInvisibleFound = .T.
				ENDIF
			NEXT
			GO TOP IN (.ColumnCursorName)
			.grdColumns.RECORDSOURCE = .ColumnCursorName
			.grdColumns.Column1.CONTROLSOURCE = (.ColumnCursorName + ".IsVisible")
			.grdColumns.Column2.CONTROLSOURCE = (.ColumnCursorName + ".ColumnCaption")
			IF !EOF(.ColumnCursorName)
				.txtColumnWidth.CONTROLSOURCE = (.ColumnCursorName + ".ColumnWidth")
			ENDIF
			thisform.chkSelectAll.value = !m.llInvisibleFound
			thisform.chkSelectAll.Refresh()
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used by the columns form to move columns up and down based on their columnorder. Parameter that is sent determines direction of move like SKIP in a table (1 = Down, -1 = Up).
	PROCEDURE movecolumn
		LPARAMETERS tnColumnSkip
		LOCAL lnColumnOrderWas, lnColumnOrderIs
		IF !EOF(THISFORM.ColumnCursorName)
			m.lnColumnOrderWas = EVALUATE(THISFORM.ColumnCursorName + ".ColumnOrd")
			m.lnColumnOrderIs = m.lnColumnOrderWas + m.tnColumnSkip
			IF SEEK(m.lnColumnOrderIs, THISFORM.ColumnCursorName, "ColumnOrd")
				REPLACE ColumnOrd WITH -1 FOR ColumnOrd = m.lnColumnOrderIs IN (THISFORM.ColumnCursorName)
				REPLACE ColumnOrd WITH m.lnColumnOrderIs FOR ColumnOrd = m.lnColumnOrderWas IN (THISFORM.ColumnCursorName)
				REPLACE ColumnOrd WITH m.lnColumnOrderWas FOR ColumnOrd = -1 IN (THISFORM.ColumnCursorName)
				IF !SEEK(m.lnColumnOrderIs, THISFORM.ColumnCursorName, "ColumnOrd")
					GO TOP IN (THISFORM.ColumnCursorName)
				ENDIF
			ELSE
				IF !SEEK(m.lnColumnOrderWas, THISFORM.ColumnCursorName, "ColumnOrd")
					GO TOP IN (THISFORM.ColumnCursorName)
				ENDIF
			ENDIF
			THISFORM.grdColumns.REFRESH()
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used by the columns form to determine whether a column in the target grid is allowed to resize or move (column properties resizable and movable).
	PROCEDURE checkresizemove
		IF USED(THISFORM.grdColumns.RECORDSOURCE) AND !EOF(THISFORM.grdColumns.RECORDSOURCE)
			THISFORM.cmdUp.ENABLED = EVALUATE(ALLTRIM(THISFORM.grdColumns.RECORDSOURCE) + ".ColMove")
			THISFORM.cmdDown.ENABLED = EVALUATE(ALLTRIM(THISFORM.grdColumns.RECORDSOURCE) + ".ColMove")
			THISFORM.txtColumnWidth.ENABLED = EVALUATE(ALLTRIM(THISFORM.grdColumns.RECORDSOURCE) + ".ColResize")
			THISFORM.txtColumnWidth.REFRESH()
		ENDIF
	ENDPROC


	PROCEDURE Load
		Set Deleted On
		Set Console Off
		Set Talk Off
		Set Status Off
		Set Multilocks On
		Set Exclusive Off
		Set Seconds Off
		Set SQLBUFFERING On
		Set Safety Off
		Set Reprocess To 3
	ENDPROC


	PROCEDURE QueryUnload
		NODEFAULT
		THISFORM.cmdExit.CLICK()
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toGridObject
		THISFORM.ICON = _SCREEN.ICON
		THISFORM.GridObject = m.toGridObject
		THISFORM.FillGrid()
		THISFORM.CheckResizeMove()
		THISFORM.MINWIDTH = THISFORM.WIDTH
		THISFORM.MINHEIGHT = THISFORM.HEIGHT
	ENDPROC


	PROCEDURE grdcolumns.AfterRowColChange
		LPARAMETERS nColIndex
		IF DODEFAULT(m.nColIndex)
			THISFORM.CheckResizeMove()
		ENDIF
	ENDPROC


	PROCEDURE cmdexit.Click
		LOCAL loColumn, lnSelectWas

		m.lnSelectWas = SELECT(0)

		SELECT (THISFORM.ColumnCursorName)
		LOCATE FOR IsVisible
		IF !FOUND()
			*!* At least one column must still be visible
			*!* You could show the user a message here, but
			*!* as a default action let's just make the first column
			*!* visible.
			GO TOP IN (THISFORM.ColumnCursorName)
			replace isvisible WITH .T. IN (THISFORM.ColumnCursorName)
		ENDIF

		SCAN ALL
			m.loColumn = EVALUATE("Thisform.GridObject." + ALLTRIM(columnname))
			IF m.loColumn.VISIBLE != IsVisible
				m.loColumn.VISIBLE = IsVisible
			ENDIF
			IF m.loColumn.COLUMNORDER != ColumnOrd
				m.loColumn.COLUMNORDER = ColumnOrd
			ENDIF
			IF m.loColumn.WIDTH != ColumnWidth
				m.loColumn.WIDTH = ColumnWidth
			ENDIF
		ENDSCAN

		SELECT (m.lnSelectWas)
		THISFORM.RELEASE()
	ENDPROC


	PROCEDURE cmdup.Click
		THISFORM.MoveColumn(-1)
	ENDPROC


	PROCEDURE cmddown.Click
		THISFORM.MoveColumn(1)
	ENDPROC


	PROCEDURE shape6.Init
		THIS.ZORDER(1)
	ENDPROC


	PROCEDURE chkselectall.Valid
		LOCAL llValue
		m.llValue = this.Value
		replace ALL isvisible WITH m.llValue IN (Thisform.ColumnCursorName)
		GO TOP IN (Thisform.ColumnCursorName)
		Thisform.grdColumns.Refresh()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridcolumns
**************************************************


**************************************************
*-- Class:        gridcolumnstoplevel (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  gridcolumns (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/14/08 07:39:02 AM
*
DEFINE CLASS gridcolumnstoplevel AS gridcolumns


	ShowWindow = 2
	DoCreate = .T.
	Name = "gridcolumnstoplevel"
	grdColumns.Column1.Header1.Name = "Header1"
	grdColumns.Column1.Check1.Alignment = 0
	grdColumns.Column1.Check1.Name = "Check1"
	grdColumns.Column1.Name = "Column1"
	grdColumns.Column2.Header1.Name = "Header1"
	grdColumns.Column2.Text1.Name = "Text1"
	grdColumns.Column2.Name = "Column2"
	grdColumns.Name = "grdColumns"
	LABEL1.Name = "LABEL1"
	cmdExit.Name = "cmdExit"
	cmdUp.Name = "cmdUp"
	cmdDown.Name = "cmdDown"
	Label2.Name = "Label2"
	TXTCOLUMNWIDTH.Name = "TXTCOLUMNWIDTH"
	Label3.Name = "Label3"
	SHAPE6.Name = "SHAPE6"


ENDDEFINE
*
*-- EndDefine: gridcolumnstoplevel
**************************************************


**************************************************
*-- Class:        gridcustomfilter (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   05/01/14 04:10:13 PM
*
DEFINE CLASS gridcustomfilter AS container


	Width = 192
	Height = 76
	BackStyle = 0
	BorderWidth = 0
	*-- INTERNAL USE: Used to specify and hold the VFP type of the target column's controlsource.
	controlsourcetype = "C"
	*-- INTERNAL USE: Used to hold the unique cursor name that is used as the rowsource for Combo1.
	uniquecursorname = ""
	*-- INTERNAL USE: See FilterString_Access.
	filterstring = ""
	*-- INTERNAL USE: Used to hold the value of the target column's controlsource.
	columncontrolsource = ""
	*-- INTERNAL USE: Used to ensure that the Combo1 interactivechange event doesn't fire more than once when the user makes a selection.
	interactivechangecombofiring = .F.
	Name = "gridcustomfilter"


	ADD OBJECT combo1 AS combobox WITH ;
		RowSourceType = 1, ;
		Height = 24, ;
		Left = 1, ;
		Style = 2, ;
		Top = 1, ;
		Width = 190, ;
		Name = "Combo1"


	ADD OBJECT text1 AS textbox WITH ;
		Format = "K", ;
		Height = 23, ;
		Left = 1, ;
		SelectOnEntry = .T., ;
		Top = 27, ;
		Visible = .F., ;
		Width = 190, ;
		Name = "Text1"


	ADD OBJECT text2 AS textbox WITH ;
		Format = "K", ;
		Height = 23, ;
		Left = 1, ;
		SelectOnEntry = .T., ;
		Top = 52, ;
		Visible = .F., ;
		Width = 190, ;
		Name = "Text2"


	*-- INTERNAL USE: When the controlsourcetype is assigned the default values for Text1 and Text2 are determined.
	PROCEDURE controlsourcetype_assign
		LPARAMETERS vNewVal

		LOCAL lvDefaultValue

		DO CASE
			CASE INLIST(m.vNewVal, "C", "M")
				m.lvDefaultValue = ""
			CASE INLIST(m.vNewVal, "N", "Y")
				m.lvDefaultValue = 0.00
			CASE m.vNewVal = "D"
				m.lvDefaultValue = {}
			CASE m.vNewVal = "T"
				m.lvDefaultValue = {/:}
			CASE m.vNewVal = "L"
				m.lvDefaultValue = .T.
		ENDCASE
		WITH THIS
			.text1.VALUE = m.lvDefaultValue
			.text2.VALUE = m.lvDefaultValue
			.text1.REFRESH()
			.text2.REFRESH()
			.ControlSourceType = m.vNewVal
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to fill the rowsource for Combo1 and set some initial values for this container.
	PROCEDURE setup
		LPARAMETERS tcFieldCaption, tcFieldType, tcColumnControlSource

		LOCAL lcUniqueCursorName

		THIS.columncontrolsource = m.tcColumnControlSource
		m.lcUniqueCursorName = SYS(2015)
		THIS.uniquecursorname = m.lcUniqueCursorName
		CREATE CURSOR (m.lcUniqueCursorName) (usrcaption C(30), datatypes C(30), ctrlone C(30), ctrltwo C(30), criteria I)
		m.tcFieldType = UPPER(m.tcFieldType)
		INSERT INTO (m.lcUniqueCursorName) VALUES ("", "", "", "", 0)
		IF INLIST(m.tcFieldType, "C", "M")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Comienza con", "CM", "Text1", "", 1)
		ENDIF
		IF INLIST(m.tcFieldType, "C", "M")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Contiene", "CM", "Text1", "", 2)
		ENDIF
		IF INLIST(m.tcFieldType, "C", "M", "N", "Y", "L", "D", "T")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Igual", "CMNYLDT", "Text1", "", 3)
		ENDIF
		IF INLIST(m.tcFieldType, "N", "Y", "D", "T")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Mayor que", "NYDT", "Text1", "", 4)
		ENDIF
		IF INLIST(m.tcFieldType, "N", "Y", "D", "T")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Menor que", "NYDT", "Text1", "", 5)
		ENDIF
		IF INLIST(m.tcFieldType, "N", "Y", "D", "T")
			INSERT INTO (m.lcUniqueCursorName) VALUES ("Entre", "NYDT", "Text1", "Text2", 6)
		ENDIF
		GO TOP IN (m.lcUniqueCursorName)
		WITH THIS
			.controlsourcetype = m.tcFieldType
			.combo1.ROWSOURCETYPE = 2
			.combo1.ROWSOURCE = m.lcUniqueCursorName
			.combo1.LISTINDEX = 1
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Handles the visibility of Text1 and Text2 controls based on whether the user has made an operator (Combo1) selection.
	PROCEDURE operatorchanged
		LOCAL lcControlOne, lcControlTwo

		WITH THIS
			IF !EOF(.uniquecursorname) AND .combo1.LISTINDEX != 1
				m.lcControlOne = EVALUATE(.uniquecursorname + ".ctrlone")
				m.lcControlTwo = EVALUATE(.uniquecursorname + ".ctrlTwo")
				.text1.VISIBLE = !EMPTY(m.lcControlOne)
				.text2.VISIBLE = !EMPTY(m.lcControlTwo)
			ELSE
				.text1.VISIBLE = .F.
				.text2.VISIBLE = .F.
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to return the filter string that was produced by this container based on the type of the target column's controlsource.
	PROCEDURE filterstring_access
		LOCAL lcFilterString, lnFilterType, lcAtCommand

		m.lcFilterString = ""
		IF THISFORM.GridExtraObject.CaseSensitive
			m.lcAtCommand = "AT("
		ELSE
			m.lcAtCommand = "ATC("
		ENDIF
		WITH THIS
			IF !EOF(.uniquecursorname) AND .combo1.LISTINDEX != 1
				m.lnFilterType = EVALUATE(.uniquecursorname + ".criteria")
				DO CASE
					CASE m.lnFilterType = 1
						m.lcFilterString = m.lcAtCommand + "[" + ALLTRIM(.text1.VALUE) + "], LEFT(" + .columncontrolsource + "," + TRANSFORM(LEN(ALLTRIM(.text1.VALUE))) + ")) > 0"
					CASE m.lnFilterType = 2
						m.lcFilterString = m.lcAtCommand + "[" + ALLTRIM(.text1.VALUE) + "], " + .columncontrolsource + ") > 0"
					CASE m.lnFilterType = 3
						DO CASE
							CASE INLIST(.controlsourcetype, "C", "M")
								m.lcFilterString = .columncontrolsource + "=[" + ALLTRIM(TRANSFORM(.text1.VALUE)) + "]"
							CASE INLIST(.controlsourcetype, "D", "T")
								m.lcFilterString = .columncontrolsource + "={" + ALLTRIM(TRANSFORM(.text1.VALUE)) + "}"
							OTHERWISE
								m.lcFilterString = .columncontrolsource + "=" + ALLTRIM(TRANSFORM(.text1.VALUE))
						ENDCASE
					CASE m.lnFilterType = 4
						IF INLIST(.controlsourcetype, "D", "T")
							m.lcFilterString = .columncontrolsource + ">{" + ALLTRIM(TRANSFORM(.text1.VALUE)) + "}"
						ELSE
							m.lcFilterString = .columncontrolsource + ">" + ALLTRIM(TRANSFORM(.text1.VALUE))
						ENDIF
					CASE m.lnFilterType = 5
						IF INLIST(.controlsourcetype, "D", "T")
							m.lcFilterString = .columncontrolsource + "<{" + ALLTRIM(TRANSFORM(.text1.VALUE)) + "}"
						ELSE
							m.lcFilterString = .columncontrolsource + "<" + ALLTRIM(TRANSFORM(.text1.VALUE))
						ENDIF
					CASE m.lnFilterType = 6
						IF INLIST(.controlsourcetype, "D", "T")
							m.lcFilterString = "Between(" + .columncontrolsource + ",{" + ALLTRIM(TRANSFORM(.text1.VALUE)) + "},{"  + ALLTRIM(TRANSFORM(.text2.VALUE)) + "})"
						ELSE
							m.lcFilterString = "Between(" + .columncontrolsource + "," + ALLTRIM(TRANSFORM(.text1.VALUE)) + ","  + ALLTRIM(TRANSFORM(.text2.VALUE)) + ")"
						ENDIF
				ENDCASE
			ENDIF
		ENDWITH

		RETURN m.lcFilterString
	ENDPROC


	*-- INTERNAL USE: Used to clear any information that has been previously selected, thus setting the controls in this container back to their defaults of Blank.
	PROCEDURE clearfiltersettings
		WITH THIS
			.combo1.LISTINDEX = 1
			.controlsourcetype = .controlsourcetype
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Ensure's that when an operator (Combo1) is selected by the user in this container that the Filter selection grid on the Search/Filter form is in Select All state. Cannot have both selection filtering and operator filtering.
	PROCEDURE selectall
		WITH THISFORM
			IF !.check1.VALUE AND THIS.combo1.LISTINDEX > 1
				.check1.VALUE = .T.
				.check1.VALID()
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE Destroy
		USE IN SELECT(THIS.UniqueCursorName)
		DODEFAULT()
	ENDPROC


	PROCEDURE combo1.ProgrammaticChange
		THIS.INTERACTIVECHANGE()
	ENDPROC


	PROCEDURE combo1.InteractiveChange
		LOCAL lnListIndexWas
		IF THIS.PARENT.InteractiveChangeComboFiring
			RETURN
		ENDIF
		THISFORM.LastUserAction = SECONDS()
		WITH THIS
			.PARENT.InteractiveChangeComboFiring = .T.
			m.lnListIndexWas = .LISTINDEX
			.PARENT.OperatorChanged()
			.PARENT.SelectAll()
			.LISTINDEX = m.lnListIndexWas
			.REFRESH()
			.PARENT.InteractiveChangeComboFiring = .F.
		ENDWITH
	ENDPROC


	PROCEDURE combo1.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE text1.InteractiveChange
		THISFORM.LastUserAction = SECONDS()
		THIS.PARENT.SelectAll()
	ENDPROC


	PROCEDURE text1.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE text2.InteractiveChange
		THISFORM.LastUserAction = SECONDS()
		THIS.PARENT.selectall()
	ENDPROC


	PROCEDURE text2.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridcustomfilter
**************************************************


**************************************************
*-- Class:        gridextra (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   12/13/17 07:54:10 AM
*
DEFINE CLASS gridextra AS custom


	*-- Set this to an expression that evaluates to the target grid. Context of this expression should be the scope or the gridextra class instance (so Thisform.Grid1 would work).
	gridexpression = "Thisform.Grid1"
	*-- INTERNAL USE: Reference to the target grid.
	gridobject = .NULL.
	*-- INTERNAL USE: Used to hold the original filter that may have been enforced on the grid's recordsource before the user started adding additional filters using GridExtras.
	originalfilter = ""
	*-- Set this property to determine whether incremental searches and filters are case-sensitive or not.
	casesensitive = .F.
	*-- INTERNAL USE: A unique name that is added as an array property to the _screen to hold the filter strings.
	globalarrayname = ""
	*-- Set to the image file that you want gridextra to use as the header picture when the target column has a filter in effect.
	headerfilterimage = "filter12.bmp"
	*-- INTERNAL USE: Holds a reference to the current column in the target grid.
	currentcolumn = .NULL.
	*-- INTERNAL USE: Used to hold the name of the temporary index file that may be used to support sorting columns where a CDX is not available.
	indexfile = ""
	*-- INTERNAL USE: Used to hold the name of the temporary tag that may be used to support sorting columns where a CDX is not available.
	indextag = ""
	*-- INTERNAL USE: Used to hold the field or expression that should be indexed when sorting a target column.
	parentfield = ""
	*-- Set to the image file that you want gridextra to use as the header picture when the target column is sorted descending.
	headerdescendingimage = "descendingsort12.bmp"
	*-- Set to the image file that you want gridextra to use as the header picture when the target column is sorted ascending.
	headerascendingimage = "ascendingsort12.bmp"
	*-- Set to the image file that you want gridextra to use as the header picture when the target column is unable to be sorted.
	headernosortimage = "nosort12.bmp"
	*-- INTERNAL USE: Used to hold the alias that should be indexed when sorting a target column.
	parenttable = ""
	*-- Set this to the name of the gridpreferences file you want gridextras to create/use to save user's preferences in. GetUserApplicationDataPath() + CompanyName + ProductName + GridPreferenceFile determines the full path.
	gridpreferencefile = "gridprefs.tmp"
	*-- Set this to the name of your company or the name of your client's company. Used to determine where the grid preferences file is saved.
	companyname = "MyCompany"
	*-- Set this to the name of your product or the name of your client's product. Used to determine where the grid preferences file is saved.
	productname = "MyProduct"
	*-- Determines whether the Excel export feature will be available to the user.
	allowgridexport = .T.
	*-- Determines whether the filter features will be available to the user.
	allowgridfilter = .T.
	*-- Determines whether the column sort feature will be available to the user.
	allowgridsort = .T.
	*-- Determines whether the users' grid preferences (column widths, column order, lockcolumns, and partition) will be saved and restored for the grid.
	allowgridpreferences = .T.
	*-- INTERNAL USE: Holds a reference to the image (gridextratemplates class) that sits in the bottom right of the target grid.
	gridtemplatesimage = .NULL.
	*-- INTERNAL USE: Used to hold a reference to the Search/Filter form so that it doesn't go out of scope until the user is done with it.
	searchandfilterform = .NULL.
	*-- INTERNAL USE: Holds a reference to a column object in the target grid.
	columnobject = .NULL.
	*-- INTERNAL USE: Holds a collection of cursor names used to handle comboboxes in the target grid's columns.
	combocursorcollection = .NULL.
	*-- INTERNAL USE: Holds the name of the internal cursor being used to hold the current combobox's list values.
	currentcombocursorname = ""
	*-- Set this property to an expression that evaluates to a full path pointing to the gridextras.dbf (or whatever you named the template table). This would usually be the same as your application's database directory.
	templatetable = "["] + FullPath("gridextras.dbf") + ["]
	*-- Set to the image file that you want gridextra to use as the header picture when the target column is sorted ascending and a filter is in effect.
	headerfilterascendingimage = "filterAscending12.bmp"
	*-- Set to the image file that you want gridextra to use as the header picture when the target column is sorted descending and a filter is in effect.
	headerfilterdescendingimage = "filterDescending12.bmp"
	*-- A numeric value 0 - 255 that controls how much the search/filter form fades. 0 = Completely Transparent, 255 = Completely Opaque (no fade)
	fadelevel = 150
	*-- Time in seconds to wait before fading the search/filter form.
	fadewait = 1
	*-- INTERNAL USE: Used as a workaround to keep Header Click events from firing when moving columns.
	columnwasmoved = .F.
	*-- Determines whether the column visibility feature will be available to the user.
	allowcolumnvisibility = .T.
	*-- If AllowColumnVisibility is .T., set this property to the number of columns that you want listed in the header's context menu before a "More..." item is added.
	maxcolumnsincontextmenu = 8
	*-- INTERNAL USE: Used to hold a reference to the gridcolumns form so it doesn't go out of scope.
	columnsform = .NULL.
	*-- Determines whether the template feature (save sorts and filters and allow them to be restored later) will be available to the user.
	allowgridtemplates = .T.
	gridtemplatesform = .NULL.
	allowgridreport = .T.
	gridreportfile = (addbs(Sys(2023)) + sys(2015) + ".frx")
	templatetablecodepage = 1252
	templateindexcollatesequence = "MACHINE"
	templatetablefree = .T.
	Name = "gridextra"

	*-- INTERNAL USE: Array used to hold the filter created when the user checks/unchecks values on GridExtraForm.
	DIMENSION acolumnfilters[1,3]

	*-- INTERNAL USE: An array of custom filters chosen by the user [Between, Contains, Greater Than, etc.].
	DIMENSION customcolumnfilters[1,5]


	*-- INTERNAL USE: Fires when the target column header's Rightclick event occurs.
	PROCEDURE headerrightclick
		LOCAL loHeaderObject, lnLeft, lnTop, lnLocationOut, lcMenuCommand
		LOCAL lnColumnCounter, lnColumnOrderCounter, loColumn, lnCurrentMenuItem, lcPublicGridExtraReference, lnCountMax
		this.currentcombocursorname = ""
		m.lnLocationOut = 0
		This.GridObject.GridHitTest(MCOL(0, 3), MROW(0, 3), @lnLocationOut)
		IF m.lnLocationOut = 1
			m.loHeaderObject = This.GetHeaderObject()
			IF !ISNULL(m.loHeaderObject)
				IF this.Allowcolumnvisibility OR This.AllowGridExport
					m.lcPublicGridExtraReference = SYS(2015)
					PUBLIC &lcPublicGridExtraReference
					&lcPublicGridExtraReference = This
					m.lnCurrentMenuItem = 1
					DEFINE POPUP mnuContext SHORTCUT RELATIVE FROM MROW(),MCOL()
					IF This.AllowGridFilter
						DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "Buscar/Filtrar" PICTURE "search16.bmp"
					ELSE
						DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "Buscar" PICTURE "search16.bmp"
					ENDIF
					m.lcMenuCommand = m.lcPublicGridExtraReference + ".ShowSearchFilterForm(" + m.lcPublicGridExtraReference + ".GridObject." + m.loHeaderObject.Parent.Name + "." + m.loHeaderObject.Name + ")"
					ON SELECTION BAR (m.lnCurrentMenuItem) OF mnuContext &lcMenuCommand
					IF This.AllowGridExport
						m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
						DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "Exportar a excel" PICTURE "excel.jpg"
						m.lcMenuCommand = m.lcPublicGridExtraReference + ".CopyToExcel()"
						ON SELECTION BAR (m.lnCurrentMenuItem) OF mnuContext &lcMenuCommand
					ENDIF
					IF This.AllowGridReport
						m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
						DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "Vista Previa" PICTURE "printer16.bmp"
						m.lcMenuCommand = m.lcPublicGridExtraReference + ".CopyToReport()"
						ON SELECTION BAR (m.lnCurrentMenuItem) OF mnuContext &lcMenuCommand
					ENDIF
					IF this.Allowcolumnvisibility
						m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
						DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "\-"
						m.lnCountMax = MIN(This.GridObject.ColumnCount, This.MaxColumnsInContextMenu)
						FOR m.lnColumnCounter = 1 TO m.lnCountMax
							FOR m.lnColumnOrderCounter = 1 TO This.GridObject.ColumnCount
								m.loColumn = This.GridObject.Columns(m.lnColumnOrderCounter)
								IF m.loColumn.ColumnOrder != m.lnColumnCounter
									LOOP
								ELSE
									m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
									DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT m.loColumn.controls(1).caption
									SET MARK OF BAR (m.lnCurrentMenuItem) OF mnuContext TO m.loColumn.Visible
									m.lcMenuCommand = m.lcPublicGridExtraReference + ".ShowHideColumn(" + m.lcPublicGridExtraReference + ".GridObject." + m.loColumn.Name + ")"
									ON SELECTION BAR (m.lnCurrentMenuItem) OF mnuContext &lcMenuCommand
								ENDIF
							ENDFOR
						ENDFOR
						IF This.GridObject.ColumnCount > This.MaxColumnsInContextMenu
							IF This.MaxColumnsInContextMenu != 0
								m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
								DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "\-"
							ENDIF
							m.lnCurrentMenuItem = m.lnCurrentMenuItem + 1
							DEFINE BAR (m.lnCurrentMenuItem) OF mnuContext PROMPT "Mas..."
							m.lcMenuCommand = m.lcPublicGridExtraReference + ".ShowColumnsForm()"
							ON SELECTION BAR (m.lnCurrentMenuItem) OF mnuContext &lcMenuCommand
						ENDIF
					ENDIF
					ACTIVATE POPUP mnuContext BAR 1
					RELEASE &lcPublicGridExtraReference
				ELSE
					this.ShowSearchFilterForm(m.loHeaderObject)
				ENDIF
			ENDIF
		ELSE
			This.savegridpreferences(this.GridObject)
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Fires when the target column header's Click event occurs.
	PROCEDURE headerclick
		LOCAL loObject, lnLeft, lnTop, loActiveControlInColumn, lcColumnCursorName, llIsCombobox, lcTag, llUseHeaderFilterImage, lcHeaderImage  
		this.currentcombocursorname = ""
		STORE .F. TO m.llIsCombobox, ;
		             m.llUseHeaderFilterImage
		IF this.allowgridsort AND !this.columnwasmoved
			m.loObject = This.GetHeaderObject()
			IF !ISNULL(m.loObject)
			    m.lcTag = m.loObject.Tag
			    This.ClearHeaderSortImages()
				m.lcHeaderImage  = UPPER(JUSTFNAME(m.loObject.picture))
		        IF !EMPTY(m.lcHeaderImage) AND INLIST(lcHeaderImage,UPPER(This.HeaderFilterImage),UPPER(This.HeaderFilterDescendingImage),UPPER(This.HeaderFilterAscendingImage))	    
		          m.llUseHeaderFilterImage = .T.
		        ENDIF
			    DO CASE
			      CASE m.lcTag = 'D'
			          m.loObject.Tag     = 'N'
			          IF m.llUseHeaderFilterImage
			            m.loObject.Picture = This.HeaderFilterImage            && Show Filter Image
			          ELSE
			            m.loObject.Picture = ''                                && Change to No Sort Order from Descending 
			          ENDIF 

			      CASE m.lcTag = 'A'
			          m.loObject.Tag     = 'D'
			          IF m.llUseHeaderFilterImage
			            m.loObject.Picture = This.HeaderFilterDescendingImage && Show Filter Descending Image
			          ELSE 
			            m.loObject.Picture = This.HeaderDescendingImage       && Change to Descending from Ascending	          
			          ENDIF 
			          
			      OTHERWISE
			          m.loObject.Tag     = 'A'
			          IF m.llUseHeaderFilterImage
			            m.loObject.Picture = This.HeaderFilterAscendingImage  && Show Filter Ascending Image
			          ELSE 
		  	            m.loObject.Picture = This.HeaderAscendingImage        && Change to Ascending from No Sort Order
			          ENDIF 
		          
			    ENDCASE 
				m.loActiveControlInColumn = EVALUATE("m.loObject.parent." + m.loObject.parent.currentcontrol)
				IF LOWER(ALLTRIM(m.loActiveControlInColumn.Baseclass)) = "combobox"
					m.lcColumnCursorName = this.getcombocursorname(m.loActiveControlInColumn)
					m.llIsCombobox = .T.
				ENDIF
				this.applysort(m.llIsCombobox,,m.loObject.Tag)
				this.SetHeaderImages()
			ENDIF
		ELSE
			this.columnwasmoved = .F.
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to set the proper header pictures for the target grid.
	PROCEDURE setheaderimages
		LOCAL loColumnObject, loHeaderObject, lcHeaderImage, llCustomFilterEnforced, lnCustomFilterIndex
		FOR EACH m.loColumnObject IN This.GridObject.Columns
			m.llCustomFilterEnforced = .F.
			m.loHeaderObject = m.loColumnObject.Controls(1)
			m.lcHeaderImage = UPPER(JUSTFNAME(m.loHeaderObject.picture))
			m.lnCustomFilterIndex = ASCAN(this.customcolumnfilters,ALLTRIM(m.loColumnObject.Name),-1,-1,1,15)
			IF m.lnCustomFilterIndex > 0 AND !EMPTY(this.customcolumnfilters(m.lnCustomFilterIndex,5))
				m.llCustomFilterEnforced = .T.
			ENDIF
			IF m.llCustomFilterEnforced OR ASCAN(this.acolumnfilters,ALLTRIM(m.loColumnObject.name),-1,-1,2,15) > 0
			  DO CASE  
			    CASE m.loHeaderObject.Tag = 'A'
			        m.loHeaderObject.picture = This.HeaderFilterAscendingImage   && Filtered Ascending Image
			        
			    CASE m.loHeaderObject.Tag = 'D'
			        m.loHeaderObject.picture = This.HeaderFilterDescendingImage  && Filtered Descending Image	    
			        
			    OTHERWISE     
					m.loHeaderObject.picture = This.HeaderFilterImage            && Filtered Only Image
			  ENDCASE   
			ELSE
			  IF !EMPTY(m.lcHeaderImage) ;
			  AND !INLIST(m.lcHeaderImage, UPPER(this.HeaderAscendingImage), UPPER(This.HeaderDescendingImage), UPPER(This.HeaderNoSortImage), ; 
			                               UPPER(this.HeaderFilterAscendingImage), UPPER(This.HeaderFilterDescendingImage))
				  STORE '' TO  m.loHeaderObject.picture, ;
				               m.loHeaderObject.Tag
			  ENDIF
			ENDIF
		ENDFOR
	ENDPROC


	*-- Call this when your target grid is ready for action (has a recordsource, columns, controlsources set, etc.).
	PROCEDURE setup
		LOCAL loGridObject, loColumnObject, loHeaderObject, lcClassLib, lcGlobalArray, lcGridTemplatesImageName, lnGridExportAnchorValue, ;
		      llSetHeaderTag
		STORE Null TO This.GridObject, m.loColumnObject, m.loHeaderObject
		UNBINDEVENTS(this)
		this.CreateScreenReference()
		m.llSetHeaderTag = .T.
		m.lcGlobalArray  = [_GEScr.] + this.GlobalArrayName
		DIMENSION &lcGlobalArray.(1,1)
		STORE .F. TO &lcGlobalArray
		m.lcClassLib = LOWER(JUSTFNAME(this.ClassLibrary))
		IF OCCURS(JUSTSTEM(m.lcClassLib),LOWER(SET("Classlib"))) = 0
			IF FILE(this.ClassLibrary)
				SET CLASSLIB TO (this.ClassLibrary) ADDITIVE
			ELSE
				SET CLASSLIB TO (LOCFILE(m.lcClassLib)) ADDITIVE
			ENDIF
		ENDIF
		This.GridObject = EVALUATE(this.gridexpression)
		IF TYPE("This.GridObject.Name") = "C"
			this.restoregridpreferences(This.GridObject)
			This.BindGridEvents(This.GridObject)
			FOR EACH m.loColumnObject IN This.GridObject.Columns
				This.BindColumnEvents(m.loColumnObject)
				This.BindHeaderEvents(m.loColumnObject.Controls(1))
				IF m.llSetHeaderTag
				  This.SetHeaderTag(m.loColumnObject,m.loColumnObject.Controls(1),@m.llSetHeaderTag)
				ENDIF   
			ENDFOR
		    This.SetHeaderImages()
			this.originalfilter = FILTER(this.GridObject.recordsource)
			this.originalfilter = IIF(!EMPTY(this.originalfilter), "(" + this.originalfilter + ")", "")
			IF this.allowgridtemplates
				m.lcGridTemplatesImageName = SYS(2015)
				This.GridObject.parent.AddObject(m.lcGridTemplatesImageName,"GridExtraTemplates",this)
				this.GridTemplatesImage = EVALUATE("This.GridObject.parent." + m.lcGridTemplatesImageName)
				this.GridTemplatesImage.GridObject = this.GridObject
				BINDEVENT(this.GridObject, "zorder", this.GridTemplatesImage, "zorderupdate", 1)
				BINDEVENT(this.GridObject, "resize", this.GridTemplatesImage, "resizeupdate", 1)
				IF TYPE("this.GridTemplatesImage.Name") = "C"
					m.lnGridExportAnchorValue = 0
					IF BITTEST(This.GridObject.anchor,3)
						 m.lnGridExportAnchorValue = BITSET(m.lnGridExportAnchorValue, 3)
					ELSE
						IF BITTEST(This.GridObject.anchor,7)
							 m.lnGridExportAnchorValue = BITSET(m.lnGridExportAnchorValue, 7)
						ENDIF
					ENDIF

					IF BITTEST(This.GridObject.anchor,2)
						 m.lnGridExportAnchorValue = BITSET(m.lnGridExportAnchorValue, 2)
					ELSE
						IF BITTEST(This.GridObject.anchor,6)
							 m.lnGridExportAnchorValue = BITSET(m.lnGridExportAnchorValue, 6)
						ENDIF
					ENDIF
					this.GridTemplatesImage.Anchor = 0
					this.GridTemplatesImage.Left = (This.GridObject.Left + This.GridObject.Width - 19)
					IF INLIST(This.GridObject.scrollbars,0,2)
						this.GridTemplatesImage.Top = (This.GridObject.Top + This.GridObject.Height + 1)
					ELSE
						this.GridTemplatesImage.Top = (This.GridObject.Top + This.GridObject.Height - 18)
					ENDIF
					this.GridTemplatesImage.Anchor = m.lnGridExportAnchorValue
					this.GridTemplatesImage.visible = .T.
				ENDIF
			ENDIF
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to save the user's preferences (columns widths, column order, partition setting, and lockcolumns)
	PROCEDURE savegridpreferences
		LPARAMETERS toGridObject
		Local lcGridHierarchy, lcString, lcPrefs, lcPrefFileContents, ;
			lcBeginPrefs, lcEndPrefs, lcPrefFile, loColumn, lnCounter, loExc as Exception
		IF this.allowgridpreferences
			m.lcGridHierarchy = Sys(1272, m.toGridObject)
			m.lcBeginPrefs = m.lcGridHierarchy + "("
			m.lcEndPrefs = ")"
			m.lcPrefFile = This.GetUserApplicationDataPath() + This.GridPreferenceFile
			m.lcPrefFileContents = ""
			If File(m.lcPrefFile)
				m.lcPrefFileContents = Filetostr(m.lcPrefFile)
			Endif
			m.lcPrefs = Strextract(m.lcPrefFileContents,m.lcBeginPrefs,m.lcEndPrefs,1,5)
			m.lcString = ""
			Try
				For m.lnCounter = 1 To m.toGridObject.ColumnCount
					m.loColumn = m.toGridObject.Columns(m.lnCounter)
					m.lcString = m.lcString + Transform(m.loColumn.ColumnOrder) + ","
					m.lcString = m.lcString + Transform(m.loColumn.Width) + ","
				ENDFOR
				m.lcString = m.lcString + "::" + TRANSFORM(m.toGridObject.LockColumns)
				m.lcString = m.lcString + "::" + TRANSFORM(m.toGridObject.LockColumnsLeft)
				m.lcString = m.lcString + "::" + TRANSFORM(m.toGridObject.Partition) + 	"::"
			CATCH TO m.loExc
			ENDTRY
			If !Empty(m.lcString)
				m.lcString = m.lcBeginPrefs + m.lcString + m.lcEndPrefs
				If Empty(m.lcPrefs) Or m.lcString != m.lcPrefs
					If Empty(m.lcPrefs)
						m.lcPrefFileContents = m.lcPrefFileContents + m.lcString + Chr(13) + Chr(10)
					Else
						m.lcPrefFileContents = Strtran(m.lcPrefFileContents, m.lcPrefs, m.lcString, 1, 1, 1)
					Endif
					Set Safety Off
					=Strtofile(m.lcPrefFileContents, m.lcPrefFile, 0)
				Endif
			ENDIF
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to restore the user's preferences that were saved using the SaveGridPreferences method.
	PROCEDURE restoregridpreferences
		LPARAMETERS toGridObject
		Local lcGridHierarchy, lcString, lcPrefs, lcPrefFileContents, lcBeginPrefs, lcEndPrefs, lcPrefFile, ;
			loColumn, lnCounter, lnMax, loExc as Exception, lnAdditionalProperties
		IF this.allowgridpreferences
			m.lcPrefFile = This.GetUserApplicationDataPath() + This.GridPreferenceFile
			m.lcPrefFileContents = ""
			If File(m.lcPrefFile)
				Try
					m.lcPrefFileContents = Filetostr(m.lcPrefFile)
					m.lcGridHierarchy = Sys(1272, m.toGridObject)
					m.lcBeginPrefs = m.lcGridHierarchy + "("
					m.lcEndPrefs = ")"
					m.lcPrefs = Strextract(m.lcPrefFileContents,m.lcBeginPrefs,m.lcEndPrefs,1,1)
					If !Empty(m.lcPrefs)
						m.lnAdditionalProperties = (OCCURS("::", m.lcPrefs) - 1)
						IF m.lnAdditionalProperties > 0
							=Alines(laPrefs, m.lcPrefs, 7, ",", "::")
							m.lnMax =  Min(m.toGridObject.ColumnCount * 2, Alen(laPrefs) - m.lnAdditionalProperties)
						ELSE
							=Alines(laPrefs, m.lcPrefs, 7, ",")
							m.lnMax =  Min(m.toGridObject.ColumnCount * 2, Alen(laPrefs))
						ENDIF
						For m.lnCounter = 1 To m.lnMax - 3 Step 2
							m.loColumn = m.toGridObject.Columns((m.lnCounter + 1)/2)
							If Type("m.loColumn.columnorder") = "N"
								m.loColumn.ColumnOrder = Val(laPrefs(m.lnCounter))
								m.loColumn.Width = Val(laPrefs(m.lnCounter + 1))
							Endif
						ENDFOR
						IF m.lnAdditionalProperties > 0
							m.toGridObject.LockColumns = Val(laPrefs(m.lnCounter + 2))
						ENDIF
						IF m.lnAdditionalProperties > 1
							m.toGridObject.LockColumnsLeft = Val(laPrefs(m.lnCounter + 3))
						ENDIF
						IF m.lnAdditionalProperties > 2
							m.toGridObject.Partition = Val(laPrefs(m.lnCounter + 4))
						ENDIF
					Endif
				CATCH TO m.loExc && Just let any errors fail silently
				Endtry
			ENDIF
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Binds the Click and RightClick events of the column headers in the grid for the Sort, context menu, or Search/Filter features.
	PROCEDURE bindheaderevents
		LPARAMETERS toHeaderObject
		BINDEVENT(m.toHeaderObject, "Click", This, "HeaderClick", 1)
		BINDEVENT(m.toHeaderObject, "RightClick", This, "HeaderRightClick", 1)
	ENDPROC


	*-- INTERNAL USE: Returns a reference to the header object for the column that the user's mouse is currently over.
	PROCEDURE getheaderobject
		LOCAL loObject
		m.loObject = this.GetColumnObject()
		IF !ISNULL(m.loObject) AND TYPE("m.loObject.baseclass") = "C" AND UPPER(m.loObject.baseclass) = "COLUMN"
			m.loObject = m.loObject.Controls(1) && Get header control
		ENDIF
		RETURN m.loObject
	ENDPROC


	*-- INTERNAL USE: Used to properly position the Search/Filter form by the target column's header control.
	PROCEDURE positionform
		LPARAMETERS toSearchAndFilterForm, toHeader
		LOCAL lnTop
		IF TYPE("m.toSearchAndFilterForm.name") = "C" AND TYPE("m.toHeader.caption") = "C"
			WITH m.toSearchAndFilterForm
				m.lnTop = OBJTOCLIENT(m.toHeader, 1 ) + IIF(THISFORM.TITLEBAR=1,SYSMETRIC(9),0) + m.toHeader.PARENT.PARENT.HEADERHEIGHT + ;
					IIF(THISFORM.BORDERSTYLE = 3, SYSMETRIC(4), SYSMETRIC(13)) + ;
					IIF(THISFORM.SHOWWINDOW = 2, Thisform.Top, OBJTOCLIENT(THISFORM, 1 )) + 1 && thanks to Vassilis Aggelakos for the Titlebar=1 fix/idea
				.LEFT = OBJTOCLIENT(m.toHeader, 2) + IIF(THISFORM.BORDERSTYLE = 3, SYSMETRIC(3), ;
					SYSMETRIC(12)) + IIF(THISFORM.SHOWWINDOW = 2, Thisform.Left, OBJTOCLIENT( THISFORM, 2 ))
				IF ((m.lnTop + .HEIGHT) > SYSMETRIC(2))
					m.lnTop = m.lnTop - .HEIGHT - m.toHeader.PARENT.PARENT.HEADERHEIGHT - (2 * SYSMETRIC(13)) + 4
				ENDIF
				.TOP = m.lnTop - 1
			ENDWITH
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Applies the GridExtra filter to the recordsource of the target grid.
	PROCEDURE applyfilter
		LOCAL lcFilter, lnFilterCounter, lcColumnFilter, lcCurrentFilter, lcCustomFilterString
		IF TYPE("this.GridObject.Name") = "C"
			m.lcCurrentFilter = FILTER(this.GridObject.recordsource)
			*!* Need 8 paranthesis on the right side to handle between() filters correctly
			DO WHILE !EMPTY(STREXTRACT(m.lcCurrentFilter,".AND.(((((((","))))))))",1,4))
				m.lcCurrentFilter = STRTRAN(m.lcCurrentFilter, STREXTRACT(m.lcCurrentFilter,".AND.(((((((","))))))))",1,4),"",-1,-1,1)
			ENDDO
			*!* Need 8 paranthesis on the right side to handle between() filters correctly
			DO WHILE !EMPTY(STREXTRACT(m.lcCurrentFilter,"(((((((","))))))))",1,4))
				m.lcCurrentFilter = STRTRAN(m.lcCurrentFilter, STREXTRACT(m.lcCurrentFilter,"(((((((","))))))))",1,4),"",-1,-1,1)
			ENDDO
			*!* Now 7 paranthesis
			DO WHILE !EMPTY(STREXTRACT(m.lcCurrentFilter,".AND.(((((((",")))))))",1,4))
				m.lcCurrentFilter = STRTRAN(m.lcCurrentFilter, STREXTRACT(m.lcCurrentFilter,".AND.(((((((",")))))))",1,4),"",-1,-1,1)
			ENDDO
			*!* Now 7 paranthesis
			DO WHILE !EMPTY(STREXTRACT(m.lcCurrentFilter,"(((((((",")))))))",1,4))
				m.lcCurrentFilter = STRTRAN(m.lcCurrentFilter, STREXTRACT(m.lcCurrentFilter,"(((((((",")))))))",1,4),"",-1,-1,1)
			ENDDO
			m.lcCurrentFilter = IIF(!EMPTY(m.lcCurrentFilter) and (LEFT(ALLTRIM(m.lcCurrentFilter),1) != "(" or RIGHT(ALLTRIM(m.lcCurrentFilter),1) != ")"), ;
								"(" + m.lcCurrentFilter + ")", m.lcCurrentFilter)

			IF ATC(this.globalarrayname,m.lcCurrentFilter) = 0
				this.originalfilter = m.lcCurrentFilter
			ENDIF

			m.lcCustomFilterString = ""
			FOR m.lnFilterCounter = 1 TO ALEN(this.customcolumnfilters,1)
				IF !EMPTY(this.customcolumnfilters(m.lnFilterCounter,5))
					m.lcCustomFilterString = m.lcCustomFilterString + IIF(!EMPTY(m.lcCustomFilterString)," AND ", " ") + this.customcolumnfilters(m.lnFilterCounter,5)
				ENDIF
			ENDFOR

			this.originalfilter = IIF(!EMPTY(this.originalfilter) and (LEFT(ALLTRIM(this.originalfilter),1) != "(" or RIGHT(ALLTRIM(this.originalfilter),1) != ")"), ;
								"(" + this.originalfilter + ")", this.originalfilter)

			IF !EMPTY(m.lcCustomFilterString)
				m.lcFilter = IIF(!EMPTY(this.originalfilter), this.originalfilter + ".AND.(((((((", "(((((((") + m.lcCustomFilterString + ")))))))"
			ELSE
				m.lcFilter = This.originalfilter
			ENDIF
			FOR m.lnFilterCounter = 1 TO ALEN(this.aColumnFilters,1)
				m.lcColumnFilter = this.aColumnFilters(m.lnFilterCounter, 1)
				IF TYPE("m.lcColumnFilter") = "C" AND !EMPTY(m.lcColumnFilter)
					m.lcFilter = m.lcFilter + This.AddJoiner(m.lcFilter, m.lcColumnFilter)
				ENDIF
			ENDFOR
			TRY
				SET FILTER TO &lcFilter IN (this.GridObject.recordsource)
			CATCH
			ENDTRY
			GO TOP IN (this.GridObject.recordsource)
			this.GridObject.refresh()

			IF VARTYPE(this.GridObject.TotFilter)<>'U'
				IF EMPTY(LcFilter)
					LcFilter = '.T.'
				ENDIF
				SELECT COUNT(*) FROM  (this.GridObject.recordsource)  WHERE  &lcFilter INTO  ARRAY aTotFilter
				this.GridObject.TotFilter = aTotFilter[1]

			ENDIF

		ENDIF
	ENDPROC


	*-- INTERNAL USE: Clears the current filter arrays.
	PROCEDURE clearfilter
		LOCAL lcFilter
		m.lcFilter = This.originalfilter
		IF USED(this.GridObject.recordsource)
			SET FILTER TO &lcFilter IN (this.GridObject.recordsource)
			GO TOP IN (this.GridObject.recordsource)
		ENDIF
		this.GridObject.refresh()
	ENDPROC


	*-- INTERNAL USE: Adds 'AND' between clauses if necessary.
	PROCEDURE addjoiner
		LPARAMETERS tcCurrentFilter, tcFilterNewPart
		LOCAL lcReturn, lcCurrentFilterPart
		m.lcReturn = ""
		IF !EMPTY(m.tcFilterNewPart)
			m.tcFilterNewPart = ALLTRIM(m.tcFilterNewPart)
			m.tcCurrentFilter = ALLTRIM(m.tcCurrentFilter)
			m.lcCurrentFilterPart = RIGHT(m.tcCurrentFilter,1)
			IF m.lcCurrentFilterPart != "(" AND m.tcFilterNewPart != ")"
				DO CASE 
					CASE m.tcFilterNewPart = "(" AND EMPTY(m.tcCurrentFilter)
						m.lcReturn = m.tcFilterNewPart
					CASE m.tcFilterNewPart = "(" AND !EMPTY(m.tcCurrentFilter)
						m.lcReturn = " AND " + m.tcFilterNewPart
					CASE m.lcCurrentFilterPart = ")"
						m.lcReturn = " AND " + m.tcFilterNewPart
					OTHERWISE
						m.lcReturn = " OR " + m.tcFilterNewPart
				ENDCASE
			ELSE
				m.lcReturn = m.tcFilterNewPart
			ENDIF
		ENDIF

		RETURN m.lcReturn
	ENDPROC


	*-- INTERNAL USE: Applies the sort (ASC, DESC, NONE) to a column in the target grid.
	PROCEDURE applysort
		Lparameters tlIsCombobox, toColumnObject, tcTemplateAscending
		Local lnSelectWas, lcSafetyWas, lcSortExpression, ;
			lcControlSource, lcParentField, loColumn, ;
			lnTagNo, llNewColumn, loHeaderObject, ;
			loExc As Exception, lnChangedBufferFrom

		m.lnSelectWas = Select()

		If Type('m.tcTemplateAscending') != 'C' ;
				OR !Inlist(tcTemplateAscending,'D','A','N')
			m.tcTemplateAscending = 'N'
		Endif

		With This
			If Type("m.toColumnObject") = "O"
				m.loColumn = m.toColumnObject
			Else
				m.loColumn = This.GetColumnObject()
			Endif
			If Type("m.loColumn.PARENT.RECORDSOURCE") != "C"
				Return .F.
			Endif
			If !Isnull(.currentcolumn) And m.loColumn.Name = .currentcolumn.Name And Vartype(m.toColumnObject) != "O"
				m.llNewColumn = .F.
			Else
				m.llNewColumn = .T.
				.currentcolumn = m.loColumn
				Release m.loColumn
				m.loColumn = Null
			Endif
			If Type([This.CurrentColumn]) != "O" Or Type([This.CurrentColumn.ControlSource]) != "C"
				m.loHeaderObject = .currentcolumn.Controls(1)
				This.ClearHeaderSortImages()
				m.loHeaderObject.Picture = This.HeaderNoSortImage && "navigate_no.png"
				.currentcolumn = Null
				Select (m.lnSelectWas)
				Return .F.
			Endif
			.currentcolumn.SetFocus()
			m.lcControlSource = Evaluate([This.CurrentColumn.ControlSource])
			m.lcParentField = Justext(m.lcControlSource)
			If m.tlIsCombobox Or Empty(Field(m.lcParentField,.currentcolumn.Parent.RecordSource))
				m.lcParentField = m.lcControlSource
				.ParentTable = .currentcolumn.Parent.RecordSource
				Select (.ParentTable)
				m.lnTagNo = 0
			Else
				.ParentTable = Juststem(m.lcControlSource)
				Select (.ParentTable)
				m.lnTagNo = Tagno(m.lcParentField)
			Endif
			If !m.llNewColumn Or m.lnTagNo > 0
				If m.lnTagNo = 0 && we're dealing with an idx
					m.lcParentField = Juststem(.INDEXFILE)
				Endif
				Try
					Do Case
					Case m.tcTemplateAscending = 'D'
						Set Order To (m.lcParentField) In (.ParentTable) Descending

					Case m.tcTemplateAscending = 'A'
						Set Order To (m.lcParentField) In (.ParentTable) Ascending

					Otherwise
						Set Order To 0 In (.ParentTable)
					Endcase
				Catch
					Set Order To 0 In (.ParentTable)
				Endtry
			Else
				m.lcSortExpression = This.GetSortExpression(m.lcParentField, m.tlIsCombobox)
				If !Empty(m.lcSortExpression)
					m.lcSafetyWas = Set("Safety")
					Set Safety Off && If idx already exists, overwrite it silently
					Try
						m.lnChangedBufferFrom = CursorGetProp("Buffering", .ParentTable)
						If Between(m.lnChangedBufferFrom, 4, 5)
							If Getnextmodified(0, .ParentTable, .T.) = 0
								CursorSetProp("Buffering", 3, .ParentTable) && Must set tables and views to optimistic row buffering in order to create a temp index
							Else
								Messagebox("The system was unable to sort the selected column due to unsaved changes." + Chr(13) ;
									+ "Save your changes and try again.", 64, "Unsaved Changes Detected - Save Required")
								Exit
							Endif
						Endif
						Try
							Index On &lcSortExpression To (.INDEXFILE)
							Do Case
							Case m.tcTemplateAscending = 'D'
								Set Order To (Order(.ParentTable)) Descending

							Case m .tcTemplateAscending = 'A'
								Set Order To (Order(.ParentTable)) Ascending

							Otherwise
								Set Order To 0 In (.ParentTable)
							Endcase
						Catch
							Set Order To 0 In (.ParentTable)
						Endtry
					Catch To m.loExc
						m.loHeaderObject = .currentcolumn.Controls(1)
						m.loHeaderObject.Picture = This.HeaderNoSortImage && "navigate_no.png"
						.currentcolumn = Null
					Finally
						If Used(.ParentTable)
							If Between(m.lnChangedBufferFrom, 4, 5) And !Between(CursorGetProp("Buffering", .ParentTable),4,5)
								CursorSetProp("Buffering", m.lnChangedBufferFrom, .ParentTable)
							Endif
						Endif
					Endtry
					Set Safety &lcSafetyWas && set it back the way we found it
				Endif
			Endif
			If !Isnull(.currentcolumn)
				Go Bottom In (.ParentTable)
				Go Top In (.ParentTable)
				.GridObject.Refresh()
				.currentcolumn.SetFocus()
			Endif
			.GridObject.Refresh()
		Endwith
		Select (m.lnSelectWas)
		Return (!Isnull(This.currentcolumn))
	ENDPROC


	*-- INTERNAL USE: Returns the sort expression to be used for indexing/sorting a column within the target grid.
	PROCEDURE getsortexpression
		LPARAMETERS tcFieldName, tlIsCombobox
		LOCAL lcType, lcSortExpression
		m.lcType = TYPE(m.tcFieldName)
		IF PCOUNT() < 2
			m.tlIsCombobox = .F.
		ENDIF
		IF m.tlIsCombobox
			m.lcSortExpression = this.currentcombocursorname + [.disptext FOR SEEK(&tcFieldName, "] + this.currentcombocursorname + [","fkid")]
		ELSE
			DO CASE
				CASE m.lcType $ "CM"
					m.lcSortExpression = [UPPER(LEFT(NVL(] + m.tcFieldName + [,""), 99))]
				CASE lcType = "N"
					m.lcSortExpression = [NVL(]  + m.tcFieldName + [, 0)]
				CASE m.lcType $ "D"
					m.lcSortExpression = [NVL(] + m.tcFieldName + [, {})]
				CASE m.lcType $ "T"
					m.lcSortExpression = [NVL(] + m.tcFieldName + [, {/:})]
				CASE m.lcType == "L"
					m.lcSortExpression = [NVL(]  + m.tcFieldName + [, .F.)]
				CASE m.lcType == "Y"
					m.lcSortExpression = [NVL(]  + m.tcFieldName + [, $0.00)]
				OTHERWISE
					m.lcSortExpression = ""
			ENDCASE
		ENDIF

		RETURN m.lcSortExpression
	ENDPROC


	*-- INTERNAL USE: Clears the current header images.
	PROCEDURE clearheadersortimages
		LOCAL loHeaderObject, lnCounter, loColumn, lcHeaderImage
		IF TYPE("THIS.currentcolumn.name") = "C"
			FOR m.lnCounter = 1 TO THIS.currentcolumn.parent.columncount
				m.loColumn = THIS.currentcolumn.parent.columns(m.lnCounter)
				m.loHeaderObject = m.loColumn.controls(1)
				m.lcHeaderImage = UPPER(JUSTFNAME(m.loHeaderObject.picture))
		*!*		IF !EMPTY(m.lcHeaderImage) AND INLIST(m.lcHeaderImage, UPPER(this.HeaderAscendingImage), UPPER(This.HeaderDescendingImage), UPPER(This.HeaderNoSortImage)) 
		*!*			 m.loHeaderObject.picture = ""
		*!*		ENDIF
				IF !EMPTY(m.lcHeaderImage)
				  DO CASE 
				    CASE INLIST(m.lcHeaderImage,UPPER(this.HeaderAscendingImage),UPPER(This.HeaderDescendingImage),UPPER(This.HeaderNoSortImage)) 
				        STORE "" TO m.loHeaderObject.picture, ;
				                    m.loHeaderObject.Tag
				                     
				    CASE INLIST(m.lcHeaderImage, UPPER(this.HeaderFilterAscendingImage), UPPER(This.HeaderFilterDescendingImage)) 
				        m.loHeaderObject.picture = This.HeaderFilterImage
				        m.loHeaderObject.Tag = ""
				  ENDCASE       
				ENDIF
			ENDFOR
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Returns a reference to the column object the user's mouse is currently over.
	PROCEDURE getcolumnobject
		LOCAL ARRAY laObject(1,4)
		LOCAL loObject, lcBaseClass
		=AMOUSEOBJ(m.laObject)
		m.loObject = m.laObject(1,1)
		IF TYPE("m.loObject.baseclass") = "C"
			m.lcBaseClass = UPPER(m.loObject.baseclass)
			DO case
			CASE m.lcBaseClass = "COLUMN"
				*!* Do nothing as m.loObject is the column
			CASE m.lcBaseClass = "HEADER"
				m.loObject = m.loObject.Parent
			OTHERWISE
				m.loObject = NULL
			ENDCASE
		ELSE
			m.loObject = NULL
		ENDIF
		This.columnobject = m.loObject
		RETURN m.loObject
	ENDPROC


	*-- INTERNAL USE: Returns the parth to the User's Application Data directory (profile specific AppData on Vista).
	PROCEDURE getuserapplicationdatapath
		#Define CSIDL_APPDATA 0x001a

		Local m.lcSpecialFolderPath, m.lcApplicationDataPath
		m.lcSpecialFolderPath = Space(255)

		Declare SHGetSpecialFolderPath In SHELL32.Dll ;
			LONG hwndOwner, ;
			STRING @cSpecialFolderPath, ;
			LONG nWhichFolder

		SHGetSpecialFolderPath(0, @m.lcSpecialFolderPath, CSIDL_APPDATA)
		m.lcApplicationDataPath = Alltrim(m.lcSpecialFolderPath)
		m.lcApplicationDataPath = Substr(m.lcApplicationDataPath,1, Len(m.lcApplicationDataPath)-1)
		m.lcApplicationDataPath = Addbs(m.lcApplicationDataPath) + This.CompanyName
		If !Directory(m.lcApplicationDataPath)
			Mkdir (m.lcApplicationDataPath)
		Endif
		m.lcApplicationDataPath = Addbs(m.lcApplicationDataPath) + This.ProductName
		If !Directory(m.lcApplicationDataPath)
			Mkdir (m.lcApplicationDataPath)
		Endif
		Return Addbs(m.lcApplicationDataPath)
	ENDPROC


	*-- INTERNAL USE: Binds the resize and move events of the columns to allow grid preferences to be saved appropriately.
	PROCEDURE bindcolumnevents
		LPARAMETERS toColumnObject
		BINDEVENT(m.toColumnObject, "Moved", This, "ColumnMoved", 1)
		BINDEVENT(m.toColumnObject, "Resize", This, "ColumnResize", 1)
	ENDPROC


	*-- INTERNAL USE: Fired when a column move event occurs for the target grid.
	PROCEDURE columnmoved
		this.columnwasmoved = .T. && workaround to keep header click from firing when user is moving column
		This.savegridpreferences(this.GridObject)
	ENDPROC


	*-- INTERNAL USE: Fired when a column resize event occurs for the target grid.
	PROCEDURE columnresize
		This.savegridpreferences(this.GridObject)
	ENDPROC


	*-- INTERNAL USE: Used to help provide the incremental search feature.
	PROCEDURE search
		LPARAMETERS tcSearchPhrase, tlFindNext, lcSearchCommand
		LOCAL lcRecordSource, lnSelectWas, lcControlSource, lcSearchValue, lnRecnoWas
		LOCAL llLockScreenWas, loActiveControlInColumn, lcCurrentComboCursorName
		LOCAL ARRAY aTemp(1)
		aTemp(1) = Null
		m.lcRecordSource = This.GridObject.recordsource
		If Used(m.lcRecordSource) AND TYPE("This.ColumnObject.Name") = "C"
		    m.lnSelectWas = SELECT()
			m.lcControlSource = This.ColumnObject.ControlSource
			m.loActiveControlInColumn = EVALUATE("This.ColumnObject." + This.ColumnObject.CurrentControl)
			IF LOWER(m.loActiveControlInColumn.BaseClass) = "combobox" and m.loActiveControlInColumn.BoundColumn != 1
				If This.casesensitive
					m.lcSearchCommand = [At(] && m.lcSearchValue, Transform(&lcControlSource)) > 0]
				ELSE
					m.lcSearchCommand = [Atc(]
				ENDIF
				m.lcSearchCommand = m.lcSearchCommand + [Alltrim(Transform(m.tcSearchPhrase)), disptext)>0]
				m.lcCurrentComboCursorName = this.currentcombocursorname
				SELECT fkid FROM (m.lcCurrentComboCursorName) WHERE &lcSearchCommand INTO ARRAY aTemp
				IF ISNULL(aTemp(1)) OR _tally < 1
					m.lcSearchCommand = [.F.]
				ELSE
					IF _tally > 1
						m.lcSearchCommand = [Ascan(aTemp, &lcControlSource)>0]
					ELSE
						m.lcSearchCommand = [&lcControlSource = aTemp(1)]
					ENDIF
				ENDIF
			ELSE
				m.lcSearchValue = Alltrim(Transform(m.tcSearchPhrase))
				If This.casesensitive
					m.lcSearchCommand = [At(] && m.lcSearchValue, Transform(&lcControlSource)) > 0]
				ELSE
					m.lcSearchCommand = [Atc(]
				ENDIF
				m.lcSearchCommand = m.lcSearchCommand + [m.lcSearchValue,Transform(&lcControlSource))>0]
			ENDIF

			Select (m.lcRecordSource)
			m.lnRecnoWas = RECNO()
			If m.tlFindNext
				If !Eof(m.lcRecordSource)
					Skip 1 In (m.lcRecordSource)
				ELSE
					GO TOP IN (m.lcRecordSource)
				ENDIF
			ELSE
				GO TOP IN (m.lcRecordSource)
			ENDIF
			Locate Rest For &lcSearchCommand
			If !Found()
				TRY
					GO RECORD (m.lnRecnoWas) IN (m.lcRecordSource)
				CATCH
					Go Top In (m.lcRecordSource)
				ENDTRY
				IF m.tlFindNext
					IF MESSAGEBOX("Search has reached the last record without finding another match. Do you want to continue searching from the first record?",36,"Continue Searching from the Beginning?") = 6
						Go Top In (m.lcRecordSource)
						Locate Rest For &lcSearchCommand
						IF !FOUND()
							MESSAGEBOX("A matching record could not be found.",64,"Unable to Locate Search Phrase")
							TRY
								GO RECORD (m.lnRecnoWas) IN (m.lcRecordSource)
							CATCH
								Go Top In (m.lcRecordSource)
							ENDTRY
						ENDIF
					ENDIF
				ELSE
					MESSAGEBOX("A matching record could not be found.",64,"Unable to Locate Search Phrase")
				ENDIF
			ENDIF
			*!* work around to allow highlighting/row update to show correctly in grid being searched as record pointer is moved
			m.llLockScreenWas = thisform.lockscreen
			thisform.lockscreen = .T.
			this.GridObject.setfocus()
			this.GridObject.refresh()
			this.SearchAndFilterForm.cmdSearch.setfocus()
			thisform.lockscreen = m.llLockScreenWas
			SELECT (m.lnSelectWas)
		Endif
	ENDPROC


	*-- INTERNAL USE: Returns the name of the internal cursor representing the combobox sent in.
	PROCEDURE getcombocursorname
		LPARAMETERS toComboBox
		LOCAL lnKeyIndex, lcTempCursorName
		IF VARTYPE(this.combocursorcollection) != "O"
			This.combocursorcollection = CREATEOBJECT("collection")
		ENDIF
		m.lcTempCursorName = ""
		m.lnKeyIndex = This.combocursorcollection.getkey(m.toComboBox.parent.name)
		IF m.lnKeyIndex = 0
			m.lcTempCursorName = SYS(2015)
			This.combocursorcollection.add(m.lcTempCursorName, m.toComboBox.parent.name)
		ELSE
			m.lcTempCursorName = This.combocursorcollection.Item(m.lnKeyIndex)
		ENDIF
		IF !USED(m.lcTempCursorName) AND !EMPTY(m.lcTempCursorName)
			this.createcombocursor(m.lcTempCursorName, m.toComboBox)
		ENDIF
		This.currentcombocursorname = m.lcTempCursorName
		RETURN m.lcTempCursorName
	ENDPROC


	*-- INTERNAL USE: Creates an internal cursor to hold the list items available in a column in the target grid.
	PROCEDURE createcombocursor
		LPARAMETERS tcTempCursorName, toComboBox

		LOCAL lnCounter, lcControlSourceType, lnSelectWas
		m.lnSelectWas = SELECT()
		CREATE CURSOR (m.tcTempCursorName) (disptext V(99), fkid V(99))
		FOR m.lnCounter = 1 TO m.toComboBox.listcount
			IF this.casesensitive
				INSERT INTO (m.tcTempCursorName) ;
				VALUES (m.toComboBox.list(m.lnCounter,1), m.toComboBox.list(m.lnCounter, m.toComboBox.boundcolumn))
			ELSE
				INSERT INTO (m.tcTempCursorName) ;
				VALUES (UPPER(m.toComboBox.list(m.lnCounter,1)), m.toComboBox.list(m.lnCounter, m.toComboBox.boundcolumn))
			ENDIF
		ENDFOR
		m.lcControlSourceType = TYPE(m.toComboBox.controlsource)
		IF !INLIST(m.lcControlSourceType, "C", "M")
			IF m.lcControlSourceType = "N"
				m.lcControlSourceType = m.lcControlSourceType + "(16,4)"
			ENDIF
			ALTER table (m.tcTempCursorName) ALTER COLUMN fkid &lcControlSourceType
		ENDIF
		SELECT(m.tcTempCursorName)
		INDEX on fkid TAG fkid

		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Creates a public reference to the _Screen. This is part of a workaround for a VFP bug where _Screen.A(1,1) will be normailzed as .A(1,1,_Screen) which causes Filter() to return an invalid filter string if _Screen were to be included.
	PROCEDURE createscreenreference
		IF TYPE("_GEScr") = "U"
			PUBLIC _GEScr
		ENDIF
		IF VARTYPE(_GEScr) != "O"
			_GEScr = _Screen
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to save column filters.
	PROCEDURE saveacolumnfilters
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas, lcGlobalArray
		LOCAL ARRAY _GEAColumn(1)
		LOCAL ARRAY _GEAGlobal(1)
		m.lnSelectWas = SELECT()
		m.lcGlobalArray = [_GEScr.] + this.GlobalArrayName
		IF This.TemplateLocate(m.tnTemplatePkID)
			=ACOPY(this.acolumnfilters, _GEAColumn)
			SAVE to Memo FilterCol ALL LIKE _GEAColumn
			=ACOPY(&lcGlobalArray, _GEAGlobal)
			SAVE to Memo FilterGlob ALL LIKE _GEAGlobal
			replace globala WITH this.globalarrayname
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used to save the custom column filters.
	PROCEDURE savecustomcolumnfilters
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas
		LOCAL ARRAY _GEACustom(1)
		m.lnSelectWas = SELECT()
		IF This.TemplateLocate(m.tnTemplatePkID)
			=ACOPY(this.customcolumnfilters, _GEACustom)
			SAVE to Memo FilterCust ALL LIKE _GEACustom
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used to save the column sort.
	PROCEDURE savecolumnsort
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas
		m.lnSelectWas = SELECT()
		IF TYPE("this.currentcolumn.name") = "C" AND TYPE("this.currentcolumn.header1.name") = "C" AND This.TemplateLocate(m.tnTemplatePkID)
			replace colname WITH this.currentcolumn.name, sortasc WITH This.CurrentColumn.Header1.Tag
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used by the grid templates screen to save a new template to the templates list (see templatetable property)
	PROCEDURE templatesave
		LPARAMETERS tcGridName, tcTemplateName
		LOCAL lnSelectWas, lnTemplatePkID
		m.lnSelectWas = SELECT()
		IF !This.TemplateLocate(m.tcGridName + ":" + m.tcTemplateName)
			APPEND BLANK
			replace template WITH m.tcTemplateName, gridname WITH m.tcGridName
			m.lnTemplatePkID = pkid
			this.saveacolumnfilters(m.lnTemplatePkID)
			this.savecustomcolumnfilters(m.lnTemplatePkID)
			this.savecolumnsort(m.lnTemplatePkID)
		ELSE
			m.lnTemplatePkID = pkid
			this.saveacolumnfilters(m.lnTemplatePkID)
			this.savecustomcolumnfilters(m.lnTemplatePkID)
			this.savecolumnsort(m.lnTemplatePkID)
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used by the grid templates screen when the user chooses to delete a selected template.
	PROCEDURE templatedelete
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas
		m.lnSelectWas = SELECT()
		IF This.TemplateLocate(m.tnTemplatePkID)
			DELETE
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used by the grid templates screen to apply a user selected template.
	PROCEDURE templateapply
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas, loActiveControlInColumn, llIsCombobox, llLockScreenWas, loHeaderObject, lcAscendingSort, llUseHeaderFilterImage
		m.lnSelectWas = SELECT()
		llUseHeaderFilterImage = .F.
		m.lcAscendingSort      = 'N'

		IF This.TemplateLocate(m.tnTemplatePkID)
			m.llLockScreenWas = thisform.LockScreen
			thisform.LockScreen = .T.
			This.ClearHeaderSortImages()
			This.RestoreColumnFilters(m.tnTemplatePkID)
			this.RestoreCustomColumnFilters(m.tnTemplatePkID)
			this.RestoreColumnSort(m.tnTemplatePkID, @m.lcAscendingSort)

			this.applyfilter()
			m.llIsCombobox = .F.
			IF TYPE("this.currentcolumn") = "O" AND TYPE("this.currentcolumn.currentcontrol") = "C" AND !EMPTY(this.currentcolumn.currentcontrol)
				m.loActiveControlInColumn = EVALUATE("this.currentcolumn." + this.currentcolumn.currentcontrol)
				IF LOWER(ALLTRIM(m.loActiveControlInColumn.Baseclass)) = "combobox"
					m.llIsCombobox = .T.
				ENDIF
				IF !this.applysort(m.llIsCombobox, this.currentcolumn, m.lcAscendingSort)
					m.lcAscendingSort = "N"
				ENDIF
			ENDIF
			this.setHeaderImages()
			IF TYPE("this.currentcolumn") = "O" AND TYPE("this.currentcolumn.currentcontrol") = "C" AND !EMPTY(this.currentcolumn.currentcontrol)
				m.loHeaderObject = this.currentcolumn.Controls(1)
				m.lcHeaderImage  = UPPER(JUSTFNAME(m.loHeaderObject.picture))
		        IF !EMPTY(m.lcHeaderImage) AND INLIST(m.lcHeaderImage,UPPER(This.HeaderFilterImage),UPPER(This.HeaderFilterDescendingImage),UPPER(This.HeaderFilterAscendingImage))	    
			      m.llUseHeaderFilterImage = .T.
			    ENDIF
				DO CASE
				  CASE m.lcAscendingSort = 'A' && Ascending
				      IF m.llUseHeaderFilterImage
			            m.loHeaderObject.Picture = This.HeaderFilterAscendingImage      && Show Filter Ascending Image
			          ELSE 
					    m.loHeaderObject.Picture = This.HeaderAscendingImage            && Ascending Sort Order
					  ENDIF   
					  
				  CASE m.lcAscendingSort = 'D' && Descending
				      IF m.llUseHeaderFilterImage
			            m.loHeaderObject.Picture = This.HeaderFilterDescendingImage     && Show Filter Descending Image
			          ELSE 
					    m.loHeaderObject.Picture = This.HeaderDescendingImage           && Descending Sort Order
					  ENDIF  
					  
				  OTHERWISE && Not Sort Order
				      IF m.llUseHeaderFilterImage
		  		        m.loHeaderObject.Picture = This.HeaderFilterImage               && Show Filter Image
		              ELSE 
		  		        m.loHeaderObject.Picture = ''                                   && No Sort Image (mothing)
		  		      ENDIF 
				ENDCASE 
			ENDIF
			thisform.LockScreen = m.llLockScreenWas
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used to restore the column filters that were saved as a template by the user.
	PROCEDURE restorecolumnfilters
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas, lnCounter, lcGlobalArrayNameWas, lcGlobalArrayNameIs, lcGlobalArray
		LOCAL ARRAY _GEAColumn(1)
		LOCAL ARRAY _GEAGlobal(1)
		m.lnSelectWas   = SELECT()
		m.lcGlobalArray = [_GEScr.] + this.GlobalArrayName
		IF This.TemplateLocate(m.tnTemplatePkID)
			RESTORE From Memo FilterCol ADDITIVE
			RESTORE From Memo FilterGlob ADDITIVE
			m.lcGlobalArrayNameWas = ALLTRIM(globala)
			m.lcGlobalArrayNameIs = this.globalarrayname
			FOR m.lnCounter = 1 TO ALEN(_GEAColumn, 1)
				IF TYPE("_GEAColumn(m.lnCounter, 1)") = "C"
					_GEAColumn(m.lnCounter, 1) = STRTRAN(_GEAColumn(m.lnCounter, 1), m.lcGlobalArrayNameWas, m.lcGlobalArrayNameIs, -1, -1, 1)
				ENDIF
			ENDFOR
			this.clearfilter()
			IF (ALEN(_GEAGlobal,1) > 0 AND ALEN(_GEAGlobal,2) > 0)
				DIMENSION &lcGlobalArray(ALEN(_GEAGlobal,1), ALEN(_GEAGlobal,2))
				=ACOPY(_GEAGlobal, &lcGlobalArray)
				IF (ALEN(_GEAColumn,1) > 0 AND ALEN(_GEAColumn,2) > 0)
					DIMENSION this.acolumnfilters(ALEN(_GEAColumn,1), ALEN(_GEAColumn,2))
					=ACOPY(_GEAColumn, this.acolumnfilters)
				ENDIF
			ELSE
				DIMENSION this.acolumnfilters(1, 3)
				STORE .F. TO this.acolumnfilters
			ENDIF
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used to restore the custom column filters that were saved as a template by the user.
	PROCEDURE restorecustomcolumnfilters
		LPARAMETERS tnTemplatePkID
		LOCAL lnSelectWas
		LOCAL ARRAY _GEACustom(1)
		m.lnSelectWas = SELECT()
		IF This.TemplateLocate(m.tnTemplatePkID)
			RESTORE From Memo FilterCusT ADDITIVE
			IF (ALEN(_GEACustom,1) > 0 AND ALEN(_GEACustom,2) > 0)
				DIMENSION this.customcolumnfilters(ALEN(_GEACustom,1),ALEN(_GEACustom,2))
				=ACOPY(_GEACustom, this.customcolumnfilters)
			ENDIF
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used to restore thecolumn sort that were saved as a template by the user.
	PROCEDURE restorecolumnsort
		LPARAMETERS tnTemplatePkID, tcSortAscending
		LOCAL lnSelectWas, loColumnObject
		m.lnSelectWas = SELECT()
		IF This.TemplateLocate(m.tnTemplatePkID) AND !EMPTY(colname)
			This.currentcolumn = EVALUATE("this.GridObject." + ALLTRIM(colname))
			m.tcSortAscending = SortAsc
		ENDIF
		SELECT (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Used by the grid templates screen to select the template table and locate the template that matches the user's selection.
	PROCEDURE templatelocate
		LPARAMETERS tnTemplatePkID
		LOCAL lcTemplateTable, lcTemplateTableJustStem, lcTemplateGrid, lcTemplateName, llReturn
		m.llReturn = .F.
		m.lcTemplateTable = EVALUATE(this.templatetable)
		m.lcTemplateTableJustStem = JUSTSTEM(m.lcTemplateTable)
		IF TYPE("m.lcTemplateTable") = "C" AND FILE(m.lcTemplateTable)
			IF !USED(m.lcTemplateTableJustStem)
				USE (m.lcTemplateTable) IN 0 SHARED
			ENDIF
			SELECT (m.lcTemplateTableJustStem)
			IF TYPE("m.tnTemplatePkID") = "N"
				m.llReturn = (m.tnTemplatePkID = EVALUATE( m.lcTemplateTableJustStem + ".pkid") OR SEEK(m.tnTemplatePkID, m.lcTemplateTableJustStem, "pkid"))
			ELSE
				IF TYPE("m.tnTemplatePkID") = "C"
					m.tnTemplatePkID = UPPER(ALLTRIM(m.tnTemplatePkID))
					m.lcTemplateGrid = GETWORDNUM(m.tnTemplatePkID, 1, ":")
					m.lcTemplateName = GETWORDNUM(m.tnTemplatePkID, 2, ":")
					m.llReturn = (UPPER(ALLTRIM(m.lcTemplateGrid)) == UPPER(ALLTRIM(gridname)) and ;
									 UPPER(ALLTRIM(m.lcTemplateName)) == UPPER(ALLTRIM(template)))
					IF !m.llReturn
						LOCATE FOR m.lcTemplateGrid == UPPER(ALLTRIM(gridname)) AND m.lcTemplateName == UPPER(ALLTRIM(template))
						m.llReturn = FOUND(m.lcTemplateTableJustStem)
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		RETURN m.llReturn
	ENDPROC


	*-- INTERNAL USE: Used to convert earlier versions of the gridextras.dbf.
	PROCEDURE checktemplatetable
		Local lnSelectWas, lcTemplateTable, lcTemplateAlias, llWasUsed
		m.lnSelectWas = Select()
		m.lcTemplateTable = EVALUATE(This.templatetable)
		If VARTYPE(m.lcTemplateTable) = "C" AND File(m.lcTemplateTable)
			m.llWasUsed = .T.
			m.lcTemplateAlias = Juststem(m.lcTemplateTable)
			If !Used(m.lcTemplateAlias)
				m.llWasUsed = .F.
				Use (m.lcTemplateTable) In 0 Shared
			Endif
			If Type(m.lcTemplateAlias + ".sortasc") = "L"
				Use In Select(m.lcTemplateAlias)
				Use (m.lcTemplateTable) In 0 Excl
				Alter Table (m.lcTemplateAlias) Alter Column sortasc C(1)
				Replace All sortasc With Icase(sortasc = "T", "A", sortasc = "F", "D", "N") In (m.lcTemplateAlias)
			ENDIF
			IF !m.llWasUsed
				Use In Select(m.lcTemplateAlias)
			ENDIF
		Endif
		Select (m.lnSelectWas)
	ENDPROC


	*-- INTERNAL USE: Binds the grid's MouseUp event so that the Parition preference can be saved.
	PROCEDURE bindgridevents
		LPARAMETERS toGridObject
		BINDEVENT(m.toGridObject, "MouseUp", This, "GridMouseUp", 1)
	ENDPROC


	*-- INTERNAL USE: Fires when the target grid's MouseUp event occurs.
	PROCEDURE gridmouseup
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		LOCAL lnLocationOut
		m.lnLocationOut = 0
		This.GridObject.GridHitTest(MCOL(0, 3), MROW(0, 3), @lnLocationOut)
		IF m.lnLocationOut = 5 && Split bar was probably moved, so we need to save partition
			This.savegridpreferences(this.GridObject)
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to set the header tag based on the order that the table comes in on.
	PROCEDURE setheadertag
		LPARAMETERS toColumnObject, toColumnHeader, tlTryAgain
		LOCAL lcParentTable, lcParentOrder, lcControlSource, lcParentField, loActiveControlInColumn, lnSelectWas

		m.lcParentTable = UPPER(toColumnObject.Parent.RecordSource)
		m.lcParentOrder = ORDER(m.lcParentTable)
		m.tlTryAgain    = .F.

		IF EMPTY(m.lcParentOrder)
		  RETURN 
		ENDIF   

		lnSelectWas       = SELECT()
		m.lcControlSource = UPPER(toColumnObject.ControlSource)
		m.lcParentField   = JUSTEXT(m.lcControlSource)
		m.tlTryAgain      = .T.

		IF m.lcParentTable != JUSTSTEM(m.lcControlSource) ;
		OR TAGNO(m.lcParentOrder) != TAGNO(m.lcParentField)
		  RETURN 
		ENDIF

		m.loActiveControlInColumn = EVALUATE('m.toColumnObject.'+m.toColumnObject.CurrentControl)
		IF LOWER(ALLTRIM(m.loActiveControlInColumn.BaseClass)) = "combobox"
		  RETURN 
		ENDIF

		m.tlTryAgain = .F.
		This.CurrentColumn = toColumnObject

		SELECT(m.lcParentTable)
		IF DESCENDING()
		  m.toColumnHeader.Tag     = 'D'
		  m.toColumnHeader.Picture = This.HeaderDescendingImage && Show Descending Image
		ELSE
		  m.toColumnHeader.Tag     = 'A'
		  m.toColumnHeader.Picture = This.HeaderAscendingImage && Show Ascending Image  
		ENDIF 

		SELECT (lnSelectWas)

		RETURN 
	ENDPROC


	*-- INTERNAL USE: Used by the grid templates screen when the user selects the blank in the templates combobox to clear any previously selected filters and sorts.
	PROCEDURE templateclear
		LOCAL loColumnObject, loHeaderObject
		WITH this
			DIMENSION .acolumnfilters(1, 3)
			STORE .F. TO .acolumnfilters
			DIMENSION .customcolumnfilters(1, 3)
			STORE .F. TO .customcolumnfilters
			.clearfilter()
			.applysort()
			FOR EACH loColumnObject IN .GridObject.columns
				m.loHeaderObject = m.loColumnObject.Controls(1)
				STORE '' TO  m.loHeaderObject.picture, m.loHeaderObject.Tag
			ENDFOR
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to display the Search/Filter form that is shown when the user clicks the context menu's "Search/Filter" item.
	PROCEDURE showsearchfilterform
		LPARAMETERS toHeaderObject

		IF thisform.ShowWindow = 2
			This.SearchAndFilterForm = CREATEOBJECT("GridSearchAndFilterTopLevel", m.toHeaderObject.parent, this)
		ELSE
			This.SearchAndFilterForm = CREATEOBJECT("GridSearchAndFilter", m.toHeaderObject.parent, this)
		ENDIF
		IF TYPE("This.SearchAndFilterForm.Caption") = "C"
			this.positionform(This.SearchAndFilterForm, m.toHeaderObject)
			This.SearchAndFilterForm.Show()
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to display the Columns form that is shown when the user clicks the context menu's "More..." item.
	PROCEDURE showcolumnsform
		IF thisform.ShowWindow = 2
			This.ColumnsForm = CREATEOBJECT("gridcolumnstoplevel", this.GridObject)
		ELSE
			This.ColumnsForm = CREATEOBJECT("gridcolumns", this.GridObject)
		ENDIF
		IF TYPE("This.ColumnsForm.Caption") = "C"
			This.ColumnsForm.Show(1)
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Copies the target grid out to an Excel document (XLS, XLSX, XLSM, and XLSB are supported).
	PROCEDURE copytoexcel
		#DEFINE ALPHANUMERICCHR "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz1234567890"
		LOCAL lnCounter, loColumn, lcXLSFile, lcSheetName, lcAliasWas, lcGridAlias, ;
			lcExcelFieldList, lcTableFieldList, loHeaderObject, ;
			lcFileName, lcAction, lcPath, loExcelApp, loWorkBook
		LOCAL ARRAY laFieldNames(1,2)

		m.lcXLSFile = This.GetMyDocumentsPath() + SYS(2015) + ".xls"
		m.lcXLSFile = PUTFILE("Exportar a Excel:", m.lcXLSFile, "XLS;XLSX;XLSM;XLSB")
		IF !EMPTY(m.lcXLSFile)
			m.lcAliasWas = ALIAS()
			m.lcGridAlias = THIS.GridObject.RECORDSOURCE

			m.lcSheetName = "Hoja1"
			STORE "" TO m.lcExcelFieldList, m.lcTableFieldList
			DIMENSION laFieldNames(THIS.GridObject.COLUMNCOUNT,2)
			FOR m.lnCounter = 1 TO THIS.GridObject.COLUMNCOUNT
				m.loColumn = THIS.GridObject.COLUMNS(m.lnCounter)
				IF m.loColumn.VISIBLE AND m.loColumn.WIDTH > 0
					m.loHeaderObject = m.loColumn.CONTROLS(1)
					laFieldNames(m.loColumn.columnorder, 1) = m.loColumn.CONTROLSOURCE
					laFieldNames(m.loColumn.columnorder, 2) = ALLTRIM(CHRTRAN(m.loHeaderObject.CAPTION,CHRTRAN(m.loHeaderObject.CAPTION,ALPHANUMERICCHR,""),""))
				ENDIF
			ENDFOR

			FOR m.lnCounter = 1 TO ALEN(laFieldNames,1)
				IF !EMPTY(laFieldNames(m.lnCounter,1)) AND !EMPTY(laFieldNames(m.lnCounter,2))
					m.lcExcelFieldList = m.lcExcelFieldList + IIF(!EMPTY(m.lcExcelFieldList), ',', '') ;
						+ laFieldNames(m.lnCounter,2)
					m.lcTableFieldList = m.lcTableFieldList + IIF(!EMPTY(m.lcTableFieldList), ',', '') ;
						+ laFieldNames(m.lnCounter,1)
				ENDIF
			ENDFOR

			IF ATC("GRIDEXTRASPROCS", SET("Procedure")) < 1
				SET PROCEDURE TO gridextrasprocs additive
			ENDIF

			CopyToExcel(m.lcXLSFile, m.lcSheetName, m.lcGridAlias, m.lcExcelFieldList, m.lcTableFieldList, FILTER(m.lcGridAlias))

			IF FILE(m.lcXLSFile)
				m.lcFileName = JUSTFNAME(m.lcXLSFile)
				IF MESSAGEBOX('El archvo ' + m.lcFileName + CHR(13) + 'fue exportado exitosamente.' + CHR(13) +;
						'Desea abrirlo ahora?',36,'EXPORTACION A EXCEL EXITOSA') = 6
					TRY
						m.loExcelApp = CREATEOBJECT("EXCEL.APPLICATION")
						m.loWorkBook = m.loExcelApp.Workbooks.OPEN(m.lcXLSFile)
						m.loExcelApp.VISIBLE = .T.
					CATCH
						MESSAGEBOX("El sistema encontro un problema al momento de abrir el documento de Excel.",64,"Ocurrio un problema")
					ENDTRY
				ENDIF
			ENDIF
			IF m.lcAliasWas != ALIAS() AND USED(m.lcAliasWas)
				SELECT (m.lcAliasWas)
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE showtemplatesform
		LOCAL lcReturnError

		m.lcReturnError = This.TemplateCreateTable()

		IF EMPTY(m.lcReturnError)
			IF thisform.ShowWindow = 2
				This.GridTemplatesForm = CREATEOBJECT("GridTemplatesTopLevel", thisform, this.GridObject, this)
			ELSE
				This.GridTemplatesForm = CREATEOBJECT("GridTemplates", thisform, this.GridObject, this)
			ENDIF
			IF TYPE("This.GridTemplatesForm.Caption") = "C"
				This.GridTemplatesForm.Show(1)
			ENDIF
		ENDIF

		RETURN (m.lcReturnError)
	ENDPROC


	PROCEDURE copytoreport
		Lparameters tcFRXName, tnOrientation, tnPaperSize, tnScale

		*************************************************************
		**
		**	tnOrientation : 0 = Portrait, 1 = Landscape
		**  tnPaperSize   : 1 = Letter, 5 = Legal
		**  tnScale       : 1 = 100%
		**
		*************************************************************
		Local loGrid As Grid
		Local loColumn As Column
		Local loField As TextBox
		Local loControl As Header
		Local loForm As Form
		Local lnLeft, lnTop, lnMaxHeight, lnPageWidth
		Local loReport As SFReportFile Of SFRepObj/SFRepObj.vcx
		Local loText   As SFReportText Of SFRepObj/SFRepObj.vcx
		Local loField  As SFReportText Of SFRepObj/SFRepObj.vcx
		Local loDetail As SFReportBand Of SFRepObj/SFRepObj.vcx
		Local loPageHeader As SFReportBand Of SFRepObj/SFRepObj.vcx
		Local lcUniqueCursorName, lnSelect

		m.tcFRXName     = Evl(m.tcFRXName, This.GridReportFile)
		m.tnOrientation = Evl(m.tnOrientation, 1)
		m.tnScale       = Evl(m.tnScale, 1)
		m.tnPaperSize   = Evl(m.tnPaperSize, 1)
		m.lcUniqueCursorName = SYS(2015)
		DO WHILE USED(m.lcUniqueCursorName)
			m.lcUniqueCursorName = SYS(2015)
		ENDDO
		m.loGrid = This.GridObject

		m.lnSelect = Select(0)

		Create Cursor (m.lcUniqueCursorName) ;
			( Expr			m, ;
			TYPE			c(1), ;
			TOP			i, ;
			LEFT			i, ;
			WIDTH			i, ;
			HEIGHT		i, ;
			ORDER			i, ;
			FONTNAME		v(150), ;
			FONTSIZE		i, ;
			FontStyle		i, ;
			FORECOLOR		i, ;
			BACKCOLOR		i, ;
			INPUTMASK		v(100), ;
			ALIGNMENT		i, ;
			CAPTION			v(150), ;
			CaptionFontName	v(150), ;
			CaptionFontSize	i, ;
			CaptionFontStyle	i, ;
			CaptionForeColor	i, ;
			CaptionBackColor	i, ;
			CaptionAlignment	i)

		For Each m.loColumn In m.loGrid.Columns FoxObject
			IF TYPE("m.loColumn.Width")="N" AND m.loColumn.Width=0
				LOOP
			ENDIF
			IF TYPE("m.loColumn.Visible")="L" AND !m.loColumn.Visible
				LOOP
			ENDIF
		  	SELECT (m.lcUniqueCursorName)
			Scatter Memo Name m.loData Blank
			With m.loData
				.Order = m.loColumn.ColumnOrder
				.Width = m.loColumn.Width

				.Expr = m.loColumn.ControlSource
				.FontName = m.loColumn.FontName
				.FontSize = m.loColumn.FontSize
				.FontStyle = 0
				.FontStyle = .FontStyle + Iif(m.loColumn.FontBold, 1, 0)
				.FontStyle = .FontStyle + Iif(m.loColumn.FontItalic, 2, 0)
				.FontStyle = .FontStyle + Iif(m.loColumn.FontUnderline, 4, 0)
				.FontStyle = .FontStyle + Iif(m.loColumn.FontStrikethru, 8, 0)
				.ForeColor = m.loColumn.ForeColor
				.BackColor = m.loColumn.BackColor
				.Alignment = m.loColumn.Alignment
				.InputMask = m.loColumn.InputMask

				For Each m.loControl In m.loColumn.Controls FoxObject
					Do Case
					Case m.loControl.BaseClass = "Header"
						.Caption = m.loControl.Caption
						.CaptionFontName = m.loControl.FontName
						.CaptionFontSize = m.loControl.FontSize
						.CaptionFontStyle = 0
						.CaptionFontStyle = .CaptionFontStyle + Iif(m.loControl.FontBold, 1, 0)
						.CaptionFontStyle = .CaptionFontStyle + Iif(m.loControl.FontItalic, 2, 0)
						.CaptionFontStyle = .CaptionFontStyle + Iif(m.loControl.FontUnderline, 4, 0)
						.CaptionFontStyle = .CaptionFontStyle + Iif(m.loControl.FontStrikethru, 8, 0)
						.CaptionForeColor = m.loControl.ForeColor
						.CaptionBackColor = m.loControl.BackColor
						.CaptionAlignment = m.loControl.Alignment

					Case m.loColumn.Sparse = .F. And m.loControl.Name = m.loColumn.CurrentControl AND TYPE("m.loControl.InputMask") = "C"
						.Expr = m.loControl.ControlSource
						.FontName = m.loControl.FontName
						.FontSize = m.loControl.FontSize
						.FontStyle = 0
						.FontStyle = .FontStyle + Iif(m.loControl.FontBold, 1, 0)
						.FontStyle = .FontStyle + Iif(m.loControl.FontItalic, 2, 0)
						.FontStyle = .FontStyle + Iif(m.loControl.FontUnderline, 4, 0)
						.FontStyle = .FontStyle + Iif(m.loControl.FontStrikethru, 8, 0)
						.ForeColor = m.loControl.ForeColor
						.BackColor = m.loControl.BackColor
						.Alignment = m.loControl.Alignment
						.InputMask = m.loControl.InputMask
					Endcase
				Endfor
				.Type = Type(.Expr)
				.Height = Fontmetric(1, .FontName, .FontSize)

				If m.tnScale <> 1
					.FontSize = Round(.FontSize * m.tnScale, 0)
					.Height = Round(.Height * m.tnScale, 0)
					.Width = Round(.Width * m.tnScale, 0)
					.CaptionFontSize = Round(.CaptionFontSize*m.tnScale, 0)
				Endif

			Endwith
			Insert Into (m.lcUniqueCursorName) From Name m.loData
		Endfor

		Index On Order Tag Order
		Go Top
		m.lnLeft = 0
		m.lnTop = 0
		m.lnMaxHeight = Height

		Do Case
		Case m.tnOrientation = 0
			m.lnPageWidth = 8*96
		Case m.tnPaperSize = 1		&& Letter
			m.lnPageWidth = 10.5*96
		Case m.tnPaperSize = 5		&& Legal
			m.lnPageWidth = 13.5*96
		Otherwise
			m.lnPageWidth = 8*96
		Endcase

		Scan
			If m.lnLeft+Width > m.lnPageWidth And m.lnLeft <> 0
				m.lnTop = m.lnTop + m.lnMaxHeight + 5
				m.lnLeft = 0
				m.lnMaxHeight = Height
			Endif
			Replace ;
				LEFT        With m.lnLeft, ;
				TOP         With m.lnTop, ;
				FORECOLOR   With Iif(ForeColor=0,-1,ForeColor), ;
				BACKCOLOR   With Iif(BackColor=Rgb(255,255,255),-1,BackColor), ;
				CaptionForeColor With Iif(CaptionForeColor=0,-1,CaptionForeColor)
			m.lnLeft = m.lnLeft + Width + 5
			m.lnMaxHeight = Max(m.lnMaxHeight, Height)
		Endscan

		m.loReport = Newobject('SFReportFile', 'SFRepObj')
		m.loReport.cReportFile  = m.tcFRXName
		m.loReport.cUnits = "I"
		m.loReport.cFontName = 'Arial'
		m.loReport.nOrientation = m.tnOrientation
		m.loReport.nPaperSize = m.tnPaperSize


		m.loPageHeader = loReport.GetReportBand('Page Header')
		m.loPageHeader.nHeight = 0

		m.loDetail = loReport.GetReportBand('Detail')
		m.loDetail.nHeight = 0

		m.loText = loPageHeader.AddItem('Text')

		m.loForm = m.loGrid.Parent
		Do While TYPE("m.loForm.Caption") != "C" && loForm.BaseClass <> "Form" And Vartype(m.loForm.Parent)="O"
			m.loForm = m.loForm.Parent
		Enddo

		m.loText.cExpression = m.loForm.Caption
		m.loText.nVPosition  = 0.1
		m.loText.nHPosition  = 0.1
		m.loText.nFontSize   = 18
		m.loText.lFontBold   = .T.
		m.lnMaxBottom = 0

		SELECT(m.lcUniqueCursorName)
		Scan All
			m.lcAlign = "left"
			Do Case
			Case Alignment = 3
				If Type$"NYIFBDT"
					m.lcAlign = "right"
				Else
					m.lcAlign = "left"
				Endif
			Case Alignment = 0
				m.lcAlign = "left"
			Case Alignment = 1
				m.lcAlign = "center"
			Case Alignment = 2
				m.lcAlign = "right"
			Endcase
			m.loText = loPageHeader.AddItem('Text')
			m.loText.cExpression = Caption
			m.loText.nVPosition  = (Top/96) + 0.50
			m.loText.nHPosition  = (Left/96) + 0.125
			m.loText.nWidth      = (Width+2)/96
			m.loText.cFontName   = CaptionFontName
			m.loText.nFontSize   = CaptionFontSize
			m.loText.lFontBold   = Bitand(CaptionFontStyle,1)=1
			m.loText.lFontItalic = Bitand(CaptionFontStyle,2)=2
			m.loText.nForeColor  = CaptionForeColor
			m.loText.cAlignment  = m.lcAlign

			m.lnMaxBottom = (Top/96) + 0.50 + (Height/96)

			m.loField = loDetail.AddItem('Field')
			m.loField.cExpression = Expr
			m.loField.nWidth      = (Width+2)/96
			m.loField.nVPosition  = (Top/96) + 0.125
			m.loField.nHPosition  = (Left-1)/96 + 0.125
			m.loField.cFontName   = FontName
			m.loField.nFontSize   = FontSize
			m.loField.lFontBold   = Bitand(FontStyle,1)=1
			m.loField.lFontItalic = Bitand(FontStyle,2)=2
			m.loField.nForeColor  = ForeColor
			m.loField.cAlignment  = m.lcAlign
			m.loField.cDataType   = Icase(Type$"NYIFB","N", Type$"DT", "D", "C")
			m.loField.cPicture    = InputMask
			m.loField.cDesignCaption = Caption
		Endscan

		m.loObject = loPageHeader.AddItem('Line')
		m.loObject.nWidth     = m.lnPageWidth/96
		m.loObject.nVPosition = m.lnMaxBottom
		m.loObject.nHPosition = 0
		m.loObject.nPenSize   = 1
		m.loObject.nForeColor = Rgb(0, 0, 128)
		IF FILE(m.tcFRXName)
			ERASE (m.tcFRXName)
		ENDIF
		m.loReport.Save()

		IF FILE(m.tcFRXName)
			TRY
				Select (m.loGrid.RecordSource)
				REPORT FORM (m.tcFRXName) TO PRINTER PROMPT PREVIEW
				IF FILE(m.tcFRXName)
					ERASE (m.tcFRXName)
				ENDIF
			CATCH
				*!* Handle the error however you wish here
			ENDTRY
		ENDIF

		Select(m.lnSelect)
	ENDPROC


	*-- This method is called to create the gridextras template table.
	PROCEDURE templatecreatetable
		*************************************
		*!* This method and the following properties allow the
		*!* class to create the template storage table if it does not exist.
		*************************************

		LOCAL lcReturnError, lcTableCodePage, lcTableFree, lcTemplateTable, lcTemplateTableJustStem, loException AS EXCEPTION

		m.lcReturnError = ""
		m.lcTemplateTable = EVALUATE(THIS.TemplateTable)

		IF !FILE(m.lcTemplateTable)
			m.lcTemplateTableJustStem = JUSTSTEM(m.lcTemplateTable)
			DIMENSION laCodePage[2,26]
			laCodePage[1,01] = 437
			laCodePage[2,01] = [U.S. MS-DOS]
			laCodePage[1,02] = 620
			laCodePage[2,02] = [Mazovia (Polish) MS-DOS]
			laCodePage[1,03] = 737
			laCodePage[2,03] = [Greek MS-DOS (437G)]
			laCodePage[1,04] = 850
			laCodePage[2,04] = [International MS-DOS]
			laCodePage[1,05] = 852
			laCodePage[2,05] = [Eastern European MS-DOS]
			laCodePage[1,06] = 857
			laCodePage[2,06] = [Turkish MS-DOS]
			laCodePage[1,07] = 861
			laCodePage[2,07] = [Icelandic MS-DOS]
			laCodePage[1,08] = 865
			laCodePage[2,08] = [Nordic MS-DOS]
			laCodePage[1,09] = 866
			laCodePage[2,09] = [Russian MS-DOS]
			laCodePage[1,10] = 874
			laCodePage[2,10] = [Thai Windows]
			laCodePage[1,11] = 895
			laCodePage[2,11] = [Kamenicky (Czech) MS-DOS]
			laCodePage[1,12] = 932
			laCodePage[2,12] = [Japanese Windows]
			laCodePage[1,13] = 936
			laCodePage[2,13] = [Chinese Simplified (PRC, Singapore) Windows]
			laCodePage[1,14] = 949
			laCodePage[2,14] = [Korean Windows]
			laCodePage[1,15] = 950
			laCodePage[2,15] = [Traditional Chinese (Hong Kong SAR, Taiwan) Windows]
			laCodePage[1,16] = 1250
			laCodePage[2,16] = [Eastern European Windows]
			laCodePage[1,17] = 1251
			laCodePage[2,17] = [Russian Windows]
			laCodePage[1,18] = 1252
			laCodePage[2,18] = [Windows ANSI]
			laCodePage[1,19] = 1253
			laCodePage[2,19] = [Greek Windows]
			laCodePage[1,20] = 1254
			laCodePage[2,20] = [Turkish Windows]
			laCodePage[1,21] = 1255
			laCodePage[2,21] = [Hebrew Windows]
			laCodePage[1,22] = 1256
			laCodePage[2,22] = [Arabic Windows]
			laCodePage[1,23] = 10000
			laCodePage[2,23] = [Standard Macintosh]
			laCodePage[1,24] = 10006
			laCodePage[2,24] = [Greek Macintosh]
			laCodePage[1,25] = 10007
			laCodePage[2,25] = [Russian Macintosh]
			laCodePage[1,26] = 10029
			laCodePage[2,26] = [Macintosh EE]

			IF EMPTY(THIS.TemplateTableCodePage)
				m.lcTableCodePage = SPACE(0)
			ELSE
			*!* Verify the code page numeric
				IF VARTYPE(THIS.TemplateTableCodePage) = "C"
					TRY
						THIS.TemplateTableCodePage = VAL(THIS.TemplateTableCodePage)
					CATCH TO m.loException
						THIS.TemplateTableCodePage = 0
					ENDTRY
				ENDIF

			*!* Verify the code page is valid
				lnRow = ASCAN(laCodePage, THIS.TemplateTableCodePage)

				IF lnRow > 0
					m.lcTableCodePage = " CODEPAGE = " + ;
						TRANSFORM(THIS.TemplateTableCodePage) + ;
						SPACE(1)
				ELSE
					m.lcTableCodePage = SPACE(0)
				ENDIF
			ENDIF

			IF THIS.TemplateTableFree
				m.lcTableFree = " FREE "
			ELSE
				IF EMPTY(SET("Database"))
			*!* No database selected so we have to make it free
					m.lcTableFree = " FREE "
				ELSE
					m.lcTableFree = SPACE(0)
				ENDIF
			ENDIF

			TRY
				CREATE TABLE (m.lcTemplateTable) &lcTableFree &lcTableCodePage ;
					(PkID        I NOT NULL AUTOINC NEXTVALUE 1 STEP 1, ;
					Template    C(50), ;
					GridName    C(254), ;
					SortAsc     C(1), ;
					ColName     C(50), ;
					filtercust  M, ;
					filtercol   M, ;
					filterglob  M, ;
					globala     C(10))

			*!* Create indexes, which returns any error message to be returned
			*!* from this method to the calling method.
				m.lcReturnError = m.lcReturnError + THIS.TemplateCreateIndex()

			*!* Close and reopen in shared mode
				USE IN (SELECT(m.lcTemplateTableJustStem))

				IF TYPE("m.lcTemplateTable") = "C" AND FILE(m.lcTemplateTable)
					USE (m.lcTemplateTable) IN 0 SHARED
					SELECT (m.lcTemplateTableJustStem)
				ENDIF

			CATCH TO m.loException
				m.lcReturnError = m.lcReturnError ;
					+ m.loException.MESSAGE ;
					+ " (" + TRANSFORM(m.loException.ERRORNO) + ") in " ;
					+ LOWER(PROGRAM()) + " on " + TRANSFORM(m.loException.LINENO)
			ENDTRY
		ENDIF

		RETURN (m.lcReturnError)
	ENDPROC


	*-- This method is called to create the index tag(s) for the gridextras template table.
	PROCEDURE templatecreateindex
		***************************************
		*!* This method is used to reindex the template table.
		*!* It is designed to be called when table is created or
		*!* independently in the development environment if the index is corrupted.
		*!* It is assumed developer will account for the index in their own application
		*!* reindexing routine.
		***************************************

		LOCAL lcReturnError, lcTemplateTableJustStem, loException AS EXCEPTION, lcCollateSequence, lcOldCollate

		m.lcTemplateTable = EVALUATE(THIS.TemplateTable)
		m.lcTemplateTableJustStem = JUSTSTEM(m.lcTemplateTable)
		m.lcCollateSequence = UPPER(THIS.TemplateIndexCollateSequence)
		m.lcReturnError = ""

		*!* Verify valid collation sequence set
		IF INLIST(m.lcCollateSequence, ;
				[ARABIC],[CZECH],[DUTCH],[GENERAL],[GERMAN],[GREEK],[HEBREW],[HUNGARY], ;
				[ICELAND],[JAPANESE],[KOREAN],[MACHINE],[NORDAN],[PINYIN],[POLISH],[RUSSIAN], ;
				[SLOVAK],[SPANISH],[STROKE],[SWEFIN],[THAI],[TURKISH],[UNIQWT])
		*!* All is well - valid selection made
		ELSE
		*!* Illegal one set - default to VFP default
			THIS.TemplateIndexCollateSequence = "MACHINE"
		ENDIF

		m.lcCollateSequence = UPPER(THIS.TemplateIndexCollateSequence)

		*!* If the developer does not pick a valid collation for the DBF code page VFP will
		*!* trigger an error #1915 (Collating sequence "name" is not found). We have left this
		*!* responsibility to the developer since most won't be changing from Machine anyway
		*!* based on the fact the only index is numeric.
		TRY
			m.lcOldCollate = SET("Collate")
			SET COLLATE TO (lcCollateSequence)
			SELECT (m.lcTemplateTableJustStem)
			DELETE TAG ALL
			INDEX ON PkID TAG PkID
			SET COLLATE TO (lcOldCollate)
		CATCH TO m.loException
			m.lcReturnError = m.lcReturnError + m.loException.MESSAGE ;
				+ " (" + TRANSFORM(m.loException.ERRORNO) + ") in " ;
				+ LOWER(PROGRAM()) + " on " + TRANSFORM(m.loException.LINENO)
		ENDTRY

		RETURN (m.lcReturnError)
	ENDPROC


	PROCEDURE showhidecolumn
		LPARAMETERS toColumn

		LOCAL loColumn, llTargetColumnVisible, lnVisibleColumnsFound

		IF TYPE("m.toColumn.name") = "C"
			m.llTargetColumnVisible = m.toColumn.Visible
			IF m.llTargetColumnVisible && user is trying to make column invisible
				m.lnVisibleColumnsFound = 0
		*!* Check to ensure that the user isn't about to make all of the columns invisible
		*!* Doing so would essentially lock them out of being able to make any of the columns
		*!* visible again because they wouldn't be able to get to the right-click context menu again.
				FOR EACH loColumn IN This.GridObject.Columns
					IF m.loColumn.Visible
						m.lnVisibleColumnsFound = m.lnVisibleColumnsFound + 1
					ENDIF
					IF m.lnVisibleColumnsFound > 1 && User will still have at least one visible column
						m.toColumn.Visible = !m.toColumn.Visible
						EXIT
					ENDIF
				NEXT
			ELSE && user is trying to make column visible
				m.toColumn.Visible = !m.toColumn.Visible
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE getmydocumentspath
		#DEFINE CSIDL_PERSONAL 0x0005
		LOCAL lcFolderPath, lcDocumentsPath
		m.lcFolderPath = space(255)

		DECLARE SHORT SHGetFolderPath IN SHFolder.dll ; 
		    INTEGER hwndOwner, INTEGER nFolder, INTEGER hToken, ; 
		    INTEGER dwFlags, STRING @pszPath 

		SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, @m.lcFolderPath)

		m.lcDocumentsPath = Alltrim(m.lcFolderPath)

		m.lcDocumentsPath = SubStr(m.lcDocumentsPath,1, Len(m.lcDocumentsPath) - 1)
		RETURN ADDBS(m.lcDocumentsPath)
	ENDPROC


	PROCEDURE Destroy
		LOCAL lnSelectWas, lcCursorName
		TRY
			UNBINDEVENTS(THIS)
			IF VARTYPE(THIS.GridObject)="O"
				UNBINDEVENTS(THIS.GridObject)
			ENDIF
			REMOVEPROPERTY(_SCREEN, THIS.GlobalArrayName)
			USE IN SELECT(THIS.GlobalArrayName)
			UNBINDEVENTS(0)
			IF FILE(THIS.IndexFile)
				m.lnSelectWas = SELECT()
				SELECT (THIS.PARENTTABLE)
				SET INDEX TO
				ERASE (THIS.IndexFile)
				SELECT (m.lnSelectWas)
			ENDIF
			IF VARTYPE(THIS.combocursorcollection) = "O"
				FOR EACH m.lcCursorName IN THIS.combocursorcollection
					IF VARTYPE(m.lcCursorName) = "C" AND USED(m.lcCursorName)
						USE IN SELECT(m.lcCursorName)
					ENDIF
				NEXT
			ENDIF
			STORE NULL TO THIS.GridObject, THIS.CurrentColumn, THIS.ColumnObject, This.SearchAndFilterForm
			STORE NULL TO THIS.GridTemplatesImage, THIS.ComboCursorCollection, this.GridTemplatesForm, This.ColumnsForm
		CATCH
		ENDTRY
	ENDPROC


	PROCEDURE Init
		This.GlobalArrayName = SYS(2015)
		ADDPROPERTY(_screen, this.GlobalArrayName+"[1,1]",.F.)
		THIS.indexfile = ADDBS(SYS(2023)) + This.GlobalArrayName + ".IDX"
		This.CheckTemplateTable()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridextra
**************************************************


**************************************************
*-- Class:        gridextratemplates (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  image
*-- BaseClass:    image
*-- Time Stamp:   12/15/08 11:35:12 AM
*
DEFINE CLASS gridextratemplates AS image


	Anchor = 12
	Picture = "table_sql_view16.png"
	Stretch = 1
	Height = 16
	Visible = .F.
	Width = 18
	*-- INTERNAL USE: Holds a reference to the target grid.
	gridobject = .NULL.
	*-- INTERNAL USE: Holds a reference to the GridExtra class instance that added this image to the form, container, or page that the target grid resides in.
	gridextrasobject = .NULL.
	*-- INTERNAL USE: Holds a reference to the Grid Templates form class (GridUtils) so that it doesn't go out of scope when created.
	gridutils = .NULL.
	Name = "gridextratemplates"


	*-- INTERNAL USE: Bound to the target grid's zorder property to ensure that this image stays visible and doesn't end up hidden behind the target grid it is meant to provide the template features for.
	PROCEDURE zorderupdate
		LPARAMETERS tnzOrder
		this.zorder(0)
	ENDPROC


	*-- INTERNAL USE: Bound to the target grid's resize event to ensure that this image stays in the proper position at the bottom left of the target grid.
	PROCEDURE resizeupdate
		LOCAL lnAnchorWas
		m.lnAnchorWas = this.Anchor
		this.Anchor = 0
		this.Left = (This.GridObject.Left + This.GridObject.Width - 19)
		IF INLIST(This.GridObject.scrollbars, 0, 2)
			this.Top = (This.GridObject.Top + This.GridObject.Height + 1)
		ELSE
			this.Top = (This.GridObject.Top + This.GridObject.Height - 18)
		ENDIF
		this.Anchor = m.lnAnchorWas
		this.ZOrder(0)
	ENDPROC


	PROCEDURE Click
		this.gridextrasobject.ShowTemplatesForm()
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toGridExtras
		this.gridextrasobject = m.toGridExtras
		this.ZOrder(0)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridextratemplates
**************************************************


**************************************************
*-- Class:        gridsearchandfilter (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   05/01/14 04:12:14 PM
*
DEFINE CLASS gridsearchandfilter AS form


	BorderStyle = 3
	Top = 0
	Left = 0
	Height = 382
	Width = 228
	Desktop = .T.
	DoCreate = .T.
	ShowTips = .T.
	Caption = ""
	ControlBox = .F.
	Closable = .F.
	MaxButton = .F.
	MinButton = .F.
	Movable = .F.
	TitleBar = 0
	WindowType = 0
	AlwaysOnTop = .T.
	BackColor = RGB(255,255,255)
	*-- INTERNAL USE: Holds a reference to the target column.
	columnobject = "NULL"
	*-- INTERNAL USE: Holds a unique (unused) cursor name that this class uses to create the recordsource for the filter selection grid.
	uniquecursorname = ""
	*-- INTERNAL USE: Holds a reference to the GridExtra class instance that called this form.
	gridextraobject = "NULL"
	*-- INTERNAL USE: Holds a reference to the value for the target column's controlsource.
	columncontrolsource = ""
	*-- INTERNAL USE: Holds a reference to the target grid's recordsource value.
	gridrecordsource = ""
	*-- INTERNAL USE: Determines what character(s) are used to delineate filter selection values. This ensures that "cap" doesn't match "cape" regardless of Exact and Ansi settings by making them "||cap||" and "||cape||" for instance.
	delimiter = "||"
	*-- INTERNAL USE: Has the same value as the GlobalArrayName property of the GridExtra class. The global array is an array property added to the _screen that stores the filter strings so that we don't need to worry about scope.
	globalarrayname = .F.
	*-- INTERNAL USE: Used to tell the class where (index/row) within the CustomColumnFilters array property of the GridExtra class instance that called this form the custom filter should be saved.
	indexcustomcolumnfilter = 0
	*-- INTERNAL USE: Used by the incremental search feature to find the next matching record within the target grid's recordsource.
	findnext = .F.
	*-- INTERNAL USE: Determines whether or not this form should be be released when the deactivate even fires.
	rundeactivaterelease = .T.
	*-- INTERNAL USE: Used to tell the class whether the mouse (cursor) is within the boundaries of the Search/Filter form or not.
	_inform = .T.
	*-- INTERNAL USE: Used to tell the class whether the form is fading or not.
	_infademode = .T.
	*-- INTERNAL USE: Used to facilitate the opacity of the fade as it is fading in or out.
	_fade = 255
	*-- INTERNAL USE: Holds the SECONDS since midnight when the last user interaction with this form occurred. Ensures that fading of the form will not occur while the user is actively using the form. See the FadeWait property of the GridExtra class.
	lastuseraction = 0
	Name = "gridsearchandfilter"


	ADD OBJECT image1 AS image WITH ;
		Anchor = 3, ;
		Picture = "..\..\grafgen\iconos\showfilters16.bmp", ;
		Height = 16, ;
		Left = 5, ;
		Top = 33, ;
		Width = 16, ;
		Name = "Image1"


	ADD OBJECT lblmore AS label WITH ;
		AutoSize = .F., ;
		Anchor = 3, ;
		BackStyle = 0, ;
		Caption = "Mas...", ;
		Height = 17, ;
		Left = 24, ;
		Top = 33, ;
		Width = 38, ;
		TabIndex = 10, ;
		ForeColor = RGB(128,128,255), ;
		Name = "lblMore"


	ADD OBJECT shpsplitter AS shape WITH ;
		Top = 54, ;
		Left = -4, ;
		Height = 1, ;
		Width = 235, ;
		Anchor = 11, ;
		SpecialEffect = 0, ;
		Name = "shpSplitter"


	ADD OBJECT check1 AS checkbox WITH ;
		Top = 142, ;
		Left = 5, ;
		Height = 17, ;
		Width = 113, ;
		Anchor = 3, ;
		AutoSize = .T., ;
		Alignment = 0, ;
		BackStyle = 0, ;
		Caption = " Seleccionar todo", ;
		Value = .T., ;
		TabIndex = 6, ;
		ForeColor = RGB(128,128,255), ;
		Name = "Check1"


	ADD OBJECT grid1 AS grid WITH ;
		ColumnCount = 2, ;
		AllowHeaderSizing = .F., ;
		AllowRowSizing = .F., ;
		DeleteMark = .F., ;
		GridLines = 0, ;
		HeaderHeight = 0, ;
		Height = 182, ;
		Highlight = .F., ;
		HighlightRow = .F., ;
		HighlightRowLineWidth = 0, ;
		Left = -1, ;
		RecordMark = .F., ;
		ScrollBars = 2, ;
		SplitBar = .F., ;
		TabIndex = 7, ;
		Top = 165, ;
		Width = 230, ;
		Name = "Grid1", ;
		Column1.Width = 23, ;
		Column1.Resizable = .F., ;
		Column1.Sparse = .F., ;
		Column1.Name = "Column1", ;
		Column2.Width = 183, ;
		Column2.Resizable = .F., ;
		Column2.ReadOnly = .T., ;
		Column2.Name = "Column2"


	ADD OBJECT gridsearchandfilter.grid1.column1.header1 AS header WITH ;
		Caption = "Header1", ;
		Name = "Header1"


	ADD OBJECT gridsearchandfilter.grid1.column1.check1 AS checkbox WITH ;
		Top = 11, ;
		Left = 12, ;
		Height = 17, ;
		Width = 60, ;
		Alignment = 0, ;
		Centered = .T., ;
		Caption = "", ;
		Name = "Check1"


	ADD OBJECT gridsearchandfilter.grid1.column2.header1 AS header WITH ;
		Caption = "Header1", ;
		Name = "Header1"


	ADD OBJECT gridsearchandfilter.grid1.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT gridcustomfilter1 AS gridcustomfilter WITH ;
		Anchor = 3, ;
		Top = 60, ;
		Left = 4, ;
		TabIndex = 5, ;
		Name = "Gridcustomfilter1", ;
		Combo1.Left = 1, ;
		Combo1.Name = "Combo1", ;
		Text1.Height = 23, ;
		Text1.Left = 21, ;
		Text1.Top = 27, ;
		Text1.Width = 170, ;
		Text1.Name = "Text1", ;
		Text2.Height = 23, ;
		Text2.Left = 21, ;
		Text2.Top = 52, ;
		Text2.Width = 170, ;
		Text2.Name = "Text2"


	ADD OBJECT tmrcheckform AS checkform WITH ;
		Top = 355, ;
		Left = 42, ;
		Name = "tmrCheckform"


	ADD OBJECT tmrfadeform AS fadeform WITH ;
		Top = 355, ;
		Left = 72, ;
		Name = "tmrFadeform"


	ADD OBJECT cmdfilter AS commandbutton WITH ;
		Top = 352, ;
		Left = 160, ;
		Height = 26, ;
		Width = 64, ;
		Picture = "..\..\grafgen\iconos\addfilter16.bmp", ;
		Caption = "Filtrar", ;
		TabIndex = 8, ;
		ToolTipText = "Aplicar filtros y salir", ;
		PicturePosition = 4, ;
		PictureMargin = 2, ;
		Name = "cmdFilter"


	ADD OBJECT image2 AS image WITH ;
		Picture = "..\..\grafgen\iconos\reverse.png", ;
		Height = 25, ;
		Left = 3, ;
		Top = 353, ;
		Width = 36, ;
		ToolTipText = "Revertir selección", ;
		Name = "Image2"


	ADD OBJECT cmdclearfilter AS commandbutton WITH ;
		Top = 4, ;
		Left = 168, ;
		Height = 26, ;
		Width = 28, ;
		Anchor = 3, ;
		Picture = "..\..\grafgen\iconos\clearfilter16.bmp", ;
		Caption = "", ;
		TabIndex = 3, ;
		ToolTipText = "Borrar filtro existente", ;
		PicturePosition = 4, ;
		Name = "cmdClearFilter"


	ADD OBJECT cmdsearch AS commandbutton WITH ;
		Top = 4, ;
		Left = 140, ;
		Height = 25, ;
		Width = 28, ;
		Anchor = 0, ;
		Picture = "..\..\grafgen\iconos\search16.bmp", ;
		Caption = "", ;
		TabIndex = 2, ;
		ToolTipText = "Buscar", ;
		Name = "cmdSearch"


	ADD OBJECT txtsearch AS textbox WITH ;
		FontItalic = .T., ;
		Anchor = 0, ;
		Value = "Search", ;
		Format = "K", ;
		Height = 23, ;
		Left = 5, ;
		SelectOnEntry = .T., ;
		TabIndex = 1, ;
		Top = 5, ;
		Width = 134, ;
		ForeColor = RGB(128,128,255), ;
		Name = "txtSearch"


	ADD OBJECT cmdexit AS commandbutton WITH ;
		Top = 4, ;
		Left = 196, ;
		Height = 26, ;
		Width = 28, ;
		Anchor = 3, ;
		Picture = "..\..\grafgen\iconos\close16.bmp", ;
		Caption = "", ;
		TabIndex = 4, ;
		ToolTipText = "Terminar y salir", ;
		PicturePosition = 4, ;
		Name = "cmdExit"


	*-- INTERNAL USE: Used to setup the initial environment for this form and some default values for controls.
	PROCEDURE setup
		LOCAL lcRecordSource, lcControlSource, lcCursorName
		LOCAL lcControlSourceJustStem, loActiveControlInColumn
		LOCAL lcColumnCursorName, llActiveControlIsCombobox, lcOrderByClause

		WITH THIS
			m.lcRecordSource = ALLTRIM(.ColumnObject.PARENT.RECORDSOURCE)
			m.lcControlSource = ALLTRIM(.ColumnObject.CONTROLSOURCE)
			.GridRecordSource = m.lcRecordSource
			.ColumnControlSource = m.lcControlSource
			m.lcCursorName = .UniqueCursorName
			IF AT(".", m.lcControlSource) > 0
				m.lcControlSourceJustStem = JUSTSTEM(m.lcControlSource)
				IF UPPER(ALLTRIM(m.lcControlSourceJustStem)) != UPPER(ALLTRIM(m.lcRecordSource)) AND USED(m.lcControlSourceJustStem)
					m.lcRecordSource = m.lcControlSourceJustStem
				ENDIF
			ENDIF
			m.loActiveControlInColumn = EVALUATE("this.ColumnObject." + .ColumnObject.CURRENTCONTROL)
			m.llActiveControlIsCombobox = (LOWER(m.loActiveControlInColumn.BASECLASS) = "combobox" AND m.loActiveControlInColumn.BOUNDCOLUMN > 1)
			IF m.llActiveControlIsCombobox
				.GridCustomFilter1.VISIBLE = .F.
			ENDIF
			m.lcOrderByClause = ""
			m.lcDistinct = ""
			IF TYPE(m.lcControlSource) != "M"
				m.lcOrderByClause = "ORDER BY 2"
				m.lcDistinct = "Distinct"
			ENDIF
			IF !.GridExtraObject.CaseSensitive AND TYPE(m.lcControlSource) = "C"
				IF m.llActiveControlIsCombobox
					m.lcColumnCursorName = .GridExtraObject.GetComboCursorName(m.loActiveControlInColumn)
					IF USED(m.lcColumnCursorName)
						SELECT &lcDistinct .T. AS checked, UPPER(disptext) AS fldvalues,  TRANSFORM(fkid) AS actvalues;
							FROM (m.lcRecordSource) WITH (BUFFERING = .T.) INNER JOIN &lcColumnCursorName ON &lcControlSource = &lcColumnCursorName..fkid ;
							&lcOrderByClause ;
							INTO CURSOR &lcCursorName READWRITE
					ENDIF
				ELSE
					SELECT &lcDistinct .T. AS checked, UPPER(&lcControlSource) AS fldvalues, UPPER(&lcControlSource) AS actvalues ;
						FROM (m.lcRecordSource) WITH (BUFFERING = .T.) ;
						&lcOrderByClause ;
						INTO CURSOR &lcCursorName READWRITE
				ENDIF
			ELSE
				IF m.llActiveControlIsCombobox
					m.lcColumnCursorName = .GridExtraObject.GetComboCursorName(m.loActiveControlInColumn)
					IF USED(m.lcColumnCursorName)
						SELECT &lcDistinct .T. AS checked, disptext AS fldvalues, TRANSFORM(fkid) AS actvalues ;
							FROM (m.lcRecordSource) WITH (BUFFERING = .T.) INNER JOIN &lcColumnCursorName ON &lcControlSource = &lcColumnCursorName..fkid ;
							&lcOrderByClause ;
							INTO CURSOR &lcCursorName READWRITE
					ENDIF
				ELSE
					SELECT &lcDistinct .T. AS checked, &lcControlSource AS fldvalues, &lcControlSource AS actvalues ;
						FROM (m.lcRecordSource) WITH (BUFFERING = .T.) ;
						&lcOrderByClause ;
						INTO CURSOR &lcCursorName READWRITE
				ENDIF
			ENDIF
			.RetrievePreviousChecks()
			GO TOP IN (m.lcCursorName)
			WITH .grid1
				.RECORDSOURCE = m.lcCursorName
				IF .COLUMNCOUNT != 2
					.COLUMNCOUNT = 2
				ENDIF
				.Column1.CONTROLSOURCE = "checked"
				.Column2.CONTROLSOURCE = "fldvalues"
				.Column2.FORMAT = THIS.ColumnObject.FORMAT
				.Column2.INPUTMASK = THIS.ColumnObject.INPUTMASK
			ENDWITH
			.GridCustomFilter1.SETUP(.ColumnObject.CONTROLS(1).CAPTION, TYPE(m.lcControlSource), m.lcControlSource)
			.retrievepreviouscustomfilter()
			.LastUserAction = SECONDS()
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to build the filter. Basically filling the CustomColumnFilters and AColumnFilters arrays of the GridExtra class.
	PROCEDURE buildfilter
		LOCAL llAllChecked, lnFilterCounter, lnOriginalLen, lcColumnName
		LOCAL llNoneChecked, lcAtCommand, lcGlobalArray, lnIndexCustomColumnFilter

		WITH THIS
			IF .GridExtraObject.CaseSensitive
				m.lcAtCommand= "AT"
			ELSE
				m.lcAtCommand= "ATC"
			ENDIF
			.ClearFilter()
			m.llAllChecked = .T.
			m.llNoneChecked = .T.
			m.lnOriginalLen = ALEN(.GridExtraObject.acolumnfilters, 1)
			IF TYPE("This.GridExtraObject.AColumnFilters(1,2)") != "C" AND m.lnOriginalLen = 1
				m.lnOriginalLen = 0
			ENDIF

			****************************************
			*!* Save custom filter settings so they can be restored
			IF .IndexCustomColumnFilter < 1
				.IndexCustomColumnFilter = ALEN(.GridExtraObject.CustomColumnFilters,1) + 1
				DIMENSION .GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 5)
			ENDIF
			.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 1) = .ColumnObject.NAME
			.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 2) = .GridCustomFilter1.Combo1.LISTINDEX
			.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 3) = .GridCustomFilter1.Text1.VALUE
			.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 4) = .GridCustomFilter1.Text2.VALUE
			.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter, 5) = .GridCustomFilter1.FilterString
			****************************************

			m.lcGlobalArray = [_GEScr.] + .GlobalArrayname
			m.lnFilterCounter = m.lnOriginalLen
			IF !.check1.VALUE
				GO TOP IN (.UniqueCursorName)
				m.lcColumnName = ALLTRIM(.ColumnObject.NAME)
				DO WHILE !EOF(.UniqueCursorName)
					IF EVALUATE(.UniqueCursorName + ".checked")
						m.llNoneChecked = .F.
						IF m.lnFilterCounter = m.lnOriginalLen
							m.lnFilterCounter = m.lnFilterCounter + 1
							DIMENSION &lcGlobalArray.(m.lnFilterCounter,1)
							DIMENSION .GridExtraObject.AColumnFilters(m.lnFilterCounter,3)
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,1) = "("
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,2) = m.lcColumnName
							m.lnFilterCounter = m.lnFilterCounter + 1
							DIMENSION &lcGlobalArray.(m.lnFilterCounter,1)
							DIMENSION .GridExtraObject.AColumnFilters(m.lnFilterCounter,3)
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,1) = m.lcAtCommand + "([" + .DELIMITER + "]+TRANSFORM(" + .ColumnControlSource + ")+[" + .DELIMITER + "],"+;
								[ _GEScr.] + .GlobalArrayname + [(] + ALLTRIM(STR(m.lnFilterCounter)) + [,1)]
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,2) = m.lcColumnName
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,3) = ;
								.DELIMITER + TRANSFORM(EVALUATE(.UniqueCursorName + ".actvalues")) + .DELIMITER
						ELSE
							.GridExtraObject.AColumnFilters(m.lnFilterCounter,3) = ;
								.GridExtraObject.AColumnFilters(m.lnFilterCounter,3) + ;
								TRANSFORM(EVALUATE(.UniqueCursorName + ".actvalues")) + .DELIMITER
						ENDIF
					ELSE
						m.llAllChecked = .F.
					ENDIF
					SKIP 1 IN (.UniqueCursorName)
				ENDDO
			ENDIF
			IF m.lnFilterCounter = 0
				DIMENSION .GridExtraObject.AColumnFilters(1,3)
				STORE .F. TO .GridExtraObject.AColumnFilters
				DIMENSION &lcGlobalArray.(1,1)
				STORE .F. TO &lcGlobalArray
			ELSE
				IF !m.llAllChecked AND !m.llNoneChecked
					&lcGlobalArray.(m.lnFilterCounter,1) = .GridExtraObject.AColumnFilters(m.lnFilterCounter,3)
					.GridExtraObject.AColumnFilters(m.lnFilterCounter,1) = ;
						.GridExtraObject.AColumnFilters(m.lnFilterCounter,1) + ")>0"
					m.lnFilterCounter = m.lnFilterCounter + 1
					DIMENSION &lcGlobalArray.(m.lnFilterCounter,1)
					DIMENSION .GridExtraObject.AColumnFilters(m.lnFilterCounter,3)
					.GridExtraObject.AColumnFilters(m.lnFilterCounter,1) = ")"
					.GridExtraObject.AColumnFilters(m.lnFilterCounter,2) = m.lcColumnName
					&lcGlobalArray.(m.lnFilterCounter,1) = ""
				ENDIF
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Clears any references for the target column's controlsource from the AColumnFilters and CustomColumnFilters array properties of the GridExtra class instance.
	PROCEDURE clearfilter
		LOCAL lnCounter, lcColumnName, lnIndex, lcGlobalArray, lcFilter
		LOCAL ARRAY aTemp(1,3)

		WITH THIS
			DIMENSION aTemp(ALEN(.GridExtraObject.AColumnFilters, 1),3)
			=ACOPY(.GridExtraObject.AColumnFilters, aTemp)
			DIMENSION .GridExtraObject.AColumnFilters(1,3)
			STORE .F. TO .GridExtraObject.AColumnFilters
			m.lcGlobalArray = [_GEScr.]+.GlobalArrayname
			m.lnIndex = 0
			m.lcColumnName = UPPER(ALLTRIM(.ColumnObject.NAME))
			FOR m.lnCounter = 1 TO ALEN(aTemp, 1)
				IF TYPE("aTemp(m.lnCounter,2)") = "C"
					IF UPPER(ALLTRIM(aTemp(m.lnCounter,2))) == m.lcColumnName
						*!*				=ADEL(.GridExtraObject.AColumnFilters, m.lnCounter)
					ELSE
						m.lnIndex = m.lnIndex + 1
						DIMENSION .GridExtraObject.AColumnFilters(m.lnIndex,3)
						DIMENSION &lcGlobalArray.(m.lnIndex,1)
						m.lcFilter = aTemp(m.lnCounter,1)
						m.lcFilter = STRTRAN(m.lcFilter, m.lcGlobalArray+"("+ALLTRIM(STR(m.lnCounter))+",1)", m.lcGlobalArray+"("+ALLTRIM(STR(m.lnIndex))+",1)")
						.GridExtraObject.AColumnFilters(m.lnIndex,1) = m.lcFilter
						.GridExtraObject.AColumnFilters(m.lnIndex,2) = aTemp(m.lnCounter,2)
						.GridExtraObject.AColumnFilters(m.lnIndex,3) = aTemp(m.lnCounter,3)
						&lcGlobalArray.(m.lnIndex,1) = aTemp(m.lnCounter,3)
					ENDIF
				ENDIF
			ENDFOR
			IF .IndexCustomColumnFilter > 0
				.GridExtraObject.CustomColumnFilters(.IndexCustomColumnFilter,5) = ""
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to retrieve what, if any, selections were checked in the grid the last time the user was in this form.
	PROCEDURE retrievepreviouschecks
		LOCAL lnCounter, lcColumnName, llFoundOne, lcIndexOneValue, lcIndexTwoValue, lcAtCommand

		WITH This
			IF .GridExtraObject.CaseSensitive
				m.lcAtCommand= "AT"
			else
				m.lcAtCommand= "ATC"
			ENDIF
			m.lcColumnName = ALLTRIM(.ColumnObject.name)
			m.llFoundOne = .F.
			m.llDoInitialUpdateToFalse = .T.
			FOR m.lnCounter = 1 TO ALEN(.GridExtraObject.AColumnFilters,1)
				m.lcIndexTwoValue = .GridExtraObject.AColumnFilters(m.lnCounter,2)
				IF TYPE("m.lcIndexTwoValue") = "C"
					m.lcIndexOneValue = .GridExtraObject.AColumnFilters(m.lnCounter,3)
					IF m.lcIndexTwoValue == m.lcColumnName ;
						AND NOT EMPTY(m.lcIndexOneValue)
						IF m.llDoInitialUpdateToFalse
							m.llDoInitialUpdateToFalse = .F.
							UPDATE (.UniqueCursorName) SET checked = .F. WHERE .T.
						ENDIF
						GO TOP IN (.UniqueCursorName)
						DO WHILE !EOF(.UniqueCursorName)
							IF &lcAtCommand.(.delimiter + TRANSFORM(EVALUATE(.UniqueCursorName + ".actvalues")) + .delimiter, m.lcIndexOneValue) > 0
								m.llFoundOne = .T.
								replace checked WITH .T. IN (.UniqueCursorName)
							ENDIF
							SKIP 1 IN (.UniqueCursorName)
						ENDDO
					ENDIF
				ENDIF
			ENDFOR
			IF m.llFoundOne
				.check1.Value = .F.
				GO TOP IN (.UniqueCursorName)
				.grid1.Refresh()
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to retrieve what, if any, selections were made by the user in the gridcustomfilter container the last time the user was in this form.
	PROCEDURE retrievepreviouscustomfilter
		LOCAL lnIndexCustomColumnFilter
		WITH THIS
			m.lnIndexCustomColumnFilter = ASCAN(.GridExtraObject.CustomColumnFilters, .ColumnObject.NAME, -1, -1, 1, 15)
			IF m.lnIndexCustomColumnFilter > 0
				.GridCustomFilter1.Combo1.LISTINDEX = .GridExtraObject.CustomColumnFilters(m.lnIndexCustomColumnFilter,2)
				.GridCustomFilter1.Text1.VALUE = .GridExtraObject.CustomColumnFilters(m.lnIndexCustomColumnFilter,3)
				.GridCustomFilter1.Text2.VALUE = .GridExtraObject.CustomColumnFilters(m.lnIndexCustomColumnFilter,4)
				.GridCustomFilter1.Combo1.REFRESH()
				.GridCustomFilter1.Text1.REFRESH()
				.GridCustomFilter1.Text2.REFRESH()
			ENDIF
			.IndexCustomColumnFilter = m.lnIndexCustomColumnFilter
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to incrementally search within the target column for the value specified by the user in the txtSearch control.
	PROCEDURE search
		LOCAL lcControlSource, lcRecordSource, lcAliasWas, lcSearchValue
		WITH THIS
			IF .txtSearch.FONTITALIC
				.txtSearch.SETFOCUS()
			ELSE
				.GridExtraObject.Search(.txtSearch.VALUE, .findnext)
				.findnext = .T.
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to expand or collapse this form based on the user click the "More..." or "Less..." label displayed beneath the txtSearch control.
	PROCEDURE showfilteroptions
		LPARAMETERS tlShowFilterOptions

		WITH THIS
			IF m.tlShowFilterOptions
				.MAXHEIGHT = -1
				.MAXWIDTH = -1
				.WIDTH = (.cmdFilter.LEFT + .cmdFilter.WIDTH + 4)
				.HEIGHT = (.cmdFilter.TOP + .cmdFilter.HEIGHT + 4)
				.SetAnchors(.F.)
			ELSE
				.SetAnchors(.T.)
				.WIDTH = (.cmdExit.LEFT + .cmdExit.WIDTH + 4)
				.HEIGHT = .shpSplitter.TOP
				.MAXHEIGHT = .HEIGHT
				.MAXWIDTH = .WIDTH
			ENDIF
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Determines whether the alias specified by UniqueCursorName has .T. in the checked field for all records and then sets the Check1 control's value appropriately.
	PROCEDURE checkforselectall
		LOCAL ARRAY aTemp(1)

		WITH THIS
			SELECT checked FROM (.UniqueCursorName) WHERE !checked INTO ARRAY aTemp
			.Check1.VALUE = (_TALLY < 1)
			.Check1.REFRESH()
		ENDWITH
	ENDPROC


	*-- INTERNAL USE: Used to both set and clear the anchor property of certain controls on this form allowing it to be expanded, resized, and collapsed appropriately.
	PROCEDURE setanchors
		LPARAMETERS tlClearAnchors

		WITH THIS
			IF m.tlClearAnchors
				.grid1.ANCHOR = 11
				.cmdFilter.ANCHOR = 8
				.image2.ANCHOR = 0
			ELSE
				.grid1.ANCHOR = 15
				.cmdFilter.ANCHOR = 12
				.image2.ANCHOR = 6
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE Deactivate
		IF !THISFORM.RunDeactivateRelease
			RETURN
		ENDIF
		THISFORM.RELEASE()
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toColumnObject, toGridExtraObject

		WITH THIS
			.ColumnObject = m.toColumnObject
			.GridExtraObject = m.toGridExtraObject
		ENDWITH

		IF TYPE("This.ColumnObject.Name") != "C" OR TYPE("This.GridExtraObject.Name") != "C"
			RETURN .F.
		ENDIF
		m.toGridExtraObject.CreateScreenReference()

		WITH THIS
			.UniqueCursorName = m.toGridExtraObject.GlobalArrayName
			.GlobalArrayName = m.toGridExtraObject.GlobalArrayName
			.HEIGHT = .shpSplitter.TOP
			.MINHEIGHT = .HEIGHT
			.MAXHEIGHT = .HEIGHT
			.MAXWIDTH = .WIDTH
			.MINWIDTH = .WIDTH
			.SETUP()
		ENDWITH

		IF OS() < "Windows 5.00"
			RETURN
		ENDIF

		DECLARE SetWindowLong IN WIN32API AS _Sol_SetWindowLong INTEGER, INTEGER, INTEGER
		DECLARE SetLayeredWindowAttributes IN WIN32API AS _Sol_SetLayeredWindowAttributes INTEGER, STRING, INTEGER, INTEGER

		WITH THIS
			_Sol_SetWindowLong(.HWND, -20, 0x00080000)
			_Sol_SetLayeredWindowAttributes(.HWND, 0, 255, 2)
			IF VAL(OS(3))<5
				.tmrCheckForm.INTERVAL = 0 && only available on Windows 2000 or higher
			ELSE
				.tmrCheckForm.INTERVAL = 200
			ENDIF
			IF !.GridExtraObject.Allowgridfilter
				.txtSearch.WIDTH = 162
				.cmdSearch.LEFT = .cmdClearFilter.LEFT
				.cmdClearFilter.VISIBLE = .F.
				.Image1.VISIBLE = .F.
				.lblMore.VISIBLE = .F.
				.MINHEIGHT = .Image1.TOP
				.MAXHEIGHT = .Image1.TOP
				.HEIGHT = .Image1.TOP
				.BORDERSTYLE = 2
			ENDIF
			.txtSearch.ANCHOR = 3
			.cmdSearch.ANCHOR = 3
		ENDWITH
	ENDPROC


	PROCEDURE Resize
		LOCAL lnObjectHeight, lnDifference

		WITH THIS
			.LastUserAction = SECONDS()
			IF .grid1.ANCHOR != 11
				m.lnObjectHeight = (.grid1.ROWHEIGHT * 3 + 1)
				IF .grid1.HEIGHT < m.lnObjectHeight
					m.lnDifference = (m.lnObjectHeight - .grid1.HEIGHT)
					.HEIGHT = (.HEIGHT + m.lnDifference)
					.SetAnchors(.T.)
				ENDIF
			ELSE
				IF .grid1.ANCHOR != 15
					m.lnObjectHeight = (.cmdFilter.TOP + .cmdFilter.HEIGHT + 4)
					IF .HEIGHT > m.lnObjectHeight
						.HEIGHT = m.lnObjectHeight
						.SetAnchors(.F.)
					ENDIF
				ENDIF
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE image1.MouseLeave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		THIS.PARENT.lblMore.MOUSELEAVE(nButton, nShift, nXCoord, nYCoord)
	ENDPROC


	PROCEDURE image1.MouseEnter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		THIS.PARENT.lblMore.MOUSEENTER(nButton, nShift, nXCoord, nYCoord)
	ENDPROC


	PROCEDURE lblmore.Click
		THISFORM.LastUserAction = SECONDS()

		WITH THIS
			IF .CAPTION = "Más..."
				.CAPTION = "Menos..."
				THISFORM.ShowFilterOptions(.T.)
			ELSE
				.CAPTION = "Más..."
				THISFORM.ShowFilterOptions(.F.)
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE lblmore.MouseLeave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		WITH THIS
			.FONTUNDERLINE = .F.
			.FORECOLOR = RGB(128,128,255)
		ENDWITH
	ENDPROC


	PROCEDURE lblmore.MouseEnter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		WITH THIS
			.FONTUNDERLINE = .T.
			.FORECOLOR = RGB(0,0,255)
		ENDWITH
	ENDPROC


	PROCEDURE check1.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE check1.Valid
		LOCAL llValue, lnRecNo

		WITH THISFORM
			.LastUserAction = SECONDS()
			IF USED(.UniqueCursorName)
				m.lnRecNo = IIF(!EOF(.UniqueCursorName), RECNO(.UniqueCursorName), 0)
				m.llValue = THIS.VALUE
				REPLACE ALL checked WITH m.llValue IN (.UniqueCursorName)
				IF m.lnRecNo > 0
					GO m.lnRecNo IN (.UniqueCursorName)
				ELSE
					GO BOTTOM IN (.UniqueCursorName)
				ENDIF
				.grid1.REFRESH()
			ENDIF
			.GridCustomFilter1.ClearFilterSettings()
		ENDWITH
	ENDPROC


	PROCEDURE grid1.Resize
		WITH THIS
			.Column2.WIDTH = MAX(.WIDTH - 45, 20) && JIC we'll make sure this column doesn't get too small or throw error for negative numbers
		ENDWITH
	ENDPROC


	PROCEDURE grid1.AfterRowColChange
		LPARAMETERS nColIndex

		THISFORM.LastUserAction = SECONDS()

		DODEFAULT(nColIndex)
	ENDPROC


	PROCEDURE check1.Valid
		WITH THISFORM
			.LastUserAction = SECONDS()
			GO RECNO(.UniqueCursorName) IN (.UniqueCursorName) && ensure change makes it to the table
			IF !THIS.VALUE AND .Check1.VALUE
				.Check1.VALUE = .F.
				.Check1.REFRESH()
			ELSE
				.CheckForSelectAll()
				.Grid1.REFRESH()
			ENDIF
			.GridCustomFilter1.ClearFilterSettings()
		ENDWITH
	ENDPROC


	PROCEDURE cmdfilter.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE cmdfilter.Click
		WITH THISFORM
			.LastUserAction = SECONDS()
			.RunDeactivateRelease = .F.
			.BuildFilter()
			.GridExtraObject.ApplyFilter()
			.GridExtraObject.SetHeaderImages()
			.RELEASE()
		ENDWITH
	ENDPROC


	PROCEDURE image2.Click
		LOCAL ARRAY aTemp(1)
		LOCAL lnRecNo

		WITH THISFORM
			.LastUserAction = SECONDS()
			IF USED(.UniqueCursorName)
				m.lnRecNo = IIF(!EOF(.UniqueCursorName), RECNO(.UniqueCursorName), 0)
				REPLACE ALL checked WITH !checked IN (.UniqueCursorName)
				.CheckForSelectAll()
				IF m.lnRecNo > 0
					GO m.lnRecNo IN (.UniqueCursorName)
					.Grid1.Column1.Check1.REFRESH()
				ELSE
					GO BOTTOM IN (.UniqueCursorName)
					IF !EOF(.UniqueCursorName)
						.Grid1.Column1.Check1.REFRESH()
					ENDIF
				ENDIF
				.Grid1.REFRESH()
			ENDIF
			.GridCustomFilter1.ClearFilterSettings()
		ENDWITH
	ENDPROC


	PROCEDURE cmdclearfilter.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE cmdclearfilter.Click
		WITH THISFORM
			.LastUserAction = SECONDS()
			WITH .Check1
				IF !.VALUE
					.VALUE = .T.
					.REFRESH()
					.VALID()
				ENDIF
			ENDWITH
			WITH .GridCustomFilter1.Combo1
				IF .LISTINDEX != 1
					.LISTINDEX = 1
					.INTERACTIVECHANGE()
				ENDIF
			ENDWITH
			.BuildFilter()
			.GridExtraObject.ApplyFilter()
			.GridExtraObject.SetHeaderImages()
		ENDWITH
	ENDPROC


	PROCEDURE cmdsearch.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE cmdsearch.Click
		WITH THISFORM
			.LastUserAction = SECONDS()
			.RunDeactivateRelease = .F.
			.Search()
			.RunDeactivateRelease = .T.
		ENDWITH
	ENDPROC


	PROCEDURE txtsearch.InteractiveChange
		WITH THISFORM
			.LastUserAction = SECONDS()
			.FindNext = .F.
		ENDWITH
	ENDPROC


	PROCEDURE txtsearch.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl

		IF m.nKeyCode = 13
			NODEFAULT
			THISFORM.cmdSearch.CLICK()
		ENDIF
	ENDPROC


	PROCEDURE txtsearch.LostFocus
		WITH THIS
			IF EMPTY(.VALUE)
				.VALUE = "Search"
				.FONTITALIC = .T.
				.FORECOLOR = RGB(128,128,255)
				.REFRESH()
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE txtsearch.GotFocus
		THISFORM.LastUserAction = SECONDS()

		WITH THIS
			IF .FONTITALIC = .T.
				.VALUE = ""
				.REFRESH()
				.FONTITALIC = .F.
				.FORECOLOR = RGB(0,0,0)
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE cmdexit.GotFocus
		THISFORM.LastUserAction = SECONDS()
	ENDPROC


	PROCEDURE cmdexit.Click
		THISFORM.RELEASE()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridsearchandfilter
**************************************************


**************************************************
*-- Class:        gridsearchandfiltertoplevel (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  gridsearchandfilter (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/15/08 11:36:12 AM
*
DEFINE CLASS gridsearchandfiltertoplevel AS gridsearchandfilter


	BorderStyle = 3
	Top = 0
	Left = 0
	Height = 382
	Width = 228
	ShowWindow = 2
	ShowInTaskBar = .F.
	DoCreate = .T.
	Name = "gridextraformtoplevel"
	Image1.Height = 16
	Image1.Width = 16
	Image1.Name = "Image1"
	lblMore.Name = "lblMore"
	shpSplitter.Name = "shpSplitter"
	Check1.Alignment = 0
	Check1.Name = "Check1"
	Grid1.Column1.Header1.Name = "Header1"
	Grid1.Column1.Check1.Alignment = 0
	Grid1.Column1.Check1.Name = "Check1"
	Grid1.Column1.Name = "Column1"
	Grid1.Column2.Header1.Name = "Header1"
	Grid1.Column2.Text1.Name = "Text1"
	Grid1.Column2.Name = "Column2"
	Grid1.Name = "Grid1"
	Gridcustomfilter1.Combo1.Name = "Combo1"
	Gridcustomfilter1.Text1.Name = "Text1"
	Gridcustomfilter1.Text2.Name = "Text2"
	Gridcustomfilter1.Name = "Gridcustomfilter1"
	tmrCheckform.Name = "tmrCheckform"
	tmrFadeform.Name = "tmrFadeform"
	cmdFilter.Name = "cmdFilter"
	Image2.Height = 25
	Image2.Width = 36
	Image2.Name = "Image2"
	cmdClearFilter.Name = "cmdClearFilter"
	cmdSearch.Name = "cmdSearch"
	txtSearch.Name = "txtSearch"
	cmdExit.Name = "cmdExit"


ENDDEFINE
*
*-- EndDefine: gridsearchandfiltertoplevel
**************************************************


**************************************************
*-- Class:        gridtemplates (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   05/02/14 03:14:13 AM
*
DEFINE CLASS gridtemplates AS form


	Height = 250
	Width = 434
	Desktop = .T.
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Plantillas de la grilla (GRID)"
	AlwaysOnTop = .T.
	*-- INTERNAL USE: Holds a reference to target grid to which the templates do and will apply.
	gridobject = .NULL.
	*-- INTERNAL USE: Not currently used, but holds a reference to the THISFORM for the GridExtras class instance that called this form. May be used in future enhancements to this class.
	parentform = .NULL.
	*-- INTERNAL USE: Holds a reference to the GridExtra class instance that called this form.
	gridextrasobject = .NULL.
	*-- INTERNAL USE: Holds a unique (unused) cursor name that is used as the alias for the cboTemplates control's rowsource. This alias is filled by way of the GetTemplates method.
	templatecursorname = ""
	*-- INTERNAL USE: Used to uniquely identify the grid within the the table specified by the TemplateTable property of the GridExtra class. This also allows the retrieval of only those templates that relate to this grid by the GetTemplates method.
	gridhierarchy = ""
	Name = "gridtemplates"


	ADD OBJECT shape6 AS shape WITH ;
		Top = 197, ;
		Left = -3, ;
		Height = 56, ;
		Width = 441, ;
		Anchor = 14, ;
		BackStyle = 0, ;
		SpecialEffect = 0, ;
		ZOrderSet = 8, ;
		Name = "Shape6"


	ADD OBJECT shape5 AS shape WITH ;
		Top = -2, ;
		Left = -2, ;
		Height = 201, ;
		Width = 89, ;
		Anchor = 7, ;
		SpecialEffect = 0, ;
		BackColor = RGB(255,255,255), ;
		ZOrderSet = 15, ;
		Name = "Shape5"


	ADD OBJECT image1 AS image WITH ;
		Picture = "..\..\grafgen\iconos\table_sql_view.png", ;
		Height = 48, ;
		Left = 18, ;
		Top = 16, ;
		Width = 48, ;
		ZOrderSet = 16, ;
		Name = "Image1"


	ADD OBJECT cbotemplates AS combobox WITH ;
		Anchor = 3, ;
		Height = 24, ;
		Left = 109, ;
		Style = 2, ;
		TabIndex = 2, ;
		Top = 74, ;
		Width = 260, ;
		Name = "cboTemplates"


	ADD OBJECT cmdadd AS commandbutton WITH ;
		Top = 73, ;
		Left = 369, ;
		Height = 26, ;
		Width = 26, ;
		Anchor = 3, ;
		Picture = "..\..\grafgen\iconos\add16.png", ;
		Caption = "", ;
		TabIndex = 3, ;
		Name = "cmdAdd"


	ADD OBJECT label1 AS label WITH ;
		AutoSize = .T., ;
		Anchor = 3, ;
		BackStyle = 0, ;
		Caption = "Plantillas de filtro y ordenamiento", ;
		Height = 17, ;
		Left = 109, ;
		Top = 57, ;
		Width = 184, ;
		TabIndex = 1, ;
		Name = "Label1"


	ADD OBJECT cmddelete AS commandbutton WITH ;
		Top = 73, ;
		Left = 394, ;
		Height = 26, ;
		Width = 26, ;
		Anchor = 3, ;
		Picture = "..\..\grafgen\iconos\delete16.png", ;
		Caption = "", ;
		TabIndex = 4, ;
		Name = "cmdDelete"


	ADD OBJECT cmdexit AS commandbutton WITH ;
		Top = 208, ;
		Left = 336, ;
		Height = 32, ;
		Width = 84, ;
		Anchor = 12, ;
		Picture = "..\..\grafgen\iconos\exit.png", ;
		Caption = "Salir", ;
		TabIndex = 6, ;
		PicturePosition = 4, ;
		PictureMargin = 2, ;
		Name = "cmdExit"


	*-- INTERNAL USE: Used to facilitate the ability for the user to add a new template (create and save) to the table specified by the TemplateTable property of the GridExtra class.
	PROCEDURE addtemplate
		LOCAL llReturn, lcTemplateName

		m.llReturn = .F.
		m.lcTemplateName = INPUTBOX("Nombre de plantilla ", "Nueva plantilla de  filtro y exportación de datos", "")
		IF !EMPTY(m.lcTemplateName)
			THISFORM.gridextrasobject.templatesave(THISFORM.gridhierarchy, m.lcTemplateName)
			m.llReturn = .T.
		ENDIF

		RETURN (m.llReturn)
	ENDPROC


	*-- INTERNAL USE: Used to retrieve template records from the table specified by the TemplateTable property of the GridExtra class and fill the cursor specified by the TemplateCursorName of this class.
	PROCEDURE gettemplates
		LOCAL lcTemplateTable, lcTemplateTableJustStem

		m.lcTemplateTable = EVALUATE(THIS.gridextrasobject.templatetable)
		m.lcTemplateTableJustStem = JUSTSTEM(m.lcTemplateTable)
		IF TYPE("m.lcTemplateTable") = "C" AND FILE(m.lcTemplateTable)
			IF !USED(m.lcTemplateTableJustStem)
				USE (m.lcTemplateTable) IN 0 SHARED
			ENDIF
			THISFORM.cboTemplates.ROWSOURCE = ""
			SELECT Template FROM (m.lcTemplateTableJustStem) WHERE .F. INTO CURSOR (THISFORM.templatecursorname) READWRITE
			INSERT INTO (THISFORM.templatecursorname) VALUES ("")
			INSERT INTO (THISFORM.templatecursorname) ;
				SELECT Template FROM (m.lcTemplateTableJustStem) ;
				WHERE !DELETED() AND UPPER(ALLTRIM(gridname)) == UPPER(ALLTRIM(THISFORM.gridhierarchy)) ;
				ORDER BY 1
			GO TOP IN (THISFORM.templatecursorname)
			THISFORM.cboTemplates.ROWSOURCE = THISFORM.templatecursorname
			THISFORM.cboTemplates.ROWSOURCETYPE = 2
			THISFORM.cboTemplates.DISPLAYVALUE = ""
			THISFORM.cboTemplates.REFRESH()
		ENDIF
	ENDPROC


	*-- INTERNAL USE: Used to facilitate the ability for the user to delete an existing template from the table specified by the TemplateTable property of the GridExtra class.
	PROCEDURE deletetemplate
		LOCAL lcTemplateName

		IF !EMPTY(THISFORM.cboTemplates.DISPLAYVALUE)
			IF MESSAGEBOX("Esta seguro de que desea borrar  la plantilla '" + ALLTRIM(THISFORM.cboTemplates.DISPLAYVALUE) + "' ?",36,"Se requiere confirmación") = 6
				m.lcTemplateName = UPPER(ALLTRIM(THISFORM.gridhierarchy)) + ":" + ALLTRIM(THISFORM.cboTemplates.DISPLAYVALUE)
				THISFORM.gridextrasobject.templatedelete(m.lcTemplateName)
			ENDIF
			THISFORM.GetTemplates()
		ENDIF
	ENDPROC


	PROCEDURE Load
		IF FILE("gridextrasprocs.prg")
			SET PROCEDURE TO gridextrasprocs.prg ADDITIVE
		ENDIF
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toParentForm, toGridObject, toGridExtrasObject

		WITH THIS
			.TemplateCursorName = SYS(2015)
			.ICON = _SCREEN.ICON
			.parentform = m.toParentForm
			.gridobject = m.toGridObject
			.gridhierarchy = SYS(1272, m.toGridObject)
			.gridextrasobject = m.toGridExtrasObject
			.GetTemplates()
			.shape5.ZORDER(1)
			.shape6.ZORDER(1)
		ENDWITH
	ENDPROC


	PROCEDURE Unload
		USE IN SELECT(this.templatecursorname)
	ENDPROC


	PROCEDURE QueryUnload
		NODEFAULT

		THISFORM.cmdExit.CLICK()
	ENDPROC


	PROCEDURE cbotemplates.InteractiveChange
		LOCAL loColumnObject, loHeaderObject

		WITH THISFORM.gridextrasobject
			IF !EMPTY(THIS.DISPLAYVALUE) && Apply the selected template
				.templateapply(UPPER(ALLTRIM(THISFORM.gridhierarchy)) + ":" + ALLTRIM(THIS.DISPLAYVALUE))
			ELSE && Clear out any filter or sort applied by a previous template selection
				DIMENSION .acolumnfilters(1, 3)
				STORE .F. TO .acolumnfilters
				DIMENSION .customcolumnfilters(1, 3)
				STORE .F. TO .customcolumnfilters
				.clearfilter()
				.applysort()
				FOR EACH loColumnObject IN .gridobject.COLUMNS
					m.loHeaderObject = m.loColumnObject.CONTROLS(1)
					STORE '' TO  m.loHeaderObject.PICTURE, m.loHeaderObject.TAG
				ENDFOR
			ENDIF
		ENDWITH

		THIS.SETFOCUS()
	ENDPROC


	PROCEDURE cmdadd.Click
		IF THISFORM.addtemplate()
			THISFORM.getTemplates()
		ENDIF
	ENDPROC


	PROCEDURE cmddelete.Click
		IF THISFORM.cboTemplates.LISTINDEX > 1
			THISFORM.deletetemplate()
		ENDIF
	ENDPROC


	PROCEDURE cmdexit.Click
		THISFORM.RELEASE()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: gridtemplates
**************************************************


**************************************************
*-- Class:        gridtemplatestoplevel (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- ParentClass:  gridtemplates (k:\aplvfp\classgen\vcxs\gridextras.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/15/08 11:31:10 AM
*
DEFINE CLASS gridtemplatestoplevel AS gridtemplates


	Desktop = .F.
	ShowWindow = 2
	DoCreate = .T.
	Name = "gridutilstoplevel"
	cboTemplates.Name = "cboTemplates"
	cmdAdd.Name = "cmdAdd"
	Label1.Name = "Label1"
	cmdDelete.Name = "cmdDelete"
	cmdExit.Name = "cmdExit"
	Shape6.Name = "Shape6"
	Shape5.Name = "Shape5"
	Image1.Height = 48
	Image1.Width = 48
	Image1.Name = "Image1"


ENDDEFINE
*
*-- EndDefine: gridtemplatestoplevel
**************************************************
