PARAMETERS PsTable,PsExcelFile,PsHoja,PlLoadTable
IF VARTYPE(PsTable)<>'C'
	PsTable = ''
ENDIF
IF VARTYPE(PsExcelFile)<>'C'
	PsExcelFile = ''
ENDIF
IF VARTYPE(PsHoja)<>'C'
	PsHoja = ''
ENDIF
IF VARTYPE(PlLoadTable)<>'L'
	PlLoadTable = .F.
ENDIF

IF EMPTY(PsTable) OR EMPTY(PsExcelFile) OR EMPTY(PsHoja)
	PlLoadTable = .F.
ENDIF

IF PlLoadTable
	DO k:\aplvfp\bsinfo\progs2\copiarexcel2dbf.prg WITH "O:\o-Negocios\IDC\local\Ctas2018.DBF","O:\o-Negocios\IDC\local\Docs\PLAN CONTABLE VICTOR.xlsx","Hoja2",'','1=1','','1=1'
	DO k:\aplvfp\bsinfo\progs2\copiarexcel2dbf.prg WITH "O:\o-Negocios\IDC\local\Ctas_cont.DBF","O:\o-Negocios\IDC\local\Docs\PLAN CONTABLE CAUCHOS ULTIMA.xlsx","PLAN CONTABLE CAUCHO",'','1=1','','1=1',.t.,.t.
ENDIF


SELECT 0
USE O:\O-NEGOCIOS\IDC\LOCAL\CTAS_Cont.DBF ALIAS c6y9
SET ORDER TO CTAS01   && CODCTA

SELECT 0
USE O:\O-NEGOCIOS\IDC\LOCAL\CTAS2018.DBF ALIAS c2018
SET ORDER TO CTAS01   && CODCTA 
SELECT 0
USE Cia001!cbdmauxi ALIAS AUXI
SET ORDER TO AUXI01   && CODCTA
SELECT 0
USE p0012018!cbdmctas ALIAS ctas
SET ORDER TO CTAS01   && CODCTA
SELECT 0
USE p0012018!cbdmctas ALIAS ctas2 AGAIN
SET ORDER TO CTAS01   && CODCTA 
SET STEP ON 
SELECT c2018
SCAN FOR !EMPTY(CodCta)
	SCATTER memvar
	SELECT CTAS
	=SEEK(m.CodCta)
	IF FOUND()
		GATHER MEMVAR FIELDS EXCEPT m.CodCta
		IF !EMPTY(m.c91) OR !EMPTY(m.c94) OR !EMPTY(m.c95) OR !EMPTY(m.c97)
			m.ClfAux = 'CT9'
			m.PidAux = 'S'
			m.MayAux = 'N'
			m.tip_afe_rc= 'A'
			m.tip_afe_rv= ''
			m.tip_afe_rt= ''
			m.an1cta	=	''
			m.CodCta_B	= '01'
			*91		
			Llfound6y9=SEEK(m.c91,'C6y9','CTAS01')
			SELECT auxi
			SEEK m.ClfAux+m.c91
			IF !FOUND() AND !EMPTY(m.c91)
				APPEND BLANK 
				REPLACE ClfAux WITH m.ClfAUx, CodAux WITH m.c91, NomAux WITH IIF(LlFound6y9,C6y9.Nomcta,'Cuenta no existe')
			ENDIF	
			IF Llfound6y9 AND !EMPTY(m.c91)
				IF !SEEK(m.c91,'CTAS2')
					=AddCta6y9(.t.,m.c91)
				ELSE
					=AddCta6y9(.F.,m.c91)	
				ENDIF  
			ENDIF
			SELECT AUXI
			*94		
			Llfound6y9=SEEK(m.c94,'C6y9','CTAS01')
			SELECT auxi
			SEEK m.ClfAux+m.c94
			IF !FOUND() AND !EMPTY(m.c94)
				APPEND BLANK 
				REPLACE ClfAux WITH m.ClfAUx, CodAux WITH m.c94, NomAux WITH IIF(LlFound6y9,C6y9.Nomcta,'Cuenta no existe')
			ENDIF
			IF Llfound6y9 AND !EMPTY(m.c94)
				IF !SEEK(m.c94,'CTAS2')
					=AddCta6y9(.t.,m.c94)
				ELSE
					=AddCta6y9(.F.,m.c94)	
				ENDIF  
			ENDIF
			SELECT AUXI

			*95	
			Llfound6y9=SEEK(m.c95,'C6y9','CTAS01')
			SELECT auxi
			SEEK m.ClfAux+m.c95
			IF !FOUND() AND !EMPTY(m.c95)
				APPEND BLANK 
				REPLACE ClfAux WITH m.ClfAUx, CodAux WITH m.c95, NomAux WITH IIF(LlFound6y9,C6y9.Nomcta,'Cuenta no existe')
			ENDIF
			IF Llfound6y9 AND !EMPTY(m.c95)
				IF !SEEK(m.c95,'CTAS2')
					=AddCta6y9(.t.,m.c95)
				ELSE
					=AddCta6y9(.F.,m.c95)	
				ENDIF  
			ENDIF
			SELECT AUXI
			
			*97	
			Llfound6y9=SEEK(m.c97,'C6y9','CTAS01')
			SELECT auxi
			SEEK m.ClfAux+m.c97
			IF !FOUND() AND !EMPTY(m.c97)
				APPEND BLANK 
				REPLACE ClfAux WITH m.ClfAUx, CodAux WITH m.c97, NomAux WITH IIF(LlFound6y9,C6y9.Nomcta,'Cuenta no existe')
			ENDIF	
			IF Llfound6y9 AND !EMPTY(m.c97)
				IF !SEEK(m.c97,'CTAS2')
					=AddCta6y9(.t.,m.c97)
				ELSE
					=AddCta6y9(.F.,m.c97)	
				ENDIF  
			ENDIF
			SELECT AUXI
			** Actualizamos la cuenta origen **		
			SELECT CTAS
			REPLACE ClfAux WITH m.ClfAux, PidAux WITH m.PidAux, MayAux WITH m.MayAux , tip_afe_rc WITH	m.tip_afe_rc
			REPLACE an1Cta WITH m.an1cta, tip_afe_rv WITH m.tip_afe_rv, tip_afe_rt WITH m.tip_afe_rt
			REPLACE CodCta_B WITH m.CodCta_B
		ENDIF
	ELSE
		SELECT CTAS
		APPEND BLANK
		GATHER MEMVAR	
		
	ENDIF
	SELECT c2018
	
ENDSCAN
******************
FUNCTION AddCta6y9
******************
PARAMETERS PlNew,PsCodCta
LnSelect = SELECT()	
SELECT CTAS2
IF PlNew
	APPEND BLANK 
ENDIF
REPLACE CodCta WITH PsCodCta,NomCta WITH IIF(LlFound6y9,C6y9.Nomcta,' Revisar nombre '+GoEntorno.User.Login+' '+ttoc(DATETIME()) )
REPLACE NivCta WITH C6y9.NivCta	, TpoMov WITH C6y9.TpoMov, AftMov WITH C6y9.TpoMov , AftDcb WITH C6y9.AftDcb
REPLACE CodMon WITH C6y9.CodMon , TpoCta WITH C6y9.TpoCta, PidAux WITH C6y9.PidAux , ClfAux WITH C6y9.ClfAux 
REPLACE PidCco WITH	C6y9.PidCco , PidDoc WITH C6y9.PidDoc, CodDoc WITH C6y9.CodDoc , CieRes WITH C6y9.CieRes
REPLACE GenAut WITH C6y9.GenAut , An1Cta WITH C6y9.An1Cta, Cc1Cta WITH C6y9.Cc1Cta , Cc2Cta WITH C6y9.Cc2Cta,An2CtaMe WITH C6y9.An2CtaMe
REPLACE PidGlo WITH C6y9.PidGlo , MayAux WITH C6y9.MayAux, MayCco WITH C6y9.MayCco , CctDef WITH C6y9.CctDef
REPLACE An1_SubCta WITH C6y9.An1_SubCta , Cc1_SubCta WITH C6y9.Cc1_SubCta, MayCco WITH C6y9.MayCco , CctDef WITH C6y9.CctDef
REPLACE tip_afe_rv WITH C6y9.tip_afe_rv , tip_afe_rc WITH C6y9.tip_afe_rc, tip_afe_rt WITH C6y9.tip_afe_rt , CodCta_B WITH C6y9.CodCta_B  	

SELECT (LnSelect)