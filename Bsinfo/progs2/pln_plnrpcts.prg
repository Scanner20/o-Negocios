
SET DATE TO BRIT
SET PROCE TO PLNFXGEN
* Pintamos Pantalla
CTIT1 = GSNOMCIA
CTIT2 = MES(VAL(XSNROPER),1)
CTIT3 = "USUARIO : "+TRIM(GSUSUARIO)
CTIT4 = "Reporte de Beneficios Sociales"
*DIMENSION AsTipo(2)
DIMENSION AsCodigo(20)
DIMENSION xAdFecha(2)
xAdFecha(1) = " Total       "
xAdFecha(2) = " Individual  "
DO FONDO WITH cTit1,cTit2,cTit3,cTit4
cNomCia  = GsNomCia
XsNroPer = IIF(XsCodPln=="1",XsNroPer,XsNroSem)
SELE 9
DmovAnt1 = PATHDEF+[\]+[CIA]+GSCODCIA+[\]+[C]+STR(_ANO-1,4,0)+[\PLNDMOVT.DBF]
USE (dmovAnt1) ORDER dmov01 ALIAS dmov97
IF !USED(9)
	RETURN .F.
ENDIF
SELE 8
USE PLNMTABL ORDER TABL01 ALIAS TABL
SELE 7
USE PLNMPCTS ORDER PCTS01 DESCENDING ALIAS PCTS
GO TOP
XCONTA = 0
DO WHILE !EOF()
   XCONTA = XCONTA + 1
   DECLA APCTS[XCONTA,3]
   APCTS[XCONTA,1] = DTOC(FCHINI) + ' - ' + DTOC(FCHFIN)
   APCTS[XCONTA,2] = FCHINI
   APCTS[XCONTA,3] = FCHFIN
   SKIP
ENDD
*SELE 5
*USE PLNINTER  ORDER INTER2 ALIAS INTER
*IF !USED(5)
*   CLOSE DATA
*   RETURN
*ENDIF
*IF XsCodPln = "1"
*   SELE 4
*   USE PLNMTCTS  ORDER TCTS01 ALIAS TCTS         && Tabla de Conceptos de CTS
*ENDIF                                            && EMPLEADOS
*IF XsCodPln = "2"
*   SELE 4
*   USE PLNMTCT2  ORDER TCTS01 ALIAS TCTS         && Tabla de ConCeptos de CTS
*ENDIF                                            && OBREROS
*IF XsCodPln = "3"
*   SELE 4
*   USE PLNMTCT3  ORDER TCTS01 ALIAS TCTS         && Tabla de ConCeptos de CTS
*ENDIF                                            && OBREROS
*IF !USED(4)
*   CLOSE DATA
*   RETURN
*ENDIF

SELE 4
USE PLNDECTS ORDER DECT01 ALIAS DECT

SELECT 3
USE PLNMPERS ORDER PERS01 ALIAS PERS
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE PERS
SET FILTER TO CodPln = XsCodPln .AND. EMPTY(FchCES)
IF XsCodPln = "1"
   SELECT 2
   USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "2"
   SELECT 2
   USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "3"
   SELECT 2
   USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
ENDIF
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF


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
  CLOSE DATA
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

largo = 66
IniPrn=[_Prn0+chr(Largo)+_PRN4]
xWhile = []
IF XSCODPLN = '1'
   sNomREP = "PLNRPCTS"
 ELSE
   sNomREP = "PLNRPCT2"
ENDI
xFor   = [VALCAL("@SIT")#5 .AND. VALCAL('XB10')>0 .AND. EMPT(PERS.FCHCES)]
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN





PRINTJOB
  Inicio = .F.
  Numpag = 0
  GO REGACT
  DO WHILE !EOF()
     SELECT PERS
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


     NUMLIN = 1
     ???IniImp
     @NUMLIN,0 SAY PADC('LIQUIDACION DE COMPENSACION POR TIEMPO DE SERVICIOS (CTS)',80)
     @NUMLIN+2,0 SAY PADC(ALLT(GSNOMCIA),80)
     NUMLIN = NUMLIN + 4
     @NUMLIN  , 2 SAY 'NOMBRE                : ' + ALLT(XSNOMBRE)
     @NUMLIN+1, 2 SAY 'TIPO DE MONEDA        : SOLES'
     @NUMLIN+2, 2 SAY 'PERIODO ACTUAL DE CTS : ' + DTOC(APCTS[XDFDH,2]) + ' - ' + DTOC(APCTS[XDFDH,3])
     @NUMLIN+3, 2 SAY 'CONDICION             : ' + IIF(XSCODPLN='1','EMPLEADO','OBRERO')
     @NUMLIN+4, 2 SAY 'FECHA DE INGRESO      : ' + DTOC(XSFCHING)
     @NUMLIN+5, 2 SAY 'CARGO                 : ' + IIF(SEEK('04'+PERS.CodCar,'TABL'),TABL.NOMBRE,'')
     NUMLIN=NUMLIN+7
     @NUMLIN  ,2 SAY 'CONCEPTOS REMUNERATIVOS'
     @NUMLIN+1,2 SAY '********* *************'
     NUMLIN=NUMLIN+2
     XNAUXI = 0
     SELE TMOV
     SEEK 'XA'
     DO WHILE LEFT(CODMOV,2) = 'XA' .AND. !EOF()
        IF RIGH(CODMOV,2) = '00'
           SKIP
           LOOP
        ENDI
        IF XSCODPLN = '1'
           @NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV),'99,999.99')
         ELSE
           IF CODMOV = 'XA25'
              @NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV)/26,'9,999.999') + ' x 26 = ' + TRAN(VALCAL(CODMOV),'99,999.99')
              XNAUXI = XNAUXI + VALCAL(CODMOV)/26
            ELSE
              @NUMLIN, 2 SAY LEFT(DESMOV,21)+ ' : S/. ' + TRAN(VALCAL(CODMOV)/30,'9,999.999') + ' x 30 = ' + TRAN(VALCAL(CODMOV),'99,999.99')
              XNAUXI = XNAUXI + VALCAL(CODMOV)/30
           ENDI
        ENDI
        NUMLIN=NUMLIN+1
        SKIP
     ENDD
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


     IF XSCODPLN = '2'
        @NUMLIN, 2 SAY 'JORNAL INDENMIZABLE   : S/. ' + TRAN(XNAUXI,'9,999.999') + '      = ' + TRAN(XNSUELIQ,'99,999.99')
        @NUMLIN+1, 2 SAY 'DIAS CRONOLOGICOS     : ' + TRAN(XMESE,'99') + ' Mes(es) y ' + TRAN(XDIAS,'99') + ' dia(s)'
        @NUMLIN+2, 2 SAY 'DIAS DE INASISTENCIAS : ' + TRAN(VALCAL('XC05'),'99') + ' dia(s)'
        @NUMLIN+3, 2 SAY 'DIAS COMPUTABLES      : ' + TRAN(XMESER,'99') + ' Mes(es) y ' + TRAN(XDIASR,'99') + ' dia(s)'
        NUMLIN=NUMLIN+5
     ELSE
        @NUMLIN  , 2 SAY 'REMUN. INDENMIZABLE   : S/. ' + TRAN(XNSUELIQ,'99,999.99')
        @NUMLIN+1, 2 SAY 'DIAS COMPUTABLES      : ' + TRAN(XMESE,'99') + ' Mes(es) y ' + TRAN(XDIAS,'99') + ' dia(s)'
        NUMLIN=NUMLIN+3
     ENDI

     @NUMLIN,0 SAY PADC('LIQUIDACION POR CTS',80)
     NUMLIN=NUMLIN+2
*     MESES                 : 99,999.99 / 12      * 99 = 99,999.99
*     DIAS                  : 99,999.99 / 12 / 30 * 99 = 99,999.99
*     TOTAL                 :                          = 99,999.99
     @NUMLIN  , 2 SAY 'MESES                 : ' + TRAN(XNSUELIQ,'99,999.99') + ' / 12      * ' + TRAN(XMESER,'99') + ' = S/. ' + TRAN(XIMESE,'99,999.99')
     @NUMLIN  , 2 SAY 'DIAS                  : ' + TRAN(XNSUELIQ,'99,999.99') + ' / 12 / 30 * ' + TRAN(XDIASR,'99') + ' = S/. ' + TRAN(XIDIAS,'99,999.99')
     @NUMLIN+2, 2 SAY 'TOTAL                 :                          = S/. ' + TRAN(XTOTAL,'99,999.99')
     NUMLIN=NUMLIN+4
     @NUMLIN, 2 SAY 'EL MONTO EN SOLES ASCIENDE A     : S/. ' + TRAN(XTOTAL,'99,999.99')
     @NUMLIN+1, 2 SAY 'EL DEPOSITO A EFECTUARSE ES EN : DOLARES'
     @NUMLIN+2, 2 SAY 'TIPO DE CAMBIO                 : S/. ' + TRAN(XNTIPCAM,'99.9999')
     @NUMLIN+3, 2 SAY 'LO QUE DA UN TOTAL DE          : US$ ' + TRAN(XTOTAL/XNTIPCAM,'99,999.99')
     NUMLIN=NUMLIN+7

     @NUMLIN, 2 SAY REPL('-',LEN(ALLT(XSNOMBRE)))
     @NUMLIN+1, 2 SAY ALLT(XSNOMBRE)
     @NUMLIN+1, 2 SAY PADC('L.E.'+ PERS.LELECT,LEN(ALLT(XSNOMBRE)))

*     @NUMLIN,0 SAY PADL('Lima, ' + STR(DAY(DATE()),2,0) + ' de ' + MES(MONTH(DATE()),3) + ' de ' + TRAN(YEAR(DATE()),'9,999'),80)
     SELE PERS
     SKIP
  ENDDO
ENDPRINTJOB
XSNROPER = XSPERANT
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN



************************************************************** ( FIN )
FUNCTION ACMFECHA
**********************************************************************
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
**********************************************************************
FUNCTION TMPEFEC
**********************************************************************
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

**********************************************************************
FUNCTION IMPORTE
**********************************************************************
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
**********************************************************************
FUNCTION NUMFEC
**********************************************************************
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
**********************************************************************
FUNCTION DIFFEC
**********************************************************************
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

*********************************************************************
FUNCTION  NUM2FEC
*********************************************************************
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
************************************************************************
PROCEDURE SUMDIAS
************************************************************************
PARAMETERS XdFch1,XdFch2
RETURN XdFch1-XdFch2
************************************************************************
FUNCTION ANN2
************************************************************************
PARAMETERS X,Y
PRIVATE nVal
nVal = 1 - ((IIF(VAL(SUBS(DTOC(X),1,2))=31,30,VAL(SUBS(DTOC(X),1,2))) + (VAL(SUBS(DTOC(X),4,2))*30) + (VAL(SUBS(DTOC(X),7,2))*360)));
         + ((IIF(VAL(SUBS(DTOC(Y),1,2))=31,30,VAL(SUBS(DTOC(Y),1,2))) + (VAL(SUBS(DTOC(Y),4,2))*30) + (VAL(SUBS(DTOC(Y),7,2))*360)))
RETURN nVal
************************************************************************
FUNCTION NUMGRA
************************************************************************
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
















Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Reporte de C.T.S."
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
*********apertura de archivos************
SELE 8
DmovAnt1 = PATHDEF+[\]+[CIA]+GSCODCIA+[\]+[C]+STR(_ANO-1,4,0)+[\PLNDMOVT.DBF]
USE (dmovAnt1) ORDER dmov01 ALIAS dmov97
IF !USED(8)
	RETURN .F.
ENDIF

SELE 7
USE PLNMPCTS ORDER PCTS01 DESCENDING ALIAS PCTS
GO TOP
XFCHINI = FCHINI
XFCHFIN = FCHFIN

SELE 5
DO CASE
   CASE XsCodPln='1'
      USE PLNBLPG1 ORDER BPGO01 ALIAS BPGO
   CASE XsCodPln='2'
      USE PLNBLPG2 ORDER BPGO01 ALIAS BPGO
   CASE XsCodPln='3'
      USE PLNBLPG3 ORDER BPGO01 ALIAS BPGO
ENDCASE
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF

SELE 4
USE PLNMTABL ORDER TABL01 ALIAS TABL
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
*SELE 3
*   USE PLNTMOVT ORDER TMOV01 ALIAS TMOV
*IF !USED(3)
*   CLOSE DATA
*   RETURN
*ENDIF

IF XsCodPln = "1"
   SELECT 3
   USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "2"
   SELECT 3
   USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "3"
   SELECT 3
   USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
ENDIF
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE PLNMPERS ORDER PERS01 ALIAS PERS
SET FILTER TO CODPLN=XSCODPLN
GO TOP
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELECT PERS


Srepor = 1
GiMaxEle = 0
UltTecla = 0
*@ 9,10 CLEAR TO 18,67
*@ 9,10       TO 18,67
*@ 11,13 SAY "Planilla   : "
LSNROPER=XSNROPER
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
SELE PERS
SET FILTER TO CODPLN=XSCODPLN
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B+_PRN3]
xWhile = []
sNomREP = "PLNRPCTS"
xFor   = [VALCAL("@SIT")#5 .AND. VALCAL('XB10')>0 .AND. EMPT(PERS.FCHCES)]
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN
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
