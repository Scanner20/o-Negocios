********************************************************************************
* Progrma       : CBDRC02v.PRG                                                 *
* Objeto        : CUENTAS PENDIENTES                                           *
* Autor         : VETT                                                         *
* Creaci¢n      : 26/07/97                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS PENDIENTES x VENCIMIENTO"
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
         IF ! EMPTY(CTAS->Clfaux)
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
                  XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
               ENDIF
            ENDIF
            XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAUX))
            @ 18,30 SAY XsCodAux
            SEEK CTAS->ClfAux+XsCodAux
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
         i = 1
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
***********
nImport   = 0
nImpUsa   = 0
IF !GenRepor()
   WAIT WINDOW [Imposible generar reporte...Pulse una tecla para terminar]
   CLOSE DATA
   RETURN
ENDIF
***********
DO ADMPRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
***** Registro de inicio de Impresi¢n ******
SELECT RMOV
GO TOP
IF EOF()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

IniImp   = _Prn8a+_Prn3    && 15   cpi
Ancho    = 150
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
En6 = "******** *************** ************** ********** ******** ************************************ ************* ************ ************ **************"
En7 = "               No.                                 FECHA                                                  US$                                  SALDO   "
En8 = "FECHA     COMPROBANTE      DOCUMENTO    REFERENC.  VENCTO    GLOSA                                    IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "******** *************** ************** ********** ******** ************************************ ************* ************ ************ **************"
ELSE
En6 = "******** *************** ************** ********** ******** ************************************ ************* ************ ************ **************"
En7 = "               No.                                 FECHA                                                  S/.                                   SALDO  "
En8 = "FECHA     COMPROBANTE      DOCUMENTO    REFERENC.  VENCTO    GLOSA                                    IMPORTE      CARGOS       ABONOS         ACTUAL  "
En9 = "******** *************** ************** ********** ******** ************************************ ************* ************ ************ **************"
ENDIF
*      0******* 9************** 25************ 40******** 51****** 60********************************** 97*********** 111********* 124********* 137***********"
*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15

Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0
PRINTJOB
   GOTO RegIni
   NumPag   = 0
fTSdoUsa = 0
fTCargos = 0
fTAbonos = 0
fTNumItm = 0
DO WHILE !EOF()
 XdFchVto = FchVto
 fbSdoUsa = 0
 fbCargos = 0
 fbAbonos = 0
 fbNumItm = 0
 DO WHILE FchVto=XdFchVto
    TsCodCta = CodCta
    =SEEK(TsCodCta,"CTAS")
    SubTitulo= TRIM(CTAS->NomCta)
    L0NumItm = 0
    L0SdoUsa = 0
    L0Cargos = 0
    L0Abonos = 0
    Quiebre1 = .T.
    DO WHILE DTOS(FchVto)+COdCta=DTOS(XdFchVto)+TsCodCta
       Llave = DTOS(FchVto)+CodCta+CodAux
       =SEEK(CTAS->CLFAUX+CodAux,"AUXI")
       LsCodCta = CodCta
       LsClfAux = ClfAux
       LsCodAux = CodAux
       L1NumItm = 0
       L1SdoUsa = 0
       L1Cargos = 0
       L1Abonos = 0
       Quiebre2 = .T.
       DO WHILE DTOS(FchVto)+CodCta+CodAux = Llave .AND. ! Cancelar
          **** Quiebre por Proveedor ****
          LsNroDoc = NroDoc
          LiCodMon = CodMon
          L2NumItm = 0
          L2SdoUsa = 0
          L2Cargos = 0
          L2Abonos = 0
          DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
             IF NROMES <= XsNroMes
                DO LinImp
             ELSE
                SKIP
             ENDIF
             Cancelar = ( INKEY() = Escape )
          ENDDO
          IF ! Cancelar .AND. L2NumItm > 0
             do resETPAG
             NumLin= PROW() + 1
             L2SalAct = L2Cargos - L2Abonos
             IF L2SalAct >= 0
                @ NumLin ,137 SAY L2SalAct       PICTURE "9,999,999.99"
             ELSE
                @ NumLin ,137 SAY -L2SalAct      PICTURE "9,999,999.99-"
             ENDIF
             NumLin = PROW()+1
             @ NumLin,0 SAY REPLICATE(".",Ancho)
             L1NumItm = L1NumItm + 1
             L1SdoUsa = L1SdoUsa + L2SdoUsa
             L1Cargos = L1Cargos + L2Cargos
             L1Abonos = L1Abonos + L2Abonos
             DO TotXFvto
          ENDIF
       ENDDO
       IF ! Cancelar .AND. L1NumItm > 0
          DO RESETPAG
          NumLin = PROW()+1
          L1SalAct = L1Cargos - L1Abonos
          @ NumLin,56 SAY "** TOTAL "+LsCodAux+" **"


          IF L1SdoUsa >= 0
          @ NumLin ,97  SAY L1SdoUsa       PICTURE "@Z 9999,999.99"
          ELSE
          @ NumLin ,97  SAY -L1SdoUsa      PICTURE "@Z 9999,999.99-"
          ENDIF


          IF L1Cargos >= 0
             @ NumLin ,111 SAY L1Cargos       PICTURE "9999,999.99"
          ELSE
             @ NumLin ,111 SAY -L1Cargos      PICTURE "9999,999.99-"
          ENDIF
          IF L1Abonos >= 0
             @ NumLin ,124 SAY L1Abonos       PICTURE "9999,999.99"
          ELSE
             @ NumLin ,124 SAY -L1Abonos      PICTURE "9999,999.99-"
          ENDIF
          IF L1SalAct >= 0
             @ NumLin ,137 SAY L1SalAct       PICTURE "9,999,999.99"
          ELSE
             @ NumLin ,137 SAY -L1SalAct      PICTURE "9,999,999.99-"
          ENDIF
          DO RESETPAG
          NumLin = PROW()+1
          @ NumLin,0 SAY REPLICATE("-",Ancho)
          L0NumItm = L0NumItm + 1
          L0SdoUsa = L0SdoUsa + L1SdoUsa
          L0Cargos = L0Cargos + L1Cargos
          L0Abonos = L0Abonos + L1Abonos
       ENDIF
    ENDDO
    IF ! Cancelar .AND. L0NumItm > 0
       DO RESETPAG
       NumLin = PROW()+1
       L0SalAct = L0Cargos - L0Abonos
       @ NumLin,56 SAY "*  TOTAL "+TsCodCta
       IF L0SdoUsa >= 0
          @ NumLin ,97 SAY L0SdoUsa       PICTURE "9999,999.99"
       ELSE
          @ NumLin ,97 SAY -L0SdoUsa       PICTURE "9999,999.99-"
       ENDIF
       IF L0Cargos >= 0
          @ NumLin ,111 SAY L0Cargos       PICTURE "9999,999.99"
       ELSE
          @ NumLin ,111 SAY -L0Cargos      PICTURE "9999,999.99-"
       ENDIF
       IF L0Abonos >= 0
          @ NumLin ,124 SAY L0Abonos       PICTURE "9999,999.99"
       ELSE
          @ NumLin ,124 SAY -L0Abonos      PICTURE "9999,999.99-"
       ENDIF
       IF L0SalAct >= 0
          @ NumLin ,137 SAY L0SalAct       PICTURE "9,999,999.99"
       ELSE
          @ NumLin ,137 SAY -L0SalAct      PICTURE "9,999,999.99-"
       ENDIF
       DO RESETPAG
       NumLin = PROW()+1
       @ NumLin,0 SAY REPLICATE("=",Ancho)
       fbNumItm = fbNumItm + 1
       fbSdoUsa = fbSdoUsa + L0SdoUsa
       fbCargos = fbCargos + L0Cargos
       fbAbonos = fbAbonos + L0Abonos
    ENDIF
 ENDDO
 IF ! Cancelar
    DO RESETPAG
    NumLin = PROW()+1
    fbSalAct = fbCargos - fbAbonos
    @ NumLin,56 SAY "*  TOTAL "+dtoc(XdFchVto)
    IF fbSdoUsa >= 0
       @ NumLin ,97  SAY fbSdoUsa       PICTURE "9999,999.99"
    ELSE
       @ NumLin ,97  SAY -fbSdoUsa      PICTURE "9999,999.99-"
    ENDIF
    IF fbCargos >= 0
       @ NumLin ,111 SAY fbCargos       PICTURE "9999,999.99"
    ELSE
       @ NumLin ,111 SAY -fbCargos      PICTURE "9999,999.99-"
    ENDIF
    IF fbAbonos >= 0
       @ NumLin ,124 SAY fbAbonos       PICTURE "9999,999.99"
    ELSE
       @ NumLin ,124 SAY -fbAbonos      PICTURE "9999,999.99-"
    ENDIF
    IF fbSalAct >= 0
       @ NumLin ,137 SAY fbSalAct       PICTURE "9,999,999.99"
    ELSE
       @ NumLin ,137 SAY -fbSalAct      PICTURE "9,999,999.99-"
    ENDIF
    NumLin = PROW()+1
    @ NumLin,0 SAY REPLICATE("*",Ancho)

    ftNumItm = ftNumItm + 1
    ftSdoUsa = ftSdoUsa + fbSdoUsa
    ftCargos = ftCargos + fbCargos
    ftAbonos = ftAbonos + fbAbonos

 ENDIF
ENDDO
DO RESETPAG
NumLin = PROW()+1
fTSalAct = fTCargos - fTAbonos
@ NumLin,56 SAY "*  TOTAL GENERAL *"
IF fTSdoUsa >= 0
   @ NumLin ,97  SAY fTSdoUsa       PICTURE "9999,999.99"
ELSE
   @ NumLin ,97  SAY -fTSdoUsa      PICTURE "9999,999.99-"
ENDIF
IF fTCargos >= 0
   @ NumLin ,111 SAY fTCargos       PICTURE "9999,999.99"
ELSE
   @ NumLin ,111 SAY -fTCargos      PICTURE "9999,999.99-"
ENDIF
IF fTAbonos >= 0
   @ NumLin ,124 SAY fTAbonos       PICTURE "9999,999.99"
ELSE
   @ NumLin ,124 SAY -fTAbonos      PICTURE "9999,999.99-"
ENDIF
IF fTSalAct >= 0
   @ NumLin ,137 SAY fTSalAct       PICTURE "9,999,999.99"
ELSE
   @ NumLin ,137 SAY -fTSalAct      PICTURE "9,999,999.99-"
ENDIF
DO RESETPAG
NumLin = PROW()+1
@ NumLin,0 SAY REPLICATE("*",Ancho)
DO RESETPAG
NumLin = PROW()+1
@ NumLin,0 SAY REPLICATE("*",Ancho)
** Resumen ***
NumPag = 0
DO RESETPAG
NumLin = PROW() + 1
@ NumLin,00 SAY _Prn6a+[*** R E S U M E N ***]+_Prn6b
XXImport = 0
XXImpUsa = 0
SELE TEMPO2
SET ORDER TO CODCta
GO TOP
DO WHILE !EOF()
    LsCodCta=COdCta
    DO RESETPAG
    NumLin = PROW() + 1
    @ NumLin,0 SAY CodCta+[ ]+GloDoc
    YYImport = 0
    YYImpUsa = 0
    SCAN WHILE COdCta=LsCodCta
        DO RESETPAG

        NumLin = PROW() + 1
        @ NumLin,0 SAY CodCta+[ ]+GloDoc+[ ]+NroCta
        IF ImpUsa>=0
           @ NumLin,97 SAY ImpUsa PICT "9,999,999.99"
        ELSE
           @ NumLin,97 SAY ImpUsa PICT "9,999,999.99-"
        ENDIF

        IF Import>=0
           @ NumLin,137 SAY Import PICT "9,999,999.99"
        ELSE
           @ NumLin,137 SAY Import PICT "9,999,999.99-"
        ENDIF
        XXImport  = XxImport + Import
        XXImpUsa  = XXImpUsa + ImpUsa
        YYImport  = XxImport + Import
        YYImpUsa  = XXImpUsa + ImpUsa
   ENDSCAN
   DO ResetPag
   NumLin= PROW() + 1
   @ NumLin ,0 SAY [* TOTAL CUENTA ]+LsCodCta
   IF YYImpUsa>=0
      @ NumLin,95 SAY YYImpUsa PICT "999,999,999.99"
   ELSE
      @ NumLin,95 SAY YYImpUsa PICT "999,999,999.99-"
   ENDIF
   ***
   IF YYImport>=0
      @ NumLin,135 SAY YYImport PICT "999,999,999.99"
   ELSE
      @ NumLin,135 SAY YYImport PICT "999,999,999.99-"
   ENDIF
ENDDO
***
DO ResetPag
NumLin= PROW() + 1
@ NumLin ,0 SAY [*** TOTAL RESUMEN ***]
IF XXImpUsa>=0
   @ NumLin,95 SAY XXImpUsa PICT "999,999,999.99"
ELSE
   @ NumLin,95 SAY XXImpUsa PICT "999,999,999.99-"
ENDIF
***
IF XXImport>=0
   @ NumLin,135 SAY XXImport PICT "999,999,999.99"
ELSE
   @ NumLin,135 SAY XXImport PICT "999,999,999.99-"
ENDIF
*** Fin Resumen ****
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
*IF Cargos = 0 .AND. Abonos = 0 .AND. (LsCodOpe="015" .AND. LsNroAst="000002")
*    RETURN
*ENDIF
DO RESETPAG
IF Quiebre2
   Quiebre2 = .F.
   NumLin = PROW()+1
   @ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
IF Quiebre1
   Quiebre1 = .F.
   NumLin = PROW()+1
   @ NumLin,0   SAY _Prn6a+TsCodCta+" "+CTAS.NomCta+_Prn6b
ENDIF



NumLin = PROW()+1
@ NumLin , 0  SAY LsFchAst
@ NumLin , 9  SAY LsCodOpe
@ NumLin , 13 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 25 SAY LsNroDoc
@ NumLin , 40 SAY LsNroRef
IF ! EMPTY(LsFchVto)
   @ NumLin , 51 SAY LsFchVto
ENDIF
@ NumLin , 60 SAY LsGloDoc        PICTURE "@S36"

IF SdoUsa >= 0
   @ NumLin ,97  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,97  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF

IF Cargos >= 0
   @ NumLin ,111 SAY Cargos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,111 SAY -Cargos      PICTURE "@Z 9999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,124 SAY Abonos       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,124 SAY -Abonos      PICTURE "@Z 9999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2SdoUsa = L2SdoUsa + SdoUsa
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
******************
PROCEDURE GenRepor
******************

WAIT WINDOW [Generando informaci¢n...Un momento por favor] NOWAIT
ArcTmp2= PATHUSER+SYS(3)
ArcTmp = PATHUSER+SYS(3)

SELECT RMOV
COPY STRU TO (ArcTmp)
COPY STRU TO (ArcTmp2)
***
SELE 0
USE (ArcTmp) ALIAS TEMPO EXCLU
IF !USED()
    CLOSE DATA
    return .f.
ENDIF
INDEX ON DTOS(FchVto)+CodCta+CodAux+NroDoc TAG FchVto
SET ORDER TO FchVto
***
SELE 0
USE (ArcTmp2) ALIAS TEMPO2 EXCLU
IF !USED()
    CLOSE DATA
    return .f.
ENDIF
INDEX ON DTOS(FchVto)+COdCta+CodAux+NroDoc TAG FChVto
INDEX ON COdCta+DTOS(FchVto) TAG COdCTa
SET ORDER TO FchVto
***
SELE RMOV
Llave = TRIM(XsCodCta)
IF ! EMPTY(XsCodAux)
   Llave = XsCodCta+TRIM(XsCodAux)
ENDIF
*Llave1 = TRIM(XsCtaf)
IF EMPTY(XsCtaf)
   Llave1 = [99999999]
ELSE
   Llave1 = TRIM(XsCtaf)+CHR(255)
ENDIF
SEEK Llave
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
IF EOF()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN .F.
ENDIF
Cancelar = .f.
_I = 1
DO WHILE CodCta<=Llave1 AND _I = 1

   IF Llave1=[99999999]
      _I = 0
   ELSE
     Llave = CodCta
     =SEEK(Llave,"CTAS")
     SubTitulo= TRIM(CTAS->NomCta)
   ENDIF
   wait window SUBTITULO NOWAIT
   NumPag   = 0
   L0NumItm = 0
   L0SdoUsa = 0
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
      L1SdoUsa = 0
      L1Cargos = 0
      L1Abonos = 0
      Quiebre1 = .T.

      wait window SUBTITULO+[ ]+LsCodAux+[ ]+TRIM(AUXI.NomAux) NOWAIT
      DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
         **** Quiebre por Documento ****
         LsNroDoc = NroDoc
         LiCodMon = CodMon
         L2NumItm = 0
         L2SdoUsa = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         DO CHECKDOC  && *** VERIFICANDO LAS CONDICIONES DE IMPRESION ***

         DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
            wait window SUBTITULO+[ ]+LsCodAux+[ ]+TRIM(AUXI.NomAux)+[ ]+LsNroDoc NOWAIT
            IF NROMES <= XsNroMes
               DO GrbPend
            ELSE
               SKIP
            ENDIF
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            L2SalAct = L2Cargos - L2Abonos
            L1NumItm = L1NumItm + 1
            L1SdoUsa = L1SdoUsa + L2SdoUsa
            L1Cargos = L1Cargos + L2Cargos
            L1Abonos = L1Abonos + L2Abonos
         ENDIF
      ENDDO
      IF ! Cancelar .AND. L1NumItm > 0
         L1SalAct = L1Cargos - L1Abonos


         IF L1SdoUsa >= 0
         ELSE
         ENDIF


         IF L1Cargos >= 0
         ELSE
         ENDIF
         IF L1Abonos >= 0
         ELSE
         ENDIF
         IF L1SalAct >= 0
         ELSE
         ENDIF
         L0NumItm = L0NumItm + 1
         L0SdoUsa = L0SdoUsa + L1SdoUsa
         L0Cargos = L0Cargos + L1Cargos
         L0Abonos = L0Abonos + L1Abonos
      ENDIF
   ENDDO
   IF ! Cancelar .AND. L0NumItm > 0
      L0SalAct = L0Cargos - L0Abonos
      IF L0SdoUsa >= 0
      ELSE
      ENDIF
      IF L0Cargos >= 0
      ELSE
      ENDIF
      IF L0Abonos >= 0
      ELSE
      ENDIF
      IF L0SalAct >= 0
      ELSE
      ENDIF
   ENDIF
ENDDO
SELE TEMPO
USE
SELE RMOV
USE (ArcTmp) ORDER FchVto ALIAS RMOV
IF !USED()
   CLOSE DATA
   RETURN .F.
ENDIF
WAIT WINDOW [OK] NOWAIT
RETURN .t.
*****************
PROCEDURE GrbPend
*****************
SCATTER MEMVAR
SELE TEMPO
append blank
GATHER MEMVAR
SELE RMOV
skip
RETURN
******************
PROCEDURE TotxFvto
******************
PRIVATE TdFchVto
TdFchVto =IIF(XdFchVto<=DATE(),DATE(),XdFchVto)
SELE TEMPO2
SEEK DTOS(TdFchVto)+TsCodCta
IF !FOUND()
    APPEND BLANK
    REPLACE FchVto WITH TdFchVto
    REPLACE CodCta WITH TsCodCta
    REPLACE GloDoc WITH CTAS.NomCta
    REPLACE NroCta WITH [Vcmto:]+DTOC(FchVto)
ENDIF
IF XiCodMon=1
	REPLACE Import WITH Import + L2SalAct
	REPLACE ImpUsa WITH ImpUsa + L2SdoUsa
ELSE
	REPLACE ImpUsa WITH ImpUsa + L2SalAct
	REPLACE Import WITH Import + L2SdoUsa
ENDIF
SELE RMOV
