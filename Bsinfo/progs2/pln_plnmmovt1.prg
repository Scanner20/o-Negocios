*!* Inicializamos Variables *!*
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

*!*	Aperturamos Tablas *!*
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV1"
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV2"
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		XsTabMov = "PLNTMOV3"
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln

*!* Ejecutamos Formulario *!*
DO FORM pln_plnmmovt
