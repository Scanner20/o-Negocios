*+----------------------------------------------------------------------------+
*Ý                                                                            Ý
*Ý bDef_Brw    Procemiento define la ventana para ingresar el detalle del do- Ý
*Ý             cumento a travez del browse que toma las caracteristicas de la Ý
*Ý             ventana de usuario.                                            Ý
*+----------------------------------------------------------------------------+
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
	CASE INLIST(sModulo,[GEN_O/C] )
		sCmp = [TpoReq:1:W=wTpoReq():V=vTpoReq():H='T':P="@!",]
		sCmp = sCmp +[NroReq:H='#REQUI.':W=wNroReq(),]
		sCmp = sCmp +[CodMat:H='COD.MAT.':V=vCdMatg():E=FsErr():F,]
		sCmp = sCmp +[DESMAT:H='DESCRIPCION':W=wdesMat():P='@S20',]
		sCmp = sCmp +[CanPed:H='CANTIDAD':P="####,###.###":V=vCanPed(),]
		sCmp = sCmp +[UndCmp:H='UND':V=vUndCmp():F,]
		IF XsNroOrd=[N]
			sCmp = sCmp +[PreUni:H="PRE.UNI.":P="####,###.###":W=wPreUni():V=vPreUni():E=sErr,]
			sCmp = sCmp +[PorDto:H='%DSCTO':P='###.##',]
		ELSE
			sCmp = sCmp +[PreFob:H='PRE.FOB.':P="####,###.###":W=wPreFob():V=vPreFob():E=sErr,]
*			sCmp = sCmp +[PreUni:H='PRE.UNI.':P="####,###.###":W=wPreUni():V=vPreUni():E=sErr,]
		ENDIF
		sCmp = sCmp +[ImpLin:H="IMPORTE":P="####,###.###":W=wImpLin():V=vImpLin():E=GsMsgErr:F]
*		sCmp = sCmp +[NroReq:W=wNroReq():H='#REQUI.']
	CASE INLIST(sModulo,[APERTURA])
		sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S22':W=.F.,]
		sCmp = sCmp +[StkIni:H="STOCK INICIAL":P="####,###.##":V=vStkIni(),]
		sCmp = sCmp +[U=bUndStk():R:H="STK",ViniMn:H="VALOR S/.":P="####,###.###":V=vViniMn():E=sErr,]
		sCmp = sCmp +[VIniUs:H="VALOR US$":P="####,###.###":V=vVIniUs():E=sErr]
	CASE INLIST(sModulo,[STKMINALM])
		sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S22':W=.F.,]
		sCmp = sCmp+[CATG.UndStk:H='UND':R:W=.F.,]
		sCmp = sCmp+[StkM01:H='Ene':P='9,999,999.999':V=StkM01>=0,]
		sCmp = sCmp+[StkM02:H='Feb':P='9,999,999.999':V=StkM02>=0,]
		sCmp = sCmp+[StkM03:H='Mar':P='9,999,999.999':V=StkM03>=0,]
		sCmp = sCmp+[StkM04:H='Abr':P='9,999,999.999':V=StkM04>=0,]
		sCmp = sCmp+[StkM05:H='May':P='9,999,999.999':V=StkM05>=0,]
		sCmp = sCmp+[StkM06:H='Jun':P='9,999,999.999':V=StkM06>=0,]
		sCmp = sCmp+[StkM07:H='Jul':P='9,999,999.999':V=StkM07>=0,]
		sCmp = sCmp+[StkM08:H='Ago':P='9,999,999.999':V=StkM08>=0,]
		sCmp = sCmp+[StkM09:H='Sep':P='9,999,999.999':V=StkM09>=0,]
		sCmp = sCmp+[StkM10:H='Oct':P='9,999,999.999':V=StkM10>=0,]
		sCmp = sCmp+[StkM11:H='Nov':P='9,999,999.999':V=StkM11>=0,]
		sCmp = sCmp+[StkM12:H='Dic':P='9,999,999.999':V=StkM12>=0 ]
	CASE INLIST(sModulo,[STKMIN])
		sCmp = []
		sCmp = sCmp+[StkM01:H='Ene':P='9,999,999.999':V=StkM01>=0,]
		sCmp = sCmp+[StkM02:H='Feb':P='9,999,999.999':V=StkM02>=0,]
		sCmp = sCmp+[StkM03:H='Mar':P='9,999,999.999':V=StkM03>=0,]
		sCmp = sCmp+[StkM04:H='Abr':P='9,999,999.999':V=StkM04>=0,]
		sCmp = sCmp+[StkM05:H='May':P='9,999,999.999':V=StkM05>=0,]
		sCmp = sCmp+[StkM06:H='Jun':P='9,999,999.999':V=StkM06>=0,]
		sCmp = sCmp+[StkM07:H='Jul':P='9,999,999.999':V=StkM07>=0,]
		sCmp = sCmp+[StkM08:H='Ago':P='9,999,999.999':V=StkM08>=0,]
		sCmp = sCmp+[StkM09:H='Sep':P='9,999,999.999':V=StkM09>=0,]
		sCmp = sCmp+[StkM10:H='Oct':P='9,999,999.999':V=StkM10>=0,]
		sCmp = sCmp+[StkM11:H='Nov':P='9,999,999.999':V=StkM11>=0,]
		sCmp = sCmp+[StkM12:H='Dic':P='9,999,999.999':V=StkM12>=0 ]
	CASE INLIST(sModulo,[PRECIOALM])
		sCmp = [CodMat:H='COD.MAT.':R,CATG.DESMAT:H='DESCRIPCION':R:P='@S35':W=.F.,]
		sCmp = sCmp+[CATG.UndStk:H='UND':R:W=.F.,]
		sCmp = sCmp+[PCTOMN:H='PRE.UNI. S/.':P='9999,999.999':V=PCTOMN>=0,]
		sCmp = sCmp+[PCTOUS:H='PRE.UNI. US$':P='9999,999.999':V=PCTOUS>=0]
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
		sCmp = sCmp +[NroRef:H='Referencia':V=vNroRef():10]
	CASE INLIST(sModulo,[PROGCMP])
		sCmp = [Desmat:30:H='*** I N S U M O S ***',]
		sCmp = sCmp + [StkIni:P='@Z 999999.9':H='Stk.Inic',]
		sCmp = sCmp + [DiaIni:P='@Z 99999':H='Dias',FchCmp:8:H='Alcanza',]
		sCmp = sCmp + [VolPed:P='@Z 999999.9':H='Volumen',]
		sCmp = sCmp + [NumCmp:P='@Z 99':H='#C',]
		sCmp = sCmp + [DiaCsm:P='@Z 99999':H='CeD',]
		sCmp = sCmp + [StkFin:P='@Z 999999.9':H='Stk.Fin.',]
		sCmp = sCmp + [DiaFin:P='@Z 99999':H='Dias',]
		sCmp = sCmp + [Error :30]
	CASE INLIST(sModulo,[PROGANUAL])
		sCmp = [Desmat:30:H='*** I N S U M O S ***',GLOSA:H=str(_ano,4,0):8:R,]
		sCmp = sCmp + [C1=IIF(!EMPTY(V01),V01,C01):H='Ene.':P='@Z 9999999',]
		sCmp = sCmp + [C2=IIF(!EMPTY(V02),V02,C02):H='Feb.':P='@Z 9999999',]
		sCmp = sCmp + [C3=IIF(!EMPTY(V03),V03,C03):H='Mar.':P='@Z 9999999',]
		sCmp = sCmp + [C4=IIF(!EMPTY(V04),V04,C04):H='Abr.':P='@Z 9999999',]
		sCmp = sCmp + [C5=IIF(!EMPTY(V05),V05,C05):H='May.':P='@Z 9999999',]
		sCmp = sCmp + [C6=IIF(!EMPTY(V06),V06,C06):H='Jun.':P='@Z 9999999',]
		sCmp = sCmp + [C7=IIF(!EMPTY(V07),V07,C07):H='Jul.':P='@Z 9999999',]
		sCmp = sCmp + [C8=IIF(!EMPTY(V08),V08,C08):H='Ago.':P='@Z 9999999',]
		sCmp = sCmp + [C9=IIF(!EMPTY(V09),V09,C09):H='Set.':P='@Z 9999999',]
		sCmp = sCmp + [CA=IIF(!EMPTY(V10),V10,C10):H='Oct.':P='@Z 9999999',]
		sCmp = sCmp + [CB=IIF(!EMPTY(V11),V11,C11):H='Nov.':P='@Z 9999999',]
		sCmp = sCmp + [CD=IIF(!EMPTY(V12),V12,C12):H='Dic.':P='@Z 9999999',]
		sCmp = sCmp + [CE=IIF(!EMPTY(V13),V13,C13):H='Tot.':P='@Z 99999999']
	CASE INLIST(sModulo,[PRG_NEW])
		sCmp = [Desmat:30:H=LsDesMat:P=fPicF():W=wFR2(SYS(18)):V=vFR2(SYS(18)),]
		sCmp = sCmp+[GLOSA:H=str(_ano,4,0):8:R,]
		sCmp = sCmp+[V01:H='Ene.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V02:H='Feb.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V03:H='Mar.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V04:H='Abr.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V05:H='May.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V06:H='Jun.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V07:H='Jul.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V08:H='Ago.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V09:H='Set.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V10:H='Oct.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V11:H='Nov.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[V12:H='Dic.':P=fPic():W=wCmp(VARREAD()):V=vCmp(VARREAD()),]
		sCmp = sCmp+[CE=IIF(!EMPTY(V13),V13,C13):H='Tot.':P='@Z 99999999':R]
	CASE INLIST(sModulo,[EST_O_C])
		sCmp = [Concepto:30,]
		sCmp = sCmp+[V01:H='Ene.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V02:H='Feb.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V03:H='Mar.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V04:H='Abr.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V05:H='May.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V06:H='Jun.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V07:H='Jul.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V08:H='Ago.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V09:H='Set.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V10:H='Oct.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V11:H='Nov.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V12:H='Dic.':P=fPic():W=wCmp(SYS(18)):V=vCmp(SYS(18)),]
		sCmp = sCmp+[V13:H='Tot.':P='@Z 99999999':R]
	CASE INLIST(sModulo,[VOLPCMP])
		sCmp = [CodMat:8:H='Cod.Mat.':W=.F.,]
		sCmp = sCmp+[Desmat:30:H='Descripci_n':W=.F.,]
		sCmp = sCmp+[UndStk:3:H='':W=.F.,]
		sCmp = sCmp+[Volped:P='999999.99':V=vVolPed():E=FsErr(),]
		sCmp = scmp+[TpoEmb:H='Embarque':P='999',]
		sCmp = scmp+[Tl_pto:H='Llegada' :P='999']
	CASE INLIST(sModulo,[DIST_CMP])
		sCmp = 		  [CodAux:6:H='Prov.':V=vCodAux():F,]
		sCmp = sCmp + [NomAux:H='Nombre':20:R:F,]
		sCmp = sCmp + [PorDis:H='% Dist.':V=vPorDis(),]
		sCmp = sCmp + [x=CAN_PRG():H='Vol.Cmp':P='9999,999.99',]
*		sCmp = sCmp + [Moneda:H='Mon.':vCodMon(),]
		sCmp = sCmp + [FmaPgo:H='Tabla':V=vFmaPgo():F,]
		sCmp = sCmp + [EmiO_C:H='O/C en':V=vEmiO_C(),]
		sCmp = sCmp + [N_Entrega:H='N§ Entrega':V=vCpProd(),]
		sCmp = sCmp + [Tasa1:H='% Tasa S/.',]
		sCmp = sCmp + [Tasa2:H='% Tasa US$',]
		sCmp = sCmp + [Flete:h='Flete US$ x '+CATG.UndCmp:p='9,999.99':V=Flete>=0,]
		sCmp = sCmp + [PorSeg:h='% Seguro C&F':p='99.99':V=PorSeg>=0,]
		sCmp = sCmp + [GtoAdu:h='Gto.Adu.x '+CATG.UndCmp:p='9,999.99':V=GtoAdu>=0,]
		sCmp = sCmp + [Otros :h='Otros x '+CATG.UndCmp:p='9,999.99':V=Otros>=0,]
		sCmp = sCmp + [CodAdu:h='Aduana',CodSeg:H='Cia.Seg',CodAsg:H='Superv.']
	CASE INLIST(sModulo,[DDIS_CMP])
		sCmp = [Periodo:H='Periodo':R,]
		sCmp = sCmp + [CodMat:H='Insumo':R,]
		sCmp = sCmp + [FchEnt1:H='Fch.Ent. 1',]
		sCmp = sCmp + [FchEnt2:H='Fch.Ent. 2',]
		sCmp = sCmp + [FchEnt3:H='Fch.Ent. 3',]
		sCmp = sCmp + [FchEnt4:H='Fch.Ent. 4',]
		sCmp = sCmp + [FchEnt5:H='Fch.Ent. 5',]
		sCmp = sCmp + [FchEnt6:H='Fch.Ent. 6']

	CASE INLIST(sModulo,[DIST_PAG])
		sCmp = [Fmapgo:H='Codigo':R,]
		sCmp = sCmp + [PorC:H='  %  ':P='999.99':V=vPorC():F,]
		sCmp = sCmp + [Ndias:H='N§ Dias':P='999':V=vndias(),]
		sCmp = sCmp + [cdfcja:H='Rubro':V=vCdfCja():F,]
		sCmp = sCmp + [x=DesNiv():H='Descripci¢n':35]
	CASE INLIST(SMODULO,[REQUIS])
		sCmp = [NROREQ:H='NRO.REQUI.':R,]
		sCmp = sCmp + [FCHREQ:H='FCH. SOL.':R,]
		sCmp = sCmp + [TPOREQ:H='T.R.',]
		sCmp = sCmp + [CODMAT:H='COD.MAT.',]
		sCmp = sCmp + [DESREQ:H='CARACTERISTICA',]
		sCmp = sCmp + [CANREQ:H='CANTIDAD',]
		sCmp = sCmp + [UNDCMP:H='UND.',]
		sCmp = sCmp + [FchEnt:H='FCH.ENT.',]
		sCmp = sCmp + [TPOBIE:H='SIT']
	CASE INLIST(SMODULO,[ESTCHQ])
		sCmp = [NROMES:H='MES':R,]
		sCmp = sCmp + [FCHAST:H='FECHA':R,]
		sCmp = sCmp + [NROCHQ:H='NRO. CHEQUE',]
		sCmp = sCmp + [CTACJA:H='BANCO',]
		sCmp = sCmp + [GIRADO:H='A LA ORDEN',]
		sCmp = sCmp + [NOTAST:H='CONCEPTO',]
		sCmp = sCmp + [NROAST:H='COMPROB',]
		sCmp = sCmp + [IMPCHQ:H='IMPORTE',]
		sCmp = sCmp + [NROVOU:H='RELACION',]
		sCmp = sCmp + [FCHENT:H='FCH. ENTREGA',]
		sCmp = sCmp + [FLGCHQ:H='ESTADO DE ENTERGA',]
		sCmp = sCmp + [FCHPRT:H='FCH. PRESENTACION',]
		sCmp = sCmp + [FLGPRT:H='ESTADO DE PRESENTACION']
	OTHER
		WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
		RETURN TO MASTER
ENDCASE
RETURN sCmp
****************
FUNCTION wTpoReq
****************
SCATTER MEMVAR
IF !EMPTY(m.NroReq)
   RETURN .F.
ENDIF
IF XcTpoO_C=[C]
   m.TpoReq = [R]  && Reposici¢n de stock por defecto
   GATHER MEMVAR FIELDS TpoReq
   RETURN .T.
ELSE
   m.TpoReq = [S]
   GATHER MEMVAR FIELDS TpoReq
   RETURN .F.
ENDIF
RETURN .T.
****************
FUNCTION vTpoReq
****************
SCATTER MEMVAR
IF XcTpoO_C=[C]
   IF !m.TpoReq$[RA]
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
****************
FUNCTION wNroReq
****************
RETURN .F.
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
FUNCTION vCdMatg
****************
IF DELETED()
   RETURN .T.
ENDIF
PRIVATE iNroReg
SCATTER MEMVAR
iNroReg = RECNO()
lValido = F1_BUSCA(m.CodMat,"CODMAT","CATG","CATG","",.f.,"")
**lAsig=SEEK(GsSubAlm+m.CodMat,"CALM")
IF !lValido
   sErr = [Codigo de material invalido]
ENDIF
**IF !lAsig
**   sErr = [Material no asignado a este almacen]
**   lValido  = .F.
**ENDIF
GO iNroReg
IF lValido
   DO CASE
      CASE INLIST(sModulo,[GEN_O/C])
           m.lUndStk = .F.
           m.lUndCmp = .T.
           m.lUndVta = .F.
           =SEEK(m.CodMat,[CATG])
           m.DesMat = CATG.DesMat
           m.Marcas = CATG.Marca
           DO CASE
              CASE m.lUndStk
                 m.UndCmp = CATG->UndStk
                 m.Factor = 1
              CASE m.lUndVta
                 m.UndCmp = CALM->UndVta
                 m.Factor = CALM->FacEqu
              CASE m.lUndCmp
                 m.UndCmp = CATG->UndCmp
                 m.FacEqu = CATG->FacEqu
           ENDCASE
           IF m.FacEqu <= 0
              m.FacEqu = 1
           ENDIF
           IF EOF()
              GO iNroReg
           ENDIF
           GATHER MEMVAR FIELDS CodMat,UndCmp,Marcas,DesMat,FacEqu
      OTHER
           =SEEK(m.CodMat,[CATG])
           GATHER MEMVAR FIELDS CodMat
   ENDCASE
ENDIF
RETURN lValido
****************
FUNCTION wDesMat
****************
IF m.Estoy=[EDITANDO] AND TpoReq#[R]
   RETURN .T.
ENDIF
RETURN .F.
****************
FUNCTION vUndCmp
****************
SCATTER MEMVAR
IF !INLIST(TpoReq,[R],[A],[S])
   XsUndStk=CATG.UndStk
ELSE
   XsUndStk=UndCmp
ENDIF

lValido=F1_Busca(m.UndCmp,"UNDVTA","EQUN","EQUN",XsUndStk,.T.,"")
IF lValido
   m.FacEqu = EQUN.FacEqu
ENDIF
IF EMPTY(m.UndCmp)
   lValido = .T.
   m.FacEqu = 1
ENDIF
DO CASE
   CASE  CATG->UndCmp == m.UndCmp
         m.FacEqu = CATG->FACEQU
         lValido = .T.
   CASE  CATG->UndStk == m.UndCmp
         m.FacEqu = 1
         lValido = .T.
ENDCASE
IF m.FacEqu<=0
   m.FacEqu = 1
ENDIF
m.CanPed = CanPed*FacEqu/m.FacEqu
GATHER MEMVAR FIELDS UndCmp,FacEqu,CanPed
RETURN lValido
****************
FUNCTION vCanPed
****************
SCATTER MEMVAR
RETURN m.CanPed>=0

***************
FUNCTION wPreUni
***************
RETURN XsNroOrd=[N]
***************
FUNCTION vPreUni
***************
SCATTER MEMVAR
IF m.PreUni>=0
   IF m.CanPed >0
      m.ImpLin = ROUND(m.CanPed*m.PreUni*(1-m.PorDto/100),2)
   ELSE
      m.ImpLin = ROUND(m.PreUni,2)
   ENDIF
   GATHER MEMVAR FIELD PreUni,PreFob,ImpLin
ENDIF
RETURN m.preuni>=0
***************
FUNCTION wPreFob
***************
RETURN XsNroOrd#[N]
***************
FUNCTION vPreFob
***************
SCATTER MEMVAR
IF m.PreFob>=0
   m.PreUni=m.PreFob
   IF m.CanPed >0
      m.ImpLin = ROUND(m.CanPed*m.PreUni*(1-m.PorDto/100),2)
   ELSE
      m.ImpLin = ROUND(m.PreUni,2)
   ENDIF
   GATHER MEMVAR FIELD PreUni,PreFob,ImpLin
ENDIF
RETURN m.PreFob>=0
***************
FUNCTION wPorDto
***************
SCATTER MEMVAR
IF XsNroOrd#[N]
   m.PreUni=m.PreFob
   GATHER MEMVAR FIELD PreUni,PreFob
ENDIF
RETURN XsNroOrd=[N]
****************
FUNCTION vPorDto
****************
RETURN PorDto>=0
****************
FUNCTION wImpLin
****************
SCATTER MEMVAR
IF m.CanPed >0
   m.ImpLin = ROUND(m.CanPed*m.PreUni*(1-m.PorDto/100),2)
ELSE
   m.ImpLin = ROUND(m.PreUni,2)
ENDIF
GATHER MEMVAR FIELD ImpLin
RETURN .T.
****************
FUNCTION vImpLin
****************
SCATTER MEMVAR
IF m.CanPed >0
   m.PreUni = m.ImpLin/(m.CanPed*(1-m.PorDto/100))
ELSE
   m.PreUni = m.ImpLin
ENDIF
IF XsNroOrd=[N]

ELSE
ENDIF
IF m.ImpLin>=0
   GATHER MEMVAR FIELD ImpLin,Preuni,PreFob
ENDIF
RETURN m.ImpLin>=0
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
FUNCTION bUndStk
****************
RETURN IIF(SEEK(CodMat,"CATG"),CATG.UndStk,"")
********************
PROCEDURE bBorra_Reg
********************
IF !lBorra
   =F1QEH("No es posible borrar registro")
   RETURN
ENDIF
DO CASE
   CASE sModulo =[GEN_O/C]
        IF SEEK(NroOrd+Usuario+NroReq,[DO_C])
           IF DO_C.CanDes<>0
              DO F1MsgErr WITH [ Item ya tiene ingreso al almac‚n ]
              RETURN
           ENDIF
        ENDIF
       *IF F1_ALERT([Solo se puede borrar un item.;]+;
       *            [No se puede a¤adir.          ],4)=2
       *   RETURN
       *ENDIF

   CASE INLIST(sModulo,[FCBB_DET])
        if saldos.FlgCtb
           define window caja from 18,13 to 20,67
           activate window caja
           xrep = 'N'
           @00,02 say "Reg. Generado en Cont.,Desea Eliminarlo <S/N>" get xrep pict "@!" valid xrep$[SN]
           read
           release window caja
           if lastkey()=27 .or. xrep=[N]
              return
           endif
           wait window [Eliminando Registro....] Nowait
           do DbfCon    &&& Abre Bases de Datos Para Contabilidad
           store 0 to nImpNac, nImpUsa
           XsCodOpe = saldos.CodOpe
           XsNivel  = saldos.Nivel
           do Grb_Ast with .f.,.t.
        endif

   case sModulo = [FCJA_DOC]
        if nroast1 <> space(len(docs.nroast1))
           =F1QEH("Imposible Eliminar Registro")
           RETURN
        endif

   case sModulo = [FORM_PAG]
        lasig = seek(fpago.fmapgo,[DPAGO])
        if lasig
           =F1QEH("Imposible Eliminar Registro")
           return
        endif

   case sModulo = [BRW_ANU]
        if anch.flgest = [A]
           =F1QEH("Imposible Eliminar Registro")
           RETURN
        endif

   case sModulo = [BRW_DOC]
        if !empty(grch.doccan)
           =F1QEH("Imposible Eliminar Registro")
           RETURN
        endif

ENDCASE

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
IF INLIST(sModulo,[GEN_O/C])
   _CURoBJ=ObjNum(m.CtrlBrw)
   KEYBOARD CHR(13)
ENDIF

*********************
PROCEDURE bAgrega_Reg
*********************
IF !lAdiciona
   =F1QEH("No es posible a¤adir registro")
   RETURN
ENDIF
PRIVATE EOF1
Eof1 = EOF()
*
DO CASE
   CASE sModulo = [FCJA_DOC]
       *seek m.queanomes+cnfg.nivel+saldos.nrodoc
        seek cnfg.nivel+saldos.clfaux+saldos.codaux+saldos.nrodoc
        if found()
           if nroast1 <> space(len(docs.nroast1))
              =F1QEH("No es posible a¤adir registro")
              RETURN
           endif
          *scan while periodo+nivel+nrodoc=m.queanomes+cnfg.nivel+saldos.nrodoc
           scan while nivel+clfaux+codaux+nrodoc=cnfg.nivel+saldos.clfaux+saldos.codaux+saldos.nrodoc
           endscan
           skip -1
           pdfchpag = docs.fchvto + 30
           pdimpusa = docs.impusa - docs.pagext
           pdimport = docs.import - docs.pagnac
           if (pdimpusa+pdimport) = 0
              =F1QEH("No es posible a¤adir registro")
              RETURN
           endif
        else
           pdfchpag = saldos.fchvto1
           pdimpusa = saldos.impusa
           pdimport = saldos.import
        endif
   CASE SMODULO = [REQUIS]
        SELE VREQ
        GO BOTT
        XFNROREQUI = TRANS(VAL(NROREQ)+1,[@L #######])
   CASE sModulo = [G_AUTO_OC]
        IF !INLIST(NroItm,[00],[L])
           SCATTER MEMVAR
        ELSE
           DO F1MsgErr WITH [No se puede agregar aquí]
           RETURN
        ENDIF
   *
   CASE sModulo = [BRW_DOC]
        IF LIQU.EstLiq = [C]
           wait window [Imposible Adicionar Datos, Liquidación Cerrada ...]
           return
        ENDIF
        *
        DEFINE   window rango from 16,20 to 20,60;
                 title "Tipo de Documento" shadow
        activate window rango
        m.opcd_c = 1

        @01,02 get m.opcd_c pict "@*H \<Provisión;\<Transf. entre Bancos;Tr\<ibutos" ;
        size 1,10,1 ;
        default 1 ;
        font "ms sans serif", 8 ;
        style "b";
        valid inlist(m.opcd_c,1,2,3)
        read
        *
        release window rango
        IF LASTKEY() = 27
           RETURN
        ENDIF
        *
        DO CASE
           CASE m.opcd_c = 1     &&& Provision
                do fcjprch5.spr
           CASE m.opcd_c = 2     &&& Transf. entre Bancos
                do fcjprch8.spr
           CASE m.opcd_c = 3     &&& Tributos
                do fcjprch9.spr
        ENDCASE
        IF UltTecla = k_esc
           RETURN
        ENDIF
        *
   CASE sModulo = [BRW_DO2]
        *
        DEFINE   window rango from 16,20 TO 20,60;
                 title "Tipo de Documento" SHADOW
        activate window rango
        m.OpcD_c = 1

        @01,02 get m.opcd_c pict "@*H \<Provisión;\<Cuenta" ;
        size 1,10,1 ;
        default 1 ;
        font "ms sans serif", 8 ;
        style "b";
        valid inlist(m.opcd_c,1,2)
        read
        *
        RELEASE WINDOW rango
        IF LASTKEY() = 27
           RETURN
        ENDIF
        *
        DO CASE
           CASE m.opcd_c = 1     &&& Provision
                do fcjprchP.spr
           CASE m.opcd_c = 2     &&& Para que pida por cuenta
                do fcjprchT.spr
        ENDCASE
        IF UltTecla = k_esc
           RETURN
        ENDIF
        *
   CASE sModulo = [BRW_ANU]
        DO fcjanch3.spr
        IF UltTecla = k_esc
           RETURN
        ENDIF

ENDCASE
*
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
   CASE INLIST(sModulo,[GEN_O/C])
        DO WHILE !RLOCK()
        ENDDO
        REPLACE NroOrd  WITH XsNroOrd
        REPLACE TpoBie  WITH XcTpoBie
        REPLACE Usuario WITH XsUsuario
        UNLOCK
   CASE sModulo = [DIST_CMP]
        DO WHILE !RLOCK([DIST])
        ENDDO
        REPLACE DIST.CODMAT WITH PSCODMAT
        UNLOCK

   CASE sModulo = [DDIS_CMP]
        do while !rlock([ddis])
        enddo
        replace ddis.periodo   with m.pertra
        replace ddis.codmat    with pscodmat
        replace ddis.codaux    with dist.codaux
        replace ddis.pordis    with dist.pordis
        replace ddis.fmapgo    with dist.fmapgo
        replace ddis.emio_c    with dist.emio_c
        replace ddis.n_entrega with dist.n_entrega
        replace ddis.tasa1     with dist.tasa1
        replace ddis.tasa2     with dist.tasa2
        unlock

   CASE sModulo = [F_CAJA_P]
        DO WHILE !RLOCK([PROY])
        ENDDO
        REPLACE PROY.CODMAT WITH XsPeriodo
        UNLOCK
   CASE sModulo = [FCBB_DET]
        DO WHILE !RLOCK([SALDOS])
        ENDDO
        REPLACE SALDOS.Periodo WITH m.QueAnoMes
        REPLACE SALDOS.FecPed  WITH XdFchAct
        REPLACE SALDOS.Nivel   WITH CNFG.Nivel
        REPLACE SALDOS.NROMES  WITH XsNroMes
        REPLACE SALDOS.codope  WITH CNFG.CodOpe
        replace saldos.codcta  with m.ctaban
        REPLACE saldos.NroBan  WITH m.NroBan
        REPLACE saldos.VctOri  WITH XdFChAct
        REPLACE saldos.codmon  WITH m.codmon
        REPLACE SALDOS.Fchast  WITH XdFchAct
        replace saldos.tpocmb  with iif(cnfg.tpomov='I',vcamusa,vcamusav)
        UNLOCK
   CASE sModulo = [FCJA_DOC]
        DO WHILE !RLOCK([DOCS])
        ENDDO
        REPLACE DOCS.PERIODO WITH M.QUEANOMES
        REPLACE DOCS.NIVEL   WITH CNFG.NIVEL
        REPLACE DOCS.NROMES  WITH XSNROMES
        REPLACE DOCS.NROAST  WITH SALDOS.NROAST
        REPLACE DOCS.CODOPE  WITH CNFG.CODOPE
        REPLACE DOCS.NRODOC  WITH SALDOS.NRODOC
        REPLACE DOCS.NOMAUX  WITH SALDOS.NOMAUX
        REPLACE DOCS.CLFAUX  WITH SALDOS.CLFAUX
        REPLACE DOCS.CODAUX  WITH SALDOS.CODAUX
        REPLACE DOCS.GLOORI  WITH SALDOS.GLOORI
        REPLACE DOCS.CODMON  WITH SALDOS.CODMON
        REPLACE DOCS.VCTORI  WITH SALDOS.VCTORI
        REPLACE DOCS.IMPext  WITH SALDOS.impext
        REPLACE DOCS.IMPnac  WITH SALDOS.impnac
        REPLACE DOCS.fchvto  WITH PdFchPag
        REPLACE DOCS.IMPusa  WITH pdimpusa
        REPLACE DOCS.IMPort  WITH pdimport
        REPLACE DOCS.TIPDOC  WITH CNFG.TIPDOC
        REPLACE DOCS.fchpag  WITH PdFchPag
        REPLACE DOCS.pagext  WITH pdimpusa
        REPLACE DOCS.pagnac  WITH pdimport
        UNLOCK
   CASE sModulo = [DIST_PAG]
        do while !rlock([dpago])
        enddo
        replace dpago.fmapgo with XsCodPag
        unlock
   CASE INLIST(sModulo,[SIST_REQU])
        DO WHILE !RLOCK([REQU])
        ENDDO
        REPLACE Area    WITH LsArea
        REPLACE Sistema WITH GsSisTema
        replace sede    with LsSede
        UNLOCK IN [REQU]
   CASE INLIST(SMODULO,[REQUIS])
        DO WHILE !RLOCK([VREQ])
        ENDDO
        REPLACE NROREQ WITH XFNROREQUI
        REPLACE FCHREQ WITH DATE()
        UNLOCK IN [VREQ]
   CASE INLIST(SMODULO,[G_AUTO_OC])
        =F1_rlock(0)	
        REPLACE PerEnt WITH m.PerEnt
        REPLACE TpoReg WITH m.TpoReg
        REPLACE FmaPgo WITH m.FmaPgo
        REPLACE CodAux WITH m.CodAux
        REPLACE CodMat WITH m.CodMat
        REPLACE FlgEmi WITH m.FlgEmi
        *REPLACE NroItm WITH m.NroItm
        REPLACE NroOrd WITH m.NroOrd
        *
        replace lugent with m.lugent
        replace fchord with m.fchord
        replace nroitm with tran(val(m.nroitm)+1,[@l 99])
        replace desmat with m.desmat
        replace undcmp with m.undcmp
        replace facequ with m.facequ
        *
        UNLOCK

   CASE INLIST(sModulo,[BRW_DOC])
        =F1_Rlock(0)
        repla fchact with xdfchtrb, usuario with xsusuario
        repla nroliq with xsnroliq
        *
        DO CASE
           CASE m.OpcD_c = 1         &&& Provisiones
                repla coddiv with xcoddiv
                repla nromes with xnromes,  codope  with xcodope,  nroast with xnroast
                repla codcta with xcodcta,  clfaux  with lsclfaux, codaux with lscodaux
                repla nomaux with lsnomaux, nrodoc  with lsnroast, fchvto with dfchvto
                repla fchped with dfchped,  tpomov  with [H],      codmon with xcodmon
                repla import with sdonac,   impusa  with sdousa
                repla nroref with xnroref,  glodoc  with lsnotast, coddoc with xstipo
                *
                repla pagdiv with xcoddiv
                repla nomdiv with iif(seek([DV ]+xcoddiv,[auxi]),auxi.nomaux,[])
                repla fchpag with dfchped
                repla monbco with iif(xcodmon=1,[S/.],[US$])
                repla pagomn with iif(xcodmon=1,sdonac,0)
                repla pagous with iif(xcodmon=2,sdousa,0)
                repla pagtot with iif(xcodmon=1,sdonac,sdousa)
                repla girado with lsnomaux
                repla cmbpag with m.cmbdia
                repla fchent with xdfchtrb
                repla nroagr with xnroagr
                repla tpodoc with iif(codcta=[423],[Carta],[Cheque-Man])
                IF TpoDoc = [Carta]
                   repla moncar with monbco
                   repla notast with [PAGO LT. VCTO. ]+dtoc(dfchvto)+[ REG.]+lsnroast
                ENDIF
                *
                DO CASE
                   CASE codcta = [42300100]  &&& Soles
                        repla pagope with [021]
                        repla nomope with iif(seek(grch.pagope,[oper]),oper.nomope,[])
                   CASE codcta = [42300200]  &&& Dolares
                        repla pagope with [038]		
                        repla nomope with iif(seek(grch.pagope,[oper]),oper.nomope,[])		
                ENDCASE
                *
                repla destino with xsdestino
                repla nrouni  with xsnrouni
                *
           CASE INLIST(m.opcd_c,2,3)     &&& Transf. entre Bancos y Tributos
                repla coddiv  with xcoddiv
                repla codope  with iif(m.opcd_c=2,[063],[040])
                repla codcta  with xcodcta, codcta_t with xcodcta
                IF m.OpcD_c = 3
                   repla clfaux with [40 ], codaux with lscodaux, nomaux with lsnomaux
                   repla nrodoc with lsnroast
                endif
                repla coddoc  with iif(m.opcd_c=2,[035],[   ])
                repla tpomov  with [H]
                repla codmon  with xcodmon
                DO CASE
                   CASE CodMon = 1
                        repla import with lfimport
                        repla impusa with round(lfimport/m.cmbdia,2)
                   CASE CodMon = 2
                        repla impusa with lfimport
                        repla import with round(lfimport*m.cmbdia,2)
                ENDCASE
                *
                repla pagdiv  with xcoddiv
                repla nomdiv  with iif(seek([DV ]+xcoddiv,[auxi]),auxi.nomaux,[])
                repla fchpag  with xdfchtrb
                repla monbco  with iif(xcodmon=1,[S/.],[US$])
                repla pagomn  with iif(xcodmon=1,import,0)
                repla pagous  with iif(xcodmon=2,impusa,0)
                repla pagtot  with iif(xcodmon=1,import,impusa)
                repla cmbpag  with m.cmbdia
                repla fchent  with xdfchtrb
                repla nroagr  with xnroagr
                repla tpodoc  with [Cheque-Man]
                repla pagope  with iif(m.opcd_c=2,[063],[040])		
                repla nomope  with iif(seek(grch.pagope,[oper]),oper.nomope,[])		
        ENDCASE
           *
        repla fchdig  with date()
        repla hordig  with time()
        *
        UNLOCK
   CASE INLIST(sModulo,[BRW_DO2])
        =F1_Rlock(0)
        repla fchact with xdfchtrb, usuario with xsusuario
        repla nroliq with xsnroliq
        *
        DO CASE
           CASE m.OpcD_c = 1         &&& Provisiones
                repla coddiv with xcoddiv
                repla nromes with xnromes,  codope  with xcodope,  nroast with xnroast
                repla codcta with xcodcta,  clfaux  with lsclfaux, codaux with lscodaux
                repla nomaux with lsnomaux, nrodoc  with lsnroast, fchvto with dfchvto
                repla fchped with dfchped,  tpomov  with [H],      codmon with xcodmon
                repla import with sdonac,   impusa  with sdousa
                repla nroref with xnroref,  glodoc  with lsnotast, coddoc with xstipo
                *
                repla pagdiv with xcoddiv
                repla nomdiv with iif(seek([DV ]+xcoddiv,[auxi]),auxi.nomaux,[])
                repla fchpag with dfchped
                repla monbco with iif(xcodmon=1,[S/.],[US$])
                repla pagomn with iif(xcodmon=1,sdonac,0)
                repla pagous with iif(xcodmon=2,sdousa,0)
                repla pagtot with iif(xcodmon=1,sdonac,sdousa)
                repla girado with lsnomaux
                repla cmbpag with m.cmbdia
                repla fchent with xdfchtrb
                repla nroagr with xnroagr
                repla tpodoc with iif(codcta=[423],[Carta],[Cheque-Man])
                IF TpoDoc = [Carta]
                   repla moncar with monbco
                   repla notast with [PAGO LT. VCTO. ]+dtoc(dfchvto)+[ REG.]+lsnroast
                ENDIF
                *
                DO CASE
                   CASE codcta = [42300100]  &&& Soles
                        repla pagope with [021]
                        repla nomope with iif(seek(grch.pagope,[oper]),oper.nomope,[])
                   CASE codcta = [42300200]  &&& Dolares
                        repla pagope with [038]		
                        repla nomope with iif(seek(grch.pagope,[oper]),oper.nomope,[])		
                ENDCASE
                *
                repla destino with xsdestino
                repla nrouni  with xsnrouni
                *
           CASE INLIST(m.opcd_c,2,3)     &&& Transf. entre Bancos y Tributos
                repla coddiv  with xcoddiv
                repla codope  with iif(m.opcd_c=2,[063],[040])
                repla codcta  with xcodcta, codcta_t with xcodcta
                IF m.OpcD_c = 3
                   repla clfaux with [40 ], codaux with lscodaux, nomaux with lsnomaux
                   repla nrodoc with lsnroast
                endif
                repla coddoc  with iif(m.opcd_c=2,[035],[   ])
                repla tpomov  with [H]
                repla codmon  with xcodmon
                DO CASE
                   CASE CodMon = 1
                        repla import with lfimport
                        repla impusa with round(lfimport/m.cmbdia,2)
                   CASE CodMon = 2
                        repla impusa with lfimport
                        repla import with round(lfimport*m.cmbdia,2)
                ENDCASE
                *
                repla pagdiv  with xcoddiv
                repla nomdiv  with iif(seek([DV ]+xcoddiv,[auxi]),auxi.nomaux,[])
                repla fchpag  with xdfchtrb
                repla monbco  with iif(xcodmon=1,[S/.],[US$])
                repla pagomn  with iif(xcodmon=1,import,0)
                repla pagous  with iif(xcodmon=2,impusa,0)
                repla pagtot  with iif(xcodmon=1,import,impusa)
                repla cmbpag  with m.cmbdia
                repla fchent  with xdfchtrb
                repla nroagr  with xnroagr
                repla tpodoc  with [Cheque-Man]
                repla pagope  with iif(m.opcd_c=2,[063],[040])		
                repla nomope  with iif(seek(grch.pagope,[oper]),oper.nomope,[])		
        ENDCASE
           *
        repla fchdig  with date()
        repla hordig  with time()
        *
        UNLOCK

   CASE INLIST(sModulo,[BRW_ANU])
        =f1_rlock(0)
        repla fchact with xdfchtrb,    usuario with xsusuario
        repla nromes with vmov.nromes, codope  with lscodope
        repla nomope with lsnomope,    nroast  with lsnroast
        repla nrovou with vmov.nrovou, codmon  with vmov.codmon
        repla tpocmb with vmov.tpocmb, fchast  with vmov.fchast
        repla fchped with vmov.fchped, fchent  with vmov.fchent
        repla notast with vmov.notast, gloast  with vmov.gloast
        repla ctacja with vmov.ctacja, nomcta  with lsnomcta
        repla nrocta with lsnrocta,    codbco  with lscodbco
        repla nombco with lsnombco,    girado  with vmov.girado
        repla nrochq with vmov.nrochq, impchq  with vmov.impchq
        repla tpoanu with vremov(nopc)
        repla fchdig with date(),   hordig  with time()
        UNLOCK

ENDCASE
IF EOF1
   GO TOP
   DEACTIVATE WINDOW (m.bDeta)
   SHOW WINDOW (m.bDeta) REFRESH TOP
ENDIF
IF INLIST(sModulo,[GEN_O/C])
   _CURoBJ=ObjNum(m.CtrlBrw)
   KEYBOARD CHR(13)
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

ENDCASE

*+----------------------------------------------------------------------------+
*Ý                                                                            Ý
*Ý wBrw      WHEN       del browse a nivel de registro                        Ý
*Ý                                                                            Ý
*Ý                                                                            Ý
*+----------------------------------------------------------------------------+

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
       =SEEK(CODMAT,"CATG")
       @ 22,14 SAY CATG.DESMAT PICT "@S40"
       lGrb_Arch = .F.
   CASE INLIST(sModulo,[STKMINALM])
       =SEEK(CODMAT,"CATG")
       @ 22,14 SAY CATG.DESMAT PICT "@S40"
   CASE INLIST(sModulo,[GEN_O/C] )
       lalm=SEEK(CodMat,[CATG])
       IF lAlm
          @ 16,2 SAY [Descri:] COLOR SCHEME 7
          @ 16,9 SAY DesMat SIZE 1,30
          @ 16,41 SAY [Ult.Pre:] COLOR SCHEME 7
          @ 16,61 SAY [Pre.Prm:] COLOR SCHEME 7
          IF XiCOdMon=1
            @ 16,49 SAY CATG.Pultmn   PICT "999,999.99"
            @ 16,69 SAY CATG.PCTOMN   PICT "999,999.99"
          ELSE
            @ 16,49 SAY CATG.PultUs   PICT "999,999.99"
            @ 16,69 SAY CATG.PCTOUS   PICT "999,999.99"
          ENDIF
       ELSE
          @16,1 SAY REPLI(" ",78) COLOR SCHEME 1
       ENDIF
   *
   case inlist(sModulo,[BRW_DOC],[BRW_ANU])
        do wbrw_chq
   *
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

   DO CASE
      CASE sModulo#[TRANSFER]
           IF m.lPidOdt AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              SHOW GET m.sNroOdt ENABLE
           ELSE
              IF !m.lPidOdt
                 m.sNroOdt = []
                 @ 7,1 CLEAR TO 7,26
              ELSE
                 SHOW GET m.sNroOdt DISABLE
                 SHOW GET m.Fbatch  DISABLE
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
      m.sCodCli = []
   ENDIF

   IF !m.lPidPro
      m.sCodPro = []
   ENDIF

   DO CASE
      CASE sModulo#[TRANSFER]
           IF !m.lPidPro AND !lPidCli
              m.sCodAux = []
              @5,28 CLEAR TO 5,78
           ELSE
              IF !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
                 SHOW GET m.sCodAux ENABLE
              ELSE
                 SHOW GET m.sCodAux DISABLE
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
           IF m.lModCsm AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              SHOW GET m.sCodPrd ENABLE
              SHOW GET m.Fbatch  ENABLE
           ELSE
              IF !m.lModCsm
                 @ 6,28 CLEAR TO 7,78
              ELSE
                 SHOW GET m.sCodPrd DISABLE
              ENDIF
           ENDIF
       OTHER
   ENDCASE

   DO CASE
      CASE sModulo#[TRASNFER]
        DO CASE
           CASE m.lPidPco AND !INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
              IF m.lMonElg
                 SHOW GET m.nCodMon ENABLE
              ELSE
                 SHOW GET m.nCodMon DISABLE
              ENDIF
           CASE m.lPidPco AND INLIST(m.Estoy,[EDITCLAVE],[PIDLLAVE])
                SHOW GET m.nCodMon DISABLE
           CASE !m.lPidPco AND !m.lModCsm
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
*****************
FUNCTION  _Cuales
*****************
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
   DO F0MBPRN IN F0PRINT
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
***************
FUNCTION NROCOR
***************
PARAMETER M.TIPO
if PARAMETERS()<1
   M.tIPO = [N]
endif
IF CDOC.CodDoc = [O/C]
   XsNroMes=TRAN(_MES,"@L ##")
   Campo1   = IIF(m.Tipo=[N],[NDOC]+XsNroMes,[IDOC]+XsNroMes)
ELSE
   Campo1   = [NDOC]+XsNroMes
ENDIF
iNroDoc = CDOC.&Campo1.
RETURN  RIGHT("000000" + LTRIM(STR(iNroDoc)), 6)
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
******************
PROCEDURE CMPpPCIA  && Program de compras de insumos anual
******************
do cmpppcia.spr
RETURN
******************
procedure cmppcmes    && Ultimo precio de compra por O/C
******************

nRep=F1_ALERT([Este proceso calcula el precio de compra del mes;]+;
              [en base a los ingresos por compra registrados en;]+;
              [el almacen y su valor total.                    ;],[PROCESO])
IF nRep=2
   RETURN .F.
ENDIF
m.WORKAREA = SELECT()
ArcErr     = [OC]+GsAnoMes+[.ERR]
pathctb3   = [\base\]
lReproceso = .T.
DO ABRIRDBFS IN Cmpiultc


SELE CATG
SET RELA TO GaClfDiv(2)+LEFT(CODMAT,GaLenCod(2)) INTO DIVF
SET FILTER TO (DIVF.TipFam=1 OR TipMat=[1])
***
m.ultcom   = .f.
m.dFch1   = CTOD([01/01/]+tran(_ANO,[9999]))
m.dFch2   = GdFecha
nMesIni   = _MES
nMEsFin   = _MES
m.CodMon  = 1
m.Cuales1 = 1  && Activo,Inactivos,todos
m.Cuales3 = 3  && Con stock ,sin stock , todos
nSedes = 0
UltTecla = 0
m.codmatD=SPACE(LEN(CATG.CodMat))
m.CodMatH=SPACE(LEN(CATG.COdMAt))

DO cmpcpmes.spr
IF UltTecla = K_Esc
   CLOSE DATA
   RETURN
ENDIF
DO GenTempo IN CMPIULTC
CLOSE DATA
RETURN
******************
procedure cmppcprm    && Ultimo precio de compra por compras promedio
******************

nRep=F1_ALERT([Este proceso calcula el precio de compra del mes;]+;
              [en base a los ingresos por compra registrados en;]+;
              [el almacen y su valor total.                    ;],[PROCESO])
IF nRep=2
   RETURN .F.
ENDIF
m.WORKAREA = SELECT()
ArcErr     = [OC]+GsAnoMes+[.ERR]
pathctb3   = [\base\]
IF !USED([DO_C])
   SELE 0
   USE CMPDO_CG ORDER DO_C05 ALIAS DO_C
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([CO_C])
   SELE 0
   USE CMPCO_CG ORDER CO_C01 ALIAS CO_C
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([DTRA])
   SELE 0
   USE ALMDTRAN ORDER DTRA03 ALIAS DTRA
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([CATG])
   SELE 0
   USE ALMCATGE ORDER CATG01 ALIAS CATG
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
ArcDbf = PATHctb3+[ADMMTCMB]
IF !USED([TCMB])
   SELE 0
  *USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
   use (ArcDbf) order tcmb01 alias tcmb
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([DIVF])
   SELE 0
   USE ALMTdivf ORDER divf01 ALIAS divf
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([CFTR])
   SELE 0
   USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
SELE DTRA
COPY STRU TO &ArcErr. WITH CDX
SELE 0
USE &ArcErr. ALIAS ERROR EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE DO_C
SET RELA TO NroOrd INTO CO_C
SELE CATG
SET RELA TO GaClfDiv(2)+LEFT(CODMAT,GaLenCod(2)) INTO DIVF
SET FILTER TO DIVF.TipFam=1
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
***
PRIVATE kK,LdFchFin,TT
m.CodMatD = SPACE(LEN(CATG.CodMat))
m.CodMatH = SPACE(LEN(CATG.CodMat))
_Moneda   = 1
UltTecla  = 0
m.COntrol = 1
m.QuePre  = 1   && 1 O_Compra, 2 ALMACEN
do CmpCpMes.spr
IF UltTecla = K_Esc
   CLOSE DATA
   RETURN
ENDIF
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.CodMatH)+CHR(255)
nAno=_Ano
nMes=_Mes
nMesIni = _MES
IF  nMes < 12
    LdFchFin  = CTOD("01/"+STR(nMes+1,2,0)+"/"+STR(nAno,4,0)) - 1
ELSE
    LdFchFin  = CTOD("31/12/"+STR(nAno,4,0))
ENDIF
SELE CATG
SEEK m.CodMatD
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE COdMat<=m.CodMatH FOR !Inactivo
  	WAIT WINDOW CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[*] NOWAIT
  	DO WHILE !RLOCK()
  	ENDDO
 _CodMat = CATG.CodMat
 STORE 0 TO LfImpCmp1,LfImpCmp2,LfPreUni,LfPulCmp,LfCanDes
 STORE 0 TO LfImpAlm1,LfImpAlm2
 LdUltCmp = CATG.UltCmp
 LfPulCmp = iif(_moneda=1,CATG.PultMn,CATG.PultUs)
 LdFchRef = LdFchFin
 lOkeyCmp = .T.
 DO WHILE DTOS(LdFchRef)=LEFT(DTOS(LdFchFin),6)
     SELE DTRA
   SET ORDER TO DTRA03
     	WAIT WINDOW _CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+DTOC(LdFchRef)+[ Buscando] NOWAIT
     SEEK _CodMat+DTOS(LdFchRef)+[I]
     IF !FOUND()
        LdFchRef = LdFchRef - 1
        LOOP
     ENDIF
     	WAIT WINDOW _CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ ]+DTOC(LdFchRef)+[ Puede ser] NOWAIT
     lOkey = .F.
  FOR kk= 1 TO ALEN(aPidPco)
      WAIT WINDOW _CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ Buscando en:]+TipMov+CodMov+[ ]+DTOC(LdFchRef) NOWAIT
      SEEK _CodMat+DTOS(LdFchRef)+aPidPco(kk)
      IF !FOUND()
         LOOP
      ENDIF
      IF !(FchDoc==LdFchRef AND CodMat==_CodMat)
         EXIT
      ENDIF
      *
            scan while codmat+dtos(fchdoc)+tipmov+codmov=_CodMat+DTOS(LdFchRef)+aPidPco(kk)
           *IF TipMov+CodMov=aPidPco(kk)
	          WAIT WINDOW _CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ Ultima Compra:]+TipMov+CodMov+[ ]+DTOC(LdFchRef) NOWAIT
	          LdUltCmp = FchDoc
	          LfTpoCmb = F_TpoCmb(FchDoc)
	          IF LfTpoCmb=-1
	             LfTpoCmb=1
	             m.Error =1
	          ENDIF
	          LfPreUni = IIF(FacTor>0,PreUni/Factor,PreUni)
	          IF EMPTY(PreUni) OR EMPTY(ImpCto)
	             m.Error = 2
	          ENDIF
	          IF CodMon=1
                  LfImpAlm1 = LfImpAlm1 + ROUND(LfPreUni*CanDes,2)
                  LfImpAlm2 = LfImpAlm2 + ROUND(LfPreUni/LfTpoCmb*CanDes,2)
              ELSE
                  LfImpAlm2 = LfImpAlm2 + ROUND(LfPreUni*CanDes,2)
                  LfImpAlm1 = LfImpAlm1 + ROUND(LfPreUni*LfTpoCmb*CanDes,2)
              ENDIF
              ** Compras
              IF DTRA.TpoRef=[O_C]
                 LfImpLin=0
	             SELE DO_C
    	         SEEK _CodMat+PADR(DTRA.NroRef,LEN(DO_C.NroOrd))
                 IF FOUND()
          	       xTCmb = F_TpoCmb(CO_C.FchOrd)
 			       IF xTCmb=-1
        	          xTCmb=1
			          m.Error =1
			       ENDIF
               	   LfImpLin = IIF(FacEqu>0,ImpLin/FacEqu,ImpLin)
               	   LfPreCmp = LfImpLin/CanPed
               	   IF CO_C.CodMon=1
                     LfImpCmp1 =LfImpCmp1+ROUND(LfPreCmp*DTRA.CanDes,2)  	
                     LfImpCmp2 =LfImpCmp2+ROUND(LfPreCmp/xTCmb*DTRA.CanDes,2)
               	   ELSE
	                 LfImpCmp2 =LfImpCmp2+ROUND(LfPreCmp*DTRA.CanDes,2)
	                 LfImpCmp1 =LfImpCmp1+ROUND(LfPreCmp*xTCmb*DTRA.CanDes,2)
               	   ENDIF
               	 ELSE
               	   SELE DTRA
                   DO O_C_Err
                 ENDIF
              ENDIF
              SELE DTRA
              LfCanDes = LfCanDes + CanDes
		   *ENDIF
            endscan
		ENDFOR
	    LdFchRef = LdFchRef -1 	
	ENDDO	
	WAIT WINDOW _CodMAt+[ ]+CATG.DesMat+[ ]+CATG.UndStk+[ Ultima Compra:]+TipMov+CodMov+[ ]+DTOC(LdFchRef)+[ OK.] NOWAIT
	SELE CATG
	CmpUPC1=[PS]+TRAN(_Mes,[@L ##])
	CmpUPC2=[PD]+TRAN(_Mes,[@L ##])
	REPLACE &CmpUpc1. WITH 0
	REPLACE &CmpUpc2. WITH 0
	IF LfCanDes#0
	    *IF LfImpCmp1>0 AND lOkeyCmp
 	    * 	REPLACE &CmpUpc1. WITH ROUND(LfImpCmp1/LfCanDes,4)
 	    *ELSE
 	    *	REPLACE &CmpUpc1. WITH ROUND(LfImpAlm1/LfCanDes,4)
 	    *ENDIF	
 	    **
 	    *IF LfImpCmp2>0 AND lOkeyCmp
	    *	REPLACE &CmpUpc2. WITH ROUND(LfImpCmp2/LfCanDes,4)
        *ELSE
	    *	REPLACE &CmpUpc2. WITH ROUND(LfImpAlm2/LfCanDes,4)
        *ENDIF			
        **
        if LfImpAlm1>0
           REPLACE &CmpUpc1. WITH ROUND(LfImpAlm1/LfCanDes,4)
        else
           IF LfImpCmp1>0 AND lOkeyCmp
 			  REPLACE &CmpUpc1. WITH ROUND(LfImpCmp1/LfCanDes,4)
           endif 		
 		endif
 		**
 		if LfImpAlm2>0
 		   REPLACE &CmpUpc2. WITH ROUND(LfImpAlm2/LfCanDes,4)
 		else
 		   IF LfImpCmp2>0 AND lOkeyCmp
			  REPLACE &CmpUpc2. WITH ROUND(LfImpCmp2/LfCanDes,4)
		   endif	
        ENDIF			
        **
	ENDIF
	UNLOCK
ENDSCAN
CLOSE DATA
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

*****************
procedure O_C_Err
*****************
xArea_Act=ALIAS()
SCATTER MEMVAR
SELE ERROR
APPEND BLANK
GATHER MEMVAR
lOkeyCmp = .F.
SELE (xArea_Act)
RETURN
*******************
PROCEDURE ACTPRXINS
*******************
DEFINE WINDOW WBIG FROM 8,10 TO 16,70 DOUBLE ;
       TITLE [Actualizar insumos por proveedor]

sele 0
use cmpmtxpr order mtpr02 alias mtpr
if !used()
   close data
   return
endif
sele 0
use cmptdist order dist01 alias dist
if !used()
   close data
   return
endif
sele 0
use almcatge order catg01 alias catg
if !used()
   close data
   return
endif
sele 0
use CBDMAUXI order AUXI01 alias AUXI
if !used()
   close data
   return
endif
**
XnRegPro=0
ACTIVATE WINDOW WBIG
@ 01,02 SAY [PROCESANDO:] COLOR n/w
SELE MTPR
SET FILTER TO CODFAM>=[4301]
COUNT TO m.TOTREG
go top
SCAN
     XnRegPro=XnRegPro +1
	 XFPORAVA=ROUND(XnRegPro/m.totreg*100,2)		
	 @ 01,02 SAY [PROCESANDO:]+TRAN(XFPORAVA,[999.99]) COLOR n/w
     IF !SEEK(GsClfPro+mtpr.codaux,[AUXI])			  					  	     		
         LOOP
     ENDIF
     SELE CATG
     SEEK MTPR.CodFam
     SCAN WHILE CodMat=MTPR.CodFam
          SELE DIST
          SEEK CATG.CODMAT+MTpr.COdAux
          IF  !FOUND()
              APPEND BLANK
          ENDIF
          DO WHILE !RLOCK()
          ENDDO
		  REPLACE CODMAT WITH CATG.CODMAT
		  REPLACE CODAUX WITH MTPR.CODAUX
		  REPLACE NOMAUX WITH AUXI.NOMAUX
		  @ 02,02 SAY [INSUMO....:]+CODMAT+[ ]+LEFT(catg.DESMAT,30) COLOR n/w
		  @ 03,02 SAY [PROVEEDOR.:]+CODAUX+[ ]+NOMAUX  COLOR n/w
		  UNLOCK
		  SELE CATG
     ENDSCAN
     sele MTPR
ENDSCAN
deactivate window wbig
close data
return
**
