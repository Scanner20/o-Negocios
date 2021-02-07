PARAMETERS cCodcli,cCodDoc,cNroDoc
IF PARAMETERS()=0
	STORE '' TO cCodcli,cCodDoc,cNroDoc
ENDIF
IF PARAMETERS()=1
	STORE '' TO cCodDoc,cNroDoc
ENDIF
IF PARAMETERS()=2
	STORE '' TO cNroDoc
ENDIF
IF !USED('ccbntasg')
	SELECT 0
	USE ccbntasg
ELSE
	SELECT ccbntasg 
ENDIF
SET ORDER TO TASG02   && CODCLI+CODDOC+NRODOC

IF !USED('cbdrmovm')
	SELECT 0
	USE p0012006!cbdrmovm
ELSE
	SELECT cbdrmovm	
ENDIF
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)

SELECT ccbntasg
SEEK cCodcli+cCodDoc+cNroDoc
BROWSE FIELDS coddoc,nrodoc,fchdoc,flgest,impdoc,nromes,codope,nroast,flgctb FONT 'Tahoma' ,10

SELECT CBDRMOVM
*SEEK ccbntasg.nromes+ccbntasg.codope + ccbntasg.nroast 
BROWSE FIELDS nromes,codope,nroast,fchdoc,codcta,nrodoc,import,impusa,codmon,tpocmb,glodoc FONT 'Tahoma' ,10

IF !USED('ccbrgdoc')
	SELECT 0
	USE ccbrgdoc
ELSE
	SELECT ccbrgdoc
ENDIF
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC

BROWSE FIELDS tpodoc,coddoc,nrodoc,tporef,codref,nroref,fchdoc,imptot,sdodoc,flgest,flgubc,flgsit,reten,agente,porret=ROUND(sdodoc/imptot*100,2) FONT 'tahoma',10

IF !USED('ccbmvtos')
	SELECT 0
	USE ccbmvtos
ELSE
	SELECT ccbmvtos
ENDIF
SET ORDER TO VTOS01   && CODDOC+NRODOC
BROWSE FIELDS coddoc,nrodoc,fchdoc,codcli,codmon,tpocmb,import,tporef,codref,nroref,rete FONT 'TAHOMA',9

SELECT ccbntasg
SET RELATION TO Ccbntasg.coddoc + Ccbntasg.nrodoc INTO Ccbmvtos ADDITIVE
SET RELATION TO Ccbntasg.nromes + Ccbntasg.codope + Ccbntasg.nroast INTO Cbdrmovm ADDITIVE
SELECT ccbmvtos
SET RELATION TO Ccbmvtos.tporef + Ccbmvtos.codref + Ccbmvtos.nroref INTO Ccbrgdoc ADDITIVE
SELECT ccbntasg