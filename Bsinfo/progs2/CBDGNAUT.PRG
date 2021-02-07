CLEAR
SELE 1
USE CBDMCTAS ORDER CTAS01   ALIAS CTAS
IF !USED(1)
    CLOSE DATA
    RETURN
ENDIF
SELE 2
USE CBDMAUXI ORDER AUXI01   ALIAS AUXI
IF !USED(2)
    CLOSE DATA
    RETURN
ENDIF
SELE 3
USE CBDVMOVM ORDER VMOV01   ALIAS VMOV EXCL
IF !USED(3)
    CLOSE DATA
    RETURN
ENDIF
SELE 4
USE CBDRMOVM ORDER RMOV01   ALIAS RMOV EXCL
IF !USED(4)
    CLOSE DATA
    RETURN
ENDIF
SELE 7
USE CBDACMCT ORDER ACCT01   ALIAS ACCT EXCL
IF !USED(7)
    CLOSE DATA
    RETURN
ENDIF

XsNroMes = TRANSF(_MES,"@L ##")
SELECT RMOV
SEEK XsNroMes
DO WHILE NROMES = XsNroMes
   Llave = NROMES+CODOPE+NROAST
   SELECT VMOV
   SEEK LLAVE
   SELECT RMOV
   ? "Procesando : ",nromes+"-"+codope+"-"+nroast
   DO WHILE  Llave = NROMES+CODOPE+NROAST .AND. ! EOF()
      DO CHEQUEO
   ENDDO
   if inkey()= Escape
      exit
   ENDIF
ENDDO
CLOSE DATA
RETURN
*****************
PROCEDURE CHEQUEO
*****************
XsCodOpe = RMOV->CodOpe
XsNroAst = RMOV->NroAst
XsCodCta = RMOV->CodCta
XsClfAux = RMOV->ClfAux
XsCodAux = RMOV->CodAux
XsCodDoc = RMOV->CodDoc
XsCodRef = RMOV->CodRef
XcTpoMov = RMOV->TpoMov
XfImport = RMOV->Import
XfImpUsa = RMOV->ImpUsa
XiNroItm = RMOV->NroItm
XsGloDoc = RMOV->GloDoc
XdFchDoc = RMOV->FchDoc
XdFchVto = RMOV->FchVto
XsNroDoc = RMOV->NroDoc
XsNroRef = RMOV->NroRef
XiCodMon = VMOV->CodMon
XfTpoCmb = VMOV->TpoCmb
=SEEK(RMOV->CodCta,"CTAS")
IF CTAS->GenAut <> "S"
   SKIP
  *DO WHILE ! EOF() .AND. NROMES+CODOPE+NROAST = LLAVE .AND. EliItm = "ú"
   DO WHILE ! EOF() .AND. NROMES+CODOPE+NROAST = LLAVE .AND. EliItm = "*"  
      DO BORRLIN
      SELECT RMOV
      SKIP
   ENDDO
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
*XcEliItm = "ú"
XcEliItm = "*"
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
      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
ELSE
   IF ! SEEK(TsAn1Cta,"CTAS")
      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
SKIP
Crear = .T.
*IF EliItm = "ú" .AND. NROMES+CODOPE+NROAST = LLAVE
IF EliItm = "*" .AND. NROMES+CODOPE+NROAST = LLAVE
   Crear = .F.
ENDIF
** Grabando la primera cuenta autom tica **
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbGrab
SKIP
Crear = .T.
*IF EliItm = "ú" .AND. NROMES+CODOPE+NROAST = LLAVE
IF EliItm = "*" .AND. NROMES+CODOPE+NROAST = LLAVE
   Crear = .F.
ENDIF
** Grabando la segunda cuenta autom tica **
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MOVbGrab
RETURN
************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
** Anulamos Provision del Proveedor **
SELE RMOV
DELETE
UNLOCK
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-Import
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-ImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-Import
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-ImpUsa
ENDIF
SELECT RMOV
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab
SELE RMOV
IF Crear
   APPEND BLANK
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
ELSE
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
   REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-ImpORT
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-ImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-ImpORT
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-ImpUsa
   ENDIF
ENDIF
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH VMOV->FchAst
REPLACE RMOV->NroVou WITH VMOV->NroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH VMOV->FchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
IF CodMon = 1
   REPLACE RMOV->Import WITH XfImport
   IF TpoCmb = 0
      REPLACE RMOV->ImpUsa WITH 0
    ELSE
      REPLACE RMOV->ImpUsa WITH ROUND(XfImport/TpoCmb,2)
   ENDIF
ELSE
   REPLACE RMOV->Import WITH ROUND(XfImport*TpoCmb,2)
   REPLACE RMOV->ImpUsa WITH XfImport
ENDIF
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE VMOV->ChkCta WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
SELECT RMOV
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
ENDIF
SELE RMOV
RETURN
