**************************************************************************
*  Nombre    : CcbCjAp1.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Aprobacion del Canje por Letras                           *
*  Par metros:            : Ninguno                                      *
*  Creaci¢n     : 06/05/94                                               *
*  Actualizaci¢n: VETT 13/03/95 Generacion de asiento contable           *
*				  VETT 02/09/2003 Adaptacion para VFP 7					 *
**************************************************************************
IF !verifyvar('GsLetCje','C')
	return
ENDIF

DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO fondo WITH 'Aprobaciones',Goentorno.user.login,GsNomCia,GsFecha

DO xPanta
**********************************
* Aperturando Archivos a usar    *
**********************************
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC04','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LODATADM.ABRIRTABLA('ABRIR','CCBNTASG','TASG','TASG03','')
LODATADM.ABRIRTABLA('ABRIR','CCBNRASG','RASG','RASG01','')
LODATADM.ABRIRTABLA('ABRIR','CJATPROV','PROV','PROV01','')
LODATADM.ABRIRTABLA('ABRIR','CBDTCNFG','CNFG','CNFG01','')
LoDatAdm.abrirtabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
RELEASE LoDatAdm

SELECT cnfg
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
   DO LIB_MERR WITH 99
   DO CLOSE_FILE IN CCB_CCBAsign
   SYS(2700,1)
   RETURN
ENDIF
XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
** VETT:Tope Maximo y Minimo para aplicar Dif.Cambio  - 2015/05/04 12:26:15 ** 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('Los valores máximos para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 ' Modificar en la opcion "Configuración de Diferencia de Cambio" en el Menu de Configuración.',0+64,'Aviso importante')
	 
ENDIF
USE


** RELACIONES A USAR **
SELE TASG
SET RELA TO GsClfCli+CodCli INTO AUXI
**********************************
* Inicializando Variables a usar *
**********************************
** variables de la cabecera **
SELECT TASG
m.coddoc = "CANJ"
m.nrodoc = SPACE(LEN(NroDoc))
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
XsCodOpe =  GsLetCje  && 012  && << OJO <<
** Logica Principal **
xCodDoc = m.CodDoc
GsMsgKey = "[Esc] Salir    [Enter] Registrar    [F8] Consulta "
DO LIB_MTEC WITH 99
UltTecla = 0
DO WHILE .T.
   *RESTORE SCREEN FROM LsScreen
   DO xLlave
   IF INLIST(UltTecla,escape_)
      EXIT
   ENDIF
   DO xPoner
   DO xGraba
   UNLOCK ALL
ENDDO
CLEAR 
CLEAR MACROS
DO close_file IN ccb_ccbasign
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
************************************************************************ EOP()
* Pintado de Pantalla
***************************************************************************
PROCEDURE xPanta

*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678
*1    Canje #      :                                     Fecha : 99/99/99
*2    Cod.Cliente  :
*3    Observaciones:
*4    Moneda       :                               Tipo Cambio : 99,999.9999
*5                  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6                  ³ Tpo.Doc.   Nro.Documento          Importe  ³
*7                  ³--------------------------------------------³
*8                  ³  1234       12345678901     999,999,999.99 ³
*9                  ³                                            ³
*0                  ³                                            ³
*1                  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*2    ------------------------>  Importe Total :  999,999,999.99
*3    Cant. Letras : ###  Letra Inicial : 123456     Plazo : 123 dias
*4                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*5                ³ No.Letra   Emision   Vencto.     Imp.Letra. ³
*6                ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*7                ³ 1234567890 99/99/99 99/99/99 999,999,999.99 ³
*8                ³                                             ³
*9                ³                                             ³
*0                ³                                             ³
*1                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*2    ------------------------> Importe Total :  999,999,999.99
*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678

CLEAR
IF _windows OR _mac
	@  0,0 TO 23,100  PANEL
ELSE
	@  0,0 TO 23,79  PANEL
endif
Titulo = "** APROBACION DEL CANJE POR LETRAS **"
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Canje #      :                                     Fecha :  "
@  2,5  SAY "Cod.Cliente  :                                              "
@  3,5  SAY "Observaciones:                                              "
@  4,5  SAY "Moneda       :                               Tipo Cambio :  "
@  5,5  SAY "              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,5  SAY "              ³ Tpo.Doc.   Nro.Documento          Importe  ³"
@  7,5  SAY "              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  8,5  SAY "              ³                                            ³"
@  9,5  SAY "              ³                                            ³"
@ 10,5  SAY "              ³                                            ³"
@ 11,5  SAY "              ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 12,5  SAY "------------------------>  Importe Total :                  "
@ 13,5  SAY "Cant. Letras :      Letra Inicial :            Plazo :      "
@ 14,5  SAY "            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ "
@ 15,5  SAY "            ³ No.Letra   Emision   Vencto.     Imp.Letra. ³ "
@ 16,5  SAY "            ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ "
@ 17,5  SAY "            ³                                             ³ "
@ 18,5  SAY "            ³                                             ³ "
@ 19,5  SAY "            ³                                             ³ "
@ 20,5  SAY "            ³                                             ³ "
@ 21,5  SAY "            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ "
@ 22,5  SAY "------------------------>  Importe Total :                  "

@  6,20 SAY " Tpo.Doc.   Nro.Documento          Importe  " COLOR SCHEME 7
@ 15,18 SAY " No.Letra   Emision   Vencto.     Imp.Letra. " COLOR SCHEME 7

RETURN
********************************************************************** FIN
* Llave de Acceso
******************************************************************************
PROCEDURE xLlave

m.nrodoc = SPACE(LEN(TASG->NroDoc))
**
GsMsgKey = "[Esc] Salir   [F8]  Consultar"
DO lib_mtec WITH 99
**
SELE TASG
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_,Enter)
   DO CASE
      CASE i = 1
         @ 1,20 GET m.NroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_)
            LOOP
         ENDIF
         
         IF UltTecla = F8
            IF !ccbbusca("0012")
               LOOP
            ENDIF
            m.NroDoc = TASG->NroDoc
	        KEYBOARD '{ENTER}' 
         ENDIF
         @ 1,20 SAY m.NroDoc
         SEEK m.CodDoc+"P"+m.NroDoc
         IF !FOUND()
            DO lib_merr WITH 6
            UltTecla = 0
            LOOP
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
RETURN
************************************************************************ FIN *
* Poner Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

@ 1,20 SAY NroDoc
@ 1,64 SAY FchDoc
@ 2,20 SAY CodCli
@ 2,33 SAY AUXI->NomAux
@ 3,20 SAY GloDoc SIZE 1,40 PICT "@!"
@ 4,20 SAY IIF(CodMon=1,'S/.','US$')
@ 4,64 SAY TpoCmb PICT "99,999.9999"
** Pintamos el Browse de Documentos origen **
** Definimos variables a usar en el Browse **
PRIVATE SelLin,EdiLin,BrrLin,InsLin,GrbLin,EscLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
SelLin   = ""
EscLin   = ""
EdiLin   = ""
BrrLin   = ""
InsLin   = ""
GrbLin   = ""
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
*
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8
PRIVATE MVprgF9,NClave,VClave,LinReg,Titulo,VTitle,HTitle
PRIVATE Yo,Xo,Largo,Ancho,TBorde
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
NClave   = "CodDoc+NroDoc"
VClave   = TASG->CodDoc+TASG->NroDoc
Titulo   = ""
VTitle   = 0
HTitle   = 0
Yo       = 7
Xo       = 19
Largo    = 5
Ancho    = 46
Tborde   = Nulo
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = ""
E2 = ""
E3 = ""
LinReg   = [' '+CodRef+'      '+NroRef+'     '+TRANS(Import,'999,999,999.99')]
**
SELE RASG
DO dbrowse
** Pintamos el Browse de Documento Letras **
SELE GDOC
SET ORDER TO GDOC03
NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
VClave   = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
Yo       = 16
Xo       = 17
Largo    = 6
Ancho    = 47
LinReg   = [NroDoc+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+TRANS(ImpTot,'999,999,999.99')+' ']
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
DO dbrowse
SET ORDER TO GDOC04
SELE TASG

RETURN
************************************************************************ FIN *
* Actualizacion de Saldos por Aprobacion de Canje por Letras
******************************************************************************
PROCEDURE xGraba

** Pedir Fecha de Aprobacion **
@ 11,24 CLEAR TO 13,56
@ 11,24 TO 13,56 DOUBLE COLOR SCHEME 7
XdFchDoc = TASG->FchDoc
UltTecla = 0
DO WHILE !INLIST(UltTecla,escape_,Enter)
   @ 12,25 SAY "Fecha de Aprobacion :" GET XdFchDoc
   READ
   UltTecla = LASTKEY()
ENDDO
IF UltTecla = escape_
   RETURN
ENDIF
** Rutina que apertura las base contables a usar y ademas **
** verifica que el mes contables NO este cerrado **
IF !ctb_aper(XdFchDoc)
   RETURN
ENDIF
cResp = [S]
cResp = Aviso(12,[ Letras Aprobadas (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
IF cResp = "N"
   RETURN
ENDIF
**
WAIT "GRABANDO" NOWAIT WINDOW
** grabamos cabecera **
SELECT TASG
m.CodRef = CodRef
m.NroRef = NroRef
IF !RLOCK()
   RETURN
ENDIF

REPLACE FchDoc WITH XdFchDoc     && Fecha de la Aprobacion
REPLACE FlgEst WITH [E]          && Aprobado
** actualizamos detalles **
SELE RASG
SEEK TASG->CodDoc+TASG->NroDoc
DO WHILE CodDoc+NroDoc = TASG->CodDoc+TASG->NroDoc .AND. !EOF()
   IF !RLOCK()
      LOOP
   ENDIF
   ** Bloqueamos Documentos **
   SELECT GDOC
   SET ORDER TO GDOC01
   SEEK "CARGO"+RASG->CodRef+RASG->NroRef
   IF !RLOCK()
      SELE RASG
      LOOP
   ENDIF
   ** Trasladamos canje al VTOS **
   SELE VTOS
   APPEND BLANK
   IF !RLOCK()
      SELE RASG
      LOOP
   ENDIF
   REPLACE CodDoc WITH RASG->CodDoc
   REPLACE NroDoc WITH RASG->NroDoc
   REPLACE TpoDoc WITH RASG->TpoDoc
   REPLACE FchDoc WITH XdFchDoc     && Con la Fecha de la Aprobacion
   REPLACE CodCli WITH RASG->CodCli
   REPLACE CodMon WITH RASG->CodMon
   REPLACE TpoCmb WITH RASG->TpoCmb
   REPLACE TpoRef WITH RASG->TpoRef
   REPLACE CodRef WITH RASG->CodRef
   REPLACE NroRef WITH RASG->NroRef
   REPLACE Import WITH RASG->Import
   UNLOCK
   * * * *
   SELE GDOC
   LfImpDoc = RASG->Import
   IF CodMon <> TASG->CodMon
      IF TASG->codmon = 1
         LfImpDoc = LfImpDoc/TASG->tpocmb
      ELSE
         LfImpDoc = LfImpDoc*TASG->tpocmb
      ENDIF
   ENDIF
   REPLACE SdoDoc WITH SdoDoc - LfImpDoc
   IF SdoDoc <= 0.01
      REPLACE FlgEst WITH 'C'
   ELSE
      REPLACE FlgEst WITH 'P'
   ENDIF
   REPLACE FchAct WITH DATE()
   REPLACE FlgSit WITH 'X'
   UNLOCK
   *
   SELE RASG
   UNLOCK
   SKIP
ENDDO
**
SELE GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
DO WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
   IF FlgEst # [T]      && NO esta en TRAMITE
      SKIP
      LOOP
   ENDIF
   IF !RLOCK()
      LOOP
   ENDIF
   REPLACE FchDoc WITH XdFchDoc     && Fecha de Aprobacion
   REPLACE FlgEst WITH 'P'          && Pendiente de Pago
   REPLACE FlgSit WITH "A"          && Letra aceptada
   SELE GDOC
   UNLOCK
   SKIP
ENDDO
** ACTUALIZACION CONTABLE **
 DO xACT_CTB  && actu. contab ..................
* * * * * * * * * * * * * * *
SELECT TASG

RETURN
************************************************************************** FIN
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************
PROCEDURE xACT_CTB

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
   RETURN
ENDIF
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
replace vmov.fchdig  with date()
replace vmov.hordig  with time() 

SELECT OPER
GOSVRCBD.NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH TASG.FchDoc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH TASG.CodMon
REPLACE VMOV->TpoCmb  WITH TASG.TpoCmb
REPLACE VMOV->NotAst  WITH TASG.CodDoc+[ ]+TASG.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
** ACTUALIZAR DATOS DE CABECERA **
REPLACE TASG.NroMes WITH XsNroMes
REPLACE TASG.CodOpe WITH XsCodOpe
REPLACE TASG.NroAst WITH XsNroAst
REPLACE TASG.FlgCtb WITH .T.
* * * * * * * * * * * * * * * * * *
* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = SPACE(LEN(RMOV.GloDoc))
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
nImpNac  = 0
nImpUsa  = 0
** Grabamos las cuentas de detalle **
*!*	SET STEP ON 
SELE GDOC
SET ORDER TO GDOC03
SEEK [Canje]+TASG.CodDoc+TASG.NroDoc+[CARGO]+[LETR]
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = [Canje]+TASG.CodDoc+TASG.NroDoc+[CARGO]+[LETR]
	=SEEK(CodDoc,"TDOC")
	XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	=SEEK(XsCodCta,"CTAS")
	XsClfAux = []
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	XsGloDoc = SPACE(LEN(RMOV.GloDoc))
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		=SEEK(XsClfAux+XsCodAux,"AUXI")
		XsGloDoc = AUXI.NomAux
	ENDIF
	XdFchDoc = GDOC.FchDoc
	XdFchVto = GDOC.FchVto
	XsCodDoc = IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'') && GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = []
	XiCodMon = GDOC.CodMon
	XfTpoCmb = GDOC.TpoCmb
	XcTpoMov = [D]
	XfImport = GDOC.ImpTot
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
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
	XiNroItm = XiNroItm + 1
	* * * *
	SELE GDOC
ENDSCAN
SELE GDOC
SET ORDER TO GDOC04
* * * *
SELE VTOS
SET ORDER TO VTOS01
SEEK TASG.CodDoc+TASG.NroDoc
SCAN WHILE CodDoc+NroDoc = TASG.CodDoc+TASG.NroDoc
   =SEEK(VTOS.CodRef,"TDOC")
   XsCodCta = PADR(IIF(VTOS.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   =SEEK(XsCodCta,"CTAS")
   XsClfAux = []
   XsGloDoc = SPACE(LEN(RMOV.GloDoc))
   IF CTAS.PIDAUX=[S]
      XsClfAux = CTAS->ClfAux
      XsCodAux = VTOS.CodCli
      =SEEK(XsClfAux+XsCodAux,"AUXI")
      XsGloDoc = AUXI.NOMAUX
   ENDIF
   XdFchDoc = VTOS.FchDoc
   XdFchVto = {}
   XsChkTpoDoc = VTOS.CodRef
   XsCodDoc = IIF(SEEK(GsCodSed+VTOS.CodRef+'001','DOCM'),DOCM.TpoDocSN,'') && VTOS.CodRef
   XsNroDoc = VTOS.NroRef
   XsNroRef = []
   XiCodMon = VTOS.CodMon
   XfTpoCmb = VTOS.TpoCmb
   XcTpoMov = [H]
   XfImport = VTOS.Import
   iImport  = XfImport
   IF xsnrodoc='0200007103'
**   	SET STEP on
   endif
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
   IF CTAS.AftDcb="S"        && VETT 11/07/2000
   	   DO DifCmb IN Ccb_Ctb  && Le agregamos la diferencia de cambio VETT 11/07/2000	
   ELSE
		GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
   ENDIF
   XiNroItm = XiNroItm + 1
   * * * *
   SELE VTOS
ENDSCAN
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT

IF PROGRAM(1)='CCB_CCBCJLT1' 
ELSE
	DO imprvouc IN CBd_DiarioGeneral 
ENDIF
DO ctb_cier
RETURN
************************************************************************ FIN *
