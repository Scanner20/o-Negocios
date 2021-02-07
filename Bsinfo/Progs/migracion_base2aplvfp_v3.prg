IF EMPTY(VERSION(2))	&& RunTime
	_SCREEN.VISIBLE = .F.
	SET SYSMENU TO
	SET DEVELOPMENT OFF
ELSE
	_SCREEN.VISIBLE = .t.
ENDIF

_screen.Icon= SYS(5)+'\APLVFP\GRAFGEN\ICONOS\MOTIF\ALIEN Motif.ico'



SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6 
SET MULTILOCKS ON
SET DELETED ON 


*!*	DEFINE WINDOW MYWINDOW FROM 5,0 TO 20,80 COLOR SCHEME 5
*!*	ACTIVATE WINDOW MYWINDOW
*!*	SET SAFETY off
*!*	STORE SPACE(40) TO tFromDBFS, tToDBC, tDBFname && suitably increase size to your needs
*!*	SET PATH TO D:\APLVFP\bsinfo\PROGS;D:\APLVFP\bsinfo\FORMS
*!*	SET PROCEDURE TO CIA001,P0012017 ADDITIVE


*!*	@ 2,5 SAY "Seleccione ruta origen  (DESDE): " Get tFromDBFS
*!*	@ 4,5 SAY "Seleccione ruta destino (HASTA): " Get tToDBC

*!*	READ

*!*	IF EMPTY(tFromDBFS) .OR. EMPTY(tToDBC) 
*!*	    DEACTIVATE WINDOW MYWINDOW
*!*	    RETURN
*!*	ENDIF
*!*	tFromDBFS	= ALLT(tFromDBFS)
*!*	tToDBC 		= ALLT(tToDBC)



*!*	DO Migracion_DBFs_2_DBC WITH tFromDBFS,tToDBC

*!*	CLOSE DATABASES ALL

*!*	DEACTIVATE WINDOW MYWINDOW
*!*	WAIT WINDOW 'PROCESO TERMINADO CON EXITO' NOWAIT
 
SET PATH TO D:\APLVFP\bsinfo\PROGS,D:\APLVFP\bsinfo\FORMS,;
 			D:\APLVFP\Classgen\Vcxs , ;
 			D:\APLVFP\Classgen\Progs, ; 
 			D:\APLVFP\Classgen\Forms
 			
 			
SET PROCEDURE TO CIA001,P0012017 ADDITIVE

SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR, o-N, registry, o-NLib,GridExtras

_SCREEN.WINDOWSTATE	= 2

CLOSE DATABASES ALL
PUBLIC goEntorno , goConexion
goConexion	= CREATEOBJECT('cnxgen_ODBC')
IF  GoConexion.cBackEnd ='VFPDBC'
	** No se establece conexion mediante ODBC
ELSE
	IF !goConexion.Conectar()
		=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
		RELEASE goConexion , goEntorno
		RETURN
	ENDIF
ENDIF	
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsSistema
GsCodCia = '001'
GsNomcia	='NO definida'
goEntorno	= CREATEOBJECT("Entorno")
_MES=MONTH(DATE())
_ANO=YEAR(DATE())

*********************************************************
*****DECLARAR LINEAS ARRIBA LO NECESARIO : SETUP INICIAL
*********************************************************
tFromDBFS	=	'D:\o-Negocios\Roberto'
tToDBC		=	'D:\o-negocios\RAUO\DATA'	

XsTransacc	= ''  &&'UPD_STR'

cancelar = .F.
DO FORM migracion_otrabd_2_aplvfp
READ EVENTS

IF Cancelar
	=MESSAGEBOX('Proceso interrumpido por el usuario',48,'ATENCION ! / WARNING !')
ENDIF

******************************************
**************SALIR DE APLICACION*********
******************************************
ON SHUTDOWN
WAIT WINDOW 'Saliendo del Sistema...' TIMEOUT 0.5


CLOSE DATABASES ALL
IF goEntorno.SqlEntorno
	goConexion.Desconectar()

	=SQLDisconnect(0)
ELSE

ENDIF

RELEASE goEntorno , goConexion , goToolBarCom , goStatusBar, goCfgAlm, goCfgCpi

SET SYSMENU TO DEFAULT
_SCREEN.PICTURE	= ''
*!*	_SCREEN.REMOVEOBJECT('PAPEL_TAPIZ')
_SCREEN.CAPTION	= ALLTRIM(LEFT(VERSION(1),AT(' ',VERSION(1),2)))

IF EMPTY(VERSION(2))	&& RunTime
	QUIT
ELSE
	_SCREEN.VISIBLE = .t.
	set sysmenu to defa	
ENDIF
WAIT CLEAR
CLEAR ALL
RETURN


********************************
PROCEDURE Migracion_DBFs_2_DBC
********************************
PARAMETERS TsDirOrigen,TsDirDestino
CLOSE DATABASES ALL
** Ubicamos en la rutas disponibles el folder origen de las compañias a migrar
SET CONFIRM OFF
SET SAFETY OFF

IF !DIRECTORY(TsDirDestino)
	MKDIR (TsDirDestino)
ENDIF
*!*		

IF !USED('DBFS')
	SELECT 0
	USE ADDBS(TsDirDestino)+'SISTDBFS' ALIAS DBFS
ENDIF
SELECT DBFS
SET ORDER TO ARCHIVO   && ARCHIVO


SET PATH TO (TsDirOrigen) ADDITIVE
CD (TsDirOrigen)
=RecursiveDIR2(TsDirOrigen)



SELECT DBFS
LOCATE

SELECT CurDirs
LOCATE
DO WHILE !EOF() AND !Cancelar
	IF !'\CIA'$JUSTPATH(cPath)
		SKIP
		LOOP
	ENDIF
	IF INLiST(JUSTSTEM(JUSTPATH(cPath)),'CIA004','CIA055','CIA064','CIA067')
*!*			SET STEP ON
	ENDIF
	*** COMPAÑIAS	
	
	
	=CopiaDBFs2CIADBC(cPath,TsDirDestino)

	*** AÑOS ***
	SELECT CurDirs
	LsRutaCia	=JUSTPATH(cPath)			&& 	D:\o-Negocios\Roberto\CIA001
	LsCodCia	=JUSTSTEM(LsRutaCia)		&& 	CIA001
	LLPaso=.F.
	
	SCAN WHILE JUSTPATH(cPath)=LsRutaCia AND !Cancelar
		LLPaso = .T.
		LsAno=SUBSTR(JUSTSTEM(cPath),2,4)
		LsRutaDBCAno=	ADDBS(TsDirDestino)+'P'+SUBSTR(LsCodCia,4,3)+LsAno	&& D:\o-negocios\RAUO\DATA\P0012000
		LsRutaDBFAno=	ADDBS(ADDBS(TsDirDestino)+LsCodCia)+'C'+LsAno
		LsNomBDAno	=	JUSTSTEM(LsRutaDBFAno)
		
		WAIT WINDOW 'Creando base de datos anual/peridodo CAAAA: '+LsNomBDAno+' En la ruta:' +LsRutaDBFAno NOWAIT
		IF !DIRECTORY(LsRutaDBFAno)	&& D:\o-negocios\RAUO\DATA\CIA001\C2000
			MKDIR (LsRutaDBFAno)
		ENDIF 
		IF FILE(LsRutaDBCAno+'.DBC')
			OPEN DATABASE (LsRutaDBCAno)
		ELSE
			CREATE DATABASE (LsRutaDBCAno)
		ENDIF
		** VETT  23/04/17 15:51 : Cargar procedimientos almacenados 
		=Load_SP(LsRutaDBCAno)   && Este proceso necesita cerrar la base de datos, asegurarse de dejarla abierta al terminar. 
		*** Cargar Tablas de la CIAXXX segun la configuracion de SISTDBFS -> DBFS 		
		SELECT DBFS
		SET ORDER TO SISTEMA
*!*			SEEK 'CONTABIL'
*!*			SCAN WHILE SISTEMA='CONTABIL' FOR UPPER(UBICACION)='PER'
		LOCATE
		SCAN FOR UPPER(UBICACION)='PER' AND !Cancelar AND Marca <>'@'
		
			IF !EMPTY(AAAA_Migra) AND 	!LsAno$TRIM(AAAA_Migra)
				LOOP
			ENDIF			
			cArcAct  = RTRIM(ARCHIVO)+'.DBF'		&& CBDACMCT.DBF
			LsTablaOri=ADDBS(CurDirs.cPath)+cArcAct
			LsTablaDes=ADDBS(ADDBS(ADDBS(TsDirDestino)+LsCodCia)+'C'+LsAno)+cArcAct	&& D:\o-negocios\RAUO\DATA\CIA001\C2000\CBDACMCT.DBF
			LsTabla		= JUSTSTEM(cArcAct)
			SET DATABASE TO (LsRutaDBCAno)
			** Creamos la tabla en DBC destino 
			WAIT WINDOW 'Agregando tabla: '+LsTabla + ' ==> '+LsRutaDBCAno NOWAIT
			IF TXNLEVEL()>0
				FOR T=1 TO TXNLEVEL()
					*!*	Forzamos cierre de cualquier transaccion inconclusa
				    END TRANSACTION
			    ENDFOR
			ENDIF
			CrearTablaDBC('P0012017',LsTabla,LsRutaDBFAno)
			WAIT WINDOW 'Importando datos de la tabla: '+LsTablaOri + ' ==> '+LsRutaDBCAno NOWAIT
			*** Importamos datos de DirOrigen solo para CONTABIL
			IF DBFS.SISTEMA='CONTABIL'
				=Cargar_Datos()
			ENDIF
			SELECT DBFS
			Cancelar = (INKEY() = 27) .OR. Cancelar
		ENDSCAN 
		SELECT CurDirs
		Cancelar = (INKEY() = 27) .OR. Cancelar
	ENDSCAN
	SELECT CurDirs
	IF !LLPaso AND !EOF()
		SKIP
	ENDIF
	Cancelar = (INKEY() = 27) .OR. Cancelar
ENDDO


FUNCTION CrearTablaDBC
PARAMETERS PsPrgDBC,PsTabla,PsRuta
SET DEFAULT TO (PsRuta)
LlCreando=.F.

IF !INDBC(LsTabla,'TABLE')
	LsPrg_Table='MakeTable_'+PsTabla+'()'
	LsPrg_Table2='MakeTable_'+PsTabla
	*** Ejecutamos solo si existe el programa generado por GENDBC y/o Frameroot
	LlCreando=.T.
ELSE
	LsPrg_Table='AlterTable_'+PsTabla+'()'
	LsPrg_Table2='AlterTable_'+PsTabla
ENDIF
IF FuncExist(LsPrg_Table2,PsPrgDBC)

	LOCAL oErr1 as Exception
	TRY    
		&LsPrg_Table.	&&	ADD TABLE (LsTablaDes)
	CATCH TO oErr1  
		=messagebox("Creando tabla "+PsTabla+' ==> '+PsRuta+chr(13)+;
          oErr1.Message+chr(13)+;
          "Error #:"+Transform(oErr1.ErrorNo)+chr(13)+;
          "Line #:"+Transform(oErr1.LineNo)+chr(13)+;
          "Error #:"+Transform(oErr1.LineContents),48,"Error")
    FINALLY 
       	IF USED(JUSTSTEM(LsTablaDes))
			USE IN (JUSTSTEM(LsTablaDes))
		ENDIF
    	WAIT CLEAR       
	ENDTRY 					
ELSE
	IF LlCreando
		REPLACE Marca WITH '@' IN DBFS	
	ELSE
		REPLACE Marca WITH 'U' IN DBFS	
	ENDIF
ENDIF
RETURN
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

*************************
FUNCTION CopiaDBFs2CIADBC
*************************  
PARAMETERS PsPath,PsDirDestino
LsRutaCia=JUSTPATH(PsPath)			&& 	D:\o-Negocios\Roberto\CIA001
LsCodCia=JUSTSTEM(LsRutaCia)		&& 	CIA001
DirAct=ADDBS(PsDirDestino)+LsCodCia	&&	D:\o-negocios\RAUO\DATA\CIA001
IF !DIRECTORY(DirAct)  && Creamos directorio/ruta de la compañia destino
	MKDIR (DirAct)
ENDIF
WAIT WINDOW 'Creando base de datos compañia: '+DirAct NOWAIT 
IF FILE(DirAct+'.DBC')
	OPEN DATABASE (DirAct)
ELSE
	CREATE DATABASE (DirAct)
ENDIF
** VETT  23/04/17 15:34 : Cargar procedimientos almacenados 
=Load_SP(DirAct)   && Este proceso necesita cerrar la base de datos, asegurarse de dejarla abierta al terminar. 
*** Cargar Tablas de la CIAXXX segun la configuracion de SISTDBFS -> DBFS 
LsNomCia=JustStem(Diract)
SELECT DBFS
SET ORDER TO SISTEMA
**SEEK 'CONTABIL'
SET FILTER TO Empaqueta='U'
LOCATE
*!*	SCAN WHILE SISTEMA='CONTABIL' FOR UPPER(UBICACION)='CIA'
SCAN FOR UPPER(UBICACION)='CIA' AND !Cancelar  AND Marca <>'@'
	IF !EMPTY(Cias_Migra) AND 	!SUBSTR(LsCodCia,4,3)$TRIM(Cias_Migra)
		LOOP
	ENDIF
	cArcAct  = RTRIM(ARCHIVO)+'.DBF'		&& CBDBANCO.DBF
	LsTablaOri=ADDBS(LsRutaCia)+cArcAct		&& D:\o-Negocios\Roberto\CIA001\CBDBANCO.DBF
	LsTablaDes=ADDBS(DirAct)+cArcAct		&& D:\o-negocios\RAUO\DATA\CIA001\CBDBANCO.DBF
	LsTabla		= JUSTSTEM(cArcAct)
	
	SET DATABASE TO (LsNomcia)
	** Creamos la tabla en DBC destino 
	WAIT WINDOW 'Agregando tabla: '+LsTabla + ' ==> '+LsRutaCia NOWAIT
	IF TXNLEVEL()>0
		FOR T=1 TO TXNLEVEL()
			*!*	Forzamos cierre de cualquier transaccion inconclusa
		    END TRANSACTION
	    ENDFOR
	ENDIF
	=CrearTablaDBC('CIA001',LsTabla,DirAct)
	
	*** Importamos datos de DirOrigen solo para CONTABIL
	IF DBFS.SISTEMA='CONTABIL'
		
		=Cargar_Datos()
	ENDIF
	SELECT DBFS
	Cancelar = (INKEY() = 27) .OR. Cancelar	
ENDSCAN
*!* 	
RETURN

FUNCTION FuncExist
PARAMETERS PsNomFunc,PsProgram
lcMyString = FILETOSTR(ADDBS(JUSTPATH(TsDirDestino))+PsProgram+".lst")

LlExiste= .f.
IF ATCC(PsNomFunc,lcmystring)>0
	LlExiste= .T.
ENDIF

RETURN LlExiste

FUNCTION 2FuncExist
PARAMETERS PsNomFunc,PsProgram

Np=APROCINFO(aProgs,PsProgram)
LlExiste= .f.
IF Np>0
	FOR K= 1 TO Np
		IF UPPER(PsNomFunc)=UPPER(aProgs(K,1))
			LlExiste= .T.
			EXIT
		ENDIF
	ENDFOR
	RETURN LlExiste
ENDIF
RETURN LlExiste

*********************
FUNCTION Cargar_Datos
*********************
** O -> es LsTablaOri Origen-> de donde se esta migrando   D -> LsTablaDes Destino  
** Las tablas destino pertenecen a las bases de datos  CIAXXX, PXXXAAAA
IF XsTransacc	= 'UPD_STR'
	RETURN
ENDIF

IF !FILE(LsTablaDes) OR !FILE(LsTablaOri)
	RETURN
ENDIF

IF DBFS.Transacc='UPD_STR'
	RETURN
ENDIF

SELECT 0
USE (LsTablaDes) ALIAS DEST EXCLU
DO CASE

	CASE INLIST(DBFS.Tipo_Migra,'O-D')
		
		LcKeyO='Tabla+Codigo'
		LcKeyD='Tabla+Codigo' 
		SELECT DEST
		SET ORDER TO TABL
		SELECT 0
		USE (LsTablaOri) ALIAS ORIG
		SET ORDER TO TABL
		SCAN 
			SCATTER MEMVAR
			LsKeyOrig=EVALUATE(LcKeyO)
			SELECT DEST
			SEEK LsKeyOrig
			IF !FOUND()
				APPEND BLANK 
				GATHER MEMVAR 
			ENDIF
			SELECT ORIG
		ENDSCAN
*!*	*!*			lcTemp	= SYS(2015) && SYS(2023)+'\'+SYS(2015)  usar asi cuando es INTO TABLE
*!*	*!*			LcKeya='a.Tabla+a.Codigo'
*!*	*!*			LcKeyb='b.Tabla+b.Codigo'
*!*	*!*				lcCmd = "SELECT a.* FROM "+LsTablaOri+" a WHERE "+lcKeya+;
*!*	*!*				 " NOT IN (SELECT "+lcKeyb+" as TBLCOD "+" FROM "+ LsTablaDes+ " b) INTO CURSOR "+lcTemp
*!*	*!*			&LcCmd.	 
*!*	*!*			SELECT DEST
*!*	*!*			APPEND FROM (DBF(LcTemp))
*!*	*!*			USE IN (lcTemp) 
		USE IN (LsTablaOri)
	CASE INLIST(DBFS.Tipo_Migra,'O')
*!*			IF 'CBDRMOVM'$UPPER(LsTablaDes)
*!*				SET STEP ON 
*!*			ENDIF
		** Cargamos solo registros de la tabla origen
		SELECT DEST 
		ZAP
		
		DO CASE 
			CASE LsTabla='CBDRMOVM'
				SELECT 0
				USE (LsTablaOri) ALIAS ORIG
				SCAN FOR !Cancelar
					SCATTER MEMVAR 
					DO CASE
						CASE INLIST(ASC(EliItm),183,250)  
							m.EliItm = '*'
						CASE INLIST(ASC(EliItm),46)  
							m.EliItm = '.'				
						CASE INLIST(ASC(EliItm),176)  
							m.EliItm = ':'				
					ENDCASE
					SELECT DEST
					APPEND BLANK
					GATHER MEMVAR 
					SELECT ORIG
					Cancelar = (INKEY() = 27) .OR. Cancelar
				ENDSCAN
				
				USE IN ORIG
			OTHERWISE 	
				SELECT DEST
				APPEND FROM (LsTablaOri)	
		ENDCASE 
		
	CASE INLIST(DBFS.Tipo_Migra,'D')	
		** VETT  23/04/17 13:16 : 
		*** SE RESPETA LOS DATOS QUE HAYAN EN LA TABLA DESTINO **
	OTHERWISE 
		WAIT WINDOW 'No esta definido .... tipo migración en SISTDBFS para tabla '+LsTablaDes	
		SUSPEND 
ENDCASE

USE IN DEST
RETURN





FUNCTION Update_CIAXXX

=AlterTable_CBDMAUXI()

