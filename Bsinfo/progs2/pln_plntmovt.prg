**************************************************************************
*  Nombre    : PLNTMovT.PRG                                              *
*  Objeto    : Generador de Tablas de Movimientos y Resultados           *
*              Planilla Semanal                                          *
*  Actualizaci¢n:   /  /                                                 *
**************************************************************************
PARAMETERS XsTipMov,cNomMov,cTipVar

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln
escape = 27
XsCodPln = TRIM(GsCodPln)

DO tmov

loContab.oDatadm.CloseTable('TMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF


**************
PROCEDURE tmov
**************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		NomArch  = "PLNVAR1"+XsTipMov+".cal"
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		NomArch  = "PLNVAR2"+XsTipMov+".cal"
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		NomArch  = "PLNVAR3"+XsTipMov+".cal"
ENDCASE
SELECT tmov
cTit1 = "Tabla de Movimientos"
cTit2 = GsNomCia
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = cNomMov
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*         10        20        30        40        50        60        70
*0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123
*
*.----------------------------------------------------------------------.
*|                                 Grupo Aplc.  Inic.   Precisi¢n Rango |
*| C¢d.  Descripci¢n                S¡    No    Cierre  Ent. Dec. Valor |
*+----------------------------------------------------------------------+
*| 123   123456789-123456789-12345   2     8      1     12    1     Si  |
*|    123                         123 12345  12345 12345  1234 12345  1 |
*|                                  123456789-123456789-123456789-12345 |
*+----------------------------------------------------------------------+
*|----------------------------------------------------------------------|
*.----------------------------------------------------------------------.
*| Minimo :  123456789-123456789-        M ximo :  123456789-123456789- |
*`----------------------------------------------------------------------'
* Variables Usadas en la Edici¢n y Grabaci¢n de Items
XsCodMov = []
XsDesMov = []
XsAGrpSi = []
XsAGrpNo = []
XnCieMov = 0
XnCieCal = 0
XnEntMov = 0
XnDecMov = 0
XsRgoMov = []
XnValMin = 0
XnValMax = 0
XnValMov = 0
XsFmlMov = []
XcSitMov = ' '
XcTpoVar = ' '
XlInsert = .F.
Set_Escape = .T.
UltTecla = 0
TITULO   = ""
SelLin   = "MvtSelec"
EdiLin   = "MvtEdita"
BrrLin   = "MvtBorra"
InsLin   = "MvtGraba"
GrbLin   = "MvtGraba"
MVprgF1  = "MvtF1"
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = "Mvtf5"
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
NClave   = "CodMov"
VClave   = XsTipMov
Yo       = 5
Xo       = 4
Largo    = 15
Ancho    = 72
TBorde   = Simple
E1       = "                                 T T Grp.Apl. Inic.   Precisi¢n Rango "
E2       = " C¢d.  Descripci¢n               C V  S¡  No  Cierre  Ent. Dec. Valor "
E3       = []
LinReg =[CodMov+'  '+DesMov+' '+IIF(RIGH(CodMov,2)='00',REPL('-',35),]+;
        [SitMov+' '+TpoVar+'  '+AGrpSi+'    '+AGrpNo+'   '+TRAN(CieMov,'@Z 9')+'      '+STR(EntMov]+;
        [,2,0)+'    '+STR(DecMov,1,0)+'     '+IIF(RgoMov='S','Si','No') )+' ']
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.

IF XsTipMov>="R"
	E1       = "                                 T F Grp.Apl. Inic.   Precisi¢n       "
	E2       = " C¢d.  Descripci¢n               C P  S¡  No  Cierre  Ent. Dec.       "
	LinReg =[CodMov+'  '+DesMov+' '+IIF(RIGH(CodMov,2)='00',REPL('-',35),]+;
        [SitMov+' '+TpoVar+'  '+AGrpSi+'    '+AGrpNo+'   '+TRAN(CieMov,'@Z 9')+'      '+STR(EntMov]+;
        [,2,0)+'    '+STR(DecMov,1,0)+'       ')+' ']
ENDIF
@ 20,Xo CLEAR TO 22,Xo+Ancho-1
@ 20,Xo       TO 22,Xo+Ancho-1
GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F1] Ayuda [F5] Imprime"
DO LIb_mtec with 99
XlFormula=.f.
DO DBrowse
IF XsTipMov >= "R"
	CLEAR
	LsNomArch = NomArch
	Ruta_tmov = SYS(2023) + "\"
	Arch_Pcal = Ruta_Tmov+LsNomArch
	NomArch = Arch_Pcal
	DELETE FILE (nomarch)
	CLEAR
	DO PLNGNPRG
	CLEAR
	GsMsgErr = "Proceso Completado"
	DO LIB_MERR WITH 99
ENDIF
RETURN
******************
PROCEDURE MvtSelec
******************
PRIVATE TlTitle
TlTitle  = RIGHT(CodMov,LEN(CodMov)-1)=REPLICATE('0',LEN(CodMov)-1)
@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
IF CieMov <> 0
	@ 21    ,Xo+2  SAY "Valor a Inicializar : " +TRANSF(ValMov,"###,####,###.##")
ENDIF
IF .NOT. TlTitle .AND. RgoMov = "S" .AND. XsTipMov<"R"
	@ 21,Xo+2  SAY "Minimo : "+TRANSF(ValMin,"##,###,###,###,###.##")
	@ 21,Xo+40 SAY "M ximo : "+TRANSF(ValMax,"##,###,###,###,###.##")
ENDIF
IF .NOT. TlTitle .AND. XsTipMov >= "R"
	@ 21,Xo+2  SAY "Formula: "+SUBSTR(FmlMov,1,58)
ENDIF
******************
PROCEDURE MvtEdita
******************
DO LIB_MTEC WITH 11
Inserta = .F.
XlFormula=.F.
* LinAct L¡nea Actual inicializada en la libreria
IF Crear
	XsCodMov = XsTipMov+SPACE(3)
	LsCodMov = SPACE(3)
	XsDesMov = SPACE(LEN(DesMov))
	XsAGrpSi = ' '
	XsAGrpNo = ' '
	XnCieMov = 0
	XnCieCal = 0
	XnEntMov = 0
	XnDecMov = 0
	XsRgoMov = ' '
	XnValMin = 0
	XnValMax = 0
	XnValMov = 0
	XsFmlMov = SPACE(LEN(FmlMov))
	XcSitMov = ' '
	XcTpoVar = ' '
ELSE
	XsCodMov = CodMov
	LsCodMov = SUBSTR(CodMov,2,3)
	XsDesMov = DesMov
	XsAGrpSi = AGrpSi
	XsAGrpNo = AGrpNo
	XnCieMov = CieMov
	XnCieCal = CieCal
	XnEntMov = EntMov
	XnDecMov = DecMov
	XsRgoMov = RgoMov
	XnValMin = ValMin
	XnValMax = ValMax
	XnValMov = ValMov
	XsFmlMov = FmlMov
	XcSitMov = SitMov
	XcTpoVar = TpoVar
ENDIF
TlTitle  = RIGHT(XsCodMov,2)="00"
@ LinAct,Xo+2    SAY XsCodMov COLOR -
@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
TlBloque = .T.
TnBloque = 1
TnMaxBlq = IIF(TlTitle , 1 , 15)
DO Lib_MTEC WITH 13
DO WHILE TlBloque
	DO CASE
		CASE TnBloque = 1
			@ LinAct,Xo+3    GET LsCodMov PICT "!99" VALID LEN(ALLTRIM(LsCodMov))=3
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			@ LinAct,Xo+3    SAY LsCodMov
			XsCodMov=XsTipMov+LsCodMov
			TlTitle  = RIGHT(XsCodMov,2)="00"
			TnMaxBlq = IIF(TlTitle , 2 , 14)
		CASE TnBloque = 2
			@ LinAct,Xo+8    GET XsDesMov
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+8    SAY XsDesMov
		CASE TnBloque = 3
			@ LinAct,Xo+34 GET XcSitMov PICT "!" VALID XcSitMov$" VG" ERROR "Valores aceptados ' ' , 'V' , 'G'"
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+34 SAY XcSitMov
		CASE TnBloque = 4
			@ LinAct,Xo+36 GET XcTpoVar PICT "!" VALID XcTpoVar$" @" ERROR "Valores aceptados ' ' , '@'"
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+36 SAY XcTpoVar
		CASE TnBloque = 5
			@ LinAct,Xo+39 GET XsAGrpSi PICT "@!"
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+39 SAY XsAGrpSi
		CASE TnBloque = 6
			@ LinAct,Xo+44 GET XsAGrpNo PICT "@!"
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+44 SAY XsAGrpNo
		CASE TnBloque = 7
			@ LinAct,Xo+48 GET XnCieMov PICT "@Z #"   RANGE 0,1
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+48 SAY XnCieMov PICT "@Z #"
		CASE TnBloque = 8
			@ LinAct,Xo+55 GET XnEntMov PICT "@Z ##"  RANGE 1,16
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+55 SAY XnEntMov PICT "@Z ##"
		CASE TnBloque = 9
			@ LinAct,Xo+61 GET XnDecMov PICT "@Z #"   RANGE 0,5
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+61 SAY XnDecMov PICT "@Z #"
		CASE (TnBloque = 11 .AND. XsTipMov >= "R" )
			GsMsgKey =" [F1] Ayuda    [F9] Copia Formula   [Enter] Graba   [Esc] Cancela"
			DO Lib_MTEC WITH 99
			@ 21,Xo+2  SAY "Formula: " GET XsFmlMov PICTURE "@!S58"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = F1       &&  F1
				DO FmlHelp
				LOOP
			ENDIF
			IF UltTecla = F9
				lEof    = EOF()
				nRegAct = RECNO()
				cVar = XsCodMov
				@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
				@ 21,Xo+2 SAY "INDIQUE LA VARIABLE A COPIAR LA FORMULA : " ;
				Get cVar PICT "!!99"
				READ
				UltTecla = LASTKEY()
				IF UltTecla <> Escape
					SEEK cVar
					XsFmlMov = FmlMov
					IF lEof
						GOTO BOTTOM
						IF ! EOF()
							SKIP
						ENDIF
					ELSE
						GOTO nRegAct
					ENDIF
				ENDIF
				UltTecla = 0
				LOOP
			ENDIF
			@ 21,Xo+2  SAY "Formula:  "+XsFmlMov PICTURE "@!S68"
			XsRgoMov = " "
			IF UltTecla <> Escape
				TlErrCal = ErrLin()
				IF TlErrCal
					UltTecla = 0
					LOOP
				ENDIF
				XlFormula=.t.
			ENDIF
			DO Lib_MTEC WITH 13
		CASE TnBloque = 12 .AND. XsTipMov < "R"
			VecOpc(1) = "No"
			VecOpc(2) = "S¡"
			XsRgoMov  = Elige(XsRgoMov,LinAct,Xo+67,2)
			@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
		CASE TnBloque = 13 .AND. XsRgoMov = 'S'.AND. XsTipMov < "R"
			@ 21    ,Xo+2  SAY "Minimo : " GET XnValMin PICTURE "##############.##"
			@ 21    ,Xo+40 SAY "M ximo : " GET XnValMax PICTURE "##############.##"
			READ
			UltTecla = LASTKEY()
		CASE TnBloque = 14 .AND. XnCieMov <> 0 .AND. XsTipMov < "R"
			@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
			@ 21    ,Xo+2  SAY "Valor a Inicializar : " GET XnValMov PICTURE "##############.##"
			READ
			UltTecla = LASTKEY()
	ENDCASE
	DO CASE
		CASE UltTecla = Escape
			EXIT
		CASE UltTecla = Arriba
			TnBloque = IIF( TnBloque > 1 , TnBloque-1 , 1)
		CASE UltTecla = CtrlW .OR. UltTecla = F10
			TlBloque = .F.
		CASE UltTecla = Enter .OR. UltTecla = CtrlW .OR. UltTecla = F10
			IF TnBloque<TnMaxBlq
				TnBloque = TnBloque+1
			ELSE
				TlBloque = .F.
			ENDIF
	ENDCASE
ENDDO

IF UltTecla =Escape
	GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F1] Ayuda [F5] Imprime"
	DO LIb_mtec with 99
ENDIF
RETURN

******************
PROCEDURE MvtGraba
******************
DO LIB_MSGS WITH 3
lokk=.f.
IF Crear
	APPEND BLANK
ENDIF
IF Rec_Lock(5)
	REPLACE CodMov WITH  XsCodMov
	REPLACE DesMov WITH  XsDesMov
	REPLACE AGrpSi WITH  XsAGrpSi
	REPLACE AGrpNo WITH  XsAGrpNo
	REPLACE CieMov WITH  XnCieMov
	REPLACE CieCal WITH  XnCieCal
	REPLACE EntMov WITH  XnEntMov
	REPLACE DecMov WITH  XnDecMov
	REPLACE RgoMov WITH  XsRgoMov
	REPLACE ValMin WITH  XnValMin
	REPLACE ValMax WITH  XnValMax
	REPLACE FmlMov WITH  XsFmlMov
	REPLACE ValMov WITH  XnValMov
	REPLACE SitMov WITH  XcSitMov
	REPLACE TpoVar WITH  XcTpoVar
	UNLOCK
	lOkk=.t.
ENDIF
*!*	IF XlFormula AND GlPlnDmo and lOkk
*!*		do plntmovt.spr
*!*	ENDIF
GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F1] Ayuda [F5] Imprime"
DO LIb_mtec with 99
RETURN
******************
PROCEDURE MvtBorra
******************
IF Rec_Lock(5)
	OK = .T.
	DELETE
	UNLOCK
ENDIF
RETURN
***************
PROCEDURE MvtF1
***************
SAVE SCREEN
GsMsgErr = "[Esc] Salir"
DO LIB_MTEC WITH 99
@  2,13 SAY  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  3,13 SAY  '³Teclas de Selecci¢n :                              ³'
@  4,13 SAY  '³   Cursor Arriba ....... Retroceder un Registro    ³'
@  5,13 SAY  '³   Cursor Abajo  ....... Adelentar un Registro     ³'
@  6,13 SAY  '³   Home          ....... Primer Registro           ³'
@  7,13 SAY  '³   End           ....... Ultimo Registro           ³'
@  8,13 SAY  '³   PgUp          ....... Retroceder en Bloque      ³'
@  9,13 SAY  '³   PgDn          ....... Adelantar en Bloque       ³'
@ 10,13 SAY  '³Teclas de Edici¢n :                                ³'
@ 11,13 SAY  '³   Enter         ....... Modificar el Registro     ³'
@ 12,13 SAY  '³                         Seleccionado              ³'
@ 13,13 SAY  '³   Del           ....... Anular el Registro        ³'
@ 14,13 SAY  '³                         Seleccionado              ³'
@ 15,13 SAY  '³   Ins           ....... Insertar un  Registro     ³'
@ 16,13 SAY  '³                                                   ³'
@ 17,13 SAY  '³   F1            ....... Pantalla Actual de Ayuda  ³'
@ 18,13 SAY  '³   F5            ....... Impresi¢n                 ³'
@ 19,13 SAY  '³   F10           ....... Terminar el Proceso       ³'
@ 20,13 SAY  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
DO WHILE INKEY(0)<>Escape
ENDDO
RESTORE SCREEN
RETURN
*****************
PROCEDURE FmlHelp
*****************
SAVE SCREEN
GsMsgErr = "[Esc] Salir"
DO LIB_MTEC WITH 99
@  1,13 SAY  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  2,13 SAY  '³ * Multiplicar| % Porcentaje| > Mayor      | # Diferente³'
@  3,13 SAY  '³ / Dividir    |             | < Menor      | & .AND.    ³'
@  4,13 SAY  '³ + Sumar      | ^ Potencia  | } Mayor igual| | .OR.     ³'
@  5,13 SAY  '³ - Restar     | (   )       | { Menor igual| ! Negaci¢n ³'
@  6,13 SAY  '³******* Variables **********| = Igual      |            ³'
@  7,13 SAY  '³ ~F???? Res. Acumulados  |******* Funciones *********** ³'
@  8,13 SAY  '³ ~I???? Ing. y Descuentos| @Max(<Exp1>,<Exp2>) M ximo   ³'
@  9,13 SAY  '³ ~A???? Asist. y Movimi. | @Min(<Exp1>,<Exp2>) Minimo   ³'
@ 10,13 SAY  '³ ~Q???? Adelantos        | ~RA01.06 ->Suma ~RA01 A ~RA06³'
@ 11,13 SAY  '³ ~R???? Resultados       | @Importa(<Var>)              ³'
@ 12,13 SAY  '³ ~C???? Cond. C lculo    | @Abs(<Exp>)   Valor Absoluto ³'
@ 13,13 SAY  '³ @NumPer().No. Periodo   | @SEL(<Var>,VAL1,VAL2,...)    ³'
@ 14,13 SAY  '³ @Abs(<Exp>) ..................... Valor absoluto       ³'
@ 15,13 SAY  '³ @DTO?([<Monto Max>]) .............Dsto Cta.Cte         ³'
@ 16,13 SAY  '³ @Caso(<Exp>,<Caso 1>,.,<Caso n>). Caso                 ³'
@ 17,13 SAY  '³ @Ent(<Exp>) ..................... Valor entero         ³'
@ 18,13 SAY  '³ @Rnd(<Exp>,<Val>) ............... Redondeo             ³'
@ 19,13 SAY  '³ @Si(<Exp L¢gica>,<Exp1>,<Exp2>).. Condicionante        ³'
@ 20,13 SAY  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
DO WHILE INKEY(0)<>Escape
ENDDO
RESTORE SCREEN
RETURN
**************************************************************************
PROCEDURE MvtF5
***************
SAVE SCREEN TO TMP
xFor = []
xWhile = [CodMov = XsTipMov]
SEEK VCLave
IF XsTipMov < "R"
	IniPrn  = [_prn1]
	sNomRep = "PLN_PLNTMOV1"
ELSE
	IniPrn  = [_prn3]
	sNomRep = "PLN_PLNTMOV2"
ENDIF
DO F0PRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
****************
PROCEDURE ErrLin
****************
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
******************
PROCEDURE PLNGNPRG
******************
PRIVATE TlTitle, TsCodMov, TsValCal, TsFmlMov
*!* ACTIVANDO EL PROGRAMA DE CALCULO *!*
DO LIB_MSGS WITH 3
@ 19,23 CLEAR TO 21,57
@ 19,23       TO 21,57 PANEL
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
	@ 20,33 SAY "Procesando : "+TsCodMov
	DO LinPrg
	SKIP
ENDDO
? "TnNumLin = " + STR(NumLin)
? "RETURN"
?
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
COMPILE (NomArch)
RETURN