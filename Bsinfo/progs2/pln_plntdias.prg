DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlntdias

*******************
PROCEDURE xPlntdias
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "HABERES FIJOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNTDIAS','DIAS','','EXCLU')
ZAP
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
*******
*******
*UltTecla = 0
*Opcion   = 1
*@ 9,10 CLEAR TO 18,67
*@ 9,10       TO 18,67
*@ 12,23 SAY "Elegir : "
* DO WHILE !INLIST(UltTecla,Escape)
*    GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
*    DO LIB_Mtec with 99
*    @ 12,33 GET Opcion FUNCTION '^ Planilla de Gratificaci¢n;Dias de Gratificaci¢n;Resumen x Centro de Costo '
*    READ
*    UltTecla  = LastKey()
*    IF INLIST(UltTecla,Escape,Enter)
*      EXIT
*    ENDIF
* ENDDO
* IF UltTecla==Escape
*    CLOSE DATA
*    RETURN
* ENDIF
*******
*******
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS05','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP
XSCODMOV="BA01"
DO WHILE !EOF()
	IF VALCAL("@SIT")=5
		SKIP
		LOOP
	ENDIF
	SELECT dias
	XFECHA = CTOD('31/'+ PADL(ALLT(STR(MONTH(DATE()),2,0)),2,'0')+'/' + STR((YEAR(DATE())-1900),2,0))
	IF !EMPT(PERS.FCtoIn)
		DD=XFECHA-PERS.FCtoIn &&FCHING
	ELSE
		DD=XFECHA-PERS.FchIng &&FCHING
	ENDI
	IF DD>179
		DD=180
	ENDIF
	APPEND BLANK
	replace CODPLN WITH XSCODPLN
	replace NROPER WITH XSNROPER
	replace CODPER WITH PERS.CODPER
	replace CODMOV WITH "BG01"
	replace VALCAL WITH DD
	replace VALREF WITH 0
	replace FLGEST WITH "R"
	SELE PERS
	SKIP
ENDDO
SELECT DMOV
APPEND FROM PLNTDIAS
WAIT WINDOW [Procesando información...] NOWAIT
SELE DMOV
SET FILTER TO
SET ORDER TO DMOV02
SEEK XSCODPLN+XSNROPER+"BG01"
DELE REST WHILE CODPLN+NROPER+CODMOV=XSCODPLN+XSNROPER+"BG01"
APPEND FROM PLNTDIAS
WAIT WINDOW [Ok...] NOWAIT
* Largo = 66
* IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3+_PRN8B]
* xWhile = []
* XFor   = [VALCAL("@SIT")<5 .AND. VALCAL(XSCODMOV)<>0 ]
* ENDCASE
* DO ADMPRINT WITH "REPORTS"
RETURN
