**************************************************************************
*  Consulta y modificaci¢n de tablas
**************************************************************************
PARAMETER XsTabla,xDigitos
PRIVATE XsCodigo , XsNombre, nSelect, Titulo, nDigitos
PRIVATE nSelect, Xo, Yo, Largo, Ancho, LinReg, Key1, Key2
PRIVATE Desde,Hasta,LsNombre,Sorteo,Localiza
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "TABLAS DEL SISTEMA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
GsMsgKey = "[T.Cursor]Posic. [F2]Modif. [F5]Ubica [F6]Lista [Ins]Adic. [Del]Borra [Enter]Tomar [Esc]Canc."
DO Lib_MTEC with 99
SELECT 1
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELECT TABL
SET ORDER TO TABL01
XsCodigo = ""
DO TABLA WITH XsTabla,XsCodigo,xDigitos
CLOSE DATA
RETURN
