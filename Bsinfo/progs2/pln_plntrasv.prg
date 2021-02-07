Dimension AsAFP(20,2)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "APORTACIONES A.F.P."
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
*********apertura de archivos************


IF XSCODPLN="1"
SELE 7
USE PLNBLP11 ORDER BPGO03 ALIAS BPGO
ENDIF
IF XSCODPLN="2"
SELE 7
USE PLNBLP22 ORDER BPGO03 ALIAS BPGO
ENDIF
IF !USED(7)
   CLOSE DATA
   RETURN
ENDIF

SELE 6
USE TEMPO1 ORDER TEMP01 ALIAS TEMP EXCL
IF !USED(6)
   CLOSE DATA
   RETURN
ENDIF
ZAP

SELE 5
USE PLNDCCTO              ALIAS CCTO EXCL
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF
ZAP
INDEX ON NROPER+CTACTS+CODMOV TAG CCTO02
INDEX ON NROPER+CODMOV+CTACTS TAG CCTO01
SELE 4
USE PLNMTABL ORDER TABL01 ALIAS TABL
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
*******
*************

IF XsCodPln = "1"
   SELECT 3
   USE PLNTMOV1 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "2"
   SELECT 3
   USE PLNTMOV2 ORDER TMOV01 ALIAS TMOV
ENDIF
IF XsCodPln = "4"
   SELECT 3
   USE PLNTMOV3 ORDER TMOV01 ALIAS TMOV
ENDIF
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF


*******
SELE 2
USE PLNDMOVT ORDER DMOV01 ALIAS DMOV
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
*******
SELE 1
USE PLNMPERS ORDER Pers13 ALIAS PERS
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF


GOTO TOP
DO WHILE ! EOF()
   XsCodAfp=CodAfp
   XsCtaCts=CtaCts
   * IF VALCAL(AsAFP[i,1]) > 0 .AND. VALCAL("RD03") > 0

   IF VALCAL("@SIT")#6
      SKIP
      LOOP
   ENDIF
   IF VALCAL("VD01") > 0
      DO GRABA
   ENDIF
   SELECT PERS
   SKIP
ENDDO

DO GRABA1


SELECT TEMP
INDEX ON TIPMOV+CODMOV TAG TEMP02
SET ORDER TO TEMP02
GOTO  TOP
DO LIB_MTEC WITH 13
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
xWhile = []
xFor   = []
sNOMREP = "PLN_PLNRTRAS"
DO F0PRINT WITH "REPORTS"




*****  GENERANDO ASIENTO CONTABLE ****************

Resp=' '
@24,00 SAY REPLI(' ',80) COLO SCHE 7
@24,20 SAY 'Generar Asiento Contable (S/N):' COLO SCHE 7
@24,55 GET Resp PICT '!' VALID Resp$'SN'
READ
IF Resp='N'
   CLOSE DATA
   RETU
endif

*scodcia="001"
DO CASE
    CASE GSCODCIA="006"
         XSCODOPE="203"
    CASE GSCODCIA="003" AND XSCODPLN="1"
         XSCODOPE="203"
    CASE GSCODCIA="003" AND XSCODPLN="2"
         XSCODOPE="203"
    CASE GSCODCIA="004"
         XSCODOPE="203"
    CASE GSCODCIA="007"
         XSCODOPE="203"
    CASE GSCODCIA="009"
         XSCODOPE="203"
ENDCASE
IF GlPlnDmo
	XsCodOpe = [203]
ENDIF

NroDec   = 4
Crear    = .T.
OK = .T.
ScrMov   = ""


CLOSE DATA
STORE [] TO xsmes,RutaR
@11,11,16,72 BOX '∞∞∞∞∞∞∞∞∞∞∞'
@10,10 CLEA TO 15,70
@10,10 TO 15,70
@12,13 SAY 'Mes a realizar el Asiento :'
*@13,13 SAY 'A§o                      :'
XSmes=SPACE(2)
*RutaR =SPACE(50)
@ 12,40 GET xsmes PICT '@!'
READ
IF LAST()=27
   CLOSE DATA
   RETU
ENDIF

XSNROMES=Xsmes
_Mes = VAL(xSnROMES)
   IF _Mes < 12
      GdFecha   = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
   ELSE
      GdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
   ENDIF
lDesBal = .T.
lTpoCorr = 1
Modificar = .T.
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XiCodMon,XfTpoCmb,XsNroVou
STORE "" TO nImpNac,nImpUsa,Ngl,XsCodMod
STORE [] TO V1,V2,V3,V4
STORE 0 TO L1,L2,L3,L4
sFmt = "999,999,999.99"
MaxEle1 = 0

STORE 0 TO vImp
iDigitos=0
XdFchAst = GdFecha
XfTpoCmb = 1.00
XiCodMon = 1

RESTORE FROM CBDCONFG ADDITIVE
DO MOVApert
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
*** Buscando que operaciones puede tomar el usuario ***
sele tcmb
seek dtos(gDfECHA)
if !found() and recno(0)>0
   go recno(0)
endif
IF TCMB.OfiVta>0

   XfTpoCmb = TCMB.OfiVta
ENDIF
UltTecla = 0
**********************
** Rutina Principal **
**********************
IF !MOVNoDoc()
   CLOSE DATA
   RETURN
ENDIF
DO MovGrabM
SELE VMOV
UNLOCK ALL
CLOSE DATA
CLOSE PROCEDURE
RETURN
************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
******************
** Abrimos areas a usar **

LsPathCia = "cia"+[001]
LsPathDbf  = PathDef+"\"+LsPathCia+[\]

LsDefaDbf  = PathDef+"\"+LsPathCia+"\C"+LTRIM(STR(_ANO))+[\]


GsRutCia = LsPathDbf
GsRutAno = LsDefaDbf


SELE 0
USE &GsRutAno.CBDTCIER
IF !used()
    close data
    return
ENDIF
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
   GOTO RegAct
   Modificar = ! Cierre
ENDIF
SELE 1
USE &GsRutCia.cbdmctas ORDER ctas01   ALIAS CTAS
IF !used(1)
    close data
    return
ENDIF
SELE 2
USE &GsRutCia.cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(2)
    close data
    return
ENDIF
SELE 3
USE &GsRutAno.cbdvmovm ORDER vmov01   ALIAS VMOV
IF !used(3)
    close data
    return
ENDIF
SELE 4
USE &GsRutAno.cbdrmovm ORDER rmov01   ALIAS RMOV
IF !used(4)
    close data
    return
ENDIF
SELE 5
USE &GsRutAno.cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE &GsRutAno.cbdtoper ORDER oper01   ALIAS OPER
IF !used(6)
    close data
    return
ENDIF
SELE 7
USE &GsRutAno.cbdacmct ORDER acct01   ALIAS ACCT
IF !used(7)
    close data
    return
ENDIF
SELE 8
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF !used(8)
    close data
    return
ENDIF

SELE 9
USE tempo1   ORDER temp02   ALIAS Temp
IF !used(9)
    close data
    return
ENDIF
RETURN
************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
XsNroAst = NROAST()
SELE OPER
SEEK XsCodOpe
IF !FOUND()
    GsMsgErr = [Operaci¢n invalida]
    DO LIB_MERR WITH 99
    RETURN .f.
ENDIF
Crear = .t.
SELECT VMOV
RETURN .T.
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
XsNroVou = SPACE(LEN(VMOV->NROVOU))
XiCodMon = VMDL->CodMon
XsNotAst = VMDL->NotAst
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
FUNCTION NROAST
****************
PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE
*
IF OPER->Origen
   iNroDoc=VAL(XsNroMes+RIGHT(TRANSF(iNRODOC,"@L ######"),4))
ENDIF
*
IF PARAMETER() = 1
   IF VAL(XsNroAst) > iNroDoc
     iNroDoc = VAL(XsNroAst) + 1
   ELSE
     iNroDoc = iNroDoc + 1
   ENDIF
   DO CASE
      CASE XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
RETURN  RIGHT("000000" + LTRIM(STR(iNroDoc)), 6)

************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE MOVMover
XdFchAst = VMOV->FchAst
XsNroVou = VMOV->NroVou
XiCodMon = VMOV->CodMon
XfTpoCmb = VMOV->TpoCmb
XsNotAst = VMOV->NOTAST
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   UltTecla = Escape
   RETURN              && No pudo bloquear registro
ENDIF
DO LIB_MSGS WITH 10
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELECT RMOV
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ENDIF
      DELETE
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
SELECT VMOV
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
   DELETE
ENDIF
UNLOCK ALL
RETURN
************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera
******************************************************************************

PROCEDURE MOVGraba
IF UltTecla = Escape
   RETURN
ENDIF
UltTecla = 0
IF Crear                  && Creando
   SELE OPER
   IF ! Rec_Lock(5)
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
   SELECT VMOV
   SEEK (XsNroMes + XsCodOpe + XsNroAst)
   IF FOUND()
      XsNroAst = NROAST()
      SEEK (XsNroMes + XsCodOpe + XsNroAst)
      IF FOUND()
         DO LIB_MERR WITH 11
         UltTecla = Escape
         RETURN
      ENDIF
   ENDIF
   APPEND BLANK
   IF ! Rec_Lock(5)
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   IF Crear
     REPLACE VMOV->FLGEST  WITH "R"   && Asiento Tipo ??
   ELSE
     REPLACE VMOV->FLGEST  WITH "R"
   ENDIF
   replace vmov.fchdig with date()
   replace vmov.hordig with time()
   SELECT OPER
   =NROAST(XsNroAst)
   SELECT VMOV
   WAIT WINDOW [Generando asiento:]+XsNroAst+[ Operaci¢n:]+XsCodOpe+[ ]+OPER.NomOpe NOWAIT
ELSE
   *** ACTULIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
   IF VMOV->FchAst <> XdFchAst .OR. VMOV->NroVou <> XsNroVou
      SELECT RMOV
      Llave = (XsNroMes + XsCodOpe + XsNroAst )
      SEEK Llave
      DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
         IF Rlock()
            REPLACE RMOV->FchAst  WITH XdFchAst
            REPLACE RMOV->NroVou  WITH XsNroVou
            UNLOCK
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT VMOV
ENDIF
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->Digita  WITH GsUsuario
RETURN
************************************************************************ FIN *
FUNCTION _CodDoc
*****************
PARAMETER sCODDOC
XsTabla = "02"
IF LASTKEY() = F8
   SELECT TABL
   IF ! CbdBusca("TABL")
      RETURN .F.
   ENDIF
   sCodDoc = LEFT(TABL->Codigo,LEN(sCodDoc))
ENDIF
RETURN SEEK(XsTabla+sCodDoc,"TABL")
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
DO LIB_MSGS WITH 10
ULTTECLA = F10
DO BORRLIN
XiNroItm = NroItm
REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
SKIP
*** anulando cuentas autom†ticas siguientes ***
DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "˙"
   DO BORRLIN
   REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
   SKIP
ENDDO
DO RenumItms WITH XiNroItm
DO MovPImp
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
IF ! REC_LOCK(5)
   UltTecla = Escape
ENDIF
SELE RMOV
DELETE
UNLOCK
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
ELSE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
ENDIF
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
DO CalImp
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
ENDIF
SELECT RMOV
RETURN
************************************************************************ FIN *
* Renumerar los items
******************************************************************************
PROCEDURE RenumItms
PARAMETERS T_Itms
DO WHILE &RegVal .AND. ! EOF()
   IF RLOCK()
      REPLACE NroItm   WITH T_Itms
   ENDIF
   UNLOCK
   SKIP
   T_Itms = T_Itms + 1
ENDDO
RETURN
************************************************************************ FIN *
* Objeto : Verificar si debe generar cuentas autom†ticas
******************************************************************************
PROCEDURE MovbVeri
**** Grabando la linea activa ****
XcEliItm = " "
DO MOVbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   IF ! Crear
      *** anulando cuentas autom†ticas anteriores ***
      SKIP
      XinroItm = NroItm
      DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "˙"
         Listar   = .T.
         Refresco = .T.
         DO BORRLIN
         REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
         SELECT RMOV
         SKIP
      ENDDO
      IF Listar
          DO RenumItms WITH XiNroItm
          GOTO NumRg(1)
      ELSE
         GOTO RegAct
      ENDIF
   ENDIF
   RETURN
ENDIF
**** Actualizando Cuentas Autom†ticas ****
XcEliItm = "˙"
TsClfAux = []
TsCodAux = []
TsAn1Cta = CTAS->An1Cta
TsCC1Cta = CTAS->CC1Cta
IF EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
   TsClfAux = "04 "
   TsCodAux = CTAS->TpoGto
   TsAn1Cta = RMOV->CodAux
   TsCC1Cta = CTAS->CC1Cta
   TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
   ** Verificamos su existencia **
   IF ! SEEK("05 "+TsAn1Cta,"AUXI")
      GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
ELSE
   IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
      IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
         TsClfAux = XSCLFAUX
         TsCodAux = XSCODAUX
      ENDIF
   ENDIF

   IF ! SEEK(TsAn1Cta,"CTAS")
      GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")

   GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
*****
**DO CompBrows WITH .F.
SKIP
Crear = .T.
IF EliItm = "˙" .AND. &RegVal
   Crear = .F.
ENDIF
** Grabando la primera cuenta autom†tica **
IF Crear
   XiNroItm = XiNroItm + 1
ELSE
   XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
   DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbGrab
**DO CompBrows WITH Crear
SKIP
Crear = .T.
IF EliItm = "˙" .AND. &RegVal
   Crear = .F.
ENDIF
** Grabando la segunda cuenta autom†tica **
IF Crear
   XiNroItm = XiNroItm + 1
ELSE
   XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
   DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MOVbGrab
****
RETURN
**********************************************************************
* Inserta Items
**********************************************************************
PROCEDURE MovInser
******************
RegAct = RECNO()
DO RenumItms WITH XiNroItm + 1
GOTO RegAct
DO MovbVeri
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab
DO LIB_MSGS WITH 4
SELE RMOV
IF Crear
   APPEND BLANK
ENDIF
IF ! Rec_Lock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF
IF Crear
   REPLACE RMOV->NroMes WITH XsNroMes
   REPLACE RMOV->CodOpe WITH XsCodOpe
   REPLACE RMOV->NroAst WITH XsNroAst
   REPLACE RMOV->NroItm WITH XiNroItm
   REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
   replace rmov.fchdig  with date()
   replace rmov.hordig  with time()
ELSE
   IF ! XsCodOpe = "9"
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
   ELSE
      DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
   ENDIF
   REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
   DO CalImp
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
   ENDIF
ENDIF
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->GLODOC WITH XSDESMOV
IF CodMon = 1
   REPLACE RMOV->Import WITH XfImport
   IF TpoCmb = 0
      REPLACE RMOV->ImpUsa WITH 0
    ELSE
      REPLACE RMOV->ImpUsa WITH round(XfImport/TpoCmb,2)
   ENDIF
ELSE
   REPLACE RMOV->Import WITH round(XfImport*TpoCmb,2)
   REPLACE RMOV->ImpUsa WITH XfImport
ENDIF
REPLACE RMOV->GloDoc WITH XsDESMOV
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE RMOV->IniAux WITH XsIniAux
REPLACE RMOV->NroRuc WITH XsNroRuc
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ENDIF
SELECT RMOV
DO CalImp
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+nImpUsa
ENDIF
DO MovPImp

SELE RMOV
UNLOCK
DO LIB_MTEC WITH 14
RETURN
*****************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
RETURN
**********************************************************************
* Complemento del db_Brows para cuentas autom†ticas
**********************************************************************
PROCEDURE CompBrows
*******************
PARAMETER INSERTA
return
@ LinIni,Xo+1 FILL TO LinIni+Actual-1,X1-1 COLOR SCHEME 1
IF INSERTA
   SCROLL LinIni+Actual-1,Xo+1,Y1,X1-1,-1
ENDIF
Contenido = []
IF HayEscLin
   DO &EscLin WITH Contenido
ELSE
   Contenido  = &LinReg
ENDIF
Linea(Actual)  = Contenido
NumRg(Actual)  = RECNO()
LinAct = LinIni+Actual-1
@ LinAct,Xo+2 SAY Linea(Actual) COLOR SCHEME 7
IF Actual >= MaxLin
   Actual = MaxLin
   Ultimo = MaxLin
   j =1
   DO WHILE j <MaxLin
      Linea(j)  = Linea(j+1)
      NumRg(j)  = NumRg(j+1)
      j =j +1
   ENDDO
   SCROLL Yo+1,Xo+1,Y1,X1-1,+1
   dB_Top = .F.
ELSE
   Actual   =  Actual + 1
   Ultimo   =  Ultimo + 1
ENDIF
LinAct = LinIni+Actual-1
RETURN
**********************************************************************
* Pinta Importe Totales
**********************************************************************
PROCEDURE MovPImp
******************
IF VMOV->CodMon = 1
   @  20,40    SAY "S/."                                   COLOR SCHEME 7
   @  20,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "US$"                                   COLOR SCHEME 7
   @  23,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
ELSE
   @  20,40    SAY "US$"                                   COLOR SCHEME 7
   @  20,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "S/."                                   COLOR SCHEME 7
   @  23,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
ENDIF
RETURN
**********************************************************************
* CHEQUEO DE FIN DE BROWSE ===========================================
**********************************************************************
PROCEDURE MovFin
****************
lDesBal = ( ABS(VMOV->HbeUsa-VMOV->DbeUsa) >.05 ) .or. ;
          ( ABS(VMOV->HbeNac-VMOV->DbeNac) >.01 )
IF lDesBal
   IF ALRT("Asiento Desbalanceado")
      Fin       = No
      Sigue     = Si
   ENDIF
ENDIF

IF Sigue = No .AND. ! lDesBal
    DO IMPRVOUC
ENDIF

RETURN
**********************************************************************
* Pantalla de Ayuda    ===============================================
**************************************************************************
PROCEDURE MovF1
***************
SAVE SCREEN
GsMsgKey = "[Esc] Retorna"
DO LIB_MTEC WITH 99
@ 3,12 FILL TO 22,64 COLOR W/N
@ 2,13 TO 19,65 COLOR SCHEME 7
@  3,14 SAY  'Teclas de Selecci¢n :                              ' COLOR SCHEME 7
@  4,14 SAY  '   Cursor Arriba ....... Retroceder un Registro    ' COLOR SCHEME 7
@  5,14 SAY  '   Cursor Abajo  ....... Adelentar un Registro     ' COLOR SCHEME 7
@  6,14 SAY  '   Home          ....... Primer Registro           ' COLOR SCHEME 7
@  7,14 SAY  '   End           ....... Ultimo Registro           ' COLOR SCHEME 7
@  8,14 SAY  '   PgUp          ....... Retroceder en Bloque      ' COLOR SCHEME 7
@  9,14 SAY  '   PgDn          ....... Adelantar en Bloque       ' COLOR SCHEME 7
@ 10,14 SAY  'Teclas de Edici¢n :                                ' COLOR SCHEME 7
@ 11,14 SAY  '   Enter         ....... Modificar el Registro     ' COLOR SCHEME 7
@ 12,14 SAY  '   Del  (Ctrl G) ....... Anular el Registro        ' COLOR SCHEME 7
@ 13,14 SAY  '   Ins  (Ctrl V) ....... Insertar un  Registro     ' COLOR SCHEME 7
@ 14,14 SAY  '                                                   ' COLOR SCHEME 7
@ 15,14 SAY  '   F1            ....... Pantalla Actual de Ayuda  ' COLOR SCHEME 7
@ 16,14 SAY  '   F3            ....... Renumerar Items           ' COLOR SCHEME 7
@ 17,14 SAY  '   F5            ....... Impresi¢n del Asiento     ' COLOR SCHEME 7
@ 18,14 SAY  '   F10           ....... Terminar el Proceso       ' COLOR SCHEME 7
DO WHILE INKEY(0)<>Escape
ENDDO
RESTORE SCREEN
RETURN
**********************************************************************
* Regenerar Acumulados ===============================================
**********************************************************************
PROCEDURE MovF3
*******************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª" COLOR SCHEME 7
@ 11,23 SAY "≥    R E C A L C U L A N D O    ≥" COLOR SCHEME 7
@ 12,23 SAY "≥  Espere un momento por favor  ≥" COLOR SCHEME 7
@ 13,23 SAY "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº" COLOR SCHEME 7
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   DO CalImp
   IF TpoMov  ="D"
      T_DbeNac = T_DbeNac + nImpNac
      T_DbeUsa = T_DbeUsa + nImpUsa
   ELSE
      T_HbeNac = T_HbeNac + nImpNac
      T_HbeUsa = T_HbeUsa + nImpUsa
   ENDIF
   T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
   SELECT RMOV
   SKIP
ENDDO
*---------------------------------------------------*save
DO AJUSTE    &&  AJUSTA DESCUADRES POR DIFERENCIA CAMBIO ( VETT )
SELE VMOV
IF REC_LOCK(5)
   REPLACE VMOV->ChkCta  WITH T_Ctas
   REPLACE VMOV->DbeNac  WITH T_DbeNac
   REPLACE VMOV->DbeUsa  WITH T_DbeUsa
   REPLACE VMOV->HbeNac  WITH T_HbeNac
   REPLACE VMOV->HbeUsa  WITH T_HbeUsa
   REPLACE VMOV->NroItm  WITH T_Itms
ENDIF
SELE RMOV
**** Chequeo del Nro de Items **********************
IF Chqado > 0
   TnItms = 0
   DO WHILE TnItms < T_Itms
      TnItms =0
      SEEK VCLAVE
      DO WHILE EVALUATE(RegVal) .AND. ! EOF()
         IF NroItm <> ChkItm
            IF RLOCK()
               REPLACE NroItm   WITH ChkItm
            ENDIF
            UNLOCK
         ELSE
            TnItms = TnItms + 1
         ENDIF
         SKIP
      ENDDO
   ENDDO
ENDIF
RESTORE SCREEN
DO MovPImp
Fin  = .T.
RETURN
****************
PROCEDURE AJUSTE  && 26/01/95 VETT
****************
* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
IF lDesBal1 .AND. XiCodMon = 2
   IF T_HbeUsa > T_DbeUsa
       XsCodCta    = "66702"
       XcTpoMov    = "D"
   ELSE
       XsCodCta    = "66702"
       XcTpoMov    = "H"
   ENDIF
   LcTpoMov = XcTpoMov
   XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
   XiCodMon    = 2
   IF XfImport<>0
      Crear = .T.
      DO MovBveri
      IF LcTpoMov = "D"
         T_DbeUsa = T_DbeUsa + XfImport
      ELSE
         T_HbeUsa = T_HbeUsa + XfImport
      ENDIF
   ENDIF
ENDIF
IF lDesBal2 .AND. XiCodMon = 1
   IF T_HbeNac > T_DbeNac
       XsCodCta    = "66702"
       XcTpoMov    = "D"
   ELSE
       XsCodCta    = "66702"
       XcTpoMov    = "H"
   ENDIF
   LcTpoMov = XcTpoMov
   XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
   XiCodMon    = 1
   IF XfImport<>0
      Crear = .T.
      DO MovBveri
      IF LcTpoMov = "D"
         T_DbeNac = T_DbeNac + XfImport
      ELSE
         T_HbeNac = T_HbeNac + XfImport
      ENDIF
   ENDIF
ENDIF
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
XfTpoCmb    = 0
IF ! lDesBal1 .AND. lDesBal2 .AND. XiCodMon = 2
   IF T_HbeNac > T_DbeNac
       XsCodCta    = "66702"
       XcTpoMov    = "D"
   ELSE
       XsCodCta    = "66702"
       XcTpoMov    = "H"
   ENDIF
   LcTpoMov = XcTpoMov
   XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
   XiCodMon    = 1
   IF XfImport<>0
      Crear = .T.
      DO MovBveri
      IF LcTpoMov = "D"
         T_DbeNac = T_DbeNac + XfImport
      ELSE
         T_HbeNac = T_HbeNac + XfImport
      ENDIF
   ENDIF
ENDIF
IF ! lDesBal2 .AND. lDesBal1 .AND. XiCodMon = 1
   IF T_HbeUsa > T_DbeUsa
       XsCodCta    = "66702"
       XcTpoMov    = "D"
   ELSE
       XsCodCta    = "66702"
       XcTpoMov    = "H"
   ENDIF
   LcTpoMov = XcTpoMov
   XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
   XiCodMon    = 2
   IF XfImport<>0
      Crear = .T.
      DO MovBveri
      IF LcTpoMov = "D"
         T_DbeUsa = T_DbeUsa + XfImport
      ELSE
         T_HbeUsa = T_HbeUsa + XfImport
      ENDIF
   ENDIF
ENDIF
Listar   = .T.
Refresco = .T.
RETURN
***************
PROCEDURE SALDO
***************
SELECT RMOV
RegAct1 = RECNO()
EOF1    = EOF()
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK XsCodCta+XsCodAux+XsNroDoc
Saldo  = 0
SdoUsa = 0
DO WHILE (Llave = CodCta+CodAux+NroDoc) .AND. ! EOF()
   IF RegAct1 <> RECNO()
      Saldo  = Saldo  + IIF(TpoMov = 'D' , 1 , -1)*Import
      SdouSA = SdouSA + IIF(TpoMov = 'D' , 1 , -1)*ImpUsa
   ENDIF
   SKIP
ENDDO
SET ORDER TO RMOV01
IF ! EOF1
   GOTO RegAct1
ELSE
   GOTO BOTTOM
   IF ! EOF()
      SKIP
   ENDIF
ENDIF

Saldo  = Saldo  + IIF(XcTpoMov = 'D' , 1 , -1)*XfImport
SdouSA = SdouSA + IIF(XcTpoMov = 'D' , 1 , -1)*XfImpUsa
@ 22,19 SAY "S/."                                   COLOR SCHEME 7
@ 22,23 SAY Saldo   PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7

@ 22,55 SAY "US$"                                   COLOR SCHEME 7
@ 22,59 SAY SdoUsa  PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
RETURN

*******************
PROCEDURE ChkDesBal
*******************
Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
DO MovPimpM
lDesBal = ( ABS(TFHbeUsa-TfDbeUsa) >.05 ) .or. ;
          ( ABS(TfHbeNac-TfDbeNac) >.01 )
IF lDesBal
   IF ALRT("Asiento Desbalanceado")
     *Fin       = No
      Sigue     = Si
      UltTecla = Home
   ENDIF
ENDIF
RETURN
*******************
PROCEDURE MOVGeRmov
*******************
IF UltTecla = Escape
   UltTecla = 0
   RETURN
ENDIF
PRIVATE nEle
MaxEle1 = 0
nEle    = 0
SELE RMDL
SEEK XsCodMod
DO WHILE !EOF() .AND. CodMod=XsCodMod
   nEle = nEle + 1
   vNroAst(nEle) = XsNroAst
   vCodRef(nEle) = RMDL->CodRef
   vCodCta(nEle) = RMDL->CodCta
   vClfAux(nEle) = RMDL->ClfAux
   vCodAux(nEle) = RMDL->CodAux
   vNroDoc(nEle) = RMDL->NroDoc
   vFchVto(nEle) = XdFchAst
   vFchDoc(nEle) = XdFchAst
   vGloDoc(nEle) = RMDL->GloDoc
   vTpoMov(nEle) = RMDL->TpoMov
   vCodMon(nEle) = VMDL->CodMon
   vImport(nEle) = _Import(RMDL->Import)
   sImport(nEle) = RMDL->Import
   vCodDoc(nEle) = RMDL->CodDoc
   vNroRef(nEle) = RMDL->NroRef
   vNroItm(nEle) = RMDL->NroItm
   vNroRuc(nEle) = SPACE(LEN(RMOV->NroRuc))
   vIniAux(nEle) = SPACE(LEN(RMOV->IniAux))
   SELE RMDL
   SKIP
ENDDO
MaxEle1 = nEle
RETURN
******************
PROCEDURE MOVGrabM
******************
PRIVATE ii
**IF UltTecla = Escape .OR. lDesbal
*   RETURN
*ENDIF
Do MovGraba
** Tan facil que era poner esto **
NClave   = [NroMes+CodOpe+NroAst]
VClave   = XsNroMes+XsCodOpe+XsNroAst
IF (LEN(TRIM(VClave)) <> 0)
   RegVal   = "&NClave = VClave"
ELSE
   * - Todos los registros son v†lidos.
   RegVal = ".T."
ENDIF
ii = 1
SELE TEMP
SCAN
     Wait WINDOW CODMOV+" "+DESMOV NOWAIT
     Crear = .T.
     XiNroItm = VMOV->NroItm + 1
     XcEliItm = " "
     XsNroVou = []
     XdFchDoc = XdFchAst
     XiCodMon = 1
     XcTpoMov = TEMP.TipMov
     XsDesMov = TEMP.DesMov
     IF XcTpoMov=[D]
        XsCodCta = TEMP.CodCta
     ELSE
        XsCodCta = TEMP.CtrCta
     ENDIF
     =SEEK(XsCodCta,[CTAS])
     XsCodRef = []
     XsCodAux = []
     XsClfAux = []
     IF CTAS.PidAux=[S]
        XsClfAux = CTAS.ClfAux
        XsCodAux = PADR(ALLTRIM(STR(VAL(TEMP.CtaCts),LEN(TEMP.CTACTS),0))+[00000000],LEN(RMOV.CodAux))
     ENDIF
     XfImport = TEMP.ValCal
     XsGloDoc = [ ]  && Concepto
     XsCodDoc = []
     XsNroDoc = []
     XsNroRef = []
     XdFchVto = {}
     XsNroRuc = []
     XsIniAux = []
     XsCodFin = []
     **** Grabando la linea activa ****
     XcEliItm = " "
     DO MOVbGrab
     RegAct = RECNO()
     *** Requiere crear cuentas automaticas ***
     =SEEK(XsCodCta,"CTAS")
     IF CTAS->GenAut <> "S"
        IF ! Crear
           *** anulando cuentas autom†ticas anteriores ***
           SKIP
           XinroItm = NroItm
           DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "˙"
              Listar   = .T.
              Refresco = .T.
              DO BORRLIN
              REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
              SELECT RMOV
              SKIP
           ENDDO
           IF Listar
               DO RenumItms WITH XiNroItm
               GOTO NumRg(1)
           ELSE
              GOTO RegAct
           ENDIF
        ENDIF
     ELSE
        XcEliItm = "˙"
        TsClfAux = []
        TsCodAux = []
        TsAn1Cta = CTAS->An1Cta
        TsCC1Cta = CTAS->CC1Cta
        IF EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
           TsClfAux = "04 "
           TsCodAux = CTAS->TpoGto
           TsAn1Cta = RMOV->CodAux
           TsCC1Cta = CTAS->CC1Cta
           TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
           ** Verificamos su existencia **
           IF ! SEEK("05 "+TsAn1Cta,"AUXI")
              GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
              DO LIB_MERR WITH 99
              RETURN
           ENDIF
        ELSE
           IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
              IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
                 TsClfAux = XSCLFAUX
                 TsCodAux = XSCODAUX
              ENDIF
           ENDIF
           IF ! SEEK(TsAn1Cta,"CTAS")
              GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
              DO LIB_MERR WITH 99
              RETURN
           ENDIF
        ENDIF
        IF ! SEEK(TsCC1Cta,"CTAS")
           GsMsgErr = "Cuenta Autom†tica no existe. Actualizaci¢n queda pendiente"
           DO LIB_MERR WITH 99
           RETURN
        ENDIF
        *****
        SKIP
        Crear = .T.
        IF EliItm = "˙" .AND. &RegVal
           Crear = .F.
        ENDIF
        ** Grabando la primera cuenta autom†tica **
        IF Crear
           XiNroItm = XiNroItm + 1
        ELSE
           XiNroItm = NroItm
        ENDIF
        IF Crear .AND. NroItm <= XiNroitm
           DO  RenumItms WITH XiNroItm + 1
        ENDIF
        XsCodCta = TsAn1Cta
        XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
        XsClfAux = TsClfAux
        XsCodAux = TsCodAux
        DO MOVbGrab
        DO CompBrows WITH Crear
        SKIP
        Crear = .T.
        IF EliItm = "˙" .AND. &RegVal
           Crear = .F.
        ENDIF
        ** Grabando la segunda cuenta autom†tica **
        IF Crear
           XiNroItm = XiNroItm + 1
        ELSE
           XiNroItm = NroItm
        ENDIF
        IF Crear .AND. NroItm <= XiNroitm
           DO  RenumItms WITH XiNroItm + 1
        ENDIF
        XsCodCta = TsCC1Cta
        XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
        XsClfAux = SPACE(LEN(RMOV->ClfAux))
        XsCodAux = SPACE(LEN(RMOV->CodAux))
        DO MOVbGrab
     ENDIF
     SELE TEMP
ENDSCAN
RETURN
****************
FUNCTION _Import
****************
Parameter sImport
Private i
IF Parameter() = 0 .OR. TRIM(sImport) = "?" .OR. TRIM(sImport)="NETO"
   RETURN 0
ENDIF
sImport = TRIM(sImport)
i = 1
LsEval=["]
DO WHILE i <= LEN(sImport)
   DO CASE
      CASE Substr(sImport,i,1) = "("
           LsEval = LsEval + "("
      CASE Substr(sImport,i,1) = "V"
           LsEval = LsEval +"&V"+ SUBSTR(sImport,i+1,1)+"."
           i = i + 1
      CASE Substr(sImport,i,1) $ "/-+*"
           LsEval = LsEval + SUBSTR(sImport,i,1)
      CASE Substr(sImport,i,1) $ "1234567890."
          *IF SubStr(sImport,i,1)="."
              LsEval = LsEval + "("+ SUBSTR(sImport,i,1)
              i = i + 1
              Paso = .F.
              DO WHILE SUBSTR(sImport,i,1)$"1234567890."
                 LsEval = LsEval + SUBSTR(sImport,i,1)
                 i = i + 1
                 Paso = .T.
              ENDDO
              IF Paso
                 i = i - 1
              ENDIF
              LsEval = LsEval + ")"
          *ELSE
          *   LsEval = LsEval + SUBSTR(sImport,i,1)
          *ENDIF
      CASE Substr(sImport,i,1) = ")"
           LsEval = LsEval + ")"
   ENDCASE
   i = i + 1
ENDDO
LsEval = LsEval + ["]
_TotImp = EVALUATE(&LsEval)
RETURN _TotImp
**************************************************

CLOSE DATA
RETURN

PROCEDURE Graba
***************

* BASE DE DATOS DETALLADA
*****************
SELE CCTO
APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VD01"
REPLACE ValCAL WITH VALCAL("VD01")

APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VS01"
REPLACE ValCAL WITH VALCAL("VS01")


IF VALCAL("VS04")>0
APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VS04"
REPLACE ValCAL WITH VALCAL("VS04")
ENDIF
**** SENATI ****


IF VALCAL("VS05")>0
APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VS05"
REPLACE ValCAL WITH VALCAL("VS05")
ENDIF

**** ACCEDENTES DE TRABAJO ******


IF XSCODPLN="2"
IF VALCAL("VS06")>0
APPEND BLANK
REPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VS06"
REPLACE ValCAL WITH VALCAL("VS06")
ENDIF
ENDIF



***** HABER ********

APPEND BLANK
*EPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VE02"
REPLACE ValCAL WITH VALCAL("VE02")


APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VF01"
REPLACE VALCAL WITH VALCAL("VF01")+VALCAL("VF03")+VALCAL("VF04")+VALCAL("VF05")


IF VALCAL("VK12")>0
APPEND BLANK
*EPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VK12"
REPLACE VALCAL WITH VALCAL("VK12")
ENDIF

APPEND BLANK
*EPLACE CtaCts WITH XsCtaCts
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VZ04"
REPLACE VALCAL WITH VALCAL("VZ04")



APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VO22"
REPLACE VALCAL WITH VALCAL("VO22")



APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VZ02"
REPLACE VALCAL WITH VALCAL("VZ02")

APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VZ03"
REPLACE VALCAL WITH VALCAL("VZ03")

*CTA. CTE


IF VALCAL("RM01")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VM01"
REPLACE VALCAL WITH VALCAL("VM01")
ENDIF


IF VALCAL("VM02")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VM02"
REPLACE VALCAL WITH VALCAL("VM02")
ENDIF


IF VALCAL("VE05")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VE05"
REPLACE VALCAL WITH VALCAL("VE05")
ENDIF

**** OTROS DESCUENTOS ****


if xscodpln="2"
IF VALCAL("VO21")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VO21"
REPLACE VALCAL WITH VALCAL("VO21")
ENDIF
endif


***** Cooperativa *********

IF VALCAL("VJ01")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VJ01"
REPLACE VALCAL WITH VALCAL("VJ01")
ENDIF




*f xscodpln="2"
IF VALCAL("VO11")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VO11"
REPLACE VALCAL WITH VALCAL("VO11")
ENDIF
*ndif

if xscodpln="2"
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VO03"
REPLACE VALCAL WITH VALCAL("VO01")+VALCAL("VO02")+VALCAL("VO03")+VALCAL("VO22")+VALCAL("VO80")
endif



IF XSCODPLN="1"
IF VALCAL("VO01")+VALCAL("VO02")+VALCAL("VO03")>0
APPEND BLANK
REPLACE CODPLN WITH XSCODPLN
REPLACE NROPER WITH XSNROPER
REPLACE CodPer WITH PERS->CodPer
REPLACE CodMOV WITH "VO03"
REPLACE VALCAL WITH VALCAL("VO01")+VALCAL("VO02")+VALCAL("VO03")
ENDIF
ENDIF
RETURN


PROCEDURE Graba1
***************

*** Agregamos totales por CENTRO DE COSTO Y CODIGO DE MOVIMIENTO
ArcTmp1 = PATHUSER+SYS(3)
SELE CCTO
SET ORDER TO CCTO02
set filter TO INLIST(CODMOV,[VD01],[VS])
GO TOP

TOTAL ON NROPER+CTACTS+CODMOV TO &ArcTmp1.
SELE 0
USE &ArcTmp1. ALIAS TMP1
GO TOP
SCAN
    REPLACE TipMov WITH [D]
    REPLA DesMov WITH IIF(SEEK(COdMOv,[TMOV]),TMOV.DESMOV,[])+"-"+IIF(XSCODPLN="1","MES "+XSNROMES,"SEMANA"+" "+XSNROSEM)
    REPLA CodCta WITH IIF(SEEK(COdMOv,[BPGO]),BPGO.COdCta,[])
    REPLA CtrCta WITH IIF(SEEK(COdMOv,[BPGO]),BPGO.CtrCta,[])
ENDSCAN
USE
SELE TEMP
APPEN FROM &ArcTmp1.
**********



*** Agregamos totales por CODIGO DE MOVIMIENTO
ArcTmp2 = PATHUSER+SYS(3)
SELE CCTO
SET ORDER TO CCTO01
set filter TO INLIST(CODMOV,[VK12],[VZ],[VE],[VJ],[VS],[VF],[VM],[VO])
GO TOP

TOTAL ON NROPER+CODMOV TO &ArcTmp2.
SELE 0
USE &ArcTmp2. ALIAS TMP2
GO TOP
SCAN
    if codmov="VZ03"
    REPLACE TipMov WITH [D]
    ELSE
    REPLACE TipMov WITH [H]
    endif
    REPLACE CTACTS WITH [ ]
   *REPLA DesMov WITH IIF(SEEK(COdMOv,[TMOV]),TMOV.DESMOV,[])
    REPLA DesMov WITH IIF(XSCODPLN="1","SUELDOS MES","SALARIOS SEMANA")+" "+IIF(XSCODPLN="1",XSNROMES,XSNROSEM)
    REPLA CodCta WITH IIF(SEEK(COdMOv,[BPGO]),BPGO.COdCta,[])
    REPLA CtrCta WITH IIF(SEEK(COdMOv,[BPGO]),BPGO.CtrCta,[])
ENDSCAN
USE
SELE TEMP
APPEN FROM &ArcTmp2.
RETURN


