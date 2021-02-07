****************************************
* PROGRAMA    : CBDCFPDT.PRG           *
* AUTOR       : MAAV                   *
* OBJETO      : CONFIGURA EL PDT       *
* CREACION    : 16/08/2001             *
****************************************
PRIVATE XSFORMULARIO,XSNOMBRE,XSCODOPE,XSCODCTA
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION DEL PDT"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SELE 0
USE CBDTOPER ORDER OPER01 ALIAS OPER
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE CBDFLPDT ORDER FPDT01 ALIAS FPDT
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
store [] to XSFORMULARIO,XSNOMBRE,XSCODOPE,XSCODCTA
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
Set_Escape = .T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = [xBSelLin]
InsLin   = [xBgrab]
EscLin   = []
EdiLin   = [TabEdit]
BrrLin   = [BorrReg]
GrbLin   = [xBgrab]
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = [xBF9]
PrgFin   = []
Titulo   = []
NClave   = []
VClave   = []
HTitle   = 3
Yo       = 5
Xo       = 5
Largo    = 16
TBorde   = Doble
*                    1         2         3         4         5         6         7         8
*          012345678901234567890123456789012345678901234567890123456789012345678901234567890
*           **** ********************* ***  *******
E1       = [FORM NOMBRE                LIB. CUENTA ]
E2       = []
E3       = []
LinReg   = [FORMULARIO+" "+NOMBRE+" "+CODOPE+"  "+CODCTA]
Ancho    = LEN(&LinReg)+4
Xo       = INT((80 - Ancho)/2)
Static   = .F.
VSombra  = .F.
**
sorteo   =  1
localiza = .F.
GsMsgKey = "[Esc] Salir   [Enter] Modificar  [F9] Reportes"
DO LIB_MTEC WITH 99
DO DBrowse
CLOSE DATA
RETURN

*****************
PROCEDURE TABEDIT
*****************
IF ! Crear
	XSFORMULARIO =  FORMULARIO
	XSNOMBRE     =  NOMBRE
	XsCodCta     =  CODCTA
	XsCodOpe     =  CODOPE
ELSE
	XSFORMULARIO =  SPACE(LEN(FORMULARIO))
	XSNOMBRE     =  SPACE(LEN(NOMBRE))
	XsCodCta     =  SPACE(LEN(CODCTA))
	XsCodOpe     =  SPACE(LEN(CODOPE))
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
	DO CASE
		CASE i = 1
			@ LinAct,Xo+2  GET XSFORMULARIO PICT "9999"
			READ
			UltTecla = LastKey()
			IF (UltTecla == Escape)
				LOOP
			ENDIF
			@ LinAct,Xo+2 SAY XSFORMULARIO
		CASE i = 2
			@ LinAct,Xo+7 GET XSNOMBRE PICT "@20"
			READ
			UltTecla = LastKey()
			IF UltTecla = Escape
				LOOP
			ENDIF
			@ LinAct,Xo+7 SAY XSNOMBRE
		CASE i = 3
			@ LinAct,Xo+28  GET XsCodOpe PICT  "@LZ ###"
			READ
			UltTecla = LastKey()
			IF UltTecla = Escape
				LOOP
			ENDIF
			SELE OPER
			IF UltTecla = F8
				IF CJABUSCA("OPER")
					XsCodOpe = CodOpe
				ELSE
					LOOP
				ENDIF
			ENDIF
			XsCodOpe = TRANSF(XsCodOPe,"@L ###")
			IF !SEEK(XsCodOpe)
				GsMsgErr = [OPERANCION NO REGISTRADA]
				DO LIB_MERR WITH 99
				SELE PROV
				LOOP
			ENDIF
			SELE FPDT
			@ LinAct,Xo+28 SAY XsCodOpe
		CASE i = 4
			@ LinAct,Xo+33  GET XsCodCta FUNC "S7"
			READ
			UltTecla = LastKey()
			IF UltTecla = Escape
				LOOP
			ENDIF
			@ LinAct,Xo+33 SAY XsCodCta PICT "@S7"
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>4, 4, i)
	i = IIF(i<1, 1, i)
ENDDO
SELE FPDT
GsMsgKey = "[F5] Buscar  [Esc] Salir   [Enter] Modificar  [F9] Reportes"
DO LIB_MTEC WITH 99
RETURN

******************
PROCEDURE XBSelLin
******************
@21,2 TO 23,77 CLEA
@21,2 TO 23,77
SELE OPER
SEEK FPDT->CODOPE
IF FOUND()
	@22,4 SAY "OPERACION CONTABLE: " + OPER->NOMOPE COLOR SCHEME 11
ELSE
	@22,4 SAY "OPERACION CONTABLE NO REGISTRADA"    COLOR SCHEME 11
ENDIF
SELE FPDT
RETU

****************
PROCEDURE xBgrab
****************
IF Crear
	APPEND BLANK
ENDIF
IF !RLOCK()
	RETURN
ENDIF
REPLACE FORMULARIO WITH XSFORMULARIO
REPLACE XSNOMBRE   WITH XSNOMBRE
REPLACE CODCTA     WITH XsCodCta
REPLACE CODOPE     WITH XsCodOpe
UNLOCK
RETURN

******************************
* Objeto: Borrar un Registro *
******************************
PROCEDURE BORRreg
IF !RLOCK()
	UltTecla = Escape
	RETURN
ENDIF
DELETE
UNLOCK
SKIP
RETURN

**************
PROCEDURE xBF9
**************
xOrder = ORDER()
SAVE SCREEN TO LsPan01
xFOR   = []
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "CBDFLPDT"
GO TOP
DO admprint WITH "REPORTS"
RESTORE SCREEN FROM LsPan01
SET ORDER TO (xOrder)
RETURN
