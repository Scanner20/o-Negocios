**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\buttons.vcx
**************************************************


**************************************************
*-- Class:        cmdhelp (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/09/95 03:26:12 PM
*-- Brings up the help file, searching for the HelpContextID of the control
*
DEFINE CLASS cmdhelp AS commandbutton


	Caption = "\<Help"
	Height = 30
	Width = 94
	HelpContextID = 15
	Name = "cmdHelp"


	PROCEDURE Click
		HELP ID This.HelpContextID
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdhelp
**************************************************


**************************************************
*-- Class:        cmdok (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   07/20/95 10:14:13 AM
*-- RELEASE THISFORM, default button
*
DEFINE CLASS cmdok AS commandbutton


	Height = 30
	Width = 94
	Caption = "OK"
	Default = .F.
	Name = "cmdok"


	PROCEDURE Click
		IF TYPE("THISFORM.PARENT") = 'O'
			RELEASE THISFORMSET
		ELSE
			RELEASE THISFORM
		ENDIF
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		DO CASE
			CASE nError = 1585 && Update conflict
			  DO CASE
			    CASE INLIST(CURSORGETPROP('Buffering'), 2,3) && Row Buffering
					FOR nField = 1 to FCOUNT(ALIAS())
					cField = FIELD(nField)
					  IF OLDVAL(cField) != CURVAL(cField)
						nChoice = MESSAGEBOX('Data in ' + cField + 'was changed by another user' + ;
							CR_LOC + 'Do you want to save your changes anyway?', 4+48+0, 'Data Conflict')
						IF nChoice = 6 && yes
							=TABLEUPDATE(.F., .T.)
						ELSE
							=TABLEREVERT(.F.)
						ENDIF
					  ENDIF
					ENDFOR
				CASE INLIST(CURSORGETPROP('Buffering'), 4,5)
				nRec = GETNEXTMODIFIED(0)
				DO WHILE nRec > 0
					FOR nField = 1 to FCOUNT(ALIAS())
						cField = FIELD(nField)
						IF OLDVAL(cField) != CURVAL(cField)
						nChoice = MESSAGEBOX('Data in ' + cField + 'was changed by another user' + ;
							CR_LOC + 'Do you want to save your changes anyway?', 4+48+0, 'Data Conflict')
							IF nChoice = 6 && yes
								=TABLEUPDATE(.F., .T.)
							ELSE
								=TABLEREVERT(.F.)
							ENDIF
						ENDIF
					ENDFOR
					nRec = GETNEXTMODIFIED(nRec)
				ENDDO
				ENDCASE
		ENDCASE
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdok
**************************************************


**************************************************
*-- Class:        cmdcancel (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- ParentClass:  cmdok (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/09/95 03:24:10 PM
*-- Release Form or Form Set
*
DEFINE CLASS cmdcancel AS cmdok


	Caption = "Cancel"
	Name = "cmdCancel"


ENDDEFINE
*
*-- EndDefine: cmdcancel
**************************************************


**************************************************
*-- Class:        mailbtn (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   07/19/96 05:15:07 PM
*-- MAPI button to send the current record.
*
DEFINE CLASS mailbtn AS container


	Width = 25
	Height = 25
	BorderWidth = 0
	TabIndex = 1
	BackColor = RGB(192,192,192)
	Name = "mailbtn"
	logsession = .F.


	ADD OBJECT cmdmail AS commandbutton WITH ;
		Top = 0, ;
		Left = 0, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "smmail.bmp", ;
		Caption = "", ;
		TabIndex = 1, ;
		Name = "cmdMail"


	ADD OBJECT olemmess AS olecontrol WITH ;
		Top = -1000, ;
		Left = -1000, ;
		Height = 100, ;
		Width = 100, ;
		Name = "oleMmess"


	ADD OBJECT olemsess AS olecontrol WITH ;
		Top = -1000, ;
		Left = -1000, ;
		Height = 100, ;
		Width = 100, ;
		Name = "olemSess"


	PROCEDURE addtabs
		parameters tcString, tnMaxLength
		#DEFINE TABSPACES	8 	&& Number of characters that will equal 1 TAB
		local i, lnAdd, lnMaxTabs
		lnMaxTabs=int(tnMaxLength/TABSPACES)+1
		lnAdd = lnMaxTabs - INT(len(tcString)/TABSPACES)
		for i = 1 to lnAdd
			tcString = tcString + chr(9)
		endfor
		return tcString
	ENDPROC


	PROCEDURE strippath
		parameters tcString
		IF RAT( "\", tcString) > 0
			tcString = SUBSTR( tcString, RAT( "\", tcString) + 1 )
		ENDIF
		return tcString
	ENDPROC


	PROCEDURE signon
		#DEFINE ERR_NOMAPI_LOC	"It does not appear that you have MAPI installed. Mail could not be run."

		this.logsession = .T.

		IF !FILE(GETENV("WINDIR")+"\SYSTEM32\MAPI32.DLL");
			AND !FILE(GETENV("WINDIR")+"\SYSTEM\MAPI32.DLL")
			MESSAGEBOX(ERR_NOMAPI_LOC)
			RETURN .F.
		ENDIF

		this.OLEMSess.signon
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		=messageb(message(),48)
		this.logsession = .F.
	ENDPROC


	PROCEDURE Init
		this.logsession = .F.
	ENDPROC


	PROCEDURE cmdmail.Error
		LPARAMETERS nError, cMethod, nLine
		=messageb(message(),48)
		IF this.parent.logsession 
			this.parent.OLEMSess.signoff
		ENDIF
		this.parent.logsession = .F.
	ENDPROC


	PROCEDURE cmdmail.Click
		*:*********************************************************************
		*:
		*: 	   Class file: \samples\ole\mapibtn.vcx
		*:
		*:         System: OLE
		*:         Author: Microsoft Corporation
		*:		  Created: 01/04/95
		*:	Last modified: 04/13/95
		*:
		*:
		*:*********************************************************************
		* This is sample class which demonstrates how to use the MAPI controls. 
		*
		* It starts a new Mail session, collects data from the current record, 
		* and brings up the Send Mail dialog with the data inserted as the 
		* message text.
		*
		* To use this example, add this class to a form. You will need to open a
		* table before pressing the Send Mail button. This will work with any 
		* Visual FoxPro table. 
		*
		* This class includes two custom methods addtabs and strippath for
		* formatting the information gathered from the table and inserted in the
		* mail message.
		*
		* This class also takes advantage of another custom method called "signon" 
		* as well as a custom property called logsession. This method and property
		* are necessary for proper error handling of the MAPI server (i.e. MSMail,
		* Exchange, etc.)
		*
		* This class also uses the smmail.bmp and next.bmp as the icons of the button
		* controls.
		*
		* In order for this button to function properly MSMAPI32.OCX must be 
		* correctly registered in the registration database and a mail 
		* application supported by the MAPI controls must be installed. The 
		* MAPI controls do not work with Windows for Workgroups or Windows 3.1.
		*
		***********************************************************************

		local j, lnMaxLength, i, lcMessageText, lvFieldValue
		** j & i are counters

		private array paDBFields

		*** Localizable Strings
		#DEFINE DBF_NOT_FOUND_LOC	"No table is open in the current work area."
		#DEFINE GEN_UNSUPPORT_LOC	"General fields are not supported in this example and will be skipped."
		#DEFINE _FALSE_LOC			"FALSE"
		#DEFINE _TRUE_LOC			"TRUE"
		#DEFINE _NULL_LOC			"NULL"
		#DEFINE _DOLLARSIGN_LOC		"$"
		#DEFINE FLD_NO_PRINT_LOC	"Field could not be printed."
		#DEFINE RECORDNUM_LOC		"Record #"

		* Verify that a table is open in the current work area
		if empty(dbf())
			=messagebox(DBF_NOT_FOUND_LOC,48)
			return
		else
			IF !this.parent.signon()			&& Use the custom method
				RETURN
			ENDIF
			IF this.parent.LogSession	&& Check if the user was able to login
				this.parent.OleMMess.sessionid=this.parent.OleMSess.sessionid

				* Get the number of fields in the current table
				=afields(paDBFields)

				**** find the longest field string for approximate formatting purposes
				lnMaxLength = 0
				for j = 1 to alen(paDBFields,1)
					if len(paDBFields(j,1))+2 > lnMaxLength
						lnMaxLength = len(paDBFields(j,1))+2
					endif
				endfor

				* Start a new mail message and build the text
				this.parent.OleMMess.compose
				lcMessageText=""
				for i = 1 to alen(paDBFields,1)
					lvFieldValue=alltrim(upper(paDBFields(i,1)))
					lcMessageText=lcMessageText+this.parent.addtabs((lvFieldValue+": "),lnMaxLength)
					if !isnull(&lvFieldValue)
						do case
							case paDBFields(i,2)= "N" or paDBFields(i,2)= "B" or paDBFields(i,2)= "F"
								lcMessageText = lcMessageText + alltrim(str(&lvFieldValue))+chr(13)
							case paDBFields(i,2) = "Y"
								lcMessageText = lcMessageText+_DOLLARSIGN_LOC+alltrim(str(&lvFieldValue,10,2))+chr(13)
							case paDBFields(i,2)= "C" or paDBFields(i,2) = "M"
								lcMessageText=lcMessageText + alltrim(&lvFieldValue)+chr(13)
							case paDBFields(i,2)= "G"
								lcMessageText=lcMessageText+GEN_UNSUPPORT_LOC+chr(13)
							case paDBFields(i,2) = "D"
								lcMessageText=lcMessageText + alltrim(DTOC(&lvFieldValue))+chr(13)
							case paDBFields(i,2) = "T"
								lcMessageText = lcMessageText + alltrim(TTOC(&lvFieldValue))+chr(13)
							case paDBFields(i,2) = "L"
								if &lvFieldValue
									lcMessageText = lcMessageText+_TRUE_LOC+chr(13)
								else
									lcMessageText = lcMessageText+_FALSE_LOC+chr(13)
								endif
							otherwise
								lcMessageText = lcMessageText+FLD_NO_PRINT_LOC+chr(13)
						endcase
					else
						lcMessageText=lcMessageText+_NULL_LOC
					endif
				endfor
				this.parent.OleMMess.msgnotetext=lcMessageText
				this.parent.OleMMess.msgsubject=this.parent.strippath(alltrim(dbf()))+": "+RECORDNUM_LOC+alltrim(str(recno()))
				this.parent.OleMMess.send(1)
				IF this.parent.logsession
					this.parent.OleMSess.signoff
				ENDIF	&& Session Handle test
			ENDIF 		&& Login Test
		endif			&& DBF Test

	ENDPROC


ENDDEFINE
*
*-- EndDefine: mailbtn
**************************************************


**************************************************
*-- Class:        vcr (k:\aplvfp\classgen\vcxs\buttons.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   07/04/96 01:48:01 PM
*-- generic vcr buttons
*
DEFINE CLASS vcr AS container


	Width = 104
	Height = 24
	BorderWidth = 1
	BackColor = RGB(192,192,192)
	*-- The table to move the record pointer in .
	skiptable = ""
	enabledisableoninit = .T.
	Name = "vcr"


	ADD OBJECT cmdtop AS commandbutton WITH ;
		Top = 0, ;
		Left = 0, ;
		Height = 24, ;
		Width = 26, ;
		FontBold = .T., ;
		FontName = "Courier New", ;
		FontSize = 11, ;
		Caption = "|<", ;
		TabIndex = 1, ;
		ToolTipText = "Top", ;
		Name = "cmdTop"


	ADD OBJECT cmdprior AS commandbutton WITH ;
		Top = 0, ;
		Left = 26, ;
		Height = 24, ;
		Width = 26, ;
		FontBold = .T., ;
		FontName = "Courier New", ;
		FontSize = 11, ;
		Caption = "<", ;
		TabIndex = 2, ;
		ToolTipText = "Prior", ;
		Name = "cmdPrior"


	ADD OBJECT cmdnext AS commandbutton WITH ;
		Top = 0, ;
		Left = 52, ;
		Height = 24, ;
		Width = 26, ;
		FontBold = .T., ;
		FontName = "Courier New", ;
		FontSize = 11, ;
		Caption = ">", ;
		TabIndex = 3, ;
		ToolTipText = "Next", ;
		Name = "cmdNext"


	ADD OBJECT cmdbottom AS commandbutton WITH ;
		Top = 0, ;
		Left = 78, ;
		Height = 24, ;
		Width = 26, ;
		FontBold = .T., ;
		FontName = "Courier New", ;
		FontSize = 11, ;
		Caption = ">|", ;
		TabIndex = 4, ;
		ToolTipText = "Bottom", ;
		Name = "cmdBottom"


	ADD OBJECT datachecker1 AS datachecker WITH ;
		Top = 6, ;
		Left = 44, ;
		Height = 15, ;
		Width = 23, ;
		Name = "Datachecker1"


	*-- Method called each time the record pointer is moved, basically providing a new event for the class.
	PROCEDURE recordpointermoved
		IF TYPE('_VFP.ActiveForm') = 'O'
			_VFP.ActiveForm.Refresh
		ENDIF
	ENDPROC


	PROCEDURE enabledisablebuttons
		LOCAL nRec, nTop, nBottom
		IF EOF() && Table empty or no records match a filter
			THIS.SetAll("Enabled", .F.)
			RETURN
		ENDIF

		nRec = RECNO()
		GO TOP
		nTop = RECNO()
		GO BOTTOM
		nBottom = RECNO()
		GO nRec

		DO CASE
			CASE nRec = nTop
				THIS.cmdTop.Enabled = .F.
				THIS.cmdPrior.Enabled = .F.
				THIS.cmdNext.Enabled = .T.
				THIS.cmdBottom.Enabled = .T.
			CASE nRec = nBottom
				THIS.cmdTop.Enabled = .T.
				THIS.cmdPrior.Enabled = .T.
				THIS.cmdNext.Enabled = .F.
				THIS.cmdBottom.Enabled = .F.
			OTHERWISE
				THIS.SetAll("Enabled", .T.)
		ENDCASE
	ENDPROC


	PROCEDURE beforerecordpointermoved
		IF !EMPTY(This.SkipTable)
			SELECT (This.SkipTable)
		ENDIF
	ENDPROC


	PROCEDURE Error
		Parameters nError, cMethod, nLine
		#define NUM_LOC "Error Number: "
		#define PROG_LOC "Procedure: "
		#define MSG_LOC "Error Message: "
		#define CR_LOC CHR(13)
		#define SELTABLE_LOC "Select Table:"
		#define OPEN_LOC "Open"
		#define SAVE_LOC "Do you want to save your changes anyway?"
		#define CONFLICT_LOC "Unable to resolve data conflict."

		DO CASE
			CASE nError = 13 && Alias not found
			*-----------------------------------------------------------
			* If the user tries to move the record pointer when no
			* table is open or when an invalid SkipTable property has been
			* specified, prompt the user for a table to open.
			*-----------------------------------------------------------
				cNewTable = GETFILE('DBF', SELTABLE_LOC, OPEN_LOC)
				IF FILE(cNewTable)
					SELECT 0
					USE (cNewTable)
					This.SkipTable = ALIAS()
				ELSE
					This.SkipTable = ""
				ENDIF
			CASE nError = 1585 
			*-----------------------------------------------------------
			* Update conflict handled by datachecker class.
			*-----------------------------------------------------------
				nConflictStatus = THIS.DataChecker1.CheckConflicts()
				IF nConflictStatus = 2
					WAIT WINDOW CONFLICT_LOC
				ENDIF
			OTHERWISE
			*-----------------------------------------------------------
			* Display information about an unanticipated error.
			*-----------------------------------------------------------
				lcMsg = NUM_LOC + ALLTRIM(STR(nError)) + CR_LOC + CR_LOC + ;
						MSG_LOC + MESSAGE( )+ CR_LOC + CR_LOC + ;
						PROG_LOC + PROGRAM(1)
				lnAnswer = MESSAGEBOX(lcMsg, 2+48+512)
				DO CASE
					CASE lnAnswer = 3 &&Abort
						CANCEL
					CASE lnAnswer = 4 &&Retry
						RETRY
					OTHERWISE
						RETURN
				ENDCASE
		ENDCASE
	ENDPROC


	PROCEDURE Init
		IF THIS.EnableDisableOnInit
			THIS.EnableDisableButtons
		ENDIF
	ENDPROC


	PROCEDURE cmdtop.Click
		THIS.Parent.BeforeRecordPointerMoved

		GO TOP

		THIS.Parent.RecordPointerMoved
		THIS.Parent.EnableDisableButtons
	ENDPROC


	PROCEDURE cmdtop.Error
		Parameters nError, cMethod, nLine
		This.Parent.Error(nError, cMethod, nLine)
	ENDPROC


	PROCEDURE cmdprior.Click
		THIS.Parent.BeforeRecordPointerMoved

		SKIP -1
		IF BOF()
			GO TOP
		ENDIF

		THIS.Parent.RecordPointerMoved
		THIS.Parent.EnableDisableButtons
	ENDPROC


	PROCEDURE cmdprior.Error
		Parameters nError, cMethod, nLine
		This.Parent.Error(nError, cMethod, nLine)
	ENDPROC


	PROCEDURE cmdnext.Click
		THIS.Parent.BeforeRecordPointerMoved

		SKIP 1
		IF EOF()
			GO BOTTOM
		ENDIF

		THIS.Parent.RecordPointerMoved
		THIS.Parent.EnableDisableButtons
	ENDPROC


	PROCEDURE cmdnext.Error
		Parameters nError, cMethod, nLine
		This.Parent.Error(nError, cMethod, nLine)
	ENDPROC


	PROCEDURE cmdbottom.Click
		THIS.Parent.BeforeRecordPointerMoved

		GO BOTTOM

		THIS.Parent.EnableDisableButtons
		THIS.Parent.RecordPointerMoved
	ENDPROC


	PROCEDURE cmdbottom.Error
		Parameters nError, cMethod, nLine
		This.Parent.Error(nError, cMethod, nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: vcr
**************************************************
