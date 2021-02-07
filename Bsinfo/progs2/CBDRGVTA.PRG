********************************************************************************
* Programa      : CBDRGVTA.PRG                                                 *
* Objeto        : LIBRO VENTAS                                                 *
* Autor         : VETT                                                         *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 11/11/94                                                     *
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
CREATE TABLE &Arch. (Divi C(5) , CodAux C(8), Cliente C(35), FchAst D ,;
                 NroAst C(6) , CodDoc c(4), NroDoc C(10), Concepto C(40) ,;
                 Soles N(14,2), Dolares N(14,2), Afecto N(14,2), SerDoc C(3),;
                 Inafecto N(14,2), ImpIgv N(14,2), TpoCmb N(8,4), ;
                 Ruc C(8), FlgEst C(1) )
USE
USE &Arch IN 0 ALIAS TEMP EXCLU
SELE TEMP
INDEX ON CodDoc+DTOC(FchAst)+NroDoc TAG TEMP01
SET ORDER TO TEMP01

SELE CNFG
SEEK 'VTA'
XsVtaOp = CNFG.CodOpe
XsVta70 = CNFG.CtaBase
XsVta40 = CNFG.CtaImpu
XsVta12 = CNFG.CtaTota

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO VENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = XsVtaOp
XiNroMes = _Mes
XsCodDiv = SPACE(5)
XsNomDiv = []
xsNombre = []
XfTpoCmb = 0
XsRuc    = []
XsFlgEst = []
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
            XsCodOpe = CodOpe
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
         i = IIF( i< 1 , i + 1, 3 )
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
XsCodbus = XsCodDiv
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
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
DO XPROCESa
DO XIMPRIME
RELEASE XsVta*
CLOSE ALL
DELETE FILE &Arch..DBF
DELETE FILE &Arch..CDX
RETURN


PROCEDURE xProcesa
******************
   DIMENSION vImport(7),vTotal(7)
   WAIT WIND PADC([... Espere un Momento Procesando Informaci¢n ...],72) NOWAIT
   SELECT VMOV
   STORE 0 TO vTotal
   XLlave = XsNroMes+XsCodOpe
   Seek xLLave
   DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF()
      STORE [] TO XsCodAux,XsNomAux,XsCodDoc,XsNroDoc,XsRefImp,XsNroRuc
      STORE 0  TO vImport,XfImport,XfImpInf,XfDolar,XfTpoCmb,CHK
      XlAfecto = .F.
      STORE [] TO XsRuc,XsFlgEst
      sKey = NroMes+CodOpe+NroAst
      SELECT RMOV
      SEEK sKey
      XsCtaAnt = SPACE(LEN(RMOV->CodCta))
      DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF()
         CHK  = CHK  + IIF(TpoMov="D",Import,-Import)
         XsCodDiv = RMOV.CodRef
         IF !EMPTY(RMOV.ClfAux) AND !EMPTY(RMOV.CodAux) AND INLIST(CODCTA,&XsVta12)
            XsCodAux   = RMOV->CodAux
            =SEEK(RMOV.ClfAux+RMOV.CodAux,"AUXI")
            XsNomAux   = IIF(RMOV->CodAux="99",RMOV->GloDoc,AUXI->NomAux)
            XsRuc      = IIF(RMOV->CodAux="99","   ",AUXI->RucAux)
            XsNroDoc   = RMOV->NroDoc
            XsCodDoc   = RMOV->CodDoc
            XdFchAst   = RMOV->FchDoc
            XfTpoCmb   = RMOV->TpoCmb
         ENDIF
         IF !EMPTY(RMOV.CodDoc) AND !EMPTY(RMOV.NroDoc) AND INLIST(CODCTA,&XsVta12)
            XsNroDoc   = RMOV->NroDoc
            XsCodDoc   = RMOV->CodDoc
         ENDI
         DO CASE
            CASE INLIST(CODCTA,&XsVta12) && And Afecto<>"N"
                 XfImport = IIF(TpoMov=[D],Import,-Import)
                 vImport(1) = vImport(1) + XfImport
                 XfDolar  = XfDolar  + IIF(TpoMov="D",ImpUsa,-ImpUsa)
            CASE INLIST(CODCTA,&XsVta70) And Afecto<>"N"
                 XfImport = IIF(TpoMov=[H],Import,-Import)
                 vImport(2) = vImport(2) + XfImport
            CASE INLIST(CODCTA,&XsVta40)
                 XfImport = IIF(TpoMov=[H],Import,-Import)
                 vImport(3) = vImport(3) + XfImport
            CASE INLIST(CODCTA,&XsVta70) And Afecto="N"
            
                 XfImport = IIF(TpoMov=[H],Import,-Import)
                 vImport(4) = vImport(4) + XfImport
                 
            OTHER
            	 IF Afecto<>"N"
    	             XfImport = Import
	             ELSE
	                 XfImport = IIF(TpoMov=[H],Import,-Import)
	             ENDIF
                 vImport(4) = vImport(4) + XfImport
         ENDCASE
         SELECT RMOV
         XsCtaAnt = CODCTA
         SKIP
      ENDDO
      SELECT VMOV
      LsGloDoc = LEFT(VMOV->NotAst,54)
      XsFlgEst  = FlgEst
      XsNroAst = NroAst
      SELE TEMP
      APPEND BLANK
      REPLACE  Divi       WITH XsCodDiv
      REPLACE  CodAux     WITH XsCodAux
      REPLACE  Cliente    with XsNomAux
      REPLACE  CodDoc     With XsCodDoc
      REPLACE  NroDoc     With SUBs(XsNroDoc,4)
      REPLACE  SerDoc     With LEFT(XsNroDoc,3)
      REPLACE  NroAst     with XsNroAst
      REPLACE  FchAst     with XdFchAst
      REPLACE  Concepto   WIth LsGloDoc
      REPLACE  Dolares    WIth XfDolar
      REPLACE  Soles      WIth vImport(1)
      REPLACE  Afecto     WIth vImport(2)
      REPLACE  ImpIgv     WIth vImport(3)
      REPLACE  Inafecto   WIth vImport(4)
      REPLACE  FlgEst     With XsFlgEst
      REPLACE  Ruc        With XsRuc
      Replace  TpoCmb     With XfTpoCmb
      IF ABS(vImport(2) * .18 - vImport(3)) > 1
         REPL Flgest   WITH '*'
      ENDI
      SELE VMOV
      SKIP
   ENDDO
RETURN

*******************
PROCEDURE xImprime
*******************
SELE TEMP
SET ORDER TO 1
XsCodBus = TRIM(XsCodBus)
LsLLave = XsCodBus

LsTstImp = []  &&[TEMP.Divi = XsCodBus]
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
sNomRep = IIF(XnFormat=1,'CBDRGVTA',[CBDRGVTB])
DO ADMPRINT WITH "REPORTS"
RETURN
