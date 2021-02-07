DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp004
loContab.oDatadm.CloseTable('TABL')
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

*******************
PROCEDURE xPlnrp004
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ORDEN DE PAGO # 03"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP

XsCodMov="CA01"
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
DO LIB_MTEC WITH 13

@ 12,28 PROMPT "      IMPORTE NETO        "
@ 13,28 PROMPT "  ADELANTO 1RA QUINCENA   "
@ 14,28 PROMPT "IMPORTE NETO GRATIFICACION"
@ 15,28 PROMPT "  ADELANTO DE REINTEGRO   "
MENU TO OPC

IF OPC = 0
	RETURN
ENDIF
DO CASE
	CASE OPC = 1
		XsCodMov = "RZ02"
	CASE OPC = 2
		XsCodMov = "SC10"
	CASE OPC = 3
		XsCodMov = "TZ02"
	CASE OPC = 4
		XsCodMov = "DB12"
ENDCASE
SELE TMOV
SEEK XsCodMov
SELE PERS
DO LIB_MTEC WITH 13
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1+_Prn8a]
xWhile = []
xFor   = [VALCAL("@SIT")<5 .and. VALCAL(XsCodMov)<>0 ]
sNomRep = "PLN_PLNRP004"
DO F0PRINT WITH "REPORTS"
RETURN
