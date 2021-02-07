****************************************************************************
* Programa     : vtapdete.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Ingreso de Precios de Detergente
* Creacion     : 26/11/94
* Parametros   :
* Actualizacion: RHC 29/12/94 Agregar Precio del carbonato a 3 decimales
****************************************************************************

** Pantalla de Datos **
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> INGRESO DE PRECIOS DEL DETERGENTE <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
** base de datos **
CLOSE DATA
*
USE vtadeter IN 0 ORDER DETE01 ALIAS DETER
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** variables a usar **
PRIVATE XsAnoMes,XfPreDet,XfPreCar
XsAnoMes = SPACE(LEN(DETER->AnoMes))
XfPreDet = 0
XfPreCar = 0
* variables del browse *
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
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
NClave   = []
VClave   = []
**
HTitle   = 1
Yo       = 5
Xo       = 30
Largo    = 17
Ancho    = 44
TBorde   = Doble
E1       = [  Periodo        Precio         Precio    ]
E2       = [ (aaaa/mm)     Detergente     Carbonato   ]
E3       = [               Bolsa  1/4       por KG    ]

*          1         2         3         4         5         6         7
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*                              ³  Periodo        Precio         Precio    ³
*                              ³ (aaaa/mm)    Detergente      Carbonato   ³
*                              ³                                          ³
*                              ³* 1994/05   999,999,999.99 999,999,999.99 ³


LinReg   = [' '+TRANS(AnoMes,'@R 9999/99')+'   '+TRANS(PreDet,'999,999,999.99')+' '+TRANS(PreCar,'99,999,999.999')+' ']
Static   = .F.
VSombra  = .T.
**
SELE DETER
DO LIB_MTEC WITH 14
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Editar Precio
******************************************************************************
PROCEDURE xBedit

IF Crear
   XsAnoMes = SPACE(LEN(AnoMes))
   XfPreDet = 0
   XfPreCar = 0
ELSE
   XsAnoMes = AnoMes
   XfPreDet = PreDet
   XfPreCar = PreCar
ENDIF
UltTecla = 0
GsMsgKey = "[Esc] Cancelar    [F10] Grabar"
DO lib_mtec WITH 99
@ LinAct,33 GET XsAnoMes PICT "@R 9999/99"
@ LinAct,43 GET XfPreDet PICT "999,999,999.99"
@ LinAct,58 GET XfPreCar PICT "99,999,999.999"
READ
UltTecla = LASTKEY()
IF !INLIST(UltTecla,Enter,F10,CtrlW)
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14

RETURN
************************************************************************ FIN *
* Objeto : Grabar Precio
******************************************************************************
PROCEDURE xBgrab

IF Crear
   APPEND BLANK
ENDIF
IF !REC_LOCK(5)
   RETURN
ENDIF
REPLACE AnoMes WITH XsAnoMes
REPLACE PreDet WITH XfPreDet
REPLACE PreCar WITH XfPreCar
UNLOCK

RETURN
************************************************************************ FIN *
* Objeto : Borrar Precio
******************************************************************************
PROCEDURE xBborr

IF !REC_LOCK(5)
   RETURN
ENDIF
DELETE
UNLOCK

RETURN
************************************************************************ FIN *
