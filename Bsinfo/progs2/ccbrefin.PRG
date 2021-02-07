****************************************************************************
* Programa     : ccbrefin.prg
* Sistema      : Cuentas por Cobrar
* Autor        : RHC
* Proposito    : Refinanciacion de Documentos
* Creacion     : 24/06/94
* Parametros   :
* Actualizacion:
****************************************************************************

** Pantalla de Datos **
DO xPanta
** base de datos **
CLOSE DATA
*
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE ccbntasg ORDER TASG01 ALIAS TASG
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 3
USE ccbtbdoc ORDER BDOC01  ALIAS TDOC
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 4
USE ccbrgdoc ORDER GDOC04 ALIAS GDOC
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 5
USE ccbnrasg ORDER RASG01 ALIAS RASG
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF
** relaciones a usar **
SELECT TASG
SET RELATION TO XsClfAux+CodCli INTO CLIE
** variables a usar **
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XsGloDoc,XsGlosa1,XsGlosa2
PRIVATE XiCodMon,XfTpoCmb,XfPorIgv,XfPorIpm,XsCodRef,XsNroRef,XfImpDoc
PRIVATE XfImpBto,XfImpIgv,XcFlgEst
PRIVATE XfImpCup,XcPidCup,XfPorInt,XcTipInt,XiDiaLet,XiDiaLib,XiCanLet
PRIVATE m.ImpCup     && Variable de Control del valor de la Cuponera IGV
PRIVATE m.NroDoc     && Control de Correlativo Multiuser
m.NroDoc = 0
XsCodDoc = [REFI]    && Refinanciacion
m.ImpCup = 0
XsNroDoc = SPACE(LEN(TASG->NroDoc))
XdFchDoc = DATE()
XsCodCli = SPACE(LEN(TASG->CodCli))
XsGloDoc = SPACE(LEN(TASG->GloDoc))
XsGlosa1 = SPACE(LEN(TASG->Glosa1))
XsGlosa2 = SPACE(LEN(TASG->Glosa2))
XiCodMon = 1         && Soles
XfTpoCmb = 0.00
XfPorIgv = 0.00
XfPorIpm = 0.00
XsCodRef = [PEDI]
XsNroRef = SPACE(LEN(TASG->NroRef))
XcPidCup = [N]
XfPorInt = 0.00
XcTipInt = [M]       && Mensual,Diario,Anual
XiDiaLet = 0
XiDiaLib = 0
XiCanLet = 0
XfImpDoc = 0.00
XfImpBto = 0.00
XfImpIgv = 0.00
XfImpCup = 0.00
XcFlgEst = [P]
** Variables del Browse **
* browse de   documentos *
PRIVATE AsCodDoc,AsNroDoc,AdFchDoc,AsTpoRef,AsCodRef,AsNroRef,AfImpTot,GiTotDoc
PRIVATE AiDelDoc,GiDelDoc
CIMAXELE = 100
DIMENSION AsTpoDoc(CIMAXELE)
DIMENSION AsCodDoc(CIMAXELE)
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AdFchDoc(CIMAXELE)
DIMENSION AsCodRef(CIMAXELE)
DIMENSION AsNroRef(CIMAXELE)
DIMENSION AfImpTot(CIMAXELE)
DIMENSION AiRegDoc(CIMAXELE)
DIMENSION AiDelDoc(CIMAXELE)
STORE SPACE(LEN(GDOC->TpoDoc)) TO AsTpoDoc
STORE [FACT]                   TO AsCodDoc
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc
STORE CTOD(SPACE(8))           TO AdFchDoc
STORE SPACE(LEN(GDOC->CodRef)) TO AsCodRef
STORE SPACE(LEN(GDOC->NroRef)) TO AsNroRef
STORE 0.00                     TO AfImpTot
STORE 0                        TO AiRegDoc
STORE 0                        TO AiDelDoc
GiTotDoc = 0
GiDelDoc = 0
* browse de letras *
PRIVATE AdFchEmi,AdFchVto,AiDiaLet,AfImport,AfImpInt,AfImpIgv,AfImpLet,GiTotLet
PRIVATE AiDelLet,GiDelLet
DIMENSION AdFchEmi(CIMAXELE)
DIMENSION AdFchVto(CIMAXELE)
DIMENSION AiDiaLet(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AfImpInt(CIMAXELE)
DIMENSION AfImpIgv(CIMAXELE)
DIMENSION AfImpLet(CIMAXELE)
DIMENSION AiRegLet(CIMAXELE)
DIMENSION AiDelLet(CIMAXELE)
STORE CTOD(SPACE(8))           TO AdFchEmi
STORE CTOD(SPACE(8))           TO AdFchVto
STORE 0                        TO AiDiaLet
STORE 0.00                     TO AfImport
STORE 0.00                     TO AfImpInt
STORE 0.00                     TO AfImpIgv
STORE 0.00                     TO AfImpLet
STORE 0                        TO AiRegLet
STORE 0                        TO AiDelLet
GiTotLet = 0
GiDelLet = 0
** Logica Principal **
SELE TASG
DO LIB_MTEC WITH 3
xCodDoc = XsCodDoc
UltTecla = 0
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [CodDoc],XCodDoc,'CMA'
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta


*           1         2         3         4         5         6         7        8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*0  Proforma : 1234567890                                Fecha  : 99/99/99
*1  Cliente  : 12345678 12345789012345789012345789012    Pedido : 1234567890
*2  Moneda   : S/.   Cambio : 99,999.9999   %IGV : 99.99   %IPM : 99.99
*3          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*4          ³    Documento     Fecha     Referencia      Importe    ³
*5          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*6          ³ FACT 1234567890 99/99/99 PEDI 1234567890 9,999,999.99 ³
*7          ³                                                       ³
*8          ³                                                       ³
*9          ³                                                       ³
*0          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ TOTAL DOCUMENTOS    : 9,999,999.99 Ù
*1                               CUPON IGV (S-N)? 1  : 9,999,999.99
*2                               IMPORTE A FINANCIAR : 9,999,999.99
*3  Tasa Mensual     : 999.99 %
*4  Letra a Dias     : 999        Glosa : 123457890123457890123457890123457890
*5  Dias Libres      : 999                123457890123457890123457890123457890
*6  Numero de Letras : 99                 123457890123457890123457890123457890
*7   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*8   ³ Emision  Dias   Importe    Interes       IGV        Total     Vence  ³
*9   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0   ³ 99/99/99 123 9,999,999.99 999,999.99 999,999.99 9,999,999.99 99/99/99³
*1   ³ 99/99/99 123 9,999,999.99 999,999.99 999,999.99 9,999,999.99 99/99/99³
*2   ÀÄÄ- TOTALES : 9,999,999.99 999,999.99 999,999.99 9,999,999.99 ÄÄÄÄÄÄÄÄÙ
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*           1         2         3         4         5         6         7        8
CLEAR

@  0,0  SAY "  Refinanc.:                                           Fecha  :            "
@  1,0  SAY "  Cliente  :                                           Pedido :            "
@  2,0  SAY "  Moneda   :       Cambio :               %IGV :         %IPM :            "
@  3,0  SAY "          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿        "
@  4,0  SAY "          ³    Documento     Fecha     Referencia      Importe    ³        "
@  5,0  SAY "          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´        "
@  6,0  SAY "          ³                                                       ³        "
@  7,0  SAY "          ³                                                       ³        "
@  8,0  SAY "          ³                                                       ³        "
@  9,0  SAY "          ³                                                       ³        "
@ 10,0  SAY "          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ TOTAL DOCUMENTOS    :              Ù        "
@ 11,0  SAY "                               CUPON IGV (S-N)? 1  :                       "
@ 12,0  SAY "                               IMPORTE A FINANCIAR :                       "
@ 13,0  SAY "  Tasa Mensual     :                                                       "
@ 14,0  SAY "  Letra a Dias     :            Glosa :                                    "
@ 15,0  SAY "  Dias Libres      :                                                       "
@ 16,0  SAY "  Numero de Letras :                                                       "
@ 17,0  SAY "   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 18,0  SAY "   ³ Emision  Dias   Importe    Interes       IGV        Total     Vence  ³"
@ 19,0  SAY "   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 20,0  SAY "   ³                                                                      ³"
@ 21,0  SAY "   ³                                                                      ³"
@ 22,0  SAY "   ÀÄÄ- TOTALES :                                                 ÄÄÄÄÄÄÄÄÙ"
*
@  4,11 SAY "    Documento     Fecha     Referencia      Importe    " COLOR SCHEME 7
@ 10,30 SAY " TOTAL DOCUMENTOS    :" COLOR SCHEME 7
@ 11,30 SAY " CUPON IGV (S-N)?    :" COLOR SCHEME 7
@ 12,30 SAY " IMPORTE A FINANCIAR :" COLOR SCHEME 7
@ 18,4  SAY " Emision  Dias   Importe    Interes       IGV        Total     Vence  " COLOR SCHEME 7
@ 22,8  SAY " TOTALES :" COLOR SCHEME 7

RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

SELE TASG
IF &RegVal
   XsNroDoc = TASG->NroDoc
ELSE
   * buscamos correlativo
   IF !SEEK(XsCodDoc,"TDOC")
      WAIT "No existe correlativo" NOWAIT WINDOW
      UltTecla = Escape
      RETURN
   ENDIF
   XsNroDoc = SPACE(LEN(TASG->NroDoc))
   XsNroDoc = RIGHT('000000'+ALLTRIM(STR(TDOC->NroDoc)),6)+;
              SPACE(LEN(XsNroDoc)-6)
   m.NroDoc = XsNroDoc
ENDIF
*
SELE TASG
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape,Enter)
   @ 0,14 GET XsNroDoc PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Escape)
      LOOP
   ENDIF
   IF UltTecla = F8
      IF ! ccbbusca("0007")
         UltTecla = 0
         LOOP
      ENDIF
      XsNroDoc = TASG->NroDoc
   ENDIF
   @ 0,14 SAY XsNroDoc
   IF EMPTY(XsNroDoc)
      UltTecla = 0
      LOOP
   ENDIF
ENDDO
SEEK XsCodDoc+XsNroDoc

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE TASG
Crear = .T.
IF &RegVal
   Crear = .F.
   IF ! RLOCK()
      RETURN
   ENDIF
   IF FlgEst = 'A'
      GsMsgErr = [ Registro Anulado ]
      DO lib_merr WITH 99
      UNLOCK
      RETURN
   ENDIF
   IF FlgEst = 'E'
      GsMsgErr = [ Proforma ha generado Letra(s) ]
      DO lib_merr WITH 99
      UNLOCK
      RETURN
   ENDIF
   DO xMover
   cTecla = [Escape,F10,CtrlW]
ELSE
   DO xInvar
   cTecla = [Escape]
ENDIF
*
@  0,64 GET XdFchDoc
@  1,14 GET XsCodCli PICT "@!"
@  1,64 GET XsNroRef PICT "@!"
@  2,28 GET XfTpoCmb PICT "99,999.9999"
@  2,49 GET XfPorIgv PICT "99.99"
@  2,64 GET XfPorIpm PICT "99.99"
@ 11,48 GET XcPidCup PICT "!"
@ 11,53 GET XfImpCup PICT "9,999,999.99"
@ 13,21 GET XfPorInt PICT "999.99"
@ 14,21 GET XiDiaLet PICT "999"
@ 15,21 GET XiDiaLib PICT "999"
@ 16,21 GET XiCanLet PICT "99"
@ 14,40 GET XsGloDoc
@ 15,40 GET XsGlosa1
@ 16,40 GET XsGlosa2
CLEAR GETS
IF !Crear
   @  1,14 SAY XsCodCli PICT "@!"
   @  1,64 SAY XsNroRef PICT "@!"
   @  2,13 SAY IIF(XiCodMon=1,'S/.','US$')
   @  2,28 SAY XfTpoCmb PICT "99,999.9999"
   @ 13,21 SAY XfPorInt PICT "999.99"
   @ 14,21 SAY XiDiaLet PICT "999"
   @ 15,21 SAY XiDiaLib PICT "999"
   @ 16,21 SAY XiCanLet PICT "99"
ENDIF
*
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,&cTecla.)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         @ 0,64 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
         @ 0,64 SAY XdFchDoc
      CASE i = 2 .AND. Crear
         GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 1,14 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(XsCodCli) .OR. UltTecla = F8
            IF ! ccbbusca("CLIE")
               LOOP
            ENDIF
            XsCodCli = CLIE->CodAux
         ENDIF
         SEEK XsClfAux+XsCodCli
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         @ 1,14 SAY LEFT(XsCodCli+' '+CLIE->NomAux,41)
      CASE i = 3 .AND. Crear
         @ 1,64 GET XsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         @ 1,64 SAY XsNroRef PICT "@!"
      CASE i = 4 .AND. Crear
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,2,13,2)
      CASE i = 5 .AND. Crear
         @ 2,28 GET XfTpoCmb PICT "99,999.9999" VALID(XfTpoCmb>0)
         READ
         UltTecla = LASTKEY()
         @ 2,28 SAY XfTpoCmb PICT "99,999.9999"
      CASE i = 6
         @ 2,49 GET XfPorIgv PICT "99.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 2,49 SAY XfPorIgv PICT "99.99"
      CASE i = 7
         @ 2,64 GET XfPorIpm PICT "99.99" RANGE 0,XfPorIgv
         READ
         UltTecla = LASTKEY()
         @ 2,64 SAY XfPorIpm PICT "99.99"
      CASE i = 8
         DO DOCBrows
      CASE i = 9
         @ 11,48 GET XcPidCup PICT "!" VALID(XcPidCup$'SN')
         READ
         UltTecla = LASTKEY()
      CASE i = 10 .AND. XcPidCup = 'S'
         ** calculamos importe de la cuponera **
         XfImpCup = m.ImpCup
         @ 11,53 GET XfImpCup PICT "9,999,999.99" VALID(XfImpCup>=0 .AND. XfImpCup<=m.ImpCup)
         READ
         UltTecla = LASTKEY()
         @ 11,53 SAY XfImpCup            PICT "9,999,999.99"
         @ 12,53 SAY (XfImpDoc-XfImpCup) PICT "9,999,999.99"
      CASE i = 10 .AND. XcPidCup = 'N'
         STORE 0 TO XfImpCup
         @ 11,53 SAY XfImpCup            PICT "9,999,999.99"
         @ 12,53 SAY (XfImpDoc-XfImpCup) PICT "9,999,999.99"
      CASE i = 11 .AND. Crear
         DO lib_mtec WITH 16
         VecOpc(1)="Mensual"
         VecOpc(2)="Anual"
         VecOpc(3)="Diario"
         XcTipInt= Elige(XcTipInt,13,7,3)
      CASE i = 12 .AND. Crear
         @ 13,21 GET XfPorInt PICT "999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 13,21 SAY XfPorInt PICT "999.99"
      CASE i = 13 .AND. Crear
         @ 14,21 GET XiDiaLet PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 14,21 SAY XiDiaLet PICT "999"
      CASE i = 14 .AND. Crear
         @ 15,21 GET XiDiaLib PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 15,21 SAY XiDiaLib PICT "999"
      CASE i = 15 .AND. Crear
         @ 16,21 GET XiCanLet PICT "99" VALID(XiCanLet>0)
         READ
         UltTecla = LASTKEY()
         @ 16,21 SAY XiCanLet PICT "99"
      CASE i = 16
         @ 14,40 GET XsGloDoc
         READ
         UltTecla = LASTKEY()
         @ 14,40 SAY XsGloDoc
      CASE i = 17
         @ 15,40 GET XsGlosa1
         READ
         UltTecla = LASTKEY()
         @ 15,40 SAY XsGlosa1
      CASE i = 18
         @ 16,40 GET XsGlosa2
         READ
         UltTecla = LASTKEY()
         @ 16,40 SAY XsGlosa2
      CASE i = 19
         DO LETBrows
   ENDCASE
   IF i = 19 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>19,19,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
ENDIF
SELE TASG
UNLOCK ALL
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

XsNroDoc = TASG->NroDoc
XdFchDoc = TASG->FchDoc
XsCodCli = TASG->CodCli
XsGloDoc = TASG->GloDoc
XsGlosa1 = TASG->Glosa1
XsGlosa2 = TASG->Glosa2
XiCodMon = TASG->CodMon
XfTpoCmb = TASG->TpoCmb
XfPorIgv = TASG->PorIgv
XfPorIpm = TASG->PorIpm
XsCodRef = TASG->CodRef
XsNroRef = TASG->NroRef
XfImpCup = TASG->ImpCup
XcPidCup = TASG->PidCup
XfPorInt = TASG->PorInt
XcTipInt = TASG->TipInt
XiDiaLet = TASG->DiaLet
XiDiaLib = TASG->DiaLib
XiCanLet = TASG->CanLet
XfImpDoc = TASG->ImpDoc
XcFlgEst = TASG->FlgEst
** cargamos arreglos **
DO DOCbmove
DO LETbmove
***********************
SELE TASG

RETURN
************************************************************************ FIN()
* Inicializamos Variables
******************************************************************************
PROCEDURE xInvar

XdFchDoc = DATE()
XsCodCli = SPACE(LEN(TASG->CodCli))
XsGloDoc = SPACE(LEN(TASG->GloDoc))
XsGlosa1 = SPACE(LEN(TASG->Glosa1))
XsGlosa2 = SPACE(LEN(TASG->Glosa2))
XiCodMon = 1         && Soles
XfTpoCmb = 0.00
XfPorIgv = 0.00
XfPorIpm = 0.00
XsCodRef = [PEDI]
XsNroRef = SPACE(LEN(TASG->NroRef))
XcPidCup = [N]
XfPorInt = 0.00
XcTipInt = [M]       && Mensual,Diario,Anual
XiDiaLet = 0
XiDiaLib = 0
XiCanLet = 0
XfImpDoc = 0.00
XfImpBto = 0.00
XfImpIgv = 0.00
XfImpCup = 0.00
XcFlgEst = [P]
** Variables del Browse **
* browse de   documentos *
STORE [FACT]                   TO AsCodDoc
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc
STORE CTOD(SPACE(8))           TO AdFchDoc
STORE SPACE(LEN(GDOC->CodRef)) TO AsCodRef
STORE SPACE(LEN(GDOC->NroRef)) TO AsNroRef
STORE 0.00                     TO AfImpTot
STORE 0                        TO AiRegDoc
STORE 0                        TO AiDelDoc
GiTotDoc = 0
GiDelDoc = 0
* browse de letras *
STORE CTOD(SPACE(8))           TO AdFchEmi
STORE CTOD(SPACE(8))           TO AdFchVto
STORE 0                        TO AiDiaLet
STORE 0.00                     TO AfImport
STORE 0.00                     TO AfImpInt
STORE 0.00                     TO AfImpIgv
STORE 0.00                     TO AfImpLet
STORE 0                        TO AiRegLet
STORE 0                        TO AiDelLet
GiTotLet = 0
GiDelLet = 0

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

SELE TASG
IF Crear
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   STORE RECNO() TO iNumReg
   * control de correlativo *
   SELE TDOC
   SEEK XsCodDoc
   IF ! RLOCK()
      RETURN
   ENDIF
   IF m.NroDoc = XsNroDoc
      * tomamos el correlativo de la base *
      XsNroDoc = RIGHT('000000'+ALLTRIM(STR(TDOC->NroDoc)),6)+;
                 SPACE(LEN(XsNroDoc)-6)
      REPLACE TDOC->NroDoc WITH TDOC->NroDoc+1
   ELSE
      * veamos si ya fue registrado *
      SELE TASG
      SEEK XsCodDoc+XsNroDoc
      IF FOUND()
         GsMsgErr = [ Registro Creado por otro Usuario ]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      SELE TDOC
      IF XsNroDoc>m.NroDoc
         * actualizamos el correlativo *
         REPLACE TDOC->NroDoc WITH VAL(XsNroDoc)+1
      ENDIF
   ENDIF
   SELE TDOC
   UNLOCK
   @ 0,14 SAY XsNroDoc
   SELE TASG
   GO iNumReg
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
REPLACE FchDoc WITH XdFchDoc
REPLACE CodCli WITH XsCodCli
REPLACE GloDoc WITH XsGloDoc
REPLACE Glosa1 WITH XsGlosa1
REPLACE Glosa2 WITH XsGlosa2
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE ImpBto WITH XfImpBto
REPLACE ImpIgv WITH XfImpIgv
REPLACE ImpCup WITH XfImpCup
REPLACE ImpDoc WITH XfImpDoc
REPLACE PorIPM WITH XfPorIPM
REPLACE PorIGV WITH XfPorIGV
REPLACE PorInt WITH XfPorInt
REPLACE TipInt WITH XcTipInt
REPLACE DiaLet WITH XiDiaLet
REPLACE DiaLib WITH XiDiaLib
REPLACE PidCup WITH XcPidCup
REPLACE CanLet WITH XiCanLet
REPLACE CodRef WITH XsCodRef
REPLACE NroRef WITH XsNroRef
REPLACE FlgEst WITH XcFlgEst
** Grabamos Browse **
DO DOCbgrab
DO LETbgrab
*********************
DO xListar
SELE TASG

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE TASG
IF ! RLOCK()
   RETURN
ENDIF
** anulamos detalles **
SELE RASG
SEEK TASG->CodDoc+TASG->NroDoc
DO WHILE CodDoc+NroDoc=TASG->CodDoc+TASG->NroDoc .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO
SELE TASG
DELETE
UNLOCK
SKIP

RETURN
************************************************************************ FIN()




















****************************************************************************
* Programa     : ccbprof1.prg
* Sistema      : Cuentas por Cobrar
* Autor        : RHC
* Proposito    : Browse de Documentos de la Proforma
* Creacion     : 03/02/94
* Parametros   :
* Actualizacion:
****************************************************************************
PROCEDURE DocBrows

**
EscLin   = "Docbline"
EdiLin   = "Docbedit"
BrrLin   = "Docbborr"
InsLin   = "Docbinse"
PrgFin   = []
*
Yo       = 5
Xo       = 10
Largo    = 6
Ancho    = 57
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
* Cargamos arreglo por defecto *
IF Crear
   DO DOCbiniv
   IF GiTotDoc = 0
      GsMsgErr = [ NO existen documentos a negociar ]
      DO lib_merr WITH 99
      UltTecla = Arriba
      RETURN
   ENDIF
ELSE
   DO DOCbmove          && Cargamos datos ya registrados
   IF GiTotDoc = 0
      GsMsgErr = [ NO existe informacion almacenada ]
      DO lib_merr WITH 99
      UltTecla = Arriba
      RETURN
   ENDIF
ENDIF
MaxEle   = GiTotDoc
TotEle   = CIMAXELE
*
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
DO aBrowse
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE DOCbLine
PARAMETERS NumEle, NumLin
@ NumLin,12 SAY AsCodDoc(NumEle)
@ NumLin,17 SAY AsNroDoc(NumEle)
@ NumLin,28 SAY AdFchDoc(NumEle)
@ NumLin,37 SAY AsCodRef(NumEle)
@ NumLin,42 SAY AsNroRef(NumEle)
@ NumLin,53 SAY AfImpTot(NumEle) PICT "9,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE DocBEdit
PARAMETERS NumEle, NumLin

PRIVATE i
i        = 1
UltTecla = 0
*
LsTpoDoc = AsTpoDoc(NumEle)
LsCodDoc = AsCodDoc(NumEle)
LsNroDoc = AsNroDoc(NumEle)
LdFchDoc = AdFchDoc(NumEle)
LsCodRef = AsCodRef(NumEle)
LsNroRef = AsNroRef(NumEle)
LfImpTot = AfImpTot(NumEle)
LiRegDoc = AiRegDoc(NumEle)
** solo se puede modificar lo que no esta grabado **
IF LiRegDoc > 0
   GsMsgErr = [ Acceso Denegado ]
   DO lib_merr WITH 99
   UltTecla = Arriba
   RETURN
ENDIF
GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1
         SELE TDOC
         @ NumLin,12 GET LsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("TDOC")
               LOOP
            ENDIF
            LsCodDoc = TDOC->CodDoc
         ENDIF
         @ NumLin,12 SAY LsCodDoc
         SEEK LsCodDoc
         IF !FOUND()
            GsMsgErr = [Documento no Existe]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF ! TpoDoc $ "CARGO|ABONO"
            DO lib_merr WITH 6
            LOOP
         ENDIF
         * * * *
         LsTpoDoc = TpoDoc    && OJO
         * * * *
      CASE i = 2
         SELE GDOC
         @ NumLin,17 GET LsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsNroDoc)
            PRIVATE XsTpoRef,XsCodRef
            XsTpoRef = LsTpoDoc
            XsCodRef = LsCodDoc
            IF !ccbbusca("ASIG")
               LOOP
            ENDIF
            LsNroDoc = GDOC->NroDoc
         ENDIF
         @ NumLin,17 SAY LsNroDoc
         SEEK XsCodCli+"P"+LsTpoDoc+LsCodDoc+LsNroDoc
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** verificamos que no se repita **
         OK = .T.
         PRIVATE j
         j = 1
         DO WHILE j <= GiTotDoc
            IF j <> NumEle
               IF AsCodDoc(j)+AsNroDoc(j) = LsCodDoc+LsNroDoc
                  WAIT "Dato ya Registrado" NOWAIT WINDOW
                  OK = .F.
                  EXIT
               ENDIF
            ENDIF
            j = j + 1
         ENDDO
         IF ! OK
            UltTecla = 0
            LOOP
         ENDIF
         IF !RLOCK()
            LOOP
         ENDIF
         LfImpTot = IIF(LsTpoDoc=[CARGO],GDOC->SdoDoc,-1*GDOC->SdoDoc)
         IF GDOC->CodMon # XiCodMon
            IF XiCodMon = 1
               LfImpTot = ROUND(LfImpTot*XfTpoCmb,2)
            ELSE
               LfImpTot = ROUND(LfImpTot/XfTpoCmb,2)
            ENDIF
         ENDIF
         LdFchDoc = GDOC->FchDoc
         LsCodRef = GDOC->CodRef
         LsNroRef = GDOC->NroRef
         UNLOCK
         @ NumLin,28 SAY LdFchDoc
         @ NumLin,37 SAY LsCodRef
         @ NumLin,42 SAY LsNroRef
         @ NumLin,53 SAY LfImpTot PICT "9,999,999.99"
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Izquierda,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
IF UltTecla # Escape
   AsTpoDoc(NumEle) = LsTpoDoc
   AsCodDoc(NumEle) = LsCodDoc
   AsNroDoc(NumEle) = LsNroDoc
   AdFchDoc(NumEle) = LdFchDoc
   AsCodRef(NumEle) = LsCodRef
   AsNroRef(NumEle) = LsNroRef
   AfImpTot(NumEle) = LfImpTot
   AiRegDoc(NumEle) = LiRegDoc
   DO DocRegen
ENDIF
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE DocbBorr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
IF AiRegDoc(i) > 0
   GiDelDoc = GiDelDoc + 1
   AiDelDoc(GiDelDoc) = AiRegDoc(i)
ENDIF
DO WHILE i <  GiTotDoc
   AsTpoDoc(i) = AsTpoDoc(i+1)
   AsCodDoc(i) = AsCodDoc(i+1)
   AsNroDoc(i) = AsNroDoc(i+1)
   AdFchDoc(i) = AdFchDoc(i+1)
   AsCodRef(i) = AsCodRef(i+1)
   AsNroRef(i) = AsNroRef(i+1)
   AfImpTot(i) = AfImpTot(i+1)
   AiRegDoc(i) = AiRegDoc(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(GDOC->TpoDoc)) TO AsTpoDoc(i)
STORE [FACT]                   TO AsCodDoc(i)
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc(i)
STORE CTOD(SPACE(8))           TO AdFchDoc(i)
STORE SPACE(LEN(GDOC->CodRef)) TO AsCodRef(i)
STORE SPACE(LEN(GDOC->NroRef)) TO AsNroRef(i)
STORE 0.00                     TO AfImpTot(i)
STORE 0.00                     TO AiRegDoc(i)
GiTotDoc = GiTotDoc - 1
Estado = .T.
DO DocRegen    && recalcula importe
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE DocbInse

PARAMETERS ElePrv, Estado
PRIVATE i
i = GiTotDoc + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsTpoDoc(i) = AsTpoDoc(i-1)
   AsCodDoc(i) = AsCodDoc(i-1)
   AsNroDoc(i) = AsNroDoc(i-1)
   AdFchDoc(i) = AdFchDoc(i-1)
   AsCodRef(i) = AsCodRef(i-1)
   AsNroRef(i) = AsNroRef(i-1)
   AfImpTot(i) = AfImpTot(i-1)
   AiRegDoc(i) = AiRegDoc(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(GDOC->TpoDoc)) TO AsTpoDoc(i)
STORE [FACT]                   TO AsCodDoc(i)
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroDoc(i)
STORE CTOD(SPACE(8))           TO AdFchDoc(i)
STORE SPACE(LEN(GDOC->CodRef)) TO AsCodRef(i)
STORE SPACE(LEN(GDOC->NroRef)) TO AsNroRef(i)
STORE 0.00                     TO AfImpTot(i)
STORE 0.00                     TO AiRegDoc(i)
GiTotDoc = GiTotDoc + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Inicializar el Arreglo
******************************************************************************
PROCEDURE DOCbiniv

** Cargamos TODOS los documentos de CARGO **
PRIVATE i
i = 1
SELE GDOC
SEEK XsCodCli+'P'+'CARGO'
DO WHILE CodCli+FlgEst+TpoDoc+CodDoc=XsCodCli+'P'+'CARGO' .AND. i <= CIMAXELE
   IF !EMPTY(XsNroRef)
      IF !(CodRef=XsCodRef .AND. NroRef=XsNroRef)
         SKIP
         LOOP
      ENDIF
   ENDIF
   AsTpoDoc(i) = TpoDoc
   AsCodDoc(i) = CodDoc
   AsNroDoc(i) = NroDoc
   AdFchDoc(i) = FchDoc
   AsCodRef(i) = CodRef
   AsNroRef(i) = NroRef
   AfImpTot(i) = SdoDoc
   AiRegDoc(i) = 0
   AiDelDoc(i) = 0
   IF GDOC->CodMon # XiCodMon
      IF XiCodMon = 1
         AfImpTot(i) = ROUND(GDOC->SdoDoc*XfTpoCmb,2)
      ELSE
         AfImpTot(i) = ROUND(GDOC->SdoDoc/XfTpoCmb,2)
      ENDIF
   ENDIF
   i = i + 1
   SKIP
ENDDO
GiTotDoc = i - 1
DO DOCRegen

RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE DOCbmove

SELE GDOC
SET ORDER TO GDOC01
*
PRIVATE  i
i = 1
SELE RASG
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc .AND. i<=CIMAXELE ;
     FOR CodRef#XsCodDoc   && << OJO con esto (trampa) <<
   =SEEK(RASG->TpoRef+RASG->CodRef+RASG->NroRef,"GDOC")
   AsTpoDoc(i) = TpoRef
   AsCodDoc(i) = CodRef
   AsNroDoc(i) = NroRef
   AdFchDoc(i) = GDOC->FchDoc
   AsCodRef(i) = GDOC->CodRef
   AsNroRef(i) = GDOC->NroRef
   AfImpTot(i) = ImpTot
   AiRegDoc(i) = RECNO()
   AiDelDoc(i) = 0
   i = i + 1
ENDSCAN
GiTotDoc = i - 1
DO DOCRegen
SELE GDOC
SET ORDER TO GDOC04
RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE DOCbgrab

SELE RASG
PRIVATE i
i = 1
IF GiDelDoc > 0
   DO WHILE i<=GiDelDoc
      GO AiDelDoc(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      DELETE
      UNLOCK
      i = i + 1
   ENDDO
ENDIF
i = 1
DO WHILE i <= GiTotDoc
   IF AiRegDoc(i) > 0
      GO AiRegDoc(i)
      IF ! RLOCK()
         LOOP
      ENDIF
   ELSE
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE CodDoc WITH XsCodDoc
      REPLACE NroDoc WITH XsNroDoc
   ENDIF
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE TpoRef WITH AsTpoDoc(i)
   REPLACE CodRef WITH AsCodDoc(i)
   REPLACE NroRef WITH AsNroDoc(i)
   REPLACE ImpTot WITH AfImpTot(i)
   i = i + 1
ENDDO

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE DocRegen

PRIVATE j
j = 1
STORE 0 TO XfImpBto,XfImpIgv,XfImpCup,XfImpDoc,m.ImpCup
DO WHILE j <= GiTotDoc
   XfImpBto = XfImpBto + ROUND(AfImpTot(j)/(1+XfPorIgv/100),2)
   XfImpDoc = XfImpDoc + AfImpTot(j)
   j = j + 1
ENDDO
XfImpIgv = XfImpDoc - XfImpBto
IF XfPorIpm > 0
   XfImpCup = ROUND(XfImpBto*(XfPorIgv-XfPorIpm)/100,2)
ENDIF
m.ImpCup = XfImpCup
@ 10,53 SAY XfImpDoc PICT "9,999,999.99" COLOR SCHEME 7

RETURN
************************************************************************ FIN *
****************************************************************************
* Programa     : ccbprof2.prg
* Sistema      : Cuentas por Cobrar
* Autor        : RHC
* Proposito    : Browse de Letras de la Proforma
* Creacion     : 03/02/94
* Parametros   :
* Actualizacion:
****************************************************************************
PROCEDURE LetBrows

**
EscLin   = "Letbline"
EdiLin   = "Letbedit"
BrrLin   = "Letbborr"
InsLin   = "Letbinse"
PrgFin   = []
*
Yo       = 19
Xo       = 3
Largo    = 4
Ancho    = 72
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
** viejo truco **
PRIVATE CIMAXELE
CIMAXELE = XiCanLet
** definimos variables de trabajo **
PRIVATE m.Import,m.ImpInt,m.ImpIgv,m.ImpTot
PRIVATE m.ImpDoc     && Valor al cual se debe llegar como minimo
STORE 0 TO m.Import,m.ImpInt,m.ImpIgv,m.ImpTot
m.ImpDoc = XfImpDoc - XfImpCup   && << OJO <<
*****************
IF Crear
   DO LETbiniv    && Inicializa el arreglo
   IF GiTotLet = 0
      GsMsgErr = [No se puede generar informacion]
      DO lib_merr WITH 99
      UltTecla = Arriba
      RETURN
   ENDIF
ELSE
   DO LETbmove       && Cargamos arreglo con informacion almacenada
   IF GiTotLet = 0
      GsMsgErr = [No se puede cargar informacion]
      DO lib_merr WITH 99
      UltTecla = Arriba
      RETURN
   ENDIF
ENDIF
MaxEle   = GiTotLet
TotEle   = CIMAXELE
DO LETRegen       && Recalculamos datos
DO WHILE .t.
   GsMsgKey = "[PgUp] [PgDw]   [Enter] Ingreso [F10] Graba [Esc] Salir"
   DO lib_mtec WITH 99
   DO aBrowse
   IF (UltTecla = Escape) .OR. (m.Import = m.ImpDoc)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Inicializar el arreglo
******************************************************************************
PROCEDURE Letbiniv

PRIVATE j,i,P,n,m,V
j = 1
m.SdoDoc = m.ImpDoc
DO WHILE j <= XiCanLet
   AiDiaLet(j) = XiDiaLet
   AfImport(j) = ROUND(m.ImpDoc/XiCanLet,2)
   P = AfImport(j)
   n = XiDiaLet
   i = XfPorInt
   DO CASE
      CASE XcTipInt = [M]     && Mensual
         m = 30
      CASE XcTipInt = [A]     && Anual
         m = 360
      CASE XcTipInt = [D]     && Diario
         m = 1
   ENDCASE
   V = P * ( ( 1 + i/100 )^(n/m) - 1 )
   V = ROUND(V,2)
   AfImpInt(j) = V
   AfImpIgv(j) = ROUND(AfImpInt(j)*XfPorIgv/100,2)
   AfImpLet(j) = AfImport(j)+AfImpInt(j)+AfImpIgv(j)
   AiDiaLet(j) = XiDiaLet
   AdFchEmi(j) = XdFchDoc
   AdFchVto(j) = XdFchDoc+XiDiaLet+XiDiaLib
   *
   m.SdoDoc = m.SdoDoc - AfImport(j)
   *
   j = j + 1
ENDDO
GiTotLet = XiCanLet
IF m.SdoDoc <> 0
   j = 1
   AfImport(j) = AfImport(j) + m.SdoDoc
   P = AfImport(j)
   n = XiDiaLet
   i = XfPorInt
   DO CASE
      CASE XcTipInt = [M]     && Mensual
         m = 30
      CASE XcTipInt = [A]     && Anual
         m = 360
      CASE XcTipInt = [D]     && Diario
         m = 1
   ENDCASE
   V = P * ( ( 1 + i/100 )^(n/m) - 1 )
   V = ROUND(V,2)
   AfImpInt(j) = V
   AfImpIgv(j) = ROUND(AfImpInt(j)*XfPorIgv/100,2)
   AfImpLet(j) = AfImport(j)+AfImpInt(j)+AfImpIgv(j)
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE LETbmove

PRIVATE  i
i = 1
SELE RASG
SEEK XsCodDoc+XsNroDoc+[CARGO]
SCAN WHILE CodDoc+NroDoc+TpoRef=XsCodDoc+XsNroDoc+[CARGO] .AND. i<=CIMAXELE ;
     FOR CodRef=XsCodDoc      && << OJO con esto (trampa) <<
   =SEEK(RASG->TpoRef+RASG->CodRef+RASG->NroRef,"GDOC")
   AdFchEmi(i) = FchRef
   AdFchVto(i) = VtoRef
   AiDiaLet(i) = DiaLet
   AfImport(i) = Import
   AfImpInt(i) = ImpInt
   AfImpIgv(i) = ImpIgv
   AfImpLet(i) = ImpTot
   AiRegLet(i) = RECNO()
   AiDelLet(i) = 0
   i = i + 1
ENDSCAN
GiTotLet = i - 1
DO LETRegen
RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen

PRIVATE j
j = 1
STORE 0 TO m.Import,m.ImpInt,m.ImpIgv,m.ImpTot
DO WHILE j <= GiTotLet
   m.Import = m.Import + AfImport(j)
   m.ImpInt = m.ImpInt + AfImpInt(j)
   m.ImpIgv = m.ImpIgv + AfImpIgv(j)
   m.ImpTot = m.ImpTot + AfImpLet(j)
   j = j + 1
ENDDO
@ 22,18 SAY m.Import PICT "9,999,999.99" COLOR SCHEME 7
@ 22,31 SAY m.ImpInt PICT "999,999.99"   COLOR SCHEME 7
@ 22,42 SAY m.ImpIgv PICT "999,999.99"   COLOR SCHEME 7
@ 22,53 SAY m.ImpTot PICT "9,999,999.99" COLOR SCHEME 7

RETURN
********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE LetBLine

PARAMETERS NumEle, NumLin
@ NumLin,5  SAY AdFchEmi(NumEle)
@ NumLin,14 SAY AiDiaLet(NumEle) PICT "999"
@ NumLin,18 SAY AfImport(NumEle) PICT "9,999,999.99"
@ NumLin,31 SAY AfImpInt(NumEle) PICT "999,999.99"
@ NumLin,42 SAY AfImpIgv(NumEle) PICT "999,999.99"
@ NumLin,53 SAY AfImpLet(NumEle) PICT "9,999,999.99"
@ NumLin,66 SAY AdFchVto(NumEle)

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE LetBEdit
PARAMETERS NumEle, NumLin

PRIVATE   i,P,V,n,m,k
i        = 1
UltTecla = 0
*
LdFchEmi = AdFchEmi(NumEle)
LiDiaLet = AiDiaLet(NumEle)
LfImport = AfImport(NumEle)
LfImpInt = AfImpInt(NumEle)
LfImpIgv = AfImpIgv(NumEle)
LfImpLet = AfImpLet(NumEle)
LdFchVto = AdFchVto(NumEle)
LiRegLet = AiRegLet(NumEle)
*
@ NumLin,5  GET LdFchEmi
@ NumLin,14 GET LiDiaLet PICT "999"
@ NumLin,18 GET LfImport PICT "9,999,999.99"
@ NumLin,31 GET LfImpInt PICT "999,999.99"
@ NumLin,42 GET LfImpIgv PICT "999,999.99"
@ NumLin,53 GET LfImpLet PICT "9,999,999.99"
@ NumLin,66 GET LdFchVto
CLEAR GETS
*
GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
DO lib_mtec WITH 99
DO WHILE ! INLIST(UltTecla,Escape,Arriba,Abajo)
   DO CASE
      CASE i = 1
         @ NumLin,5  GET LdFchEmi
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ NumLin,14 GET LiDiaLet PICT "999" VALID(LiDiaLet>=0)
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         ** calculamos dias de vencimiento **
         LdFchVto = LdFchEmi + LiDiaLet + XiDiaLib
         @ NumLin,66 SAY LdFchVto
      CASE i = 4
         @ NumLin,18 GET LfImport PICT "9,999,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE i = 5
         ** calculamos intereses **
         P = LfImport
         n = LiDiaLet
         k = XfPorInt
         DO CASE
            CASE XcTipInt = [M]     && Mensual
               m = 30
            CASE XcTipInt = [A]     && Anual
               m = 360
            CASE XcTipInt = [D]     && Diario
               m = 1
         ENDCASE
         V = P * ( ( 1 + k/100 )^(n/m) - 1 )
         V = ROUND(V,2)
         LfImpInt = V
         LfImpIgv = ROUND(LfImpInt*XfPorIgv/100,2)
         LfImpLet = LfImport+LfImpInt+LfImpIgv
         @ NumLin,18 SAY LfImport PICT "9,999,999.99"
         @ NumLin,31 SAY LfImpInt PICT "999,999.99"
         @ NumLin,42 SAY LfImpIgv PICT "999,999.99"
         @ NumLin,53 SAY LfImpLet PICT "9,999,999.99"
         EXIT
   ENDCASE
   i = IIF(UltTecla=Izquierda,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>5,5,i)
ENDDO
IF ! INLIST(UltTecla,Escape,Arriba,Abajo)
   AdFchEmi(NumEle) = LdFchEmi
   AiDiaLet(NumEle) = LiDiaLet
   AfImport(NumEle) = LfImport
   AfImpInt(NumEle) = LfImpInt
   AfImpIgv(NumEle) = LfImpIgv
   AfImpLet(NumEle) = LfImpLet
   AdFchVto(NumEle) = LdFchVto
   AiRegLet(NumEle) = LiRegLet
   DO LETRegen
ENDIF
GsMsgKey = "[PgUp] [PgDw]   [Enter] Ingreso [F10] Graba [Esc] Salir"
DO lib_mtec WITH 99
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE LetbBorr
PARAMETERS ElePrv, Estado
Estado = .F.
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE LetbInse
PARAMETERS ElePrv, Estado
PRIVATE i
Estado = .F.
RETURN

************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE LETbgrab

SELE RASG
PRIVATE i
i = 1
IF GiDelDoc > 0
   DO WHILE i<=GiDelLet
      GO AiDelLet(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      DELETE
      UNLOCK
      i = i + 1
   ENDDO
ENDIF
i = 1
DO WHILE i <= GiTotLet
   IF AiRegLet(i) > 0
      GO AiRegLet(i)
      IF ! RLOCK()
         LOOP
      ENDIF
   ELSE
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE CodDoc WITH XsCodDoc
      REPLACE NroDoc WITH XsNroDoc
   ENDIF
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE TpoRef WITH [CARGO]
   REPLACE CodRef WITH XsCodDoc     && Se graba la letra con el mismo
                                    && codigo que la refinanciacion
   REPLACE Import WITH AfImport(i)
   REPLACE ImpInt WITH AfImpInt(i)
   REPLACE ImpIgv WITH AfImpIgv(i)
   REPLACE ImpTot WITH AfImpLet(i)
   REPLACE DiaLet WITH AiDiaLet(i)
   REPLACE FchRef WITH AdFchEmi(i)
   REPLACE VtoRef WITH AdFchVto(i)
   i = i + 1
ENDDO

RETURN
************************************************************************ FIN *
* Objeto : Pintar Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

@  0,14 SAY NroDoc
@  1,14 SAY LEFT(CodCli+' '+CLIE->NomAux,41)
@  2,14 SAY IIF(CodMon=1,'S/.','US$')
@  2,28 SAY TpoCmb PICT "99,999.9999"
@  0,64 SAY FchDoc
@  1,64 SAY NroRef
@  2,49 SAY PorIGV PICT "99.99"
@  2,64 SAY PorIPM PICT "99.99"
@ 10,53 SAY ImpDoc PICT "9,999,999.99"
@ 11,48 SAY PidCup
@ 11,53 SAY ImpCup PICT "9,999,999.99"
@ 12,53 SAY (ImpDoc-ImpCup) PICT "9,999,999.99"
DO CASE
   CASE TipInt = [M]
      @ 13,7  SAY 'Mensual'
   CASE TipInt = [A]
      @ 13,7  SAY 'Anual  '
   CASE TipInt = [D]
      @ 13,7  SAY 'Diaria '
   OTHER
      @ 13,7  SAY '       '
ENDCASE
@ 13,21 SAY PorInt PICT "999.99"
@ 14,21 SAY DiaLet PICT "999"
@ 15,21 SAY DiaLib PICT "999"
@ 16,21 SAY CanLet PICT "99"
@ 14,40 SAY GloDoc
@ 15,40 SAY Glosa1
@ 16,40 SAY Glosa2
** pintar detalles **
SELE RASG
SET FILTER TO CodRef # TASG->CodDoc
*
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = [DOCbescl]
EdiLin   = []
BrrLin   = []
GrbLin   = []
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
VClave   = TASG->CodDoc+TASG->NroDoc
HTitle   = 1
Yo       = 5
Xo       = 10
Largo    = 6
Ancho    = 57
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .F.
VSombra  = .F.
DO DBrowse
* * * * * * * * * * * * * *
SELE RASG
SET FILTER TO
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
EscLin   = []
NClave   = [CodDoc+NroDoc+TpoRef+CodRef]
VClave   = TASG->CodDoc+TASG->NroDoc+[CARGO]+TASG->CodDoc
Yo       = 19
Xo       = 3
Largo    = 4
Ancho    = 72
LinReg   = [DTOC(FchRef)+' '+TRANS(DiaLet,'999')+' '+TRANS(Import,'9,999,999.99')+' '+;
            TRANS(ImpInt,'999,999.99')+' '+TRANS(ImpIgv,'999,999.99')+' '+;
            TRANS(ImpTot,'9,999,999.99')+' '+DTOC(VtoRef)]
DO DBrowse
* * * * * * * * * * * * * *
SELE TASG

RETURN
************************************************************************ FIN *
* Objeto : Linea del browse de documentos
******************************************************************************
PROCEDURE DOCbescl
PARAMETER Contenido

SELE GDOC
SET ORDER TO GDOC01
SEEK 'CARGO'+RASG->CodRef+RASG->NroRef
SELE RASG
Contenido = CodRef+' '+NroRef+' '+DTOC(GDOC->FchDoc)+' '+;
            GDOC->CodRef+GDOC->NroRef+' '+TRANS(ImpTot,'9,999,999.99')
SELE GDOC
SET ORDER TO GDOC04
SELE RASG

RETURN
************************************************************************ FIN *
* Objeto : Impresion del documento
******************************************************************************
PROCEDURE xListar

Largo  = 66       && Largo de pagina
Ancho  = 80
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
IniImp = _Prn1
DO admprint
IF LASTKEY() = Escape
   RETURN
ENDIF
** variables de impresion **
Titulo    = []
SubTitulo = []
Tit_SIzq  = GsNomCia
Tit_IIzq  = []
Tit_SDer  = []
En1       = []
En2       = []
En3       = []
En4       = []
En5       = []
En6       = []
En7       = []
En8       = []
En9       = []
NumLin    = 0
** inicio de impresion **
SELE RASG
SEEK XsCodDoc+XsNroDoc
STORE RECNO() TO REGINI
SET DEVICE TO PRINT
PRINTJOB
   NumPag = 0
   GO REGINI
   iCuenta = 1
   SCAN WHILE CodDoc+NroDoc = XsCodDoc+XsNroDoc ;
        FOR CodRef # XsCodDoc
      IF PROW() >= Largo-25 .OR. NumPag = 0
         DO xMEMBRETE
      ENDIF
      iImpTot = ROUND(ImpTot/(1+TASG->PorIgv/100),2)
      IF iCuenta%2 > 0
         @ PROW()+1,10 SAY CodRef
         @ PROW()  ,15 SAY NroRef
         @ PROW()  ,27 SAY iImpTot PICT "@( 999,999,999.99"
      ELSE
         @ PROW()  ,45 SAY CodRef
         @ PROW()  ,50 SAY NroRef
         @ PROW()  ,62 SAY iImpTot PICT "@( 999,999,999.99"
      ENDIF
      iCuenta = iCuenta + 1
   ENDSCAN
   DO xPIEPAG
ENDPRINTJOB
DO ADMPRFIN IN ADMPRINT


*          1         2         3         4         5         6         7        8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
* VIDRIOS INDUSTRIALES
*
*     PROFORMA : 1234567890                                  FECHA : 99/99/99
*     CLIENTE  : 12345678 12345678901234567890123456789012345678901234567890
*     PEDIDO   : 1234567890
*     DETALLE  : 1234567890123456789012345678901234567890
*                1234567890123456789012345678901234567890
*                1234567890123456789012345678901234567890
*     MONEDA   : S/.                                TIPO DE CAMBIO : 9,999.9999
*--------------------------------------------------------------------------------
*         DOCUMENTO NUMERO      IMPORTE      DOCUMENTO NUMERO      IMPORTE
*--------------------------------------------------------------------------------
*          FACT 1234567890 999,999,999.99     FACT 1234567890 999,999,999.99
*          FACT 1234567890 999,999,999.99     FACT 1234567890 999,999,999.99
*          FACT 1234567890 999,999,999.99     FACT 1234567890 999,999,999.99
*          FACT 1234567890 999,999,999.99     FACT 1234567890 999,999,999.99
*--------------------------------------------------------------------------------
*                          999,999,999.99                     999,999,999.99
*              IPM 02.00%  999,999,999.99         IPM 02.00%  999,999,999.99
*              IGV 16.00%  999,999,999.99         IGV 16.00%  999,999,999.99
*                          --------------                     --------------
*              TOTAL S/.   999,999,999.99         TOTAL S/.   999,999,999.99
*                          ==============                     ==============
*
*     TASA MENSUAL  : 999.99 %
*     LETRAS A DIAS : 999
*     DIAS LIBRES   : 999
*--------------------------------------------------------------------------------
* FECHA           IMPORTE        TOTAL      IGV SOBRE                  FECHA DE
*EMISION  DIAS  A FINANCIAR    INTERESES    INTERESES    TOTAL LETRA   VENCIMTO.
*--------------------------------------------------------------------------------
*99/99/99  999 999,999,999.99 9,999,999.99 9,999,999.99 999,999,999.99 99/99/99
*99/99/99  999 999,999,999.99 9,999,999.99 9,999,999.99 999,999,999.99 99/99/99
*99/99/99  999 999,999,999.99 9,999,999.99 9,999,999.99 999,999,999.99 99/99/99
*--------------------------------------------------------------------------------
*    TOTALES : 999,999,999.99 9,999,999.99 9,999,999.99 999,999,999.99 DOLARES
*                          NOTA DE CARGO : 9,999,999.99                SOLES
*================================================================================
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*          1         2         3         4         5         6         7        8
*

RETURN
************************************************************************ FIN *
* Membrete de Impresion
******************************************************************************
PROCEDURE xMEMBRETE

NumPag    = NumPag + 1

IF NumPag > 1
   EJECT PAGE
ENDIF

IF NumPag = _PBPAGE   && Reset Printer
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF

UltTecla = 0
IF NumPag >= _PBPAGE
   IF  _PWAIT
      SET DEVICE TO SCREEN
      @ 20,20 say "           Pausa entre p ginas          " COLOR SCHEME 7
      @ 21,20 say "     Presione [Enter] para continuar    " COLOR SCHEME 7
      ?? CHR(7)
      @ 21,35 say "Enter" COLOR W*/N
      UltTecla = 0
      DO WHILE ! (UltTecla = Enter .OR. UltTecla = Escape)
         UltTecla = INKEY(0)
      ENDDO
      IF UltTecla = Escape
         SET DEVICE TO PRINTER
         RETURN
      ENDIF
      @ 20,20 say "                                        "    COLOR SCHEME 11
      @ 20,25 say "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
      @ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n "    COLOR SCHEME 11
      SET DEVICE TO PRINTER
   ENDIF
ENDIF
IF GlRunDos
   SET DEVICE TO SCREEN
   @ 20,20 say "                                        "    COLOR SCHEME 11
   @ 20,25 say   "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
   SET DEVICE TO PRINTER
ENDIF

ColTit = (Ancho - LEN(Titulo) - 1)/2
ColSTt = (Ancho - LEN(SubTitulo) - 1)/2
MrgIzq = (Ancho - LEN(En9) - 1)/2
ColDer =  Ancho - LEN(Tit_Sder) - 1

* - Imprimir el encabezado de la p gina.
NumLin = 0
   @ NumLin,0      SAY IniImp
   @ NumLin,0      SAY Tit_SIzq
   @ NumLin,ColTit SAY Titulo
   @ NumLin,ColDer SAY Tit_Sder

NumLin = NumLin + 1
   @ NumLin,0        SAY Tit_IIzq
   @ NumLin,ColSTt   SAY SubTitulo
   @ NumLin,Ancho-14 SAY "PAGINA: "+STR(NumPag,5)

SELE TASG
@ PROW()+1,0  SAY "REFINANCIACION: "+NroDoc
@ PROW()  ,60 SAY "FECHA : "+DTOC(FchDoc)
@ PROW()+1,5  SAY "CLIENTE  : "+CodCli+' '+CLIE->NomAux
@ PROW()+1,5  SAY "PEDIDO   : "+NroRef
@ PROW()+1,5  SAY "DETALLE  : "+GloDoc
@ PROW()+1,16 SAY Glosa1
@ PROW()+1,16 SAY Glosa2
@ PROW()+1,5  SAY "MONEDA   : "+IIF(CodMon=1,'S/.','US$')
@ PROW()  ,51 SAY "TIPO DE CAMBIO : "+TRANS(TpoCmb,'9,999.9999')
@ PROW()+1,0  SAY "--------------------------------------------------------------------------------"
@ PROW()+1,0  SAY "         DOCUMENTO NUMERO      IMPORTE      DOCUMENTO NUMERO      IMPORTE       "
@ PROW()+1,0  SAY "--------------------------------------------------------------------------------"
SELE RASG

RETURN
************************************************************************ FIN *
* Fin de Impresion
******************************************************************************
PROCEDURE xPIEPAG

@ PROW()+1,0 SAY REPLI("-",Ancho)
iCuenta = iCuenta - 1
IF iCuenta = 1
   @ PROW()+1,28 SAY TASG->ImpBto PICT "999,999,999.99"
   IF TASG->PidCup = 'S'
      iImpIpm = ROUND(TASG->ImpBto*TASG->PorIpm/100,2)
      iImpIgv = TASG->ImpDoc - (TASG->ImpBto+iImpIpm)
      @ PROW()+1,14 SAY "IPM "+TRANS(TASG->PorIpm,'99.99')+'%'
      @ PROW()  ,28 SAY iImpIpm PICT "999,999,999.99"
      @ PROW()+1,14 SAY "IGV "+TRANS(TASG->PorIgv-TASG->PorIpm,'99.99')+'%'
      @ PROW()  ,28 SAY iImpIgv PICT "999,999,999.99"
      @ PROW()+1,28 SAY "--------------"
      @ PROW()+1,14 SAY "TOTAL "+IIF(TASG->CodMon=1,'S/.','US$')
      @ PROW()  ,28 SAY TASG->ImpDoc PICT "999,999,999.99"
      @ PROW()+1,28 SAY "=============="
   ELSE
      @ PROW()+1,14 SAY "IGV "+TRANS(TASG->PorIgv,'99.99')+'%'
      @ PROW()  ,28 SAY TASG->ImpIgv PICT "999,999,999.99"
      @ PROW()+1,28 SAY "--------------"
      @ PROW()+1,28 SAY TASG->ImpDoc PICT "999,999,999.99"
      @ PROW()+1,28 SAY "=============="
   ENDIF
ELSE
   @ PROW()+1,63 SAY TASG->ImpBto PICT "999,999,999.99"
   IF TASG->PidCup = 'S'
      iImpIpm = ROUND(TASG->ImpBto*TASG->PorIpm/100,2)
      iImpIgv = TASG->ImpDoc - (TASG->ImpBto+iImpIpm)
      @ PROW()+1,49 SAY "IPM "+TRANS(TASG->PorIpm,'99.99')+'%'
      @ PROW()  ,63 SAY iImpIpm PICT "999,999,999.99"
      @ PROW()+1,49 SAY "IGV "+TRANS(TASG->PorIgv-TASG->PorIpm,'99.99')+'%'
      @ PROW()  ,63 SAY iImpIgv PICT "999,999,999.99"
      @ PROW()+1,63 SAY "--------------"
      @ PROW()+1,49 SAY "TOTAL "+IIF(TASG->CodMon=1,'S/.','US$')
      @ PROW()  ,63 SAY TASG->ImpDoc PICT "999,999,999.99"
      @ PROW()+1,63 SAY "=============="
   ELSE
      @ PROW()+1,49 SAY "IGV "+TRANS(TASG->PorIgv,'99.99')+'%'
      @ PROW()  ,63 SAY TASG->ImpIgv PICT "999,999,999.99"
      @ PROW()+1,63 SAY "--------------"
      @ PROW()+1,63 SAY TASG->ImpDoc PICT "999,999,999.99"
      @ PROW()+1,63 SAY "=============="
   ENDIF
ENDIF
cTipInt = []
DO CASE
   CASE TASG->TipInt = [M]
      cTipInt = [MENSUAL]
   CASE TASG->TipInt = [D]
      cTipInt = [DIARIO ]
   CASE TASG->TipInt = [A]
      cTipInt = [ANUAL  ]
   OTHER
      cTipInt = [       ]
ENDCASE
@ PROW()+2, 5 SAY "TASA "+cTipInt+"  : "+TRANS(TASG->PorInt,'999.99')+'%'
@ PROW()+1, 5 SAY "LETRAS A DIAS : "+TRANS(TASG->DiaLet,'999')
@ PROW()+1, 5 SAY "DIAS LIBRES   : "+TRANS(TASG->DiaLib,'999')
IF TASG->ImpCup > 0
   @ PROW()+1, 5 SAY "CUPON IGV     : "+TRANS(TASG->ImpCup,'999,999,999.99')
ENDIF
@ PROW()+1, 0 SAY "--------------------------------------------------------------------------------"
@ PROW()+1, 0 SAY " FECHA           IMPORTE        TOTAL      IGV SOBRE                  FECHA DE  "
@ PROW()+1, 0 SAY "EMISION  DIAS  A FINANCIAR    INTERESES    INTERESES    TOTAL LETRA   VENCIMTO. "
@ PROW()+1, 0 SAY "--------------------------------------------------------------------------------"
SEEK TASG->CodDoc+TASG->NroDoc
STORE 0 TO iImport,iImpInt,iImpIgv,iImpTot
SCAN WHILE CodDoc+NroDoc=TASG->CodDoc+TASG->NroDoc ;
     FOR CodRef = TASG->CodDoc
   @ PROW()+1,0  SAY FchRef
   @ PROW()  ,10 SAY DiaLet PICT "999"
   @ PROW()  ,14 SAY Import PICT "999,999,999.99"
   @ PROW()  ,29 SAY ImpInt PICT "9,999,999.99"
   @ PROW()  ,42 SAY ImpIgv PICT "9,999,999.99"
   @ PROW()  ,55 SAY ImpTot PICT "999,999,999.99"
   @ PROW()  ,70 SAY VtoRef
   iImport = iImport + Import
   iImpInt = iImpInt + ImpInt
   iImpIgv = iImpIgv + ImpIgv
   iImpTot = iImpTot + ImpTot
ENDSCAN
@ PROW()+1,0  SAY REPLI("-",Ancho)
@ PROW()+1,4  SAY "TOTALES :"
@ PROW()  ,14 SAY iImport PICT "999,999,999.99"
@ PROW()  ,29 SAY iImpInt PICT "9,999,999.99"
@ PROW()  ,42 SAY iImpIgv PICT "9,999,999.99"
@ PROW()  ,55 SAY iImpTot PICT "999,999,999.99"
@ PROW(),PCOL()+1 SAY IIF(TASG->CodMon=1,'SOLES','DOLARES')
IF iImpInt+iImpIgv>0
   @ PROW()+1,26 SAY "NOTA DE CARGO :"
   @ PROW()  ,42 SAY (iImpInt+iImpIgv) PICT "9,999,999.99"
ENDIF
@ PROW()+1,0  SAY REPLI("=",Ancho)
EJECT PAGE

RETURN
************************************************************************ FIN *
