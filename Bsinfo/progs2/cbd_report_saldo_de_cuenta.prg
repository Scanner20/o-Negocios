#Include const.h
UltTecla = 0
INC = 0		&& SOLES
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','') 
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
*** Ejecutamos Formulario ***
DO FORM cbd_report_saldo_de_cuenta
RETURN

******************
PROCEDURE Imprimir
******************
DIMENSION vCodCta(20,2)
NumEle = 0
MaxEle = 20
*** Buscando las cuentas que selecciona el auxiliar ***
SELECT CTAS
SET ORDER TO CTAS03
SEEK "SS"+XsClfAux
DO WHILE AftMov+PidAux+ClfAux = "SS"+XsClfAux
	IF CodCta = TRIM(XsCodCta)
		IF NumEle = MaxEle
			MaxEle = MaxEle + 10
			DIMENSION vCodCta(MaxEle,2)
		ENDIF
		NumEle = NumEle + 1
		vCodCta(NumEle,1) = CodCta
		vCodCta(NumEle,2) = NomCta
	ENDIF
	SKIP
ENDDO
IF NumEle = 0
	GsMsgErr = "No existen cuentas asignadas a este auxiliar"
	DO LIB_MERR WITH 99
	RETURN
ENDIF
SET ORDER TO CTAS01
***** Registro de inicio de Impresión ******
SELECT AUXI
Llave = XsClfAux+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
	GsMsgErr = "No existen registros a listar"
	DO LIB_MERR WITH 99
	RETURN
ENDIF

*!*	EN1    = "SALDOS PENDIENTES AL "+DTOC(GdFecha)
*!*	EN2    = ALLTRIM(TABL->Nombre)
*!*	EN3    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
*!*	En4    = ""
*!*	En5    = ""
*!*	En6 = "****** ********************************** ************* ************ ************ ************* "
*!*	En7 = "                                                 SALDO                                   SALDO  "
*!*	En8 = "CUENTA  D E S C R I P C I O N                 ANTERIOR      CARGOS       ABONOS         ACTUAL  "
*!*	En9 = "****** ********************************** ************* ************ ************ ************* "
*!*	*      0***** 7********************************* 42*********** 56********** 69********** 82*********** "
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0
GOTO RegIni
NumPag   = 0
L0NumItm = 0
L0SalAnt = 0
L0Cargos = 0
L0Abonos = 0
n_contador=1
DO WHILE ClfAux+CodAux = Llave .AND. ! Cancelar
  	**** Quiebre por Auxiliar ****
  	m.Quiebre="A"+TRANSFORM(n_contador,[@l ##])
	LsClfAux = ClfAux
	LsCodAux = CodAux
	SELECT Temporal
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	replace Quiebre WITH m.Quiebre
	replace CodCta  WITH LsCodAux
	replace NomCta  WITH Auxi.NomAux
	unlock
	**-->@ 24,0 SAY PADC(TRIM(CodAux)+" "+TRIM(NOMAUX),80)
  	L1NumItm = 0
  	L1SalAnt = 0
  	L1Cargos = 0
  	L1Abonos = 0
  	Quiebre1 = .T.
	*** Buscando las cuentas que selecciona el auxiliar ***
	Cancelar = ( INKEY() = k_Esc )
	FOR Item = 1 TO NumEle
		m.Quiebre = "B"+TRANSFORM(n_contador,[@l ##])
		LsCodCta = vCodCta(Item,1)
		LsNomCta = vCodCta(Item,2)
		L2NumItm = 0
		L2SalAnt = 0
		L2Cargos = 0
		L2Abonos = 0
		Quiebre2 = .T.
		*** Buscando Movimientos para el auxiliar seleccionado ***
		SELECT RMOV
		SEEK LsCodCta+LsCodAux
		DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
			DO CHECKDOC
			Cancelar = ( INKEY() = k_esc )
		ENDDO
		IF ! Cancelar .AND. L2NumItm > 0
			IF Quiebre1
				Quiebre1 = .F.
				**-->@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
				**-->@ NumLin+1,0 SAY ""
			ENDIF
			L2SalAct = L2SalAnt + L2Cargos - L2Abonos
			SELECT Temporal
			APPEND BLANK
			DO WHILE !RLOCK()
			ENDDO
			replace Quiebre WITH m.Quiebre
			replace CodCta  WITH LsCodCta
			replace NomCta  WITH LsNomCta
			**@ NumLin,0   SAY LsCodCta
			**@ NumLin,7   SAY LsNomCta PICT "@S34"
			IF L2SalAnt >= 0
				replace t01  WITH L2SalAnt
				**@ NumLin , 42 SAY L2SalAnt       PICTURE "9,999,999.99"
			ELSE
				replace t01  WITH -L2SalAnt
				**@ NumLin , 42 SAY -L2SalAnt      PICTURE "9,999,999.99-"
			ENDIF
			IF L2Cargos >= 0
				replace t02  WITH L2Cargos
				**@ NumLin ,56  SAY L2Cargos       PICTURE "9999,999.99"
			ELSE
				replace t02  WITH -L2Cargos
				**@ NumLin ,56  SAY -L2Cargos      PICTURE "9999,999.99-"
			ENDIF
			IF L2Abonos >= 0
				replace t03  WITH L2Abonos
				**@ NumLin ,69  SAY L2Abonos       PICTURE "9999,999.99"
			ELSE
				replace t03  WITH -L2Abonos
				**@ NumLin ,69  SAY -L2Abonos      PICTURE "9999,999.99-"
			ENDIF
			IF L2SalAct >= 0
				replace t04  WITH L2SalAct
				**@ NumLin ,82  SAY L2SalAct       PICTURE "9,999,999.99"
			ELSE
				replace t04  WITH -L2SalAct
				**@ NumLin ,82  SAY -L2SalAct      PICTURE "9,999,999.99-"
			ENDIF
			L1NumItm = L1NumItm + 1
			L1SalAnt = L1SalAnt + L2SalAnt
			L1Cargos = L1Cargos + L2Cargos
			L1Abonos = L1Abonos + L2Abonos
			UNLOCK
		ENDIF
		IF Cancelar
			EXIT
		ENDIF
	NEXT
	IF ! Cancelar .AND. L1NumItm > 0
		m.quiebre = "C"+TRANSFORM(n_contador,[@l ##])
		L1SalAct = L1SalAnt + L1Cargos - L1Abonos
		SELECT Temporal
		APPEND BLANK
		DO WHILE !RLOCK()
		ENDDO
		replace quiebre WITH m.Quiebre
		replace nomcta  WITH "TOTAL " + LsCodAux
		**@ NumLin,7  SAY "** TOTAL "+LsCodAux+" **"
		IF L1SalAnt >= 0
			replace t01  WITH L1SalAnt
			**@ NumLin , 42 SAY L1SalAnt       PICTURE "9,999,999.99"
		ELSE
			replace t01  WITH -L1SalAnt
			**@ NumLin , 42 SAY -L1SalAnt      PICTURE "9,999,999.99-"
		ENDIF
		IF L1Cargos >= 0
			replace t02  WITH L1Cargos
			*@ NumLin , 56 SAY L1Cargos       PICTURE "9999,999.99"
		ELSE
			replace t02  WITH -L1Cargos
			*@ NumLin , 56 SAY -L1Cargos      PICTURE "9999,999.99-"
		ENDIF
		IF L1Abonos >= 0
			replace t03  WITH L1Abonos
			*@ NumLin , 69 SAY L1Abonos       PICTURE "9999,999.99"
		ELSE
			replace t03  WITH -L1Abonos
			**@ NumLin , 69 SAY -L1Abonos      PICTURE "9999,999.99-"
		ENDIF
		IF L1SalAct >= 0
			replace t04  WITH L1SalAct
			**@ NumLin , 82 SAY L1SalAct       PICTURE "9,999,999.99"
		ELSE
			replace t04  WITH -L1SalAct
			@ NumLin , 82 SAY -L1SalAct      PICTURE "9,999,999.99-"
		ENDIF
		L0NumItm = L0NumItm + 1
		L0SalAnt = L0SalAnt + L1SalAnt
		L0Cargos = L0Cargos + L1Cargos
		L0Abonos = L0Abonos + L1Abonos
		UNLOCK
	ENDIF
	SELECT AUXI
	n_contador = n_contador + 1
	SKIP
ENDDO
IF ! Cancelar .AND. L0NumItm > 0
	m.Quiebre = "D"
	L0SalAct = L0SalAnt + L0Cargos - L0Abonos
	SELECT Temporal
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	replace quiebre WITH m.Quiebre
	replace nomcta  WITH "TOTAL GENERAL"
	*@ NumLin,7  SAY "*  TOTAL GENERAL *"
	IF L0SalAnt >= 0
		replace t01  WITH L0SalAnt
		*@ NumLin , 42 SAY L0SalAnt       PICTURE "9,999,999.99"
	ELSE
		replace t01  WITH -L0SalAnt
		*@ NumLin , 42 SAY -L0SalAnt      PICTURE "9,999,999.99-"
	ENDIF
	IF L0Cargos >= 0
		replace t02  WITH L0Cargos
		**@ NumLin , 56 SAY L0Cargos       PICTURE "9999,999.99"
	ELSE
		replace t02  WITH -L0Cargos
		**@ NumLin , 56 SAY -L0Cargos      PICTURE "9999,999.99-"
	ENDIF
	IF L0Abonos >= 0
		replace t02  WITH L0Abonos
		**@ NumLin , 69 SAY L0Abonos       PICTURE "9999,999.99"
	ELSE
		replace t03  WITH -L0Abonos
		**@ NumLin , 69 SAY -L0Abonos      PICTURE "9999,999.99-"
	ENDIF
	IF L0SalAnt >= 0
		replace t02  WITH L0SalAct
		**@ NumLin , 82 SAY L0SalAct       PICTURE "9,999,999.99"
	ELSE
		replace t02  WITH -L0SalAct
		**@ NumLin , 82 SAY -L0SalAct      PICTURE "9,999,999.99-"
	ENDIF
ENDIF

*!*	****************
*!*	PROCEDURE LinImp
*!*	****************
*!*	nImport= 0
*!*	NumItm = 0
*!*	SalAnt = 0
*!*	Cargos = 0
*!*	Abonos = 0
*!*	DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF()
*!*	   DO CALIMP
*!*	   DO CASE
*!*	      CASE NroMes < XsNroMes
*!*	         IF TpoMov = "D"
*!*	            SalAnt = SalAnt + nIMPORT
*!*	         ELSE
*!*	            SalAnt = SalAnt - nIMPORT
*!*	         ENDIF
*!*	      CASE TpoMov = "D"
*!*	          Cargos = Cargos + nIMPORT
*!*	      OTHER
*!*	          Abonos = Abonos + nIMPORT
*!*	   ENDCASE
*!*	   NumItm = NumItm + 1
*!*	   SKIP
*!*	ENDDO
*!*	L2NumItm = L2NumItm + 1
*!*	L2SalAnt = L2SalAnt + SalAnt
*!*	L2Cargos = L2Cargos + Cargos
*!*	L2Abonos = L2Abonos + Abonos
*!*	RETURN

****************
PROCEDURE CalImp
****************
nImport = IIF(XiCodMon=1,Import,ImpUsa)
RETURN

******************
PROCEDURE CHECKDOC
******************
UltMes   = "  "
NumItm   = 0
SalAnt   = 0
Cargos   = 0
Abonos   = 0
SalAct   = 0
LsNroDoc = NroDoc
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
	DO CALIMP
	DO CASE
		CASE NroMes > XsNroMes
		CASE NroMes < XsNroMes
			IF TpoMov = "D"
				SalAnt = SalAnt + nIMPORT
			ELSE
				SalAnt = SalAnt - nIMPORT
			ENDIF
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
		OTHER
			Abonos = Abonos + nIMPORT
	ENDCASE
	IF NROMES <= XsNroMes
		UltMes = NroMes
		IF TpoMov = "D"
			SalAct = SalAct + nIMPORT
		ELSE
			SalAct = SalAct - nIMPORT
		ENDIF
	ENDIF
	SKIP
ENDDO
IF SalAct <> 0  .OR. UltMes = XsNroMes
	L2NumItm = L2NumItm + 1
	L2SalAnt = L2SalAnt + SalAnt
	L2Cargos = L2Cargos + Cargos
	L2Abonos = L2Abonos + Abonos
ENDIF
RETURN
