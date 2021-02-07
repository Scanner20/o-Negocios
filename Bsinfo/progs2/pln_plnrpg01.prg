DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrpg01

*******************
PROCEDURE xPlnrpg01
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "HABERES FIJOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Apertura de Archivos *!*
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
UltTecla = 0
Opcion   = 1
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 12,23 SAY "Elegir : "
DO WHILE !INLIST(UltTecla,Escape)
	GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
	DO LIB_Mtec with 99
	@ 12,33 GET Opcion FUNCTION '^ Planilla de Gratificaci¢n;Dias de Gratificaci¢n;Resumen x Centro de Costo '
	READ
	UltTecla  = LastKey()
	IF INLIST(UltTecla,Escape,Enter)
		EXIT
	ENDIF
ENDDO
IF UltTecla==Escape
	RETURN
ENDIF
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS14','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP
IF Opcion=2 .OR. OPCION=3
	LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS05','')
	SET FILTER TO CODPLN=XSCODPLN
	GO TOP
ENDIF
XSCODMOV="BA01" 
XSCODMOV2="DA40"
SELECT PERS
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
xWhile = []
XFor   = [VALCAL("@SIT")<5 .AND. (VALCAL(XSCODMOV)<>0 OR VALCAL(XSCODMOV2)#0)]
DO CASE
	CASE OPCION=1
		sNomREP = "pln_plnrpg01"
	CASE OPCION=2
		sNomREP = "pln_plnrpg02"
	CASE OPCION=3
		sNomREP = "pln_plnrpg01"
ENDCASE
DO F0PRINT WITH "REPORTS"
CLOSE DATA
RETURN
