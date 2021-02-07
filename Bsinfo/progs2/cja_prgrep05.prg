*******************************************
* Reporte de Cheques por Centro de Costos *
*******************************************
#INCLUDE const.h
*!*	Abrimos Bases *!*
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV02','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')

*!*	Declaramos Variables
STORE " " TO LcArcTmp,XsCtaDes,XsCtaHas,XsCodOpe
XdFch1 = CTOD('01/'+STR(_MES,2,0)+'/'+STR(_ANO,4,0))
XdFch2 = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),IIF(VARTYPE(GdFecha)='D',GdFecha,DATE()))

DO FORM cja_frmrep05

******************
PROCEDURE Imprimir
******************
XsCtaDes = IIF(Empty(XsctaDes),'104',TRIM(XsCtaDes))
XsCtaHas = IIF(Empty(XsCtaHas),'104',TRIM(XsCtaHas))
LcArcTmp=GoEntorno.TmpPath+Sys(3)
SELECT 0
CREATE TABLE (LcArcTmp) FREE (CodCta c(LEN(RMOV.CodCta)), ;
							  CodCco c(LEN(RMOV.CodCco)), ;
							  FchDoc d, ;
							  NroMes C(2) , ;
							  CodOpe C(3) , ;
							  NroAst c(LEN(RMOV.NroAst)),;
							  NroChq c(15), ;
							  Girado c(60), ;
							  CodMon n(1), ;
							  IMPORT n(16,2), ;
							  TpoCmb n(10,4), ;
							  ImpUsa n(16,2), ;
							  NotAst c(40),;
							  ImpChq n(16,2),;
							  GlodDoc C(60),;
							  CtaCja C(LEN(RMOV.CodCta)),;
							  NroVou C(LEN(VMOV.Nrovou)) )
							   
USE (LcArcTmp) EXCLUSIVE ALIAS TEMPORAL
INDEX ON CodCta+CodCco+NroAst TAG TEMP01

SELECT CTAS
SEEK XsCtaDes
SCAN WHILE CodCta >= XsCtaDes AND CodCta <= XsCtaHas && FOR AftMov='S'
	IF !AftMov='S'
		LOOP
	ENDIF
	LsCodCta = CodCta
	SELECT RMOV
	Xllave = XsNroMes+LsCodCta
	SEEK Xllave
	SCAN WHILE NroMes + CodCta = Xllave
		IF !EMPTY(XsCodOpe)
			IF XsCodOpe <> RMOV.CodOpe
				LOOP
			ENDIF
		ENDIF
		IF !EMPTY(XsCodCco)
			IF XsCodCco <> TRIM(RMOV.CodCco)
				LOOP
			ENDIF
		ENDIF
		SELECT TEMPORAL
		IF RMOV.FchAst >= XdFch1 AND RMOV.FchAst <= XdFch2 AND RMOV.TpoMov = 'H'
			APPEND BLANK
			REPLACE CodCta WITH RMOV.CodCta
			REPLACE CodCco WITH RMOV.CodCco
			REPLACE FchDoc WITH RMOV.FchDoc
			REPLACE NroAst WITH RMOV.NroAst
			Replace Import WITH RMOV.Import
			Replace Impusa WITH RMOV.ImpUsa
			=SEEK(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,"VMOV")
			replace Girado WITH VMOV.Girado
			replace NotAst WITH  VMOV.NotAst
			Replace ImpChq WITH VMOV.ImpChq
			Replace CodMon WITH Vmov.CodMon
			Replace TpoCmb WITH VMOV.TpoCmb
			Replace CtaCja WITH VMOV.CtaCja
			Replace NroChq WITH VMOV.NroChq
		ENDIF
	ENDSCAN
ENDSCAN
