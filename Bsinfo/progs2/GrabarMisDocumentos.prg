*!* cSpecialFolder = "AllUsersDesktop"
*!* cSpecialFolder = "AllUsersPrograms" 
*!* cSpecialFolder = "AllUsersStartMenu" 
*!* cSpecialFolder = "AllUsersStartup" 
*!* cSpecialFolder = "Favorites" 
*!* cSpecialFolder = "Fonts" 
*!* cSpecialFolder = "MyDocuments" 
*!* cSpecialFolder = "NetHood" 
*!* cSpecialFolder = "PrintHood" 
*!* cSpecialFolder = "Programs" 
*!* cSpecialFolder = "Recent" 
*!* cSpecialFolder = "SendTo" 
*!* cSpecialFolder = "StartMenu" 
*!* cSpecialFolder = "Startup"
*!* cSpecialFolder = "Templates"

LOCAL cDesktopPath, cSpecialFolder
cSpecialFolder = "MyDocuments"
WSHShell = CreateObject("WScript.Shell")
IF TYPE("WSHShell") = "O"
     cDesktopPath = WSHShell.SpecialFolders(cSpecialFolder)
endif
*!*	Messagebox(cDesktopPath,0,"USING WINDOWS SCRIPT")

LcExtensionDestino="XLS"

LcArcDestino=GETFILE(LcExtensionDestino,'Archivo:', 'Aceptar',1,;
   'Seleccionar Archivo')

LcArcDestino = ADDBS(cDesktopPath)+JUSTFNAME(LcArcDestino)
Messagebox(LcArcDestino,0,"USING WINDOWS SCRIPT")