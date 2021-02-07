PARAMETERS TsDirOrigen,TsDirDestino
CLOSE DATABASES ALL
** Ubicamos en la rutas disponibles el folder origen de las compañias a migrar
SET CONFIRM OFF
SET SAFETY OFF

IF !DIRECTORY(TsDirDestino)
	MKDIR (TsDirDestino)
ENDIF
*!*		
SET PROCEDURE TO CIA001,P0012017 ADDITIVE
SELECT 0
USE ADDBS(TsDirDestino)+'SISTDBFS' ALIAS DBFS
SET ORDER TO ARCHIVO   && ARCHIVO


SET PATH TO (TsDirOrigen) ADDITIVE
CD (TsDirOrigen)
=RecursiveDIR2(TsDirOrigen)
SET STEP ON 
SELECT CurDirs
LOCATE
DO WHILE !EOF() 
	IF !'\CIA'$JUSTPATH(cPath)
		SKIP
		LOOP
	ENDIF
	LsRutaCia=JUSTPATH(cPath)			&& 	D:\o-Negocios\Roberto\CIA001
	LsCodCia=JUSTSTEM(LsRutaCia)		&& 	CIA001
	DirAct=ADDBS(TsDirDestino)+LsCodCia	&&	D:\o-negocios\RAUO\DATA\CIA001
	IF !DIRECTORY(DirAct)
		MKDIR (DirAct)
	ENDIF
	WAIT WINDOW 'Creando base de datos compañia: '+DirAct NOWAIT 
	IF FILE(DirAct+'.DBC')
		OPEN DATABASE (DirAct)
	ELSE
		CREATE DATABASE (DirAct)
	ENDIF
	cArcAct = sys(2000,LsRutaCia+"\cbd*.dbf")	&& CBDBANCO.DBF
	DO WHILE ! EMPTY(LEFT(cArcAct,8))
		LsTablaOri=ADDBS(LsRutaCia)+cArcAct		&& D:\o-Negocios\Roberto\CIA001\CBDBANCO.DBF
		LsTablaDes=ADDBS(DirAct)+cArcAct		&& D:\o-negocios\RAUO\DATA\CIA001\CBDBANCO.DBF
		LsTabla		= JUSTSTEM(cArcAct)
		set defa to (DirAct)
		IF !INDBC(LsTabla,'TABLE')
			IF SEEK(LsTabla,'DBFS')
				LsPrg_Table='MakeTable_'+cArcAct
				&LsPrg_Table.	&&	ADD TABLE (LsTablaDes)
			ENDIF
		ENDIF
		WAIT WINDOW 'Agregando tabla: '+LsTabla NOWAIT
		SELECT 0
		USE (LsTablaDes) ALIAS DEST EXCLU
		ZAP
		APPEND FROM (LsTablaOri)
		USE
		cArcAct = sys(2000,DirAct+"\cbd*.dbf",1)
	ENDDO
	LLPaso=.F.
	SCAN WHILE JUSTPATH(cPath)=LsRutaCia
		LLPaso = .T.
		LsAno=SUBSTR(JUSTSTEM(cPath),2,4)
		LsRutaBDAno=ADDBS(ADDBS(TsDirDestino)+LsCodCia)+'P'+SUBSTR(LsCodCia,4,3)+LsAno	&& D:\o-negocios\RAUO\DATA\CIA001\P0012000
		LsRutaAno	= ADDBS(ADDBS(TsDirDestino)+LsCodCia)+'C'+LsAno
		WAIT WINDOW 'Creando base de datos año: '+LsRutaBDAno NOWAIT
		IF !DIRECTORY(LsRutaAno)	&& D:\o-negocios\RAUO\DATA\CIA001\C2000
			MKDIR (LsRutaAno)
		ENDIF 
		IF FILE(LsRutaBDAno+'.DBC')
			OPEN DATABASE (LsRutaBDAno)
		ELSE
			CREATE DATABASE (LsRutaBDAno)
		ENDIF
		set defa to (LsRutaAno)
		cArcAct = sys(2000,TRIM(cPath)+"\cbd*.dbf")
		DO WHILE ! EMPTY(LEFT(cArcAct,8))
			LsTablaOri=ADDBS(cPath)+cArcAct
			LsTablaDes=ADDBS(ADDBS(ADDBS(TsDirDestino)+LsCodCia)+'C'+LsAno)+cArcAct	&& D:\o-negocios\RAUO\DATA\CIA001\C2000\CBDACMCT.DBF
			LsTabla		= JUSTSTEM(cArcAct)
			IF !INDBC(LsTabla,'TABLE')
				IF SEEK(LsTabla,'DBFS')
					LsPrg_Table='MakeTable_'+cArcAct
					&LsPrg_Table.	&&	ADD TABLE (LsTablaDes)
				ENDIF
			ENDIF
			WAIT WINDOW 'Agregando tabla: '+LsTabla NOWAIT
			SELECT 0
			USE (LsTablaDes) ALIAS DEST
			ZAP
			APPEND FROM (LsTablaOri)
			USE 
			cArcAct = sys(2000,TRIM(cPath)+"\cbd*.dbf",1)
		ENDDO
	ENDSCAN 
	IF !LLPaso AND !EOF()
		SKIP
	ENDIF
ENDDO




***************************
FUNCTION CopyTableFromDbC
***************************
ADBOBJECTS(atables,"TABLE")
FOR i=1 to ALEN(atables,1)
  SET DATABASE TO (tfromdbc)
  use (atables(i)) IN 0
  SELECT(atables(i))
  COPY STRUCTURE to (ADDBS(JUSTPATH(ttodbc))+atables(i)) with cdx database (ttodbc)
  USE
  SET DATABASE TO (ttodbc)
  use (atables(i)) IN 0
  SELECT(atables(i))
  APPEND FROM (ADDBS(JUSTPATH(tfromdbc))+atables(i))
  USE 
NEXT
*********************
FUNCTION RecursiveDIR
*********************
* --- RecursiveDir.prg
* --- Syntax: = RecurseDir("d:\Autoshop","*.*")
* --- Coded as a function call to create a reclusive cursor of all folders and files.
* --- Modified from VFP API code on news2news.com
PARAMETERS cDir, cExt, llError

* --- Set a dummy ON ERROR trap as there will be cases where 
* --- errors will be generated attemtping to get dates where
* --- the record entry is a folder or sub-folder and not files
* --- exist to obtain a date from.  There are other cases of
* --- entries that are not per-say files and you cannot obtain
* --- a date or time from some of there entires.

* --- I am using one PUBIC memory variable here ranther than
* --- having to resort to a _screen global property just for 
* --- ease of understanding what is going on with this recersive
* --- routine so it runs as a stand-a-lone without a Main.prg
* --- adding in the one _screen property - lol !
PUBLIC g_lcCurrFile
lcCurrfile = ""

LOCAL lcOnError, LoDir
lcOnError = ON([ERROR])

* --- Turn off error trapping here.
ON ERROR llError = .T.

* --- Set environmental setting for this module
SET TALK OFF
SET MESSAGE TO SPACE(254)

* --- Call my delares that are required.
DO DECLARE

* --- Instance my Object.
loDir = CreateObject("Tdir", cDir)

* --- Clean up and release my one PUBIC memory variable being used.
RELEASE g_lcCurrFile

* --- Move cursor record point to the top of the file.
GOTO TOP

* --- Star out Browse and Use below, I only put it in here for debugging purposes only.
BROWSE

* --- Set error trapping back to it's default setting.
ON ERROR &lcOnError


* --- Recursive code module starts below.
DEFINE CLASS Tdir As Custom
cursorname	= ""
treelevel	= 0
cExt		= UPPER(Cext)

PROCEDURE Init(lcPath, loParent)
    IF TYPE("loParent")="O"
        THIS.cursorname = loParent.cursorname
        THIS.treelevel = loParent.treelevel + 1
    ELSE
        THIS.cursorname = "cs" + SUBSTR(SYS(2015), 3,10)
        lcCursorName = THIS.cursorname
        SELECT 0 
        * --- CREATE THE CURSOR... 
        CREATE CURSOR (THIS.cursorname) (DirLevel N(6),;
        FileSize N(12), Date D, DateTime T, Folder C(254), FileName C(254), DBfolder L, Copied L)
    ENDIF

    THIS.DoFind(lcPath)

PROCEDURE DoFind(lcPath)
#DEFINE MAX_PATH 260
#DEFINE FILE_ATTRIBUTE_DIRECTORY 16
#DEFINE INVALID_HANDLE_VALUE -1
#DEFINE MAX_DWORD 0xffffffff+1
#DEFINE FIND_DATA_SIZE  318

    lcPath = ALLTRIM(lcPath)
    IF Right(lcPath,1) <> "\"
        lcPath = lcPath + "\"
    ENDIF

    LOCAL hFind, cFindBuffer, lnAttr, cFilename, nFileCount,;
        nDirCount, nFileSize, cWriteTime, nLatestWriteTime, oNext,;
        lcurFolder, lcurFile, lcurPath

    cFindBuffer = Repli(Chr(0), FIND_DATA_SIZE)
    hFind = FindFirstFile(lcPath + "*.*", @cFindBuffer)
    IF hFind = INVALID_HANDLE_VALUE
        RETURN
    ENDIF
    
    STORE 0 TO nDirCount, nFileCount, nFileSize, nLatestWriteTime
    DO WHILE .T.
        lnAttr = buf2dword(SUBSTR(cFindBuffer, 1,4))
        cFilename = SUBSTR(cFindBuffer, 45,MAX_PATH)
        cFilename = Left(cFilename, AT(Chr(0),cFilename)-1)

        IF BITAND(lnAttr, FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY
        * --- For a directory
        lcCurrFile = lcPath + cFileName
            IF Not LEFT(cFilename,1)="."
                oNext = CreateObject("Tdir", lcPath + cFilename + "\", THIS)
            ENDIF
        ELSE
            * --- For a regular file
            IF LIKE(cExt,cFilename)
               * --- Assign the currently path and file name to a memory variable
               * --- to be used within this code routine.
               g_lcCurrFile = lcPath + cFileName 
               nFileSize = nFileSize +;
               buf2dword(SUBSTR(cFindBuffer, 29,4)) * MAX_DWORD +;
               buf2dword(SUBSTR(cFindBuffer, 33,4))
              
               * --- Call the two UDF()'s to extract the DATETIME stamps and the DATE for the 
               * --- current file being processed.
               ndate = sys2dt()
               ndatetime = sysdt()
 
               INSERT INTO (THIS.cursorname) VALUES (THIS.treelevel,;
                m.nFileSize,m.ndate,m.ndatetime,lcPath,cFileName,.F.,.T.)
                * --- If this is a folder with no file then replace the file name
                * --- with a blank value.
                IF Filename == ".."
                   REPLACE FileName WITH ""
                Endif   
                * --- Use VFP function as system data and time is returning
                * --- incorrect date and time for all root folder files. 
                lcurFile = ALLTRIM(FILENAME)
                * --- Only continue processing if the filesize is greater than zero.
                IF FILESIZE > 0 
                  * --- Test to ensure that this is not a folder or sub-folder with
                  * --- no file in it or the FDATE() function call will return an error.
                  IF .NOT. "." $lcurFile .OR. EMPTY(Filename)
                     SKIP
                     IF EOF()
                        RETURN
                     ENDIF   
                  ENDIF
               ENDIF
            ENDIF
        ENDIF

        IF FindNextFile(hFind, @cFindBuffer) = 0
            g_lcCurrFile = lcPath + cFileName
            * --- For an empty Directory with no files in it.
            * --- If you do not want to see directories with no files 
            * --- existing in them then star out the two lines of
            * --- code below.
            INSERT INTO (THIS.cursorname) VALUES (THIS.treelevel,;
            m.nFileSize,m.ndate,m.ndatetime,lcPath,cFileName,.F.,.T.)
            * --- If this is a folder with no file then replace the file name
            * --- with a blank value.
            IF Filename == ".."
               REPLACE FileName WITH ""
            Endif   
            * --- Use VFP function as system data and time is returning
            * --- incorrect date and time for all root folder files. 
            * --- Only continue processing if the filesize is greater than zero.
            IF FILESIZE > 0 
               * --- Test to ensure that this is not a folder or sub-folder with
               * --- no file in it or the FDATE() function call will return an error.
               IF .NOT. "." $lcurFile .OR. EMPTY(Filename)
                  SKIP
                  IF EOF()
                     RETURN
                  ENDIF   
               ENDIF
            ENDIF
            EXIT
        ENDIF
    ENDDO
   
    * --- Close the handle.
    = FindClose(hFind)

ENDDEFINE


* --- New function to return full file datetime stamp for the current file.
* --- the VFP FDATE() function has been unded instead of the Windows API call as the
* --- Window API was at some times returning the incorrect DATETIME stamp,
* --- but I was unsure of the actual reason this this?
FUNCTION sysdt(lcFiletime)
ltresult = FDATE(g_lcCurrFile,1)
* --- Return the full DATETIME stamp for the current file being processed.
RETURN  ltResult


* --- New funtion to return the date only for the current file.
* --- Here I also used the VFP FDATE() function just so it is using the same code
* --- as the above DATETIME code.  The Windows API did always return the correct
* --- file date, but I wanted both functions to be the same for ease of bebugging.
FUNCTION sys2dt(lcFiletime)
ltresult = FDATE(g_lcCurrFile,1)
* --- Return only the Date for the current files DATETIME stamp being processed.
RETURN  TTOD(ltResult)



* --- API conversion function to find file size infromation.
FUNCTION buf2word(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) +;
    Asc(SUBSTR(lcBuffer, 2,1)) * 256



* --- API conversion function.
FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) +;
    Asc(SUBSTR(lcBuffer, 2,1)) * 256 +;
    Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +;
    Asc(SUBSTR(lcBuffer, 4,1)) * 16777216


* --- Declare all main API's
PROCEDURE declare

    DECLARE INTEGER FindClose IN kernel32 INTEGER hFindFile

    DECLARE INTEGER FindFirstFile IN kernel32;
        STRING lpFileName, STRING @lpFindFileData

    DECLARE INTEGER FindNextFile IN kernel32;
        INTEGER hFindFile, STRING @lpFindFileData

* --- End of all Main API declare statements.
FUNCTION RecursiveDir2
PARAMETERS TsFolder
LOCAL loFSO, loFolder 
IF USED('CurDirs') 
	USE IN CurDirs
ENDIF
  CREATE CURSOR curDirs (cpath C(254))  
  loFSO = CREATEOBJECT('Scripting.FileSystemObject')  
  loFolder = loFSO.GetFolder(TsFolder)   
  =GetFolders(m.loFolder)  
*!*	  BROWSE  

  FUNCTION GetFolders  
  LPARAMETERS toFolder  
  LOCAL loItem  
  IF m.toFolder.SubFolders.COUNT = 0  
  	INSERT INTO curDirs VALUES (m.toFolder.PATH)  
  ELSE  
  	FOR EACH loItem IN m.toFolder.SubFolders  
  		IF m.loItem.SubFolders.COUNT = 0  
  			INSERT INTO curDirs VALUES (m.loItem.PATH)  
  		ELSE  
  			=GetFolders(m.loItem)  
  		ENDIF  
  	NEXT  
  ENDIF