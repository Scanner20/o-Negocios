********************************************************************************
* Progrma       : CBDRB013.PRG                                                 *
* Objeto        : Analisis Clase 9 y 6 Por Tipo Gasto                          *
* Autor         : VETT                                                         *
* Creaci¢n      : 13/07/95                                                     *
* Actualizaci¢n :                                                              *
********************************************************************************
*** Abrimos Bases ****
DIMENSION vCLFGTO(10)
vCLFGTO(01) = "000-099  ESTABLO - ALIMENTO GANADO Y OTROS"
vCLFGTO(02) = "100-199  PLANTA  - INSUMOS                "
vCLFGTO(03) = "200-299  PLANTA  - ENVASES                "
vCLFGTO(04) = "300-399  GASTOS DE PERSONAL               "
vCLFGTO(05) = "400-429  GASTOS DE PROMOCION Y PROPAGANDA "
vCLFGTO(06) = "430-499  GASTOS GENERALES                 "
vCLFGTO(07) = "                                          "
vCLFGTO(08) = "                                          "
vCLFGTO(09) = "                                          "
vCLFGTO(10) = "                                          "


sele 3
use cbdmctas order CTAS01 alias CTAS
if !used(3)
    close data
    return
endif
**
sele 2
use cbdacmct order acct02 alias ACCT
if !used(2)
    close data
    return
endif
**
sele 1
use cbdmauxi order AUXI01 alias AUXI
if !used(1)
    close data
    return
endif
**
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS CLASE 9 Y 6 POR TIPO DE GASTO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni=1
XiMesFin=_Mes
XiNroDig=1
XiNroDec=2

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
*@ 13,24 SAY "DIGITOS    : "
@ 14,24 SAY "DECIMALES  : "
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
         @ 11,38 GET XiMesIni   PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,38 GET XiMesFin   PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
        *VecOpc(1)="2"
        *VecOpc(2)="4"
        *VecOpc(3)="8"
        *VecOpc(4)="8 (S¢lo Totales)"
        *XiNroDig= Elige(1,13,38,4)
      CASE i = 5
         @ 14,38 GET XiNroDec   PICTURE "9" RANGE 0,2
         READ
         UltTecla = LASTKEY()
         @ 14,38 SAY XiNroDec   PICTURE "9"
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 5 , i + 1, 5 )

      CASE UltTecla = Enter
         IF  i < 5
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
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp1= PathUser+SYS(3)
ArcTmp2= PathUser+SYS(3)
SELECT ACCT
SEEK "9"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp1 FOR (LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 WHILE CodCta="9"
ELSE
   COPY TO &ArcTmp1 FOR (LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 WHILE CodCta="9"
ENDIF
*
SEEK "6"
IF XiCodMon = 1
   COPY TO &ArcTmp2 FOR LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBENAC - HBENAC)#0 ;
        AND INLIST(CodRef,"91","92","93","94","95","97") WHILE CODCTA<"9"
ELSE
   COPY TO &ArcTmp2 FOR LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBEEXT - HBEEXT)#0 ;
        AND INLIST(CodRef,"91","92","93","94","95","97") WHILE CODCTA<"9"
ENDIF
SET TALK OFF
**
SELECT 0
USE &ArcTmp2 ALIAS TMP2 EXCL
INDEX ON CODREF+CODCTA TAG  TMP201
INDEX ON CODCTA+CODREF TAG  TMP202
SET ORDER TO TMP202

**
SELE CTAS
SET ORDER TO TpoGto
GO TOP
DO WHILE !EOF()
   IF AftMov="S" AND ClfAux="05 "      && Tipo De gasto
      LsTpoGto=TpoGto
      DO WHILE !EOF() AND TpoGto=LsTpoGto
          LsCtaGto=CodCta
          SELE TMP2
          SEEK LsCtaGto
          DO WHILE !EOF() AND CodCta=LsCtaGto
             REPLACE CodRef WITH LEFT(CodRef,2)+LsTpoGto
             SKIP
          ENDDO
          SELE CTAS
          SKIP
      ENDDO
   ELSE
      SKIP
   ENDIF
ENDDO
SELE CTAS
SET ORDER TO CTAS01
**
DO CASE
   CASE XiNroDig = 1
      DO IMP2D
   OTHER
      DO IMP5D
ENDCASE


CLOSE DATA

DELETE FILE &ArcTmp1..dbf
DELETE FILE &ArcTmp1..idx
DELETE FILE &ArcTmp2..dbf
DELETE FILE &ArcTmp2..cdx

***************
PROCEDURE IMP2D
***************
SELE TMP2
SET  ORDER TO  TMP201
SELECT 0
USE &ArcTmp1 ALIAS TMP1  EXCL
INDEX ON CODREF+CODCTA TO  &ArcTmp1
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

Ancho = 162
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 66 - 8
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 9 Y 6 Por Tipo Gasto"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = "---- ------------------------------ ----------------------------------------------------- ----------------- ----------------- ----------------- -----------------"
En7 = "TIPO                                    AGRICOLA           ESTABLO           PLANTA         ADMINISTRACION       VENTAS          FINANCIEROS         T O T A L   "
En8 = "GAST  D E S C R I P C I O N                91                92                93                 94               95                97                          "
En9 = "---- ------------------------------ ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"

Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import97 = 0
nCol     = 6
Pos      = 36
Esp      = 18
DIMENSION  vImp(10,nCol),vCta(10)
STORE 0  TO vImp
store [] TO vCta
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   Inicio = .F.
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
      TotQui96 = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodRef,1)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodRef,1) .AND. ! Cancelar
         LsCodRef = CodRef
         LsCta9xx = CodCta
         DO Calculo
         NumEle = 0
         DO Calc_Gto
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
Import96 = 0
Import97 = 0
DO WHILE ! EOF() .AND. CodRef = LsCodRef
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF

   DO CASE
      CASE Codcta = "91"
         Import91 = Import91 + nImport
      CASE Codcta = "92"
         Import92 = Import92 + nImport
      CASE Codcta = "93"
         Import93 = Import93 + nImport
      CASE Codcta = "94"
         Import94 = Import94 + nImport
      CASE Codcta = "95"
         Import95 = Import95 + nImport
      CASE Codcta = "96"
         Import96 = Import96 + nImport
      CASE Codcta = "97"
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
******************
PROCEDURE Calc_Gto
******************
DIMENSION  vImp(10,nCol),vCta(10)
STORE 0  TO vImp
STORE [] TO vCta
SELE TMP2
SEEK LEFT(LsCta9xx,2)+LEFT(LsCodRef,3)
DO WHILE !EOF() AND CodRef=LEFT(LsCta9xx,2)+LEFT(LsCodRef,3)
   IF ALEN(vCta)<NumEle + 1
      DIMENSION vImp(NumEle + 5,nCol),vCta(NumEle + 5)
      FOR kk = NumEle + 1 TO NumEle + 5
          vCta(kk) = []
          FOR ii = 1 TO nCol
              STORE 0 TO vImp(kk,ii)
          NEXT
      NEXT
   ENDIF
   NumEle  = NumEle + 1
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF
   DO CASE
      CASE LEFT(CodRef,2)="91"
           vImp(NumEle,1) = vImp(NumEle,1)  + nImport
      CASE LEFT(CodRef,2)="92"
           vImp(NumEle,2) = vImp(NumEle,2)  + nImport
      CASE LEFT(CodRef,2)="93"
           vImp(NumEle,3) = vImp(NumEle,3)  + nImport
      CASE LEFT(CodRef,2)="94"
           vImp(NumEle,4) = vImp(NumEle,4)  + nImport
      CASE LEFT(CodRef,2)="95"
           vImp(NumEle,5) = vImp(NumEle,5)  + nImport
      CASE LEFT(CodRef,2)="97"
           vImp(NumEle,6) = vImp(NumEle,6)  + nImport
   ENDCASE
   vCta(NumEle) =  CodCta
   SKIP
ENDDO
SELE TMP1
RETURN

****************
PROCEDURE LinImp
****************

private ii,jj
=SEEK("04 "+LsCodRef,"AUXI")
DO ResetPag
NumLin = PROW() + 1
Total = Import91 +Import92 +Import93 +  Import94 + Import95 + Import97

@ NumLin,1  SAY LsCodRef      PICT "@S3"
@ NumLin,6  SAY AUXI->NomAux  PICT "@S30"
@ NumLin,36  SAY PICNUM(Import91)
@ NumLin,54  SAY PICNUM(Import92)
@ NumLin,72  SAY PICNUM(Import93)
@ NumLin,90  SAY PICNUM(Import94)
@ NumLin,108 SAY PICNUM(Import95)
@ NumLin,126 SAY PICNUM(Import97)
@ NumLin,144 SAY PICNUM(Total)

IF NumEle>0
   FOR ii  = 1 TO NumEle
       DO ResetPag
       NumLin = PROW() + 1
       @ NumLin,4 SAY vCta(ii)
       total2 = 0
       FOR jj  = 1 TO nCol
           @ NumLin,Pos + (jj-1)*Esp SAY PICNUM(vImp(ii,jj))
           total2= total2 + vImp(ii,jj)
       NEXT
       @ NumLin,144 SAY PICNUM(Total2)
   NEXT
ENDIF
RETURN
*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total  = TotQui91 +  TotQui92 + TotQui93 +TotQui94 +  TotQui95 + TotQui97

NumLin = PROW() + 1
@ NumLin,36  SAY "-----------------"
@ NumLin,54  SAY "-----------------"
@ NumLin,72  SAY "-----------------"
@ NumLin,90  SAY "-----------------"
@ NumLin,108 SAY "-----------------"
@ NumLin,126 SAY "-----------------"
@ NumLin,144 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ......"
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


******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. Inicio
   Inicio = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF

****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF XiNroDec>0
   sFmt = "99,999,999,999."+REPLI("9",XiNroDec)
ELSE
   sFmt = "99,999,999,999"
ENDIF
IF Valor<0
   RETURN TRANSF(-Valor,sFmt)+"-"
ELSE
   RETURN TRANSF( Valor,sFmt)+" "
ENDIF
***************
PROCEDURE IMP5D
***************
DIMENSION vQui1(10,2),vCta3(999,2),vCta2(999,2),vCta0(999,2)

SELECT 0
USE &ArcTmp
INDEX ON CODCTA+CODREF TO  &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF


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
En1 = "ANALISIS CLASE 9 POR TIPO GASTO"
En2 = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En3 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En4 = "<HORA : "+TIME()
En5 = ""
En6 = "***********************************************************************************************"
En7 = "       TIPO                                       *      MOVIMIENTO     *      MOVIMIENTO     *"
En8 = "CUENTA GASTO  D E S C R I P C I O N               *       DEL MES       *       ACUMULADO     *"
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
   STORE 0 TO vCta0
   DO WHILE ! EOF() .AND. ! Cancelar
      STORE 0 TO vCta2
      LsCodCta_2D = LEFT(CodCta,2)
      DO WHILE ! EOF() .AND. ! Cancelar  .AND. CodCta = LsCodCta_2D
         STORE 0 TO vCta3
         LsCodCta_3D = LEFT(CodCta,4)
         DO WHILE ! EOF() .AND. ! Cancelar  .AND. CodCta = LsCodCta_3D
            LsCodCta = CodCta
            Inicio   = .T.
            lQuiebre = .T.
            STORE 0 TO vQui1
            DO WHILE ! EOF() .AND. CodCta = LsCodCta .AND. ! Cancelar
               LsCodRef = CodRef
               DO CaLCULO1
               DO LinImp_5D
               Cancelar = INKEY() = Escape
            ENDDO
            IF ! Cancelar  .AND. INLIST(XiNroDig,3,4)
               DO TotImp_5D
            ENDIF
         ENDDO
         IF ! Cancelar
            DO TotImp_3D
         ENDIF
      ENDDO
      IF ! Cancelar
         DO TotImp_2D
      ENDIF
   ENDDO
   IF ! Cancelar
      DO TotImp_0D
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RETURN


*******************
PROCEDURE LinImp_5D
*******************
IF XiNroDig # 3
   RETURN
ENDIF


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
=SEEK("04 "+LsCodRef,"AUXI")
NumLin = PROW() + 1
@ NumLin,09 SAY LsCodRef      PICT "@S3"
@ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
@ NumLin,50 SAY "*"
@ NumLin,51  SAY PICNUM(ImportMM)
@ NumLin,72  SAY "*"
@ NumLin,73  SAY PICNUM(ImportAA)
@ NumLin,94  SAY "*"
RETURN

********************
PROCEDURE TotImp_5D
********************
PRIVATE I
DO ResetPag
NumLin = PROW() + 1
@ NumLin,0   SAY REPLICATE("*",Ancho)
ImportMM = 0
ImportAA = 0
FOR ii =1 to 10
   IF vQui1(ii,2) <> 0
      DO ResetPag
      NumLin = PROW() + 1
      @ NumLin,06 SAY vClfGto(ii)
      @ NumLin,50 SAY "*"
      @ NumLin,51  SAY PICNUM(vQui1(ii,1))
      @ NumLin,72 SAY "*"
      @ NumLin,73  SAY PICNUM(vQui1(ii,2))
      @ NumLin,94 SAY "*"
      ImportMM = vQui1(ii,1) + ImportMM
      ImportAA = vQui1(ii,2) + ImportAA
   ENDIF
NEXT
NumLin = PROW() + 1
@ NumLin,0   SAY REPLICATE("*",Ancho)
IF LEN(TRIM(LsCodCta)) = 6
   NumLin = PROW() + 2
ELSE
   NumLin = PROW() + 1
ENDIF
IF LEN(TRIM(LsCodCta)) = 0
   @ NumLin,16  SAY "TOTAL  GENERAL      "
ELSE
   @ NumLin,16  SAY "TOTAL  X CUENTA     "+LsCodCta
ENDIF
@ NumLin,50 SAY "*"
@ NumLin,51  SAY PICNUM(ImportMM)
@ NumLin,72 SAY "*"
@ NumLin,73  SAY PICNUM(ImportAA)
@ NumLin,94 SAY "*"
RETURN

********************
PROCEDURE TotImp_3D
********************
PRIVATE I
Inicio   = .T.
LsCodCta = LsCodCta_3D
DO ResetPag
NumLin = PROW() + 1

=SEEK(LsCodCta,"CTAS")
NumLin = PROW() + 1
@ NumLin,0  SAY LsCodCta
@ NumLin,14 SAY CTAS->NomCta
NumLin = PROW() + 1
@ NumLin,0  SAY ""
STORE 0 TO vQui1
FOR ii =1 to 999
   IF vCta3(ii,2) <> 0
      DO ResetPag
      NumLin = PROW() + 1
      LsCodRef = TRANSF(ii,"@L 999")
      =SEEK("04 "+LsCodRef,"AUXI")
      @ NumLin,09 SAY LsCodRef      PICT "@S3"
      @ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
      @ NumLin,50 SAY "*"
      @ NumLin,51  SAY PICNUM(vCta3(ii,1))
      @ NumLin,72 SAY "*"
      @ NumLin,73  SAY PICNUM(vCta3(ii,2))
      @ NumLin,94 SAY "*"

      z = VAL(LEFT(LsCodRef,3))
      DO CASE
         CASE Z < 100
            Z = 1
         CASE Z < 200
            Z = 2
         CASE Z < 300
            Z = 3
         CASE Z < 400
            Z = 4
         CASE Z < 430
            Z = 5
         CASE Z < 499
            Z = 6
         CASE Z < 599
            Z = 7
         CASE Z < 699
            Z = 8
         CASE Z < 799
            Z = 9
         CASE Z < 999
            Z = 10
      ENDCASE
      vQui1(z,1) = vQui1(z,1) + vCta3(ii,1)
      vQui1(z,2) = vQui1(z,2) + vCta3(ii,2)
   ENDIF
NEXT
DO TotImp_5D
RETURN


********************
PROCEDURE TotImp_2D
********************
PRIVATE I
Inicio   = .T.
LsCodCta = LsCodCta_2D
DO ResetPag
NumLin = PROW() + 1

=SEEK(LsCodCta,"CTAS")
NumLin = PROW() + 1
@ NumLin,0  SAY LsCodCta
@ NumLin,14 SAY CTAS->NomCta
NumLin = PROW() + 1
@ NumLin,0  SAY ""
STORE 0 TO vQui1
FOR ii =1 to 999
   IF vCta2(ii,2) <> 0
      DO ResetPag
      NumLin = PROW() + 1
      LsCodRef = TRANSF(ii,"@L 999")
      =SEEK("04 "+LsCodRef,"AUXI")
      @ NumLin,09 SAY LsCodRef      PICT "@S3"
      @ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
      @ NumLin,50 SAY "*"
      @ NumLin,51  SAY PICNUM(vCta2(ii,1))
      @ NumLin,72 SAY "*"
      @ NumLin,73  SAY PICNUM(vCta2(ii,2))
      @ NumLin,94 SAY "*"

      z = VAL(LEFT(LsCodRef,3))
      DO CASE
         CASE Z < 100
            Z = 1
         CASE Z < 200
            Z = 2
         CASE Z < 300
            Z = 3
         CASE Z < 400
            Z = 4
         CASE Z < 430
            Z = 5
         CASE Z < 499
            Z = 6
         CASE Z < 599
            Z = 7
         CASE Z < 699
            Z = 8
         CASE Z < 799
            Z = 9
         CASE Z < 999
            Z = 10
      ENDCASE
      vQui1(z,1) = vQui1(z,1) + vCta2(ii,1)
      vQui1(z,2) = vQui1(z,2) + vCta2(ii,2)
   ENDIF
NEXT
DO TotImp_5D
RETURN

********************
PROCEDURE TotImp_0D
********************
PRIVATE ii
Inicio   = .T.
LsCodCta = ""
STORE 0 TO vQui1
FOR ii =1 to 999
   IF vCta0(ii,2) <> 0
      DO ResetPag
      NumLin = PROW() + 1
      LsCodRef = TRANSF(ii,"@L 999")
      =SEEK("04 "+LsCodRef,"AUXI")
      @ NumLin,09 SAY LsCodRef      PICT "@S3"
      @ NumLin,14 SAY AUXI->NomAux  PICT "@S35"
      @ NumLin,50 SAY "*"
      @ NumLin,51  SAY PICNUM(vCta0(ii,1))
      @ NumLin,72 SAY "*"
      @ NumLin,73  SAY PICNUM(vCta0(ii,2))
      @ NumLin,94 SAY "*"

      z = VAL(LEFT(LsCodRef,3))
      DO CASE
         CASE Z < 100
            Z = 1
         CASE Z < 200
            Z = 2
         CASE Z < 300
            Z = 3
         CASE Z < 400
            Z = 4
         CASE Z < 430
            Z = 5
         CASE Z < 499
            Z = 6
         CASE Z < 599
            Z = 7
         CASE Z < 699
            Z = 8
         CASE Z < 799
            Z = 9
         CASE Z < 999
            Z = 10
      ENDCASE
      vQui1(z,1) = vQui1(z,1) + vCta0(ii,1)
      vQui1(z,2) = vQui1(z,2) + vCta0(ii,2)
   ENDIF
NEXT
DO TotImp_5D
RETURN

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

Z = VAL(LEFT(LSCODREF,3))
DO CASE
   CASE Z < 100
      Z = 1
   CASE Z < 200
      Z = 2
   CASE Z < 300
      Z = 3
   CASE Z < 400
      Z = 4
   CASE Z < 430
      Z = 5
   CASE Z < 499
      Z = 6
   CASE Z < 599
      Z = 7
   CASE Z < 699
      Z = 8
   CASE Z < 799
      Z = 9
   CASE Z < 999
      Z = 10
ENDCASE
vQui1(Z,1) = vQui1(Z,1) + ImportMM
vQui1(Z,2) = vQui1(Z,2) + ImportAA
i = VAL(LEFT(LsCodRef,3))
IF i<=0
   RETURN
ENDIF
vCta3(i,1) = vCta3(i,1) + ImportMM
vCta3(i,2) = vCta3(i,2) + ImportAA

vCta2(i,1) = vCta2(i,1) + ImportMM
vCta2(i,2) = vCta2(i,2) + ImportAA

vCta0(i,1) = vCta0(i,1) + ImportMM
vCta0(i,2) = vCta0(i,2) + ImportAA

RETURN
