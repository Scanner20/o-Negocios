PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoContab=CREATEOBJECT('Dosvr.Contabilidad')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoContab.oDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')

*!*	DO def_teclas IN FxGen_2
MsCodCta = " "
MsNomCta = " "
MnIporte_D = 0
MnIporte_H = 0
DO FORM cja_cjasaldo
RELEASE LoContab

******************
PROCEDURE consulta
******************
*!*	DO Fondo WITH 'Saldo en Bancos',GoEntorno.User.Login,GsNomcia,GsFecha
DIMENSION vSoles(20),vDolar(20)

MaxEle1 = 0
MaxEle2 = 0
XfTpoCmb = 2.0
XdFchAst = DATE()
IF MONTH(XdFchAst) # _Mes
	XdFchAst = GdFecha
ENDIF
@ 0,0 SAY PADC("ESTADO DE TESORERIA AL "+DTOC(XdFchAst),80)
IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
	SELECT TCMB
	GOTO BOTTOM
ENDIF
IF ! EMPTY(TCMB->OFIVTA)
	XfTpoCmb = TCMB->OFIVTA
ENDIF

@ 20,3 SAY "(T/C. "+TRANSF(XfTpoCmb,"####.###")+")" COLOR SCHEME 7

DO Carga
zs = 1
zd = 1

GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Analizar [Esc] Cancelar [Tab] Cambiar de Ventana"
DO LIB_MTEC WITH 99


SAVE SCREEN TO PANT1
DO WHILE .T.
   RESTORE SCREEN FROM PANT1
   OK       = 0
   IF MaxEle1 > 0
      @  2,0 GET ZD FROM vDolar SIZE 7,80 VALID dato1()
   ENDIF
   IF MaxEle2 > 0
      @ 12,0 GET ZS FROM vSoles SIZE 7,80 VALID dato2()
   ENDIF
   READ CYCLE
   IF LASTKEY() = Escape_
      EXIT
   ENDIF
   IF ok = 1
      XsCodCta = "10"+LEFT(vDolar(ZD),5)
      do SelMovCta
   ENDIF
   IF ok = 2
      XsCodCta = "10"+LEFT(vSoles(ZS),5)
      do SelMovCta
   ENDIF
ENDDO
CLOSE DATA
RETURN

***************
PROCEDURE dato1
***************
IF LastKey() = Enter
	OK = 1
	KEYB CHR(23)
ENDIF
RETURN .T.
***************
PROCEDURE dato2
***************
IF LastKey() = Enter
	OK = 2
	KEYB CHR(23)
ENDIF
RETURN .T.

*******************************************************************************
* Selecionar el Movimiento de la Cuenta
*******************************************************************************
PROCEDURE SelMovCta
*******************
PRIVATE Itm , XsNroMes , TsCodCta
CLEAR
XsNroMes      = RIGHT("00"+LTRIM(STR(_Mes,2,0)),2)
SELECT CTAS
SET ORDER TO CTAS01

SEEK XsCodCta
*** Pintando Pantalla ******
GsMsgKey  = "[T.Cursor] Seleccionar [Esc] Selecionar otro cuenta"
DO LIB_MTEC WITH 99
@ 0,0 SAY PADR(" "+TRIM(CodCta)+"  "+TRIM(NomCta),80)  COLOR SCHEME 7
LoContab.CBdacumd(CTAS->CodCta , 0 , _Mes)
IF oK = 1
	SdoAct = XvCalc(12)
	Cargos = XvCalc( 7)
	Abonos = XvCalc( 8)
	SdoIni = SdoAct - Cargos + Abonos
ELSE
	SdoAct = XvCalc( 6)
	Cargos = XvCalc( 1)
	Abonos = XvCalc( 2)
	SdoIni = SdoAct - Cargos + Abonos
ENDIF

@ 01,2 SAY Mes(_Mes,1)+" "+TRANS(_ANO,"9,999")
@ 01,40 SAY "SALDO INICIAL : "
@ 01,65 SAY TRANSF(ABS(SdoIni),"##,###,###.##")+IIF(SdoIni>=0," ","-")
@ 18,40 SAY "TOTAL ABONOS  : "
@ 18,65 SAY TRANSF(Cargos,"##,###,###.##")
@ 19,40 SAY "TOTAL CARGOS  : "
@ 19,65 SAY TRANSF(Abonos,"##,###,###.##")
@ 20,40 SAY "SALDO ACTUAL  : "
@ 20,65 SAY TRANSF(ABS(SdoAct),"##,###,###.##")+IIF(SdoAct>=0," ","-")
UltTecla = 0
SELECT RMOV
@ 21,0 CLEAR To 23,79
@ 21,0       To 23,79
SAVE SCREEN TO Temp2
nCodMon = 1
xKey1   = XsNroMES+XsCodCta
xKey2   = XsNroMES+XsCodCta
xLinReg = [" "+CODOPE+" "+NROAST+" "+NroDoc+" "+LEFT(GloDoc,28)+" "+xImport()]

xTITULO = "COMPROBAN.  DOCUMENTO  GLOSA                               ABONOS      CARGOS"
xTstLin = ""
DO WHILE .T.
	SET ORDER TO RMOV03
	DO BUSCA WITH "Add",xKEY1,xKEY2,xLINREG,xTITULO,02,0,16,80,xTSTLIN
	IF LASTKEY() = Escape_
		RETURN
	ENDIF
	RESTORE SCREEN FROM Temp2
	SELECT RMOV
ENDDO
*************
PROCEDURE ADD
*************
=SEEK(NROMES+CODOPE+NROAST,"VMOV")
@ 22,2  SAY "Girado : "+VMOV->Girado
@ 22,61 SAY "Fecha : "+DTOC(VMOV->FchAst)
RETURN
*******************************************************************************
PROCEDURE xImport
IF oK = 1
   XsImport = TRANS(IMPUSA,"99999,999.99")
ELSE
   XsImport = TRANS(IMPORT,"99999,999.99")
ENDIF
RETURN IIF(TPOMOV#"D",SPACE(11)+XsIMPORT,XsIMPORT+SPACE(11))
*******************************************************************************
* Selecionar el Movimiento de la Cuenta
*******************************************************************************
PROCEDURE SelAstCta
*******************
SELECT RMOV
SET ORDER TO RMOV01
XsCodOpe = RMOV->CodOpe
=SEEK(RMOV->CodOpe,"OPER")
xLLave  = RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst
nImpNac  = 0
nImpUsa  = 0
NroDec   = 2
SELECT VMOV
SEEK xLLave
DO MOVgPant IN CBDMMOVM
DO MOVPinta IN CBDMMOVM
SELECT RMOV
UltTecla = 0
SelLin   = ""
InsLin   = []
EscLin   = "bline"
EdiLin   = ""
BrrLin   = ""
GrbLin   = ""
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
Titulo   = []
NClave   = [NroMes+CodOpe+NroAst]
VClave   = xLLave
HTitle   = 1
Yo       = 10
Xo       = 0
Largo    = 21 - Yo
Ancho    = 80
TBorde   = Nulo
Titulo   = []
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .T.
Modifica = .F.
Adiciona = .F.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
SELECT RMOV
*** Variable a Conocer ****
XsCodCta = ""
XsCodRef = ""
XcTpoMov = ""
XsClfAux = 0.00
XsCodAux = 0.00
XfImport = 0.00
XiNroItm = 1
DO LIB_MTEC WITH 14
DO DBrowse
SELECT CTAS
RETURN
***************
PROCEDURE BLINE
***************
PARAMETER Contenido
DO MOVBLINE WITH Contenido IN CBDMMOVM
RETURN

*****************
PROCEDURE xGrabar  && grabamos temporal para saldos
*****************
SELECT tempo
SEEK STR(CnCodMon,1)+CsCodCta
IF !FOUND()
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	REPLACE CodMon WITH CnCodMon
	REPLACE CodCta WITH CsCodCta
	REPLACE NomCta WITH CsNomCta
	REPLACE SdoIni WITH XnSdoIni
	REPLACE Abonos WITH XnAbonos
	REPLACE Cargos WITH XnCargos
	REPLACE SdoAct WITH XnSdoAct
	UNLOCK ALL
ENDIF
RETURN

*********************
PROCEDURE xGrabar_Mov  && grabamos temporal para movimientos de una cuenta
*********************
SELECT TempoMov
APPEND BLANK
DO WHILE !RLOCK()
ENDDO
REPLACE CodOpe WITH MsCodOpe
REPLACE NroAst WITH MsNroAst
REPLACE NroDoc WITH MsNroDoc
REPLACE GloDoc WITH MsGloDoc
REPLACE FchAst WITH MdFchAst
REPLACE Girado WITH MsGirado
REPLACE AbonosMov WITH MnImporte_D
REPLACE CargosMov WITH MnImporte_H
UNLOCK ALL
