********************************************************************************
* Progrma       : CBDRL005.prg                                                 *
* Objeto        : LIBRO MAYOR                                                  *
* Autor         : J.M.                                                         *
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
cTit4 = "LIBRO MAYOR"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiCodMon = 1
XnNivCta = 2
XsSolMov = 'S'
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))

@ 09,18 SAY "                      Moneda :"
@ 10,18 SAY "        Hasta el Nivel (1-9) :"
@ 11,18 SAY "               Cuenta Desde  :"
@ 12,18 SAY "               Cuenta Hasta  :"
@ 13,18 SAY "Solo Cuentas con Movimientos :"
DO LIB_MTEC WITH 16
i = 1
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(XiCodMon,09,48,2)
         En1 = TRIM(VECOPC(XiCodMon))
      CASE i = 2
         @ 10,48 GET XnNivCta PICTURE "#" RANGE 1,9
         READ
         UltTecla = LASTKEY()
      CASE I = 3
         @ 11,48 GET XsCtaDes PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         @ 12,48 GET XsCtaHas PICTURE REPLICATE("9",LEN(CTAS->CODCTA))
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         VecOpc(1)="S¡"
         VecOpc(2)="No"
         XsSolMov= Elige(XsSolMov,13,48,2)
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 4 , i + 1, 4 )

      CASE UltTecla = Enter
         IF  i < 4
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


IF XnNivCta = 1
  SET ORDER TO CTAS02
  SEEK '1'+TRIM(XsCtaDes)
ELSE
  SEEK TRIM(XsCtaDes)
ENDIF
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

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
Ancho = 145
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = ""
SubTitulo= "LIBRO MAYOR ANALITICO AL MES DE "+MES(_MES,1)+" "+TRANS(_ANO,"9999")
En2 = " "
En3 = ""
En4 = ""
En5 = ""
En6 = "*********** ************************************* ******************************* ******************************* *******************************"
En7 = "  CODIGO                                          --------  SALDO ANTERIOR ------ ----- MOVIMIENTO DEL MES ------ --------  SALDO ACTUAL --------"
En8 = "  CUENTA       DESCRIPCION                                DEBITO          CREDITO            DEBE           HABER         DEBITO         CREDITO "
En9 = "*********** ************************************* *************** *************** *************** *************** *************** ***************"

NumCol = 8
DIMENSION X(NumCol),Y(NumCol),Z(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   xNivel  = 1
   NumPag  = 0
   xCodCta = LEFT(CodCta,2)
   STORE 0 TO X,Y,Z
   DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar
      IF NivCta<=XnNivCta
         DO LinImp
      ENDIF
      SELECT CTAS
      SKIP
      IF XnNivCta = 1 .AND. NivCta > 1
         EXIT
      ENDIF
      Cancelar = Cancelar .OR. (INKEY() = Escape)
   ENDDO
   IF ! CANCELAR
      DO TotImp
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
PRIVATE NumLin
IF NivCta=1
   Tb = 0
ELSE
   TB = 1
ENDIF

Store 0 TO X
DO CBDAcumd WITH Ctas->CodCta , 0 , _Mes
SELEC CTAS
SalAnt =  XvCalc(6+INC) - XvCalc(3+INC)
IF SalAnt > 0
   X(1) = SalAnt
ELSE
   X(2) = -SalAnt
ENDIF
X(3)   = XvCalc(1+INC)
X(4)   = XvCalc(2+INC)
SalAct = XvCalc(6+INC)
IF SalAct > 0
   X(5) = SalAct
ELSE
   X(6) = -SalAct
ENDIF
X(7)   = XvCalc(4+INC)
X(8)   = XvCalc(5+INC)
IF (X(7)  = 0  .AND. X(8)  = 0) .AND. XsSolMov = 'S'
   RETURN
ENDIF
DO ResetPag
IF xNivel <> NivCta
   NumLin = PROW()+1                           && Linea Actual
   @ NumLin,0 SAY ""
   xNivel = NivCta
ENDIF
IF CodCta = xCodCta
   NumLin = PROW()+1                           && Linea Actual
ELSE
   NumLin = PROW()+2                           && Linea Actual
ENDIF
IF NivCta = 1 .AND. XnNivCta > 1
   @ NumLin,TB SAY _Prn6a
ENDIF
xCodCta = LEFT(CodCta,2)
@ NumLin,Tb    SAY CodCta
@ NumLin,12    SAY NomCta   PICT "@S35"
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY X(i)   PICT "@Z 9999,999,999.99"
    IF NivCta = 1
       Y(I) = Y(I) + X(I)
    ENDIF
ENDFOR
IF NivCta = 1 .AND. XnNivCta > 1
   @ NumLin,Ancho-1 SAY _Prn6b
ENDIF
RETURN

**********************************************************************
PROCEDURE TotImp
****************
PRIVATE NumLin
NumLin = PROW() + 1
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY "---------------"
ENDFOR
NumLin = PROW()+1                           && Linea Actual
@ Numlin,25  SAY "TOTAL GENERAL"
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY Y(i)   PICT "@Z 9999,999,999.99"
ENDFOR
NumLin = PROW() + 1
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY "==============="
ENDFOR
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***********************************FIN
