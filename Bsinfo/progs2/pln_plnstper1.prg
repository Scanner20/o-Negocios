*!* Inicializamos Variables *!*
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

*!*	Aperturamos Tablas *!*
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

*!*	Ejecutamos Formulario
DO FORM pln_plnstper