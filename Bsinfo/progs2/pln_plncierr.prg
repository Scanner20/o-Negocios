****************************
* Cierres para la planilla *
****************************
*!*	Declaramos Variables
PARAMETERS NoCierre		&& Usamos parametro para tipo de cierre
PlnNroMes = VAL(XsNroMes)
PlnNroSem = VAL(XsNroSem)
PlnNroAno = _Ano
*!*	Aperturamos tablas a utilizarce
DO Apertura_Dbf
*!*	Ejecutamos Formulario
DO FORM Pln_PlnCierr
RETURN

**********************
PROCEDURE Apertura_Dbf
**********************
goentorno.open_dbf1('ABRIR','PLNDCCTE','CCTE','CCTE01','')
DO CASE
	CASE XsCodPln = '1'
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = '2'
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = '3'
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
	CASE XsCodPln = '4'
		goentorno.open_dbf1('ABRIR','PLNTMOV4','TMOV','TMOV01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
goentorno.open_dbf1('ABRIR','PLNMPDER','PDER','PDER01','')

****************
PROCEDURE Cierre
****************
oPln = CREATEOBJECT('DosVr.Planillas')
cSemana = XsNroSem
cMensual = XsNroMes

DO CASE
	CASE NoCierre = 1
		WAIT WINDOW 'Cierre de Semana Número: ' + XsNroSem TIMEOUT 1
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
		IF XsNroMes = '12'
			GsMsgErr = "Debera realizar un Cierre Anual"
			MESSAGEBOX(GsMsgErr,0+48,"Atención")
			RETURN
		ENDIF
		XiNroMes = VAL(XsNroMes)+1
	CASE NoCierre = 4
		PlnNroSem = 1
		PlnNroQui = 1
		PlnNroMes = 1
		PlnNroAno = PlnNroAno + 1
		GsMsgErr = 'Cierre Anual de Operaciones'
		MESSAGEBOX(GsMsgErr,0+48,"Atención")
		DO Cierre_Anual
		RETURN
ENDCASE
UltTecla = 0
DO Traslada_Generales
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
		CASE NoCierre = 4
			DO Cierre_Anual
			RETURN
	ENDCASE
	LsNroAct = TRANSFORM(XiNroMes-1,"@L ##")
	LsNroPer = TRANSFORM(XiNroMes,"@L ##")
	TsCodPer = CodPer
	TsGrpPer = GrpPer
	xSitPer = oPln.ValCal("@SIT")
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
	IF !FOUND()
		APPEND BLANK
	ENDIF
	REPLACE CodPln WITH XsCodPln
	REPLACE NroPer WITH LsNroPer
	REPLACE CodPer WITH PERS.CodPer
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
		xLLave = XsCodPln+LsNroPer+TsCodPer+'BA01'
		SEEK xLlave
		IF FOUND()
			REPLACE ValCal WITH 0
		ENDIF
	ENDIF
	*!*	Actualizando datos de cuenta corriente *!*
	SELECT CCTE
	SEEK PERS.CodPer
	REPLACE REST SDOANT WITH SDODOC WHILE CodPer = PERS.CodPer
	SELECT PERS
	SKIP
ENDDO
*!*	IF NoCierre = 4
*!*		SET TALK ON
*!*		SET TALK WINDOWS
*!*		SELECT DMOV
*!*		DELETE FOR NroPer > '01'
*!*		PACK
*!*		SET TALK OFF
*!*	ENDIF
DO CASE
	CASE NoCierre = 1
		PlnNroSem = PlnNroSem + 1
	CASE NoCierre = 2
		PlnNroQui = PlnNroQui + 1
	CASE NoCierre = 3
		PlnNroMes = PlnNroMes + 1
ENDCASE
XsNroMes = TRANSFORM(PlnNroMes,'@L ##')
XsNroSem = TRANSFORM(PlnNroSem,'@L ##')
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
WAIT WINDOW 'PROCESO TERMINADO' NOWAIT 
RETURN

********************
PROCEDURE INICIALIZA
********************
*!*	Copiando todos los datos que conservan su valor de un periodo a otro
SELECT DMOV
yLLave = XsCodPln+LsNroAct+TsCodPer
SEEK yLLave
DO WHILE ! EOF() .AND. CodPln+NroPer+CodPer = yLLave
	IF LEFT(CodMov,1) >= 'R'
		EXIT
	ENDIF
	RegAct = RECNO()
	SELECT TMOV
	SEEK DMOV.CodMov
	IF FOUND()
		IF TMOV.CIEMOV = 0
			SELECT DMOV
			XnValCal = Valcal
			xLlave = XsCodPln+LsNroPer+PERS.CodPer+TMOV.CodMov
			SEEK xLLave
			IF XnValCal <> 0
				IF !FOUND()
					APPEND BLANK
					REPLACE CodPln WITH XsCodPln
					REPLACE NroPER WITH LsNroPer
					REPLACE CodPER WITH PERS.CodPer
					REPLACE CodMov WITH TMOV.CodMov
				ENDIF
				REPLACE ValRef WITH 0
				REPLACE ValCal WITH XnValCal
			ENDIF
			IF !EOF()
				SKIP
			ENDIF
			DO WHILE !EOF() .AND. CodPln+NroPer+CodPer+CodMov = xLLave
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
LOCATE
SCAN FOR (LEFT(CodMov,1)<'R' .AND. LEFT(CodMov,1)>'A') .AND. CieMov <> 0
	SELECT DMOV
	xLlave = XsCodPln+XsNroPer+PERS.CodPer
	SEEK xLLave+TMOV.CodMov
	XnValCal = DMOV.ValCal
	IF XnValCal <> 0
		xLlave = XsCodPln+LsNroPer+PERS.CodPer+TMOV.CodMov
		SEEK xLLave
		IF ! FOUND()
			APPEND BLANK
			REPLACE CodPln WITH XsCodPln
			REPLACE NroPER WITH LsNroPer
			REPLACE CodPER WITH PERS.CodPer
			REPLACE CodMov WITH TMOV.CodMov
		ENDIF
		REPLACE ValRef WITH 0
		REPLACE ValCal WITH IIF(TMOV.CieMov=0,XnValCal,0) && Inicializamos el valor
		IF !EOF()
			SKIP
		ENDIF
		DO WHILE !EOF() .AND. CodPln+NroPer+CodPer+CodMov = xLLave
			DELETE
			SKIP
		ENDDO
*!*		ELSE
*!*			IF FOUND()
*!*				REPLACE ValRef WITH 0
*!*				REPLACE ValCal WITH 0
*!*				SKIP
*!*				DO WHILE ! EOF() .AND. CodPln+NroPer+CodPer+CodMov = xLLave
*!*					DELETE
*!*					SKIP
*!*				ENDDO
*!*			ENDIF
	ENDIF
	SELECT TMOV
ENDSCAN
RETURN

**********************
PROCEDURE Cierre_Anual
**********************
WAIT WINDOW 'Iniciando Cierre Anual de Operaciones' NOWAIT
*!*	Abrimos Tablas del Año Siguiente
DO Apertura_Dbf_Anho1
*!*	Trasladamos variables del TMOV por planillas
SELECT TMOV_A
GO TOP
APPEND FROM TMOV
*!*	Trasladamos maestro de personal
SELECT PERS_A
GO TOP
APPEND FROM PERS FOR !EMPTY(FchCes)
SCAN WHILE !EOF()
	*!*	Trasladamos derechohabientes de personal activo
	SELECT PDER
	WAIT WINDOW 'Procesando: ' + ALLTRIM(PERS_A.NomPer) NOWAIT
	SEEK XsCodPln + PERS_A.CodPer
	SCAN WHILE PDER.CodPer = PERS_A.CodPer
		SELECT PDER
		SCATTER MEMVAR
		SELECT PDER_A
		APPEND BLANK
		GATHER MEMVAR
	ENDSCAN
	SELECT PERS_A
ENDSCAN
WAIT WINDOW 'Finalización del Cierre Anual de Operaciones' NOWAIT

****************************
PROCEDURE Apertura_Dbf_Anho1
****************************
WAIT WINDOW 'Aperturando archivos del siguiente año' NOWAIT
DirNew = Lodatadm.oentorno.tsPathCia + 'C' +STR(_Ano+1,4,0)
SELECT 0
DO CASE
	CASE XsCodPln = '1'
		cArcNew = DirNew + '\PLNBLP11'
		USE &cArcNew ORDER BPGO01 ALIAS BLP1_A
	CASE XsCodPln = '2'
		cArcNew = DirNew + '\PLNBLP22'
		USE &cArcNew ORDER BPGO01 ALIAS BLP2_A
ENDCASE
SELECT 0
DO CASE
	CASE XsCodPln = '1'
		cArcNew = DirNew + '\PLNBLPG1'
		USE &cArcNew ORDER BPGO01 ALIAS BPO1_A
	CASE XsCodPln = '2'
		cArcNew = DirNew + '\PLNBLPG2'
		USE &cArcNew ORDER BPGO01 ALIAS BPO2_A
ENDCASE
SELECT 0
DO CASE
	CASE XsCodPln = '1'
		cArcNew = DirNew + '\PLNCFGP1'
		USE &cArcNew ORDER CFGP101 ALIAS CFGP1_A
	CASE XsCodPln = '2'
		cArcNew = DirNew + '\PLNCFGP2'
		USE &cArcNew ORDER CFGP101 ALIAS CFGP2_A
ENDCASE
SELECT 0
cArcNew = DirNew + '\PLNDCCTE'
USE &cArcNew ORDER CCTE01 ALIAS CCTE_A
SELECT 0
cArcNew = DirNew + '\PLNDECTS'
USE &cArcNew ORDER DECT01 ALIAS DECT_A
SELECT 0
cArcNew = DirNew + '\PLNDJUDI'
USE &cArcNew ORDER DJUD01 ALIAS DJUD_A
SELECT 0
cArcNew = DirNew + '\PLNDMOVT'
USE &cArcNew ORDER DMOV01 ALIAS DMOV_A
SELECT 0
cArcNew = DirNew + '\PLNEMOVT'
USE &cArcNew ORDER DMOV01 ALIAS EMOV_A
SELECT 0
cArcNew = DirNew + '\PLNESTAB'
USE &cArcNew ORDER ESTA01 ALIAS ESTA_A
SELECT 0
cArcNew = DirNew + '\PLNMASIT'
USE &cArcNew ORDER ASIT01 ALIAS ASIT_A
SELECT 0
cArcNew = DirNew + '\PLNMPDER'
USE &cArcNew ORDER PDER01 ALIAS PDER_A
SELECT 0
cArcNew = DirNew + '\PLNMPERS'
USE &cArcNew ORDER PERS01 ALIAS PERS_A
SELECT 0
cArcNew = DirNew + '\PLNMTSEM'
USE &cArcNew ORDER SEMA01 ALIAS SEMA_A
SELECT 0
cArcNew = DirNew + '\PLNPERIO'
USE &cArcNew ORDER PRDO01 ALIAS PRDO_A
SELECT 0
cArcNew = DirNew + '\PLNTDIAS'
USE &cArcNew ALIAS DIAS_A
SELECT 0
DO CASE
	CASE XsCodPln = '1'
		cArcNew = DirNew + '\PLNTMOV1'
		USE &cArcNew ORDER TMOV01 ALIAS TMOV_A
	CASE XsCodPln = '2'
		cArcNew = DirNew + '\PLNTMOV2'
		USE &cArcNew ORDER TMOV01 ALIAS TMOV_A
	CASE XsCodPln = '3'
		cArcNew = DirNew + '\PLNTMOV3'
		USE &cArcNew ORDER TMOV01 ALIAS TMOV_A
	CASE XsCodPln = '4'
		cArcNew = DirNew + '\PLNTMOV4'
		USE &cArcNew ORDER TMOV01 ALIAS TMOV_A
ENDCASE
SELECT 0
cArcNew = DirNew + '\PLNTPERI'
USE &cArcNew ALIAS PERI_A
SELECT 0
cArcNew = DirNew + '\PLNTTCMB'
USE &cArcNew ORDER TCMB01 ALIAS TCMB_A
WAIT WINDOW 'Termina Apertura' NOWAIT

****************************
PROCEDURE Traslada_Generales
****************************
WAIT WINDOW 'Transfiriendo Variables Generales' NOWAIT
SELECT TMOV
SEEK 'A'
SCAN WHILE CodMov = 'A'
	SELECT DMOV
	lKey = XsCodPln + XsNroPer + SPACE(LEN(PERS.CodPer)) + TMOV.CodMov
	SEEK lKey
	XsNroPer_a = TRANSFORM(VAL(NroPer)+1,'@L ##')
	XsCodMov_a = CodMov
	XnValCal_a = ValCal
	XnValRef_a = ValRef
	XsFlgEst_a = FlgEst
	lKey_a = XsCodPln + XsNroPer_a + SPACE(LEN(PERS.CodPer)) + XsCodMov_a
	SEEK lKey_a
	IF !FOUND()
		APPEND BLANK
		REPLACE CodPln WITH XsCodPln
		REPLACE NroPer WITH XsNroPer_a
		REPLACE CodPer WITH ''
		REPLACE CodMov WITH XsCodMov_a
		REPLACE ValCal WITH XnValCal_a
		REPLACE ValRef WITH XnValRef_a
		REPLACE FlgEst WITH XsFlgEst_a
	ENDIF
	SELECT TMOV
ENDSCAN
WAIT WINDOW 'Finaliza Transferencia de Variable Generales' NOWAIT