*+---------------+-------------------------------------------------------------+
*| Nombre        | Cmpcscxs.prg                                                |
*+---------------+-------------------------------------------------------------|
*| Sistema       | LOGISTICA DE COMPRAS   - FOXPRO 2.6                         |
*+---------------+-------------------------------------------------------------|
*| Autor         | VETT                   Telf: 4841538 - 9411837              |
*+---------------+-------------------------------------------------------------|
*| Ciudad        | LIMA , PERU                                                 |
*+---------------+-------------------------------------------------------------|
*| Direcci¢n     | Av. Arredondo 175 - 202 Urb.Ingenieria S.M.P.               |
*+---------------+-------------------------------------------------------------|
*| Prop¢sito     | Consulta de stock consolidado por sede.                     |
*+---------------+-------------------------------------------------------------|
*| Creaci¢n      | 08/10/97                                                    |
*+---------------+-------------------------------------------------------------|
*| Actualizaci¢n | 02/MAR/1999   Consumos a la Fecha                           |
*| Actualizacion | 31/MAR/2006   Adaptación a VFP                              |
*+---------------+-------------------------------------------------------------+
m.ParaAqui=.F.
*!*	IF TYPE([K_ESC])=[U]
*!*	   PUBLIC k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,k_f_der,;
*!*	          k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,k_f4,k_f5,k_f6,k_f7,;
*!*	          k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,k_sf6,k_sf7,k_sf8,k_sf9,;
*!*	          k_ctrlw,k_lookup,k_borrar,k_esc


*!*	   STORE 0 TO k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,;
*!*	              k_f_der,k_f_der,k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,;
*!*	              k_f4,k_f5,k_f6,k_f7,k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,;
*!*	              k_sf6,k_sf7,k_sf8,k_sf9,k_ctrlw,k_lookup,k_borrar,k_esc

*!*	   do def_teclas in Belcsoft
*!*	   PUBLIC GsClfPro,GsBusca
*!*	   GsClfPro = [01 ] &&& Clasificaci¢n de los proveedores
*!*	   GsBusca  = [Cmpselec]
*!*	ENDIF

*!*	IF TYPE([C_LINEA])=[U]
*!*	   STORE "" TO C_Fondo,C_Linea,C_Say,C_Get,C_Sayr
*!*	   do def_color  in Belcsoft
*!*	ENDIF
**
sModulo = [PROGCMP]
**
*=F1_BASE(GsNomCia,[CONSULTA DE STOCK POR SEDES],"USUARIO:"+GsUsuario,GsPeriodo)
STORE '' TO lReproceso,lPone_En_0,lOtroSist,m.Estado,m.dFchIni,m.dFch1,m.dFch2,M.DFCHCMP,;
nMesIni,nMEsFin,m.CodMon,m.Cuales1,m.Cuales2,m.Cuales3,m.Cuales4,m.Tipo1,nSedes,m.CodMatD,m.CodMatH,LnNumAlma,vCodAlma,;
CStkAct,CStkMin,CStkDia,CStkCri,CDetAlma,m.tipobus

lReproceso = .F.
lPone_En_0 = .F.
lOtroSist  = .F.
m.Estado   = 4
m.tipobus = 2
m.dFchIni=cTOd([01/]+TRAN(_MES,[@L ##])+[/]+tran(_ANO,[9999]))
m.dFch1  =cTOd([01/]+TRAN(_MES,[@L ##])+[/]+tran(_ANO,[9999]))
m.dFch2  =GdFecha
M.DFCHCMP =date() 
nMesIni = _MES
nMEsFin = _MES
m.CodMon = 1
m.Cuales1 = 1  && Activo,Inactivos,todos
m.Cuales2 = 3  && Stock minimo, sin stock minimo,todos
m.Cuales3 = 3  && Con stock ,sin stock , todos
m.Cuales4 = 1  && Todos,Criticos,No criticos
m.Tipo1   = 1  && Formato1,Formato2  
nSedes = 0
DO FORM cmp_CmpCSCXS
RETURN
*******************
PROCEDURE GenTempo1
*******************
*!*	IF USED('TEMPO')
*!*		USE IN TEMPO
*!*	ENDIF

*!*	IF USED('TEMPO2')
*!*		USE IN TEMPO2
*!*	ENDIF
*!*	IF USED('TEMPORAL')
*!*		USE IN TEMPORAL
*!*	ENDIF


DIMENSION vTransac(10)
store [] to vTransac
*
ntr=0
SELE CFTR
SCAN FOR MODCSM or AFETRA
	ntr=ntr+1
	if alen(vtransac)<ntr
		dimension vtransac(ntr+5)
	endif
	vTransac(ntr)=tipmov+codmov
ENDSCAN
*
if ntr<>0
	dimension vTransac(ntr)
endif
*
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
** Capturamos las sedes validas **
IF !USED([SEDE])
   SELE 0
   *USE SEDES ALIAS SEDE
   LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
   LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
   LoDatAdm.Abrirtabla('ABRIR','SEDES','SEDE')
   RELEASE LoDatAdm
   IF !USED()
      DO F1MSGERR WITH [Archivo de sedes no existe...!!! ]
      RETURN
   ENDIF
ENDIF
SELE SEDE
SET FILTER TO !(UPPER(Nombre)=[CENTRAL]) && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,3)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*,A*
USE
**
FOR k = 1 TO nSedes
	CNumAlm=[TA]+vSedes(K,1)
    CStkAct=[S]+vSedes(K,1)
    CStkMin=[M]+vSedes(K,1)
	CStkDia=[D]+VSedes(K,1)
	CStkCri=[C]+VSedes(K,1)
	CDetAlma=[DA]+VSedes(K,1)
	ALTER table tempo ADD COLUMN &CNumAlm N(4)
	ALTER table tempo ADD COLUMN &CStkAct n(14,4)
	ALTER table tempo ADD COLUMN &CStkMin n(14,4)
	ALTER table tempo ADD COLUMN &CStkDia N(6)
	ALTER table tempo ADD COLUMN &CstkCri c(4)
	ALTER table tempo ADD COLUMN &CDetAlma c(50)
endfor
**
SELE CALM
SET RELA TO SubAlm INTO ALMA
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.COdMatH)+CHR(255)
**
XFOR1=[.T.]
DO CASE
   CASE m.Cuales1 = 1
        XFOR1=[!CATG.Inactivo]
   CASE m.Cuales1 = 2
        XFOR1=[CATG.Inactivo]
   CASE m.Cuales1 = 3
        XFOR1=[.T.]
ENDCASE
**
XFOR2=[.T.]
DO CASE
   CASE m.Cuales2 = 1
        XFOR2=[LfStkIniT>0]
   CASE m.Cuales2 = 2
        XFOR2=[LfStkIniT=<0]
   CASE m.Cuales2 = 3
        XFOR2=[.T.]
ENDCASE
**
XFOR3=[.T.]
DO CASE
   CASE m.Cuales3 = 1
        XFOR3=[lHayStkMin]
   CASE m.Cuales3 = 2
        XFOR3=[!LHayStkMin]
   CASE m.Cuales3 = 3
        XFOR3=[.T.]
ENDCASE
XFOR4=[.T.]
DO CASE
   CASE m.Cuales4 = 1
        XFOR4=[.T.]
   CASE m.Cuales4 = 2
        XFOR4=[!EMPTY(Flag)]
   CASE m.Cuales4 = 3
        XFOR4=[EMPTY(Flag)]
ENDCASE
XlFiltro = XFOR1+[ AND ]+XFOR2+[ AND ]+XFOR3+[ AND ]+XFOR4
**

**
SELE CATG
SEEK m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
DIMENSION LnNumAlma(nSedes)
DIMENSION vCodAlma(nSedes,10)
STORE 0 TO LnNumAlma
STORE [] TO vCodAlma
 
SCAN WHILE COdMat<=m.CodMatH FOR !Inactivo
     GrbMesesAnt=.F.
     LfStkMinF  = 0
         ***
		 GenRepoDet =.T.
   	 	 LsStkMin = [STKM]+TRAN(MONTH(m.Dfch1),[@L ##])
		 GdFchIni = m.dFch1
		 GdFchFin = m.dFch2
		 StkIniAlm = .T.	
  	     WAIT WINDOW COdMat+[ ]+DesMat NoWAIT
  	    
		 DiaxMes  = DAY(GdFchFin)
         ***
	     LsCodMat=CATG.CodMat
	     LfStkIniT = 0
	     LfStkMinT = 0
	     m.Nivel   = [D01]
	     STORE 0 TO m.TStkIni,m.TStkFin,m.TCmpMes,m.TCsmMes
	     ** Stock por sedes **
	     FOR K=1 TO nSedes
	         LfStkINi=0
      	     LfStkMin  = 0      	     
      	     SELE TEMPO	
      	     SET ORDER To temp01		
			 SEEK m.Nivel+LsCodMat
	         IF !FOUND()
			    APPEND BLANK
	   		    REPLACE Nivel  WITH m.Nivel
			    REPLACE CodMat WITH LsCodMat
		        REPLACE DesMat WITH LEFT(TRIM(CATG.DesMat),LEN(CATG.DesMat)-4)+[ ]+CATG.UndStk
			 ENDIF
		     SELE CALM
		     SEEK LsCodMat
		     SCAN WHILE CodMat=LsCodMat FOR ALMA.codsed=vSedes(K,1)		     	
			     *LnNumAlma = LnNumAlma +1
			     CStkActA = [A]+vSedes(K,1)+ALLTRIM(SubAlm)&&STR(LnNumAlma,1)
			     LfStkInia=round(GOCFGALM.CapStkAlm(SubAlm,CodMat,m.dfch1),1) &&calcula el stock inicial a la fecha indicada de stock
				 LfStkIni = LfStkIni + LfStkInia
		         LfStkMin = LfStkMin + round(&LsStkMin.,1)&&calcula el stock minimo al que puede estar un material en almacen	          		                
		         
  	 		     SELECT tempo
  	 		     lnregactual  = RECNO()
		         IF !existeCampo(CStkActA)
			         ALTER table tempo ADD COLUMN &CStkActA N(14,4)		         
			         GO lnregactual
			     ENDIF
			     
	 		     REPLACE &CstkActA. WITH LfStkInia
	 		     SELECT calm 
		     ENDSCAN
	     	 CNumAlm=[TA]+vSedes(K,1)
  		     CStkAct=[S]+vSedes(K,1)
		     CStkMin=[M]+vSedes(K,1)
		     CStkDia=[D]+VSedes(K,1)
		     CStkCri=[C]+VSedes(K,1)&&para stock critico de sede
		   
		     SELECT tempo
		     replace &CNumAlm WITH LnNumAlma(k)
		     REPLACE &CstkAct. WITH LfStkIni
		     REPLACE &CstkMin. WITH LfStkMin
		     
		     IF LfStkMin>0
		        REPLACE &CstkDia. WITH ROUND(LfStkIni*DiaXMes/LfStkMin,0) &&cantidad de días a la que se encuentra del stock minimo el stock  del material señalado
		        vSedes(K,3)=[*]
		     ENDIF
		     **************************************************stock critico por sede
		     lHayStkMins=(LfStkMin>0)
		     LcFlags =[ ]
		     IF CATG.TmpRep+CATG.StkSeg>ROUND(LfStkIni*DiaXMes/LfStkMin,0) AND lHayStkMins		        
		        LcFlags=TRAN(CATG.TmpRep+CATG.StkSeg,[99])+[D]
		     ENDIF
		     REPLACE &CstkCri. WITH LcFlags
		     **************************************************
		     LfStkIniT=LfStkIniT + LfStkIni
		     LfStkMinT=LfStkMinT + LfStkMin
		     
	     ENDFOR
	     SELE TEMPO
	     REPLACE ST WITH LfStkIniT
	     REPLACE MT WITH LfStkMinT
	     IF LfStkMinT>0
    	    REPLACE DT WITH ROUND(LfStkIniT*DiaXMes/LfStkMinT,0) &&cantidad total de días a la que se encuentra del stock minimo el stock  del material señalado en todas las sedes
	     ENDIF
		 IF DT<>ROUND(LfStkIniT*DiaXMes/LfStkMinT,0) AND LfStkMinT>0
    	 	REPLACE DT WITH ROUND(LfStkIniT*DiaXMes/LfStkMinT,0)
		 ENDIF
		 LfTotDias = 0
         lHayStkMin=(LfStkMinT>0)
         ** Saldo de ordenes de compra **
         ** Primero era con un select - sql , pero no es muy eficiente
       **IF SEEK(CodMat,[SO_C])
       **   REPLACE OC WITH SO_C.Sum_Exp_3
       **ENDIF
         *** Ahora con FDU             **
         =CapSdoO_C(CodMat) &&calcula la cantidad  saldo de ordenes de compras pendientes que aun no han sido entregadas
         					&&guarda en el temporal los dias correspondientes a esa cantidad,
         					&&la fecha de la primera y ultima orden de compra pendiente	
         					&&guarda el importe de pago que se tiene que hacer por la primer entrega que llegara de acuerdo a la forma de pago
         					&&guarda el tipo de moneda si es dolares o soles
         					&&guarda la fecha maxima hasta donde se puede pagar el pago de acuerdo a la forma de pago
   		 LfTotDias = TEMPO.dt + IIF(LfStkMinT#0,ROUND(TEMPO.OC*DiaXMes/LfStkMinT,0),0)
         REPLACE TD WITH LfTotDIas
         ** Consumos acumulados
		 replace CsmAcm with CAPCSMOMES(CodMat,m.dFchIni,m.dFch1)	&&guarda la cantidad de consumo hecho en ese material entre las fechas de inicio del mes y la fecha de stock indicado 	        	
	     **--------------------**
	     LsMsgErr = []
	     IF !lHayStkMin
	        LsMsgErr=LsMsgErr +[No Stk.Min. ]
	     ENDIF
	     IF CATG.TmpRep+CATG.StkSeg>DT AND lHayStkMin &&en base a todas las sedes
	        LcFlag =[*]
	        DO CASE
	           CASE CATG.TmpRep+CATG.StkSeg=30
	                LcFlag=[3]
	           CASE CATG.TmpRep+CATG.StkSeg=60
   	                LcFlag=[6]
	           CASE CATG.TmpRep+CATG.StkSeg=90
   	                LcFlag=[9]
	        ENDCASE
	        LcFlag=TRAN(CATG.TmpRep+CATG.StkSeg,[99])+[D]
	        REPLACE Flag WITH LcFlag
	     ENDIF
	     REPLACE Error WITH LsMsgErr
	     IF !EVAL(XlFiltro)
	        DELETE
	     ENDIF
	
     SELE CATG
ENDSCAN
SELE TEMPO
GO top	
DO WHILE !EOF()			     
	cads=""	
	FOR i=1 TO nSedes
		CDetAlma=[DA]+vSedes(i,1)
		CStkAct=[S]+vSedes(i,1)
		cad =""
		FOR j = 1 TO LnNumAlma(i)		
			CStkActA = [A]+vSedes(i,1)+vCodAlma(i,j) 
			*cad = cad + TRANSFORM(tempo.&CStkActA,'@Z 9999.99')+"  "
			cad = cad + iif(tempo.&Cstkacta<>0,PADL(TRIM(TRANSFORM(tempo.&CStkActA,'@Z 999999.99')),6," "),"          ")+"     "						
		endfor	
		cads = cads + iif(tempo.&Cstkact<>0,PADL(TRIM(TRANSFORM(tempo.&CStkAct,'@Z 999999.99')),6," "),"          ")+"     "						
		replace &CdetAlma. WITH cad
	ENDFOR
	replace detSede WITH cads
    skip	
ENDDO
SELECT tempo
GO top
FLUSH
*DO BROWS_PRG WITH .F.,[TEMPO]
*** REVISAR EN CLASE ADMNOVIS.BASE_GRID.CONFIGURARGRIDCONSULTA  PARA GENERAR GRID DINAMICO
*** EN TIEMPO DE EJECUCION  
*** VETT 26/10/2006 1:00 AM
DO FORM cmp_cmpcscxsbrowse
*******************
RETURN
FUNCTION existeCampo
*******************
PARAMETERS nombreCampo
numcampos = FCOUNT("tempo")
existe = .f.
FOR i=1 TO numcampos
	IF nombreCampo = FIELD(i,"tempo",0)
		existe = .t.
	endif
ENDFOR
IF existe =.f.
	LnNumAlma(k)=LnNumAlma(k)+1
	*if alen(vCodAlma,2)<LnNumAlma(k)
	*	dimension vCodAlma(K,LnNumAlma(k)+5)
	*endif
	vCodAlma(K,LnNumAlma(k))=calm.subalm	
	*if LnNumAlma(k)<>0
	*	dimension vCodAlma(K,LnNumAlma(k))
	*endif
ENDIF
RETURN existe

*******************
PROCEDURE AbrirDBFS
*******************
*CLOSE DATA
*SELE 0
*USE \BASE\ADMMTCMB ORDER TCMB01 ALIAS TCMB
*IF !USED()
*	RETURN .F.
*ENDIF
*
*USE CMPCO_CG ORDER CO_C01 ALIAS CO_C IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*USE CMPDO_CG ORDER DO_C01 ALIAS DO_C IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*
*USE flcjtbfp ORDER fmapgo ALIAS tbfp in 0
*IF ! USED()
*   CLOSE DATA
*   RETURN
*ENDIF
*
*USE flcjtdfp ORDER fmapgo ALIAS tdfp IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*
*use flcjtbdf order diaf01 alias diaf in 0
*if !used()
*	return .f.
*endif
*
*USE ALMTdivf ORDER DIVF01 ALIAS DIVF IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*
*USE ALMDTRAN ORDER DTRA01 ALIAS DTRA IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*
*USE ALMCFTRA ORDER CFTR01 ALIAS CFTR IN 0
*IF !USED()
*    RETURN .f.
*ENDIF
*
*USE ALMCATGE ORDER CATG01 ALIAS CATG IN 0
*IF !USED()
*   RETURN .f.
*ENDIF
*
*USE ALMCATAL ORDER CATA02 ALIAS CALM IN 0
*IF !USED()
*   RETURN .F.
*ENDIF
*
*sele 0
*USE ALMequni ORDER equn01 ALIAS equn 
*IF !USED()
*   RETURN .F.
*ENDIF
*set filter to empty(codmat)
*
*SELE 0
*USE ALMTALMA ORDER ALMA01 ALIAS ALMA
*IF !USED()
*   RETURN .f.
*ENDIF

** Archivo temporal  **
ArcTmp = PATHUSER+SYS(3)
SELE 0
CREAT TABL &ArcTmp. ( Nivel  C(3),;
                      CodMat C(LEN(CATG.COdMat)),;
                      DesMat C(LEN(CATG.DesMat)),;
                      M001 N(14,4),M002 N(14,4),M003 N(14,4),;
                      S001 N(14,4),S002 N(14,4),S003 N(14,4),;
                      D001 N(6)   ,D002 N(6)   ,D003 N(6),   ;
                      C001 C(4)   ,C002 C(4)   ,C003 C(4),   ;
                      ST N(14,4)  ,DT N(6)     ,flag C(4),   ;
                      TD N(6),   ;
                      OC N(14,4)  ,FchEnt1 D(8),FchEnt2 D(8),;
                      CM001 C(14)  ,CM002 C(14)  ,CM003 C(14),  ;
                      CS001 C(14)  ,CS002 C(14)  ,CS003 C(14),  ;
                      CD001 C(6)   ,CD002 C(6)   ,CD003 C(6),   ;
                      CST C(14)   ,CDT C(6),COC C(14), Error C(20),;
                      DocPag C(4),FchPag d(8) ,ImpPgo n(12,2),;
                      CsmAcm n(12,2)  )


USE &ArcTmp. ALIAS TEMPO EXCLUSIVE
IF !USED()
   RETURN .F.
ENDIF
INDEX ON Nivel+Codmat TAG temp01
SELE DO_C
SET ORDER TO DO_C05
SET RELA TO NroOrd INTO CO_C
IF _ANO>=1998
*	
	use cmpcoant order co_c01 alias co_cant in 0
	if !used()
	   return .f.
	endif
	use cmpdoant order do_c01 alias do_cant in 0
	if !used()
	   return .f.
	endif
	sele do_cant
	set order to do_c05
	set rela to nroord into co_cant
ENDIF
*
RETURN .T.
******************
PROCEDURE IMPRIMIR
******************
LsSubTit = []
SELE TEMPOral
GO TOP
IF EOF()
   DO F1MSGERR WITH "Fin de archivo" 
   *CLOSE DATA 
   RETURN
ENDIF
TstImp = []
sMensa = []
**---------- Impresi¢n ---------**
xFOR   = []
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
if m.tipo1=1
	sNomRep = [CMPcscxs]
else
	sNomRep = [CMPcscs2]
ENDIF
DO F0print WITH "REPORTS"
*CLOSE DATA
RETURN
*******************
PROCEDURE BROWS_PRG
*******************
PARAMETER lMostrar,m.Area
m.bTitulo = [PROGRAMA]
m.bDeta   = [PROGRAMA]
m.bTitBrow= [STOCK CONSOLIDADO POR SEDES AL ]+DTOC(m.DfCh1)
IF lMostrar
   m.bClave1 = []
   m.bClave2 = []
ELSE
   m.bClave1 = []
   m.bClave2 = []
ENDIF
sModulo = [CONSTOCK]
m.bFiltro = [.T.]
m.bCampos = CmpBrowse()
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []
PRIVATE nX0,nX1,nY0,nY1
nX0 = 00
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
******************
FUNCTION CmpBrowse
******************
PRIVATE K,CB
CB = 'Codmat:H=[Codigo]:9,DesMat:H=[Descripci_n]:30,'
DO CASE 
	CASE m.tipo1=1
		FOR K = 1 TO nSedes
		    CmpS = [S]+Vsedes(K,1)
		    CmpD = [D]+Vsedes(K,1)
		    CmpM = [M]+vSedes(K,1)
		    CadS = [CS]+Vsedes(K,1)
		    CadD = [CD]+Vsedes(K,1)
		    CadM = [CM]+vSedes(K,1)
		    NomS = vSedes(K,2)
		    CB=CB+[X]+Vsedes(K,1)+'=IIF(empty(&CadS.),&CmpS.,&CadS):'
		    CB=CB+'H=['+NomS+']:P=[9999999.9]:9,'
		    IF vSedes(K,3)=[*]
		       **CB=CB+[Y]+vsedes(k,1)+'=IIF(empty(&CadD.),&CmpD.,&CadD):H=[Dias]:P=[999999]:6,'
		       CB=CB+[Z]+Vsedes(k,1)+'=IIF(empty(&CadM.),&CmpM.,&CadM):H=[Stk.Min.]:P=[999999.99],'
		    ENDIF
		ENDFOR
	CASE m.tipo1=2
			CB=CB+'J=M001+M002+M003:H=[Stk.Min.]:P=[999999.99],'
ENDCASE	
CB = CB +[V]+'=IIF(EMPTY(CST),ST,CST):H=[Stock Tot.]:P=[9999999.9]:9,'
CB = CB +[W]+'=IIF(EMPTY(CDT),DT,CDT):H=[En Dias]:P=[999999]:6,'
CB = CB +'Flag:H=[Crt]:3,'
CB = CB +[S]+'=IIF(EMPTY(COC),OC,COC):H=[Sdo.O/C]:P=[9999999.9]:9,'
CB = CB +[FchEnt1:8,FchEnt2:8,]
CB = CB +[CsmAcm:H='Csmo.Acum.':P='9999,999.9',]
CB = CB + 'Error:20'
RETURN CB
****************
FUNCTION Critico
****************
DO CASE
   CASE Flag=[3]
        RETURN [30D]
   CASE Flag=[6]
        RETURN [60D]
   CASE Flag=[9]
        RETURN [90D]
   OTHER
        RETURN []
ENDCASE
********************
PROCEDURE CapSdoO_CA
********************
WAIT WINDOW [Calculando saldo de O/Compra pendientes] NOWAIT
xAreaAct=ALIAS()
LsNomArc1=PATHUSER+SYS(3)
SELECT Do_c.codmat, Do_c.desmat, SUM(Do_c.canped-DO_c.cANDES);
 FROM CMPDO_CG Do_c, CMPCO_CG Co_c;
 WHERE Do_c.nroord = Co_c.nroord;
   AND DTOS(Co_c.fchord) <= DTOS(m.dFch1);
   AND Co_c.flgest NOT IN ("C","A");
 GROUP BY Do_c.codmat;
 ORDER BY Do_c.codmat;
 INTO TABLE &LsNomArc1.
USE &LsNomArc1. ALIAS SO_C EXCLU
IF !USED()
   *CLOSE DATA
   RETURN
ENDIF
INDEX ON CODMAT TO SO_C01
SET ORDER TO SO_C01
SELE (xAreaAct)
RELEASE xAreaAct
RETURN
******************
FUNCTION CapSdoO_C
******************
PARAMETER PsCodMat
WAIT WINDOW [Calculando saldo de O/Compra pendientes] NOWAIT
xAreaAct=ALIAS()
LsNomArc1=PATHUSER+SYS(3)
STORE { , , } TO LDFchEnt1,LDFchEnt2,LdFchOrd
STORE 0 TO LfSaldo,LfSdoPry,LnCodMon
store [] to LsUltCmp,LsFmaPgo

if _ano >= 1998
	sele do_cant
	seek pscodmat
	scan while codmat=pscodmat for !inlist(co_cant.flgest,[CA]) and co_cant.fchord<=m.dfchCmp
	     if canped-candes>0
	        LfFacEqu=FacEqu
	        IF UndCmp#CATG.UndStk AND (!EMPTY(UndCmp) AND !EMPTY(CATG.UndStk))
	           IF UndCmp==CATG.UndCmp AND CATG.FacEqu#0
	              LfFacEqu=CATG.FacEqu
	           ELSE
	           	  =seek(CATG.UndStk+UndCmp,[EQUN])	
	           	  LfFacEqu=EQUN.FacEqu
	           ENDIF
	        ENDIF
	        IF LfFacEqu=0
	        	LfFacEqu = 1
	        ENDIF
	        lfsaldo = lfsaldo + (canped - candes)*lffacequ
	        if empty(ldfchent1)
	           ldfchent1 = IIF(EMPTY(FchProg),fchent,FchProg)
	           LfPreUni  = IIF(NroOrd=[N],PreUni,PreFob)
	           LfSdoPry  = LfSdoPry + ROUND((CanPed-CanDes)*LfPreUni,2)
	           LsUltCmp  = NroOrd
	           LdFchOrd  = FchOrd
	           =seek(NroOrd,[CO_cANT])
	           LsFmaPgo  = CO_CANT.FmaPgo
	           LnCodMon  = CO_CANT.CodMon
	        endif
	        ldfchent2 = iif(empty(FchProg),FchEnt,FchProg)
	     endif
	endscan
endif
*

*
SELE DO_C
SEEK PsCodMat
SCAN WHILE CodMat=PsCodMat FOR !INLIST(CO_C.FlgEst,[CA]) AND CO_C.FchOrd<=m.dFchCmp
     IF Canped-CandES>0
        LfFacEqu=FacEqu
        IF UndCmp#CATG.UndStk AND (!EMPTY(UndCmp) AND !EMPTY(CATG.UndStk))
           IF UndCmp==CATG.UndCmp AND CATG.FacEqu#0
              LfFacEqu=CATG.FacEqu
           ELSE
           	  =seek(CATG.UndStk+UndCmp,[EQUN])	
           	  LfFacEqu=EQUN.FacEqu
           ENDIF
        ENDIF
        IF LfFacEqu=0
        	LfFacEqu = 1
        ENDIF
        LfSaldo = LfSaldo + (Canped - CanDes)*LfFacEqu
        IF EMPTY(LdFchEnt1)
           ldfchent1 = IIF(EMPTY(FchProg),fchent,FchProg)
           LfPreUni  = IIF(NroOrd=[N],PreUni,PreFob)
           LfSdoPry  = LfSdoPry + ROUND((CanPed-CanDes)*LfPreUni,2)
           LsUltCmp  = NroOrd
           LdFchOrd  = FchOrd
           =seek(NroOrd,[CO_C])
           LsFmaPgo  = CO_C.FmaPgo
           LnCodMon  = CO_C.CodMon
        ENDIF
        LdfchEnt2 = iif(empty(FchProg),FchEnt,FchProg)
     ENDIF
ENDSCAN
*
SELE (xAreaAct)
REPLACE TEMPO.OC WITH LfSaldo
REPLACE TEMPO.FchEnt1 WITH LdFchEnt1
REPLACE TEMPO.FchEnt2 WITH LdFchEnt2
IF !EMPTY(LfSdoPry) OR !EMPTY(LsUltCmp) OR !EMPTY(LsFmaPgo)
	do add_val_pry with LfSdoPry,LnCodMon,LdFchEnt2,[TEMPO],LsFmaPgo,[],0,LsUltCmp
	SELE TEMPO
ENDIF
RETURN
*********************t
procedure add_val_pry
*********************
parameter Imp_pry,mon_pry,Fch_Pry,Area_Pry,Fpg_Pry,Nivel_Pry,Dias_pry,Ref_Pry
Store 0  To timpproy, iporc, iintporc,nCodMon,fTpoCmb,nPlazo
Select TDFP
Seek Fpg_Pry
if !found()
   *do F1MSGERR with [ERROR:Forma de Pago ]+Fpg_pry+[ No tiene detalle...]
   WAIT WINDOW  [ERROR:Forma de Pago ]+Fpg_pry+[ No tiene detalle...] NOWAIT 
   return 
endif
=seek(Fpg_Pry,[TBFP])
ncodmon = tbfp.codmon
fTpoCmb = T_Cmb_Mes(Fch_Pry)
**
**VecOpc(1)="S/."     && NUEVOS SOLES
**VecOpc(2)="US$"		&& DOLAR AMERICANO
**VecOpc(3)="CAN$"	&& DOLAR CANADIENSE
**VecOpc(4)="DM"		&& MARCO ALEMAN
**VecOpc(5)=[FS]		&& FRANCO SUIZO
**VecOpc(6)=[LS]		&& LIBRA ESTERLINA
**
DO CASE
	CASE Mon_Pry=nCodMon
		LfImpIni=Imp_Pry

	CASE Mon_Pry#nCodMon
		do case	
		    CASE Mon_pry=1
				LfImpIni=ROUND(Imp_Pry/fTpoCmb,2)
			case Mon_pry=2	
				LfImpIni=round(Imp_Pry*FtpoCmb,2)
			other
				LfImpIni=Imp_Pry				
		endcase			
ENDCASE 
LdfchIni = Fch_Pry
Scan while fmapgo = Fpg_Pry
    IF EMPTY(Dias_pry) 
		nplazo = ndias
	else
		nplazo = dias_pry		
	endif
	IF EMPTY(Nivel_Pry)
	    LsNivel = CdFcja
	ELSE
		LsNivel = Nivel_pry	    
    ENDIF
    
    iporc   = LfimpIni * porc / 100
    fchproy = LdFchIni + nplazo
    iintporc = iporc * int / 100
    timpproy = iporc + iintporc
    SELE DIAF
    diafsd = Seek(Dtos(fchproy),[diaf])
    Do While diafsd
       FchProy = FchProy + 1
       diafsd = Seek(Dtos(fchProy),[diaf])
    EndDo
    *
    IF nCodMOn=1
		LfValPry1 = tImpProy        
		LfValPry2 = ROUND(tImpProy/fTpoCmb,2)
	ELSE		
		LfValPry2 = tImpProy        
		LfValPry1 = ROUND(tImpProy*FTpoCmb,2)
    ENDIF
    sele (Area_Pry)
    do case
       case TBFP.FmaPgo=[1]
			LsDocPag = [FS/.]          
       case TBFP.FmaPgo=[2]
			LsDocPag = [FUS$]          
       case TBFP.FmaPgo=[3]
			LsDocPag = [LS/.]          
       case TBFP.FmaPgo=[4]
			LsDocPag = [LUS$]          
       case TBFP.FmaPgo=[7]
			LsDocPag = [FUS$]          
		OTHER
			LsDocPag = []	
    ENDCASE
    repla DocPag   WITH LsDocPag
    repla fchPag   with FchProy
    repla ImpPgo   with IIF(nCodMon=1,LfValPry1,LfValPry2)  
    unlock
    *
    sele tdfp
endscan
sele co_c
return 
********************
procedure T_cmb_mes
*******************
parameter _Fch
PRIVATE Area_act
Area_Act = ALIAS()
IF _Mes = 12
	LdFinMes=ctod([31/12/]+str(_ano,4,0))
ELSE
	LdFinMes=CTOD([01/]+TRAN(_MES+1,[@L ##])+str(_ano,4,0))-1
ENDIF
_TpoCmb=-1
yTpoCmb=-1
SELE TCMB
SEEK dtos(LdFinMes+1)
IF !FOUND() AND RECNO(0)>0
	go recno(0)
ENDIF
DO WHILE !BOF()
	skip -1
    IF TCMB.OfiVta>0
	    yTpoCmb= TCMB.OfiVTa
	    exit
	ENDIF
ENDDO
*
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
IF _TpoCmb=-1
   _TpoCmb = yTpoCmb
ENDIF
SELE (AREA_ACT)
RETURN _TpoCmb
*******************
FUNCTION CAPCSMOMES
*******************
parameter _CodMat,_Fecha1,_Fecha2
PRIVATE XfTotCsm,Area_Act,zz
Area_Act = ALIAS()
XfTotCsm=0
SELE DTRA
CURR_TAG=ORDER()
SET ORDER TO DTRA03
SEEK _CodMat+DTOS(_Fecha1)
IF !FOUND() and RECNO(0)>0
	GO RECNO(0)
ENDIF
SCAN WHILE CodMat=_CODMAT AND FchDoc<=_Fecha2
	FOR ZZ=1 TO ALEN(vTransac)
		IF vTransac(zz)=TipMov+Codmov
			IF Tipmov=[S]
				XfTotCsm=XfTotCsm + CanDes
			ELSE
				XfTotCsm=XfTotCsm - CanDes
			ENDIF
		ENDIF
	ENDFOR
ENDSCAN
SET ORDER TO (CURR_TAG)
SELE (Area_Act)
RETURN round(XfTotCsm,2)