*** Pintamos pantalla *************

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REGENERACION DE SALDOS"
*!*	Do Fondo WITH cTit1,cTit2,cTit3,cTit4
NroDec   = 2
XsNroMes = TRANSF(_MES,"@L ##")
STORE 0    TO nImpNac,nImpUsa
STORE 1    TO xielige, xirpta,XiReindex   && xirpta = [SN]
STORE [ ]  TO xscodcta
STORE '' to LsMsgProc
XiElige = 2
do form cbd_regeneracion_de_saldos

return

**********************
PROCEDURE REGENERACION
**********************
SELE CTAS
SELE RMOV
SET ORDE TO RMOV03
SELE ACCT
SET ORDE TO ACCT01
*

cNroMes = STR(_MES,2,0)
LsMsgProc=[Anulando acumulandos anteriores ....]
DO CASE
   CASE  xielige=1
      SELE ACCT
      nMesIni = 0
      nMesFin = 12
      ZAP
      *
   CASE  xielige=2
      nMesIni = _Mes
      nMesFin = _Mes
      SEEK cNroMes
      SCAN WHILE NroMes=cNroMes
         DO WHILE !RLOCK()
         ENDDO
         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
         =Div_en_Cero()
         UNLOCK
      ENDSCAN
      *
   CASE  xielige=3
      nMesIni = 0
      nMesFin = 12
      FOR I= nMesIni TO nMesFin
          cNroMes = str(i,2,0)
          SEEK cNroMes+xscodcta
          SCAN WHILE NroMes=cNroMes .AND. CodCta = xscodcta
             DO WHILE !RLOCK()
             ENDDO
             REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
             =Div_en_Cero()
             UNLOCK
          ENDSCAN
      NEXT
      *
   CASE  xielige=4
      nMesIni = _Mes
      nMesFin = _Mes
      SEEK cNroMes+xscodcta
      SCAN WHILE NroMes=cNroMes .AND. CodCta = xscodcta
         DO WHILE !RLOCK()
         ENDDO
         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
         =Div_en_Cero()
         UNLOCK
      ENDSCAN
ENDCASE
IF xirpta = [S] AND xielige=1
	INDEX ON NROMES+CODCTA+CODREF TAG ACCT01
ENDIF
*
LsMsgProc=[Acumulando Saldos .....]
SELECT RMOV
FOR I= nMesIni TO nMesFin
    cNroMes = TRANSF(i,"@L ##")
    **@ 18,19 SAY PADC(MES(i,1),43)
    SEEK cNroMes+TRIM(xscodcta)
    DO WHILE ! EOF() AND NroMes = cNroMes AND CodCta = TRIM(xscodcta)
       LsCodCta = CodCta
       =SEEK(LsCodCta,"CTAS")
       XX = " "
       LsMsgProc =MES(cNroMes,1)+[ Procesando cuenta : ]+LsCodCta+XX+PADC(TRIM(CTAS.NomCta),40)
       DO WHILE !EOF() AND NroMes+CodCta=cNroMes+LsCodCta
          **@ 19,46 SAY XX
          XX = IIF(XX=" ",":"," ")
          IF !CodOpe = "9"
             DO cbdactct with CodCta, CodRef, i, TpoMov , Import, ImpUsa , CodDiv
          ELSE
             DO cbdactec with CodCta, CodRef, i, TpoMov , Import, ImpUsa , CodDiv
          ENDIF
          SELECT RMOV
          SKIP
       ENDDO
       LsMsgProc =MES(cNroMes,1)+[ Procesando cuenta : ]+LsCodCta+XX+PADC(TRIM(CTAS.NomCta),40)

    ENDDO
ENDFOR
LsMsgProc = [Proceso terminado]
RETURN

*******************
PROCEDURE ABRIR_DBF
*******************

xirpta = iif(xirpta=1,[S],[N])
LsMsgProc = [Aperturando Archivos ....]
lReturnOk=goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
IF !lReturnOk
	RETURN lReturnOk
ENDIF
lReturnOk=goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
IF !lReturnOk
	RETURN lReturnOk
ENDIF

*

IF xirpta = [S]
	lReturnOk=goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','','EXCLU')
	IF !lReturnOk
		RETURN lReturnOk
	ENDIF

	lReturnOk=goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','','EXCLU')
	IF !lReturnOk
		RETURN lReturnOk
	ENDIF

   *
	SELE RMOV
	IF xielige = 1
		PACK
	ENDIF
	INDEX ON NROMES+CODCTA+CODREF+CODOPE+NROAST TAG RMOV03
ELSE
*!*	   IF xielige = 1
*!*			lReturnOk=goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','EXCLU')
*!*		    IF !lReturnOk
*!*				RETURN lReturnOk
*!*			ENDIF

*!*	   ELSE
	    lReturnOk=goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','','')
	    IF !lReturnOk
			RETURN lReturnOk
		ENDIF

*!*	   ENDIF
   lReturnOk=goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','','')
	IF !lReturnOk
		RETURN lReturnOk
	ENDIF
ENDIF
*
RETURN lReturnOk
*
*********************
FUNCTION Div_en_Cero
*********************
FOR K=1 TO GnDivis
	LsDivis = TRAN(K,[@L ##])
	LsCmpDivH1 = [HbeNac]+LsDivis
	LsCmpDivD1 = [DbeNac]+LsDivis
	LsCmpDivH2 = [HbeExt]+LsDivis
	LsCmpDivD2 = [DbeExt]+LsDivis
	STORE .t. TO lActCmpDivH1,lActCmpDivD1,lActCmpDivH2,lActCmpDivD2
	IF TYPE(LsCmpDivH1)#[N]
		lActCmpDivH1=.f.
	ENDIF
	IF TYPE(LsCmpDivD1)#[N]
		lActCmpDivD1=.f.
	ENDIF
	IF TYPE(LsCmpDivH2)#[N]
		lActCmpDivH2=.f.
	ENDIF
	IF TYPE(LsCmpDivD2)#[N]
		lActCmpDivD2=.f.
	ENDIF
    IF lActCmpDivD1
    	REPLACE (LsCmpDivD1) WITH 0
    ENDIF
    IF lActCmpDivD2
    	REPLACE (LsCmpDivD2) WITH 0
    ENDIF
    IF lActCmpDivH1
    	REPLACE (LsCmpDivH1) WITH 0
    ENDIF
    IF lActCmpDivH2
    	REPLACE (LsCmpDivH2) WITH 0
    ENDIF
ENDFOR
RETURN
