***************************************************************************
* PROGRAMA : FISFRACP.PRG                                                 *
* OBJETIVO : FRACCIONAMIENTO DE FISCALIZACION                             *
* AUTOR    : YULINO MALPARTIDA                                            *
* FECHA    : DEBUT                                                        *
***************************************************************************
************  ABRIMOS LA BASE DE DATOS   **************
clea
PUBLI ESTA
STORE .F. TO ESTA

SELE 1
USE MAYCOP01 ORDE FISC20 SHAR ALIAS CONTRIB

SELE 2
USE FISCo ORDER fisC20 SHAR ALIAS CABEZA

SELE 3
USE FISCA2 ORDER FISC21 ALIAS DETALLE

**************
Modificar = .T.
STORE "" TO XdFchDoc
vtipo = space(3)
XsTemporal = []
GcTit1 = "FRACCIONAMIENTO DE FISCALIZACION"
GcTit2 = ""
GcTit3 = "FECHA:" + DTOC(DATE())
GcTit4 = ""
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
XlContinuar = .T.
do pantalla
DO WHILE   .T.
   COD = 0
   XCODIGO=0
   @ 03,02 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 04,02 SAY "³                                                                          ³"
   @ 05,02 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ 04,05 SAY 'CODIGO :' GET XCODIGO PICT '999999'
   READ
   UltTecla = LASTKEY()
   IF UltTecla = 27
      CLOSE ALL
      RETU
   ENDIF
   SELE CONTRIB
   SEEK XCODIGO
   IF FOUND ()
      XCODIGO = STR(XCODIGO,6)
      @  04, 21 SAY CON_NOMBRE
      VNOMBRE = CON_NOMBRE
      DO MOVBrow2
      * xlContinuar = .F.
   ELSE
     WAIT WIND "Contribuyente no registrado" NOWAIT
     LOOP
   ENDIF
ENDDO  && FIN DEL DO
RETURN
******************************************************************************
*  Proposito     : Procedimientos de 2do.browse INGRESO DE PISOS
******************************************************************************
PROCEDURE MOVBrow2
**************************
save screen to Rocio
IF UltTecla = Escape
   RETURN
ENDIF
SELE CABEZA
SEEK XCODIGO
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra

UltTecla = 0
SelLin   = ""
InsLin   = []
EscLin   = "MOVblin2"
EdiLin   = "MOVbedi2"
BrrLin   = "MOVbbor2"
GrbLin   = "MOVbGra2"
MVprgF1  = []
MVprgF2  = [MOVBrow1]
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []   &&OTRAS]
MVprgF9  = []
PrgFin   = []
Titulo   = []
*ycodigo  = xcodigo
NClave   = [CON_CONTRI]
VClave   = xCODIGO
HTitle   = 1
Yo       = 07
Xo       = 2
Largo    = 08
Ancho    = 76
TBorde   = Simple
Titulo   = [  DATOS  DEL  CONVENIO ]
E1       = ""
E2       =  "  Nro.  Nro.                       Fecha       import              Cuota "
E3       =  "  Conv. Cota  C O N C E P T O      Conv.      Convenio  ( % )     Inicial"
*            9999  99   AAAAAAAAAAAAAAAAA  99/99/9999  999,999.99  99.99  999,999.99"
*           234567890123456789012345678901234567890123456789012345678901234567890123456
*                   1         2         3         4         5         6         7
*
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
************* Variable a Conocer ********
XSFCHDOC = DATE()
XIPAGO = 30
VCONCEPT = SPACE(50)
VNOMBREE = SPACE(35)
VCONV    = 0
VCUOTA   = SPACE(2)
VTOTAL   = 0
VINICIAL = 0
VPORCEN  = 0
*VFECONV  = CTOD(SPACE(8))
XDFECONV = DATE()
XiNroItm  = 1
GsMsgKey  = " [F8] Otras.Inst. [Ins] Inserta la [F3] Recacula [F7] Distribuye"
DO LIB_MTEC WITH 14
DO DBrowse
REST SCREE FROM Rocio
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVblin2
PARAMETERS Contenido
PRIVATE CONTENIDO
Contenido = NUM_CONV+"  "+NUM_CUOTA+"    "+subs(DES_CONV,1,20)+;
            SPACE(1)+dtoc(FEC_CONV)+" "+TRANS(IMP_TOTAL,"999,999.99")+"  "+;
            TRANS(POR_CONV,"99.99")+"  "+TRANS(CTA_INIC,"999,999.99")
RETURN
******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedi2
*seek xcodigo
IF ! Crear
   VNOMBRE = CABEZA->NOMBRE
   VCONCEPT = CABEZA->DES_CONV
   VCONV    = CABEZA->NUM_CONV
   VCUOTA   = CABEZA->NUM_CUOTA
   VTOTAL   = CABEZA->IMP_TOTAL
   VINICIAL = CABEZA->CTA_INIC
   VPORCEN  = CABEZA->POR_CONV
  * VFECONV  = FEC_CONV
   XDFECONV  = DATE()
ELSE
   VCONCEPT = SPACE(LEN(CABEZA->DES_CONV))
   VCONV    = space(5)
   VCUOTA   = space(2)
   VTOTAL   = 0
   VINICIAL = 0
   VPORCEN  = 0
   VFECONV  = CTOD(SPACE(8))
   XDFECONV  = XDFECONV
ENDIF
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
           @ LinAct,04 GET VCONV PICT "999999"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,04 SAY VCONV PICT "999999"
      CASE i = 2
           @ LinAct,12 GET VCUOTA PICT "@!"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,12 SAY VCUOTA PICT "@!"
      CASE i = 3
           @ LinAct,15 GET VCONCEPT PICT "@s20"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,15 SAY VCONCEPT PICT "@s20"
      CASE i = 4
           @ LinAct,36 GET XDfeconv PICT "@D"
           READ  &&&
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,36 SAY XDfeconv PICT "@D"
      CASE i = 5
           @ LinAct,47 GET VTOTAL  PICT "999,999.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LInAct,47 SAY VTOTAL PICT "999,999.99"
      CASE i = 6
           @ LinAct,59 GET Vporcen PICT "99.99"
           READ
           IF VPORCEN <> 0
              VINICIAL = VTOTAL * VPORCEN / 100
           ENDIF
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,59 SAY Vporcen PICT "99.99"
      CASE i = 7
           @ LinAct,66 GET Vinicial PICT "999,999.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,66 say Vinicial PICT "999,999.99"
      CASE i = 8
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
           i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>8,8, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT cabeza
*DO LIB_MTEC WITH 14
@24,00 clea to 24,79
@24,00 say " [Borr] 2 ESP/BLNC0  [ENTER]-Continuar [F2]-FRACCIONAMIENTO [F10]-Grabar [ESC]-Cancelar" color n/

*           01234567890123456789012345678901234567890123456789012345678901234567890123456789
*                     1         2         3         4         5         6         7

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbbor2
DO LIB_MSGS WITH 10
SELE 2
IF Rec_LOCK(5)
   DELETE
   UNLOCK
   ULTTECLA = F10
ELSE
   ULTTECLA = Escape
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgra2
DO LIB_MSGS WITH 4
SELE CABEZA
IF Crear
   APPEND BLANK
ENDIF
IF ! RLock()
   RETURN
ENDIF
IF Crear
  REPL CABEZA->Con_contri WITH XCODIGO
ENDIF
REPL CABEZA->NOMBRE WITH CONTRIB->CON_NOMBRE
REPL CABEZA->NUM_CONV   WITH VCONV
REPL CABEZA->NUM_CUOTA  WITH VCUOTA
REPL CABEZA->IMP_TOTAL  WITH VTOTAL &&(VTOTAL-VINICIAL)/VCUOTA
REPL CABEZA->DES_CONV   WITH VCONCEPT
REPL CABEZA->FEC_CONV   WITH XDFECONV
REPL CABEZA->POR_CONV   WITH VPORCEN
REPL CABEZA->CTA_INIC   WITH VINICIAL
UNLOCK
DO LIB_MTEC WITH 14
IF Crear
   SELE DETALLE
       append blank
       REPLACE DETALLE->CON_CONTRI WITH CABEZA->CON_CONTRI
       REPLACE DETALLE->NUM_CONV   WITH CABEZA->NUM_CONV
       REPLACE DETALLE->Nro_CUOTA  with str (1)
       REPLACE DETALLE->IMP_CUOTA  WITH CABEZA->cta_inic
       IF IMP_CUOTA <> I
          REPLACE CABEZA->FEC_CONV   WITH XDFECONV
          REPLACE DETALLE->FEC_CANC  WITH XSFCHDOC
       ENDIF
    FOR I = 1 to CABEZA->NUM_CUOTA
       XsFracc = 0
       XSFCHDOC = XSFCHDOC + XIPAGO
       DO CALCULA
       APPEND BLANK
       IF !RLOCK()
          RETURN
       ENDIF
       REPLACE DETALLE->CON_CONTRI WITH CABEZA->CON_CONTRI
       REPLACE DETALLE->NUM_CONV   WITH CABEZA->NUM_CONV
       REPLACE DETALLE->NRO_CUOTA  WITH str(i+ 1)
       REPLAcE DETALLE->IMP_CUOTA  WITH XsFracc
       REPLACE DETALLE->FEC_PAGO  WITH XSFCHDOC
   ENDFOR
   UNLOCK
ENDIF
SELE CABEZA
RETURN
*********************************
PROC CALCULA
*********************************
XsFracc = 0
IF CABEZA->CTA_INIC > 0
   XsImpCuo = CABEZA->IMP_TOTAL - CABEZA->CTA_INIC
ELSE
   XsImpCuo = CABEZA->IMP_TOTAL
ENDIF
xsFracc = XsImpCuo/CABEZA->NUM_CUOTA

******************************************************************************
*  Proposito     : Procedimientos de 1do.browse SELECCION DE PREDIOS
******************************************************************************
PROCEDURE MOVBrow1
******************
*----------------
SAVE SCREEN TO TEMPO
vconv = num_conv
SELE DETALLE
SEEK cabeza->cON_CONTRI+vconv
set filt to cabeza->cON_CONTRI=con_contri.and.num_conv=vconv
*----------------
IF UltTecla = Escape
   RETURN
ENDIF
UltTecla = 0
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape,LinReg,Static,VSombra
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PriVATE Static,VSombra
SelLin   = ""   &&MOVbcom1"
InsLin   = []
EscLin   = "MOVblin1"
EdiLin   = "MOVbedi1"
BrrLin   = ""   &&MOVbbor2"
GrbLin   = "MOVbGra2"
MVprgF1  = []
MVprgF2  = [MOVBrow1]
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [num_conv+nro_cuota]
VClave   = []  &&[cabeza->con_contri+vconv]  &&XsP_CodCon    &&G
HTitle   = 1
Yo       = 16
Xo       = 2
Largo    = 07
Ancho    = 76
TBorde   = Simple
Titulo   = [ FRACCION DEL CONVENIO ]
*@ 09,2 CLEAR TO 19,76
*@ 09,2  TO  19,76
*@ 14,3  TO  19,74
E1       = " CUOTAS  DER.EMIS.   IMP.MORAS     IMP.CUOTA    FECHA.CANC      FECH.PAGO "
E2       = ""
E3       = ""
*           234567890123456789012345678901234567890123456789012345678901234567890123456
*                   1         2         3         4         5         6         7
*

LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.

*** Variable a Conocer ****                             && [Del] Anula
XSFCHDOC = FEC_PAGO
XiNroItm  = 1
*sMsgKey  = " [F8] Selecciona [Ins] Inserta  [F8] Recacula [F7] Distribuye"
DO LIB_MTEC WITH 14
DO DBrowse
SELE CABEZA
RESTORE SCREEN FROM TEMPO
RETURN
************************************************************************ FIN *
* Objeto : Complementa una linea del browse
******************************************************************************
PROCEDURE MOVbcom1
@ 21,02 clear to 22,76
=SEEK(COD_URB+COD_CALLE,"VIAS")
@ 21,04 SAY "CALLE        : "+VIAS->NOM_CALLE
@ 22,04 SAY "URBANIZACION : "+VIAS->NOM_URB
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVblin1
PARAMETERS Contenido
Contenido = SPACE(2)+'  '+nro_cuota+'   '+trans(der_emi,"999")+"         "+trans(imp_mora,"9999")+;
"         "+trans(imp_cuota,"9999,999.99")+"      "+dtoc(fec_pago)+'    '+dtoc(fec_canc)
RETURN

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedi1
*seek xcodigo
IF ! Crear
  XsCUOTA =  DETALLE->NRO_CUOTA
  XsDERMI =  DETALLE->DER_EMI
  XsMORA = DETALLE->IMP_MORA
  XsIPMCUOTA = DETALLE->IMP_CUOTA
  XDFECONV = DETALLE->FEC_CANC
  XSFCHDOC = DETALLE->FEC_PAGO
ELSE
  XsCUOTA = SPACE(2)
  XsDERMI = 0
  XsMORA = 0
  XsIPMCUOTA = 0
  XDFECONV = DATE()
  XSFCHDOC = DATE()
ENDIF
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
           @ LinAct,13 GET XsDERMI PICT "9.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,13 SAY XsDERMI PICT "9.99"

      CASE i = 2
           @ LinAct,26 GET XsMORA PICT "9,999.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,26 SAY XsMORA PICT "9,999.99"

      CASE i = 3
           @ LinAct,67 GET XSFCHDOC PICT "@D"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,67 SAY XSFCHDOC PICT "@D"
      CASE i = 4
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
           i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4,4, i)
   i = IIF(i<1, 1, i)
   suspend
ENDDO
set order to fisc22
SELECT detalle
*DO LIB_MTEC WITH 14
@24,00 clea to 24,79
@24,00 say " [Borr] 2 ESP/BLNC0  [ENTER]-Continuar [F2]-FRACCIONAMIENTO [F10]-Grabar [ESC]-Cancelar" color n/

*           01234567890123456789012345678901234567890123456789012345678901234567890123456789
*                     1         2         3         4         5         6         7
RETURN
***********************************
proc pantalla
***********************************
*x1=[  DATOS  DEL  CONVENIO ]
*E1       = ""
*E2       =  "Nro.  Nro.                       Fecha       import               Cuota "
*E3       =  "Conv. Cota  C O N C E P T O      Conv.      Convenio    ( % )     Inicial"
*@ 07,2 CLEAR TO 14,77
*@ 07,2  TO  14,77
*@ 10,3  TO  10,76
*@ 07,(78-len(x1))/2 say x1 colo scheme 7
*@ 08,03 say "Nro.  Nro.                       Fecha       import               Cuota   " colo sche 7
*@ 09,03 say "Conv. Cota  C O N C E P T O      Conv.      Convenio    ( % )     Inicial " colo sche 7
*@ 11,77 say 'þ' colo scheme 7
*@ 13,77 say 'þ' colo scheme 7
*---------
*x1=[ FRACCION DEL CONVENIO ]
*@ 16,2 CLEAR TO 22,77
*@ 16,2  TO  22,77
*@ 18,3  TO  18,76
*@ 16,(78-len(x1))/2 say x1 colo scheme 7
*@ 17,3 say " CUOTAS  DER.EMIS.   IMP.MORAS     FECH.PAGO     ECH.CANC.     IMP.CUOTA  " colo sche 7
*@ 19,77 say 'þ' colo scheme 7
*@ 21,77 say 'þ' colo scheme 7
retu
