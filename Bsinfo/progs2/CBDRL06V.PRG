********************************************************************************
* Programa      : CBDRL06v.PRG                                                 *
* Objeto        : LIBRO VENTAS                                                 *
* Autor         : VETT                                                         *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 11/11/94                                                     *
********************************************************************************
PRIVATE XsNroMes
*** Abrimos Bases ****
sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
    close data
    return
endif
sele 4
use cbdrmovm order RMOV01 ALIAS RMOV
if !used(4)
    close data
    return
endif
sele 5
use cbdvmovm order VMOV01 ALIAS VMOV
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(7)
    close data
    return
ENDIF
SELE 8
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(8)
    close data
    return
ENDIF

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO VENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = "014"

XiNroMes = _Mes


@ 10,18 SAY "             Mes de Trabajo : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,48 GET XiNroMes PICT "@LZ 99" RANGE 1,12
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
=SEEK(XsCodOpe,"OPER")
SELECT VMOV

XsNroMes = transf(XiNroMES,"@L ##")

xLLave = XsNroMes+XsCodOpe
SEEK xLLave
IF ! FOUND()
   GsMsgErr = "No Existen registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 220
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN8A+_PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Titulo   = "L I B R O    V E N T A S"
SubTitulo= "MES DE "+MES(VAL(XsNroMes),1)+" DE "+TRANS(_ANO,"9999")
En1 = ""
En2 = ""
En3 = ""
En4 = ""
En5 = ""
En6 = "******** ****** **************************************** ********** ********** ****** ****************************************************** ******************************* ******************************* ***************"
En7 = "           COD.                                             Nro.     Nro.      Nro.                                                               ** MONTO IMPONIBLE **              ** IMPUESTOS **             IMPORTE    "
En8 = " FECHA     AUX.               C L E N T E                   RUC      FACTURA   REGIS.                      C O N C E P T O                      AFECTA         NO AFECTA         I.G.V.          OTROS            TOTAL     "
En9 = "******** ****** **************************************** ********** ********** ****** ****************************************************** *************** *************** *************** *************** ***************"
DIMENSION vImport(5),vTotal(5)

SELECT VMOV
SET DEVICE TO PRINT
PRINTJOB
   NumPag   = 0
   SELECT VMOV
   STORE 0 TO vTotal
   FOR k = 1 to 2
       DO CASE
          CASE k = 1
               XsCodOpe = "014"  && Facturas
          CASE k = 2
               XsCodOpe = "006"  && Notas de Cargo
       ENDCASE
       XLlave = XsNroMes+XsCodOpe
       Seek xLLave
       DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF() .AND. ! Cancelar
          STORE 0 TO vImport
          XsCodAux = ""
          XsNomAux = ""
          XsNroRef = ""
          XsRefImp = ""
          XsNroRuc = ""
          XfImport = 0
          XfImpInf = 0
          XfDolar  = 0
          XlAfecto = .F.
          CHK      = 0
          sKey = NroMes+CodOpe+NroAst
          SELECT RMOV
          SEEK sKey
          XsCtaAnt = SPACE(LEN(RMOV->CodCta))
          DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF()
             CHK        = CHK        + IIF(TpoMov="D",Import,-Import)
             IF  !(ELiItm = " ")
                 SKIP
                 LOOP
             ENDIF
             DO CASE
                CASE INLIST(CODCTA,"40111","40112","40113")
                     XlAfecto = .T.
                     XsCodAux   = CodAux
                     XsRefImp   = NroRef
                     vImport(3) = vImport(3) + IIF(TpoMov="H",Import,-Import)
                CASE CODCTA="40"
                     vImport(4) = vImport(4) + IIF(TpoMov="H",Import,-Import)
                     XsCodAux   = CodAux
                CASE CODCTA="7"
                     IF CodCta = XsCtaAnt
                        XfImpInf = XfImpInf + IIF(TpoMov="H",Import,-Import)
                     ELSE
                        XfImport = XfImport + IIF(TpoMov="H",Import,-Import)
                     ENDIF
                OTHER
                     =SEEK(CLFAUX+CODAUX,"AUXI")
                     XsCodAux   = CodAux
                     XsNroRef   = NroRef
                     XsNomAux   = IIF(CODAUX="99",GLODOC,AUXI->NOMAUX)
                     XsNroRuc   = IIF(CODAUX="99",NRORUC,AUXI->RUCAUX)
                     vImport(5) = vImport(5) + IIF(TpoMov="D",Import,-Import)
                     XfDolar  = XfDolar  + IIF(TpoMov="D",ImpUsa,-ImpUsa)
             ENDCASE
             SELECT RMOV
             XsCtaAnt = CODCTA
             SKIP
          ENDDO
          SELECT VMOV
          IF XlAfecto
             vImport(1) = XfImport
             vImport(2) = XfImpInf
          ELSE
             vImport(1) = 0
             vImport(2) = XfImport + XfImpInf
          ENDIF
          LsImport = []
          IF VMOV->CodMon <> 1
             LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,2))+")"
             IF RIGHT(LsImport,3)=".00"
                LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,0))+")"
             ENDIF
          ENDIF
          LsGloDoc = LEFT(VMOV->NotAst,54-LEN(LsImport))+LsImport
          DO ResetPag
          NumLin = PROW() + 2
          @ NumLin,0  SAY FchAst
          @ NumLin,10 SAY XsCodAux
          @ NumLin,16 SAY XsNomAux PICT "@S40"
          @ NumLin,58 SAY XsNroRuc PICT "@S8"
          @ NumLin,68 SAY XsNroRef
          @ NumLin,79 SAY NroAst
          @ NumLin,86 SAY LsGloDoc
          FOR i = 1 to 5
              Col = 141 + (i-1)*16
              vTotal(i) = vTotal(i) + vImport(i)
              @ NumLin,Col SAY vImport(i) PICTURE "@Z ####,###,###.##"
          NEXT
          IF CHK <> 0
             @ NumLin,Ancho SAY "*"
          ENDIF
          SKIP
          Cancelar = (INKEY() = ESCAPE) .OR. Cancelar
       ENDDO
   ENDFOR
   IF ! Cancelar
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("=",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL GENERAL **"
      FOR i = 1 to 5
          Col = 141 + (i-1)*16
          @ NumLin,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
      NEXT
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("=",Ancho)
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,0          SAY REPLICATE(".",Ancho)
      @ NumLin+1,100      SAY "VAN ....."
      FOR i = 1 to 5
          Col = 141 + (i-1)*16
          @ NumLin+1,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
      NEXT
   ENDIF
   DO ADMMBPRN &&IN ADMPRINT
   IF NumPag > 1
      NumLin = PROW() + 1
      @ NumLin,100      SAY "VIENEN .."
      FOR i = 1 to 5
          Col = 141 + (i-1)*16
          @ NumLin,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
      NEXT
      @ NumLin+1,0      SAY REPLICATE(".",Ancho)
   ENDIF
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
