oForm = createobject('mediaplayermover')
oForm.show
read events

**************************************************
*-- Class: mediaplayermover (c:\_mywork\mediaplayer\mediaplayer.vcx)
*-- ParentClass: form
*-- BaseClass: form
*-- Time Stamp: 07/15/05 11:50:05 PM
*-- Form class that accesses the Windows Media Player to randomly copy songs to a folder of the users choosing
*
DEFINE CLASS mediaplayermover AS form

Height = 380
Width = 544
DoCreate = .T.
Comment = "Author: Jeff9000 (FREEWARE)"
AutoCenter = .T.
Caption = "Random Copy from Windows Media Player Rock Genre - Freeware!"
AllowOutput = .F.
owmp = ""
*-- XML Metadata for customizable properties
Name = "frmMain"


ADD OBJECT cmdcopy AS commandbutton WITH ;
	Top = 336, ;
	Left = 312, ;
	Height = 31, ;
	Width = 103, ;
	Caption = "Copy Songs", ;
	Default = .T., ;
	TabIndex = 8, ;
	Name = "cmdCopy"


ADD OBJECT cmdcancel AS commandbutton WITH ;
	Top = 336, ;
	Left = 426, ;
	Height = 31, ;
	Width = 103, ;
	Caption = "Cancel", ;
	TabIndex = 9, ;
	Name = "cmdCancel"


ADD OBJECT spnnumber AS spinner WITH ;
	Enabled = .F., ;
	Height = 22, ;
	KeyboardHighValue = 10000, ;
	KeyboardLowValue = 0, ;
	Left = 396, ;
	SpinnerHighValue = 10000.00, ;
	SpinnerLowValue = 0.00, ;
	TabIndex = 3, ;
	Top = 24, ;
	Width = 72, ;
	Name = "spnNumber"


ADD OBJECT spnsize AS spinner WITH ;
	Height = 22, ;
	KeyboardHighValue = 1000, ;
	KeyboardLowValue = 0, ;
	Left = 216, ;
	SpinnerHighValue = 1000.00, ;
	SpinnerLowValue = 0.00, ;
	TabIndex = 2, ;
	Top = 24, ;
	Width = 72, ;
	Value = 250, ;
	Name = "spnSize"


ADD OBJECT opgwhich AS optiongroup WITH ;
	AutoSize = .T., ;
	ButtonCount = 2, ;
	Value = 1, ;
	Height = 46, ;
	Left = 12, ;
	Top = 12, ;
	Width = 132, ;
	TabIndex = 1, ;
	Name = "opgWhich", ;
	Option1.Caption = "By Size (MB)", ;
	Option1.Value = 1, ;
	Option1.Height = 17, ;
	Option1.Left = 5, ;
	Option1.Top = 5, ;
	Option1.Width = 85, ;
	Option1.AutoSize = .T., ;
	Option1.Name = "Option1", ;
	Option2.Caption = "By Number of Files", ;
	Option2.Height = 17, ;
	Option2.Left = 5, ;
	Option2.Top = 24, ;
	Option2.Width = 122, ;
	Option2.AutoSize = .T., ;
	Option2.Name = "Option2"


ADD OBJECT label1 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Number of files", ;
	Height = 17, ;
	Left = 294, ;
	Top = 27, ;
	Width = 86, ;
	TabIndex = 10, ;
	Name = "Label1"


ADD OBJECT label2 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Size", ;
	Height = 17, ;
	Left = 180, ;
	Top = 27, ;
	Width = 25, ;
	TabIndex = 11, ;
	Name = "Label2"


ADD OBJECT txtfolder AS textbox WITH ;
	Height = 24, ;
	Left = 84, ;
	TabIndex = 5, ;
	Top = 72, ;
	Width = 372, ;
	AutoComplete = 2, ;
	AutoCompSource = "mediaplayerfolder", ;
	Name = "txtFolder"


ADD OBJECT cmdfolder AS commandbutton WITH ;
	Top = 72, ;
	Left = 12, ;
	Height = 25, ;
	Width = 67, ;
	Caption = "Dest. Folder", ;
	TabIndex = 4, ;
	Name = "cmdFolder"


ADD OBJECT txtcopyingnow AS textbox WITH ;
	Height = 24, ;
	Left = 84, ;
	TabIndex = 12, ;
	TabStop = .F., ;
	Top = 174, ;
	Width = 444, ;
	Name = "txtCopyingNow"


ADD OBJECT label3 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Copying", ;
	Height = 17, ;
	Left = 12, ;
	Top = 150, ;
	Width = 47, ;
	TabIndex = 17, ;
	Name = "Label3"


ADD OBJECT txtbytes AS textbox WITH ;
	Alignment = 1, ;
	Value = 0, ;
	Height = 24, ;
	InputMask = "999,999,999,999", ;
	Left = 84, ;
	TabIndex = 19, ;
	TabStop = .F., ;
	Top = 252, ;
	Width = 114, ;
	Name = "txtBytes"


ADD OBJECT bytes AS label WITH ;
	AutoSize = .T., ;
	Caption = "Bytes", ;
	Height = 17, ;
	Left = 12, ;
	Top = 256, ;
	Width = 32, ;
	TabIndex = 21, ;
	Name = "Bytes"


ADD OBJECT txtfiles AS textbox WITH ;
	Alignment = 1, ;
	Value = 0, ;
	Height = 24, ;
	InputMask = "999,999,999,999", ;
	Left = 264, ;
	TabIndex = 22, ;
	TabStop = .F., ;
	Top = 252, ;
	Width = 114, ;
	Name = "txtFiles"


ADD OBJECT label4 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Files", ;
	Height = 17, ;
	Left = 222, ;
	Top = 256, ;
	Width = 29, ;
	TabIndex = 23, ;
	Name = "Label4"


ADD OBJECT txtrand AS textbox WITH ;
	Alignment = 3, ;
	Value = 0, ;
	Height = 24, ;
	InputMask = "999,999,999,999", ;
	Left = 438, ;
	TabIndex = 24, ;
	TabStop = .F., ;
	Top = 252, ;
	Width = 90, ;
	Name = "txtRand"


ADD OBJECT label5 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Rand", ;
	Height = 17, ;
	Left = 396, ;
	Top = 256, ;
	Width = 32, ;
	TabIndex = 25, ;
	Name = "Label5"


ADD OBJECT txtfromfolder AS textbox WITH ;
	Height = 24, ;
	Left = 84, ;
	TabIndex = 15, ;
	TabStop = .F., ;
	Top = 144, ;
	Width = 444, ;
	Name = "txtFromFolder"


ADD OBJECT txtstatus AS textbox WITH ;
	Value = "Ready", ;
	Height = 24, ;
	Left = 84, ;
	TabIndex = 14, ;
	TabStop = .F., ;
	Top = 294, ;
	Width = 444, ;
	Name = "txtStatus"


ADD OBJECT label6 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Status", ;
	Height = 17, ;
	Left = 12, ;
	Top = 300, ;
	Width = 37, ;
	TabIndex = 20, ;
	Name = "Label6"


ADD OBJECT label7 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Genre", ;
	Height = 17, ;
	Left = 12, ;
	Top = 114, ;
	Width = 36, ;
	TabIndex = 16, ;
	Name = "Label7"


ADD OBJECT txtdestfilename AS textbox WITH ;
	Height = 24, ;
	Left = 102, ;
	TabIndex = 13, ;
	TabStop = .F., ;
	Top = 204, ;
	Width = 426, ;
	Name = "txtDestFilename"


ADD OBJECT label8 AS label WITH ;
	AutoSize = .T., ;
	Caption = "Dest. Filename", ;
	Height = 17, ;
	Left = 12, ;
	Top = 208, ;
	Width = 86, ;
	TabIndex = 18, ;
	Name = "Label8"


ADD OBJECT cbogenre AS combobox WITH ;
	Height = 25, ;
	Left = 84, ;
	Style = 2, ;
	TabIndex = 6, ;
	Top = 108, ;
	Width = 187, ;
	Name = "cboGenre"



ADD OBJECT chkdeletedestination AS checkbox WITH ;
	Top = 336, ;
	Left = 84, ;
	Height = 17, ;
	Width = 187, ;
	AutoSize = .T., ;
	Alignment = 0, ;
	Caption = "Delete *.* in Destination Folder", ;
	Value = .T., ;
	TabIndex = 7, ;
	Name = "chkDeleteDestination"


ADD OBJECT cmdgoto AS commandbutton WITH ;
	Top = 72, ;
	Left = 462, ;
	Height = 25, ;
	Width = 67, ;
	Caption = "Goto", ;
	TabIndex = 4, ;
	Name = "cmdGoto"


**********************************
**********************************
**********************************
PROCEDURE gourl
LPARAMETERS tcUrl as Character, tcOptionalAction as Character, tcOptionalDirectory as Character, tcOptionalParms as Character
******************
*** Author: Rick Strahl
*** (c) West Wind Technologies, 1996
*** Contact: rstrahl@west-wind.com
*** Modified: 03/14/96
*** procedure: Starts associated Web Browser
*** and goes to the specified URL.
*** If Browser is already open it
*** reloads the page.
*** Assume: Works only on Win95 and NT 4.0
*** Pass: tcUrl - The URL of the site or
*** HTML page to bring up
*** in the Browser
*** Return: 2 - Bad Association (invalid URL)
*** 31 - No application association
*** 29 - Failure to load application
*** 30 - Application is busy
***
*** Values over 32 indicate success
*** and return an instance handle for
*** the application started (the browser)
****************************************************
if empty(m.tcUrl)
    return -1
endif
if empty(m.tcOptionalAction)
    tcOptionalAction = "OPEN"
endif
if empty(m.tcOptionalDirectory)
    tcOptionalDirectory = sys(2023)
endif
if empty(m.tcOptionalParms)
    tcOptionalParms = ""
endif

*#beautify keyword_nochange

return ShellExec(FindWindow(0,_screen.caption),;
                        m.tcOptionalAction,;
                        m.tcUrl,;
                        m.tcOptionalParms,;
                        m.tcOptionalDirectory,;
                        1)

*#beautify
ENDPROC

**********************************
**********************************
**********************************
PROCEDURE destroy
clear events
endproc

**********************************
**********************************
**********************************
PROCEDURE Init

declare integer ShellExecute in SHELL32.dll as shellexec;
	integer nWinHandle,;
	string cOperation,;
	string cFileName,;
	string cParameters,;
	string cDirectory,;
	integer nShowWindow

declare integer FindWindow in WIN32API string cNull, string cWinName

this.oWmp = createobject('wmplayer.ocx.7') &&originally was: createobject('wmplayer.ocx.7')
*this.oWmp.visible = .f.

this.cbogenre.Init2

ENDPROC


**********************************
**********************************
**********************************
PROCEDURE cmdcopy.Click
local loGenres as Object
local loitem as Object
local lnPower as Integer
local lnMaxSize as Integer
local lnRand as Double
local lnFiles as Integer
local lcDestFile as Character
local lnFileSize as Integer
local lcTmp as Character
local lcFname as String
local ii,jj
local lcolFiles as Collection
local llDone as Boolean
local llEscape as Boolean
local loErr as Exception
local llDidError as Boolean
local lnMaxRetries as Integer
local lnAttempts as Integer
local lcKey as Character
local lnRandMax as Integer, lnRandTries as Integer
local lnMaxErrors as Integer
local lnErrors as Integer
lnMaxErrors = 10
lnErrors = 0

lcolFiles = createobject('collection')

on escape llEscape = .t.
set escape on

if empty(this.Parent.txtFolder.Value)
	messagebox('Pick a folder')
	return
endif

local lcSaveSafety
lcSaveSafety = set("Safety")
set safety off

lnRand = rand(-1)
lnMaxSize = this.Parent.spnSize.Value * 1000000
lnRandMax = 500

this.Parent.txtBytes.Value = 0
this.Parent.txtFiles.Value = 0
this.Parent.Refresh

if this.Parent.chkDeleteDestination.Value
	if messagebox('Do you want to delete all files in folder: ';
                        + this.Parent.txtFolder.Value,32+4,'') == 6
		try
			delete file (addbs(this.Parent.txtFolder.Value) + '*.*')
		catch to loErr
			messagebox('An error occurred when deleting from ';
                         + this.Parent.txtFolder.Value + chr(13);
                         + 'Error was: ' + loErr.Message,64,'')
		endtry
	endif
endif

try
	loGenres = this.Parent.owmp.mediaCollection.getByGenre(alltrim(this.Parent.cboGenre.Value))
catch to loerr
	llDidError = .t.
	messagebox('There has been an error trying to ';
                   + 'instantiate the Windows Media Player or acquiring the genre.' + chr(13);
					+ 'The error was: ' + loErr.Message,16,'')
finally
endtry

if llDidError
	this.Parent.txtStatus.Value = 'Done with Error Condition'
	return
endif

if vartype(loGenres) != 'O' or empty(loGenres.count)
	messagebox('Genre is either invalid or there are no songs in the selected genre',16)
	return
endif

lnPower = len(transform(loGenres.count))
lnFiles = loGenres.count

if this.Parent.spnSize.Enabled
	lnMaxRetries = 30 &&here we're trying to fill the last free bytes with smaller songs
else
	lnMaxRetries = 100 &&in this case we're trying to find enough songs, but we might not be able to
endif

lnAttempts = 0

do while (m.lnAttempts < m.lnMaxRetries);
  and not (m.llDone or m.llEscape) and (m.lnErrors < m.lnMaxErrors)
	if this.Parent.spnSize.Enabled
		if this.Parent.txtBytes.Value >= m.lnMaxSize
			llDone = .t.
			exit
		endif
	else
		if this.Parent.txtFiles.Value >= this.Parent.spnNumber.Value
			llDone = .t.
			exit
		endif
	endif

	lnRandTries = 0
	lnRand = int(rand() * 10**m.lnPower)
	do while m.lnRand > m.lnFiles or m.lnRand == 0 and m.lnRandTries < m.lnRandMax
		lnRandTries = m.lnRandTries + 1
		lnRand = int(rand() * 10**m.lnPower)
	enddo

	if m.lnRandTries >= m.lnRandMax
		messagebox('Too many times trying to get a random number.' + chr(13);
                    + 'Perhaps, there just are not enough songs in this genre.',16,'')
		this.Parent.txtStatus.Value = 'Done with Error Condition'
		return
	endif


	this.Parent.txtStatus.Value = 'Finding file'

	this.Parent.txtRand.Value = m.lnRand
	loitem = loGenres.Item(m.lnRand - 1)
	lnFileSize = val(loitem.getItemInfo('size'))

	if this.Parent.spnSize.Enabled
		if (this.Parent.txtBytes.Value + m.lnFileSize) > m.lnMaxSize
			lnAttempts = lnAttempts + 1
			this.Parent.txtStatus.Value = 'Finding file with size constraint';
                          + ' - Attempt ' + transform(m.lnAttempts)
			loop
		endif
	endif

	lcKey = '_' + transform(m.lnRand)

	*we want to avoid getting into an infinite loop
        *if there are not enough songs to meet our other criteria
	if !empty(lcolFiles.GetKey(m.lcKey))
		lnAttempts = m.lnAttempts + 1
		loop
	else
		lcolFiles.Add(createobject('empty'),m.lcKey)
	endif

	lcFname = substr(loitem.sourceURL,ratc('\',loitem.sourceURL)+1)

	for jj = 1 to 2
		if isdigit(m.lcFname)
			lcFname = substr(m.lcFname,2)
		endif
	next

	lcFname = alltrim(m.lcFname)
	lcFname = chrtran(m.lcFname,[-'],[])
	lcFname = padl(transform(m.lnRand),m.lnPower,'0') + '_' + m.lcFname

	lcDestFile = addbs(this.Parent.txtFolder.Value) + m.lcFname

	lcTmp = justpath(m.loitem.sourceURL)
	this.Parent.txtFromFolder.Value = substr(m.lcTmp,atc('\',m.lcTmp,4)+1)
	this.Parent.txtCopyingNow.Value = justfname(loitem.sourceURL)
	this.Parent.txtDestFilename.Value = m.lcFname
	this.Parent.txtStatus.Value = 'Copying...'

	try
		copy file (loitem.sourceURL) to (m.lcDestFile)
		this.Parent.txtFiles.Value = this.Parent.txtFiles.Value + 1
		this.Parent.txtBytes.Value = this.Parent.txtBytes.Value + m.lnFileSize
		this.Parent.txtStatus.Value = 'Copy done'
	catch to loErr
		?loErr.Message
		lnErrors = m.lnErrors + 1
		this.Parent.txtStatus.Value = 'Error on Copy'
	endtry

	doevents
enddo

do case
case m.lnAttempts >= m.lnMaxRetries
	this.Parent.txtStatus.Value = 'Exceeded Max Retries of ';
          + transform(m.lnMaxRetries);
          + ' when finding unique files or files small enough'
case m.lnErrors >= m.lnMaxErrors
	this.Parent.txtStatus.Value = 'Exceeded Max Copy Errors of ' + transform(m.lnMaxErrors)
otherwise
	this.Parent.txtStatus.Value = 'Done' + iif(m.llEscape,' - Escaped','')
endcase

set safety &lcSaveSafety

loGenres = null
loitem = null

lcolFiles.Remove(-1)

release loGenres
release loitem

on escape
ENDPROC
**********************************
**********************************
**********************************
PROCEDURE cmdcancel.Click
thisform.Release
ENDPROC


**********************************
**********************************
**********************************
PROCEDURE opgwhich.Click
if this.Value==1
	this.Parent.spnNumber.Enabled = .f.
	this.Parent.spnSize.Enabled = .t.
else
	this.Parent.spnNumber.Enabled = .t.
	this.Parent.spnSize.Enabled = .f.
endif
ENDPROC


**********************************
**********************************
**********************************
PROCEDURE cmdfolder.Click
local lcFolder
lcFolder = getdir()
if !empty(m.lcFolder)
	this.Parent.txtFolder.Value = m.lcFolder
endif
ENDPROC

**********************************
**********************************
**********************************
PROCEDURE cbogenre.Init2
local loGenres as Object
local lcGenre as String
local ii as Integer
local llFound as Boolean

loGenres = this.Parent.owmp.mediaCollection.getAttributeStringCollection('Genre','Audio')

for ii = 0 to loGenres.count - 1 &&zero based collection
	lcGenre = loGenres.item(m.ii)
	if empty(m.lcGenre)
		loop
	else
		this.AddItem(m.lcGenre)
	endif
next

for ii = 1 to this.ListCount
	if lower(this.List(m.ii)) == 'rock'
		this.ListIndex = m.ii
		llfound = .t.
		exit
	endif
next

if not m.llFound
	this.ListIndex = 1
endif
ENDPROC

**********************************
**********************************
**********************************
PROCEDURE cmdgoto.Click
if not empty(this.Parent.txtFolder.Value)
	this.Parent.goUrl(this.Parent.txtFolder.Value)
endif
ENDPROC


ENDDEFINE
*
*-- EndDefine: mediaplayermover
**************************************************

