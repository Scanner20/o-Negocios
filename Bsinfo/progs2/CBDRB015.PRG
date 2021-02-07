********************************************************************************
* Progrma       : CBDRB013.PRG                                                 *
* Objeto        : Analisis Clase 9 Por Tipo Gasto y por meses                  *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
sele 1
use cbdmauxi order AUXI01 alias AUXI
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

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69

DO LIB_MTEC WITH 16
XdMes1=_Mes
XdMes2=_Mes
LNMES=1

@ 10,26 SAY "MONEDA : "
@ 11,26 SAY "DESDE MES  : "
@ 12,26 SAY "HASTA MES  : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,36,2)
      CASE i = 2
         @ 11,38 GET XdMES1   PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,38 GET XdMES2   PICTURE "99"
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

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp = PathUser+SYS(3)
SELECT ACCT
SET TALK ON
SET TALK WINDOW
COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=5 .AND. CodCta = "9" .AND. (Val(NroMes)>=XdMes1 .AND. Val(NroMes)<=XdMes2)) .AND. CODCTA#"90"
SET TALK OFF
SELECT 0
USE &ArcTmp
REPLACE ALL CODCTA WITH "91" FOR CODCTA="92"
INDEX ON LEFT(CODCTA,2)+CODREF TO  &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
Ancho = 220
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 9 Por Tipo Gasto"
SubTitulo = "De "+Mes(XdMes1,3)+" A "+Mes(XdMes2,3)+" - "+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = ""
En7 = "**** ******************************** ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* **************"
En8 = "T.G. D e s c r i p c i o n                ENERO        FEBRERO         MARZO        ABRIL         MAYO          JUNIO         JULIO        AGOSTO       SETIEMBRE      OCTUBRE      NOVIEMBRE     DICIEMBRE       TOTAL     "
En9 = "**** ******************************** ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* ************* **************"


Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
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
   NumPag   = 0
   DO WHILE ! EOF()
      TotQui91 = 0
      TotQui92 = 0
      TotQui93 = 0
      TotQui94 = 0
      TotQui95 = 0
      Quiebre  = LEFT(CodRef,1)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodRef,1)
         LsCodRef = CodRef
         DO CaLCULO
         DO LinImp
      ENDDO
      DO TotImp1
   ENDDO
   DO TotImp2
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA

DELETE FILE &ArcTmp..dbf
DELETE FILE &ArcTmp..idx
RETURN


*****************
PROCEDURE Calculo
*****************
Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
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
   ENDCASE
   SKIP
ENDDO

TotImp91 = TotImp91 + Import91
TotImp92 = TotImp92 + Import92
TotImp93 = TotImp93 + Import93
TotImp94 = TotImp94 + Import94
TotImp95 = TotImp95 + Import95


TotQui91 = TotQui91 + Import91
TotQui92 = TotQui92 + Import92
TotQui93 = TotQui93 + Import93
TotQui94 = TotQui94 + Import94
TotQui95 = TotQui95 + Import95

RETURN

****************
PROCEDURE LinImp
****************
=SEEK("04 "+LsCodRef,"AUXI")
DO ResetPag
NumLin = PROW() + 1
Total1 = Import91 +  Import92
Total  = Total1 + Import93 +  Import94 + Import95

@ NumLin,1  SAY LsCodRef      PICT "@S3"
@ NumLin,6  SAY AUXI->NomAux  PICT "@S30"
@ NumLin,36  SAY Import91      PICT "99,999,999,999.99"
@ NumLin,54  SAY Import92      PICT "99,999,999,999.99"
@ NumLin,72  SAY Total1        PICT "99,999,999,999.99"
@ NumLin,90  SAY Import93      PICT "99,999,999,999.99"
@ NumLin,108 SAY Import94      PICT "99,999,999,999.99"
@ NumLin,126 SAY Import95      PICT "99,999,999,999.99"
@ NumLin,144 SAY Total         PICT "99,999,999,999.99"
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total1 = TotQui91 +  TotQui92
Total  = Total1 + TotQui93 +  TotQui94 + TotQui95

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
@ NumLin,36  SAY TotQui91      PICT "99,999,999,999.99"
@ NumLin,54  SAY TotQui92      PICT "99,999,999,999.99"
@ NumLin,72  SAY Total1        PICT "99,999,999,999.99"
@ NumLin,90  SAY TotQui93      PICT "99,999,999,999.99"
@ NumLin,108 SAY TotQui94      PICT "99,999,999,999.99"
@ NumLin,126 SAY TotQui95      PICT "99,999,999,999.99"
@ NumLin,144 SAY Total         PICT "99,999,999,999.99"
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*****************
PROCEDURE TotImp2
*****************
DO ResetPag
NumLin = PROW() + 2
Total1 = TotImp91 +  TotImp92
Total  = Total1 + TotImp93 +  TotImp94 + TotImp95

@ NumLin,16  SAY "* Total General.."
@ NumLin,36  SAY TotImp91      PICT "99,999,999,999.99"
@ NumLin,54  SAY TotImp92      PICT "99,999,999,999.99"
@ NumLin,72  SAY Total1        PICT "99,999,999,999.99"
@ NumLin,90  SAY TotImp93      PICT "99,999,999,999.99"
@ NumLin,108 SAY TotImp94      PICT "99,999,999,999.99"
@ NumLin,126 SAY TotImp95      PICT "99,999,999,999.99"
@ NumLin,144 SAY Total         PICT "99,999,999,999.99"
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
