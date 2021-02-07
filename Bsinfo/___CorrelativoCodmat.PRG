PARAMETERS _cLLave

nLongitud = LEN(_cLlave)

FOR K = 1 TO nLongitud
	FOR j = 32 TO 127 
		RAT(CHR(j),_cLlave)
	ENDFOR
	
	
ENDFOR

clear
FOR k = 32 TO 127 
 ?CHR(K) + CHR(13) 
ENDFOR

SELECT 'A1001'+SUBSTR(a.Codigo,6) as codmat FROM almcatge 
SELECT 'A1001' AS SUBFAM ,TRANSFORM(VAL(IIF(ISNULL(MAX(SUBSTR(codmat,6))),'',MAX( SUBSTR(codmat,6) ) )) + 1, "@L 9999999999999" ) as codmat FROM almcatge WHERE codmat='A1001' 
SELECT subfam FROM almtdivf WHERE Subfam = LEFT(codmat,5) 
