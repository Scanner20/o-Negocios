*!*	Inicializamos variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!*	Cargamos clase principal de planilla
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos tablas
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = '1'
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV1'
	CASE XsCodPln = '2'
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV2'
	CASE XsCodPln = '3'
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV3'
	CASE XsCodPln = '4'
		goentorno.open_dbf1('ABRIR','PLNTMOV4','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV4'
ENDCASE
DO CASE
	CASE XsCodPln = '1'
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = '2'
		goentorno.open_dbf1('ABRIR','PLNBLPG2','BPGO','BPGO01','')
	CASE XsCodPln = '3'
		goentorno.open_dbf1('ABRIR','PLNBLPG3','BPGO','BPGO01','')
	CASE XsCodPln = '4'
		goentorno.open_dbf1('ABRIR','PLNBLPG4','BPGO','BPGO01','')
ENDCASE
*!*	Ejecutamos formulario
DO FORM pln_plngbpgo
RELEASE oPln
RETURN
