********************************************************************************
*  Nombre        : cjaliqui.PRG                                                *
*  Sistema       : CAJA BANCOS                                                 *
*  Autor         : RHC                                                         *
*  Proposito     : Liquidacion de Cobranzas                                    *
*  Creacion      : 07/10/94                                                    *
*  Actualizacion : 07/11/94 VETT                                               *
********************************************************************************
lSimple = .F.
XsClfAux = [02 ]  && Clientes
** Pintamos Pantalla **
DO xPanta
** abrimos bases de datos **
CLOSE DATA
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbtbdoc IN 0 ORDER BDOC01  ALIAS TDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbrgdoc IN 0 ORDER GDOC01 ALIAS GDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE CCBMVTOS IN 0 ORDER VTOS01 ALIAS RMOV
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE cjavmovm IN 0 ORDER VMOV01 ALIAS VMOV
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE CBDMCTAS IN 0 ORDER CTAS01 ALIAS CTAS
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
SELE CTAS
SET FILTER TO AFTMOV="S"
**
USE CBDMTABL IN 0 ORDER TABL01 ALIAS TABL
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
**
USE admmtcmb IN 0 ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** relaciones a usar **
SELE RMOV
SET RELA TO XsClfAux+CodCli INTO CLIE
** variables del sistema **
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XfTpoCmb,XcFlgEst
PRIVATE XfEfeNac,XfChqNac,XfEfeUSa,XfChqUsa
PRIVATE m.NroDoc
XsCodDoc = [L/C ]
XcFlgEst = [E]
STORE [] TO XsNroDoc,XdFchDoc,XfTpoCmb,m.NroDoc
STORE [] TO XfEfeNac,XfChqNac,XfEfeUSa,XfChqUsa
** variables del Browse **
PRIVATE XsTpoRef,XsCodRef,XsNroRef,XfImport,XsCodCli,XiCodMon,XiFmaPgo
PRIVATE XsCodBco,XsNroChq
STORE [Cargo] TO XsTpoRef
STORE []      TO XsCodRef,XsNroRef,XfImport,XsCodCli,XiCodMon,XiFmaPgo
STORE []      TO XsCodBco,XsNroChq
** Logica principal **
SELE VMOV
UltTecla = 0
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
xCodDoc = XsCodDoc
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'xImprime',[CodDoc],xCodDoc,'CMAR'
CLOSE DATA

RETURN
********************************************************************** EOP() *
* Objeto : Pintado de Pantalla
******************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7
*001234567890123456789012345678901234567890123456789012345678901234567890123456789
*0   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*1   ³    Liquidaci¢n : 123456                           Del Dia : 99/99/99  ³
*2   ³       Cobrador : 12 123456789012345678901234567890                    ³
*3   ³ Tipo de Cambio : 9,999.9999                                           ³
*4   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*5ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6³                          Forma de                       Saldo a    Importe   ³
*7³ Doc.   N£mero  Iniciales   Pago   Bco. Cheque    Mon     Pagar    Cancelado  ³
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9³ FACT 123-456789 12345678 Efectivo 123 1234567890 S/. 9999,999.99 9999,999.99 ³
*0³                                                                              ³
*1³                                                                              ³
*2³                                                                              ³
*3³                                                                              ³
*4³                                                                              ³
*5³                                                                              ³
*6³                                                                              ³
*7³                                                                              ³
*8³ FACT 123-456789 12345678 Efectivo 123 1234567890 S/. 9999,999.99 9999,999.99 ³
*9ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0³         TOTALES > Efectivo S/. 999,999,999.99   US$ 999,999,999.99           ³
*1³                 > Cheques  S/. 999,999,999.99   US$ 999,999,999.99           ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*001234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7

CLEAR

@  0,3  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  1,3  SAY "³    Liquidaci¢n :                                  Del Dia :           ³"
@  2,3  SAY "³       Cobrador :                                                      ³"
@  3,3  SAY "³ Tipo de Cambio :                                                      ³"
@  4,3  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@  5,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,0  SAY "³                          Forma de                       Saldo a    Importe   ³"
@  7,0  SAY "³ Doc.   N£mero  Iniciales   Pago   Bco. Cheque    Mon     Pagar    Cancelado  ³"
@  8,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  9,0  SAY "³                                                                              ³"
@ 10,0  SAY "³                                                                              ³"
@ 11,0  SAY "³                                                                              ³"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "³                                                                              ³"
@ 19,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 20,0  SAY "³         TOTALES > Efectivo S/.                  US$                          ³"
@ 21,0  SAY "³                 > Cheques  S/.                  US$                          ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
Titulo = [ ** LIQUIDACION DE COBRANZAS A CLIENTES ** ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  6,1  FILL TO 7,78 COLOR SCHEME 7
@ 20,1  FILL TO 21,78 COLOR SCHEME 7

RETURN
********************************************************************** FIN() *
* Objeto : Poner datos en pantalla
******************************************************************************
PROCEDURE xPoner

@  1,22 SAY NroDoc
@  1,65 SAY FchDoc
@  3,22 SAY TpoCmb PICT '9,999.999'
**
@ 9,1 CLEAR TO 18,78
IF FlgEst = [A]
   @ 10,15 SAY "  ###   #    # #   # #      ###   ####   #####"
   @ 11,15 SAY " #   #  # #  # #   # #     #   #  #   #  #   #"
   @ 12,15 SAY "####### #  # # #   # #    ####### #    # #   #"
   @ 13,15 SAY "#     # #   ## #   # #    #     # #   #  #   #"
   @ 14,15 SAY "#     # #    # ##### #### #     # ####   #####"
ENDIF
NumLin = 9
SET ORDER TO GDOC01 IN GDOC
SELE RMOV
SEEK VMOV->CodDoc+VMOV->NroDoc
SCAN WHILE CodDoc+NroDoc = VMOV->CodDoc+VMOV->NroDoc
   =SEEK(TpoRef+CodRef+NroRef,"GDOC")
   IF NumLin <= 18
      @ NumLin,2  SAY CodRef
      @ NumLin,7  SAY NroRef PICT "@R 999-"+REPLI("9",LEN(NroRef))
      @ NumLin,18 SAY CLIE->IniAux
      @ NumLin,27 SAY cja_pgo(FmaPgo)
      @ NumLin,36 SAY CodBco
      @ NumLin,40 SAY NroChq
      @ NumLin,51 SAY IIF(CodMon=1,'S/.','US$')
      IF CodMon = GDOC->CodMon
         @ NumLin,55 SAY GDOC->SdoDoc PICT "9999,999.99"
      ELSE
         IF CodMon = 1
            @ NumLin,55 SAY GDOC->SdoDoc*TpoCmb PICT "9999,999.99"
         ELSE
            @ NumLin,55 SAY GDOC->SdoDoc/TpoCmb PICT "9999,999.99"
         ENDIF
      ENDIF
      @ NumLin,67 SAY Import PICT "9999,999.99"
      NumLin = NumLin + 1
   ENDIF
ENDSCAN
**
SELE VMOV
@  20,33 SAY EfeNac PICT "999,999,999.99" COLOR SCHEME 7
@  20,54 SAY EfeUsa PICT "999,999,999.99" COLOR SCHEME 7
@  21,33 SAY ChqNac PICT "999,999,999.99" COLOR SCHEME 7
@  21,54 SAY ChqUsa PICT "999,999,999.99" COLOR SCHEME 7

RETURN

********************************************************************** FIN() *
* Objeto : Llave de acceso
******************************************************************************
PROCEDURE xLlave

** Control Correlativo **
SELE TDOC
SEEK XsCodDoc
IF !FOUND()
   GsMsgErr = [ No existe Correlativo ]
   DO lib_merr WITH 99
   UltTecla = Escape
   RETURN
ENDIF
XsNroDoc = PADL(ALLTRIM(STR(NroDoc)),LEN(VMOV->NroDoc),'0')
m.NroDoc = XsNroDoc
*
UltTecla = 0
i = 1
SELE VMOV
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1
         @  1,22 GET XsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF ! cjabusca("0001")
               LOOP
            ENDIF
            XsNroDoc = NroDoc
         ENDIF
         @ 1,22 SAY XsNroDoc
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
SEEK XsCodDoc+XsNroDoc

RETURN
********************************************************************** FIN() *
* Objeto : Tomar datos adicionales
******************************************************************************
PROCEDURE xTomar

Crear = .T.
IF &RegVal.
   IF FlgEst = [A]
      GsMsgErr = [Documento Anulado]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF ! RLOCK()
      RETURN
   ENDIF
   Crear = .F.
   DO xMover
   * va directo al browse de cancelacion *
   UltTecla = Enter
ELSE
   DO xInvar
   UltTecla = 0
ENDIF
*
@  1,65 GET XdFchDoc DISABLE
@  3,22 GET XfTpoCmb PICT "9,999.999"DISABLE
*
i = 1
DO WHILE ! INLIST(UltTecla,Escape) .AND. Crear
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
         @  1,65 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         IF SEEK(DTOS(XdFchDoc),"TCMB")
            XfTpoCmb = TCMB->OfiVta
         ENDIF
         @  3,22 GET XfTpoCmb PICT "9,999.999" VALID(XfTpoCmb>0)
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE VMOV
IF UltTecla # Escape
   DO xGraba
   lsimple = .T.
   DO xImprime
   lsimple = .F.
ENDIF
SELE VMOV
UNLOCK ALL

RETURN
********************************************************************** FIN() *
* Objeto : Cargar Variables
******************************************************************************
PROCEDURE xMover

SELE VMOV
XsNroDoc = VMOV->NroDoc
XdFchDoc = VMOV->FchDoc
XfTpoCmb = VMOV->TpoCmb
XcFlgEst = VMOV->FlgEst

RETURN
********************************************************************** FIN() *
* Objeto : Inicializa variables
******************************************************************************
PROCEDURE xInvar

XsCodDoc = [L/C ]
XdFchDoc = DATE()
XfTpoCmb = 0.00
XcFlgEst = [E]

RETURN
********************************************************************** FIN() *
* Objeto : Grabar Cabecera
******************************************************************************
PROCEDURE xGraba

SELE VMOV
IF Crear
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   STORE RECNO() TO iRECNO
   ** control del correlativo **
   SELE TDOC
   SEEK XsCodDoc
   IF ! RLOCK()
      RETURN
   ENDIF
   IF m.NroDoc = XsNroDoc
      XsNroDoc = PADR(RIGHT("000000000"+ALLTRIM(STR(NroDoc)),9),LEN(VMOV->NroDoc))
      ** verificamos su existencia **
      IF SEEK(XsCodDoc+XsNroDoc,"VMOV")
         GsMsgErr = [Registro creado por otro usuario]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      REPLACE NroDoc WITH NroDoc+1
   ELSE
      ** verificamos su existencia **
      IF SEEK(XsCodDoc+XsNroDoc,"VMOV")
         GsMsgErr = [Registro creado por otro usuario]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      IF XsNroDoc>=m.NroDoc
         REPLACE NroDoc WITH VAL(XsNroDoc)+1
      ENDIF
   ENDIF
   UNLOCK
   ** fin de control de correlativo **
   SELE VMOV
   GO iRECNO
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   @ 1,22 SAY XsNroDoc
ENDIF
REPLACE FchDoc WITH XdFchDoc
REPLACE TpoCmb WITH XfTpoCmb
REPLACE FlgEst WITH XcFlgEst
** Browse de cancelacion **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .T.
DB_Pinta = .F.
** recalculamos el importe total **
SELE RMOV
STORE 0 TO XfEfeNac,XfChqNac,XfEfeUsa,XfChqUsa
SEEK VMOV->CodDoc+VMOV->NroDoc
SCAN WHILE CodDoc+NroDoc=VMOV->CodDoc+VMOV->NroDoc
   IF CodMon = 1
      DO CASE
         CASE FmaPgo = 1   && Efectivo
            XfEfeNac = XfEfeNac + Import
         CASE FmaPgo = 2   && Cheque
            XfChqNac = XfChqNac + Import
      ENDCASE
   ELSE
      DO CASE
         CASE FmaPgo = 1   && Efectivo
            XfEfeUsa = XfEfeUsa + Import
         CASE FmaPgo = 2   && Cheque
            XfChqUSa = XfChqUsa + Import
      ENDCASE
   ENDIF
ENDSCAN
@  20,33 SAY XfEfeNac PICT "999,999,999.99" COLOR SCHEME 7
@  21,54 SAY XfEfeUsa PICT "999,999,999.99" COLOR SCHEME 7
@  21,33 SAY XfChqNac PICT "999,999,999.99" COLOR SCHEME 7
@  21,54 SAY XfChqUsa PICT "999,999,999.99" COLOR SCHEME 7
DO LIB_MTEC WITH 14
DO xBrowse
* * * *
SELE VMOV
REPLACE EfeNac WITH XfEfeNac
REPLACE EfeUsa WITH XfEfeUsa
REPLACE ChqNac WITH XfChqNac
REPLACE ChqUsa WITH XfChqUsa

RETURN
********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = "MOVbline"
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [CodDoc+NroDoc]
VClave   = VMOV->CodDoc+VMOV->NroDoc
HTitle   = 1
Yo       = 8
Xo       = 0
Largo    = 12
Ancho    = 80
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .F.
VSombra  = .F.
**
SELE RMOV
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Escribe la linea
******************************************************************************
PROCEDURE MOVbline
PARAMETER Cadena

SET ORDER TO GDOC01 IN GDOC
=SEEK(XsTpoRef+CodRef+NroRef,"GDOC")
iSdoDoc = GDOC->SdoDoc
SELE RMOV
IF CodMon#GDOC->CodMon
   IF CodMon = 1
      iSdoDoc = ROUND(GDOC->SdoDoc*TpoCmb,2)
   ELSE
      iSdoDoc = ROUND(GDOC->SdoDoc/TpoCmb,2)
   ENDIF
ENDIF
Cadena = CodRef+' '+TRANS(NroRef,'@R 999-'+REPLI('9',LEN(NroRef)-3))+' '+CLIE->IniAux+' '
Cadena = Cadena+cja_pgo(FmaPgo)+' '+CodBco+' '+NroChq+' '+IIF(CodMon=1,'S/.','US$')+' '
Cadena = Cadena+TRANS(iSdoDoc,'9999,999.99')+' '+TRANS(Import,'9999,999.99')

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit

SELE RMOV
** OJO >> Solo se permite Crear **
XsCodCli = SPACE(LEN(RMOV->CodCli))
XsCodRef = SPACE(LEN(RMOV->CodRef))
XsNroRef = SPACE(LEN(RMOV->NroRef))
XiFmaPgo = 1
XiCodMon = 1
XfImport = 0.00
XsCodBco = SPACE(LEN(RMOV->CodBco))
XsNroChq = SPACE(LEN(RMOV->NroChq))
*
STORE 0 TO m.SdoDoc     && Control de Saldo
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [] Anterior  [Enter] Registra"
         DO lib_mtec WITH 99
         SELE TDOC
         @ LinAct,2  GET XsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodRef)
            SET FILTER TO TpoDoc = XsTpoRef
            IF ! ccbbusca("TDOC")
               SET FILTER TO
               LOOP
            ENDIF
            XsCodRef = TDOC->CodDoc
            SET FILTER TO
         ENDIF
         @ LinAct,2  SAY XsCodRef
         SEEK XsCodRef
         IF ! FOUND() .OR. TpoDoc # XsTpoRef
            DO lib_merr WITH 6
            UltTecla = 0
            LOOP
         ENDIF
      CASE i = 2
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [] Anterior  [Enter] Registra"
         DO lib_mtec WITH 99
         SELE GDOC
         SET ORDER TO GDOC05
         @ LinAct,7  GET XsNroRef PICT "@R 999-"+REPLI("9",LEN(XsNroRef)-3)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroRef)
            IF ! cjabusca("0012")
               LOOP
            ENDIF
            XsNroRef = NroDoc
         ENDIF
         @ LinAct,7  SAY XsNroRef PICT "@R 999-"+REPLI("9",LEN(XsNroRef)-3)
         SEEK [P]+XsTpoRef+XsCodRef+XsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         XsCodCli = CodCli
         m.SdoDoc = SdoDoc
         @ LinAct,18 SAY CLIE->IniAux
      CASE i = 3
         DO LIB_MTEC WITH 16
         VecOpc(1)="Efectivo"
         VecOpc(2)="Cheque  "
         XiFmaPgo= Elige(XiFmaPgo,LinAct,27,2)
      CASE i = 4 .AND. XiFmaPgo = 2
         SELE TABL
         XsTabla = "04"
         @ LinAct,36 GET XsCodBco PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,BackTab,Izquierda,Escape)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodBco)
            IF !cjabusca("TABL")
               LOOP
            ENDIF
            XsCodBco = LEFT(Codigo,3)
         ENDIF
         @ LinAct,36 SAY XsCodBco PICT "@!"
         SEEK XsTabla+XsCodBco
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF

      CASE i = 5 .AND. XiFmaPgo = 2
         @ LinAct,40 GET XsNroChq PICT "@!"
         READ
         UltTecla = LASTKEY()
         @ LinAct,40 SAY XsNroChq PICT "@!"

      CASE i = 6
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,LinAct,51,2)
      CASE i = 7
         IF XiCodMon # GDOC->CodMon
            IF XiCodMon = 1
               m.SdoDoc = ROUND(m.SdoDoc*XfTpoCmb,2)
            ELSE
               m.SdoDoc = ROUND(m.SdoDoc/XfTpoCmb,2)
            ENDIF
         ENDIF
         XfImport = m.SdoDoc
         @ LinAct,55 SAY m.SdoDoc PICT "9999,999.99"
         @ LinAct,67 GET XfImport PICT "9999,999.99" VALID(XfImport>=0.AND.XfImport<=m.SdoDoc)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>7, 7, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT RMOV
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE MOVbgrab

** SOLO EXISTE CREAR MAS NO MODIFICAR **
SELE GDOC
SET ORDER TO GDOC01
SEEK XsTpoRef+XsCodRef+XsNroRef
IF ! RLOCK()
   SELE RMOV
   RETURN
ENDIF
**
SELE RMOV
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
REPLACE CodDoc WITH XsCodDoc
REPLACE NroDoc WITH XsNroDoc
REPLACE FchDoc WITH XdFchDoc
REPLACE CodCli WITH XsCodCli
REPLACE CodMon WITH XiCodMon
REPLACE FmaPgo WITH XiFmaPgo
REPLACE TpoCmb WITH XfTpoCmb
REPLACE TpoRef WITH XsTpoRef
REPLACE CodRef WITH XsCodRef
REPLACE NroRef WITH XsNroRef
REPLACE Import WITH XfImport
REPLACE CodBco WITH XsCodBco
REPLACE NroChq WITH XsNroChq
UNLOCK
** actualizamos documento **
SELE GDOC
m.Import = XfImport
IF CodMon # XiCodMon
   IF CodMon = 1
      m.Import = ROUND(m.Import*XfTpoCmb,2)
   ELSE
      m.Import = ROUND(m.Import/XfTpoCmb,2)
   ENDIF
ENDIF
REPLACE SdoDoc WITH SdoDoc-m.Import
IF SdoDoc <= 0.01
   REPLACE FlgEst WITH [C]
ENDIF
REPLACE FchAct WITH DATE()
UNLOCK
**
SELE RMOV
IF CodMon = 1
   DO CASE
      CASE FmaPgo = 1   && Efectivo
         XfEfeNac = XfEfeNac + Import
      CASE FmaPgo = 2   && Cheque
         XfChqNac = XfChqNac + Import
   ENDCASE
ELSE
   DO CASE
      CASE FmaPgo = 1   && Efectivo
         XfEfeUsa = XfEfeUsa + Import
      CASE FmaPgo = 2   && Cheque
         XfChqUSa = XfChqUsa + Import
   ENDCASE
ENDIF
@  20,33 SAY XfEfeNac PICT "999,999,999.99" COLOR SCHEME 7
@  20,54 SAY XfEfeUsa PICT "999,999,999.99" COLOR SCHEME 7
@  21,33 SAY XfChqNac PICT "999,999,999.99" COLOR SCHEME 7
@  21,54 SAY XfChqUsa PICT "999,999,999.99" COLOR SCHEME 7

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE MOVbborr

SELE RMOV
IF !RLOCK()
   RETURN
ENDIF
**
SELE GDOC
SET ORDER TO GDOC01
SEEK RMOV->TpoRef+RMOV->CodRef+RMOV->NroRef
IF ! RLOCK()
   SELE RMOV
   RETURN
ENDIF
**
m.Import = RMOV->Import
IF CodMon # RMOV->CodMon
   IF CodMon = 1
      m.Import = ROUND(m.Import*RMOV->TpoCmb,2)
   ELSE
      m.Import = ROUND(m.Import/RMOV->TpoCmb,2)
   ENDIF
ENDIF
REPLACE SdoDoc WITH SdoDoc + m.Import
IF SdoDoc > 0
   REPLACE FlgEst WITH [P]
ENDIF
REPLACE FchAct WITH DATE()
UNLOCK
**
SELE RMOV
IF CodMon = 1
   DO CASE
      CASE FmaPgo = 1   && Efectivo
         XfEfeNac = XfEfeNac - Import
      CASE FmaPgo = 2   && Cheque
         XfChqNac = XfChqNac - Import
   ENDCASE
ELSE
   DO CASE
      CASE FmaPgo = 1   && Efectivo
         XfEfeUsa = XfEfeUsa - Import
      CASE FmaPgo = 2   && Cheque
         XfChqUSa = XfChqUsa - Import
   ENDCASE
ENDIF
@  20,33 SAY XfEfeNac PICT "999,999,999.99" COLOR SCHEME 7
@  20,54 SAY XfEfeUsa PICT "999,999,999.99" COLOR SCHEME 7
@  21,33 SAY XfChqNac PICT "999,999,999.99" COLOR SCHEME 7
@  21,54 SAY XfChqUsa PICT "999,999,999.99" COLOR SCHEME 7
DELETE
UNLOCK

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE xBorrar

SELE VMOV
IF FlgEst = [A]
   GsMsgErr = [Documento Anulado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst # [E]
   GsMsgErr = [Acceso Denegado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
* borramos detalle *
SELE RMOV
SEEK VMOV->CodDoc+VMOV->NroDoc
DO WHILE !EOF() .AND. CodDoc+NroDoc = VMOV->CodDoc+VMOV->NroDoc
   IF ! RLOCK()
      LOOP
   ENDIF
   SELE GDOC
   SET ORDER TO GDOC01
   SEEK XsTpoRef+RMOV->CodRef+RMOV->NroRef
   IF ! RLOCK()
      SELE RMOV
      LOOP
   ENDIF
   **
   m.Import = RMOV->Import
   IF CodMon # RMOV->CodMon
      IF CodMon = 1
         m.Import = ROUND(m.Import*RMOV->TpoCmb,2)
      ELSE
         m.Import = ROUND(m.Import/RMOV->TpoCmb,2)
      ENDIF
   ENDIF
   REPLACE SdoDoc WITH SdoDoc + m.Import
   IF SdoDoc > 0
      REPLACE FlgEst WITH [P]
   ENDIF
   REPLACE FchAct WITH DATE()
   UNLOCK
   **
   SELE RMOV
   DELETE
   UNLOCK
   SKIP
ENDDO
SELE VMOV
REPLACE FlgEst WITH [A]
REPLACE ImpDoc WITH 0
UNLOCK ALL
RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n del documento
******************************************************************************
PROCEDURE xImprime
******************
PRIVATE Titulo,Ancho,Largo,SubTitulo
IF EOF()
   GO TOP
ENDIF
STORE  0 TO XfChqNac,XfChqUsa,XfEfeNac,XfEfeUsa
LsDesde = VMOV->NroDoc
LsHasta = VMOV->NroDoc
LdDesde = VMOV->FchDoc
LdHasta = VMOV->FchDoc
SAVE SCREEN TO XTemp
IF !lSimple
    XiTpoRep = 1
    @  9,10 FILL  TO 15,68      COLOR W/N
    @  9,12 CLEAR TO 13,68
    @  8,11       TO 14,69
    @ 10,31 PROMPT "ORDENADO POR NUMERO"
    @ 11,31 PROMPT "ORDENADO POR FECHA "
    MENU TO XiTpoRep
    IF LastKey() = Escape .OR. XiTpoRep = 0
       RETURN
    ENDIF
    @ 12,24 CLEAR TO 16,56
    @ 12,24 FILL  TO 16,56 COLOR W/N
    @ 12,24       TO 16,56 DOUBLE
    @ 13,25 SAY "DESDE :"
    @ 14,25 SAY "HASTA :"
    ULTTECLA = 0
    I = 1
    DO WHILE !INLIST(ULTTECLA,ESCAPE,CTRLW,F10)
       DO CASE
          CASE I = 1 .AND. XiTpoRep = 1
               SET ORDER TO VMOV01
               @ 13,32 GET LsDesde PICT "@!"
               @ 14,32 GET LsHasta PICT "@!"
               READ
               UltTecla = LASTKEY()
          CASE I = 1 .AND. XiTpoRep = 2
               SET ORDER TO VMOV02
               @ 13,32 GET LdDesde
               @ 14,32 GET LdHasta
               READ
               UltTecla = LASTKEY()
         *CASE I = 2
         *     VECOPC(1) = " RESUMIDO  "
         *     VECOPC(2) = " DETALLADO "
         *    XiForma = Elige(XiForma,15,32,2)
       ENDCASE
       IF i = 1 .AND. UltTecla = Enter
          EXIT
       ENDIF
       i = IIF(UltTecla=Arriba,i-1,i+1)
       i = IIF(i<1,1,i)
       i = IIF(i>1,1,i)
    ENDDO
    IF LASTKEY() = Escape
       SELE VMOV
       SET ORDER TO VMOV01
       RESTORE SCREEN FROM xTemp
       RETURN
    ENDIF
    LsHasta = LEFT(TRIM(LsHasta)+"zzzzzzzzzz",LEN(VMOV->NroDoc))

    *** Configuraci¢n de las Impresiones ***
    DO admprint
    IF XiTpoRep = 1
       XsTstImp = [VMOV->NroDoc<=LsHasta]
       LsLlave  = VMOV->CodDoc+TRIM(LsDesde)
    ELSE
       XsTstImp = [VMOV->FchDoc<=LdHasta]
       LsLlave  = XsCodDoc+TRIM(DTOS(LdDesde))
    ENDIF
ELSE
    DO DIRPRINT IN ADMPRINT
    XsTstImp = [VMOV->NroDoc=LsDesde]
    LsLlave  = VMOV->CodDoc+TRIM(LsDesde)
ENDIF
UltTecla = LASTKEY()
IF UltTecla = Escape
   SELE VMOV
   SET ORDER TO VMOV01
   RESTORE SCREEN FROM xTemp
   RETURN
ENDIF
IniImp   = _Prn1
NumPag   = 0
Largo    = 36
Ancho    = 80
IF lSimple
   cE1=[                          Forma de                       Saldo a    Importe   ]
   cE2=[ Doc.   N£mero  Iniciales   Pago   Bco. Cheque    Mon     Pagar    Cancelado  ]
ELSE
   IniImp    = _Prn3
   Largo     = 66
   Ancho     = 128
   Titulo    = [LIQUIDACION DE COBRANZAS A CLIENTES]
   SubTitulo = [DEL :]+LsDesde +[ AL :]+LsHasta
   IF XiTpoRep = 2
      SubTitulo = [DEL :]+DTOC(LdDesde) +[ AL :]+DTOC(LdHasta)
   ENDIF
   cE1=REPLI("=",Ancho)
   cE2=[                                              Nro.       Forma de                                        Total       Total       ]
   cE3=[ Fecha   N£mero     Tpo.Cmb  Iniciales   Doc. Documento    Pago    Banco                Cheque     Mon   Cheque      Efectivo    ]
   **   0123456789-123456789-123456789-123456789-123456789-123456789-123456789-0123456789-123456789-123456789-123456789-123456789-123456789-123456789-
   **             1         2         3         4         5         6         7          8         9         0         1         2
   **   12-12-12 123456789- 9,999.99 1234567890  FACT 123-456789 Efectivo  123456789-123456789- 1234567890 S/.  9999,999.99  9999,999.99
   **
   cE4=REPLI("=",Ancho)
ENDIF
RegAct = RECNO()
SET DEVICE TO PRINTER
SET MARGIN TO 0
PRINTJOB
   GOTO RegAct
   NumPag   = 0
   NumItm1  = 0
   Cancelar = .F.
  *LsLlave  = VMOV->CodDoc+TRIM(LsDesde)
   SELE VMOV
   SEEK LsLlave
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
   DO WHILE !EOF() .AND. EVALUATE(XsTstImp) .AND. !Cancelar .AND. CodDoc=XsCodDoc
      IF NumPag = 0
         DO MOVMembr
      ENDIF
      NumItm1 = 0
      SELECT RMOV
      SEEK VMOV->CodDoc+VMOV->NroDoc
      IF VMOV->FlgESt <> "A"
         DO WHILE  ! EOF() .AND. CodDoc+Nrodoc = VMOV->CodDoc+VMOV->NroDoc
            IF Prow() > (Largo - 9)
               DO MOVMembr
            ENDIF
            SELECT RMOV
            NumLin = Prow() + 1
            IF lSimple
               Contenido  = []
               DO MovBline WITH Contenido
               @ NumLin,00 SAY Contenido
            ELSE
               NumItm1 = NumItm1+ 1
               @ NumLin ,00  SAY VMOV->FchDoc
               @ NumLin ,09  SAY VMOV->NroDoc
               @ NumLin ,20  SAY VMOV->TpoCmb PICT "9,999.99"
               @ NumLin ,29  SAY CLIE->IniAux
               @ NumLin ,41  SAY RMOV->CodRef
               @ NumLin ,46  SAY RMOV->NroRef
               @ NumLin ,57  SAY IIF(RMOV->FmaPgo=1,"Efectivo","Cheque")
               @ NumLin ,67  SAY IIF(SEEK("04"+RMOV->CodBco,'TABL'),LEFT(TABL->NomBre,20),[])
               @ NumLin ,87  SAY NroChq
               @ NumLin ,98  SAY IIF(CodMon = 1,"S/.","US$")
               IF FmaPgo = 2
                  @ NumLin ,103 SAY Import PICT "9999,999.99"
               ELSE
                  @ NumLin ,116 SAY Import PICT "9999,999.99"
               ENDIF
            ENDIF
            SKIP
         ENDDO
      ELSE
         IF lSimple
            @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
            @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
            @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
            @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
            @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
            @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
            @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
         ELSE
            IF Prow() > (Largo - 4)
               DO MOVMembr
            ENDIF
            NumLin = Prow() + 1
            @ Numlin,10 SAY [ A  N  U  L  A  D  O ]
         ENDIF
      ENDIF
      SELE VMOV
      IF (lSimple .AND. Prow() > (Largo - 15)) .OR. (!lSimple .AND. PROW() > (Largo - 4))
         DO MOVMembr
      ENDIF
      DO MovIPie
      SKIP
   ENDDO
   IF !lSimple
      IF PROW() > (Largo - 6))
         DO MOVMembr
      ENDIF
      NumLin = PROW() + 1
      @ NumLin,00  SAY REPLI("=",Ancho)
      NumLin = PROW() + 1
      @ NumLin,00  SAY "TOTAL  S/. >>>>"
      @ NumLin,103 SAY XfChqNac  PICT "9999,999.99"
      @ NumLin,116 SAY XfEfeNac  PICT "9999,999.99"
      NumLin = PROW() + 1
      @ NumLin,00  SAY "TOTAL  US$ >>>>"
      @ NumLin,103 SAY XfChqUsa  PICT "9999,999.99"
      @ NumLin,116 SAY XfEfeUsa  PICT "9999,999.99"
      NumLin = PROW() + 1
      @ NumLin,00  SAY REPLI("=",Ancho)
   ENDIF
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
SELECT VMOV
SELE VMOV
SET ORDER TO VMOV01
GO RegAct
RESTORE SCREEN FROM xTemp
RETURN
************************************************************************ FIN *
* Objeto : Membrete del documento
******************************************************************************
PROCEDURE MOVMembr
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ELSE
  *@ Largo-1,Ancho-10 SAY "../Continua"
ENDIF
NumPag = NumPag + 1
IF lSimple
   @  0,0  SAY IniImp
   @  1,1  SAY _Prn7a+GsNomCia+_Prn7b
   @  1,0  SAY []
   @  2,00 SAY "No. LIQUID. :"+_Prn7a+VMOV->NroDoc+_Prn7b
   @  2,52 SAY "FECHA       :"+DTOC(VMOV->FchDoc)
   @  3,00 SAY "TPO. CMB.   :"+TRANS(VMOV->TpoCmb,"9,999.99")
   LinAct = 4
   @ LinAct ,00 SAY REPLICATE("=",LEN(cE1))
   LinAct = LinAct + 1
   @ LinAct  , 1    SAY cE1
   LinAct = LinAct + 1
   @ LinAct  , 1    SAY cE2
   LinAct = LinAct + 1
   @ LinAct ,00 SAY REPLICATE("=",LEN(cE1))
ELSE
   @  0,0  SAY IniImp
   @  1,1  SAY _Prn7a+GsNomCia+_Prn7b
   @ 1,Ancho - 16 SAY  "Fecha :"+DTOC(DATE())
   @ 2,Ancho - 16 SAY  "P gina:"+TRANS(NumPag,"9,999")
   @ 2,(Ancho - LEN(TiTulo))/2    SAY Titulo
   @ 3,(Ancho - LEN(SubTitulo))/2 SAY SubTitulo
   @ 4,00 SAY cE1
   @ 5,00 SAY cE2
   @ 6,00 SAY cE3
   @ 7,00 SAY cE4
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
IF lSimple
   NumLin = Largo - 15
   @ Numlin,08 SAY "TOTALES > Efectivo S/."
   @ NumLin,33 SAY VMOV->EfeNac PICT "999,999,999.99"
   @ NumLin,50 SAY "US$"
   @ NumLin,54 SAY VMOV->EfeUsa PICT "999,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,08 SAY "        > Cheques  S/."
   @ NumLin,33 SAY VMOV->ChqNac PICT "999,999,999.99"
   @ NumLin,50 SAY "US$"
   @ NumLin,54 SAY VMOV->ChqUsa PICT "999,999,999.99"
   NumLin = PROW() + 9
   Pn1 = "---------------          ---------------          --------------- "
   Pn2 = "   PREPARADO                 REVISADO                  Vo Bo      "
   Pn3 = "                                                                  "
   Pn4 = "                                                                  "
   Pn5 = "---------------          ---------------          --------------- "
   @  NumLin, 1 SAY Pn1
   NumLin = PROW() + 1
   @  NumLin, 1 SAY Pn2
   EJECT PAGE
ELSE
   IF NumItm1 >1
      NumLin = PROW() + 1
      IF VMOV->ChqNac<>0 .OR. VMOV->EfeNac<>0 .OR. VMOV->ChqUsa<>0 .OR. VMOV->EfeUsa<>0
         @ NumLin,103 SAY REPLI("-",11)
         @ NumLin,116 SAY REPLI("-",11)
         NumLin = PROW() + 1
      ENDIF
      IF VMOV->ChqNac<>0 .OR. VMOV->EfeNac<>0
         @ NumLin,20  SAY "TOTAL  S/. >>"
         @ NumLin,103 SAY VMOV->ChqNac  PICT "9999,999.99"
         @ NumLin,116 SAY VMOV->EfeNac  PICT "9999,999.99"
         NumLin = PROW() + 1
      ENDIF
      IF VMOV->ChqUsa<>0 .OR. VMOV->EfeUsa<>0
         @ NumLin,20  SAY "TOTAL  US$ >>"
         @ NumLin,103 SAY VMOV->ChqUsa  PICT "9999,999.99"
         @ NumLin,116 SAY VMOV->EfeUsa  PICT "9999,999.99"
         NumLin = PROW() + 1
      ENDIF
      @ NumLin,00  SAY []
   ENDIF
   XfChqNac = XfChqNac + VMOV->ChqNac
   XfEfeNac = XfEfeNac + VMOV->EfeNac
   XfChqUsa = XfChqUsa + VMOV->ChqUsa
   XfEfeUsa = XfEfeUsa + VMOV->EfeUsa
ENDIF
RETURN
