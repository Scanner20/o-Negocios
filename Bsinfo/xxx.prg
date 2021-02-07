oForm=CREATEOBJECT('Admvrs.Base_form')

oForm.addobject('CmdSalir','Admgral.CmdSalir')

oform.CmdSalir.Enabled = .t.
oform.CmdSalir.Visible = .t.
WITH oForm.CmdSalir
   .Left = 50  && Command button column
   .Top = 100  && Command button row

ENDWITH
oForm.SHOW  && Display the form
*!*	READ EVENTS  && Start event processing
*!*	CLEAR EVENTS 

SELECT 0
USE d:\o-negocios\IDC\Data\cia001\almtgsis.dbf  ALIAS IDC
SET ORDER TO TABL01   && TABLA+CODIGO

SELECT 0
USE d:\o-negocios\DCASA\Data\cia001\almtgsis.dbf  ALIAS DCASA
SET ORDER TO TABL01   && TABLA+CODIGO

SELECT IDC
SCAN 
	SCATTER MEMVAR 
	m.CodUser = 'VETT'
	m.FchHora = DATETIME()
	
	SELECT DCASA
	SEEK m.Tabla+m.Codigo
	IF !FOUND()
		APPEND BLANK 
		GATHER MEMVAR 
	ENDIF
	
	SELECT IDC
	
ENDSCAN
