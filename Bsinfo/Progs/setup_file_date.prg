PARAMETERS LsFile,LdDateTime,LcTipo
*!*	Ejem:  do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH 'Fedora-Server-dvd-x86_64-36-1.5.iso',CTOT('20/09/2022 3:26p')
IF VARTYPE(LsFile)<>'C'
	LsFile=''
ENDIF
IF VARTYPE(LcTipo)<>'C'
	LcTipo = ''
ENDIF
IF !INLIST(LcTipo,'w','c','a')
	LcTipo	= ''
ENDIF
IF !INLIST(VARTYPE(LdDateTime),'T', 'D')
	LdDateTime=DATETIME()
ELSE
	LdDateTime=IIF(VARTYPE(LdDateTime)='D',DTOT(LdDateTime),LdDateTime)
ENDIF

LsAAAAMMDDhhmmss=TTOC(LdDateTime,1)
LnAAAA=VAL(SUBSTR(LsAAAAMMDDhhmmss,1,4))
LnMM  =VAL(SUBSTR(LsAAAAMMDDhhmmss,5,2)	)
LnDD  =VAL(SUBSTR(LsAAAAMMDDhhmmss,7,2)	)
LnHH  =VAL(SUBSTR(LsAAAAMMDDhhmmss,9,2)	)
LnMin =VAL(SUBSTR(LsAAAAMMDDhhmmss,11,2))
LnSeg =VAL(SUBSTR(LsAAAAMMDDhhmmss,13,2))	

LsAAAAMMDDhhmmss2=TTOC(LdDateTime+5,1)
LnAAAA2=VAL(SUBSTR(LsAAAAMMDDhhmmss2,1,4))
LnMM2  =VAL(SUBSTR(LsAAAAMMDDhhmmss2,5,2)	)
LnDD2  =VAL(SUBSTR(LsAAAAMMDDhhmmss2,7,2)	)
LnHH2  =VAL(SUBSTR(LsAAAAMMDDhhmmss2,9,2)	)
LnMin2 =VAL(SUBSTR(LsAAAAMMDDhhmmss2,11,2))
LnSeg2 =VAL(SUBSTR(LsAAAAMMDDhhmmss2,13,2))	

LsAAAAMMDDhhmmss3=TTOC(LdDateTime+10,1)
LnAAAA3=VAL(SUBSTR(LsAAAAMMDDhhmmss3,1,4))
LnMM3  =VAL(SUBSTR(LsAAAAMMDDhhmmss3,5,2)	)
LnDD3  =VAL(SUBSTR(LsAAAAMMDDhhmmss3,7,2)	)
LnHH3  =VAL(SUBSTR(LsAAAAMMDDhhmmss3,9,2)	)
LnMin3 =VAL(SUBSTR(LsAAAAMMDDhhmmss3,11,2))
LnSeg3 =VAL(SUBSTR(LsAAAAMMDDhhmmss3,13,2))	



IF !EMPTY(LcTipo)
	=WinSetFileTime(LsFile,LcTipo,LnAAAA,LnMM,LnDD,LnHH,LnMin,LnSeg)
ELSE	
	=WinSetFileTime(LsFile,'c',LnAAAA ,LnMM ,LnDD ,LnHH ,LnMin ,LnSeg )
	=WinSetFileTime(LsFile,'a',LnAAAA2,LnMM2,LnDD2,LnHH2,LnMin2,LnSeg2)
	=WinSetFileTime(LsFile,'w',LnAAAA3,LnMM3,LnDD3,LnHH3,LnMin3,LnSeg3)
ENDIF

IF .F.

	LsDrive='D:'
	*!*	LsRutaTabla=LsDrive+'\o-negocios\OSIS\Data\'
	LsRutaTabla=LsDrive+'\o-negocios\tyj\Data\'
	*!*	LsRutaTabla2=LsDrive+'\o-negocios\Update\'
	LsRutaTabla2=LsDrive+'\BK_SAFE\'
	*LsRutaTabla=LsDrive+'\Aplvfp\Bsinfo\Progs\'
	*!*	LsDrive='k:'
	*!*	LsRutaTabla=LsDrive+'\Aplvfp\Bsinfo\Progs\DbcEvents\'
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.exe','w',2014,11,21,17,33,49)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.exe','c',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.exe','a',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.vbr','w',2014,11,21,17,33,49)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.vbr','c',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.vbr','a',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.Tlb','w',2014,11,21,17,33,49)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.Tlb','c',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'o-nv416.Tlb','a',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'onegocios.bat','w',2014,11,21,17,33,49)
	*!*	=WinSetFileTime(LsRutaTabla+'onegocios.bat','c',2014,11,21,17,33,50)
	*!*	=WinSetFileTime(LsRutaTabla+'onegocios.bat','a',2014,11,21,17,33,50)

	*!*	=WinSetFileTime(LsRutaTabla2+'bkJAMMING_UPD_20141121173555.rar','w',2014,11,21,17,38,49)
	*!*	=WinSetFileTime(LsRutaTabla2+'bkJAMMING_UPD_20141121173555.rar','c',2014,11,21,17,38,49)
	*!*	=WinSetFileTime(LsRutaTabla2+'bkJAMMING_UPD_20141121173555.rar','a',2014,11,21,17,38,49)
	*!*	IF .F.
	=WinSetFileTime(LsRutaTabla+'dbceventprocs.fxp','c',2006,09,07,23,20,21)
	=WinSetFileTime(LsRutaTabla+'dbceventprocs.fxp','a',2006,09,14,11,16,20)
	=WinSetFileTime(LsRutaTabla+'dbceventprocs.fxp','w',2006,09,14,11,16,21)

	=WinSetFileTime(LsRutaTabla+'dbco-n.fxp','c',2007,01,16,19,49,15)
	=WinSetFileTime(LsRutaTabla+'dbco-n.fxp','a',2007,01,29,15,58,20)
	=WinSetFileTime(LsRutaTabla+'dbco-n.fxp','w',2007,01,29,15,58,20)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.dbf','w',2005,12,16,3,6,49)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.dbf','c',2006,03,31,7,51,50)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.dbf','a',2006,03,31,7,51,50)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.cdx','w',2005,12,16,3,7,49)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.cdx','c',2006,03,31,7,51,50)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.cdx','a',2006,03,31,7,51,50)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.fpt','w',2005,12,16,3,8,49)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.fpt','c',2006,03,31,7,51,50)
	=WinSetFileTime(LsRutaTabla+'tablasmodulo.fpt','a',2006,03,31,7,51,50)
ENDIF

RETURN

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
