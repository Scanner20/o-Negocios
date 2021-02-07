**********************************************************************
*  Nombre        : cbdCONST.prg
*  Sistema       : Contabilidad
*  Autor         : Jorge Mieses
*  Proposito     : Consulta Contable
*  Creacion      : 17/06/93
*  Actualizacion :
***************************************************************************
**** Aperturando bases de datos ****
DO MOVAPERT IN CBDMMOVM
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
Key1   = ""
Key2   = ""
TstLin = ""
xNivel = 0
DO WHILE .T.
   DO PANTALLA
   SELECT CTAS
   PUSH KEY CLEAR
   ON KEY LABEL F3 DO xNivel
   ON KEY LABEL F5 DO xBusca
   TITULO = " CUENTA       NOMBRE                             "
   LinReg = [PADR(SPACE(NivCta)+CodCta,10)+" "+LEFT(NomCta,40)]
   Ancho = LEN(EVALUATE(LINREG))
   Xo    = 80 - Ancho
   DO BUSCA WITH "SELLIN",KEY1,KEY2,LINREG,TITULO,0,Xo,23,ANCHO,TSTLIN
   POP KEY
   IF LASTKEY() = 27
      EXIT
   ENDIF
   DO SELMESCTA
ENDDO
CLOSE DATA
RETURN

******************
PROCEDURE PANTALLA
******************
FOR I=0 TO 23
  @ I,0 SAY REPLICATE("°",80) COLOR SCHEME 7
ENDFOR
@ 0,1 SAY PADC(TRIM(GsNomCia),25) COLOR SCHEME 7
@ 1,1 SAY PADC(Mes(_Mes,1)+" "+TRANS(_ANO,"9999 "),25) COLOR SCHEME 7
@  3,0 FILL  TO 23,24 COLOR W+/N
@  2,1 CLEAR TO 22,25
@  2,1 TO 22,25
@ 12,2 TO 12,24
@  3,2 SAY "Movimiento del Mes"
@  4,2 SAY "       S/."
@  5,2 SAY "Cargo  "
@  6,2 SAY "Abono  "
@  7,2 SAY "Saldo  "
@  8,2 SAY "    US$."
@  9,2 SAY "Cargo"
@ 10,2 SAY "Abono"
@ 11,2 SAY "Saldo"
@ 13,2 SAY "Movimiento Acumulado"
@ 14,2 SAY "     S/."
@ 15,2 SAY "Cargo"
@ 16,2 SAY "Abono"
@ 17,2 SAY "Saldo"
@ 18,2 SAY "    US$."
@ 19,2 SAY "Cargo"
@ 20,2 SAY "Abono"
@ 21,2 SAY "Saldo"
@  2,1 FILL  TO 22,25 COLOR SCHEME 7
GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F3] Nivel"
DO LIB_MTEC WITH 99
RETURN

****************
PROCEDURE xBusca
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 14,1 CLEAR TO 20,24
@ 15,1,21,24 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 14,2 TO 20,24 DOUBLE
STORE SPACE(LEN(CodCta)) TO Desde,Hasta
@ 16,4  SAY "Desde : " GET Desde  PICT "@!S10"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S10"
READ
Ciclo = .F.
IF xNivel = 0
   Key1   = TRIM(Desde)
   Key2   = TRIM(Hasta)
ELSE
   Key1   = STR(xNivel,1)+TRIM(Desde)
   IF EMPTY(Hasta)
      Key2   = Key1
   ELSE
      Key2   = STR(xNivel,1)+TRIM(Hasta)
   ENDIF
ENDIF
POP KEY
RESTORE SCREEN
RETURN

****************
PROCEDURE xNivel
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 15,1 CLEAR TO 19,17
@ 16,1,20,16 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 15,2 TO 19,17 DOUBLE
@ 17,4  SAY "Nivel : " GET xNivel PICT "@Z #"
READ
IF xNivel = 0
   SET ORDER TO CTAS01
   Key1   = ""
   Key2   = ""
ELSE
   SET ORDER TO CTAS02
   Key1   = STR(xNivel,1)
   Key2   = STR(xNivel,1)
ENDIF
Ciclo = .F.
POP KEY
RESTORE SCREEN
RETURN

****************
PROCEDURE SELLIN
****************
DO CBDAcumd WITH CTAS->CodCta , 0 , _Mes
@  5,8 SAY XvCalc( 1)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@  6,8 SAY XvCalc( 2)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@  7,8 SAY XvCalc( 3)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@  9,8 SAY XvCalc( 7)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 10,8 SAY XvCalc( 8)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 11,8 SAY XvCalc( 9)    PICT "@( 999,999,999.99" COLOR SCHEME 7

@ 15,8 SAY XvCalc( 4)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 16,8 SAY XvCalc( 5)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 17,8 SAY XvCalc( 6)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 19,8 SAY XvCalc(10)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 20,8 SAY XvCalc(11)    PICT "@( 999,999,999.99" COLOR SCHEME 7
@ 21,8 SAY XvCalc(12)    PICT "@( 999,999,999.99" COLOR SCHEME 7
SELECT CTAS
RETURN

*******************************************************************************
* Seleccionar el mes a Analizar
*******************************************************************************
PROCEDURE SelMesCta
*******************
DO WHILE .T.
   SELECT CTAS
   GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Analizar [Esc] Selecionar otra cuenta"
   DO LIB_MTEC WITH 99
   cTit1 = GsNomCia
   cTit2 = "Usuario : "+TRIM(GsUsuario)
   cTit3 = "Fecha : "+DTOC(DATE())
   cTit4 = "Hora  : "+time()
   Do Fondo WITH cTit1,cTit2,cTit3,cTit4
   Lrgo  = _Mes+3
   @ 5,3   SAY "Cuenta : "+TRIM(CodCta)+"  "+TRIM(NomCta) Color scheme 7
   @ 6, 3  CLEAR TO 6+Lrgo,76
   @ 6, 3  FILL  TO 6+Lrgo,76 COLOR SCHEME 7
   @ 6, 3  TO 6+Lrgo,76  COLOR SCHEME 7
   @ 6, 17 TO 6+Lrgo,17  COLOR SCHEME 7
   @ 6, 36 TO 6+Lrgo,36  COLOR SCHEME 7
   @ 6, 55 TO 6+Lrgo,55  COLOR SCHEME 7
   @ 6,31 SAY "Cargo"    COLOR SCHEME 7
   @ 6,49 SAY "Abonos"   COLOR SCHEME 7
   @ 6,71 SAY "Saldo"    COLOR SCHEME 7
   TnMes = 0
   FOR TnMes = 0 TO _Mes
      TitMes = MES(TnMes , 3 )
      DO CBDAcumd WITH CTAS->CodCta , TnMes , TnMes
      @  7+TnMes,21 SAY XvCalc( 1)    PICT "@Z 999,999,999.99"  COLOR SCHEME 7
      @  7+TnMes,40 SAY XvCalc( 2)    PICT "@Z 999,999,999.99"  COLOR SCHEME 7
      @  7+TnMes,59 SAY XvCalc( 3)    PICT "@( 999,999,999.99"  COLOR SCHEME 7
   ENDFOR
   DO CBDAcumd WITH CTAS->CodCta , 0 , _Mes
   @  7+TnMes,4  SAY "Acumulado"                                COLOR SCHEME 7
   @  7+TnMes,21 SAY XvCalc( 4)    PICT "@Z 999,999,999.99"     COLOR SCHEME 7
   @  7+TnMes,40 SAY XvCalc( 5)    PICT "@Z 999,999,999.99"     COLOR SCHEME 7
   @  7+TnMes,59 SAY XvCalc( 6)    PICT "@( 999,999,999.99"     COLOR SCHEME 7
   FOR TnMes = 0 TO _Mes
      TitMes = MES(TnMes , 3 )
      @ 7+TnMes,4 PROMPT TitMes COLOR SCHEME 7
   ENDFOR
   MENU TO TnMes
   IF TnMes = 0
      EXIT
   ENDIF
   TnMes = TnMes - 1
   DO SelMovCta
ENDDO
SELECT CTAS
IF xNivel > 0
   SET ORDER TO CTAS02
ELSE
   SET ORDER TO CTAS01
ENDIF
RETURN


*******************************************************************************
* Selecionar el Movimiento de la Cuenta
*******************************************************************************
PROCEDURE SelMovCta
*******************
PRIVATE Itm , XsNroMes , TsCodCta
XsNroMes      = RIGHT("00"+LTRIM(STR(TnMes,2,0)),2)
SELECT RMOV
SET ORDER TO RMOV03
TsCodCta = CTAS->CodCta
SEEK XsNroMes+TRIM(TsCodCta)
IF ! FOUND()
   GsMsgErr = "Cuenta sin Movimientos"
   DO LIB_MERR WITH 99
   SELECT CTAS
   RETURN
ENDIF
IF RMOV->CodCta<>CTAS->CodCta
   DIMENSION CtaMov(1)
   CtaMov(1) = CodCta
   NumEle    = 1
   DO WHILE ! EOF() .AND. NroMes+CodCta=XsNroMes+TRIM(TsCodCta)
      IF CtaMov(NumEle) <> CodCta
         NumEle=NumEle+1
         DIMENSION CtaMov(NumEle)
         CtaMov(NumEle) = CodCta
      ENDIF
      SKIP
   ENDDO
   UltTecla = 0
   Itm = 1
   @ 13,65 GET Itm FROM CtaMov SIZE 10,12
   READ
   IF LASTKEY() = Escape
      SELECT CTAS
      RETURN
   ENDIF
   TsCodCta = CtaMov(Itm)
ENDIF
****** Listamos saldos por comites ******
DIMENSION vCodRef(1)
SELECT ACCT
SET ORDER TO ACCT01
Llave = STR(TnMes,2,0)+CTAS->CodCta
XiCodMon = 1
SEEK Llave
NumEle = 1
vCodRef(NumEle) = "Total-"
DO WHILE (NroMes+CodCta=Llave) .AND. ! EOF()
   NumEle=NumEle+1
   DIMENSION vCodRef(NumEle)
   vCodRef(NumEle) = CodRef
   SKIP
ENDDO
Itm = 1
@ 12,65 SAY "AUXILIARES" COLOR SCHEME 7
@ 13,65 GET Itm FROM vCodRef SIZE 10,12
READ
IF LASTKEY() = Escape
   SELECT CTAS
   RETURN
ENDIF
SELECT AUXI
IF Itm = 1
   XsCodRef = ""
   GOTO BOTTOM
   IF ! EOF()
      SKIP
   ENDIF
ELSE
   XsCodRef = vCodRef(Itm)
   IF CTAS->MayAux = "S"
      SEEK CTAS->ClfAux+LEFT(XsCodRef,LEN(AUXI->CODAUX))
   ELSE
      SEEK "001"+LEFT(XsCodRef,LEN(AUXI->CODAUX))
   ENDIF
ENDIF
SELECT CTAS
SET ORDER TO CTAS01
SEEK TsCodCta

*** Pintando Pantalla ******
GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Analizar [Esc] Selecionar otro mes"
DO LIB_MTEC WITH 99
@ 0,0 SAY PADR(" "+TRIM(CodCta)+"  "+TRIM(NomCta),80)  COLOR SCHEME 7
@ 1,0 SAY PADR(" "+TRIM(XsCodRef)+"  "+TRIM(Auxi->NomAux),80)  COLOR SCHEME 7
@ 2,0 CLEAR TO 8,79
@ 2,0  TO 8,79
@ 3,17 TO 7,17
@ 3,36 TO 7,36
@ 3,55 TO 7,55
@ 5,1  TO 5,78
@ 2,31 SAY "Cargo"
@ 2,49 SAY "Abonos"
@ 2,71 SAY "Saldo"
DO CBDAcumd WITH CTAS->CodCta , 0 , TnMes, XsCodRef
@ 3,2  SAY "Total Mes   S/."
@ 3,21 SAY XvCalc( 1)    PICT "@Z 999,999,999.99"
@ 3,40 SAY XvCalc( 2)    PICT "@Z 999,999,999.99"
@ 3,59 SAY XvCalc( 3)    PICT "@( 999,999,999.99"
@ 4,2  SAY "            US$"
@ 4,21 SAY XvCalc( 7)    PICT "@Z 999,999,999.99"
@ 4,40 SAY XvCalc( 8)    PICT "@Z 999,999,999.99"
@ 4,59 SAY XvCalc( 9)    PICT "@( 999,999,999.99"
@ 5,2 SAY Mes(TnMes,1)+" "+TRANS(_ANO,"9,999")
@ 6,2  SAY "Acumulado   S/."
@ 6,21 SAY XvCalc( 4)      PICT "@Z 999,999,999.99"
@ 6,40 SAY XvCalc( 5)      PICT "@Z 999,999,999.99"
@ 6,59 SAY XvCalc( 6)      PICT "@( 999,999,999.99"
@ 7,2  SAY "            US$"
@ 7,21 SAY XvCalc(10)      PICT "@Z 999,999,999.99"
@ 7,40 SAY XvCalc(11)      PICT "@Z 999,999,999.99"
@ 7,59 SAY XvCalc(12)      PICT "@( 999,999,999.99"
UltTecla = 0
SELECT RMOV
SAVE SCREEN TO Temp2
nCodMon = 1
xKey1   = XsNroMES+TsCodCta+XsCodRef
xKey2   = XsNroMES+TsCodCta+XsCodRef
xLinReg = [" "+CODOPE+" "+NROAST+" "+CODAUX+" "+NroDoc+" "+LEFT(GloDoc,26)+" "+IIF(TPOMOV#"D",SPACE(6)+TRANS(IMPORT,"99999,999.99"),TRANS(IMPORT,"99999,999.99")+SPACE(6))]
xTITULO = " OP. ASTO.  COD.AUX DOCUMENTO  GLOSA                       CARGO       ABONOS"
xTstLin = ""
DO WHILE .T.
   SET ORDER TO RMOV03
   DO BUSCA WITH "",xKEY1,xKEY2,xLINREG,xTITULO,09,0,15,80,xTSTLIN
   IF LASTKEY() = Escape
      RETURN
   ENDIF
   DO SelAstCta
   RESTORE SCREEN FROM Temp2
   =SEEK(TsCodCta,"CTAS")
   SELECT RMOV
ENDDO
*******************************************************************************
* Selecionar el Movimiento de la Cuenta
*******************************************************************************
PROCEDURE SelAstCta
*******************
TnLenGlo  = 12
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