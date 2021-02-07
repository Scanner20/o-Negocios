****************************
* Reporte de Netos a Pagar *
****************************
*!*	Declaramos variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!*	Apertura de Archivos
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE

DO FORM pln_plnrp061

*********************
PROCEDURE xGenera_Rep
*********************
DO CASE
	CASE Opcion = 1
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
	CASE Opcion = 2
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS02','')
	CASE Opcion = 3
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS14','')
	CASE Opcion = 4
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS11','')
ENDCASE
SET FILTER TO CodPln = XsCodPln