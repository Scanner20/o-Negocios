********************************************************************************
* Programa      : CBDRCON1.PRG                                                 *
* Objeto        : Extracto de Cuenta                                          *
* Autor         : J.C.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 10/05/94                                                     *
********************************************************************************
*** Abrimos Bases ****

SELECT 1
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDACMCT ORDER ACCT01 ALIAS ACCT
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDBANCO ORDER BANC01 ALIAS BANC
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RESUMEN DE CUENTA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69

DO LIB_MTEC WITH 16
XSDOINI=0
FMES=1
Xcod=[]
XsMES =TRANSF(_MES,"@L ##")
XsCta1=SPACE(LEN(CTAS->CODCTA))
TOTSAL=0
TOTDEB=0
TOTHAB=0
XsNomCta=[]
Ximes = _MES

@ 10,26 SAY "MES : "
@ 11,26 SAY "CUENTA : "

i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,38 GET XIMES    PICTURE "@L 99"
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ 11,38 GET XsCTA1   PICTURE "104"+REPLICATE("9",LEN(XsCta1)-3)
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )

      CASE UltTecla = Enter
         IF  i < 2
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
*** Pantalla de datos  ***

XsMes = TRANSF(XiMes,"@L ##")

do LinImpS

SEEK XsMes+XsCTA1
IF !FOUND()
   GsMsgErr = "Cuenta sin movimiento"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

Ancho = 106
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "RESUMEN DE CUENTA "
SubTitulo = ""
En1 = " "
En2 = "HORA : "+TIME()+SPACE(244)
En3 ="========== ========== ========== ===== ==== ============================== =============== ==============="
En4 ="FECHA DOC.   CHEQUE     VOUCHER  OPER. ITEM        DESCRIPCION                 CARGOS           ABONOS    "
En5 ="========== ========== ========== ===== ==== ============================== =============== ==============="
En6 = ""
En7 = ""
En8 = ""
En9 = ""

*----------------------------------------------------------------------------------------------------

Cancelar = .F.
SELECT BANC
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0

*
STORE RECNO() TO REGINI
PRINTJOB
   GO REGINI
   Inicio = .T.
   NumPag  = 0
   cancela=.f.
   JAC=.T.
   DO WHILE ! EOF() .AND. XsCTA1=CODCTA .AND. XsMES=NROMES .AND.!CANCELA
        IF NROAST = "------"
            SKIP
            LOOP
        ENDIF
        IF FLGEST='B' .AND. MesCie=Space(2)
            SKIP
            LOOP
        ENDIF
        DO ResetPag
        IF JAC=.T.
           NumLin = PROW() + 1
           DO LinImp2
        ENDIF
        NumLin = PROW() + 1
        DO LinImp1
        JAC=.F.
        cancela=(INKEY()=ESCAPE.OR.CANCELA)
       SKIP
   ENDDO
   NumLin = PROW() + 1
   @ NumLin,0 SAY "==========================================================================================================="
   NumLin = PROW() + 1
   @ NumLin,0 SAY "TOTAL CUENTA          --->>"
   @ NumLin,74  SAY TOTDEB PICT "@(Z 9999,999,999.99"
   @ NumLin,91  SAY TOTHAB PICT "@(Z 9999,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "SALDO FINAL DE CUENTA --->>"
   @ NumLin,75  SAY (TOTHAB+TOTDEB)+TOTSAL        PICT "@(Z 9999,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "==========================================================================================================="
   STORE 0 TO TOTSAL,TOTDEB,TOTHAB
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN

*****************
PROCEDURE LinImp1
*****************

*========== ========== ========== ===== ==== ============================== =============== ==============="
*FECHA DOC.   CHEQUE     VOUCHER  OPER. ITEM        DESCRIPCION                 CARGOS           ABONOS    "
*========== ========== ========== ===== ==== ============================== =============== ==============="
* 12345678  1234567890 1234567890 1234  123  123456789012345678901234567890 9999,999,999.99 9999,999,999.99
* 1         11         22         33    39   44                             75              91


@ NumLin,1   SAY FCHREF
@ NumLin,11  SAY NROREF
@ NumLin,22  SAY NROAST
@ NumLin,33  SAY CODOPE
@ NumLin,39  SAY NROITM   PICT "9999"
@ NumLin,44  SAY GLODOC
IF TPOMOV='D'
  @ NumLin,74  SAY IMPORT PICT "@(Z 9999,999,999.99"
  TOTDEB=TOTDEB+IMPORT
ELSE
  @ NumLin,91  SAY IMPORT PICT "@(Z 9999,999,999.99"
  TOTHAB=TOTHAB+(IMPORT*-1)
ENDIF
RETURN

*****************
PROCEDURE LinImpS
*****************
SELE CTAS
Xcod=TRIM(XsCta1)
SEEK Xcod
XsNomCta=NOMCTA
SELE ACCT
FMES=ROUND(VAL(XsMES)-1,0)
DO CBDACUMD WITH XCOD,0,FMes
XSDOINI=XvCalc(6)
SELE BANC

RETURN
*****************
PROCEDURE LinImp2
*****************
@ NumLin,0   SAY Xcod
@ NumLin,11  SAY LEFT(XsNomCta,30)
NumLin = PROW() + 1
@ NumLin,0   SAY "SALDO  INICIAL :"
@ NumLin,75  SAY XSDOINI PICT "@(Z 9999,999,999.99"
TOTSAL=XSDOINI
NumLin = PROW() + 1
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***************
