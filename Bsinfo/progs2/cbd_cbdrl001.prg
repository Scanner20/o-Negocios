******************************************************************************+++++++++++++++++++**
* Programa      : CBDRL001.PRG                                                                    *
* Objeto        : DIARIO GENERAL POR OPERACION  							                      *
* Creación      : 15 Setiembre 2002  VETT		                                                  *
* Actualización : Generar Diario Simplificado y mostrar en browse (grid)  29/11/2017 08:54 - VETT *
* Actualización : Agregando browse (grid) Libro Diario General  2021/02/07 17:30:26 - VETT        *
***************************************************************************************************
*** Abrimos Bases ****
**DIMENSION DISTRIB(100,2)
#include const.h 
LlCodLib=.F.
LsTabla8= '00208'  && Codigo de la Tabla 8 de la sunat (Codigo Libro o Registro) en GTablas_Detalle
SELECT 0
USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf' 
IF !verifytag('gtablas_detalle','CodValor1')
	LnRpta=0
	LnRpta=MESSAGEBOX('Se va a realizar una configuración que necesita acceso exclusivo a la base de datos. '+CRLF+;
					  'Asegúrese que los demás usuarios estan fuera del sistema antes de continuar. '+CRLF+;
					  'Si tiene dudas haga clic en <Cancelar> coordine con los usuarios e intente nuevamente.'+CRLF+CRLF+;
					  'NOTA: ESTE PROCEDIMIENTO SOLO SE EJECUTARA UNA VEZ',64+1+256,'AVISO IMPORTANTE')
	IF 	LnRpta= 2
		USE IN Gtablas_Detalle
		RETURN
	ENDIF			  
    USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf'  EXCLUSIVE
    INDEX ON CODIGOTABLA+RIGHT(REPLICATE("0",3)+LTRIM(STR(GTABLAS_DETALLE.VALOR1ARGUMENTO,3,0)),3) TAG CodValor1
    USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf' 
    LlCodLib = .T.
ELSE
	
	LlCodLib=.T.    
ENDIF
LlOrdenDSF = .F.
IF !verifytag('gtablas_detalle','CODIGODSF')
	LnRpta=0
	LnRpta=MESSAGEBOX('Se va a realizar una configuración que necesita acceso exclusivo a la base de datos. '+CRLF+;
					  'Asegúrese que los demás usuarios estan fuera del sistema antes de continuar. '+CRLF+;
					  'Si tiene dudas haga clic en <Cancelar> coordine con los usuarios e intente nuevamente.'+CRLF+CRLF+;
					  'NOTA: ESTE PROCEDIMIENTO SOLO SE EJECUTARA UNA VEZ',64+1+256,'AVISO IMPORTANTE')
	IF 	LnRpta= 2
		USE IN Gtablas_Detalle
		RETURN
	ENDIF			  
    USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf'  EXCLUSIVE
    INDEX ON CODIGOTABLA+ELEMENTOTABLA+STR(VALOR1ARGUMENTO,3,0) TAG CODIGODSF
    USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf' 
    LlOrdenDSF	= .T.
ELSE
	
	LlOrdenDSF	=.T.    
ENDIF
SET ORDER TO CODVALOR1   && CODIGOTABLA+RIGHT(REPLICATE("0",3)+LTRIM(STR(GTABLAS_DETALLE.VALOR1ARGUMENTO,3,0)),3) 

goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','') 
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')



*!*	LcArctmp=goentorno.tmppath+SYS(3) 

*!*	CREATE TABLE (LcArcTmp) free  (Nromes C(LEN(rmov.nromes)) ,codope C(LEN(rmov.codope)) , Nroast C(LEN(rmov.Nroast)) , ;
*!*									FchAst d(8) , Codcta C(LEN(ctas.codcta)), Glodoc C(LEN(rmov.glodoc)) ,;
*!*									FchDoc d(8), NroDoc C(Len(RMOV.Nrodoc)), NroRef C(LEN(RMOV.NroRef)) , ;
*!*									CodMon N(1) , c_Codmon C(3) , ;
*!*									Tpomov C(1) , c_Dbe N(14,2) , c_Hbe N(14,2), c_Dbe2 N(14,2) , c_Hbe2 N(14,2),;
*!*									no_sumar l(1) )


*
*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
*
SELECT VMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
*
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "DIARIO GENERAL"

*!*	Do Fondo WITH cTit1,cTit2,cTit3,cTit4
*!*	********* Variables  a usar ***********

*!*	@  9,04 FILL  TO 15,76      COLOR W/N
*!*	@  8,05 CLEAR TO 14,77
*!*	@  8,05       TO 14,77
PRIVATE XsNroMes
XiCodMon = 1
XdFchAst = DTOT({}) && DATEtime()
XsCodOpe = SPACE(LEN(oper.codope)) && "001"
XsNroMes = transf(_MES,"@L ##")
XsDesde  = SPACE(LEN(RMOV.NroAst))
XsHasta  = SPACE(LEN(RMOV.NroAst))
nImpNac  = 0
nImpUsa  = 0
nImport  = 0
XiTipo = 2
XnExpres = 1

STORE '' to LcArcTmp,LcArcTmp1,ArcTmp
STORE '' to titulo,subtitulo,en1,en2,en3,en4,en5,en6,en7,en8,en9
STORE '' to xMes,xOpe,xAno,xDia
*
XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv
XsFor1 = [.T.]
do form cbd_report_diario_general
RETURN
*
******************
PROCEDURE imprimir
******************
IF LlCodLib
	IF !USED('Gtablas_Detalle')
		SELECT 0
		USE ADDBS(goentorno.locpath)+'gtablas_detalle.dbf' 
		SET ORDER TO CODVALOR1   && CODIGOTABLA+RIGHT(REPLICATE("0",3)+LTRIM(STR(GTABLAS_DETALLE.VALOR1ARGUMENTO,3,0)),3) 
	ENDIF
ENDIF
=SEEK(XsCodOpe,"OPER")
SELECT VMOV

XsDesde = TRIM(XsDesde)
XsHasta = LEFT(TRIM(XsHasta)+"zzzzzz",LEN(RMOV->NroAst))
*** FILTROS **
IF ! EMPTY(XdFchAst)
   SET ORDER TO VMOV03
   xLLave = XsNroMes+XsCodOpe+DTOC(XdFchAst,1)
   vClave = [NroMes+CodOpe+DTOC(FchAst,1)]
ELSE
   SET ORDER TO VMOV01
   xLLave = XsNroMes+trim(XsCodOpe)
   vClave = [NroMes+CodOpe]
ENDIF
SEEK xLLave+TRIM(XsDesde)
IF ! FOUND() AND RECNO(0)>0
   GO RECNO(0)
   XsDesde = NroAst
   SEEK xLLave+TRIM(XsDesde)
   IF EOF()
      GsMsgErr = "No Existen registros a Listar"
      MESSAGEBOX(GsMsgErr,16,'Atencion')
      RETURN
   ENDIF
ELSE
   IF EOF()
      GsMsgErr = "No Existen registros a Listar"
      MESSAGEBOX(GsMsgErr,16,'Atencion')
      RETURN
   ENDIF
ENDIF
*!*	DO ADMPRINT
*!*	IF LASTKEY() = ESCAPE
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF

**  Base auxiliar
*!*	IF xiTipo = 1
*!*	   ArcTmp=GoEntorno.TmpPath+Sys(3)
*!*	   SELE RMOV
*!*	   COPY STRUC TO (ArcTmp)
*!*	   SELECT 0
*!*	   USE (ArcTmp) EXCL ALIAS RESU
*!*	   IF !USED()
*!*	       CLOSE DATA
*!*	       RETURN
*!*	   ENDIF   
*!*	   INDEX ON CodCta TAG RESU01
*!*	   SET ORDER TO RESU01 
*!*	ENDIF

*!*	SELECT 0
*!*	USE (LcArcTmp) ALIAS temporal EXCLUSIVE
*!*	IF !USED()
*!*		RETURN .f.
*!*	ENDIF
*!*	INDEX ON nromes+codpe+nroast tag tmp01
*!*	SET ORDER TO tmp1

**
SELE VMOV
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 152
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = Largo + 14

*IniImp  = _PRN8A
*!*	IniImp  = _PRN8A+_PRN3
Tit_SIZQ = TRIM(GsNomCia)
*!*	Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Titulo   = "D I A R I O  G E N E R A L"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En1 = "@LIBRO "+XsCodOpe
En2 = TRIM(OPER->NomOpe)
En3 = ""
En4 = ""
En5 = ""
IF ! EMPTY(XdFchAst)
   xDia = TRANSF(DAY(XdFchAst)  ,"@L ##")
   xMes = TRANSF(MONTH(XdFchAst),"@L ##")
   xAno = TRANSF(YEAR(XdFchAst) ,"@L ####")
   xOpe = CHR(14)+XsCodOpe+CHR(20)+CHR(0)
   En1 = "+-------------------------+"
   En2 = "+       LIBRO  "+xOpe+"     +"
   En3 = "+-------------------------+"
   En4 = "+  FECHA   "+xDia+"   "+xMes+"   "+xAno+" +"
   En5 = "+-------------------------+"
ENDIF
*En6 = "***** ****** ********* ******* ************** ****** ********** ****** **************************************** *** *******************************"
*En7 = "      COMPRO CUENTA     COD.     REFERENCIA   FECHA             FECHA                                                                              "
*En8 = "FECHA BANTE  CONTABLE  AUXILI. Nro.      Tpo. DCMTO. DOCUMENTO  VCMTO.              D E T A L L E               MON      DEBE             HABER    "
*En9 = "***** ****** ********* ******* ************** ****** ********** ****** **************************************** *** *************** ***************"
****   12345 123456 123456789 123456  123456789- 123 123456 123456789- 123456 123456789-123456789-123456789-123456789- 123 9999,999,999.99 9999,999,999.99
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
*      0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
*
En6 = "***** ******** ******** ******** ******************* ********** ********** ********** ******************************* *** *************** ***************"
En7 = "       COMPRO  CUENTA    COD.         REFERENCIA      FECHA                  FECHA                                                                       "
En8 = "FECHA  BANTE   CONTABLE AUXILI   Nro.           Tpo.  DCMTO.     DOCUMENTO   VCMTO.              D E T A L L E        MON      DEBE             HABER    "
En9 = "***** ******** ******** ******** ******************* ********** ********** ********** ******************************* *** *************** ***************"
****   12345 12345678 12345678 12345678 12345678901234-1234 1234567890 1234567890 1234567890 123456789-123456789-123456789-1 123 9999,999,999.99 9999,999,999.99
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
*      0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
*
XsFor1= XsFor1+ IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','',' AND CodDiv=XsCodDiv')
SELECT VMOV
RegIni = RECNO()
nItm   = 0
*!*	SET DEVICE TO PRINT
*!*	PRINTJOB
	
   NumPag   = 0
   STORE 0 TO X0TotDbe,X0TotHbe,X0TotDbe2,X0TotHbe2,X0NumEle
   SELE OPER
   SEEK TRIM(XsCodOpe)
   DO WHILE !EOF()  .AND. CodOpe = TRIM(XsCodOpe) .AND. !Cancelar
       IF EMPTY(XsCodOpe)   && .and. XiTipo = 1
          xLLave = XsNroMes+OPER->CodOpe
          En1 = "@LIBRO "+CodOpe
          En2 = TRIM(OPER->NomOpe)
       ENDIF
       SELE VMOV
       SEEK xLlave+XsDesde
       SaltoPag = .T.
       DO WHILE &vClave = xLLave .AND. ! EOF() .AND. ! Cancelar .AND. NroAst<=XsHasta
          STORE 0 TO X1TotDbe,X1TotHbe,X1TotDbe2,X1TotHbe2

          XsNroMes = NroMes
          SubTitulo= "MES DE "+MES(VAL(XsNroMes),1)+" DE "+TRANS(_ANO,"9999")
          SCAN WHILE &vClave = xLLave AND ! Cancelar AND NROMES = XsNroMes AND NroAst<=XsHasta
             LdFchAst = FchAst
             XsNroAst = NroAst
             IF XiTipo = 2
                DO LINIMP
             ELSE
                DO LINRES
             ENDIF
             SELECT VMOV
             Cancelar = (INKEY() = 27) .OR. Cancelar
          ENDSCAN
          IF ! CANCELAR && AND XiTipo = 2
	             X0TotDbe = X0TotDbe + X1TotDbe
	             X0TotHbe = X0TotHbe + X1TotHbe
   	             X0TotDbe2 = X0TotDbe2 + X1TotDbe2
	             X0TotHbe2 = X0TotHbe2 + X1TotHbe2
				IF XiTipo = 2				
					SELECT temporal
					APPEND BLANK
					replace NroMes   WITH XsNroMes , CodOpe WITH OPER.CodOPe, NroAst WITH 'z1'
					replace GloDoc   WITH "TOTAL :"+CodOpe+' '+Oper.NomOpe
					replace Linea	 WITH 'TOT'
					replace c_CodMon WITH 'S/.'
					replace c_Dbe    WITH X1TotDbe
					replace c_Hbe    WITH X1TotHbe
					REPLACE no_Sumar WITH .t.	
					***
					IF XnExpres=2
						APPEND BLANK
						replace NroMes WITH XsNroMes , CodOpe WITH OPER.CodOPe, NroAst WITH 'z1'
						replace GloDoc WITH ""
						replace Linea	WITH 'TOT'
						replace c_CodMon	WITH 'US$'
						replace c_Dbe WITH X1TotDbe2
						replace c_Hbe WITH X1TotHbe2
						REPLACE no_Sumar with .t.	
					ENDIF
					X0NumEle = X0NumEle + 1
				ENDIF
          ENDIF
          SELECT VMOV
       ENDDO
*!*	       IF ! Cancelar  .AND. ! EMPTY(XdFchAst)  && PONER COMO PIE DE PAGINA
*!*	          IF PROW() > (LinFin - 4)
*!*	             SaltoPag = .T.
*!*	          ENDIF
*!*	          DO ResetPag
*!*	          IF EMPTY(XsDesde) AND EMPTY(XsHasta)
*!*	             NumLin = LINFIN - 3
*!*	             @ NumLin,0 SAY _PRN7A
*!*	             @ NumLin,0 SAY "ELABORADO:____________   REVISADO  :___________   PROCESADO :___________"+_PRN7B
*!*	          ENDIF
*!*	       ENDIF
*!*	       IF XiTipo = 1
*!*	          DO TotRESU
*!*	       ENDIF
       SELE OPER
       SKIP
   ENDDO
   IF X0NumEle > 1
		SELECT temporal
		APPEND BLANK
		replace NroMes WITH XsNroMes 
		REPLACE CodOpe WITH 'ZZZ', NroAst WITH 'z1'
*!*			REPLACE	GloDoc  WITH "** TOTAL GENERAL **"
		REPLACE	NomCta  WITH "** TOTAL GENERAL **"		
		REPLACE Linea	WITH 'TG'
		REPLACE C_CODMON WITH 'S/.'
		replace c_Dbe WITH X0TotDbe
		replace c_Hbe WITH X0TotHbe
		REPLACE no_Sumar with .t.	
		IF XnExpres=2
			APPEND BLANK
			replace NroMes WITH XsNroMes 
			REPLACE CodOpe WITH 'ZZZ', NroAst WITH 'z1'
			REPLACE Linea	WITH 'TG'
			REPLACE C_CODMON WITH 'US$'
			replace c_Dbe WITH X0TotDbe2
			replace c_Hbe WITH X0TotHbe2
			REPLACE no_Sumar with .t.	
		ENDIF
   ENDIF
*!*	   EJECT PAGE
*!*	ENDPRINTJOB
*!*	SET MARGIN TO 0
*!*	SET DEVICE TO SCREEN
*!*	DO ADMPRFIN &&IN ADMPRINT
*!*	CLOSE DATA

IF XiTipo = 1
   DELE FILE &LcArcTmp..DBF
   DELE FILE &LcArcTmp..CDX
ENDIF
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltoPag
   SaltoPag = .F.
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,Ancho -12  SAY "Continua.."
   ENDIF
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
****************
PROCEDURE LINIMP
****************
SELECT VMOV
XsNroAst = NroAst
sKey     = NroMes+CodOpe+NroAst
STORE 0 TO nDbe, nHbe, nItm, NumEle, nNumDis , nDbe2, nHbe2
IF FLGEST = [A]
	SELECT TEMPORAL
	APPEND BLANK
	REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst	
	REPLACE FchAst WITH VMOV.FchAst,NotAst WITH VMOV.NotAst
	replace Glodoc WITH '*** ANULADO***'   
ENDIF
SELECT RMOV
SEEK sKey
XcEliItm = [*]
lAuto = .F.
LPrimera = .t.



DO WHILE  !EOF() AND RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst = sKey
*!*	   IF RMOV.EliItm = "*"
*!*	      lAuto = .T.
*!*	      SKIP
*!*	      LOOP
*!*	   ENDIF
   *
   	IF !EVALUATE(XsFor1)
		SELECT rmov		
		skip
		LOOP
	ENDIF

   SELECT CTAS
   SEEK RMOV.CodCta
   *
   SELECT RMOV
   =SEEK(RMOV.ClfAux+RMOV.CodAux,[AUXI])
   LsGloDoc = RMOV.GloDoc
   LsImport = []
   IF XnExpres=1
   ELSE
	   IF RMOV.CodMon = 1
	      LsImport = [ US$] + ALLTRIM(STR(ImpUsa,14,2))
	      IF RIGHT(LsImport,3)=[.00]
	         LsImport = [(US$] + ALLTRIM(STR(ImpUsa,14,0))+[)]
	      ENDIF
	   ELSE
	      LsImport = [ S/.] + ALLTRIM(STR(Import,14,2))
	      IF RIGHT(LsImport,3)=[.00]
	         LsImport = [(S/.] + ALLTRIM(STR(Import,14,0))+[)]
	      ENDIF
	   ENDIF
   ENDIF
   DO CASE
   	  CASE !EMPTY(CTAS.ClfAux)	AND !EMPTY(RMOV.ClfAux)
	  	LsGloDoc = LEFT(AUXI.NomAux,LEN(rmov.GloDoc)-LEN(LsImport))+LsImport	
      CASE !EMPTY(RMOV.Glodoc)
         LsGloDoc = LEFT(RMOV.GloDoc,LEN(rmov.GloDoc)-LEN(LsImport))+LsImport
      CASE ! EMPTY(AUXI->NomAux)
         LsGloDoc = LEFT(AUXI.NomAux,LEN(rmov.GloDoc)-LEN(LsImport))+LsImport
      OTHER
         LsGloDoc = LEFT(VMOV.NotAst,LEN(rmov.GloDoc)-LEN(LsImport))+LsImport
	ENDCASE
	*
	DO CALIMP
	* 	
	SELECT TEMPORAL
	APPEND BLANK
	REPLACE Nromes WITH VMOV.NroMes,CodOpe WITH VMOV.CodOpe,NroAst WITH VMOV.NroAst
	REPLACE FchAst WITH IIF(EMPTY(RMOV.FchAst),VMOV.FchAst,RMOV.FchAst),CodCta WITH RMOV.CodCta
	REPLACE NomCta WITH CTAS.NomCta
	IF LlCodLib
		REPLACE CodLib WITH IIF(SEEK(LsTabla8+RMOV.CodOpe,'Gtablas_Detalle','CodValor1'),Gtablas_Detalle.ElementoTabla,'') 
	ENDIF
	REPLACE NroItm WITH RMOV.NroItm
	REPLACE CodAux WITH RMOV.CodAux,NroDoc WITH RMOV.NroDoc,CodDoc WITH RMOV.CodDoc
	REPLACE FchDoc WITH RMOV.FchDoc,NroRef WITH RMOV.NroRef,FchVto WITH RMOV.FchVto
	REPLACE GloDoc WITH LsGloDoc      &&&,    CodMon WITH RMOV.CodMon
	REPLACE NomOpe WITH OPER.NomOpe
	** VETT:Centro de costo 2021/02/05 12:58:25 ** 
	REPLACE CodCco WITH RMOV.CodCco
	IF lPrimera 
		REPLACE NOTAST WITH VMOV.NOTAST
		REPLACE NomOpe WITH OPER.NomOpe
		replace c_CodMon WITH IIF(VMOV->CODMON=1,"S/.","US$")	
		lPrimera = .F.
	ENDIF
   *
   IF CTAS->CODREF = [00000]
      LsCODREF = [00000]
   ELSE
      LsCODREF = RMOV.CodRef
   ENDIF
   IF EMPTY(LsCodRef)
      nNumDis = nNumDis + 1
   ENDIF
   x = 0
   IF XnExpres = 1
		REPLACE TEMPORAL.c_CodMon with 'S/.'
	      IF RMOV.TpoMov='D'
	   		 replace temporal.c_Dbe with nImpNac
	         nDbe = nDbe + nImpNac
	         nDbe2 = nDbe2 + nImpUsa         
	      ELSE
	   		 replace temporal.c_Hbe with nImpNac
	         nHbe = nHbe + nImpNac
	         nHbe2 = nHbe2 + nImpUsa
	      ENDIF
   ELSE
		IF VMOV.CodMon <> 1
			IF RMOV->CodMon <> VMOV.CodMon
				REPLACE TEMPORAL.c_CodMon with IIF(RMOV.CodMon=1,'S/.','US$')
			ENDIF
	      IF RMOV.TpoMov='D'
			 replace temporal.c_Dbe with nImpUsa 	
	         nDbe = nDbe + nImpNac
	         nDbe2 = nDbe2 + nImpUsa
	      ELSE
	   		 replace temporal.c_Hbe with nImpUsa 	
	         nHbe = nHbe + nImpNac
	         nHbe2 = nHbe2 + nImpUsa
	      ENDIF
	    ELSE
	      IF RMOV.TpoMov='D'
	   		 replace temporal.c_Dbe with nImpNac
	         nDbe = nDbe + nImpNac
	         nDbe2 = nDbe2 + nImpUsa         
	      ELSE
	   		 replace temporal.c_Hbe with nImpNac
	         nHbe = nHbe + nImpNac
	         nHbe2 = nHbe2 + nImpUsa
	      ENDIF
	    ENDIF
   ENDIF
   nItm = nItm + 1
   ** VETT  29/11/2017 08:54 AM : Actualizar temporal de DSF ****
   SELECT Temporal2

   IF !SEEK(DTOS(TEMPORAL.FchAst)+Temporal.NroMes+Temporal.CodOpe+Temporal.Nroast,'TEMPORAL2','TMP01')
		APPEND BLANK 
		REPLACE FchAst WITH  TEMPORAL.FchAst, NroMes WITH TEMPORAL.NroMes, CodOpe WITH Temporal.CodOpe , NroAst WITH TEMPORAL.NroAst
		REPLACE GloDoc WITH		TEMPORAL.NotAst  			
   ENDIF
   SELECT gtablas_Detalle
   SET ORDER TO CODIGODSF
   SEEK 'LCDSF'
   SCAN WHILE CodigoTabla='LCDSF' FOR Temporal.CodCta=TRIM(gtablas_Detalle.ElementoTabla)
		** VETT  30/11/2017 11:41 AM : Mejor dejamos los campos por orden y usamos el codigo cuenta para construir el nombre del campo 	
*!*	   		LsCmpColCtaD='T'+TRANSFORM(VALOR1ARGUMENTO,"@L ##")+'D'	
*!*	   		LsCmpColCtaH='T'+TRANSFORM(VALOR1ARGUMENTO,"@L ##")+'H'	
		** VETT  30/11/2017 11:47 AM : y es mas fácil indentificarlo cuando el usuario quiera exportar Excel 
		LsCmpColCtaD='T'+ALLTRIM(Gtablas_Detalle.ElementoTabla)+'D'
   		LsCmpColCtaH='T'+ALLTRIM(Gtablas_Detalle.ElementoTabla)+'H'
   		SELECT TEMPORAL2
   		REPLACE &LsCmpColCtaD. WITH &LsCmpColCtaD.	+	temporal.c_Dbe
   		REPLACE &LsCmpColCtaH. WITH &LsCmpColCtaH.	+	temporal.c_Hbe
   		REPLACE TotalD WITH TotalD + temporal.c_Dbe
   		REPLACE TotalH WITH TotalH + temporal.c_Hbe
   		SELECT gtablas_Detalle
   ENDSCAN
   SELECT Rmov
   
   SKIP
ENDDO
SELECT VMOV
IF nItm = 0 .AND. ! FLGEST = "A"
	SELECT temporal
	APPEND BLANK
	REPLACE FchAst WITH VMOV.FchAst, NroAst WITH VMOV.NroAst, NotAst WITH VMOV.NotAst
	IF lPrimera 
		REPLACE NOTAST WITH VMOV.NOTAST
		REPLACE NomOpe WITH OPER.NomOpe
		replace c_CodMon WITH IIF(VMOV->CODMON=1,"S/.","US$")			
		lPrimera = .F.
	ENDIF

ENDIF
** Agregar linea en el report
SELECT temporal
APPEND BLANK
REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst
REPLACE Linea  WITH  'RS' , No_Sumar WITH .T.
REPLACE NomOpe WITH OPER.NomOpe

SELECT temporal
APPEND BLANK
REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst
*!*	REPLACE GloDoc WITH "TOTALES" 
REPLACE NomCta WITH "TOTALES" 
*!*	REPLACE C_CodMon WITH IIF(VMOV->CODMON=1,"S/.","US$")	
REPLACE Linea WITH 'TA'
IF XnExpres=1
	REPLACE C_CodMon WITH "S/."	
	REPLACE c_Dbe WITH nDbe , c_Hbe with nHbe
ELSE
	REPLACE C_CodMon WITH IIF(VMOV->CODMON=1,"S/.","US$")
	IF vmov.CodMon=1
		REPLACE c_Dbe WITH nDbe , c_Hbe with nHbe
	ELSE
		REPLACE c_Dbe WITH nDbe2 , c_Hbe with nHbe2
	ENDIF
ENDIF	
REPLACE no_Sumar with .t.	
REPLACE NomOpe WITH OPER.NomOpe

IF XnExpres=2
	APPEND BLANK
	REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst
	REPLACE C_CODMON WITH IIF(VMOV.CodMon=2,"S/.","US$")
	REPLACE Linea WITH 'TA'
	IF VMOV.CodMon = 1
		REPLACE c_Dbe WITH VMOV->DbeUsa
		REPLACE c_Hbe with VMOV->HbeUsa
		REPLACE no_Sumar with .t.	
	ELSE
		REPLACE c_Dbe WITH VMOV->DbeNac
		REPLACE c_Hbe with VMOV->HbeNac
		REPLACE no_Sumar with .t.	
	ENDIF
	REPLACE NomOpe WITH OPER.NomOpe
ENDIF
****** DESCRIBIENDO ERRORES *****
IF (nDbe <> nHbe) OR (nDbe2 <> nHbe2)

	APPEND BLANK
	REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst,FchAst WITH VMOV.Fchast
*!*		REPLACE GloDoc WITH "ERROR : DESBALANCEADO "
	REPLACE NomCta WITH "ERROR : DESBALANCEADO "
	REPLACE Linea  WITH 'D'	
	REPLACE C_CodMon	WITH 'S/.'
	REPLACE c_Dbe  WITH ABS(nDBE-nHBE)
	APPEND BLANK
	REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst,FchAst WITH VMOV.Fchast
	REPLACE Linea  WITH 'D'	
	REPLACE C_CodMon	WITH 'US$'
	REPLACE c_Dbe  WITH ABS(nDBE2-nHBE2)
	REPLACE NomOpe WITH OPER.NomOpe
ENDIF
OK = .T.

SELECT temporal
APPEND BLANK
REPLACE Nromes WITH  VMOV.NroMes,CodOpe WITH  VMOV.CodOpe, NroAst WITH VMOV.NroAst
REPLACE Linea  WITH  'RD' , No_Sumar WITH .T.
REPLACE NomOpe WITH OPER.NomOpe

SELECT VMOV
X1TotDbe = X1TotDbe + nDbe
X1TotHbe = X1TotHbe + nHbe
X1TotDbe2 = X1TotDbe2 + nDbe2
X1TotHbe2 = X1TotHbe2 + nHbe2
RETURN

****************
PROCEDURE LINRES
****************
SELECT VMOV
XsNroAst = NroAst
sKey     = NroMes+CodOpe+NroAst
nDbe     = 0
nDbe2    = 0
nHbe     = 0
nHbe2    = 0
nItm     = 0
NumEle   = 0
nNumDis  = 0
IF FLGEST = "A"
ENDIF
SELECT RMOV
SEEK sKey
DO WHILE  ! EOF() .AND.  RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst = sKey
	=SEEK (CodCta,"CTAS")
	=SEEK(ClfAux+CodAux,"AUXI")
	LsGloDoc = []
	LsImport = []
	IF TpoMov='D'
		nDbe = nDbe + Import
		nDbe2= nDbe2+ ImpUsa
	ELSE
		nHbe = nHbe + Import
		nHbe2= nHbe2+ ImpUsa
	ENDIF
   
	DO TotResu with rmov.NroMes,Rmov.CodOpe,Rmov.CodCta,rmov.TpoMov,rmov.Import,Rmov.IMpusa

	SELE RMOV
	nItm = nItm + 1
	IF !EOF()
		SKIP
	ENDIF
ENDDO
SELECT VMOV
IF nItm = 0 .AND. ! FLGEST = "A"
ENDIF
****** DESCRIBIENDO ERRORES *****
X1TotDbe = X1TotDbe + nDbe
X1TotHbe = X1TotHbe + nHbe
X1TotDbe2 = X1TotDbe2 + nDbe2
X1TotHbe2 = X1TotHbe2 + nHbe2
RETURN
*****************
PROCEDURE TotResu
*****************
PARAMETERS cNroMes,cCodOpe,cCodCta,cTpoMov,nImpNac,nImpExt
xSelect = SELECT()
TnLen1   = LEN(cCodCta)
TnLen2   = LEN(TRIM(cCodCta))
*!*	TnCont   = TnLen2
TnCont   = 1
DO WHILE TnCont > 0
	TsCodCta = rmov.CodCta   && LEFT(cCodCta,TnCont)+SPACE(TnLen1-TnCont)
	cNromes = rmov.NroMes
	cCodOpe = rmov.CodOpe
	cTpoMov = rmov.TpoMov
	nImpNac = rmov.Import
	nImpUsa = rmov.ImpUsa
	SELECT CTAS
	SET ORDER TO CTAS01
	SEEK TsCodCta
	IF CTAS.AftMov = "S" AND cCodOpe = XsCodOpe
		IF FOUND()
			SELECT temporal
			SEEK cNroMes+cCodOPe+TsCodCta
			IF ! FOUND()
				APPEND BLANK
				REPLACE NroMes WITH cNroMes
				REPLACE CodOpe WITH cCodOpe
				REPLACE CodCta WITH TsCodCta
				=SEEK(TsCodCta,"CTAS")
				REPLACE NomOpe WITH OPER.NomOpe
				REPLACE GloDoc WITH CTAS.NomCta
				replace no_Sumar with .t.
			ENDIF
			IF cTpoMov = "D"
				REPLACE c_Dbe	WITH c_Dbe	+ nImpNac
				REPLACE c_Dbe2	WITH c_Dbe2 + nImpUsa
			ELSE
				REPLACE c_Hbe	WITH c_Hbe	+ nImpNac
				REPLACE c_Hbe2	WITH c_Hbe2 + nImpUsa
			ENDIF
		ENDIF
	ENDIF
	TnCont = TnCont - 1
	SELECT rmov
*!*		skip
ENDDO
SELECT (xSelect)
RETURN
*****************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
return
