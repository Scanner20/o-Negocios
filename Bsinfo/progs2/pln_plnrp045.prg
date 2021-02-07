DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp045
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('JUDI')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnrp045
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "JUDICIALES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','PLNDJUDI','JUDI','CCTE01','')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP
DO LIB_MTEC WITH 13
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1+_prn8a]
xWhile= []
xFor  = []
*!*	sNomQry = "plnrp045"
sNomREP = "pln_plnrp045"
DO F0PRINT WITH "REPORTS"
RETURN

**************
PROCEDURE JIMP
***************
Xselect = SELECT()
XsCodper = CodPer
XsValRef = STR(VAL(NroDoc),6,0)
SELECT DMOV
*!* Capturando judicial *!*
Llave = XsCodPln+XsNroPer + XsCodPer + "JA01" + XsValRef
SEEK LLave
XfValCal = ValCal
Llave = XsCodPln+XsNroPer + XsCodPer + "JA02" + XsValRef
SEEK LLave
XfValCal = XfValCal + ValCal
SELECT (xSelect)
RETURN XfValCal