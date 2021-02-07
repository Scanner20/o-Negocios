**************************************************************************
*  Nombre    : PlngCalc.PRG                                              *
*  Objeto    : Cálculo de Planilla.                                      *
*  Par metros:    TipCal                                                 *
*  Creaci¢n     : 18/12/90                                               *
*  Actualizaci¢n: 13/10/98                                               *
**************************************************************************
PRIVATE Escape,XsCodPln,XsNroPer
Escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	Aperturamos tablas a utilizar *!*
DO Mov_Aperturar
*!*	Ejecutamos Formulario
cTipMov = ""
SelCia = 1
NomArch = ""
DO FORM pln_plngcalc
RETURN

***********************
PROCEDURE Mov_Aperturar
***********************
goentorno.open_dbf1('ABRIR','PLNEMOVT','EMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','PLNDJUDI','JUDI','DJUD01','')
goentorno.open_dbf1('ABRIR','PLNDCCTE','CCTE','CCTE01','')
goentorno.open_dbf1('ABRIR','PLNESTAB','ESTA','ESTA01','')
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
goentorno.open_dbf1('ABRIR','PLNMTSEM','SEMA','SEMA01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')

*************************
PROCEDURE xGenera_Calculo
*************************
PARAMETER cTipMov
oPln = CREATEOBJECT('DosVr.Planillas')
=SEEK(PsCodPln+XsCodPln,'TABL')
LsNomPla = TABL.Nombre
LsRutaArc = ADDBS(GoEntorno.TmpPath)
DO CASE
	CASE XsCodPln = '1'
		NomArch = LsRutaArc+"PLNVAR1"+CTipMov+".cal"
	CASE XsCodPln = '2'
		NomArch = LsRutaArc+"PLNVAR2"+CTipMov+".cal"
	CASE XsCodPln = '3'
		NomArch = LsRutaArc+"PLNVAR3"+CTipMov+".cal"
	CASE XsCodPln = '4'
		NomArch = LsRutaArc+"PLNVAR4"+CTipMov+".cal"
ENDCASE
IF !FILE(NomArch)
	MESSAGEBOX('No se ha generado correctamente las formulas para este calculo.'+;
				"Ingrese a la opción [Variables Generales de Cálculo] ubicada en el "+; 
				"siguiente menu --> "+ TRIM(LsNomPla)+"\Sistemas\Programacion.",48,'Aviso importante' )
	RETURN
ENDIF
NomVar = ''
XXXVar = ''
SELECT PERS
SET FILTER TO CodPln = XsCodPln
GO TOP
SELECT SEMA
GO TOP
PRIVATE XsIniGra,XsFinGra  && SEMANA INICIAL Y FINAL PARA GRATIFICACION
STORE 0 TO XsIniGra,XsFinGra
IF MONTH(DATE()) = 7
	XsIniGra = 1
	IF !EOF()
		GO TOP
		LOCATE FOR VAL(Mes) > 6
		SKIP - 1
		XsFinGra = VAL(Sema)
	ELSE
		XsFinGra = 33
	ENDIF
ENDIF
IF MONTH(DATE()) = 12
	GO TOP
	LOCATE FOR VAL(Mes) > 6
	XsIniGra = VAL(Sema)
	GO BOTT
	XsFinGra = VAL(Sema)
ENDIF
SELECT PERS
XiNroPla = VAL(XsNroPer)
DO CASE
	CASE XsCodPln = '1'
		WAIT WINDOW "Mes Proceso : " + UPPER(MES(XiNroPla)) NOWAIT
	CASE XsCodPln = '2'
		WAIT WINDOW "Semana Número : " + XsNroPer NOWAIT
	CASE XsCodPln = '3'
		WAIT WINDOW "Semana Número : " + XsNroPer NOWAIT
	CASE XsCodPln = '4'
		WAIT WINDOW "Mes Proceso : " + UPPER(MES(XiNroPla)) NOWAIT
ENDCASE
ActBol = 'S'
GiMaxEle = 0
Bloque = 1
UltTecla = 0
SelSec = 1
SelPer = 1
xSitPer = 0
xSitVac = 0
XfTpoCmb = 1
TnNumLin = 50
XcFlgEst = ''
STORE SPACE(LEN(PERS.CodPer)) TO Desde,Hasta
TnContador = 0
TnNumLin = 0
NomVar = ''
*!*	nNroBol = oPln.ValCal('AA06')	&& MAAV
IF SelCia = 1
	DO WHILE ! EOF()
		SELE DMOV
		IF cTipMov='V'
			SEEK XsCodPln+XsNroPer+PERS.CodPer+"@SIT"
			IF ValCal # 6
				SELECT PERS
				SKIP
				LOOP
			ELSE
				** Borramos calculo mensual/semanal de este periodo
				zLlave = XsCodPln+XsNroPer+PERS.CodPer+"R"
				SEEK zLLave
				DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
				zLlave = XsCodPln+XsNroPer+PERS.CodPer+"S"
				SEEK zLLave
				DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
			ENDIF
		ELSE
			SEEK XsCodPln+XsNroPer+PERS->CodPer+"@SIT"
			IF ValCal = 6
				SELECT PERS
				SKIP
				LOOP
			ENDIF
		ENDIF
		SELECT PERS
		DO LinCal
		SELECT PERS
		SKIP
	ENDDO
	*!*	Actualizando número boleta actual *!*	&& MAAV
*!*		SELECT DMOV
*!*		ZsCodMov = "AA05"
*!*		xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))+ZsCodMov
*!*		SEEK xLLave
*!*		IF ! FOUND()
*!*			APPEND BLANK
*!*		ENDIF
*!*		REPLACE CodMov WITH ZsCodMov
*!*		REPLACE ValRef WITH 0
*!*		REPLACE ValCal WITH nNroBol
ELSE
	SELECT LPER
	GO TOP
	SCAN WHILE !EOF()
		SELECT PERS
		SEEK LPER.CodPer
		IF !FOUND()   && para ver si lo encuentra
			WAIT WINDOW 'Código no existe. Enter para continuar'
		ELSE
			DO LinCal
		ENDIF
	ENDSCAN
ENDIF
WAIT WINDOW 'Proceso concluido' NOWAIT
RETURN

************************
*!*	Linea de Cálculo *!*
************************
PROCEDURE LinCal
****************
TsCodPer = CodPer
*!*	TsGrpPer = GrpPer
xSitPer = oPln.ValCal('@SIT')
*!*	xSitVac = VALCAL("@VAC")
*!*	Verificamos si le toca vacaciones *!*
SELECT DMOV
ZsCodMov = '@VAC'
xLlave = XsCodPln + XsNroPer + PERS.CodPer + ZsCodMov
SEEK xLLave
IF ! FOUND()
	APPEND BLANK
ENDIF
REPLACE CodPln WITH XsCodPln
REPLACE NroPER WITH XsNroPer
REPLACE CodPER WITH PERS.CodPer
REPLACE CodMov WITH ZsCodMov
REPLACE ValRef WITH 0
SELECT PERS
TopeMax = 0
WKfSaldo = 0
LiNumLin = 1
TnContador = TnContador + 1
TsCuenta = LTRIM(STR(TnContador))+"/"+LTRIM(STR(RECCOUNT()))
WAIT WINDOW "Procesando : "+TsCodPer+" "+TsCuenta NOWAIT
IF xSitPer = 5	&& Inactivo 
	SELECT DMOV
	zLlave = XsCodPln+XsNroPer+TsCodPer+cTipMov
	SEEK zLLave
	DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
	zLlave = XsCodPln+XsNroPer+TsCodPer+"M"
	SEEK zLLave
	DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
ELSE
	SELECT DMOV
	zLlave = XsCodPln+XsNroPer+TsCodPer+cTipMov
	SEEK zLLave
	DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
	IF xSitPer <> 6 && No esta de vacaciones
		** A los que no estan de vacaciones **
		zLlave = XsCodPln+XsNroPer+TsCodPer+"V"
		SEEK zLLave
		DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
	ENDIF
	
	DO (NomArch)
*!*		IF SelCia = 1 .AND. ActBol = 'S'		&& MAAV
*!*			*!*	Actualizamos su correlativo *!*
*!*			ZsCodMov = 'CZ01'
*!*			xLlave = XsCodPln+XsNroPer+PERS.CodPer+ZsCodMov
*!*			SEEK xLLave
*!*			IF !FOUND()
*!*				APPEND BLANK
*!*			ENDIF
*!*			REPLACE CodPln WITH XsCodPln
*!*			REPLACE NroPER WITH XsNroPer
*!*			REPLACE CodPER WITH PERS.CodPer
*!*			REPLACE CodMov WITH ZsCodMov
*!*			REPLACE ValRef WITH 0
*!*			REPLACE ValCal WITH nNroBol
*!*			nNroBol = nNroBol + 1
*!*		ENDIF
ENDIF
RETURN

******************************************************
*!*	Toma los valores de los conceptos del personal *!*
******************************************************
PROCEDURE GetVar
****************
PARAMETER WKsVar
IF "."$WKsVar
	RETURN SUMA(WKsVar)
ENDIF
PRIVATE WKnVal,TlTitle
WKnVal = 0
TlTitle  = RIGHT(WKsVar,LEN(WKsVar)-2)=REPLICATE('0',LEN(WKsVar)-2)
IF WKsVar = 'A'
	SELECT TMOV
	IF TlTitle
		SEEK SUBSTR(WKsVar,1,2)
		DO WHILE CodMov = SUBSTR(WKsVar,1,2) .AND. !EOF()
			SELECT DMOV
			xLlave = XsCodPln + XsNroPer + SPACE(LEN(DMOV.CodPer))
			SEEK xLLave + TMOV.CodMov
			WKnVaL = WKnVaL + ValCal
			SELECT TMOV
			SKIP
		ENDDO
	ELSE
		SELECT DMOV
		xLlave = XsCodPln + XsNroPer + SPACE(LEN(DMOV.CodPer))
		SEEK xLLave+WKsVar
		IF FOUND()
			WKnVaL = ValCal
			SELECT TMOV
		ENDIF
	ENDIF
ELSE
	IF TlTitle
		SELECT TMov
		SEEK SUBSTR(WKsVar,1,2)
		DO WHILE CodMov=SUBSTR(WKsVar,1,2)  .AND. ! EOF()
			SELECT DMOV
			XCLAVE = XsCodPln + XsNroPer + PERS.CodPer + TMOV.CodMov
			SEEK XCLAVE
			DO WHILE CodPln + NroPer + CodPer + CodMov = XCLAVE .AND. !EOF()
				WKnVaL = WKnVaL + ValCal
				SKIP
			ENDDO
			SELECT TMOV
			SKIP
		ENDDO
	ELSE
		SELECT DMOV
		XCLAVE = XsCodPln + XsNroPer + PERS.CodPer + WKsVar
		SEEK XCLAVE
		IF FOUND()
			WKnVaL = ValCal
		ENDIF
	ENDIF
ENDIF
RETURN WKnVal

**************************
*!*	Valor del Redondeo *!*
**************************
PROCEDURE ValRed
****************
PARAMETERS WKnVal,WKnRed
PRIVATE WknVal1
WKnVal1 = WKnRed-MOD(WKnVal,WknRed)
RETURN WKnVal1

***********************************************
*!*	@TRAHORNOC Trabajador Horarion Nocturna *!*
***********************************************
PROCEDURE TraHorNoc
*******************
XnTraHorNoc = VAL(PERS.TraHorNoc)
RETURN(XnTraHorNoc)

************************************
*!*	@TRACESADO Trabajador cesado *!*
************************************
PROCEDURE TraCesado
*******************
XlTraCesado = PERS.TraCesado
RETURN(XlTraCesado)

**********************************
*!*	@HONO() Mes de honomástico *!*
**********************************
PROCEDURE HONO
**************
XsHono = VAL(SUBSTR(DTOC(PERS.FchNac),4,2))
RETURN(XsHono)

********************************
*!*	@ESS Regimen Pensionario *!*
********************************
PROCEDURE ESS
*************
RETURN VAL(PERS.CodEss)

********************************
*!*	@AFP Regimen Pensionario *!*
********************************
PROCEDURE AFP
*************
RETURN VAL(PERS.CodAfp)

**********************************************
*!*	@NROSSEMA Numeros de Semanas en un Mes *!*
**********************************************
PROCEDURE NROSSEMA
******************
SELECT SEMA
COUNT FOR Mes = XsNroMes TO NrosSema
RETURN NrosSema

**************************
*!*	@SCTSAL SCTR Salud *!*
**************************
PROCEDURE SCTSAL
****************
RETURN VAL(PERS.SctSal)

****************************
*!*	@SCTPEN SCTR Pension *!*
****************************
PROCEDURE SCTPEN
****************
RETURN VAL(PERS.SctPen)

*************************
*!*	@TASSCT Tasa SCTR *!*
*************************
PROCEDURE TASSCT
****************
=SEEK(PERS.CodEst,'ESTA','ESTA02')
IF ESTA.CenRie_a = '1'
	nTasSct = ESTA.Tasa_a/100
ELSE
	nTasSct = 0.00
ENDIF
RETURN(nTasSct)

*******************************
*!*	@NHIJOS Número de hijos *!*
*******************************
PROCEDURE NHIJOS
****************
RETURN(PERS.NHijos)

*********************************
*!*	@PVAC() Mes de vacaciones *!*
*********************************
PROCEDURE PVAC
**************
XsPvac = VAL(PERS.MesVac)
RETURN(XsPvac)

***************
*!* @DIAS() *!*
***************
PROCEDURE DIAS
**************
RETURN(dFchFin-dFchIni)

**************
*!* @DOM() *!*
**************
PROCEDURE DOM
*************
PRIVATE dFch1,dFch2,nDias
dFch1 = dFchIni
dFch2 = dFchFin
IF DOW(dFch1) > 1
	dFch1 = dFch1 + 8 - DOW(dFch1)
ENDIF
IF DOW(dFch2) > 1
	dFch2 = dFch2 - DOW(dFch2) + 1
ENDIF
nDias = dFch2 - dFch1
IF nDias > 0
	RETURN ( INT(nDia/7) + 1 )
ELSE
	RETURN (0)
ENDIF

***************
*!*	@DIAV() *!*
***************
PROCEDURE DIAV
**************
RETURN(PERS.FinVac-PERS.IniVac)

***************
*!*	@DOMV() *!*
***************
PROCEDURE DOMV
**************
PRIVATE dFch1,dFch2,nDias
dFch1 = PERS->IniVac
dFch2 = PERS->FinVac
IF DOW(dFch1) > 1
	dFch1 = dFch1 + 8 - DOW(dFch1)
ENDIF
IF DOW(dFch2) > 1
	dFch2 = dFch2 - DOW(dFch2) + 1
ENDIF
nDias = dFch2 - dFch1
IF nDias > 0
	RETURN (INT(nDia/7) + 1)
ELSE
	RETURN (0)
ENDIF

******************
*!*	@SUMA(.,.) *!*
******************
PROCEDURE SUMA
**************
PARAMETERS VAR
VAR1 = LEFT(VAR,4)
VAR2 = LEFT(VAR,2)+RIGHT(VAR,2)
WKnVal = 0
SELECT TMOV
SEEK VAR1
IF ! FOUND() .AND. (RECNO(0)>0 .AND. RECNO(0)<RECCOUNT())
	GOTO RECNO(0)
ENDIF
DO WHILE (CodMov)<=VAR2  .AND. ! EOF()
	SELECT DMOV
	IF Var1 = 'A'
		xLlave = SPACE(1+Len(DMOV.NroPer))+SPACE(Len(DMOV.CodPer))
	ELSE
		xLlave = XsCodPln + XsNroPer + PERS.CodPer
	ENDIF
	SEEK xLLave + TMOV.CodMov
	WKnVaL = WKnVaL + ValCal
	SELECT TMOV
	SKIP
ENDDO
RETURN WKnVal

*****************
*!*	@NUMPER() *!*
*****************
PROCEDURE NUMPER
****************
RETURN VAL(XsNroMes)

*************************
*!*	@CASO(..,.......) *!*
*************************
PROCEDURE CASO
**************
PARAMETERS VAR,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
PRIVATE iVar
iVar = INT(Var)
DO CASE
	CASE iVar = 10 .AND. TYPE("WK1") = "N"
		RETURN WK1
	CASE iVar = 11 .AND. TYPE("WK2") = "N"
		RETURN WK2
	CASE iVar = 12 .AND. TYPE("WK3") = "N"
		RETURN WK3
	CASE iVar = 2 .AND. TYPE("WK4") = "N"
		RETURN WK4
	CASE iVar = 21 .AND. TYPE("WK5") = "N"
		RETURN WK5
	CASE iVar = 22 .AND. TYPE("WK6") = "N"
		RETURN WK6
	CASE iVar = 23 .AND. TYPE("WK7") = "N"
		RETURN WK7
	CASE iVar = 24 .AND. TYPE("WK8") = "N"
		RETURN WK8
	CASE iVar = 3 .AND. TYPE("WK9") = "N"
		RETURN WK9
	CASE iVar = 9 .AND. TYPE("WK10") = "N"
		RETURN WK10
	CASE iVar = 99 .AND. TYPE("WK11") = "N"
		RETURN WK11
	CASE iVar = 12 .AND. TYPE("WK12") = "N"
		RETURN WK12
	CASE iVar = 13 .AND. TYPE("WK13") = "N"
		RETURN WK13
	CASE iVar = 14 .AND. TYPE("WK14") = "N"
		RETURN WK14
	CASE iVar = 15 .AND. TYPE("WK15") = "N"
		RETURN WK15
	CASE iVar = 16 .AND. TYPE("WK16") = "N"
		RETURN WK16
	CASE iVar = 17 .AND. TYPE("WK17") = "N"
		RETURN WK17
	CASE iVar = 18 .AND. TYPE("WK18") = "N"
		RETURN WK18
	CASE iVar = 19 .AND. TYPE("WK19") = "N"
		RETURN WK19
	CASE iVar = 20 .AND. TYPE("WK20") = "N"
		RETURN WK20
ENDCASE
RETURN 0

************************
*!*	@SEL(..,.......) *!*
************************
PROCEDURE SEL
*************
PARAMETERS VAR,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
IF TYPE("WK1") = "N" .AND. Var = WK1
	RETURN 1
ENDIF
IF TYPE("WK2") = "N" .AND. Var = WK2
	RETURN 1
ENDIF
IF TYPE("WK3") = "N" .AND. Var = WK3
	RETURN 1
ENDIF
IF TYPE("WK4") = "N" .AND. Var = WK4
	RETURN 1
ENDIF
IF TYPE("WK5") = "N" .AND. Var = WK5
	RETURN 1
ENDIF
IF TYPE("WK6") = "N" .AND. Var = WK6
	RETURN 1
ENDIF
IF TYPE("WK7") = "N" .AND. Var = WK7
	RETURN 1
ENDIF
IF TYPE("WK8") = "N" .AND. Var = WK8
	RETURN 1
ENDIF
IF TYPE("WK9") = "N" .AND. Var = WK9
	RETURN 1
ENDIF
IF TYPE("WK10") = "N" .AND. Var = WK10
	RETURN 1
ENDIF
IF TYPE("WK11") = "N" .AND. Var = WK11
	RETURN 1
ENDIF
IF TYPE("WK12") = "N" .AND. Var = WK12
	RETURN 1
ENDIF
IF TYPE("WK13") = "N" .AND. Var = WK13
	RETURN 1
ENDIF
IF TYPE("WK14") = "N" .AND. Var = WK14
	RETURN 1
ENDIF
IF TYPE("WK15") = "N" .AND. Var = WK15
	RETURN 1
ENDIF
IF TYPE("WK16") = "N" .AND. Var = WK16
	RETURN 1
ENDIF
IF TYPE("WK17") = "N" .AND. Var = WK17
	RETURN 1
ENDIF
IF TYPE("WK18") = "N" .AND. Var = WK18
	RETURN 1
ENDIF
IF TYPE("WK19") = "N" .AND. Var = WK19
	RETURN 1
ENDIF
IF TYPE("WK20") = "N" .AND. Var = WK20
	RETURN 1
ENDIF
RETURN 0

*****************************************
*!* Quinta Categoria, escala de Topes *!*
*****************************************
PROCEDURE QESCALA
*****************
PARAMETERS WKnVal
PRIVATE IMPUESTO
Tope1 = oPln.ValCal("AD01")	&& 6%
Tope2 = oPln.ValCal("AD02")	&& 10%
Tope3 = oPln.ValCal("AD03")	&& 20%
Tope4 = oPln.ValCal("AD04")	&& 30%
Tope5 = oPln.ValCal("AD05")	&& 37%
Porc1 = oPln.ValCal("AD11")/100	&& 6%
Porc2 = oPln.ValCal("AD12")/100	&& 10%
Porc3 = oPln.ValCal("AD13")/100	&& 20%
Porc4 = oPln.ValCal("AD14")/100	&& 30%
Porc5 = oPln.ValCal("AD15")/100	&& 37%
IMPUESTO = 0
DO CASE
	CASE WKnVal <= Tope1
		IMPUESTO = WKnVal * Porc1
	CASE WKnVal <= Tope2
		IMPUESTO = Tope1 * Porc1
		IMPUESTO = IMPUESTO + (WKnVal-Tope1) * Porc2
	CASE WKnVal <= Tope3
		IMPUESTO = Tope1 * Porc1
		IMPUESTO = IMPUESTO + ( Tope2-Tope1) * Porc2
		IMPUESTO = IMPUESTO + (WKnVal-Tope2) * Porc3
	CASE WKnVal <= Tope4
		IMPUESTO = Tope1 * Porc1
		IMPUESTO = IMPUESTO + ( Tope2-Tope1) * Porc2
		IMPUESTO = IMPUESTO + ( Tope3-Tope2) * Porc3
		IMPUESTO = IMPUESTO + (WKnVal-Tope3) * Porc4
	CASE WKnVal > Tope4
		IMPUESTO = Tope1 * Porc1
		IMPUESTO = IMPUESTO + ( Tope2-Tope1) * Porc2
		IMPUESTO = IMPUESTO + ( Tope3-Tope2) * Porc3
		IMPUESTO = IMPUESTO + ( Tope4-Tope3) * Porc4
		IMPUESTO = IMPUESTO + (WKnVal-Tope4) * Porc5
ENDCASE
RETURN IMPUESTO

***************************************************************
*!*	Quinta Categoria, proyección lo que falta pagar del año *!*
***************************************************************
PROCEDURE QPROYEC
*****************
PARAMETERS presente
*!* Para instituciones privadas *!*
IF xSitVac = 1
	DO CASE
		CASE XiNroPla < 7
			RETURN PRESENTE*(14-XiNroPla)
		CASE XiNroPla < 12
			RETURN PRESENTE*(13-XiNroPla)
		CASE XiNroPLA = 12
			RETURN 0
	ENDCASE
ELSE
	DO CASE
		CASE XiNroPla < 6
			RETURN PRESENTE*(13-XiNroPla)
		CASE XiNroPla < 12
			RETURN PRESENTE*(12-XiNroPla)
		CASE XiNroPla = 12
			RETURN 0
	ENDCASE
ENDIF
RETURN 0

*************************************************
*!* Quinta Categoria, Proyección a fin de año *!*
*************************************************
PROCEDURE QUINTA
****************
PARAMETERS WKnVal
*!*	Para instituciones privadas *!*
IF xSitVac <> 1
	DO CASE
		CASE XiNroPla < 12
			RETURN WKnVal/(13-XiNroPla)
		CASE XiNroPla = 12
			RETURN WKnVal
	ENDCASE
ELSE
	*!*	 Si esta de vacaciones  *!*
	*!*	esta pagando un mes mas *!*
	DO CASE
		CASE XiNroPla < 11
			RETURN WKnVal*2/(13-XiNroPla)
		CASE XiNroPla > 10
			RETURN WKnVal
	ENDCASE
ENDIF
RETURN 0

*****************************
*!*	Situación de Personal *!*
*****************************
PROCEDURE SPER
**************
RETURN oPln.ValCal("@SIT")

**************************************
*!*	Verifica si se paga Vacaciones *!*
**************************************
PROCEDURE VAC
*************
RETURN IIF(xSitVac=1,2,1)

***********************
*!* Seco de Persona *!*
***********************
PROCEDURE SEXO
**************
RETURN(PERS.SexPer)

**************************
*!* Código de planilla *!*
**************************
PROCEDURE CODPLN
****************
RETURN VAL(PERS.CodPln)

**************************************
*!* Tiempo de serviciones en meses *!*
**************************************
PROCEDURE TSERV
***************
XTMPSRV = VAL(SUBSTR(STR(PERS->TMPSRV,6,0),1,2))*12 + VAL(SUBSTR(STR(PERS->TMPSRV,6,0),3,2))
XTMPSRV = XTMPSRV / IIF(PERS->SexPer="1",360,300)
IF XTMPSRV > 1
	XTMPSRV = 1
ENDIF
IF PERS.CodCat <> 'NONI'
	XTMPSRV = 1
ENDIF
RETURN XTMPSRV

***********************************
*!*	Número de codigo de sección *!*
***********************************
PROCEDURE CODSEC
****************
PARAMETER VAR1,VAR2
RETURN VAL(SUBSTR(PERS.CodSec,VAR1,VAR2))

*******************
*!*	Graba Datos *!*
*******************
PROCEDURE Graba
***************
PARAMETERS TsCodMov, cAGrpSi, cAGrpNo, cSitMov, cSitVar, nDecMov
LiNumLin = LiNumLin + 1
DO CASE
	CASE TnNumLin < 1
		WAIT WINDOW " " NOWAIT
	CASE LiNumLin/TnNumLin < .01
		WAIT WINDOW " " NOWAIT
	CASE LiNumLin/TnNumLin < .35
		WAIT WINDOW "|" NOWAIT
	CASE LiNumLin/TnNumLin < .69
		WAIT WINDOW "/" NOWAIT
	CASE LiNumLin/TnNumLin < .85
		WAIT WINDOW "-" NOWAIT
	OTHER
		WAIT WINDOW "\" NOWAIT
ENDCASE
Cond1 = (cAGrpSi$PERS->GrpPer .OR. cAGrpSi=' ')
Cond2 = !(cAGrpNo$PERS->GrpPer .AND. cAGrpNo<>' ')
TnNroDec = IIF(nDecMov>=0 .AND. nDecMov<=4,nDecMov,4)
TnValCal = ROUND(TnValCal,TnNroDec)
IF ! (Cond1 .AND. Cond2)
	TnValCal = 0.00
ENDIF
*!* Verificamos su FlgEst *!*
DO CASE
	CASE cSitMov = "V" .AND. xSitVac <> 1
		TnValCal = 0.00
	CASE cSitMov = "G" .AND. xSitVac = 1  .AND. INLIST(XiNroPla,6,11)
	CASE cSitMov = "G" .AND. ! INLIST(XiNroPla,7,12)
		TnValCal = 0.00
	CASE cSitMov = "G" .AND. xSitPer = 5
		TnValCal = 0.00
ENDCASE
SELECT DMOV
SEEK XsCodPln+XsNroPer+TsCodPer+TsCodMov
Sobregiro = .F.
XfSobreg  = 0
IF ! FOUND()
	IF cSitVar = "-" .AND. TopeMax < TnValCal
		XfSobreg = TnValCal - TopeMax
		TnValCal = TopeMax
		Sobregiro = .T.
	ENDIF
	IF ! TnValCal = 0
		APPEND BLANK
		REPLACE CodPln WITH XsCodPln
		REPLACE NroPer WITH XsNroPer
		REPLACE CodMov WITH TsCodMov
		REPLACE CodPer WITH TsCodPer
		REPLACE ValCal WITH TnValCal
		REPLACE FLgEst WITH XcFlgEst
	ENDIF
ELSE
	IF cSitVar = "-" .AND. TopeMax < TnValCal
		XfSobreg  = TnValCal - TopeMax
		TnValCal  = TopeMax
		Sobregiro = .T.
	ENDIF
	REPLACE ValCal WITH TnValCal
	REPLACE FLgEst WITH XcFlgEst
ENDIF
DO CASE
	CASE cSitVar = "T"
		TopeMax = Valcal
	CASE cSitVar = "-"
		TopeMax = TopeMax - TnValcal
ENDCASE
IF Sobregiro
	SELECT EMOV
	SEEK XsCodPln+XsNroPer+TsCodPer+TsCodMov
	IF ! FOUND()
		IF ! XfSobreg = 0
			APPEND BLANK
			REPLACE CodPln WITH XsCodPln
			REPLACE NroPer WITH XsNroPer
			REPLACE CodMov WITH TsCodMov
			REPLACE CodPer WITH TsCodPer
			REPLACE ValCal WITH XfSobreg
		ENDIF
	ELSE
		REPLACE ValCal WITH XfSobreg
	ENDIF
ENDIF
SELECT DMOV
RETURN

******************
PROCEDURE Grabaval
******************
SELECT DMOV
SEEK XsCodPln+XsNroPer+LsCodPer+ZsCodMov+STR(VAL(CCTE.NroDoc),6,0)
IF ! FOUND()
	IF LfImpDst = 0
		RETURN
	ENDIF
	APPEND BLANK
	REPLACE CodPln WITH XsCodPln
	REPLACE NroPer WITH XsNroPer
	REPLACE CodMov WITH ZsCodMov
	REPLACE CodPer WITH LsCodPer
	REPLACE ValCal WITH LfImpDst
	REPLACE ValREF WITH VAL(CCTE.NroDoc)
	RETURN
ELSE
	REPLACE ValCal WITH LfImpDst
ENDIF

******************
PROCEDURE Grabajud
******************
SELECT DMOV
SEEK XsCodPln+XsNroPer+LsCodPer+ZsCodMov+STR(VAL(JUDI.NroDoc),6,0)
IF ! FOUND()
	IF LfImpDst = 0
		RETURN
	ENDIF
	APPEND BLANK
	REPLACE CodPln WITH XsCodPln
	REPLACE NroPer WITH XsNroPer
	REPLACE CodMov WITH ZsCodMov
	REPLACE CodPer WITH LsCodPer
	REPLACE ValCal WITH LfImpDst
	REPLACE ValRef WITH VAL(JUDI.NroDoc)
	RETURN
ELSE
	REPLACE ValCal WITH LfImpDst
ENDIF

*******************************
*!*	@JUDICIAL(Tope,Importe) *!*
*******************************
PROCEDURE JUDICIAL
******************
PARAMETERS WKfTope,WK1
LsCodPer = PERS.CodPer
LsCodMov = 'JA01'
SELECT JUDI
SEEK LsCodPer+LsCodMov
WKfVale = 0
DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. ! EOF()
	*!*	Anulamos su pagos anteriores *!*
	SELECT DMOV
	*!*	JUDICIAL *!*
	ZsCodMov = 'JA01'
	xLlave =  XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. ! EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	*!*	Devengados *!*
	ZsCodMov = 'JA02'
	xLlave =  XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. ! EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	SELECT JUDI
	DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. ! EOF()
		ZsCodMov = 'JA01'
		*!* JUDICIAL *!*
		IF PorJud = 0
			LfImpDst = ImpJud
		ELSE
			LfImpDst = WK1*PorJud/100
		ENDIF
		IF ! WKfTope >= (WKfVale +LfImpDst)
			LfImpDst = WkfTope - WkfVale
		ENDIF
		IF ! FlgEst $ 'SR'
			WKfVale = WKfVale + LfImpDst
			IF PorJud # 0
				REPLACE ImpJud WITH LfImpDst
			ENDIF
			*!*	Graba datos de cuenta corriente *!*
			DO GrabaJud
		ELSE
			IF PorJud # 0
				REPLACE ImpJud WITH 0
			ENDIF
		ENDIF
		SELECT JUDI
		ZsCodMov = 'JA02'
		*!*	DEVENGADO *!*
		LfImpDst = MIN(SdoAnt,ImpDct)
		IF ! WKfTope >= (WKfVale + LfImpDst)
			LfImpDst = WkfTope - WkfVale
		ENDIF
		IF !FlgEst $ 'SR'
			WKfVale = WKfVale + LfImpDst
			REPLACE SdoDOC WITH SdoAnt - LfImpDst
			*!*	Graba datos de cuenta corriente *!*
			DO GrabaJud
		ELSE
			REPLACE SdoDoc WITH SdoAnt
		ENDIF
		SELECT JUDI
		SKIP
	ENDDO
ENDDO
RETURN WKfVale

*****************************************************************
*!*	@DSTO(Tope,CONCEPTO1,CONCEPTO2,CONCEPTO3,CONCEPTO4,.....) *!*
*****************************************************************
PROCEDURE DSTO
**************
PARAMETERS WKfTope,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
LsCodPer = PERS.CodPer
WKl2do   = TYPE('WKfTope') = 'N'
LsCodMov = ''
XiMPORT = 0
IF PARAMETERS() > 1
	FOR i = 2 to PARAMETERS()
		VAR = 'WK' + LTRIM(STR(i-1,2,0))
		IF TYPE(VAR) = 'C'
			LsCodMov = &Var
			XIMPORT = XCTCTE()
		ENDIF
	ENDFOR
ELSE
	XIMPORT = XCTCTE()
ENDIF
RETURN XIMPORT

****************
PROCEDURE XCTCTE
****************
SELECT CCTE
SEEK LsCodPer+LsCodMov
WKfVale = 0
DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. !EOF()
	ZsCodMov = CodMov
	IF CodMov = 'J'
		SKIP
		LOOP
	ENDIF
	*!*	Anulamos su pagos anteriores *!*
	SELECT DMOV
	xLlave = XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. !EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	SELECT CCTE
	DO WHILE CodPer+CodMov = LsCodPer+ZsCodMov .AND. !EOF()
		LfImpDst = MIN(SdoAnt,ImpDct)
		IF WKl2do
			IF WKfTope >= (WKfVale +LfImpDst)
				IF ! FlgEst $ 'SR'
					WKfVale = WKfVale + LfImpDst
					REPLACE SdoDoc WITH SdoAnt - LfImpDst
					*!*	Graba datos de cuenta corriente
					DO GrabaVal
				ELSE
					REPLACE SdoDoc WITH SdoAnt
				ENDIF
			ELSE
				LfImpDst = WKfTope - WkfVale
				IF ! FlgEst $ 'SR'
					WKfVale = WKfVale + LfImpDst
					REPLACE SdoDoc WITH SdoAnt - LfImpDst
					DO GrabaVal
				ELSE
					REPLACE SdoDoc WITH SdoAnt
				ENDIF
			ENDIF
		ELSE
			IF ! FlgEst $ 'SR'
				WKfVale = WKfVale + LfImpDst
				REPLACE SdoDoc WITH SdoAnt - LfImpDst
				DO GrabaVal
			ELSE
				REPLACE SdoAct WITH SdoAnt
			ENDIF
		ENDIF
		SELECT CCTE
		SKIP
	ENDDO
ENDDO
RETURN WKfVale

*******************************
*!*	Envia mensajes de error *!*
*******************************
PROCEDURE ERROR
***************
PARAMETERS ErrNum,Mensaje,CurrPrg,CurrErr
TitError = Mensaje                         && Titulo del Error
TitSoluc1= ''
TitSoluc2= ''
*!*	TitProgr = NomVar + ' ' +CurrPrg      && Programa que Origino Error
TitProgr = "Variable : "+NomVar        && Programa que Origino Error
TitComent= " [Enter]-Reintentar    [Esc]-Cancelar "
FINALLY = CHR(End)+CHR(Enter)+CHR(Escape)+CHR(Del)+CHR(Home)
DO CASE
	CASE ErrNum = 4
		TitError = "Posición del Registro en Fin de Archivo"
		TitSoluc1 = "Ejecute la Opción de Mantenimiento "
		TitSoluc2 = "de Archivos"
	CASE ErrNum = 5
		TitError = "Registro esta fuera de Rango"
		TitSoluc1 = "Ejecute la Opci¢n de Mantenimiento "
		TitSoluc2 = "de Archivos"
	CASE ErrNum = 22
		TitError = "Muchas Variables de Memoria"
		TitSoluc1 = "Incremente el MVCOUNT en el"
		TitSoluc2 = "Archivo Config.fp"
	CASE ErrNum = 39
		TitError = "Valor Númerico en Overflow"
	CASE ErrNum = 43
		TitError = "Insuficiente memoria"
		TitSoluc1 = "Redusca las Tareas del Computador"
		TitSoluc2 = "o incremente al Memoria a su Máquina"
	CASE ErrNum = 56
		TitError = "No hay espacio suficiente en el Disco"
	CASE ErrNum = 114
		TitError = "Indice dañado"
		TitSoluc1 = "Probable Daño en Archivo"
		TitSoluc2 = "Ejecute la Opción de Mantenimiento"
	CASE ErrNum = 1105
		TitError = "Archivo con error en Grabación"
		TitSoluc1 = "Probable Daño en Archivo"
		TitSoluc2 = "Ejecute la Opción de Mantenimiento"
	CASE ErrNum = 1149
		TitError = "Insuficiente memoria para buffer"
		TitSoluc1 = "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2 = "Archivo Config.fp"
	CASE ErrNum = 1150
		TitError = "Insuficiente memoria para Archivo map."
		TitSoluc1 = "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2 = "Archivo Config.fp"
	CASE ErrNum = 1151
		TitError = "Insuficiente memoria para Nombre de Archivo"
		TitSoluc1 = "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2 = "Archivo Config.fp"
	CASE ErrNum = 1307
		TitError = "División entre cero"
	CASE ErrNum = 1405
		TitError = "Error de Ejecución de Programa Externo"
		TitSoluc1 = "Redusca las Tareas del Computador"
		TitSoluc2 = "o incremente al Memoria a su Máquina"
	CASE ErrNum = 1503
		TitError = "Archivo no puede ser Asegurado"
ENDCASE
SAVE SCREEN TO dbError         && Guardar Pantalla
LenMax = 0
LenMax = IIF(LEN(TitError ) > LenMax ,LEN(TitError ) , LenMax)
LenMax = IIF(LEN(TitSoluc1) > LenMax ,LEN(TitSoluc1) , LenMax)
LenMax = IIF(LEN(TitSoluc2) > LenMax ,LEN(TitSoluc2) , LenMax)
LenMax = IIF(LEN(TitProgr ) > LenMax ,LEN(TitProgr ) , LenMax)
LenMax = IIF(LEN(TitComent) > LenMax ,LEN(TitComent) , LenMax)
LenMax = LenMax+2
TitError = SUBSTR(SPACE(INT((LenMax-LEN(TitError ))/2))+TitError +SPACE(LenMax),1,LenMax)
TitSoluc1= SUBSTR(SPACE(INT((LenMax-LEN(TitSoluc1))/2))+TitSoluc1+SPACE(LenMax),1,LenMax)
TitSoluc2= SUBSTR(SPACE(INT((LenMax-LEN(TitSoluc2))/2))+TitSoluc2+SPACE(LenMax),1,LenMax)
TitProgr = SUBSTR(SPACE(INT((LenMax-LEN(TitProgr ))/2))+TitProgr +SPACE(LenMax),1,LenMax)
TitComent= SUBSTR(SPACE(INT((LenMax-LEN(TitComent))/2))+TitComent+SPACE(LenMax),1,LenMax)
Yo = 9
Xo = INT( (80 - LenMax)/2 )
*!*	Mensaje de Error en la Pantalla *!*
@ Yo,Xo CLEAR TO Yo+7,Xo+LenMax+2
@ Yo,Xo TO Yo+6,Xo+LenMax+1 COLOR SCHEME 7
@ Yo+1,Xo+1 SAY TitProgr COLOR SCHEME 7
@ Yo+2,Xo+1 SAY TitError COLOR SCHEME 7
@ Yo+3,Xo+1 SAY TitSoluc1 COLOR SCHEME 7
@ Yo+4,Xo+1 SAY TitSoluc2 COLOR SCHEME 7
@ Yo+5,Xo+1 SAY TitComent COLOR SCHEME 7
Tecla=0
DO WHILE .NOT. ( CHR(Tecla)$Final )
	Tecla = INKEY(0)
	Tecla = IIF(Tecla<0 .OR. Tecla>255,0,Tecla)
ENDDO
DO CASE
	CASE Tecla = Escape     && Cancelar
		CLEAR GETS
		CLEAR PROMPT
		RETURN TO MASTER
	CASE Tecla = End        && Finalizar
		QUIT
	CASE Tecla = Home       && Suspender
		@ 22,0  CLEAR
		? "=>"+CurrErr
		? "Digite Resume para retornar"
		@ ROW(),7 SAY "RESUME" color -
		SUSPEND
ENDCASE
RESTORE SCREEN FROM dBError
IF Tecla = Del             && Ignorar
	RETURN
ELSE
	Error = 0
	RETRY                   && Reintentar
ENDIF

************************************************************************
*!* Calcula el Promedio de los ultimos 6 meses de cualquier variable *!*
************************************************************************
PROCEDURE PRMVAR
****************
PARAMETER Var
PRIVATE WKnVal,NroProm,wRecord,SaveComp,mCurrArea
IF TYPE("Var") <> 'C'
	RETURN 0
ENDIF
IF SET('COMPATIBLE') = 'ON'
	SET COMPATIBLE OFF
	SaveComp = 'ON'
ELSE
	SaveComp = 'OFF'
ENDIF
SET COMPATIBLE OFF
mCurrArea = SELECT()
STORE 0 TO WKnVal,NroProm,I
xNroPer = VAL(XsNroPer)-6
IF xNroPer <=0
	xNroPer=12-ABS(xNroPer)
	LsCodCia = 'cia'+GsCodCia
	LsMovtCia  =PathDef+"\"+LsCodCia+"\C"+LTRIM(STR(PlnNroAno-1))+"\PLNDMOVT.DBF"
	IF FILE(LsMovtCia)
		SELECT 0
		USE &LsMovtCia ORDER DMOV01 ALIAS TMPDMOV
		SELECT TMPDMOV
		FOR I=XNroPer TO 12
			XlPeri=TRANSFORM(I,"@L ##")
			xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
			SEEK xLlave
			IF FOUND()
				WKnVal=WKnVal+ValCal
				NroProm=NroProm+IIF(VALCAL>0,1,0)
			ENDIF
		ENDFOR
		USE
		IF XNroPer>7
			SELECT DMOV
			FOR I=1 TO XNroPer-7
				XlPeri=TRANSFORM(I,"@L ##")
				xLlave = XsCodPln+XlPeri+PERS.CodPer+Var
				SEEK xLlave
				IF FOUND()
					WKnVal=WKnVal+ValCal
					NroProm=NroProm+IIF(VALCAL>0,1,0)
				ENDIF
			ENDFOR
		ENDIF
		WKnVal = IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
	ENDIF
ELSE
	SELECT DMOV
	wRecord = RECNO()
	FOR I=XNroPer TO XNroPer+5
		XlPeri=TRANSF(IIF(I>12,I-12,I),"@L ##")
		xLlave = XsCodPln+XlPeri+PERS.CodPer+Var
		SEEK xLlave
		IF FOUND()
			WKnVal=WKnVal+ValCal
			NroProm=NroProm+IIF(VALCAL>0,1,0)
		ENDIF
	ENDFOR
	WKnVal = IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
	IF BETW(wRecord,1,RECC())
		GO wRecord
	ENDI
ENDIF
SELECT (mCurrArea)
SET COMPATIBLE &SaveComp
RETURN WKnVal

***************************************************************
*!* Suma de periodos anteriores de una determinada variable *!*
***************************************************************
PROCEDURE SUMANT
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE('Var') <> 'C'
	RETURN 0
ENDIF
WKnVal = 0
FOR I = 1 TO VAL(XsNroPer) - 1
	LsNroPer = TRANSFORM(I,'@L ##')
	=SEEK(XsCodPln+LsNroPer+PERS.CodPer+Var,'DMOV')
	WKnVaL = WKnVaL + DMOV.ValCal
ENDFOR
RETURN WKnVal