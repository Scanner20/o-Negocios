*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý almpival.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý Almacenes e Inventarios                                     Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538 - 9411837              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Interface de valorizaci¢n de almacen                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 22/08/96                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Documentaci¢n Ý Captura las guias de un proveedor que todavia no han sido   Ý
*Ý               Ý valorizadas o que tienen items sin valorizar.               Ý
*Ý               Ý FlgFac ->'F' ... Gu¡a con todos sus items valorizados.      Ý
*Ý    x          Ý FlgFac ->'P' ... Guia con items pendientes de valorizar.    Ý
*+-----------------------------------------------------------------------------+
PARAMETER LsCodPro,LfTpoCmb,LnCodMon,LsTpoRfb,LsNroRfb,LsNomPro
IF EMPTY(LsCodPro)
   RETURN
ENDIF
** Variables que dan problemas
DO def_teclas IN fxgen_2

private ffjj
ffjj = 1

**
**--------------------***
m.bFiltro  = []
m.AreaOrig = ALIAS()
m.OrdenOrig= ORDER()
m.RegOrig  = RECNO()
***--------------------***
XnReg_Rmov=RECNO()
XnItem=0
*
DIMENSION fCodCta(1),fTpoO_C(1),fNroO_C(1),fnroreg(1)
*
DIMENSION vCdMDos(1),vGloItm(1),vImpCtb1(1),vImpCtb2(1)
STORE [] TO vCdMDos,vGloItm
STORE 0 TO vImpCtb1,vIMpCtb2
*
store [] to fCodCta,fTpoO_C,fNroO_C
store 0 to fnroreg
*
SEEK XsNroMes+XsCodOpe+XsNroAst
SCAN while NroMes+CodOpe+NroAst=XsNroMes+XsCodOpe+XsNroAst
     IF INLIST(RMOV.CodCta,[6040],[6041],[6050],[6060])
        XnItem=XnItem + 1
        IF ALEN(vCdMdos)<XnItem
           DIMENSION vCdMDos(ALEN(vCdMDos)+1)
           DIMENSION vGloItm(ALEN(vGloItm)+1)
           DIMENSION vIMpCtb1(ALEN(vImpCtb1)+1)
           DIMENSION vIMpCtb2(ALEN(vImpCtb2)+1)
           *
           dime fcodcta(alen(fcodcta)+1)
           dime ftpoo_c(alen(ftpoo_c)+1)
           dime fnroo_c(alen(fnroo_c)+1)
           dime fnroreg(alen(fnroreg)+1)
           *
        ENDIF
        =Seek(ClfAux+CodAux,[AUXI])
        vCdMDos(XnItem)=ClfAux+[ ]+CodAux+[ ]+LEFT(AUXI.NomAux,25)
        vGloItm(XnItem)=[  ]+GloDoc+[ ]
        IF LnCodMon=2
           vGloItm(XnItem)=vGloItm(XnItem) + [ US$]+TRAN(ImpUsa,[9999,999.99])
        ELSE
           vGloItm(XnItem)=vGloItm(XnItem) + [ S/.]+TRAN(Import,[9999,999.99])
        ENDIF
        vGloItm(XnItem)=vGloItm(XnItem) + [ O/C ] + nroo_c

        vImpCtb1(XnItem)=Import
        vImpCtb2(XnItem)=ImpUsa
        *
        fcodcta(xnitem)=codcta
        ftpoo_c(xnitem)=tpoo_c
        fnroo_c(xnitem)=nroo_c
        fnroreg(xnitem)=recn()
        *
     ENDIF
ENDSCAN
GO XnReg_Rmov
***
ArcTmp1=PATHUSER+SYS(3)
wait window [Creando Arch. #1 ] nowait
wait window [Creando Arch. #1 ] nowait
ArcTmp2=PATHUSER+SYS(3)
wait window [Creando Arch. #2 ] nowait
wait window [Creando Arch. #2 ] nowait
wait window [Creando Arch. #2 ] nowait
ArcTmp3=PATHUSER+SYS(3)
***
IF !ABRIRDBFS()
   DO F1MSGERR WITH [ERROR : en apertura de archivos de almacen]
   DO CIERDBFS
   RETURN
ENDIF
***
SAVE SCREEN
m.QueItm=1
m.CtrlWin=1
UltTecla =0
DO ALmsival.spr
DO CIERDBFS
DELE FILE (ArcTmp1)
DELE FILE (ArcTmp2)
DELE FILE (ArcTmp3)
*
WIN_ACT=WOUTPUT()
IF !EMPTY(WIN_ACT)
    DEACTIVATE WINDOW (WIN_ACT)
ENDIF
*
set library to
RESTORE SCREEN
RETURN
*******************
PROCEDURE Val_GUIAS
*******************
WIN_ACT=WOUTPUT()
IF !EMPTY(WIN_ACT)
    DEACTIVATE WINDOW (WIN_ACT)
ENDIF
PRIVATE LfImpCmp
XnLisGui = []

IF LnCodMon=1
   LfImpCmp = vImpCtb1(m.QueItm)
ELSE
   LfImpCmp = vImpCtb2(m.QueItm)
ENDIF
LsGloItm = vCdmDos(m.QueItm)
*** Variables que dan problemas
*IF TYPE([K_ESC])=[U]
*   PUBLIC k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,k_f_der,;
*          k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,k_f4,k_f5,k_f6,k_f7,;
*          k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,k_sf6,k_sf7,k_sf8,k_sf9,;
*          k_ctrlw,k_lookup,k_borrar,k_esc
*
*
*   STORE 0 TO k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,;
*              k_f_der,k_f_der,k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,;
*              k_f4,k_f5,k_f6,k_f7,k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,;
*              k_sf6,k_sf7,k_sf8,k_sf9,k_ctrlw,k_lookup,k_borrar,k_esc
*
*   do def_teclas in f0matriz
*ENDIF
*
*IF TYPE([C_LINEA])=[U]
*   STORE "" TO C_Fondo,C_Linea,C_Say,C_Get,C_Sayr
*   do def_color  in f0matriz
*ENDIF

*-------------------- Variables que controlan el color (adicional) ------------*
*m.BFiltro =[]
** Guardamos estado inicial **
sModulo = [ALMPIVAL]
**--------------------------**
m.Modulo = [INTVALM]
** Variables locales **
*ArcTmp1=PATHUSER+SYS(3)
*ArcTmp2=PATHUSER+SYS(3)
*ArcTmp3=PATHUSER+SYS(3)

set PROCEDURE TO almplibf.PRG

LcFlgFac = [ ] && Guia que tiene items Pendiente de valorizar

m.Salir  = 1
LsSubAlm = SPACE(LEN(GUIA.SubAlm))
LcTipMov = SPACE(LEN(GUIA.TipMov))
LsCodMov = SPACE(LEN(GUIA.CodMov))
LsNroDoc = SPACE(LEN(GUIA.NroDoc))
Sel_Parcial=.F.
** Capturamos las guias pendientes de facturar del proveedor **
WAIT WINDOW [Capturando guias sin valorizar] NOWAIT

LsCodPro = PADR(LsCodPro,LEN(CTRA.CodPro))
SELE CTRA
SET ORDER TO CTRA04
SET RELA TO TIPMOV+CODMOV INTO CFTR
SEEK LsCodPro
SCAN WHILE CodPro=LsCodPro
    if !(FlgEst#[A] AND CFTR.PidPco AND MONTH(FchDoc)=_MES)
       loop
    endif
    wait window [GUIA ]+Nrodoc NoWAIT

     LfImpBrt = 0
     lSinVal = .F.
     lItemVal= .F.
     lValTot = .t.
     LsLlave = SubAlm+TipMov+CodMov+NroDoc
     SELE DTRA
     SEEK LsLlave
     SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=LsLLave FOR !EMPTY(CodMat) AND CanDes>0
          IF (ABS(ImpCto/CanDes-PreUni)>.01 AND (Impcto>0 AND PreUni>0)) OR;
             (PreUni<=0 AND ImpCto<=0)
             lValTot=.F.
             lItemVal=.F.
             EXIT
          ELSE
             LItemVal=.T.
          ENDIF
          LfImpBrt = LfImpBrt + ImpNac
     ENDSCAN
     SELE CTRA
     DO WHILE !RLOCK()
     ENDDO
     DO CASE
        CASE lValTot
             REPLACE FlgFac WITH [F]
        CASE !lValTot
             REPLACE FlgFac WITH [P]
     ENDCASE
     UNLOCK
     IF FlgFac$[P ]
        SCATTER MEMVAR
        SELE GUIA
        APPEND BLANK
        GATHER MEMVAR
        REPLACE TpoRfb WITH LsTpoRfb
        REPLACE NroRfb WITH LsNroRfb
     ENDIF
     SELE CTRA
ENDSCAN
** Seleccionamos GUIAS a valorizar
SELE CTRA
SET RELA TO
SELE DTRA
SET ORDER TO DTRA01
SET RELA TO CODMAT INTO CATG
SELE GUIA
SET RELA TO SubAlm+TipMov+CodMov+NroDoc INTO DTRA
WAIT WINDOW [OK] NOWAIT
KEYBOARD CHR(K_F_DER)
DO AlmpIval.spr

IF m.Salir = 2
   UltTecla = K_ESC
ENDIF

IF UltTecla=K_Esc OR m.Salir=2
ELSE
   DO GrabItemVal
ENDIF
RELEASE WINDOW GUIAS_PROV,ITEMS_GUIA,VALORIZAR,ITEMS_DETA
SELE ITEM
ZAP
SELE TEMP
ZAP
SELE GUIA
ZAP
IF !EMPTY(WIN_ACT)
    ACTIVATE WINDOW (WIN_ACT)
ENDIF
RETURN
*******************
FUNCTION Brows_Guia
*******************
PARAMETER lMostrar
PRIVATE m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
sModulo = [INTFVGUIA]
**m.Venpadre = [intf_valor]
m.Area   = [GUIA]
m.bTitulo = [GUIAS_PROV]
m.bDeta   = [GUIAS_PROV]
m.bClave1 = LsCodPro
m.bClave2 = LsCodPro
m.bFiltro = [INLIST(GUIA.FlgFac,' ','P')]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= [Buscar]
m.prgPrep = []
m.prgPost = []

nX0 = 04
nY0 = 01
nX1 = 10
nY1 = 60

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ENDIF
*
m.lStatic = .T.
*nCmpLock  = 3
*
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
*******************
FUNCTION Brows_Item
*******************
PARAMETER lMostrar
PRIVATE m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
m.Area   = [ITEM]
sModulo  = [INTFVITEM]
**m.Venpadre = [intf_valor]
m.bTitulo = [ITEMS_GUIA]
m.bDeta   = [ITEMS_GUIA]
m.bClave1 = LsSubAlm+LcTipMov+LsCodMov+LsNroDoc
m.bClave2 = LsSubAlm+LcTipMov+LsCodMov+LsNroDoc
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []

nX0 = 13
nY0 = 01
nX1 = 19
nY1 = 79

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ENDIF
*
m.lStatic = .F.
*nCmpLock  = 3
*
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
*******************
FUNCTION Brows_Deta
*******************
PARAMETER lMostrar
PRIVATE m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
m.Area   = [DTRA]
sModulo  = [INTFVDTRA]
**m.Venpadre = [intf_valor]
m.bTitulo = [ITEMS_DETA]
m.bDeta   = [ITEMS_DETA]
m.bClave1 = GUIA.SubAlm+GUIA.TipMov+GUIA.CodMov+GUIA.NroDoc
m.bClave2 = GUIA.SubAlm+GUIA.TipMov+GUIA.CodMov+GUIA.NroDoc
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []

nX0 = 13
nY0 = 01
nX1 = 19
nY1 = 79

IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ENDIF
*
m.lStatic = .F.
*nCmpLock  = 3
*
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
*******************
FUNCTION Brows_Temp
*******************
PARAMETER lMostrar
PRIVATE m.bTitulo,m.bDeta,m.bClave1,m.bClave2,m.bFiltro,m.bCampos
PRIVATE m.bBorde,m.Area_sel,m.PrgBusca,m.PrgPrep,m.PrgPost,nX0,nY0,nX1,nY1
PRIVATE m.lModi_Reg,m.lAdic_Reg,m.lBorr_Reg,m.lStatic
sModulo  = [INTFVTEMP]
**m.Venpadre = [intf_valor]
m.Area   = [TEMP]
m.bTitulo = [VALORIZAR]
m.bDeta   = [VALORIZAR]
m.bClave1 = []
m.bClave2 = []
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= [Buscar]
m.prgPrep = []
m.prgPost = []
nX0 = 13
nY0 = 01
nX1 = 19
nY1 = 79
RELEASE WINDOW ITEMS_DETA
IF lMostrar
   lModi_Reg = .F.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ELSE
   lModi_Reg = .T.
   lAdic_Reg = .F.
   lBorr_Reg = .F.
ENDIF
*
m.lStatic = .T.
*nCmpLock  = 3
*
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
********************
PROCEDURE ProItemSel
********************
SELE TEMP
ZAP
SELE GUIA
SET RELA TO
SELE DTRA
SET RELA TO
SET ORDER TO DTRA01
SELE GUIA
GO TOP
SCAN FOR SelGui=[*]
     LsLlave = SubAlm+TipMov+CodMov+NroDoc
     SELE DTRA
     SEEK LsLlave
     SCAN WHILE SubALm+TipMov+CodMov+NroDoc=LsLlave
          SCATTER MEMVAR
        **zLLave = SubAlm+TipMov+CodMov+NroDoc+GUIA.TpoRfb+GUIA.NroRfb+CodMat
          zLLave = SubAlm+TipMov+CodMov+GUIA.TpoRfb+GUIA.NroRfb+CodMat
          ZsNroDoc = NroDoc
          =SEEK(CodMat,[CATG])
          SELE TEMP
          SEEK zLlave
          IF !FOUND()
             APPEND BLANK
             GATHER MEMVAR
             REPLACE TpoRfB WITH GUIA.TpoRfb
             REPLACE NroRfB WITH GUIA.NroRfb
             REPLACE DesMat WITH CATG.DesMat
          ELSE
             REPLACE CanDes WITH CanDes + DTRA.CanDes
            *REPLACE CanO_C WITH CanO_C + DTRA.CanDes
          ENDIF
          **STORE 0 TO LfImpCmp1,LfImpCmp2,LfPreCmp
          **DO CapValO_C
          **LfImpCto = IIF(LnCodMon=1,vImpCtb1(m.QueItm),vImpCtb2(m.QueItm))
          **REPLACE ImpCto WITH LfImpCto
          **REPLACE PreUni WITH IIF(CanDes=0,0,ROUND(ImpCto/CanDes,4))
          **IF PunO_C<=00
          **   REPLACE PUnO_C WITH ROUND(PreUni,4)
          **ENDIF
          REPLACE N_Guias WITH ZsNrodoc+[,] ADDITIVE
          SELE DTRA
     ENDSCAN
     SELE GUIA
ENDSCAN
*
* GRABA PRECIOS DE O/C GENERADAS PARA VALORIZAR FACTURA
do pre_alm
*
SELE ITEM
GO TOP
SCAN FOR SelItm=[*]
   SCATTER MEMVAR
 **zLLave = SubAlm+TipMov+CodMov+NroDoc+TpoRfb+NroRfb+CodMat
   zLLave = SubAlm+TipMov+CodMov+TpoRfb+NroRfb+CodMat
   =SEEK(CodMat,[CATG])
   ZsNroDoc = NroDoc
   SELE TEMP
   SEEK zLlave
   IF !FOUND()
      APPEND BLANK
      GATHER MEMVAR
      REPLACE TpoRfb WITH ITEM.TpoRfb
      REPLACE NroRfb WITH ITEM.NroRfb
      REPLACE DesMat WITH CATG.DesMat
   ELSE
      REPLACE CanDes WITH CanDes + ITEM.CanDes
      REPLACE CanO_C WITH CanO_C + ITEM.CanDes
   ENDIF
   STORE 0 TO LfImpCmp1,LfImpCmp2,LfPreCmp
   **DO CapValO_C
   LfImpCto = IIF(LnCodMon=1,vImpCtb1(m.QueItm),vImpCtb2(m.QueItm))
   REPLACE ImpCto WITH ImpCto + LfImpCto
   REPLACE PreUni WITH IIF(CanDes=0,0,ROUND(ImpCto/CanDes,4))
   IF PunO_C<=00
      REPLACE PUnO_C WITH ROUND(PreUni,4)
   ENDIF
   REPLACE N_Guias WITH ZsNrodoc+[,] ADDITIVE
   SELE ITEM
ENDSCAN
SELE GUIA
SET RELA TO SUBALM+TIPMOV+CODMOV+NRODOC INTO DTRA
SELE DTRA
SET RELA TO CODMAT INTO CATG
*
show get m.fImpBrt
show get m.fImpCmp
*
RETURN
*******************
PROCEDURE CapValO_C
*******************
xArea_act=ALIAS()
_CodMat=CodMat
_CanDes=CanDes
IF TpoRef=[O_C]
   LfImpLin=0
   SELE DO_C
   SEEK _CodMat+PADR(Nroref,LEN(DO_C.NroOrd))
   IF FOUND()
      xTCmb = wTpoCmb(CO_C.FchOrd)
      IF xTCmb=-1
         xTCmb=1
         m.Error =1
      ENDIF
      LfImpLin = IIF(FacEqu>0,ImpLin/FacEqu,ImpLin)
      LfPreCmp = LfImpLin/CanPed
      IF CO_C.CodMon=1
         LfImpCmp1 =LfImpCmp1+ROUND(LfPreCmp*_CanDes,2)  	
         LfImpCmp2 =LfImpCmp2+ROUND(LfPreCmp/xTCmb*_CanDes,2)
      ELSE
         LfImpCmp2 =LfImpCmp2+ROUND(LfPreCmp*_CanDes,2)
         LfImpCmp1 =LfImpCmp1+ROUND(LfPreCmp*xTCmb*_CanDes,2)
      ENDIF
   ENDIF
ENDIF
SELE (xArea_Act)
RETURN
*********************
PROCEDURE GrabItemVal
*********************
WAIT WINDOW [Valorizando gu¡as] NOWAIT
private crear,m.lModPre,m.lModCsm,m.lPidPco,LcFlgFac,LsNroDoc
SET MEMOWIDTH TO 80
SELE GUIA
SET RELA TO
SELE DTRA
SET RELA TO
SET ORDER TO DTRA05
SELE TEMP
SET ORDER TO TEMP02
GO TOP
IF EOF()
   RETURN
ENDIF
*
XnLisGui = []
*
DO WHILE !EOF()
   LsLlave = TpoRfb+NroRfb
   SCAN WHILE TpoRfb+NroRfb=LsLLave
       *_MLINE = 0
       *STORE MEMLINES(N_Guias) TO NumLin
       *FOR K = 1 TO NumLin
           *LsN_Guias = MLINE(N_Guias,1,_MLINE)
            LsN_Guias = N_Guias
            NumGui = 0
            DO WHILE .T.
               IF EMPTY(LsN_Guias)
                  EXIT
               ENDIF
               Z = AT(",",LsN_Guias)
               IF Z = 0
                  Z = LEN(LsN_Guias) + 1
               ENDIF
               LsNroDoc = PADC(LEFT(LsN_Guias,Z-1),LEN(DTRA.NroDoc))
               IF Z > LEN(LsN_Guias)
                  EXIT
               ENDIF
               LsN_Guias = SUBSTR(LsN_Guias,Z+1)
               **
               If AT((SubAlm+[-]+LsNroDoc),XnLisGui) = 0
                  XnLisGui=XnLisGui+(SubAlm+[-]+LsNroDoc+[,])
               endif
               **
               zLLave = SubAlm+TipMov+CodMov+CodMat+LsNroDoc
               SELE DTRA
               SEEK zLlave
               SCAN WHILE SubAlm+TipMov+CodMov+CodMat+NroDoc=zLlave
                    =SEEK(TipMov+CodMov,[CFTR])
                    Crear = .F.
                    m.lModPre = CFTR->ModPre
                    m.lPidPco = CFTR->PidPco
                    m.lModCsm = CFTR->ModCsm
                    m.lMonElg = CFTR->MonElg
                    m.lMonUsa = CFTR->MonUsa
                    m.lMonNac = CFTR->MonNac
                    IF m.lMonElg
                       TnCodMon = LnCodMon
                    ELSE
                       IF m.lMonNac
                          TnCodMon = 1
                       ELSE
                          TnCodMon = 2
                       ENDIF
                    ENDIF
                    DO WHILE !RLOCK()
                    ENDDO
                    REPLACE TpoRfb WITH TEMP.TpoRfb
                    REPLACE NroRfb WITH TEMP.NroRfb
                    *
                    repla codope with xscodope
                    repla nroast with xsnroast
                    repla anoast with ltrim(str(_ano))
                    *
                    IF CanDes=0
                       REPLACE PreUni WITH TEMP.PreUni
                    ELSE
                       IF TnCodMon=LnCodMon
                       REPLACE PreUni WITH ROUND(TEMP.PreUni,4)
                    ELSE
                       IF LnCodMon=2
                          LfPreCto=ROUND(TEMP.PreUni*LfTpoCmb,4)
                          REPLACE PreUni WITH LfPreCto
                       ELSE
                          IF LfTpoCmb>0
                             LfPreCto=ROUND(TEMP.PreUni/LfTpoCmb,4)
                          ELSE
                             LfPreCto=0
                          ENDIF
                          REPLACE PreUni WITH LfPreCto
                       ENDIF
                    ENDIF
                    ENDIF
                    IF CanDes=0 AND m.lModPre
                       REPLACE ImpCto WITH ROUND(PreUni,2)
                    ELSE
                       REPLACE ImpCto WITH ROUND(PreUni*CanDes,2)
                    ENDIF
                    REPLA TpoCmb WITH LfTpoCmb
                    REPLA CodMon WITH TnCodMon
                    REPLA CodAjt WITH IIF(CFTR.PidPco,[A],[ ])
                    DO Almpcsm1
                    UNLOCK
                    **
                    REPLA TEMP.CtoAlm WITH TEMP.CtoAlm + DTRA.ImpCto
                    REPLA TEMP.CanAlm WITH TEMP.CanAlm + DTRA.CanDes
               ENDSCAN
               SELE TEMP
            ENDDO
       *ENDFOR
        SELE TEMP
        IF CanAlm<>0
           REPLACE PunAlm WITH ROUND(CtoAlm/CanAlm,4)
        ELSE
           REPLACE PunAlm WITH 0
        ENDIF
   ENDSCAN
   SELE TEMP
ENDDO
SELE DTRA
SET ORDER TO DTRA01
** Actualizamos estado de las guias **
SELE CTRA
SET ORDER TO CTRA01
SELE GUIA
GO TOP
SCAN FOR SelGui=[*] OR SelItm=[*]
     LfImpBrt = 0
     LItemVal = .F.
     lValTot  = .T.
     LsLlave = SubAlm+TipMov+CodMov+NroDoc
     SELE DTRA
     SEEK LsLlave
     SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=LsLLave
          IF ABS(CanDes*PreUni-ImpCto)>.01
             lValTot=.F.
             lItemVal=.F.
             EXIT
          ELSE
             LItemVal=.T.
          ENDIF
          IF EMPTY(PreUni) OR EMPTY(ImpCto)
             lItemVal= .F.
             lValTot = .F.
             EXIT
          ENDIF
          LfImpBrt = LfImpBrt + ImpNac
     ENDSCAN
     SELE CTRA
     SEEK LsLLave
     IF FOUND()
        DO WHILE !RLOCK()
        ENDDO
        DO CASE
           CASE !lValTot
                REPLACE FlgFac WITH [P]
           CASE lValTot
                REPLACE FlgFac WITH [F]
        ENDCASE
        REPLACE ImpBrt WITH LfImpBrt

        UNLOCK
     ENDIF
     SELE GUIA
ENDSCAN
ffjj = 1
DO pImp_Liq
RETURN
*****************
FUNCTION pImp_Liq
*****************
PRIVATE xAlias,xOrder
xAlias = ALIAS()
xOrder = ORDER()
*
if ffjj = 0
   SET LIBRARY TO
   SELE CFTR
   USE
   SELE CATG
   USE
   SELE CALM
   USE
endif
*
SELE CTRA
SET ORDER TO CTRA01
SELE DTRA
SET ORDER TO DTRA04
SELE TEMP
SET ORDER TO TEMP02
GO TOP
**SET RELA TO SubAlm+TipMov+CodMov+CodMat+NroDoc INTO DTRA
LfCanAlm=0
LfPunAlm=0
LfCtoAlm=0
**---------- Impresi¢n ---------**
xFOR   = []
xWHILE = []
Largo  = 33       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4]
sNomRep = "almpival"
DO F0print WITH "REPORTS"
SELE TEMP
SET RELA TO
SELE DTRA
SET ORDER TO DTRA01
SELE (xAlias)
SET ORDER TO (xOrder)
RETURN
****************
FUNCTION _ValAlm
****************
SELE DTRA
xLlave = TEMP.TpoRfb+TEMP.NroRfb+TEMP.CodMat+TEMP.SubAlm
LfCanAlm=0
LfPunAlm=0
LfCtoAlm=0
SEEK xLlave
SCAN WHILE TpoRfb+NroRfb+CodMat+SubAlm=xLlave
     LfCanAlm = LfCanAlm + CanDes
     LfCtoAlm = LfCtoAlm + ImpCto
ENDSCAN
SELE TEMP
RETURN
*******************
PROCEDURE ABRIRDBFS
*******************
WAIT WINDOW [Abriendo archivos de almacen] NOWAIT
** Cerramos archivos no necesarios en este proceso **
IF USED([ACCT])
   SELE ACCT
   USE
ENDIF
IF USED([PROV])
   SELE PROV
   USE
ENDIF
IF USED([DPRO])
   SELE DPRO
   USE
ENDIF
IF USED([OPER])
   SELE OPER
   USE
ENDIF
**---------------------**
rutaCia=[\aplica\cia]+GsCodCia+[\]
rutaAno=[\aplica\cia]+GsCodCia+"\C"+LTRIM(STR(_ANO))+[\]
IF !USED([DO_C])
   SELE 0
   USE &RutaANO.CMPDO_CG ORDER DO_C05 ALIAS DO_C
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
IF !USED([CO_C])
   SELE 0
   USE &RutaANO.CMPCO_CG ORDER CO_C01 ALIAS CO_C
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
***
if !used([unid])
   sele 0
   use &rutacia.almequni order equn01 alias unid
   if !used()
      close data
      return
   endif
endif
***
IF !USED([AUXI])
   SELE 0
   USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([CTRA])
   SELE 0
   USE &RutaAno.ALMCTRAN ORDER CTRA01 ALIAS CTRA
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([DTRA])
   SELE 0
   USE &RutaAno.ALMDTRAN ORDER DTRA01 ALIAS DTRA
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([CFTR])
   SELE 0
   USE &RutaAno.ALMCFTRA ORDER CFTR01 ALIAS CFTR
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([CATG])
   SELE 0
   USE &RutaAno.ALMCATGE ORDER CATG01 ALIAS CATG
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([CALM])
   SELE 0
   USE &RutaAno.ALMCATAL ORDER CATA01 ALIAS CALM
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
*
SELE 0
CREATE TABLE (Arctmp1) (NroDoc C(10) ,NroRf1 C(10), NroRf2 C(10),;
           TipMov C(1)   ,CodMov C(3)   ,SubAlm C(3) ,CodPro C(6),;
           SelGui C(1)   ,SelItm C(1)   ,DesMat C(40),;
           TpoRef C(4)   ,NroRef C(10)  ,CodMat C(8),CanDes N(14,4),;
           TpoRfb C(4)   ,NroRfb C(10)  ,CodMon N(1),;
           PunO_C N(14,4),CanO_C N(14,4),NroO_C C(8),N_Guias M, ;
           PunAlm N(14,4),CanAlm N(14,4),CtoAlm N(14,2), ;
           PreUni N(18,8),ImpCto N(14,4),FchDoc D(8),;
           MonO_C N(1)   ,MonAst N(1),;
           PreAst N(18,8),ImpPro N(14,4),FlgFac C(1))

USE (ArcTmp1) EXCL ALIAS GUIA
IF !USED()
   RETURN .F.
ENDIF
INDEX ON CodPro+NroDoc+FlgFac TAG GUIA01
SET ORDER TO GUIA01

COPY STRU TO (ArcTmp2)
COPY STRU TO (ArcTmp3)
SELE 0
USE (ArcTmp2) EXCL ALIAS ITEM
IF !USED()
   RETURN .F.
ENDIF
INDEX ON SubAlm+TipMov+CodMov+Nrodoc+CodMat TAG ITEM01
SET ORDER TO ITEM01
SELE 0
USE (ArcTmp3) EXCL ALIAS TEMP
IF !USED()
   RETURN .F.
ENDIF
INDEX ON SubAlm+TipMov+CodMov+TpoRfb+NroRfb+CodMat TAG TEMP01
INDEX ON TpoRfb+NroRfb+CodMat+SubAlm+TipMov+CodMov+NroDoc TAG TEMP02
INDEX ON TpoRfb+NroRfb+TpoRef+NroRef+CodMat TAG TEMP03
SET ORDER TO TEMP01
SELE DO_C
SET RELA TO NroOrd INTO CO_C
WAIT WINDOW [OK] NOWAIT
RETURN .T.
******************
PROCEDURE CIERDBFS
******************
IF USED([CTRA])
   SELE CTRA
   USE
ENDIF
IF USED([GUIA])
   SELE GUIA
   USE
ENDIF
IF USED([ITEM])
   SELE ITEM
   USE
ENDIF
IF USED([TEMP])
   SELE TEMP
   USE
ENDIF
IF USED([DTRA])
   SELE DTRA
   USE
ENDIF
IF USED([CFTR])
   SELE CFTR
   USE
ENDIF
IF FILE([CJATPROV.DBF])
   IF !USED([PROV])
      SELE 0
      USE CJATPROV ORDER PROV02 ALIAS PROV
      IF !USED()
         RETURN .F.
      ENDIF
   ENDIF
ENDIF
IF FILE([CJADPROV.DBF])
   IF !USED([DPRO])
      SELE 0
      USE CJADPROV ORDER DPRO06 ALIAS DPRO
      IF !USED()
         RETURN .F.
      ENDIF
   ENDIF
ENDIF
IF !USED([ACCT])
   SELE 0
   USE CBDACMCT ORDER ACCT01 ALIAS ACCT
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF
IF !USED([OPER])
   SELE 0
   USE CBDTOPER ORDER OPER01 ALIAS OPER
   IF !USED()
      RETURN .F.
   ENDIF
ENDIF

SELE (m.AreaOrig)
SET ORDER TO (m.OrdenOrig)
IF m.RegOrig>0
   GO m.RegOrig
ENDIF
RETURN
****************
FUNCTION vPreUni    && PreUni VALID
****************
GsMsgErr = "Registre el Precio"
SCATTER MEMVAR
lValido = (m.PreUni > 0)
IF lValido
   IF m.CanDes = 0
      m.ImpCto = m.PreUni
   ELSE
      m.ImpCto = ROUND(m.CanDes * m.PreUni, 2)
   ENDIF
   GATHER MEMVAR FIELD PreUni,ImpCto
   zLlave = TpoRfb+NroRfb
   m.Reg_Act = RECNO()
   m.fImpBrt = 0
   SCAN
     *IF TpoRef+NroRef=zLLave AND m.Reg_Act<>RECNO()
     *   REPLACE PreUni WITH m.PreUni
     *   REPLACE ImpCto WITH ROUND(m.PreUni*CanDes,2)
     *ENDIF
      m.fImpBrt = m.fImpBrt + ImpCto
   ENDSCAN
   GO m.Reg_Act
** m.fImpIgv = ROUND(m.fImpBrt*m.fPorIgv/100,3)
** m.fImpTot = m.fImpBrt + m.fImpIgv
   SHOW GET m.fImpBrt
** @ 19,51 SAY m.fImpIgv PICTURE "999,999,999.999"
** @ 20,51 SAY m.fImpTot PICTURE "999,999,999.999"
ENDIF
RETURN lValido
****************
FUNCTION wImpCto    && ImpCto WHEN
****************
*SCATTER MEMVAR
*IF m.CanDes<>CanDesA OR m.PreUni<>PreUniA
*   IF m.CanDes = 0
*      m.ImpCto = m.PreUni
*   ELSE
*      m.ImpCto = ROUND(m.CanDes * m.PreUni, 2)
*   ENDIF
*   GATHER MEMVAR FIELD ImpCto
*ENDIF
RETURN .T.

****************
FUNCTION vImpCto   && ImpCto VALID
****************
SCATTER MEMVAR
IF m.CanDes > 0
   m.PreUni = ROUND(m.ImpCto/m.CanDes,5)
ELSE
   m.PreUni = m.ImpCto
ENDIF
lValido = .T.
IF m.ImpCto <= 0
   GsMsgErr = "Registre el Precio"
   lValido = .F.
ENDIF

IF lValido &&&AND (m.CanDes<>CanDesA OR m.PreUni<>PreUniA) &&OR m.ImpCto<>ImpCtoA)
   GATHER MEMVAR FIELD ImpCto,PreUni
   zLlave = TpoRfb+NroRfb
   m.Reg_Act = RECNO()
   m.fImpBrt = 0
   SCAN
     *IF TpoRef+NroRef=zLLave AND m.Reg_Act<>RECNO()
     *   REPLACE PreUni WITH m.PreUni
     *   REPLACE ImpCto WITH ROUND(m.PreUni*CanDes,2)
     *ENDIF
      m.fImpBrt = m.fImpBrt + ImpCto
   ENDSCAN
   GO m.Reg_Act

** m.fImpIgv = ROUND(m.fImpBrt*m.fPorIgv/100,3)
** m.fImpTot = m.fImpBrt + m.fImpIgv
   SHOW GET m.fImpBrt
** @ 19,51 SAY m.fImpIgv PICTURE "999,999,999.999"
** @ 20,51 SAY m.fImpTot PICTURE "999,999,999.999"
ENDIF
RETURN lValido
****************
FUNCTION vNroRef
****************
RETURN .T.
****************
FUNCTION vSelGui
****************
RETURN SELGUI$[* ]
****************
FUNCTION vSelItm
****************
DO CASE
   CASE sModulo = [INTFVGUIA]
        Sel_Parcial=(SELITM=[*])
        IF SelItm=[*]
           LsSubAlm=GUIA.SubAlm
           LcTipMov=GUIA.TipMov
           LsCodMov=GUIA.CodMov
           LsNroDoc=GUIA.NroDoc
           xll=LsSubAlm+LcTipMov+LsCodMov+LsNroDoc
           SELE DTRA
           SEEK xll
           SCAN WHILE SubAlm+TipMov+CodMov+LsNroDoc=xll
                zll=LsSubAlm+LcTipMov+LsCodMov+LsNroDoc
                SCATTER MEMVAR
                SELE ITEM
                SEEK zll
                IF !FOUND()
                   APPEND BLANK
                ENDIF
                GATHER MEMVAR
                SELE DTRA
           ENDSCAN
           SELE ITEM
           DO BROWS_ITEM WITH .F.
           SELE GUIA
        ENDIF
ENDCASE
RETURN SELITM$[* ]
***************
FUNCTION _VALOR
***************
M.STAT=[]
DO CASE
   CASE FLGFAC=[F]
        M.STAT=[TOTAL]
   CASE FLGFAC=[P]
        M.STAT=[PARCIAL]
   CASE FLGFAC=[ ]
        M.STAT=[FALTA  ]
   OTHER
        M.STAT=[       ]
ENDCASE

RETURN M.STAT
****************
FUNCTION wtpocmb
****************
PARAMETER _Fch
AREA_ACT=ALIAS()
_TpoCmb=-1
SELE TCMB
SEEK DTOS(_fch)
IF FOUND()
   IF Tcmb.OfiVta<=0
      DO WHILE !BOF()
         IF !BOF()
            SKIP -1
         ENDIF
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

* MORE INFORMATION
* ================
*
* This example is designed to get fields from a parent file and browse fields
* from a child file. To use this example for a single database, remove all
* lines of code referring to the child database. The steps below create a
* total of three windows:
*
*  - The first window, WBIG, is a large window with a border that acts as a
*    visual frame around the GET screen and the Browse window.
*
*  - The second window, WGETS, contains the GET and SAY fields for the data
*    entry window. It does not have a border.
*
*  - The third window, WBROWSE, contains the browse information.
*
* NOTE: The actual screen coordinates of the windows matter only insofar as
* WGETS and WBROWSE are contained within WBIG.
*
* To create these windows, do the following:
*
* 1. Use the Screen Builder to create a screen.
*
* 2. From the Screen menu, choose Screen Layout and type "WGETS"(without the
*    quotation marks) as the screen name.
*
* 3. Use the following snippet as the screen's Setup code:
*
*       SELECT 0
*          USE parent
*
*      * Remove next 4 lines for a single database example
*       SELECT 0
*          USE child
*       SELECT parent
*          SET RELATION TO keyfield INTO child
*      ****************************************************
*
*       DEFINE WINDOW wbig FROM 1,1 TO 22,80 DOUBLE
*       DEFINE WINDOW wgets FROM 0,5 TO 8,75;
*          IN WINDOW wbig NONE
*       DEFINE WINDOW wbrowse FROM 9,0 TO 20,80;
*          IN WINDOW wbig NONE
*
*       ACTIVATE WINDOW wbig
*
*       **********************************************
*       * To have the browse window come up as the active
*       * window, place the next three lines in the
*       * READ WHEN code snippet and remove the NOWAIT
*       * clause from the BROWSE statement
*       ***********************************************
*
*       SELECT child
*       ACTIVATE WINDOW wbrowse
*       BROWSE IN WINDOW wbrowse SAVE NOWAIT
*       *****************************************
*
*       SELECT parent
*       ACTIVATE WINDOW wgets
*
* 4. Use the following snippet as the screen's Cleanup code:
*
*       RELEASE WINDOW wbig, wbrowse
*
* 5. Define some fields in the screen. Because the WGETS window has been
*    defined as eight lines high, these fields should be located in the first
*    eight rows of the screen. If fields are defined beyond this point, a
*    "Position off screen" error will be generated when the .SPR program is
*    run.
*
* 6. When you are generating the screen, make sure that the Define Windows
*    check box in the generator options is not selected. In FoxPro for MS-
*    DOS, this check box is located on the right side of the Generate dialog
*    box under Code Options. In FoxPro for Windows, this check box is
*    displayed when you choose the More button in the Generate dialog box.
*
* Switching Between the Screens
* -----------------------------
*
* Two keyboard methods can be used to switch between the Browse window and
* the GET screen:
*
*  - CTRL+F1 can be used to cycle through any open windows. To use this
*    keyboard shortcut, the FoxPro System menu, or a menu using the system
*    menu bar _MWI_ROTAT with a shortcut key of CTRL+F1, must be currently
*    defined in memory. The menu must be accessible by setting SYSMENU to ON
*    or AUTOMATIC. If other windows are currently open, pressing CTRL+F1 may
*    cycle through these unrelated windows.
*
*     -or-
*
*  - An ON KEY LABEL command can be defined to switch between the two
*    windows. To do so, add the following code to the following code
*    snippets:
*
*     - In the Setup code, add the following code as the first two lines of
*       code:
*
*          SET SYSMENU ON               && Enables CTRL+F1 to switch
*          ON KEY LABEL f2 DO switchwin && Enables F2 to switch
*
*     - In the Cleanup code, add the following code as the last lines of
*       code:
*
*          PROCEDURE switchwin
*          IF WONTOP('wgets')
*             SELECT parent
*             ACTIVATE WINDOW wbrowse
*          ELSE
*             SELECT child
*             ACTIVATE WINDOW wgets
*          ENDIF
*
* In this example, the F2 key is used to switch between windows using the
* procedure SWITCHWIN. This procedure determines which window is currently
* the active output window and activates the other window. This method does
* not require access to the menu bar, and will cycle only between the GET
* screen and the Browse window.
*
* Additional reference words: 2.00 2.50 2.50a one read GETS

*******************
PROCEDURE IMP_GUIAS
*******************
dimension jTpoO_C(XnItem), jNroO_C(XnItem)
XnLisGui = []
ffss = 0
sele temp
set order to temp03
sele dtra
set order to dtra08
lsllave = xscodope+xsnroast+ltrim(str(_ano))+lstporfb+lsnrorfb
seek lsllave
if !found()
   return
endif
*
for m.queitm=1 to XnItem
    lljj = 0
    ysllave=lsllave+ftpoo_c(m.queitm)+fnroo_c(m.queitm)
    *
    if ffss <> 0  &&& Para Verificar que No se Repitan O/C
       for m.queo_c=1 to ffss
           if jtpoo_c(m.queo_c)+jnroo_c(m.queo_c)=ftpoo_c(m.queitm)+fnroo_c(m.queitm)
              lljj = 1
              exit for
           endif
       endfor
    endif
    *
    if lljj = 0
       ffss = ffss + 1
       jtpoo_c(ffss)=ftpoo_c(m.queitm)
       jnroo_c(ffss)=fnroo_c(m.queitm)
       *
       sele dtra
       seek ysllave
       scan while codope+nroast+anoast+tporfb+nrorfb+tporef+nroref=ysllave
            xbnrodoc = nrodoc      
            xbsubalm = subalm
            *
            scatter memvar
            =seek(codmat,[catg])
            xsundstk = catg.undstk
            xsfacequ = 1
            *
            sele temp
            seek dtra.tporfb+dtra.nrorfb+dtra.tporef+dtra.nroref+dtra.codmat
            if .not. found()
               xnpreo_c = 0
               xnmono_c = lncodmon
               sele do_c
               seek dtra.codmat+padr(dtra.nroref,len(do_c.nroord))
               if found()
                  xnpreo_c = (((100-pordto)/100)*iif(left(nroord,1)=[I],prefob,preuni))
                  if xsundstk <> do_c.undcmp    &&& Verifica Unidad de Medida
                     sele unid
                     seek (xsundstk+do_c.undcmp)
                     if found()
                        xsfacequ = unid.facequ
                     endif
                     sele do_c
                  endif
                  xnpreo_c = round(xnpreo_c/xsfacequ,4)
                  *
                  =seek(padr(dtra.nroref,len(do_c.nroord)),[co_c])
                  xnmono_c = co_c.codmon
                  *
                  * PRECIO DEACUERDO A LA MONEDA DEL ASIENTO
                  *
                  if lncodmon <> xnmono_c
                     if xnmono_c = 1
                        if lftpocmb>0
                           xnpreo_c=round(xnpreo_c/lftpocmb,4)
                        else
                           xnpreo_c=0
                        endif
                     else
                        xnpreo_c=round(xnpreo_c*lftpocmb,4)
                     endif
                  endif
                  *
               endif
               *
               sele temp
               append blank
               do while !rlock()
               enddo
               gather memvar
               repla desmat with catg.desmat
               repla monast with lncodmon
               if monast = 1
                  repla preuni with dtra.preuni
               else
                  repla preuni with iif(lftpocmb>0,round(dtra.preuni/lftpocmb,4),0)
               endif
               *
               repla mono_c with xnmono_c
               repla cano_c with dtra.candes
               repla puno_c with xnpreo_c
               *
               repla impcto with round(candes*preuni,2)
               *
               repla canalm with dtra.candes
               repla punalm with dtra.preuni
               repla ctoalm with round(canalm*punalm,2)
            else
               do while !rlock()
               enddo
               repla candes with candes + dtra.candes
               repla impcto with impcto + round(dtra.candes*preuni,2)
               *
               repla cano_c with cano_c + dtra.candes
               *
               repla canalm with canalm + dtra.candes
               repla ctoalm with ctoalm + round(dtra.candes*punalm,2)
            endif
            unlock
            *
            If AT((XbSubAlm+[-]+XbNroDoc),XnLisGui) = 0
               XnLisGui = XnLisGui + (XbSubAlm+[-]+XbNroDoc+[,])
            endif
            *
       endscan
    endif
endfor
*
do pImp_Liq
sele temp
zap
return
*****************
PROCEDURE PRE_ALM
*****************
sele temp
go top
store 0 to m.fImpCmp, m.fImpBrt
scan FOR !EMPTY(CodMat)
     do while !rlock()
     enddo
     repla mono_c with lncodmon
     repla monast with lncodmon
     unlock
     *
     if tporef = [O_C]
        xnimppro = 0
        for i = 1 to xnitem
            if alltrim(fnroo_c(i)) = alltrim(nroref)
               xnimppro = xnimppro + iif(lncodmon=1,vimpctb1(i),vimpctb2(i))
            endif
        endfor
        *
        do while !rlock()
        enddo
        repla imppro with xnimppro
        IF CanDes<>0
	        xnprefac = round(imppro/candes,4)
        ELSE
        	XnPreFac = 0
        ENDIF
        repla preuni with xnprefac     &&& CONTABLE
        repla impcto with round(preuni*candes,2)
        unlock
        *
        m.fImpBrt = m.fImpBrt + ImpCto
        m.fImpCmp = m.fImpCmp + ImpPro
        *
        =seek(temp.codmat,[catg])
        xsundstk = catg.undstk
        xsfacequ = 1
        *
        sele do_c
        seek temp.codmat+padr(temp.nroref,len(do_c.nroord))
        if found()
           xnpreo_c = (((100-pordto)/100)*iif(left(nroord,1)=[I],prefob,preuni))
           if xsundstk <> do_c.undcmp    &&& Verifica Unidad de Medida
              sele unid
              seek (xsundstk+do_c.undcmp)
              if found()
                 xsfacequ = unid.facequ
              endif
              sele do_c
           endif
           IF XsFacEqu<>0
           		xnpreo_c = round(xnpreo_c/xsfacequ,4)
           ELSE
           		xnPreO_c = 0
           ENDIF
           xnpreast = xnpreo_c
           *
           =seek(padr(temp.nroref,len(do_c.nroord)),[co_c])
           xnmono_c = co_c.codmon
           *
           * PRECIO DEACUERDO A LA MONEDA DEL ASIENTO
           *
           if lncodmon <> xnmono_c
              if xnmono_c = 1
                 if lftpocmb>0
                    xnpreo_c=round(xnpreo_c/lftpocmb,4)
                 else
                    xnpreo_c=0
                 endif
              else
                 xnpreo_c=round(xnpreo_c*lftpocmb,4)
              endif
           endif
           *
           sele temp
           do while !rlock()
           enddo
           repla puno_c with xnpreo_c     &&& O/C
           repla cano_c with candes
           repla mono_c with xnmono_c
           *
           repla punalm with xnprefac     &&& ALMACEN
           *
           repla preast with xnpreast     &&& PRECIO DE ACUERDO A LA MONEDA ASIENTO
           unlock
           *
        endif
     endif
     sele temp
endscan
return
