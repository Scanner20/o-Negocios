SYS(2700,0)
CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
STORE '' TO ArcTmp,ArcTmp1,ArcTmp2,ArcTmp3
DO fondo WITH 'Antiguedad de documentos',Goentorno.user.login,GsNomCia,GsFecha

DO SITLista
CLEAR 
CLEAR MACROS 
IF USED('CBDMAUXI')
	USE IN CBDMAUXI
ENDIF
IF USED('CCBRGDOC')
	USE IN CCBRGDOC
ENDIF
IF USED('TDOC')
	USE IN TDOC
ENDIF
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN

PROCEDURE SITLista
*******************

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CBDMAUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','CCBRGDOC','GDOC02','')
LODATADM.ABRIRTABLA('ABRIR','CCBTBDOC','TDOC','BDOC01','')
***
@ 2,0 TO 20,79 PANEL
@ 2,25  SAY "** ANTIGUEDAD DE DOCUMENTOS ***"
** variables a usar **

SELECT ccbrgdoc
SET FILTER TO TpoVta<>3
SET RELA TO gsclfcli+CodCli INTO cbdmauxi
xstpodoc='CARGO'
m.tpodoc  = "CARGO"
m.flgest  = "P"
m.codcli1 = SPACE(LEN(codcli))
m.codcli2 = SPACE(LEN(codcli))
m.codmon  = 2
m.tpocmb  = 0.00
M.CODDOC  =SPACE(4)
@  4,20 SAY "Documento      :"
@ 10,20 SAY "Del Cliente    :"
@ 12,20 SAY "Al  Cliente    :"
@ 14,20 SAY "Tipo de Moneda :"
@ 16,20 SAY "Tipo de Cambio :"
UltTecla = 0
do while ulttecla<>escape_
   SELECT TDOC
   @4,38  GET m.coddoc PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8
      IF !ccbbusca("TDOC")
         LOOP
      ENDIF
      m.CodDoc = CodDOC
      ulttecla=enter
   ENDIF
   @ 04,38 SAY m.CodDoc   PICTURE "@!"
   SEEK m.CodDoc
   IF ! FOUND() .AND.!EMPTY(M.CODDOC)
      WAIT "C¢digo de Documento no registrado" NOWAIT WINDOW
      LOOP
   ENDIF
   IF UltTecla = ENTER .OR. UltTecla =escape_
      EXIT
   ENDIF
enddo
IF LASTKEY() = 27
   RETURN
ENDIF
select ccbrgdoc
@ 10,38  GET m.codcli1 PICT "@!" valid _vlook(@m.codcli1,'CODAUX')
@ 12,38  GET m.codcli2 PICT "@!" valid _vlook(@m.codcli2,'codAUX')
@ 14,38  GET m.codmon  FUNCTION "*RH Soles;Dolares"
@ 16,38  GET m.tpocmb  PICT "99,999.999" VALID m.tpocmb>0
READ
IF LASTKEY() = 27
   RETURN
ENDIF
** test de impresion **

XFOR1 = "ccbrgdoc.flgest=m.flgest .AND. ccbrgdoc.tpodoc=m.tpodoc"
XFOR2 = ".T."
IF !EMPTY(M.CODDOC)
    XFOR3='CODDOC=M.CODDOC'
ELSE
    XFOR3='.T.'
ENDIF
XFOR = XFOR1 + ".AND." + XFOR2+".AND."+XFOR3
m.codcli1 = ALLTRIM(m.codcli1)
m.codcli2 = ALLTRIM(m.codcli2)+CHR(255)
IF TRIM(m.codcli1) == []
   GO TOP
   m.codcli1 = codcli
ELSE
   SEEK m.codcli1
   IF !FOUND()
      IF RECNO(0) > 0 .AND. RECNO(0)<=RECCOUNT()
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
         m.codcli1 = codcli
      ENDIF
   ELSE
      m.codcli1 = codcli
   ENDIF
ENDIF
XWHILE = "codcli<=m.codcli2"
** buscamos registro de arranque **
SEEK m.codcli1
IF !FOUND()
   WAIT "Fin de Archivo, presione barra espaciadora para continuar .." WINDOW
   RETURN
ENDIF
m.titulo = []
m.titulo = "Importe Expresado en "+IIF(m.codmon=1,'Soles','Dolares')+" al tipo de cambio de : "+TRANS(m.tpocmb,'99,999.9999')
m.subtit = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "ccbr4400"
DO F0print WITH "REPORTS"
RETURN


FUNCTION _valreal
*****************
PARAMETER Lfposi
* Valores de Lfposi
*            Lfposi=1  Menor a 90 dias
*            Lfposi=2  entre -90 a -60 dias
*            Lfposi=3  entre -60 a -30 dias
*            Lfposi=4  entre -30 a  00 dias
*            Lfposi=5  entre  00 a +30 dias
*            Lfposi=6  entre +30 a +60 dias
*            Lfposi=7  entre +60 a +90 dias
*            Lfposi=8  Mayor a 90 dias
IF m.codmon=ccbrgdoc.codmon
   LfImport=ccbrgdoc.sdodoc
ELSE
   IF ccbrgdoc.codmon=2
      LfImport=ccbrgdoc.sdodoc*m.tpocmb
   ELSE
      LfImport=ccbrgdoc.sdodoc/m.tpocmb
   ENDIF
ENDIF
DO CASE
   CASE Lfposi = 1
      IF DATE()-ccbrgdoc.fchvto>90
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 2
      IF DATE()-ccbrgdoc.fchvto<=90.AND.DATE()-ccbrgdoc.fchvto>60
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 3
      IF DATE()-ccbrgdoc.fchvto<=60.AND.DATE()-ccbrgdoc.fchvto>30
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 4
      IF DATE()-ccbrgdoc.fchvto<=30.AND.DATE()-ccbrgdoc.fchvto>=0
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 5
      IF DATE()-ccbrgdoc.fchvto<0.AND.DATE()-ccbrgdoc.fchvto>-30
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 6
      IF DATE()-ccbrgdoc.fchvto<=-30.AND.DATE()-ccbrgdoc.fchvto>-60
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 7
      IF DATE()-ccbrgdoc.fchvto<=-60.AND.DATE()-ccbrgdoc.fchvto>-90
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
   CASE Lfposi = 8
      IF DATE()-ccbrgdoc.fchvto<=-90
         RETURN LfImport
      ELSE
         RETURN 0
      ENDIF
ENDCASE
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select cbdmauxi
   IF ! ccbbusca("CLIE")
      SELECT ccbrgdoc
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla=Enter
   SELECT ccbrgdoc
ENDIF
IF INLIST(UltTecla,escape_,ENTER)
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(VAR1,"cbdmauxi")
   RETURN .F.
ENDIF
RETURN .T.
