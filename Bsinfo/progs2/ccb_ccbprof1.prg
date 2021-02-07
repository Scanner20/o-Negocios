 ********************************************************************************
* Programa     : ccbprof1.prg                                                  *
* Sistema      : Cuentas por Cobrar                                            *
* Autor        : VETT                                                           *
* Proposito    : Ingreso de Proformas                                          *
* Creacion     : 03/02/94                                                      *
* Parametros   :                                                               *
* Actualizacion:RHC 02/02/94 Ya que se modifica las condiciones de calculo     *
*                            tambien que se recalculen las letras.             *
*               VETT 24/08/95 MODIFICACION DE FORMATO DE IMPRESION             *
*               VETT 29/08/95 generer n/debito , canje y asiento si se aprueba *
*               canje FlgEst = "E",imprimir todos los documentos               *
*               Contralar el tipo de proforma : TipPro:1,2,3                   *
*               1 Fch. Facturas = F.Proforma y una letra                       *
*               2 Fch. Facturas = F.Proforma y varias letras                   *
*               3 Fch. Facturas <>F.Proforma y varias letras                   *
********************************************************************************
*
IF !verifyvar('GsRegirV','C')
	return
ENDIF
*
IF !verifyvar('GsProCcb','C')
	return
ENDIF
*
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO fondo WITH 'Proformas',Goentorno.user.login,GsNomCia,GsFecha
** Pantalla de Datos **
STORE '' TO xPantalla
DO xPanta
** base de datos **
**********************************
* Aperturando Archivos a usar    *
**********************************
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
LoDatAdm.abrirtabla('ABRIR','CCTCDIRE','DIRE','DIRE02','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC04','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNRASG','RASG','RASG01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNTASG','TASG','TASG01','')
LODATADM.ABRIRTABLA('ABRIR','CJATPROV','PROV','PROV01','')
LODATADM.ABRIRTABLA('ABRIR','CBDTCNFG','CNFG','CNFG01','')
LoDatAdm.abrirtabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
RELEASE LoDatAdm

SELECT cnfg
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
   DO LIB_MERR WITH 99
   DO CLOSE_FILE IN CCB_CCBAsign
   SYS(2700,1)
   RETURN
ENDIF
XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
USE

*
*!*	SELE 0
*!*	USE cbdmauxi ORDER AUXI01 ALIAS AUXI
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE ccbntasg ORDER TASG01 ALIAS TASG
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	SELE 0
*!*	USE ccbtbdoc ORDER BDOC01  ALIAS TDOC
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	SELE 0
*!*	USE ccbrgdoc ORDER GDOC04 ALIAS GDOC
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	SELE 0
*!*	USE ccbnrasg ORDER RASG01 ALIAS RASG
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	USE ccbmvtos IN 0 ORDER VTOS01 ALIAS VTOS
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	USE ccbsaldo IN 0 ORDER SLDO01 ALIAS SLDO
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*SELE 0
*USE ccbrrdoc ORDER RDOC01 ALIAS RDOC
*IF !USED()
*   CLOSE DATA
*   RETURN
*ENDIF
**
*SELE 0
*USE cbdmtabl ORDER TABL01 ALIAS TABLA
*IF !USED()
*   CLOSE DATA
*   RETURN
*ENDIF
** BASES DE CONTABILIDAD **
*!*	SELE 0
*!*	USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	SELE 0
*!*	USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF

** relaciones a usar **
SELECT TASG
SET RELATION TO GsClfCli+CodCli INTO AUXI
** variables a usar **
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XsGloDoc,XsGlosa1,XsGlosa2
PRIVATE XiCodMon,XfTpoCmb,XfPorIgv,XfPorIpm,XsCodRef,XsNroRef,XfImpDoc,XfIntDoc
PRIVATE XfImpBto,XfImpIgv,XcFlgEst,XfIntIgv
PRIVATE XfImpCup,XcPidCup,XfPorInt,XcTipInt,XiDiaLet,XiDiaLib,XiCanLet
PRIVATE m.ImpCup     && Variable de Control del valor de la Cuponera IGV
PRIVATE m.NroDoc     && Control de Correlativo Multiuser
ZsCodDoc = [CANJ]
ZsNroDoc = SPACE(LEN(TASG->NroDoc))
XsCodDoc = [PROF]    && Proforma
m.NroDoc = 0
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
XfIntDoc = 0.00
XfIntIgv = 0.00
XfImpBto = 0.00
XfImpIgv = 0.00
XfImpCup = 0.00
XiTipTas = 1
XcFlgEst = [P]
XiTipPro = 1
LsGloLet = []
m.FchN_D = DATE()
m.FchCje = DATE()
XdFchPro = DATE()
** Variables del Browse **
* browse de   documentos *
PRIVATE AsCodDoc,AsNroDoc,AdFchDoc,AsTpoRef,AsCodRef,AsNroRef,AfImpTot,GiTotDoc
PRIVATE AiDelDoc,GiDelDoc
CIMAXELE = 200
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
PRIVATE AiDelLet,GiDelLet,AsNroLet
DIMENSION AsNroLet(CIMAXELE)
DIMENSION AdFchEmi(CIMAXELE)
DIMENSION AdFchVto(CIMAXELE)
DIMENSION AiDiaLet(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AfImpInt(CIMAXELE)
DIMENSION AfImpIgv(CIMAXELE)
DIMENSION AfImpLet(CIMAXELE)
DIMENSION AiRegLet(CIMAXELE)
DIMENSION AiDelLet(CIMAXELE)
STORE SPACE(LEN(GDOC->NroDoc)) TO AsNroLet
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

** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
XsCodOpe = GsProCcb  && [004]  && << OJO <<
** Logica Principal **
SELE TASG
DO LIB_MTEC WITH 3
xCodDoc = XsCodDoc
UltTecla = 0
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],'xListar',;
              [CodDoc],XCodDoc,'CMAR'

DO CLOSE_FILE IN CCB_CCBAsign
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)

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
*9          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ TOTAL DOCUMENTOS    : 9,999,999.99 Ù
*0                                     IGV (S-N)? 1  : 9,999,999.99
*1                               INT.  POR DOCUMENTOS: 9,999,999.99
*2  Tipo Tasa    : Adelantada    IMPORTE A FINANCIAR : 9,999,999.99
*3  Tasa Mensual : 999.99 %      IGV. INT. DOCUMENTOS: 9,999,999.99
*4  Letra a Dias : 999            Glosa : 123457890123457890123457890123457890
*5  Dias Libres  : 999                    123457890123457890123457890123457890
*6  #  de Letras : 99                     123457890123457890123457890123457890
*7   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*8   ³ Emision  Dias   Importe    Interes       IGV        Total     Vence  ³
*9   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0   ³ 99/99/99 123 9,999,999.99 999,999.99 999,999.99 9,999,999.99 99/99/99³
*1   ³ 99/99/99 123 9,999,999.99 999,999.99 999,999.99 9,999,999.99 99/99/99³
*2   ÀÄÄ- TOTALES : 9,999,999.99 999,999.99 999,999.99 9,999,999.99 ÄÄÄÄÄÄÄÄÙ
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*           1         2         3         4         5         6         7        8
CLEAR

@  0,0  SAY "  Proforma:                                            Fecha  :            "
@  1,0  SAY "  Cliente :                                            Pedido :            "
@  2,0  SAY "  Moneda  :            T/C:               %IGV :         %IPM :            "
@  3,0  say "                                                                           "
@  4,0  SAY "          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿        "
@  5,0  SAY "          ³    Documento     Fecha     Referencia      Importe    ³        "
@  6,0  SAY "          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´        "
@  7,0  SAY "          ³                                                       ³        "
@  8,0  SAY "          ³                                                       ³        "
@  9,0  SAY "          ³                                                       ³        "
@ 10,0  SAY "          ³                                                       ³        "
@ 11,0  SAY "          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ TOTAL DOCUMENTOS    :              Ù        "
@ 12,0  SAY "  Tipo Tasa    :                     IGV (S-N)? 1  :                       "
@ 13,0  SAY "                               INT.  POR DOCUMENTOS:                       "
@ 14,0  SAY " Tasa  Mensual :               IMPORTE A FINANCIAR :                       "
@ 15,0  SAY "  Letra a Dias :                Glosa :                                    "
@ 16,0  SAY "  Dias Libres  :                                                           "
@ 17,0  SAY "  #  de Letras :                                                           "
@ 18,0  SAY "  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 19,0  SAY "  ³ Emision  Dias   Importe    Interes       IGV        Total     Vence       ³"
@ 20,0  SAY "  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,0  SAY "  ³                                                                           ³"
@ 22,0  SAY "  ³                                                                           ³"
@ 23,0  SAY "  ÀÄÄÄÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄ-ÄÄÄÄÄÄÙ"
@  5,11 SAY "    Documento     Fecha     Referencia      Importe    " COLOR SCHEME 7
@ 11,30 SAY " TOTAL DOCUMENTOS    :" COLOR SCHEME 11
@ 12,30 SAY "       IGV (S-N)? 1  :" COLOR SCHEME 11
@ 13,30 SAY " INT.  POR DOCUMENTOS:" COLOR SCHEME 11
@ 14,30 SAY " IMPORTE A FINANCIAR :" COLOR SCHEME 11
@ 19,4  SAY " Emisi¢n  Dias   Importe    Interes       IGV        Total     Vence  " COLOR SCHEME 7
@ 24,8  SAY " TOTALES :" COLOR SCHEME 11

SAVE SCREEN TO xPantalla
RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave
RESTORE SCREEN FROM xPantalla
SELE TASG
IF &sesrgv
   XsNroDoc = TASG->NroDoc
ELSE
   * buscamos correlativo
   IF !SEEK(XsCodDoc,"TDOC")
      WAIT "No existe correlativo" NOWAIT WINDOW
      UltTecla = Escape_
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
DO WHILE ! INLIST(UltTecla,Escape_,Enter)
   @ 0,14 GET XsNroDoc PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Escape_)
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
IF &sesrgv
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
   cTecla = [Escape_,F10,CtrlW]
ELSE
   DO xInvar
   cTecla = [Escape_]
ENDIF
*
@ 0,64 GET XdFchDoc PICT "@RD DD/MM/AAAA"
@ 1,14 GET XsCodCli PICT "@!"
@ 1,64 GET XsNroRef PICT "@!"
@ 2,28 GET XfTpoCmb PICT "99,999.9999"
@ 2,49 GET XfPorIgv PICT "99.99"
@ 2,64 GET XfPorIpm PICT "99.99"
@ 12,48 GET XcPidCup PICT "!"
@ 12,53 GET XfImpCup PICT "9,999,999.99"
@ 13,17 SAY IIF(XiTipTas=1,"Vencida   ","Adelantada")
@ 14,18 GET XfPorInt PICT "999.99"
@ 15,17 GET XiDiaLet PICT "999"
@ 16,17 GET XiDiaLib PICT "999"
@ 17,17 GET XiCanLet PICT "99"
@ 15,40 GET XsGloDoc
@ 16,40 GET XsGlosa1
@ 17,40 GET XsGlosa2
CLEAR GETS
IF !Crear
   @  1,14 SAY XsCodCli PICT "@!"
   @  1,64 SAY XsNroRef PICT "@!"
   @  3,13 SAY IIF(XiCodMon=1,'S/.','US$')
   @  2,28 SAY XfTpoCmb PICT "99,999.9999"
   @ 13,53 SAY XfIntDoc                               PICT "9,999,999.99"
   @ 14,18 SAY XfPorInt PICT "999.99"
   @ 14,53 SAY (XfImpDoc-XfImpCup)+XfIntDoc           PICT "9,999,999.99"
   @ 15,17 SAY XiDiaLet PICT "999"
   @ 16,17 SAY XiDiaLib PICT "999"
   @ 17,17 SAY XiCanLet PICT "99"
ENDIF
vRegAct = RECNO()
eof1= eof()
ZsNroDoc = []
LsGloLet = []
SET ORDER TO TASG05
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodRef+NroRef = XsCodDoc+XsNroDoc
     IF CodDoc = "CANJ" AND FlgEst#"A"
        ZsNroDoc = NroDoc
        SELE GDOC
        SET ORDER TO GDOC03
        SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
        SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc="Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
             LsGloLet = LsGloLet+TRIM(NroDoc)+","
        ENDSCAN
        SELE TASG
        EXIT
     ENDIF
ENDSCAN
SET ORDER TO TASG01
IF Eof1
   GO BOTTOM
ELSE
   GO vRegAct
ENDIF
IF !EMPTY(ZsNroDoc)
   GsMsgErr = [ Proforma ha generado canje :]+ZsNroDoc
   DO lib_merr WITH 99
   UNLOCK
   Do xListar
   SELE TASG
   RETURN
ENDIF
*
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,&cTecla.)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         @ 0,64 GET XdFchDoc PICT "@RD DD/MM/AAAA"
         READ
         UltTecla = LASTKEY()
         @ 0,64 SAY XdFchDoc PICT "@RD DD/MM/AAAA"
      CASE i = 2 .AND. Crear
         GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
         DO lib_mtec WITH 99
         SELE AUXI
         @ 1,14 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(XsCodCli) .OR. UltTecla = F8
            IF ! ccbbusca("CLIE")
               LOOP
            ENDIF
            XsCodCli = AUXI->CodAux
         ENDIF
         SEEK GsClfCli+XsCodCli
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         @ 1,14 SAY LEFT(XsCodCli+' '+AUXI->NomAux,41)
      CASE i = 3 .AND. Crear
         @ 1,64 GET XsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         @ 1,64 SAY XsNroRef PICT "@!"
      CASE i = 4 .AND. Crear
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,3,11,2)
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
         @ 12,48 GET XcPidCup PICT "!" VALID(XcPidCup$'SN')
         READ
         UltTecla = LASTKEY()
      CASE i = 10 .AND. XcPidCup = 'S'
         ** calculamos importe de la cuponera **
         XfImpCup = m.ImpCup
         @ 12,53 GET XfImpCup PICT "9,999,999.99" VALID(XfImpCup>=0 .AND. XfImpCup<=m.ImpCup)
         READ
         UltTecla = LASTKEY()
         @ 12,53 SAY XfImpCup                      PICT "9,999,999.99"
         @ 14,53 SAY (XfImpDoc-XfImpCup)+XfIntDoc  PICT "9,999,999.99"
      CASE i = 10 .AND. XcPidCup = 'N'
         STORE 0 TO XfImpCup
         @ 12,53 SAY XfImpCup                      PICT "9,999,999.99"
         @ 14,53 SAY (XfImpDoc-XfImpCup)+XfIntDoc  PICT "9,999,999.99"
      CASE i = 11    &&   .AND. Crear
         DO lib_mtec WITH 16
         VecOpc(1)="Vencida   "
         VecOpc(2)="Adelantada"
         XiTipTas= Elige(XiTipTas,13,17,2)
      CASE i = 12   && .AND. Crear
         DO lib_mtec WITH 16
         VecOpc(1)="Mensual"
         VecOpc(2)="Anual"
         VecOpc(3)="Diario"
         XcTipInt= Elige(XcTipInt,14,7,3)
      CASE i = 13    && .AND. Crear
         @ 14,18 GET XfPorInt PICT "999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 14,18 SAY XfPorInt PICT "999.99"
         DO DocbInte
      CASE i = 14    && .AND. Crear
         @ 15,17 GET XiDiaLet PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 15,17 SAY XiDiaLet PICT "999"
      CASE i = 15    && .AND. Crear
         @ 16,17 GET XiDiaLib PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 16,17 SAY XiDiaLib PICT "999"
      CASE i = 16   && .AND. Crear
         @ 17,17 GET XiCanLet PICT "99" VALID(XiCanLet>0)
         READ
         UltTecla = LASTKEY()
         @ 17,17 SAY XiCanLet PICT "99"
      CASE i = 17
         @ 15,40 GET XsGloDoc
         READ
         UltTecla = LASTKEY()
         @ 15,40 SAY XsGloDoc
      CASE i = 18
         @ 16,40 GET XsGlosa1
         READ
         UltTecla = LASTKEY()
         @ 16,40 SAY XsGlosa1
      CASE i = 19
         @ 17,40 GET XsGlosa2
         READ
         UltTecla = LASTKEY()
         @ 17,40 SAY XsGlosa2
      CASE i = 20
         DO LETBrows
   ENDCASE
   IF i = 20 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>20,20,i)
ENDDO
IF UltTecla # Escape_
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
XiTipTas = TASG->TipTas
XfIntDoc = TASG->IntDoc
XfIntIgv = TASG->IntIgv
XiTipPro = TASG->TipPro
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
XfIntDoc = 0.00
XfImpBto = 0.00
XfImpIgv = 0.00
XfImpCup = 0.00
XcFlgEst = [P]
XiTipTas = 1
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
* Variables Contables *
_MES     = 0
XsNroMes = SPACE(LEN(GDOC.NroMes))
XsNroAst = SPACE(LEN(GDOC.NroAst))
XsCodOpe = GsProCcb && [004]  && << OJO <<
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
REPLACE TipTas WITH XiTipTas
REPLACE IntDoc WITH XfIntDoc
REPLACE IntIgv WITH XfIntIgv
XiTipPro = _TipPro()
REPLACE TipPro WITH XiTipPro
XdFchPro = XdFchDoc
** Grabamos Browse **
LfND_Int = IntDoc
LfND_Igv = 0
DO DOCbgrab
DO LETbgrab
SELE TASG
xRegAct = RECNO()
*********************
SAVE SCREEN TO Belu1
** preguntar aprobacion de letras **
cResp = [S]
cResp = Aviso(12,[Procedemos al canje (S/N) ? ],[],[],2,'SN',0,.t.,.f.,.T.)
IF cResp = "S"
   m.FlgEst = [P]
   cResp1= [N]
   cResp1= Aviso(12,[Aprobamos letras (S/N) ? ],[],[],2,'SN',0,.t.,.f.,.T.)
   IF cResp1 = [S]
       m.FlgEst = "E"    && Aprobado
   ENDIF
   ** Pedir Fecha de n/debito   **
   @ 11,24 CLEAR TO 13,56
   @ 11,24 TO 13,56 DOUBLE COLOR SCHEME 7
   m.FchN_D = DATE()
   UltTecla = 0
   DO WHILE !INLIST(UltTecla,Escape_,Enter)
      @ 12,25 SAY "Fecha de N/Debito   :" GET m.FchN_D PICT "@RD DD/MM/AAAA"
      READ
      UltTecla = LASTKEY()
   ENDDO
   IF UltTecla = Escape_
      SELE TASG
      RETURN
   ENDIF
   XdFchDoc=m.FchN_D
   IF !ctb_aper(XdFchDoc)
      i = 1
      UltTecla = 0
      SELE TASG
      RETURN
   ENDIF
   DO xGraba1
ELSE
   DO xListar
ENDIF
REST SCREEN FROM Belu1
SELE TASG
XdFchDoc = XdFchPro
GO xRegAct
RETURN
*****************
PROCEDURE xGraba1
*****************
WAIT "CHEQUEANDO INFORMACION..." NOWAIT WINDOW
** primero verificamos los numeros de letras a usar **
=SEEK([LETR],[TDOC])
m.LetIni = TDOC->NroDoc
IF !LETbIni1()
	RETURN 
ENDIF
** segundo verificamos correaltivo de n/debito **
IF !SEEK("N/D","TDOC")
   WAIT "No existe correlativo de N/Debito" NOWAIT WINDOW
   UltTecla = Escape_
   RETURN
ENDIF
** Tercero fecha del canje en contabilidad **
@ 12,24 CLEAR TO 14,56
@ 12,24 TO 14,56 DOUBLE COLOR SCHEME 7
m.FchCje = XdFchDoc
UltTecla = 0
DO WHILE !INLIST(UltTecla,Escape_,Enter)
   @ 12,25 SAY "Fecha de Canje      :" GET m.FchCje PICT "@RD DD/MM/AAAA"
   READ
   UltTecla = LASTKEY()
ENDDO
IF UltTecla = Escape_
   SELE TASG
   RETURN
ENDIF
XdFchDoc = m.FchCje
IF !ctb_aper(XdFchDoc)
   SELE TASG
   RETURN
ENDIF
** Saldo del cliente
SELECT SLDO
SEEK XsCodcli
IF !RLOCK()
   RETURN
ENDIF
** Correlativo del canje
SELECT TDOC
SEEK "CANJ"
IF !RLOCK()
   RETURN
ENDIF
ZsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(TASG->NroDoc))
** Si no hay problemas comenzamos a grabar **
** nos posicionamos en la proforma  **
SELECT TASG
SEEK XsCodDoc+XsNroDoc
IF ! RLOCK()
   RETURN
ENDIF
**  Abrimos registro para el canje  **
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
**  Correlativo del canje **
SELECT TDOC
IF VAL(ZsNrodoc)>= NroDoc
   REPLACE NroDoc WITH VAL(ZsNrodoc)+1
ENDIF
UNLOCK
**
SELECT TASG
REPLACE CodDoc WITH ZsCoddoc
REPLACE NroDoc WITH ZsNrodoc
REPLACE FchDoc WITH XdFchdoc
REPLACE CodCli WITH XsCodcli
REPLACE GloDoc WITH XsGlodoc
REPLACE CodMon WITH XiCodmon
REPLACE TpoCmb WITH XfTpocmb
REPLACE ImpDoc WITH XfImpdoc
REPLACE FlgEst WITH m.FlgEst
* * * *
REPLACE CodRef WITH XsCodDoc
REPLACE NroRef WITH XsNroDoc
ZiRegAct = RECNO()
** Creamos n/debito **
FOR j=1 TO GiTotLet
    LfND_Int = LfND_Int + AfImpInt(j)
    LfND_Igv = LfND_Igv + AfImpIgv(j)
ENDFOR
IF (LfND_Int + LfND_Igv)>0
    WAIT "Generando Nota de Debito..." NOWAIT WINDOW
    XdFchDoc = m.FchN_D
    DO xCrear_ND
ENDIF
XdFchDoc = m.FchCje
WAIT "Generando Canje en base a proforma..." NOWAIT WINDOW
SELE TASG
GO ZiRegAct
** generamos detalles **
j = 1
DO WHILE j <= GiTotDoc
   Do CjLActDoc WITH AsCodDoc(j),AsNroDoc(j),AfImpTot(j)
   j = j + 1
ENDDO
**
j = 1
LsGloLet = []
DO WHILE j <= GiTotLet
   LsGloLet = LsGloLet+TRIM(AsNroLet)+IIF(j<GiTotLet,",","")
   LsNroDoc = AsNroLet(j)
   LdFchDoc = AdFchEmi(j)
   LdFchVto = AdFchVto(j)
   LfImpTot = AfImpLet(j)
   Do CjLActLet
   j = j + 1
ENDDO
** ACTUALIZACION CONTABLE **
IF TASG.FlgEst = [E]
   WAIT "Generando Asiento del canje..." NOWAIT WINDOW
   =Ctb_Aper(XdFchDoc)
   DO xACT_CTB IN ccb_ccbcjap1
ENDIF
WAIT "Impresi¢n de documentos ..." NOWAIT WINDOW
GsMsgErr = "Coloque papel para imprimir PROFORMA"
DO LIB_MERR WITH 99
SELE TASG
SEEK XsCodDoc+XsNroDoc        && Proforma
DO xListar
* * * * * * * * * * * * * * *
SELE TASG
SEEK ZsCodDoc+ZsNroDoc           && Canje
IF TASG->FlgEst = [E]
   SEEK XsCodDoc+XsNroDoc        && Proforma
   REPLACE FlgEst WITH [E]       && Gener¢ letras
ENDIF
**
IF (LfND_Int + LfND_Igv)>0
   GsMsgErr = "Coloque papel para imprimir NOTA DE DEBITO"
   DO LIB_MERR WITH 99
   DO xImp_ND
ENDIF
**
GsMsgErr = "Coloque papel para imprimir LETRA(S)"
DO LIB_MERR WITH 99
DO xImp_Let
RETURN
*****************
PROCEDURE xImp_ND
*****************
DO CierDbf2
IF !AbreDbf1()
   GsMsgErr = "No se puede imprimir NOTA DE DEBITO"
   DO LIB_MERR WITH 99
   DO CierDbf1
   =AbreDbf2()
   RETURN
ENDIF
** Nos posicionamos en la nota de debito **
SELE RDOC
SET RELA TO 'NC'+Codigo INTO TABLA
SELE GDOC
SET ORDER TO GDOC04
SEEK XsCodcli+"C"+"CARGO"+AsCodDoc(GiTotDoc)+AsNroDoc(GiTotDoc)
DO xListar IN ccb_CcbNcar1
DO Cierdbf1
=AbreDbf2()
RETURN
******************
PROCEDURE xImp_Let
******************
SAVE SCREEN TO BELU
PRIVATE vClave,nClave,Largo,LinFin
SELE TASG               && Canje
SEEK ZsCodDoc+ZsNrodoc
SELE GDOC
SET ORDER TO GDOC03
NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
VClave   = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
LsGlosa1 = []
LsGlosa2 = []
LsGlosa3 = []
LsGlosa4 = []

SEEK VClave
XFOR   = ".T."
XWHILE = [TpoRef+CodRef+NroRef+TpoDoc+CodDoc="Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"]
Largo  = 27       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "ccbr4700"
DO F0print WITH "REPORTS"
RESTORE SCREEN FROM BELU
SELE GDOC
SET ORDER TO GDOC04
SELE TASG
RETURN
*******************
FUNCTION REFERENCIA
*******************
RETURN .F.
*******************
PROCEDURE xCrear_ND
*******************
WAIT "Generando nota de debito" NOWAIT WINDOW
DO CierDbf2
IF !AbreDbf1()
   GsMsgErr = "No se puede generar NOTA DE DEBITO, queda pendiente."
   DO LIB_MERR WITH 99
   DO CierDbf1
   =AbreDbf2()
   RETURN
ENDIF
PRIVATE XsCodDoc,XsNroDoc,XsTpoDoc,XfImpTot,XfImport,XsCodOpe
XsCodOpe= GsRegirV    && "006"   && << OJO
XsCodDoc= "N/D"  && "N/C"
XsTpoDoc="CARGO"
XsNroDoc=SPACE(LEN(GDOC.NroDoc))
** control del correlativo **
SELE GDOC
APPEND BLANK
=REC_LOCK(0)
STORE RECNO() TO iNumReg
** Control de Correlativos **
SELE TDOC
SEEK XsCodDoc
=REC_LOCK(0)
XsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(GDOC->NroDoc))
IF SEEK(XsTpoDoc+XsCodDoc+XsNroDoc,"GDOC")
   GsMsgErr = [ Registro Creado por Otro Usuario ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF VAL(XsNroDoc)>=TDOC->NroDoc
   REPLACE TDOC->NroDoc WITH VAL(XsNroDoc)+1
ENDIF
UNLOCK
*
SELE GDOC
GO iNumReg
REPLACE TpoDoc WITH XsTpoDoc
REPLACE CodDoc WITH XsCodDoc
REPLACE NroDoc WITH XsNroDoc
REPLACE FchDoc WITH XdFchDoc
REPLACE FchEmi WITH XdFchDoc
REPLACE CodCli WITH XsCodCli
REPLACE NomCli WITH IIF(SEEK(GsClfCli+XsCodCli,"AUXI"),AUXI.NomAux,[])
REPLACE DirCli WITH IIF(SEEK(GsClfCli+XsCodCli,"AUXI"),AUXI.DirAux,[])
REPLACE RucCli WITH IIF(SEEK(GsClfCli+XsCodCli,"AUXI"),AUXI.RucAux,[])
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE Glosa1 WITH IIF(SEEK([NC]+[INT],[TABLA]),TABLA.NomBre,"INTERESES POR FINANCIAMIENTO")
REPLACE Glosa2 WITH TASG.CodDoc+":"+TASG.NroDoc+","+TASG.CodRef+":"+TASG.NroRef
REPLACE Glosa3 WITH []
SELE RDOC
STORE 0 TO XfImpTot
FOR K = 1 TO 2
    DO CASE
       CASE k = 1
            XsCodigo = "IGV"  && Igv
            XfImport = LfND_Igv
       CASE k = 2
            XsCodigo = "INT"  && Intereses
            XfImport = LfND_Int
    ENDCASE
    APPEND BLANK
    =REC_LOCK(0)
    REPLACE TpoDoc WITH XsTpoDoc
    REPLACE CodDoc WITH XsCodDoc
    REPLACE NroDoc WITH XsNroDoc
    REPLACE Codigo WITH XsCodigo
    REPLACE Import WITH XfImport
    UNLOCK
    XfImpTot = XfImpTot + Import
ENDFOR
SELE SLDO
IF XiCodMon = 1
   REPLACE CgoNAC WITH CgoNAC + XfImpTot
ELSE
   REPLACE CgoUSA WITH CgoUSA + XfImpTot
ENDIF
UNLOCK
*
SELE GDOC
REPLACE ImpNet WITH XfImpTot
REPLACE ImpTot WITH XfImpTot
REPLACE FchVto WITH XdFchDoc
REPLACE SdoDoc WITH XfImpTot
REPLACE FlgEst WITH [P]
REPLACE FlgUbc WITH [C]
REPLACE FlgSit WITH [ ]
IF XfImpTot > 0
   WAIT "Generando Asiento de la N/Debito..." NOWAIT WINDOW
   DO xACT_CTB IN ccb_CCBNCAR1
ENDIF
SELE GDOC
** Adicionamos al arreglo de documentos
GiTotDoc = GiTotDoc + 1
AsCodDoc(GiTotDoc) = CodDoc
AsNroDoc(GiTotDoc) = NroDoc
AfImpTot(GiTotDoc) = SdoDoc
UNLOCK
DO CierDbf1
=AbreDbf2()
SELE GDOC
RETURN
************************************************************************** FIN
* Cancelando Documentos
***************************************************************************
PROCEDURE CjLActDoc
PARAMETER cCodDoc,cNroDoc,nImpTot

PRIVATE LfImpDoc
SELECT GDOC
SEEK XsCodcli+"P"+"CARGO"+cCodDoc+cNroDoc
IF !RLOCK()
   RETURN
ENDIF
************************************************************************
** SI ESTA APROBADO SE GRABA EN VTOS, SI NO LO ESTA, SE GRABA EN RASG **
************************************************************************
IF TASG->FlgEst = [E]
   SELECT VTOS
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
ELSE
   SELECT RASG
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
LsAlias = ALIAS()
******************************************************
* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
******************************************************
IF TASG->FlgEst = "E"   && Canje Aprobado
   ** actualizamos documento origen **
   SELECT GDOC
   LfImpDoc = nImpTot
   IF CodMon <> Xicodmon
      IF Xicodmon = 1
         LfImpDoc = nImpTot / XfTpocmb
      ELSE
         LfImpDoc = nImpTot * XfTpocmb
      ENDIF
   ENDIF
   REPLACE SdoDoc WITH SdoDoc - LfImpDoc
   IF SdoDoc <= 0.01
      REPLACE FlgEst WITH 'C'
      REPLACE FchAct WITH XdFchDoc
   ELSE
      REPLACE FlgEst WITH 'P'
   ENDIF
   REPLACE FchAct WITH DATE()
   REPLACE FlgSit WITH 'X'
   UNLOCK
   ** actualizamos saldo del cliente **
   SELECT SLDO
   IF GDOC->CodMon = 2
      REPLACE CgoUSA WITH CgoUSA - LfImpDoc
   ELSE
      REPLACE CgoNAC WITH CgoNAC - LfImpDoc
   ENDIF
ENDIF
***** Actualiza el movimiento realizado ****
SELECT (LsAlias)
REPLACE CodDoc WITH ZsCoddoc
REPLACE NroDoc WITH ZsNrodoc
REPLACE TpoDoc WITH "Canje"
REPLACE FchDoc WITH XdFchDoc
REPLACE CodCli WITH XsCodcli
REPLACE CodMon WITH Xicodmon
REPLACE TpoCmb WITH Xftpocmb
REPLACE TpoRef WITH [CARGO]
REPLACE CodRef WITH cCodDoc
REPLACE NroRef WITH cNroDoc
REPLACE Import WITH nImpTot
UNLOCK

RETURN
************************************************************************** FIN
* Grabando Letras
***************************************************************************
PROCEDURE CjLActLet

SELECT TDOC
SEEK [LETR]
DO WHILE !RLOCK()
ENDDO
SELECT GDOC
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
REPLACE CodDoc WITH "LETR"
REPLACE NroDoc WITH LsNroDoc
REPLACE TpoDoc WITH "CARGO"
REPLACE FchEmi WITH LdFchDoc
REPLACE FchDoc WITH XdFchDoc     && Con la Fecha del Canje
REPLACE CodCli WITH XsCodcli
REPLACE CodMon WITH XiCodmon
REPLACE TpoCmb WITH XfTpocmb
REPLACE ImpNet WITH LfImpTot
REPLACE ImpTot WITH LfImpTot
REPLACE FchVto WITH LdFchVto
REPLACE SdoDoc WITH LfImpTot
REPLACE TpoRef WITH 'Canje'
REPLACE CodRef WITH ZsCoddoc
REPLACE NroRef WITH ZsNrodoc
REPLACE FlgEst WITH 'T'    && Tramite de Aprobacion
REPLACE FlgUbc WITH 'C'
REPLACE FlgSit WITH 'a'
** actualizamos control correlativo **
SELE TDOC
IF VAL(LsNroDoc)>=NroDoc
   REPLACE NroDoc WITH VAL(LsNroDoc)+1
ENDIF
******************************************************
* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
******************************************************
IF TASG->FlgEst = "E"   && Canje Aprobado
   SELE GDOC
   REPLACE FlgEst WITH 'P'    && Pendiente de Pago
   REPLACE FlgSit WITH 'A'
   **** Actualiza Saldo a Auxiliares
   SELECT SLDO
   IF GDOC->CodMon = 2
      REPLACE CgoUSA WITH CgoUSA + GDOC->ImpTot
   ELSE
      REPLACE CgoNAC WITH CgoNAC + GDOC->ImpTot
   ENDIF
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Carga los # de letras
******************************************************************************
PROCEDURE LETbini1
**
PRIVATE i,m.NroLet
i = 1
m.NroLet = m.LetIni
FOR i = 1 TO GiTotLet
   AsNroLet(i) = PADR(PADL(ALLTRIM(STR(m.NroLet)),6,'0'),LEN(GDOC->NroDoc))
   m.NroLet = m.NroLet + 1
   ** verificamos si existen letras en el archivo **
   SELECT GDOC
   SET ORDER TO GDOC01
   SEEK "CARGO"+"LETR"+TRIM(AsNroLet(i))
   IF FOUND()
      GsMsgErr = [ERROR: Letra ]+AsNroDoc(i)+[ YA EXISTE]
      DO lib_merr WITH 99
      RETURN .f.
   ENDIF
   SET ORDER TO GDOC04
ENDFOR

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar
SELE TASG
IF ! RLOCK()
   RETURN
ENDIF
IF FlgEst=[E]
   GsMsgErr = "Proforma ya genero letra(s), anule primero el canje."
   DO LIB_MERR WITH 99
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
****************************************************************************
* Programa     : ccbprof1.prg
* Sistema      : Cuentas por Cobrar
* Autor        : VETT
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
Yo       = 6
Xo       = 10
Largo    = 5
Ancho    = 57
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
* Cargamos arreglo por defecto *
IF Crear
	IF MESSAGEBOX("Desea Cargar todos los documentos pendientes del cliente",32+4,'ATENCION!!!')=6
	  *IF GiTotDoc = 0      && Primera pasada
	      DO DOCbiniv
	  *ENDIF
	   IF GiTotDoc = 0
	      GsMsgErr = [ NO existen documentos a negociar ]
	      DO lib_merr WITH 99
	      UltTecla = Arriba
	      RETURN
	   ENDIF
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
IF INLIST(UltTecla,Escape_)
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
DO WHILE !INLIST(UltTecla,Escape_)
   DO CASE
      CASE i = 1
         SELE TDOC
         @ NumLin,12 GET LsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_)
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
         IF INLIST(UltTecla,Escape_,Arriba)
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
IF UltTecla # Escape_
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

PRIVATE i
i = 1
SELE RASG
SET ORDER TO RASG02
SELE GDOC
SEEK XsCodCli+'P'+'CARGO'+'FACT'
*SEEK XsCodCli+'P'+'CARGO'
DO WHILE CodCli+FlgEst+TpoDoc+CodDoc=XsCodCli+'P'+'CARGO'+'FACT' .AND. i <= CIMAXELE
*DO WHILE CodCli+FlgEst+TpoDoc=XsCodCli+'P'+'CARGO' .AND. i <= CIMAXELE
   IF !EMPTY(XsNroRef)
      IF !(CodRef=XsCodRef .AND. NroRef=XsNroRef)
         SKIP
         LOOP
      ENDIF
   ENDIF
   IF SEEK(TpoDoc+CodDoc+NroDoc,"RASG")
      SKIP
      LOOP
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
SELE RASG
SET ORDER TO RASG01
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
     FOR CodRef#[LETR]
   =SEEK(RASG->TpoRef+RASG->CodRef+RASG->NroRef,"GDOC")
   AsTpoDoc(i) = TpoRef
   AsCodDoc(i) = CodRef
   AsNroDoc(i) = NroRef
   AdFchDoc(i) = GDOC->FchDoc
   AsCodRef(i) = GDOC->CodRef
   AsNroRef(i) = GDOC->NroRef
   AfImpTot(i) = ROUND(ImpTot,2)
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
@ 11,53 SAY XfImpDoc PICT "9,999,999.99" COLOR SCHEME 7

RETURN
******************
PROCEDURE DocbInte
******************
PRIVATE j,i,P,n,m,V
j = 1
store 0 TO XfIntDoc,XfIntIgv
DO WHILE j <= GiTotDoc
   P = AfImpTot(j)
   n = XdFchDoc - AdFchDoc(j)
   i = XfPorInt
   DO CASE
      CASE XcTipInt = [M]     && Mensual
         m = 30
      CASE XcTipInt = [A]     && Anual
         m = 360
      CASE XcTipInt = [D]     && Diario
         m = 1
   ENDCASE

   XX = ( ( 1 + i/100 )^(n/m) - 1 )
   IF XiTipTas = 1
       V = P * XX            && vencida
   ELSE
       V = P * XX/(1-XX)     && adelantada
   ENDIF
   V = ROUND(V,2)
   XfIntDoc = XfIntDoc + V
   *
   j = j + 1
ENDDO
XfIntIgv = ROUND(XfIntDoc*XfPorIgv/100,2)
@ 13,53 SAY XfIntDoc                               PICT "9,999,999.99"
@ 14,53 SAY (XfImpDoc-XfImpCup)+XfIntDoc           PICT "9,999,999.99"
RETURN
************************************************************************ FIN *
****************************************************************************
* Programa     : ccbprof2.prg
* Sistema      : Cuentas por Cobrar
* Autor        : VETT
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
Yo       = 20
Xo       = 2
Largo    = 4
Ancho    = 76
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
m.ImpDoc = XfImpDoc - XfImpCup + XfIntDoc
*****************
*IF Crear
   DO LETbiniv    && Inicializa el arreglo
   IF GiTotLet = 0
      GsMsgErr = [No se puede generar informacion]
      DO lib_merr WITH 99
      UltTecla = Arriba
      RETURN
   ENDIF
*ELSE
*   DO LETbmove       && Cargamos arreglo con informacion almacenada
*   IF GiTotLet = 0
*      GsMsgErr = [No se puede cargar informacion]
*      DO lib_merr WITH 99
*      UltTecla = Arriba
*      RETURN
*   ENDIF
*ENDIF
MaxEle   = GiTotLet
TotEle   = CIMAXELE
DO LETRegen       && Recalculamos datos
DO WHILE .t.
   GsMsgKey = "[PgUp] [PgDw]   [Enter] Ingreso [F10] Graba [Esc] Salir"
   DO lib_mtec WITH 99
   DO aBrowse
   IF (UltTecla = Escape_) .OR. (m.Import = m.ImpDoc)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
IF INLIST(UltTecla,Escape_)
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
m.SdoIgv = XfIntIgv
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

   XX = ( ( 1 + i/100 )^(n/m) - 1 )
   IF XiTipTas = 1
       V = P * XX
   ELSE
       V = P * XX/(1-XX)
   ENDIF
   V = ROUND(V,2)
   AfImpInt(j) = V
   AfImpIgv(j) = ROUND(AfImpInt(j)*XfPorIgv/100,2)+ROUND(XfIntIgv/XiCanLet,2)
   AfImpLet(j) = AfImport(j)+AfImpInt(j)+AfImpIgv(j)
   AiDiaLet(j) = XiDiaLet
   AdFchEmi(j) = XdFchDoc
   AdFchVto(j) = XdFchDoc+XiDiaLet+XiDiaLib
   *
   m.SdoDoc = m.SdoDoc - AfImport(j)
   m.SdoIgv = m.SdoIgv - ROUND(XfIntIgv/XiCanLet,2)
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
   XX = ( ( 1 + i/100 )^(n/m) - 1 )
   IF XiTipTas = 1
       V = P * XX
   ELSE
       V = P * XX/(1-XX)
   ENDIF
   V = ROUND(V,2)
   AfImpInt(j) = V
   AfImpIgv(j) = ROUND(AfImpInt(j)*XfPorIgv/100,2) + m.SdoIgv
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
     FOR CodRef=[LETR]
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
@ 24,18 SAY m.Import PICT "9,999,999.99" COLOR SCHEME 7
@ 24,31 SAY m.ImpInt PICT "999,999.99"   COLOR SCHEME 7
@ 24,42 SAY m.ImpIgv PICT "999,999.99"   COLOR SCHEME 7
@ 24,53 SAY m.ImpTot PICT "9,999,999.99" COLOR SCHEME 7

RETURN
********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE LetBLine

PARAMETERS NumEle, NumLin
@ NumLin,4  SAY AdFchEmi(NumEle) PICT "@RD DD/MM/AAAA"
@ NumLin,14 SAY AiDiaLet(NumEle) PICT "999"
@ NumLin,18 SAY AfImport(NumEle) PICT "9,999,999.99"
@ NumLin,31 SAY AfImpInt(NumEle) PICT "999,999.99"
@ NumLin,42 SAY AfImpIgv(NumEle) PICT "999,999.99"
@ NumLin,53 SAY AfImpLet(NumEle) PICT "9,999,999.99"
@ NumLin,66 SAY AdFchVto(NumEle) PICT "@RD DD/MM/AAAA"

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
@ NumLin,4  GET LdFchEmi PICT "@RD DD/MM/AAAA"
@ NumLin,14 GET LiDiaLet PICT "999"
@ NumLin,18 GET LfImport PICT "9,999,999.99"
@ NumLin,31 GET LfImpInt PICT "999,999.99"
@ NumLin,42 GET LfImpIgv PICT "999,999.99"
@ NumLin,53 GET LfImpLet PICT "9,999,999.99"
@ NumLin,66 GET LdFchVto PICT "@RD DD/MM/AAAA"
CLEAR GETS
*
GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
DO lib_mtec WITH 99
DO WHILE ! INLIST(UltTecla,Escape_,Arriba,Abajo)
   DO CASE
      CASE i = 1
         @ NumLin,4  GET LdFchEmi PICT "@RD DD/MM/AAAA"
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ NumLin,14 GET LiDiaLet PICT "999" VALID(LiDiaLet>=0)
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         ** calculamos dias de vencimiento **
         LdFchVto = LdFchEmi + LiDiaLet + XiDiaLib
         @ NumLin,66 SAY LdFchVto PICT "@RD DD/MM/AAAA"
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
         XX = ( ( 1 + k/100 )^(n/m) - 1 )
         IF XiTipTas = 1
             V = P * XX
         ELSE
             V = P * XX/(1-XX)
         ENDIF
         V = ROUND(V,2)
         LfImpInt = V
         LfImpIgv = ROUND(LfImpInt*XfPorIgv/100,2) + ROUND(XfIntIgv/XiCanLet,2)
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
IF ! INLIST(UltTecla,Escape_,Arriba,Abajo)
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
   REPLACE CodRef WITH [LETR]
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
@  1,14 SAY LEFT(CodCli+' '+AUXI->NomAux,41)
@  3,14 SAY IIF(CodMon=1,'S/.','US$')
@  2,28 SAY TpoCmb PICT "99,999.9999"
@  0,64 SAY FchDoc PICT "@RD DD/MM/AAAA"
@  1,64 SAY NroRef
@  2,49 SAY PorIGV PICT "99.99"
@  2,64 SAY PorIPM PICT "99.99"
@ 11,53 SAY ImpDoc PICT "9,999,999.99"
@ 12,48 SAY PidCup
@ 12,53 SAY ImpCup PICT "9,999,999.99"
@ 13,53 SAY (IntDoc)       PICT "9,999,999.99"
@ 14,53 SAY (ImpDoc-ImpCup)+(IntDoc) PICT "9,999,999.99"
@ 13,17 SAY IIF(TipTas=1,"Vencida   ","Adelantada")
DO CASE

   CASE TipInt = [M]
      @ 14,7  SAY 'Mensual'
   CASE TipInt = [A]
      @ 14,7  SAY 'Anual  '
   CASE TipInt = [D]
      @ 14,7  SAY 'Diaria '
   OTHER
      @ 14,7  SAY '       '
ENDCASE

@ 14,18 SAY PorInt PICT "999.99"
@ 15,17 SAY DiaLet PICT "999"
@ 16,17 SAY DiaLib PICT "999"
@ 17,17 SAY CanLet PICT "99"
@ 15,40 SAY GloDoc
@ 16,40 SAY Glosa1
@ 17,40 SAY Glosa2
** pintar detalles **
SELE RASG
SET FILTER TO CodRef # [LETR]
*
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
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
Yo       = 6
Xo       = 10
Largo    = 5
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
VClave   = TASG->CodDoc+TASG->NroDoc+[CARGO]+[LETR]
Yo       = 20
Xo       = 2
Largo    = 4
Ancho    = 76
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
*******************
PROCEDURE xPrn_Prof
*******************
** impresion **
SELE GDOC
SET ORDER TO GDOC01
SELE RASG
SEEK XsCodDoc+XsNroDoc
XFOR = [CodRef#"LETR"]
XWHILE  = [CodDoc+NroDoc = XsCodDoc+XsNroDoc]
RfIntDoc = 0
RfImpTot = 0
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]

sNomRep = "ccbprofo"
DO F0print WITH "REPORTS"
SELE GDOC
SET ORDER TO GDOC04

RETURN
************************************************************************ FIN *
* Objeto : Impresion del documento
******************************************************************************
PROCEDURE xListar
Largo  = 66       && Largo de pagina
Ancho  = 80
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
IniImp = _Prn8a+_Prn1
DO F0print
IF LASTKEY() = Escape_
   RETURN
ENDIF
IF !Crear
   LiTipPro = XiTipPro
   IF LiTipPro = 0
      LiTipPro = _TipPro1()
      XiTipPro = LiTipPro
      SELE TASG
      =RLOCK()
      REPLACE TipPro WITH XiTipPro
      UNLOCK
   ENDIF
ELSE
   LiTipPro = XiTipPro
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
VdFchDoc  = {}
** inicio de impresion **
IF EMPTY(XsNroDoc)
	XsNroDoc=TASG.NroDoc
ENDIF
SELE RASG
SEEK XsCodDoc+XsNroDoc
STORE RECNO() TO REGINI
SET DEVICE TO PRINT
PRINTJOB
   NumPag = 0
   RfIntDoc = 0
   RfImpTot = 0
   GO REGINI
   SCAN WHILE CodDoc+NroDoc = XsCodDoc+XsNroDoc ;
        FOR CodRef # [LETR]
      IF PROW() >= Largo-25 .OR. NumPag = 0
         DO xMEMBRETE
      ENDIF
      SELE GDOC
      SET ORDER TO GDOC01
      SEEK 'CARGO'+RASG->CodRef+RASG->NroRef
      SELE RASG
     *iImpTot = ROUND(ImpTot/(1+TASG->PorIgv/100),2)
      iImpTot = ROUND(ImpTot,2)
      DO CASE
         CASE LiTipPro = 1
              nDias = TASG.DiaLet
         CASE LiTipPro = 2
              nDias = TASG.DiaLet
         CASE LiTipPro = 3
              nDias = TASG.FchDoc-GDOC.FchDoc
      ENDCASE
      LfIntDoc  = Ccb_Inte(iImpTot,nDias,XfPorInt,XcTipInt,XiTipTas)
      @ PROW()+1,03 SAY CodRef
      @ PROW()  ,08 SAY NroRef
      @ PROW()  ,23 SAY GDOC->FchDoc
      @ PROW()  ,35 SAY iImpTot                         PICT "@Z 999,999,999.99"
      @ PROW()  ,54 SAY nDias                           PICT "@Z 9999"
      @ PROW()  ,62 SAY LfIntDoc                        PICT "@Z 999,999,999.999"
      SELE GDOC
      SET ORDER TO GDOC04
      SELE RASG
   ENDSCAN
   DO xPIEPAG
ENDPRINTJOB
DO F0PRFIN



*          1         2         3         4         5         6         7        8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
* VIDRIOS INDUSTRIALES
*
*     PROFORMA : 1234567890                       FECHA DE PROFORMA: 99/99/99
*     AUXINTE  : 12345678 12345678901234567890123456789012345678901234567890
*     PEDIDO   : 1234567890
*     DETALLE  : 1234567890123456789012345678901234567890
*                1234567890123456789012345678901234567890
*                1234567890123456789012345678901234567890
*     TASA MENSUAL         :                        TIPO DE CAMBIO : 9,999.9999
*
*     FECHA DE VENCIMIENTO :                                 MONEDA: S/.
*--------------------------------------------------------------------------------
*                      FECHA  DE           IMPORTE    DIAS  AL      INTERESES
*   DOC.   NUMERO       EMISION                       99/99/99
*--------------------------------------------------------------------------------
*   FACT 1234567890     99/99/99    @Z999,999,999.99   @Z9999  @Z999,999,999.99
*        1234567890
*        1234567890
*        1234567890
*--------------------------------------------------------------------------------
*   TOTAL DOCUMENTOS :                999,999,999.99             999,999,999.99
*   INTERESES        :                999,999,999.99    I.G.V. :
*                                     --------------
*                         TOTAL S/.   999,999,999.99
*                                     ==============
*
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
      @ 0,20 say "           Pausa entre p ginas          " COLOR SCHEME 7
      @ 1,20 say "     Presione [Enter] para continuar    " COLOR SCHEME 7
      ?? CHR(7)
      @ 1,35 say "Enter" COLOR W*/N
      UltTecla = 0
      DO WHILE ! (UltTecla = Enter .OR. UltTecla = Escape_)
         UltTecla = INKEY(0)
      ENDDO
      IF UltTecla = Escape_
         SET DEVICE TO PRINTER
         RETURN
      ENDIF
      @ 0,20 say "                                        "    COLOR SCHEME 11
      @ 1,25 say "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
      @ 2,20 SAY " Presione [ESC] para cancelar Impresi¢n "    COLOR SCHEME 11
      SET DEVICE TO PRINTER
   ENDIF
ENDIF
IF GlRunDos
   SET DEVICE TO SCREEN
   @ 0,20 say "                                        "    COLOR SCHEME 11
   @ 0,25 say   "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
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

NumLin = NumLin + 2
   @ NumLin,0        SAY Tit_IIzq
   @ NumLin,ColSTt   SAY SubTitulo
   @ NumLin,Ancho-14 SAY "PAGINA: "+STR(NumPag,5)

SELE TASG
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
@ PROW()+1,5  SAY "PROFORMA : "+NroDoc
@ PROW()  ,ANCHO - 14 SAY "FECHA : "+DTOC(FchDoc)
VdFchDoc = FchDoc
@ PROW()+1,5  SAY "CLIENTE  : "+CodCli+' '+AUXI->NomAux
@ PROW()+1,5  SAY "PEDIDO   : "+NroRef
@ PROW()+1,5  SAY "DETALLE  : "+GloDoc
@ PROW()+1,16 SAY Glosa1
@ PROW()+1,16 SAY Glosa2
@ PROW()+1, 5 SAY "TASA "+cTipInt+"  : "+TRANS(TASG->PorInt,'999.99')+'%'
@ PROW()  ,51 SAY "VENCIMIENTO    :"+DTOC(TASG.FchDoc+TASG.DiaLet+TASG.DiaLib)
IF LiTipPro=1
   @ PROW()+1,51 SAY "DIAS LIBRES    :"+TRAN(TASG.DiaLib,'999')
ELSE
   @ PROW()+1,0  SAY " "
ENDIF
@ PROW()+1,5  SAY "MONEDA   : "+IIF(CodMon=1,'S/.','US$')
@ PROW()  ,51 SAY "TIPO DE CAMBIO : "+TRANS(TpoCmb,'9,999.9999')
IF LiTipPro <=2
   VdFchVto = TASG.FchDoc+TASG.DiaLet+TASG.DiaLib
ELSE
   VdFchVto = TASG.FchDoc
ENDIF
@ PROW()+1,0  SAY "--------------------------------------------------------------------------------"
@ PROW()+1,0  SAY "                      FECHA  DE           IMPORTE    DIAS  AL      INTERESES    "
@ PROW()+1,0  SAY "   DOCU   NUMERO       EMISION                       "+DTOC(VdFchVto)+SPACE(19)
@ PROW()+1,0  SAY "--------------------------------------------------------------------------------"
SELE RASG

RETURN
************************************************************************ FIN *
* Fin de Impresion
******************************************************************************
PROCEDURE xPIEPAG
RrIntDoc = ROUND(RfIntDoc,2)
@ PROW()+1,00 SAY REPLI("-",Ancho)
@ PROW()+1,03 SAY "TOTAL DOCUMENTOS   :"
@ PROW()  ,35 SAY RfImptot             PICT "@Z 999,999,999.99"
@ PROW()  ,62 SAY RfIntDoc             PICT "@Z 999,999,999.999"
@ PROW()+1,03 SAY "INTERESES          :"
@ PROW()  ,35 SAY RrIntDoc             PICT "@Z 999,999,999.99"
RfIntIgv = 0
DO CASE
   CASE LiTipPro <=2
        RfIntIgv = ROUND(RrIntDoc*XfPorIgv/100,2)
        @ PROW()+1,03 SAY "I.G.V              :"
        @ PROW()  ,35 SAY RfIntIgv             PICT "@Z 999,999,999.99"
   CASE LiTipPro = 3
        RfIntIgv = 0
ENDCASE
@ PROW()+1,35 SAY "-----------------"
@ PROW()+1,03 SAY "IMPORTE A FINANCIAR:"
@ PROW()  ,35 SAY RrIntDoc+RfImpTot+RfIntIgv   PICT "@Z 999,999,999.99"
@ PROW()+1,35 SAY "================="

IF LiTipPro = 1
   IF !EMPTY(LsGloLet)
       @ PROW() + 1 , 03 SAY "LETRA(S)           :"+LsGloLet
   ENDIF
   IF !EMPTY(ZsNroDoc)
       @ PROW() + 1 , 03 SAY ZsCodDoc+":"+ZsNroDoc
   ENDIF
   EJECT PAGE
   RETURN
ENDIF
@ PROW()+2, 5 SAY "LETRAS A DIAS : "+TRANS(TASG->DiaLet,'999')
@ PROW()+1, 5 SAY "DIAS LIBRES   : "+TRANS(TASG->DiaLib,'999')
IF !EMPTY(LsGloLet)
    @ PROW()     , 35 SAY "LETRA(S) :"+LsGloLet
ENDIF
IF !EMPTY(ZsNroDoc)
    @ PROW() + 1 , 03 SAY ZsCodDoc+":"+ZsNroDoc
ENDIF
IF TASG->ImpCup > 0
   @ PROW()+1, 5 SAY "CUPON IGV     : "+TRANS(TASG->ImpCup,'999,999,999.99')
ENDIF
@ PROW()+1, 0 SAY "--------------------------------------------------------------------------------"
@ PROW()+1, 0 SAY " FECHA           IMPORTE                   IGV SOBRE                  FECHA DE  "
@ PROW()+1, 0 SAY "EMISION  DIAS  A FINANCIAR    INTERESES    INTERESES    TOTAL LETRA   VENCIMTO. "
@ PROW()+1, 0 SAY "--------------------------------------------------------------------------------"
SEEK TASG->CodDoc+TASG->NroDoc
STORE 0 TO iImport,iImpInt,iImpIgv,iImpTot
SCAN WHILE CodDoc+NroDoc=TASG->CodDoc+TASG->NroDoc ;
     FOR CodRef = [LETR]
   @ PROW()+1,0  SAY FchRef
   @ PROW()  ,10 SAY DiaLet PICT "999"
   @ PROW()  ,14 SAY Import                    PICT "999,999,999.99"
   @ PROW()  ,29 SAY ImpInt                    PICT "9,999,999.99"
   @ PROW()  ,42 SAY ImpIgv                    PICT "9,999,999.99"
   @ PROW()  ,55 SAY ImpTot                    PICT "999,999,999.99"
   @ PROW()  ,70 SAY VtoRef
   iImport = iImport + Import
   iImpInt = iImpInt + ImpInt
   iImpIgv = iImpIgv + ImpIgv
   iImpTot = iImpTot + ImpTot
ENDSCAN
 @ PROW()+1,0  SAY REPLI("-",Ancho)
 @ PROW()+1,4  SAY "TOTALES :"
 @ PROW()  ,14 SAY iImport                                PICT "999,999,999.99"
 @ PROW()  ,29 SAY iImpInt                                PICT "9,999,999.99"
 @ PROW()  ,42 SAY iImpIgv                                PICT "9,999,999.99"
 @ PROW()  ,55 SAY iImpTot                                PICT "999,999,999.99"
 @ PROW(),PCOL()+1 SAY IIF(TASG->CodMon=1,'SOLES','DOLARES')
*IF iImpInt+iImpIgv>0
*   @ PROW()+1,00 SAY REPLI("-",Ancho)
*   @ PROW()+1,04 SAY "INTERES PREVIO:"
*   @ PROW()  ,29 SAY TASG->IntDoc         PICT "9,999,999.99"
*   @ PROW()  ,42 SAY TASG->IntIgv         PICT "9,999,999.99"
*   @ PROW()+1,00 SAY REPLI("=",Ancho)
*   @ PROW()+1,04 SAY "T O T A L     :"
*   @ PROW()  ,29 SAY TASG->IntDoc+iImpInt PICT "9,999,999.99"
*   @ PROW()  ,42 SAY TASG->IntIgv+iImpIgv PICT "9,999,999.99"
*ENDIF
*@ PROW()+1,0  SAY REPLI("=",Ancho)
EJECT PAGE

RETURN
*********************************************************************** FIN *
PROCEDURE AbreDbf1
*******************
RETURN .t.
IF USED("RDOC")
   SELE RDOC
   USE
ENDIF
IF USED("TABLA")
   SELE TABLA
   USE
ENDIF
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

IF !LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
	RELEASE LoDatAdm
	RETURN .f.
ENDIF
*
IF !LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
	RELEASE LoDatAdm
	RETURN .f.
ENDIF

*
RELEASE LoDatAdm
RETURN .T.
*******************
PROCEDURE CierDbf1
*******************
return
IF USED("RDOC")
   SELE RDOC
   USE
ENDIF
IF USED("TABLA")
   SELE TABLA
   USE
ENDIF
RETURN
******************
PROCEDURE AbreDbf2
******************
RETURN .t.
*IF USED("TASG")
*   SELE TASG
*   USE
*ENDIF
IF USED("RASG")
   SELE RASG
   USE
ENDIF
IF USED("VTOS")
   SELE VTOS
   USE
ENDIF
*
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')


IF !LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
	RELEASE LoDatAdm
 	RETURN .f.
ENDIF
*
IF !LODATADM.ABRIRTABLA('ABRIR','CCBNRASG','RASG','RASG01','')
	RELEASE LoDatAdm
	RETURN .f.
ENDIF

RELEASE LoDatAdm
*SELE 0
*USE ccbntasg ORDER TASG01 ALIAS TASG
*IF !USED()
*   RETURN .F.
*ENDIF
RETURN .T.
******************
PROCEDURE CierDbf2
******************
RETURN 
*IF USED("TASG")
*   SELE TASG
*   USE
*ENDIF
IF USED("RASG")
   SELE RASG
   USE
ENDIF
IF USED("VTOS")
   SELE VTOS
   USE
ENDIF
RETURN
****************
FUNCTION _TipPro
****************
private y,z,ok1,ok2
STORE .F. TO ok1,ok2
FOR y = 1 TO GiTotDoc
    IF AsCodDoc(y)<>"N/D"
       IF AdFchDoc(y)<>XdFchDoc
          Ok1 =.T.
       ENDIF
    ENDIF
NEXT
ok2 = (GiTotLet = 1)
DO CASE
   CASE ok2 AND !Ok1
      RETURN 1
   CASE !ok2 AND !Ok1
      RETURN 2
   CASE Ok1
      RETURN 3
   OTHER
      RETURN 3
ENDCASE
*****************
FUNCTION _TipPro1
*****************
private y,z,ok1,ok2,NumLet
STORE .F. TO ok1,ok2
NumLet = 0
SELE GDOC
SET ORDER TO GDOC01
SELE RASG
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc
     =SEEK(RASG->TpoRef+RASG->CodRef+RASG->NroRef,"GDOC")
     DO CASE
        CASE CodRef # [LETR]
             IF GDOC.FchDoc<>XdFchDoc
                Ok1 = .T.
             ENDIF
        CASE CodRef = [LETR]
             NumLet = NumLet + 1
     ENDCASE
ENDSCAN
SELE GDOC
SET ORDER TO GDOC04
ok2 = (NumLet = 1)
DO CASE
   CASE ok2 AND !Ok1
      RETURN 1
   CASE !ok2 AND !Ok1
      RETURN 2
   CASE Ok1
      RETURN 3
   OTHER
      RETURN 3
ENDCASE
RETURN
