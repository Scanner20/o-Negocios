*!* Impresión de Cheque-Voucher *!*
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoContab=CREATEOBJECT('Dosvr.Contabilidad')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoContab.oDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')

SELECT vmov
XiCodMon = 2
DO FORM cja_cjachqvo
RELEASE LoContab

*********************
PROCEDURE xGenera_Vou
*********************
XsCodDo1 = []
SELE VMOV && Cabecera
SEEK XsNroMes+XsCodOpe+XsNroAstDes
Impresa = 1
SCAN WHILE NroMes+CodOpe = XsNroMes+XsCodOpe AND NroAst <= XsNroAstHas
	XsNroAst = NroAst
	IF XiCodMon <> VMOV.CodMon
		SELECT VMOV
		LOOP
	ENDIF
	SELECT rmov
	SEEK XsNroMes+XsCodOpe+XsNroAst
	SCAN WHILE NroMes+CodOpe+NroAst = XsNroMes+XsCodOpe+XsNroAst
		IF INLIST(EliItm,".")
			XsCodDoc1 = RMOV->CodDoc
			IF XsCodDoc1 <> "CH"
				SELECT VMOV
				LOOP
			ENDIF
		ENDIF
	ENDSCAN
	SELECT VMOV_T
	SEEK XsNroMes+XsCodOpe+XsNroAst
	IF !FOUND()
		APPEND BLANK
		replace NroMes WITH VMOV.NroMes
		replace CodOpe WITH VMOV.CodOpe
		replace NroAst WITH VMOV.NroAst
		replace FchAst WITH VMOV.FchAst
		replace Quiebre WITH Impresa
		XsImpChq = ALLTRIM(TRANSFORM(VMOV.ImpChq,"999,999,999.99"))
		XsImpChq = RIGHT(repli("*",LEN(VMOV_T.ImpChq)) + LTRIM(XsImpChq), LEN(VMOV_T.ImpChq))
		replace ImpChq WITH XsImpChq
		replace Girado WITH VMOV.Girado
		replace NumLet WITH NUMERO(VMOV.ImpChq,2,1)
		=SEEK(VMOV.CtaCja,"CTAS")
		replace NroCta WITH CTAS.NroCta
		replace NroChq WITH VMOV.NroChq
		XsCodBco = TRIM(CTAS.CodBco)
		=SEEK(TRIM(GSCLFBCO)+XsCodBco,"TABL")
		XsNomBco = TABL.Nombre
		replace NomBco WITH XsNomBco
		replace Concepto WITH VMOV.NotAst
		replace Concepto1 WITH mline(VMOV->GLOAST,1)
	ENDIF
	SELECT RMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	SCAN WHILE NroMes+CodOpe+NroAst=XsNroMes+XsCodOpe+XsNroAst
		SELECT RMOV_T
		APPEND BLANK
		replace NroMes WITH RMOV.NroMes
		replace CodOpe WITH RMOV.CodOpe
		replace NroAst WITH RMOV.NroAst
		replace Quiebre WITH Impresa
		replace FchAst WITH RMOV.FchAst
		replace CodCta WITH RMOV.CodCta
		replace CodAux WITH RMOV.CodAux
		replace CodCco WITH VMOV.Auxil
		replace FchPro WITH RMOV.FchPro
		replace NroPro WITH RMOV.NroPro
		replace NroDoc WITH RMOV.NroDoc
		IF RMOV.CodMon = 2
			replace ImpUsa WITH RMOV.ImpUsa
		ENDIF
		IF RMOV.TpoMov="D"
			replace ImpDbe WITH RMOV.Import
		ELSE
			replace ImpHbe WITH RMOV.Import
		ENDIF
	ENDSCAN
	Impresa = Impresa + 1
	SELECT VMOV
ENDSCAN
