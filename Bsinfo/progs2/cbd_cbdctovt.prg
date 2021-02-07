*****************************************************************************
* Programa     : CBDCTOVT.PRG
* Sistema      : Contabilidad - Costo de Ventas
* Proposito    : Genera un asiento contable por documento
* Autor		   : DAVIDDCH
*****************************************************************************
** base de datos **
PARAMETER cTipo
IF !verifyvar('GsOpeCVT','C')
	return
ENDIF
#include const.h 	
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
SYS(2700,0)           

PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

IF !INLIST(cTipo,'01')
	GsMsgErr = 'OPCION NO DEFINIDA '+cTipo
	DO LIB_MERR WITH 99
	**CLOSE DATA
	SYS(2700,1)
	RETURN
ENDIF

**CLOSE DATA

IF !Inlist(GSRUCCIA,'20330813670')
	GsMsgErr = 'NO ESTA EN LA COMPA¥IA TOP SPORT'
	DO LIB_MERR WITH 99
	SYS(2700,1)
*!*		CLOSE DATA
	RETURN
ENDIF

IF !(_MES>=1 AND _MES<=12)
	GsMsgErr = 'MES CONTABLE NO ADMITIDO : '+MES(_MES,1)
	DO LIB_MERR WITH 99
	SYS(2700,1)
*!*		CLOSE DATA
	RETURN
ENDIF

** Variables para el control de la longitud de la Sub-Familia
XnIndMaxLong	= ALEN(GaLenCod)
XnMaxLong		= GaLenCod[XnIndMaxLong]

** Variable para tipo de lectura de movimientos de ventas **
** 1 -> Lee del registro de ventas (CCBRGDOC y VTARITEM) 
** 2 -> Lee Almctran  y Almdtran de todos los movimientos que estan marcados con lCtoVta= .T. en Almcftra

XnTipoCtoVta = 1
XlCtoVta = .f.    
** 

STORE '' TO XdFchIni,XdFchFin,ok,XsNroAnt,xTpoTras,xxNROAST,xResp
xTpoTras = 'C'
XdFchIni = DATE()
XdFchFin = DATE()
Ok = .T.
*
GcTit1 = GsNomCia
GcTit2 = 'Mes : '+Mes(_Mes,3)
GcTit3 = 'Usuario : '+GsUsuario

STORE '' TO XsCtaPer,XsCtaGan,XsCodOpe,XdFchPrc,XsNroMes,XsAnual


XsNroMes = TRANS(_MES,"@L ##")
XsAnual  = TRANS(_ANO,"@L ####")
XsTipo = cTipo
XpCodOpe = GsOpeCVT
XzClfAux = GsClfCli
DO FONDO WITH GcTit1,GcTit2,GcTit3," TRANSFERENCIA A CONTABILIDAD"



@ 6,11 to 21,68 CLEA
@ 6,11 to 21,68
@ 9,25 SAY ' T R A N S F E R E N C I A ' COLOR SCHEM 7
@11,23 SAY 'GENERACION DE ASIENTOS CONTABLES'
@13,17 SAY '         A¤o y Mes : '+XsAnual+'-'+Mes(_Mes,3)
@14,17 SAY 'Operacion Contable : '+XpCodOpe

xResp = 'N'
@15,17 SAY 'Desea Continuar (S/N) :' GET xResp PICT '!' VALID INLIST(xResp,'S','N')
READ
UltTecla = Lastkey()
IF UltTecla = escape_ OR xResp<>'S'
*!*		CLOSE DATA
	SYS(2700,1)
	RETURN
ENDI

IF !USED('CBDVTRAS')
	USE CBDVTRAS EXCL
ELSE
	SELECT CBDVTRAS	
ENDIF	
DELETE TAG ALL
PACK
INDEX ON TIPO+ANUAL+NROMES+CODOPE+NROAST TAG TRAS01
USE 

SELE 0
USE CBDTCIER
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
	GOTO RegAct
	Modificar = ! Cierre
ENDIF
IF !Modificar
	GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
	DO LIB_MERR WITH 99
	SYS(2700,1)
*!*		CLOSE DATA
	RETURN
ENDIF
USE IN CBDTCIER


STORE 0  TO CntError,CntTotal,CntAstOk,CntAstNo
STORE .F. TO ElimAsto

STORE '' TO XsCtaPer, XsCtaGan
XsCodOpe = XpCodOpe
IF !Open_File()
	GsMsgErr = 'NO SE ACCEDIO A TABLAS'
	DO LIB_MERR WITH 99
	SYS(2700,1)
*!*		CLOSE DATA
	RETURN
ENDIF


IF !SEEK(XsCodOpe,"OPER")
	GsMsgErr = 'OPERACION CONTABLE NO EXISTE '+XSCODOPE
	DO LIB_MERR WITH 99
	SYS(2700,1)
*!*		CLOSE DATA
	RETURN
ENDIF


*
cArch = SYS(3)+'.dbf'
SELE RMOV
COPY STRU TO &cArch
SELE 0
USE &cArch ALIAS TEMPO EXCL
INDEX ON CodRef TAG TEMPO
*


******************* Verifica Informacion ********************
CntError = 0
CntTotal = 0
CntAstOk = 0
CntAstNo = 0
XcSigue = .F.
*
DO PROCESA WITH .F.
*
@08,10 CLEAR TO 15,70
@08,10 TO 15,70
@09,20 SAY [ Documentos Encontrados :]+STR(CntTotal,6,0)
@10,20 SAY [   Documentos Correctos :]+STR(CntAstOk,6,0)
@11,20 SAY [  Documentos Rechazados :]+STR(CntAstNo,6,0)
@12,20 SAY [ Documentos Incorrectos :]+STR(CntTotal-(CntAstOk+CntAstNo),6,0)
@13,20 SAY [       Total de Errores :]+STR(CntError,6,0)
@14,20 SAY [Pulse cualquier tecla para continuar.......]
READ

cResp = [N]
IF CntError>0 AND (CntAstOk+CntAstNo)>0
	cResp = aviso(16,[Inconsistencias en la Informacion, desea continuar (S/N) ?],[],[],3,[SN],0,.F.,.F.,.T.)
ELSE
	IF (CntAstOk+CntAstNo)>0
		cResp = aviso(16,[Desea Continuar y Generar los Asientos (S/N) ?],[],[],3,[SN],0,.F.,.F.,.T.)
	ENDIF
ENDIF
IF cResp = [S]
	XcSigue = .T.
ENDIF


IF XcSigue
	XsNroAnt = GoSvrCbd.NROAST()
	
	xxNROAST = 0
	IF SEEK(XsCodOpe,"OPER")
		IF OPER.ORIGEN
			xxNROAST = Val(XsNroMes)*10000
		ENDIF
	ENDIF

	ElimAsto = .T.
	DO PROCLMP
	IF ElimAsto
		CntError = 0
		CntTotal = 0
		CntAstOk = 0
		CntAstNo = 0
		DO PROCESA WITH .T.
	ELSE
		GsMsgErr = 'ERROR INTERNO, NO SE GENERO ASIENTOS, VUELVA A INTENTARLO'
		DO LIB_MERR WITH 99
	ENDIF
	DO OPERULT

ENDIF


SELE VERROR
COUNT TO XXXX
IF XXXX>0
	SAVE SCREEN TO LsPanR01
	xMSGRP = [***** R E P O R T E  -  E R R O R E S *****]
	@14,20 SAY xMSGRP
	xFor   = []
	xWHILE = []
	LARGO  = 66
	sNomRep= [CBD_CBDCTOV1]
	IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
	GO TOP
	DO F0PRINT WITH "REPORTS" && IN ADMPRINT
	RESTORE SCREEN FROM LsPanR01
ENDIF


SELE VDCRHZ
COUNT TO XXXX
IF XXXX>0
	SAVE SCREEN TO LsPanR01
	xMSGRP = [***** R E P O R T E  -  DOC.  R E C H A Z A D O S *****]
	@14,13 SAY xMSGRP
	xFor   = []
	xWHILE = []
	LARGO  = 66
	sNomRep= [CBD_CBDCTOV1]
	IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
	GO TOP
	DO F0PRINT WITH "REPORTS" && IN ADMPRINT
	RESTORE SCREEN FROM LsPanR01
ENDIF


SELE TEMPO
DELETE TAG ALL
*!*	CLOSE DATA
CLOSE TABLES ALL 
DELETE FILE (cArch)

IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)

RETURN

****************************************************************************
PROCEDURE PROCESA
****************************************************************************
PARAMETER xGRABA
PRIVATE XiCodMon,XfTpoCmb,XiNroItm
PRIVATE XsCodCta,XsClfAux,XsCodAux,XcEliItm,XcTpoMov,XsGloDoc,XsCodDoc,XsNroDoc,XsCodDo1,XsNroRef
PRIVATE xDebe,xHabe,xNoVacio

IF USED('VERROR')
	USE IN VERROR
ENDIF
CREATE CURSOR VERROR (NROREF C(15),CAMPO C(22), MENSJ C(100))

IF USED('VDCRHZ')
	USE IN VDCRHZ
ENDIF
CREATE CURSOR VDCRHZ (NROREF C(15),CAMPO C(22), MENSJ C(100))

CntError = 0
CntTotal = 0


SELE GDOC
SEEK XsAnual+XsNroMes
SCAN WHILE !EOF() AND PADR(DTOS(FCHDOC),6)=XsAnual+XsNroMes
	IF !INLIST(CODDOC,'FACT','BOLE')
		LOOP
	ENDIF
	XiCodMon = 1
	XfTpoCmb = IIF(SEEK(DTOS(FCHDOC),'TCMB'),TCMB.OFIVTA,0)

	XdFchAst = FCHDOC
	XdFchDoc = XdFchAst
	XvFchVto = {//}
	
	XiNroItm = 0
	CntTotal = CntTotal + 1

	XvCodDoc = IIF(CODDOC='FACT','01','03')
	XvNroDoc = NRODOC
	XvCodAux = CODCLI
	XvNomCli = NOMCLI
	XvDirCli = DIRCLI
	IF coddoc='FACT' AND nrodoc='0020000391'
		SET STEP ON 		
	ENDIF

	IF !LMPTEMP()
		DO ERRV WITH 'No se pudo Eliminar Temporal','Error Interno'
	ENDIF


	IF EMPTY(ALLT(XvNroDoc))
		DO ERRV WITH 'Nro de Documento Vacio','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF
	
	IF GDOC.FlgEst='A' 
		DO ERRV WITH '*** Documento Anulado ***','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF
	
	IF !INLIST(XiCodMon,1,2)
		DO ERRV WITH 'Moneda Incorrecta ','CODMON:'+ALLT(STR(XiCodMon,5,2)),XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF

	IF XfTpoCmb<=0
		DO ERRV WITH [T/C Incorrecto o No registrado, de la fecha ]+dtoc(XdFchAst),'TPOCMB:'+Allt(Trans(XfTpoCmb,'999.9999')),XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF

	IF EMPTY(XdFchAst)
		DO ERRV WITH 'Fecha de Documento Vacio','FCHDOC',XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF

	IF EMPTY(ALLT(XvCodAux))
		DO ERRV WITH 'Codigo de Cliente Vacio','CODCLI:'+XvCodAux,XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF

	IF !SEEK(XzClfAux+XvCodAux,'AUXI')
		DO ERRV WITH 'Cliente NO Existe '+XvCodAux,'NOMCLI',XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF

	IF ((ImpBto-ImpDto)+IMPIGV)<>IMPTOT
		DO ERRV WITH 'No coincide los importes =>'+ ALLT(TRANS(ImpBto-ImpDto,'99999,999.99'))+' + '+ALLT(TRANS(IMPIGV,'99999,999.99'))+' <> '+ALLT(TRANS(IMPTOT,'99999,999.99')) ,'IMPVTA+IMPIGV<>IMPTOT',XvCodDoc+' '+XvNroDoc
		LOOP
	ENDIF
	
	IF !ProcDet()
		SELE GDOC
		LOOP
	ENDIF

	CntAstOk = CntAstOk + 1
	IF xGRABA
		XsNroAst = ''
		XvNotAst = [** PROV.DE.ASIENTO (]+GDOC.CODDOC+'-'+XvNroDoc+[) **]
		DO Gen_Asiento
		IF !EMPTY(ALLT(XsNroAst))
			zLLAVE = GDOC.CODDOC+GDOC.NRODOC
			zTOT = 0
			SELE DETA
			SEEK zLLAVE
			SCAN WHILE !EOF() AND CODDOC+NRODOC=zLLAVE
*!*					IF !SERV AND !EMPTY(ALLT(CODMAT)) AND SEEK(PADR(DETA.CODMAT,LEN(FAMI.CODFAM)),'FAMI')
				IF !EMPTY(ALLT(CODMAT)) AND SEEK(GsClfDiv+PADR(DETA.CODMAT,GnLenDiv),'FAMI')
					zCTO = ROUND(ARTCTO(DETA.CODMAT,GDOC.FCHDOC)*DETA.CANFAC,2)
					zTOT = zTOT + zCTO
					zNOM = ALLT(DETA.CODMAT)+' ('+ALLT(DETA.DESMAT)+')'
					DO GrabaAsto WITH FAMI.CTAC2X,'H',zCTO,XvCodAux,zNOM,XvDirCli,XvCodDoc,XvNroDoc,XvFchVto
					DO GrabaAsto WITH FAMI.CTAC69,'D',zCTO,XvCodAux,zNOM,XvDirCli,XvCodDoc,XvNroDoc,XvFchVto
					SELE DETA
				ENDIF
			ENDSCAN
			*DO GrabaAsto WITH '69101','H',zTOT,XvCodAux,XvNomCli,XvDirCli,XvCodDoc,XvNroDoc,XvFchVto
		ENDIF
	ENDIF
	
	SELE GDOC
ENDSCAN

RETURN

****************************************************************************
PROCEDURE Gen_Asiento
****************************************************************************
PRIVATE cMAX,xLog
xLog = .F.
cMax = 0
DO WHILE .T.
	cMAX = cMAX + 1
	IF cMAX>10000
		DO ERRV WITH 'No se Pudo Obtener Correlativo para el asiento','No se Genero Asiento',''
		EXIT
	ENDIF
	xxNROAST = xxNROAST + 1
	IF !SEEK(XsNroMes+XsCodOpe+Trans(xxNROAST,'@l 99999999'),'vmov')
		xLog = .T.	
		EXIT
	ENDIF
ENDDO
IF !xLog
	XsNroAst = ''
	RETURN
ENDIF

XsNroAst = TRANS(xxNROAST,'@L 99999999')

SELE OPER
=SEEK(XsCodOpe,"OPER")
IF !RLOCK("OPER")
	DO ERRV WITH 'No se Pudo Bloquear Correlativo para el asiento','No se Genero Asiento'
	XsNroAst = ''
	RETURN
ENDIF
=GoSvrCbd.NROAST(XsNroAst)

WAIT "Generando Asiento "+XsCodOpe+'-'+XsNroAst WINDOW NOWAIT
SELE VMOV
APPEND BLANK
IF !REC_LOCK(5)
	DO ERRV WITH 'No se Pudo Bloquear Registro Nuevo','No se Genero Asiento'
	XsNroAst = ''
	RETURN
ENDIF
REPLACE NroMes WITH XsNroMes
REPLACE CodOpe WITH XsCodOpe
REPLACE NroAst WITH XsNroAst
REPLACE FlgEst WITH "R"

REPLACE FchAst WITH XdFchAst
REPLACE NroVou WITH ''
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE NotAst WITH XvNotAst
REPLACE Digita WITH GsUsuario

SELE TRAS
APPEND BLANK
REPLACE Tipo	WITH XsTipo
REPLACE Anual	WITH XsAnual
REPLACE Nromes	WITH XsNroMes
REPLACE CodOpe	WITH XsCodOpe
REPLACE NroAst	WITH XsNroAst

RETURN


****************************************************************************
PROCEDURE GrabaAsto
****************************************************************************
PARAMETER yCodCta,yTpoMov,yImport,yCodAux,yNomCli,yDirCli,yCodDoc,yNroDoc,yFchVto

XcEliItm = [ ]
XsCodCta = yCodCta
XcTpoMov = yTpoMov
XsClfAux = ''
XsCodAux = ''
XsNroRuc = ''
XdFchVto = yFchVto

XsCodDoc = ''
XsNroDoc = ''		
XsCodDo1 = ''
XsNroRef = ''
XsCodref = ''
XsGloDoc = yNomCli

XfImport = yImport
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
		
IF !SEEK(XsCodCta,'CTAS')
	DO ERRV WITH 'CUENTA '+XsCodCta+' NO EXISTE',' CREAR EN EL PLAN DE CUENTAS',''
	RETURN
ENDIF
IF CTAS->PidAux="S"
	XsClfAux = CTAS.CLFAUX
	XsCodAux = yCodAux
	XsNroRuc = XsCodAux
ENDIF

IF CTAS->PidDoc="S"
	XsCodDoc = yCodDoc
	XsNroDoc = yNroDoc
ENDIF

XiNroItm = XiNroItm + 1

**DO MovbVeri IN vtammovm
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')

RETURN


****************************************************************************
PROCEDURE Open_File
****************************************************************************
*
WAIT WINDOW 'Abriendo Tablas........' Nowait

LoDatAdm.AbrirTabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.AbrirTabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.AbrirTabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
LoDatAdm.AbrirTabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.AbrirTabla('ABRIR','ALMDTRAN','DTRA','DTRA03','')
LoDatAdm.AbrirTabla('ABRIR','ALMTDIVF','FAMI','DIVF01','')
LoDatAdm.AbrirTabla('ABRIR','CCBRGDOC','GDOC','GDOC08','')
LoDatAdm.AbrirTabla('ABRIR','VTARITEM','DETA','ITEM01','')
LoDatAdm.AbrirTabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.AbrirTabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.AbrirTabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.AbrirTabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoDatAdm.AbrirTabla('ABRIR','CBDTOPER','OPER','OPER01','')
LoDatAdm.AbrirTabla('ABRIR','CBDTCNFG','CNFG','CNFG01','')
LoDatAdm.AbrirTabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
LoDatAdm.AbrirTabla('ABRIR','ALMCATAL','CALM','CATA02','')
LoDatAdm.AbrirTabla('ABRIR','ALMTALMA','ALMA','ALMA01','')

*!*	SELE 0
*!*	USE ALMRMOVM ORDER RMOV03 ALIAS RMOV NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE ALMTFAMI ORDER FAMI01 ALIAS FAMI NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CCBRGDOC ORDER GDOC08 ALIAS GDOC NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE VTARITEM ORDER ITEM01 ALIAS DETA NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*
SELE 0
USE CBDVTRAS ORDER TRAS01 ALIAS TRAS
IF !USED()
	RETURN .F.
ENDIF
*
*!*	SELE 0
*!*	USE CBDMAUXI ORDER AUXI01 ALIAS AUXI NOUPDATE
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CBDMCTAS ORDER CTAS01 ALIAS CTAS NOUPDATE
*!*	IF !USED('CTAS')
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CBDMTABL ORDER TABL01 ALIAS TABL NOUPDATE
*!*	IF ! USED('TABL')
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CBDVMOVM ORDER VMOV01 ALIAS HEAD
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CBDRMOVM ORDER RMOV01 ALIAS ITEM
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	*
*!*	SELE 0
*!*	USE CBDTOPER ORDER OPER01 ALIAS OPER
*!*	IF !USED()
*!*	 	CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE CBDACMCT ORDER ACCT01 ALIAS ACCT
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*
*!*	SELE 0
*!*	USE ADMMTCMB ORDER TCMB01 ALIAS TCMB NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
*!*	*

*!*	SELE 0
*!*	USE CBDTCNFG ORDER CNFG01 ALIAS CNFG NOUPDATE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN .F.
*!*	ENDIF
SELE CALM
SET RELA TO SubAlm INTO ALMA

SELE CNFG
SEEK '02'
XsCtaGan = CodCta2
XsCtaPer = CodCta1
USE IN CNFG

CREATE CURSOR VERROR (NROREF C(15),CAMPO C(22), MENSJ C(100))
CREATE CURSOR VDCRHZ (NROREF C(15),CAMPO C(22), MENSJ C(100))
WAIT CLEAR
*
RETURN .T.



****************************************************************************
PROCEDURE PROCLMP
****************************************************************************
PRIVATE Ok
SELE TRAS
IF SEEK(XsTipo+XsAnual+XsNromes+XsCodOpe)
	SCAN WHILE !EOF() AND TIPO+ANUAL+NROMES+CODOPE=XsTipo+XsAnual+XsNromes+XsCodOpe
		Ok = .T.
		DO xDes_Ctb WITH TRAS.NROMES,TRAS.CODOPE,TRAS.NROAST
		SELE TRAS
		IF Ok
			DELETE
		ENDIF
	ENDSCAN
ENDIF

IF SEEK(XsTipo+XsAnual+XsNromes+XsCodOpe,'TRAS')
	ElimAsto = .F.
ENDIF

RETURN

****************************************************************************
* Objeto : Des-Actualiza Contabilidad
******************************************************************************
PROCEDURE xDes_Ctb
PARAMETER XcNroMes,XcCodOpe,XcNroAst
PRIVATE Xsllave

SELE VMOV
SEEK XcNromes+XcCodOpe+XcNroAst
WAIT WINDOW 'DEPURANDO ASIENTO :'+XcNroAst NOWAIT
IF .NOT. RLock()
	Ok = .F.
	ElimAsto = .F.
	RETURN              && No pudo bloquear registro
ENDIF
SELECT RMOV
XsLlave = (XcNromes + XcCodOpe + XcNroAst )
SEEK XsLlave
OK = .T.
DO WHILE ! EOF() .AND.  ok .AND. (NroMes + CodOpe + NroAst) = XsLlave
   SELECT RMOV
   IF Rlock()
      DO CBDACTCT WITH  CodCta , CodRef ,  VAL(Nromes) , TpoMov , -Import , -ImpUsa , CodDiv
      DELETE
      UNLOCK
   ELSE
      OK = .f.
      ElimAsto = .F.
   ENDIF
   SKIP
ENDDO
SELECT VMOV
IF Ok
   REPLACE DbeNac WITH 0
   REPLACE DbeUsa WITH 0
   REPLACE ChkCta WITH 0
   DELETE
ENDIF
RETURN

******************************************************************************
PROCEDURE OPERULT
******************************************************************************
PRIVATE xN,xR0
SELE RMOV

SEEK XsNroMes+XsCodOpe+CHR(255)
xR0 = RECNO(0)
IF xR0 > 0 .AND. xR0<=RECCOUNT()
   GOTO xR0
   SKIP -1
   IF BOF()
      GO TOP
   ENDIF
   xN = NROAST
ELSE
   xN = IIF(FOUND(),NROAST,'0')
ENDIF
SELE OPER
REPLACE ('NDOC'+XsNroMes) WITH VAL(xN)+1

RETURN



****************************************************************************
PROCEDURE ERRV
****************************************************************************
PARAMETER xMENSJ,xCAMPO,xDATO
INSERT INTO VERROR (NROREF,CAMPO,MENSJ) VALUES (xDATO,xCAMPO,Allt(xMensj))
CntError = CntError + 1

RETURN

****************************************************************************
PROCEDURE DCRHZ
****************************************************************************
PARAMETER xMENSJ,xCAMPO,xDATO
INSERT INTO VDCRHZ (NROREF,CAMPO,MENSJ) VALUES (xDATO,xCAMPO,Allt(xMensj))
CntAstNo = CntAstNo + 1

RETURN

****************************************************************************
FUNCTION LMPTEMP
****************************************************************************
PRIVATE xALIAS,xxLOG
xALIAS = ALIAS()
xxLOG = .F.

SELE TEMPO
IF UPPER(ALIAS())='TEMPO' AND USED('TEMPO')
	ZAP
	xxLOG = .T.
ENDIF

SELE (xALIAS)
RETURN xxLOG


****************************************************************************
FUNCTION ProcDet
****************************************************************************
PRIVATE xLLAVE,xCNTMT,xCTO,xLG,xALIAS
xALIAS = ALIAS()

IF GDOC.FLGEST='A'
	DO DCRHZ WITH 'Documento Anulado','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
	SELE (xALIAS)
	RETURN .F.
ENDIF

IF GDOC.IMPIGV<=0
	DO DCRHZ WITH 'Documento Inafecto','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
	SELE (xALIAS)
	RETURN .F.
ENDIF
xLG = .T.
xCNTMT = 0
xLLAVE = GDOC.CODDOC+GDOC.NRODOC
SELE DETA
SEEK xLLAVE
SCAN WHILE !EOF() AND CODDOC+NRODOC=xLLAVE
*!*		IF !SERV AND !EMPTY(ALLT(CODMAT))
	IF  !EMPTY(ALLT(CODMAT))
		xCNTMT = xCNTMT + 1
		xCTO = ARTCTO(DETA.CODMAT,GDOC.FCHDOC)
		IF xCTO<=0
			DO ERRV WITH 'Articulo con Costo Cero','Codigo:'+DETA.Codmat,XvCodDoc+' '+XvNroDoc
			xLG = .F.
		ELSE
			IF (Deta.CanFac*xCTO)>(DETA.ImpLin*IIF(GDOC.CodMon=1,1,XfTpoCmb))
				DO ERRV WITH 'Articulo con Costo Mayor','Codigo:'+DETA.Codmat,XvCodDoc+' '+XvNroDoc
				xLG = .F.
			ENDIF
		ENDIF
*!*			IF SEEK(PADR(DETA.CODMAT,LEN(FAMI.CODFAM)),'FAMI')
		IF	SEEK(GsClfDiv+PADR(DETA.CODMAT,GnLenDiv),'FAMI')
			DO VERICTA WITH FAMI.CTAC2X,'Existencias'
			DO VERICTA WITH FAMI.CTAC69,'Costo de Ventas'
		ELSE
			*IF EMPTY(ALLT(IIF(SEEK(PADR(DETA.CODMAT,LEN(FAMI.CODFAM)),'FAMI'),FAMI.CTAC2X,'')))
			DO ERRV WITH 'Articulo No Tiene Codigo de Familia','Codigo:'+DETA.Codmat,XvCodDoc+' '+XvNroDoc
			xLG = .F.
		ENDIF
	ENDIF
ENDSCAN
IF xCNTMT<=0
	DO DCRHZ WITH 'Documento No Tiene Articulos - Servicios o Adelantos','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
	SELE (xALIAS)
	RETURN .F.
ENDIF
IF !xLG
	DO ERRV WITH 'Documento con Inconsistencias en los costos','NRODOC:'+XvNroDoc,XvCodDoc+' '+XvNroDoc
	SELE (xALIAS)
	RETURN .F.
ENDIF

SELE (xALIAS)
RETURN .T.

****************************************************************************
PROCEDURE VERICTA
****************************************************************************
PARAMETER nCODCTA,nTexto

IF EMPTY(ALLT(nCODCTA))
	DO ERRV WITH 'Articulo No Tiene Cuenta Contable de '+nTexto,'Codigo:'+DETA.Codmat,XvCodDoc+' '+XvNroDoc
	xLG = .F.
ELSE
	IF SEEK(PADR(nCODCTA,LEN(CTAS.CODCTA)),'CTAS')
		IF CTAS->PidAux="S"
			IF !EMPTY(ALLT(CTAS.CLFAUX))
				IF !SEEK(CTAS.CLFAUX+XvCodAux,'AUXI')
					DO ERRV WITH 'Cuenta Contable Pide Auxiliar, Cliente No Existe '+XvCodAux,'Clasificacion : '+CTAS.CLFAUX,XvCodDoc+' '+XvNroDoc
					xLG = .F.
				ENDIF
			ELSE
				DO ERRV WITH 'Cuenta Contable Pide Auxiliar, Clasificacion Vacia','Cuenta : '+nCODCTA,XvCodDoc+' '+XvNroDoc
				xLG = .F.
			ENDIF
		ENDIF
	ELSE

		DO ERRV WITH 'Cuenta Contable No Existe','Cuenta : '+nCODCTA,XvCodDoc+' '+XvNroDoc
		xLG = .F.
	ENDIF
ENDIF

RETURN

****************************************************************************
FUNCTION ARTCTO
****************************************************************************
PARAMETER vCODMAT,vFCHDOC
*!*	PRIVATE xALIAS,xPRECTO
*!*	xALIAS = ALIAS()

*!*	xPRECTO = 0
*!*	SELE RMOV
*!*	SEEK vCODMAT+DTOS(vFCHDOC+1)
*!*	IF !FOUND()
*!*		IF RECNO(0)>0
*!*			GO RECNO(0)
*!*			IF DELETED()
*!*				SKIP
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF
*!*	SKIP -1
*!*	DO WHILE !BOF() AND CodMat=vCodMat AND FchDoc<=vFchDoc
*!*		IF CODAJT='A' 
*!*			xPRECTO = IIF(STKACT>0,VCTOMN/StkAct,0)
*!*			EXIT
*!*		ENDIF
*!*		SKIP-1
*!*	ENDDO

*!*	SELE (xALIAS)
IF VARTYPE(LoNeg)<>'O'
	
ENDIF
xPRECTO = gocfgalm.costo_almacen(GsCodSed,PADR(vCodMat,XnMaxLong),vFchDoc,1,COSTO_UNIT_ALMACEN) 	
RETURN xPRECTO