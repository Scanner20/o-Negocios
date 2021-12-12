**>>  Vo.Bo. VETT  2008/09/23 10:46:24 
#INCLUDE CONST.H
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','')

Ll_Liqui_C=.F.
IF !USED('L_C_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Cob.dbf')
		SELECT 0
		USE Liq_Cob ORDER LIQ_AST ALIAS L_C_Cobr	&& LIQUI
		Ll_Liqui_C=.T.
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
*goentorno.open_dbf1('ABRIR','LIQ_COB','COB','LIQ_AST','')
*goentorno.open_dbf1('ABRIR','LIQ_DET','DET','CODDOC','')

cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE CUENTA CORRIENTE"
UltTecla = 0
INC = 0   && SOLES
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
*************************************************
** VETT:Guardamos valores iniciales   2021/12/09 16:29:40 ** 
*!*	PRIVATE XsNroMes,GdFecha
GdFechaIni = GdFecha   

** VETT: 2021/12/09 16:29:40 **


XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XiTpoMov = 1
XiResumen = 2
XsTipRep  = 1  
UltTecla = 0
i        = 1
XsCtaDes = SPACE(LEN(CTAS.CodCta))
XsCtaHas = SPACE(LEN(CTAS.CodCta))
STORE '' TO LsNomCtaDes,LsNomCtaHAs
STORE [] TO XsNomClfAux , XsNomAux,LsFchIni,LsFchFin,Titulo


XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv

DO FORM cbd_cbdrc003

** VETT: 2021/12/09 16:29:40 **
XsNroMes	= TRANSF(_MES,"@L ##")
GdFechaIni  = GdFecha 
** VETT: 2021/12/09 16:29:40 **

RETURN

********************
PROCEDURE GEN_REPORT
********************
LsWhile = '.T.'
LsCtas=.f.
*IF LEN(TRIM(XsCodCta))<LEN(RMOV.CodCta)
IF TRIM(XsCtaDes)<>TRIM(XsCtaHas) OR (EMPTY(XsCtaDes) AND EMPTY(XsCtaHas))
	LsCtas=.t.
ENDIF
XsCtaHasT=TRIM(XsCtaHas)
XsCtaDes = TRIM(XsCtaDes)
XsCtaHas = TRIM(XsCtaHas)+PADR('z',LEN(CTAS.CodCta))
XsCodCta=PADR(XsCtaDes,LEN(CTAS.CodCta))
IF EMPTY(XsCodCta) AND USED('C_CTAS_R')
	SELECT C_CTAS_R
	LOCATE 
	XsCodCta =  C_CTAS_R.Codcta
	XsCtaDes =  C_CTAS_R.Codcta
ENDIF
IF EMPTY(XsCtaHasT) AND USED('C_CTAS_R')
	SELECT C_CTAS_R
	GO BOTT 
	XsCtaHas =  C_CTAS_R.Codcta
ENDIF
SELECT RMOV
Llave = XsCodCta+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
	GO RECNO(0)
ENDIF
DO CASE
	CASE  EMPTY(XsCtaDes) AND EMPTY(XsCtaHas)
		LsWhile =  'CodCta <= XsCtaHas'
	CASE !EMPTY(XsCtaDes) AND EMPTY(XsCtaHas)
		LsWhile =  'CodCta >= XsCtaDes AND CodCta <= XsCtaHas'
	CASE EMPTY(XsCtaDes) AND !EMPTY(XsCtaHas)
		LsWhile =  'CodCta <= XsCtaHas'
	CASE !EMPTY(XsCtaDes) AND !EMPTY(XsCtaHas)
		LsWhile =  'CodCta >= XsCtaDes AND CodCta <= XsCtaHas'
		
	
ENDCASE
LsFor = '.T.'
IF !EMPTY(XsCodAux)
	LsFor = 'CodAux = XsCodAux'
ENDIf

LsFor1= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodDiv=XsCodDiv')
LsFor2= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodCta_B=XsCodDiv')
** VETT  05/04/2018 10:07 PM : Adaptacion para poder enviarlo al formulario de exportacion
XTipRep = 'XLS'
** VETT  05/04/2018 10:07 PM : 

*!*	DO F0PRINT  WITH XTipRep

** VETT: 2021/12/09 16:29:40 **
IF VAL(XsNroMes) < 12
    GdFecha=CTOD("01/"+STR(VAL(XsNroMes)+1,2,0)+"/"+STR(_Ano,4,0))-1
ELSE
    GdFecha=CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
** VETT: 2021/12/09 16:29:40 **

IF UltTecla = k_esc
	RETURN
ENDIF
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN

IniImp   = _Prn8a+_Prn4    && 15   cpi
IF XsTipRep=1
	Ancho    = 166
ELSE
	Ancho    = 121
ENDIF
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "ANALISIS DE CUENTA CORRIENTE AL "+DTOC(GdFecha)
SubTitulo= ''
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = IIF(LsCtas,'DESDE:'+XsCtaDes +' - '+LsNomCtaDes,'')
En3    = IIF(LsCtas,'HASTA:'+XsCtaHasT+' - '+LsNomCtaHas,'')
En4    = IIF(XnCodDiv=0,'',"  DIVISIÓN : "+vDivision(XnCodDiv))
En5    = XsCodAux+ "  " + XsNomAux +IIF(EMPTY(XsCodAux),"","  -  ")+IIF(XiTpoMov=1,"MOVIMIENTO MENSUAL  ","MOVIMIENTO TOTAL  ")
IF XsTipRep=1
	En6 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ ************** **************"
	En7 = "               No.                                 FECHA    FECHA                                         US$                                   SALDO   OBSERVACION   "
	En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.  VENCTO   FINANZAS GLOSA                            IMPORTE       CARGOS       ABONOS         ACTUAL       DEP.     "
	En9 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ ************** **************"
*          0******* 9************** 25************ 40******** 51****** 60****** 69************************* 97*********** 111********* 124********* 137*********** 150***********"
*          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
*          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16      
ELSE
	En6 = "******** *************** ************** ********** ************* ************ ************ ************** **************"
	En7 = "               No.                                           US$                                   SALDO    OBSERVACION "
	En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.        IMPORTE       CARGOS       ABONOS         ACTUAL       DEP.    "
	En9 = "******** *************** ************** ********** ************* ************ ************ ************** **************"
*          0******* 9************** 25************ 40******** 51*********** 65********** 79********** 91*************
*          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*          0         1         2         3         4         5         6         7         8         9        10     
ENDIF
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

*!*	SET DEVICE TO PRINT
*!*	SET MARGIN TO 0
*!*	PRINTJOB
*!*		GOTO RegIni
*!*		NumPag   = 0
	L0NumItm = 0
	L0Cargos = 0
	L0Abonos = 0
	LsUltCta = space(len(ctas.codcta))
	LsQuiCta = .f.
	Store 0 to LaNumItm,LaCargos,LaAbonos
	DO WHILE CodCta >= XsCtaDes AND !Cancelar AND EVALUATE(LsWhile) AND !EOF()
		IF CodAux<>XsCodAux
			SELECT RMOV
			SKIP
			LOOP
		ENDIF
		IF !&LsFor1
			SELECT RMOV
			SKIP
			LOOP
		ENDIF
*!*			SET STEP ON 
		IF CodCta<>LsUltCta
			LSUltCta=CodCta
			LsQuiCta=.t.
			Store 0 to LaNumItm,LaCargos,LaAbonos
		ENDIF    		
		**** Quiebre por Proveedor ****
		=SEEK(CodCta,"CTAS")
		=SEEK(CTAS->CLFAUX+CodAux,"AUXI")
		LsCodCta = CodCta
		LsClfAux = ClfAux
		LsCodAux = CodAux
		L1NumItm = 0
		L1Cargos = 0
		L1Abonos = 0
		Quiebre1 = .T.
		DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar AND !EOF()
			IF !&LsFor1
				SELECT RMOV
				SKIP
				LOOP
			ENDIF

			**** Quiebre por Documento ****
			LsNroDoc = NroDoc
			LiCodMon = CodMon
			L2NumItm = 0
			L2Cargos = 0
			L2Abonos = 0
			Quiebre2 = .T.
			IF XiTpoMov = 1
				DO CHECKDOC  && *** FILTRA MOVIMIENTOS DEL MES ***
			ENDIF
			DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar AND !EOF()
				IF !&LsFor1
					SELECT RMOV
					SKIP
					LOOP
				ENDIF
*!*				        SELECT temporal
*!*				         APPEND BLANK
*!*				         Replace codcta WITH Rmov.CodCta 
*!*				         replace Obser WITH '0'        
			    SELECT RMOV 
				DO CASE
					CASE XiTpoMov = 1
						IF NroMes = XsNroMes
							IF XsTipRep=1
								DO LinImp
							ELSE
								DO LinImp1
							ENDIF
						ELSE
							SKIP
						ENDIF
					CASE XiTpoMov = 2
						IF NroMes <= XsNroMes
							IF XsTipRep=1
								DO LinImp
							ELSE
								DO LinImp1
							ENDIF
						ELSE
							SKIP
						ENDIF
				ENDCASE
				Cancelar = ( INKEY() = k_esc )
			ENDDO
			IF ! Cancelar .AND. L2NumItm > 0
				L2SalAct = L2Cargos - L2Abonos
				IF !LsCtas
					NumLin = PROW()
					IF XsTipRep=1
						IF L2SalAct >= 0
*!*								@ NumLin ,137 SAY L2SalAct  PICTURE "99,999,999.99"
						ELSE
*!*								@ NumLin ,137 SAY -L2SalAct PICTURE "99,999,999.99-"
						ENDIF
					ELSE
						IF L2SalAct >= 0
*!*								@ NumLin ,91 SAY L2SalAct  PICTURE "99,999,999.99"
						ELSE
*!*								@ NumLin ,91 SAY -L2SalAct PICTURE "99,999,999.99-"
						ENDIF
					ENDIF
					NumLin = PROW()+1
*!*						@ NumLin,0 SAY REPLICATE(".",Ancho) 
				ENDIF
				L1NumItm = L1NumItm + 1
				L1Cargos = L1Cargos + L2Cargos
				L1Abonos = L1Abonos + L2Abonos
				** VETT  06/12/2012 01:16 PM : Total x Documento 
				IF L2NumItm>1
		         	SELECT temporal
				 	APPEND BLANK
				 	=generasecuencia(0,'005',ALIAS())
				 	REPLACE CodCta WITH CTAS.CodCta
				 	replace CodAux WITH LsCodAux
	*!*				 	replace NroDoc WITH LsNroDoc
				 	replace GLODOC WITH PADC("*** TOTAL DOCUMENTO: " + LsNroDoc,LEN(GloDoc))
				 	replace Debe WITH L2Cargos
				 	Replace Haber WITH L2Abonos
				 	replace Saldo WITH L2Cargos -	L2Abonos		 
				 	** VETT: ** Linea separadora en blanco  2021/12/10 10:00:42 ** 
				 	APPEND BLANK
					replace CodCta WITH LsCodCta
					replace CodAux WITH LsCodAux
					** VETT:   2021/12/10 10:00:42 **  		 
			 	ENDIF
			 	SELECT rmov
			 	** VETT  06/12/2012 01:45 PM : Fin 
			 	IF LSNroDoc='0010000451'
*!*						SET STEP ON 			 	
			 	ENDIF
			ENDIF
		ENDDO
			IF ! Cancelar .AND. L1NumItm > 0
				NumLin = PROW()+1
				L1SalAct = L1Cargos - L1Abonos
				IF XsTipRep=1
	*!*					@ NumLin,56 SAY "** TOTAL "+LsCodAux+" **"
					IF L1Cargos >= 0
	*!*						@ NumLin ,111 SAY L1Cargos  PICTURE "9,99,999.99"
					ELSE
	*!*						@ NumLin ,111 SAY -L1Cargos PICTURE "9,99,999.99-"
					ENDIF
				ELSE
	*!*					@ NumLin,35 SAY "** TOTAL "+LsCodAux+" **"
					IF L1Cargos >= 0
	*!*						@ NumLin ,65 SAY L1Cargos  PICTURE "9,999,999.99"
					ELSE
	*!*						@ NumLin ,65 SAY -L1Cargos PICTURE "9,999,999.99-"
					ENDIF
				ENDIF
				IF XsTipRep=1
					IF L1Abonos >= 0
	*!*						@ NumLin ,124 SAY L1Abonos  PICTURE "9,999,999.99"
					ELSE
	*!*						@ NumLin ,124 SAY -L1Abonos PICTURE "9,999,999.99-"
					ENDIF
				ELSE
					IF L1Abonos >= 0
	*!*						@ NumLin ,79 SAY L1Abonos  PICTURE "9,999,999.99"
					ELSE
	*!*						@ NumLin ,79 SAY -L1Abonos PICTURE "9,999,999.99-"
					ENDIF
				ENDIF
				IF XsTipRep=1
					IF L1SalAct >= 0
	*!*						@ NumLin ,137 SAY L1SalAct  PICTURE "99,999,999.99"
					ELSE
	*!*						@ NumLin ,137 SAY -L1SalAct PICTURE "99,999,999.99-"
					ENDIF
				ELSE
					IF L1SalAct >= 0
	*!*						@ NumLin ,91 SAY L1SalAct  PICTURE "99,999,999.99"
					ELSE
	*!*						@ NumLin ,91 SAY -L1SalAct PICTURE "99,999,999.99-"
					ENDIF
				ENDIF
				** VETT  06/12/2012 01:40 PM : Total x Auxiliar 
				SELECT temporal
	            APPEND BLANK
	            =generasecuencia(0,'006',ALIAS())
	            REPLACE CodCta WITH CTAS.CodCta
	            replace GloDoc WITH PADC("** TOTAL "+LsCodAux+" **",LEN(GloDoc))
	            replace CodAux WITH LsCodAux
			 	replace Debe WITH L1Cargos
			 	Replace Haber WITH L1Abonos
			 	replace Saldo WITH L1SalAct
				** VETT: ** Linea separadora en blanco  2021/12/10 10:00:42 ** 
				APPEND BLANK
				replace CodCta WITH LsCodCta
				replace CodAux WITH LsCodAux
				** VETT:   2021/12/10 10:00:42 **  	
			 	SELECT rmov
			 	** VETT  06/12/2012 01:45 PM : Fin 
				NumLin = PROW()+1
	*!*				@ NumLin,0 SAY REPLICATE("-",Ancho)
				L0NumItm = L0NumItm + 1
				L0Cargos = L0Cargos + L1Cargos
				L0Abonos = L0Abonos + L1Abonos
			ENDIF
		ENDDO
*!*			SET STEP ON 
		IF ! Cancelar .AND. LaNumItm > 0 AND  LsCtas && AND LsUltCta<>RMOV.CodCta
			NumLin = PROW()+1
			LaSalAct = LaCargos - LaAbonos
			IF XsTipRep=1
*!*					@ NumLin,56 SAY "** TOTAL CUENTA "+LsUltCta+" **"
				IF LaCargos >= 0
*!*						@ NumLin ,111 SAY LaCargos       PICTURE "9,999,999.99"
				ELSE
*!*						@ NumLin ,111 SAY -LaCargos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaAbonos >= 0
*!*						@ NumLin ,124 SAY LaAbonos       PICTURE "9,999,999.99"
				ELSE
*!*						@ NumLin ,124 SAY -LaAbonos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaSalAct >= 0
*!*						@ NumLin ,137 SAY LaSalAct       PICTURE "99,999,999.99"
				ELSE
*!*						@ NumLin ,137 SAY -LaSalAct      PICTURE "99,999,999.99-"
				ENDIF
				NumLin = PROW()+1
*!*					@ NumLin,0 SAY REPLICATE("-",Ancho)
			ELSE
*!*					@ NumLin,35 SAY "** TOTAL CUENTA "+LsUltCta+" **"
				IF LaCargos >= 0
*!*						@ NumLin ,65 SAY LaCargos       PICTURE "9,999,999.99"
				ELSE
*!*						@ NumLin ,65 SAY -LaCargos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaAbonos >= 0
*!*						@ NumLin ,79 SAY LaAbonos       PICTURE "9,999,999.99"
				ELSE
*!*						@ NumLin ,79 SAY -LaAbonos      PICTURE "9,999,999.99-"
				ENDIF
				IF LaSalAct >= 0
*!*						@ NumLin ,91 SAY LaSalAct       PICTURE "99,999,999.99"
				ELSE
*!*						@ NumLin ,91 SAY -LaSalAct      PICTURE "99,999,999.99-"
				ENDIF
				NumLin = PROW()+1
*!*					@ NumLin,0 SAY REPLICATE("-",Ancho)
			ENDIF
			** VETT  06/12/2012 01:40 PM : Total x Auxiliar 
			SELECT temporal
	        APPEND BLANK
	        =generasecuencia(0,'007',ALIAS())
	        replace CodCta WITH CTAS.CodCta
	        replace GLODOC WITH PADC("** TOTAL CUENTA "+LsUltCta+" **",LEN(GloDoc))
		 	replace Debe WITH LaCargos
		 	Replace Haber WITH LaAbonos
		 	replace Saldo WITH LaSalAct
		 	** VETT: ** Linea separadora en blanco  2021/12/10 10:00:42 ** 
		 	APPEND BLANK
			replace CodCta WITH LsCodCta
			replace CodAux WITH LsCodAux
			** VETT:   2021/12/10 10:00:42 **  	

		 	** VETT  06/12/2012 01:45 PM : Fin 
		 	SELECT rmov
		ENDIF
	
	IF ! Cancelar .AND. L0NumItm > 0
		NumLin = PROW()+1
*!*			@ NumLin,0 SAY REPLICATE("=",Ancho)
		NumLin = PROW()+1
		L0SalAct = L0Cargos - L0Abonos
		IF XsTipRep=1
*!*				@ NumLin,56 SAY "*  TOTAL GENERAL *"
			IF L0Cargos >= 0
*!*					@ NumLin ,111 SAY L0Cargos       PICTURE "99999999.99"
			ELSE
*!*					@ NumLin ,111 SAY -L0Cargos      PICTURE "99999999.99-"
			ENDIF
			IF L0Abonos >= 0
*!*					@ NumLin ,124 SAY L0Abonos       PICTURE "99999999.99"
			ELSE
*!*					@ NumLin ,124 SAY -L0Abonos      PICTURE "99999999.99-"
			ENDIF
			IF L0SalAct >= 0
*!*					@ NumLin ,137 SAY L0SalAct       PICTURE "99999,999.99"
			ELSE
*!*					@ NumLin ,137 SAY -L0SalAct      PICTURE "99999,999.99-"
			ENDIF
		ELSE
*!*				@ NumLin,35 SAY "*  TOTAL GENERAL *"
			IF L0Cargos >= 0
*!*					@ NumLin ,65 SAY L0Cargos       PICTURE "9,999,999.99"
			ELSE
*!*					@ NumLin ,65 SAY -L0Cargos      PICTURE "9,999,999.99-"
			ENDIF
			IF L0Abonos >= 0
*!*					@ NumLin ,79 SAY L0Abonos       PICTURE "9,999,999.99"
			ELSE
*!*					@ NumLin ,79 SAY -L0Abonos      PICTURE "9,999,999.99-"
			ENDIF
			IF L0SalAct >= 0
*!*					@ NumLin ,91 SAY L0SalAct       PICTURE "99,999,999.99"
			ELSE
*!*					@ NumLin ,91 SAY -L0SalAct      PICTURE "99,999,999.99-"
			ENDIF
		ENDIF
		SELECT temporal
        APPEND BLANK
        =generasecuencia(0,'008',ALIAS())
*!*	        replace CodCta WITH CTAS.CodCta
        replace GLODOC WITH PADC("** TOTAL GENERAL "+" **",LEN(GloDoc))
	 	replace Debe WITH L0Cargos
	 	Replace Haber WITH L0Abonos
	 	replace Saldo WITH L0SalAct
	 	** VETT  06/12/2012 01:45 PM : Fin 
	 	SELECT rmov
	ENDIF
*!*		EJECT PAGE
*!*	ENDPRINTJOB
*!*	SET DEVICE TO SCREEN
SELECT TEMPORAL 
LOCATE
*!*	XTipRep = 'XLS'
*!*	DO F0PRFIN
*!*	RELEASE xTipRep
RETURN
****************
PROCEDURE LinImp
****************
*!*	IF NumPag = 0 .OR. PROW() > LinFin
*!*		DO RESETPAG
	IF Cancelar
		EXIT
	ENDIF
*!*	ENDIF
IF LsQuiCta AND lsCtas
	LsQuiCta=.f.
	NumLin = PROW()+1
*!*		@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
	** VETT  06/12/2012 06:05 PM : Auxiliar
	 SELECT Temporal
	 APPEND blank
	 =generasecuencia(0,'001',ALIAS())
	 replace CodCta  WITH CTAS.CodCta
     replace CodAux WITH LsCodAux
     replace Glodoc WITH CODCTA+[ ]+CTAS.NomCta
 	 SELECT RMOV
 	 ** VETT  06/12/2012 06:05 PM : Fin 

ENDIF
IF Quiebre1
	Quiebre1 = .F.
	NumLin = PROW()+1
*!*		@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
	** VETT  06/12/2012 06:05 PM : Auxiliar
	 SELECT Temporal
	 APPEND BLANK
	 =generasecuencia(0,'002',ALIAS())
	 	replace Codcta WITH CTAS.CodCta
	    replace CodAux WITH LsCodAux
	    replace NomAux WITH AUXI->NomAux
	    replace RucAux WITH AUXI->RucAux
	    replace GloDoc WITH AUXI->RucAux+[ ]+AUXI->NomAux

 	 SELECT RMOV
 	 ** VETT  06/12/2012 06:05 PM : Fin 
ENDIF
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
LsObs=""
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = IIF(EMPTY(FchDoc),DTOC(FchAst),DTOC(FchDOC))
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,4)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsTipRef = TipRef
LsNroRef = NroRef
LdFchRef = FchRef
LsCodDoc = CodDoc
LsFchDoc = FchDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,4)
LdFchVto = FchVto
LsFchPed = DTOC(FchPed)
LsFchPed = LEFT(LsFchPed,2)+SUBSTR(LsFchPed,4,2)+RIGHT(LsFchPed,4)
LsGloDoc = GloDoc
LnCodMon = CodMon
LfTpoCmb	= TpoCmb
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF() ;
	.AND. CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc
	IF !&LsFor1
		SELECT RMOV
		SKIP
		LOOP
	ENDIF

	DO CALIMP
	DO CASE
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa + ImpUsa
			ENDIF
		OTHERWISE
			Abonos = Abonos + nIMPORT
			***-------------------------****
			LsObs=Captura_Obs() 
			***-------------------------****
			IF LiCodMon = 2
				SdoUsa = SdoUsa - ImpUsa
			ENDIF
	ENDCASE
	NumItm = NumItm + 1
	SKIP
ENDDO
IF NumItm > 1
	LsCodRef = TRIM(LsCodRef)+"*"
ENDIF
NumLin = PROW()+1

*!*	@ NumLin , 0  SAY LsFchAst
*!*	@ NumLin , 9  SAY LsCodOpe
*!*	@ NumLin , 13 SAY LsNroMes+"-"+LsNroAst
*!*	@ NumLin , 25 SAY LsNroDoc
*!*	@ NumLin , 40 SAY LsNroRef
IF ! EMPTY(LsFchVto)
*!*		@ NumLin , 51 SAY LsFchVto
ENDIF
*!*	@ numlin,  60 say lsfchped
*!*	@ NumLin , 69 SAY LsGloDoc        PICTURE "@S27"

IF SdoUsa >= 0
*!*		@ NumLin ,97  SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
*!*		@ NumLin ,97  SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
*!*		@ NumLin ,111 SAY Cargos       PICTURE "9,999,999.99"
ELSE
*!*		@ NumLin ,111 SAY -Cargos      PICTURE "9,999,999.99-"
ENDIF
IF Abonos >= 0
*!*		@ NumLin ,124 SAY Abonos       PICTURE "9,999,999.99"
ELSE
*!*		@ NumLin ,124 SAY -Abonos      PICTURE "9,999,999.99-"
ENDIF
*!*	@ Numlin, 150 SAY LsObs
**------------------------**
SELECT Temporal
APPEND blank
=generasecuencia(0,'004',ALIAS())
replace Codcta WITH RMOV.CodCta
replace CodDoc WITH LsCodDoc
replace NroDoc WITH LsNroDoc
replace TipRef WITH LsTipRef
replace NroRef WITH LsNroRef
replace FchRef	WITH LdFchRef
replace FchDoc WITH LsFchDoc
replace NroAst WITH LsNroAst
Replace NroMes WITH LsNroMes
replace GloDoc WITH LsGloDoc
replace CodOpe WITH LsCodOpe
replace codmon WITH LnCodmon
replace TpoCmb WITH LfTpoCmb
*!*	replace Impusa WITH LsImpusa
replace CodAux WITH LsCodAux
replace RucAux WITH AUXI->RucAux
replace NomAux WITH AUXI->NomAux
replace FchAst WITH RMOV.FchAst
replace FchVto		WITH LdFchVto
replace SdoUsa		WITH SdoUsa 
replace Debe	WITH Cargos
replace Haber    WITH Abonos
replace Obser    WITH TRIM(LsObs)
SELECT RMOV
**-----------------------------------**

L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
**
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
**
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
return
******************
PROCEDURE ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
	Inicio  = .F.
	DO F0MBPRN 
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
******************
PROCEDURE CHECKDOC
******************
RegAct = RECNO()
SalAct = 0
UltMes = "  "
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc  AND !EOF() .AND. ! Cancelar
	IF !&LsFor1
		SELECT RMOV
		SKIP
		LOOP
	ENDIF

	IF NROMES <= XsNroMes
		UltMes = NroMes
		DO CALIMP
		IF TpoMov = "D"
			SalAct = SalAct + nIMPORT
		ELSE
			SalAct = SalAct - nIMPORT
		ENDIF
	ENDIF
	SKIP
ENDDO
IF SalAct <> 0 .OR. UltMes = XsNroMes
	Goto RegAct
ENDIF
RETURN

*****************
PROCEDURE LinImp1
*****************
*!*	IF NumPag = 0 .OR. PROW() > LinFin
*!*		DO RESETPAG
	IF Cancelar
		EXIT
	ENDIF
*!*	ENDIF
IF LsQuiCta AND lsCtas
	LsQuiCta=.f.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
ENDIF
IF Quiebre1
	Quiebre1 = .F.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
LsObs=""
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = IIF(EMPTY(FchDoc),DTOC(FchAst),DTOC(FchDOC))
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,4)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,4)
LsFchPed = DTOC(FchPed)
LsFchPed = LEFT(LsFchPed,2)+SUBSTR(LsFchPed,4,2)+RIGHT(LsFchPed,4)
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
	LsGloDoc = VMOV->NotAst
ENDIF
DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF() ;
	.AND. CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc
	IF !&LsFor1
		SELECT RMOV
		SKIP
		LOOP
	ENDIF

	DO CALIMP
	DO CASE
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa + ImpUsa
			ENDIF
		OTHER
			Abonos = Abonos + nIMPORT
			IF LiCodMon = 2
				SdoUsa = SdoUsa - ImpUsa
			ENDIF
	ENDCASE
	NumItm = NumItm + 1
	SKIP
ENDDO
IF NumItm > 1
	LsCodRef = TRIM(LsCodRef)+"*"
ENDIF
NumLin = PROW()+1

@ NumLin , 0  SAY LsFchAst
@ NumLin , 9  SAY LsCodOpe
@ NumLin , 13 SAY LEFT(VMOV->NroAst,2)+"-"+SUBSTR(VMOV->NroAst,3,2)+"/"+SUBSTR(VMOV->NroAst,5,4)
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 40 SAY LsNroRef

IF SdoUsa >= 0
	@ NumLin ,51  SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
	@ NumLin ,51  SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
	@ NumLin ,65 SAY Cargos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,65 SAY -Cargos      PICTURE "9,999,999.99-"
ENDIF
IF Abonos >= 0
	@ NumLin ,79 SAY Abonos       PICTURE "9,999,999.99"
ELSE
	@ NumLin ,79 SAY -Abonos      PICTURE "9,999,999.99-"
ENDIF
@ Numlin, 105 SAY LsObs
L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
**
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
**
RETURN
*********************
FUNCTION Captura_Obs
********************* 
IF !(Ll_Liqui_C AND Ll_Liqui_D)
	RETURN ""
ENDIF 
LOCAL LnSelect
IF VARTYPE(LsObs)<>'C'
	LsObs = ""
ENDIF 
LnSelect=SELECT()
IF !USED('L_C_Cobr')
	RETURN ""
ENDIF
IF !USED('L_D_Cobr')
	RETURN ""
ENDIF
DO CASE
	CASE CODCTA='12' AND TpoMov = "H"
		IF rmov.COdOpe='010' AND (RMOV.NroAst>='09000004' AND RMOV.NroAst>='09000012') 
*!*				SET STEP ON 
		ENDIF 
		LsCodDoc=RMOV.CodDoc
		LsNroDoc=RMOV.NroDOc
		SELECT L_C_Cobr
		=SEEK(LEFT(DTOS(RMOV.FchAst),6)+RMOV.CodOpe+RMOV.NroAst,"L_C_Cobr")
		LsLiqui = Liqui
		SELECT L_D_Cobr
		SEEK ALLTRIM(LsCodDoc+PADR(LsNroDoc,LEN(L_d_Cobr.nrodoc))+LsLiqui)
		LsObs = Obs		
ENDCASE
SELECT (LnSelect)
RETURN LsObs
************************
FUNCTION GeneraSecuencia
************************
PARAMETERS PnRecno,PsTipo,PsCursor
SELECT (PsCursor)
IF PnRecno=0

ENDIF
IF VARTYPE(PsTipo)<>'C'
	PsTipo='000'
ENDIF
PnRecno=RECNO(PsCursor)
*!*	SELECT COUNT(*) + 1 as Item FROM (PsCursor) INTO CURSOR xxTemp
LsSecuencia=TRANSFORM(PnRecno,"@L 9999999")+PsTipo

RETURN LsSecuencia
