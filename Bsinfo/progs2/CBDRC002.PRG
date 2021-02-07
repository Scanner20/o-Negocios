********************************************************************************
* Progrma       : CBDRC002.PRG                                                 *
* Objeto        : CUENTAS PENDIENTES                                           *
* Autor         : J.M.                                                         *
* Creaciขn      : 26/07/93                                                     *
* Actualizaciขn :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS PENDIENTES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
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

@  7,12 FILL  TO 19,71 COLOR W/N
@  6,11 CLEAR TO 18,69
@  6,11       TO 18,69

@  8,16 SAY "       Moneda : "
@ 10,13 SAY "       Cuenta : "
@ 12,13 SAY "Clasificaciขn : "
@ 14,13 SAY "     Auxiliar : "
@ 16,13 SAY '  Mes Inicial :       Mes Final: '

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,8,33,2)
      CASE I = 2
         SELECT CTAS
         @ 10,30 GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
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
         @ 10,30 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 11,30 SAY NomCta    PICT "@S35"
         @ 12,30 SAY ClfAux
         XsClfAux = ClfAux
         =SEEK("01"+ClfAux,"TABL")
         @ 13,30 SAY TABL->Nombre    PICT "@S35"

      CASE I = 5 .AND. CTAS->PIDAUX="S"
         IF ! EMPTY(CTAS->Clfaux)
            iDigitos = TABL->Digitos
            IF iDigitos <= 0 .OR. iDigitos > LEN(XsCodAux)
               iDigitos = LEN(RMOV->CodAux)
            ENDIF
            SELECT AUXI
            @ 14,30 GET XsCodAux PICT REPLICATE("!",iDigitos)
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
            @ 14,30 SAY XsCodAux
            SEEK CTAS->ClfAux+XsCodAux
            IF ! FOUND() .AND. ! EMPTY(XsCodAUX)
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 15,30 SAY AUXI->NomAux PICT "@S35"
         ENDIF

      CASE I = 6
         @ 16,30 GET lsMesIni PICT '99' VALID BETWEEN(lsMesIni,'00','12') DEFAULT '00'
         @ 16,47 GET lsMesFin PICT '99' VALID BETWEEN(lsMesIni,'00','12') DEFAULT PADL(_MES,2,'0')
         READ
         UltTecla = LASTKEY()
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
***** Registro de inicio de Impresiขn ******
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

IniImp   = _Prn8b+_Prn4
Ancho    = 153
Largo    = 66
LinFin   = 66 - 6
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "CUENTAS PENDIENTES AL "+DTOC(GdFecha)
SubTitulo= ALLT(XsCodCta)+' - '+ALLT(CTAS->NomCta)
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    = ""
En4    = ""
En5    = ""
IF XiCodMon = 1
En6 = "ออออออออออ อออออออออออออ ออออออออออ ออออออออออ ออออออออออ ออออออออออออออออออออออออออออออออออออออออ อออออออออออออ ออออออออออออ ออออออออออออ ออออออออออออออ"
En7 = "                 No.                             FECHA                                                      US$                                   SALDO  "
En8 = "   FECHA    COMPROBANTE  DOCUMENTO  REFERENCIA  VENCMTO    GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "ออออออออออ อออออออออออออ ออออออออออ ออออออออออ ออออออออออ ออออออออออออออออออออออออออออออออออออออออ อออออออออออออ ออออออออออออ ออออออออออออ ออออออออออออออ"
ELSE
En6 = "ออออออออออ อออออออออออออ ออออออออออ ออออออออออ ออออออออออ ออออออออออออออออออออออออออออออออออออออออ อออออออออออออ ออออออออออออ ออออออออออออ ออออออออออออออ"
En7 = "                 No.                             FECHA                                                      S/.                                   SALDO  "
En8 = "   FECHA    COMPROBANTE  DOCUMENTO  REFERENCIA  VENCMTO    GLOSA                                        IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "ออออออออออ อออออออออออออ ออออออออออ ออออออออออ ออออออออออ ออออออออออออออออออออออออออออออออออออออออ อออออออออออออ ออออออออออออ ออออออออออออ ออออออออออออออ"
ENDIF
*      0123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456789o123456
*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5

*      1234567890               1234567890 1234567890 1234567890 1234567890123456789012345678012345678901

Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   L0NumItm = 0
   L0Cargos = 0
   L0Abonos = 0
   DO RESETPAG
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
            IF BETWEEN(NroMes,lsMesIni,lsMesFin)
               IF NROMES <= XsNroMes
                  DO LinImp
               ELSE
                  SKIP
               ENDIF
            ELSE
               nImport= 0
               Cargos = 0
               Abonos = 0
               SdoUsa = 0
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
               SKIP
               L2Cargos = L2Cargos + Cargos
               L2Abonos = L2Abonos + Abonos
            ENDIF
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            L2SalAct = L2Cargos - L2Abonos
            NumLin = PROW()
            IF L2SalAct >= 0
               @ NumLin ,139 SAY L2SalAct       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,139 SAY -L2SalAct      PICTURE "9,999,999.99-"
            ENDIF
            NumLin = PROW()+1
            @ NumLin,0 SAY REPLICATE("-",Ancho)
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
            @ NumLin ,113 SAY L1Cargos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,113 SAY -L1Cargos      PICTURE "9999,999.99-"
         ENDIF
         IF L1Abonos >= 0
            @ NumLin ,126 SAY L1Abonos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,126 SAY -L1Abonos      PICTURE "9999,999.99-"
         ENDIF
         IF L1SalAct >= 0
            @ NumLin ,139 SAY L1SalAct       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,139 SAY -L1SalAct      PICTURE "9,999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("ฤ",Ancho)
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
         @ NumLin ,113 SAY L0Cargos       PICTURE "9999,999.99"
      ELSE
         @ NumLin ,113 SAY -L0Cargos      PICTURE "9999,999.99-"
      ENDIF
      IF L0Abonos >= 0
         @ NumLin ,126 SAY L0Abonos       PICTURE "9999,999.99"
      ELSE
         @ NumLin ,126 SAY -L0Abonos      PICTURE "9999,999.99-"
      ENDIF
      IF L0SalAct >= 0
         @ NumLin ,139 SAY L0SalAct       PICTURE "9,999,999.99"
      ELSE
         @ NumLin ,139 SAY -L0SalAct      PICTURE "9,999,999.99-"
      ENDIF
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("อ",Ancho)
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
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = FchVto
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
@ NumLin , 11 SAY LsCodOpe
@ NumLin , 15 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 36 SAY LsNroRef
IF ! EMPTY(LsFchVto)
   @ NumLin , 47 SAY LsFchVto
ENDIF
@ NumLin , 58 SAY LsGloDoc        PICTURE "@S40"

IF SdoUsa >= 0
   @ NumLin ,99  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,99  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF

IF Cargos >= 0
   @ NumLin ,113 SAY Cargos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,113 SAY -Cargos      PICTURE "@Z 9999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,126 SAY Abonos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,126 SAY -Abonos      PICTURE "@Z 9999,999.99-"
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
