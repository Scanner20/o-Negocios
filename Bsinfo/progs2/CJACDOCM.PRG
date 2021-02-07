cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CONSULTA DE DOCUMENTOS REGISTRADOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

XiTpoDoc = 1

@  9,10 FILL  TO 15,68      COLOR W/N
@  9,12 CLEAR TO 13,68
@  8,11       TO 14,69
@ 10,31 PROMPT "  CAJA  INGRESOS  "
@ 11,31 PROMPT "   CAJA EGRESOS   "
@ 12,31 PROMPT "CAJA TRANSFERENCIA"
MENU TO XiTpoDoc
IF LastKey() = Escape .OR. XiTpoDoc = 0
   RETURN
ENDIF
@  9,12 CLEAR TO 13,68
XiForma = 1
DO CASE
   CASE XiTpoDoc = 1
      @ 8,31 SAY "  CAJA  INGRESOS  " COLOR SCHEME 7
      XsCodOpe = "005"
      @ 10,22 PROMPT "  DOCUMENTO  "
      @ 11,22 PROMPT "  CONCEPTO   "
      @ 12,22 PROMPT "  CUENTA     "
      MENU TO XiForma
      xPrg = "CJAC1MOV"

   CASE XiTpoDoc = 2
      @ 8,31 SAY "   CAJA EGRESOS   " COLOR SCHEME 7
      XsCodOpe = "006"
      @ 10,22 PROMPT "  DOCUMENTO  "
      @ 11,22 PROMPT "  CONCEPTO   "
      @ 12,22 PROMPT "  CUENTA     "
      @ 13,22 PROMPT "  PROVEEDOR  "
      @ 14,22 PROMPT "  DOCUMENTO CANCELADO "
      MENU TO XiForma
      xPrg = "CJAC2MOV"

   CASE XiTpoDoc = 3
      @ 8,31 SAY "CAJA TRANSFERENCIA" COLOR SCHEME 7
      XsCodOpe = "018"
      @ 10,22 PROMPT "  DOCUMENTO  "
      @ 10,22 PROMPT "  CONCEPTO   "
      MENU TO XiForma
      xPrg = "CJAC3MOV"

ENDCASE
IF LastKey() = Escape .OR. XiForma  = 0
   CLOSE DATA
   RETURN
ENDIF
XiNroMes = _Mes
XiNroRel = 0
XiNrDoc1 = 1
XiNrDoc2 = 999999
XdFchAs1 = DATE()
XdFchAs2 = DATE()
XsNroMes = TRANSF(XiNroMes,"@L ##")
@  9,12 CLEAR TO 13,68
DO CASE
   CASE XiForma  = 1
      @ 12,26 SAY "Nro.  DOCUMENTO   . :" GET XiNrDoc1 PICT "@LZ 999999"
      READ
      XsNroMes = TRANSF(XiNroMes,"@L ##")
      Llave  = XsNroMes+XsCodOpe+TRANSF(XiNrDoc1,"@L 999999")
      Valido = ".T."
      RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe .AND. VAL(NroAst)=XiNrDoc1)"
      xOrden = "VMOV01"
   CASE XiForma  = 2
      @ 09,22 SAY    "  BUSCA CONCEPTO EN UN RANGO DE FECHA  " COLOR SCHEME 7
      @ 11,24 SAY "DESDE FECHA DE REGISTRO :" GET XdFchAs1
      @ 12,24 SAY "HASTA FECHA DE REGISTRO :" GET XdFchAs2
      READ
      Llave  = XsNroMes+XsCodOpe
      Valido = "(FchAst >=XdFchAs1 .AND. FchAst <= XdFchAs2)"
      RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe)"
      xOrden = "VMOV01"

   CASE XiForma  = 2
      @ 09,22 SAY    "      ENTRE N§ DE DOCUMENTOS       " COLOR SCHEME 7
      @ 11,26 SAY "DEL MES DE          :" GET XiNroMes PICT "@Z 99"
      @ 12,26 SAY "DESDE DOCUMENTO NO. :" GET XiNrDoc1 PICT "@LZ 999999"
      @ 13,26 SAY "HASTA DOCUMENTO NO. :" GET XiNrDoc2 PICT "@LZ 999999"
      READ
      XsNroMes = TRANSF(XiNroMes,"@L ##")
      Llave  = XsNroMes+XsCodOpe+TRANSF(XiNrDoc1,"@L 999999")
      Valido = ".T."
      RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe .AND. VAL(NroAst)<=XiNrDoc2)"
      xOrden = "VMOV01"

   CASE XiForma  = 3
      @ 09,22 SAY    "TODOS LOS DOCUMENTO DE UNA RELACION" COLOR SCHEME 7
      @ 12,30 SAY "RELACION NO. :" GET XiNroRel PICT "@LZ 999999"
      READ
      Llave  = XsCodOpe+TRANSF(XiNroRel,"@L 999999")
      Valido = ".T."
      RegVal = "(CodOpe+NroVou=Llave)"
      xOrden = "VMOV02"
ENDCASE
IF LastKey() = Escape
   RETURN
ENDIF
DO ADMPRINT
IF LastKey() = Escape
   RETURN
ENDIF
*** APERTURANDO ARCHIVOS ***
DO MOVApert IN (xPrg)
SET MARGIN TO 0
PRINTJOB
   SELECT VMOV
   SET ORDER TO (xOrden)
   SEEK LLAVE
   SCAN WHILE &RegVal
      XsNroMes = NroMes
      XsNroAst = NroAst
      IF &Valido
         DO MOVPRINT IN (xPrg)
      ENDIF
      SELECT VMOV
   ENDSCAN
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN
