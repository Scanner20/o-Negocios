*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý Cmpcpcxm.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý LOGISTICA DE COMPRAS   - FOXPRO 2.6                         Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538 - 9411837              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Programa de compra de insumos mensual.                      Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 10/03/97                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                      xxxx                   Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
PUBLIC sModulo,_PorIgv,lReproceso,lPone_En_0,lOtroSist,m.Estado,m.dFch1,m.dFch2,;
nMesIni,nMEsFin,XnMesPrm,m.CodMon,m.ConIgv,m.SolFac,m.ParaAqui,m.CodMatD,m.CodMatH,;
m.bTitBrow,m.TitRepo,m.tipo,ArcTmp2,ArcTmp

IF TYPE([K_ESC])=[U]
   PUBLIC k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,k_f_der,;
          k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,k_f4,k_f5,k_f6,k_f7,;
          k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,k_sf6,k_sf7,k_sf8,k_sf9,;
          k_ctrlw,k_lookup,k_borrar,k_esc


   STORE 0 TO k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,;
              k_f_der,k_f_der,k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,;
              k_f4,k_f5,k_f6,k_f7,k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,;
              k_sf6,k_sf7,k_sf8,k_sf9,k_ctrlw,k_lookup,k_borrar,k_esc

   do def_teclas in f0matriz
   PUBLIC GsClfPro,GsBusca
   GsClfPro = [01 ] &&& Clasificaci¢n de los proveedores
   GsBusca  = [Cmpselec]
ENDIF

IF TYPE([C_LINEA])=[U]
   STORE "" TO C_Fondo,C_Linea,C_Say,C_Get,C_Sayr
   do def_color  in f0matriz
ENDIF
**
sModulo = [PROGCMP]
**
*=F1_BASE(GsNomCia,[PROGRAMA DE COMPRAS MENSUAL],"USUARIO:"+GsUsuario,GsPeriodo)
_PorIgv=18.00
lReproceso = .F.
lPone_En_0 = .F.
lOtroSist  = .F.
m.Estado   = 4
m.dFch1  =cTOd([01/]+TRAN(_MES,[@L ##])+[/]+tran(_ANO,[9999]))
m.dFch2  =GdFecha
nMesIni = _MES
nMEsFin = _MES
XnMesPrm = 3
m.CodMon = 1
m.ConIgv = .f.
m.SolFac = .f.
store 0 to zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08,zv09,zv10,zv11,zv12,zv13,zv14

DO FORM cmp_CmpCpcxM
SET ESCAPE OFF
RETURN
*******************
PROCEDURE GenTempo1   && Esta rutina procesa informaci_n
*******************
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
nMEsFin = nMEsIni
** Capturamos las sedes validas **
*IF !USED([SEDE])
*   SELE 0
*   USE SEDES ALIAS SEDE
*   IF !USED()
*      DO F1MSGERR WITH [Archivo de sedes no existe...!!! ]
*      RETURN
*   ENDIF
*ENDIF
SELE SEDE
SET FILTER TO !(UPPER(Nombre)=[CENTRAL])&&!(Codigo=[001])  && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,2)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*
USE
**
IF LReproceso AND !lPone_En_0
   WAIT WINDOW [Borrando informacion anterior...] NOWAIT
   SELE TOTAL
   SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") 
   **busca que exista el periodo actual de compra en el programa de compras, sino lo crea a partir del periodo inmediato anterior
   ** Si no hay copio el mes anterior **
   IF !FOUND() 
      WAIT WINDOW [Inicializando nuevo periodo ]+LEFT(GsAnoMes,4)+[ ]+TRAN(nMesIni,"@L ##") nowait
      ArcTmpAnt = PATHUSER+SYS(3)
	  IF nMesIni=1   		
	     TsPerAnt = STR(_ANO-1,4,0)+[12] 
	  ELSE
	     TsPerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 
	  ENDIF   				   
	  SEEK TsPerAnt
	  COPY REST TO (ArcTmpAnt) WHILE Periodo=TsPerAnt
	  SELE 0
	  USE (ArcTmpAnt) EXCLU
	  REPLACE ALL Periodo WITH LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")
	  TsMarca = [M]+TRAN(nMesIni,[@L ##])
	  REPLACE ALL &TsMarca. WITH  [ ]
	  USE
	  SELE TOTAL 
	  APPEND FROM (ArcTmpAnt)		  
      WAIT WINDOW [OK] nowait
   ENDIF
   SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")+m.CodMatD
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
   **inicializa todos los campos del programa de compras para el rango de materiales ingresado en el periodo actual
   SCAN WHILE Periodo=LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") AND CodMat<=m.CodMatH
        DO WHILE !RLOCK()
        ENDDO
        FOR M=nMesIni TO nMesFin
			StkMes = [SI]+TRAN(M,[@L ##])
			CmpMes = [CP]+TRAN(M,[@L ##])
			CsmMes = [CS]+TRAN(M,[@L ##])
			StkFin = [SF]+TRAN(M,[@L ##])
			StkVar = [SV]+TRAN(M,[@L ##])
			NroCmp = [NC]+TRAN(M,[@L ##])
			Marca  = [M]+TRAN(M,[@L ##])
			REPLACE &StkMes. WITH 0
			IF &Marca=[2]
			ELSE
			   REPLACE &Marca   WITH []
			   REPLACE &CmpMes. WITH 0
			ENDIF
			REPLACE &CsmMes. WITH 0
			REPLACE &StkFin. WITH 0
			REPLACE &StkVar. WITH 0
			REPLACE &NroCmp. WITH 0
			REPLACE FacRf1   WITH 0
			IF !EMPTY(FacRf2)
			ELSE
    			REPLACE FacRf2   WITH 0
			ENDIF
		ENDFOR
		UNLOCK
   ENDSCAN
   lPone_En_0 =.T.
   WAIT WINDOW [OK] NOWAIT
ENDIF
**
SELE CALM
SET RELA TO SubAlm INTO ALMA
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
set escape on
on escape do xsuspend
SELE CATG
SEEK m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE COdMat<=m.CodMatH FOR !Inactivo
     GrbMesesAnt=.F.
     LfStkMinF  = 0
     XtStkMin   = 0
     XnMesPrm   = 3
     ChkStkMin  = .F.
  ***FOR SS= 1 TO ALEN(vSedes,1)
  ***    SELE CALM
	 *** SEEK CATG.CodMat
***	   	 SCAN WHILE CodMat=CATG.CodMat FOR ALMA.Codsed=vSedes(SS,1)
***        FOR NK = nMesIni+1 TO 12
***            LsCmpMin = [STKM]+TRAN(NK,[@L ##])
***            XtStkMin = XtStkMin + &LsCmpMin.
***        ENDFOR
**       ENDSCAN
**	 ENDFOR
	 SELE CATG
     FOR KK= nMesIni TO nMesFin
         MesActual=KK
         XtStkMin = 0
         ***
		 GenRepoDet =.T.
		 SalProyAnt =.F.
		 IF !lReproceso
     	 	LsStkMin = [STKM]+TRAN(_MES,[@L ##])
		    GdFchIni = m.dFch1
		    GdFchFin = m.dFch2
		    StkIniAlm = .T.
  	        WAIT WINDOW COdMat+[ ]+DesMat NoWAIT
		 ELSE
		    GdFchIni  =CTOD([01/]+TRAN(MesActual,[@L ##])+[/]+tran(_ANO,[9999]))
		    IF MesActual<12
		       GdFchFin = CTOD("01/"+STR(MesActual+1,2,0)+"/"+STR(_Ano,4,0)) - 1
		    ELSE
		       GdFchFin = CTOD("31/12/"+STR(_Ano,4,0))
		    ENDIF
		    GenRepoDet=.F.
		    IF nMesIni=MesActual
				StkIniAlm=.T.
			    IF MONTH(DATE())<_MES OR _ANO>YEAR(DATE()) 
					LlFor1=DAY(DATE())<15 AND _ANO=YEAR(DATE()) AND _MES-MONTH(DATE())=1
					LlFor2=_MES-MONTH(DATE())>1 AND _ANO=YEAR(DATE())
					LlFor3=_ANO>YEAR(DATE()) 
					LlFor =LlFor1 OR LlFor2 OR LlFor3
					IF LlFor
				        	StkIniAlm=.F.
				        	SalProyAnt=.T.
					ENDIF				        	
			    ENDIF
		    ELSE
				StkIniAlm=.F.
		    ENDIF
   	 	    LsStkMin = [STKM]+TRAN(MesActual,[@L ##])
	        WAIT WINDOW MES(MesActual,3)+[ ]+COdMat+[ ]+DesMat NoWAIT
		 ENDIF
		 DiaxMes  = DAY(GdFchFin)
         ***
	     LsCodMat=CATG.CodMat
	     LfStkIniT = 0
	     LfStkMin  = 0
	     m.Nivel   = [D01]
	     lVolumen=CATG.VolPed>0
	     STORE 0 TO m.TStkIni,m.TStkFin,m.TCmpMes,m.TCsmMes
	     ** Stock por sedes **
	     FOR K=1 TO nSedes
	         LfStkINi=0
		     SELE CALM
		     SEEK LsCodMat
		     SCAN WHILE CodMat=LsCodMat FOR ALMA.CodSed=vSedes(K,1)
		        **LfStkIni = LfStkINi + &StkMesAnt.
		          LfStkIni = LfStkIni + GOCFGALM.CapStkAlm(SubAlm,CodMat,m.dfch1-1)
		          LfStkMin = LfStkMin + &LsStkMin.
		          NK=0
                  DO WHILE NK<XnMesPrm AND MesActual+NK<=12
                      LsCmpMin = [STKM]+TRAN(MesActual+NK,[@L ##])
                      XtStkMin = XtStkMin + &LsCmpMin.
                      NK=NK + 1
                  ENDDO
                  DO WHILE NK<XnMesPrm
                      LsCmpMin = [STKM]+TRAN(MesActual+NK-12,[@L ##])
                      XtStkMin = XtStkMin + &LsCmpMin.
                      NK=NK + 1
                  ENDDO
		     ENDSCAN
		     LfStkIniT=LfStkIniT + LfStkIni
	     ENDFOR
	     LfStkMinF = LfStkMinF + LfStkMin
	     SELE TEMPO
	     SEEK m.Nivel+LsCodMat
	     APPEND BLANK
	     REPLACE Nivel  WITH m.Nivel
	     REPLACE CodMat WITH LsCodMat
	     REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     LfstkIniT = IIF(LfStkIniT<0,0,LfStkIniT)
	     REPLACE StkIni WITH LfStkIniT
	     m.Periodo=left(GsAnoMes,4)+TRAN(nMesIni,"@L ##")
	     IF StkIniAlm
	        m.TStkIni=LfStkIniT
	     ELSE
	        IF MesActual = 1
	            m.PerAnt = []
				FOR aa = 12 TO 1 STEP -1	        	
					m.PerAnt = STR(_ANO - 1,4,0)+TRAN(aa,[@L ##])
					IF SEEK(m.PerAnt+LsCodMat,[TOTAL])
						EXIT
					ENDIF	
	            ENDFOR
	           lLocStkFin=SEEK(m.PerAnt+LsCodMat,[TOTAL])
	           CmpSF=[SF]+TRAN(12,"@L ##")
	        ELSE
	           CmpSF=[SF]+TRAN(MesActual-1,"@L ##")
	           lLocStkFin=SEEK(m.Periodo+LsCodMAt,[TOTAL])
	           IF SalProyAnt
					m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
		            lLocStkFin=SEEK(m.PerAnt+LsCodMAt,[TOTAL])
	           ENDIF
	        ENDIF
	        m.TStkIni=IIF(lLocStkFin,TOTAL.&CmpSF.,0)
	        m.TstkIni = IIF(m.TStkIni<0,0,m.TStkINi)
	     ENDIF
	     ** VeriFicamos las marcas
	     TfCmpAnt = 0
	     llCmpAnt = .F.
	     CmpMarca=[M]+TRAN(MesActual,"@L ##")
	     CmpMesAct=[CP]+TRAN(MesActual,"@L ##")
	     IF TOTAL.&CmpMarca=[2]
	        =SEEK(m.Periodo+LsCodMat,[TOTAL])
	        TfCmpAnt=TOTAL.&CmpMesAct.   && Conservar esta compra
	        LlCmpAnt=.T.
	     ENDIF
	     ** 
	     IF LfStkMin >0
	        IF !LReproceso
    	       XnDiaIni = ROUND(DiaXMes*LfStkIniT/LfStkMin,0)
	           REPLACE DiaIni WITH IIF(XnDiaIni>999999,999999,XnDiaIni)
	        ELSE
	           XnDiaIni = ROUND(DiaXMes*m.TStkIni/LfStkMin,0)
	           REPLACE DiaIni WITH IIF(XnDiaIni>999999,999999,XnDiaIni)
	        ENDIF
	     ELSE
	        REPLACE DiaIni WITH 0
	        REPLACE Flag1  WITH [1]
	     ENDIF
	     lHayStkMin=(LfStkMin>0)
	     REPLACE FchCmp WITH GdFchIni+DiaIni
	     LdFchCmpI = FchCmp
	     IF lVolumen
	        REPLACE VolPed WITH catg.volped
	        REPLACE NumCmp WITH 1
	        REPLACE CsmDia WITH IIF(lHayStkmin,VolPed,0)
	     ENDIF
	     IF LfStkMIn>0
	        XnDiaCsm = ROUND(DiaxMes*VolPed/LfStkMin,0)
	        REPLACE DiaCsm WITH IIF(XnDiaCsm>=9999,999999,XnDiaCsm)
	     ENDIF
	     lDiaCsmA = DiaCsm>=0.5
	     lDiaCsmB = DiaCsm<999999
	     lDiaCsm  = lDiaCsmA AND lDiaCsmB
	     LFStkReq = ROUND((CATG.TmpRep +CATG.StkSeg)*LfStkMin/DiaXMes,2)
	     TotCmpMes = ROUND(LfStkReq/CATG.VolPed,0)
	     m.TNumCmp = 0
	     m.TCsmMes = LfStkMin
	     IF FchCmp<=GdFchFin
	        FchproCmp = FchCmp + DiaCsm
	        IF DiaCsm>=DiaXMes
	           **m.TCsmMes = m.TCsmMes + LfStkMin
	        ELSE
    	       **m.TCsmMes = m.TCsmMes + IIF(DiaCsm<=0,0,Volped*DiaIni/DiaCsm)
    	       IF FchProCmp<=GdFchFin
    	         **m.TCsmMes = m.TCsmMes + CsmDia
    	       ENDIF    
	        ENDIF
	        m.TCmpMes = m.TCmpMes + VolPed
	        m.TNumCmp = m.TNumCmp + 1
	     ELSE
	        FchproCmp = FchCmp
	        IF DiaIni>=DiaXMes
	           **m.TCsmMes = LfStkMin
	           m.TCmpMes = 0
	        ELSE

	        ENDIF
	     ENDIF
	     ** Preguntamos si esta por debajo STKSEG+TMPREP **
	
	     NumItm = 0
	     LsWhile1=[lVolumen AND lHayStkMin AND lDiaCsm]
	     LsWhile2=[FchProCmp+DiaCsm<=GdFchFin]
	     DO WHILE EVAL(LsWhile1) AND EVAL(LsWhile2)
	        APPEN BLANK
	        REPLACE Nivel  WITH m.Nivel
	        REPLACE CodMat WITH LsCodMat
	        REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	        REPLACE FchCmp WITH FchProCmp
	        REPLACE VolPed WITH catg.volped
	        REPLACE NumCmp WITH 1
	        IF LfStkMIn>0
       	       XnDiaCsm = ROUND(DiaxMes*VolPed/LfStkMin,0)
	           REPLACE DiaCsm WITH IIF(XnDiaCsm>=9999,999999,XnDiaCsm)
	        ENDIF
	        REPLACE CsmDia WITH catg.volped
	        FchProCmp = FchCmp + DiaCsm
	       *IF FchProCmp+DiaCsm>GdFchFin
	       *   EXIT
	       *ENDIF
	        NumItm = NumItm + 1
	        ***m.TCsmMes = m.TCsmMes + CsmDia
	        m.TCmpMes = m.TCmpMes + VolPed
	        m.TNumCmp = m.TNumCmp + 1
	     ENDDO
	     LdFchCmp = FchCmp
	     LnDiaCsm = DiaCsm
	     LFCsmDia = CsmDia
	     IF NumItm>0
	        ** Ultimo Registro
	        APPEND BLANK
	        REPLACE Nivel  WITH m.Nivel
	        REPLACE CodMat WITH LsCodMat
	        REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     ENDIF
	     REPLACE FchCmp WITH FchProCmp
	     IF lVolumen AND lHayStkMin
	        REPLACE VolPed WITH catg.volped
	        LfVolPed = VolPed
	        REPLACE NumCmp WITH 1
	        IF GdFchFin>=FchCmp
	           REPLACE DiaCsm WITH TTOD(GdFchFin) - FchCmp
               REPLACE CsmDia WITH LfStkMin*DiaCsm/DiaxMes
	           IF DiaCsm>0
	              ***m.TCsmMes = m.TCsmMes + CsmDia
	           ENDIF
	           ** Averiguamos si faltan hacer compras **
	           m.TUltCmp = 0
	           CHkStkFin = m.TStkIni + m.TCmpMes - m.TCsmMes
               TfProCsm = ROUND(XtStkMin/XnMesPrm,2)
               IF TfProCsm>0
                  LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
               ELSE
                  LfFacCmp = -1
	           ENDIF
	           LnMeses = ROUND((CATG.TmpRep +CATG.StkSeg)/30,2)
	           Si_ComPra = [LFFacCmp#-1 AND LfFacCmp<LnMeses]
	           lPaso = .F.
  	           m.TUltCmp = 0
	           DO WHILE EVAL(Si_Compra)
	              m.TUltCmp = m.TUltCmp + VolPed
	              ChkStkFin = ChkStkFin + VolPed
	              lPaso = .T.
                  IF TfProCsm>0
                     LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
                  ELSE
                     LfFacCmp = 0
	              ENDIF
       	          m.TNumCmp = m.TNumCmp + 1
	           ENDDO
	           IF lPaso
	              REPLACE VolPed WITH m.TUltCmp
       	          REPLACE NumCmp WITH ROUND(m.TUltCmp/LfVolPed,0)
	           ELSE
	              REPLACE VolPed WITH CATG.VolPed
       	          m.TNumCmp = m.TNumCmp + 1
	           ENDIF
   	           REPLACE NumCmp WITH ROUND(VolPed/CATG.VolPed,0)
	           *****--------------------------------******
	           ** Antes **
	          *REPLACE DiaFin WITH LnDiaCsm - DiaCsm
	          *IF LnDiaCsm>0
	          *   REPLACE StkFin WITH catg.volped*DiaFin/LnDiaCsm
	          *ENDIF
               m.TCmpMes = m.TCmpMes + VolPed
	           *** ----------------------------------------------- ***
	           IF LlCmpAnt
	              m.TCmpMes=TfCmpAnt 
	           ENDIF
	           REPLACE StkFin WITH m.TStkIni + m.TCmpMes - m.TCsmMes
	           REPLACE DiaFin WITH ROUND(StkFin*DiaXMes/LfStkMin,0)
	           m.TStkFin = StkFin
	           *** ----------------------------------------------- ***
	        ELSE
	           m.TUltCmp = 0
	           CHkStkFin = m.TStkIni + m.TCmpMes - m.TCsmMes
               TfProCsm = ROUND(XtStkMin/XnMesPrm,2)
               IF TfProCsm>0
                  LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
               ELSE
                  LfFacCmp = -1
	           ENDIF
	           LnMeses = ROUND((CATG.TmpRep +CATG.StkSeg)/30,2)
	           Si_ComPra = [LFFacCmp#-1 AND LfFacCmp<LnMeses]
   	           lPaso = .F.
  	           m.TUltCmp = 0
	           DO WHILE EVAL(Si_Compra)
	              m.TUltCmp = m.TUltCmp + VolPed
	              ChkStkFin = ChkStkFin + VolPed
	              lPaso = .T.
                  IF TfProCsm>0
                     LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
                  ELSE
                     LfFacCmp = 0
	              ENDIF
       	          m.TNumCmp = m.TNumCmp + 1
                  m.TCmpMes = m.TCmpMes + VolPed
               ENDDO
               IF lPaso
	              APPEND BLANK
	              REPLACE Nivel WITH m.Nivel
	              REPLACE CodMat WITH LsCodMat
	              REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	              REPLACE FchCmp WITH LdFchCmpI
	              REPLACE VolPed WITH m.TUltCmp
       	          REPLACE NumCmp WITH ROUND(m.TUltCmp/LfVolPed,0)
               ENDIF
	           ***
	           IF LfStkMIn>0
          	      XnDiaCsm = ROUND(DiaxMes*VolPed/LfStkMin,0)
	              REPLACE DiaCsm WITH IIF(XnDiaCsm>=9999,999999,XnDiaCsm)
	           ENDIF
	           IF DiaCsm>0
	              REPLACE CsmDia WITH Catg.Volped
	           ENDIF
	           LdProCmp = FchCmp+DiaCsm
   	           IF LlCmpAnt
	              m.TCmpMes=TfCmpAnt 
	           ENDIF
	           m.tStkFin = m.TStkIni + m.TCmpMes - m.TCsmMes
	           APPEND BLANK
	           REPLACE  Nivel WITH m.Nivel
	           REPLACE CodMAt WITH LsCodMAt
	           REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	           REPLACE FchCmp WITH LdProCmp
	        ENDIF
	     ENDIF
	     **
	     LsMsgErr =[]
	     IF !Lvolumen
	        LsMsgErr=[No Vol.Ped. ]
	     ENDIF
	     IF !lHayStkMin
	        LsMsgErr=LsMsgErr +[No Stk.Min. ]
	     ENDIF
	     REPLACE Error WITH LsMsgErr
	     **
	     append blank
	     REPLACE Nivel  WITH m.Nivel
	     REPLACE CodMat WITH LsCodMat
	     REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     IF lReproceso
	        IF !lHayStkMin
	           m.TCsmMes = -1
	        ENDIF
	        IF !lVolumen
	           m.TCmpMes = -1
	        ENDIF
	        IF !lDiaCsm
	           IF !lDiaCsmA
	              m.TCmpMes = -2
	           ENDIF
	           IF !lDiaCsmB
	              m.TCsmMes = -2
	           ENDIF
	        ENDIF
	        DO GrbPrgAnual WITH m.Periodo,LsCodMat,m.Nivel
	        SELE TEMPO
	        ZAP
	        SELE CATG
	     ENDIF
     ENDFOR	
     SELE CATG
ENDSCAN
IF !lReproceso
	DO BROWS_PRGA 
    RETURN
ELSE
ENDIF
RETURN
*******************
PROCEDURE CmbAnoMes
*******************

DO F1_CAJA WITH 10, 52, "COMPRAS", 1,""
ACTIVATE WINDOW COMPRAS

UltTecla  = 0
GsProgram = PROGRAM()

** Control del periodo contable **
IF !USED("ANOS")
   SELECT 0
   USE CBDTANOS ALIAS ANOS
   IF ! USED()
      CLOSE DATA
      EXIT
   ENDIF
ENDIF
SELE ANOS
LOCATE FOR ! CIERRE
_ANO = PERIODO
_MES = MESCONT
IF RECCOUNT() > 1
   @ 01,10 SAY " A¤o de Proceso :" GET _Ano PICT "9999" VALID _PERIODO()
ELSE
   @ 01,10 SAY " A¤o de Proceso : "+TRANS(_Ano,"9999")
ENDIF
@ 02,10 SAY " Mes de Proceso :" GET _Mes PICT "@L ##" VALID _MES()

@ 07,17 GET m.Control PICTURE "@*HT \!\<Aceptar;\<Cancelar" DEFAULT 1;
            valid vControl(m.Control)
READ CYCLE

RELEASE WINDOW COMPRAS
IF m.Control = 1
   UltTecla = LASTKEY()
ENDIF
IF UltTecla = k_Esc
   RETURN .F.
ENDIF
*****************
FUNCTION vControl
*****************
PARAMETER opc
SHOW GETS
UltTecla = IIF(opc=1,LASTKEY(),K_Esc)
RETURN .T.
*******************
FUNCTION _PERIODO
*******************
LOCATE FOR PERIODO = _ANO
RETURN FOUND()
*************
FUNCTION _MES
*************
IF _MES < 0 .OR. _MES > 13
  sErr = "Invalido mes de Trabajo"
  DO F1MSGERR WITH sErr
  RETURN .F.
ENDIF
IF _Mes < 12
  GdFecha   = CTOD("01/"+STR(_Mes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
  GdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
GsFecha   = DTOC(GdFecha)
@ 02,31 SAY PADR(Mes(_Mes,1),10)
RETURN .T.
*******************
PROCEDURE AbrirDBFS
*******************
CLOSE DATA
**USE CMPCO_CG ORDER CO_C01 ALIAS CO_C IN 0
**IF !USED()
**   RETURN .f.
**ENDIF
**USE CMPDO_CG ORDER DO_C01 ALIAS DO_C IN 0
**IF !USED()
**   RETURN .f.
**ENDIF
*
**USE CMPCREQU IN 0 ORDER CREQ03 ALIAS CREQ
**IF ! USED()
**   CLOSE DATA
**   RETURN
**ENDIF
*
**USE ALMCTRAN ORDER CTRA01 ALIAS CTRA IN 0
**IF !USED()
**   RETURN .f.
**ENDIF
*
USE ALMTdivf ORDER DIVF01 ALIAS DIVF IN 0
IF !USED()
   RETURN .f.
ENDIF
*
USE ALMDTRAN ORDER DTRA01 ALIAS DTRA IN 0
IF !USED()
   RETURN .f.
ENDIF
*
USE ALMCFTRA ORDER CFTR01 ALIAS CFTR IN 0
IF !USED()
    RETURN .f.
ENDIF
*
USE ALMCATGE ORDER CATG01 ALIAS CATG IN 0
IF !USED()
   RETURN .f.
ENDIF
*
USE ALMCATAL ORDER CATA02 ALIAS CALM IN 0
IF !USED()
   RETURN .F.
ENDIF
*
SELE 0
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF !USED()
   RETURN .f.
ENDIF
*
SELE 0
USE ALMTALMA ORDER ALMA01 ALIAS ALMA
IF !USED()
   RETURN .f.
ENDIF

** Archivo temporal  **
ArcTmp = PATHUSER+SYS(3)
SELE 0
CREAT TABL &ArcTmp. ( Nivel  C(3),;
                      CodMat C(LEN(CATG.COdMat)),;
                      DesMat C(LEN(CATG.DesMat)),;
                      StkIni N(14,4),;
                      DiaIni N(6),;
                      Flag1  C(1),;
                      FchCmp D(8),;
                      VolPed N(14,4),;
                      NumCmp N(6),;
                      CsmDia N(14,4),;
                      DiaCsm N(6),;
                      StkFin N(14,4),;
                      DiaFin N(6),;
                      Error  C(30))

USE &ArcTmp. ALIAS TEMPO EXCLUSIVE
IF !USED()
   RETURN .F.
ENDIF
INDEX ON Nivel+Codmat TAG temp01
SELE 0
USE CmpPacin ORDER PACI01 ALIAS TOTAL
IF !USED()
   RETURN .F.
ENDIF
SET ORDER TO PACI01
RETURN .T.
******************
PROCEDURE IMPRIMIR
******************
LsSubTit = []
DO CASE
   CASE m.tipo = 1
        SELE TEMPO
   CASE m.Tipo = 2
        SELE Total
   CASE m.Tipo = 3
        SELE Total
        SET RELA TO GsClfDiv+LEFT(CodMat,GnLenDiv) INTO DIVF
ENDCASE
GO TOP
IF EOF()
   DO F1MSGERR WITH "Fin de archivo"
   CLOSE DATA
   RETURN
ENDIF
TstImp = []
sMensa = []
**---------- Impresi¢n ---------**
xFOR   = []
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
m.TipRepo=[]
DO CASE
   CASE m.Tipo = 1
        sNomRep = [CMPcpcxm]
   CASE m.Tipo = 2
        sNomRep = [CMPcpcxr]
   CASE m.Tipo = 3
        sNomRep = [CMPcpcan]
        XFOR = [NIVEL<>"D07"]
   CASE m.Tipo = 4
        m.TitRepo=[COMPRAS ANUALES VALORIZADAS POR INSUMO]
        IF m.SolFac
           m.TitRepo=[COMPRAS ANUALES SOLO FACTOR DE STOCK]
        ENDIF
        sNomRep = [Cmpcpcav]
        XFOR = [NIVEL<>"D07"]
   CASE m.Tipo = 5
        sNomRep = [Cmpcpcvf]
        XFOR = [NIVEL<>"D07"]
   CASE m.Tipo = 6
        sNomRep = [CmpcpcvI]
        XFOR = [NIVEL<>"D07"]
ENDCASE
DO F0print WITH "REPORTS"
CLOSE DATA
RETURN
*******************
PROCEDURE BROWS_PRG
*******************
PARAMETER lMostrar,m.Area
m.bTitulo = [PROGRAMA]
m.bDeta   = [PROGRAMA]
IF lMostrar
   m.bClave1 = []
   m.bClave2 = []
ELSE
   m.bClave1 = []
   m.bClave2 = []
ENDIF
sModulo = [PROGCMP]
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []
PRIVATE nX0,nX1,nY0,nY1
nX0 = 01
nY0 = 0
nX1 = 20
nY1 = 79
IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ENDIF

DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
*******************
PROCEDURE GenTempo3  && Generaci_n de temporal para programa anual
*******************
PRIVATE LfTotCsm
DIMENSION vCdMDos(1,2)
STORE [] TO vCdMDos
LsDesMat = [*** I N S U M O S ***]
nMesFin = 12
SELE 0
ArcTmp2= PATHUSER+SYS(3)
CREATE TABLE &ArcTmp2. FREE ( CodMat C(LEN(CATG.COdMAt)),;
                         Desmat C(LEN(CATG.DesMat)),;
                         Desmat2 C(LEN(CATG.DesMat)),;
                         Nivel  C(3), Glosa C(10),;
                         V01 N(14,4),V02 N(14,4),V03 N(14,4),V04 N(14,4),;
                         V05 N(14,4),V06 N(14,4),V07 N(14,4),V08 N(14,4),;
                         V09 N(14,4),V10 N(14,4),V11 N(14,4),V12 N(14,4),;
                         V13 N(14,4),V14 N(14,4),;
                         C01 C(10),C02 C(10),C03 C(10),C04 C(10),;
                         C05 C(10),C06 C(10),C07 C(10),C08 C(10),;
                         C09 C(10),C10 C(10),C11 C(10),C12 C(10),;
                         C13 C(10),C14 C(10),;
                         M01 c(1),M02 C(1),M03 C(1),M04 C(1),M05 C(1),M06 C(2),;
                         M07 c(1),M08 C(1),M09 C(1),M10 C(1),M11 C(1),M12 C(2))

USE &ArcTmp2. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF
INDEX ON CodMat+Nivel TAG TMP201
SET ORDER TO Tmp201
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
SELE TOTAL
SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")+m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE Periodo=LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") AND CodMat<=m.CodMatH
     STORE 0 TO XfTotLin1,XfTotLin2,XfTotLin3,XfTotLin4,XfTotlin5,XfTotLin6
     =SEEK(CodMat,[CATG])
     WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk NOWAIT
     LfTotCsM=0
     LfProCsm=0
     FOR NM = 1 to 13
         WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+MES(NM,1) NOWAIT
         LsMes=TRAN(NM,[@L ##])
   		 StkMes = [SI]+LsMes
		 CmpMes = [CP]+LsMes
		 CsmMes = [CS]+LsMes
		 StkFin = [SF]+LsMes
		 SisMes = [SV]+LsMes
		 Cadena = [C]+LsMes
		 Valor  = [V]+LsMes
		 Marca  = [M]+LsMes
         LfProCsm=0
         NK=0
         DO WHILE NK<XnMesPrm AND NM+NK<=12 AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         DO WHILE NK<XnMesPrm AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK-12,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         LfProCsm = ROUND(LfProCsm/XnMesPrm,2)
	     SELE TMP2
	     ** Saldo inicial **
	     SEEK TOTAL.CodMat+[D01]
	     IF !FOUND()
            APPEND BLANK
    	    REPLACE CodMat   WITH TOTAL.CodMat
    	    REPLACE Nivel    WITH [D01]
	     ENDIF
	     REPLACE DesMat   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [STK.INI.]
	     DO CASE
	        CASE NM<=12
 	             REPLACE &Valor.  WITH TOTAL.&StkMes.
                 XfTotLin1 = XfTotLin1 + &Valor.
 	        CASE NM=13
       	         REPLACE &Valor.  WITH 0       &&XfTotLin1
       	    CASE NM=14
	     ENDCASE
	     ** Compras del mes **
   	     SEEK TOTAL.CodMat+[D02]
	     IF !FOUND()
		     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
	  	     REPLACE NiVel    WITH [D02]
         ENDIF
	   **REPLACE DesMat   WITH TOTAL.DesMat
	   	 REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [COMPRAS]
	     DO CASE
	        CASE NM<=12
	             DO CASE
     	            CASE TOTAL.&CmpMes.>=0
     	               REPLACE &Valor.  WITH TOTAL.&CmpMes.
     	               REPLACE &Marca.  WITH IIF(!EMPTY(TOTAL.&Marca.),[*],[])
    	               XfTotLin2 = XfTotLin2 + &Valor.
    	            CASE TOTAL.&CmpMes.=-1
    	               REPLACE &Cadena. WITH [C]
    	            CASE TOTAL.&CmpMes.=-2
    	               REPLACE &Cadena. WITH [D]
    	         ENDCASE
	        CASE NM=13
    	         REPLACE &Valor.  WITH XfTotLin2
    	    CASE NM=14
	     ENDCASE
	     ** Consumos del mes **
   	     SEEK TOTAL.CodMat+[D03]
	     IF !FOUND()
     	     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
		     REPLACE NiVel    WITH [D03]
	     ENDIF
	     REPLACE DesMat   WITH [Prom.Csmo.: ]+TRAN(LfProCsm,[999,999.99])
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [CONSUMO]
	     DO CASE
 	        CASE NM<=12
 	             DO CASE
                    CASE TOTAL.&CsmMes.>=0
        	             REPLACE &Valor.  WITH TOTAL.&CsmMes.
    	                 XfTotLin3 = XfTotLin3 + &Valor.
    	            CASE TOTAL.&CsmMes.=-1
    	                 REPLACE &Cadena. WITH [A]
       	            CASE TOTAL.&CsmMes.=-2
    	                 REPLACE &Cadena. WITH [B]
    	         ENDCASE
	        CASE NM=13
         	     REPLACE &Valor.  WITH XfTotLin3
         	CASE NM=14
	     ENDCASE
	     ** Otros ingresos y salidas **
   	     SEEK TOTAL.CodMat+[D04]
	     IF !FOUND()
     	     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
		     REPLACE NiVel    WITH [D04]
	     ENDIF
	   **REPLACE DesMat   WITH TOTAL.DesMat
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [OTROS]
	     DO CASE
 	        CASE NM<=12
	             REPLACE &Valor.  WITH TOTAL.&SisMes.
    	         XfTotLin4 = XfTotLin4 + &Valor.
	        CASE NM=13
         	     REPLACE &Valor.  WITH XfTotLin4
         	CASE NM=14
	     ENDCASE
	     ** Stock Final      **
   	     SEEK TOTAL.CodMat+[D05]
	     IF !FOUND()
	        APPEND BLANK
	        REPLACE CodMat   WITH TOTAL.CodMat
    	    REPLACE NiVel    WITH [D05]
	     ENDIF
	   **REPLACE DesMat   WITH TOTAL.DesMat
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [STK.FIN.]
	     DO CASE
   	        CASE NM<=12
	             REPLACE &Valor.  WITH TOTAL.&StkFin.
	             XfTotLin5 = XfTotLin5 + &Valor.
	        CASE NM=13
	             REPLACE &Valor.  WITH 0 && XfTotLin5
	     ENDCASE
	     *** Factor de Alerta de compra ***
   	     SEEK TOTAL.CodMat+[D06]
	     IF !FOUND()
	        APPEND BLANK
	        REPLACE CodMat   WITH TOTAL.CodMat
    	    REPLACE NiVel    WITH [D06]
	     ENDIF
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa WITH [FACTOR]
   	     IF NM<=12
	        REPLACE &Valor.  WITH IIF(LfProCsm#0,ROUND(TOTAL.&StkFin./LfProCsm,1),0)
	        REPLACE &Cadena. WITH PADR(ALLTRIM(STR(ROUND(TOTAL.&StkFin./LfProCsm,1),8,2)),10)
	      **XfTotLin6 = XfTotLin6 + &Valor.
	     ELSE
	      **REPLACE &Valor.  WITH XfTotLin6
	     ENDIF
	     IF EMPTY(DesMat)
    	    REPLACE DesMat WITH [ F1:]+TRAN(TOTAL.FacRf1,'99.99')+[ ]+[ F2:]+TRAN(Total.FacRf2,'99.99')
   	     ENDIF
	     ** Linea de separaci_n **
   	     SEEK TOTAL.CodMat+[D07]
	     IF !FOUND()
	         APPEND BLANK
    	     REPLACE CodMat   WITH TOTAL.CodMat
    	     REPLACE NiVel    WITH [D07]
	     ENDIF
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat   WITH REPLI("=",LEN(DesMat))
	     REPLACE &Cadena. WITH REPLI("=",LEN(&Cadena.))
   	     REPLACE Glosa    WITH REPLI("=",LEN(Glosa))
     ENDFOR
     SELE TOTAL
ENDSCAN
SELE TMP2
USE
SELE TOTAL
USE 
USE &ArcTmp2. IN 0 ORDER TMP201 ALIAS TOTAL EXCLU
IF !USED()
    RETURN .F.
ENDIF
GO TOP
DO BROWS_PRGA &&WITH .F.,[TOTAL]
RETURN
********************
PROCEDURE BROWS_PRGA
********************
*PARAMETER lMostrar,m.Area
*XskeyF4    = ON("KEY","F4")
*m.prgPost = []
DO CASE
   CASE m.Tipo=1
        m.bTitBrow=[PROGRAMA DE COMPRAS DETALLADO ]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)
		sModulo = [PROGCMP]   
   CASE m.Tipo=3
        m.bTitBrow=[PROGRAMA ANUAL DE COMPRA DE INSUMOS ]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)
        sModulo =[PRG_NEW]
        m.prgPost = [cpcxm_grb]
   CASE m.Tipo=4
        m.bTitBrow=[COMPRAS VALORIZADAS POR INSUMO ]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)
        sModulo =[PROGANUAL]
        m.prgPost = [cpcxm_grb]
   CASE m.Tipo=5
        m.bTitBrow=[COMPRAS VALORIZADAS POR FAMILIA ]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)+IIF(m.ConIgv,[ Con I.G.V.],[ Sin I.G.V.])
        sModulo =[PROGANUAL]
   CASE m.Tipo=6
        m.bTitBrow=[COMPRAS VALORIZADAS POR INSUMO Y % ]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)+IIF(m.ConIgv,[ Con I.G.V.],[ Sin I.G.V.])
        sModulo =[PROGANUAL]
   CASE m.Tipo=7
        m.bTitBrow=[ESTADO DE PROGRAMA DE COMPRAS]+MES(nMesIni,2)+[ ]+LEFT(GsAnoMes,4)+IIF(m.ConIgv,[ Con I.G.V.],[ Sin I.G.V.])
        sModulo =[PROGANUAL]
ENDCASE
*m.bTitulo = [PCI_ANUAL]
*m.bDeta   = [PCI_ANUAL]
*IF lMostrar
*   m.bClave1 = []
*   m.bClave2 = []
*ELSE
*   m.bClave1 = []
*   m.bClave2 = []
*ENDIF

**sModulo =[PROGANUAL]
*m.bFiltro = [.T.]
*m.bCampos = sCmp&&bDef_Cmp(sModulo)
*m.bBorde  = [DOUBLE]
*m.Area_Sel= m.Area
*m.prgBusca= []
*m.prgPrep = []
*PRIVATE nX0,nX1,nY0,nY1
*nX0 = 01
*nY0 = 0
*nX1 = 20
*nY1 = 79
*IF lMostrar
*   lModi_Reg = .F.
*   lAdic_Reg = .F.
*   lBorr_Reg = .F.
*ELSE
*   lModi_Reg = .T.
*   lAdic_Reg = .F.
*   lBorr_Reg = .F.
*ENDIF
sPic = [@Z 9999999]
sPicT= [@Z 99999999]
sPicFac= LEFT(DesMat,14)+[99.99]
store 0 to XV01,XV02,XV03,XV04,XV05,XV06,XV07,XV08,XV09,XV10,XV11,XV12,XfFacRf2A
*DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
DO form cmp_cmpcpcxmbrowse
*ON KEY LABEL F4 &XsKEYF4.
RETURN
*************
FUNCTION wCmp
*************
PARAMETER NomBCampo
IF VAL(RIGHT(UPPER(NombCampo),2))<_Mes
   RETURN .F.
ENDIF
IF nivel=[D02]
   XCmpEva=[X]+RIGHT(UPPER(NomBCampo),3)
   &XCmpEva = &NomBCampo.
   RETURN .T.
ENDIF
RETURN .F.
*************
FUNCTION vCmp
*************
PARAMETER NombCampo
SET STEP ON 
CmpEva=RIGHT(UPPER(NombCampo),3)
IF &CmpEva.<0
   RETURN .F.
ENDIF
XCmpEva=[X]+RIGHT(UPPER(NombCampo),3)
XnMesAct=VAL(RIGHT(CmpEva,2))
CmpEvaC =[C]+tran(XnMesAct,[@L ##])
XnReg_Act=RECNO()
** Compras
LfSdoFin=&CmpEva.
LsCodMat=CodMat
LfDifCmp=&XCmpEva.-&CmpEva.
** Saldo Inicial
SKIP -1
LfSdoFin=LfSdoFin + &CmpEva.
** Consumos
SKIP 2
LfSdoFin=LfSdoFin - &CmpEva.
** Otros Ingresos y salidas
SKIP 1
LfSdoFin=LfSdoFin + &CmpEva.
** Saldo Final
SKIP 1
REPLACE &CmpEva. WITH LfSdoFin
SEEK CodMat+[D03] && Promedio de consumo
TsProCsm1 = SUBSTR(ALLT(DESMAT),13,3)
TsProCsm2 = SUBSTR(ALLT(DESMAT),17,6)
TfProCsm = 0
NK=0
DO WHILE NK<XnMesPrm AND XnMesAct+NK<=12
   LsCmpEva = [V]+TRAN(XnMesAct+NK,[@L ##])
   TfProCsm = TfProCsm + &LsCmpEva.
   NK=NK + 1
ENDDO
DO WHILE NK<XnMesPrm
   LsCmpEva = [V]+TRAN(XnMesAct+NK-12,[@L ##])
   TfProCsm = TfProCsm + &LsCmpEva.
   NK=NK + 1
ENDDO
TfProCsm = ROUND(TfProCsm/XnMesPrm,2)
SEEK CodMat+[D06]
REPLACE &CmpEva.  WITH IIF(TfProCsm#0,ROUND(LfSdoFin/TfProCsm,1),0)
REPLACE &CmpEvaC. WITH PADR(ALLTRIM(STR(&CmpEva.,8,2)),10)
*** Recalculando los meses restantes
XnMesAct = XnMesAct +1	
LfSdoFin = 0
DO WHILE XnMesAct<=13
   CmpEva = [V]+TRAN(XnMesAct,[@L ##])
   CmpEvaC= [C]+TRAN(XnMesAct,[@L ##])
   IF XnMesAct#13
      SEEK LsCodMat+[D01]
      REPLACE &CmpEva. WITH &CmpEva. + IIF(LfDifCmp<0,ABS(LfDifCmp),-ABS(LfDifCmp))
   ENDIF
   IF XnMesAct=13
      SEEK LsCodMat+[D02]
      REPLACE &CmpEva. WITH &CmpEva. + IIF(LfDifCmp<0,ABS(LfDifCmp),-ABS(LfDifCmp))
   ENDIF
   IF XnMesAct#13
      SEEK LsCodMat+[D05]
      REPLACE &CmpEva. WITH &CmpEva. + IIF(LfDifCmp<0,ABS(LfDifCmp),-ABS(LfDifCmp))
      WfStkFin = &CmpEva.
      SEEK CodMat+[D06]
      REPLACE &CmpEva.  WITH IIF(TfProCsm#0,ROUND(WfStkFin/TfProCsm,1),0)
      REPLACE &CmpEvaC. WITH PADR(ALLTRIM(STR(&CmpEva.,8,2)),10)
   ENDIF
   XnMesAct = XnMesAct +1	
ENDDO
GO XnReg_Act
IF EMPTY(vCdMDos(1,1))
   vCdMDos(1,1)=CodMat
   vCdMDos(1,2)=TRAN(XnMesAct,[@L ##])
ENDIF
lAdi_Codigo=.T.
FOR CDM=1 TO ALEN(vCdMDos,1)
    IF vCdMDos(CDM,1)=CodMat
       lAdi_Codigo=.F.
       EXIT
    ENDIF
ENDFOR
IF lAdi_Codigo
   DIMENSION vCdMDos(ALEN(vCdMDos,1)+1,2)
   vCdMdos(ALEN(vCdmDos,1),1)=CodMat
   vCdMDos(ALEN(vCdmDos,1),2)=TRAN(XnMesAct,[@L ##])
ENDIF
LsMarca=[M]+TRAN(VAL(RIGHT(UPPER(NombCampo),2)),[@L ##])
replace &LsMarca. WITH [*]
RETURN .T.
*************
FUNCTION fPic
*************
RETURN IIF(GLosa=[===],REPLI([=],9),IIF(GloSa=[FAC],[999.99],sPic))
*******************
PROCEDURE cpcxm_grb
*******************
IF !USED([PACI])
   USE CmpPacin ORDER PACI01 ALIAS PACI IN 0
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF m.Tipo#3
   RETURN
ENDIF
IF EMPTY(vCdMDos)
   RETURN
ENDIF
IF LASTKEY()= K_ESC
   nRep=F1_ALERT([Desea grabar los cambios?],[PROCESO])
   IF nRep=2
      RETURN .F.
   ENDIF
ENDIF
IF INLIST(LASTKEY(),K_F10,K_CTRLW)
   nRep=F1_ALERT([Esta seguro de los cambios?],[SI_O_NO])
   IF nRep=2
      RETURN .F.
   ENDIF
ENDIF
SELE TOTAL
FOR CDM=1 TO ALEN(vcdmdos,1)
    SEEK vCdmdos(CDM,1)
    SELE PACI
    SEEK GsAnoMes+vCdmdos(CDM,1)
    IF !FOUND()
        LOOP
    ENDIF
    DO WHILE !RLOCK()
    ENDDO
    FOR QueMes=_Mes TO 12
        LsMes=TRAN(QueMes,[@L ##])
        CmpSI =[SI]+LsMes
        CMPCp =[CP]+LsMes
        CmpSF =[SF]+LsMes
        Marca =[M]+LsMes
        ValTmp=[V]+LsMes
        ** Saldo inicial **
        IF QueMes>_Mes
           =SEEK(vCdMDos(CDM,1)+[D01],[TOTAL])
           REPLACE PACI.&CmpSI. WITH TOTAL.&ValTmp.
        ENDIF
        ** Compras       **
        =SEEK(vCdMDos(CDM,1)+[D02],[TOTAL])
        REPLACE PACI.&CmpCP. WITH TOTAL.&ValTmp.
        IF !EMPTY(TOTAL.&Marca.)
           REPLACE PACI.&Marca. WITH [2]    && Marca de compras     
        ENDIF   
        ** Saldo Final   **
        =SEEK(vCdMDos(CDM,1)+[D05],[TOTAL])
        REPLACE PACI.&CmpSF. WITH TOTAL.&ValTmp.
    ENDFOR
    ** Grabamos factor 2 **
    =SEEK(vCdMDos(CDM,1)+[D06],[TOTAL])
    LsRf2 =SUBSTR(TOTAL.DESMAT,15,5)
    nPosPto  =AT([.],LsRf2)
    LsRf2A =ALLT(SUBS(LsRf2,1,nPosPto-1))
    LsRf2B =ALLT(SUBS(LsRf2,nPosPto+1,2))
    REPLACE PACI.FacRf2 WITH VAL(LsRf2A+[.]+LsRf2B)
    UNLOCK
    SELE TOTAL
ENDFOR
RETURN .T.
*************
FUNCTION wFR2
*************
PARAMETER NomBCampo
IF Glosa=[FAC]
   LsRf2 =SUBSTR(DESMAT,15,5)
   nPosPto  =AT([.],LsRf2)
   LsRf2A =ALLT(SUBS(LsRf2,1,nPosPto-1))
   LsRf2B =ALLT(SUBS(LsRf2,nPosPto+1,2))
   XfFacRf2A=VAL(LsRf2A+[.]+LsRf2B)
   RETURN .T.
ENDIF
RETURN .F.
*************
FUNCTION vFR2
*************
PARAMETER NombCampo
LsRf2 =SUBSTR(DESMAT,15,5)
nPosPto  =AT([.],LsRf2)
LsRf2A =ALLT(SUBS(LsRf2,1,nPosPto-1))
LsRf2B =ALLT(SUBS(LsRf2,nPosPto+1,2))
LfFacRf2 =VAL(LsRf2A+[.]+LsRf2B)
LfFacRf1 =VAL(SUBSTR(ALLTRIM(DESMAT),5,5))

IF LfFacRf2=XfFacRf2A
   WAIT WINDOW [No cambio] NOWAIT
   RETURN .T.
ENDIF
=SEEK(CodMat,[CATG])
SEEK COdMat+[D03]     && Pomedio de consumo
nPosIni=AT([,],SUBSTR(ALLTRIM(DESMAT),13))
TsProCsm1 = SUBSTR(ALLT(DESMAT),13,3)
TsProCsm2 = SUBSTR(ALLT(DESMAT),17,6)
TfProCsm  = 0
LnMeses  = LfFacRf2   && Nuevo factor de referencia
lok_k=.F.
FOR QueMes = _MES TO 12
    CmpEva = [V]+TRAN(QueMes,[@L ##])
    ** Primero evaluamos que es lo que vamos a grabar **
    SEEK CodMat+[D02]         && Compra del mes
    LfCmpMes = &CmpEva.
    SEEK CodMat+[D03]         && Consumo del mes
    LfCsmMes = &CmpEva.
    TfProCsm=0
    NK=0
    DO WHILE NK<XnMesPrm AND QueMes+NK<=12
       LsCmpEva = [V]+TRAN(QueMes+NK,[@L ##])
       TfProCsm = TfProCsm + &LsCmpEva.
       NK=NK + 1
    ENDDO
    DO WHILE NK<XnMesPrm
       LsCmpEva = [V]+TRAN(QueMes+NK-12,[@L ##])
       TfProCsm = TfProCsm + &LsCmpEva.
       NK=NK + 1
    ENDDO
    TfProCsm = ROUND(TfProCsm/XnMesPrm,2)
    SEEK CodMat+[D06]         && Factor del mes
    LfFacCmp = &CmpEva.
	Si_ComPra1= [LFFacCmp#0 AND LfFacCmp<LnMeses]
	lPaso1 = .F.
	lPaso2 = .F.
  	m.TUltCmp = 0
  	m.TNumCmp = 0
  	**
    SEEK CodMat+[D05]   && Stock final del mes
  	ChkStkFin = &CmpEva.
	DO WHILE EVAL(Si_Compra1)
	   m.TUltCmp = m.TUltCmp + CATG.VolPed
	   ChkStkFin = ChkStkFin + CATG.VolPed
	   lPaso1 = .T.
       IF TfProCsm>0
          LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
       ELSE
          LfFacCmp = 0
       ENDIF
       m.TNumCmp = m.TNumCmp + 1
    ENDDO
    LfDifCmp=m.TUltCmp
    Si_Compra2 = [LFFacCmp#0 AND LfFacCmp>LnMeses AND !lPaso1]
	DO WHILE EVAL(Si_Compra2)
	   m.TUltCmp = m.TUltCmp + CATG.VolPed
	   ChkStkFin = ChkStkFin - CATG.VolPed
	   lPaso2 = .T.
       IF TfProCsm>0
          LfFacCmp = ROUND(ChkStkFin/TfProCsm,4)
       ELSE
          LfFacCmp = 0
       ENDIF
       m.TNumCmp = m.TNumCmp + 1
    ENDDO
    LfDifCmp = m.TUltCmp
    IF !(lPaso1 OR lPaso2)
       LOOP
    ENDIF
    ** Ahora grabamos **
    FOR MesGrb = QueMes TO 12
        CmpGrb = [V]+TRAN(MesGrb,[@L ##])
        CmpGrbC = [C]+TRAN(MesGrb,[@L ##])
        Marca   = [M]+TRAN(MesGrb,[@L ##])
        IF MesGrb=_Mes
           SEEK CodMat+[D01]
           VfStkFin = &CmpGrb.
        ELSE
           SEEK CodMat+[D05]
           CmpGrbA = [V]+TRAN(MesGrb-1,[@L ##])
           VfStkFin = &CmpGrbA.
        ENDIF
	    IF !INLIST(MesGrb,_Mes,13)
	       lOK_K=.t.
	       SEEK CodMat+[D01]
	     **REPLACE &CmpGrb. WITH &CmpGrb. + IIF(LPaso1,ABS(LfDifCmp),-ABS(LfDifCmp))
	       REPLACE &CmpGrb. WITH VfStkFin
	    ENDIF
	    IF MesGrb=13 OR MesGrb=QueMes
	       lOK_K=.t.
	       SEEK CodMat+[D02]
	       LfImpCmp=0
	       IF lPaso1
	          LfImpCmp = ABS(LfDifCmp)
	       ELSE
	          LfImpCmp = IIF(&CmpGrb - ABS(LfDifCmp)>=0,-ABS(LfDifCmp),-&CmpGrb)
	       ENDIF
	       REPLACE &CmpGrb. WITH &CmpGrb. + LfImpCmp
	       REPLACE &Marca.  WITH [*]
	    ENDIF
	    SEEK CodMat+[D02]
        VfStkFin = VfStkFin + &CmpGrb.
	    IF MesGrb#13
	       lOK_K=.t.
	       SEEK CodMat+[D03]
	       VfStkFin = VfStkFin - &CmpGrb.
	       SEEK CodMat+[D05]
	     **REPLACE &CmpGrb. WITH &CmpGrb. + IIF(Lpaso1,ABS(LfDifCmp),-ABS(LfDifCmp))
	       REPLACE &CmpGrb. WITH VfStkFin
	       WfStkFin = &CmpGrb.
	       SEEK CodMat+[D06]
	       REPLACE &CmpGrb.  WITH IIF(TfProCsm#0,ROUND(WfStkFin/TfProCsm,1),0)
	       REPLACE &CmpGrbC. WITH PADR(ALLTRIM(STR(&CmpGrb.,8,2)),10)
	    ENDIF
    ENDFOR
ENDFOR
**
IF !lOK_K
   RETURN .T.
ENDIF
IF EMPTY(vCdMDos(1,1))
   vCdMDos(1,1)=CodMat
ENDIF
lAdi_Codigo=.T.
FOR CDM=1 TO ALEN(vCdMDos,1)
    IF vCdMDos(CDM,1)=CodMat
       lAdi_Codigo=.F.
       EXIT
    ENDIF
ENDFOR
IF lAdi_Codigo
   DIMENSION vCdMDos(ALEN(vCdMDos,1)+1,2)
   vCdMdos(ALEN(vCdmDos,1),1)=CodMat
ENDIF
WAIT WINDOW [Si cambio] NOWAIT
RETURN .T.
*******************
PROCEDURE CmbFacRf2
*******************
SEEK TOTAL.CodMat+[D06]
LfFacRf2 =VAL(RIGHT(ALLTRIM(DESMAT),4))



RETURN
**************
FUNCTION fPicF
**************
RETURN IIF(Glosa#[FAC],[],LEFT(Desmat,14)+[99.99])
******************
PROCEDURE xSuspend
******************
SUSPEN
*********************
PROCEDURE GrbPrgAnual
*********************
PARAMETER xPeriodo,xCodMat,xNivel
m.AreaAct= ALIAS()
SELE TOTAL
SEEK xPeriodo+xCodMat+xNivel
IF !FOUND()
   APPEND BLANK
   REPLACE CodMat  WITH xCodMat
   REPLACE Periodo WITH xPeriodo
   REPLACE Nivel   WITH xNivel
   REPLACE DesMat  WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
ENDIF
LsMes=TRAN(MesActual,[@L ##])
StkMes = [SI]+LsMes
CmpMes = [CP]+LsMes
CsmMes = [CS]+LsMes
StkFin = [SF]+LsMes
StkVar = [SV]+LsMes
NroCmp = [NC]+LsMes
REPLACE &StkMes. WITH m.TStkIni
REPLACE &CmpMes. WITH m.TCmpMes
REPLACE &CsmMes. WITH m.TCsmMes
REPLACE &StkFin. WITH m.TStkFin
REPLACE &NroCmp. WITH m.TNumCmp
**REPLACE &StkVar. WITH m.TStkVar
IF MesActual=nMesfin
   REPLACE FacRf1 WITH ROUND((CATG.TmpRep +CATG.StkSeg)/30,2)
ENDIF
IF !GrbMesesAnt
	FOR L=1 TO nMesIni - 1
        FchStkIni=cTOd([01/]+TRAN(L,[@L ##])+[/]+tran(_ANO,[9999]))-1
	    DO CapValMesAnt
	ENDFOR
	GrbMesesAnt=.T.
ENDIF
SELE (m.AreaAct)
RETURN
**********************
PROCEDURE CapValMesAnt
**********************
PRIVATE LfStkIni,m.StkIni,m.TotCmp,m.TotCsm,m.StkFin,K,KK,m.RegAct
m.ParaAqui=.T.
** Ponemos todo en cero
SI = [SI]+TRAN(L,[@L ##])
CP = [CP]+TRAN(L,[@L ##])
CS = [CS]+TRAN(L,[@L ##])
SF = [SF]+TRAN(L,[@L ##])
SV = [SV]+TRAN(L,[@L ##])
NC = [NC]+TRAN(L,[@L ##])
MR = [M]+TRAN(L,[@L ##])
REPLACE (SI) WITH 0
REPLACE (CP) WITH 0
REPLACE (CS) WITH 0
REPLACE (SF) WITH 0
REPLACE (SV) WITH 0
REPLACE (NC) WITH 0

m.RegAct=RECNO()
** STOCK INICIAL **
m.StkIni = 0
FOR K=1 TO nSedes
    LfStkIni=0
    SELE CALM
    SEEK TOTAL.CodMat
    SCAN WHILE CodMat=TOTAL.CodMat FOR ALMA.CodSed=vSedes(K,1)
         LfStkIni = LfStkIni + GOCFGALM.CapStkAlm(SubAlm,CodMat,FchStkIni)
    ENDSCAN
    m.StkIni=m.StkIni + LfStkIni
ENDFOR
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.StkIni = EVAL(SI)
ENDIF
** COMPRAS       **
PRIVATE LsPeriod,LfCanDes,m.OrdenAct
LsPeriod = STR(_ANO,4,0)+TRAN(L,[@L ##])
DIMENSION aPidPco(2)
STORE [] TO aPidPco
SELE CFTR
SET FILTER TO PIDPCO
NumEle = 0
SCAN FOR INLIST(CODMOV,[001],[003])
    NumEle = NumEle + 1
    IF NumEle>ALEN(aPidPco)
       DIMENSION aPidPco(NumEle+5)
    ENDIF
    aPidPco(NumEle) =TipMov+CodMov
ENDSCAN
DIMENSION aPidPco(NumEle)
SET FILTER TO
SELE DTRA
m.OrdenAct = ORDER()
SET ORDER TO DTRA06
m.TotCmp = 0
FOR kk= 1 TO ALEN(aPidPco)
    xLlave = aPidPco(kk)+TOTAL.CodMat+LsPeriod
    SEEK xLlave
    SCAN WHILE TipMov+CodMov+CodMat+DTOS(FchDoc)=xLLave
         m.TotCmp = m.TotCmp + IIF(Factor>0,FacTor*CanDes,CanDes)
    ENDSCAN
ENDFOR
SET ORDER TO (m.OrdenAct)
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.TotCmp = EVAL(CP)
ENDIF
** CONSUMOS      **
IF !USED([ESTA])
	SELE 0
	USE ALMESTCM ORDER ESTA03 ALIAS ESTA
	IF !USED()
	   RETURN .F.
	ENDIF
ENDIF
STORE 0 TO m.CanSal,m.CanIng,m.TotCsm
SELE ESTA
SEEK GaClfDiv(1)+Total.CodMat+LsPeriod
SCAN WHILE CodMat=Total.CodMat AND ClfDiv=GaClfDiv(1) AND Periodo=LsPeriod
     m.CanSal = m.CanSal + CanSal
     m.CanIng = m.CanIng + CanIng
ENDSCAN
m.TotCsm=m.CanSal - m.CanIng
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.TotCsm = EVAL(CS)
ENDIF
** STOCK FINAL **
PRIVATE LfStkFin,m.StkFin,F
FchStkFin = CTOD([01/]+TRAN(L+1,[@L ##])+[/]+STR(_ANO,4,0))-1
m.StkFin = 0
FOR F=1 TO nSedes
    LfStkFin=0
    SELE CALM
    SEEK TOTAL.CodMat
    SCAN WHILE CodMat=TOTAL.CodMat FOR ALMA.CodSed=vSedes(F,1)
         LfStkFin = LfStkFin + GOCFGALM.CapStkAlm(SubAlm,CodMat,FchStkFin)
    ENDSCAN
    m.StkFin = m.StkFin + LfStkFin
ENDFOR
m.StkVar = m.StkFin - m.StkIni - m.TotCmp + m.TotCsm
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.StkFin = EVAL(SF)
	m.StkVar = 0
ENDIF
SELE TOTAL
IF RECNO()<>m.RegAct
	GO m.RegAct
ENDIF
REPLACE (SI) WITH m.StkIni
REPLACE (CP) WITH m.TotCmp
REPLACE (CS) WITH m.TotCsm
REPLACE (SF) WITH m.StkFin
REPLACE (SV) WITH m.StkVar
REPLACE (MR) WITH [ ]
RETURN
***********************
PROCEDURE CapValAAMMAnt
***********************
PRIVATE LfStkIni,m.StkIni,m.TotCmp,m.TotCsm,m.StkFin,K,KK,m.RegAct
m.Reg_PerAct=RECNO()
LsCodMat_X=CodMat
LsAAAAMM_A=STR(_ANO-1,4,0)+TRAN(12,[@L ##])+LsCodMat_X
IF !(FOUND() AND CodMat==LsCodMAt_X AND Periodo=LsAAAAMM)
	RETURN 
ENDIF
m.ParaAqui=.T.
** Ponemos todo en cero
SI = [SI]+TRAN(L,[@L ##])
CP = [CP]+TRAN(L,[@L ##])
CS = [CS]+TRAN(L,[@L ##])
SF = [SF]+TRAN(L,[@L ##])
SV = [SV]+TRAN(L,[@L ##])
NC = [NC]+TRAN(L,[@L ##])
MR = [M]+TRAN(L,[@L ##])
**
REPLACE (SI) WITH 0
REPLACE (CP) WITH 0
REPLACE (CS) WITH 0
REPLACE (SF) WITH 0
REPLACE (SV) WITH 0
REPLACE (NC) WITH 0
**
m.RegAct=RECNO()
** STOCK INICIAL **
m.StkIni = 0
FOR K=1 TO nSedes
    LfStkIni=0
    SELE CALM
    SEEK TOTAL.CodMat
    SCAN WHILE CodMat=TOTAL.CodMat FOR ALMA.CodSed=vSedes(K,1)
         LfStkIni = LfStkIni + GOCFGALM.CapStkAlm(SubAlm,CodMat,FchStkIni)
    ENDSCAN
    m.StkIni=m.StkIni + LfStkIni
ENDFOR
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.StkIni = EVAL(SI)
ENDIF
** COMPRAS       **
PRIVATE LsPeriod,LfCanDes,m.OrdenAct
LsPeriod = STR(_ANO,4,0)+TRAN(L,[@L ##])
DIMENSION aPidPco(2)
STORE [] TO aPidPco
SELE CFTR
SET FILTER TO PIDPCO
NumEle = 0
SCAN FOR INLIST(CODMOV,[001],[003])
    NumEle = NumEle + 1
    IF NumEle>ALEN(aPidPco)
       DIMENSION aPidPco(NumEle+5)
    ENDIF
    aPidPco(NumEle) =TipMov+CodMov
ENDSCAN
DIMENSION aPidPco(NumEle)
SET FILTER TO
SELE DTRA
m.OrdenAct = ORDER()
SET ORDER TO DTRA06
m.TotCmp = 0
FOR kk= 1 TO ALEN(aPidPco)
    xLlave = aPidPco(kk)+TOTAL.CodMat+LsPeriod
    SEEK xLlave
    SCAN WHILE TipMov+CodMov+CodMat+DTOS(FchDoc)=xLLave
         m.TotCmp = m.TotCmp + IIF(Factor>0,FacTor*CanDes,CanDes)
    ENDSCAN
ENDFOR
SET ORDER TO (m.OrdenAct)
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.TotCmp = EVAL(CP)
ENDIF
** CONSUMOS      **
IF !USED([ESTA])
	SELE 0
	USE ALMESTCM ORDER ESTA03 ALIAS ESTA
	IF !USED()
	   RETURN .F.
	ENDIF
ENDIF
STORE 0 TO m.CanSal,m.CanIng,m.TotCsm
SELE ESTA
SEEK GaClfDiv(1)+Total.CodMat+LsPeriod
SCAN WHILE CodMat=Total.CodMat AND ClfDiv=GaClfDiv(1) AND Periodo=LsPeriod
     m.CanSal = m.CanSal + CanSal
     m.CanIng = m.CanIng + CanIng
ENDSCAN
m.TotCsm=m.CanSal - m.CanIng
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.TotCsm = EVAL(CS)
ENDIF
** STOCK FINAL **
PRIVATE LfStkFin,m.StkFin,F
FchStkFin = CTOD([01/]+TRAN(L+1,[@L ##])+[/]+STR(_ANO,4,0))-1
m.StkFin = 0
FOR F=1 TO nSedes
    LfStkFin=0
    SELE CALM
    SEEK TOTAL.CodMat
    SCAN WHILE CodMat=TOTAL.CodMat FOR ALMA.CodSed=vSedes(F,1)
         LfStkFin = LfStkFin + GOCFGALM.CapStkAlm(SubAlm,CodMat,FchStkFin)
    ENDSCAN
    m.StkFin = m.StkFin + LfStkFin
ENDFOR
m.StkVar = m.StkFin - m.StkIni - m.TotCmp + m.TotCsm
IF m.SalProyAnt AND L=nMesIni-1
	m.PerAnt = STR(_ANO,4,0)+TRAN(nMesIni-1,[@L ##]) 						           
	lLocStkFin=SEEK(m.PerAnt+xCodMAt,[TOTAL])
	SELE TOTAL
	m.StkFin = EVAL(SF)
	m.StkVar = 0
ENDIF
SELE TOTAL
IF RECNO()<>m.RegAct
	GO m.RegAct
ENDIF
REPLACE (SI) WITH m.StkIni
REPLACE (CP) WITH m.TotCmp
REPLACE (CS) WITH m.TotCsm
REPLACE (SF) WITH m.StkFin
REPLACE (SV) WITH m.StkVar
REPLACE (MR) WITH [ ]
RETURN

*******************
PROCEDURE GenTempo4 && Generaci_n de temporal para programa valorizado
*******************
PRIVATE LfTotCsm
** Capturamos las sedes validas **
*IF !USED([SEDE])
*   SELE 0
*   USE SEDES ALIAS SEDE
*   IF !USED()
*      DO F1MSGERR WITH [Archivo de sedes no existe...!!! ]
*      RETURN
*   ENDIF
*ENDIF
SELE SEDE
SET FILTER TO !(UPPER(Nombre)=[CENTRAL]) && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,2)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*
USE
** Vector Para compras **
DIMENSION aPidPco(2)
STORE [] TO aPidPco
SELE CFTR
SET FILTER TO PIDPCO
NumEle = 0
SCAN FOR INLIST(CodMov,[001],[003])
    NumEle = NumEle + 1
    IF NumEle>ALEN(aPidPco)
       DIMENSION aPidPco(NumEle+5)
    ENDIF
    aPidPco(NumEle) =TipMov+CodMov
ENDSCAN
DIMENSION aPidPco(NumEle)
SET FILTER TO

nMesFin = 12
SELE 0
ArcTmp2= PATHUSER+SYS(3)
CREATE TABLE &ArcTmp2. FREE( CodMat C(LEN(CATG.COdMAt)),;
                         Desmat C(LEN(CATG.DesMat)),;                         
                         Desmat2 C(LEN(CATG.DesMat)),;
                         Nivel  C(3), Glosa C(10),;
                         V01 N(14,4),V02 N(14,4),V03 N(14,4),V04 N(14,4),;
                         V05 N(14,4),V06 N(14,4),V07 N(14,4),V08 N(14,4),;
                         V09 N(14,4),V10 N(14,4),V11 N(14,4),V12 N(14,4),;
                         V13 N(14,4),V14 N(14,4),;
                         C01 C(10),C02 C(10),C03 C(10),C04 C(10),;
                         C05 C(10),C06 C(10),C07 C(10),C08 C(10),;
                         C09 C(10),C10 C(10),C11 C(10),C12 C(10),;
                         C13 C(10),C14 C(10) )

USE &ArcTmp2. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF
INDEX ON CodMat+Nivel TAG TMP201
SET ORDER TO Tmp201
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
SELE TOTAL
SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")+m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE Periodo=LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") AND CodMat<=m.CodMatH
     STORE 0 TO XfTotLin1,XfTotLin2,XfTotLin3,XfTotLin4,XfTotlin5,XfTotLin6
     =SEEK(CodMat,[CATG])
     LfPreCmp1=0
     LfPreCmp2=0
     LfTotCsM=0
     LfProCsm=0
     LfUPreCmp = 0
     WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk NOWAIT
     FOR NM = 1 to 13
         LsMes=TRAN(NM,[@L ##])
   		 StkMes = [SI]+LsMes
		 CmpMes = [CP]+LsMes
		 CsmMes = [CS]+LsMes
		 StkFin = [SF]+LsMes
		 SisMes = [SV]+LsMes
		 Cadena = [C]+LsMes
		 Valor  = [V]+LsMes
         WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+MES(NM,1) NOWAIT
         LfProCsm=0
         NK=0
         DO WHILE NK<XnMesPrm AND NM+NK<=12 AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         DO WHILE NK<XnMesPrm AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK-12,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         LfProCsm = ROUND(LfProCsm/XnMesPrm,2)
         LsAAMMREF = TRAN(_ANO,[9999])+TRAN(NM,[@L 99])
         IF NM<=nMesIni
            ***LfUPreCmp1 = UltPreCmp(TOTAL.CodMat,LsAAMMREF,m.CodMon)
            ***LfUPreCmp  = IIF(LfUPreCmp1#0,LfUPreCmp1,LfUPreCmp)
            PCMP1=[PS]+LsMes
            PCMP2=[PD]+LsMes
            IF CATG.&PCMP1.#0
               LfPreCmp1 = CATG.&PCMP1.
            ENDIF
            IF CATG.&PCMP2.#0
               LfPreCmp2 = CATG.&PCMP2.
            ENDIF
         ENDIF
	     SELE TMP2
	     ** Compras del mes **
	     IF !m.SolFac
	   	     SEEK TOTAL.CodMat+[D01]
		     IF !FOUND()
			     APPEND BLANK
			     REPLACE CodMat   WITH TOTAL.CodMat
		  	     REPLACE NiVel    WITH [D01]
	         ENDIF
	         REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
		     REPLACE DesMat   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
		     REPLACE Glosa    WITH [COMPRA]
		     DO CASE
		        CASE NM<=12
		             DO CASE
		                CASE TOTAL.&CmpMes>=0
	            	        REPLACE &Valor.  WITH TOTAL.&CmpMes.
	    	                XfTotLin1 = XfTotLin1 + &Valor.
	    	            CASE TOTAL.&CmpMes=-1
	    	                REPLACE &Cadena WITH [C]
	    	            CASE TOTAL.&CmpMes=-2
	    	                REPLACE &Cadena WITH [D]
	    	         ENDCASE
		        CASE NM=13
	    	         REPLACE &Valor.  WITH XfTotLin1
	    	    CASE NM=14
		     ENDCASE
	     ENDIF
         ** Ultimo Precio de compra **
	     IF !m.SolFac
         
	   	     SEEK TOTAL.CodMat+[D02]
		     IF !FOUND()
			     APPEND BLANK
			     REPLACE CodMat   WITH TOTAL.CodMat
		  	     REPLACE NiVel    WITH [D02]
	         ENDIF
		   **REPLACE DesMat   WITH TOTAL.DesMat
		     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
		     REPLACE Glosa    WITH [UNI S/.]
		     DO CASE
		        CASE NM<=12 AND TOTAL.&CmpMes>0
	                 REPLACE &Cadena. WITH PADR(ALLTRIM(STR(ROUND(LfPreCmp1,3),10,3)),10)
	                 **XfTotLin2 = XfTotLin2 + &Valor.
	            CASE NM=13
	                 **REPLACE &Valor. WITH XfTotLin2
	         ENDCASE
	         **
	   	     SEEK TOTAL.CodMat+[D03]
		     IF !FOUND()
			     APPEND BLANK
			     REPLACE CodMat   WITH TOTAL.CodMat
		  	     REPLACE NiVel    WITH [D03]
	         ENDIF
		   **REPLACE DesMat   WITH TOTAL.DesMat
		     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
		     REPLACE Glosa    WITH [UNI US$]
		     DO CASE
		        CASE NM<=12 AND TOTAL.&CmpMes>0
	                 REPLACE &Cadena. WITH PADR(ALLTRIM(STR(ROUND(LfPreCmp2,3),10,3)),10)
	                 **XfTotLin3 = XfTotLin3 + &Valor.
	            CASE NM=13
	                 **REPLACE &Valor. WITH XfTotLin3
	         ENDCASE
	     ENDIF    
         ** Valor segun precios de compra **
         IF !m.SoLFac
	   	     SEEK TOTAL.CodMat+[D04]
		     IF !FOUND()
			     APPEND BLANK
			     REPLACE CodMat   WITH TOTAL.CodMat
		  	     REPLACE NiVel    WITH [D04]
	         ENDIF
		   **REPLACE DesMat   WITH TOTAL.DesMat
		     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
		     REPLACE Glosa    WITH [COSTO S/.]
		     DO CASE
		        CASE NM<=12
	                 REPLACE &Valor. WITH ROUND(LfPreCmp1*TOTAL.&CmpMes.,0)
	                 XfTotLin4 = XfTotLin4 + &Valor.
	            CASE NM=13
	                 REPLACE &Valor. WITH XfTotLin4
	         ENDCASE
	     ENDIF    
   	     ** Stock en dias **
	     ** Factor de alerta de compra **
   	     SEEK TOTAL.CodMat+[D05]
	     IF !FOUND()
		     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
	  	     REPLACE NiVel    WITH [D05]
         ENDIF
	   **REPLACE DesMat   WITH TOTAL.DesMat
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [FAC]
	     *******
   	     IF NM<=12
	      **REPLACE &Valor.  WITH IIF(LfProCsm#0,ROUND(TOTAL.&StkFin./LfProCsm,1),0)
	        REPLACE &Cadena. WITH PADR(ALLTRIM(STR(ROUND(TOTAL.&StkFin./LfProCsm,1),8,2)),10)
	      **XfTotLin6 = XfTotLin6 + &Valor.
	     ELSE
	      **REPLACE &Valor.  WITH XfTotLin6
	     ENDIF
	     IF EMPTY(DesMat)
    	    REPLACE DesMat WITH [ F1:]+TRAN(TOTAL.FacRf1,'99.99')+[ ]+[ F2:]+TRAN(Total.FacRf2,'99.99')
   	     ENDIF
   	     IF m.SolFac
	     	REPLACE DesMat   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
   	     ENDIF
	     ** Linea de separaci_n **
   	     SEEK TOTAL.CodMat+[D07]
	     IF !FOUND()
	         APPEND BLANK
    	     REPLACE CodMat   WITH TOTAL.CodMat
    	     REPLACE NiVel    WITH [D07]
	     ENDIF
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat   WITH REPLI("=",LEN(DesMat))
	     REPLACE &Cadena. WITH REPLI("=",LEN(&Cadena.))
	     REPLACE Glosa    WITH REPLI("=",LEN(Glosa))
     ENDFOR
     SELE TOTAL
ENDSCAN
SELE TMP2
USE
SELE TOTAL
USE &ArcTmp2. ORDER TMP201 ALIAS TOTAL EXCLU
IF !USED()
    RETURN .F.
ENDIF
GO TOP
DO BROWS_PRGA &&WITH .F.,[TOTAL]
RETURN
*******************
PROCEDURE UltPreCmp
*******************
PARAMETER _CodMat,_AnoMes,_Moneda
PRIVATE kK,LdFchFin,TT
m.WORKAREA=SELECT()
nAno=VAL(SubStr(_AnoMes,1,4))
nMes=VAL(SubStr(_AnoMes,5,2))
IF  nMes < 12
    IF nMes<nMesIni
       IF nMes= 1
          LdFchFin  = CTOD("01/"+STR(nMes+1,2,0)+"/"+STR(nAno,4,0)) - 1
       ELSE
          LdFchFin  = CTOD("01/"+STR(nMes+1,2,0)+"/"+STR(nAno,4,0)) - 1
       ENDIF
    ELSE
       IF nMes= 1
          LdFchFin  = CTOD("01/"+STR(nMes+1,2,0)+"/"+STR(nAno,4,0)) - 1
       ELSE
          LdFchFin  = CTOD("01/"+STR(nMes,2,0)+"/"+STR(nAno,4,0)) - 1
       ENDIF
    ENDIF
ELSE
    LdFchFin  = CTOD("31/12/"+STR(nAno,4,0))
ENDIF
LfPulCmp=0
=SEEK(_CodMat,[CATG])
LdUltCmp = CATG.UltCmp
LfPulCmp = iif(_moneda=1,CATG.PultMn,CATG.PultUs)
LdFchRef = LdFchFin
LfPreUni = 0
SELE DTRA
SET ORDER TO DTRA03
DO WHILE DTOS(LdFchRef)=LEFT(DTOS(LdFchFin),6)
    SEEK _CodMat+DTOS(LdFchRef)+[I]
    IF !FOUND()
       LdFchRef = LdFchRef - 1
       LOOP
    ENDIF
    lOkey = .F.
	FOR kk= 1 TO ALEN(aPidPco)
	    SEEK _CodMat+DTOS(LdFchRef)+aPidPco(kk)
	    IF !FOUND()
	       LOOP
	    ENDIF
	    IF !(FchDoc==LdFchRef AND CodMat==_CodMat)
	       EXIT
	    ENDIF
	    IF TipMov+CodMov=aPidPco(kk)
          WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ Ultima Compra:]+TipMov+CodMov+[ ]+DTOC(LdFchRef) NOWAIT
          LdUltCmp = FchDoc
          LfTpoCmb = wTpoCmb(FchDoc)
          IF LfTpoCmb=-1
             LfTpoCmb=1
             m.Error =1
          ENDIF
          LfPreUni = IIF(FacTor>0,PreUni/Factor,PreUni)
          IF EMPTY(PreUni) OR EMPTY(ImpCto)
             m.Error = 2
          ENDIF
          IF _Moneda = CodMon
             LfPulCmp = LfPreUni
          ELSE
             IF _Moneda=1
                LfPulCmp = LfPreUni*LfTpoCmb
             ELSE
                LfPulCmp = LfPreUni/LfTpoCmb
             ENDIF
          ENDIF
	    ENDIF
	    IF LfPreUni<>0
	       lOkey=.T.
	    ENDIF
	    IF LOKey
	       EXIT
	    ENDIF
	ENDFOR
	IF LOkey
	   EXIT
	ENDIF
    LdFchRef = LdFchRef -1 	
ENDDO	
WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ Ultima Compra:]+TipMov+CodMov+[ ]+DTOC(LdFchRef)+[ OK.] NOWAIT
SELE (m.WORKAREA)
RETURN LfPulCmp
****************
FUNCTION wtpocmb
****************
PARAMETER _Fch
AREA_ACT=ALIAS()
_TpoCmb=-1
IF SEEK(DTOS(_fch),"TCMB")
   IF Tcmb.OfiVta<=0
		SELE TCMB   		
      DO WHILE !BOF()
         SKIP -1
         IF TCMB.OfiVta>0
            EXIT
         ENDIF
      ENDDO
      IF TCMB.OfiVta>0
   	     _TpoCmb= TCMB.OfiVTa
	  ENDIF
  ELSE
      IF TCMB.OfiVta>0
  	     _TpoCmb= TCMB.OfiVTa
   	  ENDIF
  ENDIF
ELSE
   SELE TCMB
   IF !FOUND() AND RECNO(0)>0
	  GO RECNO(0)
   ENDIF
   IF !BOF()
      SKIP -1
   ENDIF
   IF TCMB.OfiVta>0
      _TpoCmb = TCMB.OfiVta
   ENDIF
ENDIF
SELE (AREA_ACT)
RETURN _TpoCmb
*******************
PROCEDURE GenTempo5 && Generar temporal para programa valorizado x Familia
*******************
PRIVATE LfTotCsm
** Capturamos las sedes validas **
*IF !USED([SEDE])
*   SELE 0
*   USE SEDES ALIAS SEDE
*   IF !USED()
*      DO F1MSGERR WITH [Archivo de sedes no existe...!!! ]
*      RETURN
*   ENDIF
*ENDIF
SELE SEDE
SET FILTER TO !(UPPER(Nombre)=[CENTRAL])  && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,2)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*
USE
** Vector Para compras **
DIMENSION aPidPco(2)
STORE [] TO aPidPco
SELE CFTR
SET FILTER TO PIDPCO
NumEle = 0
SCAN FOR INLIST(CODMOV,[001],[003])
    NumEle = NumEle + 1
    IF NumEle>ALEN(aPidPco)
       DIMENSION aPidPco(NumEle+5)
    ENDIF
    aPidPco(NumEle) =TipMov+CodMov
ENDSCAN
DIMENSION aPidPco(NumEle)
SET FILTER TO

nMesFin = 12
SELE 0
ArcTmp2= PATHUSER+SYS(3)
CREATE TABLE &ArcTmp2. FREE( CodMat C(LEN(CATG.COdMAt)),;
                         Desmat C(LEN(CATG.DesMat)),;
                         Desmat2 C(LEN(CATG.DesMat)),;                         
                         Nivel  C(3), Glosa C(10),;
                         V01 N(14,4),V02 N(14,4),V03 N(14,4),V04 N(14,4),;
                         V05 N(14,4),V06 N(14,4),V07 N(14,4),V08 N(14,4),;
                         V09 N(14,4),V10 N(14,4),V11 N(14,4),V12 N(14,4),;
                         V13 N(14,4),V14 N(14,4),;
                         C01 C(10),C02 C(10),C03 C(10),C04 C(10),;
                         C05 C(10),C06 C(10),C07 C(10),C08 C(10),;
                         C09 C(10),C10 C(10),C11 C(10),C12 C(10),;
                         C13 C(10),C14 C(10) )

USE &ArcTmp2. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF
INDEX ON CodMat+Nivel TAG TMP201
INDEX ON LEFT(CodMat,GaLenCod(2))+Nivel TAG Tmp202

SET ORDER TO Tmp201
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
SELE TOTAL
SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")+m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE Periodo=LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") AND CodMat<=m.CodMatH
     IF CodMat=[43068]
        LOOP
     ENDIF
     STORE 0 TO XfTotLin1,XfTotLin2,XfTotLin3,XfTotLin4,XfTotlin5,XfTotLin6
     =SEEK(CodMat,[CATG])
     LfTotCsM=0
     LfProCsm=0
     LfPreCmp1=0
     LfPreCmp2=0
     LfUPreCmp = 0
     WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk NOWAIT
     FOR NM = 1 to 13
         LsMes=TRAN(NM,[@L ##])
   		 StkMes = [SI]+LsMes
		 CmpMes = [CP]+LsMes
		 CsmMes = [CS]+LsMes
		 StkFin = [SF]+LsMes
		 SisMes = [SV]+LsMes
		 Cadena = [C]+LsMes
		 Valor  = [V]+LsMes
         WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+MES(NM,1) NOWAIT
         LsAAMMREF = TRAN(_ANO,[9999])+TRAN(NM,[@L 99])
         LfProCsm=0
         NK=0
         DO WHILE NK<XnMesPrm AND NM+NK<=12 AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         DO WHILE NK<XnMesPrm AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK-12,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         LfProCsm = ROUND(LfProCsm/XnMesPrm,2)
         IF NM<=nMesIni
            ***LfUPreCmp1 = UltPreCmp(TOTAL.CodMat,LsAAMMREF,m.CodMon)
            ***LfUPreCmp  = IIF(LfUPreCmp1#0,LfUPreCmp1,LfUPreCmp)
            PCMP1=[PS]+LsMes
            PCMP2=[PD]+LsMes
            IF CATG.&PCMP1.#0
               LfPreCmp1 = CATG.&PCMP1.
            ENDIF
            IF CATG.&PCMP2.#0
               LfPreCmp2 = CATG.&PCMP2.
            ENDIF
         ENDIF
   	     SELE TMP2
         ** Valor segun precios de compra **
   	     SEEK TOTAL.CodMat+[D01]
	     IF !FOUND()
		     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
	  	     REPLACE NiVel    WITH [D01]
         ENDIF
         REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [COSTO ]+iif(m.COdMon=1,[S/.],[US$])
	     DO CASE
	        CASE NM<=12
	             LfUPreCmp=IIF(m.CodMon=1,LfPreCmp1,LfPreCmp2)
	             IF Total.&CmpMes.>=0
                  REPLACE &Valor. WITH ROUND(LfUPreCmp*TOTAL.&CmpMes.*IIF(m.ConIgv,1+_PorIgv/100,1),0)
                  XfTotLin3 = XfTotLin3 + &Valor.
                 ENDIF
            CASE NM=13
                 REPLACE &Valor. WITH XfTotLin3
         ENDCASE
	     ** Linea de separaci_n **
   	  ***SEEK TOTAL.CodMat+[D07]
	  ***IF !FOUND()
	  ***    APPEND BLANK
      ***    REPLACE CodMat   WITH TOTAL.CodMat
      ***  	     REPLACE NiVel    WITH [D07]
	  ***ENDIF
	  ***REPLACE DesMat   WITH REPLI("=",LEN(DesMat))
	  ***REPLACE &Cadena. WITH REPLI("=",LEN(&Cadena.))
	  ***REPLACE Glosa    WITH REPLI("=",LEN(Glosa))
     ENDFOR
     SELE TOTAL
ENDSCAN
ArcTmp3=PATHUSER+STR(VAL(SYS(3))+1,8)
SELE TMP2
SET ORDER TO TMP202
TOTAL ON LEFT(CODMAT,GaLenCod(2))+NIVEL TO &ArcTmp3.
USE &arcTmp3. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF
INDEX ON LEFT(CODMAT,GaLenCod(2))+NIVEL TAG TMP201
SET ORDER TO TMP201
go top
store 0 to zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08,zv09,zv10,zv11,zv12,zv13,zv14
sum to zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08,zv09,zv10,zv11,zv12,zv13,zv14
REPLACE ALL DESMAT WITH IIF(SEEK(GaClfDiv(2)+LEFT(CodMat,GaLenCod(2)),[DIVF]),DIVF.DesFam,[])
REPLACE ALL CodMat WITH LEFT(CodMat,GaLenCod(2))
COPY TO &ArcTmp2. WITH CDX  FOR V01+V02+V03+V04+V05+V06+V07+V08+V09+V10+V11+V12>0
USE &ArcTmp2. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF

GO TOP
SCAN
     REPLACE Nivel WITH [D02]
     REPLACE Glosa WITH [  %]
     REPLACE DESMAT WITH []
     FOR MesPro=1 to 14
         CmpPRo=[V]+TRAN(MesPro,[@L ##])
         ZCmpPro=[ZV]+TRAN(MesPro,[@L ##])
         IF &ZCmpPro.#0
            REPLACE &CmpPro. WITH ROUND(&CmpPro./&ZCmpPro.*100,2)
         ELSE
            REPLACE &CmpPro. WITH 0
         ENDIF
     ENDFOR
ENDSCAN
APPEND FROM &ArcTmp3. FOR V01+V02+V03+V04+V05+V06+V07+V08+V09+V10+V11+V12>0
USE
SELE TOTAL
USE &ArcTmp2. ORDER TMP201 ALIAS TOTAL EXCLU
IF !USED()
    RETURN .F.
ENDIF
GO TOP
DO BROWS_PRGA &&WITH .F.,[TOTAL]
RETURN
*******************
PROCEDURE GenTempo6 && Generar temporal de Valorizado x Insumo y %
*******************
PRIVATE LfTotCsm
** Capturamos las sedes validas **
*IF !USED([SEDE])
*   SELE 0
*   USE SEDES ALIAS SEDE
*   IF !USED()
*      DO F1MSGERR WITH [Archivo de sedes no existe...!!! ]
*      RETURN
*   ENDIF
*ENDIF
SELE SEDE
SET FILTER TO !(UPPER(Nombre)=[CENTRAL]) && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,2)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*
USE
** Vector Para compras **
DIMENSION aPidPco(2)
STORE [] TO aPidPco
SELE CFTR
SET FILTER TO PIDPCO
NumEle = 0
SCAN FOR INLIST(CODMOV,[001],[003])
    NumEle = NumEle + 1
    IF NumEle>ALEN(aPidPco)
       DIMENSION aPidPco(NumEle+5)
    ENDIF
    aPidPco(NumEle) =TipMov+CodMov
ENDSCAN
DIMENSION aPidPco(NumEle)
SET FILTER TO

nMesFin = 12
SELE 0
ArcTmp2= PATHUSER+SYS(3)
CREATE TABLE &ArcTmp2. FREE( CodMat C(LEN(CATG.COdMAt)),;
                         Desmat C(LEN(CATG.DesMat)),;
                         Desmat2 C(LEN(CATG.DesMat)),;
                         Nivel  C(3), Glosa C(10),;
                         V01 N(14,4),V02 N(14,4),V03 N(14,4),V04 N(14,4),;
                         V05 N(14,4),V06 N(14,4),V07 N(14,4),V08 N(14,4),;
                         V09 N(14,4),V10 N(14,4),V11 N(14,4),V12 N(14,4),;
                         V13 N(14,4),V14 N(14,4),;
                         C01 C(10),C02 C(10),C03 C(10),C04 C(10),;
                         C05 C(10),C06 C(10),C07 C(10),C08 C(10),;
                         C09 C(10),C10 C(10),C11 C(10),C12 C(10),;
                         C13 C(10),C14 C(10) )

USE &ArcTmp2. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF
INDEX ON CodMat+Nivel TAG TMP201
INDEX ON LEFT(CodMat,GaLenCod(2))+Nivel TAG Tmp202

SET ORDER TO Tmp201
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
SELE TOTAL
SEEK LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##")+m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE Periodo=LEFT(GsAnoMes,4)+TRAN(nMesIni,"@L ##") AND CodMat<=m.CodMatH
     STORE 0 TO XfTotLin1,XfTotLin2,XfTotLin3,XfTotLin4,XfTotlin5,XfTotLin6
     =SEEK(CodMat,[CATG])
     LfTotCsM=0
     LfProCsm=0
     LfPreCmp1=0
     LfPreCmp2=0
     LfUPreCmp = 0
     lHayValor=.f.
     WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk NOWAIT
     FOR NM = 1 to 13
         LsMes=TRAN(NM,[@L ##])
   		 StkMes = [SI]+LsMes
		 CmpMes = [CP]+LsMes
		 CsmMes = [CS]+LsMes
		 StkFin = [SF]+LsMes
		 SisMes = [SV]+LsMes
		 Cadena = [C]+LsMes
		 Valor  = [V]+LsMes
         WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+MES(NM,1) NOWAIT
         LsAAMMREF = TRAN(_ANO,[9999])+TRAN(NM,[@L 99])
         LfProCsm=0
         NK=0
         DO WHILE NK<XnMesPrm AND NM+NK<=12 AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         DO WHILE NK<XnMesPrm AND NM#13
            LsCmpEva = [CS]+TRAN(NM+NK-12,[@L ##])
            LfProCsm = LfProCsm + TOTAL.&LsCmpEva.
            NK=NK + 1
         ENDDO
         LfProCsm = ROUND(LfProCsm/XnMesPrm,2)
         IF NM<=nMesIni
            ***LfUPreCmp1 = UltPreCmp(TOTAL.CodMat,LsAAMMREF,m.CodMon)
            ***LfUPreCmp  = IIF(LfUPreCmp1#0,LfUPreCmp1,LfUPreCmp)
            PCMP1=[PS]+LsMes
            PCMP2=[PD]+LsMes
            IF CATG.&PCMP1.#0
               LfPreCmp1 = CATG.&PCMP1.
            ENDIF
            IF CATG.&PCMP2.#0
               LfPreCmp2 = CATG.&PCMP2.
            ENDIF
         ENDIF
         lHayValor=.t.
   	     SELE TMP2
         ** Valor segun precios de compra **
   	     SEEK TOTAL.CodMat+[D01]
	     IF !FOUND()
		     APPEND BLANK
		     REPLACE CodMat   WITH TOTAL.CodMat
	  	     REPLACE NiVel    WITH [D01]
         ENDIF
         REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE Glosa    WITH [COSTO ]+iif(m.COdMon=1,[S/.],[US$])
	     DO CASE
	        CASE NM<=12
	             LfUPreCmp=IIF(m.CodMon=1,LfPreCmp1,LfPreCmp2)
	             IF Total.&CmpMes.>=0
                  REPLACE &Valor. WITH ROUND(LfUPreCmp*TOTAL.&CmpMes.*IIF(m.ConIgv,1+_PorIgv/100,1),0)
                  XfTotLin3 = XfTotLin3 + &Valor.
                 ENDIF
            CASE NM=13
                 REPLACE &Valor. WITH XfTotLin3
         ENDCASE
	     ** Linea de separaci_n **
   	     SEEK TOTAL.CodMat+[D07]
	     IF !FOUND()
	         APPEND BLANK
             REPLACE CodMat   WITH TOTAL.CodMat
       	     REPLACE NiVel    WITH [D07]
	     ENDIF
	     REPLACE DesMat2   WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
	     REPLACE DesMat   WITH REPLI("=",LEN(DesMat))
	     REPLACE &Cadena. WITH REPLI("=",LEN(&Cadena.))
	     REPLACE Glosa    WITH REPLI("=",LEN(Glosa))
     ENDFOR
     SELE TOTAL
ENDSCAN
ArcTmp3=PATHUSER+STR(VAL(SYS(3))+1,8)
SELE TMP2
store 0 to zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08,zv09,zv10,zv11,zv12,zv13,zv14
sum to zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08,zv09,zv10,zv11,zv12,zv13,zv14
COPY TO &ArcTmp3. WITH CDX  FOR NIVEL=[D01]
USE &ArcTmp3. ALIAS TMP2 EXCLU
IF !USED()
    RETURN .F.
ENDIF

GO TOP
SCAN
     REPLACE Nivel WITH [D02]
     REPLACE Glosa WITH [  %]
     REPLACE DESMAT WITH []
     FOR MesPro=1 to 14
         CmpPRo=[V]+TRAN(MesPro,[@L ##])
         ZCmpPro=[ZV]+TRAN(MesPro,[@L ##])
         IF &ZCmpPro.#0
            REPLACE &CmpPro. WITH ROUND(&CmpPro./&ZCmpPro.*100,2)
         ELSE
            REPLACE &CmpPro. WITH 0
         ENDIF
     ENDFOR
ENDSCAN
USE
SELE TOTAL
USE &ArcTmp2. ORDER TMP201 ALIAS TOTAL EXCLU
IF !USED()
    RETURN .F.
ENDIF
APPEND FROM &ArcTmp3. &&FOR V01+V02+V03+V04+V05+V06+V07+V08+V09+V10+V11+V12>0
GO TOP
DO BROWS_PRGA &&WITH .F.,[TOTAL]
RETURN
