**************************************************************************
*  Nombre    : PLNSTPER.PRG                                              *
*  Objeto    : SITUACION DEL PERSONAL                                    *
*  Actualizaci¢n:   /  /                                                 *
**************************************************************************

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO STPER

loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('DMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

***************
PROCEDURE stper
***************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV02','')

cTit1 = "SITUACION DEL PERSONAL"
cTit2 = GsNomCia
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = " "
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
SELECT PERS
SET FILTER TO CODPLN = XsCodPln
GOTO TOP
SELECT DMOV
SET FILTER TO FlgEst="R" .OR. CodMov <> "@SIT"
XSitPer  = 1
XsCodPer = ""
*********************
DIMENSION VecOpc(9)

VecOpc(1)= "Activo          "
Vecopc(2)= "Descanso M‚dico "
VecOpc(3)= "Permiso sin goce"
VecOpc(4)= "Suspendido      "
VecOpc(5)= "Inactivo        "
VecOpc(6)= "Vacaciones      "
VecOpc(7)= "Licencia        "
VecOpc(8)= "Accidente       "
VecOpc(9)= "                "

UltTecla = 0
SelLin   = []
EdiLin   = "Edita0"
EscLin   = "Escbe0"
BrrLin   = "Borra0"
InsLin   = "Graba0"
GrbLin   = "Graba0"
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
E1       = [ COD.             NOMBRE                     SITUACION   ]
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
BBVerti  = .T.
Static   = .F.
VSombra  = .T.
Yo       = 6
Xo       = 8
Largo    = 16
Ancho    = 65
TBorde   = Simple
Set_Escape=.T.
XsCodMov = "@SIT"
NClave   = "LEFT(CODPLN,1)+NroPer+CodMov"
VClave   = XsCodPln+XsNroPer+XsCodMov
EscLin   = "Escbe0"
SEEK VClave
DO LIB_MTEC WITH 14
DO dBrowse
RETURN
****************
PROCEDURE Escbe0
****************
PARAMETER Contenido
=SEEK(CODPER,"PERS")
IF ValCal  < 2
	xSitPer = 1
ELSE
	XSitPer = ValCal
ENDIF
IF ValCal  > 8
	xSitPer = 9
ENDIF
Contenido = CodPer+' '+PADR(NOMBRE(),38)+' '+VecOpc(XSitPer)
RETURN
****************
PROCEDURE Edita0
****************
IF Crear
	XSitPer  = 0
	XsCodPer = SPACE(LEN(CodPer))
ELSE
	XsCodPer = CodPer
	XSitPer  = ValCal
ENDIF
DO LIB_MTEC WITH 6

I = 1
DO WHILE .T.
	DO CASE
		CASE I = 1 .AND. Crear
			SELECT PERS
			XiCodPer = XsCodPer
			@ LinAct,Xo+2    GET XiCodPer PICT "@"+REPLICATE("!",LEN(XsCodper))
			READ
			UltTecla = LASTKEY()
			XsCodPer = XiCodPer
			IF UltTecla = Escape
				EXIT
			ENDIF
			UltTecla = Lastkey()
			IF UltTecla = F8
				If pln_plnbusca("PERS")
					XsCodPer = CodPer
					UltTecla = CtrlW
				ENDIF
			ENDIF
			@ LinAct,Xo+2    SAY XsCodPer
			SEEK XsCodper
			IF ! FOUND()
				GsMsgErr = "C¢digo de Personal no registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			@ LinAct,Xo+8    SAY NomBRE() PICT "@S38"
		CASE I = 2
			XSitPer = Elige(XSitPer,LinAct,Xo+47,8)
			IF INLIST(UltTecla,F10,Enter,CtrlW,Escape)
				EXIT
			ENDIF
	ENDCASE
	I = IIF(UltTecla = Arriba,I-1,I+1)
	I = IIF(I>2,2,i)
	I = IIF(I<1,1,I)
ENDDO
SELE DMOV
IF UltTecla = Escape
	DO LIB_MTEC WITH 14
ENDIF
RETURN
****************
PROCEDURE Graba0
****************
SELECT DMOV
IF Crear
	SET FILTER TO
	SEEK XsCodPln+XsNroPer+"@SIT"+XsCodPer
	IF FOUND() .AND. FLGEST = "R"
		GsMsgErr = " C¢d. de Personal ya registrado "
		DO LIB_MERR WITH 99
	ENDIF
	SET FILTER TO FlgEst="R" .OR. CodMov <> "@SIT"
	IF ! FOUND()
		APPEND BLANK
	ENDIF
ENDIF
REPLACE CodPln WITH XsCodPln
REPLACE NroPer WITH XsNroPer
REPLACE CodMov WITH "@SIT"
REPLACE CodPer WITH XsCodPer
REPLACE ValCal WITH xSitPer
REPLACE ValREF WITH 0
REPLACE FLGEST WITH "R"
DO LIB_MTEC WITH 14
RETURN
****************
PROCEDURE Borra0
****************
IF REC_LOCK(5)
	DELETE
	UNLOCK
ENDIF
RETURN
***************
PROCEDURE KeyF5
***************
xFor   = [FlgEst="R"]
xWhile = RegVal
SEEK VClave
sNomRep = "PLNDMOVT"
DO ADMPRINT WITH "REPORTS"
RETURN