DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrpc01

*******************
PROCEDURE xPlnrpc01
*******************
Dimension AsCodigo(20)
XlPosSem=""
XsTitAux = SPACE(30)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroMes),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "INFORMACION COOPERATIVA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

SELE 0
USE PLNCOOPE EXCL ORDER COP01 ALIAS COOP
ZAP
PACK
SET EXCL ON
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE PLNMTSEM ORDER SEMA01 ALIAS TSEM
IF !USED()
	CLOSE DATA
	RETURN
ENDIF

SELE 0
DO CASE
	CASE XsCodPln='1'
		USE PLNBLPG1 ORDER BPGO01 ALIAS BPGO
	CASE XsCodPln='2'
		USE PLNBLPG2 ORDER BPGO01 ALIAS BPGO
	CASE XsCodPln='4'
		USE PLNBLPG3 ORDER BPGO01 ALIAS BPGO
ENDCASE
IF !USED()
	CLOSE DATA
	RETURN
ENDIF

SELE 0
USE PLNMTABL ORDER TABL01 ALIAS TABL
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*******
IF XsCodPln = "1"
	SELECT 0
	USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "2"
	SELECT 0
	USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "4"
	SELECT 0
	USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
ENDIF
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*******
OpcionR  = 1
IF XsCodPln = "2"
	UltTecla = 0
	OpcionR  = 1
	@ 9,10 CLEAR TO 18,67
	@ 9,10       TO 18,67
	@ 12,23 SAY "Elegir : "
	DO WHILE !INLIST(UltTecla,Escape)
		GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
		DO LIB_Mtec with 99
		@ 12,33 GET OpcionR FUNCTION '^ Semanal;Mensual;Vacaciones;Gratif.'
		READ
		UltTecla  = LastKey()
		IF INLIST(UltTecla,Escape,Enter)
			EXIT
		ENDIF
	ENDDO
	IF UltTecla==Escape
		CLOSE DATA
		RETURN
	ENDIF
ENDIF
*******
UltTecla = 0
Opcion   = 1
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
IF XSCODPLN = '1'
	DO CASE
		CASE GSCODCIA=[009]
			XARCH = PADR('A:\NEXOE.TXT',20)
		CASE GSCODCIA=[007]
			XARCH = PADR('A:\LIMPIEXE.TXT',20)
		OTHER
			WAIT WINDOW [NO ESTAS EN UNA COOPERATIVA] NOWAIT
			XARCH = PADR('A:\AGRARIAE.TXT',20)
	ENDCASE
ELSE
	IF GSCODCIA = [007]
		XARCH = PADR('A:\LIMPIEXO.TXT',20)
	ELSE
		WAIT WINDOW [NO ESTAS EN UNA COOPERATIVA] NOWAIT
		XARCH = PADR('A:\AGRARIAO.TXT',20)
	ENDIF
ENDIF
@ 12,23 SAY "Archivo: "
GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
DO LIB_Mtec with 99
@ 12,33 GET XARCH FUNC '!'
@ 13,33 GET Opcion FUNCTION '^ ORDEN ALFABETICO;ORDEN DE CODIGO '
IF XsCodPln=[1]
	@ 15,23 SAY "Elegir : "
	@ 15,33 GET OpcionR FUNCTION '^ Mensual;Vacaciones;Gratif.'
ENDIF
READ
UltTecla  = LastKey()
IF UltTecla==Escape
	CLOSE DATA
	RETURN
ENDIF

DO CASE
	CASE OPCION=1
		SELE 0
		USE PLNMPERS ORDER PERS02 ALIAS PERS
		SET FILTER TO CODPLN=XSCODPLN
	CASE OPCION=2
		SELE 0
		USE PLNMPERS ORDER PERS01 ALIAS PERS
		SET FILTER TO CODPLN=XSCODPLN
ENDCASE
GO TOP
IF !USED()
	CLOSE DATA
	RETURN
ENDIF

IF XsCodPln = "2" .AND. OpcionR = 2
	DO LLENATEMP
ENDIF

IF XsCodPln = "2"
	XsTitAux = IIF(OpcionR = 2,"Semanas : "+NroSema(1)+","+NroSema(2)+","+;
            NroSema(3)+","+NroSema(4)+","+NroSema(5),"Semana : "+XsNroPer)
ENDIF

*******
SELECT PERS
GO TOP
XSCODMOV = "BA01"
*******
DO WHILE !EOF()
	IF VALCAL("@SIT")=5
		SKIP
		LOOP
	ENDIF

	IF VALCAL("@SIT")=6 and ((inlist(opcionr,1,3) and xscodpln=[1]) or (INLIST(OPCIONR,1,2,4) AND XSCODPLN=[2] ))
		SKIP
		LOOP
	ENDIF
	DO CASE
		CASE OPCION=1
			XX=VALCAL("SC10")-VALCAL("DB50")-VALCAL("DB60")
		CASE OPCION=2
			Y1=VALCAL("RZ04")-VALCAL("DB51")-VALCAL("DB61")
			Y2=VALCAL("DC01")
			XX=Y1+Y2
	ENDCASE
	sele COOP
	APPEND BLANK
	DO CASE
		CASE (INLIST(OpcionR,1,2) and xscodpln=[2]) or (opcionr=1 and xscodpln=[1]) AND VALCAL([RZ01])>0
			** Sueldos y salarios: semanal , mensual. **
			** CABECERA **
			replace CODPER WITH PERS.CODPER
			replace APEPAT WITH SUBSTR(PERS.NOMPER,1,20)
			replace APEMAT WITH SUBSTR(PERS.NOMPER,21,40)
			replace NOMBRE WITH SUBSTR(PERS.NOMPER,41,60)
			replace FCHING WITH PERS.FCHING
			replace D1 WITH       Valcal("BA01")-Valcal("BA10")
			replace H1 WITH       valcal("BA17")
			** INGRESOS **
			replace SUELDO WITH   valcal("RA01")
			replace SUELDO_H WITH valcal("RA20")
*			replace H3 WITH       valcal("RO02")
*			replace H4 WITH       valcal("RO21")
			replace COMISI WITH   valcal("RB04")+valcal("RA03")
			replace BONDOM WITH   valcal("RA05")
			replace DOMINI WITH   valcal("RA06")
			replace MOVILI WITH   valcal("RA07")
			replace REMDEST WITH  valcal("RA40")
			replace JORNOCT WITH  valcal("CA03")
			replace FERLAB WITH   valcal("RA25")+valcal("RB21")
			replace ASIFAM WITH   valcal("RA02")+valcal("RA11")
			replace INCAFP WITH   valcal("RA15")+valcal("RA16")
			replace SNP33 WITH    valcal("RA17")
			replace OTRING WITH   valcal("DA05")+valcal("DA07")+valcal("RB20")
			replace REDACT WITH   valcal("RZ03")
			replace TOTING WITH   valcal("RD01")
			** DESCUENTOS **
			replace SNP WITH      valcal("RE02")
			replace AFPFON WITH   valcal("RF01")
			replace AFPSI WITH    valcal("RF03")
*			replace AFPCF WITH    valcal("RF04")
			replace AFPCP WITH    valcal("RF05")
			replace QUINTA WITH   valcal("RK12")
			replace IPSSVIDA WITH valcal("RE05")
			replace QUINCE1 WITH  valcal("SC10")
			replace PRESTAMOS WITH valcal("MA01")
			replace DESTAR WITH   valcal("RO02")
			replace DESJUD WITH   0.00
			replace OTRDCTO WITH  valcal("RZ04")
			replace REDANT WITH   valcal("RZ02")
*			replace REFRIG WITH   valcal("DB05")
			replace TOTDCTO WITH  valcal("RP01")
*			replace TOTNET WITH   valcal(IIF(XSCODPLN="1","RZ04","RZ04"))
			replace APOIPSS WITH  valcal("RS01")
			replace APOFON  WITH  valcal("RS04")
*			replace LUGPAG WITH   PERS.LUGPAG
		CASE (INLIST(OpcionR,4) and xscodpln=[2]) or (opcionr=3 and xscodpln=[1]) AND VALCAL("TZ01")>0
			** Gratificacion ** 	
			replace CODPER WITH PERS.CODPER
			replace APEPAT WITH SUBSTR(PERS.NOMPER,1,20)
			replace APEMAT WITH SUBSTR(PERS.NOMPER,21,40)
			replace NOMBRE WITH SUBSTR(PERS.NOMPER,41,60)
			replace FCHING WITH PERS.FCHING
			replace D1 WITH       Valcal("TD77")
*			replace H1 WITH       valcal("RZ04")
			replace H2 WITH       valcal("TA20")
*			replace H3 WITH       valcal("RO02")
*			replace H4 WITH       valcal("RO21")
			replace SUELDO WITH   valcal("TA01")
*			replace BONDOM WITH   valcal("RA05")
*			replace DOMINI WITH   valcal("RA06")
*			replace MOVILI WITH   valcal("RA07")
			replace ASIFAM WITH   valcal("TA11")
			replace COMISI WITH   valcal("TB04")
			replace AFP1023 WITH  valcal("TA15")
			replace AFP331 WITH   valcal("TA16")
			replace SNP33 WITH    valcal("TA17")
			replace PRMHEXT WITH   valcal("TA20")
			replace PRMDEST WITH   valcal("TA40")
*			replace OTRING WITH   valcal("DA05")+valcal("DA07")+valcal("RB20")
*			replace FERLAB WITH   valcal("RA25")+valcal("RB21")
			replace TOTING WITH   valcal("TD01")
			replace SNP WITH      valcal("TE02")
			replace AFPFON WITH   valcal("TF01")
			replace AFPSI WITH    valcal("TF03")
			replace AFPCF WITH    valcal("TF04")
			replace AFPCP WITH    valcal("TF05")
*			replace QUINTA WITH   valcal("RK12")
*			replace QUINCE1 WITH  valcal("SC10")
*			replace DESTAR  WITH  valcal("RO02")
*			replace OTRDCTO WITH  valcal("RZ04")
*			replace IPSSVIDA WITH valcal("RE05")
*			replace APOCOO WITH   valcal("RJ01")
*			replace REFRIG WITH    valcal("DB05")
			replace TOTDCTO WITH  valcal("TP01")
			replace REDANT WITH   valcal("TZ02")
			replace REDACT WITH   valcal("TZ03")
			replace TOTNET WITH   valcal(IIF(XSCODPLN="1","TZ04","TZ01"))
			replace APOIPSS WITH  valcal("TS01")
			replace APOFON WITH   valcal("TS04")
			replace LUGPAG WITH   PERS.LUGPAG
		CASE (INLIST(OpcionR,3) and xscodpln=[2]) or (OpcionR=2 and xscodpln=[1]) AND VALCAL("VZ01")>0
		** Vacaciones ** 	
			replace CODPER WITH PERS.CODPER
			replace APEPAT WITH SUBSTR(PERS.NOMPER,1,20)
			replace APEMAT WITH SUBSTR(PERS.NOMPER,21,40)
			replace NOMBRE WITH SUBSTR(PERS.NOMPER,41,60)
			replace FCHING WITH PERS.FCHING
			replace D1 WITH       Valcal("TD77")
*			replace H1 WITH       valcal("RZ04")
			replace H2 WITH       valcal("VA20")
*			replace H3 WITH       valcal("RO02")
*			replace H4 WITH       valcal("RO21")
			replace SUELDO WITH   valcal("VA01")
*			replace BONDOM WITH   valcal("RA05")
*			replace DOMINI WITH   valcal("RA06")
*			replace MOVILI WITH   valcal("RA07")
			replace ASIFAM WITH   valcal("VA11")
			replace COMISI WITH   valcal("VA10")
			replace AFP1023 WITH  valcal("VA15")
			replace AFP331 WITH   valcal("VA16")
			replace SNP33 WITH    valcal("VA17")
			replace PRMHEXT WITH   valcal("VA20")
			replace PRMDEST WITH   valcal("VA40")
*			replace OTRING WITH   valcal("DA05")+valcal("DA07")+valcal("RB20")
*			replace FERLAB WITH   valcal("RA25")+valcal("RB21")
			replace TOTING WITH   valcal("VD01")
			replace SNP WITH      valcal("VE02")
			replace AFPFON WITH   valcal("VF01")
			replace AFPSI WITH    valcal("VF03")
			replace AFPCF WITH    valcal("VF04")
			replace AFPCP WITH    valcal("VF05")
*			replace QUINTA WITH   valcal("RK12")
*			replace QUINCE1 WITH  valcal("SC10")
*			replace DESTAR  WITH  valcal("RO02")
*			replace OTRDCTO WITH  valcal("RZ04")
*			replace IPSSVIDA WITH valcal("RE05")
*			replace APOCOO WITH   valcal("RJ01")
*			replace REFRIG WITH    valcal("DB05")
			replace TOTDCTO WITH  valcal("VP01")
			replace REDANT WITH   valcal("VZ02")
			replace REDACT WITH   valcal("VZ03")
			replace TOTNET WITH   valcal(IIF(XSCODPLN="1","VZ04","VZ01"))
			replace APOIPSS WITH  valcal("VS01")
			replace APOFON WITH   valcal("VS04")
			replace LUGPAG WITH   PERS.LUGPAG
	ENDCASE
	SELE PERS
	SKIP
ENDDO
SELE COOP
REINDEX
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
xWhile = []
xFor   = [VALCAL("@SIT")<5]
DO CASE
	CASE XSCODPLN="1"
		sNomREP = "plnrpC01"
	CASE XSCODPLN="2"
		sNomREP = "plnrpC02"
ENDCASE
DO ADMPRINT WITH "REPORTS"
*DO CASE
*   CASE XSCODPLN="1"
COPY TO &XARCH SDF
*   CASE XSCODPLN="2"
*        COPY TO A:\SALARIOS.TXT SDF
*ENDCASE
CLOSE DATA
RETURN

FUNCTION SEMVAL
*==============
PRIVATE wSemanas
wSemanas=""
SELE TSEM
LOCATE FOR MES=XsNroMes
DO WHILE MES=XsNroMes
	wSemanas=wSemanas+TSEM->SEMA
	SKIP
ENDDO
SELE DMOV
RETURN wSemanas

PROCEDURE LLENATEMP
*==================
SELE DMOV
XlPosSem=SemVal()
SET FILTER TO NROPER $ XlPosSem AND XsCodPln=DMOV->CODPLN
GO BOTT
GO TOP
ArcTmp = PathUser+sys(3)+".dbf"
COPY TO (ArcTmp) FOR NROPER $ XlPosSem AND XsCodPln=DMOV->CODPLN


SELE 0
USE (ArcTmp) ALIAS TEMPO EXCL

SELE TEMPO
REPLA ALL NROPER WITH XsNroPer
INDEX ON CODPLN+CODPER+CODMOV+NROPER TAG DMOV04
ArcTmp2 = PathUser+sys(3)+".dbf"
COPY STRUC TO (ArcTmp2)
SELE 0
USE (ArcTmp2) ALIAS TEMPO2 EXCL
SELE PERS
DO WHILE !EOF()
	XsCodPer=PERS->CodPer
	SELE TEMPO
	SEEK XsCodPln+XsCodPer
	IF EOF()
		SELE PERS
		SKIP
		LOOP
	ENDIF
	DO WHILE XsCodPln=TEMPO->CODPLN AND XsCodPer=TEMPO->CODPER AND !EOF()
		SCATTER MEMVAR
		m.ValCal=0
		DO WHILE m.CodMov=TEMPO->CODMOV AND XsCodPer=TEMPO->CODPER AND !EOF()
			m.ValCal = m.ValCal + TEMPO->VALCAL
			SKIP
		ENDDO
		SELE TEMPO2
		APPEN BLANK
		GATHER MEMVAR
		SELE TEMPO
	ENDDO
	SELE PERS
	SKIP
ENDDO
SELE TEMPO2
ArcTmp3 = PathUser+sys(3)+".dbf"
COPY TO (ArcTmp3)
SELE 0
USE (ArcTmp3) ALIAS DMOV
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
INDEX ON CODPLN+NROPER+CODPER+CODMOV+STR(VALREF,6,0) TAG DMOV01
INDEX ON CODPLN+NROPER+CODMOV+CODPER TAG DMOV02
INDEX ON CODPLN+CODPER TAG DMOV03
SET ORDER TO DMOV01
RETURN

FUNCTION NROSEMA
*===============
PARAMETER wNro
PRIVATE wSem
wSem = SUBSTR(XlPosSem+"    ",wNro*2-1,2)
RETURN wSem
