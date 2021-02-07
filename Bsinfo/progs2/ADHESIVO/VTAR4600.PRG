*****************************************************************************
* Programa     : vtar4600.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Ventas Clientes/Productos
* Parametros   : El reporte se basa en la Guias de Remision Facturadas o No
* Creacion     : 22/10/94
* Actualizaci¢n: RHC 19/12/94 TODO en TM
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REPORTE DE VENTAS CLIENTES/PRODUCTOS <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 20,70
@ 8,10 TO 20,70 DOUBLE
@ 12,20 SAY "Del Periodo (AAAA/MM) :"
@ 14,20 SAY " Al Periodo (AAAA/MM) :"
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
USE vtavguia IN 0 ORDER VGUI06 ALIAS GUIA
IF !USED()
   RETURN
ENDIF
*
USE almrmovm IN 0 ORDER RMOV06 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
*
USE vtavpedi IN 0 ORDER VPED01 ALIAS VPED
IF !USED()
   RETURN
ENDIF
*
USE vtarpedi IN 0 ORDER RPED02 ALIAS RPED
IF !USED()
   RETURN
ENDIF
*
USE ccbrgdoc IN 0 ORDER GDOC01 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
*
USE vtaritem IN 0 ORDER ITEM01 ALIAS ITEM
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
*
USE almmmatg IN 0 ORDER MATG01 ALIAS MATG
IF !USED()
   RETURN
ENDIF
* Archivo Temporal de Trabajo
SELE 0
Arch = PATHUSER+SYS(3)
CREATE TABLE &Arch. ( CodCli C(5), NomCli C(50) , CodMat C(8), CanFac N(14,4),;
                      DesMat C(40), UndVta C(3), TotFac N(14,4) )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
SELE TEMPO
INDEX ON NomCli+CodMat TO &Arch.
SET INDEX TO &Arch.
* Variables a usar *
PRIVATE XsAnoMes,XsCodFam
STORE [] TO XsAnoMes1,XsAnoMes2,XsCodFam
XsAnoMes1= LEFT(DTOS(DATE()),6)
XsAnoMes2= LEFT(DTOS(DATE()),6)
XsCodFam = [004]     && Producto Terminado
* Pedimos datos
PRIVATE i
DO WHILE .T.
   i = 1
   UltTecla = 0
   DO lib_mtec WITH 8
   DO WHILE UltTecla # Escape
      DO CASE
         CASE i = 1
            @ 12,44 GET XsAnoMes1 PICT "@R 9999/99"
            READ
            UltTecla = LASTKEY()
         CASE i = 2
            @ 14,44 GET XsAnoMes2 PICT "@R 9999/99"
            READ
            UltTecla = LASTKEY()
      ENDCASE
      IF i = 2 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>2,2,i)
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
      LOOP
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
* Barremos Facturas
SELE GUIA
SEEK [G/R ]+XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
SCAN WHILE CodDoc=[G/R] .AND. LEFT(DTOS(FchDoc),6) <= XsAnoMes2
   WAIT "Procesando Guia No "+NroDoc WINDOW NOWAIT
   XcTipMov = [S]
   XsCodMov = [G]+SUBSTR(GUIA->NroDoc,2,2)
   XsNroDoc = SUBSTR(GUIA->NroDoc,4)
   SELE RMOV
   SEEK XcTipMov+XsCodMov+XsNroDoc
   SCAN WHILE TipMov+CodMov+NroDoc = XcTipMov+XsCodMov+XsNroDoc
 **SCAN WHILE TipMov+CodMov+NroDoc = XcTipMov+XsCodMov+XsNroDoc ;
      **FOR CodMat = XsCodFam

      SELE TEMPO
      SEEK GUIA->NomCli+RMOV->CodMat
      IF !FOUND()
         APPEND BLANK
         REPLACE CodCli WITH GUIA->CodCli
         REPLACE NomCli WITH GUIA->NomCli
         REPLACE CodMat WITH RMOV->CodMat
         REPLACE DesMat WITH RMOV->DesMat
         REPLACE UndVta WITH RMOV->UndVta
      ENDIF
      * Todos el Unidades de Stock
      REPLACE CanFac WITH CanFac + RMOV->CanDes*RMOV->Factor/1000   && < OJO <
      * Precio Unitario por Pedido
      LfPreUni = 0
      IF SEEK(GUIA->NroPed,"VPED")
         IF SEEK(VPED->NroDoc+RMOV->CodMat,"RPED")
            LfPreUni = RPED->PreUni
            IF VPED->CodMon = 2
               LfPreUni = PreUni*VPED->TpoCmb
            ENDIF
         ENDIF
      ENDIF
      * Precio unitario por Factura/Boleta
      IF !EMPTY(GUIA->NroFac)
         IF SEEK([Cargo]+GUIA->CodFac+GUIA->NroFac,"GDOC")
            SELE ITEM
            SEEK GDOC->CodDoc+GDOC->NroDoc
            SCAN WHILE CodDoc+NroDoc = GDOC->CodDoc+GDOC->NroDoc ;
                 FOR CodMat=RMOV->CodMat .AND. NroRef=GUIA->NroDoc
               LfPreUni = PreUni
               IF GDOC->CodMon = 2
                  LfPreUni = PreUni*GDOC->TpoCmb
               ENDIF
            ENDSCAN
         ENDIF
      ENDIF
      SELE TEMPO
      REPLACE TotFac WITH TotFac + RMOV->CanDes*LfPreUni
      *
      SELE RMOV
   ENDSCAN
   *
   SELE GUIA
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6³                                                                   Valor      ³
*7³   Nombre/Razon Social                   Producto   Cantidad    Venta Total   ³
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9³*1234567890123456789012345678901234567890  1234    9999,999.99  9999,999.99   ³
*0³                                                                              ³
*1³                                                                              ³
*2³                                                                              ³
*3³                                                                              ³
*4³                                                                              ³
*5³                                                                              ³
*6³                                                                              ³
*7³                                                                              ³
*8³                                                                              ³
*9³                                                                              ³
*0ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1³                                        TOTALES >  9999,999.99  9999,999.99   ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7         8

SAVE SCREEN TO LsPan01
@  5,0 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,0 SAY "³                                                                   Valor      ³"
@  7,0 SAY "³   Nombre/Razon Social                   Producto   Cantidad    Venta Total   ³"
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
@ 21,0 SAY "³                                        TOTALES >                             ³"
@ 22,0 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"


Tit1 = [DEL PERIODO ]+TRANS(XsAnoMes1,'@R 9999/99')+[ AL ]+TRANS(XsAnoMes2,'@R 9999/99')
@ 6,(80-LEN(Tit1))/2 SAY Tit1
@ 6,1 FILL TO 7,78 COLOR SCHEME 7
@ 21,1 FILL TO 21,78 COLOR SCHEME 7
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
EscLin   = []
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

LinReg   = [LEFT(NomCli,40)+'  '+LEFT(DesMat,4)+'    '+;
            TRANS(CanFac,'9999,999.99')+'  '+TRANS(TotFac,'9999,999.99')+'   ']
Static   = .T.
VSombra  = .F.
*
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
SELE TEMPO
SUM CanFac,TotFac ALL TO XfCanFac,XfTotFac
@ 21,52 SAY XfCanFac PICT "9999,999.99" COLOR SCHEME 7
@ 21,65 SAY XfTotFac PICT "9999,999.99" COLOR SCHEME 7
GO TOP
DO DBrowse
RESTORE SCREEN FROM LsPan01

RETURN
************************************************************************ FIN *
