************************************
* Reporte de Detalle por Conceptos *
************************************
*!*	Declaramos Variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos Archivos
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = '1'
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV1"
	CASE XsCodPln = '2'
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV2"
	CASE XsCodPln = '3'
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV3"
	CASE XsCodPln = '4'
		goentorno.open_dbf1('ABRIR','PLNTMOV4','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV4"
ENDCASE

DO FORM pln_plnrp004
RETURN

*********************
PROCEDURE xGenera_Rep
*********************
DO CASE
	CASE Opcion = 1
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
		SET FILTER TO CodPln = XsCodPln
	CASE Opcion = 2
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS02','')
		SET FILTER TO CodPln = XsCodPln
	CASE Opcion = 3
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS03','')
		SET FILTER TO CodPln = XsCodPln
	CASE Opcion = 4
		goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS04','')
		SET FILTER TO CodPln = XsCodPln
ENDCASE
RETURN
