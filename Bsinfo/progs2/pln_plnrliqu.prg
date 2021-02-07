ON KEY LABEL F2 SUSPEND
SET DATE TO BRIT
SET PROCE TO PLNFXGEN
* Pintamos Pantalla
CTIT1 = GSNOMCIA
CTIT2 = MES(VAL(XSNROPER),1)
CTIT3 = "USUARIO : "+TRIM(GSUSUARIO)
CTIT4 = "Reporte de Liquidaciones"
*DIMENSION AsTipo(2)
DIMENSION AsCodigo(20)
DIMENSION xAdFecha(2)
xAdFecha(1) = " Total       "
xAdFecha(2) = " Individual  "
DO FONDO WITH cTit1,cTit2,cTit3,cTit4
cNomCia  = GsNomCia
XsNroPer = IIF(XsCodPln=="1",XsNroPer,XsNroSem)
SELE 9
USE PLNTDEDU  ORDER DEDU01 ALIAS DEDU
SELE 8
USE PLNMTABL ORDER TABL01 ALIAS TABL
SELE 7
USE PLNMPCTS ORDER PCTS01 ALIAS PCTS
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
SET FILTER TO CodPln = XsCodPln .AND. !EMPTY(FchCES)
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
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67

* SELECT PCTS
* GO BOTT
* NTipo      = 0
* dFecha     = DTOC(Pcts.FchIni)+ " " + DTOC(Pcts.FchFin)
* @ 9,29  SAY " Beneficios Sociales " COLOR SCHEME 7
* STORE SPACE(LEN(PERS->CodPer)) TO Desde,Hasta
* @ 12,13 SAY "Reporte    : "
* XDFDH  = 1
* DO WHILE !INLIST(UltTecla,Escape)
*    DO CASE
*       CASE I = 1
*            UltTecla = enter
*       CASE I = 2
*            SELECT PERS
*            GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
*            DO LIB_Mtec with 99
*            @ 11,28 GET SelCia FUNCTION "^" FROM xAdFecha
*            READ
*            UltTecla    = LASTKEY()
*            IF UltTecla = Escape
*               EXIT
*            ENDIF
*            IF SelCia = 2
*               DO GENBrows
*               UltTecla    = LASTKEY()
*               IF LASTKEY() = 27
*                  LOOP
*               ENDIF
*            ENDIF
*            UltTecla    = LASTKEY()
*            IF INLIST(UltTecla,Escape,Enter,F10)
*               EXIT
*            ENDIF
*    ENDCASE
*    I = IIF(INLIST(UltTecla,Arriba,Izquierda),I-1,I+1)
*    I = IIF(I>2,2,I)
*    I = IIF(I<1,1,I)
* ENDDO
* IF UltTecla == Escape
*   CLOSE DATA
*   RETURN
* ENDIF
SELE PERS
IF SelCia = 2
   SET FILTER TO ASCAN(AsCodigo,CodPer,1,GiMaxEle)>0 .AND. !EMPTY(FchCES)
ENDIF
SELE PERS
SET ORDER TO PERS02
GOTO TOP
RegAct = RECNO()
DO ADMPRINT &&IN PLNMRCTS
IF Lastkey() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
SELECT PERS
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
     XSCODPER = CODPER
     XSNOMBRE = NOMBRE()
     XSFCHING = PERS.FCHING
     XSFCHCES = PERS.FCHCES
     XTMPANO  = TMPAMD(1,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN A¥OS
     XTMPMES  = TMPAMD(2,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN MESES
     XTMPDIA  = TMPAMD(3,XSFCHING,DATE())  && TIEMPO DE SERVICIOS EN DIAS

     SELE DECT
     SET ORDER TO DECT01 DESCENDING
     SEEK XSCODPLN + XSCODPER
     XSNROPER = NROPER
     SET ORDER TO DECT01 ASCENDING

     SELE PERS
     XNSUEMEN  = VALCAL('XB01')  && SUELDO MENSUAL
     IF XNSUEMEN <= 0
        SKIP
        LOOP
     ENDI
     XNPROGRA = VALCAL('XB02') && PROMEDIO DE GRATIFICACION
     XNSUELIQ = VALCAL('XB10') && SUELDO LIQUIDABLE
     IF XNSUELIQ <= 0
        SKIP
        LOOP
     ENDI
     XLANOS = VALCAL('XC01')
     XLMESE = VALCAL('XC02')
     XLDIAS = VALCAL('XC03')
     XLVACA = VALCAL('XC04')
     XLIANOS = VALCAL('XD01')
     XLIMESE = VALCAL('XD02')
     XLIDIAS = VALCAL('XD03')
     XLIVACA = VALCAL('XD05')
     XLTOTAL = VALCAL('XD04')

     NUMLIN = 1
     ???IniImp
     @NUMLIN,0 SAY PADL(ALLT(GSNOMCIA),80)
     @NUMLIN+1,0 SAY PADC('COMPENSACION POR TIEMPO DE SERVICIOS',80)
     @NUMLIN+2,0 SAY PADC('------------ --- ------ -- ---------',80)
     NUMLIN = NUMLIN + 4
     @NUMLIN  , 2 SAY 'NOMBRE            : ' + ALLT(XSNOMBRE)
     @NUMLIN+1, 2 SAY 'CARGO             : ' + IIF(SEEK('04'+PERS.CodCar,'TABL'),TABL.NOMBRE,'')
     @NUMLIN+2, 2 SAY 'FECHA DE INGRESO  : ' + DTOC(XSFCHING)
     @NUMLIN+3, 2 SAY 'FECHA DE CESE     : ' + DTOC(XSFCHCES)
     @NUMLIN+4, 2 SAY 'SUELDO MENSUAL    : ' + TRAN(XNSUEMEN,'99,999.99')
     @NUMLIN+5, 2 SAY 'PROMEDIO GRATIF.  : ' + TRAN(XNPROGRA,'99,999.99')
     @NUMLIN+6, 2 SAY 'SUELDO LIQUIDABLE : ' + TRAN(XNSUELIQ,'99,999.99')
     NUMLIN = NUMLIN + 8
     @NUMLIN,0 SAY PADC('LIQUIDACION',80)
     @NUMLIN+1,0 SAY    PADC('-----------',80)
     NUMLIN = NUMLIN + 3
     @NUMLIN,2 SAY 'DEPOSITO DE CTS'
     @NUMLIN+1,2 SAY '-----------------------------'
     NUMLIN = NUMLIN + 2
     SELE DECT
     SEEK XSCODPLN+XSCODPER
     XTOT = 0
     STOR {} TO XFECINI,XFECFIN
     XFECFIN = PERS.FCHCES
     DO WHILE !EOF()
        @NUMLIN,2 SAY FCHINI
        @NUMLIN,15 SAY FCHFIN
        @NUMLIN,28 SAY 'S/.'
        @NUMLIN,33 SAY IMPPAG PICT '99,999.99' FUNC 'Z'
        XTOT = XTOT + IMPPAG
        IF LIQUID
           XTOT = XTOT - IMPPAG
           XFECINI  = FCHINI
           EXIT
        ENDI
        NUMLIN = NUMLIN + 1
        SKIP
     ENDD
     NUMLIN = NUMLIN + 1
     @NUMLIN,33 SAY '---------'
     @NUMLIN+1,28 SAY 'S/.'
     @NUMLIN+1,33 SAY XTOT PICT '99,999.99' FUNC 'Z'
     @NUMLIN+2,33 SAY '---------'
     NUMLIN = NUMLIN + 4
     SELE PERS
     @NUMLIN,2 SAY 'DE ' + DTOC(XFECINI) + ' A ' + DTOC(XFECFIN) + '  =  ' + TRAN(XLANOS,'99') + ' A¤o(s), ' + TRAN(XLMESE,'99') + ' Mes(es), ' + TRAN(XLDIAS,'99') + ' Dia(s)'

     NUMLIN = NUMLIN + 2
*     POR 99 ANO(S)  DEL SUELDO LIQUIDABLE           = 99,999.99
*     POR 99 MES(ES) DEL SUELDO LIQUIDABLE           = 99,999.99
*     POR 99 DIA(S)  DEL SUELDO LIQUIDABLE           = 99,999.99
*     COMISION VARIABLE       : 99,999.99            = 99,999.99
*                                                      ---------
*                                              S/.     99,999.99
*     2345678901234567890123456789012345678901234567890
     @NUMLIN,2 SAY 'POR ' + TRAN(XLANOS,'99') + ' A¤o(s)  DEL SUELDO LIQUIDABLE            = ' + TRAN(XLIANOS,'99,999.99')
     @NUMLIN+1,2 SAY 'POR ' + TRAN(XLMESE,'99') + ' Mes(es) DEL SUELDO LIQUIDABLE            = ' + TRAN(XLIMESE,'99,999.99')
     @NUMLIN+2,2 SAY 'POR ' + TRAN(XLDIAS,'99') + ' Dia(s) DEL SUELDO LIQUIDABLE             = ' + TRAN(XLIDIAS,'99,999.99')
     @NUMLIN+3,2 SAY 'POR ' + TRAN(XLVACA,'99') + ' Mes(s) DE VACAC. TRUNC. DEL SUELDO MENS. = ' + TRAN(XLIVACA,'99,999.99')
     NUMLIN = NUMLIN + 4
     XTOT2 = VALCAL('XD15')
     SELE DEDU
     SEEK XSCODPER
     DO WHILE !EOF()
        IF INGRESO > 0
           @NUMLIN,2 SAY PADR(GLOSA,46) + '  = ' + TRAN(INGRESO,'99,999.99')
           XTOT2 = XTOT2 + INGRESO
           NUMLIN = NUMLIN + 1
        ENDI
        SKIP
     ENDD
     SELE PERS
     NUMLIN = NUMLIN + 1
     @NUMLIN,2 SAY '                                                  ---------'
     @NUMLIN+1,2 SAY '                                          S/.     ' + TRAN(XTOT2,'99,999.99')
     NUMLIN = NUMLIN + 3
     @NUMLIN,0 SAY   PADC('RETENCIONES',80)
     @NUMLIN+1,0 SAY PADC('-----------',80)
     NUMLIN = NUMLIN + 2
     XSNP = VALCAL('XE03')
     XFONDO  = VALCAL('XF01')
     XSEGURO = VALCAL('XF03')
     XCOMFIJ = VALCAL('XF04')
     XCOMVAR = VALCAL('XF05')
     XTOT3   = XSNP + XFONDO + XSEGURO + XCOMFIJ + XCOMVAR
     IF XSNP > 0
        @NUMLIN,2 SAY 'SNP                     : '+ TRAN(XSNP,'99,999.99')
        NUMLIN = NUMLIN + 1
     ENDI
     IF XFONDO > 0
        @NUMLIN,2 SAY 'FONDO DE PENSIONES      : '+ TRAN(XFONDO,'99,999.99')
        NUMLIN = NUMLIN + 1
     ENDI
     IF XSEGURO > 0
        @NUMLIN,2 SAY 'SEGURO PROVISIONAL      : '+ TRAN(XSEGURO,'99,999.99')
        NUMLIN = NUMLIN + 1
     ENDI
     IF XCOMFIJ > 0
        @NUMLIN,2 SAY 'COMISION FIJA           : '+ TRAN(XCOMFIJ,'99,999.99')
        NUMLIN = NUMLIN + 1
     ENDI
     IF XCOMVAR > 0
        @NUMLIN,2 SAY 'COMISION VARIABLE       : '+ TRAN(XCOMVAR,'99,999.99')
        NUMLIN = NUMLIN + 1
     ENDI
     SELE DEDU
     SEEK XSCODPER
     DO WHILE !EOF()
        IF EGRESO > 0
           @NUMLIN,2 SAY PADR(GLOSA,25) + ' ' +TRAN(EGRESO,'99,999.99')
           XTOT3 = XTOT3 + EGRESO
           NUMLIN = NUMLIN + 1
        ENDI
        SKIP
     ENDD
     IF XTOT3 > 0
        NUMLIN = NUMLIN - 1
     ENDI
     @NUMLIN,52 SAY TRAN(XTOT3,'99,999.99')
     @NUMLIN+1,52 SAY '---------'
     @NUMLIN+2,2 SAY '                                          S/.     ' + TRAN(XTOT2-XTOT3,'99,999.99')
     @NUMLIN+3,52 SAY '========='
     NUMLIN = NUMLIN + 4

     @NUMLIN,2 SAY 'SON : ' + NUMERO(XTOT2-XTOT3,2,1)
     @NUMLIN+1,2 SAY '           S.E.U.O'
     NUMLIN = NUMLIN + 3
     @NUMLIN,2 SAY 'DECLARO ESTAR CONFORME A LA LIQUIDACION QUE ANTECEDE Y EN FE DE LO CUAL'
     @NUMLIN+1,2 SAY 'FIRMO EL PRESENTE DOCUMENTO EN SE¥AL DE ACEPTACION Y CONFORMIDAD'
     NUMLIN = NUMLIN + 3
     @NUMLIN,0 SAY PADL('Lima, ' + STR(DAY(XSFCHCES),2,0) + ' de ' + MES(MONTH(XSFCHCES),3) + ' de ' + TRAN(YEAR(XSFCHCES),'9,999'),80)
     NUMLIN = NUMLIN + 4
     @NUMLIN,0 SAY PADL(REPL('-',40),80)
     @NUMLIN+1,0 SAY PADL(PADC(ALLT(XSNOMBRE),40),80)
     SELE PERS
     SKIP
ENDDO
ENDPRINTJOB
XSNROPER = XSPERANT
SET DEVICE TO SCREEN
DO ADMPRFIN
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

