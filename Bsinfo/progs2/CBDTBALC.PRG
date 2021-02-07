IF ! Master
   DO LIB_MERR WITH 3
   RETURN
ENDIF
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
USE CBDNBALC ORDER NBAL01 ALIAS NBAL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDTBALC order TBAL01 ALIAS TBAL
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION DE BALANCES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
XsCodBal = SPACE(2)
XsNombre = SPACE(30)
@ 10,10 CLEAR TO 13,71
@ 10,10 TO 13,71 DOUBLE
*           1         2         3         4         5         6         7
* 123345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 11,11 SAY "Ingrese C¢digo de balance :"
@ 12,11 SAY "Reporte Balance :          "

i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         SELECT TABL
         XsTabla = "30"
         @ 11,39 GET XsCodBal  PICT "99"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodBal = LEFT(CODIGO,2)
         ENDIF
         IF EMPTY(XsCodBal)
            GsMsgErr = "Estado de Balance Erroneo"
            DO Lib_MErr WITH 99
            LOOP
         ENDIF
         SELECT TBAL
         SEEK XsCodBal+" "
         IF ! Found()
            RESP = "S"
            SAVE SCREEN
            @ 17,19 TO 21,55 DOUBLE COLOR SCHEME 7
            @ 18,20 say "   Estado de Balance No  Existe    " COLOR SCHEME 7
            @ 19,20 say " Desea crearlo como Nuevo Estado   " COLOR SCHEME 7
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

      CASE I = 2
         @ 12,39 GET XsNombre PICT "@S30"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF Nombre <> XsNombre
            REPLACE NOMBRE WITH XsNombre
         ENDIF
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2,2, i)
   i = IIF(i<1, 1, i)
ENDDO

IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF


Titulo   = [A C T I V O S]
NClave   = [Rubro]
VClave   = XsCodbal+" "
Yo       = 5
Xo       = 05
DO TBROWSE
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF

Titulo   = [NOTAS ACTIVO]
NClave   = [Rubro]
VClave   = XsCodbal+" "
DO NBROWSE
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
********************************
Titulo   = [PASIVO Y PATRIMONIO]
NClave   = [Rubro]
VClave   = XsCodBal+"A"
Yo       = 08
Xo       = 11
DO TBROWSE
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
Titulo   = [NOTAS P.&PATRIMONIO]
NClave   = [Rubro]
VClave   = XsCodBal+"A"
DO NBROWSE
CLOSE DATA
RETURN

*****************
PROCEDURE TBROWSE
*****************
SET_ESCAPE = .T.
SELECT TBAL
XiNroItm  = NroItm
XsNota    = Nota
XsGlosa   = Glosa
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
Ancho    = 65
Largo    = 15
TBorde   = Simple
E1       = []
E2       = []
E3       = []
E3       = [ #    NOTA    D E S C R I P C I O N                                         ]
LinReg   = [TRANSF(NROITM,"@L ###")+"    "+NOTA+"     "+GLOSA]
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
XsGlosa   = Glosa
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
         @ LinAct,Xo+16 GET XsGlosa
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3,3, i)
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
REPLACE Glosa     WITH XsGlosa
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
SELECT NBAL
Ancho    = 26
Largo    = 18
Yo       = 05
Xo       = 79-Ancho
SET_ESCAPE = .T.
XsNota    = Nota
XsCodCta  = CodCta
XcSigno   = SPACE(LEN(Signo))
Xcforma   = SPACE(LEN(Forma))
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
E3       = [ NOTA   CUENTA   S   DT ]
LinReg   = [NOTA+"   "+CodCta+"   "+Signo+"    "+Forma]
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
Xcforma   = Forma
IF Crear
   XsCodCta  = SPACE(LEN(Codcta))
   XcSigno   = SPACE(LEN(Signo))
   Xcforma   = SPACE(LEN(Forma))
ENDIF
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         @ LinAct,Xo+2  GET XsNota  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 2
         SELECT CTAS
         @ LinAct,Xo+7 GET XsCodcta  PICT "@!"
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
         @ LinAct,Xo+7 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND() .AND. !("X"$XsCodCta OR XsCodCta="VA" OR XsCodCta="VM")
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            LOOP
         ENDIF
      CASE I = 3
         @ LinAct,Xo+18 GET XcSigno
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 4
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Suma                    "
            vOpc(2) = "2 Resta                   "
            vOpc(3) = "3 Suma  (Cuenta de Ajuste)"
            vOpc(4) = "4 Resta (Cuenta de Ajuste)"
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
         @ LinAct,Xo+18 SAY XcSigno


      CASE I = 4
         @ LinAct,Xo+23 GET XcForma
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 3
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Saldos Activos"
            vOpc(2) = "2 Saldo Pasivos"
            vOpc(3) = "3 Saldo Total"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape
               LOOP
            ENDIF
            XcForma  = STR(oPc,1,0)
         ENDIF
         @ LinAct,Xo+23 SAY XcForma
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4,4, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT NBAL
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
REPLACE Forma     WITH XcForma
UNLOCK ALL
RETURN
