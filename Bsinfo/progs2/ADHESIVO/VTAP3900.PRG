****************************************************************************
* Programa     : vtap3900.prg
* Sistema      : Ventas
* Autor        : EMI
* Proposito    : Enlaza Guias con facturas
* Creacion     : 05/04/95
* Actualizacion:
****************************************************************************
** Pantalla de Datos **
DO xPanta
** base de datos **
CLOSE DATA
*
SELE 1
USE ccbrgdoc ORDER gdoc01 ALIAS GDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE vtavguia ORDER vgui03 ALIAS GUIA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
PRIVATE XsTabla,XsUndStk,cTabla
XsTabla  = [Cargo]+[FACT]
XsNroFac = SPACE(LEN(GDOC->NroDoc))
XsCodCli = SPACE(LEN(GDOC->CodCli))
cTabla   = [Cargo]+[FACT]
** Variables del Browse **
PRIVATE XsUndVta,XfFacEqu,XsNomCli
XsNroDoc = SPACE(LEN(GUIA->NroDoc))
XsNomCli = SPACE(LEN(GUIA->Nomcli))
** Logica Principal **
SELE GDOC
DO LIB_MTEC WITH 3
UltTecla = 0
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [TpoDoc+CodDoc],cTabla,'M',[]
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [** ENLAZAR FACTURAS CON GUIAS **]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  7,11 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  8,11 SAY "³ No. FACTURA     :                                 ³"
@  9,11 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@ 11,11 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 12,11 SAY "³            **     GUIAS A ENLAZAR    **           ³"
@ 13,11 SAY "³ No. GUIA   FECHA    CLIENTE                       ³"
@ 14,11 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 15,11 SAY "³                                                   ³"
@ 16,11 SAY "³                                                   ³"
@ 17,11 SAY "³                                                   ³"
@ 18,11 SAY "³                                                   ³"
@ 19,11 SAY "³                                                   ³"
@ 20,11 SAY "³                                                   ³"
@ 21,11 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

SELE GDOC
IF &RegVal
   XsNroFac = GDOC->NroDoc
   XsCodCli = GDOC->CodCli
ELSE
   XsNroFac = SPACE(LEN(GDOC->NroDoc))
   XsCodCli = SPACE(LEN(GDOC->CodCli))
ENDIF
*
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape,Enter)
   @ 8,30 GET XsNroFac PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Escape)
      LOOP
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsNroFac)
      IF ! VTABUSCA("FAC2")
         UltTecla = 0
         LOOP
      ENDIF
      XsNroFac = GDOC->NroDoc
      XsCodCli = GDOC->CodCli
   ENDIF
   @ 8,30 SAY XsNroFac
ENDDO
SEEK XsTabla+XsNroFac
XsCodCli = GDOC->CodCli

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE GDOC
IF ! RLOCK()
   RETURN
ENDIF
XsNroFac = NroDoc
XsCodCli = CodCli
* * * *
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
DO xBrowse
* * * *
SELE GDOC
UNLOCK ALL
DO LIB_MTEC WITH 3
KEYBOARD CHR(Escape)

RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse
SELE GDOC
RETURN
************************************************************************ FIN()
* Browse de datos
******************************************************************************
PROCEDURE xBrowse
UltTecla = 0
SelLin   = []
InsLin   = "xBgrab"
EscLin   = []
EdiLin   = "xBedit"
BrrLin   = "xBborr"
GrbLin   = "xBgrab"
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
SELE GUIA
**
NClave   = [CodFac+NroFac]
VClave   = PADR(GDOC->CodDoc+GDOC->NroDoc,LEN(CodDoc+NroFac))
**
HTitle   = 1
Yo       = 14
Xo       = 11
Largo    = 8
Ancho    = 53
TBorde   = Nulo
E1       = []
E2       = []
E3       = []

LinReg   = [NroDoc+'  '+DTOC(FchDoc)+' '+LEFT(NomCli,25)]
Static   = .F.
VSombra  = .F.
**
Set_Escape = .T.
DO LIB_MTEC WITH 14
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit

IF ! Crear
   IF !RLOCK()
      RETURN
   ENDIF
   XsGuia = NroDoc
ELSE
   XsGuia = SPACE(LEN(GUIA->NroDoc))
ENDIF
*
DO lib_mtec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
*@ LinAct,Xo+48 SAY vClave
DO WHILE .NOT. INLIST(UltTecla,Escape)
   DO CASE
   CASE i = 1
      SELE GUIA
      @ LinAct,Xo+2 GET XsGuia PICT "@!"
      READ
      UltTecla = LASTKEY()
      IF UltTecla = Escape
         EXIT
      ENDIF
      IF UltTecla = F8
         IF !VTABUSCA("GUI2")
            LOOP
         ENDIF
         XsGuia = GUIA->NroDoc
      ENDIF
      SET ORDER TO VGUI01
      @ LinAct,Xo+2 SAY XsGuia
      SEEK [G/R ]+XsGuia
      IF ! FOUND()
         cResp = [N]
         cResp = aviso(18,[ Guia no registrada ],[ Continuamos (S-N)?],[],;
                 3,[SN],0,.F.,.T.,.T.)
         IF cResp = [N]
            LOOP
         ENDIF
      ELSE
         XsNomCli = GUIA->NomCli
      ENDIF
      IF EMPTY(XsGuia)
         LOOP
      ENDIF
      IF UltTecla = Enter
         EXIT
      ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>1, 1, i)
   i = IIF(i<1, 1, i)
ENDDO
SELE GUIA
IF UltTecla = Escape
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE xBgrab

IF !RLOCK()
   RETURN
ENDIF
*IF EMPTY(NroFac) .AND. FlgEst = [E]
IF TPOGUI=[VTAS]
   REPLACE CodFac WITH [FACT]
   REPLACE NroFac WITH XsNroFac
   REPLACE FlgEst WITH [F]
ENDIF
UNLOCK
SET ORDER TO VGUI03
RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE xBborr
IF !RLOCK()
   RETURN
ENDIF
IF TPOGUI = [VTAS]
   REPLACE CodFac WITH SPACE(4)
   REPLACE NroFac WITH SPACE(9)
   REPLACE FlgEst WITH [E]
ENDIF
UNLOCK
RETURN
************************************************************************ FIN *
