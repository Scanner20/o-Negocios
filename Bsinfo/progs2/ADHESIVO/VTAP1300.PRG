****************************************************************************
* Programa     : vtap1300.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Tabla de Unidades de Ventas
* Creacion     : 13/06/94
* Parametros   :
* Actualizacion:
****************************************************************************

** Pantalla de Datos **
DO xPanta
** base de datos **
CLOSE DATA
*
SELE 1
USE almtabla ORDER TABL01 ALIAS UNID
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE almtuvta ORDER UVTA01 ALIAS UVTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** variables a usar **
** variables de cabecera **
PRIVATE XsTabla,XsUndStk,cTabla
XsTabla  = [UD]
XsUndStk = SPACE(LEN(UNID->Codigo))
cTabla   = XsTabla
** Variables del Browse **
PRIVATE XsUndVta,XfFacEqu,XsDesVta
XsUndVta = SPACE(LEN(UVTA->UndVta))
XfFacEqu = 1
XsDesVta = SPACE(LEN(UVTA->DesVta))
** Logica Principal **
SELE UNID
DO LIB_MTEC WITH 3
UltTecla = 0
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [Tabla],cTabla,'M',[]
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta

*          1         2         3         4         5         6         7
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*4         ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*5         ³ Unidad de Stock : 123 1234567890123456789012345      ³
*6         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*7          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*8          ³              **  UNIDADES DE VENTA  **            ³
*9          ³ Codigo    Descripcion              Equivalen a    ³
*0          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1          ³*  123  1234567890123456789012345 999,999.9999 123 ³
*2          ³                                                   ³
*3          ³                                                   ³
*4          ³                                                   ³
*5          ³                                                   ³
*6          ³                                                   ³
*7          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*8
*9
*0
*1
*2
*
CLEAR
@ 0,0 TO 21,79
Titulo = [** TABLA DE UNIDADES DE VENTA **]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  4,10 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  5,10 SAY "³ Unidad de Stock :                                    ³"
@  6,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@  7,10 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  8,10 SAY " ³              **  UNIDADES DE VENTA  **            ³"
@  9,10 SAY " ³ Codigo    Descripcion              Equivalen a    ³"
@ 10,10 SAY " ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 11,10 SAY " ³                                                   ³"
@ 12,10 SAY " ³                                                   ³"
@ 13,10 SAY " ³                                                   ³"
@ 14,10 SAY " ³                                                   ³"
@ 15,10 SAY " ³                                                   ³"
@ 16,10 SAY " ³                                                   ³"
@ 17,10 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

SELE UNID
IF &RegVal
   XsUndStk = UNID->Codigo
ELSE
   XsUndStk = SPACE(LEN(UNID->Codigo))
ENDIF
*
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape,Enter)
   @ 5,30 GET XsUndStk PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Escape)
      LOOP
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsUndStk)
      IF ! vtabusca("0003")
         UltTecla = 0
         LOOP
      ENDIF
      XsUndStk = UNID->Codigo
   ENDIF
   @ 5,30 SAY XsUndStk
ENDDO
SEEK XsTabla+XsUndStk

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE UNID
IF ! RLOCK()
   RETURN
ENDIF
XsUndStk = Codigo
STORE RECNO() TO iRECNO
* * * *
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
DO xBrowse
* * * *
SELE UNID
GO iRECNO
UNLOCK ALL
DO LIB_MTEC WITH 3
KEYBOARD CHR(Escape)

RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

@  5,30 SAY Codigo+' '+LEFT(Nombre,25)
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse

SELE UNID

RETURN
************************************************************************ FIN()
* Browse de datos
******************************************************************************
PROCEDURE xBrowse

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
BrrLin   = "xBborr"
GrbLin   = "xBgrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
**
NClave   = [UndStk]
VClave   = UNID->Codigo
**
HTitle   = 1
Yo       = 10
Xo       = 11
Largo    = 8
Ancho    = 53
TBorde   = Nulo
E1       = []
E2       = []
E3       = []

LinReg   = ['  '+UndVta+'  '+LEFT(DesVta,25)+' '+TRANS(FacEqu,'999,999.9999')+' '+UNID->Codigo+' ']
Static   = .F.
VSombra  = .F.
**
SELE UVTA
DO LIB_MTEC WITH 14
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit

IF ! Crear
   IF !RLOCK()
      RETURN
   ENDIF
   XsUndVta = UndVta
   XsDesVta = DesVta
   XfFacEqu = FacEqu
ELSE
   XsUndVta = SPACE(LEN(UVTA->UndVta))
   XsDesVta = SPACE(LEN(UVTA->DesVta))
   XfFacEqu = 1
ENDIF
*
DO lib_mtec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   i = IIF(!Crear.AND.i<2,2,i)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELE UNID
         @ LinAct,15 GET XsUndVta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsUndVta)
            IF !vtabusca("0003")
               LOOP
            ENDIF
            XsUndVta = LEFT(UNID->Codigo,3)
            XsDesVta = UNID->Nombre
            GO iRECNO
         ENDIF
         @ LinAct,15 SAY XsUndVta
         SEEK XsTabla+XsUndVta
         IF !FOUND()
            cResp = [N]
            cResp = aviso(18,[ Unidad no registrada ],[ Continuamos (S-N)?],[],;
                    3,[SN],0,.F.,.T.,.T.)
            IF cResp = [N]
               GO iRECNO
               LOOP
            ENDIF
         ELSE
            XsDesVta = UNID->Nombre
         ENDIF
         GO iRECNO
         @ LinAct,20 SAY XsDesVta PICT "@S25"
         @ LinAct,59 SAY XsUndStk
      CASE i = 2
         @ LinAct,20 GET XsDesVta PICT "@!S25"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ LinAct,46 GET XfFacEqu PICT "999,999.9999" RANGE 0,
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
SELE UVTA
IF UltTecla = Escape
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE xBgrab

IF Crear
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE UndStk WITH XsUndStk
   REPLACE UndVta WITH XsUndVta
ENDIF
REPLACE DesVta WITH XsDesVta
REPLACE FacEqu WITH XfFacEqu
UNLOCK

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE xBborr

IF !RLOCK()
   RETURN
ENDIF
DELETE
UNLOCK

RETURN
************************************************************************ FIN *
