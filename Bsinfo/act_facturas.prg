SET PATH TO o:\O-NEGOCIOS\TOPSPORT ,  o:\O-NEGOCIOS\TOPSPORT\DATA  
CLOSE TABLES all
SELECT 0
USE cia001!ccbrgdoc ALIAS GDOC ORDER gdoc01
SELECT 0
USE cia001!vtaritem ALIAS ITEM ORDER item01
SELECT 0
USE p0012007!cbdrmovm ORDER rmov01 ALIAS rmov
SELECT 0
USE p0012007!cbdrmovm ORDER rmov10 ALIAS DOCS AGAIN
SELECT 0
USE p0012007!cbdvmovm ORDER vmov01 ALIAS vmov
SELECT  gdoc
SET RELATION TO nromes+codope+nroast INTO rmov ADDITIVE 
SET RELATION TO codope+nrodoc INTO DOCS ADDITIVE
SET RELATION TO coddoc+nrodoc INTO ITEM ADDITIVE
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,a=SumItems(),impigv,imptot,sdodoc,flgest,nromes,codope,nroast,fchact,tporef,codref,nroref FONT 'Tahoma',8 NOWAIT
SELECT RMOV
SET RELATION TO Rmov.nromes+ Rmov.codope+ Rmov.nroast INTO Vmov ADDITIVE
BROWSE FIELDS nromes,codope,nroast,fchast,codcta,impusa,codmon,import,hordig,fchdig,vmov.digita,vmov.hordig,vmov.fchdig,coddoc,nrodoc  FONT 'Tahoma',8 nowait
SELECT docs
BROWSE LAST FONT 'Tahoma',8 nowait
SELECT item 
BROWSE LAST FONT 'Tahoma',8 nowait

FUNCTION SumItems
LnSelect=SELECT() 

SELECT CodDoc,NroDoc, SUM(implin) as TotItem FROM item WHERE CodDoc+NroDoc=GDOC.CodDoc+Gdoc.NroDoc GROUP BY CodDoc,NroDoc INTO CURSOR xItems
xx=xItems.totItem
SELECT (LnSelect)
RETURN xx
