LsVD=SYS(5)
LsVD=IIF(":"$GoEntorno.tspathadm,'',SYS(5))

LsDirIntf = ADDBS(ADDBS(LsVD+JUSTPATH(goentorno.tspathadm))+'Interface')
*!*	LsDirIntf = ADDBS(SYS(5)+'\o-Negocios\Interface')
DIMENSION vNroMes(12),vNomMes(12)
vNomMes(1) = 'ENERO'
vNomMes(2) = 'FEBRERO'
vNomMes(3) = 'MARZO'
vNomMes(4) = 'ABRIL'
vNomMes(5) = 'MAYO'
vNomMes(6) = 'JUNIO'
vNomMes(7) = 'JULIO'
vNomMes(8) = 'AGOSTO'
vNomMes(9) = 'SEPTIEMBRE'
vNomMes(10) = 'OCTUBRE'
vNomMes(11) = 'NOVIEMBRE'
vNomMes(12) = 'DICIEMBRE'
** FASE I
SELECT 0
USE  LsDirIntf+'OrdServ.Dbf' ALIAS I_ORD
SELECT I_ORD
SCAN  FOR !INLIST(NroDoc,'AAAA')
	LsSep = AT('-',FchIni)
	REPLACE	FchIni		WITH	ConverStr2Date(FchIni)
	REPLACE	FchFin		WITH	ConverStr2Date(FchFin)
	REPLACE	FchFac1	WITH	ConverStr2Date(FchFac1)
	REPLACE	FchCob1	WITH	ConverStr2Date(FchCob1)
	REPLACE	FchFac2	WITH	ConverStr2Date(FchFac2)
	REPLACE	FchCob2	WITH	ConverStr2Date(FchCob2)
	REPLACE	FchFac3	WITH	ConverStr2Date(FchFac3)
	REPLACE	FchCob3	WITH	ConverStr2Date(FchCob3)
	REPLACE	FchFac4	WITH	ConverStr2Date(FchFac4)
	REPLACE	FchCob4	WITH	ConverStr2Date(FchCob4)
	REPLACE	FchFac5	WITH	ConverStr2Date(FchFac5)
	REPLACE	FchCob5	WITH	ConverStr2Date(FchCob5)
	REPLACE	FchFac6	WITH	ConverStr2Date(FchFac6)
	REPLACE	FchCob6	WITH	ConverStr2Date(FchCob6)
	SCATTER MEMVAR 
	m.FchIni = CTOD(TRIM(m.FchIni))
	m.FchFin = CTOD(TRIM(m.FchFin))
	m.FchFac1 = CTOD(TRIM(m.FchFac1))
	m.FchCob1 = CTOD(TRIM(m.FchCob1))
	m.FchFac2 = CTOD(TRIM(m.FchFac2))
	m.FchCob2 = CTOD(TRIM(m.FchCob2))
	m.FchFac3 = CTOD(TRIM(m.FchFac3))
	m.FchCob3 = CTOD(TRIM(m.FchCob3))
	m.FchFac4 = CTOD(TRIM(m.FchFac4))
	m.FchCob4 = CTOD(TRIM(m.FchCob4))
	m.FchFac5 = CTOD(TRIM(m.FchFac5))
	m.FchCob5 = CTOD(TRIM(m.FchCob5))
	m.FchFac6 = CTOD(TRIM(m.FchFac6))
	m.FchCob6 = CTOD(TRIM(m.FchCob6))
	m.NomServ = STRTRAN(m.NomServ,',','')
	m.NomServ = STRTRAN(m.NomServ,'µ','A')
	DO CASE
		CASE	UPPER(TRIM(m.Portal))='ADONDEVIVIR'
			m.CodFam		= '0101'
		CASE	UPPER(TRIM(m.Portal))='PERUAUTOS'
			m.CodFam		= '0102'
		CASE	UPPER(TRIM(m.Portal))='ADONDEJUEGOS'
			m.CodFam		= '0103'
		CASE	UPPER(TRIM(m.Portal))='YANUQ'
			m.CodFam		= '0104'
		CASE	UPPER(TRIM(m.Portal))='DECHALACA'
			m.CodFam		= '0105'
		CASE	UPPER(TRIM(m.Portal))='ADONDE'
			m.CodFam		= '0106'
	ENDCASE
	DIMENSION  vNomServ(1)
	STORE '' TO vNomServ
	=ChrToArray(m.NomServ,';',@vNomServ)
	FOR K = 1 TO ALEN(vNomServ)
		LsCmpEva='m.CodMat'+STR(K,1)
		DO CASE
			CASE m.CodFam = '0101' AND 'GOLD INMOBILIARIA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010203' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'CATALOGO MINI'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010204' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'BASICO AGENTE'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010302' 	
				m.TipCliServ	=	'010103'
			CASE m.CodFam = '0101' AND 'GOLD CONSTRUCTORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010103' 	
				m.TipCliServ	=	'010101'
			CASE m.CodFam = '0101' AND 'SILVER CONSTRUCTORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010102' 	
				m.TipCliServ	=	'010101'
			CASE m.CodFam = '0101' AND 'SILVER INMOBILIARIA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010202' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'STANDARD CONSTRUCTORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010101' 	
				m.TipCliServ	=	'010101'
			CASE m.CodFam = '0101' AND 'STANDARD INMOBILIARIA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010201' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'MAILING'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010210' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND '360'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010209' 	
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'BANNER'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010108'
				m.TipCliServ	=	'010101'
			CASE m.CodFam = '0101' AND 'DESTACADO HOME'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010305'
				m.TipCliServ	=	'010103'
			CASE m.CodFam = '0101' AND 'DESTACADO'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010304'
				m.TipCliServ	=	'010103'
			CASE m.CodFam = '0101' AND 'CALCULADORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010701'
				m.TipCliServ	=	'010107'
			CASE m.CodFam = '0101' AND 'CATALOGO BASICO'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010205'
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'CATALOGO PREMIUM'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010206'
				m.TipCliServ	=	'010102'
			CASE m.CodFam = '0101' AND 'BANNER HOME'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010212'
				m.TipCliServ	=	'010102'	
			CASE m.CodFam = '0101' AND 'CATALOGO'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01010213'
				m.TipCliServ	=	'010102'	
			CASE m.CodFam = '0105' AND 'BANNER'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01050102'
				m.TipCliServ	=	'010501'
			CASE m.CodFam = '0102' AND 'BANNER'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01020402'
				m.TipCliServ	=	'010204'
			CASE m.CodFam = '0102' AND 'DESTACADO'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01020302'
				m.TipCliServ	=	'010203'
			CASE m.CodFam = '0102' AND 'CALCULADORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01020501'
				m.TipCliServ	=	'010205'	
			CASE m.CodFam = '0103' AND 'BANNER'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01030102'
				m.TipCliServ	=	'010301'
			CASE m.CodFam = '0104' AND 'CALCULADORA'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01040101'
				m.TipCliServ	=	'010401'	
			CASE m.CodFam = '0104' AND 'BANNER'$UPPER(vNomServ[K])
				&LsCmpEva	=	'01040102'
				m.TipCliServ	=	'010401'	
				
		ENDCASE
	ENDFOR
	m.CndPgo = UPPER(CndPgo)
	m.CndPgo = IIF(m.CndPgo='CUOTA','CUOTAS',m.CndPgo)
	m.CodFac = UPPER(LEFT(m.CodFac,4))
	m.CodMon = UPPER(m.CodMon)
	m.CodMon	= IIF(m.CodMon='SOLES',1,IIF(m.CodMon='DOLAR',2,0))
	m.OriServ	=	UPPER(m.OriServ)
	DO CASE
		CASE 'CONTRATO'$m.OriServ 
			m.OriServ = '1'
		CASE 'COMPRA'$m.OriServ  
			m.OriServ = '2'
		CASE 'CLASIFICADO'$m.OriServ  
			m.OriServ = '3'
		CASE 'MAIL'$m.OriServ  
			m.OriServ = '4'
		CASE 'LLAMADA'$m.OriServ 
			m.OriServ = '5'
		OTHERWISE
			m.OriServ = ''	
	ENDCASE	
	m.NroDoc = RIGHT(REPLICATE('0',LEN(I_ORD.NroDoc))+TRIM(m.NroDoc),LEN(I_ORD.NroDoc))
	
	m.CodVen	=	UPPER(m.CodVen)
	DO CASE
		CASE m.CodVen = 'GISEL'
			m.codVen = 'V1'
		CASE m.CodVen = 'DEBOR'
			m.codVen = 'V2'
		CASE m.CodVen = 'GEORGINA'
			m.codVen = 'V3'
		CASE m.CodVen = 'VERA'
			m.codVen = 'V4'
	ENDCASE 
	m.CodRev	=	UPPER(m.CodRev)
	DO CASE
		CASE m.CodRev = 'GISEL'
			m.codRev = 'V1'
		CASE m.CodRev = 'DEBOR'
			m.codRev = 'V2'
		CASE m.CodRev = 'GEORGINA'
			m.codRev = 'V3'
		CASE m.CodRev = 'VERA'
			m.codRev = 'V4'
		CASE m.CodRev = 'CESAR'
			m.codRev = 'V5'
		CASE m.CodRev = 'SALLY'
			m.codRev = 'V6'
		CASE m.CodRev = 'PEDRO'
			m.codRev = 'V7'
	ENDCASE 

	INSERT INTO (LsDirIntf+'OrdServ2.Dbf') FROM MEMVAR
ENDSCAN

** FASE II

SELECT 0
USE Vtavpedi ORDER VPED01  ALIAS VPED 
SELECT 0
USE VTARPEDI ORDER RPED01 ALIAS RPED
SELECT 0
USE VTARCUOT ORDER RCUO01 ALIAS RCUO
SELECT 0
USE VTARWEBS ORDER RWEB01 ALIAS RWEB 
IF USED('OrdServ2')
	SELECT OrdServ2
ELSE
	SELECT 0
ENDIF	
USE LsDirIntf+'OrdServ2.Dbf' ALIAS I_ORD2 EXCLU
SELECT 0
USE P0012011!ALMCATGE ORDER CATG01 ALIAS CATG
SELECT 0
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
***
SELECT I_ORD2	
SCAN  
	SCATTER MEMVAR
	SELECT VPED
	SEEK I_ORD2.NroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR
	ELSE
		GATHER MEMVAR
	ENDIF
	SELECT RPED
	SEEK I_ORD2.NroDoc
	IF FOUND()
		DELETE REST  WHILE NroDoc=I_ORD2.NroDoc
	ENDIF
	DIMENSION vCodMat(3)
	vCodMat(1)		=	m.CodMat1
	vCodMat(2)		=	m.CodMat2
	vCodMat(3)		=	m.CodMat3 
	FOR K = 1 TO ALEN(vCodMat) 
		IF !EMPTY(vCodMat(K))
			SELECT RPED
			m.UndVta = 'UN'
			m.FacEqu = 1
			m.CodMat = vCodMat(K)
			=SEEK(m.CodMat,'CATG','CATG01')
			m.DesMat = CATG.DesMat
			m.CodDoc = 'PEDI'
			m.SubAlm = '001'
			m.Nro_Itm = K
			APPEND BLANK 
			GATHER MEMVAR
		ENDIF
	ENDFOR
	*** 
	SELECT RWEB
	SEEK I_ORD2.NroDoc
	IF FOUND()
		DELETE REST  WHILE NroDoc=I_ORD2.NroDoc
	ENDIF
	***
	m.CodDoc = 'PEDI'
	m.CodFam = LEFT(m.CodFam,4)
	=SEEK('02'+m.CodFam,'DIVF')
	m.DesFam = DIVF.DesFam
	APPEND BLANK 
	GATHER MEMVAR 
	** Cargamos las cuotas 
	SELECT RCUO
	SEEK I_ORD2.NroDoc
	IF FOUND()
		DELETE REST WHILE NroDoc=I_ORD2.NroDoc
	ENDIF
	m.n_Cuotas = 0
	m.Plazo = 15
	FOR J = 1 TO 6
		LsCuota	=	'I_ORD2.Cuota'	  +	STR(J,1)
		LsFchFac	=	'I_ORD2.FchFac'+	STR(J,1)
		LsFchCob	=	'I_ORD2.FchCob'+	STR(J,1)
		m.Import	= 	EVALUATE(LsCuota)
		m.FchFac	=	EVALUATE(LsFchFac)
		m.FchCob	=	EVALUATE(LsFchCob)
		m.NroCta	=	TRANSFORM(J,"@L ##")
		m.FlgEst	=	'P'
		m.CodDoc	=	'PEDI'
		m.Nro_Itm  =	 J
		IF m.Import>0  AND !EMPTY(m.FchFac) AND !EMPTY(m.FchCob)
			APPEND BLANK
			GATHER MEMVAR 				
			m.n_Cuotas = m.n_Cuotas + 1
		ENDIF
	ENDFOR
	SELECT VPED
	=RLOCK()	
	REPLACE n_Cuotas WITH m.n_Cuotas , Plazo WITH m.Plazo , FlgEst WITH 'E'
	
	FLUSH iN VPED
	SELECT	 I_ORD2	 
	=Cargar_Cliente(I_ORD2.CodCli)
	SELECT	 I_ORD2	 
	
ENDSCAN



*!*	COPY TO LsDirIntf+'OrdServ2.csv' TYPE CSV

*!*	SELECT 0
*!*	USE  LsDirIntf+'OrdServ2.Dbf' ALIAS I_ORD2 EXCLUSIVE
*!*	ZAP
*!*	APPEND FROM LsDirIntf+'OrdServ2.csv' TYPE CSV

*******************
FUNCTION ConverStr2Date
*******************
PARAMETERS LsFecha
LsFecha = STRTRAN(LsFecha, '-', '/')
FOR K=1 TO 12
	IF ATC(vNomMes(k),UPPER(LsFecha))>0
		LsFecha=STRTRAN(UPPER(LsFecha),vNomMes(K),TRANSFORM(K,'@L 99'))
	ENDIF
ENDFOR
RETURN LsFecha
******************
FUNCTION Cargar_Cliente
******************
PARAMETERS PsCodAux
IF EMPTY(PsCodAux)
	RETURN 
ENDIF
PsCodAux = PADR(PsCodAux,11)
IF !USED('CLIE') 
	SELECT 0
	USE CCTCLIEN ORDER CLIEN04 ALIAS CLIE
ELSE
	SELECT CLIE
	SET ORDER TO CLIEN04		
ENDIF
IF !USED('AUXI') 
	SELECT 0
	USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
ELSE
	SELECT AUXI
	SET ORDER TO AUXI01	
ENDIF
IF !USED('CONT')
	SELECT 0
	USE CCTCONTA ORDER CONT02 ALIAS CONT
ELSE
	SELECT  CONT
	SET ORDER TO CONT02	
ENDIF
IF !USED('DIRE')
	SELECT 0
	USE CCTCDIRE ORDER DIRE02 ALIAS DIRE
ELSE
	SELECT  DIRE
	SET ORDER TO DIRE02	
ENDIF

SELECT CLIE
SEEK GsClfCli+PsCodAux
IF !FOUND()
	APPEND BLANK
	REPLACE CodCli WITH Correlativo_Clie('')
	REPLACE ClfAux	WITH GsClfCli
	REPLACE CODAUX WITH PsCodAux
	REPLACE RazSoc	WITH I_ORD2.NomCli
	REPLACE CodDire	WITH '001'
	REPLACE Repres	WITH I_ORD2.Repres
	IF LEN(TRIM(I_ORD2.CodCli)) < 11
		REPLACE NroDni	WITH I_ORD2.CodCli
	ELSE
		REPLACE NroRuc	WITH I_ORD2.CodCli
	ENDIF	
	REPLACE CodVen WITH 	I_ORD2.CodVen
	REPLACE nrotelf1 WITH 	I_ORD2.nrotelf1
	SELECT DIRE
	SEEK GSClfCli+PsCodAux
	IF !FOUND()
		APPEND BLANK 
		REPLACE CodCli 	WITH 	CLIE.CodCli
		replace ClfAux		WITH 	GsClfCli
		replace CodAux		WITH	PsCodAux
		replace CodDire		WITH     Correlativo_Dire(CLIE.CodCli)
		replace DesDire 	WITH 	I_ORD2.DirCli
	ENDIF
	SELECT CONT
	SEEK GSClfCli+PsCodAux
	IF !FOUND()
		APPEND BLANK 
		REPLACE CodCli 	WITH 	CLIE.CodCli
		replace ClfAux		WITH 	GsClfCli
		replace CodAux		WITH	PsCodAux
		replace CodCon		WITH     Correlativo_Cont(CLIE.CodCli)
		replace NomCon 	WITH 	I_ORD2.Repres
		REPLACE TlfCon	WITH	I_ORD2.nrotelf1
		REPLACE Email		WITH	I_ORD2.Email
	ENDIF
ELSE
	SELECT DIRE
	SEEK GSClfCli+PsCodAux
	IF !FOUND()
		APPEND BLANK 
		REPLACE CodCli 	WITH 	CLIE.CodCli
		replace ClfAux		WITH 	GsClfCli
		replace CodAux		WITH	PsCodAux
		replace CodDire		WITH     Correlativo_Dire(CLIE.CodCli)
		replace DesDire 	WITH 	I_ORD2.DirCli
	ENDIF
	SELECT CONT
	SEEK GSClfCli+PsCodAux
	IF !FOUND()
		APPEND BLANK 
		REPLACE CodCli 	WITH 	CLIE.CodCli
		replace ClfAux		WITH 	GsClfCli
		replace CodAux		WITH	PsCodAux
		replace CodCon		WITH     Correlativo_Cont(CLIE.CodCli)
		replace NomCon 	WITH 	I_ORD2.Repres
		REPLACE TlfCon	WITH	I_ORD2.nrotelf1
		REPLACE Email		WITH	I_ORD2.Email
	ENDIF

ENDIF
*******************
FUNCTION Correlativo_CLIE
*******************
LPARAMETERS sCodCli
SELECT MAX(CodCli) AS Correlativo  FROM CCTCLIEN INTO CURSOR X
m.CodClieNew = VAL(X.Correlativo)+1
IF  EMPTY(m.CodClienew) or ISNULL(m.codClienew)
	m.CodClieNew = 1
ENDIF
SELE X
USE
SELECT CLIE
RETURN  RIGHT(REPLI([0],LEN(CLIE.CodCLi)) + LTRIM(STR(m.CodClieNew)), LEN(CLIE.CodCLi))
********************
FUNCTION Correlativo_Cont
*******************
LPARAMETERS sCodCli
SELECT MAX(CodCon) AS Correlativo WHERE CodCli=sCodCli FROM CCTCONTA INTO CURSOR X
m.CodContNew = VAL(X.Correlativo)+1
IF  EMPTY(m.CodContNew) or ISNULL(m.CodContNew)
	m.CodContNew = 1
ENDIF
SELE X
USE
SELECT CONT
RETURN  RIGHT(REPLI([0],LEN(CONT.CodCon)) + LTRIM(STR(m.CodContNew)), 3)
*******************
FUNCTION Correlativo_Dire
*******************
LPARAMETERS sCodCli
SELECT MAX(CodDire) AS Correlativo WHERE CodCli=sCodCli FROM CCTCDIRE INTO CURSOR X
m.CodDireNew = VAL(X.Correlativo)+1
IF  EMPTY(m.Coddirenew) or ISNULL(m.coddirenew)
	m.CodDireNew = 1
ENDIF
SELE X
USE
SELECT DIRE
RETURN  RIGHT(REPLI([0],LEN(DIRE.CodDire)) + LTRIM(STR(m.CodDireNew)), 3)
