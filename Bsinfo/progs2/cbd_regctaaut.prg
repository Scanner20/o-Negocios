PARAMETERS _NroMes
SELECT 0
USE p0012003!CBDMCTAS ORDER ctas01 ALIAS ctas



SELECT 0
USE p0012003!cbdrmovm ORDER rmov01 ALIAS rmov


SELECT rmov

SEEK _NroMes
DO WHILE NroMes = _NroMes
		
	LsNroast=NroMes+CodOpe+NroAst
	LsChkCta=''
	WAIT WINDOW LsNroast nowait

	SCAN WHILE NroMes+CodOpe+NroAst=LsNroast
		IF EliItm=':'
			=SEEK(CodCta,'CTAS')
			LsChkCta = ChkCta
			DElete
		ENDIF	
		IF ChkCta==LsChkCta AND Eliitm='*'
			DELETE 
		ENDIF
	ENDSCAN
	
ENDDO