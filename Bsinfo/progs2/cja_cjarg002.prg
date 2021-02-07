********************************************************
* Reporte de Ingreos/Salidas/Transferencias Caja/bancos
********************************************************
#INCLUDE const.h
*!*	Abrimos Bases *!*
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV02','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')
LoDatAdm.abrirtabla('ABRIR','SISTDOCS','DOCS','DOC01','')
LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
LoDatAdm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RPRO','RMOV05','')
Ll_Liqui_C=.F.
IF !USED('L_C_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Cob.dbf')
		SELECT 0
		USE Liq_Cob ORDER LIQ_AST ALIAS L_C_Cobr	&& LEFT(DTOS(FECHA),6)+CODOPE+ASIENTO
		Ll_Liqui=.T.
	ENDIF	
ENDIF
Ll_Liqui_D=.F.
IF !USED('L_D_Cobr')
	IF FILE(ADDBS(goentorno.TsPathcia)+'Liq_Det.dbf')
		SELECT 0
		USE Liq_Det ORDER CodDoc ALIAS L_D_Cobr	&& CODDOC+NRODOC+LIQUI
		Ll_Liqui_D=.T.
	ENDIF
ENDIF
*!*	Declaramos Variables
STORE " " TO LcArcTmp,XsCtaDes,XsCtaHas,XsCodOpe,XsCndPgo
STORE 1 TO XsMovCja
XdFch1 = CTOD('01/'+STR(_MES,2,0)+'/'+STR(_ANO,4,0))
XdFch2 = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),IIF(VARTYPE(GdFecha)='D',GdFecha,DATE()))

DO FORM cja_cjarg002

******************
PROCEDURE Imprimir
******************
IF USED('OTROS')
	USE IN OTROS
ENDIF
IF USED('TEMPORAL')
	USE IN TEMPORAL
ENDIF

PUBLIC oRmovAdic as Object 
XsCtaDes = IIF(Empty(XsctaDes),'104',TRIM(XsCtaDes))
XsCtaHas = IIF(Empty(XsCtaHas),'104',TRIM(XsCtaHas))
LcArcTmp=GoEntorno.TmpPath+Sys(3)
SELECT 0
CREATE TABLE (LcArcTmp) FREE (FchCob d, ;
							  CodDoc c(LEN(RMOV.CodDoc)), ;
  							  NroDoc c(LEN(RMOV.NroDoc)), ;
  							  GloDoc C(80),;
  							  CndPgo C(10),;
  							  Moneda C(3),;
  							  Importe N(16,2),;
  							  TpoCmb n(10,4), ;
  							  IMPORT n(16,2), ;
							  ImpUsa n(16,2), ;
							  Saldo n(16,2), ;
							  CtaCja C(LEN(RMOV.CodCta)),;
							  Banco  C(40),;
							  Comprob C(13),;
							  NroVou C(LEN(VMOV.Nrovou)), ; 
							  NroChq c(15), ;
  							  CodCta c(LEN(RMOV.CodCta)), ;
							  CodCco c(LEN(RMOV.CodCco)), ;
							  NroMes C(2) , ;
							  CodOpe C(3) , ;
							  NroAst c(LEN(RMOV.NroAst)),;
							  FchAst D ,;
							  FchDoc D ,;
							  FchPed D ,;
							  Girado c(60), ;
							  CodMon n(1), ;
							  NotAst c(40),;
							  ImpChq n(16,2),;
							  EliItm C(1),;
							  NroItm N(5),;
							  TpoMov C(1),;
							  Import2 n(16,2),;
							  ImpUsa2 n(16,2),;
							  GloAst C(60),;
							  Obs	 C(30) )
							   
USE (LcArcTmp) EXCLUSIVE ALIAS TEMPORAL && YO
*!*	USE (LcArcTmp) ALIAS TEMPORAL && YO DENUEVO
INDEX ON CodDoc+nroDoc TAG TEMP02
INDEX ON NroMes+CodOpe+NroAst+STR(NroItm,5,0) TAG TEMP01 



LcArcTmp2=GoEntorno.TmpPath+Sys(3)
IF FILE(LcArcTmp2+'.DBF')
	FOR K = 1 TO 1000
		LcArcTmp2=GoEntorno.TmpPath+Sys(3)
		IF !FILE(LcArcTmp2+'.DBF')
			EXIT
		ENDIF
	ENDFOR
ENDIF

COPY STRUCTURE TO (LcArcTmp2) WITH CDX
SELECT 0
USE (LcArcTmp2) ALIAS Otros ORDER TEMP01

SELECT RMOV
SET ORDER TO RMOV01
SELECT OPER
IF XsMovCja>3
	SET FILTER TO INLIST(MovCja,1,2,3) 
ELSE
	SET FILTER TO MovCja = XsMovCja
ENDIF
LOCATE	
XsFor1 = IIF(EMPTY(XsCodOpe),'.T.',"CodOpe='"+XsCodOpe+"'") 
XsFor2 = ".T."
DO CASE
	CASE EMPTY(XdFch1) AND EMPTY(XdFch2)
		XsFor2 = ".T."
	CASE !EMPTY(XdFch1) AND EMPTY(XdFch2)
		XsFor2 = "FchAst>=XdFch1"
	CASE EMPTY(XdFch1) AND !EMPTY(XdFch2)
		XsFor2 = "FchAst<=XdFch2"
	CASE !EMPTY(XdFch1) AND !EMPTY(XdFch2)
		XsFor2 = "FchAst>=XdFch1 AND XdFch2>=FchAst"
ENDCASE

XsFor3 = IIF(EMPTY(XsCndPgo),'.T.',"CndPgo='"+XsCndPgo+"'") 

SCAN FOR &XsFor1
	LsCodOpe = CodOpe
	SELECT RMOV
	Xllave = XsNroMes+LsCodOpe
	SEEK Xllave
	DO WHILE NroMes + CodOpe = Xllave AND !EOF()
		LsNroAst = NroAst
		IF INLIST(EliItm,'*',':','-')  && Obviar cuentas automaticas
			SELECT RMOV
			SKIP 
			LOOP
		ENDIF

*!*			IF LsNroAst ='01000052' THEN 
*!*			SET STEP ON
*!*			ENDIF 
		SCAN WHILE NroMes+CodOpe+NroAst=xLlave+LsNroAst FOR &XsFor2
*!*			SET STEP ON
			IF INLIST(EliItm,'*',':','-')  && Obviar cuentas automaticas
				LOOP
			ENDIF

			IF !EMPTY(XsCodCco)
				IF XsCodCco <> TRIM(RMOV.CodCco)
					LOOP
				ENDIF
			ENDIF
			STORE .T. TO LlNoPaso 
			SCATTER MEMVAR 	
			IF EVALUATE(XsFor3)
				DO CASE
					CASE OPER.MovCja=1 && Ingresos 					
						IF !INLIST(CodCta , '10')   &&AND !INLIST(EliItm , ":","*","-")
							DO GrbTemp1
							IF SEEK(CodDoc,'PROV','PROV01') AND PROV.Tipo='C'
								LsTpoDoc=IIF(SEEK(CodDoc,"DOCS"),DOCS.TpoDoc,'')
								LsGDOC="GDOC"
								IF CodDoc='PROF'
									LsNroDoc=PADR(RMOV.NroDoc,LEN(VPRO.NroDoc))
									=SEEK(LsNroDoc,'VPRO')
									LsGDOC='VPRO'
								ELSE
									LsNroDoc=PADR(RMOV.NroDoc,LEN(GDOC.NroDoc))
									=SEEK(PADR(LsTpoDoc,LEN(GDOC.TpoDoc))+CodDoc+LsNroDoc,'GDOC','GDOC01')
									LsGDOC='GDOC'
								ENDIF	
								REPLACE Moneda  WITH IIF(&LsGdoc..CodMon=1,Gocfgcbd.MON_NAC,IIF(&LsGdoc..CodMon=2,Gocfgcbd.MON_EXT,''))
								REPLACE CndPgo  WITH &LsGdoc..CndPgo
								REPLACE FchCob  WITH &LsGdoc..FchDoc
								REPLACE Importe WITH &LsGdoc..ImpTot
								REPLACE Saldo 	WITH &LsGdoc..SdoDoc
							ELSE
								REPLACE FchCob  WITH RMOV.FchAst
								REPLACE Glodoc  WITH CTAS.NomCta
							ENDIF	
							REPLACE Obs 		WITH Captura_Obs()	
							REPLACE Import WITH Import*IIF(TpoMov='H',1,-1)
							REPLACE ImpUsa WITH ImpUsa*IIF(TpoMov='H',1,-1)								
							LlNoPaso=.f.
						ENDIF	
						*** -------------- ***
						IF CodCta='10' AND RMOV.TpoMov='D' && OR RMOV.EliItm='.' && Marca de Ingresos / Egresos de Caja
							DO GrbCta10					
							LlNoPaso=.f.
						ENDIF			
						*** Otros ***
						IF LlNoPaso
							DO GrbTemp2
						ENDIF	
						*** 
						
					CASE OPER.MovCja=2 && Egresos
						IF !INLIST(CodCta , '10')   &&AND !INLIST(EliItm , ":","*","-")
							DO GrbTemp1
							IF SEEK(CodDoc,'PROV','PROV01') AND PROV.Tipo='A'
								LfProvNac = 0
								LfProvExt = 0
								SELECT RPRO
								SEEK RMOV.CodCta+RMOV.NroDoc+RMOV.CodAux
								SCAN WHILE CodCta+NroDoc+CodAux=RMOV.CodCta+RMOV.NroDoc+RMOV.CodAux FOR CodOpe == PROV->CodOpe OR (nromes=[00] and codope=[000])
									LfProvNac = LfProvNac + IIF(TpoMov="D",-1,1)*Import
									LfProvExt = LfProvExt + IIF(TpoMov="D",-1,1)*ImpUsa
								ENDSCAN
								
								SELECT TEMPORAL
								REPLACE Moneda  WITH IIF(RPRO.CodMon=1,Gocfgcbd.MON_NAC,IIF(RPRO.CodMon=2,Gocfgcbd.MON_EXT,''))
*!*									REPLACE CndPgo  WITH RPRO.CndPgo
								REPLACE FchCob  WITH RPRO.FchDoc
								REPLACE Importe WITH IIF(RPRO.CodMon=1,LfProvNac,LfProvExt)
								REPLACE Import WITH Import*IIF(TpoMov='D',1,-1)
								REPLACE ImpUsa WITH ImpUsa*IIF(TpoMov='D',1,-1)
								replace GloDoc WITH IIF(SEEK(CTAS.ClfAux+RMOV.CodAux,'AUXI'),AUXI.NomAux,GloDoc)			
							ELSE
								REPLACE FchCob  WITH RMOV.FchAst
								REPLACE Glodoc  WITH CTAS.NomCta
							ENDIF	
							LlNoPaso=.f.
						ENDIF
						*** ----------- ***
						IF CodCta='10' AND  RMOV.TpoMov='H' && OR RMOV.EliItm='.' && Marca de Ingresos / Egresos de Caja
							DO GrbCta10	
							LlNoPaso=.f.				
						ENDIF			
						IF LlNoPaso
							DO GrbTemp2
						ENDIF	

					CASE OPER.MovCja=3 && Transferencias
						DO GrbTemp1
				ENDCASE	

			ENDIF
			
		ENDSCAN	
		SELECT RMOV
	ENDDO
	SELECT OPER
ENDSCAN
SELECT OTROS
LOCATE
SELECT temporal
LOCATE
*!*	DO CASE 
*!*		CASE XnCndPago= 1 && Contado
*!*			SET FILTER TO CndPgo='C/E'
*!*		CASE XnCndPago= 2 && Credito
*!*			SET FILTER TO CndPgo<>'C/E'
*!*		OTHERWISE 
*!*			
*!*	ENDCASE
*!*	LOCATE		
******************
PROCEDURE GrbTemp1
******************
SELECT TEMPORAL
APPEND BLANK
REPLACE CodCta WITH RMOV.CodCta
REPLACE CodCco WITH RMOV.CodCco
REPLACE NroAst WITH RMOV.NroAst
Replace Import WITH RMOV.Import
Replace Impusa WITH RMOV.ImpUsa
replace CodDoc WITH RMOV.CodDoc
replace NroDoc WITH RMOV.NroDoc
replace FchDoc WITH RMOV.FchDoc
replace GloDoc WITH RMOV.GloDoc
replace FchAst WITH RMOV.FchAst
replace EliItm WITH RMOV.EliItm
replace NroItm WITH RECNO()
replace TpoMov WITH RMOV.TpoMov
***---Grabamos la llave del asiento, sino no pasa nada ---*** 
replace NroMes WITH RMOV.NroMes
replace CodOpe WITH RMOV.CodOpe
replace NroAst WITH RMOV.NroAst
*** Info de Ctas x Cobrar
=SEEK(RMOV.CodCta,"CTAS")
******************
PROCEDURE GrbTemp2
******************
SELECT RMOV
SCATTER MEMVAR
INSERT INTO (LcArcTmp2) FROM MEMVAR 
******************
PROCEDURE GrbCta10
******************
SELECT RMOV
LlGrbCja = .F.
LnRecTmp = 0
SELECT TEMPORAL
=SEEK(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst)
SCAN WHILE NroMes+CodOpe+NroAst=RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst  											
	IF EMPTY(CtaCja)
		LnRecTmp=RECNO()
		LlGrbCja = .T.
		EXIT
	ENDIF	
ENDSCAN
IF LnRecTmp>0
	GO LnRecTmp IN temporal 
ELSE
	APPEND BLANK 
	***---Grabamos la llave del asiento, sino no pasa nada ---*** 
	REPLACE NroMes WITH RMOV.NroMes
	REPLACE CodOpe WITH RMOV.CodOpe
	REPLACE NroAst WITH RMOV.NroAst
	IF LnRecTmp=0
		replace NroItm WITH RECNO()
	ENDIF
ENDIF
=SEEK(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,"VMOV")
=SEEK(RMOV.CodCta,'CTAS')
=SEEK(PADR(GsClfBco,LEN(TABL.Tabla))+CTAS.Codbco,'TABL')

SCAN WHILE NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	replace Girado WITH VMOV.Girado && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	replace NotAst WITH VMOV.NotAst && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace ImpChq WITH VMOV.ImpChq && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace CodMon WITH Vmov.CodMon && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace TpoCmb WITH VMOV.TpoCmb && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace CtaCja WITH VMOV.CtaCja && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace NroChq WITH VMOV.NroChq && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	Replace NroVou WITH VMOV.NroVou && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	replace Banco  WITH LEFT(TABL.Nombre,20) && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	replace TpoMov WITH RMOV.TpoMov && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	replace GloAst WITH TRIM(MLINE(VMOV.GloAst,1))+' '+TRIM(MLINE(VMOV.GloAst,2)) && FOR NroMes+CodOpe+NroAst=VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
ENDSCAN
*!*	DO CASE
*!*		CASE OPER.MovCja=1
*!*			replace Import2 WITH RMOV.Import*IIF(TpoMov='D',1,-1)
*!*			replace ImpUsa2 WITH RMOV.ImpUsa*IIF(TpoMov='D',1,-1)
*!*		CASE OPER.MovCja=2
*!*			replace Import2 WITH RMOV.Import*IIF(TpoMov='H',1,-1)
*!*			replace ImpUsa2 WITH RMOV.ImpUsa*IIF(TpoMov='H',1,-1)
*!*	ENDCASE
*********************
FUNCTION Captura_Obs
********************* 
LOCAL LnSelect
IF VARTYPE(LsObs)<>'C'
	LsObs = ""
ENDIF 
LnSelect=SELECT()
IF !USED('L_C_Cobr')
	RETURN
ENDIF
IF !USED('L_D_Cobr')
	RETURN
ENDIF
 
DO CASE
		CASE RMOV.CODCTA='12' AND RMOV.TpoMov = "H"
		LsCodDoc=RMOV.CodDoc
		LsNroDoc=RMOV.NroDOc		
		SELECT L_C_Cobr
		=SEEK(LEFT(DTOS(RMOV.FchAst),6)+RMOV.CodOpe+RMOV.NroAst,"L_C_Cobr")
		LsLiqui = Liqui
		SELECT L_D_Cobr
		SEEK ALLTRIM(LsCodDoc+PADR(LsNroDoc,LEN(L_d_Cobr.nrodoc))+LsLiqui)
		LsObs = Obs		
ENDCASE
SELECT (LnSelect)
RETURN LsObs
**************
PROCEDURE Old
**************
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
SYS(2700,0)           

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "DOCUMENTOS EMITIDOS"

cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
Do FONDO WITH 'DOCUMENTOS EMITIDOS '+cTitulo ,goEntorno.User.Login,GsNomCia,GsFecha

XiTpoDoc = 1
UltTecla = 0

@  9,10 FILL  TO 15,68      COLOR W/N
@  9,12 CLEAR TO 13,68
@  8,11       TO 14,69
@ 10,31 PROMPT "  CAJA  INGRESOS  "
@ 11,31 PROMPT "   CAJA EGRESOS   "
@ 12,31 PROMPT "CAJA TRANSFERENCIA"
MENU TO XiTpoDoc
IF LastKey() = Escape_ .OR. XiTpoDoc = 0
	=Terminar() 
	RETURN
ENDIF
@  9,12 CLEAR TO 13,68
XiForma = 1
DO CASE
	CASE XiTpoDoc = 1
		@ 8,31 SAY "  CAJA  INGRESOS  " COLOR SCHEME 7
		XsCodOpe = "001"
		@ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
		@ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
		MENU TO XiForma
		xPrg = "CJA_CJAC1MOV"
	CASE XiTpoDoc = 2
		@ 8,31 SAY "   CAJA EGRESOS   " COLOR SCHEME 7
		XsCodOpe = "002"
		@ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
		@ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
		@ 12,22 PROMPT "TODOS LOS DOCUMENTO DE UNA RELACION"
		MENU TO XiForma
		xPrg = "CJA_CJAC2MOV"
	CASE XiTpoDoc = 3
		@ 8,31 SAY "CAJA TRANSFERENCIA" COLOR SCHEME 7
		XsCodOpe = "018"
		@ 10,22 PROMPT "  DOCUMENTOS EN UN RANGO DE FECHA  "
		@ 11,22 PROMPT "      ENTRE N§ DE DOCUMENTOS       "
		MENU TO XiForma
		xPrg = "CJA_CJAC3MOV"
ENDCASE
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
IF !USED('OPER')
	LoContab.odatadm.Abrirtabla('ABRIR','CBDTOPER','OPER','OPER01')	
ENDIF
SELECT OPER
SET FILTER TO MovCja=XiTpoDoc
LOCATE
IF EOF()
	GsMsgErr='No hay Operaciones configuradas para este tipo de transacción'
	=MESSAGEBOX(GsMsgErr,16,'DOCUMENTOS EMITIDOS')
	=Terminar() 
	RETURN
ENDIF
XsCodOpe=OPER.CodOpe

IF LastKey() = Escape_ .OR. XiForma  = 0
	=Terminar() 
	RETURN
ENDIF
XiNroMes = _Mes
XiNroRel = 0
XiNrDoc1 = 1
XiNrDoc2 = 999999
XdFchAs1 = DATE()
XdFchAs2 = DATE()
XsNroMes = TRANSF(XiNroMes,"@L ##")
@  9,12 CLEAR TO 13,68
DO CASE
	CASE XiForma  = 1
		@ 09,22 SAY    "  DOCUMENTOS EN UN RANGO DE FECHA  " COLOR SCHEME 7
		@ 10,24 SAY "              OPERACION :" GET XsCodOpe VALID vCodOpe()
		@ 11,24 SAY "DESDE FECHA DE REGISTRO :" GET XdFchAs1
		@ 12,24 SAY "HASTA FECHA DE REGISTRO :" GET XdFchAs2
		READ
		Llave  = XsNroMes+XsCodOpe
		Valido = "(FchAst >=XdFchAs1 .AND. FchAst <= XdFchAs2)"
		RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe)"
		xOrden = "VMOV01"
	CASE XiForma  = 2
		@ 09,22 SAY    "      ENTRE N§ DE DOCUMENTOS       " COLOR SCHEME 7
		@ 10,24 SAY "          OPERACION :" GET XsCodOpe VALID vCodOpe()
		@ 11,26 SAY "DEL MES DE          :" GET XiNroMes PICT "@Z 99"
		@ 12,26 SAY "DESDE DOCUMENTO NO. :" GET XiNrDoc1 PICT "@LZ 999999"
		@ 13,26 SAY "HASTA DOCUMENTO NO. :" GET XiNrDoc2 PICT "@LZ 999999"
		READ
		XsNroMes = TRANSF(XiNroMes,"@L ##")
		Llave  = XsNroMes+XsCodOpe+TRANSF(XiNrDoc1,"@L 999999")
		Valido = ".T."
		RegVal = "(NroMes+CodOpe=XsNroMes+XsCodOpe .AND. VAL(NroAst)<=XiNrDoc2)"
		xOrden = "VMOV01"
	CASE XiForma  = 3
		@ 09,22 SAY    "TODOS LOS DOCUMENTO DE UNA RELACION" COLOR SCHEME 7
		@ 10,24 SAY "   OPERACION :" GET XsCodOpe VALID vCodOpe()
		@ 12,30 SAY "RELACION NO. :" GET XiNroRel PICT "@LZ 999999"
		READ
		Llave  = XsCodOpe+TRANSF(XiNroRel,"@L 999999")
		Valido = ".T."
		RegVal = "(CodOpe+NroVou=Llave)"
		xOrden = "VMOV02"
ENDCASE
IF UltTecla = Escape_
	=Terminar() 
	RETURN
ENDIF
DO F0PRINT
IF UltTecla = Escape_
	=Terminar() 
	RETURN
ENDIF
*!* APERTURANDO ARCHIVOS *!*
RESTORE FROM LoContab.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE

*!*	DO MOVApert IN (xPrg)
IF !LoContab.MOVApert()
	=Terminar() 
	RETURN
ENDIF
SELECT VMOV
SET ORDER TO (xOrden)
SEEK LLAVE
IF !FOUND() AND RECNO(0)>0
	GO RECNO(0)
ENDIF
RegIni = RECNO()
SET DEVICE TO PRINT
PRINTJOB
	GOTO RegIni
	NumLin  = 0
	Largo  = 33
	LinFin = Largo - 6
	NumPag = 0
	TfDebe = 0
	TfHber = 0
	DO WHILE ! EOF() .AND. &RegVal
		XsNroMes = NroMes
		XsNroAst = NroAst
		IF &Valido
			DO MOVPRINT &&IN (xPrg)
		ENDIF
		SELECT VMOV
		SKIP
	ENDDO
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO f0PRFIN &&IN f0PRINT
=Terminar() 
RETURN
****************
FUNCTION vCodOpe
****************
PARAMETERS IngresoEgreso

SELE OPER
UltTecla = LASTKEY()
IF UltTecla = F8
	IF !CBDBUSCA("OPER")
		UltTecla = 0
		RETURN .F.
	ENDIF
	XsCodOpe = OPER->CodOpe
	UltTecla = ENTER
ENDIF
SEEK XsCodOpe 
IF !FOUND() &&AND !EMPTY(XsCodOpe)
	GsMsgErr = "Operación "+XsCodOpe+" no registrada"
	DO LIB_MERR WITH 99
	RETURN .F.
ENDIF
@ 10,50 say OPER.NomOpe PICT "@S20"
RETURN .T.
*********************
FUNCTION CierraTablas
*********************
IF USED('VMOV')
	USE IN VMOV
ENDIF
IF USED('RMOV')	
	USE IN RMOV
ENDIF
IF USED('OPER')	
	USE IN OPER
ENDIF
*****************	
FUNCTION Terminar
*****************
RELEASE LoContab
=CierraTablas()
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
SYS(2700,1)  
******************
PROCEDURE MovPrint
******************
PARAMETERS __Nromes,__CodOpe,__NroAst
IF PARAMETERS() = 0  && Ya Debe estar abierta las Tablas VMOV y RMOV
	IF !USED('VMOV')
		=MESSAGEBOX('No estan abiertas las tablas VMOV y RMOV',16,'ATENCION !!!')
		RETURN 
	ENDIF
	__NroMes	=	VMOV.NroMes
	__CodOpe	=	VMOV.CodOpe
	__NroAst	=	VMOV.NroAst
ENDIF
LsLlave=__NroMes+__CodOpe+__NroAst
TfDebe = 0
TfHber = 0
SELECT RMOV
SEEK LsLLave
	DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF()
*!*			IF Import = 0 .OR. EliItm = "ú"
*!*			IF Import = 0 .OR. EliItm = "*"   
		IF Import = 0
			SKIP
			LOOP
		ENDIF
		DO INIPAG
		LinAct = PROW() + 1
		=SEEK(ClfAux+CodAux,"AUXI")
		DO CASE
			CASE ! EMPTY(RMOV->Glodoc)
				LsGlodoc = RMOV->GloDoc
			CASE ! EMPTY(VMOV->NotAst)
				LsGlodoc = VMOV->NotAst
			OTHER
				LsGlodoc = AUXI->NOMAUX
		ENDCASE
		LsGloDoc=TRIM(LsGloDoc)
		LenGloDoc=LEN(LsGloDoc)
		LenGloDoc=43
		IF VMOV->CodMon <> 1
			LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"###,###.##"))+")"
			IF RIGHT(LsImport,4)=".00)"
				LsImport = ' (US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###"))+")"
			ENDIF
			LsGloDoc = LEFT(PADR(LsGloDoc,LenGloDoc),LenGloDoc-LEN(LsImport))+LsImport
		ENDIF
		@ LinAct,6 SAY "|"  
		@ LinAct,0  SAY _PRN4
		@ LinAct,08 SAY LsGloDoc    PICT "@S50" font 'small font' , 8
		@ LinAct,0  SAY _PRN2
		@ LinAct,44+2 SAY TRIM(CodCta)   && font 'Courier New',6
		@ LinAct,50+3 SAY NroDoc   && font 'Courier New',6
		@ LinAct,60+4 SAY NroRef   && font 'Courier New',6
		IF TpoMov = "D"
			@ LinAct,70 SAY Import PICT "9,999,999.99"
			TfDebe = TfDebe + Import
		ELSE
			@ LinAct,85 SAY Import PICT "9,999,999.99"
			TfHber = TfHber + Import
		ENDIF
		@ LinAct,99 SAY "|"
		SKIP
	ENDDO
	IF NumPag = 0
		DO INIPAG
	ENDIF
	IF PROW() > Largo - 13
		DO INIPAG WITH .T.
	ENDIF
	LinAct = PROW() + 1
	@ LinAct,6  SAY "---------------------------------------------------------------------------------------------+"
	LinAct = PROW() + 1
	@ LinAct,50 SAY "TOTAL S/."
	@ LinAct,64 SAY "|"
	@ LinAct,70 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,84 SAY "|"
	@ LinAct,85 SAY TfHber PICT "9,999,999.99"
	@ LinAct,99 SAY "|"
	LinAct = PROW() + 1
	@ LinAct,64 SAY "-----------------------------------+"
	LinAct = Largo - 10
	@ LinAct+1,6  SAY "+--------------------------------------------------------------------------------------------+"
	@ LinAct+2,6  SAY "|      PREPARADO      |      REVISADO       |    AUTORIZACION     |       VoBo               |"
	@ LinAct+3,6  SAY "---------------------------------------------------------------------------------------------|"
	@ LinAct+4,6  SAY "|                     |                     |                     |                          |"
	@ LinAct+5,6  SAY "|                     |                     |                     |                          |"
	@ LinAct+6,6  SAY "+--------------------------------------------------------------------------------------------+"
SELECT VMOV
RETURN
****************
PROCEDURE INIPAG
****************
PARAMETER SaltoPag
IF TYPE("SalToPag")<>"L"
	SalToPag = .T.
ENDIF
IF ! (NumPag = 0 .OR. PROW() > LinFin .or. SaltoPag)
	RETURN
ENDIF
IF NumPag > 0
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VAN ....."
	@ LinAct,70 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,85 SAY TfHber PICT "9,999,999.99"
	LinAct = PROW() + 1
	@ LinAct,6  SAY "+--------------------------------------------------------------------------------------------+"
ENDIF
NumPag = NumPag + 1
XsHoy='Lima, '+DIA(VMOV->FchAst,3)+' '+STR(DAY(VMOV->FchAst),2)+' de '+MES(VMOV->FchAst,3)+' de '+STR(YEAR(VMOV->FchAst),4)
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")
SET MEMO TO 78
Dato1 = mline(VMOV->GLOAST,1)
Dato2 = mline(VMOV->GLOAST,2)
Dato3 = mline(VMOV->GLOAST,3)
Dato4 = mline(VMOV->GLOAST,4)
@  0,0  SAY _PRN0+_PRN5A+CHR(LARGO)+_PRN5B+_PRN2
@  0,6  SAY _PRN7A+TRIM(GsNomCia)
@  0,0  SAY _PRN7B
@  0,68 SAY _PRN7A+"No:"+VMOV->CODOPE+[-]+VMOV->NroAst+_Prn7b  font 'Courier New',10 STYLE 'B'
@  2,0  SAY _PRN7A+PADC("VOUCHER DE CAJA INGRESOS",47)+_PRN7B
@  3,6  SAY "+--------------------------------------------------------------------------------------------+"
@  4,6  SAY "|"
@  4,8  SAY XsHoy
@  4,76 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@  4,79 SAY VMOV->ImpChq PICT "***,***,***.**"
@  4,99 SAY "|"
@  5,06 SAY "|"
@  5,76 SAY "T/C. "+TRANSF(VMOV->TPOCMB,"999,999.9999")
@  5,99 SAY "|"
@  6,6  SAY "+--------------------------------------------------------------------------------------------+"
@  7,6  SAY "|"+PADC(Dato1,92)+"|"
@  8,6  SAY "|"+PADC(Dato2,92)+"|"
@  9,6  SAY "|"+PADC(Dato3,92)+"|"
@ 10,6  SAY "| "+PADR("CUENTA No: "+CTAS->NROCTA,91)+"|"
@ 11,6  SAY "| "+PADR("BANCO    : "+TABL->Nombre,91)+"|"
@ 12,6  SAY "+--------------------------------------------------------------------------------------------+"
@ 13,6  SAY "|      C O N C E P T O                  |CUENTA|DOCUMENTO|REFERENC.|     DEBE     |    HABER |"
@ 14,6  SAY "+--------------------------------------------------------------------------------------------+"

IF NumPag > 1
	LinAct = PROW() + 1
	@ LinAct,50 SAY "VIENEN..."
	@ LinAct,70 SAY TfDebe PICT "9,999,999.99"
	@ LinAct,85 SAY TfHber PICT "9,999,999.99"
ENDIF
RETURN

