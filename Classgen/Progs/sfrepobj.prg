**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\sfrepobj.vcx
**************************************************


**************************************************
*-- Class:        sfreportfile (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfcustom (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   09/19/08 10:25:13 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportfile AS sfcustom


	*-- An object reference to the page header band object
	PROTECTED opageheaderband
	opageheaderband = .NULL.
	*-- An object reference to the page footer band object
	PROTECTED opagefooterband
	opagefooterband = .NULL.
	*-- An object reference to the detail band object
	PROTECTED odetailband
	odetailband = .NULL.
	*-- An object reference to the title band object
	PROTECTED otitleband
	otitleband = .NULL.
	*-- An object reference to the summary band object
	PROTECTED osummaryband
	osummaryband = .NULL.
	*-- The default font for the report
	cfontname = "Courier New"
	*-- The default font size for the report
	nfontsize = 10
	*-- The name of the report file to create
	creportfile = ""
	*-- The factor to convert a vertical character unit to a report unit
	PROTECTED nvfactor
	nvfactor = 0
	*-- The factor to convert a horizontal character unit to a report unit
	PROTECTED nhfactor
	nhfactor = 0
	*-- The unit of measurement: "C" (characters), "I" (inches), or "M" (centimeters)
	cunits = "C"
	*-- The current band number being processed
	PROTECTED nband
	nband = 0
	*-- The current report height
	PROTECTED nheight
	nheight = 0
	*-- .T. if the report has a title band
	ltitleband = .F.
	*-- .T. if the report has a summary band
	lsummaryband = .F.
	*-- The left margin for the report
	nleftmargin = 0
	*-- The number of columns in the report
	ncolumns = 1
	*-- The spacing between columns
	ncolumnspacing = 0
	*-- .T. to use the whole page, .F. to use the printable page
	lwholepage = .F.
	*-- .T. to print records in columns across the page, .F. to print top to bottom then in columns
	lprintcolumns = .F.
	*-- .T. to use a private datasession with this report
	lprivatedatasession = .F.
	norientation = 0
	npapersize = 1
	Name = "sfreportfile"

	*-- An array of group header and footer band objects
	PROTECTED agroupbands[1]

	*-- An array of report variables
	PROTECTED avariables[1]


	*-- Returns an object reference to the specified band
	PROCEDURE getreportband
		lparameters tcBand, ;
			tnNumber
		local lcBand, ;
			loBand
		with This
			assert vartype(tcBand) = 'C' and inlist(upper(tcBand), ;
				ccBAND_PAGE_HEADER, ccBAND_PAGE_FOOTER, ccBAND_DETAIL, ccBAND_TITLE, ;
				ccBAND_SUMMARY, ccBAND_GROUP_HEADER, ccBAND_GROUP_FOOTER) ;
				message 'SFReportFile.GetReportBand: invalid tcBand parameter'
			assert pcount() = 1 or (vartype(tnNumber) $ 'NFIBY' and ;
				between(tnNumber, 1, alen(.aGroupBands, 1))) ;
				message 'SFReportFile.GetReportBand: invalid tnNumber parameter'
			lcBand = upper(tcBand)
			loBand = .NULL.
			do case
				case lcBand = ccBAND_PAGE_HEADER
					loBand = .oPageHeaderBand
				case lcBand = ccBAND_PAGE_FOOTER
					loBand = .oPageFooterBand
				case lcBand = ccBAND_DETAIL
					loBand = .oDetailband
				case lcBand = ccBAND_TITLE
					if .lTitleBand and isnull(.oTitleBand)
						.oTitleBand = newobject('SFReportBand', .ClassLibrary, '', ;
							'Title', This)
					endif .lTitleBand ...
					loBand = .oTitleBand
				case lcBand = ccBAND_SUMMARY
					if .lSummaryBand and isnull(.oSummaryBand)
						.oSummaryBand = newobject('SFReportBand', .ClassLibrary, '', ;
							'Summary', This)
					endif .lSummaryBand ...
					loBand = .oSummaryBand
				case lcBand = ccBAND_GROUP_HEADER
					loBand = .aGroupBands[tnNumber, 1]
				case lcBand = ccBAND_GROUP_FOOTER
					loBand = .aGroupBands[tnNumber, 2]
			endcase
		endwith
		return loBand
	ENDPROC


	*-- Creates the report file
	PROCEDURE save
		* Create an FRX by spinning through each band in order and processing the
		* objects in it.

		local lnSelect, ;
			lnGroups, ;
			lnI, ;
			lnVariables
		with This

		* Ensure a report file was specified.

			if empty(.cReportFile)
				error cnERR_USER_DEFINED, ccERR_NO_REPORT_FILE
				return .F.
			endif empty(.cReportFile)

		* Calculate the factors to convert character units into report units. For
		* proportional fonts, we'll use the size of the "average" character in a font
		* as the horizontal factor.

			do case
				case .cUnits = ccUNITS_CHARACTERS
					.nVFactor = .GetVFactor(This)
					.nHFactor = .GetHFactor(This)

		* For an inches scale, use the report units factor.

				case .cUnits = ccUNITS_INCHES
					.nVFactor = cnREPORT_UNITS
					.nHFactor = cnREPORT_UNITS

		* For an centimeter scale, use the report units factor divided by the number of
		* centimeters per inch.

				case .cUnits = ccUNITS_CHARACTERS
					.nVFactor = cnREPORT_UNITS/2.54
					.nHFactor = cnREPORT_UNITS/2.54
			endcase

		* Set the current band number and report height to 0.

			.nBand   = 0
			.nHeight = 0

		* Create the report and insert the header record.

			lnSelect = select()
			.CreateReportFile()
			.InsertHeader()

		* Insert the title and page header bands.

			.InsertBand(.oTitleBand)
			.InsertBand(.oPageHeaderBand)

		* Insert each group header band.

			lnGroups = iif(isnull(.aGroupBands[1, 1]), 0, alen(.aGroupBands, 1))
			for lnI = 1 to lnGroups
				.InsertBand(.aGroupBands[lnI, 1])
			next lnI

		* Insert the detail band.

			.InsertBand(.oDetailBand)

		* Insert each group footer band.

			for lnI = 1 to lnGroups
				.InsertBand(.aGroupBands[lnI, 2])
			next lnI

		* Insert the page footer and summary bands.

			.InsertBand(.oPageFooterBand)
			.InsertBand(.oSummaryBand)

		* Insert the report variables.

			lnVariables = iif(isnull(.aVariables[1]), 0, alen(.aVariables))
			for lnI = 1 to lnVariables
				.InsertVariable(.aVariables[lnI])
			next lnI

		* Insert the trailer and DataEnvironment records, then close the report file.

			.InsertTrailer()
			.InsertDE()
			use
			select (lnSelect)
		endwith
	ENDPROC


	*-- Inserts a header record into the report
	PROTECTED PROCEDURE insertheader
		local loRecord
		with This
			loRecord            = .CreateReportRecord()
			loRecord.ObjType    = cnREPOBJ_HEADER
			loRecord.ObjCode    = 53
			loRecord.VPos       = .nColumns
			loRecord.HPos       = .nLeftMargin * .nVFactor
			loRecord.Height     = .nColumnSpacing * .nVFactor
			loRecord.Width      = -1
			loRecord.FontFace   = .cFontName
			loRecord.FontSize   = .nFontSize
			loRecord.Top        = .lWholePage
			loRecord.Bottom     = .lPrintColumns
			loRecord.Ruler      = 1
			loRecord.RulerLines = 1
			loRecord.Grid       = .T.
			loRecord.GridV      = 12
			loRecord.GridH      = 12
			loRecord.AddAlias   = .T.
			loRecord.CurPos     = .T.
			loRecord.Expr       = ;
						[ORIENTATION=]+ALLTRIM(STR(.nOrientation))+CHR(13)+CHR(10)+ ;
						[PAPERSIZE=]+ALLTRIM(STR(.nPaperSize))+CHR(13)+CHR(10)
			.InsertRecord(loRecord)
		endwith
		return
	ENDPROC


	*-- Creates a report record object
	PROTECTED PROCEDURE createreportrecord
		local loRecord
		scatter name loRecord blank memo
		loRecord.Platform = 'WINDOWS'
		loRecord.UniqueID = sys(2015)
		return loRecord
	ENDPROC


	*-- Inserts the specified record to the report file
	PROTECTED PROCEDURE insertrecord
		* Adjust certain properties of the specified record, then add it to the report
		* file.

		lparameters toRecord
		local lcUnits
		with This
			if toRecord.ObjType <> cnREPOBJ_HEADER

		* Convert the height, width, left, and top properties of the object to report
		* units.

				lcUnits = upper(left(.cUnits, 1))
				toRecord.Height = iif(toRecord.Height < 0, -toRecord.Height, ;
					round(max(toRecord.Height * .nVFactor, cnFACTOR), 0))
				toRecord.Width  = iif(toRecord.Width < 0, -toRecord.Width, ;
					toRecord.Width * .nHFactor)
				toRecord.HPos   = toRecord.HPos * .nHFactor
				toRecord.VPos   = toRecord.VPos * .nVFactor + .nHeight + ;
					.nBand * cnBAND_HEIGHT

		* If we're working in characters and the object is less than a full line high,
		* let's center it vertically on the line.

				if lcUnits = 'C' and toRecord.Height < .nVFactor
					toRecord.VPos = toRecord.VPos + (.nVFactor - toRecord.Height)/2
				endif lcUnits = 'C' ...
			endif toRecord.ObjType <> 1

		* Add the record to the report file.

			append blank
			gather name toRecord memo
		endwith
	ENDPROC


	*-- Inserts a trailer record into the report
	PROTECTED PROCEDURE inserttrailer
		local lnFontStyle, ;
			lcFontStyle, ;
			loRecord
		with This
			loRecord          = .CreateReportRecord()
			loRecord.ObjType  = 23
			loRecord.VPos     = fontmetric(1, .cFontName, .nFontSize) + ;
				fontmetric(5, .cFontName, .nFontSize)
			loRecord.HPos     = fontmetric(6, .cFontName, .nFontSize)
			loRecord.Height   = fontmetric(2, .cFontName, .nFontSize)
			loRecord.Width    = fontmetric(7, .cFontName, .nFontSize)
			loRecord.PenRed   = cnPEN_RED_FUDGE
			loRecord.FontFace = .cFontName
			loRecord.FontSize = .nFontSize
			.InsertRecord(loRecord)
		endwith
		return
	ENDPROC


	*-- Inserts a DataEnvironment record into the report
	PROTECTED PROCEDURE insertde
		local loRecord
		with This
			loRecord         = .CreateReportRecord()
			loRecord.ObjType = 25
			loRecord.Name    = 'dataenvironment'
			loRecord.Expr    = 'Name = "Dataenvironment"'
			loRecord.Environ = .lPrivateDataSession
			.InsertRecord(loRecord)
		endwith
		return
	ENDPROC


	*-- Inserts the specified band record into the report
	PROTECTED PROCEDURE insertband
		lparameters toBand
		local loRecord, ;
			lnRecno, ;
			lnMaxHeight, ;
			laObjects[1], ;
			lnObjects, ;
			lnI, ;
			loObject
		if not isnull(toBand)
			with This
				loRecord = .CreateReportRecord()
				toBand.CreateRecord(loRecord, This)
				.InsertRecord(loRecord)
				lnRecno = recno()

		* Handle all the objects in the band.

				lnMaxHeight = loRecord.Height
				lnObjects = toBand.GetReportObjects(@laObjects)
				for lnI = 1 to lnObjects
					loObject = .CreateReportRecord()
					laObjects[lnI].CreateRecord(loObject, This)
					.InsertRecord(loObject)
					lnMaxHeight = max(lnMaxHeight, loObject.VPos - .nHeight - ;
						.nBand * cnBAND_HEIGHT + loObject.Height)
				next lnI

		* If the band height isn't sufficient, adjust it.

				if lnMaxHeight > Height
					go lnRecno
					replace HEIGHT with lnMaxHeight
				endif lnMaxHeight > Height

		* Increment the current band number and height.

				.nBand   = .nBand + 1
				.nHeight = .nHeight + lnMaxHeight
			endwith
		endif not isnull(toBand)
		return
	ENDPROC


	*-- Creates a new group band
	PROCEDURE creategroupband
		local lnGroup
		with This
			lnGroup = iif(isnull(.aGroupBands[1, 1]), 1, alen(.aGroupBands, 1) + 1)
			dimension .aGroupBands[lnGroup, 2]
			.aGroupBands[lnGroup, 1] = newobject('SFReportGroup', This.ClassLibrary, ;
				'', 'Group Header', This)
			.aGroupBands[lnGroup, 2] = newobject('SFReportGroup', This.ClassLibrary, ;
				'', 'Group Footer', This)
		endwith
	ENDPROC


	*-- Creates the report file
	PROTECTED PROCEDURE createreportfile
		* Create a cursor, then create a report file from it.

		local lcCursor, ;
			lcSafety
		lcCursor = sys(2015)
		create cursor (lcCursor) (FIELD1 C(1))
		create report (.cReportFile) from (lcCursor)
		use (.cReportFile) exclusive
		lcSafety = set('SAFETY')
		set safety off
		zap
		if lcSafety = 'ON'
			set safety on
		endif lcSafety = 'ON'
		return
	ENDPROC


	*-- Creates a report variable
	PROCEDURE createvariable
		local lnVariable
		with This
			lnVariable = iif(isnull(.aVariables[1]), 1, alen(.aVariables) + 1)
			loVariable = newobject('SFReportVariable', This.ClassLibrary)
			dimension .aVariables[lnVariable]
			.aVariables[lnVariable] = loVariable
		endwith
		return loVariable
	ENDPROC


	*-- Inserts a report variable into the report
	PROTECTED PROCEDURE insertvariable
		lparameters toVariable
		local loRecord
		if not isnull(toVariable)
			with This
				loRecord = .CreateReportRecord()
				toVariable.CreateRecord(loRecord, This)
				.InsertRecord(loRecord)
			endwith
		endif not isnull(toBand)
		return
	ENDPROC


	PROCEDURE nleftmargin_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nLeftMargin = tnValue
		endcase
	ENDPROC


	PROCEDURE ncolumns_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 1, 5)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nColumns = tnValue
		endcase
	ENDPROC


	PROCEDURE ncolumnspacing_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nColumnSpacing = tnValue
		endcase
	ENDPROC


	PROCEDURE lwholepage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lWholePage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lprintcolumns_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrintColumns = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lprivatedatasession_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrivateDataSession = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE cfontname_assign
		* Ensure that a valid font name was specified.

		lparameter tcValue
		local laFonts[1], ;
			lnFonts, ;
			lnI, ;
			lnFont
		afont(laFonts)
		lnFonts = alen(laFonts)
		for lnI = 1 to lnFonts
			laFonts[lnI] = upper(laFonts[lnI])
		next lnI
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case empty(tcValue)
				error cnERR_PROPERTY_INVALID
			otherwise
				lnFont = ascan(laFonts, upper(tcValue))
				if lnFont > 0
					This.cFontName = tcValue
				else
					error cnERR_PROPERTY_INVALID
				endif lnFont > 0
		endcase
	ENDPROC


	PROCEDURE nfontsize_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nFontSize = tnValue
		endcase
	ENDPROC


	PROCEDURE creportfile_assign
		lparameter tcValue
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case empty(tcValue)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.cReportFile = tcValue
		endcase
	ENDPROC


	PROCEDURE cunits_assign
		lparameter tcValue
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case not inlist(tcValue, ccUNITS_CHARACTERS, ccUNITS_INCHES, ;
				ccUNITS_CENTIMETERS)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.cUnits = tcValue
		endcase
	ENDPROC


	PROCEDURE lsummaryband_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lSummaryBand = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE ltitleband_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lTitleBand = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	*-- Calculates a horizontal value in the units used by the report
	PROCEDURE gethvalue
		lparameters tnValue, ;
			toObject
		local lnValue
		if This.cUnits = ccUNITS_CHARACTERS
			lnValue = tnValue
		else
			lnValue = tnValue * This.GetHFactor(toObject)/cnREPORT_UNITS
		endif This.cUnits = ccUNITS_CHARACTERS
		return lnValue
	ENDPROC


	*-- Calculates a vertical values in the units used by the report
	PROCEDURE getvvalue
		lparameters tnValue, ;
			toObject
		local lnValue
		if This.cUnits = ccUNITS_CHARACTERS
			lnValue = tnValue
		else
			lnValue = tnValue * This.GetVFactor(toObject)/cnREPORT_UNITS
		endif This.cUnits = ccUNITS_CHARACTERS
		return lnValue
	ENDPROC


	*-- Calculates the horizontal factor for the specified font
	PROTECTED PROCEDURE gethfactor
		lparameters toObject
		local loObject, ;
			lnMax, ;
			lnAvg, ;
			lnFactor
		loObject = iif(type('toObject.cFontName') = 'C' and ;
			not empty(toObject.cFontName) and toObject.nFontSize > 0, toObject, This)
		lnMax = fontmetric(7, loObject.cFontName, loObject.nFontSize)
		lnAvg = fontmetric(6, loObject.cFontName, loObject.nFontSize)
		if lnMax - lnAvg > 1
			lnFactor = txtwidth(ccAVG_CHAR, loObject.cFontName, loObject.nFontSize) * ;
				lnAvg * cnFACTOR
		else
			lnFactor = lnMax * cnFACTOR
		endif lnMax - lnAvg > 1
		return lnFactor
	ENDPROC


	*-- Calculates the vertical factor for the specified font
	PROTECTED PROCEDURE getvfactor
		lparameters toObject
		local loObject, ;
			lnFactor
		loObject = iif(type('toObject.cFontName') = 'C' and ;
			not empty(toObject.cFontName) and toObject.nFontSize > 0, toObject, This)
		lnFactor = (fontmetric(1, loObject.cFontName, loObject.nFontSize) + ;
			fontmetric(5, loObject.cFontName, loObject.nFontSize) + ;
			cnVERTICAL_FUDGE) * cnFACTOR
		return lnFactor
	ENDPROC


	PROCEDURE releasemembers
		* Nuke member objects.

		local lnI
		if vartype(This.oTitleBand) = 'O'
			This.oTitleBand.Release()
		endif vartype(This.oTitleBand) = 'O'
		if vartype(This.oPageHeaderBand) = 'O'
			This.oPageHeaderBand.Release()
		endif vartype(This.oPageHeaderBand) = 'O'
		if vartype(This.oDetailBand) = 'O'
			This.oDetailBand.Release()
		endif vartype(This.oDetailBand) = 'O'
		if vartype(This.oSummaryBand) = 'O'
			This.oSummaryBand.Release()
		endif vartype(This.oSummaryBand) = 'O'
		for lnI = 1 to alen(This.aGroupbands)
			if vartype(This.aGroupBands[lnI]) = 'O'
				This.aGroupBands[lnI].Release()
			endif vartype(This.aGroupBands[lnI]) = 'O'
		next lnI
		for lnI = 1 to alen(This.aVariables)
			if vartype(This.aVariables[lnI]) = 'O'
				This.aVariables[lnI].Release()
			endif vartype(This.aVariables[lnI]) = 'O'
		next lnI
	ENDPROC


	PROCEDURE Init
		* Create the objects representing bands in every report.

		with This
			.oPageHeaderBand = newobject('SFReportBand', .ClassLibrary, '', ;
				'Page Header', This)
			.oDetailBand     = newobject('SFReportBand', .ClassLibrary, '', ;
				'Detail', This)
			.oPageFooterBand = newobject('SFReportBand', .ClassLibrary, '', ;
				'Page Footer', This)
			dimension .aGroupBands[1, 2]
			.aGroupBands = .NULL.
			.aVariables  = .NULL.
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportfile
**************************************************


**************************************************
*-- Class:        sfreportrecord (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfcustom (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 02:54:06 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportrecord AS sfcustom


	*-- The object type code
	PROTECTED nobjecttype
	nobjecttype = 0
	Name = "sfreportrecord"


	*-- Creates a report record
	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		assert vartype(toRecord) = 'O' and type('toRecord.ObjType') = 'N' ;
			message 'SFReportRecord: invalid toRecord parameter'
		assert vartype(toReport) = 'O' ;
			message 'SFReportRecord: invalid toReport parameter'
		toRecord.ObjType = This.nObjectType
		return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportrecord
**************************************************


**************************************************
*-- Class:        sfreportband (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportrecord (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/24/99 02:41:02 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportband AS sfreportrecord


	*-- The band type
	PROTECTED cbandtype
	cbandtype = ""
	*-- The height of the band
	nheight = 0
	*-- The "on entry" expression for the band
	conentry = ""
	*-- The "on exit" expression for the band
	conexit = ""
	*-- .T. if this band should start on a new page
	lstartonnewpage = .F.
	*-- .T. if the band should be a constant height
	lconstantheight = .F.
	*-- A reference to the SFReportFile object that instantiated us
	PROTECTED oreport
	oreport = .NULL.
	nobjecttype = 9
	Name = "sfreportband"

	*-- An array of report objects in the band
	PROTECTED aitems[1]


	*-- Adds a new report item to the band
	PROCEDURE additem
		* Add a new report item to the band.

		lparameters tcType
		local lcType, ;
			loItem

		* Ensure a valid report object type is specified.

		assert vartype(tcType) = 'C' and not empty(tcType) ;
			message 'SFReportBand: invalid tcType parameter'
		with This
			lcType = upper(tcType)
			assert inlist(lcType, ccOBJECT_FIELD, ccOBJECT_TEXT, ccOBJECT_LINE, ;
				ccOBJECT_IMAGE, ccOBJECT_BOX) ;
				message 'SFReportBand: invalid object type specified'

		* Figure out which class to instantiate based on the report object type.

			do case
				case lcType = ccOBJECT_FIELD
					lcClass = 'SFReportField'
				case lcType = ccOBJECT_TEXT
					lcClass = 'SFReportText'
				case lcType = ccOBJECT_LINE
					lcClass = 'SFReportLine'
				case lcType = ccOBJECT_IMAGE
					lcClass = 'SFReportImage'
				case lcType = ccOBJECT_BOX
					lcClass = 'SFReportBox'
			endcase

		* Instantiate the proper class and add it to the array, then return an obect
		* reference to it.

			lnItem = iif(isnull(.aItems[1]), 1, alen(.aItems) + 1)
			dimension .aItems[lnItem]
			loItem = newobject(lcClass, .ClassLibrary, '', .oReport)
			.aItems[lnItem] = loItem
		endwith
		return loItem
	ENDPROC


	*-- Returns an array of report objects in this band
	PROCEDURE getreportobjects
		* Fill an array of report objects in V and H position order.

		lparameters taReturn
		local lnObjects, ;
			laObjects[1], ;
			lnI
		assert type('taReturn[1]') <> 'U' ;
			message 'SFReportBand: invalid taReturn parameter'
		with This
			lnObjects = iif(isnull(.aItems), 0, alen(.aItems))
			if lnObjects > 0
				dimension laObjects[lnObjects, 2], taReturn[lnObjects]
				for lnI = 1 to lnObjects
					laObjects[lnI, 1] = str(.aItems[lnI].nVPosition) + ;
						str(.aItems[lnI].nHPosition)
					laObjects[lnI, 2] = lnI
				next lnI
				asort(laObjects, 1)
				for lnI = 1 to lnObjects
					taReturn[lnI] = .aItems[laObjects[lnI, 2]]
				next lnI
			endif lnObjects > 0
		endwith
		return lnObjects
	ENDPROC


	PROCEDURE lstartonnewpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lStartOnNewPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE conentry_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cOnEntry = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE conexit_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cOnExit = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE nheight_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nHeight = tnValue
		endcase
	ENDPROC


	PROCEDURE lconstantheight_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lConstantHeight = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE releasemembers
		* Nuke member objects.

		local lnI
		for lnI = 1 to alen(This.aItems)
			if vartype(This.aItems[lnI]) = 'O'
				This.aItems[lnI].Release()
			endif vartype(This.aItems[lnI]) = 'O'
		next lnI
		if vartype(This.oReport) = 'O'
			This.oReport.Release()
		endif vartype(This.oReport) = 'O'
	ENDPROC


	PROCEDURE Init
		* Set the band type to the specified type and blank the report objects array.

		lparameters tcBandType, ;
			toReport
		assert vartype(tcBandType) = 'C' and not empty(tcBandType) ;
			message 'SFReportBand: invalid tcBandType parameter'
		with This
			.cBandType = tcBandType
			.oReport   = toReport
			.aItems    = .NULL.
		endwith
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcType, ;
			laObjects[1], ;
			lnObjects, ;
			lnMaxHeight, ;
			loObject
		dodefault(toRecord, toReport)
		with This

		* Set ObjCode based on the type of band this is.

			lcType = upper(.cBandType)
			do case
				case lcType = 'TITLE'
					lnCode = 0
				case lcType = 'PAGE HEADER'
					lnCode = 1
				case lcType = 'COLUMN HEADER'
					lnCode = 2
				case lcType = 'DETAIL'
					lnCode = 4
				case lcType = 'COLUMN FOOTER'
					lnCode = 6
				case lcType = 'PAGE FOOTER'
					lnCode = 7
				case lcType = 'SUMMARY'
					lnCode = 8
				otherwise
					lnCode = 0
			endcase
			toRecord.ObjCode = lnCode

		* Set the band height large enough to accommodate all objects in the band.

			lnObjects   = .GetReportObjects(@laObjects)
			lnMaxHeight = .nHeight
			for each loObject in laObjects
				if vartype(loObject) = 'O'
					lnMaxHeight = max(lnMaxHeight, loObject.nVPosition + ;
						loObject.nHeight)
				endif vartype(loObject) = 'O'
			next loObject
			toRecord.Height = lnMaxHeight

		* Set the OnEntry and OnExit expressions, and whether we should start this
		* band on a new page.

			toRecord.Tag       = .cOnEntry
			toRecord.Tag2      = .cOnExit
			toRecord.PageBreak = .lStartOnNewPage
		endwith
		return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportband
**************************************************


**************************************************
*-- Class:        sfreportgroup (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportband (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 04:57:12 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportgroup AS sfreportband


	*-- .T. to print the group header on each page
	lprintoneachpage = .F.
	*-- .T. to reset the page number for each page to 1
	lresetpage = .F.
	*-- .T. if each group should start in a new column
	lstartinnewcolumn = .F.
	*-- Starts a group on a new page when there is less than this much space left on the current page
	nnewpagewhenlessthan = 0
	Name = "sfreportgroup"

	*-- The group expression
	cexpression = .F.


	PROCEDURE lstartinnewcolumn_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lStartInNewColumn = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lprintoneachpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrintOnEachPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lresetpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lResetPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE nnewpagewhenlessthan_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 9999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nNewPageWhenLessThan = tnValue
		endcase
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcType
		dodefault(toRecord, toReport)
		with This
			lcType = upper(.cBandType)
			if lcType = 'GROUP HEADER'
				lnType = 3
			else
				lnType = 5
			endif lcType = 'GROUP HEADER'
			toRecord.ObjCode   = lnType
			toRecord.Expr      = .cExpression
			toRecord.PageBreak = .lStartOnNewPage or .lResetPage
			toRecord.ColBreak  = .lStartInNewColumn
			toRecord.NoRepeat  = .lPrintOnEachPage
			toRecord.ResetPage = .lResetPage
			toRecord.Width     = .nNewPageWhenLessThan
		endwith
		return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportgroup
**************************************************


**************************************************
*-- Class:        sfreportobject (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportrecord (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/25/99 09:07:10 AM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportobject AS sfreportrecord


	*-- .T. if the object can stretch
	lstretch = .F.
	*-- The vertical position for the object relative to the top of the band
	nvposition = 0
	*-- The horizontal position for the object
	nhposition = 0
	*-- The height of the object
	nheight = 0
	*-- The width of the object
	nwidth = 0
	*-- The alignment for the object: "left", "center", or "right"
	calignment = "Left"
	*-- 0 if the object should float in its band, 1 if it should be positioned relative to the top of the band, or 2 if it should be relative to the bottom of the band
	nfloat = 1
	*-- The object's foreground color (-1 = default)
	nforecolor = -1
	*-- The object's background color (-1 = default)
	nbackcolor = -1
	*-- .T. if the object is transparent, .F. for opaque
	ltransparent = .T.
	*-- .T. to remove a line if there are no objects on it
	lremovelineifblank = .F.
	*-- .T. to print repeated values
	lprintrepeats = .T.
	*-- .T. to print in the first whole band of a new page
	lprintinfirstwholeband = .F.
	*-- .T. to print when the detail band overflows to a new page
	lprintonnewpage = .F.
	*-- The Print When expression
	cprintwhen = ""
	*-- The group number if this object should print on a group change
	nprintongroupchange = 0
	Name = "sfreportobject"


	PROCEDURE nforecolor_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, -1, rgb(255, 255, 255))
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nForeColor = tnValue
		endcase
	ENDPROC


	PROCEDURE nbackcolor_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, -1, rgb(255, 255, 255))
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nBackColor = tnValue
		endcase
	ENDPROC


	PROCEDURE lremovelineifblank_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lRemoveLineIfBlank = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lstretch_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lStretch = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE nfloat_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 2)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nFloat = tnValue
		endcase
	ENDPROC


	PROCEDURE ltransparent_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lTransparent = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE calignment_assign
		lparameter tcValue
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case not inlist(upper(tcValue), upper(ccALIGN_LEFT), ;
				upper(ccALIGN_CENTER), upper(ccALIGN_RIGHT))
				error cnERR_PROPERTY_INVALID
			otherwise
				This.cAlignment = tcValue
		endcase
	ENDPROC


	PROCEDURE lprintrepeats_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrintRepeats = tlValue
			if tlValue
				.lPrintInFirstWholeBand = .T.
				.nPrintOnGroupChange    = 0
				.lPrintOnNewPage        = .F.
			endif tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lprintinfirstwholeband_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrintInFirstWholeBand = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lprintonnewpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lPrintOnNewPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE cprintwhen_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cPrintWhen = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE nprintongroupchange_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nPrintOnGroupChange = tnValue
		endcase
	ENDPROC


	PROCEDURE nheight_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nHeight = tnValue
		endcase
	ENDPROC


	PROCEDURE nwidth_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nWidth = tnValue
		endcase
	ENDPROC


	PROCEDURE nhposition_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nHPosition = tnValue
		endcase
	ENDPROC


	PROCEDURE nvposition_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99999)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nVPosition = tnValue
		endcase
	ENDPROC


	PROCEDURE Init
		lparameters toReport
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcAlign
		dodefault(toRecord, toReport)
		with This

		* Handle the object's height, width, top, and left.

			toRecord.VPos   = .nVPosition
			toRecord.HPos   = .nHPosition
			toRecord.Width  = .nWidth
			toRecord.Height = .nHeight

		* Handle the object's stretch and positioning properties.

			toRecord.Stretch = .lStretch
			do case
				case .nFloat = cnPOSITION_FLOAT
					toRecord.Float  = .T.
					toRecord.Top    = .F.
					toRecord.Bottom = .F.
				case .nFloat = cnPOSITION_TOP
					toRecord.Float  = .F.
					toRecord.Top    = .T.
					toRecord.Bottom = .F.
				case .nFloat = cnPOSITION_BOTTOM
					toRecord.Float  = .F.
					toRecord.Top    = .F.
					toRecord.Bottom = .T.
			endcase

		* Handle the object's color.

			if .nForeColor = -1
				toRecord.PenRed   = -1
				toRecord.PenGreen = -1
				toRecord.PenBlue  = -1
			else
				toRecord.PenRed   = bitand(.nForeColor, 255)
				toRecord.PenGreen = bitrshift(bitand(.nForeColor, 256^2 - 1), 8)
				toRecord.PenBlue  = bitrshift(bitand(.nForeColor, 256^3 - 1), 16)
			endif .nForeColor = -1
			if .nBackColor = -1
				toRecord.FillRed   = -1
				toRecord.FillGreen = -1
				toRecord.FillBlue  = -1
			else
				toRecord.FillRed   = bitand(.nBackColor, 255)
				toRecord.FillGreen = bitrshift(bitand(.nBackColor, 256^2 - 1), 8)
				toRecord.FillBlue  = bitrshift(bitand(.nBackColor, 256^3 - 1), 16)
			endif .nBackColor = -1

		* Handle other properties.

			toRecord.Mode     = iif(.lTransparent, 1, 2)
			toRecord.NoRepeat = .lRemoveLineIfBlank

		* Handle "Print When" properties.

			toRecord.SupAlways  = .lPrintRepeats
			toRecord.SupValChng = not .lPrintRepeats
			toRecord.SuprPCol   = iif(.lPrintInFirstWholeBand, 3, 0)
			toRecord.SupOvFlow  = .lPrintOnNewPage
			toRecord.SupExpr    = .cPrintWhen
			toRecord.SupGroup   = .nPrintOnGroupChange + cnGROUP_OFFSET
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportobject
**************************************************


**************************************************
*-- Class:        sfreportfield (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportobject (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   09/20/08 12:11:04 AM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportfield AS sfreportobject


	*-- The font to use
	cfontname = ""
	*-- The font size to use
	nfontsize = 0
	*-- The expression to display
	cexpression = ""
	*-- The picture for the field
	cpicture = ""
	*-- The total type: "N" for none, "C" for count, "S" for sum, "A" for average, "L" for lowest, "H" for highest, "D" for standard deviation, and "V" for variance
	ctotaltype = "N"
	*-- .T. if the object should be bolded
	lfontbold = .F.
	*-- .T. if the object should be in italics
	lfontitalic = .F.
	*-- .T. if the object should be underlined
	lfontunderline = .F.
	*-- The group number to reset the value on
	nresetongroup = 0
	*-- .T. to reset the variable at the end of each page; .F. to reset at the end of the report
	lresetonpage = .F.
	*-- The data type of the expression: "N" for numeric, "D" for date, and "C" for everything else
	cdatatype = "C"
	*-- A reference to the SFReportFile object this object is attached to
	PROTECTED oreport
	oreport = .NULL.
	nobjecttype = 8
	cdesigncaption = ""
	Name = "sfreportfield"


	PROCEDURE ctotaltype_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			lcType = upper(left(tcValue, 1))
			if inlist(tcValue, ccTOTAL_NONE, ccTOTAL_COUNT, ccTOTAL_SUM, ;
				ccTOTAL_AVERAGE, ccTOTAL_LOWEST, ccTOTAL_HIGHEST, ccTOTAL_STDDEV, ;
				ccTOTAL_VARIANCE)
				This.cTotalType = tcValue
			else
				error cnERR_PROPERTY_INVALID
			endif inlist(tcValue, ...
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE nresetongroup_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nResetOnGroup = tnValue
		endcase
	ENDPROC


	PROCEDURE lresetonpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lResetOnPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE cexpression_assign
		lparameter tcValue
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case empty(tcValue)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.cExpression = tcValue
		endcase
	ENDPROC


	PROCEDURE cfontname_assign
		* Ensure that a valid font name was specified.

		lparameter tcValue
		local laFonts[1], ;
			lnFonts, ;
			lnI, ;
			lnFont, ;
			lnHeight
		with This
			afont(laFonts)
			lnFonts = alen(laFonts)
			for lnI = 1 to lnFonts
				laFonts[lnI] = upper(laFonts[lnI])
			next lnI
			do case
				case vartype(tcValue) <> 'C'
					error cnERR_PROPERTY_TYPE_INVALID
				case empty(tcValue)
					error cnERR_PROPERTY_INVALID
				otherwise
					lnFont = ascan(laFonts, upper(tcValue))
					if lnFont > 0
						lnHeight = .oReport.GetVValue(1, This)
						.cFontName = tcValue
						if .nHeight = lnHeight and not .CalledFromThisClass()
							.nHeight = .oReport.GetVValue(1, This)
						endif .nHeight = lnHeight ...
					else
						error cnERR_PROPERTY_INVALID
					endif lnFont > 0
			endcase
		endwith
	ENDPROC


	PROCEDURE cpicture_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cPicture = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE lfontbold_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lFontBold = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lfontitalic_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lFontItalic = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE lfontunderline_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lFontUnderline = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE nfontsize_assign
		lparameter tnValue
		local lnHeight
		with This
			do case
				case not vartype(tnValue) $ 'NFIBY'
					error cnERR_PROPERTY_TYPE_INVALID
				case not between(tnValue, 0, 99)
					error cnERR_PROPERTY_INVALID
				otherwise
					lnHeight = .oReport.GetVValue(1, This)
					.nFontSize = tnValue
					if .nHeight = lnHeight and not .CalledFromThisClass()
						.nHeight = .oReport.GetVValue(1, This)
					endif .nHeight = lnHeight ...
			endcase
		endwith
	ENDPROC


	PROCEDURE cdatatype_assign
		lparameter tcValue
		do case
			case vartype(tcValue) <> 'C'
				error cnERR_PROPERTY_TYPE_INVALID
			case not inlist(tcValue, 'C', 'N', 'D')
				error cnERR_PROPERTY_INVALID
			otherwise
				This.cDataType = tcValue
		endcase
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcPicture, ;
			lnFontStyle, ;
			lcAlign
		dodefault(toRecord, toReport)
		with This

		* Add quotes around the picture if necessary.

			do case
				case empty(.cPicture)
					lcPicture = ''
				case not left(.cPicture, 1) $ ["']
					lcPicture = '"' + .cPicture + '"'
				otherwise
					lcPicture = .cPicture
			endcase
			toRecord.ObjCode   = 0
			toRecord.Expr      = .cExpression
			toRecord.Picture   = lcPicture
			toRecord.FillChar  = .cDataType

		* Handle the total type and when to reset the total.

			lcType = upper(left(.cTotalType, 1))
			do case
				case lcType = ccTOTAL_NONE
					toRecord.TotalType = 0
				case lcType = ccTOTAL_COUNT
					toRecord.TotalType = 1
				case lcType = ccTOTAL_SUM
					toRecord.TotalType = 2
				case lcType = ccTOTAL_AVERAGE
					toRecord.TotalType = 3
				case lcType = ccTOTAL_LOWEST
					toRecord.TotalType = 4
				case lcType = ccTOTAL_HIGHEST
					toRecord.TotalType = 5
				case lcType = ccTOTAL_STDDEV
					toRecord.TotalType = 6
				case lcType = ccTOTAL_VARIANCE
					toRecord.TotalType = 7
			endcase
			toRecord.ResetTotal = iif(.nResetOnGroup = 0, iif(.lResetOnPage, 2, 1), ;
				.nResetOnGroup + cnGROUP_OFFSET)

		* Handle the font settings.

			lnFontStyle = iif(.lFontBold, cnSTYLE_BOLD, 0) + ;
				iif(.lFontItalic, cnSTYLE_ITALIC, 0) + ;
				iif(.lFontUnderline, cnSTYLE_UNDERLINE, 0)
			lnFontStyle = iif(lnFontStyle = 0, cnSTYLE_NORMAL, lnFontStyle)
			toRecord.FontStyle = lnFontStyle
			toRecord.FontFace  = .cFontName
			toRecord.FontSize  = .nFontSize

		* Handle the object's alignment.

			lcAlign = upper(.cAlignment)
			do case
				case lcAlign = upper(ccALIGN_CENTER)
					toRecord.Offset = cnALIGN_CENTER
				case lcAlign = upper(ccALIGN_RIGHT)
					toRecord.Offset = cnALIGN_RIGHT
				otherwise
					toRecord.Offset = cnALIGN_LEFT
			ENDCASE

			** Trimming
			toRecord.rulerlines = 1

			IF NOT EMPTY(.cDesignCaption)
				toRecord.Name = .cDesignCaption
			ENDIF

		endwith
		return
	ENDPROC


	PROCEDURE Init
		* Set the default height for this object as one "row" high. Use the font name
		* and size of the report as the default for this object.

		lparameters toReport
		with This
			.oReport   = toReport
			.nHeight   = toReport.GetVValue(1, toReport)
			.cFontName = toReport.cFontName
			.nFontSize = toReport.nFontSize
		endwith
	ENDPROC


	PROCEDURE releasemembers
		if vartype(This.oReport) = 'O'
			This.oReport.Release()
		endif vartype(This.oReport) = 'O'
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportfield
**************************************************


**************************************************
*-- Class:        sfreporttext (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportfield (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 05:05:08 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreporttext AS sfreportfield


	nobjecttype = 5
	Name = "sfreporttext"


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcAlignment
		dodefault(toRecord, toReport)
		with This

		* Ensure we have valid properties.

			assert vartype(.cExpression) = 'C' and not empty(.cExpression) ;
				message 'SFReportText: invalid cExpression property'
			assert vartype(.cAlignment) = 'C' ;
				message 'SFReportText: invalid cAlignment property'
			assert vartype(.nWidth) = 'N' ;
				message 'SFReportText: invalid nWidth property'

		* Add quotes around the expression and determine the picture based on the
		* alignment.

			toRecord.Expr = '"' + .cExpression + '"'
			lcAlignment = upper(.cAlignment)
			do case
				case lcAlignment = 'CENTER'
					toRecord.Picture = '"@I"'
				case lcAlignment = 'RIGHT'
					toRecord.Picture = '"@J"'
			endcase

		* If a width wasn't defined, use the width of the expression.

			if .nWidth = 0
				toRecord.Width = toReport.GetHValue(len(.cExpression), This)
			endif .nWidth = 0
		endwith
		return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreporttext
**************************************************


**************************************************
*-- Class:        sfreportimage (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportobject (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 02:52:12 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportimage AS sfreportobject


	*-- The name of the image file or General field that's the source for the image
	cimagesource = ""
	*-- .T. if the image comes from a file; .F. if it comes from a General field
	limagefile = .T.
	*-- How to scale the image: 0 = clip, 1 = isometric, 2 = stretch
	nstretch = 0
	nobjecttype = 17
	Name = "sfreportimage"


	PROCEDURE cimagesource_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cImageSource = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE limagefile_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lImageFile = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE nstretch_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 2)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nStretch = tnValue
		endcase
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		dodefault(toRecord, toReport)
		with This
			if .lImageFile
				if left(.cImageSource, 1) $ ["']
					toRecord.Picture = .cImageSource
				else
					toRecord.Picture = '"' + .cImageSource + '"'
				endif left(.cImageSource, 1) $ ["']
				toRecord.Offset = 0
			else
				toRecord.Name   = .cImageSource
				toRecord.Double = .cAlignment = ccALIGN_CENTER
				toRecord.Offset = 1
			endif .lImageFile
			toRecord.General = .nStretch
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportimage
**************************************************


**************************************************
*-- Class:        sfreportshape (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportobject (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 02:54:10 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportshape AS sfreportobject


	*-- The pen size for the line: 0, 1, 2, 4, or 6
	npensize = 1
	*-- The pen pattern for the object: 0 = none, 1 = dotted, 2 = dashed, 3 = dash-dot, 4 = dash-dot-dot, 8 = normal
	npenpattern = 8
	nobjecttype = 6
	nheight = 0
	Name = "sfreportshape"


	PROCEDURE npenpattern_assign
		* Ensure the pen pattern value is valid.

		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 4) and tnValue <> 8
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nPenPattern = tnValue
		endcase
	ENDPROC


	PROCEDURE npensize_assign
		* Ensure the pen size value is valid.

		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not inlist(tnValue, 0, 1, 2, 4, 6)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nPenSize = tnValue
		endcase
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		dodefault(toRecord, toReport)
		with This
			toRecord.PenSize = .nPenSize
			toRecord.PenPat  = .nPenPattern
		endwith
		return
	ENDPROC


	PROCEDURE nforecolor_assign
		* If the value was saved, update nBackColor to the same color.

		lparameters tnValue
		dodefault(tnValue)
		if vartype(tnValue) $ 'NFIBY' and This.nForeColor = tnValue
			This.nBackColor = tnValue
		endif vartype(tnValue) $ 'NFIBY' ...
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportshape
**************************************************


**************************************************
*-- Class:        sfreportbox (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportshape (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 04:58:01 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportbox AS sfreportshape


	*-- The curvature for the shape (0 = none)
	ncurvature = 0
	*-- .T. to stretch the object relative to the tallest object in the band
	lstretchtotallest = .F.
	nobjecttype = 7
	Name = "sfreportbox"


	PROCEDURE lstretchtotallest_assign
		lparameter tnValue
		if vartype(tnValue) = 'L'
			This.lStretchtoTallest = tnValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tnValue) = 'L'
	ENDPROC


	PROCEDURE ncurvature_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nCurvature = tnValue
		endcase
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		dodefault(toRecord, toReport)
		with This
			toRecord.ObjCode    = 4
			toRecord.Offset     = .nCurvature
			toRecord.StretchTop = .lStretchToTallest
			toRecord.Height     = .nHeight
			toRecord.Width      = .nWidth
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportbox
**************************************************


**************************************************
*-- Class:        sfreportline (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportshape (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/22/99 02:53:01 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportline AS sfreportshape


	*-- .T. if this is a vertical line; otherwise, it's horizontal
	lvertical = .F.
	Name = "sfreportline"


	PROCEDURE lvertical_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lVertical = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		dodefault(toRecord, toReport)
		with This

		* Fix either the width or the height of the line, depending on whether this is
		* a vertical or horizontal line.

			if .lVertical
				toRecord.Width  = - cnFACTOR * .nPenSize
				toRecord.Offset = 0
			else
				toRecord.Height = - cnFACTOR * .nPenSize
				toRecord.Offset = 1
			endif .lVertical
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportline
**************************************************


**************************************************
*-- Class:        sfreportvariable (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- ParentClass:  sfreportrecord (k:\aplvfp\classgen\vcxs\sfrepobj.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   03/24/99 04:36:07 PM
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfrepobj.h"
*
DEFINE CLASS sfreportvariable AS sfreportrecord


	*-- The variable name
	cname = ""
	*-- The value to store
	cvalue = ""
	*-- The initial value
	cinitialvalue = ""
	*-- The total type: "N" for none, "C" for count, "S" for sum, "A" for average, "L" for lowest, "H" for highest, "D" for standard deviation, and "V" for variance
	ctotaltype = "N"
	*-- The group number to reset the variable on
	nresetongroup = 0
	*-- .T. to reset the variable at the end of each page; .F. to reset at the end of the report
	lresetonpage = .F.
	nobjecttype = 18
	*-- .T. to release the variable at the end of the report
	lreleaseatend = .T.
	Name = "sfreportvariable"


	PROCEDURE nresetongroup_assign
		lparameter tnValue
		do case
			case not vartype(tnValue) $ 'NFIBY'
				error cnERR_PROPERTY_TYPE_INVALID
			case not between(tnValue, 0, 99)
				error cnERR_PROPERTY_INVALID
			otherwise
				This.nResetOnGroup = tnValue
		endcase
	ENDPROC


	PROCEDURE lresetonpage_assign
		lparameter tlValue
		if vartype(tlValue) = 'L'
			This.lResetOnPage = tlValue
		else
			error cnERR_PROPERTY_TYPE_INVALID
		endif vartype(tlValue) = 'L'
	ENDPROC


	PROCEDURE cinitialvalue_assign
		lparameter tuValue
		This.cInitialValue = transform(tuValue)
	ENDPROC


	PROCEDURE cname_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			This.cName = tcValue
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE ctotaltype_assign
		lparameter tcValue
		if vartype(tcValue) <> 'C'
			error cnERR_PROPERTY_TYPE_INVALID
		else
			lcType = upper(left(tcValue, 1))
			if inlist(tcValue, ccTOTAL_NONE, ccTOTAL_COUNT, ccTOTAL_SUM, ;
				ccTOTAL_AVERAGE, ccTOTAL_LOWEST, ccTOTAL_HIGHEST, ccTOTAL_STDDEV, ;
				ccTOTAL_VARIANCE)
				This.cTotalType = tcValue
			else
				error cnERR_PROPERTY_INVALID
			endif inlist(tcValue, ...
		endif vartype(tcValue) <> 'C'
	ENDPROC


	PROCEDURE cvalue_assign
		lparameter tuValue
		This.cValue = transform(tuValue)
	ENDPROC


	PROCEDURE createrecord
		lparameters toRecord, ;
			toReport
		local lcType
		dodefault(toRecord, toReport)
		with This
			toRecord.Name   = .cName
			toRecord.Expr   = .cValue
			toRecord.Tag    = .cInitialValue
			toRecord.Unique = .lReleaseAtEnd
			lcType          = upper(left(.cTotalType, 1))
			do case
				case lcType = ccTOTAL_NONE
					toRecord.TotalType = 0
				case lcType = ccTOTAL_COUNT
					toRecord.TotalType = 1
				case lcType = ccTOTAL_SUM
					toRecord.TotalType = 2
				case lcType = ccTOTAL_AVERAGE
					toRecord.TotalType = 3
				case lcType = ccTOTAL_LOWEST
					toRecord.TotalType = 4
				case lcType = ccTOTAL_HIGHEST
					toRecord.TotalType = 5
				case lcType = ccTOTAL_STDDEV
					toRecord.TotalType = 6
				case lcType = ccTOTAL_VARIANCE
					toRecord.TotalType = 7
			endcase
			toRecord.ResetTotal = iif(.nResetOnGroup = 0, iif(.lResetOnPage, 2, 1), ;
				.nResetOnGroup + cnGROUP_OFFSET)
		endwith
		return
	ENDPROC


	PROCEDURE lreleaseatend_assign
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfreportvariable
**************************************************
