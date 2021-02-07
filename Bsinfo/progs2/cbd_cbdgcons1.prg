********************************************************************************
* Programa      : CBDGCONS.PRG                                                 *
* Objeto        : CONSISTENCIA DE REGISTRO                                     *
* Autor         : vett                                                         *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 29/05/95  VETT                                   A.G.R.      *
* Actualizaci¢n : 16/09/2003  VETT                                 VFP7        *
********************************************************************************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','') 
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','') 
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','') 
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV2','RMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','RCTA','CTAS01','') 
lreturnok=LoDatAdm.abrirtabla('ABRIR','ADMTCNFG','CNFG2','CNFG01','')

*!*	SELECT CNFG2
*!*	LOCATE FOR CNFG2.CodOpe=oSn2.CodOpe AND INLIST(CodCfg,'VTA','CMP','HON')
XsCtaBase = '' && CNFG2.CtaBase

XsCodOpe_D = ""
XsCodOpe_H = ""
XsNroMes = TRANS(_MES,"@L ##")
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
xOK      = .T.
NumEle   = 0
nNumDis  = 0
LlBorrarSinCabecera = .F.

DO FORM cbd_cbdgcons
RELEASE LoDatAdm

***************
PROCEDURE Gcons
***************
GfCtas9X = 0
GfCtas6X = 0
GfCtas79 = 0

SELECT OPER
SEEK XsCodOpe_D
SCAN WHILE CodOpe <= XsCodOpe_H
	XsCodOpe = CodOpe
	XsNomOpe = TRIM(NomOpe)
	LlCostoVenta = "COSTO"$UPPER(Siglas) and "VENTA"$UPPER(SIGLAS)
	
	** VETT  06/06/2017 08:52 AM : Controlamos cuentas base para RV,RC y RH 
	SELECT CNFG2
	LOCATE FOR CNFG2.CodOpe=XsCodOpe AND INLIST(CodCfg,'VTA','CMP','HON')
	IF FOUND()
		XsCtaBase = CNFG2.CtaBase
	ELSE
		XsCtaBase = ["XX","YY"]	
	ENDIF
	** VETT  06/06/2017 08:52 AM : Controlamos cuentas base para RV,RC y RH 
	SELECT VMOV
	xLLave = XsNroMes+TRIM(XsCodOpe)
	SEEK xLLave
	IF ! FOUND()
		GsMsgErr = "No Existen registros " + XsCodOpe + " " + XsNomOpe + " de " + XsNroMes
		*MESSAGEBOX(GsMsgErr,16,'Atención')
		WAIT WINDOW GsMsgErr Nowait
	ELSE
		DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
			*!* Verificamos si es necesario distribuir *!*
			DO VERIFICA
*!*				IF LASTKEY() = K_ESC
*!*					EXIT
*!*				ENDIF
			SELECT VMOV
			SKIP
*!*				IF INKEY() = K_ESC
*!*					EXIT
*!*				ENDIF
		ENDDO
	ENDIF
ENDSCAN

GsMsgErr = " [ Total Clase 6 "+TRANSFORM(ABS(GfCtas6x),'999,999,999.99')
DO MENSAJE1
GsMsgErr = " [ Total Clase 9 "+TRANSFORM(ABS(GfCtas9x),'999,999,999.99')
DO MENSAJE1
GsMsgErr = " [ Total Clase 79 "+TRANSFORM(ABS(GfCtas79),'999,999,999.99')
DO MENSAJE1
GsMsgErr = " [ Total Diferencia clase 6 y Clase 9 "+TRANSFORM(ABS(GfCtas6x) - ABS(GfCtas9x),'999,999,999.99')
DO MENSAJE1
GsMsgErr = " [ Total Diferencia clase 6 y Clase 79 "+TRANSFORM(ABS(GfCtas6x) - ABS(GfCtas79),'999,999,999.99')
DO MENSAJE1
GsMsgErr = " [ Total Diferencia clase 9 y Clase 79 "+TRANSFORM(ABS(GfCtas9x) - ABS(GfCtas79),'999,999,999.99')
DO MENSAJE1


*!*	@ 7,9 CLEAR TO 19,69
*!*	@ 7,9       TO 19,69

*!*	Lineas = 0
*!*	GsMsgkey = "[Esc] Cancela Proceso"
*!*	DO LIB_MTEC WITH 99

*!*	IF XiDevice = 2
*!*		SET DEVICE TO SCREEN
*!*	ENDIF
*!*	@ 20,27 SAY "--------------------------" COLOR SCHEME 7
*!*	@ 21,27 SAY "   PROCESO  COMPLETADO    "  COLOR SCHEME 7
*!*	@ 22,27 SAY " Presione Cualquier Tecla " COLOR SCHEME 7
*!*	@ 23,27 SAY "--------------------------" COLOR SCHEME 7
*!*	=INKEY(0)
*!*	CLEAR 
*!*	GoSvrcbd.oDatAdm.Close_File('CTB')
*** Verificar asientos sin cabecera *** 
SELECT rmov
SEEK XsNroMes
SCAN WHILE NroMes=XsNroMes
	IF !SEEK(NroMes+CodOpe+NroAst,'VMOV','VMOV01')
		GsMsgErr = "AST:"+NroMes+'-'+CodOpe+'-'+NroAst+' '+' SIN CABECERA - CUENTA: ['+ CodCta+'] '+IIF(Tpomov='D','DEBE','HABER')+' IMPORTE MN:'+ TRANSFORM(ABS(Import),'999,999,999.99') 
		IF LlBorrarSinCabecera
			=RLOCK()
			replace NumOri WITH 'BORRCHKSIS'
			replace FchDig WITH DATE()
			Replace  HorDig WITH TIME()
			DELETE 
			UNLOCK
			IF !CodOpe = "9"
				DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
			ELSE
				DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
			ENDIF
			GsMsgErr = GsMsgErr +   IIF(LlBorrarSinCabecera,' *** BORRADO ***','')	
		ENDIF
		DO MENSAJE1
	ENDIF
	SELECT RMOV
ENDSCAN

RETURN

******************
PROCEDURE VERIFICA
******************
Llave   = NroMes+"-"+CodOpe+"-"+NroAst
*!*	SET DEVICE TO SCREEN
WAIT WINDOW "Asiento " + Llave NOWAIT
*!*	@ 20,27 SAY "--------------------------" COLOR SCHEME 7
*!*	@ 21,27 SAY "³  ASIENTO "+LLAVE    +" ³" COLOR SCHEME 7
*!*	@ 22,27 SAY "³  **** PROCESANDO ****  ³" COLOR SCHEME 7
*!*	@ 23,27 SAY "--------------------------" COLOR SCHEME 7
*!*	IF XiDevice # 1
*!*		SET DEVICE TO PRINT
*!*		SET PRINTER TO LPT1
*!*	ENDIF
Llave   = NroMes+CodOpe+NroAst
Mensge  = "AST:"+CODOPE+"-"+NROAST
nNumDis = 0
nSumDbe = 0
nSumHbe = 0
NumEle  = 0

XiCodMon =VMOV->CodMon
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
UltDebe  =0
UltHber  =0
T_Ctas =0
TfCtas9X = 0
TfCtas6X = 0
TfCtas79 = 0

ZfCtas9X = 0
ZfCtas6X = 0
ZfCtas79 = 0
*** VETT 2008-06-19 ***
ZfCtas60 = 0
ZfCtas61 = 0
ZfCtas2X = 0


*!*	Recalculando Importes *!*
T_Itms =0
Chqado =0
SELECT RMOV
SEEK LLAVE
STORE .F. TO CtaAut , CtaAut2
NumEleX= 0
LsCodCta = SPACE(LEN(CTAS.CodCta))
LsAn1Cta = SPACE(LEN(CTAS.CodCta))
LsCc1Cta = SPACE(LEN(CTAS.CodCta))
LsAn1Clf = ""
LsAn1Aux = ""
lGenAut  = .F.
Lstip_afe_rc = ''
Lstip_afe_rv = ''
LsCtaAut = ''
STORE '' TO LsCtasAn1,LsCtasCC1,LsCtasAuto, LsCtas6x,LsCtas9x,LsCtas79,LsCtas2x,LsCtas60,LsCtas61

DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
	IF TpoMov = "D"
		UltDebe  = RECNO()
	ELSE
		UltHber  = RECNO()
	ENDIF
	IF TPOMOV = "D"
		LfImport = Import
		LfImpUsa = ImpUsa
	ELSE
		LfImport = -Import
		LfImpUsa = -ImpUsa
	ENDIF
	IF ! SEEK(CodCta,"CTAS")
		GsMsgErr = Mensge+" Cuenta ["+ALLTRIM(CodCta)+"] no registrada"+TRANS(rmov->NroItm,"#####")+ ' '+TRANSFORM(LfImport,'999,999,999.99')
		DO MENSAJE1
	ELSE
		*** --- INICIO ------------------------- 2007-03-26 ------------ VETT ----------------- ***
		***---- VETT 2008-06-05
		STORE '' TO Lstip_afe_rc,Lstip_afe_rv , LsAn1Cta2,LsCc1Cta2
		
		IF GoCfgCbd.TIPO_CONSO=2 AND (EMPTY(CodDiv) OR CodDiv='99')
			IF !EMPTY(VMOV.Auxil) && Remplazamos con la divisionaria de la cabecera
				replace CodDiv WITH VMOV.Auxil
			ELSE
				replace rmov.CodDiv WITH '99'
			ENDIF
			
		ENDIF
		LlMayAux = CTAS.MayAux = 'S'		&& Debemos controlar que no llene el campo CODREF innecesariamente
		***---- VETT 2008-06-05 
		lGenAut  = CTAS->GenAut="S"
		IF lGenAut
			LsAn1Cta2 = CTAS.An1Cta
			LsCc1Cta2 = CTAS.Cc1Cta
			Lstip_afe_rc = CTAS.tip_afe_rc
			Lstip_afe_rv = CTAS.tip_afe_rv
			LsCtaCto	=	GoCfgcbd.GenAut_costos
			IF INLIST(CodCta,&LsCtaCto)    && Cuentas de costos
				IF EMPTY(LsAn1Cta2) AND GoCfgcbd.g_An1Cta='2'	&& Auxiliar
	
					LsAn1Cta2 = PADR(RMOV.CodAux,LEN(CTAS.CodCta))
				ENDIF

				IF EMPTY(LsCc1Cta2) AND GoCfgcbd.g_Cc1Cta='5'	&& Valor Fijo
					LsCc1Cta2 = PADR(gocfgcbd.cc1cta,LEN(CTAS.CodCta))
				ENDIF
			ENDIF
			LsCtaExi	=	GoCfgcbd.GenAut_Existen
			IF INLIST(CodCta,&LsCtaExi)   && Cuentas de Existencias
				IF EMPTY(LsAn1Cta2) AND GoCfgcbd.g_An2Cta='2'	&& Auxiliar
					LsAn1Cta2 = PADR(RMOV.CodAux,LEN(CTAS.CodCta))	
				ENDIF

				IF EMPTY(LsCc1Cta2) AND GoCfgcbd.g_Cc2Cta='5'	&& Valor Fijo
					LsCc1Cta2 = PADR(gocfgcbd.cc2cta,LEN(CTAS.CodCta))
				ENDIF
			ENDIF
		ENDIF
		CtaAut2 = CTAS->GenAut="S" AND !EMPTY(LsAN1cta2) AND !EMPTY(LsCc1Cta2) && Esta no cambia su valor hasta el proximo registro
		LsCtaAut = IIF(LGenAut,CodCta,'')	
		LsChkCta  = IIF( CTAS.GenAut="S",RMOV.ChkCta,'NO.AUTO.')
		*** --- FIN ----------------------------- 2007-03-26 ------------ VETT ----------------- ***
		IF ! CtaAut
			CtaAut = CTAS->GenAut="S" AND !EMPTY(CTAS.AN1cta) AND !EMPTY(CTAS.CC1CTA) 
			IF !CtaAut
				LsCodCta = Codcta
				LsAn1Cta = CTAS.AN1cta
				LsCc1Cta = CTAS.Cc1Cta

			ELSE
				LsCodCta = CODCTA
				LsClfAux = ClfAux
				LsCodAux = CodAux
				LsAn1Cta = CTAS->AN1CTA
				LsCc1Cta = CTAS->CC1CTA
				LsAn1Clf = ""
				LsAn1Aux = ""
				Lstip_afe_rc = CTAS.tip_afe_rc
				Lstip_afe_rv = CTAS.tip_afe_rv
				RecnoCTAS=RECNO("CTAS")
				
				*!* Auxiliares de primera cuenta automatica
				=seek(LsAn1Cta,"CTAS")
				IF CTAS.MayAux="S"
					LsAn1Clf=CTAS.ClfAux
					IF LsAn1Clf=LsClfAux
						LsAn1Aux=LsCodAux
					ENDIF
				ENDIF
				*!* Auxiliares de contra cuenta
				=seek(LsCC1Cta,"CTAS")
				IF CTAS.MayAux="S"
					LsCC1Clf=CTAS.ClfAux
					IF LsCC1Clf=LsClfAux
						LsCC1Aux=LsCodAux
					ENDIF
				endif
				TsClf6x  = []
				TsClf9x  = []
				TsTpoGto = []
				go recnoCTAS IN "CTAS"
				IF EMPTY(LsAn1Cta) AND EMPTY(LsCc1Cta)
					LsAn1Cta = RMOV->CodAux
					LsCc1Cta = "79"+SUBSTR(LsAn1Cta,2,6)
					TsClf6x  = "05"
					TsClf9x  = "04"
					TsTpoGto = CTAS->TpoGto
				ENDIF
				AfImport = LfImport
				AfImpUsa = LfImpUsa
				NumEleX  = 0
			ENDIF
		ENDIF
		IF CTAS->AFTMOV#"S"
			GsMsgErr = Mensge+" Cuenta ["+ALLTRIM(CodCta)+"] no afecta a movimientos "+TRANS(rmov->NroItm,"#####") + ' '+TRANSFORM(LfImport,'999,999,999.99')
			DO MENSAJE1
		ENDIF
	ENDIF
	IF IMPORT < 0 .OR. IMPUSA < 0
		GsMsgErr = Mensge+" Contiene Importe Negativos "+TRANS(rmov->NroItm,"#####") + ' '+TRANSFORM(LfImport,'999,999,999.99')
		DO MENSAJE1
	ENDIF
	***** VERIFICANDO QUE NO SEA CUENTA QUE SE GENERA AUTOMATICAMENTE ***
	IF ELIITM <> "*"  
		SELECT CTAS
		SET ORDER TO AN1CTA
		SEEK RMOV->CODCTA
		IF FOUND() AND !LlCostoVenta
			GsMsgErr = Mensge+" ["+ALLTRIM(RMOV->CodCta)+"] es cuenta autom tica "+TRANS(RMOV->NroItm,"#####") + ' '+TRANSFORM(LfImport,'999,999,999.99')
			DO MENSAJE1
		ENDIF
		SELECT ctas
		SET ORDER TO CTAS01
		SELECT RMOV
	ENDIF
	*IF ELIITM = "ú" .AND. ! CtaAut
	IF ELIITM = "*" .AND. ! CtaAut  
		GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Invalida Cuenta autom tica "+TRANS(RMOV->NroItm,"#####")+ ' '+TRANSFORM(LfImport,'999,999,999.99')
		***DO MENSAJE1 && VETT 2007-03-26
	ENDIF
	*IF CtaAut .AND. NumEleX= 1 &&.AND. ELIITM <> "ú"
	*IF CtaAut .AND. NumEleX= 1 &&.AND. ELIITM <> "*"  
	*   CtaAut = .F.
	*   GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" no genero cuenta autom tica "+TRANS(rmov->NroItm,"#####")
	*   DO MENSAJE1
	*ENDIF
	IF CtaAut .AND. NumEleX= 1
		IF !EMPTY(TsTpoGto) 
			IF CodRef <> TsTpoGto
				DO WHILE !RLOCK('RMOV')
				ENDDO
				IF LlMayAux
					REPLACE RMOV.CodRef WITH TsTpoGto
				ENDIF
				REPLACE RMOV.CodAux WITH TsTpoGto
				REPLACE RMOV.ClfAux WITH TsClf9x
				UNLOCK IN RMOV
			ENDIF
		ENDIF
		IF !EMPTY(LsAn1Aux)
			IF CodRef <> LsAn1Aux 
				DO WHILE !RLOCK('RMOV')
				ENDDO
				IF LlMayAux				
					REPLACE RMOV.CodRef WITH LsAn1Aux
				ENDIF
				REPLACE RMOV.CodAux WITH LsAn1Aux
				REPLACE RMOV.ClfAux WITH LsAn1Aux
				UNLOCK IN RMOV
			ENDIF
		ENDIF
		IF CodCta <> LsAn1Cta
*!*				SET STEP ON
*!*				GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" genero mal la cta.autom tica "+TRANS(rmov->NroItm,"#####")
*!*				DO MENSAJE1
		ELSE
			IF Abs(AfImpUsa-LfImpUsa)>.2 .OR. ABS(AfImport-LfImport)>.2
				GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Importes en cta.autom tica "+TRANS(rmov->NroItm,"#####") + ' '+TRANSFORM(LfImport,'999,999,999.99')
				DO MENSAJE1
			ENDIF
		ENDIF
	ENDIF
	IF CtaAut .AND. NumEleX= 2
		IF CodCta <> LsCc1Cta
*!*				SET STEP ON
*!*				GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" genero mal la cta.autom tica "+TRANS(rmov->NroItm,"#####")
*!*				DO MENSAJE1
		ELSE
			IF Abs(AfImpUsa+LfImpUsa)>.2 .OR. ABS(AfImport+LfImport)>.2
				GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Importes en cta.autom tica "+TRANS(rmov->NroItm,"#####")+ ' '+TRANSFORM(LfImport,'999,999,999.99')
				DO MENSAJE1
			ENDIF
		ENDIF
		CtaAut = .F.
	ENDIF
	*!*
	*!*	IF INLIST(RMOV->CodCta,'606','607','61','62','63','64','65','67','68','71100106','71100206','72100000','72200000') &&AND EliItm="ú"
	
	*** --- INICIO ----------------------------- 2007-03-26 ------------ VETT ----------------- ***
	IF NROMES+CODOPE+NROAST='0100201000008' && or NROMES+CODOPE+NROAST='1001001100026'

	ENDIF 
		IF nromes+codope+nroast='0103701000002'
*!*			SET STEP on
		endif
	LsCtaExi	=	GoCfgcbd.GenAut_Existen
	IF INLIST(RMOV->CodCta,'60','61','62','63','64','65','67','68') && AND LsAn1Cta2='9'
		IF (INLIST(CodCta,&LsCtaExi) OR CodCta ='61' ) AND !LlCostoVenta && Cuentas de Existencias
			IF INLIST(CodCta,&LsCtaExi)
				ZfCtas60 = ZfCtas60 +  IIF(TpoMov="D",Import,-Import)			
				LsCtas60 = LsCtas60 + TRIM(CodCta) + ','
			ELSE
				ZfCtas61 = ZfCtas61 +  IIF(TpoMov="D",Import,-Import)			
				LsCtas61 = LsCtas61 + TRIM(CodCta) + ','
			ENDIF
		ELSE
			ZfCtas6x = ZfCtas6x + IIF(TpoMov="D",Import,-Import)
			LsCtas6x = LsCtas6x + TRIM(CodCta) + ','
		ENDIF
	ENDIF
	IF INLIST(RMOV->CodCta,'2') AND !LlCostoVenta
		ZfCtas2x = ZfCtas2x + IIF(TpoMov="D",Import,-Import)
		LsCtas2x = LsCtas2x + TRIM(CodCta) + ','
	ENDIF

	IF INLIST(RMOV->CodCta,'91','92','93','94','95',"96",'97') &&AND CTAS->GenAut="S"
		ZfCtas9x = ZfCtas9x + IIF(TpoMov="D",Import,-Import)
		LsCtas9x = LsCtas9x + TRIM(CodCta) + ','
	ENDIF
	*IF INLIST(RMOV->CodCta,'79')   &&AND EliItm="ú"
	IF INLIST(RMOV->CodCta,'79')   &&AND EliItm="*"  
		ZfCtas79 = ZfCtas79 + IIF(TpoMov="D",Import,-Import)
		LsCtas79 = LsCtas79 + TRIM(CodCta) + ','
	ENDIF
	
	IF CtaAut2
		TfCtas9X = 0
		TfCtas6X = 0
		TfCtas79 = 0

		LsCodAux=SPACE(LEN(RMOV.CodAux))
		LsAuxCT9=SPACE(LEN(CTAS.CodCta))
		LsCtaCto	=	GoCfgcbd.GenAut_costos
		LsCtaExi	=	gocfgcbd.genaut_existen
		LsCtaCrtChk=SPACE(LEN(CTAS.CodCta))
		LfImport2    = 0
		LfImpUsa2    = 0
		LsAn1CtaCodCta	 = ''	&& Cuenta de destino ligada ala cuenta que genera automatica
		LsCc1CtaCodCta	 = ''	&& Contra Cuenta ligada ala cuenta que genera automatica
		IF nromes+codope+nroast='0200500000013'
*!*			SET STEP on
		ENDIF
		LsEvalChkCta1 = IIF(!EMPTY(LsChkCta),[Rmov2.ChkCta = LsChkCta],[RMOV2.NroItm=RMOV.NroItm]  )
		LsEvalChkCta2 = IIF(!EMPTY(LsChkCta),[Rmov2.ChkCta = LsChkCta],[RMOV2.NroItm=RMOV.NroItm+1]  )
		LsEvalChkCta3 = IIF(!EMPTY(LsChkCta),[Rmov2.ChkCta = LsChkCta],[RMOV2.NroItm=RMOV.NroItm+2]  )
		LlChkCta = !EMPTY(LsChkCta)
		SELECT RMOV2
		SEEK RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst
		SCAN WHILE NroMes+CodOpe+NroAst	=	RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst
				IF NROMES+CODOPE+NROAST='1000310000039' && or NROMES+CODOPE+NROAST='1001001100026'
					SET STEP ON 
				ENDIF 
			IF CodCta=LsCtaAut  AND  EVALUATE(LsEvalChkCta1) &&LlRmov2.ChkCta = LsChkCta
				LsCodAux   = CodAux
				IF INLIST(CodCta,&LsCtaCto)    && Cuentas de costos
					LsCtasAuto = TRIM(CodCta)
					IF CodCta='6'
						TfCtas6x = TfCtas6x + IIF(TpoMov="D",Import,-Import)
					ELSE
						TfCtas9x = TfCtas9x + IIF(TpoMov="D",Import,-Import)
					ENDIF
					LsAuxCT9 = PADR(LsCodAux,LEN(CTAS.CodCta))
				ENDIF
				LfImport2 = Import
				LfImpUsa2 = ImpUsa
				LsCtaCrtChk=SPACE(LEN(CTAS.CodCta))
			ENDIF	
*!*				IF ( CodCta = LsAn1Cta2 OR  (INLIST(LsCtaAut,&LsCtaCto) AND CodCta=LsAuxCT9 ) ) AND LfImpUsa2 = ImpUsa AND LfImport2 = Import
			
			IF ( CodCta = LsAn1Cta2 AND ChkCtaAutomatica(LsCtaAut,LsAn1Cta2,LsCtaCto) )  AND LfImpUsa2 = ImpUsa AND LfImport2 = Import   AND EVALUATE(LsEvalChkCta2)
				LsCtasAn1 = TRIM(CodCta)
				IF CodCta='6'
					TfCtas6x = TfCtas6x + IIF(TpoMov="D",Import,-Import)
				ELSE
					TfCtas9x = TfCtas9x + IIF(TpoMov="D",Import,-Import)
				ENDIF
				LsCtaCrtChk=RCTA.Cc1Cta
			ENDIF
			IF CodCta = LsCC1Cta2 AND LsCC1Cta2=LsCtaCrtChk AND LfImpUsa2 = ImpUsa AND LfImport2 = Import AND EVALUATE(LsEvalChkCta3)
				LsCtasCC1 =  TRIM(CodCta)
				TfCtas79 = TfCtas79 + IIF(TpoMov="D",Import,-Import)
			ENDIF	
			IF INLIST(CodCta,'79')   
				
			ENDIF
		ENDSCAN
		IF ABS(ABS(TfCtas9x)-ABS(TfCtas6x))>.1 or ABS(ABS(TfCtas79)-ABS(TfCtas9x))>.1  or ABS(ABS(TfCtas79)-ABS(TfCtas6x))>.1
*!*				GsMsgErr = Mensge+" Verificar " + TRIM(LsCtasAuto)+' '+ TRIM(LsCtasAn1)+ ' '+ TRIM(LsCtasCC1) 
*!*				DO MENSAJE1
			
			GsMsgErr = Mensge+"  Cuentas: "+LsCtaAut+' '+ TRIM(LsCtasAn1)+ ' '+ TRIM(LsCtasCC1) + " Verificar DIF. [6-9] "+ TRANSFORM(ABS(TfCtas9x)-ABS(TfCtas6x),'9,999,999.999') + ;
			' [79-6] '+ TRANSFORM(ABS(TfCtas79)-ABS(TfCtas6x),'9,999,999.999')	+ ;					
			' [79-9] '+ TRANSFORM(ABS(TfCtas79)-ABS(TfCtas9x),'9,999,999.999') +' '+TRANS(rmov->NroItm,"#####") 
			DO MENSAJE1
		ENDIF

		SELECT RMOV
	ELSE
		IF 	lGenAut AND (EMPTY(LsAn1Cta2) OR EMPTY(LsCc1Cta2) ) AND EMPTY(Lstip_afe_rc) AND EMPTY(Lstip_afe_rv)  AND !LlCostoVenta
				GsMsgErr = Mensge+" "+ALLTRIM(LsCodCta)+" Revisar configuracion en plan de cuentas "+TRANS(rmov->NroItm,"#####") + ' '+TRANSFORM(LfImport,'999,999,999.99')
				DO MENSAJE1
		
		ENDIF
	ENDIF
	*** --- FIN ----------------------------- 2007-03-26 ------------ VETT ----------------- ***
	NumEleX= NumEleX+ 1
	T_Itms = T_Itms + 1
	IF T_Itms <> NroItm
		Chqado =Chqado +1
	ENDIF
	IF RLOCK()
		REPLACE ChkItm   WITH T_Itms
	ENDIF
	UNLOCK
	IF TpoMov  ="D"
		T_DbeNac = T_DbeNac + Import
		T_DbeUsa = T_DbeUsa + ImpUsa
	ELSE
		T_HbeNac = T_HbeNac + Import
		T_HbeUsa = T_HbeUsa + ImpUsa
	ENDIF
	T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
	IF XiCodMon = 1
		nImport = Import
	ELSE
		nImport = ImpUsa
	ENDIF
	IF TPOMOV = "D"
		nSumDbe = nSumDbe + nImport
	ELSE
		nSumHbe = nSumHbe + nImport
	ENDIF
	SKIP
ENDDO
*SET STEP ON 
IF ABS(ABS(ZfCtas9x)-ABS(ZfCtas6x))>.1 or ABS(ABS(ZfCtas79)-ABS(ZfCtas9x))>.1  or ABS(ABS(ZfCtas79)-ABS(ZfCtas6x))>.1
	GsMsgErr = Mensge+" Verificar Clase 6 y 9 " + TRIM(LsCtas6x)+' '+ TRIM(LsCtas9x)+ ' '+ TRIM(LsCtas79)
	DO MENSAJE1
	GsMsgErr = Mensge+" Verificar DIF. [6-9] "+ TRANSFORM(ABS(ZfCtas9x)-ABS(ZfCtas6x),'9,999,999.999') + ;
	' [79-6] '+ TRANSFORM(ABS(ZfCtas79)-ABS(ZfCtas6x),'9,999,999.999')	+ ;					
	' [79-9] '+ TRANSFORM(ABS(ZfCtas79)-ABS(ZfCtas9x),'9,999,999.999')
	DO MENSAJE1
ENDIF
IF ABS(ABS(ZfCtas60)-ABS(ZfCtas2X))>.1 or ABS(ABS(ZfCtas61)-ABS(ZfCtas60))>.1  or ABS(ABS(ZfCtas61)-ABS(ZfCtas2X))>.1
	GsMsgErr = Mensge+" Verificar Clase 60 ,2x, 61 " + TRIM(LsCtas6x)+' '+ TRIM(LsCtas9x)+ ' '+ TRIM(LsCtas79)
	DO MENSAJE1
	GsMsgErr = Mensge+" Verificar DIF. [60-2x] "+ TRANSFORM(ABS(ZfCtas60)-ABS(ZfCtas2X),'9,999,999.999') + ;
	' [61-60] '+ TRANSFORM(ABS(ZfCtas61)-ABS(ZfCtas60),'9,999,999.999')	+ ;					
	' [61-2x] '+ TRANSFORM(ABS(ZfCtas61)-ABS(ZfCtas2X),'9,999,999.999')
	DO MENSAJE1
ENDIF

IF ABS(TfCtas6x)=ABS(ZfCtas6x) AND ABS(TfCtas9x)=ABS(ZfCtas9x) AND ABS(TfCtas79)=ABS(ZfCtas79)
ELSE	 
*!*		IF ABS(ABS(TfCtas9x)-ABS(TfCtas6x))>.1 or ABS(ABS(TfCtas79)-ABS(TfCtas9x))>.1  or ABS(ABS(TfCtas79)-ABS(TfCtas6x))>.1
*!*			GsMsgErr = Mensge+" Verificar " + TRIM(LsCtasAuto)+' '+ TRIM(LsCtasAn1)+ ' '+ TRIM(LsCtasCC1) 
*!*			DO MENSAJE1
*!*			GsMsgErr = Mensge+" Verificar DIF. [6-9] "+ TRANSFORM(ABS(TfCtas9x)-ABS(TfCtas6x),'9,999,999.999') + ;
*!*			' [79-6] '+ TRANSFORM(ABS(TfCtas79)-ABS(TfCtas6x),'9,999,999.999')	+ ;					
*!*			' [79-9] '+ TRANSFORM(ABS(TfCtas79)-ABS(TfCtas9x),'9,999,999.999')
*!*			DO MENSAJE1
*!*		ENDIF
ENDIF
GfCtas6x = GfCtas6x + ZfCtas6x
GfCtas9x = GfCtas9x + ZfCtas9x
GfCtas79 = GfCtas79 + ZfCtas79

IF GfCtas6x<>GfCtas9x OR ABS(GfCtas6x)<>ABS(GfCtas79) OR ABS(GfCtas9x)<>ABS(GfCtas79)
*	SET STEP ON 
ENDIF
**** Verificamos si existe desbalance *****
Redondeo = .F.
A_DbeNac =0
A_HbeNac =0
A_DbeUsa =0
A_HbeUsa =0
DesBalNac = .F.
DesBalUsa = .F.
MsgDesbal = []
DesBalNac = (ABS(T_DbeNac - T_HbeNac)>.00)
DesBalUsa = (ABS(T_DbeUsa - T_HbeUsa)>.00)
IF DesBalNac .OR. DesbalUsa
	IF DesBalNac
		GsMsgErr = Mensge+" DESBALANCEADO " + trans(ABS(T_DbeNac - T_HbeNac),"999,999,999.99")+" SOLES"
		DO MENSAJE1
	ENDIF
	IF DesBalUsa
		GsMsgErr = Mensge+" DESBALANCEADO " + trans(ABS(T_DbeUsa - T_HbeUsa),"999,999,999.99")+" DOLARES"
		DO MENSAJE1
	ENDIF
ELSE
	*** AJUSTE POR REDONDEO ***
	IF VMOV->TpoCmb > 0
		IF XiCodMon = 1
			A_DbeUsa =ROUND(T_DbeNac/VMOV->TpoCmb,2) - T_DbeUsa
			A_HbeUsa =ROUND(T_HbeNac/VMOV->TpoCmb,2) - T_HbeUsa
		ELSE
			A_DbeNac =ROUND(T_DbeUsa*VMOV->TpoCmb,2) - T_DbeNac
			A_HbeNac =ROUND(T_HbeUsa*VMOV->TpoCmb,2) - T_HbeNac
		ENDIF
	ENDIF
	**** Verificando que el Ajuste a realizar no sobrepase a .05 ***
	zOk = .T.
	IF ABS(A_DbeUsa) > .05
		zOK = .F.
	ENDIF
	IF ABS(A_HbeUsa) > .05
		zOK = .F.
	ENDIF
	IF ABS(A_DbeNac) > .05
		zOK = .F.
	ENDIF
	IF ABS(A_HbeNac) > .05
		zOK = .F.
	ENDIF
	IF ABS(A_DbeUsa) > 0
		Redondeo = .T.
	ENDIF
	IF ABS(A_HbeUsa) > 0
		Redondeo = .T.
	ENDIF
	IF ABS(A_DbeNac) > 0
		Redondeo = .T.
	ENDIF
	IF ABS(A_HbeNac) > 0
		Redondeo = .T.
	ENDIF
ENDIF
SELECT VMOV
IF F1_RLOCK(5)
	REPLACE ChkCta  WITH T_Ctas
	REPLACE DbeNac  WITH T_DbeNac
	REPLACE DbeUsa  WITH T_DbeUsa
	REPLACE HbeNac  WITH T_HbeNac
	REPLACE HbeUsa  WITH T_HbeUsa
	REPLACE NroItm  WITH T_Itms
	UNLOCK
ENDIF
RETURN

******************
PROCEDURE MENSAJE1
******************
SELECT temp
APPEND BLANK
REPLACE mensaje WITH GsMsgErr
SELECT rmov


**** Posicionarse en el Directorio X:\O-Negocios\NomCia

********************************
PROCEDURE ver_ast_sin_cabecera
******************************
PARAMETERS cCodCia,cAno
LsNomBd = 'P'+cCodCia+cAno
CLOSE TABLES all
m.CurrentDir = CURDIR()

SET DEFAULT TO JUSTPATH(goentorno.tspathadm)

IF FILE(CURDIR()+'DATA\'+'CIA'+cCodCia+'\c'+cAno+'\cbdRmovm.dbf')
	SELECT 0
	LsTabla = LsNomBd+'!CbdRmovm'
	USE (LsTabla) ORDER RMOV01 ALIAS RMOV
ENDIF
*
IF FILE(CURDIR()+'DATA\'+'CIA'+cCodCia+'\c'+cAno+'\cbdVmovm.dbf')
	SELECT 0
	LsTabla = LsNomBd+'!CbdVmovm'
	USE (LsTabla) ORDER VMOV01 ALIAS VMOV
ENDIF

IF USED('VMOV') AND USED('RMOV')
	SELECT RMOV
	SET RELATION TO nromes+codope+nroast INTO Vmov ADDITIVE
	SET FILTER TO !rmov.nromes+rmov.codope+rmov.nroast==vmov.nromes+vmov.codope+vmov.nroast
	LOCATE
	SELECT vmov
	BROWSE nowait
	SELECT rmov
	BROWSE FIELDS nromes,codope,nroast,fchast,codcta,glodoc,tpomov,import,impusa,codmon,tpocmb,hordig,fchdig FONT 'Tahoma', 9 NOWAIT
	SUM IIF(tpomov='D',import,0),IIF(tpomov='H',import,0), ;
		IIF(tpomov='D',impusa,0),IIF(tpomov='H',impusa,0) ;
	TO a,b,c,d
	
	WAIT WINDOW TRANSFORM(a,'999,999.99')+' '+TRANSFORM(b,'999,999.99')+' '+TRANSFORM(a-b,'999,999.99')+' '+	;
	TRANSFORM(c,'999,999.99')+' '+TRANSFORM(d,'999,999.99')	+' '+TRANSFORM(c-d,'999,999.99')

	SELECT RMOV
	
	SET FILTER TO rmov.nromes+rmov.codope+rmov.nroast==vmov.nromes+vmov.codope+vmov.nroast AND vmov.flgest='A'
	locate
	BROWSE FIELDS nromes,codope,nroast,fchast,codcta,glodoc,tpomov,import,impusa,codmon,tpocmb,hordig,fchdig FONT 'Tahoma', 9 NOWAIT
	SUM IIF(tpomov='D',import,0),IIF(tpomov='H',import,0), ;
		IIF(tpomov='D',impusa,0),IIF(tpomov='H',impusa,0) ;
	TO a,b,c,d
	
	WAIT WINDOW TRANSFORM(a,'999,999.99')+' '+TRANSFORM(b,'999,999.99')+' '+TRANSFORM(a-b,'999,999.99')+' '+	;
	TRANSFORM(c,'999,999.99')+' '+TRANSFORM(d,'999,999.99')	+' '+TRANSFORM(c-d,'999,999.99')

	SELECT RMOV
	SET FILTER TO rmov.nromes+rmov.codope+rmov.nroast==vmov.nromes+vmov.codope+vmov.nroast AND EMPTY(nroast)
	locate
	BROWSE FIELDS nromes,codope,nroast,fchast,codcta,glodoc,tpomov,import,impusa,codmon,tpocmb,hordig,fchdig FONT 'Tahoma', 9 NOWAIT
	SUM IIF(tpomov='D',import,0),IIF(tpomov='H',import,0), ;
		IIF(tpomov='D',impusa,0),IIF(tpomov='H',impusa,0) ;
	TO a,b,c,d
	
	WAIT WINDOW TRANSFORM(a,'999,999.99')+' '+TRANSFORM(b,'999,999.99')+' '+TRANSFORM(a-b,'999,999.99')+' '+	;
	TRANSFORM(c,'999,999.99')+' '+TRANSFORM(d,'999,999.99')	+' '+TRANSFORM(c-d,'999,999.99')

ENDIF


SET DEFAULT TO (m.CurrentDir)

*************************
FUNCTION ChkCtaAutomatica
*************************
PARAMETERS PsCodCta,PsCtrCta,PsCtas
LnAreaAct = SELECT()
SELECT RCTA
SET ORDER TO AN1CTA   && AN1CTA+CODCTA
SEEK PsCtrCta+PsCodCta
IF FOUND() AND !EMPTY(PsCtas)
	SELECT (LnAreaAct)
	RETURN INLIST(RCTA.CodCta,&PsCtas)
ELSE
	SELECT (LnAreaAct)
	RETURN .F.
ENDIF




