**********************
* Traslado Bancarios *
**********************
*!*	Declaración de Variables
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
STORE "" TO XsCodBco
STORE 0 TO Opcion
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

*!*	Ejecutamos Formularios
DO FORM pln_plnrp051
********************
PROCEDURE Genera_bco
********************
*!* Apertura de Archivos *!*
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS05','')
SET FILTER TO CodPln = XsCodPln .AND. LugPag $ XsCodBco

XsCodMov = "BA01"
DO WHILE !EOF()
	IF VALCAL("@SIT")=5
		SKIP
		LOOP
	ENDIF
	IF VALCAL("@SIT")=6
		SKIP
		LOOP
	ENDIF
	IF VALCAL("@SIT")=7
		SKIP
		LOOP
	ENDIF
	DO CASE
		CASE OPCION=1
			XX=VALCAL("SC10")-VALCAL("DB50")-VALCAL("DB60")+VALCAL("DC01")
		CASE OPCION=2
			XX=VALCAL("RZ04")-VALCAL("DB51")-VALCAL("DB61")+VALCAL("DC02")     && -VALCAL("MA01")
		CASE OPCION=3
			XX= VALCAL("TZ04")/2- VALCAL("DB52")/2-VALCAL("DB62")/2+IIF(GSCODCIA="001",VALCAL("TQ01")/2,0.00)
		CASE OPCION=4
			XX=(VALCAL("TZ04")/4) - VALCAL("DB53")
		CASE OPCION=5
			XX=(VALCAL("TZ04")/4) - VALCAL("DB54")
		CASE OPCION=6
			XX= (VALCAL("TZ04")/4) - VALCAL("DB55")
	ENDCASE
	SELE BACO
	APPEND BLANK
	REPLACE X1 WITH PERS.CODPER
	REPLACE X3 WITH SUBSTR(PERS.NOMPER,1,20)
	REPLACE X4 WITH SUBSTR(PERS.NOMPER,21,40)
	REPLACE X5 WITH SUBSTR(PERS.NOMPER,41,60)
	REPLACE XI WITH "00000000"
	REPLACE X6 WITH trans(XX*100,"@L ############")
	REPLACE X8 WITH PERS.CTAHOR
	SELE PERS
	SKIP
ENDDO
SELE BACO
REINDEX
*!*	Largo = 66
*!*	IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3+_PRN8B]
*!*	xWhile = []
*!*	Xfor   = [VALCAL("@SIT")<5]
*!*	sNomREP = "PLNBANCO"
*!*	DO ADMPRINT WITH "REPORTS"
*!*	?CHR(7)
WAIT WINDOW [Inserte Diskkette en Unidad A: y Presione <Enter>] 
COPY TO A:\HABERES.DAT SDF
RETURN
