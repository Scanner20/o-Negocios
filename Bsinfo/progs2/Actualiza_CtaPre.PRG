SELECT 0
USE cbdvmovm ORDER vmov01 ALIAS VMOV
SELECT 0
USE cbdrmovm ALIAS rmov ORDER rmov01
SELECT 0
USE p0012009!cbdppres ALIAS PPRE ORDER ppre01
SELECT RMOV
SET RELATION TO ctapre INTO Ppre ADDITIVE
SET FILTER TO !ctapre==ppre.ctapre
REPLACE ALL ctapre WITH left(ctapre,7)

** 
SET FILTER TO INLIST(codope,'002','001') AND !EMPTY(CTAPRE)
SELECT vmov
SET FILTER TO INLIST(codope,'002','001') AND EMPTY(parfin)
SET RELATION TO nromes+codope+nroast INTO rmov
SET FILTER TO INLIST(codope,'002','001') AND EMPTY(parfin) AND nromes+codope+nroast==RMOV.nromes+RMOV.codope+RMOV.nroast
REPLACE ALL parfin WITH rmov.ctapre
**
SET RELATION OFF INTO Rmov
SELECT rmov 
SET RELATION TO nromes+codope+nroast INTO Vmov ADDITIVE
SET FILTER TO INLIST(codope,'002','001') AND EMPTY(CtaPre) AND nromes+codope+nroast==VMOV.nromes+VMOV.codope+VMOV.nroast AND !EMPTY(VMOV.parfin)
REPLACE ALL CtaPre WITH VMOV.ParFin
