parameters _codmatd,_codmath,_dfecha,_sede
Local Ls_alias

Ls_Alias = ALIAS()
m.CodMatD = _CodMatD && TRIM(THISFORM.TxtCodMatD.VALUE) ; Codigo Inicial de Item
m.CodMatH = _CodMatD && TRIM(THISFORM.TxtCodMatH.VALUE)+REPLICATE('z',len(CATG.CodMat))
m.Cuales  = 2		&& THISFORM.CboCuales.VALUE ;   1 Solo Con Stock ; 2 Todos
m.CodMon  = 1 		&& THISFORM.OpgCodMon.VALUE ; 1 Soles ; 2 Dolares
m.Estado  = 1 		&& THISFORM.OpgEstado.VALUE ; 1 Activos ; 2 Inactivos ; 3 Todos
m.FChDocH = _dFecha	&& THISFORM.TxtFchDocH.VALUE ; Fecha de corte
m.MesAnt  = 1 		&& Usar costo de referencia ; 1 Mes actual , 2 Mes Anterior
jSede    = _Sede 	&& THISFORM.CboSede.VALUE  && En blanco si se quiere stock de toda la CIA.
**m.DesSede = IIF(EMPTY(m.Sede),[GENERAL],[])
**m.TipRep  = THISFORM.CboTipRep.VALUE
m.GrabaTmp = ''

IF vartype(_MES)#'N'
	_MES = month(date())
ENDIF
*
IF vartype(_ANO)#'N'
	_ANO = YEAR(DATE())
ENDIF
*
IF _mes<=11
	DiaxMes=DAY(CTOD("01/"+TRAN(_MES+1,[@L ##])+"/"+STR(_ANO,4,0))-1)
ELSE
	DiaxMes=DAY(CTOD("31/01"+"/"+STR(_ANO+1,4,0)))
ENDIF
*
IF m.MesAnt=1    && En Base al mes actual
    dFchCto=m.FchDocH
ELSE
	dFchCto=CTOD("01/"+TRAN(_MES,[@L ##])+"/"+STR(_ANO,4,0))-1
ENDIF
*
DO CASE
   CASE m.Estado=1
        LsFor1=[NOT INACTIVO]
   CASE m.Estado=2
        LsFor1=[INACTIVO]
   CASE m.Estado=3
        LsFor1=[.T.]
ENDCASE
*
SELE ALMA
IF !EMPTY(jSede)
   SET FILTER TO CodSed=jSede
   GO TOP
ENDIF
*
SELE CALM
SET ORDER TO CATA02
SET RELA TO SubAlm INTO ALMA
*
SELE CATG
IF EMPTY(m.CodMatD)
   GO TOP
ELSE
   SEEK m.CodmatD
   IF ! FOUND() .AND. RECNO(0) > 0
      GOTO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
*
**SET STEP ON
SCAN WHILE CodMat>=m.CodMatD AND CodMat<=m.CodMatH FOR EVAL(LsFor1)
   sCodMat = CATG.CodMat
   fStkAct = 0
   fValAct = 0
   fStkSed = 0
   WAIT [Procesando Código ] + sCodMat WINDOW NOWAIT   
   lProcesar=.F.
   *
   SELE CALM
   SEEK sCodMat
   SCAN WHILE CodMat=sCodMat FOR ALMA.CodSed=TRIM(jSede)
        fStkAct  = fStkAct + StkIni
        fValAct  = fValAct + IIF(m.CodMon = 1, VIniMn, VIniUs)
        fStkSed =  fStkSed + Gocfgalm.CapStkAlm(SubAlm,CodMat,m.FchDocH)
       *fStkSed =  fStkSed + ROUND(Gocfgalm.CapStkAlm(SubAlm,CodMat,m.FchDocH),2)
      	lProCesar=.T.
   ENDSCAN
   *
   IF !lProcesar
		SELE CATG
   		LOOP
   ENDIF
   * && Capturamos Stock minimo para producción.	
   XfStkMin = GoCfgAlm.CapStkMin(sCodMat,m.FchDocH)	&& THISFORM.CapStkMin(sCodMat,m.FchDocH)   
   SELE DTRA				   					 	  
  *set order to dtra03                  &&&& VETT ==> Debe ir dtra09 no dtra03 ???? 
  *SEEK sCodMat+DTOS(m.FchDocH+1)  
   set order to dtra09
   SEEK jSede+sCodMat+DTOS(m.FchDocH+1)     
   IF !FOUND()
      IF RECNO(0)>0
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
      ENDIF
   ENDIF
   SKIP -1
   IF CodSed+CodMat = jSede+sCodMat AND FchDoc<=m.FchDocH
      fStkAct = DTRA.StkAct
      fValAct = IIF(m.CodMon = 1,VCTOMN,VCTOUS)
   ENDIF
   ** APRENDE CORCHA **
   IF fStkAct <= 0 && Esta mal recalculado o justo el stock se hizo cero con el Ult. Movimiento
		SKIP -1
	   IF CodSed+CodMat = jSede+sCodMat AND FchDoc<=m.FchDocH
	      fStkAct = DTRA.StkAct
	      fValAct = IIF(m.CodMon = 1,VCTOMN,VCTOUS)
	   ENDIF
   ENDIF	   
   ** HABER SI CAMBIAS DE DIETA POR QUE TE ESTAS VOLVIENDO MAS BRUTA **
   IF !EMPTY(jSede)
      IF fStkAct#0
		IF EMPTY(m.GrabaTmp) OR ISNULL(m.GrabaTmp)
		else
			fValAct = fStkSed*fValAct/fStkAct
			fStkAct = fStkSed
		endif				
      ELSE
        fValAct = 0
        fStkAct = fStkSed
      ENDIF
   ENDIF
   *
   IF m.MesAnt=2
	  SELE DTRA
	  SEEK jSede+sCodMat+DTOS(dFchCto+1)
	  IF !FOUND()
	     IF RECNO(0)>0
	        GO RECNO(0)
	        IF DELETED()
	           SKIP
	        ENDIF
	     ENDIF
	  ENDIF
	  SKIP -1
	  IF CodSed+CodMat = jSede+sCodMat AND FchDoc<=dFchCto
	     zfStkAct = DTRA.StkAct
	     zfValAct = IIF(m.CodMon = 1,VCTOMN,VCTOUS)
	     IF zfStkAct#0
	        fValAct = zfValAct/zfStkAct*fStkAct
   	     ELSE
	        fValAct = fStkAct*IIF(m.CodMon=1,CATG.PctoMn,CATG.PctoUs)
	     ENDIF
	  ENDIF
	ENDIF		
	*
    IF !(m.Cuales = 1 AND fStkAct<=0)
		IF EMPTY(m.GrabaTmp) OR ISNULL(m.GrabaTmp)
			gocfgalm.pctomn = CATG.PctoMn
			gocfgalm.pctous = CATG.PctoUs
			gocfgalm.stkact = fstkact
			gocfgalm.ctouni = IIF(m.CodMon=1,CATG.PctoMn,CATG.PctoUs)
		    LfCtoUni = 0
		    IF fStkAct#0
				LfCtoUni = ROUND(fValAct/fStkAct,4)
		    ENDIF
			gocfgalm.ctouni = IIF(LfCtoUni>0,LfCtoUni,goCfgAlm.CtoUni)
		ELSE
			SELE TEMPORAL
			SEEK sCodMat
		    IF !FOUND()
		        APPEND BLANK
		        REPLA CodMat WITH sCodMat
		        REPLA CodCia WITH jSede
		    ENDIF
		    *
		    REPLA StkAct WITH fStkAct
		    REPLA ValTot WITH fValAct
		    REPLA CtoUni WITH IIF(m.CodMon=1,CATG.PctoMn,CATG.PctoUs)
		    *
		    LfCtoUni = 0
		    IF StkAct#0
				LfCtoUni = ROUND(ValTot/StkAct,4)
		    ENDIF
		    *
		    LfCtoUni = IIF(LfCtoUni>0,LfCtoUni,CtoUni)
		    LfValMax = ROUND(CATG.StkMax*XfStkMin/DiaXmes*LfCtoUni,2)
		    LfValMin = ROUND(CATG.StkRep*XfStkMin/DiaXmes*LfCtoUni,2)
		    LfCanMax = ROUND(CATG.StkMax*XfStkMin/DiaXmes,2)
		    LfCanMin = ROUND(CATG.StkRep*XfStkMin/DiaXmes,2)
		    *
		    IF XfStkMin#0
		    	REPLA StkDia WITH ROUND(StkAct/XfStkMin*DiaXMes,0)
		    ENDIF
		    *
		    REPLA StkRep WITH CATG.StkRep
		    REPLA StkMax WITH CATG.StkMax
		    REPLA StkMin WITH ROUND(XfStkMin,0)
		    REPLA ValMax WITH LfValMax
		    REPLA ValMin WITH LfValMin
		    REPLA CanMax WITH LfCanMax
		    REPLA CanMin WITH LfCanMin
		    *
		    DO CASE
		    	CASE StkMax#0 AND ValTot>ValMax
			    	REPLA ValExc WITH ValTot - ValMax
		            REPLA CanExc WITH StkAct - CanMax
		    	CASE StkRep#0 AND ValTot<ValMin
			    	REPLA ValDef WITH ValMin - ValTot
		    		REPLA CanDef WITH CanMin - StkAct
		    ENDCASE
		    *
		    IF XfStkMin#0
		    	REPLA DiaExc WITH ROUND(CanExc*DiaxMes/XfStkMin,0)
		    ENDIF
		    IF XfStkMin#0
		    	REPLA DiaDef WITH ROUND(CanDef*DiaxMes/XfStkMin,0)
		    ENDIF
		ENDIF
	ENDIF	
	SELE CATG
ENDSCAN
*
SELE DTRA				   					 	  
set order to dtra03
*
SELECT CALM
SET ORDER TO CATA01
set rela to 
sele alma
set filter to
IF !EMPTY(Ls_ALias)
	SELECT (Ls_Alias)
ENDIF
WAIT [OK..] WINDOW NOWAIT   
RETURN

