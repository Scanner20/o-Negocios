********************************************************************************
* Progrma       : CBDRC002.PRG                                                 *
* Objeto        : CUENTAS PENDIENTES                                           *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS PENDIENTES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 19,68      COLOR W/N
@  8,11 CLEAR TO 18,69
@  8,11       TO 18,69
SELECT 5
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF

SELECT 4
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF

SELECT 1
USE CBDRMOVM ORDER RMOV06 ALIAS RMOV
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
**********************************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
UltTecla = 0
i        = 1

@ 10,16 SAY "Moneda        : "
@ 12,13 SAY "Cuenta        : "
@ 14,13 SAY "Clasificaci¢n : "
@ 16,13 SAY "Auxiliar      : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,33,2)
      CASE I = 2
         SELECT CTAS
         @ 12,30 GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
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
         @ 12,30 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 13,30 SAY NomCta    PICT "@S35"
         @ 14,30 SAY ClfAux
         XsClfAux = ClfAux
         =SEEK("01"+ClfAux,"TABL")
         @ 15,30 SAY TABL->Nombre    PICT "@S35"

      CASE I = 5 .AND. CTAS->PIDAUX="S"
         IF ! EMPTY(CTAS->Clfaux)
            iDigitos = TABL->Digitos
            IF iDigitos <= 0 .OR. iDigitos > LEN(XsCodAux)
               iDigitos = LEN(RMOV->CodAux)
            ENDIF
            SELECT AUXI
            @ 16,30 GET XsCodAux PICT REPLICATE("!",iDigitos)
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
               IF ! EMPTY(XsCodAux)
                  XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
               ENDIF
            ENDIF
            XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAUX))
            @ 16,30 SAY XsCodAux
            SEEK CTAS->ClfAux+XsCodAux
            IF ! FOUND() .AND. ! EMPTY(XsCodAUX)
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 17,30 SAY AUXI->NomAux PICT "@S35"
         ENDIF
      CASE I = 6
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>6,6, i)
   i = IIF(i<1, 1, i)
ENDDO
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
IF EMPTY(XsCodCta)
   GsMsgErr = "Invalida cuenta seleccionada"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
DO ADMPRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
***** Registro de inicio de Impresi¢n ******
SELECT RMOV
Llave = TRIM(XsCodCta)
IF ! EMPTY(XsCodAux)
   Llave = XsCodCta+TRIM(XsCodAux)
ENDIF
SEEK Llave
IF ! FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

IniImp   = _Prn8a+_Prn3    && 15   cpi
Ancho    = 147
Largo    = 66
LinFin   = 88 - 6
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "CUENTAS PENDIENTES AL "+DTOC(GdFecha)
SubTitulo= TRIM(CTAS->NomCta)
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    = ""
En4    = ""
En5    = ""
IF XiCodMon = 1
En6 = "****** ************* ********** ********** ****** **************************************** ************* ************ ************ **************"
En7 = "             No.                           FECHA                                                    US$                                   SALDO  "
En8 = "FECHA   COMPROBANTE  DOCUMENTO  REFERENC.  VENCTO  GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "****** ************* ********** ********** ****** **************************************** ************* ************ ************ **************"
ELSE
En6 = "****** ************* ********** ********** ****** **************************************** ************* ************ ************ **************"
En7 = "             No.                           FECHA                                                    S/.                                   SALDO  "
En8 = "FECHA   COMPROBANTE  DOCUMENTO  REFERENC.  VENCTO  GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "****** ************* ********** ********** ****** **************************************** ************* ************ ************ **************"
ENDIF
*      0**** 7************ 21******** 32******** 43**** 50************************************** 91*********** 105********* 118********* 131***********"

Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   L0NumItm = 0
   L0Cargos = 0
   L0Abonos = 0
   DO WHILE CodCta+CodAux = Llave .AND. ! Cancelar
      **** Quiebre por Proveedor ****
      =SEEK(CodCta,"CTAS")
      =SEEK(CTAS->CLFAUX+CodAux,"AUXI")
      LsCodCta = CodCta
      LsClfAux = ClfAux
      LsCodAux = CodAux
      L1NumItm = 0
      L1Cargos = 0
      L1Abonos = 0
      Quiebre1 = .T.
      DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
         **** Quiebre por Documento ****
         IF XiCodMon = 1
            IF Import = 0 .AND. (CodOpe="015" .AND. NroAst="000002")
               SKIP
               LOOP
            ENDIF
         ELSE
            IF ImpUsa = 0 .AND. (CodOpe="015" .AND. NroAst="000001")
               SKIP
               LOOP
            ENDIF
         ENDIF
         LsNroDoc = NroDoc
         LiCodMon = CodMon
         L2NumItm = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         DO CHECKDOC  && *** VERIFICANDO LAS CONDICIONES DE IMPRESION ***
         DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
            IF NROMES <= XsNroMes
               DO LinImp
            ELSE
               SKIP
            ENDIF
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            L2SalAct = L2Cargos - L2Abonos
            NumLin = PROW()
            IF L2SalAct >= 0
               @ NumLin ,131 SAY L2SalAct       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,131 SAY -L2SalAct      PICTURE "9,999,999.99-"
            ENDIF
            NumLin = PROW()+1
            @ NumLin,0 SAY REPLICATE(".",Ancho)
            L1NumItm = L1NumItm + 1
            L1Cargos = L1Cargos + L2Cargos
            L1Abonos = L1Abonos + L2Abonos
         ENDIF
      ENDDO
      IF ! Cancelar .AND. L1NumItm > 0
         NumLin = PROW()+1
         L1SalAct = L1Cargos - L1Abonos
         @ NumLin,50 SAY "** TOTAL "+LsCodAux+" **"
         IF L1Cargos >= 0
            @ NumLin ,105 SAY L1Cargos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,105 SAY -L1Cargos      PICTURE "9999,999.99-"
         ENDIF
         IF L1Abonos >= 0
            @ NumLin ,118 SAY L1Abonos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,118 SAY -L1Abonos      PICTURE "9999,999.99-"
         ENDIF
         IF L1SalAct >= 0
            @ NumLin ,131 SAY L1SalAct       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,131 SAY -L1SalAct      PICTURE "9,999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("-",Ancho)
         L0NumItm = L0NumItm + 1
         L0Cargos = L0Cargos + L1Cargos
         L0Abonos = L0Abonos + L1Abonos
      ENDIF
   ENDDO
   IF ! Cancelar .AND. L0NumItm > 0
      NumLin = PROW()+1
      L0SalAct = L0Cargos - L0Abonos
      @ NumLin,50 SAY "*  TOTAL GENERAL *"
      IF L0Cargos >= 0
         @ NumLin ,105 SAY L0Cargos       PICTURE "9999,999.99"
      ELSE
         @ NumLin ,105 SAY -L0Cargos      PICTURE "9999,999.99-"
      ENDIF
      IF L0Abonos >= 0
         @ NumLin ,118 SAY L0Abonos       PICTURE "9999,999.99"
      ELSE
         @ NumLin ,118 SAY -L0Abonos      PICTURE "9999,999.99-"
      ENDIF
      IF L0SalAct >= 0
         @ NumLin ,131 SAY L0SalAct       PICTURE "9,999,999.99"
      ELSE
         @ NumLin ,131 SAY -L0SalAct      PICTURE "9,999,999.99-"
      ENDIF
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("=",Ancho)
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN
**********************************************************************
PROCEDURE LinImp
****************
nImport= 0
NumItm = 0
SdoUsa = 0
Cargos = 0
Abonos = 0
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,2)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,2)
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
   LsGloDoc = VMOV->NotAst
ENDIF

DO CALIMP
DO CASE
   CASE TpoMov = "D"
       Cargos = Cargos + nIMPORT
       IF LiCodMon = 2
          SdoUsa = SdoUsa + ImpUsa
       ENDIF
   OTHER
       Abonos = Abonos + nIMPORT
       IF LiCodMon = 2
          SdoUsa = SdoUsa - ImpUsa
       ENDIF
ENDCASE
NumItm = NumItm + 1
SKIP
NumLin = PROW() + 1
IF Cargos = 0 .AND. Abonos = 0 .AND. (LsCodOpe="015" .AND. LsNroAst="000002")
    RETURN
ENDIF
DO RESETPAG
IF Quiebre1
   Quiebre1 = .F.
   NumLin = PROW()+1
   @ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
NumLin = PROW()+1
@ NumLin , 0  SAY LsFchAst
@ NumLin , 7  SAY LsCodOpe
@ NumLin , 11 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 21 SAY LsNroDoc
@ NumLin , 32 SAY LsNroRef
IF ! EMPTY(LsFchVto)
   @ NumLin , 43 SAY LsFchVto
ENDIF
@ NumLin , 50 SAY LsGloDoc        PICTURE "@S40"

IF SdoUsa >= 0
   @ NumLin ,91  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,91  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF

IF Cargos >= 0
   @ NumLin ,105 SAY Cargos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,105 SAY -Cargos      PICTURE "@Z 9999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,118 SAY Abonos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,118 SAY -Abonos      PICTURE "@Z 9999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
******************
PROCEDURE ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   Inicio  = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
******************
PROCEDURE CHECKDOC
******************
RegAct = RECNO()
SalAct = 0
UltMes = "  "
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
   IF NROMES <= XsNroMes
      UltMes = NroMes
      DO CALIMP
      IF TpoMov = "D"
         SalAct = SalAct + nIMPORT
      ELSE
         SalAct = SalAct - nIMPORT
      ENDIF
   ENDIF
   SKIP
ENDDO
IF SalAct <> 0
   Goto RegAct
ENDIF
RETURN
