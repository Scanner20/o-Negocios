**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\sfctrls.vcx
**************************************************


**************************************************
*-- Class:        sfcheckbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   03/01/99 12:15:03 PM
*-- Base class for CheckBox objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcheckbox AS checkbox


	AutoSize = .T.
	BackStyle = 0
	Caption = "Check1"
	Value = .F.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcheckbox"


	*-- Provides documentation for the class
	PROCEDURE about
		*==============================================================================
		* Class:					SFCheckBox
		* Based On:					CheckBox
		* Purpose:					Base class for all CheckBox objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	AutoSize:				.T.
		*	BackStyle:				0 (Transparent)
		*	Value:					.F. since checkboxes usually are used for logical
		*							values
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	Init:					ensure the object is wide enough to display the
		*							caption by resetting AutoSize
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*	When:					prevent the control from receiving focus in a
		*							read-only column
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE When
		* Prevent the checkbox from receiving focus in a read-only column.

		return (upper(This.Parent.BaseClass) <> 'COLUMN' or not This.Parent.ReadOnly)
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE Init
		* Ensure the object is wide enough to display the caption by resetting
		* AutoSize.

		with This
			if .AutoSize
				.AutoSize = .T.
			endif .AutoSize
		endwith
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- Abstract method for custom validation code
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcheckbox
**************************************************


**************************************************
*-- Class:        sfcheckboxgraphical (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  sfcheckbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   03/17/98 10:36:14 AM
*-- Graphical CheckBox
*
DEFINE CLASS sfcheckboxgraphical AS sfcheckbox


	Height = 23
	Width = 23
	AutoSize = .F.
	Caption = ""
	Style = 1
	Name = "sfcheckboxgraphical"


	PROCEDURE about
		*==============================================================================
		* Class:					SFGraphicalCheckBox
		* Based On:					SFCheckBox
		* Purpose:					Graphical CheckBox
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/17/98
		* Include file:				none
		*
		* Changes in "Based On" class properties:
		*	AutoSize:				.F.
		*	Caption:				None
		*	Height:					23
		*	Style:					1 (Graphical)
		*	Width:					23
		*
		* Changes in "Based On" class methods:
		*	None
		*
		* Custom public properties added:
		*	None
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	None
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcheckboxgraphical
**************************************************


**************************************************
*-- Class:        sfcombobox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  combobox
*-- BaseClass:    combobox
*-- Time Stamp:   03/01/99 12:15:10 PM
*-- Base class for ComboBox objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcombobox AS combobox


	RowSourceType = 5
	RowSource = "This.aItems"
	SelectOnEntry = .T.
	Style = 2
	ItemTips = .T.
	BoundTo = .T.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcombobox"

	*-- An array that can hold the values used for the ComboBox when RowSourceType is 5.
	DIMENSION aitems[1]


	*-- Provides documentation for the class
	PROCEDURE about
		*==============================================================================
		* Class:					SFComboBox
		* Based On:					ComboBox
		* Purpose:					Base class for all ComboBox objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BoundTo:				.T.
		*	ItemTips:				.T.
		*	RowSource:				This.aItems (see below)
		*	RowSourceType:			5 (Array)
		*	SelectOnEntry:			.T.
		*	Style:					2 (Dropdown List) because this is what we usually
		*							use
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	Init:					initialize This.aItems to blanks
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*
		* Custom public properties added:
		*	aItems[1]:				an array that can hold the values used for the
		*							ComboBox when RowSourceType is 5
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
		if This.Style = 0
			with toMenu
				.AddMenuBar('Cu\<t',   "sys(1500, '_MED_CUT',   '_MEDIT')")
				.AddMenuBar('\<Copy',  "sys(1500, '_MED_COPY',  '_MEDIT')")
				.AddMenuBar('\<Paste', "sys(1500, '_MED_PASTE', '_MEDIT')")
				.AddMenuBar('Cle\<ar', "sys(1500, '_MED_CLEAR', '_MEDIT')")
				.AddMenuSeparator()
				.AddMenuBar('Se\<lect All', "sys(1500, '_MED_SLCTA', '_MEDIT')")
			endwith
		endif This.Style = 0
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE Init
		* Initialize aItems to a blank string.

		This.aItems = ''
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- An abstract method for custom validation code.
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcombobox
**************************************************


**************************************************
*-- Class:        sfcommandbutton (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/01/99 12:15:14 PM
*-- Base class for CommandButton objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcommandbutton AS commandbutton


	Height = 27
	Width = 84
	Caption = "Command1"
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- .T. if this is used as a "cancel" button.
	lcancel = .F.
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcommandbutton"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFCommandButton
		* Based On:					CommandButton
		* Purpose:					Base class for all CommandButton objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	None
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lCancel:				.T. if this button is used as a "cancel" button
		*							(this allows the Valid of a control to not bother
		*							doing validation if the user clicked a "cancel"
		*							button)
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcommandbutton
**************************************************


**************************************************
*-- Class:        sfcommandgroup (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  commandgroup
*-- BaseClass:    commandgroup
*-- Time Stamp:   03/01/99 12:16:05 PM
*-- Base class for CommandGroup objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcommandgroup AS commandgroup


	ButtonCount = 2
	BackStyle = 0
	Height = 66
	Width = 94
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcommandgroup"
	Command1.Top = 5
	Command1.Left = 5
	Command1.Height = 27
	Command1.Width = 84
	Command1.Caption = "Command1"
	Command1.Name = "Command1"
	Command2.Top = 34
	Command2.Left = 5
	Command2.Height = 27
	Command2.Width = 84
	Command2.Caption = "Command2"
	Command2.Name = "Command2"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFCommandGroup
		* Based On:					CommandGroup
		* Purpose:					Base class for all CommandGroup objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 (Transparent)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Enabled_Access:			sets the Enabled property of the object and all
		*							member objects to the specified value so all
		*							objects appear to be enabled or disabled
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE enabled_assign
		* Enable or disabled member objects.

		lparameters tlEnabled
		This.SetAll('Enabled', tlEnabled)
		This.Enabled = tlEnabled
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcommandgroup
**************************************************


**************************************************
*-- Class:        sfcontainer (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   03/01/99 12:16:09 PM
*-- Base class for Container objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcontainer AS container


	BackStyle = 0
	BorderWidth = 0
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcontainer"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFContainer
		* Based On:					Container
		* Purpose:					Base class for all Container objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 (Transparent)
		*	BorderWidth:			0
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Enabled_Access:			sets the Enabled property of the object and all
		*							member objects to the specified value so all
		*							objects appear to be enabled or disabled
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE enabled_assign
		* Enable or disabled member objects.

		lparameters tlEnabled
		This.SetAll('Enabled', tlEnabled)
		This.Enabled = tlEnabled
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcontainer
**************************************************


**************************************************
*-- Class:        sfcontrol (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  control
*-- BaseClass:    control
*-- Time Stamp:   03/01/99 12:16:14 PM
*-- Base class for Control objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcontrol AS control


	BackStyle = 0
	BorderWidth = 0
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfcontrol"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFControl
		* Based On:					Control
		* Purpose:					Base class for all Controlobjects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 (Transparent)
		*	BorderWidth:			0
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Enabled_Access:			sets the Enabled property of the object and all
		*							member objects to the specified value so all
		*							objects appear to be enabled or disabled
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE enabled_assign
		* Enable or disabled member objects.

		lparameters tlEnabled
		This.SetAll('Enabled', tlEnabled)
		This.Enabled = tlEnabled
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcontrol
**************************************************


**************************************************
*-- Class:        sfcustom (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   03/24/99 01:39:11 PM
*-- Base class for Custom objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfcustom AS custom


	Width = 17
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- .T. as the object is being released
	PROTECTED lrelease
	lrelease = .F.
	Name = "sfcustom"


	*-- Provides documentation for the class
	PROCEDURE about
		*==============================================================================
		* Class:					SFCustom
		* Based On:					Custom
		* Purpose:					Base class for all Custom objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/22/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	Width:					17 so the object is small when dropped on a form
		*
		* Changes in "Based On" class methods:
		*	Destroy:				cleanup as the object is destroyed
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*
		* Custom protected properties added:
		*	lRelease:				.T. as the object is being released
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ReleaseMembers:			abstract method to nuke member references
		*
		* Custom protected methods added:
		*	CalledFromThisClass:	returns .T. if a method was called from this class
		*	Cleanup:				cleans up member references when the object is
		*							released or destroyed
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object. Note the avoidance of "with This" in this code to prevent
		* potential problems with dangling object references.

		if This.lRelease
			nodefault
			return .F.
		endif This.lRelease
		This.Cleanup()
		release This
	ENDPROC


	*-- Cleans up member references when the object is released or destroyed
	PROTECTED PROCEDURE cleanup
		*==============================================================================
		* Method:			Cleanup
		* Status:			Protected
		* Purpose:			Nuke member objects
		* Author:			Doug Hennig
		* Copyright:		(c) 1998 Stonefield Systems Group Inc.
		* Last Revision:	03/24/99
		* Parameters:		none
		* Returns:			.T. if everything succeeded
		* Environment in:	This.lRelease is .T. if we're already in the process of
		*						releasing
		* Environment out:	This.lRelease is .T.
		*					This.oHook is .NULL.
		*					This.ReleaseMembers() was called
		* Notes:			This methods avoids use of "with This" to prevent potential
		*						problems with dangling object references
		*==============================================================================

		if This.lRelease
			return .F.
		endif This.lRelease
		This.lRelease = .T.
		This.ReleaseMembers()
		This.oHook = .NULL.
	ENDPROC


	*-- Return .T. if a method was called from this class
	PROTECTED PROCEDURE calledfromthisclass
		*==============================================================================
		* Method:			CalledFromThisClass
		* Status:			Protected
		* Purpose:			Determines if the method that called this method was called
		*						from a method of this class or not
		* Author:			Doug Hennig
		* Copyright:		(c) 1998 Stonefield Systems Group Inc.
		* Last Revision:	03/16/99
		* Parameters:		none
		* Returns:			.T. if the method that called this method was called from a
		*						method of this class
		* Environment in:	none
		* Environment out:	none
		* Notes:			The reason we want to know if the method that called this
		*						method was called from a method of this class or not is
		*						to permit "read-only" properties to be changed only by
		*						methods of this class. This would typically be called
		*						from an Assign method, such as:
		*
		*					lparameters tuNewValue
		*					if This.CalledFromThisClass()
		*						This.<property> = tuNewValue
		*					else
		*						error 1743, '<property>'   && property is read-only
		*					endif This.CalledFromThisClass()
		*==============================================================================

		local lnLevel, ;
			lcProgram, ;
			lcObject, ;
			lcThisName, ;
			loParent, ;
			llReturn
		lnLevel    = program(-1)
		lcProgram  = iif(lnLevel > 2, upper(program(lnLevel - 2)), '')
		lcObject   = left(lcProgram, rat('.', lcProgram) - 1)
		lcThisName = This.Name
		loParent   = iif(type('This.Parent') = 'O', This.Parent, .NULL.)
		do while vartype(loParent) = 'O'
			lcThisName = loParent.Name + '.' + lcThisName
			loParent   = iif(type('loParent.Parent') = 'O', loParent.Parent, .NULL.)
		enddo while vartype(loParent) = 'O'
		llReturn = upper(lcObject) == upper(lcThisName)
		return llReturn
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Destroy
		* Cleanup as the object is destroyed.

		This.Cleanup()
	ENDPROC


	*-- Abstract method to nuke member references
	PROCEDURE releasemembers
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfcustom
**************************************************


**************************************************
*-- Class:        sfeditbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  editbox
*-- BaseClass:    editbox
*-- Time Stamp:   03/01/99 12:17:10 PM
*-- Base class for EditBox objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfeditbox AS editbox


	SelectOnEntry = .T.
	IntegralHeight = .T.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfeditbox"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFEditBox
		* Based On:					EditBox
		* Purpose:					Base class for all EditBox objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	IntegralHeight:			.T.
		*	SelectOnEntry:			.T.
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
		with toMenu
			.AddMenuBar('Cu\<t',   "sys(1500, '_MED_CUT',   '_MEDIT')")
			.AddMenuBar('\<Copy',  "sys(1500, '_MED_COPY',  '_MEDIT')")
			.AddMenuBar('\<Paste', "sys(1500, '_MED_PASTE', '_MEDIT')")
			.AddMenuBar('Cle\<ar', "sys(1500, '_MED_CLEAR', '_MEDIT')")
			.AddMenuSeparator()
			.AddMenuBar('Se\<lect All', "sys(1500, '_MED_SLCTA', '_MEDIT')")
		endwith
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- An abstract method for custom validation code.
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfeditbox
**************************************************


**************************************************
*-- Class:        sfform (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   03/24/99 01:39:11 PM
*-- The base class for Form objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfform AS form


	ShowWindow = 1
	DoCreate = .T.
	ShowTips = .T.
	AutoCenter = .T.
	Caption = "Form"
	*-- The value to put into the BorderStyle property at runtime.
	nborderstyle = 2
	*-- A reference to an ErrorMgr object.
	oerror = .NULL.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- .T. if an error occurred (set in Error).
	lerroroccurred = .F.
	*-- The index to the last error that occurred in aErrorInfo.
	nlasterror = 0
	*-- A reference to an SFUtility object
	outility = .NULL.
	*-- A reference to an SFMessageMgr object
	omessage = .NULL.
	*-- An object reference to a shortcut menu object
	omenu = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- .T. if the error information has been saved in aErrorInfo
	PROTECTED lerrorinfosaved
	lerrorinfosaved = .F.
	*-- .T. as the object is being released
	PROTECTED lrelease
	lrelease = .F.
	Name = "sfform"

	*-- An array of error information.
	DIMENSION aerrorinfo[1]


	*-- Provides documentation for the class
	PROCEDURE about
		*==============================================================================
		* Class:					SFForm
		* Based On:					Form
		* Purpose:					Base class for all Form objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/24/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	AutoCenter:				.T.
		*	ShowTips:				.T.
		*	ShowWindow:				1 - In Top-level Form
		*
		* Changes in "Based On" class methods:
		*	Deactivate:				ensures the screen is active if visible
		*	Destroy:				hides the form so it disappears faster, and clean
		*							up other things
		*	Error:					calls This.SetError() and This.HandleError()
		*	GotFocus:				calls This.RefreshForm()
		*	Init:					puts the value of the custom nBorderStyle property
		*							into the BorderStyle property. Instantiate
		*							SFUtility and SFMessageMgr objects if necessary
		*	Load:					set up the environment the way we want
		*	Release:				call This.Cleanup()
		*	RightClick:				call This.ShowMenu()
		*	Show:					call SetFocusToFirstObject() so focus goes to the
		*							first object in the form
		*
		* Custom public properties added:
		*	aErrorInfo:				an array of error information
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lErrorOccurred:			.T. if an error occurred (set in SetError)
		*	nBorderStyle:			the value (default = 2, Fixed dialog) to put into
		*							the BorderStyle property at runtime
		*	nLastError:				the index to the last error that occurred in
		*							aErrorInfo
		*	oError:					a reference to an error handling object (default =
		*							.NULL.)
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*	oMessage:				a reference to an SFMessageMgr object (default =
		*							.NULL.)
		*	oUtility:				a reference to an SFUtility object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	lErrorInfoSaved:		.T. if the error information has been saved in
		*							aErrorInfo
		*	lRelease:				.T. as the object is being released
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	ActivateObjectPage:		ensures any page the specified object is sitting on
		*							is the active page
		*	AfterRefresh:			an abstract method of code to execute after a form
		*							is refreshed
		*	BeforeRefresh:			an abstract method of code to execute before a form
		*							is refreshed
		*	FindErrorHandler:		called by the Error method of contained objects to
		*							find a parent that has code in its Error method
		*	HandleError:			handles an error
		*	RefreshForm:			refreshes the form
		*	ReleaseMembers:			abstract method to nuke member references
		*	ResetError:				resets lErrorOccurred, aErrorInfo, and nLastError
		*	SetError:				sets lErrorOccurred and aErrorInfo to information
		*							about the most recent error
		*	SetFocusToFirstObject:	sets focus to the first object in the specified
		*							container
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	CalledFromThisClass:	returns .T. if a method was called from this class
		*	Cleanup:				cleans up member references when the object is
		*							released or destroyed
		*==============================================================================
	ENDPROC


	*-- Find the first parent for a specified object that has code in its Error method
	PROCEDURE finderrorhandler
		*==============================================================================
		* Method:			FindErrorHandler
		* Status:			Public
		* Purpose:			Travel up the containership hierarchy until we find a
		*						parent for the specified object that has code in its
		*						Error method
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		toObject - an object reference to the desired object
		* Returns:			an object reference to the first parent of the specified
		*						object that has code in its Error method if one could
		*						be found, or .NULL. if not
		* Environment in:	none
		* Environment out:	none
		* Note:				this method prevents a problem with controls sitting on
		*						base class Page or Column objects -- no error trapping
		*						gets done if no custom code is directly entered into
		*						these objects
		*==============================================================================

		lparameters toObject
		local loParent
		loParent = toObject.Parent
		do while vartype(loParent) = 'O'
			do case
				case pemstatus(loParent, 'Error', 0)
					exit
				case type('loParent.Parent') = 'O'
					loParent = loParent.Parent
				otherwise
					loParent = .NULL.
			endcase
		enddo while vartype('loParent') = 'O'
		return loParent
	ENDPROC


	*-- Handles an error
	PROCEDURE handleerror
		*==============================================================================
		* Method:			HandleError
		* Status:			Public
		* Purpose:			Handles an error
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		none
		* Returns:			a string indicating the error resolution; see SFERRORS.H
		*						for the possible values
		* Environment in:	This.nErrorInfo points to the row in This.aErrorInfo that
		*						has information about the current error
		* Environment out:	an error message may have been displayed, or some other
		*						error resolution may have been taken
		* Notes:			if This.oError contains an error handling object, its
		*						ErrorHandler method is called
		*					if a global oError contains an error handling object, its
		*						ErrorHandler method is called
		*					if an ON ERROR routine is in effect, it's called
		*					if none of these is true, a generic error message is
		*						displayed
		*==============================================================================

		local lnError, ;
			lcMethod, ;
			lnLine, ;
			lcErrorMessage, ;
			lcErrorInfo, ;
			lcSource, ;
			loError, ;
			lcMessage, ;
			lcReturn, ;
			lcError
		with This
			lnError        = .aErrorInfo[.nLastError, cnAERR_NUMBER]
			lcMethod       = .Name + '.' + .aErrorInfo[.nLastError, cnAERR_METHOD]
			lnLine         = .aErrorInfo[.nLastError, cnAERR_LINE]
			lcErrorMessage = .aErrorInfo[.nLastError, cnAERR_MESSAGE]
			lcErrorInfo    = .aErrorInfo[.nLastError, cnAERR_OBJECT]
			lcSource       = .aErrorInfo[.nLastError, cnAERR_SOURCE]

		* Get a reference to our error handling object if there is one. It could either
		* be a member of the form or a global object.

			do case
				case vartype(.oError) = 'O'
					loError = .oError
				case type('oError.Name') = 'C'
					loError = oError
				otherwise
					loError = .NULL.
			endcase
			lcMessage = ccMSG_ERROR_NUM + ccTAB + ltrim(str(lnError)) + ccCR + ;
				ccMSG_MESSAGE + ccTAB + lcErrorMessage + ;
				ccCR + iif(empty(lcSource), '', ccMSG_CODE + ccTAB + lcSource + ;
				ccCR) + iif(lnLine = 0, '', ccMSG_LINE_NUM + ccTAB + ;
				ltrim(str(lnLine)) + ccCR) + ccMSG_METHOD + ccTAB + lcMethod
			do case

		* If the error is "cannot set focus during valid" or "DataEnvironment already
		* unloaded", we'll let it go.

				case lnError = cnERR_CANT_SET_FOCUS or lnError = cnERR_DE_UNLOADED
					lcReturn = ccMSG_CONTINUE

		* We have an error handling object, so call its ErrorHandler() method.

				case not isnull(loError)
					lcReturn = loError.ErrorHandler(lnError, lcMethod, lnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

				case not empty(on('ERROR'))
					lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
						'SYS(16)',   '"' + lcMethod + '"'), ;
						'PROGRAM()', '"' + lcMethod + '"'), ;
						'ERROR()',   'lnError'), ;
						'LINENO()',  'lnLine'), ;
						'MESSAGE()', 'lcErrorMessage'), ;
						'SYS(2018)', 'lcErrorInfo')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

					if left(lcError, 3) = 'DO '
						&lcError
						lcReturn = ccMSG_CONTINUE
					else
						lcReturn = &lcError
					endif left(lcError, 3) = 'DO '

		* We don't have an error handling object, so display a dialog box.

				otherwise
					lnChoice = messagebox('Error #: ' + ltrim(str(lnError)) + ccCR + ;
						'Message: ' + lcErrorMessage + ccCR + ;
						'Line: ' + ltrim(str(lnLine)) + ccCR + ;
						'Code: ' + lcSource + ccCR + ;
						'Method: ' + lcMethod + ccCR + ;
						'Object: ' + .Name + ccCR + ccCR + ;
						'Choose Yes to display the debugger, No to continue ' + ;
						'without the debugger, or Cancel to cancel execution', ;
						MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
					lcReturn = ccMSG_CONTINUE
					do case
						case lnChoice = IDYES
							lcReturn = ccMSG_DEBUG
						case lnChoice = IDCANCEL
							lcReturn = ccMSG_CANCEL
					endcase
			endcase
		endwith
		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not upper(lcReturn) $ upper(ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ;
			ccMSG_CLOSEFORM + ccMSG_DEBUG), ccMSG_CONTINUE, lcReturn)
		return lcReturn
	ENDPROC


	*-- Resets lErrorOccurred and aErrorInfo.
	PROCEDURE reseterror
		*==============================================================================
		* Method:			ResetError
		* Status:			Public
		* Purpose:			Reset lErrorOccurred and aErrorInfo
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/16/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	This.lErrorOccurred is .F.
		*					This.nLastError is 1
		*					This.aErrorInfo is dimensioned to a single blank row
		*==============================================================================

		with This
			.lErrorOccurred = .F.
			dimension .aErrorInfo[1, cnAERR_MAX]
			.aErrorInfo = ''
			.nLastError = 1
		endwith
	ENDPROC


	*-- Sets lErrorOccurred and aErrorInfo to information about the most recent error.
	PROCEDURE seterror
		*==============================================================================
		* Method:			SetError
		* Status:			Public
		* Purpose:			Handle errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/21/98
		* Parameters:		tcMethod - the method or function the error occurred in
		*					tnLine   - the line number within tcMethod
		*					taError  - an array of error information
		* Returns:			.T.
		* Environment in:	This.aErrorInfo is dimensioned appropriately
		*					This.lErrorSet is .T. if this method has already been called
		*						for this error
		* Environment out:	This.lErrorOccurred is .T.
		*					This.lErrorSet is .T.
		*					This.nLastError points to the current row in This.aErrorInfo
		*					This.aErrorInfo is filled with error information as
		*						follows:
		*
		*					Column	Information
		*					------	-----------
		*					1 - 7	same as AERROR()
		*					8		method error occurred in
		*					9		line error occurred on
		*					10		code causing error
		*					11		date/time error occurred
		*					12		not used
		*==============================================================================

		lparameters tcMethod, ;
			tnLine, ;
			taError
		local lnRows, ;
			lnCols, ;
			lnLast, ;
			lnError, ;
			lnRow, ;
			lnI
		external array taError
		with This

		* If we've already been called, just update the method information.

			if .lErrorInfoSaved
				.aErrorInfo[.nLastError, cnAERR_METHOD] = tcMethod
			else

		* Flag that an error occurred.

				.lErrorOccurred  = .T.
				.lErrorInfoSaved = .T.
				lnRows = alen(taError, 1)
				lnCols = alen(taError, 2)
				lnLast = iif(empty(.aErrorInfo[1, 1]), 0, alen(.aErrorInfo, 1))
				dimension .aErrorInfo[lnLast + lnRows, cnAERR_MAX]

		* For each row in the error array, put each column into our array.

				for lnError = 1 to lnRows
					lnRow = lnLast + lnError
					for lnI = 1 to lnCols
						.aErrorInfo[lnRow, lnI] = taError[lnError, lnI]
					next lnI

		* Add some additional information to the current row in our array.

					.aErrorInfo[lnRow, cnAERR_METHOD]   = tcMethod
					.aErrorInfo[lnRow, cnAERR_LINE]     = tnLine
					.aErrorInfo[lnRow, cnAERR_SOURCE]   = ;
						iif(message(1) = .aErrorInfo[lnRow, cnAERR_MESSAGE], '', ;
						message(1))
					.aErrorInfo[lnRow, cnAERR_DATETIME] = datetime()
				next lnError
				.nLastError = alen(.aErrorInfo, 1)
			endif not .lErrorInfoSaved
		endwith
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	*-- Sets focus to the first object in the specified container
	PROCEDURE setfocustofirstobject
		*==============================================================================
		* Method:			SetFocusToFirstObject
		* Status:			Public
		* Purpose:			Sets focus to the first object in the specified container
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	02/23/99
		* Parameters:		toContainer - the container to check
		* Returns:			.T. if it set focus to an object
		* Environment in:	none
		* Environment out:	if this method returns .T., focus has been set to an object
		*==============================================================================

		lparameters toContainer
		local loContainer, ;
			laObjects[1], ;
			lnObjects, ;
			lnIndex, ;
			loControl, ;
			llReturn, ;
			lnI, ;
			loObject, ;
			lcClass, ;
			lnPage, ;
			loPage

		* If the container wasn't specified, let's use the form.

		loContainer = iif(vartype(toContainer) = 'O', toContainer, This)

		* Get an array of all member objects of the specified container. Initialize
		* some variables.

		lnObjects = amembers(laObjects, loContainer, 2)
		lnIndex   = 99999
		loControl = .NULL.
		llReturn  = .F.

		* Check each of the member objects until we come across the one lowest in the
		* tab order.

		for lnI = 1 to lnObjects
			loObject = evaluate('loContainer.' + laObjects[lnI])
			lcClass  = upper(loObject.BaseClass)
			do case

		* If the object doesn't have a TabIndex property, is a label, is disabled, or
		* isn't visible, ignore it.

				case type('loObject.TabIndex') = 'U' or lcClass = 'LABEL' or ;
					(type('loObject.Enabled') = 'L' and not loObject.Enabled) or ;
					(type('loObject.Visible') = 'L' and not loObject.Visible)

		* If this object is lower in tab order than any we've already seen, grab a
		* reference to it.

				case loObject.TabIndex < lnIndex
					loControl = loObject
					lnIndex   = loObject.TabIndex
			endcase
		next lnI

		* If we found an object, set focus to it. We may need to drill down into it if
		* it's a container.

		if vartype(loControl) = 'O'
			lcClass = upper(loControl.BaseClass)
			do case

		* If this is a pageframe, choose the first page, then call ourselves
		* recursively to find the first object inside it and set focus to it.

				case lcClass = 'PAGEFRAME'
					lnIndex = 99999
					lnPage  = 0
					for lnI = 1 to loControl.PageCount
						loPage = loControl.Pages[lnI]
						if loPage.PageOrder < lnIndex
							lnPage  = lnI
							lnIndex = loPage.PageOrder
						endif loPage.PageOrder < lnIndex
					next loPage
					if lnPage > 0
						if loControl.ActivePage <> lnPage
							loControl.ActivePage = lnPage
						endif loControl.ActivePage <> lnPage
						llReturn = This.SetFocusToFirstObject(loControl.Pages[lnPage])
					endif lnPage > 0

		* If this is an optiongroup or commandgroup (containers which don't have a
		* SetFocus method of their own), call ourselves recursively to find the first
		* object inside it and set focus to it.

				case lcClass $ 'COMMANDGROUP,OPTIONGROUP'
					llReturn = This.SetFocusToFirstObject(loControl)

		* Set focus to the object.

				otherwise
					loControl.SetFocus()
					llReturn = .T.
		endcase
		endif vartype(loControl) = 'O' ...
		return llReturn
	ENDPROC


	*-- Ensures any page the specified object is sitting on is the active page
	PROCEDURE activateobjectpage
		*==============================================================================
		* Method:			ActivateObjectPage
		* Status:			Public
		* Purpose:			Ensures any page the specified object is sitting on is the
		*						active page
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		toObject - an object reference to the desired object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	any page (even if the object is in a container on a
		*						pageframe on a pageframe) the specified object is
		*						sitting on is the active page
		*==============================================================================

		lparameters toObject
		local loParent, ;
			lnPage

		* Ensure the passed parameter is a contained object.

		if vartype(toObject) <> 'O' or type('toObject.Parent') <> 'O'
			error 'Parameter is not a contained object.'
			return .F.
		endif vartype(toObject) <> 'O' ...
		loParent = toObject.Parent
		lnPage   = 0

		* Drill up until we hit the form, activating pages as necessary.

		do while upper(loParent.BaseClass) <> 'FORM'
			do case
				case upper(loParent.BaseClass) == 'PAGE'
					lnPage = loParent.PageOrder
				case upper(loParent.BaseClass) == 'PAGEFRAME' and ;
					loParent.ActivePage <> lnPage
					loParent.ActivePage = lnPage
			endcase
			loParent = loParent.Parent
		enddo while upper(loParent.BaseClass) <> 'FORM'
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object (abstract in this
		*						class)
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items may have been added to the menu in a
		*						subclass of this class
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Refreshes the form
	PROCEDURE refreshform
		*==============================================================================
		* Method:			RefreshForm
		* Status:			Public
		* Purpose:			Refreshes the form
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/16/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	the form has been refreshed and any code in the
		*						BeforeRefresh and AfterRefresh methods has executed
		*==============================================================================

		with This
			.LockScreen = .T.
			.BeforeRefresh()
			.Refresh()
			.AfterRefresh()
			.LockScreen = .F.
		endwith
	ENDPROC


	PROCEDURE GotFocus
		*==============================================================================
		* Method:			GotFocus
		* Status:			Public
		* Purpose:			Called when the window receives focus
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/05/99
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	This.RefreshForm() is called to ensure any BeforeRefresh
		*						and AfterRefresh behaviors are triggered
		*==============================================================================

		This.RefreshForm()
	ENDPROC


	PROCEDURE Init
		*==============================================================================
		* Method:			Init
		* Status:			Public
		* Purpose:			Initializes the object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG can be found
		* Environment out:	if This.Icon is empty, it's set to _screen.Icon
		*					This.BorderStyle is set to This.nBorderStyle
		*					This.oUtility may be set to an existing or may contain a
		*						new SFUtility object
		*					This.oMessage may be set to an existing or may contain a
		*						new SFMessage object
		*==============================================================================

		with This

		* If the Icon property is blank, grab the screen's.

			.Icon = iif(empty(.Icon), _screen.Icon, .Icon)

		* Set the BorderStyle property as desired.

			.BorderStyle = .nBorderStyle

		* Get or create references to SFUtility and SFMessageMgr objects.

			if type('oUtility.Name') = 'C'
				.oUtility = oUtility
			else
				.oUtility = MakeObject('SFUtility', 'SFUtility.vcx')
			endif type('oUtility.Name') = 'C'
			if type('oMessage.Name') = 'C'
				.oMessage = oMessage
			else
				.oMessage = MakeObject('SFMessageMgr', 'SFMessage.vcx', '', .Caption)
			endif type('oMessage.Name') = 'C'
		endwith
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Called when an error occurs in this object or a member
		*						object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError   - the error number
		*					tcMethod  - the method that caused the error
		*					tnLine    - the line number where the error occurred
		*					tcMessage - the error message (optional)
		* Returns:			varies
		* Environment in:	an error has occurred
		* Environment out:	control may be returned to the object/method that caused
		*						the error (either as RETURN or RETRY) or to the routine
		*						containing the READ EVENTS for the application
		*					the form may be released
		*					see This.SetError() and This.HandleError() for other
		*						environmental changes
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine, ;
			tcMessage
		local laError[1], ;
			lcReturn, ;
			lcReturnToOnCancel, ;
			lnPos, ;
			lcObject
		with This

		* Use SetError() and HandleError() to gather error information and handle it.

			aerror(laError)
			.SetError(tcMethod, tnLine, @laError)
			.lErrorInfoSaved = .F.
			lcReturn = .HandleError()

		* Figure out where to go if the user chooses "Cancel".

			do case
				case left(sys(16, 1), at('.', sys(16, 1)) - 1) = 'PROCEDURE ' + ;
					upper(.Name)
					lcReturnToOnCancel = ''
				case type('oError.cReturnToOnCancel') = 'C'
					lcReturnToOnCancel = oError.cReturnToOnCancel
				case type('.oError.cReturnToOnCancel') = 'C'
					lcReturnToOnCancel = .oError.cReturnToOnCancel
				otherwise
					lcReturnToOnCancel = 'MASTER'
			endcase
		endwith

		* Handle the return value, depending on whether the error was "ours" or came
		* from a member.

		lnPos    = at('.', tcMethod)
		lcObject = iif(lnPos = 0, '', upper(left(tcMethod, lnPos - 1)))
		do case

		* We're supposed to close the form, so do so and return to the master program
		* (we'll just cancel if we *are* the master program).

			case lcReturn = ccMSG_CLOSEFORM
				This.Release()
				if empty(lcReturnToOnCancel)
					cancel
				else
					return to &lcReturnToOnCancel
				endif empty(lcReturnToOnCancel)

		* This wasn't our error, so return the error resolution string.

			case lnPos > 0 and not (lcObject == upper(This.Name) or ;
				'DATAENVIRONMENT' $ upper(tcMethod))
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry.

			case lcReturn = ccMSG_RETRY
				retry

		* If Cancel was chosen but the master program is this form, we'll just cancel.

			case lcReturn = ccMSG_CANCEL and empty(lcReturnToOnCancel)
				cancel

		* Cancel was chosen, so return to the master program.

			case lcReturn = ccMSG_CANCEL
				return to &lcReturnToOnCancel

		* Return to the routine in error to continue on.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Destroy
		*==============================================================================
		* Method:			Destroy
		* Status:			Public
		* Purpose:			Called when the object is being destroyed
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	the form and any member objects are destroyed
		*					if oApp exists, its CloseForm() method is called so it
		*						knows we're no longer around
		*==============================================================================

		with This

		* Hide the form so it appears to go away faster.

			.Hide()

		* Cleanup as the object is destroyed.

			.Cleanup()

		* Tell oApp we're closing.

			if type('oApp.Name') = 'C' and pemstatus(oApp, 'CloseForm', 5)
				oApp.CloseForm(.Name)
			endif type('oApp.Name') = 'C' ...
		endwith
	ENDPROC


	PROCEDURE Load
		*==============================================================================
		* Method:			Load
		* Status:			Public
		* Purpose:			Sets up environmental things before the form instantiates
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/09/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	the environment is set up the way we want
		*					the locations of tables in the DataEnvironment may have
		*						been changed
		*==============================================================================

		* Set some environmental things the way we want if we're in a private
		* datasession.

		with This
			if .DataSession = 2
				set talk off
				set safety off
				set deleted on
				set fullpath on
				set exact off
				set unique off
				set multilocks on
				set exclusive off
				set sysformats on
				set century on
				set bell off
			endif .DataSession = 2

		* If the tables haven't been opened yet, set the data directory for all
		* databases and free tables, then open the tables. If we don't have an
		* application object, just open the tables.

			do case
				case type('.DataEnvironment') <> 'O' or ;
					.DataEnvironment.AutoOpenTables
				case type('oApp.Name') = 'C' and pemstatus(oApp, 'SetDataDirectory', 5)
					oApp.SetDataDirectory(.DataEnvironment)
					.DataEnvironment.OpenTables()
				otherwise
					.DataEnvironment.OpenTables()
			endcase
		endwith
	ENDPROC


	PROCEDURE Deactivate
		*==============================================================================
		* Method:			Deactivate
		* Status:			Public
		* Purpose:			Called when another window is activated
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/16/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	if _screen is visible, it's activated in case of BROWSE or
		*						other things that use the current form characteristics
		*==============================================================================

		if _screen.Visible
			activate screen
		endif _screen.Visible
	ENDPROC


	PROCEDURE RightClick
		*==============================================================================
		* Method:			RightClick
		* Status:			Public
		* Purpose:			Display a right-click menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/16/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	a menu may have been displayed and action taken from the
		*						choice the user made
		*==============================================================================

		This.ShowMenu()
	ENDPROC


	PROCEDURE Show
		*==============================================================================
		* Method:			Show
		* Status:			Public
		* Purpose:			Display the form
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		tnStyle - the style for the window
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	focus is set to the first object in the form
		*==============================================================================

		lparameters tnStyle
		local lcType
		lcType = vartype(tnStyle)
		if pcount() = 0 or lcType = 'L' or (lcType = 'N' and tnStyle = This.WindowType)
			This.SetFocusToFirstObject(This)
		endif pcount() = 0 ...
	ENDPROC


	*-- Cleans up member references when the object is released or destroyed
	PROTECTED PROCEDURE cleanup
		*==============================================================================
		* Method:			Cleanup
		* Status:			Protected
		* Purpose:			Nuke member objects
		* Author:			Doug Hennig
		* Copyright:		(c) 1998 Stonefield Systems Group Inc.
		* Last Revision:	03/24/99
		* Parameters:		none
		* Returns:			.T. if everything succeeded
		* Environment in:	This.lRelease is .T. if we're already in the process of
		*						releasing
		* Environment out:	This.lRelease is .T.
		*					This.oHook is .NULL.
		*					This.ReleaseMembers() was called
		* Notes:			This methods avoids use of "with This" to prevent potential
		*						problems with dangling object references
		*==============================================================================

		if This.lRelease
			return .F.
		endif This.lRelease
		This.lRelease = .T.
		This.ReleaseMembers()
		This.oHook    = .NULL.
		This.oError   = .NULL.
		This.oMenu    = .NULL.
		This.oMessage = .NULL.
		This.oUtility = .NULL.
	ENDPROC


	*-- Returns .T. if a method was called from this class
	PROTECTED PROCEDURE calledfromthisclass
		*==============================================================================
		* Method:			CalledFromThisClass
		* Status:			Protected
		* Purpose:			Determines if the method that called this method was called
		*						from a method of this class or not
		* Author:			Doug Hennig
		* Copyright:		(c) 1998 Stonefield Systems Group Inc.
		* Last Revision:	03/16/99
		* Parameters:		none
		* Returns:			.T. if the method that called this method was called from a
		*						method of this class
		* Environment in:	none
		* Environment out:	none
		* Notes:			The reason we want to know if the method that called this
		*						method was called from a method of this class or not is
		*						to permit "read-only" properties to be changed only by
		*						methods of this class. This would typically be called
		*						from an Assign method, such as:
		*
		*					lparameters tuNewValue
		*					if This.CalledFromThisClass()
		*						This.<property> = tuNewValue
		*					else
		*						error 1743, '<property>'   && property is read-only
		*					endif This.CalledFromThisClass()
		*==============================================================================

		local lnLevel, ;
			lcProgram, ;
			lcObject, ;
			lcThisName, ;
			loParent, ;
			llReturn
		lnLevel    = program(-1)
		lcProgram  = iif(lnLevel > 2, upper(program(lnLevel - 2)), '')
		lcObject   = left(lcProgram, rat('.', lcProgram) - 1)
		lcThisName = This.Name
		loParent   = iif(type('This.Parent') = 'O', This.Parent, .NULL.)
		do while vartype(loParent) = 'O'
			lcThisName = loParent.Name + '.' + lcThisName
			loParent   = iif(type('loParent.Parent') = 'O', loParent.Parent, .NULL.)
		enddo while vartype(loParent) = 'O'
		llReturn = upper(lcObject) == upper(lcThisName)
		return llReturn
	ENDPROC


	PROCEDURE Release
		* Release the object. Note the avoidance of "with This" in this code to prevent
		* potential problems with dangling object references.

		if This.lRelease
			nodefault
			return .F.
		endif This.lRelease
		This.Cleanup()
	ENDPROC


	*-- An abstract method of code to execute before a form is refreshed
	PROCEDURE beforerefresh
	ENDPROC


	*-- An abstract method of code to execute after a form is refreshed
	PROCEDURE afterrefresh
	ENDPROC


	*-- Abstract method to nuke member references
	PROCEDURE releasemembers
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfform
**************************************************


**************************************************
*-- Class:        sfmodaldialog (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  sfform (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/04/98 05:14:00 PM
*-- The base class for modal dialogs
*
DEFINE CLASS sfmodaldialog AS sfform


	DoCreate = .T.
	MaxButton = .F.
	MinButton = .F.
	WindowType = 1
	Name = "sfmodaldialog"


	PROCEDURE about
		*==============================================================================
		* Class:					SFModalDialog
		* Based On:					SFForm
		* Purpose:					The base class for modal dialogs
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			12/04/98
		* Include file:				none
		*
		* Changes in "Based On" class properties:
		*	MaxButton:				.F.
		*	MinButton:				.F.
		*	WindowType:				1 (Modal)
		*
		* Changes in "Based On" class methods:
		*	None
		*
		* Custom public properties added:
		*	None
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	None
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfmodaldialog
**************************************************


**************************************************
*-- Class:        sfmodaldialognotitle (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  sfmodaldialog (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/04/98 05:21:05 PM
*-- A modal dialog with no border and title
*
DEFINE CLASS sfmodaldialognotitle AS sfmodaldialog


	DoCreate = .T.
	TitleBar = 0
	Name = "sfmodaldialognotitle"


	PROCEDURE about
		*==============================================================================
		* Class:					SFModalDialogNoTitle
		* Based On:					SFModalDialog
		* Purpose:					Modal dialog with no title bar
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			12/04/98
		* Include file:				none
		*
		* Changes in "Based On" class properties:
		*	TitleBar:				0 - off
		*
		* Changes in "Based On" class methods:
		*	None
		*
		* Custom public properties added:
		*	None
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	None
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfmodaldialognotitle
**************************************************


**************************************************
*-- Class:        sfgrid (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Time Stamp:   03/09/99 05:31:10 PM
*-- The base class for Grid objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfgrid AS grid


	AllowHeaderSizing = .F.
	AllowRowSizing = .F.
	SplitBar = .F.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- The saved BackColor when SetEnabled is called with .F.
	PROTECTED nbackcolor
	nbackcolor = 0
	*-- The record number of the highlighted row
	nrecno = 0
	*-- The forecolor to use for selected rows
	cselectedbackcolor = RGB(0,255,255)
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- .T. to highlight an entire row
	lhighlightentirerow = .T.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the grid has focus
	PROTECTED lgridhasfocus
	lgridhasfocus = .F.
	*-- The forecolor to use for selected rows
	cselectedforecolor = RGB(0,0,0)
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	*-- .T. to automatically call SetupColumns() from Init
	lautosetup = .T.
	Name = "sfgrid"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFGrid
		* Based On:					Grid
		* Purpose:					Base class for all Grid objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/09/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	AllowHeaderSizing:		.F.
		*	AllowRowSizing:			.F.
		*	SplitBar:				.F.
		*
		* Changes in "Based On" class methods:
		*	AfterRowColChange:		code to support row highlighting
		*	BeforeRowColChange:		lock the form so row highlighting works
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	Init:					call This.SetupColumns()
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder (SFGridBuilder)
		*	BuilderX:				holds the name of the preferred custom builder
		*	cSelectedBackColor:		the backcolor to use for selected rows (default 0,
		*							255,255)
		*	cSelectedForeColor:		the forecolor to use for selected rows (default 0,
		*							0,0)
		*	lAutoSetup:				.T. to automatically call SetupColumns() from Init
		*	lHighlightEntireRow:	.T. to highlight an entire row
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	nRecno:					the record number of the highlighted row
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	lGridHasFocus:			.T. if the grid has focus
		*	nBackColor:				the saved BackColor when SetEnabled is called with
		*							.F.
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	GetCaption:				gets the caption for the specified field
		*	Release:				releases the object
		*	SetEnabled:				sets the Enabled property of the object to the
		*							specified value and the BackColor to the
		*							container's BackColor so all object appear to be
		*							enabled or disabled
		*	SetupColumns:			sets up things we need about columns, including the
		*							DynamicBackColor so the selected row is highlighted
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Sets up things we need about columns, including the DynamicBackColor so the selected row is highlighted
	PROCEDURE setupcolumns
		*==============================================================================
		* Method:			SetupColumns
		* Status:			Public
		* Purpose:			Sets up the columns
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/07/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	This.lHighlightRow is .T. if we're supposed to highlight
		*						an entire row
		*					This.cSelectedBackColor is set to the backcolor to
		*						highlight the row with
		*					This.cSelectedForeColor is set to the forecolor to
		*						highlight the row with
		* Environment out:	This.nBackColor is set to This.BackColor
		*					if This.lHighlightEntireRow is .T., the DynamicBackColor
		*						and DynamicForeColor property of each column is set
		*						appropriately and This.nRecno is set to the current
		*						record # of the table
		*					if the table belongs to a database, that database is the
		*						current one
		*					headers with a default caption are changed to the caption
		*						for the field their column displays
		*==============================================================================

		local lcDatabase, ;
			loColumn, ;
			lcCaption
		with This

		* Save the current BackColor to nBackColor (we'll use nBackColor in the
		* SetEnabled method), set the DynamicBackColor of all columns so the selected
		* row is highlighted, and start nRecno at the current record number.

			.nBackColor = .BackColor
			if .lHighlightEntireRow
				.SetAll('DynamicBackColor', ;
					'iif(recno(This.RecordSource) = This.nRecno, rgb(' + ;
					.cSelectedBackColor + '), ' + ltrim(str(.BackColor)) + ')', ;
					'Column')
				.SetAll('DynamicForeColor', ;
					'iif(recno(This.RecordSource) = This.nRecno, rgb(' + ;
					.cSelectedForeColor + '), ' + ltrim(str(.ForeColor)) + ')', ;
					'Column')
				.nRecno = iif(used(.RecordSource), recno(.RecordSource), 1)
			endif .lHighlightEntireRow

		* Ensure the database for the RecordSource (if there is one) is selected.

			lcDatabase = cursorgetprop('DATABASE', .RecordSource)
			if not set('DATABASE') == lcDatabase and not empty(lcDatabase)
				set database to (lcDatabase)
			endif not set('DATABASE') == lcDatabase ...

		* Ensure each column has a valid header caption.

			for each loColumn in .Columns
				for each loObject in loColumn.Controls
					if upper(loObject.BaseClass) = 'HEADER'
						if loObject.Caption = 'Header1'
							lcCaption = .GetCaption(loColumn.ControlSource)
							loObject.Caption = lcCaption
						endif loObject.Caption = 'Header1'
						exit
					endif upper(loObject.BaseClass) = 'HEADER'
				next loObject
			next loColumn
		endwith
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	*-- Gets the caption for the specified field
	PROCEDURE getcaption
		*==============================================================================
		* Method:			GetCaption
		* Status:			Public
		* Purpose:			Get the caption for the specified field
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		tcField - the field to get the caption for
		* Returns:			the caption for the field
		* Environment in:	if the field's table is in a DBC, that DBC is the current
		*						one
		*					oMeta may contain an object reference to DBCXMgr
		* Environment out:	none
		*==============================================================================

		lparameters tcField
		local lcField, ;
			lcCaption
		lcField = substr(tcField, at('.', tcField) + 1)
		do case
			case not empty(dbc()) and indbc(tcField, 'Field')
				lcCaption = dbgetprop(tcField, 'Field', 'Caption')
			case vartype('oMeta') = 'O'
				lcCaption = nvl(oMeta.DBCXGetProp(tcField, 'Field', 'Caption'), '')
			otherwise
				lcCaption = ''
		endcase
		lcCaption = iif(empty(lcCaption), proper(strtran(lcField, '_', ' ')), ;
			lcCaption)
		return lcCaption
	ENDPROC


	PROCEDURE enabled_assign
		* Enable or disabled member objects.

		lparameters tlEnabled
		with This
			.Enabled = tlEnabled
			if tlEnabled
				.BackColor = iif(.nBackColor = 0, .BackColor, .nBackColor)
			else
				.nBackColor = .BackColor
				.BackColor  = .Parent.BackColor
			endif tlEnabled
		endwith
	ENDPROC


	PROCEDURE BeforeRowColChange
		* If we're supposed to highlight the entire row, lock the screen so we don't
		* see anything until after we're done (AfterRowColChange).

		lparameters tnColIndex
		if This.lHighlightEntireRow
			Thisform.LockScreen = This.lGridHasFocus
		endif This.lHighlightEntireRow
	ENDPROC


	PROCEDURE AfterRowColChange
		* If we're supposed to highlight the entire row, save the current record
		* number, refresh the grid, and unlock the screen so we see the changes.

		lparameters tnColIndex
		with This
			if .lHighlightEntireRow
				.nRecno = recno(.RecordSource)
				if not .lGridHasFocus
					.Refresh()
				endif not .lGridHasFocus
				Thisform.LockScreen = .F.
			endif .lHighlightEntireRow
		endwith
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Init
		* Call the SetupColumns method so we can handle highlighting the entire row if
		* necessary.

		with This
			if .lAutoSetup
				.SetupColumns()
			endif .lAutoSetup
		endwith
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE Valid
		This.lGridHasFocus = .F.
	ENDPROC


	PROCEDURE When
		This.lGridHasFocus = .T.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfgrid
**************************************************


**************************************************
*-- Class:        sfimage (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  image
*-- BaseClass:    image
*-- Time Stamp:   03/01/99 12:18:06 PM
*-- The base class for Image objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfimage AS image


	BackStyle = 0
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfimage"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFImage
		* Based On:					Image
		* Purpose:					Base class for all Image objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 (Transparent)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfimage
**************************************************


**************************************************
*-- Class:        sflabel (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   03/01/99 12:18:12 PM
*-- The base class for Label objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sflabel AS label


	AutoSize = .T.
	BackStyle = 0
	Caption = "Label1"
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sflabel"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFLabel
		* Based On:					Label
		* Purpose:					Base class for all Label objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	AutoSize:				.T.
		*	BackStyle:				0 (Transparent)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sflabel
**************************************************


**************************************************
*-- Class:        sfline (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  line
*-- BaseClass:    line
*-- Time Stamp:   03/01/99 12:19:01 PM
*-- The base class for Line objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfline AS line


	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfline"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFLine
		* Based On:					Line
		* Purpose:					Base class for all Line objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	None
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfline
**************************************************


**************************************************
*-- Class:        sfpageactivate (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  sfline (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    line
*-- Time Stamp:   02/22/99 01:55:05 PM
*
DEFINE CLASS sfpageactivate AS sfline


	Visible = .F.
	Name = "sfpageactivate"


	PROCEDURE UIEnable
		LPARAMETERS lEnable
		with Thisform
			if lEnable
				.LockScreen = .T.
				This.Parent.Refresh()
				if pemstatus(Thisform, 'SetFocusToFirstObject', 5)
					.SetFocusToFirstObject(This.Parent)
				endif pemstatus(Thisform, 'SetFocusToFirstObject', 5)
				.LockScreen = .F.
			endif lEnable
		endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfpageactivate
**************************************************


**************************************************
*-- Class:        sflistbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Time Stamp:   03/01/99 12:19:06 PM
*-- The base class for ListBox objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sflistbox AS listbox


	RowSourceType = 5
	RowSource = "This.aItems"
	IntegralHeight = .T.
	ItemTips = .T.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sflistbox"

	*-- An array that can hold the values used for the ListBox when RowSourceType is 5.
	DIMENSION aitems[1]


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFListBox
		* Based On:					ListBox
		* Purpose:					Base class for all ListBox objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	IntegralHeight:			.T.
		*	ItemTips:				.T.
		*	RowSource:				This.aItems (see below)
		*	RowSourceType:			5 (Array)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	Init:					initialize This.aItems to blanks
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	aItems[1]:				an array that can hold the values used for the
		*							ListBox when RowSourceType is 5
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Init
		* Initialize aItems to a blank string.

		This.aItems = ''
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sflistbox
**************************************************


**************************************************
*-- Class:        sfoleboundcontrol (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  oleboundcontrol
*-- BaseClass:    oleboundcontrol
*-- Time Stamp:   03/01/99 12:19:11 PM
*-- The base class for OLEBoundControl objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfoleboundcontrol AS oleboundcontrol


	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	Name = "sfoleboundcontrol"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFOLEBoundControl
		* Based On:					OLEBoundControl
		* Purpose:					The base class for all OLEBoundControl objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	None
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfoleboundcontrol
**************************************************


**************************************************
*-- Class:        sfoptiongroup (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  optiongroup
*-- BaseClass:    optiongroup
*-- Time Stamp:   03/01/99 12:20:02 PM
*-- The base class for OptionGroup objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfoptiongroup AS optiongroup


	ButtonCount = 2
	BackStyle = 0
	Height = 46
	Width = 71
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfoptiongroup"
	Option1.Caption = "Option1"
	Option1.Height = 17
	Option1.Left = 5
	Option1.Top = 5
	Option1.Width = 61
	Option1.Name = "Option1"
	Option2.Caption = "Option2"
	Option2.Height = 17
	Option2.Left = 5
	Option2.Top = 24
	Option2.Width = 61
	Option2.Name = "Option2"

	*-- A reference to an SFShortcutMenu object
	omenu = .F.


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFOptionGroup
		* Based On:					OptionGroup
		* Purpose:					Base class for all OptionGroup objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 (Transparent)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Enabled_Access:			sets the Enabled property of the object and all
		*							member objects to the specified value so all
		*							objects appear to be enabled or disabled
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE enabled_assign
		* Enable or disable member objects.

		lparameters tlEnabled
		This.SetAll('Enabled', tlEnabled)
		This.Enabled = tlEnabled
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- Abstract method for custom validation code
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfoptiongroup
**************************************************


**************************************************
*-- Class:        sfpageframe (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  pageframe
*-- BaseClass:    pageframe
*-- Time Stamp:   03/01/99 12:20:06 PM
*-- The base class for PageFrame objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfpageframe AS pageframe


	ErasePage = .T.
	PageCount = 2
	TabStyle = 1
	ActivePage = 1
	Height = 250
	TabStop = .F.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfpageframe"
	Page1.Caption = "Page1"
	Page1.Name = "Page1"
	Page2.Caption = "Page2"
	Page2.Name = "Page2"


	*-- Provides documentation for the class
	PROCEDURE about
		*==============================================================================
		* Class:					SFPageFrame
		* Based On:					PageFrame
		* Purpose:					Base class for all PageFrame objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	TabStop:				.F. so the user can't set focus to pages from the
		*							keyboard
		*	TabStyle:				1 (Non-justified)
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nuke member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	Init:					add an SFPageActivate object to every page
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	GetPageNumber:			gets the page number in the Pages collection that
		*							matches the specified page order
		*	Release:				releases the object
		*	SetEnabled:				sets the Enabled property of the specified page and
		*							all member objects to the specified value so all
		*							objects appear to be enabled or disabled
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Sets the Enabled property of the specified page and all member objects to the specified value so all objects appear to be enabled or disabled.
	PROCEDURE setenabled
		* If a page is enabled or disabled, so the same for every control on the page
		* so they appear disabled.

		lparameters tnPage, ;
			tlEnabled
		with This.Pages[tnPage]
			if This.ActivePage = tnPage
				.SetAll('Enabled', tlEnabled)
			endif This.ActivePage = tnPage
			.Enabled = tlEnabled
		endwith
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	*-- Gets the page number in the Pages collection that matches the specified page order
	PROCEDURE getpagenumber
		* Gets the page number in the Pages collection that matches the specified page
		* order. These values won't be the same if the PageOrder property for any page
		* has been changed.

		lparameters tnActivePage
		local lnPage
		with This
			lnPage = 0
			for lnI = 1 to .PageCount
				if .Pages[lnI].PageOrder = tnActivePage
					lnPage = lnI
					exit
				endif .Pages[lnI].PageOrder = tnActivePage
			next lnI
		endwith
		return lnPage
	ENDPROC


	PROCEDURE Init
		* Add an SFPageActivate object to every page so when the page gets activated,
		* it gets refreshed and focus is set to the first object on the page.

		local llClassLib, ;
			loPage
		llClassLib = upper(This.ClassLibrary) $ set('CLASSLIB')
		if not llClassLib
			set classlib to (This.ClassLibrary) additive
		endif not llClassLib
		for each loPage in This.Pages
			loPage.AddObject('oActivate', 'SFPageActivate')
		next loPage
		if not llClassLib
			release classlib (This.ClassLibrary)
		endif not llClassLib
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfpageframe
**************************************************


**************************************************
*-- Class:        sfparameter (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/22/99 01:55:02 PM
*
DEFINE CLASS sfparameter AS custom


	Width = 17
	Name = "sfparameter"


	*-- Adds a property if it doesn't exist
	PROCEDURE this_access
		* Add the specified property if it doesn't exist.

		lparameters tcMember
		if not pemstatus(This, tcMember, 5)
			This.AddProperty(tcMember)
		endif not pemstatus(This, tcMember, 5)
		return This
	ENDPROC


	*-- Creates an array property
	PROCEDURE createarray
		* Create an array property.

		lparameters tcArray, ;
			tnRows, ;
			tnColumns
		local lnRows
		lnRows = iif(vartype(tnRows) = 'N', tnRows, 1)
		if vartype(tnColumns) = 'N'
			This.AddProperty(tcArray + '[lnRows, tnColumns]')
		else
			This.AddProperty(tcArray + '[lnRows]')
		endif vartype(tnColumns) = 'N'
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfparameter
**************************************************


**************************************************
*-- Class:        sfseparator (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  separator
*-- BaseClass:    separator
*-- Time Stamp:   12/04/98 05:33:10 PM
*-- The base class for Separator objects
*
DEFINE CLASS sfseparator AS separator


	Height = 0
	Width = 0
	Name = "sfseparator"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFSeparator
		* Based On:					Separator
		* Purpose:					The base class for all Separator objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			12/04/98
		* Include file:				none
		*
		* Changes in "Based On" class properties:
		*	None
		*
		* Changes in "Based On" class methods:
		*	None
		*
		* Custom public properties added:
		*	None
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfseparator
**************************************************


**************************************************
*-- Class:        sfshape (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Time Stamp:   03/01/99 12:20:12 PM
*-- The base class for all Shape objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfshape AS shape


	BackStyle = 0
	SpecialEffect = 0
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfshape"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFShape
		* Based On:					Shape
		* Purpose:					The base class for all Shape objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	BackStyle:				0 - Transparent
		*	SpecialEffect:			0 - 3D
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfshape
**************************************************


**************************************************
*-- Class:        sfspinner (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Time Stamp:   03/01/99 12:21:04 PM
*-- The base class for all Spinner objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sfspinner AS spinner


	SelectOnEntry = .T.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sfspinner"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFSpinner
		* Based On:					Spinner
		* Purpose:					The base class for all Spinner objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	SelectOnEntry:			.T.
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
		with toMenu
			.AddMenuBar('Cu\<t',   "sys(1500, '_MED_CUT',   '_MEDIT')")
			.AddMenuBar('\<Copy',  "sys(1500, '_MED_COPY',  '_MEDIT')")
			.AddMenuBar('\<Paste', "sys(1500, '_MED_PASTE', '_MEDIT')")
			.AddMenuBar('Cle\<ar', "sys(1500, '_MED_CLEAR', '_MEDIT')")
			.AddMenuSeparator()
			.AddMenuBar('Se\<lect All', "sys(1500, '_MED_SLCTA', '_MEDIT')")
		endwith
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- An abstract method for custom validation code.
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfspinner
**************************************************


**************************************************
*-- Class:        sftextbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/01/99 12:22:04 PM
*-- The base class for all TextBox objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sftextbox AS textbox


	SelectOnEntry = .T.
	IntegralHeight = .T.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- .T. if the form's shortcut menu items should be included with this object's
	luseformshortcutmenu = .F.
	Name = "sftextbox"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFTextBox
		* Based On:					TextBox
		* Purpose:					The base class for all TextBox objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	IntegralHeight:			.T.
		*	SelectOnEntry:			.T.
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*	InteractiveChange:		call This.AnyChange()
		*	ProgrammaticChange:		call This.AnyChange()
		*	RightClick:				call This.ShowMenu()
		*	Valid:					prevent validation code from executing if the user
		*							is cancelling, retain focus if a field rule failed,
		*							and call the custom Validation() method
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lUseFormShortcutMenu:	.T. if the form's shortcut menu items should be
		*							included with this object's
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AnyChange:				called by InteractiveChange() and
		*							ProgrammaticChange()
		*	Release:				releases the object
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*	Validation:				abstract method for custom validation code
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
		with toMenu
			.AddMenuBar('Cu\<t',   "sys(1500, '_MED_CUT',   '_MEDIT')")
			.AddMenuBar('\<Copy',  "sys(1500, '_MED_COPY',  '_MEDIT')")
			.AddMenuBar('\<Paste', "sys(1500, '_MED_PASTE', '_MEDIT')")
			.AddMenuBar('Cle\<ar', "sys(1500, '_MED_CLEAR', '_MEDIT')")
			.AddMenuSeparator()
			.AddMenuBar('Se\<lect All', "sys(1500, '_MED_SLCTA', '_MEDIT')")
		endwith
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook, ;
			loForm
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook
			loForm   = Thisform

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...

		* If desired, use the form's shortcut menu as well.

					if .lUseFormShortcutMenu and type('Thisform.Name') = 'C' and ;
						pemstatus(loForm, 'ShortcutMenu', 5)
						loForm.ShortcutMenu(.oMenu, 'loForm')
					endif .lUseFormShortcutMenu ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	PROCEDURE Destroy
		* Nuke member objects.

		This.oHook = .NULL.
		This.oMenu = .NULL.
	ENDPROC


	PROCEDURE Valid
		*==============================================================================
		* Method:			Valid
		* Status:			Public
		* Purpose:			Validate the Value
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/30/98
		* Parameters:		none
		* Returns:			.T. if the validation succeeded or we're not doing the
		*						validation
		* Environment in:	none
		* Environment out:	none
		*==============================================================================

		* If the Valid method is fired because the user clicked on a button with the
		* Cancel property set to .T. or if the button has an lCancel property (which
		* is part of the SFCommandButton base class) and it's .T., or if we're closing
		* the form, don't bother doing the rest of the validation.

		local loObject
		loObject = sys(1270)
		if lastkey() = 27 or (type('loObject.lCancel') = 'L' and loObject.lCancel) or ;
			(type('Thisform.ReleaseType') = 'N' and Thisform.ReleaseType > 0)
			return .T.
		endif lastkey() = 27 ...

		* If the user tries to leave this control but a field validation rule failed,
		* we'll prevent them from doing so.

		if type('Thisform.lFieldRuleFailed') = 'L' and Thisform.lFieldRuleFailed
			Thisform.lFieldRuleFailed = .F.
			return 0
		endif type('Thisform.lFieldRuleFailed') = 'L' ...

		* Do the custom validation (this allows the developer to put custom validation
		* code into the Validation method rather than having to use code like the
		* following in the Valid method:
		*
		* dodefault()
		* custom code here
		* nodefault

		return This.Validation()
	ENDPROC


	PROCEDURE ProgrammaticChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE InteractiveChange
		* Call a common method for handling changes.

		This.AnyChange()
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	*-- Called from the InteractiveChange and ProgrammaticChange events to consolidate change code in one place.
	PROCEDURE anychange
	ENDPROC


	*-- An abstract method for custom validation code.
	PROCEDURE validation
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sftextbox
**************************************************


**************************************************
*-- Class:        sfgridtextbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  sftextbox (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   12/07/98 11:53:13 AM
*-- The base class for TextBox objects in grid columns
*
DEFINE CLASS sfgridtextbox AS sftextbox


	BorderStyle = 0
	Margin = 0
	Name = "sfgridtextbox"


	PROCEDURE about
		*==============================================================================
		* Class:					SFGridTextBox
		* Based On:					SFTextBox (SFCtrls.vcx)
		* Purpose:					The base class for TextBox objects in grid columns
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			12/07/98
		* Include file:				none
		*
		* Changes in "Based On" class properties:
		*	BorderStyle:			0
		*	Height:					15
		*	Margin:					0
		*
		* Changes in "Based On" class methods:
		*	None
		*
		* Custom public properties added:
		*	None
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	None
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sfgridtextbox
**************************************************


**************************************************
*-- Class:        sftimer (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  timer
*-- BaseClass:    timer
*-- Time Stamp:   03/01/99 12:22:08 PM
*-- The base class for all Timer objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sftimer AS timer


	Height = 23
	Width = 23
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	Name = "sftimer"


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFTimer
		* Based On:					Timer
		* Purpose:					The base class for all Timer objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	Height:					23 so the object is small when dropped on a form
		*	Width:					23 so the object is small when dropped on a form
		*
		* Changes in "Based On" class methods:
		*	Destroy:				nukes member objects
		*	Error:					calls the parent Error method so error handling
		*							goes up the containership hierarchy
		*
		* Custom public properties added:
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*
		* Custom protected properties added:
		*	None
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	Release:				releases the object
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Releases the object.
	PROCEDURE release
		* Release the object.

		release This
	ENDPROC


	PROCEDURE Destroy
		* Nuke member properties.

		This.oHook = .NULL.
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Handles errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError  - the error number
		*					tcMethod - the method that caused the error
		*					tnLine   - the line number of the command in error 
		* Returns:			may return an error resolution string (see SFERRORS.H for
		*						a list) or may RETURN, RETRY, or CANCEL
		* Environment in:	if a global error handler object exists, it's in the global
		*						variable oError
		*					a global ON ERROR routine may be in effect
		* Environment out:	depends on the error resolution chosen
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		local laError[1], ;
			lcMethod, ;
			loParent, ;
			lcReturn, ;
			lcError

		* Get information about the error.

		aerror(laError)
		lcMethod = This.Name + '.' + tcMethod

		* If we're sitting on a form and that form has a FindErrorHandler method, call
		* it to travel up the containership hierarchy until we find a parent that has
		* code in its Error method. Also, if it has a SetError method, call it now so
		* we don't lose the message information (which gets messed up by TYPE()).

		if type('Thisform') = 'O'
			loParent = iif(pemstatus(Thisform, 'FindErrorHandler', 5), ;
				Thisform.FindErrorHandler(This), .NULL.)
			if pemstatus(Thisform, 'SetError', 5)
				Thisform.SetError(lcMethod, tnLine, @laError)
			endif pemstatus(Thisform, 'SetError', 5)
		else
			loParent = .NULL.
		endif type('Thisform') = 'O'
		do case

		* We have a parent that can handle the error.

			case not isnull(loParent)
				lcReturn = loParent.Error(tnError, lcMethod, tnLine)

		* We have an error handling object, so call its ErrorHandler() method.

			case type('oError.Name') = 'C'
				oError.SetError(lcMethod, tnLine, @laError)
				lcReturn = oError.ErrorHandler(tnError, lcMethod, tnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

			case not empty(on('ERROR'))
				lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
					'SYS(16)',   '"' + lcMethod + '"'), ;
					'PROGRAM()', '"' + lcMethod + '"'), ;
					'ERROR()',   'tnError'), ;
					'LINENO()',  'tnLine'), ;
					'MESSAGE()', 'laError[2]'), ;
					'SYS(2018)', 'laError[3]')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

				if left(lcError, 3) = 'DO '
					&lcError
					lcReturn = ccMSG_CONTINUE
				else
					lcReturn = &lcError
				endif left(lcError, 3) = 'DO '

		* Display a generic dialog box with an option to display the debugger (this
		* should only occur in a test environment).

			otherwise
				lnChoice = messagebox('Error #: ' + ltrim(str(tnError)) + ccCR + ;
					'Message: ' + laError[2] + ccCR + ;
					'Line: ' + ltrim(str(tnLine)) + ccCR + ;
					'Code: ' + message(1) + ccCR + ;
					'Method: ' + tcMethod + ccCR + ;
					'Object: ' + This.Name + ccCR + ccCR + ;
					'Choose Yes to display the debugger, No to continue ' + ;
					'without the debugger, or Cancel to cancel execution', ;
					MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
				do case
					case lnChoice = IDYES
						lcReturn = ccMSG_DEBUG
					case lnChoice = IDCANCEL
						lcReturn = ccMSG_CANCEL
				endcase
		endcase

		* Ensure the return message is acceptable. If not, assume "CONTINUE".

		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not lcReturn $ ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ccMSG_DEBUG, ;
			ccMSG_CONTINUE, lcReturn)

		* Handle the return value.

		do case

		* It wasn't our error, so pass it back to the calling method.

			case '.' $ tcMethod
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry the command.

			case lcReturn = ccMSG_RETRY
				retry

		* Cancel execution.

			case lcReturn = ccMSG_CANCEL
				cancel

		* Go to the line of code following the error.

			otherwise
				return
		endcase
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sftimer
**************************************************


**************************************************
*-- Class:        sftoolbar (k:\aplvfp\classgen\vcxs\sfctrls.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   03/01/99 01:08:10 PM
*-- The base class for all Toolbar objects
*
#INCLUDE "k:\aplvfp\classgen\vcxs\sfctrls.h"
*
DEFINE CLASS sftoolbar AS toolbar


	Caption = "Toolbar1"
	*-- A reference to an ErrorMgr object.
	oerror = .NULL.
	*-- Tells BUILDER.APP the name of a specific builder to use for this class.
	builder = ""
	*-- .T. if an error occurred (set in Error).
	lerroroccurred = .F.
	*-- The index to the last error that occurred in aErrorInfo.
	nlasterror = 0
	*-- Holds the name of the preferred custom builder
	builderx = ( home() + 'wizards\builderd, builderdform')
	*-- A reference to a hooked object
	ohook = .NULL.
	*-- A reference to an SFShortcutMenu object
	omenu = .NULL
	*-- .T. if the error information has been saved in aErrorInfo
	PROTECTED lerrorinfosaved
	lerrorinfosaved = .F.
	Name = "sftoolbar"

	*-- An array of error information.
	DIMENSION aerrorinfo[1]


	*-- Provides documentation for the class.
	PROCEDURE about
		*==============================================================================
		* Class:					SFToolbar
		* Based On:					Toolbar
		* Purpose:					The base class for all Toolbar objects
		* Author:					Doug Hennig
		* Copyright:				(c) 1996 Stonefield Systems Group Inc.
		* Last revision:			03/01/99
		* Include file:				SFCTRLS.H
		*
		* Changes in "Based On" class properties:
		*	None
		*
		* Changes in "Based On" class methods:
		*	DblClick:				don't undock the toolbar on a double-click
		*	Destroy:				hide the toolbar so it disappears faster and nuke
		*							member objects
		*	Error:					calls This.SetError() and This.HandleError()
		*	RightClick:				call This.ShowMenu()
		*
		* Custom public properties added:
		*	aErrorInfo:				an array of error information
		*	Builder:				holds the name of a custom builder
		*	BuilderX:				holds the name of the preferred custom builder
		*	lErrorOccurred:			.T. if an error occurred (set in Error)
		*	nLastError:				the index to the last error that occurred in
		*							aErrorInfo
		*	oError:					a reference to an error handling object (default =
		*							.NULL.)
		*	oHook:					a reference to a hooked object (default = .NULL.)
		*	oMenu:					a reference to an SFShortcutMenu object (default =
		*							.NULL.)
		*
		* Custom protected properties added:
		*	lErrorInfoSaved:		.T. if the error information has been saved in
		*							aErrorInfo
		*
		* Custom public methods added:
		*	About:					provides documentation for the class
		*	AfterRefresh:			an abstract method of code to execute after a form
		*							is refreshed
		*	BeforeRefresh:			an abstract method of code to execute before a form
		*	FindErrorHandler:		called by the Error method of contained objects to
		*							find a parent that has code in its Error method
		*	HandleError:			calls the ErrorHandler method of the oError object
		*							(if there is a valid one) or displays a generic
		*							error message
		*	RefreshForm:			refreshes the form
		*	ResetError:				resets lErrorOccurred and aErrorInfo
		*	SetError:				sets lErrorOccurred and aErrorInfo to information
		*							about the most recent error
		*	ShortcutMenu:			populates the shortcut menu
		*	ShowMenu:				display a shortcut menu
		*
		* Custom protected methods added:
		*	None
		*==============================================================================
	ENDPROC


	*-- Find the first parent for a specified object that has code in its Error method.
	PROCEDURE finderrorhandler
		*==============================================================================
		* Method:			FindErrorHandler
		* Status:			Public
		* Purpose:			Travel up the containership hierarchy until we find a
		*						parent for the specified object that has code in its
		*						Error method
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		toObject - an object reference to the desired object
		* Returns:			an object reference to the first parent of the specified
		*						object that has code in its Error method if one could
		*						be found, or .NULL. if not
		* Environment in:	none
		* Environment out:	none
		* Note:				this method prevents a problem with controls sitting on
		*						base class Page or Column objects -- no error trapping
		*						gets done if no custom code is directly entered into
		*						these objects
		*==============================================================================

		lparameters toObject
		local loParent
		loParent = toObject.Parent
		do while vartype(loParent) = 'O'
			do case
				case pemstatus(loParent, 'Error', 0)
					exit
				case type('loParent.Parent') = 'O'
					loParent = loParent.Parent
				otherwise
					loParent = .NULL.
			endcase
		enddo while vartype('loParent') = 'O'
		return loParent
	ENDPROC


	*-- Display a shortcut menu
	PROCEDURE showmenu
		*==============================================================================
		* Method:			ShowMenu
		* Status:			Public
		* Purpose:			Displays a shortcut menu
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/15/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	MAKEOBJECT.PRG and SFFFC.VCX can be found (and VARTYPE.PRG
		*						in VFP 5)
		* Environment out:	a menu may have been displayed
		*==============================================================================

		private loObject, ;
			loHook
		with This

		* Define reference to objects we might have menu items from in case the action
		* for a bar is to call a method of an object, which can't be done using "This.
		* Method" ("This" isn't applicable in a menu).

			loObject = This
			loHook   = .oHook

		* Define the menu if it hasn't already been defined.

			if vartype(.oMenu) <> 'O'
				.oMenu = MakeObject('SFShortcutMenu', 'SFFFC.VCX')
				if vartype(.oMenu) = 'O'

		* Populate it using a custom method.

					.ShortcutMenu(.oMenu, 'loObject')

		* Use the hook object (if there is one) to do any further population of the
		* menu.

					if vartype(loHook) = 'O' and pemstatus(loHook, 'ShortcutMenu', 5)
						loHook.ShortcutMenu(.oMenu, 'loHook')
					endif vartype(loHook) = 'O' ...
				endif vartype(.oMenu) = 'O'
			endif vartype(.oMenu) <> 'O'

		* Activate the menu if necessary.

			if vartype(.oMenu) = 'O' and .oMenu.nBarCount > 0
				.oMenu.ShowMenu()
			endif vartype(.oMenu) = 'O' ...
		endwith
	ENDPROC


	*-- Calls the ErrorHandler method of the oError object (if there is a valid one) or displays a generic error message.
	PROCEDURE handleerror
		*==============================================================================
		* Method:			HandleError
		* Status:			Public
		* Purpose:			Handles an error
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		none
		* Returns:			a string indicating the error resolution; see SFERRORS.H
		*						for the possible values
		* Environment in:	This.nErrorInfo points to the row in This.aErrorInfo that
		*						has information about the current error
		* Environment out:	an error message may have been displayed, or some other
		*						error resolution may have been taken
		* Notes:			if This.oError contains an error handling object, its
		*						ErrorHandler method is called
		*					if a global oError contains an error handling object, its
		*						ErrorHandler method is called
		*					if an ON ERROR routine is in effect, it's called
		*					if none of these is true, a generic error message is
		*						displayed
		*==============================================================================

		local lnError, ;
			lcMethod, ;
			lnLine, ;
			lcErrorMessage, ;
			lcErrorInfo, ;
			lcSource, ;
			loError, ;
			lcMessage, ;
			lcReturn, ;
			lcError
		with This
			lnError        = .aErrorInfo[.nLastError, cnAERR_NUMBER]
			lcMethod       = .Name + '.' + .aErrorInfo[.nLastError, cnAERR_METHOD]
			lnLine         = .aErrorInfo[.nLastError, cnAERR_LINE]
			lcErrorMessage = .aErrorInfo[.nLastError, cnAERR_MESSAGE]
			lcErrorInfo    = .aErrorInfo[.nLastError, cnAERR_OBJECT]
			lcSource       = .aErrorInfo[.nLastError, cnAERR_SOURCE]

		* Get a reference to our error handling object if there is one. It could either
		* be a member of the form or a global object.

			do case
				case vartype(.oError) = 'O'
					loError = .oError
				case type('oError.Name') = 'C'
					loError = oError
				otherwise
					loError = .NULL.
			endcase
			lcMessage = ccMSG_ERROR_NUM + ccTAB + ltrim(str(lnError)) + ccCR + ;
				ccMSG_MESSAGE + ccTAB + lcErrorMessage + ;
				ccCR + iif(empty(lcSource), '', ccMSG_CODE + ccTAB + lcSource + ;
				ccCR) + iif(lnLine = 0, '', ccMSG_LINE_NUM + ccTAB + ;
				ltrim(str(lnLine)) + ccCR) + ccMSG_METHOD + ccTAB + lcMethod
			do case

		* If the error is "cannot set focus during valid" or "DataEnvironment already
		* unloaded", we'll let it go.

				case lnError = cnERR_CANT_SET_FOCUS or lnError = cnERR_DE_UNLOADED
					lcReturn = ccMSG_CONTINUE

		* We have an error handling object, so call its ErrorHandler() method.

				case not isnull(loError)
					lcReturn = loError.ErrorHandler(lnError, lcMethod, lnLine)

		* A global error handler is in effect, so let's pass the error on to it.
		* Replace certain parameters passed to the error handler (the name of the
		* program, the error number, the line number, the message, and SYS(2018)) with
		* the appropriate values.

				case not empty(on('ERROR'))
					lcError = strtran(strtran(strtran(strtran(strtran(strtran(upper(on('ERROR')), ;
						'SYS(16)',   '"' + lcMethod + '"'), ;
						'PROGRAM()', '"' + lcMethod + '"'), ;
						'ERROR()',   'lnError'), ;
						'LINENO()',  'lnLine'), ;
						'MESSAGE()', 'lcErrorMessage'), ;
						'SYS(2018)', 'lcErrorInfo')

		* If the error handler is called with DO, macro expand it and assume the return
		* value is "CONTINUE". If the error handler is called as a function (such as an
		* object method), call it and grab the return value if there is one.

					if left(lcError, 3) = 'DO '
						&lcError
						lcReturn = ccMSG_CONTINUE
					else
						lcReturn = &lcError
					endif left(lcError, 3) = 'DO '

		* We don't have an error handling object, so display a dialog box.

				otherwise
					lnChoice = messagebox('Error #: ' + ltrim(str(lnError)) + ccCR + ;
						'Message: ' + lcErrorMessage + ccCR + ;
						'Line: ' + ltrim(str(lnLine)) + ccCR + ;
						'Code: ' + lcSource + ccCR + ;
						'Method: ' + lcMethod + ccCR + ;
						'Object: ' + .Name + ccCR + ccCR + ;
						'Choose Yes to display the debugger, No to continue ' + ;
						'without the debugger, or Cancel to cancel execution', ;
						MB_YESNOCANCEL + MB_ICONSTOP, _VFP.Caption)
					lcReturn = ccMSG_CONTINUE
					do case
						case lnChoice = IDYES
							lcReturn = ccMSG_DEBUG
						case lnChoice = IDCANCEL
							lcReturn = ccMSG_CANCEL
					endcase
			endcase
		endwith
		lcReturn = iif(vartype(lcReturn) <> 'C' or empty(lcReturn) or ;
			not upper(lcReturn) $ upper(ccMSG_CONTINUE + ccMSG_RETRY + ccMSG_CANCEL + ;
			ccMSG_CLOSEFORM + ccMSG_DEBUG), ccMSG_CONTINUE, lcReturn)
		return lcReturn
	ENDPROC


	*-- Sets lErrorOccurred and aErrorInfo to information about the most recent error.
	PROCEDURE seterror
		*==============================================================================
		* Method:			SetError
		* Status:			Public
		* Purpose:			Handle errors
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/21/98
		* Parameters:		tcMethod - the method or function the error occurred in
		*					tnLine   - the line number within tcMethod
		*					taError  - an array of error information
		* Returns:			.T.
		* Environment in:	This.aErrorInfo is dimensioned appropriately
		*					This.lErrorSet is .T. if this method has already been called
		*						for this error
		* Environment out:	This.lErrorOccurred is .T.
		*					This.lErrorSet is .T.
		*					This.nLastError points to the current row in This.aErrorInfo
		*					This.aErrorInfo is filled with error information as
		*						follows:
		*
		*					Column	Information
		*					------	-----------
		*					1 - 7	same as AERROR()
		*					8		method error occurred in
		*					9		line error occurred on
		*					10		code causing error
		*					11		date/time error occurred
		*					12		not used
		*==============================================================================

		lparameters tcMethod, ;
			tnLine, ;
			taError
		local lnRows, ;
			lnCols, ;
			lnLast, ;
			lnError, ;
			lnRow, ;
			lnI
		external array taError
		with This

		* If we've already been called, just update the method information.

			if .lErrorInfoSaved
				.aErrorInfo[.nLastError, cnAERR_METHOD] = tcMethod
			else

		* Flag that an error occurred.

				.lErrorOccurred  = .T.
				.lErrorInfoSaved = .T.
				lnRows = alen(taError, 1)
				lnCols = alen(taError, 2)
				lnLast = iif(empty(.aErrorInfo[1, 1]), 0, alen(.aErrorInfo, 1))
				dimension .aErrorInfo[lnLast + lnRows, cnAERR_MAX]

		* For each row in the error array, put each column into our array.

				for lnError = 1 to lnRows
					lnRow = lnLast + lnError
					for lnI = 1 to lnCols
						.aErrorInfo[lnRow, lnI] = taError[lnError, lnI]
					next lnI

		* Add some additional information to the current row in our array.

					.aErrorInfo[lnRow, cnAERR_METHOD]   = tcMethod
					.aErrorInfo[lnRow, cnAERR_LINE]     = tnLine
					.aErrorInfo[lnRow, cnAERR_SOURCE]   = ;
						iif(message(1) = .aErrorInfo[lnRow, cnAERR_MESSAGE], '', ;
						message(1))
					.aErrorInfo[lnRow, cnAERR_DATETIME] = datetime()
				next lnError
				.nLastError = alen(.aErrorInfo, 1)
			endif not .lErrorInfoSaved
		endwith
	ENDPROC


	*-- Resets lErrorOccurred and aErrorInfo.
	PROCEDURE reseterror
		*==============================================================================
		* Method:			ResetError
		* Status:			Public
		* Purpose:			Reset lErrorOccurred and aErrorInfo
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/16/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	This.lErrorOccurred is .F.
		*					This.nLastError is 1
		*					This.aErrorInfo is dimensioned to a single blank row
		*==============================================================================

		with This
			.lErrorOccurred = .F.
			dimension .aErrorInfo[1, cnAERR_MAX]
			.aErrorInfo = ''
			.nLastError = 1
		endwith
	ENDPROC


	*-- Populates the shortcut menu
	PROCEDURE shortcutmenu
		*==============================================================================
		* Method:			ShortcutMenu
		* Status:			Public
		* Purpose:			Populates the specified menu object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/11/98
		* Parameters:		toMenu   - an object reference to a menu object
		*					tcObject - the name of the variable containing the object
		*						reference to this object
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	additional items were added to the menu
		*==============================================================================

		lparameters toMenu, ;
			tcObject
	ENDPROC


	*-- Refreshes the form
	PROCEDURE refreshform
		*==============================================================================
		* Method:			RefreshForm
		* Status:			Public
		* Purpose:			Refreshes the form
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	11/04/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	the form has been refreshed and any code in the
		*						BeforeRefresh and AfterRefresh methods has executed
		*==============================================================================

		with This
			.LockScreen = .T.
			.BeforeRefresh()
			.Refresh()
			.AfterRefresh()
			.LockScreen = .F.
		endwith
	ENDPROC


	PROCEDURE DblClick
		* Don't undock the toolbar on a double-click.

		nodefault
	ENDPROC


	PROCEDURE Destroy
		*==============================================================================
		* Method:			Destroy
		* Status:			Public
		* Purpose:			Called when the object is being destroyed
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	12/04/98
		* Parameters:		none
		* Returns:			.T.
		* Environment in:	none
		* Environment out:	the toolbar and any member objects are destroyed
		*==============================================================================

		with This

		* Hide the toolbar so it appears to go away faster.

			.Hide()

		* Nuke our member objects.

			.oError = .NULL.
			.oHook  = .NULL.
			.oMenu  = .NULL.
		endwith
	ENDPROC


	PROCEDURE Error
		*==============================================================================
		* Method:			Error
		* Status:			Public
		* Purpose:			Called when an error occurs in this object or a member
		*						object
		* Author:			Doug Hennig
		* Copyright:		(c) 1996 Stonefield Systems Group Inc.
		* Last revision:	03/01/99
		* Parameters:		tnError   - the error number
		*					tcMethod  - the method that caused the error
		*					tnLine    - the line number where the error occurred
		*					tcMessage - the error message (optional)
		* Returns:			varies
		* Environment in:	an error has occurred
		* Environment out:	control may be returned to the object/method that caused
		*						the error (either as RETURN or RETRY) or to the routine
		*						containing the READ EVENTS for the application
		*					the form may be released
		*					see This.SetError() and This.HandleError() for other
		*						environmental changes
		*==============================================================================

		lparameters tnError, ;
			tcMethod, ;
			tnLine, ;
			tcMessage
		local laError[1], ;
			lcReturn, ;
			lcReturnToOnCancel, ;
			lnPos, ;
			lcObject
		with This

		* Use SetError() and HandleError() to gather error information and handle it.

			aerror(laError)
			.SetError(tcMethod, tnLine, @laError)
			.lErrorInfoSaved = .F.
			lcReturn = .HandleError()

		* Figure out where to go if the user chooses "Cancel".

			do case
				case left(sys(16, 1), at('.', sys(16, 1)) - 1) = 'PROCEDURE ' + ;
					upper(.Name)
					lcReturnToOnCancel = ''
				case type('oError.cReturnToOnCancel') = 'C'
					lcReturnToOnCancel = oError.cReturnToOnCancel
				case type('.oError.cReturnToOnCancel') = 'C'
					lcReturnToOnCancel = .oError.cReturnToOnCancel
				otherwise
					lcReturnToOnCancel = 'MASTER'
			endcase
		endwith

		* Handle the return value, depending on whether the error was "ours" or came
		* from a member.

		lnPos    = at('.', tcMethod)
		lcObject = iif(lnPos = 0, '', upper(left(tcMethod, lnPos - 1)))
		do case

		* We're supposed to close the form, so do so and return to the master program
		* (we'll just cancel if we *are* the master program).

			case lcReturn = ccMSG_CLOSEFORM
				This.Release()
				if empty(lcReturnToOnCancel)
					cancel
				else
					return to &lcReturnToOnCancel
				endif empty(lcReturnToOnCancel)

		* This wasn't our error, so return the error resolution string.

			case lnPos > 0 and not (lcObject == upper(This.Name) or ;
				'DATAENVIRONMENT' $ upper(tcMethod))
				return lcReturn

		* Display the debugger.

			case lcReturn = ccMSG_DEBUG
				debug
				suspend

		* Retry.

			case lcReturn = ccMSG_RETRY
				retry

		* If Cancel was chosen but the master program is this form, we'll just cancel.

			case lcReturn = ccMSG_CANCEL and empty(lcReturnToOnCancel)
				cancel

		* Cancel was chosen, so return to the master program.

			case lcReturn = ccMSG_CANCEL
				return to &lcReturnToOnCancel

		* Return to the routine in error to continue on.

			otherwise
				return
		endcase
	ENDPROC


	PROCEDURE RightClick
		* Display a right-click menu.

		This.ShowMenu()
	ENDPROC


	*-- An abstract method of code to execute after a form is refreshed
	PROCEDURE afterrefresh
	ENDPROC


	*-- An abstract method of code to execute before a form is refreshed
	PROCEDURE beforerefresh
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sftoolbar
**************************************************
