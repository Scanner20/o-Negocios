*==============================================================================
* Program:				SpecialFolders.PRG
* Purpose:				Determine the path to the specified special folder
* Author:				Doug Hennig
* Last revision:		03/21/2007
* Parameters:			tuFolder - the folder to get the path for. Specify
*							the CSIDL value of the desired folder (which can
*							be obtained from:
* http://msdn.microsoft.com/library/en-us/shellcc/platform/shell/reference/enums/csidl.asp
*							or use one of the following strings:
*							"AppData": application-specific data
*							"CommonAppData": application data for all users
*							"Desktop": the user's Desktop
*							"LocalAppData": data for local (nonroaming)
*								applications
*							"Personal": the My Documents folder
*							"CommonDocuments": the documents folder for all users
* Returns:				The path for the specified folder or blank if the
*							folder wasn't found
* Environment in:		None
* Environment out:		Error 11 occurs if tuFolder isn't specified
*							properly
* Notes:				This code was adapted from:
* http://msdn.microsoft.com/library/en-us/shellcc/platform/shell/reference/objects/folderitem/path.asp
*						Support for other CSIDLs can easily be added
*==============================================================================

lparameters tuFolder
local lnFolder, ;
	lcFolder, ;
	loShell, ;
	loFolder, ;
	loFolderItem, ;
	lcPath

* Define the CSIDLs for the different folders.

#define CSIDL_APPDATA			0x1A
*	Application-specific data:
*		XP:		C:\Documents and Settings\<username>\Application Data
*		Vista:	C:\Users\<username>\AppData\Roaming
#define CSIDL_COMMON_APPDATA	0x23
*	Application data for all users:
*		XP:		C:\Documents and Settings\All Users\Application Data
*		Vista: 	C:\ProgramData
#define CSIDL_DESKTOPDIRECTORY	0x10
*	The user's Desktop:
*		XP:		C:\Documents and Settings\<username>\Desktop
*		Vista:	C:\Users\<username>\Desktop
#define CSIDL_LOCAL_APPDATA		0x1C
*	Data for local (nonroaming) applications:
*		XP:		C:\Documents and Settings\<username>\Local Settings\Application Data
*		Vista:	C:\Users\<username>\AppData\Local
#define CSIDL_PERSONAL			0x05
*	The My Documents folder:
*		XP:		C:\Documents and Settings\<username>\My Documents
*		Vista:	C:\Users\<username>\Documents
#define CSIDL_COMMON_DOCUMENTS	0x2E
*	The My Documents folder:
*		XP:		C:\Documents and Settings\All Users\Documents
*		Vista:	C:\Users\Public\Documents

* Define some other constants.

#define ERR_ARGUMENT_INVALID	11

* Test the parameter.

do case

* If it's numeric, assume it's a valid CSIDL; if not, the API function will
* return a blank string.

	case vartype(tuFolder) = 'N'
		lnFolder = tuFolder

* An invalid data type or empty folder name was passed.

	case vartype(tuFolder) <> 'C' or empty(tuFolder)
		error ERR_ARGUMENT_INVALID
		return ''

* If a string was passed, convert it to the appropriate CSIDL.

	otherwise
		lcFolder = upper(tuFolder)
		do case
			case lcFolder = 'APPDATA'
				lnFolder = CSIDL_APPDATA
			case lcFolder = 'COMMONAPPDATA'
				lnFolder = CSIDL_COMMON_APPDATA
			case lcFolder = 'DESKTOP'
				lnFolder = CSIDL_DESKTOPDIRECTORY
			case lcFolder = 'LOCALAPPDATA'
				lnFolder = CSIDL_LOCAL_APPDATA
			case lcFolder = 'PERSONAL'
				lnFolder = CSIDL_PERSONAL
			case lcFolder = 'COMMONDOCUMENTS'
				lnFolder = CSIDL_COMMON_DOCUMENTS
			otherwise
				error ERR_ARGUMENT_INVALID
				return ''
		endcase
endcase

* Get the desired path using the Shell.

try
	loShell      = createobject('Shell.Application')
	loFolder     = loShell.Namespace(lnFolder) 
	loFolderItem = loFolder.Self
	lcPath       = addbs(loFolderItem.Path) 
catch
	lcPath = ''
endtry
return lcPath
