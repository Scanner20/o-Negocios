DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp055
loContab.oDatadm.CloseTable('BPGO')
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
PROCEDURE xPlnrp055
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "SITUACION DEL PERSONAL"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG2','BPGO','BPGO01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG3','BPGO','BPGO01','')
ENDCASE
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
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS02','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP

SELECT PERS
*!* AÑOS TRABAJADOS *!*
DO CASE
	CASE MESVAC="01"
		FM=31
	CASE MESVAC="02"
		FM=29
	CASE MESVAC="03"
		FM=31
	CASE MESVAC="04"
		FM=30
	CASE MESVAC="05"
		FM=31
	CASE MESVAC="06"
		FM=30
	CASE MESVAC="07"
		FM=31
	CASE MESVAC="08"
		FM=31
	CASE MESVAC="09"
		FM=30
	CASE MESVAC="10"
		FM=31
	CASE MESVAC="11"
		FM=30
	CASE MESVAC="12"
		FM=31
ENDCASE
MM=MONTH(DATE())-MONTH(FCHING)
IF MM<0
	AA=YEAR(DATE())-YEAR(FCHING)-1
ELSE
	AA=YEAR(DATE())-YEAR(FCHING)
ENDIF
*!* MESES TRABAJADOS *!*
IF MM<0
	MM=12+(MONTH(DATE())-MONTH(FCHING))
ELSE
	MM=(MONTH(DATE())-MONTH(FCHING))
ENDIF
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
xWhile = []
xFor   = [VALCAL("@SIT")#5]
sNomREP = "pln_plnrp055"
DO F0PRINT WITH "REPORTS"
RETURN