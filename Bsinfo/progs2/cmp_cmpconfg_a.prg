**************************************************************************
*  Nombre       : Cmpconfg.PRG
*  Autor        : VETT
*  Proposito    : Configuraci¢n del Sistema
*  Creaci¢n     : 05/12/94
*  Actualizaci¢n:
**************************************************************************
*!*	DO def_teclas IN fxgen_2
*!*	SYS(2700,0)
*!*	Pintamos Pantalla
*!*	cTit1 = GsNomCia
*!*	cTit2 = MES(MONTH(GdFecha),3)+" "+TRANS(YEAR(GdFecha),"9999")
*!*	cTit3 = "Usuario : "+TRIM(GsUsuario)
*!*	cTit4 = "CONFIGURACION"
*!*	Do Fondo WITH cTit1,cTit2,cTit3,cTit4
xClave  = SPACE(10)
CFGGLOANO= SPACE(48)
CFGGLOO_C= SPACE(70)
STORE SPAC(60) TO CFGDIR1, CFGDIR2, CFGDIR3
STORE SPAC(25) TO CFGTit1, CFGTit2
STORE SPAC(20) TO CFGCTit1, CFGCTit2
STORE SPAC(70) TO CFGGloI1, CFGGloI2, CFGGloI3, CFGGloI4
STORE SPAC(3) TO CFGIng, CFGCmp
STORE 0 TO CfgAmer, CfgRest, CfgAereo, CfgMarit, CfgConso, CfgLleno
IF FILE(GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM')
   *RESTORE FROM VTACONFG ADDITIVE
   RESTORE FROM GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM' ADDITIVE
ENDIF

xClave  = DESCRIPT(CFGPASSWD,10)
CFGGLOI1= LEFT(CFGGLOI1+SPACE(70),70)
CFGGLOI2= LEFT(CFGGLOI2+SPACE(70),70)
*!*	@  6,00 FILL  TO  20,73 COLOR W/N
*!*	@  5,00 CLEAR TO  22,90
*!*	@  5,00 TO  22,90
*!*	i          = 1
*!*	UltTecla   = 0
*!*	Itm        = 1
*!*	@ 07,05 SAY "         CLAVE :                       % I.G.V. : "
*!*	@ 09,05 SAY PADC("*** DATOS PARA AL IMPRESION DE O/Cs ***",59)
*!*	@ 10,05 SAY "  Glosa (Nac.) : "
*!*	@ 13,05 SAY " DIRECCION => "
*!*	@ 14,05 SAY "  Dirección 1: "
*!*	@ 15,05 SAY "  Dirección 2: "
*!*	@ 16,05 SAY "  Dirección 3: "

*!*	@ 07,22 GET xClave
*!*	@ 07,58 GET CfgAdmIgv PICT "999.99"
*!*	@ 10,22 GET CfgGloI1 PICT "@(S70)"
*!*	@ 11,22 GET CfgGloI2 PICT "@(S70)"
*!*	@ 14,20 GET CFGDir1 PICT "@S50"
*!*	@ 15,20 GET CFGDir2 PICT "@S50"
*!*	@ 16,20 GET CFGDir3 PICT "@S50"
*!*	CLEAR gets 

*!*	DO WHILE !INLIST(UltTecla,Escape_,CtrlW,F10)
*!*	   DO CASE
*!*	      CASE i = 1
*!*	         @ 07,22 GET xClave
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 2
*!*	         @ 07,58 GET CfgAdmIgv PICT "999.99"
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 3
*!*	         @ 10,22 GET CfgGloI1 PICT "@(S70)"
*!*	         @ 11,22 GET CfgGloI2 PICT "@(S70)"
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 4 
*!*	         @ 14,20 GET CFGDir1 PICT "@S50"
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 5 
*!*	         @ 15,20 GET CFGDir2 PICT "@S50"
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 6 
*!*	         @ 16,20 GET CFGDir3 PICT "@S50"
*!*	         READ
*!*	         UltTecla = Lastkey()
*!*	      CASE i = 7
*!*				IF UltTecla = Escape_
*!*					exit
*!*	      		ENDIF
*!*	         IF INLIST(UltTecla,Enter,CTRLW,F10)
*!*	            UltTecla = F10
*!*	         ELSE
*!*	            i = 1
*!*	            Loop
*!*	         ENDIF
*!*	   ENDCASE
*!*	   i = IIF(UltTecla = Arriba, i-1, i+1)
*!*	   i = IIF(i>7, 7, i)
*!*	   i = IIF(i<1, 1, i)
*!*	ENDDO
*!*	IF UltTecla <> Escape_
*!*	   CFGPASSWD = ENCRIPTA(xClave,10)     && Encriptar
*!*	   SAVE TO GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM' ALL LIKE CFG*
*!*	ENDIF
*!*	CLEAR 
*!*	CLEAR MACROS
*!*	IF WEXIST('__WFondo')
*!*		RELEASE WINDOW __WFondo
*!*	ENDIF

SYS(2700,0)
RETURN
