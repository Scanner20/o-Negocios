DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
PlnNroMes = VAL(XsNroMes)
PlnNroSem = VAL(XsNroSem)
PlnNroAno = _Ano

DO cierre_anual
loContab.oDatadm.CloseTable('CCTE')
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

**********************
PROCEDURE cierre_anual
**********************
_Ano_Act = _Ano
_Ano_Ant = _Ano-1
WAIT WINDOW "En Proceso de Implementación"