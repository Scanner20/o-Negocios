**************************************************************************
*  Nombre    : PlngCalc.PRG                                              *
*  Objeto    : C lculo de Planilla.                                      *
*  Par metros:    TipCal                                                 *
*  Creaci¢n     : 18/12/90                                               *
*  Actualizaci¢n: 13/10/98                                               *
**************************************************************************
PARAMETER cTipMov,cNomMov

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO Gcalc
loContab.oDatadm.CloseTable('EMOV')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('JUDI')
loContab.oDatadm.CloseTable('CCTE')
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('SEMA')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

***************
PROCEDURE gcalc
***************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNEMOVT','EMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','PLNDJUDI','JUDI','DJUD01','')
LoDatAdm.abrirtabla('ABRIR','PLNDCCTE','CCTE','CCTE01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		NomArch  = SYS(2023)+"\"+"PLNVAR1"+CTipMov+".cal"
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		NomArch  = SYS(2023)+"\"+"PLNVAR2"+CTipMov+".cal"
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		NomArch  = SYS(2023)+"\"+"PLNVAR3"+CTipMov+".cal"
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','SEMA','SEMA01','')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')

DIMENSION AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroMes),1)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = cNomMov
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

NomVar = ""
XXXVar = ""
SET FILTER TO CodPln = XsCodPln
GO TOP
SELECT SEMA
GO TOP
PRIV XSINIGRA,XSFINGRA  && SEMANA INICIAL Y FINAL PARA GRATIFICACION
STOR 0 TO XSINIGRA,XSFINGRA
IF MONTH(DATE()) = 7
	XSINIGRA = 1
	GO TOP
	LOCATE FOR VAL(MES) > 6
	SKIP -1
	XSFINGRA = VAL(SEMA)
ENDI
IF MONTH(DATE()) = 12
	GO TOP
	LOCATE FOR VAL(MES) > 6
	XSINIGRA = VAL(SEMA)
	GO BOTT
	XSFINGRA = VAL(SEMA)
ENDI
USE

SELECT PERS
XiNroPla = VAL(XsNroPer)
@ 9,10 CLEAR TO 18,67
DO CASE
	CASE XsCodPln = "2"
		@ 7,10 SAY "Semana Nro. : "+XsNroPer
	CASE XsCodPln = "1"
		@ 7,12 SAY "Mes Proceso : "+STR(XiNroPla,2,0)
ENDCASE


@  7,09 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,09 SAY '³                    I M P O R T A N T E                    ³'
@  9,09 SAY '³                                                           ³'
@ 10,09 SAY '³   Este proceso tiene por finalidad de realizar los c l -  ³'
@ 11,09 SAY '³  culos de Planillas.                                      ³'
@ 12,09 SAY '³                                                           ³'
@ 13,09 SAY '³  SOLO deber  efectuarse despues de haber ingresado todos  ³'
@ 14,09 SAY '³  los datos que son requeridos.                            ³'
@ 15,09 SAY '³                                                           ³'
@ 16,09 SAY '³          Presione <<Enter>> para Continuar                ³'
@ 17,09 SAY '³                                                           ³'
@ 18,09 SAY '³            Presione <<Esc>> para Cancelar                 ³'
@ 19,09 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
*!*	Pide respuesta
UltTecla = 0
DO WHILE ! (UltTecla=Enter .OR. UltTecla=Escape)
	UltTecla=INKEY(0)
ENDDO
IF UltTecla = Escape
	RETURN
ENDIF
@ 9,10 CLEAR TO 18,67
ActBol     = "S"
GiMaxEle   = 0
Bloque     = 1
UltTecla   = 0
SelCia     = 1
SelSec     = 1
SelPer     = 1
xSitPer    = 0
xSitVac    = 0
XfTpoCmb   = 1
TnNumLin   = 50
XcFlgEst   = " "
STORE SPACE(LEN(PERS->CodPer)) TO Desde,Hasta
@ 11,13 SAY "C lculo    : "
DO WHILE .T.
	VecOpc(1) = "Total"
	VecOpc(2) = "Individual"
	SelCia    = Elige(SelCia,11,26,2)
	IF UltTecla = Escape
		RETURN
	ENDIF
	IF SelCia = 2
		DO GENBrows
		IF LASTKEY() = 27
			LOOP
		ENDIF
	ENDIF
	EXIT
ENDDO
@  9,10 CLEAR TO 18,67
@ 12,10  SAY PADC("C A L C U L A N D O",59)
@ 14,10  SAY PADC(cNomMov,59)
TnContador = 0
TnNumLin   = 0
NomVar     = ""
@ 19,23 CLEAR TO 21,57
@ 19,23       TO 21,57 PANEL
nNroBol = VALCAL("AA06")
IF SelCia = 1
	DO WHILE ! EOF()
		SELE DMOV
		IF cTipMov='V'
			Seek XsCodPln+XsNroPer+PERS->CodPer+"@SIT"
			IF VALCAL#6
				SELE PERS
				skip
				Loop
			ENDIF
		ELSE
			Seek XsCodPln+XsNroPer+PERS->CodPer+"@SIT"
			IF VALCAL=6
				SELE PERS
				skip
				Loop
			ENDIF
		ENDIF
		SELE PERS
		DO LinCal
		SELECT PERS
		SKIP
		IF INKEY()=F9
			EXIT
		ENDIF
	ENDDO
	**** ACTUALIZANDO NRO BOLETA ACTUAL *****
	SELECT DMOV
	ZsCodMov = "AA05"
	xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))+ZsCodMov
	SEEK xLLave
	IF ! FOUND()
		APPEND BLANK
	ENDIF
	REPLACE CodMov WITH  ZsCodMov
	REPLACE ValRef WITH  0
	REPLACE ValCal WITH  nNroBol
ELSE
	FOR NumEle = 1 to GiMaxEle
		SELECT PERS
		SEEK AsCodigo(NumEle)
		IF ! Found()   && para ver si lo encuentra
			suspend
		ENDIF
		DO LinCal
	ENDFOR
ENDIF
RETURN

************************************************************************
* Linea de C lculo
************************************************************************
PROCEDURE LinCal
TsCodPer = CodPer
TsGrpPer = GrpPer
xSitPer = VALCAL("@SIT")
*xSitVac = VALCAL("@VAC")
***** VERIFICAMOS SI LE TOCA VACACIONES ******
SELECT DMOV
ZsCodMov = "@VAC"
xLlave = XsCodPln+XsNroPer+PERS->CodPer+ZsCodMov
SEEK xLLave
IF ! FOUND()
	APPEND BLANK
ENDIF
REPLACE CodPln WITH  XsCodPln
REPLACE NroPER WITH  XsNroPer
REPLACE CodPER WITH  PERS->CodPer
REPLACE CodMov WITH  ZsCodMov
REPLACE ValRef WITH  0
SELECT PERS
TopeMax  = 0
WKfSaldo = 0
LiNumLin = 1
TnContador = TnContador + 1
TsCuenta = LTRIM(STR(TnContador))+"/"+LTRIM(STR(RECCOUNT()))
@ 20,25 SAY "Procesando : "+TsCodPer+" "+TsCuenta
IF xSitPer = 5
	SELECT DMOV
	zLlave = XsCodPln+XsNroPer+TsCodPer+cTipMov
	SEEK zLLave
	DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
	zLlave = XsCodPln+XsNroPer+TsCodPer+"M"
	SEEK zLLave
	DELETE REST WHILE CodPln+NroPer+CodPer+CodMov = zLLave
ELSE
	DO (NomArch)
	IF SelCia = 1 .AND. ActBol     = "S"
		*** actualizamos su correlativo ***
		ZsCodMov = "CZ01"
		xLlave = XsCodPln+XsNroPer+PERS->CodPer+ZsCodMov
		SEEK xLLave
		IF ! FOUND()
			APPEND BLANK
		ENDIF
		REPLACE CodPln WITH  XsCodPln
		REPLACE NroPER WITH  XsNroPer
		REPLACE CodPER WITH  PERS->CodPer
		REPLACE CodMov WITH  ZsCodMov
		REPLACE ValRef WITH  0
		REPLACE ValCal WITH  nNroBol
		nNroBol = nNroBol + 1
	ENDIF
ENDIF
RETURN
************************************************************************
* Toma los valores de los conceptos del personal
************************************************************************
PROCEDURE GetVar
PARAMETER WKsVar
IF "."$WKsVar
	RETURN SUMA(WKsVar)
ENDIF
PRIVATE WKnVal, TlTitle
WKnVal = 0
TlTitle  = RIGHT(WKsVar,LEN(WKsVar)-2)=REPLICATE('0',LEN(WKsVar)-2)
IF WKsVar = "A"
	SELECT TMOV
	IF TlTitle
		SEEK SUBSTR(WKsVar,1,2)
		DO WHILE CodMov=SUBSTR(WKsVar,1,2)  .AND. ! EOF()
			SELECT DMOV
			xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
			SEEK xLLave+TMOV->CodMov
			WKnVaL = WKnVaL + ValCal
			SELECT TMOV
			SKIP
		ENDDO
	ELSE
		SELECT DMOV
		xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
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
			SELECT DMov
			XCLAVE = XsCodPln+XsNroPer+PERS->CodPer+TMov->CodMov
			SEEK XCLAVE
			DO WHILE CodPln+NroPer+CodPer+CodMov = XCLAVE .AND. ! EOF()
				WKnVaL = WKnVaL + ValCal
				SKIP
			ENDDO
			SELECT TMov
			SKIP
		ENDDO
	ELSE
		SELECT DMOV
		XCLAVE = XsCodPln+XsNroPer+PERS->CodPer+WKsVar
		SEEK XCLAVE
		IF FOUND()
			WKnVaL = ValCal
		ENDIF
	ENDIF
ENDIF
RETURN WKnVal
************************************************************************
* Valor del Redondeo
************************************************************************
PROCEDURE ValRed
PARAMETERS WKnVal,WKnRed
PRIVATE WknVal1
WKnVal1=   WKnRed-MOD(WKnVal,WknRed)
RETURN WKnVal1
************************************************************************
* @HONO()         MES DE HONOMASTICO
************************************************************************
PROCEDURE HONO
XsHono=val(Substr(DTOC(pers->FCHNAC),4,2))
RETURN(XsHono)
************************************************************************
* @PVAC()         MES DE VACACIONES
************************************************************************
PROCEDURE PVAC
XsPvac=val(pers->MESVAC)
RETURN(XsPvac)
************************************************************************
* @DIAS()
************************************************************************
PROCEDURE DIAS
RETURN(dFchFin-dFchIni)
************************************************************************
* @DOM()
************************************************************************
PROCEDURE DOM
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
************************************************************************
* @DIAV()
************************************************************************
PROCEDURE DIAV
RETURN(PERS->FinVac-PERS->IniVac)
************************************************************************
* @DOMV()
************************************************************************
PROCEDURE DOMV
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
	RETURN ( INT(nDia/7) + 1 )
ELSE
	RETURN (0)
ENDIF
************************************************************************
* @SUMA(.,.)
************************************************************************
PROCEDURE SUMA
PARAMETERS VAR
VAR1 = LEFT(VAR,4)
VAR2 = LEFT(VAR,2)+RIGHT(VAR,2)
WKnVal = 0
SELECT TMov
SEEK VAR1
IF ! FOUND() .AND. (RECNO(0)>0 .AND. RECNO(0)<RECCOUNT())
	GOTO RECNO(0)
ENDIF
DO WHILE (CodMov)<=VAR2  .AND. ! EOF()
	SELECT DMOV
	IF Var1 = "A"
		xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
	ELSE
		xLlave = XsCodPln+XsNroPer+PERS->CodPer
	ENDIF
	SEEK xLLave+TMOV->CodMov
	WKnVaL = WKnVaL + ValCal
	SELECT TMov
	SKIP
ENDDO
RETURN WKnVal
************************************************************************
* @NUMPER()
************************************************************************
PROCEDURE NUMPER
RETURN XiNroPla
************************************************************************
* @CASO(..,.......)
************************************************************************
PROCEDURE CASO
PARAMETERS VAR,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
PRIVATE iVar
iVar = INT(Var)
DO CASE
	CASE iVar=1   .AND. Type("WK1") = "N"
		RETURN WK1
	CASE iVar=2   .AND. Type("WK2") = "N"
		RETURN WK2
	CASE iVar=3   .AND. Type("WK3") = "N"
		RETURN WK3
	CASE iVar=4   .AND. Type("WK4") = "N"
		RETURN WK4
	CASE iVar=5   .AND. Type("WK5") = "N"
		RETURN WK5
	CASE iVar=6   .AND. Type("WK6") = "N"
		RETURN WK6
	CASE iVar=7   .AND. Type("WK7") = "N"
		RETURN WK7
	CASE iVar=8   .AND. Type("WK8") = "N"
		RETURN WK8
	CASE iVar=9   .AND. Type("WK9") = "N"
		RETURN WK9
	CASE iVar=10 .AND. Type("WK10") = "N"
		RETURN WK10
	CASE iVar=11 .AND. Type("WK11") = "N"
		RETURN WK11
	CASE iVar=12 .AND. Type("WK12") = "N"
		RETURN WK12
	CASE iVar=13 .AND. Type("WK13") = "N"
		RETURN WK13
	CASE iVar=14 .AND. Type("WK14") = "N"
		RETURN WK14
	CASE iVar=15 .AND. Type("WK15") = "N"
		RETURN WK15
	CASE iVar=16 .AND. Type("WK16") = "N"
		RETURN WK16
	CASE iVar=17 .AND. Type("WK17") = "N"
		RETURN WK17
	CASE iVar=18 .AND. Type("WK18") = "N"
		RETURN WK18
	CASE iVar=19 .AND. Type("WK19") = "N"
		RETURN WK19
	CASE iVar=20 .AND. Type("WK20") = "N"
		RETURN WK20
ENDCASE
RETURN 0
************************************************************************
* @SEL(..,.......)
************************************************************************
PROCEDURE SEL
PARAMETERS VAR,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
IF Type("WK1") = "N" .AND. Var = WK1
	RETURN 1
ENDIF
IF Type("WK2") = "N" .AND. Var = WK2
	RETURN 1
ENDIF
IF Type("WK3") = "N" .AND. Var = WK3
	RETURN 1
ENDIF
IF Type("WK4") = "N" .AND. Var = WK4
	RETURN 1
ENDIF
IF Type("WK5") = "N" .AND. Var = WK5
	RETURN 1
ENDIF
IF Type("WK6") = "N" .AND. Var = WK6
	RETURN 1
ENDIF
IF Type("WK7") = "N" .AND. Var = WK7
	RETURN 1
ENDIF
IF Type("WK8") = "N" .AND. Var = WK8
	RETURN 1
ENDIF
IF Type("WK9") = "N" .AND. Var = WK9
	RETURN 1
ENDIF
IF Type("WK10") = "N" .AND. Var = WK10
	RETURN 1
ENDIF
IF Type("WK11") = "N" .AND. Var = WK11
	RETURN 1
ENDIF
IF Type("WK12") = "N" .AND. Var = WK12
	RETURN 1
ENDIF
IF Type("WK13") = "N" .AND. Var = WK13
	RETURN 1
ENDIF
IF Type("WK14") = "N" .AND. Var = WK14
	RETURN 1
ENDIF
IF Type("WK15") = "N" .AND. Var = WK15
	RETURN 1
ENDIF
IF Type("WK16") = "N" .AND. Var = WK16
	RETURN 1
ENDIF
IF Type("WK17") = "N" .AND. Var = WK17
	RETURN 1
ENDIF
IF Type("WK18") = "N" .AND. Var = WK18
	RETURN 1
ENDIF
IF Type("WK19") = "N" .AND. Var = WK19
	RETURN 1
ENDIF
IF Type("WK20") = "N" .AND. Var = WK20
	RETURN 1
ENDIF
RETURN 0
************************************************************************
* *** Quinta Categoria ****  Escala de Topes
************************************************************************
PROCEDURE QESCALA
PARAMETERS WKnVal
PRIVATE IMPUESTO
******
Tope1 = VALCAL("AD01")   && 6%
Tope2 = VALCAL("AD02")   && 10%
Tope3 = VALCAL("AD03")   && 20%
Tope4 = VALCAL("AD04")   && 30%
Tope5 = VALCAL("AD05")   && 37%
******
Porc1 = VALCAL("AD11")/100   && 6%
Porc2 = VALCAL("AD12")/100   && 10%
Porc3 = VALCAL("AD13")/100   && 20%
Porc4 = VALCAL("AD14")/100   && 30%
Porc5 = VALCAL("AD15")/100   && 37%
******
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
************************************************************************
**** Quinta Categoria ****  PROYECCION LO QUE FALTA PAGAR DEL A¥O
************************************************************************
PROCEDURE QPROYEC
PARAMETERS presente
***** PARA INSTITUCIONES PRIVADAS *******
IF xSitVac = 1
	DO CASE
		CASE XiNroPLA < 7
			RETURN PRESENTE*(14-XiNroPLA)
		CASE XiNroPLA < 12
			RETURN PRESENTE*(13-XiNroPLA)
		CASE XiNroPLA = 12
			RETURN 0
	ENDCASE
ELSE
	DO CASE
		CASE XiNroPLA < 6
			RETURN PRESENTE*(13-XiNroPLA)
		CASE XiNroPLA < 12
			RETURN PRESENTE*(12-XiNroPLA)
		CASE XiNroPLA = 12
			RETURN 0
	ENDCASE
ENDIF
RETURN 0
************************************************************************
**** Quinta Categoria ****  PROYECCION A FIN DE A¥O
************************************************************************
PROCEDURE QUINTA
PARAMETERS WKnVal
***** PARA INSTITUCIONES PRIVADAS *******
IF xSitVac <> 1
	DO CASE
		CASE XiNroPLA < 12
			RETURN WKnVal/(13-XiNroPLA)
		CASE XiNroPLA = 12
			RETURN WKnVal
	ENDCASE
ELSE
	*** Si esta de vacaciones ***
	*** esta pagando un mes mas **
	DO CASE
		CASE XiNroPLA < 11
			RETURN WKnVal*2/(13-XiNroPLA)
		CASE XiNroPLA > 10
			RETURN WKnVal
	ENDCASE
ENDIF
RETURN 0
************************************************************************
**** SITUACION DEL PERSONAL
************************************************************************
PROCEDURE SPER
RETURN VALCAL("@SIT")
************************************************************************
**** VERIFICA SI SE PAGA VACACIONES *******
************************************************************************
PROCEDURE VAC
RETURN IIF(xSitVac=1,2,1)
************************************************************************
**** NUMERO DE CODIGO DE PALNILLA   *******
************************************************************************
PROCEDURE SEXO
RETURN(PERS->SEXPER)
************************************************************************
PROCEDURE CODPLN
RETURN VAL(PERS->CODPLN)
************************************************************************
**** TIEMPO DE SERVICIONES EN MESES *******
************************************************************************
PROCEDURE TSERV
XTMPSRV = VAL(SUBSTR(STR(PERS->TMPSRV,6,0),1,2))*12 + VAL(SUBSTR(STR(PERS->TMPSRV,6,0),3,2))
XTMPSRV = XTMPSRV / IIF(PERS->SexPer="1",360,300)
IF XTMPSRV > 1
	XTMPSRV = 1
ENDIF
IF PERS->CODCAT <> "NONI"
	XTMPSRV = 1
ENDIF
RETURN XTMPSRV
************************************************************************
**** NUMERO DE CODIGO DE SECCION    *******
************************************************************************
PROCEDURE CODSEC
PARAMETER VAR1,VAR2
RETURN VAL(SUBSTR(PERS->CODSEC,VAR1,VAR2))
************************************************************************
* Graba Datos
************************************************************************
PROCEDURE Graba
PARAMETERS TsCodMov, cAGrpSi, cAGrpNo, cSitMov, cSitVar, nDecMov
LiNumLin = LiNumLin + 1
DO CASE
	CASE TnNumLin < 1
		@ 20,55 SAY " "
	CASE LiNumLin/TnNumLin < .01
		@ 20,55 SAY " "
	CASE LiNumLin/TnNumLin < .35
		@ 20,55 SAY "|"
	CASE LiNumLin/TnNumLin < .69
		@ 20,55 SAY "/"
	CASE LiNumLin/TnNumLin < .85
		@ 20,55 SAY "-"
	OTHER
		@ 20,55 SAY "\"
ENDCASE
Cond1 =   (cAGrpSi$PERS->GrpPer .OR. cAGrpSi=' ')
Cond2 = ! (cAGrpNo$PERS->GrpPer .AND. cAGrpNo<>' ')
TnNroDec = IIF(nDecMov>=0 .AND. nDecMov<=4,nDecMov,4)
TnValCal = ROUND(TnValCal,TnNroDec)
IF ! (Cond1 .AND. Cond2)
	TnValCal = 0.00
ENDIF

**** VERIFICAMOS SU FLGEST ********
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
		XfSobreg  = TnValCal - TopeMax
		TnValCal  = TopeMax
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
			REPLACE CodPln WITH  XsCodPln
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
SEEK XsCodPln+XsNroPer+LsCodPer+ZsCodMov+STR(VAL(CCTE->NRODOC),6,0)
IF ! FOUND()
	IF LfImpDst = 0
		RETURN
	ENDIF
	APPEND BLANK
	REPLACE CodPln WITH  XsCodPln
	REPLACE NroPer WITH XsNroPer
	REPLACE CodMov WITH ZsCodMov
	REPLACE CodPer WITH LsCodPer
	REPLACE ValCal WITH LfImpDst
	REPLACE ValREF WITH VAL(CCTE->NRODOC)
	RETURN
ELSE
	REPLACE ValCal WITH LfImpDst
ENDIF
******************
PROCEDURE Grabajud
******************
SELECT DMOV
SEEK XsCodPln+XsNroPer+LsCodPer+ZsCodMov+STR(VAL(JUDI->NRODOC),6,0)
IF ! FOUND()
	IF LfImpDst = 0
		RETURN
	ENDIF
	APPEND BLANK
	REPLACE CodPln WITH  XsCodPln
	REPLACE NroPer WITH XsNroPer
	REPLACE CodMov WITH ZsCodMov
	REPLACE CodPer WITH LsCodPer
	REPLACE ValCal WITH LfImpDst
	REPLACE ValREF WITH VAL(JUDI->NRODOC)
	RETURN
ELSE
	REPLACE ValCal WITH LfImpDst
ENDIF
************************************************************************
* @JUDICIAL(Tope,Importe)
************************************************************************
PROCEDURE JUDICIAL
PARAMETERS WKfTope,WK1
LsCodPer = PERS->CodPer
LsCodMov = "JA01"
SELECT JUDI
SEEK LsCodPer+LsCodMov
WKfVale = 0
DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. ! EOF()
	**** Anulamos su pagos anteriores ****
	SELECT DMOV
	**** JUDICIAL ****
	ZsCodMov = "JA01"
	xLlave =  XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. ! EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	**** DEVENGADOS ***
	ZsCodMov = "JA02"
	xLlave =  XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. ! EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	SELECT JUDI
	DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. ! EOF()
		ZsCodMov = "JA01"
		*** JUDICIAL ****
		IF PorJud = 0
			LfImpDst = ImpJud
		ELSE
			LfImpDst = WK1*PorJud/100
		ENDIF
		IF ! WKfTope >= (WKfVale +LfImpDst)
			LfImpDst = WkfTope - WkfVale
		ENDIF
		IF ! FlgEst $ "SR"
			WKfVale = WKfVale + LfImpDst
			IF PorJud # 0
				REPLACE ImpJud WITH LfImpDst
			ENDIF
			*** Graba datos de cuenta corriente **
			DO GRABAJUD
		ELSE
			IF PorJud # 0
				REPLACE ImpJud WITH 0
			ENDIF
		ENDIF
		SELECT JUDI
		ZsCodMov = "JA02"
		*** DEVENGADO ****
		LfImpDst = MIN(SdoAnt,ImpDct)
		IF ! WKfTope >= (WKfVale +LfImpDst)
			LfImpDst = WkfTope - WkfVale
		ENDIF
		IF ! FlgEst $ "SR"
			WKfVale = WKfVale + LfImpDst
			REPLACE SdoDOC WITH SdoAnt - LfImpDst
			*** Graba datos de cuenta corriente **
			DO GRABAJUD
		ELSE
			REPLACE SdoDoc WITH SdoAnt
		ENDIF
		SELECT JUDI
		SKIP
	ENDDO
ENDDO
RETURN WKfVale
************************************************************************
* @DSTO(Tope,CONCEPTO1,CONCEPTO2,CONCEPTO3,CONCEPTO4,.....)
************************************************************************
PROCEDURE DSTO
PARAMETERS WKfTope,WK1,WK2,WK3,WK4,WK5,WK6,WK7,WK8,WK9,WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,WK20
LsCodPer = PERS->CodPer
WKl2do   = TYPE("WKfTope")="N"
LsCodMov = ""
XiMPORT = 0
IF Parameter() > 1
	FOR i = 2 to Parameter()
		VAR = "WK"+LTRIM(STR(i-1,2,0))
		IF TYPE(VAR)="C"
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
DO WHILE CodPer+CodMov = LsCodPer+LsCodMov .AND. ! EOF()
	ZsCodMov = CodMov
	IF CodMov = "J"
		SKIP
		LOOP
	ENDIF
	**** Anulamos su pagos anteriores ****
	SELECT DMOV
	xLlave =  XsCodPln+XsNroPer+LsCodPer+ZsCodMov
	SEEK xLlave
	DO WHILE CodPln+NroPer+CodPer+CodMov = xLLave .AND. ! EOF()
		REPLACE VALCAL WITH 0
		SKIP
	ENDDO
	SELECT CCTE
	DO WHILE CodPer+CodMov = LsCodPer+ZsCodMov .AND. ! EOF()
		LfImpDst = MIN(SdoAnt,ImpDct)
		IF WKl2do
			IF WKfTope >= (WKfVale +LfImpDst)
				IF ! FlgEst $ "SR"
					WKfVale = WKfVale + LfImpDst
					REPLACE SdoDOC WITH SdoAnt - LfImpDst
					*** Graba datos de cuenta corriente **
					DO GRABAVAL
				ELSE
					REPLACE SdoDoc WITH SdoAnt
				ENDIF
			ELSE
				LfImpDst = WKfTope - WkfVale
				IF ! FlgEst $ "SR"
					WKfVale = WKfVale + LfImpDst
					REPLACE SdoDoc WITH SdoAnt - LfImpDst
					DO GRABAVAL
				ELSE
					REPLACE SdoDoc WITH SdoAnt
				ENDIF
			ENDIF
		ELSE
			IF ! FlgEst $ "SR"
				WKfVale = WKfVale + LfImpDst
				REPLACE SdoDoc WITH SdoAnt - LfImpDst
				DO GRABAVAL
			ELSE
				REPLACE SdoAct WITH SdoAnt
			ENDIF
		ENDIF
		SELECT CCTE
		SKIP
	ENDDO
ENDDO
RETURN WKfVale

************************************************************************
* Envia mensajes de error
************************************************************************
PROCEDURE ERROR
PARAMETERS ErrNum,Mensaje,CurrPrg,CurrErr
TitError = Mensaje                         && Titulo del Error
TitSoluc1= ""
TitSoluc2= ""
*TitProgr = NomVar + ' ' +CurrPrg      && Programa que Origino Error
TitProgr = "Variable : "+NomVar        && Programa que Origino Error
TitComent= " [Enter]-Reintentar    [Esc]-Cancelar "
*                                          && Mensaje de Teclas a usar
FINAL     = CHR(End)+CHR(Enter)+CHR(Escape)+CHR(Del)+CHR(Home)
DO CASE
	CASE ErrNum=4
		TitError = "Posici¢n del Registro en Fin de Archivo"
		TitSoluc1= "Ejecute la Opci¢n de Mantenimiento "
		TitSoluc2= "de Archivos"
	CASE ErrNum=5
		TitError = "Registro esta fuera de Rango"
		TitSoluc1= "Ejecute la Opci¢n de Mantenimiento "
		TitSoluc2= "de Archivos"
	CASE ErrNum=22
		TitError = "Muchas Variables de Memoria"
		TitSoluc1= "Incremente el MVCOUNT en el"
		TitSoluc2= "Archivo Config.fp"
	CASE ErrNum=39
		TitError = "Valor N£merico en Overflow"
	CASE ErrNum=43
		TitError = "Insuficiente memoria"
		TitSoluc1= "Redusca las Tareas del Computador"
		TitSoluc2= "o incremente al Memoria a su M quina"
	CASE ErrNum=56
		TitError = "No hay espacio suficiente en el Disco"
	CASE ErrNum=114
		TitError = "Indice da¤ado"
		TitSoluc1= "Probable Da¤o en Archivo"
		TitSoluc2= "Ejecute la Opci¢n de Mantenimiento"
	CASE ErrNum=1105
		TitError = "Archivo con error en Grabaci¢n"
		TitSoluc1= "Probable Da¤o en Archivo"
		TitSoluc2= "Ejecute la Opci¢n de Mantenimiento"
	CASE ErrNum=1149
		TitError = "Insuficiente memoria para buffer"
		TitSoluc1= "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2= "Archivo Config.fp"
	CASE ErrNum=1150
		TitError = "Insuficiente memoria para Archivo map."
		TitSoluc1= "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2= "Archivo Config.fp"
	CASE ErrNum=1151
		TitError = "Insuficiente memoria para Nombre de Archivo"
		TitSoluc1= "Incremente el BUCKET/MAXMEM en el"
		TitSoluc2= "Archivo Config.fp"
	CASE ErrNum=1307
		TitError = "Divisi¢n entre cero"
	CASE ErrNum=1405
		TitError = "Error de Ejecuci¢n de Programa Externo"
		TitSoluc1= "Redusca las Tareas del Computador"
		TitSoluc2= "o incremente al Memoria a su M quina"
	CASE ErrNum=1503
		TitError = "Archivo no puede ser Asegurado"
ENDCASE

SAVE SCREEN TO dbError         && Guardar Pantalla

LenMax   = 0
LenMax   = IIF(LEN(TitError ) > LenMax ,LEN(TitError ) , LenMax)
LenMax   = IIF(LEN(TitSoluc1) > LenMax ,LEN(TitSoluc1) , LenMax)
LenMax   = IIF(LEN(TitSoluc2) > LenMax ,LEN(TitSoluc2) , LenMax)
LenMax   = IIF(LEN(TitProgr ) > LenMax ,LEN(TitProgr ) , LenMax)
LenMax   = IIF(LEN(TitComent) > LenMax ,LEN(TitComent) , LenMax)
LenMax   = LenMax+2
TitError = SUBSTR(SPACE(INT((LenMax-LEN(TitError ))/2))+TitError +SPACE(LenMax),1,LenMax)
TitSoluc1= SUBSTR(SPACE(INT((LenMax-LEN(TitSoluc1))/2))+TitSoluc1+SPACE(LenMax),1,LenMax)
TitSoluc2= SUBSTR(SPACE(INT((LenMax-LEN(TitSoluc2))/2))+TitSoluc2+SPACE(LenMax),1,LenMax)
TitProgr = SUBSTR(SPACE(INT((LenMax-LEN(TitProgr ))/2))+TitProgr +SPACE(LenMax),1,LenMax)
TitComent= SUBSTR(SPACE(INT((LenMax-LEN(TitComent))/2))+TitComent+SPACE(LenMax),1,LenMax)
Yo       = 9
Xo       = INT( (80 - LenMax)/2 )
* ------------------------------------------------------------------------
* Mensaje de Error en la Pantalla ----------------------------------------
*
@ Yo,Xo CLEAR TO Yo+7,Xo+LenMax+2
@ Yo,Xo       TO Yo+6,Xo+LenMax+1 COLOR SCHEME 7
@ Yo+1,Xo+1 SAY TitProgr    COLOR SCHEME 7
@ Yo+2,Xo+1 SAY TitError    COLOR SCHEME 7
@ Yo+3,Xo+1 SAY TitSoluc1   COLOR SCHEME 7
@ Yo+4,Xo+1 SAY TitSoluc2   COLOR SCHEME 7
@ Yo+5,Xo+1 SAY TitComent   COLOR SCHEME 7

Tecla=0
DO WHILE .NOT. ( CHR(Tecla)$Final )
	Tecla     = INKEY(0)
	Tecla     = IIF(Tecla<0 .OR. Tecla>255,0,Tecla)
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

*******************************************************************
** Calcula el Promedio de los ultimos 6 meses de cualquier variable
****************
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
mCurrArea=Selec()
STORE 0 TO WKnVal,NroProm,I
xNroPer =VAL(XsNroPer)-6
IF xNroPer <=0
	xNroPer=12-ABS(xNroPer)
	LsCodCia = "cia"+GsCodCia
	LsMovtCia  =PathDef+"\"+LsCodCia+"\C"+LTRIM(STR(PlnNroAno-1))+"\PLNDMOVT.DBF"
	IF FILE(LsMovtCia)
		Sele 0
		Use &LsMovtCia order DMOV01 ALIAS TMPDMOV
		SELE TMPDMOV
		FOR I=XNroPer TO 12
			XlPeri=TRANSF(I,"@L ##")
			xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
			SEEK xLlave
			If Found()
				WKnVal=WKnVal+ValCal
				NroProm=NroProm+IIF(VALCAL>0,1,0)
			EndIf
		ENDFOR
		USE
		IF XNroPer>7
			SELE DMOV
			FOR I=1 TO XNroPer-7
				XlPeri=TRANSF(I,"@L ##")
				xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
				SEEK xLlave
				If Found()
					WKnVal=WKnVal+ValCal
					NroProm=NroProm+IIF(VALCAL>0,1,0)
				EndIf
			ENDFOR
		ENDIF
		WKnVal=IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
	ENDIF
ELSE
	SELE DMOV
	wRecord=Recno()
	FOR I=XNroPer TO XNroPer+5
		XlPeri=TRANSF(IIF(I>12,I-12,I),"@L ##")
		xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
		SEEK xLlave
		If Found()
			WKnVal=WKnVal+ValCal
			NroProm=NroProm+IIF(VALCAL>0,1,0)
		EndIf
	ENDFOR
	WKnVal=IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
	IF BETW(wRecord,1,RECC())
		Go wRecord
	ENDI
ENDIF
Sele (mCurrArea)
SET COMPATIBLE &SaveComp
RETURN WKnVal
