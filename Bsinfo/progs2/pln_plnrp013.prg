*********************
* Archivo de A.F.P. *
*********************
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnarafp
loContab.oDatadm.CloseTable('AAFP')
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
PROCEDURE xPlnarafp
*******************
Dimension AsCodigo(20)
cTit1 = "ARCHIVO DE AFP"
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = GsNomCia
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Apertura de Archivos *!*
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNARAFP','AAFP','AAFP01','EXCLUSIVE')
ZAP
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
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS05','')
SET FILTER TO CODPLN=XSCODPLN AND CODAFP>=[03]
GO TOP
UltTecla = 0
Opcion   = 1
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 12,23 SAY "Elegir : "
DO WHILE !INLIST(UltTecla,Escape)
	GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
	DO LIB_Mtec with 99
	@ 12,33 GET Opcion FUNCTION '^ Fin de Mes;Gratifificación'
	READ
	UltTecla  = LastKey()
	IF INLIST(UltTecla,Escape,Enter)
		EXIT
	ENDIF
ENDDO
IF UltTecla==Escape
	RETURN
ENDIF
XSCODMOV="BA01"
DO WHILE !EOF()
	IF VALCAL("@SIT")=5
		SKIP
		LOOP
	ENDIF
	IF VALCAL("@SIT")=6
		SKIP
		LOOP
	ENDIF
	IF VALCAL("@SIT")=7
		SKIP
		LOOP
	ENDIF
	DO CASE
		CASE OPCION=1
			XX = VALCAL("RD01") + VALCAL("VD01")
		CASE OPCION=2
			XX = VALCAL("TD01")
	ENDCASE
	SELE AAFP
	XSCODAFP = []
	DO CASE
		CASE PERS.CODAFP=[03]
			XSCODAFP = [PRO]
		CASE PERS.CODAFP=[05]
			XSCODAFP = [HOR]
		CASE PERS.CODAFP=[06]
			XSCODAFP = [INT]
		CASE PERS.CODAFP=[07]
			XSCODAFP = [UNI]
		CASE PERS.CODAFP=[08]
			XSCODAFP = [NVD]
	ENDCASE
	APPEND BLANK
	REPLACE A_CODAFP  WITH XSCODAFP
	REPLACE C_CUSPP   WITH PERS.CARAFP
	REPLACE A_APELL1  WITH PERS.ApePat
	REPLACE A_APELL2  WITH PERS.ApeMat
	STORE ' ' TO ESPACIO
	XSNOMB1 = SUBSTR(PERS.NOMPER,41,AT(ESPACIO,SUBSTR(PERS.NOMPER,41,60)))
	N = AT(ESPACIO,SUBSTR(PERS.NOMPER,41,60))
	XSNOMB2 = SUBSTR(PERS.NOMPER,41+N,60)
	REPLACE A_NOMBRE1 WITH XSNOMB1
	REPLACE A_NOMBRE2 WITH XSNOMB2
	REPLACE M_REMASEG WITH XX
	REPLACE M_APOVOL  WITH 0.00
	REPLACE A_APOVOLS WITH 0.00
	REPLACE A_APOEMPL WITH 0.00
	SELE PERS
	SKIP
ENDDO
SELE AAFP
REINDEX
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3+_PRN8B]
xWhile = []
Xfor   = [VALCAL("@SIT")<5]
sNomREP = "PLN_PLNARAFP"
DO F0PRINT WITH "REPORTS"
CLOSE DATA
RETURN

******************
FUNCTION XNOMB_AFP
******************
XSNOMB_AFP = []
DO CASE
	CASE AAFP.A_CODAFP = [HOR]
		XSNOMB_AFP = [HORIZONTE]
	CASE AAFP.A_CODAFP = [INT]
		XSNOMB_AFP = [INTEGRA]
	CASE AAFP.A_CODAFP = [UNI]
		XSNOMB_AFP = [UNION]
	CASE AAFP.A_CODAFP = [NVD]
		XSNOMB_AFP = [NUEVA VIDA]
	CASE AAFP.A_CODAFP = [PRO]
		XSNOMB_AFP = [PROFUTURO]
ENDCASE
RETURN XSNOMB_AFP
