********************************************************************************
* Programa      : CBDRL004.PRG                                                 *
* Objeto        : RESUMEN LIBRO MAYOR AUXILIAR                                 *
* Actualizaci¢n : 05/NOV/1999                                                  *
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

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"

SELECT ACCT
SET FILTER TO NROMES <= STR(_MES,2,0)

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RESUMEN DEL MAYOR AUXILIAR"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodRef = SPACE(LEN(CTAS->CodRef))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0

@ 09,18 SAY "                     Moneda : "
@ 10,18 SAY "               Cuenta Desde : "
@ 11,18 SAY "               Cuenta Hasta : "
@ 12,18 SAY "                  Operaci¢n : "
@ 13,18 SAY "            C¢d. Referencia : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(XiCodMon,09,48,2)
         En1 = TRIM(VECOPC(XiCodMon))
      CASE i = 2
         @ 10,48 GET XsCtaDes PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         @ 11,48 GET XsCtaHas PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,48 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         @ 13,48 GET XsCodRef PICTURE "@!"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 4 , i + 1, 4 )

      CASE UltTecla = Enter
         IF  i < 4
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
*** FILTROS **
DO CASE
   CASE !EMPTY(XsCodOpe) .and.  EMPTY(XsCodREF)
      SET FILTER TO CodOpe = XsCodOpe
   CASE  EMPTY(XsCodOpe) .and. !EMPTY(XsCodREF)
      SET FILTER TO CodREf = XsCodRef
   CASE !EMPTY(XsCodOpe) .and. !EMPTY(XsCodREF)
      SET FILTER TO CodREf = XsCodRef .and. CodOpe = XsCodOpe
ENDCASE

SELECT CTAS
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 132
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniImp  = _PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = "R E S U M E N    D E L    M A Y O R    A U X I L I A R"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = ""
En2 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En3 = " "
En4 = ""
En5 = ""
En6 = "****** ***** *************************************** *************** ******************************* *******************************"
En7 = "COD.   COD.                                                   SALDO        M O V I M I E N T O            S A L D O  A C T U A L    "
En8 = "CUENTA AUXI.      GLOSA                                    ANTERIOR       CARGOS           ABONOS          DEUDOR        ACREEDOR   "
En9 = "****** ***** *************************************** *************** *************** *************** *************** ***************"
*      0***** 6***** 13************************************* 53************* 69************* 140************ 156************ 172************"
*      12345  123456 123456789-123456789-123456789-123456789 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345

NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol),R(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   NumPag  = 0
   SEEK TRIM(XsCtaDes)
   STORE 0 TO R
   RAYA = .T.
   DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar
      CodCta1 = LEFT(CodCta,2)
      NomCta1 = ""
      STORE 0 TO W
      SaltaPag = .T.
      DO WHILE CodCta=CodCta1 .AND. ! EOF() .AND. ! Cancelar
         CodCta2 = LEFT(CodCta,3)
         IF CODCTA = PADR(CodCta1,LEN(CODCTA))
            NomCta1 = NomCta
         ENDIF
         NomCta2 = ""
         NumItm1 = 0
         STORE 0 TO Z
         DO WHILE CodCta=CodCta2 .AND. ! EOF() .AND. ! Cancelar
             IF CODCTA = PADR(CodCta2,LEN(CODCTA))
                NomCta2 = NomCta
             ENDIF
             IF AftMov = "S"
                DO LinImp
             ENDIF
             SELECT CTAS
             SKIP
             Cancelar = Cancelar .OR. (INKEY() = Escape)
         ENDDO
         IF NumItm1 > 0 .AND. ! Cancelar
            DO ResetPag
            NumLin = PROW() + 1
            @ NumLin,000 SAY "* TOTAL CUENTA * "
            NumLin = PROW() + 1
            @ NumLin,000 SAY CodCta2
            @ NumLin,018 SAY NomCta2 PICT "@S37"
            FOR I=1 TO 5
                Col = (i-1)*16 + 53
                IF Z(I) >= 0
                   @ NumLin,Col SAY Z(i) PICT "@Z 999,999,999.99"
                ELSE
                   @ NumLin,Col SAY -Z(i) PICT "@Z 999,999,999.99-"
                ENDIF
                W(I) = W(I) + Z(I)
            ENDFOR
         ENDIF
      ENDDO
      IF !Cancelar
         DO ResetPag
         NumLin = PROW() + 1
         @ NumLin,000 SAY "* TOTAL CUENTA * "
         NumLin = PROW() + 1
         @ NumLin,000 SAY CodCta1
         @ NumLin,018 SAY NomCta1 PICT "@S37"
         FOR I=1 TO 5
             Col = (i-1)*16 + 53
             IF w(I) >= 0
                @ NumLin,Col SAY w(i) PICT "@Z 999,999,999.99"
             ELSE
                @ NumLin,Col SAY -w(i) PICT "@Z 999,999,999.99-"
             ENDIF
             R(I) = R(I) + W(I)
         ENDFOR
      ENDIF
   ENDDO
   IF ! CANCELAR .AND. R<>W
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL   GENERAL **"
      FOR I=1 TO 5
          Col = (i-1)*16 + 53
          IF R(I) >= 0
             @ NumLin,Col SAY R(i) PICT "@Z 999,999,999.99"
          ELSE
             @ NumLin,Col SAY -R(i) PICT "@Z 999,999,999.99-"
          ENDIF
      ENDFOR
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
SELECT RMOV
SEEK XsNroMes+CTAS->CodCta
SELECT ACCT
SET ORDER TO ACCT02
SEEK CTAS->CodCta
IF ! FOUND()
   RETURN
ENDIF
STORE 0 TO Y
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar
   STORE 0 TO X
   LsCodRef = CodRef
   SELECT AUXI
   IF ! EMPTY(CTAS->CLFAUX) .AND. CTAS->CodRef = REPLICATE("0",LEN(CTAS->CodRef))
      SEEK CTAS->ClfAux+LEFT(LsCodRef,LEN(AUXI->CODAUX))
   ELSE
      SEEK "001"+LEFT(LsCodRef,LEN(AUXI->CODAUX))
   ENDIF
   SELECT ACCT
   *** Saldo al mes Anterior ***
   DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef
      IF NroMes <  STR(_MES,2,0)
         IF XiCodMon = 1
            X(1) = X(1) + DbeNac - HbeNac
         ELSE
            X(1) = X(1) + DbeUsa - HbeUsa
         ENDIF
      ELSE
         IF XiCodMon = 1
            X(2) = X(2) + DbeNac
            X(3) = X(3) + HbeNac
         ELSE
            X(2) = X(2) + DbeUsa
            X(3) = X(3) + HbeUsa
         ENDIF
      ENDIF
      SKIP
   ENDDO
   LfSaldo = X(1)+X(2)-X(3)
   IF LfSaldo > 0
      X(4) =  LfSaldo
   ELSE
      X(5) = -LfSaldo
   ENDIF
   ok = .F.
   FOR I=1 TO 5
       Y(I) = Y(I) + X(I)
       IF X(i) <> 0
          oK = .T.
       ENDIF
   ENDFOR
   IF oK
      DO ResetPag
      RAYA = .F.
      NumLin = PROW() + 1
      @ NumLin,000 SAY CTAS->CodCta
      @ NumLin,006 SAY LsCodRef
      IF ! (EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)))
         @ NumLin,013 SAY AUXI->NomAux PICT "@S39"
      ELSE
         @ NumLin,013 SAY CTAS->NomCta PICT "@S39"
      ENDIF
      FOR I=1 TO 5
          Col = (i-1)*16 + 53
          IF X(I) >= 0
             @ NumLin,Col SAY X(i) PICT "@Z 999,999,999.99"
          ELSE
             @ NumLin,Col SAY -X(i) PICT "@Z 999,999,999.99-"
          ENDIF
      ENDFOR
      NumItm1 = NumItm1 + 1
   ENDIF
   SELECT ACCT
   Cancelar = Cancelar .OR. (INKEY() = Escape)
ENDDO
DO ResetPag
IF ! RAYA
   NumLin = PROW() + 1
   @ Numlin,000 SAY REPLICATE("-",Ancho)
ENDIF
NumLin = PROW() + 1
@ NumLin,000 SAY CTAS->CodCta
@ NumLin,013 SAY CTAS->NomCta
FOR I=1 TO 5
    Col = (i-1)*16 + 53
    IF Y(I) >= 0
       @ NumLin,Col SAY Y(i) PICT "@Z 999,999,999.99"
    ELSE
       @ NumLin,Col SAY -Y(i) PICT "@Z 999,999,999.99-"
    ENDIF
    Z(I) = Z(I) + Y(I)
ENDFOR
NumLin = PROW() + 1
@ Numlin,000 SAY REPLICATE("=",Ancho)
RAYA = .T.
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltaPag
   SaltaPag = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
