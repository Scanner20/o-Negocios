PARAMETERS PsUnidad
DEACTIVATE WINDOW  Desktop2
*!*	SET RESOURCE OFF
*!*	x=SYS(2005)
*!*	COPY FILE (x) TO "c:\temp\bkresource\"+JUSTSTEM(x)+".DBF"
*!*	COPY FILE STRTRAN(x,".DBF",".FPT") TO "c:\temp\bkresource\"+JUSTSTEM(x)+".FPT"
*!*	SET RESOURCE ON

IF VARTYPE(PsUnidad)<>'C'
	PsUnidad= "O:"
ENDIF

IF !USED('GDOC')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC again
ENDIF
IF !USED('item')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\vtaritem.dbf ALIAS item
ENDIF
IF !USED('CLIE')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\CCTCLIEN.dbf ALIAS CLIE

ENDIF
IF !USED('DIRE')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\CCTCDIRE.dbf ALIAS DIRE

ENDIF
IF !USED('TCMB')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\Admmtcmb.dbf ALIAS TCMB 
ENDIF
IF !USED('GDOC3')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC3 again
ENDIF
IF !USED('RDOC')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\ccbrrdoc.dbf ALIAS RDOC again
ENDIF

IF !USED('RMOV')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\c2021\cbdrmovm.dbf ALIAS RMOV again
ENDIF
** VETT:Agregamos relación con cabecera de asientos 2021/01/11 10:28:58 ** 
IF !USED('VMOV')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\c2021\cbdvmovm.dbf ALIAS VMOV again
ENDIF

IF !USED('RMOV2')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\c2021\cbdrmovm.dbf ALIAS RMOV2 again
ENDIF
** VETT:Agregamos relación con cabecera de asientos 2021/01/11 10:28:58 ** 
IF !USED('VMOV2')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\c2021\cbdvmovm.dbf ALIAS VMOV2 again
ENDIF

SELECT VMOV
SET ORDER TO VMOV01

SELECT VMOV2
SET ORDER TO VMOV01


DO Consulta_anulados

SELECT GDOC

_vfp.Caption =DBF()

SET ORDER TO  GDOC12   && DTOS(FCHDOC)+USERCREA+NRODOC
GO BOTT
BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoCmb:5,TpoRef:5,CodRef:5,NroRef:11,codope:4,nromes,nroast,glosa1:20,glosa2:20,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Roboto Mono',8 NOWAIT  LAST 
IF !USED('GDOC2')
	SELECT 0
	USE &PsUnidad.\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC2 AGAIN
ENDIF
SELECT GDOC2
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
*
SELECT item
SET ORDER to ITEM01   && CODDOC+NRODOC
*
SELECT RMOV
SET ORDER TO RMOV01
SELECT RMOV2
SET ORDER TO RMOV01


SELECT GDOC3
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC

SELECT RDOC
SET ORDER TO RDOC01   && TPODOC+CODDOC+NRODOC


SELECT CLIE
SET ORDER TO CLIEN04
SELECT DIRE
SET ORDER TO DIRE02   && CLFAUX+CODAUX+CODDIRE

SELECT GDOC
SET RELATION TO TPODOC+CODDOC+NRODOC INTO GDOC2
SET RELATION TO GSCLFCLI+CODCLI INTO CLIE ADDITIVE
SET RELATION TO GSCLFCLI+CODCLI INTO DIRE ADDITIVE

SELECT GDOC2
SET RELATION TO coddoc+nrodoc INTO item
SET RELATION TO TPOREF+CODREF+NROREF INTO GDOC3 ADDITIVE
SET RELATION TO TPODOC+CODDOC+NRODOC INTO RDOC ADDITIVE
SET RELATION TO NROMES+CODOPE+NROAST INTO RMOV ADDITIVE

** VETT:Agregamos relación con cabecera de asientos 2021/01/11 10:28:58 ** 
SELECT RMOV
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV ADDITIVE
SELECT RMOV2
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV2 ADDITIVE

SELECT GDOC2
BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoCmb:5,CodRef:5,NroRef:11,glosa1:20,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Roboto Mono',8 NOWAIT  LAST 


SELECT GDOC3
SET RELATION TO NROMES+CODOPE+NROAST INTO RMOV2 ADDITIVE

BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoCmb:5,CodRef:5,NroRef:11,glosa1:20,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Roboto Mono',8 NOWAIT  LAST 

SELECT RDOC
BROWSE LAST
SELECT Item
BROWSE LAST 
SELECT rmov
BROWSE last
SELECT rmov2
BROWSE last


SELECT Anulados
GO bott
BROWSE LAST NOWAIT

*****************************************
PROCEDURE Consulta_anulados
*****************************************
LnCurAct=SELECT()
SELECT * FROM GDOC WHERE DTOS(fchdoc)>='2021' AND flgest='A' AND INLIST(coddoc,'FACT','BOLE','N/D','N/C')  INTO CURSOR ANULADOS

BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoCmb:5,CodRef:5,NroRef:11,codope:4,nromes,nroast,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Roboto Mono',8 NOWAIT  LAST 
SELECT (LnCurAct)
RETURN 
