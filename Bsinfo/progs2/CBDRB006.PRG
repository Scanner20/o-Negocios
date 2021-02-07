********************************************************************************
* Progrma       : CBDRB001.PRG                                                 *
* Objeto        : BALANCE GENERAL ACUMULADO                                    *
* Autor         : Mauro                                                        *
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
use cbdmctas order ctas02 alias CTAS
if !used(3)
    close data
    return
endif
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "BALANCE DE SALDOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

DO LIB_MTEC WITH 16
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
XsCtaDes = SPACE(LEN(CTAS->CODCTA))
XsCtaHas = SPACE(LEN(CTAS->CODCTA))
XnNivCta = 2
@ 10,32 SAY " Moneda : "
@ 11,26 SAY "Hasta que Nivel (1-5) :"
@ 12,23 SAY "Cuenta Desde  : "
@ 13,23 SAY "Cuenta Hasta  : "
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i =1
         XiCodMon= Elige(1,10,42,2)
      CASE i =2
         @ 11,52 GET XnNivCta PICTURE "#" RANGE 1,9
         READ
         UltTecla = LASTKEY()
      CASE i =3
         @ 12,42 GET XsCtaDes PICTURE "@!"
         @ 13,42 GET XsCtaHas PICTURE "@!"
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
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",5)
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
Ancho = 255
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo    = "BALANCE GENERAL ACUMULADO"
SubTitulo = "MES "+MES(_MES,1)+" "+TRANS(_ANO,"9999")
En1 = "(EXPRESADO EN "+ TRIM(VECOPC(XiCodMon))+")"
En2 = " "
En3 = ""
En4 = ""
En5 = "************** *******************************************   ************************************** *************************************  *************************************  *************************************  "
En6 = "                                                                      S    U    M    A    S                     S   A   L   D   O   S                    I N V E N T A R I O               RESULTADO POR NATURALEZA      "
En7 = "CODIGO         DESCRIPCION                                         D E B E            H A B E R           DEUDOR            ACREEDOR             ACTIVO             PASIVO             PERDIDAS           GANANCIA       "
En8 = "************** *******************************************   ******************* ****************** ****************** ******************  ****************** ******************  ****************** ******************  "
En5 = En5 + "************************************* "
En6 = En6 + "          RESULTADO POR FUNCION       "
En7 = En7 + "     PERDIDAS           GANANCIA      "
En8 = En8 + "****************** ****************** "
En9 = []

Cancelar = .F.
Formato = "@Z( "+RIGHT('9,999,999,999.99',16)
SET DEVICE TO PRINT
SET MARGIN TO 0
NumCol = 10
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),XZ(10)
SELECT CTAS
IF XnNivCta = 1
   SEEK '1'+TRIM(XsCtaDes)
ELSE
   SET ORDER TO CTAS01
   SEEK TRIM(XsCtaDes)
ENDIF
IF ! FOUND()
   CLOSE DATA
   RETURN
ENDIF
iNumReg = recno()
PRINTJOB
   Inicio = .T.
   NumPag  = 0
   STORE 0 TO X,Y,Z,XZ
   DO BLOQUE WITH "AA"
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

****************
PROCEDURE BLOQUE
****************
PARAMETER TOPE
IF Cancelar
   RETURN
ENDIF
XfDebe   = 0
XfHaber  = 0
NroItm1 = 0
NumLin = PROW()+1                           && Linea Actual
STORE 0 TO X,Y
DO WHILE ! EOF() .and. ! Cancelar .AND. CodCta <=XsCtaHas
   IF NivCta > XnNivCta
      SKIP
      LOOP
   ENDIF
   Tb=(NivCta-1)
   IF Tb<0 .OR. Tb>5
      Tb=5
   ENDIF
   DO CBDACUMD WITH CodCta,0, _Mes
   STORE 0 TO X
   X(1)  = XvCalc(4+INC)
   X(2)  = XvCalc(5+INC)
   Saldo = XvCalc(6+INC)
   IF X(1) = 0 .AND. X(2) = 0
      SKIP
      LOOP
   ENDIF
   IF Saldo > 0
      X(3) =  Saldo
   ELSE
      X(4) = -Saldo
   ENDIF
   NroItm1 = NroItm1 + 1
   IF NivCta = XnNivCta
      IF CodCta < "60"
         X(5) = X(3)
         X(6) = X(4)
      ENDIF
      IF CodCta = "69"
         IF Saldo = 0
            X(9)=X(1+INC)
         ENDIF
      ENDIF
      *** Estado de Perdidas por Naturaleza **
      IF (TpoCta = 1 .OR. TpoCta = 3) .AND. CodCta >= '60'
         IF Saldo > 0
            X(7) = X(3)
         ELSE
            X(8) = X(4)
         ENDIF
      ENDIF
      *** Estado de Perdidas por Funcion    **
      IF (TpoCta = 2 .OR. TpoCta = 3)  .AND. CodCta >= '60'
         IF Saldo > 0
            X(9)  = X(3)
         ELSE
            X(10) = X(4)
         ENDIF
      ENDIF
   ENDIF
   IF X(1) = 0 .AND. X(2) = 0 .AND. XsSolMov = "S"
      RETURN
   ENDIF
   DO ResetPag
   NumLin = PROW() + 1
   @ NumLin,Tb SAY TRIM(CodCta)
   @ NumLin,15 SAY SUBSTR(NomCta,1,40)
   TnJ = 1
   DO WHILE TnJ <= 10
      @ NumLin,37+20*TnJ SAY X(TnJ) PICTURE Formato
      IF NivCta = XnNivCta
         XZ(TnJ) = XZ(TnJ) + X(TnJ)
      ENDIF
      TnJ = TnJ + 1
   ENDDO
   ********
   SKIP
   Cancelar = (Inkey()=Escape)
ENDDO
IF NroItm1 > 0
   DO ResetPag
   NumLin = PROW() + 1
   @ NumLin,57  SAY REPLICATE("-",Ancho - 57)
   NumLin = NumLin + 1
   TnJ = 1
   DO WHILE TnJ <= 10
      @ NumLin , 37+20*TnJ SAY XZ(TnJ) PICTURE Formato
      TnJ = TnJ + 1
   ENDDO
   NumLin = NumLin + 1

   IF XZ(6) > XZ(5)
      Saldo = XZ(6) - XZ(5)
      XZ(5) = XZ(5) + Saldo
      @ NumLin,137 SAY Saldo   PICTURE Formato
   ELSE
      Saldo = XZ(5) - XZ(6)
      XZ(6) = XZ(6) + Saldo
      @ NumLin,157 SAY Saldo   PICTURE Formato
   ENDIF

   IF XZ(8) > XZ(7)
      Saldo = XZ(8) - XZ(7)
      XZ(7) = XZ(7) + Saldo
      @ NumLin,177 SAY Saldo   PICTURE Formato
   ELSE
      Saldo = XZ(7) - XZ(8)
      XZ(8) = XZ(8) + Saldo
      @ NumLin,197 SAY Saldo   PICTURE Formato
   ENDIF

   IF XZ(10) > XZ(9)
      Saldo = XZ(10) - XZ(9)
      XZ(9) = XZ(9) + Saldo
      @ NumLin,217 SAY Saldo   PICTURE Formato
   ELSE
      Saldo  = XZ(9) - XZ(10)
      XZ(10) = XZ(10) + Saldo
      @ NumLin,237 SAY Saldo   PICTURE Formato
   ENDIF
   NumLin = NumLin + 1

   @ NumLin,137 SAY REPLICATE("-",118)
   NumLin = NumLin + 1

   @ NumLin,137 SAY XZ(5)  PICTURE Formato
   @ NumLin,157 SAY XZ(6)  PICTURE Formato
   @ NumLin,177 SAY XZ(7)  PICTURE Formato
   @ NumLin,197 SAY XZ(8)  PICTURE Formato
   @ NumLin,217 SAY XZ(9)  PICTURE Formato
   @ NumLin,237 SAY XZ(10) PICTURE Formato
   STORE 0 TO XZ
ENDIF
RETURN

******************
PROCEDURE RESETPAG
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