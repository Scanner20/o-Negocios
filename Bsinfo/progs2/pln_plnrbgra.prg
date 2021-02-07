DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
cNomCia  = GsNomCia

DO xPlnrbgra
loContab.oDatadm.CloseTable('TSEM')
loContab.oDatadm.CloseTable('CCTE')
loContab.oDatadm.CloseTable('PRDO')
loContab.oDatadm.CloseTable('ASIT')
loContab.oDatadm.CloseTable('BPGO')
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
PROCEDURE xPlnrbgra
*******************
PRIVATE nDM,nDN,nFI,nHD,nHS,nLS,nLC,nTR,nVC,vTiempo,vAsit
DIMENSION AsCodigo(20)
DIMENSION vTiempo(33),vAsit(33)
DIMENSION vINGRE1(18)
DIMENSION vINGRE2(18)
DIMENSION vINGRE3(18)
DIMENSION vDESCU1(18)
DIMENSION vDESCU2(18)
DIMENSION vDESCU3(18)
STORE 0  TO vTiempo
store "   " to vASIT
store "   " to vINGRE1,vINGRE2,vINGRE3,vDESCU1,vDESCU2,vDESCU3
STORE 0 TO nDM,nDN,nFI,nHD,nHS,nLS,nLC,nTR,nVC
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BOLETA DE PAGO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*!* Apertura de Archivos *!*
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','TSEM','SEMA01','')
LoDatAdm.abrirtabla('ABRIR','PLNDCCTE','CCTE','CCTE01','')
LoDatAdm.abrirtabla('ABRIR','PLNPERIO','PRDO','PRDO01','')
LoDatAdm.abrirtabla('ABRIR','PLNMASIT','ASIT','ASIT01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG2','BPGO','BPGO01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG3','BPGO','BPGO01','')
ENDCASE
SET FILTER TO TPOVAR$"6789"
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
SELECT PERS
GOTO TOP
UltTecla = 0
SELCIA = 1
GiMaxEle = 0
UltTecla = 0
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 11,13 SAY "Listado    : "
DO WHILE .T.
	VecOpc(1) = "Total"
	VecOpc(2) = "Individual"
	SelCia    = Elige(SelCia,11,26,2)
	IF UltTecla = Escape
		RETURN
	ENDIF
	IF SelCia = 2
		SET ORDER TO PERS01
		DO GENBrows
		IF LASTKEY() = 27
			LOOP
		ENDIF
	ENDIF
	EXIT
ENDDO
REGACT=RECNO()
DO F0PRINT
IF LASTKEY() = ESCAPE
	RETURN
ENDIF
esp =99
Largo    = 42       && Largo de pagina
LinFin   = Largo - 2
IniImp   = _Prn3
Ancho    = 200
Numpag   = 0
Tit_SIzq = []
Tit_SDer = []
Tit_SDr  = []
Tit_IIzq = []
Titulo   = []
SubTitulo= []
En1    = []
En2    = []
En3    = []
En4    = []
Cancelar = .F.
SET DEVICE TO PRINT
PRINTJOB
	Inicio = .F.
	Numpag = 0
	GO REGACT
	IF SelCia = 1
		DO FORMATO1
	ELSE
		DO FORMATO2
	ENDIF
ENDPRINTJOB
SET DEVICE TO SCREEN
*!*	DO ADMPRFIN 
RETURN

******************
PROCEDURE FORMATO2
******************
FOR NumEle = 1 TO GiMaxEle
	SELECT PERS
	SEEK AsCodigo(NumEle)
	xSiTPer = VALCAL("@SIT")
*!*		IF XSITPER<5
	DO FORMATO
*!*		ENFIF
    Cancelar = INKEY() = ESCAPE
	IF Cancelar
		EXIT
	ENDIF
ENDFOR
******************
PROCEDURE FORMATO1
******************
DO WHILE !EOF()  .AND. ! Cancelar
	xSitPer = VALCAL("@SIT")
*XFor   = [VALCAL("@SIT")#5 .OR. VALCAL("@VAC")=0]
	IF xSITPER < 5
		DO FORMATO
	ENDIF
	SELECT PERS
	SKIP
	Cancelar = INKEY() = ESCAPE
ENDDO
**************************************************************************
PROCEDURE FORMATO
**************************************************************************
store "   " to vINGRE,vDESCU
K=1
nMes = UPPER(MES(VAL(XsNroPer),3))
nAno = STR(YEAR(DATE()),4,0)
DD=SUBSTR(DTOC(DATE()),1,2)
MM=SUBSTR(DTOC(DATE()),4,2)
YY=RIGHT(DTOC(DATE()),2)
xFCHPGO = DD+'/'+MM+'/'+YY
DO ENCAB

********************************
SELE BPGO     && se imprime los ingresos
SEEK '6'
Ganancia = 0
DO WHILE !EOF()  .AND. TpoVar='6'
	=SEEK(BPGO->CODMOV,"TMOV")
	SELECT DMOV
	zLLave = XsCodPln+XsNroPer+PERS->CodPer+BPGO->CODMOV
	SEEK zLLave
	DO WHILE ! EOF() .AND. CodPln+NroPer+CodPer+CODMOV = zLlave
		XImport = VALCAL
		IF XImport#0
			Ganancia = Ganancia + XImport
			XsValRef = ""
			IF VALREF <> 0
				XsValRef = TRANSF(VALREF,"@L ####")
			ELSE
				IF ! EMPTY(BPGO->CODREF)
					RegAct = RECNO()
					XsValRef = TRANSF(VALCAL(BPGO->CODREF),"@Z 999")
					GOTO RegAct
				ENDIF
			ENDIF
			vINGRE1(K)=LEFT(UPPER(TMOV.DESMOV),19)
			vINGRE2(K)=XSVALREF
			vINGRE3(K)=TRANSF(XImport,"999,999.99")
			K=K+1
		ENDIF
		SELECT DMOV
		SKIP
	ENDDO
	SELE BPGO
	SKIP
ENDDO
SELE BPGO     && se imprime los descuentos
SEEK '7'
J=1
Descuento = 0
DO WHILE !EOF()  .AND. TpoVar<='8'
	=SEEK(BPGO->CODMOV,"TMOV")
	SELECT DMOV
	zLLave = XsCodPln+XsNroPer+PERS->CodPer+BPGO->CODMOV
	SEEK zLLave
	DO WHILE ! EOF() .AND. CodPln+NroPer+CodPer+CODMOV = zLlave
		XImport = VALCAL
		IF XImport#0
			Descuento = Descuento + XImport
			XsValRef = ""
			IF VALREF <> 0
				XsValRef = TRANSF(VALREF,"@L ###")
			ELSE
				IF ! EMPTY(BPGO->CODREF)
					RegAct = RECNO()
					XsValRef = TRANSF(VALCAL(BPGO->CODREF),"@Z 999")
					GOTO RegAct
				ENDIF
			ENDIF
			vDESCU1(J)=LEFT(UPPER(TMOV.DESMOV),19)
			vDESCU2(J)=xsVALREF
			vDESCU3(J)=TRANSF(XImport,"999,999.99")
			J = J + 1
		ENDIF
		SELECT DMOV
		SKIP
	ENDDO
	SELE BPGO
	SKIP
ENDDO
K = 1
J = 1
DO CASE
	CASE XsCodPln= "1" and INLIST(XsNroPer,[07],[12])
		@ PROW()+1,0       SAY [*** GRATIFICACION ***]
		@ PROW()  ,0+Esp   SAY [*** GRATIFICACION ***]
	CASE XsCodPln= "2" and INLIST(XsNroSem,[27],[50])
		@ PROW()+1,0       SAY [*** GRATIFICACION ***]
		@ PROW()  ,0+Esp   SAY [*** GRATIFICACION ***]
ENDCASE

DO WHILE K <= 18 .AND. J<=18
	@ PROW()+1,0       SAY vINGRE1(K)
	@ PROW(),25        SAY vINGRE2(K)
	@ PROW(),33        SAY vINGRE3(K)
	@ PROW(),48        SAY vDESCU1(J)
	@ PROW(),73        SAY vDESCU2(J)
	@ PROW(),81        SAY vDESCU3(J)
	@ PROW(),0  +esp  SAY vINGRE1(K)
	@ PROW(),25 +esp  SAY vINGRE2(K)
	@ PROW(),33 +esp  SAY vINGRE3(K)
	@ PROW(),48 +esp  SAY vDESCU1(J)
	@ PROW(),73 +esp  SAY vDESCU2(J)
	@ PROW(),81 +esp  SAY vDESCU3(J)
	VINGRE1(K)=" "
	VINGRE3(K)=" "
	VDESCU1(J)=" "
	VDESCU3(J)=" "
	K = K + 1
	J = J + 1
ENDDO
aIPSS = VALCAL("RS01")
aSNP  = VALCAL("RS02")
aFON  = VALCAL("RS04")
aSEN  = VALCAL("RS05")
aCCI  = VALCAL("RS06")
xNETO = VALCAL("RZ01")
xRedAnt=VALCAL("RZ02")
aRED  = VALCAL("RZ03")
aNETO = Ganancia - Descuento
aNERED= aNETO  &&+aRED

SELE CCTE
SEEK PERS.CODPER+CCTE.CODMOV
SAL1=CCTE.sdoant
SAL2=CCTE.sdodoc
@ 31,00     SAY _prn8a
@ PROW()+1,33     SAY GANANCIA  PICT "999,999.99"
@ PROW()  ,81     SAY DESCUENTO PICT "999,999.99"
@ PROW()  ,33+esp SAY GANANCIA  PICT "999,999.99"
@ PROW()  ,81+esp SAY DESCUENTO PICT "999,999.99"
@ 33,00     SAY " "
@ PROW()+2,00     SAY aIPSS     PICT "999,999.99"
@ PROW()  ,10     SAY aSNP      PICT "999,999.99"
@ PROW()  ,20     SAY aCCI      PICT "999,999.99"
@ PROW()  ,30     SAY aSEN      PICT "999,999.99"
@ PROW()  ,40     SAY aFON      PICT "999,999.99"
@ PROW()  ,50     SAY SAL1      PICT "999,999.99"
@ PROW()  ,60     SAY SAL2      PICT "999,999.99"
@ PROW()  ,77     SAY aNETO     PICT "999,999.99"
@ PROW(),00+esp SAY aIPSS     PICT "999,999.99"
@ PROW(),10+esp SAY aSNP      PICT "999,999.99"
@ PROW(),20+esp SAY aCCI      PICT "999,999.99"
@ PROW(),30+esp SAY aSEN      PICT "999,999.99"
@ PROW(),40+esp SAY aFON      PICT "999,999.99"
@ PROW(),50+esp SAY SAL1      PICT "999,999.99"
@ PROW(),60+esp SAY SAL2      PICT "999,999.99"
@ PROW(),77+esp SAY aNETO     PICT "999,999.99"
@ PROW()+1,0 SAY _PRN8B
RETURN

***************
Procedure Encab
***************
IF NumPag > 0
	EJECT PAGE
ENDIF
NumPag    = _PAGENO
IF NumPag = 1 .OR. NumPag = _PEPAGE
	IF ! GlRunDos
		SET PRINTER TO "cat >/dev/null"
	ELSE
		SET PRINTER TO NUL
	ENDIF
ENDIF
IF NumPag = _PBPAGE   && Reset Printer
	DO CASE
		CASE _Destino = 1
			IF _Interface = ""
				SET PRINTER TO
			ELSE
				SET PRINTER TO (_Interface)
			ENDIF
		CASE _Destino = 2
			SET PRINTER TO (_ARCHIVO)
		CASE _Destino = 3
			SET PRINTER TO (_ARCHIVO)
	ENDCASE
	SET DEVICE TO PRINTER
	@ 0,0 SAY _PRN3+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF
UltTecla = 0
IF NumPag >= _PBPAGE
	IF  _PWAIT
		SET DEVICE TO SCREEN
		@ 20,20 say "           Pausa entre p ginas          " COLOR SCHEME 7
		@ 21,20 say "     Presione [Enter] para continuar    " COLOR SCHEME 7
		?? CHR(7)
		@ 21,35 say "Enter" COLOR W*/N
		UltTecla = 0
		DO WHILE ! (UltTecla = Enter .OR. UltTecla = Escape)
			UltTecla = INKEY(0)
		ENDDO
		IF UltTecla = Escape
			SET DEVICE TO PRINTER
			RETURN
		ENDIF
		@ 20,20 say "                                        "    COLOR SCHEME 11
		@ 20,25 say "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
		@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n "    COLOR SCHEME 11
		SET DEVICE TO PRINTER
	ENDIF
ENDIF
IF GlRunDos
	SET DEVICE TO SCREEN
	@ 20,20 say "                                        "    COLOR SCHEME 11
	@ 20,25 say   "Imprimiendo  la P gina No. "+STR(NumPag,3,0) COLOR SCHEME 11
	SET DEVICE TO PRINTER
ENDIF

DD=SUBSTR(DTOC(PERS->FCHING),1,2)
MM=SUBSTR(DTOC(PERS->FCHING),4,2)
YY=RIGHT(DTOC(PERS->FCHING),2)
xFCHING = DD+'/'+MM+'/'+YY
DD=SUBSTR(DTOC(PERS->FCHCES),1,2)
MM=SUBSTR(DTOC(PERS->FCHCES),4,2)
YY=RIGHT(DTOC(PERS->FCHCES),2)
xFCHCES = DD+'/'+MM+'/'+YY

BASICO=VALCAL("CA01")
=SEEK("02"+PERS->CODSEC,"TABL")
SECCION=TABL->NOMBRE

=SEEK("23"+PERS->CODAFP,"TABL")
DESCAFP=TABL->NOMBRE

=SEEK("04"+PERS->CODCAR,"TABL")
DESCARG=TABL->NOMBRE
SHORA=ROUND(BASICO/30,2)

=SEEK(XsNroPer,'PRDO')
LdFchIni = PRDO.FchIni
LdFchFin = PRDO.FchFin

=SEEK(XsNroSem,'TSEM')
LdFch1 = TSEM.Fchfer
LdFch2 = TSEM.FchFe2
DD=SUBSTR(DTOC(LdFch1),1,2)
MM=SUBSTR(DTOC(LdFch1),4,2)
YY=SUBSTR(DTOC(LdFch1),7,2)
xFch1=DD+"/"+MM+"/"+YY

DD=SUBSTR(DTOC(LdFch2),1,2)
MM=SUBSTR(DTOC(LdFch2),4,2)
YY=SUBSTR(DTOC(LdFch2),7,2)
xFch2=DD+"/"+MM+"/"+YY

DD=SUBSTR(DTOC(LdFchIni),1,2)
MM=SUBSTR(DTOC(LdFchIni),4,2)
YY=SUBSTR(DTOC(LdFchIni),7,2)
xFchIni=DD+"/"+MM+"/"+YY

DD=SUBSTR(DTOC(LdFchFin),1,2)
MM=SUBSTR(DTOC(LdFchFin),4,2)
YY=SUBSTR(DTOC(LdFchFin),7,2)
xFchfin=DD+"/"+MM+"/"+YY

@ 0,0     SAY _PRN3+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
IF xscodpln="1"
	@ 2,0     SAY PERS->CODPER+"  "+LEFT(NOMBRE(),30)+"  "+"EMPLEADO"+"        "+LEFT(DESCARG,15)+"    "+XFCHPGO+"  "+xfchINg
	@ 2,0+esp SAY PERS->CODPER+"  "+LEFT(NOMBRE(),30)+"  "+"EMPLEADO"+"        "+LEFT(DESCARG,15)+"    "+XFCHPGO+"  "+xfchINg
ELSE
	@ 2,0     SAY PERS->CODPER+"  "+LEFT(NOMBRE(),30)+"  "+LEFT(DESCARG,15)+" "+"SEM"+" "+xsNroSem+" "+xfch1+" "+xfch2+"   "+xfching
	@ 2,0+esp SAY PERS->CODPER+"  "+LEFT(NOMBRE(),30)+"  "+LEFT(DESCARG,15)+" "+"SEM"+" "+xsNroSem+" "+xfch1+" "+xfch2+"   "+xfching
ENDIF
@ 5,0     SAY PERS->LELECT
@ 5,11    SAY LEFT(PERS->LMILIT,10)
@ 5,22    SAY PERS->CARAFP
@ 5,35    SAY PERS->N_IPSS
@ 5,53    SAY BASICO PICT "9999.99"
@ 5,63    SAY PERS->CTACTS
@ 5,85    SAY PERS->FCHCES

@ 5,0 +esp SAY PERS->LELECT
@ 5,11+esp SAY PERS->LMILIT
@ 5,35+esp SAY PERS->N_IPSS
@ 5,52+esp SAY BASICO PICT "9999.99"
@ 5,63+esp SAY PERS->CTACTS
@ 5,85+esp SAY PERS->FCHCES

@ 8,1 SAY " "

IF xSitPer > 1
	@ PROW()+1,6      SAY "** "+TRANSF(UPPER(SITPER()),"@I")+" **"
	@ PROW(),6 +esp   SAY "** "+TRANSF(UPPER(SITPER()),"@I")+" **"
ENDIF
RETURN

******************
PROCEDURE RESETPAG
******************
IF PROW()>=LinFin
	@ PROW() + 1,26 SAY "VAN.."
	@ PROW()    ,50 SAY IIF(BPGO->TPOVAR="6",Ganancia,Descuento) PICT "999,999.99"
	@ PROW()    ,26+esp SAY "VAN.."
	@ PROW()    ,55+esp SAY IIF(BPGO->TPOVAR="6",Ganancia,Descuento) PICT "999,999.99"
*!*		EJECT PAGE
	DO ENCAB
	@ PROW() + 1,26 SAY "VIENEN.."
	@ PROW()    ,50 SAY IIF(BPGO->TPOVAR="6",Ganancia,Descuento) PICT "999,999.99"
	@ PROW()    ,26+esp SAY "VIENEN.."
	@ PROW()    ,55+esp SAY IIF(BPGO->TPOVAR="6",Ganancia,Descuento) PICT "999,999.99"
ENDIF
RETURN
******************
PROCEDURE AcumAsit
******************
private LdFecha,nDia
=SEEK(XsNroPer,'PRDO')
STORE 0  TO vTiempo
STORE "   " TO vAsit
STORE 0 TO nDM,nDN,nFI,nHD,nHS,nLS,nLC,nTR,nVC
LdFchIni = PRDO.FchIni
LdFchFin = PRDO.FchFin
LdFecha  = LdFchIni
DO WHILE LdFecha<= LdFchFin
	IF !SEEK(DTOC(LdFecha,1)+PERS.CodPer,"ASIT")
		LdFecha = LdFecha + 1
		LOOP
	ENDIF
	DO CASE
		CASE ASIT.CodReg = 'DM'       && Descanso Medico
			nDM    = nDM + 1
		CASE ASIT.CodReg = 'DN'       && Descanso Natal
			nDN    = nDN + 1
		CASE ASIT.CodReg = 'FI'       && Falta Injustificada
			nFI    = nFI + 1
		CASE ASIT.CodReg = 'HD'       && Horas Extras dobles
			nHD    = nHD + ASIT.Tiempo
		CASE ASIT.CodReg = 'HS'       && Horas Extras simples
			nHS    = nHS + ASIT.Tiempo
		CASE ASIT.CodReg = 'LC'       && Licencia con Goce
			nLC    = nLC + 1
		CASE ASIT.CodReg = 'LS'       && Licencia sin Goce
			nLS    = nLS + 1
		CASE ASIT.CodReg = 'TR'       && Tardanzas
			nTR    = nTR + ASIT.Tiempo
		CASE ASIT.CodReg = 'VC'       && Vacaciones
			nVC    = nVC + 1
	ENDCASE
	nDia = Day(LdFecha)
	vTiempo(nDia)=ASIT.Tiempo
	vAsit(nDia)  =" "+ASIT.CodReg
	LdFecha = LdFecha + 1
ENDDO
DO RecAsit WITH 30,09
RETURN
*****************
Procedure RecAsit
*****************
parameter xx,yy
private nCol,nFil,nDia,k
espx = esp + 23
nFil = xx
store "" TO sFila1,sFila2,sFila3
FOR nDia = 26 to 32
	IF vAsit(nDia)=" TR"
		sFila1 = sFila1 + TRANS(vTiempo(nDia),"999")+space(2)
	ELSE
		sFila1 = sFila1 + vAsit(nDia)+space(2)
	ENDIF
ENDFOR
*!*	sFila1 = sFila1 + space(3)
FOR nDia = 1 to 4
	IF vAsit(nDia)=" TR"
		sFila1 = sFila1 + TRANS(vTiempo(nDia),"999")+space(2)
	ELSE
		sFila1 = sFila1 + vAsit(nDia)+space(2)
	ENDIF
ENDFOR
FOR nDia = 5 to 15
	IF vAsit(nDia)=" TR"
		sFila2 = sFila2 + TRANS(vTiempo(nDia),"999")+space(2)
	ELSE
		sFila2 = sFila2 + vAsit(nDia)+space(2)
    ENDIF
ENDFOR
FOR nDia = 16 to 25
	IF vAsit(nDia)=" TR"
		sFila3 = sFila3 + TRANS(vTiempo(nDia),"999")+space(2)
	ELSE
		sFila3 = sFila3 + vAsit(nDia)+space(2)
	ENDIF
ENDFOR
*!* Imprimimos Lineas de Asistencia *!*
@xx,yy SAY _Prn3
FOR K = 0 TO 2
	@xx+0,(yy+1+k)+k*espx     SAY sFila1
ENDFOR
FOR K = 0 TO 2
	@xx+3,(yy+1+k)+k*espx     SAY sFila2
ENDFOR
FOR K = 0 TO 2
	@xx+5,(yy+1+k)+k*espx     SAY sFila3
ENDFOR
nCol = yy + 6
nFil = nFil + 7
@nFil,nCol say _Prn3
FOR k = 0 to 2
	nCol = yy + 6
	@nFil,nCol+k*esp    say nFI PICT "999"
	@nFil,nCol+20+k*esp say nVC PICT "999"
ENDFOR
nFil = nFil + 1
FOR k = 0 to 2
	nCol = yy
	@nFil,(nCol-1)+k*Esp SAY _Prn3+"TARDANZ"+_prn3
	nCol = yy + 6
	@nFil,nCol+k*esp    say nTR PICT "999"
ENDFOR
FOR k = 0 to 2
	nCol = yy + 26
	@nFil,nCol+k*esp    say nDM PICT "999"
ENDFOR
nFil = nFil + 1
FOR k = 0 to 2
	nCol = yy
	@nFil,(nCol-1)+k*Esp SAY _Prn4+"L.S.GOCE"+_Prn2
	nCol = yy + 6
	@nFil,nCol+k*esp    say nLS PICT "999"
ENDFOR
FOR k = 0 to 2
	nCol = yy + 26
	@nFil,nCol+k*esp    say nDN PICT "999"
ENDFOR
nFil = nFil + 1
FOR k = 0 to 2
	nCol = yy + 26
	@nFil,nCol+k*esp    say nLC PICT "999"
ENDFOR
RETURN
