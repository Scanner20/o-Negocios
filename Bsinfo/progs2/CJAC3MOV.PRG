****************************************************************************
*  Nombre        : CJAC3MOV.prg
*  Sistema       : Caja Bancos
*  Proposito     : Caja TRANSFERENCIAS
*  Creacion      : 17/06/93
***************************************************************************
DIMENSION vCodCt1(20),vImpct1(20),vCodMn1(20),vCodAu1(20),vcoddi1(20)
DIMENSION vCodCt2(20),vImpct2(20),vCodMn2(20),vCodAu2(20),vcoddi2(20)
* * * *
TsCodDiv1= [01]
XsCodOpe = "063"     && TRANSFERENCIA EN BANCOS
XsCodOp1 = "099"     && CLIENTES
* * * *
XsNroMes = TRANSF(_MES,"@L ##")
ZiCodMon = 1
ScrMov   = ""
MaxEle1  = 0
MaxEle2  = 0
Crear    = .T.
Modificar= .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XnCodMon,XfTpoCmb,XsNroVou,XsGloAst
STORE 0  TO XfImpCh1,XfImpCh2
*
store [] to xsclfaux
*
XdFchAst = DATE()
XdFchPed = XdFchAst
XfTpoCmb = 1.00

RESTORE FROM CJACONFG ADDITIVE

DO MOVgPant
DO MOVApert
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELECT OPER
SET FILTER TO MOVCJA=3
GO TOP
XsCodOpe=CodOpe
SEEK XsCodOpe
IF ! FOUND()
   GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
* * * *
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
               DO DIRPRINT &&IN ADMPRINT
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
SELECT RMOV

RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY PADC("* VOUCHER DE TRANSFERENCIAS *",38) COLOR SCHEME 7
@ 1,0  SAY PADC(cTitulo,38)                  COLOR SCHEME 7
@ 0,49 TO 6,79
@ 1,50 SAY "N§ COMPROBANTE.:"
@ 2,50 SAY "CARTA N§.......:"
@ 3,50 SAY "FECHA..........:"
@ 4,50 SAY "T/CAMBIO.......:"
@ 5,50 SAY "FCH.DE FINANZAS:"
@ 5,04 SAY "DE LAS CUENTAS : " COLOR SCHEME 7
@ 7,00 TO 11,79
*@ 7,01 SAY "ð Tipo  ðCTAS.ð    D E S C R I P C I O N    ð   AUXIL.     ð         IMPORTE ð" COLOR SCHEME 7
@ 07,01 SAY "ð Tipo   DV  -CTAS.ð  D E S C R I P C I O N -   AUXIL.     ð         IMPORTE ð" COLOR SCHEME 7
@ 12,45 SAY " TOTAL CARGOS  : " COLOR SCHEME 7

@ 13,04 SAY " A LAS CUENTAS : " COLOR SCHEME 7
@ 14,00 TO 19,79
*@ 14,01 SAY "ð Tipo  ðCTAS.ð    D E S C R I P C I O N    ð   AUXIL.     ð         IMPORTE ð" COLOR SCHEME 7
*              XXXXX 123456789-123456789-123456789-1234 12345 123456789- 123123456789-1234S
@ 14,01 SAY "ð Tipo   DV  -CTAS.ð  D E S C R I P C I O N -   AUXIL.     ð         IMPORTE ð" COLOR SCHEME 7
*
@ 20,45 SAY " TOTAL ABONOS  : " COLOR SCHEME 7
@ 21,00 SAY "CONCEPTO...:"
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
                  DO DIRPRINT &&IN ADMPRINT
                  IF LASTKEY() # Escape
                     DO MovPrint
                  ENDIF
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
@ 1,68 SAY XsNroAst PICT "99999999"
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
XsGloAst = ""
IF YEAR(DATE()) = _Ano .AND. MONTH(DATE()) = _Mes
   XdFchAst = DATE()
ELSE
   XdFchAst = GdFecha
ENDIF
XdFchPed = XdFchAst
XsDigita = GsUsuario
XsNroVou = SPACE(LEN(VMOV->NroVou))
XfImpCh1 = 0
XfImpCh2 = 0
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVMover
XnCodMon = VMOV->CodMon
XsNotAst = VMOV->NOTAST
XsGloAst = VMOV->GloAst
XdFchAst = VMOV->FchAst
XdFchPed = VMOV->FchPed
XsDigita = GsUsuario
XsNroVou = NroVou
XfImpCh1 = 0
XfImpCh2 = 0
XfTpoCmb = VMOV->TpoCmb
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
@ 01,68 SAY NroAst PICT "99999999"
@ 02,68 SAY NroVou
@ 03,68 SAY FchAst
@ 4 ,68 SAY TpoCmb PICT "9999.9999"
@ 5 ,68 SAY FchPed
@  8,01 CLEAR TO 10,78
@ 15,01 CLEAR TO 18,78
LinAct1 = 8
LinAct2 = 15
XnCodMon = CODMON
IF VMOV->FlgESt = "A"
   @ LinAct1,0 say []
   @ ROW()  ,11 SAY "     #    #    #  #    # #         #    #####   ######  "
   @ ROW()+1,11 SAY "   #####  # #  #  #    # #       #####  #    #  #    #  "
   @ ROW()+1,11 SAY "  #     # #   ##  ###### ###### #     # #####   ######  "
ENDIF
**** Buscando Datos Ventana 1 ****
SELECT RMOV
LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
SEEK LsLLave
MaxEle1 = 0
MaxEle2 = 0
XfImpCh1 = 0
XfImpCh2 = 0
Ancho    = 74
Xo       = INT((80 - Ancho)/2)
DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
   DO CASE
     *CASE EliItm = chr(255)
      CASE EliItm = chr(43)     
         IF MaxEle1 >= 20
            SKIP
            LOOP
         ENDIF
         MaxEle1= MaxEle1+ 1
         vcoddi1(maxele1) = coddiv
         vCodCt1(MaxEle1) = CodCta
         vCodAu1(MaxEle1) = CodAux
         vCodMn1(MaxEle1) = CodMon
         IF TPOMOV = "H"
            vImpCt1(MaxEle1) = +IIF(RMOV->CODMON=1,IMPORT,IMPUSA)
            XfImpCh1 = XfImpCh1 + IMPORT
         ELSE
            vImpCt1(MaxEle1) = -IIF(RMOV->CODMON=1,IMPORT,IMPUSA)
            XfImpCh1 = XfImpCh1 - IMPORT
         ENDIF
         IF LinAct1 < 11
            DO GENblin1 WITH MaxEle1, LinAct1
            LinAct1 = LinAct1 + 1
         ENDIF
    OTHER
         IF MaxEle2 >= 20
            SKIP
            LOOP
         ENDIF
         MaxEle2= MaxEle2+ 1
         vcoddi2(maxele2) = coddiv         
         vCodCt2(MaxEle2) = CodCta
         vCodAu2(MaxEle2) = CodAux
         vCodMn2(MaxEle2) = CodMon
         IF TPOMOV = "H"
            vImpCt2(MaxEle2) = -IIF(RMOV->CODMON=1,IMPORT,IMPUSA)
            XfImpCh2 = XfImpCh2 - IMPORT
         ELSE
            vImpCt2(MaxEle2) = +IIF(RMOV->CODMON=1,IMPORT,IMPUSA)
            XfImpCh2 = XfImpCh2 + IMPORT
         ENDIF
         IF LinAct2 < 19
            DO GENblin2 WITH MaxEle2, LinAct2
            LinAct2 = LinAct2 + 1
         ENDIF
   ENDCASE
   SELECT RMOV
   SKIP
ENDDO
SELECT VMOV
@ 12 ,64 SAY XfImpCh1 PICT "999,999,999.99"
@ 20 ,64 SAY XfImpCh2 PICT "999,999,999.99"
@ 21 ,14 SAY VMOV->NotAst
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
      CASE I = 1
         @ 2 ,68 GET XsNroVou PICT "@!"
         READ
         UltTecla = LastKey()
         @ 2 ,68 SAY XsNroVou
      CASE I = 2
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
         @ 5 ,68 GET XdFchPed
         READ
         UltTecla = LastKey()
         @ 5 ,68 SAY XdFchPed
      CASE I = 7
         DO CARGOS
         IF LASTKEY() = Escape
            UltTecla = Arriba
         ELSE
            UltTecla = Enter
         ENDIF

      CASE I = 8
         DO ABONOS
         IF LASTKEY() = Escape
            UltTecla = Arriba
         ELSE
            UltTecla = Enter
         ENDIF

      CASE I = 11
         @ 21, 14 GET XsNotAst PICT "@!"
         READ
         UltTecla = LastKey()
         @ 21, 14 SAY XsNotAst PICT "@!"

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

   IF INLIST(UltTecla,CtrlW,F10)
      IF XfImpCh1 <> XfImpCh2
         GsMsgErr = " Importes entre Cargos y Abonos NO CUADRA"
         DO LIB_MERR WITH 99
         ULTTECLA = 0
      ENDIF
   ENDIF


ENDDO
SELECT VMOV
RETURN
****************
PROCEDURE CARGOS
****************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENblin1"
EdiLin   = "GENbedi1"
BrrLin   = "GENbbor1"
InsLin   = "GENbins1"
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
IF MaxEle1 = 1 .AND. EMPTY(vCodCt1(1))
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
PROCEDURE GENblin1
PARAMETERS NumEle, NumLin
=SEEK(vCodCt1(NumEle),"CTAS")
@ NumLin,02 SAY IIF(vCodCt1(NumEle)="104","CTA.CTE","CTA.AHO")
@ numlin,10 say vcoddi1(numele)
@ NumLin,13 SAY vCodCt1(NumEle)
@ NumLin,22 SAY CTAS->NOMCTA PICT "@S25"
@ NumLin,48 SAY vCodAu1(NumEle)
@ NumLin,61 SAY IIF(vCodMn1(NumEle)=1,"S/.","US$")
@ NumLin,64 SAY vImpCt1(NumEle) PICT "###,###,###.##"
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedi1
PARAMETERS NumEle, NumLin, LiUtecla
lscoddiv = vcoddi1(numele)
LsCodCta = vCodCt1(NumEle)
LsCodAux = vCodAu1(NumEle)
LfImport = vImpct1(NumEle)
LiCodMon = vCodMn1(NumEle)
UltTecla = 0

i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
   DO CASE
      CASE i = 1
         xElige = IIF(LsCodCta="104".OR. EMPTY(LsCodCta),1,2)
         VECOPC(1) = "CTA.CTE"
         VECOPC(2) = "CTA.AHO"
         xElige = Elige(xElige,NumLin,2,2)
         IF XElige = 1
            cCodCta = "104"
         ELSE
            cCodCta = "108"
         ENDIF
         IF ULTTECLA = F10 .AND. EMPTY(LsCodCta)
            ULTTECLA = ESCAPE
            KEYB CHR(23)
         ENDIF
      
      case i = 2
         SELE AUXI
         @ numlin,10 get lscoddiv pict [XX]
         read
         ulttecla = lastkey()
         if ulttecla = escape
            loop
         endif
         IF UltTecla = F8
            TsClfAuxAc = XsClfAux
	        XsClfAux = [DV ]  && Divisionarias
            IF ! CBDBUSCA("AUXI")
               LOOP
            ENDIF
            Lscoddiv = padr(auxi.codaux,len(rmov.coddiv))
            XsClfAux=TsClfAuxAc
         ENDIF
         SEEK [DV ]+lscoddiv
         IF !FOUND()
        	GsMsgErr = [Codigo de divisionaria invalido]
         	DO LIB_MERR WITH 99
         	LsCodDiv = space(len(rmov.coddiv))         	
         	UltTecla=0
         	Loop
         ENDIF
         @ numlin,10 SAY lsCodDiv PICT "XX"
         
      CASE I = 3
         SELECT CTAS
         zCodCta = SUBSTR(LsCodCta,4)
         @ NumLin,13 SAY cCodCta
         @ NumLin,16 GET zCodCta PICTURE REPLICATE("9",LEN(zCodCta))
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         LsCodCta = cCodCta+zCodCta
         IF UltTecla = Arriba
            I = 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("CTAX")
               LOOP
            ENDIF
            LsCodCta = CodCta
            UltTecla = Enter
         ENDIF
         @ NumLin,13 SAY LsCodCta
         SEEK LsCodCta
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
         @ NumLin,22 SAY NomCta PICT "@S25"

      CASE i = 4
         IF CTAS->PIDAUX="S"
             SELE AUXI
             XsClfAux= CTAS->ClfAux
             @ NumLin,48 GET LsCodAux PICT "@!"
             READ
             UltTecla = LASTKEY()
             IF UltTecla = F8
                SEEK XsClfAux+TRIM(LsCodaux)
                IF ! CBDBUSCA("AUXI")
                   UltTecla = 0
                   LOOP
                ENDIF
                LsCodAux = AUXI->CodAux
             ENDIF
             SEEK XsClfAux+LsCodAux
             IF !FOUND()
                GsMsgErr = "C¢digo no existe"
                DO LIB_MERR WITH 99
                UltTecla = 0
                LOOP
             ENDIF
             @ NumLin,48 SAY LsCodAux PICT "@!"
             SELE CTAS
         ENDIF

      CASE i = 5
         LiCodMon = IIF(CTAS->CodMon=1,1,2)
         @ NumLin,61 SAY IIF(CTAS->CodMon=1,"S/.","US$")
         @ NumLin,64 GET LfImport PICT "###,###,###.##"
         READ
         UltTecla = LASTKEY()

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
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 6 , 6, i)
   i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape
   vcoddi1(numele) = lscoddiv
   vCodCt1(NumEle) = LsCodCta
   vCodAu1(NumEle) = LsCodAux
   vCodMn1(NumEle) = LiCodMon
   vImpCt1(NumEle) = LfImport
ENDIF
XfImpCh1 = 0
FOR ii = 1 to MaxEle
   IF vCodMn1(ii)=1
      XfImport = vImpCt1(ii)
   ELSE
      XfImport = ROUND(vImpCt1(ii)*XfTpoCmb,2)
   ENDIF
    XfImpCh1 = XfImpCh1 + XfImport
ENDFOR
@ 12 ,64 SAY XfImpCh1 PICT "999,999,999.99"
LiUTecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbbor1
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   vcoddi1(i) = vcoddi1(i+1)
   vCodCt1(i) = vCodCt1(i+1)
   vCodAu1(i) = vCodAu1(i+1)
   vCodMn1(i) = vCodMn1(i+1)
   vImpCt1(i) = vImpCt1(i+1)
   i = i + 1
ENDDO
vcoddi1(i) = space(len(rmov.coddiv))
vCodCt1(i) = SPACE(LEN(RMOV->CODCTA))
vCodAu1(i) = SPACE(LEN(RMOV->CODAux))
vCodMn1(i) = 0
vImpCt1(i) = 0
XfImpCh1 = 0
FOR ii = 1 to MaxEle
   IF vCodMn1(ii)=1
      XfImport = vImpCt1(ii)
   ELSE
      XfImport = ROUND(vImpCt1(ii)*XfTpoCmb,2)
   ENDIF
    XfImpCh1 = XfImpCh1 + XfImport
ENDFOR
@ 12 ,64 SAY XfImpCh1 PICT "999,999,999.99"
Estado = .T.
RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbins1
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vcoddi1(i) = vcoddi1(i-1)
   vCodCt1(i) = vCodCt1(i-1)
   vCodAu1(i) = vCodAu1(i-1)
   vCodMn1(i) = vCodMn1(i-1)
   vImpCt1(i) = vImpCt1(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
vcoddi1(i) = space(len(rmov.coddiv))
vCodCt1(i) = SPACE(LEN(RMOV->CODCTA))
vCodAu1(i) = SPACE(LEN(RMOV->CODCTA))
vCodMn1(i) = 0
vImpCt1(i) = 0
Estado = .T.
RETURN
****************
PROCEDURE ABONOS
****************
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENblin2"
EdiLin   = "GENbedi2"
BrrLin   = "GENbbor2"
InsLin   = "GENbins2"
Yo       = 14
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
@ 19,1   TO 19,78
IF MaxEle2 = 1 .AND. EMPTY(vCodCt2(1))
   MaxEle2 = 0
   @ 15,01 CLEAR TO 18,78
ENDIF
@ 15,01 Fill TO 18,78 COLOR SCHEME 1
IF LASTKEY() = Escape
   RETURN
ENDIF

RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENblin2
PARAMETERS NumEle, NumLin
=SEEK(vCodCt2(NumEle),"CTAS")
@ NumLin,2  SAY IIF(vCodCt2(NumEle)="104","CTA.CTE","CTA.AHO")
@ NumLin,10 SAY vcoddi2(NumEle)
@ NumLin,13 SAY vCodCt2(NumEle)
@ NumLin,22 SAY CTAS->NOMCTA PICT "@S25"
@ NumLin,48 SAY vCodAu2(NumEle) PICT "@!"
@ NumLin,61 SAY IIF(vCodMn2(NumEle)=1,"S/.","US$")
@ NumLin,64 SAY vImpCt2(NumEle) PICT "###,###,###.##"
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedi2
PARAMETERS NumEle, NumLin, LiUtecla
lscoddiv = vcoddi2(numele)
LsCodCta = vCodCt2(NumEle)
LsCodAux = vCodAu2(NumEle)
LiCodMon = vCodMn2(NumEle)
LfImport = vImpct2(NumEle)
UltTecla = 0

i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba)
   DO CASE
      CASE i = 1
         xElige = IIF(LsCodCta="104".OR. EMPTY(LsCodCta),1,2)
         VECOPC(1) = "CTA.CTE"
         VECOPC(2) = "CTA.AHO"
         xElige = Elige(xElige,NumLin,2,2)
         IF XElige = 1
            cCodCta = "104"
         ELSE
            cCodCta = "108"
         ENDIF
         IF ULTTECLA = F10 .AND. EMPTY(LsCodCta)
            ULTTECLA = ESCAPE
            KEYB CHR(23)
         ENDIF
         
      case i = 2
         SELE AUXI
         @ numlin,10 get lscoddiv pict [XX]
         read
         ulttecla = lastkey()
         if ulttecla = escape
            loop
         endif
         IF UltTecla = F8
            TsClfAuxAc = XsClfAux
	        XsClfAux = [DV ]  && Divisionarias
            IF ! CBDBUSCA("AUXI")
               LOOP
            ENDIF
            Lscoddiv = padr(auxi.codaux,len(rmov.coddiv))
            XsClfAux=TsClfAuxAc
         ENDIF
         SEEK [DV ]+lscoddiv
         IF !FOUND()
        	GsMsgErr = [Codigo de divisionaria invalido]
         	DO LIB_MERR WITH 99
         	LsCodDiv = space(len(rmov.coddiv))         	
         	UltTecla=0
         	Loop
         ENDIF
         @ numlin,10 SAY lsCodDiv PICT "XX"
         
      CASE I = 3
         SELECT CTAS
         zCodCta = SUBSTR(LsCodCta,4)
         @ NumLin,13 SAY cCodCta
         @ NumLin,16 GET zCodCta PICTURE REPLICATE("9",LEN(zCodCta))
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         LsCodCta = cCodCta+zCodCta
         IF UltTecla = Arriba
            I = 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("CTAX")
               LOOP
            ENDIF
            LsCodCta = CodCta
            UltTecla = Enter
         ENDIF
         @ NumLin,13 SAY LsCodCta
         SEEK LsCodCta
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
         @ NumLin,22 SAY NomCta PICT "@S25"

      CASE i = 4
         IF CTAS->PIDAUX="S"
             SELE AUXI
             XsClfAux= CTAS->ClfAux
             @ NumLin,48 GET LsCodAux PICT "@!"
             READ
             UltTecla = LASTKEY()
             IF UltTecla = F8
                SEEK XsClfAux+TRIM(LsCodaux)
                IF ! CBDBUSCA("AUXI")
                   UltTecla = 0
                   LOOP
                ENDIF
                LsCodAux = AUXI->CodAux
             ENDIF
             SEEK XsClfAux+LsCodAux
             IF !FOUND()
                GsMsgErr = "C¢digo no existe"
                DO LIB_MERR WITH 99
                UltTecla = 0
                LOOP
             ENDIF
             @ NumLin,48 SAY LsCodAux PICT "@!"
             SELE CTAS
         ENDIF
         
      CASE i = 5
         LiCodMon = IIF(CTAS->CodMon=1,1,2)
         IF LfImport = 0
            LfImport = XfImpch1 - XfImpch2
            IF LiCodMon = 2
               LfImport = round(LfImport /XfTpoCmb,2)
            ENDIF
         ENDIF

         @ NumLin,61 SAY IIF(CTAS->CodMon=1,"S/.","US$")
         @ NumLin,64 GET LfImport PICT "###,###,###.##"
         READ
         UltTecla = LASTKEY()

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
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 6 , 6, i)
   i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> Escape
   vcoddi2(numele) = lscoddiv
   vCodCt2(NumEle) = LsCodCta
   vCodAu2(NumEle) = LsCodAux
   vCodMn2(NumEle) = LiCodMon
   vImpCt2(NumEle) = LfImport
ENDIF
XfImpCh2 = 0
FOR ii = 1 to MaxEle
   IF vCodMn2(ii)=1
      XfImport = vImpCt2(ii)
   ELSE
      XfImport = ROUND(vImpCt2(ii)*XfTpoCmb,2)
   ENDIF
    XfImpCh2 = XfImpCh2 + XfImport
ENDFOR
@ 20 ,64 SAY XfImpCh2 PICT "999,999,999.99"
LiUTecla = UltTecla
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbbor2
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   vcoddi2(i) = vcoddi2(i+1)
   vCodCt2(i) = vCodCt2(i+1)
   vCodAu2(i) = vCodAu2(i+1)
   vCodMn2(i) = vCodMn2(i+1)
   vImpCt2(i) = vImpCt2(i+1)
   i = i + 1
ENDDO
vcoddi2(i) = space(len(rmov.coddiv))
vCodCt2(i) = SPACE(LEN(RMOV->CODCTA))
vCodAu2(i) = SPACE(LEN(RMOV->CODAUX))
vCodMn2(i) = 0
vImpCt2(i) = 0
XfImpCh2 = 0
FOR ii = 1 to MaxEle
   IF vCodMn2(ii)=1
      XfImport = vImpCt2(ii)
   ELSE
      XfImport = ROUND(vImpCt2(ii)*XfTpoCmb,2)
   ENDIF
    XfImpCh2 = XfImpCh2 + XfImport
ENDFOR
@ 20 ,64 SAY XfImpCh2 PICT "999,999,999.99"
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
   vcoddi2(i) = vcoddi2(i-1)
   vCodCt2(i) = vCodCt2(i-1)
   vCodAu2(i) = vCodAu2(i-1)
   vCodMn2(i) = vCodMn2(i-1)
   vImpCt2(i) = vImpCt2(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
vcoddi2(i) = space(len(rmov.coddiv))
vCodCt2(i) = SPACE(LEN(RMOV->CODCTA))
vCodAu2(i) = SPACE(LEN(RMOV->CODAUX))
vCodMn2(i) = 0
vImpCt2(i) = 0
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
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELE RMOV
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, coddiv
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
ELSE
   DO MOVPINTA
   DO DIRPRINT &&IN ADMPRINT
   IF LASTKEY() # Escape
      DO MovPrint
   ENDIF
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
IF XfImpCh1 <> XfImpCh2
   GsMsgErr = " Importes entre Cargos y Abonos NO CUADRA"
   DO LIB_MERR WITH 99
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
   replace vmov.fchdig  with date()
   replace vmov.hordig  with time()
   SELECT OPER
   =NROAST(XsNroAst)
ELSE
   SEEK LLAVE
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XnCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->GloAst  WITH XsGloAst
***REPLACE VMOV->CtaCja  WITH ""
REPLACE VMOV->CtaCja  WITH VCODCT1(1)
REPLACE VMOV->NroChq  WITH ""
REPLACE VMOV->Girado  WITH ""
***REPLACE VMOV->ImpChq  WITH 0
REPLACE VMOV->ImpChq  WITH VIMPCT1(1)
REPLACE VMOV->Digita  WITH GsUsuario
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0
REPLACE VMOV->FchPed  WITH XdFchPed
SELECT RMOV
SEEK LLAVE
**** Anulando movimientos anteriores ****
DO WHILE  NroMes+CodOpe+NroAst = Llave .AND. ! EOF()
   IF Rec_LOCK(5)
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, coddiv
      SELE RMOV
      DELETE
      UNLOCK
   ENDIF
   SKIP
ENDDO
YfImport = 0
YfImpUsa = 0
XiNroItm = 0

***** ACTUALIZANDO 1ra VENTANA *****
SELECT RMOV
FOR NumEle = 1 TO Maxele1
  *XcEliItm = CHR(255)
   XcEliItm = CHR(43)  
   xscoddiv = vcoddi1(numele)
   XsCodCta = vCodCt1(NumEle)
   =SEEK(XsCodCta,"CTAS")
   XsClfAux = CTAS->ClfAux
   XsCodAux = vCodAu1(NumEle)
   XiCodMon = vCodMn1(NumEle)
   IF XiCodMon = 1
      XfImport = vImpCt1(NumEle)
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = vImpCt1(NumEle)
      XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
   ENDIF
   IF XfImport >= 0
      XcTpoMov = "H"
   ELSE
      XcTpoMov = "D"
   ENDIF
   XfImport = ABS(XfImport)
   XfImpUsa = ABS(XfImpUsa)
   DO GRBRMOV
   IF TpoMov = "H"
      YfImport = YfImport - Import
      YfImpUsa = YfImpUsa - ImpUsa
   ELSE
      YfImport = YfImport + Import
      YfImpUsa = YfImpUsa + ImpUsa
   ENDIF
ENDFOR


***** ACTUALIZANDO 2da VENTANA *****
SELECT RMOV
FOR NumEle = 1 TO Maxele2
   XcEliItm = " "
   xscoddiv = vcoddi2(numele)
   XsCodCta = vCodCt2(NumEle)
   =SEEK(XsCodCta,"CTAS")
   XsClfAux = CTAS->ClfAux
   XsCodAux = vCodAu2(NumEle)
   XiCodMon = vCodMn2(NumEle)
   IF XiCodMon = 1
      XfImport = vImpCt2(NumEle)
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = vImpCt2(NumEle)
      XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
   ENDIF
   IF XfImport >= 0
      XcTpoMov = "D"
   ELSE
      XcTpoMov = "H"
   ENDIF
   XfImport = ABS(XfImport)
   XfImpUsa = ABS(XfImpUsa)
   DO GRBRMOV
   IF TpoMov = "H"
      YfImport = YfImport - Import
      YfImpUsa = YfImpUsa - ImpUsa
   ELSE
      YfImport = YfImport + Import
      YfImpUsa = YfImpUsa + ImpUsa
   ENDIF
ENDFOR

**** ajustando residuos ****
IF ABS(YfImport) >= .01
   REPLACE Import WITH Import + YfImport
ENDIF
IF ABS(YfImpUsa) >= .01
   REPLACE ImpUsa WITH ImpUsa + YfImpUsa
ENDIF
@ 24,0
SELECT VMOV
UNLOCK ALL
RETURN
******************************************************************************
PROCEDURE Grbrmov
*****************
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
replace rmov.coddiv  with xscoddiv
REPLACE RMOV->NroMes WITH XsNroMes
REPLACE RMOV->CodOpe WITH XsCodOpe
REPLACE RMOV->NroAst WITH XsNroAst
REPLACE RMOV->NroItm WITH XiNroItm
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->NroRef WITH ""
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->Import WITH XfImport
REPLACE RMOV->ImpUsa WITH XfImpUsa
REPLACE RMOV->GloDoc WITH XsNotAst
REPLACE RMOV->CodDoc WITH ""
REPLACE RMOV->NroDoc WITH ""
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->FchAst WITH XdFchAst
*REPLACE RMOV->FchVto WITH {,,}  
REPLACE RMOV->FchVto WITH {  ,  ,    }       
IF RMOV.CodCta=[10]
   REPLACE RMOV->FchPed WITH XdFchPed
ENDIF
REPLACE VMOV->NroiTM  WITH XiNroItm
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
*
replace rmov.fchdig  with date()
replace rmov.hordig  with time()
*
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa, coddiv
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
ENDIF
SELECT RMOV
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
  *@ LinAct,55+3 SAY NroRef
   @ LinAct,55+3 SAY CodAux
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

LinAct = Largo - 15
@ LinAct+1,6  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ LinAct+2,6  SAY "³      REVISADO       ³      Vo.Bo.         ³                                           ³"
@ LinAct+3,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³ RECIBI CONFORME: .....................    ´"
@ LinAct+4,6  SAY "³                     ³                     ³ NOMBRE: ..............................    ³"
@ LinAct+5,6  SAY "³                     ³                     ³ L.E.  : ..............................    ³"
@ LinAct+6,6  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
EJECT PAGE




SELECT RMOV
RETURN
**********************************************************************
PROCEDURE MovMemb
*****************
*IF NumPag = 0
*   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
*ENDIF
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
   @ LinAct,6  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
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
@  0,76 SAY _PRN7A+"N§ "+VMOV->NroAst+_Prn7b
@  17,0  SAY _PRN7A+PADC("VOUCHER DE CAJA TRANSFERENCIAS",47)+_PRN7B




@ 18,6  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 19,6  SAY "³"
@ 19,8  SAY XsHoy
@ 19,76 SAY "CARTA N§ "+VMOV->NROVOU
@ 19,94 SAY "³"
@ 20,06 SAY "³"
@ 20,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@ 20,94 SAY "³"
@ 21,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 22,6  SAY "³"+PADC(Dato1,87)+"³"
@ 23,6  SAY "³"+PADC(Dato2,87)+"³"
@ 24,6  SAY "³"+PADC(Dato3,87)+"³"
@ 26,6  SAY "³"+PADC(Dato4,87)+"³"
@ 27,6  SAY "³"+PADC(VMOV->NotAst,87)+"³"
@ 28,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 29,6  SAY "³      C O N C E P T O         ³CUENTA³DOCUMENTO³AUXILIAR ³     DEBE     ³    HABER     ³"
@ 30,6  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"

IF NumPag > 1
   LinAct = PROW() + 1
   @ LinAct,50 SAY "VIENEN..."
   @ LinAct,65 SAY TfDebe PICT "999,999,999.99"
   @ LinAct,80 SAY TfHber PICT "999,999,999.99"
ENDIF
RETURN
