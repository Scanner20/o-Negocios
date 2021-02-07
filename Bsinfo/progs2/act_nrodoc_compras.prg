PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')

Cancelar = .f.
LsMesIni='06'
SET STEP ON 
SELECT RMOV
SET FILTER TO inlist(codcta,'42','60','20')
SEEK LsMesIni

DO WHILE  NroMes>=LsMesIni AND !Cancelar 
	IF INLIST(CodOpe,'003')
		LsLlave=NroMes+COdOpe+NroAst
		LsNroDoc=''
		LsCodDoc = ''
		LnNroReg60 = 0
		LnNroReg20 = 0
		WAIT WINDOW Lsllave+ ' DO WHILE' nowait
		SCAN WHILE NroMes+CodOpe+NroAst = LsLlave AND !cancelar
			WAIT WINDOW NroMes+CodOpe+NroAst + ' SCAN WHILE' nowait
			IF CodCta='42'
				LSNroDoc=NroDoc
				LSCodDoc=CodDoc
			ENDIF
			IF INLIST(CodCta,'60','20') 
				IF EMPTY(NroDoc) AND Codcta='60'
					LnNroReg60 = RECNO()
				ENDIF
				IF EMPTY(NroDoc) AND CodCta='20'
					LnNroReg20 = RECNO()
				ENDIF	
			ENDIF
		ENDSCAN
		LnNroRegAct = RECNO()
		IF !EMPTY(LsNroDoc)
			IF LnNroReg60>0
				GO LnNroReg60
				=RLOCK()
				replace NroDoc WITH LSNroDoc
				replace CodDoc WITH LSCodDoc
				unlock
			ENDIF
			IF LnNroReg20>0
				GO LnNroReg20
				=RLOCK()
				replace NroDoc WITH LSNroDoc
				replace CodDoc WITH LSCodDoc
				unlock
			ENDIF
			IF LnNroRegAct >0 AND RECNO()<>LnNroRegAct
				GO LnNroRegAct
			ENDIF
			WAIT WINDOW NroMes+CodOpe+NroAst + '-'+LsNroDoc nowait 			
		ENDIF
	ELSE
		
		SKIP 	
		LOOP
	ENDIF
ENDDO

