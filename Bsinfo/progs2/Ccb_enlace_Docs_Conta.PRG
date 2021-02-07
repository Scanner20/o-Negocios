SET RESOURCE TO c:\temp\foxuser2.dbf
CLOSE TABLES all
SELECT 0
USE cbdvmovm ORDER vmov01 ALIAS vmov
SELECT 0
USE cbdrmovm ORDER rmov01 ALIAS rmov
SET RELATION TO nromes+codope+nroast INTO vmov
SELECT 0
USE ccbmvtos ORDER vtos03 ALIAS vtos
SELECT 0
USE cbdrmovm ORDER rmov01 ALIAS VTRM AGAIN
SELECT vtos
SET RELATION TO NroMes+CodOpe+Nroast INTO VTRM  ADDITIVE
SELECT RMOV
SET RELATION TO coddoc+TRIM(nrodoc) INTO vtos additive
*BROWSE FIELDS coddoc,nrodoc,fchdoc,import,impusa,codmon,fchast,nromes,codope,nroast,tpomov,codcta NOWAIT FONT 'Arial',8
BROWSE LAST NOWAIT 
SELECT VMOV
*BROWSE LAST NOWAIT FONT 'Arial',8
BROWSE LAST NOWAIT
SELECT VTOS
*BROWSE FIELDS CodRef,NroRef,FchDoc,FchIng,CodDoc,NroDoc,CodCli,Import,CodMon,tpocmb,TpoRef,NroRef,Nromes,CodOpe,NroAst,FlgCtb NOWAIT FONT 'Arial',8
BROWSE LAST NOWAIT
SELECT VTRM
*BROWSE FIELDS coddoc,nrodoc,fchdoc,import,impusa,codmon,fchast,nromes,codope,nroast,tpomov,codcta NOWAIT FONT 'Arial',8
BROWSE LAST NOWAIT
