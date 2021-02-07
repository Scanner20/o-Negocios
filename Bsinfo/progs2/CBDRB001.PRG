********************************************************************************
* Progrma       : CBDRB001.PRG                                                 *
* Objeto        : HOJA DE TRABAJO                                              *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
***
sele 1
use CBDTAJUS order AJUS01 alias AJUS
if !used(1)
    close data
    return
endif

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
cTit4 = "HOJA DE TRABAJO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
*** CARGANDO EN UN VECTOR LAS CUENTAS DE AJUSTES ***
DIMENSION vCtaAju(20)
SELECT AJUS
SET ORDER TO AJUS02
GOTO TOP
MaxEle = 0
DO WHILE ! EOF()
   LsCodCta = CtaAju
   DO WHILE LsCodCta = CtaAju .AND. ! EOF()
      SKIP
   ENDDO
   MaxEle = MaxEle + 1
   IF MaxEle > ALEN(vCtaAju)
      DIMENSION vCtaAju(MaxEle + 1)
   ENDIF
   vCtaAju(MaxEle) = LsCodCta
ENDDO
SET ORDER TO AJUS03
GOTO TOP
DO WHILE ! EOF()
   LsCodCta = CtrAju
   DO WHILE LsCodCta = CtrAju .AND. ! EOF()
      SKIP
   ENDDO
   MaxEle = MaxEle + 1
   IF MaxEle > ALEN(vCtaAju)
      DIMENSION vCtaAju(MaxEle + 1)
   ENDIF
   vCtaAju(MaxEle) = LsCodCta
ENDDO
IF MaxEle > 0
   DIMENSION vCtaAju(MaxEle)
   =ASORT(vCtaAju)
ENDIF

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69

DO LIB_MTEC WITH 16
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
@ 10,26 SAY     "MONEDA : "
@ 11,26 SAY     "TIPO   : "
@ 12,24 SAY   "CONDICION: "
XiCodMon= Elige(1,10,36,2)
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
VecOpc(1)="MENSUAL           "
VecOpc(2)="ACUMULADO         "
XiTipo  = Elige(1,11,36,2)
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
VecOpc(1)="AJUSTADO "
VecOpc(2)="HISTORICO"
XiTipo2 = Elige(2,12,36,2)
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
*** Pantalla de datos  ***
IF XiTipo2 = 2
   ArcTmp = SYS(3)
   SELE AJUS
   SET ORDER TO AJUS02
   SELE ACCT
   SET RELA TO CODCTA INTO AJUS
   SET RELA TO CODCTA INTO CTAS ADDITIVE
   COPY TO &ArcTmp FOR CTAS.AFTMOV="S" .AND. !CodCta==AJUS->CtaAju WITH CDX
   SET RELA TO
   SELE AJUS
   SET ORDER TO AJUS01
   SELE 2
   USE &ArcTmp ORDER ACCT01 ALIAS ACCT
   IF !USED()
      CLOSE DATA
      DELE FILE &ArcTmp..DBF
      DELE FILE &ArcTmp..CDX
      RETURN
   ENDIF
ENDIF
SELE CTAS
SET ORDER TO CTAS02
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
Ancho = 210
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 66 - 8
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo    = "H O J A    D E    T R A B A J O"
SubTitulo = "MES "+MES(_MES,1)+" "+TRANS(_ANO,"9999")
En1 = TRIM(VECOPC(XiCodMon))
En2 = " "
En3 = _PRN6a+IIF(XiTipo=1,"M E N S U A L","A C U M U L A D O")+_Prn6b
En4 = IIF(XiTipo2=1,"A J U S T A D O","H I S T O R I C O")
En5 = ""
En6 = "*********** ************************************ ******************************* ******************************* ******************************* ******************************* *******************************"
En7 = "                                                            S U M A S                      S A L D O S              AJUSTES Y LIQUIDACIONES                INVENTARIOS                      G.  Y  P.           "
En8 = "CODIGO         CUENTAS DEL MAYOR                       DEBE           HABER          DEUDOR         ACREEDOR                                          ACTIVO         PASIVO         PERDIDAS        GANANCIAS   "
En9 = "*********** ************************************ *************** *************** *************** *************** *************** *************** *************** *************** *************** ***************"
*      0********** 12********************************** 49************* 65************* 81************* 97************* 113************ 129************ 145************ 161************
*      123456789-  123456789-123456789-123456789-123456 9999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99
***
Cancelar = .F.
SET DEVICE TO PRINT
SET MARGIN TO 0
NumCol = 10
DIMENSION X(NumCol),Y(NumCol),Z(NumCol)
PRINTJOB
   Inicio = .T.
   SEEK "1"
   NumPag  = 0
   STORE 0 TO X,Y,Z
   DO BLOQUE
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
IF XiTipo2 = 2
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
ENDIF
RETURN

******************
PROCEDURE BLOQUE
******************
PARAMETER TOPE
IF Cancelar
   RETURN
ENDIF
XfDebe   = 0
XfHaber  = 0
NroItm1 = 0
STORE 0 TO X,Y
DO WHILE  ! EOF() .and. ! Cancelar .AND. NivCta = 1
   IF XiTipo2=2
      DO CBDACUMD WITH TRIM(CodCta),0, _Mes
   ELSE
      DO CBDACUMD WITH CodCta,0, _Mes
   ENDIF
   SELECT CTAS
   STORE 0 TO X
   IF XiTipo=1
      X(1) = XvCalc(1+INC)
      X(2) = XvCalc(2+INC)
   ELSE
      X(1) = XvCalc(4+INC)
      X(2) = XvCalc(5+INC)
   ENDIF
   IF X(1) = 0 .AND. X(2) = 0
      SKIP
      LOOP
   ENDIF
   DO Saldos
   X(3) = XfDebe
   X(4) = XfHaber
   DO CASE
      CASE CODCTA<"6"
         X(7) = X(3)+X(5)
         X(8) = X(4)+X(6)
      OTHER
         X(9) = X(3)+X(5)
         X(10)= X(4)+X(6)
   ENDCASE
   DO AJUSTE
   NroItm1 = NroItm1 + 1
   DO ResetPag
   NumLin = PROW() + 1
   @ Numlin,01 SAY CodCta
   @ Numlin,12 SAY Nomcta               PICT "@S36"
   FOR i=1 to 10
     Col = (i-1)*16 + 49
     y(i) = y(i) + x(i)
     @ Numlin,Col SAY X(i)    PICT "@(Z 99,999,999.99"
   ENDFOR
   SKIP
   Cancelar = (Inkey()=Escape)
ENDDO
IF NroItm1 > 0
   DO ResetPag
   NumLin = PROW() + 1
   FOR i=1 to 10
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY "---------------"
   ENDFOR
   NumLin = PROW() + 1
   FOR i=1 to 10
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY Y(i)    PICT "@(Z 99,999,999.99"
   ENDFOR
   NumLin = PROW() + 1
   FOR i=1 to 10
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY "---------------"
   ENDFOR
   NumLin = PROW() + 1
   IF Y(7) > Y(8)
     i = 8
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY Y(i-1)-Y(i) PICT "@(Z 99,999,999.99"
     Y(i) = Y(i-1)
   ELSE
     i = 7
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY Y(i+1)-Y(i) PICT "@(Z 99,999,999.99"
     Y(i) = Y(i+1)
   ENDIF
   IF Y(9) > Y(10)
     i = 10
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY Y(i-1)-Y(i) PICT "@(Z 99,999,999.99"
     Y(i) = Y(i-1)
   ELSE
     i = 9
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY Y(i+1)-Y(i) PICT "@(Z 99,999,999.99"
     Y(i) = Y(i+1)
   ENDIF
   NumLin = PROW() + 1
   FOR i=7 to 10
     Col = (i-1)*16 + 49
     @ Numlin,Col SAY "---------------"
   ENDFOR
   NumLin = PROW() + 1
   FOR i=7 to 10
     Col = (i-1)*16 + 49
     z(i) = z(i) + y(i)
     @ Numlin,Col SAY Y(i)    PICT "@(Z 99,999,999.99"
   ENDFOR
ENDIF


******************
PROCEDURE SALDOS
******************
IF ! INLIST(LsCodCta,"10")
    IF XiTipo = 1
       IF XvCalc(3+INC) > 0
          XfDebe = XvCalc(3+INC)
          XfHaber= 0
       ELSE
          XfDebe  = 0
          XfHaber = -XvCalc(3+INC)
       ENDIF
    ELSE
       IF XvCalc(6+INC) > 0
          XfDebe = XvCalc(6+INC)
          XfHaber= 0
       ELSE
          XfDebe  = 0
          XfHaber = -XvCalc(6+INC)
       ENDIF
    ENDIF
    RETURN
ENDIF
LnOrder  = ORDER()
RegAct = RECNO()
LsCodCta = TRIM(CodCta)
SET ORDER TO CTAS01
XfDebe   = 0
XfHaber  = 0
Seek LsCodCta
DO WHILE ! EOF() .AND. CodCta = LsCodCta
   IF AftMov = "S"
      SELECT ACCT
      SET ORDER TO ACCT02
      SEEK CTAS->CodCta
      DO WHILE (CodCta=CTAS->CodCta) .AND. ! EOF()
         LfDebe   = 0
         LfHaber  = 0
         xLLave = CodCta+CodRef
         DO WHILE (CodCta+CodRef = xLLave) .AND. ! EOF()
            IF XiTipo = 1
               IF  NroMes = STR(_MES,2,0)
                   IF XiCodMon = 1
                      LfDebe  = LfDebe  + DbeNac
                      LfHaber = LfHaber + HbeNac
                   ELSE
                      LfDebe  = LfDebe  + DbeExt
                      LfHaber = LfHaber + HbeExt
                   ENDIF
               ENDIF
            ELSE
               IF  NroMes <= STR(_MES,2,0)
                   IF XiCodMon = 1
                      LfDebe  = LfDebe  + DbeNac
                      LfHaber = LfHaber + HbeNac
                   ELSE
                      LfDebe  = LfDebe  + DbeExt
                      LfHaber = LfHaber + HbeExt
                   ENDIF
               ENDIF
            ENDIF
            SKIP
         ENDDO
         IF LfDebe > LfHaber
            XfDebe  = XfDebe  + (LfDebe - LfHaber)
         ELSE
            XfHaber = XfHaber - (LfDebe - LfHaber)
         ENDIF
      ENDDO
      SELECT CTAS
   ENDIF
   SKIP
ENDDO
SELECT ACCT
SET ORDER TO ACCT01
SELECT CTAS
SET ORDER TO (LnOrder)
GOTO RegAct
RETURN

****************
PROCEDURE AJUSTE
****************
X(5) = 0
X(6) = 0
LfImport = 0
FOR I=1 TO MaxEle
    IF vCtaAju(i) = TRIM(CTAS->CodCta)
       DO CBDACUMD WITH vCtaAju(i),0, _Mes
       IF XiTipo = 1
          LfImport = LfImport + XvCalc(3+INC)
       ELSE
          LfImport = LfImport + XvCalc(6+INC)
       ENDIF
    ENDIF
NEXT
IF LfImport >= 0
   X(5) = LFIMPORT
ELSE
   X(6) = -LFIMPORT
ENDIF

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
