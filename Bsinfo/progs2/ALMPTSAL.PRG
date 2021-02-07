*+---------------Ñ-------------------------------------------------------------+
*Ý Nombre        Ý almpTsal.prg                                                Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Sistema       Ý Almacenes e Inventarios                                     Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Prop¢sito     Ý Proceso de cierre de almacen por corte de fecha.            Ý
*Ý               Ý Calcula el stock y valor a la fecha y borra informaci¢n     Ý
*Ý               Ý hasta la fecha.                                             Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Creaci¢n      Ý 08/03/96                                                    Ý
*Ç---------------+-------------------------------------------------------------¶
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+---------------Ï-------------------------------------------------------------+
=F1_BASE(GsNomCia,GsNomSub,"USUARIO:"+GsUsuario,"FECHA:"+GsFecha)

if _ano = 1998 AND GsCodCia=[001]     && Solo Cia. Insumos 06/07/99 12:38p.m.
   do f1MsgErr with [Imposible Actualizar Saldos al Pr¢ximo A¤o -> 1999]
   return
endif

IF F1_ALERT([Este proceso calcula los stocks y valores del almacen en ;]+;
            [el que nos encontramos hasta la fecha indicada.          ;]+;
            [Luego traslada los saldos obtenidos al proximo a¤o como  ;]+;
            [valores iniciales.                                       ;]+;
            [das en el sistema hasta la fecha indicada.               ;]+;
            [                                                         ;]+;
            [                                                         ;]+;
            [SE RECOMIENDA TENER BACKUP DE LA INFORMACION A PROCESAR. ;],2)#1

   CLOSE DATA
   RETURN
ENDIF

HayTransfer = .F.
MovTra   = []
m.Tipo   = 1   && 1 Cantidad , 2 Valor
m.TipMat = 1
m.General = .F.
XfTpoCmb  = 0
UltTecla  = 0
m.Control = 1
Cancelar  = .F.
*** Variables necesarias ***
m.CodMatD = []
m.CodMatH = []
m.DesmatD = []
m.DesmatH = []
nCodMon   = 1
m.Cuales  = 2
dFchDocD  = GdFecha
dFchDocH  = GdFecha
m.estado  = 1
m.borratodo=1
*** Variables de control
sAyuda_O1 = [Presione F8 para consultar]
m.Control = 1
UltTecla  = 0
*** Variables que controlan los directorios a manipular
DirNew = []
DirAct = []
LcSlash = [\]
DO CASE
   CASE _UNIX

        LcSlash = [/]
   CASE _DOS

        LcSlash = [\]

ENDCASE



DO Almptsal.spr
Ven_Actual = woutput()
IF !EMPTY(Ven_Actual)
    DEACTIVATE WINDOW (Ven_Actual)
    RELEASE WINDOW (Ven_actual)
ENDIF

CLOSE DATA
DELE FILE &Arch..DBF
DELE FILE &Arch..CDX
=F1_ALERT([Una vez que se ha ejecutado este proceso sin tener   ;]+;
          [ningun problema en el sistema, ingresar al nuevo a¤o ;]+;
          [y ejecutar la opci¢n de recalculo de stock y valor   ;]+;
          [para situar los saldos iniciales.                    :],3)


RETURN
******************
FUNCTION AbrirDbfs
******************
=F1QEH("ABRE_DBF")
SELE 7
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF !USED()
   RETURN .F.
ENDIF
SELE 6
USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
IF !USED()
   RETURN .F.
ENDIF
SELE 5
USE ALMDTRAN ORDER DTRA03 ALIAS DTRA
IF !USED()
   RETURN .f.
ENDIF
SELE 4
USE ALMCTRAN ORDER CTRA01 ALIAS CTRA
IF !USED()
   RETURN .f.
ENDIF
SELE 3
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
IF !USED()
   RETURN .f.
ENDIF
SELE 2
USE ALMCATAL ORDER CATA02 ALIAS CALM
IF !USED()
   RETURN .f.
ENDIF
SELE 1
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   RETURN .f.
ENDIF
*
* SOLO PARA EL A¥O 1998 POR LA RECLASIFICACION DE CODIGOS
*
if _ano = 1998 AND GsCodCia=[001]  && 06/07/99 12:38p.m.
   sele 0 
   use catgenew order catg01 alias new
   if !used()
      return .f.
   endif
endif
*
** Preparamos archivo temporal **
SELE 0
Arch = PAthUser+SYS(3)
CREATE TABLE &Arch. (SubAlm C(LEN(CALM.SubAlm)),;
                     CodMat C(LEN(CATG.Codmat)), StkIni N(14,3), ;
                     VIniMn N(14,3),Activo L(1),;
                     codnew c(len(catg.codnew)))

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   GsMsgErr = [No se pudo generar temporal.]
   DO F1MsgErr WITH GsMsgErr
   RETURN .F.
ENDIF
INDEX ON SubAlm+CodMat TAG TMP01
INDEX ON CODMAT+SUBALM TAG TMP02
index on codnew+subalm tag tmp03
SET ORDER TO TMP01
=F1QEH("OK")
RETURN .T.
*******************
PROCEDURE TransArch
*******************
IF !F1_Apert(5,2,7,2)
   =F1_alert([Error en transferencia de archivo al nuevo a¤o;]+;
             [Verificar atributos de lectura y escritura.],3)
   RETURN

ENDIF
IF !ABRIRDBFS()
   DO F1MSGERR WITH [Error en apertura de archivos]
   CLOSE DATA
   RETURN
ENDIF
DO ABRENEWANO
m.CodMatD = SPACE(LEN(CATG.CodMat))
m.CodMatH = SPACE(LEN(CATG.CodMat))
m.DesmatD = SPACE(LEN(CATG.DesMat))
m.DesmatH = SPACE(LEN(CATG.DesMat))
DO TRFSaldos
RETURN
********************
PROCEDURE ABRENEWANO
********************
SELE 0
USE &DirNew.ALMCATAL ORDER CATA01 ALIAS CALMX
IF !USED()
   RETURN .f.
ENDIF
SELE 0
USE &DirNew.ALMCATGE ORDER CATG01 ALIAS CATGX
IF !USED()
   RETURN .f.
ENDIF
=F1QEH("OK")
RETURN .T.
*******************
PROCEDURE TrfSalDos
*******************
LsMsg=[CALCULANDO SALDOS DE STOCK Y VALOR AL ]+DTOC(dFchDocH)
LnCol=WCOL()-LEN(LsMsg)
@ 5,2 SAY PADR(LsMsg,WCOL()-2)
** ARMAR LOS TEST DE IMPRESION **
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.CodMatH)+CHR(255)
m.Cuales  = 2
Cancelar = .f.
SELECT CATG
SEEK TRIM(m.CodMatD)
IF ! FOUND() .AND. RECNO(0)>0
   GOTO RECNO(0)
   IF DELETED()
      SKIP
   ENDIF
ENDIF
DO WHILE CATG->CodMat <= m.CodMatH .AND. ! EOF() .AND. ! Cancelar
   @ 7,2 say [PROCESANDO CODIGO:]+CATG->CodMat+"  "+CATG->DesMat SIZE 1,68
   LsCodMat = CodMat
   SELE CALM
   SEEK LsCodMat
   SCAN WHILE  CodMat=LsCodMat
      LsSubAlm = CALM.Subalm
      sCodMat  = CALM.CodMat
      fStkSub  = CALM->StkIni
      fStkAct  = CALM->StkIni
      fValAct  = IIF(nCodMon = 1, CALM->VIniMn, CALM->VIniUs)
    **WAIT [Procesando Codigo ]+sCodMat WINDOW NOWAIT
      *** HALLAR EL STOCK DEL ALMACEN ***
      SELE DTRA
      GO TOP
      IF EOF()
         SELE CALM
         LOOP
      ENDIF
      SET ORDER TO DTRA02
      SEEK LsSubAlm+sCodMat+DTOS(dFchDocH+1)
      IF !FOUND()
         IF RECNO(0)>0
            GO RECNO(0)
            IF DELETED()
               SKIP
            ENDIF
         ENDIF
      ENDIF
      SKIP -1
      IF SubAlm+CodMat = LsSubAlm+sCodMat AND FchDoc<=dFchDocH
          fStkSub = DTRA->StkSub
      ENDIF
      *** HALLAR EL VALOR GENERAL ***
      SELE DTRA
      SET ORDER TO DTRA03
      SEEK sCodMat+DTOS(dFchDocH+1)
      IF !FOUND()
         IF RECNO(0)>0
            GO RECNO(0)
            IF DELETED()
               SKIP
            ENDIF
         ENDIF
      ENDIF
      SKIP -1
      IF CodMat = sCodMat AND FchDoc<=dFchDocH
         fStkAct = DTRA.StkAct
         fValAct = IIF(nCodMon = 1,VCTOMN,VCTOUS)
      ENDIF
      *** HALLAR EL VALOR DEL ALMACEN ***
      fValSub = IIF(fStkAct>0,fValAct/fStkAct*fStkSub,0)
      IF !(m.Cuales = 1 .AND. fStkSub<=0)
         SELE TEMPO
         SEEK LsSubAlm+sCodMat
         IF !FOUND()
            APPEND BLANK
            REPLACE TEMPO.SubAlm WITH LsSubAlm
            REPLACE TEMPO.CodMat WITH sCodMat
         ENDIF
         REPLACE TEMPO.StkIni WITH IIF(fStkSub>=0,fStkSub,0)
         REPLACE TEMPO.VIniMn WITH IIF(fValSub>=0,fValSub,0)
         REPLACE TEMPO.Activo WITH !CATG.Inactivo
      ENDIF
      SELE CALM
   ENDSCAN
   SELE CATG
   SKIP
ENDDO

SELE TCMB
SEEK DTOS(GdFecha)
IF !FOUND() AND RECNO(0)>0
    GO RECNO(0)
ENDIF
XfTpoCmb = TCMB.OfiVta
@5,2 SAY [TRANSFIRIENDO NUEVO SALDO AL ]+dtoc(dfchdoch+1)

** Grabamos en CATALOGO POR ALMACEN DEL NUEVO A¥O
SELE CALMX
GO TOP
SCAN
   DO WHILE !RLOCK()
   ENDDO
   REPLACE StkIni WITH 0
   REPLACE ViniMn WITH 0
   REPLACE ViniUs WITH 0
   UNLOCK
ENDSCAN
*
if _ano = 1998 AND GsCodCia=[001]  &&& Reclasificacion de Codigos 06/07/99 12:40p.m.
   sele tempo
   set order to tmp02
   go top
   scan
      xscodmat = tempo.codmat
      xscodnew = iif(seek(xscodmat,[new]),new.codnew,[])
      =f1_rlock(0)
      if left(xscodmat,2)>=[42] and xscodmat<=[95010430]
         repla tempo.codnew with xscodnew 
      else
         repla tempo.codnew with xscodmat
      endif   
      unlock 
   endscan
   *
   sele tempo
   set filter to !empty(codnew)
   *
endif
*
if _ano = 1998 AND GsCodCia=[001]   &&& Reclasificaci¢n de C¢digos 06/07/99 12:40p.m.
   SELE TEMPO
   SET ORDER TO TMP03
   GO TOP
   SCAN
       lfound=seek(tempo.codnew,[catgx])
       DO CASE
          CASE !lFound AND TEMPO.StkIni<>0
               SELE CATG
               SEEK TEMPO.CodMat
               SCATTER MEMVAR
               SELE CATGX
               APPEN BLANK
               DO WHILE !RLOCK()
               ENDDO
               GATHER MEMVAR
               repla catgx.codmat with tempo.codnew
               UNLOCK
          CASE !lFOUND AND Tempo.StkIni=0
       ENDCASE
       @7,2 SAY [PROCESANDO CODIGO :]+CODMAT+[ ]+catgX.dESMAT size 1 ,68
       SELE CALMX
       SEEK TEMPO.subalm+TEMPO.codnew

       DO CASE
          CASE !FOUND() AND Tempo.StkIni<>0
               APPEND BLANK
               DO WHILE !RLOCK()
               ENDDO
               REPLACE SUBALM WITH TEMPO.SUBALM
               REPLACE codmat WITH TEMPO.codnew
               REPLACE CALM->UndVta WITH CATG->UndStk
               REPLACE CALM->FacEqu WITH 1
          CASE !FOUND() AND Tempo.StkIni=0
               SELE TEMPO
               LOOP
          CASE FOUND()
               DO WHILE !RLOCK()
               ENDDO
       ENDCASE
       REPLACE StkIni WITH TEMPO.StkIni
       REPLACE VIniMn WITH TEMPO.VIniMn
       IF XfTpoCmb >0
          REPLACE VIniUs WITH ROUND(VIniMn/XfTpoCmb,4)
       ELSE
          REPLACE VIniUs WITH 0
       ENDIF
       SELE TEMPO
   ENDSCAN
else
SELE TEMPO
SET ORDER TO TMP02
GO TOP
SCAN
     LFound=SEEK(CODMAT,[CATGX])
     DO CASE
        CASE !lFound AND TEMPO.StkIni<>0
             SELE CATG
             SEEK TEMPO.CodMat
             SCATTER MEMVAR
             SELE CATGX
             APPEN BLANK
             DO WHILE !RLOCK()
             ENDDO
             GATHER MEMVAR
             UNLOCK
        CASE !lFOUND AND Tempo.StkIni=0
     ENDCASE
     @7,2 SAY [PROCESANDO CODIGO :]+CODMAT+[ ]+catgX.dESMAT size 1 ,68
     SELE CALMX
     SEEK TEMPO.SubAlm+TEMPO.CodMAt

     DO CASE
        CASE !FOUND() AND Tempo.StkIni<>0
            APPEND BLANK
            DO WHILE !RLOCK()
            ENDDO
            REPLACE SUBALM WITH TEMPO.SUBALM
            REPLACE CODMAT WITH TEMPO.CODMAT
            REPLACE CALM->UndVta WITH CATG->UndStk
            REPLACE CALM->FacEqu WITH 1
        CASE !FOUND() AND Tempo.StkIni=0
            SELE TEMPO
            LOOP
        CASE FOUND()
            DO WHILE !RLOCK()
            ENDDO
     ENDCASE
     REPLACE StkIni WITH TEMPO.StkIni
     REPLACE VIniMn WITH TEMPO.VIniMn
     IF XfTpoCmb >0
        REPLACE VIniUs WITH ROUND(VIniMn/XfTpoCmb,4)
     ELSE
        REPLACE VIniUs WITH 0
     ENDIF
     SELE TEMPO
ENDSCAN
endif
=F1QEH("Fin de procesamiento...")
SELE CATG
USE
SELE CALM
USE
SELE DTRA
USE
SELE CTRA
USE
SELE CFTR
USE
SELE DIVF
USE
SELE TCMB
USE
SELE CALMX
USE
SELE CATGX
USE
SELE TEMPO
USE
*** Registrando el nuevo a¤o ***
USE CBDTANOS
IF YEAR(DATE())<_Ano+1
	REPLACE ALL CIERRE WITH .T.
ENDIF
LOCATE FOR PERIODO = _ANO+1
IF ! FOUND()
   APPEND BLANK
   REPLACE PERIODO WITH _ANO+1
ENDIF
REPLACE CIERRE WITH .F.
use
RETURN
