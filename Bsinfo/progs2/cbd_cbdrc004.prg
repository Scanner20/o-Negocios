#INCLUDE CONST.H
*** TF : TIPO DE FORMATO
*** TI : TIPO DE IMPRESION
PRIVATE TF,TI
PUBLIC TdCargos,TdAbonos,TdSalAct
STORE 1 TO TF,TI
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV06','')
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
goentorno.open_dbf1('ABRIR','CCBMVTOS','CMOV','VTOS03','')
goentorno.open_dbf1('ABRIR','CCBSALDO','SLDO','SLDO01','')
goentorno.open_dbf1('ABRIR','CCBRGDOC','GDOC','GDOC01','')

cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "SALDOS PENDIENTES"
UltTecla = 0
INC = 0   && SOLES
*** EXCLUIMOS LOS MOVIMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV
**********************************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XsNomCta = SPACE(LEN(CTAS.NomCta))
XiGenCtaCob = 1
UltTecla = 0
i        = 1
XlGenCtaCob =  INLIST(UPPER(GoEntorno.User.Login),'VETT','VICTOR') 
XlGenCtaCob = .F.

DO FORM cbd_cbdrc004
RETURN

******************
PROCEDURE Imprimir
******************

DO F0PRINT
IF UltTecla = K_Esc
	RETURN
ENDIF
DIMENSION vCodCta(20,2)
NumEle = 0
MaxEle = 20
*** Buscando las cuentas que selecciona el auxiliar ***
SELECT CTAS
SEEK XsCodCta
XsNomCta = TRIM(NomCta)
SET ORDER TO CTAS03
SEEK "SS"+XsClfAux
DO WHILE AftMov+PidAux+ClfAux = "SS"+XsClfAux
   IF CodCta = TRIM(XsCodCta)         &&   .AND. ! INLIST(CodCta,"12101")
      IF NumEle = MaxEle
         MaxEle = MaxEle + 10
         DIMENSION vCodCta(MaxEle,2)
      ENDIF
      NumEle = NumEle + 1
      vCodCta(NumEle,1) = CodCta
      vCodCta(NumEle,2) = NomCta
   ENDIF
   SKIP
ENDDO
IF NumEle = 0
	WAIT WINDOW "No existen cuentas asignadas a este auxiliar"
	RETURN
ENDIF
SET ORDER TO CTAS01
***** Registro de inicio de Impresión ******
SELECT AUXI
Llave = XsClfAux+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
   WAIT WINDOW "No existen registros a listar"
   RETURN
ENDIF

IniImp   = _Prn8a+_Prn2    && 12   cpi
Ancho    = 118
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = ""
SubTitulo= ""
EN1    = "CUENTA PENDIENTES AL "+DTOC(GdFecha)
EN2    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
EN3    = ""
EN4    = ""
En5    = ""
En6 = "****** ************** **************** **************** ********** ********** ********** ******** ******************** ***"
En7 = "CODIGO    REFE-                                         FECHA      FECHA        COMPROBANTE                            OR "
En8 = "DE CTA   RENCIA         D E B I T O     C R E D I T O   DCTO.      VCTO.      FECHA      NRO.        G  L  O  S  A     IG "
En9 = "****** ************** **************** **************** ********** ********** ********** ******** ******************** ***"
En6 = ""
En7 = "****************** ***************** ***************** ************** *********** ********** ********************* ****"
En8 = "  REFERENCIA         D E B I T O      C R E D I T O      FECHA DOC.    FECHA VTO.  ASIENTO    G  L  O  S  A        OPE."
En9 = "****************** ***************** ***************** ************** *********** ********** ********************* ****"

*      0      7              22               39               56         67         78         89       98                   119
*      0          1         2         3         4         5         6         7         8         9        10        11         
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901


*          1         2         3         4         5         6         7         8         9
*01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
******* ********** **************** **************** ******** ******** ****** ******************** ***"
*CODIGO    REFE-                                      FECHA    COMPROBANTE                         OR "
*DE CTA   RENCIA      D E B I T O     C R E D I T O   DCTO.    FECHA    NRO.    G  L  O  S  A      IG "
******* ********** **************** **************** ******** ******** ****** ******************** ***"
*12345  1234567890 9999,999,999.99- 9999,999,999.99- 99/99/99 99/99/99 123456 12345678901234567890 123
 * T O T A L *     ---------------- ---------------- *   S A L D O   *
** POR CTA         9999,999,999.99- 9999,999,999.99-  9999,999,999.99-
 * T O T A L *     ---------------- ---------------- *   S A L D O   *
** AUXILIAR        9999,999,999.99- 9999,999,999.99-  9999,999,999.99-

Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

** VETT  17/05/2016 02:05 AM : imprime totales cuando no hay movimientos para mostrar a Sunat 
IF GsSigCia='TYJ' and GsCodCia='003'
	TI=2
ENDIF

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   Inicio   = .T.
   DO WHILE ClfAux+CodAux = Llave .AND. ! Cancelar
      **** Quiebre por Auxiliar ****
      LsCodAux = CodAux
      SET DEVICE TO SCREEN
      EN3    = TRIM(CodAux)+" "+TRIM(NOMAUX)
*      @ 24,0 SAY PADC(EN3,80)
      SET DEVICE TO PRINT
      ** VETT  17/05/2016 02:05 AM : imprime totales cuando no hay movimientos para mostrar a Sunat 
      
      IF TI=2
         Inicio   = .T.
      ELSE
         EN3 = []
      ENDIF
      L1NumItm = 0
      L1Cargos = 0
      L1Abonos = 0
      Quiebre1 = .T.
      *** Buscando las cuentas que selecciona el auxiliar ***
      Cancelar = ( INKEY() = k_esc )
      FOR Item = 1 TO NumEle
         LsCodCta = vCodCta(Item,1)
         LsNomCta = vCodCta(Item,2)
         L2NumItm = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         *** Buscando Movimientos para el auxiliar seleccionado ***
         SELECT RMOV
         SEEK LsCodCta+LsCodAux
         DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
            **** Quiebre por Documento ****
            LsNroDoc = NroDoc
            L3NumItm = 0
            L3Cargos = 0
            L3Abonos = 0
            Quiebre3 = .T.
            DO CHECKDOC
            DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
	             SELECT temporal
		         APPEND BLANK
		         Replace codcta WITH Rmov.CodCta         
		         SELECT RMOV
	               IF NROMES <= XsNroMes
					DO LinImp
	               ELSE
	               	SKIP
	               ENDIF
	               Cancelar = ( INKEY() = k_esc )
            ENDDO
            IF ! Cancelar && .AND. L3NumItm > 0
               L2NumItm = L2NumItm + 1
               L2Cargos = L2Cargos + L3Cargos
               L2Abonos = L2Abonos + L3Abonos
            ENDIF
                && Saldo Por Documento
	         IF TdSalAct<>0 THEN 
	         		SELECT temporal
			 	APPEND BLANK
			 	replace CodAux WITH LsCodAux
			 	replace NomAux WITH "*** TOTAL DOCUMENTO : " + LsNroDoc
			 	replace Debe WITH TdCargos
			 	Replace Haber WITH TdAbonos
			 	replace Saldo WITH TdSalAct			 		 
			 	SELECT rmov
		 	ENDIF 
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
	           DO RESETPAG
	           L2SalAct = L2Cargos - L2Abonos
	           NumLin = PROW() + 2
               IF GsSigCia='TYJ' and GsCodCia='003'
	           		@ NumLin,0   SAY " * T O T A L  C U E N T A *     ---------------------> *   S A L D O   *"
	           ELSE
	           		@ NumLin,0   SAY " * T O T A L *     -----------------  ---------------- *   S A L D O   *"	
	           ENDIF 
      	       SELECT temporal
	           APPEND BLANK
	           replace NomAux WITH "'---- TOTAL AUXILIAR  ------------------------->"
	            NumLin = PROW() + 1
                ** VETT  17/05/2016 02:05 AM : imprime totales cuando no hay movimientos para mostrar a Sunat 
	            @ NumLin,0   SAY IIF(GsSigCia='TYJ' and GsCodCia='003',LsCodCta+' '+LsNomCta,"** POR CTA")
	            IF GsSigCia='TYJ' and GsCodCia='003'
	            ELSE
		            IF L2Cargos >= 0
		            		replace debe WITH L2Cargos
			               @ NumLin ,21  SAY L2Cargos       PICTURE "9999,999,999.99"
		            ELSE
		            		replace debe WITH -L2Cargos
		       	        @ NumLin ,21  SAY -L2Cargos      PICTURE "9999,999,999.99-"
		            ENDIF
		            IF L2Abonos >= 0
		            		replace haber WITH L2Abonos
		               	@ NumLin ,39  SAY L2Abonos       PICTURE "9999,999,999.99"
		            ELSE
					replace haber WITH -L2Abonos
		               	@ NumLin ,39  SAY -L2Abonos      PICTURE "9999,999,999.99-"
		            ENDIF
	            ENDIF
	            IF L2SalAct >= 0
	               	@ NumLin ,57  SAY L2SalAct       PICTURE "9999,999,999.99"
	               	replace saldo WITH L2SalAct
	            ELSE
	               	@ NumLin ,57  SAY -L2SalAct      PICTURE "9999,999,999.99-"
	               	replace saldo WITH -L2SalAct
	            ENDIF
	            SELECT RMOV
	            NumLin = PROW() + 1
	            @ NumLin,0 SAY []
	            L1NumItm = L1NumItm + 1
	            L1Cargos = L1Cargos + L2Cargos
	            L1Abonos = L1Abonos + L2Abonos
         ENDIF
         IF Cancelar
	            EXIT
         ENDIF
      NEXT
      IF ! Cancelar .AND. L1NumItm > 0
         NumLin = PROW()+2
         L1SalAct = L1Cargos - L1Abonos
         IF GsSigCia='TYJ' and GsCodCia='003'
    	     @ NumLin,0  SAY " * T O T A L   A U X I L I A R  ---------------------> *   S A L D O   *"
         ELSE
	         @ NumLin,0  SAY " * T O T A L *     -----------------  ---------------- *   S A L D O   *"
         ENDIF
         NumLin = PROW()+1
         ** VETT  17/05/2016 02:05 AM : imprime totales cuando no hay movimientos para mostrar a Sunat 
         @ NumLin,0   SAY IIF(GsSigCia='TYJ' and GsCodCia='003',LsCodAux+' '+PADR(AUXI.NomAux,40),"** AUXILIAR")  
         IF GsSigCia='TYJ' and GsCodCia='003'
         ELSE
	         IF L1Cargos >= 0
	            @ NumLin , 21 SAY L1Cargos       PICTURE "9999,999,999.99"
	         ELSE
	            @ NumLin , 21 SAY -L1Cargos      PICTURE "9999,999,999.99-"
	         ENDIF
	         IF L1Abonos >= 0
	            @ NumLin , 39 SAY L1Abonos       PICTURE "9999,999,999.99"
	         ELSE
	            @ NumLin , 39 SAY -L1Abonos      PICTURE "9999,999,999.99-"
	         ENDIF
	     ENDIF    
         IF L1SalAct >= 0
            @ NumLin , 57 SAY L1SalAct       PICTURE "9999,999,999.99"
         ELSE
            @ NumLin , 57 SAY -L1SalAct      PICTURE "9999,999,999.99-"
         ENDIF
         NumLIn = PROW() + 1
         @ NumLin,00 SAY [ ]
      ENDIF
      SELECT AUXI
      SKIP
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
SELECT TEMPORAL 
LOCATE
XTipRep = 'XLS'
DO F0PRFIN &&IN ADMPRINT
RELEASE xTipRep
RETURN
**********************************************************************
PROCEDURE LinImp
****************
DO RESETPAG
IF TI = 1
   NumLin = PROW() + 1
   DO RESETPAG
	IF Quiebre1
      		Quiebre1 = .F.
      		NumLin = PROW()+1
      		@ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
              SELECT Temporal
	       replace CodAux WITH LsCodAux
	       replace NomAux WITH AUXI->NomAux
	       replace RucAux WITH AUXI->RucAux
	*!*	      replace AuxRuc WITH AUXI->RucAux
	*!*	      replace RucAux WITH AUXI->RucAux
	      SELECT Rmov
	      NumLin = PROW()+1
	ELSE
	      NumLin = PROW()
	ENDIF
ENDIF
SELECT Temporal
replace CodDoc WITH Rmov.CodDoc
replace NroDoc WITH Rmov.NroDoc
SELECT Rmov
@ NumLin , 0  SAY CodDoc
@ NumLin , 6  SAY NroDoc
DO CALIMP
DO CASE
   CASE TpoMov = "D"
       Cargos = nIMPORT
       Abonos = 0
   OTHER
       Cargos = 0
       Abonos = nIMPORT
ENDCASE
SELECT Temporal
IF Cargos >= 0
   @ NumLin ,21  SAY Cargos       PICTURE "@Z 9999,999,999.99"
	replace Debe WITH Cargos
ELSE
   @ NumLin ,21  SAY -Cargos      PICTURE "@Z 9999,999,999.99-"
      replace Debe WITH -Cargos
ENDIF
IF Abonos >= 0
   @ NumLin ,39  SAY Abonos       PICTURE "@Z 9999,999,999.99"
     replace Haber WITH Abonos
ELSE
   @ NumLin ,39  SAY -Abonos      PICTURE "@Z 9999,999,999.99-"
     replace Haber WITH -Abonos
ENDIF
replace FchDoc WITH Rmov.FchDoc
replace NroAst WITH Rmov.NroAst
Replace NroMes WITH Rmov.NroMes
replace GloDoc WITH Rmov.GloDoc
replace CodOpe WITH Rmov.CodOpe
replace codmon WITH Rmov.Codmon
replace TpoCmb WITH Rmov.TpoCmb
replace Impusa WITH Rmov.Impusa
replace CodAux WITH LsCodAux
replace RucAux WITH AUXI->RucAux
replace NomAux WITH AUXI->NomAux
replace FchVto		WITH RMOV.FchVto
SELECT Rmov
@ NumLin ,57  SAY FchDoc
@ NumLin ,71  SAY FchVto
@ NumLin ,82  SAY NroAst
@ NumLin ,94  SAY GloDoc PICT "@S20"
@ NumLin ,116 SAY CodOpe
NumLin = PROW()+1    && Linea en blanco
@ NumLin ,0   SAY []
L3NumItm = L3NumItm + 1
L3Cargos = L3Cargos + Cargos
L3Abonos = L3Abonos + Abonos
SKIP
RETURN
****************
PROCEDURE CalImp
****************
nImport = IIF(XiCodMon=1,Import,ImpUsa)
RETURN
******************
PROCEDURE ResetPag
******************
IF PROW()>=LinFin .OR. NumPag = 0 .OR. Inicio
	Inicio  = .F.
	DO F0MBPRN &&IN ADMPRINT
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
******************
PROCEDURE CHECKDOC
******************
RegAct   = RECNO()
NumItm   = 0
Cargos   = 0
Abonos   = 0

SCATTER NAME oRmov BLANK 
SCATTER NAME oCancel BLANK 
SCATTER NAME oLetra BLANK 
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
	DO CALIMP
	DO CASE
		CASE NroMes > XsNroMes
		CASE TpoMov = "D"
			Cargos = Cargos + nIMPORT
			IF CodCta='121' AND CodOpe='002'
				SCATTER NAME oRmov 
			ENDIF
				
			IF CodCta='123' AND CodOpe='021'
				IF EMPTY(oLetra.NroDoc)
					SCATTER NAME oLetra 
				ELSE
					IF XiCodMon =1
						oLetra.Import = oLetra.Import + Import
					ELSE
						oLetra.ImpUsa = oLetra.ImpUsa + ImpUsa						
					ENDIF		
				ENDIF	
			ENDIF
		OTHER
			Abonos = Abonos + nIMPORT
			IF CodCta='12'
				=SEEK(CodOpe,'OPER')
				IF !('DIF.CMB'$UPPER(OPER.Siglas) OR 'DIF.CAMBIO'$UPPER(OPER.Siglas))
					IF EMPTY(oCancel.CodCta)
						SCATTER NAME oCancel 
					ELSE
						IF XiCodMon =1
							oCancel.Import = oCancel.Import + Import
						ELSE
							oCancel.ImpUsa = oCancel.ImpUsa + ImpUsa						
						ENDIF		
	 				ENDIF	
				ENDIF	
			ENDIF
			
	ENDCASE
	SKIP
ENDDO
SalAct = Cargos - Abonos
TdCargos=Cargos
TdAbonos=Abonos
TdSalAct = TdCargos - TdAbonos

=GenCancelaCTaCob(oRmov,oCancel,oLetra,SalAct)
RELEASE oRmov,oCancel,oLetra
IF SalAct <> 0
	Goto RegAct
ENDIF
RETURN
*************************
FUNCTION GenCancelaCtaCob
*************************
LPARAMETERS oRmov,oCancel,oLetra,LnSalAct
IF !XlGenCtaCob
	RETURN 
ENDIF
LsArea_act = SELECT()
PRIVATE XsTpoDoc,XsCodDoc,XsNroDoc
XsTpoDoc='CARGO'
DO CASE 
	CASE oRmov.CodCta = '121'
		DO CASE 
			CASE oRmov.CodDoc='01'
				XsCodDoc = 'FACT'
			CASE oRmov.CodDoc='03'
				XsCodDoc = 'BOLE'
		ENDCASE
	CASE oRmov.CodCta = '123'
		XsCodDoc = 'LETR'
ENDCASE 
IF EMPTY(oRmov.CodDoc)
	RETURN
ENDIF
IF EMPTY(oCancel.NroDoc)
	RETURN 
ENDIF
XsNroDoc = PADR(oCancel.NroDoc,LEN(GDOC.NroDoc))

SELECT GDOC
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
IF !FOUND() AND XsCodDoc='LETR'
	** Creamos el canje y la letra **
		
	
ENDIF

IF !FOUND()
	SELECT (LsArea_Act)
	RETURN
ENDIF
IF GDOC.FlgEst='A'
	SELECT (LsArea_Act)
	RETURN 
ENDIF
IF !F1_RLOCK(5)
	SELECT (LsArea_Act)
	RETURN 
ENDIF
LfImport = IIF(GDOC.CodMon=1,oCancel.Import,oCancel.ImpUsa)
IF  LfImport<=0 
	SELECT (LsArea_Act)
	RETURN
ENDIF
IF  oCancel.CodAux='00000000001'
	*SET step on 
ENDIF
SELECT CMOV
SEEK GDOC.CodDoc+GDOC.NroDoc+PADR("I/C",LEN(CodDoc))+PADR(oCancel.CodOpe+oCancel.NroAst,LEN(NroDoc))
IF FOUND()	&& Ya se genero ingreso de caja 
	SELECT (LsArea_Act)
	RETURN 
ENDIF

WAIT WINDOW 'Actualizando '+XsCOdDoc+' '+oCancel.CodAux+' '+oCancel.NroDoc NOWAIT 
SELECT GDOC
REPLACE SdoDoc WITH SdoDoc - LfImport
IF SdoDoc<=0
	REPLACE SdoDoc WITH 0
	REPLACE FlgEst WITH 'C'
	REPLACE FchAct WITH oCancel.FchAst
ENDIF
SELECT CMOV
APPEND BLANK
REPLACE CodDoc WITH "I/C"
REPLACE NroDoc WITH SUBSTR(oCancel.CodOpe,2)+oCancel.NroAst
REPLACE FchDoc WITH oCancel.FchAst
REPLACE CodCli WITH oCancel.CodAux
REPLACE CodMon WITH GDOC.CodMon
REPLACE FmaPgo WITH 3
REPLACE TpoCmb WITH GDOC.TpoCmb
REPLACE TpoRef WITH XsTpoDoc
REPLACE CodRef WITH XsCodDoc
REPLACE NroRef WITH XsNroDoc
REPLACE GloDoc WITH oCancel.GloDoc
REPLACE Import WITH LfImport
REPLACE CodCta WITH oCancel.CodCta
REPLACE NroMes WITH oCancel.NroMes
REPLACE CodOpe WITH oCancel.CodOpe
REPLACE NroAst WITH oCancel.NroAst
REPLACE FlgCtb WITH .T.
UNLOCK
** Actualizamos saldo por cliente 
SELECT SLDO
SEEK GDOC.CodCli
IF !FOUND()
	APPEND BLANK 
ELSE
	IF !f1_RLOCK(5)
		SELECT (LsArea_Act)
		RETURN
	ENDIF
ENDIF	
IF GDOC.CodMon = 1
	REPLACE CgoNac WITH CgoNac - LfImport
ELSE
	REPLACE CgoUsa WITH CgoUsa - LfImport
ENDIF
UNLOCK IN SLDO
SELECT (LsArea_Act)
