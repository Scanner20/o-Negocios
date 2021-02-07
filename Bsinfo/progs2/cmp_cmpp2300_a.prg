***********************************************
* Programa     : cmpp2300.prg                 *
* Sistema      : Logística                    *
* Autor		   : VETT                         *
* Proposito    : Ingreso de Ordenes de Compra *
* Creacion     : 26/10/2006                   *
***********************************************
*!*	Aperturamos Archivos
PARAMETERS 	PcTpoO_C,PcTipo,PsCodDoN,PsCodDoI,PsNroMes
IF PARAMETERS()=0
	PlGeneraOC_Req = .F.
ELSE
	IF VARTYPE(PcTpoO_C)='C' AND VARTYPE(PcTipo)='C' AND VARTYPE(PsCodDoN)='C' AND VARTYPE(PsCodDoI)='C' AND VARTYPE(PsNroMes)='C' ;
	    AND PcTpoO_C$'PSCK' AND PcTipo$' NI' AND (PsCodDoN='O/CN' OR PsCodDoN='O/CI') AND (VAL(PsNroMes)>=1 OR VAL(PsNroMes)<=12)
		PlGeneraOC_Req = .T.
	ELSE
		=MESSAGEBOX('Error en el tipo de datos de los parametros. Verifique en la llamada al procedimiento anterior '+PROGRAM(1),16,'Atencion / Warning')
		PlGeneraOC_Req = .F.
		return
	ENDIF
ENDIF

goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','PROV','AUXI01','')
goentorno.open_dbf1('ABRIR','CMPCO_CG','VORD','CO_C01','')
goentorno.open_dbf1('ABRIR','CMPDO_CG','RORD','DO_C01','')
goentorno.open_dbf1('ABRIR','ALMCATAL','CATA','CATA02','')
goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
goentorno.open_dbf1('ABRIR','CMPTDOCM','DOCM','DOCM01','')
goentorno.open_dbf1('ABRIR','ALMTGSIS','GSIS','TABL01','')
goentorno.open_dbf1('ABRIR','CMPCREQU','VREQ','CREQ03','') 
goentorno.open_dbf1('ABRIR','ALMEQUNI','EQUN','EQUN01','')
goentorno.open_dbf1('ABRIR','ALMTDIVF','DIVF','DIVF01','')   
goentorno.open_dbf1('ABRIR','FLCJTBFP','TBFP','FMAPGO','')
GoEntorno.open_dbf1('COMPRAS','CMPREQUC','REUC','REUC01',.F.)
GoEntorno.open_dbf1('ABRIR','PAISES','PAIS','PAIS01','')
GoEntorno.open_dbf1('ABRIR','DISTRITOS','DIST','DIST04','')

PUBLIC XsNomUser
XsNomUser = GoEntorno.User.Nombre

IF FILE(GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM')
	RESTORE FROM GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM' ADDITIVE
ENDIF
*!*	Relaciones a usar
SELE RORD
IF !UPPER(SET("Relation"))='USUARIO+NROREQ INTO VREQ' 
	SET RELA TO Usuario+NroReq INTO VREQ ADDIT
ENDIF	
SELE VORD
IF !UPPER(SET("Relation"))='GSCLFPRO+CODAUX INTO PROV' 
	SET RELATION TO GsClfPro+CodAux INTO PROV ADDIT
ENDIF	
SET MEMOWIDTH TO 55
*!*	Variables a usar
PUBLIC m.Crear,m.NroReq,m.TpoReq,m.CodMat,m.DesMat,m.UndCmp,m.CanPed,m.PreUni,m.ImpLin,m.NroOrd,GsClfReq,m.nroitm
PUBLIC XsFmaPgo, XsPagAde, XiTasa
PUBLIC XsNroOrd,XdFchOrd,XsCodAux,XsNroCot,XdFchO_C,XiFmaPgo
PUBLIC XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto
PUBLIC XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr
PUBLIC XfPorDto1,XfPorDto2,XfPorDto3,XfImpDto1,XfImpDto2,XfImpDto3
PUBLIC XsGloDoc,XcFlgEst,LsFmaPgo,XsRucAux,XsNomAux,XsDirAux,XsTlfAux
PRIVATE XdFchEnt,XsMarcas,XcTpoCmp,XsCodCmp,CFGPasswD,XsLugEnt,XsPrueba,XsLugEntIn,XsHorAlm,XsLugPro
PUBLIC XsCodUas,XsNroReq,XcTipo,XsUsuario,XcTpoO_C,XsRefere,XsTmpent,XcCia
PUBLIC xctpobie,XsTpoReq,XsCodMat,XsDesMat,XsUndCmp,XfCanPed,XfFacEqu
PUBLIC XcTpoFle,XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpCif,XfImpOtr
PUBLIC XfImpHan,XfImpIns,XfImpAdm,XfImpFob,XfImpGen,XfTpoCmb,XiDiaEnt
PUBLIC XfImpAdu,XfImpMtt,XsNroOr2,XsCotImp,XsMaquina
PUBLIC XfImpExw,XfImpAfs,XfImpSec,XfImpPic,XfImpCfr,XfPorSeg,XfImpDes,XfImpSbr,XfImpDer,XfImpIpm
PUBLIC XfImpIgv,XfImpDum,XfImpInt,XfImpTda,XfImpTra,XfImpAlm,XfImpCol,XfImpTog,XfImpDoc
PUBLIC XfImpOpe,XfImpQui,XfImpMov,XfImpBul,XfImpCob,XfImpPct,XfImpCom,XfImpTga,XfImpVer
PUBLIC XfImpComCo,XfImpSwf,XfImpComRe,XfImpComAc,XfImpTr1,XfImptr2,XfImpOtrBa,XfImpTgb,XfImpGma
PUBLIC XfImpCga,XfImpAfi,XfImpTdi,XfImpDevCon,XfImpOtrGa,XfImpTgal,XsEntBan
PUBLIC XTipImp,Xprecosteo
PUBLIC XsNivCom,XsViaTra,xsLugOri,XsEntBan
PUBLIC XdFchEta , m.NroOrd,XsCodDoN,XsCodDoI,XsMesCon
XsFmapgo = SPACE(04)
XsPagAde = [ ]
XiTasa   = 0
XfTpoCmb = 0.0000
STORE [] TO XsNroOrd,XdFchOrd,XsCodAux,XsNroCot,XdFchO_C,XiFmaPgo,XsUndCmp
STORE [] TO XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto,XsTpoReq,XsCodMat,XfCanPed
STORE [] TO XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr,XsDesMat,XfFacEqu
STORE [] TO XsGloDoc,XcFlgEst,LsFmaPgo,XsRucAux,XsNomAux,XsDirAux,XsTlfAux
STORE [] TO XdFchEnt,XsMarcas,XcTpoCmp,XsCodCmp,XsLugEnt,XsPrueba,XsLugEntIn,XsHorAlm,XsLugPro
STORE [] TO XfPorDto1,XfPorDto2,XfPorDto3,XfImpDto1,XfImpDto2,XfImpDto3
STORE [] TO XsCodUas,XsNroReq,XsCodRef,XsNroOr2,XsRefere,XsTmpent,XsCotImp,XsMaquina

CFGPasswD=spac(8)
IF VARTYPE(CFGADMIGV)='U'
	XfPorIgv = 19
ELSE
	XfPorIgv = CFGADMIGV
ENDIF
IF VARTYPE(CFGGloI3)='U'
	XsGloDoc=''
ELSE
	XsGloDoc=CFGGloI3
ENDIF
IF VARTYPE(CfgCorr_U_LOG)<>'L'
	CfgCorr_U_LOG = .F.
ENDIF
IF CfgCorr_U_LOG = .T.
	SELECT DOCM
	SET ORDER TO DOCM02  && Indice por CodDoc and Corr_U=.T.
ENDIF

STORE 0 TO XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpCif,XfImpOtr
STORE 0 TO XfImpHan,XfImpIns,XfImpAdm,XfImpFob,XfImpGen
STORE 0 TO XfImpAdu,XfImpMtt
STORE 0 TO XfImpExw,XfImpAfs,XfImpSec,XfImpPic,XfImpCfr,XfPorSeg,XfImpDes,XfImpSbr,XfImpDer,XfImpIpm
STORE 0 TO XfImpIgv,XfImpDum,XfImpInt,XfImpTda,XfImpTra,XfImpAlm,XfImpCol,XfImpTog,XfImpDoc
STORE 0 TO XfImpQui,XfImpMov,XfImpBul,XfImpCob,XfImpPct,XfImpCom,XfImpTga,XfImpVer
STORE 20 TO XfImpOpe
STORE 0 TO XfImpComCo,XfImpSwf,XfImpComRe,XfImpComAc,XfImpTr1,XfImptr2,XfImpOtrBa,XfImpTgb,XfImpGma
STORE 0 TO XfImpCga,XfImpAfi,XfImpTdi,XfImpDevCon,XfImpOtrGa,XfImpTgal
STORE [] TO XsNivCom,XsViaTra,xsLugOri,XsEntBan,XsTipDes,XsTipCar,XsTipCon
STORE {  ,  ,    } to XdFchEta
STORE [N] TO XcTipo
STORE [A] TO XcCia &&Aromas 26-03-07
STORE [C] TO XcTpoO_C
STORE [I] TO XcTpoBie
STORE [A] TO XcTipFle
STORE [FOB] TO XTipImp
STORE 2 TO XPrecosteo 
XsUsuario = SPACE(LEN(VREQ.Usuario))
XsCodRef  = SPACE(LEN(VORD.CodRef))
XsNroOr2  = SPACE(LEN(VORD.NroOr2))
XsCotImp  = SPACE(LEN(VORD.CotImp))
XsMaquina = SPACE(LEN(VORD.Maquina))
Xslugent  = SPACE(LEN(VORD.LugEnt))
XsLugEntIn = SPACE(LEN(vord.lugentin))
XsLugPro = SPACE(LEN(vord.lugpro))
XsHorAlm = SPACE(LEN(vord.HorAlm))
XsPrueba  = 2
XsPagAde = [N]
XdFchEnt  = DATE()
STORE {  ,  ,    } TO XDFchEmb,XdFchLle
XnDprev = 0
XnFpgFlt = 1
*!*	Variables del Browse
PRIVATE AsNroReq,AcTpoReq
PRIVATE AcTpoBie
PRIVATE AsCodMat,AsUndCmp,AfFacEqu,AfPreUni,AfCanPed,AfImpLin,AiNumReg,GiTotItm
PRIVATE AfPreFob
PRIVATE AiRegDel,GiTotDel
CIMAXELE = 100
DIMENSION AsNroReq(CIMAXELE)
DIMENSION AcTpoReq(CIMAXELE)
DIMENSION AcTpoBie(CIMAXELE)
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsMarca (CIMAXELE)
DIMENSION AsUndCmp(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AsPeso  (CIMAXELE)
DIMENSION AfPreUni(CIMAXELE)
DIMENSION AfPreFob(CIMAXELE)
DIMENSION AfPorDto(CIMAXELE)
DIMENSION AfCanPed(CIMAXELE)
DIMENSION AfImpLin(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)
DIMENSION AiRegDel(CIMAXELE)
GiTotItm = 0
GiTotDel = 0
*!*	Control correlativo multiusuario
STORE '' TO  m.NroOrd,XsCodDoN,XsCodDoI,XsMesCon
XiDiaEnt = 0
m.NroOrd = []
XsCodDoN = [O/CN]
XsCodDoI = [O/CI]
XsMesCon = 'Mes'+SUBS(DTOC(GdFecha),4,2)
*!*	Ejecutamos el Formulario
PUBLIC LoOrdenCompra as Object
IF PlGeneraOC_Req
	XcTpoO_C	=	PcTpoO_C
	XcTipo		=	PcTipo
	XsCodDoN	=	PsCodDoN
	XsCodDoI	=   PsCodDoI	 
	XsNroMes	= 	PsNroMes
	DO FORM log_frmtra03 WITH PcTpoO_C,PcTipo,PsCodDoN,PsCodDoI,PsNroMes 
	XsNroMes    = TRANSFORM(_MES,"@L ##")
ELSE
	DO FORM log_frmtra03 
ENDIF
RELEASE LoOrdenCompra
RETURN

******************
* Llave de Datos *
******************
PROCEDURE xLlave
*!*	Buscando Correlativo
IF !SEEK(XsCodDoN,"DOCM") AND RLOCK("DOCM") OR  !SEEK(XsCodDoI,"DOCM") AND RLOCK("DOCM")
	WAIT "No existe correlativo" NOWAIT WINDOW
	RETURN
ENDIF
UNLOCK IN "DOCM"
SELE VORD
LOCATE FOR NroOrd= XsNroOrd AND TpoO_C=XcTpoO_C
RETURN

************************************************************************ FIN()
* Pedir Informacion O/C Nacional
******************************************************************************
PROCEDURE xDatoNac

SAVE SCREEN TO LsPan02
DO xPieNac
DO xRegenera
UltTecla = 0
PRIVATE u
u = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE ! INLIST(UltTecla,escape_,CtrlW)
   DO CASE
      CASE u = 1
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,15 GET XfImpFle     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,15 SAY XfImpFle     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 2
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,38 GET XfImpOtr     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,38 SAY XfImpOtr     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 3
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,54 GET XfPorIgv     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,54 SAY XfPorIgv     PICT "99999,999.99"
         POP KEY
         DO xRegenera
   ENDCASE
   IF u = 3  .AND. UltTecla = Enter
      EXIT
   ENDIF
   u = IIF(INLIST(UltTecla,Arriba,BackTab),u-1,u+1)
   u = IIF(u < 1, 1,u)
   u = IIF(u > 3, 3,u)
ENDDO
IF INLIST(UltTecla,Arriba,escape_,BackTab)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF

RETURN
************************************************************************ FIN()
* Pedir Informacion O/C Importaci¢n
******************************************************************************
PROCEDURE xDatoImp

SAVE SCREEN TO LsPan02
DO xPieImp
DO xRegenera
UltTecla = 0
PRIVATE u
u = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE ! INLIST(UltTecla,escape_,CtrlW)
   DO CASE
      CASE u = 1
         VecOpc(1) = [A]
         VecOpc(2) = [M]
         XcTipFle = ELIGE(XcTipFle,19,11,2)
         UltTecla = LAST()
         @ 19,11 SAY XcTipfle
      CASE u = 2
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,14 GET XfImpFle     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,14 SAY XfImpFle     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 3
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,14 GET XfImpSeg     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,14 SAY XfImpSeg     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 4
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 18,39 GET XfImpIns     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 18,39 SAY XfImpIns     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,39 GET XfImpHan     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,39 SAY XfImpHan     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 6
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,39 GET XfImpAdv     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,39 SAY XfImpAdv     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 7
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 21,39 GET XfImpMtt     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 21,39 SAY XfImpMtt     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 8
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 18,67 GET XfImpAdm     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 18,67 SAY XfImpAdm     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 9
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,67 GET XfImpAdu     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,67 SAY XfImpAdu     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 10
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,67 GET XfImpOtr     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,67 SAY XfImpOtr     PICT "99999,999.99"
         POP KEY
         DO xRegenera
   ENDCASE
   IF u = 10  .AND. UltTecla = Enter
      EXIT
   ENDIF
   u = IIF(INLIST(UltTecla,Arriba,BackTab),u-1,u+1)
   u = IIF(u < 1, 1,u)
   u = IIF(u >10,10,u)
ENDDO
IF INLIST(UltTecla,Arriba,escape_,BackTab)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
RETURN
********************
* Cargar variables *
********************
PROCEDURE xMover
SELE VORD
XcTipo = tpocmp&&LEFT(NroOrd,1)
XdFchOrd = FchOrd
XsCodAux = CodAux
XsRucAux = RucAux
XsDirAux = DirAux
XsTlfAux = TlfAux
XsNroCot = NroCot
XiDiaEnt = DiaEnt
XsCndPgo = LEFT(CNDPGO,LEN(GSIS.CODIGO))
XsFmaPgo = LEFT(CNDPGO,LEN(GSIS.CODIGO))
XsPagAde = PagAde
XiTasa = Tasa
XsNroCot = NroCot
XsNroOr2 = NroOr2
XsCotImp = CotImp
XsMaquina = Maquina
XsRefere = Refere
XsTmpEnt = TmpEnt
XsUsuario= Usuario
XsCodRef = CodRef
XcTpoO_C = TpoO_C
XcTpoBie = IIF(TpoBie=[ ],[I],TpoBie)
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XfPorIgv = PorIgv
XfPorDto = PorDto
XfImpBto = ImpBto
XfImpDto = ImpDto
XfImpInt = ImpInt
XfImpAdm = ImpAdm
XfImpIgv = ImpIgv
XfImpNet = ImpNet
XsGloDoc = GloDoc
XdFchEnt = FchEnt
XsLugEnt = LugEnt
XsLugEntIn = lugentin 
XsLugPro = lugPro
XsHorAlm = HorAlm
XsPrueba = VAL(Prueba)
XsMarcas = Marcas
XcFlgEst = FlgEst
XcTpoCmp = TpoCmp
XsNivCom = NivCom
XsViaTra = ViaTra
xsLugOri = LugOri
XsEntBan = EntBan
XdFchEta = FchEta
XdFchEmb = FchEmb
*!*	Para Importación
XfImpFob = ImpFob
XcTipFle = TipFle
XfImpFle = ImpFle
XfImpSeg = ImpSeg
XfImpCif = ImpCif
XfImpAdv = ImpAdv
XfImpAdm = ImpAdm
XfImpHan = ImpHan
XfImpPap = ImpPap
XfImpAdu = ImpAdu
XfImpMtt = ImpMtt
XfImpIns = ImpIns
XfImpOtr = ImpOtr
XnFpgFlt = FpgFlt
XdFchLle = FchLle
XdFchEmb = FchEmb
XnDPrev = NDPrev
XTipImp = TipImp
xprecosteo = precosteo
XfImpExw = ImpExw
XfImpAfs = ImpAfs
XfImpSec = ImpSec
XfImpPic = ImpPic
XfImpCfr = ImpCfr
XfPorSeg = PorSeg
XfImpDes = ImpDes
XfImpSbr = ImpSbr
XfImpDer = ImpDer
XfImpIpm = ImpIpm
XfImpIgv = ImpIgv
XfImpDum = ImpDum
XfImpInt = ImpInt
XfImpTda = ImpTda
XfImpTra = ImpTra
XfImpAlm = ImpAlm
XfImpCol = ImpCol
XfImpTog = ImpTog
XfImpDoc = ImpDoc
XfImpOpe = ImpOpe
XfImpQui = ImpQui
XfImpMov = ImpMov
XfImpBul = ImpBul
XfImpCob = ImpCob
XfImpPct = ImpPct
XfImpCom = ImpCom
XfImpTga = ImpTga
XfImpVer = ImpVer
XfImpComCo = ImpComCo
XfImpSwf = ImpSwf
XfImpComRe = ImpComRe
XfImpComAc = ImpComAc
XfImpTr1 = ImpTr1
XfImptr2 = ImpTr2
XfImpOtrBa = ImpOtrBa
XfImpTgb = ImpTgb
XfImpGma = ImpGma
XfImpCga = ImpCga
XfImpAfi = ImpAfi
XfImpTdi = ImpTdi
XfImpDevCon = ImpDevCon
XfImpOtrGa = ImpOtrGa
XfImpTgal = ImpTgal

XsTipCar = TipCar
XsTipDes = TipDes
XsTipDes = TipCon

SELE VORD
RETURN
*************************
* Inicializamos Variables
*************************
PROCEDURE xInvar
SELE VORD
XsTpoReq = SPACE(LEN(RORD.TpoReq))
XsCodMat = SPACE(LEN(RORD.CodMat))
XsDesMat = SPACE(LEN(RORD.DesMat))
XsUndCmp = SPACE(LEN(RORD.UndCmp))
XfFacEqu = 1.0000
XfCanPed = 0
XfPorDto = 0
XfPorDto1= 0
XfPorDto2= 0
XfPorDto3= 0
XfImpBto = 0
XfImpDto = 0
XfImpDto1= 0
XfImpDto2= 0
XfImpDto3= 0
XfImpInt = 0
XfImpAdm = 0
XfImpNet = 0
XsUsuario= SPACE(LEN(GsUsuario))
XsCodRef = SPACE(LEN(CodRef))
STORE 0 TO XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpOtr,XfImpCif
STORE 0 TO XfImpHan,XfImpIns,XfImpAdm,XfImpFob
STORE 0 TO XfImpAdu,XfImpMtt
STORE 0 TO XfImpExw,XfImpAfs,XfImpSec,XfImpPic,XfImpCfr,XfPorSeg,XfImpDes,XfImpSbr,XfImpDer,XfImpIpm
STORE 0 TO XfImpIgv,XfImpDum,XfImpInt,XfImpTda,XfImpTra,XfImpAlm,XfImpCol,XfImpTog,XfImpDoc
STORE 0 TO XfImpQui,XfImpMov,XfImpBul,XfImpCob,XfImpPct,XfImpCom,XfImpTga,XfImpVer
STORE 20 TO XfImpOpe
STORE 0 TO XfImpComCo,XfImpSwf,XfImpComRe,XfImpComAc,XfImpTr1,XfImptr2,XfImpOtrBa,XfImpTgb,XfImpGma
STORE 0 TO XfImpCga,XfImpAfi,XfImpTdi,XfImpDevCon,XfImpOtrGa,XfImpTgal
STORE [] TO XsNivCom,XsViaTra,xsLugOri,XsEntBan,XsTipCar,XsTipDes,XsTipCon
STORE {  ,  ,    } TO XdFchEta,XdFchEmb
RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

SELE VORD
@  1,15 SAY NroOrd PICT "@R !-999999"
*@  2,42 SAY IIF(TpoO_C=[S],[Servicio],[Compra  ])
DO CASE
    CASE  TpoO_C = [C]
        @ 2,42 SAY [Compra    ] 
    CASE TpoO_C = [S]
        @ 2,42 SAY [Servicio  ]
    OTHERWISE
        @ 2,42 SAY [Cotización]
ENDCASE  
 VecOpc(1) = "Compra  "
 VecOpc(2) = "Servicio"
 VecOpc(3) = "Kotización"

=Elige(TpoO_C,2,42,3,.t.)

@  1,65 SAY FchOrd	PICT "RD DD/MM/AAAA"
@  2,15 SAY NroOr2
@  2,65 SAY RucAux
@  3,15 SAY CodAux PICT "@!"
@  3,28 SAY NomAux
@  4,15 SAY DirAux
@  4,67 SAY TlfAux PICT "@S12"
@  6,19 SAY NroCot PICT "@!"

IF LEFT(NroOrd,1)#[N]
  *@  6,0  SAY "Ý  No Cotizacion :             No Cot.Imp :             Moneda :               Ý"
   @  6,0  SAY "Ý  No.Cotizacion :             No Cot.Imp :                       Moneda :        Ý"
   @  6,42 SAY CotImp PICT '@(S13)'
ELSE
  *@  6,0  SAY "Ý  No Cotizacion :                                      Moneda :               Ý"
   @  6,0  SAY "Ý Sol.Cotizacion :             Refere.:                           Moneda :        Ý"
*   @  6,42 SAY SPAC(8)
ENDIF
@  6,42 SAY TRIM(Maquina)+' ' + IIF(SEEK('MQ'+Maquina,'GSIS'),LEFT(GSIS.NOMbre,20),SPACE(20))
*@  7,19 SAY CndPgo PICT "@!S25"
*@  6,65 SAY IIF(CodMon=1,'S/.','US$')
*@  7,65 SAY DiaEnt PICT "999"
@  6,75 SAY IIF(CodMon=1,'S/.','US$')
@  7,19 say Fmapgo
@  7,24 SAY CndPgo PICT "@!S40"
*!*	@  7,74 SAY tasa   PICT "99.99"
@  8,19 SAY DiaEnt PICT "999"
*!*	@  8,39 say iif(PagAde=[S],[S¡],[No])
@  9,19 SAY FchEnt PICT "RD DD/MM/AAAA"
*!*	@  9,46 SAY IIF(LugEnt='1','San Isidro', IIF(LugEnt='2','Vulcano   ','Ca¤ete    '))
@  9,46 SAY LugEnt+' ' + IIF(SEEK('LE'+LugEnt,'GSIS'),LEFT(GSIS.NOMbre,20),SPACE(20))
*!*	@  9,75 SAY IIF(Prueba='1', 'S¡', 'No')
IF LEFT(NroOrd,1)=[N]
   DO xPieNac
ELSE
   DO xPieImp
ENDIF
SELE RORD
SEEK VORD->NroOrd
NumLin = 13
@ 13,1 CLEAR TO 16,78
SCAN WHILE NroOrd=VORD->NroOrd .AND. NumLin <= 16
   @ NumLin,1  SAY NroReq PICT "@R 9999-999"
   @ NumLin,10 SAY TpoReq
   @ NumLin,12 SAY CodMat PICT "@!"
   @ NumLin,34 SAY UndCmp
   @ NumLin,38 SAY CanPed PICT "999,999.99"
   IF LEFT(NroOrd,1)=[N]
      @ NumLin,49 SAY PreUni PICT "999999.99999"
      @ NumLin,62 SAY PorDto PICT "999.99"
   ELSE
      @ NumLin,48 SAY PreFob PICT "99999.9999"
      @ NumLin,58 SAY PreUni PICT "99999.9999"
   ENDIF
   @ NumLin,69 SAY ImpLin PICT "9999999.99"
   NumLin = NumLin + 1
ENDSCAN
IF VORD->FlgEst=[A]
   NumLin = 13
   @ Numlin ,02 SAY []
   @ ROW()  ,02 SAY "          #      ##  #    #   #    #          #      #####     ######   "
   @ ROW()+1,02 SAY "        #####    # # #    #   #    #        #####    #    #    #    #   "
   @ ROW()+1,02 SAY "        #   #    #  ##    #####    ####     #   #    #####     ######   "
ENDIF
* *
SELE VORD
IF LEFT(NroOrd,1) = [N]  &&Nacional
   *@ 19,26 SAY ImpBto-ImpDto PICT "99999,999.99" COLOR SCHEME 7
   @ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                   Ý"
   @ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                   Ý"
   @ 21,0  SAY "Ý                                          Precio Venta Total :                   Ý"
   @ 19,15 SAY ImpBto  PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,38 SAY ImpDto  PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,65 SAY ImpBto-ImpDto PICT "99999,999.99" COLOR SCHEME 7
   @ 20,15 SAY ImpFle  PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,38 SAY ImpOtr  PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,54 SAY PorIgv  PICT "99.99"        COLOR SCHEME 7
   @ 20,65 SAY ImpIgv  PICT "99999,999.99" COLOR SCHEME 7
   @ 21,65 SAY ImpNet  PICT "99999,999.99" COLOR SCHEME 7
ELSE
   @ 18,14 say impfob        pict "99999,999.99" color scheme 7
   @ 19,11 say tipfle        pict "!" color scheme 7
   @ 19,14 say impfle        pict "99999,999.99" color scheme 7
   @ 20,14 say impseg        pict "99999,999.99" color scheme 7
   @ 21,14 say impcif        pict "99999,999.99" color scheme 7
   @ 18,39 say impins        pict "99999,999.99" color scheme 7
   @ 19,39 say imphan        pict "99999,999.99" color scheme 7
   @ 20,39 say impadv        pict "99999,999.99" color scheme 7
   @ 21,39 say impMtt        pict "99999,999.99" color scheme 7
   @ 18,67 say impadm        pict "99999,999.99" color scheme 7
   @ 19,67 say impadu        pict "99999,999.99" color scheme 7
   @ 20,67 say impotr        pict "99999,999.99" color scheme 7
   @ 21,67 SAY ImpNet        PICT "99999,999.99" COLOR SCHEME 7
ENDIF

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar
SET STEP ON 
SELE VORD
IF FlgEst = 'A'
	IF MESSAGEBOX("Desea Borrar el registro por completo ?",32+4,'**** ATENCION ****')=6
		IF !RLOCK()
			=MESSAGEBOX("Registro Bloqueado por otro usuario",0, 'AVISO!!!')
			RETURN
		ENDIF
		DELETE
		UNLOCK
*!*			IF TpoO_C='C'
*!*				SELECT VREQ
*!*				SET ORDER TO CREQ03
*!*				IF SEEK(VORD.NroOrd,'VREQ','CREQ03')
*!*					IF RLOCK('VREQ')
*!*						REPL NroO_C WITH SPAC(LEN(XsNroOrd)) IN VREQ
*!*						REPL FchO_C WITH {} IN VREQ
*!*						UNLOCK IN VREQ
*!*					ENDIF
*!*				ENDIF
*!*			ENDIF
*!*			FLUSH IN VREQ
		FLUSH IN VORD

	ENDIF
	RETURN
ENDIF
IF FlgEst = 'C'
	GsMsgErr = [ O/C Completo. Ingresado a Almacen]
	MESSAGEBOX(GSMsgErr,0, 'Error!!!')
	*DO lib_merr WITH 99
	RETURN
ENDIF
IF !Modifica()
	GsMsgErr = [ O/C Parcialmente Atendida ]
	MESSAGEBOX(GSMsgErr,0, 'Error!!!')
	RETURN
ENDIF
SELECT VORD
IF ! RLOCK()
	RETURN
ENDIF
*!* Anulamos detalles
SELE RORD
*SEEK VORD->NroOrd
LOCATE FOR NroOrd= XsNroOrd AND TpoO_C=XcTpoO_C
DO WHILE NroOrd= XsNroOrd AND TpoO_C=XcTpoO_C .AND. ! EOF()
	IF ! RLOCK()
		LOOP
	ENDIF
	
*!*		*!* desactualiza Requerimiento
*!*		IF !EMPTY(RORD.NroReq)		
*!*			SELE VREQ
*!*			SET ORDER TO creq03 
*!*			*SEEK LEFT(RORD->Usuario,LEN(VREQ.Usuario))+RORD->NroReq
*!*			SEEK RORD->NroReq
*!*			IF FOUND()
*!*				IF F1_rlock(0)
*!*					REPLACE VREQ.CanPed WITH VREQ.CanPed - RORD->CanPed
*!*					IF CanPed <= 0
*!*						REPLACE VREQ->FlgEst WITH [P]    && Presupuestada Por Atender 
*!*					ELSE
*!*						REPLACE VREQ->FlgEst WITH [R]    && Con O/Compra
*!*					ENDIF
*!*					REPL NroO_C WITH SPAC(LEN(XsNroOrd))
*!*					REPL FchO_C WITH {}
*!*					IF (CanPed+CanDes) >= CanReq
*!*						REPLACE FlgLog WITH [H]
*!*					ELSE
*!*						REPLACE FlgLog WITH IIF(VREQ.FlgEst=[O], [H], [R])
*!*						REPLACE FlgHis WITH [R]
*!*					ENDIF
*!*				ENDIF
*!*			ENDIF 
*!*			UNLOCK IN VREQ
*!*		ENDIF
	*!*	Proceso que permite eliminar el precio grabado en el archivo hist¢rico
	*!*	DO Eli_precio && Fuera piojos 17/03/98
	DELETE
	UNLOCK
	LoOrdenCompra.act_requisicion(XsUsuario,NroReq,XsNroOrd,CanPed,'VREQ')
	SELECT RORD
	SKIP
ENDDO
SELE VORD
REPLACE FlgEst WITH [A]
UNLOCK
*!*	SKIP
FLUSH IN VREQ 
FLUSH IN RORD
RETURN
************************************************************************ FIN()
* Browse de Datos
****************************************************************************
PROCEDURE xBrowse

EscLin   = "xBline"
IF EMPTY(XsCodRef)
   EdiLin   = "xBedit1"
   InsLin   = "xBinse1"
ELSE
   EdiLin   = "xBedit2"
   InsLin   = "xBinse2"
ENDIF
BrrLin   = "xBborr"
PrgFin   = []
*
Yo       = 12
Xo       = 0
Largo    = 6
Ancho    = 83
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
DO aBrowse
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
DO lib_mtec WITH 0
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE xBline
PARAMETERS NumEle, NumLin

@ NumLin,1  SAY AsNroReq(NumEle) PICT "@R 9999999"
@ NumLin,10 SAY AcTpoReq(NumEle)
@ NumLin,12 SAY AsCodMat(NumEle) PICT "@!" 
@ NumLin,34 SAY AsUndCmp(NumEle)
@ NumLin,38 SAY AfCanPed(NumEle) PICT "999,999.99"
IF LEFT(XsNroOrd,1)=[N]
   @ NumLin,49 SAY AfPreUni(NumEle) PICT "999999.999"
   @ NumLin,62 SAY AfPorDto(NumEle) PICT "999.99"
ELSE
   @ NumLin,48 SAY AfPreFob(NumEle) PICT "9999999.99"
   @ NumLin,58 SAY AfPreUni(NumEle) PICT "9999999.99"
ENDIF
@ NumLin,70 SAY AfImpLin(NumEle) PICT "999999.99"
@ 18,3 say AsDesMat(NumEle) pict [@S55]
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit1
PARAMETERS NumEle, NumLin
SAVE SCREEN TO TMP
** NOTA >> solo se permite modificar mas no crear
IF AcTpoReq(NumEle) $ "R|N|A|S"  && Reposicion de Stock
   @ 18,01 CLEAR TO 21,78
  *@ 19,03 EDIT AsDesMat(NumEle) SIZE 1,45 DISABLE
  *@ 19,03 say AsDesMat(NumEle) pict [@S45]
   @ 18,03 say LEFT(AsDesMat(NumEle),45)
   @ 18,50 SAY AsMarca(NumEle)  PICT "@S15"
   IF AcTpoReq(NumEle) = [R]
      SELE CATA
      SET ORDER TO CATA02
      XfStkAct = 0
      XfVCtoMn = 0
      XfVCtoUs = 0
      XfPctoMn = 0
      XfPctoUS = 0
      SEEK AsCodMat(NumEle)
      SCAN WHILE CODMAT = AsCodMat(NumEle)
         XfStkAct = XfStkAct + StkAct
         *XfVCtoMn = XfVCtoMn + VCtoMn   && No se encuentra actualizado en linea
         *XfVCtoUs = XfVCtoUs + VCtoUs
      ENDSCAN
      IF XfStkAct <> 0
         *XfPctoMn =  XfVCtoMn / XfStkAct
         *XfPctoUS =  XfVCtoUS / XfStkAct
         XfPctoMn =  CATG->VCtoMn / XfStkAct
         XfPctoUS =  CATG->VCtoUS / XfStkAct
      ENDIF
      @ 20,3 SAY "Ultimo Precio de Compra : "
      @ 21,3 SAY "Precio Promedio Actual  : "
      IF XiCodMon = 1
         LfUltPre = ROUND(CATG->PULTMN * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoMn     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "S/."
         @ 21,29 SAY "S/."
      ELSE
         LfUltPre = ROUND(CATG->PULTUS * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoUS     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "US$"
         @ 21,29 SAY "US$"
      ENDIF
      @ 20,32 SAY LfUltPre PICT "@Z 999,999,999.99"
      @ 21,32 SAY LfPrcPmd PICT "999,999,999.99"
   ENDIF
ENDIF

PRIVATE i
i        = 1
UltTecla = 0
*
LsNroReq = AsNroReq(NumEle)
LcTpoReq = AcTpoReq(NumEle)
LsCodMat = AsCodMat(NumEle)
LsCodFam = LEFT(AsCodMat(NumEle),LEN(DIVF.CodFam))
LsCodMat1= RIGH(AsCodMat(NumEle),LEN(LsCodMat)-LEN(LsCodFam))
LsDesMat = left(AsDesMat(NumEle),60)
LsMarca  = AsMarca (NumEle)
LsUndCmp = AsUndCmp(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LsPeso   = AsPeso  (NumEle)
LfPreUni = AfPreUni(NumEle)
LfPreFob = AfPreFob(NumEle)
LfPorDto = AfPorDto(NumEle)
LfCanPed = AfCanPed(NumEle)
LfImpLin = AfImpLin(NumEle)
LiNumReg = AiNumReg(NumEle)
GsMsgKey = "[Izquierda] [Derecha] Mover   [Enter] Registra    [Esc] Cancela"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   i = IIF(LsNroReq#SPAC(LEN(LsNroReq)).AND.i<3,3,i)
   DO CASE
      CASE i = 1 AND XcTpoO_C=[C]  && AND .f.
         DO lib_mtec WITH 18
         SAVE SCREEN
         @ NumLin-1,24 CLEAR TO NumLin+2,50
         @ NumLin-1,24 TO NumLin+2,50 DOUBLE
         @ NumLin,25 GET LcTpoReq PICT "@*RVT \<Reposicion de Stock;\<Activos"
         READ
         UltTecla = LASTKEY()
         RESTORE SCREEN
         IF INLIST(UltTecla,escape_,Arriba,Abajo)
            LOOP
         ENDIF
         LcTpoReq = LEFT(LcTpoReq,1)
         IF ! LcTpoReq $ "RA"
            LOOP
         ENDIF
         @ NumLin,10 SAY LcTpoReq

      CASE i = 1 AND !XcTpoO_C=[C]
         LcTpoReq = [S]
         @ NumLin,10 SAY LcTpoReq
         UltTecla = Enter
      CASE i = 2
         @ NumLin,1  SAY LsNroReq PICT "@R 9999999"
         @ NumLin,10 SAY LcTpoReq PICT "@!"
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE DIVF
         SET CONFIRM OFF
         @ NumLin,12 GET LsCodFam PICT "@!"
         READ
         UltTecla = LASTKEY()
         SET CONFIRM ON
         IF UltTecla = Arriba
            UltTecla = 0
            i = i - 1
         ENDIF
         IF UltTecla = escape_
            EXIT
         ENDIF
         IF UltTecla = F8 && .OR. EMPTY(LsCodFam)
            IF !cmpbusca("DIVF")
               UltTecla = 0
               LOOP
            ENDIF
            LsCodFam = CodFam
         ENDIF
         @ NumLin,12 SAY LsCodFam
         IF !EMPTY(LsCodFam)
			 SELECT DIVF
	         SEEK GAClfDiv(2)+LsCodFam
	         IF !FOUND()
	            DO lib_merr WITH 6
	            LOOP
	         ENDIF
	         IF DIVF.TipFam # 1
	            GsMsgErr = [ Familia no corresponde a Productos de Insumos ]
	            DO lib_merr WITH 99
	            LOOP
	         ENDIF
	         * pedimos segunda parte del codigo *
	         SELE CATG
	         @ NumLin,12+LEN(LsCodFam) GET LsCodMat1 PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF UltTecla = Arriba
	            UltTecla = 0
	            loop
	         ENDIF
	         IF UltTecla = escape_
	            EXIT
	         ENDIF

	         LsCodMat = LsCodFam+LsCodMat1
	         IF UltTecla = F8 .OR. EMPTY(LsCodMat1)
	            XsCodFam = LsCodFam
	            IF !cmpbusca("CATGF")
	               UltTecla = 0
	               LOOP
	            ENDIF
	            LsCodMat = CodMat
	            LsCodMat1= SUBST(LsCodMat,LEN(DIVF->CodFam)+1)
	         ENDIF

         ELSE
	         SELE CATG
	         SET FILTER TO 
	         @ NumLin,12 GET LsCodMat PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF UltTecla = Arriba
	            UltTecla = 0
	            loop
	         ENDIF
	         IF UltTecla = escape_
	            EXIT
	         ENDIF

	         *LsCodMat = LsCodFam+LsCodMat1
	         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
	            XsCodFam = LsCodFam
	            IF !cmpbusca("MATEGE")
	               UltTecla = 0
	               LOOP
	            ENDIF
	            LsCodMat = CodMat
*!*		            LsCodMat1= SUBST(LsCodMat,LEN(DIVF->CodFam)+1)
*!*		            LsCodFam = LsCodMat1
				SET FILTER TO 
	         ENDIF
         
         ENDIF
         @ NumLin,12 SAY LsCodMat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
         IF LcTpoReq=[R]
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
         ENDIF
         LsDesMat = CATG->DesMat      &&+[ ]+CATG->Descrip
         LsMarca  = CATG->Marca
         LsUndCmp = IIF(EMPTY(CATG->UndCmp), CATG->UndStk, CATG->UndCmp)
         LfFacEqu = IIF(EMPTY(CATG->UndCmp), 1, CATG->FacEqu)
         XsUndStk = CATG->UndStk
         **=SEEK(LsCodMat, 'PCAT')
         LsPeso   = CATG->Peso
         @ NumLin,34 SAY LsUndCmp PICT "@!"
      CASE i = 3 .AND. LcTpoReq # [R]   && Codigo Libre
        *@ 19,3 EDIT LsDesMat SIZE 1,60 COLOR SCHEME 7
         @ 18,3 get LsDesMat pict [@S55]
         READ
         UltTecla = LASTKEY()
         @ 18,3 say LsDesMat pict [@S55]

      CASE i = 3  AND  LcTpoReq =[R]
	      @ 18,3 say LsDesMat pict [@S55]
         UltTecla = Enter

      CASE i = 4 .AND. LcTpoReq $ "RAS"
         =SEEK(LsCodMat,"CATG")
         SELE GSIS
         XsTabla = 'UD'
         XsUndStk = CATG->UndStk
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("TUND")
               UltTecla = 0
               LOOP
            ENDIF
            LsUndCmp = LEFT(GSIS->Codigo,3)
            LfFacEqu = 1
         ENDIF
         @ NumLin,34 SAY LsUndCmp
         IF LsUndCmp # AsUndCmp(NumEle)
            IF CATG->UndCmp == LsUndCmp .AND. ! EMPTY(LsUndCmp)
               LfFacEqu = CATG->FACEQU
            ELSE
               IF CATG->UndStk == LsUndCmp
                  LfFacEqu = 1
               ELSE
                  LfFacEqu = 1
                  SELE EQUN
                  SEEK XsUndStk+LsUndCmp
                  IF FOUND()
                     LfFacEqu = FACEQU
                  ENDIF
               ENDIF
            ENDIF
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 4   .AND. !LcTpoReq $ "RAS"
         LsUndCmp = AsUndCmp(NumEle)  &&  xsundstk
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp

         IF LsUndCmp # AsUndCmp(NumEle)
            SEEK XsUndStk+LsUndCmp
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            LfFacEqu = FACEQU
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,38 GET LfCanPed PICT "999,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,38 SAY LfCanPed PICT "999,999.99"
         POP KEY

      CASE i = 6
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 GET LfPreUni PICT "999999.99999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
         ELSE
            @ NumLin,48 GET LfPreFob PICT "99999.9999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         POP KEY

      CASE i = 7
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,62 GET LfPorDto PICT "999.99" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
            UltTecla = Enter
         ENDIF
      CASE i = 8
         IF LfCanPed > 0
            LfImport = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)
         ELSE
            LfImport = ROUND(LfPreUni,2)
         ENDIF
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,69 GET LfImport PICT "9999999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,69 SAY LfImport PICT "9999999.99"
         POP KEY
         *IF LfCanPed > 0
         *   LfPreUni = LfImport/(LfCanPed*(1-LfPorDto/100))
         *ELSE
         *   LfPreUni = LfImport
         *ENDIF
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         @ NumLin,69 SAY LfImport PICT "9999999.99"
   ENDCASE
   IF i = 8 .AND. inlist(UltTecla ,Enter,aBAJO,Derecha)
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab,Izquierda),i-1,i+1)
   i = IIF(i<1,2,i)
   i = IIF(i>8,8,i)
ENDDO
RESTORE SCREEN FROM TMP
IF !INLIST(UltTecla,escape_,Arriba,Abajo)
   LfImpBto = ROUND(LfCanPed*LfPreUni,2)   && Sin descuento
   LfImpLin = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)   && Con descuento
   AsNroReq(NumEle) = LsNroReq
   AcTpoReq(NumEle) = LcTpoReq
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsMarca (NumEle) = LsMarca
   AsUndCmp(NumEle) = LsUndCmp
   AfFacEqu(NumEle) = LfFacEqu
   AsPeso  (NumEle) = LsPeso
   AfPreUni(NumEle) = LfPreUni
   AfPreFob(NumEle) = LfPreFob
   AfPorDto(NumEle) = LfPorDto
   AfCanPed(NumEle) = LfCanPed
   AfImpLin(NumEle) = LfImpLin
   AiNumReg(NumEle) = LiNumReg
   DO xRegenera
ENDIF
* de Guia Remisi¢n el mensaje
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea cuando parte de REQU
******************************************************************************
PROCEDURE xBedit2
PARAMETERS NumEle, NumLin
=SEEK(XsNroOrd+XsUsuario+AsNroReq(NumEle),'RORD')
IF RORD.CanDes <> 0
   GsMsgErr = ' Item ya tiene ingreso al Almac‚n '
   DO lib_merr WITH 99
   UltTecla = Enter
   RETURN
ENDIF
SAVE SCREEN TO TMP
** NOTA >> solo se permite modificar mas no crear

IF AcTpoReq(NumEle) $ "R|A|S"  && Reposicion de Stock
   @ 19,01 CLEAR TO 21,78
  *@ 19,03 EDIT AsDesMat(NumEle) SIZE 1,45 DISABLE
   @ 18,03 SAY AsDesMat(NumEle) PICT [@S45]
   @ 18,50 SAY AsMarca(NumEle)  PICT "@S15"
   IF AcTpoReq(NumEle) = [R]
      SELE CATA
      SET ORDER TO CATA02
      XfStkAct = 0
      XfVCtoMn = 0
      XfVCtoUs = 0
      XfPctoMn = 0
      XfPctoUS = 0
      SEEK AsCodMat(NumEle)
      SCAN WHILE CODMAT = AsCodMat(NumEle)
         XfStkAct = XfStkAct + StkAct
         XfVCtoMn = XfVCtoMn + VCtoMn
         XfVCtoUs = XfVCtoUs + VCtoUs
      ENDSCAN
      IF XfStkAct <> 0
         XfPctoMn =  XfVCtoMn / XfStkAct
         XfPctoUS =  XfVCtoUS / XfStkAct
      ENDIF
      @ 20,3 SAY "Ultimo Precio de Compra : "
      @ 21,3 SAY "Precio Promedio Actual  : "
      IF XiCodMon = 1
         LfUltPre = ROUND(CATG->PULTMN * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoMn     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "S/."
         @ 21,29 SAY "S/."
      ELSE
         LfUltPre = ROUND(CATG->PULTUS * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoUS     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "US$"
         @ 21,29 SAY "US$"
      ENDIF
      @ 20,32 SAY LfUltPre PICT "@Z 999,999,999.99"
      @ 21,32 SAY LfPrcPmd PICT "999,999,999.99"
   ENDIF
ENDIF
i        = 1
UltTecla = 0
*
LsNroReq = AsNroReq(NumEle)
LcTpoReq = AcTpoReq(NumEle)
LsCodMat = AsCodMat(NumEle)
LsDesMat = AsDesMat(NumEle)
LsMarca  = AsMarca (NumEle)
LsUndCmp = AsUndCmp(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LsPeso   = AsPeso  (NumEle)
LfPreUni = AfPreUni(NumEle)
LfPreFob = AfPreFob(NumEle)
LfPorDto = AfPorDto(NumEle)
LfCanPed = AfCanPed(NumEle)
LfImpLin = AfImpLin(NumEle)
LiNumReg = AiNumReg(NumEle)
LlMod    = .T.
** Verificando si tiene atencion parcial ***
** no puede cambiar codigo               ***
SELE VREQ
SEEK LEFT(XsUsuario,LEN(VREQ.Usuario))+LsNroReq
IF (CanPed+CanDes)<>0 .AND. LfCanPed<>CanReq
   LlMod = .F.
ENDIF
** fin de chequeo
GsMsgKey = "[Izquierda] [Derecha] Mover   [Enter] Registra    [Esc] Cancela"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1  AND (LcTpoReq$[ASR] AND LlMod)
         SELE CATG
         xCodMat = LsCodMat
         @ NumLin,12 GET LsCodMat PICT GsFmat
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            EXIT
         ENDIF
         IF UltTecla = F8 OR LsCodMat<>xCodMat
            LsCodMat = xCodMat
            SELE EQUN
            SEEK xCodMat
            IF !cmpbusca("EQUIV")
               UltTecla = 0
               LOOP
            ENDIF
            LsCodMat = EQUN.CodEqu
            SET RELA TO
            SELE CATG
         ENDIF
         @ NumLin,12 SAY LsCodMat PICT GsFmat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
         IF LcTpoReq=[R]
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            LsDesMat = CATG->DesMat+[ ]+CATG->Descrip
            LsMarca  = CATG->Marca
         ENDIF
            LsUndCmp = CATG->UndStk
            LfFacEqu = IIF(CATG->FacEqu<>0,CATG->FacEqu,1)
            XsUndStk = CATG->UndStk
            **=SEEK(LsCodMat, 'PCAT')
            LsPeso = CATG->Peso
            @ NumLin,34 SAY LsUndCmp PICT "@!"
      CASE i = 1 .AND. !(LcTpoReq $ "ASR" AND Llmod)
         UltTecla = Enter
      CASE i = 2  AND  LcTpoReq $ [N|A|S]  && En Caso que quieran modificar
        *@ 19,3 EDIT LsDesMat SIZE 1,60 COLOR SCHEME 7
         @ 18,3 GET  LsDesMat PICT [@S55]
         READ
         UltTecla = LASTKEY()
        *@ 19,3 EDIT LsDesMat SIZE 1,60 DISABLE
         @ 18,3 SAY LsDesMat PICT [@S55]
      CASE i = 2  AND  !(LcTpoReq $ [N|A|S])
         UltTecla = Enter
      CASE i = 3 .AND. LcTpoReq = "R"
         =SEEK(LsCodMat,"CATG")
         XsUndStk = CATG->UndStk
         SELE EQUN
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp
         IF LsUndCmp # AsUndCmp(NumEle)
            IF CATG->UndCmp == LsUndCmp .AND. ! EMPTY(LsUndCmp)
               LfFacEqu = CATG->FACEQU
            ELSE
               IF CATG->UndStk == LsUndCmp
                  LfFacEqu = 1
               ELSE
                  SEEK XsUndStk+LsUndCmp
                  IF !FOUND()
                     DO lib_merr WITH 6
                     LOOP
                  ENDIF
                  LfFacEqu = FACEQU
               ENDIF
            ENDIF
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 3   .AND. LcTpoReq # "R"
         XsUndStk = AsUndCmp(NumEle)
         SELE EQUN
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp

         IF LsUndCmp # AsUndCmp(NumEle)
            SEEK XsUndStk+LsUndCmp
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            LfFacEqu = FACEQU
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 4
         @ NumLin,38 GET LfCanPed PICT "999,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,38 SAY LfCanPed PICT "999,999.99"
      CASE i = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 GET LfPreUni PICT "999999.99999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
         ELSE
            @ NumLin,48 GET LfPreFob PICT "99999.9999"
            READ
            UltTecla = LASTKEY()
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         POP KEY

      CASE i = 6
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,62 GET LfPorDto PICT "999.99" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
            UltTecla = Enter
         ENDIF

      CASE i = 7
         IF LfCanPed > 0
            LfImport = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)
         ELSE
            LfImport = ROUND(LfPreUni,2)
         ENDIF
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,69 GET LfImport PICT "9999999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,69 SAY LfImport PICT "9999999.99"
         POP KEY
         IF LfCanPed > 0
            LfPreUni = LfImport/(LfCanPed*(1-LfPorDto/100))
         ELSE
            LfPreUni = LfImport
         ENDIF
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         @ NumLin,69 SAY LfImport PICT "9999999.99"
      CASE i = 8
         *IF CATG->CodFle = SPAC(2) OR VAL(CATG->CodFle)=0
         *   SELE FLET
         *   IF !cmpbusca('FLET')
         *      UltTecla = 0
         *   ENDI
         *   XfCodFle = CodFle
         *   SELE CATG
         *   IF SEEK(LsCodMat,"CATG")
         *      IF RLOCK()
         *         REPL CodFle WITH XfCodFle
         *      ENDI
         *   ENDI
         *ENDI
         UltTecla = Enter
   ENDCASE
   IF i = 8 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>8,8,i)
ENDDO
RESTORE SCREEN FROM TMP
IF !INLIST(UltTecla,escape_,Arriba,Abajo)
   LfImpBto = ROUND(LfCanPed*LfPreUni,2)   && Sin descuento
   LfImpLin = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)   && Con descuento
   AsNroReq(NumEle) = LsNroReq
   AcTpoReq(NumEle) = LcTpoReq
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsMarca (NumEle) = LsMarca
   AsUndCmp(NumEle) = LsUndCmp
   AfFacEqu(NumEle) = LfFacEqu
   AsPeso  (NumEle) = LsPeso
   AfPreUni(NumEle) = LfPreUni
   AfPreFob(NumEle) = LfPreFob
   AfPorDto(NumEle) = LfPorDto
   AfCanPed(NumEle) = LfCanPed
   AfImpLin(NumEle) = LfImpLin
   AiNumReg(NumEle) = LiNumReg
   DO xRegenera
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove

SELE RORD
*
PRIVATE  i
i = 1
SEEK XsNroOrd
SCAN WHILE NroOrd=XsNroOrd .AND. i<=CIMAXELE
   AsNroReq(i) = NroReq
   AcTpoReq(i) = TpoReq
   *
   AcTpoBie(i) = iif(TpoBie=[ ],[I],TpoBie)
   *
   AsCodMat(i) = CodMat
   AsDesMat(i) = DesMat    && << OJO <<
   AsMarca (i) = []     && << OJO <<
   AsUndCmp(i) = UndCmp
   AfFacEqu(i) = FacEqu
   AsPeso  (i) = Peso
   AfPreUni(i) = PreUni
   AfPreFob(i) = PreFob
   AfPorDto(i) = PorDto
   AfCanPed(i) = CanPed
   AfImpLin(i) = ImpLin
   AiNumReg(i) = RECNO()
   i = i + 1
ENDSCAN
GiTotItm = i - 1
DO xRegenera

RETURN
**********************
* Grabar Informacion *
**********************
PROCEDURE xGraba
SELE VORD
IF m.Crear
	*!*	Actualizamos el correlativo
	XsNroOrd = GoCfgVta.Corr_O_C(XcTpoO_C,XcTipo,XsCodDoN,XsCodDoI,XsNroMes,_Ano,CfgCorr_U_LOG)
	SELE VORD
	APPEND BLANK
	IF ! RLOCK()
		RETURN
	ENDIF
	XsNroOrd = GoCfgVta.Corr_O_C(XcTpoO_C,XcTipo,XsCodDoN,XsCodDoI,XsNroMes,_Ano,CfgCorr_U_LOG)
	REPLACE VORD->NroOrd WITH XsNroOrd
	GoCfgVta.Corr_O_C(XcTpoO_C,XcTipo,XsCodDoN,XsCodDoI,XsNroMes,_Ano,CfgCorr_U_LOG,XsNroOrd)
ELSE
	IF ! RLOCK()
		RETURN
	ENDIF
ENDIF
REPLACE VORD->NroOr2  WITH XsNroOr2
REPLACE VORD->CotImp  WITH XsCotImp
REPLACE VORD->FchOrd  WITH XdFchOrd
REPLACE VORD->CodAux  WITH XsCodAux
REPLACE VORD->NomAux  WITH XsNomAux
REPLACE VORD->RucAux  WITH XsRucAux
REPLACE VORD->DirAux  WITH XsDirAux
REPLACE VORD->TlfAux  WITH XsTlfAux
REPLACE VORD->NroCot  WITH XsNroCot
*!*	IF m.Crear
*!*		REPLACE VORD->DiaEnt  WITH VAL(XiDiaEnt)
*!*	ELSE
REPLACE VORD->DiaEnt  WITH XiDiaEnt
*!*	ENDIF
REPLACE VORD->CndPgo  WITH XsFmaPgo
REPLACE VORD->Maquina WITH XsMaquina
REPLACE VORD->PagAde  WITH XsPagAde
REPLACE VORD->Tasa    WITH XiTasa
REPLACE VORD->CodMon  WITH XiCodMon
REPLACE VORD->PorIgv  WITH XfPorIgv
REPLACE VORD->GloDoc  WITH XsGloDoc
REPLACE VORD->FchEnt  WITH XdFchEnt
REPLACE VORD->LugEnt  WITH XsLugEnt
replace vord->LugEntIn WITH XsLugEntIn
replace vord->lugPro WITH XsLugPro
replace vord->HorAlm WITH XsHorAlm 
REPLACE VORD->FlgEst  WITH XcFlgEst
*REPLACE VORD->FlgEst  WITH "T"
*!*	REPLACE VORD->Prueba  WITH STR(XsPrueba,1)
REPLACE VORD->Hora    WITH time()
REPLACE VORD->Refere  WITH XsRefere
REPLACE VORD->TmpEnt  WITH XsTmpEnt
*!*	Cambiaron Tipo de generacion Ing.Federico
REPLACE VORD->Usuario WITH GsUsuario
REPLACE VORD->CodRef  WITH XsCodRef
REPLACE VORD->TpoO_C  WITH XcTpoO_C
REPLACE VORD->TpoCmp  WITH XcTipo
REPLACE vord->tpobie  WITH XcTpoBie
replace VORD.TpoCmb WITH XfTpoCmb
REPLACE vord->NivCom WITH XsNivCom
REPLACE vord->ViaTra with XsViaTra
REPLACE vord->LugOri with xsLugOri
REPLACE vord->EntBan with XsEntBan
REPLACE vord->FchEta with XdFchEta
REPLACE vord->FchEmb with XdFchEmb
REPLACE  VORD.TipDes WITH XsTipDes
REPLACE  VORD.TipCar WITH XsTipCar
REPLACE  VORD.TipCon WITH XsTipCon
*!*	Gastos de importación
REPLACE VORD->TipFle with XcTipFle
REPLACE VORD->ImpSeg with XfImpSeg
REPLACE VORD->ImpCif with XfImpCif
REPLACE VORD->ImpAdv with XfImpAdv
REPLACE VORD->ImpAdm with XfImpAdm
REPLACE VORD->ImpHan with XfImpHan
REPLACE VORD->ImpPap with XfImpPap
REPLACE VORD->ImpMtt with XfImpMtt
REPLACE VORD->ImpIns with XfImpIns
REPLACE VORD->ImpOtr with XfImpOtr
REPLACE VORD->FpgFlt with XnFpgFlt
REPLACE VORD->ImpFob  WITH XfImpFob
REPLACE VORD->ImpFle  WITH XfImpFle
REPLACE VORD->ImpAdu  WITH XfImpAdu
REPLACE VORD->Status  WITH [1]
REPLACE VORD->precosteo  WITH xPRecosteo &&AMAA 07-03-07
REPLACE VORD->tipimp  WITH xTipImp &&AMAA 10-03-07
REPLACE VORD->ImpExw WITH xfImpExw
replace VORD->ImpAfs WITH XfImpAfs
REPLACE VORD->ImpSec with XfImpSec
REPLACE VORD->ImpPic with XfImpPic
REPLACE VORD->ImpCfr with XfImpCfr
REPLACE VORD->PorSeg with XfPorSeg
REPLACE VORD->ImpDes with XfImpDes
REPLACE VORD->ImpSbr with XfImpSbr
REPLACE VORD->ImpDer with XfImpDer
REPLACE VORD->ImpIpm with XfImpIpm
REPLACE VORD->ImpIgv with XfImpIgv
REPLACE VORD->ImpDum with XfImpDum
REPLACE VORD->ImpInt with XfImpInt
REPLACE VORD->ImpTda with XfImpTda
REPLACE VORD->ImpTra with XfImpTra
REPLACE VORD->ImpAlm with XfImpAlm
REPLACE VORD->ImpCol with XfImpCol
REPLACE VORD->ImpTog with XfImpTog
REPLACE VORD->ImpDoc with XfImpDoc
REPLACE VORD->ImpOpe with XfImpOpe
REPLACE VORD->ImpQui with XfImpQui
REPLACE VORD->ImpMov with XfImpMov
REPLACE VORD->ImpBul with XfImpBul
REPLACE VORD->ImpCob with XfImpCob
REPLACE VORD->ImpPct with XfImpPct
REPLACE VORD->ImpCom with XfImpCom
REPLACE VORD->ImpTga with XfImpTga
REPLACE VORD->ImpVer with XfImpVer
REPLACE VORD->ImpComCo with XfImpComCo
REPLACE VORD->ImpSwf with XfImpSwf
REPLACE VORD->ImpComRe with XfImpComRe
REPLACE VORD->ImpComAc with XfImpComAc
REPLACE VORD->ImpTr1 with XfImpTr1
REPLACE VORD->Imptr2 with XfImpTr2
REPLACE VORD->ImpOtrBa with XfImpOtrBa
REPLACE VORD->ImpTgb with XfImpTgb
REPLACE VORD->ImpGma with XfImpGma
REPLACE VORD->ImpCga with XfImpCga
REPLACE VORD->ImpAfi with XfImpAfi
REPLACE VORD->ImpTdi with XfImpTdi
REPLACE VORD->ImpDevCon with XfImpDevCon
REPLACE VORD->ImpOtrGa with XfImpOtrGa
REPLACE VORD->ImpTgal with XfImpTgal
REPLACE VORD->PorIgv with XfPorIgv
REPLACE VORD->ImpBto with XfImpBto
REPLACE VORD->ImpDto with XfImpDto
REPLACE VORD->ImpAdm with XfImpAdm
REPLACE VORD->ImpVta with XfImpVta
REPLACE VORD->ImpNet with XfImpNet

** Grabamos en Seguimiento de Importaci¢n **
*!*	IF LEFT(VORD.NroOrd,1)<>[N]
*!*	   SELE SIMP
*!*	   SEEK XsNroOrd
*!*	   IF !FOUND()
*!*	      APPEND BLANK
*!*	      IF ! RLOCK()
*!*	         RETURN
*!*	      ENDIF
*!*	      REPLACE SIMP->NroOrd WITH XsNroOrd
*!*	      REPLACE SIMP->Status  WITH [1]  && FIJARSE EN CMPMTABL EL ANCHO DEL CODIGO
*!*	      REPLACE SIMP->FchSeg  WITH DATE()
*!*	      REPLACE SIMP->TimSeg  WITH TIME()
*!*	      REPLACE SIMP->FchOrd  WITH XdFchOrd
*!*	      REPLACE SIMP->FchPgo  WITH XdFchEnt
*!*	      REPLACE SIMP->User    WITH GsUsuario
*!*	      UNLOCK
*!*	   ENDIF
*!*	ENDIF
** Fin de grabaci¢n Seg. Importaci¢n **
SELE VORD

** Grabamos Browse **
*!*	DO xBgrab
*********************

*!*	SELE VORD
*!*	DO XImprime
*!*	IF _Destino#2  && Pantalla es 2
*!*	   IF SEEK(XsNroOrd,"VORD") AND RLOCK("VORD")
*!*	      *REPLACE VORD.NroCop WITH VORD.NroCop+1
*!*	   ENDIF
*!*	   UNLOCK IN "VORD"
*!*	ENDIF
*!*	SELE RORD
*!*	SET RELA TO
*!*	SELE VORD
RETURN
*********************************************
* Objeto : Grabacion de Informacion Detalle *
*********************************************
PROCEDURE xBgrab
SELE RORD
APPEND BLANK
REPLACE NroOrd WITH XsNroOrd
REPLACE TpoReq WITH XsTpoReq
REPLACE CodMat WITH XsCodMat
REPLACE DesMat WITH XsDesMat
REPLACE UndCmp WITH XsUndCmp
REPLACE FacEqu WITH XfFacEqu
REPLACE PreUni WITH XfPreUni
REPLACE CanPed WITH XfCanPed
REPLACE PorDto WITH XfPorDto
REPLACE ImpLin WITH XfImpLin
REPLACE FchOrd WITH VORD.FchOrd
REPLACE TpoBie WITH XcTpoBie
*!*	PRIVATE i
*!*	i = 1
*!*	IF GiTotDel > 0
*!*	   DO WHILE i<=GiTotDel
*!*	      SELE RORD
*!*	      GO AiRegDel(i)
*!*	      IF ! RLOCK()
*!*	         LOOP
*!*	      ENDIF
*!*	      ** desactualiza Requerimiento **
*!*	      IF AsNroReq # SPAC(6)
*!*	         SELE VREQ
*!*	         SEEK LEFT(RORD->Usuario,LEN(VREQ.Usuario))+RORD->NroReq
*!*	         IF !REC_LOCK(5)
*!*	            LOOP
*!*	         ENDIF
*!*	         IF UNDCMP <> RORD->UNDCMP
*!*	            REPLACE VREQ->CanPed WITH CanPed - RORD->CanPed*RORD->FacEqu/FacEqu
*!*	         ELSE
*!*	            REPLACE VREQ->CanPed WITH CanPed - RORD->CanPed
*!*	         ENDIF
*!*	         IF CanPed <= 0
*!*	            REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
*!*	         ELSE
*!*	            REPLACE VREQ->FlgEst WITH [O]    && Con O/Compra
*!*	         ENDIF
*!*	         IF CanDes >= CanReq
*!*	            REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
*!*	         ELSE
*!*	            REPLACE VREQ->FlgLog WITH IIF(VREQ->FlgEst=[O],[H],[R])
*!*	            REPLACE VREQ->FlgHis WITH [R]
*!*	         ENDIF
*!*	         REPLACE VREQ->NroO_C WITH SPAC(LEN(XsNroOrd))
*!*	         REPLACE VREQ->FchO_C WITH {}
*!*	         UNLOCK
*!*	      ENDI
*!*	      **
*!*	      SELE RORD
*!*	      * Proceso que permite eliminar el precio grabado en el archivo hist¢rico
*!*	      **DO Eli_precio
*!*	      SELE RORD
*!*	      DELETE
*!*	      UNLOCK
*!*	      i = i + 1
*!*	   ENDDO
*!*	ENDIF
*!*	i = 1
*!*	DO WHILE i <= GiTotItm
*!*		IF !EMPTY(AsNroReq(i))
*!*		   SELE VREQ
*!*		   SEEK LEFT(XsUsuario,LEN(VREQ.Usuario))+AsNroReq(i)  && Caso Logistica NumEle
*!*		   IF FOUND()
*!*			   IF !REC_LOCK(5)
*!*		    	  LOOP
*!*			   ENDIF
*!*		   ENDIF
*!*	   ENDIF
*!*	   SELE RORD
*!*	   IF AiNumReg(i)>0   && Registros ya existen
*!*	      GO AiNumReg(i)
*!*	      IF ! RLOCK()
*!*	         LOOP
*!*	      ENDIF
*!*	      ** OJO >> El sistema no permite modificar # de Requerimiento **
*!*	      ** desactualizamos Requerimiento **
*!*	      IF AsNroReq(i) # SPAC(6)
*!*	         SELE VREQ
*!*	         IF UNDCMP <> RORD->UNDCMP
*!*	            *  Se considera una orden de compra por requisicion
*!*	            REPLACE VREQ->CanPed WITH VREQ->CanPed - (RORD->CanPed*RORD->FacEqu/FacEqu)
*!*	         ELSE
*!*	            REPLACE VREQ->CanPed WITH VREQ->CanPed - RORD->CanPed
*!*	         ENDIF
*!*	         IF VREQ.CanPed <= 0
*!*	            REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
*!*	         ELSE
*!*	            REPLACE VREQ->FlgEst WITH [O]    && Solo Emitida
*!*	         ENDIF
*!*	         IF VREQ->CanPed >= VREQ->CanReq
*!*	            REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
*!*	         ELSE
*!*	            REPLACE VREQ->FlgLog WITH IIF(VREQ->FlgEst=[O],[H],[R])
*!*	            REPLACE VREQ->FlgHis WITH [R]
*!*	         ENDIF
*!*	         REPLACE VREQ->NroO_C WITH XsNroOrd
*!*	         REPLACE VREQ->FchO_C WITH XdFchOrd
*!*	         UNLOCK
*!*	      ENDI
*!*	   ELSE
*!*	      SELECT RORD
*!*	      APPEND BLANK
*!*	      IF ! RLOCK()
*!*	         LOOP
*!*	      ENDIF
*!*	      REPLACE RORD->NroOrd WITH XsNroOrd
*!*	      UNLO
*!*	   ENDI
*!*	   **
*!*	   SELE RORD
*!*	   IF !REC_LOCK(5)
*!*	      LOOP
*!*	   ENDIF
*!*	   REPLACE RORD->Usuario WITH XsUsuario   &&AsUsuari(i)
*!*	   REPLACE RORD->NroReq  WITH AsNroReq(i)
*!*	   REPLACE RORD->TpoReq  WITH AcTpoReq(i)
*!*	   *
*!*	   REPLACE RORD->TpoBie  WITH AcTpoBie(i)
*!*	   *
*!*	   REPLACE RORD->CodMat  WITH AsCodMat(i)
*!*	   REPLACE RORD->DesMat  WITH AsDesMat(i)
*!*	   REPLACE RORD->UndCmp  WITH AsUndCmp(i)
*!*	   REPLACE RORD->FacEqu  WITH AfFacEqu(i)
*!*	   REPLACE RORD->Peso    WITH AsPeso  (i)
*!*	   REPLACE RORD->PreUni  WITH AfPreUni(i)
*!*	   REPLACE RORD->PreFob  WITH AfPreFob(i)
*!*	   REPLACE RORD->PorDto  WITH AfPorDto(i)
*!*	   REPLACE RORD->CanPed  WITH AfCanPed(i)
*!*	   REPLACE RORD->ImpLin  WITH AfImpLin(i)
*!*	   REPLACE RORD->FchOrd  WITH XdFchOrd
*!*	   x = RECNO()  &&  El puntero no ubica autom ticamente
*!*	   GO x
*!*	   REPLACE RORD->FchEnt  WITH VREQ->FCHENT
*!*	   ** Control de la Requisici¢n
*!*	   IF !EMPTY(AsNroReq(i))
*!*	      SELE VREQ
*!*	      IF UNDCMP <> RORD->UNDCMP
*!*	         *  Se considera una orden de compra por requisicion
*!*	         REPLACE VREQ->CanPed WITH VREQ->CanPed + (RORD->CanPed*RORD->FacEqu/FacEqu)
*!*	      ELSE
*!*	         REPLACE VREQ->CanPed WITH VREQ->CanPed + RORD->CanPed
*!*	      ENDIF

*!*	      IF VREQ.CanPed <= 0
*!*	         REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
*!*	      ELSE
*!*	         REPLACE VREQ->FlgEst WITH [O]    && Con O/Compra
*!*	      ENDIF
*!*	      IF VREQ->CanPed >= VREQ->CanReq
*!*	         ** El Control de enviar a Historia se realiza
*!*	         ** por el ingreso a almacen
*!*	         REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
*!*	      ELSE
*!*	         REPLACE VREQ->FlgLog WITH IIF(VREQ.FlgEst=[O],[H],[R])
*!*	         REPLACE VREQ->FlgHis WITH [R]
*!*	      ENDIF
*!*	      ** Se graban los datos del producto si coincide n£mero de Requisi¢n
*!*	      IF VREQ.CodMat <> RORD.CodMat AND VREQ.NroReq=RORD.NroReq
*!*	         REPLACE VREQ.CodMat WITH RORD.CodMat
*!*	         REPLACE VREQ.UndCmp WITH RORD.UndCmp
*!*	         REPLACE VREQ.DesReq WITH RORD.DesMat
*!*	      ENDIF
*!*	      IF VREQ.DesReq <> RORD.DesMat AND VREQ.NroReq=RORD.NroReq
*!*	         REPLACE VREQ.DesReq WITH RORD.DesMat
*!*	      ENDIF
*!*	      REPLACE VREQ->NroO_C WITH XsNroOrd
*!*	      REPLACE VREQ->FchO_C WITH XdFchOrd
*!*	      UNLOCK
*!*	   ENDI
*!*	   * Actualizamos el precio ingresado
*!*	   *** DO Gra_precio && Fuera piojos 17/03/98
*!*	   **
*!*	   STORE SPACE(LEN(RORD->NroReq))  TO AsNroReq(i)
*!*	   STORE SPACE(LEN(RORD->TpoReq))  TO AcTpoReq(i)
*!*	   *
*!*	   STORE SPACE(LEN(RORD->TpoBie))  TO AcTpoBie(i)
*!*	   *
*!*	   STORE SPACE(LEN(RORD->CodMat))  TO AsCodMat(i)
*!*	   STORE SPACE(LEN(CATG->DesMat))  TO AsDesMat(i)
*!*	   STORE SPACE(LEN(CATG->Marca ))  TO AsMarca (i)
*!*	   STORE SPACE(LEN(RORD->UndCmp))  TO AsUndCmp(i)
*!*	   STORE 1                         TO AfFacEqu(i)
*!*	   STORE 0                         TO AsPeso  (i)
*!*	   STORE 0                         TO AfPreUni(i)
*!*	   STORE 0                         TO AfPreFob(i)
*!*	   STORE 0                         TO AfPorDto(i)
*!*	   STORE 0                         TO AfCanPed(i)
*!*	   STORE 0                         TO AfImpLin(i)
*!*	   STORE 0                         TO AiNumReg(i)
*!*	   SELE RORD
*!*	   UNLOCK
*!*	   i = i + 1
*!*	ENDDO
*!*	STORE SPACE(LEN(RORD->NroReq)) TO AsNroReq
*!*	GiTotItm = 0
RETURN
******************************************************************************
* Objeto : Graba el precio unitario de la O/C en CMPCATGE.DBF
******************************************************************************
PROCEDURE Gra_precio
IF !SEEK (AsCodMat(i), 'PCAT')
   SELE PCAT
   APPEN BLANK
   REPL CodMat WITH AsCodMat(i)
ENDI
SELE PCAT
IF (XdFchOrd >= FCCMP5)  OR  (FCCMP5={})
   IF (XsNroOrd >= Orcmp5) OR (EMPTY(Orcmp5))
      IF RLOCK()
         DO CASE
            CASE XsNroOrd = Orcmp5
                REPL Prcmp5 WITH IIF(LEFT(XsNroOrd,1)='N',RORD.PreUni,RORD.PreFob)
                REPL Prove5 WITH XsCodAux
                REPL Fccmp5 WITH XdFchOrd
                REPL Orcmp5 WITH XsNroOrd
            OTHERWISE
                STORE 1 TO ix, iix
                X = 'ORCMP'
                FOR ix=1 to 5
                    X = 'ORCMP'+STR(ix,1)
                    IF EMPTY(&x)
                       iix = ix
                       ix = 5
                    ENDI
                ENDF
                IF iix < 5
                   FOR ix=iix TO 4
                      X = 'PRCMP'+STR(ix,1)
                      Y = 'PRCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'PROVE'+STR(ix,1)
                      Y = 'PROVE'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'FCCMP'+STR(ix,1)
                      Y = 'FCCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'ORCMP'+STR(ix,1)
                      Y = 'ORCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                   ENDF
                ENDI
                *
                REPL Prcmp5 WITH IIF(LEFT(XsNroOrd,1)='N',RORD.PreUni,RORD.PreFob)
                REPL Prove5 WITH XsCodAux
                REPL Fccmp5 WITH XdFchOrd
                REPL Orcmp5 WITH XsNroOrd
         ENDC
      ENDI
      UNLO
   ENDI
ENDI
SELE RORD
RETURN
************************************************************************ FIN *
* Objeto : Elimina el precio unitario de la O/C en CMPCATGE.DBF
******************************************************************************
PROCEDURE Eli_precio
IF !SEEK (RORD.CodMat, 'PCAT')
   GsMsgErr = [ Producto no existe en el archivo CMPCATGE.DBF ]
   DO LIB_MERR WITH 99
   RETURN
ENDI
SELE PCAT
DO CASE
   CASE (VORD.FchOrd = FCCMP5) AND (XsNroOrd = Orcmp5)
      IF RLOCK()
         REPL Prcmp5 WITH 0 , Prove5 WITH SPAC(LEN(Prove5))
         REPL Fccmp5 WITH {}, Orcmp5 WITH SPAC(LEN(Orcmp5))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP4) AND (XsNroOrd = Orcmp4)
      IF RLOCK()
         REPL Prcmp4 WITH 0 , Prove4 WITH SPAC(LEN(Prove4))
         REPL Fccmp4 WITH {}, Orcmp4 WITH SPAC(LEN(Orcmp4))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP3) AND (XsNroOrd = Orcmp3)
      IF RLOCK()
         REPL Prcmp3 WITH 0 , Prove3 WITH SPAC(LEN(Prove3))
         REPL Fccmp3 WITH {}, Orcmp3 WITH SPAC(LEN(Orcmp3))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP2) AND (XsNroOrd = Orcmp2)
      IF RLOCK()
         REPL Prcmp2 WITH 0 , Prove2 WITH SPAC(LEN(Prove2))
         REPL Fccmp2 WITH {}, Orcmp2 WITH SPAC(LEN(Orcmp2))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP1) AND (XsNroOrd = Orcmp1)
      IF RLOCK()
         REPL Prcmp1 WITH 0 , Prove1 WITH SPAC(LEN(Prove1))
         REPL Fccmp1 WITH {}, Orcmp1 WITH SPAC(LEN(Orcmp1))
      ENDI
      UNLO
ENDC
SELE RORD
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE XBinse1
PARAMETERS ElePrv, Estado

PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsNroReq(i) = AsNroReq(i-1)
   AcTpoReq(i) = AcTpoReq(i-1)
   *
   AcTpoBie(i) = AcTpoBie(i-1)
   *
   AsCodMat(i) = AsCodMat(i-1)
   AsDesMat(i) = AsDesMat(i-1)
   AsMarca (i) = AsMarca (i-1)
   AsUndCmp(i) = AsUndCmp(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfPreUni(i) = AfPreUni(i-1)
   AsPeso  (i) = AsPeso  (i-1)
   AfPreFob(i) = AfPreFob(i-1)
   AfPorDto(i) = AfPorDto(i-1)
   AfCanPed(i) = AfCanPed(i-1)
   AfImpLin(i) = AfImpLin(i-1)
   AiNumReg(i) = AiNumReg(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(RORD->NroReq))  TO AsNroReq(i)
STORE 'R'  TO AcTpoReq(i)
*
STORE SPACE(LEN(RORD->TpoBie))  TO AcTpoBie(i)
*
STORE SPACE(LEN(RORD->CodMat))  TO AsCodMat(i)
STORE SPACE(LEN(CATG->DesMat))  TO AsDesMat(i)
STORE SPACE(LEN(CATG->Marca ))  TO AsMarca (i)
STORE SPACE(LEN(RORD->UndCmp))  TO AsUndCmp(i)
STORE 1                         TO AfFacEqu(i)
STORE 0                         TO AsPeso  (i)
STORE 0                         TO AfPreUni(i)
STORE 0                         TO AfPreFob(i)
STORE 0                         TO AfPorDto(i)
STORE 0                         TO AfCanPed(i)
STORE 0                         TO AfImpLin(i)
STORE 0                         TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea cuando parte de REQU
******************************************************************************
PROCEDURE XBinse2
PARAMETERS ElePrv, Estado

Estado = .F.

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr
PARAMETERS ElePrv, Estado
PRIVATE LnRsp
=SEEK(XsNroOrd+XsUsuario+AsNroReq(EleAct),'RORD')
IF RORD.CanDes <> 0
   GsMsgErr = ' Item ya tiene ingreso al Almac‚n '
   DO lib_merr WITH 99
   Estado = .F.
   UltTecla = Enter
   RETURN
ENDIF
*!*	LnRsp = MESSAGEBOX( "Despu‚s de eliminar un Item ya no se podr  a¤adir",0+4+48,"'*** I M P O R T A N T E ***")
*!*	IF LnRsp = 7
*!*	   Estado = .F.
*!*	   UltTecla = Enter
*!*	   RETURN
*!*	ENDIF
PRIVATE i
i = ElePrv + 1
IF AiNumReg(i) > 0
   GiTotDel = GiTotDel + 1
   AiRegDel(GiTotDel) = AiNumReg(i)
ENDIF
* borramos del arreglo
=ADEL(AsNroReq,i)
=ADEL(AcTpoReq,i)
=ADEL(AcTpoBie,i)
=ADEL(AsCodMat,i)
=ADEL(AsDesMat,i)
=ADEL(AsMarca ,i)
=ADEL(AsUndCmp,i)
=ADEL(AfFacEqu,i)
=ADEL(AfPreUni,i)
=ADEL(AsPeso  ,i)
=ADEL(AfPreFob,i)
=ADEL(AfPorDto,i)
=ADEL(AfCanPed,i)
=ADEL(AfImpLin,i)
=ADEL(AiNumReg,i)
i = GiTotItm
STORE SPACE(LEN(RORD->NroReq)) TO AsNroReq(i)
STORE SPACE(LEN(RORD->TpoReq)) TO AcTpoReq(i)
*
STORE SPACE(LEN(RORD->TpoBie)) TO AcTpoBie(i)
*
STORE SPACE(LEN(RORD->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(CATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(CATG->Marca )) TO AsMarca (i)
STORE SPACE(LEN(RORD->UndCmp)) TO AsUndCmp(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AsPeso  (i)
STORE 0                        TO AfPreUni(i)
STORE 0                        TO AfPreFob(i)
STORE 0                        TO AfPorDto(i)
STORE 0                        TO AfCanPed(i)
STORE 0                        TO AfImpLin(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm - 1
Estado = .T.
DO xRegenera

RETURN
*************************************************
* Objeto : Recalcula Importes y saldos NACIONAL *
*************************************************
PROCEDURE xRegenera
PRIVATE j
j = 1
STORE 0 TO XfImpBto,XfImpDto,XfImpIgv,XfImpNet
STORE 0 TO XfImpFob,XfTotUnd
FOR j = 1 TO GiTotItm
   XfTotUnd = XfTotUnd + AfCanPed(j)
   XfImpFob = XfImpFob + ROUND(AfCanPed(j)*AfPreFob(j),2)
   XfImpBto = XfImpBto + ROUND(AfCanPed(j)*AfPreUni(j),2)
   XfImpDto = XfImpDto + (ROUND(AfCanPed(j)*AfPreUni(j),2)-AfImpLin(j))
ENDFOR
IF LEFT(XsNroOrd,1)=[N]
   XfImpVta = XfImpBto - XfImpDto
   XfImpIgv = ROUND((XfImpVta+XfImpFle+XfImpOtr)*XfPorIgv/100,2)
   XfImpNet = XfImpVta +XfImpFle +XfImpOtr + XfImpIgv
   @ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                Ý"
   @ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                Ý"
   @ 21,0  SAY "Ý                                          Precio Venta Total :                Ý"
   @ 19,15 SAY XfImpBto PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,38 SAY XfImpDto PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,65 SAY XfImpVta PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,15 SAY XfImpFle PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,38 SAY XfImpOtr PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,54 SAY XfPorIgv PICT "99.99"         COLOR SCHEME 7
   @ 20,65 SAY XfImpIgv PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,65 SAY XfImpNet PICT "99999,999.99"  COLOR SCHEME 7
ELSE
   XfImpCif = XfImpFob+XfImpFle+XfImpSeg
   XfImpBto = XfImpCif+XfImpIns+XfImpHan+XfImpAdv+XfImpPap+XfImpAdu+XfImpMtt+XfImpAdm+XfImpOtr
   XfImpNet = XfImpBto
   *XfImpNet = XfImpFob
   j = 1
   FOR j = 1 TO GiTotItm
      AfPreUni(j) = AfPreFob(j) + ((XfImpNet-XfImpFob)/XfTotUnd)
      AfImpLin(j) = ROUND(AfPreUni(j) * AfCanPed(j),2)
   ENDFOR
   XfPorIgv = 0
   XfImpIgv = 0
   *@ 21,65 SAY XfImpNet PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,14 SAY XfImpFob     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,11 SAY XcTipFle     PICT "!" COLOR SCHEME 7
   @ 19,14 SAY XfImpFle     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,14 SAY XfImpSeg     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,14 SAY XfImpCif     PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,39 SAY XfImpIns     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,39 SAY XfImpHan     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,39 SAY XfImpAdv     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,39 SAY XfImpMtt     PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,67 SAY XfImpAdm     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,67 SAY XfImpAdu     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,67 SAY XfImpOtr     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,67 SAY XfImpNet     PICT "99999,999.99"  COLOR SCHEME 7
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n del documento
******************************************************************************
PROCEDURE xImprime
PRIVATE LARGO
SAVE SCREEN TO XTemp
*!*	Relaciones para impresión
XsNroOrd = VORD.NroOrd
*SELE RORD
*SET RELA TO Usuario+NroReq INTO VREQ
*LOCATE FOR NroOrd=XsNroOrd AND TpoO_C=XcTpoO_C
xWHILE = "RORD->NroOrd=XsNroOrd and RORD->TpoO_C=XcTpoO_C"
sNomRep = []
SELE RORD
LOCATE FOR NroOrd=XsNroOrd AND TpoO_C=XcTpoO_C
xFOR   = []
GO TOP IN C_RORD
IF XcTpoO_C = [S] OR XcTpoO_C = [K] OR (XcTpoO_C = [C] AND XcTipo=[N]) 
	Largo  = 66     && Largo de pagina
	sNomRep = "cmpn2300_"+GsSigCia
	IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
	DO F0print WITH "REPORTS"
ELSE
	IF XcTpoO_C = [C]
		Largo  = 66     && Largo de pagina
		sNomRep = "cmpi2300_"+GsSigCia  
		IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
		DO F0print WITH "REPORTS"
	ELSE
		Largo  = 66     && Largo de pagina
		sNomRep = "cmpp2300_"+GsSigCia  
		IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
		DO F0print WITH "REPORTS"
	ENDIF 	
ENDIF
*!*	RESTORE SCREEN FROM xTemp
RETURN
************************************************************************ FIN *
* Objeto : Emisión del documento
******************************************************************************
PROCEDURE xImpNac
DO F0PRINT
UltTecla = LastKey()
IF UltTecla = escape_
   RETURN
ENDIF
IniImp = _Prn2
Largo  = 66       && Largo de pagina
LinFin = 66 - 6
Ancho  = 95
Titulo = []
SubTitulo = []
STORE [] TO En1,En2,En3,En4,En5,En6,En7,En8,En9

SET DEVICE TO PRINTER
SET MARGIN TO 0
PRINTJOB
NumPag   = 0
LsLla_I  = VORD.NroOrd
NumLin = 0
DO Resetpag
SELE RORD
SEEK LsLla_I
SET MEMOW TO 26
IF VORD->FlgEst <> "A"
   STORE 0 TO Xsumpag,Xcanped,Xpeso
   SCAN WHILE  NroOrd=LsLla_i
      @ NumLin ,00  SAY RORD.CanPed PICT '9999,999.99'
      @ NumLin ,18  SAY RORD.UndCmp PICT '999'
      @ NumLin ,23  SAY RORD.CodMat PICT '@!'
      IF !EMPTY(VREQ.DesReq)
         @ NumLin, 32 SAY MLINE(VREQ.DesReq,1) PICT '@S26'   &&  +[ ]+VREQ.GloReq
      ELSE
        *@ NumLin, 32 SAY MLINE(RORD.DesMat,1) PICT '@S26'
         @ NumLin, 32 SAY RORD.DesMat PICT '@S26'
         IF LEN(TRIM(rord.Desmat))>26
               NumLin = NumLin + 1
               IF NumLin > 42
                  DO Resetpag
               ENDI
               @ NumLin, 32 SAY SUBSTR(RORD.Desmat,27) PICT '@S26'
         ENDIF
      ENDI
      @ NumLin ,59  SAY IIF(RORD.PorDto>0, TRANS(RORD.PorDto, '99')+'%', '')
      @ NumLin ,62  SAY RORD.PreUni PICT '99999.9999'
      @ NumLin ,73  SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
      @ NumLin ,78  SAY TRAN(ROUND(RORD.CanPed*RORD.PreUni,2), '9999,999.99')
      Xsumpag = Xsumpag + RORD.ImpLin
      Xcanped = Xcanped + RORD.CanPed
      Xpeso   = Xpeso   + (RORD.CanPed*RORD.Peso)
      IF !EMPTY(VREQ.DesReq)
         FOR ii=2 TO 24
            IF !EMPTY(MLINE(VREQ.Desreq,ii))
               NumLin = NumLin + 1
               IF NumLin > 42
                  DO Resetpag
               ENDI
               @ NumLin, 32 SAY MLINE(VREQ.DesReq,ii) PICT '@S26'
            ELSE
               ii = 24
            ENDI
         ENDF
      ELSE
      *   FOR ii=2 TO 20
      *      IF !EMPTY(MLINE(RORD.DesMat,ii))
      *         NumLin = NumLin + 1
      *         IF NumLin > 42
      *            DO Resetpag
      *         ENDI
      *         @ NumLin, 32 SAY MLINE(RORD.DesMat,ii) PICT '@S26'
      *      ELSE
      *         ii = 20
      *      ENDI
      *   ENDF
      ENDI
      NumLin = NumLin + 1
      IF NumLin > 42
         DO Resetpag
      ENDI
      @ NumLin , 32 SAY 'F.Ent.: '+DTOC(VREQ.FchEnt)
      NumLin = PROW() + 1
      SELE RORD
   ENDS
   IF NumLin > 34
      DO Resetpag
   ENDI
   @ NumLin  , 78 SAY '------------'
   NumLin = NumLin+1
   @ NumLin  , 74  SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
   @ NumLin  , 78 SAY VORD.ImpBto  PICT  '9999,999.99'
   @ NumLin+1, 46 SAY 'Descuento '
   @ NumLin+1, 78 SAY VORD.ImpDto  PICT  '9999,999.99'
   @ NumLin+2, 46 SAY 'Flete '
   @ NumLin+2, 78 SAY VORD.ImpFle  PICT  '9999,999.99'
   @ NumLin+3, 46 SAY 'Otros Gastos '
   @ NumLin+3, 78 SAY VORD.ImpOtr  PICT  '9999,999.99'
   @ NumLin+4, 46 SAY 'I.G.V. '
   @ NumLin+4, 78 SAY VORD.ImpIgv  PICT  '9999,999.99'
   @ NumLin+5, 78 SAY '------------'
   @ NumLin+6, 74 SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
   @ NumLin+6, 78 SAY VORD.ImpNet  PICT  '9999,999.99'
   @ NumLin+7, 78 SAY '============'
   * Pie de paguina
   IF RORD.Peso >0
      @ 43,06  say 'Ref.de Peso : '+TRANS(xcanped, '999999,999')+' Und.equivalen a '+TRANS(xpeso, '9999,999.9999')
   ENDI
   @ 44,06  say cfggloO_C
   IF VORD.Prueba='1'
      @ 46,17  say [x]
   ELSE
      @ 46,28  say [x]
   ENDI
   *@ 47,17  say VORD.TmpEnt
   IF EMPTY(CFGDir1) AND EMPTY(CFGDir2) AND EMPTY(CFGDir3)
      DO CASE
         CASE VORD.LugEnt = '1'
            @ 50,23  say [x]
         CASE VORD.LugEnt = '2'
            @ 50,46  say [x]
         CASE VORD.LugEnt = '3'
            @ 50,67  say [x]
      ENDC
   ELSE
      DO CASE
         CASE VORD.LugEnt = '1'
            @ 50,21  say CFGDir1
         CASE VORD.LugEnt = '2'
            @ 50,21  say CFGDir2
         CASE VORD.LugEnt = '3'
            @ 50,21  say CFGDir3
      ENDC
   ENDI
   SET MEMOW TO 55
   @ 51,18  say VORD.CndPgo
   @ 53,17  say MLINE(VORD.GloDoc,1)
   @ 54,17  say MLINE(VORD.GloDoc,2)
   @ 55,17  say MLINE(VORD.GloDoc,3)
ELSE
   @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
   @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ENDIF
ENDPRINTJOB
SET MEMOW TO 55
EJECT PAGE
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN 
SELECT VORD

RETURN
******************
PROCEDURE Resetpag
******************
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ELSE
   @ Largo-1,Ancho-10 SAY "../Continua"
ENDIF
@ 0,0  SAY IniImp
@ 2,19 SAY [R.U.C: 25856228]
@ 3,29 SAY VORD.REFERE
@ 6, 7 SAY LEFT(DTOC(VORD.FchOrd),2)
@ 6,17 SAY MES(MONTH(VORD.FchOrd),3)
@ 6,37 SAY RIGH(DTOC(VORD.FchOrd),2)
@ 7,60 SAY 'Cod.Prov.'
@ 8,12 SAY VORD.NomAux
@ 8,61 SAY VORD.CodAux
@10,12 SAY VORD.DirAux
@13,12 SAY PROV.Nomc_V
@13,54 SAY VORD.TlfAux
@14,75 say left(vord.nroord,1)+right(alltrim(str(_ano)),2)+[-]+right(vord.nroord,6)
*@14,75 SAY VORD.NroOrd PICT '@R !-!!!!!!'
NumLin = 19
NumPag = NumPag + 1

RETURN
************************************************************************ FIN *
FUNCTION MEMOANCHO
******************
PARAMETER xAncho
SET MEMOWIDTH  TO xAncho
RETURN ""

************************************************************************ FIN *
FUNCTION Modifica
*****************
SELE RORD
LOCATE FOR NroOrd= XsNroOrd AND TpoO_C=XcTpoO_C
SCAN WHILE NroOrd= XsNroOrd AND TpoO_C=XcTpoO_C FOR TpoReq$[RN] .AND. !EMPTY(CodMat) ;
   .AND. CanDes>0
   RETURN .F.
ENDSCAN
RETURN .T.
************************************************************************ FIN *
* Objeto : Verifica si el codigo fue registrado
******************************************************************************
FUNCTION xRepite
PRIVATE k
FOR k = 1 TO GiTotItm
   IF AsCodMat(k)=LsCodMat .AND. k#NumEle
      RETURN .T.
   ENDIF
ENDFOR
RETURN .F.
************************************************************************** FIN
* procedimiento que graba el recnop para saber fin de o/c
******************************************************************************
PROCEDURE  xImpPie
*********************
PUBLIC nRet
PRIVATE RecAct, Zona
Zona   = SELECT()
IF EOF()
   RecAct = RECCO()
ELSE
   RecAct = RECNO()
ENDI
SEEK XsNroOrd
SCAN WHILE  &xWHILE
   nRet = RECNO()
ENDSCAN
SELECT (Zona)
GOTO (RecAct)
RETURN  (nRet)
******************************************************************************
* Pintar pie de O/Compra de Importaci¢n
******************************************************************************
PROCEDURE xPieImp

*@ 10,1  SAY "  Nro.   T                                        Precio     Precio   Importe " COLOR SCHEME 7
*@ 11,1  SAY "Requisic R  C¢digo de Material   Und  Cantidad     FOB      Unitario   Total  " COLOR SCHEME 7
@ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
@ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
@ 18,0  SAY "ÝValor F.O.B.:              INSPECCION:                GTOS.OPER.:                Ý"
@ 19,0  SAY "Ý    FLETE   :              HANDLING  :               COMISION AA:                Ý"
@ 20,0  SAY "Ý     SEGURO :              ADVALOREN :                     OTROS:                Ý"
@ 21,0  SAY "ÝValor C.I.F.:              ALM.MANTT.:             <Valor TOTAL>:                Ý"
RETU

******************************************************************************
* pintado pie de O/c Nacional
******************************************************************************
PROCEDURE xPieNac
*!*	@ 10,1  SAY "  Nro.   T                                        Precio              Importe "  COLOR SCHEME 7
*!*	@ 11,1  SAY "Requisic R  C¢digo de Material   Und  Cantidad   Unitario  % Descto    Total  "  COLOR SCHEME 7
*!*	@ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
*!*	@ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
*!*	@ 18,0  SAY "Ý                                                                                 Ý"
*!*	@ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                   Ý"
*!*	@ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                   Ý"
*!*	@ 21,0  SAY "Ý                                          Precio Venta Total :                   Ý"
RETURN
******************************************************************************
****************
function _moneda
****************
parameter _mon
do case
	case _mon=1
	 return [NUEVOS SOLES]
	case _mon=2
	 return [DOLARES AMERICANOS]
	case _mon=3
	 return [DOLARES CANADIENSES]
	case _mon=4
	 return [MARCOS ALEMANES]
endcase
*
****************
FUNCTION vTipDoc
****************
ulttecla = lastkey()
if ulttecla = f8
   if !cmpbusca("TBFP")
      return .f.
   endif
   xsfmapgo = fmapgo
   ulttecla = enter
endif
SEEK XsFmaPgo
IF ! FOUND()
*!*	   GsMsgErr = [** Forma de Pago No Registrado **]
*!*	   DO LIB_Merr WITH 99
   UltTecla = 0
*!*	   return .f.
ENDIF
return .t.
*****************
PROCEDURE DATaDIC
*****************
DO CMPDIMPO.spr
return

