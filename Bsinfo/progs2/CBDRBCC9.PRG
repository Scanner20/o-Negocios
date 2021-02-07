********************************************************************************
* Progrma       : CBDRBCC9.PRG                                                 *
* Objeto        : Analisis Clase 9 por Centro de Costos                        *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 17/04/95  VETT                                  - ATECO      *
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
cTit4 = "ANALISIS CLASE 9"
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
         VecOpc(1)="3"
         VecOpc(2)="6"
         VecOpc(3)="6 Detallado"
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
SEEK "9"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=6 .AND. INLIST(CodCta,"62","63","64","65","66","67","68") .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBENAC - HBENAC)#0 WHILE CODCTA="6"
ELSE
   COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=6 .AND. INLIST(CodCta,"62","63","64","65","66","67","68") .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBEEXT - HBEEXT)#0 WHILE CODCTA="6"
ENDIF
SET TALK OFF
SELECT 0
USE &ArcTmp
DO CASE
   CASE XiNroDig = 1
      INDEX ON CODCTA+CODREF TO  &ArcTmp
      SET INDEX TO &ArcTmp
      GOTO TOP
      DO IMP3D
   CASE XiNroDig = 2
      INDEX ON CODCTA+CODREF TO  &ArcTmp
      SET INDEX TO &ArcTmp
      GOTO TOP
      DO IMP5D
   CASE XiNroDig = 3
      INDEX ON Codref+Codcta TO  &ArcTmp
      SET INDEX TO &ArcTmp
      GOTO TOP
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
Ancho = 133
Cancelar = .F.
Saltopag = .T.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 9 por Centro de Costos"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = "---- ------------------------------ ----------------- ----------------- -----------------  ----------------- -----------------"
EN7 = "COD.                                      STOCK        REPRESENTACION       SERVICIOS            Sin                          "
EN8 = "CTA. D E S C R I P C I O N                 00                01                 02             C/Costo              T O T A L "
En9 = "---- ------------------------------ ----------------- ----------------- -----------------  ----------------- -----------------"

Import00 = 0
Import01 = 0
Import02 = 0
ImportXX = 0
Import97 = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   TotImp00 = 0
   TotImp01 = 0
   TotImp02 = 0
   TotImpxx = 0
   TotImp97 = 0
   NumPag   = 0


   Saltopag = .T.
   DO WHILE ! EOF() .AND. ! Cancelar
      TotQui00 = 0
      TotQui01 = 0
      TotQui02 = 0
      TotQuixx = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodCta,2)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodCta,2) .AND. ! Cancelar
         LsCodCta = LEFT(CodCta,3)
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
Import00 = 0
Import01 = 0
Import02 = 0
Importxx = 0
Import97 = 0
DO WHILE ! EOF() .AND. CodCta = LsCodCta
   IF XiCodMon = 1
      nImport = (HbeNac - DbeNac)*(-1)
   ELSE
      nImport = (HbeExt - DbeExt)*(-1)
   ENDIF

   DO CASE
      CASE CodRef = "00"
         Import00 = Import00 + nImport
      CASE CodRef = "01"
         Import01 = Import01 + nImport
      CASE CodRef = "02"
         Import02 = Import02 + nImport
      CASE EMPTY(CodReF)
         Importxx = Importxx + nImport
   ENDCASE
   SKIP
ENDDO

TotImp00 = TotImp00 + Import00
TotImp01 = TotImp01 + Import01
TotImp02 = TotImp02 + Import02
TotImpxx = TotImpxx + Importxx
TotImp97 = TotImp97 + Import97


TotQui00 = TotQui00 + Import00
TotQui01 = TotQui01 + Import01
TotQui02 = TotQui02 + Import02
TotQuixx = TotQuixx + Importxx
TotQui97 = TotQui97 + Import97

RETURN

****************
PROCEDURE LinImp
****************
=SEEK(LsCodCta,"CTAS")
DO ResetPag
NumLin = PROW() + 1
Total  = Import00 +  Import01 + Import02 + Importxx

@ NumLin,0   SAY LsCodCta      PICT "@S3"
@ NumLin,6   SAY CTAS->NomCta  PICT "@S30"
@ NumLin,36  SAY PICNUM(Import00)
@ NumLin,54  SAY PICNUM(Import01)
@ NumLin,72  SAY PICNUM(Import02)
@ NumLin,90  SAY PICNUM(Importxx)
@ NumLin,108 SAY PICNUM(Total)
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total  = TotQui00 +  TotQui01 + TotQui02 + TotQuiXX

NumLin = PROW() + 1
@ NumLin,36  SAY "-----------------"
@ NumLin,54  SAY "-----------------"
@ NumLin,72  SAY "-----------------"
@ NumLin,90  SAY "-----------------"
@ NumLin,108 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ....."
@ NumLin,36  SAY PICNUM(TotQui00)
@ NumLin,54  SAY PICNUM(TotQui01)
@ NumLin,72  SAY PICNUM(TotQui02)
@ NumLin,90  SAY PICNUM(TotQuixx)
@ NumLin,108 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*****************
PROCEDURE TotImp2
*****************
DO ResetPag
NumLin = PROW() + 2
Total  = TotImp00 +  TotImp01 + TotImp02 + TotImpXX

@ NumLin,16  SAY "* Total General.."
@ NumLin,36  SAY PICNUM(TotImp00)
@ NumLin,54  SAY PICNUM(TotImp01)
@ NumLin,72  SAY PICNUM(TotImp02)
@ NumLin,90  SAY PICNUM(TotImpXX)
@ NumLin,108 SAY PICNUM(Total)
RETURN

***************
PROCEDURE IMP5D
***************
Ancho = 137
Cancelar = .F.
Saltopag = .T.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 9 por Centro de Costo"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
EN6 = "------ ----------------------------------------  ----------------- ----------------- -----------------  ----------------- -----------------"
EN7 = "COD.                                                   STOCK        REPRESENTACION       SERVICIOS            Sin                          "
EN8 = "CUENTA D E S C R I P C I O N                            00                01                 02             C/Costo              T O T A L "
EN9 = "------ ----------------------------------------  ----------------- ----------------- -----------------  ----------------- -----------------"


Import00 = 0
Import01 = 0
Import02 = 0
Importxx = 0
Import97 = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   TotImp00 = 0
   TotImp01 = 0
   TotImp02 = 0
   TotImpxx = 0
   TotImp97 = 0
   NumPag   = 0


   Saltopag = .T.
   DO WHILE ! EOF() .AND. ! Cancelar
      TotQui00 = 0
      TotQui01 = 0
      TotQui02 = 0
      TotQuixx = 0
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
Total  = Import00 +  Import01 + Import02 + ImportXX

@ NumLin,0   SAY LsCodCta      PICT "@S6"
@ NumLin,7   SAY CTAS->NomCta  PICT "@S39"
@ NumLin,49  SAY PICNUM(Import00)
@ NumLin,67  SAY PICNUM(Import01)
@ NumLin,85  SAY PICNUM(Import02)
@ NumLin,103 SAY PICNUM(Importxx)
@ NumLin,121 SAY PICNUM(Total)
RETURN

*******************
PROCEDURE TotImp1_5
*******************
DO ResetPag
Total  = TotQui00 +  TotQui01 + TotQui02 + TotQuixx

NumLin = PROW() + 1
@ NumLin,49  SAY "-----------------"
@ NumLin,67  SAY "-----------------"
@ NumLin,85  SAY "-----------------"
@ NumLin,103 SAY "-----------------"
@ NumLin,121 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ....."
@ NumLin,49  SAY PICNUM(TotQui00)
@ NumLin,67  SAY PICNUM(TotQui01)
@ NumLin,85  SAY PICNUM(TotQui02)
@ NumLin,103 SAY PICNUM(TotQuixx)
@ NumLin,121 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*******************
PROCEDURE TotImp2_5
*******************
DO ResetPag
NumLin = PROW() + 2
Total  =  TotImp00 +  TotImp01 + TotImp02 + TotImpXx

@ NumLin,16  SAY "* Total General.."
@ NumLin,49  SAY PICNUM(TotImp00)
@ NumLin,67  SAY PICNUM(TotImp01)
@ NumLin,85  SAY PICNUM(TotImp02)
@ NumLin,103 SAY PICNUM(TotImpxx)
@ NumLin,121 SAY PICNUM(Total)
RETURN


******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltoPag
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
   Saltopag = .F.
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
Ancho = 117
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
TITULO  = ""
SubTitulo = "ANALISIS CLASE 6 POR CENTRO DE COSTOS"
En1 = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En2 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En3 = "<HORA : "+TIME()
En4 = " "
En5 = ""
En6 = "*********************************************************************************************************************"
En7 = "                                                  *      MOVIMIENTO     *      MOVIMIENTO     *      MOVIMIENTO     *"
En8 = "CUENTA        D E S C R I P C I O N               *     MES ANTERIOR    *       DEL MES       *       ACUMULADO     *"
En9 = "*********************************************************************************************************************"
*      0      7      14---789-123456789-123456789-123456 *51---------------    *73---------------    *95---------------    *

ImportMA = 0
ImportMM = 0
ImportAA = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   GOTO TOP
   NumPag= 0
   TOT10 = 0
   TOT20 = 0
   TOT30 = 0
   DO WHILE ! EOF() .AND. ! Cancelar
      TOT12 = 0
      TOT22 = 0
      TOT32 = 0
      LsCodCta = []
      LsCodRef = CodRef
      Saltopag = .T.
      =SEEK("007"+LsCodRef,"AUXI")
      En5      = "Centro de costo : "+TRIM(LsCodRef)+" "+TRIM(AUXI->NomAux)
      DO WHILE ! EOF() .AND. CodRef = LsCodRef .AND. ! Cancelar
         DO CaLCULO1
         DO LinImp_5D
         Cancelar = INKEY() = Escape
      ENDDO
      NumLin = PROW() + 1
      @ NumLin,0  SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,12 SAY "TOTAL X C/Costo      "+LsCodRef
      @ NumLin,51  SAY PICNUM(Tot12)
      @ NumLin,73  SAY PICNUM(Tot22)
      @ NumLin,95  SAY PICNUM(Tot32)
      TOT10 = TOT10 + TOT12
      TOT20 = TOT20 + TOT22
      TOT30 = TOT30 + TOT32
   ENDDO
   NumLin = PROW() + 2
   @ NumLin,12 SAY "TOTAL GENERAL        "
   @ NumLin,51  SAY PICNUM(Tot10)
   @ NumLin,73  SAY PICNUM(Tot20)
   @ NumLin,95  SAY PICNUM(Tot30)
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
=SEEK(LsCodCta,"CTAS")
NumLin = PROW() + 1
@ NumLin,0  SAY LsCodCta
@ NumLin,14 SAY CTAS->NomCta   PICT "@S35"
*=SEEK("007"+LsCodRef,"AUXI")
*@ NumLin,08 SAY LsCodRef      PICT "@S5"
*@ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
@ NumLin,51  SAY PICNUM(ImportMA)
@ NumLin,73  SAY PICNUM(ImportMM)
@ NumLin,95  SAY PICNUM(ImportAA)
RETURN
******************
PROCEDURE Calculo1
******************
ImportMA = 0
ImportMM = 0
ImportAA = 0
LsCodCta = CodCta
DO WHILE ! EOF() .AND. CodRef = LsCodRef .AND. CodCta=LsCodCta
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF
   ImportAA = ImportAA + nImport
   IF  VAL(NroMes) = XiMesFin
      ImportMM = ImportMM + nImport
   ENDIF
   IF  VAL(NroMes) = XiMesFin - 1
      ImportMA = ImportMA + nImport
   ENDIF
   SKIP
ENDDO
TOT12 = TOT12 + ImportMA
TOT22 = TOT22 + IMportMM
TOT32 = TOT32 + IMportAA
RETURN
