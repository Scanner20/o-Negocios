*** Abrimos Bases ****
#Include const.h
goentorno.open_dbf1('ABRIR','cbdacmct','ACCT','ACCT01','') 
goentorno.open_dbf1('ABRIR','cbdmctas','CTAS','CTAS01','') 
goentorno.open_dbf1('ABRIR','cbdrmovm','RMOV','RMOV03','') 
goentorno.open_dbf1('ABRIR','cbdvmovm','VMOV','VMOV01','') 
goentorno.open_dbf1('ABRIR','cbdmtabl','TABL','TABL01','') 
goentorno.open_dbf1('ABRIR','cbdtoper','OPER','OPER01','') 
goentorno.open_dbf1('ABRIR','cbdmauxi','AUXI','AUXI01','') 
goentorno.open_dbf1('ABRIR','cbdppres','PPRES','PPRE01','') 
*** Final de Apertura ****
SELECT ACCT
SET FILTER TO NROMES <= STR(_MES,2,0)
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO MAYOR AUXILIAR"
********* Variables  a usar ***********
XiCodMon = 1
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XsCodOpe = SPACE(LEN(RMOV->CodOpe))
XsCodAux = SPACE(LEN(RMOV->CodAux))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XnMes	= _Mes
XnMes2	= _Mes
XlSinCCo = .F.
XsCodCCo = SPACE(LEN(RMOV.CodCco))
LsTitulo1 = ''
LSTitulo2 = ''
XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv
*
DIMENSION vCampo(1),vNombre(1)
STORE [] TO vCampo, vNombre
*
DO FORM cbd_report_libro_mayor_auxiliar
RETURN

******************
PROCEDURE IMPRIMIR
******************
SELECT ACCT
SET FILTER TO NROMES <= STR(XnMES2,2,0)
SELECT RMOV
DO CASE
	CASE !EMPTY(XsCodOpe) .and. EMPTY(XsCodAux)
		SET FILTER TO CodOpe = XsCodOpe
	CASE EMPTY(XsCodOpe) .and. !EMPTY(XsCodAux)
		SET FILTER TO CodAux = XsCodAux
	CASE !EMPTY(XsCodOpe) .and. !EMPTY(XsCodAux)
		SET FILTER TO CodAux = XsCodAux .and. CodOpe = XsCodOpe
ENDCASE
SELECT CTAS
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

Cancelar = .F.
NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol)
NumPag  = 0

SEEK TRIM(XsCtaDes)
STORE 0 TO W
DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar

	CodCta1 = LEFT(CodCta,2)
	NomCta1 = ""
	NumItm1 = 0
	STORE 0 TO Z
	SaltaPag = .T.
	DO WHILE CodCta=CodCta1 .AND. ! EOF() .AND. ! Cancelar
		IF CODCTA = PADR(CodCta1,LEN(CODCTA))
            NomCta1 = NomCta
		ENDIF
		IF AftMov = "S"
			IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
			ELSE
				IF CodCta_B=XsCodDiv
				ELSE
					SELECT CTAS
					SKIP
					LOOP	
				ENDIF
			ENDIF
			DO LinImp
		ENDIF
		SELECT CTAS
		SKIP
		Cancelar = Cancelar .OR. (INKEY() = k_esc)
		IF CodCta>XsCtaHas
			EXIT
		ENDIF
	ENDDO
		 
	IF NumItm1 > 0 .AND. ! Cancelar

		m.Quiebre = 'E'
		m.CodCta = CodCta1
		m.NomCta = "* TOTAL CUENTA * "+TRIM(CodCta1)+ ' ' +NomCta1
		** --- **
		LzSaldo = Z(1)+Z(2)-Z(3)
		IF LzSaldo > 0
			Z(4) =  LzSaldo
		ELSE
			Z(5) =  -LzSaldo
		ENDIF
		** --- **
		FOR I=1 TO 5
			Col = (i-1)*13 + 69
			IF I>1
				IF Z(I) >= 0
					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
					&LsCampo = Z(I)
				ELSE
					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
					&LsCampo = Z(I)
				ENDIF
				W(I) = W(I) + Z(I)
			ENDIF

		ENDFOR
		** -- **		
		

		
*!*			LwSaldo = W(1)+W(2)-W(3)
*!*			IF LwSaldo > 0
*!*				W(4) = W(4) +   LwSaldo
*!*			ELSE
*!*				W(5) = W(5) +  -LwSaldo
*!*			ENDIF

		
		=GrbTmp(m.QuieBre,m.CodCta)
	ENDIF
ENDDO
IF ! CANCELAR
	m.Quiebre = 'F'
	m.CodCta	= 'TOTAL'
	m.NomCta	= "** TOTAL   GENERAL **"

	FOR I=2 TO 5
		Col = (i-1)*13 + 69
		IF W(I) >= 0
			LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
			&LsCampo = W(I)

		ELSE
			LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
			&LsCampo = W(I)

		ENDIF
	ENDFOR
	
	=GrbTmp(m.QuieBre,m.CodCta)
ENDIF


RETURN

****************
PROCEDURE LinImp
****************
PRIVATE NumLin
LsNroMes = transf(XnMES,"@L ##")
*!*	IF ctas.codcta='40111'
*!*		SET STEP ON 
*!*	endif
SELECT ACCT
SET ORDER TO ACCT02
SEEK CTAS->CodCta
IF ! FOUND()
	RETURN
ENDIF
STORE 0 TO Y
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. ! Cancelar
	STORE 0 TO X
	LsCodRef = CodRef
	*** Saldo al mes Anterior ***
	DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef
		IF NroMes <  STR(XnMES,2,0)
			IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
			
				IF XiCodMon = 1
					X(1) = X(1) + DbeNac - HbeNac
				ELSE
					X(1) = X(1) + DbeExt - HbeExt
				ENDIF
			ELSE
				LsDbeNacDiv	=	'DbeNac'+TRANSFORM(XnCodDiv,'@L 99')
				LsHbeNacDiv	=	'HbeNac'+TRANSFORM(XnCodDiv,'@L 99')
				LsDbeExtDiv	=	'DbeExt'+TRANSFORM(XnCodDiv,'@L 99')
				LsHbeExtDiv	=	'HbeExt'+TRANSFORM(XnCodDiv,'@L 99')
				IF XiCodMon = 1
					X(1) = X(1) + &LsDbeNacDiv. - &LsHbeNacDiv.
				ELSE
					X(1) = X(1) + &LsDbeExtDiv. - &LsHbeExtDiv.
				ENDIF
			
			ENDIF	
		ENDIF
		SKIP
	ENDDO
*!*		DO CASE 
*!*			CASE XnMes<>XnMes2
*!*			   SET STEP ON
			IF CTAS.CODCTA='40199'
*!*					SET STEP ON 
 			ENDIF 
			NumItm2 = 0
			FOR k = XnMes TO XnMes2		
				LsNroMes = TRANSFORM(k,'@L 99')
				DO ImpRMOV
			ENDFOR 
			** INI --- VETT 2008-07-10 ---**
			IF NumItm2 = 0
				m.QuieBre	= 'C'
				m.CodCta = CTAS.CodCta
				m.CodRef = LsCodRef
				IF ! ( EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)) )
					m.NomCta 	=	AUXI->NomAux
				ELSE
					m.NomCta	=	CTAS->NomCta
				ENDIF
				
				IF X(1) > 0
					m.t01 =  X(1)
				ELSE
					m.t01 =  X(1)
				ENDIF
				m.t02 = 0
				m.t03 = 0
				m.t04 = 0
				m.t05 = 0
				=GrbTmp(m.QuieBre,m.CodCta)
			ENDIF
			** FIN --- VETT 2008-07-10 ---**
			
			FOR I=1 TO 3
				Y(I) = Y(I) + X(I)
			ENDFOR
			LySaldo = Y(1)+Y(2)-Y(3)
			IF LySaldo > 0
				Y(4) =  LySaldo
			ELSE
				Y(5) = -LySaldo
			ENDIF
			

*!*			CASE XnMes=XnMes2
*!*				DO ImpRMOV
*!*		ENDCASE
	
	SELECT ACCT
ENDDO


	m.Quiebre = 'D'
	m.CoDcta  = CTAS->CodCta
	m.NomCta	= "TOTAL SUBCTA    "+TRIM(CTAS->CodCta)+' '+TRIM(CTAS->NomCta)
	FOR I=1 TO 5

		IF i>1
		    IF Y(I) >= 0
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = Y(I)

		    ELSE
				LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
				&LsCampo = Y(I)
		    ENDIF
	    ENDIF
	    IF I <=3
		    Z(I) = Z(I) + Y(I)
	    ENDIF
	ENDFOR
IF NumItm2>0
	=GrbTmp(m.QuieBre,m.CodCta)
ENDIF
RETURN
******************
PROCEDURE ImpRMOV
******************
NumItm1 = NumItm1 + 1

m.NroVou = ''

SELECT AUXI
IF ! EMPTY(CTAS->CLFAUX) .AND. CTAS->CodRef = REPLICATE("0",LEN(CTAS->CodRef))
	SEEK CTAS->ClfAux+LEFT(LsCodRef,LEN(AUXI->CODAUX))
ELSE
	SEEK "001"+LEFT(LsCodRef,LEN(AUXI->CODAUX))
ENDIF
IF EMPTY(XsCodCCo)
	XsFOR1='.T.'
ELSE	
	XsFOR1=[CodCco=XsCodCCo]
ENDIF
XsFor1= XsFor1+ IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')
SELECT RMOV
SEEK LsNroMes+CTAS->CodCta+LsCodRef
DO WHILE CODCTA = CTAS->CODCTA .AND. ! EOF() .AND. CodRef = LsCodRef .AND. ! Cancelar .AND. NroMes = LsNroMes
	IF !EVALUATE(XsFor1)
		SELECT rmov		
		skip
		LOOP
	ENDIF
	IF XlSinCCo  AND !EMPTY(RMOV.COdCCo)
		SELECT rmov		
		skip
		LOOP
	ENDIF
	IF NumItm2 = 0
		M.Quiebre = 'A'
		IF ! ( EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)) )
			m.NomCta 	=	AUXI->NomAux
		ELSE
			m.NomCta	=	CTAS->NomCta
		ENDIF
		IF X(1) > 0
			m.t01 = x(1)
		ELSE
			m.t01 = x(1)
		ENDIF
		STORE 0 TO m.t02,m.t03,m.t04,m.t05
		m.CodCta = CTAS->CodCta
		=GrbTmp(m.QuieBre,m.CodCta)
	ENDIF
	SCATTER memvar
	STORE 0 TO m.t02,m.t03
	=SEEK(NROMES+CODOPE+NROAST,"VMOV")
	NumItm2 = NumItm2 + 1
	m.QuieBre = 'B'+NroMes
	IF ! EMPTY(FCHDOC)
		m.DesFch=TRANSF(DAY(FCHDOC),"@L ##")+TRANSF(MONTH(FCHDOC),"@L ##")+RIGHT(STR(YEAR(FCHDOC),4,0),2)	
	ELSE
		m.DesFch = TRANSF(DAY(FCHast),"@L ##")+TRANSF(MONTH(FCHast),"@L ##")+RIGHT(STR(YEAR(FCHast),4,0),2)	
	ENDIF
	LsImport = ""
	IF RMOV->CodMon <> 1 .AND. XiCodMon = 1
		LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"#####,###.##"))+")"
		IF RIGHT(LsImport,3)=".00)"
			LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"####,###,###"))+")"
		ENDIF
	ENDIF
	
	IF CTAS->CodMon = 2  .AND. XiCodMon = 1
		LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,2))+")"
		IF RIGHT(LsImport,3)=".00"
			LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
		ENDIF
	ENDIF
	DO CASE
		CASE ! EMPTY(RMOV->Glodoc)
			LsGloDoc = LEFT(GloDoc,38-LEN(LsImport))+LsImport
		CASE ! EMPTY(AUXI->NomAux)
			LsGloDoc = LEFT(AUXI->NomAux,38-LEN(LsImport))+LsImport
		OTHER
			LsGloDoc = LEFT(VMOV->NotAst,38-LEN(LsImport))+LsImport
	ENDCASE
	m.NroVou = VMOV.NroVou
	m.GloDoc = LsGloDoc
	DO CalImp
	IF TPOMOV = "D"
		X(2) = X(2) + nImport
		m.t02 = nImport
	ELSE
		X(3) = X(3) + nImport
		m.t03 = nImport
	ENDIF
	m.t01 = 0
	m.t04 = 0
	m.t05 = 0
	=GrbTmp(m.QuieBre,m.CodCta)
	SKIP
	Cancelar = Cancelar .OR. (INKEY() = k_esc)
ENDDO
IF NumItm2 = 0  .AND. X(1) = 0
	RETURN
ENDIF
LfSaldo = X(1)+X(2)-X(3)
IF LfSaldo > 0
	X(4) =  LfSaldo
ELSE
	X(5) = -LfSaldo
ENDIF
*!*	FOR I=1 TO 5
*!*		Y(I) = Y(I) + X(I)
*!*	ENDFOR

*!*	*!*	IF ! (EMPTY(LsCodRef) .OR. LsCodRef = REPLICATE("0",LEN(LsCodRef)))
*!*	*!*		m.Quiebre	= 'C'
*!*	*!*		m.CodRef	= LsCodRef
*!*	*!*		m.CodCta	= CTAS.CodCta
*!*	*!*		m.NomCta	= "TOTAL AUXILIAR  "+CTAS->CodCta	
*!*	*!*		m.NomAux	= AUXi.NOMAux
*!*	*!*		m.CodOpe	= ''
*!*	*!*		m.Glodoc	= ''
*!*	*!*		m.NroVou	= ''
*!*	*!*		m.NroAst	= ''
*!*	*!*		FOR I=2 TO 5
*!*	*!*			Col = (i-1)*13 + 69
*!*	*!*			IF X(I) >= 0
*!*	*!*					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
*!*	*!*					&LsCampo = X(I)
*!*	*!*			ELSE
*!*	*!*					LsCampo = 'm.T'+TRANSFORM(I,'@L 99')
*!*	*!*					&LsCampo = X(I)
*!*	*!*			ENDIF
*!*	*!*		ENDFOR
*!*	*!*		=GrbTmp(m.QuieBre,m.CodCta)
*!*	*!*	ENDIF
RETURN
****************
PROCEDURE GrbTmp
****************
PARAMETERS _Quiebre,_CodCta
LOCAL LsAlias_Act
Lsalias_Act = SELECT()
SELECT temporal
*!*	SEEK _Quiebre+_CodCta
*!*	IF !FOUND()
	APPEND BLANK
*!*		replace QuieBre WITH _Quiebre
*!*		replace CodCta	WITH _CodCta
*!*	ENDIF
DO CASE
	CASE _Quiebre='E'
		m.CodCta2 = LEFT(_Codcta,2)+_Quiebre
	OTHERWISE
		m.CodCta2 = LEFT(_Codcta,2)
ENDCASE
GATHER memvar
SELECT (LsAlias_Act)

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltaPag
	IF NumPag > 0 .AND. ! SaltaPag
		NumLin =  LinFin+2
		IF NumLin < PROW()+ 1
			NumLin =  PROW()+1
		ENDIF
		@ NumLin,10 SAY "VAN ......"
	ENDIF
	SaltaPag = .F.
	DO F0MBPRN 
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
	IF NumPag > 1
		@ PROW()+1,10 SAY "VIENEN ......"
		NumLin = PROW() + 1
		@ NumLin,005 SAY CTAS->CodCta
		@ NumLin,032 SAY LsCodRef
		IF ! EMPTY(LsCodRef)
			@ NumLin,044 SAY TRIM(AUXI->NomAux)+"     CONT..."
		ELSE
			@ NumLin,044 SAY TRIM(CTAS->NomCta)+"     CONT..."
		ENDIF
	ENDIF
ENDIF
RETURN
****************
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
nImport = IIF(XiCodMon=1,nImpNac,nImpUsa)
RETURN
********************
FUNCTION existeCampo
********************
PARAMETERS nombreCampo
numcampos = FCOUNT("temporal")
existe = .f.
FOR i=1 TO numcampos
	IF nombreCampo = FIELD(i,"temporal",0)
		existe = .t.
	endif
ENDFOR
IF existe =.f.
ENDIF
RETURN existe
***************************
FUNCTION Export_Tabla_Excel
***************************

LOCAL loExcel as "Excel.Application"
LOCAL loWrkBook AS "Excel.WorkBook"
LOCAL loSheet AS "Excel.Sheet"

loExcel = CREATEOBJECT("Excel.Application")
loExcel.DisplayAlerts = .F.
loExcel.Visible = .F.

loWrkBook = loExcel.Application.Workbooks.Add()
loSheet = loWrkBook.Sheets(1)
liRow = 0
SELECT TABL
SCAN FOR Tabla='00'
liRow = liRow + 1
lcRow = TRANSFORM(liRow)
loSheet.Range("A"+lcRow) = Codigo
loSheet.Range("B"+lcRow) = Nombre
loSheet.Range("C"+lcRow) = Digitos
ENDSCAN

loWrkBook.SaveAs("c:\temp\Excelfile")
loExcel.Visible = .T.

loSheet = .NULL.
loWrkBook = .NULL.
loExcel = .NULL.