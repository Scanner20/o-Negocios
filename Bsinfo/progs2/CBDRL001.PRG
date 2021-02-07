********************************************************************************
* Programa      : CBDRL001.PRG                                                 *
* Objeto        : DIARIO GENERAL POR OPERACION                                 *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
*** Abrimos Bases ****
**DIMENSION DISTRIB(100,2)
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

@  9,04 FILL  TO 15,76      COLOR W/N
@  8,05 CLEAR TO 14,77
@  8,05       TO 14,77

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = "001"
XsNroMes = transf(_MES,"@L ##")
XsDesde  = SPACE(LEN(RMOV->NroAst))
XsHasta  = SPACE(LEN(RMOV->NroAst))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XiTipo = 2

@ 09,18 SAY "          Fecha de Registro : "
@ 11,18 SAY "                  Operaci¢n : "
@ 12,18 SAY " Comprobante         Desde  :            Hasta :"
@ 13,18 SAY "          Resumen de cuentas: "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 09,48 GET XdFchAst
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE OPER
         @ 11,48 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF CBDBUSCA("OPER")
               XsCodOpe = OPER->CodOpe
            ELSE
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         SEEK XsCodOpe
         IF !FOUND() AND !EMPTY(CodOpe)
            GsMsgErr = "Operaci¢n no registrada"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE i = 3
         @ 12,48 GET XsDesde PICTURE REPLI("9",LEN(RMOV->NroAst))
         @ 12,67 GET XsHasta PICTURE REPLI("9",LEN(RMOV->NroAst))
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         VecOpc(1)="Si"
         VecOpc(2)="No"
         XiTipo  = Elige(XiTipo,13,48,2)
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 4 , i + 1, 4 )

      CASE UltTecla = Enter
         IF  i < 4
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
XsDesde = TRIM(XsDesde)
XsHasta = LEFT(TRIM(XsHasta)+"zzzzzz",LEN(RMOV->NroAst))
*** FILTROS **
IF ! EMPTY(XdFchAst)
   SET ORDER TO VMOV03
   xLLave = XsNroMes+XsCodOpe+DTOC(XdFchAst,1)
   vClave = [NroMes+CodOpe+DTOC(FchAst,1)]
ELSE
   SET ORDER TO VMOV01
   xLLave = XsNroMes+trim(XsCodOpe)
   vClave = [NroMes+CodOpe]
ENDIF
SEEK xLLave+TRIM(XsDesde)
IF ! FOUND() AND RECNO(0)>0
   GO RECNO(0)
   XsDesde = NroAst
   SEEK xLLave+TRIM(XsDesde)
   IF EOF()
      GsMsgErr = "No Existen registros a Listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
ELSE
   IF EOF()
      GsMsgErr = "No Existen registros a Listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
**  Base auxiliar
IF XiTipo=1
   Arctmp = SYS(3)
   SELE RMOV
   COPY STRU TO &ArcTmp
   SELE 0
   USE &ArcTmp  ALIAS RESU EXCL
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
   INDEX ON CodCta TAG RESU01
   SET ORDER TO RESU01
ENDIF
**
SELE VMOV
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 152
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo + 14
*IniImp  = _PRN8A
IniImp  = _PRN8A+_PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Titulo   = "D I A R I O  G E N E R A L"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = "@LIBRO "+XsCodOpe
En2 = TRIM(OPER->NomOpe)
En3 = ""
En4 = ""
En5 = ""
IF ! EMPTY(XdFchAst)
   xDia = TRANSF(DAY(XdFchAst)  ,"@L ##")
   xMes = TRANSF(MONTH(XdFchAst),"@L ##")
   xAno = TRANSF(YEAR(XdFchAst) ,"@L ####")
   xOpe = CHR(14)+XsCodOpe+CHR(20)+CHR(0)
   En1 = ">ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   En2 = ">³      LIBRO  "+xOpe+"     ³"
   En3 = ">ÃÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄ´"
   En4 = ">³ FECHA ³ "+xDia+" ³ "+xMes+" ³ "+xAno+" ³"
   En5 = ">ÀÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÙ"
ENDIF
*En6 = "***** ****** ********* ******* ************** ****** ********** ****** **************************************** *** *******************************"
*En7 = "      COMPRO CUENTA     COD.     REFERENCIA   FECHA             FECHA                                                                              "
*En8 = "FECHA BANTE  CONTABLE  AUXILI. Nro.      Tpo. DCMTO. DOCUMENTO  VCMTO.              D E T A L L E               MON      DEBE             HABER    "
*En9 = "***** ****** ********* ******* ************** ****** ********** ****** **************************************** *** *************** ***************"
****   12345 123456 123456789 123456  123456789- 123 123456 123456789- 123456 123456789-123456789-123456789-123456789- 123 9999,999,999.99 9999,999,999.99
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
*      0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
*
En6 = "***** ******** ******** ******** ******************* ********** ********** ********** ******************************* *** *************** ***************"
En7 = "       COMPRO  CUENTA    COD.         REFERENCIA      FECHA                  FECHA                                                                       "
En8 = "FECHA  BANTE   CONTABLE AUXILI   Nro.           Tpo.  DCMTO.     DOCUMENTO   VCMTO.              D E T A L L E        MON      DEBE             HABER    "
En9 = "***** ******** ******** ******** ******************* ********** ********** ********** ******************************* *** *************** ***************"
****   12345 12345678 12345678 12345678 12345678901234-1234 1234567890 1234567890 1234567890 123456789-123456789-123456789-1 123 9999,999,999.99 9999,999,999.99
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
*      0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
*
SELECT VMOV
RegIni = RECNO()
nItm   = 0
SET DEVICE TO PRINT
PRINTJOB
   NumPag   = 0
   SELE OPER
   SEEK TRIM(XsCodOpe)
   DO WHILE !EOF()  .AND. CodOpe = TRIM(XsCodOpe) .AND. !Cancelar
       IF EMPTY(XsCodOpe)   && .and. XiTipo = 1
          xLLave = XsNroMes+OPER->CodOpe
          En1 = "@LIBRO "+CodOpe
          En2 = TRIM(OPER->NomOpe)
       ENDIF
       SELE VMOV
       SEEK xLlave
       X0TotDbe = 0
       X0TotHbe = 0
       X0NumEle = 0
      *GOTO RegIni
       SaltoPag = .T.
       DO WHILE &vClave = xLLave .AND. ! EOF() .AND. ! Cancelar .AND. NroAst<=XsHasta
          X1TotDbe = 0
          X1TotHbe = 0
          XsNroMes = NroMes
          SubTitulo= "MES DE "+MES(VAL(XsNroMes),1)+" DE "+TRANS(_ANO,"9999")
          DO WHILE &vClave = xLLave .AND. ! EOF() .AND. ! Cancelar .AND. NROMES = XsNroMes .AND. NroAst<=XsHasta
             LdFchAst = FchAst
             XsNroAst = NroAst
             IF XiTipo = 2
                DO LINIMP
             ELSE
                DO LINRES
             ENDIF
             SELECT VMOV
             SKIP
             Cancelar = (INKEY() = ESCAPE) .OR. Cancelar
          ENDDO
          IF ! CANCELAR AND XiTipo = 2
             DO ResetPag
             NumLin = PROW() + 1
             @ Numlin,000 SAY REPLICATE("*",Ancho)
             NumLin = PROW() + 1
             @ NumLin,000 SAY "** TOTAL **"
             @ NumLin,116 SAY X1TotDbe PICT "9999,999,999.99"
             @ NumLin,132 SAY X1TotHbe PICT "9999,999,999.99"
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
          @ NumLin,116 SAY X0TotDbe PICT "9999,999,999.99"
          @ NumLin,132 SAY X0TotHbe PICT "9999,999,999.99"
          NumLin = PROW() + 1
          @ Numlin,000 SAY REPLICATE("=",Ancho)
       ENDIF
       IF ! Cancelar  .AND. ! EMPTY(XdFchAst)
          IF PROW() > (LinFin - 4)
             SaltoPag = .T.
          ENDIF
          DO ResetPag
          IF EMPTY(XsDesde) AND EMPTY(XsHasta)
             NumLin = LINFIN - 3
             @ NumLin,0 SAY _PRN7A
             @ NumLin,0 SAY "ELABORADO:____________   REVISADO  :___________   PROCESADO :___________"+_PRN7B
          ENDIF
       ENDIF
       IF XiTipo = 1
          DO TotRESU
       ENDIF
       SELE OPER
       SKIP
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
IF XiTipo = 1
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
ENDIF
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
   @ NumLin,80  SAY VMOV->NotAst PICT "@S31"
   @ NumLin,129 SAY "*** ANULADO***"
ENDIF
SELECT RMOV
SEEK sKey
*XcEliItm = "ú"
XcEliItm = "*"
lAuto = .F.
DO WHILE  ! EOF() .AND.  RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst = sKey
   *IF RMOV.EliItm = "ú"
   IF RMOV.EliItm = "*"
      lAuto = .T.
     *DO Calimp
     *IF XiCodMon <> 1
     *   IF TpoMov='D'
     *      nDbe = nDbe + nImpUsa
     *   ELSE
     *      nHbe = nHbe + nImpUsa
     *   ENDIF
     *ELSE
     *   IF TpoMov='D'
     *      nDbe = nDbe + nImpNac
     *   ELSE
     *      nHbe = nHbe + nImpNac
     *   ENDIF
     *ENDIF
      SKIP
      LOOP
   ENDIF
   SELECT CTAS
   SEEK RMOV->CodCta
   SELECT RMOV
   DO ResetPag
   NumLin = Prow() + 1
   @ NumLin,00  SAY TRANSF(DAY(FCHAST),"@L ##")+"-"+TRANSF(MONTH(FCHAST),"@L ##")
   @ NumLin,06  SAY NroAst
   @ NumLin,15  SAY CodCta
   @ NumLin,24  SAY CodAux
   @ Numlin,33  SAY NroDoc
   @ NumLin,48  SAY CodDoc
   IF ! EMPTY(FCHDOC)
     ** @ NumLin,53  SAY TRANSF(DAY(FCHDOC),"@L ##")+TRANSF(MONTH(FCHDOC),"@L ##")+RIGHT(STR(YEAR(FCHDOC),4,0),4)
     	@ NumLin,53  SAY FchDoc
   ENDIF
   @ NumLin,64  SAY NroRef
   **@ NumLin,75  SAY TRANSF(DAY(FCHVTO),"@L ##")+TRANSF(MONTH(FCHVTO),"@L ##")+RIGHT(STR(YEAR(FCHVTO),4,0),4)
   @ NumLin,75  SAY FchVto
  * @ NumLin,71  SAY NroRec
   =SEEK(ClfAux+CodAux,"AUXI")
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
         @ NumLin,86  SAY LsGloDoc PICT "@S31"
      CASE ! EMPTY(AUXI->NomAux)
         LsGloDoc = LEFT(AUXI->NomAux,40-LEN(LsImport))+LsImport
         @ NumLin,86  SAY LsGloDoc PICT "@S31"
      OTHER
         LsGloDoc = LEFT(VMOV->NotAst,40-LEN(LsImport))+LsImport
         @ NumLin,86  SAY LsGloDoc PICT "@S31"
   ENDCASE
   DO CALIMP
   IF CTAS->CODREF = "00000"
      LsCODREF = "00000"
   ELSE
      LsCODREF = CodRef
   ENDIF
   IF EMPTY(LsCodRef)
      nNumDis = nNumDis + 1
   ENDIF
   x = 0
**   FOR I = 1 TO NumEle
**      IF DISTRIB[I,1] = LsCODREF
**         X = I
**         EXIT
**      ENDIF
**   ENDFOR
**   IF X = 0
**      NumEle = NumEle + 1
**      x      = NumEle
**      DISTRIB[X,1] = LsCodRef
**      DISTRIB[X,2] = 0
**   ENDIF
   IF XiCodMon <> 1
      IF RMOV->CodMon <> XiCodMon
         @ Numlin,118 SAY IIF(RMOV.CodMon=1,'S/.','US$')
        *@ NumLin,104 SAY Import
      ENDIF
      IF TpoMov='D'
         @ NumLin,122 SAY nImpUsa PICT "9999,999,999.99"
      **   DISTRIB[X,2] = DISTRIB[X,2] + nImpUsa
         nDbe = nDbe + nImpUsa
      ELSE
         @ NumLin,138 SAY nImpUsa PICT "9999,999,999.99"
      **   DISTRIB[X,2] = DISTRIB[X,2] - nImpUsa
         nHbe = nHbe + nImpUsa
      ENDIF
   ELSE
      IF TpoMov='D'
         @ NumLin,122 SAY nImpNac PICT "9999,999,999.99"
      **   DISTRIB[X,2] = DISTRIB[X,2] + nImpNac
         nDbe = nDbe + nImpNac
      ELSE
         @ NumLin,138 SAY nImpNac PICT "9999,999,999.99"
      **   DISTRIB[X,2] = DISTRIB[X,2] - nImpNac
         nHbe = nHbe + nImpNac
      ENDIF
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
   @ NumLin,80  SAY VMOV->NotAst PICT "@S31"
ENDIF
DO ResetPag
NumLin = PROW() + 1
@ NumLin,0   SAY REPLICATE("-",ANCHO)
DO ResetPag
NumLin = PROW() + 1
@ NumLin,102 SAY "TOTALES"
@ NumLin,118 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@ NumLin,122 SAY nDbe PICT "9999,999,999.99"
@ NumLin,138 SAY nHbe PICT "9999,999,999.99"
DO ResetPag
NumLin = PROW() + 1
@ NumLin,118 SAY IIF(VMOV.CodMon=2,"S/.","US$")
IF VMOV.CodMon = 1
   @ NumLin,122 SAY VMOV->DbeUsa PICT "9999,999,999.99"
   @ NumLin,138 SAY VMOV->HbeUsa PICT "9999,999,999.99"
ELSE
   @ NumLin,122 SAY VMOV->DbeNac PICT "9999,999,999.99"
   @ NumLin,138 SAY VMOV->HbeNac PICT "9999,999,999.99"
ENDIF
****** DESCRIBIENDO ERRORES *****
IF nDbe <> nHbe
   DO ResetPag
   NumLin = PROW() + 1
  *IF lAuto
  *   @ NumLin,0 SAY "OJO   : *** TOTAL NO TOMA LAS CUENTAS AUTOMATICAS - ASIENTO DESBALANCEADO ***"
  *ELSE
      @ NumLin,0 SAY "ERROR : *** ASIENTO DESBALANCEADO ***"
  *ENDIF
ENDIF
OK = .T.
**FOR I = 1 TO NumEle
**    IF DISTRIB[I,2] <> 0
**       OK = .F.
**       EXIT
**    ENDIF
**ENDFOR
*IF ! OK
*   DO ResetPag
*   NumLin = PROW() + 1
*   @ NumLin,0 SAY "ERROR : *** ASIENTO MAL DISTRIBUIDO ***"
*ENDIF
*IF OK .AND. nNumDis > 0
*   DO ResetPag
*   NumLin = PROW() + 1
*   @ NumLin,0 SAY "ERROR : *** ASIENTO NO DISTRIBUIDO ***"
*ENDIF
NumLin = PROW() + 1
@ NumLin,0   SAY REPLICATE("-",Ancho)
X1TotDbe = X1TotDbe + nDbe
X1TotHbe = X1TotHbe + nHbe
RETURN
***********************************FIN
****************
PROCEDURE LINRES
****************
SELECT VMOV
XsNroAst = NroAst
sKey     = NroMes+CodOpe+NroAst
nDbe     = 0
nDbe2    = 0
nHbe     = 0
nHbe2    = 0
nItm     = 0
NumEle   = 0
nNumDis  = 0
IF FLGEST = "A"
ENDIF
SELECT RMOV
SEEK sKey
DO WHILE  ! EOF() .AND.  RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst = sKey
   DO ResetPag
   =SEEK (CodCta,"CTAS")
   =SEEK(ClfAux+CodAux,"AUXI")
   LsGloDoc = []
   LsImport = []
   IF TpoMov='D'
      nDbe = nDbe + Import
      nDbe2= nDbe2+ ImpUsa
   ELSE
      nHbe = nHbe + Import
      nHbe2= nHbe2+ ImpUsa
   ENDIF
   SELE RESU
   SEEK RMOV->CodCta+RMOV->TpoMov
   IF !FOUND()
      APPEN BLANK
      REPLACE CodCta WITH RMOV->CodCta
      REPLACE Tpomov WITH RMOV->TpoMov
   ENDIF
   REPLACE Import WITH Import + RMOV->Import
   REPLACE ImpUsa WITH ImpUsa + RMOV->ImpUsa
   SELE RMOV
   nItm = nItm + 1
   SKIP
ENDDO
SELECT VMOV
IF nItm = 0 .AND. ! FLGEST = "A"
ENDIF
****** DESCRIBIENDO ERRORES *****
X1TotDbe = X1TotDbe + nDbe
X1TotHbe = X1TotHbe + nHbe
RETURN
*****************
PROCEDURE TotResu
*****************
SELE RESU
GO TOP
IF EOF()
   RETURN
ENDIF
STORE 0 TO TotNacDG,TotNacHG,TotExtDG,TotExtHG,NumItmG
DO WHILE !EOF() AND !Cancelar
   LsCodCta1 = LEFT(CodCta,2)
   STORE 0 TO TotNacD1,TotNacH1,TotExtD1,TotExtH1,NumItm1
   DO WHILE !EOF() AND CodCta=LsCodCta1  AND !Cancelar
      LsCodCta2 = LEFT(CodCta,3)
      STORE 0 TO TotNacD2,TotNacH2,TotExtD2,TotExtH2,NumItm2
      DO WHILE !EOF() AND CodCta=LsCodCta2   AND !Cancelar
          LsCodCta = CodCta
          STORE 0 TO TotNacD,TotNacH,TotExtD,TotExtH,NumItm
          DO WHILE !EOF() AND CodCta=LsCodCta   AND !Cancelar
             IF TpoMov = "D"
                TotNacD = TotNacD + Import
                TotExtD = TotExtD + ImpUsa
             ELSE
                TotNacH = TotNacH + Import
                TotExtH = TotExtH + ImpUsa
             ENDIF
             NumItm = NumItm + 1
             SKIP
          ENDDO
          IF !Cancelar AND NumItm>0
             DO ResetPag
             NumLin = PROW() + 1
             =SEEK(LsCodCta,"CTAS")
             @NumLin,05  SAY LsCodCta+" "+CTAS->NomCta
             @NumLin,106 SAY TotNacD  PICT "999,999,999.99"
             @NumLin,122 SAY TotNacH  PICT "999,999,999.99"
             NumItm2  = NumItm2 + 1
             TotNacD2 = TotNacD2 + TotNacD
             TotExtD2 = TotExtD2 + TotExtD
             TotNacH2 = TotNacH2 + TotNacH
             TotExtH2 = TotExtH2 + TotExtH
          ENDIF
      ENDDO
      IF !Cancelar
          DO ResetPag
          NumLin = PROW() + 1
          =SEEK(LsCodCta2,"CTAS")
          @ NumLin,00 SAY _PRN6a
          @NumLin,03  SAY LsCodCta2+" "+CTAS->NomCta
          @NumLin,106 SAY TotNacD2  PICT "999,999,999.99"
          @NumLin,122 SAY TotNacH2  PICT "999,999,999.99"
          @ NumLin,123 SAY _PRN6b
          NumItm1 = NumItm1 + 1
          TotNacD1 = TotNacD1 + TotNacD2
          TotExtD1 = TotExtD1 + TotExtD2
          TotNacH1 = TotNacH1 + TotNacH2
          TotExtH1 = TotExtH1 + TotExtH2
         *NumLin = PROW() + 1
         *@ NumLin , 00 SAY [ ]
      ENDIF
   ENDDO
   IF !Cancelar
       DO ResetPag
       NumLin = PROW() + 1
       =SEEK(LsCodCta1,"CTAS")
       @ NumLin,00 SAY _PRN6a
       @NumLin,02  SAY LsCodCta1+" "+CTAS->NomCta
       @NumLin,106 SAY TotNacD1  PICT "999,999,999.99"
       @NumLin,122 SAY TotNacH1  PICT "999,999,999.99"
       @ NumLin,123 SAY _PRN6b
       NumItmG = NumItmG + 1
       TotNacDG = TotNacDG + TotNacD1
       TotExtDG = TotExtDG + TotExtD1
       TotNacHG = TotNacHG + TotNacH1
       TotExtHG = TotExtHG + TotExtH1
      *NumLin = PROW() + 1
      *@ NumLin , 00 SAY [ ]
   ENDIF
ENDDO
IF !Cancelar
    DO ResetPag
    NumLin = PROW() + 1
    @ NumLin,00 SAY _PRN6a
    @NumLin,00  SAY "T O T A L   O P E R A C I O N "+OPER->CoDOpe+" "+TRIM(OPER->NomOpe)
    @NumLin,106 SAY TotNacDG  PICT "999,999,999.99"
    @NumLin,122 SAY TotNacHG  PICT "999,999,999.99"
    @ NumLin,123 SAY _PRN6b
ENDIF
ZAP
RETURN
*****************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
return
