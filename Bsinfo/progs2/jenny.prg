* Procedimiento de Grabaci¢n de informaci¢n
********************************
FUNCTION Grabar_transaccion_Alm
********************************
PARAMETERS  m.cSubAlm, m.cTipMov ,m.sCodMov ,m.sNroDoc
=F1QEH("GRAB_DBFS")
IF GoCfgAlm.lPidCli
   GoCfgAlm.sCodCli = GoCfgAlm.sCodAux
ENDIF
IF GoCfgAlm.lPidPro
   GoCfgAlm.sCodPro = GoCfgAlm.sCodAux
ENDIF
IF GoCfgAlm.Crear                  && Creando
   =F1QEH("GRAB_CABE")
*!*	   SELE CDOC
*!*	   IF .NOT. F1_RLock(5)
*!*			UltTecla = K_ESC
*!*	    	RETURN .F.             && No pudo bloquear registro
*!*	   ENDIF
	SELECT CTRA
	IF SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc ,'CTRA','CTRA01')
		m.sNroDoc=correlativo_alm(GoCfgAlm.EntidadCorrelativo,m.cTipMov,m.sCodMov,m.cSubAlm,'0')
		IF SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc ,'CTRA','CTRA01')
			=MESSAGEBOX("Registro creado por otro usuario.")
*!*				UltTecla = K_ESC
		    RETURN -1
		ENDIF
	ENDIF
	INSERT INTO CTRA  ( CodSed,SubAlm,TipMov ,CodMov,NroDoc) VALUES  ( GsCodSed,m.cSubAlm,m.cTipMov,m.sCodMov,m.sNroDoc)
*!*	   REPLACE CTRA->CodAlm WITH GsCodAlm
*!*	   REPLACE CTRA->SubAlm WITH GsSubAlm
*!*	   REPLACE CTRA->TipMov WITH m.cTipMov
*!*	   REPLACE CTRA->CodMov WITH m.sCodMov
*!*	   REPLACE CTRA->NroDoc WITH m.sNroDoc
*!*	   SELECT CDOC
*!*	   IF GlCorrU_I
*!*		   IF m.sNroDoc >= RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.sNroDoc))
*!*		      REPLACE CDOC->NroDoc WITH CDOC->NroDoc + 1
*!*		   ENDIF
*!*		   UNLOCK
*!*	   ELSE 
*!*		   =NROAST(m.sNroDoc)
*!*	   ENDIF                
*!*	  SELECT CTRA
   =correlativo_alm(GoCfgAlm.EntidadCorrelativo,m.cTipMov,m.sCodMov,m.cSubAlm,m.sNroDoc)  
ELSE
   =F1QEH("GRAB_CABE")
  *** Rectifica cambios hechos en la cabezera, cambien en el cuerpo del **
  *** documento.                                                        ***
  =SEEK(m.cSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc	,'CTRA','CTRA01')
   IF CTRA.FchDoc != C_CTRA.FchDoc .OR. ;
      CTRA.CodPro != C_CTRA.CodPro .OR. ;
      CTRA.CodVen != C_CTRA.CodVen .OR. ;
      CTRA.CodCli != C_CTRA.CodCli .OR. ;
      CTRA.NroOdt != C_CTRA.NroOdt .OR. ;
      CTRA.CodMon != C_CTRA.CodMon .OR. ;
      CTRA.TpoCmb != C_CTRA.TpoCmb .OR. ;
      CTRA.CodPrd != C_CTRA.CodPrd .OR. ;
      CTRA.FBatch != C_CTRA.fBatch  .OR. ;
      _ChkRef()

	Local  LsLLave_reg
	SELE C_DTRA
*!*	      LsLLave  = GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
*!*	      SEEK LsLLave
*!*	      DO WHILE LsLLave = (SubAlm+TipMov+CodMov+NroDoc) .AND. ! EOF()

	* @_@ Solo cheuqeamos los registros que ya existen. NO los nuevos
	SCAN FOR !EMPTY(NROREG) 
**	 IF F1_RLOCK(5)
		LsLlave_reg = C_DTRA.SubAlm+C_DTRA.TipMov+C_DTRA.CodMov+C_DTRA.NroDoc  + STR(C_DTRA.NroItm,3,0)
		 IF  !SEEK(LsLLave_Reg,'DTRA','DTRA01')
		 	WAIT WINDOW 'Que raro se supone que ya esta grabado y no lo encuentro, estara mal la llave?' 
		 	LOOP
		 ENDIF
	    RegAct = NROREG   && @_@ Numero de registro en la tabla real
	    lAcPre = ( DTRA.FchDoc != C_CTRA.FchDoc ) .OR. ( DTRA.CodMon != C_CTRA.CodMon ) ;
	     .OR. ( DTRA.TpoCmb != C_CTRA.TpoCmb )
	    lCmFch = DTRA.FchDoc  > FchDoc  && Barrer desde el principio

	    IF !EMPTY(GoCfgAlm.XsTpoRef)	&& Si hay documento de referencia
	       LsTpoRef = GoCfgAlm.XsTpoRef
	   		LsCadenaEval2 = GoCfgAlm.VarRef
	**       IF EMPTY(NroRef)				&& Asignamos segun referencia que tenga
		  		LsNroRef = IIF(!EMPTY(GoCfgAlm.VarRef),&LsCadenaEval2.,[])
	**       ENDIF
		ELSE 	&& Lo dejamos como estaba
			LsTpoRef = TpoRef
			LsNroRef = NroRef	       
	    ENDIF
	    
	    UPDATE DTRA SET ;	    
		     FchDoc = C_CTRA.FchDoc, ;   && OJO ALTERA EL PROMEDIO
		     CodPro = C_CTRA.CodPro, ;
		     CodMon = C_CTRA.CodMon, ;    && OJO ALTERA EL PROMEDIO
		     TpoCmb = C_CTRA.TpoCmb, ;    && OJO ALTERA EL PROMEDIO
			 CodCli = C_CTRA.CodCli, ;
		     TpoRef = LsTpoRef, ;
		     NroRef = LsNroRef, ;
		     FBatch = C_CTRA.FBatch ;
		WHERE    Subalm = m.cSubAlm AND ;
			TipMov = m.cTipMov AND ; 			  	     	
			CodMov = m.sCodMov AND  ;
       		NroDoc = m.sNroDoc AND ;
			NroItm = C_DTRA.NroItm
		     
	    *** AQUI
*!*		    IF !EMPTY(GoCfgAlm.XsTpoRef)
*!*		       REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
*!*		       IF EMPTY(NroRef)
*!*			  REPLACE NroRef WITH IIF(!EMPTY(GoCfgAlm.VarRef),m.GoCfgAlm.&VarRef.,[])
*!*		       ENDIF
*!*		    ENDIF
	    lAcCsmo=GoCfgAlm.lModCsm AND (C_CTRA.FBatch<>GoCfgAlm.FBatch OR CodPrd<>GoCfgAlm.sCodPrd ;
		    OR lAcPre)
	    IF lAcCsmo					
		    UPDATE DTRA SET ;	    
				TpoRef = GoCfgAlm.XsTpoRef , ;
				CodPrd = GoCfgAlm.sCodPrd, ;
				NroRef = GoCfgAlm.sNroOdt, ;
				FBatch = GoCfgAlm.FBatch ;
			WHERE    Subalm = m.cSubAlm AND ;
				TipMov = m.cTipMov AND ; 			  	     	
				CodMov = m.sCodMov AND  ;
	       		NroDoc = m.sNroDoc AND ;
				NroItm = C_DTRA.NroItm
				=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,-Candes,NroReg,'ESTA')
	    ENDIF
	    *
	    lActTra=GoCfgAlm.lAfeTra AND (C_CTRA.FBatch<>GoCfgAlm.FBatch OR CodPrd<>GoCfgAlm.sCodPrd ;
		    OR lAcPre)
		*   
	    IF lActTra
		    UPDATE DTRA SET ;	    
				CodPrd = GoCfgAlm.sCodPrd, ;
				FBatch = GoCfgAlm.FBatch ;
			WHERE    Subalm = m.cSubAlm AND ;
				TipMov = m.cTipMov AND ; 			  	     	
				CodMov = m.sCodMov AND  ;
	       		NroDoc = m.sNroDoc AND ;
				NroItm = C_DTRA.NroItm
	       		=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,-Candes,nroreg,'ESTR')
	    ENDIF
        *
        =CALC_ACT_COSTOPROMEDIOUNIT(NroReg,lCmFch)
        *
	    SELE C_DTRA
	    IF lAcCsmo
	    	=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,Candes,nroreg,'ESTA')
	    ENDIF
	    *
	    IF lActTra
			=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,Candes,nroreg,'ESTR')
	    ENDIF
		SELE C_dtra	
	ENDSCAN
   ENDIF
   SELECT CTRA
ENDIF

UPDATE CTRA SET  ;
		FchDoc  = C_CTRA.FchDoc ,;
		NroRf1  =  C_CTRA.NroRf1 ,; 
       	NroRf2  =  C_CTRA.NroRf2 ,;
       	NroRf3  = C_CTRA.NroRf3 ,;
       	NroOdt  = C_CTRA.NroOdt ,;
       	CodVen  = C_CTRA.CodVen ,;
       	CodPro  = C_CTRA.CodPro ,;
       	CodCli  = C_CTRA.CodCli ,;
       	CodMon  = C_CTRA.CodMon ,;
       	TpoCmb  = C_CTRA.TpoCmb ,;
       	Observ  = C_CTRA.Observ ,;
       	CodPrd  = C_CTRA.CodPrd ,;
       	FBatch  = C_CTRA.fBatch ,;
       	User    = GoCfgAlm.Usuario ,;
	    	NomTra  = C_CTRA.NomTra ,;
	    	DirTra  = C_CTRA.DirTra ,;
	    	RucTra  = C_CTRA.RucTra ,;
	    	PlaTra  = C_CTRA.PlaTra ,;
	    	Brevet  = C_CTRA.Brevet ,;
	    	Motivo  = C_CTRA.Motivo ,;
	    	ImpBrt  = C_CTRA.ImpBrt ,;
	    	PorIgv  = C_CTRA.PorIgv ,;
	    	ImpIgv  = C_CTRA.ImpIgv ,;
	    	ImpTot  = C_CTRA.ImpTot ,;
	    	CodUser = GoCfgAlm.Usuario ,;
	    	CodLote = C_CTRA.CodLote,;
	    	CodActiv = C_CTRA.CodActiv,;
	    	CodProcs = C_CTRA.CodProcs,;
	    	CodFase  = C_CTRA.CodFase,;
		CodCult  = C_CTRA.CodCult,;
	    	FchHOra = DATETIME() ;
	WHERE    Subalm = m.cSubAlm AND ;
		TipMov = m.cTipMov AND ; 			  	     	
       	CodMov = m.sCodMov AND  ;
       	NroDoc = m.sNroDoc
        	

=F1QEH("GRAB_DETA")
LnControl=Grabar_transaccion_Alm_Detalle()         && Grabamos detalle
=F1QEH("OK")
SELE CTRA
*!*	=F1QEH("IMPRIMIR")
*!*	**DO pEmision
RETURN LnControl
**************************************
FUNCTION Grabar_transaccion_Alm_Detalle   && Graba todos los items de una transaccion al final
**************************************
*
PRIVATE OK
*

IF GoCfgAlm.GnTotDel >0
	FOR k = 1 TO GoCfgAlm.GnTotDel
       ** Borramos en el almacen emisor **
		IF GoCfgAlm.aRegDel(k)>0
			SELE DTRA
			GO GoCfgAlm.aRegDel(k)
			DO WHILE !RLOCK()
			ENDDO
			DELETE
			DO CASE 
				CASE GoCfgAlm.cTipMov='I'
					=Alm_Descarga_stock_ALMpdsm2(.T.)
				CASE GoCfgAlm.cTipMov='S'
					=Alm_Carga_Stock_Almpcsm2(.T.)	
			ENDCASE					
			UNLOCK
		ENDIF
   ENDFOR
ENDIF
OK     = .T.

IF OK
   SELE C_DTRA
   PACK
   GO TOP
   SCAN
	m.Nro_Itm = RECNO()
	SCATTER MEMVAR
	IF NroReg>0
	   ** Desactualizar **
	   m.Nro_Reg = NroReg
	   SELE DTRA
	   GO m.Nro_Reg
	   DO WHILE !RLOCK()
	   ENDDO
		DO CASE 
			CASE GoCfgAlm.cTipMov='I'
				=Alm_Descarga_stock_ALMpdsm2(.T.)
			CASE GoCfgAlm.cTipMov='S'
				=Alm_Carga_Stock_Almpcsm2(.T.)	
		ENDCASE					
	   UNLOCK
	ELSE
	   SELE DTRA
	   APPEND BLANK
	   m.Nro_Reg = RECNO()
		*** Determinamos el NroItm ***
		Local LsLLave_Reg
		LsLlave_Reg=C_DTRA.SubAlm+C_DTRA.TipMov+C_DTRA.CodMov+C_DTRA.NroDoc 
		select max(nroitm)+1 as nroitm from almdtran where subalm+tipmov+codmov+nrodoc=LsLlave_Reg into cursor cur_temp
		IF _TALLY  = 0		&& Creando registro por primera vez
			m.NroItm = 1
		ELSE
			m.NroItm = cur_temp.nroitm
		ENDIF
		use in cur_temp
		SELE DTRA
		*** 
	ENDIF
	IF m.Nro_Reg<>RECNO() AND m.Nro_Reg>0
	   GO m.Nro_Reg       && Ser  posible  ??  SI, si es que no se tiene ningun area seleccionada
	ENDIF
	GATHER MEMVAR
	REPLACE CodSed WITH GoCfgAlm.CodSed
	REPLACE FchDoc WITH C_CTRA.FchDoc
	IF GoCfgAlm.lModCsm OR GoCfgAlm.lAfeTra
	   IF USED([DFPRO])
	      =SEEK(CodPrd+SubAlm+CodMat,[DFPRO])
	      REPLACE CnFmla WITH DFPRO.CanReq*C_DTRA.Fbatch
	   ENDIF
	   REPLACE CodPrd WITH C_DTRA.CodPrd
	   REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
	   REPLACE NroRef WITH C_CTRA.NroOdt				&& Revisar todavia no obedece a una
	   REPLACE FBATCH WITH C_CTRA.FBatch			&& configuracion total 01/09/2001
	ENDIF
	*
	*** AQUI
	IF !EMPTY(GoCfgAlm.XsTpoRef)
		LsCadenaEval2 = GoCfgAlm.VarRef
	   REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
	   REPLACE NroRef WITH IIF(!EMPTY(GoCfgAlm.VarRef),C_CTRA.&LsCadenaEval2,[])
*!*		   IF !EMPTY(C_DTRA.NroRef)
*!*		       REPLACE NroRef WITH C_DTRA.NroRef
*!*		   ENDIF
	ENDIF
	*
	REPLACE CTRA.NroItm WITH CTRA.NroItm + 1
	*
	IF GoCfgAlm.lPidPco
	   REPLACE DTRA.CodAjt WITH "A"
	ELSE
	   REPLACE DTRA.CodAjt WITH " "
	ENDIF
	* * * * * * * * * * * * * *
	DO CASE 
		CASE GoCfgAlm.cTipMov='I'
			=alm_Carga_Stock_Almpcsm1()
		CASE GoCfgAlm.cTipMov='S'
	 	=Alm_Descarga_stock_ALMpdsm1()
	ENDCASE	 	
	UNLOCK
	SELE C_DTRA
   ENDSCAN
ENDIF
*
RETURN 1


*
*
***************************************************************************************
* VETT ??? Procedimientos para Grabar Parte Diario - CpipgO_T
***************************************************************************************
* El Procedimiento Grabar_O_T llama a :
* - DO GrbdO_T
*
*
*********************
PROCEDURE Grabar_O_T
*********************
PRIVATE iRecno
IF Crear
   APPEND BLANK
   IF !F1_RLOCK(5)
      RETURN
   ENDIF
   STORE RECNO() TO iRECNO
   * control multiuser *
   SELE CDOC
   IF !F1_RLOCK(5)
      SELE CO_T
      DELETE
      RETURN
   ENDIF
   IF sNroO_T = m.NroO_T
      * correlativo automatico
      XsNroMes=TRAN(_MES,"@L ##")
      Campo1   = [NDOC]+XsNroMes
      LnNroO_T = CDOC.&Campo1.
      LnNroO_T = VAL(XsNroMes+RIGHT(TRANSF(LnNroO_T,"@L ###"),3))
      LsNroO_T = ALLTRIM(STR(LnNroO_T))
      sNroO_T  = LEFT(CDOC.Siglas,3)+PADL(LsNroO_T,LEN(CO_T.NroDoc)-3,'0')
      REPLACE &Campo1. WITH &Campo1. + 1
   ELSE
      SELE CO_T
      SEEK sNroO_T
      IF FOUND()
         GO iRECNO
         DELETE
         sErr = [Registro Creado por Otro Usuario]
         DO F1MSGERR WITH sERR
         RETURN
      ELSE
         SELE CDOC
         sNroCorr = SUBSTR(sNroO_T,4)
         IF VAL(sNroCorr)>=NroDoc
            REPLACE NroDoc WITH VAL(sNroCorr)+1
         ENDIF
      ENDIF
   ENDIF
   UNLOCK IN "CDOC"
   SELE CO_T
   GO iRECNO
   REPLACE NroDoc WITH sNroO_T
ENDIF
** REMPLAZAMOS DATOS DE LA CABECERA **
REPLACE FchDoc WITH dFchDoc
REPLACE Respon WITH sRespon
REPLACE CanObj WITH fCanObj
REPLACE CodPro WITH sCodPrd
REPLACE CdArea WITH sCdArea
** Guardamos datos anteriores **
REPLACE FchFinA WITH FchFin
REPLACE CanFinA WITH CanFin
*--------------X---------------*
REPLACE FchFin WITH dFchFin
REPLACE CanFin WITH fCanFin

REPLACE FlgEst WITH IIF(!EMPTY(FchFin),[T],cFlgEst)
REPLACE TipBat WITH m.tipbat
** Factor de producci¢n
REPLACE Factor WITH fFactor
DO GrbdO_T
SELE CO_T
UNLOCK ALL

** FIN : REMPLAZO DE DATOS DE LA CABECERA
***************************************************************************************
*+-----------------------------------------------------------------------------+
*Ý GRBdO_T   Prototipo de grabaci¢n  de O_T y Actualizaci¢n a almacen          Ý
*Ý                                                                             Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
***************** VETT ?????
* El Procedimiento GrbdO_T llama a :
* - DO CierDbfPro    M
* - !AbreDbfAlm()    M
* - DO CierDbfAlm   M
* - =AbreDbfPro()
* - DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
* - !ArrConfig()
* - =ChkMovAct([CanFor])
* - =ActAlmCen(K)
*****************
PROCEDURE GrbdO_T  && Comienza la chanfainita
*****************
** Cerramos archivos innecesarios  **
lActalm = .T.
STORE .F. TO aHayMov
DO CierDbfPro
IF !AbreDbfAlm()
   DO F1MsgErr WITH [Error en apertura de archivos de almacen]
   DO CierDbfAlm
   =AbreDbfPro()
   lActalm = .F.
ENDIF
** Extornamos datos anteriores de almacen con otro factor **
SELE EXTORNO
SCAN
	IF !EMPTY(CodFor+CodAdi+CodDev)
		DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
    ENDIF
ENDSCAN
** Borramos informacion anterior **
IF GnTotDel >0
   FOR k = 1 TO GnTotDel
       IF aRegDel(k)>0
          SELE DO_T
          GO aRegDel(k)
          DO WHILE !RLOCK()
          ENDDO
          DO EXTALMCEN WITH .F.,DO_T.NroDoc,DO_T.SubAlm,DO_T.CodMat,.T.
          SELE DO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
** Cargamos configuraci¢n de Producci¢n **
IF nTotMov <=0
   IF !ArrConfig()
      DO F1MsgErr WITH [No existe configuraci¢n para actualizar almacen]
      =AbreDbfPro()
      lActAlm = .F.
   ENDIF
ENDIF

** Grabaci¢n de detalle de O_T   **

SELE TEMPO
PACK
GO TOP
SCAN
 **IF EMPTY(NroDoc)
 **   REPLACE NroDoc WITH sNroO_t
 **ENDIF
 **IF EMPTY(CodPro)
 **   REPLACE CodPRo WITH sCodPrd
 **ENDIF
 **IF EMPTY(TipPro)
 **   =SEEK(CODMAT,[CATG])
 **   IF !CATG.NoProm
 **      m.TipPro = [PTA] && Insumos que no son envases
 **   ELSE
 **      m.TipPro = [PTB] && Insumos que si son envases
 **   ENDIF
 **   REPLACE TipPro  WITH m.TipPro
 **ENDIF
 **IF CnFmla=0
 **   REPLACE CnFmla WITH CanFor
 **ENDIF
 **IF FacEqu=0
 **   REPLACE FacEqu WITH 1
 **ENDIF
   IF m.TipBat=2
		REPLACE CnFmla WITH CanFor + CanAdi
   ENDIF
   =ChkMovAct([CanFor])
   =ChkMovAct([CanAdi])
  *=ChkMovAct([CanSal])
   =ChkMovAct([CanDev])
   SCATTER MEMVAR
   IF NroReg>0
      m.Nro_Reg = NroReg
      SELE DO_T
      GO m.Nro_Reg
   ELSE
      SELE DO_T
      APPEND BLANK
      m.Nro_Reg = RECNO()
   ENDIF
   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
      GO m.Nro_Reg
   ENDIF
   GATHER MEMVAR
   REPLACE FCHDOC with co_t.fCHdOC
   UNLOCK
   SELE TEMPO
   REPLACE RegGrb WITH m.Nro_Reg
ENDSCAN
SELE CO_T
m.HayIngP_T = !EMPTY(CO_T.FchFin) AND (CO_T.CanFin#CO_T.CanFinA OR CO_T.FchFin#CO_T.FchFinA)
** Chequeamos si hay que valorizar Productos terminados **
lValProTer = .f.
PRIVATE YY
FOR YY  = 1 to nTotMov
	if aporp_t(yy)
	else
	   IF aHayMov(yy)		
	   	  lValProTer =.t.	
	   endif
	endif
ENDFOR
** Fin De Chequeo **
SELE DTRA
SET ORDER TO DTRA04
SELE PO_T
SEEK sNROO_T
SCAN WHILE NroDoc=sNroO_T
     lGrbValAlm=SEEK(ZsTpoRef+NroDoc+CodPrd+SubAlm+CodP_T,[DTRA])
     lGrbCtoUni=lGrbValAlm AND (DTRA.Preuni#0 AND DTRA.ImpCto#0)
     IF lValProTer or CostMn<=0 or !lGrbCtoUni
        DO WHILE !RLOCK()
        ENDDO
        REPLACE FlgAlm WITH .F.
        UNLOCK
     ENDIF
     =ChkMovAct([CanFin])
ENDSCAN
SELE CO_T

IF !lActAlm
   RETURN
ENDIF

IF CieDelMes(_MES)
   RETURN
ENDIF

** Y abrimos archivos de almacen   **
IF !AbreDbfAlm()
   DO F1MsgErr WITH [Error en apertura de archivos de almacen]
   DO CierDbfAlm
   =AbreDbfPro()
   RETURN
ENDIF

STORE .F. TO aConFig
*DO CPIsgo_t.spr

PRIVATE K
nNumItmI = 0
FOR K = 1 TO nTotMov
    IF aHayMov(K) &&&AND aConFig(K,1)
       =ActAlmCen(K)
    ENDIF
ENDFOR
** Imprimir guias de almacen **
lCapConfig =.T.
DO Impr_Guias
**
RELEASE K
** Cerramos archivos de Almacen **
DO CierDbfAlm
** Y abrimos archivos de Producci¢n **
IF !AbreDbfPro()
   DO F1MsgErr WITH [Error en apertura de archivos de Producci¢n]
ENDIF
RETURN

****************** ????? VETT ?????
* El Procedimiento CierDbfPro No llama a Otro
********************
PROCEDURE CierDbfPro
********************
*
IF USED([CFPRO])
   SELE CFPRO
   USE
ENDIF
*
IF USED([DFPRO])
   SELE DFPRO
   USE
ENDIF
*
RETURN

****************** ????? VETT ?????
* El Procedimiento AbreDbfAlm No llama a Otro
*******************
FUNCTION AbreDbfAlm
*******************
IF !USED([CTRA])
   SELE 0
   USE ALMCTRAN ORDER CTRA01 ALIAS CTRA
   IF !USED()
      DO F1MsgErr WITH [Error en apertura de archivo de almacen:]+[ALMCTRAN]
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DTRA])
   SELE 0
   USE ALMDTRAN ORDER DTRA01 ALIAS DTRA
   IF !USED()
      DO F1MsgErr WITH [Error en apertura de archivo de almacen:]+[ALMDTRAN]
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([ESTA])
   SELE 0
   USE ALMESTCM ORDER ESTA01 ALIAS ESTA
   IF !USED()
      DO F1MsgErr WITH [Error en apertura de archivo de almacen:]+[ALMESTCM]
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([ESTR])
   SELE 0
   USE ALMESTTR ORDER ESTR01 ALIAS ESTR 
   IF !USED()
      DO F1msgerr WITH [Error en apertura de archivo de almacen:]+[ALMESTTR]
      RETURN .F.
   ENDIF
ENDIF
*
RETURN .T.

****************** ????? VETT ?????
* El Procedimiento CierDbfAlm No llama a Otro
********************
PROCEDURE CierDbfAlm
********************
IF USED([CTRA])
   SELE CTRA
   USE
ENDIF
*
*IF USED([DTRA])
*   SELE DTRA
*   USE
*ENDIF
*
IF USED([ESTA])
   SELE ESTA
   USE
ENDIF
*
IF USED([ESTR])
   SELE ESTR
   USE
ENDIF
*
RETURN

****************** ????? VETT ?????
* El Procedimiento AbreDbfPro No llama a Otro
*******************
FUNCTION AbreDbfPro
*******************
*
IF !USED([CFPRO])
   SELE 0
   USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DFPRO])
   SELE 0
   USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.

****************** ????? VETT ?????
* El Procedimiento ExtAlmCen llama a : 
* - DO ALMpdsm2 WITH .T.
* - DO ALMpcsm2 WITH .T.
*******************
PROCEDURE ExtAlmCen && Extornamos ingresos y/o salidas de almacen
*******************
PARAMETER ANULAR,LsNroDoc,LsSubAlm,LsCodMat,BorraItem
IF !USED([ESTA])
   USE ALMESTCM ORDER ESTA01 ALIAS ESTA IN 0
   IF !USED()
       DO F1msgerr WITH [No se puede actualizar archivo almestcm.dbf]
       RETURN
   ENDIF
ENDIF
*
IF !USED([ESTR])
   USE ALMESTTR ORDER ESTR01 ALIAS ESTR IN 0
   IF !USED()
       DO F1msgerr WITH [No se puede actualizar archivo almesttr.dbf]
       RETURN
   ENDIF
ENDIF
*
m.CurrArea = ALIAS()
LsNroDoc  = PADR(LsNroDoc,LEN(DTRA.NroRef))
LsLLave   = ZsTpoRef+LsNroDoc+LsCodMat+LsSubAlm
SELE DTRA
SET ORDER TO DTRA04
SEEK LsLlave
SCAN WHILE TpoRef+NroRef+CodMat+SubAlm=LsLlave
     m.CurReg = RECNO()
     IF ANULAR AND USED([CTRA])
        IF SEEK(SubAlm+TipMov+CodMov+NroDoc,[CTRA]) AND CTRA.FLGEST#[A]
           SELE CTRA
           =F1_RLOCK(0)
           REPLACE FlgEst WITH [A]
           REPLACE Observ WITH [*** A N U L A D O ***]
           UNLOCK
           SELE DTRA
        ENDIF
     ENDIF
     =F1_RLOCK(0)
     IF ANULAR OR BorraItem
        DELETE
     ENDIF
     IF TipMov = [I]
        DO ALMpdsm2 WITH .T.
     ELSE
        DO ALMpcsm2 WITH .T.
     ENDIF
     IF ANULAR OR BorraItem
     ELSE
        REPLACE CanDes WITH 0
     ENDIF
     UNLOCK
     IF m.CurReg<>RECNO()
        GO m.CurReg
     ENDIF
ENDSCAN
SET ORDER TO DTRA01
IF USED([ESTA])
   SELE ESTA
   USE
ENDIF
*
IF USED([ESTR])
   SELE ESTR
   USE
ENDIF
*
SELE (m.CurrArea)

*+-----------------------------------------------------------------------------+
*Ý ArrConfig   Carga arreglo de configuraci¢n para las actualizaciones de alma-Ý
*Ý             cen por producci¢n.                                             Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
****************** ????? VETT ?????
* El Procedimiento ArrConFig No llama a Otro
******************
FUNCTION ArrConfig
******************
IF !USED([CFTR])
   USE ALMCFTRA ORDER CFTR02 ALIAS CFTR IN 0
   IF !USED([CFTR])
      DO F1MSGERR WITH [No es posible abrir archivo de configuraci¢n]
      RETURN .F.
   ENDIF
ENDIF
PRIVATE K
SELE CFTR

GO TOP
K = 0
SCAN FOR eval(lsmovpro)
     K=K+1
     IF ALEN(aTipMov)<K
        DIMENSION aTipmov(K+5),aCodMov(K+5),aCmpEva(K+5),aEvalua(K+5),;
              aPorP_T(K+5),aCmpAct1(K+5),aCmpAct2(K+5),aDesMov(K+5),;
              aHayMov(K+5),aConFig(K+5,2)
     ENDIF
     aTipMov(K)  = TipMov
     aCodMov(K)  = CodMov
     aDesMov(K)  = DesMov
     aCmpEva(K)  = CmpEva
     aEvalua(K)  = Evalua
     aPorP_T(K)  = PorP_T
     aCmpAct1(K) = CmpAct1
     aCmpAct2(K) = CmpAct2
     aHayMov(K)  = .F.
     aConfig(K,1)=.f.
     aConfig(K,2)=.f.
ENDSCAN
USE
IF K>0
   DIMENSION aTipmov(K),aCodMov(K),aCmpEva(K),aEvalua(K),aPorP_T(K),;
             aCmpAct1(K),aCmpAct2(K),adesMov(K),aHayMov(K),aConfig(K,2)
   nTotMov = K
   RETURN .T.
ELSE
   RETURN .F.
ENDIF

****************** ????? VETT ?????
* El Procedimiento ChkMovAct No llama a Otro
******************
FUNCTION ChkMovAct
******************
PARAMETER Campo
PRIVATE K
FOR K=1 TO nTotMov
    IF UPPER(aCmpEva(K))=UPPER(Campo)
       LsEvalua   = aEvalua(K)
       aHayMov(K) = IIF(!aHayMov(K),EVAL(LsEvalua),.T.)
       EXIT
    ENDIF
ENDFOR
RELEASE K
RETURN

****************** ????? VETT ?????
* El Procedimiento ActAlmCen llama a :
* - ChkNroDoc(sNroO_T+LsSubAlm+LcTipMov+LsCodMov)
* - !GrbCabAlm(LsSubAlm,LcTipMov,LsCodMov,LsNroDoc,LdFchDoc)
* - DO GrbDetAlm
* - DO FinGrbAlm
* - DO VALORIZA
* - =chqmovalm_Pt()
******************
FUNCTION ActAlmCen
******************
PARAMETER m.NumEle
LcTipMov = aTipMov(m.NumEle)
LsCodMov = aCodMov(m.NumEle)
LsDesMov = aDesMov(m.NumEle)
LsNroDoc = []
LdFchDoc = dFchDoc
LsValor  = aCmpEva(m.NumEle)
LsEvalua = aEvalua(m.NumEle)
m.Insumos= !aPorP_T(m.NumEle)
LsCmpAct1= aCmpAct1(m.NumEle)
LsCmpAct2= aCmpAct2(m.NumEle)
IF F1_Alert("GENERAR "+aDesMov(m.NumEle),2)#1
   RETURN
ENDIF
LsDesCrip  = TRIM(LEFT(aDesMov(m.NumEle),30))
WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
IF m.Insumos
   SELE TEMPO
   GO TOP
   DO WHILE !EOF()
      IF !EVAL(LsEvalua)
         SKIP
         LOOP
      ENDIF
      LsSubAlm=SubAlm
      LsDesCrip = LsDesCrip +[ EN:]+LEFT(AlmNombr(LsSubAlm),13)
      WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
      LsNroDoc=ChkNroDoc(sNroO_T+LsSubAlm+LcTipMov+LsCodMov)
      IF !GrbCabAlm(LsSubAlm,LcTipMov,LsCodMov,LsNroDoc,LdFchDoc)
         DO F1MsgErr WITH [IMPOSIBLE GENERAR ]+aDesMov(m.NumEle)+[ EN ]+ALMNOMBR(LsSubALm)
         SELE TEMPO
         SKIP
         LOOP
      ENDIF
      LsDescrip = LsDescrip + [Gu¡a:]+LsNroDoc
      WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
      LnNroItm = 0
      zllave = NroDoc+SubAlm
      SCAN WHILE NroDoc+SubAlm=zLlave
           LfCandes = &LsValor.
           LsCodPrd = sCodPrd
           LsCodMat = CodMat
           LsUndVta = UndPro
           LfFactor = FacEqu
           LfPreUni = 0
           LfCnFmla = CnFmla
           LnRegGrb = RegGrb
           IF LfCanDes>=0 AND EVAL(LsEvalua)
              m.Rec_Alm=0
              DO GrbDetAlm
              SELE DO_T
              GO LnRegGrb
              =F1_RLOCK(0)
              REPLACE &LsCmpAct1. WITH .T.
              REPLACE &LsCmpAct2. WITH LcTipMov+LsCodMov+LsNroDoc
              UNLOCK
           ENDIF
           SELE TEMPO
      ENDSCAN
      IF LnNroItm >0
         SELE CTRA
         DO FinGrbAlm
      ENDIF
      SELE TEMPO
   ENDDO
ELSE
   DO VALORIZA   && VALORIZA PRODUCCION DE LA O_T
   LnNroItm = 0
   SELE PO_T
   SEEK sNroO_T
   SCAN WHILE NroDoc = sNroO_T FOR EVAL(LsEvalua)
        LsSubAlm = SubAlm
        LsDesCrip = LsDesCrip +[ EN:]+LEFT(AlmNombr(LsSubAlm),13)
        WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
        =chqmovalm_Pt()
        LsNroDoc=ChkNroDoc(sNroO_T+LsSubAlm+LcTipMov+LsCodMov)
        IF !GrbCabAlm(LsSubAlm,LcTipMov,LsCodMov,LsNroDoc,LdFchDoc)
           DO F1MsgErr WITH [Imposible actualizar almacen ]+AlmNombr(LsSubAlm)
           SELE PO_T
        ELSE
           LsDescrip = LsDescrip + [Gu¡a:]+LsNroDoc
           WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
           =SEEK(CodPrd,[CATG])
           LsCodPrd = []
           LsCodMat = CodPrd
           LfCanDes = CanFin
           LsUndVta = CATG.UndStk
           LfFactor = 1
           LdFchDoc = FchFin
           LFCnFmla = 0
           LfPreUni = ROUND(CostMn/CanFin,4)
           LfImpCto = ROUND(LfPreUni*LfCanDes,2)
           IF LfCanDes>=0
              DO GrbDetAlm
              SELE PO_T
              =F1_RLOCK(0)
              REPLACE &LsCmpAct1. WITH .T.
              REPLACE &LsCmpAct2. WITH LcTipMov+LsCodMov+LsNroDoc
              UNLOCK
              SELE CTRA
              DO FinGrbAlm
           ENDIF
           SELE PO_T
        ENDIF
   ENDSCAN
ENDIF
RETURN

****************** ????? VETT ?????
* El Procedimiento ChkNroDoc no llama a otro
******************
FUNCTION ChkNroDoc
******************
PARAMETER m.Llave
PRIVATE m.OrDer,m.CurrArea
m.CurrArea=ALIAS()
SELE CTRA
m.Order = ORDER()
m.NroDocAlm = SPACE(LEN(CTRA.NRODOC))
SET ORDER TO CTRA02
SEEK m.Llave
IF FOUND()
   m.NroDocAlm = CTRA.NroDoc
ENDIF
SET ORDER TO (m.Order)
SELE (m.CurrArea)
RETURN m.NroDocAlm

****************** ????? VETT ?????
* El Procedimiento GrbCabAlm llama a :
* - NROAST()
* - !CAPVARCFG()
* - DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
* - DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
* - DO ALMPCPP1            &&& Calculamos precio promedio
*******************
PROCEDURE GrbCabAlm
*******************
PARAMETERS m.SubAlm,m.TipMov,m.CodMov,m.NroDoc,m.FchDoc
PRIVATE GsSubAlm,GsCodAlm,lCrear,GsNomSub,m.CurrArea
m.CurrArea = ALIAS()
IF TYPE("GsCodAlm")#[C]
   GsCodAlm = [001]
ENDIF
* buscamos control de correlativos *
SELE CDOC
SET ORDER TO CDOC01
SEEK (m.SubAlm+m.TipMov+m.CodMov)
IF .NOT. FOUND()
   DO f1msgerr WITH [Correlativo no existe.]
   UltTecla = K_ESC
   SELE (m.CurrArea)
   RETURN .F.
ENDIF
**m.NroCor = RIGHT(REPLI("0",LEN(m.NroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.NroDoc))
m.NroCor=NROAST()
*
m.sDesMov = []
IF !CAPVARCFG()
   DO F1MSGERR WITH [No se puede actualizar almacen ** error en configuraci¢n]
   SELE (m.CurrArea)
   RETURN .F.
ENDIF

m.nCodMon = 1
IF m.lMonUsa
   m.nCodMon = 2
ENDIF
m.fTpoCmb = 1.00
m.sObserv = SPACE(LEN(CTRA.Observ))
m.sNroRf1 = SPACE(LEN(CTRA.NroRf1))
m.sNroRf2 = SPACE(LEN(CTRA.NroRf2))
m.sNroOdt = m.sNroO_T
m.sCodCli = []
m.sCodPro = []
m.sCodVen = []
m.sCodAux = []
IF m.lPidCli
   m.sCodAux = SPACE(LEN(m.sCodCli))
ENDIF

IF m.lPidPro
   m.sCodAux = SPACE(LEn(m.sCodPro))
ENDIF

m.fImpBrt = 0.00
m.fImpTot = 0.00
m.fImpIgv = 0.00
m.fPorIgv = 0.00

lCrear = EMPTY(m.NroDoc)

IF lCrear
   m.NroDoc = m.NroCor     && Correlativo
ENDIF
** Grabando cabecera **
=F1QEH("GRAB_DBFS")
IF m.lPidCli
   m.sCodCli = m.sCodAux
ENDIF
IF m.lPidPro
   m.sCodPro = m.sCodAux
ENDIF
UltTecla = 0
IF lCrear                  && Creando
   SELE CDOC
   IF .NOT. F1_RLock(5)
      UltTecla = K_ESC
      SELE (m.CurrArea)
      RETURN .F.
   ENDIF
   SELECT CTRA
   SEEK (m.SubALm + m.TipMov + m.CodMov + m.NroDoc )
   IF FOUND()
      m.NroDoc = RIGHT(REPLI("0",LEN(m.NroDoc)) + LTRIM(STR(CDOC->NroDoc)), LEN(m.NroDoc))
      SEEK (m.SubALm + m.TipMov + m.CodMov + m.NroDoc )
      IF FOUND()
         DO f1msgerr WITH [Registro creado por otro usuario.]
         UltTecla = K_ESC
         SELE (m.CurrArea)
         RETURN .F.
      ENDIF
   ENDIF
   APPEND BLANK
   IF .NOT. F1_RLock(5)
      UltTecla = K_ESC
      SELE (m.CurrArea)
      RETURN .F.
   ENDIF
   REPLACE CTRA->CodAlm WITH GsCodAlm
   REPLACE CTRA->SubAlm WITH m.SubAlm
   REPLACE CTRA->TipMov WITH m.TipMov
   REPLACE CTRA->CodMov WITH m.CodMov
   REPLACE CTRA->NroDoc WITH m.NroDoc
   SELECT CDOC
  *IF m.NroDoc >= RIGHT(REPLI("0",LEN(m.NroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.NroDoc))
  *   REPLACE CDOC->NroDoc WITH CDOC->NroDoc + 1
  *ENDIF
  *UNLOCK

   =NROAST(m.NroDoc)
   SELECT CTRA
ELSE
   *** Rectifica cambios hechos en la cabezera, cambien en el cuerpo del **
   *** documento.                                                        **
   IF CTRA->FchDoc != m.FchDoc .OR. ;
      CTRA->CodPro != m.sCodPro .OR. ;
      CTRA->CodVen != m.sCodVen .OR. ;
      CTRA->CodCli != m.sCodCli .OR. ;
      CTRA->NroOdt != m.sNroOdt .OR. ;
      CTRA->CodMon != m.nCodMon .OR. ;
      CTRA->TpoCmb != m.fTpoCmb .OR. ;
      CTRA->CodPrd != m.sCodPrd .OR. ;
      CTRA->FBatch != fFactor
      SELE DTRA
      LsLLave  = m.SubAlm+m.TipMov+m.CodMov+m.NroDoc
      SEEK LsLLave
      DO WHILE LsLLave = (SubAlm+TipMov+CodMov+NroDoc) .AND. ! EOF()
         IF f1_RLOCK(5)
            RegAct = RECNO()
            lAcPre = ( m.FchDoc <> FchDoc ) .OR. ( m.nCodMon <> CodMon ) ;
                     .OR. ( m.fTpoCmb <> TpoCmb )
            lCmFch = m.FchDoc  > FchDoc  && Barrer desde el principio
            REPLACE FchDoc WITH m.FchDoc    && OJO ALTERA EL PROMEDIO
            REPLACE CodPro WITH m.sCodPro
          **REPLACE CodVen WITH m.sCodVen
            REPLACE CodCli WITH m.sCodCli
            REPLACE CodMon WITH m.nCodMon    && OJO ALTERA EL PROMEDIO
            REPLACE TpoCmb WITH m.fTpoCmb    && OJO ALTERA EL PROMEDIO
            REPLACE CodPrd WITH m.sCodPrd
            REPLACE TpoRef WITH ZsTpoRef
            REPLACE NroRef WITH m.sNroOdt
            REPLACE FBatch WITH fFactor
            *
            lAcCsmo=m.lModCsm AND (CTRA.FBatch<>fFactor OR CodPrd<>m.sCodPrd ;
                    OR lAcPre)
            IF lAcCsmo
               DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
            ENDIF
            *
            * ACTUALIZACION DE TRANSFORMACIONES
            *
            lActTra=m.lAfeTra AND (CTRA.FBatch<>fFactor OR CodPrd<>m.sCodPrd ;
                    OR lAcPre)
            IF lActTra
               DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
            ENDIF
            *
            IF lAcPre
               IF lCmFch
                  * Para Regenerar el precio promedio desde el principio *
                  xCodmm = CodMat
                  SET ORDER TO DTRA03
                  SEEK xCodmm
               ENDIF
               DO Almpcpp1            &&& Calculamos precio promedio
               SET ORDER TO DTRA01
               GOTO RegAct
            ENDIF
            IF lAcCsmo
               DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov, Candes
            ENDIF
            *
            IF lActTra
               DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov, Candes
            ENDIF
            *
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT CTRA
ENDIF
REPLACE CTRA->FchDoc  WITH m.FchDoc
REPLACE CTRA->NroRf1  WITH m.sNroRf1
REPLACE CTRA->NroRf2  WITH m.sNroRf2
REPLACE CTRA->NroOdt  WITH m.sNroOdt
REPLACE CTRA->CodVen  WITH m.sCodVen
REPLACE CTRA->CodPro  WITH m.sCodPro
REPLACE CTRA->CodCli  WITH m.sCodCli
REPLACE CTRA->CodMon  WITH m.nCodMon
REPLACE CTRA->TpoCmb  WITH m.fTpoCmb
REPLACE CTRA->Observ  WITH m.sObserv
REPLACE CTRA->CodPrd  WITH m.sCodPrd
REPLACE CTRA->FBatch  WITH fFactor
*
REPLACE CTRA->AlmOri  WITH ZsTpoRef
*

*
SELE (m.CurrArea)
RETURN .T.

****************** ????? VETT ?????
* El Procedimiento GrbDetAlm llama a :
* DO ALMpdsm2 WITH .T.
* DO ALMpcsm2 WITH .T.
* DO ALMpcsm1
* DO ALMpdsm1
*******************
PROCEDURE GrbDetAlm
*******************
PRIVATE LsNroO_T
m.Reg_Act = 0
m.Ingreso = INLIST(LcTipMov,[I],[R])
LsNroO_T  = PADR(sNroO_T,LEN(DTRA.NroRef))
SELE DTRA
SET ORDER TO DTRA04
SEEK ZsTpoRef+LsNroO_T+LsCodMat+LsSubAlm+LcTipMov+LsCodMov+LsNroDoc
IF FOUND()
   DO WHILE !RLOCK()
   ENDDO
   m.Reg_Act = RECNO()
   LnNroItm = NroItm
   IF m.Ingreso
      DO ALMpdsm2 WITH .T.
   ELSE
      DO ALMpcsm2 WITH .T.
   ENDIF
   REPLACE CanDes WITH 0
   UNLOCK
   IF LfCandes<=0
      RETURN
   ENDIF
ELSE
   IF LfCandes<=0
      RETURN
   ENDIF
   APPEND BLANK
   m.Reg_Act = RECNO()
   LnNroItm = LnNroItm + 1
ENDIF
IF RECNO()<>m.Reg_Act AND m.Reg_Act>0
   GO m.Reg_Act
ENDIF
DO WHILE !RLOCK()
ENDDO
REPLACE CodAlm WITH GsCodAlm
REPLACE SubAlm WITH LsSubAlm
REPLACE TipMov WITH LcTipMov
REPLACE CodMov WITH LsCodMov
REPLACE NroDoc WITH LsNroDoc
REPLACE FchDoc WITH LdFchDoc
REPLACE CodMat WITH LsCodMat
REPLACE CanDes WITH LfCanDes
REPLACE UndVta WITH LsUndVta
REPLACE Factor WITH LfFactor
REPLACE CodPrd WITH LsCodPrd
REPLACE FBatch WITH fFactor
REPLACE CnFmla WITH LfCnFmla
*
REPLACE TpoRef WITH ZsTpoRef    && Generado autom ticamente por producci¢n.
*
REPLACE NroItm WITH LnNroItm
*
REPLACE CodMon WITH m.nCodMon
REPLACE TpoCmb WITH m.fTpoCmb
REPLACE CodPro WITH m.sCodPro
**REPLACE CodVen WITH m.sCodVen
REPLACE CodCli WITH m.sCodCli
REPLACE User   WITH GsUsuario
REPLACE NroRef WITH m.sNroOdt
*
REPLACE CTRA.NroItm WITH CTRA.NroItm + 1
*
IF m.lPidPco
   replace preuni with LfPreUni
   replace ImpCto WITH LfImpCto
   REPLACE DTRA->CodAjt WITH "A"
ELSE
   REPLACE DTRA->CodAjt WITH " "
ENDIF
*
IF m.Ingreso
   DO ALMpcsm1
ELSE
   DO ALMpdsm1
ENDIF
UNLOCK
*IF ALEN(aImprimir)<nNumItmI+1
*   DIMENSION aImprimir(nNumItmI + 5)
*ENDIF
*nNumItmI = nNumItmI + 1
*aImprimir(nNumItmI)=SubAlm+TipMov+CodMov+NroDoc+CodMat
RETURN

****************** ????? VETT ?????
* El Procedimiento FinGrbAlm no llama a otro
*******************
PROCEDURE FinGrbAlm
*******************
=F1QEH("OK")
SELE CTRA
UNLOCK
*IF LcTipMov=[I]
*   DO pEmision IN AlmpMI1a
*ELSE
*   DO pEmision IN AlmpMS1a
*ENDIF
RETURN

****************** ????? VETT ?????
* El Procedimiento VALORIZA no llama a otro
******************
PROCEDURE VALORIZA
******************
priva xnvalmn, xnvalus, xncanfin,ii
store 0 to xnvalmn, xnvalus, xncanfin
xncanfin = co_t.canfin
sele dtra
set order to dtra04
seek ZsTpoRef + snroo_t
if found()
   scan while tporef=ZsTpoRef and nroref=snroo_t and !eof()
        lpro_term=.f.
        for ii=1 to ntotmov
            if atipmov(ii)+acodmov(ii)=tipmov+codmov
               if aporp_t(ii)
                  lpro_term=.t.
               endif
               exit
            endif
        endfor
        if lpro_term
           loop
        endif
        if tipmov = [S]
           xnvalmn = xnvalmn + impnac
           xnvalus = xnvalus + impusa
        else
           xnvalmn = xnvalmn - impnac
           xnvalus = xnvalus - impusa
        endif
   endscan
endif
*
sele po_t
xnreg_act = recno()
seek snroo_t
if found()
   scan while nrodoc = snroo_t and !eof()
        do while !rlock()
        enddo
        repla costmn with iif(xncanfin<>0,round(xnvalmn*canfin/xncanfin,2),0)
        repla costus with iif(xncanfin<>0,round(xnvalus*canfin/xncanfin,2),0)
        unlock
   endscan
endif
return

****************** ????? VETT ?????
* El Procedimiento ChqMovalm_Pt llama a :
* DO ExtAlmCen WITH .T.,NroDoc,SubAlmA,CodPrd
*********************
Function ChqMovalm_Pt
*********************
PRIVATE AREA_ACT
AREA_ACT=alias()
IF EMPTY(CodP_t)
	return .f.
ENDIF
*
IF SubAlm#SubAlmA AND !EMPTY(SubAlmA)
	DO ExtAlmCen WITH .T.,NroDoc,SubAlmA,CodPrd
ENDIF
*
IF CodPrd#CodPrdA AND !EMPTY(CodPrdA)
    DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodPrdA
endif
*
SELE (Area_Act)
return .t.

****************** ????? VETT ?????                    &&&& JCTA
* El Procedimiento CapVarCfg no llama a otro
*******************
PROCEDURE CapVarCfg
*******************
** Definiendo Variables a necesitar **
IF !USED([CFTR])
   USE ALMCFTRA ORDER CFTR01 ALIAS CFTR IN 0
   IF !USED([CFTR])
      RETURN .F.
   ENDIF
ENDIF

SELE CFTR
SEEK m.TipMov+m.CodMov
m.sDesMov = LEFT(DESMOV,30)
m.lPidRf1 = CFTR->PidRf1
m.lPidRf2 = CFTR->PidRf2
m.lPidRf3 = CFTR->PidRf3
m.GloRf1  = CFTR->GloRf1
m.GloRf2  = CFTR->GloRf2
m.GloRf3  = CFTR->GloRf3
m.lPidVen = CFTR->PidVen
m.lPidCli = CFTR->PidCli
m.lPidPro = CFTR->PidPro
m.lPidOdT = CFTR->PidOdT
m.lModPre = CFTR->ModPre
m.lUndStk = CFTR->UndStk .OR. EOF()
m.lUndVta = CFTR->UndVta
m.lUndCmp = CFTR->UndCmp
IF ! m.lUndVta .and. ! m.lUndCmp
   m.lUndStk = .t.
ENDIF
m.lModCsm = CFTR->ModCsm
*
m.lAfeTra = CFTR->AfeTra
*
m.lExtPco = CFTR->ExtPco
m.lPidPco = CFTR->PidPco
m.lMonNac = CFTR->MonNac
m.lMonUsa = CFTR->MonUsa
m.lMonElg = CFTR->MonElg
m.lStkNeg = CFTR->StkNeg
if ! m.lMonElg .and. ! m.lMonUsa
   m.lMonNac = .t.
   m.lMonElg = .f.
   m.lMonUsa = .f.
ENDIF
USE
RETURN .T.
