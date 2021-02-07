**********************************************************
* Nombre    :   PlnCierr.PRG                             *
* Objeto    :   Proceso de Cierre de Planilla            *
* Parámetros:   NroCierre: Número de Cierre a realizar   *
*                        1: Semana 2: Quincena 3: Mes    *
* Creación     : 21/11/2000                              *
**********************************************************
PARAMETERS NoCierre		&& Usamos parametro para tipo de cierre

PRIVATE Escape,XsCodPln,XsNroPer
Escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
PlnNroMes = VAL(XsNroMes)
PlnNroSem = VAL(XsNroSem)
PlnNroAno = _Ano
*!*	Aperturamos Archivos y ejecutamos libreria
DO Apertura_Dbf

*!*	Ejecutamos Formulario
DO FORM Pln_Plncierr
RETURN

**********************
PROCEDURE Apertura_Dbf
**********************
goentorno.open_dbf1('ABRIR','PLNDCCTE','CCTE','CCTE01','')
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

****************
PROCEDURE Cierre
****************
cSemana = XsNroSem
cMensual = XsNroMes
DO CASE
	CASE NoCierre = 1
		WAIT WINDOW "Cierre de Semana Número: " + XsNroSem TIMEOUT 1
		XiNroSem = VAL(XsNroSem)+1
	CASE NoCierre = 2
		WAIT WINDOW "Cierre de Quincena Número: " + XsNroQui TIMEOUT 1
		IF XsNroQui = "24"
			GsMsgErr = "Debera realizar un Cierre Anual"
			MESSAGEBOX(GsMsgErr,0+48,"Atención")
			RETURN
		ENDIF
		XiNroQui = VAL(XsNroQui)+1
	CASE NoCierre = 3
		WAIT WINDOW "Cierre de Mes Número: " + XsNroMes TIMEOUT 1
		IF XsNroMes = "12"
			GsMsgErr = "Debera realizar un Cierre Anual"
			MESSAGEBOX(GsMsgErr,0+48,"Atención")
			RETURN
		ENDIF
		XiNroMes = VAL(XsNroMes)+1
	CASE NoCierre = 4
		GsMsgErr = "No puede ser ejecutado por esta opción"
		MESSAGEBOX(GsMsgErr,0+48,"Atención")
		RETURN
ENDCASE
UltTecla = 0
SELECT PERS
SET FILTER TO CodPln = XsCodPln
GOTO TOP
TnBorrados = 0
TnDMovt = 0
TnContador = 0
TnNumLin = 0
SELECT PERS
DO WHILE !EOF()
	DO CASE
		CASE NoCierre = 1
			XiNroMes = XiNroSem
		CASE NoCierre = 2
			XiNroMes = XiNroQui
		CASE NoCierre = 3
			XiNroMes = XiNroMes
	ENDCASE
	LsNroAct = TRANSFORM(XiNroMes-1,"@L ##")
	LsNroPer = TRANSFORM(XiNroMes,"@L ##")
	TsCodPer = CodPer
	TsGrpPer = GrpPer
	xSitPer = VALCAL("@SIT")
	xSitVac = 0
	WKfSaldo = 0
	LiNumLin = 0
	TnContador = TnContador + 1
	TsCuenta = LTRIM(STR(TnContador))+"/"+LTRIM(STR(RECCOUNT()))
	WAIT WINDOW "Procesando : "+TsCodPer+" "+TsCuenta NOWAIT
	DO Inicializa
	SELECT DMOV
	*!*	Grabamos nueva configuración *!*
	xLlave = XsCodPln+LsNroPer+PERS->CodPer+"@SIT"
	SEEK xLlave
	IF ! FOUND()
		APPEND BLANK
	ENDIF
	REPLACE CodPln WITH XsCodPln
	REPLACE NroPER WITH LsNroPer
	REPLACE CodPER WITH PERS->CodPer
	REPLACE CodMov WITH '@SIT'
	REPLACE ValRef WITH 0
	REPLACE ValCal WITH xSitPer
	IF xSitPer = 6  && Vacaciones
		REPLACE ValCal WITH  1
		xSitPer = 1
	ENDIF
	IF xSitVac = 1
		REPLACE ValCal WITH  6
		xSitPer = 6
		xSitVac = 0
	ENDIF
	IF xSitPer > 1
		SELECT DMOV
		xLLave =  XsCodPln+LsNroPer+TsCodPer+"BA01"
		SEEK xLlave
		IF FOUND()
			REPLACE VALCAL WITH 0
		ENDIF
	ENDIF
	*** Actualizando datos de cuenta corriente ***
	SELECT CCTE
	SEEK PERS->CODPER
	REPLACE REST SDOANT WITH SDODOC WHILE CodPer = PERS->CODPER
	SELECT PERS
	SKIP
ENDDO
IF NoCierre = 4
	SET TALK ON
	SET TALK WINDOWS
	SELECT DMOV
	DELETE FOR NroPer > '01'
	PACK
	SET TALK OFF
ENDIF
DO CASE
	CASE NoCierre = 1
		PlnNroSem = PlnNroSem + 1
	CASE NoCierre = 2
		PlnNroQui = PlnNroQui + 1
	CASE NoCierre = 3
		PlnNroMes = PlnNroMes + 1
	CASE NoCierre = 4
		PlnNroSem = 1
		PlnNroQui = 1
		PlnNroMes = 1
		PlnNroAno = PlnNroAno + 1
ENDCASE
XsNroMes = TRANSF(PlnNroMes,"@L ##")
XsNroSem = TRANSF(PlnNroSem,"@L ##")
*!*	XsNroQui = TRANSF(PLNNroQui,"@L ##")
XsNroPer = XsNroMes
DO CASE
	CASE NoCierre = 1
		XsNroPer = XsNroSem
	CASE NoCierre = 2
		XsNroPer = XsNroQui
	CASE NoCierre = 3
		XsNroPer = XsNroMes
ENDCASE
_Ano = PlnNroAno
SAVE TO PLNCONFG ALL LIKE PlnNro???
RETURN

********************
PROCEDURE INICIALIZA
********************
*!*	Copiando todos los datos que conservan su valor de un periodo a otro
SELECT DMOV
yLLave = XsCodPln+LsNroAct+TsCodPer
SEEK yLLave
DO WHILE ! EOF() .and. CodPln+NroPer+CodPer = yLLave
	IF LEFT(CodMov,1) >= "R"
		EXIT
	ENDIF
	RegAct = RECNO()
	SELECT TMOV
	SEEK DMOV->CodMov
	IF FOUND()
		IF TMOV->CIEMOV = 0
			SELECT DMOV
			XnValCal = Valcal
			xLlave = XsCodPln+LsNroPer+PERS->CodPer+TMOV->CodMov
			SEEK xLLave
			IF XnValCal <> 0
				IF ! FOUND()
					APPEND BLANK
				ENDIF
			ENDIF
			REPLACE CodPln WITH  XsCodPln
			REPLACE NroPER WITH  LsNroPer
			REPLACE CodPER WITH  PERS->CodPer
			REPLACE CodMov WITH  TMOV->CodMov
			REPLACE ValRef WITH  0
			REPLACE ValCal WITH  XnValCal
			IF ! EOF()
				SKIP
			ENDIF
			DO WHILE ! EOF() .and. CodPln+NroPer+CodPer+CodMov = xLLave
				DELETE
				SKIP
			ENDDO
			GOTO RegAct
		ENDIF
	ENDIF
	SELECT DMOV
	SKIP
ENDDO
*!*	Inicializando todas las variables que deben ser cerradas *!*
SELECT TMOV
GOTO TOP
SCAN FOR (LEFT(CODMOV,1)<"R" .AND. LEFT(CODMOV,1)>"A") .AND. CieMov <> 0
	SELECT DMOV
	XnValCal = TMOV->ValMov
	xLlave = XsCodPln+LsNroPer+PERS->CodPer
	SEEK xLLave+TMOV->CodMov
	IF XnValCal <> 0
		xLlave = XsCodPln+LsNroPer+PERS->CodPer+TMOV->CodMov
		SEEK xLLave
		IF ! FOUND()
			APPEND BLANK
		ENDIF
		REPLACE CodPln WITH  XsCodPln
		REPLACE NroPER WITH  LsNroPer
		REPLACE CodPER WITH  PERS->CodPer
		REPLACE CodMov WITH  TMOV->CodMov
		REPLACE ValRef WITH  0
		REPLACE ValCal WITH  XnValCal
		SKIP
		DO WHILE ! EOF() .and. CodPln+NroPer+CodPer+CodMov = xLLave
			DELETE
		ENDDO
	ELSE
		IF FOUND()
			REPLACE ValRef WITH  0
			REPLACE ValCal WITH  0
			SKIP
			DO WHILE ! EOF() .and. CodPln+NroPer+CodPer+CodMov = xLLave
				DELETE
			ENDDO
		ENDIF
	ENDIF
	SELECT TMOV
ENDSCAN
RETURN
