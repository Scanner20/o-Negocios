*****************************************************************************
* Programa     : ccbr4100.prg												*
* Sistema      : Saldos por cliente											*
* Proposito    : Ingreso de Notas de Cargo con actualizacion contable		*	
* Autor		   : VETT														*
* Creacion     : 13/03/95													*
* Parametros   :															*
* Actualizacion: VETT 28/03/00 Adhesivos S.A.								*
*				  VETT 02/09/2003 Adaptacion para VFP 7						*
* Actualizacion: VETT 23/11/2003 CEVA										*
*****************************************************************************
SYS(2700,0)
CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')

WAIT "Aperturando Sistema" NOWAIT WINDOW
*!*	DO fondo WITH 'Saldos por cliente',Goentorno.user.login,GsNomCia,GsFecha

** bases de datos a usar **
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC04','')
Arch = lodatadm.oentorno.tmppath+SYS(3)
SELE GDOC
SET FILTER TO TpoVta<>3
m.codcli1 = SPACE(LEN(codcli))
m.codcli2 = SPACE(LEN(codcli))
m.flgsit  = 3  && Legal



DO FORM CCB_CCBR4100

*!*	DO SDOLista

IF USED('TEMPO')
	USE IN TEMPO
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
RELEASE LoDatAdm
RETURN
SYS(2700,1)
*******************
PROCEDURE SDOLista
*******************
*
*DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
*!*	Titulo = "REPORTE DE SALDOS POR CLIENTE"
*!*	@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
*!*	@ 6,10 CLEAR TO 20,70
*!*	@ 6,10 TO 20,70 DOUBLE
IF USED('TEMPO')
	USE IN TEMPO
ENDIF

SELE 0
CREATE TABLE &Arch. FREE ( NomCli C(50) , VenNac N(12,2) , VenUsa N(12,2) ,;
                      CodCli C(5), PVenNac N(12,2) , PVenUsa N(12,2) )
USE &Arch ALIAS TEMPO EXCLUSIVE 
INDEX ON NomCli TO &Arch.
** variables a usar **
** pantalla de datos **
*!*	GsMsgKey = "[Esc] Salir   [Enter] Aceptar"
*!*	DO lib_mtec WITH 99
*!*	@  8,20 SAY "Del Cliente :" GET m.codcli1 PICT "@!" valid _vlook(m.codcli1,'codaux')
*!*	@ 10,20 SAY " Al Cliente :" GET m.codcli2 PICT "@!" valid _vlook(m.codcli1,'codaux')
*!*	READ
*!*	IF LASTKEY() = 27
*!*	   RETURN
*!*	ENDIF
** test de impresion **


m.codcli1 = ALLTRIM(m.codcli1)
m.codcli2 = ALLTRIM(m.codcli2)+CHR(255)
XWHILE = "clfaux+codaux<=gsclfcli+m.codcli2"
** buscamos registro de arranque **
SELE CLIE
IF EMPTY(m.codcli1)
   SEEK GsClfCli
ELSE
   SEEK GsClfCli+m.codcli1
   IF !FOUND()
      IF RECNO(0)>=0 .AND. RECNO(0)<=RECCOUNT()
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF EOF()
   WAIT "Fin de Archivo, presione barra espaciadora para continuar .." WINDOW
   RETURN
ENDIF
*
DO xGenera
SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO lib_merr WITH 99
   RETURN
ENDIF
*
CLEAR MACROS 
STORE [] TO xFOR,xWHILE
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "ccbr4100"
DO F0print WITH "REPORTS"

RETURN
*********************************************************************** FIN() *
* Objeto : Generar Archivo de Impresion
*******************************************************************************
PROCEDURE xGenera


SELE CLIE
SCAN WHILE &xWHILE
   WAIT "Verificando Cliente : "+NomAux WINDOW NOWAIT
   * Calculamos Importes
   XfVenNac = _VenNac()
   XfVenUsa = _VenUsa()
   XfPVenNac= _PVenNac()
   XfPVenUsa= _PVenUsa()
   IF XfVenNac+XfVenUsa+XfPVenNac+XfPVenUsa > 0
      SELE TEMPO
      APPEND BLANK
      REPLACE CodCli WITH CLIE->CodAux
      REPLACE NomCli WITH CLIE->NomAux
      REPLACE VenNac  WITH XfVenNac
      REPLACE VenUsa  WITH XfVenUsa
      REPLACE PVenNac WITH XfPVenNac
      REPLACE PVenUsa WITH XfPVenUsa
   ENDIF
   SELE CLIE
ENDSCAN
WAIT "Fin de Generacion" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *

FUNCTION _vennac
****************
* calcula el saldo vencido nacional *

PRIVATE iImport,cAlias
iImport = 0.00
SELECT GDOC
SEEK CLIE->CodAux+"P"+"CARGO"
SCAN WHILE codcli+flgest+tpodoc = CLIE->CodAux+"P"+"CARGO" ;
   FOR CodMon = 1 .AND. FchVto <= DATE()
   iImport = iImport + SdoDoc
ENDSCAN

RETURN iImport

FUNCTION _venusa
****************
* calcula el saldo vencido usa *
PRIVATE iImport,cAlias
iImport = 0.00
SELECT GDOC
SEEK CLIE->CodAux+"P"+"CARGO"
SCAN WHILE codcli+flgest+tpodoc = CLIE->CodAux+"P"+"CARGO" ;
   FOR CodMon = 2 .AND. FchVto <= DATE()
   iImport = iImport + SdoDoc
ENDSCAN

RETURN iImport

FUNCTION _pvennac
*****************
* calcula el saldo por vencer nacional *
PRIVATE iImport,cAlias
iImport = 0.00
SELECT GDOC
SEEK CLIE->CodAux+"P"+"CARGO"
SCAN WHILE codcli+flgest+tpodoc = CLIE->CodAux+"P"+"CARGO" ;
   FOR CodMon = 1 .AND. FchVto > DATE()
   iImport = iImport + SdoDoc
ENDSCAN

RETURN iImport

FUNCTION _pvenusa
*****************
* calcula el saldo por vencer usa *
PRIVATE iImport,cAlias
iImport = 0.00
SELECT GDOC
SEEK CLIE->CodAux+"P"+"CARGO"
SCAN WHILE codcli+flgest+tpodoc = CLIE->CodAux+"P"+"CARGO" ;
   FOR CodMon = 2 .AND. FchVto > DATE()
   iImport = iImport + SdoDoc
ENDSCAN

RETURN iImport
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select CLIE
   IF ! ccbbusca("CLIE")
      SELECT gdoc
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla= Enter
   SELECT gdoc
ENDIF
IF UltTecla = ESCAPE_ .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(VAR1,"CLIE")
   RETURN .F.
ENDIF
RETURN .T.


