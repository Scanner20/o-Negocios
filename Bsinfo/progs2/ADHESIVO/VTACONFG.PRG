**************************************************************************
*
*  Nombre       : Vtaconfg.PRG
*  Autor        : Jorge Mieses
*  Proposito    : Configuraci¢n del Sistema
*  Creaci¢n     : 11/01/91
*  Actualizaci¢n: 02/08/94  VETT   FOXPRO
*
**************************************************************************
IF ! Master
   DO LIB_MERR WITH 3
   RETURN
ENDIF
** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(MONTH(GdFecha),3)+" "+TRANS(YEAR(GdFecha),"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONFIGURACION"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
xClave  = SPACE(10)
CFGGLOANO= SPACE(48)
RESTORE FROM VTACONFG ADDITIVE
xClave  = DESCRIPT(CFGPASSWD,10)
@  8,05 FILL  TO  21,73 COLOR W/N
@  7,06 CLEAR TO  20,74
@  7,06 TO  20,74
i          = 1
UltTecla   = 0
Itm        = 1
@ 09,09 SAY "        CLAVE  : "
@ 10,09 SAY "      % I.G.V. : "
@ 11,09 SAY " GLOSA DEL A¥O : "
@ 12,09 SAY PADC("*** DATOS PARA AL IMPRESION DE GUIAS ***",59)
@ 13,09 SAY "TRANSPORTISTA  : "
@ 14,09 SAY "           RUC : "
@ 15,09 SAY "        CHOFER : "
@ 16,09 SAY "   VEHICULO NO.: "
@ 17,09 SAY "    BREVETE NO.: "
@ 18,09 SAY "           A¥O : "



DO WHILE !INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
         @ 09,26 GET xClave
         READ
         UltTecla = Lastkey()
      CASE i = 2
         @ 10,26 GET CfgAdmIgv PICT "999.99"
         READ
         UltTecla = Lastkey()
      CASE i = 3
         @ 11,26 GET CfgGloAno PICT "@!"
         @ 13,26 GET CfgNomTra PICT "@!"
         @ 14,26 GET CfgRUCTra
         @ 15,26 GET CfgNomCho PICT "@!"
         @ 16,26 GET CfgPlaTra PICT "@!"
         @ 17,26 GET CfgNroBre PICT "@!"
         @ 17,26 GET CFGANO    PICT "9999"
         READ
         UltTecla = Lastkey()
      CASE i = 4
         IF UltTecla = Enter
            UltTecla = F10
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4, 4, i)
   i = IIF(i<1, 1, i)
ENDDO
IF UltTecla <> Escape
   CFGPASSWD = ENCRIPTA(xClave,10)     && Encriptar
   SAVE TO VTACONFG ALL LIKE CFG*
ENDIF
RETURN
