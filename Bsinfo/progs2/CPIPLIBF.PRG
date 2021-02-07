
*+-----------------------------------------------------------------------------+
*Ý bDef_Cmp    Funci¢n que define los campos que se van a presentar en la ven- Ý
*Ý             tana browse, asi como las funciones asociadas al VALID,WHEN,cam-Ý
*Ý             calculados,encabezados y formatos de edici¢n (PICTURE)          Ý
*+-----------------------------------------------------------------------------+
*****************
FUNCTION bDef_Cmp
*****************
PARAMETERS sModulo
IF PARAMETERS() = 0
   WAIT "Falta definir campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER

ENDIF
PRIVATE sCmp
DO CASE
 CASE INLIST(sModulo,[FORMPROD])
  IF !INLIST(m.Estoy,[EDITANDO])
    sCmp = [SubAlm:H='ALM.':V=vSubAlm():E=sErr():F,CodMat:H='COD.MAT.']
    sCmp = sCmp +[:V=vCdMate():E=sErr:F,CATG.DesMat:H='DESCRIPCION':R:P='@S33']
    sCmp = sCmp +[:W=.F.,CanReq:H="Cantidad":P="##,###,###.####"]
    sCmp = sCmp +[:V=vCanRqu():E=sErr,UndPro:H="UND":V=bUndPro():E=FsErr():F]
   *sCmp = sCmp +[PCTOMN:P='######.##':H='P.UNI.S/.':V=PCTOMN>=0,]
   *sCmp = sCmp +[PCTOUS:P='######.##':H='P.UNI.US$':V=PCTOUS>=0]
  ELSE
    sCmp = [SubAlm:H='ALM.':V=vSubAlm():E=sErr():F,CodMat:H='COD.MAT.']
    sCmp = sCmp +[:V=vCdMate():E=sErr:F,DESMAT:H='DESCRIPCION':R:P='@S33']
    sCmp = sCmp +[:W=.F.,CanReq:H="Cantidad":P="##,###,###.####"]
    sCmp = sCmp +[:V=vCanRqu():E=sErr,UndPro:H="UND":V=bUndPro():E=FsErr():F]
   *sCmp = sCmp +[PCTOMN:P='######.##':H='P.UNI.S/.':V=PCTOMN>=0,]
   *sCmp = sCmp +[PCTOUS:P='######.##':H='P.UNI.US$':V=PCTOUS>=0]
  ENDIF
 CASE INLIST(sModulo,[PROGRAMA])
  IF !INLIST(m.Estoy,[EDITANDO])
    sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=sErr:F,]
    sCmp = sCmp +[CATG.DesMat:H='DESCRIPCION':R:P='@S33']
    sCmp = sCmp +[:W=.F.,CanPrg:H="Cantidad":P="#####,###.####"]
    sCmp = sCmp +[:V=vCanPrg():E=sErr,UndStk:H="UND":W=.F.]
  ELSE
    sCmp = [CodMat:H='COD.MAT.']
    sCmp = sCmp +[:V=vCdMatg():E=sErr:F,DESMAT:H='DESCRIPCION':R:P='@S33']
    sCmp = sCmp +[:W=.F.,CanPrg:H="Cantidad":P="#####,###.####"]
    sCmp = sCmp +[:V=vCanPrg():E=sErr,UndStk:H="UND":W=.F.]
  ENDIF

 CASE INLIST(sModulo,[GEN_O/T])
  IF !INLIST(m.Estoy,[EDITANDO])
   sCmp=[]
   sCmp= [SubAlm:H='ALM':V=vSubAlm():E=sErr():F,]
   sCmp= sCmp +[CodMat:H='COD.MAT.':W=wCdMat():V=vCdMate():E=sErr:F,]
   sCmp= sCmp +[CATG.DesMat:H='I N S U M O S':R:P='@S25':W=.F.,]
   sCmp= sCmp +[CanFor:H="Sal.ProducA":P="######.####":W=.F.,]
   sCmp= sCmp +[f=vStkFor():W=.F.,]
   sCmp= sCmp +[CanAdi:H="Sal.ProducB":P="######.####":V=vCanAdi():E=sErr,]
   sCmp= sCmp +[A=vStkAdi():W=.F.,UndPro:H="UN":W=.F.,]
   sCmp= sCmp +[CanDev:H="Devuelto":P="######.####":V=vCanDev():E=sErr,]
   sCmp= sCmp +[C=CanFor+CanAdi-CanDev:H="Utilizado":P="######.####"]
   IF GsUsuario=[MASTER]
      sCmp= sCmp +[,CanSal:H='Salida Real':P='######.####':W=wCanSal():V=vCanSal()]
   ENDIF

  ELSE
   sCmp = []
   sCmp = [SubAlm:H='ALM':V=vSubAlm():E=sErr():F,]
   sCmp = sCmp +[CodMat:H='COD.MAT.':W=wCdMat():V=vCdMate():E=sErr:F,]
   sCmp = sCmp +[DesMat:H='I N S U M O S':R:P='@S25':W=.F.,]
   sCmp = sCmp +[CanFor:H="Sal.ProducA":P="######.####":V=vCanFor():E=sErr:F,]
   sCmp = sCmp +[f=vStkFor():W=.F.,]
   sCmp = sCmp +[CanAdi:H="Sal.ProducB":P="######.####":V=vCanAdi():E=sErr:F,]
   sCmp = sCmp +[A=vStkAdi():W=.F.,UndPro:H="UN":W=.F.,]
   sCmp = sCmp +[CanDev:H="Devuelto":P="######.####":V=vCanDev():E=sErr,]
   sCmp= sCmp +[C=CanFor+CanAdi-CanDev:H="Utilizado":P="######.####"]
   IF GsUsuario=[MASTER]
    sCmp= sCmp +[,CanSal:H='Salida Real':P='######.####':W=wCanSal():V=vCanSal()]
   ENDIF
  ENDIF
**IF !INLIST(m.Estoy,[EDITANDO])
** sCmp = []
** sCmp = [SubAlm:H='ALM.':V=vSubAlm():E=sErr():F,]
** sCmp = sCmp +[CodMat:H='COD.MAT.':W=wCdMat():V=vCdMate():E=sErr:F,]
** sCmp = sCmp +[CATG.DesMat:H='I N S U M O S':R:P='@S25':W=.F.,]
** sCmp = sCmp +[CanFor:H="Formulado":P="##,###.####":W=.F.,]
** sCmp = sCmp +[CanSal:H="Sal. Real":P="##,###.####":V=vCanSal():E=sErr,]
** sCmp = sCmp +[A=vStkSal():W=.F.,UndPro:H="UND":W=.F.,]
** sCmp = sCmp +[CanDev:H="Devuelto":P="##,###.####":V=vCanDev():E=sErr,]
** sCmp = sCmp +[C=CanSal-CanDev:H="Utilizado":P="##,###.####"]
**ELSE
** sCmp = []
** sCmp = [SubAlm:H='ALM.':V=vSubAlm():E=sErr():F,]
** sCmp = sCmp +[CodMat:H='COD.MAT.':W=wCdMat():V=vCdMate():E=sErr:F,]
** sCmp = sCmp +[DesMat:H='I N S U M O S':R:P='@S25':W=.F.,]
** sCmp = sCmp +[CanFor:H="Formulado":P="##,###.####":W=.F.,]
** sCmp = sCmp +[CanSal:H="Sal. Real":P="##,###.####":V=vCanSal():E=sErr,]
** sCmp = sCmp +[A=vStkSal():W=.F.,UndPro:H="UND":W=.F.,]
** sCmp = sCmp +[CanDev:H="Devuelto":P="##,###.####":V=vCanDev():E=sErr,]
** sCmp = sCmp +[C=CanSal-CanDev:H="Utilizado":P="##,###.####"]
**ENDIF
 CASE INLIST(sModulo,[INGP_T])
    sCmp = [CodPrd:H='Producto.':w=wcodprd():v=vcodprd():f,]
    sCmp = sCmp + [v=vdesmat():H='Descripci¢n':R:P='@S20':w=.f.,]
    sCmp = sCmp + [SubAlm:H='ALM.':w=wSubAlm():V=vSubAlm():E=sErr():F,]
    sCmp = sCmp + [d=SUBSTR(AlmNombr(SubAlm),5):H='DESCRIPCION':R:P='@S20']
    sCmp = sCmp + [:W=.F.,CanFin:H="Cantidad":P="#####,###.###":]
    sCmp = sCmp + [w=wcanfin():V=vCanFin():E=sErr:F,]
    sCmp = sCmp + [costmn:H='Costo S/.':P='###,###,###.##':R,]
    sCmp = sCmp + [costus:H='Costo US$':P='###,###,###.##':R]
 CASE INLIST(sModulo,[ORDEN_T])
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
 CASE INLIST(sModulo,[CHQMOVPRO])
  sCmp = []
  sCmp = sCmp+[C1=IIF(EMPTY(COL01),DESMAT,COL01):H=LEFT(CATG.DesMat,30):P='@Z':30,]
  sCmp = sCmp+[C2=IIF(EMPTY(COL02),CnFormu,COL02):H='FORMULA':P='@Z':11,]
  sCmp = sCmp+[C3=IIF(EMPTY(COL03),CnBatch,COL03):H='BATCH'+TRAN(CO_T.Factor,'99.999'):P='@Z':11,]
  sCmp = sCmp+[C4=IIF(EMPTY(COL04),SalFor+SalAdi ,COL04):H='Sal.Real.':P='@Z':10,]
  sCmp = sCmp+[C5=IIF(EMPTY(COL05),IngDev ,COL05):H='Devoluci¢n':P='@Z':10,]
  sCmp = sCmp+[C6=IIF(EMPTY(COL06),SalRea ,COL06):H='Consumo Prod.':P='@Z':10,]
  sCmp = sCmp+[C7=IIF(EMPTY(COL07),CsmAlm ,COL07):H='Consumo Alm.':P='@Z':10,]
  sCmp = sCmp+[C9=IIF(EMPTY(COL08),SalRea-CsmAlm,COL08):H='Diferencia':P='@Z':10]
  
  CASE INLIST(sModulo,[PRECIOALM])
    sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S35':W=.F.,]
    sCmp = sCmp+[CATG.UndStk:H='UND':R:W=.F.,]
    sCmp = sCmp+[PuinMN:H='PRE.UNI. S/.':P='9999,999.999':V=PuinMN>=0,]
    sCmp = sCmp+[PuinUS:H='PRE.UNI. US$':P='9999,999.999':V=PuinUS>=0]
  CASE INLIST(sModulo,[PROG_VPT])
    sCmp = [CodEqu,Descrip]

 OTHER
    WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
    RETURN TO MASTER
ENDCASE
RETURN sCmp
****************
FUNCTION vEleAlm
****************
IF DELETED()
   RETURN .T.
ENDIF
SCATTER MEMVAR
IF TYPE([ADESALM])=[U]
   DIMENSION aDesAlm(ALEN(GaSubAlm,1))
   FOR K = 1 TO ALEN(GaSubAlm,1)
       aDesAlm(K) = GaSubAlm(K,1)+[ ]+GaSubAlm(K,2)
   ENDFOR
ENDIF
lValido =F1ASELEC(m.SubAlm,aDesAlm,.F.,LEN(SubAlm))
IF lValido
   GATHER MEMVAR FIELDS SubAlm
ENDIF
RETURN
****************
funCtion wsubalm
****************
PdSubAlm=SubAlm
****************
FUNCTION vSubAlm
****************
IF DELETED()
   RETURN .T.
ENDIF
SCATTER MEMVAR
lValido =F1_BUSCA(m.SubAlm,"SUBALM","ALMA","ALMA","",.F.,"")
IF lValido
   =SEEK(m.SubAlm,[ALMA])
   DO CASE
      CASE sModulo = [FORMPROD]
          GATHER MEMVAR FIELDS SubAlm
          @ 20,4 SAY "ALMACEN:"+LEFT(ALMA.DesSub,25)
      CASE sModulo = [INGP_T]
		m.FchFin  = dFchFin
        m.SubAlmA = PdSubAlm
		repla SubAlm  WITH m.SubAlm
		repla FchFin  WITH dFchFin
		repla SubAlmA WITH PdSubAlm          	
   ENDCASE
ENDIF
RETURN
FUNCTION wCdMat
*RETURN EMPTY(CodMat)
RETURN .t.
*
****************
FUNCTION vDesMat
****************
private m.desmat
scatter memvar
=seek(m.codprd,[catg])
m.desmat = catg.desmat
return m.desmat
*
****************
FUNCTION wCODPRD
****************
PdCodPrd = CodPrd
****************
FUNCTION VCODPRD
****************
if deleted()
   return .t.
endif
scatter memvar
lvalido=f1_busca(m.codprd,[CODMAT],[FORM],[FORM],[],.t.,[])
if lvalido
   do while !rlock([po_t])
   enddo
   IF !EMPTY(CodP_T)
	   repla po_t.CodPrdA WITH PdCodPrd
   ENDIF
   repla po_t.codprd with m.codprd
   unlock
endif
return lvalido
*
****************
FUNCTION vCdMate
****************
IF DELETED()
   RETURN .T.
ENDIF

PRIVATE m.CurArea,iNroReg
SCATTER MEMVAR
iNroReg = RECNO()
m.CurArea = ALIAS()
*SELE CALM
*SET RELA TO
*SELE CATG
*SET RELA TO m.SubAlm+CodMat INTO CALM
*SET FILTER TO m.SubAlm+CodMat = CALM.SubAlm+CALM.CodMat
 lValido = F1_BUSCA(m.CodMat,"CODMAT","CATG","CATG",[],.f.,"")
*SELE CATG
*SET FILTER TO
*SET RELA TO
*SELE (m.CurArea)
lAsig=SEEK(m.SubAlm+m.CodMat,"CALM")
IF !lValido
   sErr = [Codigo de material inv lido]
ENDIF
IF !lAsig
   sErr = [Material no asignado a este almacen]
   lValido  = .F.
ENDIF
GO iNroReg
IF lValido
  *GATHER MEMVAR FIELDS CodMat
   =SEEK(m.CodMat,"CATG")
   m.UndStk = CATG.UndStk
   DO CASE
      CASE INLIST(sModulo,[FORMPROD])
           =SEEK(m.CodMat,"CATG")
           m.UndStk = CATG.UndStk
           m.DesMat = CATG.DesMat
           IF EMPTY(m.UndPro)
              m.UndPro = m.UndStk
           ENDIF
           GATHER MEMVAR FIELDS CodMat,UndStk,UndPro,DesMat
      CASE INLIST(sModulo,[GEN_O/T])
           =SEEK(m.CodMat,"CATG")
           IF !CATG.NoProm
              m.TipPro = [PTA] && Insumos que no son envases
           ELSE
              m.TipPro = [PTB] && Insumos que si son envases
           ENDIF
           m.UndStk = CATG.UndStk
           m.DesMat = CATG.DesMat
           IF EMPTY(m.UndPro)
              m.UndPro = m.UndStk
           ENDIF
           
**           GATHER MEMVAR FIELDS CodMat,UndStk,UndPro,DesMat,TipPro
			replace CodMat WITH m.CodMat
			replace DesMat WITH m.UNdStk
			replace UndPro WITH m.UndPro
			replace DesMat WITH m.DesMat	
			replace TipPro WITH m.TipPro
      OTHER
           GATHER MEMVAR FIELDS CodMat
   ENDCASE
ENDIF
RETURN lValido
****************
FUNCTION vCdMatg
****************
IF DELETED()
   RETURN .T.
ENDIF
SCATTER MEMVAR
lValido = F1_BUSCA(m.CodMat,"CODMAT","CATG","CATG","",.f.,"")
*lAsig=SEEK(GsSubAlm+m.CodMat,"CALM")
*IF !lAsig
*   sErr = [Material no asignado a este almacen]
*   lValido  = .F.
*ENDIF
IF !lValido
   sErr = [Codigo de material inv lido]
ENDIF
IF lValido
   GATHER MEMVAR FIELDS CodMat
   =SEEK(m.CodMat,"CATG")
   m.UndStk = CATG.UndStk

   DO CASE
      CASE INLIST(sModulo,[FORMPROD],[GEN_O/T])
           IF EMPTY(m.UndPro)
              m.UndPro = m.UndStk
           ENDIF
           GATHER MEMVAR FIELDS CodMat,UndStk,UndPro
      CASE INLIST(sModulo,[PROGRAMA])
           GATHER MEMVAR FIELDS CodMat,UndStk
      OTHER
           GATHER MEMVAR FIELDS CodMat
   ENDCASE
ENDIF
RETURN lValido
****************
FUNCTION wCanSal
****************
scatter memvar
RETURN .T.
****************
FUNCTION vCanSal
****************
sErr = []
DO CASE
   CASE CanSal<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
****************
FUNCTION vSTKSal
****************
DO CASE
   CASE  StkSal AND CanSal>0
      RETURN [o]
   CASE !StkSal AND CanSal>0
      RETURN [x]
   CASE !StkSal AND CanSal<=0
      RETURN [.]
   OTHER
      RETURN [ ]
ENDCASE
****************
FUNCTION vCanAdi
****************
DO CASE
   CASE CanAdi<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
LfCanAdi = CanAdi
LfCanFor = CanFor
IF FacEqu>0
   LfCanAdi = CanAdi*FacEqu
   LfCanFor = CanFor*FacEqu
ENDIF
=SEEK(SubAlm+CodMat,[CALM])
**** Verificamos si existe stock ****
IF NroReg<=0
   LfCanDes = LfCanAdi + LfCanFor
   IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
      REPLACE StkAdi WITH .F.
      sErr = [** No hay Stock **]
      WAIT WINDOW sErr NOWAIT
   ELSE
      REPLACE StkAdi WITH .T.
   ENDIF
ELSE
   ** Verificamos stock para formula **
   LcTipMov=LEFT(CodFor,1)
   LsCodMov=SUBS(CodFor,2,3)
   LsNroDoc=SUBS(CodFor,5)
   IF FlgFor
   ELSE
      IF ! m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanFor,.T.)
         REPLACE StkFor WITH .F.
         sErr = [** No hay Stock para salida a producci¢n **]
         WAIT WINDOW sErr NOWAIT
      ELSE
         REPLACE StkFor WITH .T.
      ENDIF
   ENDIF
   ** Verificamos stock adicional **
   LcTipMov=LEFT(CodAdi,1)
   LsCodMov=SUBS(CodAdi,2,3)
   LsNroDoc=SUBS(CodAdi,5)
   DO CASE
      CASE FlgAdi AND !FlgFor
         LfCanDes = LfCanFor + LfCanAdi
         IF ! m.lStkNeg .AND.;
            !HayStkAlm(SubAlm,CodMat,dFchDoc,LcTipMov,LsCodMov,LsNroDoc,LfCanDes,.f.)
            REPLACE StkAdi WITH .F.
            sErr = [** No hay Stock para salida adicional **]
            WAIT WINDOW sErr NOWAIT
         ELSE
            REPLACE StkAdi WITH .T.
         ENDIF
      CASE !FlgAdi AND !FlgFor
         LfCanDes = LfCanAdi + LfCanfor
         =SEEK(SubALm+CodMat,[CALM])
         IF ! m.lStkNeg AND !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
            REPLACE StkAdi WITH .F.
            sErr = [** No hay Stock para salidas a producci¢n **]
            WAIT WINDOW sErr NOWAIT
         ELSE
            REPLACE StkAdi WITH .T.
         ENDIF
      CASE !FlgAdi AND FlgFor
         LfCanDes = LfCanAdi
         =SEEK(SubALm+CodMat,[CALM])
         IF ! m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
            REPLACE StkAdi WITH .F.
            sErr = [** No hay Stock para salida adicional **]
            WAIT WINDOW sErr NOWAIT
         ELSE
            REPLACE StkAdi WITH .T.
         ENDIF
   ENDCASE
ENDIF

IF (CanAdi#CanAdiA)
   REPLACE FlgAdi WITH .F.
ENDIF
IF (CanFor#CanForA)
   REPLACE FlgFor WITH .F.
ENDIF
RETURN .T.
****************
FUNCTION vCanFor
****************
DO CASE
   CASE CanFor<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
LfCanAdi = CanAdi
LfCanFor = CanFor
IF FacEqu>0
   LfCanAdi = CanAdi*FacEqu
   LfCanFor = CanFor*FacEqu
ENDIF
=SEEK(SubAlm+CodMat,[CALM])
**** Verificamos si existe stock ****
IF NroReg<=0
   LfCanDes = LfCanFor
   IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanDes,.T.)
      REPLACE StkFor WITH .F.
      sErr = [** No hay Stock para salida a producci¢n **]
      ?chr(7)
      WAIT WINDOW sErr NOWAIT
   ELSE
      REPLACE StkFor WITH .T.
   ENDIF
ELSE
   ** Verificamos stock para formula **
   LcTipMov=LEFT(CodFor,1)
   LsCodMov=SUBS(CodFor,2,3)
   LsNroDoc=SUBS(CodFor,5)
   IF FlgFor
      IF ! m.lStkNeg .AND.;
         !HayStkAlm(SubAlm,CodMat,dFchDoc,LcTipMov,LsCodMov,LsNroDoc,LfCanFor,.f.)
         REPLACE StkFor WITH .F.
      ELSE
         REPLACE StkFor WITH .T.
      ENDIF
   ELSE
      =SEEK(SubAlm+CodMat,[CALM])
      IF ! m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,dFchDoc,[],[],[],LfCanFor,.T.)
         REPLACE StkFor WITH .F.
         ?chr(7)
         sErr = [** No hay Stock para salida por formula **]
         WAIT WINDOW sErr NOWAIT
      ELSE
         REPLACE StkFor WITH .T.
      ENDIF
   ENDIF
ENDIF

IF (CanFor#CanForA)
   REPLACE FlgFor WITH .F.
ENDIF
RETURN .T.
****************
FUNCTION vSTKADI
****************
DO CASE
   CASE  StkAdi AND CanAdi>0
      RETURN [o]
   CASE !StkAdi AND CanAdi>0
      RETURN [x]
   CASE !StkAdi AND CanAdi<=0
      RETURN [.]
   OTHER
      RETURN [ ]
ENDCASE
****************
FUNCTION vSTKFOR
****************
DO CASE
   CASE  StkFor AND CanFor>0
      RETURN [o]
   CASE !StkFor AND CanFor>0
      RETURN [x]
   CASE !StkFor AND CanFor<=0
      RETURN [.]
   OTHER
      RETURN [ ]
ENDCASE
****************
FUNCTION vCanRqu
****************
DO CASE
   CASE CanReq<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
RETURN .T.
****************
FUNCTION vCanPrg
****************
DO CASE
   CASE CanPrg<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
RETURN .T.
****************
FUNCTION vCanDev
****************
DO CASE
   CASE CanDev>CanFor+CanAdi
     sErr = [Devoluci¢n no puede ser mayor a cantidad requerida]
     RETURN .F.
   CASE CanDev<0
     sErr = [Cantidad debe ser mayor o igual a cero]
     RETURN .F.
ENDCASE
IF CanDev#CanDevA
   REPLACE FlgDev WITH .F.
ENDIF
RETURN .T.
****************
FUNCTION bDesmat
****************
PRIVATE sOrdAct,sDesMat
IF ALIAS()=[CALM]
   sDesMat = IIF(SEEK(CALM.CodMat,[CATG]),CATG.DesMat,[])
ELSE
   IF EMPTY(CodMat)
      sDesMat = []
   ELSE
      sDesMat = IIF(SEEK(CodMat,[CATG]),CATG.DesMat,[])
   ENDIF
ENDIF
RETURN sDesMat
****************
FUNCTION bUndPro
****************
SCATTER MEMVAR
PRIVATE iRegAct
iRegAct = RECNO()
fDensidad = IIF(SEEK(m.CodMat,[CATG]),CATG.Densidad,0)
DO CASE
  CASE fDensidad>0
    SELE EQUN
    SET ORDER TO EQUN03
    SET FILTER TO
    SELE TEMPO
    lValido=F1_Busca(m.UndPro,"UNDVTA","DENS","EQUN",m.CodMat+m.UndStk,.F.,"")
  OTHER
    SELE EQUN
    SET ORDER TO EQUN01
    SET FILTER TO empty(CODMAT)
    GO TOP
    SELE TEMPO
    lValido=F1_Busca(m.UndPro,"UNDVTA","EQUN","EQUN",m.UndStk,.F.,"")
ENDCASE
sErr = [Unidad de formulaci¢n inv lida]
lValido = lValido OR m.UndPro==m.UndStk
IF lValido

   m.FacEqu = EQUN.FacEqu
   IF m.UndPro=m.UndStk
      m.FacEqu = 1
   ENDIF
   GO iRegAct
   GATHER MEMVAR FIELDS UndPro,FacEqu
ENDIF
RELEASE iRegAct
RETURN lValido

****************
FUNCTION vStkIni
****************
sErr = "Cantidad debe ser mayor o igual a cero"
lValido = STKINI>=0
lGrb_Arch = .T.
RETURN lValido

****************
FUNCTION vVINIMn
****************
sErr = "Valor debe ser mayor o igual a cero"
SCATTER MEMVAR
IF m.VIniUS = 0
   IF m.fTpoCmb > 0
      m.VIniUS = ROUND(m.VIniMN/m.fTpoCmb,2)
   ENDIF
ENDIF
lValido = (m.ViniMn>0)
IF lValido
   GATHER MEMVAR FIELD VIniMn,VIniUs
   lGrb_Arch = .T.
ENDIF
RETURN lValido

****************
FUNCTION vVIniUs    && VINIMn VALID
****************
sErr = "Valor debe ser mayor o igual a cero"
lValido = (VIniUs >=0)
lGrb_Arch = .T.
IF lValido AND lGrb_Arch
   DO Brw_Grab
   lGrb_Arch = .F.
ENDIF
RETURN lValido
****************
function wcanfin
****************
pdcanfin=canfin
****************
FUNCTION vCanFin
****************
SCATTER MEMVAR
IF m.CanFin<0
   sErr = [Cantidad debe ser mayor o igual a cero]
   RETURN .F.
ENDIF
Private TfCanFin,m.Reg_Act
TfCanFin = 0
lValido = .T.
m.Reg_Act = RECNO()
SEEK sNroO_T
SCAN WHILE NroDoc=sNroO_t
    TfCanFin = TfCanFin + CanFin
ENDSCAN
GO m.Reg_Act
IF TfCanFin>fCanFin
   sErr = [Total no debe exceder a la cantidad final producida]
   lValido = .F.
ENDIF
IF lValido
  *m.CanFinA = CanFin
   m.CanFinA = PdCanFin
   GATHER MEMVAR FIELDS CanFin,CanFinA
ENDIF
RETURN lValido
********************
PROCEDURE bBorra_Reg
********************
IF !lBorra
   =F1QEH("No es posible borrar registro")
   RETURN
ENDIF
m.RegAct = RECNO()
IF TYPE([NroReg])=[N]
   GnTotDel = GnTotDel + 1
   IF ALEN(aRegDel)<GnTotDel
      DIMENSION aRegDel(GnTotDel + 5)
   ENDIF
   aRegDel(GnTotDel) = NroReg
ENDIF
DELE
m.RegPrm=RECNO()+1
GO TOP
IF RECCOUNT()>=m.RegPrm
   GO m.RegPrm
ENDIF
blBorrar = .T.
DEACTIVATE WINDOW (m.bDeta)
SHOW WINDOW (m.bDeta) REFRESH TOP
IF INLIST(sModulo,[GEN_O/T],[FORMPROD],[INGP_T])
	if sModulo=[INGP_T]
	   _CURoBJ=ObjNum(m.dFchFin)
	else
	   _CURoBJ=ObjNum(m.CtrlBrw)
   endif
   KEYBOARD CHR(13)
ENDIF
*********************
PROCEDURE bAgrega_Reg
*********************
PRIVATE EOF1
IF !lAdiciona
   =F1QEH("No es posible a¤adir registro")
   RETURN
ENDIF
EOF1 = EOF()
APPEND BLANK
DO CASE
   CASE INLIST(sModulo,[FORMPROD])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE CodPro WITH m.CodPro
        UNLOCK
   CASE INLIST(sModulo,[GEN_O/T])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE NroDoc WITH sNroO_T
        REPLACE TipPro WITH [PTA]
        REPLACE CodPro WITH sCodPrd
        UNLOCK
   CASE INLIST(sModulo,[INGP_T])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE CodPrd WITH sCodPrd
        REPLACE NroDoc WITH sNroO_T
        REPLACE FchFin WITH dFchFin
        UNLOCK
   CASE INLIST(sModulo,[VTA_PT_M])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE Periodo WITH GsAnoMes
        UNLOCK

   CASE INLIST(sModulo,[SIST_REQU])
        DO WHILE !RLOCK([REQU])
        ENDDO
        REPLACE Area    WITH LsArea
        REPLACE Sistema WITH GsSisTema
        replace sede    with LsSede
        UNLOCK IN [REQU]

ENDCASE
IF EOF1
   GO TOP
   DEACTIVATE WINDOW (m.bDeta)
   SHOW WINDOW (m.bDeta) REFRESH TOP
   IF INLIST(sModulo,[GEN_O/T],[FORMPROD],[INGP_T])
		if sModulo=[INGP_T]
		   _CURoBJ=ObjNum(m.dFchFin)
		else
		   _CURoBJ=ObjNum(m.CtrlBrw)
	   endif
	   KEYBOARD CHR(13)
   ENDIF

ENDIF
RETURN

*+----------------------------------------------------------------------------+
*Ý                                                                            Ý
*Ý vBrw      VALID      del browse a nivel de registro                        Ý
*Ý                                                                            Ý
*Ý                                                                            Ý
*+----------------------------------------------------------------------------+

FUNCTION vBrw

DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
       IF TYPE("NroItm")="N"
          IF NroItm<>RECNO()
             REPLACE NroItm WITH RECNO()
          ENDIF
       ENDIF
   CASE INLIST(sModulo,[APERTURA])
      IF lGrb_Arch
         DO Brw_Grab
         lGrb_Arch = .F.
      ENDIF
      *@ 22,14 SAY CATG.DESMAT PICT "@S40"
   CASE INLIST(sModulo,[GEN_O/T]) AND ALIAS()=[TEMPO]
        DO WHILE !RLOCK()
        ENDDO
        IF EMPTY(NroDoc)
           REPLACE NroDoc WITH sNroO_T
        ENDIF
        IF EMPTY(CodPro)
           REPLACE CodPro WITH sCodPrd
        ENDIF
        IF EMPTY(TipPro)
           =SEEK(CODMAT,[CATG])
           IF !CATG.NoProm
              m.TipPro = [PTA] && Insumos que no son envases
           ELSE
              m.TipPro = [PTB] && Insumos que si son envases
           ENDIF
           REPLACE TipPro  WITH m.TipPro
        ENDIF
        IF CnFmla=0
           REPLACE CnFmla WITH CanFor
        ENDIF
        IF m.TipBat=2
			REPLACE CnFmla WITH CanFor + CanAdi
		ENDIF
        IF FacEqu=0
           REPLACE FacEqu WITH 1
        ENDIF
        UNLOCK
ENDCASE

*+----------------------------------------------------------------------------+
*Ý                                                                            Ý
*Ý wBrw      WHEN       del browse a nivel de registro                        Ý
*Ý                                                                            Ý
*Ý                                                                            Ý
*+----------------------------------------------------------------------------+
*************
FUNCTION wBrw
*************
IF DELETED()
   RETURN .F.
ENDIF
DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
        IF TYPE("NroItm")="N"
           IF NroItm<>RECNO()
              REPLACE NroItm WITH RECNO()
           ENDIF
        ENDIF
   CASE INLIST(sModulo,[APERTURA])
       =SEEK(CODMAT,"CATG")
       @ 22,14 SAY CATG.DESMAT PICT "@S40"
       lGrb_Arch = .F.
   CASE INLIST(sModulo,[GEN_O/T])
		=SEEK(CODMAT,"CATG")
		** SubAlm,05 : CodMat,42
		=SEEK(CODMAT,[CATG])
		LsXXDes=LEFT(SUBS(ALMNOMBR(SubALm),5),17)+[ Mat.:]
		LsXXDes=LsXXDes+LEFT(CATG.DesMat,35)+[ F:]+TRAN(CnFmla,'999999.9999')
		STORE WOUTPUT() TO currwind
		IF SYS(2016) = "" OR SYS(2016) = "*"
			ACTIVATE SCREEN
   		    @ SROW()-4,01 SAY  LsXXDes FONT "MS Sans Serif", 8
		ENDIF
		IF NOT EMPTY(currwind)
			ACTIVATE WINDOW (currwind) SAME
		ENDIF
       lGrb_Arch = .F.
   CASE sModulo = [FORMPROD]
       @ 20,4 SAY "ALMACEN:"+SUBS(ALMNOMBR(SubAlm),5)
ENDCASE
RETURN .T.
*******************
PROCEDURE pRefresco
*******************
IF !m.lPidRf1
   m.sNroRf1 = []
   SHOW GET m.sNroRf1 DISABLE
   @ 5,1 CLEAR TO 5,26
ENDIF
IF !m.lPidRf2
   m.sNroRf1 = []
   SHOW GET m.sNroRf2 DISABLE
   @ 6,1 CLEAR TO 6,26
ENDIF
IF !m.lPidOdt
  *m.sNroOdt = []
   SHOW GET m.sNroOdt DISABLE
   @ 7,1 CLEAR TO 7,26
ENDIF

IF !m.lPidVen
   m.sCodVen = []
   SHOW GET m.sCodVen DISABLE
   @ 6,28 CLEAR TO 6,78
ENDIF

IF !m.lPidCli
   m.sCodCli = []
ENDIF


IF !m.lPidPro
   m.sCodPro = []
ENDIF

IF !m.lPidPro AND !lPidCli
   m.sCodAux = []
   SHOW GET m.sCOdAux DISABLE
   @5,28 CLEAR TO 5,78
ENDIF
IF !m.lPidPco
   SHOW GET m.fImpBrt DISABLE
   SHOW GET m.fPorIgv DISABLE
   SHOW GET m.fImpIgv DISABLE
   SHOW GET m.fImpTot DISABLE
   @ 19,1 CLEAR TO 20,65
ELSE

ENDIF

RETURN
******************
FUNCTION  _Cuales
******************
PARAMETER _Cual
DO CASE
   CASE _Cual = 1
     RETURN [    Solo Materiales con Stock     ]
   CASE _Cual = 2
     RETURN [Todos los Materiales Seleccionados]
   OTHER
     RETURN [ ]
ENDCASE
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 ;
   .OR. SaltoPag
   SaltoPag = .F.
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,Ancho -12  SAY "Continua.."
   ENDIF
   DO F0MBPRN
   IF InKey() = K_ESC
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
******************
PROCEDURE CPIREVIS
******************
IF !USED([CATG])
    SELE 0
    USE ALMCATGE ORDER CATG01 ALIAS CATG
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
IF !USED([CFTR])
    SELE 0
    USE ALMCftra ORDER CFTR01 ALIAS CFTR
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
IF !USED([CFTRX])
    SELE 0
    USE \APLICA\TRASLADO\CFTRLIMA ORDER CFTR01 ALIAS CFTRX
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
IF !USED([DFPRO])
    SELE 0
    USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
*
IF !USED([CFPRO])
    SELE 0
    USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
*
IF !USED([CO_T])
    SELE 0
    USE CPICO_TB ORDER CO_T01 ALIAS CO_T
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
*
IF !USED([DO_T])
    SELE 0
    USE CPIDO_TB ORDER DO_T01 ALIAS DO_T
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
*
SELE DO_T
SET ORDER TO
GO TOP
SCAN
    WAIT WINDOW [ACTUALIZANDO:]+NRODOC+[,]+CODPRO NOWAIT
    =SEEK(CODPRO+SUBALM+CODMAT,[DFPRO])
    =SEEK(CODMAT,[CATG])
    =SEEK(NRODOC,[CO_T])
    DO WHILE !RLOCK()
    ENDDO
    IF DTOS(CO_T.FCHDOC)>=[19960210] AND NRODOC=CO_T.NRODOC
       REPLACE CODFOR WITH CODSAL
       REPLACE FLGFOR WITH FLGSAL
       REPLACE STKFOR WITH STKSAL
       REPLACE CANFOR WITH CANSAL
       REPLACE CANFORA WITH CANSALA
    ENDIF
    IF !CATG.NoProm
       REPLACE TIPPRO WITH [PTA]
    ENDIF
    IF CATG.NoProm
       REPLACE TIPPRO WITH [PTB]
    ENDIF
    IF CODPRO+SUBALM+CODMAT=DFPRO.CODPRO+DFPRO.SUBALM+DFPRO.CODMAT
       REPLACE Cnfmla WITH DFPRO.CanReq
    ENDIF
    UNLOCK
ENDSCAN
*
SELE CFTRX
WAIT WINDOW [TRANSFIRIENDO CONFIGURACION DE TRANSACCIONES] NOWAIT
SCAN FOR MOVPRO = 1
     SCATTER MEMVAR
     WAIT WINDOW TIPMOV+[ ]+CODMOV+[ ]+DESMOV NOWAIT
     SELE CFTR
     SEEK CFTRX.TIPMOV+CFTRX.CODMOV
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
     ELSE
        GATHER MEMVAR
     ENDIF
     SELE CFTRX
ENDSCAN
CLOSE DATA
=F1QEH([OK])
RETURN
******************
PROCEDURE CPIPASTR
******************
=F1_BASE(GsNomCia,GsNomSub,"Usuario:"+GsUsuario,GsFecha)
UltTecla = 0

IF  F1_ALERT([Este proceso tiene por objeto actualizar las estructuras  ;]+;
             [de las bases datos que han sido modificadas en la  sede   ;]+;
             [central. Los modelos de las nuevas estructuras deben loca-;]+;
             [lizarse en el directorio \APLICA\TRASLADO\ los nombres de ;]+;
             [los archivos se caracterizan por el siguiente formato :   ;]+;
             [????????.STR . Si no se esta seguro de estos requisitos es;]+;
             [mejor desistir. Y consultar con la oficina central.       ;]+;
             [Este proceso realiza una apertura exclusiva de los archi- ;]+;
             [vos por lo que deber  ser £nica tarea realizada por el    ;]+;
             [sistema.                                                  ;],4)#1
    RETURN
ENDIF

IF UltTecla = K_ESC
   RETURN
ENDIF
CLOSE DATA
=F1QEH([Actualizando catalogo de materiales...])
IF !USED([CATG])
    SELE 0
    USE ALMCATGE ALIAS CATG EXCL
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
IF !USED([CATGX])
    SELE 0
    USE \APLICA\TRASLADO\almcatge.str ALIAS CATGX
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
SELE CATG
COPY TO CATGTMP
ZAP
USE
SELE CATGX
COPY STRU TO ALMCATGE
IF !USED([CATG])
    SELE 0
    USE ALMCATGE ALIAS CATG EXCL
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
SELE CATG
APPEND FROM CATGTMP
CLOSE DATA
DELE FILE CATGTMP.DBF
=F1QEH([OK])
**
**=F1QEH([Actualizando tabla de almacenes...])
**IF !USED([ALMA])
**    SELE 0
**    USE ALMTALMA ALIAS ALMA EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**IF !USED([ALMAX])
**    SELE 0
**    USE \APLICA\TRASLADO\ALMALIMA ALIAS ALMAX
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE ALMA
**COPY TO ALMATMP
**ZAP
**USE
**SELE ALMAX
**COPY STRU TO ALMTALMA
**IF !USED([ALMA])
**    SELE 0
**    USE ALMTALMA ALIAS ALMA EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE ALMA
**APPEND FROM ALMATMP
**CLOSE DATA
**=F1QEH([OK])
****
=F1QEH([Actualizando Cabecera de producci¢n...])
IF !USED([CO_T])
    SELE 0
    USE CPICO_TB ALIAS CO_T EXCL
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
IF !USED([CO_TX])
    SELE 0
    USE \APLICA\TRASLADO\cpico_tb.str ALIAS CO_TX
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
SELE CO_T
COPY TO CO_TTMP
ZAP
USE
SELE CO_TX
COPY STRU TO CPICO_TB
IF !USED([CO_T])
    SELE 0
    USE CPICO_TB ALIAS CO_T EXCL
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
SELE CO_T
APPEND FROM CO_TTMP
CLOSE DATA
DELE FILE CO_TTMP.DBF
=F1QEH([OK])
****
**=F1QEH([Actualizando detalle de producci¢n...])
**IF !USED([CFTR])
**    SELE 0
**    USE ALMCFTRA ALIAS CFTR EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**IF !USED([CFTRX])
**    SELE 0
**    USE \APLICA\TRASLADO\CFTRLIMA ALIAS CFTRX
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE CFTR
**COPY TO CFTRTMP
**ZAP
**USE
**SELE CFTRX
**COPY STRU TO ALMCFTRA
**IF !USED([CFTR])
**    SELE 0
**    USE ALMCFTRA ALIAS CFTR EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE CFTR
**APPEND FROM CFTRTMP
**CLOSE DATA
**=F1QEH([OK])
RETURN
***************
FUNCTION NROAST
***************
PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = CDOC->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = CDOC->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = CDOC->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = CDOC->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = CDOC->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = CDOC->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = CDOC->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = CDOC->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = CDOC->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = CDOC->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = CDOC->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = CDOC->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = CDOC->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = CDOC->NDOC13
   OTHER
     iNroDoc = CDOC->NRODOC
ENDCASE

*IF CDOC->ORIGEN
   iNroDoc = VAL(XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ##########"),8))
*ENDIF
IF PARAMETER() = 1
   IF VAL(XsNroAst) > iNroDoc
     iNroDoc = VAL(XsNroAst) + 1
   ELSE
     iNroDoc = iNroDoc + 1
   ENDIF
   DO CASE
      CASE XsNroMES = "00"
        REPLACE   CDOC->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   CDOC->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   CDOC->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   CDOC->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   CDOC->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   CDOC->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   CDOC->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   CDOC->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   CDOC->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   CDOC->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   CDOC->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   CDOC->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   CDOC->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   CDOC->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   CDOC->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN CDOC
ENDIF
RETURN  RIGHT("0000000000" + LTRIM(STR(iNroDoc)), 10)
***************
FUNCTION _CHKNRO
***************
IF (&sEsRgv.)
   IF MONTH(CTRA.FchDoc)#VAL(XsNroMes)
      sErr = [Registro pertenece al mes de ]+PADR(MES(MONTH(CTRA.FchDoc)),10)
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
*******************
FUNCTION CieAHoyDia
*******************
PARAMETER m.Fecha
PRIVATE LsFecha
LsFecha=DTOC(GdFchCie)
IF m.Fecha<=GdFchCie
   =F1_ALERT([Existe cierre de transacciones al ]+LsFecha ,[MENSAJE])
   RELEASE LsFecha
   RETURN .T.
ELSE
   RELEASE LsFecha
   RETURN .F.
ENDIF
******************
FUNCTION CieDelMes
******************
PARAMETER m.Mes
PRIVATE LsFecha
LsMes=MES(m.Mes,2)
IF !GlModMes
   =F1_ALERT([Existe cierre contable del mes de ]+LsMes     ,[MENSAJE])
   RELEASE LsMes
   RETURN .T.
ELSE
   RELEASE LsMes
   RETURN .F.
ENDIF
*******************
FUNCTION ActxFchCmb
*******************
PARAMETER _Periodo,_CodPro,_FchCmb,_ALIAS
PRIVATE sAlias,x
IF !USED(_ALIAS)
    DO F1MsgErr WITH [ERROR:No se puede acceder a tabla de programaci¢n]
    RETURN .F.
ENDIF
xResp=1
IF TYPE("PROCMEN")=[L]
ELSE
   xResp=F1_ALERT([ PROCEDEMOS A LA ACTUALIZACION AUTOMATICA DE ;]+;
                  [ EL PROGRAMA DE PRODUCCION DE ESTE PRODUCTO.  ],[SI_O_NO])
ENDIF
IF xResp= 2
   RETURN .F.
ENDIF
sALIAS = ALIAS()
**=SEEK(m.CodPRo,[CFPRO])
IF EMPTY(_FchCmb)
   _FchCmb = CTOD("01/"+STR(_MES,2,0)+"/"+STR(_ANO,4,0))
ENDIF
x=GdFecha - _FchCmb
LnDiasTra= DAY(GdFecha)-x-1
LnDiasFal= x+1
LnTotDias= DAY(GdFecha)
LfBatObj = ROUND(IIF(CFPRO.CanObj>0,m.CanObj/CFPRO.CanObj,0),4)
DO CASE
   CASE sModulo = [FORMPROD]
		SELE (_ALias)
		SEEK _Periodo+_CodPro
		SCAN WHILE Periodo+CodPro=_Periodo+_CodPro
		     SELE DFPRO
		     SEEK _CodPro+_CodMat
		     LfCanAct=DPRG.CanPrg
		     STORE 0 TO LfCnFalta,LfCnUsado,LfNewCan,LfCanReq
		     SCAN WHILE _CodPro+_CodMat=DFPRO.CodPRo+DFPRO.CodMat
		          LfFacEqu = IIF(FacEqu<=0,1,FacEqu)
		          LfNewCan = LfNewCan + ROUND(DFPRO.CanReq*LfFacEqu*LfBatObj,4)
		          LfCanReq = LfCanReq + DFPRO.CanReq*LfFacEqu
		     ENDSCAN
		     LfCnFalta = LfNewCan/LnTotDias*LnDiasFal
		     LfCnUsado = LfCanAct/LnTotDias*LnDiasTra
		     SELE (_Alias)
		     DO WHILE !RLOCK()
		     ENDDO
		     REPLACE CanPrg WITH LfCnFalta+LfCnUsado
		     REPLACE CanReq WITH LfCanReq
		     UNLOCK
		ENDSCAN
		SELE CPRG
		DO WHILE !RLOCK()
		ENDDO
		REPLACE FchCmb WITH _FchCmb
		REPLACE BatObj WITH LfBatObj
		UNLOCK
   CASE sModulo = [PROGRAMA]
		SELE (_ALias)
		SEEK _Periodo+_CodPro
		SCAN WHILE Periodo+CodPro=_Periodo+_CodPro
		     LfCanAct=DPRG.CanPrg
		     STORE 0 TO LfCnFalta,LfCnUsado,LfNewCan
             LfNewCan = LfNewCan + ROUND(CanReq*LfBatObj,4)
		     LfCnFalta = LfNewCan/LnTotDias*LnDiasFal
		     LfCnUsado = LfCanAct/LnTotDias*LnDiasTra
		     SELE (_Alias)
		     DO WHILE !RLOCK()
		     ENDDO
		     REPLACE CanPrg WITH LfCnFalta+LfCnUsado
		     UNLOCK
		ENDSCAN
ENDCASE
SELE (sAlias)
RETURN .T.
********************
PROCEDURE ActProgMes
********************
set escape on
ON ESCAPE DO CpiCancel
nr=F1_ALERT([Este proceso actualiza el programa de producci¢n mensual;]+;
            [con el programa de produccion real utilizado en el mes. ;]+;
            [                                                        ;]+;
            [ATENCION:La programacion actual se cambiara por la del  ;]+;
            [mes anterior en caso de no existir informacion en el mes;]+;
            [actual.],[PROCESO])
IF nr=2
   return
ENDIF
m.Reproceso = .T.
SELE 0
USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPIDFPRO ORDER DFPR02 ALIAS DFPRO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPICPROG ORDER CPRG01 ALIAS CPRG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPIDPROG ORDER DPRG01 ALIAS DPRG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPITO_TB ORDER TO_T02 ALIAS TO_T
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
WAIT WINDOW [Procesando 0 % ]  NOWAIT
SELE CFPRO
GO TOP
LnTotReg =RECCOUNT()
LnNumReg = 0

SCAN
    LnNumReg = LnNumReg + 1
    LsPorcen = TRAN(LnNumReg/LnTotReg*100,[999])
    LsLLave=GsAnoMes+CFPRO.CodPro
    WAIT WINDOW [Procesando...]+LsPorcen+[%] NOWAIT
    SELE CPRG
    SEEK LsLLave
    IF !FOUND()
        APPEND BLANK
        DO WHILE !RLOCK()
        ENDDO
        REPLACE Periodo WITH GsAnoMes
        REPLACE CodPro  WITH CFPRO.CodPro
    ELSE
        DO WHILE !RLOCK()
        ENDDO
        REPLACE FchCmb  WITH GdFecha - DAY(GdFecha-1)
    ENDIF
    IF CanObj<=0
       REPLACE CanObj WITH 0
       SELE TO_T
       SEEK CFPRO.CodPro+GsAnoMes
       SCAN WHILE CodPrd+DTOS(FcHDoc)=CFPRO.CodPro+GsAnoMes FOR ClfDiv=GaClfDiv(3)
            REPLACE CPRG.CanObj WITH  CPRG.CanObj + CanObj
       ENDSCAN
       REPLACE CPRG.BatObj WITH ROUND(IIF(CFPRO.CanObj>0,CPRG.CanObj/CFPRO.CanObj,0),4)
       *** Si no se encontro nada en los totales del mes actual
    ENDIF
    IF CPRG.CanObj=0  && Osea no se encontro nada en los totales del mes actual
       IF _MES>1
	       GsAAMMANT=LEFT(GsAnoMes,4)+TRAN(_MES-1,"@L ##")
       ELSE
	       GsAAMMANT=TRAN(_ANO-1,"9999")+[12]
       ENDIF
	   SELE TO_T
       SEEK CFPRO.CodPro+GsAAMMANT
       SCAN WHILE CodPrd+DTOS(FcHDoc)=CFPRO.CodPro+GsAAMMANT FOR ClfDiv=GaClfDiv(3)
	      REPLACE CPRG.CanObj WITH  CPRG.CanObj + CanObj
	   ENDSCAN
	   REPLACE CPRG.BatObj WITH ROUND(IIF(CFPRO.CanObj>0,CPRG.CanObj/CFPRO.CanObj,0),4)
    ENDIF
    ** detalle de programa de producci_n

    SELE DFPRO
    SEEK CFPRO.CodPro
    DO WHILE CodPro=CFPRO.CodPro AND !EOF()
       LsCodMat=CodMat
       LfCanPrg=0
       LfCanReq=0
       LsUnDStk = []
	   SCAN WHILE CodPro+CodMat=CFPRO.CodPro+LsCodMat
	        LsUndStk = UndStk
            LfFacEqu = IIF(FacEqu<=0,1,FacEqu)
	        LfCanPrg = LfCanPrg+ROUND(DFPRO.CanReq*LfFacEqu*CPRG.BatObj,4)
	        LfCanReq = LfCanReq + DFPRO.CanReq*LfFacEqu
	   ENDSCAN
       SELE DPRG
       SEEK GsAnoMes+CFPRO.CodPro+LsCodMat
       IF !FOUND()
          APPEND BLANK
          DO WHILE !RLOCK()
          ENDDO
          REPLACE Periodo WITH GsAnoMes
          REPLACE CodPro  WITH CFPRO.COdpro
          REPLACE COdMat  WITH LsCodMat
       ELSE
          DO WHILE !RLOCK()
          ENDDO
          REPLACE CanPrg WITH 0
          REPLACE CanReq WITH 0
       ENDIF
       REPLACE CanPrg WITH LfCanPrg
       REPLACE CanReq WITH LfCanReq
       REPLACE UndStk WITH LsUndStk
       UNLOCK
	   SELE DFPRO
    ENDDO
    UNLOCK IN [CPRG]
    *
    SELE CFPRO
ENDSCAN
=F1QEH([OK])
CLOSE DATA
SET ESCAPE OFF
RETURN
*******************
PROCEDURE CPICANCEL
*******************
PRIVATE NR
NR=F1_ALERT([Desea interrumpir la tarea que estamos realizando ?],[REINTENTAR])
IF NR=2
   retry
ELSE
   CLOSE DATA
   SET ESCAPE OFF
   RETURN to master
ENDIF
******************
PROCEDURE CPIPCIVA
******************
PARAMETER PsPeriodo
IF USED([SEDES])


ENDIF
M.SEDE = SPACE(3)
M.NOMBRE = SPACE(20)
lVenta = .F.
lDctos = .F.
m.Control = 1
UltTecla = 0
DO cpipciva.spr
IF UltTecla=K_ESC
   m.Control = 2
ENDIF
IF m.Control = 2
   CLOSE DATA
   RETURN
ENDIF
IF lVenta
		ArcSec = []
		IF PARAMETERS()#1 OR EMPTY(PsPeriodo)
		   PsPeriodo = GsAnoMes
		   nresp=F1_Alert([Desea escoger archivo con información ;]+;
		                  [de ventas de productos.],[SI_O_NO])
		   IF nResp=1
			   m.Dir_Act=CURDIR()
			   SET DEFA TO (PATHTRAS)
			   ArcSec = GETFILE([SEC|TXT],[Archivo de interface],[OK])
			   SET DEFA TO (m.Dir_Act)
		   ENDIF
		ENDIF
		IF !USED([PVTA])
			SELE 0
			USE CPITPVTA ORDER PVTA01 ALIAS PVTA
			IF !USED()
			   CLOSE DATA
			   RETURN
			ENDIF
		ENDIF
		**
		IF !USED([EMPV])
			SELE 0
			USE CPIEMVPT  ALIAS EMVP ORDER EMVP02
			IF !USED()
			   CLOSE DATA
			   RETURN
			ENDIF
		ENDIF
		**
		IF !USED([VXPV])
			SELE 0
			USE CPIPVXPV ORDER VXPV01 ALIAS VXPV
			IF !USED()
			   CLOSE DATA
			   RETURN
			ENDIF
		ENDIF	
		**
		IF !EMPTY(ArcSec)
		   ArcNew = PATHUSER+SYS(3)
		   IF _Mes=1
		       m.PerAnt = STR(_ANO-1,4,0)+[12]
		       xMesAnt=12
		   ELSE
			   m.PerAnt = STR(_ANO,4,0)+TRAN(_MES-1,[@L ##])
			   xMesAnt=_MES-1
		   ENDIF
		   SELE EMVP
		   COPY STRU TO (ArcNew)
		   SEEK m.PerAnt
		   IF !FOUND()
			   IF xMesAnt=1
			       m.PerAnt = STR(_ANO-1,4,0)+[12]
			   ELSE
				   m.PerAnt = STR(_ANO,4,0)+TRAN(xMesAnt-1,[@L ##])
			   ENDIF
		   ENDIF
		   SELE 0
		   USE (ArcNew) EXCLU
		   APPEND FROM (ArcSec) TYPE DELIMITED
		   GO TOP
		   SET RELA TO m.PerAnt+CODPRO INTO EMVP
		   REPLACE ALL DesCrip WITH EMVP.DesCrip FOR m.PerAnt+CodPro==EMVP.Periodo+EMVP.CodPro
		   REPLACE ALL CodEqu  WITH EMVP.CodEqu  FOR m.PerAnt+CodPro==EMVP.Periodo+EMVP.CodPro
		   USE
		   SELE EMVP
		   SEEK PsPeriodo
		   DELE REST WHILE Periodo=PsPeriodo
		   APPEND FROM (ArcNew)
		ENDIF
		SELE VXPV
		SEEK PsPeriodo
		SCAN WHILE PERIODO=PsPeriodo
		    DO WHILE !rlocK()
		    enddo
		    replace VOLVTA  with 0
		    replace VALVTA1 WITH 0
		    REPLACE VALVTA2 WITH 0
		    unlock
		ENDSCAN
		SELE EMVP
		STORE 0 TO PV1,PV2,PV3,PV4,PV5,PV6,PV7,PV8
		SEEK PsPeriodo
		SCAN WHILE Periodo=PsPeriodo
		    wait window codpro+[ ]+descrip nowait
		    SELE PVTA
		    SCAN
		        LsCmpVol = CmpVol
		        LsCmpVal1 = CmpVal1
		        SELE VXPV
		        SEEK PsPeriodo+PVTA.PtoVta+EMVP.CodEqu
		        IF !FOUND()
		           APPEND BLANK
		           DO WHILE !RLOCK()
		           ENDDO
		           REPLACE Periodo WITH PsPeriodo
		           REPLACE PtoVta  WITH PVTA.PtoVta
		           REPLACE CodPro  WITH EMVP.CodEqu
		        ENDIF
		        REPLACE VolVTa  WITH EMVP.&LsCmpVol.
		        REPLACE ValVta1 WITH EMVP.&LsCmpVal1.
		        UNLOCK
		        SELE PVTA
		    ENDSCAN
		    SELE EMVP
		ENDSCAN
ENDIF	
***	
IF lDctos
	ArcSec = []
	IF PARAMETERS()#1 OR EMPTY(PsPeriodo)
	   PsPeriodo = GsAnoMes
	   nresp=F1_Alert([Desea escoger archivo con información ;]+;
	                  [de Descuentos en venta de Productos],[SI_O_NO])
	   IF nResp=1
		   m.Dir_Act=CURDIR()
		   SET DEFA TO (PATHTRAS)
		   ArcSec = GETFILE([SEC|TXT],[Archivo de interface],[OK])
		   SET DEFA TO (m.Dir_Act)
	   ENDIF
	ENDIF
	IF !USED([PVTA])
		SELE 0
		USE CPITPVTA ORDER PVTA01 ALIAS PVTA
		IF !USED()
		   CLOSE DATA
		   RETURN
		ENDIF
	ENDIF
	**
	IF !USED([EMPD])
		SELE 0
		USE CPIEMDPT ORDER EMDP02 ALIAS EMDP
		IF !USED()
		   CLOSE DATA
		   RETURN
		ENDIF
	ENDIF
	**
	IF !USED([DCTO])
		SELE 0
		USE CPITDCTO ORDER DCTO01 ALIAS DCTO
		IF !USED()
		   CLOSE DATA
		   RETURN
		ENDIF
	ENDIF	
	**
	IF !EMPTY(ArcSec)
	   ArcNew = PATHUSER+SYS(3)
	   IF _Mes=1
	       m.PerAnt = STR(_ANO-1,4,0)+[12]
	   ELSE
		   m.PerAnt = STR(_ANO,4,0)+TRAN(_MES-1,[@L ##])
	   ENDIF
	   SELE EMDP
	   COPY STRU TO (ArcNew)
	   SELE 0
	   USE (ArcNew) EXCLU
	   APPEND FROM (ArcSec) TYPE DELIMITED
	   GO TOP
	   REPLACE ALL CodEqu  WITH [0]+CodPro+[0]
	   USE
	   SELE EMDP
	   SEEK PsPeriodo
	   DELE REST WHILE Periodo=PsPeriodo
	   APPEND FROM (ArcNew)
	ENDIF
	SELE DCTO
	SEEK PsPeriodo
	SCAN WHILE PERIODO=PsPeriodo
	    DO WHILE !rlocK()
	    enddo
	    replace Dct_U_Fac WITH 0
	    REPLACE DCT_U_NC  WITH 0	
	    replace Dct_V_Fac WITH 0
	    REPLACE Dct_V_NC  WITH 0
	    unlock
	ENDSCAN
	SELE PVTA
	SET ORDER TO PVTA02
	ArcVta=PATHUSER+SYS(3)
	TOTAL ON Grupo TO (ArcVta)
	USE (ArcVta) ALIAS PVTA
	REPLACE ALL DesVta WITH DesGru FOR !EMPTY(DesGru)
	INDEX ON Grupo TAG PVTA02
	SET ORDER TO PVTA02
	SELE EMDP
	SEEK PsPeriodo
	SCAN WHILE Periodo=PsPeriodo
	    wait window codpro+[ ]+descrip nowait
	    SELE PVTA
	    SCAN
	        m.U_Cmp_Fac = [EMDP.]+C_Dct_U_Fa
	        m.U_Cmp_NC  = [EMDP.]+C_Dct_U_NC
	        LsPtoVTa=PtoVTa
	        IF !EMPTY(Desgru)
		        m.U_Cmp_Fac = [EMDP.]+G_Cmp1
		        m.U_Cmp_NC  = [EMDP.]+G_Cmp2
		        LsPtoVta=Grupo
	        ENDIF
	        SELE DCTO
	        SEEK PsPeriodo+LsPtoVta+EMDP.CodEqu
	        IF !FOUND()
	           APPEND BLANK
	           DO WHILE !RLOCK()
	           ENDDO
	           REPLACE Periodo WITH PsPeriodo
	           REPLACE PtoVta  WITH LsPtoVta
	           REPLACE CodPro  WITH EMDP.CodEqu
	        ENDIF
	        IF EMDP.Tipo=[VOLUM]
				REPLACE Dct_U_Fac WITH EVAL(m.U_Cmp_Fac)
				REPLACE Dct_U_NC  WITH EVAL(m.U_Cmp_NC)
	        ENDIF
	        IF EMDP.Tipo=[VALOR]
				REPLACE Dct_V_Fac WITH EVAL(m.U_Cmp_Fac)
				REPLACE Dct_V_NC  WITH EVAL(m.U_Cmp_NC)
			ENDIF	
	        UNLOCK
	        SELE PVTA
	    ENDSCAN
	    SELE EMDP
	ENDSCAN
ENDIF		
IF PARAMETERS()#1 OR EMPTY(PsPeriodo)
   CLOSE DATA
ENDIF
WAIT WINDOW [OK] NOWAIT
RETURN
*******************
PROCEDURE CpiGrbEq
*******************
parameter _cual
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
IF _CUAL#2
	SELE 0
	USE ALMESTCM ORDER ESTA01 ALIAS ESTA
	IF !USED()
	   CLOSE DATA
	   RETURN
	ENDIF
ENDIF
**
IF _CUAL#1
	SELE 0
	USE CPITO_TB ORDER TO_T01 ALIAS TO_T
	IF !USED()
	   CLOSE DATA
	   RETURN
	ENDIF
ENDIF
*
IF _cual#2     && _CUAL=1
	SELE ESTA
	SEEK GsAnoMes
	SCAN WHILE Periodo=GsAnoMes
	     DO WHILE !RLOCK()
	     ENDDO
	     lfound=SEEK(TRIM(CodPro),[CATG])
	     WAIT WINDOW Periodo+[ ]+CodPro+[ ]+TRIM(CATG.DesMat) NOWAIT
	     LsCodEqu = CATG.CodEqu
	     FOR ndiv=1 TO ALEN(GaLenCod)
	         IF ClfDiv =GaClfDiv(ndiv) AND lFound
	            REPLACE CodEqu WITH LEFT(LsCodEqu,GaLenCod(nDiv))
	            UNLOCK
	         ENDIF
	     ENDFOR
	     UNLOCK
	ENDSCAN
ENDIF
IF _Cual#1		&& _CUAL=2
	SELE TO_T
	SEEK GsAnoMes
	SCAN WHILE DTOS(FCHDOC)=GsAnoMes
	     DO WHILE !RLOCK()
	     ENDDO
	     lfound=SEEK(TRIM(CodPrd),[CATG])
	     WAIT WINDOW DTOC(FchDoc)+[ ]+CodPrd+[ ]+TRIM(CATG.DesMat) NOWAIT
	     LsCodEqu = CATG.CodEqu
	     FOR ndiv=1 TO ALEN(GaLenCod)
	         IF ClfDiv =GaClfDiv(ndiv) AND lFound
	            REPLACE CodEqu WITH LEFT(LsCodEqu,GaLenCod(nDiv))
	            UNLOCK
	         ENDIF
	     ENDFOR
	     UNLOCK
	ENDSCAN
ENDIF	
CLOSE DATA
RETURN
******************
PROCEDURE Cpiprprg
******************
set escape on
ON ESCAPE DO CpiCancel
nr=F1_ALERT([Este proceso actualiza el programa de producci¢n mensual;]+;
            [en base al promedio de producción real de los meses an- ;]+;
            [teriores,la producción programada y la producción real  ;]+;
            [del mes anterior tomando siempre el mayor de los tres.  ;]+;
            [                                                        ;],[PROCESO])
IF nr=2
   return
ENDIF
m.Reproceso = .T.
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPIDFPRO ORDER DFPR02 ALIAS DFPRO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPICPROG ORDER CPRG01 ALIAS CPRG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPIDPROG ORDER DPRG01 ALIAS DPRG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE CPITO_TB ORDER TO_T02 ALIAS TO_T
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SELE CFPRO
SET RELA TO CODPRO INTO CATG
*
*** variables de Control ***
UltTecla = 0
m.control= 1
m.CodProD=SPACE(LEN(CodPro))
m.CodProH=SPACE(LEN(CodPro))
MesActual=_MES
** variables para reactualizacion **
XnMesAnt=2   && Numero de meses anteriores a comparar
XfPrmAnt=0   && Porcentaje de variacion en base a los meses anteriores
XfPorAdi=0   && Porcentaje adicional
XfPorAct=0   && Porcentaje de actualización anula los anteriores
STORE .F. TO M.CRIT1,M.CRIT2
XnMesCal=XnMesAnt
DIMENSION aCanObj(3)
STORE 0 TO aCanObj
do cpiprprg.spr
IF m.Control=2 OR UltTecla=K_Esc
   CLOSE DATA
   RETURN
ENDIF
**
m.CodPRoD=TRIM(m.CodProD)
m.CodPRoH=TRIM(m.CodProH)+CHR(255)
WAIT WINDOW [Procesando 0 % ]  NOWAIT
SELE CFPRO
SEEK m.CodProD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
LnTotReg =RECCOUNT()
LnNumReg = 0
SCAN WHILE CodPro<=m.CodProH
    LnNumReg = LnNumReg + 1
    LsPorcen = TRAN(LnNumReg/LnTotReg*100,[999])
    XfPrmAnt=0
    m.CanObjAct=0
    m.CanObjAnt=0
    m.CanProAnt=0
    m.CanProUlt=0
    FOR QueMes= _MES TO 12
	    LsLLave=STR(_ANO,4,0)+TRAN(QUEMES,[@L ##])+CFPRO.CodPro
	    TsAnoMes=STR(_ANO,4,0)+TRAN(QUEMES,[@L ##])
	    WAIT WINDOW [Procesando ]+coDprO+[ ]+padr(catg.dESMAT,35)+[ ]+MES(QueMes,1) NOWAIT
	    SELE CPRG
	    SEEK LsLLave
	    IF !FOUND()
	        APPEND BLANK
	        DO WHILE !RLOCK()
	        ENDDO
	        REPLACE Periodo WITH TsAnoMes
	        REPLACE CodPro  WITH CFPRO.CodPro
	    ELSE
	        DO WHILE !RLOCK()
	        ENDDO
	        REPLACE FchCmb  WITH GdFecha - DAY(GdFecha-1)
	    ENDIF
	    IF CanObj<=0
	       REPLACE CanObj WITH 0
	       SELE TO_T
	       SEEK CFPRO.CodPro+TsAnoMes
	       SCAN WHILE CodPrd+DTOS(FcHDoc)=CFPRO.CodPro+TsAnoMes FOR ClfDiv=GaClfDiv(3)
	            REPLACE CPRG.CanObj WITH  CPRG.CanObj + CanObj
	       ENDSCAN
	       REPLACE CPRG.BatObj WITH ROUND(IIF(CFPRO.CanObj>0,CPRG.CanObj/CFPRO.CanObj,0),4)
	       *** Si no se encontro nada en los totales del mes actual
	    ENDIF
	    IF CPRG.CanObj=0  && Osea no se encontro nada en los totales del mes actual
	       IF _MES>1
		       GsAAMMANT=LEFT(TsAnoMes,4)+TRAN(_MES-1,"@L ##")
	       ELSE
		       GsAAMMANT=TRAN(_ANO-1,"9999")+[12]
	       ENDIF
		   SELE TO_T
	       SEEK CFPRO.CodPro+GsAAMMANT
	       SCAN WHILE CodPrd+DTOS(FcHDoc)=CFPRO.CodPro+GsAAMMANT ;
	            FOR ClfDiv=GaClfDiv(3)
		        REPLACE CPRG.CanObj WITH  CPRG.CanObj + CanObj
		   ENDSCAN
		   REPLACE CPRG.BatObj WITH ROUND(IIF(CFPRO.CanObj>0,CPRG.CanObj/CFPRO.CanObj,0),4)
	    ENDIF
	    SELE CPRG
	    m.Reg_Act = RECNO()
        m.CanObjAct=CPRG.CanObj
	    IF QueMes=_MES
            m.CanObjAct=CPRG.CanObj
		    XnMesAnt=XnMesCal
		    IF TYPE([CPRG.MesAnt])=[N]
			    IF CPRG.MesAnt#0
			       XnMesAnt=CPRG.MesAnt
			    ENDIF
		    ENDIF
		    ** Calculamos porcentaje de variación en base a XnMesAnt
		    m.lUltMes  = .F.
		    FOR NM = 1 TO XnMesAnt
		        m.AnoMesAnt=STR(IIF(_MES=1,_ANO-1,_ANO),4,0)+TRAN(_MES-NM,[@L ##])
		        =SEEK(m.AnoMesAnt+CFPRO.CodPro,[CPRG])
		        m.CanObjAnt = m.CanObjAnt + CPRG.CanObj
		        SELE TO_T
		        SEEK CFPRO.CodPro+m.AnoMesAnt
		        SCAN WHILE CodPrd+DTOS(FcHDoc)=CFPRO.CodPro+m.AnoMesANT;
		             FOR ClfDiv=GaClfDiv(3)
		             m.CanProAnt = m.CanProAnt + TO_T.CanFin
		        ENDSCAN
		        IF !m.lUltMes
		   	       m.CanProUlt= m.CanProAnt
		           m.lUltMes = .T.
		        ENDIF
		    ENDFOR
		    IF m.CanObjAnt#0
		       XfPrmAnt = ROUND(m.CanProAnt/m.CanObjAnt*100,2)-100
		    ENDIF
	    ENDIF
	    DIMENSION aCanObj(3)
	    STORE 0 TO aCanObj
	    DO CASE
	       CASE !m.Crit2
	            XfPorTot = XfPrmAnt
	            IF m.Crit1
	               XfPorTot = XfPorTot + XfPorAdi
	            ENDIF
		   	    aCanObj(1) = m.CanObjAct
			    aCanObj(2) = m.CanObjAct*(1+XfPorTot/100)
			    aCanObj(3) = m.CanProUlt
           CASE m.Crit2
           		aCanObj(1) = m.CanObjAct*(1+XfPorAct/100) 	
	    ENDCASE
	    =ASORT(aCanObj,1,3,1)
	    **
	    SELE CPRG
	    GO m.Reg_Act
	    IF aCanObj(1)>0
	       REPLACE CanObj WITH aCanObj(1)
		   REPLACE CPRG.BatObj WITH ROUND(IIF(CFPRO.CanObj>0,CPRG.CanObj/CFPRO.CanObj,0),4)
	    ENDIF
	    ** detalle de programa de producci_n
	    SELE DFPRO
	    SEEK CFPRO.CodPro
	    DO WHILE CodPro=CFPRO.CodPro AND !EOF()
	       LsCodMat=CodMat
	       LfCanPrg=0
	       LfCanReq=0
	       LsUnDStk = []
		   SCAN WHILE CodPro+CodMat=CFPRO.CodPro+LsCodMat
		        LsUndStk = UndStk
	            LfFacEqu = IIF(FacEqu<=0,1,FacEqu)
		        LfCanPrg = LfCanPrg+ROUND(DFPRO.CanReq*LfFacEqu*CPRG.BatObj,4)
		        LfCanReq = LfCanReq + DFPRO.CanReq*LfFacEqu
		   ENDSCAN
	       SELE DPRG
	       SEEK GsAnoMes+CFPRO.CodPro+LsCodMat
	       IF !FOUND()
	          APPEND BLANK
	          DO WHILE !RLOCK()
	          ENDDO
	          REPLACE Periodo WITH GsAnoMes
	          REPLACE CodPro  WITH CFPRO.COdpro
	          REPLACE COdMat  WITH LsCodMat
	       ELSE
	          DO WHILE !RLOCK()
	          ENDDO
	          REPLACE CanPrg WITH 0
	          REPLACE CanReq WITH 0
	       ENDIF
	       REPLACE CanPrg WITH LfCanPrg
	       REPLACE CanReq WITH LfCanReq
	       REPLACE UndStk WITH LsUndStk
	       UNLOCK
		   SELE DFPRO
	    ENDDO
	    UNLOCK IN [CPRG]
    ENDFOR
    *
    SELE CFPRO
ENDSCAN
=F1QEH([OK])
CLOSE DATA
SET ESCAPE OFF
RETURN
******************
PROCEDURE CPIP_TSM
******************
SELE 0
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 0
USE CPIDPROG ORDER DPRG02 ALIAS DPRG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 0
USE ALMCATAL ORDER CATA01 ALIAS CALM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
set rela to GaClfDiv(2)+LEFT(CodMat,GaLenCod(2)) INTO DIVF
SET FILTER TO DIVF.TipFam=1
**
M.Control=1
UltTecla = 0
m.CodMatD=SPACE(LEN(CATG.CodMat))
m.CodMatH=SPACE(LEN(CATG.CodMat))
DO CPIP_TSM.SPR
IF m.Control=2 or UltTecla=0
   CLOSE DATA
   RETURN
ENDIF
**
m.CodMatD=TRIM(m.CodMatD)
m.CodMatH=TRIM(m.CodMatH)+CHR(255)
XsSubAlm=[020]
SELE CATG
SEEK m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE COdmat<=m.CodMatH
     IF INLIST(CodMat,[53110],[53115])
        XsSubAlm=[090]
     ELSE
        XsSubAlm=[020]
     ENDIF
     LsCodMat=CodMat
     SELE CALM
     SEEK XsSubAlm+LsCodMat
     IF !FOUND()
        SELE CATG
        LOOP
     ENDIF
     DO WHILE !RLOCK()
     ENDDO
     StkMinAnt=0
     FOR K = _MES TO 12
         WAIT WINDOW CALM.SubAlm+[ ]+LSCodmat+[ ]+Catg.DesMat+[ ]+Mes(K,1) NOWAIT
         LsPeriod=STR(_ANO,4,0)+TRAN(K,[@L ##])
         LfCanPrg=0
         lPASO=.F.
         LsCmpStk=[STKM]+TRAN(K,[@L ##])
         IF K=_MES
            LsCmpAnt=[STKM]+TRAN(K-1,[@L ##])
		    StkMinAnt=&LsCmpAnt.
         ENDIF
         SELE DPRG
	     SEEK LsPeriod+LsCodMat
	     SCAN WHILE Periodo+CodMat=LsPeriod+LsCodMat
	          LfCanPrg = LfCanPrg + CanPrg
	          lPASO=.T.
	     ENDSCAN
	     SELE CALM
	     IF lPaso
 	  	     REPLACE &LsCmpStk. WITH LfCanPrg
 	  	 ELSE
 	  	     REPLACE &LsCmpStk. WITH StkMinAnt
	     ENDIF
     ENDFOR
     SELE CALM
     UNLOCK
     SELE CATG
ENDSCAN
CLOSE DATA
RETURN
********************
PROCEDURE ERR_ALM_OT
********************
M.GENERA=.F.
M.REPORTE=.T.
M.CONTROL=1
UltTecla =0
DO CPIALMER.SPR
IF UltTecla = K_ESC
   RETURN
ENDIF
**
SELE 0
USE ALMDTRAN ORDER DTRA10 ALIAS DTRA
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
ArcErr = [ALMERR]+tran(_MES,[@L ##])+[.DBF]
ArcStr = PATHUSER+SYS(3)
IF !FILE(ArcErr)
	COPY STRU extendeD TO (ArcStr)
	SELE 0
	USE (ArcStr) EXCLU
	APPEND BLANK
	REPLACE FIELD_NAME WITH [ERROR]
	REPLACE FIELD_TYPE WITH [C]
	REPLACE FIELD_LEN  WITH 30
	REPLACE FIELD_DEC  WITH 0

	CREATE (arcErr) FROM (arcstr)
    USE (ArcErr) EXCLU
	INDEX ON CodPrd+CodMat+SUBALM+TpoRef+NroRef+TipMov+CodMov+NroDoc TAG ERRO01
	INDEX On DTOS(FcHDOC)+NROREF+CODPRD+CODMAT   	               TAG ERRO02
	USE
ENDIF

SELE 0
USE (ArcErr) ORDER ERRO01 ALIAS ERR_ALM
IF !USED()
	CLOSE DATA
	RETURN
ENDIF

IF m.Genera
	SELE 0
	USE CPIDO_TB ORDER DO_T02 ALIAS DO_T
	IF !USED()
		CLOSE DATA
		RETURN
	ENDIF
	**
	SELE ERR_ALM
	USE (ArcErr) EXCLU
	ZAP
	USE (ArcErr) ORDER ERRO01 ALIAS ERR_ALM
	IF !USED()
		CLOSE DATA
		RETURN
	ENDIF
	**
	CANCELAR=.F.
	SELE DTRA
	SEEK GsAnoMes
	SCAN WHILE DTOS(FchDoc)=GsAnoMes AND !Cancelar FOR CodMat>=[43] AND CodMat#[99] AND TPoReF=[O_T] AND !INLIST(CODPRD,[999],[PROCE])
	    WAIT WINDOW DTRA.CodPrd+[ ]+DTRA.CodMat+[ ]+DTRA.SubAlm+[ ]+DTRA.TpoRef+[ ]+DTRA.NroRef+[ ]+DTOC(FchDoc) NOWAIT
	    SCATTER MEMVAR
		SELE DO_T
		SEEK LEFT(DTRA.NroRef,LEN(DO_T.NroDoc))+DTRA.CodPrd+DTRA.SubAlm+DTRA.CodMat
		IF !FOUND()
		    SELE ERR_ALM
		    SEEK DTRA.CodPrd+DTRA.CodMat+DTRA.SUBALM+DTRA.TpoRef+DTRA.NroRef
		    IF !FOUND()
			    APPEND BLANK
		    ENDIF
		    DO WHILE !RLOCK()
		    ENDDO
		    GATHER MEMVAR
		    replace error with [No se encuentra en produccion]
		    UNLOCK
		ELSE
		    FOR K = 1 TO 3
		        DO CASE
		        	CASE K=1
			        	LsCampo=DO_T.CodFor
			        	LsError=[Error de salida por formula]
			        	LfValor=DO_T.CanFor
		        	CASE K=2
			        	LsCampo=DO_T.CodAdi
			        	LsError=[Error de salida por adicional]
			        	LfValor=DO_T.CanAdi
		        	CASE K=3
			        	LsCampo=DO_T.CodDev
			        	LsError=[Error de ingreso por devolución]
			        	LfValor=DO_T.CanDev
		        ENDCASE
			    IF !EMPTY(LsCampo)
			        LsDo_t=DO_T.SubAlm+DO_T.CodMat+LsCampo+DO_T.NroDoc
					LsDtra=DTRA.SubAlm+DTRA.CodMat+DTRA.TipMov+DTRA.CodMov+DTRA.NroDoc+PADR(DTRA.NroRef,LEN(DO_T.NroDoc))
			        IF LsDo_t==LsDtra
			            Xfor2=[ABS(LfValor-DTRA.CanDes)>.01]
			            IF DTRA.CodMat=[43070]
			               Xfor2=[ABS(LfValor-DTRA.CanDes)>.0001]
			            ENDIF
						IF EVAL(xFor2)
						    WAIT WINDOW DTRA.CodPrd+[ ]+DTRA.CodMat+[ ]+DTRA.SubAlm+[ ]+DTRA.TpoRef+[ ]+DTRA.NroRef NOWAIT
						    SELE ERR_ALM
						    SEEK DTRA.CodPrd+DTRA.CodMat+DTRA.SUBALM+DTRA.TpoRef+DTRA.NroRef+LsCampo
						    IF !FOUND()
							    APPEND BLANK
						    ENDIF
						    DO WHILE !RLOCK()
						    ENDDO
						    GATHER MEMVAR
						    REPLACE ERROR WITH lsError
						    UNLOCK
						ENDIF					
			        ENDIF
				ENDIF
			ENDFOR
			
		ENDIF 	
		SELE DTRA
		CANCELAR = (CANCELAR OR INKEY()=K_ESC)
	ENDSCAN

ENDIF
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
SELE ERR_ALM
SET ORDER TO ERRO02
GO TOP
IF eof()
   IF m.Genera
	   wait WINDOW [NO HAY ERRORES REGISTRADOS !!!INCREIBLE!!!] TIMEOUT 5
   ELSE
	   wait WINDOW [NO SE HA GENERADO ARCHIVO DE ERRORES O NO LOS HAY] TIMEOUT 5
   ENDIF	
ELSE
	IF m.Reporte
	   SET RELA TO CODMAT INTO CATG
	   SNOMREP=[CPIALMER]
	   Largo     = 66
	   Iniprn    = [_Prn0+_Prn5a+CHR(Largo)+_Prn5b+_Prn3]
	   DO F0PRINT WITH [REPORTS]
	ENDIF	
ENDIF
CLOSE DATA
WAIT WINDOW [OK] NOWAIT
RETURN
**
*******************
PROCEDURE GRBSALMEN
*******************
PARAMETER _Subalm,_MesIni,_MesFin
PRIVATE LdFecha
xAlias =ALIAS()
xOrder =ORDER()
xRegAct=RECNO()
sCodMat = CALM.CodMat
fStkSub = CALM->StkIni
fStkAct = CALM->StkIni
fVCTOMN = CALM->VIniMn
fVCTOUS = CALM->VIniUs
IF _MesFin>=1
   FOR TnMes = _MesIni TO _MesFin
       IF TnMes < 12
         LdFecha   = CTOD("01/"+STR(TnMes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
       ELSE
         LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
       ENDIF
       WAIT [Procesando Codigo ]+sCodMat+[ ]+CATG.DESMAT WINDOW NOWAIT
       *** HALLAR EL STOCK DEL ALMACEN ***
       SELE DTRA
       GO TOP
       IF EOF()
          SELE CALM
          LOOP
       ENDIF
       SET ORDER TO DTRA02
       SEEK _SubAlm+sCodMat+DTOS(LdFecha+1)
       IF !FOUND()
          IF RECNO(0)>0
             GO RECNO(0)
             IF DELETED()
                SKIP
             ENDIF
          ENDIF
       ENDIF
       SKIP -1
       IF SubAlm+CodMat = _SubAlm+sCodMat AND FchDoc<=LdFecha
           fStkSub = DTRA->StkSub
       ENDIF
       *** HALLAR EL VALOR GENERAL ***
       SELE DTRA
       SET ORDER TO DTRA03
       SEEK sCodMat+DTOS(LdFecha+1)
       IF !FOUND()
          IF RECNO(0)>0
             GO RECNO(0)
             IF DELETED()
                SKIP
             ENDIF
          ENDIF
       ENDIF
       SKIP -1
       IF CodMat = sCodMat AND FchDoc<=LdFecha
          fStkAct = DTRA.StkAct
          fVCTOMN = VCTOMN
          fVCTOUS = VCTOUS
       ENDIF
       *** HALLAR EL VALOR DEL ALMACEN ***
       fValSub1 = IIF(fStkAct>0,fVCTOMN/fStkAct*fStkSub,0)
       fValSub2 = IIF(fStkAct>0,fVCTOUS/fStkAct*fStkSub,0)
       SELE CALM
       CamSTK = [STK]+TRAN(TnMes,"@L ##")
       CamVMN = [VMN]+TRAN(TnMes,"@L ##")
       CamVUS = [VUS]+TRAN(TnMes,"@L ##")
      ** REPLACE &CamSTK.  WITH fStkSub
      ** REPLACE &CamVMN.  WITH fValSub1
       REPLACE &CamVUS.  WITH fValSub2
   ENDFOR
ENDIF
SELE CALM
RETURN
*****************
FUNCTION F_Tpocmb    && Tomar el tipo de cambio de una fecha
*****************
PARAMETER _Fch
PRIVATE AREA_ACT
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

