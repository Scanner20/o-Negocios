**************************************************************************
*  Nombre    : CcbLtrPr.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Protesto de Letras                                        *
*  Par metros: Ninguno                                                   *
*  Creaci¢n     : 01/01/2000                                             *
*  Actualizaci¢n: 27/07/2000											 *
*				  Genera asiento de protesto y controla flgsit anterior	 *
**************************************************************************

*******************************
* Aperturando Archivos a usar *
*******************************
CLOSE DATA
USE CCBTBDOC IN 0 ORDER BDOC01 ALIAS TDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF

**
USE ADMMTCMB IN 0 ORDER TCMB01 ALIAS TCMB
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS AUXI
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE CBDMCTAS IN 0 ORDER CTAS01 ALIAS CTAS
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE ccbrgdoc IN 0 ORDER GDOC07 ALIAS GDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
** RELACIONES A USAR **
SELE gdoc
SET RELA TO XsClfAux+CodCli INTO auxi
XSCODOPE=[021]   && Protesto de letras

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
CLOSE DATA

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
Ancho    = 80
Tborde   = Simple
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = "    NUMERO   CLIENTE       N O M B R E             FCH.PROT.        IMPORTE    "
E2 = ""
E3 = ""

*         1         2         3         4         5         6         7
*123456789012345678901234567890123456789012345678901234567890123456789012345678
*    NUMERO   CLIENTE       N O M B R E               FCH.PROT.       IMPORTE    "
* 1234567890 12345 123456789012345678901234567890123 99/99/9999 S/.999,999,999.99
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
DO WHILE ! INLIST(UltTecla,Escape)
	DO CASE
		CASE i = 1
			SELE gdoc
			SET ORDER TO GDOC05
			@ LinAct,2  GET m.nrodoc PICT "@!"
			READ
			UltTecla = LASTKEY()
			IF INLIST(UltTecla,Escape)
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
			SEEK m.flgest+m.tpodoc+m.coddoc+m.nrodoc
			IF !FOUND()
				DO lib_merr WITH 6
				SET ORDER TO GDOC07
				LOOP
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
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN .F.
ENDIF
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = NROAST()
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
=NROAST(XsNroAst)
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
XiNroItm = 1
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
	IF XfTpoCmb > 0
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = 0
	ENDIF
ELSE
	XfImpUsa = XfImport
	XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = GDOC.NroDoc
ENDIF
IF CTAS.AftDcb = [S] .AND. XcFlgSit = [D]
	DO DIFCMB   IN CCB_CTB
ELSE
	DO MovbVeri IN ccb_ctb
ENDIF
* Actualizamos la cuenta de letras y la regresamos a cartera *
=SEEK(GDOC.CodDoc,"TDOC")
XsCodCta = TDOC.CodCta
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
	IF XfTpoCmb > 0
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = 0
	ENDIF
ELSE
	XfImpUsa = XfImport
	XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = GDOC.NroDoc
ENDIF
DO MovbVeri IN ccb_ctb

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
	IF XfTpoCmb > 0
		XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
	ELSE
		XfImpUsa = 0
	ENDIF
ELSE
	XfImpUsa = XfImport
	XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
DO MovbVeri IN ccb_ctb
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
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
DO MovbVeri IN ccb_ctb

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
DO MOVBorra IN ccb_ctb
SELE VMOV
**DELETE   && Por Ahora
DO ctb_cier
RETURN
************************************************************************ FIN *
