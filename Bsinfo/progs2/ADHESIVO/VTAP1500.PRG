**************************************************************************
*  Nombre    : Vtap1500.PRG
*  Sistema   : Ventas  v.3.0  Control de Almacenes
*  Autor     : RHC
*  Objeto    : Lista de Precios
*  Creaci¢n  : 11/06/94
**************************************************************************

GcTit4 = [INGRESO DE PRECIO DE VENTA]
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
GcTit4 = []
CLOSE DATA
DO lib_msgs WITH 11
* Bases a usar *
SELE 2
USE almTfami ORDER FAMI01 ALIAS FAMI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE almmmatg ORDER MATG01 ALIAS MATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
* Variables a usar
PRIVATE XiCodMon,XfPreVe1
STORE [] TO XiCodMon,XfPreVe1
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
*** FILTRAMOS LOS PRODUCTOS QUE TIENEN PRECIO *****
*SET FILTER TO PREVE1<>0
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
SelLin   = []
InsLin   = []
EscLin   = []
EdiLin   = "xBedit"
BrrLin   = []
GrbLin   = "xBgrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = [xBF5]
MVprgF6  = [xBF6]
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
E1       = [  C¢digo         D e s c r i p c i ¢ n             Und Mon   Precio   ]
E2       = []
E3       = []
LinReg   = [CodMat+' '+LEFT(DesMat,40)+' '+UndStk+' '+IIF(CodMon=1,'S/.','US$')+' '+;
            TRANS(PreVe1,'999,999.999')]
Ancho    = LEN(&LinReg.)+4
Xo       = INT((80 - ancho)/2)
Static   = .F.
VSombra  = .T.
**
Sorteo   = 1      && Nombre
LsNombre = SPACE(LEN(DesMat))
Localizar= .F.
BBVerti  = .T.
GsMsgKey = "[F5] Buscar  [F6] Continuar  [Esc] Salir   [Enter] Modificar  [F9] Listar"
DO LIB_MTEC WITH 99
DO DBrowse

CLOSE DATA
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit
IF ! Crear
   IF !REC_LOCK(5)
      UltTecla = Escape
      RETURN
   ENDIF
ENDIF
XsCodFam  = SPACE(LEN(FAMI->CodFAM))
XsCodMat1 = SPACE(LEN(MATG->CodMAT)-LEN(XsCodFam))

XiCodMon = CodMon
XfPreVe1 = PreVe1
*
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1 .AND. Crear
         ** dividimos el get en 2 partes **
         SELE FAMI
         SET CONFIRM OFF
         @ LinAct,Xo+2   GET XsCodFam PICT "@!"
         READ
         UltTecla = LASTKEY()
         SET CONFIRM ON
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodFam)
            IF !almbusca("FAMI")
               UltTecla = 0
               LOOP
            ENDIF
            XsCodFam = CodFam
         ENDIF
         @ LinAct,Xo+2 SAY XsCodFam
         SEEK XsCodFam
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         * pedimos segunda parte del codigo *
         SELE MATG
         SET FILTER TO
         @ LinAct,Xo+2+LEN(XsCodFam) GET XsCodMat1 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         XsCodMat = XsCodFam+XsCodMat1
         IF UltTecla = F8 .OR. EMPTY(XsCodMat1)
            IF !almbusca("MATGF")
               SET FILTER TO PREVE1<>0
               UltTecla = 0
               LOOP
            ENDIF
            XsCodMat = CodMat
         ENDIF
         @ LinAct,Xo+2 SAY XsCodMat+" "+LEFT(MATG->DESMAT,40)+" "+MATG->UNDSTK
         SEEK XsCodMat
         SET FILTER TO PREVE1<>0
         IF ! FOUND()
            DO Lib_MErr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF

      CASE i = 2
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon = Elige(XiCodMon,LinAct,62,2)
      CASE i = 3        && C¢digo de Cuenta
         DO lib_mtec WITH 7    && Teclas edicion linea
         @ LinAct,66 GET XfPreVe1 PICT "999,999.999" RANGE 0,
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3, 3, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT MATG
IF UltTecla = Escape
   UNLOCK
ENDIF
GsMsgKey = "[F5] Buscar   [Esc] Salir   [Enter] Modificar  [F9] Listar"
DO LIB_MTEC WITH 99
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE xBgrab
REPLACE CodMon WITH XiCodMon
REPLACE PreVe1 WITH XfPreVe1
UNLOCK
RETURN
************************************************************************ FIN *
* Objeto : Pedir Orden y busqueda
******************************************************************************
PROCEDURE xBF5

SAVE SCREEN
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
IF UltTecla = Escape
   RETURN
ENDIF
Localizar = .F.
IF Sorteo = 1
   SET ORDER TO MATG01
ELSE
   SET ORDER TO MATG02
ENDIF
IF Sorteo = 1
   Desde = SPACE(LEN(CodMat))
   @ 18,4 SAY "C¢digo :" GET Desde
ELSE
   Desde = SPACE(LEN(DesMat))
   @ 18,4 SAY "Nombre :" GET Desde PICT "@S15"
ENDIF
LsNombre = SPACE(LEN(DesMat))
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
READ
IF UltTecla = Escape
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
IF ! EMPTY(LsNombre)
   Localizar = .T.
   LOCATE FOR TRIM(LsNombre)$DesMat
   Listar   = FOUND()
   Refresco = FOUND()
ENDIF
RESTORE SCREEN

RETURN
************************************************************************ FIN *
* Objeto : Continuar Busqueda
******************************************************************************
PROCEDURE xBF6

IF Localizar
   SAVE SCREEN TO LsPan01
   WAIT "Buscando" WINDOW NOWAIT
   CONTINUE
   Listar    = FOUND()
   LeeReg    = FOUND()
   Localizar = FOUND()
   RESTORE SCREEN FROM LsPan01
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Impresion de Lista de Precios
******************************************************************************
PROCEDURE xBF9

xOrder = ORDER()
SAVE SCREEN TO LsPan01

*    2         3         4         5         6
*    01234567890123456789012345678901234567890
*8      Ordenado Por :   CODIGO     NOMBRE
*9             Desde : 12345678901234567890
*0             Hasta :

XiOrden = 1
@  7,20  CLEAR TO 11,60
@  7,20  TO 11,60 DOUBLE
@  8,23 SAY "Ordenado Por :"
@  9,23 SAY "       Desde :"
@ 10,23 SAY "       Hasta :"
UltTecla = 0
@  8,40 PROMPT "CODIGO"
@  8,50 PROMPT "NOMBRE"
MENU TO XiOrden
IF XiOrden = 0
   RESTORE SCREEN FROM LsPan01
   RETURN
ENDIF
IF XiOrden = 1
   XsDesde = SPACE(LEN(CodMat))
   XsHasta = SPACE(LEN(CodMat))
ELSE
   XsDesde = SPACE(LEN(DesMat))
   XsHasta = SPACE(LEN(DesMat))
ENDIF
IF XiOrden = 1
   @  9,38 GET XsDesde PICT "@!"
   @ 10,38 GET XsHasta PICT "@!"
ELSE
   @  9,38 GET XsDesde PICT "@!S20"
   @ 10,38 GET XsHasta PICT "@!S20"
ENDIF
READ
IF LASTKEY() = Escape
   RESTORE SCREEN FROM LsPan01
   RETURN
ENDIF
IF XiOrden = 1
   SET ORDER TO MATG01
ELSE
   SET ORDER TO MATG02
ENDIF
XsDesde = TRIM(XsDesde)
XsHasta = TRIM(XsHasta)+CHR(255)
IF EMPTY(XsDesde)
   GO TOP
ELSE
   SEEK XsDesde
   IF !FOUND()
      GO RECNO(0)
   ENDIF
ENDIF
xFOR = []
IF XiOrden = 1
   xWHILE = "CodMat<=XsHasta"
ELSE
   xWHILE = "DesMat<=XsHasta"
ENDIF

Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
sNomRep = "vtar1500"
DO admprint WITH "REPORTS"
RESTORE SCREEN FROM LsPan01
SET ORDER TO (xOrder)
RETURN
************************************************************************ FIN *

