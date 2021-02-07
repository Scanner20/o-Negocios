*************************************************************************
* Nombre    : PLNCdCal.PRG                                              *
* Objeto    : Condiciones de C lculo.                                   *
* Creaci¢n     : 18/12/90                                               *
*************************************************************************

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO cdcal
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('DMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

***************
PROCEDURE cdcal
***************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')


cTit1 = "Condiciones de Calculo"
cTit2 = GsNomCia
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = " "
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

SELECT TMOV
*         10        20        30        40        50        60        70
*123456789 123456789 123456789 123456789 123456789 123456789 123456789 123
*
*.---------------------------------------------------------.
*| C¢d.  Descripci¢n                                       |
*+---------------------------------------------------------+
*| 123   123456789-123456789-12345  123456789-123456789-12 |
*|    123                         12                      1|
*`---------------------------------------------------------'

* Variables Usadas en la Edici¢n y Grabaci¢n de Items
PRIVATE  XsValCal , TsEntPict , TsDecPict

TsEntPict   = "##,###,###,###,###"
TsDecPict   = ".####"
XnValCal = 0
XnValRef = 0
UltTecla = 0
SelLin   = []
EdiLin   = "Edita1"
EscLin   = "Escbe1"
BrrLin   = []
InsLin   = []
GrbLin   = "Graba1"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = "KeyF5"
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
Titulo   = []
E1       = " C¢d.  Descripci¢n                                       "
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .F.
BBVerti  = .T.
Static   = .F.
VSombra  = .T.
Yo       = 06
Xo       = 10
Largo    = 16
Ancho    = 59
TBorde   = Simple
Set_Escape =.T.
NClave   = "CodMov"
VClave   = "A"
EscLin   = "Escbe1"
DO LIB_MTEC WITH 14
DO dBrowse
*!*	CLOSE DATA
RETURN
****************
PROCEDURE Escbe1
****************
PARAMETER Contenido
xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
=SEEK(xLLave+TMOV->CodMov,"DMOV")
TsFormat = "####,###,###,###,###"
TnLargo  = 14
IF EntMov >0 .AND. EntMov<15
	TnLargo  = EntMov
ENDIF
IF DecMov >=0 .AND. DecMov<5
	TsFormat = TsFormat + "." + LEFT("####",DecMov)
	TnLargo  = TnLargo  + DecMov + 1
ENDIF
TsFormat = RIGHT(TsFormat,TnLargo)

Contenido = CodMov+'  '+DesMov+'  '
IF RIGHT(CodMov,2)='00'
	Contenido = Contenido + REPLICATE('-',22)
ELSE
	Contenido = Contenido + ;
	RIGHT(SPACE(22)+' '+TRANSF(DMOV->ValCal,TsFormat),22)
ENDIF
RETURN
****************
PROCEDURE Edita1
****************
PRIVATE TlTitle , TnLargo ,TsFormat , TnXo , TlSigue
xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
=SEEK(xLLave+TMOV->CodMov,"DMOV")
TsFormat = "####################"
XnValCal = DMOV->ValCal
XnValRef = DMOV->ValRef
IF RIGHT(CodMov,2)="00"
	UltTecla = Escape
	RETURN
ENDIF
TnLargo  = 14
IF EntMov >0 .AND. EntMov<15
	TnLargo  = EntMov
ENDIF
IF DecMov >=0 .AND. DecMov<5
	TsFormat = TsFormat + "." + LEFT("####",DecMov)
	TnLargo  = TnLargo  + DecMov + 1
ENDIF
TsFormat = RIGHT(TsFormat,TnLargo)
TnXo     = Xo+57-TnLargo
do lib_mtec with 6
DO WHILE .T.
	@ LinAct,TnXo  GET XnValCal PICT "@Z "+TsFormat
	READ
	UltTecla = LASTKEY()
	IF RgoMov="S" .AND. UltTecla <> Escape
		IF (XnValCal<ValMin .OR. XnValCal>ValMax )
			GsMsgErr = "Dato Fuera de Rango"
			DO LIB_MERR WITH 99
			LOOP
		ENDIF
	ENDIF
	EXIT
ENDDO
SELE TMOV
IF UltTecla = Escape
	DO LIB_MTEC WITH 14
ENDIF
RETURN
****************
PROCEDURE Graba1
****************
SELE DMOV
xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
SEEK xLLave+TMOV->CodMov
IF ! FOUND()
	APPEND BLANK
ENDIF
IF REC_Lock(5)
	REPLACE NroPER WITH  ""
	REPLACE CodPER WITH  ""
	REPLACE CodMov WITH  TMOV->CodMov
	REPLACE ValRef WITH  XnValRef
	REPLACE ValCal WITH  XnValCal
	UNLOCK
ENDIF
SELE TMOV
DO LIB_MTEC WITH 14
RETURN
***************
PROCEDURE KeyF5
***************
xFor   = []
xWhile = [EVALUATE(NClave)=Vclave]
SEEK VClave
sNomRep = "PLN_PLNDMOVT"
DO ADMPRINT WITH "REPORTS"
RETURN