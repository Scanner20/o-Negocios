DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp056
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
PROCEDURE xPlnrp056
*******************
Dimension AsCodigo(20)
cTit1 = "SITUACION DEL PERSONAL"
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = GsNomCia
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
UltTecla = 0
SelFil   = 1
CodLLV   = space(6)
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 12,23 SAY "Elegir : "
@ 16,23 SAY "Codigo : "
DO WHILE !INLIST(UltTecla,Escape)
	GsMsgKey = "[] [] Posiciona   [Enter] Registrar   [Esc] Salir"
	DO LIB_Mtec with 99
	@ 12,33 GET SelFil FUNCTION '^ Divisi¢n;Area;Secci¢n;Sede;Todos'
	READ
	UltTecla  = LastKey()
	IF INLIST(UltTecla,Escape,Enter)
		EXIT
	ENDIF
ENDDO
IF UltTecla==Escape
	RETURN
ENDIF
SELE PERS
SELCIA=0
DO CASE
	CASE SelFil = 1
		XsTabla = "29"
		DO TABLA WITH XsTabla,CodLLV
		UltTecla  = LastKey()
		=SEEK(XsTabla+CodLLV,"TABL")
		@ 16,33 SAY CodLLV+"  "+LEFT(TABL.NomBre,25)
		SET FILTER TO DIVISION = allt(CodLLV) and COdPln=XsCodPLn
	CASE SelFil = 2
		XsTabla = "30"
		DO TABLA WITH XsTabla,CodLLV
		UltTecla  = LastKey()
		=SEEK(XsTabla+CodLLV,"TABL")
		@ 16,33 SAY CodLLV+"  "+LEFT(TABL.NomBre,25)
		SET FILTER TO AREA = allt(CodLLV) and COdPln=XsCodPLn
	CASE SelFil = 3
		XsTabla  = "28"
		DO TABLA WITH XsTabla,CodLLV
		UltTecla  = LastKey()
        =SEEK(XsTabla+CodLLV,"TABL")
		@ 16,33 SAY CodLLV+"  "+LEFT(TABL->NOMBRE,25)
		SET FILTER TO CODSEC = allt(CodLLV) and COdPln=XsCodPLn
	CASE SelFil = 4
		XsTabla  = '27'
		DO TABLA WITH XsTabla,CodLLV
		UltTecla  = LastKey()
		=SEEK(XsTabla+CodLLV,"TABL")
		@ 16,33 SAY CodLLV+"  "+Left(TabL->Nombre,25)
		SET FILTER TO GRA_SG = allt(codLLV) and COdPln=XsCodPLn
	CASE SelFil = 5
		UltTecla = 0
		Selcia   = 1
		@ 9,10 CLEAR TO 18,67
		@ 9,10       TO 18,67
		@ 12,23 SAY "Elegir : "
		DO WHILE !INLIST(UltTecla,Escape)
			GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
			DO LIB_Mtec with 99
			@ 12,33 GET SelCia FUNCTION '^ Reporte Orden Alfabetico ;Reporte por Sedes '
			READ
			UltTecla  = LastKey()
			IF INLIST(UltTecla,Escape,Enter)
				EXIT
			ENDIF
		ENDDO
		IF UltTecla==Escape
			RETURN
		ENDIF
		if selcia = 1
			SELE PERS
			SET ORDER TO PERS12
			SET FILTER TO CODPLN=XSCODPLN
			GO TOP
			IF !USED()
   				RETURN
			ENDIF
		ENDIF
		IF SelCia = 2
			sele pers
			set order to pers14
			go top
			Largo = 66
			IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
			xWhile = []
			xFor   = [VALCAL("@SIT")#5]
			sNomREP = "plnrp057"
			DO ADMPRINT WITH "REPORTS"
			CLOSE DATA
			RETURN
		ENDIF
ENDCASE
SELE PERS
SET ORDER TO PERS02
GO TOP
*A¥OS TRABAJADOS*
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
sNomREP = "pln_plnrp056"
DO F0PRINT WITH "REPORTS"
RETURN
