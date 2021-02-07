********************************************************************************
* Programa      : CBDRCON3.PRG                                                 *
* Objeto        : CONCILIACION BANCARIA MASTERCARD                             *
* Autor         : J.C.                                                         *
* Creaci¢n      : 06/06/94                                                     *
* Actualizaci¢n :                                                              *
********************************************************************************
*** Abrimos Bases ****

SELECT 1
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDACMCT ORDER ACCT01 ALIAS ACMT
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDBANCO ORDER BANC04 ALIAS BANC
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONCILIACION BANCARIA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69

DO LIB_MTEC WITH 16
XSDOINI=0
XsImport=0
FMES=1
Xcod=[]
STORE 0 TO XsSdoIni,XfSaLib,TotSdo,Ximport,XfSdo
XsMES =SPACE(2)
XsCta1=SPACE(len(CTAS->CodCta))
TOTSAL=0
TOTDEB=0
TOTHAB=0
LDIMP=0
LHIMP=0
BDIMP=0
BHIMP=0
LLDIMP=0
LLHIMP=0
SSDOINI=0

@ 10,18 SAY "MES : "
@ 11,18 SAY "CUENTA : "
XiMes = _Mes

i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,26 GET XimES    PICTURE "@L 99"
         READ
         UltTecla = LASTKEY()
      CASE i = 2
          cCodCta = "104"
          SELECT CTAS
          @ 11,26 GET XsCTA1   PICTURE "104"+REPLICATE("9",LEN(XsCta1)-3)
          READ
          UltTecla = LASTKEY()
          IF UltTecla = Escape
             CLOSE DATA
             RETURN
          ENDIF
          IF UltTecla = F8
             IF CBDBUSCA("CTAX")
                XsCTA1 = CTAS->CodCta
             ELSE
                LOOP
             ENDIF
             UltTecla = Enter
          ENDIF
          @ 11,26 SAY XsCTA1
          SEEK XsCTA1
          IF ! FOUND()
             GsMsgErr = "Cuenta no Registrada"
             DO LIB_MERR WITH 99
             LOOP
          ENDIF
          XsNomCta=NomCta
          @ 12,26 SAY XsNomCta
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
XsMes = TRANSF(XiMes,"@L ##")
*** Pantalla de datos  ***
SELE BANC
SEEK XsCTA1
IF !FOUND()
   RETURN
ENDIF
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

Ancho = 100
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN2
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = "HORA : "+TIME()
Titulo  = "CONCILIACION BANCARIA"
SubTitulo = " AL MES "+MES(XiMES,1)+" "+TRANS(_ANO,"9999")
En1 = "BANCO "+TRIM(XsNomCta)
En2 = ""
En3 = "                                                                                 "
En4 = "========== ========== ========== ===== ==== ======================================== ==============="
En5 = "FECHA DOC.   CHEQUE     VOUCHER  OPER. ITEM        BENEFICIARIO                          IMPORTE    "
En6 = "========== ========== ========== ===== ==== ======================================== ==============="
En7 = ""
En8 = ""
En9 = ""

*========== ========== ========== ===== ==== ======================================== ==============="
*FECHA DOC.   CHEQUE     VOUCHER  OPER. ITEM        BENEFICIARIO                          IMPORTE    "
*========== ========== ========== ===== ==== ======================================== ==============="
* 12345678  1234567890 1234567890 1234  123  1234567890123456789012345678901234567890 9999,999,999.99
* 1         11         22         33    39   44                                       85
*
*----------------------------------------------------------------------------------------------------

Cancelar = .F.
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0

*
STORE RECNO() TO REGINI
PRINTJOB
   SET ORDER TO BANC04
   SEEK XsCta1
   Inicio = .T.
   NumPag  = 0
   Cancela=.f.
   DO WHILE ! EOF() .AND. XsCTA1=CODCTA .AND.  !CANCELA
      DO CASE
          CASE VAL(NROMES)>XiMes
          CASE FLGEST="B" .AND. (EMPTY(MESCIE) .OR. VAL(MESCIE)>XiMes)
              DO LinImp1
          CASE VAL(NROMES)=XiMes .AND. FLGEST="L"
              DO LinImp1
      ENDCASE
      Cancela=(INKEY()=ESCAPE.OR.CANCELA)
      SKIP
   ENDDO
   NumLin = PROW() + 1
   @ NumLin,0 SAY "===================================================================================================="
   NumLin = PROW() + 1
   @ NumLin,0 SAY "TOTAL CH/NO COBRADOS              --->>"
   @ NumLin,85  SAY XfSaLib  PICT "@(Z 99,999,999.99"
   SELE BANC
   SET ORDER TO BANC01
   SEEK XsMes+XsCTA1+'B'
   XsSdoIni=SdoIni
   DO WHILE ! EOF() .AND. XsMes+XsCTA1+'B'=NroMes+Codcta+FlgEst .AND.  !CANCELA
       IF TpoMov='D'
          Ximport=import
       ELSE
          Ximport=import*-1
       ENDIF
       XfSdo=XfSdo+Ximport
       SKIP
   ENDDO
   TotSdo=XsSdoIni+XfSdo
   NumLin = PROW() + 1
   @ NumLin,0 SAY "SALDO SEGUN EXTRACTO CTA.CTE     --->>"
   @ NumLin,85 SAY TotSdo PICT "@(Z 99,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "SALDO SEGUN LIBROS                --->>"
   @ NumLin,85  SAY (TotSdo+XfSaLib)  PICT "@(Z 99,999,999.99"
   NumLin = PROW() + 1
   @ NumLin,0 SAY "===================================================================================================="
   STORE 0 TO XsSdoIni,XfSaLib,TotSdo,Ximport,XfSdo
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
DO RESETPAG
NumLin = PROW()+1

@ NumLin,1   SAY FCHREF
@ NumLin,11  SAY NROREF
@ NumLin,22  SAY NROAST
@ NumLin,33  SAY CODOPE
@ NumLin,39  SAY NROITM   PICT "@Z 9999"
@ NumLin,44  SAY GLODOC
IF TPOMOV='H'
   IF FLGEST='B'
      @ NumLin,85  SAY (IMPORT) PICT "@(Z 99,999,999.99"
      XfImport=(IMPORT)
   ELSE
      @ NumLin,85  SAY (IMPORT*-1) PICT "@(Z 99,999,999.99"
      XfImport=(IMPORT*-1)
   ENDIF
ELSE
   IF FLGEST='B'
      @ NumLin,85  SAY (IMPORT*-1) PICT "@(Z 99,999,999.99"
      XfImport=(IMPORT*-1)
   ELSE
      @ NumLin,85  SAY (IMPORT) PICT "@(Z 99,999,999.99"
      XfImport=(IMPORT)
   ENDIF
ENDIF

XfSaLib=XfSaLib+XfImport
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