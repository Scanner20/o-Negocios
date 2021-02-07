********************************************************************************
* Progrma       : CBDRV001.prg                                                 *
* Objeto        : Reporte del Plan de Cuentas                                  *
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
cTit4 = "PLAN DE CUENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES

@  9,10 FILL  TO 14,68      COLOR W/N
@  8,11 CLEAR TO 13,69
@  8,11       TO 13,69
Desde = SPACE(LEN(CTAS->CodCta))
Hasta = SPACE(LEN(CTAS->CodCta))
@ 10,28 SAY "DESDE CUENTA : " GET Desde PICT REPLICATE("9",LEN(DESDE))
@ 11,28 SAY "HASTA CUENTA : " GET Hasta PICT REPLICATE("9",LEN(DESDE))
READ
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
*** Pantalla de datos  ***
SELE CTAS
SEEK TRIM(Desde)
Hasta = LEFT(TRIM(Hasta)+"zzzzzzzzzz",LEN(HASTA))
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = [CodCta <= Hasta]
xFor   = []
sNomREP = "cbdmctas"
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN
