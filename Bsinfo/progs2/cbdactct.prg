*** Actualiza el acumulado contable con divisionaria VETT 15/JUN/1999 ***
PARAMETERS cCodCta , cCodRef , nNroMes , cTpoMov , nImport , nImpUsa , cDivision
PRIVATE TnLen1 , TnLen2 , TnCont , TsCodCta , TnImpNac , TnImpExt, xSelect
xSelect = SELECT()
LsCodRef = cCodREf
TnImpNac = nImport
TnImpExt = nImpUsa
TnLen1   = LEN(cCodCta)
TnLen2   = LEN(TRIM(cCodCta))
TnCont   = TnLen2
** Control de la divisionaria **
STORE .F. TO lActCmpDivH1,lActCmpDivD1,lActCmpDivH2,lActCmpDivD2
IF PARAMETERS()>6 AND !EMPTY(cDivision)
    SELE ACCT
	LsCmpDivH1 = [HbeNac]+cDivision
	LsCmpDivD1 = [DbeNac]+cDivision
	LsCmpDivH2 = [HbeExt]+cDivision
	LsCmpDivD2 = [DbeExt]+cDivision
	STORE .t. TO lActCmpDivH1,lActCmpDivD1,lActCmpDivH2,lActCmpDivD2
	IF TYPE(LsCmpDivH1)#[N]
		lActCmpDivH1=.f.
	ENDIF
	IF TYPE(LsCmpDivD1)#[N]
		lActCmpDivD1=.f.
	ENDIF
	IF TYPE(LsCmpDivH2)#[N]
		lActCmpDivH2=.f.
	ENDIF
	IF TYPE(LsCmpDivD2)#[N]
		lActCmpDivD2=.f.
	ENDIF
ELSE
	STORE [] TO LsCmpDivH1,LsCmpDivD1,LsCmpDivH2,LsCmpDivD2
ENDIF
**
DO WHILE TnCont > 0
   TsCodCta = LEFT(cCodCta,TnCont)+SPACE(TnLen1-TnCont)
   SELECT CTAS
   SET ORDER TO CTAS01
   SEEK TsCodCta
   IF FOUND()
      SELECT ACCT
      SEEK STR(nNroMes,2,0) + TsCodCta + LsCodRef
      IF ! FOUND()
         APPEND BLANK
      ENDIF

      IF RLOCK()
         REPLACE CodCta WITH TsCodCta
         REPLACE CodRef WITH LsCodRef
         REPLACE NroMes WITH STR(nNroMes,2,0)
         IF cTpoMov = 'D'
            REPLACE DbeNac WITH DbeNac+TnImpNac
            REPLACE DbeExt WITH DbeExt+TnImpExt
            ** División **
            IF lActCmpDivD1
	            REPLACE (LsCmpDivD1) WITH EVAL(LsCmpDivD1) + TnImpNac
            ENDIF
            IF lActCmpDivD2
	            REPLACE (LsCmpDivD2) WITH EVAL(LsCmpDivD2) + TnImpExt
            ENDIF
         ELSE
            REPLACE HbeNac WITH HbeNac+TnImpNac
            REPLACE HbeExt WITH HbeExt+TnImpExt
            ** División **
            IF lActCmpDivH1
	            REPLACE (LsCmpDivH1) WITH EVAL(LsCmpDivH1) + TnImpNac
            ENDIF
            IF lActCmpDivH2
	            REPLACE (LsCmpDivH2) WITH EVAL(LsCmpDivH2) + TnImpExt
            ENDIF
         ENDIF
      ENDIF
      LsCodRef = SPACE(LEN(LsCodRef))
      UNLOCK
   ENDIF
   TnCont = TnCont - 1
ENDDO
SELECT (xSelect)
RETURN

*** Actualiza el acumulado contable sin divisionaria ***
PARAMETERS cCodCta , cCodRef , nNroMes , cTpoMov , nImport , nImpUsa
PRIVATE TnLen1 , TnLen2 , TnCont , TsCodCta , TnImpNac , TnImpExt, xSelect
xSelect = SELECT()
LsCodRef = cCodREf
TnImpNac = nImport
TnImpExt = nImpUsa
TnLen1   = LEN(cCodCta)
TnLen2   = LEN(TRIM(cCodCta))
TnCont   = TnLen2
DO WHILE TnCont > 0
   TsCodCta = LEFT(cCodCta,TnCont)+SPACE(TnLen1-TnCont)
   SELECT CTAS
   SET ORDER TO CTAS01
   SEEK TsCodCta
   IF FOUND()
      SELECT ACCT
      SEEK STR(nNroMes,2,0) + TsCodCta + LsCodRef
      IF ! FOUND()
         APPEND BLANK
      ENDIF

      IF RLOCK()
         REPLACE CodCta WITH TsCodCta
         REPLACE CodRef WITH LsCodRef
         REPLACE NroMes WITH STR(nNroMes,2,0)
         IF cTpoMov = 'D'
            REPLACE DbeNac WITH DbeNac+TnImpNac
            REPLACE DbeExt WITH DbeExt+TnImpExt
         ELSE
            REPLACE HbeNac WITH HbeNac+TnImpNac
            REPLACE HbeExt WITH HbeExt+TnImpExt
         ENDIF
      ENDIF
      LsCodRef = SPACE(LEN(LsCodRef))
      UNLOCK
   ENDIF
   TnCont = TnCont - 1
ENDDO
SELECT (xSelect)
RETURN
