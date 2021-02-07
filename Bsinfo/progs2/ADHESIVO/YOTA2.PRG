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
USE FISCA01 ORDER fisC20 SHAR ALIAS CABEZA

SELE 3
USE FISCA02 ORDER FISC21 ALIAS DETALLE

**************
vtipo =space(3)
XsTemporal= []
GcTit1 = "FRACCIONAMIENTO DE FISCALIZACION"
GcTit2 = ""
GcTit3 = "FECHA:" + DTOC(DATE())
GcTit4 = ""
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
XlContinuar = .T.
DO WHILE   .T.
  COD = 0
  XCODIGO=0
  @ 05,02 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 06,02 SAY "³                                                                          ³"
  @ 07,02 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  @ 06,05 SAY 'CODIGO :' GET XCODIGO PICT '999999'
  READ
  UltTecla = LASTKEY()
  IF UltTecla = 27
      CLOSE ALL
      RETU
  ENDIF
  SELE CONTRIB
   SEEK XCODIGO
   IF FOUND ()
      XCODIGO = STR(XCODIGO)
      @  06, 21 SAY CON_NOMBRE
       DO MOVBrow2
      * xlContinuar = .F.
   ELSE
     WAIT WIND "Contribuyente no registrado" NOWAIT
   ENDIF
ENDDO  && FIN DEL DO
RETURN
******************************************************************************
*  Proposito     : Procedimientos de 2do.browse INGRESO DE PISOS
******************************************************************************
PROCEDURE MOVBrow2
**************************
*XCODIGO = STR(CON_CONTRI)
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
SelLin   = "MOVbcom2"
InsLin   = []
EscLin   = "MOVblin2"
EdiLin   = "MOVbedi2"
BrrLin   = "MOVbbor2"
GrbLin   = "MOVbGra2"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []   &&OTRAS]
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [CON_CONTRI]
VClave   = XCODIGO
HTitle   = 1
Yo       = 09
Xo       = 2
Largo    = 11
Ancho    = 76
TBorde   = Simple
Titulo   = [  DATOS  DEL  CONVENIO ]
E1       = ""
E2       = "Nro.  Nro.                       Fecha      import             Cuota              "
E3       = "Conv. Cota  C O N C E P T O      Conv.     Convenio    ( % )   Inicial  "
*            9999  99   AAAAAAAAAAAAAAAAA  99/99/9999  999,999.99  99.99  999,999.99"
*           23456789012345678901234567890123456789012345678901234567890123456789012345678
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
VCONCEPT = SPACE(10)
VCONV    = 0
VCUOTA   = 0
VTOTAL   = 0
VINICIAL = 0
VPORCEN  = 0
VFECONV  = CTOD(SPACE(8))
XiNroItm  = 1
GsMsgKey  = " [F8] Otras.Inst. [Ins] Inserta la [F3] Recacula [F7] Distribuye"
DO LIB_MTEC WITH 14
DO DBrowse
*REST SCREE FROM PANTA1
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVblin2
PARAMETERS Contenido
PRIVATE CONTENIDO
Contenido = trans(NUM_CONV,"999999")+"  "+STR(NUM_CUOTA,2)+"   "+DES_CONV+""+;
            SPACE(3)+dtoc(FEC_CONV)+"   "+TRANS(IMP_TOTAL,"999,999.99")+"  "+;
            TRANS(POR_CONV,"99.99")+"   "+TRANS(CTA_INIC,"999,999.99")
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedi2
seek xcodigo
IF ! Crear
   VCONCEPT = CABEZA->DES_CONV
   VCONV    = CABEZA->NUM_CONV
   VCUOTA   = CABEZA->NUM_CUOTA
   VTOTAL   = CABEZA->IMP_TOTAL
   VINICIAL = CABEZA->CTA_INIC
   VPORCEN  = CABEZA->POR_CONV
   VFECONV  = FEC_CONV
ELSE
   VCONCEPT = SPACE(LEN(CABEZA->DES_CONV))
   VCONV    = 0
   VCUOTA   = 0
   VTOTAL   = 0
   VINICIAL = 0
   VPORCEN  = 0
   VFECONV  = CTOD(SPACE(8))
ENDIF
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
           @ LinAct,03 GET VCONV PICT "999999"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,03 SAY VCONV PICT "999999"
      CASE i = 2
           @ LinAct,10 GET VCUOTA PICT "99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,10 SAY VCUOTA PICT "99"
      CASE i = 3
           @ LinAct,14 GET VCONCEPT PICT "@"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,14 SAY VCONCEPT PICT "@"
      CASE i = 4
           @ LinAct,32 GET Vfeconv PICT "@D"
           READ  &&&
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,32 SAY Vfeconv PICT "@D"
      CASE i = 5
           @ LinAct,44 GET VTOTAL  PICT "999,999.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LInAct,44 SAY VTOTAL PICT "999,999.99"
      CASE i = 6
           @ LinAct,57 GET Vporcen PICT "99.99"
           READ
        IF VPORCEN <> 0
           VINICIAL = VTOTAL * VPORCEN / 100
        ENDIF
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,57 SAY Vporcen PICT "99.99"
      CASE i = 7
           @ LinAct,67 GET Vinicial PICT "999,999.99"
           READ
           UltTecla = LastKey()
           IF UltTecla = Escape
              LOOP
           ENDIF
           @ LinAct,67 say Vinicial PICT "999,999.99"
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
DO LIB_MTEC WITH 14
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
*IF ! Rec_Lock(5)
*   RETURN
*ENDIF
*IF Crear
REPL CABEZA->Con_contri WITH XCODIGO
*ENDIF
REPL CABEZA->NUM_CONV   WITH VCONV
REPL CABEZA->NUM_CUOTA  WITH VCUOTA
REPL CABEZA->IMP_TOTAL  WITH VTOTAL
REPL CABEZA->DES_CONV   WITH VCONCEPT
REPL CABEZA->FEC_CONV   WITH VFECONV
REPL CABEZA->POR_CONV   WITH VPORCEN
REPL CABEZA->CTA_INIC   WITH VINICIAL
*UNLOCK
DO LIB_MTEC WITH 14
RETURN
**************************
RETURN



***********************************
PROC F3
***********************************
IF LASTKEY()=-2
   ON KEY LABEL INS DO INSCONV
   SELE 2
   SEEK Xcodigo
   IF FOUND()
      SET FILT  TO XCODIGO = CON_CONTRI
      GO TOP
   ELSE
      SET FILT TO XCODIGO = CON_CONTRI
      GO TOP
   ENDIF
   DEFI POPU CONVENIO FROM 5,30 TO 13,79 ;
       PROM FIEL NRO_CONV+'³'+TRANSFORM (TOT_FRAC, '9999999.99')+ ;
       '³'+TRANSFORM (TOT_PAGO,;
        '9999999.99')+'³'+TRANSFORM (SAL_FRAC, '9999999.99')+'³'+TRANSFORM (TOT_CUOT, '99') TITLE '[°±²Û CODIGO=> '+;
        TRANSFORM (XnCOD, '999999999999')+' Û²±°]'  COLOR SCHEME 7 MARGIN SCROLL SHAD
   ON SELECTION POPUP CONVENIO DO toggle WITH XnCOD,NRO_CONV
   ACTI POPU CONVENIO
   ON KEY LABEL INS
ENDIF

************************************
PROC TOGGLE
************************************
PARA _X,_Y
SELE 8
SEEK STR(_X)+_Y
IF FOUND()
   SET FILT TO PRE_CODPRE=_X.AND.NRO_CONV=_Y
   go bott
   xx = nro_cuot
   GO TOP
ELSE
   SET FILT TO PRE_CODPRE=_X.AND.NRO_CONV=_Y
   GO TOP
   XX = 0
ENDIF
PUBLIC PIL
PIL = 0
ON KEY LABEL INS DO INSCONV2 WITH _Y,XX,_X
DEFI POPU CONVENIO1 FROM 15,30 TO 22,79 ;
     PROM FIEL TRANSFORM (NRO_CUOT, '99')+' ³'+TRANSFORM (SUB_TOTA,;
     '9999999.99')+' ³'+DTOC(FEC_PAGO)+'³ '+NRO_FACT+' ³ '+DTOC(FEC_FACT) TITLE '[°±²Û CONVENIO=> '+ALLTRIM(_Y)+' Û²±°]'  COLOR SCHEME 7 MARGIN SCROLL
ON SELECTION POPUP CONVENIO1
ACTI POPU CONVENIO1
SELE 7
ON KEY LABEL INS DO INSCONV
RELE I
RETU
*************************************
PROC INSCONV
*************************************
DEFI WIND CONVENIO FROM 06,02 TO 11,40 SHAD COLO SCHE 7
ACTI WIND CONVENIO
XsConve = SPACE(10)
XsTotCo = 0
DO WHILE .T.
   op = 'N'
   @ 00,01 SAY 'Nro. Convenio => ' get XsConve pict'@!'
   @ 01,01 SAY 'Tot. Convenio => ' get XsTotCo pict'9999999.99' VALID(XsTotCo>0)
   read
   IF LASTKEY()=27
      EXIT
   ENDIF
   @ 03,05 SAY 'Datos Correctos ' get op pict'@!'
   read
   IF OP$'sS'
      APPE BLAN
      REPLA CON_CONTRI WITH XCODIGO
      REPLA PRE_CODPRE WITH XnCOD
      REPLA NRO_CONV   WITH XsConve
      REPLA TOT_FRAC   WITH XsTotCo
      EXIT
   ELSE
      LOOP
   ENDIF
ENDDO
RELE WIND CONVENIO
RETU
*************************************
PROC INSCONV2
*************************************
PARA _Y,_XX,_Z
DEFI WIND CONVEN FROM 12,02 TO 20,40 SHAD COLO SCHE 7
ACTI WIND CONVEN
XsConve = SPACE(10)
PIL = PIL + 1
XsTotCo = 0
XsNroCu = _XX+PIL   &&1
XsTotFr = 0
XsFecPa = ctod(space(8))
DO WHILE .T.
   op = 'N'
   @ 00,01 SAY 'Nro. Convenio => ' get _Y pict'@!'
   @ 01,01 SAY 'Nro. Cuotas   => ' get XsNroCu pict'99'
   CLEA GET
   @ 02,01 SAY 'Tot. Fraccio. => ' get XsTotFr pict'9999999.99' VALID(XsTotFr>0)
   @ 03,01 SAY 'Fec. Pago     => ' get XsFecPa pict'@D'
   read
   IF LASTKEY()=27
      EXIT
   ENDIF
   @ 05,05 SAY 'Datos Correctos ' get op pict'@!'
   read
   IF OP$'sS'
      APPE BLAN
      REPLA CON_CONTRI WITH XCODIGO
      REPLA PRE_CODPRE WITH _Z
      REPLA NRO_CONV   WITH _Y
      REPLA NRO_CUOT   WITH XsNroCu
      REPLA SUB_TOTA   WITH XsTotFr
      REPLA FEC_PAGO   WITH XsFecPa
      SELE 7
      REPLA TOT_PAGO WITH TOT_PAGO+XsTotFr
      REPLA SAL_FRAC WITH TOT_FRAC-TOT_PAGO
      REPLA TOT_CUOT WITH XsNroCu
      SELE 8
      EXIT
   ELSE
      LOOP
   ENDIF
ENDDO
RELE WIND CONVEN
RETU







































************************************
*ROC MUESTRA1
************************************
*SELE CABEZA
*SEEK STR(XCODIGO,6,0)
*
*VNOMBRE = SPACE(35)
*VFECONV = CTOD(SPACE(8))
*VFECPAG  = CTOD(SPACE(8))
*VFECANC  = CTOD(SPACE(8))
*VFECEMI  = CTOD(SPACE(8))
*VCONCEPT = SPACE(35)
*VCONV    = SPACE(6)
*VCUOTA   = SPACE(2)
*VCDPRED  = SPACE(12)
*VDEREMI  = SPACE(6)
*VTOTAL   = SPACE(15)
*VINICIAL = SPACE(15)
*VPORCEN  = SPACE(3)
**---------------------------
*VNOMBRE  = CON_NOMBRE
*VCDPRE   = COD_PRED
*VCONCEPT = DES_CONV
*VCONV    = NUM_CONV
*VCUOTA   = NUM_CUOTA
*VCODPRED = DETALLE->PRE_CODPRE
*VDERMI   = DETALLE->DER_EMIS
*VTOTAL   = IMP_TOTAL
*VINICIAL = CTA_INIC
*VPORCEN  = POR_CONV
*VIMPCTA  = DETALLE->IMP_CUOTA
*VNRCUOTA = DETALLE->NRO_CUOTA
*VFECONV  = FEC_CONV
*VFECPAG  = DETALLE->FEC_PAGO
*VFECANC  = DETALLE->FEC_CANC
*VFECEMI  = DETALLE->FEC_EMIS
*  *--------------------------------
*
* 08,03 say 'N.Convenio :'
* 08,25 say 'N.Cuotas :'
* 08,47 say 'Fecha Convenio :'
* 10,03 say 'Concpt.Conv. :'
* 12,03 SAY 'Monto Total :'
* 12,36 say '%'
* 12,46 say 'Cuota Inicial :'
* 14,03 say 'Dcho.Emision :'
* 14,24 say 'Cod.Pred.:'
*
* 08,15 get vconv pict'999999'
* 08,35 get vcuota pict'99'  RANGE 1,
* 08,62 get vfeconv pict '@D '
* 10,15 get vconcept
* 12,16 get vtotal pict '9999,999,999.99'
*@ 12,38 get vporcen pict '99.99'
*LEAR GETS
* 08,15 get vconv pict'999999'
* 08,35 get vcuota pict'99'
* 08,62 get vfeconv pict '@D '
* 10,15 get vconcept
* 12,16 get vtotal pict '9999,999,999.99'
* 12,38 get vporcen pict '99.99'
*EAD
*F VPORCEN <> 0
*  VINICIAL = VTOTAL * VPORCEN / 100
*NDIF
* 12,61 get vinicial pict '999,999.999'
* 14,17 get vderemi pict '999'
* 14,34 get vcdpred pict '999999999999'
*EAD
*F UltTecla = Enter .OR. UltTecla = F10
*           cResp = Aviso(19,"Desea realizar Fraccionamiento",;
*                   "(S)i / (N)o",[],3,"SN",3,.T.,.F.,.T.)
*           IF cResp = "N"
*              UltTecla = Escape
*              RETURN
*           ENDIF
*NDIF
*    SELE CABEZA
*    SEEK STR(XCODIGO,6,0)
*    IF !FOUND()
*      APPE BLAN
*    ENDIF
*      REPL CON_CONTRI WITH STR(XCODIGO,6,0)
*      REPL NUM_CONV   WITH VCONV
*      REPL NUM_CUOTA  WITH VCUOTA
*      REPL IMP_TOTAL  WITH VTOTAL
*      REPL CON_NOMBRE WITH VNOMBRE
*      REPL DES_CONV   WITH VCONCEPT
*      REPL FEC_CONV   WITH VFECONV
*      REPL POR_CONV   WITH VPORCEN
*      REPL CTA_INIC   WITH VINICIAL
*      REPL COD_PRED   WITH VCODPRED
*
* SELE DETALLE
* FOR I = 1 TO VCUOTA
* SEEK CABEZA.NRO_CON + I
* IF NOT FOUND()
*    APPEND BLAN
*    REPLACE NROCON WITH CABEZA.NROCON
*    REPLACE NRO_CUO WITH I
*    REPLACE IMP-CUOTA WITH VALOR-CUOTA
* ENDIF
* ENDFOR

*RETURN















