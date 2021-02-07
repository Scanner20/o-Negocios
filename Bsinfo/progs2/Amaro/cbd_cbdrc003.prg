#INCLUDE CONST.H
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','')
IF !USED('L_C_Cobr')
		SELECT 0
		USE Liq_Cob order LIQ_COB ALIAS L_C_Cobr	&& LIQUI
ENDIF
IF !USED('L_D_Cobr')
		SELECT 0
		USE Liq_Det order CodDoc ALIAS L_D_Cobr	&& LIQUI
	ENDIF
*goentorno.open_dbf1('ABRIR','LIQ_COB','COB','LIQ_AST','')
*goentorno.open_dbf1('ABRIR','LIQ_DET','DET','CODDOC','')

cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE CUENTA CORRIENTE"
UltTecla = 0
INC = 0   && SOLES
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
*************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XiTpoMov = 1
XiResumen = 2
UltTecla = 0
i        = 1
XsCtaDes = SPACE(LEN(CTAS.CodCta))
XsCtaHas = SPACE(LEN(CTAS.CodCta))
STORE '' TO LsNomCtaDes,LsNomCtaHAs
DO FORM cbd_cbdrc003
RETURN

********************
PROCEDURE GEN_REPORT
********************
LsWhile = '.T.'
LsCtas=.f.
*IF LEN(TRIM(XsCodCta))<LEN(RMOV.CodCta)
IF TRIM(XsCtaDes)<>TRIM(XsCtaHas)
	LsCtas=.t.
ENDIF

XsCtaDes = TRIM(XsCtaDes)
XsCtaHas = TRIM(XsCtaHas)+PADR('z',LEN(CTAS.CodCta))
XsCodCta=PADR(XsCtaDes,LEN(CTAS.CodCta))
SELECT RMOV
Llave = XsCodCta+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
	GO RECNO(0)
ENDIF
IF LsCtas
	LsWhile =  'CodCta <= XsCtaHas'
ELSE
	LsWhile =  'CodCta <= XsCtaDes'
ENDIF
LsFor = '.T.'
IF !EMPTY(XsCodAux)
	LsFor = 'CodAux = XsCodAux'
ENDIf

DO F0PRINT

IF LASTKEY() = k_esc
	RETURN
ENDIF

IniImp   = _Prn8a+_Prn4    && 15   cpi
IF XsTipRep=1
	Ancho    = 166
ELSE
	Ancho    = 121
ENDIF
Largo    = 66
LinFin   = 88 - 10
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "BALANCE DE CUENTA CORRIENTE AL "+DTOC(GdFecha)
SubTitulo= ''
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = IIF(LsCtas,'Desde:'+LsNomCtaDes,LsNomCtaDes)
En3    = IIF(LsCtas,'Hasta:'+LsNomCtaHas,'')
En4    = ""
En5    = ""
IF XsTipRep=1
	En6 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ ************** **************"
	En7 = "               No.                                 FECHA    FECHA                                         US$                                   SALDO   OBSERVACION   "
	En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.  VENCTO   FINANZAS GLOSA                            IMPORTE       CARGOS       ABONOS         ACTUAL       DEP.     "
	En9 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ ************** **************"
*          0******* 9************** 25************ 40******** 51****** 60****** 69************************* 97*********** 111********* 124********* 137*********** 150***********"
*          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
*          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16      
ELSE
	En6 = "******** *************** ************** ********** ************* ************ ************ ************** **************"
	En7 = "               No.                                           US$                                   SALDO    OBSERVACION "
	En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.        IMPORTE       CARGOS       ABONOS         ACTUAL       DEP.    "
	En9 = "******** *************** ************** ********** ************* ************ ************ ************** **************"
*          0******* 9************** 25************ 40******** 51*********** 65********** 79********** 91************ 105***********
*          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*          0         1         2         3         4         5         6         7         8         9        10        11        12
ENDIF
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
	GOTO RegIni
	NumPag   = 0
	L0NumItm = 0
	L0Cargos = 0
	L0Abonos = 0
	LsUltCta = space(len(ctas.codcta))
	LsQuiCta = .f.
	Store 0 to LaNumItm,LaCargos,LaAbonos
	DO WHILE CodCta >= XsCtaDes AND !Cancelar AND EVALUATE(LsWhile)
		IF CodAux<>XsCodAux
			SELECT RMOV
			SKIP
			LOOP
		ENDIF
		IF CodCta<>LsUltCta
			LSUltCta=CodCta
			LsQuiCta=.t.
			Store 0 to LaNumItm,LaCargos,LaAbonos
		ENDIF    		
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
		DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
			**** Quiebre por Documento ****
			LsNroDoc = NroDoc
			LiCodMon = CodMon
			L2NumItm = 0
			L2Cargos = 0
			L2Abonos = 0
			Quiebre2 = .T.
			IF XiTpoMov = 1
				DO CHECKDOC  && *** FILTRA MOVIMIENTOS DEL MES ***
			ENDIF
			DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
				DO CASE
					CASE XiTpoMov = 1
						IF NROMES = XsNroMes
							IF XsTipRep=1
								DO LinImp
							ELSE
								DO LinImp1
							ENDIF
						ELSE
							SKIP
						ENDIF
					CASE XiTpoMov = 2
						IF NROMES <= XsNroMes
							IF XsTipRep=1
								DO LinImp
							ELSE
								DO LinImp1
							ENDIF
						ELSE
							SKIP
						ENDIF
				ENDCASE
				Cancelar = ( INKEY() = k_esc )
			ENDDO
			IF ! Cancelar .AND. L2NumItm > 0
				L2SalAct = L2Cargos - L2Abonos
				IF !LsCtas
					NumLin = PROW()
					IF XsTipRep=1
						IF L2SalAct >= 0
							@ NumLin ,137 SAY L2SalAct  PICTURE "99,999,999.99"
						ELSE
							@ NumLin ,137 SAY -L2SalAct PICTURE "99,999,999.99-"
						ENDIF
					ELSE
						IF L2SalAct >= 0
							@ NumLin ,91 SAY L2SalAct  PICTURE "99,999,999.99"
						ELSE
							@ NumLin ,91 SAY -L2SalAct PICTURE "99,999,999.99-"
						ENDIF
					ENDIF
					NumLin = PROW()+1
					@ NumLin,0 SAY REPLICATE(".",Ancho)
				ENDIF
				L1NumItm = L1NumItm + 1
				L1Cargos = L1Cargos + L2Cargos
				L1Abonos = L1Abonos + L2Abonos
			ENDIF
		ENDDO
		IF ! Cancelar .AND. L1NumItm > 0
			NumLin = PROW()+1
			L1SalAct = L1Cargos - L1Abonos
			IF XsTipRep=1
				@ NumLin,56 SAY "** TOTAL "+LsCodAux+" **"
				IF L1Cargos >= 0
					@ NumLin ,111 SAY L1Cargos  PICTURE "9,99,999.99"
				ELSE
					@ NumLin ,111 SAY -L1Cargos PICTURE "9,99,999.99-"
				ENDIF
			ELSE
				@ NumLin,35 SAY "** TOTAL "+LsCodAux+" **"
				IF L1Cargos >= 0
					@ NumLin ,65 SAY L1Cargos  PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,65 SAY -L1Cargos PICTURE "9,999,999.99-"
				ENDIF
			ENDIF
			IF XsTipRep=1
				IF L1Abonos >= 0
					@ NumLin ,124 SAY L1Abonos  PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,124 SAY -L1Abonos PICTURE "9,999,999.99-"
				ENDIF
			ELSE
				IF L1Abonos >= 0
					@ NumLin ,79 SAY L1Abonos  PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,79 SAY -L1Abonos PICTURE "9,999,999.99-"
				ENDIF
			ENDIF
			IF XsTipRep=1
				IF L1SalAct >= 0
					@ NumLin ,137 SAY L1SalAct  PICTURE "99,999,999.99"
				ELSE
					@ NumLin ,137 SAY -L1SalAct PICTURE "99,999,999.99-"
				ENDIF
			ELSE
				IF L1SalAct >= 0
					@ NumLin ,91 SAY L1SalAct  PICTURE "99,999,999.99"
				ELSE
					@ NumLin ,91 SAY -L1SalAct PICTURE "99,999,999.99-"
				ENDIF
			ENDIF
			NumLin = PROW()+1
			@ NumLin,0 SAY REPLICATE("-",Ancho)
			L0NumItm = L0NumItm + 1
			L0Cargos = L0Cargos + L1Cargos
			L0Abonos = L0Abonos + L1Abonos
		ENDIF
		IF ! Cancelar .AND. LaNumItm > 0 AND  LsCtas AND LsUltCta<>RMOV.CodCta
			NumLin = PROW()+1
			LaSalAct = LaCargos - LaAbonos
			IF XsTipRep=1
				@ NumLin,56 SAY "** TOTAL CUENTA "+LsUltCta+" **"
				IF LaCargos >= 0
					@ NumLin ,111 SAY LaCargos       PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,111 SAY -LaCargos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaAbonos >= 0
					@ NumLin ,124 SAY LaAbonos       PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,124 SAY -LaAbonos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaSalAct >= 0
					@ NumLin ,137 SAY LaSalAct       PICTURE "99,999,999.99"
				ELSE
					@ NumLin ,137 SAY -LaSalAct      PICTURE "99,999,999.99-"
				ENDIF
				NumLin = PROW()+1
				@ NumLin,0 SAY REPLICATE("-",Ancho)
			ELSE
				@ NumLin,35 SAY "** TOTAL CUENTA "+LsUltCta+" **"
				IF LaCargos >= 0
					@ NumLin ,65 SAY LaCargos       PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,65 SAY -LaCargos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaAbonos >= 0
					@ NumLin ,79 SAY LaAbonos       PICTURE "9,999,999.99"
				ELSE
					@ NumLin ,79 SAY -LaAbonos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaSalAct >= 0
					@ NumLin ,91 SAY LaSalAct       PICTURE "99,999,999.99"
				ELSE
					@ NumLin ,91 SAY -LaSalAct      PICTURE "99,999,999.99-"
				ENDIF
				NumLin = PROW()+1
				@ NumLin,0 SAY REPLICATE("-",Ancho)
			ENDIF
		ENDIF
	ENDDO
	IF ! Cancelar .AND. L0NumItm > 0
		NumLin = PROW()+1
		@ NumLin,0 SAY REPLICATE("=",Ancho)
		NumLin = PROW()+1
		L0SalAct = L0Cargos - L0Abonos
		IF XsTipRep=1
			@ NumLin,56 SAY "*  TOTAL GENERAL *"
			IF L0Cargos >= 0
				@ NumLin ,111 SAY L0Cargos       PICTURE "99999999.99"
			ELSE
				@ NumLin ,111 SAY -L0Cargos      PICTURE "99999999.99-"
			ENDIF
			IF L0Abonos >= 0
				@ NumLin ,124 SAY L0Abonos       PICTURE "99999999.99"
			ELSE
				@ NumLin ,124 SAY -L0Abonos      PICTURE "99999999.99-"
			ENDIF
			IF L0SalAct >= 0
				@ NumLin ,137 SAY L0SalAct       PICTURE "99999,999.99"
			ELSE
				@ NumLin ,137 SAY -L0SalAct      PICTURE "99999,999.99-"
			ENDIF
		ELSE
			@ NumLin,35 SAY "*  TOTAL GENERAL *"
			IF L0Cargos >= 0
				@ NumLin ,65 SAY L0Cargos       PICTURE "9,999,999.99"
			ELSE
				@ NumLin ,65 SAY -L0Cargos      PICTURE "9,999,999.99-"
			ENDIF
			IF L0Abonos >= 0
				@ NumLin ,79 SAY L0Abonos       PICTURE "9,999,999.99"
			ELSE
				@ NumLin ,79 SAY -L0Abonos      PICTURE "9,999,999.99-"
			ENDIF
			IF L0SalAct >= 0
				@ NumLin ,91 SAY L0SalAct       PICTURE "99,999,999.99"
			ELSE
				@ NumLin ,91 SAY -L0SalAct      PICTURE "99,999,999.99-"
			ENDIF
		ENDIF
	ENDIF
	EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO F0PRFIN
RETURN
****************
PROCEDURE LinImp
****************
IF NumPag = 0 .OR. PROW() > LinFin
	DO RESETPAG
	IF Cancelar
		EXIT
	ENDIF
ENDIF
IF LsQuiCta AND lsCtas
	LsQuiCta=.f.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
ENDIF
IF Quiebre1
	Quiebre1 = .F.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
LsObs=""
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,4)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,4)
LsFchPed = DTOC(FchPed)
LsFchPed = LEFT(LsFchPed,2)+SUBSTR(LsFchPed,4,2)+RIGHT(LsFchPed,4)
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF() ;
	.AND. CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc
	DO CALIMP
	DO CASE
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa + ImpUsa
			ENDIF
		OTHERWISE
			***-------------------------****
			DO Captura_Obs 
			***-------------------------****
			Abonos = Abonos + nIMPORT			
			IF LiCodMon = 2
				SdoUsa = SdoUsa - ImpUsa
			ENDIF
	ENDCASE
	NumItm = NumItm + 1
	SKIP
ENDDO
IF NumItm > 1
	LsCodRef = TRIM(LsCodRef)+"*"
ENDIF
NumLin = PROW()+1

@ NumLin , 0  SAY LsFchAst
@ NumLin , 9  SAY LsCodOpe
@ NumLin , 13 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 40 SAY LsNroRef
IF ! EMPTY(LsFchVto)
	@ NumLin , 51 SAY LsFchVto
ENDIF
@ numlin,  60 say lsfchped
@ NumLin , 69 SAY LsGloDoc        PICTURE "@S27"

IF SdoUsa >= 0
	@ NumLin ,97  SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,97  SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
	@ NumLin ,111 SAY Cargos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,111 SAY -Cargos      PICTURE "9,999,999.99-"
ENDIF
IF Abonos >= 0
	@ NumLin ,124 SAY Abonos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,124 SAY -Abonos      PICTURE "9,999,999.99-"
ENDIF
@ Numlin, 150 say LsObs

L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
**
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
**
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
return
******************
PROCEDURE ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
	Inicio  = .F.
	DO F0MBPRN 
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
******************
PROCEDURE CHECKDOC
******************
RegAct = RECNO()
SalAct = 0
UltMes = "  "
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
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
IF SalAct <> 0 .OR. UltMes = XsNroMes
	Goto RegAct
ENDIF
RETURN

*****************
PROCEDURE LinImp1
*****************
IF NumPag = 0 .OR. PROW() > LinFin
	DO RESETPAG
	IF Cancelar
		EXIT
	ENDIF
ENDIF
IF LsQuiCta AND lsCtas
	LsQuiCta=.f.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
ENDIF
IF Quiebre1
	Quiebre1 = .F.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
LsObs=""
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,4)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,4)
LsFchPed = DTOC(FchPed)
LsFchPed = LEFT(LsFchPed,2)+SUBSTR(LsFchPed,4,2)+RIGHT(LsFchPed,4)
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF() ;
	.AND. CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc
	DO CALIMP
	DO CASE
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa + ImpUsa
			ENDIF
		OTHERWISE
			***-------------------------****
			DO Captura_Obs 
			***-------------------------****
			Abonos = Abonos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa - ImpUsa
			ENDIF
	ENDCASE
	NumItm = NumItm + 1
	SKIP
ENDDO
IF NumItm > 1
	LsCodRef = TRIM(LsCodRef)+"*"
ENDIF
NumLin = PROW()+1

@ NumLin , 0  SAY LsFchAst
@ NumLin , 9  SAY LsCodOpe
@ NumLin , 13 SAY LEFT(VMOV->NroAst,2)+"-"+SUBSTR(VMOV->NroAst,3,2)+"/"+SUBSTR(VMOV->NroAst,5,4)
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 40 SAY LsNroRef

IF SdoUsa >= 0
	@ NumLin ,51  SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,51  SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
	@ NumLin ,65 SAY Cargos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,65 SAY -Cargos      PICTURE "9,999,999.99-"
ENDIF
IF Abonos >= 0
	@ NumLin ,79 SAY Abonos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,79 SAY -Abonos      PICTURE "9,999,999.99-"
ENDIF
@ Numlin, 105 say LsObs

L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
**
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
**
RETURN

PROCEDURE Captura_Obs 
DO CASE
		CASE CODCTA='12' AND TpoMov = "H"
		LsCodDoc=CodDoc
		LsNroDoc=NroDOc		
		SELECT L_C_Cobr
		SEEK LsNroAst
		LsLiqui = Liqui
		SELECT L_D_Cobr
		SEEK ALLTRIM(LsCodDoc+LsNroDoc+LsLiqui)
		LsObs = Obs		
ENDCASE
SELECT 0
SELECT RMOV
RETURN
