**************************************************************************
*  Nombre    : Vtap1700.PRG
*  Sistema   : Ventas
*  Autor     : RMT
*  Objeto    : Mantenimiento archivo de Cod. Art. para Despachos
*  Creaci¢n  : 1994/11/09
**************************************************************************
GcTit1 = GsNomCia
GcTit2 = DTOC(DATE())
GcTit3 = [USER: ]+TRIM(GsUsuario)
GcTit4 = [OPERACIONES CAJA-BANCOS]
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
GcTit4 = []
CLOSE DATA
DO lib_msgs WITH 11
* Bases a usar *

SELE 2
USE CBDTOPER ORDER OPER01 ALIAS OPER
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

SELE 1
USE CJATPROV ORDER PROV01 ALIAS PROV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

** Variables a usar **
Private XsTpoDoc,XcTipo,XsCodOpe,XsCodCtas,XsNotAst
store [] to XsTpoDoc,XcTipo,XsCodOpe,XsCodCtas,XsNotAst
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
Set_Escape = .T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = [xBSelLin]
InsLin   = [xBgrab]
EscLin   = []
EdiLin   = [TabEdit]
BrrLin   = [BorrReg]
GrbLin   = [xBgrab]
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = [xBF5]
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = [xBF9]
PrgFin   = []
Titulo   = []
NClave   = []
VClave   = []
HTitle   = 3
Yo       = 5
Xo       = 5
Largo    = 16
TBorde   = Doble
*                    1         2         3         4         5         6         7         8
*          012345678901234567890123456789012345678901234567890123456789012345678901234567890
*            **** * *** ******************** ***************************************
E1       = [ OPER T LIB CUENTAS CONTABLES    DESCRIPCION                              ]
E2       = []
E3       = []
LinReg   = [TPODOC+" "+TIPO+" "+CODOPE+" "+SUBS(CODCTA,1,20)+" "+NOTAST]
Ancho    = LEN(&LinReg)+4
Xo       = INT((80 - Ancho)/2)
Static   = .F.
VSombra  = .F.
**
sorteo   =  1
localiza = .F.
GsMsgKey = "[F5] Buscar  [Esc] Salir   [Enter] Modificar  [F9] Reportes"
DO LIB_MTEC WITH 99
DO DBrowse
CLOSE DATA
RETURN

************************************************************************* FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE TABEDIT
IF ! Crear
   XsTpoDoc       =  TPODOC
   XcTipo         =  TIPO
   XsCodCtas      =  CODCTA
   XsCodOpe       =  CODOPE
   XsNotAst       =  NOTAST
ELSE

   XsTpoDoc       =  SPACE(LEN(TPODOC))
   XcTipo         =  SPACE(LEN(TIPO))
   XsCodCtas      =  SPACE(LEN(CODCTA))
   XsCodOpe       =  SPACE(LEN(CODOPE))
   XsNotAst       =  SPACE(LEN(NOTAST))

ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
         @ LinAct,Xo+2  GET XsTpoDoc PICT "@!"
         READ
         UltTecla = LastKey()
         IF (UltTecla == Escape)
            LOOP
         ENDIF
         @ LinAct,Xo+ 2 SAY XsTpoDoc
      CASE i = 2
         @ LinAct,Xo+7   GET XcTipo PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         @ LinAct,Xo+7   SAY XcTipo
      CASE i = 3
         @ LinAct,Xo+9  GET XsCodOpe PICT  "@LZ ###"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         SELE OPER
         IF UltTecla = F8
            IF CJABUSCA("OPER")
               XsCodOpe = CodOpe
            ELSE
               LOOP
            ENDIF
         ENDIF
         XsCodOpe = TRANSF(XsCodOPe,"@L ###")
         IF !SEEK(XsCodOpe)
            GsMsgErr = [OPERANCION NO REGISTRADA]
            DO LIB_MERR WITH 99
            SELE PROV
            LOOP
         ENDIF
         SELE PROV
         @ LinAct,Xo+9 SAY XsCodOpe
      CASE i = 4
         @ LinAct,Xo+13  GET XsCodCtas FUNC "S20"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         @ LinAct,Xo+13 SAY XsCodCtas PICT "@S20"
      CASE i = 5
         @ LinAct,Xo+34  GET XsNotAst PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         @ LinAct,Xo+34 SAY XsNotAst
         IF UltTecla = ENTER
            UltTecla = F10
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5, 5, i)
   i = IIF(i<1, 1, i)
ENDDO
SELE PROV

GsMsgKey = "[F5] Buscar  [Esc] Salir   [Enter] Modificar  [F9] Reportes"
DO LIB_MTEC WITH 99

RETURN

********************************
* Objeto : Grabar informacion  *
********************************
PROCEDURE xBgrab
IF Crear
   APPEND BLANK
ENDIF
IF !RLOCK()
   RETURN
ENDIF
REPLACE TPODOC     WITH XsTpoDoc
REPLACE TIPO       WITH XcTipo
REPLACE CODCTA     WITH XsCodCtas
REPLACE CODOPE     WITH XsCodOpe
REPLACE NOTAST     WITH XsNotAst
UNLOCK
RETURN

******************************
* Objeto: Borrar un Registro *
******************************
PROCEDURE BORRreg
IF !RLOCK()
   UltTecla = Escape
   RETURN
ENDIF
DELETE
UNLOCK
SKIP
RETURN

PROCEDURE XBSelLin
@21,2 TO 23,77 CLEA
@21,2 TO 23,77
SELE OPER
SEEK PROV->CODOPE
IF FOUND()
   @22,4 SAY "OPERACION CONTABLE: " + OPER->NOMOPE COLOR SCHEME 11
ELSE

   @22,4 SAY "OPERACION CONTABLE NO REGISTRADA"    COLOR SCHEME 11
ENDIF
SELE PROV
RETU



****************************************************************
* Objeto : Pedir Orden y busqueda                              *
****************************************************************
PROCEDURE xBF5
SAVE SCREEN
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
Localizar = .F.
Desde = SPACE(LEN(TPODOC))
@ 18,4 SAY "INICIO: " GET Desde
READ
Desde = ALLTRIM(Desde)
IF UltTecla = Escape
   RESTORE SCREEN
   RETURN
ENDIF

LeeReg = .T.
Listar = .T.
Desde = TRIM(Desde)
IF !EMPTY(Desde)
   SEEK Desde
   LeeReg = FOUND()
   Listar = FOUND()
ENDIF
RESTORE SCREEN
RETURN


************************************************************************ FIN *
* Objeto : Impresion de Codigos de Articulos Para Despachos
******************************************************************************
PROCEDURE xBF9

xOrder = ORDER()
SAVE SCREEN TO LsPan01

*    2         3         4         5         6
*    01234567890123456789012345678901234567890
*8      Ordenado Por :   CODIGO     NOMBRE
*9             Desde : 12345678901234567890
*0             Hasta :

xFOR   = []
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "CJARPROV"
GO TOP
DO admprint WITH "REPORTS"
RESTORE SCREEN FROM LsPan01
SET ORDER TO (xOrder)
RETURN
