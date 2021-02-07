**************************************************************************
*  Nombre       : ccbr4700.prg
*  Proposito    : Impresion de Letras en Formato Continuo
*  Autor        : RHC
*  Creaci¢n     : 16/05/94
*  Actualizaci¢n:
**************************************************************************
SYS(2700,0)
CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
Arch = ''

WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO fondo WITH 'Impresión de letras en formato continuo',Goentorno.user.login,GsNomCia,GsFecha

DO IMPRIME WITH ''

IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('DIRE')
	USE IN DIRE
ENDIF

CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
*****************
PROCEDURE IMPRIME
*****************
PARAMETERS LsCanje
IF VARTYPE(LsCanje)='U' 
	LsCanje =''
	lSolo = .f.
ELSE
	lSolo = .t.	
ENDIF
IF EMPTY(LSCanje)
	lSolo = .f.
ENDIF
IF !lSolo
	** pantalla de datos **
	@ 2,0 TO 20,79 PANEL
	Titulo = "IMPRESION DE LETRAS EN FORMATO CONTINUO"
	@ 2,(80-LEN(Titulo))/2 SAY Titulo
	LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
	LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
	LoDatAdm.abrirtabla('ABRIR','CCTCDIRE','DIRE','DIRE02','')
	LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
	LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
ELSE
	SELECT TASG
	SET RELATION TO
	SELECT GDOC 
	LsTagGDOC=Order()
	SET ORDER TO GDOC01
	SELECT VTOS
	LsTagVTOS=Order()
	SET ORDER TO VTOS01
	SELECT AUXI
	SET ORDER TO AUXI01
ENDIF

** relaciones a usar **
SELE GDOC
SET FILTER TO tpovta<>3
SET RELA TO GsClfCli+CodCli INTO AUXI
SET RELA TO GsClfCli+CodCli INTO CLIE ADDITIVE
SET RELA TO GsClfCli+CodCli+CLIE.CodDire INTO DIRE ADDITIVE
** variables a usar **
PRIVATE XsTpoDoc,XsCodDoc,XsNroDocD,XsNroDocH
XsTpoDoc = [CARGO]
XsCodDoc = [LETR]
XsNroDocD= SPACE(LEN(GDOC->NroDoc))
XsNroDocH= SPACE(LEN(GDOC->NroDoc))
IF !lSolo
	** Rango de numeros **
	@  8,20 SAY "Desde la Letra :" GET XsNroDocD PICT "@!"
	@ 10,20 SAY "Hasta la Letra :" GET XsNroDocH PICT "@!"
	READ
	IF LASTKEY() = 27
	   RETURN
	ENDIF
ELSE
*	LsCanje = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
	SELECT GDOC
	SET ORDER TO gdoc03
	SEEK LsCanje
	SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc=LsCanje
			IF EMPTY(XsNroDocD)
				XsNroDocD=NroDoc
			ENDIF
			XsNroDocH=NroDoc
*!*			SELECT Min(nrodoc) as nrodoc FROM gdoc WHERE TpoRef+CodRef+NroRef+TpoDoc+CodDoc=LsCanje UNION ;
*!*			SELECT MAX(nrodoc) as nrodoc FROM gdoc WHERE TpoRef+CodRef+NroRef+TpoDoc+CodDoc=LsCanje  INTO CURSOR c_letras 
	ENDSCAN 
*!*		XsNroDocD=c_letras.NroDoc
*!*		GO BOTTOM in c_letras
*!*		XsNroDocH=c_letras.NroDoc
ENDIF
XsNroDocD = TRIM(XsNroDocD)
XsNroDocH = LEFT(TRIM(XsNroDocH)+REPLICATE('z',10),LEN(GDOC.NroDoc))
SELE GDOC
SET ORDER TO GDOC01
IF EMPTY(XsNroDocD)
   SEEK XsTpoDoc+XsCodDoc
   XsNroDocD = NroDoc
ELSE
   SEEK XsTpoDoc+XsCodDoc+XsNroDocD
   IF !FOUND()
      IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
         XsNroDocD = NroDoc
      ENDIF
   ENDIF
ENDIF
SEEK XsTpoDoc+XsCodDoc+XsNroDocD
IF !FOUND()
   GsMsgErr = [Fin de Archivo]
   DO lib_merr WITH 99
ENDIF
** impresion **
XFOR = ".T."
XWHILE  = "TpoDoc+CodDoc+NroDoc<=XsTpoDoc+XsCodDoc+XsNroDocH"
Largo  = 27       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "ccbr4700_"+GsSigCia
DO F0print WITH "REPORTS"
IF lSolo
	SELECT GDOC
	SET RELATION TO
	SET ORDER TO (LsTagGDOC) 
	SELECT VTOS
	SET ORDER TO (LsTagVTOS)
	SELECT TASG
	SET RELA TO GsClfCli+CodCli INTO AUXI
ENDIF
RETURN
*******************
FUNCTION REFERENCIA
*******************
RETURN .F.
xRegAct=RECNO()
okk= .F.
EOF1 = EOF()
IF CodRef="RENV"
   SELE VTOS
   SET ORDER TO VTOS04
   SEEK GDOC->CODCLI+GDOC->CODREF+GDOC->NROREF
   IF FOUND()
      SELE GDOC
      SEEK VTOS->TpoRef+VTOS->CodRef+VTOS->NroRef
      IF FOUND()
         okk =.T.
         LsGlosa1="REFERENCIA:"
         LsGlosa2="L "+GDOC.NRODOC
         LsGlosa3=IIF(CodMon=1,"S/","US$")+TRANS(GDOC.SDODOC,"9999,999.99")
         LsGlosa4="vcto. "+DTOC(FchVto)
      ENDIF
   ENDIF
ENDIF
SELE VTOS
SET ORDER TO VTOS01
SELE GDOC
IF EOF1
   GO BOTT
ELSE
   GO xRegAct
ENDIF
RETURN okk
*****************
FUNCTION _RefDocs
*****************
PARAMETERS PsCodDoc,PsNroDoc
LOCAL LsAreaAct,LsOrderAct
LsAreaAct=SELECT()
STORE '' TO LsDocRefs
DO CASE
CASE TASG.FlgEst='P'
*!*		SELECT * FROM GDOC WHERE TpoRef+CodRef+NroRef+TpoDoc+CodDoc="Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR" INTO CURSOR c_Letras_x_Aprobar
*!*		SELECT c_Letras_x_Aprobar
	SELECT RASG
	SEEK TASG.CodDoc+TASG.NroDoc
	SCAN WHILE CodDoc+NroDoc=TASG.CodDoc+TASG.NroDoc
		IF CodRef='LETR'
			LsDocRefs = LsDocRefs + LEFT(CodRef,1)+TRIM(NroRef)+','
		ELSE
			LsDocRefs = LsDocRefs + LEFT(CodRef,1)+SUBSTR(NroRef,2,2)+SUBSTR(NroRef,6)+','
		ENDIF
	ENDSCAN	
	LsDocRefs = SUBSTR(LsDocRefs,1,LEN(LsDocRefs)-1)
CASE TASG.FlgEst='E'
	SELECT VTOS
	SEEK PsCodDoc+PsNroDoc
	SCAN WHILE CodDoc+NroDoc=PsCodDoc+PsNroDoc
		IF CodRef='LETR'
			LsDocRefs = LsDocRefs + LEFT(CodRef,1)+TRIM(NroRef)+','
		ELSE
			LsDocRefs = LsDocRefs + LEFT(CodRef,1)+SUBSTR(NroRef,2,2)+SUBSTR(NroRef,6)+','
		ENDIF
	ENDSCAN 
	LsDocRefs = SUBSTR(LsDocRefs,1,LEN(LsDocRefs)-1)
CASE TASG.FlgEst = 'A'
	LsDocRefs = '**A N U L A D O**'
ENDCASE
SELECT (LsAreaact)
RETURN LsDocRefs