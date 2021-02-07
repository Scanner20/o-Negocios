**************************************************************************
* AJUSTE POR DIFERENCIA DE CAMBIO / DOLARES (TRASLACION)                 *
**************************************************************************
NroDec    = 4
XsNroMes  = TRANSF(_MES,"@L ##")
Modificar = .T.
DO MOVgPant IN CBDMMOVM
DO MOVApert IN CBDMMOVM
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELECT 0
USE CBDTCNFG ORDER CNFG01 ALIAS CNFG
XsCodCfg = "03"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n dentro del sistema "
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
UltTecla = 0
XsCodOpe = CodOpe
XsNotAst = "AJUSTE X TRASLACION"
XdFchAst = GdFecha
XsNroVou = ""
XfTpoCmb = 0
XsDigita = GsUsuario
EscLin   = "MOVbLine"
XsNroRuc = ""

XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
SELECT TCMB
SEEK DTOC(GdFecha,1)
XfTC_Vta = OFIVTA
XfTC_Cmp = OFICMP
IF ! Modificar
   GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
SAVE SCREEN
GsMsgKey = "[F10] Inicia Proceso   [Esc] Cancela Proceso    [F7] Configuramos"
DO LIB_MTEC WITH 99
@ 11,20 CLEAR TO 15,60
@ 11,20       TO 15,60
@ 12,25 SAY "T/Cambio Compra   : " GET XfTC_Cmp  PICT "###,###.####"
@ 14,25 SAY "T/Cambio Venta    : " GET XfTC_Vta  PICT "###,###.####"
READ
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
IF ! FOUND()
   APPEND BLANK
ENDIF
IF REC_LOCK(5)
   REPLACE FCHCMB WITH GdFecha
   REPLACE OFIVTA WITH XfTC_Vta
   REPLACE OFICMP WITH XfTC_Cmp
ENDIF
IF LASTKEY() = F7
   SELECT CNFG
   EDIT
   CLOSE DATA
   RETURN
ENDIF
RESTORE SCREEN

SELECT OPER
SEEK XsCodOpe
IF ! FOUND()
   GsMsgErr = " Operaci¢n no registrada "
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
SET PROCEDURE TO CBDMMOVM
XsNroAst = "000002"
IF NROAST() < "000002"
   = NROAST(XsNroAst)
ENDIF
SET PROCEDURE TO
cCodCta = ""
SdoAct  = 0
SdoPas  = 0
nImpNac = 0
nImpUsa = 0
**** Variables a Grabar *****
XcEliItm = " "
XsCodCta = ""
XsClfAux = ""
XsCodAux = ""
XsCodRef = ""
XcTpoMov = "D"
XfImport = 0
XfImpUsa = XfImport
XfImpNac = 0
XiNroItm = 0
XsGloDoc = ""
XdFchDoc = GdFecha
*XdFchVto = {,,}
XdFchVto = {  ,  ,    }
XsCodDoc = ""
XsNroDoc = ""
XsNroRef = ""
XiCodMon = 2
XfTpoCmb = 0
Yo       = 10
Xo       = 0
LinIni   = Yo
LinAct   = LinIni + 1
LiNroREG = 0

**** Borrando movimientos anteriores ***
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SELECT VMOV
SEEK LLave
zOK       = FOUND()
Crear    = .F.
IF ! FOUND()
   APPEND BLANK
   IF ! Rec_Lock(5)
      CLOSE DATA
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   REPLACE VMOV->FLGEST WITH "R"
   replace vmov.fchdig  with date()
   replace vmov.hordig  with time() 
ELSE
   IF ! Rec_Lock(5)
      GsMsgErr = "Asiento usado por otro usuario"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE VMOV->FLGEST  WITH "R"
ENDIF
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0
REPLACE VMOV->NroItm  WITH 0
DO MOVGraba IN CBDMMOVM

IF ZOK
   @ 15,1 SAY PADC("** ANULANDO MOVIMIENTO ANTERIOR **",78)
   DO LIB_MSGS WITH 10
   SELECT RMOV
   SEEK Llave
   ok     = .t.
   DO WHILE ! EOF() .AND.  ok .AND. Llave = (NroMes + CodOpe + NroAst )
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
ENDIF
DO MOVPINTA IN CBDMMOVM
Crear    = .T.
SELECT CTAS
SEEK cCodCta
DO WHILE CodCta = TRIM(cCodCta) .AND. ! EOF()
   LiNroReg = LiNroReg + 1
   LiRegAct = RECNO()
   @ 23,2 SAY (LiNroReg / RECCOUNT())*100  PICT "## %" COLOR SCHEME 7
   IF AftDcb = "S" .AND. AftMov = "S"
      DO Actualiza
   ENDIF
   SELECT CTAS
   GOTO LiRegAct
   SKIP
ENDDO
* Grabando la contra cuenta ***********
XfImpUsa = 0
XsCodCta = CodCta
XfTpoCmb = 0
XsClfAux = []
XsCodAux = []
XsCodRef = []
XsNroDoc = []
XsNroRef = []
IF XiNroItm > 0
   IF SdoPas <> 0
      XfImport = ABS(SdoPas)
      XfImpUsa = XfImport
      XfImpNac = 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = CTAS->CLFAUX
         XsCodAux = XsCdAux1
      ELSE
         XsClfAux = ""
         XsCodAux = ""
      ENDIF
      IF SdoPas > 0
         XcTpoMov = "H"
      ELSE
         XcTpoMov = "D"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
   IF SdoAct <> 0
      XfImport = ABS(SdoAct)
      XfImpUsa = XfImport
      XfImpNac = 0
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = CTAS->CLFAUX
         XsCodAux = XsCdAux2
      ELSE
         XsClfAux = ""
         XsCodAux = ""
      ENDIF
      IF SdoAct > 0
         XcTpoMov = "H"
      ELSE
         XcTpoMov = "D"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
ENDIF
CLOSE DATA
RETURN

**********************************************************************
* Genera el Item por Diferencia de Cambio
**********************************************************************
PROCEDURE Actualiza
*******************
IF CTAS->CodMon = 2
   RETURN
ENDIF
XfImpUsa = 0
XsCodCta = CodCta
XfTpoCmb = 0
XsClfAux = []
XsCodAux = []
XsCodRef = []
XsNroDoc = []
XsNroRef = []
IF CTAS->TpoCmb = 1
   fTpoCmb = XfTC_Cmp
ELSE
   fTpoCmb = XfTC_Vta
ENDIF
IF CTAS->CodMon = 1   .AND. INLIST(XsCodCta,"10")
   DO CBDAcumd WITH XsCodCta , 0 , _Mes
   SdoNac  =  XvCalc(6 )
   SdoExt  =  XvCalc(12)
   IF CTAS->TpoCmb = 3
      IF SdoNac > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SdoAjte = ROUND(SdoNac/fTpoCmb - SdoExt,2)
   IF SdoAjte <> 0
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpUsa = XfImport
         XfImpNac = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpUsa = XfImport
         XfImpNac = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
ELSE
   DO ActCtCte
ENDIF
RETURN
**********************************************************************
* GRABA AUTOMATICAS
**********************************************************************
PROCEDURE GRABA
**** Grabando la linea activa ****
XcEliItm = " "
DO MOVbgrab in CBDMMOVM
DO PINTALIN
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
*XcEliItm = "ú"
XcEliItm = "*"
TsClfAux = "04 "
TsCodAux = CTAS->TpoGto
*TsAn1Cta = CTAS->An1Cta
TsAn1Cta = RMOV->CodAux
TsCC1Cta = CTAS->CC1Cta
  ** Verificamos su existencia **
IF ! SEEK(TsAn1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
XiNroItm = XiNroItm + 1
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbgrab in CBDMMOVM
DO PINTALIN
XiNroItm = XiNroItm + 1
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = ""
XsCodAux = ""
DO MOVbgrab in CBDMMOVM
DO PINTALIN
RETURN
**********************************************************************
* Genera el Item por Diferencia de Cambio cuando existe Cta.Cte.
**********************************************************************
PROCEDURE ActCtCte
******************
**** Buscamos si existe la cuenta en PROV ***
SELECT PROV
GOTO TOP
DO WHILE ! EOF()
   IF XsCodCta$CodCta
      EXIT
   ENDIF
   SKIP
ENDDO

SELECT RMOV
SET ORDER TO RMOV06
SEEK XsCodCta
CiCodMon = CTAS->CodMon
CiTpoCmb = CTAS->TpoCmb
DO WHILE CodCta = XsCodCta .AND. !EOF()
   XsClfAux = ClfAux
   XsCodAux = CodAux
   XsNroDoc = NroDoc
   XsNroRef = NroRef
   IF CiCodMon = 1
      LiCodMon = 1
   ELSE
      LiCodMon = CodMon
   ENDIF
   Llave  = XsCodCta+XsCodAux+XsNroDoc
   LfSdoNac = 0
   LfSdoExt = 0
   DO WHILE LLave = ( CodCta+CodAux+Nrodoc ) .AND. ! EOF()
      IF VAL(NroMes) <= _Mes
         IF CodOpe == PROV->CodOpe
            IF CiCodMon # 2
               LiCodMon = CodMon
            ENDIF
         ENDIF
         IF TpoMov = "H"
            LfSdoNac = LfSdoNac - Import
            LfSdoExt = LfSdoExt - ImpUsa
         ELSE
            LfSdoNac = LfSdoNac + Import
            LfSdoExt = LfSdoExt + ImpUsa
         ENDIF
      ENDIF
      SKIP
   ENDDO
   IF CiTpoCmb = 3
      IF LfSdoNac > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SALDO   = LfSdoNac/fTpoCmb
   SdoAjte = ROUND(Saldo - LfSdoExt , 2)
   IF ABS(SdoAjte) > 0  .AND. LiCodMon = 1 and LfSdoExt<>0
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpUsa = XfImport
         XfImpNac = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpUsa = XfImport
         XfImpNac = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      RegAct1  = Recno()
      SET ORDER TO RMOV01
      DO GRABA
      SELECT RMOV
      SET ORDER TO RMOV06
      GOTO RegAct1
   ENDIF
   SELECT RMOV
ENDDO
RETURN
******************
PROCEDURE PINTALIN
******************
IF LinAct > 19
   LinAct = 19
   SCROLL LinIni+1,Xo+1,LinAct,78,1
ENDIF
Contenido = ""
DO MOVBLine WITH Contenido IN CBDMMOVM
@ LinAct,2 SAY Contenido
LinAct = LinAct + 1
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
RETURN
