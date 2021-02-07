SELECT 0
USE H:\clientes\quimica\cia006\ccbrgdoc.DBF ALIAS quim
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CargoFACT0010005809'
IF !FOUND()
	APPEND BLANK
	Replace TpoDoc WITH 'Cargo'
	Replace CodDoc WITH 'FACT'
	replace NroDoc WITH '0010005809'
	REPLACE FchDoc WITH CTOD('25/08/2004')
	replace FlgEst WITH 'C'
	REPLACE CodCli WITH '50197352'
	REPLACE NomCli WITH 'EMBOTELLADORA DON JORGE S.A.C.'  
	replace Soles  WITH .25
	replace Dolares  WITH .75
	LlActualiza= .T.
ELSE
	
	IF Soles + Dolares = 1
		LlActualiza= .F.
	ELSE
		=RLOCK()
		LlActualiza= .T.		
		replace Soles  WITH .25
		replace Dolares  WITH .75
		UNLOCK
		
	ENDIF
	
ENDIF

IF Llactualiza
	WAIT WINDOW 'Hola' nowait
	SET ORDER TO GDOC08   && DTOC(FCHDOC,1)+CODCLI+TPODOC+CODDOC+NRODOC
	SEEK '2007'
	UPDATE quim SET Soles = VAL(Nrodoc), ;
		Dolares = VAL(codcli),;
		NroDoc	= encrypt(Nrodoc,Tpodoc,1024),;
		CodCli	= encrypt(CodCli,Tpodoc,1024),;
		NomCli = encrypt(NomCli,Tpodoc,1024),;
		FlgEst = encrypt(FlgEst,Tpodoc,1024);
	where DTOS(fchdoc)='2007'
		
	WAIT WINDOW 'Listo' nowait

ENDIF

IF USED('QUIM')
	USE IN QUIM 
ENDIF