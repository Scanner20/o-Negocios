* *********************************************************
* *
* * 15/01/2003             GENERADB_AAAA.DBC             20:32:24
* *
* *********************************************************
* *
* * Descripción:
* * Este programa lo ha generado automáticamente GENDBC
* * Versión 2.26.67
* *
* *********************************************************
PARAMETERS cPathDatos,cCodCia,cAno
*SET DEFA TO d:\Apl
*!*	Activar los Paths para sus formularios personales.... (xUsuario)
*SET PATH TO  d:\apl\Data , ;
			d:\Aplvfp\ClassGen\vcxs,;
			d:\Aplvfp\ClassGen\PROGS,;
			d:\Aplvfp\BSINFO\PROGS



cPathDb_ANO = cPathDatos+"\CIA"+cCodCia+"\c"+cAno

DisplayStatus([Creando base de datos...])
CLOSE DATA ALL
IF !DIRECTORY(cPathDatos)
	MKDIR (cPathDatos)
ENDIF	
SET defa to (cPathDatos)

LsNomBd = 'P'+cCodCia+cAno
LsNomCia = 'CIA'+cCodcia
CREATE DATABASE (LsNomBd)
IF !DIRECTORY(cPathDB_ANO)
	MKDIR (cPathDB_ANO)
ENDIF	
SET DEFAULT TO (cPathDb_ANO)
DisplayStatus([Creando tabla ALMCATAL...])
MakeTable_ALMCATAL()
DisplayStatus([Creando tabla CPIQO_TB...])
MakeTable_CPIQO_TB()
DisplayStatus([Creando tabla ALMCDOCM...])
MakeTable_ALMCDOCM()
DisplayStatus([Creando tabla ALMCFTRA...])
MakeTable_ALMCFTRA()
DisplayStatus([Creando tabla ALMCTRAN...])
MakeTable_ALMCTRAN()
DisplayStatus([Creando tabla CBDDRMOV...])
MakeTable_CBDDRMOV()
DisplayStatus([Creando tabla CBDMPART...])
MakeTable_CBDMPART()
DisplayStatus([Creando tabla CBDRPART...])
MakeTable_CBDRPART()
DisplayStatus([Creando tabla CBDTCIER...])
MakeTable_CBDTCIER()
DisplayStatus([Creando tabla CBDTOPER...])
MakeTable_CBDTOPER()
DisplayStatus([Creando tabla CBDVMOVM...])
MakeTable_CBDVMOVM()
DisplayStatus([Creando tabla CPICDOCM...])
MakeTable_CPICDOCM()
DisplayStatus([Creando tabla CPICO_TB...])
MakeTable_CPICO_TB()
DisplayStatus([Creando tabla CPICULTI...])
MakeTable_CPICULTI()
DisplayStatus([Creando tabla CPICUXLT...])
MakeTable_CPICUXLT()
DisplayStatus([Creando tabla CPIDO_TB...])
MakeTable_CPIDO_TB()
DisplayStatus([Creando tabla CPIMO_TB...])
MakeTable_CPIMO_TB()
DisplayStatus([Creando tabla CPIPO_TB...])
MakeTable_CPIPO_TB()
DisplayStatus([Creando tabla CBDMCTAS...])
MakeTable_CBDMCTAS()
DisplayStatus([Creando tabla FCJCROPL...])
MakeTable_FCJCROPL()
DisplayStatus([Creando tabla FCJTCPLA...])
MakeTable_FCJTCPLA()
DisplayStatus([Creando tabla FLCJDOCC...])
MakeTable_FLCJDOCC()
DisplayStatus([Creando tabla FLCLIQUI...])
MakeTable_FLCLIQUI()
DisplayStatus([Creando tabla ALMDLOTE...])
MakeTable_ALMDLOTE()
DisplayStatus([Creando tabla ALMDTRAN...])
MakeTable_ALMDTRAN()
DisplayStatus([Creando tabla ALMCATGE...])
MakeTable_ALMCATGE()
DisplayStatus([Creando tabla CBDRMOVM...])
MakeTable_CBDRMOVM()
DisplayStatus([Creando tabla CBDACMCT...])
MakeTable_CBDACMCT()
DisplayStatus([Creando vista V_MATERIALES_X_ALMACEN...])
MakeView_V_MATERIALES_X_ALMACEN()
DisplayStatus([Creando vista V_CULTIVOS_X_LOTE...])
MakeView_V_CULTIVOS_X_LOTE()
DisplayStatus([Creando vista V_MATERIALES_X_ALMACEN_2...])
MakeView_V_MATERIALES_X_ALMACEN_2()
DisplayStatus([Creando vista V_MATERIALES_SIN_ALMACEN...])
MakeView_V_MATERIALES_SIN_ALMACEN()
DisplayStatus([Creando vista V_MATERIALES_X_ALMACEN_3...])
MakeView_V_MATERIALES_X_ALMACEN_3()
DisplayStatus([Creando vista V_MOVIMIENTOS_ALMACEN...])
MakeView_V_MOVIMIENTOS_ALMACEN()
DisplayStatus([Creando vista V_MATERIALES_X_LOTE...])
MakeView_V_MATERIALES_X_LOTE()

MakeView_V_REPORTE_GUIA()
MakeView_V_NOTAS_BALANCE()
DisplayStatus([Terminado.])

SET defa to (cPathDatos)
LsNomBdNew=LsNomBd
LsNomBd = SUBSTR(LsNomBdNew,1,4)+str(val(substr(Lsnombdnew,5))-1,4,0)
LsNomBd = 'P0012004'
********* Volver a crear el procedimiento *********
IF !FILE(LsNomBd+[.PRO])
	
    ? [¡Advertencia! No se ha encontrado ningún archivo de procedimientos.]
ELSE     
    OPEN DATABASE  (LsNomBd)
    COPY PROCEDURES TO LsNomBd+[.PRO]
    CLOSE DATABASES
    
ENDIF

*!*		CLOSE DATABASE
*!*		USE LsNomBdNew +'.DBC'
*!*		g_SetSafety = SET('SAFETY')
*!*		SET SAFETY OFF
*!*		LOCATE FOR Objectname = 'StoredProceduresSource'
*!*		IF FOUND()
*!*	        APPEND MEMO Code FROM LsNomBd+[.krt] OVERWRITE
*!*		    REPLACE Code WITH SUBSTR(Code, 87, 5496)
*!*		ENDIF
*!*		LOCATE FOR Objectname = 'StoredProceduresObject'
*!*		IF FOUND()
*!*	        APPEND MEMO Code FROM LsNomBd+[.krt] OVERWRITE
*!*	        REPLACE Code WITH SUBSTR(Code, 5583)
*!*		ENDIF
*!*	    SET SAFETY &g_SetSafety
*!*		USE
		OPEN DATABASE (LsNomBdNew)
		APPEND PROCEDURES FROM LsNomBd+[.PRO] OVERWRITE		




CLOSE DATA ALL
RETURN 

FUNCTION MakeTable_ALMCATAL
***** Configuración de tabla para ALMCATAL *****
CREATE TABLE 'ALMCATAL.DBF' NAME 'ALMCATAL' (CODSED C(3) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       FACEQU N(10, 4) NOT NULL, ;
                       CODUBI C(10) NOT NULL, ;
                       CODSEC C(5) NOT NULL, ;
                       STKACT N(14, 4) NOT NULL, ;
                       STKINV N(14, 4) NOT NULL, ;
                       STKFIS N(14, 4) NOT NULL, ;
                       STKREP N(14, 4) NOT NULL, ;
                       STKINI N(14, 4) NOT NULL, ;
                       PINIMN N(18, 6) NOT NULL, ;
                       PINIUS N(18, 6) NOT NULL, ;
                       PCTOMN N(16, 4) NOT NULL, ;
                       PCTOUS N(16, 4) NOT NULL, ;
                       FCHING D NOT NULL, ;
                       FCHSAL D NOT NULL, ;
                       FCHINV D NOT NULL, ;
                       SELINV C(1) NOT NULL, ;
                       ORDCMP C(6) NOT NULL, ;
                       VINIMN N(18, 6) NOT NULL, ;
                       VINIUS N(18, 6) NOT NULL, ;
                       VCTOMN N(18, 4) NOT NULL, ;
                       VCTOUS N(18, 4) NOT NULL, ;
                       STKM01 N(14, 4) NOT NULL, ;
                       STKM02 N(14, 4) NOT NULL, ;
                       STKM03 N(14, 4) NOT NULL, ;
                       STKM04 N(14, 4) NOT NULL, ;
                       STKM05 N(14, 4) NOT NULL, ;
                       STKM06 N(14, 4) NOT NULL, ;
                       STKM07 N(14, 4) NOT NULL, ;
                       STKM08 N(14, 4) NOT NULL, ;
                       STKM09 N(14, 4) NOT NULL, ;
                       STKM10 N(14, 4) NOT NULL, ;
                       STKM11 N(14, 4) NOT NULL, ;
                       STKM12 N(14, 4) NOT NULL, ;
                       STK01 N(14, 4) NOT NULL, ;
                       STK02 N(14, 4) NOT NULL, ;
                       STK03 N(14, 4) NOT NULL, ;
                       STK04 N(14, 4) NOT NULL, ;
                       STK05 N(14, 4) NOT NULL, ;
                       STK06 N(14, 4) NOT NULL, ;
                       STK07 N(14, 4) NOT NULL, ;
                       STK08 N(14, 4) NOT NULL, ;
                       STK09 N(14, 4) NOT NULL, ;
                       STK10 N(14, 4) NOT NULL, ;
                       STK11 N(14, 4) NOT NULL, ;
                       STK12 N(14, 4) NOT NULL, ;
                       VMN01 N(14, 4) NOT NULL, ;
                       VMN02 N(14, 4) NOT NULL, ;
                       VMN03 N(14, 4) NOT NULL, ;
                       VMN04 N(14, 4) NOT NULL, ;
                       VMN05 N(14, 4) NOT NULL, ;
                       VMN06 N(14, 4) NOT NULL, ;
                       VMN07 N(14, 4) NOT NULL, ;
                       VMN08 N(14, 4) NOT NULL, ;
                       VMN09 N(14, 4) NOT NULL, ;
                       VMN10 N(14, 4) NOT NULL, ;
                       VMN11 N(14, 4) NOT NULL, ;
                       VMN12 N(14, 4) NOT NULL, ;
                       VUS01 N(14, 4) NOT NULL, ;
                       VUS02 N(14, 4) NOT NULL, ;
                       VUS03 N(14, 4) NOT NULL, ;
                       VUS04 N(14, 4) NOT NULL, ;
                       VUS05 N(14, 4) NOT NULL, ;
                       VUS06 N(14, 4) NOT NULL, ;
                       VUS07 N(14, 4) NOT NULL, ;
                       VUS08 N(14, 4) NOT NULL, ;
                       VUS09 N(14, 4) NOT NULL, ;
                       VUS10 N(14, 4) NOT NULL, ;
                       VUS11 N(14, 4) NOT NULL, ;
                       VUS12 N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para ALMCATAL *****
SET COLLATE TO 'MACHINE'
INDEX ON CODMAT+SUBALM TAG CATA02 CANDIDATE
ALTER TABLE 'ALMCATAL' ADD PRIMARY KEY SUBALM+CODMAT TAG CATA01

***** Cambiar propiedades para ALMCATAL *****
ENDFUNC

FUNCTION MakeTable_CPIQO_TB
***** Configuración de tabla para CPIQO_TB *****
CREATE TABLE 'CPIQO_TB.DBF' NAME 'CPIQO_TB' (NRODOC C(10) NOT NULL, ;
                       FCHDOC T NOT NULL, ;
                       CODPAR C(8) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       H_INICIO T NOT NULL, ;
                       H_FIN T NOT NULL, ;
                       N_HORA C(20) NOT NULL)

***** Crear cada índice para CPIQO_TB *****
SET COLLATE TO 'MACHINE'
INDEX ON NRODOC TAG QO_T01

***** Cambiar propiedades para CPIQO_TB *****
ENDFUNC

FUNCTION MakeTable_ALMCDOCM
***** Configuración de tabla para ALMCDOCM *****
CREATE TABLE 'ALMCDOCM.DBF' NAME 'ALMCDOCM' (SUBALM C(3) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       DESDOC C(20) NOT NULL, ;
                       NRODOC N(10, 0) NOT NULL, ;
                       TIPMOV C(1) NOT NULL, ;
                       CODMOV C(3) NOT NULL, ;
                       CODFAM C(5) NOT NULL, ;
                       SIGLAS C(4) NOT NULL, ;
                       NDOC00 N(10, 0) NOT NULL, ;
                       NDOC01 N(10, 0) NOT NULL, ;
                       NDOC02 N(10, 0) NOT NULL, ;
                       NDOC03 N(10, 0) NOT NULL, ;
                       NDOC04 N(10, 0) NOT NULL, ;
                       NDOC05 N(10, 0) NOT NULL, ;
                       NDOC06 N(10, 0) NOT NULL, ;
                       NDOC07 N(10, 0) NOT NULL, ;
                       NDOC08 N(10, 0) NOT NULL, ;
                       NDOC09 N(10, 0) NOT NULL, ;
                       NDOC10 N(10, 0) NOT NULL, ;
                       NDOC11 N(10, 0) NOT NULL, ;
                       NDOC12 N(10, 0) NOT NULL, ;
                       NDOC13 N(10, 0) NOT NULL, ;
                       TIPPRO C(4) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       CAMPO_ID C(15) NOT NULL, ;
                       ANT_MES N(1, 0) NOT NULL, ;
                       ANT_SERIE N(1, 0) NOT NULL, ;
                       ANT_PTOVTA N(1, 0) NOT NULL, ;
                       VAR_SUF_ID C(10) NOT NULL, ;
                       EVAL_VALOR_PK M NOT NULL, ;
                       T_DESTINO C(30) NOT NULL)

***** Crear cada índice para ALMCDOCM *****
SET COLLATE TO 'MACHINE'
INDEX ON CODDOC TAG CDOC02
INDEX ON SUBALM+TIPMOV+CODFAM TAG CDOC03
ALTER TABLE 'ALMCDOCM' ADD PRIMARY KEY SUBALM+TIPMOV+CODMOV TAG CDOC01

***** Cambiar propiedades para ALMCDOCM *****
DBSETPROP('ALMCDOCM.T_DESTINO', 'Field', 'Comment', "Tabla destino")
ENDFUNC

FUNCTION MakeTable_ALMCFTRA
***** Configuración de tabla para ALMCFTRA *****
CREATE TABLE 'ALMCFTRA.DBF' NAME 'ALMCFTRA' (TIPMOV C(1) NOT NULL, ;
                       CODMOV C(3) NOT NULL, ;
                       DESMOV C(37) NOT NULL, ;
                       PIDRF1 L NOT NULL, ;
                       PIDRF2 L NOT NULL, ;
                       PIDRF3 L NOT NULL, ;
                       GLORF1 C(16) NOT NULL, ;
                       GLORF2 C(16) NOT NULL, ;
                       GLORF3 C(16) NOT NULL, ;
                       PIDVEN L NOT NULL, ;
                       PIDCLI L NOT NULL, ;
                       PIDPRO L NOT NULL, ;
                       PIDODT L NOT NULL, ;
                       PIDACTFIJO L NOT NULL, ;
                       PIDPCO L NOT NULL, ;
                       PIDPVT L NOT NULL, ;
                       MODPRE L NOT NULL, ;
                       STKNEG L NOT NULL, ;
                       UNDSTK L NOT NULL, ;
                       UNDVTA L NOT NULL, ;
                       UNDCMP L NOT NULL, ;
                       MODCSM L NOT NULL, ;
                       EXTPCO L NOT NULL, ;
                       MONNAC L NOT NULL, ;
                       MONUSA L NOT NULL, ;
                       MONELG L NOT NULL, ;
                       TRANSF L NOT NULL, ;
                       MOVPRO N(1, 0) NOT NULL, ;
                       CMPEVA C(30) NOT NULL, ;
                       EVALUA M NOT NULL, ;
                       PORP_T L NOT NULL, ;
                       CMPACT1 C(10) NOT NULL, ;
                       CMPACT2 C(10) NOT NULL, ;
                       CMPACT3 C(10) NOT NULL, ;
                       ORDPRO C(2) NOT NULL, ;
                       ORDEN C(3) NOT NULL, ;
                       TPORF1 C(4) NOT NULL, ;
                       TPORF2 C(4) NOT NULL, ;
                       TPORF3 C(4) NOT NULL, ;
                       CORR_U L NOT NULL, ;
                       VALCTB L NOT NULL, ;
                       AFETRA L NOT NULL, ;
                       PIDLOTE L NOT NULL, ;
                       PIDPROCESO L NOT NULL, ;
                       PIDACTIVID L NOT NULL, ;
                       PIDCULTIVO L NOT NULL, ;
                       PIDFASE L NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       CTOVTA L NOT NULL, ;
                       PIDMOT L NOT NULL, ;
                       ES_IMP L NOT NULL)

***** Crear cada índice para ALMCFTRA *****
SET COLLATE TO 'MACHINE'
INDEX ON ORDPRO+TIPMOV+CODMOV TAG CFTR02
INDEX ON ORDEN TAG CFTR03
INDEX ON TIPMOV+CODMOV TAG CFTR01 CANDIDATE

***** Cambiar propiedades para ALMCFTRA *****
DBSETPROP('ALMCFTRA.PIDMOT', 'Field', 'Caption', "Motivo")
ENDFUNC

FUNCTION MakeTable_ALMCTRAN
***** Configuración de tabla para ALMCTRAN *****
CREATE TABLE 'ALMCTRAN.DBF' NAME 'ALMCTRAN' (CODSED C(3) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       TIPMOV C(1) NOT NULL, ;
                       CODMOV C(3) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       ALMTRF C(3) NOT NULL, ;
                       ALMORI C(3) NOT NULL, ;
                       CODLOTE C(3) NOT NULL, ;
                       CODCULT C(8) NOT NULL, ;
                       CODFASE C(3) NOT NULL, ;
                       CODPROCS C(3) NOT NULL, ;
                       CODACTIV C(3) NOT NULL, ;
                       TPORF1 C(4) NOT NULL, ;
                       NRORF1 C(10) NOT NULL, ;
                       TPORF2 C(4) NOT NULL, ;
                       NRORF2 C(10) NOT NULL, ;
                       TPORF3 C(4) NOT NULL, ;
                       NRORF3 C(10) NOT NULL, ;
                       NROODT C(10) NOT NULL, ;
                       CODPRD C(8) NOT NULL, ;
                       CODPRO C(11) NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       CODDIRE C(3) NOT NULL, ;
                       CODVEN C(4) NOT NULL, ;
                       CODPAR C(8) NOT NULL, ;
                       OBSERV C(40) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(14, 4) NOT NULL, ;
                       IMPBRT N(14, 2) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       FLGFAC C(1) NOT NULL, ;
                       NROPED C(6) NOT NULL, ;
                       TPOCLI C(2) NOT NULL, ;
                       PLZVTO N(2, 0) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       TIPPRC N(1, 0) NOT NULL, ;
                       IMPDST N(16, 2) NOT NULL, ;
                       IMPIGV N(16, 2) NOT NULL, ;
                       CODOPE C(2) NOT NULL, ;
                       IMPTOT N(16, 2) NOT NULL, ;
                       PORIGV N(6, 2) NOT NULL, ;
                       USER C(10) NOT NULL, ;
                       FBATCH N(8, 4) NOT NULL, ;
                       CODTRA C(3) NOT NULL, ;
                       NOMTRA M NOT NULL, ;
                       DIRTRA M NOT NULL, ;
                       RUCTRA C(11) NOT NULL, ;
                       PLATRA C(10) NOT NULL, ;
                       MOTIVO N(1, 0) NOT NULL, ;
                       BREVET C(20) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para ALMCTRAN *****
SET COLLATE TO 'MACHINE'
INDEX ON NROODT+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA02 UNIQUE
INDEX ON CODPRO+DTOS(FCHDOC)+NRORF1+FLGFAC TAG CTRA04
INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA01
INDEX ON TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA03

***** Cambiar propiedades para ALMCTRAN *****
CREATE TRIGGER ON 'ALMCTRAN' FOR DELETE AS del_guia()
CREATE TRIGGER ON 'ALMCTRAN' FOR INSERT AS add_guia()
CREATE TRIGGER ON 'ALMCTRAN' FOR UPDATE AS upd_guia()
ENDFUNC

FUNCTION MakeTable_CBDDRMOV
***** Configuración de tabla para CBDDRMOV *****
CREATE TABLE 'CBDDRMOV.DBF' NAME 'CBDDRMOV' (MODULO C(5) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(14) NOT NULL, ;
                       GLOORI C(40) NOT NULL, ;
                       VCTORI D NOT NULL, ;
                       IMPORI F(12, 2) NOT NULL, ;
                       TIPORI C(2) NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       NUMORI C(10) NOT NULL, ;
                       N_POLIZA C(20) NOT NULL, ;
                       IMPNAC1 N(12, 2) NOT NULL, ;
                       IMPNAC2 N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       CTABAN C(8) NOT NULL, ;
                       DESTINO C(20) NOT NULL, ;
                       NROUNI C(15) NOT NULL, ;
                       DESBCO C(3) NOT NULL, ;
                       LETGIR C(10) NOT NULL, ;
                       REFGIR C(20) NOT NULL)

***** Crear cada índice para CBDDRMOV *****
SET COLLATE TO 'MACHINE'
INDEX ON MODULO+NROMES+CODOPE+NROAST+CODCTA+TIPDOC+NROREF TAG DRMO01
INDEX ON MODULO+NROMES+CODOPE+NROAST+CODCTA+CODDOC+NRODOC TAG DRMO02
INDEX ON MODULO+NROMES+CODOPE+NROAST+NRODOC+CODCTA TAG DRMO03

***** Cambiar propiedades para CBDDRMOV *****
ENDFUNC

FUNCTION MakeTable_CBDMPART
***** Configuración de tabla para CBDMPART *****
CREATE TABLE 'CBDMPART.DBF' NAME 'CBDMPART' (CODCTA C(8) NOT NULL, ;
                       CODPAR C(6) NOT NULL, ;
                       NOMPAR C(50) NOT NULL, ;
                       AGRUPA C(25) NOT NULL, ;
                       CCOSTO C(5) NOT NULL, ;
                       FEC_DEPR D NOT NULL, ;
                       FEC_INGR D NOT NULL, ;
                       FEC_CESE D NOT NULL, ;
                       VAL_COMP N(12, 2) NOT NULL, ;
                       VAL_COMPEX N(12, 2) NOT NULL, ;
                       VAL_ACTI N(12, 2) NOT NULL, ;
                       VAL_ACTIEX N(12, 2) NOT NULL, ;
                       DEP_ACUM N(12, 2) NOT NULL, ;
                       DEP_ACUMEX N(12, 2) NOT NULL, ;
                       AJU_ACTI N(12, 2) NOT NULL, ;
                       AJU_DEPR N(12, 2) NOT NULL, ;
                       VAL_BAJA N(12, 2) NOT NULL, ;
                       DEP_BAJA N(12, 2) NOT NULL, ;
                       EST_ACTI C(3) NOT NULL, ;
                       PORDPR N(6, 2) NOT NULL)

***** Crear cada índice para CBDMPART *****
SET COLLATE TO 'MACHINE'
INDEX ON CODCTA+CODPAR TAG PART01

***** Cambiar propiedades para CBDMPART *****
ENDFUNC

FUNCTION MakeTable_CBDRPART
***** Configuración de tabla para CBDRPART *****
CREATE TABLE 'CBDRPART.DBF' NAME 'CBDRPART' (CODCTA C(8) NOT NULL, ;
                       CODPAR C(6) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       FACTOR N(6, 3) NOT NULL, ;
                       VALAJT N(12, 2) NOT NULL, ;
                       VALAJTM N(12, 2) NOT NULL, ;
                       DPHISA N(12, 2) NOT NULL, ;
                       DPHISM N(12, 2) NOT NULL, ;
                       DPAJTA N(12, 2) NOT NULL, ;
                       DPAJTM N(12, 2) NOT NULL, ;
                       DPHISAEX N(12, 2) NOT NULL, ;
                       DPHISMEX N(12, 2) NOT NULL)

***** Crear cada índice para CBDRPART *****
SET COLLATE TO 'MACHINE'
INDEX ON CODCTA+CODPAR+NROMES TAG RPAR01
INDEX ON NROMES+CODCTA+CODPAR TAG RPAR02

***** Cambiar propiedades para CBDRPART *****
ENDFUNC

FUNCTION MakeTable_CBDTCIER
***** Configuración de tabla para CBDTCIER *****
CREATE TABLE 'CBDTCIER.DBF' NAME 'CBDTCIER' (CIERRE L NOT NULL, ;
                       CJABCO L NOT NULL, ;
                       OFIVTA N(10, 4) NOT NULL, ;
                       OFICMP N(10, 4) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para CBDTCIER *****

***** Cambiar propiedades para CBDTCIER *****
ENDFUNC

FUNCTION MakeTable_CBDTOPER
***** Configuración de tabla para CBDTOPER *****
CREATE TABLE 'CBDTOPER.DBF' NAME 'CBDTOPER' (CODOPE C(3) NOT NULL, ;
                       NOMOPE C(30) NOT NULL, ;
                       SIGLAS C(15) NOT NULL, ;
                       ORIGEN L NOT NULL, ;
                       CODUSR C(11) NOT NULL, ;
                       LIBROS L NOT NULL, ;
                       RESUME L NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(1, 0) NOT NULL, ;
                       TPOCOR N(1, 0) NOT NULL, ;
                       NDOC00 N(8, 0) NOT NULL, ;
                       NDOC01 N(8, 0) NOT NULL, ;
                       NDOC02 N(8, 0) NOT NULL, ;
                       NDOC03 N(8, 0) NOT NULL, ;
                       NDOC04 N(8, 0) NOT NULL, ;
                       NDOC05 N(8, 0) NOT NULL, ;
                       NDOC06 N(8, 0) NOT NULL, ;
                       NDOC07 N(8, 0) NOT NULL, ;
                       NDOC08 N(8, 0) NOT NULL, ;
                       NDOC09 N(8, 0) NOT NULL, ;
                       NDOC10 N(8, 0) NOT NULL, ;
                       NDOC11 N(8, 0) NOT NULL, ;
                       NDOC12 N(8, 0) NOT NULL, ;
                       NDOC13 N(8, 0) NOT NULL, ;
                       NRODOC N(8, 0) NOT NULL, ;
                       NROREL N(6, 0) NOT NULL, ;
                       CORR_U L NOT NULL, ;
                       T_DESTINO C(30) NOT NULL, ;
                       CAMPO_ID C(20) NOT NULL, ;
                       ANT_MES N(1, 0) NOT NULL, ;
                       ANT_SERIE N(1, 0) NOT NULL, ;
                       ANT_PTOVTA N(1, 0) NOT NULL, ;
                       VAR_SUF_ID C(10) NOT NULL, ;
                       EVAL_VALOR_PK M NOT NULL, ;
                       LEN_ID N(3, 0) NOT NULL, ;
                       MOVCJA N(1, 0) NOT NULL)

***** Crear cada índice para CBDTOPER *****
SET COLLATE TO 'MACHINE'
ALTER TABLE 'CBDTOPER' ADD PRIMARY KEY CODOPE TAG OPER01

***** Cambiar propiedades para CBDTOPER *****
ENDFUNC

FUNCTION MakeTable_CBDVMOVM
***** Configuración de tabla para CBDVMOVM *****
CREATE TABLE 'CBDVMOVM.DBF' NAME 'CBDVMOVM' (NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROVOU C(9) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       DIGITA C(10) NOT NULL, ;
                       CHKCTA N(12, 0) NOT NULL, ;
                       DBENAC N(12, 2) NOT NULL, ;
                       HBENAC N(12, 2) NOT NULL, ;
                       DBEUSA N(12, 2) NOT NULL, ;
                       HBEUSA N(12, 2) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       CTACJA C(8) NOT NULL, ;
                       GIRADO C(40) NOT NULL, ;
                       NROCHQ C(15) NOT NULL, ;
                       IMPCHQ N(12, 2) NOT NULL, ;
                       AUXIL C(11) NOT NULL, ;
                       GLOAST M NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL, ;
                       FCHPED D NOT NULL, ;
                       FCHENT D NOT NULL)

***** Crear cada índice para CBDVMOVM *****
SET COLLATE TO 'MACHINE'
INDEX ON NROMES+CODOPE+NROVOU TAG VMOV02
INDEX ON NROMES+DTOS(FCHAST) TAG VMOV04
INDEX ON NROMES+CODOPE+DTOC(FCHAST,1)+NROAST TAG VMOV03
INDEX ON NROMES+CODOPE+NROAST TAG VMOV01

***** Cambiar propiedades para CBDVMOVM *****
ENDFUNC

FUNCTION MakeTable_CPICDOCM
***** Configuración de tabla para CPICDOCM *****
CREATE TABLE 'CPICDOCM.DBF' NAME 'CPICDOCM' (CODCIA C(3) NOT NULL, ;
                       CODSED C(3) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       SERIE C(3) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       TPODOC C(5) NOT NULL, ;
                       INTEST L NOT NULL, ;
                       NRODOC N(10, 0) NOT NULL, ;
                       NUM_ORDREQ N(10, 0) NOT NULL, ;
                       CAMPO_ID C(20) NOT NULL CHECK len_id(), ;
                       ANT_MES N(1, 0) NOT NULL, ;
                       ANT_SERIE N(1, 0) NOT NULL, ;
                       ANT_PTOVTA N(1, 0) NOT NULL, ;
                       CORR_U L NOT NULL, ;
                       VAR_SUF_ID C(10) NOT NULL, ;
                       EVAL_VALOR_PK M NOCPTRANS NOT NULL, ;
                       T_DESTINO C(30) NOT NULL, ;
                       LEN_ID N(3, 0) NOT NULL, ;
                       NDOC00 N(10, 0) NOT NULL, ;
                       NDOC01 N(10, 0) NOT NULL, ;
                       NDOC02 N(10, 0) NOT NULL, ;
                       NDOC03 N(10, 0) NOT NULL, ;
                       NDOC04 N(10, 0) NOT NULL, ;
                       NDOC05 N(10, 0) NOT NULL, ;
                       NDOC06 N(10, 0) NOT NULL, ;
                       NDOC07 N(10, 0) NOT NULL, ;
                       NDOC08 N(10, 0) NOT NULL, ;
                       NDOC09 N(10, 0) NOT NULL, ;
                       NDOC10 N(10, 0) NOT NULL, ;
                       NDOC11 N(10, 0) NOT NULL, ;
                       NDOC12 N(10, 0) NOT NULL, ;
                       NDOC13 N(10, 0) NOT NULL)

***** Create each index for CPICDOCM *****
INDEX ON CODCIA+CODSED+CODDOC TAG CDOC01 CANDIDATE COLLATE 'MACHINE'

***** Cambiar propiedades para CPICDOCM *****
ENDFUNC

FUNCTION MakeTable_CPICO_TB
***** Configuración de tabla para CPICO_TB *****
CREATE TABLE 'CPICO_TB.DBF' NAME 'CPICO_TB' (NRODOC C(10) NOT NULL, ;
                       CODFASE C(3) NOT NULL, ;
                       CODPROCS C(3) NOT NULL, ;
                       CODACTIV C(3) NOT NULL, ;
                       CODLOTE C(3) NOT NULL, ;
                       CODCULT C(8) NOT NULL, ;
                       CODPRO C(8) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHFIN D NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       CANOBJ N(14, 3) NOT NULL, ;
                       CANFIN N(14, 3) NOT NULL, ;
                       RESPON C(10) NOT NULL, ;
                       CDAREA C(2) NOT NULL, ;
                       FACTOR N(6, 2) NOT NULL, ;
                       CANFINA N(14, 3) NOT NULL, ;
                       FCHFINA D NOT NULL, ;
                       VFORM1D01 N(14, 4) NOT NULL, ;
                       VFORM1D02 N(14, 4) NOT NULL, ;
                       VBATC1D01 N(14, 4) NOT NULL, ;
                       VBATC1D02 N(14, 4) NOT NULL, ;
                       VMERM1D01 N(14, 4) NOT NULL, ;
                       VMERM1D02 N(14, 4) NOT NULL, ;
                       VFORM2D01 N(14, 4) NOT NULL, ;
                       VFORM2D02 N(14, 4) NOT NULL, ;
                       VBATC2D01 N(14, 4) NOT NULL, ;
                       VBATC2D02 N(14, 4) NOT NULL, ;
                       VMERM2D01 N(14, 4) NOT NULL, ;
                       VMERM2D02 N(14, 4) NOT NULL, ;
                       VFORL1D01 N(14, 4) NOT NULL, ;
                       VFORL1D02 N(14, 4) NOT NULL, ;
                       VBATL1D01 N(14, 4) NOT NULL, ;
                       VBATL1D02 N(14, 4) NOT NULL, ;
                       VMERL1D01 N(14, 4) NOT NULL, ;
                       VMERL1D02 N(14, 4) NOT NULL, ;
                       VFORL2D01 N(14, 4) NOT NULL, ;
                       VFORL2D02 N(14, 4) NOT NULL, ;
                       VBATL2D01 N(14, 4) NOT NULL, ;
                       VBATL2D02 N(14, 4) NOT NULL, ;
                       VMERL2D01 N(14, 4) NOT NULL, ;
                       VMERL2D02 N(14, 4) NOT NULL, ;
                       VDEVOMN N(14, 4) NOT NULL, ;
                       VDEVOUS N(14, 4) NOT NULL, ;
                       VDEVLMN N(14, 4) NOT NULL, ;
                       VDEVLUS N(14, 4) NOT NULL, ;
                       EFICIE N(8, 2) NOT NULL, ;
                       TIPO N(1, 0) NOT NULL, ;
                       TIPBAT N(1, 0) NOT NULL, ;
                       CODNEW C(8) NOT NULL)

***** Crear cada índice para CPICO_TB *****
SET COLLATE TO 'MACHINE'
INDEX ON CODPRO+DTOS(FCHDOC) TAG CO_T03
INDEX ON DTOS(FCHDOC)+CODPRO TAG CO_T02
INDEX ON CODLOTE+CODCULT+DTOS(FCHDOC) TAG CO_T04
INDEX ON LEFT(NRODOC,3)+CODACTIV+DTOS(FCHDOC) TAG CO_T05
ALTER TABLE 'CPICO_TB' ADD PRIMARY KEY NRODOC TAG CO_T01

***** Cambiar propiedades para CPICO_TB *****
ENDFUNC

FUNCTION MakeTable_CPICULTI
***** Configuración de tabla para CPICULTI *****
CREATE TABLE 'CPICULTI.DBF' NAME 'CPICULTI' (CODCULT C(8) NOT NULL, ;
                       DESCULT C(30) NOT NULL, ;
                       DESCORT C(17) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       CODCULT1 C(8) NOT NULL, ;
                       VMN01 N(14, 4) NOT NULL, ;
                       VMN02 N(14, 4) NOT NULL, ;
                       VMN03 N(14, 4) NOT NULL, ;
                       VMN04 N(14, 4) NOT NULL, ;
                       VMN05 N(14, 4) NOT NULL, ;
                       VMN06 N(14, 4) NOT NULL, ;
                       VMN07 N(14, 4) NOT NULL, ;
                       VMN08 N(14, 4) NOT NULL, ;
                       VMN09 N(14, 4) NOT NULL, ;
                       VMN10 N(14, 4) NOT NULL, ;
                       VMN11 N(14, 4) NOT NULL, ;
                       VMN12 N(14, 4) NOT NULL, ;
                       VUS01 N(14, 4) NOT NULL, ;
                       VUS02 N(14, 4) NOT NULL, ;
                       VUS03 N(14, 4) NOT NULL, ;
                       VUS04 N(14, 4) NOT NULL, ;
                       VUS05 N(14, 4) NOT NULL, ;
                       VUS06 N(14, 4) NOT NULL, ;
                       VUS07 N(14, 4) NOT NULL, ;
                       VUS08 N(14, 4) NOT NULL, ;
                       VUS09 N(14, 4) NOT NULL, ;
                       VUS10 N(14, 4) NOT NULL, ;
                       VUS11 N(14, 4) NOT NULL, ;
                       VUS12 N(14, 4) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para CPICULTI *****
SET COLLATE TO 'MACHINE'
INDEX ON UPPER(DESCULT) TAG CULT02
INDEX ON CODCULT1 TAG CULT03 CANDIDATE
INDEX ON CODCULT TAG CULT01 CANDIDATE

***** Cambiar propiedades para CPICULTI *****
ENDFUNC

FUNCTION MakeTable_CPICUXLT
***** Configuración de tabla para CPICUXLT *****
CREATE TABLE 'CPICUXLT.DBF' NAME 'CPICUXLT' (CODSED C(3) NOT NULL, ;
                       CODLOTE C(3) NOT NULL, ;
                       CODCULT C(8) NOT NULL, ;
                       CODCULT1 C(8) NOT NULL, ;
                       AREACULT N(10, 2) NOT NULL, ;
                       NROPLANTA N(10, 0) NOT NULL, ;
                       DISTPLANTA C(15) NOT NULL, ;
                       FCHSIEMB1 D NOT NULL, ;
                       FCHSIEMB2 D NOT NULL, ;
                       TIPOCULT N(1, 0) NOT NULL, ;
                       VINIMN N(18, 6) NOT NULL, ;
                       VINIUS N(18, 6) NOT NULL, ;
                       VCTOMN N(18, 6) NOT NULL, ;
                       VCTOUS N(18, 6) NOT NULL, ;
                       VMN01 N(14, 4) NOT NULL, ;
                       VMN02 N(14, 4) NOT NULL, ;
                       VMN03 N(14, 4) NOT NULL, ;
                       VMN04 N(14, 4) NOT NULL, ;
                       VMN05 N(14, 4) NOT NULL, ;
                       VMN06 N(14, 4) NOT NULL, ;
                       VMN07 N(14, 4) NOT NULL, ;
                       VMN08 N(14, 4) NOT NULL, ;
                       VMN09 N(14, 4) NOT NULL, ;
                       VMN10 N(14, 4) NOT NULL, ;
                       VMN11 N(14, 4) NOT NULL, ;
                       VMN12 N(14, 4) NOT NULL, ;
                       VUS01 N(14, 4) NOT NULL, ;
                       VUS02 N(14, 4) NOT NULL, ;
                       VUS03 N(14, 4) NOT NULL, ;
                       VUS04 N(14, 4) NOT NULL, ;
                       VUS05 N(14, 4) NOT NULL, ;
                       VUS06 N(14, 4) NOT NULL, ;
                       VUS07 N(14, 4) NOT NULL, ;
                       VUS08 N(14, 4) NOT NULL, ;
                       VUS09 N(14, 4) NOT NULL, ;
                       VUS10 N(14, 4) NOT NULL, ;
                       VUS11 N(14, 4) NOT NULL, ;
                       VUS12 N(14, 4) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para CPICUXLT *****
SET COLLATE TO 'MACHINE'
INDEX ON CODCULT+CODLOTE TAG CUXLT02 UNIQUE
INDEX ON CODLOTE+CODCULT1 TAG CUXLT03 CANDIDATE
INDEX ON CODLOTE+CODCULT TAG CUXLT01 CANDIDATE

***** Cambiar propiedades para CPICUXLT *****
ENDFUNC

FUNCTION MakeTable_CPIDO_TB
***** Configuración de tabla para CPIDO_TB *****
CREATE TABLE 'CPIDO_TB.DBF' NAME 'CPIDO_TB' (NRODOC C(10) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       TIPPRO C(3) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       NROITM C(3) NOT NULL, ;
                       CANSAL N(14, 4) NOT NULL, ;
                       CANFOR N(14, 4) NOT NULL, ;
                       CANADI N(14, 4) NOT NULL, ;
                       CANDEV N(14, 4) NOT NULL, ;
                       UNDPRO C(3) NOT NULL, ;
                       FACEQU N(14, 6) NOT NULL, ;
                       LOTE N(6, 0) NOT NULL, ;
                       CANFORA N(14, 4) NOT NULL, ;
                       CANADIA N(14, 4) NOT NULL, ;
                       CANDEVA N(14, 4) NOT NULL, ;
                       CANSALA N(14, 4) NOT NULL, ;
                       STKFOR L NOT NULL, ;
                       STKADI L NOT NULL, ;
                       FLGFOR L NOT NULL, ;
                       FLGADI L NOT NULL, ;
                       FLGDEV L NOT NULL, ;
                       CODFOR C(14) NOT NULL, ;
                       CODADI C(14) NOT NULL, ;
                       CODDEV C(14) NOT NULL, ;
                       CODSAL C(14) NOT NULL, ;
                       NROGUIA C(10) NOT NULL, ;
                       FLGSAL L NOT NULL, ;
                       STKSAL L NOT NULL, ;
                       CNFMLA N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Crear cada índice para CPIDO_TB *****
SET COLLATE TO 'MACHINE'
INDEX ON CODMAT TAG DO_T05
INDEX ON NRODOC+TIPPRO+SUBALM+CODMAT TAG DO_T01
INDEX ON NRODOC+CODPRO+SUBALM+CODMAT TAG DO_T02
INDEX ON DTOS(FCHDOC)+NRODOC+CODPRO+SUBALM+CODMAT TAG DO_T03

***** Cambiar propiedades para CPIDO_TB *****
ENDFUNC

FUNCTION MakeTable_CPIMO_TB
***** Configuración de tabla para CPIMO_TB *****
CREATE TABLE 'CPIMO_TB.DBF' NAME 'CPIMO_TB' (NRODOC C(10) NOT NULL, ;
                       FCHDOC T NOT NULL, ;
                       CODPERS C(6) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       HN_ENTRADA T NOT NULL, ;
                       HN_SALIDA T NOT NULL, ;
                       HE_ENTRADA T NOT NULL, ;
                       HE_SALIDA T NOT NULL, ;
                       H_NORMAL C(8) NOT NULL, ;
                       H_EXTRA C(8) NOT NULL, ;
                       COST_HN N(14, 2) NOT NULL, ;
                       COST_HE N(14, 2) NOT NULL)

***** Crear cada índice para CPIMO_TB *****
SET COLLATE TO 'MACHINE'
INDEX ON NRODOC TAG MO_T01

***** Cambiar propiedades para CPIMO_TB *****
ENDFUNC

FUNCTION MakeTable_CPIPO_TB
***** Configuración de tabla para CPIPO_TB *****
CREATE TABLE 'CPIPO_TB.DBF' NAME 'CPIPO_TB' (NRODOC C(10) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       SUBALMA C(3) NOT NULL, ;
                       CODPRD C(13) NOT NULL, ;
                       CODPRDA C(13) NOT NULL, ;
                       FCHFIN D NOT NULL, ;
                       CANFIN N(14, 4) NOT NULL, ;
                       CANFINA N(14, 4) NOT NULL, ;
                       FLGALM L NOT NULL, ;
                       CODP_T C(14) NOT NULL, ;
                       COSTMN N(14, 2) NOT NULL, ;
                       COSTUS N(14, 2) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Crear cada índice para CPIPO_TB *****
SET COLLATE TO 'MACHINE'
INDEX ON SUBALM+DTOS(FCHFIN)+CODPRD TAG PO_T02
INDEX ON CODPRD TAG PO_T04
INDEX ON NRODOC+SUBALM+CODPRD+DTOS(FCHFIN) TAG PO_T01
INDEX ON CODPRDA TAG PO_T03

***** Cambiar propiedades para CPIPO_TB *****
ENDFUNC

FUNCTION MakeTable_CBDMCTAS
***** Configuración de tabla para CBDMCTAS *****
CREATE TABLE 'CBDMCTAS.DBF' NAME 'CBDMCTAS' (CODCTA C(8) NOT NULL, ;
                       NOMCTA C(40) NOT NULL, ;
                       NIVCTA N(1, 0) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       AFTMOV C(1) NOT NULL, ;
                       AFTDCB C(1) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(1, 0) NOT NULL, ;
                       TPOCTA N(1, 0) NOT NULL, ;
                       PIDAUX C(1) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       PIDDOC C(1) NOT NULL, ;
                       PIDCCO C(1) NOT NULL, ;
                       CODDOC C(3) NOT NULL, ;
                       CIERES C(1) NOT NULL, ;
                       GENAUT C(1) NOT NULL, ;
                       AN1CTA C(8) NOT NULL, ;
                       CC1CTA C(8) NOT NULL, ;
                       AN2CTA C(8) NOT NULL, ;
                       CC2CTA C(8) NOT NULL, ;
                       CODREF C(5) NOT NULL, ;
                       NROCTA C(16) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       PIDGLO C(1) NOT NULL, ;
                       MAYAUX C(1) NOT NULL, ;
                       MAYCCO C(1) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       SECBCO C(30) NOT NULL, ;
                       REFBCO C(10) NOT NULL, ;
                       TPOGTO C(3) NOT NULL, ;
                       FLGBCO C(1) NOT NULL, ;
                       CTACJA C(1) NOT NULL, ;
                       PORCEN N(5, 2) NOT NULL, ;
                       CCTDEF L NOT NULL, ;
                       AN1_SUBCTA L NOT NULL, ;
                       CC1_SUBCTA L NOT NULL, ;
                       TIP_AFE_RV C(1) NOT NULL, ;
                       TIP_AFE_RC C(1) NOT NULL, ;
                       CTACOB C(8) NOT NULL, ;
                       CTADES C(8) NOT NULL)

***** Crear cada índice para CBDMCTAS *****
SET COLLATE TO 'MACHINE'
INDEX ON AN1CTA+CODCTA TAG AN1CTA
INDEX ON CODCTA TAG CTAS01
INDEX ON STR(NIVCTA,1)+CODCTA TAG CTAS02
INDEX ON AFTMOV+PIDAUX+CLFAUX TAG CTAS03
INDEX ON TPOGTO TAG TPOGTO

***** Cambiar propiedades para CBDMCTAS *****
DBSETPROP('CBDMCTAS.CCTDEF', 'Field', 'Caption', "Ctr. Cta.Def.")
DBSETPROP('CBDMCTAS.CCTDEF', 'Field', 'Comment', "Contra cuenta por defecto" + CHR(13) + "")
DBSETPROP('CBDMCTAS.TIP_AFE_RV', 'Field', 'Comment', "'N'o gravado" + CHR(13) + "'A' Afecto igv" + CHR(13) + "'G'ravado destinado a ventas gravadas" + CHR(13) + "'I' nafecto" + CHR(13) + "   ")
ENDFUNC

FUNCTION MakeTable_FCJCROPL
***** Configuración de tabla para FCJCROPL *****
CREATE TABLE 'FCJCROPL.DBF' NAME 'FCJCROPL' (TNGAUX C(2) NOT NULL, ;
                       TNGDES C(50) NOT NULL, ;
                       TMN01 N(14, 2) NOT NULL, ;
                       TMN02 N(14, 2) NOT NULL, ;
                       TUS01 N(14, 2) NOT NULL, ;
                       TUS02 N(14, 2) NOT NULL, ;
                       TOT01 N(14, 2) NOT NULL, ;
                       TOT02 N(14, 2) NOT NULL, ;
                       TMN03 N(14, 2) NOT NULL, ;
                       TMN04 N(14, 2) NOT NULL, ;
                       TUS03 N(14, 2) NOT NULL, ;
                       TUS04 N(14, 2) NOT NULL, ;
                       TOT03 N(14, 2) NOT NULL, ;
                       TOT04 N(14, 2) NOT NULL, ;
                       TMN05 N(14, 2) NOT NULL, ;
                       TMN06 N(14, 2) NOT NULL, ;
                       TUS05 N(14, 2) NOT NULL, ;
                       TUS06 N(14, 2) NOT NULL, ;
                       TOT05 N(14, 2) NOT NULL, ;
                       TOT06 N(14, 2) NOT NULL, ;
                       TMN07 N(14, 2) NOT NULL, ;
                       TMN08 N(14, 2) NOT NULL, ;
                       TUS07 N(14, 2) NOT NULL, ;
                       TUS08 N(14, 2) NOT NULL, ;
                       TOT07 N(14, 2) NOT NULL, ;
                       TOT08 N(14, 2) NOT NULL, ;
                       TMN09 N(14, 2) NOT NULL, ;
                       TMN10 N(14, 2) NOT NULL, ;
                       TUS09 N(14, 2) NOT NULL, ;
                       TUS10 N(14, 2) NOT NULL, ;
                       TOT09 N(14, 2) NOT NULL, ;
                       TOT10 N(14, 2) NOT NULL, ;
                       TMN11 N(14, 2) NOT NULL, ;
                       TMN12 N(14, 2) NOT NULL, ;
                       TUS11 N(14, 2) NOT NULL, ;
                       TUS12 N(14, 2) NOT NULL, ;
                       TOT11 N(14, 2) NOT NULL, ;
                       TOT12 N(14, 2) NOT NULL)

***** Crear cada índice para FCJCROPL *****
SET COLLATE TO 'MACHINE'
INDEX ON TNGAUX TAG CROP01

***** Cambiar propiedades para FCJCROPL *****
ENDFUNC

FUNCTION MakeTable_FCJTCPLA
***** Configuración de tabla para FCJTCPLA *****
CREATE TABLE 'FCJTCPLA.DBF' NAME 'FCJTCPLA' (TNGAUX C(2) NOT NULL, ;
                       TNGDES C(50) NOT NULL, ;
                       ENE_MN N(14, 2) NOT NULL, ;
                       ENE_US N(14, 2) NOT NULL, ;
                       ENE_TOT N(14, 2) NOT NULL, ;
                       FEB_MN N(14, 2) NOT NULL, ;
                       FEB_US N(14, 2) NOT NULL, ;
                       FEB_TOT N(14, 2) NOT NULL, ;
                       MAR_MN N(14, 2) NOT NULL, ;
                       MAR_US N(14, 2) NOT NULL, ;
                       MAR_TOT N(14, 2) NOT NULL, ;
                       ABR_MN N(14, 2) NOT NULL, ;
                       ABR_US N(14, 2) NOT NULL, ;
                       ABR_TOT N(14, 2) NOT NULL, ;
                       MAY_MN N(14, 2) NOT NULL, ;
                       MAY_US N(14, 2) NOT NULL, ;
                       MAY_TOT N(14, 2) NOT NULL, ;
                       JUN_MN N(14, 2) NOT NULL, ;
                       JUN_US N(14, 2) NOT NULL, ;
                       JUN_TOT N(14, 2) NOT NULL, ;
                       JUL_MN N(14, 2) NOT NULL, ;
                       JUL_US N(14, 2) NOT NULL, ;
                       JUL_TOT N(14, 2) NOT NULL, ;
                       AGO_MN N(14, 2) NOT NULL, ;
                       AGO_US N(14, 2) NOT NULL, ;
                       AGO_TOT N(14, 2) NOT NULL, ;
                       SET_MN N(14, 2) NOT NULL, ;
                       SET_US N(14, 2) NOT NULL, ;
                       SET_TOT N(14, 2) NOT NULL, ;
                       OCT_MN N(14, 2) NOT NULL, ;
                       OCT_US N(14, 2) NOT NULL, ;
                       OCT_TOT N(14, 2) NOT NULL, ;
                       NOV_MN N(14, 2) NOT NULL, ;
                       NOV_US N(14, 2) NOT NULL, ;
                       NOV_TOT N(14, 2) NOT NULL, ;
                       DIC_MN N(14, 2) NOT NULL, ;
                       DIC_US N(14, 2) NOT NULL, ;
                       DIC_TOT N(14, 2) NOT NULL, ;
                       TOT_MN N(14, 2) NOT NULL, ;
                       TOT_US N(14, 2) NOT NULL, ;
                       TOT_GEN N(14, 2) NOT NULL)

***** Crear cada índice para FCJTCPLA *****
SET COLLATE TO 'MACHINE'
INDEX ON TNGAUX TAG CPLA01

***** Cambiar propiedades para FCJTCPLA *****
ENDFUNC

FUNCTION MakeTable_FLCJDOCC
***** Configuración de tabla para FLCJDOCC *****
CREATE TABLE 'FLCJDOCC.DBF' NAME 'FLCJDOCC' (TIPDOC C(4) NOT NULL, ;
                       NDOC00 N(6, 0) NOT NULL, ;
                       NDOC01 N(6, 0) NOT NULL, ;
                       NDOC02 N(6, 0) NOT NULL, ;
                       NDOC03 N(6, 0) NOT NULL, ;
                       NDOC04 N(6, 0) NOT NULL, ;
                       NDOC05 N(6, 0) NOT NULL, ;
                       NDOC06 N(6, 0) NOT NULL, ;
                       NDOC07 N(6, 0) NOT NULL, ;
                       NDOC08 N(6, 0) NOT NULL, ;
                       NDOC09 N(6, 0) NOT NULL, ;
                       NDOC10 N(6, 0) NOT NULL, ;
                       NDOC11 N(6, 0) NOT NULL, ;
                       NDOC12 N(6, 0) NOT NULL, ;
                       NDOC13 N(6, 0) NOT NULL, ;
                       NRODOC N(6, 0) NOT NULL)

***** Crear cada índice para FLCJDOCC *****
SET COLLATE TO 'MACHINE'
INDEX ON TIPDOC TAG DOCC01

***** Cambiar propiedades para FLCJDOCC *****
ENDFUNC

FUNCTION MakeTable_FLCLIQUI
***** Configuración de tabla para FLCLIQUI *****
CREATE TABLE 'FLCLIQUI.DBF' NAME 'FLCLIQUI' (FCHACT D NOT NULL, ;
                       USUARIO C(10) NOT NULL, ;
                       NROLIQ C(6) NOT NULL, ;
                       CMBDIA N(8, 4) NOT NULL, ;
                       TPOOPC C(2) NOT NULL, ;
                       FCHINI D NOT NULL, ;
                       FCHFIN D NOT NULL, ;
                       ESTLIQ C(1) NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL)

***** Crear cada índice para FLCLIQUI *****
SET COLLATE TO 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ TAG LIQU01
INDEX ON USUARIO+DTOS(FCHACT)+NROLIQ TAG LIQU02

***** Cambiar propiedades para FLCLIQUI *****
ENDFUNC

FUNCTION MakeTable_ALMDLOTE
***** Configuración de tabla para ALMDLOTE *****
CREATE TABLE 'ALMDLOTE.DBF' NAME 'ALMDLOTE' (CODSED C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       LOTE C(15) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       STKSUB N(14, 4) NOT NULL, ;
                       STKACT N(14, 4) NOT NULL, ;
                       STKINI N(14, 4) NOT NULL, ;
                       STK01 N(14, 4) NOT NULL, ;
                       STK02 N(14, 4) NOT NULL, ;
                       STK03 N(14, 4) NOT NULL, ;
                       STK04 N(14, 4) NOT NULL, ;
                       STK05 N(14, 4) NOT NULL, ;
                       STK06 N(14, 4) NOT NULL, ;
                       STK07 N(14, 4) NOT NULL, ;
                       STK08 N(14, 4) NOT NULL, ;
                       STK09 N(14, 4) NOT NULL, ;
                       STK10 N(14, 4) NOT NULL, ;
                       STK11 N(14, 4) NOT NULL, ;
                       STK12 N(14, 4) NOT NULL)

***** Crear cada índice para ALMDLOTE *****
SET COLLATE TO 'MACHINE'
INDEX ON CODSED+SUBALM+CODMAT+LOTE+DTOS(FCHVTO) TAG DLOTE01
INDEX ON CODMAT+LOTE+DTOS(FCHVTO) TAG DLOTE02
INDEX ON CODSED+SUBALM+CODMAT+DTOS(FCHVTO) TAG DLOTE03

***** Cambiar propiedades para ALMDLOTE *****
ENDFUNC

FUNCTION MakeTable_ALMDTRAN
***** Configuración de tabla para ALMDTRAN *****
CREATE TABLE 'ALMDTRAN.DBF' NAME 'ALMDTRAN' (CODSED C(3) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       ALMTRF C(3) NOT NULL, ;
                       ALMORI C(3) NOT NULL, ;
                       TIPMOV C(1) NOT NULL, ;
                       CODMOV C(3) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       NRO_ITM N(3, 0) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       CODPRO C(11) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       TPOREQ C(1) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CODPRD C(13) NOT NULL, ;
                       CANDES N(14, 4) NOT NULL, ;
                       CANREC N(14, 4) NOT NULL, ;
                       LOTE C(15) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       CANDEV N(14, 4) NOT NULL, ;
                       CNFMLA N(14, 4) NOT NULL, ;
                       FACTOR N(7, 4) NOT NULL, ;
                       PREUNI N(16, 4) NOT NULL, ;
                       IMPCTO N(14, 4) NOT NULL, ;
                       STKSUB N(16, 4) NOT NULL, ;
                       STKACT N(16, 4) NOT NULL, ;
                       CODAJT C(1) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       TPOREF C(4) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       TPORFB C(4) NOT NULL, ;
                       NRORFB C(10) NOT NULL, ;
                       NROREF2 C(10) NOT NULL, ;
                       IMPNAC N(16, 4) NOT NULL, ;
                       IMPUSA N(16, 4) NOT NULL, ;
                       VCTOMN N(16, 4) NOT NULL, ;
                       VCTOUS N(16, 4) NOT NULL, ;
                       USER C(10) NOT NULL, ;
                       FBATCH N(8, 4) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(6) NOT NULL, ;
                       ANOAST C(4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(8) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       NROREG_1 N(10, 0) NOT NULL CHECK num_registro() DEFAULT RECNO(), ;
                       D1 N(5, 2) NOT NULL, ;
                       D2 N(5, 2) NOT NULL, ;
                       D3 N(5, 2) NOT NULL, ;
                       PREC_CIF N(14, 4) NOT NULL, ;
                       FACT_IMP N(10, 4) NOT NULL)

***** Crear cada índice para ALMDTRAN *****
SET COLLATE TO 'MACHINE'
INDEX ON SUBALM+CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA02
INDEX ON CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA03
INDEX ON TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC TAG DTRA04
INDEX ON SUBALM+TIPMOV+CODMOV+CODMAT+NRODOC+DTOS(FCHDOC) TAG DTRA05
INDEX ON TIPMOV+CODMOV+CODMAT+DTOS(FCHDOC) TAG DTRA06
INDEX ON ALMORI+SUBALM+TIPMOV+CODMOV+NRODOC+CODMAT TAG DTRA07
INDEX ON CODOPE+NROAST+ANOAST+TPORFB+NRORFB+TPOREF+NROREF+CODMAT TAG DTRA08
INDEX ON DTOS(FCHDOC)+CODMAT+TIPMOV+CODMOV+NRODOC TAG DTRA10
INDEX ON CODSED+CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA09
INDEX ON CODPRD TAG DTRA11
INDEX ON LOTE TAG DTRA12
INDEX ON TIPMOV+CODMOV+NROREF TAG DTRA13
INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0) TAG DTRA01

***** Cambiar propiedades para ALMDTRAN *****
ENDFUNC

FUNCTION MakeTable_ALMCATGE
***** Configuración de tabla para ALMCATGE *****
CREATE TABLE 'ALMCATGE.DBF' NAME 'ALMCATGE' (CODMAT C(13) NOT NULL, ;
                       CODEQU C(8) NOT NULL, ;
                       CODREF C(10) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       DESMAT2 C(20) NOT NULL, ;
                       CODAGR C(8) NOT NULL, ;
                       MARCA C(25) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       UNDCMP C(3) NOT NULL, ;
                       FACEQU N(10, 4) NOT NULL, ;
                       PMAXMN N(18, 6) NOT NULL, ;
                       PMAXUS N(18, 6) NOT NULL, ;
                       PCTOMN N(18, 6) NOT NULL, ;
                       PCTOUS N(18, 6) NOT NULL, ;
                       PULTMN N(18, 6) NOT NULL, ;
                       PULTUS N(18, 6) NOT NULL, ;
                       CODPR1 C(6) NOT NULL, ;
                       CODPR2 C(6) NOT NULL, ;
                       FCHALZ D NOT NULL, ;
                       ULTCMP D NOT NULL, ;
                       ULTSAL D NOT NULL, ;
                       STKACT N(14, 4) NOT NULL, ;
                       STKINI N(14, 4) NOT NULL, ;
                       PINIMN N(18, 6) NOT NULL, ;
                       PINIUS N(18, 6) NOT NULL, ;
                       STKREP N(14, 4) NOT NULL, ;
                       STKMAX N(14, 4) NOT NULL, ;
                       VOLPED N(14, 4) NOT NULL, ;
                       TMPREP N(9, 0) NOT NULL, ;
                       STKSEG N(9, 0) NOT NULL, ;
                       PESO N(14, 4) NOT NULL, ;
                       TPOEMB N(4, 0) NOT NULL, ;
                       TL_PTO N(4, 0) NOT NULL, ;
                       TIPMAT C(2) NOT NULL, ;
                       EQMAT1 C(8) NOT NULL, ;
                       EQMAT2 C(8) NOT NULL, ;
                       EQMAT3 C(8) NOT NULL, ;
                       EQMAT4 C(8) NOT NULL, ;
                       EQMAT5 C(8) NOT NULL, ;
                       EQMAT6 C(8) NOT NULL, ;
                       EQMAT7 C(8) NOT NULL, ;
                       EQMAT8 C(8) NOT NULL, ;
                       EQMAT9 C(8) NOT NULL, ;
                       EQMAT10 C(8) NOT NULL, ;
                       STKMIN N(14, 4) NOT NULL, ;
                       VINIMN N(18, 6) NOT NULL, ;
                       VINIUS N(18, 6) NOT NULL, ;
                       CODSEC C(2) NOT NULL, ;
                       ORIGEN N(1, 0) NOT NULL, ;
                       PUINMN N(12, 4) NOT NULL, ;
                       PUINUS N(12, 4) NOT NULL, ;
                       VCTOMN N(18, 4) NOT NULL, ;
                       VCTOUS N(18, 4) NOT NULL, ;
                       DENSIDAD N(10, 4) NOT NULL, ;
                       UNDNUM C(3) NOT NULL, ;
                       UNDDEN C(3) NOT NULL, ;
                       NOPROM L NOT NULL, ;
                       INACTIVO L NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CTAC2X C(8) NOT NULL, ;
                       CTAC33 C(8) NOT NULL, ;
                       CTAC70 C(8) NOT NULL, ;
                       CTAC71 C(8) NOT NULL, ;
                       CTAC60 C(8) NOT NULL, ;
                       CTAC61 C(8) NOT NULL, ;
                       CTAC61C C(8) NOT NULL, ;
                       CTAC16 C(8) NOT NULL, ;
                       CTAC69 C(8) NOT NULL, ;
                       UNDEQU N(14, 4) NOT NULL, ;
                       DESEQU C(20) NOT NULL, ;
                       FACVTA N(9, 4) NOT NULL, ;
                       STK01 N(14, 4) NOT NULL, ;
                       STK02 N(14, 4) NOT NULL, ;
                       STK03 N(14, 4) NOT NULL, ;
                       STK04 N(14, 4) NOT NULL, ;
                       STK05 N(14, 4) NOT NULL, ;
                       STK06 N(14, 4) NOT NULL, ;
                       STK07 N(14, 4) NOT NULL, ;
                       STK08 N(14, 4) NOT NULL, ;
                       STK09 N(14, 4) NOT NULL, ;
                       STK10 N(14, 4) NOT NULL, ;
                       STK11 N(14, 4) NOT NULL, ;
                       STK12 N(14, 4) NOT NULL, ;
                       VMN01 N(14, 4) NOT NULL, ;
                       VMN02 N(14, 4) NOT NULL, ;
                       VMN03 N(14, 4) NOT NULL, ;
                       VMN04 N(14, 4) NOT NULL, ;
                       VMN05 N(14, 4) NOT NULL, ;
                       VMN06 N(14, 4) NOT NULL, ;
                       VMN07 N(14, 4) NOT NULL, ;
                       VMN08 N(14, 4) NOT NULL, ;
                       VMN09 N(14, 4) NOT NULL, ;
                       VMN10 N(14, 4) NOT NULL, ;
                       VMN11 N(14, 4) NOT NULL, ;
                       VMN12 N(14, 4) NOT NULL, ;
                       VUS01 N(14, 4) NOT NULL, ;
                       VUS02 N(14, 4) NOT NULL, ;
                       VUS03 N(14, 4) NOT NULL, ;
                       VUS04 N(14, 4) NOT NULL, ;
                       VUS05 N(14, 4) NOT NULL, ;
                       VUS06 N(14, 4) NOT NULL, ;
                       VUS07 N(14, 4) NOT NULL, ;
                       VUS08 N(14, 4) NOT NULL, ;
                       VUS09 N(14, 4) NOT NULL, ;
                       VUS10 N(14, 4) NOT NULL, ;
                       VUS11 N(14, 4) NOT NULL, ;
                       VUS12 N(14, 4) NOT NULL, ;
                       PS01 N(12, 4) NOT NULL, ;
                       PS02 N(12, 4) NOT NULL, ;
                       PS03 N(12, 4) NOT NULL, ;
                       PS04 N(12, 4) NOT NULL, ;
                       PS05 N(12, 4) NOT NULL, ;
                       PS06 N(12, 4) NOT NULL, ;
                       PS07 N(12, 4) NOT NULL, ;
                       PS08 N(12, 4) NOT NULL, ;
                       PS09 N(12, 4) NOT NULL, ;
                       PS10 N(12, 4) NOT NULL, ;
                       PS11 N(12, 4) NOT NULL, ;
                       PS12 N(12, 4) NOT NULL, ;
                       PD01 N(12, 4) NOT NULL, ;
                       PD02 N(12, 4) NOT NULL, ;
                       PD03 N(12, 4) NOT NULL, ;
                       PD04 N(12, 4) NOT NULL, ;
                       PD05 N(12, 4) NOT NULL, ;
                       PD06 N(12, 4) NOT NULL, ;
                       PD07 N(12, 4) NOT NULL, ;
                       PD08 N(12, 4) NOT NULL, ;
                       PD09 N(12, 4) NOT NULL, ;
                       PD10 N(12, 4) NOT NULL, ;
                       PD11 N(12, 4) NOT NULL, ;
                       PD12 N(12, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       LUGENT N(1, 0) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Crear cada índice para ALMCATGE *****
SET COLLATE TO 'MACHINE'
INDEX ON UPPER(DESMAT) TAG CATG02
INDEX ON CODEQU TAG CATG05
INDEX ON CODREF TAG CATG06
INDEX ON LEFT(CODMAT,3)+UPPER(DESMAT) TAG CATG03
INDEX ON CODMAT TAG CATG01 CANDIDATE

***** Cambiar propiedades para ALMCATGE *****
ENDFUNC

FUNCTION MakeTable_CBDRMOVM
***** Configuración de tabla para CBDRMOVM *****
CREATE TABLE 'CBDRMOVM.DBF' NAME 'CBDRMOVM' (NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       ELIITM C(1) NOT NULL, ;
                       CODDIV C(2) NOT NULL, ;
                       CTAPRE C(15) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(11) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(11) NOT NULL, ;
                       NRORUC C(11) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(11) NOT NULL, ;
                       NROREF C(11) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       INIAUX C(8) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       FCHPED D NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       TPOO_C C(4) NOT NULL, ;
                       CODFIN C(4) NOT NULL, ;
                       CODCCO C(8) NOT NULL, ;
                       AFECTO C(1) NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL, ;
                       AN1CTA C(8) NOT NULL, ;
                       CC1CTA C(8) NOT NULL, ;
                       CHKCTA C(10) NOT NULL)

***** Crear cada índice para CBDRMOVM *****
SET COLLATE TO 'MACHINE'
INDEX ON NROMES+CODOPE+NROAST+STR(NROITM,5) TAG RMOV01
INDEX ON CODCTA+CODAUX+NRODOC+NROMES+DTOC(FCHDOC,1)+CODOPE+NROAST TAG RMOV06
INDEX ON CODCTA+NRODOC+CODAUX TAG RMOV05
INDEX ON NROMES+CODCTA+DTOS(FCHAST) TAG RMOV02
INDEX ON CODCTA+DTOS(FCHPED)+CODOPE TAG RMOV04
INDEX ON CTAPRE+CODCTA TAG RMOV09
INDEX ON NROMES+CODOPE+NROAST+CODCTA TAG RMOV07
INDEX ON NROMES+CODCTA+CODREF+CODOPE+NROAST TAG RMOV03

***** Cambiar propiedades para CBDRMOVM *****
ENDFUNC

FUNCTION MakeTable_CBDACMCT
***** Configuración de tabla para CBDACMCT *****
CREATE TABLE 'CBDACMCT.DBF' NAME 'CBDACMCT' (CODCTA C(8) NOT NULL, ;
                       CODREF C(11) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       DBENAC N(12, 2) NOT NULL, ;
                       HBENAC N(12, 2) NOT NULL, ;
                       DBEEXT N(12, 2) NOT NULL, ;
                       HBEEXT N(12, 2) NOT NULL, ;
                       DBENAC01 N(12, 2) NOT NULL, ;
                       HBENAC01 N(12, 2) NOT NULL, ;
                       DBEEXT01 N(12, 2) NOT NULL, ;
                       HBEEXT01 N(12, 2) NOT NULL, ;
                       DBENAC02 N(12, 2) NOT NULL, ;
                       HBENAC02 N(12, 2) NOT NULL, ;
                       DBEEXT02 N(12, 2) NOT NULL, ;
                       HBEEXT02 N(12, 2) NOT NULL, ;
                       DBENAC03 N(12, 2) NOT NULL, ;
                       HBENAC03 N(12, 2) NOT NULL, ;
                       DBEEXT03 N(12, 2) NOT NULL, ;
                       HBEEXT03 N(12, 2) NOT NULL, ;
                       DBENAC04 N(12, 2) NOT NULL, ;
                       HBENAC04 N(12, 2) NOT NULL, ;
                       DBEEXT04 N(12, 2) NOT NULL, ;
                       HBEEXT04 N(12, 2) NOT NULL)

***** Crear cada índice para CBDACMCT *****
SET COLLATE TO 'MACHINE'
INDEX ON CODCTA+CODREF+NROMES TAG ACCT02
INDEX ON NROMES+CODCTA+CODREF TAG ACCT01

***** Cambiar propiedades para CBDACMCT *****
ENDFUNC

FUNCTION MakeView_V_MATERIALES_X_ALMACEN
***************** Ver la configuración para V_MATERIALES_X_ALMACEN ***************
t1=LsNomBd+'!almcatal'
t2=LsNomBd+'!almcatge'
CREATE SQL VIEW "V_MATERIALES_X_ALMACEN" ; 
   AS SELECT Almcatal.subalm, Almcatal.codmat, Almcatge.desmat,  Almcatge.undstk, Almcatal.stkact  FROM  &T1. INNER JOIN &T2. ON Almcatal.codmat = Almcatge.codmat   ORDER BY Almcatal.subalm, Almcatal.codmat

DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'UpdateType', 1)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'WhereType', 3)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'FetchMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'SendUpdates', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'UseMemoSize', 255)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'MaxRecords', -1)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'Tables', LsNomBd+'!almcatal,'+LsNomBd+'!almcatge')
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'Prepared', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'CompareMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'Comment', "")
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MATERIALES_X_ALMACEN', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MATERIALES_X_ALMACEN
* Props for the V_MATERIALES_X_ALMACEN.subalm field.
DBSetProp('V_MATERIALES_X_ALMACEN.subalm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.subalm', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN.subalm', 'Field', 'UpdateName', LsNomBd+'!almcatal.subalm')
DBSetProp('V_MATERIALES_X_ALMACEN.subalm', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN.codmat field.
DBSetProp('V_MATERIALES_X_ALMACEN.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.codmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.codmat', 'Field', 'UpdateName', 'codmat')
DBSetProp('V_MATERIALES_X_ALMACEN.codmat', 'Field', 'DataType', "C(8)")
* Props for the V_MATERIALES_X_ALMACEN.desmat field.
DBSetProp('V_MATERIALES_X_ALMACEN.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.desmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN.desmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.desmat')
DBSetProp('V_MATERIALES_X_ALMACEN.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MATERIALES_X_ALMACEN.undstk field.
DBSetProp('V_MATERIALES_X_ALMACEN.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.undstk', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN.undstk', 'Field', 'UpdateName', LsNomBd+'!almcatge.undstk')
DBSetProp('V_MATERIALES_X_ALMACEN.undstk', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN.stkact field.
DBSetProp('V_MATERIALES_X_ALMACEN.stkact', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.stkact', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN.stkact', 'Field', 'UpdateName', 'stkact')
DBSetProp('V_MATERIALES_X_ALMACEN.stkact', 'Field', 'DataType', "N(14,4)")
ENDFUNC
 
FUNCTION MakeView_V_CULTIVOS_X_LOTE
***************** Ver la configuración para V_CULTIVOS_X_LOTE ***************
t1=LsNomBd+'!cpiculti'
t2=LsNomBd+'!cpicuxlt'

CREATE SQL VIEW "V_CULTIVOS_X_LOTE" ; 
   AS SELECT Cpicuxlt.codsed, Cpicuxlt.codlote, Cpicuxlt.codcult,  Cpiculti.descult  FROM &T1. INNER JOIN &T2. ON  Cpiculti.codcult = Cpicuxlt.codcult

DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'UpdateType', 1)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'WhereType', 3)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'FetchMemo', .T.)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'SendUpdates', .F.)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'UseMemoSize', 255)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'FetchSize', 100)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'MaxRecords', -1)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'Tables', LsNomBd+'!cpicuxlt,'+LsNomBd+'!cpiculti')
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'Prepared', .F.)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'CompareMemo', .T.)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'FetchSize', 100)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'Comment', "")
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_CULTIVOS_X_LOTE', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_CULTIVOS_X_LOTE
* Props for the V_CULTIVOS_X_LOTE.codsed field.
DBSetProp('V_CULTIVOS_X_LOTE.codsed', 'Field', 'KeyField', .F.)
DBSetProp('V_CULTIVOS_X_LOTE.codsed', 'Field', 'Updatable', .T.)
DBSetProp('V_CULTIVOS_X_LOTE.codsed', 'Field', 'UpdateName', LsNomBd+'!cpicuxlt.codsed')
DBSetProp('V_CULTIVOS_X_LOTE.codsed', 'Field', 'DataType', "C(3)")
* Props for the V_CULTIVOS_X_LOTE.codlote field.
DBSetProp('V_CULTIVOS_X_LOTE.codlote', 'Field', 'KeyField', .F.)
DBSetProp('V_CULTIVOS_X_LOTE.codlote', 'Field', 'Updatable', .T.)
DBSetProp('V_CULTIVOS_X_LOTE.codlote', 'Field', 'UpdateName', LsNomBd+'!cpicuxlt.codlote')
DBSetProp('V_CULTIVOS_X_LOTE.codlote', 'Field', 'DataType', "C(3)")
* Props for the V_CULTIVOS_X_LOTE.codcult field.
DBSetProp('V_CULTIVOS_X_LOTE.codcult', 'Field', 'KeyField', .F.)
DBSetProp('V_CULTIVOS_X_LOTE.codcult', 'Field', 'Updatable', .F.)
DBSetProp('V_CULTIVOS_X_LOTE.codcult', 'Field', 'UpdateName', 'codcult')
DBSetProp('V_CULTIVOS_X_LOTE.codcult', 'Field', 'DataType', "C(8)")
* Props for the V_CULTIVOS_X_LOTE.descult field.
DBSetProp('V_CULTIVOS_X_LOTE.descult', 'Field', 'KeyField', .F.)
DBSetProp('V_CULTIVOS_X_LOTE.descult', 'Field', 'Updatable', .T.)
DBSetProp('V_CULTIVOS_X_LOTE.descult', 'Field', 'UpdateName', LsNomBd+'!cpiculti.descult')
DBSetProp('V_CULTIVOS_X_LOTE.descult', 'Field', 'DataType', "C(30)")
ENDFUNC
 
FUNCTION MakeView_V_MATERIALES_X_ALMACEN_2
***************** Ver la configuración para V_MATERIALES_X_ALMACEN_2 ***************
T1=LsNomBd+'!v_materiales_x_almacen'
T2=LsNomCia+'!almtalma'
CREATE SQL VIEW "V_MATERIALES_X_ALMACEN_2" ; 
   AS SELECT V_materiales_x_almacen.subalm, Almtalma.dessub,  V_materiales_x_almacen.codmat, V_materiales_x_almacen.desmat,  V_materiales_x_almacen.undstk, V_materiales_x_almacen.stkact  FROM  &T2. INNER JOIN &T1. ON  Almtalma.subalm = V_materiales_x_almacen.subalm

DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'UpdateType', 1)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'WhereType', 3)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'FetchMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'SendUpdates', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'UseMemoSize', 255)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'MaxRecords', -1)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'Tables', LsNomCia+'!almtalma,'+LsNomBd+'!v_materiales_x_almacen')
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'Prepared', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'CompareMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'Comment', "")
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MATERIALES_X_ALMACEN_2', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MATERIALES_X_ALMACEN_2
* Props for the V_MATERIALES_X_ALMACEN_2.subalm field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.subalm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.subalm', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.subalm', 'Field', 'UpdateName', LsNomCia+'!almtalma.subalm')
DBSetProp('V_MATERIALES_X_ALMACEN_2.subalm', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_2.dessub field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.dessub', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.dessub', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.dessub', 'Field', 'UpdateName', LsNomCia+'!almtalma.dessub')
DBSetProp('V_MATERIALES_X_ALMACEN_2.dessub', 'Field', 'DataType', "C(32)")
* Props for the V_MATERIALES_X_ALMACEN_2.codmat field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.codmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.codmat', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen.codmat')
DBSetProp('V_MATERIALES_X_ALMACEN_2.codmat', 'Field', 'DataType', "C(8)")
* Props for the V_MATERIALES_X_ALMACEN_2.desmat field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.desmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.desmat', 'Field', 'UpdateName', 'desmat')
DBSetProp('V_MATERIALES_X_ALMACEN_2.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MATERIALES_X_ALMACEN_2.undstk field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.undstk', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.undstk', 'Field', 'UpdateName', 'undstk')
DBSetProp('V_MATERIALES_X_ALMACEN_2.undstk', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_2.stkact field.
DBSetProp('V_MATERIALES_X_ALMACEN_2.stkact', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.stkact', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_2.stkact', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen.stkact')
DBSetProp('V_MATERIALES_X_ALMACEN_2.stkact', 'Field', 'DataType', "N(14,4)")
ENDFUNC
 
FUNCTION MakeView_V_MATERIALES_SIN_ALMACEN
***************** Ver la configuración para V_MATERIALES_SIN_ALMACEN ***************
T1=LsNomBd+'!almcatge'
T2=LsNomBd+'!almcatal'
CREATE SQL VIEW "V_MATERIALES_SIN_ALMACEN" ; 
   AS SELECT Almcatge.codmat, Almcatge.desmat, Almcatge.undstk FROM  &t1. LEFT OUTER JOIN &t2. ON  Almcatge.codmat = Almcatal.codmat

DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'UpdateType', 1)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'WhereType', 3)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'FetchMemo', .T.)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'SendUpdates', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'UseMemoSize', 255)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'MaxRecords', -1)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'Tables', LsNomBd+'!almcatge')
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'Prepared', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'CompareMemo', .T.)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'Comment', "")
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MATERIALES_SIN_ALMACEN', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MATERIALES_SIN_ALMACEN
* Props for the V_MATERIALES_SIN_ALMACEN.codmat field.
DBSetProp('V_MATERIALES_SIN_ALMACEN.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.codmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.codmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.codmat')
DBSetProp('V_MATERIALES_SIN_ALMACEN.codmat', 'Field', 'DataType', "C(13)")
* Props for the V_MATERIALES_SIN_ALMACEN.desmat field.
DBSetProp('V_MATERIALES_SIN_ALMACEN.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.desmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.desmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.desmat')
DBSetProp('V_MATERIALES_SIN_ALMACEN.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MATERIALES_SIN_ALMACEN.undstk field.
DBSetProp('V_MATERIALES_SIN_ALMACEN.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.undstk', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_SIN_ALMACEN.undstk', 'Field', 'UpdateName', LsNomBd+'!almcatge.undstk')
DBSetProp('V_MATERIALES_SIN_ALMACEN.undstk', 'Field', 'DataType', "C(3)")
ENDFUNC
 
FUNCTION MakeView_V_MATERIALES_X_ALMACEN_3
***************** Ver la configuración para V_MATERIALES_X_ALMACEN_3 ***************
t1=LsNomBd+'!almcatge'
t2=LsNomBd+'!almcatal'
T3=LsNomCia+'!almtalma'
CREATE SQL VIEW "V_MATERIALES_X_ALMACEN_3" ; 
   AS SELECT Almcatge.codmat, Almcatge.desmat, Almcatge.undstk,  Almcatal.undvta, Almcatal.facequ, Almtalma.codsed, Almcatal.subalm,  Almtalma.dessub, 0.0000 AS stk_sede, 0.0000 AS stk_alm,  0.0000 AS stk_gen, Almcatge.puinmn, Almcatge.puinus FROM  &T1. LEFT OUTER JOIN &t2. INNER JOIN &T3. ON  Almcatal.subalm = Almtalma.subalm    ON  Almcatge.codmat = Almcatal.codmat

DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'UpdateType', 1)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'WhereType', 3)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'FetchMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'SendUpdates', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'UseMemoSize', 255)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'MaxRecords', -1)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'Tables', LsNomBd+'!almcatge,'+LsNomBd+'!almcatal,'+LsNomCia+'!almtalma')
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'Prepared', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'CompareMemo', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'Comment', "")
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MATERIALES_X_ALMACEN_3', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MATERIALES_X_ALMACEN_3
* Props for the V_MATERIALES_X_ALMACEN_3.codmat field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.codmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.codmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.codmat')
DBSetProp('V_MATERIALES_X_ALMACEN_3.codmat', 'Field', 'DataType', "C(13)")
* Props for the V_MATERIALES_X_ALMACEN_3.desmat field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.desmat', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.desmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.desmat')
DBSetProp('V_MATERIALES_X_ALMACEN_3.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MATERIALES_X_ALMACEN_3.undstk field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.undstk', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.undstk', 'Field', 'UpdateName', LsNomBd+'!almcatge.undstk')
DBSetProp('V_MATERIALES_X_ALMACEN_3.undstk', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_3.undvta field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.undvta', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.undvta', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.undvta', 'Field', 'UpdateName', LsNomBd+'!almcatal.undvta')
DBSetProp('V_MATERIALES_X_ALMACEN_3.undvta', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_3.facequ field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.facequ', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.facequ', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.facequ', 'Field', 'UpdateName', LsNomBd+'!almcatal.facequ')
DBSetProp('V_MATERIALES_X_ALMACEN_3.facequ', 'Field', 'DataType', "N(10,4)")
* Props for the V_MATERIALES_X_ALMACEN_3.codsed field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.codsed', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.codsed', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.codsed', 'Field', 'UpdateName', LsNomCia+'!almtalma.codsed')
DBSetProp('V_MATERIALES_X_ALMACEN_3.codsed', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_3.subalm field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.subalm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.subalm', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.subalm', 'Field', 'UpdateName', LsNomBd+'!almcatal.subalm')
DBSetProp('V_MATERIALES_X_ALMACEN_3.subalm', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_ALMACEN_3.dessub field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.dessub', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.dessub', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.dessub', 'Field', 'UpdateName', LsNomCia+'!almtalma.dessub')
DBSetProp('V_MATERIALES_X_ALMACEN_3.dessub', 'Field', 'DataType', "C(32)")
* Props for the V_MATERIALES_X_ALMACEN_3.stk_sede field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_sede', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_sede', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_sede', 'Field', 'UpdateName', 'Almtalma.dessub*')
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_sede', 'Field', 'DataType', "N(6,4)")
* Props for the V_MATERIALES_X_ALMACEN_3.stk_alm field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_alm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_alm', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_alm', 'Field', 'UpdateName', 'Almtalma.dessub**')
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_alm', 'Field', 'DataType', "N(6,4)")
* Props for the V_MATERIALES_X_ALMACEN_3.stk_gen field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_gen', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_gen', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_gen', 'Field', 'UpdateName', 'Almtalma.dessub***')
DBSetProp('V_MATERIALES_X_ALMACEN_3.stk_gen', 'Field', 'DataType', "N(6,4)")
* Props for the V_MATERIALES_X_ALMACEN_3.puinmn field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinmn', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinmn', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinmn', 'Field', 'UpdateName', LsNomBd+'!almcatge.puinmn')
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinmn', 'Field', 'DataType', "N(12,4)")
* Props for the V_MATERIALES_X_ALMACEN_3.puinus field.
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinus', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinus', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinus', 'Field', 'UpdateName', LsNomBd+'!almcatge.puinus')
DBSetProp('V_MATERIALES_X_ALMACEN_3.puinus', 'Field', 'DataType', "N(12,4)")
ENDFUNC
 
FUNCTION MakeView_V_MOVIMIENTOS_ALMACEN
***************** Ver la configuración para V_MOVIMIENTOS_ALMACEN ***************
T1=LsNomBd+'!almcftra'
T2=LsNomBd+'!almctran'
T3=LsNomBd+'!almdtran'
T4=LsNomBd+'!almcatge'
CREATE SQL VIEW "V_MOVIMIENTOS_ALMACEN" ; 
   AS SELECT Almdtran.codsed, Almdtran.subalm, Almdtran.almori,  Almdtran.tipmov, Almdtran.codmov, Almdtran.nrodoc, Almdtran.nroitm,  Almdtran.fchdoc, Almdtran.codcli, Almdtran.codpro, Almdtran.codmon,  Almdtran.tpocmb, Almdtran.tporeq, Almdtran.codmat, Almdtran.codprd,  Almdtran.candes, Almdtran.canrec, Almdtran.lote, Almdtran.fchvto,  Almdtran.candev, Almdtran.cnfmla, Almdtran.factor, Almdtran.preuni,  Almdtran.impcto, Almdtran.stksub, Almdtran.stkact, Almdtran.codajt,  Almdtran.undvta, Almdtran.tporef, Almdtran.nroref, Almdtran.tporfb,  Almdtran.nrorfb, Almdtran.nroref2, Almdtran.impnac, Almdtran.impusa,  Almdtran.vctomn, Almdtran.vctous, Almdtran.user, Almdtran.fbatch,  Almdtran.codope, Almdtran.nroast, Almdtran.anoast, Almdtran.codnew,  Almdtran.codnew1, Almdtran.coduser, Almdtran.fchhora, Almctran.nrorf1,  Almctran.nrorf2, Almctran.nrorf3, Almctran.nroodt, Almcatge.desmat,  Almcftra.desmov, Almcftra.pidpco, Almcatge.undstk FROM &t1. , ;
   &t2. INNER JOIN &T3. INNER JOIN &T4. ON Almdtran.codmat = Almcatge.codmat ON  Almctran.subalm = Almdtran.subalm   AND  Almctran.tipmov = Almdtran.tipmov   AND  Almctran.codmov = Almdtran.codmov   AND  Almctran.nrodoc = Almdtran.nrodoc WHERE Almctran.tipmov = Almcftra.tipmov   AND Almctran.codmov = Almcftra.codmov ORDER BY Almdtran.tipmov, Almdtran.codmov, Almdtran.subalm

DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'UpdateType', 1)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'WhereType', 3)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'FetchMemo', .T.)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'SendUpdates', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'UseMemoSize', 255)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'MaxRecords', -1)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'Tables', LsNomBd+'!almcftra,'+LsNomBd+'!almcatge')
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'Prepared', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'CompareMemo', .T.)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'FetchSize', 100)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'Comment', "")
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MOVIMIENTOS_ALMACEN', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MOVIMIENTOS_ALMACEN
* Props for the V_MOVIMIENTOS_ALMACEN.codsed field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codsed', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codsed', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codsed', 'Field', 'UpdateName', LsNomBd+'!almdtran.codsed')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codsed', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.subalm field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.subalm', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.subalm', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.subalm', 'Field', 'UpdateName', LsNomBd+'!almdtran.subalm')
DBSetProp('V_MOVIMIENTOS_ALMACEN.subalm', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.almori field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.almori', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.almori', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.almori', 'Field', 'UpdateName', LsNomBd+'!almdtran.almori')
DBSetProp('V_MOVIMIENTOS_ALMACEN.almori', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.tipmov field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.tipmov', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tipmov', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tipmov', 'Field', 'UpdateName', LsNomBd+'!almdtran.tipmov')
DBSetProp('V_MOVIMIENTOS_ALMACEN.tipmov', 'Field', 'DataType', "C(1)")
* Props for the V_MOVIMIENTOS_ALMACEN.codmov field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmov', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmov', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmov', 'Field', 'UpdateName', LsNomBd+'!almdtran.codmov')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmov', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.nrodoc field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrodoc', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrodoc', 'Field', 'UpdateName', LsNomBd+'!almdtran.nrodoc')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrodoc', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.nroitm field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroitm', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroitm', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroitm', 'Field', 'UpdateName', LsNomBd+'!almdtran.nroitm')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroitm', 'Field', 'DataType', "N(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.fchdoc field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchdoc', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchdoc', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchdoc', 'Field', 'UpdateName', LsNomBd+'!almdtran.fchdoc')
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchdoc', 'Field', 'DataType', "D")
* Props for the V_MOVIMIENTOS_ALMACEN.codcli field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codcli', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codcli', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codcli', 'Field', 'UpdateName', LsNomBd+'!almdtran.codcli')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codcli', 'Field', 'DataType', "C(11)")
* Props for the V_MOVIMIENTOS_ALMACEN.codpro field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codpro', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codpro', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codpro', 'Field', 'UpdateName', LsNomBd+'!almdtran.codpro')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codpro', 'Field', 'DataType', "C(11)")
* Props for the V_MOVIMIENTOS_ALMACEN.codmon field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmon', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmon', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmon', 'Field', 'UpdateName', LsNomBd+'!almdtran.codmon')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmon', 'Field', 'DataType', "N(1)")
* Props for the V_MOVIMIENTOS_ALMACEN.tpocmb field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.tpocmb', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tpocmb', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tpocmb', 'Field', 'UpdateName', LsNomBd+'!almdtran.tpocmb')
DBSetProp('V_MOVIMIENTOS_ALMACEN.tpocmb', 'Field', 'DataType', "N(10,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.tporeq field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporeq', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporeq', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporeq', 'Field', 'UpdateName', LsNomBd+'!almdtran.tporeq')
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporeq', 'Field', 'DataType', "C(1)")
* Props for the V_MOVIMIENTOS_ALMACEN.codmat field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmat', 'Field', 'UpdateName', LsNomBd+'!almdtran.codmat')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codmat', 'Field', 'DataType', "C(13)")
* Props for the V_MOVIMIENTOS_ALMACEN.codprd field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codprd', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codprd', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codprd', 'Field', 'UpdateName', LsNomBd+'!almdtran.codprd')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codprd', 'Field', 'DataType', "C(13)")
* Props for the V_MOVIMIENTOS_ALMACEN.candes field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.candes', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.candes', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.candes', 'Field', 'UpdateName', LsNomBd+'!almdtran.candes')
DBSetProp('V_MOVIMIENTOS_ALMACEN.candes', 'Field', 'DataType', "N(14,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.canrec field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.canrec', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.canrec', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.canrec', 'Field', 'UpdateName', LsNomBd+'!almdtran.canrec')
DBSetProp('V_MOVIMIENTOS_ALMACEN.canrec', 'Field', 'DataType', "N(14,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.lote field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.lote', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.lote', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.lote', 'Field', 'UpdateName', LsNomBd+'!almdtran.lote')
DBSetProp('V_MOVIMIENTOS_ALMACEN.lote', 'Field', 'DataType', "C(15)")
* Props for the V_MOVIMIENTOS_ALMACEN.fchvto field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchvto', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchvto', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchvto', 'Field', 'UpdateName', LsNomBd+'!almdtran.fchvto')
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchvto', 'Field', 'DataType', "D")
* Props for the V_MOVIMIENTOS_ALMACEN.candev field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.candev', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.candev', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.candev', 'Field', 'UpdateName', LsNomBd+'!almdtran.candev')
DBSetProp('V_MOVIMIENTOS_ALMACEN.candev', 'Field', 'DataType', "N(14,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.cnfmla field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.cnfmla', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.cnfmla', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.cnfmla', 'Field', 'UpdateName', LsNomBd+'!almdtran.cnfmla')
DBSetProp('V_MOVIMIENTOS_ALMACEN.cnfmla', 'Field', 'DataType', "N(14,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.factor field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.factor', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.factor', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.factor', 'Field', 'UpdateName', LsNomBd+'!almdtran.factor')
DBSetProp('V_MOVIMIENTOS_ALMACEN.factor', 'Field', 'DataType', "N(7,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.preuni field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.preuni', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.preuni', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.preuni', 'Field', 'UpdateName', LsNomBd+'!almdtran.preuni')
DBSetProp('V_MOVIMIENTOS_ALMACEN.preuni', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.impcto field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.impcto', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impcto', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impcto', 'Field', 'UpdateName', LsNomBd+'!almdtran.impcto')
DBSetProp('V_MOVIMIENTOS_ALMACEN.impcto', 'Field', 'DataType', "N(14,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.stksub field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.stksub', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.stksub', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.stksub', 'Field', 'UpdateName', LsNomBd+'!almdtran.stksub')
DBSetProp('V_MOVIMIENTOS_ALMACEN.stksub', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.stkact field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.stkact', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.stkact', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.stkact', 'Field', 'UpdateName', LsNomBd+'!almdtran.stkact')
DBSetProp('V_MOVIMIENTOS_ALMACEN.stkact', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.codajt field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codajt', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codajt', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codajt', 'Field', 'UpdateName', LsNomBd+'!almdtran.codajt')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codajt', 'Field', 'DataType', "C(1)")
* Props for the V_MOVIMIENTOS_ALMACEN.undvta field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.undvta', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.undvta', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.undvta', 'Field', 'UpdateName', LsNomBd+'!almdtran.undvta')
DBSetProp('V_MOVIMIENTOS_ALMACEN.undvta', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.tporef field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporef', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporef', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporef', 'Field', 'UpdateName', LsNomBd+'!almdtran.tporef')
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporef', 'Field', 'DataType', "C(4)")
* Props for the V_MOVIMIENTOS_ALMACEN.nroref field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref', 'Field', 'UpdateName', LsNomBd+'!almdtran.nroref')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.tporfb field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporfb', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporfb', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporfb', 'Field', 'UpdateName', LsNomBd+'!almdtran.tporfb')
DBSetProp('V_MOVIMIENTOS_ALMACEN.tporfb', 'Field', 'DataType', "C(4)")
* Props for the V_MOVIMIENTOS_ALMACEN.nrorfb field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorfb', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorfb', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorfb', 'Field', 'UpdateName', LsNomBd+'!almdtran.nrorfb')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorfb', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.nroref2 field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref2', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref2', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref2', 'Field', 'UpdateName', LsNomBd+'!almdtran.nroref2')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroref2', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.impnac field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.impnac', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impnac', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impnac', 'Field', 'UpdateName', LsNomBd+'!almdtran.impnac')
DBSetProp('V_MOVIMIENTOS_ALMACEN.impnac', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.impusa field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.impusa', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impusa', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.impusa', 'Field', 'UpdateName', LsNomBd+'!almdtran.impusa')
DBSetProp('V_MOVIMIENTOS_ALMACEN.impusa', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.vctomn field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctomn', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctomn', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctomn', 'Field', 'UpdateName', LsNomBd+'!almdtran.vctomn')
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctomn', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.vctous field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctous', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctous', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctous', 'Field', 'UpdateName', LsNomBd+'!almdtran.vctous')
DBSetProp('V_MOVIMIENTOS_ALMACEN.vctous', 'Field', 'DataType', "N(16,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.user field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.user', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.user', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.user', 'Field', 'UpdateName', LsNomBd+'!almdtran.user')
DBSetProp('V_MOVIMIENTOS_ALMACEN.user', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.fbatch field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.fbatch', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fbatch', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fbatch', 'Field', 'UpdateName', LsNomBd+'!almdtran.fbatch')
DBSetProp('V_MOVIMIENTOS_ALMACEN.fbatch', 'Field', 'DataType', "N(8,4)")
* Props for the V_MOVIMIENTOS_ALMACEN.codope field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codope', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codope', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codope', 'Field', 'UpdateName', LsNomBd+'!almdtran.codope')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codope', 'Field', 'DataType', "C(3)")
* Props for the V_MOVIMIENTOS_ALMACEN.nroast field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroast', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroast', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroast', 'Field', 'UpdateName', LsNomBd+'!almdtran.nroast')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroast', 'Field', 'DataType', "C(6)")
* Props for the V_MOVIMIENTOS_ALMACEN.anoast field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.anoast', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.anoast', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.anoast', 'Field', 'UpdateName', LsNomBd+'!almdtran.anoast')
DBSetProp('V_MOVIMIENTOS_ALMACEN.anoast', 'Field', 'DataType', "C(4)")
* Props for the V_MOVIMIENTOS_ALMACEN.codnew field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew', 'Field', 'UpdateName', LsNomBd+'!almdtran.codnew')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew', 'Field', 'DataType', "C(13)")
* Props for the V_MOVIMIENTOS_ALMACEN.codnew1 field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew1', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew1', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew1', 'Field', 'UpdateName', LsNomBd+'!almdtran.codnew1')
DBSetProp('V_MOVIMIENTOS_ALMACEN.codnew1', 'Field', 'DataType', "C(8)")
* Props for the V_MOVIMIENTOS_ALMACEN.coduser field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.coduser', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.coduser', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.coduser', 'Field', 'UpdateName', LsNomBd+'!almdtran.coduser')
DBSetProp('V_MOVIMIENTOS_ALMACEN.coduser', 'Field', 'DataType', "C(8)")
* Props for the V_MOVIMIENTOS_ALMACEN.fchhora field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchhora', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchhora', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchhora', 'Field', 'UpdateName', LsNomBd+'!almdtran.fchhora')
DBSetProp('V_MOVIMIENTOS_ALMACEN.fchhora', 'Field', 'DataType', "T")
* Props for the V_MOVIMIENTOS_ALMACEN.nrorf1 field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf1', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf1', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf1', 'Field', 'UpdateName', LsNomBd+'!almctran.nrorf1')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf1', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.nrorf2 field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf2', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf2', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf2', 'Field', 'UpdateName', LsNomBd+'!almctran.nrorf2')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf2', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.nrorf3 field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf3', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf3', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf3', 'Field', 'UpdateName', LsNomBd+'!almctran.nrorf3')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nrorf3', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.nroodt field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroodt', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroodt', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroodt', 'Field', 'UpdateName', LsNomBd+'!almctran.nroodt')
DBSetProp('V_MOVIMIENTOS_ALMACEN.nroodt', 'Field', 'DataType', "C(10)")
* Props for the V_MOVIMIENTOS_ALMACEN.desmat field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmat', 'Field', 'UpdateName', LsNomBd+'!almcatge.desmat')
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MOVIMIENTOS_ALMACEN.desmov field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmov', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmov', 'Field', 'Updatable', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmov', 'Field', 'UpdateName', LsNomBd+'!almcftra.desmov')
DBSetProp('V_MOVIMIENTOS_ALMACEN.desmov', 'Field', 'DataType', "C(37)")
* Props for the V_MOVIMIENTOS_ALMACEN.pidpco field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.pidpco', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.pidpco', 'Field', 'Updatable', .T.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.pidpco', 'Field', 'UpdateName', LsNomBd+'!almcftra.pidpco')
DBSetProp('V_MOVIMIENTOS_ALMACEN.pidpco', 'Field', 'DataType', "L")
* Props for the V_MOVIMIENTOS_ALMACEN.undstk field.
DBSetProp('V_MOVIMIENTOS_ALMACEN.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.undstk', 'Field', 'Updatable', .T.)
DBSetProp('V_MOVIMIENTOS_ALMACEN.undstk', 'Field', 'UpdateName', LsNomBd+'!almcatge.undstk')
DBSetProp('V_MOVIMIENTOS_ALMACEN.undstk', 'Field', 'DataType', "C(3)")
ENDFUNC
 
FUNCTION MakeView_V_MATERIALES_X_LOTE
***************** Ver la configuración para V_MATERIALES_X_LOTE ***************
T1=LsNomBd+'!v_materiales_x_almacen_3'
T2=LsNomBd+'!almdlote'
CREATE SQL VIEW "V_MATERIALES_X_LOTE" ; 
   AS SELECT V_materiales_x_almacen_3_a.codmat,  V_materiales_x_almacen_3_a.desmat, V_materiales_x_almacen_3_a.undstk,  Almdlote.lote, Almdlote.stkact, Almdlote.fchvto, 0.0000 AS stk_alm,  V_materiales_x_almacen_3_a.codsed, V_materiales_x_almacen_3_a.subalm FROM  &T1. V_materiales_x_almacen_3_a INNER JOIN &t2. ON  V_materiales_x_almacen_3_a.codmat = Almdlote.codmat ORDER BY V_materiales_x_almacen_3_a.codmat

DBSetProp('V_MATERIALES_X_LOTE', 'View', 'UpdateType', 1)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'WhereType', 3)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'FetchMemo', .T.)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'SendUpdates', .F.)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'UseMemoSize', 255)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'MaxRecords', -1)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'Tables', LsNomBd+'!almdlote,'+LsNomBd+'!v_materiales_x_almacen_3')
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'Prepared', .F.)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'CompareMemo', .T.)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'FetchSize', 100)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'Comment', "")
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_MATERIALES_X_LOTE', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_MATERIALES_X_LOTE
* Props for the V_MATERIALES_X_LOTE.codmat field.
DBSetProp('V_MATERIALES_X_LOTE.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.codmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_LOTE.codmat', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen_3.codmat')
DBSetProp('V_MATERIALES_X_LOTE.codmat', 'Field', 'DataType', "C(13)")
* Props for the V_MATERIALES_X_LOTE.desmat field.
DBSetProp('V_MATERIALES_X_LOTE.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.desmat', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_LOTE.desmat', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen_3.desmat')
DBSetProp('V_MATERIALES_X_LOTE.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_MATERIALES_X_LOTE.undstk field.
DBSetProp('V_MATERIALES_X_LOTE.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.undstk', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_LOTE.undstk', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen_3.undstk')
DBSetProp('V_MATERIALES_X_LOTE.undstk', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_LOTE.lote field.
DBSetProp('V_MATERIALES_X_LOTE.lote', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.lote', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_LOTE.lote', 'Field', 'UpdateName', LsNomBd+'!almdlote.lote')
DBSetProp('V_MATERIALES_X_LOTE.lote', 'Field', 'DataType', "C(15)")
* Props for the V_MATERIALES_X_LOTE.stkact field.
DBSetProp('V_MATERIALES_X_LOTE.stkact', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.stkact', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_LOTE.stkact', 'Field', 'UpdateName', LsNomBd+'!almdlote.stkact')
DBSetProp('V_MATERIALES_X_LOTE.stkact', 'Field', 'DataType', "N(14,4)")
* Props for the V_MATERIALES_X_LOTE.fchvto field.
DBSetProp('V_MATERIALES_X_LOTE.fchvto', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.fchvto', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_LOTE.fchvto', 'Field', 'UpdateName', LsNomBd+'!almdlote.fchvto')
DBSetProp('V_MATERIALES_X_LOTE.fchvto', 'Field', 'DataType', "D")
* Props for the V_MATERIALES_X_LOTE.stk_alm field.
DBSetProp('V_MATERIALES_X_LOTE.stk_alm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.stk_alm', 'Field', 'Updatable', .F.)
DBSetProp('V_MATERIALES_X_LOTE.stk_alm', 'Field', 'UpdateName', '')
DBSetProp('V_MATERIALES_X_LOTE.stk_alm', 'Field', 'DataType', "N(6,4)")
* Props for the V_MATERIALES_X_LOTE.codsed field.
DBSetProp('V_MATERIALES_X_LOTE.codsed', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.codsed', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_LOTE.codsed', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen_3.codsed')
DBSetProp('V_MATERIALES_X_LOTE.codsed', 'Field', 'DataType', "C(3)")
* Props for the V_MATERIALES_X_LOTE.subalm field.
DBSetProp('V_MATERIALES_X_LOTE.subalm', 'Field', 'KeyField', .F.)
DBSetProp('V_MATERIALES_X_LOTE.subalm', 'Field', 'Updatable', .T.)
DBSetProp('V_MATERIALES_X_LOTE.subalm', 'Field', 'UpdateName', LsNomBd+'!v_materiales_x_almacen_3.subalm')
DBSetProp('V_MATERIALES_X_LOTE.subalm', 'Field', 'DataType', "C(3)")
ENDFUNC
 
FUNCTION MakeView_V_REPORTE_GUIA
***************** Ver la configuración para V_REPORTE_GUIA ***************
X=LsNomBd+'!almcatge'
Y=LsNomBd+'!almDTRAN'
Z=LsNomCia+'!vtavguia'
CREATE SQL VIEW "V_REPORTE_GUIA" ; 
   AS SELECT Vtavguia.nrodoc, Vtavguia.fchdoc, Vtavguia.nomtra,  Vtavguia.dirtra, Vtavguia.ructra, Vtavguia.platra, Vtavguia.nomcli,  Vtavguia.dircli, Vtavguia.ruccli, Almdtran.codmat, Almdtran.candes FROM  &Z. INNER JOIN &Y. INNER JOIN &X. ON  Almdtran.codmat = Almcatge.codmat    ON  Vtavguia.coddoc = Almdtran.tporef   AND  Vtavguia.nrodoc = Almdtran.nroref WHERE Vtavguia.coddoc = ?_CodDoc   AND Vtavguia.nrodoc = ?_NroDoc

DBSetProp('V_REPORTE_GUIA', 'View', 'UpdateType', 1)
DBSetProp('V_REPORTE_GUIA', 'View', 'WhereType', 3)
DBSetProp('V_REPORTE_GUIA', 'View', 'FetchMemo', .T.)
DBSetProp('V_REPORTE_GUIA', 'View', 'SendUpdates', .F.)
DBSetProp('V_REPORTE_GUIA', 'View', 'UseMemoSize', 255)
DBSetProp('V_REPORTE_GUIA', 'View', 'FetchSize', 100)
DBSetProp('V_REPORTE_GUIA', 'View', 'MaxRecords', -1)
DBSetProp('V_REPORTE_GUIA', 'View', 'Tables', LsNomCia+'!vtavguia,almdtran')
DBSetProp('V_REPORTE_GUIA', 'View', 'Prepared', .F.)
DBSetProp('V_REPORTE_GUIA', 'View', 'CompareMemo', .T.)
DBSetProp('V_REPORTE_GUIA', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_REPORTE_GUIA', 'View', 'FetchSize', 100)
DBSetProp('V_REPORTE_GUIA', 'View', 'Comment', "")
DBSetProp('V_REPORTE_GUIA', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_REPORTE_GUIA', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_REPORTE_GUIA
* Props for the V_REPORTE_GUIA.nrodoc field.
DBSetProp('V_REPORTE_GUIA.nrodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.nrodoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.nrodoc', 'Field', 'UpdateName', LsNomCia+'!vtavguia.nrodoc')
DBSetProp('V_REPORTE_GUIA.nrodoc', 'Field', 'DataType', "C(9)")
* Props for the V_REPORTE_GUIA.fchdoc field.
DBSetProp('V_REPORTE_GUIA.fchdoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.fchdoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.fchdoc', 'Field', 'UpdateName', LsNomCia+'!vtavguia.fchdoc')
DBSetProp('V_REPORTE_GUIA.fchdoc', 'Field', 'DataType', "D")
* Props for the V_REPORTE_GUIA.nomtra field.
DBSetProp('V_REPORTE_GUIA.nomtra', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.nomtra', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.nomtra', 'Field', 'UpdateName', LsNomCia+'!vtavguia.nomtra')
DBSetProp('V_REPORTE_GUIA.nomtra', 'Field', 'DataType', "C(40)")
* Props for the V_REPORTE_GUIA.dirtra field.
DBSetProp('V_REPORTE_GUIA.dirtra', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.dirtra', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.dirtra', 'Field', 'UpdateName', LsNomCia+'!vtavguia.dirtra')
DBSetProp('V_REPORTE_GUIA.dirtra', 'Field', 'DataType', "C(40)")
* Props for the V_REPORTE_GUIA.ructra field.
DBSetProp('V_REPORTE_GUIA.ructra', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.ructra', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.ructra', 'Field', 'UpdateName', LsNomCia+'!vtavguia.ructra')
DBSetProp('V_REPORTE_GUIA.ructra', 'Field', 'DataType', "C(8)")
* Props for the V_REPORTE_GUIA.platra field.
DBSetProp('V_REPORTE_GUIA.platra', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.platra', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.platra', 'Field', 'UpdateName', LsNomCia+'!vtavguia.platra')
DBSetProp('V_REPORTE_GUIA.platra', 'Field', 'DataType', "C(10)")
* Props for the V_REPORTE_GUIA.nomcli field.
DBSetProp('V_REPORTE_GUIA.nomcli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.nomcli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.nomcli', 'Field', 'UpdateName', LsNomCia+'!vtavguia.nomcli')
DBSetProp('V_REPORTE_GUIA.nomcli', 'Field', 'DataType', "C(50)")
* Props for the V_REPORTE_GUIA.dircli field.
DBSetProp('V_REPORTE_GUIA.dircli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.dircli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.dircli', 'Field', 'UpdateName', LsNomCia+'!vtavguia.dircli')
DBSetProp('V_REPORTE_GUIA.dircli', 'Field', 'DataType', "C(60)")
* Props for the V_REPORTE_GUIA.ruccli field.
DBSetProp('V_REPORTE_GUIA.ruccli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.ruccli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.ruccli', 'Field', 'UpdateName', LsNomCia+'!vtavguia.ruccli')
DBSetProp('V_REPORTE_GUIA.ruccli', 'Field', 'DataType', "C(10)")
* Props for the V_REPORTE_GUIA.codmat field.
DBSetProp('V_REPORTE_GUIA.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.codmat', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.codmat', 'Field', 'UpdateName', LsNomBd+'!almdtran.codmat')
DBSetProp('V_REPORTE_GUIA.codmat', 'Field', 'DataType', "C(13)")
* Props for the V_REPORTE_GUIA.candes field.
DBSetProp('V_REPORTE_GUIA.candes', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_GUIA.candes', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_GUIA.candes', 'Field', 'UpdateName', LsNomBd+'!almdtran.candes')
DBSetProp('V_REPORTE_GUIA.candes', 'Field', 'DataType', "N(14,4)")
ENDFUNC

FUNCTION MakeView_V_NOTAS_BALANCE
***************** Ver la configuración para V_NOTAS_BALANCE ***************

X=LsNomBd+'!CBDMCTAS'
Y=LsNomCia+'!cbdtbalc' 
Z=LsNomCia+'!cbdnbalc' 
CREATE SQL VIEW "V_NOTAS_BALANCE" ; 
   AS SELECT Cbdnbalc.nota, Cbdnbalc.codcta, Cbdmctas.nomcta, Cbdnbalc.signo,  Cbdnbalc.forma, Cbdtbalc.nroitm, Cbdnbalc.rubro FROM  &Y.  INNER JOIN &Z. LEFT OUTER JOIN &X. ON  Cbdnbalc.codcta = Cbdmctas.codcta    ON  Cbdtbalc.rubro = Cbdnbalc.rubro   AND  Cbdtbalc.nota = Cbdnbalc.nota ORDER BY Cbdnbalc.rubro, Cbdnbalc.nota

DBSetProp('V_NOTAS_BALANCE', 'View', 'UpdateType', 1)
DBSetProp('V_NOTAS_BALANCE', 'View', 'WhereType', 3)
DBSetProp('V_NOTAS_BALANCE', 'View', 'FetchMemo', .T.)
DBSetProp('V_NOTAS_BALANCE', 'View', 'SendUpdates', .T.)
DBSetProp('V_NOTAS_BALANCE', 'View', 'UseMemoSize', 255)
DBSetProp('V_NOTAS_BALANCE', 'View', 'FetchSize', 100)
DBSetProp('V_NOTAS_BALANCE', 'View', 'MaxRecords', -1)
DBSetProp('V_NOTAS_BALANCE', 'View', 'Tables', LsNomCia+'!cbdnbalc')
DBSetProp('V_NOTAS_BALANCE', 'View', 'Prepared', .F.)
DBSetProp('V_NOTAS_BALANCE', 'View', 'CompareMemo', .T.)
DBSetProp('V_NOTAS_BALANCE', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_NOTAS_BALANCE', 'View', 'FetchSize', 100)
DBSetProp('V_NOTAS_BALANCE', 'View', 'Comment', "")
DBSetProp('V_NOTAS_BALANCE', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_NOTAS_BALANCE', 'View', 'ShareConnection', .F.)

*!* Field Level Properties for V_NOTAS_BALANCE
* Props for the V_NOTAS_BALANCE.nota field.
DBSetProp('V_NOTAS_BALANCE.nota', 'Field', 'KeyField', .T.)
DBSetProp('V_NOTAS_BALANCE.nota', 'Field', 'Updatable', .T.)
DBSetProp('V_NOTAS_BALANCE.nota', 'Field', 'UpdateName', LsNomCia+'!cbdnbalc.nota')
DBSetProp('V_NOTAS_BALANCE.nota', 'Field', 'DataType', "C(2)")
* Props for the V_NOTAS_BALANCE.codcta field.
DBSetProp('V_NOTAS_BALANCE.codcta', 'Field', 'KeyField', .T.)
DBSetProp('V_NOTAS_BALANCE.codcta', 'Field', 'Updatable', .T.)
DBSetProp('V_NOTAS_BALANCE.codcta', 'Field', 'UpdateName', LsNomCia+'!cbdnbalc.codcta')
DBSetProp('V_NOTAS_BALANCE.codcta', 'Field', 'DataType', "C(8)")
* Props for the V_NOTAS_BALANCE.nomcta field.
DBSetProp('V_NOTAS_BALANCE.nomcta', 'Field', 'KeyField', .F.)
DBSetProp('V_NOTAS_BALANCE.nomcta', 'Field', 'Updatable', .F.)
DBSetProp('V_NOTAS_BALANCE.nomcta', 'Field', 'UpdateName', LsNomBd+'!cbdmctas.nomcta')
DBSetProp('V_NOTAS_BALANCE.nomcta', 'Field', 'DataType', "C(40)")
* Props for the V_NOTAS_BALANCE.signo field.
DBSetProp('V_NOTAS_BALANCE.signo', 'Field', 'KeyField', .F.)
DBSetProp('V_NOTAS_BALANCE.signo', 'Field', 'Updatable', .T.)
DBSetProp('V_NOTAS_BALANCE.signo', 'Field', 'UpdateName', LsNomCia+'!cbdnbalc.signo')
DBSetProp('V_NOTAS_BALANCE.signo', 'Field', 'DataType', "C(1)")
* Props for the V_NOTAS_BALANCE.forma field.
DBSetProp('V_NOTAS_BALANCE.forma', 'Field', 'KeyField', .F.)
DBSetProp('V_NOTAS_BALANCE.forma', 'Field', 'Updatable', .T.)
DBSetProp('V_NOTAS_BALANCE.forma', 'Field', 'UpdateName', LsNomCia+'!cbdnbalc.forma')
DBSetProp('V_NOTAS_BALANCE.forma', 'Field', 'DataType', "C(1)")
* Props for the V_NOTAS_BALANCE.nroitm field.
DBSetProp('V_NOTAS_BALANCE.nroitm', 'Field', 'KeyField', .F.)
DBSetProp('V_NOTAS_BALANCE.nroitm', 'Field', 'Updatable', .F.)
DBSetProp('V_NOTAS_BALANCE.nroitm', 'Field', 'UpdateName', LsNomCia+'!cbdtbalc.nroitm')
DBSetProp('V_NOTAS_BALANCE.nroitm', 'Field', 'DataType', "N(3)")
* Props for the V_NOTAS_BALANCE.rubro field.
DBSetProp('V_NOTAS_BALANCE.rubro', 'Field', 'KeyField', .T.)
DBSetProp('V_NOTAS_BALANCE.rubro', 'Field', 'Updatable', .T.)
DBSetProp('V_NOTAS_BALANCE.rubro', 'Field', 'UpdateName', LsNomCia+'!cbdnbalc.rubro')
DBSetProp('V_NOTAS_BALANCE.rubro', 'Field', 'DataType', "C(3)")
ENDFUNC


FUNCTION DisplayStatus(lcMessage)
WAIT WINDOW NOWAIT lcMessage
ENDFUNC
