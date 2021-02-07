**************************************************************************
*  Consulta y modificaci¢n de tablas
**************************************************************************
PARAMETER XsTabla,xDigitos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [TABLAS DEL SISTEMA]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
GsMsgKey = "[T.Cursor]Posic. [F2]Modif. [F5]Ubica [F6]Lista [Ins]Adic. [Del]Borra [Enter]Tomar [Esc]Canc."
DO Lib_MTEC WITH 99
CLOSE DATA
SELECT 1
USE ALMTABLA ORDER TABL01 ALIAS TABL
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
*********************************************************************** EOP() *
