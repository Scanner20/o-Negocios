*xsCodCta=cbdrmovm.codcta
xsCodCta=rmovCTA.codcta

SELECT CBDRMOVM
XnNroReg =RECNO('CBDRMOVM')
replace ALL cbdrmovm.codcta WITH cbdmctas.codcta FOR cbdrmovm.codcta=xscodcta
IF XnNroReg>0
	GO XnNroReg
ENDIF
SELECT RMOVCTA
BROWSE LAST
RETURN 