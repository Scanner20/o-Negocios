*!* Inicializamos Variables *!*
*!*	XsCodPln = TRIM(GsCodPln)
*!*	XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

*!*	Aperturamos Tablas *!*
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
*!*	DO CASE
*!*		CASE XsCodPln = "1"
*!*			goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
*!*			XsTabMov = "PLNTMOV1"
*!*		CASE XsCodPln = "2"
*!*			goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
*!*			XsTabMov = "PLNTMOV2"
*!*		CASE XsCodPln = "3"
*!*			goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
*!*			XsTabMov = "PLNTMOV3"
*!*	ENDCASE
goentorno.open_dbf1('ABRIR','CMPTMOVG','TMOV','TMOV01','')
MsCodMov = ""
*!* Ejecutamos Formulario *!*
DO FORM Cmp_Cmptmovt

******************
PROCEDURE PLNGNPRG
******************
PRIVATE TlTitle, TsCodMov, TsValCal, TsFmlMov
XsTipMov = MsCodMov
SET CONSOLE OFF
SET PRINTER TO (NomArch) ADDITIVE
SET PRINTER ON
*!* GRABANDO LA CABEZERA *!*
??"********************************"
? "* PROGRAMA : "+NomArch
? "*            CALCULO DE PLANILLA"
? "* USUARIO  : "+GsUsuario
? "* FECHA    : "+DTOC(DATE())
? "********************************"
? "RELEASE V"
? "DIMENSION V(30)"
NumLin = 0
SELECT TMOV
SEEK XsTipMov
DO WHILE .NOT. EOF() .AND. CodMov = XsTipMov
	NumLin = NumLin + 1
	TsFmlMov = TRIM(FmlMov)
	TsCodMov = CodMov
	TcSitMov = SitMov
	TcAGrpSi = AGrpSi
	TcAGrpNo = AGrpNo
	TnCieCal = CieCal
	TcTpoVar = TpoVar
	TnNroDec = IIF(DecMov>=0 .AND. DecMov<=4,DecMov,4)
	DO LinPrg
	WAIT WINDOW "Procesando : "+TsCodMov NOWAIT
	SKIP
ENDDO
? "TnNumLin = " + STR(NumLin)
? "RETURN"
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
COMPILE (NomArch)
SELECT TMOV1
RETURN

****************
PROCEDURE LinPrg
****************
TlTitle  = RIGHT(TsCodMov,2)="00"
CodErr   = 0
NumErr   = 0
NomErr   = 0
NumCol   = 0
ida      = 0
vuelta   = 0
IF ! TlTitle
	i = 1
	NomVar  = ""
	lNumero = .f.
	lVariab = .f.
	lFuncio = .f.
	nTpoVar = 0
	NumVar  = 0
	? "*-------------------------------------------------------------------"
	? "NomVar = ["+ TsCodMov + "]"
	? "* "+TsFmlMov
	? "nValRef = 0"
	? "IF NomVar = XXXVar"
	IF TcTpoVar = "@"
		lTpoFml = .t.
		? "   TpoFml  = .T."
		? "   DO WHILE nValRef <= 12"
		? "   ExpVal = .F."
	ELSE
		lTpoFml = .f.
		? "   TpoFml  = .F."
	ENDIF
	*!* Variables de la Expresión *!*
	lString = .f.
	NomExp  = ""
	DO WHILE i <= LEN(TsFmlMov)
		DO CASE
			CASE SUBSTR(TsFmlMov, i,1)=["]
				lString = ! lString
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
			CASE lString
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
			CASE SUBSTR(TsFmlMov, i,1) $ "@"
				lFuncio = .t.
			CASE SUBSTR(TsFmlMov, i,1) $ "(" .and. lFuncio
				lFuncio = .f.
			CASE SUBSTR(TsFmlMov, i,1)$"0123456789." .AND. ! lVariab .AND. ! lFuncio
				IF ! lNumero
					lNumero = .t.
					lVariab = .f.
					NomVar  = ""
				ENDIF
				NomVar = NomVar + SUBSTR(TsFmlMov, i,1)
			CASE SUBSTR(TsFmlMov, i,1)="_"
				NomVar  = ""
				lVariab = .t.
				lNumero = .f.
				nTpoVar = 3
			CASE SUBSTR(TsFmlMov, i,1)="~"
				NomVar  = ""
				lVariab = .t.
				lNumero = .f.
				nTpoVar = 1
			CASE SUBSTR(TsFmlMov, i,1)="$"
				NomVar  = ""
				lVariab = .t.
				lNumero = .f.
				nTpoVar = 2
			CASE SUBSTR(TsFmlMov, i,1) $ " #+-*/^%=&|)><,{}" .AND. (lNumero .OR. lVariab)
				NumVar = NumVar + 1
				DO CASE
					CASE lNumero
						? "   V(" + STR(NumVar,2,0) + ") = " + NomVar
					CASE nTpoVar = 1 .AND. XsTipMov="Z" .AND. TcTpoVar = "A"
						? "   V(" + STR(NumVar,2,0) + ") = VarAcm([" + NomVar + "])"
					CASE nTpoVar = 1
						? "   V(" + STR(NumVar,2,0) + ") = GetVar([" + NomVar + "])"
					CASE nTpoVar = 2
						? "   V(" + STR(NumVar,2,0) + ") = Suma([" + NomVar + "])"
					CASE nTpoVar = 3
						? "   V(" + STR(NumVar,2,0) + ") = VMes([" + NomVar + "])"
				ENDCASE
				lNumero = .f.
				lVariab = .f.
			CASE lVariab
				NomVar = NomVar + SUBSTR(TsFmlMov, i,1)
		ENDCASE
		IF SUBSTR(TsFmlMov, i,1)="(" .AND. ! lString
			IDA = IDA + 1
		ENDIF
		IF SUBSTR(TsFmlMov, i,1)=")" .AND. ! lString
			VUELTA = VUELTA + 1
		ENDIF
		i = i + 1
	ENDDO
	IF (lNumero .OR. lVariab)
		NumVar = NumVar + 1
		IF lNumero
			? "   V(" + STR(NumVar,2,0) + ") = " + NomVar
		ELSE
			DO CASE
				CASE nTpoVar = 1 .AND. XsTipMov="Z" .AND. TcTpoVar = "A"
					? "   V(" + STR(NumVar,2,0) + ") = VarAcm([" + NomVar + "])"
				CASE nTpoVar = 1
					? "   V(" + STR(NumVar,2,0) + ") = GetVar([" + NomVar + "])"
				CASE nTpoVar = 2
					? "   V(" + STR(NumVar,2,0) + ") = Suma([" + NomVar + "])"
				CASE nTpoVar = 3
					? "   V(" + STR(NumVar,2,0) + ") = VMes([" + NomVar + "])"
			ENDCASE
		ENDIF
	ENDIF
	i = 1
	NomExp  = ""
	NumVar  = 0
	NomFun  = ""
	lNumero = .f.
	lVariab = .f.
	lFuncio = .f.
	lString = .f.
	DO WHILE i <= LEN(TsFmlMov)
		DO CASE
			CASE SUBSTR(TsFmlMov, i,1)=["]
				lString = ! lString
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
			CASE lString
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
			CASE SUBSTR(TsFmlMov, i,1)$"0123456789." .AND. ! lVariab .AND. ! lFuncio
				lNumero = .t.
			CASE SUBSTR(TsFmlMov, i,1)$"~$_"
				lVariab = .t.
				lNumero = .f.
			CASE SUBSTR(TsFmlMov, i,1) $ " #+-*/^%=,|&><}{" .AND. (lNumero .OR. lVariab)
				IF (lNumero .OR. lVariab)
					NumVar = NumVar + 1
					NomExp = NomExp + "V("+STR(NumVar,2,0)+")"
					lNumero = .f.
					lVariab = .f.
				ENDIF
				vOperador = SUBSTR(TsFmlMov, i,1)
				DO CASE
					CASE vOperador $ " #+-*/^=,><"
						NomExp = NomExp + vOperador
					CASE vOperador = "%"
						NomExp = NomExp + "*.001*"
					CASE "|" = SUBSTR(TsFmlMov, i,1)
						NomExp = NomExp + ".OR."
					CASE "&" = SUBSTR(TsFmlMov, i,1)
						NomExp = NomExp + ".AND."
					CASE vOperador = "}"
						NomExp = NomExp + ">="
					CASE vOperador = "{"
						NomExp = NomExp + "<="
				ENDCASE
			CASE SUBSTR(TsFmlMov, i,1) $ "@"
				lFuncio = .t.
				NomFun  = ""
			CASE SUBSTR(TsFmlMov, i,1) $ "(" .and. lFuncio
				DO CASE
					CASE NomFun = "ENT"
						NomFun = "INT"
					CASE NomFun = "RND"
						NomFun = "VALRED"
					CASE NomFun = "SI"
						NomFun = "IIF"
					CASE NomFun = "VENTAS"
						NomFun = "VENTAS"
					CASE NomFun = "ROUND"
					CASE NomFun = "DFVL"
					CASE NomFun = "ABS"
					CASE NomFun = "MAX"
					CASE NomFun = "MIN"
					CASE NomFun = "CASO"
					CASE NomFun = "DIAS"
					CASE NomFun = "DOM"
					CASE NomFun = "HORAS"
					CASE NomFun = "DIAV"
					CASE NomFun = "DOMV"
					CASE NomFun = "NUMPER"
					CASE NomFun = "SEL"
					CASE NomFun = "NROMES"
					CASE NomFun = "QESCALA"
					CASE NomFun = "QPROYEC"
					CASE NomFun = "QUINTA"
					CASE NomFun = "SUMANT"
					CASE NomFun = "VALACM"
					CASE NomFun = "VALANT"
					CASE NomFun = "SPER"
					CASE NomFun = "VAC"
					CASE NomFun = "DSTO"
					CASE NomFun = "CODPLN"
					CASE NomFun = "CODSEC"
					CASE NomFun = "BASICO"
					CASE NomFun = "JUDICIAL"
					CASE NomFun = "CARGO"
					CASE NomFun = "AFP"
					CASE NomFun = "NHIJOS"
					CASE NomFun = "ESS"
					CASE NomFun = "SCT"
					CASE NomFun = "HONO"
					CASE NomFun = "SEXO"
					CASE NomFun = "PVAC"
					CASE NomFun = "PRMVAR"
					CASE NomFun = "DGRAT"
					CASE NomFun = "SUMGRA"
					CASE NomFun = "SUMVAC"
					CASE NomFun = "TMPMES"
					CASE NomFun = "TMPAMD"
					CASE NomFun = "DIACTS"
					CASE NomFun = "MESCTS"
					CASE NomFun = "ANOCTS"
					CASE NomFun = "MESVAC"
					CASE NomFun = "DTRAB"
					CASE NomFun = "DIAGRA"
					CASE NomFun = "HEXTCTS"
					CASE NomFun = "DINAS"
					CASE NomFun = "CCOSTO"
					CASE NomFun = "PRMSAL"
					OTHER
						IF NumErr = 0
							NumErr = 1
							NomErr = "Invalida Funci¢n en posici¢n "+ltrim(str(i))
						ENDIF
						NomFun = ""
				ENDCASE
				NomExp = NomExp + NomFun + "("
				lFuncio = .f.
			CASE SUBSTR(TsFmlMov, i,1) $ ")"
				IF (lNumero .OR. lVariab)
					NumVar = NumVar + 1
					NomExp = NomExp + "V("+STR(NumVar,2,0)+")"
					lNumero = .f.
					lVariab = .f.
				ENDIF
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
			CASE lFuncio
				NomFun = NomFun + SUBSTR(TsFmlMov, i,1)
			CASE "|" = SUBSTR(TsFmlMov, i,1)
				NomExp = NomExp + ".OR."
			CASE "&" = SUBSTR(TsFmlMov, i,1)
				NomExp = NomExp + ".AND."
			CASE ! (lNumero .OR. lVariab .or. lFuncio)
				NomExp = NomExp + SUBSTR(TsFmlMov, i,1)
		ENDCASE
		i = i + 1
	ENDDO
	IF (lNumero .OR. lVariab)
		NumVar = NumVar + 1
		NomExp = NomExp + "V("+STR(NumVar,2,0)+")"
		lNumero = .f.
		lVariab = .f.
	ENDIF
	IF TRIM(NomExp) == ""
		NomExp = "0"
	ENDIF
	IF  LTpoFml
		? "   IF ExpVal"
		? "      TnValCal = "+NomExp
		? "   ELSE"
		? "      TnValCal = 0.00"
		? "   ENDIF"
	ELSE
		? "   TnValCal = "+NomExp
	ENDIF
	? "   DO Graba WITH ["+TsCodMov+"]"+",["+TcAGrpSi+"],["+TcAGrpNo+"],";
		+"["+TcSitMov+"],["+TcTpoVar+"],"+ LTRIM(STR(TnNroDec))
	IF  LTpoFml
		? "   nValRef = nValRef + 1"
		? "   ENDDO"
	ENDIF
	IF XsTipMov="F"
		? "ENDIF"
	ENDIF
	? "ENDIF"
	IF Ida <> Vuelta
		IF IDA>VUELTA
			NomErr = "Falta )"
		ELSE
			NomErr = "Falta ("
		ENDIF
		NumErr = 4
	ENDIF
	? ""
ENDIF
RETURN

****************
PROCEDURE ErrLin
****************
SET STEP ON
NumErr = 0
NumCol = 0
NomErr = ""
SET PRINTER TO errores.cal
SET CONSOLE OFF
SET PRINTER ON
TsFmlMov = TRIM(XsFmlMov)
TsCodMov = XsCodMov
TcSitMov = XcSitMov
TcAGrpSi = XsAGrpSi
TcAGrpNo = XsAGrpNo
TcTpoVar = XcTpoVar
TnCieCal = XnCieCal
TnNroDec = IIF(XnDecMov>=0 .AND. XnDecMov<=4,XnDecMov,4)
DO LinPrg
SET PRINTER OFF
SET PRINTER TO
IF NumErr = 0
	DELETE FILE ERRORES.ERR
	COMPILE ERRORES.CAL
	IF File("errores.err")
		NumErr = 99
		NumCol = 1
		NomErr = "Error de Sintaxis"
	ENDIF
ENDIF
DELETE FILE ERRORES.ERR
DELETE FILE ERRORES.CAL
DELETE FILE ERRORES.FXP
SET CONSOLE ON
IF NumErr <> 0
	GsMsgErr = NomErr
	DO Lib_MErr WITH 0
ENDIF
RETURN ! NumErr = 0
