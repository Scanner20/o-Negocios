********************************************************************************
* Programa      : CBDRC02a.PRG                                                 *
* Objeto        : CUENTAS PENDIENTES                                           *
* Autor         : VETT  resumido por auxiliar                                  *
* Creaci¢n      : 26/07/95                                                     *
* Actualizaci¢n :   /  /                                        - MILKITO      *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS PENDIENTES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 21,68      COLOR W/N
@  8,11 CLEAR TO 20,69
@  8,11       TO 20,69
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
XsCtaf   = SPACE(LEN(CodCta))
UltTecla = 0
i        = 1
@ 10,16 SAY "Moneda        : "
@ 12,13 SAY "Desde la Cta. : "
@ 14,13 SAY "Hasta la Cta. : "
@ 16,13 SAY "Clasificaci¢n : "
@ 18,13 SAY "Auxiliar      : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,33,2)
      CASE I = 2
         SELECT CTAS
         @ 12,30 GET XsCodCta &&PICT REPLICATE("9",LEN(XsCodCta))
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
         @ 16,30 SAY ClfAux
         XsClfAux = ClfAux
         =SEEK("01"+ClfAux,"TABL")
         @ 17,30 SAY TABL->Nombre    PICT "@S35"

      CASE I = 3
         SELECT CTAS
         @ 14,30 GET XsCtaf PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCtaf)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCtaf   = CTAS->CodCta
         ENDIF
         @ 14,30 SAY XsCtaf
         IF !EMPTY(XsCtaf)
            SEEK XsCtaf
            IF ! FOUND()
               GsMsgErr = "Cuenta no Registrada"
               DO Lib_MErr WITH 99
               UltTecla = 0
               LOOP
            ENDIF
            @ 15,30 SAY NomCta    PICT "@S35"
            XsClfAux = SPACE(LEN(ClfAux))
         ENDIF
      CASE I = 5
         SELECT TABL
         XsTabla = "01"
         @ 16,30 GET XsClfAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsClfAux = LEFT(TABL->Codigo,LEN(XsClfAux))
         ENDIF
         @ 16,30 SAY XsClfAux
         IF ! SEEK(XsTabla+XsClfAux,"TABL")
            DO Lib_Merr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         @ 17,30 SAY TABL->Nombre    PICT "@S35"
      CASE I = 6
         IF ! EMPTY(XsClfaux)
            iDigitos = TABL->Digitos
            IF iDigitos <= 0 .OR. iDigitos > LEN(XsCodAux)
               iDigitos = LEN(RMOV->CodAux)
            ENDIF
            SELECT AUXI
            @ 18,30 GET XsCodAux PICT REPLICATE("!",iDigitos)
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
                 *XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
               ENDIF
            ENDIF
            XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAUX))
            @ 18,30 SAY XsCodAux
            SEEK XsClfAux+XsCodAux
            IF ! FOUND() .AND. ! EMPTY(XsCodAUX)
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 19,30 SAY AUXI->NomAux PICT "@S35"
         ENDIF
      CASE I = 7
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>7,7, i)
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
   Llave = TRIM(XsCodCta)
ENDIF
*Llave1 = TRIM(XsCtaf)
XsCtaF   = LEFT(TRIM(XsCtaF  )+"zzzzzzzzzz",LEN(CODCTA))
SEEK Llave
IF ! FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
SELE CTAS
SEEK TRIM(XsCodCta)
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
**---- Rutina de impresi¢n ----**
IniImp   = _Prn8a+_Prn3    && 15   cpi
Ancho    = 160
Largo    = 66
LinFin   = 88 - 6
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "CUENTAS PENDIENTES AL "+DTOC(GdFecha)
SubTitulo= IIF(XsCodCta=XsCtaF,XsCodCta,"DESDE :"+XsCodCta+"  HASTA :"+XsCtaF)
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    = ""
En4    = ""
En5    = ""
IF XiCodMon = 1
En6 = "******** *************** ************** ************** ************* ******************************** ************** ************* *************** **************"
En7 = "               No.                                              US$                                         SALDO                                      SALDO     "
En8 = "FECHA     COMPROBANTE      DOCUMENTO    REFERENC.           IMPORTE   GLOSA                                ANTERIOR      CARGOS         ABONOS        ACTUAL     "
En9 = "******** *************** ************** ************** ************* ******************************** ************** ************* *************** **************"
ELSE
En6 = "******** *************** ************** ************** ************* ******************************** ************** ************* *************** **************"
En7 = "               No.                                              S/.                                         SALDO                                      SALDO     "
En8 = "FECHA     COMPROBANTE      DOCUMENTO    REFERENC.           IMPORTE   GLOSA                                ANTERIOR      CARGOS         ABONOS         ACTUAL    "
En9 = "******** *************** ************** ************** ************* ******************************** ************** ************* *************** **************"
ENDIF
*      0******* 9************** 25************ 40************ 55*********** 69****************************** 102*********** 117********** 131************ 147***********
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-1234567890
*      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0
SET DEVICE TO PRINT
PRINTJOB
   GOTO RegIni
   _I = 1
   NumPag   = 0
   LtNumItm = 0
   LtCargos = 0
   LtAbonos = 0
   LtSalAnt = 0
   SELE CTAS
   SEEK TRIM(XsCodCta)
   DO WHILE !EOF() AND CodCta <= XsCtaf AND !EOF() AND !Cancelar
      IF AFTMOV<>"S"
         SKIP
         LOOP
      ENDIF
      IF !(ClfAux=TRIM(XsClfAux))
         SKIP
         LOOP
      ENDIF
      Llave1 = CodCta
      NomCta1 =TRIM(CTAS->NomCta)
      L0NumItm = 0
      L0Cargos = 0
      L0Abonos = 0
      L0SalAnt = 0
      Quiebre  = .T.
      SELE RMOV
      SEEK LLAVE1
      DO WHILE CodCta = Llave1 .AND. ! Cancelar AND !EOF()
         IF !(RMOV.CodAux=TRIM(XsCodAux))
            SKIP
            LOOP
         ENDIF
         **** Quiebre por Proveedor ****
         =SEEK(CTAS->CLFAUX+CodAux,"AUXI")
         LsCodCta = CodCta
         LsClfAux = ClfAux
         LsCodAux = CodAux
         L1NumItm = 0
         L1Cargos = 0
         L1Abonos = 0
         L1SalAnt = 0
         Quiebre1 = .T.
         LinMes   = .F.
         DO CHECKDOC  && *** VERIFICANDO LAS CONDICIONES DE IMPRESION ***
         DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar AND !EOF()
            **** Quiebre por Documento ****
            LsNroDoc = NroDoc
            LiCodMon = CodMon
            L2NumItm = 0
            L2Cargos = 0
            L2Abonos = 0
            L2SalAnt = 0
            Quiebre2 = .T.
            IF NroMes <= XsNroMes
               L1NumItm = L1NumItm + 1
               DO LinImp
            ENDIF
            SKIP
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L1NumItm > 0
            DO RESETPAG
            NumLin = PROW() + 1
            @ Numlin ,0 SAY REPLI(".",ANCHO)
            NumLin = PROW()+1
            L1SalAct = L1SalAnt + L1Cargos - L1Abonos
            @ NumLin,63 SAY "** TOTAL "+LsCodAux+" **"
            IF L1SalAnt >= 0
               @ NumLin ,102 SAY L1SalAnt       PICTURE "99,999,999.99"
            ELSE
               @ NumLin ,102 SAY -L1SalAnt      PICTURE "99,999,999.99-"
            ENDIF
            IF L1Cargos >= 0
               @ NumLin ,117 SAY L1Cargos       PICTURE "9999,999.99"
            ELSE
               @ NumLin ,117 SAY -L1Cargos      PICTURE "9999,999.99-"
            ENDIF
            IF L1Abonos >= 0
               @ NumLin ,131 SAY L1Abonos       PICTURE "9999,999.99"
            ELSE
               @ NumLin ,131 SAY -L1Abonos      PICTURE "9999,999.99-"
            ENDIF
            IF L1SalAct >= 0
               @ NumLin ,147 SAY L1SalAct       PICTURE "99,999,999.99"
            ELSE
               @ NumLin ,147 SAY -L1SalAct      PICTURE "99,999,999.99-"
            ENDIF
            NumLin = PROW()+1
            @ NumLin,0 SAY REPLICATE("-",Ancho)
            L0NumItm = L0NumItm + 1
            L0SalAnt = L0SalAnt + L1SalAnt
            L0Cargos = L0Cargos + L1Cargos
            L0Abonos = L0Abonos + L1Abonos
         ENDIF
      ENDDO
      IF ! Cancelar .AND. L0NumItm > 0
         NumLin = PROW()+1
         L0SalAct = L0SalAnt + L0Cargos - L0Abonos
         @ NumLin,63 SAY "*  TOTAL CUENTA  *"
         IF L0SalAnt >= 0
            @ NumLin ,102 SAY L0SalAnt       PICTURE "99,999,999.99"
         ELSE
            @ NumLin ,102 SAY -L0SalAnt      PICTURE "99,999,999.99-"
         ENDIF
         IF L0Cargos >= 0
            @ NumLin ,117 SAY L0Cargos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,117 SAY -L0Cargos      PICTURE "9999,999.99-"
         ENDIF
         IF L0Abonos >= 0
            @ NumLin ,131 SAY L0Abonos       PICTURE "99999,999.99"
         ELSE
            @ NumLin ,131 SAY -L0Abonos      PICTURE "99999,999.99-"
         ENDIF
         IF L0SalAct >= 0
            @ NumLin ,147 SAY L0SalAct       PICTURE "99,999,999.99"
         ELSE
            @ NumLin ,147 SAY -L0SalAct      PICTURE "99,999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("=",Ancho)
         LtNumItm = LtNumItm + 1
         LtSalAnt = LtSalAnt + L0SalAnt
         LtCargos = LtCargos + L0Cargos
         LtAbonos = LtAbonos + L0Abonos
      ENDIF
      SELE CTAS
      SKIP
   ENDDO
   IF ! Cancelar .AND. LtNumItm > 0
      DO RESETPAG
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("*",Ancho)
      DO RESETPAG
      NumLin = PROW()+1
      LtSalAct = LtSalAnt + LtCargos - LtAbonos
      @ NumLin,63 SAY "*  TOTAL GENERAL *"
      IF LtSalAnt >= 0
         @ NumLin ,102 SAY LtSalAnt       PICTURE "99,999,999.99"
      ELSE
         @ NumLin ,102 SAY -LtSalAnt      PICTURE "99,999,999.99-"
      ENDIF
      IF LtCargos >= 0
         @ NumLin ,117 SAY LtCargos       PICTURE "9999,999.99"
      ELSE
         @ NumLin ,117 SAY -LtCargos      PICTURE "9999,999.99-"
      ENDIF
      IF LtAbonos >= 0
         @ NumLin ,131 SAY LtAbonos       PICTURE "99,999,999.99"
      ELSE
         @ NumLin ,131 SAY -LtAbonos      PICTURE "99,999,999.99-"
      ENDIF
      IF LtSalAct >= 0
         @ NumLin ,147 SAY LtSalAct       PICTURE "99,999,999.99"
      ELSE
         @ NumLin ,147 SAY -LtSalAct      PICTURE "99,999,999.99-"
      ENDIF
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
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
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,4)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,4)
LsGloDoc = GloDoc
LiCodMon = CodMon
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
NumLin = PROW() + 1
DO RESETPAG
IF Quiebre
   Quiebre  = .F.
   NumLin = PROW()+1
   @ NumLin,0   SAY _Prn6a+Llave1+" "+LEFT(NomCta1,30)+_Prn6b
   DO RESETPAG
   NumLIn = PROW() + 1
   @ NumLin,00 SAY [ ]
ENDIF
NumLin = PROW()+1
IF Quiebre1 AND LinMes
   Quiebre1 = .F.
   LinMes   = .F.
   NumLin = PROW()+1
   @ NumLin,02  SAY _Prn6a+LsCodAux+" "+LEFT(AUXI->NomAux,30)
   IF L1SalAnt >= 0
      @ NumLin ,102 SAY L1SalAnt       PICTURE "99,999,999.99"
   ELSE
      @ NumLin ,102 SAY -L1SalAnt      PICTURE "99,999,999.99-"
   ENDIF
   @ NumLin , 113 SAY _PRN6b
ENDIF
NumLin = PROW()+1
IF NroMes < XsNroMes
   RETURN
ENDIF
NumLin = PROW()+1
@ NumLin , 0  SAY LsFchAst
@ NumLin , 9  SAY LsCodOpe
@ NumLin , 13 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 40 SAY LsNroRef
*IF ! EMPTY(LsFchVto)
*   @ NumLin , 43 SAY LsFchVto
*ENDIF
IF SdoUsa >= 0
   @ NumLin ,54  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,54  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF
@ NumLin , 69 SAY LsGloDoc        PICTURE "@S32"

IF Cargos >= 0
   @ NumLin ,117 SAY Cargos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,117 SAY -Cargos      PICTURE "@Z 9999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,131 SAY Abonos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,131 SAY -Abonos      PICTURE "@Z 9999,999.99-"
ENDIF
L1Cargos = L1Cargos + Cargos
L1Abonos = L1Abonos + Abonos
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
   DO ADMMBPRN &&IN ADMPRINT
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
DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
   DO CALIMP
   DO CASE
      CASE NROMES>XsNROMES
      CASE NROMES<XsNROMES
           IF TpoMov = "D"
              L1SalAnt = L1SalAnt + nIMPORT
           ELSE
              L1SalAnt = L1SalAnt - nIMPORT
           ENDIF
       CASE NroMes = XsNroMes
            LinMes = .T.
   ENDCASE
   IF NROMES <= XsNroMes
      UltMes = NroMes
      IF TpoMov = "D"
         SalAct = SalAct + nIMPORT
      ELSE
         SalAct = SalAct - nIMPORT
      ENDIF
   ENDIF
   SKIP
ENDDO
IF SalAct <> 0
   L1NumItm = L1NumItm + 1
   Goto RegAct
ENDIF
RETURN
