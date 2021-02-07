***********************************
* Reporde de Recibos de Adelantos *
***********************************
*!*	Declaramos variables

IF !verifyvar_Pln('PsPlnAde','C')
	return
ENDIF


PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
*!*	SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos archivos
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln=XSCODPLN
*!*	Ejecutamos formulario
DO FORM pln_plnrp006
RETURN
