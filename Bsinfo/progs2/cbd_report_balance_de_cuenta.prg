#Include const.h
UltTecla = 0
INC = 0   && SOLES
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','') 
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','') 
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XiTpoMov = 1
*** Ejecutamos formulario ***
DO FORM cbd_report_balance_de_cuentas
RETURN

******************
PROCEDURE Imprimir
******************
LsCtas=.f.
SELECT RMOV
Llave = XsCodCta+TRIM(XsCodAux)
IF LEN(TRIM(XsCodCta))<LEN(RMOV.CodCta)
	LLave = TRIM(XsCodCta)
	LsCtas=.t.
ENDIF
SEEK Llave
IF ! FOUND()
	WAIT Window "No existen registros a listar" NoWait
	RETURN
ENDIF

*!*	IniImp   = _Prn8a+_Prn4    && 15   cpi
*!*	Ancho    = 150
*!*	Largo    = 66
*!*	LinFin   = 88 - 8
*!*	Tit_SIzq = GsNomCia
*!*	Tit_IIzq = GsDirCia
*!*	Tit_SDer = "FECHA : "+DTOC(DATE())
*!*	Tit_IDer = ""
*!*	Titulo   = "BALANCE DE CUENTA CORRIENTE AL "+DTOC(GdFecha)
*!*	SubTitulo= TRIM(CTAS->NomCta)
*!*	EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
*!*	En2    = " "
*!*	En3    = ""
*!*	En4    = ""
*!*	En5    = ""
*!*	En6 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ **************"
*!*	En7 = "               No.                                 FECHA    FECHA                                         US$                                   SALDO  "
*!*	En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.  VENCTO   FINANZAS GLOSA                            IMPORTE       CARGOS       ABONOS         ACTUAL "
*!*	En9 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ **************"
*!*	*      0******* 9************** 25************ 40******** 51****** 60****** 69************************* 97*********** 111********* 124********* 137***********"
*!*	*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*!*	*      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14    
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0
**PRINTJOB
GOTO RegIni
n_contador = 1
NumPag   = 0
L0NumItm = 0
L0Cargos = 0
L0Abonos = 0
LsUltCta = space(len(ctas.codcta))
LsQuiCta = .f.
Store 0 to LaNumItm,LaCargos,LaAbonos
DO WHILE CodCta+CodAux = Llave .AND. ! Cancelar
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
						DO LinImp
					ELSE
						SKIP
					ENDIF
				CASE XiTpoMov = 2
					IF NROMES <= XsNroMes
						DO LinImp
					ELSE
						SKIP
					ENDIF
			ENDCASE
			SELECT Rmov
            Cancelar = ( INKEY() = k_Esc )
		ENDDO
		IF ! Cancelar .AND. L2NumItm > 0
			L2SalAct = L2Cargos - L2Abonos
			LsCtas = .F.
			IF !LsCtas
				IF L2SalAct >= 0
					Replace temporal.t04 WITH L2SalAct
					**@ NumLin ,137 SAY L2SalAct       PICTURE "99999,999.99"
				ELSE
					Replace temporal.t04 WITH L2SalAct
					**@ NumLin ,137 SAY -L2SalAct      PICTURE "99999,999.99-"
				ENDIF
				DO Coloca_Linea
				LsCtas = .T.
				**NumLin = PROW()+1
				**@ NumLin,0 SAY REPLICATE(".",Ancho)
			ENDIF
			UNLOCK
			L1NumItm = L1NumItm + 1
			L1Cargos = L1Cargos + L2Cargos
			L1Abonos = L1Abonos + L2Abonos
		ENDIF
		SELECT Rmov
	ENDDO
	IF ! Cancelar .AND. L1NumItm > 0
		L1SalAct = L1Cargos - L1Abonos
		m.Quiebre ="D"
		m.QuiebreA = TRANSFORM(n_contador,[@L ###])
		SELECT Temporal
		APPEND BLANK
		DO WHILE !RLOCK()
		ENDDO
		Replace Quiebre  WITH m.Quiebre
		Replace QuiebreA WITH m.QuiebreA
		Replace NomCta   WITH "TOTAL " + LsCodAux
		**@ NumLin,56 SAY "** TOTAL "+LsCodAux+" **"
		IF L1Cargos >= 0
			Replace t02 WITH L1Cargos
			**@ NumLin ,111 SAY L1Cargos       PICTURE "9999,999.99"
		ELSE
			Replace t02 WITH -L1Cargos
			**@ NumLin ,111 SAY -L1Cargos      PICTURE "9999,999.99-"
		ENDIF
		IF L1Abonos >= 0
			Replace t03 WITH L1Abonos
			**@ NumLin ,124 SAY L1Abonos       PICTURE "9999,999.99"
		ELSE
			Replace t03 WITH -L1Abonos
			**@ NumLin ,124 SAY -L1Abonos      PICTURE "9999,999.99-"
		ENDIF
		IF L1SalAct >= 0
			Replace t04 WITH L1SalAct
			**@ NumLin ,137 SAY L1SalAct       PICTURE "99999,999.99"
		ELSE
			Replace t04 WITH L1SalAct
			**@ NumLin ,137 SAY -L1SalAct      PICTURE "99999,999.99-"
		ENDIF
		**@ NumLin,0 SAY REPLICATE("-",Ancho)
		UNLOCK
		L0NumItm = L0NumItm + 1
		L0Cargos = L0Cargos + L1Cargos
		L0Abonos = L0Abonos + L1Abonos
	ENDIF
	IF ! Cancelar .AND. LaNumItm > 0 AND  LsCtas
		LaSalAct = LaCargos - LaAbonos
		m.Quiebre ="E"
		m.QuiebreA = TRANSFORM(n_contador,[@L ###])
		SELECT Temporal
		APPEND BLANK
		DO WHILE !RLOCK()
		ENDDO
		Replace Quiebre  WITH m.Quiebre
		Replace QuiebreA WITH m.QuiebreA
		Replace NomCta   WITH "TOTAL CUENTA " + LsUltCta
		**@ NumLin,56 SAY "** TOTAL CUENTA "+LsUltCta+" **"
		IF LaCargos >= 0
			Replace t02 WITH LaCargos
			**@ NumLin ,111 SAY LaCargos       PICTURE "9999,999.99"
		ELSE
			Replace t02 WITH -LaCargos
			**@ NumLin ,111 SAY -LaCargos      PICTURE "9999,999.99-"
		ENDIF
		IF LaAbonos >= 0
			Replace t03 WITH LaAbonos
			**@ NumLin ,124 SAY LaAbonos       PICTURE "9999,999.99"
		ELSE
			Replace t03 WITH -LaAbonos
			**@ NumLin ,124 SAY -LaAbonos      PICTURE "9999,999.99-"
		ENDIF
		IF LaSalAct >= 0
			Replace t04 WITH LaSalAct
			**@ NumLin ,137 SAY LaSalAct       PICTURE "9,999,999.99"
		ELSE
			Replace t04 WITH LaSalAct
			**@ NumLin ,137 SAY -LaSalAct      PICTURE "9,999,999.99-"
		ENDIF
		**@ NumLin,0 SAY REPLICATE("-",Ancho)
		UNLOCK
		n_contador = n_contador + 1
	ENDIF
	SELECT Rmov
ENDDO
IF ! Cancelar .AND. L0NumItm > 0
*!*		NumLin = PROW()+1
*!*		@ NumLin,0 SAY REPLICATE("=",Ancho)
*!*		NumLin = PROW()+1
	L0SalAct = L0Cargos - L0Abonos
	m.Quiebre = "F"
	m.QuiebreA = "ULT"
	SELECT Temporal
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	Replace Quiebre  WITH m.Quiebre
	Replace QuiebreA WITH m.QuiebreA
	Replace NomCta   WITH "TOTAL GENERAL"
	**@ NumLin,56 SAY "*  TOTAL GENERAL *"
	IF L0Cargos >= 0
		Replace t02 WITH L0Cargos
		**@ NumLin ,111 SAY L0Cargos       PICTURE "99999999.99"
	ELSE
		Replace t02 WITH -L0Cargos
		**@ NumLin ,111 SAY -L0Cargos      PICTURE "99999999.99-"
	ENDIF
	IF L0Abonos >= 0
		Replace t03 WITH L0Abonos
		**@ NumLin ,124 SAY L0Abonos       PICTURE "99999999.99"
	ELSE
		Replace t03 WITH -L0Abonos
		**@ NumLin ,124 SAY -L0Abonos      PICTURE "99999999.99-"
	ENDIF
	IF L0SalAct >= 0
		Replace t04 WITH L0SalAct
		**@ NumLin ,137 SAY L0SalAct       PICTURE "99999,999.99"
	ELSE
		Replace t04 WITH L0SalAct
		**@ NumLin ,137 SAY -L0SalAct      PICTURE "99999,999.99-"
	ENDIF
	UNLOCK
ENDIF
**EJECT PAGE
**ENDPRINTJOB
**SET DEVICE TO SCREEN
**DO F0PRFIN IN BELCSOFT
RETURN

****************
PROCEDURE LinImp
****************
*!*	IF NumPag = 0 .OR. PROW() > LinFin
*!*		IF Cancelar
*!*			EXIT
*!*		ENDIF
*!*	ENDIF
IF LsQuiCta AND lsCtas
	m.Quiebre = "A"
	m.QuiebreA = TRANSFORM(n_contador,[@L ###])
	LsQuiCta=.f.
	SELECT Temporal
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	Replace Quiebre  WITH m.Quiebre
	Replace QuiebreA WITH m.QuiebreA
	Replace CodCta   WITH Ctas.CodCta
	Replace NomCta   WITH Ctas.NomCta
	UNLOCK
	**@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
ENDIF
IF Quiebre1
	m.Quiebre = "B"
	m.QuiebreA = TRANSFORM(n_contador,[@L ###])
	Quiebre1 = .F.
	SELECT Temporal
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	Replace Quiebre  WITH m.Quiebre
	Replace QuiebreA WITH m.QuiebreA
	Replace CodCta   WITH LsCodAux
	Replace NomCta   WITH AUXI->NomAux
	UNLOCK
	**@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
SELECT Rmov
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
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
		OTHER
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

m.Quiebre = "C"
m.QuiebreA = TRANSFORM(n_contador,[@L ###])
SELECT Temporal
APPEND BLANK
DO WHILE !RLOCK()
ENDDO
Replace Quiebre  WITH m.Quiebre
Replace QuiebreA WITH m.QuiebreA
Replace CodCta   WITH LsFchAst
Replace CodOpe   WITH LsCodOpe
Replace NroAst   WITH LsNroAst
Replace NroDoc   WITH LsNroDoc
Replace NroRef   WITH LsNroRef
*!*	@ NumLin , 0  SAY LsFchAst
*!*	@ NumLin , 9  SAY LsCodOpe
*!*	@ NumLin , 13 SAY LsNroMes+"-"+LsNroAst
*!*	@ NumLin , 25 SAY LsNroDoc
*!*	@ NumLin , 40 SAY LsNroRef
IF ! EMPTY(LsFchVto)
	Replace FchVct WITH LsFchVto
	**@ NumLin , 51 SAY LsFchVto
ENDIF
**@ numlin,  60 say lsfchped
Replace GloDoc WITH LsGloDoc
**@ NumLin , 69 SAY LsGloDoc        PICTURE "@S27"

IF SdoUsa >= 0
	Replace t01 WITH SdoUsa
	**@ NumLin ,97  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
	Replace t01 WITH -SdoUsa
	**@ NumLin ,97  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF

IF Cargos >= 0
	Replace t02 WITH Cargos
	**@ NumLin ,111 SAY Cargos       PICTURE "9999,999.99"
ELSE
	Replace t02 WITH -Cargos
	**@ NumLin ,111 SAY -Cargos      PICTURE "9999,999.99-"
ENDIF
IF Abonos >= 0
	Replace t03 WITH Abonos
	**@ NumLin ,124 SAY Abonos       PICTURE "9999,999.99"
ELSE
	Replace t03 WITH -Abonos
	**@ NumLin ,124 SAY -Abonos      PICTURE "9999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
RETURN

****************
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
return

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

**********************
PROCEDURE Coloca_Linea
**********************
m.Quiebre  = "C"
m.QuiebreA = TRANSFORM(n_contador,[@L ###])
SELECT Temporal
APPEND BLANK
DO WHILE !RLOCK()
ENDDO
Replace Quiebre  WITH m.Quiebre
Replace QuiebreA WITH m.QuiebreA
Replace Raya     WITH "___"
RETURN