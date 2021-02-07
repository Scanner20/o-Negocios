*!*	1 - C:\Users\username\Documents

*!*	2 - C:\Users\username\AppData\Local

*!*	3 - C:\Users\username\AppData\Roaming

*!*	4 - C:\Users\Public\Documents

*!*	5 - C:\ProgramData

*!*	 

*!*	1 - data private to one user while logged onto one specific computer

*!*	1 - the database files can be easily found by the user by browsing their Documents folder

*!*	 

*!*	2 - data private to one user while logged onto one specific computer

*!*	2 - the database files are in a hidden folder but may be accessible by a skilled user

*!*	 

*!*	3 - data private to one user while logged onto any networked computer

*!*	3 - the database files are in a hidden folder but may be accessible by a skilled user

*!*	 

*!*	4 - data public to any user logged onto a specific computer

*!*	4 - the database files can be easily found by the user by browsing the public Documents folder

*!*	 

*!*	5 - data public to any user logged onto a specific computer

*!*	5 - the database files are in a hidden folder but may be accessible by a skilled user

*!*	 


*!*	Code Snippet
#DEFINE CSIDL_PERSONAL            0x0005

#DEFINE CSIDL_LOCAL_APPDATA       0x001C

#DEFINE CSIDL_APPDATA             0x001A

#DEFINE CSIDL_COMMON_DOCUMENTS    0x002E

#DEFINE CSIDL_COMMON_APPDATA      0x0023

 

=MESSAGEBOX(getsystemfolder(CSIDL_PERSONAL),64,"Folder")

=MESSAGEBOX(getsystemfolder(CSIDL_APPDATA),64,"Folder")

=MESSAGEBOX(getsystemfolder(CSIDL_LOCAL_APPDATA),64,"Folder")

=MESSAGEBOX(getsystemfolder(CSIDL_COMMON_DOCUMENTS),64,"Folder")

=MESSAGEBOX(getsystemfolder(CSIDL_COMMON_APPDATA),64,"Folder")

 

function getsystemfolder

  parameters folderid

  private lpszpath

  declare integer SHGetSpecialFolderPath in shell32.dll integer, string @, integer, integer

 


  lpszpath = space(255)

  if SHGetSpecialFolderPath(0,@lpszpath,folderid,0) # 0

    return substr(rtrim(lpszpath),1,len(rtrim(lpszpath))-1)

  else

    return ""

  endif

endfunc

