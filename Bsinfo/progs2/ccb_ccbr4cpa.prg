CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')

WAIT "Aperturando Sistema" NOWAIT WINDOW
DO fondo WITH 'Canjes pendientes de aprobar',Goentorno.user.login,GsNomCia,GsFecha

DO  GenReport

CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
DO close_file IN CCB_Ccbasign
RETURN 
********************
PROCEDURE GenReport
********************
LsDBC = 'CIA'+GsCodCia
SET DATABASE TO (LsDBC)
SELECT 0
USE ccbntasg  ORDER TASG03 ALIAS TASG
IF !USED()
   RETURN
ENDIF
**
SELECT 0
USE ccbmvtos ORDER VTOS01 ALIAS VTOS
IF !USED()
   RETURN
ENDIF
**
SELECT 0
USE ccbrgdoc  ORDER GDOC01 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
**
SELECT 0
USE ccbrrdoc  ORDER RDOC01 ALIAS RDOC
IF !USED()
   RETURN
ENDIF
**
SELECT 0
USE cbdmauxi ORDER AUXI01 ALIAS AUXI
IF !USED()
   RETURN
ENDIF
*
SELECT 0
USE ccbnrasg  ORDER RASG01 ALIAS RASG
IF !USED()
   RETURN
ENDIF
m.codref = [PROF]
m.CodDoc = [CANJ]
UltTecla = 0
DESDE = SPACE(LEN(VTOS.NroDoc))
HASTA = SPACE(LEN(VTOS.NroDoc))

@ 2,0 TO 20,79 PANEL
*@ 2,25  SAY "CANJES PENDIENTES DE APROBAR"
GsMsgKey = " [Enter] Aceptar [Esc] Salir "
DO LIB_MTEC WITH 99
XdFch1 = DATE()
XdFch2 = DATE()
XsTpoDoc = "CARGO"
XsCodDoc = "N/C "
XnAno    = YEAR(DATE())
XnMes    = MONTH(DATE())

@ 14,10 SAY "Fecha     Desde  :"    COLOR SCHEME 11
@ 15,10 SAY "Fecha     Hasta  :"    COLOR SCHEME 11
UltTecla = 0
i = 1
DO LIB_MTEC WITH 11
DO WHILE !INLIST(UltTecla,Escape_,CtrlW)
   DO CASE
      CASE i = 1
           @ 14,28 GET XdFch1  PICT "@RD mm/dd/aa" &&VALID MONTH(XdFch1)=XnMes AND YEAR(XdFch1)=XnAno
           @ 15,28 GET XdFch2  PICT "@RD mm/dd/aa" &&VALID MONTH(XdFch2)=XnMes AND YEAR(XdFch2)=XnAno
           READ
           UltTecla = LASTKEY()
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>1 ,1 ,i)
ENDDO
IF UltTecla = Escape_

   RETURN
ENDIF
*
SELE TASG
SEEK "CANJP"
IF !FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
** Archivo temporal **
ArcTmp = PathUser + SYS(3)
COPY STRU TO &ArcTmp
SELE 0
USE &ArcTmp ALIAS TEMPO EXCL
IF !USED()
   RETURN
ENDIF
INDEX ON Glosa2+NroDoc TAG TASG01
SET ORDER TO TASG01
*
SELE TASG
SCAN WHILE CODDOC+FlgEst="CANJP" FOR FchDoc<=XdFch2 AND FchDoc>=XdFch1
     vRegAct = RECNO()
     ZsNroDoc = []
     LsGloLet = []
     XsCodRef = CodRef
     XsNroRef = NroRef
     XsCodDoc = CodDoc
     XsNroDoc = NroDoc
     SCATTER MEMVAR
     SELE RASG
     SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc
          LsGloLet = LsGloLet+TRIM(NroRef)+","
     ENDSCAN
     SELE TEMPO
     APPEND BLANK
     GATHER MEMVAR
     =SEEK(GsClfAux+CodCli,"AUXI")
     REPLACE Glosa2 WITH AUXI.NomAux
     REPLACE Glosa1 WITH LsGloLet
     SELE TASG
     GO vRegAct
ENDSCAN
*
SELE TEMPO
LOCATE
xWHILE = []
xFOR   = []
** Impresion **
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
IniImp =_PRN4+_PRN8A
sNomREP = "Ccbr4cpa"
DO F0PRINT WITH "REPORTS"

RETURN
