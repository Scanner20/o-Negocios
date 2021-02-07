*!*	PARAMETERS cFormulario
*!*	IF PARAMETERS()=0
*!*		MESSAGEBOX('Indicar el numero o codigo de formulario correspondiente segun lo indican en el PDT.'+;
*!*					' Ejemplo : 0621 -> Importacion de recibo por honorarios',16,'ATENCION !!' )
*!*		RETURN
*!*		
*!*	ENDIF
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
*!*	DO CASE 
*!*		CASE cFormulario='0621R'
*!*		CASE cFormulario='0621P'
*!*		CASE cFormulario='0621L'
*!*		CASE cFormulario='0621'
*!*			cTit4 = "GENERAR INFORMACION DE RECIBOS PARA EL PDT"
*!*		
*!*	ENDCASE

XdFchAst = DATE()
XsNombre =[]
XxImp=0
XsCodAux = SPACE(11)
XsCodDiv = SPACE(3)
XsNomDiv = []
XsCodRef = []
XsNroAst = []
XsClfAux = []
XnFormat = 1
XcEliItm = '*'

***

XsNroMes = TRANSFORM(_Mes,"@L ##")
XsCodOpe = SPACE(3)
CsCodCco =  '' 
XiCodMon = 1   
XnOrden  = 2 
XsRutaArchivo = ''
LcRutaArcTxtVMOV = ''
LcRutaArcTxtRMOV = ''
LcRutaFileVmov = ''
LcRutaFileRmov = '' 

LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNDMOVM','DMOV','VMOV01','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
DO CASE
	CASE XsCodPln = '1'
		LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV1'
	CASE XsCodPln = '2'
		LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV2'
	CASE XsCodPln = '3'
		LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV3'
	CASE XsCodPln = '4'
		LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNTMOV4','TMOV','TMOV01','')
		XsTabMov = 'PLNTMOV4'
ENDCASE
LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','SEMA','SEMA01','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')


DO FORM PLN_Txt_Reloj_2_DMOV

RETURN
*******************************
PROCEDURE Migrar_Archivo_Txt_2_DMOV
*******************************
#include const.h
PARAMETERS LcRutaTxtDMOV
LcFile=ADDBS(SYS(2023))+'LogPlnReloj.txt' 
=STRTOFILE('****  REGISTRO DE ERRORES AL CARGAR ASISTENCIA DEL RELOJ  '+TTOC(DATETIME())+' *****  '+CRLF,LcFile,.T.)	
IF EMPTY(LcRutaTxtDMOV)
	MESSAGEBOX('No se ha indicado el archivo de texto con los registros de asistencia del reloj',16 ,'ATENCION!! /  WARNING !!')
	RETURN
ENDIF
LcRutaFileDmov = ADDBS(goentorno.locpath)+'ITXT_RELOJ.DBF'
IF USED('I_RELOJ')
	USE IN I_RELOJ
ENDIF	

IF !FILE(LcRutaFileDmov)
	
	DO CASE
		CASE GsSigCia='CISLA'
			** estrucutura PREVIA PARA TEMPUS 
			CREATE TABLE (LcRutaFileDmov) FREE ( ;
					TIPO C(1) ,;
					PERIODO C(7),;
					COD_TRAB C(7),;
					DIAS_DIUR C(7),;
	                DIAS_NOCT C(7),;
	                DIAS_FALT C(7),;
	                DOM_LABO  C(7),;
	                HEXT_25   C(7),;
	                HEXT_35   C(7),;
	                HEXT_100  C(7),;
	                MIN_TARD  C(7)  )
			USE	(LcRutaFileDmov)  ALIAS I_RELOJ EXCLUSIVE														      
	    OTHER            
			CREATE TABLE  (LcRutaFileDMOV)  FREE ( ; 
					TIPO		   C(1),;
					PERIODO       C(6),;
		                     COD_TRAB    C(6)  ,;
		                     DIAS_DIUR    N(3,0),;
		                     DIAS_NOCT   N(3,0),;
		                     DIAS_FALT    N(8,2),;
		                     DOM_LABO  N(8,2),;
		                     HEXT_25       N(8,2),;
		                     HEXT_35       N(8,2),;
		                     HEXT_100    N(8,2),;
		                     MIN_TARD   N(3,0)  )

			USE	(LcRutaFileDMOV)  ALIAS I_RELOJ EXCLUSIVE														      	                
	ENDCASE	                
ELSE
	SELECT 0
	USE (LcRutaFileDMOV)  ALIAS I_RELOJ EXCLUSIVE
	ZAP
ENDIF
SET STEP ON
APPEND FROM (LcRutaTxtDMOV) TYPE DELIMITED WITH CHARACTER ','				
INDEX ON PERIODO+COD_TRAB  TAG RELO01
SELECT I_RELOJ
SCAN FOR INLIST(Tipo,'1','2','3','4')
	LsCodPln    =	IIF(EMPTY(Tipo),GsCodPln,Tipo)
	LsANO		=	SUBSTR(GETWORDNUM(Periodo,1),1,4)
	LsNroPer	=	SUBSTR(GETWORDNUM(Periodo,1),5,2)
	LsCodPer	=	PADR(GETWORDNUM(Cod_Trab,1),LEN(PERS.CodPer))
	LnBA01      =   VAL(GETWORDNUM(DIAS_DIUR,1)) + VAL(GETWORDNUM(DIAS_NOCT,1)) && DIAS_DIUR + DIAS_NOCT
	LnBA02  	=   VAL(GETWORDNUM(DIAS_FALT,1))  && DIAS_FALT
	LnBB02		=	VAL(GETWORDNUM(HEXT_25,1))  && HEXT_25
	LnBB03		=	VAL(GETWORDNUM(HEXT_35,1))  && HEXT_35
	LnBB04		=	VAL(GETWORDNUM(HEXT_100,1)) && HEXT_100
	LnBBXX		=   VAL(GETWORDNUM(DOM_LABO,1))  && DOM_LABO
	LnBBYY		=	VAL(GETWORDNUM(MIN_TARD,1))  && MIN_TARD
	IF !SEEK(LsCodPer,'PERS')	
		=STRTOFILE(' Codigo de personal no esta registrado: ' +LsCodPer+CRLF,LcFile,.T.)	
		LOOP
	ENDIF
	WAIT WINDOW 'Procesando registro:' + LsCodPer + ' '+ TRIM(Pers.NomPer)  NOWAIT
	LsCodMov = 'BA01'  && Dias trabajados
	IF LnBA01>0
		SELECT DMOV
		SEEK LsCodPln + LsNroPer + LsCodPer + LsCodMov 
		IF !FOUND()
			APPEND BLANK 
			REPLACE CodPln WITH LsCodPln, NroPer WITH LsNroPer , CodPer WITH LsCodPer,  CodMov WITH LsCodMov
		ENDIF
		REPLACE ValCal WITH LnBA01, FlgEst WITH 'R'
		REPLACE FlgRec WITH 'I', FchEmi WITH DATE() , NroRec WITH TIME(), NroAst WITH GoEntorno.User.Login
	ENDIF
	LsCodMov = 'BA02'   && Dias faltas
	IF LnBA02>0
		SELECT DMOV
		SEEK LsCodPln + LsNroPer + LsCodPer + LsCodMov 
		IF !FOUND()
			APPEND BLANK 
			REPLACE CodPln WITH LsCodPln, NroPer WITH LsNroPer , CodPer WITH LsCodPer,  CodMov WITH LsCodMov
		ENDIF
		REPLACE ValCal WITH LnBA02, FlgEst WITH 'R'
		REPLACE FlgRec WITH 'I', FchEmi WITH DATE() , NroRec WITH TIME(), NroAst WITH GoEntorno.User.Login
	ENDIF
	IF LnBB02>0
		LsCodMov = 'BB02'  && Horas extras 25 %
		SELECT DMOV
		SEEK LsCodPln + LsNroPer + LsCodPer + LsCodMov 
		IF !FOUND()
			APPEND BLANK 
			REPLACE CodPln WITH LsCodPln, NroPer WITH LsNroPer , CodPer WITH LsCodPer,  CodMov WITH LsCodMov
		ENDIF
		REPLACE ValCal WITH LnBB02, FlgEst WITH 'R'
		REPLACE FlgRec WITH 'I', FchEmi WITH DATE() , NroRec WITH TIME(), NroAst WITH GoEntorno.User.Login
	ENDIF
	
	IF LnBB03>0
		LsCodMov = 'BB03' && Horas extras 35 %
		SELECT DMOV
		SEEK LsCodPln + LsNroPer + LsCodPer + LsCodMov 
		IF !FOUND()
			APPEND BLANK 
			REPLACE CodPln WITH LsCodPln, NroPer WITH LsNroPer , CodPer WITH LsCodPer,  CodMov WITH LsCodMov
		ENDIF
		REPLACE ValCal WITH LnBB03, FlgEst WITH 'R'
		REPLACE FlgRec WITH 'I', FchEmi WITH DATE() , NroRec WITH TIME(), NroAst WITH GoEntorno.User.Login
	ENDIF
	IF LnBB04>0
		LsCodMov = 'BB04'  && Horas extras 100 %
		SELECT DMOV
		SEEK LsCodPln + LsNroPer + LsCodPer + LsCodMov 
		IF !FOUND()
			APPEND BLANK 
			REPLACE CodPln WITH LsCodPln, NroPer WITH LsNroPer , CodPer WITH LsCodPer,  CodMov WITH LsCodMov
		ENDIF
		REPLACE ValCal WITH LnBB04, FlgEst WITH 'R'
		REPLACE FlgRec WITH 'I', FchEmi WITH DATE() , NroRec WITH TIME(), NroAst WITH GoEntorno.User.Login
	ENDIF
	SELECT I_RELOJ
ENDSCAN
WAIT WINDOW 'Proceso terminado' NOWAIT

**********************************************
PROCEDURE Migrar_Cobranzas_Isla
********************************************** 
PARAMETERS LcRutaTxtVMOV,LcRutaTxtRMOV,PsCodOpe


IF EMPTY(LcRutaTxtVMOV)
	MESSAGEBOX('No se ha indicado el archivo de texto con los registros de la cabecera',16 ,'ATENCION!! /  WARNING !!')
	RETURN
ENDIF

IF EMPTY(LcRutaTxtRMOV)
	MESSAGEBOX('No se ha indicado el archivo de texto con los registros de el detalle',16 ,'ATENCION!! /  WARNING !!')
	RETURN
ENDIF

LcRutaFileVmov = ADDBS(goentorno.locpath)+'Intf_VMOV.DBF'
LcRutaFileRmov = ADDBS(goentorno.locpath)+'Intf_RMOV.DBF'
IF USED('I_VMOV')
	USE IN I_VMOV
ENDIF	
IF USED('I_RMOV')	
	USE IN I_RMOV
ENDIF
IF !FILE(LcRutaFileVMOV)
	SELECT 0
	CREATE TABLE  (LcRutaFileVMOV)  FREE ( GLO_MES C(2), ;
															      GLO_TIPO C(2), ;
															      GLO_OPER C(2), ;
															      GLO_NUMERO C(6), ;
															      GLO_FECHA D, ;
															      GLO_DESCRI C(40), ;
															      GLO_CAMBIO N(1),  ;
															      GLO_MONEDA  c(1), ;
															      GLO_LINEAS n(3), ;
															      GLO_MONDEB n(9,2), ;
															      GLO_MONHAB n(9,2), ;
															      GLO_DOLDEB n(9,2), ;
															      GLO_DOLHAB n(9,2), ;
															      GLO_USUARI C(6), ;
															      GLO_DELETE c(6), ;
															      GLO_CODIGO C(2), ;
															      GLO_TIPDOC  C(2), ;
															      GLO_NROSER C(4),  ;
															      GLO_NRODOC C(10) ,  ;
															      GLO_IMPORT  N(8,2), ;
															      GLO_AFAVOR C(2), ;
															      GLO_BANCO C(3), ;
															      GLO_DIFER C(2),;
															      GLO_DATE	 D, ;
															      GLO_TIME  C(8), ;
															      GLO_USUA C(6) )
     USE	(LcRutaFileVMOV)  ALIAS I_VMOV EXCLUSIVE														      
									      
ELSE
	SELECT 0
	USE (LcRutaFileVMOV)  ALIAS I_VMOV EXCLUSIVE
	ZAP
ENDIF
APPEND FROM (LcRutaTxtVMOV) TYPE DELIMITED WITH CHARACTER ','				
INDEX ON GLO_MES+GLO_OPER+GLO_NUMERO TAG ASIENTO

IF !FILE(LcRutaFileRMOV)
	SELECT 0
	CREATE TABLE  (LcRutaFileRMOV)  FREE (                       VOU_MES C(2), ;
															     VOU_TIPO C(2), ;
															      VOU_OPER C(2), ;
															      VOU_NUMERO C(6), ;
															      VOU_LINEA n(3),  ;
															      VOU_CUENTA C(6), ;
															      VOU_CODIGO C(3), ;
															      VOU_TIPDOC C(2), ;
															      VOU_SERIE    C(3), ;
															      VOU_NRODOC C(6), ;
															      VOU_FECDOC D, ;
															      VOU_FECVEN D, ;
															      VOU_MONTO N(9,2), ;
															      VOU_DOLAR  N(9,2), ;
															      VOU_DH          C(1),  ;
															      VOU_TRANSF C(1) ,  ;
															      VOU_FECHA D, ;
															      VOU_COSTO C(5), ;
															      VOU_CONCI C(5), ;
															      VOU_NRORE C(5) , ;
															      VOU_DESCRI C(10)	, ;
															      VOU_MONEDA C(1), ;
															      VOU_CAMBIO  N(1),  ;
															     VOU_COMBO C(1), ;
															     VOU_CC C(1), ;
															     VOU_CAJA C(1) , ;
															     VOU_DATE D, ;
															     VOU_TIME C(8), ;
															      VOU_USUA C(6),;
															      VOU_PARTID C(6) )
	
	USE (LcRutaFileRMOV)  ALIAS I_RMOV EXCLUSIVE															      
ELSE
	SELECT 0
	USE (LcRutaFileRMOV)  ALIAS I_RMOV EXCLUSIVE
	ZAP
ENDIF
APPEND FROM (LcRutaTxtRMOV) TYPE DELIMITED WITH CHARACTER ','				
INDEX ON VOU_MES+VOU_OPER+VOU_NUMERO TAG ASIENTO

SELECT I_VMOV
SCAN  FOR !GLO_MES='GL'
	XsNromes  =  GLO_MES
       XsNroAst   =   GLO_NUMERO
       XdFchast  =    GLO_FECHA 
       XsNotAst  =    GLO_DESCRI 
       XfTpoCmb  = GLO_CAMBIO
       XsUsuario =  GLO_USUA
       
       DO xACT_CTB WITH PADL(GLO_OPER,3,'0')
       SELECT I_VMOV
ENDSCAN
WAIT WINDOW 'PROCESO TERMINADO' NOWAIT 
*!*	DO ctb_cier
*******************************
PROCEDURE xACT_CTB
*******************************
PARAMETERS PsCodOpe
PRIVATE DirCtb,UltTecla && _MES,_ANO,
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XfImport,XdFchDoc,XdFchVto
PRIVATE XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,TsCodDiv1  &&XsCodOpe,XsNroMes,XsNroAst,
PRIVATE XiNroItm,XsCodDiv,XsCtaPre,XcAfecto,XsCodCco,GlInterface,XsCodDoc,XsNroDoc 
PRIVATE XsNroRef,XsCodFin,XdFchdoc,XdFchVto,XsIniAux,XdFchPed,NumCta,XsNivAdi
PRIVATE XcTipoC,XsTipDoc,XsAn1Cta,XsCc1Cta,XsChkCta, nImpUsa, nImpNac,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = ''
** Valores variables inicializados como STRING
dimension vcodcta(10)
STORE {} TO XdFchDoc,XdFchVto,XdFchPed
STORE '' TO XsCodCco ,XsCodDoc,XsNroDoc,XsNroRef,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta,XsNroRuc
** Valores variables inicializados como NUMERO
STORE 0 TO nImpNac,nImpUsa,NumCta


*********
XsCodOpe = PsCodOpe
SELE OPER
SEEK XsCodOpe
DO CASE
	CASE XsCodOpe = '021'
		LsNomOpe = 'COBRANZAS SOCIOS'
		LsSiglas      = 'COBRANZ. SOC.'
	CASE XsCodOpe = '072'
		LsNomOpe = 'PROVISION CUOTAS Y OTROS CARGO'
		LsSiglas      = 'PROV. CUOTAS' 
	OTHERWISE
		LsNomOpe = 'POR DEFINIR'
		LsSiglas      = 'POR DEFINIR' 
ENDCASE
LlOrigen		= .T.
LnCodmon	= 3
LnTpoCmb	= 2
LnTpoCor 		= 1
LnLen_Id		= 8	
IF !FOUND()
	APPEND BLANK
	REPLACE CodOpe WITH XsCodOpe, NomOpe WITH LsNomOpe, Origen WITH LlOrigen, TpoCmb WITH LnTpoCmb, ; 
	TpoCor WITH TpoCor, Len_Id WITH LnLen_Id
	REPLACE Ndoc00 WITH 1,Ndoc01 WITH 1,Ndoc02 WITH 1,Ndoc03 WITH 1,Ndoc04 WITH 1,Ndoc05 WITH 1,Ndoc06 WITH 1,Ndoc07 WITH 1,;
	Ndoc08 WITH 1,Ndoc09 WITH 1,Ndoc10 WITH 1,Ndoc11 WITH 1,Ndoc12 WITH 1,Ndoc13 WITH 1
ELSE
*!*		REPLACE NomOpe WITH LsNomOpe, Origen WITH LlOrigen, TpoCmb WITH LnTpoCmb, ; 
*!*		TpoCor WITH TpoCor, Len_Id WITH LnLen_Id 	
ENDIF
IF !REC_LOCK(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN
ENDIF
SELECT I_VMOV
IF !EMPTY(I_VMOV.GLO_OPER) AND !EMPTY(GLO_Numero) AND !EMPTY(GLO_MES)
	XsNroMes  = GLO_MES
	XsCodOpe = PsCodOpe
	XsNroAst    = XsNroMes+GLO_Numero
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
SELECT I_VMOV
=SEEK(DTOS(GLO_FECHA),'TCMB')
XdFchAst	= GLO_FECHA
XsNroVou	= ''
XiCodMon	= IIF(GLO_MONEDA='S',1,IIF(GLO_MONEDA='D',2,0)  )
XfTpoCmb	= GLO_CAMBIO
XsNotAst	= GLO_DESCRI
m.Err= GOSVRCBD.MovGraba(XsNroMes,XsCodOpe,@XsNroAst)
SELECT I_VMOV
IF m.Err>=0
** ACTUALIZAR DATOS DE CABECERA **
	REPLACE GLO_USUA WITH goentorno.user.login
ELSE
	REPLACE GLO_USUA WITH '**Error**'
	GoSvrCbd.MensajeErr(m.Err)
	RETURN
ENDIF
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
SELE I_RMOV
SEEK I_VMOV.GLO_MES+I_VMOV.GLO_OPER+I_VMOV.GLO_NUMERO
DO WHILE !EOF() .AND. VOU_MES+VOU_OPER+VOU_NUMERO = I_VMOV.GLO_MES+I_VMOV.GLO_OPER+I_VMOV.GLO_NUMERO
	IF !INLIST(I_RMOV.VOU_MES, '01','02','03','04','05','06','07','08','09','10','11','12')
		SKIP 
		LOOP
	ENDIF
*!*	   =SEEK([NA]+RDOC.Codigo,"TABLA")
*!*		IF I_RMOV.VOU_LINEA=30
*!*			SET STEP ON 
*!*		ENDIF 
	XsCodCta = I_RMOV.VOU_CUENTA
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	DO CASE
		CASE !SEEK(XsCodCta,"CTAS") AND !EMPTY(XsCodCta)
			IF MESSAGEBOX('Cuenta ['+XsCodCta+'] '+ 'no existe desea crearla',32+4 ,'¡ ATENCION / WARNING !' ) = 6
				SELECT CTAS
				APPEND BLANK 
				REPLACE CodCta WITH XsCodCta, NomCta WITH 'FALTA NOMBRE', AftMov WITH 'S',NivCta  WITH 5, TpoCta WITH 1, TpoMov WITH 'D',CodMon WITH 1
				IF INLIST(CodCta,'12','16','17')
					REPLACE  ClfAux WITH 'SOC',PIDAUX WITH 'S',PIDDOC WITH 'S'
				ENDIF
				SELECT I_RMOV
				=SEEK(XsCodCta,"CTAS")
			ENDIF
	CASE  EMPTY(XsCodCta)		
			XsCodCta = 'XXXXXX'  && Cuenta Invalida
	CASE FOUND("CTAS")
			IF EMPTY(CTAS.ClfAux) OR EMPTY(CTAS.PidAux) OR EMPTY(CTAS.PidDoc)	AND !EMPTY(I_RMOV.VOU_CODIGO) AND !INLIST(I_RMOV.VOU_CUENTA,'10')
		   		REPLACE ClfAux WITH 'SOC',PIDAUX WITH 'S',PIDDOC WITH 'S' IN CTAS
		   	ENDIF
	ENDCASE
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	IF CTAS.PidAux=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = I_RMOV.VOU_CODIGO
	ENDIF
	XcTpoMov = I_RMOV.VOU_DH    && << OJO <<
	XfImport =  I_RMOV.VOU_MONTO
	XiCodMon	= VMOV.CodMon
	XfTpoCmb	= VMOV.TpoCmb
	IF XiCodMon = 1
   		XfImpNac = XfImport
  		IF XfTpoCmb>0
			 XfImpUsa =  I_RMOV.VOU_DOLAR    && ROUND(XfImport/XfTpoCmb,3)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = I_RMOV.VOU_DOLAR  && XfImport
		XfImpNac = I_RMOV.VOU_MONTO && ROUND(XfImpUsa*XfTpoCmb,3)
	ENDIF
	XsCodDoc = SPACE(LEN(RMOV.CodDoc))
	XsNroDoc = SPACE(LEN(RMOV.NroDoc))
	XsNroRef = SPACE(LEN(RMOV.NroDoc))
	XsClfAux = SPACE(LEN(RMOV.ClfAux))
	IF CTAS.PidDoc=[S]
		XsClfAux = CTAS.ClfAux
		XsCodDoc =   ""  &&IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')   && GDOC.CodDoc
		XsNroDoc =  I_RMOV.VOU_NRODOC
		XdFchDoc = I_RMOV.VOU_FECDOC
		XdFchVto  = I_RMOV.VOU_FECVEN
		XsNroRef = []  && GDOC.NroDoc
	ENDIF
   	XiNroItm = I_RMOV.VOU_LINEA
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
	XiNroItm = XiNroItm + 1
	SELE I_RMOV
	SKIP
ENDDO
RETURN
