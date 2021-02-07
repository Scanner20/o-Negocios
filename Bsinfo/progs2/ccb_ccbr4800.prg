*------------------------------------------------------------------------------
* CCBR4800 : CONSOLIDADO DE CUENTA CORRIENTE DE CLIENTES
*
*          : Eduardo Tapia Castillo
* FECHA    : 1-JULIO-1994
* Actualizacion : RHC 01/03/95
* Actualizacion : VETT opci¢n de tomar o no las letras en descuento
*------------------------------------------------------------------------------
SYS(2700,0)
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

STORE '' TO Arch, Arch1,Arch2,Arch3
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
Arch = LoDatAdm.oentorno.TmpPath+SYS(3)
WAIT "Aperturando Sistema" NOWAIT WINDOW

IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('AUXI1')
	USE IN AUXI1
ENDIF
DO fondo WITH 'Consolidado cuenta corriente por cliente',Goentorno.user.login,GsNomCia,GsFecha
DO PENLista

IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('AUXI1')
	USE IN AUXI1
ENDIF

IF USED('TDOC')
	USE IN TDOC
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
DELETE FILE &arch.+'.Dbf'
DELETE FILE &arch.+'.idx'
DELETE FILE &arch1.+'.idx'

CLEAR
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN

PROCEDURE PENLista
*******************
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC02','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')

Arch1 = LoDatAdm.oentorno.TmpPath+SYS(3)

RELEASE LoDatAdm
***
Titulo = [ ** CONSOLIDADO CUENTA CORRIENTE POR CLIENTE ** ]
@ 2,0 TO 20,79 PANEL
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
** variables a usar **
m.codcli1 = SPACE(LEN(codcli))
m.codcli2 = SPACE(LEN(codcli))
m.fchdoc  = DATE()
XiNeto    = 1
XnCodMon  = 1
nTipCam  = 0.00
XsClfAux=GsClfCli
** pantalla de datos **

@ 08,10 SAY "Del Cliente       :"       COLOR SCHEME 11
@ 10,10 SAY " Al Cliente       :"       COLOR SCHEME 11
@ 12,10 SAY " Al Dia           :"       COLOR SCHEME 11
@ 14,10 SAY " Neto de Descuento:"       COLOR SCHEME 11
@ 16,10 SAY " Moneda           :"       COLOR SCHEME 11
*@ 18,10 SAY " T.de Cambio      :"       COLOR SCHEME 11

@23,00
GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar [F10] Genera reporte"
DO LIB_MTEC WITH 99

@ 08,32 GET m.codcli1 PICT "@!" VALID _vLook(@m.CodCli1,"CODAUX")
@ 10,32 GET m.codcli2 PICT "@!" VALID _vLook(@m.CodCli2,"CODAUX")
@ 12,32 GET m.fchdoc
@ 14,32 GET XiNeto    FUNCTION "*RH Si;No"    COLOR SCHEME 7
@ 16,32 GET XnCodMon  FUNCTION "*RH NUEVO SOL;DOLAR AMERICANO" COLOR SCHEME 8
*@ 18,32 GET nTipCam   PICT "9,999.99"
READ
VecOpc(1) = "NUEVO SOL"
VecOpc(2) = "DOLAR AMERICANO"
IF LASTKEY() = 27
   RETURN
ENDIF
** test de impresion **
IF XiNeto=1
   XFOR1 = [IIF(CodDoc="LETR",FlgUbc+FlgSit="BD",.T.)]
ELSE
   XFOR1 = [.T.]
ENDIF
XFOR = "FchDoc<=m.fchdoc .AND. !FlgEst$'TA'"+".AND."+XFOR1
*XFOR = "FchDoc<=m.fchdoc .AND. !(FlgEst=[A].AND.ImpTot=0)"
m.codcli1 = ALLTRIM(m.codcli1)
m.codcli2 = ALLTRIM(m.codcli2)+CHR(255)
XWHILE = "m.codcli2>=CodCli"
** buscamos registro de arranque **
SELE GDOC
SET FILTER TO tpovta<>3
IF EMPTY(m.codcli1)
	LOCATE
ELSE
   SEEK m.codcli1
   IF !FOUND()
      IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF EOF()
   WAIT "Fin de Archivo, presione barra espaciadora para continuar .." WINDOW
   RETURN
ENDIF
** Generamos Base de trabajo **


SELE 0
CREATE TABLE &Arch. FREE (CodCli C(LEN(GDOC.CodCli)),;
                     Orden C(1) , CodDoc C(LEN(GDOC.CodDoc)),;
                     Imp00_00   N(14,2), Imp30_60   N(14,2), ;
                     Imp60_90   N(14,2), Imp90_120  N(14,2), ;
                     Imp120_180 N(14,2), Imp180_360 N(14,2), ;
                     Imp360_360 N(14,2) )

USE &Arch. ALIAS AUXI EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON CodCli+Orden+CodDoc TO &Arch.
INDEX ON Orden+CodDoc        TO &Arch1.
SET INDEX TO &Arch.,&Arch1.
** logica principal **
SELE GDOC
SCAN WHILE &XWHILE. FOR &XFOR.
   WAIT [Procesando Cliente ]+CodCli+[ ]+CodDoc+[ ]+NroDoc WINDOW NOWAIT
   XfTpoCmb = TpoCmb
   m.CodCli = CodCli
   m.TpoRef = TpoDoc
   m.CodRef = CodDoc
   m.NroRef = NroDoc
   m.SdoDoc = ImpTot    && Saldo Original
   m.CodMon = CodMon
   m.Orden  = IIF(TpoDoc=[CARGO],[1],[2])
   m.Dias   = m.FchDoc - FchVto
   ** buscamos documentos de cancelaci¢n **
   IF m.TpoRef = [CARGO]
      SELE VTOS
      SET ORDER TO VTOS03
      SEEK m.CodRef+m.NroRef
      SCAN WHILE CodRef+NroRef=m.CodRef+m.NroRef FOR FchDoc<=m.FchDoc
         IF CodMon = m.CodMon
            m.SdoDoc = m.SdoDoc - Import
         ELSE
            IF m.CodMon = 1
              *m.SdoDoc = m.SdoDoc - ROUND(Import*nTipCam,2)
               m.SdoDoc = m.SdoDoc - ROUND(Import*TpoCmb,2)
            ELSE
              *m.SdoDoc = m.SdoDoc - ROUND(Import/nTipCam,2)
               m.SdoDoc = m.SdoDoc - ROUND(Import/TpoCmb,2)
            ENDIF
         ENDIF
      ENDSCAN
   ELSE
      SELE VTOS
      SET ORDER TO VTOS01
      SEEK m.CodRef+m.NroRef
      SCAN WHILE CodDoc+NroDoc=m.CodRef+m.NroRef FOR FchDoc<=m.FchDoc
         IF CodMon = m.CodMon
            m.SdoDoc = m.SdoDoc - Import
         ELSE
            IF m.CodMon = 1
              *m.SdoDoc = m.SdoDoc - ROUND(Import*nTipCam,2)
               m.SdoDoc = m.SdoDoc - ROUND(Import*TpoCmb,2)
            ELSE
              *m.SdoDoc = m.SdoDoc - ROUND(Import/nTipCam,2)
               m.SdoDoc = m.SdoDoc - ROUND(Import/TpoCmb,2)
            ENDIF
         ENDIF
      ENDSCAN
   ENDIF
   m.SdoDoc = IIF(ABS(m.SdoDoc)<=0.01,0,m.SdoDoc)
   IF m.CodMon # XnCodMon
      IF XnCodMon = 1
         m.SdoDoc = ROUND(m.SdoDoc*XfTpoCmb,2)
      ELSE
         m.SdoDoc = ROUND(m.SdoDoc/XfTpoCmb,2)
      ENDIF
   ENDIF
   IF m.SdoDoc > 0
      SELE AUXI
      SEEK m.CodCli+m.Orden+m.CodRef
      IF !FOUND()
         APPEND BLANK
         REPLACE CodCli WITH GDOC.CodCli
         REPLACE Orden  WITH m.Orden
         REPLACE CodDoc WITH GDOC.CodDoc
      ENDIF
      m.SdoDoc = IIF(m.Orden=[1],m.SdoDoc,-1*m.SdoDoc)
      DO CASE
         CASE m.Dias <= 30
            REPLACE Imp00_00 WITH Imp00_00 + m.SdoDoc
         CASE m.Dias > 30 .AND. m.Dias <= 60
            REPLACE Imp30_60 WITH Imp30_60 + m.SdoDoc
         CASE m.Dias > 60 .AND. m.Dias <= 90
            REPLACE Imp60_90 WITH Imp60_90 + m.SdoDoc
         CASE m.Dias > 90  .AND. m.Dias <= 120
            REPLACE Imp90_120 WITH Imp90_120 + m.SdoDoc
         CASE m.Dias > 120 .AND. m.Dias <= 180
            REPLACE Imp120_180 WITH Imp120_180 + m.SdoDoc
         CASE m.Dias > 180 .AND. m.Dias <= 360
            REPLACE Imp180_360 WITH Imp180_360 + m.SdoDoc
         CASE m.Dias > 360
            REPLACE Imp360_360 WITH Imp360_360 + m.SdoDoc
      ENDCASE
   ENDIF
   SELE GDOC
ENDSCAN
* Acumulamos totales en archivo auxiliar *
 
SELE AUXI
SET ORDER TO 2
TOTAL TO &Arch1. ON Orden+CodDoc
SELE 0
USE &Arch1. ALIAS AUXI1 EXCLU
IF !USED()
   RETURN
ENDIF
SELE AUXI
SET ORDER TO 1
WAIT [Fin del Proceso] WINDOW NOWAIT
GO TOP
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO lib_merr WITH 99
   RETURN
ENDIF
sNomRep = "ccbr4800"
NumLin=1
IF XnCodMon=1
   XnExp='EXPRESADO EN NUEVOS SOLES'
ELSE
   XnExp='EXPRESADO EN DOLARES AMERICANOS'
ENDIF
*  Impresion ---------------------------------------------------------------------------
DO F0PRINT
IF LASTKEY() = Escape_
   RETURN
ENDIF
Ancho    = 198
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
LinFin = Largo - 8
IniImp =_PRN3
Tit_SIzq = GsNomCia
Tit_IIzq = sNomRep
Tit_SDer =''
Tit_IDer =''
Titulo   = "CONSOLIDADO DEL SALDO DE LA CUENTA CORRIENTE DE CLIENTES AL "+DTOC(m.FchDoc)
SubTitulo= XnExp
En1    = SPACE(ANCHO-14)+"FECHA :"+DTOC(DATE())
En2    = SPACE(ANCHO-15)+"HORA  :"+LEFT(TIME(),5)
En3    = IIF(XiNeto = 1,[NETO DE DESCUENTO],[])
En4    = []
En5    = "<Tipo de Cambio"+TRANS(nTipCam,'9,999.99')
En6    ='******************************************************* *****  **************** **************** **************** **************** **************** **************** **************** ****************'
En7    ='<    * Saldo por Tipo de Dcmto y Vencimiento *'
En8    ='               CLIENTE  DESCRIPCION                     DCMTO      EN PLAZO          31 - A - 60      61 - A - 90     91 - A - 120    121 - A - 180    181 - A - 360    360 - A -  +       T O T A L  '
En9    ='******************************************************* *****  **************** **************** **************** **************** **************** **************** **************** ****************'


*          1         2         3         4         5         6         7         8         9        100       110       120       130       140       150       160       170       180       190       200
*012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
******************************************************** *****  **************** **************** **************** **************** **************** **************** **************** ****************'
*<    * Saldo por Tipo de Dcmto y Vencimiento *'
*               CLIENTE  DESCRIPCION                     DCMTO      EN PLAZO          31 - A - 60      61 - A - 90     91 - A - 120    121 - A - 180    181 - A - 360    360 - A -  +       T O T A L  '
******************************************************** *****  **************** **************** **************** **************** **************** **************** **************** ****************'
*                                                        1234   9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99
*

*
SET DEVICE TO PRINT
PRINTJOB
   SELE AUXI
   GO TOP
   NumPag   = 0
   STORE 0 TO Tf00_00,Tf30_60,Tf60_90,Tf90_120,Tf120_180,Tf180_360,Tf360_360
   DO WHILE !EOF()
      IF PROW() > LinFin .OR. NumPag = 0
         DO ResetPag
      ENDIF
      * Quebramos por cliente *
      XsCodCli = CodCli
      @ PROW()+1,2 SAY XsCodCli
      =SEEK(XsClfAux+XsCodCli,'CLIE')
      @ PROW(),15 SAY CLIE->NomAux PICT "@S34"
      STORE 0 TO Xf00_00,Xf30_60,Xf60_90,Xf90_120,Xf120_180,Xf180_360,Xf360_360
      DO WHILE !EOF() .AND. CodCli=XsCodCli
         IF PROW() > LinFin .OR. NumPag = 0
            DO ResetPag
         ENDIF
         @ PROW(),056 SAY CodDoc
         @ PROW(),063 SAY Imp00_00    PICT '9,999,999,999.99'
         @ PROW(),080 SAY Imp30_60    PICT '9,999,999,999.99'
         @ PROW(),097 SAY Imp60_90    PICT '9,999,999,999.99'
         @ PROW(),114 SAY Imp90_120   PICT '9,999,999,999.99'
         @ PROW(),131 SAY Imp120_180  PICT '9,999,999,999.99'
         @ PROW(),148 SAY Imp180_360  PICT '9,999,999,999.99'
         @ PROW(),165 SAY Imp360_360  PICT '9,999,999,999.99'
         XfTotal = Imp00_00 + Imp30_60 + Imp60_90 + Imp90_120 + Imp120_180
         XfTotal = XfTotal  + Imp180_360 + Imp360_360
         @ PROW(),182 SAY XfTotal     PICT '9,999,999,999.99'
         @ PROW()+1,0 SAY []
         Xf00_00 = Xf00_00 + Imp00_00
         Xf30_60 = Xf30_60 + Imp30_60
         Xf60_90 = Xf60_90 + Imp60_90
         Xf90_120= Xf90_120+ Imp90_120
         Xf120_180= Xf120_180+ Imp120_180
         Xf180_360= Xf180_360+ Imp180_360
         Xf360_360= Xf360_360+ Imp360_360
         SKIP
      ENDDO
      IF PROW() > LinFin .OR. NumPag = 0
         DO ResetPag
      ENDIF
      @ PROW(),056 SAY 'TOTALES'
      @ PROW(),063 SAY Xf00_00      PICT '9,999,999,999.99'
      @ PROW(),080 SAY Xf30_60      PICT '9,999,999,999.99'
      @ PROW(),097 SAY Xf60_90      PICT '9,999,999,999.99'
      @ PROW(),114 SAY Xf90_120     PICT '9,999,999,999.99'
      @ PROW(),131 SAY Xf120_180    PICT '9,999,999,999.99'
      @ PROW(),148 SAY Xf180_360    PICT '9,999,999,999.99'
      @ PROW(),165 SAY Xf360_360    PICT '9,999,999,999.99'
      XfTotal = Xf00_00 + Xf30_60 + Xf60_90 + Xf90_120 + Xf120_180
      XfTotal = XfTotal  + Xf180_360 + Xf360_360
      @ PROW(),182 SAY XfTotal      PICT '9,999,999,999.99'
      @ PROW()+1,063 SAY REPLICATE('-',135)
      @ PROW()+1,0   SAY []
      Tf00_00 = Tf00_00 + Xf00_00
      Tf30_60 = Tf30_60 + Xf30_60
      Tf60_90 = Tf60_90 + Xf60_90
      Tf90_120= Tf90_120+ Xf90_120
      Tf120_180= Tf120_180+ Xf120_180
      Tf180_360= Tf180_360+ Xf180_360
      Tf360_360= Tf360_360+ Xf360_360
   ENDDO
   * Barremos el segundo auxiliar *
   SELE AUXI1
   GO TOP
   DO WHILE !EOF()
      IF PROW() > LinFin .OR. NumPag = 0
         DO ResetPag
      ENDIF
      @ PROW(),056 SAY CodDoc
      @ PROW(),063 SAY Imp00_00    PICT '9,999,999,999.99'
      @ PROW(),080 SAY Imp30_60    PICT '9,999,999,999.99'
      @ PROW(),097 SAY Imp60_90    PICT '9,999,999,999.99'
      @ PROW(),114 SAY Imp90_120   PICT '9,999,999,999.99'
      @ PROW(),131 SAY Imp120_180  PICT '9,999,999,999.99'
      @ PROW(),148 SAY Imp180_360  PICT '9,999,999,999.99'
      @ PROW(),165 SAY Imp360_360  PICT '9,999,999,999.99'
      XfTotal = Imp00_00 + Imp30_60 + Imp60_90 + Imp90_120 + Imp120_180
      XfTotal = XfTotal  + Imp180_360 + Imp360_360
      @ PROW(),182 SAY XfTotal     PICT '9,999,999,999.99'
      @ PROW()+1,0 SAY []
      SKIP
   ENDDO
   @ PROW(),046 SAY 'TOTALES GENERALES'
   @ PROW(),063 SAY Tf00_00      PICT '9,999,999,999.99'
   @ PROW(),080 SAY Tf30_60      PICT '9,999,999,999.99'
   @ PROW(),097 SAY Tf60_90      PICT '9,999,999,999.99'
   @ PROW(),114 SAY Tf90_120     PICT '9,999,999,999.99'
   @ PROW(),131 SAY Tf120_180    PICT '9,999,999,999.99'
   @ PROW(),148 SAY Tf180_360    PICT '9,999,999,999.99'
   @ PROW(),165 SAY Tf360_360    PICT '9,999,999,999.99'
   XfTotal = Tf00_00 + Tf30_60 + Tf60_90 + Tf90_120 + Tf120_180
   XfTotal = XfTotal  + Tf180_360 + Tf360_360
   @ PROW(),182 SAY XfTotal      PICT '9,999,999,999.99'
   @ PROW()+1,063 SAY REPLICATE('-',135)
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN && IN ADMPRINT
RETURN
*********(EOF)*****************************************************************

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,Ancho -12  SAY "Continua.."
   ENDIF
   DO F0MBPRN  && IN ADMPRINT
ENDIF
RETURN
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select CLIE
   IF ! ccbbusca("CLIE")
      SELECT GDOC
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla= Enter
   SELECT GDOC
ENDIF
IF UltTecla = ESCAPE_ .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(VAR1,"CLIE")
   RETURN .F.
ENDIF
RETURN .T.
