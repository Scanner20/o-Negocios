************************************
* Reporte de Situación de Personal *
************************************
*!*	Declaramos Variables
PRIVATE XsCodPln,XsNroPer,Opcion
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

*!* Ejecutamos formulario
DO FORM pln_plnrp001
*****************
PROCEDURE xGenera
*****************
Dimension VecOpc(20)
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Aperturamos Archivos
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE OPCION=1
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS02','')
	CASE OPCION=2
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
	CASE OPCION=3
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS14','')
ENDCASE
SET FILTER TO CODPLN=XSCODPLN
GO TOP
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
