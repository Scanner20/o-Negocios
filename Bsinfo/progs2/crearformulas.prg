CLOSE TABLES all
goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
goentorno.open_dbf1('ABRIR','ALMTGSIS','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CPICFPRO','CFPRO','CFPR01','')
goentorno.open_dbf1('ABRIR','CPIDFPRO','DFPRO','DFPR01','')

SELECT 0
USE  o:\o-negocios\update\modelos ALIAS MODELOS
SET ORDER TO CDMODELO   && UPPER(CDMODELO)
*
SELECT 0
USE o:\o-negocios\update\formulas_ago_2010 ALIAS NEWFOR

LnIndMaxLong	= ALEN(GaLenCod)
LnMaxLong		= GaLenCod[LnIndMaxLong]

IF SEEK('CM'+GaClfDiv(LnIndMaxLong),'TABL')
	LcTipoCorrelativo = TABL.Respon
ELSE
	LcTipoCorrelativo = '1'
ENDIF


SELECT Modelos
SCAN 
	XsCodPro=CodPro
	SELECT CATG
	SEEK XsCodPro
	IF !FOUND()
		XsCodPro = GetNewCod('1','0199  ')
		IF !EMPTY(XsCodPro)
			=UPDCATG()
			SELECT CFPRO
			SEEK XsCodPro
			IF !FOUND()
				IF !SEEK(Modelos.CdModelo,'CFPRO','CFPR02')
					=NewCFPRO()
				ENDIF
			ELSE
				IF !SEEK(Modelos.CdModelo,'CFPRO','CFPR02')
					=NewCFPRO()
				ENDIF
			ENDIF
			SELECT MODELOS
			REPLACE CodPro WITH XsCodPro
		ENDIF
	ELSE
		=UPDCATG()
		SELECT CFPRO
		SEEK XsCodPro
		IF !FOUND()
			IF !SEEK(Modelos.CdModelo,'CFPRO','CFPR02')
				=NewCFPRO()
			ENDIF
		ELSE
			IF !SEEK(Modelos.CdModelo,'CFPRO','CFPR02')
				=NewCFPRO()
			ENDIF
		ENDIF
	ENDIF
	** Ahora Cargamos el detalle de la formula modelo
	SELECT DFPRO
    SEEK XsCodPro
    DELETE REST WHILE CodPro==XsCodPro
	SELECT NewFor
	SCAN 
		LsCmpMod = Modelos.Modelo
		LfCanReq = EVALUATE(LsCmpMod)
		IF VARTYPE(LfCanreq)='N' AND LfCanReq <> 0
			SELECT DFPRO
			APPEND BLANK
			REPLACE CodPro WITH XsCodPro
			REPLACE CodMat WITH NewFor.CodMat
			REPLACE SubAlm WITH '002'  && Materia Prima 
			REPLACE CanReq WITH LfCanReq
			REPLACE UndPro WITH 'KGS'
			REPLACE UndStk WITH 'KGS'
			REPLACE FacEqu WITH 1
			replace CodUser WITH goEntorno.User.Login
			** Log data
			replace UsrNew WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1))
			replace FchNew WITH DATETIME()
		ENDIF
		SELECT NewFor
	ENDSCAN 
	SELECT MODELOS
ENDSCAN

FUNCTION GetNewCod
PARAMETERS LcTipoCorrelativo,LcFiltroDivFam
LcTabla_Remota='CATG'
LcCmps_ID	= 'CodMat'
LcCampo_id	= 'CodMat'

XsValue =''
		DO CASE 
			CASE LcTipoCorrelativo = '1'
				Xsvalue=goSvrCbd.odatadm.cap_nroitm(LcFiltroDivFam ,Lctabla_remota,LcCmps_ID,LcCampo_id,,GnLenDiv,LnMaxLong )
			CASE LcTipoCorrelativo = '2'	
				Xsvalue=goSvrCbd.odatadm.cap_nroitm(''             ,Lctabla_remota,''       ,LcCampo_id,,GnLenDiv,LnMaxLong )  && Longitud Maxima por Familia
			CASE LcTipoCorrelativo = '3'	
				*** Esto funciona pero trae el correlativo aumentado en 1 , sirve cuando lo sacamos
				*** directamente de la tabla a actualizar, no de un maestro de correlativos
*!*					this.value=.oData.Cap_NroItm('CODIG' ,'CORR','TIPO','NUMERO') 
				x=goSvrCbd.odatadm.gencursor("C_Corr_CodMat","CORR",'',[TIPO],'CODIG',,'')
				LsPict = "@L "+REPLICATE('9',LnMaxLong - GnLenDiv)
				XsValue = TRANSFORM(C_Corr_CodMat.Numero,LsPict)
				goSvrCbd.odatadm.closetable("C_Corr_CodMat") 
		ENDCASE 
		IF VARTYPE(XsValue)='C'
			XsValue=TRIM(XsValue)
*!*				this.Value=VAL(THIS.Value)
*!*				this.Value=transform(this.Value)
			XsValue=IIF(LcTipoCorrelativo # '1',LcFiltroDivFam+XsValue,XsValue )                   					
		ENDIF	
RETURN XsValue

FUNCTION NewCFPRO
APPEND BLANK IN CFPRO
REPLACE CodPro WITH XsCodPro IN CFPRO
REPLACE Modelo WITH .T. IN CFPRO
REPLACE CdModelo WITH Modelos.CdModelo IN CFPRO
REPLACE UDPeso WITH 'KGS' IN CFPRO
REPLACE CodUser WITH goEntorno.User.Login IN CFPRO
REPLACE FchHora WITH DATETIME() IN CFPRO
REPLACE FchCmb  WITH DATETIME() IN CFPRO
Replace UsrCmb  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN CFPRO
REPLACE FchNew  WITH DATETIME() IN CFPRO
Replace UsrNew  WITH ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1)) IN CFPRO

FUNCTION UPDCATG
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
