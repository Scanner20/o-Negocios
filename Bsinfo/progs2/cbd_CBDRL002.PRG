********************************************************************************
* Programa      : CBDRL002.PRG                                                 *
* Objeto        : DIARIO GENERAL POR OPERACION                                 *
* Autor         : JORGE MIESES VALENCIA                                        *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
DIMENSION DISTRIB(100,2)
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

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "DIARIO GENERAL"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = "001"
XsNroMes = transf(_MES,"@L ##")
nImpNac  = 0
nImpUsa  = 0
nImport  = 0

@ 10,22 SAY " Mes          : "
@ 11,22 SAY " Origen       :"
DO LIB_MTEC WITH 16

i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
     CASE i = 1
        @ 10,45 GET XsNroMes PICTURE "99"
        READ
        UltTecla = LASTKEY()

     CASE i = 2
        XiCodOpe=val(XsCodOpe)
        @ 11,45 GET XiCodOpe  PICTURE "@LZ ###"
        READ
        UltTecla = LASTKEY()
        XsCodOpe = Transf(XiCodOpe,"@L ###")
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
=SEEK(XsCodOpe,"OPER")
SELECT VMOV
xLLave = XsNroMes+TRIM(XsCodOpe)
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
Ancho = 149
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 7
IniImp  = _PRN8A+_PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Titulo   = "LISTADO DE MOVIMIENTOS CONTABLES"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = ""
En2 = TRIM(OPER->NomOpe)
En3 = ""
En4 = ""
En5 = ""
En6 = "******* ********** ******** ********** ********** **************************************** ******************************* *************************"
En7 = " COD.               FECHA      Nro.                                                                                                                 "
En8 = "AUXILI. REFERENCIA   DOC.   DOCUMENTO    CUENTA           G L O S A                              DEBE            HABER                              "
En9 = "******* ********** ******** ********** ********** **************************************** *************** *************** *************************"

SELECT VMOV
RegIni = RECNO()
nItm   = 0
SET DEVICE TO PRINT
PRINTJOB
   NumPag   = 0
   X0TotDbe = 0
   X0TotHbe = 0
   X0NumEle = 0
   GOTO RegIni
   DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF() .AND. ! Cancelar
      LsCodOpe = CodOpe
      X1NumEle = 0
      X1TotDbe = 0
      X1TotHbe = 0
      SaltoPag = .T.
      DO WHILE NroMes+CodOpe = XsNroMes+LsCodOpe .AND. ! EOF() .AND. ! Cancelar
         XsnroAst = NroAst
         DO LINIMP
         SELECT VMOV
         SKIP
         Cancelar = (INKEY() = ESCAPE) .OR. Cancelar
      ENDDO
      IF ! CANCELAR .AND. X1NumEle > 0
         DO ResetPag
         NumLin = PROW() + 1
         @ Numlin,000 SAY REPLICATE("*",Ancho)
         NumLin = PROW() + 1
         @ NumLin,000 SAY "** TOTAL **"
         @ NumLin,92  SAY X1TotDbe PICT "999,999,999.99"
         @ NumLin,108 SAY X1TotHbe PICT "999,999,999.99"
         X0TotDbe = X0TotDbe + X1TotDbe
         X0TotHbe = X0TotHbe + X1TotHbe
         X0NumEle = X0NumEle + 1
      ENDIF
   ENDDO
   IF X0NumEle > 1
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("=",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL GENERAL **"
      @ NumLin,92  SAY X0TotDbe PICT "999,999,999.99"
      @ NumLin,108 SAY X0TotHbe PICT "999,999,999.99"
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
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltoPag
   SaltoPag = .F.
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,Ancho -12  SAY "Continua.."
   ENDIF
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
****************
PROCEDURE LINIMP
****************
SELECT VMOV
XsNroAst = NroAst
sKey     = NroMes+CodOpe+NroAst
nDbe     = 0
nHbe     = 0
nItm     = 0
NumEle   = 0
nNumDis  = 0
IF FLGEST = "A"
   DO ResetPag
   NumLin = Prow() + 1
   @ NumLin,00  SAY TRANSF(DAY(FCHAST),"@L ##")+"-"+TRANSF(MONTH(FCHAST),"@L ##")
   @ NumLin,06  SAY NroAst
   @ NumLin,72  SAY VMOV->NotAst
   @ NumLin,129 SAY "*** ANULADO***"
ENDIF
SELECT RMOV
SEEK sKey
DO WHILE  ! EOF() .AND.  NroMes+CodOpe+NroAst = sKey
  *IF VMOV->CodMon=1 AND ELiItm = "ø"
   IF VMOV->CodMon=1 AND ELiItm = ":"  
      SKIP
      LOOP
   ENDIF
   IF nItm = 0
      DO ResetPag
      NumLin = PROW() + 1
      @ NumLin,2   SAY "ORIGEN  :"+XsCodOpe
      @ NumLin,21  SAY "FECHA   :"+Dtoc(FCHAST)
      @ NumLin,48  SAY "ASIENTO :"+NroAst
   ENDIF
   DO ResetPag
   NumLin = Prow() + 1
   =SEEK(ClfAux+CodAux,"AUXI")
   =SEEK(Codcta,"CTAS")
   @ NumLin,0   SAY CodAux
   @ NumLin,8   SAY NroRef
   @ NumLin,19  SAY FCHDOC
   @ NumLin,28  SAY NroDoc
   @ NumLin,39  SAY CodCta
   LsGloDoc = []
   LsImport = []
   IF RMOV->CodMon <> 1
      LsImport = 'US$' + ALLTRIM(STR(ImpUsa,14,2))
      IF RIGHT(LsImport,3)=".00"
         LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
      ENDIF
   ENDIF
   LsGloDoc = LEFT(LsGloDoc,60-LEN(LsImport))+LsImport
   DO CASE
      CASE ! EMPTY(RMOV->Glodoc)
         LsGloDoc = LEFT(GloDoc,40-LEN(LsImport))+LsImport
         @ NumLin,50  SAY LsGloDoc PICT "@S40"
      CASE ! EMPTY(AUXI->NomAux)
         LsGloDoc = LEFT(AUXI->NomAux,40-LEN(LsImport))+LsImport
         @ NumLin,50  SAY LsGloDoc PICT "@S40"
      OTHER
         LsGloDoc = LEFT(VMOV->NotAst,40-LEN(LsImport))+LsImport
         @ NumLin,50  SAY LsGloDoc PICT "@S40"
   ENDCASE
   IF TpoMov='D'
      @ NumLin,92  SAY Import PICT "999,999,999.99"
      nDbe = nDbe + Import
   ELSE
      @ NumLin,108 SAY Import PICT "999,999,999.99"
      nHbe = nHbe + Import
   ENDIF
   nItm = nItm + 1
   SKIP
ENDDO
SELECT VMOV
IF nItm = 0 .AND. ! FLGEST = "A"
   DO ResetPag
   NumLin = Prow() + 1
   @ NumLin,00  SAY TRANSF(DAY(FCHAST),"@L ##")+"-"+TRANSF(MONTH(FCHAST),"@L ##")
   @ NumLin,06  SAY NroAst
   @ NumLin,72  SAY VMOV->NotAst
ENDIF
NumLin = PROW() + 1
@ NumLin,92  SAY "--------------  --------------"
NumLin = PROW() + 1
@ NumLin,52  SAY "TOTAL ASIENTO "
@ NumLin,92  SAY nDbe PICT "999,999,999.99"
@ NumLin,108 SAY nHbe PICT "999,999,999.99"
