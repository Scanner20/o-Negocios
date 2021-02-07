***********************************************************************
*  Nombre        : CJAC2MOV.prg
*  Sistema       : Caja Bancos
*  Autor         : VETT
*  Proposito     : Caja Egresos  ( Giro de Cheques )
*  Creacion      : 17/06/93
***********************************************************************
PARAMETERS __Ing_Egre_Transf
IF PARAMETERS() = 0
	__Ing_Egre_Transf =''	
ENDIF
IF INLIST(__Ing_Egre_Transf,'I','E','T')	
	DO Imprime_Vouchers WITH __Ing_Egre_Transf
ENDIF
PUBLIC VsClfAux
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
SYS(2700,0)  
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
Do FONDO WITH 'EGRESOS DE CAJA  '+cTitulo ,goEntorno.User.Login,GsNomCia,GsFecha

DIMENSION vTpoAst(80),vNroAst(80),vNotAst(80),vImport(80),VECOPC(5)
DIMENSION xCodCta(80),xCodMon(80),xNroRef(80),xCodAux(80),xCodOpe(80),xCodDiv(80),xNroPro(80),xFchPro(80)
DIMENSION vCodCta(80),vCodAux(80),vNroRef(80),vImpCta(80),vTpoMov(80),vCodDoc(80),vCodDiv(80),vCtaPre(80)
* * * *
TsCodDiv1= [01]
K_ESC    = 27
XsCodOpe = "002"     && Caja Egresos
XsCodOp1 = "000"     && Proveedores
* * * *
XnMn_Cart=1
XsNroMes = TRANSF(_MES,"@L ##")
ZiCodMon = 1
ScrMov   = ""
MaxEle1  = 0
MaxEle2  = 0
Crear    = .T.
Modificar= .T.
*
store "" to xscjadiv, xscoddiv,xsclfaux,XsCtaPre
*
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XiNroVou,XsGloAst,XsCaux
STORE "" TO XsCtaCja,XSCODFIN,XfImpChq,XsNroChq,XsGirado,XsCodAux,XsNomAux,XsAuxil,XsCodDo1,XsNroPro,XdFchPro
STORE 0  TO XfImpCh1,XfImpCh2
XdFchAst = DATE()
XdFchPed = XdFchAst
XdFchEnt = XdFchAst
XfTpoCmb = 1.00
NroOpc   = 0
XsCtaCja = '104'
*
STORE {} to XdFchPro
*!*	PATHAPL1 = [\belcsoft\CIA001\]
*
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
RESTORE FROM LoContab.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE

IF VARTYPE(CfgFchFnzSegunAst)='U'
	CfgFchFnzSegunAst = .F.
ENDIF
IF VARTYPE(CfgFchEntSegunAst)='U'
	CfgFchEntSegunAst = .F.
ENDIF
IF VARTYPE(CfgCCostoSegunPrv)='U'
	CfgCCostoSegunPrv = .F.
ENDIF


IF _Dos OR _UNIX
	LinGirado = 19
	LinNota   = 20
ELSE
	LinGirado = 20
	LinNota   = 22
ENDIF


DO MOVgPant
IF !LoContab.MOVApert()
	RELEASE LoContab
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
	SYS(2700,1)  
	RETURN
ENDIF

SELECT PROV
SET FILTER TO TIPO<>"C"  && NO CUENTAS POR COBRAR *******************
LOCATE

SELECT CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
	GsMsgErr = " No Configurado la opción de diferencia de Cambio "
	DO LIB_MERR WITH 99
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
	SYS(2700,1)  
	RETURN
ENDIF
XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
XsProgra = SPACE(5)

LsClfAux = []
LsCodAux = []
LsNroPro = []
LdFchPro = DATE()
UltTecla = 0
LsLastOpe = []
SELE OPER
SET FILTER TO MOVCJA=2
LOCATE

DO WHILE (.t.)
	*-----
	RESTORE SCREEN FROM ScrMov
	SELE OPER
	*----- Control de Egresos de Caja ----* vett 12-abr-2000
*!*		IF !EMPTY(LsLastOpe)
*!*			LOCATE FOR CodOpe=LsLastOpe
*!*		ENDIF
	XsCodOpe=CodOpe
	****
	@ 2,2  SAY "OPERACION: "
	@ 2,12 GET XsCodOpe
	READ
	UltTecla = LASTKEY()
	IF UltTecla = Escape_
		EXIT
	ENDIF
	IF UltTecla = F8
		IF !CBDBUSCA("OPER")
			UltTecla = 0
			LOOP
		ENDIF
		XsCodOpe = OPER->CodOpe
		UltTecla = ENTER
	ENDIF
	SEEK XsCodOpe
	IF !FOUND()
		GsMsgErr = "Operación "+XsCodOpe+" no registrada"
		DO LIB_MERR WITH 99
		LOOP
	ENDIF
*!*		IF EMPTY(LsLastOpe)
*!*			LsLastOpe=XsCodOpe
*!*		ENDIF
*   @ 2,12 SAY XsCodOpe+" "+LEFT(OPER->NomOpe,20)
*   @ 0,0  SAY PADC("* VOUCHER DE EGRESOS *",38) COLOR SCHEME 7
	@ 0,0  SAY PADC(XsCodOpe+" "+LEFT(OPER->NomOpe,20),38) COLOR SCHEME 7
	@ 2,12 SAY XsCodOpe
	*-----
	DO MOVNoDoc
	SELECT VMOV
	DO CASE
		CASE UltTecla = 0
			LOOP
		CASE UltTecla = Escape_
			EXIT
		CASE UltTecla = F9                       && Borrado (Queda Auditado)
			IF ! Modificar
				GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			IF FlgEst = "C"
				GsMsgErr = "Asiento Cerrado, no puede ser alterado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			IF ! Clave(CFGPasswD)
				LOOP
			ENDIF
			DO MOVBorra
		CASE UltTecla = F1  .AND. FlgEst = "A"   && Borrado Definitivo
			IF ! Modificar
				GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			IF ! Clave(CFGPasswD)
				LOOP
			ENDIF
			DO MOVBorra
		OTHER
			IF ! Modificar
				GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			LnImprimir = 0
			IF Crear
				DO MOVInVar
			ELSE
				IF FlgEst = "C"
					GsMsgErr = "Asiento Cerrado, no puede ser alterado"
					DO LIB_MERR WITH 99
					LOOP
				ENDIF
				IF ! Clave(CFGPasswD)
					LOOP
				ENDIF
				SELECT VMOV
				IF ! REC_LOCk(5)
					LOOP
				ENDIF
				DO MOVMover
				LnImprimir = 6  && Si por defecto
				LnImprimir =MESSAGEBOX('Solo desea Imprimir?',4+32,'Atención')
			ENDIF
			IF LnImprimir # 6 OR Crear 
				DO MOVEdita
			ENDIF
			IF UltTecla <> Escape_
				IF LnImprimir # 6 OR Crear 
					DO MOVGraba
				ENDIF
				IF UltTecla <> Escape_
					DO FORM cja_cjatiprp WITH XsCtaCja && Para controlar el formato por cuenta y banco
					
*!*						@ 10,28 CLEAR TO 15,59
*!*						@ 10,28 TO 15,59
*!*						xElige = 3
*!*						VECOPC(1) = " ** VOUCHER - Hoja Completa **** "
*!*						VECOPC(2) = " ************ CARTAS *********** "
*!*						VECOPC(3) = " ******** CHEQUE-VOUCHER ******* "
*!*						VECOPC(4) = " **** VOUCHER - Media Hoja ***** "
*!*						VECOPC(5) = " ******** CHEQUEVOUCHER ******** "
*!*						xElige = Elige(xElige,12,30,5)
*!*						IF LASTKEY() <> Escape_
*!*							IF xElige=2
*!*	*!*								XnMn_Cart=XnCodMon
*!*	*!*								DO Cjas2mov.spr
*!*							ENDIF
*!*							IF INLIST(XELIGE,1,4)
*!*								DO F0PRINT &&IN ADMPRINT
*!*							ENDIF
*!*							DO CASE
*!*								CASE XElige = 1
*!*									DO MovPrint
*!*								CASE XElige = 2
*!*									DO MovPrin2
*!*								CASE XElige = 3
*!*									IF MESSAGEBOX('Coloque el CHEQUE en la impresora, Continuar?',4+64,'Aviso')=6 
*!*										DO MovPrin3
*!*									ENDIF
*!*									IF MESSAGEBOX('Coloque papel para VOUCHER, Continuar?',4+64,'Aviso')=6 
*!*										DO MovPrin4
*!*									ENDIF
*!*								CASE XElige = 4
*!*									DO MovPrin4
*!*								CASE XElige = 5
*!*									DO MovPrin5 && esto es con la otra libreria
*!*							ENDCASE
*!*						ENDIF
*!*						SET DEVICE TO SCREEN
				ENDIF
			ENDIF
	ENDCASE
	UNLOCK ALL
ENDDO

CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
LoConTab.odatadm.close_file('CJA')
LoConTab.odatadm.close_file('CCB_CJA')
RELEASE LoContab 
SYS(2700,1)  
RETURN

******************
PROCEDURE IMPRIMIR
******************
DO F0PRINT &&IN ADMPRINT
IF LASTKEY() # Escape_
DO MovPrint
ENDIF
SET DEVICE TO SCREEN
RETURN

************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
*!*	PROCEDURE MOVAPERT
*!*	******************
*!*	** Abrimos areas a usar **
*!*	SELECT 1
*!*	USE CBDTCIER
*!*	RegAct = _Mes + 1
*!*	Modificar = .T.
*!*	IF RegAct <= RECCOUNT()
*!*		GOTO RegAct
*!*		Modificar = ! (Cierre  .OR. CjaBco)
*!*	ENDIF
*!*	SELE 1
*!*	USE cbdmctas ORDER ctas01   ALIAS CTAS
*!*	IF ! USED(1)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 2
*!*	USE cbdmauxi ORDER auxi01   ALIAS AUXI
*!*	IF ! USED(2)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 3
*!*	USE cbdvmovm ORDER vmov01   ALIAS VMOV
*!*	IF ! USED(3)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 4
*!*	USE cbdrmovm ORDER rmov01   ALIAS RMOV
*!*	IF ! USED(4)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 5
*!*	USE cbdmtabl ORDER tabl01   ALIAS TABL
*!*	IF ! USED(5)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 6
*!*	USE cbdtoper ORDER oper01   ALIAS OPER
*!*	IF ! USED(6)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 7
*!*	USE cbdacmct ORDER acct01   ALIAS ACCT
*!*	IF ! USED(7)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 8
*!*	USE admmtcmb ORDER tcmb01   ALIAS TCMB
*!*	IF ! USED(8)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 9
*!*	USE CJATPROV ORDER prov01   ALIAS PROV
*!*	IF ! USED(9)
*!*	*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SET FILTER TO TIPO<>"C"  && NO CUENTAS POR COBRAR *******************
*!*	*
*!*	lopDIAF=.f.
*!*	lexiste=.t.
*!*	SELE 0
*!*	m.file1=pathdef+"\cia"+gscodcia+"\flcjtbdf.dbf"
*!*	IF !FILE(m.file1)
*!*		m.file1="\"+M.DIR_SIST2+"\cia"+gscodcia+"\flcjtbdf.dbf"	
*!*		IF !FILE(m.file1)
*!*			m.file1="\"+M.DIR_SIST3+"\cia"+gscodcia+"\flcjtbdf.dbf"	
*!*			IF !FILE(m.file1)
*!*				lexiste=.f.
*!*			endif		
*!*	 	ENDIF
*!*	ENDIF
*!*	**
*!*	if lexiste
*!*		sele 0
*!*		use (m.file1) order diaf01 alias diaf
*!*		if !used()
*!*		   close data
*!*		   return
*!*		endif
*!*		lopDIAF=.t.
*!*	endif
*!*	*
*!*	*ArcDbf = PATHapl1+[flcjdocp]
*!*	*sele 11
*!*	*use (ArcDbf) order ddoc05 alias docs
*!*	*if !used(11)
*!*	*    close data
*!*	*    return
*!*	*endif
*!*	*
*!*	SELECT RMOV
*!*	RETURN

************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
*@ 0,0  SAY PADC("* VOUCHER DE EGRESOS *",38) COLOR SCHEME 7
*@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 6,79
@ 1,50 SAY "N§ COMPROBANTE.:" COLOR SCHEME 11
@ 2,50 SAY "N§ RELACION....:" COLOR SCHEME 11
@ 3,50 SAY "FECHA..........:" COLOR SCHEME 11
@ 3,00 SAY "CUENTA..:" COLOR SCHEME 11
@ 5,00 SAY "TD.:     N§:" COLOR SCHEME 11
@ 6,00 SAY "FCH. DE ENT.:" COLOR SCHEME 11

IF gocfgcbd.TIPO_CONSO = 2
	@ 6,25 SAY [DIV.:] COLOR SCHEME 11
ENDIF

DO CASE
CASE gocfgcbd.C_COSTO = 3
	@ 5,30 SAY "C.COSTO:" COLOR SCHEME 11
CASE gocfgcbd.C_COSTO = 2 
	@ 5,30 SAY "C.COSTO:" COLOR SCHEME 11
CASE gocfgcbd.C_COSTO = 1	
	@ 5,30 SAY "C.COSTO:" COLOR SCHEME 11
OTHER
	@ 5,30 SAY "AUXIL:  " COLOR SCHEME 11
ENDCASE


@ 4,50 SAY "T/CAMBIO.......:" COLOR SCHEME 11
@ 5,50 SAY "FCH.DE FINANZAS:" COLOR SCHEME 11
@ 7,00 TO 11,79
@ 7,01 SAY "ð Tipo ð N§  PROV.ð         C O N C E P T O                ð         IMPORTE ð" COLOR SCHEME 7

@ 12,00 TO 17,79+20 COLOR SCHEME 11
*@12,01 SAY "ðCTAS.ð      C O N C E P T O       ð AUXI.ð TD.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
@ 12,01 SAY "DV -CTAS.-   C O N C E P T O       ð AUXI.     ð TD.ðN§  DOCTO.ð          IMPORTE ðPROYECTO      ð" COLOR SCHEME 7
*
IF _dos 

	@ 18,00 SAY "IMPORTE....:" COLOR SCHEME 11
	@ 19,00 SAY "GIRADO A...:" COLOR SCHEME 11
	@ 20,00 SAY "CONCEPTO...:" COLOR SCHEME 11
	@ 21,00 SAY "PROVEEDOR..:" COLOR SCHEME 11

ELSE

	@ 18,00 SAY "IMPORTE....:" COLOR SCHEME 11
	@ 20,00 SAY "GIRADO A...:" COLOR SCHEME 11
	@ 22,00 SAY "CONCEPTO...:" COLOR SCHEME 11
	@ 24,00 SAY "PROVEEDOR..:" COLOR SCHEME 11

ENDIF
SAVE SCREEN TO SCRMOV
RETURN

************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
i = 1
XsNroAst = LoContab.NROAST()
*RESTORE SCREEN FROM ScrMov
Crear = .t.
** Posicionamos en el ultimo registro + 1 **

SELECT VMOV
SEEK (XsNroMes+XsCodOpe+Chr(255))
IF RECNO(0) > 0
	GOTO RECNO(0)
ELSE
	GOTO BOTTOM
	IF ! EOF()
		SKIP
	ENDIF
ENDIF
UltTecla = 0
DO LIB_MTEC WITH 2
DO WHILE ! INLIST(UltTecla,Enter,Escape_)
	@ 1,68 GET XsNroAst PICT "99999999"
	READ
	UltTecla = LASTKEY()
	IF UltTecla = F8
		IF CBDBUSCA("VMOV")
			XsNroAst = VMOV->NroAst
		ELSE
			LOOP
		ENDIF
		UltTecla = Enter
	ENDIF
	SELECT VMOV
	Llave = (XsNroMes+XsCodOpe+XsNroAst)
	DO CASE
		CASE UltTecla = Escape_
			EXIT
		CASE UltTecla = 0
			LOOP
		CASE UltTecla = F9
			IF LLave = (NroMes + CodOpe + NroAst) .AND. VMOV->FlgEst<>"A"
				IF ALRT("Anular este Documento")
					UltTecla = F9
					EXIT
				ENDIF
			ELSE
				SEEK LLave
				IF ! FOUND()
					DO LIB_MERR WITH 9
					UltTecla = 0
				ELSE
					IF VMOV->FlgEst <> "A"
						IF ALRT("Anular este Documento")
							UltTecla = F9
							EXIT
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		CASE UltTecla = F1
			IF Llave = (NroMes + CodOpe + NroAst) .AND. VMOV->FlgEst="A"
				EXIT
			ENDIF
			SEEK Llave
			IF ! FOUND()
				DO LIB_MERR WITH 9
				UltTecla = 0
			ELSE
				IF VMOV->FlgEst = "A"
					EXIT
				ENDIF
			ENDIF
		CASE UltTecla = PgUp                    && Anterior Documento
			IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe)
				SEEK (XsNroMes+XsCodOpe+Chr(255))
				IF RECNO(0) > 0
					GOTO RECNO(0)
				ELSE
					GOTO BOTTOM
				ENDIF
				IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe)
					SKIP -1
				ENDIF
			ELSE
				IF ! BOF()
					SKIP -1
				ENDIF
			ENDIF
		CASE UltTecla = PgDn  .AND. ! EOF()     && Siguiente Documento
			SKIP
		CASE UltTecla = Home                    && Primer Documento
			SEEK (XsNroMes+XsCodOpe)
		CASE UltTecla = End                     && Ultimo Documento
			SEEK (XsNroMes+XsCodOpe+Chr(255))
			IF RECNO(0) > 0
				GOTO RECNO(0)
				SKIP -1
			ELSE
				GOTO BOTTOM
			ENDIF
		OTHER
			IF XsNroAst < LoContab.NROAST()
				IF Llave = (NroMes + CodOpe + NroAst) .AND. VMOV->FlgEst<>"A"
					EXIT
				ENDIF
				SEEK LLave
				IF ! FOUND() .AND. UltTecla = CtrlW
					RESTORE SCREEN FROM ScrMov
					Crear = .t.
					EXIT
				ENDIF
				IF ! FOUND()
					DO LIB_MERR WITH 9
					UltTecla = 0
				ELSE
					IF VMOV->FlgEst = "A"
						DO FORM cja_cjatiprp && MAAV
*!*							DO LIB_MERR WITH 14
*!*							UltTecla = 0
*!*							@ 10,28 CLEAR TO 14,59
*!*							@ 10,28 TO 14,59
*!*							XELIGE = 4
*!*							VECOPC(1) = " ******** VOUCHER ********* "
*!*							VECOPC(2) = " ********* CARTAS ********* "
*!*							VECOPC(3) = " ***** CHEQUE-VOUCHER ***** "
*!*							VECOPC(4) = " **** VOUCHER ESPECIAL **** "
*!*							VECOPC(5) = " ***** CHEQUEVOUCHER ****** "
*!*							XELIGE = ELIGE(XELIGE,12,50,5)
*!*							IF LASTKEY() <> ESCAPE_
*!*								DO F0PRINT &&IN ADMPRINT
*!*								IF XELIGE = 1
*!*									DO MOVPRINT
*!*								ELSE
*!*									IF XELIGE=2
*!*										DO MOVPRIN2
*!*									ELSE
*!*										IF XELIGE=3
*!*											DO MOVPRIN3
*!*										ELSE
*!*											IF XElige = 4
*!*												DO MOVPRIN4
*!*											ELSE
*!*												DO MOVPRIN5 && esto es con la otra liberia
*!*											ENDIF
*!*										ENDIF
*!*									ENDIF
*!*								ENDIF
*!*							ENDIF
*!*							SET DEVICE TO SCREEN
					ENDIF
				ENDIF
			ENDIF
	ENDCASE
	IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
		XsNroAst = LoContab.NROAST()
		RESTORE SCREEN FROM ScrMov
		DO LIB_MTEC WITH 2
		Crear = .t.
	ELSE
		XsNroAst = VMOV->NroAst
		DO MovPinta
		Crear = .f.
	ENDIF
ENDDO
@ 0,0  SAY PADC(XsCodOpe+" "+LEFT(OPER->NomOpe,20),38) COLOR SCHEME 7
@ 1,68 SAY XsNroAst
SELECT VMOV
IF UltTecla= Escape_
	UltTecla = 0
ENDIF
RETURN

************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
MaxEle1  = 0
MaxEle2  = 0
XnCodMon = 1
*XsProgra = SPACE(LEN(VMOV->PROGRA))
XsNotAst = SPACE(LEN(VMOV->NOTAST))
XsGirado = SPACE(LEN(VMOV->Girado))
XsGloAst = ""
IF YEAR(DATE()) = _Ano .AND. MONTH(DATE()) = _Mes
	XdFchAst = DATE()
ELSE
	XdFchAst = GdFecha
ENDIF
XdFchPed = XdFchAst
XsDigita = GsUsuario
XsCtaCja = PADR('104',LEN(RMOV.CODCTA)) && SPACE(LEN(RMOV->CODCTA))
xscjadiv = space(len(rmov->coddiv))
XiNroVou = OPER->NroRel
XfImpChq = 0
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = SPACE(LEN(VMOV->NroChq))
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsNroPro = SPACE(LEN(RMOV->NroPro))
XdFchPro = XdFchAst
XsAuxil  = Auxil
XsNomAux = SPACE(LEN(AUXI->NomAux))
RETURN

************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVMover
XnCodMon = VMOV->CodMon
XsNotAst = VMOV->NOTAST
XsGirado = VMOV->Girado
XsGloAst = VMOV->GloAst
XdFchAst = VMOV->FchAst
XdFchPed = VMOV->FchPed
XdFchEnt = VMOV->FchEnt && NUEVO
XsDigita = GsUsuario
XsCtaCja = CtaCja
XiNroVou = VAL(NroVou)
XfImpChq = ImpChq
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = VMOV->NroChq
XfTpoCmb = VMOV->TpoCmb
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsNomAux = SPACE(LEN(AUXI->NomAux))
XsNroPro = SPACE(LEN(RMOV->NroPro))
XdFchAst = VMOV->FchAst
XsAuxil  = Auxil
*!* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS
xscjadiv = space(len(rmov.coddiv))
sele rmov
set order to rmov07
seek (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
if found()
	xscjadiv = rmov.coddiv
endif
set order to rmov01
sele vmov
RETURN

************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
*!* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS
xscjadiv = space(len(rmov.coddiv))
sele rmov
set order to rmov07
seek (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
if found()
	xscjadiv = rmov.coddiv
endif
set order to rmov01
sele vmov

IF gocfgcbd.TIPO_CONSO = 2
	@06,30 say xscjadiv
	@06,33 say iif(seek([DV ]+xscjadiv,[auxi]),left(auxi.nomaux,7),space(07))
ENDIF

=SEEK(CtaCja,"CTAS")
@ 01,68 SAY NroAst
IF CtaCja = "104"
	@ 02,2  SAY " ****** CUENTAS CORRIENTES ******* "
ELSE
	IF CtaCja = "108"
		@ 02,2  SAY " ****** CUENTAS DE AHORRO ******** "
	ELSE
		@ 02,2  SAY " ****** CUENTAS DE CAJA ******** "
	ENDIF
ENDIF
@ 02,68 SAY NroVou
@ 03,68 SAY FchAst PICT '@RD dd/mm/aa'
@ 05,68 SAY FchPed PICT '@RD dd/mm/aa'
@ 03,10 SAY CtaCja+" "+CTAS->NomCta pict "@S38"
@ 04,00 SAY "N§CUENTA: "+SUBSTR(CTAS->NroCta,1,15)
@ 05,12 SAY NroChq
@ 06,13 SAY VMOV.FCHENT PICT '@RD dd/mm/aa'
@ 05,38 SAY Auxil
@ 4 ,68 SAY TpoCmb PICT "9999.9999"
IF VMOV->CodMon = 1
	XnCodMon = 1
	@ 18,14 say "S/. "
ELSE
	XnCodMon = 2
	@ 18,14 say "US$ "
ENDIF
@  8,01 CLEAR TO 10,78
@ 13,01 CLEAR TO 16,78+20
LinAct1 = 8
LinAct2 = 13
IF VMOV->FlgESt = "A"
	@ LinAct1,0 say []
	@ ROW()  ,11 SAY "     #    #    #  #    # #         #    #####   ######  "
	@ ROW()+1,11 SAY "   #####  # #  #  #    # #       #####  #    #  #    #  "
	@ ROW()+1,11 SAY "  #     # #   ##  ###### ###### #     # #####   ######  "
ENDIF
**** Buscando Datos Ventana 1 ****
SELECT RMOV
LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
XsCodAux = ""
SEEK LsLLave
MaxEle1 = 0
MaxEle2 = 0
IF _DOS OR _UNIX
	@ 21,14 SAY SPACE(LEN(RMOV->CodAux))
	@ 21,22 SAY SPACE(50)
ELSE
	@ 24,14 SAY SPACE(LEN(RMOV->CodAux))
	@ 24,22 SAY SPACE(50)
ENDIF
	
Ancho    = 74
Xo       = INT((80 - Ancho)/2)
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
	DO CASE
		CASE EliItm = CHR(43)      
			IF MaxEle1 >= 80
				SKIP
				LOOP
			ENDIF
			XfImport = IIF(TpoMov="D",1,-1)*Import
			XfImpUsa = IIF(TpoMov="D",1,-1)*ImpUsa
			IF EMPTY(XsCodAux)
				XsCodAux = CodAux
				XsClfAux = ClfAux
				@ IIF(_Dos or _UNIX,21,24),14 SAY XsCodAux
				=SEEK(XsClfAux+XsCodAux,"AUXI")
				XsNomAux = AUXI->NomAux
				@ IIF(_Dos or _UNIX,21,24),26 SAY AUXI->NomAux PICT "@S60"
			ENDIF
			MaxEle1= MaxEle1+ 1
			*** Revisar ***
			vNroAst(MaxEle1) = NroDoc
			vTpoAst(MaxEle1) = CodDoc
			vNotAst(MaxEle1) = GloDoc
			xCodCta(MaxEle1) = CodCta
			xCodMon(MaxEle1) = CodMon
			xNroRef(MaxEle1) = NroREf
			xCodAux(MaxEle1) = CodAux
			xcoddiv(maxele1) = coddiv
			xNroPro(MaxEle1) = NroPro
			xFchPro(MaxEle1) = FchPro
			IF VMOV->CodMon = 1
				vImport(MaxEle1) = XfImport
			ELSE
				vImport(MaxEle1) = XfImpUsa
			ENDIF
			IF LinAct1 < 11
				DO GENbline WITH MaxEle1, LinAct1
				LinAct1 = LinAct1 + 1
			ENDIF
		CASE EliItm = "-" .AND. MaxEle1 > 0
			IF MaxEle1 >= 80
				SKIP
				LOOP
			ENDIF
			IF VMOV->CodMon = 1
				vImport(MaxEle1) = vImport(MaxEle1)+IIF(TpoMov="D",1,-1)*Import
			ELSE
				vImport(MaxEle1) = vImport(MaxEle1)+IIF(TpoMov="D",1,-1)*ImpUsa
			ENDIF
			IF MaxEle1 < 6
				DO GENbline WITH MaxEle1, LinAct1-1
			ENDIF
		CASE ! INLIST(EliItm,".","*")     
			IF MaxEle2 >= 80
				SKIP
				LOOP
			ENDIF
			MaxEle2 = MaxEle2 + 1
			=SEEK(CodCta,"CTAS")
			vCodCta(MaxEle2) = CodCta
			IF EMPTY(XsCodAux) .AND. CTAS->PIDAUX="S"
				XsCodAux = CodAux
				XsClfAux=  ClfAux
				@ IIF(_Dos or _UNIX,21,24),14 SAY XsCodAux
				XsNomAux = AUXI->NomAux
				=SEEK(XsClfAux+XsCodAux,"AUXI")
				@ IIF(_Dos or _UNIX,21,24),26 SAY AUXI->NomAux PICT "@S60"
			ENDIF
			vcoddiv(maxele2) = coddiv
			vCodAux(MaxEle2) = CodAux
			vNroRef(MaxEle2) = NroDoc
			vCodDoc(MaxEle2) = CodDoc
			vTpoMov(MaxEle2) = TpoMov
			vCtaPre(MaxEle2) = CtaPre
			IF VMOV->CodMon = 1
				vImpCta(MaxEle2) = Import
			ELSE
				vImpCta(MaxEle2) = ImpUsa
			ENDIF
			IF LinAct2 < 17
				DO GENblin2 WITH MaxEle2, LinAct2
				LinAct2 = LinAct2 + 1
			ENDIF
		CASE INLIST(EliItm,".")
			XsCodDo1 = RMOV->CodDoc
			@ 5,04 SAY XsCodDo1
	ENDCASE
	SELECT RMOV
	SKIP
ENDDO
XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAux))
SELECT VMOV

IF _dos OR _Unix
	@ 18 ,18 SAY VMOV->ImpChq PICT "99,999,999,999.99"
	@ 19 ,14 SAY PADR(VMOV->Girado,70) FONT "Tahoma",7 STYLE 'B' 
	@ 20 ,14 SAY VMOV->NotAst
*	@ 22 ,14 SAY "OPERACION CONTABLE : "+VMOV->CODOPE
ELSE
	@ 18 ,18 SAY VMOV->ImpChq PICT "99,999,999,999.99"
	@ 20 ,14 SAY PADR(VMOV->Girado,70) FONT "Tahoma",7 STYLE 'B' 
	@ 22 ,14 SAY VMOV->NotAst
*	@ 24 ,14 SAY "OPERACION CONTABLE : "+VMOV->CODOPE
ENDIF
RETURN

************************************************************************** FIN
FUNCTION NROAST
****************
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
IF OPER->ORIGEN
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
RETURN  RIGHT("00000000" + LTRIM(STR(iNroDoc)), 8)

************************************************************************** FIN
* Procedimiento que edita las variables de cabezera
******************************************************************************
PROCEDURE MOVEdita
IF _Dos OR _UNIX
	LinGirado = 19
	LinNota   = 20
ELSE
	LinGirado = 20
	LinNota   = 22
ENDIF
IF Crear
	IF ! (YEAR(DATE()) = _Ano .AND. MONTH(DATE()) = _Mes)
		IF ! ALRT("Fecha no corresponde al mes de Trabajo")
			UltTecla = Escape_
			RETURN
		ENDIF
	ENDIF
ENDIF
LlBuscaCTA10X = .F.
UltTecla = 0
I        = 1
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
	DO CASE
		CASE  i = 1
        *SELE OPER
        *@ 2,2  SAY "OPERACION: "
        *@ 2,12 GET XsCodOpe
        *READ
        *UltTecla = LASTKEY()
        *IF UltTecla = F8
        *   IF !CBDBUSCA("OPER")
        *      UltTecla = 0
        *      LOOP
        *   ENDIF
        *   XsCodOpe = OPER->CodOpe
        *   UltTecla = ENTER
        *ENDIF
        *SEEK XsCodOpe
        *IF !FOUND()
        *   GsMsgErr = "Operaci¢n inv lida"
        *   DO LIB_MERR WITH 99
        *   LOOP
        *ENDIF
        *@ 2,12 SAY XsCodOpe+" "+LEFT(OPER->NomOpe,20)
        *SELE VMOV
			UltTecla = Enter
		CASE I = 2
			@ 2 ,68 GET XiNroVou PICT "@L 999999"
			READ
			UltTecla = LastKey()
			@ 2 ,68 SAY XiNroVou PICT "@L 999999"
		CASE I = 3
			@ 3,68 GET XdFchAst PICT '@RD dd/mm/aa'
			READ
			UltTecla = LastKey()
			@ 3,68 SAY XdFchAst PICT '@RD dd/mm/aa'
			IF Crear
				XdFchPed = XdFchAst
				XdFchEnt = XdFchAst
				@ 5 ,68 SAY XdFchPed PICT '@RD dd/mm/aa'
				@ 6 ,13 SAY XdFchEnt PICT '@RD dd/mm/aa'
			ENDIF
			
		CASE I = 4
			IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
				?? CHR(7)
				WAIT "No Registrado el tipo de Cambio" NOWAIT WINDOW
			ENDIF
			&& VETT 22-05-2005 , Igual que en el Diario General
			IF Crear
				XfTpoCmb = iif(OPER.TpoCmb=1,TCMB.OFICMP,TCMB.OFIVTA)
			ELSE
				IF XdFchAst<>VMOV.FchAst
					XfTpoCmb = iif(OPER.TpoCmb=1,TCMB.OFICMP,TCMB.OFIVTA)
				ENDIF
			ENDIF
			@ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
			READ
			UltTecla = LastKey()
			@ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
			IF UltTecla = Escape_
				EXIT
			ENDIF
		CASE I = 5 AND !CfgFchFnzSegunAst
			@ 5 ,68 GET XdFchPed PICT '@RD dd/mm/aa'
			READ
			UltTecla = LastKey()
			IF USED('DIAF')
				if inlist(xscodope,[021],[038],[020],[036]) && LETRAS
					sele diaf
					seek dtos(XdFchPed)
					if found()
						XdFchPed = FchVen
					endif
				ENDIF
			ENDIF
			@ 5 ,68 SAY XdFchPed PICT '@RD dd/mm/aa'
		CASE I = 6
			DO CASE
				CASE XsCtaCja = "104"
					xElige = 1
				CASE XsCtaCja = "108"
					xElige = 2
				OTHERWISE
					xElige = 3
			ENDCASE
			VECOPC(1) = " ***** CUENTAS CORRIENTES ******** "
			VECOPC(2) = " ***** CUENTAS DE AHORRO  ******** "
			VECOPC(3) = " ******  CUENTAS DE CAJA  ******** "
*!*				xElige = Elige(xElige,2,2,3)
			DO CASE
				CASE XElige  = 1
					cCodCta = "104"
				CASE XElige  = 2
					cCodCta = "108"
				CASE XElige  = 3
					cCodCta = "101"
			ENDCASE
			IF !LlBuscaCTA10X 
				KEYBOARD '{ENTER}' 
			ELSE
				SELECT CTAS 
				SET FILTER TO NivCta=2 AND CodCta='10'
				LOCATE	
			ENDIF
			
			@ 03,10 GET cCodCta PICTURE REPLICATE("9",LEN(cCOdCta)) VALID _vlook_cja(@cCodCta,'CodCta','CTA10X','CTAS')
			READ
			UltTecla = LASTKEY()
*!*				IF UltTecla = Escape_
*!*					EXIT
*!*				ENDIF
			cCodCta = PADR(cCodCta,3)			
			LlBuscaCTA10X = .F.
			SELECT CTAS
			SET FILTER TO 
		CASE I = 7
			GsMsgKey = " [Enter] Aceptar  [Esc] Cancela [F7] Tipo Cuenta   [F8] Buscar "
			DO LIB_MTEC WITH 99
			SELECT CTAS
			IF xElige <= 3
				zCodCta = SUBSTR(XsCtaCja,4)
				@ 03,10 SAY cCodCta PICTURE REPLICATE("9",LEN(cCOdCta)) 
				@ 03,13 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-3)
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					EXIT
				ENDIF
				XsCtaCja = cCodCta+zCodCta
			ELSE
				zCodCta = SUBSTR(XsCtaCja,3)
				@ 03,10 SAY cCodCta
				@ 03,12 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-2)
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					EXIT
				ENDIF
				XsCtaCja = cCodCta+zCodCta
			ENDIF
			IF UltTecla = F7
				LlBuscaCTA10X  = .T.
				UltTecla = 0
				i=6
				LOOP
				
			ENDIF
			IF UltTecla = F8
				IF ! CBDBUSCA("CTAX")
					LOOP
				ENDIF
				XsCtaCja = CodCta
				UltTecla = Enter
			ENDIF
			SEEK XsCtaCja
			IF ! FOUND()
				GsMsgErr = "Cuenta no Registrada"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			IF AFTMOV="N"
				GsMsgErr = "Cuenta no Afecta a Movimiento"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ 03,10 SAY XsCtaCja+" "+NomCta pict "@S38"
			@ 04,00 SAY "N§CUENTA: "+SUBSTR(NroCta,1,15)
			IF Crear
				XsNroChq = PADR(NroChq,LEN(XsNroChq))
			ENDIF
			IF CTAS->CodMon = 1
				XnCodMon = 1
				@ 18,14 say "S/. "
			ELSE
				XnCodMon = 2
				@ 18,14 say "US$ "
			ENDIF
			IF Crear
				XsCodDo1 = "CH"
			ENDIF
				@ 05,04 SAY XsCodDo1
				@ 05,12 SAY XsNroChq
				@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
				
			DO LIB_MTEC WITH 7	
   ** CASE I = 8
   **    SELECT AUXI
   **    XSCLFAUX  = "99 "
   **    @ 04,33 SAY "             "
   **    @ 04,26 SAY "N§Fin:"
   **    @ 04,33 GET XSCODFIN PICT "@!"
   **    READ
   **    UltTecla = LASTKEY()
   **    IF UltTecla = Escape_
   **       LOOP
   **    ENDIF
   **    IF UltTecla = F8
   **       IF ! CBDBUSCA("FINA")
   **          LOOP
   **       ENDIF
   **       XSCODFIN = AUXI->CODAUX
   **       ULTTECLA = ENTER
   **    ENDIF
   **    SEEK XSCLFAUX+XSCODFIN
   **    IF ! FOUND()
   **       DO Lib_MErr WITH 9 && no registrado
   **       UltTecla = 0
   **       LOOP
   **    ENDIF
   **    @ 04,33 SAY XSCODFIN+" "+SUBSTR(AUXI->NOMAUX,1,12)
		CASE I = 9  && .AND. EMPTY(XsNroChq)
			sele tabl
			XsTabla = "02"
			@ 05,04 GET XsCodDo1 PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = F8
				IF !CBdBusCa("TABL")
					UltTecla = 0
					LOOP
				ENDIF
				XsCodDo1 = LEFT(TABL->Codigo,3)
			ENDIF
			SEEK XsTabla+XsCodDo1
			IF !FOUND() AND !EMPTY(XsCodDo1)
				GsMsgErr = "Código de documento inv lido"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ 05,04 SAY XsCodDo1 PICT "@!"
		CASE I = 10  && .AND. EMPTY(XsNroChq)
			@ 05,12 GET XsNroChq PICT "@!"
			READ
			UltTecla = LASTKEY()
			@ 05,12 SAY XsNroChq
		CASE I = 11 AND !CfgFchEntSegunAst
			@ 6,13 GET XdFchEnt PICT '@RD dd/mm/aa'
			READ
			UltTecla = LastKey()
			@ 6,13 SAY XdFchEnt PICT '@RD dd/mm/aa'
		CASE I = 12 AND !CfgCCostoSegunPrv

			DO CASE 
			
				CASE gocfgcbd.C_COSTO = 1
					XsClfAux=PADR(GsClfCCt,LEN(AUXI.ClfAux))
					SELE AUXI
					@ 05,38 GET XsAuxil  PICT "@!"
					READ
					UltTecla = LASTKEY()
					IF UltTecla = Escape_
						Exit
					ENDIF
					IF UltTecla = F8
						SEEK XsClfAux+TRIM(XsAuxil )
						IF ! CBDBUSCA("AUXI")
							UltTecla = 0
							LOOP
						ENDIF
						XsAuxil  = AUXI->CodAux
					ENDIF
					XsAuxil=PADR(XsAuxil,LEN(AUXI->CodAux))
					SEEK XsClfAux+XsAuxil
					IF !FOUND()
						GsMsgErr = "C¢digo no existe"
						DO LIB_MERR WITH 99
						UltTecla = 0
						LOOP
					ENDIF
					@ 05,38 SAY XsAuxil  PICT "@!"
				CASE gocfgcbd.C_COSTO = 2
														
				CASE gocfgcbd.C_COSTO = 3
						XsTabla=PADR(GsClfCct,LEN(TABL.Tabla))
						SELE TABL
						@ 05,38 GET XsAuxil  PICT "@!"
						READ
						UltTecla = LASTKEY()
						IF UltTecla = Escape_
							Exit
						ENDIF
						IF UltTecla = F8
							SEEK XsTabla+TRIM(XsAuxil )
							IF ! CBDBUSCA("TABL")
								UltTecla = 0
								LOOP
							ENDIF
							XsAuxil  = TABL->Codigo
						ENDIF
						XsAuxil=PADR(XsAuxil,LEN(TABL.Codigo))
						SEEK XsTabla+XsAuxil
						IF !FOUND()
							GsMsgErr = "C¢digo no existe"
							DO LIB_MERR WITH 99
							UltTecla = 0
							LOOP
						ENDIF
						@ 05,38 SAY XsAuxil  PICT "@!"

				OTHER
					IF CTAS->PIDAUX="S"
						XsClfAux=CTAS.ClfAux
						SELE AUXI
						@ 05,38 GET XsAuxil  PICT "@!"
						READ
						UltTecla = LASTKEY()
						IF UltTecla = Escape_
							Exit
						ENDIF
						IF UltTecla = F8
							SEEK XsClfAux+TRIM(XsAuxil )
							IF ! CBDBUSCA("AUXI")
								UltTecla = 0
								LOOP
							ENDIF
							XsAuxil  = AUXI->CodAux
						ENDIF
						SEEK XsClfAux+XsAuxil
						IF !FOUND()
							GsMsgErr = "C¢digo no existe"
							DO LIB_MERR WITH 99
							UltTecla = 0
							LOOP
						ENDIF
						@ 05,38 SAY XsAuxil  PICT "@!"
					ENDIF

			ENDCASE
		CASE I = 13   &&& PIDE DIVISIONARIA
			IF gocfgcbd.TIPO_CONSO = 2
				SELE AUXI
				@ 06,30 GET XsCjaDiv PICT "XX"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					LOOP
				ENDIF
				IF UltTecla = F8
					TsClfAuxAc = XsclfAux
					XsClfAux = [DV ]  && Divisionarias
					IF ! CBDBUSCA("AUXI")
						LOOP
					ENDIF
					XsCjaDiv = PADR(AUXI.CodAux,LEN(RMOV.CodDiv))
					XsClfAux = TsClfAuxAc
				ENDIF
				SEEK [DV ]+XsCjaDiv
				IF !FOUND()
					GsMsgErr = [Codigo de divisionaria invalido]
					DO LIB_MERR WITH 99
					UltTecla=0
					Loop
				ENDIF
				@ 06,30 SAY XsCjaDiv PICT "XX"
				@ 06,33 say left(auxi.nomaux,7)
			ENDIF
		CASE I = 14
			DO COMPROBAN
			XfImpCh1 = 0
			FOR ii = 1 to MaxEle1
				XfImpCh1 = XfImpCh1 + vImport(ii)
			ENDFOR
			XfImpChq = XfImpCh1 + XfImpCh2
			@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
			IF LASTKEY() = Escape_
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
		CASE I = 15
			DO VOUCHER
			XfImpCh2 = 0
			FOR ii = 1 to MaxEle2
				XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
			ENDFOR
			XfImpChq = XfImpCh1 + XfImpCh2
			@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
			IF LASTKEY() = Escape_
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
			IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
				XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
				XsGirado = PADR("*** CHEQUE ANULADO ***",LEN(XsGirado))
				@ 19, 14 SAY PADR(XsGirado,70) PICT "@!" FONT "Tahoma",9 STYLE 'B'
				@ 20, 14 SAY XsNotAst PICT "@!"
			ENDIF
		CASE I = 16
			@ LinGirado, 14 GET XsGirado PICT "@!" FONT "Tahoma",9 STYLE 'B'
			READ
			UltTecla = LastKey()
			@ LinGirado, 14 SAY PADR(XsGirado,70) PICT "@!" FONT "Tahoma",9 STYLE 'B'
		CASE I = 17
			IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
				XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
			ENDIF
			@ LinNota, 14 GET XsNotAst PICT "@!"
			READ
			UltTecla = LastKey()
			@ LinNota, 14 SAY XsNotAst PICT "@!"
		CASE I = 18
			SAVE SCREEN
			@ 18,00 TO 22,79 DOUBLE
			@ 18,03 SAY "DETALLES" COLOR SCHEME 7
			GsMsgKey = "[S-TAB] Campo anterior     [Esc] Cancela    [F10] Siguiente Campo "
			DO LIB_MTEC WITH 99
			@ 19,1 EDIT XsGloAst SIZE 3,78 COLOR SCHEME 7
			READ
			RESTORE SCREEN
			UltTecla = LastKey()
			IF UltTecla = BackTab .OR. UltTecla = Escape_
				UltTecla = Arriba
			ENDIF
			IF UltTecla = 10
				UltTecla = CtrlW
			ENDIF
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>18,18, i)
	i = IIF(i<1, 1, i)
	IF INLIST(UltTecla,F10,CtrlW)
		IF XfImpChq < 0
			GsMsgErr = "Importe es Negativo"
			DO LIB_MERR WITH 99
			UltTecla = 0
			i = 8
		ENDIF
	ENDIF
ENDDO
SELECT VMOV
RETURN

****************
PROCEDURE NROCHQ
****************
IF ! REC_LOCK(5)
	RETURN
ENDIF
DO CASE
	CASE XsNroChq >= CTAS->NroChq .AND. ! EMPTY(XsNroChq)
		LsNroChq = ALLTRIM(XsNroChq)
		LiNroChq = 0
		X        = 0
		FOR I = LEN(LsNroChq) TO 1 STEP -1
			IF ! SUBSTR(LsNroChq,i,1)$"0123456789"
				EXIT
			ENDIF
			LiNroChq = VAL(SUBSTR(LsNroChq,i))
			X = X + 1
		ENDFOR
		LiNroChq = LiNroChq + 1
		IF X > 0
			LsNroChq = LEFT(LsNroChq,i)+TRANSF(LiNroChq,"@L "+REPLICATE("9",X))
		ENDIF
		REPLACE CTAS->NroChq WITH LsNroChq
ENDCASE
RETURN

*******************
PROCEDURE COMPROBAN
*******************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
Yo       = 7
Largo    = 5
Ancho    = 80
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle1
TotEle   = 80     && M ximos elementos a usar
DO ABROWSE
MaxEle1 = MaxEle
@ 11,1   TO 11,78
IF MaxEle1 = 1 .AND. EMPTY(LEFT(vNroAst(1),6))
	MaxEle1 = 0
	@ 8,01 CLEAR TO 10,78
ENDIF
@ 8,01 Fill TO 10,78  COLOR SCHEME 16
IF LASTKEY() = Escape_
	RETURN
ENDIF
RETURN

******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin
@ NumLin,3  SAY vTpoAst(NumEle)
@ NumLin,09 SAY vNroAst(NumEle)
@ NumLin,24 SAY vNotAst(NumEle) PICT "@S36"
@ NumLin,58 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,61 SAY vImport(NumEle) PICT "##,###,###,###.##"
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin, LiUtecla
LsTpoAst = vTpoAst(NumEle)
LsNroAst = vNroAst(NumEle)
LfImport = vImport(NumEle)
LsNotAst = vNotAst(NumEle)

UltTecla = 0
i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape_,Arriba)
	DO CASE
		CASE i = 1
			SELECT PROV
			SET ORDER TO PROV01
			@ NumLin,3   GET LsTpoAst PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				EXIT
			ENDIF
			IF ULTTECLA = Escape_
				EXIT
			ENDIF
			IF UltTecla = F8
				IF ! CBDBUSCA("PROV")
					LOOP
				ENDIF
				LsTpoAst = TpoDoc				
				ULTTECLA = Enter
			ENDIF
			IF MaxEle = 1 .AND. EMPTY(LsTpoAst)
				LsNroAst = SPACE(LEN(RMOV->NroDoc))
				UltTecla = CtrlW
				EXIT
			ENDIF
			IF MaxEle > 1 .AND. EMPTY(LsTpoAst)
				LsNroAst = SPACE(LEN(RMOV->NroDoc))
				UltTecla = Escape_
				KEYB CHR(23)
				EXIT
			ENDIF
			@ NumLin,3   SAY LsTpoAst PICT "@!"
			SEEK LsTpoAst
			IF FOUND()
				VsClfAux = PROV.CLFAUX
			ELSE			
			*IF ! FOUND()
				GsMsgErr = "** COD. DOCUMENTO NO REGISTRADO **"
				DO LIB_Merr WITH 99
				UltTecla = 0
				LOOP		
			ENDIF
		CASE i = 2
			IF PROV->TIPO$"AM" .and. EMPTY(SUBSTR(LsNroAst,8,2))
				**LsNroAst = SUBSTR(LsNroAst,1,8)+"-"+STR(_ANO,4)+" "
				LsNroAst = PADR(LsNroAst,LEN(RMOV.NroDoc))
			ENDIF
			IF PROV->TIPO$"AM"
				@ NumLin,09  GET LsNroAst PICT "!!!!!!!!!!!!!!"
			ELSE
				@ NumLin,09  GET LsNroAst PICT "@!"
			ENDIF
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				I = 1
				LOOP
			ENDIF
			IF ULTTECLA = Escape_
				EXIT
			ENDIF
			IF ULTTECLA = F8
				MaxEle_Old = MaxEle
				NumEle_Old = NumEle
				SELECT RMOV
				SET ORDER TO RMOV06
				*STORE '' TO vDatos,vCdCta,vCodCta,vMovDoc,XsCodAux
				*XdFchVto = {}
				STORE 0 TO XiForma &&,NumEle,NumCta,ZiOpcion
				*!*	LfSalAct1 = 0.00
				*!*	LfSalAct2 = 0.00
				SET PROCEDURE TO cja_cjaccpag_1.prg ADDITIVE 
				LsNroAst_R = SPACE(10)
				ZiOpcion = 3
				DO FORM cja_cjaccpag2 TO LsNroAst_R
				IF AT('@',LsNroAst_R)>0
					nLenChar=AT('@',LsNroAst_R)
					LsNroAst=SUBSTR(LsNroAst_R,1,nLenChar-1)
					LsCodAux=SUBSTR(LsNroAst_R,nLenChar+1)
				ENDIF
				MaxEle = MaxEle_Old
				NumEle = NumEle_Old
				=SEEK(LsTpoAst,'PROV')
				*WAIT WINDOW LsNroAst
				SET PROCEDURE TO 
				SET PROCEDURE TO janesoft,fxgen_2
				IF EMPTY(LsNroAst)
					LOOP
				ENDIF
				SELECT RMOV
				SET ORDER TO RMOV01
				IF PROV->TIPO$"AM"
					@ NumLin,09  SAY LsNroAst PICT "!!!!!!!!!!!!!!"
				ELSE
					@ NumLin,09  SAY LsNroAst PICT "@!" 
				ENDIF

				IF ! CHKNROAST(LsNroAst,LsCodAux)
					UltTecla = 0
					LOOP
				ENDIF
			ELSE

				IF ! CHKNROAST()
					UltTecla = 0
					LOOP
				ENDIF
			ENDIF
			@ NumLin,24 SAY LsNotAst PICT "@S36"
		CASE i = 3
			@ NumLin,58 SAY IIF(XnCodMon=1,"S/.","US$")
			@ NumLin,61 GET LfImport PICT "##,###,###,###.##"
			READ
			UltTecla = LASTKEY()
		CASE i = 5
			IF UltTecla = Enter
				EXIT
			ENDIF
			IF INLIST(UltTecla,F10,CTRLw)
				UltTecla = CtrlW
				EXIT
			ENDIF
			i = 1
	ENDCASE
	i = IIF(UltTecla = Izquierda, i-1, i+1)
	i = IIF( i > 5 , 5, i)
	i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape_
	vTpoAst(NumEle) = LsTpoAst
	vNroAst(NumEle) = LsNroAst
	vImport(NumEle) = LfImport
	vNotAst(NumEle) = LsNotAst
ENDIF
XfImpCh1 = 0
FOR ii = 1 to MaxEle
	XfImpCh1 = XfImpCh1 + vImport(ii)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"

LiUTecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Chequeando la existencia de la provisi¢n
******************************************************************************
PROCEDURE CHKNROAST
*******************
PARAMETERS PsNroAst,PsCodAux
IF PARAMETERS()=0
	PsNroAst = ''
	PsCodAux = ''
ENDIF
IF PARAMETERS()=1
	LsNroAst = PsNroAst
ENDIF
IF PARAMETERS()=2
	LsNroAst = PsNroAst
	LsCodAux = PADR(PsCodAux,LEN(RMOV.CodAux))
ENDIF
LsFiltroAuxiItems = IIF(EMPTY(PsCodAux),[.T.],[!EMPTY(PsCodAux) AND xCodAux(z)=LsCodAux])
LsNroAst=PADR(LsNroAst,LEN(RMOV.NroDoc))
** Verificando que no se repita en otro item **
IF MaxEle > 1
	FOR z = 1 TO MaxEle
		IF Z#NumEle .AND. vTpoAst(z)=LsTpoAst .AND. vNroAst(z)=LsNroAst AND &LsFiltroAuxiItems
			IF !EMPTY(PsCodAux)
				GsMsgErr = "*** Nro. de Documento del mismo proveedor ya registado en otro item **"
			ELSE
				GsMsgErr = "*** Nro. de Documento ya registado en otro item **"
			ENDIF
			DO LIB_MERR WITH 99
			RETURN .F.
		ENDIF
	NEXT
ENDIF
XsCodOp1 = PROV->CodOpe
XcTipo   = PROV->Tipo
*** Seleccionando la cuentas alternativas ***
DIMENSION xxCodCta(4)
NumCta = 0
LsxxCodCta = ALLTRIM(PROV->CodCta)
DO WHILE .T.
	IF EMPTY(LsxxCodCta)
		EXIT
	ENDIF
	NumCta = NumCta + 1
	IF NumCta > ALEN(xxCodCta)
		DIMENSION xxCodCta(NumCta+5)
	ENDIF
	Z = AT(",",LsxxCodCta)
	IF Z = 0
		Z = LEN(LsxxCodCta) + 1
	ENDIF
	xxCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
	IF Z > LEN(LsxxCodCta)
		EXIT
	ENDIF
	LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
ENDDO
OK = .F.
LsFiltroAuxi = IIF(EMPTY(PsCodAux),[.T.],[!EMPTY(PsCodAux) AND CodAux=LsCodAux])
FOR Z = 1 TO NumCta
	LsCodCta = xxCodCta(Z)
	SELECT RMOV
	SET ORDER TO RMOV05
	SEEK LsCodCta + LsNroAst
	IF FOUND()
		* Posicionamos el puntero *
		DO WHILE ! EOF() .AND. CodCta+NroDoc = LsCodCta+LsNroAst
			IF (CodOpe == PROV->CodOpe or (nromes=[00] and codope=[000])) AND EVALUATE(LsFiltroAuxi)
	            xcoddiv(numele) = coddiv
				xCodMon(NumEle) = CodMon
				xNroRef(NumEle) = NroREf
				=SEEK(NroMes+CodOpe+NroAst,"VMOV")
				LsNotAst = VMOV->NotAst
				IF LsCodAux = "999"
					XsNomAux = RMOV->GloDoc
				ENDIF
				OK = .T.
				EXIT
			ENDIF
			SKIP
		ENDDO
		IF OK
			LsClfAux=RMOV->ClfAux
			LsCodAux=RMOV->CodAux
			LsNroPro=RMOV.NroAst
			LdFchPro=RMOV.FchAst
			XsNomAux = ""
			LfImport = 0
			=SEEK(NroMes+CodOpe+NroAst,"VMOV")
			LsNotAst = VMOV->NotAst
			xcoddiv(numele) = coddiv
			xCodCta(NumEle) = CodCta
			xCodMon(NumEle) = CodMon
			xNroRef(NumEle) = NroREf
			xCodAux(NumEle) = CodAux
			xCodOpe(NumEle) = CodOpe
			xNroPro(NumEle) = LsNroPro
			xFchPro(NumEle) = LdFchPro
			IF LsCodAux = "999"
				XsNomAux = RMOV->GloDoc
			ENDIF
			IF NROMES = "00"
				LsNotAst = RMOV->GloDoc
			ENDIF
			Llave = xCodCta(NumEle)+LsNroAst+xCodAux(NumEle)
			SdoNac = 0
			SdoUsa = 0
			DO WHILE ! EOF() .AND. CodCta+NroDoc+CodAux = Llave
				IF CodOpe == PROV->CodOpe or (nromes=[00] and codope=[000])
					xCodMon(NumEle) = CodMon
					xNroRef(NumEle) = NroREf
					=SEEK(NroMes+CodOpe+NroAst,"VMOV")
					LsNotAst = VMOV->NotAst
					IF NROMES = "00"
						LsNotAst = RMOV->GloDoc
					ENDIF
					IF LsCodAux = "999"
						XsNomAux = RMOV->GloDoc
					ENDIF
				ENDIF
				SdoNac   = SdoNac   + IIF(TpoMov="D",-1,1)*Import
				SdoUsa   = SdoUsa   + IIF(TpoMov="D",-1,1)*ImpUsa
				SKIP
			ENDDO
			IF xCodMon(NumEle) = 1
				LfImport = SdoNac
			ELSE
				LfImport = SdoUsa
			ENDIF
			IF XnCodMon # xCodMon(NumEle)
				IF XnCodMon = 1
					LfImport = ROUND(LfImport*XfTpoCmb,2)
				ELSE
					LfImport = ROUND(LfImport/XfTpoCmb,2)
				ENDIF
			ENDIF
			SET ORDER TO RMOV01
			ok = .T.
			EXIT
		ENDIF
   ENDIF
NEXT
SELECT RMOV
SET ORDER TO RMOV01 
SELECT VMOV
IF ! Ok
	GsMsgErr = "*** Provisión mal Registrada **"
	DO LIB_MERR WITH 99
	RETURN .F.
ENDIF
IF EMPTY(XsCodAux) .OR. MaxEle = 1
	XsCodAux = LsCodAux
	=SEEK(LsClfAux+LsCodAux,"AUXI")
	@ IIF(_Dos or _UNIX,21,24),14 SAY LsCodAux
	@ IIF(_Dos or _UNIX,21,24),26 SAY AUXI->NomAux PICT "@S50"
ENDIF
IF _Dos OR _UNIX
	LinGirado = 19
	LinNota   = 20
ELSE
	LinGirado = 20
	LinNota   = 22
ENDIF

IF EMPTY(XsNotAst) .OR. MaxEle = 1
	XsNotAst = LsNotAst
	@ LinNota,14 SAY XsNotAst
ENDIF
IF EMPTY(XsGirado) .OR. MaxEle = 1
	IF LsCodAux = "999"
		XsGirado = PADR(XsNomAux,LEN(XsGirado))
	ELSE
		=SEEK(LsClfAux+LsCodAux,"AUXI")
		XsGirado = PADR(AUXI->NomAux,LEN(XsGirado))
	ENDIF
	@ LinGirado,14 SAY PADR(XsGirado,70) PICT "@S50" FONT "Tahoma",7 STYLE 'B'
ENDIF
SET ORDER TO VMOV01
RETURN .T.

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
	vTpoAst(i) = vTpoAst(i+1)
	vNroAst(i) = vNroAst(i+1)
	vImport(i) = vImport(i+1)
	vNotAst(i) = vNotAst(i+1)
	i = i + 1
ENDDO
vTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
vNroAst(i) = SPACE(LEN(RMOV->NroDoc))
vImport(i) = 0
vNotAst(i) = SPACE(LEN(VMOV->NotAst))
Estado = .T.
RETURN

******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
	vTpoAst(i) = vTpoAst(i-1)
	vNroAst(i) = vNroAst(i-1)
	vImport(i) = vImport(i-1)
	vNotAst(i) = vNotAst(i-1)
	i = i - 1
ENDDO
i = ElePrv + 1
vTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
vNroAst(i) = SPACE(LEN(RMOV->NroDoc))
vNotAst(i) = SPACE(LEN(VMOV->NotAst))
vImport(i) = 0
Estado = .T.
RETURN

**********************************************************************
PROCEDURE VOUCHER
*****************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENblin2"
EdiLin   = "GENbedi2"
BrrLin   = "GENbbor2"
InsLin   = "GENbins2"
Yo       = 12
Largo    = 6
Ancho    = 80+20
Xo       = INT((100 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle2
TotEle   = 80     && M ximos elementos a usar
DO ABROWSE
MaxEle2 = MaxEle
@ 17,1   TO 17,78+20
IF MaxEle2 = 1 .AND. EMPTY(vCodCta(1))
	MaxEle2 = 0
	@ 13,01 CLEAR TO 16,78+20
ENDIF
@ 13,01 Fill TO 16,78+20 COLOR SCHEME 16
RETURN

******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENblin2
PARAMETERS NumEle, NumLin

=SEEK(vCodCta(NumEle),"CTAS")
=SEEK(vCtaPre(NumEle),"PPRE")
@ numlin,1  say vcoddiv(numele)
@ NumLin,4  SAY vCodCta(NumEle)
@ NumLin,13 SAY CTAS->NomCta PICT "@S21"
@ NumLin,37 SAY vCodAux(NumEle)
@ NumLin,49 SAY vCodDoc(NumEle)
@ NumLin,54 SAY vNroRef(NumEle)
@ NumLin,64 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,68 SAY vImpCta(NumEle) PICT "999,999,999.99"
@ NumLin,82 SAY IIF(vTpoMov(NumEle) = "D"," ","-")
@ NumLin,84 SAY TRIM(vCtaPre(NumEle)) + ' '+ LEFT(PPRE.Nombre,12)
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedi2
PARAMETERS NumEle, NumLin, LiUtecla

lscoddiv = vcoddiv(numele)
LsCodCta = vCodCta(NumEle)
LsCodAux = vCodAux(NumEle)
LcTpoMov = vTpoMov(NumEle)
LsNroRef = vNroRef(NumEle)
LsCodDoc = vCodDoc(NumEle)
LfImpCta = vImpCta(NumEle)
LsCtaPre = vCtaPre(NumEle)

UltTecla = 0
i = 1
LinAct = NumLin
LinDiv = 1
LinCta = 4
LinNom = 13
LinAux = 37
LinTdo = 49
LinRef = 54
LinImp = 68
LinCPRE = 84
i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape_,Arriba)
	DO CASE
		CASE i = 1        && Divisionaria
			SELE AUXI
			@ LinAct,LinDiv GET lscoddiv PICT "XX"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape_
				LOOP
			ENDIF
			IF UltTecla = Arriba
				LOOP
			ENDIF
			IF UltTecla = F8
				TsClfAuxAc = XsClfAux
				XsClfAux = [DV ]  && Divisionarias
				IF ! CBDBUSCA("AUXI")
					LOOP
				ENDIF
				Lscoddiv = padr(auxi.codaux,len(rmov.coddiv))
				XsClfAux=TsClfAuxAc
			ENDIF
			IF MaxEle = 1 .AND. EMPTY(lscoddiv)
				UltTecla = CtrlW
				EXIT
			ENDIF
			IF MaxEle > 1 .AND. EMPTY(lscoddiv)
				UltTecla = Escape_
				KEYB CHR(23)
				EXIT
			ENDIF
			SEEK [DV ]+lscoddiv
			IF !FOUND()
				GsMsgErr = [Codigo de divisionaria invalido]
				DO LIB_MERR WITH 99
				LsCodDiv = space(len(rmov.coddiv))         	
				UltTecla=0
				Loop
			ENDIF
			@ LinAct,LinDiv SAY lsCodDiv PICT "XX"
		CASE i = 2        && C¢digo de Cuenta
			SELECT CTAS
			@ LinAct,LinCta GET LsCodCta PICT REPLICATE("9",LEN(LsCodCta))
			READ
			UltTecla = LastKey()
			IF UltTecla = Escape_
				LOOP
			ENDIF
			IF UltTecla = F8
				SEEK TRIM(LsCodCta)
				IF ! CBDBUSCA("CTAS")
					LOOP
				ENDIF
				LsCodCta = CTAS->CodCta
			ENDIF
        *IF MaxEle = 1 .AND. EMPTY(LsCodCta)
        *   UltTecla = CtrlW
        *   EXIT
        *ENDIF
        *IF MaxEle > 1 .AND. EMPTY(LsCodCta)
        *   UltTecla = Escape_
        *   KEYB CHR(23)
        *   EXIT
        *ENDIF
			SEEK LsCodCta
			IF ! FOUND()
				GsMsgErr = "Cuenta no Registrada"
				DO Lib_MErr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ LinAct,LinCta SAY LsCodCta
			IF CTAS->AFTMOV#"S"
				GsMsgErr = "Cuenta no Afecta a movimiento"
				DO Lib_MErr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ LinAct,LinNom SAY CTAS->NomCta PICT "@S20"
			IF EMPTY(LcTpoMov)
				LcTpoMov = "D"
			ENDIF
		CASE i = 3
			IF CTAS->PIDAUX="S"
				XsClfAux = CTAS->ClfAux
				=SEEK("01"+XsClfAux,"TABL")
				iDigitos = TABL->Digitos
				IF iDigitos < 0 .OR. iDigitos > LEN(LsCodAux)
					iDigitos = LEN(LsCodAux)
				ENDIF
				SELECT AUXI
				IF XsClfAux = "01 "
					LsCodAux = XsCodAux
				ENDIF
				@ LinAct,LinAux GET LsCodAux PICT REPLICATE("9",iDigitos)
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					LOOP
				ENDIF
				IF UltTecla = F8
					IF ! CBDBUSCA("AUXI")
						LOOP
					ENDIF
					LsCodAux = AUXI->CodAux
				ENDIF
				@ LinAct,LinAux SAY LsCodAux
				SEEK XsClfAux+LsCodAux
				IF ! FOUND()
					DO Lib_MErr WITH 9 && no registrado
					LsCodAux = SPACE(LEN(RMOV->CodAUX))
					UltTecla = 0
					LOOP
				ENDIF
				IF EMPTY(XsCodAux)
					XsCodAux = LsCodAux
					XsClfAux = XsClfAux
					@ IIF(_Dos or _UNIX,21,24),14 SAY XsCodAux
					@ IIF(_Dos or _UNIX,21,24),26 SAY AUXI->NomAux PICT "@S50"
				ENDIF
				IF EMPTY(XsGirado) &&.OR. MaxEle = 1
					IF LsCodAux = "999"
						XsGirado = PADR(AUXI->NomAux,LEN(XsGirado))
					ELSE
						=SEEK(XsClfAux+LsCodAux,"AUXI")
						XsGirado = PADR(AUXI->NomAux,LEN(XsGirado))
					ENDIF
					@ LinGirado,14 SAY PADR(XsGirado,70) PICT "@S50" FONT "Tahoma",7 STYLE 'B'
				ENDIF

			ELSE
				LsCodAux = SPACE(LEN(RMOV->CodAUX))
			ENDIF
		CASE i = 4
			IF CTAS->PidDoc="S"
				SELE TABL
				XsTabla = '02'
				@ LinAct,LinTdo GET LsCodDoc PICT "@!"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = F8
					IF !CBdBusCa("TABL")
						UltTecla = 0
						LOOP
					ENDIF
					LsCodDoc = LEFT(TABL->Codigo,LEN(RMOV->CodDoc))
				ENDIF
				SEEK XsTabla+LsCodDoc
				IF !FOUND() AND !EMPTY(LsCodDoc)
					GsMsgErr = "Código de documento inválido"
					DO LIB_MERR WITH 99
					UltTecla = 0
					LOOP
				ENDIF
			ELSE
				LsCodDoc = SPACE(LEN(RMOV->CodDoc))
			ENDIF
			@ LinAct,LinTdo SAY LsCodDoc PICT "@!"
		CASE i = 5
			IF CTAS->PidDoc="S"
				@ LinAct,LinRef GET LsNroRef PICT "@!"
				READ
				UltTecla = LASTKEY()
			ELSE
				LsNroRef = SPACE(LEN(RMOV->NroDoc))
			ENDIF
			@ LinAct,LinRef SAY LsNroRef PICT "@!"
		CASE i = 6
			IF LfImpCta<=0
				LfImpCta = ROUND(XfImpCh1,2)
			ENDIF
			@ NumLin,64 SAY IIF(XnCodMon=1,"S/.","US$")
			@ LinAct,LinImp GET LfImpCta PICT "999,999,999.99" VALID LfImpCta > 0
			READ
			UltTecla = LASTKEY()
			@ LinAct,LinImp SAY LfImpCta PICT "999,999,999.99"
		CASE i = 7
			
			ZcTpoMov = IIF(LcTpoMov = "D"," ","-")
			@ LinAct,82     GET ZcTpoMov PICT "!" VALID ZcTpoMov$" -"
			READ
			UltTecla = LASTKEY()
			LcTpoMov = IIF(ZcTpoMov = "-","H","D")
			@ LinAct,82     SAY IIF(LcTpoMov = "D"," ","-")

		CASE i = 8        && C¢digo de Cuenta
			SELECT PPRE
			@ LinAct,LinCPRE GET LsCtaPre PICT REPLICATE("9",LEN(LsCtaPre))
			READ
			UltTecla = LastKey()
			IF UltTecla = Escape_
				LOOP
			ENDIF
			IF UltTecla = F8
				SEEK TRIM(LsCtaPre)
				IF ! CBDBUSCA("PPRE")
					LOOP
				ENDIF
				LsCtaPre = PPRE.CtaPre
			ENDIF
			SEEK LsCtaPre
			IF ! FOUND()
				GsMsgErr = "Codigo no Registrado"
				DO Lib_MErr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ LinAct,LinCPRE SAY TRIM(LsCtaPre) +' '+LEFT(PPRE.Nombre,12)
*!*				IF CPRE.AFTMOV#"S"
*!*					GsMsgErr = "Cuenta no Afecta a movimiento"
*!*					DO Lib_MErr WITH 99
*!*					UltTecla = 0
*!*					LOOP
*!*				ENDIF
		*!*	MAAV Cuentas presupuestales
		CASE i = 9
			IF UltTecla = Enter
				EXIT
			ENDIF
			IF INLIST(UltTecla,F10,CTRLw)
				UltTecla = CtrlW
				EXIT
			ENDIF
			i = 1
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>9, 9, i)
	i = IIF(i<1, 1, i)
ENDDO
SELECT CTAS
IF UltTecla <> Escape_
	vcoddiv(numele) = lscoddiv
	vCodCta(NumEle) = LsCodCta
	vTpoMov(NumEle) = LcTpoMov
	vCodAux(NumEle) = LsCodAux
	vNroRef(NumEle) = LsNroRef
	vCodDoc(NumEle) = LsCodDoc
	vImpCta(NumEle) = LfImpCta
	vCtaPre(NumEle) = LsCtaPre
ENDIF
XfImpCh2 = 0
FOR ii = 1 to MaxEle
	XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
LiUtecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbbor2
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
	vcoddiv(i) = vcoddiv(i+1)
	vCodCta(i) = vCodCta(i+1)
	vCodAux(i) = vCodAux(i+1)
	vNroRef(i) = vNroRef(i+1)
	vCodDoc(i) = vCodDoc(i+1)
	vTpoMov(i) = vTpoMov(i+1)
	vImpCta(i) = vImpCta(i+1)
	vCtaPre(i) = vCtaPre(i+1)
	i = i + 1
ENDDO
vcoddiv(i) = space(len(rmov.coddiv))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vTpoMov(i) = "D"
vImpCta(i) = 0
vCtaPre(i) = SPACE(LEN(RMOV->CtaPre))
Estado = .T.
RETURN

******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbins2
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
	vcoddiv(i) = vcoddiv(i-1)
	vCodCta(i) = vCodCta(i-1)
	vCodAux(i) = vCodAux(i-1)
	vNroRef(i) = vNroRef(i-1)
	vCodDoc(i) = vCodDoc(i-1)
	vTpoMov(i) = vTpoMov(i-1)
	vImpCta(i) = vImpCta(i-1)
	vCtaPre(i) = vCtaPre(i-1)
	i = i - 1
ENDDO
i = ElePrv + 1
vcoddiv(i) = space(len(rmov.coddiv))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vTpoMov(i) = "D"
vImpCta(i) = 0
vCtaPre(i) = SPACE(LEN(RMOV->CtaPre))
Estado = .T.
RETURN

************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
SAVE SCREEN
DO WHILE INKEY()#0
ENDDO
?? CHR(7)
?? CHR(7)
?? CHR(7)
@ 9,14 FILL  TO 15,63 COLOR W/N
@ 8,15 CLEAR TO 14,64
@ 8,15 FILL  TO 14,64 COLOR SCHEME 15
@ 8,15       TO 14,64 COLOR SCHEME 15
m.remove = 1
@ 10,16 SAY PADC("Forma de Anulaci¢n", 48, " ")  COLOR SCHEME 15
@ 13,19 GET m.remove PICTURE "@*HT \<Voucher;\<Cheque" COLOR SCHEME 7
READ CYCLE MODAL
RESTORE SCREEN
IF LASTKEY() = Escape_
	RETURN
ENDIF
IF .NOT. RLock()
	GsMsgErr = "Asiento usado por otro usuario"
	DO LIB_MERR WITH 99
	UltTecla = Escape_
	RETURN              && No pudo bloquear registro
ENDIF

DO LIB_MSGS WITH 10
IF m.remove = 1
	XsNotAst = PADR("*** VOUCHER ANULADO ***",LEN(VMOV->NotAst))
ELSE
	XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(VMOV->NotAst))
ENDIF
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
	Llave = (NroMes + CodOpe + NroAst )
	IF Rlock()
		SELECT RMOV
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, coddiv
		IF EliItm = "."  .AND. m.remove = 2     
			REPLACE IMPORT WITH 0
			REPLACE IMPUSA WITH 0
			REPLACE GLODOC WITH "**** ANULADO ***"
		ELSE
			SELE RMOV
			DELETE
		ENDIF
		UNLOCK
	ELSE
		ok = .f.
	ENDIF
	SKIP
ENDDO
SELECT VMOV
IF m.remove = 1
	REPLACE CTACJA  WITH ""
	REPLACE NroChq  WITH ""
	REPLACE GIRADO  WITH ""
ENDIF
REPLACE NOTAST WITH XsNotAst
REPLACE GloAst WITH PADC(XsNotAst,52)
REPLACE IMPCHQ WITH 0
REPLACE DBENAC WITH 0
REPLACE HBENAC WITH 0
REPLACE DBEUSA WITH 0
REPLACE HBEUSA WITH 0
IF Ok
	REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
*!*		DELETE
	REPLACE FlgEst WITH " "    && Marca de anulado
ELSE
	DO MOVPINTA
	DO FORM cja_cjatiprp
*!*		@ 10,28 CLEAR TO 14,59
*!*		@ 10,28 TO 14,59
*!*		xElige = 1
*!*		VECOPC(1) = " ******** VOUCHER ********* "
*!*		VECOPC(2) = " ********* CARTAS ********* "
*!*		VECOPC(3) = " ***** CHEQUE-VOUCHER ***** "
*!*		VECOPC(4) = " **** VOUCHER ESPECIAL **** "
*!*		VECOPC(3) = " ***** CHEQUEVOUCHER ****** "
*!*		xElige = Elige(xElige,12,50,4)
*!*		IF LASTKEY() <> Escape_
*!*			DO f0PRINT &&IN ADMPRINT
*!*			IF XElige = 1
*!*				DO MovPrinT
*!*			ELSE
*!*				IF XELIGE=2
*!*					DO MOVPRIN2
*!*				ELSE
*!*					IF XELIGE=3
*!*						DO MOVPRIN3
*!*					ELSE
*!*						IF XElige = 4
*!*							DO MOVPRIN4
*!*						ELSE
*!*							DO MOVPRIN5 && esto es con la otra libreria
*!*						ENDIF
*!*					ENDIF
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
*!*		SET DEVICE TO SCREEN
ENDIF
UNLOCK ALL
RETURN

************************************************************************** FIN
* Procedimiento de Grabar las variables de cabezera
******************************************************************************
PROCEDURE MOVGraba
IF UltTecla = Escape_
	RETURN
ENDIF
DO LIB_MSGS WITH 3
IF XnCodMon = 1
	YfImport = XfImpChq
	YfImpUsa = ROUND(YfImport/XfTpoCmb,2)
ELSE
	YfImpUsa = XfImpChq
	YfImport = ROUND(YfImpUsa*XfTpoCmb,2)
ENDIF
SELECT VMOV
UltTecla = 0
LLAVE = (XsNroMes + XsCodOpe + XsNroAst)
IF Crear                  && Creando
	SELE OPER
	IF ! Rec_Lock(5)
		UltTecla = Escape_
		RETURN              && No pudo bloquear registro
	ENDIF
	SELECT VMOV
	SEEK LLAVE
	IF FOUND()
		XsNroAst = LoContab.NROAST()
		LLAVE = (XsNroMes + XsCodOpe + XsNroAst)
		SEEK LLAVE
		IF FOUND()
			DO LIB_MERR WITH 11
			UltTecla = Escape_
			RETURN
		ENDIF
		@ 1,68 SAY XsNroAst
	ENDIF
	APPEND BLANK
	IF ! Rec_Lock(5)
		UltTecla = Escape_
		RETURN              && No pudo bloquear registro
	ENDIF
	REPLACE VMOV->NROMES WITH XsNroMes
	REPLACE VMOV->CodOpe WITH XsCodOpe
	REPLACE VMOV->NroAst WITH XsNroAst
	replace vmov.fchdig  with date()
	replace vmov.hordig  with time()
	SELECT OPER
	=NROAST(XsNroAst)
	SELECT CTAS
	SEEK XsCtaCja
	**** incrementado el nro de cheque ****
	DO NROCHQ
ELSE
	SEEK LLAVE
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->FchEnt  WITH XdFchEnt
REPLACE VMOV->NroVou  WITH TRANSF(XiNroVou,"@L ######")
REPLACE VMOV->CodMon  WITH XnCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->GloAst  WITH XsGloAst
REPLACE VMOV->CtaCja  WITH XsCtaCja
REPLACE VMOV->NroChq  WITH XsNroChq
REPLACE VMOV->Girado  WITH XsGirado
REPLACE VMOV->ImpChq  WITH XfImpChq
REPLACE VMOV->Digita  WITH GsUsuario
REPLACE VMOV->FLGEST  WITH "M"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0
REPLACE VMOV->Auxil   WITH XsAuxil
REPLACE VMOV.FchPed   WITH XdFchPed
**** Anulando movimientos anteriores ****
SELECT RMOV
SEEK LLAVE
DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
	IF Rec_LOCK(5)
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, coddiv
		SELE RMOV
		DELETE
		UNLOCK
	ENDIF
	SKIP
ENDDO
XiNroItm = 0
***** ACTUALIZANDO 1ra VENTANA *****
FOR NumEle = 1 TO Maxele1
	XcTpoMov = "D"
	IF XnCodMon = 1
		XfImport = vImport(NumEle)
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = vImport(NumEle)
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	xscoddiv = xcoddiv(numele)
	XsCodCta = xCodCta(NumEle)
	=SEEK(XsCodCta,"CTAS")
	XsNroRef = xNroRef(NumEle)
	XsClfAux = CTAS->CLFAUX
	XsCodAux = xCodAux(NumEle)
	XsCodRef = ""
	XsGloDoc = vNotAst(NumEle)
	XsCodDoc = vTpoAst(NumEle)
	XsNroDoc = vNroAst(NumEle)
	XiCodMon = xCodMon(NumEle)
	XsCodCco = IIF(INLIST(GoCfgCbd.C_Costo,1,2,3),XsAuxil,'')
	XsNroPro = xNroPro(NumEle)
	XdFchPro = xFchPro(NumEle)
*!*		XcEliItm = CHR(255)
	XcEliItm = chr(43)  
	IF XiCodMon = 1
		IF XfImport < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ELSE
		IF XfImpUsa < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ENDIF
	IF CTAS->AftDcb = "S"
		DO DIFCMB
	ELSE
		DO GRBRMOV
		IF TpoMov = "H"
			YfImport = YfImport + Import
			YfImpUsa = YfImpUsa + ImpUsa
		ELSE
			YfImport = YfImport - Import
			YfImpUsa = YfImpUsa - ImpUsa
		ENDIF
	ENDIF
ENDFOR
***** ACTUALIZANDO 2da VENTANA *****
FOR NumEle = 1 TO Maxele2
	=SEEK(vCodCta(NumEle),"CTAS")
	XcTpoMov = vTpoMov(NumEle)
	IF XnCodMon = 1
		XfImport = vImpCta(NumEle)
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = vImpCta(NumEle)
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	xscoddiv = vcoddiv(numele)
	XsCodCta = vCodCta(NumEle)
	XsNroRef = ""
	XsClfAux = CTAS->CLFAUX
	XsCodAux = vCodAux(NumEle)
	XsCodRef = ""
	XsGloDoc = XsNotAst
	XsCodDoc = vCodDoc(NumEle)
	XsNroDoc = vNroRef(NumEle)
	XcEliItm = " "
	XiCodMon = XnCodMon
	XsCodCCo = IIF(INLIST(GoCfgCbd.C_Costo,1,2,3),XsAuxil,'')
	XsCtaPre = vCtaPre(NumEle)
	IF XnCodMon = 1
		IF XfImport < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ELSE
		IF XfImpUsa < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ENDIF
	DO GRBRMOV
	IF TpoMov = "H"
		YfImport = YfImport + Import
		YfImpUsa = YfImpUsa + ImpUsa
	ELSE
		YfImport = YfImport - Import
		YfImpUsa = YfImpUsa - ImpUsa
	ENDIF
ENDFOR

**** Actualizando Cta de Caja ***
IF XnCodMon = 1
	LfImport = XfImpChq
	LfImpUsa = ROUND(LfImport/XfTpoCmb,2)
ELSE
	LfImpUsa = XfImpChq
	LfImport = ROUND(LfImpUsa*XfTpoCmb,2)
ENDIF
XsCodCta = XsCtaCja
xscoddiv = xscjadiv
=SEEK(XsCodCta,"CTAS")
XsNroRef = ""
XsClfAux = ''
XsCodAux = ''
DO CASE
	CASE GoCfgCbd.C_COSTO=1
		XsClfAux = GsClfCCt
		XsCodAux = XsAuxil
	CASE GoCfgCbd.C_COSTO=2
		
	CASE GoCfgCbd.C_COSTO=3
		XsCodCCo = XsAuxil	
	OTHER		
		XsClfAux = CTAS->ClfAux
		XsCodAux = XsAuxil

ENDCASE
XsCodRef = ""
XsGloDoc = XsNotAst
XsCodDoc = XsCodDo1
XsNroDoc = XsNroChq
XcEliItm = "."
XcTpoMov = "H"
IF XnCodMon = 1
	IF LfImport < 0
		XcTpoMov = "D"
	ENDIF
ELSE
	IF LfImpUsa < 0
		XcTpoMov = "D"
	ENDIF
ENDIF
XiCodMon = XnCodMon
XfImport = ABS(LfImport)
XfImpUsa = ABS(LfImpUsa)
DO GrbRMOV
SELECT VMOV
REPLACE VMOV->NROITM  WITH XiNroitm
@ 24,0
UNLOCK ALL
*** ACTUALIZANDO INFORMACION DE LETRAS PARA EL FLUJO DE CAJA PROYECTADO
*if crear .and. inlist(xscodope,[021],[038])
*   for numele = 1 to maxele1
*       xscodcta = xcodcta(numele)
*       xscodaux = xcodaux(numele)
*       xsnrodoc = vnroast(numele)
*       xicodmon = xcodmon(numele)
*       jjimppag = vimport(numele)
*       if xscodcta = [423]
*          sele docs
*          jjllave = [LE]+xsnrodoc+[01 ]+xscodaux
*          seek jjllave
*          if found()
*             cc = 0
*             scan while tipdoc+nrodoc+clfaux+codaux=jjllave
*                  cc = cc + 1
*                  vimppag = iif(xicodmon=1,pagnac,pagext)
*                  if vimppag = jjimppag
*                     do while !rlock()
*                     enddo
*                     repla nromes1 with xsnromes
*                     repla codope1 with xscodope
*                     repla nroast1 with xsnroast
*                     unlock
*                  endif
*             endscan
*             *
*             if cc>1
*                seek jjllave
*                scan while tipdoc+nrodoc+clfaux+codaux=jjllave
*                     if nroast1 = space(len(docs.nroast1))
*                        do while !rlock()
*                        enddo
*                        delete
*                        unlock
*                     endif
*                endscan
*             endif
*          endif
*       endif
*   endfor
*endif
*
*
*** ACTUALIZANDO FEC.PED. EN PROVISIONES DE FACT. Y LETRA
*
if crear 
	for numele = 1 to maxele1
		if inlist(xcodcta(numele),[421],[423]) and inlist(xcodope(numele),[065],[075],[000])
			bsllave = xcodcta(numele)+vnroast(numele)+xcodaux(numele)       
			sele rmov
			set order to rmov05
			seek bsllave
			if found()
				scan while codcta+nrodoc+codaux=bsllave for tpomov=[H] and codope=xcodope(numele) 
					=f1_rlock(0)
					repla rmov.fchped with xdfchped
					unlock                  
				endscan
			endif
		endif
	endfor
endif
*
sele vmov
RETURN

*****************
PROCEDURE Grbrmov
*****************
**** Grabando la linea activa ****
DO Graba
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
	RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
*XcEliItm = "ú"
XcEliItm = "*"
TsClfAux = []
TsCodAux = []
TsAn1Cta = CTAS->An1Cta
TsCC1Cta = CTAS->CC1Cta
IF EMPTY(TsAn1Cta) AND EMPTY(TsAn1Cta)
	TsClfAux = "04 "
	TsCodAux = CTAS->TpoGto
	TsAn1Cta = RMOV->CodAux
	TsCC1Cta = CTAS->CC1Cta
	TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
	** Verificamos su existencia **
	IF ! SEEK("05 "+TsAn1Cta,"AUXI")
		GsMsgErr = "Cuenta Automática no existe. Actualización queda pendiente"
		DO LIB_MERR WITH 99
		RETURN
	ENDIF
ELSE
	IF ! SEEK(TsAn1Cta,"CTAS")
		GsMsgErr = "Cuenta Automática no existe. Actualización queda pendiente"
		DO LIB_MERR WITH 99
		RETURN
	ELSE
		IF CTAS.CodCta==TsAn1Cta and ctas.mayaux="S"
			IF CTAS.ClfAux=XsClfAux	
				TsClfAux = XSCLFAUX
				TsCodAux = XSCODAUX
			ENDIF
		ENDIF
	ENDIF   
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
	GsMsgErr = "Cuenta Automática no existe. Actualización queda pendiente"
	DO LIB_MERR WITH 99
	RETURN
ENDIF
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO Graba
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO Graba
RETURN

***************
PROCEDURE GRABA
***************
SELECT RMOV
APPEND BLANK
XiNroItm = XiNroItm + 1
=SEEK(XsCodCta,"CTAS")
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
	IF CTAS->MAYAUX = "S"
		XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
	ENDIF
ENDIF
replace rmov->coddiv with xscoddiv
REPLACE RMOV->NroMes WITH XsNroMes
REPLACE RMOV->CodOpe WITH XsCodOpe
REPLACE RMOV->NroAst WITH XsNroAst
REPLACE RMOV->NroItm WITH XiNroItm
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->Import WITH XfImport
REPLACE RMOV->ImpUsa WITH XfImpUsa
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV->FchVto WITH {  ,  ,    }
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
REPLACE RMOV.CodCco WITH XsCodCco
Replace RMOV.CtaPre WITH XsCtaPre
*
DO CASE
	CASE rmov.codcta = [10]
		REPLACE rmov.FchPed WITH XdFchPed
		replace RMOV.NroPro WITH " "
		replace RMOV.FchPro WITH XdFchAst
	CASE rmov.codcta = [423] .and. rmov.tpomov = [H] && Provisi¢n
		REPLACE rmov.FchPed WITH rmov.fchvto
		replace RMOV.NroPro WITH XsNroPro
		replace RMOV.FchPro WITH XdFchPro
	CASE rmov.codcta = [423] .and. rmov.tpomov = [D] && Cancelaci¢n Letras
		REPLACE rmov.FchPed WITH XdFchPed
		replace RMOV.NroPro WITH XsNroPro
		replace RMOV.FchPro WITH XdFchPro
	CASE rmov.codcta = [421] .and. rmov.tpomov = [D] && Cancelaci¢n Facturas
		REPLACE rmov.FchPed WITH XdFchPed
		replace RMOV.NroPro WITH XsNroPro
		replace RMOV.FchPro WITH XdFchPro
	OTHERWISE
		REPLACE rmov.fchped WITH xdfchped
		replace RMOV.NroPro WITH XsNroPro
		XdFchPro = XdFchAst
		replace RMOV.FchPro WITH XdFchPro
ENDCASE
*
REPLACE rmov.fchdig WITH date()
REPLACE rmov.hordig WITH time()
*
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa, coddiv
IF RMOV->TpoMov = 'D'
	REPLACE VMOV->DbeNac WITH VMOV->DbeNac+Import
	REPLACE VMOV->DbeUsa WITH VMOV->DbeUsa+ImpUsa
ELSE
	REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
	REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
ENDIF
RETURN

******************************************************************************
* Objeto : Procedure Imprime Voucher
******************************************************************************
******************
PROCEDURE MovPrint
******************
NumPag   = 1
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SELECT RMOV
SEEK LsLLave
RegIni = RECNO()
SET DEVICE TO PRINT
PRINTJOB
IF EOF()
ELSE
	GOTO RegIni
ENDIF
Largo  = 66
LinFin = Largo - 6
NumPag = 0
TfDebe = 0
TfHber = 0
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
*!*		IF Import = 0 .AND. EliItm = "ú"
*!*		IF Import = 0 .AND. EliItm = "*"   
	IF Import = 0
		SKIP
		LOOP
	ENDIF
	DO INIPAG
	LinAct = PROW() + 1
	=SEEK(ClfAux+CodAux,"AUXI")
	DO CASE
		CASE ! EMPTY(RMOV->Glodoc)
			LsGlodoc = RMOV->GloDoc
		CASE ! EMPTY(VMOV->NotAst)
			LsGlodoc = VMOV->NotAst
		OTHER
			LsGlodoc = AUXI->NOMAUX
	ENDCASE
	IF VMOV->CodMon <> 1 .OR. RMOV->CodMon = 2 .OR. Import = 0
		LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
		IF RIGHT(LsImport,4)=".00)"
			LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
		ENDIF
		LsGloDoc = LEFT(PADR(LsGloDoc,50),50-LEN(LsImport))+LsImport
	ENDIF
	@ LinAct,6 SAY "³"
	@ LinAct,0  SAY _PRN4
	@ LinAct,15 SAY LsGloDoc    PICT "@S50" font 'small font' , 7
	@ LinAct,0  SAY _PRN2
	@ LinAct,39+3 SAY CodCta
	@ LinAct,45+3 SAY NroDoc
	@ LinAct,55+3 SAY NroRef
	IF TpoMov = "D"
		@ LinAct,65 SAY Import PICT "999,999,999.99"
		TfDebe = TfDebe + Import
	ELSE
		@ LinAct,80 SAY Import PICT "999,999,999.99"
		TfHber = TfHber + Import
	ENDIF
	@ LinAct,94 SAY "³"
	SKIP
ENDDO
IF NumPag = 0
	DO INIPAG
ENDIF
IF PROW() > Largo - 13
	DO INIPAG with .t.
ENDIF
LinAct = PROW() + 1
@ LinAct,6  SAY "============================================================================================"
LinAct = PROW() + 1
@ LinAct,50 SAY "TOTAL S/."
@ LinAct,64 SAY "|"
@ LinAct,65 SAY TfDebe PICT "999,999,999.99"
@ LinAct,79 SAY "³"
@ LinAct,80 SAY TfHber PICT "999,999,999.99"
@ LinAct,94 SAY "|"
LinAct = PROW() + 1
@ LinAct,64 SAY "==============================="

LinAct = Largo - 15
@ LinAct+1,6  SAY "+=====================+=====================+===========================================+"
@ LinAct+2,6  SAY "|     PROCESADO       |     AUTORIZADO      |                                           |"
@ LinAct+3,6  SAY "+===========================================+ RECIBI CONFORME: .....................    |"
@ LinAct+4,6  SAY "|                     |                     | NOMBRE: ..............................    |"
@ LinAct+5,6  SAY "|                     |                     | DNI   : ..............................    |"
@ LinAct+6,6  SAY "+===========================================+===========================================+"
EJECT PAGE
ENDPRINTJOB
DO f0PRFIN
SELECT RMOV
RETURN

*****************
PROCEDURE MovMemb
*****************
IF NumPag > 0
	NumLin = PROW() + 1
	@ NumLin,80  SAY "VAN ......"
	@ NumLin,107 SAY nDbe PICT "999,999,999.99"
	@ NumLin,122 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
cTitulo =+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY IniImp
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b
@ 2,0  SAY GsDirCia
@ 2,Ancho - 23  SAY "OPERACION  "+_Prn7a+Vmov->CodOpe+_Prn7b
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho/2-14  SAY _Prn7a+"VOUCHER GENERAL"+_Prn7b
@ 3,Ancho - 36  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b
@ 4,0           SAY cTitulo
@ 4,Ancho - 44  SAY "MONEDA     "+IIF(Vmov->CodMon=1,"S/.","US$")
@ 4,Ancho - 23  SAY "REFERENCIA "+VMOV->NroVou
@ 5,0           SAY Vmov->NotAst
@ 5,Ancho - 44  SAY "T/C   "+TRAN(VMOV->TpoCmb,"##,###.####")
@ 5,Ancho - 23  SAY "Fecha      "+DTOC(Vmov->FchAst)
@ 6, 0          SAY En5
@ 7, 0          SAY En6
@ 8, 0          SAY En7
@ 9, 0          SAY En8
@ 10,0          SAY En9
IF NumPag > 1
	NumLin = PROW() + 1
	@ NumLin,80  SAY "VIENEN ..."
	@ NumLin,107 SAY nDbe PICT "999,999,999.99"
	@ NumLin,122 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN

*****************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                                                                                              "
Pn2 = "                                                                                                                                                          "
Pn3 = "                                                                                                                                                          "
Pn4 = "_______________ _______________ _______________                                                                                                           "
Pn5 = PADC(VMOV->Digita,15)
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn4
@ NumLin+3,0    SAY Pn5
*@ NumLin+4,0    SAY Pn4
*@ NumLin+5,0    SAY Pn5
RETURN

****************
PROCEDURE INIPAG
****************
PARAMETER SaltoPag
IF TYPE("SalToPag")<>"L"
	SalToPag = .T.
ENDIF
IF ! (NumPag = 0 .OR. PROW() > LinFin .or. SaltoPag)
	RETURN
ENDIF
IF NumPag > 0
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VAN ....."
	@ LinAct,65 SAY TfDebe PICT "999,999,999.99"
	@ LinAct,80 SAY TfHber PICT "999,999,999.99"
	LinAct = PROW() + 1
	@ LinAct,6  SAY "========================================================================================="
ENDIF
NumPag = NumPag + 1
XsHoy='Lima, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")

SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)

@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN2
@  0,6  SAY _PRN7A+TRIM(GsNomCia)
@  0,0  SAY _PRN7B
@  0,76 SAY _PRN7A+"N§ "+VMOV->NroAst
@  0,0  SAY _PRN7B
@  1,06 SAY _PRN7A+[OP-]+VMOV->CODOPE
@  1,0  SAY _PRN7B
@  1,75 SAY _PRN7A+"Rel-"+SUBSTR(VMOV->NroVou,2,5)+_PRN7B

@ 17,0  SAY _PRN7A+PADC("VOUCHER DE CAJA EGRESOS",47)+_PRN7B

@ 18,6  SAY "========================================================================================="
@ 19,6  SAY "|"
@ 19,8  SAY XsHoy
@ 19,76 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@ 19,80 SAY VMOV->ImpChq PICT "**,***,***.**"
@ 19,94 SAY "|"
@ 20,06 SAY "|"
@ 20,8  SAY "GIRADO A:"
@ 20,18 SAY VMOV->GIRADO
@ 20,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@ 20,94 SAY "|"
@ 21,6  SAY "| "+PADR("BANCO    : "+CTAS->NOMCTA,86)+"|"
@ 22,6  SAY "| "+PADR("CHEQUE N§: "+VMOV->NROCHQ+"                 "+CTAS->NROCTA,86)+"³"
@ 23,6  SAY "+========================================================================================"
@ 24,6  SAY "|"+PADC(Dato1,87)+"|"
@ 25,6  SAY "|"+PADC(Dato2,87)+"|"
@ 26,6  SAY "|"+PADC(Dato3,87)+"|"
@ 27,6  SAY "+=======================================================================================+"
@ 28,6  SAY "|    DOCUMENTO CANCELADO       ³CUENTA³DOCUMENTO³REFERENC.³     DEBE     ³    HABER     |"
@ 29,6  SAY "+========================================================================================"

IF NumPag > 1
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VIENEN..."
	@ LinAct,63 SAY TfDebe PICT "999,999,999.99"
	@ LinAct,78 SAY TfHber PICT "999,999,999.99"
ENDIF
RETURN

******************************************************************************
* Objeto : GENERA ITEM DE DIFERENCIA DE CAMBIO
******************************************************************************
PROCEDURE DIFCMB
****************
LfImport = 0
LfImpUsa = 0
SELECT RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK Llave
DO WHILE ! EOF() .AND. CodCta+CodAux+NroDoc = Llave
	LfImport = LfImport + IIF(TpoMov="D",-1,1)*Import
	LfImpUsa = LfImpUsa + IIF(TpoMov="D",-1,1)*ImpUsa
	SKIP
ENDDO
SET ORDER TO RMOV01
*!* Verificando la cancelaci¢n del documento *!*
oK = .T.
IF xCodMon(NumEle) = 1
	IF ABS(LfImport-IIF(XcTpoMov="D",1,-1)*XfImport) > 0.90   && Ajuste y Matar puchos
		oK = .F.
	ENDIF
ELSE
	IF ABS(LfImpUsa-IIF(XcTpoMov="D",1,-1)*XfImpUsa) > 0.90   && Ajuste y Matar puchos
		oK = .F.
	ENDIF
ENDIF
*** Grabando el Documento ***
IF oK
	XfImpUsa = LfImpUsa
	XfImport = LfImport
	IF XcTpoMov = "H"
		XfImpUsa = -LfImpUsa
		XfImport = -LfImport
	ENDIF
ENDIF
DO GRBRMOV
IF TpoMov = "H"
	YfImport = YfImport + Import
	YfImpUsa = YfImpUsa + ImpUsa
ELSE
	YfImport = YfImport - Import
	YfImpUsa = YfImpUsa - ImpUsa
ENDIF

IF ! oK
	RETURN
ENDIF

**** Calculando REDONDEO y DIFERENCIA DE CAMBIO ****

IF XnCodMOn = 1
	IF TpoMov = "D"
		LfImport = Import - vImport(NumEle)
		LfImpUsa = ImpUsa - ROUND(vImport(NumEle)/XfTpoCmb,2)
	ELSE
		LfImport = - Import - vImport(NumEle)
		LfImpUsa = - ImpUsa - ROUND(vImport(NumEle)/XfTpoCmb,2)
	ENDIF
ELSE
	IF TpoMov = "D"
		LfImport = Import - ROUND(vImport(NumEle)*XfTpoCmb,2)
		LfImpUsa = ImpUsa - vImport(NumEle)
	ELSE
		LfImport = -Import - ROUND(vImport(NumEle)*XfTpoCmb,2)
		LfImpUsa = -ImpUsa - vImport(NumEle)
	ENDIF
ENDIF
***** Grabando el redondeo y el ajuste ****
XcEliItm = "-"
XfImpUsa = LfImpUsa
XfImport = LfImport
IF XfImport#0
	IF XfImport > 0
		XsCodCta = XsCdCta2
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = XsCdAux2
		XcTpoMov = [H]
	ELSE
		XfImpUsa = -LfImpUsa
		XfImport = -LfImport
		XsCodCta = XsCdCta1
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = XsCdAux1
		XcTpoMov = [D]
	ENDIF
	DO GRBRMOV
ENDIF
IF XfImpUsa#0
	IF XfImpUsa > 0
		XsCodCta = XsCdCta2
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = XsCdAux2
		XcTpoMov = [H]
	ELSE
		XfImpUsa = -LfImpUsa
		XfImport = -LfImport
		XsCodCta = XsCdCta1
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = XsCdAux1
		XcTpoMov = [D]
	ENDIF
	DO GRBRMOV
ENDIF

IF TpoMov = "H"
	YfImport = YfImport + Import
	YfImpUsa = YfImpUsa + ImpUsa
ELSE
	YfImport = YfImport - Import
	YfImpUsa = YfImpUsa - ImpUsa
ENDIF
RETURN

******************************************************************************
* Objeto : Procedure Imprime Voucher DE CARTA
******************************************************************************
PROCEDURE MovPrin2
******************
LOCAL lcRptTxt,lcRptGraph,lcRptDesc 
LOCAL LcArcTmp,LcAlias,LnNumReg,LnNumCmp,LlPrimera
LcArcTmp=GoEntorno.TmpPath+Sys(3)
LcAlias  = ALias()
LnControl = 1
DO xGenerar_Carta
SELECT Vmov_t
GO TOP
IF EOF()
	wait window "No existen registros a Listar" NOWAIT
	IF NOT EMPTY(LcAlias)
		SELE (LcAlias)
	ENDIF
	RETURN
ENDIF
lcRptTxt   = "cja_cheque_carta"
lcRptGraph = "cja_cheque_carta"
lcRptDesc  = "Carta al banco"
LoTipRep   = ''
IF .f.
	MODI REPORT cja_cheque_carta
ENDIF
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc &&, THISFORM.DATASESSIONID
USE IN VMOV_T
IF NOT EMPTY(LcAlias)
	SELECT (LcAlias)
ENDIF
RELEASE LcArcTmp, LcAlias,LnNumReg
RETURN

*!*	NumPag   = 1
*!*	SELECT VMOV
*!*	LsLLave  = (NroMes+CodOpe+NroAst)
*!*	SELECT RMOV
*!*	SEEK LsLLave
*!*	RegIni = RECNO()
*!*	SET DEVICE TO PRINT
*!*	PRINTJOB
*!*		GOTO RegIni
*!*		Largo  = 66
*!*		LinFin = Largo - 8
*!*		NumPag = 0
*!*		TfDebe = 0
*!*		TfHber = 0
*!*		DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
*!*	*!*			IF Import = 0 .AND. EliItm = "ú"
*!*	*!*			IF Import = 0 .AND. EliItm = "*"   
*!*			IF Import = 0
*!*				SKIP
*!*				LOOP
*!*			ENDIF
*!*			DO ZINIPAG
*!*			LinAct = PROW() + 1
*!*			=SEEK(ClfAux+CodAux,"AUXI")
*!*			DO CASE
*!*				CASE ! EMPTY(RMOV->Glodoc)
*!*					LsGlodoc = RMOV->GloDoc
*!*				CASE ! EMPTY(VMOV->NotAst)
*!*					LsGlodoc = VMOV->NotAst
*!*				OTHER
*!*					LsGlodoc = AUXI->NOMAUX
*!*			ENDCASE
*!*			IF VMOV->CodMon <> 1 .OR. RMOV->CodMon = 2 .OR. Import = 0
*!*				LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
*!*				IF RIGHT(LsImport,4)=".00)"
*!*					LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
*!*				ENDIF
*!*				LsGloDoc = LEFT(PADR(LsGloDoc,50),50-LEN(LsImport))+LsImport
*!*			ENDIF
*!*	*!*		@ LinAct,0  SAY _PRN4
*!*	*!*			LinAct,15 SAY LsGloDoc    PICT "@S50"
*!*	*!*		@ LinAct,0  SAY _PRN1
*!*	*!*			@ LinAct,39+3 SAY CodCta
*!*	*!*			@ LinAct,45+3 SAY NroDoc
*!*	*!*			@ LinAct,55+3 SAY NroRef
*!*			IF TpoMov = "D"
*!*	*!*				@ LinAct,65 SAY Import PICT "999,999,999.99"
*!*				TfDebe = TfDebe + Import
*!*			ELSE
*!*	*!*				@ LinAct,80 SAY Import PICT "999,999,999.99"
*!*				TfHber = TfHber + Import
*!*			ENDIF
*!*			SKIP
*!*		ENDDO
*!*		IF NumPag = 0
*!*			DO ZINIPAG
*!*		ENDIF
*!*		IF PROW() > Largo - 10
*!*			DO ZINIPAG with .t.
*!*		ENDIF
*!*		LinAct = PROW() + 1
*!*		LinAct = PROW() + 1
*!*		LinAct = PROW() + 1
*!*		LinAct = Largo - 15
*!*		EJECT PAGE
*!*	ENDPRINTJOB
*!*	DO f0PRFIN
*!*	SELECT RMOV
*!*	RETURN

****************
PROCEDURE ZINIPAG
****************
PARAMETER SaltoPag
IF TYPE("SalToPag")<>"L"
	SalToPag = .T.
ENDIF
IF ! (NumPag = 0 .OR. PROW() > LinFin .or. SaltoPag)
	RETURN
ENDIF
IF NumPag > 0
	LinAct = PROW() + 1
ENDIF
NumPag = NumPag + 1
XsHoy='Miraflores, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")
XsNomBan =TABL->Nombre
SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)
Dato4 = mline(VMOV->GLOAST,4)
Dato5 = mline(VMOV->GLOAST,5)
Dato6 = mline(VMOV->GLOAST,6)
Dato7 = mline(VMOV->GLOAST,7)
Dato8 = mline(vmov->gloast,8)
Dato9 = mline(vmov->gloast,9)

*!*	@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN1
*!*	@  0,6  SAY _PRN7a+TRIM(GsNomCia)+_PRN7B
@ 12,60 SAY "N° "+VMOV->CODOPE+"-"+SUBSTR(VMOV->NroAst,3,2)+RIGHT(VMOV->NroAst,4)
@ 13,60 SAY "Relac. -"+SUBSTR(VMOV->NroVou,2,5)
@ 15,8  SAY XsHoy
@ 18,8  SAY "Señores"
@ 19,8  SAY _prn6a+XsNomBan+_prn6b
@ 20,8  SAY "Presente.-"
@ 22,8  SAY "Attn.: "+dato1
@ 23,15 SAY "Funcionario de Negocios"
@ 25,8  SAY "Ref. :"
@ 25,15 SAY dato2
@ 26,15 SAY dato3
@ 29,8  SAY "De Nuestra Consideración:"
@ 32,8  SAY "Por medio de la presente, les  solicitamos efectuar"
@ 33,8  SAY "la operación de la referencia:"
@ 35,8  SAY "A la orden de     :"
*!*	@ 35,28 SAY _PRN6A+(VMOV->GIRADO)+_PRN6B
@ 35,28 SAY VMOV->GIRADO
@ 37,8  SAY "Por el Importe de :"
IF XnMn_Cart=VMOV.CodMon
	@ 37,28 SAY IIF(VMOV->CODMON=1,"S/.","US$")
	@ 37,33 SAY VMOV->ImpChq PICT "**,***,***.**"
	@ 38,08 SAY NUMERO(VMOV->ImpChq,2,1)+IIF(VMOV->CODMON=1," Nuevos Soles"," D¢lares Americanos")
ELSE
	IF XnMn_cart=1
		@ 37,28 SAY IIF(XnMn_Cart=1,"S/.","US$")
		XfImpCarta=ROUND(VMOV.ImpChq*XfTpoCmb,2)
		@ 37,33 SAY XfIMpCarta PICT "**,***,***.**"
	ELSE
        @ 37,28 SAY IIF(XnMn_Cart=1,"S/.","US$")
		XfImpCarta=ROUND(VMOV.ImpChq/XfTpoCmb,2)
		@ 37,33 SAY XfIMpCarta PICT "**,***,***.**"
	ENDIF
	@ 38,08 SAY NUMERO(XfImpCarta,2,1)+IIF(XnMn_Cart=1," Nuevos Soles"," D¢lares Americanos")
ENDIF
@ 40,8 SAY dato4
@ 41,8 SAY dato5
@ 43,8 SAY "Asimismo, agradeceremos cargar el importe solicitado"
@ 44,8 SAY "en nuestra cuenta corriente:"
@ 45,8 SAY _prn6a+PADR(CTAS->NOMCTA,45)+_prn6b
@ 47,8 SAY dato6
@ 48,8 SAY dato7
@ 49,8 say dato8
@ 50,8 say dato9
*!*	@ 50,8 SAY "Agradeciendo la atenci¢n a la presente, quedamos de"
*!*	@ 51,8 SAY "ustedes."
*!*	@ 53,42 SAY "Atentamente,"
@ 52,8 SAY "Agradeciendo la atenci¢n a la presente, quedamos de"
@ 53,8 SAY "ustedes."
@ 54,42 SAY "Atentamente,"

IF NumPag > 1
	LinAct = PROW() + 1
*!*	@ LinAct,50 SAY "VIENEN..."
*!*	@ LinAct,63 SAY TfDebe PICT "999,999,999.99"
*!*	@ LinAct,78 SAY TfHber PICT "999,999,999.99"
ENDIF
RETURN

******************************************************************************
* Objeto : Procedure Imprime Cheque - Voucher
******************************************************************************
PROCEDURE MovPrin3
******************
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SET MEMO TO 90
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)
Dato4 = mline(VMOV->GLOAST,4)

DIMENSION vLinHbe(10),vLinDbe(10)
STORE "" TO vLinHbe,vLinDbe
STORE 0 TO THbe,TDbe
SELECT RMOV
SEEK LsLLave
SNOMREP = "CJA_CJACHQVO"
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
XFOR   = [ELIITM#"*"]
XWHILE = [NROMES+CODOPE+NROAST=LsLlAVE]
DO F0PRINT WITH "REPORTS"

******************************************************************************
* Objeto : Procedure Imprime Voucher
******************************************************************************
PROCEDURE MovPrin4
******************
DO F0PRINT
IF LASTKEY() = k_Esc
   RETURN
ENDIF
NumPag   = 1
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SELECT RMOV
SEEK LsLLave
RegIni = RECNO()
SET DEVICE TO PRINT
PRINTJOB
	GOTO RegIni
	Largo  = 33
	LinFin = Largo - 3
	NumPag = 0
	TfDebe = 0
	TfHber = 0
	DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
		IF Import = 0
			SKIP
			LOOP
		ENDIF
		DO INIPAG1
		LinAct = PROW() + 1
		=SEEK(ClfAux+CodAux,"AUXI")
		DO CASE
			CASE ! EMPTY(RMOV->Glodoc)
				LsGlodoc = RMOV->GloDoc
			CASE ! EMPTY(VMOV->NotAst)
				LsGlodoc = VMOV->NotAst
			OTHER
				LsGlodoc = AUXI->NOMAUX
		ENDCASE
		IF VMOV->CodMon <> 1 .OR. RMOV->CodMon = 2 .OR. Import = 0
			LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
			IF RIGHT(LsImport,4)=".00)"
				LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
			ENDIF
			LsGloDoc = LEFT(PADR(LsGloDoc,50),50-LEN(LsImport))+LsImport
		ENDIF
		@ LinAct,6 SAY "|"
		@ LinAct,0 SAY _PRN4
		@ LinAct,8 SAY LsGloDoc PICT "@S25"
		@ LinAct,0 SAY _PRN2
		@ LinAct,35+3 SAY CodCta
		@ LinAct,45+3 SAY NroDoc
*!*		@ LinAct,53+3 SAY NroRef
		IF TpoMov = "D"
			@ LinAct,65 SAY Import PICT "999,999,999.99"
			TfDebe = TfDebe + Import
		ELSE
			@ LinAct,80 SAY Import PICT "999,999,999.99"
			TfHber = TfHber + Import
		ENDIF
		@ LinAct,94 SAY "|"
		SKIP
	ENDDO
	IF NumPag = 0
		DO INIPAG1
	ENDIF
	IF PROW() > Largo - 7
		DO INIPAG1 with .t.
	ENDIF
	LinAct = PROW() + 1
	@ LinAct,6  SAY "========================================================================================="
	LinAct = PROW() + 1
	@ LinAct,50 SAY "TOTAL S/."
	@ LinAct,64 SAY "|"
	@ LinAct,65 SAY TfDebe PICT "999,999,999.99"
	@ LinAct,79 SAY "|"
	@ LinAct,80 SAY TfHber PICT "999,999,999.99"
	@ LinAct,94 SAY "|"
	LinAct = PROW() + 1
	@ LinAct,64 SAY "==============================="
	LinAct = Largo - 8
	@ LinAct+1,6  SAY "+=====================+=====================+===========================================+"
	@ LinAct+2,6  SAY "|     PROCESADO       |     AUTORIZADO      |                                           |"
	@ LinAct+3,6  SAY "+=====================+=====================+ RECIBI CONFORME: .....................    |"
	@ LinAct+4,6  SAY "|                     |                     | NOMBRE: ..............................    |"
	@ LinAct+5,6  SAY "|                     |                     | DNI   : ..............................    |"
	@ LinAct+6,6  SAY "+===========================================+===========================================+"
	EJECT PAGE
ENDPRINTJOB
DO F0PRFIN
SELECT RMOV
RETURN

*****************
PROCEDURE INIPAG1
*****************
PARAMETER SaltoPag
IF TYPE("SalToPag")<>"L"
	SalToPag = .T.
ENDIF
IF ! (NumPag = 0 .OR. PROW() > LinFin .or. SaltoPag)
	RETURN
ENDIF
IF NumPag > 0
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VAN ....."
	@ LinAct,65 SAY TfDebe PICT "999,999,999.99"
	@ LinAct,80 SAY TfHber PICT "999,999,999.99"
	LinAct = PROW() + 1
	@ LinAct,6  SAY "========================================================================================="
ENDIF
NumPag = NumPag + 1
XsHoy='Lima, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")

SET MEMO TO 40
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)

@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN2
@  0,6  SAY _PRN7A+TRIM(GsNomCia)
@  0,0  SAY _PRN7B
@  0,78 SAY _PRN7A+"VOUCHER "+LEFT(VMOV->NroAst,2)+"-"+SUBSTR(VMOV->NroAst,3)              && SUBSTR(VMOV->NroAst,4,2)+"/"+SUBSTR(VMOV->NroAst,6,4)
@  0,0  SAY _PRN7B
@  1,6  SAY _PRN7A+[OP-]+VMOV->CODOPE
@  1,0  SAY _PRN7B
*!*	@  1,75 SAY _PRN7A+"Rel-"+SUBSTR(VMOV->NroVou,2,5)+_PRN7B

@ 02,24  SAY _PRN7A+PADC("VOUCHER DE CAJA EGRESOS",47)+_PRN7B

@ 03,6  SAY "========================================================================================="
@ 04,6  SAY "|"
@ 04,8  SAY XsHoy
@ 04,76 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@ 04,80 SAY VMOV->ImpChq PICT "**,***,***.**"
@ 04,94 SAY "|"
@ 05,06 SAY "|"
@ 05,8  SAY "GIRADO A :"
@ 05,19 SAY VMOV->GIRADO
@ 05,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@ 05,94 SAY "|"
@ 06,6  SAY "| "+PADR("BANCO    : "+CTAS->NOMCTA,86)+"|"
@ 07,6  SAY "| "+PADR("CHEQUE Nº: "+VMOV->NROCHQ+"NRO. CUENTA : "+CTAS->NROCTA,86)+"|"
@ 08,6  SAY "+========================================================================================"
@ 09,6  SAY "|"+PADC(Dato1,87)+"|"
*!*	@ 15,6  SAY "|"+PADC(Dato2,87)+"|"
*!*	@ 16,6  SAY "|"+PADC(Dato3,87)+"|"
@ 10,6  SAY "+=======================================================================================+"
@ 11,6  SAY "|    DOCUMENTO CANCELADO       | CUENTA |  DOCUMENTO  |       DEBE       |      HABER   |"
@ 12,6  SAY "+========================================================================================"
IF NumPag > 1
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VIENEN..."
	@ LinAct,63 SAY TfDebe PICT "999,999,999.99"
	@ LinAct,78 SAY TfHber PICT "999,999,999.99"
ENDIF
RETURN

**************************
PROCEDURE Imprime_Vouchers
**************************
PARAMETERS __Ing_Egre_Transf

DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "DOCUMENTOS EMITIDOS"

cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
Do FONDO WITH 'DOCUMENTOS EMITIDOS '+cTitulo ,goEntorno.User.Login,GsNomCia,GsFecha


XiTpoDoc = 1

@  9,10 FILL  TO 15,68      COLOR W/N
@  9,12 CLEAR TO 13,68
@  8,11       TO 14,69
@ 10,31 PROMPT "  CAJA  INGRESOS  "
@ 11,31 PROMPT "   CAJA EGRESOS   "
@ 12,31 PROMPT "CAJA TRANSFERENCIA"
MENU TO XiTpoDoc
IF LastKey() = Escape_ .OR. XiTpoDoc = 0
   RETURN
ENDIF
@  9,12 CLEAR TO 13,68
XiForma = 1
DO CASE
   CASE XiTpoDoc = 1
      @ 8,31 SAY "  CAJA  INGRESOS  " COLOR SCHEME 7
      XsCodOpe = "001"
      @ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
      @ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
      MENU TO XiForma
      xPrg = "CJA_CJAC1MOV"

   CASE XiTpoDoc = 2
      @ 8,31 SAY "   CAJA EGRESOS   " COLOR SCHEME 7
      XsCodOpe = "002"
      @ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
      @ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
      @ 12,22 PROMPT "TODOS LOS DOCUMENTO DE UNA RELACION"
      MENU TO XiForma
      xPrg = "CJA_CJAC2MOV"

   CASE XiTpoDoc = 3
      @ 8,31 SAY "CAJA TRANSFERENCIA" COLOR SCHEME 7
      XsCodOpe = "018"
      @ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
      @ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
      MENU TO XiForma
      xPrg = "CJA_CJAC3MOV"

ENDCASE
IF LastKey() = Escape_ .OR. XiForma  = 0
   *CLOSE DATA
   RETURN
ENDIF
XiNroMes = _Mes
XiNroRel = 0
XiNrDoc1 = 1
XiNrDoc2 = 999999
XdFchAs1 = DATE()
XdFchAs2 = DATE()
XsNroMes = TRANSF(XiNroMes,"@L ##")
@  9,12 CLEAR TO 13,68
DO CASE
   CASE XiForma  = 1
      @ 09,22 SAY    "  DOCUMENTOS EN UN RANGO DE FECHA  " COLOR SCHEME 7
      @ 11,24 SAY "DESDE FECHA DE REGISTRO :" GET XdFchAs1
      @ 12,24 SAY "HASTA FECHA DE REGISTRO :" GET XdFchAs2
      READ
      Llave  = XsNroMes+XsCodOpe
      Valido = "(FchAst >=XdFchAs1 .AND. FchAst <= XdFchAs2)"
      RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe)"
      xOrden = "VMOV01"

   CASE XiForma  = 2
      @ 09,22 SAY    "      ENTRE N§ DE DOCUMENTOS       " COLOR SCHEME 7

      @ 11,26 SAY "DEL MES DE          :" GET XiNroMes PICT "@Z 99"
      @ 12,26 SAY "DESDE DOCUMENTO NO. :" GET XiNrDoc1 PICT "@LZ 999999"
      @ 13,26 SAY "HASTA DOCUMENTO NO. :" GET XiNrDoc2 PICT "@LZ 999999"
      READ
      XsNroMes = TRANSF(XiNroMes,"@L ##")
      Llave  = XsNroMes+XsCodOpe+TRANSF(XiNrDoc1,"@L 999999")
      Valido = ".T."
      RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe .AND. VAL(NroAst)<=XiNrDoc2)"
      xOrden = "VMOV01"

   CASE XiForma  = 3
      @ 09,22 SAY    "TODOS LOS DOCUMENTO DE UNA RELACION" COLOR SCHEME 7
      @ 12,30 SAY "RELACION NO. :" GET XiNroRel PICT "@LZ 999999"
      READ
      Llave  = XsCodOpe+TRANSF(XiNroRel,"@L 999999")
      Valido = ".T."
      RegVal = "(CodOpe+NroVou=Llave)"
      xOrden = "VMOV02"
ENDCASE
IF LastKey() = Escape_
   RETURN
ENDIF
DO f0PRINT
IF LastKey() = Escape_
   RETURN
ENDIF
*** APERTURANDO ARCHIVOS ***
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
RESTORE FROM LoContab.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE

*!*	DO MOVApert IN (xPrg)
IF !LoContab.MOVApert()
	RELEASE LoContab
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
	RETURN
ENDIF

SET MARGIN TO 0
PRINTJOB
   SELECT VMOV
   SET ORDER TO (xOrden)
   SEEK LLAVE
   DO WHILE ! EOF() .AND. &RegVal
      XsNroMes = NroMes
      XsNroAst = NroAst
      IF &Valido
         DO MOVPRINT && IN (xPrg)
      ENDIF
      SELECT VMOV
      SKIP
   ENDDO
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO f0PRFIN IN f0PRINT
RETURN

******************
PROCEDURE MOVPRIN5
******************
PARAMETERS PsCtaCja
IF PARAMETERS()=0
	PsCtaCja = ''
ENDIF

LOCAL lcRptTxt,lcRptGraph,lcRptDesc 
LOCAL LcArcTmp,LcAlias,LnNumReg,LnNumCmp,LlPrimera
LcArcTmp=GoEntorno.TmpPath+Sys(3)
LcAlias  = ALias()
LnControl = 1
IF USED('VMOV_T')
	USE IN VMOV_T
ENDIF
IF USED('RMOV_T')
	USE IN RMOV_T
ENDIF

DO xGenerar_ChqVou
SELECT Vmov_t
LOCATE
IF EOF()
	wait window "No existen registros a Listar" NOWAIT
	IF NOT EMPTY(LcAlias)
		SELE (LcAlias)
	ENDIF
	RETURN
ENDIF
SELECT Rmov_t
LOCATE
IF EOF()
	wait window "No existen registros a Listar" NOWAIT
	IF NOT EMPTY(LcAlias)
		SELE (LcAlias)
	ENDIF
	RETURN
ENDIF
IF !EMPTY(PsCtaCja)
	lcRptTxt   = "cja_cheque_voucher_"+PsCtaCja
	lcRptGraph = "cja_cheque_voucher_"+PsCtaCja
ELSE
	lcRptTxt   = "cja_cheque_voucher"
	lcRptGraph = "cja_cheque_voucher"
ENDIF
lcRptDesc  = "Cheque - Voucher"
LoTipRep   = ''
IF .F.
	MODI REPORT cja_cheque_voucher
ENDIF
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc &&, THISFORM.DATASESSIONID
IF USED('VMOV_T')
	USE IN VMOV_T
ENDIF
IF USED('RMOV_T')
	USE IN RMOV_T
ENDIF
IF NOT EMPTY(LcAlias)
	SELECT (LcAlias)
ENDIF
RELEASE LcArcTmp, LcAlias,LnNumReg
RETURN

*************************
PROCEDURE xGenerar_ChqVou
*************************
*!* Creamos temporal para detalle *!*
SELECT 0
LcArcRmov_t = GoEntorno.TmpPath+Sys(3)
WAIT WINDOW 'Generando impresion de cheque voucher' TIMEOUT .1
CREATE TABLE (LcArcRmov_t) FREE ( NroMes c(LEN(RMOV.NroMes)), CodOpe c(LEN(RMOV.CodOpe)),;
								NroAst c(LEN(RMOV.NroAst)), FchAst D(8),;
								CodCta c(LEN(RMOV.CodCta)),CodAux c(LEN(RMOV.CodAux)),;
								CodCco c(LEN(RMOV.CodCco)),NroPro c(LEN(RMOV.NroPro)),;
								NroDoc c(LEN(RMOV.NroDoc)),ImpUsa n(16,2),;
								FchPro d(8),ImpDbe n(16,2),ImpHbe n(16,2),Glodoc C(30),import n(16,2) )
USE (LcArcRmov_t) ALIAS RMOV_T EXCLUSIVE
INDEX ON NroMes+CodOpe+NroAst TAG RMOV_T01
*!* Creamos temporal para cabecera *!*
WAIT WINDOW 'Generando impresion de cheque voucher... espere un momento' TIMEOUT .1
SELECT 0
LcArcVmov_t = GoEntorno.TmpPath+Sys(3)
CREATE TABLE (LcArcVmov_t) FREE ( NroMes c(LEN(VMOV.NroMes)), CodOpe c(LEN(VMOV.CodOpe)),;
								NroAst c(LEN(VMOV.NroAst)), FchAst D(8),;
								ImpChq c(25), Girado c(LEN(VMOV.Girado)),;
								NumLet c(80), NroCta c(LEN(CTAS.NroCta)),;
								NroChq c(LEN(VMOV.NroChq)), NomBco c(40),;
								Concepto c(LEN(VMOV.NotAst)), Concepto1 c(LEN(VMOV.NotAst)), TpoCmb N(7,4) )
USE (LcArcVmov_t) ALIAS Vmov_T EXCLUSIVE
INDEX ON NroMes+CodOpe+NroAst TAG VMOV_T01
SELE VMOV && Cabecera
SEEK XsNroMes+XsCodOpe+XsNroAst
SCAN WHILE NroMes+CodOpe+NroAst = XsNroMes+XsCodOpe+XsNroAst
	SELECT VMOV_T
	SEEK XsNroMes+XsCodOpe+XsNroAst
	IF !FOUND()
		APPEND BLANK
		replace NroMes WITH VMOV.NroMes
		replace CodOpe WITH VMOV.CodOpe
		replace NroAst WITH VMOV.NroAst
		replace FchAst WITH VMOV.FchAst
		XsImpChq = ALLTRIM(TRANSFORM(VMOV.ImpChq,"999,999,999.99"))
		XsImpChq = RIGHT(repli("*",LEN(VMOV_T.ImpChq)) + LTRIM(XsImpChq), LEN(VMOV_T.ImpChq))
		replace ImpChq WITH XsImpChq
		replace Girado WITH VMOV.Girado
		replace NumLet WITH NUMERO(VMOV.ImpChq,2,1)
		=SEEK(VMOV.CtaCja,"CTAS")
		replace NroCta WITH CTAS.NroCta
		replace NroChq WITH VMOV.NroChq
		XsCodBco = TRIM(CTAS.CodBco)
		=SEEK(TRIM(GSCLFBCO)+XsCodBco,"TABL")
		XsNomBco = TABL.Nombre
		replace NomBco WITH XsNomBco
		replace Concepto WITH VMOV.NotAst
		replace Concepto1 WITH mline(VMOV->GLOAST,1)
		REPLACE TpoCmb WITH VMOV.TpoCmb
	ENDIF
	SELECT RMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	SCAN WHILE NroMes+CodOpe+NroAst=XsNroMes+XsCodOpe+XsNroAst
		SELECT RMOV_T
		APPEND BLANK
		replace NroMes WITH RMOV.NroMes
		replace CodOpe WITH RMOV.CodOpe
		replace NroAst WITH RMOV.NroAst
		replace FchAst WITH RMOV.FchAst
		replace CodCta WITH RMOV.CodCta
		replace CodAux WITH RMOV.CodAux
		replace CodCco WITH VMOV.Auxil
		replace FchPro WITH RMOV.FchPro
		replace NroPro WITH RMOV.NroPro
		replace NroDoc WITH RMOV.NroDoc
		replace Glodoc WITH RMOV.Glodoc
		IF RMOV.CodMon = 2
			replace ImpUsa WITH RMOV.ImpUsa
		ELSE
			replace Import WITH RMOV.Import
		ENDIF
		IF RMOV.TpoMov="D"
			replace ImpDbe WITH RMOV.Import
		ELSE
			replace ImpHbe WITH RMOV.Import
		ENDIF
	ENDSCAN
ENDSCAN

************************
PROCEDURE xGenerar_Carta
************************
SELECT 0
WAIT WINDOW 'Generando carta al banco...espere un momento' TIMEOUT .2
LcArcVmov_t = GoEntorno.TmpPath+Sys(3)

CREATE TABLE (LcArcVmov_t) FREE ( NroMes c(LEN(VMOV.NroMes)), CodOpe c(LEN(VMOV.CodOpe)),;
								NroAst c(LEN(VMOV.NroAst)), FchAst D(8), Sectorista c(40),;
								ImpChq c(12), Girado c(LEN(VMOV.Girado)),CodMon n(1),;
								NumLet c(80), NroCta c(LEN(CTAS.NroCta)),;
								NroCar c(LEN(VMOV.NroChq)), NomBco c(40),;
								Concepto c(LEN(VMOV.NotAst)), NroCtaPro c(15) )
USE (LcArcVmov_t) ALIAS Vmov_T EXCLUSIVE
INDEX ON NroMes+CodOpe+NroAst TAG VMOV_T01
SELE VMOV && Cabecera
SEEK XsNroMes+XsCodOpe+XsNroAst
SCAN WHILE NroMes+CodOpe+NroAst = XsNroMes+XsCodOpe+XsNroAst
	SELECT VMOV_T
	SEEK XsNroMes+XsCodOpe+XsNroAst
	IF !FOUND()
		APPEND BLANK
		replace NroMes WITH VMOV.NroMes
		replace CodOpe WITH VMOV.CodOpe
		replace NroAst WITH VMOV.NroAst
		replace FchAst WITH VMOV.FchAst
		XsImpChq = ALLTRIM(TRANSFORM(VMOV.ImpChq,"999,999,999.99"))
		replace ImpChq WITH XsImpChq
		replace CodMon WITH VMOV.CodMon
		replace Girado WITH VMOV.Girado
		replace NumLet WITH NUMERO(VMOV.ImpChq,2,1)
		=SEEK(VMOV.CtaCja,"CTAS")
		replace sectorista WITH Ctas.SecBco
		replace NroCta WITH CTAS.NroCta
		replace NroCar WITH VMOV.NroChq
		XsCodBco = TRIM(CTAS.CodBco)
		=SEEK(TRIM(GSCLFBCO)+XsCodBco,"TABL")
		XsNomBco = TABL.Nombre
		replace NomBco WITH XsNomBco
		replace NroCtaPro WITH VMOV.NotAst
		replace Concepto  WITH MLINE(VMOV->GLOAST,1)
	ENDIF
ENDSCAN



****************************
procedure _vlook_cja
****************************
parameters var1,campo1,cBusca,cTablaLook
xSelect = SELECT()
UltTecla = LAStKEY()
IF UltTecla = F8
   SELECT (cTablaLook)
   IF ! CbdBusca(cBusca)
      =SELECT(xSelect) 
      return .T.
   ENDIF

   var1    = &campo1
   ulttecla= Enter
   =SELECT(xSelect) 
ENDIF
IF UltTecla = escape_ .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(VAR1,cTablaLook)
   RETURN .F.
ENDIF
RETURN .T.