*************************************************************************************
* Programa          : CBDRL06v.PRG                                                                                                                                                      *
* Objeto               : LIBRO VENTAS                                                                                                                                                        *
* Autor                 : VETT                                                                                                                                                                          *
* Creaci¢n          : 05/09/93                                                                                                                                                               *
* Actualizaci¢n  : 11/11/94                                                                                                                                                               *
** VETT  06/06/2010 08:58 AM : Actualizacion para contemplar nuevo formato segun PCGE a partir de Julio 2010       *
*************************************************************************************
PRIVATE XsNroMes
*** Abrimos Bases ****
PUBLIC LoDatAdm AS dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','') 
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','') 
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','') 
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','') 
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','') 
LoDatAdm.abrirtabla('ABRIR','ADMTCNFG','CNFG','CNFG01','') 
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','') 
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Registro de Ventas"

XiCodMon = 1
XdFchAst = DATE()
XsCodDiv = SPACE(5)
XsNomDiv = []
xsNombre = []
XfTpoCmb = 0
XsRuc    = []
XsFlgEst = []
XsClfAux = [010]
XnFormat = 1
XsNroMes = TRANSFORM(_MES,'@L ##')
XcEliItm = '*'

SELE CNFG
SEEK 'VTA'
XsVtaOp = CNFG.CodOpe
XsVta70 = CNFG.CtaBase
XsVta40 = CNFG.CtaImpu
XsVta12 = CNFG.CtaTota

XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv

DO FORM cbd_report_REGISTRO_VENTAS
RELEASE LoDatAdm
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELE CNFG
SEEK 'VTA'
XsVtaOp = CNFG.CodOpe
XsVta70 = CNFG.CtaBase
XsVta40 = CNFG.CtaImpu
XsVta12 = CNFG.CtaTota
XsCodCco = " "

XsCodbus = XsCodDiv
=SEEK(XsCodOpe,"OPER")
SELECT VMOV
xLLave = XsNroMes+XsCodOpe
SEEK xLLave
IF ! FOUND()
	MESSAGEBOX("No Existen registros a Listar",0,'Resultado')
	RETURN
ENDIF

*!*	XsForV= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','Auxil=XsCodDiv') 	&& VETT 2008-05-07	

DIMENSION vImport(7),vTotal(7)
WAIT WIND PADC([... Espere un Momento Procesando Informaci¢n ...],72) NOWAIT
STORE 0 TO vTotal
DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
	STORE [] TO XsCodAux,XsNomAux,XsCodDoc,XsNroDoc,XsRefImp,XsNroRuc,XsNroRef,ZsCodDiv,XsTipRef
	STORE 0  TO vImport,XfImport,XfImpInf,XfDolar,XfTpoCmb,CHK,XfDolar2,XnCodMon,XnNroItm
	STORE {} TO XdFchDoc,XdFchRef,XdFchVto
	XlAfecto = .F.
	STORE [] TO XsRuc,XsFlgEst
	sKey = NroMes+CodOpe+NroAst
	XnCodMon = CodMon
*!*		IF nroast='08020032'
*!*			SET STEP ON 
*!*		ENDIF

	** VETT 2008-05-07	
	IF Nromes+CodOpe+NroAst='0200402000076'
		SET step on
	ENDIF 
*!*		IF !&XsForV.
*!*			SELECT VMOV
*!*			SKIP 
*!*			LOOP
*!*		ENDIF
	XdFchAst = VMOV.FchAst
	** VETT 2008-05-07	
	SELECT RMOV
	SEEK sKey
	XsCtaAnt = SPACE(LEN(RMOV->CodCta))
	IF EMPTY(CsCodCco)
		XsFor1='.T.'
	ELSE
		XsFor1=[CodCco=CsCodCco]
	ENDIF
	XsFor1= XsFor1+ IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')
*!*		IF !EVALUATE(XsFor1)
*!*			SELECT vmov
*!*			SKIP
*!*			LOOP
*!*		ENDIF
	DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF()
		IF !EVALUATE(XsFor1)
			SELECT Rmov
			SKIP
			LOOP
		ENDIF
		IF INLIST(EliItm , XcEliItm ,":")
			SKIP
			LOOP
		ENDIF
		IF XiCodMon = 1
			CHK  = CHK  + IIF(TpoMov="D",Import,-Import)
		ELSE
			CHK  = CHK  + IIF(TpoMov="D",ImpUsa,-ImpUSa)
		ENDIF	
*!*			ZsCodDiv = RMOV.CodDiv
*!*			IF NroDoc='00100000020'
*!*				SET STEP ON 
*!*			ENDIF
		DO CASE
			CASE INLIST(CODCTA,&XsVta12) 
				IF INLIST(Afecto,"A","N")
					IF !EMPTY(RMOV.ClfAux) AND !EMPTY(RMOV.CodAux) AND INLIST(RMOV.CodDoc,'01','03','07','08')
						IF XiCodMon=1
							XfImport = IIF(TpoMov=[D],Import,-Import)
						ELSE
							XfImport = IIF(TpoMov=[D],ImpUsa,-ImpUsa)
						ENDIF

						XsCodAux   = RMOV->CodAux
						=SEEK(RMOV.ClfAux+RMOV.CodAux,"AUXI")
						XsNomAux = IIF(RMOV->CodAux="99",RMOV->GloDoc,AUXI->NomAux)
						XsRuc    = IIF(RMOV->CodAux="99","   ",AUXI->RucAux)
						XsNroDoc = RMOV->NroDoc
						XsCodDoc = RMOV->CodDoc
						XdFchAst = RMOV.FchAst
						XdFchDoc = RMOV.FchDoc
						XfTpoCmb = RMOV->TpoCmb
						XsNroRef = RMOV.NroRef
						XsCodCco = RMOV.CodCco
						ZsCodDiv = RMOV.CodDiv
						XsTipRef	= IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'')  && RMOV.TipRef
						XdFchRef	= IIF(VerifyVar('FchRef','','CAMPO','RMOV'),RMOV.FchRef,{})  && RMOV.FchRef
						XdFchVto	=	RMOV.FchVto
						** VETT:PLE - SUNAT - 2015/04/08 13:06:07 ** 
						XnNroItm	= RMOV.NroItm
						
					ENDIF
					IF !EMPTY(RMOV.CodDoc) AND !EMPTY(RMOV.NroDoc)
						XsNroDoc   = RMOV->NroDoc
						XsCodDoc   = RMOV->CodDoc
					ENDI

					vImport(1) = vImport(1) + XfImport
					XfDolar  = XfDolar  + IIF(TpoMov="D",ImpUsa,-ImpUsa)
					XfDolar2  = XfDolar2  + IIF(TpoMov="H",ImpUsa,-ImpUsa)*IIF(XnCodMon=2,1,0)
				ELSE
*!*						XsNomAux = IIF(RMOV->CodAux="99",RMOV->GloDoc,AUXI->NomAux)
*!*						XsRuc    = IIF(RMOV->CodAux="99","   ",AUXI->RucAux)
*!*						XsNroDoc = RMOV->NroDoc
*!*						XsCodDoc = RMOV->CodDoc
*!*						XdFchAst = RMOV.FchAst
*!*						XdFchDoc = RMOV.FchDoc

				ENDIF	
			CASE INLIST(CODCTA,&XsVta70) And Afecto<>"N"
				IF XiCodMon = 1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUSa,-ImpUSa)
				ENDIF
					
				vImport(2) = vImport(2) + XfImport
			CASE INLIST(CODCTA,&XsVta40)
				IF XiCodmOn=1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUSa,-ImpUSa)
				ENDIF
				DO CASE
					CASE INLIST(Afecto,'A','G')	
						vImport(3) = vImport(3) + XfImport
					CASE Afecto =  'I'
						vImport(4) = vImport(4) + XfImport
					CASE Afecto =  'N'
						vImport(3) = vImport(3) + 0	
					OTHERWISE	
				ENDCASE	

			CASE INLIST(CODCTA,&XsVta70) And Afecto="N"
				IF XiCodmOn=1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUSa,-ImpUSa)
				ENDIF
				vImport(4) = vImport(4) + XfImport
			OTHERWISE
				IF Afecto<>"N"
					XfImport = Import
				ELSE
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ENDIF
				vImport(6) = vImport(6) + XfImport					
				IF Afecto<>"N"
					XfImport = ImpUSa
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUSa,-ImpUSA)
				ENDIF
				vImport(7) = vImport(7) + XfImport					
				IF INLIST(GsSigCia,'YTB','FITNESS')
					IF !EMPTY(RMOV.CodDoc) AND !EMPTY(RMOV.NroDoc)
						XsNroDoc   = RMOV->NroDoc
						XsCodDoc   = RMOV->CodDoc
						XsGloDoc   = RMOV->GloDoc
						XsNomAux   = RMOV->GloDoc	
					ENDIF
				ENDIF

				
		ENDCASE
		SELECT RMOV
		XsCtaAnt = CODCTA
		SKIP
	ENDDO
	SELECT VMOV
	LsGloDoc = LEFT(VMOV->NotAst,54)
	XsFlgEst  = FlgEst
	XsNroAst = NroAst
	
*!*		IF vImport(1)=0 AND vImport(2)=0 AND vImport(3)=0 AND vImport(4)=0 AND vImport(5)=0 AND vImport(6)=0 AND vImport(7)=0 AND ;
*!*			EMPTY(XsRuc) AND EMPTY(XsCodAux) AND VMOV.FLGEST<>'A'
*!*			SELECT VMOV
*!*			SKIP 
*!*			LOOP
*!*		ENDIF
	
	SELE TEMPORAL
	APPEND BLANK

	REPLACE  Divi       WITH ZsCodDiv
	REPLACE  CodAux     WITH XsCodAux
	REPLACE  CodCco     WITH XsCodCco
	REPLACE  Cliente    with IIF(VMOV.FlgEst='A',VMOV.NotAst,XsNomAux)
	REPLACE  CodDoc     With XsCodDoc
	** VETT:Control de las series que incluyen letras- Documentos creados en SEE - SOL - SFS 2022/02/18 16:43:41 **
	** QUEDA PENDIENTE AGREGAR ESTA REGLA DE NEGOCIO FUERA DEL CODIGO &&RN001:SERIE 2022/02/18 16:43:41 **
	m.lcReturnToMe = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	m.LcSource  = XsNroDoc
	m.LsSerLet	= CHRTRAN(m.lcSource, CHRTRAN(m.lcSource, m.lcReturnToMe, SPACE(0)), SPACE(0))
	LnLenSer    = IIF(EMPTY(m.LsSerLet),3,4)	
	XnPosGuion	= AT('-',XsNroDoc)
	LsSerDoc    = IIF(XnPosGuion>0,LEFT(XsNroDoc,XnPosGuion-1), LEFT(XsNroDoc,LnLenSer))    &&RN001  IIF(XnPosGuion>0,LEFT(XsNroDoc,XnPosGuion-1),LEFT(XsNroDoc,3))
	LsNroDoc    = IIF(XnPosGuion>0,SUBST(XsNroDoc,XnPosGuion+1),SUBST(XsNroDoc,LnLenSer+1)) &&RN001  IIF(XnPosGuion>0,SUBST(XsNroDoc,XnPosGuion+1),SUBST(XsNroDoc,4))
	** VETT: 2022/02/18 16:43:41 **
	REPLACE  SerDoc     With IIF(VMOV.FlgEst='A',LEFT(VMOV.NroVou,3),LsSerDoc)
	REPLACE  NroDoc     With IIF(VMOV.FlgEst='A',SUBs(VMOV.NroVou,4),LsNroDoc)
*	REPLACE  FchDoc		WITH IIF(EMPTY(XdFchDoc),VMOV.FchAst,XdFchDoc)
	REPLACE  FchDoc		WITH IIF(VMOV.FlgEst='A',VMOV.FchAst,IIF(EMPTY(XdFchDoc),VMOV.FchAst,XdFchDoc))

	REPLACE  NroAst     with XsNroAst
	REPLACE  FchAst     with XdFchAst
	REPLACE  Concepto   WIth IIF(VMOV.FlgEst='A',VMOV.NotAst,LsGlodoc)
	REPLACE  Dolares    WIth XfDolar
	REPLACE  Soles      WIth vImport(1)
	REPLACE  Afecto     WIth vImport(2)
	REPLACE  ImpIgv     WIth vImport(3)
	REPLACE  Inafecto   WIth vImport(4)
	REPLACE  PuchoMN    WITH vImport(6)
	REPLACE  PuchoME    WITH vImport(7)
	REPLACE  FlgEst     With XsFlgEst
	REPLACE  Ruc        With XsRuc
	Replace  TpoCmb     With XfTpoCmb
	REPLACE		CodMon    WITH XnCodMon
	REPLACE		NroRef    WITH XsNroRef	
	Replace		CHK  	  WITH m.CHK	
	** VETT  31/05/2012 10:32 AM : Nuevo Formato PCGE 2010
	REPLACE FchRef	WITH XdFchRef	
	REPLACE TipRef		WITH XsTipRef
	** VETT  22/11/2017 1:15 AM : Descomponer la serie del NroRef por defecto 3 1eros digitos, sino segun el guion '-'
 	** VETT:Control de las series que incluyen letras- Documentos creados en SEE - SOL - SFS 2022/02/18 16:43:41 **
	m.LcSource  = XsNroRef
	m.LsSerLet	= CHRTRAN(m.lcSource, CHRTRAN(m.lcSource, m.lcReturnToMe, SPACE(0)), SPACE(0))	
	LnLenSer    = IIF(EMPTY(m.LsSerLet),3,4)	
	XnPosGuion= AT('-',XsNroRef)
	LsSerRef    = IIF(XnPosGuion>0,LEFT(XsNroRef,XnPosGuion-1),LEFT(XsNroRef,LnLenSer))     &&RN001 IIF(XnPosGuion>0,LEFT(XsNroRef,XnPosGuion-1),LEFT(XsNroRef,3))
	LsNroRef    = IIF(XnPosGuion>0,SUBST(XsNroRef,XnPosGuion+1),SUBST(XsNroRef,LnLenSer+1))   &&RN001 IIF(XnPosGuion>0,SUBST(XsNroRef,XnPosGuion+1),SUBST(XsNroRef,4))
	REPLACE SerRef    WITH RIGHT('0000'+LTRIM(LsSerRef),4)		&& LEFT(XsNroRef,3)
	REPLACE NroRef    WITH LsNroRef		&& SUBST(XsNroRef,4)
	REPLACE FchVto	WITH XdFchVto
	** VETT:PLE-SUNAT - 2015/04/08 13:06:59 ** 
	REPLACE NroItm	WITH XnNroItm
	
	IF XiCOdMon=1
		IF ABS(Afecto + ImpIgv - Soles ) <= PuchoMN 
			REPLACE Soles WITH Afecto + ImpIgv
		ENDIF
	ELSE
		IF ABS(Afecto + ImpIgv - Dolares ) <= PuchoME 
			REPLACE Dolares WITH Afecto + ImpIgv
		ENDIF
	ENDIF
	IF (month(FchAst)<=8 AND _ANO=2003) OR _ano<=2002 
		IF ABS(vImport(2) * .18 - vImport(3)) > 1
			REPL Flgest   WITH '*'
		ENDIF
	ELSE
		
		IF ABS(vImport(2) * gosvrcbd.xfporigv/100 - vImport(3)) > 1
			REPL Flgest   WITH '*'
		ENDIF
	ENDIF
*!*		IF INLIST(nroast,'01050696','01050709')
*!*		SET STEP ON 
*!*		endif
	IF VMOV.FlgEst='A'
		LsAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
		LsFchAst = DTOS(VMOV.FchAst)	
		IF Goentorno.sqlentorno
			LoDatAdm.GenCursor('C_Anulado','GDOC','','','',"Nromes+CodOpe+NroAst='"+LsAst+"'",'')
		ELSE
			IF !USED('C_ANULADO')
				LcArtTmp = Goentorno.LocPath+SYS(3)
				LoDatAdm.GenCursor('C_Anulado','GDOC','','','',"0>1",'')
			ENDIF
			SELECT GDOC
			SET ORDER TO GDOC08
			LsAnoMes = TRAN(_Ano,[9999])+XsNroMes
			SEEK LsFchAst &&LsAnoMes
			SCAN WHILE DTOS(FchDoc)=LsFchAst &&LsAnoMes
				IF NroMes+CodOpe+NroAst	= LsAst
					SCATTER MEMVAR  
					SELECT  C_Anulado 
					APPEND BLANK 
					GATHER MEMVAR 
					SELECT GDOC
					EXIT
				ENDIF			
			ENDSCAN
		ENDIF

		IF USED('C_ANULADO')
			GO TOP IN C_ANULADO
			DO CASE 
				CASE C_ANULADO.CodDoc='FACT'	
					REPLACE  TEMPORAL.CodDoc  WITH '01'    
				CASE C_ANULADO.CodDoc='BOLE'	
					REPLACE  TEMPORAL.CodDoc  WITH '03'    
				CASE C_ANULADO.CodDoc='N/C'	
					REPLACE  TEMPORAL.CodDoc  WITH '07'    
				CASE C_ANULADO.CodDoc='N/D'	
					REPLACE  TEMPORAL.CodDoc  WITH '08'    
				OTHERWISE 	
			ENDCASE
			REPLACE  TEMPORAL.NroDoc     With SUBSTR(C_ANULADO.NroDoc,4)
			REPLACE  TEMPORAL.SerDoc     With LEFT(C_ANULADO.NroDoc,3)
			
			USE IN c_ANULADO
		ENDIF	
	ENDIF
	SELE VMOV
	SKIP
ENDDO
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

** VETT:Agregando campos: nroitm , exonerado , Exportac, ImpISC para PLE-SUNAT - 2015/04/07 11:25:42 **
SELE 0
CREATE TABLE (LcArcTmp) FREE (Divi C(5) ,;
							CodAux C(11),;
						    Cliente C(40),;
						    FchAst D ,;
			                NroAst C(8) ,;
			                CodDoc c(4),;
			                NroDoc C(10),;
			                FchDoc D,;
			                Concepto C(40),;
			                CodCco C(8), ;
		                    Soles N(14,2),;
		                    Dolares N(14,2),;
		                    Afecto N(14,2),;
		                    ImpExt N(14,2),;
		                    SerDoc C(15),;
                            Inafecto N(14,2),;
                            ImpIgv N(14,2),;
                            TpoCmb N(8,4),;
                            CodMon N(1,0), ;
                            NroRef C(11), ;
                 			FchRef D, ;
                 			TipRef C(2),;
                 			SerRef C(4),;
                 			FchVto D ,;
                 			Ruc C(11),;
                 			FlgEst C(1),;
                 			PuchoMn N(14,2),;
                 			PuchoME N(14,2),;
                 			NroVou C(10),;
                 			Chk N(14,2),;
                            NroItm N(5),;
                            Exonerado N(14,2),;
                            Exportac N(14,2),;
                            ImpISC N(14,2) ) 
                              
USE (LcArcTmp) EXCL ALIAS (LsAliasTemp)
IF !USED()
	RETURN ''
ENDIF
RETURN ALIAS()