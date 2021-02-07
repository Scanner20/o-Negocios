*****************************************************************************
* Programa     : vtar4400.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Programa de Entregas por Producto Consolidado
* Creacion     : 21/10/94
* Actualizaci¢n:
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> PROGRAMA DE ENTREGAS CONSOLIDADO <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 20,70
@ 8,10 TO 20,70 DOUBLE
@ 12,20 SAY "Dia Inicial :"
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
USE vtarpedi IN 0 ORDER RPED04 ALIAS RPED
IF !USED()
   RETURN
ENDIF
*
USE almmmatg IN 0 ORDER MATG01 ALIAS MATG
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
*
USE vtavpedi IN 0 ORDER VPED01 ALIAS VPED
IF !USED()
   RETURN
ENDIF
* Archivo Temporal de Trabajo
SELE 0
Arch = PATHUSER+SYS(3)
CREATE TABLE &Arch. ( CodMat C(13), DesMat C(40), D1 N(12,2), D2 N(12,2),;
                      D3 N(12,2), D4 N(12,2), D5 N(12,2), D6 N(12,2),;
                      D7 N(12,2), SdoAnt N(12,2) )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON CodMat TO &Arch.
SET INDEX TO &Arch.
* Variables a usar *
PRIVATE XsCodMat,XdFchIni,XdFchFin,XsCodFam,XsCodMat1
STORE [] TO XsCodMat,XdFchIni,XdFchFin,XsCodFam,XsCodMat1
XdFchIni = DATE() - DOW(DATE()) + 2
* Pedimos datos
PRIVATE i
DO WHILE .T.
   i = 1
   UltTecla = 0
   DO lib_mtec WITH 8
   DO WHILE UltTecla # Escape
      DO CASE
         CASE i = 1
            @ 12,34 GET XdFchIni VALID(DOW(XdFchIni)=2)   && Siempre Lunes
            READ
            UltTecla = LASTKEY()
      ENDCASE
      IF i = 1 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>1,1,i)
   ENDDO
   IF UltTecla = Escape
      EXIT
   ENDIF
   ** Generamos Registro Final **
   DO xGENERA
   SELE TEMPO
   GO TOP
   IF EOF()
      GsMsgErr = [Fin de Archivo]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   DO xBrowse
ENDDO

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SELE TEMPO
DELE ALL
* Barremos el catalogo
SELE MATG
GO TOP
SCAN WHILE !EOF()
   WAIT "Producto "+CodMat WINDOW NOWAIT
   XsCodMat = CodMat
   * Test de Generacion
   XdFchFin = XdFchIni + 5       && Hasta el sabado
   xFOR   = "INLIST(FlgEst,[ ],[P])"
   xWHILE = "CodMat=XsCodMat.AND.XdFchFin>=FchEnt"
   SELE RPED
   SEEK XsCodMat
   SCAN WHILE &xWHILE FOR &xFOR
      LfSaldo = (CanPed-CanDes)
      SELE TEMPO
      SEEK XsCodMat
      IF !FOUND()
         APPEND BLANK
         REPLACE CodMat WITH RPED->CodMat
         REPLACE DesMat WITH RPED->DesMat
      ENDIF
      DO CASE
         CASE RPED->FchEnt < XdFchIni
            REPLACE SdoAnt WITH SdoAnt + LfSaldo
         CASE DOW(RPED->FchEnt) = 2    && Lunes
            REPLACE D1 WITH D1 + LfSaldo
         CASE DOW(RPED->FchEnt) = 3    && Martes
            REPLACE D2 WITH D2 + LfSaldo
         CASE DOW(RPED->FchEnt) = 4    && Mierc.
            REPLACE D3 WITH D3 + LfSaldo
         CASE DOW(RPED->FchEnt) = 5    && Jueves
            REPLACE D4 WITH D4 + LfSaldo
         CASE DOW(RPED->FchEnt) = 6    && Viernes
            REPLACE D5 WITH D5 + LfSaldo
         CASE DOW(RPED->FchEnt) = 7    && Sabado
            REPLACE D6 WITH D6 + LfSaldo
         CASE DOW(RPED->FchEnt) = 1    && Domingo
            REPLACE D7 WITH D7 + LfSaldo
      ENDCASE
      *
      SELE RPED
   ENDSCAN
   *
   SELE MATG
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

SAVE SCREEN TO LsPan01

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6³                         Saldo      Saldo    SEMANA DEL 99/99/99 AL 99/99/99  ³
*7³ Producto   C¢digo     Anterior    Actual   Lun  Mar  Mie  Jue  Vie  Sab  Dom ³
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9³   1234    12345678    999,999    999,999   999  999  999  999  999  999  999 ³
*0³   1234    12345678    999,999    999,999   999  999  999  999  999  999  999 ³
*1³                                                                              ³
*2³                                                                              ³
*3³                                                                              ³
*4³                                                                              ³
*5³                                                                              ³
*6³                                                                              ³
*7³                                                                              ³
*8³                                                                              ³
*9³   1234    12345678    999,999    999,999   999  999  999  999  999  999  999 ³
*0ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1³        TOTALES >      999,999    999,999   999  999  999  999  999  999  999 ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*

@  5,0 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,0 SAY "³                         Saldo      Saldo    SEMANA DEL          AL           ³"
@  7,0 SAY "³ Producto   C¢digo     Anterior    Actual   Lun  Mar  Mie  Jue  Vie  Sab  Dom ³"
@  8,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  9,0 SAY "³                                                                              ³"
@ 10,0 SAY "³                                                                              ³"
@ 11,0 SAY "³                                                                              ³"
@ 12,0 SAY "³                                                                              ³"
@ 13,0 SAY "³                                                                              ³"
@ 14,0 SAY "³                                                                              ³"
@ 15,0 SAY "³                                                                              ³"
@ 16,0 SAY "³                                                                              ³"
@ 17,0 SAY "³                                                                              ³"
@ 18,0 SAY "³                                                                              ³"
@ 19,0 SAY "³                                                                              ³"
@ 20,0 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,0 SAY "³        TOTALES >                                                             ³"
@ 22,0 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@  6,1  SAY "                         Saldo      Saldo    SEMANA DEL          AL           " COLOR SCHEME 7
@  7,1  SAY " Producto   C¢digo     Anterior    Actual   Lun  Mar  Mie  Jue  Vie  Sab  Dom " COLOR SCHEME 7
@ 21,1  SAY "        TOTALES >                                                             " COLOR SCHEME 7
@  6,57 SAY XdFchIni COLOR SCHEME 7
@  6,69 SAY XdFchFin COLOR SCHEME 7
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
SelLin   = []
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
Xo       = 0
Largo    = 13
Ancho    = 80
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .T.
VSombra  = .F.
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
*
SELE TEMPO
SUM SdoAnt,D1,D2,D3,D4,D5,D6,D7 ALL TO XfSdoAnt,XfD1,XfD2,XfD3,XfD4,XfD5,XfD6,XfD7
@ 21,24 SAY XfSdoAnt PICT "999,999" COLOR SCHEME 7
@ 21,35 SAY (XfD1+XfD2+XfD3+XfD4+XfD5+XfD6+XfD7) PICT "999,999" COLOR SCHEME 7
@ 21,45 SAY XfD1 PICT "9999" COLOR SCHEME 7
@ 21,50 SAY XfD2 PICT "9999" COLOR SCHEME 7
@ 21,55 SAY XfD3 PICT "9999" COLOR SCHEME 7
@ 21,60 SAY XfD4 PICT "9999" COLOR SCHEME 7
@ 21,65 SAY XfD5 PICT "9999" COLOR SCHEME 7
@ 21,70 SAY XfD6 PICT "9999" COLOR SCHEME 7
@ 21,75 SAY XfD7 PICT "9999" COLOR SCHEME 7
GO TOP
DO DBrowse
RESTORE SCREEN FROM LsPan01

RETURN
************************************************************************ FIN *
* Objeto : Impresion de la Linea
******************************************************************************
PROCEDURE xBEscl
PARAMETER Contenido

Contenido = '  '+LEFT(DesMat,4)+' '+CodMat+' '
Contenido = Contenido+TRANS(SdoAnt,'999,999')+'    '
Contenido = Contenido+TRANS(D1+D2+D3+D4+D5+D6+D7,'999,999')+'   '
Contenido = Contenido+TRANS(D1,'999')+'  '
Contenido = Contenido+TRANS(D2,'999')+'  '
Contenido = Contenido+TRANS(D3,'999')+'  '
Contenido = Contenido+TRANS(D4,'999')+'  '
Contenido = Contenido+TRANS(D5,'999')+'  '
Contenido = Contenido+TRANS(D6,'999')+'  '
Contenido = Contenido+TRANS(D7,'999')+' '

RETURN
************************************************************************ FIN *
