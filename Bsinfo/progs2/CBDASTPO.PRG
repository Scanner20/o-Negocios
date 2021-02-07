*******************************************************************************
*  Nombre        : CBDASTPO.prg                                               *
*  Sistema       : Contabilidad                           - VINSA             *
*  Autor         : VETT                                                       *
*  Proposito     : GENERACION DE ASIENTOS TIPO SEGUN MODELO                   *
*  Creacion      : 26/06/94                                                   *
*  Actualizacion :                                                            *
*******************************************************************************
* Flag
* A    Anulado
* R    Registrado en el sistema
* C    Documento Cerrado
* M    Asiento generado autom ticamente
* E    Estimado (no actualiza los acumulados contables)
* T    Asiento generado seg£n tabla de asientos tipo
***************************************************************************
NroDec   = 4
Crear    = .T.
OK = .T.
ScrMov   = ""
XsNroMes = TRANSF(_MES,"@L ##")
lDesBal = .T.
lTpoCorr = 1
Modificar = .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XiCodMon,XfTpoCmb,XsNroVou
STORE "" TO nImpNac,nImpUsa,Ngl,XsCodMod
DIMENSION vNroAst(40),vCodCta(40),vCodAux(40),vNroDoc(40),vFchVto(40),vNroCaj(40)
DIMENSION vCodMon(40),vCodDoc(40),vImport(40),vNroRef(40),vNroItm(40),vFchDoc(40)
DIMENSION vTpoMov(40),vCodRef(40),vGloDoc(40),vClfAux(40),sImport(40),vNroRuc(40)
DIMENSION vIniAux(40)
DIMENSION vImp(4)
STORE [] TO V1,V2,V3,V4
STORE 0 TO L1,L2,L3,L4
STORE [] TO vNroAst,vCodCta,vCodAux,vNroDoc,vFchVto,vNroCaj
STORE [] TO vCodMon,vCodDoc,vImport,vNroRef,vNroItm,vFchDoc
STORE [] TO vTpoMov,vCodRef,vGloDoc,vClfAux,sImport,vIniAux,vNroRuc
sFmt = "999,999,999.99"
MaxEle1 = 0

STORE 0 TO vImp
iDigitos=0
XdFchAst = GdFecha
XfTpoCmb = 1.00
RESTORE FROM CBDCONFG ADDITIVE
DO MOVgPant
DO MOVApert
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
XsCodMod = SPACE(LEN(VMDL.CodMod))
*** Buscando que operaciones puede tomar el usuario ***
SELECT OPER
*IF ! Master
*   SET FILTER TO CODUSR = GsUsuario .OR. EMPTY(CODUSR)
*   GOTO TOP
*ENDIF
*IF EOF()
*   GsMsgErr = "Usuario no autorizado a registrar Operaciones"
*   DO LIB_MERR WITH 99
*   CLOSE DATA
*   RETURN
*ENDIF
XsCodOpe = OPER->CodOpe
*@ 4,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
VAROpe = .F.
*IF ! EOF()
*   SKIP
*ENDIF
*IF EOF()
*   VAROpe = .F.
*ENDIF
*SEEK XsCodOpe
UltTecla = 0
**********************
** Rutina Principal **
**********************
DO WHILE .T.
   SELE VMDL
   @ 4,14 GET XsCodMod  PICT  "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape
      EXIT
   ENDIF
   IF UltTecla = F8
      IF CBDBUSCA("MDLO")
         XsCodMod = CodMod
         UltTecla = Enter
      ELSE
         UltTecla = 0
         LOOP
      ENDIF
   ENDIF
   SEEK XsCodMod
   IF !FOUND()
       GsMsgErr = "Modelo no definido"
       DO LIB_MERR WITH 99
       UltTecla = 0
       LOOP
   ENDIF
   @ 04,14 SAY XsCodMod+" "+LEFT(VMDL->NotAst,30) COLOR SCHEME 11
   DO MOVEImpG       && Pide importe de seg£n # de glosas del modelo
   DO WHILE (.t.)
      DO MOVSlMov    && Pide el c¢digo de operaci¢n a ingresar
      IF UltTecla = Escape
         EXIT
         RETURN
      ENDIF
      IF XsCodOpe = "9"
         GsMsgErr = "SOLO PARA MOVIMIENTOS EXTRA CONTABLES DE CAJA"
         DO LIB_MERR WITH 99
         EXIT
      ENDIF
      **** Correlativo Mensual ****
      SELECT RMOV
      SET ORDER TO RMOV01
      SELECT VMOV
      SET ORDER TO VMOV01
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
                  IF ! Clave(CFGPasswD)
                     LOOP
                  ENDIF
               ENDIF
               IF ! INLIST(FlgEst,"C"," ","R","G","T")
                  GsMsgErr = "Asiento, no puede ser alterado"
                  DO LIB_MERR WITH 99
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
               IF Crear         && Tomamos datos del modelo
                  DO MOVInVar
               ELSE
                  IF FlgEst = "C"
                     GsMsgErr = "Asiento Cerrado, no puede ser alterado"
                     DO LIB_MERR WITH 99
                     IF ! Clave(CFGPasswD)
                        LOOP
                     ENDIF
                  ENDIF
                  IF ! INLIST(FlgEst,"C"," ","R","T")
                     GsMsgErr = "Asiento, no puede ser alterado"
                     DO LIB_MERR WITH 99
                     LOOP
                  ENDIF
                  DO MOVMover
               ENDIF
               DO MOVEdita
               IF Crear
                  DO MovGeRmov  && Generamos detalle del asiento seg£n modelo
                  DO MovBrowM
                  DO MovGrabM
                  SELE VMOV
               ELSE
                  DO MOVGraba
                  DO MOVBrows
               ENDIF
         ENDCASE
         UNLOCK ALL
      ENDDO
      IF ! VAROpe
         EXIT
      ENDIF
   ENDDO
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
IF !used(1)
    close data
    return
ENDIF
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
   GOTO RegAct
   Modificar = ! Cierre
ENDIF
SELE 1
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF !used(1)
    close data
    return
ENDIF
SELE 2
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(2)
    close data
    return
ENDIF
SELE 3
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF !used(3)
    close data
    return
ENDIF
SELE 4
USE cbdrmovm ORDER rmov01   ALIAS RMOV
IF !used(4)
    close data
    return
ENDIF
SELE 5
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdacmct ORDER acct01   ALIAS ACCT
IF !used(7)
    close data
    return
ENDIF
SELE 8
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF !used(8)
    close data
    return
ENDIF
SELE 9
USE cbdVMDLO ORDER VMDL01   ALIAS VMDL
IF !used(9)
    close data
    return
ENDIF
SELE 10
USE cbdRMDLO ORDER RMDL01   ALIAS RMDL
IF !used(10)
    close data
    return
ENDIF
** Archivo de Control de Documentos del Proveedor **
SELE 11
USE CJADPROV ORDER DPRO06   ALIAS DPRO
IF !USED(11)
    CLOSE DATA
    RETURN
ENDIF
RETURN
RETURN
************************************************************************* FIN
* Procedimiento Pide el codigo de movimiento
******************************************************************************
PROCEDURE MOVSlMov
**********************
** Pide Operaci¢n **
SELECT OPER
SEEK VMDL->CodOpe
XsCodOpe = OPER->CodOpe
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW,Enter)
   XsCodOpe = OPER->CodOPE
   @ 5,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
   DO LIB_MTEC WITH 1
   @ 5,14 GET XsCodOpe PICT REPLICATE("9", LEN(OPER->CodOpe)) WHEN VarOpe
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8
      IF CBDBUSCA("OPER")
         XsCodOpe = CodOpe
      ELSE
         LOOP
      ENDIF
   ENDIF
   DO CASE
      CASE UltTecla = Escape

      CASE UltTecla = PgDn
         SKIP
         IF EOF()
            GOTO TOP
         ENDIF
      CASE UltTecla = PgUp
         SKIP - 1
         IF BOF()
            GOTO BOTTOM
         ENDIF
      OTHER
         IF !  XsCodOpe  =  OPER->CodOpe .OR. UltTecla = F8
            SEEK XsCodOpe
            IF ! FOUND()
               DO LIB_MERR WITH 9
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
   ENDCASE
ENDDO
@ 5,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
Save Screen to ScrMov
RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
@ 0,0 TO 23,79
@ 0,02 SAY "GENERACION DE ASIENTOS SEGUN MODELOS"

@ 6,0  SAY "Ã"
@ 6,1  TO  6,49
@ 6,79 SAY "³"

@ 0,50 SAY "Â"
@ 1,50 TO 6,50
@ 6,50 SAY "Ù"

@ 3,0 SAY "Ã"
@ 3,1 TO  3,49 COLOR SCHEME 7
@ 3,50 SAY "´"


@ 20,0  SAY "Ã"
@ 20,1 TO 20,78
@ 20,79 SAY "´"

@ 1,1  SAY PADR(" COMPA¥IA  : "+GsCodCia+" "+GsNomCia,49) COLOR SCHEME 7
@ 2,1  SAY PADR(" Usuario   : "+GsUsuario,49)             COLOR SCHEME 7
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9999 ")
nCol    = (49-LEN(cTitulo))/2
@ 3,1+nCol SAY cTitulo
@ 4,1 SAY PADR(" MODELO    : ",49) COLOR SCHEME 7
@ 5,1 SAY PADR(" OPERACION : ",49) COLOR SCHEME 7

@ 1,52 SAY "No. DOCUMENTO :"
@ 2,52 SAY "FECHA         :"
@ 3,52 SAY "MONEDA        :"
@ 4,52 SAY "TIPO DE CAMBIO:"
@ 5,52 SAY "REFERENCIA    :"
@ 7,2  SAY "OBSERVACIONES : "

@ 8,0  SAY "Ã"
@ 8,1  TO  8,78
@ 8,79 SAY "´"
@ 9,1  SAY  " COD.  COD.  Nro.       FECHA                              T                  " COLOR SCHEME 7
@10,1  SAY  " CTA.  AUXI. DOCUMENTO  VCTO.    DESCRIPCION               M       IMPORTE    " COLOR SCHEME 7
           *  2     8     14         25       34
           *0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
           *          1         2         3         4         5         6         7
*             XXXXX XXXXX XXXXXXXXXX XX/XX/XX XXXXXXXXXXXXXXXXXxxxxxxXX X US$999,999,999.99
@ 11,0  SAY "Ã"
@ 11,1  TO  11,78
@ 11,79 SAY "´"

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
IF OPER->TPOCOR = 1
   SEEK (XsNroMes+XsCodOpe+Chr(255))
ELSE
   SEEK (XsCodOpe+Chr(255))
ENDIF
IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
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
            IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
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
         IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
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
XsNroVou = SPACE(LEN(VMOV->NROVOU))
XiCodMon = VMDL->CodMon
XsNotAst = VMDL->NotAst
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
@ 5,1 SAY " OPERACION : "+OPER->CodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
@ 1,68 SAY VMOV->NroAst
@ 2,1  SAY PADR(" Usuario   : "+VMOV->Digita,49)             COLOR SCHEME 7
@ 2,68 SAY VMOV->FchAst
@ 3,68 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@ 4,68 SAY TpoCmb PICT "9999.9999"
@ 5,68 SAY VMOV->NroVou
@ 7,18 SAY VMOV->NOTAST
LinAct = 12
@ LinAct,1 CLEAR TO 22,78
IF VMOV->FlgESt = "A"
   @ LinAct,0 say []
   @ ROW()  ,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ ROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
   @ ROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
   @ ROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
   @ ROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ ROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
   @ ROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ELSE
   SELECT RMOV
   LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
   SEEK LsLLave
   DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF() .AND. ;
            LinAct < 20
      Contenido = ""
      DO MOVBLine WITH Contenido
      @ LinAct,2 SAY Contenido
      LinAct = LinAct + 1
      SKIP
   ENDDO
   @ 20,1 TO 20,78
   DO MovPImp
   @ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
ENDIF
SELECT VMOV
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
* Procedimiento de edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita
UltTecla = 0
IF ! Crear
   IF .NOT. RLock()
      GsMsgErr = "Asiento usado por otro usuario"
      DO LIB_MERR WITH 99
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
ENDIF
I        = 1
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         DO LIB_MTEC WITH 7
         @ 2,68 GET XdFchAst
         READ
         UltTecla = LastKey()
         @ 2,68 SAY XdFchAst
      CASE I = 2
         IF !Crear
            DO LIB_MTEC WITH 16
            VecOpc(1)="S/."
            VecOpc(2)="US$"
            DO CASE
               CASE OPER->CODMON = 1
                 XiCodMon= 1
               CASE OPER->CODMON = 2
                 XiCodMon= 2
               OTHER
                 XiCodMon= Elige(XiCodMon,3,68,2)
            ENDCASE
         ENDIF
         @ 3,68 SAY IIF(XiCODMON=1,"S/.","US$")
      CASE I = 3
         SELECT TCMB
         SEEK DTOC(XdFChAst,1)
         IF ! FOUND()
            OK = .F.
            ?? chr(7)
            WAIT "T/Cambio no registrado" NOWAIT WINDOW
            GOTO BOTTOM
         ENDIF
         IF Crear
            XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
         ENDIF
         DO LIB_MTEC WITH 7
         @ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
         READ
         UltTecla = LastKey()
         @ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
         IF ! OK
            APPEND BLANK
            REPLACE FCHCMB WITH XdFchast
         ENDIF
         IF OPER->TpoCmb=1
            IF OFICMP = 0
               REPLACE OFICMP WITH XfTpoCmb
            ENDIF
         ELSE
            IF OFIVTA = 0
               REPLACE OFIVTA WITH XfTpoCmb
            ENDIF
         ENDIF

      CASE I = 4
         @ 5 ,68 GET XsNroVou PICT "@!"
         READ
         UltTecla = LastKey()
         @ 5 ,68 SAY XsNroVou
      CASE I = 5   &&.AND. !Crear
         @ 7, 18 GET XsNotAst
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5,5, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT VMOV
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
IF Crear                  && Creando
   SELE OPER
   IF ! Rec_Lock(5)
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
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
ELSE
   *** ACTULIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
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
******************************************************************************
*  Proposito     : Procedimientos de browse (Ingresos de almacen)
******************************************************************************
PROCEDURE MOVBrows
IF UltTecla = Escape
   RETURN
ENDIF
UltTecla = 0
SelLin   = "MOVbcomp"
InsLin   = "MOVInser"
EscLin   = "MOVbline"
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbVeri"
MVprgF1  = [MOVF1]
MVprgF2  = []
MVprgF3  = [MOVF3]
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = ""                 && [BORRLIN]
PrgFin   = "MovFin"
Titulo   = []
NClave   = [NroMes+CodOpe+NroAst]
VClave   = XsNroMes+XsCodOpe+XsNroAst
HTitle   = 1
Yo       = 11
Xo       = 0
Largo    = 21 - Yo
Ancho    = 80
TBorde   = Nulo
Titulo   = []
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
SELECT RMOV
*** Variable a Conocer ****
XsCodCta = SPACE(LEN(RMOV->CodCta))
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsCodRef = SPACE(LEN(RMOV->CodRef))
XsGloDoc = SPACE(LEN(RMOV->GloDoc))
XdFchDoc = VMOV->FCHAST
*XdFchVto = {,,}
XdFchVto = {  ,  ,    }
XsCodDoc = SPACE(LEN(RMOV->CodDoc))
XsNroDoc = SPACE(LEN(RMOV->NroDoc))
XsNroRef = SPACE(LEN(RMOV->NroRef))
XsNroCaj = SPACE(6)
XsIniAux = SPACE(LEN(RMOV->IniAux))
XsNroRuc = SPACE(LEN(RMOV->NroRuc))
XiCodMon = VMOV->CodMon
XfTpoMon = VMOV->TpoCmb
XcTpoMov = "D"
XfImport = 0.00
XiNroItm = VMOV->NroItm+1
XiNroItm = 1
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recacula [F7] Distribuye"
DO LIB_MTEC WITH 14
DO DBrowse
SELECT VMOV
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVbline
PARAMETERS Contenido
Contenido = CodCta+EliItm+CodAux+" "+Nrodoc+" "
IF EMPTY(FchVto)
   Contenido = Contenido + SPACE(9)
ELSE
   XsFchVto = LEFT(DTOC(FchVto),6)+RIGHT(DTOC(FchVto),2)
   Contenido = Contenido + XsFchVto + " "
ENDIF
Contenido = Contenido+LEFT(GloDoc,24)+" "+TpoMov+"    "
IF VMOV->CodMon <> 1
   Contenido = Contenido + TRAN(ImpUsa,"999,999,999.99")
ELSE
   Contenido = Contenido + TRAN(Import,"999,999,999.99")
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Complementa una linea del browse
******************************************************************************
PROCEDURE MOVbcomp
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
@ 21,1 clear to 22,78
=SEEK(RMOV->CodCta,"CTAS")
IF ! EMPTY(CODAUX)
   =SEEK(CLFAUX+CODAUX,"AUXI")
   @ 22,1 SAY "AUXILIAR: "+AUXI->NomAux
ENDIF
IF CodAux="09990"
   @ 22,1 clear to 22,78
   @ 22,01 SAY "Iniciales:"  COLOR SCHEME 11
   @ 22,12 SAY IniAux
   @ 22,60 SAY "R.U.C. :"    COLOR SCHEME 11
   @ 22,69 SAY NroRuc
ENDIF
IF RMOV->CODMON = 1
   @ 21,60  SAY "US$"  COLOR SCHEME 11
   @ 21,64  SAY IMPUSA  PICTURE "999,999,999.99"  COLOR SCHEME 11
ELSE
   @ 21,60  SAY "S/."  COLOR SCHEME 11
   @ 21,64  SAY IMPORT  PICTURE "999,999,999.99"  COLOR SCHEME 11
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit
IF ! Crear
  *IF INLIST(EliItm , "ú")
   IF INLIST(EliItm , "*")  
      GsMsgErr = " L¡nea no puede ser modificada "
      DO LIB_MERR WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   XsCodCta = RMOV->CodCta
   XsClfAux = RMOV->ClfAux
   XsCodAux = RMOV->CodAux
   XsCodRef = RMOV->CodRef
   XcTpoMov = RMOV->TpoMov
   IF RMOV->CodMon = 1
      XfImport = RMOV->Import
   ELSE
      XfImport = RMOV->ImpUsa
   ENDIF
   XiNroItm = RMOV->NroItm
   XsGloDoc = RMOV->GloDoc
   XdFchDoc = RMOV->FchDoc
   XdFchVto = RMOV->FchVto
   XsCodDoc = RMOV->CodDoc
   XsNroDoc = RMOV->NroDoc
   XsNroRef = RMOV->NroRef
   XiCodMon = RMOV->CodMon
   XfTpoCmb = RMOV->TpoCmb
   XsIniAux = RMOV->IniAux
   XsNroRuc = RMOV->NroRuc
   IF OPER->CodMon = 4
      XiCodMon = RMOV->CodMon
      XfTpoCmb = RMOV->TpoCmb
   ENDIF
ELSE
   XsCodRef = SPACE(LEN(RMOV->CodRef))
   XsNroRef = SPACE(LEN(RMOV->NroRef))
   XdFchDoc = VMOV->FCHAST
  *XdFchVto = {,,}
   XdFchVto = {  ,  ,    }  
   XsCodDoc = SPACE(LEN(RMOV->CodDoc))
   XsNroDoc = SPACE(LEN(RMOV->NroDoc))
   XsCodAux = SPACE(LEN(RMOV->CodAux))
   XsNroCaj = SPACE(6)
   XiCodMon = VMOV->CodMon
   XfTpoMon = VMOV->TpoCmb
   XiNroItm = VMOV->NroItm+1
   @ 21,1 CLEAR TO 22,78
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1

LinRef = 0
LinCta = 2
LinAux = LinCta + 6
LinDoc = LinAux + 6
LinVto = LinDoc + 11
LinGlo = LinVto + 9
LinTpo = LinGlo + 25
LinImp = LinTpo + 2

UltTecla = 0
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELECT CTAS
         @ LinAct,LinCta GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ LinAct,LinCta SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         IF CTAS->AFTMOV#"S"
            GsMsgErr = "Cuenta no Afecta a movimiento"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 21,1 CLEAR TO 22,78
         @ 21,1 SAY "CUENTA CONTABLE  : "+CTAS->NomCta
      CASE i = 2 .AND. CTAS->PidAux = [S]
         SELECT TABL
         XsTabla = "01"
         IF EMPTY(CTAS->CLFAUX)
            GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
            DO LIB_MERR WITH 99
            UltTecla = Escape
            EXIT
         ELSE
            XsClfAux = CTAS->ClfAux
         ENDIF
         SEEK XsTabla+XsClfAux
         IF ! FOUND()
            GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
            DO LIB_MERR WITH 99
            UltTecla = Escape
            EXIT
         ENDIF
         @ 22,1 SAY "Tipo de Auxiliar : "+TABL->Nombre
         iDigitos = TABL->Digitos
         IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
            iDigitos = LEN(XsCodAux)
         ENDIF
         SELECT AUXI
         @ LinAct,LinAux GET XsCodAux PICT REPLICATE("9",iDigitos)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("AUXI")
               LOOP
            ENDIF
            XsCodAux = AUXI->CodAux
         ELSE
            XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
         ENDIF
         XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAUX))
         @ LinAct,LinAux SAY XsCodAux
         SEEK XsClfAux+XsCodAux
         IF ! FOUND()
            DO Lib_MErr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         @ 22,1 SAY "AUXIL. : "+AUXI->NomAux
      CASE i = 2 .AND. CTAS->PidAux # [S]
         XsClfAux = SPACE(LEN(RMOV->CLFAUX))
         XsCodAux = SPACE(LEN(RMOV->CODAUX))
      CASE i = 3 .AND. CTAS->PidDoc=[S]
         ** No modificar documento en caso de Proveedores y Modificacion **
         DO CASE
            CASE OPER->Origen .AND. LEFT(XsCodCta,4)="4211" .AND. Crear
               ** Generamos Numero de Documento **
               *XsNroDoc = XsNroMes+RIGHT(XsNroAst,4)
               *XsNroDoc = XsNroAst+RIGHT(STR(_ANO,2),2)
               XsNroDoc = XsNroVou  && RHC pedido x Guillermo el 20/06/94
               ** Buscamos Datos por Defecto **
               IF SEEK(XsNroMes+XsNroDoc,"DPRO")
                  ** verificar el mes contable **
                  ** activar cuando sea necesario **
                  *IF DPRO->NroMes # XsNroMes
                  *   GsMsgErr = [Docmto del Proveedor NO corresponde al mes Contable]
                  *   DO lib_merr WITH 99
                  *   i = i - 1
                  *   LOOP
                  *ENDIF
                  XdFchVto = DPRO->FchVto
                  XiCodMon = DPRO->CodMon
                  XfImport = DPRO->Import
                  XsNroRef = DPRO->NroDoc
                  XdFchDoc = DPRO->FchDoc
                  XsNroRuc = DPRO->RucAux
                  XsCodDoc = DPRO->CodDoc
               ENDIF
               @ LinAct,LinDoc GET XsNroDoc PICT "@!" VALID ! EMPTY(XsNroDoc)
               READ
               UltTecla = LASTKEY()
        ****CASE !(OPER->Origen .AND. LEFT(XsCodCta,4)="4211")
            OTHER
               @ LinAct,LinDoc GET XsNroDoc PICT "@!" VALID ! EMPTY(XsNroDoc)
               READ
               UltTecla = LASTKEY()
         ENDCASE
         @ LinAct,LinDoc SAY XsNroDoc
      CASE i = 3 .AND. CTAS->PidDoc # [S]
         XsNroDoc = SPACE(LEN(RMOV->NroDoc))
      CASE i = 4
         IF CTAS->PidDoc="S"
            @ LinAct,LinVto GET XdFchVto
            READ
            UltTecla = LastKey()
            @ LinAct,LinVto SAY XdFchVto
         ELSE
           *XdFchVto = {,,}
            XdFchVto = {  ,  ,    }           
         ENDIF
      CASE i = 5
         @ LinAct,LinGlo GET XsGloDoc PICT "@!S24"
         READ
         UltTecla = LastKey()
         @ LinAct,LinGlo SAY XsGloDoc PICT "@S24"
      CASE i = 6
         VecOpc(1)="D"
         VecOpc(2)="H"
         XcTpoMov= Elige(XcTpoMov,LinAct,LinTpo,2)
      CASE i = 7 .AND. OPER->CodMon = 4
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,LinAct,Linimp,2)
      CASE i = 8
         @ LinAct,LinImp SAY IIF(XiCodmon=1,"S/.","US$")
         @ LinAct,LinImp+3 GET XfImport PICT "999,999,999.99" VALID XfImport > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,LinImp SAY XfImport PICT "999,999,999.99"
      CASE i = 9  .AND. CTAS->PidGlo = "S"
         @ 21,1 CLEAR TO 22,78
         @ 21,01 SAY "N§ Doc.:"
         @ 21,14 GET XsNroRef PICT "@!"
         @ 21,50 SAY "Fecha Documento:" GET XdFchDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 10 .AND. XsCodAux="09990"
         IF Crear
            XsIniAux = LEFT(XsGloDoc,8)
         ENDIF
         @ 22,01 SAY "Iniciales:"  COLOR SCHEME 11
         @ 22,12 GET XsIniAux    PICT "@!"
         @ 22,60 SAY "R.U.C. :"      COLOR SCHEME 11
         @ 22,69 GET XsNroRuc    PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 11
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>11,11, i)
   i = IIF(i<1, 1, i)
ENDDO

SELECT RMOV
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
FUNCTION _CodDoc
*****************
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
*DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "ú"
DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
   DO BORRLIN
   REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
   SKIP
ENDDO
DO RenumItms WITH XiNroItm
DO MovPImp
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
IF ! REC_LOCK(5)
   UltTecla = Escape
ENDIF
** Anulamos Provision del Proveedor **
IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
   ** Buscamos documento Provisionado
   IF SEEK(RMOV->CodAux+[P]+RMOV->NroDoc,"DPRO")
      IF RLOCK("DPRO")
         REPLACE DPRO->NroAst WITH []
        *REPLACE DPRO->FchAst WITH {,,}
         REPLACE DPRO->FchAst WITH {  ,  ,    }        
         REPLACE DPRO->FlgEst WITH [R]   && Recepcionado
         UNLOCK IN "DPRO"
      ENDIF
   ENDIF
ENDIF
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
DO MOVbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   IF ! Crear
      *** anulando cuentas autom ticas anteriores ***
      SKIP
      XinroItm = NroItm
     *DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "ú"
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
LsCtaAut = XsCodCta
*XcEliItm = "ú"
XcEliItm = "*"
TsClfAux = "04 "
TsCodAux = CTAS->TpoGto
*TsAn1Cta = CTAS->An1Cta
TsAn1Cta = RMOV->CodAux
TsCC1Cta = CTAS->CC1Cta
  ** Verificamos su existencia **
IF ! SEEK(TsAn1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
*****
DO CompBrows WITH .F.
SKIP
Crear = .T.
*IF EliItm = "ú" .AND. &RegVal
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
DO MOVbGrab
DO CompBrows WITH Crear
SKIP
Crear = .T.
*IF EliItm = "ú" .AND. &RegVal
IF EliItm = "*" .AND. &RegVal
   Crear = .F.
ENDIF
** Grabando la segunda cuenta autom tica **
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
XsClfAux = SPACE(LEN(RMOV->CLFAUX))
XsCodAux = SPACE(LEN(RMOV->CODAUX))
DO MOVbGrab
@ LinIni,Xo+1 FILL TO LinIni+Actual-1,X1-1 COLOR SCHEME 1
IF Crear
   SCROLL LinIni+Actual-1,Xo+1,Y1,X1-1,-1
ENDIF
XsCodCta = LsCtaAut
RETURN
**********************************************************************
* Inserta Items
**********************************************************************
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
PROCEDURE MOVbgrab
DO LIB_MSGS WITH 4
SELE RMOV
IF Crear
   APPEND BLANK
ENDIF
IF ! Rec_Lock(5)
   RETURN
ENDIF
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
   ** anulamos Provision del Proveedor **
   IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
      ** Buscamos documento Provisionado
      IF SEEK(RMOV->CodAux+[P]+RMOV->NroDoc,"DPRO")
         IF RLOCK("DPRO")
            REPLACE DPRO->NroAst WITH []
           *REPLACE DPRO->FchAst WITH {,,}
            REPLACE DPRO->FchAst WITH {  ,  ,    }           
            REPLACE DPRO->FlgEst WITH [R]   && Recepcionado
            UNLOCK IN "DPRO"
         ENDIF
      ENDIF
   ENDIF
ENDIF
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
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
REPLACE RMOV->GloDoc WITH XsGloDoc
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
** actualizamos Provision del Proveedor **
IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
   ** Buscamos documento
   IF SEEK(RMOV->CodAux+[R]+RMOV->NroDoc,"DPRO")
      IF RLOCK("DPRO")
         REPLACE DPRO->NroAst WITH XsNroAst
         REPLACE DPRO->FchAst WITH XdFchAst
         REPLACE DPRO->FlgEst WITH [P]   && Provisionado
         UNLOCK IN "DPRO"
      ENDIF
   ENDIF
ENDIF

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
**********************************************************************
* Pinta Importe Totales
**********************************************************************
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
**********************************************************************
* Pantalla de Ayuda    ===============================================
**************************************************************************
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
**********************************************************************
* Regenerar Acumulados ===============================================
**********************************************************************
PROCEDURE MovF3
*******************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
@ 11,23 SAY "³    R E C A L C U L A N D O    ³" COLOR SCHEME 7
@ 12,23 SAY "³  Espere un momento por favor  ³" COLOR SCHEME 7
@ 13,23 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes *************************
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
IF REC_LOCK(5)
   REPLACE VMOV->ChkCta  WITH T_Ctas
   REPLACE VMOV->DbeNac  WITH T_DbeNac
   REPLACE VMOV->DbeUsa  WITH T_DbeUsa
   REPLACE VMOV->HbeNac  WITH T_HbeNac
   REPLACE VMOV->HbeUsa  WITH T_HbeUsa
   REPLACE VMOV->NroItm  WITH T_Itms
ENDIF
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
* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
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

******************
PROCEDURE IMPRVOUC
******************
PRIVATE Largo,Ancho,Temp
SAVE SCREEN TO Temp
REGACT=RECNO()
DO DIRPRINT IN ADMPRINT
IF LASTKEY() = ESCAPE
   RESTORE SCREEN FROM TEMP
   RETURN
ENDIF
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Tit_I_CEN= []
TITULO   = ""
SUBTITULO = ""
IniImp   = _Prn3    && 16.6 cpi
Largo    = 66
LinFin   = Largo - 5
Ancho    = 140
numpag  = 0
En1 =[]
En2 =[]
En3 =[]
En4 =[]
En5 = "***** ********** ************************* ****** ************************************************** ****************** ******************"
En6 = "COD.                D O C U M E N T O      CUENTA                                                                                         "
En7 = "AUXI-  N§        ************************* CONTAB               D E S C R I P C I O N                    C A R G O S         A B O N O S  "
En8 = "LIAR  REFERENCIA Tpo   No.        VENCTO.                                                                                                 "
En9 = "***** ********** *** ********** ********** ****** ************************************************** ****************** ******************"
*      12345 1234567890 123 1234567890 1234567890 123456 12345678901234567890123456789012345678901234567890
*      00    06         17  21         32         43     50                                                 101                120
SET DEVICE TO PRINTER
PRINTJOB
   sKey = XsNroMes+XsCodOpe+XsNroAst
   =SEEK(sKey,"VMOV")
   =SEEK(VMOV.CodOpe,'OPER')
   LsNomOpe=OPER->NomOpe
   DO MovMemb
   nDbe = 0
   nHbe = 0
   SELECT RMOV
   cNroChq = []
   SEEK XsNroMes+XsCodOpe+XsNroAst
   DO WHILE  ! EOF() .AND. sKey = RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst
    *IF ELIITM#'ú'
     IF ELIITM#[*]    
        IF Prow() > (Largo - 4)
          DO MovMemb
        ENDIF
        NumLin = Prow() + 1
        @ NumLin,00  SAY CodAux
        @ NumLin,06  SAY NroRef
        @ NumLin,17  SAY CodDoc
        @ NumLin,21  SAY NroDoc
        IF ! EMPTY(FchVto)
           @ NumLin,32  SAY FchVto
        ENDIF
        @ NumLin,43  SAY CodCta
        @ NumLin,43  SAY CodCta
        =SEEK(ClfAux+CodAux,"AUXI")
        DO CASE
           CASE ! EMPTY(RMOV->Glodoc)
              LsGlodoc = LEFT(RMOV->GloDoc,50)
           CASE ! EMPTY(VMOV->NotAst)
              LsGlodoc = LEFT(VMOV->NotAst,50)
           OTHER
              LsGlodoc = LEFT(AUXI->NOMAUX,50)
        ENDCASE
        IF RMOV->CodMon <> 1
           LsImport = 'US$' + ALLTRIM(STR(ImpUsa,14,2))
           IF RIGHT(LsImport,3)=".00"
              LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
           ENDIF
           LsGloDoc = LEFT(LsGloDoc,50-LEN(LsImport))+LsImport
        ENDIF
        @ NumLin,50  SAY LsGloDoc PICT "@S50"
        DO CalImp
        IF TpoMov='D'
           @ NumLin,101 SAY nImpNac PICT "999,999,999.99"
           nDbe = nDbe + nImpNac
        ELSE
           @ NumLin,120 SAY nImpNac PICT "999,999,999.99"
           nHbe = nHbe + nImpNac
        ENDIF
     ENDIF
     SKIP
   ENDDO
   IF Prow() > (Largo - 10)
     DO MovMemb
   ENDIF
   NumLin = PROW() + 2
   @ NumLin,80  SAY _Prn7a+"TOTALES"+_Prn7B
   @ NumLin,0  SAY [ ]
   @ NumLin,101 SAY _Prn6a
   @ NumLin,101 SAY nDbe PICT "999,999,999.99"
   @ NumLin,120 SAY nHbe PICT "999,999,999.99"
   @ NumLin,Ancho-1 SAY _Prn6a
   DO MovIPie
ENDPRINTJOB
EJECT PAGE
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RESTORE SCREEN FROM Temp
RETURN
**********************************************************************
PROCEDURE MovMemb
*****************
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF
IF NumPag > 0
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VAN ......"
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,134 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
@ 0,0  SAY IniImp
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b
@ 2,0  SAY GsDirCia
@ 2,Ancho - 33  SAY "OPERACION  "+_Prn7a+Vmov->CodOpe+_Prn7b
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho - 33  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b
@ 4,0           SAY cTitulo
@ 4,Ancho - 54  SAY "MONEDA     "+IIF(Vmov->CodMon=1,"S/.","US$")
@ 4,Ancho - 33  SAY "REFERENCIA "+VMOV->NroVou
@ 5,0           SAY Vmov->NotAst
@ 5,Ancho - 54  SAY "T/C   "+TRAN(VMOV->TpoCmb,"##,###.####")
@ 5,Ancho - 33  SAY "Fecha      "+DTOC(Vmov->FchAst)
@ 6, 0          SAY En5
@ 7, 0          SAY En6
@ 8, 0          SAY En7
@ 9, 0          SAY En8
@ 10,0          SAY En9
IF NumPag > 1
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VIENEN ..."
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,134 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                             _________________________________________________________________"
Pn2 = "                                                                                                                  Recibi Conforme                         "
Pn3 = "                                                                                                                                                          "
Pn4 = "_______________ _______________ _______________                                          L.E. /L.T. No : _________________________________________________"
Pn5 = PADC(VMOV->Digita,15)
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn2
@ NumLin+3,0    SAY Pn3
@ NumLin+4,0    SAY Pn4
@ NumLin+5,0    SAY Pn5
RETURN
******************
PROCEDURE MOVEimpG
******************
PRIVATE i
Ngl = 0
STORE 0 TO V1,V2,V3,V4
FOR kk = 1 TO 4
    LsGlosa = "GIMPO"+TRANS(kk,"9")
    IF !EMPTY(&LsGlosa)
       Ngl = Ngl + 1
    ENDIF
ENDFOR
xAncho = LEN(VMDL->Gimpo1)+LEN(sFmt)+3
Save screen To PANT1
UltTecla = 0
CordX = 12
CordY = 22
@ CordX,CordY CLEAR TO (CordX+1 + Ngl),CordY+xAncho
@ CordX,CordY FILL TO (CordX+1 + Ngl),CordY+xAncho COLOR SCHEME 7
@ CordX,CordY TO (CordX+1 + Ngl),CordY+xAncho DOUBLE
@ CordX,CordY+11 SAY "** IMPORTES **" COLOR SCHEME 7
ColIni = CordY + 1
LinIni = CordX + 1
LinImp = CordX + 1
IF !EMPTY(VMDL->GImpo1)
   @ LinImp,ColIni SAY VMDL.Gimpo1 PICT "@!"
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo2)
   @ LinImp,ColIni SAY VMDL.Gimpo2 PICT "@!"
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo3)
   @ LinImp,ColIni SAY VMDL.Gimpo3 PICT "@!"
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo4)
   @ LinImp,ColIni SAY VMDL.Gimpo4 PICT "@!"
   LinImp = LinImp + 1
ENDIF
IF LinImp<4
   RESTORE SCREEN FROM PANT1
   RETURN
ENDIF
ColImp = LEN(Gimpo1) + 1
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1 .AND. !EMPTY(VMDL->GImpo1)
         @ LinIni + 0 ,ColIni + ColImp GET L1 PICT sFmt  VALID L1<>0
         READ
         UltTecla = LASTKEY()
      CASE i = 2 .AND. !EMPTY(VMDL->GImpo2)
         @ LinIni + 1 ,ColIni + ColImp GET L2 PICT sFmt  VALID L2<>0
         READ
         UltTecla = LASTKEY()
      CASE i = 3 .AND. !EMPTY(VMDL->GImpo3)
         @ LinIni + 2 ,ColIni + ColImp GET L3 PICT sFmt  VALID L3<>0
         READ
         UltTecla = LASTKEY()
      CASE i = 4 .AND. !EMPTY(VMDL->GImpo4)
         @ LinIni + 3 ,ColIni + ColImp GET L4 PICT sFmt  VALID L4<>0
         READ
         UltTecla = LASTKEY()
      CASE i = 5
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>05,05, i)
   i = IIF(i<1, 1, i)
ENDDO
FOR kk = 1 TO 4
    Campo = "L"+TRANS(kk,"9")
    Campo2= "V"+TRANS(kk,"9")
    IF &Campo<>0
       &Campo2 = TRANS(&Campo ,"999999999.99")
    ENDIF
ENDFOR
RESTORE SCREEN FROM PANT1
RETURN
******************
PROCEDURE MovBrowM
******************
IF UltTecla = Escape
   RETURN
ENDIF
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle,PrgFin
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
Yo       = 11
Xo       = 00
Largo    = 21 - 11
Ancho    = 80       &&
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
PrgFin   = "CHKDesbal"
MaxEle   = MaxEle1
TotEle   = MaxEle1  && M ximos elementos a usar
** Variables para la edici¢n **
LinRef = 0
LinCta = 2
LinAux = LinCta + 6
LinDoc = LinAux + 6
LinVto = LinDoc + 11
LinGlo = LinVto + 9
LinTpo = LinGlo + 25
LinImp = LinTpo + 2
***
LnNeto = 0
DO CalNeto
DO ABROWSE
MaxEle1 = MaxEle
*IF MaxEle1 = 1 .AND. EMPTY(vCodAgp(1))
*   MaxEle1 = 0
*ENDIF
IF LASTKEY() = Escape
   RETURN
ENDIF
RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin
*@ NumLin,Xo + LinRef     SAY vCodRef(NumEle) PICT "@!"
@ NumLin,Xo + LinCta     SAY vCodCta(NumEle) PICT "@!"
@ NumLin,Xo + LinAux     SAY vCodAux(NumEle) PICT "@!"
@ NumLin,Xo + LinDoc     SAY vNroDoc(NumEle) PICT "@!"
@ NumLin,Xo + LinVto     SAY vFchvto(NumEle)
@ NumLin,Xo + LinGlo     SAY vGloDoc(NumEle) PICT "@S20"
@ NumLin,Xo + LinTpo     SAY vTpoMov(NumEle) PICT "@!"
@ NumLin,Xo + LinImp     SAY IIF(vCodMon(NumEle)=1,"S/.","US$")
@ NumLin,Xo + LinImp+3   SAY vImport(NumEle) PICT "999999999.99"
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin, LiUtecla
UltTecla = 0
LsCodRef = vCodRef(NumEle)
LsCodCta = vCodCta(NumEle)
LsCodAux = vCodAux(NumEle)
LsClfAux = vClfAux(NumEle)
LsNroDoc = vNroDoc(NumEle)
LdFchVto = vFchVto(NumEle)
LsGloDoc = vGloDoc(NumEle)
LcTpoMov = vTpoMov(NumEle)
LiCodMon = vCodMon(NumEle)
LfImport = vImport(NumELe)
LsCodDoc = vCodDoc(NumEle)
LsNroRef = vNroRef(NumEle)
LsImport = sImport(NumEle)
LsNroRuc = vNroRuc(NumEle)
LsIniAux = vIniAux(NumEle)
LdFchDoc = vFchDoc(NumEle)
i = 1
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba,Abajo)
   DO CASE
      CASE i = 1
         SELECT CTAS
         @ NumLin,LinCta GET LsCodCta PICT REPLICATE("9",LEN(LsCodCta))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(LsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            LsCodCta = CTAS->CodCta
         ENDIF
         @ NumLin,LinCta SAY LsCodCta
         SEEK LsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         IF CTAS->AFTMOV#"S"
            GsMsgErr = "Cuenta no Afecta a movimiento"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 21,1 CLEAR TO 22,78
         @ 21,1 SAY "CUENTA CONTABLE  : "+CTAS->NomCta

      CASE i = 2
         IF CTAS->PIDAUX="S"
            SELECT TABL
            XsTabla = "01"
            IF EMPTY(CTAS->CLFAUX)
               GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
               DO LIB_MERR WITH 99
               UltTecla = Escape
               EXIT
            ELSE
               LsClfAux = CTAS->ClfAux
            ENDIF
            SEEK XsTabla+LsClfAux
            IF ! FOUND()
               GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
               DO LIB_MERR WITH 99
               UltTecla = Escape
               EXIT
            ENDIF
            @ 22,1 SAY "Tipo de Auxiliar : "+TABL->Nombre
            iDigitos = TABL->Digitos
            IF iDigitos < 0 .OR. iDigitos > LEN(LsCodAux)
               iDigitos = LEN(LsCodAux)
            ENDIF
            SELECT AUXI
            @ NumLin,LinAux GET LsCodAux PICT REPLICATE("9",iDigitos)
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
               LOOP
            ENDIF
            IF UltTecla = F8
               IF ! CBDBUSCA("AUXI")
                  LOOP
               ENDIF
               LsCodAux = TRIM(AUXI->CodAux)
            ELSE
               XsCod11 = TRIM(AUXI->CodAux)
               LsCodAux = PADR(LsCodAux,LEN(XsCod11))
            ENDIF
            @ NumLin,LinAux SAY LsCodAux
            SEEK LsClfAux+LsCodAux
            IF ! FOUND()
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 22,1 SAY "AUXIL. : "+AUXI->NomAux
         ELSE
            LsClfAux = SPACE(LEN(RMOV->CLFAUX))
            LsCodAux = SPACE(LEN(RMOV->CODAUX))
         ENDIF
      CASE i = 3
         IF CTAS->PidDoc="S"
            DO CASE
               CASE OPER->Origen .AND. LEFT(LsCodCta,4)="4211" .AND. Crear
                  ** Generamos Numero de Documento **
                   LsNroDoc = XsNroMes+RIGHT(XsNroAst,4)
                   LsNroDoc = XsNroAst+"-"+RIGHT(TRAN(_ANO,"####"),2)+" "
                  ** Buscamos Datos por Defecto **
                  IF SEEK(XsNroMes+LsNroDoc,"DPRO")
                     ** verificar el mes contable **
                     ** activar cuando sea necesario **
                     *IF DPRO->NroMes # XsNroMes
                     *   GsMsgErr = [Docmto del Proveedor NO corresponde al mes Contable]
                     *   DO lib_merr WITH 99
                     *   i = i - 1
                     *   LOOP
                     *ENDIF
                     LdFchVto = DPRO->FchVto
                     LiCodMon = DPRO->CodMon
                     LfImport = DPRO->Import
                     LsNroRef = DPRO->NroDoc
                     LdFchDoc = DPRO->FchDoc
                     LsNroRuc = DPRO->RucAux
                     LsCodDoc = DPRO->CodDoc
                  ENDIF
                  @ NumLin,LinDoc GET LsNroDoc PICT "@!" VALID ! EMPTY(LsNroDoc)
                  READ
                  UltTecla = LASTKEY()
           ****CASE !(OPER->Origen .AND. LEFT(LsCodCta,4)="4211")
               OTHER
                  @ NumLin,LinDoc GET LsNroDoc PICT "@!" VALID ! EMPTY(LsNroDoc)
                  READ
                  UltTecla = LASTKEY()
            ENDCASE
            @ NumLin,LinDoc SAY LsNroDoc
         ELSE
            LsNroDoc = SPACE(LEN(RMOV->NroDoc))
            LsCodDoc = SPACE(LEN(RMOV->CodDoc))
         ENDIF
      CASE i = 4
         IF CTAS->PidDoc="S"
            @ NumLin,LinVto GET LdFchDoc
            READ
            UltTecla = LastKey()
            @ NumLin,LinVto SAY LdFchDoc
         ELSE
           *LdFchVto = {,,}
            LdFchVto = {  ,  ,    }           
         ENDIF
      CASE i = 5
         @ NumLin,LinGlo GET LsGloDoc PICT "@!S24"
         READ
         UltTecla = LastKey()
         @ NumLin,LinGlo SAY LsGloDoc PICT "@S24"
      CASE i = 6
         VecOpc(1)="D"
         VecOpc(2)="H"
         LcTpoMov= Elige(LcTpoMov,NumLin,LinTpo,2)
      CASE i = 7 .AND. OPER->CodMon = 4
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         LiCodMon= Elige(LiCodMon,NumLin,LinImp,2)
      CASE i = 8
         DO CASE
            CASE TRIM(LsImport) = "?"  .or. TRIM(LsImport) = "NETO"
              @ NumLin,LinImp SAY IIF(LiCodmon=1,"S/.","US$")
              @ NumLin,LinImp+3 GET LfImport PICT "999999999.99" VALID LfImport >=0
              READ
              UltTecla = LASTKEY()
           *CASE TRIM(LsImport) = "NETO"
           *  Do CalNeto
           *  Lfimport = vImport(LnNeto)
         ENDCASE
         @ NumLin,LinImp SAY LfImport PICT "999,999,999.99"
      CASE i = 09 .AND. CTAS->PidGlo = "S"
         @ 21,1 CLEAR TO 22,78
         @ 21,01 SAY "N§ Doc.:"
         @ 21,14 GET LsNroRef PICT "@!"
         @ 21,50 SAY "Fecha Documento:" GET LdFchDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 10 .AND. LsCodAux="09990"
         IF Crear
            LsIniAux = LEFT(LsGloDoc,8)
         ENDIF
         @ 22,01 SAY "Iniciales:"  COLOR SCHEME 11
         @ 22,12 GET LsIniAux    PICT "@!"
         @ 22,60 SAY "R.U.C. :"      COLOR SCHEME 11
         @ 22,69 GET LsNroRuc    PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 11
         IF UltTecla = Enter
            EXIT
         ENDIF
         IF INLIST(UltTecla,F10,CTRLw)
            UltTecla = CtrlW
            EXIT
         ENDIF
         i = 1
   ENDCASE
   IF INLIST(UltTecla,Izquierda,Derecha,PgDn,PgUp,Home,End)
      EXIT
   ENDIF
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>11,11, i)
   i = IIF(i<1, 1, i)
ENDDO
IF UltTecla <> Escape
   vCodRef(NumEle) = LsCodRef
   vCodCta(NumEle) = LsCodCta
   vCodAux(NumEle) = LsCodAux
   vNroDoc(NumEle) = LsNroDoc
   vFchVto(NumEle) = LdFchVto
   vFchDoc(NumEle) = LdFchDoc
   vGloDoc(NumEle) = LsGloDoc
   vTpoMov(NumEle) = LcTpoMov
   vCodMon(NumEle) = LiCodMon
   vImport(NumELe) = LfImport
   vCodDoc(NumEle) = LsCodDoc
   vNroRef(NumEle) = LsNroRef
   vNroRuc(NumEle) = LsNroRuc
   vIniAux(NumEle) = LsIniAux
   DO MOVPimpM
ENDIF
IF UltTecla = Escape
   UltTecla = Abajo
ENDIF
LiUTecla = UltTecla
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   vCodRef(i) = vCodRef(i+1)
   vCodCta(i) = vCodCta(i+1)
   vCodAux(i) = vCodAux(i+1)
   vNroDoc(i) = vNroDoc(i+1)
   vFchVto(i) = vFchVto(i+1)
   vFchDoc(i) = vFchDoc(i+1)
   vGloDoc(i) = vGloDoc(i+1)
   vTpoMov(i) = vTpoMov(i+1)
   vCodMon(i) = vCodMon(i+1)
   vImport(i) = vImport(i+1)
   vCodDoc(i) = vCodDoc(i+1)
   vNroRef(i) = vNroRef(i+1)
   vNroRuc(i) = vNroRuc(i+1)
   vIniAux(i) = vIniAux(i+1)
   i = i + 1
ENDDO
vCodRef(i) = SPACE(LEN(RMOV->CodReF))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroDoc(i) = SPACE(LEN(RMOV->NroDoc))
*vFchVto(i) = {,,}
vFchVto(i) = {  ,  ,    }
vFchDoc(i) = XdFchAst
vGloDoc(i) = SPACE(LEN(RMOV->GloDoc))
vTpoMov(i) = SPACE(LEN(RMOV->TpoMov))
vCodMon(i) = VMDL->CodMon
vImport(i) = 0
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vNroRef(i) = SPACE(LEN(RMOV->NroRef))
vNroRuc(i) = SPACE(LEN(RMOV->NroRuc))
vIniAux(i) = SPACE(LEN(RMOV->IniAux))
Estado = .T.
RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse
PARAMETERS ElePrv, Estado
PRIVAT  i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vCodRef(i) = vCodRef(i-1)
   vCodCta(i) = vCodCta(i-1)
   vCodAux(i) = vCodAux(i-1)
   vNroDoc(i) = vNroDoc(i-1)
   vFchVto(i) = vFchVto(i-1)
   vGloDoc(i) = vGloDoc(i-1)
   vTpoMov(i) = vTpoMov(i-1)
   vCodMon(i) = vCodMon(i-1)
   vImport(i) = vImport(i-1)
   vCodDoc(i) = vCodDoc(i-1)
   vNroRef(i) = vNroRef(i-1)
   vNroRuc(i) = vNroRuc(i-1)
   vIniAux(i) = vIniAux(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
vCodRef(i) = SPACE(LEN(RMOV->CodReF))
vCodCta(i) = SPACE(LEN(RMOV->CodCta))
vCodAux(i) = SPACE(LEN(RMOV->CodAux))
vNroDoc(i) = SPACE(LEN(RMOV->NroDoc))
*vFchVto(i) = {,,}
vFchVto(i) = {  ,  ,    }
vGloDoc(i) = SPACE(LEN(RMOV->GloDoc))
vTpoMov(i) = SPACE(LEN(RMOV->TpoMov))
vCodMon(i) = VMDL->CodMon
vImport(i) = 0
vCodDoc(i) = SPACE(LEN(RMOV->CodDoc))
vNroRef(i) = SPACE(LEN(RMOV->NroRef))
vNroRuc(i) = SPACE(LEN(RMOV->NroRuc))
vIniAux(i) = SPACE(LEN(RMOV->IniAux))
Estado = .T.
RETURN
******************
PROCEDURE MOVPimpM
******************
PRIVATE j
Store 0 TO ZfImpNac,ZfImpUsa,TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
FOR j = 1 TO MaxEle1
    IF vCodMon(j) = 1
       ZfImpNac = vImport(j)
       IF XfTpoCmb = 0
         ZfImpUsa = 0
       ELSE
         ZfImpUsa = round(vImport(j)/XfTpoCmb,2)
       ENDIF
    ELSE
       ZfImpNac =  round(vImport(j)*XfTpoCmb,2)
       ZfImpUsa =  vImport(j)
    ENDIF
    IF vTpoMov(j)='D'
       TfDbeNac = TfDbeNac + ZfImpNac
       TfDbeUsa = TfDbeUsa + ZfImpUsa
    ELSE
       TfHbeNac = TfHbeNac + ZfImpNac
       TfHbeUsa = TfHbeUsa + ZfImpUsa
    ENDIF
    IF TRIM(sImport(j))="NETO"
       LnNeto = J
    ENDIF
ENDFOR
IF XiCodMon = 1
   @  20,40    SAY "S/."                                   COLOR SCHEME 7
   @  20,47    SAY TfDbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY TfHbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "US$"                                   COLOR SCHEME 7
   @  23,47    SAY TfDbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY TfHbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
ELSE
   @  20,40    SAY "US$"                                   COLOR SCHEME 7
   @  20,47    SAY TfDbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY TfHbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "S/."                                   COLOR SCHEME 7
   @  23,47    SAY TfDbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY TfHbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
ENDIF
RETURN
**********************************************************************
* CALCULO DE IMPORTES================================================
**********************************************************************
PROCEDURE CalNeto
*****************
Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
DO MovPimpM
IF LnNeto > 0
   IF vCodMon(LnNeto) = 1
       vImport(LnNeto) = TfHbeNac - TfDbeNac
   ELSE
       vImport(LnNeto) = TfHbeUsa - TfDbeUsa
   ENDIF
   DO MovPimpM
ENDIF
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
     *Fin       = No
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
   SELE RMDL
   SKIP
ENDDO
MaxEle1 = nEle
RETURN
******************
PROCEDURE MOVGrabM
******************
PRIVATE ii
IF UltTecla = Escape .OR. lDesbal
   RETURN
ENDIF
Do MovGraba
** Tan facil que era poner esto **
NClave   = [NroMes+CodOpe+NroAst]
VClave   = XsNroMes+XsCodOpe+XsNroAst
IF (LEN(TRIM(VClave)) <> 0)
   RegVal   = "&NClave = VClave"
ELSE
   * - Todos los registros son v lidos.
   RegVal = ".T."
ENDIF
**
ii = 1
FOR  ii = 1 TO MaxEle1
     Crear = .T.
     XiNroItm = VMOV->NroItm + 1
     XcEliItm = " "
     XsNroVou = XsNroVou
     XdFchDoc = vFchDoc(ii)
     XiCodMon = vCodMon(ii)
     XsCodCta = vCodCta(ii)
     XsCodRef = vCodRef(ii)
     XsClfAux = vClfAux(ii)
     XsCodAux = vCodAux(ii)
     XcTpoMov = vTpoMov(ii)
     XfImport = vImport(ii)
     XsGloDoc = vGloDoc(ii)
     XsCodDoc = vCodDoc(ii)
     XsNroDoc = vNroDoc(ii)
     XsNroRef = vNroRef(ii)
     XdFchVto = vFchVto(ii)
     XsNroRuc = vNroRuc(ii)
     XsIniAux = vIniAux(ii)
     **** Grabando la linea activa ****
     XcEliItm = " "
     DO MOVbGrab
     RegAct = RECNO()
     *** Requiere crear cuentas automaticas ***
     =SEEK(XsCodCta,"CTAS")
     IF CTAS->GenAut <> "S"
        IF ! Crear
           *** anulando cuentas autom ticas anteriores ***
           SKIP
           XinroItm = NroItm
          *DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "ú"
           DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = [*]          
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
        **** Actualizando Cuentas Autom ticas ****
       *XcEliItm = "ú"
        XcEliItm = [*]       
        TsClfAux = "04 "
        TsCodAux = CTAS->TpoGto
        TsAn1Cta = RMOV->CodAux
        TsCC1Cta = CTAS->CC1Cta
          ** Verificamos su existencia **
        IF ! SEEK(TsAn1Cta,"CTAS")
           GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
           DO LIB_MERR WITH 99
           RETURN
        ENDIF
        IF ! SEEK(TsCC1Cta,"CTAS")
           GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
           DO LIB_MERR WITH 99
           RETURN
        ENDIF
        *****
      * DO CompBrows WITH .F.
        SKIP
        Crear = .T.
       *IF EliItm = "ú" .AND. !EOF()
        IF EliItm = "*" .AND. !EOF()       
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
        DO MOVbGrab
       *DO CompBrows WITH Crear
        SKIP
        Crear = .T.
       *IF EliItm = "ú" .AND. ! EOF()
        IF EliItm = "*" .AND. ! EOF()       
           Crear = .F.
        ENDIF
        ** Grabando la segunda cuenta autom tica **
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
        XsClfAux = SPACE(LEN(RMOV->CLFAUX))
        XsCodAux = SPACE(LEN(RMOV->CODAUX))
        DO MOVbGrab
     ENDIF
ENDFOR
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
          *ELSE
          *   LsEval = LsEval + SUBSTR(sImport,i,1)
          *ENDIF
      CASE Substr(sImport,i,1) = ")"
           LsEval = LsEval + ")"
   ENDCASE
   i = i + 1
ENDDO
LsEval = LsEval + ["]
_TotImp = EVALUATE(&LsEval)
RETURN _TotImp
