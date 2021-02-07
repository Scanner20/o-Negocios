*****************************************************************************
*  Nombre       : CCBASIGN.PRG												*	
*  Autor        : VETT														*
*  Proposito    : ASIGNACION DE NOTAS DE ABONO								*
*  Creaci¢n     : 18/05/93													*
*				  VETT 02/09/2003 Adaptacion para VFP 7					 	*
*  Actualizaci¢n: VETT 23/11/2003 CEVA										*
*****************************************************************************
IF !verifyvar('GsAsigCC','C')
	return
ENDIF

DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.abrirtabla('ABRIR','VTAVPROF','VPRO','GDOC01','')

RELEASE LoDatAdm

RESTORE FROM GoCfgVta.oentorno.tspathcia+'vtaCONFG.MEM' ADDITIVE

DO fondo WITH 'Asignaciones',Goentorno.user.login,GsNomCia,GsFecha

** VETT  21/03/2018 08:40 PM : Cambiamos variable de fecha de asignacion de XdFchDoc a XdFchEmi 
* * * *
SELE GDOC
SET RELA TO GsClfCli+CodCli INTO AUXI
** VARIABLES DEL SISTEMA **
PRIVATE XsTpoDoc,XsCodDoc,XsNroDoc,XsCodCli,XdFchDoc,XiCodMon,XfTpoCmb,XdFchEmi
PRIVATE XfSdoDoc
XsTpoDoc = [ABONO]
XsCoddoc = SPACE(LEN(GDOC->CODDOC))
XsNrodoc = SPACE(LEN(GDOC->NRODOC))
XsCodcli = SPACE(LEN(GDOC->CODCLI))
XdFchDoc = {}
XdFchEmi = DATE() 
XiCodMon = 1      && Soles
XfTpoCmb = 0.00
XfSdoDoc = 0.00
* variables del browse *
PRIVATE XsCodRef,XsTpoRef,XsNroRef,XfImport,XfSdoRef
XsCodRef = ""
XsTpoRef = "CARGO"
XsNroRef = ""
XfImport = 0
XfSdoRef = 0
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
XsCodOpe = GsAsigCC && [021]        && << OJO <<
LsAlias_CAB = ''
LsCdBusca   = ''
*
UltTecla = 0
DO WHILE .T.
   CLEAR
   @ 0,25 SAY "SISTEMA DE CUENTAS POR COBRAR" COLOR SCHEME 7
   @ 1,25 SAY "   ASIGNACION DE DOCUMENTOS  " COLOR SCHEME 7

*          1         2         3         4         5         6         7         8
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*0
*1
*2
*3       Documento : 123                      Fecha de Documento :
*4    N§ Documento :                         Fecha de Asignacion :
*5         Cliente : 123456 12345678901234567890123456789012345678901234567890
*6          Moneda :                          Tipo de Cambio     :
*7         Importe :                          Saldo a Asignar    :
*8
*9
*0
*1
*2
*3

IF _DOS OR _Unix

   @ 2,0 TO 23,79 PANEL
ELSE
   @ 2,0 TO 30,80 PANEL
ENDIF   

   @ 3,5   SAY "   Documento : "
   @ 4,5   SAY "N§ Documento : "
   @ 4,45  SAY "Fecha de Documento : "
   @ 5,5   SAY "     Cliente : "
   @ 6,5   SAY "      Moneda : "
   @ 6,45  SAY "Tipo de Cambio     : "
   @ 7,5   SAY "     Importe : "
   @ 7,45  SAY "Saldo a Asignar    : "
   *
   SELE TDOC
   SET FILTER TO TpoDoc = [ABONO]
   *
   SELE GDOC
   SET ORDER TO GDOC01
   GsMsgKey = "[Esc] Cancela      [Enter] Registar       [F8] Consulta"

   DO LIB_MTEC WITH 99
   Mensaje = ""
   @ 3,5   SAY "   Documento :" GET XsCodDoc PICT "@!"  VALID _CodDoc() ERROR Mensaje
   @ 4,5   SAY "N§ Documento :" GET XsNroDoc PICT "@!"  VALID _NroDoc() ERROR Mensaje
   READ
   UltTecla = LASTKEY()
   IF UltTecla = escape_
      EXIT
   ENDIF
   *
   SELE TDOC
   SET FILTER TO
   *
   SELE GDOC
   SEEK XsTpoDoc+XsCodDoc+XsNroDoc
   DO CJAEDITA
ENDDO
CLEAR MACROS 
CLEAR
DO close_file
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
**********************************************************************
FUNCTION _SwapAlias
****************
PARAMETERS PsCodDoc
LsAlias_CAB = ''
DO CASE
	CASE INLIST(PsCodDoc ,'NCPR','ANPR','PROF')
		LsAlias_CAB= 'VPRO'
		LsCdBusca  = 'ASPROF'
	OTHERWISE 
		LsAlias_CAB= 'GDOC'
		LsCdBusca  = 'ASIG'
ENDCASE
SELECT  (LsAlias_CAB)
**************
FUNCTION _coddoc
**************
IF LASTKEY()=F8 .OR. EMPTY(XsCodDoc)
   SELECT TDOC
   IF ccbbusca("TDOC")
      XsCodDoc = TDOC->CodDoc
   ELSE
      Mensaje = ""
      RETURN 0
   ENDIF
ENDIF
IF !SEEK(XsCodDoc,"TDOC")
   Mensaje = "C¢digo de Documento no Existe"
   WAIT Mensaje NOWAIT WINDOW
   RETURN 0
ENDIF
IF XsTpoDoc # TDOC->TpoDoc
   Mensaje = "El c¢digo no corresponde a un documento de Abono"
   WAIT Mensaje NOWAIT WINDOW
   RETURN 0
ENDIF
@ 3,25 SAY TDOC->DESDOC

RETURN .T.
*************************************************************************** FIN
FUNCTION _nrodoc
****************
DO CASE
	CASE INLIST(XsCodDoc ,'NCPR','ANPR','PROF')
		SELECT VPRO
		SET ORDER TO GDOC01
		IF LASTKEY()=F8 .OR. EMPTY(XsNroDoc)
		   IF ccbbusca("NCPR")
		      XsNroDoc = VPRO.NroDoc
		   ELSE
		      Mensaje = ""
		      RETURN 0
		   ENDIF
		ENDIF

		IF ! SEEK(XsTpodoc+XsCodDoc+XsNrodoc,"VPRO")
		   Mensaje =  "Documento no registrado"
		   WAIT Mensaje NOWAIT WINDOW
		   RETURN 0
		ENDIF

	OTHERWISE 
		SELECT GDOC
		SET ORDER TO GDOC01
		IF LASTKEY()=F8 .OR. EMPTY(XsNroDoc)
		   IF ccbbusca("GDOC")
		      XsNroDoc = GDOC->NroDoc
		   ELSE
		      Mensaje = ""
		      RETURN 0
		   ENDIF
		ENDIF

		IF ! SEEK(XsTpodoc+XsCodDoc+XsNrodoc,"GDOC")
		   Mensaje =  "Documento no registrado"
		   WAIT Mensaje NOWAIT WINDOW
		   RETURN 0
		ENDIF
	
ENDCASE
IF FlgEst = 'A'
   Mensaje = "Documento Anulado"
   WAIT Mensaje NOWAIT WINDOW
   RETURN 0
ENDIF

SHOW GETS
RETURN .T.
*************************************************************************** FIN
* Edita registro seleccionado (Crear , Anular )
**********************************************************************
PROCEDURE CJAEdita

** BLOQUEAMOS BASES NECESARIAS **

=_SwapAlias(XsCodDoc)
SELECT  (LsAlias_CAB)
IF ! RLOCK()
   RETURN
ENDIF
   SELE SLDO
   SEEK &LsAlias_CAB..CodCli
   IF !FOUND()
      APPEND BLANK
      REPLACE CodCli WITH &LsAlias_CAB..CodCli
   ELSE
      =REC_LOCK(0)
   ENDIF
** cargamos variables de control **
SELE (LsAlias_CAB)
XsCodCli = &LsAlias_CAB..CodCli
XiCodMon = &LsAlias_CAB..CodMon
XfTpoCmb = &LsAlias_CAB..TpoCmb
XfSdoDoc = &LsAlias_CAB..SdoDoc
XdFchDoc = &LsAlias_CAB..FchDoc
XdFchEmi = &LsAlias_CAB..FchEmi
**
=SEEK(GsClfCli+XsCodCli,"AUXI")
DO LIB_MTEC WITH 7
@ 3,45  SAY "Fecha de Documento :" GET FchDoc pict '@d dd/mm/aa'
@ 5,5   SAY "      Cuenta :"       GET CodCli PICT "@!"
@ 5,34  SAY AUXI->NomAux PICT "@S35"
@ 6,5   SAY "      Moneda :"       GET CodMon FUNCTION "*RH SOLES;DOLARES"
@ 7,5   SAY "     Importe :"       GET ImpTot PICT "999,999.99"
@ 7,45  SAY "Saldo a Asignar    :" GET SdoDoc PICT "999,999.99"
CLEAR GETS
@ 4,44  SAY "Fecha de Asignacion :" GET XdFchEmi pict '@d dd/mm/aa'
@ 6,45  SAY "Tipo de Cambio     :"  GET XfTpoCmb PICT "9,999.9999" VALID(XfTpoCmb>0)
READ
IF LASTKEY() = escape_
   RETURN
ENDIF
DO LIB_MTEC WITH 14
DO XBROWSE
RETURN
************************************************************************* FIN *
* Browse
*******************************************************************************
PROCEDURE XBROWSE

SELECT VTOS
UltTecla = 0
SelLin   = "BSALDO"
InsLin   = "BGRABA"
EscLin   = "BLINEA"
EdiLin   = "BEDITA"
BrrLin   = "BELIMI"
GrbLin   = "BGRABA"
NClave   = [CODDOC+NRODOC]
VClave   = XSCODDOC+XSNRODOC
HTitle   = 3
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
Yo       = 08
Largo    = 14
Titulo   = ""
TBorde   = Simple
E1       =  [ COD.      NRO.                IMPORTE          SALDO   ]
E2       =  [ REF.   REFERENCIA             COBRADO          ACTUAL  ]
E3       = []

* COD.      NRO.                IMPORTE          SALDO   ]
* REF.   REFERENCIA             COBRADO          ACTUAL  ]
* 1234   123456789012345   9,999,999.99   S/.9,999,999.99

LinReg   = []
Ancho    = 58
Xo       = INT((80 - Ancho)/2)
Consulta = .F.
Modifica = .F.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
BBverti  = .T.
nColor_Sch = 18
SELECT VTOS
DO DBrowse
RETURN
********************************************************************
PROCEDURE BEDITA
***************

** OJO >> Solo se permite CREAR **
** Verificamos fecha de asignacion **
IF !ctb_aper(XdFchEmi)
   SELE VTOS
   UltTecla = escape_
   RETURN
ENDIF
* * * * * * * * * * * * * * * * * * *
XsCodRef=SPACE(LEN(VTOS->CODREF))
XsNroRef=SPACE(LEN(VTOS->NROREF))
XfImport  = 0.00
XfSdoRef  = 0.00
DO LIB_MTEC WITH 7
UltTecla = 0
Mensaje =""
@ LinAct,Xo+2  GET XsCodRef PICT "@!"  ERROR Mensaje VALID _CodRef()
@ LinAct,Xo+9  GET XsNroRef PICT "@!"  ERROR Mensaje VALID _NroRef()
@ LinAct,Xo+27 GET XfImport PICT "9,999,999.99" VALID(XfImport<=XfSdoRef)
READ
UltTecla = LASTKEY()
IF UltTecla = escape_
   DO ctb_cier
ENDIF
SELECT VTOS
DO LIB_MTEC WITH 14
RETURN
****************
FUNCTION _CODREF
****************
IF LASTKEY()=F8 .OR. EMPTY(XsCodRef)
   SELECT TDOC
   IF ccbbusca("TDOC")
      XsCodRef = TDOC->CodDoc
   ELSE
      Mensaje = ""
      RETURN 0
   ENDIF
ENDIF
IF !SEEK(XsCodRef,"TDOC")
   Mensaje = "C¢digo de Documento no Existe"
   RETURN 0
ENDIF
IF TDOC->TpoDoc # "CARGO"
   Mensaje = "No es un Documento de Cargo"
   RETURN 0
ENDIF
SHOW GETS
RETURN .T.
*****************
PROCEDURE _NROREF
*****************
=_SwapAlias(XsCodDoc)
SET ORDER TO GDOC04
IF LASTKEY()=F8 .OR. EMPTY(XsNroRef)
   IF ccbbusca("ASIG")
      XsNroRef = &LsAlias_CAB..NroDoc
   ELSE
      Mensaje = ""
      RETURN 0
   ENDIF
ENDIF
SET ORDER TO GDOC01
SEEK XsTpoRef+XsCodRef+XsNroRef
IF ! FOUND()
   SELE VTOS
   Mensaje = "Documento no Registrado"
   RETURN .F.
ENDIF
IF CodCli <> XsCodCli
   SELE VTOS
   Mensaje = "Asignado al cliente "+CodCli
   RETURN .F.
ENDIF
IF FLGEST # "P"
   SELE VTOS
   Mensaje = "Documento Cancelado"
   RETURN .F.
ENDIF
XfImport = SdoDoc
IF XiCodMon <> &LsAlias_CAB..CodMon
   IF XiCodMon = 1
      XfImport = ROUND(XfImport * XfTpoCmb,2)
   ELSE
      XfImport = ROUND(XfImport / XfTpoCmb,2)
   ENDIF
ENDIF
XfSdoRef = MIN(XfImport,XfSdoDoc)
XfImport = XfSdoRef
SELE VTOS
RETURN .T.

***************
PROCEDURE BGRABA
***************
=_SwapAlias(XsCodDoc)
SET ORDER TO GDOC01
SEEK XsTpoRef+XsCodRef+XsNroRef     && Documento de Cargo
IF ! RLOCK()
   UNLOCK
   SELECT VTOS
   RETURN
ENDIF
** Comienza la Actualizacion **
SELE VTOS
IF CREAR
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   IF !RLOCK()
      RETURN
   ENDIF
ENDIF
REPLACE FCHDOC WITH XdFchDoc
REPLACE FCHING WITH XdFchEmi
REPLACE CODCLI WITH XsCodCli
REPLACE CODMON WITH XiCodMon
REPLACE TPOCMB WITH XfTpoCmb
REPLACE TPOREF WITH XsTpoRef
REPLACE CODREF WITH XsCodRef
REPLACE NROREF WITH XsNroRef
REPLACE IMPORT WITH XfImport
REPLACE GLODOC WITH [ASIGNACION AUTOMATICA ]+VTOS.CodDoc+[ ]+VTOS.NroDoc
* descargamos saldos por la N/Abono *
LfImport = VTOS->Import
=_SwapAlias(XsCodDoc) && SELECT GDOC
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
REPLACE SdoDoc WITH SdoDoc - LfImport
REPLACE FchAct WITH XdFcHEmi && XdFchDoc
REPLACE TpoCmb WITH XfTpoCmb
IF SdoDoc <= 0.01
   REPLACE FlgEst WITH 'C'
ENDIF
@ 7,45  SAY "Saldo a Asignar    :" GET SdoDoc PICT "999,999.99" DISABLE
XfSdoDoc = &LsAlias_CAB..SdoDoc
SELE SLDO
IF VTOS->CodMon = 1
   REPLACE AbnNAC WITH AbnNAC - LfImport
ELSE
   REPLACE AbnUSA WITH AbnUSA - LfImport
ENDIF
** descargamos saldos por la Asignacion **
=_SwapAlias(XsCodDoc) && SELECT GDOC
SEEK XsTpoRef+XsCodRef+XsNroRef
LfImport = VTOS->Import
IF VTOS->CodMon <> &LsAlias_CAB..CodMon
   IF &LsAlias_CAB..CodMon = 1
      LfImport = ROUND(VTOS->Import * VTOS->TpoCmb,2)
   ELSE
      LfImport = ROUND(VTOS->Import / VTOS->TpoCmb,2)
   ENDIF
ENDIF
REPLACE SdoDoc WITH SdoDoc - LfImport
REPLACE FchAct WITH XdFchEmi  && XdFchDoc
IF SdoDoc <= 0.01
   REPLACE FlgEst WITH "C"
ENDIF
UNLOCK
SELE SLDO
IF GDOC->CodMon = 1
   REPLACE CGONAC WITH CGONAC - LfImport
ELSE
   REPLACE CGOUSA WITH CGOUSA - LfImport
ENDIF
UNLOCK
** Actualizacion Contable **
DO xACT_CTB
* * * * * * * * * * * * * * *
SELE VTOS
UNLOCK

RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE BElimi

SELE VTOS
IF ! RLOCK()
   RETURN
ENDIF
=_SwapAlias(XsCodDoc) && SELECT GDOC
SET ORDER TO GDOC01
=SEEK(VTOS.TpoRef+VTOS.CodRef+PADR(VTOS.NroRef,LEN(&LsAlias_CAB..NroDoc)),LsAlias_CAB)
IF ! RLOCK()
   UNLOCK
   SELECT VTOS
   RETURN
ENDIF
* VEAMOS SI SE PUEDE ANULAR LA CONTABILIDAD *
IF VTOS.FlgCtb
   IF !ctb_aper(VTOS.FchDoc)
      SELE VTOS
      UNLOCK
      UNLOCK IN &LsAlias_CAB.
      RETURN
   ENDIF
ENDIF
** Cargamos saldo al documento destino **
LfImport = VTOS->Import
IF VTOS->CODMON <> &LsAlias_CAB..CODMON
   IF GDOC->CODMON = 1
      LfImport = ROUND(VTOS->IMPORT * VTOS->TPOCMB,2)
   ELSE
      LfImport = ROUND(VTOS->IMPORT / VTOS->TPOCMB,2)
   ENDIF
ENDIF
SELECT &LsAlias_CAB.  && GDOC
REPLACE SdoDoc WITH SdoDoc + LfImport
REPLACE FlgEst WITH "P"
REPLACE FchAct WITH XdFchEmi && XdFchDoc
UNLOCK
SELE SLDO
IF &LsAlias_CAB..CodMon = 1
   REPLACE CGONAC WITH CGONAC + LfImport
ELSE
   REPLACE CGOUSA WITH CGOUSA + LfImport
ENDIF
** Cargamos saldo a la N/Abono **
SELECT &LsAlias_CAB.  && GDOC
LfImport = VTOS->Import
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
REPLACE SdoDoc WITH SdoDoc + LfImport
REPLACE FlgEst WITH 'P'
REPLACE FchAct WITH XdFchEmi && XdFchDoc
@ 7,45  SAY "Saldo a Asignar    :" GET SdoDoc PICT "999,999.99" DISABLE
XfSdoDoc = SdoDoc
SELE SLDO
IF &LsAlias_CAB..CodMon = 1
   REPLACE AbnNAC WITH AbnNAC + LfImport
ELSE
   REPLACE AbnUSA WITH AbnUSA + LfImport
ENDIF
* ANULAMOS CONTABILIDAD
IF VTOS.FlgCtb
   DO xANUL_CTB
ENDIF
*
SELE VTOS
DELETE
UNLOCK
@ 23,17 SAY "Asiento :"+SPACE(LEN(VTOS.NroMes))+' '+ SPACE(LEN(VTOS.CodOpe))+' '+SPACE(LEN(VTOS.NroAst)) COLOR SCHEME 7
RETURN
*************************************************************************** FIN

****************
PROCEDURE BSALDO
****************
SELE VTOS
XTIMPORT = 0
@ 23,17 SAY "Asiento :"+VTOS.NroMes+' '+ VTOS.CodOpe+' '+VTOS.NroAst COLOR SCHEME 7
SEEK XSCODDOC+XSNRODOC
DO WHILE XSCODDOC+XSNRODOC = CODDOC+NRODOC
   XTIMPORT = XTIMPORT + IMPORT
   SKIP
ENDDO
@ 22,17 SAY "TOTAL IMPORTES -> "+TRANSFORM(XTIMPORT,"999,999,999.99") COLOR SCHEME 7

RETURN
**************************************************************************


****************
PROCEDURE BLINEA
****************
PARAMETER Contenido
* COD.      NRO.           IMPORTE          SALDO ]
* REF.   REFERENCIA        COBRADO          ACTUAL]
* 1234   1234567890   9,999,999.99   S/.9,999,999.99
=_SwapAlias(XsCodDoc)
LinReg   = [CODREF+"   "+NROREF+"   "+TRANSFORM(IMPORT,"9,999,999.99")+"   "+IIF(&LsAlias_CAB..CODMON=1,"S/. ","US$ ")+TRANSFORM(&LsAlias_CAB..SDODOC,"9,999,999.99")]
=SEEK(VTOS.TpoRef+VTOS.CodRef+PADR(VTOS.NroRef,LEN(&LsAlias_CAB..NroDoc)),LsAlias_CAB)
SELECT VTOS
Contenido = CODREF+"   "+NROREF+"   "+TRANSFORM(IMPORT,"9,999,999.99")+"   "+IIF(&LsAlias_CAB..CODMON=1,"S/. ","US$ ")+TRANSFORM(&LsAlias_CAB..SDODOC,"9,999,999.99")
RETURN
******************
PROCEDURE REGENDOC
******************
SELE VTOS
SEEK TASG->CodDoc+TASG->CodDoc
XsCodDoc = CodDoc
XsNroDoc = NroDoc
XdFchDoc = FchDoc
XsCodCli = CodCli
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XsTpoRef = TpoRef
XsCodRef = CodRef
XsNroRef = NroRef
XfImport = Import
SELE GDOC
IF XsCodRef = [ADEL]
   REPLACE TpoDoc WITH [ABONO]
   REPLACE CodDoc WITH XsCodRef
   REPLACE NroDoc WITH XsNroDoc  && El numero del I/C.
   REPLACE FchDoc WITH XdFchDoc  && Datos del I/C.
   REPLACE CodCli WITH XsCodCli
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE Glosa1 WITH XsGloDoc
   REPLACE TpoRef WITH []
   REPLACE CodRef WITH []
   REPLACE NroRef WITH []
   REPLACE ImpNet WITH XfImport
   REPLACE ImpTot WITH XfImport
   REPLACE FchVto WITH XdFchDoc
   REPLACE SdoDoc WITH XfImport
   REPLACE FlgEst WITH [P]
   UNLOCK
   ** saldo del cliente **
   SELE SLDO
   IF XiCodMon = 1
      REPLACE AbnNAC WITH AbnNAC + XfImport
   ELSE
      REPLACE AbnUSA WITH AbnUSA + XfImport
   ENDIF
ENDIF
RETURN
******************************************************************************
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************
PROCEDURE xACT_CTB
=_SwapAlias(XsCodDoc)
XsCodOpe = GsAsigCC && [021]        && << OJO <<
=SEEK(&LsAlias_CAB..CodDoc,"TDOC")
IF EMPTY(TDOC.CodCta) AND EMPTY(TDOC.CTA12_MN) AND EMPTY(TDOC.CTA12_ME)
	=f1_alert('Actualización contable queda pendiente.;'+;
			'Revise en Cuentas por cobrar/Maestros/Tipo de documentos;'+;
			'y configure las cuentas contables',[MENSAJE])
   RETURN
ENDIF
=SEEK(VTOS.CodDoc,"TDOC")
IF EMPTY(TDOC.CodCta) AND EMPTY(TDOC.CTA12_MN) AND EMPTY(TDOC.CTA12_ME)
	=f1_alert('Actualización contable queda pendiente.;'+;
			'Revise en Cuentas por cobrar/Maestros/Tipo de documentos;'+;
			'y configure las cuentas contables',[MENSAJE])
   RETURN
ENDIF
XsCodOpe = TDOC.CodOpe
IF EMPTY(XsCodOpe)
	=f1_alert('Actualización contable queda pendiente.;'+;
			'Revise en Cuentas por cobrar/Maestros/Tipo de documentos;'+;
			'y la operación contable a la que pertenece esta transacción',[MENSAJE])
			
	RETURN
ENDIF

*********
** VAriables generales para generar el asiento
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsTipRef,XdFchDtr,XsNroDtr
PRIVATE XfImport,XdFchDoc,XdFchVto
PRIVATE XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,TsCodDiv1  &&XsCodOpe,XsNroMes,XsNroAst,
PRIVATE XiNroItm,XsCodDiv,XsCtaPre,XcAfecto,XsCodCco,GlInterface,XsCodDoc,XsNroDoc 
PRIVATE XsNroRef,XsCodFin,XdFchdoc,XdFchVto,XsIniAux,XdFchPed,NumCta,XsNivAdi
PRIVATE XcTipoC,XsTipDoc,XsAn1Cta,XsCc1Cta,XsChkCta, nImpUsa, nImpNac,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = 'A'
** Valores variables inicializados como STRING
dimension vcodcta(10)
STORE {} TO XdFchDoc,XdFchVto,XdFchPed
STORE '' TO XsCodCco ,XsCodDoc,XsNroDoc,XsNroRef,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta,XsNroRuc
** Valores variables inicializados como NUMERO
STORE 0 TO nImpNac,nImpUsa,NumCta

*********

SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF .f.
	SELECT &LsAlias_CAB.
	IF !EMPTY(&LsAlias_CAB..CodOpe) AND !EMPTY(NroAst) AND !EMPTY(NroMes)
		XsNroMes = &LsAlias_CAB..NroMes
		XsCodOpe = &LsAlias_CAB..CodOpe
		XsNroAst = &LsAlias_CAB..NroAst
		SELECT VMOV
		SEEK (XsNroMes + XsCodOpe + XsNroAst)
		IF FOUND()
			GOSVRCBD.Crear = .f.
			GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst,.T.)
		ELSE
			GOSVRCBD.Crear = .T.
		ENDIF
	ELSE
		SELECT OPER
		XsNroMes = TRANSF(_MES,"@L ##")
		XsNroAst = GOSVRCBD.NROAST()
		GOSVRCBD.Crear = .T.
	ENDIF
	WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
	XdFchAst = VTOS.FchDoc
	XsNroVou = ''
	XiCodMon = VTOS.CodMon
	XfTpoCmb = VTOS.TpoCmb
	XsNotAst = [ASIGNACION AUTOMATICA ]+VTOS.CodDoc+[ ]+VTOS.NroDoc
	m.Err= GOSVRCBD.MovGraba(XsCodOPe,XsNroMEs,@XsNroAst)
	IF m.Err>=0
	** ACTUALIZAR DATOS DE CABECERA **
		REPLACE VTOS.NroMes WITH XsNroMes
		REPLACE VTOS.CodOpe WITH XsCodOpe
		REPLACE VTOS.NroAst WITH XsNroAst
		REPLACE VTOS.FlgCtb WITH .T.
	ELSE
		REPLACE VTOS.FlgCtb WITH .F.
		GoSvrCbd.MensajeErr(m.Err)
		RETURN
	ENDIF
ENDIF
* * * * * * * * * * * * * * * * * *
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = GOSVRCBD.NROAST()
SELECT VMOV
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
   DO LIB_MERR WITH 11
   RETURN
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN              && No pudo bloquear registro
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FLGEST WITH "R"
REPLACE VMOV.FCHDIG  WITH DATE()
REPLACE VMOV.HORDIG  WITH TIME()
SELECT OPER
GOSVRCBD.NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH VTOS.FchDoc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH VTOS.CodMon
REPLACE VMOV->TpoCmb  WITH VTOS.TpoCmb
REPLACE VMOV->NotAst  WITH [ASIGNACION AUTOMATICA ]+VTOS.CodDoc+[ ]+VTOS.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
** ACTUALIZAR DATOS DE CABECERA **
** ACTUALIZAR DATOS DE CABECERA **
REPLACE VTOS.NroMes WITH XsNroMes
REPLACE VTOS.CodOpe WITH XsCodOpe
REPLACE VTOS.NroAst WITH XsNroAst
REPLACE VTOS.FlgCtb WITH .T.
* * * * * * * * * * * * * * * * * *


XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = IIF(EMPTY(VTOS.GloDoc),VMOV.NotAst,VTOS.GloDoc) 
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
nImpNac  = 0
nImpUsa  = 0
** Grabamos 1er. Registro **
** VETT  16/03/2018 12:59 PM : Variables para grabar  tipo , documento y fecha de referencia
STORE [] TO XsTipRef,XsNroDtr,LsLLaveRef1
STORE {} TO XdFchRef,XdFchDtr
** VETT  16/03/2018 12:59 PM 
SELE VTOS
=SEEK(CodDoc,"TDOC")
XsCodCta = PADR(IIF(VTOS.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = []
IF CTAS.PidAux=[S]
   XsCodAux = VTOS.CodCli
   XsClfAux = CTAS.ClfAux
ENDIF
XcTpoMov = [D]    && << OJO <<
XfImport = VTOS.Import
IF XiCodMon = 1
	XfImpNAc = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
    ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsTipRef = SPACE(LEN(RMOV.TipRef))
XsNroRef = SPACE(LEN(RMOV.NroRef))
XdFchDoc = {}
XdFchRef = {}
XdFchVto = {}

IF CTAS.PidDoc=[S]
*!*	   XsClfAux = CTAS.ClfAux
   XsCodDoc = IIF(SEEK(VTOS.CodDoc,'TDOC'),TDOC.TpoDocSN,'') && VTOS.CodDoc
   XsNroDoc = VTOS.NroDoc
   XdFchDoc = VTOS.FchDoc
   XdFchVto = VTOS.FchIng
*!*	   XsNroRef = VTOS.NroDoc
ENDIF
IF CTAS.PidGlo=[S]
	XsTipRef = 	IIF(SEEK(VTOS.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
	XsNroRef =   VTOS.NroRef
	** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de referencia 
	LiRecActGDOC = RECNO(LsAlias_CAB)
	LsLLaveRef1=VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef
    IF SEEK(LsLLaveRef1,LsAlias_CAB)
    	XdFchRef = &LsAlias_CAB..FchDoc
    ENDIF
    GO LiRecActGDOC IN (LsAlias_CAB) 
ENDIF
*DO MovbVeri IN ccb_ctb
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
** Grabamos 2do. Registro **
SELE VTOS
=SEEK(CodRef,"TDOC")
=SEEK(VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef,'GDOC','GDOC01')
XsCodCta = PADR(IIF(GDOC.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
*** Chequear la cuenta de origen del documento ***
*!*	=CHkDoc()
***
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = []
IF CTAS.PidAux=[S]
   XsCodAux = VTOS.CodCli
   XsClfAux = CTAS.ClfAux
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = VTOS.Import
IF XiCodMon = 1
	XfImpNac = XfImport	
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
    ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroRef))
XdFchDoc = {}
XdFchRef = {}
XdFchVto = {}
IF CTAS.PidDoc=[S]
	** VETT  14/03/18 23:32 : Cambiamos de tabla de documentos para que detecte la CFG de retenciones 
	XsCodDoc = IIF(SEEK(VTOS.CodRef,'TDOC'),TDOC.TpoDocSN,'')
	XsNroDoc = VTOS.NroRef
	** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de origen 
	LiRecActGDOC = RECNO(LsAlias_CAB)
	LsLLaveRef1=VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef
    IF SEEK(LsLLaveRef1,LsAlias_CAB)
    	XdFchDoc	=	&LsAlias_CAB..FchDOc
    	XdFchVto	=	&LsAlias_CAB..FchVto
    ENDIF
    GO LiRecActGDOC IN (LsAlias_CAB)   
ENDIF
IF CTAS.PidGlo=[S]
	** VETT  15/03/2018 05:06 PM : Colocamos documento y fecha de referencia 
	XsTipRef = 	IIF(SEEK(VTOS.CodDoc,'TDOC'),TDOC.TpoDocSN,'')	
	XsNroRef =  VTOS.NroDoc
	XdFchRef =	VTOS.FchDoc	  
ENDIF

**DO MovbVeri IN ccb_ctb
XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT
DO ctb_cier

RETURN
************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = VTOS.NroMes
XsCodOpe = VTOS.CodOpe
XsNroAst = VTOS.NroAst
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN
ENDIF
GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst)
SELE VMOV
IF FlgEst = [A]
  *DELETE   && Por Ahora
ENDIF
DO ctb_cier

RETURN
************************************************************************ FIN *
FUNCTION ChkDoc
***************
PRIVATE xxCodCta,NumCta,LsxxCodCta,OK,Z,LsCodCta,LsNroAst
LsNroAst = VTOS.NroRef
DIMENSION xxCodCta(4)
NumCta = 0
* 1ro. si tiene codigo de cuenta
* cuenta normal *
IF EMPTY(TDOC.CodCta)
   GsMsgErr = [ No tiene registrado el c¢digo de cuenta ]
   DO lib_merr WITH 99
   RETURN .F.
ENDIF
LsxxCodCta = ALLTRIM(TDOC->CodCta)
* 2do. si tiene reflejo contable *
DO WHILE .T.
   IF EMPTY(LsxxCodCta)
      EXIT
   ENDIF
   NumCta = NumCta + 1
   IF NumCta > ALEN(xxCodCta)
      DIMENSION xxCodCta(NumCta+5)
   ENDIF
   Z = AT(",",LsxxCodCta)
   IF Z = 0
      Z = LEN(LsxxCodCta) + 1
   ENDIF
   xxCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
   IF Z > LEN(LsxxCodCta)
      EXIT
   ENDIF
   LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
ENDDO
*
OK = .F.
PRIVATE LsCodCta,LiCodMon,LfImport,Llave,SdoNac,SdoUsa
STORE [] TO LsCodCta,LiCodMon,LfImport,Llave,SdoNac,SdoUsa
FOR Z = 1 TO NumCta
   LsCodCta = xxCodCta(Z)
   SELECT RMOV
   SET ORDER TO RMOV05
   SEEK LsCodCta + LsNroAst
   IF FOUND()
      LsCodAux = CodAux
      LiCodMon = CodMon
      LfImport = 0
      Llave = LsCodCta+LsNroAst+LsCodAux
      SdoNac = 0
      SdoUsa = 0
      DO WHILE ! EOF() .AND. CodCta+NroDoc+CodAux = Llave
         SdoNac   = SdoNac   + IIF(TpoMov="H",-1,1)*Import
         SdoUsa   = SdoUsa   + IIF(TpoMov="H",-1,1)*ImpUsa
         SKIP
      ENDDO
      IF LiCodMon = 1
         LfImport = SdoNac
      ELSE
         LfImport = SdoUsa
      ENDIF
      IF XiCodMon # LiCodMon
         IF XiCodMon = 1
            LfImport = ROUND(LfImport*XfTpoCmb,2)
         ELSE
            LfImport = ROUND(LfImport/XfTpoCmb,2)
         ENDIF
      ENDIF
      SET ORDER TO RMOV01
      OK = .T.
      EXIT
   ENDIF
NEXT
SELECT VMOV
SET ORDER TO VMOV01
IF ! Ok
   GsMsgErr = "*** Provisi¢n mal Registrada **"
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
IF LsCodAux <> XsCodCli
   GsMsgErr = "*** Auxiliar no corresponde **"
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
XsCodCta = LsCodCta

RETURN .T.

PROCEDURE Close_file
IF USED('CTAS')
	USE IN CTAS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF

IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('RDOC')
	USE IN RDOC
ENDIF
IF USED('SLDO')
	USE IN SLDO
ENDIF
IF USED('TDOC')
	USE IN TDOC
ENDIF
IF USED('TCMB')
	USE IN TCMB
ENDIF
IF USED('TASG')
	USE IN TASG
ENDIF
IF USED('RASG')
	USE IN RASG
ENDIF
IF USED('TABLA')
	USE IN TABLA
ENDIF
IF USED('TABL')
	USE IN TABL
ENDIF
IF USED('CNFG')
	USE IN CNFG
ENDIF
IF USED('PROV')
	USE IN PROV
ENDIF

IF USED('DOCM')
	USE IN DOCM
ENDIF
IF USED('DIRE')
	USE IN DIRE
ENDIF
IF USED('DOCS')
	USE IN DOCS
ENDIF
IF USED('VPRO')
	USE IN VPRO
ENDIF

