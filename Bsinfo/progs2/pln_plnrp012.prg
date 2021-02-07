*********************************
* Indice de Personal con A.F.P. *
*********************************
*!*	Declaramos variables
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!*	Apertura de Archivos *!*
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS11','')
*!*	Ejecutamos Formulario
DO FORM pln_plnrp012

*******************
PROCEDURE xPlnrp012
*******************
SELECT PERS
SET FILTER TO CodPln = XsCodPln .AND. CodAfp $ "03,04,05,06,07,08,09,10"
GO TOP