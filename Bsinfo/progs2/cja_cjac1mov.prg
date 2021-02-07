*!* Caja Ingresos *!*
GlInterface_Ccb = .F.  && Poner esta variable en true (.T.)  cuando se accese a la rutina CtaCOB desde otro programa y/o Formulario
#include const.h 	
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
SYS(2700,0)           
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")

Do FONDO WITH 'INGRESOS DE CAJA '+cTitulo + '    USUARIO: '+ goEntorno.User.Login +'   '+' EMPRESA: '+TRIM(GsNomCia),'','',''

DIMENSION vTpoAst(40),vNroAst(40),vNotAst(40),vImport(40),vCodBco(40),vNroChq(40),vNroCta(40)
DIMENSION vCodCta(40),vCodAux(40),vNroRef(40),vImpCta(40),vTpoMov(40),vCodDoc(40),vcoddiv(40)
DIMENSION xCodCta(40),xCodMon(40),xNroRef(40),xCodAux(40),xcoddiv(40),pCodMon(40)
* * * *
TsCodDiv1= [01]
XsCodOpe = "001"     && INGRESOS DE CAJA
XsCodOp1 = "099"     && CLIENTES
* * * *
XsNroMes = TRANSF(_MES,"@L ##")
ZiCodMon = 1
ScrMov   = ""
MaxEle1  = 0
MaxEle2  = 0
Crear    = .T.
Modificar= .T.
*
store "" to xscjadiv, xscoddiv, xsclfaux,XsCtaPre,XsParFin
*
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XiNroVou,XsGloAst,XsCaux
STORE "" TO XsCtaCja,XfImpChq,XsNroChq,XsGirado,XsCodAux,XsAuxil,XsCodDo1,XsNroCh1
STORE 0  TO XfImpCh1,XfImpCh2,XfPorcen
XdFchAst = DATE()
XdFchPed = XdFchAst
XfTpoCmb = 3.5

PUBLIC LoContab as Contabilidad OF SYS(5)+"\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

RESTORE FROM LoContab.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE

*** Constantes para dibujar la pantalla ***
STORE 0 TO LinImpChq ,LinConcep,YoBrow1 ,YoBrow2 ,RowsBrow1,RowsBrow2,AnchoBrow1,AnchoBrow2

STORE 0 TO XoParFin,XoDesFin
** VETT 25/10/2019
Ll_Liqui_C=.F.
Ll_Liqui_D=.F.
***-------------------------------------***
WAIT WINDOW "Aperturando archivos..." NOWAIT 
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


WAIT WINDOW "Listo" Nowait
DO MOVgPant

Modificar = LoContab.Modificar 

SELECT CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
	GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
	DO LIB_MERR WITH 99
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
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

XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('Los valores máximos para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 ' Modificar en la opcion "Configuración de Diferencia de Cambio" en el Menu de Configuración.',0+64,'Aviso importante')
	 
ENDIF


LsClfAux = []
LsCodAux = []
UltTecla = 0
SELE OPER
SET FILTER TO MOVCJA=1
LOCATE

DO WHILE (.t.)
	RESTORE SCREEN FROM ScrMov
	*----- Control de Ingresos de Caja ----* vett 12-abr-2000
	SELE OPER
	XsCodOpe=CodOpe
	@ 2,2  SAY "OPERACION: " COLOR SCHEME 11
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
*!*		IF XsCodOpe<"001" .or. XsCodOpe>"019"
*!*			GsMsgErr = "Operaci¢n "+XsCodOpe+" invalida"
*!*			DO LIB_MERR WITH 99
*!*			LOOP
*!*		ENDIF
	SEEK XsCodOpe
	IF !FOUND()
		GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
		DO LIB_MERR WITH 99
		LOOP
	ENDIF
*!*		@ 2,12 SAY XsCodOpe+" "+LEFT(OPER->NomOpe,20)
	@ 0,0  SAY PADC(XsCodOpe+" "+LEFT(OPER->NomOpe,20),38) COLOR SCHEME 7
	@ 2,12 SAY XsCodOpe  COLOR SCHEME 11
	DO MOVNoDoc
	SELECT VMOV
	DO CASE
		CASE UltTecla = 0
			Loop
		CASE UltTecla = Escape_
			EXIT
		CASE UltTecla = F9                       && Borrado (Queda Auditado)
			IF !hasaccess('IngresosCaja_Eliminar') 
				=MESSAGEBOX('Acceso denegado',16,'Anulacion de Voucher')
				LOOP
			ENDIF 
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
			IF !hasaccess('IngresosCaja_Eliminar') 
				=MESSAGEBOX('Acceso denegado',16,'Anulacion de Voucher')
				LOOP
			ENDIF 
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
				UltTecla = 0
			ENDIF
			IF (LnImprimir # 6 AND hasaccess('IngresosCaja_Modificar') ) OR (Crear AND hasaccess('IngresosCaja_Adicionar'))
				
				DO MOVEdita
			ELSE

			ENDIF
			IF UltTecla <> Escape_  
				IF (LnImprimir # 6 AND hasaccess('IngresosCaja_Modificar') ) OR (Crear AND hasaccess('IngresosCaja_Adicionar'))
					DO MOVGraba
				ENDIF	
				IF UltTecla <> Escape_ AND hasaccess('IngresosCaja_Consultar') 
					DO FORM cja_cjatporp
*!*						@ 10,28 CLEAR TO 13,59  COLOR SCHEME 11
*!*						@ 10,28 TO 13,59
*!*						xElige = 1
*!*						VECOPC(1) = " ** VOUCHER CON FORMATO ** "
*!*						VECOPC(2) = " ** VOUCHER SIN FORMATO ** "
*!*						xElige = Elige(xElige,12,30,2)
*!*						IF LASTKEY() # Escape_
*!*							DO CASE 
*!*								CASE XELIGE=1              
*!*									DO MovPrin2
*!*								CASE XELIGE=2              
*!*									DO f0print &&IN ADMPRINT
*!*									DO MovPrint
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

************************************************
* Procedimiento de Apertura de archivos a usar *
************************************************
PROCEDURE MOVAPERT
******************
** Abrimos areas a usar **
SELECT 1
USE CBDTCIER
RegAct = _Mes + 1
Modificar = .T.
IF RegAct <= RECCOUNT()
	GOTO RegAct
	Modificar = ! (Cierre  .OR. CjaBco)
ENDIF
SELE 1
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF ! USED(1)
	RETURN
ENDIF
SELE 2
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF ! USED(2)
	RETURN
ENDIF
SELE 3
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF ! USED(3)
	RETURN
ENDIF

SELE 4
USE cbdrmovm ORDER rmov01   ALIAS RMOV
IF ! USED(4)
	RETURN
ENDIF

SELE 5
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF ! USED(5)
	RETURN
ENDIF
SELE 6
USE cbdtoper ORDER oper01   ALIAS OPER
IF ! USED(6)
	RETURN
ENDIF
SELE 7
USE cbdacmct ORDER acct01   ALIAS ACCT
IF ! USED(7)
	RETURN
ENDIF
SELE 8
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF ! USED(8)
	RETURN
ENDIF
SELE 9
USE CJATPROV ORDER prov01   ALIAS PROV
IF ! USED(9)
	RETURN
ENDIF
* SELE 0
* USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
* IF !USED()
*    CLOSE DATA
*    RETURN
* ENDIF
***
*SELE 0
*USE CCBMVTOS ORDER VTOS03 ALIAS CMOV
*IF ! USED()
*   CLOSE DATA
*   RETURN
*ENDIF
***
*SELE 0
*USE CCBTBDOC ORDER BDOC01 ALIAS TDOC
*IF ! USED()
*   CLOSE DATA
*   RETURN
*ENDIF
SELECT RMOV
RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
*!*	@ 0,0 FILL TO 24,80 color scheme 11
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY PADC("* VOUCHER DE INGRESOS *",38) COLOR SCHEME 7
*!*	@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 6,79 COLOR SCHEME 11
@ 1,50 SAY "N§ COMPROBANTE.:" COLOR SCHEME 11
@ 3,50 SAY "FECHA..........:" COLOR SCHEME 11
@ 3,00 SAY "CUENTA..:" COLOR SCHEME 11
@ 4,50 SAY "T/CAMBIO.......:" COLOR SCHEME 11
@ 5,50 SAY "FCH.DE FINANZAS:" COLOR SCHEME 11
@ 5,00 SAY "TD.:     N§:" COLOR SCHEME 11

DO CASE
	CASE gocfgcbd.C_COSTO = 3
		@ 5,30 SAY "C.COSTO:"
	CASE gocfgcbd.C_COSTO = 2
		@ 5,30 SAY "C.COSTO:"
	CASE gocfgcbd.C_COSTO = 1	
		@ 5,30 SAY "C.COSTO:"
	OTHER
		@ 5,30 SAY "AUXIL:  "
ENDCASE

IF gocfgcbd.TIPO_CONSO = 2
	@ 6,25 SAY [DIV.:]
ENDIF

DO CASE
	CASE gocfgcbd.PidPre 
		@ 7,15 SAY  UPPER(TRIM(gocfgcbd.GloPre))  COLOR SCHEME 11
	OTHER
		@ 7,15 SAY SPACE(15)
ENDCASE

LnLenParFin = 0
IF VARTYPE(VMOV.ParFin)='C'
	LnLenParFin = LEN(VMOV.ParFin)
ENDIF
XoParFin = 15 + LEN(TRIM(gocfgcbd.GloPre)) 

XoDesFin = XoParFin + LnLenParFin + 1

YoBrow1= 8
RowsBrow1 = 10
YoBrow2= YoBrow1 + RowsBrow1 +2 && 12 
RowsBrow2 = 10
AnchoBrow1 = 80
AnchoBrow2 = 80


LinImpChq = YoBrow2 + RowsBrow2  && 18
LinConcep = LinImpChq + 1 && 19


@ YoBrow1,00 TO YoBrow1+RowsBrow1-1,AnchoBrow1 - 1 COLOR SCHEME 11
@ YoBrow1,01 SAY "ð Tipo  ð N§ PROV.ð         C O N C E P T O                ð         IMPORTE ð" COLOR SCHEME 7

@ YoBrow2,00 TO YoBrow2+RowsBrow2-1,AnchoBrow2 - 1 COLOR SCHEME 11
*!*	@ 12,01 SAY "ðCTAS.ð      C O N C E P T O       ð AUXI.ð TD.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
*  	   XXXXX 123456789-123456789-123456789-1234 12345 123456789- 123123456789-1234S
@ YoBrow2,01 SAY "DV -CTAS.-   C O N C E P T O       ð AUXI.ð TD.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
@ LinImpChq,00 SAY "IMPORTE....:" COLOR SCHEME 11
@ LinConcep,00 SAY "CONCEPTO...:" COLOR SCHEME 11
SAVE SCREEN TO SCRMOV
RETURN

************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
i = 1
XsNroAst = LoContab.NROAST()
*!*	RESTORE SCREEN FROM ScrMov
Crear = .t.
*!* Posicionamos en el ultimo registro + 1 *!*
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
					IF !BOF()
						SKIP -1
					ENDIF
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
*!*						RESTORE SCREEN FROM ScrMov
					Crear = .t.
					EXIT
				ENDIF
				IF ! FOUND()
					DO LIB_MERR WITH 9
					UltTecla = 0
				ELSE
					IF VMOV->FlgEst = "A"
						DO LIB_MERR WITH 14
						UltTecla = 0
						DO DIRPRINT &&IN ADMPRINT
						IF LASTKEY() # Escape_
							DO MovPrint
						ENDIF
						SET DEVICE TO SCREEN
					ENDIF
				ENDIF
			ENDIF
	ENDCASE
	IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
		XsNroAst = LoContab.NROAST()
*!*			RESTORE SCREEN FROM ScrMov
		DO LIB_MTEC WITH 2
		Crear = .t.
	ELSE
		XsNroAst = VMOV->NroAst
		IF HasAccess('IngresosCaja_Consultar') OR HasAccess('IngresosCaja_Modificar')
			DO MovPinta
		ELSE
		    =MESSAGEBOX('Acceso denegado',16,'Consulta/Modificación Voucher')	
		ENDIF

		Crear = .f.
	ENDIF
ENDDO
@ 1,68 SAY XsNroAst  COLOR SCHEME 11
SELECT VMOV
IF UltTecla=Escape_
	UltTecla = 0
ENDIF
RETURN

**************************************
* Procedimiento inicializa variables *
**************************************
PROCEDURE MOVInVar
******************
MaxEle1  = 0
MaxEle2  = 0
XnCodMon = 1
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
XsCtaCja = SPACE(LEN(RMOV->CODCTA))
xscjadiv = space(len(rmov->coddiv))
XiNroVou = 0
XfImpChq = 0
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = LEFT(SPACE(LEN(VMOV->NroChq)),10)
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsAuxil  = SPACE(LEN(VMOV->Auxil ))
XsCodDo1 = SPACE(LEN(RMOV->CodDoc))
XsParFin = IIF(VARTYPE(Vmov.Parfin)='C',SPACE(LEN(VMOV.ParFin)),'')
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
XdFchPed = VMOV.FchPed
XsDigita = GsUsuario
XsCtaCja = CtaCja
XsCodOpe = CodOpe
XiNroVou = VAL(NroVou)
XfImpChq = ImpChq
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = VMOV->NroChq
XfTpoCmb = VMOV->TpoCmb
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsAuxil  = Auxil
XsNroChq = LEFT(VMOV.NroChq,10)
XsParFin = IIF(VARTYPE(Vmov.Parfin)='C',VMOV.ParFin,'')
* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS
xscjadiv = space(len(rmov.coddiv))
SELE rmov
SET ORDER TO rmov07
SEEK (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
IF FOUND()
	xscjadiv = rmov.coddiv
ENDIF
SET ORDER TO rmov01
SELE vmov
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS

*
*
=SEEK(CtaCja,"CTAS")
@ 01,68 SAY NroAst  && COLOR SCHEME 11
*@ 02,68 SAY NroVou
@ 03,68 SAY FchAst  && COLOR SCHEME 11
DO CASE
	CASE CtaCja = "104"
		@ 02,2  SAY " ****** CUENTAS CORRIENTES ******* "  && COLOR SCHEME 11
	CASE CtaCja = "108"
		@ 02,2  SAY " ****** CUENTAS DE AHORRO ******** "   && COLOR SCHEME 11
	CASE CtaCja = "101"
		@ 02,2  SAY " ******** CUENTAS DE CAJA ******** "  && COLOR SCHEME 11
ENDCASE
@ 03,10 SAY CtaCja+" "+CTAS->NomCta pict "@S38"    && COLOR SCHEME 11
@ 04,02 SAY "N§ CUENTA : "+CTAS->NroCta+" "+CTAS->RefBco  pict "@S38" && COLOR SCHEME 11
@ 4 ,68 SAY TpoCmb PICT "9999.9999"   && COLOR SCHEME 11
@ 05,68 SAY FchPed   && COLOR SCHEME 11
@ 5,04  SAY XsCodDo1
@ 5,12  SAY VMOV.NroChq  && COLOR SCHEME 11
@ 5 ,38 SAY Auxil  && COLOR SCHEME 11

IF VARTYPE(VMOV.PARFIN)='C'
	=SEEK(PADR(VMOV.ParFin,LEN(PPRE.CtaPre)),"PPRE")
	@ 07,XoParFin SAY ParFin
	@ 07,XoDesFin SAY PPRE.NomBre PICT "@S30"
ENDIF



IF gocfgcbd.TIPO_CONSO = 2
	xscjadiv = space(len(rmov.coddiv))
	sele rmov
	set order to rmov07
	seek (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
	if found()
		xscjadiv = rmov.coddiv
	endif
	set order to rmov01
	sele vmov

	@06,30 say xscjadiv
	@06,33 say iif(seek([DV ]+xscjadiv,[auxi]),left(auxi.nomaux,11),space(11))
ENDIF
IF VMOV->CodMon = 1
	XnCodMon = 1
	@ LinImpChq,14 say "S/. "  && COLOR SCHEME 11
ELSE
	XnCodMon = 2
	@ LinImpChq,14 say "US$ "  && COLOR SCHEME 11
ENDIF
@ YoBrow1 + 1,01 clear TO YoBrow1 + RowsBrow1 - 2,AnchoBrow1 - 2  && COLOR SCHEME 11
@ YoBrow2 + 1,01 CLEAR TO YoBrow2 + RowsBrow2 - 2,AnchoBrow2 - 2  && COLOR SCHEME 11
@ YoBrow1 + 1,01 FILL TO YoBrow1 + RowsBrow1 - 2,AnchoBrow1 - 2  && COLOR SCHEME 11
@ YoBrow2 + 1,01 FILL TO YoBrow2 + RowsBrow2 - 2,AnchoBrow2 - 2  && COLOR SCHEME 11
LinAct1 = YoBrow1 + 1
LinAct2 = YoBrow2 + 1
IF VMOV->FlgESt = "A"
	@ LinAct1,0 say []
	@ ROW()  ,11 SAY "     #    #    #  #    # #         #    #####   ######  "  && COLOR SCHEME 11
	@ ROW()+1,11 SAY "   #####  # #  #  #    # #       #####  #    #  #    #  "  &&  COLOR SCHEME 11
	@ ROW()+1,11 SAY "  #     # #   ##  ###### ###### #     # #####   ######  "  &&  COLOR SCHEME 11
ENDIF
**** Buscando Datos Ventana 1 ****
SELECT RMOV
LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
SEEK LsLLave
MaxEle1 = 0
MaxEle2 = 0
XsCodAux = ""
Ancho    = 74
Xo       = INT((80 - Ancho)/2)
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
	DO CASE
*!*			CASE EliItm = CHR(255)
		CASE EliItm = chr(43)   
			IF MaxEle1 >= 40
				SKIP
				LOOP
			ENDIF
			XfImport = IIF(TpoMov#"D",1,-1)*Import
			XfImpUsa = IIF(TpoMov#"D",1,-1)*ImpUsa
			IF EMPTY(XsCodAux)
				XsCodAux = CodAux
				XsClfAux = ClfAux
*!*					@ 21,14 SAY XsCodAux
				=SEEK(XsClfAux+XsCodAux,"AUXI")
				XsNomAux = AUXI->NomAux
*!*					@ 21,22 SAY AUXI->NomAux PICT "@S50"
			ENDIF
			MaxEle1= MaxEle1+ 1
			*!* Revisar *!*
			vNroAst(MaxEle1) = NroDoc
			vTpoAst(MaxEle1) = CodDoc
			vNotAst(MaxEle1) = GloDoc
			xCodCta(MaxEle1) = CodCta
			xCodMon(MaxEle1) = CodMon
			xNroRef(MaxEle1) = NroRef
			xCodAux(MaxEle1) = CodAux
			xcoddiv(maxele1) = coddiv         
			vCodBco(MaxEle1) = CodBco
			vNroChq(MaxEle1) = NroChq
			vNroCta(MaxEle1) = NroCta
			IF VMOV->CodMon = 1
				vImport(MaxEle1) = XfImport
			ELSE
				vImport(MaxEle1) = XfImpUsa
			ENDIF
			IF LinAct1 < YoBrow1 + RowsBrow1 - 1 && 11
				DO GENbline WITH MaxEle1, LinAct1
				LinAct1 = LinAct1 + 1
			ENDIF
*!*			CASE EliItm = "ð" .AND. MaxEle1 > 0
		CASE EliItm = "-" .AND. MaxEle1 > 0     
			IF MaxEle1 >= 40
				SKIP
				LOOP
			ENDIF
			IF VMOV->CodMon = 1
				vImport(MaxEle1) = vImport(MaxEle1)+IIF(TpoMov#"D",1,-1)*Import
			ELSE
				vImport(MaxEle1) = vImport(MaxEle1)+IIF(TpoMov#"D",1,-1)*ImpUsa
			ENDIF
			IF MaxEle1 < 6
				DO GENbline WITH MaxEle1, LinAct1-1
			ENDIF
*!*			CASE ! INLIST(EliItm,"ù","ú","ø")
		CASE ! INLIST(EliItm,".","*",":")     
			IF MaxEle2 >= 40
				SKIP
				LOOP
			ENDIF
			MaxEle2 = MaxEle2 + 1
			=SEEK(CodCta,"CTAS")
			vCodCta(MaxEle2) = CodCta
			IF EMPTY(XsCodAux) .AND. CTAS->PIDAUX="S"
				XsCodAux = CodAux
				XsClfAux=  ClfAux
			ENDIF
			vcoddiv(maxele2) = coddiv
			vCodAux(MaxEle2) = CodAux
			vNroRef(MaxEle2) = NroDoc
			vCodDoc(MaxEle2) = CodDoc
			vTpoMov(MaxEle2) = TpoMov
			IF VMOV->CodMon = 1
				vImpCta(MaxEle2) = Import
			ELSE
				vImpCta(MaxEle2) = ImpUsa
			ENDIF
			IF LinAct2 < YoBrow2 + RowsBrow2 - 1 && 17
				DO GENblin2 WITH MaxEle2, LinAct2
				LinAct2 = LinAct2 + 1
			ENDIF
*!*			CASE INLIST(EliItm,"ù")
		CASE INLIST(EliItm,".")     
			XsCodDo1=RMOV->CodDoc
			@ 05,04 say XsCodDo1  && COLOR SCHEME 11
	ENDCASE
	SELECT RMOV
	SKIP
ENDDO
XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAux))
SELECT VMOV
@ LinImpChq ,18 SAY VMOV->ImpChq PICT "99,999,999,999.99"   && COLOR SCHEME 11
@ LinConcep ,14 SAY VMOV->NotAst  && COLOR SCHEME 11
RETURN

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
*****************************************************
* Procedimiento que edita las variables de cabezera *
*****************************************************
PROCEDURE MOVEdita
IF Crear
	IF ! (YEAR(DATE()) = _Ano .AND. MONTH(DATE()) = _Mes)
		IF ! ALRT("Fecha no corresponde al mes de Trabajo")
			UltTecla = Escape_
			RETURN
		ENDIF
	ENDIF
ENDIF
UltTecla = 0
I        = 1
DO LIB_MTEC WITH 7
cCodCta = "104"
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape_)
	DO CASE
		CASE I = 1
			@ 3,68 GET XdFchAst PICT "@RD dd/mm/aa" 
			READ
			UltTecla = LastKey()
			@ 3,68 SAY XdFchAst PICT "@RD dd/mm/aa"  COLOR SCHEME 11
	        XdFchPed = IIF(Crear,XdFchAst,XdFchPed)
		CASE I = 2
			IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
				?? CHR(7)
				WAIT "No Registrado el tipo de Cambio" NOWAIT WINDOW
			ENDIF
			&& VETT - 22-05-2005  , igual que el Diario General.
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
			@ 4 ,68 SAY XfTpoCmb PICT "9999.9999"  COLOR SCHEME 11
			IF UltTecla = Escape_
				EXIT
			ENDIF
		CASE I = 3
			@ 5 ,68 GET XdFchPed PICT "@RD dd/mm/aa"
			READ
			UltTecla = LastKey()
			@ 5 ,68 SAY XdFchPed PICT "@RD dd/mm/aa"  COLOR SCHEME 11
		CASE I = 4
			DO CASE
				CASE XsCtaCja = "104"
					xElige = 1
				CASE XsCtaCja = "108"
					xElige = 2
				CASE XsCtaCja = "101"
					xElige = 3
				OTHER
					xElige = 4
			ENDCASE
			DIMENSION VecOpc(4)
			VECOPC(1) = " ***** CUENTAS CORRIENTES ******** "
			VECOPC(2) = " ***** CUENTAS DE AHORRO  ******** "
			VECOPC(3) = " ******  CUENTAS DE CAJA  ******** "
			VECOPC(4) = " ****** CUENTAS ADELANTOS ******** "
			xElige = Elige(xElige,2,2,4)
			DO CASE
				CASE XElige  = 1
					cCodCta = "104"
				CASE XElige  = 2
					cCodCta = "108"
				CASE XElige  = 3
					cCodCta = "101"
				CASE XElige =  4
					cCodCta = "121"  && No emitidas
			ENDCASE
		CASE I = 5
			SELECT CTAS
			IF xElige<=3
				zCodCta = SUBSTR(XsCtaCja,4)
				@ 03,10 SAY cCodCta  COLOR SCHEME 11
				@ 03,13 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-3)
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					EXIT
				ENDIF
				XsCtaCja = cCodCta+zCodCta
			ELSE
				zCodCta = SUBSTR(XsCtaCja,3)
				@ 03,10 SAY cCodCta  COLOR SCHEME 11
				@ 03,13 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-2)
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape_
					EXIT
				ENDIF
				XsCtaCja = cCodCta+zCodCta
			ENDIF
			IF UltTecla = Arriba
				I = 5
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
			@ 03,10 SAY XsCtaCja+" "+NomCta pict "@S38"  COLOR SCHEME 11
			@ 04,02 SAY "N§ CUENTA : "+NroCta+" "+RefBco pict "@S38" COLOR SCHEME 11
			IF CTAS->CodMon = 1
				XnCodMon = 1
				@ LinImpChq,14 say "S/. "  COLOR SCHEME 11
			ELSE
				XnCodMon = 2
				@ LinImpChq,14 say "US$ "   COLOR SCHEME 11
			ENDIF
			@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"
		CASE i = 6
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
				GsMsgErr = "C¢digo de documento inv lido"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ 05,04 SAY XsCodDo1 PICT "@!"  COLOR SCHEME 11
		CASE I = 7  && .AND. EMPTY(XsNroChq)
			@ 05,12 GET XsNroChq PICT "@!"
			READ
			UltTecla = LASTKEY()
			@ 05,12 SAY XsNroChq  COLOR SCHEME 11
		CASE I = 8
			DO CASE 
				CASE gocfgcbd.C_COSTO = 1
					XsClfAux=PADR(GsClfCCt,LEN(AUXI.ClfAux))
					SELE AUXI
					@ 05,38 GET XsAuxil  PICT "@!"
					READ
					UltTecla = LASTKEY()
					IF UltTecla = Escape_
						EXIT
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
							EXIT
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
		CASE I = 9   &&& PIDE DIVISIONARIA
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
				@ 06,30 SAY XsCjaDiv PICT "XX"   COLOR SCHEME 11
				@ 06,33 say left(auxi.nomaux,11)  COLOR SCHEME 11
			ENDIF
		CASE I = 10	AND gocfgcbd.PidPre 

			SELECT PPRE
			IF GoCfgCbd.TIPO_CONSO = 2
				SET FILTER TO CodDiv = TRIM(XsCjaDiv)
			ENDIF
			@ 07,XoParFin GET XsParFin PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape_
				EXIT
			ENDIF
			IF UltTecla = F8
				IF ! CbdBusca("PPRE")
					UltTecla = 0
					LOOP
				ENDIF
				XsParFin = PPRE.CtaPre
			ENDIF
			SEEK XsParFin
			IF !FOUND()
				GsMsgErr = "Código no existe"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ 07,XoParFin SAY XsParFin+ ' ' + PPRE.NomBre  PICT "@S43"
			SET FILTER TO IN PPRE
		CASE I = 11
			DO COMPROBAN

			XfImpCh1 = 0
			FOR ii = 1 to MaxEle1
				XfImpCh1 = XfImpCh1 + vImport(ii)
			ENDFOR
			XfImpCh2 = 0
			FOR ii = 1 to MaxEle2
				XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="H",1,-1)
			ENDFOR
			XfImpChq = XfImpCh1 + XfImpCh2
			@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
			IF LASTKEY() = Escape_
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
		CASE I = 12
			DO VOUCHER
			XfImpCh1 = 0
			FOR ii = 1 to MaxEle1
				XfImpCh1 = XfImpCh1 + vImport(ii)
			ENDFOR
			XfImpCh2 = 0
			FOR ii = 1 to MaxEle2
				XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="H",1,-1)
			ENDFOR
			XfImpChq = XfImpCh1 + XfImpCh2
			@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
			IF LASTKEY() = Escape_
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
		CASE I = 13
			@ LinConcep, 14 GET XsNotAst PICT "@!"
			READ
			UltTecla = LastKey()
			@ LinConcep, 14 SAY XsNotAst PICT "@!"  COLOR SCHEME 11
		CASE I = 14
			SAVE SCREEN
			@ LinImpChq,00 TO LinImpChq+4,79 DOUBLE
			@ LinImpChq,03 SAY "OBSERVACIONES" COLOR SCHEME 7
			GsMsgKey = "[S-TAB] Campo anterior     [Esc] Cancela    [F10] Siguiente Campo "
			DO LIB_MTEC WITH 99
			@ LinConcep,1 EDIT XsGloAst SIZE 3,78 COLOR SCHEME 7
			READ
			RESTORE SCREEN
			UltTecla = LastKey()
			IF UltTecla = BackTab .OR. UltTecla = Escape_
				UltTecla = Arriba
			ENDIF
			IF UltTecla = 9
				UltTecla = CtrlW
			ENDIF
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>14,14, i)
	i = IIF(i<1, 1, i)
ENDDO
SELECT VMOV
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
Yo       = YoBrow1  && 7
Largo    = RowsBrow1 && 5
Ancho    = AnchoBrow1
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle1
TotEle   = 40     && M ximos elementos a usar
DO ABROWSE
MaxEle1 = MaxEle
@ YoBrow1 + RowsBrow1 - 1,1   TO YoBrow1 + RowsBrow1 - 1,AnchoBrow1 - 2  && COLOR SCHEME 11
IF MaxEle1 = 1 .AND. EMPTY(LEFT(vNroAst(1),6))
	MaxEle1 = 0
	@ YoBrow1 + 1,01 CLEAR TO YoBrow1 + RowsBrow1 - 2 ,AnchoBrow1 - 2
ENDIF
@ YoBrow1 + 1,01 Fill TO YoBrow1 + RowsBrow1 - 2,AnchoBrow1 - 2  COLOR SCHEME 16
IF LASTKEY() = Escape_
	RETURN
ENDIF
RETURN
*****************************************
* Objeto : Escribe una linea del browse *
*****************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin
@ NumLin,3  SAY vTpoAst(NumEle)  && COLOR SCHEME 11
@ NumLin,09 SAY vNroAst(NumEle) PICT "@R 999-99999999"   && COLOR SCHEME 11
@ NumLin,21 SAY vNotAst(NumEle) PICT "@S40"  && COLOR SCHEME 11
@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")  &&  COLOR SCHEME 11
@ NumLin,64 SAY vImport(NumEle) PICT "###,###,###.##"  &&  COLOR SCHEME 11
IF VARTYPE(LeeReg)='L' AND VARTYPE(xCodAux(numele))='C' AND VARTYPE(vNotAst(numele))='C'
	@YoBrow2-2,8 SAY "Cliente : " + xCodAux(numele)+" "+vNotAst(numele) PICT "@S60"  color r+/n
ELSE
	@YoBrow2-2,8 SAY SPACE(60) COLOR SCHEME 11	
ENDIF
RETURN

****************************
* Objeto : Edita una linea *
****************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin, LiUtecla
LsTpoAst = vTpoAst(NumEle)
LsNroAst = vNroAst(NumEle)
LfImport = vImport(NumEle)
LsNotAst = vNotAst(NumEle)
LsCodBco = vCodBco(NumEle)
LsNroChq = vNroChq(NumEle)
LsNroCta = vNroCta(NumEle)
UltTecla = 0
*
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
			@ NumLin,3   SAY LsTpoAst PICT "@!"  COLOR SCHEME 11
			SEEK LsTpoAst
			IF ! FOUND()
				GsMsgErr = "** COD. DOCUMENTO NO REGISTRADO **"
				DO LIB_Merr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
		CASE i = 2
			IF PROV->TIPO$"AM" .and. EMPTY(SUBSTR(LsNroAst,8,2))
*!*					LsNroAst = SUBSTR(LsNroAst,1,8)+"-"+STR(_ANO,4)+" "
			ENDIF
			IF PROV->TIPO$"C" .and. EMPTY(LsNroAst)
				LsNroAst = "001"+SPACE(7)
			ENDIF
			DO CASE
				CASE PROV->TIPO$"AM"
					@ NumLin,09  GET LsNroAst PICT "!!!!!!!!!!!!!!"
				CASE PROV->TIPO="C"
*!*						@ NumLin,09  GET LsNroAst PICT "999-999999"
					IF INLIST(PROV.TpoDoc,'FAC','BOL')
						@ NumLin,09  GET LsNroAst PICT "@R 999-99999999"
					ELSE 
						@ NumLin,09  GET LsNroAst PICT "@R XXXXXXXXXX"
					ENDIF 
				OTHER
					@ NumLin,09  GET LsNroAst PICT "@!"
			ENDCASE
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
				IF PROV->TIPO="C"
					DO FORM ccb_consultadocumentos.scx WITH LsTpoAst TO XS
					LsNroAst = XS
					UltTecla = Enter
				ELSE
					LOOP
				ENDIF		
			ENDIF
			IF PROV->TIPO="C"
*!*					LsNroAst = RIGHT("000"+ALLTRIM(LEFT(LsNroAst,3)),3)+"-"+RIGHT("00000"+ALLTRIM(SUBS(LsNroAst,5,6)),6)
*!*					LsNroAst = PADR(LsNroAst,GDOC.NroDoc)
				IF INLIST(PROV.TpoDoc,'FAC','BOL')
					@ NumLin,09  SAY LsNroAst PICT "@R 999-99999999"  COLOR SCHEME 11
				ELSE
					@ NumLin,09 SAY LsNroAst PICT "@R XXXXXXXXXX"    COLOR SCHEME 11
				ENDIF    
			ENDIF
			IF ! CHKNROAST()
				UltTecla = 0
				LOOP
			ENDIF
			@ NumLin,21 SAY LsNotAst PICT "@S40"  COLOR SCHEME 11
		CASE i = 3
			@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")  COLOR SCHEME 11
			@ NumLin,64 GET LfImport PICT "###,###,###.##" &&VALID LfImport > 0
			READ
			UltTecla = LASTKEY()
		CASE i = 4
			*!* Pide Datos Adicionales de Cancelacion *!*
			DO GENbedi1
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
	vCodBco(NumEle) = LsCodBco
	vNroChq(NumEle) = LsNroChq
	vNroCta(NumEle) = LsNroCta
ENDIF
XfImpCh1 = 0
FOR ii = 1 to MaxEle
	XfImpCh1 = XfImpCh1 + vImport(ii)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
LiUTecla = UltTecla
RETURN
************************************
* Objeto : Edita datos adicionales *
************************************
PROCEDURE GENbedi1
*4         5         2         7         *
*01234567890123456789012345678901234567890
*ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
*º      Banco :                      º
*º No. Cuenta :                      º
*º No. Cheque :                      º
*ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
SAVE SCREEN
@ NumLin-2,40 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 17
@ NumLin-1,40 SAY "º      Banco :                      º" COLOR SCHEME 17
@ NumLin  ,40 SAY "º No. Cuenta :                      º" COLOR SCHEME 17
@ NumLin+1,40 SAY "º No. Cheque :                      º" COLOR SCHEME 17
@ NumLin+2,40 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 17

UltTecla = 0
PRIVATE i
i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape_)
	DO CASE
		CASE i = 1
			XsTabla = "04"
			@ NumLin-1,55 GET LsCodBco PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF LastKey() = F8
				SELECT TABL
				IF ! CBDBUSCA("TABL")
					LOOP
				ENDIF
				SELECT CTAS
				LsCodBco = LEFT(TABL->CODIGO,LEN(LsCodBco))
			ENDIF
			@ NumLin-1,55 SAY LsCodBco COLOR SCHEME 7
			IF !EMPTY(LsCodBco) .AND. ! SEEK(XsTabla+LsCodBco,"TABL")
				GsMsgErr = "Banco no registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
		CASE i = 2
			@ NumLin  ,55 GET LsNroCta PICT "@!"
			READ
			UltTecla = LASTKEY()
		CASE i = 3
			@ NumLin+1,55 GET LsNroChq PICT "@!"
			READ
			UltTecla = LASTKEY()
	ENDCASE
	IF i = 3 .AND. UltTecla = Enter
		EXIT
	ENDIF
	i = IIF(INLIST(UltTecla,BackTab,Arriba), i-1, i+1)
	i = IIF( i > 3 , 3, i)
	i = IIF( i < 1 , 1, i)
ENDDO
RESTORE SCREEN
IF UltTecla = Escape_
	UltTecla = Izquierda
ENDIF
RETURN

*****************************************************
* Objeto : Chequeando la existencia de la provisi¢n *
*****************************************************
PROCEDURE CHKNROAST
*******************
lNoMostraMensaje = GlInterface_CCB

** Verificando que no se repita en otro item **
IF !GlInterface_CCb
	IF MaxEle > 1
		FOR z = 1 TO MaxEle
			IF Z#NumEle .AND. vTpoAst(z)=LsTpoAst .AND. vNroAst(z)=LsNroAst
				GsMsgErr = "*!* Nro. de Documento ya registado en otro item *!*"
				DO LIB_MERR WITH 99,lNoMostraMensaje
				RETURN .F.
			ENDIF
		NEXT
	ENDIF
ENDIF

XsCodOp1  = PROV->CodOpe
XcTipo    = PROV->Tipo
XsCodDocPrv = PADR('',LEN(RMOV.TipDoc))   && Codigo de documento de la provision generalmente coindicide con tabla de la SUNAT
LlChkCodDocPrv = .f.
SELECT PROV
SCATTER MEMVAR 
IF VARTYPE(m.CodDoc)='C'
	XsCodDocPrv = PADR(PROV.CodDoc,LEN(RMOV.TipDoc))
	LlChkCodDocPrv =IIF(EMPTY(PROV.CodDoc),.F., .T.)
ENDIF

LlChkCodDocPrv = (LlChkCodDocPrv AND  VerifyTag('RMOV','RMOV11'))
IF XcTipo = "C"   && Cuentas por Cobrar
	RETURN CTACOB()
ENDIF
*** Seleccionando la cuentas alternativas ***
LsNroAst=PADR(LsNroAst,LEN(RMOV.NroDoc))
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
FOR Z = 1 TO NumCta
	LsCodCta = xxCodCta(Z)
	SELECT RMOV
	IF LlChkCodDocPrv
		SET ORDER TO RMOV11 		&& EL NUEVO INDICE ES CODCTA+TIPDOC+NRODOC+CODAUX  VETT 27/03/2006
		SEEK LsCodCta + XsCodDocPrv + LsNroAst
	ELSE
		SET ORDER TO RMOV05			
		SEEK LsCodCta + LsNroAst
	ENDIF
	IF FOUND()
		LsClfAux=RMOV->ClfAux
		LsCodAux=RMOV->CodAux
		XsNomAux = ""
		LfImport = 0
		=SEEK(NroMes+CodOpe+NroAst,"VMOV")
		LsNotAst = VMOV->NotAst
		xCodCta(NumEle) = CodCta
		xCodMon(NumEle) = CodMon
		xNroRef(NumEle) = NroREf
		xCodAux(NumEle) = CodAux
		IF LsCodAux = "999"
			XsNomAux = RMOV->GloDoc
		ENDIF
		IF NROMES = "00"
			LsNotAst = RMOV->GloDoc
		ENDIF
		IF LlChkCodDocPrv		&& VETT 27/03/2006
			LsCmpEval = [CodCta+TipDoc+NroDoc+CodAux]
			LLave = xCodCta(NumEle)+XsCodDocPrv+LsNroAst+xCodAux(NumEle)
		ELSE
			Llave = xCodCta(NumEle)+LsNroAst+xCodAux(NumEle)
			LsCmpEval = [CodCta+NroDoc+CodAux]
		ENDIF
		SdoNac = 0
		SdoUsa = 0
		DO WHILE ! EOF() .AND. &LsCmpEval. = Llave
			IF CodOpe == PROV->CodOpe OR (nromes=[00] and codope=[000])
				xcoddiv(numele) = coddiv 
				xCodMon(NumEle) = CodMon
				xNroRef(NumEle) = NroREf
				=SEEK(NroMes+CodOpe+NroAst,"VMOV")
				LsNotAst = VMOV->NotAst
				IF LsCodAux = "999"
					XsNomAux = RMOV->GloDoc
				ENDIF
				IF !EMPTY(RMOV.CodAux) AND RMOV.NroMes='00'
					=SEEK(LsClfAux+RMOV.CodAux,"AUXI")
					LsNotAst = AUXI.NomAux
				ENDIF	
				
			ENDIF
			SdoNac   = SdoNac   + IIF(TpoMov#"D",-1,1)*Import
			SdoUsa   = SdoUsa   + IIF(TpoMov#"D",-1,1)*ImpUsa
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
NEXT
SELECT RMOV
SET ORDER TO RMOV01
SELECT VMOV
IF ! Ok
	GsMsgErr = "*!* Provisi¢n mal Registrada *!*"
	DO LIB_MERR WITH 99,lNoMostraMensaje
	RETURN .F.
ENDIF
IF GlInterface_CCB
ELSE
	IF EMPTY(XsCodAux) .OR. MaxEle = 1
		XsCodAux = LsCodAux
		=SEEK(LsClfAux+LsCodAux,"AUXI")
	*!*		@ 21,14 SAY LsCodAux
	*!*		@ 21,22 SAY AUXI->NomAux PICT "@S50"
	ENDIF

	IF EMPTY(XsNotAst) .OR. MaxEle = 1
		XsNotAst = LsNotAst
		@ LinImpChq + 2,14 SAY XsNotAst  COLOR SCHEME 11
	ENDIF
ENDIF	
SET ORDER TO VMOV01
RETURN .T.

****************************
* Objeto : Borra una linea *
****************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
	vTpoAst(i) = vTpoAst(i+1)
	vNroAst(i) = vNroAst(i+1)
	vImport(i) = vImport(i+1)
	vNotAst(i) = vNotAst(i+1)
	vCodBco(i) = vCodBco(i+1)
	vNroCta(i) = vNroCta(i+1)
	vNroChq(i) = vNroChq(i+1)
	*!* VETT 21-10-2019 
	xCodCta(i) = xCodCta(i+1)
	xCodMon(i) = xCodMon(i+1)
	xNroRef(i) = xNroRef(i+1)
	xCodAux(i) = xCodAux(i+1)
	xcoddiv(i) = xcoddiv(i+1)         

	i = i + 1
ENDDO
vTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
vNroAst(i) = SPACE(LEN(RMOV->NroDoc))
vImport(i) = 0
vNotAst(i) = SPACE(LEN(VMOV->NotAst))
vCodBco(i) = SPACE(LEN(RMOV->CodBco))
vNroCta(i) = SPACE(LEN(RMOV->NroCta))
vNroChq(i) = SPACE(LEN(RMOV->NroChq))
XfImpCh1 = 0
FOR ii = 1 to MaxEle
	XfImpCh1 = XfImpCh1 + vImport(ii)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
Estado = .T.

RETURN
******************************
* Objeto : Inserta una linea *
******************************
PROCEDURE GENbinse
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
	vTpoAst(i) = vTpoAst(i-1)
	vNroAst(i) = vNroAst(i-1)
	vImport(i) = vImport(i-1)
	vNotAst(i) = vNotAst(i-1)
	vCodBco(i) = vCodBco(i-1)
	vNroCta(i) = vNroCta(i-1)
	vNroChq(i) = vNroChq(i-1)
	i = i - 1
ENDDO
i = ElePrv + 1
vTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
vNroAst(i) = SPACE(LEN(RMOV->NroDoc))
vNotAst(i) = SPACE(LEN(VMOV->NotAst))
vImport(i) = 0
vCodBco(i) = SPACE(LEN(RMOV->CodBco))
vNroCta(i) = SPACE(LEN(RMOV->NroCta))
vNroChq(i) = SPACE(LEN(RMOV->NroChq))
Estado = .T.
RETURN

*****************
PROCEDURE VOUCHER
*****************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENblin2"
EdiLin   = "GENbedi2"
BrrLin   = "GENbbor2"
InsLin   = "GENbins2"
Yo       = YoBrow2 && 12
Largo    = RowsBrow2 && 6
Ancho    = AnchoBrow2
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle2
TotEle   = 40     && M ximos elementos a usar
DO ABROWSE
MaxEle2 = MaxEle
@ YoBrow2 + RowsBrow2 - 1,1   TO YoBrow2 + RowsBrow2 - 1,AnchoBrow2 - 2  && COLOR SCHEME 11
IF MaxEle2 = 1 .AND. EMPTY(vCodCta(1))
	MaxEle2 = 0
	@ YoBrow2 + 1 ,01 CLEAR TO YoBrow2 + RowsBrow2 - 2,AnchoBrow2 - 2
ENDIF
@ YoBrow2 + 1,01 Fill TO YoBrow2 + RowsBrow2 - 2,AnchoBrow2 - 2  COLOR SCHEME 16
RETURN
*****************************************
* Objeto : Escribe una linea del browse *
*****************************************
PROCEDURE GENblin2
PARAMETERS NumEle, NumLin
=SEEK(vCodCta(NumEle),"CTAS")
@ numlin,1 say vcoddiv(numele)  && COLOR SCHEME 11
@ NumLin,4 SAY vCodCta(NumEle)  && COLOR SCHEME 11 
@ NumLin,13 SAY CTAS->NomCta PICT "@S21"   && COLOR SCHEME 11
@ NumLin,37 SAY vCodAux(NumEle)   && COLOR SCHEME 11
@ NumLin,44 SAY vCodDoc(NumEle)   &&  COLOR SCHEME 11
@ NumLin,49 SAY vNroRef(NumEle)   &&   COLOR SCHEME 11
IF EMPTY(vCodCta(NumEle)) .AND. vImpCta(NumEle)=0
	@ NumLin,60 SAY "   "   && COLOR SCHEME 11
	@ NumLin,63 SAY vImpCta(NumEle) PICT "@Z 999,999,999.99"  && COLOR SCHEME 11
	@ NumLin,77 SAY " "  && COLOR SCHEME 11
ELSE
	@ NumLin,60 SAY IIF(XnCodMon=1,"S/.","US$")  && COLOR SCHEME 11
	@ NumLin,63 SAY vImpCta(NumEle) PICT "999,999,999.99"  && COLOR SCHEME 11
	@ NumLin,77 SAY IIF(vTpoMov(NumEle) = "H"," ","-")   && COLOR SCHEME 11
ENDIF
RETURN

****************************
* Objeto : Edita una linea *
****************************
PROCEDURE GENbedi2
PARAMETERS NumEle, NumLin, LiUtecla
lscoddiv = vcoddiv(numele)
LsCodCta = vCodCta(NumEle)
LsCodAux = vCodAux(NumEle)
LcTpoMov = vTpoMov(NumEle)
LsNroRef = vNroRef(NumEle)
LsCodDoc = vCodDoc(NumEle)
LfImpCta = vImpCta(NumEle)
UltTecla = 0
i = 1
LinAct = NumLin
LinDiv = 1
LinCta = 4
LinNom = 13
LinAux = 37
LinTdo = 44
LinRef = 49
LinImp = 63
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
				LOOP
			ENDIF
			@ LinAct,LinDiv SAY lsCodDiv PICT "XX"   COLOR SCHEME 11
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
			IF MaxEle = 1 .AND. EMPTY(LsCodCta)
				UltTecla = CtrlW
				EXIT
			ENDIF
			IF MaxEle > 1 .AND. EMPTY(LsCodCta)
				UltTecla = Escape_
				KEYB CHR(23)
				EXIT
			ENDIF
			SEEK LsCodCta
			IF ! FOUND()
				GsMsgErr = "Cuenta no Registrada"
				DO Lib_MErr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ LinAct,LinCta SAY LsCodCta  COLOR SCHEME 11
			IF CTAS->AFTMOV#"S"
				GsMsgErr = "Cuenta no Afecta a movimiento"
				DO Lib_MErr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ LinAct,LinNom SAY CTAS->NomCta PICT "@S34"  COLOR SCHEME 11
			IF EMPTY(LcTpoMov)
				LcTpoMov = "H"
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
				ELSE
					LsCodAux = RIGHT("00000000"+ALLTRIM(LsCodAux),iDigitos)
				ENDIF
				LsCodAux = PADR(LsCodAux,LEN(RMOV->CodAUX))
				@ LinAct,LinAux SAY LsCodAux  COLOR SCHEME 11
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
					GsMsgErr = "C¢digo de documento inv lido"
					DO LIB_MERR WITH 99
					UltTecla = 0
					LOOP
				ENDIF
			ELSE
				LsCodDoc = SPACE(LEN(RMOV->CodDoc))
			ENDIF
			@ LinAct,LinTdo SAY LsCodDoc PICT "@!"  COLOR SCHEME 11
		CASE i = 5
			IF CTAS->PidDoc="S"
				@ LinAct,LinRef GET LsNroRef PICT "@!"
				READ
				UltTecla = LASTKEY()
			ELSE
				LsNroRef = SPACE(LEN(RMOV->NroDoc))
			ENDIF
			@ LinAct,LinRef SAY LsNroRef PICT "@!"  COLOR SCHEME 11
		CASE i = 6
			IF LfImpCta<=0
				LfImpCta = ROUND(XfImpCh1,2)
			ENDIF
			@ NumLin,60 SAY IIF(XnCodMon=1,"S/.","US$")  COLOR SCHEME 11
			@ LinAct,LinImp GET LfImpCta PICT "99999999999.99" VALID LfImpCta > 0
			READ
			UltTecla = LASTKEY()
			@ LinAct,LinImp SAY LfImpCta PICT "999,999,999.99"   COLOR SCHEME 11
		CASE i = 7
			ZcTpoMov = IIF(LcTpoMov = "H"," ","-")
			@ LinAct,77     GET ZcTpoMov PICT "!" VALID ZcTpoMov$" -"
			READ
			UltTecla = LASTKEY()
			LcTpoMov = IIF(ZcTpoMov = "-","D","H")
			@ LinAct,77     SAY IIF(LcTpoMov = "H"," ","-")   COLOR SCHEME 11
		CASE i = 8
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
	i = IIF(i>8, 8, i)
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
ENDIF
XfImpCh2 = 0
FOR ii = 1 to MaxEle
	XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="H",1,-1)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
LiUtecla = UltTecla
RETURN

****************************
* Objeto : Borra una linea *
****************************
PROCEDURE GENbbor2
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
	vcoddiv(i) = vcoddiv(i+1)
	vCodCta(i) = vCodCta(i+1)
	vCodAux(i) = vCodAux(i+1)
	vNroRef(i) = vNroRef(i+1)
	vCOdDoc(i) = vCodDoc(i+1)
	vTpoMov(i) = vTpoMov(i+1)
	vImpCta(i) = vImpCta(i+1)
	i = i + 1
ENDDO
vcoddiv(i) = space(len(rmov.coddiv))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vTpoMov(i) = "H"
vImpCta(i) = 0
XfImpCh2 = 0
FOR ii = 1 to MaxEle
	XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="H",1,-1)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ LinImpChq ,18 SAY XfImpChq PICT "99,999,999,999.99"  COLOR SCHEME 11
Estado = .T.
RETURN
******************************
* Objeto : Inserta una linea *
******************************
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
	i = i - 1
ENDDO
i = ElePrv + 1
vcoddiv(i) = IIF(gocfgcbd.TIPO_CONSO = 2,XsCjaDiv,SPACE(LEN(RMOV.CodDiv)))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroRef))
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vTpoMov(i) = "H"
vImpCta(i) = 0
Estado = .T.
RETURN
*********************************************************
* Procedimiento de Borrado ( Auditado ) de un documento *
*********************************************************
PROCEDURE MOVBorra
PARAMETERS __NroMes,__CodOpe,__NroAst
IF PARAMETERS()=0  && Cuando estamos dentro del Cja_Cjac1Mov
	__NroMes = XsNroMes
	__CodOpe = XsCodOpe
	__NroAst = XsNroAst
ENDIF
IF VARTYPE(__NroMes)='C' AND VARTYPE(XsNroMes)<>'C'
	XsNroMes = __NroMes
ENDIF
IF VARTYPE(__CodOpe)='C' AND VARTYPE(XsCodOpe)<>'C'
	XsCodOpe = __CodOpe
ENDIF
IF VARTYPE(__NroAst)='C' AND VARTYPE(XsNroAst)<>'C'
	XsNroAst = __NroAst
ENDIF

#include const.h 	

lNoMostraMensaje = GlInterface_CCB
IF !USED('VMOV')
	lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
	IF !Lok
*!*			=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		GsMsgErr = 'No hay acceso a registro de Asientos'
		DO LIB_MERR WITH 99  && ,lNoMostraMensaje
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('RMOV')
	lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
	IF !Lok
*!*			=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		GsMsgErr = 'No hay acceso a registro a detalle de asientos'
		DO LIB_MERR WITH 99  && ,lNoMostraMensaje
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('ACCT')
	lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
	IF !Lok
*!*			=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		GsMsgErr = 'No hay acceso a acumulado de cuentas'
		DO LIB_MERR WITH 99  && ,lNoMostraMensaje
		RETURN lOk
	ENDIF
ENDIF	


SELECT VMOV
LsLlave = (__NroMes + __CodOpe + __NroAst )
SEEK LsLlave
IF !FOUND()
	GsMsgErr = "Asiento NO existe"
	DO LIB_MERR WITH 99  
	UltTecla = Escape_
	RETURN .f. && No pudo bloquear registro
ENDIF
IF .NOT. RLock()
	GsMsgErr = "Asiento usado por otro usuario"
	DO LIB_MERR WITH 99  
	UltTecla = Escape_
	RETURN  .f. && No pudo bloquear registro
ENDIF
IF GlInterface_CCB
ELSE
	DO LIB_MSGS WITH 10
ENDIF

SELECT RMOV
LsLlave = (__NroMes + __CodOpe + __NroAst )
SEEK LsLlave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
	LsLlave = (NroMes + CodOpe + NroAst )
	IF Rlock()
		=SEEK(CodDoc,'PROV','PROV01')
		IF PROV.Tipo='C'
			DO DESCOB
		ENDIF
		SELECT RMOV
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov ,-Import , -ImpUsa, coddiv
		DELETE
		UNLOCK
	ELSE
		ok = .f.
	ENDIF
	SKIP
ENDDO
SELECT VMOV
REPLACE NOTAST WITH "*** VOUCHER ANULADO ***"
REPLACE GloAst WITH PADC(ALLTRIM(NotAst),52)
REPLACE IMPCHQ WITH 0
REPLACE DBENAC WITH 0
REPLACE HBENAC WITH 0
REPLACE DBEUSA WITH 0
REPLACE HBEUSA WITH 0
IF Ok
	REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
	DELETE
	REPLACE FlgEst WITH " "    && Marca de anulado
ELSE
	IF GlInterface_CCB
	ELSE
		DO MOVPINTA
		DO F0PRINT &&IN ADMPRINT
		IF UltTecla # Escape_
			DO MovPrint
		ENDIF
		SET DEVICE TO SCREEN
	ENDIF	
ENDIF
UNLOCK ALL
RETURN Ok
*****************************************************
* Procedimiento de Grabar las variables de cabezera *
*****************************************************
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
		@ 1,68 SAY XsNroAst  COLOR SCHEME 11
	ENDIF
	APPEND BLANK
	IF ! Rec_Lock(5)
		UltTecla = Escape_
		RETURN              && No pudo bloquear registro
	ENDIF
	REPLACE VMOV->NROMES WITH XsNroMes
	REPLACE VMOV->CodOpe WITH XsCodOpe
	REPLACE VMOV->NroAst WITH XsNroAst
	REPLACE vmov.fchdig  with date()
	REPLACE vmov.hordig  with time()
	SELECT OPER
	LoContab.NROAST(XsNroAst)
ELSE
	SEEK LLAVE
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsCodDo1  && VETT 2009-05-22     && TRANSF(XiNroVou,"@L ######")
REPLACE VMOV->CodMon  WITH XnCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->GloAst  WITH XsGloAst
REPLACE VMOV->CtaCja  WITH XsCtaCja
REPLACE VMOV->NroChq  WITH XsNroChq  && VETT 2009-05-22
REPLACE VMOV->Girado  WITH ""
REPLACE VMOV->ImpChq  WITH XfImpChq
REPLACE VMOV->Digita  WITH GsUsuario
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0
REPLACE VMOV->Auxil   WITH XsAuxil
REPLACE VMOV.FchPed   WITH XdFchPed
IF VARTYPE(VMOV.ParFin)='C'
	REPLACE VMOV.ParFin   WITH XsParFin 
ENDIF

XsNroCh1 = VMOV.NroChq
SELECT RMOV
SEEK LLAVE
IF !crear
*!*		SET STEP ON 
ENDIF
**** Anulando movimientos anteriores ****
DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
	IF Rec_LOCK(5)
		=SEEK(CodDoc,'PROV','PROV01')
		IF codaux='20456123504'
*!*				SET STEP ON 
		ENDIF
		IF PROV.Tipo='C'
			DO DESCOB
		ENDIF
		SELE RMOV
 
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
	XcTpoMov = "H"
	IF XnCodMon = 1
		XfImport = vImport(NumEle)
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = vImport(NumEle)
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	xscoddiv = IIF(EMPTY(xcoddiv(numele)),'',xcoddiv(numele))
	XsCodCta = xCodCta(NumEle)

	=SEEK(XsCodCta,"CTAS",'CTAS01')
	XsNroRef = xNroRef(NumEle)
	XsClfAux = CTAS->CLFAUX
	XsCodAux = xCodAux(NumEle)
	XsCodRef = ""
	XsGloDoc = vNotAst(NumEle)
	*** VETT 27/03/2006 ***		INI 
	=SEEK(vTpoAst(NumEle),'PROV','PROV01')  && Asegurarse de que esta con el indice correcto VETT 2009-05-28
	LsCodDocPrv = ''
	LlExisteCodDocPrv = .f.
	IF VARTYPE(Prov.CodDoc)='C'
		LsCodDocPrv = PROV.CodDoc
		LlExisteCodDocPrv=IIF(EMPTY(PROV.CodDoc),.f.,.t.)
	ENDIF
	LlExisteCodDocPrv = ( LlExisteCodDocPrv AND !EMPTY(LsCodDocPrv) )
	*** VETT 27/03/2006 ***		FIN
	XsTipDoc = IIF(LlExisteCodDocPrv,LsCodDocPrv,vTpoAst(NumEle))
	XsCodDoc = vTpoAst(NumEle)
	XsNroDoc = vNroAst(NumEle)
	XiCodMon = xCodMon(NumEle)
	XsCodCCo = IIF(INLIST(GoCfgCbd.C_Costo,1,2,3),XsAuxil,'')
	XsCtaPre = IIF(GoCfgCbd.PidPre,XsParFin,'')
*!*		XcEliItm = CHR(255)
	XcEliItm = CHR(43)  
	XsCodBco = vCodBco(NumEle)
	XsNroCta = vNroCta(NumEle)
	XsNroChq = vNroChq(NumEle)
	IF XiCodMon = 1
		IF XfImport < 0
			XcTpoMov = IIF(XcTpoMov # "D","D","H")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ELSE
		IF XfImpUsa < 0
			XcTpoMov = IIF(XcTpoMov # "D","D","H")
			XfImport = -XfImport
			XfImpUsa = -XfImpUsa
		ENDIF
	ENDIF
	*!* ACTUALIZA C/C *!*
	IF PROV.Tipo='C'
		DO GRACOB
	ENDIF
	IF CTAS->AftDcb = "S"
		DO DIFCMB
	ELSE
		DO GRBRMOV
	ENDIF
ENDFOR
*!* ACTUALIZANDO 2da VENTANA *!*
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
	IF CTAS.PidDoc='S'
		XsCodDoc = vCodDoc(NumEle)
		XsNroDoc = vNroRef(NumEle)
		XsTipDoc =  vCodDoc(NumEle)
	ELSE
		XsCodDoc = ''
		XsNroDoc = ''
		XsTipDoc =  ''
	ENDIF
	XcEliItm = " "
	XsCodBco = []
	XsNroChq = []
	XsNroCta = []
	XsCodCco = IIF(INLIST(GoCfgCbd.C_Costo,1,2,3),XsAuxil,'')
	XsCtaPre = IIF(GoCfgCbd.PidPre,XsParFin,'')
	IF XnCodMon = 1
		IF XfImport < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
		ENDIF
	ELSE
		IF XfImpUsa < 0
			XcTpoMov = IIF(XcTpoMov = "D","H","D")
		ENDIF
	ENDIF
	XfImport = ABS(XfImport)
	XfImpUsa = ABS(XfImpUsa)
	DO GRBRMOV
ENDFOR
*!* Actualizando Cta de Caja *!*
IF XnCodMon = 1
	YfImport = XfImpChq
	YfImpUsa = ROUND(YfImport/XfTpoCmb,2)
ELSE
	YfImpUsa = XfImpChq
	YfImport = ROUND(YfImpUsa*XfTpoCmb,2)
ENDIF
*!* Graba la cuenta de  Caja *!*
XsCodCta = XsCtaCja
XsCodDiv = xscjadiv
=SEEK(XsCodCta,"CTAS")
XsCodRef = ""
XsNroRef = ""
XsClfAux = ''
XsCodAux = ''
XsCodCCo = IIF(INLIST(GoCfgCbd.C_Costo,1,2,3),XsAuxil,'')
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
XsTipDoc =  ''
XsGloDoc = XsNotAst
XsCodDoc = XsCodDo1
XsNroDoc = XsNroCh1
XcEliItm = "."
XsCodBco = []
XsNroCta = []
XsNroChq = []
LfImpUsa = YfImpUsa
LfImport = YfImport
XcTpoMov = "D"
IF XnCodMon = 1
	IF LfImport < 0
		XcTpoMov = "H"
	ENDIF
ELSE
	IF LfImpUsa < 0
		XcTpoMov = "H"
	ENDIF
ENDIF
XfImport = ABS(LfImport)
XfImpUsa = ABS(LfImpUsa)
XsCtaPre = IIF(GoCfgCbd.PidPre,XsParFin,'')
DO GrbRMOV
SELECT VMOV
REPLACE VMOV->NROITM  WITH XiNroitm
@ 24,0
SELECT VMOV
UNLOCK ALL
RETURN
*****************
PROCEDURE Grbrmov
*****************
*!* Grabando la linea activa *!*
LnAreaAct=SELECT()
DO Graba
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
	RETURN
ENDIF
*!* Actualizando Cuentas Autom ticas *!*
*!*	XcEliItm = "ú"
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
	*!* Verificamos su existencia *!*
	IF ! SEEK("05 "+TsAn1Cta,"AUXI")
		GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
		DO LIB_MERR WITH 99
		RETURN
	ENDIF
ELSE
	IF ! SEEK(TsAn1Cta,"CTAS")
		GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
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
	GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
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
SELECT (LnAreaAct)
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
REPLACE rmov->coddiv with IIF(EMPTY(xscoddiv),TsCodDiv1,XsCodDiv)
REPLACE RMOV->NroMes WITH XsNroMes
REPLACE RMOV->CodOpe WITH XsCodOpe
REPLACE RMOV->NroAst WITH XsNroAst
REPLACE RMOV->NroItm WITH XiNroItm
REPLACE RMOV->CodMon WITH XnCodMon
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
REPLACE RMOV.CodCco  WITH XsCodCco  
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV.TipDoc	WITH iif(VARTYPE(XsTipDoc)='U','',XsTipDoc)
*!*	REPLACE RMOV->FchVto WITH {,,}  
REPLACE RMOV->FchVto WITH {  ,  ,    }   
*!*	IF RMOV.CodCta=[10]
REPLACE FchPed WITH XdFchPed
*!*	ENDIF
REPLACE RMOV->CodBco WITH XsCodBco
REPLACE RMOV->NroCta WITH XsNroCta
REPLACE RMOV->NroChq WITH XsNroChq
REPLACE rmov.fchdig  with date()
REPLACE rmov.hordig  with time()
Replace RMOV.CtaPre WITH XsCtaPre  && VETT 2009-11-24
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa, coddiv
IF RMOV->TpoMov = 'D'
	REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
	REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
ELSE
	REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
	REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
ENDIF
RETURN
**************************************
* Objeto : Procedure Imprime Voucher *
**************************************
PROCEDURE MOVPRIN2
******************
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)
DIMENSION vLinHbe(10),vLinDbe(10)
STORE "" TO vLinHbe,vLinDbe
STORE 0 TO THbe,TDbe
SELECT RMOV
SEEK LsLLave
SCAN WHILE 	NroMes+CodOpe+NroAst=LsLLave FOR EliItm#"*" && Sin Automaticas
	IF TpoMov="H"
		IF THbe<10  && Solo hay espacio para diez lineas
			tHbe= THbe + 1
			vLinHbe(THbe)= CodCta+" "+TRAN(IIF(VMOV.CodMon=1,Import,ImpUSa),"99,999,999.99")
		ENDIF
	ELSE
		IF TDbe<10  && Solo hay espacio para diez lineas
			tDbe= TDbe + 1
			vLinDbe(TDbe)= CodCta+" "+TRAN(IIF(VMOV.CodMon=1,Import,ImpUSa),"99,999,999.99")
		ENDIF
	ENDIF
ENDSCAN
SEEK LsLLave
*!*	SNOMREP = "CJAVOING_"+UPPER(GsSigCia)
*!*	SNOMREP2 = "CJAVOING-TM_"+UPPER(GsSigCia)
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
XFOR   = [eliitm#"*"]
XWHILE = [NROMES+CODOPE+NROAST=LsLlAVE]
*!*	DO F0PRINT WITH "REPORTS"
lcRptTxt	= "CJAVOING"+"_"+GsSigCia
lcRptGraph	= "CJAVOING-TM"+"_"+GsSigCia
lcRptDesc	= "INGRESO DE CAJA CON FORMATO"
CurSession  = SET("Datasession")

DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , CurSession && THISFORM.DATASESSIONID

RETURN
******************
PROCEDURE MovPrint
******************
PARAMETERS __Nromes,__CodOpe,__NroAst
_Fontsize = 9
IF !USED('VMOV')
	=MESSAGEBOX('No estan abiertas las tablas VMOV y RMOV',16,'ATENCION !!!')
	RETURN 
ENDIF

IF PARAMETERS() = 0  && Ya Debe estar abierta las Tablas VMOV y RMOV
	__NroMes	=	VMOV.NroMes
	__CodOpe	=	VMOV.CodOpe
	__NroAst	=	VMOV.NroAst
	SELECT VMOV
	LsLLave  = (__NroMes+__CodOpe+__NroAst)
ELSE
	SELECT VMOV
	LsLLave  = (__NroMes+__CodOpe+__NroAst)
	SEEK LsLLave

ENDIF
NumPag   = 1
SELECT RMOV
SEEK LsLLave
RegIni = RECNO()
SET DEVICE TO PRINT
PRINTJOB
*!*		GOTO RegIni
	*** VETT 2008-05-30 ----- INI
	LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
	XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
	Largo    = XnLargo
	LinFin   = Largo - 6
	*** VETT 2008-05-30 ----- FIN

	NumLin  = 0
*!*		Largo  = 66
*!*		LinFin = Largo - 6
	NumPag = 0
	TfDebe = 0
	TfHber = 0
	DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
*!*			IF Import = 0 .OR. EliItm = "ú"
*!*			IF Import = 0 .OR. EliItm = "*"   
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
		LsGloDoc=TRIM(LsGloDoc)
		LenGloDoc=LEN(LsGloDoc)
		LenGloDoc=43
		IF VMOV->CodMon <> 1
			LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"###,###.##"))+")"
			IF RIGHT(LsImport,4)=".00)"
				LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###"))+")"
			ENDIF
			LsGloDoc = LEFT(PADR(LsGloDoc,LenGloDoc),LenGloDoc-LEN(LsImport))+LsImport
		ENDIF
		@ LinAct,6 SAY "|"  
		*@ LinAct,0  SAY _PRN4
		IF _Fontsize>8
			@ LinAct,07 SAY LsGloDoc    PICT "@S30" font _Fontname,8
		ELSE
			@ LinAct,07 SAY LsGloDoc    PICT "@S30" font _Fontname,_Fontsize -1
		ENDIF
		*@ LinAct,0  SAY "" && _PRN2
		@ LinAct,42  SAY TRIM(CodCta)   && font 'Courier New',6
		@ LinAct,52 SAY NroDoc   PICT "@S11" && font 'Courier New',6
		@ LinAct,64 SAY NroRef   PICT "@S11" && font 'Courier New',6
		IF TpoMov = "D"
			@ LinAct,75 SAY Import PICT "9,999,999.99"
			TfDebe = TfDebe + Import
		ELSE
			@ LinAct,88 SAY Import PICT "9,999,999.99"
			TfHber = TfHber + Import
		ENDIF
		@ LinAct,100 SAY "|"
		SKIP
	ENDDO
	IF NumPag = 0
		DO INIPAG
	ENDIF
	IF PROW() > Largo - 13
		DO INIPAG WITH .T.
	ENDIF
	LinAct = PROW() + 1
	@ LinAct,6  SAY "----------------------------------------------------------------------------------------------+"
	LinAct = PROW() + 1
	@ LinAct,50 SAY "TOTAL S/."
	@ LinAct,64 SAY "|"
	@ LinAct,75 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,87 SAY "|"
	@ LinAct,88 SAY TfHber PICT "9,999,999.99"
	@ LinAct,100 SAY "|"
	LinAct = PROW() + 1
	@ LinAct,64 SAY "------------------------------------+"
	LinAct = Largo - 10
	@ LinAct+1,6  SAY "+--------------------------------------------------------------------------------------------+"
	@ LinAct+2,6  SAY "|      PREPARADO      |      REVISADO       |    AUTORIZACION     |       VoBo               |"
	@ LinAct+3,6  SAY "---------------------------------------------------------------------------------------------|"
	@ LinAct+4,6  SAY "|                     |                     |                     |                          |"
	@ LinAct+5,6  SAY "|                     |                     |                     |                          |"
	@ LinAct+6,6  SAY "+--------------------------------------------------------------------------------------------+"
	EJECT PAGE
ENDPRINTJOB
DO f0PRFIN
SELECT RMOV
RETURN
*****************
PROCEDURE MovMemb
*****************
*!*	IF NumPag = 0
*!*		@ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
*!*	ENDIF
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
@ 3,Ancho/2-14  SAY _Prn7a+"VOUCHER GENERAL"+_Prn7b  font 'Courier New',10 STYLE 'B'
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
	@ LinAct,70 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,85 SAY TfHber PICT "9,999,999.99"
	LinAct = PROW() + 1
	@ LinAct,6  SAY "+---------------------------------------------------------------------------------------------+"
ENDIF
NumPag = NumPag + 1
XsHoy='Lima, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")
SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)
Dato4 = mline(VMOV->GLOAST,4)
@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN2
@  0,6  SAY _PRN7A+TRIM(GsNomCia)
@  0,0  SAY _PRN7B
@  0,68 SAY _PRN7A+"No:"+VMOV->CODOPE+[-]+VMOV->NroAst+_Prn7b  font 'Courier New',10 STYLE 'B'
@  2,0  SAY _PRN7A+PADC("VOUCHER DE CAJA INGRESOS",47)+_PRN7B
@  3,6  SAY "+---------------------------------------------------------------------------------------------+"
@  4,6  SAY "|"
@  4,8  SAY XsHoy
@  4,76 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@  4,79 SAY VMOV->ImpChq PICT "***,***,***.**"
@  4,100 SAY "|"
@  5,06 SAY "|"
@  5,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@  5,100 SAY "|"
@  6,6  SAY "+---------------------------------------------------------------------------------------------+"
@  7,6  SAY "|"+PADC(Dato1,93)+"|"
@  8,6  SAY "|"+PADC(Dato2,93)+"|"
@  9,6  SAY "|"+PADC(Dato3,93)+"|"
@ 10,6  SAY "| "+PADR("CUENTA No: "+CTAS->NROCTA,92)+"|"
@ 11,6  SAY "| "+PADR("BANCO    : "+TABL->Nombre,92)+"|"
@ 12,6  SAY "+---------------------------------------------------------------------------------------------+"
@ 13,6  SAY "|      C O N C E P T O              |CUENTA |DOCUMENTO  |REFERENC.|     DEBE     |    HABER   |"
@ 14,6  SAY "+---------------------------------------------------------------------------------------------+"

IF NumPag > 1
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VIENEN..."
	@ LinAct,70 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,85 SAY TfHber PICT "9,999,999.99"
ENDIF
RETURN
************************************************
* Objeto : GENERA ITEM DE DIFERENCIA DE CAMBIO *
************************************************
PROCEDURE DIFCMB  && Revisar proceso cuando es por exceso
****************
LfImport = 0
LfImpUsa = 0
SELECT RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK Llave
DO WHILE ! EOF() .AND. CodCta+CodAux+NroDoc = Llave
	LfImport = LfImport + IIF(TpoMov#"D",-1,1)*Import
	LfImpUsa = LfImpUsa + IIF(TpoMov#"D",-1,1)*ImpUsa
	SKIP
ENDDO
SET ORDER TO RMOV01
*!* Verificando la cancelaci¢n del documento *!*
oK = .T.
IF xCodMon(NumEle) = 1
	IF ABS(LfImport-IIF(XcTpoMov#"D",1,-1)*XfImport) > XfDif_MN   && Ajuste y Matar puchos
		oK = .F.
	ENDIF
ELSE
	IF ABS(LfImpUsa-IIF(XcTpoMov#"D",1,-1)*XfImpUsa) > XfDif_ME   && Ajuste y Matar puchos
		oK = .F.
	ENDIF
ENDIF
*** Grabando el Documento ***
IF oK
	XfImpUsa = LfImpUsa
	XfImport = LfImport
	IF XcTpoMov = "D"
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

*!* Calculando REDONDEO y DIFERENCIA DE CAMBIO *!*

IF XnCodMOn = 1
	IF TpoMov # "D"
		LfImport = Import - vImport(NumEle)
		LfImpUsa = ImpUsa - ROUND(vImport(NumEle)/XfTpoCmb,2)
	ELSE
		LfImport = - Import - vImport(NumEle)
		LfImpUsa = - ImpUsa - ROUND(vImport(NumEle)/XfTpoCmb,2)
	ENDIF
ELSE
	IF TpoMov # "D"
		LfImport = Import - ROUND(vImport(NumEle)*XfTpoCmb,2)
		LfImpUsa = ImpUsa - vImport(NumEle)
	ELSE
		LfImport = -Import - ROUND(vImport(NumEle)*XfTpoCmb,2)
		LfImpUsa = -ImpUsa - vImport(NumEle)
	ENDIF
ENDIF
*!* Grabando el redondeo y el ajuste *!*
*!*	XcEliItm = "ð"
XcEliItm = "-"
XfImpUsa = LfImpUsa
XfImport = LfImport
IF LfImpUsa <>0  AND LfImport <> 0
*	SET STEP ON 
ENDIF
IF LfImport # 0						&& XfImport # 0   VETT 26/06/2009
	XfImpUsa = 0			&&   VETT 28/03/2006
	XfImport =	LfImport	&&    VETT 28/03/2006
	IF LfImport > 0					&& XfImport # 0   VETT 26/06/2009
		XsCodCta = XsCdCta1
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = ""
		XcTpoMov = [D]
	ELSE
		XfImpUsa = 0 	&&  -LfImpUsa  VETT 28/03/2006
		XfImport = -LfImport
		XsCodCta = XsCdCta2
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XcTpoMov = [H]
		XsCodAux = XsCdAux2
	ENDIF
	DO GRBRMOV
	IF TpoMov = "H"
		YfImport = YfImport + Import
		YfImpUsa = YfImpUsa + ImpUsa
	ELSE
		YfImport = YfImport - Import
		YfImpUsa = YfImpUsa - ImpUsa
	ENDIF
	IF pCodMon(NumEle)=1 AND LfImport<>0 && Actualizamos saldo en Ctas x Cobrar
		DO GRACOB_DFCMB	WITH LfImport,pCodMon(NumEle)	
	ENDIF
ENDIF
IF LfImpUsa # 0			            && XfImpUsa # 0   VETT 26/06/2009
	IF LfImpUsa > 0		            && XfImpUsa # 0   VETT 26/06/2009
		XfImpUsa = LfImpUsa	&&   VETT 28/03/2006
		XfImport =	0			&&    VETT 28/03/2006
		XsCodCta = XsCdCta1
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XsCodAux = ""
		XcTpoMov = [D]
	ELSE
		XfImpUsa = -LfImpUsa
		XfImport =    0                 &&   -LfImport	VETT 28/03/2006
		XsCodCta = XsCdCta2
		=SEEK(XsCodCta,"CTAS")
		XsClfAux = CTAS->ClfAux
		XcTpoMov = [H]
		XsCodAux = XsCdAux2
	ENDIF
	DO GRBRMOV
	IF TpoMov = "H"
		YfImport = YfImport + Import
		YfImpUsa = YfImpUsa + ImpUsa
	ELSE
		YfImport = YfImport - Import
		YfImpUsa = YfImpUsa - ImpUsa
	ENDIF
	IF pCodMon(NumEle)=2 AND LfImpUsa<>0 && Actualizamos saldo en Ctas x Cobrar
		DO GRACOB_DFCMB	WITH LfImpUsa,pCodMon(NumEle)	
	ENDIF
ENDIF
RETURN

*!* ACTUALIZANDO A CUENTAS POR COBRAR *!*
**************************************************
* Objeto : Verificar la Existencia del documento *
**************************************************
PROCEDURE CTACOB
****************
lNoMostraMensaje = GlInterface_CCB

DO CASE 
	CASE LsTpoAst<>'PROF'  && Todos los documentos que no son PROFORMAS : VETT 2007-10-04
		IF !USED('GDOC')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
			IF !Lok
		*!*			=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
				GsMsgErr = 'No hay acceso a registro de documentos por cobrar'
				DO LIB_MERR WITH 99,lNoMostraMensaje
				RETURN lOk
			ENDIF
		ENDIF	
		IF !USED('TDOC')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
			IF !Lok
		*!*			=MESSAGEBOX('No hay acceso maestro  documentos de cobranza',0+48,'Atención!!')
				GsMsgErr = 'No hay acceso maestro  documentos de cobranza'
				DO LIB_MERR WITH 99,lNoMostraMensaje
				RETURN lOk
			ENDIF
		ENDIF	
		LsAliasDocs = 'GDOC'
		LsLlave = 'CARGO'+LsTpoAst
		LsWhile = [TpoDoc='CARGO' AND CodDoc=LsTpoAst]
		LsOrder = 'GDOC01'
	OTHERWISE
		IF !USED('VPRO')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
			IF !Lok
		*!*			=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
				GsMsgErr = 'No hay acceso a registro de documentos por cobrar'
				DO LIB_MERR WITH 99,lNoMostraMensaje
				RETURN lOk
			ENDIF
		ENDIF	
		IF !USED('TDOC')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
			IF !Lok
		*!*			=MESSAGEBOX('No hay acceso maestro  documentos de cobranza',0+48,'Atención!!')
				GsMsgErr = 'No hay acceso maestro  documentos de cobranza'
				DO LIB_MERR WITH 99,lNoMostraMensaje
				RETURN lOk
			ENDIF
		ENDIF	
		LsAliasDocs = 'VPRO'
		LsLlave = ''
		LsWhile = '.T.'
		LsOrder = 'VPRO01'
ENDCASE 
SELECT (LsAliasDocs)
SET ORDER TO (LsOrder)
*!* Buscando Como Documento de CARGO *!*
LsNroDoc = PADR(LsNroAst,LEN(NRODOC))
SEEK LsLlave+LsNroDoc
IF ! FOUND() AND LsTpoAst<>'PROF'
	*!* Buscando Como Documento de ABONO *!*
	SEEK "ABONO"+LsTpoAst+LsNroDoc
	IF ! FOUND()
		GsMsgErr = "Documento no registrado"
		DO LIB_MERR WITH 99,lNoMostraMensaje
		RETURN .F.
	ENDIF
ENDIF
IF FLGEST = "A"
	GsMsgErr = "Documento Anulado"
	DO LIB_MERR WITH 99,lNoMostraMensaje
	RETURN .F.
ENDIF
IF SdoDoc = 0
	GsMsgErr = "Documento Cancelado"
	DO LIB_MERR WITH 99,lNoMostraMensaje
	IF FLGEST <> "C"
		IF RLOCK()
			REPLACE FLGEST WITH "C"
		ENDIF
		UNLOCK
	ENDIF
	RETURN .F.
ENDIF
LfImport = SdoDoc
IF TpoDoc = "A"
	LfImport = -SdoDoc
ENDIF
IF XnCodMon # CodMon
	IF XnCodMon = 1
		LfImport = ROUND(LfImport*XfTpoCmb,2)
	ELSE
		LfImport = ROUND(LfImport/XfTpoCmb,2)
	ENDIF
ENDIF
=SEEK(&LsAliasDocs..CodDoc,"TDOC")
LsNotAst = NomCli
xCodDiv(NumEle) = IIF(VARTYPE(XsCjaDiv)<>'C','',XsCjaDiv)
xCodCta(NumEle) = PADR(IIF(CodMon=1,TDOC.Cta12_MN,TDOC.Cta12_ME),LEN(RMOV.CodCta))
xCodMon(NumEle) = CodMon
xNroRef(NumEle) = ""
xCodAux(NumEle) = CodCli
XsNomAux = NomCli

IF PROGRAM(1)='CJA_CJAC1MOV'
	@YoBrow2-2,8 SAY "Cliente : " + xCodAux(numele)+" "+LsNotAst PICT "@S60"  color r+/n
ENDIF
RETURN .T.

*******************************
* Objeto : Grabar informacion *
*******************************
PROCEDURE GRACOB
LnAreaAct=SELECT()
IF VARTYPE(LoContab)<>'O'
	LOCAL LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoContab = CREATEOBJECT('Dosvr.Contabilidad')
ENDIF
IF !USED('GDOC')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('CMOV')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBMVTOS','CMOV','VTOS03','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a detalle de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('SLDO')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a Saldos por cliente',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
LsTpoAst = vTpoAst(NumEle)

PRIVATE LsLlave
DO CASE 
	CASE LsTpoAst<>'PROF'  && Todos los documentos que no son PROFORMAS : VETT 2007-10-04
		LsAliasDocs = 'GDOC'
		LsLlave = 'CARGO'+LsTpoAst
		LsWhile = [TpoDoc='CARGO' AND CodDoc=LsTpoAst]
		LsOrder = 'GDOC01'
	OTHERWISE
		IF !USED('VPRO')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
			IF !Lok
				=MESSAGEBOX('No hay acceso a registro de PROFORMAS',0+48,'Atención!!')
				RETURN lOk
			ENDIF
		ENDIF	
		LsAliasDocs = 'VPRO'
		LsLlave = ''
		LsWhile = '.T.'
		LsOrder = 'VPRO01'
ENDCASE 



SELECT (LsAliasDocs)
SET ORDER TO (LsOrder)
LsNroAst = vNroAst(NumEle)
LsNroDoc = PADR(LsNroAst,LEN(NRODOC))
SEEK LsLlave+LsNroDoc
IF ! FOUND() AND LsTpoAst<>'PROF'
	*!* Buscando Como Documento de ABONO *!*
	SEEK "ABONO"+LsTpoAst+LsNroDoc
	IF ! FOUND()
		GsMsgErr = "Documento no registrado"
		DO LIB_MERR WITH 99
		RETURN .F.
	ENDIF
ENDIF
IF ! RLOCK()
	RETURN
ENDIF
LfImport = vImport(NumEle)
pCodMon(NumEle) = CodMon
IF TpoDoc = "A"
	LfImport = -SdoDoc
ENDIF
LsTpoDocCCB=TpoDoc
SELE CMOV
*!* ACTUALIZAMOS SU MOVIMIENTO *!*
APPEND BLANK
IF !RLOCK()
	RETURN
ENDIF
** INI: VETT Actualización de saldos de documentos de ABONO - 2014-12-5
IF LsTpoDocCCB='A'
	REPLACE CodDoc WITH &LsAliasDocs..CodDoc 
	REPLACE NroDoc WITH &LsAliasDocs..NroDoc 
	REPLACE FchDoc WITH XdFchAst
	REPLACE CodCli WITH &LsAliasDocs..CodCli
	REPLACE CodMon WITH XnCodMon
	REPLACE FmaPgo WITH 3
	REPLACE TpoCmb WITH XfTpoCmb
	REPLACE TpoRef WITH IIF(LsALiasDocs='VPRO','',&LsAliasDocs..TpoDoc)
	REPLACE CodRef WITH "I/C"
	REPLACE NroRef WITH SUBSTR(XsCodOpe,2)+XsNroAst
	REPLACE GloDoc WITH VMOV->NotAst
	REPLACE Import WITH ABS(LfImport)  && Ojo, cuando es por cancelacion de Ingreso de Caja los TPODOC='ABONO' vienen con saldo negativo.
	REPLACE CodCta WITH XsCodCta
	REPLACE NroMes WITH XsNroMes
	REPLACE CodOpe WITH XsCodOpe
	REPLACE NroAst WITH XsNroAst
	REPLACE FlgCtb WITH .T.
ELSE
	REPLACE CodDoc WITH "I/C"
	REPLACE NroDoc WITH SUBSTR(XsCodOpe,2)+XsNroAst
	REPLACE FchDoc WITH XdFchAst
	REPLACE CodCli WITH &LsAliasDocs..CodCli
	REPLACE CodMon WITH XnCodMon
	REPLACE FmaPgo WITH 3
	REPLACE TpoCmb WITH XfTpoCmb
	REPLACE TpoRef WITH IIF(LsALiasDocs='VPRO','',&LsAliasDocs..TpoDoc)
	REPLACE CodRef WITH &LsAliasDocs..CodDoc
	REPLACE NroRef WITH &LsAliasDocs..NroDoc
	REPLACE GloDoc WITH VMOV->NotAst
	REPLACE Import WITH LfImport
	REPLACE CodCta WITH XsCodCta
	REPLACE NroMes WITH XsNroMes
	REPLACE CodOpe WITH XsCodOpe
	REPLACE NroAst WITH XsNroAst
	REPLACE FlgCtb WITH .T.
ENDIF
** FIN: VETT Actualización de saldos de documentos de ABONO - 2014-12-5
UNLOCK
*!* ACTUALIZAMOS DOCUMENTO *!*
SELECT (LsAliasDocs)
m.Import = LfImport
IF CodMon # XnCodMon
	IF CodMon = 1
		m.Import = ROUND(m.Import*XfTpoCmb,2)
	ELSE
		m.Import = ROUND(m.Import/XfTpoCmb,2)
	ENDIF
ENDIF
** VETT Actualización de saldos de documentos de ABONO - 2014-12-5
IF TPODOC='A'
	REPLACE SdoDoc WITH SdoDoc + m.Import
ELSE
	REPLACE SdoDoc WITH SdoDoc - m.Import
ENDIF
** 
IF SdoDoc <= 0.09
	REPLACE FlgEst WITH [C]
ENDIF
REPLACE FchAct WITH XdFchAst
UNLOCK
*!* extorno del saldo del cliente *!*
SELECT SLDO
SEEK &LsAliasDocs..CodCli
IF FOUND()
	IF RLOCK()
		IF LsTpoDocCCB='A'
			IF &LsAliasDocs..CodMon = 1
			    REPLACE AbnNac  WITH AbnNac + m.Import
		    ELSE
			    REPLACE AbnUsa  WITH AbnUsa + m.Import
		    ENDIF
		ELSE
			IF &LsAliasDocs..CodMon = 1
				REPLACE CgoNac WITH CgoNac - m.Import
			ELSE
				REPLACE CgoUsa WITH CgoUsa - m.Import
			ENDIF
		ENDIF	
	ENDIF
ENDIF
UNLOCK IN SLDO
DO grabar_Liqui_Deta
SELECT (LsAliasDocs)
SELECT (LnAreaAct)
RETURN .T.
**************************
FUNCTION Grabar_Liqui_deta
**************************
** Borramos registro en Liquidacion de cobranza VETT 21/10/2019 7:26 am
IF !USED('L_D_Cobr')
	RETURN
ENDIF
IF !USED('L_C_Cobr')
	RETURN
ENDIF
SELECT L_C_Cobr
SET ORDER TO LIQ_AST	 && LEFT(DTOS(FECHA),6)+CODOPE+ASIENTO
SEEK LEFT(DTOS(XdFchAst),6)+XsCodOpe+PADR(XsNroAst,LEN(ASIENTO))
IF FOUND() 
	SELECT L_D_Cobr
	APPEND BLANK
	REPLACE Liqui	WITH L_C_Cobr.Liqui
	REPLACE CodMon	WITH XiCodMon
	REPLACE TpoCmb	WITH XfTpoCmb
	IF XiCodMon = 1
		REPLACE ImpSol	WITH XfImport
		
	ELSE
		REPLACE ImpDol	WITH XfImpUsa
	ENDIF
	REPLACE CodCli	WITH XsCodAux
	REPLACE CliNom	WITH XsGloDoc
	REPLACE CodDoc	WITH XsCodDoc
	REPLACE NroDoc	WITH XsNroDoc
	IF XsCodDoc<>'PROF'
		IF !USED('GDOC')
			lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
			IF !Lok
				=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
				RETURN lOk
			ENDIF	
			=SEEK('CARGO'+XsCodDoc+PADR(XsNroDoc,LEN(GDOC.NroDoc)),'GDOC')
			SELECT L_D_Cobr
			REPLACE FchDoc	WITH GDOC.FchDoc
			REPLACE CodVen  WITH GDOC.CodVen
			REPLACE ImpNet  WITH GDOC.ImpTot
	    ENDIF	
	ELSE
		IF !USED('VPRO')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
			IF !Lok
				=MESSAGEBOX('No hay acceso a registro de PROFORMAS',0+48,'Atención!!')
				RETURN lOk
			ENDIF
		ENDIF
		=SEEK(PADR(XsNroDoc,LEN(VPRO.NroDoc)),'VPRO')
		SELECT L_D_Cobr
		REPLACE FchDoc	WITH GDOC.FchDoc
		REPLACE CodVen  WITH GDOC.CodVen
		REPLACE ImpNet  WITH GDOC.ImpTot
			
	ENDIF	
ENDIF
RETURN 
*******************************
* Objeto : Grabar informacion *
*******************************
PROCEDURE GRACOB_DFCMB
PARAMETERS PfImport,PnCodMon
LnAreaAct=SELECT()
IF VARTYPE(LoContab)<>'O'
	LOCAL LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoContab = CREATEOBJECT('Dosvr.Contabilidad')
ENDIF
IF !USED('GDOC')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('CMOV')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBMVTOS','CMOV','VTOS03','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a detalle de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
IF !USED('SLDO')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a Saldos por cliente',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF	
LsTpoAst = vTpoAst(NumEle)

PRIVATE LsLlave
DO CASE 
	CASE LsTpoAst<>'PROF'  && Todos los documentos que no son PROFORMAS : VETT 2007-10-04
		LsAliasDocs = 'GDOC'
		LsLlave = 'CARGO'+LsTpoAst
		LsWhile = [TpoDoc='CARGO' AND CodDoc=LsTpoAst]
		LsOrder = 'GDOC01'
	OTHERWISE
		IF !USED('VPRO')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
			IF !Lok
				=MESSAGEBOX('No hay acceso a registro de PROFORMAS',0+48,'Atención!!')
				RETURN lOk
			ENDIF
		ENDIF	
		LsAliasDocs = 'VPRO'
		LsLlave = ''
		LsWhile = '.T.'
		LsOrder = 'VPRO01'
ENDCASE 



SELECT (LsAliasDocs)
SET ORDER TO (LsOrder)
LsNroAst = vNroAst(NumEle)
LsNroDoc = PADR(LsNroAst,LEN(NRODOC))
SEEK LsLlave+LsNroDoc
IF ! FOUND() AND LsTpoAst<>'PROF'
	*!* Buscando Como Documento de ABONO *!*
	SEEK "ABONO"+LsTpoAst+LsNroDoc
	IF ! FOUND()
		GsMsgErr = "Documento no registrado"
		DO LIB_MERR WITH 99
		RETURN .F.
	ENDIF
ENDIF
IF ! RLOCK()
	RETURN
ENDIF
LfImport = PfImport  && vImport(NumEle)
IF TpoDoc = "A"
	LfImport = -SdoDoc
ENDIF
LsTpoDocCCB=TpoDoc
SELE CMOV
*!* ACTUALIZAMOS SU MOVIMIENTO *!*
APPEND BLANK
IF !RLOCK()
	RETURN
ENDIF
** INI: VETT Actualización de saldos de documentos de ABONO - 2014-12-5
IF LsTpoDocCCB='A'
	REPLACE CodDoc WITH &LsAliasDocs..CodDoc 
	REPLACE NroDoc WITH &LsAliasDocs..NroDoc 
	REPLACE FchDoc WITH XdFchAst
	REPLACE CodCli WITH &LsAliasDocs..CodCli
	REPLACE CodMon WITH PnCodMon &&  &LsAliasDocs..CodMon && XnCodMon
	REPLACE FmaPgo WITH 3
	REPLACE TpoCmb WITH XfTpoCmb
	REPLACE TpoRef WITH IIF(LsALiasDocs='VPRO','',&LsAliasDocs..TpoDoc)
	REPLACE CodRef WITH "I/C"
	REPLACE NroRef WITH SUBSTR(XsCodOpe,2)+XsNroAst
	REPLACE GloDoc WITH VMOV->NotAst
	REPLACE Import WITH ABS(LfImport)  && Ojo, cuando es por cancelacion de Ingreso de Caja los TPODOC='ABONO' vienen con saldo negativo.
	REPLACE CodCta WITH XsCodCta
	REPLACE NroMes WITH XsNroMes
	REPLACE CodOpe WITH XsCodOpe
	REPLACE NroAst WITH XsNroAst
	REPLACE FlgCtb WITH .T.
ELSE
	REPLACE CodDoc WITH "I/C"
	REPLACE NroDoc WITH SUBSTR(XsCodOpe,2)+XsNroAst
	REPLACE FchDoc WITH XdFchAst
	REPLACE CodCli WITH &LsAliasDocs..CodCli
	REPLACE CodMon WITH PnCodMon &&  &LsAliasDocs..CodMon && XnCodMon XnCodMon
	REPLACE FmaPgo WITH 3
	REPLACE TpoCmb WITH XfTpoCmb
	REPLACE TpoRef WITH IIF(LsALiasDocs='VPRO','',&LsAliasDocs..TpoDoc)
	REPLACE CodRef WITH &LsAliasDocs..CodDoc
	REPLACE NroRef WITH &LsAliasDocs..NroDoc
	REPLACE GloDoc WITH VMOV->NotAst
	REPLACE Import WITH LfImport
	REPLACE CodCta WITH XsCodCta
	REPLACE NroMes WITH XsNroMes
	REPLACE CodOpe WITH XsCodOpe
	REPLACE NroAst WITH XsNroAst
	REPLACE FlgCtb WITH .T.
ENDIF
** FIN: VETT Actualización de saldos de documentos de ABONO - 2014-12-5
UNLOCK
*!* ACTUALIZAMOS DOCUMENTO *!*
SELECT (LsAliasDocs)
m.Import = LfImport
** VETT:Siempre va a ser igual a moneda del documento asi que mejor lo comentamos 2015/03/25 15:36:34 ** 
*!*	IF CodMon # PCodMon(NumEle)  
*!*		IF CodMon = 1
*!*			m.Import = ROUND(m.Import*XfTpoCmb,2)
*!*		ELSE
*!*			m.Import = ROUND(m.Import/XfTpoCmb,2)
*!*		ENDIF
*!*	ENDIF

** VETT Actualización de saldos de documentos de ABONO - 2014-12-5
IF TPODOC='A'
	REPLACE SdoDoc WITH SdoDoc + m.Import
ELSE
	REPLACE SdoDoc WITH SdoDoc - m.Import
ENDIF
** 
IF SdoDoc <= 0.09
	REPLACE FlgEst WITH [C]
ENDIF
REPLACE FchAct WITH XdFchAst
UNLOCK
*!* extorno del saldo del cliente *!*
SELECT SLDO
SEEK &LsAliasDocs..CodCli
IF FOUND()
	IF RLOCK()
		IF LsTpoDocCCB='A'
			IF &LsAliasDocs..CodMon = 1
			    REPLACE AbnNac  WITH AbnNac + m.Import
		    ELSE
			    REPLACE AbnUsa  WITH AbnUsa + m.Import
		    ENDIF
		ELSE
			IF &LsAliasDocs..CodMon = 1
				REPLACE CgoNac WITH CgoNac - m.Import
			ELSE
				REPLACE CgoUsa WITH CgoUsa - m.Import
			ENDIF
		ENDIF	
	ENDIF
ENDIF
UNLOCK IN SLDO
SELECT (LsAliasDocs)
SELECT (LnAreaAct)
RETURN .T.


*********************************
* Objeto : DesActualiza Cta Cte *
*********************************
PROCEDURE DESCOB
****************
IF EMPTY(RMOV.CodDoc) OR EMPTY(RMOV.NroDoc)
	RETURN 
ENDIF
IF VARTYPE(LoContab)<>'O'
	LOCAL LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoContab = CREATEOBJECT('Dosvr.Contabilidad')
ENDIF

IF !USED('GDOC')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a registro de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF
IF !USED('CMOV')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBMVTOS','CMOV','VTOS03','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a detalle de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF
IF !USED('SLDO')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a Saldos por cliente',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF

LsTpoAst = RMOV->CodDoc
PRIVATE LsLlave
DO CASE 
	CASE LsTpoAst<>'PROF'  && Todos los documentos que no son PROFORMAS : VETT 2007-10-04
		LsAliasDocs = 'GDOC'
		LsLlave = 'CARGO'+LsTpoAst
		LsWhile = [TpoDoc='CARGO' AND CodDoc=LsTpoAst]
		LsOrder = 'GDOC01'
	OTHERWISE
		IF !USED('VPRO')
			lOk=gosvrcbd.odatadm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
			IF !Lok
				=MESSAGEBOX('No hay acceso a registro de PROFORMAS',0+48,'Atención!!')
				RETURN lOk
			ENDIF
		ENDIF	
		LsAliasDocs = 'VPRO'
		LsLlave = ''
		LsWhile = '.T.'
		LsOrder = 'VPRO01'
ENDCASE 


SELECT (LsAliasDocs)
SET ORDER TO (LsOrder)
** VETT 2014-12-05 

**
LsNroAst = RMOV->NroDoc
LsNroDoc = PADR(LsNroAst,LEN(NRODOC))
SEEK LsLlave+LsNroDoc
IF ! FOUND() AND LsTpoAst<>'PROF'
	*!* Buscando Como Documento de ABONO *!*
	SEEK "ABONO"+LsTpoAst+LsNroDoc
	IF ! FOUND()
		RETURN
	ENDIF
ENDIF
LsTpoDocCCB=TpoDoc
SELE CMOV
*!*	SEEK PADR("I/C",LEN(CodDoc))+PADR(SUBSTR(XsCodOpe,2)+"-"+XsNroAst,LEN(NroDoc))+GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
                           
IF LsTpoDocCCB="A"		
         ** CODREF+NROREF+CODDOC+CODOPE+NROAST 
	SEEK PADR("I/C",LEN(CodDoc))+PADR(RIGHT(XsCodOpe,2)+XsNroAst,LEN(NroRef))+ &LsAliasDocs..CodDoc + PADR(XsCodOpe+XsNroAst,LEN(CodOpe+NroAst))
ELSE
	SEEK &LsAliasDocs..CodDoc+PADR(&LsAliasDocs..NroDoc,LEN(NroRef))+PADR("I/C",LEN(CodDoc))+PADR(XsCodOpe+XsNroAst,LEN(CodOpe+NroAst))
ENDIF
IF !FOUND()
	RETURN
ENDIF
IF !RLOCK()
	RETURN
ENDIF
DELETE
UNLOCK
*!* ACTUALIZAMOS DOCUMENTO *!*
SELECT (LsAliasDocs)
m.Import = CMOV->Import
IF CodMon # CMOV->CodMon
	IF CodMon = 1
		m.Import = ROUND(m.Import*CMOV->TpoCmb,2)
	ELSE
		m.Import = ROUND(m.Import/CMOV->TpoCmb,2)
	ENDIF
ENDIF
REPLACE SdoDoc WITH SdoDoc+m.Import
IF SdoDoc <= 0.00
	REPLACE FlgEst WITH [C]
ELSE
	REPLACE FlgEst WITH [P]
ENDIF
UNLOCK
** Borramos registro en Liquidacion de cobranza VETT 21/10/2019 7:26 am
IF !USED('L_D_Cobr')
	RETURN
ENDIF
SELECT L_D_Cobr
SET ORDER TO CODDOC   && CODDOC+NRODOC+LIQUI
SEEK STRTRAN(LsLlave,'CARGO','')+PADR(LsNroDoc,LEN(L_D_Cobr.NroDoc))
IF !FOUND()
	RETURN
ENDIF
IF !RLOCK()
	RETURN
ENDIF
DELETE
UNLOCK
FLUSH IN L_D_Cobr
RETURN

*********************************
Function ChangeData
*********************************
IF VARTYPE(LoContab)<>'O'
	PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoContab = CREATEOBJECT('Dosvr.Contabilidad')
ENDIF	

IF !USED('RMOV')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a CBDRMOVM',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ENDIF
SELECT RMOV
REPLACE ALL tipdoc WITH coddoc FOR !EMPTY(coddoc)
REPLACE ALL tipdoc WITH '01' FOR tipdoc='FAC'
REPLACE ALL tipdoc WITH '03' FOR tipdoc='BOL'
REPLACE ALL tipdoc WITH '13' FOR tipdoc='CH'

RELEASE LoContab
**********************
FUNCTION redimensionar
**********************
PARAMETERS NewDim,LlForce
IF !LlForce 
	IF  NumEle > ALEN(vTpoAst)
		DIMENSION vTpoAst(NewDim)
		DIMENSION vNroAst(NewDim)
		DIMENSION xCodCta(NewDim)
		DIMENSION xCodMon(NewDim)
		DIMENSION xNroRef(NewDim)
		DIMENSION xCodAux(NewDim)
		DIMENSION xcoddiv(NewDim)
		MaxEle = NewDim
	ENDIF
ELSE
	DIMENSION vTpoAst(NewDim)
	DIMENSION vNroAst(NewDim)
	DIMENSION xCodCta(NewDim)
	DIMENSION xCodMon(NewDim)
	DIMENSION xNroRef(NewDim)
	DIMENSION xCodAux(NewDim)
	DIMENSION xcoddiv(NewDim)
	MaxEle = NewDim
ENDIF
