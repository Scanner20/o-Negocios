CLOSE TABLES all
SET DELETED ON
LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')


SELECT 0
USE p0012006!almdtran ALIAS dtra order dtra04
SELECT 0
USE p0012006!almCtran ALIAS Ctra order Ctra01
SELECT 0
USE p0012006!almCatge ALIAS CATG order CATG01
SELECT 0
USE p0012006!almCatal ALIAS CALM order CATA01
SELECT 0
USE p0012006!almdlote ALIAS LOTE order DLOTE01
SELECT 0
USE ccbrgdoc ALIAS gdoc order gdoc08
SELECT 0
USE vtaritem ALIAS DETA ORDER item01
*** Creamos temporales de Cab y Det de almacen
LoDatAdm.abrirtabla('TEMP_STR','DTRA','C_DTRA','','')
*LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','DesMat','C',LEN(CATG.DesMat),0)
LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','UndStk','C',LEN(CATG.UndStk),0)
LoDatAdm.Mod_str_tabla('C_DTRA','Agregar','NroReg','N',6,0)
LoDatAdm.abrirtabla('TEMP_STR','CTRA','C_CTRA','','')

SELECT c_DTRA
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC

APPEND FROM DBF('DTRA') FOR tporef='FACT' OR tporef='BOLE' AND DTOS(fchdoc)='20060602'
SET STEP ON 
SELECT GDOC
SEEK '20060603'
SCAN WHILE  DTOS(FchDoc)<='20060606' FOR CodRef='FREE' AND FlgEst<>'A'
	WAIT WINDOW DTOC(FchDoc)+' ' + COdDOc+ ' ' + NroDoc NOWAIT 
	SCATTER memvar
	DO case
		CASE CodDoc='FACT'
			m.CodMov='Y01'
		CASE CODDOC='BOLE'
			m.CodMov='Y02'	
	ENDCASE
	m.TipMov = 'S'
	m.CodSed = GsCodSed
	m.TpoRf1 = m.CodDoc
	m.NroRf1 = m.NroDoc
	m.Observ = ''
	m.Motivo = 1
	m.coduser ='VETT'
	m.fchhora = DATETIME()
	LsLLave=CodDoc+NroDoc
	m.NroDoc = LEFT(CodDoc,1)+SUBSTR(m.nrodoc,2)
	IF SEEK(m.TpoRf1+m.NroRf1,'DTRA','DTRA04')
		DELETE REST WHILE TpoRef+NroRef=m.TpoRf1+m.NroRf1 IN DTRA
	ENDIF
	m.NroItm = 0
	SELECT DETA
	SEEK LsLlave
	SCAN WHILE CodDoc+NroDoc=LsLlave    FOR !EMPTY(SubAlm)
		SCATTER memvar	field EXCEPT nrorf1,NroRef,NroItm	
		m.Factor = 1
		m.ImpCto = m.ImpLin
		m.CanDes = m.CanFac
		m.Tporef = m.CodDoc
		m.NroRef = m.NroDoc
		m.NroDoc = LEFT(CodDoc,1)+SUBSTR(m.nrodoc,2)
		m.NroItm = m.NroItm + 1
		INSERT INTO DTRA FROM MEMVAR  	
		IF !SEEK(m.SubAlm+m.TipMov+m.CodMov+m.NroDoc,'CTRA','CTRA01')
			INSERT INTO Ctra FROM memvar 
		ENDIF
		SELECT DETA				
	ENDSCAN	
	SELECT GDOC
ENDSCAN


RELEASE LoDatAdm
*LnConTrol =	Grabar_Transaccion_Alm_X_ALM('C_DTRA','FREE')
