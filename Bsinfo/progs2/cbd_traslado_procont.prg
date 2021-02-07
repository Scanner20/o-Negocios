IF DTOS(DATE())>'200305'
	MESSAGEBOX('Esta opción es válida para actualizar transacciones del sistema procont hasta el mes de mayo 2003')
	return
ENDIF
LnRespuesta=MESSAGEBOX("Esta seguro de continuar?",4+32,"Proceso de información de sistema externo Procont")
IF LnRespuesta=7
	return
ENDIF
SET PROCEDURE TO cbd_DiarioGeneral,Janesoft additive
GlInterface = .T.   && Actualizacion en tre tablas de diferente estructura
DO interface WITH 'cia001!cbdmtabl','C:\PC2000M\01\TIPO_DOC.DBF'
DO interface WITH 'admin!admmtcmb','C:\PC2000M\TIPO_CAM.DBF'
DO interface WITH 'cia001!cbdmAUXI','C:\PC2000M\01\AUXILIAR.DBF'
DO interface WITH 'p0012003!cbdtOPER','C:\PC2000M\01\VOUCHERS.DBF'
DO interface WITH 'p0012003!cbdmctas','C:\PC2000M\01\PLANCUEN.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\ENE2003C.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\FEB2003C.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\MAR2003C.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\ABR2003C.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\MAY2003C.DBF'
DO interface WITH 'p0012003!cbdvmovm','C:\PC2000M\01\JUN2003C.DBF'
=revisa_CTAS()
WAIT WINDOW 'Proceso terminado' NOWAIT 
********************
FUNCTION Revisa_Ctas
********************
SELECT 0
USE p0012003!cbdmctas ORDER ctas01 ALIAS ctas
SELECT 0
USE p0012003!cbdrmovm ORDER rmov05 ALIAS rmov
TOTAL ON CODCTA TO CTAS_RMOV
SELECT 0
USE CTAS_RMOV
INDEX ON codcta TAG codcta

SELECT CTAS_RMOV
SCAN
	WAIT WINDOW 'revisando cuenta:'+CodCta NOWAIT 
	SELECT CTAS
	SEEK CTAS_RMOV.CodCta
	IF FOUND() AND CodCta==CTAS_RMOV.CodCta
		replace aftmov WITH 'S'
	ELSE
		replace ctas_rmov.NroRef WITH 'Revisar'	
	ENDIF
	SELECT CTAS_RMOV
ENDSCAN

SELECT ctas
SCAN
	SELECT ctas_rmov
	SEEK ctas.codcta
	IF !FOUND()
		SELECT ctas
		replace aftmov WITH 'N'
		
	ENDIF
	SELECT ctas
	
ENDSCAN




USE IN rmov
USE IN ctas

SELECT ctas_rmov
SET FILTER TO NroRef='Revisar'
LOCATE
IF !EOF()
	BROWSE 
ELSE
	USE IN ctas_rmov	
ENDIF


RETURN 



******************
FUNCTION Interface
******************
PARAMETERS _RutaTabla1,_RutaTabla2
LcTablaDestino	=	_RutaTabla1
LcTablaOrigen	=	_RutaTabla2
LcRutina = "ALTER_"+ SUBSTR(LcTablaDestino,AT("!",LcTablaDestino)+1)

TsCodDiv1= '01' 


DO (LcRutina)

RETURN

FUNCTION ALTER_CbdMTabl
SELECT 0
USE (LcTablaDestino) ORDER TABL01 ALIAS TABL EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON Codigo TAG C2
SCAN
	m.Tabla ='SN'
	m.Codigo=Codigo
	m.Nombre=Nombre  
	
	SELECT tabl
	SEEK m.Tabla+m.Codigo
	IF !FOUND()
		APPEND BLANK
		replace Tabla WITH m.Tabla
		replace Codigo WITH m.Codigo
	ENDIF
	replace nombre WITH m.Nombre
	SELECT c2
		 
ENDSCAN 

USE IN c2
USE IN tabl
USE IN (LcNomArcOrigen)


FUNCTION alter_admmtcmb
SELECT 0
USE (LcTablaDestino) ORDER tcmb01 ALIAS tcmb EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON DTOS(Fecha) TAG C2
SCAN
	m.FchCmb = Fecha
	m.OfiCmp = c2.t_c_Compra 
	m.OfiVta = c2.t_c_Venta
	SELECT tcmb
	=SEEK(DTOS(M.FchCmb),'TCMB') 
	IF !FOUND()
		APPEND BLANK
		replace FchCmb WITH M.FchCmb
	ENDIF
	GATHER MEMVAR fields LIKE OfiVta, OfiCmp	
	SELECT c2	
	
	
ENDSCAN
USE IN c2
USE IN tcmb
USE IN (LcNomArcOrigen)
RETURN

************************
FUNCTION alter_cbdmctas
************************

LcTablaOrigAutoma = JUSTPATH(LcTablaOrigen)+'\ATRANSFE'
LcNombreAutoma	= JUSTSTEM(LcTablaOrigAutoma)
SELECT 0
SELECT * from (LcTablaOrigAutoma) INTO CURSOR C3
INDEX ON CODIGO TAG TAG1


SELECT 0
USE (LcTablaDestino) ORDER ctas01 ALIAS CTAS EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON codigo TAG C2
** Primero actualizamos desde la tabla origen

SELECT c2
SCAN

	LsCodCta=PADR(Codigo,LEN(ctas.codcta))	
	lExiste=SEEK(LsCodCta,'CTAS','CTAS01')
	lCtaAut=SEEK(Codigo,'C3','TAG1')
	STORE '' TO m.An1Cta,m.Cc1Cta,m.GenAut
	IF lCtaAut
		LsCodigo = C2.Codigo
		LnNumItm =0
		SELECT c3
		SCAN WHILE Codigo=LsCodigo
			LnNumItm = LnNumItm+1
			IF LnNumItm =1
				m.An1Cta = XTRANSFER
			ELSE
				m.CC1Cta = XTRANSFER
			ENDIF
				
		ENDSCAN
		SELECT C2		
	ENDIF
	IF lExiste
		LnRegCta=RECNO('CTAS')
	ENDIF
	** Verificamos el tipo de cuenta
	LExiste2=INDEXSEEK(LEFT(LsCodCta,2),.t.,'CTAS')
	IF lExiste2
		m.TpoCta = CTAS.TpoCta
	ELSE
		m.TpoCta = 0	
	ENDIF
	** Volvemos **
	lExiste=SEEK(LsCodCta,'CTAS','CTAS01')
	
	m.CodCta = LsCodCta
	IF lExiste 
		m.SecBco = 'Existe'
		m.NivCta = CTAS.NivCta
	ELSE
		m.SecBco = 'Nueva'
		DO CASE
			CASE LEN(TRIM(LSCodCta))=2
					m.NivCta = 1
			CASE LEN(TRIM(LSCodCta))=3
					m.NivCta = 2
	 		CASE LEN(TRIM(LSCodCta))=4
					m.NivCta = 3
	 		CASE LEN(TRIM(LSCodCta))=5
					m.NivCta = 4
	 		CASE LEN(TRIM(LSCodCta))=8
					m.NivCta = 5
					
		ENDCASE
		
	ENDIF
	m.NomCta = Nombre
	m.PidAux = IIF(EMPTY(Tipo_aux),'N','S')	
	m.ClfAux = F_ClfAux(Tipo_aux)
	m.AftDcb = IIF(EMPTY(T_camb_aju),'','S')
	m.TpoCmb = IIF(EMPTY(T_camb_aju),'',IIF(T_camb_aju='C',1,2))
	m.CodMon = IIF(ATC('M/E',UPPER(nomcta))>0,2,1)
	m.TpoCta = IIF(lExiste2,m.TpoCta,0)
	m.Tip_afe_RV = ''
	m.Tip_afe_RC = ''
	DO CASE
		CASE Colu_RC='1'
			m.Tip_afe_RC = 'A'
		CASE Colu_RC='3'	
			m.Tip_afe_RC = 'N'
		CASE Colu_RC='5'	
			m.Tip_afe_RC = 'A'
		CASE Colu_RC='6'	
			m.Tip_afe_RC = 'A'
	ENDCASE	
	DO CASE
		CASE Colu_RV='1'
			m.Tip_afe_RV = 'A'
		CASE Colu_RV='3'	
			m.Tip_afe_RV = 'N'
		CASE Colu_RV='5'	
			m.Tip_afe_RV = 'A'
		CASE Colu_RV='6'	
			m.Tip_afe_RV = 'A'
	ENDCASE	
	IF lCtaAut
		m.GenAut = 'S'
	ENDIF
	
	
	WAIT WINDOW 'Actualizando:'+m.CodCta+' '+m.NomCta NOWAIT	
	SELECT ctas
	IF lExiste
		GATHER MEMVAR		
	ELSE
		APPEND BLANK 
		GATHER MEMVAR		
	ENDIF
	SELECT C2
ENDSCAN
** Primero actualizamos desde la tabla origen
SELECT ctas
SCAN FOR EMPTY(secbco)
	delete			
ENDSCAN
USE IN c2
USE IN CTAS
USE IN (LcNomArcOrigen)
USE IN c3
USE IN (LcNombreAutoma)
RETURN
*****************
FUNCTION F_ClfAux
*****************
PARAMETERS _Tipo

DO case
	CASE _Tipo = '12'
		LsClfAux = 'CLI'
	CASE _Tipo = '42'
		LsClfAux = 'PRO'
	CASE _Tipo = '14'
		LsClfAux = 'PL'
	CASE _Tipo = '20'
		LsClfAux = '21'
	OTHERWISE 
		LsClfAux = ''
ENDCASE
RETURN LsClfAux

***********************
FUNCTION alter_cbdmauxi
***********************
SELECT 0
USE (LcTablaDestino) ORDER AUXI01 ALIAS AUXI EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON tipo+Codigo TAG TAG1
SCAN
	DO CASE
		CASE tipo='12'
			m.ClfAux = 'CLI'
		CASE tipo='42'
			m.ClfAux = 'PRO'
		CASE tipo='14'
			m.ClfAux = 'PL'
		CASE tipo='20'		
			m.ClfAux = '21'
			
	ENDCASE
	m.ClfAux = PADR(m.ClfAux,LEN(AUXI.ClfAux))
	m.CodAux = PADR(Codigo,LEN(AUXI.CodAux))
	m.NomAux = NombRe
	m.DirAux = Direccion
	m.RucAux = m.CodAux
	lExiste=SEEK(m.ClfAux+m.CodAux,'AUXI','AUXI01')
	WAIT WINDOW 'Actualizando:'+m.ClfAux+' '+m.CodAux+' '+m.NomAux NOWAIT	
	SELECT AuXi
	IF lexiste
		m.DirAux = IIF(EMPTY(m.DirAux),AUXI.DirAux,m.DirAux)
		GATHER MEMVAR fields Clfaux,CodAux,NomAux,DirAux,RucAux
	ELSE
		APPEND BLANK
		GATHER MEMVAR fields Clfaux,CodAux,NomAux,DirAux,RucAux	
		IF m.ClfAux='CLI'
			SELECT TRANSFORM(MAX(VAL(CodCli))+1,'@L 9999') as CodCli FROM cia001!cctclien INTO CURSOR C_CODCLI
			insert INTO cia001!cctclien 	(Clfaux,CodAux,CodCli,NroRuc,RazSoc,CodDire) VALUES ;
					(m.Clfaux,m.CodAux,C_CODCLI.CodCli,m.CodAux,m.NomAux,'001')
					
			USE IN c_Codcli		
		ENDIF
		
	ENDIF
	SELECT C2
ENDSCAN
USE IN c2
USE IN AUXI
USE IN (LcNomArcOrigen)
IF USED('cctclien')
	USE IN cctclien
ENDIF

RETURN
***********************
FUNCTION alter_cbdtoper
***********************
SELECT 0
USE (LcTablaDestino) ORDER OPER01 ALIAS OPER EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON codigo TAG TAG1
SELECT C2
SCAN 
	m.CodOpe = f_CodOpe(CodIgo)
	IF EMPTY(m.CodOpe)
		LOOP
	ENDIF
	m.NomOpe = NomBre
	m.Siglas = Codigo
	m.TpoCmb = IIF(tipo_t_cam='C',1,IIF(tipo_t_cam='V',2,1))
	SELECT OPER
	SEEK m.CodOpe
	IF !FOUND()
		APPEND BLANK 
	ENDIF
	GATHER MEMVAR 	
	FOR k = 0 to 12
	    CmpNro = [NDOC]+TRAN(K,"@L ##")
	    iNroMes = 1
	    REPLACE &CmpNro. WITH iNroMes
	ENDFOR
	SELECT C2
ENDSCAN
USE IN c2
USE IN OPER
USE IN (LcNomArcOrigen)
RETURN
***********************
FUNCTION alter_cbdvmovm
***********************
** variables que se utilizan para grabar el detalle del asiento **
** Pronto sera un objeto como el que se creo para las transacciones de ventas 
STORE '' TO NCLAVE,VCLAVE,REGVAL
STORE '' to XsCodCta,XsClfAux,XsCodAux,XsCodPrv,XsNomPrv,XsRefPrv,XsIniAux,XsCodRef,XsCodRef ,xsglodoc,XdFchDoc
STORE '' to XdFchVto,XdFchPed ,xsnivadi,XsCodDoc,XsNroDoc,XsNroRef ,XSCODFIN,XcTpoMov,XfImport ,XfImpNac,XfImpUsa
STORE '' to XiNroitm, XcTipoC,XsNroRuc,XsTipDoc,xstipdoc1,xscodcta1,xsnroref1,xstipori,xsnumori,xsfecori,xsimpori
STORE '' to xsnumpol,xsimpnac1,xsimpnac2
STORE '' TO XsCodCco,XsAn1Cta,XsCC1Cta,XsChkCta,XsCtaPre




WAIT WINDOW 'Abriendo archivos...' nowait


SELECT 0
USE p0012003!cbdacmct ALIAS acct ORDER acct01


SELECT 0
USE P0012003!cbdtoper ORDER oper01 ALIAS oper EXCLUSIVE

SELECT 0
USE P0012003!cbdMCTAS ORDER CTAS01 ALIAS ctas EXCLUSIVE


SELECT 0
USE ADMIN!admmtcmb ORDER tcmb01 ALIAS tcmb shared

SELECT 0
USE P0012003!cbdrmovm ORDER rMOV01 ALIAS rmov EXCLUSIVE

SELECT 0
USE (LcTablaDestino) ORDER VMOV01 ALIAS vmov EXCLUSIVE

LOCATE
LlEstaVacia=EOF()

SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
INDEX ON VOUCHER+NUMERO TAG TAG1
SELECT C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LcTablaOrigDetalle = JUSTPATH(LcTablaOrigen)+'\'+LEFT(LcNomArcOrigen,7)+'d'
LcNomArcOrigenDeta	=	JUSTSTEM(LcTablaOrigDetalle)
SELECT 0
SELECT * from (LcTablaOrigDetalle) INTO CURSOR C3
INDEX ON VOUCHER+NUMERO TAG TAG1


LcAAAA=SUBSTR(LcNomArcOrigen,4,4)
LcMes =F_Mes(SUBSTR(LcNomArcOrigen,1,3))
SELECT 0
SELECT codcta,nomcta,an1cta,cc1cta,genaut from ctas WHERE genaut='S' INTO table c4
INDEX ON an1cta TAG an1cta
INDEX ON cc1cta TAG cc1cta



WAIT WINDOW 'Borrando transacciones anteriores' nowait

** Borrar datos anteriores de la cabecera **
SELECT vmov
SEEK LcMes
DELETE while NroMes = LcMes
PACK

**
** Borrar datos anteriores de EL  DETALLE **
SELECT Rmov
SEEK LcMes
DELETE while NroMes = LcMes
PACK

SELECT OPER
SCAN 
	CmpNro = [NDOC]+LcMes
	iNroMes = 1
	REPLACE &CmpNro. WITH iNroMes
ENDSCAN

SELECT c2
SCAN 
	m.NroMes = LcMes
	XsNroMes = LcMes
	_Mes     = VAL(m.NroMes)
	m.CodOpe = f_CodOpe(Voucher)	
	IF EMPTY(m.CodOpe)
		=MESSAGEBOX('Codigo de operación no existe',16  )
		SET STEP ON 
	ENDIF
	=SEEK(m.CodOpe,'OPER','OPER01') 

	
	m.NroAst = Nroast()
	XsCodOpe = m.CodOpe
	XsNroAst = m.NroAst
	m.NroVou = NumEro
	m.FchAst = Fecha
	m.CodMon = IIF(Moneda='D',2,1)		
	=SEEK(DTOS(m.FchAst),'TCMB','TCMB01')
	IF Tipo_T_Cam='V'
		m.TpoCmb = TCMB.OfiVta
	ELSE
		m.TpoCmb = TCMB.OfiCmp
	ENDIF
	SELECT VMOV
	APPEND BLANK
	GATHER MEMVAR	
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	RegVal   = "&NClave = VClave"
	XiNroItm = 0
	WAIT WINDOW 'Actualizando:'+XsNromes+'-'+XsCodOpe+'-'+XsNroAst NOWAIT
	=NroAst(XsNroASt)
	SELECT C3
	SEEK C2.Voucher+C2.Numero
	SCAN	WHILE Voucher+Numero = C2.Voucher+C2.Numero
		XsCodCta = PADR(Codigo,LEN(ctas.codcta))
		XsClfAux = F_ClfAux(Tipo_Aux)	
		XsCodAux = AUXILIAR
		XcTpoMov = IIF(!EMPTY(Debe),'D','H')
		XsCodDoc = Tipo_Doc
		XsNroDoc = LEFT(Pref_Doc,3)+Nro_doc
		XdFchDoc = Fecha_Doc
		XiCodmon   = IIF(Moneda='D',2,1)   && m.CodMon
		XsGloDoc   = Glosa
		XiNroItm   = VMOV.NroItm + 1
		XcEliItm   = ''		
		YcEliItm   = ''	
		XsCodRef   = ''
		XfTpoCmb   = Tipo_Camb
		XdFchAst   = VMOV.FchAst
		XdFchVto   = {}
		XdFchPed   = {}	
		XcAfecto   = ''
		XsCodCCo	= ''	
		STORE .f. to lAn1Cta,lCC1Cta
		
		IF XcTpoMov='D'
			IF XiCodMon=1
				XfImport = DEBE
			ELSE
				XfImport = DDEBE
			ENDIF	
			XfImpUsa = DDEBE
			XfImpNac = DEBE
		ELSE
			IF XiCodMon=1
				XfImport = HABER
			ELSE
				XfImport = DHABER
			ENDIF	
		
			XfImpUsa = DHABER
			XfImpNac = HABER
		ENDIF	

*!*			IF XiCodMon=1
*!*	           XfImpNac    = XfImport
*!*	           XfImpUsa    = round(XfImport/VMOV.TpoCmb,2)
*!*	        ELSE
*!*	           XfImpUsa    = XfImport
*!*	           XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
*!*	        ENDIF
        XsChkCta = SYS(2015)
        XsCodDiv = '01'
        dimension vcodcta(10)
		store 0 to numcta,nImpNac,nImpUsa
		
		IF xScODoPE='003' AND !INLIST(XSCODCTA,'42','40','00')
*			SET STEP ON 
		ENDIF
		LAn1cta=SEEK(XsCodCta,'C4','An1cta')
		lCc1cta=SEEK(XsCodCta,'C4','CC1CTA')
		IF lAn1Cta OR lCC1Cta
			YcEliItm = '*'
		ENDIF
		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		SELECT C3		
	ENDSCAN
			
			
	SELECT C2
		
ENDSCAN
USE IN c2
USE IN C3
USE IN C4
USE IN OPER
USE IN vmov
USE IN rmov
USE IN ctas
USE IN TCMB
USE IN acct
USE IN (LcNomArcOrigen)
USE IN (LcNomArcOrigenDeta)
WAIT WINDOW 'Proceso terminado' NOWAIT

**************
FUNCTION F_MES
**************
PARAMETERS cMes
DO case
	CASE	cMes='ENE'
		LcMes = '01'
	CASE	cMes='FEB'
		LcMes = '02'	
	CASE	cMes='MAR'
		LcMes = '03'		
	CASE	cMes='ABR'
		LcMes = '04'			
	CASE	cMes='MAY'
		LcMes = '05'				
	CASE	cMes='JUN'
		LcMes = '06'					
	CASE	cMes='JUL'
		LcMes = '07'						
	CASE	cMes='AGO'
		LcMes = '08'							
	CASE	cMes='SET'
		LcMes = '09'								
	CASE	cMes='OCT'
		LcMes = '10'									
	CASE	cMes='NOV'
		LcMes = '11'									
	CASE	cMes='DIC'
		LcMes = '12'										
ENDCASE

RETURN LcMes
*****************
FUNCTION f_Codope
*****************
PARAMETERS CodIgo
PRIVATE m.CodOpe
	DO CASE
		CASE Codigo =='01 '
			m.CodOpe = '005'
		CASE CodIGo =='02 '
			m.CodOpe = '006'
		CASE Codigo =='03 '
			m.CodOpe='021' 
		CASE Codigo =='RC '	
			m.CodOpe='003' 
		CASE Codigo =='RV '
			m.CodOpe='002' 
		OTHERWISE 
			m.CodOpe = ''
	ENDCASE
RETURN m.Codope


FUNCTION alter_cbdrmovm

