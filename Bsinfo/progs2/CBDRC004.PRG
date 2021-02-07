********************************************************************************
* Progrma       : CBDRC004.PRG                                                 *
* Objeto        : CUENTAS PENDIENTES X AUXILIAR                                *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** TF : TIPO DE FORMATO
*** TI : TIPO DE IMPRESION
PRIVATE TF,TI
STORE 1 TO TF,TI
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "SALDOS PENDIENTES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 21,68      COLOR W/N
@  8,11 CLEAR TO 20,69
@  8,11       TO 20,69
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

SELECT 0
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

*** EXCLUIMOS LOS MOVIMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV

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
         IF EMPTY(XsClfAux)
            TI = 0
         ENDIF
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
      CASE I = 7  AND EMPTY(XsCodAux)
         @19,21 SAY "SALTO PAGINA :" GET TI PICT "@*RHT NO;SI"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
      CASE I = 7  AND !EMPTY(XsCodAux)
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
SEEK XsCodCta
XsNomCta = TRIM(NomCta)
SET ORDER TO CTAS03
SEEK "SS"+XsClfAux
DO WHILE AftMov+PidAux+ClfAux = "SS"+XsClfAux
   IF CodCta = TRIM(XsCodCta)         &&   .AND. ! INLIST(CodCta,"12101")
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
Ancho    = 122
Largo    = 66
LinFin   = 88 - 6
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = ""
SubTitulo= ""
EN1    = "CUENTA PENDIENTES AL "+DTOC(GdFecha)
EN2    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
EN3    = ""
EN4    = ""
En5    = ""
En6 = "****** ************** **************** **************** ********** ********** ********** ******** ******************** ***"
En7 = "CODIGO    REFE-                                         FECHA      FECHA        COMPROBANTE                            OR "
En8 = "DE CTA   RENCIA         D E B I T O     C R E D I T O   DCTO.      VCTO.      FECHA      NRO.        G  L  O  S  A     IG "
En9 = "****** ************** **************** **************** ********** ********** ********** ******** ******************** ***"
*      0      7              22               39               56         67         78         89       98                   119
*      0          1         2         3         4         5         6         7         8         9        10        11         
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901


*          1         2         3         4         5         6         7         8         9
*01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
******* ********** **************** **************** ******** ******** ****** ******************** ***"
*CODIGO    REFE-                                      FECHA    COMPROBANTE                         OR "
*DE CTA   RENCIA      D E B I T O     C R E D I T O   DCTO.    FECHA    NRO.    G  L  O  S  A      IG "
******* ********** **************** **************** ******** ******** ****** ******************** ***"
*12345  1234567890 9999,999,999.99- 9999,999,999.99- 99/99/99 99/99/99 123456 12345678901234567890 123
 * T O T A L *     ---------------- ---------------- *   S A L D O   *
** POR CTA         9999,999,999.99- 9999,999,999.99-  9999,999,999.99-
 * T O T A L *     ---------------- ---------------- *   S A L D O   *
** AUXILIAR        9999,999,999.99- 9999,999,999.99-  9999,999,999.99-


Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   Inicio   = .T.
   DO WHILE ClfAux+CodAux = Llave .AND. ! Cancelar
      **** Quiebre por Auxiliar ****
      LsCodAux = CodAux
      SET DEVICE TO SCREEN
      EN3    = TRIM(CodAux)+" "+TRIM(NOMAUX)
      @ 24,0 SAY PADC(EN3,80)
      SET DEVICE TO PRINT
      IF TI=2
         Inicio   = .T.
      ELSE
         EN3 = []
      ENDIF
      L1NumItm = 0
      L1Cargos = 0
      L1Abonos = 0
      Quiebre1 = .T.
      *** Buscando las cuentas que selecciona el auxiliar ***
      Cancelar = ( INKEY() = Escape )
      FOR Item = 1 TO NumEle
         LsCodCta = vCodCta(Item,1)
         LsNomCta = vCodCta(Item,2)
         L2NumItm = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         *** Buscando Movimientos para el auxiliar seleccionado ***
         SELECT RMOV
         SEEK LsCodCta+LsCodAux
         DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
            **** Quiebre por Documento ****
            LsNroDoc = NroDoc
            L3NumItm = 0
            L3Cargos = 0
            L3Abonos = 0
            Quiebre3 = .T.
            DO CHECKDOC
            DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
               IF NROMES <= XsNroMes
                  DO LinImp
               ELSE
                  SKIP
               ENDIF
               Cancelar = ( INKEY() = Escape )
            ENDDO
            IF ! Cancelar .AND. L3NumItm > 0
               L2NumItm = L2NumItm + 1
               L2Cargos = L2Cargos + L3Cargos
               L2Abonos = L2Abonos + L3Abonos
            ENDIF
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            DO RESETPAG
            L2SalAct = L2Cargos - L2Abonos
            NumLin = PROW() + 2
            @ NumLin,0   SAY " * T O T A L *     ---------------- ---------------- *   S A L D O   *"
            NumLin = PROW() + 1
            @ NumLin,0   SAY "** POR CTA"
            IF L2Cargos >= 0
               @ NumLin ,22  SAY L2Cargos       PICTURE "9999,999,999.99"
            ELSE
               @ NumLin ,22  SAY -L2Cargos      PICTURE "9999,999,999.99-"
            ENDIF
            IF L2Abonos >= 0
               @ NumLin ,39  SAY L2Abonos       PICTURE "9999,999,999.99"
            ELSE
               @ NumLin ,39  SAY -L2Abonos      PICTURE "9999,999,999.99-"
            ENDIF
            IF L2SalAct >= 0
               @ NumLin ,57  SAY L2SalAct       PICTURE "9999,999,999.99"
            ELSE
               @ NumLin ,57  SAY -L2SalAct      PICTURE "9999,999,999.99-"
            ENDIF
            NumLin = PROW() + 1
            @ NumLin,0 SAY []
            L1NumItm = L1NumItm + 1
            L1Cargos = L1Cargos + L2Cargos
            L1Abonos = L1Abonos + L2Abonos
         ENDIF
         IF Cancelar
            EXIT
         ENDIF
      NEXT
      IF ! Cancelar .AND. L1NumItm > 0
         NumLin = PROW()+2
         L1SalAct = L1Cargos - L1Abonos
         @ NumLin,0  SAY " * T O T A L *     ---------------- ---------------- *   S A L D O   *"
         NumLin = PROW()+1
         @ NumLin,0  SAY "** AUXILIAR"
         IF L1Cargos >= 0
            @ NumLin , 22 SAY L1Cargos       PICTURE "9999,999,999.99"
         ELSE
            @ NumLin , 22 SAY -L1Cargos      PICTURE "9999,999,999.99-"
         ENDIF
         IF L1Abonos >= 0
            @ NumLin , 39 SAY L1Abonos       PICTURE "9999,999,999.99"
         ELSE
            @ NumLin , 39 SAY -L1Abonos      PICTURE "9999,999,999.99-"
         ENDIF
         IF L1SalAct >= 0
            @ NumLin , 57 SAY L1SalAct       PICTURE "9999,999,999.99"
         ELSE
            @ NumLin , 57 SAY -L1SalAct      PICTURE "9999,999,999.99-"
         ENDIF
         NumLIn = PROW() + 1
         @ NumLin,00 SAY [ ]
      ENDIF
      SELECT AUXI
      SKIP
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN
**********************************************************************
PROCEDURE LinImp
****************
DO RESETPAG
IF TI = 1
   NumLin = PROW() + 1
   DO RESETPAG
   IF Quiebre1
      Quiebre1 = .F.
      NumLin = PROW()+1
      @ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
   ENDIF
ENDIF
NumLin = PROW()+1
@ NumLin , 0  SAY SUBSTR(CodCta,1,6)
@ NumLin , 7  SAY NroDoc
DO CALIMP
DO CASE
   CASE TpoMov = "D"
       Cargos = nIMPORT
       Abonos = 0
   OTHER
       Cargos = 0
       Abonos = nIMPORT
ENDCASE
IF Cargos >= 0
   @ NumLin ,22  SAY Cargos       PICTURE "@Z 9999,999,999.99"
ELSE
   @ NumLin ,22  SAY -Cargos      PICTURE "@Z 9999,999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,39  SAY Abonos       PICTURE "@Z 9999,999,999.99"
ELSE
   @ NumLin ,39  SAY -Abonos      PICTURE "@Z 9999,999,999.99-"
ENDIF
@ NumLin ,56  SAY FchDoc
@ NumLin ,67  SAY FchVTO
@ NumLin ,78  SAY VMOV->FchAst
@ NumLin ,89  SAY NroAst
@ NumLin ,98  SAY GloDoc PICT "@S20"
@ NumLin ,119 SAY CodOpe
NumLin = PROW()+1    && Linea en blanco
@ NumLin ,0   SAY []
L3NumItm = L3NumItm + 1
L3Cargos = L3Cargos + Cargos
L3Abonos = L3Abonos + Abonos
SKIP
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImport = IIF(XiCodMon=1,Import,ImpUsa)
RETURN
******************
PROCEDURE ResetPag
******************
IF PROW()>=LinFin .OR. NumPag = 0 .OR. Inicio
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
RegAct   = RECNO()
NumItm   = 0
Cargos   = 0
Abonos   = 0
DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
   DO CALIMP
   DO CASE
      CASE NroMes > XsNroMes
      CASE TpoMov = "D"
          Cargos = Cargos + nIMPORT
      OTHER
          Abonos = Abonos + nIMPORT
   ENDCASE
   SKIP
ENDDO
SalAct = Cargos - Abonos
IF SalAct <> 0
   Goto RegAct
ENDIF
RETURN
