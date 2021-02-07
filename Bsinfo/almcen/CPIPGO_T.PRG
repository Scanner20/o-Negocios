*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý cpipgO_T.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý Control de producci¢n industrial                            Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538 - 9437638              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Generaci¢n de orden de trabajo (BATCH) .                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 27/12/95                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
PARAMETER m.tpo_pro
*PARAMETER m.Automatico
do case
   case m.tpo_pro = [O_T ]
        sTit = [GENERACION DE ORDEN DE TRABAJO]
        LsMovPro=[MovPro=1]
   case m.tpo_pro = [TRB ]
        sTit = [TRANSFORMACION]
        LsMovPro=[MovPro=2]
   case m.tpo_pro = [FRU ]
        sTit = [PROCESO DE FRUTA]
        LsMovPro=[MovPro=3]
   case m.tpo_pro = [PRB ]
        sTit = [PRODUCCION DE BOTELLAS]
        LsMovPro=[MovPro=4]
endcase
=F1_BASE(GsNomCia,[PRODUCCION:]+sTit,"USUARIO:"+GsUsuario,"FECHA:"+GsFecha)

m.lStkNeg = .F.
sModulo = [GEN_O/T]
ArcTmp = PATHUSER+SYS(3)
STORE [] TO sMovSal,sMovIng,sMovDev
IF !ABrirDbfs()
   *IF !m.Automatico
      CLOSE DATA
   *ENDIF
   RETURN
ENDIF


** Inicializamos variables de la cabecera **

PRIVATE sNroO_T,fCanFin,dFchDoc,sRespon,cFlgEst,m.tipbat,ZsTpoRef
PRIVATE sMovIng,sMovDev,sMovSal,sNoIng1,sNoIng2,sNoDev1,sNoDev2,sNoSal1,sNoSal2
m.TipPro = [P/T]  && Producto Terminado
ZsTpoRef = m.tpo_pro  && Ordenes de trabajo autom ticas   ---> O J O
sNroO_T  = SPACE(LEN(CO_T.NroDoc))
dFchDoc  = GdFecha
dFchFIn  = {,,}
sCodPrd  = SPACE(LEN(CO_T.CodPro))
fCanFin  = 0.000
fCanObj  = 0.000
sRespon  = SPACE(LEN(CO_T.Respon))
sCdArea  = SPACE(LEN(CO_T.CdArea))
cFlgEst  = [P]      && Pendiente , Terminada, Anulada,
m.tipbat  = 1      && 1 -> Normal , 2 -> Regularizaci¢n no afecta
					&& Stock de productos terminados					
					
fFactor  = 1.00
m.FacAnt = 1.00
sAlmSal  = []
sAlmIng  = []
sAlmDev  = []
*
* Variables del Browse *
PRIVATE nX0,nY0,nX1,nY1,sModulo
PRIVATE m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
STORE [] TO m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde

* Variables de control general
UltTecla  = 0
m.Primera = .T.
m.Estoy   = [MOSTRANDO]
m.salir   = 1
Crear     = .F.

GnTotDel  = 0


* Control de Correlativo Multi-usuario *
PRIVATE m.NroO_T
m.NroO_T = []

* Control de actualizaci¢n de almacen
PRIVATE m.HAYSALID1,m.HAYSALID2,m.HAYDEVOL1,m.HAYDEVOL2,m.HAYINGP_T,m.HAYINGP_I
STORE .F. TO m.HAYSALID1,m.HAYSALID2,m.HAYDEVOL1,m.HAYDEVOL2,m.HAYINGP_T,m.HAYINGP_I

** Variables de Configuraci¢n de transacciones de almacen **
m.lPidRf1 = .F.
m.lPidRf2 = .F.
m.lPidRf3 = .F.
m.lPidVen = .F.
m.lPidCli = .F.
m.lPidPro = .F.
m.lPidOdT = .T.
m.lModPre = .F.
m.lUndStk = .T.
m.lUndVta = .F.
m.lUndCmp = .F.
m.lModCsm = .F.
*
m.lAfeTra = .F.
*
m.lExtPco = .F.
m.lPidPco = .F.
m.lMonNac = .T.
m.lMonUsa = .F.
m.lMonElg = .F.
* Variables para registros en almacen *
STORE [] TO m.nCodMon,m.fTpoCmb,m.sObserv,m.sNroRf1,m.sNroRf2,m.sNroOdt
STORE [] TO m.sCodCli,m.sCodPro,m.sCodVen,m.sCodAux,m.fImpBrt,m.fImpTot
STORE [] TO m.fImpIgv,m.fPorIgv,m.sDesMov,m.GloRf1,m.GloRf2,m.glorf3
* Variable de control de stock *
lNoHayStock = .T.
* Arreglos para capturar configuracion de actualizaciones de almacen *
DIMENSION aTipmov(1),aCodMov(1),aCmpEva(1),aEvalua(1),aPorP_T(1),;
          aCmpAct1(1),aCmpAct2(1),aDesMov(1),aHayMov(1),aImprimir(1),aSubAlm(1)
DIMENSION aConFig(1,2)
STORE [] TO aTipmov,aCodMov,aCmpEva,aEvalua,aPorP_T,aCmpAct1,aCmpAct2,aDesmov2,;
            aHayMov,aImprimir,aSubAlm,aConFig

nNumItmI= 0 && Numero de items a imprimir
nTotMov = 0 && Numero de movimientos de almacen afectados por produccion
IF nTotMov <=0
   IF !ArrConfig()
      DO F1MsgErr WITH [No existe configuraci¢n para actualizar almacen]
      =AbreDbfPro()
      lActAlm = .F.
   ENDIF
ENDIF

lCapConfig = .F.
**if not wexist("WBROW1")
**   define window WBROW1 from 6,01 to 20,74 ;
**   font "ms sans serif", 8 ;
**   style "b" ;
**   float ;
**   noclose ;
**   minimize ;
**   double
**endif

**ACTIVATE WINDOW WBROW1
SELE CO_T
GO TOP
DO pVerTodo

SELE CO_T

DO F1_EDIT WITH [pLlave],[pVerTodo],[pEditar],[pBorrar],[pImprime],[],[],'CMAR',[]

CLOSE DATA
**RELEASE WINDOW WBROW1
RETURN
*******************
PROCEDURE ABRIRDBFS
*******************
=F1QEH([ABRE_DBF])
IF !USED([CFTR])
   USE ALMCFTRA IN 0 ORDER CFTR02 ALIAS CFTR
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
SELE CFTR
SET FILTER TO eval(lsmovpro) AND UPPER(CMPEVA)=[CANFOR]
GO TOP
m.lStkNeg = CFTR->StkNeg
USE
*
IF !USED([ALMA])
   USE ALMTALMA IN 0 ORDER ALMA01 ALIAS ALMA
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DIVF])
   USE ALMTDIVF IN 0 ORDER DIVF01 ALIAS DIVF
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CATG])
   USE ALMCATGE IN 0 ORDER CATG01 ALIAS CATG
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
sele catg
set rela to left(codmat,5) into divf
*
ArcSql = pathuser+sys(3)
sele 0
if m.tpo_pro = [O_T ]     &&& O/T
   select catg.codmat,catg.desmat,catg.undstk;
          from almcatge catg, almtdivf divf;
          where divf.clfdiv=[02] .and. divf.tipfam#1 .and. catg.codmat=divf.codfam;
          group by catg.codmat;
          order by catg.codmat;
          into table &ArcSql.
else                     &&& TRANSFORMACION
   select catg.codmat,catg.desmat,catg.undstk;
          from almcatge catg, almtdivf divf;
          where divf.clfdiv=[02] .and. inlist(catg.tipmat,[11],[20]) .and. catg.codmat=divf.codfam;
          group by catg.codmat;
          order by catg.codmat;
          into table &ArcSql.
endif
use &ArcSql. alias form exclu
if !used()
   close data
   return .f.
endif
index on codmat tag form01
index on upper(desmat) tag form02
set order to form01
*
IF !USED([CALM])
   USE ALMCATAL IN 0 ORDER CATA01 ALIAS CALM
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CO_T])
   USE CPICO_TB IN 0 ORDER CO_T01 ALIAS CO_T
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DO_T])
    USE CPIDO_TB IN 0 ORDER DO_T01 ALIAS DO_T
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
*
IF !USED([PO_T])
    USE CPIPO_TB IN 0 ORDER PO_T01 ALIAS PO_T
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
*
IF !USED([CDOC])
   if m.tpo_pro = [O_T ]     &&& O/T
      USE ALMCDOCM IN 0 ORDER CDOC01 ALIAS CDOC   
   else
      USE ALMCDOCM IN 0 ORDER CDOC03 ALIAS CDOC
   endif
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([CFPRO])
   USE CPICFPRO IN 0 ORDER cfpr01 ALIAS CFPRO
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DFPRO])
   USE CPIDFPRO IN 0 ORDER DFPR01 ALIAS DFPRO
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([TABL])
   USE ALMTGSIS IN 0 ORDER TABL01 ALIAS TABL
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
IF !USED([DTRA])
   USE ALMDTRAN IN 0 ORDER DTRA01 ALIAS DTRA
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
SELE 0
CREAT TABL &ArcTmp. (NroDoc  C(8),CodPro  C(8),TipPro  C(3),SubAlm C(3),;
  CodMat C(8),DesMat C(40),UndPro C(3),FacEqu N(14,4),NroReg N(9),RegGrb N(9),;
  CanSal N(14,4),CanSalA N(14,4),StkSal L(1),FlgSal L(1),CodSal C(14),;
  CanFor N(14,4),CanForA N(14,4),StkFor L(1),FlgFor L(1),CodFor C(14),;
  CanAdi N(14,4),CanAdiA N(14,4),StkAdi L(1),FlgAdi L(1),CodAdi C(14),;
  CanDev N(14,4),CanDevA N(14,4),FlgDev L(1),CodDev C(14),CnFmla N(14,4) )


USE &ArcTmp. ALIAS TEMPO EXCLUSIVE
IF !USED()
   RETURN .F.
ENDIF
INDEX ON NroDoc+TipPro+SubAlm+CodMat TAG DO_T01
ArcExt = PATHUSER+SYS(3)
COPY STRU TO (ArcExt) WITH CDX
SELE 0
USE (arcext) ALIAS EXTORNO ORDER DO_T01 EXCLUSIVE
IF !USED()
   RETURN .F.
ENDIF

* relaciones a usar *
SELE DO_T
SET RELA TO CodMat INTO CATG



SELE CO_T
SET RELA TO NroDoc INTO DO_T

=F1QEH([OK])
RETURN .T.
*******************
PROCEDURE pLlave
*******************
* buscamos control de correlativos *
*SELE DIVF
*SEEK GaClfDiv(1)+LEFT(sCodPrd,LEN(GaLenCod(1)))
*SELE CDOC
*SEEK [070]+[P]+LEFT(DIVF.CodFam,LEN(GaLenCod(1)))
*IF .NOT. FOUND()
*   DO f1msgerr WITH [Correlativo no existe.]
*   Ultecla = K_ESC
*   RETURN
*ENDIF
*SELE CO_T
*IF &sEsRgv.
*   sNroO_T = NroDoc
*ELSE
*   sNroO_T  = PADL(ALLTRIM(STR(CDOC.NroDoc)),LEN(CO_T.NroDoc),'0')
*   m.NroO_T = sNroO_T
*ENDIF
UltTecla = 0
*
do case
   case m.tpo_pro = [O_T ]     &&&& O/T
        DO CPIPGO_T.SPR
   case m.tpo_pro = [TRB ]     &&&& TRANSFORMACIONES
        DO CPIPGTRA.SPR       
   case m.tpo_pro = [FRU ]     &&&& PROCESO DE FRUTAS
        DO CPIPGFRU.SPR               
   case m.tpo_pro = [PRB ]     &&&& PRODUCCION DE BOTELLAS
        DO CPIPPBOT.SPR               
endcase
*
SELE CO_T
SEEK sNroO_T
RETURN
*****************
PROCEDURE pVerTodo
*****************
sNroO_T = CO_T.NroDoc
DO CapVarBd
*
do case
   case m.tpo_pro = [O_T ]     &&&& O/T
        DO CPIPGO_T.SPR
   case m.tpo_pro = [TRB ]     &&&& TRANSFORMACIONES
        DO CPIPGTRA.SPR       
   case m.tpo_pro = [FRU ]     &&&& PROCESO DE FRUTAS
        DO CPIPGFRU.SPR               
   case m.tpo_pro = [PRB ]     &&&& PRODUCCION DE BOTELLAS
        DO CPIPPBOT.SPR               
endcase
*
SELE CO_T
RETURN
******************
PROCEDURE CapVarBd
******************
lHayStock = .T.
dFchDoc  = CO_T.FchDoc
dFchFin  = CO_T.FchFin
fCanFin  = CO_T.CanFin
fCanObj  = CO_T.CanObj
sCodPrd  = CO_T.CodPro
sRespon  = CO_T.Respon
sCdArea  = CO_T.CdArea
cFlgEst  = CO_T.FlgEst
m.tipbat  = CO_T.TipBat
fFactor  = CO_T.Factor
m.FacAnt = CO_T.Factor
* Cargamos detalle de materiales directos y/o insumos ya registrados *
* a el archivo temporal.
IF m.Estoy = [EDITANDO]
	WAit window [Factor1=]+tran(m.facant,[999.9999]) 
	SELE extorno
	zap		
   SELE TEMPO
   ZAP
   SELE DO_T
   SEEK sNroO_T
   SCAN WHILE NRODOC = sNroO_T
        m.Reg_Ori  = RECNO()
        SCATTER MEMVAR
        SELE TEMPO
        APPEND BLANK
        GATHER MEMVAR
        =SEEK(CODMAT,[CATG])

        REPLACE DesMat  WITH CATG.DesMat
        REPLACE CanForA WITH CanFor
        REPLACE CanDevA WITH CanDev
        REPLACE CanSalA WITH CanSal
        REPLACE CanAdiA WITH CanAdi
        REPLACE NroReg  WITH m.Reg_Ori
        DO CASE
           CASE !FlgFor AND EMPTY(CodFor)
                LfCanDes = CanFor
                IF FacEqu>0
                   LfCanDes = CanFor*FacEqu
                ENDIF
                =SEEK(SubAlm+CodMat,[CALM])
                **** Verificamos si existe stock ****
                IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
                   lHayStock = .F.
                   REPLACE StkFor WITH .F.
                ELSE
                   REPLACE StkFor WITH .T.
                ENDIF
           CASE !FlgAdi AND EMPTY(CodAdi) AND CANADI#0 AND FlgFor
                LfCanDes = CanAdi
                IF FacEqu>0
                   LfCanDes = CanAdi*FacEqu
                ENDIF
                =SEEK(SubAlm+CodMat,[CALM])
                **** Verificamos si existe stock ****
                IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
                   lHayStock = .F.
                   REPLACE StkAdi WITH .F.
                ELSE
                   REPLACE StkAdi WITH .T.
                ENDIF
           CASE !FlgAdi AND EMPTY(CodAdi) AND CANADI#0 AND !FlgFor AND EMPTY(CODFOR)
                LfCanDes = CanAdi + CanFor
                IF FacEqu>0
                   LfCanDes = (CanFor+CanAdi)*FacEqu
                ENDIF
                =SEEK(SubAlm+CodMat,[CALM])
                **** Verificamos si existe stock ****
                IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
                   lHayStock = .F.
                   REPLACE StkAdi WITH .F.
                ELSE
                   REPLACE StkAdi WITH .T.
                ENDIF
        ENDCASE
       *** Solo para ponerse al dia
       *DO CASE
       *   CASE !FlgSal AND EMPTY(CodSal)
       *        LfCanDes = CanSal
       *        IF FacEqu>0
       *           LfCanDes = CanSal*FacEqu
       *        ENDIF
       *        =SEEK(SubAlm+CodMat,[CALM])
       *        **** Verificamos si existe stock ****
       *        IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
       *           lHayStock = .F.
       *           REPLACE StkSal WITH .F.
       *        ELSE
       *           REPLACE StkSal WITH .T.
       *        ENDIF
       *ENDCASE
       ***
        SELE DO_T
   ENDSCAN
ENDIF
* Fin : Carga de materiales directos

GnTotDel  = 0
STORE 0 TO aRegDel

SELE CO_T
RETURN
******************
PROCEDURE IniVarBd
******************
lHayStock = .T.
dFchDoc  = GdFecha
dFchFin  = {,,}
fCanFin  = 0.000
fCanObj  = 0.000
*sCodPrd  = SPACE(LEN(CO_T.CodPro))
sRespon  = SPACE(LEN(CO_T.Respon))
sCdArea  = SPACE(LEN(CO_T.CdArea))
cFlgEst  = [P]     && en Proceso,Terminada,Anulada,Registrada(sin empezar)
m.tipbat  = 1     && Normal,rEgularizaci¢n (Generalmente para empaque)
fFactor  = 1.00
GnTotDel = 0
SELE PO_T

STORE 0 TO aRegDel
DO Carga_Form WITH .T.
SELE CO_T
RETURN
*****************
PROCEDURE pEditar
*****************
SELE CO_T
Crear = .T.
IF CieDelMes(_MES)
   RETURN
ENDIF
IF &sEsRgv.
   Crear = .F.
   IF !F1_RLOCK(5)
      UltTecla = K_ESC
      RETURN
   ENDIF
   IF FlgEst = [A]
      DO F1MsgErr with [Acceso denegado]
      UltTecla = K_ESC
      UNLOCK
      RETURN
   ENDIF
   IF DTOS(FchDoc)<=[19960131]
      DO F1MsgErr with [Acceso denegado :regularizaciones por almacen]
      UltTecla = K_ESC
      UNLOCK
      RETURN
   ENDIF
   DO CapVarBd
ELSE
   DO IniVarBd
ENDIF
*
do case
   case m.tpo_pro = [O_T ]     &&&& O/T
        DO CPIPGO_T.SPR
   case m.tpo_pro = [TRB ]     &&&& TRANSFORMACIONES
        DO CPIPGTRA.SPR       
   case m.tpo_pro = [FRU ]     &&&& PROCESO DE FRUTAS
        DO CPIPGFRU.SPR               
   case m.tpo_pro = [PRB ]     &&&& PRODUCCION DE BOTELLAS
        DO CPIPPBOT.SPR               
endcase
*
IF UltTecla # K_ESC
   DO pGrabar
ENDIF
SELE CO_T
UNLOCK ALL
m.Estoy = [MOSTRANDO]
=SEEK(sNroO_T,[DO_T])
SELE DO_T
DO BROWS_OT with .T.,[DO_T]
DEACTIVATE WINDOW (m.bTitulo)
SHOW WINDOW (m.bTitulo) REFRESH TOP
RETURN
*******************
PROCEDURE Carga_Del
*******************
m.CurrArea = ALIAS()
SELE TEMPO
GO TOP
SCAN
   GnTotDel = GnTotDel + 1
   IF ALEN(aRegDel)<GnTotDel
      DIMENSION aRegDel(GnTotDel + 5)
   ENDIF
   aRegDel(GnTotDel) = NroReg
ENDSCAN
DIMENSION aRegDel(GnTotDel)
SELE (m.CurrArea)
RETURN
********************
PROCEDURE Carga_Form
********************

PARAMETER m.Nuevo
* cargamos insumos  y/o materiales directos seg£n formulaci¢n, que ser n
* requeridos para la producci¢n a un archivo temporal
=SEEK(sCodPrd,[CFPRO])
IF m.Nuevo
   FCanObj=CFPRO.CanObj
   fCanObj=FCanObj*fFacTor
   fCanFin=fCanObj
   SHOW GET fCanObj
   SHOW GET fCanFin
   SELE TEMPO
   ZAP
   SELE DFPRO
   SEEK sCodPrd
   SCAN WHILE CodPRo = sCodPrd
        SCATTER MEMVAR
        SELE TEMPO
        APPEND BLANK
        GATHER MEMVAR
        REPLACE NroDoc WITH sNroO_T
        =SEEK(CODMAT,[CATG])
        IF !CATG.NoProm
           m.TipPro = [PTA] && Insumos que no son envases
        ELSE
           m.TipPro = [PTB] && Insumos que si son envases
        ENDIF
        REPLACE TipPro  WITH m.TipPro
        REPLACE DesMat  WITH CATG.DesMat
        REPLACE CnFmLa  WITH DFPRO.CanReq*FFactor
        IF m.tipbat=2
           REPLACE CnFmla WITH IIF(m.TipPro=[PTB],FCanObj,0)
        ENDIF
        *---
        REPLACE CanFor WITH DFPRO.CanReq
        REPLACE CanFor WITH CanFor*fFactor
        IF CanFor=0
           REPLACE CanFor WITH IIF(m.TipPro=[PTB],FCanObj,0)
        ENDIF
        LfCanDes = CanFor
        IF FacEqu>0
           LfCanDes = CanFor*FacEqu
        ENDIF
        =SEEK(SubAlm+CodMat,[CALM])
        **** Verificamos si existe stock ****
        IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
           lHayStock = .F.
           REPLACE StkFor WITH .F.
        ELSE
           REPLACE StkFor WITH .T.
        ENDIF
        *---
        SELE DFPRO
   ENDSCAN
ELSE
   FCanObj=CFPRO.CanObj
   fCanObj=fCanObj*fFacTor
   IF EMPTY(CO_T.CanFin)
      fCanFin=fCanObj
   ENDIF
   SHOW GET fCanObj
   SHOW GET fCanFin
   SELE EXTORNO
   IF EOF()
      APPEND FROM (arcTmp)
   ENDIF
   SELE TEMPO
   GO TOP
   SCAN
     **IF !EMPTY(CodFor+CodAdi+CodDev)
     **   DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
     **   REPLACE CodFor WITH []
     **   REPLACE CodAdi WITH []
     **   REPLACE COdDev WITH []
     **ENDIF
     lFormula=SEEK(CodPro+SubAlm+CodMat,[DFPRO])
     =SEEK(CODMAT,[CATG])
     IF !CATG.NoProm
        m.TipPro = [PTA] && Insumos que no son envases
     ELSE
        m.TipPro = [PTB] && Insumos que si son envases
     ENDIF
     REPLACE TipPro  WITH m.TipPro
     WfCanFor = CnFmla
     IF WFCanFor <= 0
        WfCanFor = CanFor
     ENDIF
     WAit window [Factor1=]+tran(m.facant,[999.9999]) 

     WfCanFor = ROUND(WfCanFor/m.FacAnt*Ffactor,4)
     REPLACE CnFmla WITH WFCanFor
     REPLACE CanFor WITH WfCanFor
     IF CnFmla<=0 AND lFormula
        REPLACE CnFmla WITH DFPRO.CanReq*fFactor
        REPLACE CanFor WITH DFPRO.CanReq*fFactor
     ENDIF
     IF m.tipbat=2
        REPLACE CnFmla WITH IIF(m.TipPro=[PTB],FCanObj,0)
     ENDIF
     REPLACE CanAdi WITH 0
     REPLACE CanDev WITH 0
     LfCanDes = CanFor
     IF FacEqu>0
        LfCanDes = CanFor*FacEqu
     ENDIF
     **** Verificamos si existe stock ****
     LcTipMov=LEFT(CodFor,1)
     LsCodMov=SUBS(CodFor,2,3)
     LsNroDoc=SUBS(CodFor,5)
     IF CanFor#CanForA
        REPLACE FlgFor WITH .F.
     ENDIF
     IF CanAdi#CanAdiA
        REPLACE FlgAdi WITH .F.
     ENDIF
     IF CanDev#CanDevA
        REPLACE FlgDev WITH .F.
     ENDIF
     IF FlgFor
       IF !m.lStkNeg .AND. ;
          !HayStkAlm(SubAlm,CodMat,dFchDoc,LcTipMov,LsCodMov,LsNroDoc,LfCanDes,.f.)
          lHayStock = .F.
          REPLACE StkFor WITH .F.
       ELSE
          REPLACE StkFor WITH .T.
       ENDIF
     ELSE
        =SEEK(SubAlm+CodMat,[CALM])
        **** Verificamos si existe stock ****
        IF !m.lStkNeg .AND. ;
           !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
           lHayStock = .F.
           REPLACE StkFor WITH .F.
        ELSE
           REPLACE StkFor WITH .T.
        ENDIF
     ENDIF
     IF !EMPTY(CodFor+CodAdi+CodDev)
        REPLACE CodFor WITH []
        REPLACE CodAdi WITH []
        REPLACE COdDev WITH []
     ENDIF
   ENDSCAN
ENDIF
* Fin de carga de Insumos y/o Materiales directos (M.P.)
SELE CO_T
RETURN
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
******************
FUNCTION HayStkAlm
******************
PARAMETERS sSubAlm,sCodMat,dFecha,cTipmov,sCodMov,sNroDoc,fCandes,lNuevo
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
DO CASE
   CASE lNuevo
        =SEEK(sSubAlm+sCodmat,[CALM])
        LfStkSub=CALM.StkIni
        SELE DTRA
        SET ORDER TO DTRA02
        SEEK sSubAlm+sCodMat+DTOS(dFecha+1)
        IF !FOUND()
           IF RECNO(0)>0
              GO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        SKIP -1
        IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
           LfStkSub = StkSub
        ENDIF
        SELE (m.CurrArea)
        RETURN LfStkSub>=fCandes
   CASE .NOT. lNuevo
        =SEEK(sSubAlm+sCodmat,[CALM])
        LfStkSub=CALM.StkIni
        SELE DTRA
        SET ORDER TO DTRA02
        SEEK sSubAlm+sCodMat+DTOS(dFecha)+cTipMov+sCodMov+sNroDoc
        IF FOUND()
           SKIP -1
           IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
              LfStkSub = StkSub
           ENDIF
        ENDIF
        SELE (m.CurrArea)
        RETURN LfStkSub>=fCandes
ENDCASE
*****************
PROCEDURE pGrabar
*****************
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
*+-----------------------------------------------------------------------------+
*Ý GRBdO_T   Prototipo de grabaci¢n  de O_T y Actualizaci¢n a almacen          Ý
*Ý                                                                             Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
*****************
PROCEDURE GrbdO_t  && Comienza la chanfainita
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
*******************
FUNCTION ActAlmCen
*******************
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
*******************
*FUNCTION Impr_Item
*******************
*PRIVATE K,OK
*Ok=.F.
*FOR K = 1 TO nNumItmI
*    IF aImprimir(K)=SubAlm+TipMov+CodMov+NroDoc+CodMat
*       OK = .T.
*       EXIT
*    ENDIF
*ENDFOR
*RETURN OK
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
******************
PROCEDURE pImprime
******************
lCapConfig = .T.
DO Impr_Guias
lCapConfig = .F.
RETURN
********************
PROCEDURE Impr_Guias
********************
PRIVATE J,LsLLave,G
DO CierDbfPro
IF !AbreDbfAlm()
   DO F1MsgErr WITH [Error en apertura de archivos de almacen]
   DO CierDbfAlm
ENDIF

SELE CTRA
m.Tag = ORDER()
SET ORDER TO CTRA02
SEEK CO_T.NroDoc
SCAN WHILE NroOdt=CO_T.NroDoc
     IF lCapConfig
        m.TipMov = TipMov
        m.CodMov = CodMov
        IF !CAPVARCFG()
           DO F1MSGERR WITH [No se pudo capturar configuraci¢n]
        ENDIF
        SELE CTRA
     ENDIF
     WAIT WINDOW [Imprimiendo Guia:]+NroDoc+[ ALM:]+LEFT(ALMNOMBR(SubAlm),25)+[ ]+m.sDesmov NOWAIT
     IF TipMov=[I]
        DO pEmision IN AlmpMI1a
     ELSE
        DO pEmision IN AlmpMS1a
     ENDIF
     SELE CTRA
ENDSCAN
SELE CTRA
SET ORDER TO (m.Tag)
DO CierdbfAlm
=AbreDbfPro()
RETURN
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
********************
PROCEDURE Brows_OT
********************
PARAMETER lMostrar,m.Area
**M.VENPADRE=[WBROW1]
m.bTitulo = [COMP0NENTE]
m.bDeta   = [COMPONENTE]
IF lMostrar
   m.bClave1 = CO_T.NroDoc
   m.bClave2 = CO_T.NroDoc
ELSE
   m.bClave1 = sNroO_T
   m.bClave2 = sNroO_T
ENDIF
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = [bPreProg]
m.prgPost = [bFinProg]

nX0 = 7
nY0 = 1
nX1 = 20
nY1 = 74

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .T.
   lBorr_Reg = .T.
ENDIF

DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar

SELE CO_T
RETURN
*****************
PROCEDURE pBorrar
*****************
=F1QEH("BORR_REG")
IF CieDelMes(_MES)
   RETURN
ENDIF
DO CierDbfPro
IF !AbreDbfAlm()
   DO F1MsgErr WITH [Error en apertura de archivos de almacen]
   DO CierDbfAlm
   =AbreDbfPro()
   SELE CO_T
   RETURN
ENDIF

SELE CO_T
DO WHILE !RLOCK()
ENDDO
XsNroO_T= NroDoc
SELE DO_T
SEEK CO_T.NroDoc
DO WHILE !EOF() .AND. NroDoc = CO_T.NroDoc
   DO WHILE !RLOCK()
   ENDDO
   DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodMat
   DELETE
   UNLOCK
   SKIP
ENDDO
SELE PO_T
SEEK CO_T.NroDoc
SCAN WHILE NroDoc = CO_T.NroDoc
     DO WHILE !RLOCK()
     ENDDO
     DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodPrd
     DELETE
     UNLOCK
ENDSCAN
SELE CO_T
REPLACE FlgEst WITH [A]
UNLOCK
DO CierDbfAlm
=AbreDbfPro()

m.Estoy = [MOSTRANDO]
DO BROWS_OT with .T.,[DO_T]
DEACTIVATE WINDOW (m.bTitulo)
SHOW WINDOW (m.bTitulo) REFRESH TOP
=F1QEH("OK")
RETURN
******************
PROCEDURE bpreProg
******************
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
IF lPintar
   SELE TEMPO
   SET RELA TO
   SELE DO_T
   SET RELA TO CODMAT INTO CATG
ELSE
   SELE DO_T
   SET RELA TO
   SELE TEMPO
   SET RELA TO
ENDIF
SELE (m.CurrArea)
RETURN
******************
PROCEDURE bFinProg
******************
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
IF !lPintar
   fTotItm = 0
   GO TOP
   SCAN WHILE !EOF()
     =SEEK(CodMat,[CATG])
     IF !CATG.NoProm
        fTotItm = fTotItm + CnFmla
     ENDIF
   ENDSCAN
   =SEEK(CodPro,[CFPRO])
   m.Peso = CFPRO.Peso
   IF m.Peso=0 OR (CFPRO.CanObj<=0 OR CATG.UndEqu<=0)
   ELSE
      fCanObj = ROUN(fTotItm/m.Peso,3)
   ENDIF
   SHOW GET fCanObj
ENDIF
SELE (m.CurrArea)
RETURN
*******************
PROCEDURE DesAlmcen
*******************
PARAMETERS m.SubAlm,m.TipMov,m.CodMov,m.NroDoc,m.Fecha

SELE CTRA
SEEK m.SubAlm+m.TipMov+m.CodMov+m.NroDoc
IF !FOUND()
   DO F1msgerr WITH IIF(m.TipMov=[I],[Ingreso ],[Salida ])+m.CodMov+[ ]+m.NroDoc+[ no existe]
ENDIF
IF .NOT. f1_RLock(5)
   UltTecla = k_Esc
   RETURN              && No pudo bloquear registro
ENDIF
*IF FchDoc <= XdFchCie
*   GsMsgErr = [ Acceso Denegado ]
*   DO lib_merr WITH 99
*   UNLOCK
*   RETURN
*ENDIF

=F1QEH("BORR_REG")

IF FlgEst = [A]
   DELETE
   UNLOCK
   RETURN
ENDIF

m.NroDoc = CTRA->NroDoc
**
SELECT DTRA
SEEK (m.SubALm + m.TipMov + m.CodMov + m.NroDoc )
OK     = .T.
DO WHILE ! EOF() .AND.  OK .AND. ;
   (m.SubALm+m.TipMov+m.CodMov+m.NroDoc) = (SubALm+TipMov+CodMov+NroDoc)
   IF f1_Rlock(5)
      SELE CATG
      SEEK DTRA->CodMat
      SELE CALM
      SEEK m.SubAlm + DTRA->CodMat
      SELECT DTRA
      DELETE
      IF TipMov=[I]
         DO ALMpdsm2 WITH .T.
      ELSE
         DO ALMpcsm2 WITH .T.
      ENDIF
      UNLOCK
   ELSE
      OK = .F.
   ENDIF
   SKIP
ENDDO
** Actualizamos Cabecera de la ordenes **
SELECT CTRA
IF Ok
   REPLACE CODCLI WITH ""
   REPLACE CODPRO WITH ""
   REPLACE OBSERV WITH ""
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
UNLOCK ALL
=F1QEH("OK")
RETURN
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
*+-----------------------------------------------------------------------------+
*Ý ArrConfig   Carga arreglo de configuraci¢n para las actualizaciones de alma-Ý
*Ý             cen por producci¢n.                                             Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
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
     IF ALEN(aTipMov)<K)
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
********************
FUNCTION AbreDbfAlm
********************

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
********************
FUNCTION AbreDbfPro
********************
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



*+-----------------------------------------------------------------------------+
*Ý IngPTxAlm Ingresamos los productos terminados a los almacenes respectivos   Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
*******************
PROCEDURE IngPTxAlm
*******************
PRIVATE lMostrar,m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
m.Area   = [PO_T]
lMostrar = .F.
m.bTitulo = [DESTINO_PRODUCTO]
m.bDeta   = [DESTINO_PRODUCTO]
IF lMostrar
   m.bClave1 = PO_T.NroDoc
   m.bClave2 = PO_T.NroDoc
ELSE
   m.bClave1 = sNroO_T
   m.bClave2 = sNroO_T
ENDIF
m.bFiltro = [.T.]
LsModulo = sModulo
sModulo  = [INGP_T]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []

nX0 = 18
nY0 = 01
nX1 = 23
nY1 = 78

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .T.
   lBorr_Reg = .T.
ENDIF
*
m.lStatic = .F.
**** Variables adicionales ****
PdCanFin=0
PdSubAlm=[]
PdCodPrd=[]
*
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
*
sModulo = LsModulo
*
IF _DOS
   IF WOUTPUT(m.BTitulo)
      RELEASE WINDOW (m.bTitulo)
   ENDIF
ENDIF
if inlist(lastkey(),K_F10,K_CTRLW,K_ESC)
   _curobj = objnum(m.salir)
endif
SELE CO_T
RETURN
*******************
PROCEDURE pActivate
*******************
IF !EMPTY(m.bDeta)
   IF WVISIBLE(m.bDeta) AND m.bDeta<>m.bTitulo
      DEACTIVATE WINDOW (m.bDeta)
   ENDIF
ENDIF
DO CASE
   CASE m.Estoy=[EDITCLAVE]
   CASE m.Estoy = [EDITANDO] AND !m.Pll_btn
        SHOW GETS ENABLE
        SHOW GET sNroO_T DISABLE
        SHOW GET sCodPrd DISABLE
        IF TYPE("CVCTRL")=[C] AND cVctrl=[M] && Creando
           SHOW GET dFchDoc  DISABLE
        ENDIF
   CASE m.Estoy = [EDITANDO] AND m.Pll_btn
        SHOW GETS ENABLE
        SHOW GET sNroO_T  DISABLE
        SHOW GET sCodPrd  DISABLE
        IF TYPE("CVCTRL")=[C] AND cVctrl=[M] && Creando
           SHOW GET dFchDoc  DISABLE
        ENDIF
   CASE m.Estoy = [PIDLLAVE]
        SHOW GETS DISABLE
        SHOW GET sNroO_T  ENABLE
        IF TYPE("CVCTRL")=[C] AND cVctrl=[C] && Creando
           SHOW GET sCodPrd  ENABLE
        ENDIF

   CASE m.Estoy = [MOSTRANDO]
        SHOW GETS
        CLEAR READ
ENDCASE
*****************
PROCEDURE Extorno
*****************
IF !USED([ESTR])
   USE ALMESTTR ORDER ESTR01 ALIAS ESTR IN 0
   IF !USED()
       DO F1msgerr WITH [No se puede actualizar archivo almesttr.dbf]
       RETURN
   ENDIF
ENDIF
*
IF !USED([ESTA])
   USE ALMESTCM ORDER ESTA01 ALIAS ESTA IN 0
   IF !USED()
       DO F1msgerr WITH [No se puede actualizar archivo almestcm.dbf]
       RETURN
   ENDIF
ENDIF
DO ExtAlmcen  WITH .T.,sNroO_T,[],[]
DO Carga_Del
DO Carga_Form WITH .F.
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