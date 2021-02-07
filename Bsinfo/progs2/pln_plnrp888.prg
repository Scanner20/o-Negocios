DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp888

*******************
PROCEDURE xPlnrp888
*******************
Dimension AsCodigo(20)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "HABERES FIJOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
*********apertura de archivos************
SELE 5
DO CASE
   CASE XsCodPln='1'
      USE PLNBLPG1 ORDER BPGO01 ALIAS BPGO
   CASE XsCodPln='2'
      USE PLNBLPG2 ORDER BPGO01 ALIAS BPGO
   CASE XsCodPln='4'
      USE PLNBLPG3 ORDER BPGO01 ALIAS BPGO
ENDCASE
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF

SELE 4
USE PLNMTABL ORDER TABL01 ALIAS TABL
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
*******

IF XsCodPln = "1"
   SELECT 3
   USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "2"
   SELECT 3
   USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "4"
   SELECT 3
   USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
ENDIF

IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
*******
SELE 1
USE PLNMPERS ORDER PERS14 ALIAS PERS
SET FILTER TO CODPLN=XSCODPLN .AND. NPLAZA $ "01,02,03,04,05,06,07,08,09,10"
GO TOP
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
XSCODMOV="BA01"
*******
SELECT PERS
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3+_PRN8B]
xWhile = []
XFor   = [VALCAL("@SIT")<5 .AND. VALCAL(XSCODMOV)<>0 ]
sNomREP = "plnrp888"
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN
