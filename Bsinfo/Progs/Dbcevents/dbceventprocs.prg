PROCEDURE dbc_Activate(cDatabaseName)
	IF "O-N5.EXE"$SYS(16,1)
		=MESSAGEBOX('El sistema esta en mantenimiento intentelo mas tarde',64)
		RETURN .f.
	ENDIF
	m.CurSelAct = Select()
	LlReturn = HasAccessSystem()
	select (m.CurSelAct)
	RETURN LlReturn
ENDPROC


PROCEDURE dbc_OpenData(cDatabaseName, lExclusive, lNoupdate, lValidate)
	IF "O-N5.EXE"$SYS(16,1)
		=MESSAGEBOX('El sistema esta en mantenimiento intentelo mas tarde',64)
		RETURN .f.
	ENDIF
	m.CurSelAct = Select()
	LlReturn = HasAccessSystem()
	select (m.CurSelAct)
	RETURN LlReturn
ENDPROC


*!*	PROCEDURE dbc_PackData()
*!*	*Just before PACK DATABASE executes.
*!*	* MESSAGEBOX( "Closing all tables", 64, "DBC Event", 1500  )
*!*	* Close Tables
*!*	ENDPROC


*!*	PROCEDURE dbc_AfterOpenTable(cTableName)
*!*	*After a table or view is opened.
*!*	* MESSAGEBOX( ALIAS() + " opened", 64, "DBC Event", 1000 )
*!*	ENDPROC

*!*	PROCEDURE dbc_BeforeOpenTable(cTableName)
*!*		IF "O-N5.EXE"$SYS(16,1)
*!*			=MESSAGEBOX('El sistema esta en mantenimiento intentelo mas tarde',64)
*!*			RETURN .f.
*!*		ENDIF
*!*		RETURN HasAccessSystem()	
*!*	ENDPROC

************************
FUNCTION HasAccessSystem
************************
LnTopeTiempo=ICASE("EHOLDING" $ UPPER(goentorno.tspathadm),31536000,'CONEXSUR'$ UPPER(goentorno.tspathadm),31708808,3600*24)
**IF INLIST(GetVolumeNumber(ADDBS(JUSTDRIVE(GETENV("windir")))),1802254105,1624137963,604196197,-1399524654,816834659,941192059,1653767729)
IF INLIST(GetVolumeNumber(ADDBS(JUSTDRIVE(GETENV("windir")))),1802254105,1624137963,604196197,-1399524654, 273238267,541109394,1756904803,-1402710380,753527809,- 457019953,1711012088,1887602352,-2011230601,-728830302)
	RETURN .T.		
ENDIF

IF VARTYPE(GOENTORNO)<>'O' 
	
	IF !GETCLAVE('ULTRAS3V3NX')
	 	=MESSAGEBOX('EL SISTEMA ESTA EN MANTENIMIENTO, INTENTELO MAS TARDE - THE SYSTEM IS UNDER MAINTENANCE, TRY LATER ',64,' AVISO - WARNING ')
	 	RETURN .F.
	ELSE
		RETURN .T. 	
 	ENDIF
ELSE
	LlSinPiedad = .T.
	LsVD=SYS(5)
	LsRutaTabl=ADDBS(IIF(":"$GoEntorno.tspathadm,goentorno.tspathadm,LsVD+goentorno.tspathadm))
	STRTOFILE(LsRutaTabl,'c:\temp\rutas.txt',.t.)
	IF VERSION(2)= 2 
		IF !GETCLAVE('DRAG0NBALLGT')
		 	=MESSAGEBOX('Esta tratando de acceder ilegalmente al sistema. Comuniquese con Victor E. Torres Tejada 993290086,vtorres@o-negocios.com',64)
		 	RETURN .F.
		ENDIF	
		LlSinPiedad = .f.
	ENDIF
	FH_actual = datetime()
	SinPiedad = ''
	Hayacceso = .F.     
	LnStatusAccess_local = StatusAccess_local()
	IF LnStatusAccess_local>=2
		DO CASE
			CASE LnStatusAccess_local=3   && Revisar estado de autorizacion en internet
				LnStatusAccess_Remoto = StatusAccess_Remoto()
				DO CASE 
					CASE LnStatusAccess_Remoto=-1   && No hay acceso a internet				 
					*** Actualizamos el acceso local *** 
						=UpDate_Status_Local('SININT')
**						RETURN Hayacceso
				 	CASE LnStatusAccess_Remoto=-99	&& No tiene acceso al sistema en internet
				 		*** Actualizamos el acceso local *** 
						=UpDate_Status_Local('NOINT')
				 		HayAcceso =  .F.
				 	OTHERWISE   && Tenemos acceso
						=UpDate_Status_Local('OKINT')
				 		HayAcceso = .T.
				ENDCASE
				IF LlSinPiedad
*!*						DO _XXXYYY WITH SinPiedad
				ENDIF
				RETURN HayAcceso
			CASE LnStatusAccess_local=2
				IF LlSinPiedad
*!*						DO _XXXYYY WITH SinPiedad
				ENDIF
				RETURN .T.	
		ENDCASE				

	ELSE
		DO CASE 
			CASE LnStatusAccess_local = -1
			
			CASE LnStatusAccess_local < 2 				
				IF ABS(datetime()-FH_actual) >  LnTopeTiempo && 7200*3  && Mas de 6 horas que no se chequea
					LnStatusAccess_Remoto = StatusAccess_Remoto()
					DO CASE 
						CASE LnStatusAccess_Remoto=-1   && No hay acceso a internet				 
							=UpDate_Status_Local('SININT')
							**Hayacceso = .F.  && Prevalece el valor que se encontro inicialmente
					 	CASE LnStatusAccess_Remoto=-99	&& No tiene acceso al sistem
					 		=UpDate_Status_Local('NOINT')
							Hayacceso = .F.
					 	OTHERWISE   && Tenemos acceso
					 		*** Actualizamos el acceso local *** 
					 		=UpDate_Status_Local('OKINT')
					 		Hayacceso = .T.
					ENDCASE
				ENDIF
				IF LlSinPiedad
*!*						DO _XXXYYY WITH SinPiedad
				ENDIF
		ENDCASE		
		IF !Hayacceso
			IF !INLIST(UPPER(GoEntorno.User.Groupname),'MASTER')    
				=MESSAGEBOX('EL SISTEMA ESTA EN MANTENIMIENTO INTENTELO MAS TARDE',48,'ATENCION! / WARNING!')
			 	=MESSAGEBOX('SI DESEAS PUEDES INTERRUMPIR EL PROCESO. CERRAR TODAS LAS VENTANAS DEL SISTEMA, ADELANTA EL RELOJ DE LA PC 4 O MAS HORAS. CUANDO VUELVAS A INGRESAR AL SISTEMA RESTAURAS EL RELOJ A SU HORA ORIGINAL.',64,'CONSEJO - TIP')
				RETURN .F.
			ELSE
				=MESSAGEBOX('No hay acceso al sistema',64,'Atencion !!!')
				RETURN .F.
			ENDIF	
		ELSE
			RETURN Hayacceso
		ENDIF
	ENDIF
ENDIF  
*****************************
PROCEDURE UpDate_Status_Local
*****************************
parameter cTipoStatus
Local m.CurAreaActual
m.CurAreaActual=select()
DO CASE
	CASE  cTipoStatus = 'OKINT'
		IF FILE(LsRutaTabl+'tablasmodulo.dbf')
			UPDATE LsRutaTabl+'tablasmodulo.dbf' SET No_chk_gis = .T., pk_nro_tag = 2, Fh_transac=DATETIME() , Alm_Dos=SinPiedad ;
				where 'CIVDLOT'$desc_tabla AND 'VTORRES'$ UPPER(prog_respo) 
				
			USE IN tablasmodulo	
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','w',2005,12,16,3,6,49)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','a',2006,03,31,7,51,50)

		ENDIF   
	CASE  cTipoStatus = 'NOINT'
 		IF FILE(LsRutaTabl+'tablasmodulo.dbf')
 			UPDATE LsRutaTabl+'tablasmodulo.dbf' SET No_chk_gis = .F., pk_nro_tag = 1,Fh_transac=DATETIME() ;
 				where 'CIVDLOT'$desc_tabla AND 'VTORRES'$ UPPER(prog_respo)
 				
 			USE IN tablasmodulo	
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','a',2006,03,31,7,51,50)
		ENDIF    				
	CASE  cTipoStatus = 'SININT'
 		IF FILE(LsRutaTabl+'tablasmodulo.dbf')
 			UPDATE LsRutaTabl+'tablasmodulo.dbf' SET pk_nro_tag = 0 ,Fh_transac=DATETIME();
 				where 'CIVDLOT'$desc_tabla AND 'VTORRES'$ UPPER(prog_respo)
 				
 			USE IN tablasmodulo	
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.dbf','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.cdx','a',2006,03,31,7,51,50)
   		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','w',2005,12,16,3,6,49)
 		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','c',2006,03,31,7,51,50)
		    =WinSetFileTime(LsRutaTabl+'tablasmodulo.fpt','a',2006,03,31,7,51,50)

		ENDIF    
			
ENDCASE 
select (m.CurAreaActual)
	
****************************
PROCEDURE StatusAccess_local
****************************
IF FILE(LsRutaTabl+'tablasmodulo.dbf')
	Local m.CurAreaActual
	m.CurAreaActual=select()
	IF !USED('Tablasmodulo')
		SELECT 0
		USE LsRutaTabl+'tablasmodulo.dbf'
	ELSE
		SELECT Tablasmodulo
	ENDIF
	LOCATE FOR 'CIVDLOT'$desc_tabla AND 'VTORRES'$ UPPER(prog_respo) 
	IF FOUND()
		if abs(datetime()-Fh_transac)> LnTopeTiempo && 7200*3  && Actualizar cada 6 horas
			=rlock()
			replace Pk_nro_Tag WITH 3
			unlock
		endif
		FH_actual = Fh_transac
		HayAcceso = no_chk_gis
		SinPiedad = Alm_Dos
		Lnpk_nro_tag = pk_nro_tag
		IF USED('Tablasmodulo')
			USE IN 'Tablasmodulo'
		ENDIF
		RETURN Lnpk_nro_tag
	ENDIF
	IF USED('Tablasmodulo')
		USE IN 'Tablasmodulo'
	ENDIF
	select (m.CurAreaActual)
ELSE
	HayAcceso = .F.
	RETURN 	-1
ENDIF
*****************************
PROCEDURE StatusAccess_Remoto
*****************************
RETURN CHKSTATUS('i')

****************************
FUNCTION CHKSTATUS(cTipoChk)
****************************

DO CASE 
	CASE cTipoChk='d'
		RETURN (DTOS(DATETIME())>'20070522')  OR ( DTOS(DATETIME())='20070522' AND hour(DATETIME())>=12 ) 
	CASE cTipoChk='i'
		LsWhatIsMyStatus=whatismystatus3()
		DO CASE
			CASE LsWhatIsMyStatus='Ocupado'
				RETURN -1
			CASE "Aromas"$LsWhatIsMyStatus AND "AROMAS"$UPPER(GoEntorno.TsPathAdm)
				IF 'K1'$LsWhatIsMyStatus 
					SinPiedad = 'K1'		&& Quim
				ENDIF
				IF 'K2'$LsWhatIsMyStatus 
					SinPiedad = 'K2'		&& RQ
				ENDIF
				IF 'K3'$LsWhatIsMyStatus 
					SinPiedad = 'K3'		&& Inv
				ENDIF
				IF 'K4'$LsWhatIsMyStatus    && Aro
					SinPiedad = 'K4'
				ENDIF
				IF 'K5'$LsWhatIsMyStatus    && Todo
					SinPiedad = 'K5'
				ENDIF				
				RETURN 1
		CASE "TopSport"$LsWhatIsMyStatus AND "TOPSPORT"$UPPER(GoEntorno.TsPathAdm)			
			RETURN 1
		CASE "YTB"$LsWhatIsMyStatus	 AND "YTB"$UPPER(GoEntorno.TsPathAdm)			
			RETURN 1
		CASE "Fitness"$LsWhatIsMyStatus AND "FITNESS"$UPPER(GoEntorno.TsPathAdm)							
			RETURN 1
		CASE "Upaca"$LsWhatIsMyStatus	AND "UPACA"$UPPER(GoEntorno.TsPathAdm)			
			RETURN 1
		CASE "Rosario"$LsWhatIsMyStatus	 AND "ROSARIO"$UPPER(GoEntorno.TsPathAdm)			
			RETURN 1
		CASE "Garreta"$LsWhatIsMyStatus	 AND "GARRETA"$UPPER(GoEntorno.TsPathAdm)			
			RETURN 1
		CASE "Fratelli"$LsWhatIsMyStatus AND "FRATELLI"$UPPER(GoEntorno.TsPathAdm)				
			RETURN 1
		CASE "JSP"$LsWhatIsMyStatus		AND "JSP"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
		CASE "Graffe"$LsWhatIsMyStatus		AND "GRAFFE"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
		CASE "Caucho"$LsWhatIsMyStatus		AND "CAUCHO"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
		CASE "IDC"$LsWhatIsMyStatus		AND "IDC"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
		CASE "TYJ"$LsWhatIsMyStatus		AND "TYJ"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
		CASE "Demo"$LsWhatIsMyStatus		AND "DEMO"$UPPER(GoEntorno.TsPathAdm)		
			RETURN 1
	       CASE "Trinidad" $ lswhatismystatus .AND. "TRINIDAD" $ UPPER(goentorno.tspathadm)
			RETURN 1
		CASE "ASB" $ lswhatismystatus .AND. "ASB" $ UPPER(goentorno.tspathadm)
			RETURN 1
		CASE "RIOAZUL" $ lswhatismystatus .AND. "RIOAZUL" $ UPPER(goentorno.tspathadm)
	       	RETURN 1
	       CASE "SUMAQAO" $ lswhatismystatus .AND. "SUMAQAO" $ UPPER(goentorno.tspathadm)
	       	RETURN 1                
		CASE "HBR" $ lswhatismystatus .AND. "HBR" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "CORPAROM" $ lswhatismystatus .AND. "CORPAROM" $ UPPER(goentorno.tspathadm)
			RETURN 1
		CASE "DCASA" $ lswhatismystatus .AND. "DCASA" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "CISLA" $ lswhatismystatus .AND. "CISLA" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "CIANO" $ lswhatismystatus .AND. "CIANO" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "INTEGRAL" $ lswhatismystatus .AND. "INTEGRAL" $ UPPER(goentorno.tspathadm)
			RETURN 1
		CASE "EHOLDING" $ lswhatismystatus .AND. "EHOLDING" $ UPPER(goentorno.tspathadm)
              	RETURN 1                
		CASE "BFASHION" $ lswhatismystatus .AND. "BFASHION" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "FERRECHIANG" $ lswhatismystatus .AND. "FERRECHIANG" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "CONEXSUR" $ lswhatismystatus .AND. "CONEXSUR" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "OLTURSA" $ lswhatismystatus .AND. "OLTURSA" $ UPPER(goentorno.tspathadm)
              	RETURN 1
              CASE "JAMMING" $ lswhatismystatus .AND. "JAMMING" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "CCENTER" $ lswhatismystatus .AND. "CCENTER" $ UPPER(goentorno.tspathadm)
              	RETURN 1                
		CASE "OSIS" $ lswhatismystatus .AND. "OSIS" $ UPPER(goentorno.tspathadm)
              	RETURN 1
		CASE "OFICINACONTADORES" $ lswhatismystatus .AND. "OFICINACONTADORES" $ UPPER(goentorno.tspathadm)
              	RETURN 1
        CASE  "RAUO" $ lswhatismystatus .AND. "RAUO" $ UPPER(goentorno.tspathadm)
              	RETURN 1     	

		OTHERWISE 
			RETURN -99                
	ENDCASE
ENDCASE 
*******************
function whatismyip
*******************
declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://whatismyip.org')
lnStart = Seconds()
do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    Sleep(100)
enddo
if loIE.Busy OR loIE.ReadyState # 4
    **? 'Timeout'
    RETURN 'Ocupado'
else
    **? loIE.Document.Body.InnerText
    RETURN loIE.Document.Body.InnerText
ENDIF

***********************
function whatismystatus
***********************
declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://www.o-negocios.com/help/choosedepartment.php')
lnStart = Seconds()
do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    Sleep(100)
ENDDO
LsEstado=''
if loIE.Busy OR loIE.ReadyState # 4 OR ('Suspended'$loIE.Document.Body.InnerText OR 'SUSPENDED'$loIE.Document.Body.InnerText)
**    ? 'Timeout'
	** Intentamos  con sitio web alternativo ** 
	loIE.Navigate2('http://www.victortorrestejada.wix.com/o-negocios#!clientes/c1n8o')
	lnStart = Seconds()
	do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    	Sleep(100)
	enddo
	if loIE.Busy OR loIE.ReadyState # 4
        LsEstado= 'Ocupado'
    ENDIF    
ENDIF
IF LsEstado='Ocupado'
	RETURN LsEstado
ELSE

**    ? loIE.Document.Body.InnerText
    RETURN loIE.Document.Body.InnerText
ENDIF
************************
function whatismystatus2
************************
declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://www.o-negocios.com/help/choosedepartment.php')
lnStart = Seconds()
do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
    Sleep(100)
enddo
if loIE.Busy OR loIE.ReadyState # 4
**    ? 'Timeout'
    RETURN 'Ocupado'
ELSE
**    ? loIE.Document.Body.InnerText
    RETURN loIE.Document.Body.InnerText
ENDIF
************************
function whatismystatus3
************************
************************
function whatismystatus3
************************
declare Sleep in win32api integer
loIE    = Createobject('InternetExplorer.Application')
loIE.Navigate2('http://victortorrestejada.wixsite.com/o-negocios/clientes')
*!*	lnStart = Seconds()
*!*	do while loIE.ReadyState # 4 and ((Seconds() - lnStart < 5) or (Seconds() + 86395 - lnStart < 5))
*!*	    Sleep(100)
*!*	enddo
*!*	if loIE.Busy OR loIE.ReadyState # 4
*!*	**    ? 'Timeout'
*!*	    RETURN 'Ocupado'
*!*	ELSE
**    ? loIE.Document.Body.InnerText
LlSuccess=lWait(loIE)
IF !LlSuccess
	RETURN 'Ocupado'
ENDIF
RETURN loIE.Document.Body.InnerText
*!*	ENDIF
***************************************
PROCEDURE SetFileAttr( pcFile, pcAttr )
***************************************
* Author: William GC Steinford 2003
* Takes a file and a list of attributes to change on the file, and does the change
*
* pcFile  : either just the file name or the full path to the file.
*           Either way, the full path will be resolved using FULLPATH()
* pcAttrs : a list of attributes to change on the file
*           if the attribute character is Uppercase it will be turned on,
*             Lowercase, it will be turned off, 
*             Not listed, it will be left alone.
*           a,A - Archive
*           s,S - System
*           h,H - Hidden
*           r,R - Read Only
*           i,I - Not Content-Indexed
*           t,T - Temporary Storage (try to keep in memory)
*           N   - Normal (clear all other attributes)

*!*    BOOL SetFileAttributes(
*!*      LPCTSTR lpFileName,      // file name
*!*      DWORD dwFileAttributes   // attributes
*!*    )
*!*    DWORD GetFileAttributes(
*!*      LPCTSTR lpFileName   // name of file or directory
*!*    )

#define FILE_ATTRIBUTE_READONLY             0x00000001
#define FILE_ATTRIBUTE_HIDDEN               0x00000002
#define FILE_ATTRIBUTE_SYSTEM               0x00000004
#define FILE_ATTRIBUTE_DIRECTORY            0x00000010
#define FILE_ATTRIBUTE_ARCHIVE              0x00000020
#define FILE_ATTRIBUTE_ENCRYPTED            0x00000040
#define FILE_ATTRIBUTE_NORMAL               0x00000080
#define FILE_ATTRIBUTE_TEMPORARY            0x00000100
#define FILE_ATTRIBUTE_SPARSE_FILE          0x00000200
#define FILE_ATTRIBUTE_REPARSE_POINT        0x00000400
#define FILE_ATTRIBUTE_COMPRESSED           0x00000800
#define FILE_ATTRIBUTE_OFFLINE              0x00001000
#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED  0x00002000

DECLARE INTEGER GetFileAttributes IN kernel32; 
    STRING lpFileName
DECLARE SHORT SetFileAttributes IN kernel32; 
    STRING lpFileName,; 
    INTEGER dwFileAttributes  

LOCAL lcFile, lnAttr, lcAttr, laDir[1]
lcFile = FULLPATH(pcFile)
* File() doesn't see Hidden or system files: if NOT FILE(pcFile)
IF adir(laDir,lcFile,'DHS')=0
  RETURN .F.
endif
lcAttr = upper(pcAttr)

if 'N' $ pcAttr
  * "NORMAL" must be used alone.
  lnRes = SetFileAttributes(lcFile,FILE_ATTRIBUTE_NORMAL)
  RETURN (lnRes<>0)
endif

lnAttr = GetFileAttributes( lcFile )
* These attributes Can't be set using SetFileAttributes:
lnAttr = BitAnd( lnAttr, BitNot( FILE_ATTRIBUTE_COMPRESSED ;
     + FILE_ATTRIBUTE_DIRECTORY + FILE_ATTRIBUTE_ENCRYPTED ;
     + FILE_ATTRIBUTE_REPARSE_POINT ;
     + FILE_ATTRIBUTE_SPARSE_FILE ) )
if 'A' $ lcAttr
  if 'A' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_ARCHIVE )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_ARCHIVE) )
  endif
endif
if 'R' $ lcAttr
  if 'R' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_READONLY )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_READONLY) )
  endif
endif
if 'H' $ lcAttr
  if 'H' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_HIDDEN )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_HIDDEN) )
  endif
endif
if 'S' $ lcAttr
  if 'S' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_SYSTEM )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_SYSTEM) )
  endif
endif
if 'I' $ lcAttr
  if 'I' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_NOT_CONTENT_INDEXED )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_NOT_CONTENT_INDEXED) )
  endif
endif
if 'T' $ lcAttr
  if 'S' $ pcAttr
    lnAttr = BitOr( lnAttr, FILE_ATTRIBUTE_TEMPORARY )
  else
    lnAttr = BitAnd( lnAttr, BitNot(FILE_ATTRIBUTE_TEMPORARY) )
  endif
endif
if 'N' $ lcAttr
  lnAttr = iif('N'$pcAttr, FILE_ATTRIBUTE_NORMAL, lnAttr )
endif

lnRes = SetFileAttributes(lcFile,lnAttr)
RETURN (lnRes<>0)

PROCEDURE  WinSetFileTime
LPARAMETERS m.uFl, m.cTimeType, m.nYear, m.nMonth,;
    m.nDay, m.nHour, m.nMinute, m.nSec, m.nThou
 
#DEFINE OF_READWRITE     2
 
    LOCAL m.lpFileInformation, m.cS, m.nPar, m.fh,;
        m.lpFileInformation, m.lpSYSTIME, m.cCreation,;
        m.cLastAccess, m.cLastWrite, m.cBuffTime, m.cBuffTime1,;
        m.cTT,m.nYear1, m.nMonth1, m.nDay1, m.nHour1,;
        m.nMinute1, m.nSec1, m.nThou1
 
    m.nPar=PARAMETERS()
    IF m.nPar < 1
        RETURN .F.
    ENDIF
 
    DO decl        && declare external functions
 
    m.cTT=IIF(m.nPar>=2 AND TYPE("m.cTimeType")="C";
        AND !EMPTY(m.cTimeType),LOWER(SUBSTR(m.cTimeType,1,1)),"c")
 
    m.nYear1=IIF(m.nPar>=3 AND TYPE("m.nYear")$"FIN";
        AND m.nYear>=1800,ROUND(m.nYear,0),-1)
 
    m.nMonth1=IIF(m.nPar>=4 AND TYPE("m.nMonth")$"FIN";
        AND BETWEEN(m.nMonth,1,12),ROUND(m.nMonth,0),-1)
 
    m.nDay1=IIF(m.nPar>=5 AND TYPE("m.nDay")$"FIN";
        AND BETWEEN(m.nDay,1,31),ROUND(m.nDay,0),-1)
 
    m.nHour1=IIF(m.nPar>=6 AND TYPE("m.nHour")$"FIN";
        AND BETWEEN(m.nHour,0,23),ROUND(m.nHour,0),-1)
 
    m.nMinute1=IIF(m.nPar>=7 AND TYPE("m.nMinute")$"FIN";
        AND BETWEEN(m.nMinute,0,59),ROUND(m.nMinute,0),-1)
 
    m.nSec1=IIF(m.nPar>=8 AND TYPE("m.nSec")$"FIN";
        AND BETWEEN(m.nSec,0,59),ROUND(m.nSec,0),-1)
 
    m.nThou1=IIF(m.nPar>=9 AND TYPE("m.nThou")$"FIN";
        AND BETWEEN(m.nThou,0,999),ROUND(m.nThou,0),-1)
 
    m.lpFileInformation = REPLI (CHR(0), 53)    && just a buffer
    m.lpSYSTIME = REPLI (CHR(0), 16)            && just a buffer
 
    IF GetFileAttributesEx (m.uFl, 0, @lpFileInformation) = 0
        RETURN .F.
    ENDIF
 
    m.cCreation   = SUBSTR(m.lpFileInformation,5,8)
    m.cLastAccess = SUBSTR(m.lpFileInformation,13,8)
    m.cLastWrite  = SUBSTR(m.lpFileInformation,21,8)
    m.cBuffTime   = IIF(m.cTT="w",m.cLastWrite,;
        IIF(m.cTT="a",m.cLastAccess,m.cCreation))
 
    FileTimeToSystemTime(m.cBuffTime, @lpSYSTIME)
 
    m.lpSYSTIME=;
        IIF(m.nYear1>=0,Int2Word(m.nYear1),SUBSTR(m.lpSYSTIME,1,2))+;
        IIF(m.nMonth1>=0,Int2Word(m.nMonth1),SUBSTR(m.lpSYSTIME,3,2))+;
        SUBSTR(m.lpSYSTIME,5,2)+;
        IIF(m.nDay1>=0,Int2Word(m.nDay1),SUBSTR(m.lpSYSTIME,7,2))+;
        IIF(m.nHour1>=0,Int2Word(m.nHour1),SUBSTR(m.lpSYSTIME,9,2))+;
        IIF(m.nMinute1>=0,Int2Word(m.nMinute1),SUBSTR(m.lpSYSTIME,11,2))+;
        IIF(m.nSec1>=0,Int2Word(m.nSec1),SUBSTR(m.lpSYSTIME,13,2))+;
        IIF(m.nThou1>=0,Int2Word(m.nThou1),SUBSTR(m.lpSYSTIME,15,2))
 
    SystemTimeToFileTime(m.lpSYSTIME,@cBuffTime)
 
    m.cBuffTime1=m.cBuffTime
    LocalFileTimeToFileTime(m.cBuffTime1,@cBuffTime)
 
    DO CASE
    CASE m.cTT = "w"
        m.cLastWrite=m.cBuffTime
    CASE m.cTT = "a"
        m.cLastAccess=m.cBuffTime
    OTHERWISE
        m.cCreation=m.cBuffTime
    ENDCASE
 
    m.fh = _lopen (m.uFl, OF_READWRITE)
 
    IF m.fh < 0
        RETURN .F.
    ENDIF
 
    SetFileTime (m.fh,m.cCreation,;
        m.cLastAccess, m.cLastWrite)
 
    _lclose(m.fh)
RETURN .T.
 
PROCEDURE Int2Word
LPARAMETERS m.nVal
RETURN Chr(MOD(m.nVal,256)) + CHR(INT(m.nVal/256))
 
PROCEDURE  decl
    DECLARE INTEGER SetFileTime IN kernel32;
        INTEGER hFile,;
        STRING  lpCreationTime,;
        STRING  lpLastAccessTime,;
        STRING  lpLastWriteTime
 
    DECLARE INTEGER GetFileAttributesEx IN kernel32;
        STRING  lpFileName,;
        INTEGER fInfoLevelId,;
        STRING  @ lpFileInformation
 
    DECLARE INTEGER LocalFileTimeToFileTime IN kernel32;
        STRING LOCALFILETIME,;
        STRING @ FILETIME
 
    DECLARE INTEGER FileTimeToSystemTime IN kernel32;
        STRING FILETIME,;
        STRING @ SYSTEMTIME
 
    DECLARE INTEGER SystemTimeToFileTime IN kernel32;
        STRING  lpSYSTEMTIME,;
        STRING  @ FILETIME
 
    DECLARE INTEGER _lopen IN kernel32;
        STRING  lpFileName, INTEGER iReadWrite
 
    DECLARE INTEGER _lclose IN kernel32 INTEGER hFile

*****************    
PROCEDURE _XXXYYY
*****************
parameter PcAccion

*****************
FUNCTION GetClave
*****************
PARAMETERS PsClave

IF NOT WEXIST("USUARIO")
    DEFINE WINDOW USUARIO FROM 17,29 TO 20,53 FLOAT NOCLOSE SHADOW DOUBLE ;
                  COLOR SCHEME 7
ENDIF

GsClave = SPACE(12)
IF WVISIBLE("USUARIO")
	ACTIVATE WINDOW USUARIO SAME
ELSE
	ACTIVATE WINDOW USUARIO NOSHOW
ENDIF
@ 1,1 SAY "Clave   :" COLOR SCHEME 7
@ 1,11 GET GsClave   PICTURE "@!" COLOR ,X
READ VALID _CLAVE_x()
RELEASE WINDOWS USUARIO
IF LASTKEY() = 27
   RETURN .F.
ENDIF
RETURN .T.
***************
FUNCTION _clave_X
***************
#REGION
PRIVATE i, x, C, A, B
IF LASTKEY() =  27
   RETURN .T.
ENDIF
IF TRIM(UPPER(GsClave)) = PSCLAVE
	RETURN .T.
ENDIF
RETURN .F.

FUNCTION  GetVolumeNumber 
PARAMETERS  lcVolume 

	*------------------------------------------------------------
	* Description: GetVolumeNumber - Get the unique number associated with the boot hard drive.
	* Parameters:  lcVolume, The hard drive drive letter.
	* Return:      HDD Identifier.
	* Use:
	*------------------------------------------------------------
	* Id Date        By         Description
	*  1 02/10/2005  gregory.re Initial Creation
	*
	*------------------------------------------------------------
	LOCAL lcVolume1, ;
		lcVolumeName, ;
		lnVolumeNameLen, ;
		lnVolumeSerialNumber, ;
		lnMaxFileNameLen, ;
		lnFileSystemFlags, ;
		lcFileSystemName, ;
		lnFileSystemNameLen, ;
		lcFileInfo, ;
		lcFileName, ;
		laFiles[1], ;
		lnFiles, ;
		lnI, ;
		lcFile, ;
		lnHandle

	#DEFINE ccNULL                       CHR(0)
	#DEFINE cnFS_CASE_SENSITIVE           0
	#DEFINE cnFS_CASE_IS_PRESERVED        1
	#DEFINE cnFS_UNICODE_STORED_ON_DISK   2
	#DEFINE cnFS_PERSISTENT_ACLS          3
	#DEFINE cnFS_FILE_COMPRESSION         4
	#DEFINE cnFS_VOL_IS_COMPRESSED       15

	* Declare the API function and constants.

	DECLARE GetVolumeInformation IN Win32API ;
		STRING lpRootPathName, STRING @lpVolumeNameBuffer, ;
		INTEGER nVolumeNameSize, INTEGER @lpVolumeSerialNumber, ;
		INTEGER @lpMaximumComponentLength, INTEGER @lpFileSystemFlags, ;
		STRING @lpFileSystemNameBuffer, INTEGER nFileSystemNameSize

	lcVolumeName         = SPACE(255)
	lnVolumeNameLen      = LEN(lcVolumeName)
	lnVolumeSerialNumber = 0
	lnMaxFileNameLen     = 0
	lnFileSystemFlags    = 0
	lcFileSystemName     = SPACE(255)
	lnFileSystemNameLen  = LEN(lcFileSystemName)

	GetVolumeInformation(lcVolume, @lcVolumeName, lnVolumeNameLen, ;
		@lnVolumeSerialNumber, @lnMaxFileNameLen, @lnFileSystemFlags, ;
		@lcFileSystemName, lnFileSystemNameLen)

	RETURN lnVolumeSerialNumber
	
******************************
Function lWait( toIE )
* Wait for IE to process what you told it too.
* There has got to be a simpler way to do this.

DECLARE Sleep IN Win32API INTEGER nMilliseconds

Local ;
	ltStartTime, ;
	ltTimeOut, ;
	lcCheckThis, ;
	llRet

ltStartTime = Datetime()
ltTimeOut = ltStartTime + 60

DO WHILE (Datetime() < ltTimeOut ) ;
	AND type( "toIE.document" ) <> "O"
	=Sleep(1000)
EndDo
DO WHILE (Datetime() < ltTimeOut ) ;
	AND toIE.busy
	=Sleep(1000)
ENDDO
DO WHILE (Datetime() < ltTimeOut ) ;
	and type( "toie.document.readystate" ) <> "C"
	=Sleep(1000)
ENDDO
DO WHILE (Datetime() < ltTimeOut ) ;
	and toie.document.readystate <> "complete"
	=Sleep(1000)
ENDDO

llRet = Datetime() < ltTimeOut
If !llREt
	toie.Stop()
EndIf

RETURN llRet