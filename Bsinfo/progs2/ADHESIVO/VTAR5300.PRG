*****************************************************************************
* Programa     : vtar5300.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Variacion de Precios
* Parametros   :
* Creacion     : 11/11/94
* Actualizaci¢n: RHC 19/12/94 OJO todo en TM
*                RHC 29/12/94 Precio del carbonato de la Tabla de Detergente
*****************************************************************************

DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = ">> GRAFICO DE VARIACION DE PRECIOS <<"
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO SDOLista
CLOSE DATA

RETURN
*********************************************************************** EOP() *
PROCEDURE SDOLista
******************

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
USE almrmovm IN 0 ORDER RMOV03 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
**
USE almvmovm IN 0 ORDER VMOV01 ALIAS VMOV
IF !USED()
   RETURN
ENDIF
**
USE admmtcmb IN 0 ORDER TCMB01 ALIAS TCMB
IF !USED()
   RETURN
ENDIF
**
USE vtadeter IN 0 ORDER DETE01 ALIAS DETER
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
* Relaciones a Usar *
SELE RMOV
SET RELA TO SubAlm+TipMov+CodMov+NroDoc INTO VMOV
** Archivo temporal **
Arch = PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch. ( Mes C(3), Serie1 N(12,2) , Serie2 N(12,2),;
                      Serie3 N(12,2), Serie4 N(12,2), Serie5 N(12,2),;
                      Serie6 N(12,2) )
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON Mes TO &Arch.
SET INDEX TO &Arch.
*
Arch1= PATHUSER+SYS(3)
SELE 0
CREATE TABLE &Arch1. ( Mes C(3), Serie1 N(12,2) , Serie2 N(12,2),;
                      Serie3 N(12,2), Serie4 N(12,2), Serie5 N(12,2),;
                      Serie6 N(12,2) )
USE &Arch1. ALIAS TEMPO1 EXCLU
IF !USED()
   RETURN
ENDIF
** variables a usar **
XsAnoMes2 = LEFT(DTOS(DATE()),6)
XiMes     = MONTH(DATE())-11     && Los 12 meses anteriores
XiAno     = YEAR(DATE())
IF XiMes <= 0
   XiMes = XiMes + 12
   XiAno = XiAno - 1
ENDIF
XsAnoMes1 = STR(XiAno,4)+TRANS(XiMes,'@L 99')
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
* Reordenamos la base *
XiMes = VAL(SUBST(XsAnoMes1,5,2))
FOR i=1 TO 12
   XsMes = LEFT(MES(XiMes,1),3)
   =SEEK(XsMes,"TEMPO")
   SELE TEMPO1
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie1 WITH TEMPO->Serie1
   REPLACE Serie2 WITH TEMPO->Serie2
   REPLACE Serie3 WITH TEMPO->Serie3
   REPLACE Serie4 WITH TEMPO->Serie4
   REPLACE Serie5 WITH TEMPO->Serie5
   REPLACE Serie6 WITH TEMPO->Serie6
   XiMes = XiMes + 1
   IF XiMes > 12
      XiMes = XiMes - 12
   ENDIF
ENDFOR
SELE TEMPO1
GO TOP
*
_Titulo      = "VARIACION DE PRECIOS"
_Subtitulo   = []
_TipoGrafico = "LINES2D.3GR"
_TitFila     = "MESES"          && Titulo campo alfabetico
_TitColumna  = "INDICE"
DIMENSION _Vtit(6)
_Vtit[1] = [R-6]
_VTit[2] = [VS1]
_VTit[3] = [Soda]
_VTit[4] = [T/C]
_VTit[5] = [Carbonato]
_VTit[6] = [Detergente]

_FoxGraph = "H:\FOXGRAPH\FOXGRAPH.EXE"

DO  Interface_Grafica IN intergra

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

* 1ro. El Petroleo *
WAIT "Procesando Petroleo" WINDOW NOWAIT
SELE RMOV
SEEK PADR([010001],LEN(RMOV->CodMat))+XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE CodMat=[010001] .AND. LEFT(DTOS(FchDoc),6) <= XsAnoMes2
   IF !( TipMov+CodMov = [I001] )
      SKIP
      LOOP
   ENDIF
   XiMes    = MONTH(FchDoc)
   XsAnoMes = LEFT(DTOS(FchDoc),6)
   STORE 0 TO XfCanDes,XfImpCto
   SCAN WHILE CodMat=[010001] .AND. LEFT(DTOS(FchDoc),6) = XsAnoMes ;
        FOR TipMov+CodMov = [I001]
      XfCanDes = XfCanDes + CanDes
      XfImpCto = XfImpCto + IIF(VMOV->CodMon=1,ImpCto/VMOV->TpoCmb,ImpCto)
   ENDSCAN
   *
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes    WITH XsMes
   ENDIF
   REPLACE Serie1 WITH Serie1 + (XfImpCto/XfCanDes)
   *
   SELE RMOV
ENDDO
* 2do. Soda Caustica *
WAIT "Procesando Soda Caustica" WINDOW NOWAIT
SELE RMOV
SEEK PADR([011001],LEN(RMOV->CodMat))+XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE CodMat=[011001] .AND. LEFT(DTOS(FchDoc),6) <= XsAnoMes2
   IF !( TipMov+CodMov = [I001] )
      SKIP
      LOOP
   ENDIF
   XiMes    = MONTH(FchDoc)
   XsAnoMes = LEFT(DTOS(FchDoc),6)
   STORE 0 TO XfCanDes,XfImpCto
   SCAN WHILE CodMat=[011001] .AND. LEFT(DTOS(FchDoc),6) = XsAnoMes ;
        FOR TipMov+CodMov = [I001]
      XfCanDes = XfCanDes + CanDes
      XfImpCto = XfImpCto + IIF(VMOV->CodMon=1,ImpCto/VMOV->TpoCmb,ImpCto)
   ENDSCAN
   *
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie3 WITH Serie3 + (XfImpCto/XfCanDes)/1000
   *
   SELE RMOV
ENDDO
* 3do. Carbonato *
WAIT "Procesando Carbonato" WINDOW NOWAIT
*SELE RMOV
*SEEK PADR([001001],LEN(RMOV->CodMat))+XsAnoMes1
*IF !FOUND()
*   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
*      GO RECNO(0)
*      IF DELETED()
*         SKIP
*      ENDIF
*   ENDIF
*ENDIF
*DO WHILE CodMat=[001001] .AND. LEFT(DTOS(FchDoc),6) <= XsAnoMes2
*   IF !( TipMov+CodMov = [I001] )
*      SKIP
*      LOOP
*   ENDIF
*   XiMes    = MONTH(FchDoc)
*   XsAnoMes = LEFT(DTOS(FchDoc),6)
*   STORE 0 TO XfCanDes,XfImpCto
*   SCAN WHILE CodMat=[001001] .AND. LEFT(DTOS(FchDoc),6) = XsAnoMes ;
*        FOR TipMov+CodMov = [I001]
*      XfCanDes = XfCanDes + CanDes
*      XfImpCto = XfImpCto + IIF(VMOV->CodMon=1,ImpCto/VMOV->TpoCmb,ImpCto)
*   ENDSCAN
*   *
*   SELE TEMPO
*   XsMes = LEFT(MES(XiMes,1),3)
*   SEEK XsMes
*   IF !FOUND()
*      APPEND BLANK
*      REPLACE Mes WITH XsMes
*   ENDIF
*   REPLACE Serie5 WITH Serie5 + (XfImpCto/XfCanDes)/1000
*   *
*   SELE RMOV
*ENDDO
SELE DETER
SEEK XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE AnoMes <= XsAnoMes2 .AND. !EOF()
   XiMes    = VAL(SUBST(AnoMes,5,2))
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie5 WITH DETER->PreCar
   *
   SELE DETER
   SKIP
ENDDO
* 4to. VS1 *
WAIT "Procesando VS1" WINDOW NOWAIT
SELE GDOC
xFOR = "INLIST(GDOC->CodDoc,[FAC],[BOL]) .AND. FlgEst # [A] "
SEEK XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE LEFT(DTOS(FchDoc),6) <= XsAnoMes2 .AND. !EOF()
   IF !(&xFOR)
      SKIP
      LOOP
   ENDIF
   XiMes = MONTH(FchDoc)
   XsAnoMes = LEFT(DTOS(FchDoc),6)
   STORE 0 TO XfCanFac,XfImpFac
   SCAN WHILE LEFT(DTOS(FchDoc),6) = XsAnoMes FOR &xFOR
      * buscamos detalle de facturas/boletas
      SELE ITEM
      SEEK GDOC->CodDoc+GDOC->NroDoc
      SCAN WHILE ITEM->CodDoc+ITEM->NroDoc=GDOC->CodDoc+GDOC->NroDoc FOR INLIST(CodMat,"004","002")
         XfCanFac = XfCanFac + ITEM->CanFac*ITEM->FacEqu/1000   && << OJO <<
         XfImpFac = XfImpFac + IIF(GDOC->CodMon=1,ITEM->CanFac*ITEM->PreUni,;
                    ITEM->Canfac*ITEM->PreUni/GDOC->TpoCmb)
      ENDSCAN
      SELE GDOC
   ENDSCAN
   *
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie2 WITH Serie2 + (XfImpFac/XfCanFac)/1000
   *
   SELE GDOC
ENDDO
* 5to. T/Cambio *
WAIT "Procesando T/Cambio" WINDOW NOWAIT
SELE TCMB
SEEK XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE LEFT(DTOS(FchCmb),6) <= XsAnoMes2 .AND. !EOF()
   XiMes = MONTH(FchCmb)
   XsAnoMes = LEFT(DTOS(FchCmb),6)
   STORE 0 TO XiDias,XfOfiVta
   SCAN WHILE LEFT(DTOS(FchCmb),6) = XsAnoMes
      XiDias   = XiDias + 1
      XfOfiVta = XfOfiVta + OfiVta
   ENDSCAN
   *
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie4 WITH Serie4 + (XfOfiVta/XiDias)
   *
   SELE TCMB
ENDDO
* 6to. Detergente *
WAIT "Procesando Detergente" WINDOW NOWAIT
SELE DETER
SEEK XsAnoMes1
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
DO WHILE AnoMes <= XsAnoMes2 .AND. !EOF()
   XiMes    = VAL(SUBST(AnoMes,5,2))
   SELE TEMPO
   XsMes = LEFT(MES(XiMes,1),3)
   SEEK XsMes
   IF !FOUND()
      APPEND BLANK
      REPLACE Mes WITH XsMes
   ENDIF
   REPLACE Serie6 WITH DETER->PreDet
   *
   SELE DETER
   SKIP
ENDDO
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
