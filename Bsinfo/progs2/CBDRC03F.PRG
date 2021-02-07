********************************************************************************
* Progrma       : CBDRC003.PRG                                                 *
* Objeto        : BALANCE DE CUENTA CORRIENTE                                  *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE CUENTA CORRIENTE"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 22,68      COLOR W/N
@  8,11 CLEAR TO 21,69
@  8,11       TO 21,69
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
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV
**********************************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCta = SPACE(LEN(CodCta))
XsCodCt2 = SPACE(LEN(CodCta))
XiTpoMov = 1
XsCodRef = SPACE(LEN(CTAS->CodRef))
UltTecla = 0
i        = 1
TAux     =''

@ 10,13 SAY "Cuenta Desde  : "
@ 11,13 SAY "       Hasta  : "
@ 13,13 SAY "Clasificaci¢n : "
@ 15,13 SAY "Auxiliar      : "
@ 17,13 SAY "Tipo          : "
@ 19,13 SAY "Divisionaria  : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE I = 1
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
         @ 10,40 SAY CTAS->NomCta    PICT "@S25"

      CASE I = 2
         SELECT CTAS
         @ 11,30 GET XsCodCt2 PICT REPLICATE("9",LEN(XsCodCt2))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCt2)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCt2 = CTAS->CodCta
         ENDIF
         @ 11,30 SAY XsCodCt2
         SEEK XsCodCt2
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 11,40 SAY NomCta    PICT "@S25"

      CASE I = 3
         IF (XsCodCta = XsCodct2)
            XsClfaux = ClfAux
            SELECT TABL
            XsTabla = "01"
            @ 13,30 SAY XsClfAux
            =SEEK(XsTabla+XsClfAux,"TABL")
            @ 14,30 SAY TABL->Nombre    PICT "@S35"
         ELSE
            XsClfAux = SPAC(LEN(ClfAux))
            @ 14,30 SAY SPAC(35)
         ENDI
         IF EMPTY(XsClfAux)
            TAux = '.T.'
         ELSE
            TAux = 'ClfAux = XsClfAux'
         ENDI
      CASE I = 4
         IF (XsCodCta = XsCodct2) .AND. CTAS->PIDAUX="S"
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
                    *XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
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
              XsCodAux = SPACE(LEN(CodAux))
            ENDIF
         ELSE
            XsCodAux = SPACE(LEN(AUXI.CodAux))
            @ 16,30 SAY SPAC(35)
         ENDIF
      CASE I = 5
         IF (XsCodCta = XsCodct2) .AND. CTAS->PIDAUX#"S"
            i = i - 1
            GsMsgErr = "Cuenta no trabaja con Auxiliares"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDI
      CASE I = 6
         VecOpc(1)="Movimientos de Mes"
         VecOpc(2)="Movimiento Total"
         XiTpoMov= Elige(XiTpoMov,17,30,2)
      CASE i = 7
         XsClfTmp = XsClfAux
         XsClfAux = "DIV"
         SELE AUXI
         @ 19,30 GET XsCodRef PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF CbdBusca("AUXI")
               XsCodRef = LEFT(AUXI->CodAux,LEN(XsCodRef))
               UltTecla = Enter
            ELSE
               XsClfAux = XsClfTmp
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         IF !SEEK(XsClfAux+XsCodRef,"AUXI") .AND. !EMPTY(XsCodRef)
            XsClfAux = XsClfTmp
            UltTecla = 0
            LOOP
         ENDIF
         XsNomAux=LEFT(AUXI.NomAux,30)
         @ 19,30 SAY XsCodRef
         @ 19,35 SAY LEFT(AUXI.NomAux,30)
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         XsClfAux = XsClfTmp
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>7,7,i)
   i = IIF(i<1,1,i)
ENDDO

IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
IF EMPTY(XsCodCta) OR EMPTY(XsCodCt2)
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
Llave = XsCodCta+TRIM(XsCodAux)
SEEK Llave
IF ! FOUND()
   IF XsCodCta = XsCodCt2
      GsMsgErr = "No existen registros a listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ELSE
      SEEK XsCodCta
   ENDI
ENDIF

IF !EMPTY(XsCodRef)
   TstLin1 =[RMOV.CodRef=XsCodRef]
ELSE
   TstLin1 = [.T.]
ENDIF

*  set filter to RMOV->nromes=TRANSF(_MES,"@L ##")
IniImp   = _Prn8a+_Prn4    && 15   cpi
Ancho    = 174
Largo    = 66
LinFin   = 88 - 8
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "BALANCE DE CUENTA CORRIENTE AL "+DTOC(GdFecha)
IF XsCodCta = XsCodCt2
   SubTitulo= XsCodCta+' '+ TRIM(CTAS->NomCta)
ELSE
   SubTitulo= 'Desde : '+ALLT(XsCodCta)+' '+ 'Hasta : '+ALLT(XsCodCt2)
ENDI
EN1    = "(EXPRESADO EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = " "
En3    = ""
En4    = ""
En5 = "                                                                                                                                            "+time()
En6 = "****** ************* *********** ************ ******** *********** *************** *************** ******************** ************* ************* ************* *************"
En7 = "             No.                               FCH.                                                                          US$                                     SALDO     "
En8 = "FECHA   COMPROBANTE  DOCUMENTO   REFERENC.     VTO     NRO.CHEQUE  BANCO           GIRADO A        GLOSA                   IMPORTE         CARGOS      ABONOS        ACTUAL    "
En9 = "****** ************* *********** ************ ******** *********** *************** *************** ******************** ************* ************* ************* *************"
*                                                                                                                              9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99
*      0***** 7************ 21******** 32******** 43**** 50***55**********67**************83************* 99*******************120***********134 **********148***********162***********   179
*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901


Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   LGNumItm = 0
   LGDolar  = 0
   LGCargos = 0
   LGAbonos = 0
   LsCodCta = SPAC(LEN(CodCta))
   XsRecno = RECNO()
 DO WHILE CodCta <= XsCodCt2 .AND. !EOF() .AND. !Cancelar
   L0NumItm = 0
   L0Dolar  = 0
   L0Cargos = 0
   L0Abonos = 0
   IF !EMPTY(XsCodAux) AND !EMPTY(LsCodCta)
      DO WHILE LsCodCta = CodCta AND !EOF() AND !Cancelar
         SKIP
      ENDD
      LsCodCta = SPAC(LEN(CodCta))
      XsRecno = RECNO()
      LOOP
   ENDI
   LsCodCta = CodCta
   =SEEK(LsCodCta,"CTAS")
   IF CTAS->PidAux # 'S'
      DO WHILE LsCodCta = CodCta AND !EOF() AND !Cancelar
         SKIP
      ENDD
      LOOP
   ENDI
   Llave = TRIM(LsCodCta)
   IF ! EMPTY(XsCodAux)
      Llave = LsCodCta+TRIM(XsCodAux)
   ENDIF
   SEEK Llave
   IF FOUND()
      =SEEK(CodCta,"CTAS")
      IF (XsCodCta # XsCodCt2)
         DO RESETPAG
         NumLin = PROW()+1
         @ NumLin,0   SAY _PRN6A+LsCodCta+' '+CTAS->NomCta+_PRN6B
         NumLin = PROW()+1
         @ NumLin,0  SAY REPL('-',LEN(LsCodCta)+LEN(ALLT(CTAS->NomCta))+1)
         NumLin = PROW()+1
         @ NumLin,0  SAY ''
         NumLin = PROW()
      ENDIF
      DO WHILE CodCta+CodAux = Llave .AND. ! Cancelar
         **** Quiebre por Proveedor ****
         =SEEK(CodCta,"CTAS")
         =SEEK(CTAS->CLFAUX+CodAux,"AUXI")
         LsCodCta = CodCta
         LsClfAux = ClfAux
         LsCodAux = CodAux
         L1NumItm = 0
         L1Dolar  = 0
         L1Cargos = 0
         L1Abonos = 0
         Quiebre1 = .T.
         DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! Cancelar
            **** Quiebre por Documento ****
            LsNroDoc = NroDoc
            LiCodMon = CodMon
            L2NumItm = 0
            L2Dolar  = 0
            L2Cargos = 0
            L2Abonos = 0
            Quiebre2 = .T.
            IF XiTpoMov = 1
               DO CHECKDOC  && *** FILTRA MOVIMIENTOS DEL MES ***
            ENDIF
            DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! Cancelar
               IF !(&TstLin1.) OR VMOV->FlgEst = 'A' &&  OR !&TAux
                  SKIP
                  LOOP
               ENDIF
               IF XiTpoMov=1
                  IF NroMes = XsNroMes
                     DO LinImp
                  ELSE
                    SKIP
                  ENDIF
               ELSE
                  IF NROMES <= XsNroMes
                     DO LinImp
                  ELSE
                     SKIP
                  ENDIF
               ENDIF
               Cancelar = ( INKEY() = Escape )
            ENDDO
            IF ! Cancelar .AND. L2NumItm > 0
               L2SalAct = L2Cargos - L2Abonos
               NumLin = PROW()
               IF L2SalAct >= 0
                  @ NumLin ,162 SAY L2SalAct       PICTURE "9,999,999.99"
               ELSE
                  @ NumLin ,162 SAY -L2SalAct      PICTURE "9,999,999.99-"
               ENDIF
               NumLin = PROW()+1
               @ NumLin,0 SAY ''
               L1NumItm = L1NumItm + 1
               L1Dolar  = L1Dolar  + L2Dolar
               L1Cargos = L1Cargos + L2Cargos
               L1Abonos = L1Abonos + L2Abonos
            ENDIF
         ENDDO
         IF ! Cancelar .AND. L1NumItm > 0
            NumLin = PROW()+1
            L1SalAct = L1Cargos - L1Abonos
            @ NumLin,50 SAY "** TOTAL "+LsCodAux+" **"
            @ NumLin ,120 SAY L1Dolar        PICTURE "9,999,999.99"
            IF L1Cargos >= 0
               @ NumLin ,134 SAY L1Cargos       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,134 SAY -L1Cargos      PICTURE "9,999,999.99-"
            ENDIF
            IF L1Abonos >= 0
               @ NumLin ,148 SAY L1Abonos       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,148 SAY -L1Abonos      PICTURE "9,999,999.99-"
            ENDIF
            IF L1SalAct >= 0
               @ NumLin ,162 SAY L1SalAct       PICTURE "9,999,999.99"
            ELSE
               @ NumLin ,162 SAY -L1SalAct      PICTURE "9,999,999.99-"
            ENDIF
            NumLin = PROW()+1
            @ NumLin,0 SAY REPLICATE("-",Ancho)
            L0NumItm = L0NumItm + 1
            L0Dolar  = L0Dolar  + L1Dolar
            L0Cargos = L0Cargos + L1Cargos
            L0Abonos = L0Abonos + L1Abonos
         ENDIF
      ENDDO
      IF XsCodCta = XsCodCt2

      ENDI
      IF ! Cancelar .AND. L0NumItm > 0
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("=",Ancho)
         NumLin = PROW()+1
         L0SalAct = L0Cargos - L0Abonos
         @ NumLin,50 SAY "*  TOTAL CUENTA "+ ALLT(LsCodCta)+" *"
         @ NumLin ,120 SAY L0Dolar        PICTURE "9,999,999.99"
         IF L0Cargos >= 0
            @ NumLin ,134 SAY L0Cargos       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,134 SAY -L0Cargos      PICTURE "9,999,999.99-"
         ENDIF
         IF L0Abonos >= 0
            @ NumLin ,148 SAY L0Abonos       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,148 SAY -L0Abonos      PICTURE "9,999,999.99-"
         ENDIF
         IF L0SalAct >= 0
            @ NumLin ,162 SAY L0SalAct       PICTURE "9,999,999.99"
         ELSE
            @ NumLin ,162 SAY -L0SalAct      PICTURE "9,999,999.99-"
         ENDIF
         NumLin = PROW()+1
         @ NumLin,0 SAY REPLICATE("=",Ancho)
         LGNumItm = LGNumItm + 1
         LGCargos = LGCargos + L0Cargos
         LGAbonos = LGAbonos + L0Abonos
      ENDIF
   ELSE
      go xsrecno
      SELE RMOV
      IF !EOF()
         SKIP
      ENDI
   ENDI
   IF XsCodCta = XsCodCt2
      EXIT
   ENDI
ENDD
   IF ! Cancelar .AND. LGNumItm > 0
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("=",Ancho)
      NumLin = PROW()+1
      LGSalAct = LGCargos - LGAbonos
      @ NumLin,50 SAY "*  TOTAL GENERAL *"
      @ NumLin ,120 SAY LGDolar        PICTURE "9,999,999.99"
      IF LGCargos >= 0
         @ NumLin ,134 SAY LGCargos       PICTURE "9,999,999.99"
      ELSE
         @ NumLin ,134 SAY -LGCargos      PICTURE "9,999,999.99-"
      ENDIF
      IF LGAbonos >= 0
         @ NumLin ,148 SAY LGAbonos       PICTURE "9,999,999.99"
      ELSE
         @ NumLin ,148 SAY -LGAbonos      PICTURE "9,999,999.99-"
      ENDIF
      IF LGSalAct >= 0
         @ NumLin ,162 SAY LGSalAct       PICTURE "9,999,999.99"
      ELSE
         @ NumLin ,162 SAY -LGSalAct      PICTURE "9,999,999.99-"
      ENDIF
      NumLin = PROW()+1
      @ NumLin,0 SAY REPLICATE("=",Ancho)
      NumLin = PROW()+1
   ENDIF
   IF LGNumItm > 0
      EJECT PAGE
   ENDI
ENDPRINTJOB
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
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
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,2)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
*LsFchVto = LEFT(LsFchVto,2)+SUBSTR(LsFchVto,4,2)+RIGHT(LsFchVto,2)
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
@ NumLin , 7  SAY LsCodOpe
@ NumLin , 11 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 21 SAY LsNroDoc
@ NumLin , 33 SAY ALLT(LsNroRef)
IF ! EMPTY(LsFchVto)
   @ NumLin , 46 SAY LsFchVto
ENDIF
=SEEK(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,"VMOV")
@ NumLin , 55 SAY VMOV.NroChq     PICTURE "@S11"
SELE CTAS
XRE = RECNO()
SEEK VMOV.CtaCja
IF FOUND()
   @ NumLin , 67 SAY LEFT(CTAS.NomCta,15)     PICTURE "@!"
ENDIF
GO XRE
@ NumLin , 83 SAY LEFT(VMOV.Girado,15)     PICTURE "@!"
SELE RMOV

@ NumLin , 99 SAY LsGloDoc        PICTURE "@S20"

IF SdoUsa >= 0
   @ NumLin ,120 SAY SdoUsa       PICTURE "@Z 9,999,999.99"
ELSE
   @ NumLin ,120 SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
ENDIF

IF Cargos >= 0
   @ NumLin ,134 SAY Cargos       PICTURE "9,999,999.99"
ELSE
   @ NumLin ,134 SAY -Cargos      PICTURE "9,999,999.99-"
ENDIF
IF Abonos >= 0
   @ NumLin ,148 SAY Abonos       PICTURE "9,999,999.99"
ELSE
   @ NumLin ,148 SAY -Abonos      PICTURE "9,999,999.99-"
ENDIF
L2NumItm = L2NumItm + 1
L2Dolar  = L2Dolar  + SdoUsa
L2Cargos = L2Cargos + Cargos
L2Abonos = L2Abonos + Abonos
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
   IF !(&TstLin1.) OR VMOV->FlgEst = 'A'   && Filtra Divisionarias
      SKIP
      LOOP
   ENDIF
   IF NROMES <=XsNroMes
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
