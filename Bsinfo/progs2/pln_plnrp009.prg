*****************************************
* Reporte de Aportaciones del Empleador *
*****************************************
*!*	Declaración de variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos archivos
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMTSEM','SEMA','SEMA02','')
*!*	Ejecutamos Formulario
DO FORM pln_plnrp009
RETURN

*********************
PROCEDURE xGenera_Rep
*********************
DO CASE
	CASE opcion = 1
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
	CASE opcion = 2
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS02','')
	CASE opcion = 3
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS03','')
	CASE opcion = 4
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS04','')
ENDCASE
SET FILTER TO CODPLN=XSCODPLN
GO TOP
*!*	Fijate en este codigo que era algo que ver con la semanas
*!*	XNM = XSNROMES
*!*	IF INLIST(XSCODPLN,"2","3")
*!*		XS1 = XSNROPER
*!*		XS2 = TRANS((VAL(XSNROPER)+1),[@L ##])
*!*		XS3 = TRANS((VAL(XSNROPER)+2),[@L ##])
*!*		XS4 = TRANS((VAL(XSNROPER)+3),[@L ##])
*!*		XS5 = TRANS((VAL(XSNROPER)+4),[@L ##])
*!*		XNM = XSNROMES
*!*		LLAVE = XS5+XNM
*!*		@ 9,10 CLEAR TO 18,67
*!*		@ 9,10       TO 18,67
*!*		@ 11,20 SAY "1ra. Semana : "
*!*		@ 12,20 SAY "2da. Semana : "
*!*		@ 13,20 SAY "3ra. Semana : "
*!*		@ 14,20 SAY "4ta. Semana : "
*!*		@ 15,20 SAY "5ta. Semana : "
*!*		@ 15,38 SAY "(Si mes tiene 5 semanas)"
*!*		@ 11,34 GET XS1
*!*		@ 12,34 GET XS2
*!*		@ 13,34 GET XS3
*!*		@ 14,34 GET XS4
*!*		@ 15,34 GET XS5
*!*		READ
*!*	ENDIF
*!*	UltTecla = LASTKEY()
*!*	IF UltTecla==Escape
*!*		RETURN
*!*	ENDIF
*!*	Largo  = 66
*!*	IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1+_Prn8a]
*!*	xWhile = []
*!*	xFor   = [VALCAL("@SIT")#5] 
*!*	sNOMREP = "PLN_PLNRP150"
*!*	DO F0PRINT WITH "REPORTS"
*!*	RETURN
