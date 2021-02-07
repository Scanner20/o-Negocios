*****************************************************************************
* Programa     : vtar4900.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Consulta de GuiasxFacturar
* Creacion     : 03/10/94
* Actualizaci¢n:
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> GUIAS PENDIENTES DE FACTURAR <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
*
CLOSE DATA
DO xListar
CLOSE DATA

RETURN
*********************************************************************** EOP() *
* Objeto : Logica Principal
*******************************************************************************
PROCEDURE xListar

* Aperturando bases
DO lib_msgs WITH 11
USE vtavguia IN 0 ORDER VGUI05 ALIAS GUIA
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
*
USE almrmovm IN 0 ORDER RMOV06 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
*
SELE GUIA
Arch = PathUser+SYS(3)
COPY STRU TO &Arch.
SELE 0
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON NomCli+NroDoc TO &Arch.
SET INDEX TO &Arch.
* Variables a usar *

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6     ³                     Fecha             Tipo      ³
*7     ³ Cliente    Guia    Emisi¢n  Pedido  de Venta    ³
*8     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9     ³ 12345678 123456789 99/99/99 123456 123456789012 ³
*0     ³ 12345678 123456789 99/99/99 123456 123456789012 ³
*1     ³ 12345678 123456789 99/99/99 123456 123456789012 ³
*2     ³ 12345678 123456789 99/99/99 123456 123456789012 ³
*3     ³ 12345678 123456789 99/99/99 123456 123456789012 ³
*4     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*5          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6          ³  C¢digo        D e s c r i p c i ¢ n               Cantidad  Und ³
*7          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*8          ³ 12345678 1234567890123456789012345678901234567890 999,999.99 123 ³
*9          ³ 12345678 1234567890123456789012345678901234567890 999,999.99 123 ³
*0          ³ 12345678 1234567890123456789012345678901234567890 999,999.99 123 ³
*1          ³ 12345678 1234567890123456789012345678901234567890 999,999.99 123 ³
*2          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7         8

@  5,5  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,5  SAY "³                     Fecha             Tipo      ³"
@  7,5  SAY "³ Cliente    Guia    Emisi¢n  Pedido  de Venta    ³"
@  8,5  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  9,5  SAY "³                                                 ³"
@ 10,5  SAY "³                                                 ³"
@ 11,5  SAY "³                                                 ³"
@ 12,5  SAY "³                                                 ³"
@ 13,5  SAY "³                                                 ³"
@ 14,5  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 15,10 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 16,10 SAY "³  C¢digo        D e s c r i p c i ¢ n               Cantidad  Und ³"
@ 17,10 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 18,10 SAY "³                                                                  ³"
@ 19,10 SAY "³                                                                  ³"
@ 20,10 SAY "³                                                                  ³"
@ 21,10 SAY "³                                                                  ³"
@ 22,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@ 6,6 FILL TO 7,54 COLOR SCHEME 7
@ 16,11 FILL TO 16,76 COLOR SCHEME 7

DO xGenera
SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = [No existen Guias que Facturar]
   DO lib_merr WITH 99
   RETURN
ENDIF
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .T.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .F.
Set_Escape=.T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = [xBSeli]
InsLin   = []
EscLin   = [xBEscl]
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
NClave   = []
VClave   = []
HTitle   = 1
Yo       = 8
Xo       = 5
Largo    = 7
Ancho    = 51
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .T.
VSombra  = .F.
*
SELE TEMPO
GO TOP
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Impresion de la Linea
******************************************************************************
PROCEDURE xBEscl
PARAMETER Contenido

=SEEK(GsClfAux+CodCli,"CLIE")
Contenido = IIF(EMPTY(CLIE->IniAux),LEFT(NomCli,8),CLIE->IniAux)+' '
Contenido = Contenido+NroDoc+' '+DTOC(FchDoc)+' '
Contenido = Contenido+NroPed+' '+LEFT(vta_pgo(fmapgo)+SPACE(12),12)

RETURN
************************************************************************ FIN *
* Objeto : Seleccion de Linea
******************************************************************************
PROCEDURE xBSeli

PRIVATE NumLin,LsLlave
@ 18,11 CLEAR TO 21,76
SELE RMOV
LsLlave = [S]+[G]+SUBST(TEMPO->NroDoc,2,2)+SUBST(TEMPO->NroDoc,4)
SEEK LsLlave
NumLin = 18
SCAN WHILE TipMov+CodMov+NroDoc=LsLlave
   IF NumLin <= 21
      @ NumLin,12 SAY CodMat
      @ NumLin,21 SAY DesMat PICT "@S40"
      @ NumLin,62 SAY CanDes PICT "999,999.99"
      @ NumLin,73 SAY UndVta
   ENDIF
   NumLin = NumLin + 1
ENDSCAN
SELE TEMPO

RETURN
************************************************************************ FIN *
* Objeto : Generacion de base
******************************************************************************
PROCEDURE xGenera

SELE GUIA
SEEK [G/R ]+[E]
SCAN WHILE CodDoc+FlgEst = [G/R ]+[E]
   WAIT "Generando "+CodDoc+" "+NroDoc WINDOW NOWAIT
   SELE TEMPO
   APPEND BLANK
   REPLACE NroDoc WITH GUIA->NroDoc
   REPLACE CodCli WITH GUIA->CodCli
   REPLACE NomCli WITH GUIA->NomCli
   REPLACE FmaPgo WITH GUIA->FmaPgo
   REPLACE FchDoc WITH GUIA->FchDoc
   REPLACE NroPed WITH GUIA->NroPed
   SELE GUIA
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
************************************************************************ FIN *
