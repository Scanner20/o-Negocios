**********************************************************************
*  Nombre        : CJACJLE1.prg
*  Sistema       : Caja Bancos
*  Autor         : RHC
*  Prop¢sito     : Canje por Letras (Proveedor)
*  Creaci¢n      : 23/08/94
*                  RMT                                      - MILKITO
**********************************************************************

* arreglo de Facturas
DIMENSION vTpoAst(20),vNroAst(20),vNotAst(20),vImport(20)
DIMENSION xCodCta(20),xCodMon(20),xNroRef(20),xCodAux(20)
* arreglo de Cuentas Auxiliares
DIMENSION vCodCta(20),vCodAux(20),vNroRef(20),vImpCta(20),vTpoMov(20),vCodAdd(20),vGloDoc(20)
* arreglo de Letras
DIMENSION aTpoAst(20),aNroAst(20),aNotAst(20),aImport(20),aFchVto(20)
DIMENSION aVctOri(20),aImpOri(20),aGloOri(20)
* * * *
XsCodOpe = "003"     && Letras Proveedor
XsCodOp1 = "016"     && Proveedores
XsClfAux = "PRO"     && Clasificacion
* * * *
XsNroMes = TRANSF(_MES,"@L ##")
ZiCodMon = 1
ScrMov   = ""
MaxEle1  = 0
MaxEle2  = 0
MaxEle3  = 0
LiCanLet = 0
LiNumLet = 0
Crear    = .T.
Modificar= .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XiNroVou,XsGloAst
STORE "" TO XsCtaCja,XfImpChq,XsNroChq,XsGirado,XsCodAux,XsNomAux,XsAuxil
STORE 0  TO XfImpCh1,XfImpCh2,XfImpCh3
XdFchAst = DATE()
XfTpoCmb = 1.00
NroOpc   = 0
XdFchVto = {,,}

RESTORE FROM CJACONFG ADDITIVE


SELECT 1
USE CBDTCNFG ORDER CNFG01 ALIAS CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
	GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
	DO LIB_MERR WITH 99
	CLOSE DATA
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


DO MOVgPant
DO MOVApert
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF


SELECT OPER
SEEK XsCodOpe
IF ! FOUND()
   GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
* * * *
LsClfAux = []
LsCodAux = []
UltTecla = 0
DO WHILE (.t.)
   DO MOVNoDoc
   SELECT VMOV
   DO CASE
      CASE UltTecla = Escape
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
         IF Crear
            DO MOVInVar
         ELSE
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
            SELECT VMOV
            IF ! REC_LOCk(5)
               LOOP
            ENDIF
            DO MOVMover
         ENDIF
         DO MOVEdita
         IF UltTecla <> Escape
            DO MOVGraba
            IF UltTecla <> Escape
               DO MovPrint
            ENDIF
         ENDIF
   ENDCASE
   UNLOCK ALL
ENDDO
CLOSE DATA
CLOSE PROCEDURE
RETURN

************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
******************
** Abrimos areas a usar **
SELECT 0
USE CBDTCIER
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
	GOTO RegAct
	Modificar = ! Cierre
	IF  Cierre  .OR. CjaBco
		CLOSE DATA
		GsMsgErr = "*** Mes de Proceso Cerrado ***"
		DO LIB_MERR WITH 99
		RETURN
	ENDIF
ENDIF
SELE 0
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdrmovm ORDER rmov01   ALIAS RMOV
IF ! USED(4)
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdtoper ORDER oper01   ALIAS OPER
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE cbdacmct ORDER acct01   ALIAS ACCT
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE CJATPROV ORDER prov01   ALIAS PROV
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELECT RMOV

RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant

*
*           1         2         3         4         5         6         7         8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*0* VOUCHER DE CANJE POR LETRA *                   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*1***************************************          ³N§ COMPROBANTE.:             ³
*2PROVEEDOR :                                      ³FECHA..........:             ³
*3NOMBRE....:                                      ³MONEDA ...:                  ³
*4                                                 ³T/CAMBIO.......:             ³
*5                                                 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*6ÚðTipo ð N§  PROV.ð   C O N C E P T O                      ð         IMPORTE  ð¿
*7³ 12345 1234567890 123456789012345678901234567890123456 12345 S/.###,###,###.##³
*8³                                                                              ³
*9³                                                                              ³
*0ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*1ÚðCTAS.ð       C O N C E P T O       ðAUXI.ðN§  DOCTO.ðESTADð         IMPORTE ð¿
*2³ XXXXX 123456789-123456789-123456789-1234 12345 123456789- 123123456789-1234S ³
*3³                                                                              ³
*4³                                                                              ³
*5ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*6
*7  Cantidad de Letras :           N£mero Inicial :
*8ÚðTipo ð N§ LETRA ð   C O N C E P T O             ðF.VENCTOð         IMPORTE  ð¿
*9³ 12345 1234567890 1234567890123456789012345678901 99/99/99   S/.###,###,###.##³
*0³                                                                              ³
*1³                                                                              ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*           1         2         3         4         5         6         7         8


CLEAR
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY PADC("* VOUCHER DE CANJE POR LETRA *",38) COLOR SCHEME 7
@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 5,79

@ 2,00 SAY "PROVEEDOR :"
@ 3,00 SAY "NOMBRE....:"
@  1,50 SAY "N§ COMPROBANTE.:"
@  2,50 SAY "FECHA..........:"
@  3,50 SAY "MONEDA ...:"
@  4,50 SAY "T/CAMBIO.......:"

@  6,00 SAY "ÚðTipo ð N§  PROV.ð   C O N C E P T O                      ð         IMPORTE  ð¿"
@  7,00 SAY "³                                                                              ³"
@  8,00 SAY "³                                                                              ³"
@  9,00 SAY "³                                                                              ³"
@ 10,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 11,00 SAY "ÚðCTAS.ð       C O N C E P T O       ðAUXI.ðN§  DOCTO.ðESTADð         IMPORTE ð¿"
@ 12,00 SAY "³                                                                              ³"
@ 13,00 SAY "³                                                                              ³"
@ 14,00 SAY "³                                                                              ³"
@ 15,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 16,00 SAY "                                                                                "
@ 17,00 SAY "  Cantidad de Letras :           N£mero Inicial :                               "
@ 18,00 SAY "ÚðTipo ð N§ LETRA ð   C O N C E P T O             ðF.VENCTOð         IMPORTE  ð¿"
@ 19,00 SAY "³                                                                              ³"
@ 20,00 SAY "³                                                                              ³"
@ 21,00 SAY "³                                                                              ³"
@ 22,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 23,00 SAY "VERIFICA:"
@  6,01 SAY "ðTipo ð N§  PROV.ð   C O N C E P T O                      ð         IMPORTE  ð" COLOR SCHEME 7
@ 11,01 SAY "ðCTAS.ð       C O N C E P T O       ðAUXI.ðN§  DOCTO.ðESTADð         IMPORTE ð" COLOR SCHEME 7
@ 18,01 SAY "ðTipo ð N§ LETRA ð   C O N C E P T O             ðF.VENCTOð         IMPORTE  ð" COLOR SCHEME 7

SAVE SCREEN TO SCRMOV

RETURN
************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc

i = 1
XsNroAst = NROAST()
RESTORE SCREEN FROM ScrMov
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
DO WHILE ! INLIST(UltTecla,Enter,Escape)
	@ 1,68 GET XsNroAst PICT "999999"
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
		CASE UltTecla = Escape
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
			IF XsNroAst < NROAST()
				IF Llave = (NroMes + CodOpe + NroAst) .AND. VMOV->FlgEst<>"A"
					EXIT
				ENDIF
				SEEK LLave
				IF ! FOUND() .AND. INLIST(UltTecla,CtrlW,Enter)
					RESTORE SCREEN FROM ScrMov
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
					ENDIF
				ENDIF
			ENDIF
	ENDCASE
	IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
		XsNroAst = NROAST()
		RESTORE SCREEN FROM ScrMov
		DO LIB_MTEC WITH 2
		Crear = .t.
	ELSE
		XsNroAst = VMOV->NroAst
		DO MovPinta
		Crear = .f.
	ENDIF
ENDDO
@ 1,68 SAY XsNroAst
SELECT VMOV
RETURN

************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar

MaxEle1  = 0
MaxEle2  = 0
MaxEle3  = 0
XnCodMon = 1
XsNotAst = SPACE(LEN(VMOV->NOTAST))
XsGirado = SPACE(LEN(VMOV->Girado))
XsGloAst = ""
XdFchAst = DATE()
XsDigita = GsUsuario
XsCtaCja = SPACE(LEN(RMOV->CODCTA))
XiNroVou = OPER->NroRel
XfImpChq = 0
XfImpCh1 = 0
XfImpCh2 = 0
XfImpCh3 = 0
XsNroChq = SPACE(LEN(VMOV->NroChq))
XsAuxil  = SPACE(LEN(RMOV->CodAux))
XsNomAux = SPACE(LEN(AUXI->NomAux))

XCODMON = 0
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
XsDigita = GsUsuario
XsCtaCja = CtaCja
XiNroVou = VAL(NroVou)
XfImpChq = ImpChq
XfImpCh1 = 0
XfImpCh2 = 0
XfImpCh3 = 0
XsNroChq = VMOV->NroChq
XfTpoCmb = VMOV->TpoCmb
XsAuxil  = VMOV->Auxil
RETURN

************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta

=SEEK(CtaCja,"AUXI")
@ 01,68 SAY NroAst
@ 02,68 SAY FchAst
IF VMOV->CodMon = 1
	XnCodMon = 1
	@ 03,68 SAY "S/. "
ELSE
	XnCodMon = 2
	@ 03,68 SAY "US$ "
ENDIF
@ 4 ,68 SAY TpoCmb PICT "9999.9999"
@ 02,12 SAY CtaCja
@ 03,12 SAY AUXI->NomAux PICT "@S35"
@  7,01 CLEAR TO  9,78
@ 12,01 CLEAR TO 14,78
@ 19,01 CLEAR TO 21,78
LinAct1 = 7
LinAct2 = 19
LinAct3 = 12
IF VMOV->FlgEst = "A"
	@ LinAct1,0 say []
	@ ROW()  ,11 SAY "     #    #     # #     # #          #    ######  #######  "
	@ ROW()+1,11 SAY "   # # #  # #   # #     # #        # # #  #     # #     #  "
	@ ROW()+1,11 SAY "  #     # #   # #  #####  ####### #     # ######  #######  "
ENDIF
**** Buscando Datos Ventana 1 ****
SELECT RMOV
LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
SEEK LsLLave
MaxEle1 = 0
MaxEle2 = 0
MaxEle3 = 0
LICanLet = 0
XsNomAux = ""
Ancho    = 74
Xo       = INT((80 - Ancho)/2)
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
	DO CASE
		CASE EliItm = CHR(255)
			IF MaxEle1 >= 20
				SKIP
				LOOP
			ENDIF
			XfImport = IIF(TpoMov="D",1,-1)*Import
			XfImpUsa = IIF(TpoMov="D",1,-1)*ImpUsa
			IF EMPTY(XsCodAux)
				XsCodAux = CodAux
				XsClfAux = ClfAux
				=SEEK(XsClfAux+XsCodAux,"AUXI")
				XsNomAux = AUXI->NomAux
				@ 2,12 SAY XsCodAux
				@ 3,12 SAY XsNomAux PICT "@S35"
			ENDIF
			MaxEle1= MaxEle1+ 1
			*** Revisar ***
			vNroAst(MaxEle1) = NroDoc
			vTpoAst(MaxEle1) = CodDoc
			vNotAst(MaxEle1) = GloDoc
			xCodCta(MaxEle1) = CodCta
			xCodMon(MaxEle1) = CodMon
			xNroRef(MaxEle1) = NroRef
			xCodAux(MaxEle1) = CodAux
			IF VMOV->CodMon = 1
				vImport(MaxEle1) = XfImport
			ELSE
				vImport(MaxEle1) = XfImpUsa
			ENDIF
			IF LinAct1 < 9
				DO GENbline WITH MaxEle1, LinAct1
				LinAct1 = LinAct1 + 1
			ENDIF
		CASE EliItm = "@"
			** Cuentas Adicionales **
			IF MaxEle3 >= 20
				SKIP
				LOOP
			ENDIF
			MaxEle3 = MaxEle3 + 1
			=SEEK(CodCta,"CTAS")
			vCodCta(MaxEle3) = CodCta
			IF EMPTY(XsCodAux) .AND. CTAS->PIDAUX="S"
				XsCodAux = CodAux
				XsClfAux=  ClfAux
				@  2,12 SAY XsCodAux
				XsNomAux = AUXI->NomAux
				=SEEK(XsClfAux+XsCodAux,"AUXI")
				@  3,12 SAY AUXI->NomAux PICT "@S35"
			ENDIF
			vCodAux(MaxEle3) = CodAux
			vGloDoc(MaxEle3) = Glodoc
			vNroRef(MaxEle3) = NroDoc
			vTpoMov(MaxEle3) = TpoMov
			IF VMOV->CodMon = 1
				vImpCta(MaxEle3) = Import
			ELSE
				vImpCta(MaxEle3) = ImpUsa
			ENDIF
*			vCodAdd(MaxEle3) = CodAdd
			IF LinAct3 < 15
				DO GENblin3 WITH MaxEle3, LinAct3
				LinAct3 = LinAct3 + 1
			ENDIF
		CASE ! INLIST(EliItm,"ù","ú","ð") OR EliItm = "›"
			IF MaxEle2 >= 20
				SKIP
				LOOP
			ENDIF
			XfImport = Import
			XfImpUsa = ImpUsa
			MaxEle2 = MaxEle2 + 1
			LiCanLet = LiCanLet + 1
			IF LiNumLet = 0 AND !Crear
				LiNumLet = Val(NroDoc)
			ENDIF
			aNroAst(MaxEle2) = NroDoc
			aTpoAst(MaxEle2) = CodDoc
			aNotAst(MaxEle2) = GloDoc
			aFchVto(MaxEle2) = FchVto
			IF VMOV->CodMon = 1
				aImport(MaxEle2) = XfImport
			ELSE
				aImport(MaxEle2) = XfImpUsa
			ENDIF
			IF LinAct2 < 22
				DO GENbline2 WITH MaxEle2, LinAct2
				LinAct2 = LinAct2 + 1
			ENDIF
	ENDCASE
	SELECT RMOV
	SKIP
ENDDO
SELECT VMOV
RETURN

************************************************************************** FIN
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
	iNroDoc = VAL(XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ######"),4))
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
RETURN  RIGHT("000000" + LTRIM(STR(iNroDoc)), 6)
************************************************************************** FIN
* Procedimiento que edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita

UltTecla = 0
I        = 1
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
	DO CASE
		CASE I = 1
			@ 2,68 GET XdFchAst
			READ
			UltTecla = LastKey()
			@ 2,68 SAY XdFchAst
		CASE I = 2
			VecOpc(1)="S/."
			VecOpc(2)="US$"
			XnCodMon= Elige(XnCodMon,3,68,2)
		CASE I = 3
			IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
				?? CHR(7)
				WAIT "No Registrado el tipo de Cambio" NOWAIT WINDOW
			ENDIF
			IF CREAR .AND. ! EMPTY(TCMB->OFICMP)
				XfTpoCmb = TCMB->OFICMP
			ENDIF
			@ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
			READ
			UltTecla = LastKey()
			@ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
			IF UltTecla = Escape
				EXIT
			ENDIF
		CASE I = 4
			SELECT AUXI
			@ 02,12 GET XsAuxil  PICTURE "@!"
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape
				EXIT
			ENDIF
			IF UltTecla = F8 .OR. EMPTY(XsAuxil )
				IF ! CBDBUSCA("AUXI")
					LOOP
				ENDIF
				XsAuxil  = CodAux
				UltTecla = Enter
			ENDIF
			SEEK XsClfAux+XsAuxil
			IF ! FOUND()
				GsMsgErr = "Proveedor no Registrado"
				DO LIB_MERR WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			@ 02,12 SAY XsAuxil
			@ 03,12 SAY AUXI->NomAux PICT "@S35"
		CASE I = 5
			DO COMPROBAN
			XfImpCh1 = 0
			FOR ii = 1 to MaxEle1
				XfImpCh1 = XfImpCh1 + vImport(ii)
			ENDFOR
			@ 10,64 SAY XfImpCh1          PICT "999,999,999.99" COLOR SCHEME 7
			@ 16,64 SAY XfImpCh1+XfImpCh3 PICT "999,999,999.99" COLOR SCHEME 7
			IF LASTKEY() = Escape
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
		CASE I = 6
			* cuentas adicionales *
			DO VOUCHER3
			XfImpCh3 = 0
			FOR ii = 1 to MaxEle3
				XfImpCh3 = XfImpCh3 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
			ENDFOR
			@ 15,64 SAY XfImpCh3          PICT "999,999,999.99" COLOR SCHEME 7
			@ 16,64 SAY XfImpCh1+XfImpCh3 PICT "999,999,999.99" COLOR SCHEME 7
			IF LASTKEY() = Escape
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
         	ENDIF
		CASE i = 7 &&.AND. Crear
			@ 17,23 GET LiCanLet PICT "999" RANGE 0,20
			READ
			UltTecla = LASTKEY()
		CASE i = 8 &&.AND. Crear
			@ 17,50 GET LiNumLet PICT "999999" WHEN _NumLet()
			READ
			UltTecla = LASTKEY()
		CASE I = 9
			* Letras *
			DO VOUCHER
			XfImpCh2 = 0
			FOR ii = 1 to MaxEle2
				XfImpCh2 = XfImpCh2 + aImport(ii)
			ENDFOR
			@ 22,64 SAY XfImpCh2 PICT "999,999,999.99" COLOR SCHEME 7
			IF LASTKEY() = Escape
				UltTecla = Arriba
			ELSE
				UltTecla = Enter
			ENDIF
			IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 .AND. MAXELE3 = 0)
				XsNotAst = PADR("*** VOUCHER ANULADO ***",LEN(XsNotAst))
				XsGirado = PADR("*** VOUCHER ANULADO ***",LEN(XsGirado))
			ENDIF
		CASE I = 10
			*  * verificamos montos iguales *
			*  IF XfImpCh1+XfImpCh3 # XfImpCh2
			*     GsMsgErr = [ Los montos deben ser iguales ]
			*     DO lib_merr WITH 99
			*     UltTecla = 0
			*     i = 1
			*     LOOP
			*  ENDIF

		CASE I = 11
			SAVE SCREEN
			@ 18,00 TO 22,79 DOUBLE
			@ 18,03 SAY "DETALLES" COLOR SCHEME 7
			GsMsgKey = "[S-TAB] Campo anterior     [Esc] Cancela    [F10] Siguiente Campo "
			DO LIB_MTEC WITH 99
			@ 19,1 EDIT XsGloAst SIZE 3,78 COLOR SCHEME 7
			READ
			RESTORE SCREEN
			UltTecla = LastKey()
			IF UltTecla = BackTab .OR. UltTecla = Escape
				UltTecla = Arriba
			ENDIF
			IF UltTecla = 9
				UltTecla = CtrlW
			ENDIF
			UltTecla = CtrlW
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>11,11,i)
	i = IIF(i<1, 1, i)
	IF INLIST(UltTecla,F10,CtrlW)
		* IF XfImpCh1+XfImpCh3 # XfImpCh2
		*    GsMsgErr = " Los Montos deben ser iguales "
		*    DO LIB_MERR WITH 99
		*    UltTecla = 0
		*    i = 1
		* ENDIF
	ENDIF
ENDDO
SELECT VMOV
RETURN
****************

*****************
PROCEDURE _NUMLET
*****************
** Determina el numero de letra a grabar **
LiNumLet = OPER->NroDoc
RETURN .T.

*******************
PROCEDURE COMPROBAN
*******************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
Yo       = 6
Largo    = 5
Ancho    = 80
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle1
TotEle   = 20     && M ximos elementos a usar
DO ABROWSE
MaxEle1 = MaxEle
IF MaxEle1 = 1 .AND. EMPTY(LEFT(vNroAst(1),6))
	MaxEle1 = 0
	@ 7,01 CLEAR TO 10,78
ENDIF
@ 7,01 Fill TO 10,78 COLOR SCHEME 1
IF LASTKEY() = Escape
	RETURN
ENDIF

RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin

@ NumLin,2  SAY vTpoAst(NumEle)
@ NumLin,08 SAY vNroAst(NumEle)
@ NumLin,19 SAY vNotAst(NumEle) PICT "@S40"
@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,64 SAY vImport(NumEle) PICT "###,###,###.##"

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

*           1         2         3         4         5         6         7         8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*6ÚðTipo ð N§  PROV.ð   C O N C E P T O                      ð         IMPORTE  ðÄ¿
*7³ 12345 123456-12  1234567890123456789012345678901234567890  S/.999,999,999.99  ³

i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
	DO CASE
		CASE i = 1
			SELECT PROV
			@ NumLin,2   GET LsTpoAst PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				EXIT
			ENDIF
			IF ULTTECLA = Escape
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
				UltTecla = Escape
				KEYB CHR(23)
				EXIT
			ENDIF
			@ NumLin,2   SAY LsTpoAst PICT "@!"
			SEEK LsTpoAst
			IF ! FOUND()
				GsMsgErr = "** COD. DOCUMENTO NO REGISTRADO **"
				DO LIB_Merr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
		CASE i = 2
			IF PROV->TIPO="A" .AND. EMPTY(SUBSTR(LsNroAst,8,2))
				LsNroAst = SUBSTR(LsNroAst,1,6)+"-"+RIGHT(STR(_ANO,4),2)+" "
			ENDIF
			IF PROV->TIPO="A"
				@ NumLin,08  GET LsNroAst PICT "!!!!!!-99!"
			ELSE
				@ NumLin,08  GET LsNroAst PICT "@!"
			ENDIF
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				I = 1
				LOOP
			ENDIF
			IF ULTTECLA = Escape
				EXIT
			ENDIF
			IF ULTTECLA = F8
				LOOP
			ENDIF
			IF ! CHKNROAST()
				UltTecla = 0
				LOOP
			ENDIF
			@ NumLin,19 SAY LsNotAst PICT "@S40"
		CASE i = 3
			@ NumLin,19 GET LsNotAst PICT "@S40"
			READ
			UltTecla = LASTKEY()
		CASE i = 4
			@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
			@ NumLin,64 GET LfImport PICT "###,###,###.##"
			READ
			UltTecla = LASTKEY()

		CASE i = 5
			IF UltTecla = Enter
				EXIT
			ENDIF
			IF INLIST(UltTecla,F10,CtrlW)
				UltTecla = CtrlW
				EXIT
			ENDIF
			i = 1
	ENDCASE
	i = IIF(UltTecla = Izquierda, i-1, i+1)
	i = IIF( i > 5 , 5, i)
	i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape
	vTpoAst(NumEle) = LsTpoAst
	vNroAst(NumEle) = LsNroAst
	vImport(NumEle) = LfImport
	vNotAst(NumEle) = LsNotAst
ENDIF
XfImpCh1 = 0
FOR ii = 1 to MaxEle
	XfImpCh1 = XfImpCh1 + vImport(ii)
ENDFOR
@ 10,64 SAY XfImpCh1 PICT "999,999,999.99" COLOR SCHEME 7

LiUTecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Chequeando la existencia de la provisi¢n
******************************************************************************
PROCEDURE CHKNROAST
*******************

** Verificando que no se repita en otro item **
IF MaxEle > 1
	FOR z = 1 TO MaxEle
		IF Z#NumEle .AND. vTpoAst(z)=LsTpoAst .AND. vNroAst(z)=LsNroAst
			GsMsgErr = "*** Nro. de Documento ya registado en otro item **"
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
FOR Z = 1 TO NumCta
	LsCodCta = xxCodCta(Z)
	SELECT RMOV
	SET ORDER TO RMOV05
	SEEK LsCodCta + LsNroAst
	IF FOUND()
		* Posicionamos el puntero *
		DO WHILE ! EOF() .AND. CodCta+NroDoc = LsCodCta+LsNroAst
			IF CodOpe == PROV->CodOpe And CodAux = XsAuxil
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
			Llave = xCodCta(NumEle)+LsNroAst+xCodAux(NumEle)
			SdoNac = 0
			SdoUsa = 0
			DO WHILE ! EOF() .AND. CodCta+NroDoc+CodAux = Llave
				IF CodOpe == PROV->CodOpe
					xCodMon(NumEle) = CodMon
					xNroRef(NumEle) = NroREf
					=SEEK(NroMes+CodOpe+NroAst,"VMOV")
					LsNotAst = VMOV->NotAst
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
SELECT VMOV
IF ! Ok
	GsMsgErr = "*** Provisi¢n no Registrada **"
	DO LIB_MERR WITH 99
	RETURN .F.
ENDIF
SET ORDER TO VMOV01
RETURN .T.
*********************************************************************** FIN *
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
* Browse de Letras
**********************************************************************
PROCEDURE VOUCHER

PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENbline2"
EdiLin   = "GENbedit2"
BrrLin   = "GENbborr2"
InsLin   = "GENbinse2"
Yo       = 18
Largo    = 5
Ancho    = 80
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
IF Crear .or. MaxEle2=0
	DO GENbinv2
ENDIF
MaxEle   = MaxEle2
TotEle   = 20     && M ximos elementos a usar
DO ABROWSE
MaxEle2 = MaxEle
IF MaxEle2 = 1 .AND. EMPTY(LEFT(aNroAst(1),6))
	MaxEle2 = 0
	@ 16,01 CLEAR TO 19,78
ENDIF
@ 16,01 Fill TO 19,78 COLOR SCHEME 1
IF LASTKEY() = Escape
	RETURN
ENDIF

RETURN
******************************************************************************
* Objeto : Carga Inicial de datos
******************************************************************************
PROCEDURE GENbinv2

=SEEK([003],"PROV")
PRIVATE i
LfImport = ROUND((XfImpCh1+XfImpCh3)/LiCanLet,2)
LfImpLet = 0
FOR i = 1 TO LiCanLet
	aTpoAst(i) = [003]
	IF PROV->TIPO="A"
		aNroAst(i) = PADL(ALLTRIM(STR(LiNumLet)),6,'0')+'-'+RIGH(STR(_ANO,4),2)+IIF(i=1," ",CHR(63+i))
	ELSE
		aNroAst(i) = PADL(ALLTRIM(STR(LiNumLet)),6,'0')+'    '
	ENDIF
	aNotAst(i) = SPACE(LEN(RMOV->GloDoc))
	aImport(i) = LfImport
	*Datos Nuevos Finanzas
	aFchVto(i) = {,,}
	*
	LfImpLet   = LfImpLet + LfImport
*	LiNumLet   = LiNumLet + 1
ENDFOR
IF LfImpLet # XfImpCh1+XfImpCh3
	* acumulamos en la 1ra.
	aImport(1) = aImport(1) + (XfImpCh1-LfImpLet)
ENDIF
XfImpCh2 = XfImpCh1+XfImpCh3
MaxEle2  = LiCanLet
@ 22,64 SAY XfImpCh2 PICT "999,999,999.99" COLOR SCHEME 7

RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline2
PARAMETERS NumEle, NumLin

@ NumLin,2  SAY aTpoAst(NumEle)
@ NumLin,08 SAY aNroAst(NumEle)
@ NumLin,19 SAY aNotAst(NumEle) PICT "@S30"
@ NumLin,51 SAY aFchVto(NumEle)
@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,64 SAY aImport(NumEle) PICT "###,###,###.##"

RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit2
PARAMETERS NumEle, NumLin, LiUtecla

LsTpoAst = aTpoAst(NumEle)
*Datos Nuevos Finanzas
*
LsNroAst = aNroAst(NumEle)
LfImport = aImport(NumEle)
LsNotAst = aNotAst(NumEle)
LdFchVto = aFchVto(NumEle)
UltTecla = 0

*           1         2         3         4         5         6         7         8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*6ÚðTipo ð N§ LETRA ð   C O N C E P T O            ðF.Vencto.ð         IMPORTE  ðÄ¿
*7³ LET   123456-12  123456789012345678901234567890  99/99/99  S/.999,999,999.99  ³

PRIVATE i,Crear
i = 1
*=SEEK([009],"PROV")
*Crear = CHKNROLET()
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
	*i = IIF(!Crear .AND. i < 2,2,i)
	DO CASE
		CASE i = 1
			SELE PROV
*			set filter to INLIST(TpoDoc,"LPRO")
			GO TOP
			@ NumLin,02 GET LsTpoAst
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				EXIT
			ENDIF
			IF ULTTECLA = Escape
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
				UltTecla = Escape
				KEYB CHR(23)
				EXIT
			ENDIF
			@ NumLin,2   SAY LsTpoAst PICT "@!"
			SEEK LsTpoAst
			IF ! FOUND()
				GsMsgErr = "** COD. DOCUMENTO NO REGISTRADO **"
				DO LIB_Merr WITH 99
				UltTecla = 0
				LOOP
			ENDIF
			SET FILTER TO
		CASE i = 2
			IF PROV->TIPO="A"
				@ NumLin,08  GET LsNroAst PICT "@!"
			ELSE
				@ NumLin,08  GET LsNroAst PICT "@!"
			ENDIF
			READ
			UltTecla = LASTKEY()
			IF ULTTECLA = Arriba
				I = 1
				LOOP
			ENDIF
			IF ULTTECLA = Escape
				EXIT
			ENDIF
			IF ULTTECLA = F8
				LOOP
			ENDIF
			IF ! CHKNROLET()
				UltTecla = 0
				LOOP
			ENDIF
		CASE i = 3
			@ NumLin,19 GET LsNotAst PICT "@S30"
			READ
			UltTecla = LASTKEY()
		CASE i = 4
			@ NumLin,51 GET LdFchVto VALID(LdFchVto>=XdFchAst)
			READ
			UltTecla = LASTKEY()
		CASE i = 5
			@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
			@ NumLin,64 GET LfImport PICT "###,###,###.##"
			READ
			UltTecla = LASTKEY()
		CASE i = 6
			**LECTURA DE LOS NUEVOS DATOS DE FINANZAS
			*  DEFINE WINDOW FINANZAS FROM 11,0  TO 15,79 ;
			*         TITLE "Control de Finanzas"
			*  ACTIVATE WINDOW FINANZAS
			*  @0,8 SAY "Vencimiento Original " GET LdVctOri VALID !EMPTY(LdVctOri)
			*  @1,8 SAY "Importe     Original " GET LnImpOri PICT "999999999.99" VALID !EMPTY(LnImpOri)
			*  @2,8 SAY "Descripci¢n Original " GET LsGloOri VALID !EMPTY(LsGloOri)
			*  READ
			*  UltTecla = LastKey()
			*  DEACTIVATE WINDOW FINANZAS
		CASE i = 7
			IF UltTecla = Enter
				EXIT
			ENDIF
			IF INLIST(UltTecla,F10,CtrlW)
				UltTecla = CtrlW
				EXIT
			ENDIF
			i = 1
	ENDCASE
	i = IIF(UltTecla = Izquierda, i-1, i+1)
	i = IIF( i > 7 , 7, i)
	i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape
	aTpoAst(NumEle) = LsTpoAst
	*Datos Nuevos Finanzas
	aNroAst(NumEle) = LsNroAst
	aImport(NumEle) = LfImport
	aNotAst(NumEle) = LsNotAst
	aFchVto(NumEle) = LdFchVto
ENDIF
XfImpCh2 = 0
FOR ii = 1 to MaxEle
	XfImpCh2 = XfImpCh2 + aImport(ii)
ENDFOR
@ 22,64 SAY XfImpCh2 PICT "999,999,999.99" COLOR SCHEME 7

LiUTecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr2
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
	aTpoAst(i) = aTpoAst(i+1)
	*Datos Nuevos Finanzas

	aNroAst(i) = aNroAst(i+1)
	aImport(i) = aImport(i+1)
	aNotAst(i) = aNotAst(i+1)
	aFchVto(i) = aFchVto(i+1)
	i = i + 1
ENDDO
aTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
*** Datos Nuevos Finanzas ***
aNroAst(i) = SPACE(LEN(RMOV->NroDoc))
aImport(i) = 0
aNotAst(i) = SPACE(LEN(VMOV->NotAst))
aFchVto(i) = {,,}
Estado = .T.
RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse2
PARAMETERS ElePrv, Estado

Estado = .F.
RETURN
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
	aTpoAst(i) = aTpoAst(i-1)
	*Datos Nuevos Finanzas
	aNroAst(i) = aNroAst(i-1)
	aImport(i) = aImport(i-1)
	aNotAst(i) = aNotAst(i-1)
	aFchVto(i) = aFchVto(i-1)
	i = i - 1
ENDDO
i = ElePrv + 1
aTpoAst(i) = SPACE(LEN(RMOV->CodDoc))
aNroAst(i) = SPACE(LEN(RMOV->NroDoc))
aNotAst(i) = SPACE(LEN(VMOV->NotAst))
aImport(i) = 0
aFchVto(i) = {,,}
Estado = .T.
RETURN
**********************************************************************
* Objeto : Chequeando la existencia de la letra
******************************************************************************
PROCEDURE CHKNROLET
*******************

** Verificando que no se repita en otro item **
IF MaxEle > 1
	FOR z = 1 TO MaxEle
		IF Z#NumEle .AND. aTpoAst(z)=LsTpoAst .AND. aNroAst(z)=LsNroAst
			GsMsgErr = "*** Nro. de Letra ya registado en otro item **"
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

OK = .T.
FOR Z = 1 TO NumCta
	LsCodCta = xxCodCta(Z)
	SELECT RMOV
	SET ORDER TO RMOV05
	SEEK LsCodCta + LsNroAst
	IF FOUND()
		SET ORDER TO RMOV01
		OK = .F.
		EXIT
	ENDIF
	SET ORDER TO RMOV01
NEXT
SELECT VMOV
* IF ! Ok
*    GsMsgErr = "*** Letra YA Registrada **"
*    DO LIB_MERR WITH 99
*    RETURN .F.
* ENDIF
SET ORDER TO VMOV01

RETURN .T.
************************************************************************ FIN *
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
IF .NOT. RLock()
	GsMsgErr = "Asiento usado por otro usuario"
	DO LIB_MERR WITH 99
	UltTecla = Escape
	RETURN              && No pudo bloquear registro
ENDIF
DO LIB_MSGS WITH 10
XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
	Llave = (NroMes + CodOpe + NroAst )
	IF Rlock()
		SELECT RMOV
		XsNroDoc = NroDoc
		IF EliItm = "ù"
			REPLACE IMPORT WITH 0
			REPLACE IMPUSA WITH 0
			REPLACE GLODOC WITH "**** ANULADO ***"
		ELSE
			SELE RMOV
			DELETE
		ENDIF
			DO ACT_RECEP WITH .F.
			UNLOCK
	ELSE
		ok = .f.
	ENDIF
	SKIP
ENDDO
SELECT VMOV
REPLACE NOTAST WITH "*** CHEQUE ANULADO ***"
REPLACE IMPCHQ WITH 0
REPLACE DBENAC WITH 0
REPLACE HBENAC WITH 0
REPLACE DBEUSA WITH 0
REPLACE HBEUSA WITH 0
IF Ok
	REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
	REPLACE FlgEst WITH " "    && Marca de anulado
	*DELETE
ENDIF
UNLOCK ALL
RETURN
************************************************************************** FIN
* Procedimiento de Grabar las variables de cabezera
******************************************************************************
PROCEDURE MOVGraba

IF UltTecla = Escape
	RETURN
ENDIF
DO LIB_MSGS WITH 3
SELECT VMOV
UltTecla = 0
LLAVE = (XsNroMes + XsCodOpe + XsNroAst)
IF Crear                  && Creando
	SELE OPER
	IF ! Rec_Lock(5)
		UltTecla = Escape
		RETURN              && No pudo bloquear registro
	ENDIF
	SELECT VMOV
	SEEK LLAVE
	IF FOUND()
		XsNroAst = NROAST()
		LLAVE = (XsNroMes + XsCodOpe + XsNroAst)
		SEEK LLAVE
		IF FOUND()
			DO LIB_MERR WITH 11
			UltTecla = Escape
			RETURN
		ENDIF
		@ 1,68 SAY XsNroAst
	ENDIF
	APPEND BLANK
	IF ! Rec_Lock(5)
		UltTecla = Escape
		RETURN              && No pudo bloquear registro
	ENDIF
	REPLACE VMOV->NROMES WITH XsNroMes
	REPLACE VMOV->CodOpe WITH XsCodOpe
	REPLACE VMOV->NroAst WITH XsNroAst
	SELECT OPER
	=NROAST(XsNroAst)
	SELECT CTAS
	SEEK XsCtaCja
ELSE
	SEEK LLAVE
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH XdFchAst
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
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0

REPLACE VMOV->Auxil   WITH XsAuxil
**** Anulando movimientos anteriores ****
SELECT RMOV
SEEK LLAVE
DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
	IF Rec_LOCK(5)
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
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
	XcEliItm = CHR(255)
	XdFchVto = {,,}
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
		DO MovbVeri
	ENDIF
ENDFOR

***** ACTUALIZANDO 2da VENTANA *****
FOR NumEle = 1 TO Maxele3
	=SEEK(vCodCta(NumEle),"CTAS")
	XcTpoMov = vTpoMov(NumEle)
	IF XnCodMon = 1
		XfImport = vImpCta(NumEle)
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = vImpCta(NumEle)
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	XsCodCta = vCodCta(NumEle)
	XsNroRef = ""
	XsClfAux = CTAS->CLFAUX
	XsCodAux = vCodAux(NumEle)
	XsCodRef = ""
	XsGloDoc = vGloDoc(NumEle)
	XsCodDoc = ""
	XsNroDoc = vNroRef(NumEle)
	XcEliItm = "@"    && << OJO <<
	XiCodMon = XnCodMon
*	XsCodAdd = vCodAdd(NumEle)
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
*	DO GRBRMOV
	DO MovbVeri
ENDFOR

***** ACTUALIZANDO 3da VENTANA *****
FOR NumEle = 1 TO Maxele2
	XcTpoMov = "H"
	IF XnCodMon = 1
		XfImport = aImport(NumEle)
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = aImport(NumEle)
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	=SEEK(aTpoAst(NumEle),'PROV')
	XsCodCta = LEFT(PROV->CodCta,LEN(RMOV->CodCta))
	=SEEK(XsCodCta,"CTAS")
	XsNroRef = []
	XsClfAux = CTAS->CLFAUX
	XsCodAux = XsAuxil
	XsCodRef = []
	XsGloDoc = aNotAst(NumEle)
	XsCodDoc = aTpoAst(NumEle)
	XsNroDoc = aNroAst(NumEle)
	XiCodMon = XnCodMon
	XcEliItm = "›"
	XdFchVto = aFchVto(NumEle)
	*Datos Nuevos Finanzas
	*
	IF VAL(XsNroDoc)>=OPER->NroDoc
		REPLACE OPER->NroDoc WITH VAL(XsNroDoc)+1
	ENDIF
	*IF CTAS->AftDcb = "S"
	*   DO DIFCMB
	*ELSE
	DO GRBRMOV
	*ENDIF
	DO ACT_RECEP WITH .T.
ENDFOR

SELECT VMOV
REPLACE VMOV->NROITM  WITH XiNroitm
@ 24,0
UNLOCK ALL
RETURN
******************************************************************************
* Objeto : Verificar si debe generar cuentas autom ticas
******************************************************************************
PROCEDURE MovbVeri

**** Grabando la linea activa ****
DO GRBRMOV
* cocina *
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
	RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
XcEliItm = "ú"
TsClfAux = []
TsCodAux = []
TsAn1Cta = CTAS->An1Cta
TsCC1Cta = CTAS->CC1Cta
** Verificamos su existencia **
IF EMPTY(TsAn1Cta) AND EMPTY(TsAn1Cta)
	TsClfAux = "04 "
	TsCodAux = CTAS->TpoGto
	TsAn1Cta = RMOV->CodAux
	TsCC1Cta = CTAS->CC1Cta
	TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
	** Verificamos su existencia **
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
	ENDIF
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
	GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
	DO LIB_MERR WITH 99
	RETURN
ENDIF
Crear = .T.
** Grabando la primera cuenta autom tica **
IF Crear
	XiNroItm = XiNroItm + 1
ELSE
	XiNroItm = NroItm
ENDIF
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO GRBRMOV
Crear = .T.
** Grabando la segunda cuenta autom tica **
IF Crear
	XiNroItm = XiNroItm + 1
ELSE
	XiNroItm = NroItm
ENDIF
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO GRBRMOV

RETURN
**********************************************************************
PROCEDURE GRBRMOV
*****************

SELECT RMOV
APPEND BLANK
XiNroItm = XiNroItm + 1
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
	IF CTAS->MAYAUX = "S"
		XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
	ENDIF
ENDIF
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

REPLACE RMOV->FchVto WITH XdFchVto
**DATOS ADICIONALES DE FINANZAS
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
IF RMOV->TpoMov = 'D'
	REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
	REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
ELSE
	REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
	REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
ENDIF

RETURN
******************************************************************************
* Objeto : Procedure Imprime Voucher
******************************************************************************
PROCEDURE MovPrint
******************

SELE RMOV
SET ORDER TO RMOV01
SEEK VMOV->NroMes+VMOV->CodOPe+VMOV->NroAst
xFOR = []
xWHILE = [NroMes+CodOpe+NroAst=VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst]
SET MEMO TO 80
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "cjacjlet"
DO admprint WITH "REPORTS"

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
*** Verificando la cancelaci¢n del documento ***
oK = .T.
IF xCodMon(NumEle) = 1  && ERROR
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
XcEliItm = "ð"
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
	DO movbveri
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
	DO movbveri
ENDIF
RETURN

** RUTINA ADICIONAL PEDIDA POR LA SRTA. ROSA (CAJA) 07/09/94 **
******************
PROCEDURE VOUCHER3
******************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENblin3"
EdiLin   = "GENbedi3"
BrrLin   = "GENbbor3"
InsLin   = "GENbins3"
Yo       = 11
Largo    = 5
Ancho    = 80
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle3
TotEle   = 20     && M ximos elementos a usar
DO ABROWSE
MaxEle3 = MaxEle
IF MaxEle3 = 1 .AND. EMPTY(vCodCta(1))
   MaxEle3 = 0
   @ 12,01 CLEAR TO 14,78
ENDIF
@ 12,01 Fill TO 14,78 COLOR SCHEME 1
RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENblin3
PARAMETERS NumEle, NumLin

=SEEK(vCodCta(NumEle),"CTAS")
*=SEEK([CJ]+vCodAdd(NumEle),"TABL")
@ NumLin,2  SAY vCodCta(NumEle)
@ NumLin,11 SAY vGloDoc(NumEle) PICT "@S24"
@ NumLin,36 SAY vCodAux(NumEle)
@ NumLin,46 SAY vNroRef(NumEle)
*@ NumLin,55 SAY vCodAdd(NumEle)
@ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,64 SAY vImpCta(NumEle) PICT "999,999,999.99"
@ NumLin,78 SAY IIF(vTpoMov(NumEle) = "D"," ","-")
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedi3
PARAMETERS NumEle, NumLin, LiUtecla

LsCodCta = vCodCta(NumEle)
LsGloDoc = vGloDoc(NumEle)
LsCodAux = vCodAux(NumEle)
LcTpoMov = vTpoMov(NumEle)
LsNroRef = vNroRef(NumEle)
LfImpCta = vImpCta(NumEle)
*LsCodAdd = vCodAdd(NumEle)
UltTecla = 0
i = 1
LinAct = NumLin
LinCta = 2
LinNom = 11
LinAux = 37
LinRef = 46
LinEst = 55
LinImp = 64
i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELECT CTAS
         @ LinAct,LinCta GET LsCodCta PICT REPLICATE("9",LEN(LsCodCta))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = Arriba
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
            UltTecla = Escape
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
         @ LinAct,LinCta SAY LsCodCta
         IF CTAS->AFTMOV#"S"
            GsMsgErr = "Cuenta no Afecta a movimiento"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
        * @ LinAct,LinNom SAY CTAS->NomCta PICT "@S29"
         @23,14 SAY CTAS->NomCta
         LcTpoMov = CTAS->CtaCja

      CASE i = 2
         @ LinAct,LinNom GET LsGloDoc PICT "@S25"
         READ
         UltTecla = LASTKEY()

      CASE i = 3
         IF CTAS->PIDAUX="S"
            XsClfAux = CTAS->ClfAux
            = SEEK("01"+XsClfAux,"TABL")
            iDigitos = TABL->Digitos
            IF iDigitos < 0 .OR. iDigitos > LEN(LsCodAux)
               iDigitos = LEN(LsCodAux)
            ENDIF
            SELECT AUXI
            IF XsClfAux = "01 "
               LsCodAux = XsAuxil
            ENDIF
            @ LinAct,LinAux GET LsCodAux PICT REPLICATE("9",iDigitos)
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
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
               @ 21,14 SAY XsCodAux
               @ 21,24 SAY AUXI->NomAux PICT "@S50"
            ENDIF
         ELSE
            LsCodAux = SPACE(LEN(RMOV->CodAUX))
         ENDIF

      CASE i = 4
         IF CTAS->PidDoc="S"
            @ LinAct,LinRef GET LsNroRef PICT "@!"
            READ
            UltTecla = LASTKEY()
         ELSE
            LsNroRef = SPACE(LEN(RMOV->NroDoc))
         ENDIF
         @ LinAct,LinRef SAY LsNroRef PICT "@!"

      CASE i = 5
    *    SELE TABL
    *    XsTabla = [CJ]
    *    @ NumLin,LinEst GET LsCodAdd PICT "@!"
    *    READ
    *    UltTecla = LASTKEY()
    *    IF INLIST(UltTecla,Escape,Izquierda)
    *       i = i - 1
    *       LOOP
    *    ENDIF
    *    IF UltTecla = F8
    *       IF !cbdbusca("TABL")
    *          LOOP
    *       ENDIF
    *       LsCodAdd = TABL->Codigo
    *    ENDIF
    *    @ NumLin,LinEst SAY LsCodAdd
    *    IF !EMPTY(LsCodAdd)
    *       SEEK XsTabla+LsCodAdd
    *       IF !FOUND()
    *          DO lib_merr WITH 6
    *          LOOP
    *       ENDIF
    *    ENDIF
    *    @23,13 SAY TABL->NOMBRE

      CASE i = 6
         IF LfImpCta<=0
            LfImpCta = ROUND(XfImpCh1,2)
         ENDIF
         @ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
         @ LinAct,LinImp GET LfImpCta PICT "999,999,999.99" VALID LfImpCta > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,LinImp SAY LfImpCta PICT "999,999,999.99"

      CASE i = 7
         ZcTpoMov = IIF(LcTpoMov = "D"," ","-")
         @ LinAct,78     GET ZcTpoMov PICT "!" VALID ZcTpoMov$" -"
         READ
         UltTecla = LASTKEY()
         LcTpoMov = IIF(ZcTpoMov = "-","H","D")
         @ LinAct,78     SAY IIF(LcTpoMov = "D"," ","-")

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
IF UltTecla <> Escape
   vCodCta(NumEle) = LsCodCta
   vGloDoc(NumEle) = LsGloDoc
   vTpoMov(NumEle) = LcTpoMov
   vCodAux(NumEle) = LsCodAux
   vNroRef(NumEle) = LsNroRef
   vImpCta(NumEle) = LfImpCta
*   vCodAdd(NumEle) = LsCodAdd
ENDIF
XfImpCh3 = 0
FOR ii = 1 to MaxEle
    XfImpCh3 = XfImpCh3 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh3
@ 15 ,64 SAY XfImpCh3 PICT "999,999,999.99" COLOR SCHEME 7
LiUtecla = UltTecla
@23,13
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbbor3
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   vCodCta(i) = vCodCta(i+1)
   vGloDoc(i) = vGloDoc(i+1)
   vCodAux(i) = vCodAux(i+1)
   vNroRef(i) = vNroRef(i+1)
   vTpoMov(i) = vTpoMov(i+1)
   vImpCta(i) = vImpCta(i+1)
*   vCodAdd(i) = vCodAdd(i+1)
   i = i + 1
ENDDO
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vGloDoc(i) = SPACE(LEN(RMOV->GloDoc))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vTpoMov(i) = " "
vImpCta(i) = 0
*vCodAdd(i) = SPACE(LEN(TABL->Codigo))
Estado = .T.
RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbins3
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vCodCta(i) = vCodCta(i-1)
   vGloDoc(i) = vGloDoc(i-1)
   vCodAux(i) = vCodAux(i-1)
   vNroRef(i) = vNroRef(i-1)
   vTpoMov(i) = vTpoMov(i+1)
   vImpCta(i) = vImpCta(i-1)
*   vCodAdd(i) = vCodAdd(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vGloDoc(i) = SPACE(LEN(RMOV->GloDoc))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroRef))
vTpoMov(i) = " "
vImpCta(i) = 0
*vCodAdd(i) = SPACE(LEN(TABL->Codigo))
Estado = .T.
RETURN
*******************
PROCEDURE ACT_RECEP
*******************
parameter Act
RETURN
