************************************
* Reporte de Situación de Personal *
************************************
*!*	Declaramos Variables
PRIVATE XsCodPln,XsNroPer,Opcion
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	Cargamos clase principal
oPln = CREATEOBJECT('DosVr.Planillas')
*!* Ejecutamos formulario
DO FORM pln_plnrp001
RELEASE oPln
RETURN
*****************
PROCEDURE xGenera
*****************
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE Opcion = 1
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
	CASE Opcion = 2
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS02','')
	CASE Opcion = 3
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS03','')
	CASE Opcion = 4
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS04','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
SELECT PERS
SET FILTER TO CodPln = XsCodPln
GO TOP

