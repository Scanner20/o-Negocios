********************************************************************************
* Progrma       : CBDRC04f.PRG                                                 *
* Objeto        : BALANCE DE CUENTA CORRIENTE                                  *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Reporte de Cuentas por Proyecto"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 22,68      COLOR W/N
@  8,11 CLEAR TO 21,69
@  8,11       TO 21,69

SELECT 5
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF

SELECT 4
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF

SELECT 1
USE CBDRMOVM ORDER RMOV08 ALIAS RMOV
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV
**********************************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCt1 = SPACE(LEN(CodCta))
XsCodCt2 = SPACE(LEN(CodCta))
XiTpoMov = 1
XsCodRe1 = SPACE(LEN(CTAS->CodRef))
XsCodRe2 = SPACE(LEN(CTAS->CodRef))
XsNomAu1 = SPACE(LEN(AUXI->NomAux))
XsNomAu2 = SPACE(LEN(AUXI->NomAux))
XdFecha1 = DATE()
XdFecha2 = DATE()
XdFchAs1 = DATE()
XdFchAs2 = DATE()
UltTecla = 0
i        = 1
TAux     = ''

@ 10,13 SAY "De Proyecto   : "
@ 11,13 SAY " A Proyecto   : "
@ 12,13 SAY "De Cuenta     : "
@ 13,13 SAY " A Cuenta     : "
@ 14,13 SAY "De Fecha      : "
@ 15,13 SAY " A Fecha      : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE i = 1
         XsClfAux = "DIV"
         SELE AUXI
         @ 10,30 GET XsCodRe1 PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .or. EMPTY(XsCodRe1)
            IF !CbdBusca("AUXI")
               XsCodRe1 = LEFT(AUXI->CodAux,LEN(XsCodRe1))
               CLOSE DATA
               RETURN
            ENDIF
         ENDIF
         IF !SEEK(XsClfAux+XsCodRe1,"AUXI") .AND. !EMPTY(XsCodRe1)
            UltTecla = 0
            CLOSE DATA
            RETURN
         ENDIF
         XsNomAu1=LEFT(AUXI.NomAux,30)
         @ 10,30 SAY XsCodRe1
         @ 10,35 SAY LEFT(AUXI.NomAux,30)
      CASE i = 2
         XsClfAux = "DIV"
         SELE AUXI
         @ 11,30 GET XsCodRe2 PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .or. EMPTY(XsCodRe2)
            IF !CbdBusca("AUXI")
               XsCodRe2 = LEFT(AUXI->CodAux,LEN(XsCodRe2))
               CLOSE DATA
               RETURN
            ENDIF
         ENDIF
         IF !SEEK(XsClfAux+XsCodRe2,"AUXI") .AND. !EMPTY(XsCodRe2)
            UltTecla = 0
            CLOSE DATA
            RETURN
         ENDIF
         XsNomAu2=LEFT(AUXI.NomAux,30)
         @ 11,30 SAY XsCodRe2
         @ 11,35 SAY LEFT(AUXI.NomAux,30)
      CASE I = 3
         SELECT CTAS
         @ 12,30 GET XsCodCt1 PICT REPLICATE("9",LEN(XsCodCt1))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCt1)
            IF ! CBDBUSCA("CTAS")
               I = 1
               LOOP
            ENDIF
            XsCodCt1 = CTAS->CodCta
         ENDIF
         @ 12,30 SAY XsCodCt1
         SEEK XsCodCt1
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 12,30 SAY CTAS->NomCta    PICT "@S25"
      CASE I = 4
         SELECT CTAS
         @ 13,30 GET XsCodCt2 PICT REPLICATE("9",LEN(XsCodCt2))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCt2)
            IF ! CBDBUSCA("CTAS")
               I = 1
               LOOP
            ENDIF
            XsCodCt2 = CTAS->CodCta
         ENDIF
         @ 13,30 SAY XsCodCt2
         SEEK XsCodCt2
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 13,30 SAY CTAS->NomCta    PICT "@S25"
      CASE I = 5
         SELECT CTAS
         @ 14,30 GET XdFchAs1 PICT "@E"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 14,30 SAY XdFchAs1 PICT "@E"
      CASE I = 6
         SELECT CTAS
         @ 15,30 GET XdFchAs2 PICT "@E"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 15,30 SAY XdFchAs2 PICT "@E"
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>6,6,i)
   i = IIF(i<1,1,i)
ENDDO
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
DO ADMPRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
***** Registro de inicio de Impresi¢n ******
SELECT RMOV
IF EMPTY(XsCodCt1)
   XsCodCt1 = [10401]
ENDIF
Llave = XsCodRe1+TRIM(XsCodCt1)
SEEK Llave
IF ! FOUND()
   IF RECNO(0) > 0 AND RECNO(0) < RECCO()
      GOTO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ELSE
      GsMsgErr = "No existen registros a Listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
suspe
IF EMPTY(XsCodRe2)
   XsCodRe2 = 'zzz'
ELSE
   XsCodRe2 = ALLTRIM(XsCodRe2)
ENDIF

*  set filter to RMOV->nromes=TRANSF(_MES,"@L ##")
IniImp   = _Prn8a+_Prn4    && 15   cpi
Ancho    = 174
Largo    = 66
LinFin   = 88 - 8
Tit_SIzq = GsNomCia
Tit_IIzq = GsDirCia
Tit_SDer = "FECHA : "+DTOC(DATE())
Tit_IDer = ""
Titulo   = "Reporte por Proyectos "+DTOC(GdFecha)
SubTitulo= ""
EN1    = "(Expresado EN "+IIF(XiCodMon = 1,"NUEVOS SOLES","DOLARES AMERICANOS")+")"
En2    = ""
En3    = ""
En4    = ""
En5 = "                                                                                                                                            "+time()
En6 = "****** ************* *********** ************ ******** *********** *************** *************** ******************** ************* ************* ************* *************"
En7 = "             No.                               FCH.                                                                          US$                                     SALDO     "
En8 = "FECHA   COMPROBANTE  DOCUMENTO   REFERENC.     VTO     NRO.CHEQUE  BANCO           GIRADO A        GLOSA                   IMPORTE         CARGOS      ABONOS        ACTUAL    "
En9 = "****** ************* *********** ************ ******** *********** *************** *************** ******************** ************* ************* ************* *************"
*                                                                                                                              9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99
*      0***** 7************ 21******** 32******** 43**** 50***55**********67**************83************* 99*******************120***********134 **********148***********162***********   179
*                1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8
*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901


Cancelar  = .F.
RegIni    = RECNO()
nImport   = 0

PRINTJOB
   GOTO RegIni
   NumPag   = 0
   LGNumItm = 0
   LGDolar  = 0
   LGCargos = 0
   LGAbonos = 0
   LsCodCta = SPAC(LEN(CodCta))
   XsRecno = RECNO()
   DO WHILE CodRef <= XsCodRe2 .AND. !EOF() .AND. !Cancelar
      LsCodRef = CodRef
      Quiebre2 = .T.
      DO WHILE CodRef = LsCodRef .AND. !EOF() .AND. !Cancelar
         LsCodCta = CodCta
         Quiebre1 = .T.
         IF Quiebre2
            DO RESETPAG
            Quiebre2 = .F.
            NumLin = PROW()+1
            =SEEK([DIV]+LsCodRef,"AUXI")
            @ NumLin,0   SAY _Prn6a+LsCodRef+" "+AUXI->NomAux+_Prn6b
            NumLin = PROW()+1
         ENDIF
         DO WHILE CodRef+CodCta <= LsCodRef+XsCodCt2 .AND. !EOF() .AND. !Cancelar
            DO LinImp
            SELE RMOV
            SKIP
            Cancelar = ( INKEY() = Escape )
         ENDDO
         Cancelar = ( INKEY() = Escape )
      ENDDO
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN
****************
PROCEDURE LinImp
****************
IF NumPag = 0 .OR. PROW() > LinFin
   DO RESETPAG
   IF Cancelar
      EXIT
   ENDIF
ENDIF
IF Quiebre1
   Quiebre1 = .F.
   NumLin = PROW()+1
   DO RESETPAG
   @ NumLin,0   SAY _Prn6a+LsCodCta+" "+CTAS->NomCta+_Prn6b
ENDIF
nImport= 0
NumItm = 0
=SEEK(NroMes+CodOpe+NroAst,"VMOV")
LsFchAst = DTOC(FchDOC)
LsFchAst = LEFT(LsFchAst,2)+SUBSTR(LsFchAst,4,2)+RIGHT(LsFchAst,2)
LsNroMes = NroMes
LsCodOpe = CodOpe
LsNroAst = NroAst
LsCodRef = CodRef
LsNroRef = NroRef
LsCodDoc = CodDoc
LsFchVto = DTOC(FchVto)
LsNroDoc = NroDoc
LsGloDoc = GloDoc
LsCodAux = CodAux
IF EMPTY(LsGloDoc)
   LsGloDoc = VMOV->NotAst
ENDIF
LiCodMon = CodMon
NumLin = PROW()+1
*@ NumLin , 0  SAY LsFchAst
@ NumLin , 7  SAY LsCodOpe
@ NumLin , 11 SAY LsNroMes+"-"+LsNroAst
@ NumLin , 21 SAY LsNroDoc
@ NumLin , 33 SAY ALLT(LsNroRef)
IF ! EMPTY(LsFchVto)
   @ NumLin , 46 SAY LsFchVto
ENDIF
=SEEK(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,"VMOV")
@ NumLin , 55 SAY VMOV.NroChq     PICTURE "@S11"
@ NumLin , 83 SAY LEFT(VMOV.Girado,15)     PICTURE "@!"
SELE RMOV
@ NumLin , 99 SAY LsGloDoc        PICTURE "@S20"
@ NumLin ,120 SAY CodCta
*IF SdoUsa >= 0
*   @ NumLin ,120 SAY SdoUsa       PICTURE "@Z 9,999,999.99"
*ELSE
*   @ NumLin ,120 SAY -SdoUsa      PICTURE "@Z 9,999,999.99-"
*ENDIF
*IF Cargos >= 0
*   @ NumLin ,134 SAY Cargos       PICTURE "9,999,999.99"
*ELSE
*   @ NumLin ,134 SAY -Cargos      PICTURE "9,999,999.99-"
*ENDIF
*IF Abonos >= 0
*   @ NumLin ,148 SAY Abonos       PICTURE "9,999,999.99"
*ELSE
*   @ NumLin ,148 SAY -Abonos      PICTURE "9,999,999.99-"
*ENDIF
RETURN
***********************************FIN
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
return
******************
PROCEDURE ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   Inicio  = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
