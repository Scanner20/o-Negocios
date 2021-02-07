*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                                                                            ³
*³ bDef_Brw    Procemiento define la ventana para ingresar el detalle del do- ³
*³             cumento a travez del browse que toma las caracteristicas de la ³
*³             ventana de usuario.                                            ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
******************
FUNCTION bDEF_BRW
*****************
_llave    = GsSubAlm+m.cTipMov+m.sCodMov
m.bTitulo = [MUESTRA]
m.bDeta   = [DETALLE]
m.bClave1 = _Llave+m.sNroDoc
m.bClave2 = _Llave+m.sNroDoc
m.bFiltro = [.T.]
IF !m.lPidPco
   spdesm=[@S40]
   blPidPro=.F.
ELSE
   spdesm=[@S25]
   blPidPro=.F.
ENDIF
m.bCampos = bDef_Cmp(sModulo)
IF m.bDefBrow
   RELEASE WINDOW (m.btitulo)
ENDIF
IF !WEXIST(m.bTitulo)
   IF WEXIST(m.bDeta)
      RELEASE WINDOW (m.bDeta)
   ENDIF
   DEFINE WINDOW (m.bTitulo) FROM nX0,nY0 TO nX1,nY1 ;
          FLOAT GROW ZOOM NOCLOSE SHADOW NONE   COLOR SCHEME 10
   ACTIVATE WINDOW (m.bTitulo)
   SELE DTRA
   SET RELA TO CODMAT INTO CATG
   seek m.bclave1
   BROWSE FIELD &bCampos KEY m.bClave1 TITLE (m.btitulo) COLOR SCHEME 10 ;
                WINDOW (m.bTitulo) FOR EVALUATE(m.bFiltro) NOWAIT NOAPPEND NOMODIFY NODELETE

   RELEASE WINDOW (m.bTitulo)
   SELE CTRA
   m.bDefBrow = .F.
ELSE

   IF WEXIST(m.bDeta)
      RELEASE WINDOW (m.bDeta)
   ENDIF
   m.bDefBrow = .F.
ENDIF
PRIVATE xAlias
xAlias=ALIAS()
IF !USED([AUXI])
   SELE 0
   USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
ENDIF
IF !USED([CFTR])
   SELE 0
   USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
ENDIF
IF !USED([TCMB]) AND m.lPidPco
   SELE 0
   USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
ENDIF
IF !USED([ESTA]) AND m.lModCsm
   SELE 0
   USE ALMESTCM ORDER ESTA01 ALIAS ESTA
ENDIF
SELE (xAlias)
RELEASE xAlias
RETURN .T.
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ bDef_Cmp    Funci¢n que define los campos que se van a presentar en la ven- ³
*³             tana browse, asi como las funciones asociadas al VALID,WHEN,cam-³
*³             calculados,encabezados y formatos de edici¢n (PICTURE)          ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
  CASE INLIST(sModulo,[INGRESOS],[SALIDAS],[TRANSFER])

    IF !m.lPidPco

       spdesm=[@S40]
       blPidPro=.F.
       IF inlist(sModulo,[SALIDAS],[TRANSFER])
          IF m.cTipMov+m.sCodMov=[S040] OR m.cTipMov+m.sCodMov=[T011]
             spdesm=[@S34]
             blPidPro=.T.
          ELSE
             spdesm=[@S40]
             blPidPro=.F.
          ENDIF
       ENDIF
       IF !INLIST(m.Estoy,[EDITANDO])
          sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,CATG.DESMAT:H='DESCRIPCION':R:W=.F.]
          sCmp = sCmp +[:P=sPdesm,CanDes:H="CANTIDAD":P="###,###,###.###":V=vCandes():E=GsMsgErr,]
          if m.ctipmov+m.scodmov = [I040]
             sCmp = sCmp +[CanRec:H="CANT.REM.":P="###,###,###.###":V=vCanRec():E=GsMsgErr,]
          endif
          sCmp = sCmp +[UndVta:H=LEFT(sTUnd,3)]
          IF blPidPro
             sCmp = sCmp + [,CodPro:H='Prove.':V=vCodPro()]
          ENDIF
          IF !EMPTY(XsTpoRef)
             sCmp = sCmp + [,NroRef:H=XsTpoRef:V=vRefer()]
          ENDIF
 		  IF GsSubAlm=[080]                           && Ivan 23/08/99
		     sCmp = sCmp + [,FechVen:H='Fech.Venc.'] 
		  ENDIF     
       ELSE
          sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,DESMAT:H='DESCRIPCION':R:W=.F.]
          sCmp = sCmp +[:P=sPdesm,CanDes:H="CANTIDAD":P="###,###,###.###":V=vCandes():E=GsMsgErr,]
          if m.ctipmov+m.scodmov = [I040]
             sCmp = sCmp +[CanRec:H="CANT.REM.":P="###,###,###.###":V=vCanRec():E=GsMsgErr,]
          endif
          sCmp = sCmp +[UndVta:H=LEFT(sTUnd,3):V=vUndvta():F]
          IF blPidPro
             sCmp = sCmp + [,CodPro:H='Prove.':V=vCodPro():F]
          ENDIF
          IF !EMPTY(XsTpoRef)
              sCmp=sCmp + [,NroRef:H=XsTpoRef:V=vRefer()]
          ENDIF
		  IF GsSubAlm=[080]                           && Ivan 23/08/99  
		     sCmp = sCmp + [,FechVen:H='Fech.Venc.'] 
		  ENDIF            
       ENDIF
    ELSE
       blPidPro=.F.
       spdesm=[@S25]
       IF !INLIST(m.Estoy,[EDITANDO])
          sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,CATG.DESMAT:H='DESCRIPCION':R:W=.F.]
          sCmp = sCmp +[:P=sPdesm,CanDes:H="CANTIDAD":P="####,###.###":V=vCandes(),]
          sCmp = sCmp +[UndVta:H=LEFT(sTUnd,3),PreUni:H="PREC.UNIT.":P="####,###.###":V=vPreUni():E=GsMsgErr,]
          sCmp = sCmp +[ImpCto:H="IMPORTE":P="####,###.###":W=wImpCto():V=vImpCto():E=GsMsgErr:F]
          IF !EMPTY(XsTpoRef)
              sCmp=sCmp + [,NroRef:H=XsTpoRef:V=vRefer()]
          ENDIF
       ELSE
          sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,DESMAT:H='DESCRIPCION':R:W=.F.]
          sCmp = sCmp +[:P=sPdesm,CanDes:H="CANTIDAD":P="####,###.###":V=vCandes(),]
          sCmp = sCmp +[UndVta:H=LEFT(sTUnd,3):V=vUndvta():F,]
          sCmp = sCmp +[PreUni:H="PREC.UNIT.":P="####,###.###":V=vPreUni():E=GsMsgErr,]
          sCmp = sCmp +[ImpCto:H="IMPORTE":P="####,###.###":W=wImpCto():V=vImpCto():E=GsMsgErr:F]
          IF !EMPTY(XsTpoRef)
              sCmp=sCmp + [,NroRef:H=XsTpoRef:V=vRefer()]
          ENDIF
       ENDIF
    ENDIF
  CASE INLIST(sModulo,[APERTURA])
       sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S22':W=.F.,]
       sCmp = sCmp +[StkIni:H="STOCK INICIAL":P="####,###.####":V=vStkIni(),]
       sCmp = sCmp +[U=bUndStk():R:H="STK",ViniMn:H="VALOR S/.":P="####,###.###":V=vViniMn():E=sErr,]
       sCmp = sCmp +[VIniUs:H="VALOR US$":P="####,###.###":V=vVIniUs():E=sErr]
  CASE INLIST(sModulo,[MATE_AREA])
       sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S30':W=.F.,]
       sCmp = sCmp +[U=bUndStk():R:H="UND",]
       sCmp = sCmp +[CodSec:H="AREA":5]
  CASE INLIST(sModulo,[STKMINALM])
    sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S22':W=.F.,]
    sCmp = sCmp+[CATG.UndStk:H='UND':R:W=.F.,]
    sCmp = sCmp+[StkM01:H='Ene':P='9,999,999.999':V=vsmin(StkM01),]
    sCmp = sCmp+[StkM02:H='Feb':P='9,999,999.999':V=vsmin(StkM02),]
    sCmp = sCmp+[StkM03:H='Mar':P='9,999,999.999':V=vsmin(StkM03),]
    sCmp = sCmp+[StkM04:H='Abr':P='9,999,999.999':V=vSmin(StkM04),]
    sCmp = sCmp+[StkM05:H='May':P='9,999,999.999':V=vSmin(StkM05),]
    sCmp = sCmp+[StkM06:H='Jun':P='9,999,999.999':V=vSmin(StkM06),]
    sCmp = sCmp+[StkM07:H='Jul':P='9,999,999.999':V=vSmin(StkM07),]
    sCmp = sCmp+[StkM08:H='Ago':P='9,999,999.999':V=vSmin(StkM08),]
    sCmp = sCmp+[StkM09:H='Sep':P='9,999,999.999':V=vSmin(StkM09),]
    sCmp = sCmp+[StkM10:H='Oct':P='9,999,999.999':V=vSmin(StkM10),]
    sCmp = sCmp+[StkM11:H='Nov':P='9,999,999.999':V=vSmin(StkM11),]
    sCmp = sCmp+[StkM12:H='Dic':P='9,999,999.999':V=vSmin(StkM12) ]
  CASE INLIST(sModulo,[STKMIN])
       sCmp = []
       sCmp = sCmp+[StkM01:H='Ene':P='9,999,999.999':V=vsmin(StkM01),]
       sCmp = sCmp+[StkM02:H='Feb':P='9,999,999.999':V=vsmin(StkM02),]
       sCmp = sCmp+[StkM03:H='Mar':P='9,999,999.999':V=vsmin(StkM03),]
       sCmp = sCmp+[StkM04:H='Abr':P='9,999,999.999':V=vSmin(StkM04),]
       sCmp = sCmp+[StkM05:H='May':P='9,999,999.999':V=vSmin(StkM05),]
       sCmp = sCmp+[StkM06:H='Jun':P='9,999,999.999':V=vSmin(StkM06),]
       sCmp = sCmp+[StkM07:H='Jul':P='9,999,999.999':V=vSmin(StkM07),]
       sCmp = sCmp+[StkM08:H='Ago':P='9,999,999.999':V=vSmin(StkM08),]
       sCmp = sCmp+[StkM09:H='Sep':P='9,999,999.999':V=vSmin(StkM09),]
       sCmp = sCmp+[StkM10:H='Oct':P='9,999,999.999':V=vSmin(StkM10),]
       sCmp = sCmp+[StkM11:H='Nov':P='9,999,999.999':V=vSmin(StkM11),]
       sCmp = sCmp+[StkM12:H='Dic':P='9,999,999.999':V=vSmin(StkM12) ]

  CASE INLIST(sModulo,[PRECIOALM])
    sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S35':W=.F.,]
    sCmp = sCmp+[CATG.UndStk:H='UND':R:W=.F.,]
    sCmp = sCmp+[PUINMN:H='PRE.UNI. S/.':P='9999,999.999':V=PUINMN>=0,]
    sCmp = sCmp+[PUINUS:H='PRE.UNI. US$':P='9999,999.999':V=PUINUS>=0]
  CASE INLIST(sModulo,[INTFVGUIA])
    sCmp = [NroRf1:H='G/R Recep.':W=.F.,NroRf2:H='G/R Prove.':W=.F.,FchDoc:W=.F.,]
    sCmp = sCmp +[NroDoc:H='Correlativo':W=.F.,]
    sCmp = sCmp +[SelGui:H='T':V=vSelGui(),SelItm:H='P':V=vSelItm(),H=_valor():h='ESTADO':7]
  CASE INLIST(sModulo,[INTFVITEM])
    sCmp = [CodMat:H='Cod.Mat.':W=.F.,DesMat:H='Descripci¢n':30:W=.F.,]
    sCmp = sCmp +[CanDes:P='####,###.###':W=.F.,]
    sCmp = sCmp +[NroRef:H='Referencia':V=vNroRef(),]
    sCmp = sCmp +[SelItm:H='Selecci¢n':V=vSelItm()]
  CASE INLIST(sModulo,[INTFVDTRA])
    sCmp = [CodMat:H='Cod.Mat.':W=.F.,CATG.DesMat:H='Descripci¢n':30:W=.F.,]
    sCmp = sCmp +[CanDes:P='####,###.###':W=.F.,]
    sCmp = sCmp +[TpoRef:H='Tip.Doc.',]
    sCmp = sCmp +[NroRef:H='Referencia':V=vNroRef()]
  CASE INLIST(sModulo,[INTFVTEMP])
    sCmp = [CodMat:H='Cod.Mat.':W=.F.:8,DesMat:H='Descripci¢n':25:W=.F.,]
    sCmp = sCmp +[CanDes:P='####,###.###':W=.F.:H='Cantidad',]
    sCmp = sCmp +[PreUni:P='######.####':H='Pre.Uni.':V=vPreUni(),]
    sCmp = sCmp +[ImpCto:P='#######.##':H='Valor':V=vImpCto(),]
    sCmp = sCmp +[ImpPro:P='#######.##':H='Provision':R,]
    sCmp = sCmp +[NroRef:H='O/C':R,]
    sCmp = sCmp +[PreAst:P='######.####':H='Pre.O/C.':R,]
    sCmp = sCmp +[NroRfb:H='Referencia':V=vNroRef():10]
  CASE INLIST(sModulo,[ING_INVF])
    sCmp = [CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,]
    sCmp = sCmp + [CATG.DESMAT:H='DESCRIPCION':R:W=.F.:P='@S35',]
    sCmp = sCmp + [CATG.UndStk:R:H="UND":W=.F.,]
    sCmp = sCmp + [CanInv:P='9999,999.999':H=sCInv:V=vCanInv(),]
    sCmp = sCmp + [TALO.NroTar:H='N§Tarj.':W=.F.]
  CASE INLIST(sModulo,[RECLASIF])
	sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':P='@S35',]
	sCmp = sCmp + [UndStk:H='UND':R,]
    sCmp = sCmp + [CodNew:H="COD. NUEVO":P="XXXXXXXX"]

  OTHER
       WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
       RETURN TO MASTER
ENDCASE
RETURN sCmp


****************
FUNCTION vCdMate
****************
IF DELETED()
   RETURN .T.
ENDIF
SCATTER MEMVAR
PRIVATE iNroReg
iNroReg=RECNO()
lValido = F1_BUSCA(m.CodMat,"CODMAT","CALM","CALM",GsSubAlm,.f.,"")
lAsig=SEEK(GsSubAlm+m.CodMat,"CALM")
IF !lValido
   sErr = [Codigo de material inv lido]
ENDIF
IF !lAsig
   sErr = [Material no asignado a este almacen]
   lValido  = .F.
ENDIF
GO iNroReg
IF lValido
   DO CASE
      CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
           GATHER MEMVAR FIELDS CodMat
           =SEEK(m.CodMat,[CATG])
           m.DesMat = CATG.DesMat
           DO CASE
              CASE m.lUndStk
                 m.UndCmp = CATG->UndStk
                 m.Factor = 1
              CASE m.lUndVta
                 m.UndCmp = CALM->UndVta
                 m.Factor = CALM->FacEqu
              CASE m.lUndCmp
                 m.UndCmp = CATG->UndCmp
                 m.Factor = CATG->FacEqu
           ENDCASE
           IF m.Factor <= 0
              m.Factor = 1
           ENDIF
           m.UndVta = m.UndCmp
           GATHER MEMVAR FIELDS CodMat,UndVta,Factor,DesMat
      OTHER
           GATHER MEMVAR FIELDS CodMat
   ENDCASE
ENDIF
RETURN lValido
****************
FUNCTION vCanInv
****************
SCATTER MEMVAR
lValido = (m.CanInv>=0)
GATHER MEMVAR FIELDS CanInv
RETURN lValido
****************
FUNCTION vCdMatg
****************
IF DELETED()
   RETURN .T.
ENDIF
PRIVATE iNroReg
SCATTER MEMVAR
iNroReg = RECNO()
lValido = F1_BUSCA(m.CodMat,"CODMAT","CATG","CATG","",.f.,"")
lAsig=SEEK(GsSubAlm+m.CodMat,"CALM")
IF !lValido
   sErr = [Codigo de material inv lido]
ENDIF
IF !lAsig
   sErr = [Material no asignado a este almacen]
   lValido  = .F.
ENDIF
GO iNroReg
IF lValido
   DO CASE
      CASE INLIST(sModulo,[INGRESOS],[SALIDAS],[TRANSFER])
           =SEEK(m.CodMat,[CATG])
           m.DesMat = CATG.DesMat
           DO CASE
              CASE m.lUndStk
                 m.UndCmp = CATG->UndStk
                 m.Factor = 1
              CASE m.lUndVta
                 m.UndCmp = CALM->UndVta
                 m.Factor = CALM->FacEqu
              CASE m.lUndCmp
                 m.UndCmp = CATG->UndCmp
                 m.Factor = CATG->FacEqu
           ENDCASE
           IF m.Factor <= 0
              m.Factor = 1
           ENDIF
           m.UndVta = m.UndCmp
           IF EOF()
              GO iNroReg
           ENDIF
           IF m.CanDes=0
              GATHER MEMVAR FIELDS CodMat,UndVta,Factor,DesMat
           ELSE
              GATHER MEMVAR FIELDS CodMat,DesMat
           ENDIF
      OTHER
           =SEEK(m.CodMat,[CATG])
           GATHER MEMVAR FIELDS CodMat
   ENDCASE
ENDIF
RETURN lValido
****************
FUNCTION bDesmat
****************
PRIVATE sOrdAct,sDesMat
DO CASE
   CASE ALIAS()=[CALM]
        sDesMat = IIF(SEEK(CALM.CodMat,[CATG]),CATG.DesMat,[])
   CASE ALIAS()=[TEMP]
        sDesmat=DesMat
   CASE ALIAS()=[DTRA]
        sDesMat=CATG.DesMat
   OTHER
        IF EMPTY(CodMat)
           sDesMat = []
        ELSE
           sDesMat = IIF(SEEK(CodMat,[CATG]),CATG.DesMat,[])
        ENDIF
ENDCASE
RETURN sDesMat
****************
FUNCTION vCodPro
****************
SCATTER MEMVAR
lValido = F1_Busca(m.CodPro,[CODAUX],[AUXI],[AUXI],GsClfPro,.T.,[])
IF lValido
   GATHER MEMVAR FIELDS CodPro
ENDIF
RETURN lValido
****************
FUNCTION bUndStk
****************
RETURN IIF(SEEK(CodMat,"CATG"),CATG.UndStk,"")
****************
FUNCTION vUndVta    && UndVta VALID
****************
SCATTER MEMVAR
lValido=F1_Busca(m.UndVta,"UNDVTA","EQUN","EQUN",CATG.UndStk,.T.,"")
IF lValido OR m.UndVTa=CATG.UndStk
   m.Factor = EQUN.FacEqu
   m.UndCmp = m.UndVta
   DO CASE
      CASE  CATG->UndCmp == m.UndCmp
            m.Factor = CATG->FACEQU
      CASE  CATG->UndStk == m.UndCmp
            m.Factor = 1
   ENDCASE
   lValido = .T.
   m.UndVTa=m.UndCmp
   GATHER MEMVAR FIELDS UndVta,Factor
ENDIF
RETURN lValido
****************
FUNCTION vUndCmp
****************
SCATTER MEMVAR
PRIVATE iRegAct,sAlias
sAlias  = ALIAS()
iRegAct = RECNO()
DO CASE
  OTHER
    SELE EQUN
    SET ORDER TO EQUN01
    SET FILTER TO empty(CODMAT)
    GO TOP
    SELE (sAlias)
    lValido=F1_Busca(m.UndVta,"UNDVTA","EQUN","EQUN",m.UndStk,.F.,"")
ENDCASE
sErr = [Unidad de stock\compra\venta inv lida]
lValido = lValido OR m.UndPro==m.UndStk
IF lValido
   m.UndVta = EQUN.UndVta
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

**************
FUNCTION vSMin && Valid Stkm??
**************
parameter m.campo
sErr = "Cantidad debe ser mayor o igual a cero"
lValido = m.campo>=0
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
lValido = (m.ViniMn>=0)
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

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                                                                            ³
*³ bDeta_Brw   Procedimiento que llama a la ventana browse para editar los    ³
*³             datos del detalle                                              ³
*³                                                                            ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PROCEDURE bDeta_Brw
PARAMETERS sKEY,lmodifica,ladiciona,lborra

IF PARAMETERS() < 1
   sKEY = []
ENDIF

IF PARAMETERS() < 2
   sModifica = []
   lModiFica = .T.
ELSE
   sModifica = IIF(lmodifica,"","NOMODIFY")
ENDIF

IF PARAMETERS() < 3
   sAdiciona = []
   lAdiciona = .T.
ELSE
   sAdiciona = IIF(lAdiciona,"","NOAPPEND")
ENDIF
IF PARAMETERS() < 4
   sBorrar   = []
   lBorra    = .T.
ELSE
   sBorrar   = IIF(lBorra   ,"","NODELETE")
ENDIF

IF TYPE("m.bBorde")#"C"
   sBorde = [NONE]
ELSE
   sBorde = m.bBorde
ENDIF

IF TYPE("m.Area_Sel")#"C"
   m.Area_Sel = [TEMP]
ENDIF




PUSH KEY CLEAR


IF TYPE("m.PrgBusca")=[C]
   ON KEY LABEL F5 DO &PrgBusca.
ENDIF
ON KEY LABEL CTRL+PGUP GOTO TOP
ON KEY LABEL CTRL+PGDN GOTO BOTTOM

ON KEY LABEL CTRL+DEL  DO bBorra_Reg
ON KEY LABEL CTRL+INS  DO bAgrega_Reg

blBorrar = .F.
lGrb_Arch= .F.
IF WEXIST(m.btitulo)
   IF WVISIBLE(m.btitulo)
      DEACTIVATE WINDOW (m.btitulo)
      RELEASE WINDOW (m.bTitulo)
   ENDIF
ENDIF
DEFINE WINDOWS (m.bDeta) FROM nX0,nY0 TO nX1,nY1 FLOAT GROW ZOOM NOCLOSE;
               SHADOW &sBorde. COLOR SCHEME 10

STORE WOUTPUT() TO currwind
IF SYS(2016) = "" OR SYS(2016) = "*"
   ACTIVATE SCREEN
   @ 24,0 SAY 'Presione [CTRL]+[INS] para agregar item, [CTRL]+[DEL] borrar item.' COLOR (C_Linea)
ENDIF
IF NOT EMPTY(currwind)
 ACTIVATE WINDOW (currwind) SAME
ENDIF
SELE (Area_Sel)
DO SWAP_RELA
BROWSE FIELD &bCampos KEY sKEY TITLE (m.bDeta) COLOR SCHEME 10 ;
              FOR EVALUATE(m.bFiltro) WINDOW (m.bDeta) NOWAIT NOCLEAR
RELEASE WINDOW (m.bDeta)
BROWSE FIELD &bCampos KEY sKEY TITLE (m.bDeta) COLOR SCHEME 10 ;
              FOR EVALUATE(m.bFiltro) NOCLEAR WHEN wBrw() VALID vBrw() &sModifica. &sAdiciona. &sBorrar.
IF INLIST(LASTKEY(),K_CTRLW,K_ESC,K_F10)
   m.bDefBrow = .T.
ENDIF

POP KEY
RETURN
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
SKIP +1
blBorrar = .T.
DEACTIVATE WINDOW (m.bDeta)
SHOW WINDOW (m.bDeta) REFRESH TOP
*********************
PROCEDURE bAgrega_Reg
*********************
IF !lAdiciona
   =F1QEH("No es posible a¤adir registro")
   RETURN
ENDIF
PRIVATE EOF1
eof1 = EOF()
APPEND BLANK
DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS],[TRANSFER])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE CodAlm WITH GsCodAlm
        REPLACE SubAlm WITH GsSubAlm
        REPLACE TipMov WITH m.cTipMov
        REPLACE CodMov WITH m.sCodMov
        REPLACE NroDoc WITH m.sNroDoc
        UNLOCK
   CASE sModulo = [APERTURA]

   CASE sModulo = [ING_INVF]
        DO WHILE !RLOCK()
        ENDDO
        REPLACE SubAlm WITH m.SubAlm
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
ENDIF
RETURN

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                                                                            ³
*³ vBrw      VALID      del browse a nivel de registro                        ³
*³                                                                            ³
*³                                                                            ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FUNCTION vBrw

DO CASE
   CASE INLIST(sModulo,[INGRESOS],[SALIDAS])
       IF TYPE("NroItm")="N"
          IF NroItm<>RECNO()
             REPLACE NroItm WITH RECNO()
          ENDIF
       ENDIF
   CASE INLIST(sModulo,[APERTURA],[STKMINALM],[STKMIN])
      IF lGrb_Arch
         DO Brw_Grab
         lGrb_Arch = .F.
      ENDIF
      *@ 22,14 SAY CATG.DESMAT PICT "@S40"
ENDCASE

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                                                                            ³
*³ wBrw      WHEN       del browse a nivel de registro                        ³
*³                                                                            ³
*³                                                                            ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FUNCTION wBrw

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

       STORE WOUTPUT() TO currwind
       IF SYS(2016) = "" OR SYS(2016) = "*"
          ACTIVATE SCREEN
          =SEEK(CODMAT,"CATG")
          @ 22,14 SAY CATG.DESMAT PICT "@S40"
       ENDIF

       IF NOT EMPTY(currwind)
          ACTIVATE WINDOW (currwind) SAME
       ENDIF

       lGrb_Arch = .F.
   CASE INLIST(sModulo,[STKMINALM])
       STORE WOUTPUT() TO currwind
       IF SYS(2016) = "" OR SYS(2016) = "*"
          ACTIVATE SCREEN
          =SEEK(CODMAT,"CATG")
          @ 22,14 SAY CATG.DESMAT PICT "@S40"

       ENDIF
       IF NOT EMPTY(currwind)
          ACTIVATE WINDOW (currwind) SAME
       ENDIF
ENDCASE
RETURN .T.
*******************
PROCEDURE pRefresco
*******************
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF SYS(2016) = "" OR SYS(2016) = "*"
   ACTIVATE SCREEN
   IF INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.dFchDoc DISABLE
   ELSE
      SHOW GET m.dFchDoc ENABLE
   ENDIF
   IF m.lPidPco AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.fTpoCmb ENABLE
   ELSE
      IF !lPidPco
      ELSE
         SHOW GET m.fTpoCmb DISABLE
      ENDIF
   ENDIF

   IF m.lPidRf1 AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.sNroRf1 ENABLE
   ELSE
      IF !m.lPidRf1
         m.sNroRf1 = []
         @ 5,1 CLEAR TO 5,26
      ELSE
         SHOW GET m.sNroRf1 DISABLE
      ENDIF
   ENDIF

   IF m.lPidRf2 AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.sNroRf2 ENABLE
   ELSE
      IF !m.lPidRf2
         m.sNroRf2 = []
         @ 6,1 CLEAR TO 6,26
      ELSE
         SHOW GET m.sNroRf2 DISABLE
      ENDIF
   ENDIF
   IF m.lPidRf3 AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.sNroRf3 ENABLE
   ELSE
      IF !m.lPidRf3
         m.sNroRf3 = []
         @ 7,1 CLEAR TO 7,26
      ELSE
         SHOW GET m.sNroRf3 DISABLE
      ENDIF
   ENDIF
   DO CASE
      CASE sModulo#[TRANSFER]
         IF !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
            IF m.lPidOdt
               SHOW GET m.sNroOdt ENABLE
              *SHOW GET m.FBatch  ENABLE
            ELSE
               m.sNroOdt = []
               @ 7,28 CLEAR TO 7,78  
            ENDIF  
            IF m.lModCsm or m.lAfeTra
               SHOW GET m.sCodPrd ENABLE
               SHOW GET m.FBatch  ENABLE               
            ELSE
               m.sCodPrd = []
               @ 6,28 CLEAR TO 6,78  
            ENDIF
         ELSE
         	
            IF !m.lPidOdt AND !m.lMOdCsm and !m.lAfeTra
               m.sNroOdt = []
               m.sCodPrd = []
               m.Fbath   = 0
               @ 7,28 CLEAR TO 7,78  
            ELSE
               IF m.lPidOdt
                  SHOW GET m.sNroOdt DISABLE
                 *SHOW GET m.Fbatch  DISABLE
			   ELSE
	               m.sNroOdt = []
	               @ 7,28 CLEAR TO 7,78  
               ENDIF
               IF m.lModCsm or m.lAfeTra
                  SHOW GET m.sCodPrd DISABLE
                  SHOW GET m.Fbatch  DISABLE                  
               ELSE
	               m.sCodPrd = []
	               @ 6,28 CLEAR TO 6,78  
               ENDIF
            ENDIF
         ENDIF
      OTHER
   ENDCASE
   DO CASE
      CASE sModulo#[TRANSFER]
           IF m.lPidVen AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              SHOW GET m.sCodVen ENABLE
           ELSE
              IF !m.lPidVen
                 m.sCodVen = []
                *@ 6,28 CLEAR TO 6,78
              ELSE
                 SHOW GET m.sCodVen DISABLE
              ENDIF
           ENDIF
       OTHER
   ENDCASE

   IF !m.lPidCli
      IF TYPE("XsTpoRef")#[C]
         m.sCodCli = []
      ELSE
         IF XsTpoRef#[G/R]
            m.sCodCli = []
         ENDIF
      ENDIF
   ENDIF

   IF !m.lPidPro
      m.sCodPro = []
   ENDIF




   DO CASE
      CASE sModulo#[TRANSFER]
           IF !m.lPidPro AND !lPidCli
              m.sCodAux = []
              @5,28 CLEAR TO 5,78
			  IF GsSubAlm = [080]  && Ivan 13/09/99
			  	m.sCodAux1 = []
			  	@5,28 CLEAR TO 5,78
			  ENDIF         
           ELSE
              IF !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              	 SHOW GET m.sCodAux ENABLE
              	 IF GsSubAlm = [080]  && Ivan 13/09/99
			  	 	SHOW GET m.sCodAux1 ENABLE
			  	 ENDIF         	
              ELSE
                 SHOW GET m.sCodAux DISABLE
                 IF GsSubAlm = [080]  && Ivan 13/09/99
			  	 	SHOW GET m.sCodAux1 DISABLE
			  	 ENDIF         	 
              ENDIF
           ENDIF
      OTHER
   ENDCASE

   IF m.lPidPco AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
      SHOW GET m.fImpBrt ENABLE
      SHOW GET m.fPorIgv ENABLE
      SHOW GET m.fImpIgv ENABLE
      SHOW GET m.fImpTot ENABLE
   ELSE
      IF !m.lPidPco
        *@ 19,1 CLEAR TO 20,65
      ELSE
         SHOW GET m.fImpBrt DISABLE
         SHOW GET m.fPorIgv DISABLE
         SHOW GET m.fImpIgv DISABLE
         SHOW GET m.fImpTot DISABLE
      ENDIF
   ENDIF

   DO CASE
      CASE sModulo#[TRANSFER]
           IF (m.lModCsm or m.lAfeTra) AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              SHOW GET m.sCodPrd ENABLE
              IF m.lPidOdt
                 SHOW GET m.Fbatch  ENABLE
                 SHOW GET m.sNroOdt ENABLE
              ENDIF
           ELSE
              IF !m.lModCsm AND !m.lPidOdt and !m.lAfeTra
                 @ 6,28 CLEAR TO 7,78  
              ELSE
                 IF m.lModCsm or m.lAfeTra
                    SHOW GET m.sCodPrd DISABLE
                    SHOW GET m.FBatch  DISABLE                    
                 ENDIF
                 IF m.lPidOdt
                    SHOW GET m.sNroOdt DISABLE
                   *SHOW GET m.FBatch  DISABLE
                 ENDIF
              ENDIF
           ENDIF
       OTHER
   ENDCASE

   DO CASE
      CASE sModulo#[TRANSFER]
        DO CASE
           CASE m.lPidPco AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              IF m.lMonElg
                 SHOW GET m.nCodMon ENABLE
              ELSE
                 SHOW GET m.nCodMon DISABLE
              ENDIF
           CASE m.lPidPco AND INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
                SHOW GET m.nCodMon DISABLE
           CASE !m.lPidPco AND !m.lModCsm and !m.lAfeTra
                @ 7,28 CLEAR TO 7,78 
           CASE !m.lPidPco AND m.lModCsm
        ENDCASE
      OTHER
   ENDCASE
   SHOW GET m.salir ENABLE
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
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
******************
PROCEDURE ALMPASTR
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
IF !FILE("SEDES.DBF")
   CLOSE DATA
   DO F1MSGERR WITH [No existe la tabla SEDES.DBF]
   RETURN
ENDIF
SELE 0
USE SEDES ALIAS SEDE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SET FILTER TO Activa=[X]
GO TOP
private xact
COUNT TO Xact FOR Activa=[X]
IF Xact>1
   CLOSE DATA
   =F1_ALERT([Existe m s de una sede activa marque con una X solo a  ;]+;
             [la sede en que se esta ejecutando el sistema.          ;]+;
             [Puede hacerlo en el menu principal de aplica en el menu;]+;
             [de configuraciones.                                    ;],3)
   RETURN
ENDIF

IF Xact<=0
   CLOSE DATA
   =F1_ALERT([No esta marcada la sede activa.                        ;]+;
             [Marque con una X a la sede en que se esta ejecuatndo el;]+;
             [sistema. Salga hasta el menu pricipal de aplica y entre;]+;
             [a la opci¢n de configuraci¢n.                          ;],3)
   RETURN
ENDIF

GO TOP

M.SEDE = SEDE.CODIGO

IF INLIST(m.Sede,[XXX],[XXX])
   m.Dir_Orig = CURDIR()
   TsPathCia = "cia"+GsCodCia
   TsPathdef  = PathDef+"\"+TsPathCia
   SET DEFA TO (TsPathDef)
   CLOSE DATA
   =F1QEH([Actualizando materiales por almacen...])
   IF !USED([CALM])
       SELE 0
       USE ALMCATAL ALIAS CALM EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   IF !USED([CALMX])
       SELE 0
       USE \APLICA\TRASLADO\ALMCATAL.STR ALIAS CALMX
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE CALM
   COPY TO CALMTMP
   ZAP
   USE
   SELE CALMX
   COPY STRU TO ALMCATAL
   IF !USED([CALM])
       SELE 0
       USE ALMCATAL ALIAS CALM EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE CALM
   APPEND FROM CALMTMP
   CLOSE DATA
   =F1QEH([OK])
   SET DEFA TO (m.Dir_Orig)
ENDIF
**
IF INLIST(m.Sede,[001],[XXX])
   m.Dir_Orig = CURDIR()
   TsPathCia = "cia"+GsCodCia
   TsPathdef  = PathDef+"\"+TsPathCia
   SET DEFA TO (TsPathDef)
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
       USE \APLICA\TRASLADO\ALMCATGE.STR ALIAS CATGX
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
   =F1QEH([OK])
   SET DEFA TO (m.Dir_Orig)
ENDIF
IF INLIST(m.Sede,[XXX])
   m.Dir_Orig = CURDIR()
   TsPathCia = "cia"+GsCodCia
   TsPathdef  = PathDef+"\"+TsPathCia
   SET DEFA TO (TsPathDef)
   =F1QEH([Actualizando tabla de almacenes...])
   IF !USED([ALMA])
       SELE 0
       USE ALMTALMA ALIAS ALMA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   IF !USED([ALMAX])
       SELE 0
       USE \APLICA\TRASLADO\ALMTALMA.STR ALIAS ALMAX
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE ALMA
   COPY TO ALMATMP
   ZAP
   USE
   SELE ALMAX
   COPY STRU TO ALMTALMA
   IF !USED([ALMA])
       SELE 0
       USE ALMTALMA ALIAS ALMA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE ALMA
   APPEND FROM ALMATMP
   CLOSE DATA
   =F1QEH([OK])
   SET DEFA TO (m.Dir_Orig)
ENDIF

IF INLIST(m.Sede,[XXX],[XXX])
    m.Dir_Orig = CURDIR()
   TsPathCia = "cia"+GsCodCia
   TsPathdef  = PathDef+"\"+TsPathCia
   SET DEFA TO (TsPathDef)
    =F1QEH([Actualizando tabla de DIVISIONES...])
    IF !USED([DIVF])
        SELE 0
        USE ALMTDIVF ALIAS DIVF EXCL
        IF !USED()
           CLOSE DATA
           RETURN
        ENDIF
    ENDIF
    IF !USED([DIVFX])
        SELE 0
        USE \APLICA\TRASLADO\ALMTDIVF.STR ALIAS DIVFX
        IF !USED()
           CLOSE DATA
           RETURN
        ENDIF
    ENDIF
    SELE DIVF
    COPY TO DIVFTMP
    ZAP
    USE
    SELE DIVFX
    COPY STRU TO ALMTDIVF
    IF !USED([ALMA])
        SELE 0
        USE ALMTDIVF ALIAS DIVF EXCL
        IF !USED()
           CLOSE DATA
           RETURN
        ENDIF
    ENDIF
    SELE DIVF
    APPEND FROM DIVFTMP
    CLOSE DATA
    =F1QEH([OK])
    SET DEFA TO (m.Dir_Orig)
ENDIF
****
****
IF INLIST(m.Sede,[XXX])
     m.Dir_Orig = CURDIR()
     TsPathCia = "cia"+GsCodCia
     TsPathdef  = PathDef+"\"+TsPathCia
     SET DEFA TO (TsPathDef)
     =F1QEH([Actualizando configuraci¢n de transacciones...])
     IF !USED([CFTR])
         SELE 0
         USE ALMCFTRA ALIAS CFTR EXCL
         IF !USED()
            CLOSE DATA
            RETURN
         ENDIF
     ENDIF
     IF !USED([CFTRX])
         SELE 0
         USE \APLICA\TRASLADO\ALMCFTRA.STR ALIAS CFTRX
         IF !USED()
            CLOSE DATA
            RETURN
         ENDIF
     ENDIF
     SELE CFTR
     COPY TO CFTRTMP
     ZAP
     USE
     SELE CFTRX
     COPY STRU TO ALMCFTRA
     IF !USED([CFTR])
         SELE 0
         USE ALMCFTRA ALIAS CFTR EXCL
         IF !USED()
            CLOSE DATA
            RETURN
         ENDIF
     ENDIF
     SELE CFTR
     APPEND FROM CFTRTMP
     CLOSE DATA
     SET DEFA TO (m.Dir_Orig)
ENDIF
IF INLIST(m.Sede,[XXX])
   =F1QEH([Actualizando cabecera de transacciones...])
   IF !USED([CTRA])
       SELE 0
       USE ALMCTRAN ALIAS CTRA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   IF !USED([CTRAX])
       SELE 0
       USE \APLICA\TRASLADO\ALMCTRAN.STR ALIAS CTRAX
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE CTRA
   COPY TO CTRATMP
   ZAP
   USE
   SELE CTRAX
   COPY STRU TO ALMCTRAN WITH CDX
   IF !USED([CTRA])
       SELE 0
       USE ALMCTRAN ALIAS CTRA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE CTRA
   APPEND FROM CTRATMP
   CLOSE DATA
   =F1QEH([OK])
ENDIF
***
IF INLIST(m.Sede,[XXX],[XXX])
   =F1QEH([Actualizando detalle de transacciones...])
   IF !USED([DTRA])
       SELE 0
       USE ALMDTRAN ALIAS DTRA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   IF !USED([DTRAX])
       SELE 0
       USE \APLICA\TRASLADO\ALMDTRAN.STR ALIAS DTRAX
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE DTRA
   COPY TO DTRATMP
   ZAP
   USE
   SELE DTRAX
   COPY STRU TO ALMDTRAN WITH CDX
   IF !USED([DTRA])
       SELE 0
       USE ALMDTRAN ALIAS DTRA EXCL
       IF !USED()
          CLOSE DATA
          RETURN
       ENDIF
   ENDIF
   SELE DTRA
   APPEND FROM DTRATMP
   IF M.SEDE=[002]
      SELE 0
      USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
      IF !USED()
         DO F1MSGERR WITH [Actualizaci¢n de referencias queda pendiente..]
         CLOSE DATA
         RETURN
      ENDIF
      SELE DTRA
      SET RELA TO TIPMOV+CODMOV INTO CFTR
      REPLACE ALL TPOREF WITH ALMORI FOR CFTR.MODCSM
      REPLACE ALL NROREF WITH NROODT FOR CFTR.MODCSM
   ENDIF
   CLOSE DATA
   =F1QEH([OK])
ENDIF
***
*****
**=F1QEH([Actualizando archivo de correlativos...])
**IF !USED([CDOC])
**    SELE 0
**    USE ALMCDOCM ALIAS CDOC EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**IF !USED([CDOCX])
**    SELE 0
**    USE \APLICA\TRASLADO\ALMCDOCM.STR ALIAS CDOCX
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE CDOC
**COPY TO CDOCTMP
**ZAP
**USE
**SELE CDOCX
**COPY STRU TO ALMCDOCM WITH CDX
**IF !USED([CDOC])
**    SELE 0
**    USE ALMCDOCM ALIAS CDOC EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE CDOC
**APPEND FROM CDOCTMP
*!*	REPLACE ALL  NDOC00 WITH 1
*!*	REPLACE ALL  NDOC01 WITH 1
*!*	REPLACE ALL  NDOC02 WITH 1
*!*	REPLACE ALL  NDOC03 WITH 1
*!*	REPLACE ALL  NDOC04 WITH 1
*!*	REPLACE ALL  NDOC05 WITH 1
*!*	REPLACE ALL  NDOC06 WITH 1
*!*	REPLACE ALL  NDOC07 WITH 1
*!*	REPLACE ALL  NDOC08 WITH 1
*!*	REPLACE ALL  NDOC09 WITH 1
*!*	REPLACE ALL  NDOC10 WITH 1
*!*	REPLACE ALL  NDOC11 WITH 1
*!*	REPLACE ALL  NDOC12 WITH 1
*!*	REPLACE ALL  NDOC13 WITH 1
**CLOSE DATA
**
**=F1QEH([Actualizando detalle de estadisticas...])
**
**m.Dir_Orig = CURDIR()
**TsPathCia = "cia"+GsCodCia
**TsPathdef  = PathDef+"\"+TsPathCia
**SET DEFA TO (TsPathDef)
**IF !USED([ESTA])
**    SELE 0
**    USE ALMESTCM ALIAS ESTA EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**IF !USED([ESTAX])
**    SELE 0
**    USE \APLICA\TRASLADO\ALMESTCM.STR ALIAS ESTAX
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE ESTA
**COPY TO ESTATMP
**ZAP
**USE
**SELE ESTAX
**COPY STRU TO ALMESTCM WITH CDX
**IF !USED([ESTA])
**    SELE 0
**    USE ALMESTCM ALIAS ESTA EXCL
**    IF !USED()
**       CLOSE DATA
**       RETURN
**    ENDIF
**ENDIF
**SELE ESTA
**APPEND FROM ESTATMP
**CLOSE DATA
**=F1QEH([OK])
**SET DEFA TO (m.Dir_Orig)
RETURN
******************
PROCEDURE VERIFDBF
******************
m.Dir_Orig = CURDIR()

TsPathCia = "CIA"+GsCodCia
m.ruta = PATHDEF1+"\"+TsPathCia+"\C"+LTRIM(STR(_ANO))
R_Ano  = "C"+LTRIM(STR(_ANO))
!CD &Ruta. > NULL
m.Dir_act = CURDIR()
IF m.Dir_Act#m.Ruta
   Redir = Pathdef+"\"+TsPathCia
   !CD &Redir. > NULL
   !MD &R_Ano. > NULL
   !Cd &Ruta.  > NULL
   m.Dir_act = CURDIR()
   IF m.Dir_Act#m.Ruta
      DO F1MSGERR WITH [Imposible crear directorio nuevo ]+m.Ruta
      RETURN
   ENDIF
   @ 24,0 COLOR (c_linea)
   save scree
   !COPY ..\alm?tran.* .
   rest scree
   @ 24,0 COLOR (c_linea)
   !COPY ..\almcdocm.* .
   rest scree
   @ 24,0 COLOR (c_linea)
   !COPY ..\almcdocm.* .
   rest scree
   @ 24,0 COLOR (c_linea)
   !COPY ..\cpicdocm.* .
   rest scree
   @ 24,0 COLOR (c_linea)
   !COPY ..\cpi?o_tb.* .
   rest scree
   @ 24,0 COLOR (c_linea)
   !CD ..
   !DEL alm?tran.*
   !DEL almcdocm.*
   !DEL almcdocm.*
   !DEL cpicdocm.*
   !DEL cpi?o_tb.*
ENDIF
SET DEFA TO (m.Dir_Orig)

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
******************
PROCEDURE AlmDepCd
******************
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG EXCL
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
SELE 0
USE ALMCATAL ORDER CATA01 ALIAS CALM EXCL
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
SELE 0
USE ALMdtran ORDER dtra03 ALIAS dtra
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
SELE 0
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
Cancelar = .F.
SELE CATG
SCAN
     =SEEK(GsClfDiv+LEFT(CodMat,GsLenDiv),[DIVF])
     IF DIVF.TipFam#1
        LOOP
     ENDIF
     borraCatg = .F.
     LsCodMat = CodMat
     wait window codmat+[ ]+desmat nowait
     SELE DTRA
     SET ORDER TO DTRA03
     SEEK LsCodMat
     IF !FOUND()
        BorraCatg = .T.
        SELE CALM
        SET ORDER TO CATA02
        SEEK LsCodMat
        WAIT WINDOW [Depurando ]+LsCodMat+[ ]+LEFT(CATG.Desmat,30)+[ almacen:todos] NOWAIT
        SCAN WHILE CodMat = LsCodMat
             IF StkIni=0
                DELETE
             ELSE
                BorraCatg=.F.
             ENDIF
        ENDSCAN
        SELE CATG
      **WAIT WINDOW [Borrando del catalogo general ]+CodMat+[ ]+LEFT(DesMat,30) NOWAIT
      **DELE
     ELSE
        IF DTRA.CodMat==LsCodMat
           SELE DTRA
           SET ORDER TO DTRA02
           SELE CALM
           SET ORDER TO CATA02
           SEEK LsCodMat
           SCAN WHILE CODMAT=LsCodMat
                LsSubAlm=SubAlm
                SELE DTRA
                SEEK LsSubAlm+LsCodMat
                IF !FOUND()
                   SELE CALM
                   IF STKINI=0
                      WAIT WINDOW [Borrando ]+CodMat+[ ]+LEFT(CATG.Desmat,30)+[ almacen:]+SubAlm NOWAIT
                      DELETE
                   ENDIF
                ENDIF
                SELE CALM
           ENDSCAN
        ENDIF
     ENDIF
     SELE CATG
     IF BorraCatg and !CATG.Inactivo
        DELETE
     ENDIF
ENDSCAN
IF USED([CATG])
   SELE CATG
   USE
ENDIF
IF USED([CALM])
   SELE CALM
   USE
ENDIF
IF USED([DTRA])
   SELE DTRA
   USE
ENDIF
IF USED([DIVF])
   SELE DIVF
   USE
ENDIF
close data
RETURN
****************
FUNCTION _GloRef
****************
parameter LsxxDesRef,m.parte
DIMENSION xxDesRef(2)
STORE [] TO xxDesRef
NumDes = 0
DO WHILE .T.
   IF EMPTY(LsxxDesRef)
      EXIT
   ENDIF
   NumDes = NumDes + 1
   IF NumDes > ALEN(xxDesRef)
      DIMENSION xxDesRef(NumDes+1)
   ENDIF
   Z = AT(" ",LsxxDesRef)
   IF Z = 0
      Z = LEN(LsxxDesRef) + 1
   ENDIF
   xxDesRef(NumDes) = PADC(LEFT(LsxxDesRef,Z-1),08)
   IF Z > LEN(LsxxDesRef)
      EXIT
   ENDIF
   LsxxDesRef = SUBSTR(LsxxDesRef,Z+1)
ENDDO
return xxDesRef(m.Parte)

******************
PROCEDURE ALMVRCMP
******************
USE ALMCFTRA ORDER CFTR01 ALIAS CFTR IN 1
IF !USED(1)
    CLOSE DATA
    RETURN
ENDIF
USE ALMCTRAN ORDER CTRA01 ALIAS CTRA IN 2
IF !USED(2)
    CLOSE DATA
    RETURN
ENDIF
USE ALMDTRAN ORDER DTRA01 ALIAS DTRA IN 3
IF !USED(3)
    CLOSE DATA
    RETURN
ENDIF
SELE CTRA
SET RELA TO TIPMOV+CODMOV INTO CFTR
GO TOP
SCAN FOR CFTR.PIDPCO
     LsLlave = subalm+tipmov+codmov+nrodoc
     lok = .F.
     sele dtra
     seek lsllave
     scan while subalm+tipmov+codmov+nrodoc=lsllave
          IF codajt=[A]
             Lok=.T.
          ELSE
             lok=.F.
             exit
          endif
     endscan
     sele ctra
     if lok
        wait window subalm+[ ]+tipmov+[ ]+codmov+[ ]+nrodoc+[ ]+dtoc(fchdoc) nowait
        do while !rlock()
        enddo
        replace flgfac with [F]
        unlock
     endif
ENDSCAN
close data
return
******************
PROCEDURE ALMPRMEN
******************
PARAMETER M.CODMATD,CODMATH
*
SELE 0
USE ALMDTRAN ORDER DTRA01 ALIAS DTRA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE ALMCATAL ORDER CATA01 ALIAS CALM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*

m.COdMatH = LEFT( TRIM(m.CodMatH)+REPLICATE(CHR(255),LEN(m.CodMatH)),Len(m.CodMatH))
SELECT CATG
SEEK TRIM(m.CodMatD)
IF ! FOUND() .AND. RECNO(0)>0
   GOTO RECNO(0)
   IF DELETED()
      SKIP
   ENDIF
ENDIF
Cancelar = .f.
DO WHILE CATG->CodMat <= m.CodMatH .AND. ! EOF() .AND. ! Cancelar
   WAIT CATG->CodMat+"  "+CATG->DesMat NOWAIT WINDOW
   LsCodMat = CATG->CodMat
   LfStkAct = 0
   LfVCtoMn = 0
   LfVCtoUS = 0
   **
   TfStkAct = 0
   TfVCtoMn = 0
   TfVCtoUS = 0
   FOR TnMes = 1 to 12
       CmpSTK=[STK]+TRAN(TnMES,"@L ##")
       CmpVMN=[VMN]+TRAN(TnMES,"@L ##")
       CmpVUS=[VUS]+TRAN(TnMES,"@L ##")
       REPLACE &CmpSTK. WITH 0
       REPLACE &CmpVMN. WITH 0
       REPLACE &CmpVUS. WITH 0
   ENDFOR
   SELECT CALM
   SET ORDER TO CATA02
   SEEK LsCodMat
   STORE 0 TO LfStkIni,LfVIniMn,LfVIniUs
   SCAN WHILE CodMat=LsCodMat
      LfStkIni = LfStkIni + STKINI
      LfViniMN = LfVINIMN + VINIMN
      LfViniUS = LfVINIUS + VINIUS
      DO GRBSALMEN WITH SUBALM,1,12
   ENDSCAN
   SELE CATG
   LfStkAct = LfStkIni
   LfVCtoMn = LfVINIMN
   LfVCtoUS = LfVINIUS
   FOR TnMes = 1 to 12
       IF TnMes < 12
         LdFecha   = CTOD("01/"+STR(TnMes+1,2,0)+"/"+STR(_Ano,4,0)) - 1
       ELSE
         LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
       ENDIF
       CmpSTK=[STK]+TRAN(TnMES,"@L ##")
       CmpVMN=[VMN]+TRAN(TnMES,"@L ##")
       CmpVUS=[VUS]+TRAN(TnMES,"@L ##")
       *** HALLAR EL VALOR GENERAL ***
       SELE DTRA
       SET ORDER TO DTRA03
       SEEK LsCodMat+DTOS(LdFecha+1)
       IF !FOUND()
          IF RECNO(0)>0
             GO RECNO(0)
             IF DELETED()
                SKIP
             ENDIF
          ENDIF
       ENDIF
       SKIP -1
       IF CodMat =LsCodMat AND FchDoc<=LdFecha
          LfStkAct = DTRA.StkAct
          LFVCTOMN = VCTOMN
          LFVCTOUS = VCTOUS
       ENDIF
       SELE CATG
       REPLACE &CmpSTK.  WITH LfStkAct
       REPLACE &CmpVMN.  WITH LfVCTOMN
       REPLACE &CmpVUS.  WITH LfVCTOUS
   ENDFOR
   SELE CATG
   SKIP
   CANCELAR = INKEY()=K_ESC
ENDDO
CLOSE DATA
RETURN
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
       REPLACE &CamSTK.  WITH fStkSub
       REPLACE &CamVMN.  WITH fValSub1
       REPLACE &CamVUS.  WITH fValSub2
   ENDFOR
ENDIF
SELE CALM
RETURN
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
******************
FUNCTION CapStkAlm
******************
PARAMETERS sSubAlm,sCodMat,dFecha
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
m.NroRegAct= RECNO()
m.OrdenAct = ORDER()
m.Nra_CALM = 0
IF m.CurrArea#[CALM]
   m.NRA_CALM=RECNO([CALM])
   IF ORDER([CALM])=[CATA01]
      =SEEK(sSubAlm+sCodmat,[CALM])
   ELSE
      =SEEK(sCodmat+sSubAlm,[CALM])
   ENDIF
ENDIF
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
IF m.Nra_Calm>0 AND RECNO([CALM])<>m.Nra_CALM
   GO m.Nra_CALM IN [CALM]
ENDIF
SELE (m.CurrArea)
SET ORDER TO (OrdenAct)
GO m.NroRegAct
RETURN LfStkSub
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
