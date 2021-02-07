*****************************************************************************
* Programa     : vtar4200.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Registro de Pedidos
* Creacion     : 21/10/94
* Actualizaci¢n: RHC 28/10/94 Agregar Producto Intermedio
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REGISTRO DE PEDIDOS <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 22,70
@ 8,10 TO 22,70 DOUBLE
@ 10,20 SAY "Ordenado Por :"
@ 14,20 SAY "  Del Pedido :        al "
@ 15,20 SAY " Del Cliente : "
@ 16,20 SAY "Emitidos del :          al "
@ 18,20 SAY "Condicion    :"
*
CLOSE DATA
DO xListar
CLOSE DATA
RETURN
*********************************************************************** EOP() *
************* Objeto : Logica Principal - xLISTAR
*******************************************************************************
PROCEDURE xListar
******** Aperturando bases
DO lib_msgs WITH 11
USE vtavpedi IN 0 ALIAS VPED
IF !USED()
   RETURN
ENDIF
*
USE vtarpedi IN 0 ORDER RPED01 ALIAS RPED
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
* Archivo Temporal de Trabajo
SELE 0
Arch = PATHUSER+SYS(3)
CREATE TABLE &Arch. ( NroDoc C(6), NomCli C(50), CodMat C(8), UndVta C(3),;
                      CodCli C(5), FacEqu N(10,4), PreUni N(12,2), CanPed N(14,4),;
                      CanDes N(14,4), CanFac N(14,4), DesMat C(40), FchDoc D,;
                      NroO_C C(10), FchO_C D )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON NroDoc+CodMat TO &Arch.
********* Variables a usar *
PRIVATE XsNroD,XsNroH,XsCliD,XdFchD,XdFchH
PRIVATE LiOrden
LiOrden = 1
LiSelec = 1
******** Pedimos datos
PRIVATE i
DO WHILE .T.
   STORE SPACE(LEN(VPED->NroDoc)) TO XsNroD,XsNroH
   STORE SPACE(LEN(VPED->CodCli)) TO XsCliD
   STORE {,,}                     TO XdFchD,XdFchH
   i = 1
   UltTecla = 0
   DO WHILE UltTecla # Escape
      DO lib_mtec WITH 8
      DO CASE
         CASE i = 1
            @ 9,34 TO 13,48
            @ 10,35 PROMPT " Correlativo "
            @ 11,35 PROMPT "  Clientes   "
            @ 12,35 PROMPT "   Fechas    "
            MENU TO LiOrden
            IF LiOrden = 0
               UltTecla = Escape
            ELSE
               UltTecla = Enter
            ENDIF
         CASE i = 2
            @ 14,35 GET XsNroD PICT "@!"
            @ 14,45 GET XsNroH PICT "@!"
            READ
            UltTecla = LASTKEY()
            @ 14,35 SAY XsNroD PICT "@!"
            @ 14,45 SAY XsNroH PICT "@!"
         CASE i = 3
            GsMsgKey = "[F8] Consultar   [Enter] Aceptar   [Esc] Cancelar"
            DO lib_mtec WITH 99
            SELE CLIE
            @ 15,35 GET XsCliD PICT "@!"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Arriba,Escape,BackTab)
               i = i - 1
               LOOP
            ENDIF
            IF UltTecla = F8
               IF !vtabusca("CLIE")
                  LOOP
               ENDIF
               XsCliD = CodAux
            ENDIF
            @ 15,35 SAY XsCliD PICT "@!"
            IF !EMPTY(XsCliD)
               SEEK GsClfAux+XsCliD
               IF !FOUND()
                  DO lib_merr WITH 9
                  LOOP
               ENDIF
            ENDIF
         CASE i = 4
            @ 16,35 GET XdFchD
            @ 16,47 GET XdFchH
            READ
            UltTecla = LASTKEY()
            @ 16,35 SAY XdFchD
            @ 16,47 SAY XdFchH
         CASE i = 5
            @ 17,34 TO 21,48
            @ 18,35 PROMPT "    Todos    "
            @ 19,35 PROMPT " Despachados "
            @ 20,35 PROMPT " Con Saldos  "
            MENU TO LiSelec
            IF LiSelec = 0
               UltTecla = Escape
            ELSE
               UltTecla = Enter
            ENDIF
      ENDCASE
      IF i = 5 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>5,5,i)
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
ZAP
INDEX ON NroDoc+CodMat TO &Arch.
* Logica Principal *
SELE VPED
XsNroD = TRIM(XsNroD)
XsNroH = TRIM(XsNroH)+CHR(255)
IF !EMPTY(XsCliD)
   SET ORDER TO VPED02
   xWHILE = "CodCli=XsCliD"
   SEEK XsCliD
   xFOR   = "XsNroD<=NroDoc.AND.XsNroH>=NroDoc"
ELSE
   SET ORDER TO VPED01
   IF EMPTY(XsNroD)
      GO TOP
   ELSE
      SEEK XsNroD
      IF !FOUND()
         IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
            GO RECNO(0)
            IF DELETED()
               SKIP
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   xWHILE = "NroDoc<=XsNroH"
   xFOR   = IIF(EMPTY(XsCliD),".T.","CodCli=XsCliD")
ENDIF
DO CASE
   CASE EMPTY(XdFchD) .AND. EMPTY(XdFchH)
   CASE !EMPTY(XdFchD) .AND. EMPTY(XdFchH)
      xFOR = xFOR + ".AND.FchDoc>=XdFchD"
   CASE EMPTY(XdFchD) .AND. !EMPTY(XdFchH)
      xFOR = xFOR + ".AND.FchDoc<=XdFchH"
   CASE !EMPTY(XdFchD) .AND. !EMPTY(XdFchH)
      xFOR = xFOR + ".AND.FchDoc>=XdFchD.AND.FchDoc<=XdFchH"
ENDCASE
DO CASE
   CASE LiSelec = 1
      xFOR1 = ".T."
   CASE LiSelec = 2
     *xFOR1 = "CanPed-CanDes<=0"
      xFOR1 = "FlgEst$[CN]"
   CASE LiSelec = 3
     *xFOR1 = "CanPed-CanDes>0"
     *xFOR1 = "!FlgEst$[CN]"
      XFOR1 = ".T."
ENDCASE
**xFOR1 = xFOR1 + ".AND. LEFT(CodMat,3)$[004|002]"   && Productos Terminados
                                                   && e Intermedios
* Barremos Cabecera
SCAN WHILE &xWHILE FOR &xFOR
   WAIT "Pedido "+NroDoc WINDOW NOWAIT
   * Barremos Detalle
   SELE RPED
   SEEK VPED->NroDoc
   DO WHILE NroDoc = VPED->NroDoc
      IF !EVALUATE(xFor1)
         SKIP
         LOOP
      ENDIF
      SELE TEMPO
      SEEK RPED->NroDoc+RPED->CodMat
      IF !FOUND()
         APPEND BLANK
         REPLACE NroDoc WITH RPED->NroDoc
         REPLACE CodMat WITH RPED->CodMat
         REPLACE UndVta WITH RPED->UndVta
         REPLACE DesMat WITH RPED->DesMat
         REPLACE FchDoc WITH VPED->FchDoc
         REPLACE CodCli WITH VPED->CodCli
         REPLACE NomCli WITH VPED->NomCli
         REPLACE PreUni WITH RPED->PreUni
         REPLACE NroO_C WITH VPED->NroO_C
         REPLACE FchO_C WITH VPED->FchO_C
      ENDIF
      REPLACE CanPed WITH CanPed+RPED->CanPed
      REPLACE CanDes WITH CanDes+IIF(RPED->FlgEst=[N],RPED->CanPed,RPED->CanDes)
      REPLACE CanFac WITH CanFac+RPED->CanFac
      SELE RPED
      SKIP
   ENDDO
   *
   SELE VPED
ENDSCAN
* Ordenamos de acuerdo a requerimiento
SELE VPED
SET ORDER TO VPED01
SELE TEMPO
DO CASE
   CASE LiOrden = 1
      INDEX ON NroDoc+CodMat TO &Arch.
   CASE LiOrden = 2
      INDEX ON NomCli+NroDoc+CodMat TO &Arch.
   CASE LiOrden = 3
      INDEX ON DTOS(FchDoc)+NroDoc+CodMat TO &Arch.
ENDCASE
SET INDEX TO &Arch.
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

*          1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6³                                                       Cantid. Saldo x   Valor³
*7³ Pedido   Fecha  Cliente   No. O/C  Fecha O/C Producto Pedida  Entregar  Unit.³
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9³*123456 99/99/99 12345678 1234567890 99/99/99   VS1*   99,999   99,999   999  ³
*0³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*1³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*2³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*3³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*4³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*5³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*6³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*7³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*8³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*9³*123456 99/99/99 12345678 1234567890 99/99/99   VS1    99,999   99,999   999  ³
*0ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1³                                                       TOTAL : 999,999        ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*          1         2         3         4         5         6         7         8

SAVE SCREEN TO LsPan01
@  5,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,0  SAY "³                                                       Cantid. Saldo x   Valor³"
@  7,0  SAY "³ Pedido   Fecha  Cliente   No. O/C  Fecha O/C Producto Pedida  Entregar  Unit.³"
@  8,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  9,0  SAY "³                                                                              ³"
@ 10,0  SAY "³                                                                              ³"
@ 11,0  SAY "³                                                                              ³"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "³                                                                              ³"
@ 19,0  SAY "³                                                                              ³"
@ 20,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,0  SAY "³                                                       TOTAL :                ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@  6,1 FILL TO  7,78 COLOR SCHEME 7
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
*
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
SELE TEMPO
DO CASE
  *CASE LiSelec = 1
  *   xFOR1 = ".T."
  *CASE LiSelec = 2
  *   xFOR1 = "CanPed-CanDes<=0"
   CASE LiSelec = 3
      xFOR1 = "CanPed-CanDes>0"
ENDCASE
SET FILTER TO &xFOR1
SUM CanPed-Candes ALL TO XfTotal
@ 21,64 SAY XfTotal PICT "999,999" COLOR SCHEME 7
GO TOP
DO DBrowse
RESTORE SCREEN FROM LsPan01
SET FILTER TO

RETURN
************************************************************************ FIN *
* Escribe linea activa
******************************************************************************
PROCEDURE xBEscl
PARAMETER Contenido

=SEEK(GsClfAux+CodCli,"CLIE")
Contenido = NroDoc+' '+DTOC(FchDoc)+' '
IF !EMPTY(CLIE->IniAux)
   Contenido = Contenido+CLIE->IniAux+' '
ELSE
   Contenido = Contenido+LEFT(NomCli,8)+' '
ENDIF
Contenido = Contenido+NroO_C+' '+DTOC(FchO_C)+'   '
Contenido = Contenido+LEFT(DesMat,4)+'   '
Contenido = Contenido+TRANS(CanPed,'99,999')+'   '
Contenido = Contenido+TRANS(CanPed-CanDes,'99,999')+'   '
Contenido = Contenido++TRANS(PreUni,'999')+'  '

RETURN
************************************************************************ FIN *
