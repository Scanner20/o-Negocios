*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý cpipform.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý Control de producci¢n industrial                            Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Formulaci¢n de productos terminados o intermedios           Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 18/12/95                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý JGAF, Adaptacion Foxpro -> VFP 9 , 30/10/2006		       Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
PARAMETERS LTipo,cFormEdit
 ** Ltipo  .F. Formulas Reales , .T.  Precosteo 
#include const.h

XsTipo = Ltipo

XsTipCtoUni = 'PROM'
GoCfgAlm.odatadm.gencursor('CurTipCosteo','ALMTGSIS','TABL01','TABLA',TRIM(GsTipVal),[Defecto],'')
IF USED('CurTipCosteo')
	XsTipCtoUni = CurTipCosteo.Codigo
	USE IN 'CurTipCosteo'
ENDIF
DO FORM cpi_formulacion_01 WITH LTipo,cFormEdit

return


sTit = [FORMULACION DE PRODUCTOS]
**=F1_BASE(GsNomCia,[PRODUCCION:]+sTit,"USUARIO:"+GsUsuario,"FECHA:"+GsFecha)

PRIVATE nX0,nY0,nX1,nY1,sModulo
PRIVATE m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
PRIVATE m.PrgPrep,m.PrgPost,m.PrgBusca,m.Area_sel
STORE [] TO m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
STORE [] TO m.PrgPrep,m.PrgPost,m.PrgBusca,m.Area_sel
sModulo = [FORMPROD]

ArcTmp = SYS(2023)+'\'+SYS(3)
IF !ABrirDbfs()
*   CLOSE DATA
   RETURN  
ENDIF

PRIVATE m.CodPro,m.CanObj
m.CodPro = SPACE(LEN(CFPRO->CodPro))
m.CanObj = 0
m.Peso   = 0
m.UdPeso = 0
m.Modelo = .f.
m.FchCmb = {}
m.LCmbFor= .F.
m.CodMon = 1
DIMENSION vNroReg(5)
STORE 0 TO vNroReg
* Variables del Browse *

UltTecla  = 0
m.Primera = .T.
m.Estoy   = [MOSTRANDO]
m.salir   = 1

SELE CFPRO
LOCATE
DO pVerTodo

SELE CFPRO

*DO F1_EDIT WITH [pLlave],[pVerTodo],[pEditar],[pBorrar],[pListado],[],[],'CMAR',[]

*CLOSE DATA
RETURN
*******************
PROCEDURE ABRIRDBFS
*******************
=F1QEH([ABRE_DBF])

LOCAL LoDatAdm as dataadmin OF SYS(5)+"\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

IF !LoDatAdm.AbrirTabla('ABRIR','ALMTALMA','ALMA','ALMA01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMTDIVF','DIVF','DIVF01','')
    LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMEQUNI','EQUN','EQUN01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','CPICFPRO','CFPRO','CFPR01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','CPIDFPRO','DFPRO','DFPR01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMCATGE','CATG','CATG01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMCATAL','CALM','CATA01','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMDTRAN','DTRA','DTRA02','')
   LlRetVal =  .f.
ENDIF
*
IF !LoDatAdm.AbrirTabla('ABRIR','ALMTGSIS','TABL','TABL01','')
   LlRetVal =  .f.
ENDIF
***
SELE 0
CREATE TABL &ArcTmp. FREE (CodPro C(8), CodMat C(8), DesMat C(40) ,CanReq N(14,4),;
                      UndStk C(3), UndPro C(3), FacEqu N(7,4) ,SubAlm C(3),  ;
                      CanReqA N(14,4),NroReg N(6),PCTOMN N(14,4),PCTOUS N(14,4) )

USE &ArcTmp. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON CodPro TAG DFPR01
***
IF !LoDatAdm.AbrirTabla('ABRIR','CPICPROG','CPRG','CPRG01','')
   LlRetVal =  .f.
ENDIF
***
IF !LoDatAdm.AbrirTabla('ABRIR','CPIDPROG','DPRG','DPRG01','')
   LlRetVal =  .f.
ENDIF

* relaciones a usar *
SELE DFPRO
SET RELA TO CodMat INTO CATG

SELE CFPRO
SET RELA TO CodPro INTO DFPRO

=F1QEH([OK])
RETURN
*******************
PROCEDURE pLlave
*******************
SELE CFPRO
IF &sEsRgv.
   m.CodPro = CodPro
ELSE
   m.CodPro = SPACE(LEN(CodPro))
ENDIF
UltTecla = 0
DO CPIPFORM.SPR
SELE CFPRO
SEEK m.CodPro
RETURN
*****************
PROCEDURE pVerTodo
*****************
m.CodPro = CFPRO.CodPro
m.LCmbFor= .F.
DO CapVarBd
DO FORM CPIPFORM

SELE CFPRO

RETURN
******************
PROCEDURE CapVarBd
******************
PARAMETERS PsCodMat,PsAliasTemp,PsCdModelo
IF PARAMETERS()<3
	PsCdModelo = ''
ENDIF
IF VARTYPE(PsCdModelo)<>'C'
	PsCdModelo = '' 
ENDIF
IF PARAMETERS()<2
	PsAliasTemp = 'TEMPO'
ENDIF
IF PARAMETERS()<1 
	PsCodMat = ''
ENDIF
IF VARTYPE(PsCodMat)<>'C'
	PsCodMat = ''
ENDIF

SELE (PsAliasTemp)
ZAP
IF EMPTY(PsCodMat)
	RETURN
ENDIF

=SEEK(PsCodMat,'CFPRO','CFPR01')
IF !EMPTY(PsCdModelo)
	=SEEK(PsModelo,'CFPRO','CFPR02')
	PsCodMat = CFPRO.CodMat
ENDIF

m.CanObj = CFPRO.CanObj
m.Peso   = CFPRO.Peso
m.UDPeso = CFPRO.UDPeso
m.Modelo = CFPRO.Modelo
m.FchCmb = CFPRO.FchCmb
m.LCmbFor= .F.

SELE DFPRO
SEEK PsCodMat
SCAN WHILE CodPro = PsCodMat
     m.Nro_Reg = RECNO()
     SCATTER MEMVAR
     SELECT(PsAliasTemp)
     APPEND BLANK
     GATHER MEMVAR
     =SEEK(CodMat,[CATG])
     REPLACE DesMat WITH CATG.DesMat
     REPLACE NroReg WITH m.Nro_Reg
     Replace CanReqA WITH CanReq
     SELE DFPRO
ENDSCAN
SELECT(PsAliasTemp)
LOCATE
SELE CFPRO
RETURN
******************
PROCEDURE IniVarBd
******************
PARAMETERS PsAliasTemp
m.CanObj = 0.00
m.Peso   = 0.00
m.UDPeso = SPACE(LEN(CFPRO.UDPeso))
m.Modelo = .f.
m.FchCmb = {}
SELECT(PsAliasTemp)
ZAP
SELE CFPRO
RETURN
*****************
PROCEDURE pEditar
*****************
SELE CFPRO
Crear = .T.
IF &sEsRgv.
   Crear = .F.
   IF !F1_RLOCK(5)
      UltTecla = Escape
      RETURN
   ENDIF
   DO CapVarBd
ELSE
   DO IniVarBd
ENDIF

DO CPIPFORM.SPR

IF UltTecla # K_ESC
   DO pGrabar
   DO ActProgram
ENDIF
SELE CFPRO
UNLOCK ALL
m.Estoy=[MOSTRANDO]
DO BROWS_form with .t.,[DFPRO]
IF WVISIBLE(m.bTitulo)
   DEACTIVATE WINDOW (m.bTitulo)
   SELE DFPRO
   SEEK  m.CodPro
   SHOW WINDOW (m.bTitulo) TOP refresh
ENDIF
SELE CFPRO
RETURN
*****************
PROCEDURE pGrabar
*****************
IF Crear
   SEEK m.CodPro
   IF FOUND()
      DO f1msgerr WITH [Formulaci¢n de producto ya existe]
      RETURN
   ENDIF
   APPEND BLANK
   IF !F1_RLOCK(5)
      RETURN
   ENDIF
   REPLACE CodPro WITH m.CodPro
ENDIF
REPLACE CanObj WITH m.CanObj
REPLACE Peso   WITH m.Peso
REPLACE UdPeso WITH m.UDPeso
REPLACE Modelo WITH m.Modelo
REPLACE FchCmb WITH m.FchCmb

SELE DFPRO
SEEK m.CodPro
SCAN WHILE COdPro=m.CodPro
     DO WHILE !RLOCK()
     ENDDO
     DELE
     UNLOCK
ENDSCAN
NRC=0
SELE TEMPO
PACK
GO TOP
SCAN
   SCATTER MEMVAR
   lCmbReg=.F.
   IF CanReq<>CanReqA OR NroReg=0
      lCmbReg = .T.
   ENDIF
   SELE DFPRO
   APPEND BLANK
   GATHER MEMVAR
   IF lCmbReg
      NRC=NRC + 1
      IF nRC>ALEN(vNroReg)
         DIMENSION vNroReg(NRC+5)
      ENDIF
      vNroReg(NRC) = RECNO()
   ENDIF
   SELE TEMPO
ENDSCAN
IF NRC>0
	DIMENSION vNroReg(NRC)
ENDIF
SELE CFPRO
RETURN
********************
PROCEDURE Brows_Form
********************
PARAMETER lMostrar,m.Area,LoCnt

m.bTitulo = [COMP0NENTES]
m.bDeta   = [COMPONENTES]
IF lmostrar
   m.bClave1 = CFPRO.CodPro
   m.bClave2 = CFPRO.CodPro
ELSE
   m.bClave1 = m.CodPro
   m.bClave2 = m.CodPro
ENDIF
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.PrgPrep = [bPreProg]
m.PrgPost = [bFinProg]
nX0 = 10    && Left
nY0 = 105   && Top
nX1 = 646 
nY1 = 345

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .T.
   lBorr_Reg = .T.
ENDIF

DO f1browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar,LoCnt

SELE CFPRO
RETURN
*****************
PROCEDURE pBorrar
*****************
=F1QEH("BORR_REG")
SELE CFPRO
IF !F1_RLOCK(5)
   RETURN
ENDIF
SELE DFPRO
SEEK CFPRO->CodPro
DO WHILE !EOF() .AND. CodPro = CFPRO->CodPro
   IF !F1_RLOCK(5)
      LOOP
   ENDIF
   DELETE
   SKIP
ENDDO
SELE CFPRO
DELETE
SKIP
=F1QEH("OK")
RETURN
************************************************************************ FIN *
PROCEDURE bpreprog
******************
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
IF lPintar
   SELE TEMPO
   SET RELA TO
   SELE DFPRO
   SET RELA TO CODMAT INTO CATG
ELSE
   SELE DFPRO
   SET RELA TO
   SELE TEMPO
   SET RELA TO
ENDIF
SELE (m.CurrArea)
RETURN
******************
PROCEDURE bFinprog
******************
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
IF !lPintar
	DO CASE
		CASE M.CODPRO=[GV]		   	
		OTHER
		   fTotItm = 0
		   GO TOP
		   SCAN WHILE !EOF()
		     =SEEK(CodMat,[CATG])
		     IF !CATG.NoPRom
		        LfFacEqu = IIF(FacEqu<=0,1,FacEqu)
		        fTotItm = fTotItm + CanReq*IIF(UndPro#[KG],LfFacEqu,1)
		     ENDIF
		     ** Chequeamos cambios para actualizacion de programaci¢n **
		     IF NroReg=0 OR CANReqA<>CanReq
		        m.lCmbFor=.T.
		        m.FchCmb = DATE()
		     ENDIF
		     **
		   ENDSCAN
		   IF m.Peso=0
		   ELSE
		      m.CanObj = ROUN(FTotItm/m.Peso,0)
		   ENDIF
		   SHOW GET m.CanObj DISABLE
	ENDCASE		   
ENDIF
SELE (m.CurrArea)
RETURN
*******************
Function Calc_Peso && VETT 2010-01-13 15:26pm
*******************
PARAMETER PsCodPrd, PfPeso, PfCanObj, PfFacPObj, PaValorItems ,PsAliasDetForm

IF PARAMETERS()<6
	PsAliasDetForm = ''
ENDIF
IF EMPTY(PsAliasDetForm)
	PsAliasDetForm = 'DFPRO'
ENDIF
IF PARAMETERS()<5
	DIMENSION PaValorItems(6)

ENDIF
IF PARAMETERS()<4
	PfFacPObj = 0
ENDIF
IF PARAMETERS()<3
	PfCanObj = 0
ENDIF
IF PARAMETERS()<2
	PfPeso = 0
ENDIF

IF PARAMETERS()<1
	PsCodPrd = SPACE(0)
ENDIF

IF EMPTY(PsCodPrd)
	MESSAGEBOX('El codigo de producto no ha sido indicado',16,'¡ ATENCION ! - ¡ WARNING !')
	RETURN -1
ENDIF

PRIVATE m.CurrArea,LsCurOrder 
m.CurrArea = SELECT()
LsCurOrder = ''

	DO CASE
		CASE PsCodPrd=[GV]		   	
		OTHER
		   
		   STORE 0 TO fCostoItemsMN, fCostoItemsME, PfPesoItems, fTotItm ,PaValorItems
		   SELECT (PsAliasDetForm)
		   IF VerifyTAG(PsAliasDetForm,'DFPR01')
		   		LsCurOrder = ORDER()
				SET ORDER TO DFPR01
				SEEK PsCodPrd
				LsWhile = 'CodPro=PsCodPrd'
		   ELSE
		   		LsWhile = '.T.'			 		   		
		   ENDIF
		   SCAN WHILE EVALUATE(LsWhile)
		     =SEEK(CodMat,[CATG])
		     IF !CATG.NoPRom
		        LfFacEqu = IIF(FacEqu<=0,1,FacEqu)
		        fTotItm = fTotItm + CanReq*IIF(UndPro#[KG],LfFacEqu,1)
		     ENDIF
		     ** Chequeamos cambios para actualizacion de programaci¢n **
		     IF VARTYPE(NroReg)='N' AND VARTYPE(CanReqA)='N'
			     IF NroReg=0 OR CANReqA<>CanReq
			        m.lCmbFor=.T.
			        m.FchCmb = DATE()
			     ENDIF
		     ENDIF
		     fCostoItemsMN = fCostoItemsMN + ROUND(PreUni*CanReq*IIF(UndPro#[KG],LfFacEqu,1),4)
		     fCostoItemsME = fCostoItemsME + ROUND(PreUni2*CanReq*IIF(UndPro#[KG],LfFacEqu,1),4)
		     **
		   ENDSCAN
		   IF PfPeso=0 && Aqui se refiere al peso del producto
		   ELSE
		      PfCanObj = ROUN(FTotItm/PfPeso,3)
		   ENDIF
		   IF PfFacPobj<>0
		      PfCanObj = ROUND(FTotItm/PfFacPobj,3)
		      PfPeso   = ROUND(PfCanObj*PfFacPobj,3)
		   ENDIF
		   PfPesoItems = FTotItm  && Este es el peso de los insumos
	ENDCASE		   
	PaValorItems(1) = PfPeso
	PaValorItems(2) = PfCanObj
	PaValorItems(3) = PfFacPObj
	PaValorItems(4) = PfPesoItems
	PaValorItems(5) = fCostoItemsMN
	PaValorItems(6) = fCostoItemsME
SELECT (PsAliasDetForm)
SET ORDER TO (LsCurOrder)
LOCATE	
SELE (m.CurrArea)
RETURN 
********************
PROCEDURE ActProgram
********************
IF !M.lCmbFor
   RETURN
ENDIF
IF EMPTY(CFPRO.FchCmb)
   LdFchCmb = CTOD([01/]+STR(_MES,2,0)+[/]+STR(_ANO,4,0))
ELSE
   LdFchCmb = m.FchCmb
ENDIF

IF ActxFchCmb(GsAnoMes,CFPRO.CodPRo,LdFchCmb,[DPRG])
   =F1_ALERT([Actualizado programa del mes de ]+MES(_MES,3),3)
ELSE
   =F1_ALERT([No se pudo actualizar programa del mes de ]+MES(_MES,3),3)
ENDIF
RETURN
******************
PROCEDURE pListado
******************
do cpiiform.spr
RELEASE WINDOW FORMPROD
IF USED([FORM])
   SELE FORM
   USE
ENDIF
SELE DFPRO
SET RELA TO CodMat INTO CATG
SELE CFPRO
SET RELA TO CodPro INTO DFPRO

RETURN
******************
FUNCTION Cto_U_Gen
******************
PARAMETERS _vCostoUNI,PsCodMat,PcTipCtoUni
** Tomamos el ultimo valor mas proximo a la fecha; si es cero
*DIMENSION _vCostoUNI[2]
IF PARAMETERS()<3
	PcTipCtoUni = 'PROM'
ENDIF

IF PARAMETERS()<2
	PsCodMat = ''
ENDIF
**
IF VARTYPE(PsCodMat)<>'C'
	PsCodMat = ''
ENDIF
IF EMPTY(PsCodMat)
	PsCodMat =DFPRO.CodMat
ENDIF
**
PsCodMat = PADR(PsCodMat,LEN(DTRA.CodMat))
m.SaveArea=ALIAS()
STORE 0 TO LfPreUni1,LfPreUni2,LfPreUni,_vCostoUNI
STORE 0 TO LfVCosto1,LfVCosto2,LfVCosto
LfStkIni=0
LdFchDoc=CTOD([01/]+TRAN(_Mes+1,[@L ##])+[/]+STR(_ANO,4,0))-1
LdFch1 = CTOD('01/01/'+STR(_ANO,4,0))
** VETT  16/08/2010 05:04 PM : Costo de Almacen (Promedio o Ultima Compra)
DO CASE
	CASE PcTipCtoUni = 'PROM' && Costo Promedio Almacen
		LfPreUni=GoCfgAlm.Costo_Almacen(GsCodSed,PsCodMat,LdFchDoc,2,COSTO_UNIT_ALMACEN)
		_vCostoUNI[1] = GoCfgAlm.fPreUni1
		_vCostoUNI[2] = GoCfgAlm.fPreUni2

	CASE PcTipCtoUni = 'UEPS' && Ultima Entrar Primera Salir (LIFO)
		LOCAL LoUltCmp as Calc_UltCmp OF SYS(5)+"\aplvfp\Classgen\Progs\Janesoft.prg" 
		LoUltCmp=CREATEOBJECT("Calc_UltCmp")
		aUltCmp=LoUltCmp.cap_ultcmp(PsCodMat,PsCodMat,1,3,.T.,.F.,PcTipCtoUni,LdFch1,LdFchDoc)
		_vCostoUNI[1] = aUltCmp(5)
		_vCostoUNI[2] = aUltCmp(6)
		
	CASE PcTipCtoUni = 'PEPS' && Primera Entrar Primera Salir (FIFO)
		LOCAL LoUltCmp as Calc_UltCmp OF SYS(5)+"\aplvfp\Classgen\Progs\Janesoft.prg" 
		LoUltCmp=CREATEOBJECT("Calc_UltCmp")
		aUltCmp=LoUltCmp.cap_ultcmp(PsCodMat,PsCodMat,1,3,.T.,.F.,PcTipCtoUni,LdFch1,LdFchDoc)
		_vCostoUNI[1] = aUltCmp(5)
		_vCostoUNI[2] = aUltCmp(6)
	CASE PcTipCtoUni = 'FORM' && En base a costo del maestro de formulas
		LnCurReg = RECNO('CFPRO')
		IF SEEK(PsCodMat,'CFPRO','CFPR01')
			_vCostoUNI[1] = CFPRO.UniRea
			_vCostoUNI[2] = CFPRO.UniRea2
		ENDIF
		IF LnCurReg>0 AND RECNO('CFPRO')<>LnCurReg		
			GO LnCurReg IN 'CFPRO'
		ENDIF

ENDCASE
SELE (m.SAVEAREA)
RETURN LfPreUni
*******************
FUNCTION Cto_P_REAL
*******************
parameter _producto
PRIVATE xALias,LfCtoUni
xAlias = ALIAS()
LfCtoUni=0
IF !USED([CSTO])
	SELE 0
	USE CPICSTPT ORDER CSTO01 ALIAS CSTO
	IF !USED()
		RETURN -1
	ENDIF
ENDIF
SELE CSTO
SET ORDER TO CSTO01
SEEK GSAnoMes+_PRODUCTO
IF FOUND()
   LfCtoUni=ROUND(UniRea,3)
ENDIF
SELE (xALIAS)
RETURN LfCtoUni
***************************
PROCEDURE Importar_Formulas
***************************
DIMENSION aWrkSht(1), aCols(1)
m.lcXlsFile = GETFILE("Excel:XLS,XLSX,XLSB,XLSM")
IF FILE(m.lcXlsFile)
	SELECT 0
	USE d:\o-negocios\update\formulas_new ALIAS F_NEW	
*!*		?AWorkSheets(@aWrkSht,m.lcXlsFile,.T.)
*!*		?AWorkSheetColumns(@aCols,m.lcXlsFile,"C.PERF.")
	AppendFromExcel(m.lcXlsFile, "C.PERF.", "F_NEW", "", "", "", "",".F.")
	SELECT F_NEW
	GO TOP IN "F_NEW"
	BROWSE LAST NOWAIT
ENDIF
*!*	CopyToExcel("C:\Test.xlsx", "Sheet1", "MyTable") && try xls, xlsb, and xlsm as well

IF !USED('CFPRO')
	goentorno.open_dbf1('ABRIR','CPICFPRO','CFPRO','CFPR01','')	
ENDIF
IF !USED('DFPRO')
	goentorno.open_dbf1('ABRIR','CPIDFPRO','DFPRO','DFPR01','')	
ENDIF
IF !USED('CATG')
	goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
ENDIF

SELECT CFPRO
SET ORDER TO CFPR01   && CODPRO
** VETT  18/08/10 01:51 PM : Copiar a Codref todos los CodEqu que empiezan con 'P' 
SELECT CATG
SET ORDER TO CATG06   && CODREF 
SELECT F_NEW
LOCATE
SCAN FOR !EMPTY(Num_part)
	LsNumPart = TRIM(Num_part)
*!*		IF LsNumPart = 'P1274'
*!*			SET STEP ON 
*!*		ENDIF
	SCATTER MEMVAR
	SELECT CATG
	SEEK LsNumPart
	IF FOUND()
		LsCodPro = CodMat
		SELECT CFPRO
		SEEK LsCodPro
		IF FOUND()
			IF F_NEW.WEIGHT =0 AND F_NEW.Meter = 0
				REPLACE FchCmb  WITH {} IN F_NEW
				Replace UsrCmb  WITH 'INVALFORM' IN F_NEW
			ELSE
				replace FacNum WITH F_NEW.Weight
				replace FacDen WITH F_NEW.Meter
				replace FacPObj WITH F_NEW.W_M
				replace CdModelo WITH F_New.Code
				GATHER MEMVAR 
				REPLACE MODELO WITH .f.
				REPLACE FchCmb  WITH DATETIME() IN CFPRO
				Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN CFPRO
				REPLACE FchCmb  WITH DATETIME() IN F_NEW
				Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN F_NEW
				replace DivFam WITH LsCodPro IN F_NEW
			
			ENDIF
			
		ELSE
			IF F_NEW.WEIGHT =0 AND F_NEW.Meter = 0
				REPLACE FchCmb  WITH {} IN F_NEW
				Replace UsrCmb  WITH 'INVALIDO' IN F_NEW
			ELSE
				SELECT CFPRO
				APPEND BLANK 
				replace CodPro WITH LsNumPart
				replace FacNum WITH F_NEW.Weight
				replace FacDen WITH F_NEW.Meter
				replace FacPObj WITH F_NEW.W_M
				replace CdModelo WITH F_New.Code
				
				REPLACE UDPeso WITH 'KGS'
				GATHER MEMVAR 
				REPLACE MODELO WITH .f.
				REPLACE Precosteo WITH .T.
				REPLACE FchCmb  WITH DATETIME() IN CFPRO
				Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN CFPRO
				REPLACE FchCmb  WITH DATETIME() IN F_NEW
				Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN F_NEW
				replace DivFam WITH LsCodPro IN F_NEW
				REPLACE FchCmb  WITH {} IN F_NEW
				Replace UsrCmb  WITH 'NUEVO' IN F_NEW
				
			ENDIF
		ENDIF
	ELSE
		IF F_NEW.WEIGHT =0 AND F_NEW.Meter = 0
			REPLACE FchCmb  WITH {} IN F_NEW
			Replace UsrCmb  WITH 'INVALIDO' IN F_NEW
		ELSE
			SELECT CFPRO
			APPEND BLANK 		
			replace CodPro WITH LsNumPart
			replace FacNum WITH F_NEW.Weight
			replace FacDen WITH F_NEW.Meter
			replace FacPObj WITH F_NEW.W_M
			replace CdModelo WITH F_New.Code
			REPLACE UDPeso WITH 'KGS'
			GATHER MEMVAR 
			REPLACE MODELO WITH .f.
			REPLACE Precosteo WITH .T.
			REPLACE FchCmb  WITH DATETIME() IN CFPRO
			Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN CFPRO
			REPLACE FchCmb  WITH DATETIME() IN F_NEW
			Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN F_NEW
			replace DivFam WITH LsCodPro IN F_NEW

			REPLACE FchCmb  WITH {} IN F_NEW
			Replace UsrCmb  WITH 'NUEVOCATG' IN F_NEW
		ENDIF
	ENDIF
	SELECT F_NEW
	
ENDSCAN

FUNCTION UPDCATG_FORM
SELECT CATG 
IF !SEEK(XsCodPro,'CATG')
	APPEND BLANK
	REPLACE CodMat WITH XsCodPro
ENDIF
REPLACE DesMat WITH Modelos.CdModelo
REPLACE UndStk WITH 'MTS'
REPLACE FacEqu WITH 1
REPLACE UndCmp WITH 'MTS'
REPLACE TipMat WITH '20'
REplace LugEnt WITH 1

REPLACE FlgIgv WITH .T.
REPLACE CodSec WITH '01'
REPLACE Origen WITH 1
REPLACE CodUser WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) && goEntorno.User.Login
REPLACE FchHora WITH DATETIME()

PROCEDURE Prueba_Cargar_Hoja_Excel

LOCAL lcXLBook AS STRING, lnSQLHand AS INTEGER, ;
    lcSQLCmd AS STRING, lnSuccess AS INTEGER, ;
    lcConnstr AS STRING


lcXLBook = [D:\o-Negocios\update\costosnuevos.xls]

lcConnstr = [Driver=] + ;
    [{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
    [DBQ=] + lcXLBook

IF !FILE( lcXLBook )
    ? [Excel file not found]
    RETURN .F.
ENDIF
*-- Attempt a connection to the .XLSX WorkBook.
*-- NOTE: If the specified workbook is not found,
*-- it will be created by this driver! You cannot rely on a
*-- connection failure - it will never fail. Ergo, success
*-- is not checked here. Used FILE() instead.
lnSQLHand = SQLSTRINGCONNECT( lcConnstr )

*-- Connect successful if we are here. Extract data...
lcSQLCmd = [Select * FROM "C.PERF.$"]
lnSuccess = SQLEXEC( lnSQLHand, lcSQLCmd, [xlResults] )
? [SQL Cmd Success:], IIF( lnSuccess > 0, 'Good!', 'Failed' )
IF lnSuccess < 0
    LOCAL ARRAY laErr[1]
    AERROR( laErr )
    ? laErr(3)
    SQLDISCONNECT( lnSQLHand )
    RETURN .F.
ENDIF


*-- Show the results
SELECT xlResults
BROWSE NOWAIT
SQLDISCONNECT( lnSQLHand )