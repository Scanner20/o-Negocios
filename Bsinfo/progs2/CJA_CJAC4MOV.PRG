**********************************************************************
*  Nombre        : CJAC4MOV.prg
*  Sistema       : Caja Bancos
*  Autor         : Jorge Mieses
*  Proposito     : Provisi¢n de Caja chica
*  Creacion      : 17/06/93
***************************************************************************
DIMENSION vTpoAst(20),vNroAst(20),vNotAst(20),vImport(20)
DIMENSION xCodCta(20),xCodMon(20),xNroRef(20),xCodAux(20)
DIMENSION vCodCta(20),vCodAux(20),vNroRef(20),vImpCta(20),vTpoMov(20)
* * * *
XsCodOpe = "010"     && Caja Chica
XsCodOp1 = "003"     && Proveedores
* * * *
XsNroMes = TRANSF(_MES,"@L ##")
ZiCodMon = 1
ScrMov   = ""
MaxEle1  = 0
MaxEle2  = 0
Crear    = .T.
Modificar= .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XiNroVou,XsGloAst
STORE "" TO XsCtaCja,XfImpChq,XsGirado,XsCodAux,XsNomAux
STORE 0  TO XfImpCh1,XfImpCh2
XdFchAst = DATE()
XfTpoCmb = 1.00
NroOpc   = 0


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
IF ! USED(1)
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
               DO DIRPRINT IN ADMPRINT
               IF LASTKEY() # Escape
                  DO MovPrint
               ENDIF
               SET DEVICE TO SCREEN
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
SELECT 1
USE CBDTCIER
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
   GOTO RegAct
   IF  Cierre  .OR. CjaBco
      CLOSE DATA
      GsMsgErr = "*** Mes de Proceso Cerrado ***"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
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
SELECT RMOV

RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY PADC("* PROVISION DE CAJA CHICA *",38) COLOR SCHEME 7
@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 5,79
@ 1,50 SAY "N§ COMPROBANTE.:"
@ 3,50 SAY "FECHA..........:"
@ 2,00 SAY "CUENTA..:"
@ 4,50 SAY "T/CAMBIO.......:"
@ 6,00 TO 11,79
@ 6,01 SAY "ð Tipo ð N§  PROV.ð         C O N C E P T O                ð         IMPORTE ð" COLOR SCHEME 7

@ 12,00 TO 17,79
@ 12,01 SAY "ðCTAS.ð           C O N C E P T O        ðAUXI.ðN§  DOCTO.ð          IMPORTE ð" COLOR SCHEME 7
*
@ 18,00 SAY "IMPORTE....:"
@ 20,00 SAY "CONCEPTO...:"
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
XsNroChq = SPACE(LEN(VMOV->NroChq))
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsNomAux = SPACE(LEN(AUXI->NomAux))
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVMover
XnCodMon = VMOV->CodMon
XsNotAst = VMOV->NOTAST
XsGirado = SPACE(LEN(VMOV->Girado))
XsGloAst = VMOV->GloAst
XdFchAst = VMOV->FchAst
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
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
=SEEK(CtaCja,"CTAS")
@ 01,68 SAY NroAst
@ 02,68 SAY NroVou
@ 03,68 SAY FchAst
@ 02,10 SAY CtaCja+" "+CTAS->NomCta pict "@S38"
@ 4 ,68 SAY TpoCmb PICT "9999.9999"
IF VMOV->CodMon = 1
   XnCodMon = 1
   @ 18,14 say "S/. "
ELSE
   XnCodMon = 2
   @ 18,14 say "US$ "
ENDIF
@  7,01 CLEAR TO 10,78
@ 13,01 CLEAR TO 16,78
LinAct1 = 7
LinAct2 = 13
IF VMOV->FlgESt = "A"
   @ LinAct1,0 say []
   @ ROW()  ,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ ROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
   @ ROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ ROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ENDIF
**** Buscando Datos Ventana 1 ****
SELECT RMOV
LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
SEEK LsLLave
MaxEle1 = 0
MaxEle2 = 0
XsCodAux = ""
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

         IF VMOV->CodMon = 1
            vImport(MaxEle1) = XfImport
         ELSE
            vImport(MaxEle1) = XfImpUsa
         ENDIF
         IF LinAct1 < 11
            DO GENbline WITH MaxEle1, LinAct1
            LinAct1 = LinAct1 + 1
         ENDIF
      CASE EliItm = "ð" .AND. MaxEle1 > 0
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


      CASE ! INLIST(EliItm,"ù","ú")
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
            XsNomAux = AUXI->NomAux
            =SEEK(XsClfAux+XsCodAux,"AUXI")
         ENDIF
         vCodAux(MaxEle2) = CodAux
         vNroRef(MaxEle2) = NroDoc
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
   ENDCASE
   SELECT RMOV
   SKIP
ENDDO
XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAux))
SELECT VMOV
@ 18 ,18 SAY VMOV->ImpChq PICT "999,999.99"
@ 20 ,14 SAY VMOV->NotAst
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
* Procedimiento que edita las variables de cabezera
******************************************************************************
PROCEDURE MOVEdita
UltTecla = 0
I        = 1
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         @ 3,68 GET XdFchAst
         READ
         UltTecla = LastKey()
         @ 3,68 SAY XdFchAst
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
         SELECT CTAS
         XsCtaCja = "46901"
         SEEK XsCtaCja
         @ 02,10 SAY XsCtaCja+" "+NomCta pict "@S38"
         XsNroChq = PADR(XsNroAst+"-"+RIGHT(STR(_Ano,4,0),2),LEN(XsNroChq))
         XnCodMon = 1
         @ 18,14 say "S/. "

      CASE I = 7
         IF Crear .AND. MaxEle1 = 0
            GsMsgkey = " [Buscando Provisones para caja chica] "
            DO MOVBUSCA
         ENDIF
         DO COMPROBAN
         XfImpCh1 = 0
         FOR ii = 1 to MaxEle1
             XfImpCh1 = XfImpCh1 + vImport(ii)
         ENDFOR
         XfImpChq = XfImpCh1 + XfImpCh2
         @ 18 ,18 SAY XfImpChq PICT "999,999.99"
         IF LASTKEY() = Escape
            UltTecla = Arriba
         ELSE
            UltTecla = Enter
         ENDIF

      CASE I = 8
         DO VOUCHER
         XfImpCh2 = 0
         FOR ii = 1 to MaxEle2
             XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
         ENDFOR
         XfImpChq = XfImpCh1 + XfImpCh2
         @ 18 ,18 SAY XfImpChq PICT "999,999.99"
         IF LASTKEY() = Escape
            UltTecla = Arriba
         ELSE
            UltTecla = Enter
         ENDIF
         IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
            XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
            XsGirado = SPACE(LEN(VMOV->Girado))
            @ 20, 14 SAY XsNotAst PICT "@!"
         ENDIF

      CASE I = 11
         IF ( MAXELE1 = 0 .AND. MAXELE2 = 0 )
            XsNotAst = PADR("*** CHEQUE ANULADO ***",LEN(XsNotAst))
         ENDIF
         @ 20, 14 GET XsNotAst PICT "@!"
         READ
         UltTecla = LastKey()
         @ 20, 14 SAY XsNotAst PICT "@!"

      CASE I = 13
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
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>13,13, i)
   i = IIF(i<1, 1, i)

   IF INLIST(UltTecla,F10,CtrlW)
      IF XfImpChq < 0
         GsMsgErr = "Importe es Negativo"
         DO LIB_MERR WITH 99
         UltTecla = 0
         i = 7
      ENDIF
   ENDIF

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
Yo       = 6
Largo    = 6
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

@ NumLin,3  SAY vTpoAst(NumEle)
@ NumLin,09 SAY vNroAst(NumEle)
@ NumLin,20 SAY vNotAst(NumEle) PICT "@S40"
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
         IF PROV->TIPO="A" .and. EMPTY(SUBSTR(LsNroAst,8,2))
            LsNroAst = SUBSTR(LsNroAst,1,6)+"-"+RIGHT(STR(_ANO,4),2)+" "
         ENDIF
         IF PROV->TIPO="A"
            @ NumLin,09  GET LsNroAst PICT "!!!!!!-99!"
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
         @ NumLin,20 SAY LsNotAst PICT "@S40"
      CASE i = 3
         @ NumLin,61 SAY IIF(XnCodMon=1,"S/.","US$")
         @ NumLin,64 GET LfImport PICT "###,###,###.##"
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
@ 18 ,18 SAY XfImpChq PICT "999,999.99"

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
   LsxxCodCta = SUBSTR(LsxxCodCta,i+1)
ENDDO

OK = .F.
FOR Z = 1 TO NumCta
   LsCodCta = xxCodCta(Z)
   SELECT RMOV
   SET ORDER TO RMOV05
   SEEK LsCodCta + LsNroAst
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
ENDIF

IF EMPTY(XsNotAst) .OR. MaxEle = 1
   XsNotAst = LsNotAst
   @ 20,14 SAY XsNotAst
ENDIF
IF EMPTY(XsGirado) .OR. MaxEle = 1
   XsGirado = SPACE(LEN(VMOV->Girado))
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
PROCEDURE MOVBUSCA
******************
SELECT VMOV
SET ORDER TO VMOV02
LLAVE = "016*"
SEEK LLAVE
DO WHILE CODOPE+NROVOU = LLAVE .AND. ! EOF()
   MaxEle1 = MaxEle1 + 1
   vTpoAst(MaxEle1) = "FAC"
   vNroAst(MaxEle1) = NroAst+"-"+RIGHT(STR(_Ano,4,0),2)+" "
   vImport(MaxEle1) = 0
   vNotAst(MaxEle1) = ""
   SKIP
ENDDO
SET ORDER TO VMOV01
LsTpoAst = "FAC"
SELECT PROV
SEEK LsTpoAst
MaxEle = MaxEle1
FOR NumEle = 1 TO MaxEle
    LsNroAst = vNroAst(NumEle)
    LfImport = 0
    LsNotAst = ""
    IF CHKNROAST()
    ENDIF
    vImport(NumEle) = LfImport
    vNotAst(NumEle) = LsNotAst
NEXT
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
@ NumLin,2  SAY vCodCta(NumEle)
@ NumLin,8  SAY CTAS->NomCta PICT "@S34"
@ NumLin,43 SAY vCodAux(NumEle)
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

LsCodCta = vCodCta(NumEle)
LsCodAux = vCodAux(NumEle)
LcTpoMov = vTpoMov(NumEle)
LsNroRef = vNroRef(NumEle)
LfImpCta = vImpCta(NumEle)
UltTecla = 0
i = 1
LinAct = NumLin
LinCta = 2
LinNom = 8
LinAux = 43
LinRef = 49
LinImp = 63
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
         @ LinAct,LinNom SAY CTAS->NomCta PICT "@S20"
         LcTpoMov = CTAS->CtaCja

      CASE i = 2
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
            ENDIF
         ELSE
            LsCodAux = SPACE(LEN(RMOV->CodAUX))
         ENDIF

      CASE i = 3
         IF CTAS->PidDoc="S"
            @ LinAct,LinRef GET LsNroRef PICT "@!"
            READ
            UltTecla = LASTKEY()
         ELSE
            LsNroRef = SPACE(LEN(RMOV->NroDoc))
         ENDIF
         @ LinAct,LinRef SAY LsNroRef PICT "@!"


      CASE i = 4
         IF LfImpCta<=0
            LfImpCta = ROUND(XfImpCh1,2)
         ENDIF
         @ NumLin,60 SAY IIF(XnCodMon=1,"S/.","US$")
         @ LinAct,LinImp GET LfImpCta PICT "9,999,999.99" VALID LfImpCta > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,LinImp SAY LfImpCta PICT "9,999,999.99"

      CASE i = 5
         ZcTpoMov = IIF(LcTpoMov = "D"," ","-")
         @ LinAct,77     GET ZcTpoMov PICT "!" VALID ZcTpoMov$" -"
         READ
         UltTecla = LASTKEY()
         LcTpoMov = IIF(ZcTpoMov = "-","H","D")
         @ LinAct,77     SAY IIF(LcTpoMov = "D"," ","-")


      CASE i = 6
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
   i = IIF(i>6, 6, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT CTAS
IF UltTecla <> Escape
   vCodCta(NumEle) = LsCodCta
   vTpoMov(NumEle) = LcTpoMov
   vCodAux(NumEle) = LsCodAux
   vNroRef(NumEle) = LsNroRef
   vImpCta(NumEle) = LfImpCta
ENDIF
XfImpCh2 = 0
FOR ii = 1 to MaxEle
    XfImpCh2 = XfImpCh2 + vImpCta(ii)*iif(vTpoMov(ii)="D",1,-1)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
@ 18 ,18 SAY XfImpChq PICT "999,999.99"
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
   vCodCta(i) = vCodCta(i+1)
   vCodAux(i) = vCodAux(i+1)
   vNroRef(i) = vNroRef(i+1)
   vTpoMov(i) = vTpoMov(i+1)
   vImpCta(i) = vImpCta(i+1)
   i = i + 1
ENDDO
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroDoc))
vTpoMov(i) = " "
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
   vCodCta(i) = vCodCta(i-1)
   vCodAux(i) = vCodAux(i-1)
   vNroRef(i) = vNroRef(i-1)
   vTpoMov(i) = vTpoMov(i+1)
   vImpCta(i) = vImpCta(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroRef(i) = SPACE(LEN(RMOV->NroRef))
vTpoMov(i) = " "
vImpCta(i) = 0
Estado = .T.
RETURN
************************************************************************** FIN
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
      IF EliItm = "ù"
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
   DELETE
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
   SELECT OPER
   =NROAST(XsNroAst)
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
REPLACE VMOV->FLGEST  WITH "M"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0

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
   **** anulamos los * en la referencia ***
   SELECT VMOV
   REGACT = RECNO()
   LsNroMes = LEFT(XsNroDoc,2)
   LsNroAst = LEFT(XsNroDoc,6)
   LsCodOpe = "016"
   SEEK  LsNroMes+LsCodOpe+LsNroAst
   IF NROVOU = "*"
      IF RLOCK()
         REPLACE NROVOU WITH ""
      ENDIF
   ENDIF
   GOTO REGACT
   = RLOCK()
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
   XsCodCta = vCodCta(NumEle)
   XsNroRef = ""
   XsClfAux = CTAS->CLFAUX
   XsCodAux = vCodAux(NumEle)
   XsCodRef = ""
   XsGloDoc = XsNotAst
   XsCodDoc = ""
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

**** Ajustando Residuos ****
*IF MaxEle1 > 0 .or. MaxEle2 > 0
*   IF ABS(YfImport) >= .01
*      IF TPOMOV = "D"
*         REPLACE Import WITH Import - YfImport
*       ELSE
*         REPLACE Import WITH Import + YfImport
*       ENDIF
*   ENDIF
*   IF ABS(YfImpUsa) >= .01
*      IF TPOMOV = "D"
*         REPLACE ImpUsa WITH ImpUsa - YfImpUsa
*      ELSE
*         REPLACE ImpUsa WITH ImpUsa + YfImpUsa
*      ENDIF
*   ENDIF
*ENDIF

**** Actualizando Cta de Caja ***
IF XnCodMon = 1
   LfImport = XfImpChq
   LfImpUsa = ROUND(LfImport/XfTpoCmb,2)
ELSE
   LfImpUsa = XfImpChq
   LfImport = ROUND(LfImpUsa*XfTpoCmb,2)
ENDIF
XsCodCta = XsCtaCja
XsNroRef = ""
XsClfAux = ""
XsCodAux = ""
XsCodRef = ""
XsGloDoc = XsNotAst
XsCodDoc = "CHQ"
XsNroDoc = XsNroChq
XcEliItm = "ù"
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
RETURN
******************************************************************************
PROCEDURE Grbrmov
*****************
SELECT RMOV
APPEND BLANK
XiNroItm = XiNroItm + 1
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
REPLACE RMOV->FchVto WITH {,,}
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
NumPag   = 1
SELECT VMOV
LsLLave  = (NroMes+CodOpe+NroAst)
SELECT RMOV
SEEK LsLLave
SET DEVICE TO PRINT
Largo  = 36
LinFin = Largo - 10
NumPag = 0
TfDebe = 0
TfHber = 0
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
   IF Import = 0 .AND. EliItm = "ú"
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
      @ LinAct,65+3 SAY Import PICT "999,999,999.99"
      TfDebe = TfDebe + Import
   ELSE
      @ LinAct,80+3 SAY Import PICT "999,999,999.99"
      TfHber = TfHber + Import
   ENDIF
   @ LinAct,94+3 SAY "³"
   SKIP
ENDDO
IF PROW() > LinFin - 3
   @ LARGO -1,0 SAY ""
   DO INIPAG
ENDIF
LinAct = PROW() + 1
@ LinAct,6  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
LinAct = PROW() + 1
@ LinAct,50 SAY "TOTAL S/."
@ LinAct,64 SAY "³"
@ LinAct,65 SAY TfDebe PICT "999,999,999.99"
@ LinAct,79 SAY "³"
@ LinAct,80 SAY TfHber PICT "999,999,999.99"
@ LinAct,94 SAY "³"
LinAct = PROW() + 1
@ LinAct,64 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

LinAct = LinFin
@ LinAct+1,6  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ LinAct+2,6  SAY "³      PREPARADO      ³      REVISADO       ³    AUTORIZACION     ³       VoBo          ³"
@ LinAct+3,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ LinAct+4,6  SAY "³                     ³                     ³                     ³                     ³"
@ LinAct+5,6  SAY "³                     ³                     ³                     ³                     ³"
@ LinAct+6,6  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
EJECT PAGE
RETURN
****************
PROCEDURE INIPAG
****************
IF ! (NumPag = 0 .OR. PROW() > LinFin)
   RETURN
ENDIF
IF NumPag > 0
   LinAct = PROW() + 1
   @ LinAct,06 SAY "³"
   @ LinAct,50 SAY "VAN ....."
   @ LinAct,65 SAY TfDebe PICT "999,999,999.99"
   @ LinAct,80 SAY TfHber PICT "999,999,999.99"
   @ LinAct,94 SAY "³"
   LinAct = PROW() + 1
   @ LinAct,6  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ENDIF
NumPag = NumPag + 1
XsHoy='Lima, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)

SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)

@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN2
@  0,6  SAY _PRN7A+TRIM(GsNomCia)
@  0,0  SAY _PRN7B
@  0,76 SAY _PRN7A+"N§ "+VMOV->NroAst+_Prn7b
@  0,0  SAY _PRN7B
@  2,0  SAY _PRN7A+PADC("PROVISION CAJA CHICA",47)+_PRN7B
@  3,6  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  4,6  SAY "³"
@  4,8  SAY XsHoy
@  4,76 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@  4,80 SAY VMOV->ImpChq PICT "**,***,***.**"
@  4,94 SAY "³"
@  5,06 SAY "³"
@  5,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@  5,94 SAY "³"
@  6,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  7,6  SAY "³      C O N C E P T O         ³CUENTA³DOCUMENTO³REFERENC.³     DEBE     ³    HABER     ³"
@  8,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"

IF NumPag > 1
   LinAct = PROW() + 1
   @ LinAct,06 SAY "³"
   @ LinAct,50 SAY "VIENEN..."
   @ LinAct,65 SAY TfDebe PICT "999,999,999.99"
   @ LinAct,80 SAY TfHber PICT "999,999,999.99"
   @ LinAct,94 SAY "³"
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
XcEliItm = "ð"
XfImpUsa = LfImpUsa
XfImport = LfImport
IF XfImport > 0
   XsCodCta = XsCdCta1
   XsClfAux = ""
   XsCodAux = ""
   XcTpoMov = [H]
ELSE
   XfImpUsa = -LfImpUsa
   XfImport = -LfImport
   XsCodCta = XsCdCta2
   =SEEK(XsCodCta,"CTAS")
   XsClfAux = CTAS->ClfAux
   XsCodAux = XsCdAux2
   XcTpoMov = [D]
ENDIF
DO GRBRMOV
IF TpoMov = "H"
   YfImport = YfImport + Import
   YfImpUsa = YfImpUsa + ImpUsa
ELSE
   YfImport = YfImport - Import
   YfImpUsa = YfImpUsa - ImpUsa
ENDIF
RETURN
