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
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV12','')
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
XsCmpOp  = CNFG.CodOpe


UltTecla = 0
DO FORM cbd_report_REGISTRO_COMPRAS
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELE CNFG
SEEK 'CMP'
XsCmpOp  = CNFG.CodOpe
XsCmp60  = CNFG.CtaBase
XsCmp40  = CNFG.CtaImpu
XsCmp42  = CNFG.CtaTota
XsCmp4ta = CNFG.Cta4tac
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
XnCodAst = 1
DIMENSION vImport(12),vTotal(12)
STORE 0 TO vTotal, vGenera
DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
	STORE 0  TO vImport,vGenera,XfImport,XfImpInf,XfDolar,CHK,XnCodMon
	STORE [] TO XsCodAux,XsNomAux,XsNroDoc,XsRefImp,XsNroRuc,XsAfecto,XsNroRef,XsCodDoc,XsGloDoc,XsNroDtr,XsNumOri,XsTipOri
	STORE FchAst TO XdFchAst ,XdFchDoc, XdFchVto, XdFchDtr
	XsNroAst = NroAst
	XnCodMon = CodMon
	XsFlgEst = FlgEst
	XlAfecto = .F.
	XfTpoCmb = VMOV.TpoCmb
	sKey = NroMes+CodOpe+NroAst+TRANSFORM(XnCodAst,"@L 99999")
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
	IF !EVALUATE(XsFor1)
		SELECT vmov
		SKIP
		LOOP
	ENDIF
	STORE.F.TO XCompra, XNuevo,XCmp40
	DO WHILE NroMes+CodOpe+NroAst+TRANSFORM(CodAst,"@L 99999") = sKey .AND. ! EOF() AND XsFlgEst#'A'
		IF EliItm = XcEliItm
			SKIP
			LOOP
		ENDIF
		CHK  = CHK + IIF(TpoMov="D",Import,-Import)
		DO CASE
			CASE INLIST(CodCta,&XsCmp60) && AND Afecto = 'A'
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
			CASE INLIST(CodCta,&XsCmp42) AND !INLIST(CodCta,&XsCmp60)
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
		IF XCompra AND INLIST(CodCta,&XsCmp60)
			XNuevo = .T.
		ENDI
		SELECT RMOV
	ENDDO
	IF VMOV.CodAst > XnCodAst
		XnCodAst = XnCodAst + 1
	ELSE
		XnCodAst = 1
		SELE VMOV
		SKIP
	ENDIF
	DO GrabCmp
	SELECT VMOV
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
REPLACE Divi      WITH XsCodref
REPLACE NroAst    WITH XsNroAst
REPLACE CodCco    WITH XsCodCco
REPLACE RucAux    WITH XsNroRuc
REPLACE BaseA     WITH vImport(1)
REPLACE BaseB     WITH vImport(2)
REPLACE BaseC     WITH vImport(3)
REPLACE ImpIgvA   WITH vImport(4)
REPLACE ImpIgvB   WITH vImport(5)
REPLACE Importe   WITH vImport(6)
REPLACE CodAux    WITH XsCodAux
REPLACE Proveedor WITH XsNomAux
REPLACE GloDoc    WITH XsGloDoc
REPLACE CodDoc    WITH XsCodDoc
REPLACE SerDoc    WITH LEFT(XsNroDoc,3)
REPLACE NroDoc    WITH SUBST(XsNroDoc,4)
REPLACE NroRef    WITH XsNroRef    &&para las notas de credito y debito
REPLACE ImporUS   WITH XfDolar
REPLACE TpoCmb    WITH XfTpoCmb
REPLACE FlgEst    WITH XsFlgEst
REPLACE CodMon    WITH XnCodMon
REPLACE Afecto    WITH XsAfecto
REPLACE TipOri    WITH XsTipOri
REPLACE NumOri    WITH XsNumOri
REPLACE NroDtr    WITH XsNroDtr
REPLACE FchDtr    WITH XdFchDtr
RETURN
