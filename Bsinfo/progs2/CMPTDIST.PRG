*       *********************************************************
*       *
*       * 26/06/97            CMPTDIST.SPR               10:51:57
*       *
*       *********************************************************
*       *
*       * Victor E. Torres Tejada  - VETT
*       *
*       * Copyright (c) 1997 BELSOFT-        9437638
*       * Av. Arredondo 175-202 Urb.Ingenieria
*       * San M. Porres - LIMA, LIMA  C.P.
*       * PERU
*       *
*       * Description:
*       * Este programa lo ha generado automﬂticamente GENSCRN.
*       *
*       *********************************************************


#REGION 0
REGIONAL m.currarea, m.talkstat, m.compstat

IF SET("TALK") = "ON"
	SET TALK OFF
	m.talkstat = "ON"
ELSE
	m.talkstat = "OFF"
ENDIF
*
PATHCTB1 = [\BASE\CIA001\]
*
m.compstat = SET("COMPATIBLE")
SET COMPATIBLE FOXPLUS

m.rborder = SET("READBORDER")
SET READBORDER ON
*       *********************************************************
*       *
*       *             Windows Definiciones de ventana
*       *
*       *********************************************************
*
DO CASE
   CASE _DOS OR _UNIX
	IF NOT WEXIST("wbig")
		DEFINE WINDOW wbig ;
			FROM 1,1 ;
			TO 23,78 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			MINIMIZE ;
			DOUBLE
	ENDIF

	IF NOT WEXIST("cmpdistrib")
		DEFINE WINDOW cmpdistrib ;
			FROM 0, 0 ;
			TO 6,75 ;
			TITLE "DISTRIBUCION DE COMPRAS PROGRAMADAS" ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			CLOSE ;
			SHADOW ;
			MINIMIZE IN WINDOW WBIG
	ENDIF

	IF NOT WEXIST("wbrowse0")
		DEFINE WINDOW wbrowse0 ;
			FROM 7, 0 ;
			TO 16,75 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			NONE ;
			MINIMIZE IN WINDOW WBIG
	ENDIF

	IF NOT WEXIST("wcontrol")
		DEFINE WINDOW wcontrol ;
			FROM 20, 0 ;
			TO 23,75 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			NONE ;
			NOMINIMIZE IN WINDOW WBIG
	ENDIF
   CASE _WINDOWS OR _MAC
	IF NOT WEXIST("wbig")
		DEFINE WINDOW wbig ;
			FROM 1,1 ;
			TO 27,80 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			MINIMIZE ;
			DOUBLE
	ENDIF

	IF NOT WEXIST("cmpdistrib")
		DEFINE WINDOW cmpdistrib ;
			FROM 0, 0 ;
			TO 8,95 ;
			TITLE "DISTRIBUCION DE COMPRAS PROGRAMADAS" ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			CLOSE ;
			SHADOW ;
			MINIMIZE IN WINDOW WBIG
	ENDIF

	IF NOT WEXIST("wbrowse0")
		DEFINE WINDOW wbrowse0 ;
			FROM 9, 0 ;
			TO 17,95 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			NONE ;
			TITLE [Tabla de Distribuci¢n de Compras Proyectadas] ;
			GROW ;
			MINIMIZE IN WINDOW WBIG
	ENDIF
	
	IF NOT WEXIST("wcontrol")
		DEFINE WINDOW wcontrol ;
			FROM 18, 0 ;
			TO 21,95 ;
			FONT "MS Sans Serif", 8 ;
			STYLE "B" ;
			FLOAT ;
			NOCLOSE ;
			NONE ;
			NOMINIMIZE IN WINDOW WBIG
	ENDIF
ENDCASE
*       *********************************************************
*       *
*       *  CMPTDIST/Windows C_digo de configuraci_n - SECCION 2
*       *
*       *********************************************************
*

#REGION 1
IF !ABRIRDBFS()
   DO F1MsgErr WITH [Error en apertura de archivo]
   RETURN
ENDIF
AnoAct = _Ano
MesAct = _Mes
m.mes  = MesAct
IF MesAct<12
   PdFchFin = CTOD("01/"+STR(MesAct+1,2,0)+"/"+STR(AnoAct,4,0)) - 1
ELSE
   PdFchFin = CTOD("31/12/"+STR(AnoAct,4,0))
ENDIF
m.PerTra=TRAN(AnoAct,[9999])+TRAN(MesAct,[@L ##])
m.PerAnt=TRAN(AnoAct,[9999])+TRAN(MesAct,[@L ##])
LfCanPen=0
SELE DIST
GO TOP
m.Salir = 1
PsCodMat= DIST.CodMat
=SEEK(PsCodMat,[CATG])
LsDesMat = CATG.DesMat
LsUndStk = CATG.UndStk
*
*=SEEK(m.PerTra+PsCodMat,[PACI])
ii = 1
sele paci
seek m.pertra
if !found()
   do while .t.
      if mesact = 1
         m.perant=str(anoact-1,4,0)+[12]
      else
         m.perant=str(anoact,4,0)+tran(mesact-ii,[@l 99])
      endif
      seek m.perant
      if found() .or. mesact-ii=0
         exit
      endif
      ii = ii + 1
   enddo
endif
=SEEK(m.PerAnt+PsCodMat,[PACI])
LsCmpMes=[PACI.CP]+TRAN(m.mes,[@L ##])
LfCanPrg=EVAL(LscmpMes)
*
do tot_prog
*
XfTpoCmb=F_TpoCmb(PdFchFin)
UltTecla = 0
M.PRIMERA=.T.
*** VARIABLES DEL BROWSE ***
M.bfILTRO =[]
M.BcAMPOS =[]
M.BClave1 =[]
M.BClave2 =[]
sModulo = [DIST_CMP]
IF WVISIBLE("wbig")
	ACTIVATE WINDOW wbig SAME
ELSE
	ACTIVATE WINDOW wbig NOSHOW
ENDIF

*       *********************************************************
*       *
*       *        CMPTDIST/Windows Distribuci_n de pantalla
*       *
*       *********************************************************
*
#REGION 1
IF WVISIBLE("cmpdistrib")
	ACTIVATE WINDOW cmpdistrib SAME
ELSE
	ACTIVATE WINDOW cmpdistrib NOSHOW
ENDIF
DO CASE
   CASE _DOS OR _UNIX
        @ 0.000,0.000  SAY "Periodo   :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 0.000,23     SAY "Mes :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 1.077,0.000  SAY "Insumo    :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 2.154,0.000  SAY "T.Cambio  :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 3.0,0.000    SAY "Compras   :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "BT"

        @ 4.0,0.000    SAY "O/C x Emit:" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "BT"

        @ 0.077,12.333 GET m.PerTra ;
                       SIZE 1.000,7 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "@R 9999-99" ;
                       WHEN _rls0nafrz() ;
                       VALID _rls0nafsu()

        @ 0.077,29.000 GET m.mes ;
                       SIZE 1.000,2 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "@R 99" ;
                       WHEN _rls0nafrz() ;
                       VALID _mespro()

        @ 1.154,12.333 GET PsCodMat ;
                       SIZE 1.000,8.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       VALID _rls0nafu6()

        @ 1.077,22.500 GET LsDesMat ;
                       SIZE 1.000,39.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       WHEN _rls0nafvj()

        @ 1.077,58.500 GET LsUndStk ;
                       SIZE 1.000,3.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       WHEN _rls0nafwe()

        @ 2.308,12.333 GET XfTpoCmb ;
                       SIZE 1.000,10.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "9,999.9999" ;
                       WHEN _rls0nafx9() ;
                       VALID _rls0nafy2() ;
                       MESSAGE [Tipo de cambio del mes.]

        @ 3.0,12.000   GET lfCanPrg ;
                       SIZE 1.000,13.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       PICTURE "@K 999,999,999.99" ;
                       WHEN _rls0nag04()

        @ 4.0,12.000   GET lfCanPen ;
                       SIZE 1.000,13.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       PICTURE "@K 999,999,999.99" ;
                       WHEN _rls0nag04()

        @ 4.0,40       get m.distrib ;
                       PICTURE "@*HN \<Distribuir" ;
                       SIZE 1.0,12.000,1.000 ;
                       DEFAULT 1 ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       VALID _rls0nafz1() ;
                       MESSAGE [Distribuci¢n por proveedor]

   CASE _WINDOWS OR _MAC
        @ 0.077,0.000  SAY "Periodo     :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 0.077,23     SAY "Mes :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 1.154,0.000  SAY "Insumo      :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 2.308,0.000  SAY "T.Cambio  :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B"

        @ 3.462,0.000    SAY "Compras   :" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "BT"

        @ 4.616,0.000    SAY "O/C x Emit:" ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "BT"

        @ 0.077,12.333 GET m.PerTra ;
                       SIZE 1.000,8.200 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "@R 9999-99" ;
                       WHEN _rls0nafrz() ;
                       VALID _rls0nafsu()

        @ 0.077,29.000 GET m.mes ;
                       SIZE 1.000,3 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "@R 99" ;
                       WHEN _rls0nafrz() ;
                       VALID _mespro()

        @ 1.154,12.333 GET PsCodMat ;
                       SIZE 1.000,9.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       VALID _rls0nafu6()

        @ 1.077,21.500 GET LsDesMat ;
                       SIZE 1.000,39.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       WHEN _rls0nafvj()

        @ 1.077,55.500 GET LsUndStk ;
                       SIZE 1.000,3.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       WHEN _rls0nafwe()

        @ 2.308,12.333 GET XfTpoCmb ;
                       SIZE 1.000,10.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       PICTURE "9,999.9999" ;
                       WHEN _rls0nafx9() ;
                       VALID _rls0nafy2() ;
                       MESSAGE [Tipo de cambio del mes.]

        @ 3.462,12.333 GET lfCanPrg ;
                       SIZE 1.000,13.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       PICTURE "@K 999,999,999.99" ;
                       WHEN _rls0nag04()

        @ 4.616,12.333 GET lfCanPen ;
                       SIZE 1.000,13.000 ;
                       DEFAULT " " ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       PICTURE "@K 999,999,999.99" ;
                       WHEN _rls0nag04()

        @ 4.000,52.500 GET m.distrib ;
                       PICTURE "@*HN \<Distribuir" ;
                       SIZE 1.769,12.000,1.000 ;
                       DEFAULT 1 ;
                       FONT "MS Sans Serif", 8 ;
                       STYLE "B" ;
                       VALID _rls0nafz1() ;
                       MESSAGE [Distribuci¢n por proveedor]

ENDCASE


*       *********************************************************
*       *
*       *        CMPWBROW/Windows Distribuci_n de pantalla
*       *
*       *********************************************************
*

#REGION 2
IF WVISIBLE("wbrowse0")
	ACTIVATE WINDOW wbrowse0 SAME
ELSE
	ACTIVATE WINDOW wbrowse0 NOSHOW
ENDIF




*       *********************************************************
*       *
*       *        CMPWBIG/Windows Distribuci_n de pantalla
*       *
*       *********************************************************
*

#REGION 3




*       *********************************************************
*       *
*       *        CMPCTRL1/Windows Distribuci_n de pantalla
*       *
*       *********************************************************
*

#REGION 4
IF WVISIBLE("wcontrol")
	ACTIVATE WINDOW wcontrol SAME
ELSE
	ACTIVATE WINDOW wcontrol NOSHOW
ENDIF
@ 0,49  GET m.salir ;
	PICTURE "@*H \<Imprimir;\<Salir" ;
	SIZE 1,10,1 ;
	DEFAULT 1 ;
	FONT "MS Sans Serif", 8 ;
	STYLE "B";
	VALID vSalir()
	
IF NOT WVISIBLE("wBIG")
	ACTIVATE WINDOW wBig
ENDIF

IF NOT WVISIBLE("wcontrol")
	ACTIVATE WINDOW wcontrol
ENDIF
IF NOT WVISIBLE("wbrowse0")
	ACTIVATE WINDOW wbrowse0
ENDIF
IF NOT WVISIBLE("cmpdistrib")
	ACTIVATE WINDOW cmpdistrib
ENDIF

****READ CYCLE deactivate vdeact() valid xxx()

read cycle valid xxx()

RELEASE WINDOW cmpdistrib
RELEASE WINDOW wbrowse0
RELEASE WINDOW wcontrol
RELEASE WINDOW wbig

****close data

#REGION 0

SET READBORDER &rborder

IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


*       *********************************************************
*       *
*       *           CMPTDIST/Windows C_digo de limpieza
*       *
*       *********************************************************
*

#REGION 1
UltTecla = LASTKEY()
if ulttecla = k_esc
   m.salir = 2
endif
IF m.Salir = 2
   UltTecla = K_ESC
   close data
   return
ENDIF
********************


*       *********************************************************
*       *
*       * CMPTDIST/Windows Procedimientos y funciones de soporte
*       *
*       *********************************************************
*

#REGION 1
********************
PROCEDURE Brows_DIST
********************
PARAMETER lMostrar,m.Area
m.bTitulo = [WBROWSE0]
m.bDeta   = [WBROWSE0]
m.bTitBrow= [Tabla de Distribuci¢n de Compras Proyectadas]
m.VenPadre = [WBIG]
IF lMostrar
   m.bClave1 = PsCodMat
   m.bClave2 = PsCodMat
ELSE
   m.bClave1 = PsCodMat
   m.bClave2 = PsCodMat
ENDIF
sModulo = [DIST_CMP]
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = [DOUBLE]
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
m.prgPost = []
PRIVATE nX0,nX1,nY0,nY1
nX0 = 04
nY0 = 02
nX1 = 09
nY1 = 70
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
m.bPrgkeyF4=[Ddis]
m.bDescriF4=[Detalle]

DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RETURN
******************
FUNCTION ABRIRDBFS
******************
=F1qeh([Abriendo archivos...])
IF !USED([CATG])
    SELE 0
    USE ALMCATGE ORDER CaTG01  ALIAS CATG
    IF !USED()
       RETURN .F.
    ENDIF
    sele 0
    use almtdivf order divf01 alias divf
    IF !USED()
       RETURN .F.
    ENDIF
    sele catg
	set rela to left(codmat,GsLenDiv) into divf
	*
	sele 0
	ArcSql = pathuser+sys(3)
	select catg.codmat,catg.desmat,catg.undstk,catg.UndCmp;
       from almcatge catg, almtdivf divf;
       where divf.clfdiv=GsClfDiv .and. divf.tipfam=1 .and. catg.codmat=divf.codfam;
       group by catg.codmat;
       order by catg.codmat;
       into table (ArcSql)
    use   
	sele divf
	use       
    sele catg   
	use (ArcSql) alias catg exclu
	if !used()
	   close data
	   return .f.
	endif
	index on codmat tag catg01
	index on upper(desmat) tag catg02
	set order to catg01
ENDIF
***
IF !USED([AUXI])
    SELE 0
    ArcDbf = PATHctb1+[cbdmauxi]
    USE (ArcDbf) ORDER AUXI01  ALIAS AUXI
    IF !USED()
       RETURN .F.
    ENDIF
    ArcAux1 = PATHUSER+SYS(3)
    SEEK GsClfPro
    COPY REST TO (ArcAux1) with CDX  WHILE ClfAux=GsClfPro
    USE (ArcAux1) ORDER AUXI01 ALIAS AUXI
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([DIST])
    SELE 0
    USE CMPTDIST ORDER DIST01 ALIAS DIST
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([DDIS])
    SELE 0
    USE CMPDDIST ORDER DDIS01 ALIAS DDIS
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([FPGO])
    SELE 0
    USE FlCjTbFp ORDER FmaPgo  ALIAS FPGO
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([TCMB])
    SELE 0
    USE ADMMTCMB ORDER TCMB01  ALIAS TCMB
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([PRMY])
    SELE 0
    USE CMPTPRMY ORDER PRMY03 ALIAS PRMY
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
IF !USED([PACI])
    SELE 0
    USE CMPPACIN ORDER PACI01  ALIAS PACI
    IF !USED()
       RETURN .F.
    ENDIF
ENDIF
***
SELE DIST
=F1qeh([OK])
RETURN .T.
****************
FUNCTION vCodAux
****************
if deleted()
	return
endif
SCATTER MEMVAR
lvalido=F1_BUSCA(m.CodAux,[CODAUX],[AUXI],[AUXI],GsClfPro,.F.,[])
IF lValido
   DO WHILE !RLOCK([DIST])
   ENDDO
   REPLACE DIST.CodAux WITH m.CodAux
   replace dist.nOMaUX with aUXI.NOMAUX
   UNLOCK IN [DIST]
ENDIF
RETURN lValido
****************
FUNCTION vPorDis
****************
SCATTER MEMVAR
RETURN m.PorDis>=0
****************
FUNCTION vFmaPgo
****************
SCATTER MEMVAR
lValido = F1_Busca(m.FmaPgo,[FMAPGO],[FPGO],[FPGO],[],.T.,[])
IF lValido
	DO WHILE !RLOCK([DIST])
	ENDDO
	REPLACE DIST.FmaPgo WITH m.FmaPgo
	UNLOCK IN [DIST]
ENDIF	
RETURN lValido
****************
FUNCTION vEmiO_C
****************
SCATTER memvar
RETURN m.EmiO_C>=0
****************
FUNCTION vcpProd
****************
SCATTER memvar
RETURN m.n_entrega>=0
****************
FUNCTION Can_Prg
****************
RETURN ROUND(LfCanPen*PorDis/100,2)
****************
FUNCTION vCodMon
****************
SCATTER MEMVAR
RETURN INLIST(m.CodMon,1,2)


*       *********************************************************
*       *
*       * _RLS0NAFRZ           m.PerTra WHEN
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    5
*       * Variable:            m.PerTra
*       * Called By:           WHEN Clause
*       * Object Type:         Field
*       * Snippet Number:      1
*       *
*       *********************************************************
*
FUNCTION _rls0nafrz     &&  m.PerTra WHEN
#REGION 1
IF m.Primera
	do BROWS_dist WITH .t.,[DIST]
	m.Primera = .F.
ENDIF


*       *********************************************************
*       *
*       * _RLS0NAFSU           m.PerTra VALID
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    5
*       * Variable:            m.PerTra
*       * Called By:           VALID Clause
*       * Object Type:         Field
*       * Snippet Number:      2
*       *
*       *********************************************************
*
FUNCTION _rls0nafsu     &&  m.PerTra VALID
#REGION 1
AnoAct = VAL(SUBSTR(m.PerTra,1,4))
MesAct = VAL(SUBSTR(m.PerTra,5,2))
IF MesAct<12
   PdFchFin = CTOD("01/"+STR(MesAct+1,2,0)+"/"+STR(AnoAct,4,0)) - 1
ELSE
   PdFchFin = CTOD("31/12/"+STR(AnoAct,4,0))
ENDIF
*
m.PerAnt=TRAN(AnoAct,[9999])+TRAN(MesAct,[@L ##])
*
*=SEEK(m.PerTra+PsCodMat,[PACI])
sele paci
seek m.pertra
if !found()
   do while .t.
      if mesact = 1
         m.perant=str(anoact-1,4,0)+[12]
      else
         m.perant=str(anoact,4,0)+tran(mesact-ii,[@l 99])
      endif
      seek m.perant
      if found() .or. mesact-ii=0
         exit
      endif
      ii = ii + 1
   enddo
endif
*
=SEEK(m.PerAnt+PsCodMat,[PACI])
LsCmpMes=[PACI.CP]+TRAN(m.mes,[@L ##])
LfCanPrg=EVAL(LscmpMes)
*
do tot_prog
*
FUNCTION _mespro     &&  m.mes VALID
#REGION 1
if m.mes<MesAct
   return .f.
endif
*AnoAct = VAL(SUBSTR(m.PerTra,1,4))
AnoAct = VAL(SUBSTR(m.PerAnt,1,4))
IF m.mes<12
   PdFchFin = CTOD("01/"+STR(m.mes+1,2,0)+"/"+STR(AnoAct,4,0)) - 1
ELSE
   PdFchFin = CTOD("31/12/"+STR(AnoAct,4,0))
ENDIF
*=SEEK(m.PerTra+PsCodMat,[PACI])
=SEEK(m.PerAnt+PsCodMat,[PACI])
LsCmpMes=[PACI.CP]+TRAN(m.mes,[@L ##])
LfCanPrg=EVAL(LscmpMes)
*
do tot_prog
*

*
*       *********************************************************
*       *
*       * _RLS0NAFU6           PsCodMat VALID
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    6
*       * Variable:            PsCodMat
*       * Called By:           VALID Clause
*       * Object Type:         Field
*       * Snippet Number:      3
*       *
*       *********************************************************
*
FUNCTION _rls0nafu6     &&  PsCodMat VALID
#REGION 1
pscodmat = padr(pscodmat,len(dist.codmat))
lValido=F1_Busca(PsCodMat,[CODMAT],[CATG],[CATG],[],.T.,[])
If lValido
   LsDesMat = CATG.DesMat
   LsUndStk = CATG.UndStk
   SHOW GET LsDesMat
   SHOW GET LsUndStk
   *
   *=SEEK(m.PerTra+PsCodMat,[PACI])
   =SEEK(m.PerAnt+PsCodMat,[PACI])
   LsCmpMes=[PACI.CP]+TRAN(m.mes,[@L ##])
   LfCanPrg=EVAL(LscmpMes)
   *
   do tot_prog
   *
   SHOW GET LfCanPrg
   SHOW GET LfCanPen
ENDIF
RETURN lValido


*       *********************************************************
*       *
*       * _RLS0NAFVJ           LsDesMat WHEN
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    7
*       * Variable:            LsDesMat
*       * Called By:           WHEN Clause
*       * Object Type:         Field
*       * Snippet Number:      4
*       *
*       *********************************************************
*
FUNCTION _rls0nafvj     &&  LsDesMat WHEN
#REGION 1
return .f.

*       *********************************************************
*       *
*       * _RLS0NAFWE           LsUndStk WHEN
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    8
*       * Variable:            LsUndStk
*       * Called By:           WHEN Clause
*       * Object Type:         Field
*       * Snippet Number:      5
*       *
*       *********************************************************
*
FUNCTION _rls0nafwe     &&  LsUndStk WHEN
#REGION 1
RETURN .F.

*       *********************************************************
*       *
*       * _RLS0NAFX9           XfTpoCmb WHEN
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    9
*       * Variable:            XfTpoCmb
*       * Called By:           WHEN Clause
*       * Object Type:         Field
*       * Snippet Number:      6
*       *
*       *********************************************************
*
FUNCTION _rls0nafx9     &&  XfTpoCmb WHEN
#REGION 1
IF EMPTY(XfTpoCmb)
   XfTpoCmb= F_TpoCmb(PdFecha)
ENDIF
SHOW GET XfTpoCmb

*       *********************************************************
*       *
*       * _RLS0NAFY2           XfTpoCmb VALID
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:    9
*       * Variable:            XfTpoCmb
*       * Called By:           VALID Clause
*       * Object Type:         Field
*       * Snippet Number:      7
*       *
*       *********************************************************
*
FUNCTION _rls0nafy2     &&  XfTpoCmb VALID
#REGION 1
RETURN XfTpoCmb>0

*       *********************************************************
*       *
*       * _RLS0NAFZ1           m.distrib VALID
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:   10
*       * Variable:            m.distrib
*       * Called By:           VALID Clause
*       * Object Type:         Push Button
*       * Snippet Number:      8
*       *
*       *********************************************************
*
FUNCTION _rls0nafz1     &&  m.distrib VALID
#REGION 1
do brows_DIST WITH .F.,[DIST]

*       *********************************************************
*       *
*       * _RLS0NAG04           lfCanPrg WHEN
*       *
*       * Function Origin:
*       *
*       * From Platform:       Windows
*       * From Screen:         CMPTDIST,     Record Number:   12
*       * Variable:            lfCanPrg
*       * Called By:           WHEN Clause
*       * Object Type:         Field
*       * Snippet Number:      9
*       *
*       *********************************************************
*
FUNCTION _rls0nag04     &&  lfCanPrg / lfCanPen  WHEN
#REGION 1
return .f.


*       *********************************************************
*       *
*       * _RLS0NAG12           Nivel de lectura WHEN
*       *
*       * Function Origin:
*       *
*       *
*       * From Platform:       Windows
*       * From Screen:         Multiple Screens
*       * Called By:           READ Statement
*       * Snippet Number:      10
*       *
*       *********************************************************
*

function vsalir
DO CASE
   CASE m.Salir = 1
 		WAIT WINDOW [Procedimiento de impresion]
   CASE m.Salir = 2
        CLEAR READ
ENDCASE
***************
Function vdeact
***************
IF NOT WVISIBLE("WBIG")
   quitting = .T.
  *suspend
   RETURN .T.
ENDIF	
IF WONTOP("WBROWSE0") OR WONTOP("WCONTROL") OR WONTOP("cmpdistrib")
	IF RDLEVEL() > 1
		RETURN .T.
	ELSE
		RETURN .F.
	ENDIF
ENDIF
lll=NOT WREAD()
if lll
  *suspen
endif
RETURN lll
************
function xxx
************
if m.salir=2
   return .T.
endif
return .F.
*
**************
PROCEDURE Ddis
**************
PRIVATE M.SAVEAREA,M.SAVEORDE
m.SAveArea=SELECT()
m.SaveOrde=ORDER()
xsnomaux = nomaux
xscodaux = codaux
sele ddis
set order to ddis01
*seek m.pertra + pscodmat + xscodaux
seek left(m.perant,4)+tran(m.mes,[@l ##])+pscodmat+xscodaux
do brow_ddis WITH .f.,[DDIS]
=SELECT(m.SaveArea)
sele dist
*
*******************
PROCEDURE Brow_Ddis
*******************
PARAMETER lMostrar,m.Area
PRIVATE m.PrgPost,m.bTitBrow,m.bTitulo,m.bDeta,m.BClave1,m.bClave2,m.bCampos
PRIVATE m.bFiltro,m.Area_Sel,m.PrgBusca,m.prgPrep,lModi_Reg,lAdi_Reg,lBorr_Reg
PRIVATE m.lStatic,m.bPrgkeyF4,m.bDescriF4
m.prgPost = []
m.btitbrow= alltrim(xsnomaux)
m.bTitulo = [flj_Det_D]
m.bDeta   = [flj_Det_D]
m.VenPadre= [WBIG]
IF lMostrar
  *m.bClave1 = m.pertra + pscodmat + xscodaux
  *m.bClave2 = m.pertra + pscodmat + xscodaux
   m.bClave1 = left(m.perant,4)+tran(m.mes,[@l ##]) + pscodmat + xscodaux
   m.bClave2 = left(m.perant,4)+tran(m.mes,[@l ##]) + pscodmat + xscodaux
ELSE
  *m.bClave1 = m.pertra + pscodmat + xscodaux
  *m.bClave2 = m.pertra + pscodmat + xscodaux
   m.bClave1 = left(m.perant,4)+tran(m.mes,[@l ##]) + pscodmat + xscodaux
   m.bClave2 = left(m.perant,4)+tran(m.mes,[@l ##]) + pscodmat + xscodaux
ENDIF
sModulo =[DDIS_CMP]
m.bFiltro = [.T.]
m.bCampos = bDef_Cmp(sModulo)
m.bBorde  = []
m.Area_Sel= m.Area
m.prgBusca= []
m.prgPrep = []
PRIVATE nX0,nX1,nY0,nY1
nX0 = 15
nY0 = 00
nX1 = 20
nY1 = 75
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
sPic = [@Z 9999999]
sPicT= [@Z 99999999]
m.lStatic = .f.
DO F1Browse WITH m.bClave1,lModi_Reg,lAdic_Reg,lBorr_Reg,lMostrar
RELEASE WINDOW flj_Det_D
RETURN
******************
PROCEDURE TOT_PROG
******************
lfcanpen = 0
sele prmy
xsllave = m.pertra+pscodmat+tran(m.mes,[@l ##])
seek xsllave
if found()
   scan while periodo+codmat+nromes=xsllave for sitprog=[P]
        lfcanpen = lfcanpen + progcmp
   endscan
endif
sele dist
return
