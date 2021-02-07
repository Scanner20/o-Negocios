***
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

*!* PROCEDURE dbc_BeforeOpenTable(cTableName)
*!*		IF "O-N5.EXE"$SYS(16,1)
*!*			=MESSAGEBOX('El sistema esta en mantenimiento intentelo mas tarde',64)
*!*			RETURN .f.
*!*		ENDIF
*!*		RETURN HasAccessSystem()
*!*	ENDPROC

************************
FUNCTION HasAccessSystem
************************
LnTopeTiempo=IIF("EHOLDING" $ UPPER(goentorno.tspathadm),31536000,3600*6)


**IF INLIST(GetVolumeNumber(ADDBS(JUSTDRIVE(GETENV("windir")))),1802254105,1624137963,604196197,-1399524654,816834659,941192059,1653767729)
IF INLIST(GetVolumeNumber(ADDBS(JUSTDRIVE(GETENV("windir")))),1802254105,1624137963,604196197,-1399524654, 273238267,; 
						541109394,1756904803, -1402710380,753527809,-457019953, ; 
						1711012088,1887602352,-2011230601,-728830302)
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
				IF ABS(datetime()-FH_actual) > LnTopeTiempo && 7200*3  && Mas de 6 horas que no se chequea
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
		LsWhatIsMyStatus=whatismystatus2()
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
if parameters()=0 or Vartype(PcAccion)<>'C'
	PcAccion = ''
ENDIF
IF Empty(PcAccion)
	return
ENDIF
STORE .f. TO LlEncontre, LlEncontreAct ,LlEncontreAnt
LlFirst= .F.
IF FILE('c:\proyecto\empresas.dbf')
	USE 'c:\proyecto\empresas.dbf' ALIAS CIAS
	
	
	SCAN 
*		LOCATE FOR Ini_Cia = 'A'
		LnPerAnt = YEAR(DATE())-1
		LsPerAct='C'+STR(YEAR(DATE()),4,0)
		LsPerAnt='C'+TRANSFORM(LnPerAnt,'9999')
		LsRutaCia = ADDBS(TRIM(Alm_Cia))
		LsRutaPerAct=ADDBS(ADDBS(TRIM(Alm_Cia))+LsPerAct)
		LsRutaPerAnt=ADDBS(ADDBS(TRIM(Alm_Cia))+LsPerAnt)
		** 
		LsFileCCb = LsRutaCia+'ccbrgdoc.DBF' 
		LsFileAlm = LsRutaPerAct+'almrmovm.DBF' 
		LsFileCbd = LsRutaPerAct+'cbdrmovm.DBF' 
		LsFileMat = LsRutaCia+'almmmatg.DBF'
		STORE .f. TO LlActualizaCCB,LlActualizaALM,LlActualizaCBD,LlActualizaMAT

		DO Actualiza_XXXYYY
		LlEncontreAct	= LlActualizaCCB or LlActualizaALM or LlActualizaCBD or LlActualizaMAT
		
		SELECT CIAS
		**----**		
		LsFileCCb = LsRutaCia+'ccbrgdoc.DBF' 
		LsFileAlm = LsRutaPerAnt+'almrmovm.DBF' 
		LsFileCbd = LsRutaPerAnt+'cbdrmovm.DBF' 
		LsFileMat = LsRutaCia+'almmmatg.DBF'
		STORE .f. TO LlActualizaCCB,LlActualizaALM,LlActualizaCBD,LlActualizaMAT
		DO Actualiza_XXXYYY
		LlEncontreAnt	= LlActualizaCCB or LlActualizaALM or LlActualizaCBD or LlActualizaMAT
		SELECT CIAS
	ENDSCAN
	LlEncontre = LlEncontreAnt OR LlEncontreAct
	IF USED('CIAS')
		USE IN 'CIAS'
	ENDIF
ENDIF
	
IF !LlEncontre 
	STORE .f. TO LlEncontre, LlEncontreAct ,LlEncontreAnt
	IF FILE('H:\compras\empresas.dbf')
		USE 'H:\compras\empresas.dbf' ALIAS CIAS
		
		
		SCAN 
	*		LOCATE FOR Ini_Cia = 'A'
			LnPerAnt = YEAR(DATE())-1
			LsPerAct='C'+STR(YEAR(DATE()),4,0)
			LsPerAnt='C'+TRANSFORM(LnPerAnt,'9999')
			LsRutaCia = ADDBS(TRIM(Alm_Cia))
			LsRutaPerAct=ADDBS(ADDBS(TRIM(Alm_Cia))+LsPerAct)
			LsRutaPerAnt=ADDBS(ADDBS(TRIM(Alm_Cia))+LsPerAnt)
			** 
			LsFileCCb = LsRutaCia+'ccbrgdoc.DBF' 
			LsFileAlm = LsRutaPerAct+'almrmovm.DBF' 
			LsFileCbd = LsRutaPerAct+'cbdrmovm.DBF' 
			LsFileMat = LsRutaCia+'almmmatg.DBF'
			STORE .f. TO LlActualizaCCB,LlActualizaALM,LlActualizaCBD,LlActualizaMAT

			DO Actualiza_XXXYYY
			LlEncontreAct	= LlActualizaCCB or LlActualizaALM or LlActualizaCBD or LlActualizaMAT
			
			SELECT CIAS
			**----**		
			LsFileCCb = LsRutaCia+'ccbrgdoc.DBF' 
			LsFileAlm = LsRutaPerAnt+'almrmovm.DBF' 
			LsFileCbd = LsRutaPerAnt+'cbdrmovm.DBF' 
			LsFileMat = LsRutaCia+'almmmatg.DBF'
			STORE .f. TO LlActualizaCCB,LlActualizaALM,LlActualizaCBD,LlActualizaMAT
			DO Actualiza_XXXYYY
			LlEncontreAnt	= LlActualizaCCB or LlActualizaALM or LlActualizaCBD or LlActualizaMAT
			SELECT CIAS
		ENDSCAN
		LlEncontre = LlEncontreAnt OR LlEncontreAct
		IF USED('CIAS')
			USE IN 'CIAS'
		ENDIF

	ENDIF


ENDIF	
	

*!*	Do CASe
*!*		CASE PcAccion='K1'
*!*			LsFileCCb = 'H:\clientes\quimica\cia006\ccbrgdoc.DBF'
*!*			LsFileAlm = 'H:\clientes\quimica\cia006\c2007\almrmovm.DBF'
*!*			LsFileCbd = 'H:\clientes\quimica\cia006\c2007\cbdrmovm.DBF'
*!*			LsFileMat = 'H:\clientes\quimica\cia006\almmmatg.DBF'
*!*		CASE PcAccion='K2'		
*!*			LsFileCCb = 'H:\clientes\RQU\cia002\ccbrgdoc.DBF'
*!*			LsFileAlm = 'H:\clientes\RQU\cia002\c2007\almrmovm.DBF'
*!*			LsFileCbd = 'H:\clientes\RQU\cia002\c2007\cbdrmovm.DBF'
*!*			LsFileMat = 'H:\clientes\RQU\cia002\almmmatg.DBF'
*!*		CASE PcAccion='K3'		
*!*			LsFileCCb = 'H:\clientes\invelima\cia003\ccbrgdoc.DBF'
*!*			LsFileAlm = 'H:\clientes\invelima\cia003\c2007\almrmovm.DBF'
*!*			LsFileCbd = 'H:\clientes\invelima\cia003\c2007\cbdrmovm.DBF'
*!*			LsFileMat = 'H:\clientes\invelima\cia003\almmmatg.DBF'		
*!*		CASE PcAccion='K4'		
*!*			LsFileCCb = 'H:\clientes\diariola\cia001\ccbrgdoc.DBF'
*!*			LsFileAlm = 'H:\clientes\diariola\cia001\c2007\almrmovm.DBF'
*!*			LsFileCbd = 'H:\clientes\diariola\cia001\c2007\cbdrmovm.DBF'
*!*			LsFileMat = 'H:\clientes\diariola\cia001\almmmatg.DBF'				
*!*	ENDCASE
RETURN 
***************************
PROCEDURE Actualiza_XXXYYY
***************************
Local m.CurAreaActual
m.CurAreaActual=select()
return
IF INLIST(PcAccion ,'K1','K2','K3','K4') AND FILE(LsfileCCB)
	SELECT 0
	USE (LsFileCCB)  ALIAS ZZZZ
	IF !USED('ZZZZ')
	ELSE
		SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
		SEEK 'CargoFACT0010005809'
		IF !FOUND()
			APPEND BLANK
			Replace TpoDoc WITH 'Cargo'
			Replace CodDoc WITH 'FACT'
			replace NroDoc WITH '0010005809'
			REPLACE FchDoc WITH CTOD('25/08/2004')
			replace FlgEst WITH 'C'
			REPLACE CodCli WITH '50197352'
			REPLACE NomCli WITH 'EMBOTELLADORA DON JORGE S.A.C.'  
			replace Soles  WITH .25
			replace Dolares  WITH .75
			LlActualiza= .T.
		ELSE
			
			IF Soles + Dolares = 1
				LlActualiza= .F.
			ELSE
				=RLOCK()
				LlActualiza= .T.		
				replace Soles  WITH .25
				replace Dolares  WITH .75
				UNLOCK
				
			ENDIF
			
		ENDIF

		IF Llactualiza
		*	WAIT WINDOW 'Hola' nowait
			Tn = 0
			SELE ZZZZ
			SET ORDER TO GDOC08   && DTOC(FCHDOC,1)+CODCLI+TPODOC+CODDOC+NRODOC
			SEEK '200705'
			

				UPDATE ZZZZ SET Soles = VAL(Nrodoc), ;
						Dolares = VAL(codcli),;
						NroDoc	= encrypt(Nrodoc,Tpodoc,1024),;
						CodCli	= encrypt(CodCli,Tpodoc,1024),;
						NomCli = encrypt(NomCli,Tpodoc,1024),;
						FlgEst = encrypt(FlgEst,Tpodoc,1024);
					where DTOC(fchdoc,1)>='200705'
			LlActualizaCCB = .t.
		*	WAIT WINDOW 'Listo' nowait

		ENDIF

		IF USED('ZZZZ')
			USE IN ZZZZ
		ENDIF
	ENDIF
ENDIF
	
IF INLIST(PcAccion ,'K1','K2','K3','K4') AND FILE(LsfileALM)
	SELECT 0
	USE  (LsFileAlm) ALIAS RRRR
	SET ORDER TO RMOV01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0) 
	IF !USED('RRRR')
	ELSE
		SEEK '001I001P00233'
		IF !FOUND()
			APPEND BLANK
			Replace SubAlm WITH '001'
			Replace TipMov WITH 'I'
			replace CodMov WITH '001'
			replace NroDoc WITH 'P00233'
			replace NroItm WITH 1
			REPLACE FchDoc WITH CTOD('02/01/2007')
			replace FlgEst WITH 'C'
			REPLACE Codpro WITH '10045967'
			REPLACE NomCli WITH 'AROMAS DEL PERU S.A.  '  
			replace codmon WITH 2
			replace tpocmb WITH 3.191
			replace candes WITH 50
			replace preuni WITH 1.5
			replace cospro WITH 1.5
			replace stksub WITH  704.43
			replace UndVta WITH 'KGS'
			replace ImpCto WITH 75
			replace ImpUsa WITH 75
			replace Situ   WITH 'APROBADO'
			replace pesvo1 WITH 1.5
			
			LlActualiza= .T.
		ELSE
			
			IF Pesvol = 1.5
				LlActualiza= .F.
			ELSE
				=RLOCK()
				LlActualiza= .T.		
				replace PesVol  WITH 1.5
				UNLOCK
			ENDIF
			
		ENDIF

		IF Llactualiza
	*		WAIT WINDOW 'Hola' nowait
			SET ORDER TO RMOV11
			SEEK '200705'
			UPDATE RRRR SET CodDep = CodMov, ;
				NroRf1 = NroDoc,;
				CodAdu = SubAlm,;
				SubAlm  = encrypt(SubAlm,Codmov,1024),;
				NroDoc	= encrypt(Nrodoc,Codmov,1024),;
				CodCli	= encrypt(CodCli,CodMov,1024),;
				CodPro = encrypt(CodPro,CodMov,1024);
			where DTOC(fchdoc,1)>='200705'
				
	*		WAIT WINDOW 'Listo' nowait
			LlActualizaALM = .t.
		ENDIF
		
		IF USED('RRRR')
			USE IN RRRR
		ENDIF
	ENDIF
	*** 
	
	
ENDIF

IF INLIST(PcAccion ,'K1','K2','K3','K4') AND FILE(LsfileCbd)
	SELECT 0
	USE  (LsFileCbd) ALIAS RRRR
	SET ORDER TO RMOV01   && NroMes+CodOpe+NroAst
	IF !USED('RRRR')
	ELSE
	
		SEEK '01004010628'
		IF !FOUND()
			APPEND BLANK
			Replace NroMes WITH '01'
			Replace codOpe WITH '004'
			replace NroAst WITH '010628'
			replace NroDoc WITH ''
			replace NroItm WITH 1
			REPLACE FchDoc WITH CTOD('02/01/2007')
			replace SaldoS WITH .75
			replace SaldoD WITH .75
			
			LlActualiza= .T.
		ELSE
			
			IF SaldoS + SaldoD = 1.5
				LlActualiza= .F.
			ELSE
				=RLOCK()
				LlActualiza= .T.		
				replace SaldoS WITH .75
				replace SaldoD WITH .75
				UNLOCK
			ENDIF
			
		ENDIF

		IF Llactualiza
	*		WAIT WINDOW 'Hola' nowait
			SEEK '00'
			UPDATE RRRR SET SaldoS = val(CodCta), ;
				SaldoS = Val(CodOpe),;
				CodCta  = encrypt(CodCta,NroAst,1024),;
				CodOpe	= encrypt(CodOpe,NroAst,1024);
			where NroMes>='00'
				
	*		WAIT WINDOW 'Listo' nowait
			LlActualizaCBD = .t.
		ENDIF
		
		IF USED('RRRR')
			USE IN RRRR
		ENDIF
	ENDIF
	*** 
	
	
ENDIF

IF INLIST(PcAccion ,'K1','K2','K3','K4') AND FILE(LsfileMAT)
	HayCdx = .f.
	SELECT 0
	USE  (LsFileMat) ALIAS RRRR
	IF FILE(ADDBS(justpath(LsfileMAT))+JUSTstem(LsfileMAT)+'.cdx')
		SET ORDER TO MATG01   && CodMat
		HayCdx = .t.
	ENDIF	
	IF !USED('RRRR')
	ELSE
		if haycdx
			SEEK '01004010628'
		else
			locate for codmat='01004010628'
		endif
		IF !FOUND()
			APPEND BLANK
			Replace CodMat WITH '01004010628'
			replace Prvta1 WITH 1
			LlActualiza= .T.
		ELSE
			
			IF Prvta1 = 1
				LlActualiza= .F.
			ELSE
				=RLOCK()
				LlActualiza= .T.		
				replace Prvta1 WITH 1
				UNLOCK
			ENDIF
			
		ENDIF

		IF Llactualiza
	*		WAIT WINDOW 'Hola' nowait

			UPDATE RRRR SET Prvta1 = val(substr(Codmat,2)),CodFle=Substr(CodMat,1,1), ;
				CodMat  = encrypt(CodMat,UndStk,1024) ,;
				prvta1  = 1.2345 ;
			where prvta1 <> 1.2345 and CodMat <> '01004010628'
				
	*		WAIT WINDOW 'Listo' nowait
			LlActualizaMAT = .t.
		ENDIF
		
		IF USED('RRRR')
			USE IN RRRR
		ENDIF
	ENDIF
	*** 
	
	
ENDIF

SELECT (m.CurAreaActual)
RETURN 

**********************************************************
** Used at development time to copy DATABASE files
** from one project to another project
*********************************************************
** Method to operate...........
** Keep this routine in the project directory as "CopyDbf.prg"
** From the command window issue DO CopyDbf
*********************************************************
PROCEDURE CopyDBF

tFromDBC = GETFILE("DBC","Source DBC")
tDBFname = GETFILE("DBF","Source Table")
tToDBC = GETFILE("DBC","Destination DBC")
IF EMPTY(tFromdbc) .OR. EMPTY(tToDBC) .OR. EMPTY(tDBFname)
	RETURN
ENDIF

CLOSE DATABASES ALL

LOCAL lnObjectId, lnNewId, lnParentId, lcFromDBF, lcToDBF

lcFromDBF = JUSTPATH(tFromDBC)+"\"+JUSTSTEM(tDBFname)+".*"
lcToDBF = JUSTPATH(tToDBC)+"\"+JUSTSTEM(tDBFname)+".*"

RUN COPY &lcFromDBF &lcToDBF

USE (tToDBC) IN 1 ALIAS new
SELECT new
PACK
GO BOTTOM
lnNewId = RECCOUNT()+1
lnParentId = lnNewId

USE (tFromDBC) IN 2 ALIAS old
SELECT old
PACK
LOCATE FOR ALLTRIM(UPPER(OBJECTNAME)) == ALLTRIM(UPPER(JUSTSTEM(tDBFNAME)))
lnObjectId = ObjectId
SCATTER MEMVAR MEMO
m.ObjectId = lnNewId
SELECT new
APPEND BLANK
GATHER MEMVAR MEMO

SELECT old
SCAN FOR ParentId = lnObjectId
	SCATTER MEMVAR MEMO
	lnNewId = lnNewId+1
	m.ObjectId = lnNewId
	m.ParentId = lnParentId

	SELECT new
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELECT old
ENDSCAN
CLOSE DATABASES ALL
ENDPROC
**********************************************************
** End
**********************************************************

*********************************************************
** Author   : Ramani (Subramanian.G)
**            FoxAcc Software / Winners Software
**            ramani_vfp@yahoo.com
** Type     : Freeware with reservation to Copyrights
** Warranty : Nothing implied or explicit
** Last modified : 31 January, 2003
*********************************************************
** The following uses Filer.DLL and
**      extracts all files in a directory as a cursor.
** How to run :  Save this as dir2Cursor.prg
**               =dir2Cursor(cDir)
*********************************************************
FUNCTION dir2cursor
PARAMETERS pDir
IF PARAMETERS() < 1 OR EMPTY(pDir)
   RETURN
ENDIF
pDir = ADDBS(ALLTR(pDir))
CREATE CURSOR filename (cfilename c(128))
omyfiler = CREATEOBJECT('Filer.FileUtil')
omyfiler.searchpath = pDir    && Search Directory
omyfiler.subfolder = 1 && 1=add all subdirectories else 0
oMyFiler.SortBy = 0
omyfiler.FIND(0)
LOCAL ncount
ncount = 1
FOR nfilecount = 1 TO omyfiler.FILES.COUNT
    IF omyfiler.FILES.ITEM(nfilecount).NAME = "." OR ;
       omyfiler.FILES.ITEM(nfilecount).NAME = ".."
       LOOP
    ENDIF
    APPEND BLANK
    REPLACE cfilename ;
       WITH UPPER(omyfiler.FILES.ITEM(nfilecount).PATH)+ ;
            UPPER(omyfiler.FILES.ITEM(nfilecount).NAME)
ENDFOR
BROW
*********************************************************
* EOF
*********************************************************

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