cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RELACION DE CHEQUES GIRADOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SELECT 2
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELECT 1
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SET RELATION TO "04"+CODBCO INTO TABL
SELE 4
USE cbdvmovm ORDER vmov02   ALIAS VMOV
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
SELECT 5
USE CBDTOPER ORDER OPER01 ALIAS OPER
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69
SELECT OPER
XsCodOpe = "006"
SEEK XsCodOpe
IF CodOpe = XsCodOpe
   XiNroRel = OPER->NroRel
ELSE
   XiNroRel = 1
ENDIF
@ 10,18 SAY "             Nro. Relaci¢n  : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,48 GET XiNroRel PICTURE "@L 999999"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 1 , i + 1, 1 )

      CASE UltTecla = Enter
         IF  i < 1
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
SELECT VMOV
XsNroRel = PADR(TRANSF(XiNroRel,"@L 999999"),LEN(NROVOU))
SET RELATION TO CTACJA INTO CTAS
SEEK XsCodOpe+XsNroRel
IF !FOUND()
    GsMSgErr="Fin De Archivo"
    DO LIB_MERR WITH 99
    CLOSE DATA
    RETURN
ENDIF
Largo  = 36
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
xWhile = [CodOpe+NroVou =  XsCodOpe+XsNroRel]
xFor   = [!EMPTY(VMOV->CTACJA)]
sNomRep = "CJARG001"
xNomRep = "CJARGP01"
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN
