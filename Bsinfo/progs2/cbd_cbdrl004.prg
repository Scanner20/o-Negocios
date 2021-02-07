#INCLUDE CONST.H
*** Abrimos Bases ***
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV03','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RESUMEN DEL MAYOR AUXILIAR"
********* Variables  a usar ***********
UltTecla = 0
XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodRef = SPACE(LEN(CTAS->CodRef))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XnMes    = _MES
TsNroMes = XsNroMes

DO FORM cbd_cbdrl004
RETURN

******************
PROCEDURE imprimir
******************
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ***
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT ACCT
SET FILTER TO NROMES <= STR(XnMES,2,0)
 
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

DO F0PRINT
IF UltTecla = k_Esc
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 132
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = 88 - 6
IniImp  = _PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = "R E S U M E N    D E L    M A Y O R    A U X I L I A R"
SubTitulo= "MES DE "+MES(XnMES,1)+" DE "+TRANS(_ANO,"9999")
En1 = ""
IF XiCodMon=1
	En2 = "(EXPRESADO EN SOLES)" &&+TRIM(VECOPC(XiCodMon))+")"
ELSE
	En2 = "(EXPRESADO EN DOLARES)" &&+TRIM(VECOPC(XiCodMon))+")"
ENDIF
En3 = " "
En4 = ""
En5 = ""
En6 = "****** ***** ****************************************** *************** ******************************* *******************************"
En7 = "COD.   COD.                                                      SALDO        M O V I M I E N T O            S A L D O  A C T U A L    "
En8 = "CUENTA AUXI.      GLOSA                                       ANTERIOR       CARGOS           ABONOS          DEUDOR        ACREEDOR   "
En9 = "****** ***** ****************************************** *************** *************** *************** *************** ***************"
*      0***** 6***** 13************************************* 53************* 69************* 140************ 156************ 172************"
*      12345  123456 123456789-123456789-123456789-123456789 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345

NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol),R(NumCol),L(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   NumPag  = 0
   SEEK TRIM(XsCtaDes)
   STORE 0 TO R,L
   RAYA = .T.
   DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar
      CodCta1 = LEFT(CodCta,2)
      NomCta1 = ""
      STORE 0 TO W
      SaltaPag = .F.
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
             Cancelar = Cancelar .OR. (INKEY() = k_esc)
         ENDDO
         IF NumItm1 > 0 .AND. ! Cancelar
            DO ResetPag
            NumLin = PROW() + 1
            @ NumLin,000 SAY "* TOTAL CUENTA  3 DIG. * "
            NumLin = PROW() + 1
            @ NumLin,000 SAY CodCta2
            @ NumLin,018 SAY NomCta2 PICT "@S37"
            FOR I=1 TO 5
                Col = (i-1)*16 + 56
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
             Col = (i-1)*16 + 56
             IF w(I) >= 0
                @ NumLin,Col SAY w(i) PICT "@Z 999,999,999.99"
                
             ELSE
                @ NumLin,Col SAY -w(i) PICT "@Z 999,999,999.99-"
             ENDIF
             R(I) = R(I) + W(I)
         ENDFOR
	         
         DO ResetPag
         NumLin = PROW() + 1
         @ Numlin,000 SAY REPLICATE(".",Ancho)
      ENDIF
   ENDDO
   IF ! CANCELAR .AND. (R(1)<>W(1) or R(2)<>W(2) or R(3)<>W(3) or R(4)<>W(4) or  R(5)<>W(5) )
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL   GENERAL **"
      FOR I=1 TO 5
          Col = (i-1)*16 + 56
          IF R(I) >= 0
             @ NumLin,Col SAY R(i) PICT "@Z 999,999,999.99"
          ELSE
             @ NumLin,Col SAY -R(i) PICT "@Z 999,999,999.99-"
          ENDIF
      ENDFOR
*!*	      NumLin = PROW() + 1
*!*	      @ NumLin,000 SAY "** TOTAL   GENERAL **"
*!*	      FOR I=1 TO 5
*!*	          Col = (i-1)*16 + 56
*!*	          IF L(I) >= 0
*!*	             @ NumLin,Col SAY L(i) PICT "@Z 999,999,999.99"
*!*	          ELSE
*!*	             @ NumLin,Col SAY -L(i) PICT "@Z 999,999,999.99-"
*!*	          ENDIF
*!*	      ENDFOR
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
RETURN

****************
PROCEDURE LinImp
****************
PRIVATE NumLin
**XsNroMes = transf(_MES,"@L ##")
SELECT RMOV
SEEK TsNroMes+CTAS->CodCta
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
      SEEK CTAS->ClfAux+LEFT(LsCodRef,LEN(AUXI->CODAUX))
   ENDIF
   SELECT ACCT
   *** Saldo al mes Anterior ***
   DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef
      IF NroMes <  STR(XnMES,2,0)
         IF XiCodMon = 1
            X(1) = X(1) + DbeNac - HbeNac
         ELSE
            X(1) = X(1) + DbeExt - HbeExt
         ENDIF
      ELSE
         IF XiCodMon = 1
            X(2) = X(2) + DbeNac
            X(3) = X(3) + HbeNac
         ELSE
            X(2) = X(2) + DbeExt
            X(3) = X(3) + HbeExt
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
*!*		IF X(1) > 0
*!*			L(2) = L(2) +  X(1) + X(2)
*!*		ELSE
*!*			L(3) = L(3) +  X(1) + X(3)
*!*		ENDIF
*		L(4) = L(4) +  X(1) + X(2)
*		L(5) = L(5) +  -X(1) + X(3)	     				    
   
   IF oK
      DO ResetPag
      RAYA = .F.
      NumLin = PROW() + 1
      @ NumLin,000 SAY CTAS->CodCta
      @ NumLin,009 SAY LsCodRef
      IF ! (EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)))
         @ NumLin,025 SAY AUXI->NomAux PICT "@S30"
      ELSE
         @ NumLin,025 SAY CTAS->NomCta PICT "@S30"
      ENDIF
      FOR I=1 TO 5
          Col = (i-1)*16 + 56
          IF X(I) >= 0
             @ NumLin,Col SAY X(i) PICT "@Z 999,999,999.99"
          ELSE
             @ NumLin,Col SAY -X(i) PICT "@Z 999,999,999.99-"
          ENDIF
		         
      ENDFOR
      NumItm1 = NumItm1 + 1
   ENDIF
   SELECT ACCT
   Cancelar = Cancelar .OR. (INKEY() = k_esc)
ENDDO
DO ResetPag
IF ! RAYA
   NumLin = PROW() + 1
   @ Numlin,000 SAY REPLICATE("-",Ancho)
ENDIF
NumLin = PROW() + 1
@ NumLin,000 SAY CTAS->CodCta
@ NumLin,016 SAY CTAS->NomCta
FOR I=1 TO 5
    Col = (i-1)*16 + 56
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
   DO F0MBPRN &&IN ADMPRINT
   IF UltTecla = k_esc
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
