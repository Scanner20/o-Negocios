**************************************************************************
*
*  Nombre       : Cbdconfg.PRG
*  Autor        : Jorge Mieses
*  Proposito    : Configuraci¢n del Sistema
*  Creaci¢n     : 11/01/91
*  Actualizaci¢n:   /  /
*
**************************************************************************
IF ! Master
   DO LIB_MERR WITH 3
   RETURN
ENDIF
*IF ! Clave(CFGPasswD)
*   DO LIB_MERR WITH 3
*   RETURN
*ENDIF

** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

xClave  = SPACE(10)
xClave1 = SPACE(10)
xClave2 = SPACE(10)
xClave3 = SPACE(10)

_CONFI = "CBDCONFG"
RESTORE FROM &_CONFI ADDITIVE
IF TYPE("CFGPASSWD")="U"
   CFGPASSWD = ENCRIPTA("VALMIESA  ",10)
ENDIF
IF TYPE("CFGAPERTU")="U"
   CFGAPERTU = ENCRIPTA("VALMIESA  ",10)
ENDIF
IF TYPE("CFGCIERRE")="U"
   CFGCIERRE = ENCRIPTA("VALMIESA  ",10)
ENDIF
IF TYPE("CFGDIARIO")="U"
   CFGDIARIO = ENCRIPTA("VALMIESA  ",10)
ENDIF
xClave  = DESCRIPT(CFGPASSWD,10)
xClave1 = DESCRIPT(CFGAPERTU,10)
xClave2 = DESCRIPT(CFGCIERRE,10)
xClave3 = DESCRIPT(CFGDIARIO,10)

@  9,13 FILL  TO  22,63 COLOR W/N
@  7,15 CLEAR TO  20,65
@  7,15 TO  20,65
i          = 1
UltTecla   = 0
Itm        = 1

@ 13,18 SAY "CLAVE CIERRE      -DIA: " GET xClave3
@ 14,18 SAY "CLAVE DE CIERRE   -MES: " GET xClave2
@ 15,18 SAY "CLAVE DE APERTURA -MES: " GET xClave1
@ 16,18 SAY "PASSWORD MASTER       : " GET xClave

READ
IF LASTKEY()  <> 27
   CFGDIARIO = ENCRIPTA(xClave3,10)     && Encriptar
   CFGCIERRE = ENCRIPTA(xClave2,10)     && Encriptar
   CFGAPERTU = ENCRIPTA(xClave1,10)     && Encriptar
   CFGPASSWD = ENCRIPTA(xClave ,10)     && Encriptar
   SAVE TO &_CONFI ALL LIKE CFG*
   SAVE TO CBDBAK  ALL LIKE CFG*

ENDIF
RETURN
