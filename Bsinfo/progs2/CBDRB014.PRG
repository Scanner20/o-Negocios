********************************************************************************
* Progrma       : CBDRB014.PRG                                                 *
* Objeto        : Analisis Clase 6 por Centro de Costos                       *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
sele 3
use cbdmauxi order auxi01 alias AUXI
if !used(3)
    close data
    return
endif
sele 2
use cbdacmct order acct02 alias ACCT
if !used(2)
    close data
    return
endif
sele 1
use cbdmctas order CTAS01 alias CTAS
if !used(1)
    close data
    return
endif

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS CLASE 6"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni = 1
XiMesFin = _Mes
XiNroDig = 1

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
@ 13,24 SAY "DIGITOS    : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,38,2)
      CASE i = 2
         @ 11,38 GET XiMesIni PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,38 GET XiMesFin PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         VecOpc(1)="4"
         VecOpc(2)="8"
         VecOpc(3)="8 Detallado"
         XiNroDig= Elige(1,13,38,3)
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
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"


@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp = Pathuser+SYS(3)
SELECT ACCT
SEEK "6"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=8 .AND. INLIST(CodCta,"607","61","62","63","64","65","67","68",[71],[72]) .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBENAC - HBENAC)#0 WHILE CODCTA<="7"
ELSE
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=8 .AND. INLIST(CodCta,"607","61","62","63","64","65","67","68",[71],[72]) .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBEEXT - HBEEXT)#0 WHILE CODCTA<="7"
ENDIF
SET TALK OFF
SELECT 0
USE &ArcTmp
INDEX ON CODCTA+CODREF TO  &ArcTmp
GOTO TOP
DO CASE
   CASE XiNroDig = 1
      DO IMP3D
   CASE XiNroDig = 2
      DO IMP5D
   CASE XiNroDig = 3
      DO IMP5D_D
ENDCASE
CLOSE DATA

DELETE FILE &ArcTmp..dbf
DELETE FILE &ArcTmp..idx
RETURN
RETURN


***************
PROCEDURE IMP3D
***************
Ancho = 162
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 6 por Centro de Costos"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = "---- ------------------------------ ----------------------------------------------------- ----------------- ----------------- ----------------- -----------------"
EN7 = "COD.                                                                                                                                                             "
EN8 = "CTA. D E S C R I P C I O N                 91                92                 93                94               95                97              T O T A L   "
En9 = "---- ------------------------------ ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"

Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import97 = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   TotImp91 = 0
   TotImp92 = 0
   TotImp93 = 0
   TotImp94 = 0
   TotImp95 = 0
   TotImp97 = 0
   NumPag   = 0


   DO WHILE ! EOF() .AND. ! Cancelar
      TotQui91 = 0
      TotQui92 = 0
      TotQui93 = 0
      TotQui94 = 0
      TotQui95 = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodCta,2)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodCta,2) .AND. ! Cancelar
         LsCodCta = LEFT(CodCta,4)
         DO CaLCULO
         DO LinImp
         Cancelar = INKEY() = Escape
      ENDDO
      IF ! Cancelar
         DO TotImp1
      ENDIF
   ENDDO
   IF ! Cancelar
      DO TotImp2
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RETURN


*****************
PROCEDURE Calculo
*****************
Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import97 = 0
DO WHILE ! EOF() .AND. CodCta = LsCodCta
   IF XiCodMon = 1
      nImport = (HbeNac - DbeNac)*(-1)
   ELSE
      nImport = (HbeExt - DbeExt)*(-1)
   ENDIF

   DO CASE
      CASE CodRef = "91"
         Import91 = Import91 + nImport
      CASE CodRef = "92"
         Import92 = Import92 + nImport
      CASE CodRef = "93"
         Import93 = Import93 + nImport
      CASE CodRef = "94"
         Import94 = Import94 + nImport
      CASE CodRef = "95"
         Import95 = Import95 + nImport
      CASE CodRef = "97"
         Import97 = Import97 + nImport
   ENDCASE
   SKIP
ENDDO

TotImp91 = TotImp91 + Import91
TotImp92 = TotImp92 + Import92
TotImp93 = TotImp93 + Import93
TotImp94 = TotImp94 + Import94
TotImp95 = TotImp95 + Import95
TotImp97 = TotImp97 + Import97


TotQui91 = TotQui91 + Import91
TotQui92 = TotQui92 + Import92
TotQui93 = TotQui93 + Import93
TotQui94 = TotQui94 + Import94
TotQui95 = TotQui95 + Import95
TotQui97 = TotQui97 + Import97

RETURN

****************
PROCEDURE LinImp
****************
=SEEK(LsCodCta,"CTAS")
DO ResetPag
NumLin = PROW() + 1
Total  = Import91 +  Import92 + Import93 + Import94 +  Import95 + Import97

@ NumLin,0   SAY LsCodCta      PICT "@S4"
@ NumLin,6   SAY CTAS->NomCta  PICT "@S30"
@ NumLin,36  SAY PICNUM(Import91)
@ NumLin,54  SAY PICNUM(Import92)
@ NumLin,72  SAY PICNUM(IMport93)
@ NumLin,90  SAY PICNUM(Import94)
@ NumLin,108 SAY PICNUM(Import95)
@ NumLin,126 SAY PICNUM(Import97)
@ NumLin,144 SAY PICNUM(Total)
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total  = TotQui91 +  TotQui92 + TotQui93 + TotQui94 +  TotQui95 + TotQui97

NumLin = PROW() + 1
@ NumLin,36  SAY "-----------------"
@ NumLin,54  SAY "-----------------"
@ NumLin,72  SAY "-----------------"
@ NumLin,90  SAY "-----------------"
@ NumLin,108 SAY "-----------------"
@ NumLin,126 SAY "-----------------"
@ NumLin,144 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ....."
@ NumLin,36  SAY PICNUM(TotQui91)
@ NumLin,54  SAY PICNUM(TotQui92)
@ NumLin,72  SAY PICNUM(TotQui93)
@ NumLin,90  SAY PICNUM(TotQui94)
@ NumLin,108 SAY PICNUM(TotQui95)
@ NumLin,126 SAY PICNUM(TotQui97)
@ NumLin,144 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*****************
PROCEDURE TotImp2
*****************
DO ResetPag
NumLin = PROW() + 2
Total  = TotImp91 +  TotImp92 + TotImp93 + TotImp94 +  TotImp95 + TotImp97

@ NumLin,16  SAY "* Total General.."
@ NumLin,36  SAY PICNUM(TotImp91)
@ NumLin,54  SAY PICNUM(TotImp92)
@ NumLin,72  SAY PICNUM(TotImp93)
@ NumLin,90  SAY PICNUM(TotImp94)
@ NumLin,108 SAY PICNUM(TotImp95)
@ NumLin,126 SAY PICNUM(TotImp97)
@ NumLin,144 SAY PICNUM(Total)
RETURN

***************
PROCEDURE IMP5D
***************
Ancho = 174
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 6 por Centro de Costo"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
EN6 = "------ ---------------------------------------- ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"
EN7 = "COD.                                                                                                                                                                         "
EN8 = "CUENTA D E S C R I P C I O N                            91                92               93                94                95                97              TOTAL       "
EN9 = "------ ---------------------------------------- ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"


Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import97 = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   TotImp91 = 0
   TotImp92 = 0
   TotImp93 = 0
   TotImp94 = 0
   TotImp95 = 0
   TotImp97 = 0
   NumPag   = 0


   DO WHILE ! EOF() .AND. ! Cancelar
      TotQui91 = 0
      TotQui92 = 0
      TotQui93 = 0
      TotQui94 = 0
      TotQui95 = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodCta,2)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodCta,2) .AND. ! Cancelar
         LsCodCta = CodCta
         DO CaLCULO
         DO LinImp_5
         Cancelar = INKEY() = Escape
      ENDDO
      IF ! Cancelar
         DO TotImp1_5
      ENDIF
   ENDDO
   IF ! Cancelar
      DO TotImp2_5
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RETURN


******************
PROCEDURE LinImp_5
******************
=SEEK(LsCodCta,"CTAS")
DO ResetPag
NumLin = PROW() + 1
Total  = Import91 +  Import92 + Import93 + Import94 +  Import95 + Import97

@ NumLin,0   SAY LsCodCta      PICT "@S8"
@ NumLin,9   SAY CTAS->NomCta  PICT "@S35"
@ NumLin,47  SAY PICNUM(Import91)
@ NumLin,65  SAY PICNUM(Import92)
@ NumLin,83  SAY PICNUM(Import93)
@ NumLin,101 SAY PICNUM(Import94)
@ NumLin,119 SAY PICNUM(Import95)
@ NumLin,137 SAY PICNUM(Import97)
@ NumLin,155 SAY PICNUM(Total)
RETURN

*******************
PROCEDURE TotImp1_5
*******************
DO ResetPag
Total  = TotQui91 +  TotQui92 + TotQui93 + TotQui94 +  TotQui95 + TotQui97

NumLin = PROW() + 1
@ NumLin,47  SAY "-----------------"
@ NumLin,65  SAY "-----------------"
@ NumLin,83  SAY "-----------------"
@ NumLin,101 SAY "-----------------"
@ NumLin,119 SAY "-----------------"
@ NumLin,137 SAY "-----------------"
@ NumLin,155 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ....."
@ NumLin,47  SAY PICNUM(TotQui91)
@ NumLin,65  SAY PICNUM(TotQui92)
@ NumLin,83  SAY PICNUM(TotQui93)
@ NumLin,101 SAY PICNUM(TotQui94)
@ NumLin,119 SAY PICNUM(TotQui95)
@ NumLin,137 SAY PICNUM(TotQui97)
@ NumLin,155 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*******************
PROCEDURE TotImp2_5
*******************
DO ResetPag
NumLin = PROW() + 2
Total  = TotImp91 +  TotImp92 + TotImp93 + TotImp94 +  TotImp95 + TotImp97

@ NumLin,16  SAY "* Total General.."
@ NumLin,47  SAY PICNUM(TotImp91)
@ NumLin,65  SAY PICNUM(TotImp92)
@ NumLin,83  SAY PICNUM(TotIMp93)
@ NumLin,101 SAY PICNUM(TotImp94)
@ NumLin,119 SAY PICNUM(TotImp95)
@ NumLin,137 SAY PICNUM(TotImp97)
@ NumLin,155 SAY PICNUM(Total)
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


****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"99,999,999,999.99")+"-"
ELSE
   RETURN TRANSF( Valor,"99,999,999,999.99")+" "
ENDIF


*****************
PROCEDURE IMP5D_D
*****************

Ancho = 95
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN2+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
TITULO  = ""
SubTitulo = ""
En1 = "ANALISIS CLASE 6 POR CENTRO DE COSTOS"
En2 = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En3 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En4 = "<HORA : "+TIME()
En5 = ""
En6 = "***********************************************************************************************"
En7 = "       CTRO.                                      *      MOVIMIENTO     *      MOVIMIENTO     *"
En8 = "CUENTA COSTO  D E S C R I P C I O N               *       DEL MES       *       ACUMULADO     *"
En9 = "***********************************************************************************************"
*      0      7      14---789-123456789-123456789-123456 *51---------------    *73---------------    *

ImportMM = 0
ImportAA = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   NumPag   = 0
   TOT10 = 0
   TOT20 = 0
   DO WHILE ! EOF() .AND. ! Cancelar
      TOT11 = 0
      TOT21 = 0
      LsCodCta = CodCta
      DO WHILE ! EOF() .AND. CodCta = LsCodCta .AND. ! Cancelar
         lQuiebre = .T.
         LsCodRef2d = LEFT(CodRef,2)
         TOT12 = 0
         TOT22 = 0
         DO WHILE ! EOF() .AND. CodCta = LsCodCta .AND. ! Cancelar .AND. LsCodRef2d = LEFT(CodRef,2)
            LsCodRef = CodRef
            DO CaLCULO1
            DO LinImp_5D
            Cancelar = INKEY() = Escape
         ENDDO
         NumLin = PROW() + 1
         @ NumLin,12 SAY "**** "+LsCodRef2d+" ****"
         @ NumLin,50 SAY "*"
         @ NumLin,51  SAY PICNUM(Tot12)
         @ NumLin,72  SAY "*"
         @ NumLin,73  SAY PICNUM(Tot22)
         @ NumLin,94  SAY "*"
         TOT11 = TOT11 + TOT12
         TOT21 = TOT21 + TOT22
      ENDDO
      NumLin = PROW() + 1
      @ NumLin,0  SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,12 SAY "TOTAL X CUENTA       "+LsCodCta
      @ NumLin,50 SAY "*"
      @ NumLin,51  SAY PICNUM(Tot11)
      @ NumLin,72  SAY "*"
      @ NumLin,73  SAY PICNUM(Tot21)
      @ NumLin,94  SAY "*"
      TOT10 = TOT10 + TOT11
      TOT20 = TOT20 + TOT21
   ENDDO
   NumLin = PROW() + 2
   @ NumLin,12 SAY "TOTAL GENERAL        "
   @ NumLin,50 SAY "*"
   @ NumLin,51  SAY PICNUM(Tot10)
   @ NumLin,72  SAY "*"
   @ NumLin,73  SAY PICNUM(Tot20)
   @ NumLin,94  SAY "*"
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RETURN


*******************
PROCEDURE LinImp_5D
*******************
DO ResetPag
IF lQuiebre
   lQuiebre = .F.
   =SEEK(LsCodCta,"CTAS")
   NumLin = PROW() + 1
   @ NumLin,0  SAY LsCodCta
   @ NumLin,14 SAY CTAS->NomCta
   NumLin = PROW() + 1
   @ NumLin,0  SAY ""
ENDIF
=SEEK(CTAS->ClfAux+LsCodRef,"AUXI")
NumLin = PROW() + 1
@ NumLin,08 SAY LsCodRef      PICT "@S5"
@ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
@ NumLin,50 SAY "*"
@ NumLin,51  SAY PICNUM(ImportMM)
@ NumLin,72  SAY "*"
@ NumLin,73  SAY PICNUM(ImportAA)
@ NumLin,94  SAY "*"
RETURN

NumLin = PROW() + 1
@ NumLin,12 SAY "TOTAL X CUENTA       "+LsCodCta
@ NumLin,50 SAY "*"
@ NumLin,51  SAY PICNUM(Tot11)
@ NumLin,72  SAY "*"
@ NumLin,73  SAY PICNUM(Tot12)
@ NumLin,94  SAY "*"

******************
PROCEDURE Calculo1
******************
ImportMM = 0
ImportAA = 0
DO WHILE ! EOF() .AND. CodRef = LsCodRef .AND. CodCta = LsCodCta
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF

   ImportAA = ImportAA + nImport
   IF  VAL(NroMes) = XiMesFin
      ImportMM = ImportMM + nImport
   ENDIF

   SKIP
ENDDO

TOT12 = TOT12 + ImportMM
TOT22 = TOT22 + IMportAA

RETURN


