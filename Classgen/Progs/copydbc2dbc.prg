PARAMETERS cPathDatos,cCodCia,cAno,cPathDestino,cDbOrigen,cPathTablas,nTipoGen
*** ---------------------------------------------------------------------------------------------------------------------------------------------------------- ***
*!*	COMO USAR:
*** ---------------------------------------------------------------------------------------------------------------------------------------------------------- ***
*** PARA COPIAR UNA COMPAÑIA A OTRA NUEVA 	
***	>>> do  copydbc2dbc.prg with 'O:\o-Negocios\RioAzul\data\Cia001','','','O:\o-Negocios\RioAzul\data\Cia003','','O:\o-Negocios\RioAzul\data\Cia003',5
*** VETT  12/03/11 08:19 AM : Otro ejemplo: 
*** do  copydbc2dbc.prg with 'd:\o-Negocios\TYJ\data\Cia019','','','D:\o-Negocios\TYJ\data\Cia020','','D:\o-Negocios\TYJ\data\Cia020',5

*** PARA COPIAR UNA AÑO A OTRO, EL ORIGEN PUEDE SER DE UNA COMPAÑIA DISTINTAN 	
*** >>> do  copydbc2dbc.prg with 'O:\o-Negocios\RioAzul\data\P0012010','','','O:\o-Negocios\RioAzul\data\P0032010','','O:\o-Negocios\RioAzul\data\Cia003\c2010',0
*** VETT  12/03/11 08:19 AM : Otro ejemplo: 
*** do  copydbc2dbc.prg with 'd:\o-Negocios\TYJ\data\P0192011','','','D:\o-Negocios\TYJ\data\P0202011','','D:\o-Negocios\TYJ\data\Cia020\c2011',0

*** PARA CREAR UN NUEVO AÑO DENTRO DE UNA COMPAÑIA YA EXISTENTE BASADO EN AÑO ANTERIOR - SE USA PARA EL CIERRE ANUAL
*** >>> do  copydbc2dbc.prg with 'O:\o-Negocios\RioAzul\data','001','2010','','','',0
*** ----------------------------------------------------------------------------------------------------------------------------------------------------------- ***

IF PARAMETERS()<7
	nTipoGen = 0  && 
ENDIF
IF PARAMETERS()<6
	cPathTablas = ''  && 
ENDIF
IF PARAMETERS()<5
	cDbOrigen = ''  && 
ENDIF
IF PARAMETERS()<4
	cPathDestino = ''  && 
ENDIF
IF VARTYPE(cPathDestino)<>'C'
	cPathDestino = ''  && 
ENDIF
IF VARTYPE(cAno)<>'C'
	cAno = ''  && 
ENDIF

SET PROCEDURE TO CIA001,P0012017 ADDITIVE

IF EMPTY(cAno) AND EMPTY(cPathDestino)
	=MESSAGEBOX('Se debe indicar el periodo (Año) o en su defecto la ruta de la base de datos destino',16,'ATENCION') 	
	RETURN -1
ENDIF
IF !FILE(ADDBS(JUSTPATH(cPathDatos))+'SISTDBFS'+'.DBF')
	=MESSAGEBOX('No esta bien definida la ruta origen '+cPathDatos +' o  no se encuentra la tabla '+[SISTDBFS.DBF],16,'ATENCION') 	
	RETURN -1
ENDIF
SET SAFETY off
STORE SPACE(60) TO tFromDBC, tToDBC, tDBFname && suitably increase size to your needs
DO CASE
	CASE !EMPTY(cAno) AND !EMPTY(cCodCia) AND EMPTY(cPathDestino)
		cPathDb_ANO = ADDBS(cPathDatos)+"CIA"+cCodCia+"\c"+cAno
		LsNomToDBC = 'P'+cCodCia+cAno
		tToDBC = ADDBS(cPathDatos)+LsNomToDBC
		LsNomFromDBC = SUBSTR(LsNomToDBC,1,4)+str(val(substr(LsNomToDBC,5))-1,4,0)
		tFromDBC = ADDBS(cPathDatos)+LsNomFromDBC
	CASE !EMPTY(cPathDestino)	AND EMPTY(cAno) AND EMPTY(cCodCia)
		tToDBC = ALLTRIM(cPathDestino)
		LsNomFromDBC = ''
		tFromDBC = ALLTRIM(cPathDatos) && ADDBS(cPathDatos)+LsNomFromDBC
		IF !EMPTY(cDbOrigen)
			tFromDBC = ADDBS(tFromDBC)+ cDbOrigen
		ENDIF

	OTHER
ENDCASE

IF EMPTY(tFromdbc) .OR. EMPTY(tToDBC) 
	=MESSAGEBOX('No estan definidos las bases de datos origen y/o destino correctamente',16,'¡¡ ATENCION !! - ¡¡ WARNING !!')
    RETURN
ENDIF
*tfromdbc="d:\vfpalarms\dat\mydata"
*ttodbc="d:\vfpalarms\dat1\logbook"
tFromDBC = ALLT(tFromDBC)
tToDBC = ALLT(tToDBC)

CLOSE DATABASES ALL
SELECT 0
IF EMPTY(cAno) AND EMPTY(cCodCia)
	USE ADDBS(JUSTPATH(cPathDatos))+'SISTDBFS' ALIAS DBFS
ELSE
	USE ADDBS(cPathDatos)+'SISTDBFS' ALIAS DBFS
ENDIF	
SET ORDER TO ARCHIVO
WAIT WINDOW 'Creando base de datos ' +ttodbc NOWAIT
CREATE DATABASE (ttodbc)
OPEN DATABASE  (tfromdbc)
ADBOBJECTS(atables,"TABLE")
FOR i=1 to ALEN(atables,1)
  SET DATABASE TO (tfromdbc)
  use (atables(i)) IN 0
  SELECT(atables(i))
  IF SEEK(PADR(UPPER(atables(i)),LEN(DBFS.Archivo)),'DBFS') OR .T.
	  IF INLIST(UPPER(atables(i)),'VTARITEM','ALMCAT')
*!*			  	SET STEP ON 
	  ENDIF
	  IF !EMPTY(cAno)
		  LsNewPathTable=ADDBS(cPathDb_ANO)
		  IF !DIRECTORY(LsNewPathTable)
			mkdir(LsNewPathTable)  		
		  ENDIF
		  WAIT WINDOW 'Creando tabla ' +LsNewPathTable+atables(i) + ' en '+ttodbc NOWAIT
		  COPY STRUCTURE to (LsNewPathTable+atables(i)) with cdx database (ttodbc)
	  ELSE
	  	  LsNewPathTable = ADDBS(IIF(!EMPTY(cPathTablas),cPathTablas,JUSTPATH(ttodbc)))
		  IF !DIRECTORY(LsNewPathTable)
			  mkdir(LsNewPathTable)  		
		  ENDIF
	      WAIT WINDOW 'Creando tabla '+ atables(i) + ' en '+ttodbc NOWAIT
		  COPY STRUCTURE to (LsNewPathTable+atables(i)) with cdx database (ttodbc)
	  ENDIF
	  USE
	  SET DATABASE TO (ttodbc)
	  use (atables(i)) IN 0
	  SELECT(atables(i))
	  =SEEK(PADR(UPPER(atables(i)),LEN(DBFS.Archivo)),'DBFS')
	*!*	  IF lll = .t.
	*!*		  SET STEP ON 
	*!*	  ENDIF
	  IF INLIST(UPPER(atables(i)),'VTARITEM','ALMCAT')
*!*		  	SET STEP ON 
	  ENDIF
	  SELECT DBFS
	  LlCorrelativo1 = VARTYPE(Correla_t1)='L'
	  LlCorrelativo2 = VARTYPE(Correla_t2)='L'
	  LlTipo_Ini     = VARTYPE(Tipo_Ini)='C'
	  SELECT(atables(i))
	  IF !DBFS.trans_str && Tambien traslada los registros
		  IF !EMPTY(cCodCia) AND !EMPTY(cAno)
		  	  APPEND FROM ADDBS(cPathDatos)+LsNomFromDBC+"!"+atables(i) FOR NOT DELETED() 
		  ELSE	  
		  	  APPEND FROM tfromdbc+'!'+atables(i)  && (ADDBS(JUSTPATH(tfromdbc))+atables(i))
		  ENDIF
	  ENDIF
	  IF LlCorrelativo1 AND DBFS.Correla_t1
	    DO Inicializa_correlativos
	  ENDIF
	  IF   LlTipo_Ini   AND INLIST(DBFS.Tipo_Ini ,'STKI','STKG')
	    DO Stock_Ini_Almacenes_Cero
	  ENDIF
	  USE
  ENDIF 
NEXT
** Copiamos procedimientos almacenados **
WAIT WINDOW 'Creando procedimientos almacenados en ' +ttodbc  NOWAIT
SET DATABASE TO (tfromdbc)
COPY PROCEDURES TO ttodbc+[.PRO]
SET DATABASE TO (ttodbc)
APPEND PROCEDURES FROM ttodbc+[.PRO] OVERWRITE
*!*	SET STEP ON 
IF INLIST(nTipoGen,0,2)
	IF JUSTSTEM(tToDBC)='C'
		DO Make_Views  WITH TTODBC IN CIA001 && cPathDestino=TTODBC
	ELSE
		cDbAno=JUSTSTEM(TTODBC)				&& cPathDestino=TTODBC
		IF VARTYPE(cPathDb_ANO)<>'C'
			cPathDbCia = ADDBS(JUSTPATH(cPathDestino))+'CIA'+SUBSTR(cDbAno,2,3)
		ELSE
			cPathDbCia = JUSTPATH(cPathDb_ANO) && ADDBS(JUSTPATH(cPathDestino))+'CIA'+SUBSTR(cDbAno,2,3)
		ENDIF
		DO Make_Views  WITH cPathDbCia,TTODBC IN P0012017   && cPathDestino=TTODBC
	ENDIF	
ENDIF

IF INLIST(nTipoGen,0,5) 
	=CIA_NEW_YEAR()
ENDIF
CLOSE TABLES ALL
CLOSE DATABASES 
WAIT WINDOW ' !!! PROCESO DE CREACION DE BASE DATOS TERMINADO CON EXITO !!!' nowait
RETURN
********************************
FUNCTION Inicializa_correlativos
********************************
*!*	LsNomBd = 'P'+cCodCia+cAno
*!*	cAnoAnt=TRANSFORM(VAL(cAno)-1,"9999")
*!*	LsNomBdAnt = 'P'+cCodCia+cAnoAnt
SCAN 
	=RLOCK()
	replace NroDoc WITH 1	
	FOR LnMes = 1 TO 12
		LsNroMes = 'NDOC'+TRANSFORM(LnMes,'@L 99')
		replace (LsNroMes) WITH 1
	ENDFOR
	UNLOCK
ENDSCAN

**********************************
PROCEDURE Stock_Ini_Almacenes_Cero
**********************************
	REPLACE ALL stkini WITH 0
	REPLACE ALL vinimn WITH 0
	REPLACE ALL vinius WITH 0

*********************
FUNCTION CIA_NEW_YEAR
*********************
IF !EMPTY(cAno)
	WAIT WINDOW 'Inicializando el periodo (año) '+cAno nowait
	LsTblAno='CIA'+cCodCia+'\CBDTANOS'
	LnAnoAnt = VAL(cAno) - 1
	USE (LsTblAno)
	LOCATE FOR Periodo=LnAnoAnt 
	=RLOCK()
	replace Cierre WITH .t.
	UNLOCK
	LOCATE FOR Periodo=VAL(cAno)
	IF !FOUND()
		APPEND BLANK 
	ENDIF
	replace Periodo WITH VAL(cAno)
	replace MesCont WITH 1
	replace MesCaja WITH 1
	replace MesCost WITH 1
	replace MesCtoi WITH 1
	REPLACE Cierre WITH .F.
ELSE
    LsNewPathTable =  ADDBS(IIF(!EMPTY(cPathTablas),JUSTPATH(cPathTablas),ADDBS(ADDBS(JUSTPATH(TTODBC))+'CIA'+SUBSTR(JUSTSTEM(TTODBC),2,3))))
	IF FILE(LsNewPathTable+'CBDTANOS.DBF')
		USE LsNewPathTable+'CBDTANOS.DBF'
		replace ALL cierre WITH .t.
		LOCATE FOR Periodo=YEAR(DATE())
		IF !FOUND()
			APPEND BLANK 
		ENDIF
		replace Periodo WITH YEAR(DATE())
		replace MesCont WITH 1
		replace MesCaja WITH 1
		replace MesCost WITH 1
		replace MesCtoi WITH 1
		REPLACE Cierre WITH .F.
	ENDIF	
ENDIF	
USE
******
*!*	ALTER table o:\TYJ\Data\cia001\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia003\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia005\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia006\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia007\c2010\cbdvmovm ADD COLUMN ParFin C(15)
*!*	ALTER table o:\TYJ\Data\cia009\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia011\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia012\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia013\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia014\c2010\cbdvmovm ADD COLUMN ParFin C(15)
*!*	ALTER table o:\TYJ\Data\cia015\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia016\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia017\c2010\cbdvmovm ADD COLUMN ParFin C(15)
*!*	ALTER table o:\TYJ\Data\cia018\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*!*	ALTER table o:\TYJ\Data\cia019\c2010\cbdvmovm ADD COLUMN ParFin C(15) 
*******************
PROCEDURE CopyViews
*******************
SET DATABASE TO (tfromdbc)
ADBOBJECTS(atables,"VIEW")

CLOSE DATABASES all

LOCAL lnObjectId, lnNewId, lnParentId, lcFromDBF, lcToDBF

use (tfromdbc+".dbc") IN 0 ALIAS old  && EXCLUSIVE
USE (tToDBC+".DBC") IN 0 ALIAS new EXCLUSIVE
WAIT WINDOW 'Creando vistas en ' +ttodbc  NOWAIT
SELECT new
PACK
GO BOTTOM
lnNewId = RECCOUNT()+1
lnParentId = lnNewId
SELECT old
**PACK

FOR i=1 to ALEN(atables,1)

  LOCATE FOR ALLTRIM(UPPER(OBJECTNAME)) == ALLTRIM(UPPER(atables(i)))
  WAIT WINDOW 'Creando vistas '+atables(i) + ' en ' +ttodbc  NOWAIT
  lnObjectId = ObjectId
  SCATTER MEMVAR MEMO
  m.ObjectId = lnNewId
  nstart=1
  do while .t.
    plen=ASC(SUBSTR(m.property,nstart,1))+256*ASC(SUBSTR(m.property,nstart+1,1))
    buf=SUBSTR(m.property,nstart,plen)
    do while .t.
      ns=AT(JUSTFNAME(tfromdbc)+"!",buf,1)
      IF ns=0
        EXIT
      ENDIF
      buf=STUFF(buf,ns,LEN(JUSTFNAME(tfromdbc)),JUSTFNAME(ttodbc))
    ENDDO
    nlen=LEN(buf)
    hnlen=INT(nlen/256)
    lnlen=MOD(nlen,256)
    buf=STUFF(buf,1,2,CHR(lnlen)+CHR(hnlen))
    m.property=STUFF(m.property,nstart,plen,buf)
    nstart=nstart+nlen
    m.property=IIF(EMPTY(m.property),TRIM(m.property),m.property)
    IF nstart>=LEN(m.property)
      EXit
    endif
  enddo
  SELECT new
  APPEND BLANK
  GATHER MEMVAR MEMO
	
  SELECT old
  SCAN FOR ParentId = lnObjectId
    SCATTER MEMVAR MEMO
    lnNewId = lnNewId+1
    m.ObjectId = lnNewId
    m.ParentId = lnParentId
    nstart=1
    do while .t.
      plen=ASC(SUBSTR(m.property,nstart,1))+256*ASC(SUBSTR(m.property,nstart+1,1))
      buf=SUBSTR(m.property,nstart,plen)
      do while .t.
        ns=AT(JUSTFNAME(tfromdbc)+"!",buf,1)
        IF ns=0
          EXIT
        ENDIF
        buf=STUFF(buf,ns,LEN(JUSTFNAME(tfromdbc)),JUSTFNAME(ttodbc))
      ENDDO
      nlen=LEN(buf)
      hnlen=INT(nlen/256)
      lnlen=MOD(nlen,256)
      buf=STUFF(buf,1,2,CHR(lnlen)+CHR(hnlen))
      m.property=STUFF(m.property,nstart,plen,buf)
      nstart=nstart+nlen
      m.property=IIF(EMPTY(m.property),TRIM(m.property),m.property)
      IF nstart>=LEN(m.property)
        EXit
      endif
    enddo
    SELECT new
    APPEND BLANK
    GATHER MEMVAR MEMO
    SELECT old
  ENDSCAN
  lnnewid=lnnewid+1
  lnParentId = lnNewId
next
CLOSE DATABASES ALL
