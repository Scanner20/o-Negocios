********************************************************************************
* Progrma       : CBDRC001.PRG                                                 *
* Objeto        : SALDOS PENDIENTES                                            *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "SALDOS PENDIENTES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 19,68      COLOR W/N
@  8,11 CLEAR TO 18,69
@  8,11       TO 18,69
SELECT 4
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
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
@ 12,16 SAY "Clasificaci¢n : "
@ 14,16 SAY "Auxiliar      : "
@ 16,16 SAY "Cuenta        : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,33,2)
      CASE I = 4
         SELECT TABL
         XsTabla = "01"
         @ 12,33 GET XsClfAux PICT "@!"
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
         @ 12,33 SAY XsClfAux
         IF ! SEEK(XsTabla+XsClfAux,"TABL")
            DO Lib_Merr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         @ 13,33 SAY TABL->Nombre    PICT "@S35"
      CASE I = 5
         iDigitos = TABL->Digitos
         IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
            iDigitos = LEN(XsCodAux)
         ENDIF
         SELECT AUXI
         @ 14,33 GET XsCodAux PICT REPLICATE("!",iDigitos)
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
         @ 14,33 SAY XsCodAux
         SEEK XsClfAux+XsCodAux
         @ 15,33 SAY AUXI->NomAux PICT "@S35"
         IF ! FOUND() .AND. ! EMPTY(XsCodAUX)
            DO Lib_MErr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
      CASE I = 6
         SELECT CTAS
         @ 16,33 GET XsCodCta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("MCTA")
               LOOP
            ENDIF
            XsCodCta = CodCta
         ENDIF
         @ 16,33 SAY XsCodCta
         IF ! EMPTY(XsCodCta) .AND. ! SEEK(XsCodCta)
            DO Lib_Merr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         @ 17,33 SAY NomCta         PICT "@S35"
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>6,6, i)
   i = IIF(i<1, 1, i)
ENDDO
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
IF EMPTY(XsCLFAUX)
   GsMsgErr = "Invalida Clasificaci¢n seleccionada"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
@ 24,0
DO ADMPRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
DIMENSION vCodCta(20,2)
NumEle = 0
MaxEle = 20
*** Buscando las cuentas que selecciona el auxiliar ***
SELECT CTAS
SET ORDER TO CTAS03
SEEK "SS"+XsClfAux
DO WHILE AftMov+PidAux+ClfAux = "SS"+XsClfAux
   IF CodCta = TRIM(XsCodCta)
      IF NumEle = MaxEle
         MaxEle = MaxEle + 10
         DIMENSION vCodCta(MaxEle,2)
      ENDIF
      NumEle = NumEle + 1
      vCodCta(NumEle,1) = CodCta
      vCodCta(NumEle,2) = NomCta
   ENDIF
   SKIP
ENDDO
IF NumEle = 0
   GsMsgErr = "No existen cuentas asignadas a este auxiliar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
SET ORDER TO CTAS01
***** Registro de inicio de Impresi¢n ******
SELECT AUXI
Llave = XsClfAux+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

IniImp   = _Prn8a+_Prn2    && 12   cpi
Ancho    = 96
Largo    = 66
LinFin   = 88 - 6
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = ""
SubTitulo= ""
EN1    = "SALDOS PENDIENTES AL "+DTOC(GdFecha)
EN2    = ALLTRIM(TABL->Nombre)
EN3    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En4    = ""
En5    = ""
En6 = "****** ********************************** ************* ************ ************ ************* "
En7 = "                                                 SALDO                                   SALDO  "
En8 = "CUENTA  D E S C R I P C I O N                 ANTERIOR      CARGOS       ABONOS         ACTUAL  "
En9 = "****** ********************************** ************* ************ ************ ************* "
*      0***** 7********************************* 42*********** 56********** 69********** 82*********** "

Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   L0NumItm = 0
   L0SalAnt = 0
   L0Cargos = 0
   L0Abonos = 0
   DO WHILE ClfAux+CodAux = Llave .AND. ! Cancelar
      **** Quiebre por Auxiliar ****
      LsClfAux = ClfAux
      LsCodAux = CodAux
      SET DEVICE TO SCREEN
      @ 24,0 SAY PADC(TRIM(CodAux)+" "+TRIM(NOMAUX),80)
      SET DEVICE TO PRINT
      L1NumItm = 0
      L1SalAnt = 0
      L1Cargos = 0
      L1Abonos = 0
      Quiebre1 = .T.
      *** Buscando las cuentas que selecciona el auxiliar ***
      Cancelar = ( INKEY() = Escape )
      FOR Item = 1 TO NumEle
         LsCodCta = vCodCta(Item,1)
         LsNomCta = vCodCta(Item,2)
         L2NumItm = 0
         L2SalAnt = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         *** Buscando Movimientos para el auxiliar seleccionado ***
         SELECT RMOV
         SEEK LsCodCta+LsCodAux
         DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
            DO CHECKDOC
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            DO RESETPAG
            IF Quiebre1
               Quiebre1 = .F.
               NumLin = PROW()+1
               @ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
               @ NumLin+1,0 SAY ""
            ENDIF
            L2SalAct = L2SalAnt + L2Cargos - L2Abonos
            NumLin = PROW() + 1
            @ NumLin,0   SAY LsCodCta
            @ NumLin,7   SAY LsNomCta PICT "@S34"
            IF L2SalAnt >= 0
               @ NumLin , 42 SAY L2SalAnt       PICTURE "9,999,999.99"
            ELSE
               @ NumLin , 42 SAY -L2SalAnt      PICTURE "9,999,999.99-"
            ENDIF
            IF L2Cargos >= 0
               @ NumLin ,56  SAY L2Cargos       PICTURE "9999,999.99"
            ELSE
               @ NumLin ,56  SAY -L2Cargos      PICTURE "9999,999.99-"
            ENDIF
            IF L2Abonos >= 0
               @ NumLin ,69  SAY L2Abonos       PICTURE "9999,999.99"
            ELSE
               @ NumLin ,69  SAY -L2Abonos      PICTURE "9999,999.99-"
            ENDIF
            IF L2SalAct >= 0
               @ NumLin ,82  SAY L2SalAct       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,82  SAY -L2SalAct      PICTURE "9,999,999.99-"
            ENDIF
            L1NumItm = L1NumItm + 1
            L1SalAnt = L1SalAnt + L2SalAnt
            L1Cargos = L1Cargos + L2Cargos
            L1Abonos = L1Abonos + L2Abonos
         ENDIF
         IF Cancelar
            EXIT
         ENDIF
      NEXT
      IF ! Cancelar .AND. L1NumItm > 0
         NumLin = PROW()+1
         L1SalAct = L1SalAnt + L1Cargos - L1Abonos
         @ NumLin,7  SAY "** TOTAL "+LsCodAux+" **"
         IF L1SalAnt >= 0
            @ NumLin , 42 SAY L1SalAnt       PICTURE "9,999,999.99"
         ELSE
            @ NumLin , 42 SAY -L1SalAnt      PICTURE "9,999,999.99-"
         ENDIF
         IF L1Cargos >= 0
            @ NumLin , 56 SAY L1Cargos       PICTURE "9999,999.99"
         ELSE
            @ NumLin , 56 SAY -L1Cargos      PICTURE "9999,999.99-"
         ENDIF
         IF L1Abonos >= 0
            @ NumLin , 69 SAY L1Abonos       PICTURE "9999,999.99"
         ELSE
            @ NumLin , 69 SAY -L1Abonos      PICTURE "9999,999.99-"
         ENDIF
         IF L1SalAct >= 0
            @ NumLin , 82 SAY L1SalAct       PICTURE "9,999,999.99"
         ELSE
            @ NumLin , 82 SAY -L1SalAct      PICTURE "9,999,999.99-"
         ENDIF
         @ NumLin ,95  SAY "*"
         NumLin = PROW()+1
         @ NumLin,0 SAY ""
         L0NumItm = L0NumItm + 1
         L0SalAnt = L0SalAnt + L1SalAnt
         L0Cargos = L0Cargos + L1Cargos
         L0Abonos = L0Abonos + L1Abonos
      ENDIF
      SELECT AUXI
      SKIP
   ENDDO
   IF ! Cancelar .AND. L0NumItm > 0
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("=",Ancho)
      NumLin = PROW()+1
      L0SalAct = L0SalAnt + L0Cargos - L0Abonos
      @ NumLin,7  SAY "*  TOTAL GENERAL *"
      IF L0SalAnt >= 0
         @ NumLin , 42 SAY L0SalAnt       PICTURE "9,999,999.99"
      ELSE
         @ NumLin , 42 SAY -L0SalAnt      PICTURE "9,999,999.99-"
      ENDIF
      IF L0Cargos >= 0
         @ NumLin , 56 SAY L0Cargos       PICTURE "9999,999.99"
      ELSE
         @ NumLin , 56 SAY -L0Cargos      PICTURE "9999,999.99-"
      ENDIF
      IF L0Abonos >= 0
         @ NumLin , 69 SAY L0Abonos       PICTURE "9999,999.99"
      ELSE
         @ NumLin , 69 SAY -L0Abonos      PICTURE "9999,999.99-"
      ENDIF
      IF L0SalAnt >= 0
         @ NumLin , 82 SAY L0SalAct       PICTURE "9,999,999.99"
      ELSE
         @ NumLin , 82 SAY -L0SalAct      PICTURE "9,999,999.99-"
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
SalAnt = 0
Cargos = 0
Abonos = 0
DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF()
   DO CALIMP
   DO CASE
      CASE NroMes < XsNroMes
         IF TpoMov = "D"
            SalAnt = SalAnt + nIMPORT
         ELSE
            SalAnt = SalAnt - nIMPORT
         ENDIF
      CASE TpoMov = "D"
          Cargos = Cargos + nIMPORT
      OTHER
          Abonos = Abonos + nIMPORT
   ENDCASE
   NumItm = NumItm + 1
   SKIP
ENDDO
L2NumItm = L2NumItm + 1
L2SalAnt = L2SalAnt + SalAnt
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImport = IIF(XiCodMon=1,Import,ImpUsa)
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
UltMes   = "  "
NumItm   = 0
SalAnt   = 0
Cargos   = 0
Abonos   = 0
SalAct   = 0
LsNroDoc = NroDoc
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
   DO CALIMP
   DO CASE
      CASE NroMes > XsNroMes
      CASE NroMes < XsNroMes
         IF TpoMov = "D"
            SalAnt = SalAnt + nIMPORT
         ELSE
            SalAnt = SalAnt - nIMPORT
         ENDIF
      CASE TpoMov = "D"
          Cargos = Cargos + nIMPORT
      OTHER
          Abonos = Abonos + nIMPORT
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
IF SalAct <> 0  .OR. UltMes = XsNroMes
   L2NumItm = L2NumItm + 1
   L2SalAnt = L2SalAnt + SalAnt
   L2Cargos = L2Cargos + Cargos
   L2Abonos = L2Abonos + Abonos
ENDIF
RETURN
