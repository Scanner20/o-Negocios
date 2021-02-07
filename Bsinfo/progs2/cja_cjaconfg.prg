**************************************************************************
*
*  Nombre       : Cbdconfg.PRG
*  Autor        : VETT
*  Proposito    : Configuraci¢n del Sistema
*  Creaci¢n     : 11/01/91
*  Actualizaci¢n:   /  /
*
**************************************************************************
DO FORM cja_cjaconfg
RETURN

SYS(2700,0)
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA50

** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
xClave  = SPACE(10)

RESTORE FROM GoCfgVta.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE
xClave  = DESCRIPT(CFGPASSWD,10)

@  9,13 FILL  TO  22,63 COLOR W/N
@  7,15 CLEAR TO  20,65
@  7,15 TO  20,65
i          = 1
UltTecla   = 0
Itm        = 1
@ 16,18 SAY "CLAVE DE MODIFICACION : " GET xClave
READ
IF LASTKEY()  <> 27
   CFGPASSWD = ENCRIPTA(xClave,10)     && Encriptar
   SAVE TO GoCfgVta.oentorno.tspathcia+'CJACONFG.MEM' ALL LIKE CFG*
ENDIF

IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

SYS(2700,1)
RETURN
