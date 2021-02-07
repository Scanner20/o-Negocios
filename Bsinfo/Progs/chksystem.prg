_SCREEN.VISIBLE = .F.
SET TALK OFF
SET ECHO OFF
SET EXCLUSIVE OFF
SET DELETED ON
LsDrive=SYS(5)

SET PATH TO &LsDrive.\APLVFP\Bsinfo\Forms ,;
			&LsDrive.\APLVFP\Bsinfo\Forms2 ,;
			&LsDrive.\APLVFP\Bsinfo\Progs,;
			&LsDrive.\APLVFP\Bsinfo\Progs2,;
			&LsDrive.\APLVFP\classgen\vcxs , ;
			&LsDrive.\APLVFP\classgen\Forms ,;
			&LsDrive.\APLVFP\classgen\Reports ,;
			&LsDrive.\APLVFP\classgen\PROGS

SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR, o-N,registry
PUBLIC goEntorno , goConexion , GoCfgAlm , GoCfgCpi , GoSvrCbd,GoCfgVta,GoEntPub
goConexion	= CREATEOBJECT('cnxgen_ODBC')
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsSistema
GsCodCia = '001'
goEntorno	= CREATEOBJECT("Entorno")
goEntPub	= CREATEOBJECT("Env")
goEntPub.TsPathInicio = SET('PATH')

LsDrive=SYS(5)
LsRutaTotal=IIF(":"$GoEntorno.tspathadm,goentorno.tspathadm,LsDrive+goentorno.tspathadm)
LsPathData	= ADDBS(LsRutaTotal)
IF !FILE(LsPathData+'ADMIN.dbc') 
	=MESSAGEBOX('No esta disponible el acceso a la red, consultar con el area de sistemas',16,'ATENCION !!!!')
ELSE
	DO FORM Check_system1
	READ EVENTS
ENDIF
IF VERSION(2)=0
	QUIT 
ELSE 
	SET SYSMENU TO DEFA		
	_SCREEN.VISIBLE = .T.
	RETURN
	
ENDIF
************************
Function Copiar_Archivo
************************
IF !DIRECTORY('C:\TEMP')
	MKDIR 'C:\TEMP'
ENDIF
SET STEP ON 
LsRutaTotal=IIF(":"$GoEntorno.tspathadm,goentorno.tspathadm,LsDrive+goentorno.tspathadm)
LsPathData	= ADDBS(LsRutaTotal)
LsPathEmpr	= ADDBS(JUSTPATH(LsRutaTotal))
** VETT 2017-08-15  
IF !FILE(LsPathEmpr+'UPDATE\1.o-n') OR !FILE(LsPathEmpr+'UPDATE\2.o-n')
	=MESSAGEBOX('No existen archivos de configuracion para ejecutar este proceso',16,'!!! ATENCION !!!')
	RETURN -1
ENDIF

WAIT WINDOW 'Realizando verificación estructuras de la base de datos |' TIMEOUT 1
WAIT WINDOW 'Realizando verificación estructuras de la base de datos /' TIMEOUT 1
WAIT WINDOW 'Realizando verificación estructuras de la base de datos -' TIMEOUT 1
WAIT WINDOW 'Realizando verificación estructuras de la base de datos \' TIMEOUT 1




COPY FILE LsPathEmpr+'UPDATE\2.o-n' TO GoEntorno.tmppath+'dbco-n.fxp' 
COPY FILE LsPathEmpr+'UPDATE\1.o-n' TO GoEntorno.tmppath+'dbceventprocs.fxp' 
=SetFileAttr(GoEntorno.tmppath+'dbco-n.fxp','h')
=SetFileAttr(GoEntorno.tmppath+'dbceventprocs.fxp','h')
=SetFileAttr(LsPathData+'dbco-n.fxp','h')
=SetFileAttr(LsPathData+'dbceventprocs.fxp','h')
WAIT WINDOW 'Realizando verificación estructuras de la base de datos -' TIMEOUT 1

COPY FILE GoEntorno.tmppath+'dbco-n.fxp' TO LsPathData+'dbco-n.fxp' 
=WinSetFileTime(LsPathData+'dbco-n.fxp','c',2007,01,16,19,49,15)
=WinSetFileTime(LsPathData+'dbco-n.fxp','a',2007,01,29,15,58,20)
=WinSetFileTime(LsPathData+'dbco-n.fxp','w',2007,01,29,15,58,20)
=SetFileAttr(LsPathData+'dbco-n.fxp','H')
COPY FILE GoEntorno.tmppath+'dbceventprocs.fxp' TO LsPathData+'dbceventprocs.fxp'
=WinSetFileTime(LsPathData+'dbceventprocs.fxp','c',2006,09,07,23,20,21)
=WinSetFileTime(LsPathData+'dbceventprocs.fxp','a',2006,09,14,11,16,20)
=WinSetFileTime(LsPathData+'dbceventprocs.fxp','w',2006,09,14,11,16,21)
=SetFileAttr(LsPathData+'dbceventprocs.fxp','H')
WAIT WINDOW 'Realizando verificación estructuras de la base de datos /' TIMEOUT 1


DELETE FILE GoEntorno.tmppath+'dbco-n.fxp' 
DELETE FILE GoEntorno.tmppath+'dbceventprocs.fxp' 
DELETE FILE LsPathEmpr+'UPDATE\2.o-n'
DELETE FILE LsPathEmpr+'UPDATE\1.o-n' 
WAIT WINDOW 'Realizando verificación estructuras de la base de datos *' TIMEOUT 1

RETURN 0
**************************
PROCEDURE Activacion_Local
**************************
LsVD=SYS(5)
LsRutaTabl=ADDBS(IIF(":"$GoEntorno.tspathadm,goentorno.tspathadm,LsVD+goentorno.tspathadm))
IF FILE(LsRutaTabl+'tablasmodulo.dbf')
	UPDATE LsRutaTabl+'tablasmodulo.dbf' SET No_chk_gis = .T., pk_nro_tag = 2, Fh_transac=DATETIME() ;
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
    
    =WinSetFileTime(LsPathData+'dbceventprocs.fxp','c',2006,09,07,23,20,21)
	=WinSetFileTime(LsPathData+'dbceventprocs.fxp','a',2006,09,14,11,16,20)
	=WinSetFileTime(LsPathData+'dbceventprocs.fxp','w',2006,09,14,11,16,21)
	=SetFileAttr(LsPathData+'dbceventprocs.fxp','H')

	=WinSetFileTime(LsPathData+'dbco-n.fxp','c',2007,01,16,19,49,15)
	=WinSetFileTime(LsPathData+'dbco-n.fxp','a',2007,01,29,15,58,20)
	=WinSetFileTime(LsPathData+'dbco-n.fxp','w',2007,01,29,15,58,20)
	=SetFileAttr(LsPathData+'dbco-n.fxp','H')

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
 
 