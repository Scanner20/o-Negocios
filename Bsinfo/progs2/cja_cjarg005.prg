********************************************************************************
* Programa      : Cjarg005.PRG                                                 *
* Objeto        : Estado de Liquidez - Diario                                  *
* Autor         : VETT                                                         *
* Creaci¢n      : 24/11/93                                                     *
* Actualizaci¢n : 24/07/95                                      - MILKITO      *
* RMOV02        : NroMes+CodCta+DTOS(FchAst)                                   *
********************************************************************************
#include const.h
*** Abrimos Bases ****
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV02','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')

Ll_Liqui_C=.F.
IF !USED('L_C_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Cob.dbf')
		SELECT 0
		USE Liq_Cob ORDER LIQ_COB ALIAS L_C_Cobr	&& LIQUI
		Ll_Liqui=.T.
	ENDIF	
ENDIF
Ll_Liqui_D=.F.
IF !USED('L_D_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Det.dbf')
		SELECT 0
		USE Liq_Det ORDER CodDoc ALIAS L_D_Cobr	&& LIQUI
		Ll_Liqui_D=.T.
	ENDIF
ENDIF

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ESTADO DE LIQUIDEZ - DIARIO"
** Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********
XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodRef = SPACE(LEN(RMOV->CodAux))
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XdFch1   = CTOD('01/'+STR(_MES,2,0)+'/'+STR(_ANO,4,0))
XdFch2   = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),IIF(VARTYPE(GdFecha)='D',GdFecha,DATE()))
XnMes    = _Mes
XiTipo   = 1
LdFecha  = GdFecha
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XfTpoCmb = 1
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
UltTecla = 0
XnFormato = 1	&& 1 Hoja chica, 2 Hoja USA Standar
XlFchEnt = .f.
XlFchPed = .f.
XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv
XsCtaPreD = SPACE(LEN(RMOV.CtaPre))
XsCtaPreH = SPACE(LEN(RMOV.CtaPre))
TstLinImp2 = '.T.'
XlSoloMonedaCuenta = .F.

DO FORM CBD_Cjarg005
*****************
FUNCTION IMPRIMIR
*****************
SELECT CTAS
IF EMPTY(XsCtaDes)
   XsCtaDes = [10]
   XsCtaHas = [10]
ENDIF
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

DO F0PRINT
IF UltTecla = K_ESC
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 155
Cancelar = .F.
*** VETT 2010-01-20 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2010-01-20 ----- FIN

IniImp  = _PRN8A+_PRN4
LnLenCia=42

Tit_SIZQ = SUBSTR(TRIM(GsNomCia),1,LnLenCia)
*!*	Tit_IIZQ = TRIM(GsDirCia)
Tit_IIZQ = SUBSTR(TRIM(GsNomCia),LnLenCia+1)
Tit_IIZQ2 = "RUC:"+GsRucCia
Tit_SDER = "FECHA : "+DTOC(GdFecha)
Tit_IDER = "HORA :"+TIME() 
Titulo   = "LIBRO DE CAJA Y BANCOS"
SubTitulo   = "MES DE "+MES(XnMes,1)+" DE "+TRANS(_ANO,"9,999")
En1 = "(CUENTAS EN "+TRIM(VECOPC(XiCodMon))+")"
IF XdFch1=XdFch2
   En2 = "AL : "+DTOC(XdFch1)
ELSE
   En2 = "Del: "+DTOC(XdFch1)+" Al: "+DTOC(XdFch2)
ENDIF
EN3 = "Filtro "+GoCfgCbd.GLOPRE+":" + LcRptTit
En4 = IIF(XnCodDiv=0,'',vDivision(XnCodDiv))
En5 = IIF(EMPTY(XsCodRef),[],"REFERENCIA :"+LEFT(AUXI->NomAux,30))
DO CASE
	CASE	XnFormato=1
		En6 = "***** ******** *** *********** ******************** ***************** ************* *************************** ************* ****************"
		En7 = "       COMPRO  LI      Nro.                                                SALDO          M O V I M I E N T O     S A L D O     OBSERVACIONES "
		En8 = "FECHA  BANTE   BRO  DOCUMENTO     GIRADO A:            GLOSA              ANTERIOR        CARGOS       ABONOS                                 "
		En9 = "***** ******** *** *********** ******************** ***************** ************* ************* ************* ************* ****************"
		*      0**** 6******* 15* 19********* 31****************** 52*************** 70*********** 84*********** 98*********** 122********** 1
		*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
		*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
		nColFch = 0 + _PLOFFSET
		nColAst	= 6	+ _PLOFFSET
		nColOpe = 15 + _PLOFFSET
		nColBan	= 0    && No va en Formato 1
		nColDoc = 19 + _PLOFFSET
		nColCco = 0    && No va en Formato 1
		nColGir = 31 + _PLOFFSET
		nColGlo = 52 + _PLOFFSET
		nColSan = 70 + _PLOFFSET
		nColCar = 84 + _PLOFFSET
		nColAbo = 98 + _PLOFFSET
		nColSal = 122 + _PLOFFSET
		Pos = 70 + _PLOFFSET
		Esp = 14 
		Ancho = 124		
	CASE	XnFormato=2
		En6 = "***** ******** *** ******** ************** ******** ******************** ************************* ************* *************************** *************"
		En7 = "       COMPRO  LI  FECHA         Nro.      CENTRO                                                     SALDO          M O V I M I E N T O       S A L D O  "
		En8 = "FECHA  BANTE   BRO BANCO      DOCUMENTO    COSTOS   GIRADO A:            GLOSA                        ANTERIOR        CARGOS       ABONOS                 "
		En9 = "***** ******** *** ******** ************** ******** ******************** ************************* ************* ************* ************* *************"
		nColFch = 0 + _PLOFFSET
		nColAst	= 6	 + _PLOFFSET
		nColOpe = 15 + _PLOFFSET
		nColBan	= 19 + _PLOFFSET
		nColDoc = 28 + _PLOFFSET
		nColGir = 52 + _PLOFFSET
		nColCco = 43 + _PLOFFSET
		nColGlo = 73 + _PLOFFSET
		nColSan = 99 + _PLOFFSET
		nColCar = 113 + _PLOFFSET
		nColAbo = 127 + _PLOFFSET
		nColSal = 141 + _PLOFFSET
		Pos = 99 + _PLOFFSET
		Esp = 14 
		Ancho = 155
	CASE	XnFormato=3
		En6 = "***** ******** *** ******** ************** ******** ******************** ************************* ************* *************************** *************"
		En7 = "       COMPRO  LI  FECHA         Nro.      CENTRO                                                     SALDO          M O V I M I E N T O       S A L D O  "
		En8 = "FECHA  BANTE   BRO BANCO      DOCUMENTO    COSTOS   GIRADO A:            GLOSA                        ANTERIOR        CARGOS       ABONOS                 "
		En9 = "***** ******** *** ******** ************** ******** ******************** ************************* ************* ************* ************* *************"
		nColFch = 0 + _PLOFFSET
		nColAst	= 6	 + _PLOFFSET
		nColOpe = 15 + _PLOFFSET
		nColBan	= 19 + _PLOFFSET
		nColDoc = 28 + _PLOFFSET
		nColGir = 52 + _PLOFFSET
		nColCco = 43 + _PLOFFSET
		nColGlo = 73 + _PLOFFSET
		nColSan = 99 + _PLOFFSET
		nColCar = 113 + _PLOFFSET
		nColAbo = 127 + _PLOFFSET
		nColSal = 141 + _PLOFFSET
		Pos = 99 + _PLOFFSET
		Esp = 14 
		Ancho = 155

ENDCASE
		*      0**** 6******* 15* 19****** 28************ 43****** 52******** 63******* 73*********************** 99*********** 113********** 127********** 141**********
		*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
		*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5

****** ****** *** ****** ********** ******* ********* **************************************** ************* *************************** ***************************"
*      COMPRO LI  FECHA     Nro.    VENCTO.                                                        SALDO          M O V I M I E N T O       S A L D O  A C T U A L  "
*FECHA BANTE  BRO BANCO  DOCUMENTO  CHEQUE REFERENCIA       GLOSA                                ANTERIOR        CARGOS       ABONOS        DEUDOR        ACREEDOR  "
****** ****** *** ****** ********** ****** ********** **************************************** ************* ************* ************* ************* *************"
*0**** 6***** 13* 17**** 24******** 35**** 42******** 53************************************** 94*********** 108********** 122********** 136********** 150**********"
*12-12 123456 123 123456 123456789- 123456 123456789- 123456789-123456789-123456789-123456789- 123456789-123 123456789-123 123456789-123 123456789-123 123456789-123



NumCol = 5
NumColR= 9


DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol),G(NumCol),Rx(NumCol),Ry(NumCol)
DIMENSION Rx(NumColR),Ry(NumColR)
store 0 to Z,y,x
SET DEVICE TO PRINT
*!*	IF gsSigCia='RIOAZUL'
*!*		SET MARGIN TO 5
*!*	ELSE
*!*		SET MARGIN TO 0
*!*	ENDIF	
PRINTJOB
   NumPag  = 0
   LsCodRef = []
   UltCta   = []
   Paso     = .F.
   Saltapag = .T.
   STORE 0 TO G
   SELE CTAS
   SEEK TRIM(XsCtaDes)
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
   DO WHILE CTAS->CodCta<=XsCtaHas .AND. !EOF() .AND. ! Cancelar
      Comienzo = .T.
     *LsCodRef = LEFT(AUXI->CodAux,LEN(RMOV.CodRef))
     *En4 = "COMITE  "+LsCodRef+"    "+RTRIM(AUXI->NomAux)
     *SaltaPag = .T.
      IF CTAS->AftMov#"S"  &&OR CTAS->CodMon#XiCodMon
         SKIP
         LOOP
      ENDIF
      IF CTAS->CodMon#XiCodMon AND XlSoloMonedaCuenta
         SKIP
         LOOP
      ENDIF 
		IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
		ELSE
			IF CodCta_B=XsCodDiv
			ELSE
				SELECT CTAS
				SKIP
				LOOP	
			ENDIF
		ENDIF

      LsCodCta = CTAS->CodCta
      NomCta1  = LEFT(CTAS->NomCta,35)
      NumItm1  = 0
      STORE 0 TO Y
      Primera1 = .T.
      DO LinImp
      Cancelar = Cancelar .OR. (INKEY() = K_Esc)
      IF !Cancelar  .and. (Y(1)>0 .or. Y(2)>0 .or. Y(3)>0 .or. Y(4)>0)
          DO ResetPag
          NumLin = PROW() + 1
          @ Numlin,_PLOFFSET SAY REPLICATE(".",Ancho)
          NumLin = PROW() + 1
          DO RESETPAG
          @ NumLin,+ _PLOFFSET SAY "TOTAL CUENTA    " + CTAS->CodCta
          DO RESETPAG
          FOR ll=1 TO 4
              Col = Pos + (ll -1)*Esp
              IF Y(ll) >= 0
                 @ NumLin,Col SAY Y(ll) PICT "@Z 99999,999.99"
              ELSE
                 @ NumLin,Col SAY -Y(ll) PICT "@Z 99999,999.99-"
              ENDIF
              G(ll) = G(ll) + Y(ll)
          ENDFOR
          Paso = .F.
          DO RESETPAG
          NumLin = PROW() + 1
          @ NumLin,+ _PLOFFSET SAY [ ]
          SELECT temporal 
          APPEND BLANK
          REPLACE		Cuenta WITH Ctas.CodCta
          REPLACE		Descripcio WITH 'TOTAL CUENTA  '+CTAS.CodCta
          REPLACE		Saldo_ini   WITH	Y(1)
          REPLACE		Cargo	WITH	Y(2)
          REPLACE		Abono	WITH	Y(3)
          REPLACE		Saldo	WITH	Y(4)
          SELECT CTAS
      ENDIF
      SELE CTAS
      SKIP
   ENDDO
   *
   IF ! CANCELAR  .and. Y(4)<>G(4)
      DO ResetPag
      NumLin = PROW() + 1
      @ NumLin,+ _PLOFFSET SAY "** TOTAL   GENERAL **"
      FOR i=1 TO 4
          Col = Pos + (i-1)*Esp
          IF G(I) >= 0
             @ NumLin,Col SAY G(i) PICT "@Z 99999,999.99"
          ELSE
             @ NumLin,Col SAY -G(i) PICT "@Z 99999,999.99-"
          ENDIF
      ENDFOR
          SELECT temporal 
          APPEND BLANK
          REPLACE		Cuenta WITH Ctas.CodCta
          REPLACE		Descripcio WITH '** TOTAL   GENERAL **'
          REPLACE		Saldo_ini   WITH	G(1)
          REPLACE		Cargo	WITH	G(2)
          REPLACE		Abono	WITH	G(3)
          REPLACE		Saldo	WITH	G(4)
          SELECT CTAS
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
SELECT Temporal
LOCATE
xTipRep='XLS'
DO F0PRFIN &&IN ADMPRINT
RELEASE xTipRep
RETURN
****************
PROCEDURE LinImp
****************
PRIVATE NumLin
XsNroMes = transf(XnMES,"@L ##")
NumItm1  = 0
Paso     = .F.

SELECT RMOV
SEEK XsNroMes+LsCodCta
SELECT ACCT
SET ORDER TO ACCT02
STORE 0 TO Y
IF Comienzo
   Comienzo = .F.
   STORE 0 TO X
   SELECT ACCT
   SEEK LsCodCta+TRIM(XsCodRef)
   DO WHILE CODCTA=LsCodCta .AND. ! EOF() .AND. ! Cancelar .AND. CodRef=TRIM(XsCodRef)
      IF  NroMes >  STR(XnMES,2,0)
          SKIP
          LOOP
      ENDIF
      SELECT ACCT
      *** Saldo al mes Anterior ***
      DO WHILE ! EOF() .AND. CodRef=TRIM(XsCodRef) .and. !Cancelar .AND. CodCta = LsCodCta
         IF NroMes <  STR(XnMES,2,0)
	 		IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
			
				IF XiCodMon = 1
					X(1) = X(1) + DbeNac - HbeNac
				ELSE
					X(1) = X(1) + DbeExt - HbeExt
				ENDIF
			ELSE
				LsDbeNacDiv	=	'DbeNac'+TRANSFORM(XnCodDiv,'@L 99')
				LsHbeNacDiv	=	'HbeNac'+TRANSFORM(XnCodDiv,'@L 99')
				LsDbeExtDiv	=	'DbeExt'+TRANSFORM(XnCodDiv,'@L 99')
				LsHbeExtDiv	=	'HbeExt'+TRANSFORM(XnCodDiv,'@L 99')
				IF XiCodMon = 1
					X(1) = X(1) + &LsDbeNacDiv. - &LsHbeNacDiv.
				ELSE
					X(1) = X(1) + &LsDbeExtDiv. - &LsHbeExtDiv.
				ENDIF
			
			ENDIF	
         ENDIF
         SKIP
         Cancelar = Cancelar .OR. (INKEY() = K_Esc)
      ENDDO
      SELE ACCT
   ENDDO
   *** Saldo a la Fecha De Inicio
   SELECT RMOV
   STORE 0 TO  XHbe ,XDbe
   SEEK XsNroMes+TRIM(LsCodCta)
   DO WHILE !EOF() .AND. CodCta=LsCodCta .AND. ! Cancelar .AND. NroMes=XsNroMes
      IF RMOV.FchAst>=XdFch1
         SKIP
         LOOP
      ENDIF
      IF !(RMOV->CodAux=TRIM(XsCodRef))
         SKIP
         LOOP
      ENDIF
      IF CTAS.CodMon = XiCodMon AND XlSoloMonedaCuenta
         DO CalImp
         nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
         IF TPOMOV = "D"
            XDbe = XDbe + nImport
         ELSE
            XHbe = XHbe + nImport
         ENDIF
      ELSE
         DO CalImp
         nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
         IF TPOMOV = "D"
            XDbe = XDbe + nImport
         ELSE
            XHbe = XHbe + nImport
         ENDIF
      ENDIF
      SKIP
   ENDDO
   X(1)  = X(1)  + XDbe - XHbe
   DO RESETPAG
   NumLin = PROW() + 1
   @Numlin,+ _PLOFFSET SAY LsCodCta+" "+NomCta1
  *@Numlin,038 SAY "SALDO ANTERIOR"
   IF X(1) >= 0
      @ NumLin,Pos   SAY  X(1) PICT "@Z 99999,999.99"
   ELSE
      @ NumLin,Pos   SAY -X(1) PICT "@Z 99999,999.99-"
   ENDIF
   SELECT Temporal
   APPEND BLANK 
   REPLACE Cuenta	WITH	LsCodCta 
   REPLACE Descripcio	WITH	NomCta1
   REPLACE Saldo_ini	WITH	X(1)
   SELECT RMOV
   DO ResetPag
   Numlin = Prow() + 1
   @ NumLin,+ _PLOFFSET SAY [ ]
ENDIF
IF XiTipo = 1
	DO ImpRMOV
ELSE
	DO ImpRMOV1
ENDIF
DO ResetPag
IF NumItm1 > 0 .or. Paso .or. X(1)<>0
   FOR I=1 TO 4
       Y(I)  = Y(I)  + X(I)
   ENDFOR
ENDIF
RETURN
*****************
PROCEDURE ImpRMOV
*****************
Primera  = .T.
sTimp	=	[(RMOV.FchAst>=XdFch1 .AND. RMOV.FchAst<=XdFch2) .AND. CodAux=TRIM(XsCodRef)]  &&&.OR. (RMOV->FchAst>XdFch2 .AND. MONTH(XdFch2+1)>XnMes)] SELECT RMOV   &&&  Marcianada del S.N.I.
sTimp	=	sTimp + IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')
sTimp	=	sTimp + IIF(XlFchPed,' AND EMPTY(FchPed)','') 

SEEK XsNroMes+LsCodCta
DO WHILE !EOF() .AND. LsCodCta=CodCta .AND. !Cancelar .AND. NroMes=XsNroMes
   IF !EVALUATE(sTimp)
      SKIP
      LOOP
   ENDIF
   IF !EVALUATE(TstLinImp2)
      SKIP
      LOOP
   ENDIF

   IF (CTAS.CodMon = XiCodMon AND XlSoloMonedaCuenta ) OR !XlSoloMonedaCuenta
      DO ResetPag
      NumLin = PROW() + 1
      Paso = .T.
      NumItm1 = NumItm1 + 1
      @ NumLin,nColFch   SAY TRANSF(DAY(FCHAST),"@L ##")+"-"+TRANSF(MONTH(FCHAST),"@L ##")
      @ NumLin,nColAst   SAY NroAst
      @ NumLin,nColOpe   SAY CodOpe
      IF !EMPTY(nColBan)
	      IF ! EMPTY(FCHPED)
	         @ NumLin,nColBan SAY TRANSF(DAY(FCHPED),"@L ##")+TRANSF(MONTH(FCHPED),"@L ##")+STR(YEAR(FCHPED),4,0)
	      ENDIF
      ENDIF
      @ NumLin,nColDoc   SAY NRODOC PICT "@S11"
*!*	      IF ! EMPTY(FCHVTO)
*!*	         @ NumLin,43  SAY TRANSF(DAY(FCHVTO),"@L ##")+TRANSF(MONTH(FCHVTO),"@L ##")+STR(YEAR(FCHVTO),4,0)
*!*	      ENDIF
	  IF !EMPTY(nColCco)	
	      @ NumLin,nColCco  SAY CodCco
      ENDIF
  
	  =SEEK(XsNroMes+rmov.codope+rmov.nroast,"VMOV")   && MAAV girado a

	 	
	  IF GsSigCia='TYJ'
	  	LsPicGlo= '@S58'
	  	nColGlo	= nColGir	 
		nLenGloDoc=58
	  ELSE
	  	LsPicGlo= '@S31'
		nLenGloDoc=40
      	@ NumLin,nColGir   SAY LEFT(VMOV.GIRADO,19)
      ENDIF
      LsImport = ""
      IF RMOV->CodMon <> 1 .AND. XiCodMon = 1
         LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
         IF RIGHT(LsImport,3)=".00)"
            LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
         ENDIF
      ENDIF
      IF CTAS->CodMon = 2  .AND. XiCodMon = 1
         LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,2))+")"
         IF RIGHT(LsImport,3)=".00"
            LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
         ENDIF
      ENDIF
      DO CASE
         CASE ! EMPTY(RMOV->Glodoc)
            LsGloDoc = LEFT(GloDoc,nLenGloDoc-LEN(LsImport))+LsImport
*!*	         CASE ! EMPTY(AUXI->NomAux)
*!*	            LsGloDoc = LEFT(AUXI->NomAux,nLenGloDoc-LEN(LsImport))+LsImport
         OTHER
            LsGloDoc = LEFT(VMOV->NotAst,nLenGloDoc-LEN(LsImport))+LsImport
      ENDCASE
*!*	      @ NumLin,063   SAY CODREF   PICT "@S9"
	   	
      @ NumLin,nColGlo   SAY LsGloDoc PICT LsPicGlo &&"@S36"
      DO CalImp
      IF TPOMOV = "D"
         @ NumLin,POS + 1*Esp   SAY nImport PICT "@Z 99999,999.99"
         X(2) = X(2) + nImport
      ELSE
         @ NumLin,POS + 2*Esp     SAY nImport PICT "@Z 99999,999.99-"
         X(3) = X(3) + nImport
      ENDIF
      TfSaldo = X(1) + X(2) - X(3)
      IF TfSaldo>=0
         @ NumLin, Pos + 3*Esp  SAY TfSaldo PICT "@Z 99999,999.99"
      ELSE
         @ NumLin, Pos + 3*Esp  SAY -TfSaldo PICT "@Z 99999,999.99-"
      ENDIF
    ENDIF
	SELECT Temporal
	APPEND BLANK 
	REPLACE 	Fecha		WITH RMOV.FchAst 
	REPLACE 	Libro  		WITH Rmov.CodOpe
	REPLACE 	Asiento		WITH RMOV.NroAst
	REPLACE 	Descripcio	WITH LsGloDoc
	REPLACE 	Girado_a	WITH VMOV.GIRADO
	REPLACE 	C_Costo 	WITH RMOV.CodCCo
	REPLACE 	N_Docum 	WITH RMOV.NroDoc
	REPLACE 	F_Finanza	WITH VMOV.FchPed
	REPLACE 	Cuenta 		WITH RMOV.CodCta
	IF RMOV.TPOMOV = "D"
		REPLACE Cargo		WITH nImport
	ELSE
		REPLACE Abono	WITH nImport
	ENDIF	    
	REPLACE 	Saldo		WITH TfSaldo
	REPLACE 	Mes		WITH RMOV.NroMes
	REPLACE 	C_Presup 	WITH RMOV.CtaPre
	REPLACE 	Division 	WITH RMOV.CodDiv
	REPLACE 	Moneda 	WITH IIF(VMOV.CodMon=1,'S/.',IIF(VMOV.CodMon=2,'US$','N/A'))
	REPLACE 	T_Cmb 		WITH VMOV.TpoCmb
	REPLACE 	T_Docum 	WITH RMOV.CodDoc
	REPLACE     CodAux		WITH RMOV.CodAux	
	SELECT RMOV
    SKIP
    Cancelar = Cancelar .OR. (INKEY() = K_Esc)
ENDDO
LfSaldo    = X(1)+X(2)-X(3)
X(4) =  LfSaldo
RETURN
******************
procedure ResetPag
******************

Okk = .F.
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltaPag
   SaltaPag = .F.
   DO F0MBPRN &&IN ADMPRINT
   IF UltTecla = K_Esc
      Cancelar = .T.
   ENDIF
   IF NumPag > 1
      IF LEN(RTRIM(Ctas.Codcta))>4
      ENDIF
   ENDIF
   NumLin = Prow() + 1
ENDIF
RETURN
****************
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
*************
FUNCTION _MES
*************
IF XnMES < 0 .OR. XnMES > 13
  GsMsgErr = "Invalido mes de Trabajo"
**  DO LIB_MERR WITH 99
  RETURN .F.
ENDIF
@ 09,51 SAY Mes(XnMes,1)
RETURN .T.
******************
PROCEDURE ImpRMOV1
******************
Primera  = .T.
sTimp=[(RMOV.FchAst>=XdFch1 .AND. RMOV.FchAst<=XdFch2) .AND. CodAux=TRIM(XsCodRef)]  &&&.OR. (RMOV->FchAst>XdFch2 .AND. MONTH(XdFch2+1)>XnMes)]
sTimp	=	sTimp + IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')
sTimp	=	sTimp + IIF(XlFchPed,' AND EMPTY(FchPed)','') 
SELECT RMOV                                                                           &&&  Marcianada del S.N.I.
SEEK XsNroMes+LsCodCta
DO WHILE !EOF() .AND. LsCodCta=CodCta .AND. !Cancelar .AND. NroMes=XsNroMes
   IF !EVALUATE(sTimp)
      SKIP
      LOOP
   ENDIF
   IF !EVALUATE(TstLinImp2)
      SKIP
      LOOP
   ENDIF
   IF (CTAS.CodMon = XiCodMon AND XlSoloMonedaCuenta ) OR !XlSoloMonedaCuenta
      DO ResetPag
      NumLin = PROW() + 1
      Paso = .T.
      NumItm1 = NumItm1 + 1
*!*	      @ NumLin,000   SAY TRANSF(DAY(FCHAST),"@L ##")+"-"+TRANSF(MONTH(FCHAST),"@L ##")
*!*	      @ NumLin,006   SAY NroAst
*!*	      @ NumLin,015   SAY CodOpe
      IF ! EMPTY(FCHPED)
*!*	         @ NumLin,019 SAY TRANSF(DAY(FCHPED),"@L ##")+TRANSF(MONTH(FCHPED),"@L ##")+STR(YEAR(FCHPED),4,0)
      ENDIF
*!*	      @ NumLin,028   SAY NRODOC
*!*	      IF ! EMPTY(FCHVTO)
*!*	         @ NumLin,43  SAY TRANSF(DAY(FCHVTO),"@L ##")+TRANSF(MONTH(FCHVTO),"@L ##")+STR(YEAR(FCHVTO),4,0)
*!*	      ENDIF
*!*	      @ NumLin,43  SAY CodCco
	  =SEEK(XsNroMes+rmov.codope+rmov.nroast,"VMOV")   && MAAV girado a
*!*	      @ NumLin,052   SAY LEFT(VMOV.GIRADO,19)
      LsImport = ""
      IF RMOV->CodMon <> 1 .AND. XiCodMon = 1
         LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
         IF RIGHT(LsImport,3)=".00)"
            LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
         ENDIF
      ENDIF
      IF CTAS->CodMon = 2  .AND. XiCodMon = 1
         LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,2))+")"
         IF RIGHT(LsImport,3)=".00"
            LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
         ENDIF
      ENDIF
      DO CASE
         CASE ! EMPTY(RMOV->Glodoc)
            LsGloDoc = LEFT(GloDoc,40-LEN(LsImport))+LsImport
         CASE ! EMPTY(AUXI->NomAux)
            LsGloDoc = LEFT(AUXI->NomAux,40-LEN(LsImport))+LsImport
         OTHER
            LsGloDoc = LEFT(VMOV->NotAst,40-LEN(LsImport))+LsImport
      ENDCASE
*!*	      @ NumLin,063   SAY CODREF   PICT "@S9"
*!*	      @ NumLin,073   SAY LsGloDoc PICT "@S36"
      DO CalImp
      IF TPOMOV = "D"
*!*	         @ NumLin,POS + 1*Esp   SAY nImport PICT "@Z 99999,999.99"
         X(2) = X(2) + nImport
      ELSE
*!*	         @ NumLin,POS + 2*Esp     SAY nImport PICT "@Z 99999,999.99-"
         X(3) = X(3) + nImport
      ENDIF
      TfSaldo = X(1) + X(2) - X(3)
      IF TfSaldo>=0
*!*	         @ NumLin, Pos + 3*Esp  SAY TfSaldo PICT "@Z 99999,999.99"
      ELSE
*!*	         @ NumLin, Pos + 3*Esp  SAY -TfSaldo PICT "@Z 99999,999.99-"
      ENDIF
    ENDIF
    SKIP
    Cancelar = Cancelar .OR. (INKEY() = K_Esc)
ENDDO
LfSaldo    = X(1)+X(2)-X(3)
X(4) =  LfSaldo
RETURN

******************
PROCEDURE CreaTemp
******************
PARAMETERS LsAliasTemp
IF PARAMETERS()=0
	LsAliasTemp = 'Temporal'
ENDIF
IF VARTYPE(LsAliasTemp)<>'C'
	LsAliasTemp = 'Temporal'
ENDIF
IF USED(LsAliasTemp)
	USE IN (LsAliasTemp)
ENDIF
LcArcTmp=GoEntorno.TmpPath+Sys(3)

SELE 0
CREATE TABLE (LcArcTmp) FREE  ; 
	(Cuenta C(LEN(RMOV.CodCta)),Fecha D, Libro C(LEN(RMOV.CodOpe)),;
	Asiento C(LEN(RMOV.NroAst)),Descripcio C(LEN(RMOV.GloDoc)+30), Girado_a C(LEN(VMOV.Girado)), ;
	T_Docum C(LEN(RMOV.CodDoc)),N_Docum C(LEN(RMOV.NroDoc)), F_Docum D(8), F_Vcmto D, F_Finanza D, Moneda C(3),;
	T_Cmb N(12,4),C_Costo C(LEN(RMOV.CodCCo)),C_Presup C(LEN(RMOV.CtaPre)), Saldo_Ini N(12,2),Cargo N(12,2),;
	Abono N(12,2), Saldo N(12,2), Mes C(LEN(RMOV.NroMes)),Division C(LEN(RMOV.CodDiv)),;
	CodAux C(LEN(RMOV.CodAux)), NomAux C(LEN(AUXI.NomAux)),Obs C(30) )

USE (LcArcTmp) EXCL ALIAS (LsAliasTemp)
IF !USED()
	RETURN ''
ENDIF
RETURN ALIAS()
*********************
PROCEDURE Captura_Obs
********************* 
IF !USED('L_C_Cobr')
	RETURN
ENDIF
IF !USED('L_D_Cobr')
	RETURN
ENDIF
DO CASE
		CASE CODCTA='12' AND TpoMov = "H"
		LsCodDoc=CodDoc
		LsNroDoc=NroDOc		
		SELECT L_C_Cobr
		SEEK LsNroAst
		LsLiqui = Liqui
		SELECT L_D_Cobr
		SEEK ALLTRIM(LsCodDoc+LsNroDoc+LsLiqui)
		LsObs = Obs		
ENDCASE
SELECT 0
SELECT RMOV
RETURN
************************