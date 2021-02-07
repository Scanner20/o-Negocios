*** Actualiza el acumulado contable ***
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
            REPLACE Db2Nac WITH Db2Nac+TnImpNac
            REPLACE Db2Ext WITH Db2Ext+TnImpExt
         ELSE
            REPLACE Hb2Nac WITH Hb2Nac+TnImpNac
            REPLACE Hb2Ext WITH Hb2Ext+TnImpExt
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