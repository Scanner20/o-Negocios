*****************************************************************************
* Programa     : vtar5200.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Precio, Volumen de Ventas Menusal
* Parametros   :
* Creacion     : 11/11/94
* Actualizaci¢n: RHC 16/12/94 OJO todo a TM
*****************************************************************************

DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = ">> GRAFICO DE PRECIO, VOLUMEN MENSUAL <<"
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  5,10 CLEAR TO 20,68
@  5,10 TO 20,68 DOUBLE
@ 13,20 SAY "Producto:"
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO SDOLista
CLOSE DATA
RETURN
*********************************************************************** EOP() *

PROCEDURE SDOLista
*******************
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
**
USE ccbrgdoc IN 0 ORDER GDOC08 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
**
USE VTARITEM IN 0 ORDER ITEM01 ALIAS ITEM
IF !USED()
   RETURN
ENDIF
**
USE ALMMMATG IN 0 ORDER MATG01 ALIAS MATG
IF !USED()
   RETURN
ENDIF
**
** Archivo temporal **
Len1 = SPACE(LEN(MATG->CodMat))
Arch = PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch. ( Mes C(3), Venta N(14,2) , Precio N(12,2) , AnoMes C(6) )
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
** variables a usar **
XsAno    = LEFT(DTOS(DATE()),4)
XsCodMat = SPACE(LEN(MATG->CodMat))
XsCodFam = [004]
XsAnoMes2 = LEFT(DTOS(DATE()),6)
XiMes     = MONTH(DATE())-11     && Los 12 meses anteriores
XiAno     = YEAR(DATE())
IF XiMes <= 0
   XiMes = XiMes + 12
   XiAno = XiAno - 1
ENDIF
XsAnoMes1 = STR(XiAno,4)+TRANS(XiMes,'@L 99')
** pantalla de datos **
i = 1
UltTecla = 0
DO WHILE UltTecla # Escape
   DO lib_mtec WITH 8
   DO CASE
      CASE i = 1
         SELE MATG
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
        *@ 13,30 GET XsCodMat PICT XsCodFam+REPLI("!",LEN(XsCodMat)-LEN(XsCodFam))
         @ 13,30 GET XsCodMat PICT REPLI("!",LEN(XsCodMat))
         READ
         UltTecla = Lastkey()
         IF INLIST(UltTecla,Arriba,Backtab,Escape)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodmat)
           *IF !vtabusca("MATGF")
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            XsCodMat = CodMat
         ENDIF
         @ 13,30 SAY XsCodMat
         SEEK XsCodMat
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
   ENDCASE
   IF i = 1 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
IF UltTecla = Escape
   RETURN
ENDIF
** Generamos Registro Final **
DO xGENERA
** test de impresion **
XFOR = []
XWHILE = []
** buscamos registro de arranque **
SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO lib_merr WITH 99
   RETURN
ENDIF
*
_Titulo      = "PRECIO, VOLUMEN DE VENTAS"
_Subtitulo   = "PRODUCTO : "+TRIM(MATG->DesMat)+" "
_TipoGrafico = "LINES2D.3GR"
_TitFila     = "MESES"          && Titulo campo alfabetico
_TitColumna  = "ACUMULADO"
DIMENSION _Vtit(2)
_Vtit[1] = [TM Vendidas]
_VTit[2] = [Precio Unit. US$]
_FoxGraph = "H:\FOXGRAPH\FOXGRAPH.EXE"

DO  Interface_Grafica IN intergra

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

*
xFOR = "INLIST(GDOC->CodDoc,[FAC],[BOL]) .AND. FlgEst # [A] "
*
SELE TEMPO
DELE ALL
* Buscamos Facturas y Boletas
SELE GDOC
SEEK XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
SCAN WHILE LEFT(DTOS(FchDoc),6) <= XsAnoMes2 FOR &xFOR
   WAIT "Verificando "+CodDoc+" "+NroDoc WINDOW NOWAIT
   DO CASE
      CASE MONTH(GDOC->FchDoc) = 1
         XsMes = [ENE]
      CASE MONTH(GDOC->FchDoc) = 2
         XsMes = [FEB]
      CASE MONTH(GDOC->FchDoc) = 3
         XsMes = [MAR]
      CASE MONTH(GDOC->FchDoc) = 4
         XsMes = [ABR]
      CASE MONTH(GDOC->FchDoc) = 5
         XsMes = [MAY]
      CASE MONTH(GDOC->FchDoc) = 6
         XsMes = [JUN]
      CASE MONTH(GDOC->FchDoc) = 7
         XsMes = [JUL]
      CASE MONTH(GDOC->FchDoc) = 8
         XsMes = [AGO]
      CASE MONTH(GDOC->FchDoc) = 9
         XsMes = [SET]
      CASE MONTH(GDOC->FchDoc) = 10
         XsMes = [OCT]
      CASE MONTH(GDOC->FchDoc) = 11
         XsMes = [NOV]
      CASE MONTH(GDOC->FchDoc) = 12
         XsMes = [DIC]
   ENDCASE
   * buscamos detalle de facturas/boletas
   SELE ITEM
   SEEK GDOC->CodDoc+GDOC->NroDoc
   SCAN WHILE ITEM->CodDoc+ITEM->NroDoc=GDOC->CodDoc+GDOC->NroDoc FOR INLIST(CodMat,"004","002")
      SELE TEMPO
      LOCA FOR Mes = XsMes
      IF !FOUND()
         APPEND BLANK
         REPLACE Mes    WITH XsMes
         REPLACE AnoMes WITH LEFT(DTOS(GDOC->FchDoc),6)
      ENDIF
      REPLACE Venta WITH Venta + ITEM->CanFac*ITEM->FacEqu/1000   && < OJO <
      REPLACE Precio WITH Precio+IIF(GDOC->CodMon=1,ITEM->CanFac*ITEM->PreUni,;
                          ITEM->Canfac*ITEM->PreUni/GDOC->TpoCmb)
      *
      SELE ITEM
   ENDSCAN
   *
   SELE GDOC
ENDSCAN
* Barremos informacion para que no falte ningun mes **
XsAnoMes = XsAnoMes1    && Punto de Partida
XiMes    = VAL(SUBSTR(XsAnoMes1,5,2))
XiAno    = VAL(LEFT(XsAnoMes1,4))
SELE TEMPO
GO TOP
FOR i = 1 TO 12
   OK = .T.
   IF EOF()
      APPEND BLANK
      OK = .F.
   ELSE
      IF AnoMes # XsAnoMes
         INSERT BEFORE BLANK
         OK = .F.
      ENDIF
   ENDIF
   IF !OK
      DO CASE
         CASE XiMes = 1
            XsMes = [ENE]
         CASE XiMes = 2
            XsMes = [FEB]
         CASE XiMes = 3
            XsMes = [MAR]
         CASE XiMes = 4
            XsMes = [ABR]
         CASE XiMes = 5
            XsMes = [MAY]
         CASE XiMes = 6
            XsMes = [JUN]
         CASE XiMes = 7
            XsMes = [JUL]
         CASE XiMes = 8
            XsMes = [AGO]
         CASE XiMes = 9
            XsMes = [SET]
         CASE XiMes = 10
            XsMes = [OCT]
         CASE XiMes = 11
            XsMes = [NOV]
         CASE XiMes = 12
            XsMes = [DIC]
      ENDCASE
      REPLACE Mes    WITH XsMes
      REPLACE AnoMes WITH XsAnoMes
   ENDIF
   XiMes = XiMes + 1
   IF XiMes > 12
      XiAno = XiAno + 1
      XiMes = XiMes - 12
   ENDIF
   XsAnoMes = STR(XiAno,4)+TRANS(XiMes,'@L 99')
   SKIP
ENDFOR
REPLACE ALL Precio WITH IIF(Venta>0,Precio/Venta,0)
WAIT "Fin de Generaci¢n" WINDOW NOWAIT
RETURN
*********************************************************************** FIN() *
