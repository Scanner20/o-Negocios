GsClfAux = [01 ]  && Proveedores
DIMENSION XvCalc(12)
STORE 0 TO XvCalc
DO WHILE .T.
   CLEAR
   @  0, 0 TO 23, 79 PANEL
   @  2,3 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
   @  3,3 SAY "ÃÄÜÛÛÛÛÛÜÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÜÛÛÛÛÛÜÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" COLOR SCHEME 7
   @  4,3 SAY "ÃÄÛÛßßßÛÛÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÛÛßßßÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" COLOR SCHEME 7
   @  5,3 SAY "ÃÄÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" COLOR SCHEME 7
   @  6,3 SAY "ÃÄÛÛÄÄÄÄÄÄÜÛÛÛÛÜÄÄÄÄÄÛÛÄÜÛÛÛÛÜÄÄÄÛÛÜÜÜÛßÄÄÜÛÛÛÛÜÄÛÛ ÛÛÛÜÄÜÛÛÛÛÜÄÜÛÛÛÛÜÄ´" COLOR SCHEME 7
   @  7,3 SAY "ÃÄÛÛÄÄÄÄÄÄßßÄÄÛÛÄÄÄÄÄÛÛÄßßÄÄÛÛÄÄÄÛÛßßßßÛÜÄßßÄÄÛÛÄÄÛÛßßÛÛÄÛÛßßÛÛÄÛÛßßÛÛÄ´" COLOR SCHEME 7
   @  8,3 SAY "ÃÄÛÛÄÄÄÄÄÄÄÜÛÛÛÛÄÛÛÄÄÛÛÄÄÜÛÛÛÛÄÄÄÛÛÄÄÄÄÛÛÄÄÜÛÛÛÛÄÄÛÛÄÄÛÛÄÛÛÄÄÄÄÄÛÛÄÄÛÛÄ´" COLOR SCHEME 7
   @  9,3 SAY "ÃÄÛÛÜÜÜÛÛÄÛÛÄÄÛÛÄÛÛÄÄÛÛÄÛÛÄÄÛÛÄÄÄÛÛÜÜÜÜÛÛÄÛÛÄÄÛÛÄÄÛÛÄÄÛÛÄÛÛÜÜÛÛÄÛÛÜÜÛÛÄ´" COLOR SCHEME 7
   @ 10,3 SAY "ÃÄßÛÛÛÛÛßÄßÛÛÛÛßÄßÛÛÛÛßÄßÛÛÛÛßÄÄÄßÛÛÛÛÛÛßÄßÛÛÛÛßÄÄÛÛÄÄÛÛÄßÛÛÛÛßÄßÛÛÛÛßÄ´" COLOR SCHEME 7
   @ 11,3 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼" COLOR SCHEME 7
** @ 12,23 SAY "                                  "
** @ 13,23 SAY "                                  "
   @ 14,7 TO 21,71 Double
   @ 17,7 TO 17,71 Double
   @ 17,7  SAY "Ì"
   @ 17,71 SAY "¹"
** @ 15,23 SAY "CAJASYS-Multiuser Versi¢n 7.0/1,993"
   @ 16,23 SAY GsCodCia+" "+GsNomCia   PICT "@I"
   CLOSE DATA
   SELECT 1
   USE CBDTANOS ALIAS ANOS
   IF ! USED(1)
      CLOSE DATA
      RETURN
   ENDIF
   GOTO BOTTOM
   LOCATE FOR ! CIERRE
   _ANO = PERIODO
   _MES = MESCAJA
   IF YEAR(DATE()) = _Ano
      _MES = MONTH(DATE())
   ENDIF

   IF RECCOUNT() > 1
      @ 19,29 SAY " A¤o de Proceso :" GET _Ano PICT "9,999" VALID _PERIODO()
   ELSE
      @ 19,29 SAY " A¤o de Proceso : "+TRANS(_Ano,"9,999")
   ENDIF
   @ 20,29 SAY " Mes de Proceso :" GET _Mes PICT "@L ##" VALID _MES()
   READ
   IF LASTKEY() = Escape
      CLOSE DATA
      RETURN
   ENDIF
   IF _ANO <> PERIODO
      LOCATE FOR _ANO = PERIODO
   ENDIF
   IF _MES <> MESCAJA
      IF RLOCK()
         REPLACE MESCAJA WITH _MES
      ENDIF
   ENDIF
   CLOSE DATA
   IF _Mes < 12
      GdFecha   = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
   ELSE
      GdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
   ENDIF

   TsPathCia = "cia"+GsCodCia
   TsPathDbf  = PathOrg+";"+PathDef+"\"+TsPathCia
   SET PATH TO (TsPathDbf)
   TsPathDbf  = PathDef+"\"+TsPathCia+"\C"+LTRIM(STR(_ANO))
   SET DEFAULT TO (TsPathDbf)
   *** Ojo - Para captar variables de configuracion general ** vett 17/05/2000
   STORE 0 TO M.TIPO_EMPRE,M.TIPO_CONSO,M.MAX_AUXIL,M.C_COSTO
   STORE "" TO M.DIR_SIST1,M.DIR_SIST2,M.DIR_SIST3
   do chkdirsist
   DO CJAMENUS
ENDDO


*******************
FUNCTION _PERIODO
*******************
LOCATE FOR PERIODO = _ANO
RETURN FOUND()

*************
FUNCTION _MES
*************
IF _MES < 0 .OR. _MES > 13
  GsMsgErr = "Invalido mes de Trabajo"
  DO LIB_MERR WITH 99
  RETURN .F.
ENDIF
@ 20,50 SAY Mes(_Mes,1)
RETURN .T.
********************
procedure chkdirsist
********************
IF !FILE("CBDCNFG0.dbf")

	nResp=F1_alert("Archivo de configuracion principal no existe.;"+;
			  "Es necesario crear el archivo de configuraci¢n;"+;
			  "principal para continuar.","PROCESO")
			   
	IF nResp=2
		=f1_alert("No se ha instalado el archivo de configuracion principal;"+;
			"se abandonara el modulo","MENSAJE")		 
		close data 
		return		
	ENDIF		   
	DO CBDCNFG0.SPR
ENDIF
SELE 0
USE CBDCNFG0 ALIAS CNFG0
SCATTER MEMVAR
USE 
RETURN 