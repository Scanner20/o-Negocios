DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
SYS(2700,0)        
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp666
IF USED('TABL')
	USE IN TABL
ENDIF
IF USED('BPGO')
	USE IN BPGO
ENDIF
IF USED('PERS')
	USE IN PERS
ENDIF
IF USED('DMOV')
	USE IN DMOV
ENDIF
IF USED('TMOV')
	USE IN TMOV
ENDIF

SYS(2700,1)        
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnrp666
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REMUNERACIONES"
Do Fondo WITH cTit1,cTit2,cTit3,cTiT4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos************
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
LoDatAdm.abrirtabla('ABRIR','PLNTTCMB','TCMB','','')
*!*	LOCATE FOR VAL(nromes)= _mes && PlnNroMes
SEEK DTOS(GDFECHA)
XfTpoCmb=OfiVta
m.Control = 1
XnMonPln  = 1
UltTecla = 0
Opcion   = 1
*!*	plnrp666.spr

IF LASTKEY()=27 OR m.Control =2
	RETURN
	SYS(2700,1)        
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF

ENDIF
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS05','')
SET FILTER TO CODPLN=XSCODPLN .AND. LUGPAG $ "10,20,30,40,50,60"
GO TOP
IF Opcion=2 .OR. OPCION=3
	LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS13','')
	SET FILTER TO CODPLN=XSCODPLN
	GO TOP
ENDIF
XSCODMOV="BA01"
SELECT PERS
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
xWhile = []
XFor   = [VALCAL("@SIT")<5 ]
DO CASE
	CASE OPCION=1
		UltTecla  = 0
		XFinQui   = 1
		@ 9,10 CLEAR TO 18,67
		@ 9,10       TO 18,67
		@ 12,23 SAY "Elegir : "
		DO WHILE !INLIST(UltTecla,Escape)
			GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
			DO LIB_Mtec with 99
			@ 12,33 GET XFinQui FUNCTION '^ Semanal;Quincena;Fin de Mes;Gratificación'
			READ
			UltTecla  = LastKey()
   			IF INLIST(UltTecla,Escape,Enter)
   				EXIT
			ENDIF
		ENDDO
		IF UltTecla==Escape
			RETURN
		ENDIF
		sNomREP = "pln_plnrp66A"
   CASE OPCION=2
        sNomREP = "pln_plnrp666"
   CASE OPCION=3
        sNomREP = "pln_plnrp66B"
ENDCASE
DO F0PRINT WITH "REPORTS"
RETURN

*************
FUNCTION XIMP
*************
DO CASE
	CASE XFINQUI = 1
		IMPORTE = VALCAL([RZ04])-VALCAL([DB51])-VALCAL([DB61])+VALCAL([DC02])
	CASE XFINQUI = 2
		IMPORTE = VALCAL([SC10])-VALCAL([DB50])-VALCAL([DB60])+VALCAL([DC01])
	CASE XFINQUI = 3
		IF GSCODCIA = [006] OR GSCODCIA=[009]
			IMPORTE = VALCAL([RZ04])-VALCAL([DB51])-VALCAL([DB61])-VALCAL([MA01])+VALCAL([DC02])
		ELSE
			IMPORTE = VALCAL([RZ04])-VALCAL([DB51])-VALCAL([DB61])+VALCAL([DC02])
		ENDIF
	CASE XFINQUI = 4
		IMPORTE = VALCAL("TZ04")/2-VALCAL([DB52])/2-VALCAL([DB62])/2
ENDCASE
RETURN IMPORTE
