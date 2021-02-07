SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoContab=CREATEOBJECT('Dosvr.Contabilidad')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoContab.oDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')

DO def_teclas IN FxGen_2

DO consulta

CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
LoConTab.odatadm.close_file('CJA')
RELEASE LoContab
******************
PROCEDURE consulta
******************

DO Fondo WITH 'Saldo en Bancos',GoEntorno.User.Login,GsNomcia,GsFecha



DIMENSION vSoles(20),vDolar(20)
CLEAR
@ 01,1 SAY "Cuentas en Dolares              ³  Sdo.Ini  ³  Abonos  ³  Cargos  ³   Saldo   " COLOR SCHEME 7

@ 09,21 SAY "TOTALES US$ "

@ 11,1 SAY "Cuentas en Soles                ³  Sdo.Ini  ³  Abonos  ³  Cargos  ³   Saldo   " COLOR SCHEME 7

@ 19,21 SAY "TOTALES S/. "
@ 20,21 SAY "TOTALES US$ "
@ 21,1 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 22,1 SAY "³             TOTAL GENERAL US$ ³           ³          ³          ³           ³"
@ 23,1 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"



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
***************
PROCEDURE CARGA
***************
**** CARGANDO CUENTAS EN DOLARES ***
SELECT CTAS
cCodCta1 = "101"
cCodCta2 = "104"
cCodCta3 = "108"
MaxEle1  = 0
MaxEle2  = 0
SEEK cCodCta1
DfSdoIni = 0
DfCargos = 0
DfAbonos = 0
DfSaldos = 0

SfSdoIni = 0
SfCargos = 0
SfAbonos = 0
SfSaldos = 0

DO WHILE CodCta<=cCodCta3 .AND. ! EOF()
   IF ! (INLIST(CodCta,cCodCta1,cCodCta2,cCodCta3) .AND. AFTMOV="S")
      SKIP
      LOOP
   ENDIF
   LoContab.CBdacumd(CTAS->CodCta , 0 , _Mes)

   IF CTAS->CodMon = 2
      SdoAct = ROUND(XvCalc(12),0)
      Cargos = ROUND(XvCalc( 7),0)
      Abonos = ROUND(XvCalc( 8),0)
      SdoIni = SdoAct - Cargos + Abonos
      DfSdoIni = DfSdoIni + SdoIni
      DfCargos = DfCargos + Cargos
      DfAbonos = DfAbonos + Abonos
      DfSaldos = DfSaldos + SDOAct

      MaxEle1 = MaxEle1 + 1
      IF MaxEle1 > ALEN(vDolar)
         DIMENSION vDolar(MaxEle1+10)
      ENDIF
      vDolar(MaxEle1) = PADR(SUBSTR(CTAS->CODCTA,3)+" "+CTAS->NOMCTA,31)+"Û"
      vDolar(MaxEle1) = vDolar(MaxEle1) + TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," Û","-Û")
      vDolar(MaxEle1) = vDolar(MaxEle1) + TRANSF(Cargos,"@Z ##,###,###")+"Û"
      vDolar(MaxEle1) = vDolar(MaxEle1) + TRANSF(Abonos,"@Z ##,###,###")+"Û"
      vDolar(MaxEle1) = vDolar(MaxEle1) + TRANSF(ABS(SdoAct),"@Z ##,###,###")+IIF(SdoAct>=0," Û","-Û")
   ELSE
      SdoAct = ROUND(XvCalc( 6),0)
      Cargos = ROUND(XvCalc( 1),0)
      Abonos = ROUND(XvCalc( 2),0)
      SdoIni = SdoAct - Cargos + Abonos
      SfSdoIni = SfSdoIni + SdoIni
      SfCargos = SfCargos + Cargos
      SfAbonos = SfAbonos + Abonos
      SfSaldos = SfSaldos + SDOAct
      MaxEle2 = MaxEle2 + 1
      IF MaxEle2 > ALEN(vSoles)
         DIMENSION vSoles(MaxEle2+10)
      ENDIF
      vSoles(MaxEle2) = PADR(SUBSTR(CTAS->CODCTA,3)+" "+CTAS->NOMCTA,31)+"Û"
      vSoles(MaxEle2) = vSoles(MaxEle2) + TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," Û","-Û")
      vSoles(MaxEle2) = vSoles(MaxEle2) + TRANSF(Cargos,"@Z ##,###,###")+"Û"
      vSoles(MaxEle2) = vSoles(MaxEle2) + TRANSF(Abonos,"@Z ##,###,###")+"Û"
      vSoles(MaxEle2) = vSoles(MaxEle2) + TRANSF(ABS(SdoAct),"@Z ##,###,###")+IIF(SdoAct>=0," Û","-Û")
   ENDIF
   SKIP
ENDDO
IF MaxEle1 > 0
   DIMENSION vDolar(MaxEle1)
ENDIF
IF MaxEle2 > 0
   DIMENSION vSoles(MaxEle2)
ENDIF

SdoIni = DfSdoIni
Cargos = DfCargos
Abonos = DfAbonos
SDOAct = DfSaldos
@  9,34 SAY TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," ","-") COLOR SCHEME 7
@  9,46 SAY TRANSF(Cargos,"@Z ##,###,###") COLOR SCHEME 7
@  9,57 SAY TRANSF(Abonos,"@Z ##,###,###") COLOR SCHEME 7
@  9,68 SAY TRANSF(ABS(SdoAct),"@Z #,####,###")+IIF(SdoAct>=0," ","-") COLOR SCHEME 7

SdoIni = SfSdoIni
Cargos = SfCargos
Abonos = SfAbonos
SDOAct = SfSaldos
@ 19,34 SAY TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," ","-") COLOR SCHEME 7
@ 19,46 SAY TRANSF(Cargos,"@Z ##,###,###") COLOR SCHEME 7
@ 19,57 SAY TRANSF(Abonos,"@Z ##,###,###") COLOR SCHEME 7
@ 19,68 SAY TRANSF(ABS(SdoAct),"@Z #,####,###")+IIF(SdoAct>=0," ","-") COLOR SCHEME 7
SdoIni = ROUND(SfSdoIni/XfTpoCmb,0)
Cargos = ROUND(SfCargos/XfTpoCmb,0)
Abonos = ROUND(SfAbonos/XfTpoCmb,0)
SDOAct = ROUND(SfSaldos/XfTpoCmb,0)
@ 20,34 SAY TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," ","-") COLOR SCHEME 7
@ 20,46 SAY TRANSF(Cargos,"@Z ##,###,###") COLOR SCHEME 7
@ 20,57 SAY TRANSF(Abonos,"@Z ##,###,###") COLOR SCHEME 7
@ 20,68 SAY TRANSF(ABS(SdoAct),"@Z #,####,###")+IIF(SdoAct>=0," ","-") COLOR SCHEME 7
SdoIni = ROUND(SfSdoIni/XfTpoCmb,0)+DfSdoIni
Cargos = ROUND(SfCargos/XfTpoCmb,0)+DfCargos
Abonos = ROUND(SfAbonos/XfTpoCmb,0)+DfAbonos
SDOAct = ROUND(SfSaldos/XfTpoCmb,0)+DfSaldos
@ 22,34 SAY TRANSF(ABS(SdoIni),"@Z ##,###,###")+IIF(SdoIni>=0," ","-") COLOR SCHEME 7
@ 22,46 SAY TRANSF(Cargos,"@Z ##,###,###") COLOR SCHEME 7
@ 22,57 SAY TRANSF(Abonos,"@Z ##,###,###") COLOR SCHEME 7
@ 22,68 SAY TRANSF(ABS(SdoAct),"@Z #,####,###")+IIF(SdoAct>=0," ","-") COLOR SCHEME 7
RETURN

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
*******************************************************************************
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
