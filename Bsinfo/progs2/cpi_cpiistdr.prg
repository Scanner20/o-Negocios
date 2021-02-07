*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý cpiistdr.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý Control de producci¢n industrial                            Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Estandares de rendimiento.                                  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 02/02/96                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
*parameter 
PUBLIC ArcTmp,ArcTmp2,sModulo,UltTecla,m.QueDiv,m.codmatD,m.codmatH,m.CodDivD,m.CodDivH,m.CodFamD,m.CodFamH,;
m.CodSubFamD,m.CodSubFamH,m.NroDocD,m.NroDocH,m.Fch1,m.Fch2,m.Fch1,m.Fch2,m.CodMon,m.QuePre,;
m.TipRep,LsDesPro1,LsDesPro2,LsDesPro3

_NroO_T=0
ArcTmp = PATHUSER+SYS(3)
ArcTmp2 = PATHUSER+SYS(3)
sModulo  = [ORDEN_T]
*IF !Abrirdbfs()
*   DO F1msgerr WITH [Error en apertura de archivos]
*ENDIF
UltTecla = 0
m.QueDiv  = 1
*m.CodMatD = SPACE(LEN(CATG.COdMat))
*m.CodMatH = SPACE(LEN(CATG.CodMat))
m.CodDivD = SPACE(GaLenCod(1))
m.CodDivH = SPACE(GaLenCod(1))
m.CodFamD = SPACE(GaLenCod(2))
m.CodFamH = SPACE(GaLenCod(2))
m.CodSubFamD = SPACE(GaLenCod(3))
m.CodSubFamH = SPACE(GaLenCod(3))

m.NroDocD = []
m.NroDocH = []
m.Fch1    = DATE()
m.Fch2    = DATE()
m.Fch1    = CTOD("01/"+STR(_Mes,2,0)+"/"+STR(_Ano,4,0))
m.Fch2    = IIF(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
m.CodMon  = 1
m.QuePre  = 1
m.TipRep  = 1
STORE [] TO LsDesPro1,LsDesPro2,LsDesPro3

*IF EMPTY(_NroO_T)
DO FORM cpi_cpiistdr
return
*ELSE
*   m.NroDocD = TRIM(_NroO_T)
*   m.NroDocH = TRIM(_NroO_T)+CHR(255)
*ENDIF

********************
PROCEDURE GenReport
********************
DIMENSION aCodPro(15)
STORE [] TO aCodPro
m.NroDocD = TRIM(m.NroDocD)
m.NroDocH = TRIM(m.NroDocH)+CHR(255)
Cancelar = .F.

IF m.QueDiv <=3 &&4
    DO SelProduc
ENDIF
DO CASE
   CASE m.QueDiv = 4 &&5
       SELE CO_T
       SET ORDER TO CO_T01
   CASE !EMPTY(m.Fch1)
 	   SELE CO_T
       SET ORDER TO CO_T03
   CASE EMPTY(m.Fch1) AND !EMPTY(m.NroDocD)
       SELE CO_T
      SET ORDER TO CO_T01
ENDCASE
IF m.QueDiv<=3&&4
   FOR J = 1 TO ALEN(aCodPro)
      XsCodPrd = aCodPro(J)
      DO CASE
          CASE !EMPTY(m.Fch1)
       		 XsFor   = [NroDoc>=m.NroDocD AND NroDoc<=m.NroDocH]
             XsLlave = XsCodPrd+DTOS(m.Fch1)
             XsWhile = [CodPro=XsCodPrd AND DTOS(FchDoc)<=DTOS(m.Fch2)]
          CASE EMPTY(m.Fch1)  AND !EMPTY(m.NroDocD)
             XsFor   = [FchDoc>=m.Fch1 AND FchDoc<=m.Fch2]
             XsLlave = m.NroDocD
             XsWhile = [NroDoc<=m.NroDocH]
         OTHER
             XsFor1  = [NroDoc>=m.NroDocD AND NroDoc<=m.NroDocH]
             XsFor2  = [FchDoc>=m.Fch1 AND FchDoc<=m.Fch2]
             XsFor   = XsFor1+[ AND ]+XsFor2
             XsLlave = XsCodPrd
             XsWhile = [CodPro=XsCodPrd]
     ENDCASE
     
     DO GenStdRen
     *Cancelar = (INKEY()=K_ESC OR Cancelar)
  ENDFOR
ELSE
  XsFor = [FchDoc>=m.Fch1 AND FchDoc<=m.Fch2]
  IF EMPTY(m.Fch1) AND EMPTY(m.Fch2)
     XsFor = [.T.]
  ENDIF
  XsLlave = m.NroDocD
  XsWhile = [NroDoc<=m.NroDocH]
  IF EMPTY(m.NroDocD) AND EMPTY(m.NroDocH)
     SELE CO_T
     SET ORDER TO CO_T02
     XsLlave = DTOS(m.Fch1)
     XsWhile = [FchDoc<=m.Fch2]
     XsFor   = [.T.]
  ENDIF
  DO GenStdRen
ENDIF
*SELE CO_T
*SET ORDER TO CO_T01
SELE TMP
SET RELA TO NRODOC INTO CO_T,CODPRD INTO CATG

ArcTmp2 = PATHUSER+SYS(3)
GO TOP
SET ORDER TO TMP02
SET FILTER TO Marca#1
TOTAL ON CODPRD+NIVEL+CODMAT TO (ArcTmp2) 
   
*sele 0
*use (arctmp2)
**suspen
sele tmp
set filter to
set order to tmp01
*do brow_batch
*DO Imprime
RETURN
*******************
PROCEDURE GenStdRen
*******************
** Posicionamos en orden trabajo **
WAIT WINDOW [Generando consulta...] NOWAIT
SELE CO_T
SEEK XsLlave
IF !FOUND()
   IF RECNO(0)>0
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
SCAN WHILE EVAL(XsWhile) AND !Cancelar FOR EVAL(XsFor) AND FLGEST#[A]
     LsNroO_T = NroDoc
     LsCodPrd = CodPro
     LfCanObj = CanObj
     LfCanFin = CanFin
     LfFacTor = Factor
     LdFchDoc = FchDoc
     LdFchFin = FchFin
     lFProd   = SEEK(LsCodPrd,"CFPRO")
     =SEEK(CodPro,[CATG])
     LsDesPro = CATG.DesMat
     WAIT WINDOW CodPro+[ ]+LsDesPro+[ ]+DTOC(FchDoc) NOWAIT
     IF lFprod AND CFPRO.CanObj>0
        WfCanObj = CFPRO.CanObj*LfFactor
        IF ABS(LfCanObj - WfCanObj)>.1
          LfCanObj = WfCanObj
        ENDIF
     ENDIF
     IF LfCanObj<=0
        LfEficie = 0
     ELSE
        LfEficie = ROUND(LfCanFin/LfCanObj*100,2)
     ENDIF
     STORE 0 TO fVFormuD01,fVBatchD01,fVMermaD01
     STORE 0 TO fVFormuD02,fVBatchD02,fVMermaD02
     STORE 0 TO LnItm01,LnItm02,LnNroItm,fVDevoluc
     SELE DO_T
     SEEK LsNroO_T
     SCAN WHILE NroDoc=LsNroO_T  AND !Cancelar
     	
          LsSubAlm = SubAlm
          LsCodMat = CodMat
          LsNroO_T = NroDoc
          =SEEK(CodMat,[CATG])
          LfPctoUs = CATG.PUINUS
          LfPctoMn = CATG.PUINMN
          =SEEK(CodPro+SubAlm+CodMat,[DFPRO])
          =SEEK(CodPro,[CFPRO])
          ** Valorizaci¢n **
          DO CASE
             CASE m.QuePre = 1
                  LfPreUni = 0
                  bLlave = [O_T ]+PADR(NroDoc,LEN(DTRA.NroRef))+CodMat+SubAlm
                  IF SEEK(bLlave,[DTRA])
                     LfCandes = IIF(DTRA.Factor>0,DTRA.Candes*DTRA.Factor,DTRA.Candes)
                     LFVCosto    = IIF(m.CodMon = 1,DTRA.ImpNac,DTRA.ImpUsa)
                     IF LfCanDes>0
                        LfPreUni = ROUND(LfVCosto/LfCanDes,4)
                     ELSE
                        LfPreUni = 0
                     ENDIF
                  ENDIF
                  ** Tomamos el ultimo valor mas proximo a la fecha; si es cero
                  IF LfPreUni = 0
                     =SEEK(SubAlm+Codmat,[CALM])
                     IF m.CodMon = 1
                        LfVCosto =CALM.VIniMn
                     ELSE
                        LfVCosto =CALM.VIniUs
                     ENDIF
                     IF CALM.StkIni>0
                        LfPreUni = ROUND(LfVCosto/CALM.StkIni,4)
                     ELSE
                        LfPreUni = 0
                     ENDIF
                     SELE DTRA
                     SET ORDER TO DTRA02
                     SEEK LsSubAlm+LsCodMat+DTOS(LdFchDoc+1)
                     IF !FOUND()
                        IF RECNO(0)>0
                           GO RECNO(0)
                           IF DELETED()
                              SKIP
                           ENDIF
                        ENDIF
                     ENDIF
                     SKIP -1
                     IF LsSubAlm+LsCodMat=SubAlm+CodMat  AND FchDoc<=LdFchDoc
                        LfVCosto = IIF(m.CodMon=1,ImpNac,ImpUsa)
                        LfCandes = IIF(DTRA.Factor>0,DTRA.Candes*DTRA.Factor,DTRA.Candes)
                        IF LfCanDes>0
                           LfPreUni = ROUND(LfVCosto/LfCanDes,4)
                        ELSE
                           LfPreUni = 0
                        ENDIF
                     ENDIF
                     SET ORDER TO DTRA04
                  ENDIF
             CASE m.QuePre = 2
                  LfPreUni = IIF(m.CodMon=1,LfPCTOMN,LfPCTOUS)
          ENDCASE
          ** Fin ; Valorizaci¢n
          IF !CATG.NoProm
             LsNivel = [D01]
          ELSE
             LsNivel = [D02]
          ENDIF
          LfFacEqu = IIF(DO_T.FacEqu>0,DO_T.FacEqu,1)
          SELE TMP
          APPEND BLANK
          REPLACE Nivel   WITH LsNivel
          REPLACE NroDoc  WITH LsNroO_T
          REPLACE CodPrd  WITH LsCodPrd
          REPLACE CodMat  WITH DO_T.Codmat
          REPLACE DesMat  WITH LEFT(CATG.DesMat,26)+[ ]+DO_T.UndPro
          REPLACE CnBatch WITH DO_T.CnFmla
          IF EMPTY(CnBatch)
             REPLACE CnBatch WITH DO_T.CanFor
          ENDIF
          IF LfFacTor#0
	          REPLACE CnFormu WITH ROUND(CnBatch/LfFactor,4)
          ENDIF
          REPLACE SalFor  WITH DO_T.CanFor
          REPLACE SalAdi  WITH DO_T.CanAdi
          REPLACE IngDev  WITH DO_T.CanDev
          REPLACE SalRea  WITH SalFor+SalAdi - IngDev
          REPLACE SalBpr  WITH ROUND(LfEficie*SalRea/100,4)
          REPLACE SalBFm  WITH ROUND(LfEficie*CnBatch/100,4)
          *** Para tomar salidas que no afectan el almacen 17/01/97
          IF !EMPTY(DO_T.CanSal)
             REPLACE SalBFm  WITH DO_T.CanSal
          ENDIF
          ***
          REPLACE VFORMU  WITH ROUND(LfPreUni*CnBatch*LfFacEqu,2)
          REPLACE VBATCH  WITH ROUND(LfPreUni*SalRea *LfFacEqu,2)
          REPLACE VMerma  WITH ROUND(LfPreUni*(SalRea - SalBfm)*LfFacEqu,2)
          REPLACE PreUni  WITH LfPreUni
          DO GrbPrecios
          IF (vBatch-vmerma)=0
             REPLACE PorMer  WITH 0
          ELSE
             REPLACE PorMer  WITH ROUND(Vmerma/(VBatch-VMerma)*100,2)
          ENDIF
          DO CASE
             CASE Nivel = [D01]
                  LnItm01 = LnItm01 + 1
                  fVFormuD01  = fVFormuD01 + VFormu
                  fVBatchD01  = fVBatchD01 + VBatch
                  fVMermaD01  = fVMermaD01 + VMerma
                  LnNroItm = LnItm01
             CASE Nivel = [D02]
                  LnItm02 = LnItm02 + 1
                  fVFormuD02  = fVFormuD02 + VFormu
                  fVBatchD02  = fVBatchD02 + VBatch
                  fVMermaD02  = fVMermaD02 + VMerma
                  LnNroItm = LnItm02
          ENDCASE
          fVDevoluc = fVDevoluc + ROUND(IngDev*PreUni,2)
          REPLACE NroItm WITH LnNroItm
          SELE DO_T
          *Cancelar = (INKEY()=K_ESC OR Cancelar)
     ENDSCAN

     ** totales de insumos que no son envases **
     LnNroItm = LnItm01
     DO GrbLin1 WITH [D01],[LS],09,13
     DO GrbLin1 WITH [D01],[]
     DO GrbLin1 WITH [D01],[LS],09,13
     ** totales de insumos que son envases **

     LnNroItm = LnItm02
     DO GrbLin1 WITH [D02],[LD],1
     DO GrbLin1 WITH [D02],[]
     DO GrbLin1 WITH [D02],[LD],09,13
     ** total   de insumos                 **

     LnNroItm = 0
    *DO GrbLin1 WITH [D03],[LD],1
     DO GrbLin1 WITH [D03],[]
     DO GrbLin1 WITH [D03],[LD],09,13
     ** Totales de producci¢n **

     LnNroItm = 0
     DO GrbLin1 WITH [P01],[LD],1,3
     DO GrbLin1 WITH [P01],[]
     DO GrbLin1 WITH [P01],[LD],1,3
     DO GrbLin1 WITH [P02],[]
     DO GrbLin2 WITH [P03]
     LnNroItm = LnNroItm + 1
     DO GrbLin1 WITH [P04],[LD],1,3
     DO GrbLin1 WITH [P04],[BL]
     LnNroItm = 0
     DO GrbLin1 WITH [R01],[]
     DO GrbLin1 WITH [R01],[LS],6,8
     DO GrbLin1 WITH [R02],[]
     DO GrbLin1 WITH [R03],[]
     DO GrbLin1 WITH [R04],[]
     DO GrbLin1 WITH [R05],[]
     DO GrbLin1 WITH [R06],[]
     DO GrbAdic         

     SELE CO_T    
     *Cancelar = (INKEY()=K_ESC OR Cancelar)
ENDSCAN


RETURN
*****************
PROCEDURE GrbLin1
*****************
PARAMETER m.Nivel,m.Tipo,m.Col1,m.Col2
PRIVATE K
STORE 0 TO ColIni,ColFin
IF PARAMETERs()>2
   ColIni = m.Col1
   ColFin = 13
ENDIF
IF parameters()>3
   ColIni = m.Col1
   ColFin = m.Col2
ENDIF
LnNroItm = LnNroItm + 1
SELE TMP
APPEND BLANK
REPLACE Nivel  WITH m.Nivel
REPLACE NroItm WITH LnNroItm
REPLACE NroDoc WITH LsNroO_T
REPLACE CodPrd WITH LsCodPrd
IF M.TIPO = [BL]
   RETURN
ENDIF
DO CASE
   CASE M.NIVEL =[D]
        DO CASE
           CASE m.Tipo = [L]
                RAYA = IIF(INLIST(M.TIPO,[LS],[RS]),[-],[=])
                IF ColIni>0
                   FOR K = ColIni TO ColFin
                       Campo1 = [COL]+TRAN(K,[@L ##])
                       nLen   = LEN(&Campo1.)
                       REPLACE  &Campo1. WITH REPLI(RAYA,nLen)
                   ENDFOR
                ENDIF
                IF m.Nivel = [D03]
                   REPLACE DESMAT WITH LsDesPro
                ENDIF
           CASE m.Tipo # [L]
                IF m.Nivel<[D03]
                   Campo1a= [VFormu]
                   Campo2a= [VBatch]
                   Campo3a= [VMerma]
                   Campo1 = [fVFormu]+m.Nivel
                   Campo2 = [fVBatch]+m.Nivel
                   Campo3 = [fVMerma]+m.Nivel
                   REPLACE &Campo1a. WITH &Campo1.
                   REPLACE &Campo2a. WITH &Campo2.
                   REPLACE &Campo3a. WITH &Campo3.
                   IF (vBatch-vmerma)<=0.1
                      REPLACE PorMer  WITH 0
                   ELSE
 					  xxPorcen=ROUND(Vmerma/(VBatch-VMerma)*100,2)
						IF xxPorcen>999.99	                  
						   xxPorCen=0 
  						ENDIF	                 
                      REPLACE PorMer  WITH xxPorcen
                   ENDIF
					REPLACE CODMAT WITH [TOT]+M.NIVEL
                   IF m.Nivel=[D02]
                      REPLACE DESMAT WITH [Fecha:]+DTOC(CO_T.FCHDOC)
                   ENDIF
                ELSE
                   REPLACE VFormu WITH fVFormuD01+fVFormuD02
                   REPLACE VBatch WITH fVBatchD01+fVBaTCHD02
                   REPLACE VMerma WITH fVMermaD01+fVmermaD02
                   IF (vBatch-vmerma)<=0.1
                      REPLACE PorMer  WITH 0
                   ELSE
 					  xxPorcen=ROUND(Vmerma/(VBatch-VMerma)*100,2)
						IF xxPorcen>999.99	                  
						   xxPorCen=0 
  						ENDIF	                 
                      REPLACE PorMer  WITH xxPorcen
                   ENDIF
                   REPLACE DESMAT WITH [PROD:]+CodPrd+[ BATCH:]+NroDoc
					REPLACE CODMAT WITH [TOT]+M.NIVEL
                ENDIF
        ENDCASE
   CASE m.Nivel =[P]
        DO CASE
           CASE m.Tipo = [L]
                RAYA = IIF(INLIST(M.TIPO,[LS],[RS]),[-],[=])
                IF ColIni>0
                   FOR K = ColIni TO ColFin
                       Campo1 = [COL]+TRAN(K,[@L ##])
                       nLen   = LEN(&Campo1.)
                       REPLACE  &Campo1. WITH REPLI(RAYA,nLen)
                   ENDFOR
                ENDIF
                REPLACE CODMAT WITH [LIN1]+m.Nivel
           CASE m.Tipo # [L]
                DO CASE
                   CASE m.Nivel = [P01]
                        REPLACE DESMAT WITH [TOTALES]
                        REPLACE COL03  WITH [UND]
                        REPLACE CODMAT WITH [LIN2]+M.NIVEL
                   CASE m.Nivel = [P02]
                        REPLACE DESMAT  WITH [PRODUCCION ESTIMADA   UND]
                        REPLACE CnFormu WITH INT(CFPRO.CanObj)
                        REPLACE CnBaTCH WITH INT(CO_T.CanObj)
                        REPLACE CODMAT  WITH [LIN3]+M.NIVEL
                        REPLACE Marca   WITH IIF(CO_T.TipBat=2,1,0) 
                ENDCASE
        ENDCASE
   CASE m.Nivel =[R]
        DO CASE
           CASE m.Tipo = [L]
                RAYA = IIF(INLIST(M.TIPO,[LS],[RS]),[-],[=])
                IF ColIni>0
                   FOR K = ColIni TO ColFin
                       Campo1 = [COL]+TRAN(K,[@L ##])
                       nLen   = LEN(&Campo1.)
                       REPLACE  &Campo1. WITH REPLI(RAYA,nLen)
                   ENDFOR
                ENDIF
           CASE m.Tipo # [L]
                DO CASE
                   CASE m.Nivel = [R01]
                        REPLACE DESMAT WITH [RESUMEN DE VALORIZACION:]
                   CASE m.Nivel = [R02]
                        REPLACE DESMAT  WITH [PRODUCCION SEGUN FORMULA   ]+IIF(m.CodMon=1,[S/.],[US$])
                        REPLACE CnFormu WITH fVformuD01+fVformuD02
                        REPLACE COL06   WITH [MERMA:]
                        m.VMerma=(fVMermaD01+fVMermaD02)
                        m.VCReal=(fVBatchD01+fVBatchD02)-(fVMermaD01+fVMermaD02)
                        IF m.VCReal=0
                           LfPorMer = 0
                        ELSE
                           LfPorMer = round(m.VMerma/VCReal*100,2)
                        ENDIF
                        REPLACE COL07   WITH TRAN(LfPorMer,"999.99")+[%]
                        LfVMerma = fVMermaD01+fVMermaD02
                        REPLACE COL08   WITH IIF(m.CodMon=1,[S/.],[US$])+TRAN(LfVMerma,"999999.99")
                   CASE m.Nivel = [R03]
                        REPLACE DESMAT  WITH [DEVOLUCION DE INSUMOS      ]+IIF(m.CodMon=1,[S/.],[US$])
                        REPLACE CnFormu WITH fVDevoluc
                        REPLACE COL06   WITH [EFICIENCIA:]
                        REPLACE COL07   WITH TRAN(LfEficie,"99999.99")+[%]
                   CASE m.Nivel = [R04]
                        REPLACE DESMAT  WITH [PRODUCCION FORMULA NETA    ]+IIF(m.CodMon=1,[S/.],[US$])
                        REPLACE CnFormu WITH fVformuD01+fVformuD02-fVDevoluc
                        REPLACE COL06   WITH REPLI([-],LEN(COL06))
                        REPLACE COL07   WITH REPLI([-],LEN(COL07))
                        REPLACE COL08   WITH REPLI([-],LEN(COL08))
                   CASE m.Nivel = [R05]
                        REPLACE DESMAT  WITH [COSTO PRODUCCION-MAT.PRIMA ]+IIF(m.CodMon=1,[S/.],[US$])
                        REPLACE CnFormu WITH fVBatchD01+fVBatchD02
                   CASE m.Nivel = [R06]
                        REPLACE DESMAT  WITH [MERMA DE PRODUCCION        ]+IIF(m.CodMon=1,[S/.],[US$])
                        REPLACE CnFormu WITH fVMermaD01+fVMermaD02


                ENDCASE
        ENDCASE
ENDCASE
RETURN
*****************
PROCEDURE GrbLin2
*****************
PARAMETER m.Nivel,m.Tipo,m.Col1,m.Col2
STORE 0 TO ColIni,ColFin
IF PARAMETERs()>2
   ColIni = m.Col1
   ColFin = 13
ENDIF
IF parameters()>3
   ColIni = m.Col1
   ColFin = m.Col2
ENDIF

DO CASE
   CASE m.Nivel = [P03]
        STORE 0 TO TfCnFormu,TfCnBatch
        SELE PO_T
        SEEK LsNroO_t
        SCAN WHILE NroDoc = LsNroO_T
             LnNroItm = LnNroItm + 1
             SELE TMP
             APPEND BLANK
             REPLACE Nivel   WITH m.Nivel
             REPLACE NroItm  WITH LnNroItm
             REPLACE NroDoc  WITH LsNroO_T
             REPLACE CodPrd  WITH LsCodPrd
             REPLACE DESMAT  WITH ALMNOMBR(PO_T.SubAlm)
             SCATTER MEMVAR
             LfCnBatch = PO_T.CanFin
             IF CO_T.Factor>0
                LfCnFormu = PO_T.CanFin/CO_T.Factor
             ELSE
                LfCnFormu = 0
             ENDIF
             REPLACE CnFormu WITH LfCnFormu
             REPLACE CnBatch WITH LfCnBatch
             REPLACE CODMAT  WITH [ALM:]+PO_T.SubAlm
             TfCnFormu = TfCnFormu + CnFormu
             TfCnBaTCH = TfCnBaTCH + CnBatch
             IF CO_T.TipBat=2
	             REPLACE Marca WITH 1
             ENDIF
             SELE PO_T
        ENDSCAN
        LnNroItm = LnNroItm + 1
        SELE TMP
        APPEND BLANK
        GATHER MEMVAR
        REPLACE NroDoc  WITH LsNroO_T
        REPLACE CodPrd  WITH LsCodPrd
        REPLACE NroItm  WITH LnNroItm
        REPLACE DESMAT  WITH [PRODUCCION REAL]
		REPLACE CODMAT  WITH [P_REAL]
        IF TfCnBatch<=0
           TfCnBatch = CO_T.CanFin
           IF CO_T.Factor#0
              TfCnFormu = CO_T.CanObj/CO_T.Factor
           ELSE
              TfCnFormu = 0
           ENDIF
        ENDIF
        REPLACE CnFormu WITH TfCnFormu
        REPLACE CnBatch WITH TfCnBaTCH
        IF CO_T.TipBat=2
            REPLACE Marca WITH 1
        ENDIF
        ** Grabamos porcentajes de rendimiento **
        LnNroItm = LnNroItm + 1
        SELE TMP
        APPEND BLANK
        GATHER MEMVAR
        REPLACE NroDoc  WITH LsNroO_T
        REPLACE CodPrd  WITH LsCodPrd
        REPLACE NroItm  WITH LnNroItm
        REPLACE DESMAT  WITH [PORCENTAJE EN BASE A PRODUCIDO %]
        REPLACE CnFormu WITH LfEficie
        REPLACE CnBatch WITH LfEficie
        REPLACE CODMAT  WITH [PORCEN]
        IF CO_T.TipBat=2
           REPLACE Marca WITH 1
        ENDIF
ENDCASE
RETURN
*****************
PROCEDURE GrbAdic
*****************
SELE Tmp
APPEND BLANK
REPLACE NroDoc WITH LsNroO_T
REPLACE CodPrd WITH LsCodPRd
REPLACE NiVel  WITH [B01]
REPLACE DesMat WITH [INSUMOS DEL BATCH:]+NroDoc+[ ]
REPLACE Factor WITH CO_T.Factor
REPLACE Marca  WITH IIF(CO_T.TipBat=2,1,0)
APPEND BLANK
REPLACE NroDoc WITH LsNroO_T
REPLACE NiVel  WITH [Z01]
REPLACE CodPrd WITH LsCodPRd
REPLACE DESMAT WITH REPLI("-",LEN(DesMat))
REPLACE Col01  WITH REPLI("-",LEN(Col01))
REPLACE Col02  WITH REPLI("-",LEN(Col02))
REPLACE Col03  WITH REPLI("-",LEN(Col03))
REPLACE Col04  WITH REPLI("-",LEN(Col04))
REPLACE Col05  WITH REPLI("-",LEN(Col05))
REPLACE Col06  WITH REPLI("-",LEN(Col06))
REPLACE Col07  WITH REPLI("-",LEN(Col07))
REPLACE Col08  WITH REPLI("-",LEN(Col08))
REPLACE Col09  WITH REPLI("-",LEN(Col09))
REPLACE Col10  WITH REPLI("-",LEN(Col10))
REPLACE Col11  WITH REPLI("-",LEN(Col11))
REPLACE Col12  WITH REPLI("-",LEN(Col12))
REPLACE Col13  WITH REPLI("-",LEN(Col13))
APPEND BLANK
REPLACE NroDoc WITH LsNroO_T
REPLACE NiVel  WITH [Z02]
REPLACE CodPrd WITH LsCodPRd
REPLACE DESMAT WITH REPLI("-",LEN(DesMat))
REPLACE Col01  WITH REPLI("-",LEN(Col01))
REPLACE Col02  WITH REPLI("-",LEN(Col02))
REPLACE Col03  WITH REPLI("-",LEN(Col03))
REPLACE Col04  WITH REPLI("-",LEN(Col04))
REPLACE Col05  WITH REPLI("-",LEN(Col05))
REPLACE Col06  WITH REPLI("-",LEN(Col06))
REPLACE Col07  WITH REPLI("-",LEN(Col07))
REPLACE Col08  WITH REPLI("-",LEN(Col08))
REPLACE Col09  WITH REPLI("-",LEN(Col09))
REPLACE Col10  WITH REPLI("-",LEN(Col10))
REPLACE Col11  WITH REPLI("-",LEN(Col11))
REPLACE Col12  WITH REPLI("-",LEN(Col12))
REPLACE Col13  WITH REPLI("-",LEN(Col13))
RETURN
******************
FUNCTION AbrirDbfs
******************
=F1qeh([ABRE_DBF])
*
IF !USED([DIVF])
   SELE 0
   USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
IF !USED([DTRA])
   SELE 0
   USE ALMDTRAN ORDER DTRA04 ALIAS DTRA
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CTRA])
   SELE 0
   USE ALMCTRAN ORDER CTRA01 ALIAS CTRA
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CALM])
   SELE 0
   USE ALMCATAL ORDER CATA01 ALIAS CALM
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CATG])
   SELE 0
   USE ALMCATGE ORDER CATG01 ALIAS CATG
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CFPRO])
   SELE 0
   USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*

IF !USED([DFPRO])
   SELE 0
   USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DO_T])
   SELE 0
   USE CPIDO_TB ORDER DO_T01 ALIAS DO_T
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CO_T])
   SELE 0
   USE CPICO_TB ORDER CO_T01 ALIAS CO_T
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([PO_T])
   SELE 0
   USE CPIPO_TB ORDER PO_T01 ALIAS PO_T
   IF !USED()
      CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
*
SELE 0
CREATE TABLE &ArcTmp. (Nivel C(3),NroDoc C(8),CodPrd C(13),CodMat C(8),;
       DesMat C(40),Glosa C(40),NroItm N(4), CnFormu N(14,4),         ;
       CnBatch N(14,4),Factor N(6,2),SalFor N(14,4),SalAdi N(14,4),   ;
       IngDev N(14,4),SalRea N(14,4),SalBpr N(14,4),SalBFm N(14,4),   ;
       VFormu N(14,4),VBATCH N(14,4),VMerma N(14,4),PorMer N(6,2),    ;
       PreUni N(14,4),Marca N(1),									;
       COL01 C(40),COL02 C(10),COL03 C(10),COL04 C(10),COL05 C(10),COL06 C(10),;
       COL07 C(10),COL08 C(11),COL09 C(10),COL10 C(10),COL11 C(10),COL12 C(08),;
       COL13 C(8) )


USE &ArcTmp. ALIAS TMP EXCL
IF !USED()
   CLOSE DATA
   RETURN .F.
ENDIF
INDEX ON NroDoc+Nivel TAG TMP01
INDEX ON CodPrd+Nivel+CodMat TAG TMP02
SET ORDER TO TMP01
RETURN .T.
*********************
PROCEDURE Brow_BATCH
*********************
PRIVATE lMostrar,m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
private m.CurrWind
STORE WOUTPUT() TO m.CurrWind
IF !EMPTY(m.CurrWind)
   DEACTIVATE WINDOW (m.CurrWind)
ENDIF
lMostrar  = .F.
LfCanObj = CO_T.CanObj
LfCanFin = CO_T.CanFin
LfFacTor = CO_T.Factor
LdFchDoc = CO_T.FchDoc
LdFchFin = CO_T.FchFin
IF LfCanObj<=0
   LfEficie = 0
ELSE
   LfEficie = ROUND(LfCanFin/LfCanObj*100,2)
ENDIF
m.Area   = [TMP]
m.bTitulo = [ORDEN_DE_TRABAJO]
m.bDeta   = [ORDEN_DE_TRABAJO]
IF lMostrar
   m.bClave1 = []
   m.bClave2 = []
ELSE
   m.bClave1 = []
   m.bClave2 = []
ENDIF
m.bFiltro = [.T.]
sModulo  = [ORDEN_T]

sCmp = []
  sCmp = sCmp+[C1=IIF(EMPTY(COL01),DESMAT,COL01):H=LEFT(CATG.DesMat,30):P='@Z':30,]
  sCmp = sCmp+[C2=IIF(EMPTY(COL02),CnFormu,COL02):H='FORMULA':P='@Z':11,]
  sCmp = sCmp+[C3=IIF(EMPTY(COL03),CnBatch,COL03):H='BATCH'+TRAN(CO_T.Factor,'99.999'):P='@Z':11,]
  sCmp = sCmp+[C4=IIF(EMPTY(COL04),SalFor+SalAdi ,COL04):H='Sal.Real.':P='@Z':10,]
  sCmp = sCmp+[C5=IIF(EMPTY(COL05),IngDev ,COL05):H='Devoluci¢n':P='@Z':10,]
  sCmp = sCmp+[C6=IIF(EMPTY(COL06),SalRea ,COL06):H='Salida Neta':P='@Z':10,]
  sCmp = sCmp+[C7=IIF(EMPTY(COL07),SalBfm ,COL07):H='SBP:'+TRAN(CO_T.Eficie,'999.99'):P='@Z':10,]
  sCmp = sCmp+[C9=IIF(EMPTY(COL08),SalRea-SalBFm,COL08):H='Unidades':P='@Z':10,]
  sCmp = sCmp+[CA=IIF(EMPTY(COL09),VFormu,COL09):H='V.Formula':P='@Z':10,]
  sCmp = sCmp+[CB=IIF(EMPTY(COL10),VBatch,COL10):H='V.Real   ':P='@Z':10,]
  sCmp = sCmp+[CC=IIF(EMPTY(COL11),VMerma,COL11):H='V.Merma  ':P='@Z':10,]
  sCmp = sCmp+[CD=IIF(EMPTY(COL12),PorMer,COL12):H='Merma %':P='@Z':08,]
  sCmp = sCmp+[CE=IIF(EMPTY(COL13),PreUni,COL13):H='Pre.Uni.':P='@Z':08]
  
m.bCampos =scmp&& bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []

nX0 = 01
nY0 = 00
nX1 = 23
nY1 = 79
lModi_Reg = .F.
lAdic_Reg = .F.
lBorr_Reg = .F.
m.lStatic = .F.
Lcmb = .f.
DO CASE
   CASE SYS(2006)=[VGA] &&AND _dos
       SET DISPLAY TO VGA50
       Lcmb = .T.
       nX1 = 49
   CASE SYS(2006)=[EGA] &&and _dos
       SET DISPLAY TO EGA43
       Lcmb = .T.
       nX1 = 42

ENDCASE
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
IF lCmb
   DO CASE
      CASE SYS(2006)=[VGA]
          SET DISPLAY TO VGA25
      CASE SYS(2006)=[EGA]
          SET DISPLAY TO EGA25
   ENDCASE
ENDIF
RETURN
*************
FUNCTION wBrw
*************



RETURN .T.
*****************
PROCEDURE IMPRIME
*****************
SELE TMP
GO TOP
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO F1MSGERR WITH GSMSGERR
   RETURN
ENDIF
**
xFor  = [!INLIST(Nivel,'B','Z')]
Largo = 66
IniPrn = [_Prn0+_Prn5a+CHR(Largo)+_Prn5b+_Prn4]
sNomRep = "CPIISTDR"
DO F0PRINT WITH "REPORTS"
RETURN
***************
FUNCTION DESPRO
***************
DIMENSION xxDesMat(3)
STORE [] TO xxDesMat
=SEEK(CodPrd,[CATG])
LsxxDesMat = CATG.DesMat
NumDes = 0
DO WHILE .T.
   IF EMPTY(LsxxDesMat)
      EXIT
   ENDIF
   NumDes = NumDes + 1
   IF NumDes > ALEN(xxDesMat)
      DIMENSION xxDesMat(NumDes+1)
   ENDIF
   Z = AT("-",LsxxDesMat)
   IF Z = 0
      Z = LEN(LsxxDesMat) + 1
   ENDIF
   xxDesMat(NumDes) = PADC(LEFT(LsxxDesMat,Z-1),15)
   IF Z > LEN(LsxxDesMat)
      EXIT
   ENDIF
   LsxxDesMat = SUBSTR(LsxxDesMat,Z+1)
ENDDO
LsDesPro1=xxDesMat(1)
LsDesPro2=xxDesMat(2)
LsDesPro3=xxDesMat(3)
RETURN
*******************
PROCEDURE SelProduc
*******************
=f1qeh("Ordenando informaci¢n...")
m.Len0 = LEN(CATG.CodMat)
m.Len1 = m.Len0 - GaLenCod(1)
m.Len2 = m.Len0 - GaLenCod(2)
m.Len3 = m.Len0 - GaLenCod(3)
DO CASE
   CASE m.QueDiv = 1
        SELE DIVF
        m.CodDivD = TRIM(m.CodDivD)
        m.CodDivH = TRIM(m.CodDivH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodDivD)
           SEEK m.ClfDiv
        ELSE
           SEEK m.ClfDiv+m.CodDivD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE ClfDiv+CodFam<=m.ClfDiv+m.CodDivH &&FOR DIVF.TipFam>1 &&AMAA 27-02-07
             LsCodFam = LEFT(CodFam,GaLenCod(1))
             SELE CATG
             SEEK LsCodFam
             SCAN WHILE CodMat = LsCodFam
                  zi = zi + 1
                  if alen(aCodPro)< zi
                     dimension aCodPro(zi+5)
                  endif
                  aCodPro(zi) = CodMat
             ENDSCAN
             SELE DIVF
        ENDSCAN
        IF zi>0
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No estan definidas las divisiones por material]
           RETURN .F.
        ENDIF
   CASE m.QueDiv = 2   		
        SELE DIVF
        m.CodFamD = TRIM(m.CodFamD)
        m.CodFamH = TRIM(m.CodFamH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodFamD)
           SEEK m.ClfDiv
        ELSE
           SEEK m.ClfDiv+m.CodFamD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE ClfDiv+CodFam<=m.ClfDiv+m.CodFamH
             LsCodFam = LEFT(CodFam,GaLenCod(2))
             SELE CATG
             SEEK LsCodFam
             SCAN WHILE CodMat = LsCodFam &&FOR (DIVF.TipFam>1 OR CATG.TipMat=[11])
                  zi = zi + 1
                  if alen(aCodPro)< zi
                     dimension aCodPro(zi+5)
                  endif
                  aCodPro(zi) = CodMat
             ENDSCAN
             SELE DIVF
        ENDSCAN
        IF zi>0
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No estan definidas las familias por material]
           RETURN .F.
        ENDIF
   *CASE m.QueDiv = 3
   *     SELE DIVF
   *     m.CodSubFamD = TRIM(m.CodSubFamD)
   *     m.CodSubFamH = TRIM(m.CodSubFamH)+CHR(255)
   *     m.ClfDiv  = GaClfDiv(m.QueDiv)
   *     IF EMPTY(m.CodSubFamD)
   *        SEEK m.ClfDiv
   *     ELSE
   *        SEEK m.ClfDiv+m.CodSubFamD
   *        IF ! FOUND() .AND. RECNO(0) > 0
   *           GOTO RECNO(0)
   *           IF DELETED()
   *              SKIP
   *           ENDIF
   *        ENDIF
   *     ENDIF
   *     zi = 0
   *     SCAN WHILE ClfDiv+CodFam<=m.ClfDiv+m.CodSubFamH
   *          LsCodFam = LEFT(CodFam,GaLenCod(3))
   *          SELE CATG
   *          SEEK LsCodFam
   *          SCAN WHILE CodMat = LsCodFam FOR (DIVF.CodFam>1 OR CATG.TipMat=[11])
   *               zi = zi + 1
   *               if alen(aCodPro)< zi
   *                  dimension aCodPro(zi+5)
   *               endif
   *               aCodPro(zi) = CodMat
   *          ENDSCAN
   *          SELE DIVF
   *     ENDSCAN
   *     IF zi>0
   *        DIMENSION  aCodPro(zi)
   *    ELSE
   *        DO F1MsgErr WITH [No estan definidas las subfamilias por material]
   *        RETURN .F.
   *     ENDIF
   CASE m.QueDiv = 3
        SELE CATG
        IF EMPTY(m.CodMatD)
           m.CodMatD = m.CodFamD
        ENDIF
        IF EMPTY(m.CodMatH)
           m.CodMatH = m.CodFamD
        ENDIF
        m.CodMatD = TRIM(m.CodMatD)
        m.CodMatH = TRIM(m.CodMatH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodMatD)
           GO TOP
        ELSE
           SEEK m.CodMatD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE CodMat<=m.CodMatH
             lFound = SEEK(GaClfDiv(2)+LEFT(CodMat,GaLenCod(2)),[DIVF])
             IF lFound &&AND (DIVF.TipFam>1 OR CATG.TipMat=[11])
                zi = zi + 1
                if alen(aCodPro)< zi
                   dimension aCodPro(zi+5)
                endif
                aCodPro(zi) = CodMat
             ENDIF
        ENDSCAN
        IF zi>0
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No existen materiales en el rango]
           RETURN .F.
        ENDIF
ENDCASE
=f1qeh("OK")
****************
FUNCTION bDescri
****************
DO CASE
   CASE UPPER(VARREAD())=[CODDIVD] AND m.QueDiv = 1
        @ 6,12+GaLenCod(1)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODDIVH] AND m.QueDiv = 1
        @ 7,12+GaLenCod(1)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAMD] AND m.QueDiv = 2
        @ 6,12+GaLenCod(2)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAMH] AND m.QueDiv = 2
        @ 7,12+GaLenCod(2)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODMATD] AND m.QueDiv = 3
        @ 6,12+GaLenCod(3)+3    SAY CATG.DesMAT SIZE 1,30
   CASE UPPER(VARREAD())=[CODMATH] AND m.QueDiv = 3
        @ 7,12+GaLenCod(3)+3    SAY CATG.DesMAT SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAM]
        @ 4,12+GaLenCod(2)+3    SAY divf.DesfAM SIZE 1,30
ENDCASE
********************
PROCEDURE GrbPrecios
********************
PRIVATE xArea_Act
xArea_Act = ALIAS()
IF !USED([RESUMEN])
	ArcResu=PATHUSER+SYS(3)
	SELE 0
	CREATE TABLE (ArcResu) FREE (   Refer C(5) , CodPro C(8), CodMat C(8),;
								PreUni N(12,4),Factor N(10,4)           )
	USE (ArcResu) EXCLU ALIAS RESUMEN
	INDEX ON REFER+CodPro+CodMat TAG RESU01	
	SET ORDER TO RESU01    
ENDIF
SELE (xArea_Act)
RETURN 
