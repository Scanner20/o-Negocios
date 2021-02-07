********************************************************************************
* Programa      : CBDRL008.PRG                                                 *
* Objeto        : LIBRO BANCOS                                                 *
*                                                                              *
* Autor         : JORGE MIESES VALENCIA                                        *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
***
sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
    close data
    return
endif
sele 4
use cbdrmovm order RMOV03 ALIAS RMOV
if !used(4)
    close data
    return
endif
sele 5
use cbdvmovm order VMOV01 ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(7)
    close data
    return
ENDIF

SELECT ACCT
SET FILTER TO NROMES <= STR(_MES,2,0)

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO BANCOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiCodMon = 1
XsCodCta = SPACE(LEN(CTAS->CodCta))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0

@ 10,18 SAY "            Cuenta Bancaria : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         SELECT CTAS
         @ 10,48 GET XsCodCta PICTURE "10"+REPLICATE("9",LEN(CTAS->CODCTA)-2)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTA2")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ 10,48 SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND() .AND. ! EMPTY(XsCodCta)
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 11,28 SAY CTAS->NomCta
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 1 , i + 1, 1 )

      CASE UltTecla = Enter
         IF  i < 1
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
SELECT RMOV

DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
Ancho = 137
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN8A+_PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = "L I B R O    B A N C O S"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = " "
En2 = ""
En3 = ""
En4 = ""
En5 = ""

En6 = "***** ****** *** ********** *************************************** ************* ************* *************************** *************"
En7 = "      COMPRO LI     Nro.                                               IMPORTE        SALDO          M O V I M I E N T O      S A L D O  "
En8 = "FECHA BANTE  BRO DOCUMENTO        GLOSA                                  US$        ANTERIOR        CARGOS       ABONOS         ACTUAL   "
En9 = "***** ****** *** ********** *************************************** ************* ************* ************* ************* *************"
*      0**** 6***** 13* 17******** 28************************************* 68*********** 82*********** 96*********** 110********** 124**********"



NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
LsCodRef = ""
PRINTJOB
   NumPag  = 0
   SELECT CTAS
   SEEK TRIM(XsCodCta)
   STORE 0 TO W
   DO WHILE CodCta=TRIM(XsCodCta) .AND. ! EOF() .AND. ! Cancelar
      IF AftMov = "S" .AND. INLIST(CodCta,"104","108")
         DO LinImp
      ENDIF
      SELECT CTAS
      SKIP
   ENDDO
   IF ! CANCELAR
      DO ResetPag
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL   BANCOS  **"
      FOR I=1 TO 4
          Col = (i-1)*14 + 82
          IF W(I) >= 0
             @ NumLin,Col SAY W(i) PICT "@Z 99999,999.99"
          ELSE
             @ NumLin,Col SAY -W(i) PICT "@Z 99999,999.99-"
          ENDIF
      ENDFOR
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("*",Ancho)
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

****************
PROCEDURE LinImp
****************
PRIVATE NumLin
XsNroMes = transf(_MES,"@L ##")
SELECT ACCT
SET ORDER TO ACCT02
SEEK CTAS->CodCta
IF ! FOUND()
   RETURN
ENDIF
STORE 0 TO X,Y
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar
   IF NroMes <  STR(_MES,2,0)
      X(1) = X(1) + DbeNac - HbeNac
      Y(1) = Y(1) + DbeExt - HbeExt
   ENDIF
   SKIP
ENDDO
DO ImpRMOV
DO ResetPag
NumLin = PROW() + 1
@ NumLin,000 SAY "TOTAL CUENTA    "+CTAS->CodCta
@ NumLin,028 SAY CTAS->NomCta
IF CTAS->CodMon = 2
   IF Y(1) >= 0
      @ NumLin,68    SAY  Y(1) PICT "99999,999.99"
   ELSE
      @ NumLin,68    SAY -Y(1) PICT "99999,999.99-"
   ENDIF
ENDIF
FOR I=1 TO 4
    Col = (i-1)*14 + 82
    IF X(I) >= 0
       @ NumLin,Col SAY X(i)  PICT "99999,999.99"
    ELSE
       @ NumLin,Col SAY -X(i) PICT "99999,999.99-"
    ENDIF
    W(I) = W(I) + X(I)
ENDFOR
NumLin = PROW() + 1
@ Numlin,000 SAY REPLICATE("=",Ancho)
RETURN
******************
PROCEDURE ImpRMOV
******************
NumItm2 = 0
NumLin = PROW() + 1
SELECT RMOV
SEEK XsNroMes+CTAS->CodCta
XiCodMon = 1
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar .AND. NroMes = XsNroMes
   DO ResetPag
   IF NumItm2 = 0
      NumLin = PROW() + 1
      @ NumLin,000 SAY CTAS->CodCta
      @ NumLin,028 SAY CTAS->NomCta PICT "@S40"
      IF CTAS->CodMon = 2
         IF Y(1) >= 0
            @ NumLin,68    SAY  Y(1) PICT "99999,999.99"
         ELSE
            @ NumLin,68    SAY -Y(1) PICT "99999,999.99-"
         ENDIF
      ENDIF
      IF X(1) >= 0
         @ NumLin,82    SAY  X(1) PICT "99999,999.99"
      ELSE
         @ NumLin,82    SAY -X(1) PICT "99999,999.99-"
      ENDIF
      NumLin = PROW() + 1
      @ NumLin,000 SAY REPLICATE(".",Ancho)
   ENDIF
   =SEEK(NROMES+CODOPE+NROAST,"VMOV")
   =SEEK(CLFAUX+CODAUX,"AUXI")
   NumItm2 = NumItm2 + 1
   NumLin = PROW() + 1
   @ NumLin,000   SAY TRANSF(DAY(VMOV->FCHAST),"@L ##")+"-"+TRANSF(MONTH(VMOV->FCHAST),"@L ##")
   @ NumLin,006   SAY NroAst
   @ NumLin,013   SAY CodOpe
   @ NumLin,017   SAY NRODOC
   DO CASE
      CASE ! EMPTY(RMOV->Glodoc)
         LsGloDoc = GloDoc
      CASE ! EMPTY(AUXI->NomAux)
         LsGloDoc = AUXI->NomAux
      OTHER
         LsGloDoc = VMOV->NotAst
   ENDCASE
   @ NumLin,028   SAY LsGloDoc PICT "@S40"
   IF CTAS->CodMon = 2
      IF TpoMov = "D"
         @ NumLin,68    SAY ImpUsa PICT "99999,999.99"
         Y(1) = Y(1) + ImpUsa
      ELSE
         @ NumLin,68    SAY ImpUsa PICT "99999,999.99-"
         Y(1) = Y(1) - ImpUsa
      ENDIF
   ENDIF
   IF TPOMOV = "D"
      @ NumLin,96    SAY Import PICT "99999,999.99"
      X(2) = X(2) + Import
   ELSE
      @ NumLin,110   SAY Import PICT "99999,999.99"
      X(3) = X(3) + Import
   ENDIF
   @ NumLin+1,0   SAY ""
   SKIP
   Cancelar = Cancelar .OR. (INKEY() = Escape)
ENDDO
IF NumItm2 = 0  .AND. X(1) = 0
   RETURN
ENDIF
X(4) = X(1)+X(2)-X(3)
NumLin = PROW() + 1
@ Numlin,000 SAY REPLICATE("-",Ancho)
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   *IF NumPag > 0
   *   NumLin =  LinFin+2
   *   IF NumLin < PROW()+ 1
   *      NumLin =  PROW()+1
   *   ENDIF
   *   @ NumLin,10 SAY "VAN ......"
   *ENDIF
   SaltaPag = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
   *IF NumPag > 1
   *   @ PROW()+1,10 SAY "VIENEN ......"
   *   NumLin = PROW() + 1
   *   @ NumLin,000 SAY CTAS->CodCta
   *   @ NumLin,028 SAY CTAS->NomCta
   *ENDIF
ENDIF
RETURN
***********************************FIN
