**************************************************************************
*  Nombre       : CbdPCDIA.PRG
*  Autor        : Jorge Mieses
*  Proposito    : Cierre de DIA
*  Creaci¢n     : 11/01/91
*  Actualizaci¢n:   /  /
*
**************************************************************************
*IF ! Master
*   DO LIB_MERR WITH 3
*   RETURN
*ENDIF
** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CIERRE DIARIO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

@  9,13 FILL  TO  22,63 COLOR W/N
@  7,15 CLEAR TO  20,65
@  7,15 TO  20,65
i          = 1
UltTecla   = 0
Itm        = 1
SELECT 4
USE CBDRMOVM ORDER RMOV01 ALIAS RMOV
if !used(4)
    close data
    return
endif
sele 5
use cbdvmovm order VMOV03 ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(7)
    close data
    return
ENDIF
SELECT 1
USE CBDTCIER
if !used(1)
    close data
    return
endif
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
IF m.Cierre
   GsMsgErr = "Mes Cerrado"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

XdFchAst = DATE()
XsCodOpe = SPACE(LEN(RMOV->CodOpe))

@ 09,18 SAY " Fecha de Proceso : "
@ 11,18 SAY "        Operaci¢n : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 09,38 GET XdFchAst
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELECT OPER
         @ 11,38 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF CBDBUSCA("OPER")
               XsCodOpe = CodOpe
            ELSE
               LOOP
            ENDIF
         ENDIF
         @ 11,38 SAY XsCodOpe
         SEEK XsCodOpe
         @ 12,38 SAY NomOpe pict "@s25"
         IF ! FOUND()
            DO LIB_MERR WITH 9
            UltTecla = 0
            LOOP
         ENDIF
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )

      CASE UltTecla = Enter
         IF  i < 2
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
M.OK = 1
@ 14,18 SAY "CONFORME  : " GET m.ok PICT "@*H \<Salir;\<Continuar"
READ
IF LASTKEY()  = 27 .OR. Ok = 1
   CLOSE DATA
   RETURN
ENDIF
@ 16,27 SAY "*** EN PROCESO DE CIERRE ***" COLOR -
SELECT VMOV
LLave = XsCodOpe+DTOC(XdFchAst,1)
SEEK Llave
DO WHILE ! EOF() .AND. CodOpe+DTOC(FchAst,1)=LLave
   IF FLGEST $ " R" .AND. REC_LOCK(5)
      REPLACE FLGEST WITH "C"
   ENDIF
   SKIP
ENDDO
CLOSE DATA
@ 16,27 SAY "                            "
GsMsgErr = "CIERRE DE DIA COMPLETADO .."
DO LIB_MERR WITH 99
RETURN
