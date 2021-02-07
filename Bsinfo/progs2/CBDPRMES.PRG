**************************************************************************
*  Nombre       : CbdPRMES.PRG
*  Autor        : Jorge Mieses
*  Proposito    : Reapertura de Mes
*  Creaci¢n     : 11/01/91
*  Actualizaci¢n:   /  /
*
**************************************************************************
IF ! Master
   DO LIB_MERR WITH 3
   RETURN
ENDIF
** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REAPERTURA DE MES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

@  9,13 FILL  TO  22,63 COLOR W/N
@  7,15 CLEAR TO  20,65
@  7,15 TO  20,65
i          = 1
UltTecla   = 0
Itm        = 1
SELECT 1
USE CBDTCIER
RegAct = _Mes + 1
IF RegAct <= RECCOUNT()
   GOTO RegAct
   M.Cierre  = Cierre
ELSE
  DO WHILE ! RECCOUNT() = RegAct
     APPEND BLANK
  ENDDO
   M.Cierre  = .F.
ENDIF
IF ! m.Cierre
   GsMsgErr = "Mes NO Cerrado"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
M.OK = 1
@ 14,18 SAY "REAPERTURA DE MES : " GET m.ok PICT "@*H \<Salir;\<Reapertura"
READ
IF LASTKEY()  <> 27 .AND. Ok = 2
   IF REC_LOCK(5)
      REPLACE CIERRE WITH .F.
   ENDIF
ENDIF
close data
RETURN
