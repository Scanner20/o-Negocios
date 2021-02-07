**************************************************************************
*  Nombre    : CCBP5200.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Actualizaci¢n de Saldos                                   *
*  Actualizaci¢n: 01/09/95 VETT                                          *
* Modifcado por VETT 2008/09/23 15:46:11 
**************************************************************************
** Pintamos pantalla *************
*save screen to xstmp
SYS(2700,0)
DO fondo WITH 'Regeneración de saldos',Goentorno.user.login,GsNomCia,GsFecha
DO Regenera
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF

PROCEDURE Regenera
CLEAR
@ 2,0 TO 20,79 PANEL
@ 2,31  say "R E C A L C U L O"  color scheme 7
@ 4,10  SAY "   Este proceso tiene por finalidad de recalcular los saldos  "  color scheme 7
@ 5,10  SAY " de todos los documentos pendientes segun los movimientos rea-"  color scheme 7
@ 6,10  SAY " lizados y actualizarlos en el archivo de documentos.         "  color scheme 7
@ 7,10  SAY "                                                              "  color scheme 7
@ 8,10  SAY "  Este proceso realiza una apertura de archivo  exclusiva por "  color scheme 7
@ 9,10  SAY " tanto  deber   ser  la  £nica  tarea  que se efectue sobre el"  color scheme 7
@ 10,10 SAY " sistema.                                                     "  color scheme 7
@12,35 prompt "CANCELAR"
@14,35 prompt "RECALCULAR"
menu to opc

IF LASTKEY() = 27 .OR. opc = 1
	SYS(2700,1)
    clear
    RETURN
ENDIF
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC02','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS05','')
IF verifyvar('VTAVPROF','TABLE','INDBC','CIA'+GsCodCia)
	LoDatAdm.abrirtabla('ABRIR','VTAVPROF','VPRO','VPRO05','')
ENDIF
RELEASE LoDatAdm

SELECT SLDO
m.CodCli1 = SPACE(LEN(SLDO.Codcli))
m.CodCli2 = SPACE(LEN(SLDO.Codcli))
m.SoloFchVto = 'N'

@ 3,1 CLEAR TO 19,78

@ 5,10 SAY "Del Cliente : "
@ 6,10 SAY "Al  Cliente : "
@ 7,10 SAY "Solo Fch. Vto: [S/N] "
@ 05,28  GET m.codcli1 PICT "@!" valid _vlook(@m.codcli1,'codaux')
@ 06,28  GET m.codcli2 PICT "@!" valid _vlook(@m.codcli2,'codaux') when _wcodcli2()
@ 07,32  get m.SoloFchVto PICT "@!" DEFAULT 'N' VALID m.SoloFchVto$'SsNn'
READ
UltTecla = LASTKEY()
IF LASTKEY() = 27
    DO close_file
    RETURN
ENDIF
@ 17,26 SAY "Cliente :.................." COLOR -
@ 18,17 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 11
@ 19,17 SAY "³                                            ³" COLOR SCHEME 11
@ 20,17 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11
@ 19,26 SAY "Chequeando informaci¢n....." COLOR -
@ 22,28 SAY "                   " COLOR SCHEME 7
@ 23,28 SAY "                   " COLOR SCHEME 7
*** Logica Principal  ***
PorAnt   = 0
LiNumLin = 0
TnNumLin = 0
TnNumLin2 = 0
LnLinea  = 1
m.CodCli1=TRIM(m.CodCli1)
m.CodCli2=TRIM(m.CodCli2)
IF m.CodCli1=m.CodCli2  AND !EMPTY(m.Codcli1)
    SELE GDOC
    SEEK m.CodCli1
    COUNT WHILE CodCli=m.CodCli1 TO TnNumLin
    SELE VPRO
    SEEK m.CodCli1
    COUNT WHILE CodCli=m.CodCli1 TO TnNumLin2
    LnLinea = 2
ELSE
    SELE CLIE
    m.codcli2 = ALLTRIM(m.codcli2)
    m.codcli2 = LEFT(m.codcli2+REPLI("z",LEN(codaux)),LEN(codaux))
    SEEK GsClfCli+TRIM(m.CodCli1)
    COUNT WHILE ClfAux=GsClfCli AND CodAux<=m.CodCli2 TO TnNumLin
    SELE VPRO
    SEEK m.CodCli1
    COUNT WHILE CodCli>=m.CodCli1 AND CodCli<=m.CodCli2 TO TnNumLin2

    LnLinea = 1
ENDIF
lfimptot=0.0
SELE CLIE
m.codcli2 = ALLTRIM(m.codcli2)
m.codcli2 = LEFT(m.codcli2+REPLI("z",LEN(codaux)),LEN(codaux))
IF m.SoloFchVto='S'

	LnRpta=F1_alert('Solo se va a remplazar las  fechas de vencimientos que estan vacias; Sumando la fecha del documento mas los dias de vencimiento.; Seguro de Continuar?',"SI_O_NO")
	SELECT GDOC
	SCAN FOR  TpoDoc='CARGO' AND COdCli>=m.CodCli1 AND CodCli<=m.COdCLi2 AND EMPTY(FchVto)
		
		IF RLOCK()
			WAIT WINDOW 'Doc:'+TpoDoc+' '+CodDoc+' '+NroDoc+' Fecha:'+DTOC(FchDoc) NOWAIT
			replace FcHVto WITH FchDoc + DIAVTO  
		endif
	ENDSCAN
    DO close_file
    RETURN 
ENDIF

SEEK GsClfCli+TRIM(m.CodCli1)
SET STEP ON 
DO WHILE !EOF() AND CodAux<=m.CodCli2 AND ClfAux=GsClfCli
*!*	    IF LnLinea >= 1
*!*	       Do Linea
*!*	    ENDIF
    XsCodCli = CodAux
    STORE 0 TO LfCgoNac,LfCgoUsa,LfAbnNac,LfAbnUsa
    SELE GDOC
    SEEK XsCodCli
    DO WHILE !EOF() AND CodCli=XsCodCli
    		
*!*         IF LnLinea = 2
*!*            Do Linea
*!*         ENDIF
		IF VARTYPE(FlgNO)='C'  && Verficamos si existe campo y es de tipo Char
			IF FlgNo='N'
				** NO TOCAMOS SU SALDO Y ESTADO **
				SKIP
				LOOP
			ENDIF		  
		ENDIF
        Okk = .F.
        LfImptot=0.00
        =REC_LOCK(5)
        IF GDOC->TpoDoc=[CARGO]
           SELE VTOS
           SET ORDER TO VTOS05
           SEEK GDOC.CodCli+GDOC.CodDoc+GDOC.NroDoc
           SCAN WHILE CodCli+CodRef+NroRef=GDOC.CodCli+GDOC.CodDoc+GDOC.NroDoc
              LfImpTot=LfImpTot+IIF(GDOC.CodMon=CodMon,Import,IIF(CodMon=1, ;
                                                    Import/Tpocmb,Import*Tpocmb))
              OKK=.T.
           ENDSCAN
        ELSE
           SELE VTOS
           SET ORDER TO VTOS01
           SEEK GDOC.CodDoc+GDOC.NroDoc
           SCAN WHILE CodDoc+NroDoc=GDOC.CodDoc+GDOC.NroDoc
              LfImpTot=LfImpTot+IIF(GDOC.CodMon=CodMon,Import,IIF(CodMon=1, ;
                                                    Import/Tpocmb,Import*Tpocmb))
              OKK=.T.
           ENDSCAN
        ENDIF
        SELE GDOC
        IF GsSigCia='AROMAS' AND DTOS(GDOC.FchDoc)<='20060517' AND DTOS(GDOC.FchVto)<='20060517'
           IF FlgEst = "T"
              && en tramite no afectamos el saldo
           ELSE
              IF TpoDoc="CARGO"
                 LfCgoNac = LfCgoNac + IIF(GDOC.CodMon=1,SdoDoc,0)
                 LfCgoUsa = LfCgoUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
              ELSE
                 LfAbnNac = LfAbnNac + IIF(GDOC.CodMon=1,SdoDoc,0)
                 LfAbnUsa = LfAbnUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
              ENDIF
  		 ENDIF      
        ELSE	 && Comportamiento normal del Proceso de regeneracion de Documentos de CCB  	
        
  	      IF OKK  && Tiene movimientos en CCBMVTOS
  	         IF FlgEst#"A"
  	            REPLACE SdoDoc WITH (ImpTot-LfImptot)
  	            IF SdoDoc<=0.01
  	               REPLACE FlgEst WITH 'C'
  	               REPLACE SdoDoc WITH 0
  	            ELSE
  	               REPLACE FlgEst WITH 'P'
  	            ENDIF
  	            IF FlgSit="a" AND CodDoc="LETR"
  	               REPLACE FlgEst WITH "T"
  	            ENDIF
  	         ELSE
  	            REPLACE SdoDoc WITH 0
  	         ENDIF
  	         IF FlgEst = "T"
  	            && en tramite no afectamos el saldo
  	         ELSE
  	            IF TpoDoc="CARGO"
  	               LfCgoNac = LfCgoNac + IIF(GDOC.CodMon=1,SdoDoc,0)
  	               LfCgoUsa = LfCgoUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
  	            ELSE
  	               LfAbnNac = LfAbnNac + IIF(GDOC.CodMon=1,SdoDoc,0)
  	               LfAbnUsa = LfAbnUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
  	            ENDIF
  	         ENDIF
  	      ELSE
  	         REPLACE SdoDoc WITH Imptot
  	         IF FlgEst$"AT"
  	            IF FlgEst = "A"
  	               REPLACE SdoDoc WITH 0
  	            ENDIF
  	         ELSE
  	            IF SdoDoc>=0
  	               REPLACE FlgEst WITH [P]
  	            ENDIF
  	            IF TpoDoc="CARGO"
  	               LfCgoNac = LfCgoNac + IIF(GDOC.CodMon=1,SdoDoc,0)
  	               LfCgoUsa = LfCgoUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
  	            ELSE
  	               LfAbnNac = LfAbnNac + IIF(GDOC.CodMon=1,SdoDoc,0)
  	               LfAbnUsa = LfAbnUsa + IIF(GDOC.CodMon=2,SdoDoc,0)
  	            ENDIF
  	         ENDIF
  	      ENDIF
        ENDIF
        UNLOCK
        SKIP
    ENDDO
    *** REGENERAMOS PROFORMAS *** 
    **>>  Vo.Bo. VETT  2008/09/23 15:46:40 

*!*	    IF LnLinea = 2
*!*	 		PorAnt   = 0
*!*	    	LiNumLin = 0
*!*	    	TnNumLin = TnNumLin2		
*!*	    ENDIF
	IF verifyvar('VTAVPROF','TABLE','INDBC','CIA'+GsCodCia)
	
	    STORE 0 TO LfCgoNac2,LfCgoUsa2,LfAbnNac2,LfAbnUsa2
	    LsArcTmp = GoEntorno.TmpPath+SYS(3)
			
	    SELE VPRO
		SEEK XsCodCli
	    DO WHILE !EOF() AND CodCli<=XsCodCli
	  		IF coddoc='NCPR' AND NRODOC='00000289'
	  				SET STEP ON 
	  		ENDIF
			IF VARTYPE(FlgNO)='C'  && Verficamos si existe campo y es de tipo Char
				IF FlgNo='N'
					** NO TOCAMOS SU SALDO Y ESTADO **
					SKIP
					LOOP
				ENDIF		  
			ENDIF	 		
	*!*         IF LnLinea = 2
	*!*            DO Linea
	*!*         ENDIF
	        Okk = .F.
	        LfImptot2=0.00
	        =REC_LOCK(5)
	        IF VPRO.CodDoc=[PROF]
	           SELE VTOS
	           SET ORDER TO VTOS05
	           SEEK VPRO.CodCli+VPRO.CodDoc+VPRO.NroDoc
	           SCAN WHILE CodCli+CodRef+NroRef=VPRO.CodCli+VPRO.CodDoc+VPRO.NroDoc
	              LfImpTot2=LfImpTot2+IIF(VPRO.CodMon=CodMon,Import,IIF(CodMon=1, ;
	                                                    Import/Tpocmb,Import*Tpocmb))
	              OKK=.T.
	           ENDSCAN
	        ELSE
	           SELE VTOS
	           SET ORDER TO VTOS01
	           SEEK VPRO.CodDoc+VPRO.NroDoc
	           SCAN WHILE CodDoc+NroDoc=VPRO.CodDoc+VPRO.NroDoc
	              LfImpTot2=LfImpTot2+IIF(VPRO.CodMon=CodMon,Import,IIF(CodMon=1, ;
	                                                    Import/Tpocmb,Import*Tpocmb))
	              OKK=.T.
	           ENDSCAN
	        ENDIF
	        SELE VPRO
	    	  ** Comportamiento normal del Proceso de regeneracion de Documentos de CCB  	
	       
	        IF OKK  && Tiene movimientos en CCBMVTOS
	           IF FlgEst#"A"
	              REPLACE SdoDoc WITH (ImpTot-LfImptot2)
	              IF SdoDoc<=0.01
	                 REPLACE FlgEst WITH 'C'
	                 REPLACE SdoDoc WITH 0
	              ELSE
	                 REPLACE FlgEst WITH 'P'
	              ENDIF
	  *!*	            IF FlgSit="a" AND CodDoc="LETR"
	  *!*	               REPLACE FlgEst WITH "T"
	  *!*	            ENDIF
	           ELSE
	              REPLACE SdoDoc WITH 0
	           ENDIF
	           IF FlgEst = "T"
	              && en tramite no afectamos el saldo
	           ELSE
	              IF CodDoc="PROF"
	                 LfCgoNac2 = LfCgoNac2 + IIF(VPRO.CodMon=1,SdoDoc,0)
	                 LfCgoUsa2 = LfCgoUsa2 + IIF(VPRO.CodMon=2,SdoDoc,0)
	              ELSE
	                 LfAbnNac2 = LfAbnNac2 + IIF(VPRO.CodMon=1,SdoDoc,0)
	                 LfAbnUsa2 = LfAbnUsa2 + IIF(VPRO.CodMon=2,SdoDoc,0)
	              ENDIF
	           ENDIF
	        ELSE
	           REPLACE SdoDoc WITH Imptot
	           IF FlgEst$"AT"
	              IF FlgEst = "A"
	                 REPLACE SdoDoc WITH 0
	              ENDIF
	           ELSE
	              IF SdoDoc>=0
	                 REPLACE FlgEst WITH [P]
	              ENDIF
	              IF CodDoc="PROF"
	                 LfCgoNac2 = LfCgoNac2 + IIF(VPRO.CodMon=1,SdoDoc,0)
	                 LfCgoUsa2 = LfCgoUsa2 + IIF(VPRO.CodMon=2,SdoDoc,0)
	              ELSE
	                 LfAbnNac2 = LfAbnNac2 + IIF(VPRO.CodMon=1,SdoDoc,0)
	                 LfAbnUsa2 = LfAbnUsa2 + IIF(VPRO.CodMon=2,SdoDoc,0)
	              ENDIF
	           ENDIF
	        ENDIF
	        UNLOCK
	        SKIP
	    ENDDO
	ELSE
	    
	ENDIF    


	**>>  Vo.Bo. VETT  2008/09/23 15:46:54 

    SELE SLDO
    SEEK XsCodCli
    IF !FOUND()
        APPEND BLANK
        =REC_LOCK(5)
        REPLACE CodCli WITH XsCodCli
       *REPLACE NomCli WITH AUXI.NomAux
       *REPLACE DirCli WITH AUXI.DirAux
    ELSE
       =REC_LOCK(5)
    ENDIF
    REPLACE SLDO->CgoNac  WITH LfCgoNac+LfCgoNac2
    REPLACE SLDO->CgoUsa  WITH LfCgoUsa+LfCgoUsa2
    REPLACE SLDO->AbnNac  WITH LfAbnNac+LfAbnNac2
    REPLACE SLDO->AbnUsa  WITH LfAbnUsa+LfAbnUsa2
    UNLOCK
    SELE CLIE
    SKIP
ENDDO
@18,30 SAY '                      '
*** IGUALANDO CUENTAS DE TRANSFERENCIA  ****
WAIT "RECALCULO COMPLETADO...<Enter> para salir" WINDOW
*restore screen from xstmp
DO CLOSE_FILE

CLEAR
SYS(2700,1)
RETURN
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select Clie
   IF ! ccbbusca("CLIE")
      SELECT GDOC
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla= Enter
   SELECT GDOC
ENDIF
IF !SEEK(GsClfCli+VAR1,"CLIE") AND !EMPTY(VAR1)
   RETURN .F.
ENDIF
IF UltTecla = ENTER
	@5+_CurObj-1,28 + 12 say CLIE.NomAux PICT "@S30"
ENDIF
IF UltTecla = escape_ .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
RETURN .T.
******************
FUNCTION _wCodcli2
******************
IF !EMPTY(m.codcli1) AND EMPTY(m.CodCli2)
	m.codcli2 = m.codcli1
ENDIF
***************
PROCEDURE Linea
***************
LiNumLin = LiNumLin + 1
PorAct   =  INT(LiNumLin*40/TnNumLin)
IF PorAct <> PorAnt
   PorAnt  = PorAct
   @  19,17 SAY "³                                            ³" COLOR SCHEME 11
   @ 19,18 SAY REPLICATE("Û",PorAct) COLOR SCHEME 11
ENDIF
@ 19,18+PorAnt SAY ltrim(str(LiNumLin*100/TnNumLin,3,0))+"%"
RETURN
********************
PROCEDURE close_file
********************
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('SLDO')
	USE IN SLDO
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF
IF USED('VPRO')
	USE IN VPRO
ENDIF


PROCEDURE xxx
SET STEP ON 

