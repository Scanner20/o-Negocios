*+---------------+-------------------------------------------------------------+
*| Nombre        | CmpiUltc.prg                                                |
*+---------------+-------------------------------------------------------------|
*| Sistema       | LOGISTICA DE COMPRAS   - FOXPRO 2.6                         |
*+---------------+-------------------------------------------------------------|
*| Autor         | VETT                   Telf: 4841538 - 9411837              |
*+---------------+-------------------------------------------------------------|
*| Ciudad        | LIMA , PERU                                                 |
*+---------------+-------------------------------------------------------------|
*| Direcci¢n     | M. Corpancho  250 Alt. Cdra. 3 Av. Arequipa - LIMA          |
*+---------------+-------------------------------------------------------------|
*| Prop¢sito     | Ultimas compras de insumos                                  |
*+---------------+-------------------------------------------------------------|
*| Creaci¢n      | 26/09/97                                                    |
*+---------------+-------------------------------------------------------------|
*| Actualizaci¢n | VETT  16/08/2010 05:18 PM 								   |	
*|               | : Integracion con control de produccion                     |                                                             |
*+---------------+-------------------------------------------------------------+
m.ParaAqui=.F.
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
   GsBusca  = [Cmpselec]
ENDIF
STORE '' TO sModulo,m.ultcom,lReproceso,lPone_En_0,lOtroSist,m.Estado,m.dFch1,;
m.dFch2,nMesIni,nMEsFin,m.CodMon,m.Cuales1,m.Cuales3,nSedes

**
sModulo = [PROGCMP]
**
*=F1_BASE(GsNomCia,[5 Ultimas compras x Insumo],"USUARIO:"+GsUsuario,GsPeriodo)
m.ultcom   = .F.
lReproceso = .F.
lPone_En_0 = .F.
lOtroSist  = .F.
m.Estado   = 4
m.dFch1   = CTOD([01/01/]+tran(_ANO,[9999]))
m.dFch2   = GdFecha
nMesIni   = _MES
nMEsFin   = _MES
m.CodMon  = 1
m.Cuales1 = 1  && Activo,Inactivos,todos
m.Cuales3 = 3  && Con stock ,sin stock , todos
nSedes = 0
DO form cmp_CmpiUltc

RETURN
*******************
PROCEDURE AbrirDbfs
*******************
sele 0
USE ALMequni ORDER equn01 ALIAS equn 
IF !USED()
   RETURN .F.
ENDIF
set filter to empty(codmat)
*
sele 0
use cmpdo_cg order do_C01 ALIAS DO_C
IF !USED()
   RETUR .F.
ENDIF
**
SELE 0
USE cmpCO_CG ORDER CO_C01 ALIAS Co_C
IF !USED()
   RETUR .F.
ENDIF
**
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   RETUR .F.
ENDIF
**
sele 0
use almcatal order cata02 alias calm
if !used()
   return .f.
endif   
**
SELE 0
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
IF !USED()
   RETUR .F.
ENDIF
**
arcAuxi=[\base\cia]+gscodcia+[\cbdmauxi.dbf]
SELE 0
USE (ArcAuxi) ORDER AUXI01 ALIAS AUXI
IF !USED()
   RETUR .F.
ENDIF
**
IF lReproceso
	sele 0
	USe \base\admmtcmb order tcmb01 alias TCMB
	IF !USED()
	   RETUR .F.
	ENDIF
	sele 0
	*
	ArcCatg_a=pathdef+[\cia]+gscodcia+[\c]+str(_ANO-1,4,0)+[\almcatge.dbf]
	IF FILE(ArcCatg_a)
		use (ArcCatg_a) ORDER CATG01 ALIAS CATG_A
		IF !USED()
		   RETUR .F.
		ENDIF
    ENDIF 
	*
	IF GsCodCia=[001] and _Ano=1999
		sele 0
		use catgenew order catg07 alias CATG_R
		IF !USED()
		   RETUR .F.
		ENDIF
		*
	endif		
ENDIF
**
SELE 0
ArcTmp=PATHUSER+SYS(3)
CREATE TABLE  (ArcTmp)  (   CodMat  C(8),;
						    UndStk  C(3),;
						    CodAux1 C(8),;
							NroO_C1 C(7),;	
							FchCmp1 D(8),;													  														
							PreCio1 N(12,3),;
							CodMon1 N(1),;
						    CodAux2 C(8),;
							NroO_C2 C(7),;													  														
							FchCmp2 D(8),;													  														
							PreCio2 N(12,3),;
							CodMon2 N(1),;
						    CodAux3 C(8),;
							NroO_C3 C(7),;													  														
							FchCmp3 D(8),;													  														
							PreCio3 N(12,3),;
							CodMon3 N(1),;
						    CodAux4 C(8),;
							NroO_C4 C(7),;													  														
							FchCmp4 D(8),;													  														
							PreCio4 N(12,3),;
							CodMon4 N(1),;
						    CodAux5 C(8),;
							NroO_C5 C(7),;													  														
							FchCmp5 D(8),;													  														
							PreCio5 N(12,3),;
							CodMon5 N(1),;
							StkMin  N(14,4))

USE (ArcTmp) ALIAS TMP EXCLU
INDEX ON CodMat TAG TMP01
SET ORDER TO TMP01
RETURN .T.
******************
PROCEDURE Gentempo
******************
LOCAL LoUltCmp as Calc_UltCmp OF SYS(5)+"\aplvfp\Classgen\Progs\Janesoft.prg" 
LoUltCmp=CREATEOBJECT("Calc_UltCmp")
aUltCmp=LoUltCmp.cap_ultcmp(m.CodMatD,m.CodMatH,m.cuales1,m.Cuales3,m.UltCom,lReproceso,'',m.dFch1,m.dFch2)

RETURN
*!*	**********************************
*!*	DEFINE CLASS Calc_UltCmp AS Custom 
*!*	**********************************
*!*	DIMENSION aUltCmp[6] 

*!*		FUNCTION Cap_UltCmp(m.CodMatD,m.CodMatH,m.cuales1,m.Cuales3,m.UltCom,lReproceso) as Array

*!*		m.CodMatD = TRIM(m.CodMatD)
*!*		m.CodMatH = TRIM(m.CodMatH)+CHR(255)
*!*		***
*!*		DO CASE
*!*			CASE m.Cuales1=1
*!*				Xfor1=[!CATG.Inactivo]	
*!*			CASE m.Cuales1=2
*!*				Xfor1=[CATG.Inactivo]	
*!*			CASE m.Cuales1=3
*!*				Xfor1=[.T.]	
*!*		ENDCASE
*!*		***
*!*		DO CASE
*!*			CASE m.Cuales3=1
*!*				Xfor2=[CATG.StkAct>0]	
*!*			CASE m.Cuales3=2
*!*				Xfor2=[CATG.StkAct<=0]	
*!*			CASE m.Cuales3=3
*!*				Xfor2=[.T.]	
*!*		ENDCASE
*!*		***
*!*		xFiltro=Xfor1+[ AND ]+Xfor2
*!*		***

*!*		SELE DO_C
*!*		SET ORDER TO DO_C06 DESCENDING  && La ultima compra primero VETT 2010/02/21
*!*		SET RELA TO NROORD INTO CO_C
*!*		SELE CATG
*!*		SEEK m.CodMatD
*!*		IF !FOUND() AND RECNO(0)>0
*!*			GO RECNO(0)
*!*		ENDIF
*!*		SCAN WHILE CodMat<=m.CodMatH FOR EVAL(XFiltro)
*!*			WAIT WINDOW CodMat +[ ]+DesMat+[ ]+UndStk NOWAIT
*!*			LsCodMat = CATG.CodMat	
*!*			LfStkMin = 0
*!*			*
*!*			* VERIFICA STOCK MINIMO SI ES ULTIMA COMPRA
*!*			*
*!*			if m.ultcom and !lReproceso
*!*				sele calm
*!*				seek LsCodMat
*!*			      SCAN WHILE CodMat = LsCodMat
*!*			             m.CodCmp = [STKM]+TRAN(_MES,"@L ##")
*!*			             LfStkMin = LfStkMin + &CodCmp.       
*!*			       ENDSCAN
*!*			       sele catg
*!*			endif
*!*			* 
*!*			LdFecha=m.dFch2
*!*			IF lReproceso 
*!*				NumCmp = 1
*!*			ELSE
*!*				NumCmp = 5
*!*			ENDIF	
*!*			*
*!*			SELE DO_C	    
*!*			SEEK LsCodMat+DTOS(m.dFch2)
*!*			IF !FOUND()
*!*				IF RECNO(0)>0
*!*			   		GO RECNO(0)
*!*			       	IF DELETED()
*!*				    	SKIP
*!*				   	ENDIF
*!*				ENDIF
*!*			ENDIF
*!*			SCAN WHILE CodMat=PADR(LsCodMat,LEN(DO_C.CodMat)) AND NumCmp>0
*!*				IF CO_C.FlgEst#[A] AND tpoO_C=[C] AND DO_C.FchOrd >= m.dFch1 AND  DO_C.FchOrd <= m.dFch2 
*!*			 	***-----------------***
*!*				  LfFacEqu=FacEqu
*!*			      IF UndCmp#CATG.UndStk AND (!EMPTY(UndCmp) AND !EMPTY(CATG.UndStk))
*!*			          IF UndCmp==CATG.UndCmp AND !INLIST(CATG.FacEqu,0,1) 
*!*			        	  LfFacEqu=CATG.FacEqu
*!*			          ELSE
*!*			       		  =seek(CATG.UndStk+UndCmp,[EQUN])	
*!*			       	 	  LfFacEqu=EQUN.FacEqu
*!*			          ENDIF
*!*			      ENDIF
*!*			 	  IF LfFacEqu=0
*!*					  LfFacEqu = 1
*!*			      ENDIF 
*!*			  		****--------------------***********
*!*			      SELE TMP
*!*			      SEEK LsCodMat
*!*			      IF !FOUND()
*!*					append blank
*!*			      ENDIF
*!*			      do while !rlock()
*!*			      enddo
*!*			      REPLACE CodMat WITH LsCodMat
*!*			      REPLACE UndStk WITH CATG.UndStk
*!*			      *
*!*			      if m.ultcom
*!*			         REPLACE StkMin WITH LfStkMin
*!*			      endif
*!*			      *
*!*			      Cmp1=[CodAux]+STR(NumCmp,1,0)
*!*			      Cmp2=[NroO_C]+STR(NumCmp,1,0)
*!*			      Cmp3=[Precio]+STR(NumCmp,1,0)
*!*				  Cmp4=[FchCmp]+STR(NumCmp,1,0)
*!*				  Cmp5=[CodMon]+STR(NumCmp,1,0)
*!*				  ***--------------------------------***
*!*				  ***--------------------------------***	        
*!*			      REPLACE (Cmp1)  WITH CO_C.CodAux
*!*			      REPLACE (Cmp2)  WITH DO_C.NroOrd
*!*			      REPLACE (Cmp3)  WITH DO_C.PreUni &&IIF(DO_C.NroOrd=[N],DO_C.PreUni,DO_C.PreFob) - AMAA 20-03-07
*!*			      REPLACE (Cmp4)  WITH DO_C.FchOrd
*!*			      REPLACE (Cmp5)  WITH CO_C.CodMon
*!*			      NumCmp = NumCmp - 1
*!*						      
*!*		  			XfPre=ROUND(TMP.Precio1/LfFacEqu,2)
*!*		  			XnMon=TMP.Codmon1
*!*		  			XdFch=TMP.FchCmp1
*!*		  			XfTcm = CO_C.TpoCmb
*!*		  			IF XfTcm<=0
*!*		  				DO F1msgerr WITH [Verifique tipo cambio al ]+DTOC(XdFch)+[ O/C:]+CO_C.NroOrd
*!*		  				XfTcm=GoCfgAlm.oentorno._tipocambio(XdFch)
*!*			  			IF XfTcm<=0
*!*			  				DO F1msgerr WITH [Verifique tipo cambio al ]+DTOC(XdFch)
*!*			  				XfTcm=1
*!*			  			ENDIF
*!*					ENDIF
*!*		  			XfPs=IIF(XnMon=1,XfPre,ROUND(XfPre*XfTcm,2))
*!*		  			XfPd=IIF(XnMon=2,XfPre,ROUND(XfPre/XfTcm,2))
*!*		  	      	IF lReproceso 
*!*			  			SELE CATG
*!*			  			Precio_S=[PS]+TRAN(_MES,[@L ##])	      		
*!*			  			Precio_D=[PD]+TRAN(_MES,[@L ##])	      		
*!*			  			=f1_rlock(0)
*!*			  			REPLACE (Precio_S) WITH XfPs
*!*			  			REPLACE (Precio_D) WITH XfPd
*!*			  			UNLOCK
*!*					ENDIF
*!*		  			
*!*		  			*** Valores a retornar en el arreglo *** VETT 2010-02-23
*!*		  			IF m.UltCom
*!*			  			THIS.aUltCmp[1] = CO_C.CodAux
*!*			  			THIS.aUltCmp[2] = CO_C.NroOrd
*!*			  			THIS.aUltCmp[3] = CO_C.FchOrd
*!*			  			THIS.aUltCmp[4] = CO_C.CodMon
*!*			  			THIS.aUltCmp[5] = XfPs
*!*			  			THIS.aUltCmp[6] = XfPd
*!*			  			EXIT
*!*		  			ENDIF
*!*				ENDIF		   
*!*			ENDSCAN  
*!*			SELE CATG
*!*		ENDSCAN
*!*		WAIT WINDOW [OK] NOWAIT
*!*		RETURN @This.aUltCmp

*!*	ENDDEFINE

******************
PROCEDURE Imprimir
******************
SELE TMP
GO TOP
IF EOF()
   DO F1MSGERR WITH "Fin de archivo"
   RETURN
ENDIF
TstImp = []
sMensa = []
**---------- Impresi¢n ---------**
xFOR   = [precio1+precio2+precio3+precio4+precio5>0]
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
IniPrnW = []
sNomRep = IIF(m.ultcom,[CMPICULT],[CMPIULTC])
DO F0print WITH "REPORTS"
RETURN
****************
function _moneda
****************
parameter _mon
do case
	case _mon=1
	 return [S/.]
	case _mon=2
	 return [US$]
	case _mon=3
	 return [CN$]
	case _mon=4
	 return [MAR]
	OTHER
	 RETURN [   ]	
endcase

