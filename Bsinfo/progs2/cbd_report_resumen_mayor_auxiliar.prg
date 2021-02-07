*** Abrimos Bases ****
#Include const.h
goentorno.open_dbf1('ABRIR','cbdacmct','ACCT','ACCT01','') 
goentorno.open_dbf1('ABRIR','cbdmctas','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','cbdrmovm','RMOV','RMOV03','') 
goentorno.open_dbf1('ABRIR','cbdvmovm','VMOV','VMOV01','') 
goentorno.open_dbf1('ABRIR','cbdmtabl','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','cbdtoper','OPER','OPER01','') 
goentorno.open_dbf1('ABRIR','cbdmauxi','AUXI','AUXI01','') 
*** Final de Apertura ****
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
cTit4 = "LIBRO MAYOR AUXILIAR"
********* Variables  a usar ***********
XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodRef = SPACE(LEN(CTAS->CodRef))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XlSinCCo = .F.
XnMes	=	_Mes
XnMes2	=	_Mes

DO FORM cbd_report_resumen_mayor_auxiliar
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELECT RMOV
*** FILTROS ***
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

*DO ADMPRINT
*IF LASTKEY() = ESCAPE
*	CLOSE DATA
*	RETURN
*ENDIF
*IF XiCodMon = 2
*	INC = 6
*ELSE
*	INC = 0
*ENDIF
*Ancho = 137
Cancelar = .F.
*Tit_SIZQ = TRIM(GsNomCia)
*Tit_IIZQ = TRIM(GsDirCia)
*Tit_SDER = "FECHA : "+DTOC(DATE())
*Tit_IDER = ""
*Titulo   = "M A Y O R    A U X I L I A R"
*SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
*En2 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
*En3 = " "
*En4 = ""
*En5 = ""
*En6 = "**** ******* ******** *************************************** ********** ******** *************************** ***************************"
*En7 = " LI   COMPRO   FECHA                                              Nro.    CODIGO      M O V I M I E N T O              S A L D O         "
*En8 = " BRO  BANTE     DOC.        D E S C R I P C I O N              DOCUMENTO  AUXIL.       CARGOS       ABONOS        DEUDOR       ACREEDOR  "
*En9 = "**** ******* ******** *************************************** ********** ******** ************* ************* ************* *************"
NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol),R(NumCol)
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
            Cancelar = Cancelar .OR. (INKEY() = K_Esc)
        ENDDO
		IF NumItm1 > 0 .AND. ! Cancelar
			m.Quiebre = 'E'
			m.CodCta = CodCta2
			m.NomCta = "* TOTAL CUENTA * "+TRIM(CodCta2)+ ' ' +NomCta2
			FOR I=2 TO 5
				Col = (i-1)*13 + 69
				IF Z(I) >= 0
					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
					&LsCampo = Z(I)
				ELSE
					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
					&LsCampo = -Z(I)
				ENDIF
				W(I) = W(I) + Z(I)
			ENDFOR
			=GrbTmp(m.QuieBre,m.CodCta)
		ENDIF
	ENDDO
	IF ! CANCELAR
		m.Quiebre = 'F'
		m.CodCta	= 'TOTAL'
		m.NomCta	= "** TOTAL   GENERAL **"
		FOR I=2 TO 5
			Col = (i-1)*13 + 69
			IF W(I) >= 0
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = W(I)

			ELSE
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = -W(I)

			ENDIF
		ENDFOR
		=GrbTmp(m.QuieBre,m.CodCta)
	ENDIF
ENDDO
IF ! CANCELAR .AND. R<>W
	m.Quiebre = 'F'
	m.CodCta	= 'TOTAL'
	m.NomCta	= "** TOTAL   GENERAL **"
	FOR I=1 TO 5
		IF R(I) >= 0
			@ NumLin,Col SAY R(i) PICT "@Z 999,999,999.99"
		ELSE
			@ NumLin,Col SAY -R(i) PICT "@Z 999,999,999.99-"
		ENDIF
	ENDFOR
ENDIF
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
STORE 0 TO Y
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar
	STORE 0 TO X
	LsCodRef = CodRef
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
      RAYA = .F.
  **    @ NumLin,000 SAY CTAS->CodCta
  **    @ NumLin,006 SAY LsCodRef
      IF ! (EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)))
         **@ NumLin,013 SAY AUXI->NomAux PICT "@S39"
      ELSE
         **@ NumLin,013 SAY CTAS->NomCta PICT "@S39"
      ENDIF
      FOR I=1 TO 5
		IF X(I) >= 0
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = X(I)
		ELSE
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = X(I)
		ENDIF
      ENDFOR
	   	 NumItm1 = NumItm1 + 1
      	m.Quiebre	= 'A'
      	m.CodCta 	= Ctas.CodCta
		m.CodRef	= LsCodRef
		m.NomCta	= "TOTAL AUXILIAR  "+CTAS->CodCta	
		m.NomAux	= AUXi.NOMAux
		=GrbTmp(m.QuieBre,m.CodCta)
   ENDIF
   SELECT ACCT
   Cancelar = Cancelar .OR. (INKEY() = K_Esc)
ENDDO
***DO ResetPag
IF ! RAYA
***>   NumLin = PROW() + 1
***>   @ Numlin,000 SAY REPLICATE("-",Ancho)
ENDIF
NumLin = PROW() + 1
FOR I=1 TO 5
    Col = (i-1)*16 + 53
    IF Y(I) >= 0
		LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
		&LsCampo = Y(I)

    ELSE
		LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
		&LsCampo = -Y(I)
    ENDIF
    Z(I) = Z(I) + Y(I)
ENDFOR
m.Quiebre	= 'D'
m.CodCta 	= Ctas.CodCta
m.CodRef	= ''
m.NomCta	= CTAS.NomCta
m.NomAux	= ''
=GrbTmp(m.QuieBre,m.CodCta)
RAYA = .T.
RETURN
****************
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
****************
PROCEDURE GrbTmp
****************
PARAMETERS _Quiebre,_CodCta
LOCAL LsAlias_Act
Lsalias_Act = SELECT()
SELECT temporal
*SEEK _Quiebre+_CodCta
*IF !FOUND()
	APPEND BLANK
*	replace QuieBre WITH _Quiebre
*	replace CodCta	WITH _CodCta
*ENDIF
DO CASE
	CASE _Quiebre='E'
		m.CodCta2 = LEFT(_Codcta,2)+_Quiebre
	OTHERWISE
		m.CodCta2 = LEFT(_Codcta,2)
ENDCASE
GATHER memvar
SELECT (LsAlias_Act)

