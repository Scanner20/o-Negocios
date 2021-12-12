#INCLUDE CONST.H
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','')

** VETT:Captura de observaciones de liquidación de cobranzas, ctacte clientes 2021/11/28 00:48:14 **
Ll_Liqui_C=.F.
IF !USED('L_C_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Cob.dbf')
		SELECT 0
		USE Liq_Cob ORDER LIQ_AST ALIAS L_C_Cobr	&& LIQUI
		Ll_Liqui_C=.T.
	ENDIF	
ENDIF
Ll_Liqui_D=.F.
IF !USED('L_D_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Det.dbf')
		SELECT 0
		USE Liq_Det ORDER CodDoc ALIAS L_D_Cobr	&& LIQUI
		Ll_Liqui_D=.T.
	ENDIF
ENDIF
** VETT: 2021/11/28 00:48:14 **


cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS PENDIENTES"
UltTecla = 0
INC = 0   && SOLES
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
**********************************************************************
** VETT:Guardamos valores iniciales  2021/12/02 23:31:06 ** 
*!*	PRIVATE XsNroMes,GdFecha
GdFechaIni = GdFecha   
** VETT:  2021/12/02 23:31:06 ***

XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
STORE [] TO XsNomClfAux , XsNomAux,LsFchIni,LsFchFin
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XsNomCta = SPACE(LEN(CTAS.CodCta))
UltTecla = 0
i        = 1
** VETT:Divisionarias 2021/11/28 00:50:40 **
XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv
** VETT: 2021/11/28 00:50:40 **


DO FORM cbd_cbdrc002

** VETT: 2021/11/28 00:50:40 **
XsNroMes	= TRANSF(_MES,"@L ##")
GdFechaIni  = GdFecha 
** VETT: 2021/11/28 00:50:40 **

RETURN

********************
PROCEDURE GEN_REPORT
********************
** VETT:Damos de baja a F0PRINT (gracias x 20 años de servicio compañero) 2021/11/26 12:15:18 **
** Usaremos el clagen_spool (Imprimir, pantalla , exportar (CSV,TXT,XLS,XLSX,XML,etc) 
** Tambien quitaremos los @ say para imprimir, todo irá a un cursor temporal

** VETT: 2021/11/26 12:15:18 **
** Filtros para la divisionaria
LsFor1= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodDiv=XsCodDiv')
LsFor2= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodCta_B=XsCodDiv')

XsNroMes = LsMesFin
**

** VETT:Obtenemos un cursor con el rango de cuentas 2021/12/11 18:18:27 ** 
LlaveCta = TRIM(XsCodCta)
LsFor3= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodCta_B=XsCodDiv')+[ AND AftMov='S'] 
gosvrcbd.odatadm.gencursor('c_cTAS_R','CBDMCTAS','','CODCTA',LlaveCta,LsFor3,'CODCTA')

SELECT c_cTAS_R
LOCATE 
IF EOF()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
** VETT: 2021/12/11 18:18:27 ** 

IF VAL(XsNroMes) < 12
    GdFecha=CTOD("01/"+STR(VAL(XsNroMes)+1,2,0)+"/"+STR(_Ano,4,0))-1
ELSE
    GdFecha=CTOD("31/12/"+STR(_Ano,4,0))
ENDIF

*** VETT 2008-05-30 ----- INI
***** Registro de inicio de Impresi¢n ******
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN


IniImp   = _Prn8b+_Prn4
IF XsTipRep = 1
	Ancho    = 153
ELSE
	Ancho    = 107
ENDIF
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "CUENTAS PENDIENTES AL "+DTOC(GdFecha)
SubTitulo= ALLT(XsCodCta)+' - '+ALLT(XsNomCta)
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    =  ALLT(XsCodCta) + "  " + ALLT(XsNomCta)
En4    = IIF(LsMesIni<>LsMesFin,"DESDE: "+MES(VAL(LsMesIni),1)+"        HASTA: "+ MES(VAL(LsMesFin),1),"AL MES DE: "+MES(VAL(LsMesIni),1) )
En5    = IIF(XnCodDiv=0,'',"  DIVISIÓN : "+vDivision(XnCodDiv))
DO case
	CASE XsTipRep = 1
		IF XiCodMon = 1
			En6 = "------------------------------------------------------------------------------------------------------------------------------------------------------------"
			En7 = "                 No.                                FECHA                                                      US$                                   SALDO  "
			En8 = "   FECHA    COMPROBANTE     DOCUMENTO  REFERENCIA  VENCMTO    GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
			En9 = "------------------------------------------------------------------------------------------------------------------------------------------------------------"
		ELSE
			En6 = "------------------------------------------------------------------------------------------------------------------------------------------------------------"
			En7 = "                 No.                                FECHA                                                      S/.                                   SALDO  "
			En8 = "   FECHA    COMPROBANTE     DOCUMENTO  REFERENCIA  VENCMTO    GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
			En9 = "------------------------------------------------------------------------------------------------------------------------------------------------------------"
		ENDIF
			*     0123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456
			*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
	CASE XsTipRep = 2
		IF XiCodMon = 1
			En6 = "-----------------------------------------------------------------------------------------------------------"
			En7 = "                 No.                                           US$                                   SALDO "
			En8 = "   FECHA    COMPROBANTE     DOCUMENTO  REFERENCIA          IMPORTE      CARGOS       ABONOS         ACTUAL "
			En9 = "-----------------------------------------------------------------------------------------------------------"
		ELSE
			En6 = "-----------------------------------------------------------------------------------------------------------"
			En7 = "                 No.                                           S/.                                   SALDO  "
			En8 = "   FECHA    COMPROBANTE     DOCUMENTO  REFERENCIA          IMPORTE      CARGOS       ABONOS         ACTUAL  "
			En9 = "-----------------------------------------------------------------------------------------------------------"
		ENDIF
			*     0123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o1234567
			*               1         2         3         4         5         6         7         8         9         0 
ENDCASE

** VETT: USAMOS CURSOR CON RANGO DE CUENTAS 2021/12/11 18:47:49 **
SELECT c_cTAS_R
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0
NumPag   = 0
LTNumItm = 0
LTCargos = 0
LTAbonos = 0
SCAN 
	**** Quiebre por Cuenta ****
	Llave = CodCta
	IF ! EMPTY(XsCodAux)
	   Llave = PADR(XsCodCta,LEN(CodCta))+TRIM(XsCodAux)
	ENDIF
	SELECT RMOV
	SEEK Llave
	L0NumItm = 0
	L0Cargos = 0
	L0Abonos = 0
	Quiebre0 = .T.
	** VETT:  2021/12/11 18:47:49 **
	DO WHILE CodCta+CodAux = Llave AND !EOF() .AND. ! Cancelar
		**** Quiebre por Proveedor ****
		=SEEK(CodCta,"CTAS")
		=SEEK(CTAS->CLFAUX+CodAux,"AUXI")
		LsCodCta = CodCta
		LsClfAux = ClfAux
		LsCodAux = CodAux
		L1NumItm = 0
		L1Cargos = 0
		L1Abonos = 0
		Quiebre1 = .T.
		DO WHILE CodCta+CodAux = LsCodCta+LsCodAux  AND !EOF() .AND. ! Cancelar
			**** Quiebre por Documento ****
			IF XiCodMon = 1
				IF Import = 0 .AND. (CodOpe="015" .AND. NroAst="000002")
					SKIP
					LOOP
				ENDIF
			ELSE
				IF ImpUsa = 0 .AND. (CodOpe="015" .AND. NroAst="000001")
					SKIP
					LOOP
				ENDIF
			ENDIF
			LsNroDoc = NroDoc
			LiCodMon = CodMon
			L2NumItm = 0
			L2Cargos = 0
			L2Abonos = 0
			Quiebre2 = .T.
			DO CHECKDOC  && *** VERIFICANDO LAS CONDICIONES DE IMPRESION ***
			DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc  AND !EOF() .AND. ! Cancelar
				IF !&LsFor1
					SELECT RMOV
					SKIP
					LOOP
				ENDIF	
				IF BETWEEN(NroMes,lsMesIni,lsMesFin)
					IF NROMES <= XsNroMes
*!*							IF XsTipRep=1
						DO LinImp
*!*							ELSE
*!*								DO LinImp1
*!*							ENDIF
					ELSE
						SKIP
					ENDIF
				ELSE
	               SKIP
				ENDIF
				Cancelar = ( INKEY() = k_esc )
			ENDDO
			IF ! Cancelar .AND. L2NumItm > 0
				L2SalAct = L2Cargos - L2Abonos
				NumLin = PROW()
				SELECT Temporal
				IF L2SalAct >= 0
					REPLACE Saldo WITH L2SalAct
				ELSE
					REPLACE Saldo WITH -L2SalAct
				ENDIF
				SELECT RMOV
				L1NumItm = L1NumItm + 1
				L1Cargos = L1Cargos + L2Cargos
				L1Abonos = L1Abonos + L2Abonos
			ENDIF
		ENDDO
		IF ! Cancelar .AND. L1NumItm > 0
			NumLin = PROW()+1
			L1SalAct = L1Cargos - L1Abonos
			
			SELECT Temporal
			APPEND BLANK 
			replace CodCta WITH LsCodCta
			replace CodAux WITH LsCodAux
			replace NomAux WITH "'---- TOTAL AUXILIAR ------------------------->"
			replace Glodoc WITH "*** TOTAL AUXILIAR : " + LsCodAux+" " + AUXI.NomAux

			IF L1Cargos >= 0
				replace debe WITH L1Cargos
				
			ELSE
				replace debe WITH -L1Cargos
			ENDIF
			IF L1Abonos >= 0
				replace haber WITH L1Abonos
			ELSE
				replace haber WITH -L1Abonos
			ENDIF
			IF L1SalAct >= 0
				replace saldo WITH L1SalAct
			ELSE
				replace saldo WITH -L1SalAct
			ENDIF
			APPEND BLANK
			replace Codcta WITH LsCodCta	
			replace CodAux WITH LsCodAux
			SELECT RMOV
			L0NumItm = L0NumItm + 1
			L0Cargos = L0Cargos + L1Cargos
			L0Abonos = L0Abonos + L1Abonos
		ENDIF
	ENDDO
	IF ! Cancelar .AND. L0NumItm > 0
		L0SalAct = L0Cargos - L0Abonos
		SELECT Temporal
		APPEND BLANK 
		replace CodCta WITH LsCodCta
		replace CodAux WITH LsCodAux
		replace Glodoc WITH "*** TOTAL CUENTA "+LsCodCta+"  ***"
		IF L0Cargos >= 0
			replace debe WITH L0Cargos
		ELSE
			replace debe WITH -L0Cargos
		ENDIF
		IF L0Abonos >= 0
			replace haber WITH 	L0Abonos
		ELSE
			replace haber WITH 	-L0Abonos
		ENDIF
		IF L0SalAct >= 0
			replace saldo WITH 	L0SalAct
		ELSE
			replace saldo WITH 	-L0SalAct
		ENDIF
		SELECT Temporal
		APPEND BLANK 
		replace CodCta WITH LsCodCta
		replace CodAux WITH LsCodAux
		LTNumItm = LTNumItm + 1
		LTCargos = LTCargos + L0Cargos
		LTAbonos = LTAbonos + L0Abonos
	ENDIF
	SELECT C_CTAS_R
ENDSCAN
IF ! Cancelar .AND. LTNumItm > 0
		LTSalAct = LTCargos - LTAbonos
		SELECT Temporal
		APPEND BLANK 
		replace CodCta WITH LsCodCta
		replace CodAux WITH LsCodAux
		replace Glodoc WITH "*** TOTAL GENERAL  ***"
			
		IF LTCargos >= 0
			replace debe WITH LTCargos
		ELSE
			replace debe WITH -LTCargos
		ENDIF
		IF LTAbonos >= 0
			replace haber WITH 	LTAbonos
		ELSE
			replace haber WITH 	-LTAbonos
		ENDIF
		IF LTSalAct >= 0
			replace saldo WITH 	LTSalAct
		ELSE
			replace saldo WITH 	-LTSalAct
		ENDIF
ENDIF

RETURN
**********************************************************************
PROCEDURE LinImp
****************
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = FchVto
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO CALIMP
DO CASE
	CASE TpoMov = "D"
		Cargos = Cargos + nIMPORT
		IF LiCodMon = 2
			SdoUsa = SdoUsa + ImpUsa
		ENDIF
	OTHER
		Abonos = Abonos + nIMPORT
		IF LiCodMon = 2
			SdoUsa = SdoUsa - ImpUsa
		ENDIF
ENDCASE

** VETT:Quiebre por cuenta 2021/12/11 19:49:13 **
IF Quiebre0
	Quiebre0 = .F.
	SELECT Temporal
	APPEND BLANK
	REPLACE CodCta WITH LsCodCta
	REPLACE CodAux WITH LsCodAux
	replace NomAux WITH AUXI->NomAux
	replace RucAux WITH AUXI->RucAux
	REPLACE GloDoc WITH LsCodCta+" " + C_CTAS_R.NomCta	
	SELECT RMOV
ENDIF
** VETT: 2021/12/11 19:49:13 **

** VETT:Grabamos documentos pendientes en cursor temporal 2021/11/27 13:13:06 **
IF Quiebre1
	Quiebre1 = .F.
	SELECT Temporal
	APPEND BLANK
	REPLACE CodCta WITH LsCodCta
	REPLACE CodAux WITH LsCodAux
	replace NomAux WITH AUXI->NomAux
	replace RucAux WITH AUXI->RucAux
	REPLACE GloDoc WITH LsCodAUX+" " + AUXI.NomAux	
	SELECT RMOV
ENDIF

SELECT Temporal
APPEND BLANK
REPLACE CodCta WITH RMOV.CodCta
REPLACE CodAux WITH RMOV.CodAux
replace CodDoc WITH Rmov.CodDoc
replace NroDoc WITH Rmov.NroDoc
replace FchDoc WITH Rmov.FchDoc
replace NroAst WITH Rmov.NroAst
Replace NroMes WITH Rmov.NroMes
replace GloDoc WITH Rmov.GloDoc
replace CodOpe WITH Rmov.CodOpe
replace codmon WITH Rmov.Codmon
replace TpoCmb WITH Rmov.TpoCmb
replace Impusa WITH Rmov.Impusa
replace RucAux WITH AUXI->RucAux
replace NomAux WITH AUXI->NomAux
replace FchVto WITH RMOV.FchVto
replace Fchast WITH RMOV.FchAst
replace Obser  WITH Captura_Obs()
REPLACE Debe   WITH IIF(Cargos>=0,1,-1)*Cargos
REPLACE Haber  WITH IIF(Abonos>=0,1,-1)*Abonos

*REPLACE Saldo  WITH Debe - Haber
SELECT Rmov

NumItm = NumItm + 1
SKIP
IF Cargos = 0 .AND. Abonos = 0 .AND. (LsCodOpe="015" .AND. LsNroAst="000002")
	RETURN
ENDIF

IF ! EMPTY(LsFchVto)
ENDIF

IF SdoUsa >= 0
ELSE
ENDIF

IF Cargos >= 0
ELSE
ENDIF

IF Abonos >= 0
ELSE
ENDIF

L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
RETURN
****************
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
******************
PROCEDURE CHECKDOC
******************
RegAct = RECNO()
SalAct = 0
UltMes = "  "
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc AND !EOF() .AND. ! Cancelar 
	IF !&LsFor1
		SELECT RMOV
		SKIP
		LOOP
	ENDIF
	IF NROMES <= XsNroMes
		UltMes = NroMes
		DO CALIMP
		IF TpoMov = "D"
			SalAct = SalAct + nIMPORT
		ELSE
			SalAct = SalAct - nIMPORT
		ENDIF
	ENDIF
	SKIP
ENDDO
IF SalAct <> 0
	Goto RegAct
ENDIF
RETURN
*****************
PROCEDURE LinImp1
*****************
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = FchVto
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO CALIMP
DO CASE
	CASE TpoMov = "D"
		Cargos = Cargos + nIMPORT
		IF LiCodMon = 2
			SdoUsa = SdoUsa + ImpUsa
		ENDIF
	OTHER
		Abonos = Abonos + nIMPORT
		IF LiCodMon = 2
			SdoUsa = SdoUsa - ImpUsa
		ENDIF
ENDCASE
NumItm = NumItm + 1
SKIP
NumLin = PROW() + 1
IF Cargos = 0 .AND. Abonos = 0 .AND. (LsCodOpe="015" .AND. LsNroAst="000002")
	RETURN
ENDIF
DO RESETPAG
IF Quiebre1
	Quiebre1 = .F.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
NumLin = PROW()+1
@ NumLin , 0  SAY LsFchAst
@ NumLin , 11 SAY LsCodOpe
@ NumLin , 15 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 28 SAY LsNroDoc
@ NumLin , 39 SAY LsNroRef
IF SdoUsa >= 0
	@ NumLin ,53  SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,53  SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
	@ NumLin ,66 SAY Cargos       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,66 SAY -Cargos      PICTURE "@Z 9,999,999.99-"
ENDIF
IF Abonos >= 0
	@ NumLin ,79 SAY Abonos       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,79 SAY -Abonos      PICTURE "@Z 9,999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
RETURN
*********************
FUNCTION Captura_Obs
********************* 
IF !(Ll_Liqui_C AND Ll_Liqui_D)
	RETURN ""
ENDIF 
LOCAL LnSelect
IF VARTYPE(LsObs)<>'C'
	LsObs = ""
ENDIF 
LnSelect=SELECT()
IF !USED('L_C_Cobr')
	RETURN ""
ENDIF
IF !USED('L_D_Cobr')
	RETURN ""
ENDIF

DO CASE
	CASE RMOV.CODCTA='12' AND RMOV.TpoMov = "H"
		IF rmov.COdOpe='010' AND (RMOV.NroAst>='09000004' AND RMOV.NroAst>='09000012') 
*!*				SET STEP ON 
		ENDIF 
		LsCodDoc=RMOV.CodDoc
		LsNroDoc=RMOV.NroDOc
		SELECT L_C_Cobr
		=SEEK(LEFT(DTOS(RMOV.FchAst),6)+RMOV.CodOpe+RMOV.NroAst,"L_C_Cobr")
		LsLiqui = Liqui
		SELECT L_D_Cobr
		SEEK ALLTRIM(LsCodDoc+PADR(LsNroDoc,LEN(L_d_Cobr.nrodoc))+LsLiqui)
		LsObs = Obs		
ENDCASE
SELECT (LnSelect)
RETURN LsObs