********************************************************************************
* Progrma       : CBDRL007.PRG                                                 *
* Objeto        : Libros Generales                                             *
* Autor         : VETT                                                         *
* Creaci¢n      : 24/08/1999                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
SELE 7
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(7)
    close data
    return
ENDIF

SELE 6
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(6)
    close data
    return
ENDIF
SELE 5
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 4
USE cbdrmovm ORDER rmov01   ALIAS RMOV
IF !used(4)
    close data
    return
ENDIF
ArcCgo = Pathuser+Sys(3)
ArcAbn = Pathuser+Sys(3)
COPY STRU TO &ArcCgo
COPY STRU TO &ArcAbn
SELECT 10
USE &ArcCgo EXCLUSIVE  ALIAS CGOS
Index on CodCta to &ArcCgo
SELECT 9
USE &ArcAbn EXCLUSIVE ALIAS ABNS
Index on CodCta to &ArcAbn

SELE 3
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(3)
    close data
    return
ENDIF
sele 2
use cbdacmct order acct01 alias ACCT
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
cTit4 = "LIBROS GENERALES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
XsCodOpe = SPACE(3)
XsNroMes = transf(_MES,"@L ##")

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "OPERACION  : "
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
         SELE OPER
         @ 11,38 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !CBDBUSCA("OPER")
               UltTecla = 0
               LOOP
            ENDIF
            XsCodOpe = OPER->CodOpe
            UltTecla = ENTER
         ENDIF
         *
         SEEK XsCodOpe
         IF !FOUND()
            GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
            DO LIB_MERR WITH 99
            LOOP
         ENDIF
         @11,38 SAY XsCodOpe
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)
      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )
      CASE UltTecla = Enter
         IF  i < 2
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
* chequeos
=SEEK(XsCodOpe,"OPER")
SELECT VMOV
xLLave = XsNroMes+XsCodOpe
vClave = [NroMes+CodOpe]
SEEK xLLave
IF ! FOUND()
   GsMsgErr = "No Existen registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
*
DO PROCESO
*
CLOSE DATA
DELETE FILE  &ArcCgo..dbf
DELETE FILE  &ArcCgo..idx
DELETE FILE  &ArcAbn..dbf
DELETE FILE  &ArcAbn..idx
RETURN


*****************
PROCEDURE PROCESO
*****************
Ancho = 202
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN3+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = XsCodOpe+" "+TRIM(OPER->NomOpe)
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
IF XsCodOpe = "300"
   En6 = "**** ****** ******** *************** ********** ******************************** ********* ****************************** ********** ****************** ******************** ********** ******************"
   En7 = "      NRO.               No.         CODIGO                                        Nro.                                   CUENTAS     BASE IMPONIBLE                         CUENTAS         T O T A L    "
   En8 = "  #   ASTO.  FECHA   TD  DOCUMENTO   AUXILIAR    DESCRIPCION                       R.U.C   GLOSA                          CARGOS             CARGOS             40           ABONOS               ABONOS  "
   En9 = "**** ****** ******** *************** ********** ******************************** ********* ****************************** ********** ****************** ******************** ********** ******************"
   *                                                      123456789-123456789-12345678-123 123456783
ELSE

   En6 = "**** ****** ******** *************** ********** ****************************************** ****************************** ********** ****************** ******************** ********** ******************"
   En7 = "      NRO.               No.         CODIGO                                                                               CUENTAS                                            CUENTAS                      "
   En8 = "  #   ASTO.  FECHA   TD  DOCUMENTO   AUXILIAR    DESCRIPCION                               GLOSA                          CARGOS             CARGOS             40           ABONOS               ABONOS  "
   En9 = "**** ****** ******** *************** ********** ****************************************** ****************************** ********** ****************** ******************** ********** ******************"
   *                                                      123456789-123456789-12345678-123456789-123
ENDIF
*  **** ****** ******** *************** ********** ****************************************** ****************************** ********** ****************** ******************** ********** ******************"
*        NRO.               No.         CODIGO                                                                               CUENTAS                                            CUENTAS                      "
*    #   ASTO.  FECHA   TD  DOCUMENTO   AUXILIAR    DESCRIPCION                               GLOSA                          CARGOS             CARGOS             40           ABONOS               ABONOS  "
*  **** ****** ******** *************** ********** ****************************************** ****************************** ********** ****************** ******************** ********** ******************"
*  1234 123456 11/11/11
*
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
*
Formato = "999,999,999,999.99"
Nro_Cops = 1
TnCargos = 0
TnAbonos = 0
TgCargos = 0
TgAbonos = 0
* Secci¢n principal ------------------------------------------------------
*
Cancelar  = .F.
RegIni    = RECNO()
DO WHILE (.NOT. Cancelar) .AND. Nro_Cops>0
   GOTO RegIni
   NumPag   = 0
   Sigue    = .T.
   NumLin   = 0
   TgCargos = 0
   TgCtas40 = 0
   TiNroItm = 0
   TsNroAst = "     "
   DO WHILE VMOV->NroMes+VMOV->CodOpe = XsNroMes+XsCodOpe .AND. ! Cancelar
      * Inicia p gina nueva -------------------------------------------
      DO ResetPag
      TiNroItm = TiNroItm + 1
      TnCargos = 0
      TnCtas40 = 0
      TnAbonos = 0
      dFchDoc  = FchAst
      cTpoDoc  = []
      cNroDoc  = []
      cCodAux  = []
      cDesAux  = []
      cGlosa   = []
      DO CalImp
      DO LinImp
      TgCargos = TgCargos + TnCargos
      TgCtas40 = TgCtas40 + TnCtas40
      TgAbonos = TgAbonos + TnAbonos
      SELECT VMOV
      SKIP
      Cancelar = Cancelar .or. ( INKEY() = Escape )
   ENDDO
   DO ResetPag
   NumLin = PROW() + 1
   @ NumLin,0  SAY REPLICATE("-",Ancho)
   *!
   DO ResetPag
   NumLin = NumLin + 1
   @ NumLin,46  SAY "TOTAL DEL MES"
   @ NumLin,134 SAY TgCargos   PICTURE Formato
   @ NumLin,153 SAY TgCtas40   PICTURE "@( "+Formato
   @ NumLin,185 SAY TgAbonos   PICTURE Formato
   Nro_Cops = Nro_Cops - 1
ENDDO .NOT. Cancelar
*
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RETURN

PROCEDURE CalImp
****************
*** Anulando elementos de los archivos auxiliares ***
SELECT CGOS
ZAP
SELECT ABNS
ZAP
SELECT VMOV
TsNroAst = NROAST
SELECT RMOV
SEEK XsNroMes+XsCodOpe+TsNroAst
DO WHILE XsNroMes+XsCodOpe+TsNroAst = NroMes+CodOpe+NroAst .AND. ! EOF()
   IF EliItm = "ú"
      SKIP
      LOOP
   ENDIF
   IF ! TRIM(CodAux) == []
      dFchDoc  = FchDoc
      cTpoDoc  = CodDoc
      cNroDoc  = NroRef
      cCodAux  = ClfAux+CodAux
      =SEEK(cCodAux,"AUXI")
      cDesAux  = LEFT(AUXI->NomAux,40)
      XsNroRuc = IIF(CODAUX="99",NRORUC,AUXI->RUCAUX)
      IF XsCodOPe = "300"
         cDesAux = LEFT(AUXI->NomAux,32)+" "+XsNroRuc
      ENDIF
      cGlosa   = GloDoc
   ENDIF
   IF VMOV->CodMon = 1
      ImpNac = Import
      IF TpoCmb > 0
          ImpExt = Import/TpoCmb
      ELSE
          ImpExt = 0
      ENDIF
   ELSE
      ImpExt = Import
      ImpNac = Import*TpoCmb
   ENDIF
   IF ! CodCta = [40]
      IF TpoMov="D"
         SELECT CGOS
         SEEK RMOV->CodCta
         IF ! FOUND()
            APPEND BLANK
            REPLACE CodCta WITH RMOV->CodCta
         ENDIF
         REPLACE Import with Import + IIF(XiCodMon=1,ImpNac,ImpExt)
         TnCargos = TnCargos + IIF(XiCodMon=1,ImpNac,ImpExt)
      ELSE
         SELECT ABNS
         SEEK RMOV->CodCta
         IF ! FOUND()
            APPEND BLANK
            REPLACE CodCta WITH RMOV->CodCta
         ENDIF
         REPLACE Import with Import + IIF(XiCodMon=1,ImpNac,ImpExt)
         TnAbonos = TnAbonos + IIF(XiCodMon=1,ImpNac,ImpExt)
      ENDIF
   ELSE
      IF TpoMov ="D"
         TnCtas40 = TnCtas40 + IIF(XiCodMon=1,ImpNac,ImpExt)
      ELSE
         TnCtas40 = TnCtas40 - IIF(XiCodMon=1,ImpNac,ImpExt)
      ENDIF
   ENDIF
   SELECT RMOV
   SKIP
ENDDO
SELECT VMOV
RETURN

**********************************************************************
PROCEDURE LinImp
****************
DO RESETPAG
NumLin = Prow() + 1
@ NumLin,0  SAY TiNroItm  PICTURE "####"
@ NumLin,5  SAY TsNroAst  PICTURE "######"
@ NumLin,12 SAY  dFchDoc
@ NumLin,21 SAY  cTpoDoc
@ NumLin,25 SAY  cNroDoc
@ NumLin,38 SAY  cCodAux
@ NumLin,49 SAY  cDesAux PICTURE "@S42"
@ NumLin,92 SAY  cGlosa
SELECT CGOS
GOTO TOP
SELECT ABNS
GOTO TOP
lCtas40 = .t.
lCgos = .T.
lAbns = .T.
DO WHILE (lCgos .or. lAbns )
   DO ResetPag
   SELECT CGOS
   lCgos = ! EOF()
   IF lCgos
      @ NumLin,123 SAY CodCta
      @ NumLin,134 SAY Import   PICTURE Formato
      SKIP
   ENDIF
   IF lCtas40
      @ NumLin,153 SAY TnCtas40 PICTURE "@( "+Formato
      lCtas40 = .F.
   ENDIF
   SELECT ABNS
   lAbns = ! EOF()
   IF lAbns
      @ NumLin,174 SAY CodCta
      @ NumLin,185 SAY Import   PICTURE Formato
      SKIP
   ENDIF
   NumLin = PROW() + 1
ENDDO
RETURN

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   DO ADMMBPRN IN ADMPRINT
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
RETURN
