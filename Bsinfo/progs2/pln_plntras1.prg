*!* Asiento Contable que vaina *!*
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
TsCodDiv1=[01]

DO xPlnTras1
*!* De Planillas
loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('SEDE')
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('CCTO')
loContab.oDatadm.CloseTable('BPGO')
loContab.oDatadm.CloseTable('CCTO1')
loContab.oDatadm.CloseTable('CODCTO')
loContab.oDatadm.CloseTable('COFG')
*!* De Contabilidad
loContab.oDatadm.CloseTable('CNFG2')
loContab.oDatadm.CloseTable('PPRE')
loContab.oDatadm.CloseTable('CNFG')
loContab.oDatadm.CloseTable('CFIG')
loContab.oDatadm.CloseTable('CTA2')
loContab.oDatadm.CloseTable('DIAF')
loContab.oDatadm.CloseTable('DRMOV')
loContab.oDatadm.CloseTable('PROV')
loContab.oDatadm.CloseTable('DPRO')
loContab.oDatadm.CloseTable('TCMB')
loContab.oDatadm.CloseTable('ACCT')
loContab.oDatadm.CloseTable('OPER')
loContab.oDatadm.CloseTable('RMOV')
loContab.oDatadm.CloseTable('VMOV')
loContab.oDatadm.CloseTable('AUXI')
loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('OPLN')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnTras1
*******************
Dimension AsAFP(20,2)
cTit1 = "Traslado Contable"
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = GsNomCia
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos************
PUBLIC LoDatAdm AS dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

DO CASE
	CASE XsCodPln = [1]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = [2]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = [3]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
ENDCASE
goentorno.open_dbf1('ABRIR','CBDPLNOR','OPLN','OPLN02','')

ArcTmp = PATHUSER+SYS(3)
SELE 0
CREATE TABLE (ARCTMP) FREE (CODPLN C(1)  ,;
					   CodCco c(8) ,;
                       CTACTS C(10) ,;
                       lElect C(8) ,;
                       NROPER C(2) ,;
                       CODPER C(6) ,;
                       CODMOV C(4) ,;
                       VALCAL N(12,2),;
                       TIPMOV C(1) ,;
                       DESMOV C(30) ,;
                       CODCTA C(8) ,;
                       CTRCTA C(8))

USE (ArcTmp) ALIAS CCTO Exclu
INDEX ON CODPER+NROPER+CTACTS+CODMOV TAG CCTO02
INDEX ON CODPER+NROPER+CODMOV+CTACTS TAG CCTO01
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNCOFG0','COFG','','')
GO TOP
LoDatAdm.abrirtabla('ABRIR','SEDES','SEDE','SEDE01','')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
IF COFG.Tipo_CodCc = 1
	LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
ELSE
	LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS13','')
ENDIF
GOTO TOP
DO WHILE ! EOF()
	XsCodPer = PERS.CodPer
	XsCodAfp = CodAfp
	XsGra_Sg = Gra_Sg
	XslElect = lElect
	IF COFG.Tipo_CodCc = 1
		XsCodCco = TRIM(PERS.CodCco)
	ELSE
		=SEEK(XsGra_Sg,"SEDE")
		XsCodCco = TRIM(SEDE.CodCco)
	ENDIF
	XsCtaCts = TRIM(CtaCts)
	IF INLIST(VALCAL("@SIT"),6,5)
		SKIP
		LOOP
	ENDIF
	DO GRABA
	SELECT PERS
	SKIP
ENDDO
SELECT bpgo
GO TOP
XsCodOpe = CodOpe
xContinuar = .T.
*************
DO p_Une_Ctas && Programa para Seeparar Centro de Costos y Unir Cuentas
*************
RESTORE FROM CBDCONFG ADDITIVE
DO MovApert
IF ! USED()
	RETURN
ENDIF
IF xContinuar
	SELECT CCTO1
	GOTO TOP
	IF MESSAGEBOX("Generar Asiento Contable",4+64+256,"Atención") <> 6
		RETURN
	ENDIF
	IF COFG.Tipo_CodCc = 1
		ArcTmp_1 = PATHUSER+SYS(3)
		CREATE TABLE (ARCTMP_1) FREE (CodCco C(8))
		USE (ArcTmp_1) ALIAS CodCto Exclu
		INDEX ON CodCco TAG CODCCO01
		SELECT PERS
		GO TOP
		SCAN WHILE !EOF()
			Bs_CodCco = CodCco
			SELECT CodCto
			SEEK Bs_CodCco
			IF !FOUND()
				APPEND BLANK
				REPLACE CodCco WITH Bs_CodCco
			ENDIF
			SELECT PERS
		ENDSCAN
		SELECT CodCto
		GO TOP
		SCAN WHILE !EOF()
			Dms_CodCco = CodCco
			SELECT ccto1
			SEEK Dms_CodCco
			IF FOUND()
				DO x_Genera_Asiento
			ENDIF
			SELECT CodCto
		ENDSCAN
	ELSE
		SELECT sede
		GO TOP
		SCAN WHILE !EOF()
			Dms_CodCco = CodCco
			SELECT ccto1
			SEEK Dms_CodCco
			IF FOUND()
				DO x_Genera_Asiento
			ENDIF
			SELECT sede
		ENDSCAN
	ENDIF
ELSE
	RETURN
ENDIF
*!*	Aca reemplazar libreria actual ya que es un report MAAV *!*
*!*	DO LIB_MTEC WITH 13
*!*	Largo  = 66
*!*	IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
*!*	xWhile = []
*!*	xFor   = []
*!*	sNOMREP = "PLN_PLNRTRAS"
*!*	DO F0PRINT WITH "REPORTS"
*!* GENERANDO ASIENTO CONTABLE *!*
*!*	Resp=' '
*!*	@24,00 SAY REPLI(' ',80) COLO SCHE 7
*!*	@24,20 SAY 'Generar Asiento Contable (S/N):' COLO SCHE 7
*!*	@24,55 GET Resp PICT '!' VALID Resp$'SN'
*!*	READ
*!*	IF Resp='N'
*!*		RETURN
*!*	ENDIF
**************************
PROCEDURE x_Genera_Asiento
**************************
NroDec = 4
Crear = .T.
OK = .T.
ScrMov = ""
STORE [] TO xsmes,RutaR
_Mes = VAL(XsNroMes)
IF _Mes < 12
	GdFecha = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
	GdFecha = CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
lDesBal = .T.
lTpoCorr = 1
Modificar = .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XiCodMon,XfTpoCmb,XsNroVou
STORE "" TO nImpNac,nImpUsa,Ngl,XsCodMod
STORE [] TO V1,V2,V3,V4
STORE 0 TO L1,L2,L3,L4
sFmt = "999,999,999.99"
MaxEle1 = 0

STORE 0 TO vImp
iDigitos=0
XsNotAst = "ASIENTO AUTOMATICO DE PLANILLA"
XdFchAst = GdFecha
XfTpoCmb = 1.00
XiCodMon = 1

*!* Buscando que operaciones puede tomar el usuario *!*
SELECT tcmb
SEEK DTOS(GdFecha)
IF !FOUND() AND RECNO(0)>0
	GO RECNO(0)
ENDIF
IF TCMB.OfiVta>0
	XfTpoCmb = TCMB.OfiVta
ENDIF
UltTecla = 0
************************
*!* Rutina Principal *!*
************************
IF !MOVNoDoc()
	RETURN
ENDIF
DO MovGrabM
SELE VMOV
UNLOCK ALL
RETURN
************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
******************
*!* Abrimos areas a usar **
LOCAL LoDatAdm1 as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm1 = CREATEOBJECT('Dosvr.DataAdmin')
LOCAL LReturOk

Modificar  = gosvrcbd.mescerrado(_mes)

LReturnOk=LoDatAdm1.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LReturnOk=LoDatAdm1.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')

lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDCNFG0','CFIG','','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
*!* Archivo de Control de Documentos del Proveedor *!*
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CJADPROV','DPRO','DPRO06','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CJATPROV','PROV','PROV02','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDDRMOV','DRMOV','DRMO01','')

lexiste=.t.
lreturnok=LoDatAdm1.abrirtabla('ABRIR','FLCJTBDF','DIAF','DIAF01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDMCTA2','CTA2','CTA201','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDTCNFG','CNFG','CNFG01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','CBDPPRES','PPRE','PPRE01','')
lreturnok=LoDatAdm1.abrirtabla('ABRIR','ADMTCNFG','CNFG2','CNFG01','')

RELEASE LoDatAdm1
RETURN lReturnOk

************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
SELE OPER
SEEK XsCodOpe
IF !FOUND()
    GsMsgErr = [Operación Invalida]
    DO LIB_MERR WITH 99
    RETURN .f.
ENDIF
XsNroAst = NROAST()
XsNroVou = XsCodOpe+RIGHT(XsNroAst,6)
Crear = .t.
SELECT VMOV
RETURN .T.
***************
FUNCTION NROAST
***************
PARAMETER XsNroAst
DO CASE
	CASE XsNroMES = "00"
		iNroDoc = OPER->NDOC00
	CASE XsNroMES = "01"
		iNroDoc = OPER->NDOC01
	CASE XsNroMES = "02"
		iNroDoc = OPER->NDOC02
	CASE XsNroMES = "03"
		iNroDoc = OPER->NDOC03
	CASE XsNroMES = "04"
		iNroDoc = OPER->NDOC04
	CASE XsNroMES = "05"
		iNroDoc = OPER->NDOC05
	CASE XsNroMES = "06"
		iNroDoc = OPER->NDOC06
	CASE XsNroMES = "07"
		iNroDoc = OPER->NDOC07
	CASE XsNroMES = "08"
		iNroDoc = OPER->NDOC08
	CASE XsNroMES = "09"
		iNroDoc = OPER->NDOC09
	CASE XsNroMES = "10"
		iNroDoc = OPER->NDOC10
	CASE XsNroMES = "11"
		iNroDoc = OPER->NDOC11
	CASE XsNroMES = "12"
		iNroDoc = OPER->NDOC12
	CASE XsNroMES = "13"
		iNroDoc = OPER->NDOC13
	OTHER
		iNroDoc = OPER->NRODOC
ENDCASE
LnLen_ID = OPER.Len_ID
IF OPER->Origen
	iNroDoc = VAL(TsCodDiv1+XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ########"),4))
ENDIF
IF PARAMETER() = 1
	IF VAL(XsNroAst) > iNroDoc
		iNroDoc = VAL(XsNroAst) + 1
	ELSE
		iNroDoc = iNroDoc + 1
	ENDIF
	DO CASE
		CASE XsNroMES = "00"
			REPLACE   OPER->NDOC00 WITH iNroDoc
		CASE XsNroMES = "01"
			REPLACE   OPER->NDOC01 WITH iNroDoc
		CASE XsNroMES = "02"
			REPLACE   OPER->NDOC02 WITH iNroDoc
		CASE XsNroMES = "03"
			REPLACE   OPER->NDOC03 WITH iNroDoc
		CASE XsNroMES = "04"
			REPLACE   OPER->NDOC04 WITH iNroDoc
		CASE XsNroMES = "05"
			REPLACE   OPER->NDOC05 WITH iNroDoc
		CASE XsNroMES = "06"
			REPLACE   OPER->NDOC06 WITH iNroDoc
		CASE XsNroMES = "07"
			REPLACE   OPER->NDOC07 WITH iNroDoc
		CASE XsNroMES = "08"
			REPLACE   OPER->NDOC08 WITH iNroDoc
		CASE XsNroMES = "09"
			REPLACE   OPER->NDOC09 WITH iNroDoc
		CASE XsNroMES = "10"
			REPLACE   OPER->NDOC10 WITH iNroDoc
		CASE XsNroMES = "11"
			REPLACE   OPER->NDOC11 WITH iNroDoc
		CASE XsNroMES = "12"
			REPLACE   OPER->NDOC12 WITH iNroDoc
		CASE XsNroMES = "13"
			REPLACE   OPER->NDOC13 WITH iNroDoc
		OTHER
			REPLACE   OPER->NRODOC WITH iNroDoc
	ENDCASE
	UNLOCK IN OPER
ENDIF
RETURN  RIGHT(repli("0",LnLen_ID) + LTRIM(STR(iNroDoc)), LnLen_ID)

************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE MOVMover
XdFchAst = VMOV->FchAst
XsNroVou = VMOV->NroVou
XiCodMon = VMOV->CodMon
XfTpoCmb = VMOV->TpoCmb
XsNotAst = VMOV->NOTAST
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
IF .NOT. RLock()
	GsMsgErr = "Asiento usado por otro usuario"
	DO LIB_MERR WITH 99
	UltTecla = Escape
	RETURN       && No pudo bloquear registro
ENDIF
DO LIB_MSGS WITH 10
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
	Llave = (NroMes + CodOpe + NroAst )
	IF Rlock()
		SELECT RMOV
		IF ! XsCodOpe = "9"
			DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
		ELSE
			DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
		ENDIF
		DELETE
		UNLOCK
	ELSE
		ok = .f.
	ENDIF
	SKIP
ENDDO
SELECT VMOV
IF Ok
	REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
	DELETE
ENDIF
UNLOCK ALL
RETURN
************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera
******************************************************************************
PROCEDURE MOVGraba
IF UltTecla = Escape
	RETURN
ENDIF
UltTecla = 0
IF Crear	&& Creando
	SELE OPER
*!*		IF ! Rec_Lock(5)
*!*			UltTecla = Escape
*!*			RETURN              && No pudo bloquear registro
*!*		ENDIF
	SELECT VMOV
	SEEK (XsNroMes + XsCodOpe + XsNroAst)
	IF FOUND()
		XsNroAst = NROAST()
		SEEK (XsNroMes + XsCodOpe + XsNroAst)
		IF FOUND()
			DO LIB_MERR WITH 11
			UltTecla = Escape
			RETURN
		ENDIF
	ENDIF
	APPEND BLANK
*!*		IF ! Rec_Lock(5)
*!*			UltTecla = Escape
*!*			RETURN              && No pudo bloquear registro
*!*		ENDIF
	REPLACE VMOV->NROMES WITH XsNroMes
	REPLACE VMOV->CodOpe WITH XsCodOpe
	REPLACE VMOV->NroAst WITH XsNroAst
	REPLACE VMOV.Auxil WITH Dms_CodCco
	IF Crear
		REPLACE VMOV->FLGEST  WITH "R"   && Asiento Tipo ??
	ELSE
		REPLACE VMOV->FLGEST  WITH "R"
	ENDIF
	replace vmov.fchdig  with date()
	replace vmov.hordig  with time()
	SELECT OPER
	=NROAST(XsNroAst)
	SELECT VMOV
	WAIT WINDOW [Generando asiento: ]+XsNroAst+[ Operación: ]+XsCodOpe+[ ]+OPER.NomOpe NOWAIT
ELSE
	*!* ACTULIZA CAMBIOS DE LA CABECERA EN EL CUERPO *!*
	IF VMOV->FchAst <> XdFchAst .OR. VMOV->NroVou <> XsNroVou
		SELECT RMOV
		Llave = (XsNroMes + XsCodOpe + XsNroAst )
		SEEK Llave
		DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
			IF Rlock()
				REPLACE RMOV->FchAst  WITH XdFchAst
				REPLACE RMOV->NroVou  WITH XsNroVou
				UNLOCK
			ENDIF
			SKIP
		ENDDO
	ENDIF
	SELECT VMOV
ENDIF
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->Digita  WITH GsUsuario
RETURN
****************
FUNCTION _CodDoc
****************
PARAMETER sCODDOC
XsTabla = "02"
IF LASTKEY() = F8
	SELECT TABL
	IF ! CbdBusca("TABL")
		RETURN .F.
	ENDIF
	sCodDoc = LEFT(TABL->Codigo,LEN(sCodDoc))
ENDIF
RETURN SEEK(XsTabla+sCodDoc,"TABL")
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
DO LIB_MSGS WITH 10
ULTTECLA = F10
DO BORRLIN
XiNroItm = NroItm
REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
SKIP
*** anulando cuentas autom ticas siguientes ***
DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
	DO BORRLIN
	REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
	SKIP
ENDDO
DO RenumItms WITH XiNroItm
DO MovPImp
DO LIB_MTEC WITH 14
RETURN
*****************
PROCEDURE BORRLIN
*****************
*!*	IF ! REC_LOCK(5)
*!*		UltTecla = Escape
*!*	ENDIF
SELE RMOV
DELETE
UNLOCK
IF ! XsCodOpe = "9"
	DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
ELSE
	DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
ENDIF
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
DO CalImp
IF RMOV->TpoMov = 'D'
	REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
	REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
ELSE
	REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
	REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
ENDIF
SELECT RMOV
RETURN
************************************************************************ FIN *
* Renumerar los items
******************************************************************************
PROCEDURE RenumItms
PARAMETERS T_Itms
DO WHILE &RegVal .AND. ! EOF()
	IF RLOCK()
		REPLACE NroItm   WITH T_Itms
	ENDIF
	UNLOCK
	SKIP
	T_Itms = T_Itms + 1
ENDDO
RETURN
************************************************************************ FIN *
* Objeto : Verificar si debe generar cuentas autom ticas
******************************************************************************
PROCEDURE MovbVeri
**** Grabando la linea activa ****
XcEliItm = " "
DO MovbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
	IF ! Crear
		*** anulando cuentas autom ticas anteriores ***
		SKIP
		XinroItm = NroItm
		DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
			Listar   = .T.
			Refresco = .T.
			DO BORRLIN
			REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
			SELECT RMOV
			SKIP
		ENDDO
		IF Listar
			DO RenumItms WITH XiNroItm
			GOTO NumRg(1)
		ELSE
			GOTO RegAct
		ENDIF
	ENDIF
	RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
XcEliItm = "*"
TsClfAux = []
TsCodAux = []
TsAn1Cta = CTAS->An1Cta
TsCC1Cta = CTAS->CC1Cta
IF EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
	TsClfAux = "04 "
	TsCodAux = CTAS->TpoGto
	TsAn1Cta = RMOV->CodAux
	TsCC1Cta = CTAS->CC1Cta
	TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
	*!* Verificamos su existencia *!*
	IF ! SEEK("05 "+TsAn1Cta,"AUXI")
		GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
		DO LIB_MERR WITH 99
		RETURN
	ENDIF
ELSE
	IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
		IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
			TsClfAux = XSCLFAUX
			TsCodAux = XSCODAUX
		ENDIF
	ENDIF
	IF ! SEEK(TsAn1Cta,"CTAS")
		GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
		DO LIB_MERR WITH 99
		RETURN
	ENDIF
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
	GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
	DO LIB_MERR WITH 99
	RETURN
ENDIF
*!*	DO CompBrows WITH .F.
SKIP
Crear = .T.
IF EliItm = "*" .AND. &RegVal
	Crear = .F.
ENDIF
** Grabando la primera cuenta autom tica **
IF Crear
	XiNroItm = XiNroItm + 1
ELSE
	XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
	DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MovbGrab
*!*	DO CompBrows WITH Crear
SKIP
Crear = .T.
IF EliItm = "*" .AND. &RegVal
	Crear = .F.
ENDIF
*!* Grabando la segunda cuenta automática *!*
IF Crear
	XiNroItm = XiNroItm + 1
ELSE
	XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
	DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MovbGrab
RETURN
*****************
* Inserta Items *
*****************
PROCEDURE MovInser
******************
RegAct = RECNO()
DO RenumItms WITH XiNroItm + 1
GOTO RegAct
DO MovbVeri
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MovbGrab
DO LIB_MSGS WITH 4
SELE RMOV
IF Crear
	APPEND BLANK
ENDIF
*!*	IF ! Rec_Lock(5)
*!*		RETURN
*!*	ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
	IF CTAS->MAYAUX = "S"
		XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
	ENDIF
ENDIF
IF Crear
	REPLACE RMOV->NroMes WITH XsNroMes
	REPLACE RMOV->CodOpe WITH XsCodOpe
	REPLACE RMOV->NroAst WITH XsNroAst
	REPLACE RMOV->NroItm WITH XiNroItm
	REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
	replace rmov.fchdig  with date()
	replace rmov.hordig  with time()
ELSE
	IF ! XsCodOpe = "9"
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
	ELSE
		DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
	ENDIF
	REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
	DO CalImp
	IF RMOV->TpoMov = 'D'
		REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
		REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
	ELSE
		REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
		REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
	ENDIF
ENDIF
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
*!*	REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodCco WITH XsCodCco
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->GLODOC WITH XSDESMOV
IF CodMon = 1
	REPLACE RMOV->Import WITH XfImport
	IF TpoCmb = 0
		REPLACE RMOV->ImpUsa WITH 0
	ELSE
		REPLACE RMOV->ImpUsa WITH round(XfImport/TpoCmb,2)
	ENDIF
ELSE
	REPLACE RMOV->Import WITH round(XfImport*TpoCmb,2)
	REPLACE RMOV->ImpUsa WITH XfImport
ENDIF
REPLACE RMOV->GloDoc WITH XsDESMOV
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE RMOV->IniAux WITH XsIniAux
REPLACE RMOV->NroRuc WITH XsNroRuc
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
	DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ELSE  && EXTRA CONTABLE
	DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ENDIF
SELECT RMOV
DO CalImp
IF RMOV->TpoMov = 'D'
	REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+nImpNac
	REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+nImpUsa
ELSE
	REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+nImpNac
	REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+nImpUsa
ENDIF
DO MovPImp
SELE RMOV
UNLOCK
DO LIB_MTEC WITH 14
RETURN
*****************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
RETURN
**********************************************************************
* Complemento del db_Brows para cuentas autom ticas
**********************************************************************
PROCEDURE CompBrows
*******************
PARAMETER INSERTA
return
@ LinIni,Xo+1 FILL TO LinIni+Actual-1,X1-1 COLOR SCHEME 1
IF INSERTA
	SCROLL LinIni+Actual-1,Xo+1,Y1,X1-1,-1
ENDIF
Contenido = []
IF HayEscLin
	DO &EscLin WITH Contenido
ELSE
	Contenido  = &LinReg
ENDIF
Linea(Actual)  = Contenido
NumRg(Actual)  = RECNO()
LinAct = LinIni+Actual-1
@ LinAct,Xo+2 SAY Linea(Actual) COLOR SCHEME 7
IF Actual >= MaxLin
	Actual = MaxLin
	Ultimo = MaxLin
	j =1
	DO WHILE j <MaxLin
		Linea(j)  = Linea(j+1)
		NumRg(j)  = NumRg(j+1)
		j =j +1
	ENDDO
	SCROLL Yo+1,Xo+1,Y1,X1-1,+1
	dB_Top = .F.
ELSE
	Actual   =  Actual + 1
	Ultimo   =  Ultimo + 1
ENDIF
LinAct = LinIni+Actual-1
RETURN
*************************
* Pinta Importe Totales *
*************************
PROCEDURE MovPImp
******************
IF VMOV->CodMon = 1
	@  20,40    SAY "S/."                                   COLOR SCHEME 7
	@  20,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  20,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  23,40    SAY "US$"                                   COLOR SCHEME 7
	@  23,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  23,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
ELSE
	@  20,40    SAY "US$"                                   COLOR SCHEME 7
	@  20,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  20,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  23,40    SAY "S/."                                   COLOR SCHEME 7
	@  23,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
	@  23,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
ENDIF
RETURN
**********************************************************************
* CHEQUEO DE FIN DE BROWSE ===========================================
**********************************************************************
PROCEDURE MovFin
****************
lDesBal = ( ABS(VMOV->HbeUsa-VMOV->DbeUsa) >.05 ) .or. ;
          ( ABS(VMOV->HbeNac-VMOV->DbeNac) >.01 )
IF lDesBal
	IF ALRT("Asiento Desbalanceado")
		Fin       = No
		Sigue     = Si
	ENDIF
ENDIF

IF Sigue = No .AND. ! lDesBal
	DO IMPRVOUC
ENDIF
RETURN
*********************
* Pantalla de Ayuda *
*********************
PROCEDURE MovF1
***************
SAVE SCREEN
GsMsgKey = "[Esc] Retorna"
DO LIB_MTEC WITH 99
@ 3,12 FILL TO 22,64 COLOR W/N
@ 2,13 TO 19,65 COLOR SCHEME 7
@  3,14 SAY  'Teclas de Selecci¢n :                              ' COLOR SCHEME 7
@  4,14 SAY  '   Cursor Arriba ....... Retroceder un Registro    ' COLOR SCHEME 7
@  5,14 SAY  '   Cursor Abajo  ....... Adelentar un Registro     ' COLOR SCHEME 7
@  6,14 SAY  '   Home          ....... Primer Registro           ' COLOR SCHEME 7
@  7,14 SAY  '   End           ....... Ultimo Registro           ' COLOR SCHEME 7
@  8,14 SAY  '   PgUp          ....... Retroceder en Bloque      ' COLOR SCHEME 7
@  9,14 SAY  '   PgDn          ....... Adelantar en Bloque       ' COLOR SCHEME 7
@ 10,14 SAY  'Teclas de Edici¢n :                                ' COLOR SCHEME 7
@ 11,14 SAY  '   Enter         ....... Modificar el Registro     ' COLOR SCHEME 7
@ 12,14 SAY  '   Del  (Ctrl G) ....... Anular el Registro        ' COLOR SCHEME 7
@ 13,14 SAY  '   Ins  (Ctrl V) ....... Insertar un  Registro     ' COLOR SCHEME 7
@ 14,14 SAY  '                                                   ' COLOR SCHEME 7
@ 15,14 SAY  '   F1            ....... Pantalla Actual de Ayuda  ' COLOR SCHEME 7
@ 16,14 SAY  '   F3            ....... Renumerar Items           ' COLOR SCHEME 7
@ 17,14 SAY  '   F5            ....... Impresi¢n del Asiento     ' COLOR SCHEME 7
@ 18,14 SAY  '   F10           ....... Terminar el Proceso       ' COLOR SCHEME 7
DO WHILE INKEY(0)<>Escape
ENDDO
RESTORE SCREEN
RETURN
************************
* Regenerar Acumulados *
************************
PROCEDURE MovF3
***************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "*********************************" COLOR SCHEME 7
@ 11,23 SAY "*    R E C A L C U L A N D O    *" COLOR SCHEME 7
@ 12,23 SAY "*  Espere un momento por favor  *" COLOR SCHEME 7
@ 13,23 SAY "*********************************" COLOR SCHEME 7
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
*!* Recalculando Importes *!*
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
	T_Itms = T_Itms + 1
	IF T_Itms <> NroItm
		Chqado =Chqado +1
	ENDIF
	IF RLOCK()
		REPLACE ChkItm   WITH T_Itms
	ENDIF
	UNLOCK
	DO CalImp
	IF TpoMov  ="D"
		T_DbeNac = T_DbeNac + nImpNac
		T_DbeUsa = T_DbeUsa + nImpUsa
	ELSE
		T_HbeNac = T_HbeNac + nImpNac
		T_HbeUsa = T_HbeUsa + nImpUsa
	ENDIF
	T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
	SELECT RMOV
	SKIP
ENDDO
*---------------------------------------------------*save
DO AJUSTE    &&  AJUSTA DESCUADRES POR DIFERENCIA CAMBIO ( VETT )
SELE VMOV
*!*	IF REC_LOCK(5)
	REPLACE VMOV->ChkCta  WITH T_Ctas
	REPLACE VMOV->DbeNac  WITH T_DbeNac
	REPLACE VMOV->DbeUsa  WITH T_DbeUsa
	REPLACE VMOV->HbeNac  WITH T_HbeNac
	REPLACE VMOV->HbeUsa  WITH T_HbeUsa
	REPLACE VMOV->NroItm  WITH T_Itms
*!*	ENDIF
SELE RMOV
**** Chequeo del Nro de Items **********************
IF Chqado > 0
	TnItms = 0
	DO WHILE TnItms < T_Itms
		TnItms =0
		SEEK VCLAVE
		DO WHILE EVALUATE(RegVal) .AND. ! EOF()
			IF NroItm <> ChkItm
				IF RLOCK()
					REPLACE NroItm   WITH ChkItm
				ENDIF
				UNLOCK
			ELSE
				TnItms = TnItms + 1
			ENDIF
			SKIP
		ENDDO
	ENDDO
ENDIF
RESTORE SCREEN
DO MovPImp
Fin  = .T.
RETURN
****************
PROCEDURE AJUSTE  && 26/01/95 VETT
****************
*!* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
IF lDesBal1 .AND. XiCodMon = 2
	IF T_HbeUsa > T_DbeUsa
		XsCodCta    = "66702"
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = "66702"
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
	XiCodMon    = 2
	IF XfImport<>0
		Crear = .T.
		DO MovBveri
		IF LcTpoMov = "D"
			T_DbeUsa = T_DbeUsa + XfImport
		ELSE
			T_HbeUsa = T_HbeUsa + XfImport
		ENDIF
	ENDIF
ENDIF
IF lDesBal2 .AND. XiCodMon = 1
	IF T_HbeNac > T_DbeNac
		XsCodCta    = "66702"
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = "66702"
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
	XiCodMon    = 1
	IF XfImport<>0
		Crear = .T.
		DO MovBveri
		IF LcTpoMov = "D"
			T_DbeNac = T_DbeNac + XfImport
		ELSE
			T_HbeNac = T_HbeNac + XfImport
		ENDIF
	ENDIF
ENDIF
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
XfTpoCmb    = 0
IF ! lDesBal1 .AND. lDesBal2 .AND. XiCodMon = 2
	IF T_HbeNac > T_DbeNac
		XsCodCta    = "66702"
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = "66702"
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
	XiCodMon    = 1
	IF XfImport<>0
		Crear = .T.
		DO MovBveri
		IF LcTpoMov = "D"
			T_DbeNac = T_DbeNac + XfImport
		ELSE
			T_HbeNac = T_HbeNac + XfImport
		ENDIF
	ENDIF
ENDIF
IF ! lDesBal2 .AND. lDesBal1 .AND. XiCodMon = 1
	IF T_HbeUsa > T_DbeUsa
		XsCodCta    = "66702"
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = "66702"
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
	XiCodMon    = 2
	IF XfImport<>0
		Crear = .T.
		DO MovBveri
		IF LcTpoMov = "D"
			T_DbeUsa = T_DbeUsa + XfImport
		ELSE
			T_HbeUsa = T_HbeUsa + XfImport
		ENDIF
	ENDIF
ENDIF
Listar   = .T.
Refresco = .T.
RETURN
***************
PROCEDURE SALDO
***************
SELECT RMOV
RegAct1 = RECNO()
EOF1    = EOF()
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK XsCodCta+XsCodAux+XsNroDoc
Saldo  = 0
SdoUsa = 0
DO WHILE (Llave = CodCta+CodAux+NroDoc) .AND. ! EOF()
	IF RegAct1 <> RECNO()
		Saldo  = Saldo  + IIF(TpoMov = 'D' , 1 , -1)*Import
		SdouSA = SdouSA + IIF(TpoMov = 'D' , 1 , -1)*ImpUsa
	ENDIF
	SKIP
ENDDO
SET ORDER TO RMOV01
IF ! EOF1
	GOTO RegAct1
ELSE
	GOTO BOTTOM
	IF ! EOF()
		SKIP
	ENDIF
ENDIF
Saldo  = Saldo  + IIF(XcTpoMov = 'D' , 1 , -1)*XfImport
SdouSA = SdouSA + IIF(XcTpoMov = 'D' , 1 , -1)*XfImpUsa
@ 22,19 SAY "S/."                                   COLOR SCHEME 7
@ 22,23 SAY Saldo   PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
@ 22,55 SAY "US$"                                   COLOR SCHEME 7
@ 22,59 SAY SdoUsa  PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
RETURN

*******************
PROCEDURE ChkDesBal
*******************
Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
DO MovPimpM
lDesBal = ( ABS(TFHbeUsa-TfDbeUsa) >.05 ) .or. ;
          ( ABS(TfHbeNac-TfDbeNac) >.01 )
IF lDesBal
	IF ALRT("Asiento Desbalanceado")
*!*			Fin       = No
		Sigue     = Si
		UltTecla = Home
	ENDIF
ENDIF
RETURN
*******************
PROCEDURE MOVGeRmov
*******************
IF UltTecla = Escape
	UltTecla = 0
	RETURN
ENDIF
PRIVATE nEle
MaxEle1 = 0
nEle    = 0
SELE RMDL
SEEK XsCodMod
DO WHILE !EOF() .AND. CodMod=XsCodMod
	nEle = nEle + 1
	vNroAst(nEle) = XsNroAst
	vCodRef(nEle) = RMDL->CodRef
	vCodCta(nEle) = RMDL->CodCta
	vClfAux(nEle) = RMDL->ClfAux
	vCodAux(nEle) = RMDL->CodAux
	vNroDoc(nEle) = RMDL->NroDoc
	vFchVto(nEle) = XdFchAst
	vFchDoc(nEle) = XdFchAst
	vGloDoc(nEle) = RMDL->GloDoc
	vTpoMov(nEle) = RMDL->TpoMov
	vCodMon(nEle) = VMDL->CodMon
	vImport(nEle) = _Import(RMDL->Import)
	sImport(nEle) = RMDL->Import
	vCodDoc(nEle) = RMDL->CodDoc
	vNroRef(nEle) = RMDL->NroRef
	vNroItm(nEle) = RMDL->NroItm
	vNroRuc(nEle) = SPACE(LEN(RMOV->NroRuc))
	vIniAux(nEle) = SPACE(LEN(RMOV->IniAux))
	SELECT RMDL
	SKIP
ENDDO
MaxEle1 = nEle
RETURN
******************
PROCEDURE MOVGrabM
******************
PRIVATE ii
**IF UltTecla = Escape .OR. lDesbal
*   RETURN
*ENDIF
DO MovGraba
*!*	Tan facil que era poner esto *!*
NClave   = [NroMes+CodOpe+NroAst]
VClave   = XsNroMes+XsCodOpe+XsNroAst
IF (LEN(TRIM(VClave)) <> 0)
	RegVal   = "&NClave = VClave"
ELSE
	*!* Todos los registros son válidos
	RegVal = ".T."
ENDIF
ii = 1
SELE CCTO1
SEEK Dms_CodCco
SCAN WHILE CodCco = TRIM(VMOV.Auxil)
	WAIT WINDOW CODMOV+" "+DESMOV+" "+CodCco NOWAIT
	Crear = .T.
	XiNroItm = VMOV->NroItm + 1
	XcEliItm = " "
	XsNroVou = []
	XdFchDoc = XdFchAst
	XiCodMon = 1
	XsCodCco = Dms_CodCco
	XcTpoMov = CCTO1.TipMov
	XsDesMov = CCTO1.DesMov
	XsCodCta = CCTO1.CodCta
	=SEEK(XsCodCta,[CTAS])
	XsCodRef = []
	XsCodAux = []
	XsClfAux = []
	XsCodDoc = []
	XsNroDoc = []
	XsNroRef = []
	XdFchVto = {}
	XsNroRuc = []
	XsIniAux = []
	XsCodFin = []
	IF CTAS.PidAux=[S]
		XsClfAux = CTAS.ClfAux
		IF XsCodCta="41"
			XsCodAux = CCTO1.CodAux
			XsCodDoc = "20" && Ve donde configurarlo MAAV
		ELSE
			XsCodAux = CCTO1.CodAux
		ENDIF
	ENDIF
	XfImport = CCTO1.ValCal
	XsGloDoc = XsNotAst  && Concepto
	*!* Grabando la linea activa *!*
	XcEliItm = " "
	DO MovbGrab
	RegAct = RECNO()
	*!* Requiere crear cuentas automaticas *!*
	=SEEK(XsCodCta,"CTAS")
	IF CTAS->GenAut <> "S"
		IF ! Crear
			*!* anulando cuentas autom ticas anteriores *!*
			SKIP
			XinroItm = NroItm
			DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
				Listar   = .T.
				Refresco = .T.
				DO BORRLIN
				REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
				SELECT RMOV
				SKIP
			ENDDO
			IF Listar
				DO RenumItms WITH XiNroItm
				GOTO NumRg(1)
			ELSE
				GOTO RegAct
			ENDIF
		ENDIF
	ELSE
		XcEliItm = "*"
		TsClfAux = []
		TsCodAux = [] && aca va la nueva teoria hasta mientras MAAV
		TsAn1Cta = TRIM(CCTO1.CodAux)
		TsCC1Cta = TRIM(CFIG.Cc1Cta)
		IF EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
			TsClfAux = "04 "
			TsCodAux = CTAS->TpoGto
			TsAn1Cta = RMOV->CodAux
			TsCC1Cta = CTAS->CC1Cta
			TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
			*!* Verificamos su existencia *!*
			IF ! SEEK("05 "+TsAn1Cta,"AUXI")
				GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
				DO LIB_MERR WITH 99
				RETURN
			ENDIF
		ELSE
			IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
				IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
*!*						TsClfAux = XSCLFAUX
*!*						TsCodAux = XSCODAUX
				ENDIF
			ENDIF
			IF ! SEEK(TsAn1Cta,"CTAS")
				GsMsgErr = "Cuenta Automática no existe. Actualización queda pendiente"
				DO LIB_MERR WITH 99
				RETURN
			ENDIF
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta Automática no existe. Actualización queda pendiente"
			DO LIB_MERR WITH 99
			RETURN
		ENDIF
		SKIP
		Crear = .T.
		IF EliItm = "*" .AND. &RegVal
			Crear = .F.
		ENDIF
		*!* Grabando la primera cuenta autom tica *!*
		IF Crear
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF Crear .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsAn1Cta
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		DO MOVbGrab
		DO CompBrows WITH Crear
		SKIP
		Crear = .T.
		IF EliItm = "*" .AND. &RegVal
			Crear = .F.
		ENDIF
		*!* Grabando la segunda cuenta autom tica *!*
		IF Crear
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF Crear .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsCC1Cta
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = SPACE(LEN(RMOV->ClfAux))
		XsCodAux = SPACE(LEN(RMOV->CodAux))
		DO MOVbGrab
	ENDIF
	SELE CCTO1
ENDSCAN
RETURN
****************
FUNCTION _Import
****************
Parameter sImport
Private i
IF Parameter() = 0 .OR. TRIM(sImport) = "?" .OR. TRIM(sImport)="NETO"
	RETURN 0
ENDIF
sImport = TRIM(sImport)
i = 1
LsEval=["]
DO WHILE i <= LEN(sImport)
	DO CASE
		CASE Substr(sImport,i,1) = "("
			LsEval = LsEval + "("
		CASE Substr(sImport,i,1) = "V"
			LsEval = LsEval +"&V"+ SUBSTR(sImport,i+1,1)+"."
			i = i + 1
		CASE Substr(sImport,i,1) $ "/-+*"
			LsEval = LsEval + SUBSTR(sImport,i,1)
		CASE Substr(sImport,i,1) $ "1234567890."
			*IF SubStr(sImport,i,1)="."
			LsEval = LsEval + "("+ SUBSTR(sImport,i,1)
			i = i + 1
			Paso = .F.
			DO WHILE SUBSTR(sImport,i,1)$"1234567890."
				LsEval = LsEval + SUBSTR(sImport,i,1)
				i = i + 1
				Paso = .T.
			ENDDO
			IF Paso
				i = i - 1
			ENDIF
			LsEval = LsEval + ")"
			*!*	ELSE
			*!*	LsEval = LsEval + SUBSTR(sImport,i,1)
			*!*	ENDIF
		CASE Substr(sImport,i,1) = ")"
			LsEval = LsEval + ")"
	ENDCASE
	i = i + 1
ENDDO
LsEval = LsEval + ["]
_TotImp = EVALUATE(&LsEval)
RETURN _TotImp
DELE FILE &ARCTMP..dBF
DELE FILE &ARCTMP..cdx
DELE FILE &ARCTEM..dBF
DELE FILE &ARCTEM..cdx
RETURN
***************
PROCEDURE Graba
***************
DIMENSION vcodmo1(40),vdescr1(40),vmont1(40),vCodCta(40),vCtrCta(40),vTpoMov_Cta(40),vTpoMov_Ctr(40)
STORE 0 TO n1,xTot01
SELE BPGO
GOTO TOP
lfPrimera = .T.
DO WHILE !EOF()
	IF INLIST(TpoVar,'5')
		SKIP
		LOOP
	ENDIF
	SELE TMOV
	SEEK BPGO->CODMOV
	SELE DMOV
	XfValCal = VALCAL(BPGO->CODMOV)
	xTot01 = xTot01 + XfVALCAL
	n1     = n1 + 1
	IF lfPrimera
		XmCodCta = BPGO->CTRCTA
		lfPrimera = .F.
	ENDIF
	vcodmo1(n1) = BPGO->CODMOV
	vdescr1(n1) = TRIM(UPPER(TMOV->DESMOV))
	vmont1(n1)  = XfValCal
	vCodCta(n1) = BPGO->CODCTA
	vCtrCta(n1) = BPGO->CTRCTA
	vTpoMov_Cta(n1) = BPGO->TpoMov_Cta
	vTpoMov_Ctr(n1) = BPGO->TpoMov_Ctr
	IF vMont1(n1)<>0.00 AND !EMPTY(BPGO.CodOpe)
		SELE CCTO
		APPEND BLANK
		REPLACE CtaCts WITH XsCtaCts
		REPLACE CodCco WITH XsCodCco
		REPLACE CODPLN WITH XsCodPln
		REPLACE NroPer WITH XsNroPer
		REPLACE CodPer WITH XsCodPer
		REPLACE CodMov WITH vcodmo1(n1)
		REPLACE DesMov WITH vdescr1(n1)
		REPLACE ValCal WITH vmont1(n1)
		REPLACE CodCta WITH vCodCta(n1)
		REPLACE CtrCta WITH vCtrCta(n1)
		DO CASE
			CASE BPGO.TpoMov_H = "X" AND BPGO.TpoMov_D = "X"
				*!*	Ponemos una linea mas por el Haber esta nota es importante
				REPLACE tipmov WITH vTpoMov_Cta(n1)
				APPEND BLANK
				REPLACE CtaCts WITH XsCtaCts
				REPLACE CodCco WITH XsCodCco
				REPLACE CODPLN WITH XsCodPln
				REPLACE NroPer WITH XsNroPer
				REPLACE CodPer WITH XsCodPer
				REPLACE CodMov WITH vcodmo1(n1)
				REPLACE DesMov WITH vdescr1(n1)
				REPLACE ValCal WITH vmont1(n1)
				REPLACE CodCta WITH vCodCta(n1)
				REPLACE CtrCta WITH vCtrCta(n1)
				REPLACE TipMov WITH vTpoMov_Ctr(n1)
			CASE BPGO.TpoMov_D = "X"
				replace TipMov WITH vTpoMov_Cta(n1)
			CASE BPGO.TpoMov_H = "X"
				replace TipMov WITH vTpoMov_Ctr(n1)
		ENDCASE
	ENDIF
	SELE BPGO
	SKIP
ENDDO
SELECT ccto
GO TOP
STORE 0 TO Xf1Debe,Xf1Haber
SCAN WHILE !EOF()
	IF TipMov = "D"
		Xf1Debe = Xf1Debe + ValCal
	ELSE
		Xf1Haber = Xf1Haber + ValCal
	ENDIF
ENDSCAN
XfTotal_Pla = Xf1Debe - Xf1Haber
APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE lElect WITH XslElect
REPLACE CodCco WITH XsCodCco
REPLACE CODPLN WITH XsCodPln
REPLACE NroPer WITH XsNroPer
REPLACE CodPer WITH XsCodPer
REPLACE CodMov WITH vcodmo1(n1)
REPLACE DesMov WITH "NETO A PAGAR"
REPLACE ValCal WITH XfTotal_Pla
REPLACE CodCta WITH XmCodCta
REPLACE CtrCta WITH XmCodCta
REPLACE TipMov WITH vTpoMov_Ctr(n1)

********************
PROCEDURE p_Une_Ctas
********************
ArcTmp1 = PATHUSER+SYS(3)
SELE 0
CREATE TABLE (ARCTMP1) FREE (CODPLN C(1)  ,;
					   Orden c(1) ,;
					   CodCco c(8) ,;
					   CodAux c(8) ,;
					   CodDoc c(2) ,;
                       NROPER C(2) ,;
                       CODMOV C(4) ,;
                       VALCAL N(12,2),;
                       TIPMOV C(1) ,;
                       DESMOV C(30) ,;
                       CODCTA C(8) )

USE (ArcTmp1) ALIAS CCTO1 Exclu
INDEX ON CodCco+Orden+CodCta+CodAux TAG CCTO102
INDEX ON CodCco+CodCta+CodAux TAG CCTO101
SELECT CCTO
GO TOP
SCAN WHILE !EOF()
	XsCodCco = CCTO.CodCco
	XcTpoMov = CCTO.TipMov
	XsDesMov = CCTO.DesMov
	XcLelect = CCTO.lElect
	IF XcTpoMov=[D]
		XsCodCta = CCTO.CodCta
	ELSE
		XsCodCta = CCTO.CtrCta
	ENDIF
	IF XsCodCta = "41"
		XsCodAux = TRIM(CCTO.lElect)
		XsCodDoc = "20" && Ve donde configurarlo MAAV
	ELSE
		XsCodAux = TRIM(CCTO.CtaCts)
		XsCodDoc = ""
	ENDIF
	
	SELECT CCTO1
	XsKey1 = XsCodCco+XsCodCta+XsCodAux
	SEEK XsKey1
	IF !FOUND()
		APPEND BLANK
		replace CodPln WITH CCTO.CodPln
		SELECT opln
		SEEK XsCodPln+TRIM(XsCodCta)
		XiOrden = Orden
		IF !FOUND()
			IF MESSAGEBOX("No Esta configurada la Tabla de Orden ¿Desea Continuar?",4+64+256,"Atención") <> 6
				xContinuar = .f.
				RETURN
			ENDIF
		ELSE
			REPLACE CCTO1.Orden WITH XiOrden
		ENDIF
		SELECT CCTO1
		replace CodCco WITH XsCodCco
		replace CodAux WITH XsCodAux
		replace NroPer WITH CCTO.NroPer
		replace CodDoc WITH XsCodDoc
		replace CodMov WITH CCTO.CodMov
		replace ValCal WITH CCTO.ValCal
		replace TipMov WITH XcTpomov
		replace DesMov WITH CCTO.DesMov
		replace CodCta WITH XsCodCta
	ELSE
		replace ValCal WITH ValCal+CCTO.ValCal
	ENDIF
ENDSCAN
*!* Aca verificamos el Orden de las Cuentas *!*
SELECT CCTO1
SET ORDER TO CCTO102
