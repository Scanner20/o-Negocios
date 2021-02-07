***********************************************************************
*  Nombre        : CJAC2MOV.prg
*  Sistema       : Caja Bancos
*  Autor         : VETT
*  Proposito     : Caja Egresos  ( Giro de Cheques )
*  Creacion      : 17/06/93
***********************************************************************
DIMENSION vTpoAst(20),vNroAst(20),vNotAst(20),vImport(20)
DIMENSION xCodCta(20),xCodMon(20),xNroRef(20),xCodAux(20),xCodOpe(20),xCodDiv(20)
DIMENSION vCodCta(20),vCodAux(20),vNroRef(20),vImpCta(20),vTpoMov(20),vCodDoc(20),vCodDiv(20)
* * * *
TsCodDiv1= [01]
K_ESC    = 27
XsCodOpe = "020"     && Caja Egresos
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
store "" to xscjadiv, xscoddiv,xsclfaux
*
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XiNroVou,XsGloAst,XsCaux
STORE "" TO XsCtaCja,XSCODFIN,XfImpChq,XsNroChq,XsGirado,XsCodAux,XsNomAux,XsAuxil,XsCodDo1
STORE 0  TO XfImpCh1,XfImpCh2
XdFchAst = DATE()
XdFchPed = XdFchAst
XdFchEnt = XdFchAst
XfTpoCmb = 1.00
NroOpc   = 0
*
PATHAPL1 = [\belcsoft\CIA001\]
*

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
XsProgra = SPACE(5)

DO MOVgPant
DO MOVApert
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
*  SELECT OPER
*  SEEK XsCodOpe
*  IF ! FOUND()
*     GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
*     DO LIB_MERR WITH 99
*     CLOSE DATA
*     RETURN
*  ENDIF
* * * *
LsClfAux = []
LsCodAux = []
UltTecla = 0
DO WHILE (.t.)
   *-----
   RESTORE SCREEN FROM ScrMov
   SELE OPER
   *----- Control de Egresos de Caja ----* vett 12-abr-2000
   SELE OPER
   SET FILTER TO MOVCJA=2
   GO TOP
   XsCodOpe=CodOpe
   ****

   @ 2,2  SAY "OPERACION: "
   @ 2,12 GET XsCodOpe
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape
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
   *
   *
   SEEK XsCodOpe
   IF !FOUND()
      GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
      DO LIB_MERR WITH 99
      LOOP
   ENDIF
   @ 2,12 SAY XsCodOpe+" "+LEFT(OPER->NomOpe,20)
   *-----
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
         IF ! Modificar
            GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
            DO LIB_MERR WITH 99
            LOOP
         ENDIF
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
         ENDIF
         DO MOVEdita
         IF UltTecla <> Escape
            DO MOVGraba
            IF UltTecla <> Escape
               *
               @ 10,28 CLEAR TO 14,59
               @ 10,28 TO 14,59
               xElige = 3
               VECOPC(1) = " ******** VOUCHER ********* "
               VECOPC(2) = " ********* CARTAS ********* "
               VECOPC(3) = " ***** CHEQUE-VOUCHER ***** "
               *xElige = Elige(xElige,2,2,2)
               xElige = Elige(xElige,12,30,3)
               IF LASTKEY() <> Escape
                  IF xElige=2
   					 XnMn_Cart=XnCodMon
                  	 DO Cjas2mov.spr
                  ENDIF
                  IF XELIGE=1 OR XELIGE=2
                      DO DIRPRINT &&IN ADMPRINT
                  ENDIF
                  DO CASE
					CASE XElige = 1
						DO MovPrin1
					CASE XElige = 2
						DO MovPrin2
					CASE XElige = 3
						DO MovPrin3
				  ENDCASE
               ENDIF
              *DO DIRPRINT IN ADMPRINT
              *IF LASTKEY() # Escape
              *   DO MovPrint
              *ENDIF
               SET DEVICE TO SCREEN
            ENDIF
         ENDIF
   ENDCASE
   UNLOCK ALL
ENDDO
CLOSE DATA
CLOSE PROCEDURE
RETURN

******************
PROCEDURE IMPRIMIR
******************
DO DIRPRINT &&IN ADMPRINT
IF LASTKEY() # Escape
DO MovPrint
ENDIF
SET DEVICE TO SCREEN
RETURN
************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
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
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF

SELE 4
USE cbdrmovm ORDER rmov01   ALIAS RMOV
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELE 5
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF
SELE 6
USE cbdtoper ORDER oper01   ALIAS OPER
IF ! USED(6)
   CLOSE DATA
   RETURN
ENDIF
SELE 7
USE cbdacmct ORDER acct01   ALIAS ACCT
IF ! USED(7)
   CLOSE DATA
   RETURN
ENDIF
SELE 8
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF ! USED(8)
   CLOSE DATA
   RETURN
ENDIF
SELE 9
USE CJATPROV ORDER prov01   ALIAS PROV
IF ! USED(9)
   CLOSE DATA
   RETURN
ENDIF
SET FILTER TO TIPO<>"C"  && NO CUENTAS POR COBRAR *******************
*
lopDIAF=.f.
lexiste=.t.
SELE 0
m.file1=pathdef+"\cia"+gscodcia+"\flcjtbdf.dbf"
IF !FILE(m.file1)
	m.file1="\"+M.DIR_SIST2+"\cia"+gscodcia+"\flcjtbdf.dbf"	
	IF !FILE(m.file1)
		m.file1="\"+M.DIR_SIST3+"\cia"+gscodcia+"\flcjtbdf.dbf"	
		IF !FILE(m.file1)
			lexiste=.f.
		endif		
 	ENDIF
ENDIF
**
if lexiste
	sele 0
	use (m.file1) order diaf01 alias diaf
	if !used()
	   close data
	   return
	endif
	lopDIAF=.t.
endif

*
*ArcDbf = PATHapl1+[flcjdocp]
*sele 11
*use (ArcDbf) order ddoc05 alias docs
*if !used(11)
*    close data
*    return
*endif
*
SELECT RMOV
RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY PADC("* VOUCHER DE EGRESOS *",38) COLOR SCHEME 7
@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 6,79
@ 1,50 SAY "N§ COMPROBANTE.:"
@ 2,50 SAY "N§ RELACION....:"
@ 3,50 SAY "FECHA..........:"
@ 3,00 SAY "CUENTA..:"
@ 5,00 SAY "TD.:     N§:"
@ 6,00 SAY "FCH. DE ENT.:" && NUEVO
@ 6,25 SAY [DIV.:]
@ 5,30 SAY "AUXIL.:"
@ 4,50 SAY "T/CAMBIO.......:"
@ 5,50 SAY "FCH.DE FINANZAS:"
@ 7,00 TO 11,79
@ 7,01 SAY "ð Tipo ð N§  PROV.ð         C O N C E P T O                ð         IMPORTE ð" COLOR SCHEME 7

@ 12,00 TO 17,79
*@12,01 SAY "ðCTAS.ð      C O N C E P T O       ð AUXI.ð TD.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
@ 12,01 SAY "DV -CTAS.-   C O N C E P T O       ð AUXI.ð TD.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
*
@ 18,00 SAY "IMPORTE....:"
@ 19,00 SAY "GIRADO A...:"
@ 20,00 SAY "CONCEPTO...:"
@ 21,00 SAY "PROVEEDOR..:"
SAVE SCREEN TO SCRMOV
RETURN

************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
i = 1
XsNroAst = NROAST()
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
DO WHILE ! INLIST(UltTecla,Enter,Escape)
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
                  DO LIB_MERR WITH 14
                  UltTecla = 0
                  @ 10,28 CLEAR TO 14,59
                  @ 10,28 TO 14,59
                  XELIGE = 3
                  VECOPC(1) = " ******** VOUCHER ********* "
                  VECOPC(2) = " ********* CARTAS ********* "
                  VECOPC(3) = " ***** CHEQUE-VOUCHER ***** "
                  *XELIGE = ELIGE(XELIGE,2,2,2)
                  XELIGE = ELIGE(XELIGE,12,50,3)
                  IF LASTKEY() <> ESCAPE
                     DO DIRPRINT &&IN ADMPRINT
                     IF XELIGE = 1
                        DO MOVPRIN1
                     ELSE
                     	IF XELIGE=2
	                        DO MOVPRIN2
	                    ELSE
	                        DO MOVPRIN3
                        ENDIF
                     ENDIF
                  ENDIF
                 *DO DIRPRINT IN ADMPRINT
                 *IF LASTKEY() # Escape
                 *   DO MovPrint
                 *ENDIF
                  SET DEVICE TO SCREEN
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
XnCodMon = 1
XsProgra = SPACE(LEN(VMOV->PROGRA))
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
*
xscjadiv = space(len(rmov->coddiv))
*
**XSCODFIN = SPACE(LEN(RMOV->CODFIN))
XiNroVou = OPER->NroRel
XfImpChq = 0
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = SPACE(LEN(VMOV->NroChq))
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsAuxil  = Auxil
XsNomAux = SPACE(LEN(AUXI->NomAux))
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVMover
XnCodMon = VMOV->CodMon
XsProgra = VMOV->PROGRA
XsNotAst = VMOV->NOTAST
XsGirado = VMOV->Girado
XsGloAst = VMOV->GloAst
XdFchAst = VMOV->FchAst
XdFchPed = VMOV->FchPed
XdFchEnt = VMOV->FchEnt && NUEVO
XsDigita = GsUsuario
XsCtaCja = CtaCja
**XSCODFIN = CODFIN
XiNroVou = VAL(NroVou)
XfImpChq = ImpChq
XfImpCh1 = 0
XfImpCh2 = 0
XsNroChq = VMOV->NroChq
XfTpoCmb = VMOV->TpoCmb
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsNomAux = SPACE(LEN(AUXI->NomAux))
XsAuxil  = Auxil
*
* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS
*
xscjadiv = space(len(rmov.coddiv))
sele rmov
set order to rmov07
seek (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
if found()
   xscjadiv = rmov.coddiv
endif
set order to rmov01
sele vmov
*
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
*
* VERIFICA DIVISIONARIA DE LA CUENTA CAJA BANCOS
*
xscjadiv = space(len(rmov.coddiv))
sele rmov
set order to rmov07
seek (vmov.nromes+vmov.codope+vmov.nroast+vmov.ctacja)
if found()
   xscjadiv = rmov.coddiv
endif
set order to rmov01
sele vmov
*
@06,30 say xscjadiv
@06,33 say iif(seek([DV ]+xscjadiv,[auxi]),left(auxi.nomaux,7),space(07))
*
=SEEK(CtaCja,"CTAS")
@ 01,68 SAY NroAst
IF CtaCja = "104"
   @ 02,2  SAY " ****** CUENTAS CORRIENTES ******* "
ELSE
   @ 02,2  SAY " ****** CUENTAS DE AHORRO ******** "
ENDIF
@ 02,68 SAY NroVou
@ 03,68 SAY FchAst
@ 05,68 SAY FchPed
@ 03,10 SAY CtaCja+" "+CTAS->NomCta pict "@S38"
@ 04,00 SAY "N§CUENTA: "+SUBSTR(CTAS->NroCta,1,15)
***@ 04,10 SAY "N§ CUENTA : "+CTAS->NroCta+" "+CTAS->RefBco
**@ 04,26 SAY "N§Fin: "+VMOV->CODFIN
@ 05,12 SAY NroChq
@ 06,13 SAY VMOV.FCHENT
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
@ 13,01 CLEAR TO 16,78
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
@ 21,14 SAY SPACE(LEN(RMOV->CodAux))
@ 21,22 SAY SPACE(50)
Ancho    = 74
Xo       = INT((80 - Ancho)/2)
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
   DO CASE
     *CASE EliItm = CHR(255)
      CASE EliItm = CHR(43)      
         IF MaxEle1 >= 20
            SKIP
            LOOP
         ENDIF
         XfImport = IIF(TpoMov="D",1,-1)*Import
         XfImpUsa = IIF(TpoMov="D",1,-1)*ImpUsa
         IF EMPTY(XsCodAux)
            XsCodAux = CodAux
            XsClfAux = ClfAux
            @ 21,14 SAY XsCodAux
            =SEEK(XsClfAux+XsCodAux,"AUXI")
            XsNomAux = AUXI->NomAux
            @ 21,22 SAY AUXI->NomAux PICT "@S45"
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

         IF VMOV->CodMon = 1
            vImport(MaxEle1) = XfImport
         ELSE
            vImport(MaxEle1) = XfImpUsa
         ENDIF
         IF LinAct1 < 11
            DO GENbline WITH MaxEle1, LinAct1
            LinAct1 = LinAct1 + 1
         ENDIF
     *CASE EliItm = "ð" .AND. MaxEle1 > 0
      CASE EliItm = "-" .AND. MaxEle1 > 0     
         IF MaxEle1 >= 20
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


     *CASE ! INLIST(EliItm,"ù","ú")
      CASE ! INLIST(EliItm,".","*")     
         IF MaxEle2 >= 20
            SKIP
            LOOP
         ENDIF
         MaxEle2 = MaxEle2 + 1
         =SEEK(CodCta,"CTAS")
         vCodCta(MaxEle2) = CodCta
         IF EMPTY(XsCodAux) .AND. CTAS->PIDAUX="S"
            XsCodAux = CodAux
            XsClfAux=  ClfAux
            @ 21,14 SAY XsCodAux
            XsNomAux = AUXI->NomAux
            =SEEK(XsClfAux+XsCodAux,"AUXI")
            @ 21,22 SAY AUXI->NomAux PICT "@S50"
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
         IF LinAct2 < 17
            DO GENblin2 WITH MaxEle2, LinAct2

            LinAct2 = LinAct2 + 1
         ENDIF
     *CASE INLIST(EliItm,"ù")
      CASE INLIST(EliItm,".")     
         XsCodDo1 = RMOV->CodDoc
         @ 5,04 SAY XsCodDo1
   ENDCASE
   SELECT RMOV
   SKIP
ENDDO
XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAux))
SELECT VMOV
@ 18 ,18 SAY VMOV->ImpChq PICT "99,999,999,999.99"
@ 19 ,14 SAY VMOV->Girado
@ 20 ,14 SAY VMOV->NotAst
@ 22 ,14 SAY "OPERACION CONTABLE : "+VMOV->CODOPE
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
IF Crear
   IF ! (YEAR(DATE()) = _Ano .AND. MONTH(DATE()) = _Mes)
      IF ! ALRT("Fecha no corresponde al mes de Trabajo")
         UltTecla = Escape
         RETURN
      ENDIF
   ENDIF
ENDIF
UltTecla = 0
I        = 1
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
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
         @ 3,68 GET XdFchAst
         READ
         UltTecla = LastKey()
         @ 3,68 SAY XdFchAst
      CASE I = 4
         IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
            ?? CHR(7)
            WAIT "No Registrado el tipo de Cambio" NOWAIT WINDOW
         ENDIF
         IF CREAR
            XfTpoCmb = iif(OPER->TpoCmb=1,TCMB->OFICMP,TCMB->OFIVTA)
         ENDIF
         @ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
         READ
         UltTecla = LastKey()
         @ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
         IF UltTecla = Escape
            EXIT
         ENDIF
      CASE I = 5
         @ 5 ,68 GET XdFchPed
         READ
         UltTecla = LastKey()
         *
         if inlist(xscodope,[021],[038],[020],[036]) && LETRAS
            sele diaf
            seek dtos(XdFchPed)
            if found()
               XdFchPed = FchVen
            endif
         endif
         *
         @ 5 ,68 SAY XdFchPed
      CASE I = 6
         DO CASE
            CASE XsCtaCja = "104"
                 xElige = 1
            CASE XsCtaCja = "108"
                 xElige = 2
            OTHER
                 xElige = 3
         ENDCASE
         VECOPC(1) = " ***** CUENTAS CORRIENTES ******** "
         VECOPC(2) = " ***** CUENTAS DE AHORRO  ******** "
         VECOPC(3) = " *****    OTRAS CUENTAS   ******** "
         xElige = Elige(xElige,2,2,2)
         DO CASE
            CASE XElige  = 1
                 cCodCta = "104"
            CASE XElige  = 2
                 cCodCta = "108"
            CASE XElige  = 3
                 cCodCta = "10"
         ENDCASE
      CASE I = 7
         SELECT CTAS
         IF xElige<=2
            zCodCta = SUBSTR(XsCtaCja,4)
            @ 03,10 SAY cCodCta
            @ 03,13 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-3)
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
               EXIT
            ENDIF
            XsCtaCja = cCodCta+zCodCta
         ELSE
            zCodCta = SUBSTR(XsCtaCja,3)
            @ 03,10 SAY cCodCta
            @ 03,12 GET zCodCta PICTURE REPLICATE("9",LEN(XsCtaCja)-2)
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
               EXIT
            ENDIF
            XsCtaCja = cCodCta+zCodCta
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
    *****@ 04,10 SAY "N§ CUENTA : "+NroCta+" "+RefBco
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
            XsCodDo1 = "CHQ"
         ENDIF
         @ 05,04 SAY XsCodDo1
         @ 05,12 SAY XsNroChq
         @ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
   ** CASE I = 8
   **    SELECT AUXI
   **    XSCLFAUX  = "99 "
   **    @ 04,33 SAY "             "
   **    @ 04,26 SAY "N§Fin:"
   **    @ 04,33 GET XSCODFIN PICT "@!"
   **    READ
   **    UltTecla = LASTKEY()
   **    IF UltTecla = Escape
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
            GsMsgErr = "C¢digo de documento inv lido"
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

      CASE I = 11
         @ 6,13 GET XdFchEnt
         READ
         UltTecla = LastKey()
         @ 6,13 SAY XdFchEnt
         
      CASE I = 12
         IF CTAS->PIDAUX="S"
            XsClfAux=CTAS->ClfAux
            SELE AUXI
            @ 05,38 GET XsAuxil  PICT "@!"
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
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
         
      CASE I = 13   &&& PIDE DIVISIONARIA
         SELE AUXI
         @ 06,30 GET XsCjaDiv PICT "XX"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
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
      CASE I = 14
         DO COMPROBAN
         XfImpCh1 = 0
         FOR ii = 1 to MaxEle1
             XfImpCh1 = XfImpCh1 + vImport(ii)
         ENDFOR
         XfImpChq = XfImpCh1 + XfImpCh2
         @ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"
         IF LASTKEY() = Escape
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
         IF LASTKEY() = Escape
            UltTecla = Arriba
         ELSE
            UltTecla = Enter
         ENDIF
         IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
            XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
            XsGirado = PADR("*** CHEQUE ANULADO ***",LEN(XsGirado))
            @ 19, 14 SAY XsGirado PICT "@!"
            @ 20, 14 SAY XsNotAst PICT "@!"
         ENDIF

      CASE I = 16
         @ 19, 14 GET XsGirado PICT "@!"
         READ
         UltTecla = LastKey()
         @ 19, 14 SAY XsGirado PICT "@!"

      CASE I = 17
         IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
            XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
         ENDIF
         @ 20, 14 GET XsNotAst PICT "@!"
         READ
         UltTecla = LastKey()
         @ 20, 14 SAY XsNotAst PICT "@!"

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
         IF UltTecla = BackTab .OR. UltTecla = Escape
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
TotEle   = 20     && M ximos elementos a usar
DO ABROWSE
MaxEle1 = MaxEle
@ 11,1   TO 11,78
IF MaxEle1 = 1 .AND. EMPTY(LEFT(vNroAst(1),6))
   MaxEle1 = 0
   @ 8,01 CLEAR TO 10,78
ENDIF
@ 8,01 Fill TO 10,78 COLOR SCHEME 1
IF LASTKEY() = Escape
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
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
   DO CASE
      CASE i = 1
         SELECT PROV
         @ NumLin,3   GET LsTpoAst PICT "@!"
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
         @ NumLin,3   SAY LsTpoAst PICT "@!"
         SEEK LsTpoAst
         IF ! FOUND()
            GsMsgErr = "** COD. DOCUMENTO NO REGISTRADO **"
            DO LIB_Merr WITH 99
            UltTecla = 0
            LOOP
         ENDIF

      CASE i = 2
         IF PROV->TIPO$"AM" .and. EMPTY(SUBSTR(LsNroAst,8,2))
            LsNroAst = SUBSTR(LsNroAst,1,8)+"-"+STR(_ANO,4)+" "
            **LsNroAst = PADR(LsNroAst,LEN(RMOV.NroDoc))
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
XfImpChq = XfImpCh1 + XfImpCh2
@ 18 ,18 SAY XfImpChq PICT "99,999,999,999.99"

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
         IF CodOpe == PROV->CodOpe or (nromes=[00] and codope=[000])
            *        
            xcoddiv(numele) = coddiv
            *
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
         *
         xcoddiv(numele) = coddiv
         *
         xCodCta(NumEle) = CodCta
         xCodMon(NumEle) = CodMon
         xNroRef(NumEle) = NroREf
         xCodAux(NumEle) = CodAux
         xCodOpe(NumEle) = CodOpe
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

SELECT VMOV

 IF ! Ok
    GsMsgErr = "*** Provisi¢n mal Registrada **"
    DO LIB_MERR WITH 99
    RETURN .F.
 ENDIF

IF EMPTY(XsCodAux) .OR. MaxEle = 1
   XsCodAux = LsCodAux
   =SEEK(LsClfAux+LsCodAux,"AUXI")
   @ 21,14 SAY LsCodAux
   @ 21,22 SAY AUXI->NomAux PICT "@S50"
ENDIF

IF EMPTY(XsNotAst) .OR. MaxEle = 1
   XsNotAst = LsNotAst
   @ 20,14 SAY XsNotAst
ENDIF
IF EMPTY(XsGirado) .OR. MaxEle = 1
   IF LsCodAux = "999"
      XsGirado = PADR(XsNomAux,LEN(XsGirado))
   ELSE
      =SEEK(LsClfAux+LsCodAux,"AUXI")
      XsGirado = PADR(AUXI->NomAux,LEN(XsGirado))
   ENDIF
   @ 19,14 SAY XsGirado PICT "@S50"
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
Ancho    = 80
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle2
TotEle   = 20     && M ximos elementos a usar
DO ABROWSE
MaxEle2 = MaxEle
@ 17,1   TO 17,78
IF MaxEle2 = 1 .AND. EMPTY(vCodCta(1))
   MaxEle2 = 0
   @ 13,01 CLEAR TO 16,78
ENDIF
@ 13,01 Fill TO 16,78 COLOR SCHEME 1
RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENblin2
PARAMETERS NumEle, NumLin

=SEEK(vCodCta(NumEle),"CTAS")
@ numlin,1  say vcoddiv(numele)
@ NumLin,4  SAY vCodCta(NumEle)
@ NumLin,13 SAY CTAS->NomCta PICT "@S21"
@ NumLin,37 SAY vCodAux(NumEle)
@ NumLin,44 SAY vCodDoc(NumEle)
@ NumLin,49 SAY vNroRef(NumEle)
@ NumLin,60 SAY IIF(XnCodMon=1,"S/.","US$")
@ NumLin,63 SAY vImpCta(NumEle) PICT "999,999,999.99"
@ NumLin,77 SAY IIF(vTpoMov(NumEle) = "D"," ","-")
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
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
   DO CASE
      case i = 1        && Divisionaria
         SELE AUXI
         @ LinAct,LinDiv GET lscoddiv PICT "XX"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
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
            UltTecla = Escape
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
         IF UltTecla = Escape
            LOOP
         ENDIF
        *IF UltTecla = Arriba
        *   LOOP
        *ENDIF
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
        *   UltTecla = Escape
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
         LcTpoMov = CTAS->CtaCja

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
               LsCodAux = XsCodAux
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
               @ 21,22 SAY AUXI->NomAux PICT "@S50"
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
         @ NumLin,60 SAY IIF(XnCodMon=1,"S/.","US$")
         @ LinAct,LinImp GET LfImpCta PICT "999,999,999.99" VALID LfImpCta > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,LinImp SAY LfImpCta PICT "999,999,999.99"

      CASE i = 7
         ZcTpoMov = IIF(LcTpoMov = "D"," ","-")
         @ LinAct,77     GET ZcTpoMov PICT "!" VALID ZcTpoMov$" -"
         READ
         UltTecla = LASTKEY()
         LcTpoMov = IIF(ZcTpoMov = "-","H","D")
         @ LinAct,77     SAY IIF(LcTpoMov = "D"," ","-")

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
   i = i + 1
ENDDO
vcoddiv(i) = space(len(rmov.coddiv))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vTpoMov(i) = "D"
vImpCta(i) = 0
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
IF LASTKEY() = Escape
   RETURN
ENDIF
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   UltTecla = Escape
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
     *IF EliItm = "ù"  .AND. m.remove = 2
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
   REPLACE PROGRA  WITH ""
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
  *DELETE
   REPLACE FlgEst WITH " "    && Marca de anulado
ELSE
   DO MOVPINTA
   @ 10,28 CLEAR TO 14,59
   @ 10,28 TO 14,59
   xElige = 1
   VECOPC(1) = " ******** VOUCHER ********* "
   VECOPC(2) = " ********* CARTAS ********* "
   VECOPC(3) = " ***** CHEQUE-VOUCHER ***** "
   *xElige = Elige(xElige,2,2,2)
   xElige = Elige(xElige,12,50,3)
   IF LASTKEY() <> Escape
      DO DIRPRINT &&IN ADMPRINT
      IF XElige = 1
         DO MovPrin1
      ELSE
	     IF XELIGE=2
	        DO MOVPRIN2
	     ELSE
	        DO MOVPRIN3
         ENDIF
      ENDIF
   ENDIF
  *DO DIRPRINT &&IN ADMPRINT
  *IF LASTKEY() # Escape
  *   DO MovPrint
  *ENDIF
   SET DEVICE TO SCREEN
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
   REPLACE VMOV->Progra WITH XsProgra
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
**PLACE VMOV->CODFIN  WITH XSCODFIN
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
  *XcEliItm = CHR(255)
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
*
xscoddiv = xscjadiv
*
=SEEK(XsCodCta,"CTAS")
XsNroRef = ""
XsClfAux = CTAS->ClfAux
XsCodAux = XsAuxil
XsCodRef = ""
XsGloDoc = XsNotAst
XsCodDoc = XsCodDo1
XsNroDoc = XsNroChq
*XcEliItm = "ù"
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
*
*** ACTUALIZANDO INFORMACION DE LETRAS PARA EL FLUJO DE CAJA PROYECTADO
*
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
      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
ELSE
   IF ! SEEK(TsAn1Cta,"CTAS")
      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   else
	   IF CTAS.CodCta==TsAn1Cta and ctas.mayaux="S"
	   		 IF CTAS.ClfAux=XsClfAux	
		         TsClfAux = XSCLFAUX
		         TsCodAux = XSCODAUX
    	     endif
	   endif
   endif	   
      
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
*****
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
**PLACE RMOV->CODFIN WITH XSCODFIN
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->Import WITH XfImport
REPLACE RMOV->ImpUsa WITH XfImpUsa
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->FchAst WITH XdFchAst
*REPLACE RMOV->FchVto WITH {,,}
REPLACE RMOV->FchVto WITH {  ,  ,    }
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
*
do case
   case rmov.codcta = [10]
        repla rmov.FchPed with XdFchPed
   case rmov.codcta = [423] .and. rmov.tpomov = [H] && Provisi¢n
        repla rmov.FchPed with rmov.fchvto
   case rmov.codcta = [423] .and. rmov.tpomov = [D] && Cancelaci¢n Letras
        repla rmov.FchPed with XdFchPed
   case rmov.codcta = [421] .and. rmov.tpomov = [D] && Cancelaci¢n Facturas
        repla rmov.FchPed with XdFchPed
   otherwise
       repla rmov.fchped with xdfchped     
endcase
*
replace rmov.fchdig with date()
replace rmov.hordig with time()
*
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa, coddiv
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
PROCEDURE MovPrin1
******************
NumPag   = 1
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SELECT RMOV
SEEK LsLLave
SET DEVICE TO PRINT
Largo  = 66
LinFin = Largo - 6
NumPag = 0
TfDebe = 0
TfHber = 0
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
   *IF Import = 0 .AND. EliItm = "ú"
   *IF Import = 0 .AND. EliItm = "*"   
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
   @ LinAct,15 SAY LsGloDoc    PICT "@S50"
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
@ LinAct+2,6  SAY "|      REVISADO       |      Vo.Bo.         |                                           |"
@ LinAct+3,6  SAY "+===========================================+ RECIBI CONFORME: .....................    |"
@ LinAct+4,6  SAY "|                     |                     | NOMBRE: ..............................    |"
@ LinAct+5,6  SAY "|                     |                     | L.E.  : ..............................    |"
@ LinAct+6,6  SAY "+===========================================+===========================================+"
EJECT PAGE

SELECT RMOV
RETURN
**********************************************************************
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
**********************************************************************
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
*** Verificando la cancelaci¢n del documento ***
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
*XcEliItm = "ð"
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
NumPag   = 1
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SELECT RMOV
SEEK LsLLave
SET DEVICE TO PRINT
Largo  = 66
LinFin = Largo - 8
NumPag = 0
TfDebe = 0
TfHber = 0
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
   *IF Import = 0 .AND. EliItm = "ú"
   *IF Import = 0 .AND. EliItm = "*"   
   IF Import = 0
      SKIP
      LOOP
   ENDIF
   DO ZINIPAG
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

   @ LinAct,0  SAY _PRN4
   *LinAct,15 SAY LsGloDoc    PICT "@S50"
   @ LinAct,0  SAY _PRN1
   *@ LinAct,39+3 SAY CodCta
   *@ LinAct,45+3 SAY NroDoc
   *@ LinAct,55+3 SAY NroRef
   IF TpoMov = "D"
    *  @ LinAct,65 SAY Import PICT "999,999,999.99"
      TfDebe = TfDebe + Import
   ELSE
    *  @ LinAct,80 SAY Import PICT "999,999,999.99"
      TfHber = TfHber + Import
   ENDIF
   SKIP
ENDDO
IF NumPag = 0
   DO ZINIPAG
ENDIF
IF PROW() > Largo - 10
   DO ZINIPAG with .t.
ENDIF
LinAct = PROW() + 1
LinAct = PROW() + 1
LinAct = PROW() + 1

LinAct = Largo - 15
EJECT PAGE

SELECT RMOV
RETURN
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
XsHoy='San Isidro, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
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

@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN1
*@  0,6  SAY _PRN7a+TRIM(GsNomCia)+_PRN7B
@ 12,60 SAY "N§ "+VMOV->CODOPE+"-"+VMOV->NroAst
@ 13,60 SAY "Relac. -"+SUBSTR(VMOV->NroVou,2,5)
@ 15,8  SAY XsHoy
@ 18,8  SAY "Se¤ores"
@ 19,8  SAY _prn6a+XsNomBan+_prn6b
@ 20,8  SAY "Presente.-"
@ 22,8  SAY "Attn.: "+dato1
@ 23,15 SAY "Funcionario de Negocios"
@ 25,8  SAY "Ref. :"
@ 25,15 SAY dato2
@ 26,15 SAY dato3
@ 29,8  SAY "De Nuestra Consideraci¢n:"
@ 32,8  SAY "Por medio de la presente, les  solicitamos efectuar"
@ 33,8  SAY "la operaci¢n de la referencia:"
@ 35,8  SAY "A la orden de     :"
@ 35,28 SAY _PRN6A+(VMOV->GIRADO)+_PRN6B
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

*******************
@ 40,8 SAY dato4
@ 41,8 SAY dato5
@ 43,8 SAY "Asimismo, agradeceremos cargar el importe solicitado"
@ 44,8 SAY "en nuestra cuenta corriente:"
@ 45,8 SAY _prn6a+PADR(CTAS->NOMCTA,45)+_prn6b
@ 47,8 SAY dato6
@ 48,8 SAY dato7
*
@ 49,8 say dato8
@ 50,8 say dato9
*
*@ 50,8 SAY "Agradeciendo la atenci¢n a la presente, quedamos de"
*@ 51,8 SAY "ustedes."
*@ 53,42 SAY "Atentamente,"
*
@ 52,8 SAY "Agradeciendo la atenci¢n a la presente, quedamos de"
@ 53,8 SAY "ustedes."
@ 54,42 SAY "Atentamente,"


IF NumPag > 1
   LinAct = PROW() + 1
  *@ LinAct,50 SAY "VIENEN..."
  *@ LinAct,63 SAY TfDebe PICT "999,999,999.99"
  *@ LinAct,78 SAY TfHber PICT "999,999,999.99"
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
SCAN WHILE 	NroMes+CodOpe+NroAst=LsLLave FOR EliItm#"*" && Sin Automaticas  
	if TpoMov="H" 
		IF THbe<10  && Solo hay espacio para diez lineas
			tHbe= THbe + 1
			vLinHbe(THbe)= CodCta+" "+TRAN(IIF(VMOV.CodMon=1,Import,ImpUSa),"99,999,999.99")
		ENDIF			
	else	
		IF TDbe<10  && Solo hay espacio para diez lineas
			tDbe= TDbe + 1
			vLinDbe(TDbe)= CodCta+" "+TRAN(IIF(VMOV.CodMon=1,Import,ImpUSa),"99,999,999.99")
		ENDIF			
	endif	
ENDSCAN
SEEK LsLLave
SNOMREP = "CJACHQVO"
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
XFOR   = [ELIITM#"*"]
XWHILE = [NROMES+CODOPE+NROAST=LsLlAVE]
DO F0PRINT WITH "REPORTS"