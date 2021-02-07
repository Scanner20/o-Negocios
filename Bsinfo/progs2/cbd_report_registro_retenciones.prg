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
DO AbrirTablas
SELE OPER
GO TOP

XiCodMon = 1
XdFchAst = DATE()
XsNombre =[]
XxImp=0
XsCodAux = SPACE(LEN(AUXI.CODAUX))
XsCodDiv = SPACE(3)
XsNomDiv = []
XsCodRef = []
XsNroAst = []
XsClfAux = [010]
XnFormat = 1
XcEliItm = '*'
XsNroMes = TRANSFORM(_MES,'@L ##')
SELE CNFG
SEEK 'HON'
XsHonOp  = CNFG.CodOpe
UltTecla = 0
DO FORM cbd_report_REGISTRO_RETENCIONES
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELE CNFG
SEEK 'HON'
XsHonOp  = CNFG.CodOpe
XsHon60  = CNFG.CtaBase
XsHon40  = CNFG.Cta4tac
XsHon42  = CNFG.CtaTota
XsCodCco = " "

SELECT VMOV
xLLave = XsNroMes+XsCodOpe
SEEK xLLave
IF ! FOUND()
	WAIT WINDOW "No Existen registros a Listar" NOWAIT
	RETURN
ENDIF

WAIT WIND PADC([... Espere un Momento Procesando Información ...],72) NOWAIT
DIMENSION vImport(12),vTotal(12)
STORE 0 TO vTotal, vGenera
DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
		
	STORE 0  TO vImport,vGenera,XfImport,XfImpInf,XfDolar,CHK,XnCodMon
	STORE [] TO XsCodAux,XsNomAux,XsNroDoc,XsRefImp,XsNroRuc,XsAfecto,XsNroRef,XsCodDoc
	STORE FchAst TO XdFchAst ,XdFchDoc
	XsNroAst = NroAst
	XnCodMon = CodMon
	XsFlgEst = FlgEst
	XlAfecto = .F.
	XfTpoCmb = VMOV.TpoCmb
	IF EMPTY(CsCodCco)
		XsFor1='.T.'
	ELSE
		XsFor1=[CodCco=CsCodCco]
	ENDIF
	IF !EVALUATE(XsFor1)
		SELECT vmov
		SKIP
		LOOP
	ENDIF
	sKey = NroMes+CodOpe+NroAst
	IF nroast="03000018"
		SET STEP ON 
	ENDIF

	SELECT RMOV
	SEEK sKey
	IF !FOUND()
		XsNomAux   = [******* ANULADO *******]
	ENDIF
	STORE.F.TO XCompra, XNuevo,XHon40
	DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF() AND XsFlgEst#'A'
		IF EliItm = XcEliItm
			SKIP
			LOOP
		ENDIF
		CHK  = CHK + IIF(TpoMov="D",Import,-Import)
		DO CASE
			CASE INLIST(CodCta,&XsHon60) && AND Afecto = 'A'
				IF XiCodMon=1
					XfImport = IIF(TpoMov=[D],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[D],ImpUsa,-ImpUsa)
				ENDIF	
				DO CASE 
					CASE INLIST(Afecto,'N')
						vImport(1) = vImport(1) + XfImport
					CASE INLIST(Afecto,'A','G')
						vImport(2) = vImport(2) + XfImport
					CASE INLIST(Afecto,'I')
						vImport(3) = vImport(3) + XfImport
				ENDCASE
				XsAfecto   = Afecto
			CASE INLIST(CodCta,&XsHon40)
				IF XiCodMon=1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUsa,-ImpUsa)
				ENDIF
				DO CASE
					CASE INLIST(Afecto,'N')
						vImport(4) = vImport(4) + XfImport
					CASE INLIST(Afecto,'A','G')
						vImport(5) = vImport(5) + XfImport
					CASE INLIST(Afecto,'I')
						vImport(4) = vImport(4) + 0
				ENDCASE
			CASE INLIST(CodCta,&XsHon42) AND !INLIST(CodCta,&XsHon60)
				XCompra = .T.
				IF XiCodMon=1
					XfImport = IIF(TpoMov=[H],Import,-Import)
				ELSE
					XfImport = IIF(TpoMov=[H],ImpUsa,-ImpUsa)
				ENDIF	
				vImport(6) = vImport(6) + XfImport
				XfDolar  = XfDolar  + IIF(TpoMov="H",ImpUsa,-ImpUsa)
				IF !EMPTY(ClfAux) AND !EMPTY(CodAux) 
					=SEEK(ClfAux+CodAux,"AUXI")
					XsCodAux = CodAux
					XdFchDoc = FchDoc
					XsNroDoc = NroDoc
					XsCodDoc = CodDoc
					XsNomAux = IIF([VARIO]$AUXI.NomAux,GloDoc,AUXI->NomAux)
					XsNroRuc = IIF([VARIO]$AUXI.NomAux,NroRuc,AUXI->RucAux)
					XsCodRef = CodRef
					XsNroRef = NroRef
					XsCodCco = CodCco
				ENDIF
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
		IF XCompra AND INLIST(CodCta,&XsHon60)
			XNuevo = .T.
		ENDI
		SELECT RMOV
	ENDDO
	IF XsCodDoc='02'
		DO GrabHon
	ENDIF
	SELE VMOV
	SKIP
ENDDO
RETURN

*****************
PROCEDURE GrabHon
*****************
SELE TEMPORAL
APPEND BLANK
REPLACE FchAst    WITH XdFchast
REPLACE FchDoc    WITH XdFchDoc
REPLACE Divi      WITH XsCodref
REPLACE NroAst    WITH XsNroAst
REPLACE CodCco    WITH XsCodCco
REPLACE RucAux    WITH XsNroRuc
*REPLACE BaseA     WITH vImport(1)
*REPLACE BaseB     WITH vImport(2)
*REPLACE BaseC     WITH vImport(3)
*REPLACE ImpIgvA   WITH vImport(4)
*REPLACE ImpIgvB   WITH vImport(5)

REPLACE CtaCate   WITH vImport(4)
IF ctacate>0
	REPLACE NoGrava   WITH vImport(1)		
ELSE
	REPLACE BaseC     WITH vImport(1)
ENDIF

REPLACE Importe   WITH vImport(6)
REPLACE CodAux    WITH XsCodAux
REPLACE Proveedor WITH XsNomAux
REPLACE CodDoc    WITH XsCodDoc
REPLACE SerDoc    WITH LEFT(XsNroDoc,3)
REPLACE NroDoc    WITH SUBST(XsNroDoc,4)
REPLACE NroRef    WITH XsNroRef    &&para las notas de credito y debito
REPLACE ImporUS   WITH XfDolar
REPLACE TpoCmb    WITH XfTpoCmb
REPLACE FlgEst    WITH XsFlgEst
REPLACE CodMon    WITH XnCodMon
REPLACE Afecto    WITH XsAfecto
RETURN

*********************
PROCEDURE AbrirTablas
*********************
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','') 
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','') 
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','') 
goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','') 
goentorno.open_dbf1('ABRIR','ADMTCNFG','CNFG','CNFG01','') 

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
CREATE TABLE (LcArcTmp) FREE (Divi C(5), CodAux C(8), FchAst D, NroAst C(8), ;
       Proveedor C(30), RucAux C(11), NroDoc C(14), CodCco c(8),BaseA N(14,2), ;
       BaseB N(14,2), BaseC N(14,2), BaseD N(14,2), BaseE N(14,2), ;
       ImpIgvA N(14,2), ImpIgvB N(14,2), ImpIgvC N(14,2), Importe N(14,2), ;
       NoGrava N(14,2), CtaCate N(14,2), Fonavi N(14,2), Redondeo N(14,2), Flag C(1), ;
       ImporUS N(14,2), TpoCmb N(10,4), FlgEst C(1) ,FchDoc D , ;
       CodMon N(1,0) , Afecto C(1), NroRef C(11), SerDoc C(3), CodDoc C(4) ,;
	   PuchoMn N(14,2),PuchoME N(14,2),NroVou C(10),Chk N(14,2) )
		
USE (LcArcTmp) EXCL ALIAS (LsAliasTemp)
IF !USED()
	RETURN ''
ENDIF
RETURN ALIAS()