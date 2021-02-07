SELECT 0
USE d:\o-negocios\trinidad\Data\cia001\c2011\cbdmctas.dbf ALIAS CTAS
SET ORDER TO CTAE   && CTAE2010
SELECT 0
USE d:\o-negocios\trinidad\Data\cia001\c2011\cbdrmovm.dbf  ALIAS rm2011
SET RELATION TO codcta INTO ctas
SET FILTER TO codcta==ctas.ctae2010

BROWSE FIELDS nromes,codope,nroast,codcta,ctas.ctae2010,ctas.codcta,ctas.nivcta,ctas.aftmov
REPLACE ALL codcta WITH ctas.codcta  FOR codcta==ctas.ctae2010 AND ctas.nivcta=5