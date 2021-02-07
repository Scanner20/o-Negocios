CLOSE TABLES all
SET DELETED ON
LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')


SELECT 0
USE p0012007!almdtran ALIAS dtra order dtra04
SELECT 0
USE p0012007!almCtran ALIAS Ctra order Ctra01
SELECT 0
USE p0012007!almCatge ALIAS CATG order CATG01
SELECT 0
USE p0012007!almCatal ALIAS CALM order CATA01
SELECT 0
USE p0012007!almdlote ALIAS LOTE order DLOTE01
SELECT 0
USE ccbrgdoc ALIAS gdoc order gdoc08
SELECT 0
USE vtaritem ALIAS DETA ORDER item01
SELECT 0
USE vtaritem ALIAS DETA2 ORDER item01 AGAIN


*** Creamos temporales de Cab y Det de almacen
LoDatAdm.abrirtabla('TEMP_STR','DTRA','C_DTRA','','')
*LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','DesMat','C',LEN(CATG.DesMat),0)
LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','UndStk','C',LEN(CATG.UndStk),0)
LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','NroReg','N',6,0)
LoDatAdm.abrirtabla('TEMP_STR','CTRA','C_CTRA','','')

SELECT c_DTRA
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC

*!*	APPEND FROM DBF('DTRA') FOR tporef='FACT' OR tporef='BOLE' AND DTOS(fchdoc)='20060602'
*!*	SET STEP ON 
SELECT GDOC
SEEK '2007'
SCAN WHILE  DTOS(FchDoc)>='2007' FOR INLIST(CodRef,'FREE','G/R') AND FlgEst<>'A'
	WAIT WINDOW DTOC(FchDoc)+' ' + COdDOc+ ' ' + NroDoc NOWAIT 
	SCATTER MEMVAR field EXCEPT  CodOpe,NroAst	
	DO case
		CASE CodDoc='FACT'
			m.CodMov='Y01'
		CASE CODDOC='BOLE'
			m.CodMov='Y02'	
	ENDCASE
	m.TipMov = 'S'
	m.CodSed = GsCodSed
	m.TpoRf1 = IIF(CodRef='FREE',m.CodDoc,CodRef)
	m.NroRf1 = m.NroDoc
	m.Observ = ''
	m.Motivo = 1
	m.coduser ='VETT'
	m.fchhora = DATETIME()
	LsLLave=CodDoc+NroDoc
	m.NroDoc = LEFT(CodDoc,1)+SUBSTR(m.nrodoc,2)
	
*!*		IF SEEK(m.TpoRf1+m.NroRf1,'DTRA','DTRA04')
*!*			DELETE REST WHILE TpoRef+NroRef=m.TpoRf1+m.NroRf1 IN DTRA
*!*	    ELSE
*!*	    	
*!*		ENDIF

		
	m.NroItm = 0
	DECLARE aGuias[1]
	STORE '' TO aGuias
	IF CodRef='G/R' AND EMPTY(NroRef) AND AT(',',Glosa2,2)>0
		=ChrToArray( Glosa2, ',' , @aguias )
		
	ENDIF
	SELECT DETA
	SEEK LsLlave
	SCAN WHILE CodDoc+NroDoc=LsLlave    FOR !EMPTY(CodMat)
		IF coddoc+nrodoc='FACT0200009441'
*			SET STEP ON 
		ENDIF
		LsSubAlm = SubAlm		
		IF EMPTY(Subalm) AND INLIST(GDOC.CodRef,'FREE','G/R') AND !EMPTY(CodMat)
			LPrimera =.f.
			SELECT CALM
			SET ORDER TO CATA02  && CodMat+ SubAlm
			SEEK PADR(DETA.CodMat,LEN(CALM.CodMat))
			SCAN WHILE codmat = PADR(DETA.CodMat,LEN(CALM.CodMat)) &&FOR INLIST(Subalm,'001','002')
				IF !lprimera
					LsSubAlm =SubAlm
					lPrimera = .t.
				ENDIF
				SELECT deta
				=RLOCK('DETA')
				replace nroser WITH IIF(EMPTY(Nroser),TRIM(nroser)+CALM.Subalm,TRIM(nroser)+','+CALM.SubAlm) IN 'DETA'
				UNLOCK IN 'DETA'
				SELECT CALM
			ENDSCAN
			SELECT DETA
		ENDIF
		SCATTER memvar	field EXCEPT nrorf1,NroRef,NroItm,CodOpe,NroAst	
		m.SubAlm = LsSubAlm
		m.Factor = 1
		m.ImpCto = m.ImpLin
		m.CanDes = m.CanFac
		m.Tporef = m.CodDoc
		m.NroDoc = LEFT(CodDoc,1)+SUBSTR(m.nrodoc,2)
		m.NroRef = m.NroDoc
		m.CodMat = PADR(CodMat,LEN(DTRA.CodMat))
		m.NroItm = m.NroItm + 1
		XtCanFac = 0
		SELECT deta2
		SEEK LsLLave
		SCAN WHILE CodDoc+NroDoc = LsLlave 
				IF CodMat=m.CodMat
					XtCanFac = XtCanFac + CanFac
				ENDIF 
		ENDSCAN	
		SELECT DETA
		
*!*		
*!*			
*!*			INSERT INTO DTRA FROM MEMVAR  	
*!*			IF !SEEK(m.SubAlm+m.TipMov+m.CodMov+m.NroDoc,'CTRA','CTRA01')
*!*				INSERT INTO Ctra FROM memvar 
*!*			ENDIF
	
		XtGuias = 0
		IF !EMPTY(aGuias)
			m.TpoRef = PADR('G/R',LEN(DTRA.TpoRef))
			FOR K = 1 TO ALEN(aGuias) 
				IF !EMPTY(aGuias(k))
					m.NroRef = PADR(aGuias(k),LEN(DTRA.NroRef))
					IF !SEEK(m.TpoRef+m.NroRef+m.CodMat,'DTRA','DTRA04')
						Loop	
					ELSE 
						XtGuias = XtGuias + DTRA.Candes
						IF XtGuias=XtCanFac
							EXIT 
						ENDIF	
					ENDIF
				ENDIF
			ENDFOR
			IF XtGuias<XtCanFac
				m.Candes = XtCanFac - XtGuias
				SELECT c_DTRA
				APPEND BLANK
				GATHER MEMVAR 
			ENDIF
		ELSE
			DO CASE
				CASE !EMPTY(NroRef)  && Con Guia
					m.TpoRef = PADR('G/R',LEN(DTRA.TpoRef))
					m.NroRef = PADR(NroRef,LEN(DTRA.NroRef))

				OTHERWISE  			 && Con Factura
				
			ENDCASE

			IF !SEEK(m.TpoRef+m.NroRef+m.CodMat,'DTRA','DTRA04')
				SELECT c_DTRA
				APPEND BLANK
				GATHER MEMVAR 
			ENDIF
		ENDIF	
		SELECT DETA				
	ENDSCAN	
	SELECT GDOC
ENDSCAN


RELEASE LoDatAdm
SELECT C_DTRA

*LnConTrol =	Grabar_Transaccion_Alm_X_ALM('C_DTRA','FREE')
SET ORDER TO DTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0)
*** Renumeramos Items 
LOCATE
DO WHILE !EOF()
	LsLlave = SubAlm+TipMov+CodMov+NroDoc
	TnNroItm=0
	SCATTER  memvar
	SCAN WHILE SubAlm+TipMov+CodMov+NroDoc = LsLlave
		tnNroItm = tnNroItm + 1
		replace NroItm WITH TnNroItm	
	ENDSCAN
	m.NroItm = TnNroItm
	m.tporf1 = m.Tporef
	m.NroRf1 = m.NroRef
	m.FlgEst = 'E'
	IF m.TpoRf1='G/R'
		m.FlgEst='F' 
	ENDIF
	INSERT INTO c_CTRA FROM memvar
	SELECT c_DTRA
ENDDO
	

SELECT c_CTRA
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
BROWSE FIELDS CodSed,SubAlm,TipMov,CodMov,NroDoc,FchDoc,NroItm,CodCli,CodPro,tporf1,nrorf1,flgest 
SELECT C_DTRA
SET ORDER TO DTRA10   && DTOS(FCHDOC)+CODMAT+TIPMOV+CODMOV+NRODOC
LOCATE
SET RELATION TO SUBALM+TIPMOV+CODMOV+NRODOC INTO C_CTRA
BROWSE FIELDS tporef,nroref,nrodoc,fchdoc,codsed,subalm,tipmov,codmat,desmat,undstk,candes,preuni,impcto,codcli FONT 'Tahoma',8



PROCEDURE CanFac_X_Item


