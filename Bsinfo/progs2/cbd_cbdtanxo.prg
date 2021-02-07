DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
LOCAL  LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

DO TANXO

loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('ANXO')

RELEASE LoContab
RELEASE loDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF


***************
PROCEDURE TANXO
***************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDTANXO','ANXO','ANXO01','')

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION DE ANEXOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
LOCATE 
XsNroAxo = NroAxo
SEEK XsNroAxo
DO WHILE .T.
   SELECT ANXO
   XsNroAxo = NroAxo
   @ 6,23  SAY XsNroAxo
   DO ASMSelec
   @ 6,23 GET XsNroAxo PICT "99!"
   READ
   UltTecla = LASTKEY()
   DO CASE
      CASE UltTecla = Escape_
         EXIT
      CASE UltTecla = PgUp
         IF EOF()
            GOTO BOTTOM
            XsNroAxo = NroAxo
            SEEK XsNroAxo
         ELSE
            SEEK XsNroAxo
            SKIP -1
            XsNroAxo = NroAxo
            SEEK XsNroAxo
         ENDIF
         LOOP
      CASE UltTecla = Home
         GOTO TOP
         XsNroAxo = NroAxo
         SEEK XsNroAxo
         LOOP
      CASE UltTecla = End
         GOTO BOTTOM
         XsNroAxo = NroAxo
         SEEK XsNroAxo
         LOOP
      CASE UltTecla = PgDn
         IF .NOT. EOF()
            SCAN WHILE  XsNroAxo = NroAxo
            ENDSCAN
            XsNroAxo = NroAxo
         ENDIF
         IF EOF()
            GOTO BOTTOM
            XsNroAxo = NroAxo
            SEEK XsNroAxo
         ENDIF
         LOOP
      OTHER
         SEEK XsNroAxo
   ENDCASE
   @ 6,23 SAY XsNroAxo
   DO XBrowse
*   SKIP
   IF EOF()
      GOTO BOTTOM
   ENDIF
ENDDO


RETURN
**************************************************************************
PROCEDURE ASMSelec
******************
@ 5,6 CLEAR TO 7,76
@ 5,6       TO 7,76
@ 6,12  SAY "ANEXO N§ : "
@ 6,23  SAY XsNroAxo
@ 6,42  SAY "FORMATO  : "
@ 6,53  SAY FoRmat PICT "9"

@ 08,6 CLEAR TO 21,76
@ 08,6       TO 21,76
@ 09,7 SAY   " Ref.  # CTA.     ***       G L O S A        ***           M Q R S T " COLOR SCHEME 7
@ 10,7       TO 10,75
NumEle = 1
DO WHILE NumEle <= (10) .AND. (NroAxo=XsNroAxo) .AND. ! EOF()
	Contenido= []
	DO pEscbe WITH Contenido
	@ 10+NumEle, 8 SAY Contenido
	SKIP
	NumEle = NumEle + 1
ENDDO
RETURN
*****************
PROCEDURE xBrowse
*****************
* Variables Usadas en la Edici¢n y Grabaci¢n de Items
XiFormat = Format
DO WHILE .T.
   @ 6,53  GET XiFoRmat PICT "9" RANGE 1,3
   READ
   UltTecla = LastKey()
   IF UltTecla = F8
      save screen
      Largo    = 3
      DIMENSION vOpc(Largo)
      oPc = 1
      vOpc(1) = "1 Estandar para Cuentas de Balance"
      vOpc(2) = "2 Saldos Corrientes/No Corrientes "
      vOpc(3) = "3 Estandar para Cuentas de Gestión"
      Ancho1   = LEN(vOpc(1))+2
      Yo1      = 18
      Xo1      = 80-Ancho1
      @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
      READ
      restore screen
      IF LASTKEY() = Escape_
         LOOP
      ENDIF
      XiFormat = oPc
   ENDIF
   @ 6,53  SAY XiFoRmat PICT "9"
   EXIT
ENDDO

XsRefAxo  = RefAxo
XiItmAxo  = ItmAxo
XsCodCta  = CodCta
XsGloAxo  = GloAxo
XcRayas   = Rayas
XcSigno   = Signo
XcMenos   = Menos
XcQuieb   = Quieb
XiModAxo  = ModAxo
UltTecla = 0
SelLin   = []
EdiLin   = "pEdita"
EscLin   = "pEscbe"
BrrLin   = "pBorra"
InsLin   = "pGraba"
GrbLin   = "pGraba"
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
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
BBVerti  = .T.
Static   = .F.
VSombra  = .T.
Yo       = 10
Xo       = 6
Largo    = 12
Ancho    = 71
TBorde   = Nulo
Set_Escape=.T.
NClave   = "NroAxo"
VClave   = XsNroAxo
DO LIB_MTEC WITH 14
DO dBrowse
RETURN

****************
PROCEDURE pEscbe
****************
PARAMETER Contenido
Contenido = RefAxo+" "+STR(ItmAxo,3,0)+" "+CodCta+" "+GloAxo+" "+Menos+" "+Quieb+" "+Rayas+" "+Signo+" "+STR(ModAxo,1,0)
RETURN

****************
PROCEDURE pEdita
****************
XsRefAxo  = RefAxo
XiItmAxo  = ItmAxo
XsCodCta  = CodCta
XsGloAxo  = GloAxo
XcMenos   = Menos
XcQuieb   = Quieb
XiModAxo  = ModAxo
XcSigno   = Signo
XcRayas   = Rayas

IF Crear
   XsCodCta  = SPACE(LEN(Codcta))
   XiItmAxo  = XiItmAxo  + 1
ENDIF
i = 0
UltTecla = 0
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
   DO CASE
      CASE I = 1
         @ LinAct,Xo+2  GET XsRefAxo  PICT "@!"
         READ
         UltTecla = LastKey()
      CASE I = 2
         @ LinAct,Xo+6  GET XiItmAxo  PICT "999"
         READ
         UltTecla = LastKey()
      CASE I = 3
         SELECT CTAS
         @ LinAct,Xo+10 GET XsCodcta
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape_
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ LinAct,Xo+10 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND() .AND. ! "X"$XsCodCta  .AND. ! EMPTY(XsCodCta)
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            LOOP
         ENDIF
      CASE I = 4
         @ LinAct,Xo+19  GET XsGloAxo
         READ
         UltTecla = LastKey()
      CASE I = 5
         @ LinAct,Xo+60 GET XcMenos
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 2
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "  Cuando es negativo [MENOS]  "
            vOpc(2) = "N No Antepone la palabra MENOS"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcMenos  = LEFT(vOpc(oPc),1)
         ENDIF
         @ LinAct,Xo+60 SAY XcMenos

      CASE I = 6
         @ LinAct,Xo+62 GET XcQuieb
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 2
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "  Totaliza   "
            vOpc(2) = "N No Totaliza"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcQuieb  = LEFT(vOpc(oPc),1)
         ENDIF
         @ LinAct,Xo+62 SAY XcQuieb

      CASE I = 7
         @ LinAct,Xo+64 GET XcRayas
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 3
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "               "
            vOpc(2) = "S Rayas Simples"
            vOpc(3) = "D Rayas Dobles "
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcQuieb  = LEFT(vOpc(oPc),1)
         ENDIF
         @ LinAct,Xo+64 SAY XcRayas

      CASE I = 8
         @ LinAct,Xo+66 GET XcSigno
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 2
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Suma"
            vOpc(2) = "2 Resta"
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XcSigno  = LEFT(vOpc(oPc),1)
         ENDIF
         @ LinAct,Xo+66 SAY XcSigno

      CASE I = 9
         @ LinAct,Xo+68 GET XiModAxo PICT "9"
         READ
         UltTecla = LastKey()
         IF UltTecla = F8
            save screen
            Largo    = 3
            DIMENSION vOpc(Largo)
            oPc = 1
            vOpc(1) = "1 Saldo Activo"
            vOpc(2) = "2 Saldo Pasivo"
            vOpc(3) = "3 Saldo Total  "
            Ancho1   = LEN(vOpc(1))+2
            Yo1      = 18
            Xo1      = 80-Ancho1
            @ Yo1+1,Xo1+2 GET oPc FROM vOpc COLOR SCHEME 7
            READ
            restore screen
            IF LASTKEY() = Escape_
               LOOP
            ENDIF
            XiModAxo = oPc
         ENDIF
         @ LinAct,Xo+68 SAY XiModAxo PICT "9"
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>9,9, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT ANXO
DO LIB_MTEC WITH 14
RETURN

****************
PROCEDURE pGraba
****************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
REPLACE NroAxo    WITH XsNroAxo
REPLACE Format    WITH XiFormat
REPLACE RefAxo    WITH XsRefAxo
REPLACE ItmAxo    WITH XiItmAxo
REPLACE CodCta    WITH XsCodCta
REPLACE GloAxo    WITH XsGloAxo
REPLACE Signo     WITH XcSigno
REPLACE Rayas     WITH XcRayas
REPLACE Menos     WITH XcMenos
REPLACE Quieb     WITH XcQuieb
REPLACE ModAxo    WITH XiModAxo
UNLOCK ALL
RETURN
UNLOCK ALL
RETURN
*************************************************************************** FIN
* Procedimiento borrado
******************************************************************************
PROCEDURE pBORRA
***************
IF ! RLOCK()
   RETURN
ENDIF
DELETE
UNLOCK ALL
RETURN
