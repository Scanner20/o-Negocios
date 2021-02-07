**************************************************************************
*  Nombre    : PLNMMOVT.PRG                                              *
*  Objeto    : Registro Multiple por Persona                             *
*  Actualizaci¢n: 31/05/2007 VETT                                        *
**************************************************************************
*!* Inicializamos Variables *!*
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

*!*	Aperturamos Tablas *!*
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV1"
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV2"
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV3"
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln
SELECT DMOV
SET FILTER TO LEFT(CodMov,1) $ "@,B,C,D"
SELECT PERS
*!* Ejecutamos Formulario *!*
DO FORM pln_plnmmovt

PROCEDURE Movt_ant

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO mmovt
loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('DMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

***************
PROCEDURE mmovt
***************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CODPLN = XsCodPln
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')

cTit1 = "Registro por Concepto de Planilla"
cTit2 = GsNomCia
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = " "
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

*!*	SELECT 3
*!*	USE PLNMPERS ORDER PERS01 ALIAS PERS
*!*	IF !USED(3)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	SELE PERS
*!*	SET FILTER TO CODPLN = XsCodPln
*!*	GOTO TOP
*!*	IF XsCodPln = "1"
*!*	   SELECT 2
*!*	   USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
*!*	ENDIF
*!*	IF XsCodPln = "2"
*!*	   SELECT 2
*!*	   USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
*!*	ENDIF
*!*	IF XsCodPln = "3"
*!*	   SELECT 2
*!*	   USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
*!*	ENDIF
*!*	IF !USED(2)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	SELECT 1
*!*	USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
*!*	IF !USED(1)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
SELECT PERS
GOTO TOP
DO WHILE .T.
	SELECT PERS
	XsCodPer = CodPer
	DO ASMSelec
	XiCodPer = VAL(XsCodPer)
	@ 6,12 GET XiCodPer PICT "@ZL "+REPLICATE("9",LEN(XsCodper))
	READ
	UltTecla = LASTKEY()
	XsCodPer = TRANSFORM(XiCodPer,"@ZL "+REPLICATE("9",LEN(XsCodper)))
	DO CASE
		CASE UltTecla = Escape
			EXIT
		CASE UltTecla = PgUp
			IF EOF()
				GOTO BOTTOM
			ELSE
				IF .NOT. BOF()
					SKIP -1
				ENDIF
			ENDIF
			LOOP
		CASE UltTecla = PgDn
			IF .NOT. EOF()
				SKIP
			ENDIF
			IF EOF()
				GOTO BOTTOM
			ENDIF
			LOOP
		CASE UltTecla = F8
			IF ! pln_plnbusca("PERS")
				LOOP
			ENDIF
			XsCodPer = CodPer
		OTHER
			SEEK XsCodPer
			IF ! FOUND()
				GsMsgErr = "C¢digo de Personal no registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
	ENDCASE
	XsCodPer = CodPer
	@ 6,12 SAY CodPer
	@ 6,20 SAY NomBRE()
	SELECT DMOV
	DO XBrowse
	SELECT PERS
	SKIP
	IF EOF()
		GOTO BOTTOM
	ENDIF
ENDDO
*!*	CLOSE DATA
RETURN
******************
PROCEDURE ASMSelec
******************
@ 5,10 CLEAR TO 7,68
@ 5,10       TO 7,68
@ 6,20  SAY NomBRE()
@ 6,12  SAY XsCodPer
@ 08,10 CLEAR TO 21,68
@ 08,10       TO 21,68
@ 09,11 SAY   " C¢d.  Descripci¢n                                       " COLOR SCHEME 7
@ 10,11       TO 10,67
SELECT DMOV
Llave = XsCodPln+XsNroPer+XsCodPer
SEEK LLave
NumEle = 1
DO WHILE NumEle <= (10) .AND. ! EOF() .AND. Llave = CodPln+NroPer+CodPer
	IF LEFT(CodMov,1) $ "@,B,C,D"
		Contenido= []
		DO Escbe1 WITH Contenido
		@ 10+NumEle, 12 SAY Contenido
	ENDIF
	NumEle = NumEle + 1
	SKIP
ENDDO
SELECT PERS
RETURN
*****************
PROCEDURE xBrowse
*****************
SELECT DMOV
SET FILTER TO LEFT(CodMov,1) $ "@,B,C,D"
**SET FILTER TO FlgEst="R" .OR. CodPer <> XsCodPer
PRIVATE  XsValCal , TsEntPict , TsDecPict
XsCodMov = 0
XnValCal = 0
XnValRef = 0
UltTecla = 0
SelLin   = []
EdiLin   = "Edita1"
EscLin   = "Escbe1"
BrrLin   = "Borra1"
InsLin   = "Graba1"
GrbLin   = "Graba1"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = "KeyF5"
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
Titulo   = []
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
BBVerti  = .T.
Static   = .F.
VSombra  = .T.
Yo       = 10
Xo       = 10
Largo    = 12
Ancho    = 59
TBorde   = Nulo
Set_Escape=.T.
NClave   = "CodPln+NroPer+CodPer"
VClave   = XsCodPln+XsNroPer+XsCodPer
EscLin   = "Escbe1"
DO LIB_MTEC WITH 14
DO dBrowse
SELECT PERS
RETURN
****************
PROCEDURE Escbe1
****************
PARAMETER Contenido
=SEEK(CodMov,"TMOV")
TsFormat = "####,###,###,###,###"
TnLargo  = 14
IF TMOV->EntMov >0 .AND. TMOV->EntMov<15
	TnLargo  = TMOV->EntMov
ENDIF
IF TMOV->DecMov > 0 .AND. TMOV->DecMov<5
	TsFormat = TsFormat + "." + LEFT("####",TMOV->DecMov)
	TnLargo  = TnLargo  + TMOV->DecMov + 1
ENDIF
TsFormat = RIGHT(TsFormat,TnLargo)

Contenido = CodMov+' '+TMOV->DesMov+' '+TRANSF(ValRef,"@ZL ######")
*!*	DO CASE
*!*		CASE GsMnuNv01=[PLNMNU01] AND !INLIST(CodMov,[CA01],[CS10],[DA90])
Contenido = Contenido + RIGHT(SPACE(22)+' '+TRANSF(DMOV->ValCal,TsFormat),18)
*!*		CASE GsMnuNv01=[PLNMNU01] AND INLIST(CodMov,[CA01],[CS10],[DA90])
*!*			Contenido = Contenido + RIGHT(SPACE(22)+' '+TRANSF(0,TsFormat),18)
*!*		OTHER	
*!*			Contenido = Contenido + RIGHT(SPACE(22)+' '+TRANSF(DMOV->ValCal,TsFormat),18)
*!*	ENDCASE
RETURN
****************
PROCEDURE Edita1
****************
IF Crear
	XsCodMov = SPACE(LEN(CodMov))
	XnValCal = 0
	XnValRef = 0
ELSE
	XsCodMov = CodMov
*!*		DO CASE
*!*			CASE GsMnuNv01=[PLNMNU01] AND INLIST(XsCodMov,[CA01],[CS10],[DA90])
*!*				GsMsgErr=[No se puede modificar este conceptos] 
*!*				DO Lib_Merr WITH 99
*!*				UltTecla = Escape
*!*				RETURN
*!*			OTHER	
*!*		ENDCASE
	XnValCal = ValCal
	XnValRef = ValRef
	=SEEK(XsCodMov,"TMOV")
	TnLargo  = 14
	TsFormat = "####,###,###,###,###"
	IF TMOV->EntMov >0 .AND. TMOV->EntMov<15
		TnLargo  = TMOV->EntMov
	ENDIF
	IF TMOV->DecMov > 0 .AND. TMOV->DecMov<5
		TsFormat = TsFormat + "." + LEFT("####",TMOV->DecMov)
		TnLargo  = TnLargo  + TMOV->DecMov + 1
	ENDIF
	TsFormat = RIGHT(TsFormat,TnLargo)
	TnXo     = Xo+Ancho-2-TnLargo
ENDIF
DO LIB_MTEC WITH 6
I = 1
DO WHILE .T.
	DO CASE
		CASE I = 1 .AND. Crear
			SELECT TMOV
			@ LinAct,Xo+2    GET XsCodMov PICT "!!99"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			UltTecla = Lastkey()
			IF UltTecla = F8
				IF pln_plnBusca("TMOV")
					XsCodMov = CodMov
					UltTecla = CtrlW
				ENDIF
			ENDIF
			@ LinAct,Xo+2    SAY XsCodMov
			SEEK XsCodMov
			IF ! FOUND()
				GsMsgErr = "C¢digo de Concepto no registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			IF INLIST(XsCodMov,"R","A","P","J","M") .OR. RIGHT(XsCodMov,2)="00"
				GsMsgErr = "Concepto Invalido a ser Registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
*!*				IF XsCodMov=[C] && AND !PlnNroCfj
*!*					GsMsgErr=[No se puede modificar conceptos fijos] 
*!*					DO Lib_Merr WITH 99
*!*					LOOP
*!*				ENDIF
*!*				DO CASE
*!*					CASE GsMnuNv01=[PLNMNU01] AND INLIST(XsCodMov,[CA01],[CS10])
*!*						GsMsgErr=[No se puede modificar este conceptos] 
*!*						DO Lib_Merr WITH 99
*!*						UltTecla = Escape
*!*						EXIT
*!*					OTHER	
*!*				ENDCASE
			@ LinAct,Xo+7    SAY DesMov
			TnLargo  = 14
			TsFormat = "####,###,###,###,###"
			IF TMOV->EntMov >0 .AND. TMOV->EntMov<15
				TnLargo  = TMOV->EntMov
			ENDIF
			IF TMOV->DecMov >0 .AND. TMOV->DecMov<5
				TsFormat = TsFormat + "." + LEFT("####",TMOV->DecMov)
				TnLargo  = TnLargo  + TMOV->DecMov + 1
			ENDIF
			TsFormat = RIGHT(TsFormat,TnLargo)
			TnXo     = Xo+Ancho-2-TnLargo
		CASE I = 2 .AND. TMOV->TpoVar = "@" .AND. Crear
			@ LinAct,TnXo-7  GET XnValRef PICT "@ZL ######" RANGE 1,12
			READ
			UltTecla = LASTKEY()
			@ LinAct,TnXo-7  SAY XnValRef PICT "@ZL ######"
		CASE I = 3
			@ LinAct,TnXo  GET XnValCal PICT "@Z "+TsFormat
			READ
			UltTecla = LASTKEY()
			IF TMOV->RgoMov="S" .AND. UltTecla <> Escape
				IF (XnValCal<TMOV->ValMin .OR. XnValCal>TMOV->ValMax )
					GsMsgErr = "Dato Fuera de Rango"
					DO LIB_MERR WITH 99
					LOOP
				ENDIF
			ENDIF
			IF INLIST(UltTecla,F10,Enter,CtrlW,Escape)
				EXIT
			ENDIF
	ENDCASE
	I = IIF(UltTecla = Arriba,I-1,I+1)
	I = IIF(I>3,3,i)
	I = IIF(I<1,1,I)
ENDDO
SELE DMOV
IF UltTecla = Escape
	DO LIB_MTEC WITH 14
ENDIF
RETURN
****************
PROCEDURE Graba1
****************
SELE DMOV
IF Crear
	xLlave = XsCodPln+XsNroPer+XsCodPer+XsCodMov+STR(ValRef,6)
	SEEK xLLave
	IF ! FOUND()
		APPEND BLANK
	ENDIF
ENDIF
IF REC_Lock(5)
	REPLACE CodPln WITH  XsCodPln
	REPLACE NroPER WITH  XsNroPer
	REPLACE CodPER WITH  XsCodPer
	REPLACE CodMov WITH  XsCodMov
	REPLACE ValRef WITH  XnValRef
	REPLACE ValCal WITH  XnValCal
	REPLACE FlgEst WITH  "R"
	UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
****************
PROCEDURE Borra1
****************
IF REC_LOCK(5)
	DELETE
	UNLOCK
ENDIF
RETURN
***************
PROCEDURE KeyF5
***************
xFor   = [FlgEst="R"]
xWhile = RegVal
SEEK VClave
sNomRep = "PLNDMOVT"
DO ADMPRINT WITH "REPORTS"
RETURN
