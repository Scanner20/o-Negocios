DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrbqui
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
PROCEDURE xPlnrbqui
*******************
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RECIBOS DE ADELANTOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
STORE 0 TO TB200,TB100,TB50,TB20,TB10,TB05,TB01,TCEN
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Apertura de Archivos *!*
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CODPLN=XSCODPLN
GO TOP
OPC = 1
cad1 = ""
cad2 = ""
XiMax = 2
SELCIA   = 1
GiMaxEle = 0
UltTecla = 0
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 10,13 SAY "Valor M x. :      para la distribuci¢n de moneda"
@ 12,13 SAY "Listado    : "
DO WHILE .T.
	VecOpc(1) = "200"
	VecOpc(2) = "100"
	VecOpc(3) = " 50"
	VecOpc(4) = " 20"
	VecOpc(5) = " 10"
	VecOpc(6) = "  5"
	XiMax     = Elige(XiMax,10,26,6)
	IF UltTecla = Escape
		RETURN
	ENDIF
	DO CASE
		CASE Ximax = 1
			XiMax = 200
		CASE Ximax = 2
			XiMax = 100
		CASE Ximax = 3
			XiMax = 50
		CASE Ximax = 4
			XiMax = 20
		CASE Ximax = 5
			XiMax = 10
		CASE Ximax = 6
			XiMax = 5
	ENDCASE
	VecOpc(1) = "Total"
	VecOpc(2) = "Individual"
	SelCia    = Elige(SelCia,12,26,2)
	IF UltTecla = Escape
		RETURN
	ENDIF
	IF SelCia = 2
		save Screen to   Temp
		DO GENBrows
		IF LASTKEY() = 27
			LOOP
		ENDIF
		rest screen from temp
	ENDIF
	@ 13,28 PROMPT "ADELANTO DE 1RA QUINCENA "
	@ 14,28 PROMPT "ADELANTO DE GRATIFICACION"
	@ 15,28 PROMPT "ADELANTO DE REINTEGRO    "
	MENU TO OPC
	EXIT
ENDDO
Largo    = 33       && Largo de pagina
DO CASE
	CASE Opc = 1
		XsCodMov = "SC10"
		CONCEPTO = "ADELANTO DE QUINCENA CORRESPONDIENTE AL MES DE "+MES(VAL(XsnroPer),1)+" DE "+STR(_ANO,4,0)
	CASE Opc = 2
		CONCEPTO = "ADELANTO DE GRATIFICACION CORRESPONDIENTE AL MES DE "+MES(VAL(XsnroPer),1)+" DE "+STR(_ANO,4,0)
		XsCodMov = "TZ04"
	CASE Opc = 3
		CONCEPTO = "ADELANTO DE REINTEGRO CORRESPONDIENTE AL MES DE "+MES(VAL(XsnroPer),1)+" DE "+STR(_ANO,4,0)
		XsCodMov = "RB04"
ENDCAS
IF SelCia = 1
	xFor   = [VALCAL("@SIT")#5 .and. VALCAL(XsCodMov)<>0]
ELSE
	xFor   = [ASCAN(AsCodigo,CodPer,1,GiMaxEle)>0]
ENDIF
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
SELE PERS
GO TOP
DO CASE
	CASE Opc = 1
		sNomREP = "pln_plnrbqui"
	CASE Opc = 2
		sNomREP = "pln_plnrbqu1"
	CASE Opc = 3
		sNomREP = "pln_plnrbqu2"
ENDCAS
K_ESC=27
DO F0PRINT WITH "REPORTS"
SET DEVICE TO SCREEN
RETURN
****************
FUNCTION Distrib
****************
*****  Distribuci¢n de Sueldo en Billetes y Monedas  ******
Parameter Monto,Min
store 0 to  B200,B100,B50,B20,B10,B05,B01,CEN
store 0 to  R200,R100,R50,R20,R10,R05,R01
STORE [] TO cad1,cad2
IF Min>=200
	IF Monto/200>=1
		B200=INT(Monto/200)    && 100
		R200=Monto-B200*200
	ELSE
		B200=0
		R200=Monto
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+"200    "
ELSE
	R200 = Monto
ENDIF
*
IF Min>=100
	IF R200/100>=1
		B100=INT(R200/100)    && 100
		R100=R200-B100*100
	ELSE
		B100=0
		R100=R200
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+"100    "
ELSE
	R100 = R200
ENDIF
IF Min>=50
	IF R100/50>=1  .and. Min >= 50
		B50=INT(R100/50)         && 50
		R50=R100-B50*50
	ELSE
		B50=0
		R50=R100
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+" 50    "
ELSE
	R50 = R100
ENDIF
IF Min>=20
	IF R50/20>=1
		B20=INT(R50/20)         && 20
		R20=R50-B20*20
	ELSE
		B20=0
		R20=R50
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+" 20    "
ELSE
	R20 = R50
ENDIF
IF Min>=10
	IF R20/10>=1  .and. Min >= 10
		B10=INT(R20/10)         && 10
		R10=R20-B10*10
	ELSE
		B10=0
		R10=R20
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+" 10    "
ELSE
	R10 = R20
ENDIF
IF Min>=5
	IF R10/5>=1  .and. Min >= 5
		B05=INT(R10/5)          && 5
		R05=R10-B05*5
	ELSE
		B05=0
		R05=R10
	ENDIF
	cad1 =cad1+"---    "
	cad2 =cad2+"  5    "
ELSE
	R05 = R10
ENDIF
IF R05/1>=1
	B01=INT(R05/1)          && 1
	R01=R05-B01*1
ELSE
	B01=0
	R01=R05
ENDIF
cad1 =cad1+"---    "
cad2 =cad2+"  1    "
CEN=100*R01             && Centavos
cad1 =cad1+"---"
cad2 =cad2+" c."
cadena=TRANS(B100,"@L 999")+"    "+TRANS(B50,"@L 999")+"    "+TRANS(B20,"@L 999")+"    "+TRANS(B10,"@L 999")+"    "+TRANS(B05,"@L 999")+"    "+TRANS(B01,"@L 999")+"    "+TRANS(CEN,"@L 999")
TB200=TB200+B200
TB100=TB100+B100
TB50 =TB50 +B50
TB20 =TB20 +B20
TB10 =TB10 +B10
TB05 =TB05 +B05
TB01 =TB01 +B01
TCEN =TCEN +CEN
RETURN Cadena
