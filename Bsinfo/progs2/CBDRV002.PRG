********************************************************************************
* Progrma       : CBDRV002.prg                                                 *
* Objeto        : Reporte del CUENTAS AUXILIARES                               *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
***
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
         @ 11,12 SAY "CLASIFICACION :" GET XsClfAux PICTURE REPLICATE("9",LEN(XsClfAux))
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
      CASE I = 2
         @ 13,12 SAY "Ordenado      : " GET Sorteo PICT "@^ C¢digo;Nombre"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3,3, i)
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
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = [ClfAux = TRIM(XsClfAux)]
xFor   = ""
sNomREP = "cbdmauxi"
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN
