CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
Arch = ''

WAIT "Aperturando Sistema" NOWAIT WINDOW
*!*	DO fondo WITH 'Documentos pendientes por cliente',Goentorno.user.login,GsNomCia,GsFecha

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC02','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')

Arch = lodatadm.oentorno.tmppath+SYS(3)
RELEASE LoDatAdm
SELE GDOC

m.codcli1  = SPACE(LEN(codcli))
m.codcli2  = SPACE(LEN(codcli))
m.vendedor = space(4)
DO FORM ccb_ccbr4200
*!*	DO PENLista

IF USED('TEMPO')
	USE IN TEMPO
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('TDOC')
	USE IN TDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF

DELETE FILE &Arch..dbf
DELETE FILE &Arch..cdx
CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
RETURN

******************
PROCEDURE PenLista
******************
*!*	IF LASTKEY() = 27
*!*		RETURN
*!*	ENDIF
*!*	m.Vendedor = PADR(m.Vendedor,LEN(GDOC.CodVen))
IF !empty(m.vendedor)
	SET FILTER TO CODVEN = M.vendedor AND TpoVta<>3
ELSE
	SET FILTER TO TpoVta<>3
ENDIF
LOCATE
*!*	Test de impresion *!*
*XFOR = "FchDoc<=m.fchdoc .AND. FlgEst#'A'"
XFOR = "FchDoc<=m.fchdoc .AND. !(FlgEst=[A].AND.ImpTot=0)"
m.codcli1 = ALLTRIM(m.codcli1)
m.codcli2 = ALLTRIM(m.codcli2)+CHR(255)
*XWHILE = "TpoDoc=[CARGO] .AND. CodCli<=m.codcli2"
XWHILE = "CodCli<=m.codcli2"
*!* buscamos registro de arranque *!*
IF EMPTY(m.codcli1)
	GO TOP
	m.codcli1 = CodCli
ELSE
	SEEK m.codcli1
	IF !FOUND()
		IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
			GO RECNO(0)
			IF DELETED()
				SKIP
			ENDIF
			m.codcli1 = CodCli
		ENDIF
	ELSE
		m.codcli1 = CodCli
	ENDIF
ENDIF
SEEK m.codcli1
IF !FOUND()
	WAIT "Fin de Archivo, presione barra espaciadora para continuar .." WINDOW
	RETURN
ENDIF
*!* Generamos Base de trabajo *!*
SELE GDOC

COPY STRU TO &Arch.
SELE 0
USE &Arch. ALIAS AUXI EXCLU
IF !USED()
	RETURN
ENDIF
INDEX ON CodCli+TpoDoc+CodDoc+NroDoc TO &Arch.
SET INDEX TO &Arch.
*!* logica principal *!*
SELE GDOC
SEEK m.codcli1
SCAN WHILE &XWHILE. .AND. !EOF() FOR &XFOR.
	WAIT WINDOW "Procesando Documento " + GDOC.NroDoc NOWAIT
	IF GDOC->FLGEST#[A]
		m.TpoRef = TpoDoc
		m.CodRef = CodDoc
		m.NroRef = NroDoc
       	m.SdoDoc = ImpTot    && Saldo Original
		m.CodMon = CodMon
		*!* buscamos documentos de cancelacion *!*
		IF m.TpoRef = [CARGO]
			SELE VTOS
			SET ORDER TO VTOS03
			SEEK m.CodRef+m.NroRef
			SCAN WHILE CodRef+NroRef=m.CodRef+m.NroRef FOR FchDoc<=m.FchDoc
				IF CodMon = m.CodMon
					m.SdoDoc = m.SdoDoc - Import
				ELSE
					IF m.CodMon = 1
						m.SdoDoc = m.SdoDoc - ROUND(Import*TpoCmb,2)
					ELSE
						m.SdoDoc = m.SdoDoc - ROUND(Import/TpoCmb,2)
					ENDIF
				ENDIF
			ENDSCAN
		ELSE
			SELE VTOS
			SET ORDER TO VTOS01
			SEEK m.CodRef+m.NroRef
			SCAN WHILE CodDoc+NroDoc=m.CodRef+m.NroRef ;
				FOR FchDoc<=m.FchDoc
					IF CodMon = m.CodMon
					m.SdoDoc = m.SdoDoc - Import
				ELSE
					IF m.CodMon = 1
						m.SdoDoc = m.SdoDoc - ROUND(Import*TpoCmb,2)
					ELSE
						m.SdoDoc = m.SdoDoc - ROUND(Import/TpoCmb,2)
					ENDIF
				ENDIF
			ENDSCAN
		ENDIF
		IF m.SdoDoc > 0.01   && << OJO <<
			SELE AUXI
			APPEND BLANK
			REPLACE TpoDoc WITH IIF(GDOC->TpoDoc=[CARGO],[001],[002])
			REPLACE CodDoc WITH GDOC->CodDoc
			REPLACE NroDoc WITH GDOC->NroDoc
			REPLACE FchDoc WITH GDOC->FchDoc
			REPLACE FchVto WITH GDOC->FchVto
			REPLACE CodMon WITH GDOC->CodMon
			REPLACE ImpTot WITH IIF(GDOC->TpoDoc=[CARGO],GDOC->ImpTot,-1*GDOC->ImpTot)
			REPLACE SdoDoc WITH IIF(GDOC->TpoDoc=[CARGO],m.SdoDoc,-1*m.SdoDoc)
			REPLACE CodCli WITH GDOC->CodCli
			REPLACE FlgEst WITH GDOC->FlgEst
		ENDIF
		SELE GDOC
	ENDIF
ENDSCAN
SELE AUXI
SET RELA TO GsClfCli+CodCli INTO CLIE
GO TOP
XFOR   = '.T.'
XWHILE = '.T.'
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
sNomRep = "ccbr4200"
DO f0print WITH "REPORTS"
RETURN
