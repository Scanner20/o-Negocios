function actualiza_precios
SELECT 0
USE o:\o-Negocios\idc\data\cia001\c2010\almcatge ORDER catg01
SELECT 0
USE "o:\o-Negocios\update\PreciosAgo2010.dbf" ALIAS PRECIOS EXCLU
INDEX on codmat TAG codmat
SET ORDER TO CODMAT   && CODMAT

SELECT almcatge
SET RELATION TO codmat INTO precios
REPLACE ALL preve1 WITH precios.preve1 , preve2 WITH precios.preve2 , prevn1 WITH precios.prevn1 , prevn2 WITH precios.prevn2 , codant WITH precios.codant, fchalz WITH DATE() FOR codmat==precios.codmat AND !EMPTY(precios.preve1) AND !EMPTY(precios.preve2)


FUNCTION CambiaComaxPunto
FOR K = 1 TO 80
	LsCmpMod='CdMod'+TRANSFORM(K,'@L 99')
    WAIT WINDOW LsCmpMod NOWAIT
    REPLACE ALL &LsCmpMod. WITH STRTRAN(&LsCmpMod.,',','.') FOR !EMPTY(&LsCmpMod.) AND !(AT(',',&LsCmpMod.)=0)
ENDFOR

FOR K = 1 TO 80
	LsCmpMod='CdMod'+TRANSFORM(K,'@L 99')
	ALTER table Formulas_AGO_2010 ALTER COLUMN &LsCmpMod. Numeric (10,4)
ENDFOR
** Calculamos la suma total para verificar
Tot = 0
FOR K = 1 TO 80
	LsCmpMod='CdMod'+TRANSFORM(K,'@L 99')
	SUM &LsCmpMod. TO Xx
	Tot = Tot + Xx
ENDFOR
WAIT WINDOW TOT