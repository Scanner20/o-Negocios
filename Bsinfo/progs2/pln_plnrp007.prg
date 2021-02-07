************************************
* Reporte de Descuentos Judiciales *
************************************
*!*	Declaramos variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos archivos
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','PLNDJUDI','JUDI','CCTE01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
*!*	Ejecutamos formulario
DO FORM pln_plnrp007
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
SET FILTER TO CodPln = XsCodPln
GO TOP
*!*	DO LIB_MTEC WITH 13
*!*	Largo = 66
*!*	IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1+_prn8a]
*!*	xWhile= []
*!*	xFor  = []
*!*	sNomREP = "pln_plnrp045"
*!*	DO F0PRINT WITH "REPORTS"
*!*	RETURN

*!*	**************
*!*	PROCEDURE JIMP
*!*	***************
*!*	Xselect = SELECT()
*!*	XsCodper = CodPer
*!*	XsValRef = STR(VAL(NroDoc),6,0)
*!*	SELECT DMOV
*!*	*!* Capturando judicial *!*
*!*	Llave = XsCodPln+XsNroPer + XsCodPer + "JA01" + XsValRef
*!*	SEEK LLave
*!*	XfValCal = ValCal
*!*	Llave = XsCodPln+XsNroPer + XsCodPer + "JA02" + XsValRef
*!*	SEEK LLave
*!*	XfValCal = XfValCal + ValCal
*!*	SELECT (xSelect)
*!*	RETURN XfValCal