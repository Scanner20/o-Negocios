*/ paso 2
&& Programa para generar automaticas 67
SET DELETED ON
CLOSE ALL 
PUBLIC mes, ope, ast, itm, ktm, etm, cta, mov, impt, usa, dbn, hbn, dbu, hbu, rmimp, rmusa, sie, ritm, fch, mon, ajs, n, reg
rmimp = 0.00
rmusa = 0.00
n = 0
sie = 0
SET DEFAULT TO H:\o-Negocios\Aromas\data\CIA004\c2011
*SET DEFAULT TO C:\TEMP

USE CBDRMOVM ORDER RMOV01 ALIAS rmctas && NROMES+CODOPE+NROAST+STR(NROITM,5)
SELECT 0
USE CBDVMOVM ORDER VMOV01 ALIAS vmctas && NROMES+CODOPE+NROAST
SELECT 0

SELECT rmctas
GO top
*SET STEP ON 
DO WHILE .not.eof()
STORE nromes TO mes
STORE codope TO ope
STORE nroast TO ast
STORE nroitm TO itm
STORE fchdoc TO fch
STORE import TO imp
STORE tpocmb TO cmb
STORE codmon TO mon
STORE impusa TO usa
STORE tipdoc TO doc
STORE codcco TO cco
reg = RECNO()
*!*	?RECNO() 
	IF CODOPE='005' AND INLIST(rmctas.codcta,'63706','62905') THEN 
	ritm = rmctas.nroitm
	kitm = rmctas.chkitm
	SKIP		
		IF rmctas.codcta<>'9'
			sk = 0 
			DO WHILE rmctas.nromes+rmctas.codope+rmctas.nroast = mes+ope+ast
			*!*				replace nroitm WITH nroitm  + 2
			*!*				replace chkitm WITH chkitm  + 2
			sk = sk + 1 
			SKIP 			
			ENDDO  
			DO WHILE sk > 0
			SKIP -1 
			*IF codope = '010'
			replace nroitm WITH nroitm  + 2
			replace chkitm WITH chkitm  + 2
			*ENDIF 
			sk = sk - 1 
			ENDDO 
			n = n + 1 	 
			APPEND BLANK 
			replace nromes with mes,codope with ope ,nroast with ast,nroitm WITH ritm + 1,chkitm WITH kitm + 1 ,codcta WITH '94000'
			replace fchdoc WITH fch,tpocmb with cmb, tpomov WITH 'D', import WITH imp,codmon WITH mon
			replace impusa WITH usa, fchast WITH fch,coddiv WITH '01', codcco WITH '9999'
			replace eliitm WITH '*'
			APPEND BLANK 
			replace nromes with mes,codope with ope ,nroast with ast,nroitm WITH ritm + 2,chkitm WITH kitm + 2 ,codcta WITH '79901'
			replace fchdoc WITH fch,tpocmb with cmb, tpomov WITH 'H', import WITH imp,codmon WITH mon
			replace impusa WITH usa, fchast WITH fch,coddiv WITH '01', codcco WITH '9999'
			replace eliitm WITH '*'
			SELECT vmctas	
			SEEK mes+ope+ast
			IF FOUND()
				replace nroitm WITH nroitm + 2		
				replace dbenac WITH dbenac + imp
				replace dbeusa WITH dbeusa + usa
				replace hbenac WITH hbenac + imp
				replace hbeusa WITH hbeusa + usa
			ENDIF 
			SELECT 0
			SELECT rmctas
			GO TOP 
			SEEK mes+ope+ast+STR(itm,5)
			*SET STEP ON 
			SKIP 
			IF reg = RECNO() then
				SKIP
			ENDIF
		ELSE
			SKIP  
		ENDIF 
	ELSE
		SKIP
	ENDIF 
CLEAR
ENDDO


