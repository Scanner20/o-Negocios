**************************************************************************
*  Nombre    : PLNDMOVT.PRG                                              *
*  Objeto    : Variables para el C lculo de planilla                     *
*  Creaci¢n     : 18/12/90                                               *
**************************************************************************
PARAMETER cTipMov,cNomMov

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO dmovt

loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('TMOV')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

***************
PROCEDURE dmovt
***************
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),1)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = cNomMov
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE

SELECT pers
SET FILTER TO CodPln = XsCodPln
MsCodPer = PERS.CodPer
SEEK MsCodPer
SELECT TMOV
DO WHILE .T.
   SELECT PERS
   TsCodPer = PERS->CodPer
   @ 6,10  SAY SPACE(59)
   @ 6,20  SAY LEFT(NOMPER,40)
   @ 6,12  SAY PERS->CodPer
   SELECT TMOV
   DO ASMSelec
   SELECT PERS
   @ 6,12 GET TsCodPer PICT "@!"
   READ
   UltTecla = LASTKEY()
   TsCodPer = RIGHT("0000000"+ALLTRIM(TsCodPer),LEN(TsCodPer))
   DO CASE
      CASE UltTecla = Escape
         EXIT
      CASE UltTecla = PgUp
         IF EOF()
            GOTO BOTTOM
         ELSE
            IF .NOT. BOF()
               SKIP -1
            ENDIF
         ENDIF
         LOOP
      CASE UltTecla = PgDn
         IF .NOT. EOF()
            SKIP
         ENDIF
         IF EOF()
            GOTO BOTTOM
         ENDIF
         LOOP
      CASE UltTecla = F8
         IF ! PLN_PLNBUSCA("PERS")
            LOOP
         ENDIF
         TsCodPer = PERS->CodPer
      OTHER
         SEEK TsCodPer
         IF ! FOUND()
            GsMsgErr = "C¢digo de Personal no registrado"
            DO LIB_MERR WITH 99
            LOOP
         ENDIF
   ENDCASE
   TsCodPer = CodPer
   @ 6,12 SAY CodPer
   @ 6,20 SAY NOMBRE() PICT "@S36"
   SELECT TMOV
   DO XBrowse
   SELECT PERS
   SKIP
   IF EOF()
      GOTO BOTTOM
   ENDIF
ENDDO
*!*	CLOSE DATA
RETURN
******************
PROCEDURE ASMSelec
******************
@ 5,10 CLEAR TO 7,68
@ 5,10       TO 7,68
*@ 6,20  SAY LEFT(PERS->NOMPER,40)
@ 6,20  SAY NOMBRE() PICT "@S36"
@ 6,12  SAY PERS->CodPer
@ 08,10 CLEAR TO 21,68
@ 08,10       TO 21,68
@ 09,11 SAY   " C¢d.  Descripci¢n                                       " COLOR SCHEME 7
@ 10,11       TO 10,67
SEEK cTipMov
NumEle = 1
DO WHILE NumEle <= (10) .AND. (CodMov=cTipMov) .AND. ! EOF()
   Contenido= []
   DO Escbe WITH Contenido
   @ 10+NumEle, 12 SAY Contenido
   SKIP
   NumEle = NumEle + 1
ENDDO
RETURN
*****************
PROCEDURE xBrowse
*****************
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
*********************
UltTecla = 0
SelLin   = []
EdiLin   = "Edita"
EscLin   = "Escbe"
BrrLin   = []
InsLin   = []
GrbLin   = "Graba"
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
*E1       = " C¢d.  Descripci¢n                                       "
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .F.
BBVerti  = .T.
Static   = .F.
VSombra  = .T.
Yo       = 10
Xo       = 10
Largo    = 12
Ancho    = 59
TBorde   = Nulo
Set_Escape=.T.
NClave   = "CodMov"
VClave   = cTipMov
EscLin   = "Escbe"
DO LIB_MTEC WITH 14
DO dBrowse
RETURN
**************************************************************************
PROCEDURE Escbe
***************
PARAMETER Contenido
xLlave = XsCodPln+XsNroPer+PERS->CodPer
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
**************************************************************************
PROCEDURE Edita
******************
PRIVATE TlTitle , TnLargo ,TsFormat , TnXo , TlSigue
TsFormat = "####################"
IF RIGHT(CodMov,2)="00"
   UltTecla = Escape
   RETURN
ENDIF
xLlave = XsCodPln+XsNroPer+PERS->CodPer
=SEEK(xLLave+TMOV->CodMov,"DMOV")
XnValCal = DMOV->ValCal
XnValRef = DMOV->ValRef
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
**************************************************************************
PROCEDURE Graba
******************
SELE DMOV
xLlave = XsCodPln+XsNroPer+PERS->CodPer
SEEK xLLave+TMOV->CodMov
IF ! FOUND()
  APPEND BLANK
ENDIF
IF REC_Lock(5)
   REPLACE CodPln WITH  XsCodPln
   REPLACE NroPER WITH  XsNroPer
   REPLACE CodPER WITH  PERS->CodPer
   REPLACE CodMov WITH  TMOV->CodMov
   REPLACE ValRef WITH  XnValRef
   REPLACE ValCal WITH  XnValCal
   UNLOCK
ENDIF
SELE TMOV
DO LIB_MTEC WITH 14
RETURN
**************************************************************************
PROCEDURE KeyF5
***************
xFor   = []
xWhile = [EVALUATE(NClave)=Vclave]
SEEK VClave
sNomRep = "PLNDMOVT"
DO ADMPRINT WITH "REPORTS"
RETURN
