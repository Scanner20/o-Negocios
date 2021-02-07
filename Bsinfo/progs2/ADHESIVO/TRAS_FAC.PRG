****************************************************************************
* Programa     : tras_fac.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Actualizar Informacion Contable
* Creacion     : 18/07/94
* Parametros   : Codigo del Documento [FACT] [BOLE]
* Actualizacion:
****************************************************************************
PARAMETER _CodDoc
PRIVATE XsTpoDoc,XsCodDoc

IF !_CodDoc $ [FACT|BOLE]
   RETURN
ENDIF
RESTORE FROM VTACONFG ADDITIVE
XsTpoDoc = [Cargo]
XsCodDoc = _CodDoc
** base de datos **
CLOSE DATA
*
SELE 0
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE vtaritem ORDER ITEM01 ALIAS DETA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
*
SELECT 0
USE ccbtbdoc ORDER BDOC01 ALIAS TDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELECT 0
USE almtfami ORDER FAMI01 ALIAS FAMI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
* Logica principal *
PRIVATE XdFchDocD,XdFchDocH
XdFchDocD = {01,01,1995}
XdFchDocH = {18,05,1995}
SELE GDOC
SEEK XsTpoDoc+XsCodDoc
SCAN WHILE TpoDoc+CodDoc=XsTpoDoc+XsCodDoc ;
     FOR FCHDOC >= XDFCHDOCD AND FCHDOC<=XDFCHDOCH
   DO XGRABA
ENDSCAN
CLOSE DATA
RETURN
******************************************************************************
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

** NOTA > Solo es crear y genera SIEMPRE correlativos **
**
SELE GDOC
IF ! RLOCK()
   RETURN
ENDIF
** ACTUALIZAMOS CONTABILIDAD **
DO xAct_Ctb
SELE GDOC

RETURN
************************************************************************ FIN()
* Objeto : Actualiza de Contabilidad
******************************************************************************
PROCEDURE xAct_Ctb

* Abrimos Base de Datos *
PRIVATE _MES,_ANO,DirCtb
_MES = MONTH(GDOC->FchDoc)
_ANO = YEAR(GDOC->FchDoc)
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
IF !Open_File()
   RETURN
ENDIF
* Grabamos Cabecera *
PRIVATE XsNroMes,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,XsCodOpe,XsNroAst
XsNroMes = TRANS(_MES,"@L ##")
XdFchAst = GDOC->FchDoc
XsNroVou = []
XiCodMon = GDOC->CodMon
XfTpoCmb = GDOC->TpoCmb
XsNotAst = [PROV. ]+GDOC->CodDoc+[. ]+GDOC->NomCli
XsCodOpe = [002]
=SEEK(XsCodOpe,"OPER")
IF !RLOCK("OPER")
   DO Close_File
   RETURN
ENDIF
XsNroAst = NROAST()
WAIT "Generando Asiento "+XsNroAst WINDOW NOWAIT
SELE Head
APPEND BLANK
IF !REC_LOCK(5)
   DO Close_File
   RETURN
ENDIF
REPLACE NroMes WITH XsNroMes
REPLACE CodOpe WITH XsCodOpe
REPLACE NroAst WITH XsNroAst
REPLACE FlgEst WITH "R"
*
REPLACE GDOC->NroMes WITH XsNroMes
REPLACE GDOC->CodOpe WITH XsCodOpe
REPLACE GDOC->NroAst WITH XsNroAst
REPLACE GDOC->FlgCtb WITH .T.
*
SELECT OPER
=NROAST(XsNroAst)
SELECT Head
REPLACE FchAst WITH XdFchAst
REPLACE NroVou WITH XsNroVou
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE NotAst WITH XsNotAst
REPLACE Digita WITH GsUsuario
* Grabamos Detalle *
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XfImport,XdFchDoc,XdFchVto
* Cuenta de Factura
=SEEK(GDOC->CodDoc,"TDOC")
XiNroItm = 1
XcEliItm = [ ]
XsCodCta = TDOC->CodCta
XsCodRef = GDOC->CodDoc
=SEEK(XsCodCta,"CTAS")
IF CTAS->PIDAUX="S"
   XsClfAux = GsClfAux
   XsCodAux = GDOC->CodCli
   XsNroRuc = GDOC->RucCli
ELSE
   XsClfAux = SPACE(LEN(Item->ClfAux))
   XsCodAux = SPACE(LEN(Item->CodAux))
   XsNroRuc = SPACE(LEN(Item->NroRuc))
ENDIF
XcTpoMov = [D]
XfImport = GDOC->ImpTot
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
XsGloDoc = GDOC->NomCli
XsCodDoc = GDOC->CodDoc
XsNroDoc = GDOC->NroDoc
XsNroRef = GDOC->NroDoc
XdFchDoc = GDOC->FchDoc
XdFchVto = GDOC->FchVto
DO MovbVeri IN vtammovm
* Cuenta de Impuestos
XcEliItm = [ ]
XsCodCta = [40111]      && Del plana de cuentas
XsCodRef = GDOC->CodDoc
=SEEK(XsCodCta,"CTAS")
IF CTAS->PIDAUX="S"
   XsClfAux = GsClfAux
   XsCodAux = GDOC->CodCli
   XsNroRuc = GDOC->RucCli
ELSE
   XsClfAux = SPACE(LEN(Item->ClfAux))
   XsCodAux = SPACE(LEN(Item->CodAux))
   XsNroRuc = SPACE(LEN(Item->NroRuc))
ENDIF
XcTpoMov = [H]
XfImport = GDOC->ImpIgv
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
XsGloDoc = []
XsCodDoc = GDOC->CodDoc
XsNroDoc = GDOC->NroDoc
XsNroRef = GDOC->NroDoc
XdFchDoc = {,,}
XdFchVto = {,,}
DO MovbVeri IN vtammovm
* Cuenta 7
=SEEK(GDOC->CodDoc+GDOC->NroDoc,"DETA")
=SEEK(LEFT(DETA->CodMat,LEN(FAMI->CodFam)),"FAMI")
XcEliItm = [ ]
XsCodCta = FAMI->Ctac70

* OJO >> por ahora fijamos la cuenta a usar * (si no te gusta lo cambias)
XsCodCta = [701101]
* * * * * * * * * * *

XsCodRef = GDOC->CodDoc
=SEEK(XsCodCta,"CTAS")
IF CTAS->PIDAUX="S"
   XsClfAux = GsClfAux
   XsCodAux = GDOC->CodCli
   XsNroRuc = GDOC->RucCli
ELSE
   XsClfAux = SPACE(LEN(Item->ClfAux))
   XsCodAux = SPACE(LEN(Item->CodAux))
   XsNroRuc = SPACE(LEN(Item->NroRuc))
ENDIF
XcTpoMov = [H]
XfImport = GDOC->ImpBto-GDOC->ImpDto-GDOC->ImpInt-GDOC->ImpAdm
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
XsGloDoc = []
XsCodDoc = GDOC->CodDoc
XsNroDoc = GDOC->NroDoc
XsNroRef = GDOC->NroDoc
XdFchDoc = {,,}
XdFchVto = {,,}
DO MovbVeri IN vtammovm
* * * *
SELE Head
DO Close_File

RETURN
*********************************************************************** FIN() *
* Objeto : Abrir Base de Contabilidad
******************************************************************************
PROCEDURE Open_File

USE cbdmctas IN 0 ORDER ctas01 ALIAS CTAS
IF !USED()
   RETURN 0
ENDIF
*
USE &DirCtb.cbdvmovm IN 0 ORDER vmov01 ALIAS Head
IF !USED()
   SELE CTAS
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdrmovm IN 0 ORDER rmov01 ALIAS Item
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdtoper IN 0 ORDER oper01 ALIAS OPER
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdacmct IN 0 ORDER acct01 ALIAS ACCT
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   SELE OPER
   USE
   RETURN 0
ENDIF
*
RETURN .T.
*********************************************************************** FIN() *
* Objeto : Cerrar Base de Contabilidad
******************************************************************************
PROCEDURE Close_File

SELE CTAS
USE
SELE Head
USE
SELE Item
USE
SELE OPER
USE
SELE ACCT
USE

RETURN
*********************************************************************** FIN() *
