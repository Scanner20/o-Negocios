GcTit4 = [LISTA DE PRECIOS]
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
PRIVATE XiCcaja,XiCodMon,XfPreFaIgv,XfDprov,XfPorGan
STORE "" TO XiCcaja,XiCodMon,XfPreFaIgv,XfDprov,XfPorGan

*    CODMAT
*    CCAJA
*    CODMON
*    PREFAIGV
*    DPROV
*    PRECOSIGV
*    PORGAN
*    PORGAN
*    PREFIVEIGV
*    GANIGV



STORE [] TO XiCodMon,XfPreVe1,xfd1,xfd2,xfpneto,xfdprov,xfprecos,xfutilidad,XiCcaja


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
SelLin   = [masd]
InsLin   = []
EscLin   = []
LinReg   = []
EdiLin   = "xBedit"
BrrLin   = []
GrbLin   = "xBgrab"
MVprgF1  = []
MVprgF2  = [VARIAR]
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
*                                       9999.999 99.99 9999.999 99.99 9999.999 9999.999
E1       = [  C¢digo       Und Caja Mon   Precio Dscto    P.Neto  Ganan  P.Venta Utilidad]
E2       = []
E3       = []


LinReg    = [CodMat+' '+UndStk + ' ' + TRAN(CCAJALIM,'9999.999') + ' '  + ;
            TRAN(PreFAIGV,'9999.999') + ' ' + TRAN(DPROV,'99.99') + '% '+;
            TRAN(PRECOSIGV,'9999.999')+' ' + TRAN(PORGAN,'99.99')+'% '+ TRAN(PREFIVEIGV,'9999.999') + ' ' ]

  LinReg     = LinReg + " + TRAN(GANIGV,'9999.999')"





*    CODMAT
*    CCAJA
*    CODMON
*    PREFAIGV
*    DPROV
*    PRECOSIGV
*    PORGAN
*    PREFIVEIGV
*    GANIGV


Ancho    = LEN(&LinReg.)+4
Xo       = INT((80 - ancho)/2)


Static   = .F.
VSombra  = .F.
*
Sorteo   = 1      && Nombre
LsNombre = SPACE(LEN(DesMat))
Localizar= .F.
GsMsgKey = "[F2] Variar P.Venta [F5] Buscar  [F6] Continuar  [Esc] Salir   [Enter] Modificar  [F9] Listar"
DO LIB_MTEC WITH 99
DO DBrowse

CLOSE DATA
RETURN

PROCEDURE MASD

@ 21,Xo + 2 SAY DESMAT COLOR SCHEME 7
@ 21,70     SAY IIF(CODMON=1,'S/.','US$') COLOR SCHEME 7
@ 22,29     SAY ROUND(PREFAIGV/(1 + CFGADMIGV/100),3) PICT "9999.999"   COLOR SCHEME 08
@ 22,45     SAY ROUND(PRECOSIGV/(1 + CFGADMIGV/100),3) PICT "9999.999"  COLOR SCHEME 08
@ 22,61     SAY ROUND(PREFIVEIGV/(1 + CFGADMIGV/100),3) PICT "9999.999" COLOR SCHEME 08

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


* XiCcaja,XiCodMon,XfPreFaIgv,XfDprov,XfPorGan,XfPreFiVeIgv


xiccaja           = ccajaLIM
XiCodMon          = CodMon
XfPreFaIgv        = PreFaIgv
XfDprov           = Dprov
XfPorGan          = PorGan


*LinReg    = [CodMat+' '+UndStk + ' ' + TRAN(CCAJA,'9999') + ' ' + IIF(CODMON=1,'S/.','US$') + ' ' + ;
*            TRAN(PreFAIGV,'9999.999') + ' ' + TRAN(DPROV,'99.99') + '% '+;
*            TRAN(PRECOSIGV,'9999.999')+' ' + TRAN(PORGAN,'99.99')+'% '+ TRAN(PREFIVEIGV,'9999.999') + ' ' ]

*  LinReg     = LinReg + " + TRAN(GANIGV,'9999.999')"


*                     1         2         3         4         5         6         7         8
*           012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                               #### ### ####.### ##.##% ####.### ##.##%


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
         DO lib_mtec WITH 7    && Teclas edicion linea
         @ LinAct,20 GET Xiccaja  PICT "9999.999" RANGE 0,
         READ
         UltTecla = LASTKEY()
       * IF UltTecla = Enter
       *    UltTecla = CtrlW
       * ENDIF

  *   CASE i = 3
  *      DO LIB_MTEC WITH 16
  *      VecOpc(1)="S/."
  *      VecOpc(2)="US$"
  *      XiCodMon = Elige(XiCodMon,LinAct,25,2)
  *      UltTecla = LASTKEY()
      CASE i = 6
         DO lib_mtec WITH 7
         @ LinAct,29 GET XfPreFaIgv PICT "9999.999" RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE i = 7
         @ LinAct,38 GET Xfdprov PICT "99.99" RANGE 0,
         READ
         UltTecla = LASTKEY()

      CASE i = 8
         @ LinAct,54 GET XfPorGan PICT "99.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE i = 9
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon = Elige(XiCodMon,21,70,2)
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF

   ENDCASE


   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>10, 10, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT MATG
IF UltTecla = Escape
   UNLOCK
ENDIF

GsMsgKey = "[F2] Variar P.Venta [F5] Buscar  [F6] Continuar  [Esc] Salir   [Enter] Modificar  [F9] Listar"
DO LIB_MTEC WITH 99
RETURN

PROCEDURE VARIAR
PRIVATE XTPV
SAVE SCREEN
IF EOF() OR BOF()
   RETURN
ENDIF
IF !RLOCK()
   RETURN
ENDIF
XTPV = MATG.PREFIVEIGV
@21,52 SAY "NUEVO PRECIO" GET XTPV PICT "9,999,999.999" MESSAGE "PRESIONES < F10 > PARA TERMINAR"
READ CYCLE
IF LASTKEY() # 27  AND XTPV > 0
  REPLACE PREFIVEIGV WITH XTPV
  REPLACE GANIGV     WITH ROUND (  ccajaLIM * ( Prefiveigv - PreCosIgv)  / ( 1 + cfgadmigv / 100 ) , 3 )
  REPLACE PorGan     WITH ROUND ( 100*(1 - PreCosIgv/PREFIVEIGV) , 2)
ENDIF
UNLOCK
RESTORE SCREEN
GsMsgKey = "[F2] Variar P.Venta [F5] Buscar  [F6] Continuar  [Esc] Salir   [Enter] Modificar  [F9] Listar"
DO LIB_MTEC WITH 99
Listar = .T.
RETURN


************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE xBgrab

*    PRECOSIGV
*    PREFIVEIGV
*    GANIGV

REPLACE ccajaLIM      WITH xiccaja
REPLACE CodMon     WITH XiCodMon
REPLACE PreFaIgv   WITH XfPreFaIgv
REPLACE Dprov      WITH XfDprov
REPLACE PorGan     WITH XfPorGan
REPLACE PreCosIgv  WITH ROUND( PreFaIgv * ( 1 - Dprov / 100 ) ,   3 )
REPLACE PREFIVEIGV WITH ROUND( PreCosIgv / ( 1 - PorGan / 100 ) , 3 )
REPLACE GANIGV     WITH ROUND (  ccajaLIM * ( Prefiveigv - PreCosIgv)  / ( 1 + cfgadmigv / 100 ) , 3 )

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
xtrep = 1
define popup trep title "Tipo de Reporte"
define bar 1 of trep prompt "Lista de precios para Clientes"
define bar 2 of trep prompt "Lista de Precios Uso Interno"
define bar 3 of trep prompt "Lista de Precios Uso Interno Sin Igv"
on selection popup trep deactivate popu trep
activate popup trep  at 12 , 21
xtrep = bar()
if xtrep = 0
   return
endif
xOrder = ORDER()
SAVE SCREEN TO LsPan01

*    2         3         4         5         6
*    01234567890123456789012345678901234567890
*8      Ordenado Por :   CODIGO     NOMBRE
*9             Desde : 12345678901234567890
*0             Hasta :

XiOrden = 1
@  6,20  CLEAR TO 11,60
@  6,20  TO 11,60 DOUBLE
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
do case
case xtrep =  1
     IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
     sNomRep = "vta1500b"
case xtrep = 2
     IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
     sNomRep = "vta1500c"
case xtrep = 3
     IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
     sNomRep = "vta1500d"
endcase

DO admprint WITH "REPORTS"
RESTORE SCREEN FROM LsPan01
SET ORDER TO (xOrder)
RETURN
************************************************************************ FIN *

