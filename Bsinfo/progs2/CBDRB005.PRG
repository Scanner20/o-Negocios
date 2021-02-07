********************************************************************************
* Progrma       : CBDRB005.PRG                                                 *
* Objeto        : BALANCE DE GENERAL A 8  COLUMNAS                             *
* Autor         : J.C.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
***
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
***
sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
    close data
    return
endif
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE GENERAL"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiNivel=1
XiCodMon = 1
XiNroMes = _Mes

DO LIB_MTEC WITH 16
@ 10,26 SAY "MONEDA : "
@ 11,26 SAY "NIVEL  : "
@ 12,26 SAY "MES    : "
i = 1
UltTecla = 0

DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,36,2)
      CASE i = 2
         @ 11,36 GET XiNivel PICT "9"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,36 GET XiNroMes PICT "99" RANGE 0,13
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)
      CASE UltTecla = Abajo
         i = IIF( i< 3 , i + 1, 3 )
      CASE UltTecla = Enter
         IF  i < 3
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO

IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
*** Pantalla de datos  ***
SELE CTAS
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
Ancho = 128
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo    = "BALANCE GENERAL"
SubTitulo = "AL MES "+MES(XiNroMes,1)+" "+TRANS(_ANO,"9999")
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = "********************************************************************************************************************************"
En5 = ":CUENTA         N O M B R E                                                                                                    :"
En6 = ":..............................................................................................................................:"
En7 = ":          S U M A S            :          S A L D O S          :          INVENTARIO           :          RESULTADO           :"
En8 = ":     DEBE            HABER     :    DEUDOR         ACREEDOR    :    ACTIVO          PASIVO     :    PERDIDA         GANANCIA  :"
En9 = "**************** *************** *************** *************** *************** *************** *************** ***************"
       * 1               17              33              49              65              81              97              113
***
Cancelar = .F.
SET DEVICE TO PRINT
SET MARGIN TO 0
NumCol = 8
DIMENSION X(NumCol),Y(NumCol),Z(NumCol)
PRINTJOB
   Inicio = .T.
   NumPag  = 0
   SEEK "10"
   STORE 0 TO X,Y,Z

   DO WHILE ! EOF() .and. ! Cancelar
      IF NivCta > XiNivel
         SKIP
         LOOP
      ENDIF
      DO LinImp
      Cancelar = INKEY() = Escape
      SKIP
   ENDDO
   IF ! Cancelar
      DO TOTIMP0
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

****************
PROCEDURE LinImp
****************
DO CBDACUMD WITH CodCta,0,XiNroMes
SELECT CTAS
STORE 0 TO X
X(1) = XvCalc(4+INC)
X(2) = XvCalc(5+INC)
IF XvCalc(6+INC) >= 0
   X(3) = XvCalc(6+INC)
ELSE
   X(4) = -XvCalc(6+INC)
ENDIF

IF CodCta < "6"
   X(5) = X(3)
   X(6) = X(4)
ELSE
   X(7) = X(3)
   X(8) = X(4)
ENDIF

DO ResetPag
NumLin = PROW() + 2
@ Numlin,09  SAY CodCta
@ Numlin,21  SAY Nomcta
NumLin = PROW() + 2
FOR I = 1 TO 8
   Col = (i-1)*16
   @ Numlin,Col SAY  PICNUM(X(I))
   IF NivCta = 1
      Z(I) = Z(I) + X(I)
   ENDIF
NEXT
RETURN

*****************
PROCEDURE TotImp0
*****************
STORE 0 TO X
IF Z(5) > Z(6)
   X(5) = 0
   X(6) = Z(5)-Z(6)
ELSE
   X(5) = Z(6)-Z(5)
   X(6) = 0
ENDIF
IF Z(7) > Z(8)
   X(7) = 0
   X(8) = Z(7)-Z(8)
ELSE
   X(7) = Z(8)-Z(7)
   X(8) = 0
ENDIF

NumLin = PROW() + 2
@ Numlin,33  SAY _PRN6a
@ Numlin,33  SAY "GANANCIA DEL EJERCCIO"
FOR I = 5 TO 8
   Col = (i-1)*16
   @ Numlin,Col SAY  PICNUM(X(I))
   Z(I) = Z(I) + X(I)
NEXT
@ Numlin,33  SAY _PRN6b
NumLin = PROW() + 2
FOR I = 5 TO 8
   Col = (i-1)*16
   @ Numlin,Col SAY REPLICATE("-",LEN(PICNUM(0)))
NEXT
NumLin = PROW() + 1
FOR I = 5 TO 8
   Col = (i-1)*16
   @ Numlin,Col SAY  PICNUM(Z(I))
NEXT
NumLin = PROW() + 1
FOR I = 5 TO 8
   Col = (i-1)*16
   @ Numlin,Col SAY REPLICATE("=",LEN(PICNUM(0)))
NEXT
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***********************************FIN
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"@Z 9999,999,999.99")+"-"
ELSE
   RETURN TRANSF( Valor,"@Z 9999,999,999.99")+" "
ENDIF
