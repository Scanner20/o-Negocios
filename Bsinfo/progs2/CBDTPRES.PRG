*IF ! Master
*   DO LIB_MERR WITH 3
*   RETURN
*ENDIF
SELE 4
USE CBDMCTAS order CTAS01 ALIAS CTAS
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE CBDMTABL order TABL01 ALIAS TABL
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE CBDNpres order NPER01 ALIAS NPER
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDTpres order TPER01 ALIAS TPER
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION ESTADOS DE GESTION"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
XsCodBal = SPACE(2)
XsNombre = SPACE(LEN(TABL->NOMBRE))
XsPresuP = 'N'

@ 10,10 CLEAR TO 13,71
@ 10,10 TO 14,71 DOUBLE
*           1         2         3         4         5         6         7
* 123345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 11,12 SAY "Presupuesto     :"
@ 12,12 SAY "Descripci¢n     :"
*@ 13,12 SAY "Presupuesto     :"

i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         SELECT TABL
         XsTabla = "32"
         @ 11,30 GET XsCodBal  PICT "99"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         SELECT TABL
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodBal = LEFT(CODIGO,2)
         ENDIF
         IF EMPTY(XsCodBal)
            GsMsgErr = "Resumen x presupuesto erroneo"
            DO Lib_MErr WITH 99
            LOOP
         ENDIF
         SELECT TPER
         SEEK XsCodBal
         IF ! Found()
            RESP = "S"
            SAVE SCREEN
            @ 17,19 TO 21,55 DOUBLE COLOR SCHEME 7
            @ 18,20 say " Resumen por presupuesto no existe " COLOR SCHEME 7
            @ 19,20 say " Desea crearlo como Nuevo Resumen  " COLOR SCHEME 7
            @ 20,20 say "          [S/N] ?                  " COLOR SCHEME 7
            @ 20,39 GET RESP PICT "@!" VALID RESP$'NS'
            READ
            RESTORE SCREEN
            IF LASTKEY()=Escape
               LOOP
            ENDIF
            IF RESP = "N"
               LOOP
            ENDIF
         ENDIF
         SELECT TABL
         SEEK XsTabla+XsCodBal
         IF ! FOUND()
            APPEND BLANK
            REPLACE TABLA WITH Xstabla
            REPLACE Codigo WITH XsCodBal
         ENDIF
         XsNombre = Nombre
        *XsPresup = Presup

      CASE I = 2
         @ 12,30 GET XsNombre PICT "@S40"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF Nombre <> XsNombre
            REPLACE NOMBRE WITH XsNombre
         ENDIF

     *CASE I = 3
     *   @ 13,30 GET XsPresup PICT "@!"
     *   READ
     *   UltTecla = LastKey()
     *   IF UltTecla = Escape
     *      EXIT
     *   ENDIF
     *   REPLACE PRESUP WITH XsPresup
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2, 2, i)
   i = IIF(i<1, 1, i)
ENDDO

IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF

Titulo   = ALLTRIM(XsNomBre)
DO TBROWSE
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF

Titulo   = [NOTAS ESTADO]
NClave   = [Rubro]
VClave   = XsCodbal
DO NBROWSE

*IF LASTKEY() = Escape
*   CLOSE DATA
*   RETURN
*ENDIF
*IF TABL->Presup='S'
*   SELECT TPER
*   SET FILTER TO RUBRO=XsCodBal
*   BROW FIELD Nota:R,Glosa:R,Presol01:P="99,999,999.99",Preusa01:P="99,999,999.99",Presol02:P="99,999,999.99",Preusa02:P="99,999,999.99",Presol03:P="99,999,999.99",Preusa03:P="99,999,999.99",Presol04:P="99,999,999.99",Preusa04:P="99,999,999.99",;
*   Presol05:P="99,999,999.99",Preusa05:P="99,999,999.99",Presol06:P="99,999,999.99",Preusa06:P="99,999,999.99",Presol07:P="99,999,999.99",Preusa07:P="99,999,999.99",Presol08:P="99,999,999.99",Preusa08:P="99,999,999.99",Presol09:P="99,999,999.99", ;
*   Preusa09:P="99,999,999.99",Presol10:P="99,999,999.99",Preusa10:P="99,999,999.99",Presol11:P="99,999,999.99",Preusa11:P="99,999,999.99",Presol12:P="99,999,999.99",Preusa12:P="99,999,999.99" NODELETE NOAPPEND  LOCK 2
*ENDIF

CLOSE DATA
RETURN
********************************
PROCEDURE TBROWSE
*****************
SET_ESCAPE = .T.
SELECT TPER
XiNroItm  = NroItm
XsNota    = Nota
XsGloCta  = GloCta
XsGlosa   = Glosa
XcSaldo   = Saldo
SelLin   = ""
InsLin   = [MOVbGrab]
EscLin   = ""
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = "MOVF3"
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
HTitle   = 1
NClave   = [Rubro]
VClave   = XsCodBal
Yo       = 5
Largo    = 15
TBorde   = Simple
E1       = []
E2       = []
E3       = []
E3       = [ #    NOTA    *****             D E S C R I P C I O N               *****   ]
LinReg   = [TRANSF(NROITM,"@L ###")+"    "+NOTA+"    "+GLOCTA+"  "+GLOSA+" "+Saldo]
Ancho    = LEN( &LinReg ) + 4
Xo       = INT((80 - Ancho)/2)
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .T.
DB_Pinta = .F.
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [Enter] Modifica"
DO LIB_MTEC WITH 14
DO DBrowse
RETURN
*************************************************************************** FIN
* Procedimiento Para Edici¢n
******************************************************************************
PROCEDURE MOVBEDIT
******************
XiNroItm  = NroItm
XsNota    = Nota
XsGloCta  = GloCta
XsGlosa   = Glosa
XcSaldo   = Saldo
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         @ LinAct,Xo+2 GET XiNroItm PICT "@L ###"
         READ
         UltTecla = LastKey()
      CASE I = 2
         @ LinAct,Xo+9  GET XsNota  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 3
         @ LinAct,Xo+15 GET XsGloCta
         READ
         UltTecla = LastKey()
      CASE I = 4
         @ LinAct,Xo+32 GET XsGlosa
         READ
         UltTecla = LastKey()
      CASE I = 5         
         @ LinAct,Xo+67 GET XcSaldo
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5,5, i)
   i = IIF(i<1, 1, i)
ENDDO
DO LIB_MTEC WITH 14
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE MOVBGRAB
******************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
REPLACE Rubro     WITH VClave
REPLACE NroItm    WITH XiNroItm
REPLACE Nota      WITH XsNota
REPLACE GloCta    WITH XsGloCta
REPLACE Glosa     WITH XsGlosa
REPLACE Saldo     WITH XcSaldo
UNLOCK ALL
RETURN
*************************************************************************** FIN
* Procedimiento borrado
******************************************************************************
PROCEDURE MOVBBORR
******************
IF ! RLOCK()
   RETURN
ENDIF
DELETE
UNLOCK ALL
RETURN
**********************************************************************
* Regenerar Items ====================================================
**********************************************************************
PROCEDURE MovF3
*******************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
@ 11,23 SAY "³    R E C A L C U L A N D O    ³" COLOR SCHEME 7
@ 12,23 SAY "³  Espere un momento por favor  ³" COLOR SCHEME 7
@ 13,23 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   SKIP
ENDDO
**** Chequeo del Nro de Items **********************
IF Chqado > 0
   TnItms = 0
   DO WHILE TnItms < T_Itms
      TnItms =0
      SEEK VCLAVE
      DO WHILE EVALUATE(RegVal) .AND. ! EOF()
         IF NroItm <> ChkItm
            IF RLOCK()
               REPLACE NroItm   WITH ChkItm
            ENDIF
            UNLOCK
         ELSE
            TnItms = TnItms + 1
         ENDIF
         SKIP
      ENDDO
   ENDDO
ENDIF
RESTORE SCREEN
Fin  = .T.
RETURN
*****************
PROCEDURE NBROWSE
*****************
SELECT NPER
Ancho    = 25
Largo    = 18
Yo       = 05
Xo       = 79-Ancho
SET_ESCAPE = .T.
XsNota    = Nota
XsCodCta  = CodCta
XcSigno   = SPACE(LEN(Signo))
XsCodRef  = SPACE(LEN(CodRef))
SelLin   = ""
InsLin   = [MOVnGrab]
EscLin   = ""
EdiLin   = "MOVnedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVnGrab"
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
HTitle   = 1
TBorde   = Simple
E1       = []
E2       = []
E3       = []
E3       = [ NT.  C.CTA. S  REF.  ]
LinReg   = [NOTA+" "+CodCta+"  "+Signo+" "+CodRef]
**           999 99999999  9 99999999
**            
Ancho    = LEN(&LinReg.)+4
Xo       = 79-Ancho
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .T.
DB_Pinta = .F.
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [Enter] Modifica"
DO LIB_MTEC WITH 14
DO DBrowse
RETURN
*************************************************************************** FIN
* Procedimiento Para Edici¢n
******************************************************************************
PROCEDURE MOVNEDIT
******************
XsNota    = Nota
XsCodCta  = Codcta
XcSigno   = Signo
XsCodRef  = CodRef
IF Crear
   XsCodCta  = SPACE(LEN(Codcta))
   XcSigno   = SPACE(LEN(Signo))
   XsCodRef  = SPACE(LEN(CodRef))
ENDIF
LenNot = Xo+2
LenCta = LenNot + Len(XsNota)+ 1
LenSig = LenCta + Len(XsCodCta) + 2
LenRef = LenSig + Len(XcSigno) + 1
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         @ LinAct,LenNot  GET XsNota  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 2
         SELECT CTAS
         @ LinAct,LenCta GET XsCodcta
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ LinAct,LenCta SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND() .AND. ! "X"$XsCodCta  .AND. ! XsCodCta="VA"  .AND. ! XsCodCta="VM" .AND. ! EMPTY(XsCodCta)  .AND. ! XsCodCta="CA"
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE I = 3
         @ LinAct,LENSIG GET XcSigno
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 2
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Suma "
            vOpc(2) = "2 Resta"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape
               LOOP
            ENDIF
            XcSigno  = STR(oPc,1,0)
         ENDIF
         @ LinAct,LENSIG SAY XcSigno
      CASE I = 4
         @ LinAct,LenRef GET XsCodRef
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4,4, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT NPER
DO LIB_MTEC WITH 14
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE MOVNGRAB
******************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
REPLACE Rubro     WITH VClave
REPLACE Nota      WITH XsNota
REPLACE CodCta    WITH XsCodCta
REPLACE Signo     WITH XcSigno
REPLACE CodRef    WITH XsCodRef
UNLOCK ALL
RETURN
