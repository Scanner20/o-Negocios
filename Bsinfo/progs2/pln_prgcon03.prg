**************************************
*  Nombre    : pln_plncon03.PRG      *
*  Objeto    : Consulta a Resultados *
*  Creaci¢n  : 24/10/2006            *
**************************************
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!*	Aperturamos archivos
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
DO FORM pln_frmcon03
RETURN