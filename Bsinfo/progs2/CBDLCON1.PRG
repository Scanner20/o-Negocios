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
USE CBDBANCO ORDER BANC01 ALIAS BANC
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "EXTRACTO DE CUENTA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69

DO LIB_MTEC WITH 16
XiMES =_MES
XsCta1=SPACE(LEN(CTAS->CODCTA))
TOTSAL=0
TOTDEB=0
TOTHAB=0

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
XsMES =TRANSF(XiMES,"@L ##")
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

Ancho = 102
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "EXTRACTO DE CUENTA"
SubTitulo = ""
En1 = " "
En2 = "HORA : "+TIME()+SPACE(244)
En3 ="========== ==============================  ==========  ==========  ===============  =============== =="
En4 ="  CUENTA              CUENTA               FECHA DOC.  DOCUMENTO        CARGOS          ABONOS      C."
En5 ="========== ==============================  ==========  ==========  ===============  =============== =="

*========== ==============================  ==========  ==========  ===============  =============== =="
*  CUENTA              CUENTA               FECHA DOC.  DOCUMENTO        CARGOS          ABONOS      C."
*========== ==============================  ==========  ==========  ===============  =============== =="
*1234567890 123456789012345678901234567890   12345678   1234567890  9999,999,999.99  9999,999,999.99
*0          11                               44         55          67               84

En6 = ""
En7 = ""
En8 = ""
En9 = ""

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cancelar = .F.
SELECT BANC
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0

SEEK XsMes+XsCTA1
IF !FOUND()
   RETURN
ENDIF
*
STORE RECNO() TO REGINI
PRINTJOB
   GO REGINI
   Inicio = .T.
   NumPag  = 0
   cancela=.f.
   JAC=.T.
   DO WHILE ! EOF() .AND. XsCTA1=CODCTA .AND. XsMES=NROMES.AND.!CANCELA
        IF FLGEST<>'B'
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
   @ NumLin,0 SAY "==================================================================================================="
   NumLin = PROW() + 1
   @ NumLin,0 SAY "TOTAL CUENTA          --->>"
   @ NumLin,67  SAY TOTDEB PICT "9999,999,999.99"
   @ NumLin,84  SAY TOTHAB PICT "9999,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "SALDO FINAL DE CUENTA --->>"
   @ NumLin,67  SAY (TOTHAB-TOTDEB)+TOTSAL        PICT "9999,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "==================================================================================================="
   NumLin = PROW() + 1
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

@ NumLin,44  SAY FCHREF
@ NumLin,55  SAY NROREF
IF TPOMOV='H'
  @ NumLin,84  SAY IMPORT PICT "9999,999,999.99"
  TOTDEB=TOTDEB+IMPORT
ELSE
  @ NumLin,67  SAY IMPORT PICT "9999,999,999.99"
  TOTHAB=TOTHAB+IMPORT
ENDIF
@ NumLin,100 SAY MESCIE
RETURN

*****************
PROCEDURE LinImp2
*****************
@ NumLin,0   SAY CODCTA
SELE CTAS
SEEK TRIM(BANC->CODCTA)
@ NumLin,11  SAY LEFT(NOMCTA,30)
SELE BANC
@ NumLin,44  SAY "SALDO  INICIAL :"
@ NumLin,67  SAY SDOINI PICT "9999,999,999.99"
TOTSAL=TOTSAL+SDOINI

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