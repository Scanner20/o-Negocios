********************************************************************************
* Programa      : CBDRGHON.PRG                                                 *
* Objeto        : LIBRO HONORARIOS                                             *
* Autor         : AJLP                                                         *
* Creaci¢n      : 20/05/99                                                     *
********************************************************************************
PRIVATE XsNroMes
*** Abrimos Bases ****
CLOSE DATA
USE CBDMCTAS IN 0 ORDER CTAS01 ALIAS CTAS
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE CBDRMOVM IN 0 ORDER RMOV01 ALIAS RMOV
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE CBDVMOVM IN 0 ORDER VMOV01 ALIAS VMOV
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE CBDMTABL IN 0 ORDER TABL01   ALIAS TABL
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE CBDMAUXI IN 0 ORDER AUXI01   ALIAS AUXI
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE CBDTOPER IN 0 ORDER OPER01   ALIAS OPER
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE ADMMTCMB IN 0 ORDER TCMB01   ALIAS TCMB
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
*
USE ADMTCNFG IN 0 ORDER CNFG01   ALIAS CNFG
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
******
Arch = PathUser+Sys(3)
CREATE TABLE &Arch. (Divi C(5) , CodAux C(8), FchAst D , NroAst C(6) ,;
       Proveedor C(30),RucAux C(10), NroDoc C(14),Afecta N(14,2),;
       NAfecta N(14,2),NoGrava N(14,2), ImpIgv N(14,2), Importe N(14,2),;
       Gravada N(14,2),CtaCate N(14,2), Fonavi N(14,2), Redondeo N(14,2),Flag C(1),ImporUS N(14,2),;
       TpoCmb N(10,4),FlgEst C(1) ,FchDoc D , CodMon N(1,0) , Afecto C(1),;
       NroRef C(10),SerDoc C(3), CodDoc C(4) )
use
USE &Arch IN 0 ALIAS TEMP EXCLU
SELE TEMP
INDEX ON NroAst TAG TEMP01
SET ORDER TO TEMP01

SELE CNFG
SEEK 'HON'
XsCmpOp = CNFG.CodOpe
XsCmp60 = CNFG.CtaBase
XsCmp40 = CNFG.CtaImpu
XsCmp42 = CNFG.CtaTota
XsCmp4ta = CNFG.Cta4tac
XsCmpFon = CNFG.CtaFona

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO HONORARIOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = XsCmpOp
XsNombre =[]
XiNroMes = _Mes
XxImp=0
XsCodAux = SPACE(4)
XsCodDiv = SPACE(3)
XsNomDiv = []
XsCodRef = []
XsNroAst = []
XsClfAux = [010]
XnFormat = 1

@ 10,18 SAY "             Mes de Trabajo : "
@ 11,18 SAY " Operacion  : "
@ 12,18 SAY " Formato    : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,48 GET XiNroMes PICT "@LZ 99" RANGE 1,12
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE OPER
         @ 11,33 GET XsCodOpe PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCODope)
            IF ! CBDBUSCA("OPER")
               LOOP
            ENDIF
            XsCODOPE = CodOpe
            XsNombre = OPER->NomOpe
            UltTecla = Enter
         ENDIF
         IF UltTecla <>F8
            SELE OPER
            SEEK XSCODOPE
            XsNombre = OPER->NomOpe
         ENDIF
         @ 11,33 SAY XsCodOpe
         @ 11,37 SAY XsNombre
      CASE i = 3
         XsClfAux = [010]
         @ 12,33 GET XnFormat FUNC '^ Oficial;Interno'
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)
      CASE UltTecla = Abajo
         i = IIF( i< 3 , i + 1, 3 )
      CASE UltTecla = Enter
         IF  i < 3
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
DO XPROCESA
DO XIMPRIME
RELEASE XsCmp*
CLOSE ALL
RETURN

*******************
PROCEDURE xImprime
*******************
SELE TEMP
XsCodDiv = TRIM(XsCodDiv)
LsLLave = XsCodDiv
LsTstImp = []  &&[TEMP.Divi = XsCodDiv]
GO TOP
IF EOF()
   GsMsgErr = [No existen Registros]
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF EMPTY(LsLlave)
   xWHILE = [.T.]
   GO TOP
ELSE
   SEEK LsLlave
   IF !FOUND()
      IF RECNO(0) > 0
         GO RECNO(0)
         IF DELETE()
            SKIP
         ENDIF
      ENDIF
   ENDIF
ENDIF

xWHILE = LsTstImp
xFOR   = []
Largo = 66
IniPrn = [_Prn0+_Prn5A+chr(Largo)+_Prn5b+_Prn4]
sNomRep = IIF(XnFormat=1,'CBDRGHON',[CBDRGCMA])
DO ADMPRINT WITH "REPORTS"
RETURN
******************
PROCEDURE xProcesa
******************
WAIT WIND PADC([... Espere un Momento Procesando Informaci¢n ...],72) NOWAIT
DIMENSION vImport(10),vTotal(10)
   SELECT VMOV
   Seek xLLave
   STORE 0 TO vTotal, vGenera
   DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
      STORE 0  TO vImport,vGenera,XfImport,XfImpInf,XfDolar,CHK
      STORE [] TO XsCodAux,XsNomAux,XsNroDoc,XsRefImp,XsNroRuc,XsAfecto,XsNroRef,XsCodDoc
      STORE FchAst TO XdFchAst ,XdFchDoc
      XsNroAst = NroAst
      XiCodMon = CodMon
      XsFlgEst = FlgEst
      XlAfecto = .F.
      XfTpoCmb = VMOV.TpoCmb
      sKey = NroMes+CodOpe+NroAst
      SELECT RMOV
      SEEK sKey
      IF !FOUND()
          XsNomAux   = [******* ANULADO *******]
      ENDIF
      STORE.F.TO XCompra, XNuevo,XCmp40
      DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF() AND XsFlgEst#'A'
         IF EliItm = 'ú'
            SKIP
            LOOP
         ENDIF
         CHK  = CHK + IIF(TpoMov="D",Import,-Import)
         DO CASE
            CASE INLIST(CodCta,&XsCmp42) AND !INLIST(CodCta,&XsCmp60)
                 XCompra = .T.
                 XfImport = IIF(TpoMov=[H],Import,-Import)
                 vImport(1) = vImport(1) + XfImport
                 XfDolar  = XfDolar  + IIF(TpoMov="H",ImpUsa,-ImpUsa)
                 IF !EMPTY(ClfAux) AND !EMPTY(CodAux) 
                    =SEEK(ClfAux+CodAux,"AUXI")
                    XsCodAux = CodAux
                    XdFchDoc = FchDoc
                    XsNroDoc = NroDoc
                    XsCodDoc = CodDoc
                    XsNomAux = IIF([VARIO]$AUXI.NomAux,GloDoc,AUXI->NomAux)
                    XsNroRuc = IIF([VARIO]$AUXI.NomAux,NroRuc,AUXI->RucAux)
                    XsCodRef = CodRef
                    XsNroRef = NroRef
                 ENDIF
            CASE INLIST(CodCta,&XsCmp40)
                 XCmp40 = .T.
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(2) = vImport(2) + XfImport
            CASE INLIST(CodCta,&XsCmp60) AND Afecto = 'A'
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(3) = vImport(3) + XfImport
                 XsAfecto   = Afecto
            CASE INLIST(CodCta,&XsCmp60) AND Afecto = 'I'
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(4) = vImport(4) + XfImport
                 XsAfecto   = Afecto
            CASE INLIST(CodCta,&XsCmp60) AND Afecto = 'G'
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(5) = vImport(5) + XfImport
                 XsAfecto   = Afecto
            CASE INLIST(CodCta,&XsCmp60) AND Afecto = 'N'
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(6) = vImport(6) + XfImport
                 XsAfecto   = Afecto
            CASE INLIST(CodCta,&XsCmp4ta)
                 Xcmp40 = .T.
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(7) = vImport(7) + XfImport
            CASE INLIST(CodCta,&XsCmpFon)
                 XCmp40 = .T.
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(8) = vImport(8) + XfImport
            OTHER
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(9) = vImport(9) + XfImport
         ENDCASE
         SELECT RMOV
         SKIP
         IF EliItm = 'ú'
            SKIP
            LOOP
         ENDIF
         IF XCompra AND INLIST(CodCta,&XsCmp60)
            XNuevo = .T.
         ENDI
         SELECT RMOV
      ENDDO
      DO GrabCmp
      SELE VMOV
      SKIP
   ENDDO
RETURN

PROCEDURE GrabCmp
*================
      SELE TEMP
      APPEND BLANK
      REPLACE FchAst    WITH XdFchast
      REPLACE FchDoc    WITH XdFchDoc
      REPLACE Divi      WITH XsCodref
      REPLACE NroAst    WITH XsNroAst
      REPLACE RucAux    WITH XsNroRuc
      REPLACE Importe   WITH vImport(1)
      REPLACE ImpIgv    WITH vImport(2)
      REPLACE Afecta    WITH vImport(3)
      REPLACE NAfecta   WITH vImport(4)
      REPLACE Gravada   WITH vImport(5)
      REPLACE NoGrava   WITH vImport(6)
      REPLACE CtaCate   WITH vImport(7)
      REPLACE Fonavi    WITH vImport(8)
      REPLACE Redondeo  WITH vImport(9)
      REPLACE CodAux    WITH XsCodAux
      REPLACE Proveedor WITH XsNomAux
      REPLACE CodDoc    WITH XsCodDoc
      REPLACE NroDoc    WITH SUBST(XsNroDoc,4)
      REPLACE SerDoc    WITH LEFT(XsNroDoc,3)
      REPLACE NroRef    WITH XsNroRef       &&para las notas de credito y debito
      REPLACE ImporUS   WITH XfDolar
      REPLACE TpoCmb    WITH XfTpoCmb
      REPLACE FlgEst    WITH XsFlgEst
      REPLACE CodMon    WITH XiCodMon
      REPLACE Afecto    WITH XsAfecto
      IF ABS(vImport(3) * .18 - vImport(2)) > 1
         REPL Flag      WITH '*'
      ENDI
RETURN
