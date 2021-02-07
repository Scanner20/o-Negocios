LnRpta=MESSAGEBOX('Actualizar salidas sin nro. de lote? con el lote de vencimiento mas próximo',4+32+256,'Atención')
IF LnRpta=7
	RETURN
	
ENDIF
IF DATE()>{^2003-11-10}
	=MESSAGEBOX('Esta opción es valida solo hasta el '+DTOC({^2003-10-10}),0+16,'Atención')	
	RETURN
	
ENDIF


lodatadm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','ALMDTRAN','DTRA','DTRA01','')
LoDatAdm.abrirtabla('ABRIR','ALMCTRAN','CTRA','CTRA01','')
LoDatAdm.abrirtabla('ABRIR','ALMTALMA','ALMA','ALMA01','')
LoDatAdm.abrirtabla('ABRIR','ALMCFTRA','CFTR','CFTR01','')
LoDatAdm.abrirtabla('ABRIR','ALMCATGE','CATG','CATG01','')
LoDatAdm.abrirtabla('ABRIR','ALMDLOTE','DLOTE','DLOTE03','')
LoDatAdm.abrirtabla('ABRIR','SEDES','SEDES','SEDE01','')

RELEASE LoDatAdm
*** 1ero. Primero verificamos ingresos que no tienen lote
LsCursor = SYS(2015)

SELECT DTRA.codsed,SEDES.nombre,DTRA.subalm,ALMA.DESSUB AS ALMACEN, ; 
DTRA.tipmov,DTRA.codmov,CFTR.DESMOV,DTRA.nrodoc,DTRA.fchdoc,DTRA.tporef,DTRA.nroref, ; 
DTRA.codmat,CATG.DESMAT,DTRA.candes ;
from  DTRA INNER JOIN  CFTR  ON DTRA.TIPMOV+DTRA.CODMOV=CFTR.TIPMOV+CFTR.CODMOV ; 
INNER JOIN  CATG ON CATG.CODMAT=DTRA.CODMAT ; 
INNER JOIN ALMA ON ALMA.CODSED+ALMA.SUBALM=DTRA.CODSED+DTRA.SUBALM ;
INNER JOIN SEDES ON SEDES.codigo=DTRA.codsed ; 
WHERE DTRA.tipmov='I' AND EMPTY(DTRA.lote) INTO CURSOR  (LsCursor)

SELECT (LsCursor)
LOCATE
IF !EOF()
	lcRptTxt	= "alm_Ing_sin_lote.FRX"
	lcRptGraph	= "alm_Ing_sin_lote.FRX"
	lcRptDesc	= "Ingresos sin numero de lote"
	*
	IF .f.
	   MODI REPORT  alm_Ing_sin_lote.FRX
	ENDIF
	*
	DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , 1

ENDIF

*!*	IF USED(LsCursor)
*!*		USE IN (LsCursor)
*!*	ENDIF

*** 2do. Obtenemos todos los ingresos que si tienen lote 
LsCursor2 = SYS(2015)

SELECT DTRA.codsed,Sedes.nombre,DTRA.subalm,ALMA.DESSUB AS ALMACEN, ; 
DTRA.tipmov,DTRA.codmov,CFTR.DESMOV,DTRA.nrodoc,DTRA.fchdoc,DTRA.tporef,DTRA.nroref, ; 
DTRA.codmat,CATG.DESMAT,DTRA.candes,DTRA.Lote,DTRA.FchVto ;
from dtra  INNER JOIN CFTR  ON DTRA.TIPMOV+DTRA.CODMOV=CFTR.TIPMOV+CFTR.CODMOV ; 
INNER JOIN CATG ON CATG.CODMAT=DTRA.CODMAT ; 
INNER JOIN ALMA ON ALMA.CODSED+ALMA.SUBALM=DTRA.CODSED+DTRA.SUBALM ;
INNER JOIN sedes  ON SEDES.codigo=DTRA.codsed ; 
WHERE DTRA.tipmov='I' AND !EMPTY(DTRA.lote) ;
order by DTRA.CodMat, DTRA.fchvto ;
INTO  CURSOR  (LsCursor2) READWRITE 

SELECT (LsCursor2)
LOCATE
IF !EOF()
	lcRptTxt	= "alm_Ing_con_lote.FRX"
	lcRptGraph	= "alm_Ing_con_lote.FRX"
	lcRptDesc	= "Ingresos con numero de lote"
	*
	IF .f.
	   MODI REPORT  alm_Ing_con_lote
	ENDIF
	*
	DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , 1

ENDIF

** 3ero. Totalizamos los ingresos por item y lote
LsCursorLote = SYS(2015)

SELECT DTRA.codsed,DTRA.subalm,DTRA.codmat,LEFT(DTOS(DTRA.FchDoc),6) AS periodo ,CATG.DESMAT, ;
 sum(DTRA.candes) as candes , sum(DTRA.candes) as saldo ,DTRA.Lote,DTRA.FchVto ;
from dtra ; 
INNER JOIN CATG ON CATG.CODMAT=DTRA.CODMAT ; 
WHERE DTRA.tipmov='I' AND !EMPTY(DTRA.lote) ;
GROUP BY DTRA.codsed,DTRA.subalm,DTRA.codmat,Periodo,DTRA.Lote,DTRA.FchVto ;
order by periodo,DTRA.CodMat, DTRA.fchvto ;
INTO  CURSOR  (LsCursorLote) READWRITE 
INDEX ON codsed+subalm+codmat+DTOS(FchVto)+LOTE TAG lote 


** 4to  Procesamos las salidas que no tienen numero de lote en el Kardex
** En base al saldo de lotes disponibles 
SELECT DTRA
SET ORDER TO DTRA01
SCAN FOR TipMov='S' 
	IF EMPTY(Lote) OR EMPTY(FchVto)
		WAIT WINDOW SubAlm+'-'+Tipmov+'-'+CodMov+'-'+NroDoc	NOWAIT 
		LdFchVto={}
		replace DTRA.Lote WITH CapturaLoteConSaldo(CodSed,SubAlm,CodMat,Candes,FchDoc)				
		IF !EMPTY(LdFchVto) AND !EMPTY(DTRA.Lote)
			replace Dtra.FchVto WITH LdFchVto 
			replace CodUser WITH GoEntorno.User.Login
			Replace FChHora WITH DATETIME()
		ENDIF
	ENDIF
ENDSCAN

** 5to . Veamos que salidas de almacen siguen sin tener lote asignado
LsCursor4 = SYS(2015)

SELECT DTRA.codsed,Sedes.nombre,DTRA.subalm,ALMA.DESSUB AS ALMACEN, ; 
DTRA.tipmov,DTRA.codmov,CFTR.DESMOV,DTRA.nrodoc,DTRA.fchdoc,DTRA.tporef,DTRA.nroref, ; 
DTRA.codmat,CATG.DESMAT AS Desmat,DTRA.candes,DTRA.Lote,DTRA.FchVto ;
from dtra  INNER JOIN CFTR  ON DTRA.TIPMOV+DTRA.CODMOV=CFTR.TIPMOV+CFTR.CODMOV ; 
INNER JOIN CATG ON CATG.CODMAT=DTRA.CODMAT ; 
INNER JOIN ALMA ON ALMA.CODSED+ALMA.SUBALM=DTRA.CODSED+DTRA.SUBALM ;
INNER JOIN sedes  ON SEDES.codigo=DTRA.codsed ; 
WHERE DTRA.tipmov='S' AND EMPTY(DTRA.lote) ;
order by Desmat, DTRA.fchvto ;
INTO  CURSOR  (LsCursor4) READWRITE 

SELECT (LsCursor4)
LOCATE
IF !EOF()
	lcRptTxt	= "alm_SAl_Sin_lote.FRX"
	lcRptGraph	= "alm_Sal_Sin_lote.FRX"
	lcRptDesc	= "Salidas sin # de lote"
	*
	IF .f.
	   MODI REPORT  alm_Sal_Sin_lote
	ENDIF
	*
	DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , 1

ENDIF

IF USED(LsCursor)
	USE IN (LsCursor)
ENDIF
IF USED(LsCursorLote)
	USE IN (LsCursorLote)
ENDIF
IF USED(LsCursor2)
	USE IN (LsCursor2)
ENDIF
IF USED(LsCursor4)
	USE IN (LsCursor4)
ENDIF

***
 

****************************
FUNCTION CapturaLoteConSaldo
****************************
PARAMETERS _CodSed,_SubAlm,_CodMat,_Candes,_FchDoc
LOCAL  LsAreaAct As String ,LsLote as String , LsLlave as String 
LsAreaAct = SELECT()
LsLote  = ''
LsLlave = _CodSed+_SubAlm+_CodMat
Lfsaldo = 0
LfSalAnt = 0
LnRegant = 0
LfCandes = _Candes
*!*	SELECT (LsCursorLote)
**LdFchVto = {}

SELECT DLOTE
SEEK LsLLave
SCAN WHILE _CodSed+_SubAlm+_CodMat = Lsllave  FOR StkAct>0 

	LfSaldo =  (StkAct - LfCandes) 
    IF LfSaldo >=0
    	replace StkAct WITH LfSaldo
    	LfCandes = 0
    	LsLote = Lote
    	LdFchVto = FchVto
    	EXIT
    ELSE
    	LnRegAnt = RECNO()
    	LfSalAnt = StkAct
*        replace Saldo WITH 0
*        LfCandes = -LfSaldo
    ENDIF
ENDSCAN
SELECT (LsAreaAct)
RETURN LsLote



