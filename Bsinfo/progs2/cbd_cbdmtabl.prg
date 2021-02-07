do form cbd_cbdmtabl
RETURN
**************************************************************************
*  Consulta y modificaci¢n de tablas
**************************************************************************
PARAMETER XsTabla,xDigitos
PRIVATE XsCodigo , XsNombre, nSelect, Titulo, nDigitos
PRIVATE nSelect, Xo, Yo, Largo, Ancho, LinReg, Key1, Key2
PRIVATE Desde,Hasta,LsNombre,Sorteo,Localiza

CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "TABLAS DEL SISTEMA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
GsMsgKey = "[T.Cursor]Posic. [F2]Modif. [F5]Ubica [F6]Lista [Ins]Adic. [Del]Borra [Enter]Tomar [Esc]Canc."
DO Lib_MTEC with 99
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')

lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
RELEASE LoDatAdm
IF !lreturnok
	=MESSAGEBOX('No hay acceso a la tabla CBDMTABL',16,'Error de acceso')
	RETURN 
ENDIF

SELECT TABL
SET ORDER TO TABL01
XsCodigo = ""
DO TABLA WITH XsTabla,XsCodigo,xDigitos
*CLOSE DATA
IF USED('TABL')
	USE IN TABL
ENDIF

IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
CLEAR
CLEAR MACROS
RETURN
