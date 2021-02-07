lReturnOk=goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
lReturnOk=goentorno.open_dbf1('ABRIR','CJATPROV','PROV','PROV01','')


**** Variables *****
STORE "" TO XsTpoDoc,XcTipo,XsCodCtas,XsCodOpe,XsNotAst,XsClfAux
Crear = .F.
DO FORM CJA_CJAMTOPE
RETURN

*************************************************************************** FIN
* Procedimiento de CARGA A VARIABLES
******************************************************************************
PROCEDURE TOMA
**************
SELECT PROV
IF ! Crear
	XsTpoDoc   =  TPODOC
	XcTipo     =  TIPO
	XsCodCtas  =  CODCTA
	XsCodOpe   =  CODOPE
	XsNotAst   =  NOTAST
	XsClfAux   =  CLFAUX 
ELSE
	XsTpoDoc   =  SPACE(LEN(TPODOC))
	XcTipo     =  SPACE(LEN(TIPO))
	XsCodCtas  =  SPACE(LEN(CODCTA))
	XsCodOpe   =  SPACE(LEN(CODOPE))
	XsNotAst   =  SPACE(LEN(NOTAST))
	XsClfAux   =  SPACE(LEN(CLFAUX))
ENDIF
RETURN

PROCEDURE Graba
PARAMETERS Crear
SET STEP ON 
IF Crear='I'
   APPEND BLANK
ENDIF
IF !RLOCK()
   RETURN
ENDIF
REPLACE TPODOC     WITH XsTpoDoc
REPLACE TIPO       WITH XcTipo
REPLACE CODCTA     WITH XsCodCtas
REPLACE CODOPE     WITH XsCodOpe
REPLACE NOTAST     WITH XsNotAst
replace CLFAUX	   WITH XsClfAux
UNLOCK
RETURN
******************************
* Objeto: Borrar un Registro *
******************************
PROCEDURE Elimina
SELECT prov
IF !RLOCK()
   UltTecla = Escape_
   RETURN
ENDIF
DELETE
UNLOCK
SKIP
RETURN
