cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CIERRE ANUAL DE OPERACIONES"

*!*	SET DISPLAY TO VGA25
*!*	DO def_teclas IN FxGen_2

*!*	Do F1_BASE WITH cTit4,cTit2,cTit3,cTit1

*!*	@  7,08 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
*!*	@  8,08 SAY '³                     I M P O R T A N T E                              ³'
*!*	@  9,08 SAY '³                                                                      ³'
*!*	@ 10,08 SAY '³    Este proceso tiene por finalidad preparar los archivos            ³'
*!*	@ 11,08 SAY '³   del  sistema para comenzar a procesar la informacion de            ³'
*!*	@ 12,08 SAY '³   un nuevo a¤o contable.                                             ³'
*!*	@ 13,08 SAY '³   Consiste en transferir los saldos contables y movimien-            ³'
*!*	@ 14,08 SAY '³   tos de cuenta corriente a otro directorio de un nuevo              ³'
*!*	@ 15,08 SAY '³   a¤o contable.                                                      ³'
*!*	@ 16,08 SAY '³   SOLO deber  efectuarse al FINALIZAR UN A¥O CONTABLE.               ³'
*!*	@ 17,08 SAY '³     Antes de realizar este proceso verifique que todos               ³'
*!*	@ 18,08 SAY '³   los balances esten correctos.                                      ³'
*!*	@ 19,08 SAY '³                      < C >  - Continuar                              ³'
*!*	@ 20,08 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
*!*	*
*!*	GsMsgKey = "[Esc] Cancelar Proceso        [C] Iniciar proceso"
*!*	DO LIB_Mtec WITH 99
*!*	************************************************************************
*!*	* Pide Confirmaci¢n de ingreso ******
*!*	************************************************************************
*!*	FinTecla = CHR(Escape_)+"cC"
*!*	UltTecla = 0
*!*	DO WHILE ! CHR(UltTecla)$FinTecla
*!*		UltTecla = INKEY(0)
*!*		UltTecla = IIF(UltTecla >0 , UltTecla , 0 )
*!*		IF UltTecla = Escape_
*!*			CLEAR MACROS
*!*			CLEAR 
*!*			IF WEXIST('__WFondo')
*!*				RELEASE WINDOW __WFondo
*!*			ENDIF
*!*			RETURN
*!*		ENDIF
*!*	ENDDO

**** directorio del A¥O que sigue
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
TsCodDiv1="01"
TsCodDiv2 = ''
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv

DO FORM CBD_CbdAnual 


RELEASE LoDatAdm
=BuildAccessCursor()
RETURN
*******************
PROCEDURE GenerAper
*******************
IF _dos OR _Unix
	DirNew = PATHDEF+"\CIA"+GsCodCia+"\C"+STR(_Ano+1,4,0)
	DirAct = SYS(2003)
ELSE
	DirNew = Lodatadm.oentorno.tspathcia+"C"+STR(_Ano+1,4,0)
	DirAct = Lodatadm.oentorno.tspathcia+"C"+STR(_Ano,4,0)
ENDIF	
**** TRATANDO DE CREAR EL DIRECTORIO *****
LsPathDatos =  ''

*** Controlamos la divisionaria ***
LcFiltro = '.T.'
LcFiltroMov='.T.'
IF XnCodDiv=0
	TsCodDiv1='00'
	LcFiltro = '.T.'
	LcFiltroMov='.T.'
	TsCodDiv2 = ''
ELSE
	IF XsCodDiv='**'
		TsCodDiv1='00'
		LcFiltro = '.T.'
		LcFiltroMov='.T.'
		TsCodDiv2 = ''
	ELSE
		TsCodDiv1=XsCodDiv
		LcFiltro = 'Codcta_b=XsCodDiv'
		LcFiltroMov='CodDiv=XsCodDiv'
		TsCodDiv2 = XsCodDiv
	ENDIF	
ENDIF	

IF _DOS OR _UNIX
	@ 19,10 SAY ""
	!MKDIR &DirNew > NULL
ELSE
	IF !DIRECTORY(DirNew)
		MKDIR (DirNew)
		*** Crear Base de datos ***
	ENDIF
	LsNewDataBase = 'P'+GsCodCia+STR(_Ano+1,4,0)
ENDIF	
***** Copiando los archivos que no existan en este nuevo directorio ****
*** Base de datos ****
@  8,09 CLEAR TO 14,80
cArcAct = sys(2000,DirAct+"\cbd*.dbf")
DO WHILE ! EMPTY(LEFT(cArcAct,8))
	cArcNEW = DirNew+"\"+cArcAct
	IF ! FILE(cArcNEW)
		SCROLL 8,09,14,80,1
		@ 14,10 SAY "Creando el archivo "+cArcNew+"..."
		IF _DOS OR _UNIX
			SELECT 0
			USE &cArcAct
		ELSE
			LoDatAdm.abrirtabla('ABRIR',LEFT(cArcAct,8),'','','')
		ENDIF
		DO CASE
			CASE cArcAct = "CBDTOPER.DBF"
				COPY TO (cArcNEW) WITH CDX
				USE &cArcNEW
				REPLACE ALL NDOC00 WITH 1
				REPLACE ALL NDOC01 WITH 1
				REPLACE ALL NDOC02 WITH 1
				REPLACE ALL NDOC03 WITH 1
				REPLACE ALL NDOC04 WITH 1
				REPLACE ALL NDOC05 WITH 1
				REPLACE ALL NDOC06 WITH 1
				REPLACE ALL NDOC07 WITH 1
				REPLACE ALL NDOC08 WITH 1
				REPLACE ALL NDOC09 WITH 1
				REPLACE ALL NDOC10 WITH 1
				REPLACE ALL NDOC11 WITH 1
				REPLACE ALL NDOC12 WITH 1
				REPLACE ALL NDOC13 WITH 1
			CASE cArcAct = "CBDMCTAS.DBF"
				COPY TO (cArcNEW) WITH CDX
			CASE cArcAct = "CBDTCIER.DBF"
				COPY STRUCTU TO (cArcNEW) WITH CDX
				USE &cArcNEW
				DO WHILE RECCOUNT() < 14
					APPEND BLANK
				ENDDO
			OTHER
				COPY STRUCTU TO (cArcNEW) WITH CDX
		ENDCASE
		USE 
	ENDIF
	cArcAct = sys(2000,DirAct+"\cbd*.dbf",1)
ENDDO

**** ARCHIVOS DE MEMORIA *****************************
cArcAct = sys(2000,DirAct+"\CBD*.MEM")
DO WHILE ! EMPTY(cArcAct)
	cArcNEW = DirNew+"\"+cArcAct
	IF ! FILE(cArcNEW)
		SCROLL 8,09,14,80,1
		@ 14,10 SAY "Creando el archivo "+cArcNew+"..."
		COPY FILE &cArcAct TO &cArcNEW
	ENDIF
	cArcAct = sys(2000,DirAct+"\CBD*.MEM",1)
ENDDO

cArcAct = sys(2000,DirAct+"\CJA*.MEM")
DO WHILE ! EMPTY(cArcAct)
	cArcNEW = DirNew+"\"+cArcAct
	IF ! FILE(cArcNEW)
		SCROLL 8,09,14,80,1
		@ 14,10 SAY "Creando el archivo "+cArcNew+"..."
		COPY FILE &cArcAct TO &cArcNEW
	ENDIF
	cArcAct = SYS(2000,DirAct+"\CJA*.MEM",1)
ENDDO
****** ACTUALIZANDO CONCIALIACION BANCARIA **********
* cArcAct = "CBDBANCO.DBF"
* cArcNEW = DirNew+"\"+cArcAct
* cArcTmp = PathUser+SYS(3)
* IF FILE(cArcNEW)
*    SCROLL 8,09,19,69,1
*    @ 19,10 SAY "Actualizando conciliaci¢n Bancaria...."
*    USE CBDBANCO
*    COPY TO &cArcTmp FOR NROMES =  "12" .AND. (FLGEST$"Ll" .OR. EMPTY(MesCie))
*    USE &cArcTmp
*    REPLACE ALL NROMES WITH "00"
*    USE &cArcNEW
*    DELETE ALL FOR NROMES = "00"
*    APPEND FROM &cARCTMP
*    DELETE FILE &cARCTMP
*    CLOSE DATA
* ENDIF

******* ACTUALIZANDO ARCHIVOS DE PARTIDAS PARA REI *******
cArcAct = "CBDMPART.DBF"
cArcNEW = DirNew+"\"+cArcAct
cArcTmp = PathUser+SYS(3)
IF FILE(cArcNEW)
	SCROLL 8,09,14,80,1
	@ 14,10 SAY "Actualizando Partidas para el ajuste por Inflacion ..."
	LoDatAdm.abrirtabla('ABRIR',LEFT(cArcAct,8),'','','')
	COPY TO &cArcTmp FOR EMPTY(FEC_CESE) .OR. YEAR(FEC_CESE) >_Ano
	**** actualizando los Importes de Inicio de A¥O
	SELE 0
	*USE CBDRPART ORDER RPAR01 ALIAS RPAR

	IF LoDatAdm.abrirtabla('ABRIR','CBDRPART','RPAR','RPAR01','')
	
		SELE 0
		USE &cArcTmp ALIAS TMP
		DO WHILE ! EOF()
			Llave = CodCta+CodPar+"12"
			=SEEK(Llave,"RPAR")
			REPLACE Dep_ACUM   WITH RPAR->DPHISA
			REPLACE Dep_ACUMEX WITH RPAR->DPHISAEX
			REPLACE AJU_ACTI   WITH RPAR->VALAJT
		    REPLACE AJU_DEPR   WITH RPAR->DPAJTA
		    SELECT TMP
		    SKIP
		ENDDO
		USE IN TMP
		SELECT 0
		USE &cArcNEW
		DELETE ALL FOR YEAR(FEC_INGR) <= _Ano
		APPEND FROM &cARCTMP
		DELETE FILE &cARCTMP
		USE
	endif	
ENDIF

lodatadm.closetable('RPAR')
lodatadm.closetable('CBDMPART')
****** ACTUALIZANDO SALDOS CONTABLES ********************
SCROLL 8,09,14,80,1
@ 14,10 SAY "Actualizando los Movimientos Contables ..."
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')

SELECT RMOV
COPY STRU TO &cArcTmp
SELECT 0
USE &cArcTmp ALIAS TMP
SELECT 0
cArcNEW = DirNew+"\CBDTOPER"
USE &cArcNEW ORDER OPER01 ALIAS OPER

*!*	TRY
	TRY
*!*			WAIT WINDOW xxx && la variable no ha sido declarada
		DO APERTURA
	CATCH TO lEx WHEN lEx.ErrorNo = 1 && el fichero no existe
		MESSAGEBOX( [La tabla ] + cTable + [ no existe] )
	CATCH TO lEx WHEN lEx.ErrorNo = 3 && la tabla ya está abierta
		MESSAGEBOX( [La tabla ] + cTable + [ ya está abierta con otro Alias] )
	CATCH TO lEx WHEN lEx.ErrorNo = 19 && El índice no va con la tabla
		MESSAGEBOX([Tag de índice ] + cTag + [ no va con la tabla ] + cTable )
	CATCH TO lEx WHEN lEx.ErrorNo = 26 && No hay un orden de TAG
		MESSAGEBOX( [La tabla ] + cTable + [no tiene Tags de Índice] )
	CATCH TO lEx WHEN lEx.ErrorNo = 1683 && El Tag no existe
		Msg = [El Tag de índice ] + cTag + [ no existe]
		ATAGINFO(laTags)
			IF TYPE ( 'laTags(1)' ) <> [U]
				Msg = Msg + CHR(13) + [TAGS disponibles: ] + CHR(13)
				FOR I = 1 TO ALEN ( laTags, 1 )
				Msg = Msg + laTags(I,1) + CHR(13)
			ENDFOR
		ENDIF
		MESSAGEBOX( Msg )
	CATCH TO lEx WHEN lEx.ErrorNo = 1925 && Error no identificado
		SET STEP ON 
	CATCH TO lEx WHEN lEx.ErrorNo = 10 && Error no identificado
		SET STEP ON 		
	CATCH TO lEx
		SET STEP ON 
		lEx.Message = lEx.Message+ " Tabla:" + cTable + " "
		
			
		THROW
*!*			MESSAGEBOX( ;
*!*			[Error: ] + TRANSFORM(lEx.ErrorNo ) + CHR(13) ;
*!*			+ [Texto: ] + lEx.Message + CHR(13) ;
*!*			+ [Linea: ] + TRANSFORM(lEx.LineNo ) )
	FINALLY
		IF _dos OR _Unix
			CLOSE DATA
		ENDIF
	ENDTRY
RETURN

************************************************************************
* Generando en archivo auxiliar el asiento de apertura
************************************************************************
PROCEDURE Apertura
******************
SCROLL 8,09,14,69,1
SELECT ACCT
SET ORDER TO ACCT02
LOCATE
XnNroItm = 0
XsCodOpe = "000"
TnSdoNac = 0
TnSdoUsa = 0
DO WHILE ! EOF() .AND. CodCta < "60"
	LsCodCta = CodCta
	LsCodRef = CodRef
	SELECT ACCT
	SdoNac = 0.0
	SdoUsa = 0.0
	DO WHILE ! EOF() .AND. LsCodCta+LsCodRef = CodCta+CodRef
*!*			IF COdCta='12101'
*!*				SET STEP ON 
*!*			ENDIF

		IF NroMes < '13'
			IF codcta='10101'
*!*					SET STEP ON 
			ENDIF
			IF XsCodDiv=[**]  && Consolidado
				SdoNac = SdoNac + DbeNac - HbeNac
				SdoUsa = SdoUsa + DbeExt - HbeExt
			ELSE
		  		XsCmpDbe1= [DBENAC]+LEFT(vDivision(XnCodDiv),2)
		  		XsCmpHbe1= [HBENAC]+LEFT(vDivision(XnCodDiv),2)
		  		XsCmpDbe2= [DBEEXT]+LEFT(vDivision(XnCodDiv),2)
		  		XsCmpHbe2= [HBEEXT]+LEFT(vDivision(XnCodDiv),2)
				SdoNac = SdoNac + IIF(TYPE(XsCmpDbe1)#[N],0,EVAL(XsCmpDbe1)) - IIF(TYPE(XsCmpHbe1)#[N],0,EVAL(XsCmpHbe1))
				SdoUsa = SdoUsa + IIF(TYPE(XsCmpDbe2)#[N],0,EVAL(XsCmpDbe2)) - IIF(TYPE(XsCmpHbe2)#[N],0,EVAL(XsCmpHbe2))
			ENDIF
		ENDIF
		SKIP
	ENDDO
	SELECT CTAS
	SEEK LsCodCta
	IF AftMOV = 'S' .AND. !(SdoNac= 0 .AND. SdoUsa = 0)
		@ 14,10 SAY LsCodCta+" "+NomCta
		IF !EVALUATE(LcFiltro) && Si es por divisionaria solo filtra las que coinciden con CodCta_B
			SELECT ACCT
			LOOP
		ENDIF
		IF CTAS->PIDAUX="S" AND LEFT(CTAS.CODCTA,2)#"10"
      *if ctas->pidaux=[S] and (inlist(ctas.codcta,[10900200],[10900900],[10900901]) or left(ctas.codcta,2)#[10])
			DO CtaCte
			SELECT ACCT
			DO WHILE ! EOF() .AND. LsCodCta = CodCta
				SKIP
			ENDDO
		ELSE
			SELECT TMP
			APPEND BLANK
			XnNroItm = XnNroItm + 1
			REPLACE NroMes WITH "00"
			REPLACE CodOpe WITH XsCodOpe
			
			REPLACE NroAst WITH TsCodDiv1+"000001"
			REPLACE NroItm WITH XnNroItm
			REPLACE CodCta WITH LsCodCta
			REPLACE CodRef WITH LsCodRef
			REPLACE CodMon WITH 1
			REPLACE TpoCmb WITH 1
			REPLACE FchDoc WITH CTOD("01/01/"+STR(_ANO+1,4,0)) && CTOD("31/12/"+STR(_ANO,4,0))
			REPLACE CodDiv WITH TsCodDiv2
			DO CASE
				CASE SdoNac > 0
					REPLACE TpoMov WITH "D"
					REPLACE Import WITH SdoNac
					REPLACE ImpUsa WITH SdoUsa
	            CASE SdoNac < 0
					REPLACE TpoMov WITH "H"
					REPLACE Import WITH -SdoNac
					REPLACE ImpUsa WITH -SdoUsa
	            CASE SdoUsa > 0
					REPLACE TpoMov WITH "D"
					REPLACE Import WITH SdoNac
					REPLACE ImpUsa WITH SdoUsa
	            CASE SdoUsa < 0
	  	            REPLACE TpoMov WITH "H"
	    	        REPLACE Import WITH -SdoNac
	        	    REPLACE ImpUsa WITH -SdoUsa
			ENDCASE
			TnSdoNac = TnSdoNac + SdoNac
			TnSdoUsa = TnSdoUsa + SdoUsa
		ENDIF
	ENDIF
	SELECT ACCT
ENDDO

**** Descargando en la cuenta de acumulados ***
LsCodCta = "59101"
SdoNac   = -TnSdoNac
SdoUsa   = -TnSdoUsa
SELECT TMP
APPEND BLANK
XnNroItm = XnNroItm + 1
REPLACE NroMes WITH "00"
REPLACE CodOpe WITH XsCodOpe
REPLACE NroAst WITH TsCodDiv1+"000001"
REPLACE NroItm WITH XnNroItm
REPLACE CodCta WITH LsCodCta
REPLACE FchDoc WITH CTOD("01/01/"+STR(_ANO+1,4,0)) && CTOD("31/12/"+STR(_ANO,4,0))
REPLACE CodMon WITH 1
REPLACE TpoCmb WITH 1
IF SdoNac > 0
	REPLACE TpoMov WITH "D"
	REPLACE Import WITH SdoNac
	REPLACE ImpUsa WITH SdoUsa
ELSE
	REPLACE TpoMov WITH "H"
	REPLACE Import WITH -SdoNac
	REPLACE ImpUsa WITH -SdoUsa
ENDIF
REPLACE CodDiv WITH TsCodDiv2
TnSdoNac = TnSdoNac + SdoNac
TnSdoUsa = TnSdoUsa + SdoUsa
SCROLL 8,09,14,69,1
@ 14,10 SAY "Grabando Movimientos de Apertura ..."

SELECT ACCT
cArcNEW = DirNew+"\CBDACMCT"
USE &cArcNEW ORDER ACCT01 ALIAS ACCT && EXCL

SELECT VMOV
cArcNEW = DirNew+"\CBDVMOVM"
USE &cArcNEW ORDER VMOV01 ALIAS VMOV && EXCL

SELECT RMOV
cArcNEW = DirNew+"\CBDRMOVM"
USE &cArcNEW ORDER RMOV01 ALIAS RMOV && EXCL

SELEC OPER
SEEK XsCodOPe
IF ! FOUND()
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	REPLACE CodOpe WITH XsCodOPe
	REPLACE NDoc00 with 2
ELSE
	DO WHILE !RLOCK()
	ENDDO
ENDIF
REPLACE NomOpe WITH "Apertura Contable"
REPLACE CodMon WITH 4
unlock

SELECT VMOV
Llave = "00"+XsCodOpe+TsCodDiv1+"000001"
SEEK Llave
IF ! FOUND()
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	REPLACE NroMes WITH "00"
	REPLACE CodOpe WITH XsCodOpe
	REPLACE NroAst WITH TsCodDiv1+"000001"
ELSE
	DO WHILE !RLOCK()
	ENDDO
ENDIF

REPLACE FchAst WITH CTOD("01/01/"+STR(_ANO+1,4,0)) && CTOD("31/12/"+STR(_ANO,4,0))
REPLACE CodMon WITH 1
REPLACE TpoCmb WITH 0
REPLACE NotAst WITH "ASIENTO AUTOMATICO DE APERTURA"
REPLACE ChkCta WITH 0
REPLACE NroItm WITH XnNroItm
REPLACE DbeNac WITH 0
REPLACE HbeNac WITH 0
REPLACE DbeUsa WITH 0
REPLACE HbeUsa WITH 0

******* ANULANDO EL MOVIMIENTO ANTERIOR **********
SELECT RMOV
SEEK LLAVE
DO WHILE ! EOF() .AND. NroMes+CodOPe+NroAst = Llave
	DO WHILE !RLOCK()
	ENDDO
	DO CBDACTCT WITH CodCta , CodRef , 0 , TpoMov , -Import , -ImpUsa , CodDiv
	DELETE
	UNLOCK
	SKIP
ENDDO
*
sele acct
set order to acct01
seek [ 0]
delete rest while nromes = [ 0]
*
**** ACTUALIZANDO LOS NUEVOS SALDOS ****
SELECT TMP
GOTO TOP
DO WHILE ! EOF()
	SCATTER MEMVAR
	SELECT RMOV
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	GATHER MEMVAR
	REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
	DO CBDACTCT WITH  CodCta , CodRef , 0 , TpoMov , Import , ImpUsa , CodDiv
	IF RMOV->TpoMov = 'D'
		REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
		REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
	ELSE
		REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
		REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
	ENDIF
	UNLOCK
	SELECT TMP
	SKIP
ENDDO
IF _DOS OR _UNIX
	CLOSE DATA
ENDIF
lodatadm.closetable('TMP')
SCROLL 8,09,14,69,1
@ 14,10 SAY "Registrando el nuevo año............"

*!*	USE CBDTANOS
Lodatadm.abrirtabla('ABRIR','CBDTANOS','','','')
REPLACE ALL CIERRE WITH .T.
LOCATE FOR PERIODO = _ANO+1
IF ! FOUND()
	APPEND BLANK
	REPLACE PERIODO WITH _ANO+1
ENDIF
REPLACE CIERRE WITH .F.
SCROLL 8,09,14,69,1
@ 14,10 SAY "Proceso Concluido..................."
IF _DOS OR _UNIX
	CLOSE DATA
ENDIF
lodatadm.closetable('CBDTANOS')
RETURN
************************************************************************
* Copia a un archivo auxiliar todos los movientos pendientes
************************************************************************
PROCEDURE CtaCte
****************
SELECT RMOV
*** SORTEADO POR COD. DE CUENTA *****
SET ORDER TO RMOV06
SEEK LsCodCta
DO WHILE ! EOF() .AND. CodCta = LsCodCta
	IF NroMes > '12'
		SELECT RMOV
		SKIP 
		LOOP
	ENDIF
	IF !EVALUATE(LcFiltroMov)  && Para Filtrar solo la divisionaria seleccionada VETT 2009-06-23
		SELECT RMOV
		SKIP 
		LOOP
	ENDIF
	SdoNac   = 0
	SdoUsa   = 0
	XsGloDoc = GloDoc
	SCATTER MEMVAR
	Llave  = CodCta+CodAux+NroDoc
   *
   *if codcta = [42300200] .and. nrodoc=[090216-97B]
   *   set step on
   *endif
   *
	DO WHILE CodCta+CodAux+NroDoc = LLAVE .AND. ! EOF()
		IF NroMes > '12'
			SELECT RMOV
			SKIP 
			LOOP
		ENDIF
		IF !EVALUATE(LcFiltroMov)  && Para Filtrar solo la divisionaria seleccionada VETT 2009-06-23
			SELECT RMOV
			SKIP 
			LOOP
		ENDIF

		SdoNac = SdoNac + IIF(TpoMov=[D],IMPORT,-1*Import)
		SdoUsa = SdoUsa + IIF(TpoMov=[D],IMPUSA,-1*ImpUsa)
		SKIP
	ENDDO
	**>>  Vo.Bo. VETT  2009/01/13 16:11:54 
	IF ! (SdoNac = 0) AND ABS(SdoNac) > 0.10 
		SELECT TMP
		APPEND BLANK
		GATHER MEMVAR FIELDS EXCEPT Afecto
	    XnNroItm = XnNroItm + 1
	    REPLACE NroMes WITH "00"
	    REPLACE CodOpe WITH XsCodOpe
	    REPLACE NroAst WITH TsCodDiv1+"000001"
	    REPLACE NroItm WITH XnNroItm
	    REPLACE CodCta WITH LsCodCta
	    IF SEEK(NroMes+CodOpe+NroAst,"VMOV") AND EMPTY(XsGloDoc)
			XsGloDoc = VMOV->NotAst
		ENDIF
		REPLACE GloDoc WITH XsGloDoc
		REPLACE FchDoc WITH CTOD("01/01/"+STR(_ANO+1,4,0)) && CTOD("31/12/"+STR(_ANO,4,0))
		IF COdCta='12101' AND SdoNac < 0
*!*				SET STEP ON 
		ENDIF

		DO CASE
			CASE SdoNac > 0
				REPLACE TpoMov WITH "D"
	            REPLACE Import WITH SdoNac
	            REPLACE ImpUsa WITH SdoUsa
			CASE SdoNac < 0
				REPLACE TpoMov WITH "H"
	            REPLACE Import WITH -SdoNac
	            REPLACE ImpUsa WITH -SdoUsa
			CASE SdoUsa > 0
	            REPLACE TpoMov WITH "D"
	            REPLACE Import WITH SdoNac
	            REPLACE ImpUsa WITH SdoUsa
			CASE SdoUsa < 0
				REPLACE TpoMov WITH "H"
	            REPLACE Import WITH -SdoNac
	            REPLACE ImpUsa WITH -SdoUsa
		ENDCASE
		TnSdoNac = TnSdoNac + SdoNac
		TnSdoUsa = TnSdoUsa + SdoUsa
	ENDIF
	SELECT RMOV
ENDDO
SELECT ACCT
RETURN
********************
PROCEDURE P_TERMINAR
********************
lodatadm.closetable('RMOV')
lodatadm.closetable('VMOV')
lodatadm.closetable('ACCT')
lodatadm.closetable('OPER')
lodatadm.closetable('CTAS')
