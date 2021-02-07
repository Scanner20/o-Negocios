**************************************************************************
*  Nombre    : CcbConst.PRG                                              *
*  Objeto    : Consultas de Cuentas Corrientes por Cobrar                *
*  Autor	 :	VETT 													 *	
*  Par metros: Ninguno                                                   *
*  Creaci¢n     : 04/02/93                                               *
*  Actualizaci¢n:   /  /                                                 *
*				  VETT 02/09/2003 Adaptacion para VFP 7					 *
**************************************************************************
DO def_teclas IN fxgen_2
SYS(2700,0)
CLEAR
DO fondo  WITH 'Consulta de saldos por cliente',Goentorno.user.login,'Titulo2','titulo3'
DO consulta 
CLEAR MACROS 
CLEAR
DO close_file IN CCB_Ccbasign
IF WVISIBLE('__WFondo')
	HIDE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN

PROCEDURE CONSULTA
*******************


SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNTASG','TASG','TASG02','')
RELEASE LoDatAdm
** Relaciones a usar **
SELECT CLIE
SET RELATION TO CodAux INTO SLDO
XsNomCli=space(len(clie.codaux))
** Vector de Acumulacion de Cuentas ***********
XlBusco  = .F.
Sorteo   = 1
GsMsgKey  = "[T.Cursor]Buscar [Enter]Aceptar [Esc]Salir [F5]Selecciona [F2]Localiza  [F3]Siguiente [F9]Recalculo"
DO LIB_MTEC WITH 99
@ 18,0 TO 23,79 PANEL
@ 18,29 SAY " ** SALDOS ACTUALES ** "
@ 19,6 SAY "Cargos         :  S/.                          US$                  "
@ 20,6 SAY "Bonificaciones :  S/.                          US$                  "
@ 21,6 SAY "                       ----------------             ----------------"
@ 22,6 SAY "Saldo Neto     :  S/.                          US$                  "
****** Pintado de pantalla ****

UltTecla = 0
DO WHILE UltTecla <> escape_
   Key1    = GsClfCli
   Key2    = GsClfCli
   LnNomAux=60
   Titulo    = "C¢digo      Nombre/Razon Social"
   LinReg    = [CodAux+" "+LEFT(NomAux,LnNomAux)]
             **12345678901 1234567890123456789012345678901234567890
             
   Ancho   = LEN( &LinReg ) + 2
   Xo      = INT((80-Ancho)/2)
   PUSH KEY CLEAR
   ON KEY LABEL F2  DO xF2CLIE
   ON KEY LABEL F3  DO xF3CLIE
   ON KEY LABEL F5  DO xF5CLIE
   ON KEY LABEL F9  DO CstMovF9
   DO Busca WITH "Saldos",Key1,Key2,LinReg,Titulo,0,Xo,17,Ancho,""
   POP KEY
   UltTecla = LastKey()
   IF UltTecla = Enter
      DO CstMovmt
      UltTecla = 0
   ENDIF
ENDDO
RETURN
*******************************************************************************
* Complemento muestra los resultados de la cuenta
*******************************************************************************
PROCEDURE SALDOS
****************

@ 19,28 SAY Sldo->CgoNac  PICT "9,999,999,999.99"
@ 19,57 SAY Sldo->CgoUsa  PICT "9,999,999,999.99"

@ 20,28 SAY Sldo->AbnNac  PICT "9,999,999,999.99"
@ 20,57 SAY Sldo->AbnUsa  PICT "9,999,999,999.99"

LfTotNac = Sldo->CgoNac - Sldo->AbnNac
LfTotUsa = Sldo->CgoUsa - Sldo->AbnUsa

@ 22,28 SAY LfTotNac      PICT "9,999,999,999.99"
@ 22,57 SAY LfTotUsa      PICT "9,999,999,999.99"


RETURN
*******************************************************************************
PROCEDURE XF5CLIE
*****************
PUSH KEY CLEAR
SAVE SCREEN
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
*@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre;Cellular"
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
IF LASTKEY() = 27
   RETURN
ENDIF
DO CASE
   CASE Sorteo = 1
     SET ORDER TO AUXI01
     STORE SPACE(LEN(CodAux)) TO Desde,Hasta
   CASE Sorteo = 2
     SET ORDER TO AUXI02
     STORE SPACE(LEN(NomAux)) TO Desde,Hasta
  *CASE Sorteo = 3
  *  SET ORDER TO CLIE03
  *  STORE SPACE(LEN(CelLular)) TO Desde,Hasta
ENDCASE
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
READ
Ciclo = .F.
Key1   = GsClfCli+TRIM(Desde)
Key2   = GsClfCli+TRIM(Hasta)
POP KEY
RESTORE SCREEN
RETURN

*****************
PROCEDURE XF2CLIE
*****************
SAVE SCREEN
@ 10,19 CLEAR TO 13,63
@ 10,19 TO 13,63 DouBLE
XsNomCli = SPACE(LEN(NomAux))
@ 11,20 SAY "Nombre > " GET XsNomCli PICT "@!S30"
READ
IF UPDATE()
   XsNomCli = TRIM(XsNomCli)
   WAIT "Buscando .. " NOWAIT WINDOW
   LOCATE      FOR NomAux=XsNomCli
   XlBusco = ! EOF()
   Leereg  = FOUND()
ENDIF
RESTORE SCREEN

*****************
PROCEDURE XF3CLIE
*****************
IF XlBusco
   WAIT "Buscando .. " NOWAIT WINDOW
   CONTINUE
   XlBusco = FOUND()
   Leereg  = FOUND()
ENDIF

*******************************************************************************
* Muestra el Movimiento de Documentos por Auxiliar
*******************************************************************************
PROCEDURE CstMovmt
*******************
SAVE SCREEN TO sConsulta
IF FILE("CCBTASAD.MEM")
   RESTORE FROM CCBTASAD ADDITIVE
ENDIF
XsCodCli = CLIE->CodAux
CLEAR
@ 0,0 SAY CodAux+' '+NomAux
@ 01,6 SAY "Cargos         :  S/.                          US$                  "
@ 02,6 SAY "Bonificaciones :  S/.                          US$                  "
@ 03,6 SAY "                       ----------------             ----------------"
@ 04,6 SAY "Saldo Neto     :  S/.                          US$                  "
@ 01,28 SAY Sldo->CgoNac  PICT "9,999,999,999.99"
@ 01,57 SAY Sldo->CgoUsa  PICT "9,999,999,999.99"

@ 02,28 SAY Sldo->AbnNac  PICT "9,999,999,999.99"
@ 02,57 SAY Sldo->AbnUsa  PICT "9,999,999,999.99"

LfTotNac = Sldo->CgoNac - Sldo->AbnNac
LfTotUsa = Sldo->CgoUsa - Sldo->AbnUsa

@ 04,28 SAY LfTotNac      PICT "9,999,999,999.99"
@ 04,57 SAY LfTotUsa      PICT "9,999,999,999.99"
@ 5,0 TO 5,79
@ 5,60 SAY date()
@ 0,0 FILL TO 5,79 COLOR SCHEME 7

SELECT GDOC
SET ORDER TO GDOC04
SEEK  XsCodCli+'P'+'CARGO'
XlF2  = FOUND()
SEEK  XsCodCli+'C'+'CARGO'
XlF3  = FOUND()
SEEK  XsCodCli+'P'+"ABONO"
XlF5  = FOUND()
SELECT TASG
SEEK  XsCodCli+"NEGO"
XlF7  = FOUND()
** Recalculo
XlF9  = .F.
**
NClave = "CodCli+FlgEst+TpoDoc"
VClave = XsCodCli+'P'+'CARGO'
@ 24,24 SAY 'Mover'
@ 24,35 SAY IIF(XlF2,"Pen.",[])
@ 24,43 SAY IIF(XlF3,"Can.",[])
@ 24,59 SAY IIF(XlF5,"Bonf.",[])
@ 24,65 SAY IIF(XlF7,"Nego.",[])
@ 24,72 SAY IIF(XlF9,"Recalc.",[])
@ 24 , 1 SAY ""                COLOR SCHEME 7
@ 24 , 3 SAY ""                COLOR SCHEME 7
@ 24 , 5 SAY [PgUp]             COLOR SCHEME 7
@ 24 ,10 SAY [PgDn]             COLOR SCHEME 7
@ 24 ,15 SAY [Home]             COLOR SCHEME 7
@ 24 ,20 SAY [End]              COLOR SCHEME 7
@ 24 ,32 SAY IIF(XlF2,[F2],"")  COLOR SCHEME 7
@ 24 ,40 SAY IIF(XlF3,[F3],"")  COLOR SCHEME 7
*@ 24 ,48 SAY IIF(XlF4,[F4],"")  COLOR SCHEME 7
@ 24 ,56 SAY IIF(XlF5,[F5],"")  COLOR SCHEME 7
*@ 24 ,65 SAY IIF(XlF6,[F6],"")  COLOR SCHEME 7
@ 24 ,65 SAY IIF(XlF7,[F7],"")  COLOR SCHEME 7
@ 24 ,72 SAY IIF(XlF9,[F9],"")  COLOR SCHEME 7
Titulo = ""
SelLin   = ""
EdiLin   = ""
BrrLin   = ""
InsLin   = ""
EscLin   = ""
GrbLin   = ""
PrgFin   = []
MVprgF1  = []
MVprgF2  = IIF(XlF2,"CstMovF2","")
MVprgF3  = IIF(XlF3,"CstMovF3","")
*MVprgF4  = IIF(XlF4,"CstMovF4","")
MVprgF4  = []
MVprgF5  = IIF(XlF5,"CstMovF5","")
*MVprgF6  = IIF(XlF6,"CstMovF6","")
MVprgF6  = []
MVprgF7  = IIF(XlF7,"CstMovF7","")
MVprgF8  = []
MVprgF9  = IIF(XlF9,"CstMovF9","")
Set_escape= .T.
HTitle   = 1
Yo       = 7
Xo       = 0
Largo    = 17
Ancho    = 85
TBorde   = Simple
E1       = " Tpo. No.              S   Fecha    Fecha   Dia         Importe del      Saldo     "
E2       = " Doc. Docum.           T    Doc.     Vto.  Atr.  Mon    Documento       Actual     "
E3       = []


*         1         2         3         4         5         6         7         8
*12345678901234567890123456789012345678901234567890123456789012345678901234567890
* Tpo. No.        S   Fecha    Fecha   Dia         Importe del      Saldo      "
* Doc. Docum.     T    Doc.     Vto.   Atr.  Mon    Documento       Actual     "
* 1234 1234567890 1 99/99/99 99/99/99 (1234) S/. 999,999,999.99 999,999,999.99
*

LinReg = [CodDoc+' '+NroDoc+' '+FlgSit+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+;
TRANS(DATE()-FchVto,'@( 9999')+' '+;
IIF(CodMon=2,'US$','S/.')+' '+TRANSF(ImpTot,'99,999,999.99')+' '+;
TRANSF(SdoDoc,'99999,999.99')+' ']
BBVerti  = .T.
Static   = .F.
VSombra  = .F.
Consulta = .T.
Modifica = .F.
Adiciona = .F.
SELECT GDOC
SET ORDER TO GDOC04
DO dBrowse
SELECT CLIE
RESTORE SCREEN FROM sConsulta
RETURN

*******************************************************************************
* Cuentas Pendientes
*******************************************************************************
PROCEDURE CstMovF2
*******************
SELECT GDOC

@ Yo-3,Xo+1 SAY "   Cuentas Pendientes   "
@ Yo-2,Xo+1 SAY " Tpo. No.         xx   S   Fecha    Fecha  Dia         Importe del      Saldo      " COLOR SCHEME 7
@ Yo-1,Xo+1 SAY " Doc. Docum.           T    Doc.     Vto.  Atr.  Mon    Documento       Actual     " COLOR SCHEME 7
*
NClave = "CodCli+FlgEst+TpoDoc"
VClave = XsCodCli+'P'+'CARGO'
LinReg = [CodDoc+' '+NroDoc+' '+IIF(FlgSit='D',CODBCO,'...')+' '+FlgSit+' '+DTOC(FchDoc)+' '+DTOC(FchVto)+' '+;
TRANS(DATE()-FchVto,'@( 9999')+' '+;
IIF(CodMon=2,'US$','S/.')+' '+TRANSF(ImpTot,'9999,999.99')+' '+;
TRANSF(SdoDoc,'9999,999.99')+' ']
FIN = .T.
RETURN

*******************************************************************************
* Cuentas Canceladas
*******************************************************************************
PROCEDURE CstMovF3
*******************
SELECT GDOC
SET ORDER TO GDOC04
@ Yo-3,Xo+1 SAY "   Cuentas Canceladas   "
@ Yo-2,Xo+1 SAY " Tpo. No.             S   Fecha    Fecha               Importe del      Saldo      "  COLOR SCHEME 7
@ Yo-1,Xo+1 SAY " Doc. Docum.          T   Emis.     Vto.         Mon    Documento       Actual     "  COLOR SCHEME 7
**
NClave = "CodCli+FlgEst+TpoDoc"
VClave = XsCodCli+'C'+'CARGO'
LinReg = [CodDoc+' '+NroDoc+' '+FlgSit+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+;
SPACE(6)+' '+;
IIF(CodMon=2,'US$','S/.')+' '+TRANSF(ImpTot,'99,999,999.99')+' '+;
TRANSF(SdoDoc,'99999,999.99')+' ']
FIN = .T.
RETURN
*******************************************************************************
* Notas de Abono
*****************************************************************************
PROCEDURE CstMovF5
*******************
SELECT GDOC
SET ORDER TO GDOC04
@ Yo-3,Xo+1 SAY "     Bonificaciones     "
@ Yo-2,Xo+1 SAY " Tpo. No.             S   Fecha    Fecha               Importe del      Saldo      "  COLOR SCHEME 7
@ Yo-1,Xo+1 SAY " Doc. Docum.          T   Emis.     Vto.         Mon    Documento       Actual     "  COLOR SCHEME 7
**
NClave = "CodCli+FlgEst+TpoDoc"
VClave = XsCodcLI+"PABONO"
LinReg = [CodDoc+' '+NroDoc+' '+FlgSit+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+;
SPACE(6)+' '+;
IIF(CodMon=2,'US$','S/.')+' '+TRANSF(ImpTot,'99,999,999.99')+' '+;
TRANSF(SdoDoc,'99999,999.99')+' ']
FIN = .T.
RETURN
*******************************************************************************
* Negociaciones Realizadas
*******************************************************************************
PROCEDURE CstMovF7
*******************

SELECT ccbntasg
@ Yo-3,Xo+1 SAY "Negociaciones Realizadas"   COLOR SCHEME 7
@ Yo-2,Xo+1 SAY " No.             Fecha                                                   Importe   " COLOR SCHEME 7
@ Yo-1,Xo+1 SAY " Docum.           Doc.                                                    Docum.   " COLOR SCHEME 7

*12345678901234567890123456789012345678901234567890123456789012345678901234567890
* No.        Fecha                                                   Importe   "
* Docum.      Doc.                                                    Docum.   "
* 12345678901 99/99/99                                        S/.999,999,999.99
*                     1234567890123456789012345678901234567890

NClave = "CodCli+CodDoc"
VClave = XsCodCli+'NEGO'
LinReg = [NroDoc+' '+DTOC(FchDoc)+SPACE(40)+IIF(CodMon=2,'US$','S/.')+;
TRANSF(ImpDoc,'999,999,999.99)]
FIN = .T.
RETURN
******************
PROCEDURE CstMovF9
******************
xSelect=SELECT() 
XsCodCli= PADR(CLIE.CodAux,LEN(SLDO.CodCli))
NClave = "CodCli+FlgEst"
VClave = XsCodCli+'P'
STORE 0 TO LfCgoNac,LfCgoUsa,LfAbnNac,LfAbnUsa
RegVal   = "&NClave = VClave"
SELECT GDOC
SET ORDER TO GDOC04
SEEK vClave
SCAN WHILE  &RegVal.
     IF FlgEst = "T"
        && en tramite no afectamos el saldo
     ELSE
        IF TpoDoc="CARGO"
           LfCgoNac = LfCgoNac + IIF(GDOC.CodMon=1,SdoDoc,0)
           LfCgoUsa = LfCgoUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
        ELSE
           LfAbnNac = LfAbnNac + IIF(GDOC.CodMon=1,SdoDoc,0)
           LfAbnUsa = LfAbnUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
        ENDIF
	 ENDIF      
ENDSCAN
IF RLOCK('SLDO')
	REPLACE  Sldo.CgoNac  WITH LfCgoNac IN SLDO
	REPLACE  Sldo.CgoUsa  WITH LfCgoUsa IN SLDO

	REPLACE  Sldo.AbnNac  WITH LfAbnNac IN SLDO
	REPLACE  Sldo.AbnUsa  WITH LfAbnUsa IN SLDO
	UNLOCK IN SLDO
	FLUSH IN SLDO
ENDIF
SELECT (xSelect)
******************


