SET CENTURY ON
DIMENSION XvCalc(12)
STORE 0 TO XvCalc
DO WHILE .T.
   CLEAR
   @  0, 0 TO 23, 79 PANEL
   @  2,3 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 7
   @  3,3 SAY "ÃÄÜÛÛÛÛÛÜÄÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÄÛÛÄ´" COLOR SCHEME 7
   @  4,3 SAY "ÃÄÛÛßßßÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÜÜÄÄÄÄÄÄÄÄÜÜÄÄÄÄÄÄÄÄÜÜÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄ´" COLOR SCHEME 7
   @  5,3 SAY "ÃÄÛÛÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÛÛÄÄÄÄÄÄÄÄÄÄÄÄÛÛÄ´" COLOR SCHEME 7
   @  6,3 SAY "ÃÄÛÛÄÄÄÄÄÄÜÛÛÛÛÜÄÛÛ ÛÛÛÜÄÛÛÄÜÛÛÛÛÜÄÛÛÜÛÛÜÄÛÛÄÛÛÄÛÛÄÜÛÛÜÛÛÄÜÛÛÛÛÜÄÜÛÛÜÛÛÄ´" COLOR SCHEME 7
   @  7,3 SAY "ÃÄÛÛÄÄÄÄÄÄÛÛßßÛÛÄÄÛÛßßÛÛÄÛÛÄßßÄÄÛÛÄÛÛÛßßÛÄÛÛÄÛÛÄÛÛÄÛßßÛÛÛÄßßÄÄÛÛÄÛßßÛÛÛÄ´" COLOR SCHEME 7
   @  8,3 SAY "ÃÄÛÛÄÄÄÄÄÄÛÛÄÄÛÛ  ÛÛÄÄÛÛ ÛÛÄÄÜÛÛÛÛÄÛÛÄÄÄÛÄÛÛÄÛÛÄÛÛÄÛÄÄÄÛÛÄÄÜÛÛÛÛÄÛÄÄÄÛÛÄ´" COLOR SCHEME 7
   @  9,3 SAY "ÃÄÛÛÜÜÜÛÛÄÛÛÜÜÛÛÄÄÛÛÄÄÛÛÄÛÛÄÛÛÄÄÛÛÄÛÛÛÜÜÛÄÛÛÄÛÛÄÛÛÄÛÜÜÛÛÛÄÛÛÄÄÛÛÄÛÜÜÛÛÛÄ´" COLOR SCHEME 7
   @ 10,3 SAY "ÃÄßÛÛÛÛÛßÄßÛÛÛÛßÄÄÛÛÄÄÛÛÄÛÛÄßÛÛÛÛßÄÛÛßÛÛßÄÛÛÄÛÛÄÛÛÄßÛÛßÛÛÄßÛÛÛÛßÄßÛÛßÛÛÄ´" COLOR SCHEME 7
   @ 11,3 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 7
** @ 12,23 SAY "Desarrollado por Belcsoft Software"
** @ 13,23 SAY "  Todos los derechos reservados   "
   @ 14,7 TO 21,71 Double
   @ 17,7 TO 17,71 Double
   @ 17,7  SAY "Ì"
   @ 17,71 SAY "¹"
** @ 15,23 SAY "Contabil-Multiuser Versi¢n 7.0/1,993"
   @ 16,23 SAY GsCodCia+" "+GsNomCia   PICT "@I"
   CLOSE DATA
   SELECT 1
   USE CBDTANOS ALIAS ANOS
   IF ! USED(1)
      CLOSE DATA
      RETURN
   ENDIF
   LOCATE FOR ! CIERRE
   _ANO = PERIODO
   _MES = MESCONT
   IF RECCOUNT() > 1
      @ 19,29 SAY " A¤o de Proceso :" GET _Ano PICT "9999" VALID _PERIODO()
   ELSE
      @ 19,29 SAY " A¤o de Proceso : "+TRANS(_Ano,"9999")
   ENDIF
   @ 20,29 SAY " Mes de Proceso :" GET _Mes PICT "@L ##" VALID _MES()
   READ
   UltTecla = Lastkey()
   IF LASTKEY() = Escape
      CLOSE DATA
      RETURN
   ENDIF
   IF _ANO <> PERIODO
      LOCATE FOR _ANO = PERIODO
   ENDIF
   IF _MES <> MESCONT
      IF RLOCK()
         REPLACE MESCONT WITH _MES
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
   *** chequeando si se ha registardo tipo de cambio **
   SELE 1
   USE admmtcmb ORDER tcmb01   ALIAS TCMB
   IF ! USED(1)
      CLOSE DATA
      RETURN
   ENDIF
   DO TPOCMB
   
   CLOSE DATA
   *** Ojo - Para captar variables de configuracion general ** vett 17/05/2000
   STORE 0 TO M.TIPO_EMPRE,M.TIPO_CONSO,M.MAX_AUXIL,M.C_COSTO
   STORE "" TO M.DIR_SIST1,M.DIR_SIST2,M.DIR_SIST3
   do chkdirsist
   DO CBDMENUS
ENDDO

*******************
FUNCTION _PERIODO
*******************
LOCATE FOR PERIODO = _ANO
RETURN FOUND()


*******************
PROCEDURE TPOCMB
*******************
XdFchDia = DATE()
IF ! SEEK(DTOC(XdFchDia,1),"TCMB")
    GOTO BOTTOM
    XfOFICMP = TCMB->OFICMP
    XfOFIVTA = TCMB->OFIVTA
    APPEND BLANK
    IF REC_LOCK(5)
       REPLACE FCHCMB WITH XdFchDia
    ENDIF
ELSE
    IF  TCMB->OFICMP>0 .AND. TCMB->OFIVTA>0 .and. ! UltTecla = F2
        RETURN
    ENDIF
    XfOFICMP = TCMB->OFICMP
    XfOFIVTA = TCMB->OFIVTA
ENDIF
@ 16,19 FILL  TO 21,59 COLOR W/N
@ 15,20 CLEAR TO 20,60
@ 15,20 FILL  TO 20,60 COLOR SCHEME 11
@ 15,20       TO 20,60
@ 15,25 SAY "TIPO DE CAMBIO DEL DIA "+DTOC(XdFchDia) COLOR SCHEME 7
@ 17,24 SAY "TIPO DE CAMBIO COMPRA :" GET XfOFICMP PICT "9999.9999" COLOR SCHEME 11
@ 18,24 SAY "TIPO DE CAMBIO VENTA  :" GET XfOFIVTA PICT "9999.9999" COLOR SCHEME 11
READ
IF LASTKEY() = Escape
   RETURN
ENDIF
REPLACE OFICMP WITH XfOfiCmp
REPLACE OFIVTA WITH XfOfiVta
RETURN

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