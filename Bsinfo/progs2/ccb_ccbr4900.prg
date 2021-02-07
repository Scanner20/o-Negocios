*****************************************************************************
* Programa     : ccbr4900.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Doc.xCobrar
* Parametros   :
* Creacion     : 03/11/94
* Actualizaci¢n: RHC 19/12/94 Seleccionar entre FAC y LETR
*****************************************************************************
SYS(2700,0)
CLEAR
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

STORE '' TO Arch, Arch1,Arch2,Arch3
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
Arch = LoDatAdm.oentorno.TmpPath+SYS(3)

* Pantalla de Datos
Titulo = [>> DOCUMENTOS x COBRAR x VENCIMIENTO <<]
DO fondo WITH 'Documentos x cobrar x vencimiento',Goentorno.user.login,GsNomCia,GsFecha

*@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 22,70
@ 8,10 TO 22,70 DOUBLE
@ 12,20 SAY " Del Cliente : "
@ 14,20 SAY " Condici¢n   : "
*
IF USED('TEMPO')
	USE IN TEMPO
ENDIF

DO xListar

IF USED('TEMPO')
	USE IN TEMPO
ENDIF
IF USED('AUXI1')
	USE IN AUXI1
ENDIF

IF USED('TCMB')
	USE IN TCMB
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
*********************************************************************** EOP() *
* Objeto : Logica Principal
*******************************************************************************
PROCEDURE xListar

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC02','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
*DO lib_msgs WITH 11

RELEASE LoDatAdm
* Archivo Temporal de Trabajo
SELE GDOC
COPY STRU TO &Arch.
SELE 0
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
* Variables a usar *
PRIVATE XsCliD
PRIVATE LiOrden
LiOrden = 1
LiSelec = 1
XiCondi = 1
* Pedimos datos
PRIVATE i
DO WHILE .T.
   STORE SPACE(LEN(CLIE->CodAux)) TO XsCliD
   i = 1
   UltTecla = 0
   DO WHILE UltTecla # escape_
      DO lib_mtec WITH 8
      DO CASE
         CASE i = 1
            GsMsgKey = "[F8] Consultar   [Enter] Aceptar   [Esc] Cancelar [F10] Genera reporte"
            DO lib_mtec WITH 99
            SELE CLIE
            @ 12,35 GET XsCliD PICT "@!"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Arriba,escape_,BackTab)
               LOOP
            ENDIF
            IF UltTecla = F8
               IF !ccbbusca("CLIE")
                  LOOP
               ENDIF
               XsCliD = CodAux
            ENDIF
            @ 12,35 SAY XsCliD PICT "@!"
            IF !EMPTY(XsCliD)
               SEEK GsClfCli+XsCliD
               IF !FOUND()
                  DO lib_merr WITH 9
                  LOOP
               ENDIF
            ENDIF
         CASE i = 2
	            GsMsgKey = "[Enter]Aceptar [Esc]Salir [Teclas Cursor]Posicionar [F10] Genera reporte"
			    DO LIB_MTEC WITH 99
				@ 13,34 GET XiCondi  FUNCTION "^RH FACTURAS;LETRAS;N/DEBITO;TODOS"
				READ
				UltTecla = LASTKEY()

      ENDCASE
      IF i = 2 .AND. INLIST(UltTecla, Enter,CTRLW,F10)
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>2,2,i)
   ENDDO
   IF UltTecla = escape_
      EXIT
   ENDIF
   ** Generamos Registro Final **
   DO xGENERA
   SELE TEMPO
   GO TOP
   IF EOF()
      GsMsgErr = [Fin de Archivo]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   DO xBrowse
ENDDO

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SELE TEMPO
ZAP
INDEX ON NomCli+DTOS(FchVto) TAG TEMP01
* Logica Principal *
SELE GDOC
SET FILTER TO tpovta<>3
IF !EMPTY(XsCliD)
   SET ORDER TO GDOC04
   xWHILE = "CodCli=XsCliD.AND.FlgEst=[P].AND.TpoDoc=[CARGO]"
   SEEK XsCliD+[P]+[CARGO]
ELSE
   SET ORDER TO GDOC05
   xWHILE = "FlgEst=[P].AND.TpoDoc=[CARGO]"
   SEEK [P]+[CARGO]
ENDIF
DO CASE
   CASE XiCondi = 1
      xFOR = "CodDoc=[FAC]"
   CASE XiCondi = 2
      xFOR = "CodDoc=[LET]"
   CASE XiCondi = 3
      xFOR = "CodDoc=[N/D]"
   OTHER
      xFOR = ".T."
ENDCASE
* Barremos Cabecera
SCAN WHILE &xWHILE FOR &xFOR
   WAIT "Documento : "+CodDoc+" "+NroDoc WINDOW NOWAIT
   =SEEK(GsClfCli+GDOC->CodCli,"CLIE")
   SELE TEMPO
   APPEND BLANK
   REPLACE CodCli WITH GDOC->CodCli
   REPLACE NomCli WITH IIF(EMPTY(CLIE.IniAux),GDOC.NomCli,CLIE.IniAux)
   REPLACE FchDoc WITH GDOC->FchDoc
   REPLACE CodDoc WITH GDOC->CodDoc
   REPLACE NroDoc WITH GDOC->NroDoc
   REPLACE FchVto WITH GDOC->FchVto
   REPLACE CodMon WITH GDOC->CodMon
   REPLACE SdoDoc WITH GDOC->SdoDoc
   *
   SELE GDOC
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT

RETURN
*********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

*          1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6³              Fecha                        Fecha      Dias            Saldo   ³
*7³ Cliente     Emisi¢n   Cod.   Documento    Vencto.   Atraso  Mon     Actual   ³
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*9³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*0³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*1³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*2³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*3³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*4³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*5³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*6³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*7³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*8³*12345678   99/99/99   1234   123456789   99/99/99   (123)   S/.99,999,999.99 ³
*9ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0³                             TOTALES : S/. 999,999,999.99  US$ 999,999,999.99 ³
*1³ Tipo de Cambio :                            TOTAL GENERAL US$                ³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*          1         2         3         4         5         6         7         8

SAVE SCREEN TO LsPan01
@  5,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,0  SAY "³              Fecha                        Fecha      Dias            Saldo   ³"
@  7,0  SAY "³ Cliente     Emisi¢n   Cod.   Documento    Vencto.   Atraso  Mon     Actual   ³"
@  8,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  9,0  SAY "³                                                                              ³"
@ 10,0  SAY "³                                                                              ³"
@ 11,0  SAY "³                                                                              ³"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "³                                                                              ³"
@ 19,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 20,0  SAY "³                             TOTALES : S/.                 US$                ³"
@ 21,0  SAY "³ Tipo de Cambio :                          TOTAL GENERAL : US$                ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@  6,1 FILL TO  7,78 COLOR SCHEME 7
@ 20,1 FILL TO 21,78 COLOR SCHEME 7
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .T.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .F.
Set_Escape=.T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = [xBEscl]
EdiLin   = []
BrrLin   = []
GrbLin   = []
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = [xBF9]
PrgFin   = []
Titulo   = []
NClave   = []
VClave   = []
HTitle   = 1
Yo       = 8
Xo       = 0
Largo    = 12
Ancho    = 80
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = [LEFT(NomCli,18)+' '+DTOC(FchDoc)+' '+CodDoc+' '+NroDoc+' '+;
            DTOC(FchVto)+' '+TRANS(DATE()-FchVto,'@( 9999')+'  '+;
            IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'99999,999.99')+' ']
Static   = .T.
VSombra  = .F.
*
GsMsgKey = "[Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover  [F9] Listar"
DO lib_mtec WITH 99
SELE TEMPO
STORE 0 TO XfTotNac,XfTotUsa,XfTotTot
GO TOP
DO WHILE !EOF()
   IF CodMon = 1
      XfTotNac = XfTotNac + SdoDoc
   ELSE
      XfTotUsa = XfTotUsa + SdoDoc
   ENDIF
   SKIP
ENDDO
XfTpoCmb = 1
IF SEEK(DTOS(DATE()),"TCMB")
   XfTpoCmb = TCMB->OfiVta
ENDIF
XfTotTot = XfTotUsa + XfTotNac/XfTpoCmb
@ 20,44 SAY XfTotNac PICT "999,999,999.99" COLOR SCHEME 7
@ 20,64 SAY XfTotUsa PICT "999,999,999.99" COLOR SCHEME 7
@ 21,19 SAY XfTpoCmb PICT "9,999.999"      COLOR SCHEME 7
@ 21,64 SAY XfTotTot PICT "999,999,999.99" COLOR SCHEME 7
GO TOP
DO DBrowse
RESTORE SCREEN FROM LsPan01

RETURN
************************************************************************ FIN *
* Objeto : Escribir linea
******************************************************************************
PROCEDURE xBEscl
PARAMETER Contenido

=SEEK(GsClfCli+CodCli,"CLIE")
Contenido = IIF(EMPTY(CLIE->IniAux),LEFT(NomCli,8),CLIE->IniAux)+' '
Contenido = Contenido+DTOC(FchDoc)+'  '+CodDoc+'  '+NroDoc+'  '
COntenido = Contenido+DTOC(FchVto)+'  '+TRANS(DATE()-FchVto,'@( 9999')+'  '
COntenido = Contenido+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9999,999.99')+' '

RETURN
************************************************************************ FIN *
* Objeto : Impresion
******************************************************************************
PROCEDURE xBF9
SAVE SCREEN TO LsTmp01
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "ccbr4900"
DO F0print WITH "REPORTS"
RESTORE SCREEN FROM LsTmp01
RETURN
************************************************************************ FIN *
