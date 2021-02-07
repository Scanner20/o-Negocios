********************************************************************************
* Progrma       : CBDRPLAN.PRG                                                 *
* Objeto        : AUXILIARES                                                  *
* Autor         : J.C.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 10/05/94                                                     *
********************************************************************************
SELE 2
USE cbdmtabl ORDER tabl01   ALIAS TABL
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
SET RELATION TO "001"+CLFAUX INTO TABL
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS AUXILIARES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
XsNom=[]
@  9,08 FILL  TO 21,70      COLOR W/N
@  8,09 CLEAR TO 20,71
@  8,09       TO 20,71
XsClfAux = SPACE(LEN(AUXI->ClfAux))
XsTPOAux = SPACE(LEN(AUXI->TpoAux))
XslocAux = SPACE(LEN(AUXI->locAux))
Sorteo   = 1
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10)
   DO CASE
      CASE I = 1
         SELECT TABL
         XsTabla = "01"
         @ 11,12 SAY "CLASIFICACION :" GET XsClfAux PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            CLOSE DATA
            RETURN
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCLFaUX)
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsClfAux = LEFT(CODIGO,len(XsClfAux))
            UltTecla = Enter
         ENDIF
         IF ! SEEK("01"+XsClfAux,"TABL")
            GsMsgErr = "Clasificaci¢n no registrada"
            DO LIB_MERR WITH 99
            LOOP
         ENDIF
         @ 11,28 SAY XsClfAux
         @ 11,33 SAY TABL->Nombre PICT "@S30"
         XsNom=TABL->Nombre
      CASE I = 2
         @ 13,12 SAY "Ordenado      : " GET Sorteo PICT "@^ C¢digo;Nombre"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>4,4, i)
   i = IIF(i<1 , 1, i)
ENDDO
IF XSCLFAUX<>"01 "
   XsTPOAux = ""
   XslocAux = ""
ELSE
   XsTPOAux = TRIM(XsTPOAux)
   XslocAux = TRIM(XslocAux)
ENDIF
IF ! EMPTY(XsTpoAux)
   XsTpoAux=XsTpoAux+",CP"
ENDIF
*** Pantalla de datos  ***
SELE AUXI
IF Sorteo = 2
   SET ORDE TO AUXI02
ENDIF
SEEK TRIM(XsClfAux)
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
Ancho = 81
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN1
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "RELACION DE AUXILIARES"
SubTitulo = ""
En1 = "AUXILIAR "+XsClfAux+XsNOM
En2 = "HORA : "+TIME()+SPACE(72)
En3 = "========== ======================================== ============================="
En4 = " CODIGO                  NOMBRE                              DIRECCION           "
En5 = "========== ======================================== ============================="

*========== ======================================== ============================="
* CODIGO                  NOMBRE                              DIRECCION           "
*========== ======================================== ============================="
*1234567890 1234567890123456789012345678901234567890 123456789012345678901234567890
*0          11                                       52

En6 = ""
En7 = ""
En8 = ""
En9 = ""

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cancelar = .F.
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0

STORE RECNO() TO REGINI
PRINTJOB
   GO REGINI
   Inicio = .T.
   NumPag  = 0
   cancela=.f.
   DO WHILE ! EOF() .AND. XsClfAux=CLFAUX .AND.!CANCELA
      DO ResetPag
      NumLin = PROW() + 1
      DO LinImp1
      cancela=(INKEY()=ESCAPE.OR.CANCELA)
      SKIP
   ENDDO
   NumLin = PROW() + 1
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

*****************
PROCEDURE LinImp1
*****************
Separa = 0

@ NumLin,0   SAY CODAUX
@ NumLin,11  SAY LEFT(NOMAUX,40)
@ NumLin,52  SAY DIRAUX

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

***************

