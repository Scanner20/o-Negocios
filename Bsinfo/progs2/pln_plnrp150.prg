DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp150
loContab.oDatadm.CloseTable('SEMA')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnrp150
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Maestro de Personal"
Do Fondo WITH cTit1,cTit2,cTit3,cTiT4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','SEMA','SEMA02','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS02','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP
XNM = XSNROMES
IF INLIST(XSCODPLN,"2","3")
	XS1 = XSNROPER
	XS2 = TRANS((VAL(XSNROPER)+1),[@L ##])
	XS3 = TRANS((VAL(XSNROPER)+2),[@L ##])
	XS4 = TRANS((VAL(XSNROPER)+3),[@L ##])
	XS5 = TRANS((VAL(XSNROPER)+4),[@L ##])
	XNM = XSNROMES
	LLAVE = XS5+XNM
	@ 9,10 CLEAR TO 18,67
	@ 9,10       TO 18,67
	@ 11,20 SAY "1ra. Semana : "
	@ 12,20 SAY "2da. Semana : "
	@ 13,20 SAY "3ra. Semana : "
	@ 14,20 SAY "4ta. Semana : "
	@ 15,20 SAY "5ta. Semana : "
	@ 15,38 SAY "(Si mes tiene 5 semanas)"
	@ 11,34 GET XS1
	@ 12,34 GET XS2
	@ 13,34 GET XS3
	@ 14,34 GET XS4
	@ 15,34 GET XS5
	READ
ENDIF
UltTecla = LASTKEY()
IF UltTecla==Escape
	RETURN
ENDIF
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1+_Prn8a]
xWhile = []
xFor   = [VALCAL("@SIT")#5] 
sNOMREP = "PLN_PLNRP150"
DO F0PRINT WITH "REPORTS"
RETURN
