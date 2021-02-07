DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlncfgpl
loContab.oDatadm.CloseTable('BPGO')
loContab.oDatadm.CloseTable('TMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlncfgpl
*******************
DIMENSION VecOpc(15)
cTit1 = GsNomCia
cTit2 = "RESUMEN CONCEPTOS DE PLANILLA"
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTIT4 = "CONFIGURACIONES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Apertura de Archivos *!*
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNCFGP1','BPGO','CFGP101','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNCFGP2','BPGO','CFGP201','')
ENDCASE
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE

zTpoVar  = "123456789ABCD"
XiTpoVar = []
XiNroItm = []
XsCodMov = []
XsCodCta = []
XsCodPar = []
XsCtrCta = []
XsCodOpe = []
XsCodRef = []
XcTpoMov = []
XsFlgCal = []
XlInsert = .F.
Set_Escape = .T.
UltTecla = 0
TITULO   = ""
EscLin   = "MvtEscbe"
SelLin   = "MvtSelec"
EdiLin   = "MvtEdita"
BrrLin   = "MvtBorra"
InsLin   = "MvtGraba"
GrbLin   = "MvtGraba"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = "Mvtf5"
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
NClave   = ""
VClave   = ""
Yo       = 5
Xo       = 12
Largo    = 15
Ancho    = 60
TBorde   = Simple
E1       = "   TIPO                                            CALC."
E2       = " CONCEPTO     ITEM  VAR.  DESCRIPCION               S/N "
             ************* 16*  21** 26*********************** *****"

XsGloDOc = ""

E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
SELECT BPGO
@ 20,Xo CLEAR TO 22,Xo+Ancho-1
@ 20,Xo       TO 22,Xo+Ancho-1
GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F5] Imprime"
DO LIb_mtec with 99
DO DBrowse
CLOSE DATA
RETURN
******************
PROCEDURE MvtEscbe
******************
Parameter Contenido
DO CASE
	CASE TPOVAR = '1'
		Contenido = "INGRESOS      "
	CASE TPOVAR = '2'
		Contenido = "IMPUESTOS     "
	CASE TPOVAR = '3'
		Contenido = "DESCUENTOS    "
	CASE TPOVAR = '4'
		Contenido = "APORTACIONES  "
	CASE TPOVAR = '5'
		Contenido = "PROVISIONES  "
	CASE TPOVAR = '6'
		Contenido = "INGR.GRATIF. "
	CASE TPOVAR = '7'
		Contenido = "IMPU.GRATIF. "
	CASE TPOVAR = '8'
		Contenido = "DESC.GRATIF. "
	CASE TPOVAR = '9'
		Contenido = "APOR.GRATIF. "
	CASE TPOVAR = 'A'
		Contenido = "INGR.VACACI. "
	CASE TPOVAR = 'B'
		Contenido = "IMPU.VACACI. "
	CASE TPOVAR = 'C'
		Contenido = "DESC.VACACI. "
	CASE TPOVAR = 'D'
		Contenido = "APOR.VACACI. "
	OTHER
		Contenido = "             "
ENDCASE
=SEEK(Codmov,"TMOV")
Contenido = Contenido + STR(NroItm,4,0) + "  " + CodMov + " "
Contenido = Contenido + TMov->DesMov + ' ' +IIF(FLGCAL,' S ',' N ')
RETURN
******************
PROCEDURE MvtSelec
******************
PRIVATE TlTitle
@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
*!*	21,Xo+2 SAY GlodOC
******************
PROCEDURE MvtEdita
******************
DO LIB_MTEC WITH 11
Inserta = .F.
*!*	LinAct Línea Actual inicializada en la libreria
IF TpoVar $ zTpoVar
	XiTpoVar = AT(TpoVar,zTpoVar)
ELSE
	XiTpoVar = 1
ENDIF
XiNroItm = NroItm
XsCodMov = CodMov
XsFlgCal = iif(FlgCal,'S','N')
@ 21,Xo+2 CLEAR TO  21,Xo+Ancho-3
TlBloque = .T.
TnBloque = 1
TnMaxBlq = 9
DO WHILE ! INLIST(UltTecla,Escape,CtrlW,F10)
	DO CASE
		CASE TnBloque = 1
			VecOpc(1)= "INGRESOS     "
			VecOpc(2)= "IMPUESTOS    "
			VecOpc(3)= "DESCUENTOS   "
			VecOpc(4)= "APORTACIONES "
			VecOpc(5)= "PROVISIONES  "
			VecOpc(6)= "INGR. GRATIF."
			VecOpc(7)= "IMPU. GRATIF."
			VecOpc(8)= "DESC. GRATIF."
			VecOpc(9)= "APOT. GRATIF."
			VecOpc(10)="INGR. VACACI."
			VecOpc(11)="IMPU. VACACI."
			VecOpc(12)="DESC. VACACI."
			VecOpc(13)="APOR. VACACI."
			XiTpoVar = Elige(XiTpoVar,LinAct,Xo+2,13)
		CASE TnBloque = 2
			@ LinAct,Xo+16   GET XiNroItm PICT "####"
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+16   SAY XINroItm PICT "####"
		CASE TnBloque = 3
			@ LinAct,Xo+22   GET XsCodMov PICT "!!99"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			@ LinAct,Xo+22   SAY XsCodMov
			=SEEK(XsCodMov,"TMOV")
			@ LinAct,Xo+27   SAY TMOV->DesMov
		CASE TnBloque = 4
			@ LinAct,Xo+54   GET XsFlgCal PICT "@!" Valid inlist(XsFlgCal,'S','N')
			READ
			UltTecla = LASTKEY()
			@ LinAct,Xo+54   SAY XsFlgCal PICT "@!"
	ENDCASE
	DO CASE
		CASE UltTecla = Escape
			EXIT
		CASE UltTecla = Arriba
			TnBloque = IIF( TnBloque > 1 , TnBloque-1 , 1)
		CASE UltTecla = Enter .OR. UltTecla = CtrlW .OR. UltTecla = F10
			IF TnBloque<TnMaxBlq
				TnBloque = TnBloque+1
			ELSE
				EXIT
			ENDIF
	ENDCASE
ENDDO
IF UltTecla =Escape
	GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F5] Imprime"
	DO LIb_mtec with 99
ENDIF
RETURN
******************
PROCEDURE MvtGraba
******************
DO LIB_MSGS WITH 3
IF Crear
	APPEND BLANK
ENDIF
IF Rec_Lock(5)
	XiTpoVar = IIF(XiTpoVar>LEN(zTpoVar),Len(zTpoVar),XiTpoVar)
	XiTpoVar = IIF(XiTpoVar<1 ,1 ,XiTpoVar)
	XcTpoVar = SUBSTR(zTpoVar,XiTpoVar,1)
	REPLACE TpoVar WITH  XcTpoVar
	REPLACE NroItm WITH  XiNroItm
	REPLACE CodMov WITH  XsCodMov
	REPLACE FlgCal WITH  IIF(XsFlgCal='S',.T.,.F.)
	UNLOCK
ENDIF
GsMsgKey = "[Ins] Inserta [Del] Anula [Esc] Salir [F5] Imprime"
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
PROCEDURE MvtF5
***************
SAVE SCREEN TO TMP
xFor = []
xWhile = []
SEEK VCLave
Largo = 66
IniPrn  = [_Prn0+_prn5a+chr(Largo)+_prn5b+_prn1]
sNomRep = "PLN_PLNGBPGO"
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
