DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
cNomCia  = GsNomCia

DO xPlnmrCts
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('PCTS')
loContab.oDatadm.CloseTable('DECT')
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
PROCEDURE xPlnmrCts
*******************
*!* Pintamos Pantalla *!*
CTIT1 = "Reporte de Beneficios Sociales"
CTIT2 = MES(VAL(XSNROPER),1)
CTIT3 = "USUARIO : "+TRIM(GSUSUARIO)
CTIT4 = GSNOMCIA
*!*	DIMENSION AsTipo(2)
DIMENSION AsCodigo(20)
DIMENSION xAdFecha(2)
xAdFecha(1) = " Total       "
xAdFecha(2) = " Individual  "
DO FONDO WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
*!*	SELE 9  && fijate en esto es importante MAAV 
*!*	DmovAnt1 = PATHDEF+[\]+[CIA]+GSCODCIA+[\]+[C]+STR(_ANO-1,4,0)+[\PLNDMOVT.DBF]
*!*	USE (dmovAnt1) ORDER dmov01 ALIAS dmov97
*!*	IF !USED(9)
*!*		RETURN .F.
*!*	ENDIF
LoDatAdm.abrirtabla('ABRIR','PLNMPCTS','PCTS','PCTS01','')
GO TOP
XCONTA = 0
DO WHILE !EOF()
	XCONTA = XCONTA + 1
	DECLARE APCTS[XCONTA,3]
	APCTS[XCONTA,1] = DTOC(FCHINI) + ' - ' + DTOC(FCHFIN)
	APCTS[XCONTA,2] = FCHINI
	APCTS[XCONTA,3] = FCHFIN
	SKIP
ENDDO
LoDatAdm.abrirtabla('ABRIR','PLNDECTS','DECT','DECT01','')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln .AND. EMPTY(FchCES)
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')

nImp0      = 0
nImp1      = 0
nImp2      = 0
nImp3      = 0
nImp4      = 0
nImp5      = 0
nImp6      = 0
nImp7      = 0
XlAcum     = 0
TmpEfecT   = " "
TmpServ    = " "
dFecha     = SPACE(35)
ActBol     = "S"
GiMaxEle   = 0
Bloque     = 1
UltTecla   = 0
xSelCia    = 1
SelCia     = 1
SSelCia    = 1
SelSec     = 1
SelPer     = 1
xSitPer    = 0
xSitVac    = 0
XfTpoCmb   = 1
TnNumLin   = 50
XcFlgEst   = " "
cdFecha    = " "
I          = 0
@ 9,10 CLEAR TO 20,67
@ 9,10       TO 20,67

SELECT PCTS
GO BOTT
NTipo      = 0
dFecha     = DTOC(Pcts.FchIni)+ " " + DTOC(Pcts.FchFin)
XNTIPCAM   = 2.589
@ 9,29  SAY " Beneficios Sociales " COLOR SCHEME 7
STORE SPACE(LEN(PERS->CodPer)) TO Desde,Hasta
@ 12,13 SAY "Per¡odo     : "
@ 15,13 SAY "Reporte     : "
@ 18,13 SAY "Tipo Cambio : "
XDFDH  = 1
DO WHILE !INLIST(UltTecla,Escape)
	DO CASE
		CASE I = 1
			SELECT PCTS
			@11,30 get XDFDH PICT '@^' FROM APCTS SIZE 1,21
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
		CASE I = 2
			SELECT PERS
			GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
			DO LIB_Mtec with 99
			@ 14,30 GET SelCia FUNCTION "^" FROM xAdFecha
			READ
			UltTecla    = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			IF SelCia = 2
				DO GENBrows
				UltTecla    = LASTKEY()
				IF LASTKEY() = 27
					LOOP
				ENDIF
			ENDIF
			UltTecla    = LASTKEY()
		CASE I = 3
			@ 18,30 GET XNTIPCAM PICT '99.9999'
			READ
			UltTecla    = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			IF INLIST(UltTecla,Escape,Enter,F10)
				EXIT
			ENDIF
	ENDCASE
	I = IIF(INLIST(UltTecla,Arriba,Izquierda),I-1,I+1)
	I = IIF(I>3,3,I)
	I = IIF(I<1,1,I)
ENDDO
IF UltTecla == Escape
	RETURN
ENDIF
SELE PERS
IF SelCia = 2
	SET FILTER TO ASCAN(AsCodigo,CodPer,1,GiMaxEle)>0 .AND. EMPTY(FchCES)
ENDIF
SELE PERS
SET ORDER TO PERS02
GOTO TOP
RegAct = RECNO()
DO f0PRINT 
IF Lastkey() = ESCAPE
	RETURN
ENDIF
SELECT PERS
NUME=1
GOTO TOP
Largo     = 66       && Largo de pagina
LinFin    = Largo - 6
IniImp    = _Prn1
Ancho     = 148
Numpag    = 0
UltTecla  = 0
Cancelar  = .F.
SET DEVICE TO PRINT
XSPERANT = XSNROPER
PRINTJOB
	Inicio = .F.
	Numpag = 0
	GO REGACT
	DO WHILE !EOF()
		SELECT PERS
		NUMPAG=NUMPAG +1
		XSCODPER = CODPER
		XSNOMBRE = NOMBRE()
		XSFCHING = PERS.FCHING
		XSFCHCES = PERS.FCHCES
		XTMPANO  = TMPAMD(1,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN A¥OS
		XTMPMES  = TMPAMD(2,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN MESES
		XTMPDIA  = TMPAMD(3,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN DIAS
		SELE DECT
		SEEK XSCODPLN + XSCODPER + DTOC(APCTS[XDFDH,2],1)
		XSNROPER = NROPER
		SELE PERS
		IF VALCAL('XD04') = 0
			SKIP
			LOOP
		ENDI
*!*			nume=1
		???IniImp
		numlin=1
		@NUMLIN,  0 say GSNOMCIA
		@NUMLIN, 52 say NUME
		@NUMLIN+1,0 say GSDIRCIA
		@NUMLIN+2,0 say "R.U.C.: "+GSRUCCIA
		@NUMLIN+4,0 SAY PADC('LIQUIDACION DE COMPENSACION POR TIEMPO DE SERVICIOS    LIQ. 1.15',80)
		@NUMLIN+5,0 SAY PADC('034.91TR',80)
		@NUMLIN+6,0 SAY PADC('---------------------------------------------------',80)
		NUMLIN = NUMLIN + 7
		@NUMLIN  , 2 SAY 'NOMBRE                : ' + ALLT(XSNOMBRE)
		@NUMLIN+1, 2 SAY 'TIPO DE MONEDA        : SOLES'
		@NUMLIN+2, 2 SAY 'PERIODO ACTUAL DE CTS : ' + DTOC(APCTS[XDFDH,2]) + ' - ' + DTOC(APCTS[XDFDH,3])
		@NUMLIN+3, 2 SAY 'CONDICION             : ' + IIF(XSCODPLN='1','EMPLEADO','OBRERO')
		@NUMLIN+4, 2 SAY 'FECHA DE INGRESO      : ' + DTOC(XSFCHING)
		@NUMLIN+5, 2 SAY 'CARGO                 : ' + IIF(SEEK('04'+PERS.CodCar,'TABL'),TABL.NOMBRE,'')
		NUMLIN=NUMLIN+7
		@NUMLIN  ,2 SAY 'CONCEPTOS REMUNERATIVOS'
		@NUMLIN+1,2 SAY '-----------------------'
		NUMLIN=NUMLIN+2
		XNAUXI = 0
		NUME=NUME+1
		SELE TMOV
		SEEK 'XA'
		DO WHILE LEFT(CODMOV,2) = 'XA' .AND. !EOF()
			IF RIGHT(CODMOV,2) = '00'
				SKIP
				LOOP
			ENDIF
			IF VALCAL(CODMOV)=0
				SKIP
				LOOP
			ENDIF
			IF XSCODPLN = '1'
				@NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV),'99,999.99')
			ELSE
				IF CODMOV = 'XA25'
					@NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV)/26,'9,999.999') + ' x 26 = ' + TRAN(VALCAL(CODMOV),'99,999.99')
					XNAUXI = XNAUXI + VALCAL(CODMOV)/26
				ELSE
					@NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV)/30,'9,999.999') + ' x 30 = ' + TRAN(VALCAL(CODMOV),'99,999.99')
					XNAUXI = XNAUXI + VALCAL(CODMOV)/30
				ENDIF
			ENDIF
			NUMLIN=NUMLIN+1
			SKIP
		ENDDO
		SELE PERS
		XNSUELIQ = VALCAL('XB10') && SUELDO LIQUIDABLE
		XANOS = VALCAL('XC01')
		XMESE = VALCAL('XC02')
		XDIAS = VALCAL('XC03')
		IF XSCODPLN = '1'
			XMESER = VALCAL('XC02')
			XDIASR = VALCAL('XC03')
		ELSE
			XMESER = VALCAL('XC06')
			XDIASR = VALCAL('XC07')
		ENDI
		XIANOS = VALCAL('XD01')
		XIMESE = VALCAL('XD02')
		XIDIAS = VALCAL('XD03')
		XTOTAL = VALCAL('XD04')
		@NUMLIN, 2 SAY '                            --------------------------'
		NUMLIN=NUMLIN + 1
		IF XSCODPLN = '2'
			@NUMLIN, 2 SAY '. INDENMIZABLE   : S/. ' + TRAN(XNAUXI,'9,999.999') + '      = ' + TRAN(XNSUELIQ,'99,999.99')
			@NUMLIN+1, 2 SAY 'DIAS CRONOLOGICOS     : ' + TRAN(XMESE,'99') + ' Mes(es) y ' + TRAN(XDIAS,'99') + ' dia(s)'
			@NUMLIN+2, 2 SAY 'DIAS DE INASISTENCIAS : ' + TRAN(VALCAL('XC05'),'99') + ' dia(s)'
			@NUMLIN+3, 2 SAY 'DIAS COMPUTABLES      : ' + TRAN(XMESER,'99') + ' Mes(es) y ' + TRAN(XDIASR,'99') + ' dia(s)'
			NUMLIN=NUMLIN+5
		ELSE
			@NUMLIN  , 2 SAY 'REMUN. INDENMIZABLE   : S/. ' + TRAN(XNSUELIQ,'99,999.99')
			@NUMLIN+1, 2 SAY 'DIAS COMPUTABLES      : ' + TRAN(XMESE,'99') + ' Mes(es) y ' + TRAN(XDIAS,'99') + ' dia(s)'
			NUMLIN=NUMLIN+3
		ENDIF
		@NUMLIN,0 SAY PADC('LIQUIDACION POR CTS',80)
		NUMLIN=NUMLIN+2
*!*			MESES                 : 99,999.99 / 12      * 99 = 99,999.99
*!*			DIAS                  : 99,999.99 / 12 / 30 * 99 = 99,999.99
*!*			TOTAL                 :                          = 99,999.99
		@NUMLIN  , 2 SAY 'MESES                 : ' + TRAN(XNSUELIQ,'99,999.99') + ' / 12      * ' + TRAN(XMESER,'99') + ' = S/. ' + TRAN(XIMESE,'99,999.99')
		@NUMLIN+1 , 2 SAY 'DIAS                  : ' + TRAN(XNSUELIQ,'99,999.99') + ' / 12 / 30 * ' + TRAN(XDIASR,'99') + ' = S/. ' + TRAN(XIDIAS,'99,999.99')
		@NUMLIN+2, 2 SAY 'TOTAL                 :                          = S/. ' + TRAN(XTOTAL,'99,999.99')
		@NUMLIN+3, 2 SAY '----------------------------------------------------------------'
		NUMLIN=NUMLIN+5
		@NUMLIN,   2 SAY 'EL MONTO EN SOLES ASCIENDE A     : S/. ' + TRAN(XTOTAL,'99,999.99')
		@NUMLIN+1, 2 SAY 'EL DEPOSITO A EFECTUARSE ES EN   : DOLARES'
		@NUMLIN+2, 2 SAY 'TIPO DE CAMBIO                   : S/. ' + TRAN(XNTIPCAM,'99.9999')
		@NUMLIN+3, 2 SAY 'LO QUE DA UN TOTAL DE            : US$ ' + TRAN(XTOTAL/XNTIPCAM,'99,999.99')
		@NUMLIN+4, 2 SAY 'ENTIDAD FINANCIERA               : AESA'
		numlin=numlin+6
		@NUMLIN, 2 SAY 'EL TRABAJADOR DECLARA SU CONFORMIDAD CON LA LIQUIDACION'
		@NUMLIN+1,2 SAY 'EN FE DE LO CUAL FIRMA EL PRESENTE DOCUMENTO'
		numlin=numlin+3
		IF gscodcia="003"
			@NUMLIN, 2 SAY "Ca¤ete, Noviembre de 1,998"
		ELSE
			@NUMLIN, 2 SAY "Lima, Noviembre de 1,998"
		ENDIF
		NUMLIN=NUMLIN+3
		@NUMLIN, 2 SAY REPL('-',LEN(ALLT(XSNOMBRE)))
		@NUMLIN, 45 SAY "---------------------"
		@NUMLIN+1, 2 SAY ALLT(XSNOMBRE)
		@NUMLIN+1, 50 SAY "GERENTE"
		@NUMLIN+2, 2 SAY PADC('L.E.'+ PERS.LELECT,LEN(ALLT(XSNOMBRE)))
*!*			@,0 SAY PADL('Lima, ' + STR(DAY(DATE()),2,0) + ' de ' + MES(MONTH(DATE()),3) + ' de ' + TRAN(YEAR(DATE()),'9,999'),80)
		SELE PERS
		SKIP
	ENDDO
ENDPRINTJOB
XSNROPER = XSPERANT
SET DEVICE TO SCREEN
DO f0prfin IN f0print
RETURN

*****************
FUNCTION ACMFECHA
*****************
PARAMETERS XCodPer
PRIVATE XdFecha
XdFecha = 0
SELECT INTER
=SEEK(XCodPer,"Inter")
SCAN WHILE Inter->CodPer == XCodPer .AND. !EOF()
	SELECT INTER
	XdFecha = xdFecha + SumDias(FecFin,FecIni)
ENDSCAN
SELECT PERS
RETURN XdFecha
****************
FUNCTION TMPEFEC
****************
PARAMETERS xFchING
IF CTOD("  /  /  ") <> XFchING
	Serv = INT( ( VAL(DTOC(Date(),1))-VAL(DTOC(XFchIng,1)) )/10000 )
	IF DAY(DATE()) > DAY(XFchING)
		Dias = ( DAY(DATE()) - DAY(XFchING) )
		Mese = MONTH(DATE())
	ELSE
		Dias = ( DAY(DATE() - DAY(DATE())) ) + ( DAY(DATE()) - DAY(XFchING) )
		Mese = ( MONTH(DATE()) - 1 )
	ENDIF
	IF Mese>=MONTH(XFchIng)
		Mesi = ( Mese - MONTH(XFchING) )
	ELSE
		Mesi = ( Mese - MONTH(XFchING) + 12 )
	ENDIF
ELSE
	MesI = 0
	Dias = 0
	Serv = 0
ENDIF
RETURN STR(MesI,2,0)+" Mese(s) "+STR(Dias,2,0)+" Dia(s) "+STR(Serv,2,0)+" A¤o(s)"

****************
FUNCTION IMPORTE
****************
PARAMETERS cCodMov
PRIVATE nZona,XlImporte
nZona = SELECT()
XlImporte = 0
SELE DMOVT
SEEK XsCodPln+XsNroPer+PERS->CodPer+cCodMov
IF FOUND()
	XlImporte = DMOVT.ValCal
ENDIF
SELECT (nZona)
RETURN XlImporte
***************
FUNCTION NUMFEC
***************
PARAMETERS cFec1,cFec2
PRIVATE d1,d2,m1,m2,a1,a2,dr,mr,ar,rm,ra
d1 = 00
d2 = 00
m1 = 00
m2 = 00
a1 = 00
a2 = 00
rm = 0
ra = 0
d1 = VAL(SUBS(cfec1,1,2))
m1 = VAL(SUBS(cfec1,3,2))
a1 = VAL(SUBS(cfec1,5,2))
d2 = VAL(SUBS(cfec2,1,2))
m2 = VAL(SUBS(cfec2,3,2))
a2 = VAL(SUBS(cfec2,5,2))
dr = d1 + d2
IF dr > 29
	rm = 1
	dr = dr - 30
ENDIF
mr = m1 + m2 + rm
IF mr > 11
	ra = 1
	mr = mr - 12
ENDIF
ar = a1 + a2 + ra
RETURN STR(dr,2)+STR(mr,2)+STR(ar,2)
***************
FUNCTION DIFFEC
***************
PARAMETERS cfec1,cfec2
PRIVATE d1,d2,m1,m2,a1,a2,dr,mr,ar,rm,ra
d1 = 0
d2 = 0
m1 = 0
m2 = 0
a1 = 0
a2 = 0
rm = 0
ra = 0
d1 = VAL(SUBS(cfec1,1,2))
m1 = VAL(SUBS(cfec1,4,2))
a1 = VAL(SUBS(cfec1,7,2))
d2 = VAL(SUBS(cfec2,1,2))
m2 = VAL(SUBS(cfec2,4,2))
a2 = VAL(SUBS(cfec2,7,2))
IF d2 >= d1
	dr = d2 - d1
	rm = 0
ELSE
	dr = 30 - d1 + d2
	rm = -1
ENDIF
IF m2 > m1
	mr = m2 - m1 + rm
	ra = 0
ELSE
	mr = 12 - m1 + m2 + rm
	ra = -1
ENDIF
IF mr = 12
	ra = ra +1
	mr = 0
ENDIF
ar = a2 - a1 + ra
RETURN STR(mr,2)+" Mese(s) " +STR(dr,2)+" Dia(s) "+ STR(ar,2)+ " A¤o(s) "

*****************
FUNCTION  NUM2FEC
*****************
PARAMETERS ndias
PRIVATE nano,nmes,ndias2
IF nDias>0
	nano   = INT(ndias/360)
	nmes   = INT(MOD(ndias,360)/30)
	ndias2 = ndias - (nano * 360) - (nmes * 30)
ELSE
	nano   = 0
	nmes   = 0
	ndias2 = 0
ENDIF
RETURN STR(nMes,2,0)+" Mese(s) "+STR(nDias2,2,0)+" Dia(s) "+STR(nAno,2,0)+" A¤o(s)"
*****************
PROCEDURE SUMDIAS
*****************
PARAMETERS XdFch1,XdFch2
RETURN XdFch1-XdFch2
*************
FUNCTION ANN2
*************
PARAMETERS X,Y
PRIVATE nVal
nVal = 1 - ((IIF(VAL(SUBS(DTOC(X),1,2))=31,30,VAL(SUBS(DTOC(X),1,2))) + (VAL(SUBS(DTOC(X),4,2))*30) + (VAL(SUBS(DTOC(X),7,2))*360)));
         + ((IIF(VAL(SUBS(DTOC(Y),1,2))=31,30,VAL(SUBS(DTOC(Y),1,2))) + (VAL(SUBS(DTOC(Y),4,2))*30) + (VAL(SUBS(DTOC(Y),7,2))*360)))
RETURN nVal
***************
FUNCTION NUMGRA
***************
PRIVATE nDias, nMeses
nDias  = 0
nMeses = 0
IF  ( Pers.FchIng <= Pcts.FchIni )
	NMeses = 6
ENDIF
*IF ( Pers.FchING > Pcts.FchINI    .AND.    ;
*   YEAR(Pcts.FchFIN) = YEAR(Pers.FchING) ) ;
*   .AND. ( PERS.FchIng <= PCTS.FchFin )
*    NMeses = ( MONTH(PCTS.FchFIN) - MONTH(PERS.FchING) )
*ENDIF
IF  MONTH( PERS->FcHING ) > 1 .AND. YEAR( PERS->FcHING ) = _ANO
	NMeses = 0
ENDIF
RETURN ( nMeses )
****************
FUNCTION FValCal
****************
PARAMETER Var,xPer,SAREA
PRIVATE WKnVal1
IF TYPE("Var") <> 'C'
	RETURN 0
ENDIF
xNroPer =XsNroPer
IF TYPE("xPer")="N"
	xNroPer = TRANSF(xPer,"@L ##")
ENDIF
WKnVal1 = 0
DO CASE
	CASE Var = "A"
		xLlave = SPACE(1+Len(&sArea..NroPer))+SPACE(Len(&sArea..CodPer))
		=SEEK(xLlave+Var,sArea)
		WKnVaL1 = &sArea..ValCal
	OTHER
		xLlave = XsCodPln+xNroPer+PERS->CodPer+Var
		m.cursel = select()
		SELECT (sArea)
		SEEK xLlave
		DO WHILE CodPln+NroPer+CodPer+CodMov = xLlave .AND. ! EOF()
			WKnVaL1 = WKnVaL1 + &sArea..ValCal
			SKIP
		ENDDO
		SELECT (m.cursel)
ENDCASE
RETURN WKnVal1/6
