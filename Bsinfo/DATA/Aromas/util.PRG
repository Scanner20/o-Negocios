SET STEP ON
SELECT 0
USE subfamilia ORDER subf01 ALIAS subf
SELECT 0
USE util ORDER util01
SELECT subf
SCAN WHILE !EOF()
	SELECT util
	SEEK subf.codfam
	IF FOUND()
		replace desfam WITH subf.sdesc
	ENDIF
	SELECT subf
ENDSCAN