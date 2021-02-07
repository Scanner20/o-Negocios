*****************************************************************************
* Programa     : vtar4500.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Ventas Producto/Clientes
* Parametros   : El reporte se basa en la Guias de Remision Facturadas o No
* Creacion     : 22/10/94
* Actualizaci¢n: RJC 19/12/94 TODO en TM
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REPORTE DE VENTAS PRODUCTO/CLIENTES <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 20,70
@ 8,10 TO 20,70 DOUBLE
@ 10,20 SAY "             Producto :"
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
CREATE TABLE &Arch. ( CodCli C(5), NomCli C(50) , NroGui C(9) , FchDoc D , CanFac N(14,2) ,;
                      UndVta C(3), PreUni N(12,2) , ImpLin N(12,2) , NroFac C(9) )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
SELE TEMPO
INDEX ON NomCli+NroGui TO &Arch.
SET INDEX TO &Arch.
* Variables a usar *
PRIVATE XsAnoMes1,XsAnoMes2,XsCodMat,XsCodFam,XsCodMat1
STORE [] TO XsAnoMes1,XsAnoMes2,XsCodMat,XsCodFam,XsCodMat1
XsCodFam = [004]     && Productos Terminados
XsAnoMes1= LEFT(DTOS(DATE()),6)
XsAnoMes2= LEFT(DTOS(DATE()),6)
XsCodMat1= SPACE(LEN(MATG->CodMat)-3)
XsCodMat = SPACE(LEN(MATG->CodMat))
* Pedimos datos
PRIVATE i
DO WHILE .T.
   i = 1
   UltTecla = 0
   DO lib_mtec WITH 8
   DO WHILE UltTecla # Escape
      DO CASE
         CASE i = 1
            GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
            DO lib_mtec WITH 99
            SELE MATG
           *@ 10,44 SAY XsCodFam
           *@ 10,47 GET XsCodMat1 PICT "@!"
            @ 10,44 GET XsCodMat  PICT "@!"
            READ
            UltTecla = LASTKEY()
            XsCodMat1= SUBSTR(XsCodMat,4)
            XsCodFam = LEFT(XsCodMat,3)
            IF UltTecla = Escape
               EXIT
            ENDIF
            IF UltTecla = F8
           *IF UltTecla = F8 .OR. EMPTY(XsCodMat1)
              *IF !vtabusca("MATGF")
               IF !vtabusca("MATG")
                  LOOP
               ENDIF
               XsCodMat1= SUBSTR(CodMat,4)
               XsCodFam = LEFT(CodMat,3)
            ENDIF
            XsCodMat = XsCodFam+XsCodMat1
            @ 10,44 SAY XsCodMat
            SEEK XsCodMat
            IF !FOUND()
               DO lib_merr WITH 9
               LOOP
            ENDIF
         CASE i = 2
            @ 12,44 GET XsAnoMes1 PICT "@R 9999/99"
            READ
            UltTecla = LASTKEY()
         CASE i = 3
            @ 14,44 GET XsAnoMes2 PICT "@R 9999/99"
            READ
            UltTecla = LASTKEY()
      ENDCASE
      IF i = 3 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>3,3,i)
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
   SEEK XcTipMov+XsCodMov+XsNroDoc+XsCodMat
   SCAN WHILE TipMov+CodMov+NroDoc+CodMat = XcTipMov+XsCodMov+XsNroDoc+XsCodMat
      SELE TEMPO
      APPEND BLANK
      REPLACE CodCli WITH GUIA->CodCli
      REPLACE NomCli WITH GUIA->NomCli
      REPLACE NroGui WITH GUIA->NroDoc
      REPLACE FchDoc WITH GUIA->FchDoc
      REPLACE CanFac WITH RMOV->CanDes*RMOV->Factor/1000   && < OJO <
      REPLACE UndVta WITH RMOV->UndVta
      * Precio Unitario por Pedido
      IF SEEK(GUIA->NroPed,"VPED")
         IF SEEK(VPED->NroDoc+RMOV->CodMat,"RPED")
            REPLACE PreUni WITH RPED->PreUni*1000/RPED->FacEqu   && <OJO<
            IF VPED->CodMon = 2
               REPLACE PreUni WITH PreUni*VPED->TpoCmb
            ENDIF
            REPLACE ImpLin WITH CanFac*PreUni
         ENDIF
      ENDIF
      REPLACE NroFac WITH GUIA->NroFac
      * Precio unitario por Factura/Boleta
      IF !EMPTY(NroFac)
         IF SEEK([Cargo]+GUIA->CodFac+GUIA->NroFac,"GDOC")
            SELE ITEM
            SEEK GDOC->CodDoc+GDOC->NroDoc
            SCAN WHILE CodDoc+NroDoc = GDOC->CodDoc+GDOC->NroDoc ;
                 FOR CodMat=RMOV->CodMat .AND. NroRef=GUIA->NroDoc
               REPLACE TEMPO->PreUni WITH PreUni*1000/ITEM->FacEqu   && <OJO<
               IF GDOC->CodMon = 2
                  REPLACE TEMPO->PreUni WITH PreUni*GDOC->TpoCmb
               ENDIF
               REPLACE TEMPO->ImpLin WITH TEMPO->PreUni*TEMPO->CanFac
            ENDSCAN
         ENDIF
      ENDIF
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

SAVE SCREEN TO LsPan01

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6   ³                     PRODUCTO : 004001 VS1 - VIDRIO ALKASIL              ³
*7   ³                 DEL PERIODO : 9999/99  AL 9999/99                       ³
*8   ³ Cliente   G/Rem.    Fecha     Cantidad  Valor Unit  Valor Total  No.Fac ³
*9   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0   ³*12345678  999999  99/99/99  999,999.99  999,999.99  9999,999.99  999999 ³
*1   ³                                                                         ³
*2   ³                                                                         ³
*3   ³                                                                         ³
*4   ³                                                                         ³
*5   ³                                                                         ³
*6   ³                                                                         ³
*7   ³                                                                         ³
*8   ³                                                                         ³
*9   ³                                                                         ³
*0   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1   ³                TOTALES >    999,999.99              9999,999.99         ³
*2   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7         8
*

@  5,3 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,3 SAY "³                                                                         ³"
@  7,3 SAY "³                                                                         ³"
@  8,3 SAY "³ Cliente   G/Rem.    Fecha     Cantidad  Valor Unit  Valor Total  No.Fac ³"
@  9,3 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 10,3 SAY "³                                                                         ³"
@ 11,3 SAY "³                                                                         ³"
@ 12,3 SAY "³                                                                         ³"
@ 13,3 SAY "³                                                                         ³"
@ 14,3 SAY "³                                                                         ³"
@ 15,3 SAY "³                                                                         ³"
@ 16,3 SAY "³                                                                         ³"
@ 17,3 SAY "³                                                                         ³"
@ 18,3 SAY "³                                                                         ³"
@ 19,3 SAY "³                                                                         ³"
@ 20,3 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,3 SAY "³                TOTALES >                                                ³"
@ 22,3 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"


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
Yo       = 9
Xo       = 3
Largo    = 12
Ancho    = 75
TBorde   = Nulo
E1       = []
E2       = []
E3       = []

@  6,4  SAY "                                                                         " COLOR SCHEME 7
@  7,4  SAY "                                                                         " COLOR SCHEME 7
@  8,4  SAY " Cliente   G/Rem.    Fecha     Cantidad  Valor Unit  Valor Total  No.Fac " COLOR SCHEME 7
@ 21,4  SAY "                TOTALES >                                                " COLOR SCHEME 7

Tit1 = [PRODUCTO : ]+MATG->CodMat+[ ]+TRIM(MATG->DesMat)
Tit2 = [DEL PERIODO : ]+TRANS(XsAnoMes1,'@R 9999/99')+[ AL ]+TRANS(XsAnoMes2,'@R 9999/99')
@ 6,(80-LEN(Tit1))/2 SAY Tit1 COLOR SCHEME 7
@ 7,(80-LEN(Tit2))/2 SAY Tit2 COLOR SCHEME 7

LinReg   = [IIF(EMPTY(CLIE->IniAux),LEFT(NomCli,8),CLIE->IniAux)+'  '+;
            SUBSTR(NroGui,4,6)+'  '+DTOC(FchDoc)+'  '+;
            TRANS(CanFac,'999,999.99')+'  '+TRANS(PreUni,'999,999.99')+'  '+;
            TRANS(ImpLin,'9999,999.99')+'  '+SUBSTR(NroFac,4,6)+' ']
Static   = .T.
VSombra  = .F.
*
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
SELE TEMPO
GO TOP
STORE 0 TO XfTot1,XfTot2
DO WHILE !EOF()
   XfTot1 = XfTot1 + CanFac
   XfTot2 = XfTot2 + ImpLin
   SKIP
ENDDO
@ 21,33 SAY XfTot1 PICT "999,999.99" COLOR SCHEME 7
@ 21,57 SAY XfTot2 PICT "9999,999.99" COLOR SCHEME 7
SET RELA TO GsClfAux+CodCli INTO CLIE
GO TOP
DO DBrowse
RESTORE SCREEN FROM LsPan01

RETURN
************************************************************************ FIN *
