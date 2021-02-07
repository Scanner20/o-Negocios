do form ccb_traslado_fpd26
return
PROCEDURE Traslado_fpd26
PARAMETERS _RutaOrig,_CiaOrig,_AnoOrig,_CiaDes,_AnoDes,_MesIni,_MesFin,_FchIni,_FchFin,_Filtro1,_Filtro2,_CodOpes
IF PARAMETERS()<12
	_CodOpes=''
ENDIF

IF PARAMETERS()<11
	_Filtro2='.T.'
ENDIF
IF PARAMETERS()<10
	_Filtro1='.T.'
ENDIF
IF VARTYPE(_Filtro2)<>'C'
	_Filtro2 = '.T.'
ENDIF
IF VARTYPE(_Filtro1)<>'C'
	_Filtro1 = '.T.'
ENDIF
IF VARTYPE(_CodOpes)<>'C'
	_CodOpes = ''
ENDIF
IF EMPTY(_CodOpes)
	_CodOpes = [""]
ENDIF

#INCLUDE CONST.H
# DEFINE escape_      27
# DEFINE K_ESC      27
#DEFINE CRLF 			CHR(13)+CHR(10)
#DEFINE S_OK			0

IF DTOS(GdFecha)<'2005'
	MESSAGEBOX('Esta opción es válida para actualizar transacciones del sistema a partir del periodo 2005')
	return
ENDIF
LnRespuesta=MESSAGEBOX("Esta seguro de continuar?",4+32,"Traslado de datos de FPD26 a VFP9")
IF LnRespuesta=7
	return
ENDIF
*SET PROCEDURE TO cbd_DiarioGeneral,Janesoft additive
GlInterface = .T.   && Actualizacion en tre tablas de diferente estructura
LsRutaCia = ADDBS(ADDBS(TRIM(_RutaOrig))+'CIA'+_CiaOrig)
LsRutaCiaAno = ADDBS(LsRutaCia+'C'+LTRIM(_AnoOrig))
LsDBCia		 = 'CIA'+_CiaDes+'!' 				&& BDatos o-N  CIAXXX
LsDBCiaAno	 = 'P'+_CIADES+_AnoDes+'!'	&& BDAtos o-N  PXXXAAAA
LsDBAdmin	 = 'ADMIN!'
LsMesIni = TRANSFORM(_MesIni,"@L ##")
LsMesFIn = TRANSFORM(_MesFin,"@L ##")
LsForMes = "NroMes>=LsMesIni AND NroMes<=LsMesFin"
DO CASE
	CASE EMPTY(_FchIni) AND EMPTY(_FchFin)
		LsForFecha = ".T."
	CASE !EMPTY(_FchIni) AND EMPTY(_FchFin)
		LsForFecha = "FchDoc=_FchIni" 
	CASE EMPTY(_FchIni) AND !EMPTY(_FchFin)
		LsForFecha = "FchDoc=_FchFin" 
	CASE !EMPTY(_FchIni) AND !EMPTY(_FchFin)	
		LsForFecha = "FchDoc>=_FchIni AND FchDoc<=_FchFin" 
ENDCASE
DO CASE
	CASE EMPTY(_FchIni) AND EMPTY(_FchFin)
		LsForFechaAst = ".T."
	CASE !EMPTY(_FchIni) AND EMPTY(_FchFin)
		LsForFechaAst = "FchAst=_FchIni" 
	CASE EMPTY(_FchIni) AND !EMPTY(_FchFin)
		LsForFechaAst = "FchAst=_FchFin" 
	CASE !EMPTY(_FchIni) AND !EMPTY(_FchFin)	
		LsForFechaAst = "FchAst>=_FchIni AND FchAst<=_FchFin" 
ENDCASE
LsAnoINI = _AnoOrig
LsAnoFIN = _AnoDes


*DO interface WITH 'admin!admmtcmb','TCMB01',_RutaOrig+'admmtcmb','TCMB01'
IF m.ProcCorrel
	DO interface WITH LsDBAdmin+'CCBTBDOC','BDOC01',LsRutaCia+'CCBTBDOC.DBF','BDOC01'
ENDIF
IF m.ProcAuxi
	DO interface WITH LsDBCia+'CBDMAUXI','AUXI01',LsRutaCia+'CBDMAUXI','AUXI01'
ENDIF
IF m.ProcVentas
	DO interface WITH LsDbCia+'CCBRGDOC','GDOC01',LsRutaCia+'CCBRGDOC','GDOC01'   &&& 1 Cabecera 
ENDIF
**DO interface WITH LsDbCia+'VTARITEM','ITEM01',LsRutaCia+'VTARITEM','item01'   &&& 1 Detalle
IF m.ProcCtaCob
	DO interface WITH LsDbCia+'CCBNTASG','TASG01',LsRutaCia+'CCBNTASG','TASG01'   &&& 2 Cabecera 
	DO interface WITH LsDbCia+'CCBNRASG','RASG01',LsRutaCia+'CCBNRASG','RASG01'   &&& 2 Detalle
	DO interface WITH LsDbCia+'CCBMVTOS','VTOS01',LsRutaCia+'CCBMVTOS','VTOS01'
	DO interface WITH LsDbCia+'CCBRRDOC','RDOC01',LsRutaCia+'CCBRRDOC','RDOC01'
ENDIF
IF m.ProcAlmCat
	DO CASE 
		CASE INLIST(UPPER(GsSigCia),'AROMAS','QUIMICA','RQU')
			DO interface WITH LsDbCiaAno+'ALMCATGE','CATG01',LsRutaCia+'ALMMMATG','MATG01'
			DO interface WITH LsDbCiaAno+'ALMCATAL','CATA01',LsRutaCiaAno+'ALMMMATE','MATE01'
		CASE INLIST(UPPER(GsSigCia),'TOPSPORT')
			DO interface WITH LsDbCiaAno+'ALMCATGE','CATG01',LsRutaCia+'ALMMMATG','MATG01'
			DO interface WITH LsDbCiaAno+'ALMCATAL','CATA01',LsRutaCia+'ALMMMATE','MATE01'
		
	ENDCASE 		
ENDIF
IF m.ProcAlmSalIni
	DO Saldo_inicial
ENDI
IF m.ProcAlmMovi
	DO CASE 
		CASE INLIST(UPPER(GsSigCia),'AROMAS','QUIMICA','RQU')
			DO interface WITH LsDbCiaAno+'ALMCTRAN','CTRA01',LsRutaCiaAno+'ALMVMOVM','VMOV01'
		CASE INLIST(UPPER(GsSigCia),'TOPSPORT')
			DO interface WITH LsDbCiaAno+'ALMCTRAN','CTRA01',LsRutaCia+'ALMVMOVM','VMOV01'
	ENDCASE				
ENDIF
*DO interface WITH LsDbCiaAno+'ALMDTRAN','DTRA01',LsRutaCiaAno+'ALMRMOVM','RMOV01'
IF m.ProcGuias
	DO interface WITH LsDbCia+'VTAVGUIA','VGUI01',LsRutaCia+'VTAVGUIA','VGUI01'
ENDIF

IF m.ProcCbdMov
	DO interface WITH LsDbCia+'CbdVMOVm','VMOV01',LsRutaCiaAno+'CbdVMOVm','VMOV01'
ENDIF
IF m.ProcCbdSimco
	DO interface WITH LsDbCia+'CbdVMOVm_SimCo','VMOV01',ADDBS(_RutaOrig)+'Diario','CASIENTO'
ENDIF

*DO interface WITH LsDbCia+'CbdRMOVm','RMOV01',LsRutaCia+'CbdRMOVm','RMOV01'


WAIT WINDOW 'Proceso terminado' NOWAIT 
******************
FUNCTION Interface
******************
PARAMETERS _RutaTabla1,_tag1,_RutaTabla2,_tag2
LcTablaDestino	=	_RutaTabla1   &&& Ruta de o-Negocios
LcTablaOrigen	=	_RutaTabla2	   &&& Ruta de Aromas	
LcRutina = "ALTER_"+ SUBSTR(LcTablaDestino,AT("!",LcTablaDestino)+1)
TsCodDiv1= '01' 
DO (LcRutina)

RETURN

***********************
FUNCTION ALTER_CCBTBDOC
***********************
SELECT 0
USE (LcTablaDestino) ORDER BDOC01 ALIAS BDOC EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
LsTablaDoc = LsDBCIA+'Vtatdocm'
USE (LsTablaDoc) order DOCM01 ALIAS DOCM
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2

LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON CodDoc+TpoDoc TAG C2
SCAN FOR EVALUATE(_filtro2) 
	
	SCATTER memvar
	m.TpoDoc = UPPER(m.TpoDoc)
	if m.tpodoc='CARGO'
		m.codDOC = IIF(m.coddoc='N/C','N/D',m.CodDoc)		
	ENDIF
	IF m.TPODOC='A'
		m.codDOC = IIF(m.coddoc='N/A','N/C',m.CodDoc)		
	ENDIF	
	SELECT BDOC
	WAIT WINDOW DBF() NOWAIT 
	SEEK m.CodDoc
	IF !FOUND()
		APPEND BLANK
		replace CodDoc WITH m.CodDoc
		replace TpoDoc WITH m.TpoDoc
		Replace DesDoc WITH m.DesDoc
	ENDIF
	replace NroDoc WITH m.NroDoc
	REPLACE CodOpe WITH m.CodOpe
	replace CTA12_MN WITH m.CodCta
 	REPLACE CTA12_ME WITH m.CodCt2
 	REplace CTA40	WITH  m.Codct3
*!*	 	replace CTA70	WITH
	IF INLIST(m.CodDoc,'FACT','BOLE','G/R','PEDI')
		SELECT DOCM
		SEEK GsCodSed+m.coddoc+m.PtoVta
		IF !FOUND()
			APPEND BLANK 
			replace Sede WITH GsCodSed
			replace CodDOc WITH m.CodDOC
			REPLACE PtoVta WITH m.PtoVta
		ENDIF
		replace Nrodoc WITH m.NroDoc
		replace Serie WITH m.PtoVta
		replace TpoDocSN WITH IIF(VARTYPE(m.CodCbd)='C',m.CodCbd,'')
		replace Campo_Id WITH 'NroDoc'
		replace Corr_U WITH .T.
		replace Ant_serie WITH 1
		replace T_destino WITH IIF(INLIST(m.CodDoc,'F','B'),'GDOC',IIF(m.CodDoc='G/R','GUIA','VPED'))
		replace len_id WITH IIF(INLIST(m.CodDoc,'F','B','G'),10,8)
	ENDIF
	SELECT c2
		 
ENDSCAN 

USE IN c2
USE IN DOCM
USE IN BDOC
USE IN (LcNomArcOrigen)

***********************
FUNCTION ALTER_CCBRGDOC
***********************
SELECT 0
LsTablaTABLA=LsDBCIA+'Cbdmtabl'
USE (LsTablaTABLA) ORDER tabl01 ALIAS tabl
SELECT 0
LsTablaCTAS = LsDBCIAANO+'CBDMCTAS'
USE (LsTablaCtas) ORDER ctas01 ALIAS ctas

SELECT 0
USE (LcTablaDestino) ORDER GDOC01 ALIAS GDOC && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
LsTablaITEM=LsDBCIA+'VTARITEM'
USE (LsTablaITEM) ORDER ITEM01 ALIAS ITEM && EXCLUSIVE
*
SELECT 0
LsTablaRasg= ADDBS(JUSTPATH(LcTablaOrigen))+"CCBNRASG" 
USE (LsTablaRasg) ALIAS RASG
SET ORDER TO RASG03
*
SELECT 0
LsTablaC3= ADDBS(JUSTPATH(LcTablaOrigen))+"VTARITEM" 
USE (LsTablaC3) ORDER ITEM01 ALIAS C3
*
SELECT 0
USE (LcTablaOrigen) ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)

SCAN FOR &LsForFecha  AND &_Filtro1   &&AND coddoc='LETR'
	SCATTER MEMVAR memo	
	SELECT GDOC	

	
	m.TpoDoc = UPPER(m.TpoDoc)
	m.TpoRef = IIF(INLIST(UPPER(m.TpoRef),'CARGO','ABONO'),UPPER(m.TpoRef),m.TpoRef)
	m.CodDire = '001'
	IF m.TpoDoc= 'ABONO' AND INLIST(m.CodDoc,'N/A','N/C')
		m.CodDoc = 'N/C '
	ENDIF
	IF m.TpoDoc= 'CARGO' AND INLIST(m.CodDoc,'N/C','N/A')
		m.CodDoc = 'N/D '
	ENDIF
	IF m.TpoRef= 'ABONO' AND INLIST(m.CodRef,'N/C','N/A')
		m.CodRef = 'N/C '
	ENDIF
	IF m.TpoRef= 'CARGO' AND INLIST(m.CodRef,'N/C','N/A')
		m.CodRef = 'N/D '
	ENDIF
	IF M.CODDOC='LETR' && AND M.NRODOC='006336'
		**SET STEP ON 
	ENDIF 
	m.NroPla = ''
	m.CodBco = ''
    M.Glosa4 = 'VETTTR1'+TTOC(DATETIME(),3)

	IF m.CodDoc='LETR' AND INLIST(UPPER(GsSigCia),'AROMAS','QUIMICA','RQU')
		m.CodCta=m.Banco
		IF SEEK(TRIM(m.CodCta),'CTAS') AND CTAS.Aftmov='S'
			IF !EMPTY(CTAS.CodBco)
				m.CodBco = CTAS.CodBco
			ENDIF
		ENDIF
	    WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc+ ' +'  NOWAIT 
		DO CASE 
			CASE m.CodDoc='LETR' AND m.sdodoc>=0.1 AND UPPER(m.Seccion)='CARTERA' AND m.FlgSit<>'A'
				m.FlgSit = 'A'
				
			CASE m.CodDoc='LETR' AND m.sdodoc>=0.1 AND m.Seccion = 'Cobranzas' AND m.TPOREF+m.CodRef='RenovRENV' AND (m.FlgSit<>'C' OR m.FlgUbc<>'B')
				m.FlgSit = 'C'
				m.FlgUbc = 'B'
				
			CASE m.CodDoc='LETR' AND m.sdodoc=>0.0 AND INLIST(m.Seccion,'Banco','Descuento') 
				IF SEEK(m.CodDoc+m.NroDoc,'RASG') AND RASG.CodDoc='L/D' AND (m.FlgSit<>'D' OR m.FlgUbc<>'B')
					m.FlgSit = 'D'
					m.FlgUbc = 'B'
					m.NroPla = RASG.NroDoc
				ENDIF
				
			CASE m.CodDoc='LETR' AND m.sdodoc=>0.1 AND m.Seccion = 'Cobranzas' 
				IF SEEK(m.CodDoc+m.NroDoc,'RASG') AND RASG.CodDoc='L/B'
					m.FlgSit = 'C'
					m.FlgUbc = 'B'
					m.NroPla = RASG.NroDoc
				ENDIF
				
			CASE m.CodDoc='LETR' AND m.sdodoc>0.1 AND m.Seccion = 'Protesto' 
				m.FlgSit = 'P'
				m.FlgUbc = 'B'
				
		ENDCASE 
	ENDIF
	SEEK m.TpoDoc+m.Coddoc+m.nroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE TPODOC,CODDOC,NRODOC,CODDIRE,TPOREF
	ENDIF
    GATHER MEMVAR MEMO FIELDS EXCEPT TPODOC,CODDOC,NRODOC,CODDIRE,TPOREF
    WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc + ' *'  NOWAIT 
    SELECT ITEM
    SEEK m.CodDoc+m.NroDoc
    DELETE REST WHILE CodDoc+NroDoc=m.CodDoc+m.NroDoc
	SELECT C3
	SEEK m.CodDoc+m.NroDoc
	SCAN  WHILE CodDoc+NroDoc=m.CodDoc+m.NroDoc
		SCATTER MEMVAR 
		m.TpoDoc = 'CARGO'
		m.CanFac = m.Candes
		SELECT ITEM
		APPEND BLANK
		GATHER MEMVAR
		SELECT C3	
	ENDSCAN     
    WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc+ ' -'  NOWAIT 
    SELECT C2
ENDSCAN 

USE IN C2
USE IN C3
IF USED()
	USE IN (LcNomArcOrigen)
ENDIF
USE IN GDOC
USE IN RASG
USE IN ITEM
USE IN CTAS
***********************
FUNCTION ALTER_VTARITEM
***********************
SELECT 0
USE (LcTablaDestino) ORDER ITEM01 ALIAS ITEM EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order item01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN
	SCATTER MEMVAR memo	
	SELECT ITEM
	m.TpoDoc = 'CARGO'
	m.CanFac = m.Candes
	SEEK m.TpoDoc+m.CodDoc+m.NroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE TPODOC,CODDOC,NRODOC
	ENDIF
    GATHER MEMVAR MEMO FIELDS EXCEPT TPODOC,CODDOC,NRODOC
  	WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc  NOWAIT 
    SELECT C2
ENDSCAN 

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN item

***********************
FUNCTION ALTER_CCBNTASG
***********************
SELECT 0
USE (LcTablaDestino) ORDER TASG01 ALIAS TASG && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order TASG01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN FOR &LsForFecha
	SCATTER MEMVAR memo	
	SELECT TASG
	SEEK m.CodDoc+m.NroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE CODDOC,NRODOC
	ENDIF
    GATHER MEMVAR MEMO FIELDS EXCEPT CODDOC,NRODOC
   	WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc  NOWAIT 
    SELECT C2
ENDSCAN 

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN TASG
***********************
FUNCTION ALTER_CCBNRASG
***********************
SELECT 0
USE (LcTablaDestino) ORDER RASG01 ALIAS RASG && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order RASG01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LOCATE 
DO WHILE !EOF() 
	IF &LsForFecha
		SCATTER MEMVAR memo	
		SELECT RASG
		m.Tporef = IIF(INLIST(UPPER(m.TpoRef),'CARGO','ABONO'),UPPER(m.TpoRef),m.TpoRef)
		SEEK m.CodDoc+m.NroDoc
		DELETE REST WHILE CodDoc+NroDoc = m.CodDoc+m.NroDoc IN RASG
		SELECT C2
		SCAN WHILE CodDoc+NroDoc = m.CodDoc+m.NroDoc
			SCATTER MEMVAR 
			m.Tporef = IIF(INLIST(UPPER(m.TpoRef),'CARGO','ABONO'),UPPER(m.TpoRef),m.TpoRef)
			INSERT INTO RASG FROM MEMVAR 
		   	WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc  NOWAIT 
	   	ENDSCAN 
   	ELSE
		SELECT C2
		SKIP 
		LOOP   	
   	ENDIF
    SELECT C2
ENDDO

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN RASG
***********************
FUNCTION ALTER_CCBMVTOS
***********************
SELECT 0
USE (LcTablaDestino) ORDER VTOS01 ALIAS VTOS && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order VTOS01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LOCATE
DO WHILE !EOF() 
	IF !&LsForFecha.
		SELECT C2
		SKIP 
		LOOP
	ENDIF
	SCATTER MEMVAR memo	
	IF m.CodRef = 'N/C' AND m.TpoRef='Canje'
		m.Codref = 'N/D '  && Nota Debito
	ENDIF	
	m.TpoRef = IIF(INLIST(UPPER(m.TpoRef),'CARGO','ABONO'),UPPER(m.TpoRef),m.TpoRef)
	SELECT VTOS
	SEEK m.CodDoc+m.NroDoc
	DELETE REST WHILE CodDoc+NroDoc = m.CodDoc+m.NroDoc IN VTOS
	SELECT C2
	SCAN WHILE CodDoc+NroDoc = m.CodDoc+m.NroDoc
		SCATTER MEMVAR 
		IF m.CodRef = 'N/C' AND m.TpoRef='Canje'
			m.Codref = 'N/D '  && Nota Debito
		ENDIF	
		m.TpoRef = IIF(INLIST(UPPER(m.TpoRef),'CARGO','ABONO'),UPPER(m.TpoRef),m.TpoRef)
		INSERT INTO VTOS FROM MEMVAR 
	   	WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc  NOWAIT 
   	ENDSCAN 
    SELECT C2
ENDDO

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN VTOS


***********************
FUNCTION ALTER_CCBRRDOC
***********************
SELECT 0
USE (LcTablaDestino) ORDER RDOC01 ALIAS RDOC && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order RDOC01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LOCATE 
DO WHILE !EOF()
*!*		IF !&LsForFecha.
*!*			SELECT C2
*!*			SKIP 
*!*			LOOP
*!*		ENDIF
	SCATTER MEMVAR memo	
	m.TpoDoc=UPPER(Tpodoc)
	IF m.TpoDoc= 'ABONO' AND INLIST(m.CodDoc,'N/A','N/C')
		m.CodDoc = 'N/C '
	ENDIF
	IF m.TpoDoc= 'CARGO' AND INLIST(m.CodDoc,'N/C','N/A')
		m.CodDoc = 'N/D '
	ENDIF
	SELECT RDOC
	SEEK m.TpoDoc+m.CodDoc+m.NroDoc
	DELETE REST WHILE TpoDoc+CodDoc+NroDoc=m.TpoDoc+m.CodDoc+m.NroDoc IN RDOC
	SELECT C2
	SCAN WHILE TpoDoc+CodDoc+NroDoc=m.TpoDoc+m.CodDoc+m.NroDoc
		SCATTER MEMVAR memo	
		m.TpoDoc=UPPER(Tpodoc)
		IF m.TpoDoc= 'ABONO' AND INLIST(m.CodDoc,'N/A','N/C')
			m.CodDoc = 'N/C '
		ENDIF
		IF m.TpoDoc= 'CARGO' AND INLIST(m.CodDoc,'N/C','N/A')
			m.CodDoc = 'N/D '
		ENDIF
		INSERT INTO RDOC FROM MEMVAR
	  	WAIT WINDOW DBF() +' '+ Tpodoc+CodDoc+NroDoc  NOWAIT 
    ENDSCAN

    SELECT C2
ENDDO

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN RDOC

***********************
FUNCTION alter_admmtcmb
***********************
SELECT 0
USE (LcTablaDestino) ORDER tcmb01 ALIAS tcmb EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
SELECT 0
SELECT * from (LcTablaOrigen) INTO CURSOR C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
INDEX ON DTOS(FchCmb) TAG C2
SCAN
	SCATTER MEMVAR
	SELECT TCMB
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




***********************
FUNCTION ALTER_ALMCATGE
***********************
SELECT 0
USE (LcTablaDestino) ORDER CATG01 ALIAS CATG &&EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order MATG01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN FOR !EMPTY(CodMat)
	SCATTER MEMVAR memo	
	SELECT CATG
	SEEK TRIM(m.CodMat)
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR && FIELDS LIKE CodMat
	ENDIF
*    GATHER MEMVAR MEMO FIELDS EXCEPT CodMat
  	WAIT WINDOW DBF() +' '+ CodMat+' '+Desmat  NOWAIT 
    SELECT C2
ENDSCAN 

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN CATG

***********************
FUNCTION ALTER_ALMCATAL
***********************
SELECT 0
USE (LcTablaDestino) ORDER CATA01 ALIAS CALM && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
SELECT 0
USE (LcTablaOrigen) order MATE01 ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN FOR !EMPTY(CodMat) AND !EMPTY(Subalm)
	SCATTER MEMVAR memo	
	m.CodSed = '001'
	SELECT CALM
	SEEK m.SubAlm+TRIM(m.CodMat)
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR && FIELDS LIKE SubAlm,CodMat
	ENDIF
*    GATHER MEMVAR MEMO FIELDS EXCEPT SubAlm,CodMat
  	WAIT WINDOW DBF() +' '+ SubAlm+' '+Codmat  NOWAIT 
    SELECT C2
ENDSCAN 

USE IN c2
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN CALM
**********************
FUNCTION Saldo_inicial
**********************
SELECT 0
LsTablaTCMB=LsDBADMIN+'ADMMTCMB'
USE (LsTablaTCMB) ORDER TCMB01 ALIAS TCMB && EXCLUSIVE
*
SELECT 0
LsTablaALMA=LsDBCIA+'ALMTALMA'
USE (LsTablaALMA) ORDER ALMA01 ALIAS ALMA && EXCLUSIVE
*
SELECT 0
LsTablaCALM=LsDBCiaAno+'ALMCATAL'
USE (LsTablaCALM) ORDER CATA01 ALIAS CALM && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
LsTablaDTRA=LsDBCiaAno+'ALMDTRAN'
SELECT 0
USE (LsTablaDTRA) ORDER DTRA01 ALIAS DTRA
*
SELECT 0
LsTablaRMOV= LsRutaCiaANO+"ALMRMOVM" 
USE (LsTablaRMOV) ORDER RMOV02 ALIAS C3
*
SELECT alma
SET RELATION TO dtos(fchcie) INTO tcmb ADDITIVE

m.FchDocD = _FchFin
SELECT CALM
SET RELATION TO subalm INTO alma additive
LOCATE
SCAN 
	WAIT WINDOW SubAlm+' '+ CodMat nowait
	m.SubAlm = SubAlm
	m.CodMat = CodMat
	m.FchDocD = ALMA.FchCie + 1
	m.TpoCmb  = TCMB.OfiVta
	SELECT C3
	SEEK m.subalm+PADR(m.codmat,LEN(c3.codmat))+DTOC(m.FchDocD,1)
	IF !FOUND()
		IF RECNO(0)>0
	    	GO RECNO(0)
			IF DELETED()
	        	SKIP
			ENDIF
		ENDIF
	ENDIF
	m.Reg_Ini = RECNO() 
	SKIP -1
	IF C3.SubAlm + C3.CodMat=m.SubAlm + PADR(m.codmat,LEN(c3.codmat)) AND C3.FchDoc < m.FchDocD
	     fStkIni = C3.StkAct
	     IF !EMPTY(C3.CosPro)
		     IF C3.CodMon=2
			     fVIniUs = ROUND(C3.COSPRO*C3.StkAct,2)
			     fVIniMn = ROUND(C3.COSPRO*C3.StkAct*m.TpoCmb,2)
		     ELSE
		     	 m.TpoCmb=IIF(m.TpoCmb<=0,1,m.TpoCmb)
			     fVIniMn = ROUND(C3.COSPRO*C3.StkAct,2)
			     fVIniUS = ROUND(C3.COSPRO*C3.StkAct/m.TpoCmb,2)
		     ENDIF
	     ENDIF
	     SELECT CALM
	     =RLOCK()
	     replace Stkini WITH fStkIni
	     replace ViniMn WITH fVIniMn
	     replace ViniUs WITH fVIniUS
	     unlock
	ENDIF
     SELECT CALM
ENDSCAN
SELECT dtra
DELETE ALL FOR DTOS(fchdoc)='2005'


USE IN C3
USE IN CALM
USE IN DTRA
USE IN tcmb
USE IN alma
***********************
FUNCTION ALTER_ALMCTRAN
***********************
SELECT 0
USE (LcTablaDestino) ORDER CTRA01 ALIAS CTRA && EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
LsTablaDTRA=LsDBCiaAno+'ALMDTRAN'
SELECT 0
USE (LsTablaDTRA) ORDER DTRA01 ALIAS DTRA
*
SELECT 0
LsTablaRasg= ADDBS(JUSTPATH(LcTablaOrigen))+"ALMRMOVM" 
USE (LsTablaRasg) ORDER RMOV01 ALIAS C3
*
SELECT 0
USE (LcTablaOrigen) ALIAS C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN  FOR &LsForFecha AND &_Filtro2
	SCATTER MEMVAR memo	
	LsLlaveORI = SubAlm+TipMov+CodMov+NroDoc
	m.CodSed = '001'
	IF INLIST(m.tipmov,'X','Y')
		LcOldTipMov = m.TipMov
		m.TipMov='S'
		m.CodMov=LcOldTipMov+RIGHT(m.CodMov,2)
		IF LcOldTIPMOV='X' AND INLIST(LcOldCODMOV,'001','002')
			m.NRORF1 = PtoVta+NRODOC
			m.TPORF1 = 'G/R'  
		ENDIF
		IF LcOldTIPMOV='Y' AND INLIST(LcOldCODMOV,'001','002')
			m.NRORF1 = LEFT(IIF(LcOldCodMov='001','FACT','BOLE'),1)+TRIM(SUBSTR(PTOVTA,2))+NRODOC
			m.TPORF1 = IIF(LcOldCodMov='001','FACT','BOLE')
		ENDIF		
	ENDIF	
	DO CASE
		CASE INLIST(UPPER(GsSigCia),'TOPSPORT')
			m.SubAlm = IIF(m.SubAlm='001','002',m.SubAlm)		
	ENDCASE
	
	SELECT CTRA
	SEEK m.SubAlm+m.TipMov+m.CodMov+m.NroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE SubAlm,TipMov,CodMov,NroDoc
		SELECT C2  && Volvemos a coger los datos 
		SCATTER MEMVAR MEMO  
		m.CodSed = '001'
		IF INLIST(m.tipmov,'X','Y')
			LcOldTipMov = m.TipMov
			m.TipMov='S'
			m.CodMov=LcOldTipMov+RIGHT(m.CodMov,2)
		ENDIF	
		SELECT CTRA
	ENDIF
    GATHER MEMVAR MEMO FIELDS EXCEPT SubAlm,TipMov,CodMov,NroDoc
   	WAIT WINDOW DBF() +' '+ SubAlm+' '+TipMov+' '+CodMov+' '+NroDoc  NOWAIT 
    LsLlaveDes=SubAlm+TipMov+CodMov+NroDoc
    *** DETALLE ***
   	SELECT DTRA
 	SEEK LsLlaveDes
 	DELETE REST WHILE SubAlm+TipMov+CodMov+NroDoc=LsLlaveDes
 	SELECT C3
 	SEEK LsLLaveORI
 	SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=LsLLaveORI
 	
 		SCATTER memvar
 		DO CASE 
	 		CASE UPPER(GsSigCia)='AROMAS'
		 		
		 		m.CodSed = '001'
		 		REPLACE REST NROREF WITH '002'+NRODOC,TPOREF WITH 'G/R' WHILE TIPMOV='S' AND CODMOV='X01'
				m.Situ = IIF(VARTYPE(m.Situ)='C',m.Situ,'')
		 		DO CASE 
		 			CASE m.Situ = 'APROBADO'
				 		m.Situ = '01'
		 			CASE m.Situ = 'RECHAZADO'
				 		m.Situ = '02'
		 			CASE m.Situ = 'REANALIZAD'
				 		m.Situ = '03'
		 			CASE m.Situ = 'NO SE MUEV'
				 		m.Situ = '04'
		 			CASE m.Situ = 'OBSERVADO'
				 		m.Situ = '05'
		 			CASE m.Situ = 'POR INSPEC'
				 		m.Situ = '06'		 				 				 				 				 		
		 		ENDCASE 
				LcOldTipMov = m.TipMov
				LcOldCodMov = m.CodMov
				IF INLIST(m.tipmov,'X','Y')
					LcOldTipMov = m.TipMov
					LcOldCodMov = m.CodMov
					m.TipMov='S'
					m.CodMov=LcOldTipMov+RIGHT(m.CodMov,2)
				ENDIF	
				**COPY TO ralmfalt FOR !EMPTY(codmat) AND !EMPTY(subalm) AND  tipmov$'ISXY'
				m.Lote = IIF(VARTYPE(m.NroRf1)='C',m.NroRf1,'')
				IF LcOldTIPMOV='X' AND INLIST(LcOldCODMOV,'001','002')
					m.NROREF = PtoVta+NRODOC
					m.TPOREF = 'G/R'  
				ENDIF
				IF LcOldTIPMOV='Y' AND INLIST(LcOldCODMOV,'001','002')
					m.NROREF = LEFT(IIF(LcOldCodMov='001','FACT','BOLE'),1)+TRIM(SUBSTR(PTOVTA,2))+NRODOC
					m.TPOREF = IIF(LcOldCodMov='001','FACT','BOLE')
				ENDIF

			CASE INLIST(UPPER(GsSigCia),'TOPSPORT')
				LcOldTipMov = m.TipMov
				LcOldCodMov = m.CodMov
				IF INLIST(m.tipmov,'X','Y')
					LcOldTipMov = m.TipMov
					LcOldCodMov = m.CodMov
					m.TipMov='S'
					m.CodMov=LcOldTipMov+RIGHT(m.CodMov,2)
				ENDIF	
				DO CASE
					CASE	LcOldTIPMOV='X' AND INLIST(LcOldCODMOV,'001','002') 
							m.NROREF = PTOVTA+NRODOC
							m.TPOREF = 'G/R'  
					CASE	LcOldTIPMOV='Y' AND INLIST(LcOldCODMOV,'001','002') 
							m.NROREF = LEFT(IIF(LcOldCodMov='001','FACT','BOLE'),1)+SUBSTR(PTOVTA,2)+NRODOC
							m.TPOREF = IIF(LcOldCodMov='001','FACT','BOLE')
				ENDCASE 
		ENDCASE			
		IF INLIST(UPPER(GsSigCia),'TOPSPORT')
			m.CodMat = '999'+CodMat
			m.SubAlm = IIF(m.SubAlm='001','002',m.SubAlm)		
		ENDIF
		SELECT DTRA
		APPEND BLANK 
		GATHER memvar		 		
		SELECT C3
 	ENDSCAN
    SELECT C2
ENDSCAN 
*** Ahora Veamos movimientos sin Cabecera
SELECT C2
SET ORDER TO VMOV01
SELECT C3 
SET ORDER TO RMOV01
SET RELATION TO subalm+tipmov+codmov+nrodoc INTO C2
SET FILTER TO !SUBALM+TIPMOV+CODMOV+NRODOC==C2.SUBALM+C2.TIPMOV+C2.CODMOV+C2.NRODOC
SCAN FOR &LsForFecha AND !EMPTY(codmat) AND !EMPTY(subalm) AND  tipmov$'ISXY' AND &_Filtro2
   	WAIT WINDOW DBF() +' SIN CABECERA '+ SubAlm+' '+TipMov+' '+CodMov+' '+NroDoc  NOWAIT 
	SCATTER memvar
	LcOldTipMov = m.TipMov
	LcOldCodMov = m.CodMov
	IF INLIST(m.tipmov,'X','Y')
		LcOldTipMov = m.TipMov
		LcOldCodMov = m.CodMov
		m.TipMov='S'
		m.CodMov=LcOldTipMov+RIGHT(m.CodMov,2)
	ENDIF	
	DO CASE
		CASE	LcOldTIPMOV='X' AND INLIST(LcOldCODMOV,'001','002') 
				m.NROREF = PTOVTA+NRODOC
				m.TPOREF = 'G/R'  
				m.TpoRf1 = m.TpoRef
				m.NroRf1 = m.NroRef
				
		CASE	LcOldTIPMOV='Y' AND INLIST(LcOldCODMOV,'001','002') 
				m.NROREF = LEFT(IIF(LcOldCodMov='001','FACT','BOLE'),1)+TRIM(SUBSTR(PTOVTA,2))+NRODOC
				m.TPOREF = IIF(LcOldCodMov='001','FACT','BOLE')
				m.TpoRf1 = m.TpoRef
				m.NroRf1 = m.NroRef
	ENDCASE 
	
	**COPY TO ralmfalt FOR !EMPTY(codmat) AND !EMPTY(subalm) AND  tipmov$'ISXY'
*	m.Lote = IIF(VARTYPE(m.NroRf1)='C',m.NroRf1,'')
    LsLlaveDes=M.SubAlm+M.TipMov+M.CodMov+M.NroDoc+STR(M.NROITM,3,0)
    *** DETALLE ***
    M.CODUSER = 'VETTTR1'
    M.FHCHORA = DATETIME()
	m.Situ = IIF(VARTYPE(m.Situ)='C',m.Situ,'')
  		DO CASE 
 			CASE m.Situ = 'APROBADO'
		 		m.Situ = '01'
 			CASE m.Situ = 'RECHAZADO'
		 		m.Situ = '02'
 			CASE m.Situ = 'REANALIZAD'
		 		m.Situ = '03'
 			CASE m.Situ = 'NO SE MUEV'
		 		m.Situ = '04'
 			CASE m.Situ = 'OBSERVADO'
		 		m.Situ = '05'
 			CASE m.Situ = 'POR INSPEC'
		 		m.Situ = '06'		 				 				 				 				 		
 		ENDCASE 
	m.CodSed = '001'
	IF INLIST(UPPER(GsSigCia),'TOPSPORT')
		m.CodMat = '999'+CodMat
		m.SubAlm = IIF(m.SubAlm='001','002',m.SubAlm)		
	ENDIF
   	SELECT DTRA
*!*	 	SEEK LsLlaveDes
*!*	 	DELETE REST WHILE SubAlm+TipMov+CodMov+NroDoc=LsLlaveDes
*!*		SELECT C3
	SEEK LsLlaveDes
	IF !FOUND()
		APPEND BLANK 
	ENDIF
	GATHER MEMVAR
	SELECT ctra
	SEEK M.SubAlm+M.TipMov+M.CodMov+M.NroDoc
	IF !FOUND()
		APPEND BLANK
	ENDIF
	GATHER memvar 
		
	SELECT C3		
ENDSCAN


*
USE IN c2
USE IN C3
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN CTRA
USE IN DTRA

***********************
FUNCTION ALTER_VTAVGUIA
***********************
SELECT 0
USE (LcTablaDestino) ORDER VGUI01 ALIAS GUIA EXCLUSIVE
LOCATE
LlEstaVacia=EOF()
*
*!*	LsTablaDTRA=LsDBCiaAno+'ALMDTRAN'
*!*	SELECT 0
*!*	USE (LsTablaDTRA) ORDER DTRA01 ALIAS DTRA
*
*!*	SELECT 0
*!*	LsTablaRasg= ADDBS(JUSTPATH(LcTablaOrigen))+"ALMRMOVM" 
*!*	USE (LsTablaRasg) ORDER RMOV01 ALIAS C3
*
SELECT 0
USE (LcTablaOrigen) ALIAS C2

LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
SCAN  FOR &LsForFecha AND &_Filtro1
	SCATTER MEMVAR memo	
	LsLlaveORI = SubAlm+TipMov+CodMov+NroDoc
	m.CodSed = '001'
	IF INLIST(m.tipmov,'X','Y')
		m.TipMov='S'
		m.CodMov=m.TipMov+RIGHT(m.CodMov,2)
	ENDIF	
	SELECT GUIA
	SEEK m.CodDoc+m.NroDoc
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE CodDoc,NroDoc
	ENDIF
    GATHER MEMVAR MEMO FIELDS EXCEPT CodDoc,NroDoc
   	WAIT WINDOW DBF() +' '+ CodDoc+' '+NroDoc  NOWAIT 
*!*	    LsLlaveDes=SubAlm+TipMov+CodMov+NroDoc
*!*	    *** DETALLE ***
*!*	   	SELECT DTRA
*!*	 	SEEK LsLlaveDes
*!*	 	DELETE REST WHILE SubAlm+TipMov+CodMov+NroDoc=LsLlaveDes
*!*	 	SELECT C3
*!*	 	SEEK LsLLaveORI
*!*	 	SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=LsLlaveORI
*!*	 		SCATTER memvar
*!*	 		m.CodSed = '001'
*!*			IF INLIST(m.tipmov,'X','Y')
*!*				m.TipMov='S'
*!*				m.CodMov=m.TipMov+RIGHT(m.CodMov,2)
*!*			ENDIF	
*!*			SELECT DTRA
*!*			APPEND BLANK 
*!*			GATHER memvar		 		
*!*			SELECT C3
*!*	 	ENDSCAN
    SELECT C2
ENDSCAN 

USE IN c2
*USE IN C3
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
USE IN GUIA
*USE IN DTRA
***********************
FUNCTION ALTER_CbdMauxi 
***********************
Local LoData as Dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoData = CREATEOBJECT('DOSVR.DataAdmin')

	
SELECT 0
USE (LcTablaDestino) ORDER AUXI01 ALIAS AUXI && EXCLUSIVE
LOCATE
SELECT 0
LsTablaCLIEN=LsDBCIA+'CCTCLIEN'
USE (LsTablaCLIEN) ORDER CLIEN04 ALIAS CLIEN && EXCLUSIVE
SELECT 0
LsTablaCDIRE=LsDBCIA+'CCTCDIRE'
USE (LsTablaCDIRE) ORDER DIRE02 ALIAS CDIRE && EXCLUSIVE
SELECT 0
LsTablaDISTRI=LsDBCIA+'DISTRITOS'
USE (LsTablaDISTRI) ORDER DIST01 ALIAS CDIST && EXCLUSIVE


LlEstaVacia=EOF()
SELECT 0
USE (LcTablaOrigen) ALIAS C2

LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)

SCAN FOR INLIST(ClfAux,GsClfCli,GsClfPro,'006','TRA')
	SCATTER MEMVAR memo
	SELECT AUXI
	SEEK m.ClfAux+PADR(m.CodAux,LEN(AUXI.CodAux))
	IF !FOUND()	
		APPEND BLANK
		GATHER MEMVAR FIELDS LIKE ClfAux,CodAux		
	ENDIF
	WAIT WINDOW ClfAux+' ' + CodAux+ '  '+ Nomaux nowait
	GATHER MEMVAR MEMO FIELDS EXCEPT ClfAux,CodAux
	unlock
	IF ClfAux=GsClfCli
		SELECT CLIEN
		SEEK m.ClfAux+PADR(m.CodAux,LEN(AUXI.CodAux))
		IF !FOUND()	
			APPEND BLANK
			GATHER MEMVAR FIELDS LIKE ClfAux,CodAux		
			LsCodCli=LoData.Cap_NroItm('','CLIEN','','CodCli' )	
			replace CodCli WITH  LsCodCli		
		ENDIF
		=RLOCK()
		REPLACE NRORUC		WITH M.RUCAUX
		REPLACE RAZSOC		WITH M.NOMAUX
		REPLACE RETE		WITH IIF(VARTYPE(M.RETE)='L',m.Rete,.F.)
		REPLACE CODDIRE		WITH '001'
		REPLACE REPRES		WITH m.nomc_v
		REPLACE CodVen		WITH m.CodVen
		REPLACE NroTelf1	WITH LEFT(m.tlfaux	,LEN(CLIEN.NroTelf1))
		REPLACE NroTelf2	WITH SUBSTR(m.tlfaux,LEN(CLIEN.NroTelf1)+1) 
		replace Naccli 		WITH 1
		replace CodUser 	WITH Goentorno.User.Login
		Replace FchHora     WITH DATETIME()
		replace NomAva      WITH m.NomAva
		replace DirAva      WITH m.DirAva
		replace DniAva      WITH m.DniAva
		m.CodCli = CodCli
		m.CodUser = CodUser
		UNLOCK
		***		
		IF !EMPTY(m.DirAux)
		
			SELECT cdire
*!*				SEEK m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux))+'001'
			LsCodDire=LoData.Cap_NroItm(m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux)),'CDIRE','ClfAux+CodAux','CodDire' )	
			IF LsCodDire='001'	
				m.CodDire = '001'
				APPEND BLANK
				GATHER MEMVAR FIELDS LIKE ClfAux,CodAux,CodDire		
			ENDIF
			UPDATE cdire SET ;
			 DesDire = m.DirAux ,;
			 CodDist  = m.CodPos,;
			 cODpAIS = '51',;
			 CodCli = m.CodCli,;
			 CodUser = m.CodUser,;
			 FchHora  = DATETIME() ;
			 WHERE ClfAux+CodAux= m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux)) AND CodDire='001'
			
		ENDIF
		IF !EMPTY(m.CorAux)
			SELECT cdire
*!*				SEEK m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux))+'002'
			LsCodDire=LoData.Cap_NroItm(m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux)),'CDIRE','ClfAux+CodAux','CodDire' )	
			IF LsCodDire='002'	
				m.CodDire = '002'
				APPEND BLANK
				GATHER MEMVAR FIELDS LIKE ClfAux,CodAux,CodDire		
			ENDIF
			UPDATE cdire SET ;
			 DesDire = m.CorAux ,;
			 CodDist  = m.CodPos,;
			 cODpAIS = '51',;
			 CodCli = m.CodCli,;
			 CodUser = m.CodUser,;
			 FchHora  = DATETIME() ;
			 WHERE ClfAux+CodAux= m.ClfAux+PADR(m.CodAux,LEN(CDIRE.CodAux)) AND CodDire='002'
		ENDIF
		IF LEN(TRIM(m.CodPos ))<=2 AND !EMPTY(m.CodPos)
			SELECT cdist
			SEEK PADR(m.CodPos,LEN(CodDist))
			IF !found()
				APPEND BLANK
				replace coddist WITH m.CodPos
			ENDIF
			=RLOCK()
			REPLACE CodZona WITH '01'
			UNLOCK 
		ENDIF
	ENDIF
		
	SELECT c2	
ENDSCAN

IF USED('c2')
	USE IN C2
ENDIF
IF USED('CLIEN')
	USE IN CLIEN
ENDIF
IF USED('CDIRE')
	USE IN CDIRE
ENDIF
IF USED('CDIST')
	USE IN CDIST
ENDIF
IF USED('AUXI')
	USE IN AUXI
	
ENDIF

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
FUNCTION alter_cbdmaux1
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
USE LsDBCiaAno+'CBDACMCT' ALIAS acct ORDER acct01


SELECT 0
USE LsDBCiaAno+'CBDTOPER' ORDER oper01 ALIAS oper SHARED

SELECT 0
USE LsDBCiaAno+'CBDMCTAS' ORDER CTAS01 ALIAS ctas SHARED


SELECT 0
USE ADMIN!ADMMTCMB ORDER tcmb01 ALIAS tcmb shared

SELECT 0
USE LsDBCiaAno+'CBDRMOVM' ORDER rMOV01 ALIAS rmov SHARED

SELECT 0
USE LsDBCiaAno+'CBDVMOVM' ORDER VMOV01 ALIAS vmov SHARED

LOCATE
LlEstaVacia=EOF()

SELECT 0
USE (LcTablaOrigen) ALIAS C2
SET ORDER TO VMOV01

SELECT C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LcTablaOrigDetalle = JUSTPATH(LcTablaOrigen)+'\CBDRMOVM'
LcNomArcOrigenDeta	=	JUSTSTEM(LcTablaOrigDetalle)
SELECT 0
USE (LcTablaOrigDetalle) ALIAS C3
SET ORDER TO RMOV01


LcAAAA=SUBSTR(LcNomArcOrigen,4,4)
*LcMes =F_Mes(SUBSTR(LcNomArcOrigen,1,3))
SELECT 0
SELECT codcta,nomcta,an1cta,cc1cta,genaut from ctas WHERE genaut='S' INTO table c4
INDEX ON an1cta TAG an1cta
INDEX ON cc1cta TAG cc1cta

LsCodDiv = IIF("CLIENTES\STI"$_RutaOrig OR "\CLIENTES\GIMNASIO"$_RutaOrig ,RIGHT(_CiaOrig,2),'')

=STRTOFILE(lscoddiv+CRLF,"c:\temp\errortrf.txt",.t.)
=STRTOFILE(_RutaOrig+CRLF,"c:\temp\errortrf.txt",.t.)
LsFiltroDiv1 = IIF(EMPTY(LsCodDiv),'.T.',"Auxil=LsCodDiv")
LsFiltroDiv2 = IIF(EMPTY(LsCodDiv),'.T.',"CodDiv=LsCodDiv")

WAIT WINDOW 'Borrando transacciones anteriores' nowait
Cancelar = .F.
** Borrar datos anteriores de la cabecera **
FOR K= _MesIni TO _MesFin 	
	LcMes = TRANSFORM(K,'@L 99')
	SELECT vmov
	SEEK LcMes
	DELETE while NroMes = LcMes FOR  INLIST(CodOpe,&_CodOpes)  AND &LsForFechaAst AND (Digita='VETTTR1' OR HorDig='VETTTR1') AND &LsFiltroDiv1
	*PACK
	**
	** Borrar datos anteriores de EL  DETALLE **

	SELECT Rmov
	SEEK LcMes
	DELETE while NroMes = LcMes FOR  INLIST(CodOpe,&_CodOpes) AND &LsForFechaAst  AND NumOri='VETTTR1'  AND &LsFiltroDiv2
	*PACK
	
	Cancelar = ( INKEY() = k_esc )

	*!*	SELECT OPER
	*!*	SCAN 
	*!*		CmpNro = [NDOC]+LcMes
	*!*		iNroMes = 1
	*!*		REPLACE &CmpNro. WITH iNroMes
	*!*	ENDSCAN
	IF CheckCancel()
		EXIT
	ENDIF

	SELECT c2
	SEEK LcMes
	SCAN  WHILE NroMes=LcMes FOR INLIST(CodOpe,&_CodOpes)  AND &LsForFechaAst AND !Cancelar
		SCATTER memvar
		XsNroMes = m.NroMes
		_Mes     = VAL(m.NroMes)
		
		IF EMPTY(m.CodOpe)
			=MESSAGEBOX('Codigo de operación no existe',16  )
			SET STEP ON 
		ENDIF
		LlExisteOper=SEEK(m.CodOpe,'OPER','OPER01') 

*!*			IF nroast='020199'		
*!*				SET STEP ON 
*!*			ENDIF
        XsCodDiv = IIF(EMPTY(LsCodDiv),'01',LsCodDiv)
		XsCodOpe = m.CodOpe
		XsNroAst = m.NroAst
		*m.NroAst = Nroast && Nroast()
		m.NroVou = NroVou
		m.FchAst = FchAst
		m.CodMon = CodMon
		XsDigita 	=	'VETTTR1'
		m.Digita = XsDigita
		m.HorDig = XsDigita
		m.FchDig = DATE()
		m.Auxil  = LsCodDiv
		=SEEK(DTOS(m.FchAst),'TCMB','TCMB01')
		m.TpoCmb = TpoCmb
		SELECT VMOV
		NClave   = [NroMes+CodOpe+NroAst]
		VClave   = XsNroMes+XsCodOpe+XsNroAst
		RegVal   = "&NClave = VClave"
		vClave2  = XsNroMes+XsCodOpe+PADR(XsNroAst,LEN(VMOV.NroAst))
		IF SEEK(VClave2,'VMOV')
			=RLOCK()
			GATHER MEMVAR			
			UNLOCK
		ELSE
			APPEND BLANK
			GATHER MEMVAR	
		ENDIF
		XiNroItm = 0
		WAIT WINDOW 'Actualizando:'+XsNromes+'-'+XsCodOpe+'-'+XsNroAst NOWAIT
		*=NroAst(XsNroASt)
		SELECT C3
		SEEK VClave
		SCAN	WHILE  &RegVal.
			XcAfecto  = Afecto
			XsCodCta = PADR(CODCTA,LEN(ctas.codcta))
			XsClfAux = ClfAux
			XsCodAux = CodAux
			XcTpoMov = TpoMov  && IIF(!EMPTY(Debe),'D','H')
			XsCodDoc = CodDoc
			XsNroDoc = NroDoc
			XdFchDoc = FchDoc
			XiCodmon   = CodMon   && m.CodMon
			IF INLIST(GsSigCia,'YTBFITNESS','FITNESSINV')  && LA MONEDA SEGUN LA CABECERA 
				XiCodMon = VMOV.CodMon
			ENDIF
			XsGloDoc   = GloDoc
			XiNroItm   = NroItm
			XcEliItm   = ''		
			YcEliItm   = ''	
			XsCodRef   = CodRef
			XfTpoCmb   = TpoCmb
			XdFchAst   = VMOV.FchAst
			XdFchVto   = FchVto
			XdFchPed   = {}	
			XcAfecto   = IIF(LlExisteOper AND INLIST(UPPER(OPER.Siglas),'VENTA','COMPRA') AND EMPTY(Afecto),'A',Afecto) 
			XsCodCCo	= CodCco
		
			XsNumOri	=	'VETTTR1'			
			STORE .f. to lAn1Cta,lCC1Cta
			
			IF XcTpoMov='D'
				IF XiCodMon=1
					XfImport = Import
				ELSE
					XfImport = ImpUsa
				ENDIF	
				XfImpUsa = ImpUsa
				XfImpNac = Import
			ELSE
				IF XiCodMon=1
					XfImport = Import
				ELSE
					XfImport = ImpUSa
				ENDIF	
			
				XfImpUsa = ImpUsa
				XfImpNac = Import
			ENDIF	

	*!*			IF XiCodMon=1
	*!*	           XfImpNac    = XfImport
	*!*	           XfImpUsa    = round(XfImport/VMOV.TpoCmb,2)
	*!*	        ELSE
	*!*	           XfImpUsa    = XfImport
	*!*	           XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
	*!*	        ENDIF
	        XsChkCta = SYS(2015)
	        XsCodDiv = IIF(EMPTY(LsCodDiv),'01',LsCodDiv)
	        dimension vcodcta(10)
			store 0 to numcta,nImpNac,nImpUsa
			
	*!*			IF xScODoPE='003' AND !INLIST(XSCODCTA,'42','40','00')
	*!*	*			SET STEP ON 
	*!*			ENDIF
			LAn1cta=SEEK(XsCodCta,'C4','An1cta')
			lCc1cta=SEEK(XsCodCta,'C4','CC1CTA')
	*!*			IF lAn1Cta OR lCC1Cta
	*!*				YcEliItm = '*'
	*!*			ENDIF
			DO CASE
				CASE INLIST(ASC(EliItm),183)  
					XcEliItm = '*'
				CASE INLIST(ASC(EliItm),46)  
					XcEliItm = '.'				
				CASE INLIST(ASC(EliItm),176)  
					XcEliItm = ':'				
					
			ENDCASE
			IF XiNroItm=0
				XiNroItm = XiNroItm +  1
			ENDIF
			*=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
			GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
			SELECT C3		
			Cancelar = ( INKEY() = k_esc )
		ENDSCAN
		** Cambiamos Numeracion del asiento 
		IF CheckCancel()
			EXIT
		ENDIF

		LsNuevoASt=XsCodDiv+PADR(XsNroAst,LEN(VMOV.NroAst))
		LlExisteAst = .F.
		SELECT VMOV
		SEEK XsNroMes+XsCodOpe+LsNuevoASt
		IF FOUND()
			LsNuevoASt = GOSVRCBD.NROAST()
			LlExisteAst = .T.
		ENDIF
		IF LlExisteAst
**			SET STEP ON  
		ENDIF
		SELECT RMOV
		SEEK vClave2
		DO WHILE  NroMes+CodOpe+NroAst=vClave2 AND !Cancelar
			=RLOCK()
			replace NroAst WITH LsNuevoASt
			replace NumOri WITH 'VETTTR1'
			unlock
			SEEK XsNroMes+XsCodOpe+XsNroAst			
			Cancelar = ( INKEY() = k_esc )
			IF CheckCancel()
				EXIT
			ENDIF
		ENDDO
		SELECT VMOV
		SEEK vClave2
		IF FOUND() AND RLOCK()
			replace NroVou WITH NroAst
			replace NroAst WITH LsNuevoASt
			IF  LlExisteAst 
				=GOSVRCBD.NROAST(LsNuevoASt)
			ENDIF
			UNLOCK IN VMOV
		ENDIF
		**			
		FLUSH in "RMOV"
		FLUSH IN "VMOV"
		SELECT C2
		Cancelar = ( INKEY() = k_esc )
		IF CheckCancel()
			EXIT
		ENDIF
	ENDSCAN

ENDFOR
USE IN c2
USE IN C3
USE IN C4
USE IN OPER
USE IN vmov
USE IN rmov
USE IN ctas
USE IN TCMB
USE IN acct
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
IF USED(LcNomArcOrigenDeta)	
	USE IN (LcNomArcOrigenDeta)
ENDIF
WAIT WINDOW 'Proceso terminado' NOWAIT

*************************
FUNCTION alter_cbdvmovm_Simco
*************************
** variables que se utilizan para grabar el detalle del asiento **
** Pronto sera un objeto como el que se creo para las transacciones de ventas 

STORE '' TO NCLAVE,VCLAVE,REGVAL
STORE '' to XsCodCta,XsClfAux,XsCodAux,XsCodPrv,XsNomPrv,XsRefPrv,XsIniAux,XsCodRef,XsCodRef ,xsglodoc,XdFchDoc
STORE '' to XdFchVto,XdFchPed ,xsnivadi,XsCodDoc,XsNroDoc,XsNroRef ,XSCODFIN,XcTpoMov,XfImport ,XfImpNac,XfImpUsa
STORE '' to XiNroitm, XcTipoC,XsNroRuc,XsTipDoc,xstipdoc1,xscodcta1,xsnroref1,xstipori,xsnumori,xsfecori,xsimpori
STORE '' to xsnumpol,xsimpnac1,xsimpnac2
STORE '' TO XsCodCco,XsAn1Cta,XsCC1Cta,XsChkCta,XsCtaPre




WAIT WINDOW 'Abriendo archivos...' nowait
*!*	Simco : Abrir tabla de rutas y equivalencias de tablas con o-Negocios
SELECT 0
USE int_Rutas ALIAS IRUT 
SET ORDER TO IRUT02   && CODCIA_FIN+TABLA_FIN



SELECT 0
USE LsDBCiaAno+'CBDACMCT' ALIAS acct ORDER acct01


SELECT 0
USE LsDBCiaAno+'CBDTOPER' ORDER oper01 ALIAS oper SHARED

SELECT 0
USE LsDBCiaAno+'CBDMCTAS' ORDER CTAS01 ALIAS ctas SHARED


SELECT 0
USE ADMIN!ADMMTCMB ORDER tcmb01 ALIAS tcmb shared

SELECT 0
USE LsDBCiaAno+'CBDRMOVM' ORDER rMOV01 ALIAS rmov SHARED

SELECT 0
USE LsDBCiaAno+'CBDVMOVM' ORDER VMOV01 ALIAS vmov SHARED

LOCATE
LlEstaVacia=EOF()

SELECT IRUT
SET ORDER TO IRUT02   && CODCIA_FIN+TABLA_FIN 
SEEK GsCodCia+'CBDVMOVM'

SELECT 0
USE USE (ADDBS(IRUT.Ruta_INI)+IRUT.Tabla_ini) ALIAS C2
SET ORDER TO (IRUT.Tag_INI)

SELECT C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LcTablaOrigDetalle = JUSTPATH(LcTablaOrigen)+'\CBDRMOVM'
LcNomArcOrigenDeta	=	JUSTSTEM(LcTablaOrigDetalle)

SELECT IRUT
SET ORDER TO IRUT02   && CODCIA_FIN+TABLA_FIN 
SEEK GsCodCia+'CBDVMOVM'
LsFiltroC2 = IIF(EMPTY(Filtro),'.T.',TRIM(Filtro))
LcFile = Tabla_INI
SELECT 0
USE (ADDBS(IRUT.Ruta_Fin)+IRUT.Tabla_Fin) ALIAS C3
SET ORDER TO (IRUT.Tag_Fin)
LsFiltroC3 = IIF(EMPTY(Filtro),'.T.',TRIM(Filtro))

LcAAAA=SUBSTR(LcNomArcOrigen,4,4)
*LcMes =F_Mes(SUBSTR(LcNomArcOrigen,1,3))
SELECT 0
SELECT codcta,nomcta,an1cta,cc1cta,genaut from ctas WHERE genaut='S' INTO table c4
INDEX ON an1cta TAG an1cta
INDEX ON cc1cta TAG cc1cta

LsCodDiv = '' && IIF("CLIENTES\STI"$_RutaOrig OR "\CLIENTES\GIMNASIO"$_RutaOrig ,RIGHT(_CiaOrig,2),'')
*!*	Simco : Divisionaria no se usa
=STRTOFILE(lscoddiv+CRLF,"c:\temp\errortrf.txt",.t.)
=STRTOFILE(_RutaOrig+CRLF,"c:\temp\errortrf.txt",.t.)
LsFiltroDiv1 = IIF(EMPTY(LsCodDiv),'.T.',"Auxil=LsCodDiv")
LsFiltroDiv2 = IIF(EMPTY(LsCodDiv),'.T.',"CodDiv=LsCodDiv")

WAIT WINDOW 'Borrando transacciones anteriores' nowait
Cancelar = .F.
** Borrar datos anteriores de la cabecera **
FOR K= _MesIni TO _MesFin 	
	LcMes = TRANSFORM(K,'@L 99')
	SELECT vmov
	SEEK LcMes
	DELETE while NroMes = LcMes FOR  INLIST(CodOpe,&_CodOpes)  AND &LsForFechaAst AND (Digita='VETTTR1' OR HorDig='VETTTR1') AND &LsFiltroDiv1
	*PACK
	**
	** Borrar datos anteriores de EL  DETALLE **

	SELECT Rmov
	SEEK LcMes
	DELETE while NroMes = LcMes FOR  INLIST(CodOpe,&_CodOpes) AND &LsForFechaAst  AND NumOri='VETTTR1'  AND &LsFiltroDiv2
	*PACK
	
	Cancelar = ( INKEY() = k_esc )

	*!*	SELECT OPER
	*!*	SCAN 
	*!*		CmpNro = [NDOC]+LcMes
	*!*		iNroMes = 1
	*!*		REPLACE &CmpNro. WITH iNroMes
	*!*	ENDSCAN
	IF CheckCancel()
		EXIT
	ENDIF
	
	SELECT 0
	USE D:\sistema\simco1.0\fabrica\comun\relacion 
	SET ORDER TO CCODREL  
	
	SELECT FACT.OPER, FACT.N_FACT, FACT.CLIENTE, IIF(FACT.ANULA_DOC<>.T., RELACION.RAZONSOC, "A  N  U  L  A  D  O                        ") AS _NCLIENTE,;
	 FACT.FECHA, FACT.CORRELA, IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_BRUTOMN*-1, FACT.V_BRUTOMN), 000000000.00 ) AS _BRUTO,;
	 IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_VENTAMN*-1, FACT.V_VENTAMN), 000000000.00 ) AS _VENTA,;
	 IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_AFECTOMN*-1, FACT.V_AFECTOMN), 000000000.00 ) AS _AFECTO,;
	 IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_INAFECTOMN*-1, FACT.V_INAFECTOMN), 000000000.00 ) AS _INAFECTO,;
	 IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_IGVMN*-1, FACT.V_IGVMN), 000000000.00 ) AS _IGV, ;
	 IIF(FACT.ANULA_DOC<>.T., IIF(FACT.OPER="53", FACT.V_TOTALMN*-1, FACT.V_TOTALMN), 000000000.00 ) AS _TOTAL,;
        FACT.MONEDA, FACT.T_CAMBIO, FACT.SERIE_DOC, FACT.ANULA_DOC, FACT.TDSUNAT, RELACION.RUC, RELACION.CATEGORIA, ;
        FACT.FEC_NCND, FACT.REF_NCND, FACT.TDSU_NCND, FACT.CONVTA, FACT.VENCE, FACT.XFILE, FACT.VOUCHERS, TABOPER.OP_DES ; 
        FROM fact INNER JOIN relacion ON RELACION.CODREL=FACT.CLIENTE ;
        INNER JOIN taboper ON TABOPER.OP_COD=FACT.OPER ; 
        WHERE FACT.CIA=MEN_CIA AND SUBSTR(DTOS(FACT.FECHA), 1, 6)=_RANGO1 ORDER BY 6 INTO CURSOR cEstadi
        
        
	SELECT c2
	SEEK LcMes
	SCAN  WHILE SUBSTR(DTOS(Fecha),5,2)=LcMes FOR &Filtro  AND &LsForFechaAst AND !Cancelar
		SCATTER memvar
		XsNroMes = SUBSTR(DTOS(Fecha),5,2)
		m.NroMes = XsNroMes
		_Mes     = VAL(XsNroMes)
		IF EMPTY(LcFile)
			=MESSAGEBOX('Codigo de operación origen no existe',16  )
			SET STEP ON 
		ENDIF
		DO CASE
			CASE LcFile='COMPRA'
				m.CodOpe= '005'
			CASE LcFile='FACT'
				m.CodOpe= '004'	
		ENDCASE
		LlExisteOper=SEEK(m.CodOpe,'OPER','OPER01') 
		IF !LlExisteOper
			=MESSAGEBOX('Codigo de operación destino no existe',16  )
			SET STEP ON 
		ENDIF

*!*			IF nroast='020199'		
*!*				SET STEP ON 
*!*			ENDIF
	        XsCodDiv = IIF(EMPTY(LsCodDiv),'01',LsCodDiv)
		XsCodOpe = m.CodOpe
		XsNroAst = SUBSTR(Correla,5)
		*m.NroAst = Nroast && Nroast()
		m.NroVou = RIGHT(clvfact,LEN(VMOV.NroVou))
		m.FchAst = Fecha
		m.CodMon = Moneda
		XsDigita 	=	'VETTTR1'
		m.Digita = XsDigita
		m.HorDig = XsDigita
		m.FchDig = DATE()
		m.Auxil  = LsCodDiv
		
		XsNotAst = [PROV. ]+C2.CodDoc+[. ]+C2.NomCli
*!*			=SEEK(DTOS(m.FchAst),'TCMB','TCMB01')
*!*			m.TpoCmb = TpoCmb
		m.TpoCmb	=	t_cambio 
		SELECT VMOV
		NClave   = [NroMes+CodOpe+NroAst]
		VClave   = XsNroMes+XsCodOpe+XsNroAst
		RegVal   = "&NClave = VClave"
		vClave2  = XsNroMes+XsCodOpe+PADR(XsNroAst,LEN(VMOV.NroAst))
		IF SEEK(VClave2,'VMOV')
			=RLOCK()
			GATHER MEMVAR			
			UNLOCK
		ELSE
			APPEND BLANK
			GATHER MEMVAR	
		ENDIF
		XiNroItm = 0
		WAIT WINDOW 'Actualizando:'+XsNromes+'-'+XsCodOpe+'-'+XsNroAst NOWAIT
		*=NroAst(XsNroASt)
*!*			SELECT C3
*!*			SEEK VClave
*!*			SCAN	WHILE  &RegVal.
			XcAfecto  = 'A'
			XsCodCta = PADR(CODCTA,LEN(ctas.codcta))
			
			XsClfAux = IIF(LcFile='VENTA',GsClfCli,GsClfPro)
			XsCodAux = C2.Ruc
			XcTpoMov = 'D'  && IIF(!EMPTY(Debe),'D','H')
			XsCodDoc = C2.TdSunat
			XsNroDoc = C2.N_Fact
			XdFchDoc = C2.Fecha
			XiCodmon   = CodMon   && m.CodMon
			IF INLIST(GsSigCia,'YTBFITNESS','FITNESSINV')  && LA MONEDA SEGUN LA CABECERA 
				XiCodMon = VMOV.CodMon
			ENDIF
			XsGloDoc   = GloDoc
			XiNroItm   = 0
			XcEliItm   = ''		
			YcEliItm   = ''	
			XsCodRef   = ''
			XfTpoCmb   = VMOV.TpoCmb
			XdFchAst   = VMOV.FchAst
			XdFchVto   = Vence
			XdFchPed   = {}	
			XcAfecto   = IIF(LlExisteOper AND INLIST(UPPER(OPER.Siglas),'VENTA','COMPRA') AND EMPTY(Afecto),'A',Afecto) 
			XsCodCCo	= ''
			DO CASE 
				CASE LcFile='FACT'
					XdFchRef	= FACT.FEC_NCND
					XsNroRef	= FACT.REF_NCND	
					XfImport	= FACT.V_AFECTOMN
					XcTpoMov	= 'H'
					XcEliItm = [ ]
					XsCodCta	= '' &&&???????
				CASE  LcFile='COMPRA'
				
				CASE  LcFile='CONTAB'
					
			ENDCASE
			XsNumOri	=	'VETTTR1'			
			
			STORE .f. to lAn1Cta,lCC1Cta
			IF XcTpoMov='D'
				IF XiCodMon=1
					XfImport = Import
				ELSE
					XfImport = ImpUsa
				ENDIF	
				XfImpUsa = ImpUsa
				XfImpNac = Import
			ELSE
				IF XiCodMon=1
					XfImport = Import
				ELSE
					XfImport = ImpUSa
				ENDIF	
			
				XfImpUsa = ImpUsa
				XfImpNac = Import
			ENDIF	

	*!*			IF XiCodMon=1
	*!*	           XfImpNac    = XfImport
	*!*	           XfImpUsa    = round(XfImport/VMOV.TpoCmb,2)
	*!*	        ELSE
	*!*	           XfImpUsa    = XfImport
	*!*	           XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
	*!*	        ENDIF
	        XsChkCta = SYS(2015)
	        XsCodDiv = IIF(EMPTY(LsCodDiv),'01',LsCodDiv)
	        dimension vcodcta(10)
			store 0 to numcta,nImpNac,nImpUsa
			
	*!*			IF xScODoPE='003' AND !INLIST(XSCODCTA,'42','40','00')
	*!*	*			SET STEP ON 
	*!*			ENDIF
			LAn1cta=SEEK(XsCodCta,'C4','An1cta')
			lCc1cta=SEEK(XsCodCta,'C4','CC1CTA')
	*!*			IF lAn1Cta OR lCC1Cta
	*!*				YcEliItm = '*'
	*!*			ENDIF
			DO CASE
				CASE INLIST(ASC(EliItm),183)  
					XcEliItm = '*'
				CASE INLIST(ASC(EliItm),46)  
					XcEliItm = '.'				
				CASE INLIST(ASC(EliItm),176)  
					XcEliItm = ':'				
					
			ENDCASE
			IF XiNroItm=0
				XiNroItm = XiNroItm +  1
			ENDIF
			*=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
			GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
*!*				SELECT C3		
*!*				Cancelar = ( INKEY() = k_esc )
*!*			ENDSCAN
		** Cambiamos Numeracion del asiento 
		IF CheckCancel()
			EXIT
		ENDIF

		LsNuevoASt=XsCodDiv+PADR(XsNroAst,LEN(VMOV.NroAst))
		LlExisteAst = .F.
		SELECT VMOV
		SEEK XsNroMes+XsCodOpe+LsNuevoASt
		IF FOUND()
			LsNuevoASt = GOSVRCBD.NROAST()
			LlExisteAst = .T.
		ENDIF
		IF LlExisteAst
**			SET STEP ON  
		ENDIF
		SELECT RMOV
		SEEK vClave2
		DO WHILE  NroMes+CodOpe+NroAst=vClave2 AND !Cancelar
			=RLOCK()
			replace NroAst WITH LsNuevoASt
			replace NumOri WITH 'VETTTR1'
			unlock
			SEEK XsNroMes+XsCodOpe+XsNroAst			
			Cancelar = ( INKEY() = k_esc )
			IF CheckCancel()
				EXIT
			ENDIF
		ENDDO
		SELECT VMOV
		SEEK vClave2
		IF FOUND() AND RLOCK()
			replace NroVou WITH NroAst
			replace NroAst WITH LsNuevoASt
			IF  LlExisteAst 
				=GOSVRCBD.NROAST(LsNuevoASt)
			ENDIF
			UNLOCK IN VMOV
		ENDIF
		**			
		FLUSH in "RMOV"
		FLUSH IN "VMOV"
		SELECT C2
		Cancelar = ( INKEY() = k_esc )
		IF CheckCancel()
			EXIT
		ENDIF
	ENDSCAN

ENDFOR
USE IN c2
USE IN C3
USE IN C4
USE IN OPER
USE IN vmov
USE IN rmov
USE IN ctas
USE IN TCMB
USE IN acct
IF USED(LcNomArcOrigen)
	USE IN (LcNomArcOrigen)
ENDIF
IF USED(LcNomArcOrigenDeta)	
	USE IN (LcNomArcOrigenDeta)
ENDIF
WAIT WINDOW 'Proceso terminado' NOWAIT

***********************
FUNCTION alter_cbdvmovm_procont
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
USE LsDBCiaAno+'CBDACMCT' ALIAS acct ORDER acct01


SELECT 0
USE LsDBCiaAno+'CBDTOPER' ORDER oper01 ALIAS oper EXCLUSIVE

SELECT 0
USE LsDBCiaAno+'CBDMCTAS' ORDER CTAS01 ALIAS ctas EXCLUSIVE


SELECT 0
USE ADMIN!ADMMTCMB ORDER tcmb01 ALIAS tcmb shared

SELECT 0
USE LsDBCiaAno+'CBDRMOVM' ORDER rMOV01 ALIAS rmov EXCLUSIVE

SELECT 0
USE LsDBCiaAno+'CBDVMOVM' ORDER VMOV01 ALIAS vmov EXCLUSIVE

LOCATE
LlEstaVacia=EOF()

SELECT 0
USE (LcTablaOrigen) ALIAS C2
SET ORDER TO VMOV01

SELECT C2
LcNomArcOrigen	=	JUSTSTEM(LcTablaOrigen)
LcTablaOrigDetalle = JUSTPATH(LcTablaOrigen)+'\CBDRMOVM'
LcNomArcOrigenDeta	=	JUSTSTEM(LcTablaOrigDetalle)
SELECT 0
USE (LcTablaOrigDetalle) ALIAS C3
SET ORDER TO RMOV01


LcAAAA=SUBSTR(LcNomArcOrigen,4,4)
LcMes =F_Mes(SUBSTR(LcNomArcOrigen,1,3))
SELECT 0
SELECT codcta,nomcta,an1cta,cc1cta,genaut from ctas WHERE genaut='S' INTO table c4
INDEX ON an1cta TAG an1cta
INDEX ON cc1cta TAG cc1cta



WAIT WINDOW 'Borrando transacciones anteriores' nowait

** Borrar datos anteriores de la cabecera **
FOR K= _MesIni TO _MesFin
	LcMes = TRANSFORM(K,'@L 99')
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
	
ENDFOR

SELECT OPER
SCAN 
	CmpNro = [NDOC]+LcMes
	iNroMes = 1
	REPLACE &CmpNro. WITH iNroMes
ENDSCAN

SELECT c2
SCAN  FOR INLIST(CodOpe,'004','010','027')
	m.NroMes = LcMes
	XsNroMes = LcMes
	_Mes     = VAL(m.NroMes)
	m.CodOpe = CodOpe
	IF EMPTY(m.CodOpe)
		=STRTOFILE('Codigo de operación en blanco'+m.NroMes+ '-'+ NroAst + CRLF,"c:\temp\errortrf.txt",.t.)
		LOOP
	ENDIF
	=SEEK(m.CodOpe,'OPER','OPER01') 

	

	XsCodOpe = m.CodOpe
	XsNroAst = m.NroAst
	m.NroAst = Nroast && Nroast()
	m.NroVou = NroVou
	m.FchAst = FchAst
	m.CodMon = CodMon
	
	=SEEK(DTOS(m.FchAst),'TCMB','TCMB01')
	m.TpoCmb = TpoCmb
	SELECT VMOV
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	RegVal   = "&NClave = VClave"
	IF SEEK(VClave,'VMOV')
		=RLOCK()
		GATHER MEMVAR			
		UNLOCK
	ELSE
		APPEND BLANK
		GATHER MEMVAR	
	ENDIF
	XiNroItm = 0
	WAIT WINDOW 'Actualizando:'+XsNromes+'-'+XsCodOpe+'-'+XsNroAst NOWAIT
	*=NroAst(XsNroASt)
	SELECT C3
	SEEK VClave
	SCAN	WHILE  &RegVal.
		XcAfecto  = Afecto
		XsCodCta = PADR(CODCTA,LEN(ctas.codcta))
		XsClfAux = ClfAux
		XsCodAux = CodAux
		XcTpoMov = TpoMov  && IIF(!EMPTY(Debe),'D','H')
		XsCodDoc = CodDoc
		XsNroDoc = NroDoc
		XdFchDoc = FchDoc
		XiCodmon   = CodMon   && m.CodMon
		XsGloDoc   = GloDoc
		XiNroItm   = NroItm
		XcEliItm   = ''		
		YcEliItm   = ''	
		XsCodRef   = CodRef
		XfTpoCmb   = TpoCmb
		XdFchAst   = VMOV.FchAst
		XdFchVto   = FchVto
		XdFchPed   = {}	
		XcAfecto   = IIF(CodOpe='004' and Afecto<>'A','A', Afecto)  && Afecto
		XsCodCCo	= CodCco
		
		STORE .f. to lAn1Cta,lCC1Cta
		
		IF XcTpoMov='D'
			IF XiCodMon=1
				XfImport = Import
			ELSE
				XfImport = ImpUsa
			ENDIF	
			XfImpUsa = ImpUsa
			XfImpNac = Import
		ELSE
			IF XiCodMon=1
				XfImport = Import
			ELSE
				XfImport = ImpUSa
			ENDIF	
		
			XfImpUsa = ImpUsa
			XfImpNac = Import
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
		
*!*			IF xScODoPE='003' AND !INLIST(XSCODCTA,'42','40','00')
*!*	*			SET STEP ON 
*!*			ENDIF
		LAn1cta=SEEK(XsCodCta,'C4','An1cta')
		lCc1cta=SEEK(XsCodCta,'C4','CC1CTA')
*!*			IF lAn1Cta OR lCC1Cta
*!*				YcEliItm = '*'
*!*			ENDIF
		DO CASE
			CASE INLIST(ASC(EliItm),183,250)  
				XcEliItm = '*'
			CASE INLIST(ASC(EliItm),46)  
				XcEliItm = '.'				
			CASE INLIST(ASC(EliItm),176)  
				XcEliItm = ':'				
				
		ENDCASE

		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		
		SELECT C3		
	ENDSCAN
	** Cambiamos Numeracion del asiento 
	** Primero verificamos si el nuevo asiento existe 
	LsNuevoASt='01'+NroAst
	SELECT VMOV
	SEEK XsNroMes+XsCodOpe+LsNuevoASt
	IF FOUND()
		LsNuevoASt = GOSVRCBD.NROAST()
	ENDIF
	SELECT RMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	DO WHILE  &RegVal
		replace NroAst WITH LsNuevoASt
		SEEK XsNroMes+XsCodOpe+XsNroAst			
	ENDDO
	SELECT VMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	IF FOUND() AND RLOCK()
		replace NroAst WITH LsNuevoASt
		=GOSVRCBD.NROAST(XsNroAst)
	ENDIF
	**			
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

********************
FUNCTION CheckCancel
********************
IF Cancelar 
	=MESSAGEBOX('Se ha cancelado el proceso',48,'ATENCION!!! / WARNING !!!')
	RETURN .T.
ENDIF
RETURN .F.