********************************************************************************
* Progrma       : CBDRC003.PRG                                                 *
* Objeto        : BALANCE DE CUENTA CORRIENTE                                  *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************

cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE CUENTA CORRIENTE"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
k_esc=27
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
XiTpoMov = 1
UltTecla = 0
i        = 1
@ 10,13 SAY "Moneda        : "
@ 11,13 SAY "Cuenta        : "
@ 13,13 SAY "Clasificaci¢n : "
@ 15,13 SAY "Auxiliar      : "
@ 17,13 SAY "Tipo          : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,33,2)
      CASE I = 2
         SELECT CTAS
         @ 11,30 GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
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
         @ 11,30 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 12,30 SAY CTAS->NomCta    PICT "@S35"
         XsClfaux = ClfAux
         SELECT TABL
         XsTabla = "01"
         @ 13,30 SAY XsClfAux
         =SEEK(XsTabla+XsClfAux,"TABL")
         @ 14,30 SAY TABL->Nombre    PICT "@S35"
      CASE I = 5 .AND. CTAS->PIDAUX = "S"
         IF ! EMPTY(XsClfaux)
            iDigitos = TABL->Digitos
            IF iDigitos <= 0 .OR. iDigitos > LEN(XsCodAux)
               iDigitos = LEN(XsCodAux)
            ENDIF
            SELECT AUXI
            @ 15,30 GET XsCodAux PICT REPLICATE("!",iDigitos)
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
            @ 15,30 SAY XsCodAux
            SEEK XsClfAux+XsCodAux
            IF ! FOUND() .AND. ! EMPTY(XsCodAUX)
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 16,30 SAY AUXI->NomAux PICT "@S35"
         Else
           XsCodAux = SPACE(LEN(AUXI.CodAux))
         ENDIF
      CASE I = 6
         VecOpc(1)="Movimientos de Mes"
         VecOpc(2)="Movimiento Total"
         XiTpoMov= Elige(XiTpoMov,17,30,2)
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
IF EMPTY(XsCodCta)
   GsMsgErr = "Invalida cuenta seleccionada"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
***** Registro de inicio de Impresi¢n ******
LsCtas=.f.
SELECT RMOV
Llave = XsCodCta+TRIM(XsCodAux)
IF LEN(TRIM(XsCodCta))<LEN(RMOV.CodCta)
	LLave = TRIM(XsCodCta)
	LsCtas=.t.
ENDIF
SEEK Llave
IF ! FOUND()
   GsMsgErr = "No existen registros a listar"
   do f1msgerr WITH GsMsgErr
   CLOSE DATA
   RETURN
ENDIF

DO F0PRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF

IniImp   = _Prn8a+_Prn4    && 15   cpi
Ancho    = 150
Largo    = 66
LinFin   = 88 - 8
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "BALANCE DE CUENTA CORRIENTE AL "+DTOC(GdFecha)
SubTitulo= TRIM(CTAS->NomCta)
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    = ""
En4    = ""
En5    = ""
En6 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ **************"
En7 = "               No.                                 FECHA    FECHA                                         US$                                   SALDO  "
En8 = "FECHA     COMPROBANTE     DOCUMENTO     REFERENC.  VENCTO   FINANZAS GLOSA                            IMPORTE       CARGOS       ABONOS         ACTUAL "
En9 = "******** *************** ************** ********** ******** ******** *************************** ************* ************ ************ **************"
*      0******* 9************** 25************ 40******** 51****** 60****** 69************************* 97*********** 111********* 124********* 137***********"
*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14    
Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   L0NumItm = 0
   L0Cargos = 0
   L0Abonos = 0
   LsUltCta = space(len(ctas.codcta))
   LsQuiCta = .f.
   Store 0 to LaNumItm,LaCargos,LaAbonos
   DO WHILE CodCta+CodAux = Llave .AND. ! Cancelar
      IF CodCta<>LsUltCta
      	LSUltCta=CodCta
		LsQuiCta=.t.
		Store 0 to LaNumItm,LaCargos,LaAbonos
      ENDIF    		
      **** \uiebre por Proveedor ****
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
         LsNroDoc = NroDoc
         LiCodMon = CodMon
         L2NumItm = 0
         L2Cargos = 0
         L2Abonos = 0
         Quiebre2 = .T.
         IF XiTpoMov = 1
            DO CHECKDOC  && *** FILTRA MOVIMIENTOS DEL MES ***
         ENDIF
         DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
            DO CASE
               CASE XiTpoMov = 1
                  IF NROMES = XsNroMes
                     DO LinImp
                  ELSE
                     SKIP
                  ENDIF
               CASE XiTpoMov = 2
                  IF NROMES <= XsNroMes
                     DO LinImp
                  ELSE
                     SKIP
                  ENDIF
            ENDCASE
            Cancelar = ( INKEY() = Escape )
         ENDDO
         IF ! Cancelar .AND. L2NumItm > 0
            L2SalAct = L2Cargos - L2Abonos
            IF !LsCtas
	            NumLin = PROW()
	            IF L2SalAct >= 0
	               @ NumLin ,137 SAY L2SalAct       PICTURE "99999,999.99"
	            ELSE
	               @ NumLin ,137 SAY -L2SalAct      PICTURE "99999,999.99-"
	            ENDIF
	            NumLin = PROW()+1
	            @ NumLin,0 SAY REPLICATE(".",Ancho)
            ENDIF
            L1NumItm = L1NumItm + 1
            L1Cargos = L1Cargos + L2Cargos
            L1Abonos = L1Abonos + L2Abonos
         ENDIF
      ENDDO
      IF ! Cancelar .AND. L1NumItm > 0
         NumLin = PROW()+1
         L1SalAct = L1Cargos - L1Abonos
         @ NumLin,56 SAY "** TOTAL "+LsCodAux+" **"
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
            @ NumLin ,137 SAY L1SalAct       PICTURE "99999,999.99"
         ELSE
            @ NumLin ,137 SAY -L1SalAct      PICTURE "99999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("-",Ancho)
         L0NumItm = L0NumItm + 1
         L0Cargos = L0Cargos + L1Cargos
         L0Abonos = L0Abonos + L1Abonos
      ENDIF
      **
      IF ! Cancelar .AND. LaNumItm > 0 AND  LsCtas
         NumLin = PROW()+1
         LaSalAct = LaCargos - LaAbonos
         @ NumLin,56 SAY "** TOTAL CUENTA "+LsUltCta+" **"
         IF LaCargos >= 0
            @ NumLin ,111 SAY LaCargos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,111 SAY -LaCargos      PICTURE "9999,999.99-"
         ENDIF
         IF LaAbonos >= 0
            @ NumLin ,124 SAY LaAbonos       PICTURE "9999,999.99"
         ELSE
            @ NumLin ,124 SAY -LaAbonos      PICTURE "9999,999.99-"
         ENDIF
         IF LaSalAct >= 0
            @ NumLin ,137 SAY LaSalAct       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,137 SAY -LaSalAct      PICTURE "9,999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("-",Ancho)
      ENDIF
   ENDDO
   IF ! Cancelar .AND. L0NumItm > 0
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("=",Ancho)
      NumLin = PROW()+1
      L0SalAct = L0Cargos - L0Abonos
      @ NumLin,56 SAY "*  TOTAL GENERAL *"
      IF L0Cargos >= 0
         @ NumLin ,111 SAY L0Cargos       PICTURE "99999999.99"
      ELSE
         @ NumLin ,111 SAY -L0Cargos      PICTURE "99999999.99-"
      ENDIF
      IF L0Abonos >= 0
         @ NumLin ,124 SAY L0Abonos       PICTURE "99999999.99"
      ELSE
         @ NumLin ,124 SAY -L0Abonos      PICTURE "99999999.99-"
      ENDIF
      IF L0SalAct >= 0
         @ NumLin ,137 SAY L0SalAct       PICTURE "99999,999.99"
      ELSE
         @ NumLin ,137 SAY -L0SalAct      PICTURE "99999,999.99-"
      ENDIF
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO F0PRFIN IN BELCSOFT
CLOSE DATA
RETURN
**********************************************************************
PROCEDURE LinImp
****************
IF NumPag = 0 .OR. PROW() > LinFin
   DO RESETPAG
   IF Cancelar
      EXIT
   ENDIF
ENDIF
IF LsQuiCta AND lsCtas
	LsQuiCta=.f.
	NumLin = PROW()+1
	@ NumLin,0   SAY _Prn6a+CODCTA+[ ]+CTAS.NomCta+_Prn6b
	
ENDIF
IF Quiebre1
   Quiebre1 = .F.
   NumLin = PROW()+1
   @ NumLin,0   SAY _Prn6a+LsCodAux+" "+AUXI->NomAux+_Prn6b
ENDIF
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
LsFchPed = DTOC(FchPed)
LsFchPed = LEFT(LsFchPed,2)+SUBSTR(LsFchPed,4,2)+RIGHT(LsFchPed,4)
LsGloDoc = GloDoc
IF EMPTY(LsGloDoc)
   LsGloDoc = VMOV->NotAst
ENDIF


DO WHILE NroMes+CodOpe+NroAst = LsNroMes+LsCodOpe+LsNroAst .AND. ! EOF() ;
   .AND. CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc
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
ENDDO
IF NumItm > 1
   LsCodRef = TRIM(LsCodRef)+"*"
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
*@ NumLin, 60 SAY LsGloDoc        PICTURE "@S36"

@ numlin,  60 say lsfchped
@ NumLin , 69 SAY LsGloDoc        PICTURE "@S27"

IF SdoUsa >= 0
   @ NumLin ,97  SAY SdoUsa       PICTURE "@Z 9999,999.99"
ELSE
   @ NumLin ,97  SAY -SdoUsa      PICTURE "@Z 9999,999.99-"
ENDIF

IF Cargos >= 0
   @ NumLin ,111 SAY Cargos       PICTURE "9999,999.99"
ELSE
   @ NumLin ,111 SAY -Cargos      PICTURE "9999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,124 SAY Abonos       PICTURE "9999,999.99"
ELSE
   @ NumLin ,124 SAY -Abonos      PICTURE "9999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
**
LaNumItm = LaNumItm + 1
LaCargos = LaCargos + Cargos
LaAbonos = LaAbonos + Abonos
**
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
return
******************
PROCEDURE ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   Inicio  = .F.
   DO F0MBPRN IN BELCSOFT
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
IF SalAct <> 0 .OR. UltMes = XsNroMes
   Goto RegAct
ENDIF
RETURN
