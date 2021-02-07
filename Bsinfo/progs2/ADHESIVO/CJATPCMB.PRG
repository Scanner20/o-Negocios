**************************************************************************
*  Nombre       : CJATPCMB.PRG
*  Autor        : Jorge Mieses Valencia
*  Objeto       : Tabla de Tipos de Cambio
*  Creaci¢n     : 25/03/92
*  Actualizaci¢n:   /  /
**************************************************************************
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "TABLA DE TIPOS DE CAMBIO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SELE 1
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
XdFchCmb = GdFecha
UltTecla = 0
XfOfiVta = 0
XfOfiCmp = 0
XfBcoVta = 0
XfBcoCmp = 0
XfParVta = 0
XfParCmp = 0

SelLin   = []
EdiLin   = "TCBEdita"
BrrLin   = "TCBBorra"
InsLin   = "TCBGraba"
GrbLin   = "TCBGraba"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = [TCBF6]
MVprgF7  = []
MVprgF8  = []
MVprgF9  = [TCBF9]
Titulo   = []
NClave   = ""
VClave   = ""
Yo       = 5
Xo       = 24
Largo    = 18
Ancho    = 34
TBorde   = Simple
E1       = "            *T/Cambio Oficial * "
E2       = "  FECHA        COMPRA     VENTA "
* 99/99/99   ####.#### ####.#### *

E3       = []
cPict    = "####.####"
LinReg   = [PADR(DTOC(FchCmb),10)+' '+]+;
           [ TRANSF(OfiCmp,cPict)+' '+TRANSF(OfiVta,cPict)]

IF Master
   Consulta = .F.
   Modifica = .T.
   Adiciona = .T.
ELSE
   Consulta = .T.
ENDIF

BBVerti  = .T.
Static   = .T.
VSombra  = .T.
DB_Pinta = .F.
SET_ESCAPE = .T.
GsMsgKey = "[Enter] Seleciona    [F6] Busca una Fecha     [F9] Listado    [Esc] Salir"
nOrdAct  = 1
DO Lib_mtec with 99
IF FIL_LOCK(5)
   DO dBrowse
ENDIF
UNLOCK ALL
CLOSE DATA
RETURN
**************************************************************************
PROCEDURE TCBEdita
******************
RegAct   = RECNO()
EofAct   = EOF()
XdFchCmb = IIF( Crear, CTOD("  /  /    "), FchCmb)
XfOfiVta = OfiVta
XfOfiCmp = OfiCmp
XfBcoVta = BcoVta
XfBcoCmp = BcoCmp
XfParVta = ParVta
XfParCmp = ParCmp
DO LIB_MTEC WITH 7
Teclas   = CHR( Escape ) + Chr( CtrlW )
UltTecla = 0
I        = 1
DO WHILE ! CHR(UltTecla) $ Teclas
   DO CASE
      CASE I = 1
          @ LinAct,Xo+2  GET XdFchCmb VALID ! XdFchCmb = CTOD("  /  /    ")
          READ
          UltTecla = LASTKEY()
          IF UltTecla <> Escape .and. XdFchCmb <> FchCmb
             SEEK DTOC(XdFchCmb,1)
             IF Found()
                DO LIB_MERR WITH 8
                IF ! EofAct
                   GOTO RegAct
                ENDIF
                LOOP
             ENDIF
             IF ! EofAct
                GOTO RegAct
             ENDIF
          ENDIF

      CASE I = 2
          @ LinAct,Xo+13 GET XfOfiCmp  PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 3
          @ LinAct,Xo+23 GET XfOfiVta PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 4
          IF UltTecla = Enter
             UltTecla = CtrlW
          ENDIF
          I = 0
      CASE I = 4
          IF XfBcoVta = 0
             XfBcoVta = XfOfiVta
          ENDIF
          @ LinAct,Xo+36 GET XfBcoVta PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 5
          IF XfBcoCmp = 0
             XfBcoCmp = XfOfiCmp
          ENDIF
          @ LinAct,Xo+46 GET XfBcoCmp PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 6
          IF XfParVta = 0
             XfParVta = XfBcoVta
          ENDIF
          @ LinAct,Xo+59 GET XfParVta PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 7
          IF XfParCmp = 0
             XfParCmp = XfBcoCmp
          ENDIF
          @ LinAct,Xo+69 GET XfParCmp PICTURE cPict
          READ
          UltTecla = LASTKEY()
      CASE I = 8
          IF UltTecla = Enter
             UltTecla = CtrlW
          ENDIF
          I = 0
   ENDCASE
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF(i>4, 4, i)
   i = IIF(i<1, 1, i)
ENDDO
GsMsgKey = "[Enter] Seleciona    [F6] Busca una Fecha     [F9] Listado    [Esc] Salir"
DO Lib_mtec with 99
RETURN
**************************************************************************
PROCEDURE TCBGraba
******************
IF Crear
   APPEND BLANK
ELSE
   IF XdFchCmb <> FchCmb
      dB_Top    = .f.
      dB_Bottom = .f.
      Listar    = .t.
   ENDIF
ENDIF
dB_Top    = .f.
dB_Bottom = .f.
REPLACE FchCmb WITH  XdFchCmb
REPLACE OfiVta WITH  XfOfiVta
REPLACE OfiCmp WITH  XfOfiCmp
REPLACE BcoVta WITH  XfBcoVta
REPLACE BcoCmp WITH  XfBcoCmp
REPLACE ParVta WITH  XfParVta
REPLACE ParCmp WITH  XfParCmp
RETURN
**************************************************************************
PROCEDURE TCBBorra
******************
DELETE
RETURN
**************************************************************************
PROCEDURE TCBF6
******************
SET ORDER TO 1
@ 23,0
@ 23,10 SAY "Fecha a Buscar : " GET XdFchCmb
READ
IF LASTKEY()# Escape
   SEEK DTOC(XdFchCmb,1)
   IF ! FOUND() .AND. Recno(0) > 0
      GOTO Recno(0)
   ENDIF
   dB_Top    = .f.
   dB_Bottom = .f.
   Listar    = .t.
ENDIF
UltTecla = 0
@ 23,0
RETURN
************************************************************************** FIN
*  Proposito     : Listado
***************************************************************************
PROCEDURE TCBF9
SAVE SCREEN TO TMP
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = []
xFor   = []
sNomREP = "CJATPCMB"
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
RETURN
