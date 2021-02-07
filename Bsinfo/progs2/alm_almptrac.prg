=F1_BASE(GsNomCia,GsNomSub,"Usuario:"+GsUsuario,GsFecha)
LsSubAlm = [   ]
LdFch1   = CTOD("01/"+STR(_Mes,2,0)+"/"+STR(_Ano,4,0))
LdFch2   = GdFecha
M.SUCURSAL  = []
M.UNIDAD    = 2
M.DRIVE     = 1
m.sede      = []
LcSLash     = [\]
m.RutaOri   = PADR(PATHTRAS,30)
m.RutaDes   = PADR(PATHTRAS,30)
m.Ruta_C    = PADR(PATHTRAS,40)
m.UnpakArc  = 2
XcTipo      = IIF(GsCodCia=[001],[Insumos],[Repuestos])
**
STORE [] TO sPathCalm,sPathCatg,sPathmovi,sPathcftr,sPathcdoc,sPathdivf,sPathalma
**
STORE .T. TO lActdivf,lActCdoc,lActCftr,lActMOVI,lActCatg,lActCalm,lactalma 
STORE .F. TO lStkMIn,lBorrMov,lActIni
STORE .f. TO OnlyNewCatg,OnlyNewCalm,OnlyNewCFTR,OnlyNewALMA,OnlyNewDIVF
STORE []  TO m.CodMatD,m.CodMatH

*
m.salir  = 1
UltTecla = 0
IF  F1_ALERT([Este proceso importa informaci¢n de otras sucursales que ;]+;
             [hayan enviado sus archivos actualizados por diskette me- ;]+;
             [diante la opci¢n de exportaci¢n de informaci¢n.          ],4)#1
    RETURN
ENDIF

IF UltTecla = K_ESC
   RETURN
ENDIF
UltTecla = 0

m.Dir_Orig = CURDIR()
SET DEFA TO (PATHTRAS)
m.Dir_act = CURDIR()
IF SYS(5)+m.Dir_Act#PATHTRAS
   SET DEFA TO (PATHDEF)
   DO CASE
      CASE _Dos OR _UNIX
	      !MKDIR TRASLADO
      CASE _Windows OR _Mac
	      =MKDIR([TRASLADO])
   ENDCASE
   SET DEFA TO (PATHTRAS)
   m.Dir_act = CURDIR()
   IF SYS(5)+m.Dir_Act#PATHTRAS
      DO F1MSGERR WITH [Imposible crear directorio de transferencia de datos]
   ENDIF
ENDIF
SET DEFA TO (m.Dir_Orig)

*
OnlyNewCatg=.t.
*
do almptrac.spr

IF UltTecla = K_ESC
   M.CURRWIN = WOUTPUT()
   IF !EMPTY(M.CURRWIN)
      RELEASE WINDOW (M.CURRWIN)
   ENDIF
   CLOSE DATA
   RETURN
ENDIF
*
LsSubALm = TRIM(LsSubAlm)
m.Ruta_C = m.RutaDes
m.Ruta_C = TRIM(m.Ruta_C)
*
DO CASE
   CASE _Unix
     LcSlash = [/]
   CASE _Dos
     LcSlash = [\]
   CASE _wINDOWS
     LcSlash = [\]

ENDCASE

IF !SUBSTR(m.Ruta_C,LEN(m.Ruta_C),1)$LcSlash
   m.Ruta_C=SUBSTR(m.Ruta_C,1,LEN(m.Ruta_C))+LcSlash
ENDIF




IF lActCalm
   DO ACTcalm
ENDIF
IF lActCatg
   DO ACTcatg
ENDIF
IF lActMovi
   DO ACTmovi
ENDIF
IF lActCftr
   DO ACTcftr
ENDIF
IF lActCdoc
   DO ACTcdoc
ENDIF
IF lActDIVF
   DO ACTDIVF
ENDIF

M.CURRWIN = WOUTPUT()
IF !EMPTY(M.CURRWIN)
   RELEASE WINDOW (M.CURRWIN)
ENDIF
CLOSE DATA
=F1QEH([PROCESO TERMINADO])

RETURN
*****************
PROCEDURE ACTCALM
*****************
SELE 0
USE ALMCATAL ORDER CATA01 ALIAS CALM
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
ArcTra = RUTA_C+[CATAL]+M.SEDE
SELE 0
USE &ArcTra. ALIAS CALMX
IF !USED()
    USE &ArcTra. ALIAS CALMX
    IF !USED()
       CLOSE DATA
       RETURN
    ENDIF
ENDIF
SELE CALMX
IF !EMPTY(LsSubAlm)
    WAIT WINDOW [Actualizando codigos del almacen ]+ALMNOMBR(LsSubAlm) NOWAIT
else
    WAIT WINDOW [Actualizando codigos por almacen ] NOWAIT
endif
GO TOP
SCAN FOR SubAlm = LsSubAlm AND (STKINI<>0 OR VINIMN<>0 OR VINIUS<>0 OR STKACT<>0)
     SCATTER MEMVAR
     SELE CALM
     SEEK CALMX.SubAlm+CALMX.CodMat
     LfVINIMN = VINIMN
     LfVINIUS = VINIUS
     LfSTKINI = STKINI

     WAIT WINDOW [Actualizando almacen ]+LEFT(ALMNOMBR(SubAlm),20)+[ ] NOWAIT
     IF !FOUND()
        APPEND BLANK
        IF lActIni
           GATHER MEMVAR
        ELSE
           GATHER MEMVAR FIELDS SUBALM,CODMAT,UNDVTA,STKACT,FACEQU,CODSEC,;
                         STKREP,STKM01,STKM02,STKM03,STKM04,STKM05,STKM06,;
                         STKM07,STKM08,STKM09,STKM10,STKM11,STKM12
        ENDIF
        UNLOCK
        WAIT WINDOW [Actualizando almacen ]+LEFT(ALMNOMBR(SubAlm),20)+[ ]+CodMat NOWAIT
     ELSE
    	IF !OnlyNewCatg
     
        IF lActIni
           GATHER MEMVAR FIELDS UNDVTA,STKACT,FACEQU,CODSEC,STKINI,VINIMN,VINIUS,;
                         STKREP,STKM01,STKM02,STKM03,STKM04,STKM05,STKM06,;
                         STKM07,STKM08,STKM09,STKM10,STKM11,STKM12
        ELSE
           IF !lStkMin
              GATHER MEMVAR FIELDS UNDVTA,STKACT,FACEQU,CODSEC,;
                            STKREP,STKM01,STKM02,STKM03,STKM04,STKM05,STKM06,;
                            STKM07,STKM08,STKM09,STKM10,STKM11,STKM12
           ELSE
              GATHER MEMVAR FIELDS STKM01,STKM02,STKM03,STKM04,STKM05,STKM06,;
                            STKM07,STKM08,STKM09,STKM10,STKM11,STKM12
           ENDIF

        ENDIF
        UNLOCK
        WAIT WINDOW [Actualizando almacen ]+LEFT(ALMNOMBR(SubAlm),20)+[ ]+CodMat NOWAIT
        ENDIF
     ENDIF
     SELE CALMX
ENDSCAN
CLOSE DATA
RETURN
*****************
PROCEDURE ACTCATG
*****************
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
    CLOSE DATA
    RETURN
ENDIF
SELE 0
ArcTra = RUTA_C+[CATGE]+M.SEDE
USE &ArcTra. ALIAS CATGX
IF !USED()
   USE &ArcTra. ALIAS CATGX
   IF !USED()
       CLOSE DATA
       RETURN
   ENDIF
ENDIF
SELE CATGX
GO TOP
WAIT WINDOW [Actualizando codigos del Catalogo general] NOWAIT
SCAN  for codmat>=m.CodMatD AND CodMat<=m.CodMatH
    SCATTER MEMVAR
    SELE CATG
    SEEK CATGX.CODMAT
    IF !FOUND()
       WAIT WINDOW [Actualizando codigo]+[ ]+m.CodMat NOWAIT
       APPEND BLANK
       GATHER MEMVAR
    ELSE
    	IF !OnlyNewCatg
			WAIT WINDOW [Actualizando codigo]+[ ]+m.CodMat NOWAIT
	        GATHER MEMVAR FIELDS DESMAT,UNDSTK,INACTIVO,CODPR1,CODPR2
			REPLACE UndEqu WITH IIF(EMPTY(UndEqu) AND !EMPTY(CATGX.UndEqu),CATGx.UndEqu,UndEqu)        		
		ENDIF	
    ENDIF
    SELE CATGX
ENDSCAN
CLOSE DATA
RETURN
*****************
PROCEDURE ACTMOVI
*****************
IF !USED([ALMA])
   SELE 0
   USE ALMTALMA ORDER ALMA01 ALIAS ALMA
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
SELE 0
USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE ALMDTRAN ORDER DTRA01 ALIAS DTRA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE ALMCTRAN ORDER CTRA01 ALIAS CTRA
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
SELE 0
USE ALMESTCM ORDER ESTA01 ALIAS ESTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
ArcTra = RUTA_C+[DTRAN]+M.SEDE
SELE 0
USE &ArcTra. ALIAS DTRAX EXCL
IF !USED()
   USE &ArcTra. ALIAS DTRAX EXCL
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
*
ArcTra = RUTA_C+[CTRAN]+M.SEDE
SELE 0
USE &ArcTra. ALIAS CTRAX EXCL
IF !USED()
   USE &ArcTra. ALIAS CTRAX EXCL
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
IF lBorrMov
   WAIT WINDOW [BORRANDO MOVIMIENTOS ANTERIORMENTE GRABADOS] NOWAIT
   SELE DTRA
   SET ORDER TO DTRA10
   SEEK DTOS(LdFch1)
   IF !FOUND() AND RECNO(0)>0
      GO RECNO(0)
   ENDIF
   SCAN WHILE FchDoc<=LdFch2 FOR CODALM=m.Sede
        =SEEK(SUBALM,[ALMA])
        IF FCHDOC>ALMA.FCHCIE AND SUBALM=LsSubAlm
           m.Ingreso = INLIST(TipMov,[I],[R])
           WAIT WINDOW [Borrando: ]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
           zLlave = DTRA.SubAlm+DTRA.TipMov+DTRA.CodMov+DTRA.NroDoc
           =SEEK(TipMov+CodMov,[CFTR])
           m.lModPre = CFTR->ModPre
           m.lPidPco = CFTR->PidPco
           m.lModCsm = CFTR->ModCsm
           if M.LPIDpCO
              loop
           endif
           =F1_RLOCK(0)
           DELE
          *IF m.Ingreso
          *   DO ALMpdsm2 WITH .T.
          *ELSE
          *   DO ALMpcsm2 WITH .T.
          *ENDIF
           UNLOCK
           SELE CTRA
           SEEK zLlave
           IF FOUND()
              =F1_RLOCK(0)
              DELE
              UNLOCK
           ENDIF
           SELE DTRA
        ENDIF
   ENDSCAN
   SELE DTRA
   SET ORDER TO DTRA01
ENDIF
***
WAIT WINDOW [TRANSFIRIENDO MOVIMIENTOS UN MOMENTO POR FAVOR...] NOWAIT
SELE CTRAX
INDEX ON DTOS(FCHDOC)+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA04
SET ORDER TO CTRA04
SELE DTRAX
INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM) TAG DTRA01
INDEX ON ALMORI+SUBALM+TIPMOV+CODMOV+NRODOC      TAG DTRA07
SET ORDER TO DTRA01
SELE CTRAX
SET RELA TO SUBALM INTO ALMA
SEEK DTOS(LdFch1)
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
SCAN WHILE FchDoc>=LdFch1 AND FchDoc<=LdFch2 FOR SubAlm=LsSubAlm AND FCHDOC>ALMA.FCHCIE
     SCATTER MEMVAR
     SELE CTRA
     SEEK CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
        WAIT WINDOW [Actualizando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
        SELE DTRA
        SEEK CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
        SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
             =SEEK(TipMov+CodMov,[CFTR])
             WAIT WINDOW [Borrando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
             m.lModPre = CFTR->ModPre
             m.lPidPco = CFTR->PidPco
             m.lModCsm = CFTR->ModCsm
             =F1_RLOCK(0)
             DELE
            *IF TipMov = [I]
            *   DO ALMpdsm2 WITH .T.
            *ELSE
            *   DO ALMpcsm2 WITH .T.
            *ENDIF
             UNLOCK
        ENDSCAN
        IF CTRAX.TipMov=[T]
           zLLave = CTRAX.SubAlm+CTRAX.AlmOri+[R]+CTRAX.CodMov+CTRAX.NroDoc
           SELE DTRA
           SET ORDER TO DTRA07
           SEEK zLlave
           SCAN WHILE AlmOri+SubAlm+TipMov+CodMov+NroDoc=zLLave
                WAIT WINDOW [Borrando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
                =SEEK([T]+CodMov,[CFTR])
                m.lModPre = CFTR->ModPre
                m.lPidPco = CFTR->PidPco
                m.lModCsm = CFTR->ModCsm
                =F1_RLOCK(0)
                DELE
               *IF TipMov = [I]
               *   DO ALMpdsm2 WITH .T.
               *ELSE
               *   DO ALMpcsm2 WITH .T.
               *ENDIF
                UNLOCK
           ENDSCAN
           SELE DTRA
           SET ORDER TO DTRA01
        ENDIF
        SELE DTRAX
        SEEK CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
        SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
             =seek(codmat,[CATG])
             WAIT WINDOW [Actualizando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
             m.Ingreso = INLIST(TipMov,[I],[R])
             SCATTER MEMVAR
             SELE DTRA
             APPEND BLANK
             GATHER MEMVAR
             DO WHILE !RLOCK()
             ENDDO
             =SEEK(TipMov+CodMov,[CFTR])
             m.lModPre = CFTR->ModPre
             m.lPidPco = CFTR->PidPco
             m.lModCsm = CFTR->ModCsm
             Crear = .T.
            *IF m.Ingreso
            *   DO ALMpcsm1
            *ELSE
            *   DO ALMpdsm1
            *ENDIF
             IF DTOS(FCHDOC)<=[199608]
                IF m.lModCsm
                   REPLACE TpoRef WITH DTRAX.AlmOri
                   REPLACE NroRef WITH DTRAX.NroOdt
                ENDIF
             ENDIF
             UNLOCK
             SELE DTRAX
        ENDSCAN
        IF CTRAX.TipMov=[T]
           SELE DTRAX
           SET ORDER TO DTRA07
           zllave = CTRAX.SubAlm+CTRAX.AlmOri+[R]+CTRAX.CodMov+CTRAX.NroDoc
           SEEK zLlave
           SCAN WHILE AlmOri+SubAlm+TipMov+CodMov+NroDoc=zLlave
                =seek(codmat,[CATG])
                WAIT WINDOW [Actualizando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
                m.Ingreso = INLIST(TipMov,[I],[R])
                SCATTER MEMVAR
                SELE DTRA
                APPEND BLANK
                GATHER MEMVAR
                DO WHILE !RLOCK()
                ENDDO
                =SEEK([T]+CodMov,[CFTR])
                m.lModPre = CFTR->ModPre
                m.lPidPco = CFTR->PidPco
                m.lModCsm = CFTR->ModCsm
                Crear = .T.
               *IF m.Ingreso
               *   DO ALMpcsm1
               *ELSE
               *   DO ALMpdsm1
               *ENDIF
                UNLOCK
                SELE DTRAX
           ENDSCAN
           SELE DTRAX
           SET ORDER TO DTRA01
        ENDIF
     ELSE
        =SEEK(CTRAX.TIPMOV+CTRAX.CODMOV,[CFTR])
        IF !CFTR.pidpco
           GATHER MEMVAR
           ** Borramos lo que ya existe **
           SELE DTRA
           SEEK CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
           SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
                =SEEK(TipMov+CodMov,[CFTR])
                WAIT WINDOW [Borrando :]+Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
                m.lModPre = CFTR->ModPre
                m.lPidPco = CFTR->PidPco
                m.lModCsm = CFTR->ModCsm
                =F1_RLOCK(0)
                DELE
               *IF TipMov = [I]
               *   DO ALMpdsm2 WITH .T.
               *ELSE
               *   DO ALMpcsm2 WITH .T.
               *ENDIF
                UNLOCK
           ENDSCAN
           ** Graabamos nuevamente **
           WAIT WINDOW [Actualizando :]+CTRAX.Subalm+[ ]+CTRAX.Tipmov+[ ]+CTRAX.CodMov+[ ]+CTRAX.NroDoc+[ ]+DTOC(CTRAX.FchDoc) NOWAIT
           SELE DTRAX
           SEEK CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
           SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=CTRAX.SubAlm+CTRAX.TipMov+CTRAX.CodMov+CTRAX.NroDoc
                =seek(codmat,[CATG])
                m.Ingreso = INLIST(TipMov,[I],[R])
                SCATTER MEMVAR
                SELE DTRA
                APPEND BLANK
                GATHER MEMVAR
                DO WHILE !RLOCK()
                ENDDO
                =SEEK(TipMov+CodMov,[CFTR])
                m.lModPre = CFTR->ModPre
                m.lPidPco = CFTR->PidPco
                m.lModCsm = CFTR->ModCsm
                Crear = .T.
               *IF m.Ingreso
               *   DO ALMpcsm1
               *ELSE
               *   DO ALMpdsm1
               *ENDIF
                IF DTOS(FCHDOC)<=[199608]
                   IF m.lModCsm
                      REPLACE TpoRef WITH DTRAX.AlmOri
                      REPLACE NroRef WITH DTRAX.NroOdt
                   ENDIF
                ENDIF
                UNLOCK
                SELE DTRAX
           ENDSCAN
        ENDIF
     ENDIF
     SELE CTRAX
ENDSCAN
CLOSE DATA
RETURN
*****************
PROCEDURE ActCdoc
*****************
SELE 0
USE ALMCDOCM ORDER CDOC01 ALIAS CDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
ArcTra = RUTA_C+[CDOCM]+M.SEDE
SELE 0
USE &ArcTra. ALIAS CDOCX EXCL
IF !USED()
   USE &ArcTra. ALIAS CDOCX EXCL
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
INDEX ON SUBALM+TIPMOV+CODMOV TAG CDOC01
SET ORDER TO CDOC01
GO TOP
WAIT WINDOW [TRANSFIRIENDO CORRELATIVO DE DOCUMENTOS] NOWAIT
SCAN FOR SUBALM=LsSubalm AND !Empty(SubAlm) AND !INLIST(TIPMOV,[P],[B])
     WAIT WINDOW Subalm+[ ]+Tipmov+[ ]+CodMov NOWAIT
     SCATTER MEMVAR
     XnNroDoc = NroDoc
     SELE CDOC
     SEEK CDOCX.SUBALM+CDOCX.TIPMOV+CDOCX.CODMOV
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
     ELSE
        =F1_RLOCK(0)
        IF XnNroDoc>NroDoc
           REPLACE NroDoc WITH XnNroDoc
        ENDIF
        FOR k = 1 to 12
            CmpNro = [NDOC]+TRAN(K,"@L ##")
            iNroMes = CDOCX.&CmpNro.
            iNroAct = &CmpNro.
            IF iNroMes>iNroAct
               REPLACE &CmpNro. WITH iNroMes
            ENDIF
        ENDFOR
     ENDIF
     UNLOCK
     SELE CDOCX
ENDSCAN
**
SELE CDOC
SET ORDER TO CDOC03
SELE CDOCX
GO TOP
WAIT WINDOW [TRANSFIRIENDO CORRELATIVO DE PRODUCCION] NOWAIT
SCAN FOR INLIST(TIPMOV,[P],[B])
     WAIT WINDOW Subalm+[ ]+Tipmov+[ ]+CodMov NOWAIT
     XnNroDoc = NroDoc
     SCATTER MEMVAR
     SELE CDOC
     SEEK CDOCX.SUBALM+CDOCX.TIPMOV+CDOCX.CODFAM+CDOCX.Siglas
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
     ELSE
        =F1_RLOCK(0)
        gather memvar 
     ENDIF
     UNLOCK
     SELE CDOCX
ENDSCAN
CLOSE DATA
RETURN
*****************
PROCEDURE ActCFTR
*****************
SELE 0
USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
ArcTra = RUTA_C+[CFTRA]+M.SEDE
SELE 0
USE &ArcTra. ALIAS CFTRX EXCL
IF !USED()
   USE &ArcTra. ALIAS CFTRX EXCL
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
SELE CFTRX
GO TOP
WAIT WINDOW [TRANSFIRIENDO CONFIGURACION DE TRANSACCIONES] NOWAIT
SCAN
     SCATTER MEMVAR
     SELE CFTR
     SEEK CFTRX.TIPMOV+CFTRX.CODMOV
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
        WAIT WINDOW TIPMOV+[ ]+CODMOV+[ ]+DESMOV NOWAIT
     ENDIF
     SELE CFTRX
ENDSCAN
CLOSE DATA
RETURN
*****************
PROCEDURE Actdivf
*****************
SELE 0
USE ALMtdivf ORDER divf01 ALIAS divf
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
ArcTra = RUTA_C+[TDIVF]+M.SEDE
USE &ArcTra. ALIAS DIVFX
IF !USED()
   USE &ArcTra. ALIAS DIVFX
   IF !USED()
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
SELE DIVFX
GO TOP
WAIT WINDOW [TRANSFIRIENDO TABLA DE DIVISIONES Y FAMILIAS] NOWAIT
SCAN
     SCATTER MEMVAR
     SELE DIVF
     SEEK DIVFX.CLFDIV+DIVFX.CODFAM
     IF !FOUND()
        APPEND BLANK
        GATHER MEMVAR
        WAIT WINDOW CLFDIV+[ ]+CODFAM+[ ]+DESFAM NOWAIT
     ENDIF
     SELE DIVFX
ENDSCAN
CLOSE DATA
RETURN
**********************
PROCEDURE Desempaqueta
**********************
PRIVATE XVENTMP
M.CURRWIN = WOUTPUT()
IF !EMPTY(M.CURRWIN)
   DEACTIVATE WINDOW (M.CURRWIN)
ENDIF
m.RutaDes = ADDBS(TRIM(m.RutaDes))
m.RutaOri = ADDBS(TRIM(m.RutaOri))
VsCurDir  = m.Dir_Orig
VsRuta    = PATHDEF+[\]
*if M.SEDE=[003]  && Vulcano
 	VsArcDes  = [ALM]+right(TRAN(_ANO,'9999'),2)+TRAN(_MES,"@L ##")+[.]+right(m.sede,2)+LEFT(XcTipo,1)
*else
*	VsArcDes  = [ALM]+right(TRAN(_ANO,'9999'),2)+TRAN(_MES,"@L ##")+[.]+m.sede
*endif	
VsBatch   = [ALM]+m.sede+[I]
VsRuta  =ADDBS(JUSTPATH(LOCFILE(Vsbatch,[BAT;EXE],[Buscar ]+VsBatch)))
IF !EMPTY(VsRuta)
	RUN &VsRuta.&vsbatch. &VsArcDes. &Rutades.
	SET DEFA TO (VsCurDir)
ELSE
	=F1_ALERT([El archivo de proceso por lotes ]+VsBatch+[ no se puede localizar.;]+;
			  [Verificar en Menu -> Mantenimiento\Configuración de sistema],[MENSAJE])	
	
ENDIF
**RUN &VsRuta.&VsBatch. &RutaOri.&VsArcDes. &RutaDes.
SET DEFA TO (VsCurDir)
IF !EMPTY(M.CURRWIN)
   ACTIVATE WINDOW (M.CURRWIN)
   show gets
ENDIF
