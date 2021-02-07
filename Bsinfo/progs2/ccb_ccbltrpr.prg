**************************************************************************
*  Nombre    : CcbLtrPr.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Protesto de Letras                                        *
*  Par metros: Ninguno                                                   *
*  Creaci¢n     : 01/01/2000                                             *
*  Actualizaci¢n: 27/07/2000											 *
*				  Genera asiento de protesto y controla flgsit anterior	 *
*  Actualización: 03/05/2006 - Chequeo de variables de configuracion
*					Adaptacion para o-Negocios  					 	
**************************************************************************
IF !verifyvar('GsLetPrt','C') && Operacion de protesto de letras
	return
ENDIF
*!*	IF !verifyvar('GsGasPrt','C') && Codigo de gastos por protesto de letras
*!*		return
*!*	ENDIF
**
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

DO fondo WITH 'Protesto de Letras',Goentorno.user.login,GsNomCia,GsFecha
*******************************
* Aperturando Archivos a usar *
*******************************
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC07','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','CCBNTASG','TASG','TASG01','')
LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
** RELACIONES A USAR **
SELE gdoc
SET RELA TO GsClfCli+CodCli INTO auxi
XSCODOPE=GsLetPrt && [021]   && Protesto de letras

**********************************
* Inicializando Variables a usar *
**********************************
STORE 0 TO nImpNac,nImpusa
_MES=MONTH(DATE())
**  
SELE gdoc
m.codcta = SPACE(LEN(CTAS.codcta))
m.codbco = SPACE(LEN(GDOC.codbco))
m.nrocta = SPACE(LEN(GDOC.nrocta))
m.tpodoc = "CARGO"
m.coddoc = "LETR"
m.codmon = 1
m.TpoCmb = 1
m.flgest = 'P'    && Pendiente
m.flgubc = 'C'    && En Cartera
m.flgsit = 'P'    && Protestada
XcFlgSit  = ' '    && Situacion original de la letra "C", "D"
XcFlgUbc  = ' '    && Ubicacion original de la letra 
**
STORE 0 TO XfInteres,XfGastos,XfTotalG,XfImport
** variables a usar en el browse **
m.nrodoc = SPACE(LEN(GDOC.nrodoc))
m.fchubc = DATE()

DO DcbCGrba
UNLOCK ALL

DO CLOSE_FILE IN CCB_CCBAsign
LoDatAdm.closetable('ACCT')
LoDatAdm.closetable('RMOV')
LoDatAdm.closetable('VMOV')
LoDatAdm.closetable('OPER')
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RELEASE LoDatAdm
RETURN
********************************************************************** FIN
* Procedimiento de Grabacion de informacion de Cabezera
******************************************************************************
PROCEDURE DcbCGrba

** abrimos el browse **
** Definimos variables a usar en el Browse **
PRIVATE SelLin,EdiLin,BrrLin,InsLin,GrbLin,EscLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
SelLin   = ""
EscLin   = ""
EdiLin   = "BROWedit"
BrrLin   = "BROWborr"
InsLin   = ""
GrbLin   = "BROWgrab"
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .T.
Db_Pinta = .F.
** Definimos variables a usar en el Browse **
PRIVATE Set_Escape
Set_Escape = .T.
UltTecla = 0
*
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8
PRIVATE MVprgF9,NClave,VClave,LinReg,Titulo,VTitle,HTitle
PRIVATE Yo,Xo,Largo,Ancho,TBorde
PRIVATE CBorde,CTexto,CBarra,CTitle
PRIVATE BBVerti,Static,VSombra,E1,E2,E3
MVprgF1  = ""
MVprgF2  = ""
MVprgF3  = ""
MVprgF4  = ""
MVprgF5  = ""
MVprgF6  = ""
MVprgF7  = ""
MVprgF8  = ""
MVprgF9  = ""
PrgFin   = []
NClave   = "FlgEst+FlgSit+TpoDoc+CodDoc"
VClave   = m.flgest+m.flgsit+m.tpodoc+m.coddoc
Titulo   = [ ** LETRAS PROTESTADAS ** ]
VTitle   = 1
HTitle   = 0
Yo       = 5
Xo       = 0
Largo    = 16
Ancho    = 85
Tborde   = Simple
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = "    NUMERO   CLIENTE       N O M B R E           FCH.PROT.              IMPORTE    "
E2 = ""
E3 = ""

*         1         2         3         4         5         6         7          8    
*01234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*    NUMERO   CLIENTE       N O M B R E           FCH.PROT.              IMPORTE    "
*01234567890 12345 123456789012345678901234567890123 99/99/9999 S/.999,999,999.99
*
LinReg = [NroDoc+' '+CodCli+' '+LEFT(auxi.nomaux,30)+' '+DTOC(FchUbc)+' '+;
         IIF(CodMon=1,'S/.','US$')+TRANS(ImpTot,'999,999,999.99')]
**
SELECT gdoc
** variables del browse **
CLEAR
GsMsgKey = "[F10] Salir   [PgUp] [PgDn] [Home] [End] [] [] Posicionar   [Del] Borra"
DO LIB_MTEC WITH 99
DO dBrowse
**

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE BROWedit

** OJO >> se supone que solo existe crear **
m.nrodoc = SPACE(LEN(GDOC.nrodoc))
m.fchubc = DATE()
STORE 0 TO XfGastos,XfInteres,XfTotalG,XfImport
cGenProt = "N"
**
*         1         2         3         4         5         6         7
*123456789012345678901234567890123456789012345678901234567890123456789012345678
*    NUMERO   CLIENTE       N O M B R E              FCH.PROT.      IMPORTE    "
* 1234567890 12345678 123456789012345678901234567890 99/99/9999 S/.999,999,999.99
*
DO lib_mtec WITH 7
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,Escape_)
	DO CASE
		CASE i = 1
			SELE gdoc
			SET ORDER TO GDOC05
			@ LinAct,2  GET m.nrodoc PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF INLIST(UltTecla,Escape_)
				SET ORDER TO GDOC07
				LOOP
			ENDIF
			IF UltTecla = F8
				IF !ccbbusca("0004")
					SET ORDER TO GDOC07
					LOOP
				ENDIF
				m.nrodoc = NroDoc
			ENDIF
			@ LinAct,2 SAY m.nrodoc
			LsNroDoc=m.nrodoc
			SEEK m.flgest+m.tpodoc+m.coddoc+m.nrodoc
			IF !FOUND()
				LlProtestar = FOUND()
				SEEK 'C'+m.tpodoc+m.coddoc+m.nrodoc
				IF FOUND()
					IF FlgUbc='B' AND FlgSit='D' && Es una letra en descuento
					*SET STEP ON 
						** Ubicamos la Nota Bancaria de la cancelación 
						SELECT VTOS
						SET ORDER TO VTOS03
						SEEK m.CodDoc+m.NroDoc+'N/BC'
						IF FOUND() && Cancelada con una Nota Bancaria
						&& DESDE AQUI AIR 20.06.08 RENV
					*	IF FOUND()
								   SELECT GDOC
								   SET ORDER TO GDOC01
								   SEEK "CARGO"+VTOS->codref+VTOS->nroref
								   IF !RLOCK()
								      SELE VTOS
								      RETURN 
								   ENDIF
								   LfImpDoc = VTOS->Import
								   IF CodMon <> vtos->codmon
								      IF vtos->codmon = 1
										 IF Vtos.TpoCmb>0									      
									         LfImpDoc = LfImpDoc / vtos->tpocmb
								         ELSE
									         LfImpDoc = 0
								         ENDIF
								      ELSE
								         LfImpDoc = LfImpDoc * vtos->tpocmb
								      ENDIF
								   ENDIF
								   REPLACE SdoDoc WITH SdoDoc + LfImpDoc
								   IF SdoDoc <= 0.01
								      REPLACE FlgEst WITH 'C'
								   ELSE
								      REPLACE FlgEst WITH 'P'
								   ENDIF
								  *REPLACE FlgSit WITH ' '
								   UNLOCK
								   SELECT GDOC
								   SET ORDER TO GDOC05
								   * * * *
								   SELECT VTOS
								   DELETE
								   UNLOCK
								   *** Buscamos asiento de renovacion
									LsRenov=VTOS.CodDoc+VTOS.NroDoc				
									SELECT TASG				
								   	SEEK LsRenov
								   	IF FOUND() AND FlgCtb
								   		LsNroMes= TASG.NroMes
								   		LsCodOpe= TASG.CodOpe
								   		LsNroAst= TASG.NroAst
										*!*	IF 	VTOS.CodDoc='RENV'
										*!*	LsNroDoc=PADR(SUBSTR(m.NroDoc,1,AT('-',m.NroDoc)-1),LEN(m.NroDoc))
										*!*	ENDIF
										SELECT VMOV
										SEEK LsNroMes+LsCodOpe+LsNroAst
										IF !FOUND()	
											RETURN
										ELSE
											=RLOCK()
										ENDIF
								   		SELECT RMOV
								   		SEEK LsNroMes+LsCodOpe+LsNroAst
								   		SET STEP ON 
										SCAN WHILE NroMes+CodOPe+NroAst=LsNroMes+LsCodOpe+LsNroAst
											IF CodDoc+NroDoc=m.CodDoc+LsNroDoc
												*** Borrar conta *** 
												=RLOCK()
												DELETE
												UNLOCK
												IF ! CodOpe = "9"
													DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
												ELSE
													DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
												ENDIF
												SELECT RMOV
												REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
												nImpNac = Import
												nImpUsa = ImpUsa
												IF RMOV.TpoMov = 'D'
													REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
													REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
												ELSE
													REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
													REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
												ENDIF
											ENDIF
								   		ENDSCAN
								   	ENDIF
								   	SELECT vmov
								   	UNLOCK								   	
						   			LlProtestar=.t.		
						*!*	ENDIF			
						&& HASTA AQUI AIR 20.06.08 RENV
							*!*	LsNotaBanc=VTOS.CodDoc+VTOS.NroDoc				
							*!*	SELECT TASG				
							*!*	SEEK LsNotaBanc
							*!*	IF FOUND() 
							*!*		LsCtaNota=CodCta
							*!*		IF !FlgCtb && Capturamos datos del asiento contable
							*!*			LsAsiento=NroMes+CodOpe+NroAst
							*!*			*** Solo revertimos la letra contra la cuenta de caja ***
							*!*			**	123  D Importe cancelado en la N/BC
							*!*			**  104  H Importe cancelado en la N/BC
							*!*			***
							*!*			SET STEP ON 
							*!*		ENDIF
							*!*		LlProtestar=.t.		
							*!*	ENDIF
						 ELSE
						*** Buscamos cancelacion por renovacion **	
							SEEK m.CodDoc+m.NroDoc+'RENV'
							IF FOUND()
								   SELECT GDOC
								   SET ORDER TO GDOC01
								   SEEK "CARGO"+VTOS->codref+VTOS->nroref
								   IF !RLOCK()
								      SELE VTOS
								      RETURN 
								   ENDIF
								   LfImpDoc = VTOS->Import
								   IF CodMon <> vtos->codmon
								      IF vtos->codmon = 1
										 IF Vtos.TpoCmb>0									      
									         LfImpDoc = LfImpDoc / vtos->tpocmb
								         ELSE
									         LfImpDoc = 0
								         ENDIF
								      ELSE
								         LfImpDoc = LfImpDoc * vtos->tpocmb
								      ENDIF
								   ENDIF
								   REPLACE SdoDoc WITH SdoDoc + LfImpDoc
								   IF SdoDoc <= 0.01
								      REPLACE FlgEst WITH 'C'
								   ELSE
								      REPLACE FlgEst WITH 'P'
								   ENDIF
								  *REPLACE FlgSit WITH ' '
								   UNLOCK
								   SELECT GDOC
								   SET ORDER TO GDOC05
								   * * * *
								   SELECT VTOS
								   DELETE
								   UNLOCK
								   *** Buscamos asiento de renovacion
									LsRenov=VTOS.CodDoc+VTOS.NroDoc				
									SELECT TASG				
								   	SEEK LsRenov
								   	IF FOUND() AND FlgCtb
								   		LsNroMes= TASG.NroMes
								   		LsCodOpe= TASG.CodOpe
								   		LsNroAst= TASG.NroAst
										IF 	VTOS.CodDoc='RENV'
											LsNroDoc=PADR(SUBSTR(m.NroDoc,1,AT('-',m.NroDoc)-1),LEN(m.NroDoc))
										ENDIF
										SELECT VMOV
										SEEK LsNroMes+LsCodOpe+LsNroAst
										IF !FOUND()	
											RETURN
										ELSE
											=RLOCK()
										ENDIF
								   		SELECT RMOV
								   		SEEK LsNroMes+LsCodOpe+LsNroAst
										SCAN	WHILE NroMes+CodOPe+NroAst=LsNroMes+LsCodOpe+LsNroAst
											IF CodDoc+NroDoc=m.CodDoc+LsNroDoc
												*** Borrar conta *** 
												=RLOCK()
												DELETE
												UNLOCK
												IF ! CodOpe = "9"
													DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
												ELSE
													DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
												ENDIF
												SELECT RMOV
												REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
												nImpNac = Import
												nImpUsa = ImpUsa
												IF RMOV.TpoMov = 'D'
													REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
													REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
												ELSE
													REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
													REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
												ENDIF
											ENDIF
								   		ENDSCAN
								   	ENDIF
								   	SELECT vmov
								   	UNLOCK								   	
						   			LlProtestar=.t.		
							ENDIF																				
						ENDIF				
*!*							FLUSH in vmov
*!*						   	FLUSH in rmov
*!*						   	FLUSH in vtos
*!*						   	FLUSH in gdoc			   
					ENDIF
					SELECT GDOC
					IF !LlProtestar
						GsMsgErr = 'El Documento se encuentra cancelado'					
						DO lib_merr WITH 99
						SET ORDER TO GDOC07
						LOOP
					ENDIF
				ENDIF
				IF !LlProtestar
					SELECT GDOC
					DO lib_merr WITH 6
					SET ORDER TO GDOC07
					LOOP
				ENDIF
			ENDIF
			STORE RECNO() TO iNumReg
			** veamos si esta repetido **
			SET ORDER TO GDOC07
			SEEK m.flgest+m.flgsit+m.tpodoc+m.coddoc+m.nrodoc
			IF FOUND()
				GsMsgErr = [ Letra ya esta Protestada ]
				DO lib_merr WITH 6
				LOOP
			ENDIF
			**
			GO iNumReg
			@ LinAct,13 SAY CodCli+' '+LEFT(auxi.NomAux,30)
			@ LinAct,61 SAY IIF(CodMon=1,'S/.','US$')
			@ LinAct,64 SAY ImpTot PICT "999,999,999.99"
			m.CodMon=CodMon
			XfImport = GDOC.ImpTot
		CASE i = 2
			@ LinAct,50 GET m.fchubc
			READ
			M.FCHDOC=M.FCHUBC
			IF SEEK(DTOS(M.FchDoc),"TCMB")
				M.TpoCmb = TCMB->OfiVta
			ELSE
				M.TPOCMB = GDOC.TPOCMB
			ENDIF
			_MES=MONTH(M.FCHDOC)
			UltTecla = LASTKEY()
			@ LinAct,50 SAY m.fchubc
		CASE i = 3
		    *** Aqui ingresamos los gastos e intereses por el protesto ***
		    DO ccbnban2.spr
		    ***--------------------------------------------------------*** 
			UltTecla = Enter
	ENDCASE
	IF i = 3 .AND. UltTecla = Enter
		EXIT
	ENDIF
	i = IIF(UltTecla=Izquierda,i-1,i+1)
	i = IIF(i<1,1,i)
	i = IIF(i>3,3,i)
ENDDO
GsMsgKey = "[F10] Salir   [PgUp] [PgDn] [Home] [End] [] [] Posicionar   [Del] Borra"
DO LIB_MTEC WITH 99

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE BROWborr

IF !RLOCK()
	RETURN
ENDIF
REPLACE GDOC.flgsit WITH GDOC.FlgSitA
REPLACE GDOC.flgubc WITH GDOC.FlgUbcA
REPLACE GDOC.flgest WITH "P"
IF FlgPrt
	IF !ctb_aper(GDOC.FchUbc)
	ELSE
		DO xANUL_CTB	
	ENDIF
ENDIF
SELE GDOC
REPLACE GDOC.FlgPrt WITH .F.
UNLOCK

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE BROWgrab

IF !RLOCK()
	RETURN
ENDIF									&& VETT 27-JULIO-2000
REPLACE GDOC.flgsitA WITH GDOC.Flgsit   && Guardamos estado anterior
REPLACE GDOC.flgUbcA WITH GDOC.FlgUbc   && Guardamos estado anterior
XcFlgSit = GDOC.FlgSit
XcFlgUbc = GDOC.FlgUbc
REPLACE GDOC.flgsit WITH m.flgsit
REPLACE GDOC.fchubc WITH m.fchubc
REPLACE GDOC.FLGEST WITH M.FLGEST
REPLACE GDOC.fchubc WITH M.FchUBC
REPLACE GDOC.ImpInt WITH XfInteres
REPLACE GDOC.ImpGas WITH XfGastos
IF !FlgPrt
	cGenProt = Aviso(12,[ Protesto V lido (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
	IF cGenProt = "S"
		** Rutina que apertura las base contables a usar y ademas **
		** verifica que el mes contables NO este cerrado **
		IF !ctb_aper(m.FchUbc)
		ELSE
			DO XAct_ctb
		ENDIF
	ENDIF
ENDIF
UNLOCK IN "GDOC"
RETURN

******************
PROCEDURE xAct_Ctb
******************
** Valores variables inicializados como STRING
PRIVATE XdFchPed,GlInterface,XsCodDiv,TsCodDiv1,XcAfecto
PRIVATE XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
PRIVATE XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = ''

dimension vcodcta(10)
STORE {} TO XdFchPed
STORE '' TO XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores variables inicializados como NUMERO
STORE 0 TO NumCta
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN .F.
ENDIF
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = GOSVRCBD.NROAST()
SELECT VMOV
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
	DO LIB_MERR WITH 11
	RETURN .F.
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN .F.          && No pudo bloquear registro
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FLGEST WITH "R"
SELECT OPER
GOSVRCBD.NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH m.FchUbc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH m.CodMon
REPLACE VMOV->TpoCmb  WITH m.TpoCmb
REPLACE VMOV->NotAst  WITH [LETRA PROTESTADA ]+GDOC.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
***************
DO GenDetCtb     && Generamos el detalle contable VETT 27/07/2000
***************
RETURN .T.

************************************************************************ FIN *
* Grabamos detalle
************************************************************************ FIN *
PROCEDURE GenDetCtb

IF XcFlgSit = [D]        && Descuento
	=SEEK(GDOC.CodCta,"CTAS")
	XsCodCta = CTAS.CtaDes       && << OJO >>
ELSE                    && Cobranza
	=SEEK(GDOC.CodCta,"CTAS")
	XsCodCta = CTAS.CtaCob
ENDIF
* * * * * * * * * * * * * * * * * *
XiNroItm = 0
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = IIF(XcFlgSit=[D],VMOV.TpoCmb,GDOC.TpoCmb)
XsGloDoc = AUXI->NomAux
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
** Grabamos las cuentas de detalle **
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XsCodAux = SPACE(LEN(RMOV.CodAux))
IF CTAS.PidAux=[S]
	XsClfAux = CTAS.ClfAux
	XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    &&     Revertimos la cuenta  de Descuento o Cobranza
XfImport = GDOC.Imptot
IF XiCodMon = 1
	XfImpNac = XfImport
	IF XfTpoCmb > 0
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
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = GDOC.NroDoc
ENDIF
XsChkTpoDoc = XsCodDoc  && Revisar esto
IF CTAS.AftDcb = [S] .AND. XcFlgSit = [D]
	DO DIFCMB   IN CCB_CTB
ELSE
	DO MovbVeri IN CCB_CTB
ENDIF
* Actualizamos la cuenta de letras y la regresamos a cartera *
=SEEK(GDOC.CodDoc,"TDOC")
XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta)) && TDOC.CodCta
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = GDOC.CodMon
XfTpoCmb = GDOC.TpoCmb
XsGloDoc = AUXI->NomAux
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
XsCodRef = SPACE(LEN(RMOV.CodRef))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XsCodAux = SPACE(LEN(RMOV.CodAux))
=SEEK(XsCodCta,"CTAS")
IF CTAS.PidAux=[S]
	XsClfAux = CTAS.ClfAux
	XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [D]    && << OJO <<
XfImport = GDOC.Imptot
IF XiCodMon = 1
	XfImpNAc = XfImport
	IF XfTpoCmb > 0
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
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = GDOC.NroDoc
ENDIF
XsChkTpoDoc = XsCodDoc  && Revisar esto
DO MovbVeri IN CCB_CTB


** Ahora actualizamos la cuenta de banco y los intereses en Nota de debito
** Ubicamos la planilla del banco donde se envio a Cobranza o Descuento


* 1ero  (Cuenta del Banco) *
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = "Gastos protesto de letra"+GDOC.NroDoc
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
XsCodCta = GDOC.CodCta
XsCodRef = SPACE(LEN(RMOV.CodRef))
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XcTpoMov = [H]    && << OJO <<
XfImport = XfGastos
IF XiCodMon = 1
	XfImpNac = XfImport
	IF XfTpoCmb > 0
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
XsNroRef = SPACE(LEN(RMOV.NroDoc))
DO MovbVeri IN CCB_CTB
** Gastos por protesto **
********************************
*** Gastos a la 67           ***
********************************
=SEEK(GDOC.CodCta,"CTAS")
XsCodCta = CTAS.CtaGas
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XcTpoMov = [D]    && << OJO <<
XfImport = XfGastos
XfTpoCmb = VMOV.TpoCmb
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
XsNroRef = SPACE(LEN(RMOV.NroDoc))
DO MovbVeri IN CCB_CTB

** ACTUALIZAMOS CAMPOS DE AFECTACION CONTABLE **
SELE GDOC
REPLACE GDOC.MesPrt WITH XsNroMes
REPLACE GDOC.OpePrt WITH XsCodOpe
REPLACE GDOC.AstPrt WITH XsNroAst
REPLACE GDOC.FlgPrt WITH .T.
RETURN
************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB
XsNroMes = GDOC.MesPrt
XsCodOpe = GDOC.OpePrt
XsNroAst = GDOC.AstPrt
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
**DELETE   && Por Ahora
DO ctb_cier
RETURN
************************************************************************ FIN *
********************************
PROCEDURE Extorna_LETR_Descuento
********************************






