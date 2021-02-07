********************************************************************************
* Programa      : CBDRL006.PRG                                                 *
* Objeto        : LIBRO COMPRAS                                                *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 12/11/94  VETT                                    - VISOL    *
* Actualizaci¢n : 23/05/2000  VETT                                  - NAVIERA  *
* ASOCIACION DE OPERACIONES A LIBROS CONTABLES SEGUN TABLA
* CREACION DE REPORTE SEGUN FORMATO CON REPORT			 	
********************************************************************************
PARAMETER  _Libro
PRIVATE XsNroMes

*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','') 
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','') 
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','') 
goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','') 
goentorno.open_dbf1('ABRIR','ADMTCNFG','CNFG','CNFG01','') 
SELE OPER
*SET FILTER TO INLIST(Libros,_libro)
GO TOP

XiCodMon = 1
XdFchAst = DATE()
XsNombre =[]
XxImp=0
XsCodAux = SPACE(LEN(AUXI.CODAUX))
XsGloDoc = SPACE(LEN(RMOV.GLODOC))
XsCodDiv = SPACE(3)
XsNomDiv = []
XsCodRef = []
XsNroAst = []
XsClfAux = [010]
XnFormat = 1
XcEliItm = '*'
XsNroMes = TRANSFORM(_MES,'@L ##')
SELE CNFG
SEEK 'CMP'
LOCATE FOR ClfAux=CodOpe
XsCmpOp  = CNFG.CodOpe

XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv


UltTecla = 0
DO FORM cbd_report_REGISTRO_COMPRAS
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELE CNFG
SEEK 'CMP'
LOCATE FOR ClfAux=CodOpe
XsCmpOp  = CNFG.CodOpe
XsCmp60  = CNFG.CtaBase
XsCmp40  = CNFG.CtaImpu
XsCmp42  = CNFG.CtaTota
XsCmp4ta = IIF(VARTYPE(CNFG.Cta4tac)<>'C' OR EMPTY(CNFG.Cta4tac),["XX"],CNFG.Cta4tac)
XscmpDom = IIF(VARTYPE(CtaDom)<>'C' OR EMPTY(CNFG.CtaDom),["XX"],CNFG.CtaDom)
XsCmpFon = CNFG.CtaFona
XsCodCco = " "

SELECT VMOV
xLLave = XsNroMes+XsCodOpe
SEEK xLLave
IF ! FOUND()
	WAIT WINDOW "No Existen registros a Listar" NOWAIT
	RETURN
ENDIF
WAIT WIND PADC([... Espere un Momento Procesando Información ...],72) NOWAIT

*!*	XsForV= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','Auxil=XsCodDiv')  && VETT 2008-05-07
DIMENSION vImport(12),vTotal(12)
STORE 0 TO vTotal, vGenera
DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
	STORE 0  TO vImport,vGenera,XfImport,XfImpInf,XfDolar,CHK,XnCodMon,XfDolar2,XnNroItm
	STORE [] TO XsCodAux,XsNomAux,XsNroDoc,XsRefImp,XsNroRuc,XsAfecto,XsNroRef,XsCodDoc,XsGloDoc,XsNroDtr,XsNumOri,XsTipOri,ZsCodDiv,XsTipRef
	STORE []	TO XsDirAux,XsCodPais
	STORE FchAst TO XdFchAst ,XdFchDoc, XdFchVto, XdFchDtr,XdFchRef
	XsNroAst = NroAst
	XnCodMon = CodMon
	XsFlgEst = FlgEst
	XlAfecto = .F.
	XfTpoCmb = VMOV.TpoCmb
	sKey = NroMes+CodOpe+NroAst
	** VETT 2008-05-07	
*!*		IF !&XsForV.
*!*			SELECT VMOV
*!*			SKIP 
*!*			LOOP
*!*		ENDIF
	** VETT 2008-05-07	
	
	
	SELECT RMOV
	SEEK sKey
	IF !FOUND()
		XsNomAux   = [******* ANULADO *******]
	ENDIF
	IF EMPTY(CsCodCco)
		XsFor1='.T.'
	ELSE
		XsFor1=[CodCco=CsCodCco]
	ENDIF
	
	XsFor1= XsFor1+ IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')  && VETT 2008-03-14
	IF !EVALUATE(XsFor1)
		SELECT vmov
		SKIP
		LOOP
	ENDIF
	STORE.F.TO XCompra, XNuevo,XCmp40
	DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF() AND XsFlgEst#'A'
	
		IF NroAst='01000080'
*!*				SET STEP ON 
		ENDIF
		IF !EVALUATE(XsFor1)
			SELECT Rmov
			SKIP
			LOOP
		ENDIF

		IF EliItm = XcEliItm
			SKIP
			LOOP
		ENDIF
*!*			IF NroAst='01000044'
*!*				SET STEP ON 
*!*			ENDIF
		CHK  = CHK + IIF(TpoMov="D",Import,-Import)
*!*			IF INLIST(nroast,'02000003')
*!*				SET STEP ON 
*!*			ENDIF 
		DO CASE
			CASE INLIST(CodCta,&XsCmp60) && AND Afecto = 'A'
				IF XiCodMon=1
					XfImport = IIF(TpoMov=[D],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[D],ImpUsa,-ImpUsa)
				ENDIF	
				DO CASE 
					CASE INLIST(Afecto,'N') 
						IF INLIST(UPPER(GsSigCia),'RAUO')
							vImport(3) = vImport(3) + XfImport
						ELSE
							vImport(1) = vImport(1) + XfImport
						ENDIF
					CASE INLIST(Afecto,'A','G') 
						vImport(2) = vImport(2) + XfImport
					CASE INLIST(Afecto,'I') 
						vImport(3) = vImport(3) + XfImport
				ENDCASE
				XsAfecto   = Afecto
				XfDolar2  = XfDolar2  + IIF(TpoMov="D",ImpUsa,-ImpUsa)*IIF(XnCodMon=2,1,0)
			CASE INLIST(CodCta,&XsCmp40) 
				IF XiCodMon=1				
					XfImport = IIF(TpoMov=[D],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[D],ImpUsa,-ImpUsa)
				ENDIF	
				DO CASE
					CASE INLIST(Afecto,'A','G')
						vImport(4) = vImport(4) + XfImport
					CASE INLIST(Afecto,'I')	
						vImport(5) = vImport(5) + XfImport
					CASE INLIST(Afecto,'N')		
						vImport(4) = vImport(4) + 0
				ENDCASE
			CASE INLIST(CodCta,&XsCmp4ta) 				
				IF XiCodMon=1				
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUsa,-ImpUsa)
				ENDIF	
				** VETT:Importe de renta de 4ta categoria Recibos x Honorarios - 2015/04/21 12:21:44 ** 
				** VETT:Si existe  importe en la cuenta es por estar afecta a la retencion  campo AFECTO='A' - 2015/04/21 12:23:26 ** 
*!*					DO CASE
*!*						CASE INLIST(Afecto,'N')
						vImport(8) = vImport(8) + XfImport
*!*					ENDCASE
			
			&& ---------------------@ir 08.07.08 // ADICIONAR... "RENTA NO DOMICILIADA"--------------------------------
			CASE INLIST(CodCta,&XsCmpDom) 				
				IF XiCodMon=1				
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUsa,-ImpUsa)
				ENDIF	
				*DO CASE
				*	CASE INLIST(Afecto,'N')
						vImport(9) = vImport(9) + XfImport
				*ENDCASE
			&& -----------------------------------------------------
			
			CASE INLIST(CodCta,&XsCmp42) AND !INLIST(CodCta,&XsCmp60) AND INLIST(Afecto,'A','G','I','N') && 
				** VETT  03/12/2015 10:51 AM : Todo importe en la cuentas de compras /facturas emitidas / debe sumar al total de la compra incluso inafecto 
				XCompra = .T.
				IF XiCodMon=1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUsa,-ImpUsa)
				ENDIF	
				vImport(6) = vImport(6) + XfImport
				XfDolar  = XfDolar  + IIF(TpoMov="H",ImpUsa,-ImpUsa)
				** VETT  03/12/2015 10:51 AM : FIN 
				DO CASE 
					CASE INLIST(Afecto,'A','G')
						
						IF !EMPTY(ClfAux) AND !EMPTY(CodAux)
							=SEEK(ClfAux+CodAux,"AUXI")
							XsCodAux = CodAux
							XsGloDoc = GloDoc
							XdFchDoc = FchDoc
							XdFchVto = FchVto
							XsNroDoc = NroDoc
							XsCodDoc = CodDoc
							XsNomAux = IIF([VARIO]$AUXI.NomAux,GloDoc,AUXI->NomAux)
							XsNroRuc = IIF([VARIO]$AUXI.NomAux,NroRuc,AUXI->RucAux)
							XsCodRef = CodRef
							XsNroRef = NroRef
							XsCodCco = CodCco
							XsNumOri = NumOri
							XsTipOri = TipOri
							XsNroDtr = NroDtr
							XdFchDtr = FchDtr
							ZsCodDiv = RMOV.CodDiv
							XsTipRef	= IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'')  && RMOV.TipRef
							XdFchRef	= IIF(VerifyVar('FchRef','','CAMPO','RMOV'),RMOV.FchRef,{})  && RMOV.FchRef
							** VETT:PLE - SUNAT - 2015/04/10 15:52:05 ** 
							XnNroItm	= RMOV.NroItm
							** VETT  19/06/2017 04:59 PM : PLE - SUNAT - DATOS NO DOMICILIADOS 
							XsDirAux	=	AUXI.DirAux
							XsCodPais	=	AUXI.CodPais
							
						ENDIF
					CASE	INLIST(Afecto,'I','N') AND EMPTY(XsNroDoc)
						IF !EMPTY(ClfAux) AND !EMPTY(CodAux)
							=SEEK(ClfAux+CodAux,"AUXI")
							XsCodAux = CodAux
							XsGloDoc = GloDoc
							XdFchDoc = FchDoc
							XdFchVto = FchVto
							XsNroDoc = NroDoc
							XsCodDoc = CodDoc
							XsNomAux = IIF([VARIO]$AUXI.NomAux,GloDoc,AUXI->NomAux)
							XsNroRuc = IIF([VARIO]$AUXI.NomAux,NroRuc,AUXI->RucAux)
							XsCodRef = CodRef
							XsNroRef = NroRef
							XsCodCco = CodCco
							XsNumOri = NumOri
							XsTipOri = TipOri
							XsNroDtr = NroDtr
							XdFchDtr = FchDtr
							ZsCodDiv = RMOV.CodDiv
							XsTipRef	= IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'')  && RMOV.TipRef
							XdFchRef	= IIF(VerifyVar('FchRef','','CAMPO','RMOV'),RMOV.FchRef,{})  && RMOV.FchRef
							** VETT:PLE - SUNAT - 2015/04/10 15:52:05 ** 
							XnNroItm	= RMOV.NroItm
							** VETT  19/06/2017 04:59 PM : PLE - SUNAT - DATOS NO DOMICILIADOS 
							XsDirAux	=	AUXI.DirAux
							XsCodPais	=	AUXI.CodPais							
						ENDIF
					
					 	
				ENDCASE
			OTHERWISE
				IF XiCodMon= 1
					XfImport = IIF(TpoMov=[D],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[D],ImpUsa,-ImpUsa)					
				ENDIF	
				vImport(07) = vImport(07) + XfImport
		ENDCASE
		SELECT RMOV
		SKIP
		IF EliItm = XcEliItm
			SKIP
			LOOP
		ENDIF
		IF XCompra AND INLIST(CodCta,&XsCmp60)
			XNuevo = .T.
		ENDI
		SELECT RMOV
	ENDDO
	DO GrabCmp
	SELE VMOV
	SKIP
ENDDO
RETURN

*****************
PROCEDURE GrabCmp
*****************
SELE TEMPORAL
APPEND BLANK
REPLACE FchAst    WITH XdFchast
REPLACE FchDoc    WITH XdFchDoc
REPLACE FchVto    WITH XdFchVto
REPLACE Divi      WITH ZsCodDiv
REPLACE NroAst    WITH XsNroAst
REPLACE CodCco    WITH XsCodCco
REPLACE RucAux    WITH XsNroRuc
REPLACE BaseA     WITH vImport(1)  && Base No Gravado 
REPLACE BaseB     WITH vImport(2)  && Base Gravado
REPLACE BaseC     WITH vImport(3)  && Inafecto


REPLACE ImpIgvA   WITH vImport(4)   && Igv Gravado
REPLACE ImpIgvB   WITH vImport(5)
REPLACE Importe   WITH vImport(6)

REPLACE CtaCate   WITH vImport(8)   && 4Ta Categoria 
IF ctacate>0
	REPLACE NoGrava   WITH vImport(1)		
ENDIF
REPLACE CtaDom   WITH vImport(9)
REPLACE CodAux    WITH XsCodAux
REPLACE Proveedor WITH XsNomAux
REPLACE GloDoc    WITH XsGloDoc
REPLACE CodDoc    WITH XsCodDoc
XnPosGuion= AT('-',XsNroDoc)
*!*	IF NroAst='01000044'
*!*		SET STEP ON 
*!*	ENDIF
REPLACE SerDoc    WITH IIF(XnPosGuion>0,LEFT(XsNroDoc,XnPosGuion-1),LEFT(XsNroDoc,3))
REPLACE NroDoc    WITH IIF(XnPosGuion>0,SUBST(XsNroDoc,XnPosGuion+1),SUBST(XsNroDoc,4))
REPLACE NroRef    WITH XsNroRef    &&para las notas de credito y debito
REPLACE ImporUS   WITH XfDolar   
REPLACE ImpExt    WITH XfDolar2   && Solo cuando es en dolares
REPLACE TpoCmb    WITH XfTpoCmb
REPLACE FlgEst    WITH XsFlgEst
REPLACE CodMon    WITH XnCodMon
REPLACE Afecto    WITH XsAfecto
REPLACE TipOri    WITH XsTipOri
REPLACE NumOri    WITH XsNumOri
REPLACE NroDtr    WITH XsNroDtr
REPLACE FchDtr    WITH XdFchDtr
REPLACE FchRef		WITH XdFchRef
REPLACE TipRef		WITH XsTipRef
** VETT  22/11/2017 1:15 AM : Descomponer la serie del NroRef por defecto 3 1eros digitos, sino segun el guion '-'
XnPosGuion= AT('-',XsNroRef)
LsSerRef    = IIF(XnPosGuion>0,LEFT(XsNroRef,XnPosGuion-1),LEFT(XsNroRef,3))
LsNroRef    = IIF(XnPosGuion>0,SUBST(XsNroRef,XnPosGuion+1),SUBST(XsNroRef,4))
REPLACE SerRef    WITH RIGHT('0000'+LTRIM(LsSerRef),4)		&& LEFT(XsNroRef,3)
REPLACE NroRef    WITH LsNroRef		&& SUBST(XsNroRef,4)
** VETT:PLE-SUNAT - 2015/04/10 15:53:15 ** 
REPLACE NroItm	WITH XnNroItm
REPLACE AAAA_DUA WITH IIF(INLIST(CodDoc,'50','52'),DTOS(FchDoc),'')
REPLACE CodPais	WITH XsCodPais
REPLACE DirAux	WITH XsDirAux

IF (month(FchAst)<=8 AND _ANO=2003) OR _ano<=2002 
	IF ABS(vImport(2) * .18 - vImport(6)) > 1
		REPL FlgErr   WITH '*'
	ENDIF
ELSE
	
	IF ABS(vImport(2) * gosvrcbd.xfporigv/100 - vImport(6)) > 1
		REPL FlgErr   WITH '*'
	ENDIF
ENDIF


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
CREATE TABLE (LcArcTmp) FREE (Divi C(5), CodAux C(11), FchAst D, FchVto D,NroAst C(8), ;
       Proveedor C(30), RucAux C(11), NroDoc C(14), CodCco C(8),BaseA N(14,2), ;
       BaseB N(14,2), BaseC N(14,2), BaseD N(14,2), BaseE N(14,2), TipOri c(2), NumOri c(14),;
       ImpIgvA N(14,2), ImpIgvB N(14,2), ImpIgvC N(14,2), Importe N(14,2), ;
       NoGrava N(14,2), CtaCate N(14,2), CtaDom N(14,2), Fonavi N(14,2), Redondeo N(14,2), ;
       Flag C(1), NroDtr c(20), FchDtr D,FchRef D, TipRef C(2), SerRef C(4) ,;
       ImporUS N(14,2),ImpExt N(14,2), TpoCmb N(10,4), FlgEst C(1) ,FchDoc D , Glodoc C(20) ,;
       CodMon N(1,0) , Afecto C(1), NroRef C(11), SerDoc C(15), CodDoc C(4) ,;
	   PuchoMn N(14,2),PuchoME N(14,2),NroVou C(10),Chk N(14,2),FlgErr C(1),;
	                            NroItm N(5),;
                            Exonerado N(14,2),ImpISC N(14,2),AAAA_DUA C(4),CodPais C(4),DirAux C(100)  )

USE (LcArcTmp) EXCL ALIAS (LsAliasTemp)
IF !USED()
	RETURN ''
ENDIF
RETURN ALIAS()