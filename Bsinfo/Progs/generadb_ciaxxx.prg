* *********************************************************
* *
* * 07/01/04              CIA001.DBC              14:01:08
* *
* *********************************************************
* *
* * Descripción:
* * Este programa lo ha generado automáticamente GENDBC
* * Versión 2.26.67
* *
* *********************************************************
parameter cPathDatos,cCodCia
DisplayStatus([Creando base de datos...])
CLOSE DATA ALL
LsNomDbc = 'CIA'+cCodCia+'.DBC'
LsNomCia = 'CIA'+cCodCia

IF !DIRECTORY(cPathDatos)
	MKDIR (cPathDatos)
ENDIF	
set defa to (cPathDatos)
*
IF !DIRECTORY(LsNomCia)
	MKDIR (LsNomCia)
ENDIF	
CREATE DATABASE (LsNomDbc)
set defa to (Lsnomcia)
DisplayStatus([Creating table ALMEQUNI...])
MakeTable_ALMEQUNI()
DisplayStatus([Creating table ALMESTCM...])
MakeTable_ALMESTCM()
DisplayStatus([Creating table ALMESTTR...])
MakeTable_ALMESTTR()
DisplayStatus([Creating table ALMIMDAC...])
MakeTable_ALMIMDAC()
DisplayStatus([Creating table ALMIMDAV...])
MakeTable_ALMIMDAV()
DisplayStatus([Creating table ALMTALMA...])
MakeTable_ALMTALMA()
DisplayStatus([Creating table ALMTDIVF...])
MakeTable_ALMTDIVF()
DisplayStatus([Creating table ALMTGSIS...])
MakeTable_ALMTGSIS()
DisplayStatus([Creating table ALMTUNID...])
MakeTable_ALMTUNID()
DisplayStatus([Creating table CBDMAUXI...])
MakeTable_CBDMAUXI()
DisplayStatus([Creating table CBDMPART...])
MakeTable_CBDMPART()
DisplayStatus([Creating table CBDMTABL...])
MakeTable_CBDMTABL()
DisplayStatus([Creating table CBDNANXO...])
MakeTable_CBDNANXO()
DisplayStatus([Creating table CBDNBALC...])
MakeTable_CBDNBALC()
DisplayStatus([Creating table CBDNPERN...])
MakeTable_CBDNPERN()
DisplayStatus([Creating table CBDRPART...])
MakeTable_CBDRPART()
DisplayStatus([Creating table CBDTAJUS...])
MakeTable_CBDTAJUS()
DisplayStatus([Creating table CBDTANOS...])
MakeTable_CBDTANOS()
DisplayStatus([Creating table CBDTANXO...])
MakeTable_CBDTANXO()
DisplayStatus([Creating table CBDTBALC...])
MakeTable_CBDTBALC()
DisplayStatus([Creating table CBDTCNFG...])
MakeTable_CBDTCNFG()
DisplayStatus([Creating table CBDTCOST...])
MakeTable_CBDTCOST()
DisplayStatus([Creating table CBDTPERN...])
MakeTable_CBDTPERN()
DisplayStatus([Creating table CBDCNFG0...])
MakeTable_CBDCNFG0()
DisplayStatus([Creating table CJATPROV...])
MakeTable_CJATPROV()
DisplayStatus([Creating table CCBMVTOS...])
MakeTable_CCBMVTOS()
DisplayStatus([Creating table CCBNRASG...])
MakeTable_CCBNRASG()
DisplayStatus([Creating table CCBNTASG...])
MakeTable_CCBNTASG()
DisplayStatus([Creating table CCBRGDOC...])
MakeTable_CCBRGDOC()
DisplayStatus([Creating table CCBRRDOC...])
MakeTable_CCBRRDOC()
DisplayStatus([Creating table CCBSALDO...])
MakeTable_CCBSALDO()
DisplayStatus([Creating table CCTCDIRE...])
MakeTable_CCTCDIRE()
DisplayStatus([Creating table CFCMPROY...])
MakeTable_CFCMPROY()
DisplayStatus([Creating table CJACFNZA...])
MakeTable_CJACFNZA()
DisplayStatus([Creating table CJATFNZA...])
MakeTable_CJATFNZA()
DisplayStatus([Creating table CCB1FACT...])
MakeTable_CCB1FACT()
DisplayStatus([Creating table CMPCREQU...])
MakeTable_CMPCREQU()
DisplayStatus([Creating table CMPDDIST...])
MakeTable_CMPDDIST()
DisplayStatus([Creating table CMPDIMPO...])
MakeTable_CMPDIMPO()
DisplayStatus([Creating table CMPMODIM...])
MakeTable_CMPMODIM()
DisplayStatus([Creating table CMPPACIN...])
MakeTable_CMPPACIN()
DisplayStatus([Creating table CMPPDIRE...])
MakeTable_CMPPDIRE()
DisplayStatus([Creating table CMPPROV...])
MakeTable_CMPPROV()
DisplayStatus([Creating table CMPTDIST...])
MakeTable_CMPTDIST()
DisplayStatus([Creating table CMPTDOCM...])
MakeTable_CMPTDOCM()
DisplayStatus([Creating table CMPTPRMY...])
MakeTable_CMPTPRMY()
DisplayStatus([Creating table CMPTVPED...])
MakeTable_CMPTVPED()
DisplayStatus([Creating table CPIDFPRO...])
MakeTable_CPIDFPRO()
DisplayStatus([Creating table CPIACXPR...])
MakeTable_CPIACXPR()
DisplayStatus([Creating table CPICCPPT...])
MakeTable_CPICCPPT()
DisplayStatus([Creating table CPICFGCP...])
MakeTable_CPICFGCP()
DisplayStatus([Creating table CPICFPRO...])
MakeTable_CPICFPRO()
DisplayStatus([Creating table CPICGCPT...])
MakeTable_CPICGCPT()
DisplayStatus([Creating table CPICONFG...])
MakeTable_CPICONFG()
DisplayStatus([Creating table CPICOSTO...])
MakeTable_CPICOSTO()
DisplayStatus([Creating table CPICPROG...])
MakeTable_CPICPROG()
DisplayStatus([Creating table CPICRPRG...])
MakeTable_CPICRPRG()
DisplayStatus([Creating table CPICSTPT...])
MakeTable_CPICSTPT()
DisplayStatus([Creating table CPICTOPP...])
MakeTable_CPICTOPP()
DisplayStatus([Creating table CPICXLGRAL...])
MakeTable_CPICXLGRAL()
DisplayStatus([Creating table CPICXLM_O...])
MakeTable_CPICXLM_O()
DisplayStatus([Creating table CPIACTIV...])
MakeTable_CPIACTIV()
DisplayStatus([Creating table CPIDPROG...])
MakeTable_CPIDPROG()
DisplayStatus([Creating table CPIEMDPT...])
MakeTable_CPIEMDPT()
DisplayStatus([Creating table CPIEMVPT...])
MakeTable_CPIEMVPT()
DisplayStatus([Creating table CPIFASES...])
MakeTable_CPIFASES()
DisplayStatus([Creating table CPIICMDF...])
MakeTable_CPIICMDF()
DisplayStatus([Creating table CPIICPPT...])
MakeTable_CPIICPPT()
DisplayStatus([Creating table CPIIECMP...])
MakeTable_CPIIECMP()
DisplayStatus([Creating table CPIIPRGM...])
MakeTable_CPIIPRGM()
DisplayStatus([Creating table CPIIPUXP...])
MakeTable_CPIIPUXP()
DisplayStatus([Creating table CPIIVCSD...])
MakeTable_CPIIVCSD()
DisplayStatus([Creating table CPIIVPUF...])
MakeTable_CPIIVPUF()
DisplayStatus([Creating table CPILOTES...])
MakeTable_CPILOTES()
DisplayStatus([Creating table CPIPROCS...])
MakeTable_CPIPROCS()
DisplayStatus([Creating table CPIPVXPV...])
MakeTable_CPIPVXPV()
DisplayStatus([Creating table CPIRESP1...])
MakeTable_CPIRESP1()
DisplayStatus([Creating table CPITDCTO...])
MakeTable_CPITDCTO()
DisplayStatus([Creating table CPITPVTA...])
MakeTable_CPITPVTA()
DisplayStatus([Creating table DISTRITOS...])
MakeTable_DISTRITOS()
DisplayStatus([Creating table FLCANCHQ...])
MakeTable_FLCANCHQ()
DisplayStatus([Creating table FLCGRCHQ...])
MakeTable_FLCGRCHQ()
DisplayStatus([Creating table FLCJCNFG...])
MakeTable_FLCJCNFG()
DisplayStatus([Creating table FLCJTBBC...])
MakeTable_FLCJTBBC()
DisplayStatus([Creating table FLCJTBCP...])
MakeTable_FLCJTBCP()
DisplayStatus([Creating table FLCJTBDF...])
MakeTable_FLCJTBDF()
DisplayStatus([Creating table FLCJTBDU...])
MakeTable_FLCJTBDU()
DisplayStatus([Creating table FLCJTBFP...])
MakeTable_FLCJTBFP()
DisplayStatus([Creating table FLCJTBTT...])
MakeTable_FLCJTBTT()
DisplayStatus([Creating table FLCJTDFP...])
MakeTable_FLCJTDFP()
DisplayStatus([Creating table FLCJTHFP...])
MakeTable_FLCJTHFP()
DisplayStatus([Creating table FLCLIQUI...])
MakeTable_FLCLIQUI()
DisplayStatus([Creating table PAISES...])
MakeTable_PAISES()
DisplayStatus([Creating table SEDES...])
MakeTable_SEDES()
DisplayStatus([Creating table FLCJANOS...])
MakeTable_FLCJANOS()
DisplayStatus([Creating table FLBBSINI...])
MakeTable_FLBBSINI()
DisplayStatus([Creating table FLCBPROY...])
MakeTable_FLCBPROY()
DisplayStatus([Creating table FLBBDFJR...])
MakeTable_FLBBDFJR()
DisplayStatus([Creating table FLCJANUA...])
MakeTable_FLCJANUA()
DisplayStatus([Creating table FLCJBBDU...])
MakeTable_FLCJBBDU()
DisplayStatus([Creating table FLCJC_LE...])
MakeTable_FLCJC_LE()
DisplayStatus([Creating table FLCJCAMB...])
MakeTable_FLCJCAMB()
DisplayStatus([Creating table FLCJCIER...])
MakeTable_FLCJCIER()
DisplayStatus([Creating table FLCJCONC...])
MakeTable_FLCJCONC()
DisplayStatus([Creating table FLCJDANO...])
MakeTable_FLCJDANO()
DisplayStatus([Creating table FLCJDFJR...])
MakeTable_FLCJDFJR()
DisplayStatus([Creating table FLCJMANO...])
MakeTable_FLCJMANO()
DisplayStatus([Creating table FLCJPAGO...])
MakeTable_FLCJPAGO()
DisplayStatus([Creating table FLCJPROY...])
MakeTable_FLCJPROY()
DisplayStatus([Creating table FLCJREAL...])
MakeTable_FLCJREAL()
DisplayStatus([Creating table FLCJSINI...])
MakeTable_FLCJSINI()
DisplayStatus([Creating table VTACRONO...])
MakeTable_VTACRONO()
DisplayStatus([Creating table VTAPTOVT...])
MakeTable_VTAPTOVT()
DisplayStatus([Creating table VTARFACT...])
MakeTable_VTARFACT()
DisplayStatus([Creating table VTARITEM...])
MakeTable_VTARITEM()
DisplayStatus([Creating table VTARPEDI...])
MakeTable_VTARPEDI()
DisplayStatus([Creating table VTATDOCM...])
MakeTable_VTATDOCM()
DisplayStatus([Creating table VTAVFACT...])
MakeTable_VTAVFACT()
DisplayStatus([Creating table VTAVGUIA...])
MakeTable_VTAVGUIA()
DisplayStatus([Creating table VTAVPEDI...])
MakeTable_VTAVPEDI()
DisplayStatus([Creating table ZONAS...])
MakeTable_ZONAS()
DisplayStatus([Creating table CCTCLIEN...])
MakeTable_CCTCLIEN()
DisplayStatus([Creating table CBDPPRES...])
MakeTable_CBDPPRES()
DisplayStatus([Creating table VTAPVTCL...])
MakeTable_VTAPVTCL()
DisplayStatus([Creating table CBDRMDLO...])
MakeTable_CBDRMDLO()
DisplayStatus([Creating table CBDVMDLO...])
MakeTable_CBDVMDLO()
DisplayStatus([Creating table PLNMTABL...])
MakeTable_PLNMTABL()
DisplayStatus([Creating table PLNMPCTS...])
MakeTable_PLNMPCTS()
DisplayStatus([Creating table CBDORDEN...])
MakeTable_CBDORDEN()
DisplayStatus([Creating table PLNDJTF1...])
MakeTable_PLNDJTF1()
DisplayStatus([Creating table PLNDJTF2...])
MakeTable_PLNDJTF2()
DisplayStatus([Creating table PLNBANCO...])
MakeTable_PLNBANCO()
DisplayStatus([Creating table PLNBANCR...])
MakeTable_PLNBANCR()
DisplayStatus([Creating table PLNCOOPE...])
MakeTable_PLNCOOPE()
DisplayStatus([Creating table PLNARAFP...])
MakeTable_PLNARAFP()
DisplayStatus([Creating table CJADPROV...])
MakeTable_CJADPROV()
DisplayStatus([Creating table CBDFLPDT...])
MakeTable_CBDFLPDT()
DisplayStatus([Creating table PDT3500...])
MakeTable_PDT3500()
DisplayStatus([Creating table CBDCNFG1...])
MakeTable_CBDCNFG1()
DisplayStatus([Creating table CBDMCTA2...])
MakeTable_CBDMCTA2()
DisplayStatus([Creating view V_ACTIVIDADES_X_FASE_PROC...])
MakeView_V_ACTIVIDADES_X_FASE_PROC()
DisplayStatus([Creating view V_UNIDADES_EQUIVALENCIAS...])
MakeView_V_UNIDADES_EQUIVALENCIAS()
DisplayStatus([Creating view V_DOCUMENTOS_X_COBRAR...])
MakeView_V_DOCUMENTOS_X_COBRAR()
DisplayStatus([Creating view V_REPORTE_FACT...])
MakeView_V_REPORTE_FACT()
DisplayStatus([Creating view V_CLIENTES...])
MakeView_V_CLIENTES()
DisplayStatus([Finished.])


********* Procedure Re-Creation *********
SET DEFAULT TO (cPathDatos)
IF !FILE(LsNomCia+[.PRO])
    ? [Advertencia!  No se ha encontrado ningún archivo de procedimientos.!]
ELSE
	CLOSE DATABASE
	OPEN DATABASE LsNomCia 
    COPY PROCEDURES TO LsNomBd+[.PRO]
    CLOSE DATABASES
ENDIF
CLOSE DATA ALL
RETURN 


FUNCTION MakeTable_ALMEQUNI
***** Table setup for ALMEQUNI *****
CREATE TABLE 'ALMEQUNI.DBF' NAME 'ALMEQUNI' (UNDSTK C(3) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       FACEQU N(12, 4) NOT NULL, ;
                       DESVTA C(25) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       PIDGLO C(1) NOT NULL, ;
                       TIP_AFE_RV C(1) NOT NULL, ;
                       NROREG N(10, 0) NOT NULL)

***** Create each index for ALMEQUNI *****
INDEX ON UNDSTK+UNDVTA TAG EQUN01 CANDIDATE COLLATE 'MACHINE'
INDEX ON CODMAT+UNDSTK+UNDVTA TAG EQUN03 COLLATE 'MACHINE'

***** Change properties for ALMEQUNI *****
ENDFUNC

FUNCTION MakeTable_ALMESTCM
***** Table setup for ALMESTCM *****
CREATE TABLE 'ALMESTCM.DBF' NAME 'ALMESTCM' (CODALM C(3) NOT NULL, ;
                       CLFDIV C(2) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       CODEQU C(13) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       PERIODO C(8) NOT NULL, ;
                       CODLOTE C(3) NOT NULL, ;
                       CANING N(14, 4) NOT NULL, ;
                       CANSAL N(14, 4) NOT NULL, ;
                       VINGMN N(14, 4) NOT NULL, ;
                       VINGUS N(14, 4) NOT NULL, ;
                       VSALMN N(14, 4) NOT NULL, ;
                       VSALUS N(14, 4) NOT NULL, ;
                       CANFOR N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Create each index for ALMESTCM *****
INDEX ON PERIODO+CODEQU+CODMAT TAG ESTA05 COLLATE 'MACHINE'
INDEX ON CODPRO+CODMAT+PERIODO TAG ESTA02 COLLATE 'MACHINE'
INDEX ON CLFDIV+CODMAT+PERIODO+CODPRO TAG ESTA03 COLLATE 'MACHINE'
INDEX ON CLFDIV+CODMAT+CODPRO+PERIODO TAG ESTA04 COLLATE 'MACHINE'
INDEX ON PERIODO+CODPRO+CODMAT+CODLOTE TAG ESTA01 COLLATE 'MACHINE'

***** Change properties for ALMESTCM *****
ENDFUNC

FUNCTION MakeTable_ALMESTTR
***** Table setup for ALMESTTR *****
CREATE TABLE 'ALMESTTR.DBF' NAME 'ALMESTTR' (CODALM C(3) NOT NULL, ;
                       CLFDIV C(2) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       CODEQU C(13) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       PERIODO C(8) NOT NULL, ;
                       CANING N(14, 4) NOT NULL, ;
                       CANSAL N(14, 4) NOT NULL, ;
                       VINGMN N(14, 4) NOT NULL, ;
                       VINGUS N(14, 4) NOT NULL, ;
                       VSALMN N(14, 2) NOT NULL, ;
                       VSALUS N(14, 2) NOT NULL, ;
                       CANFOR N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Create each index for ALMESTTR *****
INDEX ON PERIODO+CODEQU+CODMAT TAG ESTR05 COLLATE 'MACHINE'
INDEX ON PERIODO+CODPRO+CODMAT TAG ESTR01 COLLATE 'MACHINE'
INDEX ON CODPRO+CODMAT+PERIODO TAG ESTR02 COLLATE 'MACHINE'
INDEX ON CLFDIV+CODMAT+PERIODO+CODPRO TAG ESTR03 COLLATE 'MACHINE'
INDEX ON CLFDIV+CODMAT+CODPRO+PERIODO TAG ESTR04 COLLATE 'MACHINE'

***** Change properties for ALMESTTR *****
ENDFUNC

FUNCTION MakeTable_ALMIMDAC
***** Table setup for ALMIMDAC *****
CREATE TABLE 'ALMIMDAC.DBF' NAME 'ALMIMDAC' (CODMAT C(20) NOT NULL, ;
                       STKACT N(14, 3) NOT NULL, ;
                       CI01 N(14, 4) NOT NULL, ;
                       CI02 N(14, 4) NOT NULL, ;
                       CI03 N(14, 4) NOT NULL, ;
                       CI04 N(14, 4) NOT NULL, ;
                       CI05 N(14, 4) NOT NULL, ;
                       CI06 N(14, 4) NOT NULL, ;
                       CI07 N(14, 4) NOT NULL, ;
                       CI08 N(14, 4) NOT NULL, ;
                       CI09 N(14, 4) NOT NULL, ;
                       CI10 N(14, 4) NOT NULL, ;
                       CI11 N(14, 4) NOT NULL, ;
                       CI12 N(14, 4) NOT NULL, ;
                       CI13 N(14, 4) NOT NULL, ;
                       CI14 N(14, 4) NOT NULL, ;
                       CI15 N(14, 4) NOT NULL, ;
                       CI16 N(14, 4) NOT NULL, ;
                       CI17 N(14, 4) NOT NULL, ;
                       CS01 N(14, 4) NOT NULL, ;
                       CS02 N(14, 4) NOT NULL, ;
                       CS03 N(14, 4) NOT NULL, ;
                       CS04 N(14, 4) NOT NULL, ;
                       CS05 N(14, 4) NOT NULL, ;
                       CS06 N(14, 4) NOT NULL, ;
                       CS07 N(14, 4) NOT NULL, ;
                       CS08 N(14, 4) NOT NULL, ;
                       CS09 N(14, 4) NOT NULL, ;
                       CS10 N(14, 4) NOT NULL, ;
                       CS11 N(14, 4) NOT NULL, ;
                       CS12 N(14, 4) NOT NULL, ;
                       CS13 N(14, 4) NOT NULL, ;
                       CS14 N(14, 4) NOT NULL, ;
                       CS15 N(14, 4) NOT NULL, ;
                       CS16 N(14, 4) NOT NULL, ;
                       CS17 N(14, 4) NOT NULL, ;
                       CT01 N(14, 4) NOT NULL, ;
                       CR02 N(14, 4) NOT NULL, ;
                       CNCSMO N(14, 4) NOT NULL, ;
                       VCCSMO N(14, 4) NOT NULL, ;
                       TCING N(14, 4) NOT NULL, ;
                       TVING N(14, 4) NOT NULL, ;
                       TCSAL N(14, 4) NOT NULL, ;
                       TVSAL N(14, 4) NOT NULL, ;
                       TOTVAL N(14, 4) NOT NULL, ;
                       TOTCAN N(14, 4) NOT NULL, ;
                       NIVEL C(3) NOT NULL, ;
                       STKINI N(14, 4) NOT NULL, ;
                       VALINI N(14, 4) NOT NULL)

***** Create each index for ALMIMDAC *****
INDEX ON NIVEL+CODMAT TAG TMP01 COLLATE 'MACHINE'

***** Change properties for ALMIMDAC *****
ENDFUNC

FUNCTION MakeTable_ALMIMDAV
***** Table setup for ALMIMDAV *****
CREATE TABLE 'ALMIMDAV.DBF' NAME 'ALMIMDAV' (CODMAT C(20) NOT NULL, ;
                       STKACT N(14, 3) NOT NULL, ;
                       VI01 N(14, 4) NOT NULL, ;
                       VI02 N(14, 4) NOT NULL, ;
                       VI03 N(14, 4) NOT NULL, ;
                       VI04 N(14, 4) NOT NULL, ;
                       VI05 N(14, 4) NOT NULL, ;
                       VI06 N(14, 4) NOT NULL, ;
                       VI07 N(14, 4) NOT NULL, ;
                       VI08 N(14, 4) NOT NULL, ;
                       VI09 N(14, 4) NOT NULL, ;
                       VI10 N(14, 4) NOT NULL, ;
                       VI11 N(14, 4) NOT NULL, ;
                       VI12 N(14, 4) NOT NULL, ;
                       VI13 N(14, 4) NOT NULL, ;
                       VI14 N(14, 4) NOT NULL, ;
                       VI15 N(14, 4) NOT NULL, ;
                       VI16 N(14, 4) NOT NULL, ;
                       VI17 C(10) NOT NULL, ;
                       VS01 N(14, 4) NOT NULL, ;
                       VS02 N(14, 4) NOT NULL, ;
                       VS03 N(14, 4) NOT NULL, ;
                       VS04 N(14, 4) NOT NULL, ;
                       VS05 N(14, 4) NOT NULL, ;
                       VS06 N(14, 4) NOT NULL, ;
                       VS07 N(14, 4) NOT NULL, ;
                       VS08 N(14, 4) NOT NULL, ;
                       VS09 N(14, 4) NOT NULL, ;
                       VS10 N(14, 4) NOT NULL, ;
                       VS11 N(14, 4) NOT NULL, ;
                       VS12 N(14, 4) NOT NULL, ;
                       VS13 N(14, 4) NOT NULL, ;
                       VS14 N(14, 4) NOT NULL, ;
                       VS15 N(14, 4) NOT NULL, ;
                       VS16 N(14, 4) NOT NULL, ;
                       VS17 N(14, 4) NOT NULL, ;
                       VT01 N(14, 4) NOT NULL, ;
                       VR02 N(14, 4) NOT NULL, ;
                       CNCSMO N(14, 4) NOT NULL, ;
                       VCCSMO N(14, 4) NOT NULL, ;
                       TCING N(14, 4) NOT NULL, ;
                       TVING N(14, 4) NOT NULL, ;
                       TCSAL N(14, 4) NOT NULL, ;
                       TVSAL N(14, 4) NOT NULL, ;
                       TOTVAL N(14, 4) NOT NULL, ;
                       TOTCAN N(14, 4) NOT NULL, ;
                       NIVEL C(3) NOT NULL, ;
                       STKINI N(14, 4) NOT NULL, ;
                       VALINI N(14, 4) NOT NULL)

***** Create each index for ALMIMDAV *****
INDEX ON NIVEL+CODMAT TAG TMP01 COLLATE 'MACHINE'

***** Change properties for ALMIMDAV *****
ENDFUNC

FUNCTION MakeTable_ALMTALMA
***** Table setup for ALMTALMA *****
CREATE TABLE 'ALMTALMA.DBF' NAME 'ALMTALMA' (CODSED C(3) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       DESSUB C(32) NOT NULL, ;
                       PROCESO L NOT NULL, ;
                       FCHCIE D NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for ALMTALMA *****
INDEX ON CODSED+DESSUB TAG ALMA03 COLLATE 'MACHINE'
INDEX ON CODSED+SUBALM TAG ALMA02 COLLATE 'MACHINE'
INDEX ON SUBALM TAG ALMA01 COLLATE 'MACHINE'

***** Change properties for ALMTALMA *****
ENDFUNC

FUNCTION MakeTable_ALMTDIVF
***** Table setup for ALMTDIVF *****
CREATE TABLE 'ALMTDIVF.DBF' NAME 'ALMTDIVF' (CLFDIV C(2) NOT NULL, ;
                       CODFAM C(5) NOT NULL, ;
                       FKDIVF C(5) NOT NULL, ;
                       DESFAM C(30) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       DSTVE1 N(5, 2) NOT NULL, ;
                       DSTVE2 N(5, 2) NOT NULL, ;
                       DSTVE3 N(5, 2) NOT NULL, ;
                       CTAC2X C(8) NOT NULL, ;
                       CTAC33 C(8) NOT NULL, ;
                       CTAC70 C(8) NOT NULL, ;
                       CTAC71 C(8) NOT NULL, ;
                       CTAC60 C(8) NOT NULL, ;
                       CTAC61 C(8) NOT NULL, ;
                       CTAC61C C(8) NOT NULL, ;
                       CTAC16 C(8) NOT NULL, ;
                       CTAC69 C(8) NOT NULL, ;
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
                       TPOGTO C(2) NOT NULL, ;
                       TIPFAM N(1, 0) NOT NULL, ;
                       NOPROM L NOT NULL, ;
                       P_ADVALOR N(6, 2) NOT NULL, ;
                       P_DESPEC N(6, 2) NOT NULL, ;
                       P_SOBTASA N(6, 2) NOT NULL, ;
                       FAMTRA L NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for ALMTDIVF *****
INDEX ON CLFDIV+UPPER(DESFAM) TAG DIVF02 COLLATE 'MACHINE'
INDEX ON CLFDIV+CODFAM TAG DIVF01 COLLATE 'MACHINE'

***** Change properties for ALMTDIVF *****
ENDFUNC

FUNCTION MakeTable_ALMTGSIS
***** Table setup for ALMTGSIS *****
CREATE TABLE 'ALMTGSIS.DBF' NAME 'ALMTGSIS' (TABLA C(2) NOT NULL, ;
                       CODIGO C(10) NOT NULL, ;
                       NOMBRE C(40) NOT NULL, ;
                       DIGITOS N(2, 0) NOT NULL, ;
                       SELEC L NOT NULL, ;
                       RESPON C(4) NOT NULL, ;
                       CODING C(10) NOT NULL, ;
                       CODSAL C(10) NOT NULL, ;
                       DEFECTO L NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       DIAVTO N(4, 0) NOT NULL)

***** Create each index for ALMTGSIS *****
INDEX ON TABLA+NOMBRE TAG TABL02 COLLATE 'MACHINE'
INDEX ON TABLA+CODIGO TAG TABL01 COLLATE 'MACHINE'

***** Change properties for ALMTGSIS *****

***** Load Data
=LoadData_ALMTGSIS()

ENDFUNC

FUNCTION MakeTable_ALMTUNID
***** Table setup for ALMTUNID *****
CREATE TABLE 'ALMTUNID.DBF' NAME 'ALMTUNID' (UNDSTK C(3) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       FACEQU N(12, 4) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for ALMTUNID *****

***** Change properties for ALMTUNID *****
ENDFUNC

FUNCTION MakeTable_CBDMAUXI
***** Table setup for CBDMAUXI *****
CREATE TABLE 'CBDMAUXI.DBF' NAME 'CBDMAUXI' (CLFAUX C(3) NOT NULL, ;
                       CODAUX C(11) NOT NULL, ;
                       NOMAUX C(50) NOT NULL, ;
                       DIRAUX C(60) NOT NULL, ;
                       DISAUX C(25) NOT NULL, ;
                       RUCAUX C(11) NOT NULL, ;
                       LIBAUX C(15) NOT NULL, ;
                       TPOAUX C(2) NOT NULL, ;
                       LOCAUX C(1) NOT NULL, ;
                       TLFAUX C(25) NOT NULL, ;
                       FCHING D NOT NULL, ;
                       FLGSIT C(1) NOT NULL, ;
                       CODDEP C(2) NOT NULL, ;
                       CODDIS C(2) NOT NULL, ;
                       FINANZ C(20) NOT NULL, ;
                       INDUST C(2) NOT NULL, ;
                       MOROSO C(1) NOT NULL, ;
                       INIAUX C(8) NOT NULL, ;
                       CODPOS C(8) NOT NULL, ;
                       NOMC_V C(30) NOT NULL, ;
                       CALAUX C(1) NOT NULL, ;
                       FLGING C(1) NOT NULL, ;
                       VTO_INIC N(3, 0) NOT NULL, ;
                       MONTO_MIN N(12, 2) NOT NULL, ;
                       MON_LETRA N(1, 0) NOT NULL, ;
                       INTER_LETR N(3, 0) NOT NULL, ;
                       MONTO_LETR N(12, 2) NOT NULL, ;
                       CODFAM C(5) NOT NULL, ;
                       TASA_INT N(6, 2) NOT NULL, ;
                       UBIAUX C(1) NOT NULL, ;
                       TNGAUX C(2) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       AP_PATER C(20) NOT NULL, ;
                       AP_MATER C(20) NOT NULL, ;
                       NOMBRE1 C(20) NOT NULL, ;
                       NOMBRE2 C(20) NOT NULL)

***** Create each index for CBDMAUXI *****
INDEX ON CLFAUX+CODAUX TAG AUXI01 COLLATE 'MACHINE'
INDEX ON CLFAUX+UPPER(NOMAUX) TAG AUXI02 COLLATE 'MACHINE'

***** Change properties for CBDMAUXI *****
ENDFUNC

FUNCTION MakeTable_CBDMPART
***** Table setup for CBDMPART *****
CREATE TABLE 'CBDMPART.DBF' NAME 'CBDMPART' (CODSED C(3) NOT NULL, ;
                       CODCTA C(5) NOT NULL, ;
                       CODPAR C(8) NOT NULL, ;
                       NOMPAR C(50) NOT NULL, ;
                       NOMCORT C(8) NOT NULL, ;
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
                       PORDPR N(6, 2) NOT NULL, ;
                       STKACT N(10, 0) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CBDMPART *****

***** Change properties for CBDMPART *****
ENDFUNC

FUNCTION MakeTable_CBDMTABL
***** Table setup for CBDMTABL *****
CREATE TABLE 'CBDMTABL.DBF' NAME 'CBDMTABL' (TABLA C(2) NOT NULL, ;
                       CODIGO C(5) NOT NULL, ;
                       NOMBRE C(40) NOT NULL, ;
                       DIGITOS N(2, 0) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODADD C(7) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       PIDDIG L NOT NULL)

***** Create each index for CBDMTABL *****
INDEX ON TABLA+CODIGO TAG TABL01 COLLATE 'MACHINE'
INDEX ON TABLA+NOMBRE TAG TABL02 COLLATE 'MACHINE'

***** Change properties for CBDMTABL *****
***** Load Data
=LoadData_CbdMTabl()
ENDFUNC

FUNCTION MakeTable_CBDNANXO
***** Table setup for CBDNANXO *****
CREATE TABLE 'CBDNANXO.DBF' NAME 'CBDNANXO' (NROAXO C(3) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       SIGNO C(1) NOT NULL, ;
                       FORMA C(1) NOT NULL)

***** Create each index for CBDNANXO *****
INDEX ON NROAXO+NOTA+CODCTA TAG NAXO01 COLLATE 'MACHINE'

***** Change properties for CBDNANXO *****
ENDFUNC

FUNCTION MakeTable_CBDNBALC
***** Table setup for CBDNBALC *****
CREATE TABLE 'CBDNBALC.DBF' NAME 'CBDNBALC' (RUBRO C(3) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       SIGNO C(1) NOT NULL, ;
                       FORMA C(1) NOT NULL)

***** Create each index for CBDNBALC *****
INDEX ON RUBRO+NOTA+CODCTA TAG NBAL01 COLLATE 'MACHINE'

***** Change properties for CBDNBALC *****

**** Load Data
=LoadData_CBDNBALC()
ENDFUNC

FUNCTION MakeTable_CBDNPERN
***** Table setup for CBDNPERN *****
CREATE TABLE 'CBDNPERN.DBF' NAME 'CBDNPERN' (RUBRO C(2) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(5) NOT NULL, ;
                       SIGNO C(1) NOT NULL, ;
                       FORMA C(1) NOT NULL)

***** Create each index for CBDNPERN *****
INDEX ON RUBRO+NOTA+CODCTA TAG NPER01 COLLATE 'MACHINE'

***** Change properties for CBDNPERN *****
***** LOAD DATA
=LoadData_CBDNPERN()
ENDFUNC

FUNCTION MakeTable_CBDRPART
***** Table setup for CBDRPART *****
CREATE TABLE 'CBDRPART.DBF' NAME 'CBDRPART' (CODCTA C(5) NOT NULL, ;
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

***** Create each index for CBDRPART *****

***** Change properties for CBDRPART *****
ENDFUNC

FUNCTION MakeTable_CBDTAJUS
***** Table setup for CBDTAJUS *****
CREATE TABLE 'CBDTAJUS.DBF' NAME 'CBDTAJUS' (CODCTA C(6) NOT NULL, ;
                       FORMAS N(1, 0) NOT NULL, ;
                       CTAAJU C(6) NOT NULL, ;
                       CTRAJU C(6) NOT NULL, ;
                       NROPAR N(6, 0) NOT NULL)

***** Create each index for CBDTAJUS *****
INDEX ON CODCTA TAG AJUS01 COLLATE 'MACHINE'
INDEX ON CTAAJU+CODCTA TAG AJUS02 COLLATE 'MACHINE'
INDEX ON CTRAJU+CODCTA TAG AJUS03 COLLATE 'MACHINE'

***** Change properties for CBDTAJUS *****
ENDFUNC

FUNCTION MakeTable_CBDTANOS
***** Table setup for CBDTANOS *****
CREATE TABLE 'CBDTANOS.DBF' NAME 'CBDTANOS' (PERIODO N(4, 0) NOT NULL, ;
                       MESCONT N(2, 0) NOT NULL, ;
                       MESCAJA N(2, 0) NOT NULL, ;
                       MESCTOI N(2, 0) NOT NULL, ;
                       MESCOST N(2, 0) NOT NULL, ;
                       CIERRE L NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CBDTANOS *****

***** Change properties for CBDTANOS *****
***** LOAD DATA
=LOADDATA_CBDTANOS()
ENDFUNC

FUNCTION MakeTable_CBDTANXO
***** Table setup for CBDTANXO *****
CREATE TABLE 'CBDTANXO.DBF' NAME 'CBDTANXO' (NROAXO C(3) NOT NULL, ;
                       REFAXO C(3) NOT NULL, ;
                       ITMAXO N(3, 0) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       MENOS C(1) NOT NULL, ;
                       SIGNO C(1) NOT NULL, ;
                       RAYAS C(1) NOT NULL, ;
                       QUIEB C(1) NOT NULL, ;
                       MODAXO N(1, 0) NOT NULL, ;
                       GLOAXO C(40) NOT NULL, ;
                       FORMAT N(1, 0) NOT NULL)

***** Create each index for CBDTANXO *****
INDEX ON NROAXO+REFAXO+STR(ITMAXO,3,0)+CODCTA TAG ANXO01 COLLATE 'MACHINE'

***** Change properties for CBDTANXO *****

***** Load Data
=LoadData_cbdtanxo()
ENDFUNC

FUNCTION MakeTable_CBDTBALC
***** Table setup for CBDTBALC *****
CREATE TABLE 'CBDTBALC.DBF' NAME 'CBDTBALC' (RUBRO C(3) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       CHKITM N(3, 0) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       GLOSA C(47) NOT NULL, ;
                       MESS00 N(14, 2) NOT NULL, ;
                       MESS01 N(14, 2) NOT NULL, ;
                       MESS02 N(14, 2) NOT NULL, ;
                       MESS03 N(14, 2) NOT NULL, ;
                       MESS04 N(14, 2) NOT NULL, ;
                       MESS05 N(14, 2) NOT NULL, ;
                       MESS06 N(14, 2) NOT NULL, ;
                       MESS07 N(14, 2) NOT NULL, ;
                       MESS08 N(14, 2) NOT NULL, ;
                       MESS09 N(14, 2) NOT NULL, ;
                       MESS10 N(14, 2) NOT NULL, ;
                       MESS11 N(14, 2) NOT NULL, ;
                       MESS12 N(14, 2) NOT NULL, ;
                       MESS13 N(14, 2) NOT NULL, ;
                       MESD00 N(14, 2) NOT NULL, ;
                       MESD01 N(14, 2) NOT NULL, ;
                       MESD02 N(14, 2) NOT NULL, ;
                       MESD03 N(14, 2) NOT NULL, ;
                       MESD04 N(14, 2) NOT NULL, ;
                       MESD05 N(14, 2) NOT NULL, ;
                       MESD06 N(14, 2) NOT NULL, ;
                       MESD07 N(14, 2) NOT NULL, ;
                       MESD08 N(14, 2) NOT NULL, ;
                       MESD09 N(14, 2) NOT NULL, ;
                       MESD10 N(14, 2) NOT NULL, ;
                       MESD11 N(14, 2) NOT NULL, ;
                       MESD12 N(14, 2) NOT NULL, ;
                       MESD13 N(14, 2) NOT NULL)

***** Create each index for CBDTBALC *****
INDEX ON RUBRO+STR(NROITM,3,0) TAG TBAL01 COLLATE 'MACHINE'

***** Change properties for CBDTBALC *****

****** LOAD DATA
=LoadData_CBDTBALC()

ENDFUNC

FUNCTION MakeTable_CBDTCNFG
***** Table setup for CBDTCNFG *****
CREATE TABLE 'CBDTCNFG.DBF' NAME 'CBDTCNFG' (CODCFG C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       GLOCFG C(40) NOT NULL, ;
                       CODCTA1 C(8) NOT NULL, ;
                       CODCTA2 C(8) NOT NULL, ;
                       CODCTA3 C(8) NOT NULL, ;
                       CODCTA4 C(8) NOT NULL, ;
                       CODAUX1 C(8) NOT NULL, ;
                       CODAUX2 C(8) NOT NULL, ;
                       CODAUX3 C(8) NOT NULL, ;
                       CODAUX4 C(8) NOT NULL, ;
                       DIF_ME N(10, 4) NOT NULL, ;
                       DIF_MN N(10, 4) NOT NULL)

***** Create each index for CBDTCNFG *****
INDEX ON CODCFG TAG CNFG01 COLLATE 'MACHINE'

***** Change properties for CBDTCNFG *****

***** LOAD DATA 
=LoadData_CBDTCNFG()
ENDFUNC

FUNCTION MakeTable_CBDTCOST
***** Table setup for CBDTCOST *****
CREATE TABLE 'CBDTCOST.DBF' NAME 'CBDTCOST' (CODMAT C(8) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       TPOGTO C(2) NOT NULL, ;
                       GLOSA C(40) NOT NULL, ;
                       TCST01 N(16, 4) NOT NULL, ;
                       TCST02 N(16, 4) NOT NULL, ;
                       TCST03 N(16, 4) NOT NULL, ;
                       TCST04 N(16, 4) NOT NULL, ;
                       TCST05 N(16, 4) NOT NULL, ;
                       TCST06 N(16, 4) NOT NULL, ;
                       TCST07 N(16, 4) NOT NULL, ;
                       TCST08 N(16, 4) NOT NULL, ;
                       TCST09 N(16, 4) NOT NULL, ;
                       TCST10 N(16, 4) NOT NULL, ;
                       TOTD01 N(16, 4) NOT NULL, ;
                       TOTD02 N(16, 4) NOT NULL, ;
                       TOTD03 N(16, 4) NOT NULL, ;
                       TOTD04 N(16, 4) NOT NULL, ;
                       TOTD05 N(16, 4) NOT NULL, ;
                       TOTD06 N(16, 4) NOT NULL, ;
                       TOTD07 N(16, 4) NOT NULL, ;
                       TOTD08 N(16, 4) NOT NULL, ;
                       TOTD09 N(16, 4) NOT NULL, ;
                       TOTD10 N(16, 4) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       CHQADO N(10, 0) NOT NULL)

***** Create each index for CBDTCOST *****

***** Change properties for CBDTCOST *****
ENDFUNC

FUNCTION MakeTable_CBDTPERN
***** Table setup for CBDTPERN *****
CREATE TABLE 'CBDTPERN.DBF' NAME 'CBDTPERN' (RUBRO C(2) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       CHKITM N(3, 0) NOT NULL, ;
                       NOTA C(2) NOT NULL, ;
                       GLOCTA C(15) NOT NULL, ;
                       GLOSA C(50) NOT NULL, ;
                       MESS00 N(14, 2) NOT NULL, ;
                       MESS01 N(14, 2) NOT NULL, ;
                       MESS02 N(14, 2) NOT NULL, ;
                       MESS03 N(14, 2) NOT NULL, ;
                       MESS04 N(14, 2) NOT NULL, ;
                       MESS05 N(14, 2) NOT NULL, ;
                       MESS06 N(14, 2) NOT NULL, ;
                       MESS07 N(14, 2) NOT NULL, ;
                       MESS08 N(14, 2) NOT NULL, ;
                       MESS09 N(14, 2) NOT NULL, ;
                       MESS10 N(14, 2) NOT NULL, ;
                       MESS11 N(14, 2) NOT NULL, ;
                       MESS12 N(14, 2) NOT NULL, ;
                       MESS13 N(14, 2) NOT NULL, ;
                       MESD00 N(14, 2) NOT NULL, ;
                       MESD01 N(14, 2) NOT NULL, ;
                       MESD02 N(14, 2) NOT NULL, ;
                       MESD03 N(14, 2) NOT NULL, ;
                       MESD04 N(14, 2) NOT NULL, ;
                       MESD05 N(14, 2) NOT NULL, ;
                       MESD06 N(14, 2) NOT NULL, ;
                       MESD07 N(14, 2) NOT NULL, ;
                       MESD08 N(14, 2) NOT NULL, ;
                       MESD09 N(14, 2) NOT NULL, ;
                       MESD10 N(14, 2) NOT NULL, ;
                       MESD11 N(14, 2) NOT NULL, ;
                       MESD12 N(14, 2) NOT NULL, ;
                       MESD13 N(14, 2) NOT NULL, ;
                       PRESOL N(12, 2) NOT NULL, ;
                       PREDOL N(12, 2) NOT NULL, ;
                       PORTIP N(6, 2) NOT NULL, ;
                       PORAMA N(6, 2) NOT NULL, ;
                       PORMES N(6, 2) NOT NULL, ;
                       PORACM N(6, 2) NOT NULL)

***** Create each index for CBDTPERN *****
INDEX ON RUBRO+STR(NROITM,3,0) TAG TPER01 COLLATE 'MACHINE'

***** Change properties for CBDTPERN *****

***** Load Data 
=LoadData_CBDTPERN()
ENDFUNC

FUNCTION MakeTable_CBDCNFG0
***** Table setup for CBDCNFG0 *****
CREATE TABLE 'CBDCNFG0.DBF' NAME 'CBDCNFG0' (TIPO_EMPRE N(1, 0) NOT NULL, ;
                       TIPO_CONSO N(1, 0) NOT NULL, ;
                       MAX_AUXIL N(2, 0) NOT NULL, ;
                       C_COSTO N(1, 0) NOT NULL, ;
                       MASC_CORRE C(20) NOT NULL, ;
                       NDIG_CORRE N(2, 0) NOT NULL, ;
                       NDIG_TERM1 N(2, 0) NOT NULL, ;
                       NDIG_TERM2 N(2, 0) NOT NULL, ;
                       NDIG_TERM3 N(2, 0) NOT NULL, ;
                       NDIG_TERM4 N(2, 0) NOT NULL, ;
                       POS_TERM1 N(1, 0) NOT NULL, ;
                       POS_TERM2 N(1, 0) NOT NULL, ;
                       POS_TERM3 N(1, 0) NOT NULL, ;
                       POS_TERM4 N(1, 0) NOT NULL, ;
                       DIR_SIST1 C(10) NOT NULL, ;
                       DIR_SIST2 C(10) NOT NULL, ;
                       DIR_SIST3 C(10) NOT NULL, ;
                       G_AN1CTA C(15) NOT NULL, ;
                       G_CC1CTA C(15) NOT NULL, ;
                       CC1CTA C(10) NOT NULL, ;
                       G_AN2CTA C(15) NOT NULL, ;
                       G_CC2CTA C(15) NOT NULL, ;
                       CC2CTA C(10) NOT NULL, ;
                       MON_NAC C(10) NOT NULL, ;
                       MON_EXT C(10) NOT NULL, ;
                       MON_EXT2 C(10) NOT NULL, ;
                       GENAUT_COSTOS C(60) NOT NULL, ;
                       GENAUT_EXISTEN C(60) NOT NULL)

***** Create each index for CBDCNFG0 *****

***** Change properties for CBDCNFG0 *****
DBSETPROP('CBDCNFG0.G_CC1CTA', 'Field', 'Comment', "Codigo de contra cuenta automatica por defecto")
***** Load Data
=LoadData_cbdcnfg0()

ENDFUNC

FUNCTION MakeTable_CJATPROV
***** Table setup for CJATPROV *****
CREATE TABLE 'CJATPROV.DBF' NAME 'CJATPROV' (TPODOC C(4) NOT NULL, ;
                       TIPO C(1) NOT NULL, ;
                       CODCTA C(180) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       GIRADO C(40) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       TIPREG C(1) NOT NULL)

***** Create each index for CJATPROV *****
INDEX ON TPODOC+CODCTA TAG PROV01 COLLATE 'MACHINE'
INDEX ON CODOPE TAG PROV02 COLLATE 'MACHINE'

***** Change properties for CJATPROV *****

***** Load Data
=LoadData_CJATPROV()

ENDFUNC

FUNCTION MakeTable_CCBMVTOS
***** Table setup for CCBMVTOS *****
CREATE TABLE 'CCBMVTOS.DBF' NAME 'CCBMVTOS' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       TPODOC C(1) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHING D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       TPOREF C(5) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       NROPLA C(9) NOT NULL, ;
                       NROITM N(4, 0) NOT NULL, ;
                       GLODOC C(40) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       CODIGO C(5) NOT NULL, ;
                       CODADD C(6) NOT NULL, ;
                       CODCTA C(7) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       FLGCTB L NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       IMPINT N(12, 2) NOT NULL, ;
                       IMPGAS N(12, 2) NOT NULL)

***** Create each index for CCBMVTOS *****
INDEX ON CODDOC+NRODOC TAG VTOS01 COLLATE 'MACHINE'
INDEX ON CODDOC+DTOS(FCHDOC)+NRODOC TAG VTOS02 COLLATE 'MACHINE'
INDEX ON DTOS(FCHDOC)+TPOREF+CODREF+NROREF TAG VTOS06 COLLATE 'MACHINE'
INDEX ON DTOS(FCHDOC)+TPOREF+CODREF+NROREF TAG VTOS08 COLLATE 'MACHINE'
INDEX ON CODCLI+CODDOC+NRODOC TAG VTOS04 COLLATE 'MACHINE'
INDEX ON CODCLI+CODREF+NROREF TAG VTOS05 COLLATE 'MACHINE'
INDEX ON CODREF+NROREF+CODDOC+CODOPE+NROAST TAG VTOS03 COLLATE 'MACHINE'

***** Change properties for CCBMVTOS *****
ENDFUNC

FUNCTION MakeTable_CCBNRASG
***** Table setup for CCBNRASG *****
CREATE TABLE 'CCBNRASG.DBF' NAME 'CCBNRASG' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       TPODOC C(1) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       TPOREF C(5) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(9) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       FCHREF D NOT NULL, ;
                       VTOREF D NOT NULL, ;
                       IMPINT N(12, 2) NOT NULL, ;
                       IMPIGV N(12, 2) NOT NULL, ;
                       IMPTOT N(12, 2) NOT NULL, ;
                       DIALET N(3, 0) NOT NULL)

***** Create each index for CCBNRASG *****
INDEX ON CODDOC+NRODOC+TPOREF+CODREF+NROREF TAG RASG01 COLLATE 'MACHINE'

***** Change properties for CCBNRASG *****
ENDFUNC

FUNCTION MakeTable_CCBNTASG
***** Table setup for CCBNTASG *****
CREATE TABLE 'CCBNTASG.DBF' NAME 'CCBNTASG' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       TPODOC C(4) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHING D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       GLODOC C(40) NOT NULL, ;
                       GLOSA1 C(40) NOT NULL, ;
                       GLOSA2 C(40) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       IMPDOC N(12, 2) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       NROCUO N(2, 0) NOT NULL, ;
                       PORIPM N(5, 2) NOT NULL, ;
                       PORIGV N(5, 2) NOT NULL, ;
                       IMPCUP N(12, 2) NOT NULL, ;
                       PORINT N(5, 2) NOT NULL, ;
                       TIPINT C(1) NOT NULL, ;
                       DIALET N(3, 0) NOT NULL, ;
                       DIALIB N(3, 0) NOT NULL, ;
                       PIDCUP C(1) NOT NULL, ;
                       CANLET N(2, 0) NOT NULL, ;
                       IMPIGV N(12, 2) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(9) NOT NULL, ;
                       IMPBTO N(12, 2) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       CODCTA C(7) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(15) NOT NULL, ;
                       NROLIQ C(10) NOT NULL, ;
                       FCHCIE D NOT NULL, ;
                       FLGLIQ C(1) NOT NULL, ;
                       EFENAC N(12, 2) NOT NULL, ;
                       EFEUSA N(12, 2) NOT NULL, ;
                       CHQNAC N(12, 2) NOT NULL, ;
                       CHQUSA N(12, 2) NOT NULL, ;
                       DEPNAC N(12, 2) NOT NULL, ;
                       DEPUSA N(12, 2) NOT NULL, ;
                       TOTEFE N(12, 2) NOT NULL, ;
                       TOTCHQ N(12, 2) NOT NULL, ;
                       TOTDEP N(12, 2) NOT NULL, ;
                       EFENACD N(12, 2) NOT NULL, ;
                       EFEUSAD N(12, 2) NOT NULL, ;
                       CHQNACD N(12, 2) NOT NULL, ;
                       CHQUSAD N(12, 2) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       FLGCTB L NOT NULL, ;
                       CODADD C(6) NOT NULL, ;
                       TIPTAS N(1, 0) NOT NULL, ;
                       NROAST1 C(8) NOT NULL, ;
                       NROMES1 C(2) NOT NULL, ;
                       CODOPE1 C(3) NOT NULL, ;
                       FLGCTB1 L NOT NULL)

***** Create each index for CCBNTASG *****
INDEX ON CODDOC+NRODOC TAG TASG01 COLLATE 'MACHINE'
INDEX ON CODDOC+FLGEST+NRODOC TAG TASG03 COLLATE 'MACHINE'
INDEX ON CODDOC+DTOS(FCHDOC)+NRODOC TAG TASG04 COLLATE 'MACHINE'
INDEX ON CODREF+NROREF+CODDOC+NRODOC TAG TASG05 COLLATE 'MACHINE'
INDEX ON CODDOC+FLGLIQ+DTOS(FCHDOC)+NRODOC TAG TASG06 COLLATE 'MACHINE'
INDEX ON CODCLI+CODDOC+NRODOC TAG TASG02 COLLATE 'MACHINE'

***** Change properties for CCBNTASG *****
ENDFUNC

FUNCTION MakeTable_CCBRGDOC
***** Table setup for CCBRGDOC *****
CREATE TABLE 'CCBRGDOC.DBF' NAME 'CCBRGDOC' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       TPODOC C(5) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       NOMCLI C(50) NOT NULL, ;
                       CODDIRE C(3) NOT NULL, ;
                       DIRCLI C(50) NOT NULL, ;
                       RUCCLI C(11) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       IMPNET N(14, 4) NOT NULL, ;
                       IMPDTO N(14, 4) NOT NULL, ;
                       IMPFLT N(14, 4) NOT NULL, ;
                       IMPSEL N(14, 4) NOT NULL, ;
                       IMPIGV N(14, 4) NOT NULL, ;
                       IMPTOT N(14, 4) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(40) NOT NULL, ;
                       SDODOC N(14, 4) NOT NULL, ;
                       TPOREF C(5) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       NROPED C(8) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       FLGUBC C(1) NOT NULL, ;
                       FLGSIT C(1) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       CODCTA C(7) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCTA C(16) NOT NULL, ;
                       FCHUBC D NOT NULL, ;
                       CODCOB N(2, 0) NOT NULL, ;
                       PORIGV N(5, 2) NOT NULL, ;
                       IMPBTO N(14, 4) NOT NULL CHECK cal_impbrt(), ;
                       GLOSA1 C(80) NOT NULL, ;
                       GLOSA2 C(80) NOT NULL, ;
                       GLOSA3 C(80) NOT NULL, ;
                       GLOSA4 C(80) NOT NULL, ;
                       CODZON C(1) NOT NULL, ;
                       TRACTB C(1) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       IMPINT N(14, 4) NOT NULL, ;
                       IMPGAS N(14, 4) NOT NULL, ;
                       IMPADM N(14, 4) NOT NULL, ;
                       NROO_C C(20) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       FMASOL C(25) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       CNDPGO C(18) NOT NULL CHECK _fmapgo(), ;
                       DIAVTO N(3, 0) NOT NULL, ;
                       CODVEN C(4) NOT NULL, ;
                       PORDTO N(5, 2) NOT NULL, ;
                       FCHEMI D NOT NULL, ;
                       FLGCTB L NOT NULL, ;
                       NROPLA C(6) NOT NULL, ;
                       MESCTB C(2) NOT NULL, ;
                       OPECTB C(3) NOT NULL, ;
                       ASTCTB C(8) NOT NULL, ;
                       FLGESTA C(1) NOT NULL, ;
                       FLGSITA C(1) NOT NULL, ;
                       FLGUBCA C(1) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       SDOUSA N(12, 2) NOT NULL, ;
                       MESPRT C(2) NOT NULL, ;
                       OPEPRT C(3) NOT NULL, ;
                       ASTPRT C(8) NOT NULL, ;
                       FLGPRT L NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       IMPBRT N(14, 4) NOT NULL, ;
                       TPOVTA N(1, 0) NOT NULL, ;
                       IMPSEG N(14, 4) NOT NULL, ;
                       DESTINO C(1) NOT NULL, ;
                       VIA C(1) NOT NULL, ;
                       TABLDEST C(2) NOT NULL, ;
                       TABLVIA C(2) NOT NULL, ;
                       CODVIA C(2) NOT NULL, ;
                       TABLRUTA C(2) NOT NULL, ;
                       RUTA C(5) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       AGENTE C(1) NOT NULL, ;
                       RETEN N(12, 2) NOT NULL)

***** Create each index for CCBRGDOC *****
INDEX ON FLGEST+TPODOC+CODDOC+NRODOC TAG GDOC05 COLLATE 'MACHINE'
INDEX ON TPOREF+CODREF+NROREF+TPODOC+CODDOC+NRODOC TAG GDOC03 COLLATE 'MACHINE'
INDEX ON CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC+FLGSIT+NRODOC TAG GDOC06 COLLATE 'MACHINE'
INDEX ON FLGEST+FLGSIT+TPODOC+CODDOC+NRODOC TAG GDOC07 COLLATE 'MACHINE'
INDEX ON FLGEST+FLGUBC+TPODOC+CODDOC+NRODOC TAG GDOC09 COLLATE 'MACHINE'
INDEX ON CODDOC+FLGUBC+FLGSIT+NROPLA+CODCTA TAG GDOC10 COLLATE 'MACHINE'
INDEX ON CODCLI+TPODOC+CODDOC+NRODOC TAG GDOC02 COLLATE 'MACHINE'
INDEX ON CODCLI+FLGEST+TPODOC+CODDOC+NRODOC TAG GDOC04 COLLATE 'MACHINE'
INDEX ON DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC TAG GDOC08 COLLATE 'MACHINE'
INDEX ON TPODOC+CODDOC+NRODOC TAG GDOC01 COLLATE 'MACHINE'

***** Change properties for CCBRGDOC *****
DBSETPROP('CCBRGDOC.TPODOC', 'Field', 'InputMask', "@!")
ENDFUNC

FUNCTION MakeTable_CCBRRDOC
***** Table setup for CCBRRDOC *****
CREATE TABLE 'CCBRRDOC.DBF' NAME 'CCBRRDOC' (TPODOC C(5) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       CODIGO C(5) NOT NULL, ;
                       IMPORT N(14, 4) NOT NULL, ;
                       GLOSA C(50) NOT NULL)

***** Create each index for CCBRRDOC *****
INDEX ON TPODOC+CODDOC+NRODOC TAG RDOC01 COLLATE 'MACHINE'

***** Change properties for CCBRRDOC *****
ENDFUNC

FUNCTION MakeTable_CCBSALDO
***** Table setup for CCBSALDO *****
CREATE TABLE 'CCBSALDO.DBF' NAME 'CCBSALDO' (CODCLI C(11) NOT NULL, ;
                       CGONAC N(12, 2) NOT NULL, ;
                       CGOUSA N(12, 2) NOT NULL, ;
                       ABNNAC N(12, 2) NOT NULL, ;
                       ABNUSA N(12, 2) NOT NULL)

***** Create each index for CCBSALDO *****
INDEX ON CODCLI TAG SLDO01 COLLATE 'MACHINE'

***** Change properties for CCBSALDO *****
ENDFUNC

FUNCTION MakeTable_CCTCDIRE
***** Table setup for CCTCDIRE *****
CREATE TABLE 'CCTCDIRE.DBF' NAME 'CCTCDIRE' (CLFAUX C(3) NOT NULL, ;
                       CODAUX C(11) NOT NULL, ;
                       CODCLI C(4) NOT NULL, ;
                       CODDIRE C(3) NOT NULL, ;
                       DESDIRE C(60) NOT NULL, ;
                       CODZONA C(3) NOT NULL, ;
                       CODDIST C(3) NOT NULL, ;
                       CODPAIS C(3) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CCTCDIRE *****
INDEX ON CODCLI+CODDIRE TAG DIRE01 COLLATE 'MACHINE'
INDEX ON CLFAUX+CODAUX TAG DIRE02 COLLATE 'MACHINE'

***** Change properties for CCTCDIRE *****
ENDFUNC

FUNCTION MakeTable_CFCMPROY
***** Table setup for CFCMPROY *****
CREATE TABLE 'CFCMPROY.DBF' NAME 'CFCMPROY' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL)

***** Create each index for CFCMPROY *****
INDEX ON CODTT TAG TBTT02 COLLATE 'MACHINE'
INDEX ON NIVEL TAG TBTT03 COLLATE 'MACHINE'

***** Change properties for CFCMPROY *****
ENDFUNC

FUNCTION MakeTable_CJACFNZA
***** Table setup for CJACFNZA *****
CREATE TABLE 'CJACFNZA.DBF' NAME 'CJACFNZA' (CODDOC C(4) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       CODAUX C(6) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       NOMAUX C(40) NOT NULL, ;
                       RUCAUX C(8) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       FCHPGO D NOT NULL, ;
                       IMPPGO N(12, 2) NOT NULL, ;
                       IMPORI N(12, 2) NOT NULL, ;
                       FCHREC D NOT NULL, ;
                       GIRADO L NOT NULL, ;
                       CODCTA C(5) NOT NULL, ;
                       TOTAL2 N(12, 2) NOT NULL, ;
                       TOTAL1 N(12, 2) NOT NULL, ;
                       NROAST C(6) NOT NULL, ;
                       FCHAST D NOT NULL)

***** Create each index for CJACFNZA *****
INDEX ON CODDOC+NRODOC TAG FNZA01 COLLATE 'MACHINE'
INDEX ON DTOS(FCHPGO)+NRODOC TAG FNZA02 COLLATE 'MACHINE'
INDEX ON DTOS(FCHPGO)+NOMAUX TAG FNZA04 COLLATE 'MACHINE'
INDEX ON NRODOC TAG FNZA06 COLLATE 'MACHINE'
INDEX ON CODAUX+DTOS(FCHPGO)+NRODOC TAG FNZA03 COLLATE 'MACHINE'
INDEX ON CODCTA+CODAUX+NRODOC TAG FNZA05 COLLATE 'MACHINE'

***** Change properties for CJACFNZA *****
ENDFUNC

FUNCTION MakeTable_CJATFNZA
***** Table setup for CJATFNZA *****
CREATE TABLE 'CJATFNZA.DBF' NAME 'CJATFNZA' (TPODOC C(4) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       CODCTA C(200) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       FLGMAR C(1) NOT NULL)

***** Create each index for CJATFNZA *****
INDEX ON TPODOC TAG FNZA01 COLLATE 'MACHINE'

***** Change properties for CJATFNZA *****
ENDFUNC

FUNCTION MakeTable_CCB1FACT
***** Table setup for CCB1FACT *****
CREATE TABLE 'CCB1FACT.DBF' NAME 'CCB1FACT' (TPODOC C(7) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODAUX C(10) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       CODALM C(3) NOT NULL, ;
                       NROGUI C(6) NOT NULL, ;
                       NROPED C(6) NOT NULL, ;
                       TPOCMB N(16, 6) NOT NULL, ;
                       IMPORT N(16, 2) NOT NULL, ;
                       IMPBRT N(16, 2) NOT NULL, ;
                       IMPDST N(16, 2) NOT NULL, ;
                       IMPRET N(16, 2) NOT NULL, ;
                       IMPIGV N(16, 2) NOT NULL, ;
                       PLZVTO N(2, 0) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       FCHVT1 D NOT NULL, ;
                       GLODOC C(60) NOT NULL, ;
                       SDOINI N(16, 2) NOT NULL, ;
                       SDOACT N(16, 2) NOT NULL, ;
                       CODVEN C(3) NOT NULL, ;
                       TPOREF C(7) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       FCHCAN D NOT NULL, ;
                       FLGCAN C(1) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       CODCTA C(10) NOT NULL, ;
                       NOMCLI C(40) NOT NULL, ;
                       DIRCLI C(40) NOT NULL, ;
                       TPOCLI C(2) NOT NULL, ;
                       GLOSA1 C(40) NOT NULL, ;
                       GLOSA2 C(40) NOT NULL, ;
                       FLGDES C(1) NOT NULL, ;
                       FLGLIQ C(1) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       FCHING D NOT NULL, ;
                       TPODES C(1) NOT NULL, ;
                       IGV N(16, 2) NOT NULL, ;
                       HORA C(5) NOT NULL, ;
                       USUARIO C(10) NOT NULL, ;
                       IMPISC N(14, 2) NOT NULL, ;
                       DISCLI C(30) NOT NULL, ;
                       ORDCMP C(8) NOT NULL, ;
                       RUCCLI C(10) NOT NULL, ;
                       TRANSP C(25) NOT NULL, ;
                       RUCTRA C(10) NOT NULL, ;
                       DIRTRA C(25) NOT NULL, ;
                       LETRA C(10) NOT NULL, ;
                       MOTIVO N(1, 0) NOT NULL, ;
                       IMPRGU C(1) NOT NULL, ;
                       FLGTRA C(1) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       PTOPAR C(30) NOT NULL)

***** Create each index for CCB1FACT *****

***** Change properties for CCB1FACT *****
ENDFUNC

FUNCTION MakeTable_CMPCREQU
***** Table setup for CMPCREQU *****
CREATE TABLE 'CMPCREQU.DBF' NAME 'CMPCREQU' (NROREQ C(7) NOT NULL, ;
                       FCHREQ D NOT NULL, ;
                       USUARIO C(3) NOT NULL, ;
                       CODCMP C(3) NOT NULL, ;
                       TPOREQ C(1) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CODUAS C(7) NOT NULL, ;
                       CANREQ N(12, 4) NOT NULL, ;
                       CANPED N(12, 4) NOT NULL, ;
                       DESREQ M NOT NULL, ;
                       FCHENT D NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       NROO_C C(7) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       GLOREQ C(40) NOT NULL, ;
                       FLGHIS C(1) NOT NULL, ;
                       FLGLOG C(1) NOT NULL, ;
                       DETALLE M NOT NULL, ;
                       CODCTA C(5) NOT NULL, ;
                       UNDCMP C(3) NOT NULL, ;
                       FACEQU N(12, 4) NOT NULL, ;
                       FLGSEL C(1) NOT NULL, ;
                       USER C(8) NOT NULL, ;
                       CANDES N(12, 4) NOT NULL, ;
                       CANSOL N(12, 4) NOT NULL, ;
                       SEDE C(2) NOT NULL, ;
                       DIVISI C(3) NOT NULL, ;
                       AREAS C(3) NOT NULL, ;
                       SECCIO C(3) NOT NULL, ;
                       PESO N(12, 4) NOT NULL, ;
                       TPOBIE C(1) NOT NULL, ;
                       CODNEW C(13) NOT NULL)

***** Create each index for CMPCREQU *****
INDEX ON USUARIO+FLGHIS+NROREQ TAG CREQ01 COLLATE 'MACHINE'
INDEX ON FLGLOG+NROREQ TAG CREQ02 COLLATE 'MACHINE'
INDEX ON NROREQ+USUARIO+FLGHIS TAG CREQ03 COLLATE 'MACHINE'
INDEX ON FLGLOG+USUARIO+NROREQ TAG CREQ04 COLLATE 'MACHINE'
INDEX ON FLGLOG+DTOS(FCHENT) TAG CREQ05 COLLATE 'MACHINE'
INDEX ON USUARIO+NROREQ TAG CREQ06 COLLATE 'MACHINE'
INDEX ON FLGHIS+NROREQ TAG CREQ07 COLLATE 'MACHINE'
INDEX ON DTOS(FCHREQ)+NROREQ TAG CREQ08 COLLATE 'MACHINE'
INDEX ON CODMAT+DTOS(FCHENT) TAG CREQ09 COLLATE 'MACHINE'

***** Change properties for CMPCREQU *****
ENDFUNC

FUNCTION MakeTable_CMPDDIST
***** Table setup for CMPDDIST *****
CREATE TABLE 'CMPDDIST.DBF' NAME 'CMPDDIST' (PERIODO C(6) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CODAUX C(6) NOT NULL, ;
                       PORDIS N(8, 2) NOT NULL, ;
                       CANCOM N(12, 2) NOT NULL, ;
                       FMAPGO C(4) NOT NULL, ;
                       EMIO_C N(3, 0) NOT NULL, ;
                       N_ENTREGA N(10, 0) NOT NULL, ;
                       TASA1 N(8, 2) NOT NULL, ;
                       TASA2 N(8, 2) NOT NULL, ;
                       FCHENT1 D NOT NULL, ;
                       FCHENT2 D NOT NULL, ;
                       FCHENT3 D NOT NULL, ;
                       FCHENT4 D NOT NULL, ;
                       FCHENT5 D NOT NULL, ;
                       FCHENT6 D NOT NULL, ;
                       FCHENT7 D NOT NULL, ;
                       FCHENT8 D NOT NULL, ;
                       FCHENT9 D NOT NULL, ;
                       FCHENT10 D NOT NULL, ;
                       CODNEW C(13) NOT NULL)

***** Create each index for CMPDDIST *****
INDEX ON PERIODO+CODMAT+CODAUX TAG DDIS01 COLLATE 'MACHINE'
INDEX ON CODMAT TAG DDIS02 COLLATE 'MACHINE'

***** Change properties for CMPDDIST *****
ENDFUNC

FUNCTION MakeTable_CMPDIMPO
***** Table setup for CMPDIMPO *****
CREATE TABLE 'CMPDIMPO.DBF' NAME 'CMPDIMPO' (FLUJO C(4) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       CONCEPTO C(20) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHPRY D NOT NULL, ;
                       IMPPROY1 N(12, 2) NOT NULL, ;
                       IMPPROY2 N(12, 2) NOT NULL)

***** Create each index for CMPDIMPO *****
INDEX ON PERIODO+NIVEL+DTOS(FCHPRY)+NROREF TAG DIMP01 COLLATE 'MACHINE'
INDEX ON NIVEL+DTOS(FCHPRY) TAG DIMP02 COLLATE 'MACHINE'

***** Change properties for CMPDIMPO *****
ENDFUNC

FUNCTION MakeTable_CMPMODIM
***** Table setup for CMPMODIM *****
CREATE TABLE 'CMPMODIM.DBF' NAME 'CMPMODIM' (TPOREG C(4) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       NROORD C(7) NOT NULL, ;
                       FCHORD D NOT NULL, ;
                       NROREQ C(7) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       FCHENT D NOT NULL, ;
                       GRUPO C(2) NOT NULL, ;
                       CONCEPTO C(10) NOT NULL, ;
                       PORCEN N(6, 2) NOT NULL, ;
                       VALOR N(12, 2) NOT NULL, ;
                       TOT1 C(2) NOT NULL, ;
                       TOT2 C(2) NOT NULL, ;
                       CDFCJA C(4) NOT NULL, ;
                       FMAPGO C(4) NOT NULL)

***** Create each index for CMPMODIM *****
INDEX ON TPOREG+NROORD+CODMAT+NROREQ+GRUPO TAG MDLO01 COLLATE 'MACHINE'

***** Change properties for CMPMODIM *****
ENDFUNC

FUNCTION MakeTable_CMPPACIN
***** Table setup for CMPPACIN *****
CREATE TABLE 'CMPPACIN.DBF' NAME 'CMPPACIN' (NIVEL C(3) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       SI01 N(14, 4) NOT NULL, ;
                       SI03 N(14, 4) NOT NULL, ;
                       SI05 N(14, 4) NOT NULL, ;
                       SI02 N(14, 4) NOT NULL, ;
                       SI04 N(14, 4) NOT NULL, ;
                       SI06 N(14, 4) NOT NULL, ;
                       SI07 N(14, 4) NOT NULL, ;
                       SI09 N(14, 4) NOT NULL, ;
                       SI11 N(14, 4) NOT NULL, ;
                       SI08 N(14, 4) NOT NULL, ;
                       SI10 N(14, 4) NOT NULL, ;
                       SI12 N(14, 4) NOT NULL, ;
                       CP01 N(14, 4) NOT NULL, ;
                       CP03 N(14, 4) NOT NULL, ;
                       CP05 N(14, 4) NOT NULL, ;
                       CP02 N(14, 4) NOT NULL, ;
                       CP04 N(14, 4) NOT NULL, ;
                       CP06 N(14, 4) NOT NULL, ;
                       CP07 N(14, 4) NOT NULL, ;
                       CP09 N(14, 4) NOT NULL, ;
                       CP11 N(14, 4) NOT NULL, ;
                       CP08 N(14, 4) NOT NULL, ;
                       CP10 N(14, 4) NOT NULL, ;
                       CP12 N(14, 4) NOT NULL, ;
                       CS01 N(14, 4) NOT NULL, ;
                       CS03 N(14, 4) NOT NULL, ;
                       CS05 N(14, 4) NOT NULL, ;
                       CS02 N(14, 4) NOT NULL, ;
                       CS04 N(14, 4) NOT NULL, ;
                       CS06 N(14, 4) NOT NULL, ;
                       CS07 N(14, 4) NOT NULL, ;
                       CS09 N(14, 4) NOT NULL, ;
                       CS11 N(14, 4) NOT NULL, ;
                       CS08 N(14, 4) NOT NULL, ;
                       CS10 N(14, 4) NOT NULL, ;
                       CS12 N(14, 4) NOT NULL, ;
                       SV01 N(14, 4) NOT NULL, ;
                       SV02 N(14, 4) NOT NULL, ;
                       SV03 N(14, 4) NOT NULL, ;
                       SV04 N(14, 4) NOT NULL, ;
                       SV05 N(14, 4) NOT NULL, ;
                       SV06 N(14, 4) NOT NULL, ;
                       SV07 N(14, 4) NOT NULL, ;
                       SV08 N(14, 4) NOT NULL, ;
                       SV09 N(14, 4) NOT NULL, ;
                       SV10 N(14, 4) NOT NULL, ;
                       SV11 N(14, 4) NOT NULL, ;
                       SV12 N(14, 4) NOT NULL, ;
                       SF01 N(14, 4) NOT NULL, ;
                       SF02 N(14, 4) NOT NULL, ;
                       SF03 N(14, 4) NOT NULL, ;
                       SF04 N(14, 4) NOT NULL, ;
                       SF05 N(14, 4) NOT NULL, ;
                       SF06 N(14, 4) NOT NULL, ;
                       SF07 N(14, 4) NOT NULL, ;
                       SF08 N(14, 4) NOT NULL, ;
                       SF09 N(14, 4) NOT NULL, ;
                       SF10 N(14, 4) NOT NULL, ;
                       SF11 N(14, 4) NOT NULL, ;
                       SF12 N(14, 4) NOT NULL, ;
                       NC01 N(6, 0) NOT NULL, ;
                       NC02 N(6, 0) NOT NULL, ;
                       NC03 N(6, 0) NOT NULL, ;
                       NC04 N(6, 0) NOT NULL, ;
                       NC05 N(6, 0) NOT NULL, ;
                       NC06 N(6, 0) NOT NULL, ;
                       NC07 N(6, 0) NOT NULL, ;
                       NC08 N(6, 0) NOT NULL, ;
                       NC09 N(6, 0) NOT NULL, ;
                       NC10 N(6, 0) NOT NULL, ;
                       NC11 N(6, 0) NOT NULL, ;
                       NC12 N(6, 0) NOT NULL, ;
                       FACRF1 N(8, 2) NOT NULL, ;
                       FACRF2 N(8, 2) NOT NULL, ;
                       M01 C(1) NOT NULL, ;
                       M02 C(1) NOT NULL, ;
                       M03 C(1) NOT NULL, ;
                       M04 C(1) NOT NULL, ;
                       M05 C(1) NOT NULL, ;
                       M06 C(1) NOT NULL, ;
                       M07 C(1) NOT NULL, ;
                       M08 C(1) NOT NULL, ;
                       M09 C(1) NOT NULL, ;
                       M10 C(1) NOT NULL, ;
                       M11 C(1) NOT NULL, ;
                       M12 C(1) NOT NULL, ;
                       CODNEW C(13) NOT NULL)

***** Create each index for CMPPACIN *****
INDEX ON PERIODO+CODMAT+NIVEL TAG PACI01 COLLATE 'MACHINE'
INDEX ON CODMAT TAG PACI02 COLLATE 'MACHINE'

***** Change properties for CMPPACIN *****
ENDFUNC

FUNCTION MakeTable_CMPPDIRE
***** Table setup for CMPPDIRE *****
CREATE TABLE 'CMPPDIRE.DBF' NAME 'CMPPDIRE' (CODPRV C(4) NOT NULL, ;
                       CODDIRE C(3) NOT NULL, ;
                       DESDIRE C(40) NOT NULL, ;
                       CODDIST C(3) NOT NULL, ;
                       CODPAIS C(3) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CMPPDIRE *****
INDEX ON CODPRV+CODDIRE TAG DIRE01 COLLATE 'MACHINE'

***** Change properties for CMPPDIRE *****
ENDFUNC

FUNCTION MakeTable_CMPPROV
***** Table setup for CMPPROV *****
CREATE TABLE 'CMPPROV.DBF' NAME 'CMPPROV' (CODPRV C(4) NOT NULL, ;
                      NRORUC C(11) NOT NULL, ;
                      RAZSOC C(40) NOT NULL, ;
                      REPRES C(40) NOT NULL, ;
                      ORIGEN N(1, 0) NOT NULL, ;
                      CODMON N(1, 0) NOT NULL, ;
                      CODDIRE C(3) NOT NULL, ;
                      NROTELF1 C(7) NOT NULL, ;
                      NROTELF2 C(7) NOT NULL, ;
                      NROFAX C(7) NOT NULL, ;
                      NRODNI C(11) NOT NULL, ;
                      MAXCRE N(12, 2) NOT NULL, ;
                      MAXCRED N(12, 2) NOT NULL, ;
                      FMAXCRE T NOT NULL, ;
                      SALFAC N(12, 2) NOT NULL, ;
                      SALFACD N(12, 2) NOT NULL, ;
                      SALLET N(12, 2) NOT NULL, ;
                      SALLETD N(12, 2) NOT NULL, ;
                      SALCRE N(12, 2) NOT NULL, ;
                      SALCRED N(12, 2) NOT NULL, ;
                      SALDEB N(12, 2) NOT NULL, ;
                      SALDEBD N(12, 2) NOT NULL, ;
                      FPRICOM T NOT NULL, ;
                      FULTCOM T NOT NULL, ;
                      NCOMACT N(8, 0) NOT NULL, ;
                      NCOMANT N(8, 0) NOT NULL, ;
                      FACTACT N(12, 2) NOT NULL, ;
                      FACTACTD N(12, 2) NOT NULL, ;
                      FACTANT N(12, 2) NOT NULL, ;
                      FACTANTD N(12, 2) NOT NULL, ;
                      CODUSER C(8) NOT NULL, ;
                      FCHHORA T NOT NULL)

***** Create each index for CMPPROV *****
INDEX ON CODPRV TAG PROV01 CANDIDATE COLLATE 'MACHINE'
INDEX ON NRORUC TAG PROV03 UNIQUE COLLATE 'MACHINE'
INDEX ON UPPER(RAZSOC) TAG PROV02 COLLATE 'MACHINE'

***** Change properties for CMPPROV *****
ENDFUNC

FUNCTION MakeTable_CMPTDIST
***** Table setup for CMPTDIST *****
CREATE TABLE 'CMPTDIST.DBF' NAME 'CMPTDIST' (CODMAT C(13) NOT NULL, ;
                       CODAUX C(6) NOT NULL, ;
                       NOMAUX C(30) NOT NULL, ;
                       PORDIS N(8, 2) NOT NULL, ;
                       CANCMP C(10) NOT NULL, ;
                       FMAPGO C(4) NOT NULL, ;
                       MONEDA N(1, 0) NOT NULL, ;
                       EMIO_C N(3, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       N_ENTREGA N(10, 0) NOT NULL, ;
                       TASA1 N(8, 2) NOT NULL, ;
                       TASA2 N(8, 2) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       FLETE N(12, 2) NOT NULL, ;
                       PORSEG N(12, 2) NOT NULL, ;
                       GTOADU N(12, 2) NOT NULL, ;
                       OTROS N(12, 2) NOT NULL, ;
                       CODADU C(2) NOT NULL, ;
                       CODSEG C(2) NOT NULL, ;
                       CODASG C(2) NOT NULL)

***** Create each index for CMPTDIST *****
INDEX ON CODMAT+CODAUX TAG DIST01 COLLATE 'MACHINE'
INDEX ON CODAUX+CODMAT TAG DIST02 COLLATE 'MACHINE'

***** Change properties for CMPTDIST *****
ENDFUNC

FUNCTION MakeTable_CMPTDOCM
***** Table setup for CMPTDOCM *****
CREATE TABLE 'CMPTDOCM.DBF' NAME 'CMPTDOCM' (CODDOC C(4) NOT NULL, ;
                       NRODOC N(6, 0) NOT NULL, ;
                       NROANO C(2) NOT NULL, ;
                       NRODO1 N(6, 0) NOT NULL, ;
                       MES01 N(4, 0) NOT NULL, ;
                       MES02 N(4, 0) NOT NULL, ;
                       MES03 N(4, 0) NOT NULL, ;
                       MES04 N(4, 0) NOT NULL, ;
                       MES05 N(4, 0) NOT NULL, ;
                       MES06 N(4, 0) NOT NULL, ;
                       MES07 N(4, 0) NOT NULL, ;
                       MES08 N(4, 0) NOT NULL, ;
                       MES09 N(4, 0) NOT NULL, ;
                       MES10 N(4, 0) NOT NULL, ;
                       MES11 N(4, 0) NOT NULL, ;
                       MES12 N(4, 0) NOT NULL)

***** Create each index for CMPTDOCM *****
INDEX ON CODDOC TAG DOCM01 COLLATE 'MACHINE'

***** Change properties for CMPTDOCM *****
ENDFUNC

FUNCTION MakeTable_CMPTPRMY
***** Table setup for CMPTPRMY *****
CREATE TABLE 'CMPTPRMY.DBF' NAME 'CMPTPRMY' (PERIODO C(6) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CODAUX C(6) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       PROGCMP N(14, 4) NOT NULL, ;
                       PRECMP1 N(14, 4) NOT NULL, ;
                       PRECMP2 N(14, 4) NOT NULL, ;
                       PORDIS N(14, 4) NOT NULL, ;
                       IMPCMP1 N(12, 2) NOT NULL, ;
                       IMPCMP2 N(12, 2) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       FCHPROG D NOT NULL, ;
                       TASA1 N(8, 2) NOT NULL, ;
                       TASA2 N(8, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       NROORD C(7) NOT NULL, ;
                       SITPROG C(1) NOT NULL, ;
                       FSW C(1) NOT NULL, ;
                       FMAPGO C(4) NOT NULL, ;
                       ORIGEN N(1, 0) NOT NULL, ;
                       MONORI N(1, 0) NOT NULL, ;
                       TC_OC N(10, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL)

***** Create each index for CMPTPRMY *****
INDEX ON PERIODO+CODMAT+CODAUX+NROMES TAG PRMY01 COLLATE 'MACHINE'
INDEX ON PERIODO+CODMAT+CODAUX+NROMES+SITPROG TAG PRMY02 COLLATE 'MACHINE'
INDEX ON PERIODO+CODMAT+NROMES+SITPROG TAG PRMY03 COLLATE 'MACHINE'
INDEX ON CODMAT+CODAUX TAG PRMY04 COLLATE 'MACHINE'

***** Change properties for CMPTPRMY *****
ENDFUNC

FUNCTION MakeTable_CMPTVPED
***** Table setup for CMPTVPED *****
CREATE TABLE 'CMPTVPED.DBF' NAME 'CMPTVPED' (CODMAT C(13) NOT NULL, ;
                       VOLPED N(14, 4) NOT NULL, ;
                       UNDCMP C(3) NOT NULL)

***** Create each index for CMPTVPED *****
INDEX ON CODMAT TAG VPED01 COLLATE 'MACHINE'

***** Change properties for CMPTVPED *****
ENDFUNC

FUNCTION MakeTable_CPIDFPRO
***** Table setup for CPIDFPRO *****
CREATE TABLE 'CPIDFPRO.DBF' NAME 'CPIDFPRO' (CODPRO C(13) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CANREQ N(14, 4) NOT NULL, ;
                       CANPED N(14, 4) NOT NULL, ;
                       FACAJU N(14, 6) NOT NULL, ;
                       FACEQU N(14, 6) NOT NULL, ;
                       UNDPRO C(3) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       PREUNI N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Create each index for CPIDFPRO *****
INDEX ON CODMAT TAG DFPR03 COLLATE 'MACHINE'
INDEX ON CODPRO+SUBALM+CODMAT TAG DFPR01 COLLATE 'MACHINE'
INDEX ON CODPRO+CODMAT+SUBALM TAG DFPR02 COLLATE 'MACHINE'

***** Change properties for CPIDFPRO *****
ENDFUNC

FUNCTION MakeTable_CPIACXPR
***** Table setup for CPIACXPR *****
CREATE TABLE 'CPIACXPR.DBF' NAME 'CPIACXPR' (CODFASE C(3) NOT NULL, ;
                       CODPROCS C(3) NOT NULL, ;
                       CODACTIV C(3) NOT NULL, ;
                       ORDEN N(3, 0) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CPIACXPR *****
INDEX ON CODFASE+CODPROCS+CODACTIV TAG ACXPR01 COLLATE 'MACHINE'

***** Change properties for CPIACXPR *****
ENDFUNC

FUNCTION MakeTable_CPICCPPT
***** Table setup for CPICCPPT *****
CREATE TABLE 'CPICCPPT.DBF' NAME 'CPICCPPT' (NROITM N(4, 0) NOT NULL, ;
                       NIVEL C(3) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       DESVTA C(30) NOT NULL, ;
                       GLOSA C(20) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       PRODUCTO C(40) NOT NULL, ;
                       UNDVTA C(6) NOT NULL, ;
                       PRECIO_VTA N(14, 3) NOT NULL, ;
                       COSTO_UNI N(14, 4) NOT NULL, ;
                       UNI_PROD N(8, 0) NOT NULL, ;
                       MARGEN N(9, 2) NOT NULL, ;
                       UNI_VEND N(8, 0) NOT NULL, ;
                       VALOR_VTA N(10, 0) NOT NULL, ;
                       COSTO N(10, 0) NOT NULL, ;
                       VALOR_MARG N(10, 0) NOT NULL, ;
                       PORCEN N(7, 2) NOT NULL, ;
                       PORCEN_ACM N(7, 2) NOT NULL, ;
                       UNI_VENEQ N(8, 0) NOT NULL, ;
                       UNI_PRDEQ N(8, 0) NOT NULL, ;
                       COSTO_TOT N(9, 0) NOT NULL)

***** Create each index for CPICCPPT *****

***** Change properties for CPICCPPT *****
ENDFUNC

FUNCTION MakeTable_CPICFGCP
***** Table setup for CPICFGCP *****
CREATE TABLE 'CPICFGCP.DBF' NAME 'CPICFGCP' (CODIGO C(3) NOT NULL, ;
                       TIPO C(1) NOT NULL, ;
                       NOM_CMP C(10) NOT NULL, ;
                       TIP_CMP C(1) NOT NULL, ;
                       ANC_CMP N(3, 0) NOT NULL, ;
                       DEC_CMP N(2, 0) NOT NULL, ;
                       CONCEPTO C(20) NOT NULL, ;
                       PRGCAL C(10) NOT NULL, ;
                       BUSCAR_EN C(11) NOT NULL, ;
                       RUTA C(30) NOT NULL, ;
                       ORDEN C(10) NOT NULL, ;
                       ALIAS_EN C(6) NOT NULL, ;
                       CAMPO_1 C(10) NOT NULL, ;
                       E_1 C(1) NOT NULL, ;
                       IGUAL_A_1 C(20) NOT NULL, ;
                       CAMPO_2 C(10) NOT NULL, ;
                       E_2 C(10) NOT NULL, ;
                       IGUAL_A_2 C(20) NOT NULL, ;
                       CONDICION C(40) NOT NULL, ;
                       VALOR C(50) NOT NULL, ;
                       DETALLE C(11) NOT NULL, ;
                       RUTA_DET C(20) NOT NULL, ;
                       ALIAS_DET C(6) NOT NULL, ;
                       ORDEN_DET C(10) NOT NULL, ;
                       TOT_COL N(12, 2) NOT NULL, ;
                       EVALUA C(20) NOT NULL)

***** Create each index for CPICFGCP *****
INDEX ON CODIGO TAG CFGC01 COLLATE 'MACHINE'

***** Change properties for CPICFGCP *****
ENDFUNC

FUNCTION MakeTable_CPICFPRO
***** Table setup for CPICFPRO *****
CREATE TABLE 'CPICFPRO.DBF' NAME 'CPICFPRO' (CODPRO C(8) NOT NULL, ;
                       CANOBJ N(14, 4) NOT NULL, ;
                       PESO N(14, 4) NOT NULL, ;
                       UDPESO C(3) NOT NULL, ;
                       MODELO L NOT NULL, ;
                       FCHCMB D NOT NULL, ;
                       UNIREA F(14, 4) NOT NULL, ;
                       CODNEW C(8) NOT NULL)

***** Create each index for CPICFPRO *****
INDEX ON CODPRO TAG CFPR01 COLLATE 'MACHINE'

***** Change properties for CPICFPRO *****
ENDFUNC

FUNCTION MakeTable_CPICGCPT
***** Table setup for CPICGCPT *****
CREATE TABLE 'CPICGCPT.DBF' NAME 'CPICGCPT' (PERIODO C(6) NOT NULL, ;
                       TABLA C(3) NOT NULL, ;
                       CODIGO C(8) NOT NULL, ;
                       TIPO C(6) NOT NULL, ;
                       NOMBRE C(40) NOT NULL, ;
                       GLOSA C(10) NOT NULL, ;
                       BUS_EN C(8) NOT NULL, ;
                       SUBRAY C(6) NOT NULL, ;
                       ESPACIO N(3, 0) NOT NULL, ;
                       NUMCOL N(3, 0) NOT NULL, ;
                       ESPCOL N(3, 0) NOT NULL, ;
                       V01 N(14, 4) NOT NULL, ;
                       V02 N(14, 4) NOT NULL, ;
                       V03 N(14, 4) NOT NULL, ;
                       V04 N(14, 4) NOT NULL, ;
                       V05 N(14, 4) NOT NULL, ;
                       V06 N(14, 4) NOT NULL, ;
                       V07 N(14, 4) NOT NULL, ;
                       V08 N(14, 4) NOT NULL, ;
                       V09 N(14, 4) NOT NULL, ;
                       V10 N(14, 4) NOT NULL, ;
                       V11 N(14, 4) NOT NULL, ;
                       V12 N(14, 4) NOT NULL, ;
                       V13 N(14, 4) NOT NULL, ;
                       V14 N(14, 4) NOT NULL, ;
                       V15 N(14, 4) NOT NULL, ;
                       V16 N(14, 4) NOT NULL, ;
                       V17 N(14, 4) NOT NULL, ;
                       V18 N(14, 4) NOT NULL, ;
                       V19 N(14, 4) NOT NULL, ;
                       V20 N(14, 4) NOT NULL, ;
                       V21 N(14, 4) NOT NULL, ;
                       V22 N(14, 4) NOT NULL, ;
                       V23 N(14, 4) NOT NULL, ;
                       V24 N(14, 4) NOT NULL, ;
                       V25 N(14, 4) NOT NULL, ;
                       V26 N(14, 4) NOT NULL, ;
                       V27 N(14, 4) NOT NULL, ;
                       V28 N(14, 4) NOT NULL, ;
                       V29 N(14, 4) NOT NULL, ;
                       V30 N(14, 4) NOT NULL, ;
                       V31 N(14, 4) NOT NULL, ;
                       V32 N(14, 4) NOT NULL, ;
                       V33 N(14, 4) NOT NULL, ;
                       V34 N(14, 4) NOT NULL, ;
                       V35 N(14, 4) NOT NULL, ;
                       V36 N(14, 4) NOT NULL, ;
                       V37 N(14, 4) NOT NULL, ;
                       V38 N(14, 4) NOT NULL, ;
                       V39 N(14, 4) NOT NULL, ;
                       V40 N(14, 4) NOT NULL, ;
                       V41 N(14, 4) NOT NULL, ;
                       V42 N(14, 4) NOT NULL, ;
                       V43 N(14, 4) NOT NULL, ;
                       V44 N(14, 4) NOT NULL, ;
                       V45 N(14, 4) NOT NULL, ;
                       V46 N(14, 4) NOT NULL, ;
                       V47 N(14, 4) NOT NULL, ;
                       V48 N(14, 4) NOT NULL, ;
                       V49 N(14, 4) NOT NULL, ;
                       V50 N(14, 4) NOT NULL, ;
                       V51 N(14, 4) NOT NULL, ;
                       TOTAL N(14, 4) NOT NULL)

***** Create each index for CPICGCPT *****

***** Change properties for CPICGCPT *****
ENDFUNC

FUNCTION MakeTable_CPICONFG
***** Table setup for CPICONFG *****
CREATE TABLE 'CPICONFG.DBF' NAME 'CPICONFG' (CODCFG C(2) NOT NULL, ;
                       ALMING C(3) NOT NULL, ;
                       ALMSAL C(3) NOT NULL, ;
                       ALMDEV C(3) NOT NULL, ;
                       MOVING C(3) NOT NULL, ;
                       MOVDEV C(3) NOT NULL, ;
                       MOVSAL C(3) NOT NULL, ;
                       PWD1 C(10) NOT NULL, ;
                       PWD2 C(10) NOT NULL, ;
                       PWDMASTER C(10) NOT NULL)

***** Create each index for CPICONFG *****

***** Change properties for CPICONFG *****
ENDFUNC

FUNCTION MakeTable_CPICOSTO
***** Table setup for CPICOSTO *****
CREATE TABLE 'CPICOSTO.DBF' NAME 'CPICOSTO' (ANOCON N(4, 0) NOT NULL, ;
                       MESCON C(2) NOT NULL, ;
                       CODPRD C(13) NOT NULL, ;
                       CANPRD N(14, 4) NOT NULL, ;
                       TPOGTO C(2) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CANDES N(14, 4) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       NROPAR C(6) NOT NULL, ;
                       IMPNAC N(14, 2) NOT NULL, ;
                       IMPUSA N(14, 2) NOT NULL)

***** Create each index for CPICOSTO *****

***** Change properties for CPICOSTO *****
ENDFUNC

FUNCTION MakeTable_CPICPROG
***** Table setup for CPICPROG *****
CREATE TABLE 'CPICPROG.DBF' NAME 'CPICPROG' (PERIODO C(6) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       CANOBJ N(14, 4) NOT NULL, ;
                       BATOBJ N(14, 4) NOT NULL, ;
                       FCHCMB D NOT NULL, ;
                       CODNEW C(13) NOT NULL)

***** Create each index for CPICPROG *****
INDEX ON PERIODO+CODPRO TAG CPRG01 COLLATE 'MACHINE'
INDEX ON CODPRO+PERIODO TAG CPRG02 COLLATE 'MACHINE'

***** Change properties for CPICPROG *****
ENDFUNC

FUNCTION MakeTable_CPICRPRG
***** Table setup for CPICRPRG *****
CREATE TABLE 'CPICRPRG.DBF' NAME 'CPICRPRG' (PERIODO C(6) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       SUM_CANPRG N(16, 4) NOT NULL, ;
                       SUM_CSMMES N(16, 4) NOT NULL)

***** Create each index for CPICRPRG *****

***** Change properties for CPICRPRG *****
ENDFUNC

FUNCTION MakeTable_CPICSTPT
***** Table setup for CPICSTPT *****
CREATE TABLE 'CPICSTPT.DBF' NAME 'CPICSTPT' (PERIODO C(6) NOT NULL, ;
                       CODPRD C(13) NOT NULL, ;
                       CODEQU C(13) NOT NULL, ;
                       CODREF C(8) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       VALO_T N(14, 4) NOT NULL, ;
                       VALADI N(14, 4) NOT NULL, ;
                       VALREA N(14, 4) NOT NULL, ;
                       VALFOR N(14, 4) NOT NULL, ;
                       VMERMA N(14, 4) NOT NULL, ;
                       PORMER N(14, 4) NOT NULL, ;
                       CANOBJ N(14, 4) NOT NULL, ;
                       CANFIN N(14, 4) NOT NULL, ;
                       CANOEQ N(14, 4) NOT NULL, ;
                       CANFEQ N(14, 4) NOT NULL, ;
                       BATPRO N(14, 4) NOT NULL, ;
                       UNIREA N(14, 4) NOT NULL, ;
                       UNIFOR N(14, 4) NOT NULL, ;
                       UNIMER N(14, 4) NOT NULL, ;
                       UNIREAEQ N(14, 4) NOT NULL, ;
                       UNIFOREQ N(14, 4) NOT NULL, ;
                       UNIMEREQ N(14, 4) NOT NULL)

***** Create each index for CPICSTPT *****

***** Change properties for CPICSTPT *****
ENDFUNC

FUNCTION MakeTable_CPICTOPP
***** Table setup for CPICTOPP *****
CREATE TABLE 'CPICTOPP.DBF' NAME 'CPICTOPP' (CODIGO C(3) NOT NULL, ;
                       CONCEPTO C(20) NOT NULL, ;
                       PRGCAL C(10) NOT NULL, ;
                       BUSCAR_EN C(11) NOT NULL, ;
                       RUTA C(30) NOT NULL, ;
                       ORDEN C(10) NOT NULL, ;
                       ALIAS_EN C(6) NOT NULL, ;
                       CAMPO_1 C(10) NOT NULL, ;
                       E_1 C(1) NOT NULL, ;
                       IGUAL_A_1 C(20) NOT NULL, ;
                       CAMPO_2 C(10) NOT NULL, ;
                       E_2 C(10) NOT NULL, ;
                       IGUAL_A_2 C(20) NOT NULL, ;
                       CONDICION C(40) NOT NULL, ;
                       VALOR C(50) NOT NULL, ;
                       DETALLE C(11) NOT NULL, ;
                       RUTA_DET C(20) NOT NULL, ;
                       ALIAS_DET C(6) NOT NULL, ;
                       ORDEN_DET C(10) NOT NULL, ;
                       VALOR_DET C(20) NOT NULL)

***** Create each index for CPICTOPP *****

***** Change properties for CPICTOPP *****
ENDFUNC

FUNCTION MakeTable_CPICXLGRAL
***** Table setup for CPICXLGRAL *****
CREATE TABLE 'CPICXLGRAL.DBF' NAME 'CPICXLGRAL' (PERIODO C(8) NOT NULL, ;
                         TPODIV C(2) NOT NULL, ;
                         CODMAT C(13) NOT NULL, ;
                         CANXREC N(14, 4) NOT NULL, ;
                         CTOXREC N(14, 4) NOT NULL, ;
                         TOTXREC N(14, 4) NOT NULL, ;
                         CODPAR C(8) NOT NULL, ;
                         H01 N(6, 2) NOT NULL, ;
                         C01 N(14, 4) NOT NULL, ;
                         H02 N(6, 2) NOT NULL, ;
                         C02 N(14, 4) NOT NULL, ;
                         H03 N(6, 2) NOT NULL, ;
                         C03 N(14, 4) NOT NULL, ;
                         H04 N(6, 2) NOT NULL, ;
                         C04 N(14, 4) NOT NULL, ;
                         H05 N(6, 2) NOT NULL, ;
                         C05 N(14, 4) NOT NULL, ;
                         H06 N(6, 2) NOT NULL, ;
                         C06 N(14, 4) NOT NULL, ;
                         H07 N(6, 2) NOT NULL, ;
                         C07 N(14, 4) NOT NULL, ;
                         H08 N(5, 2) NOT NULL, ;
                         C08 N(14, 4) NOT NULL, ;
                         H09 N(6, 2) NOT NULL, ;
                         C09 N(14, 4) NOT NULL, ;
                         H10 N(6, 2) NOT NULL, ;
                         C10 N(14, 4) NOT NULL, ;
                         H11 N(6, 2) NOT NULL, ;
                         C11 N(14, 4) NOT NULL, ;
                         H12 N(6, 2) NOT NULL, ;
                         C12 N(14, 4) NOT NULL, ;
                         H13 N(6, 2) NOT NULL, ;
                         C13 N(14, 4) NOT NULL, ;
                         H14 N(6, 2) NOT NULL, ;
                         C14 N(14, 4) NOT NULL, ;
                         H15 N(6, 2) NOT NULL, ;
                         C15 N(14, 4) NOT NULL, ;
                         H16 N(6, 2) NOT NULL, ;
                         C16 N(14, 4) NOT NULL, ;
                         H17 N(6, 2) NOT NULL, ;
                         C17 N(14, 4) NOT NULL, ;
                         H18 N(6, 2) NOT NULL, ;
                         C18 N(14, 4) NOT NULL, ;
                         H19 N(6, 2) NOT NULL, ;
                         C19 N(14, 4) NOT NULL, ;
                         H20 N(6, 2) NOT NULL, ;
                         C20 N(14, 4) NOT NULL, ;
                         TOTHORAS N(6, 2) NOT NULL, ;
                         TOTCOSTO N(14, 4) NOT NULL)

***** Create each index for CPICXLGRAL *****
INDEX ON PERIODO+CODPAR TAG CXLT02 COLLATE 'MACHINE'
INDEX ON PERIODO+CODMAT+CODPAR TAG CXLT01 COLLATE 'MACHINE'
INDEX ON PERIODO+CODPAR+TPODIV+CODMAT TAG CXLT03 COLLATE 'MACHINE'

***** Change properties for CPICXLGRAL *****
ENDFUNC

FUNCTION MakeTable_CPICXLM_O
***** Table setup for CPICXLM_O *****
CREATE TABLE 'CPICXLM_O.DBF' NAME 'CPICXLM_O' (PERIODO C(8) NOT NULL, ;
                        TPODIV C(2) NOT NULL, ;
                        CODPERS C(6) NOT NULL, ;
                        CODACTIV C(3) NOT NULL, ;
                        CTOXPERS N(14, 4) NOT NULL, ;
                        H01 N(6, 2) NOT NULL, ;
                        C01 N(14, 4) NOT NULL, ;
                        H02 N(6, 2) NOT NULL, ;
                        C02 N(14, 4) NOT NULL, ;
                        H03 N(6, 2) NOT NULL, ;
                        C03 N(14, 4) NOT NULL, ;
                        H04 N(6, 2) NOT NULL, ;
                        C04 N(14, 4) NOT NULL, ;
                        H05 N(6, 2) NOT NULL, ;
                        C05 N(14, 4) NOT NULL, ;
                        H06 N(6, 2) NOT NULL, ;
                        C06 N(14, 4) NOT NULL, ;
                        H07 N(6, 2) NOT NULL, ;
                        C07 N(14, 4) NOT NULL, ;
                        H08 N(5, 2) NOT NULL, ;
                        C08 N(14, 4) NOT NULL, ;
                        H09 N(6, 2) NOT NULL, ;
                        C09 N(14, 4) NOT NULL, ;
                        H10 N(6, 2) NOT NULL, ;
                        C10 N(14, 4) NOT NULL, ;
                        H11 N(6, 2) NOT NULL, ;
                        C11 N(14, 4) NOT NULL, ;
                        H12 N(6, 2) NOT NULL, ;
                        C12 N(14, 4) NOT NULL, ;
                        H13 N(6, 2) NOT NULL, ;
                        C13 N(14, 4) NOT NULL, ;
                        H14 N(6, 2) NOT NULL, ;
                        C14 N(14, 4) NOT NULL, ;
                        H15 N(6, 2) NOT NULL, ;
                        C15 N(14, 4) NOT NULL, ;
                        H16 N(6, 2) NOT NULL, ;
                        C16 N(14, 4) NOT NULL, ;
                        H17 N(6, 2) NOT NULL, ;
                        C17 N(14, 4) NOT NULL, ;
                        H18 N(6, 2) NOT NULL, ;
                        C18 N(14, 4) NOT NULL, ;
                        H19 N(6, 2) NOT NULL, ;
                        C19 N(14, 4) NOT NULL, ;
                        H20 N(6, 2) NOT NULL, ;
                        C20 N(14, 4) NOT NULL, ;
                        TOTHORAS N(6, 2) NOT NULL, ;
                        TOTCOSTO N(14, 4) NOT NULL)

***** Create each index for CPICXLM_O *****
INDEX ON PERIODO+CODPERS TAG CXLT01 COLLATE 'MACHINE'
INDEX ON PERIODO+TPODIV+CODPERS TAG CXLT02 COLLATE 'MACHINE'

***** Change properties for CPICXLM_O *****
ENDFUNC

FUNCTION MakeTable_CPIACTIV
***** Table setup for CPIACTIV *****
CREATE TABLE 'CPIACTIV.DBF' NAME 'CPIACTIV' (CODACTIV C(3) NOT NULL, ;
                       DESACTIV C(30) NOT NULL, ;
                       CODGRAL C(3) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CPIACTIV *****
INDEX ON UPPER(DESACTIV) TAG ACTI02 COLLATE 'MACHINE'
INDEX ON CODACTIV TAG ACTI01 CANDIDATE COLLATE 'MACHINE'

***** Change properties for CPIACTIV *****
ENDFUNC

FUNCTION MakeTable_CPIDPROG
***** Table setup for CPIDPROG *****
CREATE TABLE 'CPIDPROG.DBF' NAME 'CPIDPROG' (PERIODO C(6) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       CANPRG N(14, 4) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       CANREQ N(14, 4) NOT NULL, ;
                       CSMMES N(14, 4) NOT NULL, ;
                       CODNEW C(13) NOT NULL, ;
                       CODNEW1 C(13) NOT NULL)

***** Create each index for CPIDPROG *****

***** Change properties for CPIDPROG *****
ENDFUNC

FUNCTION MakeTable_CPIEMDPT
***** Table setup for CPIEMDPT *****
CREATE TABLE 'CPIEMDPT.DBF' NAME 'CPIEMDPT' (TIPO C(5) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       CODPRO C(8) NOT NULL, ;
                       DESCRIP C(30) NOT NULL, ;
                       VAUTOSER N(7, 0) NOT NULL, ;
                       VHELADO N(7, 0) NOT NULL, ;
                       VBODEGA N(7, 0) NOT NULL, ;
                       VDISTRIB N(7, 0) NOT NULL, ;
                       VMAYORIS N(7, 0) NOT NULL, ;
                       VCANJE N(7, 0) NOT NULL, ;
                       VESPECIAL N(7, 0) NOT NULL, ;
                       VTOTLIMA N(8, 0) NOT NULL, ;
                       VPROVIN N(7, 0) NOT NULL, ;
                       VTOTGEN N(8, 0) NOT NULL, ;
                       XAUTOSER N(7, 0) NOT NULL, ;
                       XHELADO N(7, 0) NOT NULL, ;
                       XBODEGA N(7, 0) NOT NULL, ;
                       XDISTRIB N(7, 0) NOT NULL, ;
                       XMAYORIS N(7, 0) NOT NULL, ;
                       XOTROS N(7, 0) NOT NULL, ;
                       XTOTLIMA N(8, 0) NOT NULL, ;
                       XPROVINC N(8, 0) NOT NULL, ;
                       XTOTGEN N(8, 0) NOT NULL, ;
                       YAUTOSER N(7, 0) NOT NULL, ;
                       YHELADO N(7, 0) NOT NULL, ;
                       YBODEGA N(7, 0) NOT NULL, ;
                       YDISTRIB N(7, 0) NOT NULL, ;
                       YMAYORIS N(7, 0) NOT NULL, ;
                       YOTROS N(7, 0) NOT NULL, ;
                       YTOTLIMA N(9, 0) NOT NULL, ;
                       YPROVINC N(9, 0) NOT NULL, ;
                       YTOTGEN N(9, 0) NOT NULL, ;
                       CODEQU C(8) NOT NULL)

***** Create each index for CPIEMDPT *****

***** Change properties for CPIEMDPT *****
ENDFUNC

FUNCTION MakeTable_CPIEMVPT
***** Table setup for CPIEMVPT *****
CREATE TABLE 'CPIEMVPT.DBF' NAME 'CPIEMVPT' (PERIODO C(6) NOT NULL, ;
                       CODPRO C(8) NOT NULL, ;
                       DESCRIP C(30) NOT NULL, ;
                       UAUTOSER N(7, 0) NOT NULL, ;
                       UHELADO N(7, 0) NOT NULL, ;
                       UBODEGA N(7, 0) NOT NULL, ;
                       UDISTRIB N(7, 0) NOT NULL, ;
                       UMAYORIS N(7, 0) NOT NULL, ;
                       UCANJPUB N(7, 0) NOT NULL, ;
                       UESPECIA N(7, 0) NOT NULL, ;
                       UTOTLIMA N(8, 0) NOT NULL, ;
                       UPROVINC N(8, 0) NOT NULL, ;
                       UTOTGEN N(8, 0) NOT NULL, ;
                       CUOTA N(8, 0) NOT NULL, ;
                       PORCEN N(3, 0) NOT NULL, ;
                       VAUTOSER N(7, 0) NOT NULL, ;
                       VHELADO N(7, 0) NOT NULL, ;
                       VBODEGA N(7, 0) NOT NULL, ;
                       VDISTRIB N(7, 0) NOT NULL, ;
                       VMAYORIS N(7, 0) NOT NULL, ;
                       VCANJPUB N(7, 0) NOT NULL, ;
                       VESPECIA N(7, 0) NOT NULL, ;
                       VTOTLIMA N(9, 0) NOT NULL, ;
                       VPROVINC N(9, 0) NOT NULL, ;
                       VTOTGEN N(9, 0) NOT NULL, ;
                       CODEQU C(8) NOT NULL)

***** Create each index for CPIEMVPT *****

***** Change properties for CPIEMVPT *****
ENDFUNC

FUNCTION MakeTable_CPIFASES
***** Table setup for CPIFASES *****
CREATE TABLE 'CPIFASES.DBF' NAME 'CPIFASES' (CODFASE C(3) NOT NULL, ;
                       DESFASE C(30) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CPIFASES *****
INDEX ON CODFASE TAG FASE01 COLLATE 'MACHINE'
INDEX ON UPPER(DESFASE) TAG FASE02 COLLATE 'MACHINE'

***** Change properties for CPIFASES *****
ENDFUNC

FUNCTION MakeTable_CPIICMDF
***** Table setup for CPIICMDF *****
CREATE TABLE 'CPIICMDF.DBF' NAME 'CPIICMDF' (NIVEL C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       DESMAT C(30) NOT NULL, ;
                       C01 N(14, 2) NOT NULL, ;
                       C02 N(14, 2) NOT NULL, ;
                       C03 N(14, 2) NOT NULL, ;
                       C04 N(14, 2) NOT NULL, ;
                       C05 N(14, 2) NOT NULL, ;
                       C06 N(14, 2) NOT NULL, ;
                       C07 N(14, 2) NOT NULL, ;
                       C08 N(14, 2) NOT NULL, ;
                       C09 N(14, 2) NOT NULL, ;
                       C10 N(14, 2) NOT NULL, ;
                       C11 N(14, 2) NOT NULL, ;
                       C12 N(14, 2) NOT NULL, ;
                       C13 N(14, 2) NOT NULL, ;
                       C14 N(14, 2) NOT NULL, ;
                       C15 N(14, 2) NOT NULL, ;
                       V01 N(14, 2) NOT NULL, ;
                       V02 N(14, 2) NOT NULL, ;
                       V03 N(14, 2) NOT NULL, ;
                       V04 N(14, 2) NOT NULL, ;
                       V05 N(14, 2) NOT NULL, ;
                       V06 N(14, 2) NOT NULL, ;
                       V07 N(14, 2) NOT NULL, ;
                       V08 N(14, 2) NOT NULL, ;
                       V09 N(14, 2) NOT NULL, ;
                       V10 N(14, 2) NOT NULL, ;
                       V11 N(14, 2) NOT NULL, ;
                       V12 N(14, 2) NOT NULL, ;
                       V13 N(14, 2) NOT NULL, ;
                       V14 N(14, 2) NOT NULL, ;
                       V15 N(14, 2) NOT NULL, ;
                       TOTCOM N(14, 2) NOT NULL, ;
                       TOTVAL N(14, 2) NOT NULL, ;
                       B01 N(14, 2) NOT NULL, ;
                       B02 N(14, 2) NOT NULL, ;
                       B03 N(14, 2) NOT NULL, ;
                       B04 N(14, 2) NOT NULL, ;
                       B05 N(14, 2) NOT NULL, ;
                       B06 N(14, 2) NOT NULL, ;
                       B07 N(14, 2) NOT NULL, ;
                       B08 N(14, 2) NOT NULL, ;
                       B09 N(14, 2) NOT NULL, ;
                       B10 N(14, 2) NOT NULL, ;
                       B11 N(14, 2) NOT NULL, ;
                       B12 N(14, 2) NOT NULL, ;
                       B13 N(14, 2) NOT NULL, ;
                       B14 N(14, 2) NOT NULL, ;
                       B15 N(14, 2) NOT NULL)

***** Create each index for CPIICMDF *****

***** Change properties for CPIICMDF *****
ENDFUNC

FUNCTION MakeTable_CPIICPPT
***** Table setup for CPIICPPT *****
CREATE TABLE 'CPIICPPT.DBF' NAME 'CPIICPPT' (NIVEL C(3) NOT NULL, ;
                       PTOVTA C(8) NOT NULL, ;
                       DESVTA C(30) NOT NULL, ;
                       GLOSA C(20) NOT NULL, ;
                       VA01 N(9, 4) NOT NULL, ;
                       VB01 N(9, 4) NOT NULL, ;
                       VC01 N(9, 4) NOT NULL, ;
                       VD01 N(14, 3) NOT NULL, ;
                       VE01 N(14, 3) NOT NULL, ;
                       VF01 N(14, 3) NOT NULL, ;
                       VA02 N(9, 4) NOT NULL, ;
                       VB02 N(9, 4) NOT NULL, ;
                       VC02 N(9, 4) NOT NULL, ;
                       VD02 N(14, 3) NOT NULL, ;
                       VE02 N(14, 3) NOT NULL, ;
                       VF02 N(14, 3) NOT NULL, ;
                       VA03 N(9, 4) NOT NULL, ;
                       VB03 N(9, 4) NOT NULL, ;
                       VC03 N(9, 4) NOT NULL, ;
                       VD03 N(14, 3) NOT NULL, ;
                       VE03 N(14, 3) NOT NULL, ;
                       VF03 N(14, 3) NOT NULL, ;
                       VA04 N(9, 4) NOT NULL, ;
                       VB04 N(9, 4) NOT NULL, ;
                       VC04 N(9, 4) NOT NULL, ;
                       VD04 N(14, 3) NOT NULL, ;
                       VE04 N(14, 3) NOT NULL, ;
                       VF04 N(14, 3) NOT NULL, ;
                       VA05 N(9, 4) NOT NULL, ;
                       VB05 N(9, 4) NOT NULL, ;
                       VC05 N(9, 4) NOT NULL, ;
                       VD05 N(14, 3) NOT NULL, ;
                       VE05 N(14, 3) NOT NULL, ;
                       VF05 N(14, 3) NOT NULL, ;
                       VA06 N(9, 4) NOT NULL, ;
                       VB06 N(9, 4) NOT NULL, ;
                       VC06 N(9, 4) NOT NULL, ;
                       VD06 N(14, 3) NOT NULL, ;
                       VE06 N(14, 3) NOT NULL, ;
                       VF06 N(14, 3) NOT NULL, ;
                       VA07 N(9, 4) NOT NULL, ;
                       VB07 N(9, 4) NOT NULL, ;
                       VC07 N(9, 4) NOT NULL, ;
                       VD07 N(14, 3) NOT NULL, ;
                       VE07 N(14, 3) NOT NULL, ;
                       VF07 N(14, 3) NOT NULL, ;
                       VA08 N(9, 4) NOT NULL, ;
                       VB08 N(9, 4) NOT NULL, ;
                       VC08 N(9, 4) NOT NULL, ;
                       VD08 N(14, 3) NOT NULL, ;
                       VE08 N(14, 3) NOT NULL, ;
                       VF08 N(14, 3) NOT NULL, ;
                       VA09 N(9, 4) NOT NULL, ;
                       VB09 N(9, 4) NOT NULL, ;
                       VC09 N(9, 4) NOT NULL, ;
                       VD09 N(14, 3) NOT NULL, ;
                       VE09 N(14, 3) NOT NULL, ;
                       VF09 N(14, 3) NOT NULL, ;
                       VA10 N(9, 4) NOT NULL, ;
                       VB10 N(9, 4) NOT NULL, ;
                       VC10 N(9, 4) NOT NULL, ;
                       VD10 N(14, 3) NOT NULL, ;
                       VE10 N(14, 3) NOT NULL, ;
                       VF10 N(14, 3) NOT NULL, ;
                       VA11 N(9, 4) NOT NULL, ;
                       VB11 N(9, 4) NOT NULL, ;
                       VC11 N(9, 4) NOT NULL, ;
                       VD11 N(14, 3) NOT NULL, ;
                       VE11 N(14, 3) NOT NULL, ;
                       VF11 N(14, 3) NOT NULL, ;
                       VA12 N(9, 4) NOT NULL, ;
                       VB12 N(9, 4) NOT NULL, ;
                       VC12 N(9, 4) NOT NULL, ;
                       VD12 N(14, 3) NOT NULL, ;
                       VE12 N(14, 3) NOT NULL, ;
                       VF12 N(14, 3) NOT NULL, ;
                       VA13 N(9, 4) NOT NULL, ;
                       VB13 N(9, 4) NOT NULL, ;
                       VC13 N(9, 4) NOT NULL, ;
                       VD13 N(14, 3) NOT NULL, ;
                       VE13 N(14, 3) NOT NULL, ;
                       VF13 N(14, 3) NOT NULL, ;
                       VA14 N(9, 4) NOT NULL, ;
                       VB14 N(9, 4) NOT NULL, ;
                       VC14 N(9, 4) NOT NULL, ;
                       VD14 N(14, 3) NOT NULL, ;
                       VE14 N(14, 3) NOT NULL, ;
                       VF14 N(14, 3) NOT NULL, ;
                       VA15 N(9, 4) NOT NULL, ;
                       VB15 N(9, 4) NOT NULL, ;
                       VC15 N(9, 4) NOT NULL, ;
                       VD15 N(14, 3) NOT NULL, ;
                       VE15 N(14, 3) NOT NULL, ;
                       VF15 N(14, 3) NOT NULL, ;
                       VA16 N(9, 4) NOT NULL, ;
                       VB16 N(9, 4) NOT NULL, ;
                       VC16 N(9, 4) NOT NULL, ;
                       VD16 N(14, 3) NOT NULL, ;
                       VE16 N(14, 3) NOT NULL, ;
                       VF16 N(14, 3) NOT NULL, ;
                       VA17 N(9, 4) NOT NULL, ;
                       VB17 N(9, 4) NOT NULL, ;
                       VC17 N(9, 4) NOT NULL, ;
                       VD17 N(14, 3) NOT NULL, ;
                       VE17 N(14, 3) NOT NULL, ;
                       VF17 N(14, 3) NOT NULL, ;
                       VA18 N(9, 4) NOT NULL, ;
                       VB18 N(9, 4) NOT NULL, ;
                       VC18 N(9, 4) NOT NULL, ;
                       VD18 N(14, 3) NOT NULL, ;
                       VE18 N(14, 3) NOT NULL, ;
                       VF18 N(14, 3) NOT NULL, ;
                       VA19 N(9, 4) NOT NULL, ;
                       VB19 N(9, 4) NOT NULL, ;
                       VC19 N(9, 4) NOT NULL, ;
                       VD19 N(14, 3) NOT NULL, ;
                       VE19 N(14, 3) NOT NULL, ;
                       VF19 N(14, 3) NOT NULL, ;
                       VA20 N(9, 4) NOT NULL, ;
                       VB20 N(9, 4) NOT NULL, ;
                       VC20 N(9, 4) NOT NULL, ;
                       VD20 N(14, 3) NOT NULL, ;
                       VE20 N(14, 3) NOT NULL, ;
                       VF20 N(14, 3) NOT NULL, ;
                       VA21 N(9, 4) NOT NULL, ;
                       VB21 N(9, 4) NOT NULL, ;
                       VC21 N(9, 4) NOT NULL, ;
                       VD21 N(14, 3) NOT NULL, ;
                       VE21 N(14, 3) NOT NULL, ;
                       VF21 N(14, 3) NOT NULL)

***** Create each index for CPIICPPT *****

***** Change properties for CPIICPPT *****
ENDFUNC

FUNCTION MakeTable_CPIIECMP
***** Table setup for CPIIECMP *****
CREATE TABLE 'CPIIECMP.DBF' NAME 'CPIIECMP' (NIVEL C(6) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       DESMAT C(30) NOT NULL, ;
                       CP01 N(14, 2) NOT NULL, ;
                       CP02 N(14, 2) NOT NULL, ;
                       CP03 N(14, 2) NOT NULL, ;
                       CP04 N(14, 2) NOT NULL, ;
                       CP05 N(14, 2) NOT NULL, ;
                       CP06 N(14, 2) NOT NULL, ;
                       CP07 N(14, 2) NOT NULL, ;
                       CP08 N(14, 2) NOT NULL, ;
                       CP09 N(14, 2) NOT NULL, ;
                       CP10 N(14, 2) NOT NULL, ;
                       CP11 N(14, 2) NOT NULL, ;
                       CP12 N(14, 2) NOT NULL, ;
                       CP13 N(14, 2) NOT NULL, ;
                       CP14 N(14, 2) NOT NULL, ;
                       CP15 N(14, 2) NOT NULL, ;
                       VC01 N(14, 2) NOT NULL, ;
                       VC02 N(14, 2) NOT NULL, ;
                       VC03 N(14, 2) NOT NULL, ;
                       VC04 N(14, 2) NOT NULL, ;
                       VC05 N(14, 2) NOT NULL, ;
                       VC06 N(14, 2) NOT NULL, ;
                       VC07 N(14, 2) NOT NULL, ;
                       VC08 N(14, 2) NOT NULL, ;
                       VC09 N(14, 2) NOT NULL, ;
                       VC10 N(14, 2) NOT NULL, ;
                       VC11 N(14, 2) NOT NULL, ;
                       VC12 N(14, 2) NOT NULL, ;
                       VC13 N(14, 2) NOT NULL, ;
                       VC14 N(14, 2) NOT NULL, ;
                       VC15 N(14, 2) NOT NULL, ;
                       CF01 N(14, 2) NOT NULL, ;
                       CF02 N(14, 2) NOT NULL, ;
                       CF03 N(14, 2) NOT NULL, ;
                       CF04 N(14, 2) NOT NULL, ;
                       CF05 N(14, 2) NOT NULL, ;
                       CF06 N(14, 2) NOT NULL, ;
                       CF07 N(14, 2) NOT NULL, ;
                       CF08 N(14, 2) NOT NULL, ;
                       CF09 N(14, 2) NOT NULL, ;
                       CF10 N(14, 2) NOT NULL, ;
                       CF11 N(14, 2) NOT NULL, ;
                       CF12 N(14, 2) NOT NULL, ;
                       CF13 N(14, 2) NOT NULL, ;
                       CF14 N(14, 2) NOT NULL, ;
                       CF15 N(14, 2) NOT NULL, ;
                       EF01 N(14, 2) NOT NULL, ;
                       EF02 N(14, 2) NOT NULL, ;
                       EF03 N(14, 2) NOT NULL, ;
                       EF04 N(14, 2) NOT NULL, ;
                       EF05 N(14, 2) NOT NULL, ;
                       EF06 N(14, 2) NOT NULL, ;
                       EF07 N(14, 2) NOT NULL, ;
                       EF08 N(14, 2) NOT NULL, ;
                       EF09 N(14, 2) NOT NULL, ;
                       EF10 N(14, 2) NOT NULL, ;
                       EF11 N(14, 2) NOT NULL, ;
                       EF12 N(14, 2) NOT NULL, ;
                       EF13 N(14, 2) NOT NULL, ;
                       EF14 N(14, 2) NOT NULL, ;
                       EF15 N(14, 2) NOT NULL, ;
                       TOTCOMR N(14, 2) NOT NULL, ;
                       TOTCOMF N(14, 2) NOT NULL, ;
                       TOTEFECTO N(14, 2) NOT NULL, ;
                       CPR01 N(14, 2) NOT NULL, ;
                       CPR02 N(14, 2) NOT NULL, ;
                       CPR03 N(14, 2) NOT NULL, ;
                       CPR04 N(14, 2) NOT NULL, ;
                       CPR05 N(14, 2) NOT NULL, ;
                       CPR06 N(14, 2) NOT NULL, ;
                       CPR07 N(14, 2) NOT NULL, ;
                       CPR08 N(14, 2) NOT NULL, ;
                       CPR09 N(14, 2) NOT NULL, ;
                       CPR10 N(14, 2) NOT NULL, ;
                       CPR11 N(14, 2) NOT NULL, ;
                       CPR12 N(14, 2) NOT NULL, ;
                       CPR13 N(14, 2) NOT NULL, ;
                       CPR14 N(14, 2) NOT NULL, ;
                       CPR15 N(14, 2) NOT NULL, ;
                       CFR01 N(14, 2) NOT NULL, ;
                       CFR02 N(14, 2) NOT NULL, ;
                       CFR03 N(14, 2) NOT NULL, ;
                       CFR04 N(14, 2) NOT NULL, ;
                       CFR05 N(14, 2) NOT NULL, ;
                       CFR06 N(14, 2) NOT NULL, ;
                       CFR07 N(14, 2) NOT NULL, ;
                       CFR08 N(14, 2) NOT NULL, ;
                       CFR09 N(14, 2) NOT NULL, ;
                       CFR10 N(14, 2) NOT NULL, ;
                       CFR11 N(14, 2) NOT NULL, ;
                       CFR12 N(14, 2) NOT NULL, ;
                       CFR13 N(14, 2) NOT NULL, ;
                       CFR14 N(14, 2) NOT NULL, ;
                       CFR15 N(14, 2) NOT NULL, ;
                       CVR01 N(14, 2) NOT NULL, ;
                       CVR02 N(14, 2) NOT NULL, ;
                       CVR03 N(14, 2) NOT NULL, ;
                       CVR04 N(14, 2) NOT NULL, ;
                       CVR05 N(14, 2) NOT NULL, ;
                       CVR06 N(14, 2) NOT NULL, ;
                       CVR07 N(14, 2) NOT NULL, ;
                       CVR08 N(14, 2) NOT NULL, ;
                       CVR09 N(14, 2) NOT NULL, ;
                       CVR10 N(14, 2) NOT NULL, ;
                       CVR11 N(14, 2) NOT NULL, ;
                       CVR12 N(14, 2) NOT NULL, ;
                       CVR13 N(14, 2) NOT NULL, ;
                       CVR14 N(14, 2) NOT NULL, ;
                       CVR15 N(14, 2) NOT NULL, ;
                       VP01 N(14, 2) NOT NULL, ;
                       VP02 N(14, 2) NOT NULL, ;
                       VP03 N(14, 2) NOT NULL, ;
                       VP04 N(14, 2) NOT NULL, ;
                       VP05 N(14, 2) NOT NULL, ;
                       VP06 N(14, 2) NOT NULL, ;
                       VP07 N(14, 2) NOT NULL, ;
                       VP08 N(14, 2) NOT NULL, ;
                       VP09 N(14, 2) NOT NULL, ;
                       VP10 N(14, 2) NOT NULL, ;
                       VP11 N(14, 2) NOT NULL, ;
                       VP12 N(14, 2) NOT NULL, ;
                       VP13 N(14, 2) NOT NULL, ;
                       VP14 N(14, 2) NOT NULL, ;
                       VP15 N(14, 2) NOT NULL)

***** Create each index for CPIIECMP *****

***** Change properties for CPIIECMP *****
ENDFUNC

FUNCTION MakeTable_CPIIPRGM
***** Table setup for CPIIPRGM *****
CREATE TABLE 'CPIIPRGM.DBF' NAME 'CPIIPRGM' (NIVEL C(3) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       DESMAT C(30) NOT NULL, ;
                       CP01 N(14, 2) NOT NULL, ;
                       CP02 N(14, 2) NOT NULL, ;
                       CP03 N(14, 2) NOT NULL, ;
                       CP04 N(14, 2) NOT NULL, ;
                       CP05 N(14, 2) NOT NULL, ;
                       CP06 N(14, 2) NOT NULL, ;
                       CP07 N(14, 2) NOT NULL, ;
                       CP08 N(14, 2) NOT NULL, ;
                       CP09 N(14, 2) NOT NULL, ;
                       CP10 N(14, 2) NOT NULL, ;
                       CP11 N(14, 2) NOT NULL, ;
                       CP12 N(14, 2) NOT NULL, ;
                       CP13 N(14, 2) NOT NULL, ;
                       CP14 N(14, 2) NOT NULL, ;
                       CP15 N(14, 2) NOT NULL, ;
                       PM01 N(14, 2) NOT NULL, ;
                       PM02 N(14, 2) NOT NULL, ;
                       PM03 N(14, 2) NOT NULL, ;
                       PM04 N(14, 2) NOT NULL, ;
                       PM05 N(14, 2) NOT NULL, ;
                       PM06 N(14, 2) NOT NULL, ;
                       PM07 N(14, 2) NOT NULL, ;
                       PM08 N(14, 2) NOT NULL, ;
                       PM09 N(14, 2) NOT NULL, ;
                       PM10 N(14, 2) NOT NULL, ;
                       PM11 N(14, 2) NOT NULL, ;
                       PM12 N(14, 2) NOT NULL, ;
                       PM13 N(14, 2) NOT NULL, ;
                       PM14 N(14, 2) NOT NULL, ;
                       PM15 N(14, 2) NOT NULL, ;
                       PR01 N(14, 2) NOT NULL, ;
                       PR02 N(14, 2) NOT NULL, ;
                       PR03 N(14, 2) NOT NULL, ;
                       PR04 N(14, 2) NOT NULL, ;
                       PR05 N(14, 2) NOT NULL, ;
                       PR06 N(14, 2) NOT NULL, ;
                       PR07 N(14, 2) NOT NULL, ;
                       PR08 N(14, 2) NOT NULL, ;
                       PR09 N(14, 2) NOT NULL, ;
                       PR10 N(14, 2) NOT NULL, ;
                       PR11 N(14, 2) NOT NULL, ;
                       PR12 N(14, 2) NOT NULL, ;
                       PR13 N(14, 2) NOT NULL, ;
                       PR14 N(14, 2) NOT NULL, ;
                       PR15 N(14, 2) NOT NULL, ;
                       VS01 N(14, 2) NOT NULL, ;
                       VS02 N(14, 2) NOT NULL, ;
                       VS03 N(14, 2) NOT NULL, ;
                       VS04 N(14, 2) NOT NULL, ;
                       VS05 N(14, 2) NOT NULL, ;
                       VS06 N(14, 2) NOT NULL, ;
                       VS07 N(14, 2) NOT NULL, ;
                       VS08 N(14, 2) NOT NULL, ;
                       VS09 N(14, 2) NOT NULL, ;
                       VS10 N(14, 2) NOT NULL, ;
                       VS11 N(14, 2) NOT NULL, ;
                       VS12 N(14, 2) NOT NULL, ;
                       VS13 N(14, 2) NOT NULL, ;
                       VS14 N(14, 2) NOT NULL, ;
                       VS15 N(14, 2) NOT NULL, ;
                       VD01 N(14, 2) NOT NULL, ;
                       VD02 N(14, 2) NOT NULL, ;
                       VD03 N(14, 2) NOT NULL, ;
                       VD04 N(14, 2) NOT NULL, ;
                       VD05 N(14, 2) NOT NULL, ;
                       VD06 N(14, 2) NOT NULL, ;
                       VD07 N(14, 2) NOT NULL, ;
                       VD08 N(14, 2) NOT NULL, ;
                       VD09 N(14, 2) NOT NULL, ;
                       VD10 N(14, 2) NOT NULL, ;
                       VD11 N(14, 2) NOT NULL, ;
                       VD12 N(14, 2) NOT NULL, ;
                       VD13 N(14, 2) NOT NULL, ;
                       VD14 N(14, 2) NOT NULL, ;
                       VD15 N(14, 2) NOT NULL, ;
                       ER01 N(14, 2) NOT NULL, ;
                       ER02 N(14, 2) NOT NULL, ;
                       ER03 N(14, 2) NOT NULL, ;
                       ER04 N(14, 2) NOT NULL, ;
                       ER05 N(14, 2) NOT NULL, ;
                       ER06 N(14, 2) NOT NULL, ;
                       ER07 N(14, 2) NOT NULL, ;
                       ER08 N(14, 2) NOT NULL, ;
                       ER09 N(14, 2) NOT NULL, ;
                       ER10 N(14, 2) NOT NULL, ;
                       ER11 N(14, 2) NOT NULL, ;
                       ER12 N(14, 2) NOT NULL, ;
                       ER13 N(14, 2) NOT NULL, ;
                       ER14 N(14, 2) NOT NULL, ;
                       ER15 N(14, 2) NOT NULL, ;
                       PMO01 N(14, 2) NOT NULL, ;
                       PMO02 N(14, 2) NOT NULL, ;
                       PMO03 N(14, 2) NOT NULL, ;
                       PMO04 N(14, 2) NOT NULL, ;
                       PMO05 N(14, 2) NOT NULL, ;
                       PMO06 N(14, 2) NOT NULL, ;
                       PMO07 N(14, 2) NOT NULL, ;
                       PMO08 N(14, 2) NOT NULL, ;
                       PMO09 N(14, 2) NOT NULL, ;
                       PMO10 N(14, 2) NOT NULL, ;
                       PMO11 N(14, 2) NOT NULL, ;
                       PMO12 N(14, 2) NOT NULL, ;
                       PMO13 N(14, 2) NOT NULL, ;
                       PMO14 N(14, 2) NOT NULL, ;
                       PMO15 N(14, 2) NOT NULL, ;
                       PRO01 N(14, 2) NOT NULL, ;
                       PRO02 N(14, 2) NOT NULL, ;
                       PRO03 N(14, 2) NOT NULL, ;
                       PRO04 N(14, 2) NOT NULL, ;
                       PRO05 N(14, 2) NOT NULL, ;
                       PRO06 N(14, 2) NOT NULL, ;
                       PRO07 N(14, 2) NOT NULL, ;
                       PRO08 N(14, 2) NOT NULL, ;
                       PRO09 N(14, 2) NOT NULL, ;
                       PRO10 N(14, 2) NOT NULL, ;
                       PRO11 N(14, 2) NOT NULL, ;
                       PRO12 N(14, 2) NOT NULL, ;
                       PRO13 N(14, 2) NOT NULL, ;
                       PRO14 N(14, 2) NOT NULL, ;
                       PRO15 N(14, 2) NOT NULL, ;
                       TOTVS N(14, 2) NOT NULL, ;
                       TOTVD N(14, 2) NOT NULL, ;
                       TOTCP N(14, 2) NOT NULL)

***** Create each index for CPIIPRGM *****

***** Change properties for CPIIPRGM *****
ENDFUNC

FUNCTION MakeTable_CPIIPUXP
***** Table setup for CPIIPUXP *****
CREATE TABLE 'CPIIPUXP.DBF' NAME 'CPIIPUXP' (CODPRD C(13) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       PREA01 N(14, 4) NOT NULL, ;
                       PFOR01 N(14, 4) NOT NULL, ;
                       PREAE01 N(14, 4) NOT NULL, ;
                       PFORE01 N(14, 4) NOT NULL, ;
                       PREA02 N(14, 4) NOT NULL, ;
                       PFOR02 N(14, 4) NOT NULL, ;
                       PREAE02 N(14, 4) NOT NULL, ;
                       PFORE02 N(14, 4) NOT NULL, ;
                       PREA03 N(14, 4) NOT NULL, ;
                       PFOR03 N(14, 4) NOT NULL, ;
                       PREAE03 N(14, 4) NOT NULL, ;
                       PFORE03 N(14, 4) NOT NULL, ;
                       PREA04 N(14, 4) NOT NULL, ;
                       PFOR04 N(14, 4) NOT NULL, ;
                       PREAE04 N(14, 4) NOT NULL, ;
                       PFORE04 N(14, 4) NOT NULL, ;
                       PREA05 N(14, 4) NOT NULL, ;
                       PFOR05 N(14, 4) NOT NULL, ;
                       PREAE05 N(14, 4) NOT NULL, ;
                       PFORE05 N(14, 4) NOT NULL, ;
                       PREA06 N(14, 4) NOT NULL, ;
                       PFOR06 N(14, 4) NOT NULL, ;
                       PREAE06 N(14, 4) NOT NULL, ;
                       PFORE06 N(14, 4) NOT NULL, ;
                       PREA07 N(14, 4) NOT NULL, ;
                       PFOR07 N(14, 4) NOT NULL, ;
                       PREAE07 N(14, 4) NOT NULL, ;
                       PFORE07 N(14, 4) NOT NULL, ;
                       PREA08 N(14, 4) NOT NULL, ;
                       PFOR08 N(14, 4) NOT NULL, ;
                       PREAE08 N(14, 4) NOT NULL, ;
                       PFORE08 N(14, 4) NOT NULL, ;
                       PREA09 N(14, 4) NOT NULL, ;
                       PFOR09 N(14, 4) NOT NULL, ;
                       PREAE09 N(14, 4) NOT NULL, ;
                       PFORE09 N(14, 4) NOT NULL, ;
                       PREA10 N(14, 4) NOT NULL, ;
                       PFOR10 N(14, 4) NOT NULL, ;
                       PREAE10 N(14, 4) NOT NULL, ;
                       PFORE10 N(14, 4) NOT NULL, ;
                       PREA11 N(14, 4) NOT NULL, ;
                       PFOR11 N(14, 4) NOT NULL, ;
                       PREAE11 N(14, 4) NOT NULL, ;
                       PFORE11 N(14, 4) NOT NULL, ;
                       PREA12 N(14, 4) NOT NULL, ;
                       PFOR12 N(14, 4) NOT NULL, ;
                       PREAE12 N(14, 4) NOT NULL, ;
                       PFORE12 N(14, 4) NOT NULL)

***** Create each index for CPIIPUXP *****

***** Change properties for CPIIPUXP *****
ENDFUNC

FUNCTION MakeTable_CPIIVCSD
***** Table setup for CPIIVCSD *****
CREATE TABLE 'CPIIVCSD.DBF' NAME 'CPIIVCSD' (CODPRD C(13) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       PR01S F(14, 4) NOT NULL, ;
                       PF01S F(14, 4) NOT NULL, ;
                       PRE01S F(14, 4) NOT NULL, ;
                       PFE01S F(14, 4) NOT NULL, ;
                       PR02S F(14, 4) NOT NULL, ;
                       PF02S F(14, 4) NOT NULL, ;
                       PRE02S F(14, 4) NOT NULL, ;
                       PFE02S F(14, 4) NOT NULL, ;
                       PR03S F(14, 4) NOT NULL, ;
                       PF03S F(14, 4) NOT NULL, ;
                       PRE03S F(14, 4) NOT NULL, ;
                       PFE03S F(14, 4) NOT NULL, ;
                       PR04S F(14, 4) NOT NULL, ;
                       PF04S F(14, 4) NOT NULL, ;
                       PRE04S F(14, 4) NOT NULL, ;
                       PFE04S F(14, 4) NOT NULL, ;
                       PR05S F(14, 4) NOT NULL, ;
                       PF05S F(14, 4) NOT NULL, ;
                       PRE05S F(14, 4) NOT NULL, ;
                       PFE05S F(14, 4) NOT NULL, ;
                       PR06S F(14, 4) NOT NULL, ;
                       PF06S F(14, 4) NOT NULL, ;
                       PRE06S F(14, 4) NOT NULL, ;
                       PFE06S F(14, 4) NOT NULL, ;
                       PR07S F(14, 4) NOT NULL, ;
                       PF07S F(14, 4) NOT NULL, ;
                       PRE07S F(14, 4) NOT NULL, ;
                       PFE07S F(14, 4) NOT NULL, ;
                       PR08S F(14, 4) NOT NULL, ;
                       PF08S F(14, 4) NOT NULL, ;
                       PRE08S F(14, 4) NOT NULL, ;
                       PFE08S F(14, 4) NOT NULL, ;
                       PR09S F(14, 4) NOT NULL, ;
                       PF09S F(14, 4) NOT NULL, ;
                       PRE09S F(14, 4) NOT NULL, ;
                       PFE09S F(14, 4) NOT NULL, ;
                       PR10S F(14, 4) NOT NULL, ;
                       PF10S F(14, 4) NOT NULL, ;
                       PRE10S F(14, 4) NOT NULL, ;
                       PFE10S F(14, 4) NOT NULL, ;
                       PR11S F(14, 4) NOT NULL, ;
                       PF11S F(14, 4) NOT NULL, ;
                       PRE11S F(14, 4) NOT NULL, ;
                       PFE11S F(14, 4) NOT NULL, ;
                       PR12S F(14, 4) NOT NULL, ;
                       PF12S F(14, 4) NOT NULL, ;
                       PRE12S F(14, 4) NOT NULL, ;
                       PFE12S F(14, 4) NOT NULL, ;
                       PR01D F(14, 4) NOT NULL, ;
                       PF01D F(14, 4) NOT NULL, ;
                       PRE01D F(14, 4) NOT NULL, ;
                       PFE01D F(14, 4) NOT NULL, ;
                       PR02D F(14, 4) NOT NULL, ;
                       PF02D F(14, 4) NOT NULL, ;
                       PRE02D F(14, 4) NOT NULL, ;
                       PFE02D F(14, 4) NOT NULL, ;
                       PR03D F(14, 4) NOT NULL, ;
                       PF03D F(14, 4) NOT NULL, ;
                       PRE03D F(14, 4) NOT NULL, ;
                       PFE03D F(14, 4) NOT NULL, ;
                       PR04D F(14, 4) NOT NULL, ;
                       PF04D F(14, 4) NOT NULL, ;
                       PRE04D F(14, 4) NOT NULL, ;
                       PFE04D F(14, 4) NOT NULL, ;
                       PR05D F(14, 4) NOT NULL, ;
                       PF05D F(14, 4) NOT NULL, ;
                       PRE05D F(14, 4) NOT NULL, ;
                       PFE05D F(14, 4) NOT NULL, ;
                       PR06D F(14, 4) NOT NULL, ;
                       PF06D F(14, 4) NOT NULL, ;
                       PRE06D F(14, 4) NOT NULL, ;
                       PFE06D F(14, 4) NOT NULL, ;
                       PR07D F(14, 4) NOT NULL, ;
                       PF07D F(14, 4) NOT NULL, ;
                       PRE07D F(14, 4) NOT NULL, ;
                       PFE07D F(14, 4) NOT NULL, ;
                       PR08D F(14, 4) NOT NULL, ;
                       PF08D F(14, 4) NOT NULL, ;
                       PRE08D F(14, 4) NOT NULL, ;
                       PFE08D F(14, 4) NOT NULL, ;
                       PR09D F(14, 4) NOT NULL, ;
                       PF09D F(14, 4) NOT NULL, ;
                       PRE09D F(14, 4) NOT NULL, ;
                       PFE09D F(14, 4) NOT NULL, ;
                       PR10D F(14, 4) NOT NULL, ;
                       PF10D F(14, 4) NOT NULL, ;
                       PRE10D F(14, 4) NOT NULL, ;
                       PFE10D F(14, 4) NOT NULL, ;
                       PR11D F(14, 4) NOT NULL, ;
                       PF11D F(14, 4) NOT NULL, ;
                       PRE11D F(14, 4) NOT NULL, ;
                       PFE11D F(14, 4) NOT NULL, ;
                       PR12D F(14, 4) NOT NULL, ;
                       PF12D F(14, 4) NOT NULL, ;
                       PRE12D F(14, 4) NOT NULL, ;
                       PFE12D F(14, 4) NOT NULL)

***** Create each index for CPIIVCSD *****

***** Change properties for CPIIVCSD *****
ENDFUNC

FUNCTION MakeTable_CPIIVPUF
***** Table setup for CPIIVPUF *****
CREATE TABLE 'CPIIVPUF.DBF' NAME 'CPIIVPUF' (CODPRD C(13) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       UNDSTK C(3) NOT NULL, ;
                       PREA01 N(14, 4) NOT NULL, ;
                       PFOR01 N(14, 4) NOT NULL, ;
                       PREAE01 N(14, 4) NOT NULL, ;
                       PFORE01 N(14, 4) NOT NULL, ;
                       PREA02 N(14, 4) NOT NULL, ;
                       PFOR02 N(14, 4) NOT NULL, ;
                       PREAE02 N(14, 4) NOT NULL, ;
                       PFORE02 N(14, 4) NOT NULL, ;
                       PREA03 N(14, 4) NOT NULL, ;
                       PFOR03 N(14, 4) NOT NULL, ;
                       PREAE03 N(14, 4) NOT NULL, ;
                       PFORE03 N(14, 4) NOT NULL, ;
                       PREA04 N(14, 4) NOT NULL, ;
                       PFOR04 N(14, 4) NOT NULL, ;
                       PREAE04 N(14, 4) NOT NULL, ;
                       PFORE04 N(14, 4) NOT NULL, ;
                       PREA05 N(14, 4) NOT NULL, ;
                       PFOR05 N(14, 4) NOT NULL, ;
                       PREAE05 N(14, 4) NOT NULL, ;
                       PFORE05 N(14, 4) NOT NULL, ;
                       PREA06 N(14, 4) NOT NULL, ;
                       PFOR06 N(14, 4) NOT NULL, ;
                       PREAE06 N(14, 4) NOT NULL, ;
                       PFORE06 N(14, 4) NOT NULL, ;
                       PREA07 N(14, 4) NOT NULL, ;
                       PFOR07 N(14, 4) NOT NULL, ;
                       PREAE07 N(14, 4) NOT NULL, ;
                       PFORE07 N(14, 4) NOT NULL, ;
                       PREA08 N(14, 4) NOT NULL, ;
                       PFOR08 N(14, 4) NOT NULL, ;
                       PREAE08 N(14, 4) NOT NULL, ;
                       PFORE08 N(14, 4) NOT NULL, ;
                       PREA09 N(14, 4) NOT NULL, ;
                       PFOR09 N(14, 4) NOT NULL, ;
                       PREAE09 N(14, 4) NOT NULL, ;
                       PFORE09 N(14, 4) NOT NULL, ;
                       PREA10 N(14, 4) NOT NULL, ;
                       PFOR10 N(14, 4) NOT NULL, ;
                       PREAE10 N(14, 4) NOT NULL, ;
                       PFORE10 N(14, 4) NOT NULL, ;
                       PREA11 N(14, 4) NOT NULL, ;
                       PFOR11 N(14, 4) NOT NULL, ;
                       PREAE11 N(14, 4) NOT NULL, ;
                       PFORE11 N(14, 4) NOT NULL, ;
                       PREA12 N(14, 4) NOT NULL, ;
                       PFOR12 N(14, 4) NOT NULL, ;
                       PREAE12 N(14, 4) NOT NULL, ;
                       PFORE12 N(14, 4) NOT NULL)

***** Create each index for CPIIVPUF *****

***** Change properties for CPIIVPUF *****
ENDFUNC

FUNCTION MakeTable_CPILOTES
***** Table setup for CPILOTES *****
CREATE TABLE 'CPILOTES.DBF' NAME 'CPILOTES' (CODSED C(3) NOT NULL, ;
                       CODLOTE C(3) NOT NULL, ;
                       DESLOTE C(15) NOT NULL, ;
                       AREALOTE N(10, 2) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CPILOTES *****
INDEX ON CODLOTE TAG LOTE01 CANDIDATE COLLATE 'MACHINE'
INDEX ON CODSED+CODLOTE TAG LOTE02 CANDIDATE COLLATE 'MACHINE'
INDEX ON CODSED+UPPER(DESLOTE) TAG LOTE03 COLLATE 'MACHINE'

***** Change properties for CPILOTES *****
ENDFUNC

FUNCTION MakeTable_CPIPROCS
***** Table setup for CPIPROCS *****
CREATE TABLE 'CPIPROCS.DBF' NAME 'CPIPROCS' (CODPROCS C(3) NOT NULL, ;
                       DESPROCS C(35) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for CPIPROCS *****
INDEX ON CODPROCS TAG PROC01 CANDIDATE COLLATE 'MACHINE'
INDEX ON UPPER(DESPROCS) TAG PROC02 COLLATE 'MACHINE'

***** Change properties for CPIPROCS *****
ENDFUNC

FUNCTION MakeTable_CPIPVXPV
***** Table setup for CPIPVXPV *****
CREATE TABLE 'CPIPVXPV.DBF' NAME 'CPIPVXPV' (PERIODO C(6) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       CODEQU C(13) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       VOLVTA N(8, 0) NOT NULL, ;
                       VALVTA1 N(8, 0) NOT NULL, ;
                       VALVTA2 N(8, 0) NOT NULL)

***** Create each index for CPIPVXPV *****

***** Change properties for CPIPVXPV *****
ENDFUNC

FUNCTION MakeTable_CPIRESP1
***** Table setup for CPIRESP1 *****
CREATE TABLE 'CPIRESP1.DBF' NAME 'CPIRESP1' (CODPRO C(8) NOT NULL, ;
                       NOMBRE C(30) NOT NULL, ;
                       UND C(3) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       N_BATCHS N(6, 0) NOT NULL, ;
                       PESO_BACTH N(7, 2) NOT NULL, ;
                       COSTO_UNI N(10, 4) NOT NULL, ;
                       UNID_PROD N(10, 0) NOT NULL, ;
                       COSTO_TOT N(14, 2) NOT NULL, ;
                       MERMA_PROD N(10, 2) NOT NULL, ;
                       MERMA_CONT N(10, 2) NOT NULL)

***** Create each index for CPIRESP1 *****

***** Change properties for CPIRESP1 *****
ENDFUNC

FUNCTION MakeTable_CPITDCTO
***** Table setup for CPITDCTO *****
CREATE TABLE 'CPITDCTO.DBF' NAME 'CPITDCTO' (PERIODO C(6) NOT NULL, ;
                       CODPRO C(13) NOT NULL, ;
                       CODEQU C(13) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       DCT_U_FAC N(8, 0) NOT NULL, ;
                       DCT_U_NC N(8, 0) NOT NULL, ;
                       DCT_V_FAC N(8, 0) NOT NULL, ;
                       DCT_V_NC N(8, 0) NOT NULL)

***** Create each index for CPITDCTO *****

***** Change properties for CPITDCTO *****
ENDFUNC

FUNCTION MakeTable_CPITPVTA
***** Table setup for CPITPVTA *****
CREATE TABLE 'CPITPVTA.DBF' NAME 'CPITPVTA' (PTOVTA C(3) NOT NULL, ;
                       DESVTA C(30) NOT NULL, ;
                       CMPVOL C(10) NOT NULL, ;
                       CMPVAL1 C(10) NOT NULL, ;
                       CMPVAL2 C(10) NOT NULL, ;
                       C_DCT_U_FA C(10) NOT NULL, ;
                       C_DCT_U_NC C(10) NOT NULL, ;
                       GRUPO C(3) NOT NULL, ;
                       DESGRU C(10) NOT NULL, ;
                       G_CMP1 C(10) NOT NULL, ;
                       G_CMP2 C(10) NOT NULL)

***** Create each index for CPITPVTA *****

***** Change properties for CPITPVTA *****
ENDFUNC

FUNCTION MakeTable_DISTRITOS
***** Table setup for DISTRITOS *****
CREATE TABLE 'DISTRITOS.DBF' NAME 'DISTRITOS' (CODDIST C(3) NOT NULL, ;
                        DESDIST C(40) NOT NULL, ;
                        CODZONA C(3) NOT NULL, ;
                        CODUSER C(8) NOT NULL, ;
                        FCHHORA C(8) NOT NULL)

***** Create each index for DISTRITOS *****
INDEX ON UPPER(DESDIST) TAG DIST02 COLLATE 'MACHINE'
INDEX ON CODZONA TAG DIST03 COLLATE 'MACHINE'
INDEX ON CODDIST TAG DIST01 CANDIDATE COLLATE 'MACHINE'

***** Change properties for DISTRITOS *****

***** Load Data 
=LoadData_DISTRITOS()

ENDFUNC

FUNCTION MakeTable_FLCANCHQ
***** Table setup for FLCANCHQ *****
CREATE TABLE 'FLCANCHQ.DBF' NAME 'FLCANCHQ' (FCHACT D NOT NULL, ;
                       USUARIO C(10) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NOMOPE C(40) NOT NULL, ;
                       NROAST C(6) NOT NULL, ;
                       NROVOU C(9) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       FCHPED D NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       GLOAST M NOT NULL, ;
                       DIGITA C(10) NOT NULL, ;
                       CHKCTA N(12, 0) NOT NULL, ;
                       DBENAC N(12, 2) NOT NULL, ;
                       HBENAC N(12, 2) NOT NULL, ;
                       DBEUSA N(12, 2) NOT NULL, ;
                       HBEUSA N(12, 2) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       CTACJA C(8) NOT NULL, ;
                       NOMCTA C(40) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NOMBCO C(40) NOT NULL, ;
                       GIRADO C(40) NOT NULL, ;
                       NROCHQ C(15) NOT NULL, ;
                       IMPCHQ N(12, 2) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       PROGRA C(5) NOT NULL, ;
                       AUXIL C(6) NOT NULL, ;
                       CODFIN C(3) NOT NULL, ;
                       FCHENT D NOT NULL, ;
                       FLGCHQ C(1) NOT NULL, ;
                       FCHPRT D NOT NULL, ;
                       FLGPRT C(1) NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL, ;
                       TPOANU C(8) NOT NULL)

***** Create each index for FLCANCHQ *****
INDEX ON DTOS(FCHACT)+USUARIO TAG ANCH01 COLLATE 'MACHINE'
INDEX ON NROMES+CODOPE+NROAST TAG ANCH02 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+CODBCO+CTACJA+NROCHQ TAG ANCH03 COLLATE 'MACHINE'

***** Change properties for FLCANCHQ *****
ENDFUNC

FUNCTION MakeTable_FLCGRCHQ
***** Table setup for FLCGRCHQ *****
CREATE TABLE 'FLCGRCHQ.DBF' NAME 'FLCGRCHQ' (FCHACT D NOT NULL, ;
                       USUARIO C(10) NOT NULL, ;
                       NROLIQ C(6) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(6) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(8) NOT NULL, ;
                       NOMAUX C(35) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       FCHPED D NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       TPODOC C(10) NOT NULL, ;
                       MONCAR C(3) NOT NULL, ;
                       TPOCAR C(20) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NOMBCO C(30) NOT NULL, ;
                       CTABCO C(8) NOT NULL, ;
                       NOMCTA C(30) NOT NULL, ;
                       NROCTA C(16) NOT NULL, ;
                       MONBCO C(3) NOT NULL, ;
                       FCHPAG D NOT NULL, ;
                       PAGOMN N(12, 2) NOT NULL, ;
                       PAGOUS N(12, 2) NOT NULL, ;
                       PAGTOT N(12, 2) NOT NULL, ;
                       CMBPAG N(8, 4) NOT NULL, ;
                       PAGOPE C(3) NOT NULL, ;
                       NOMOPE C(30) NOT NULL, ;
                       GIRADO C(40) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       GLOAST M NOT NULL, ;
                       FCHENT D NOT NULL, ;
                       PAGFLG C(1) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       NROVOU C(6) NOT NULL, ;
                       DOCCAN C(11) NOT NULL, ;
                       ORDEN N(4, 0) NOT NULL, ;
                       MARCA C(1) NOT NULL, ;
                       NROAGR C(3) NOT NULL, ;
                       DESTINO C(20) NOT NULL, ;
                       NROUNI C(15) NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL)

***** Create each index for FLCGRCHQ *****
INDEX ON DOCCAN TAG GRCH08 COLLATE 'MACHINE'
INDEX ON CODCTA+NRODOC+CODAUX TAG GRCH07 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+CODBCO+CTABCO+CLFAUX+CODAUX+NRODOC TAG GRCH02 COLLATE 'MACHINE'
INDEX ON CODBCO+CTABCO+STR(ORDEN,4) TAG GRCH04 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+CLFAUX+CODAUX+CODOPE+NRODOC TAG GRCH01 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+MARCA TAG GRCH05 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+NROAGR TAG GRCH06 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+CODBCO+CTABCO+NROCHQ+NROAGR TAG GRCH03 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ+CODBCO+CTABCO+NROAGR TAG GRCH09 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+CODBCO+CTABCO+TPODOC+NROCHQ+DOCCAN TAG GRCH10 COLLATE 'MACHINE'

***** Change properties for FLCGRCHQ *****
ENDFUNC

FUNCTION MakeTable_FLCJCNFG
***** Table setup for FLCJCNFG *****
CREATE TABLE 'FLCJCNFG.DBF' NAME 'FLCJCNFG' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       DESTT1 C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL, ;
                       V23 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       TOTAL3 C(4) NOT NULL, ;
                       TOTAL4 C(4) NOT NULL, ;
                       RUBROS C(40) NOT NULL, ;
                       LINEA C(1) NOT NULL, ;
                       NIVADI C(4) NOT NULL, ;
                       ACCION C(4) NOT NULL, ;
                       PRYNIV C(4) NOT NULL)

***** Create each index for FLCJCNFG *****
INDEX ON CODTT TAG TBTT02 COLLATE 'MACHINE'
INDEX ON NIVEL TAG TBTT03 COLLATE 'MACHINE'
INDEX ON NIVEL2 TAG TBTT04 COLLATE 'MACHINE'

***** Change properties for FLCJCNFG *****
ENDFUNC

FUNCTION MakeTable_FLCJTBBC
***** Table setup for FLCJTBBC *****
CREATE TABLE 'FLCJTBBC.DBF' NAME 'FLCJTBBC' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL, ;
                       V23 N(12, 2) NOT NULL, ;
                       V24 N(12, 2) NOT NULL, ;
                       V25 N(12, 2) NOT NULL, ;
                       V26 N(12, 2) NOT NULL, ;
                       V27 N(12, 2) NOT NULL, ;
                       V28 N(12, 2) NOT NULL, ;
                       V29 N(12, 2) NOT NULL, ;
                       V30 N(12, 2) NOT NULL, ;
                       V31 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL)

***** Create each index for FLCJTBBC *****
INDEX ON DTOS(FCHACT)+CODTT TAG TBTT02 COLLATE 'MACHINE'
INDEX ON DTOS(FCHACT)+NIVEL TAG TBTT03 COLLATE 'MACHINE'

***** Change properties for FLCJTBBC *****
ENDFUNC

FUNCTION MakeTable_FLCJTBCP
***** Table setup for FLCJTBCP *****
CREATE TABLE 'FLCJTBCP.DBF' NAME 'FLCJTBCP' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES2TT C(20) NOT NULL, ;
                       DES1TT C(30) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       FLAG1 C(1) NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL)

***** Create each index for FLCJTBCP *****

***** Change properties for FLCJTBCP *****
ENDFUNC

FUNCTION MakeTable_FLCJTBDF
***** Table setup for FLCJTBDF *****
CREATE TABLE 'FLCJTBDF.DBF' NAME 'FLCJTBDF' (FCHDF D NOT NULL, ;
                       FCHVEN D NOT NULL)

***** Create each index for FLCJTBDF *****
INDEX ON DTOS(FCHDF) TAG DIAF01 COLLATE 'MACHINE'

***** Change properties for FLCJTBDF *****
ENDFUNC

FUNCTION MakeTable_FLCJTBDU
***** Table setup for FLCJTBDU *****
CREATE TABLE 'FLCJTBDU.DBF' NAME 'FLCJTBDU' (ANO_FLCJ C(4) NOT NULL, ;
                       MM_FLCJ C(2) NOT NULL, ;
                       DDU_FLCJ C(2) NOT NULL, ;
                       NDD_FLCJ N(2, 0) NOT NULL)

***** Create each index for FLCJTBDU *****
INDEX ON ANO_FLCJ+MM_FLCJ+DDU_FLCJ TAG TBDU01 COLLATE 'MACHINE'

***** Change properties for FLCJTBDU *****
ENDFUNC

FUNCTION MakeTable_FLCJTBFP
***** Table setup for FLCJTBFP *****
CREATE TABLE 'FLCJTBFP.DBF' NAME 'FLCJTBFP' (FMAPGO C(4) NOT NULL, ;
                       DESFPAG C(70) NOT NULL, ;
                       TPODOC C(4) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       NDVCTO1 N(3, 0) NOT NULL, ;
                       DIFVCTO N(3, 0) NOT NULL, ;
                       CORFPAG1 N(3, 0) NOT NULL, ;
                       CORFPAG2 N(3, 0) NOT NULL)

***** Create each index for FLCJTBFP *****
INDEX ON STR(CODMON,1)+FMAPGO TAG FMAP01 COLLATE 'MACHINE'
INDEX ON FMAPGO TAG FMAPGO COLLATE 'MACHINE'
INDEX ON NROITM TAG NROITM COLLATE 'MACHINE'

***** Change properties for FLCJTBFP *****
ENDFUNC

FUNCTION MakeTable_FLCJTBTT
***** Table setup for FLCJTBTT *****
CREATE TABLE 'FLCJTBTT.DBF' NAME 'FLCJTBTT' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(20) NOT NULL, ;
                       CODOPEP C(25) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(54) NOT NULL, ;
                       NCTASP C(76) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL, ;
                       V23 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       REAL C(1) NOT NULL, ;
                       OBLI C(1) NOT NULL, ;
                       SELEC C(1) NOT NULL, ;
                       DOCVTO C(1) NOT NULL)

***** Create each index for FLCJTBTT *****
INDEX ON CODTT TAG TBTT02 COLLATE 'MACHINE'
INDEX ON NIVEL TAG TBTT03 COLLATE 'MACHINE'
INDEX ON NIVEL2 TAG TBTT04 COLLATE 'MACHINE'

***** Change properties for FLCJTBTT *****
ENDFUNC

FUNCTION MakeTable_FLCJTDFP
***** Table setup for FLCJTDFP *****
CREATE TABLE 'FLCJTDFP.DBF' NAME 'FLCJTDFP' (FMAPGO C(4) NOT NULL, ;
                       TPODOC C(15) NOT NULL, ;
                       PORC N(6, 2) NOT NULL, ;
                       INT N(6, 2) NOT NULL, ;
                       NDIAS N(3, 0) NOT NULL, ;
                       IMPTE N(11, 2) NOT NULL, ;
                       CDFCJA C(4) NOT NULL)

***** Create each index for FLCJTDFP *****
INDEX ON FMAPGO TAG FMAPGO COLLATE 'MACHINE'

***** Change properties for FLCJTDFP *****
ENDFUNC

FUNCTION MakeTable_FLCJTHFP
***** Table setup for FLCJTHFP *****
CREATE TABLE 'FLCJTHFP.DBF' NAME 'FLCJTHFP' (CTPODOC C(1) NOT NULL, ;
                       TPODOC C(15) NOT NULL, ;
                       CODFPAG C(4) NOT NULL, ;
                       DESFPAG C(70) NOT NULL, ;
                       CORFPAG1 N(3, 0) NOT NULL, ;
                       CORFPAG2 N(3, 0) NOT NULL)

***** Create each index for FLCJTHFP *****
INDEX ON CODFPAG TAG CODFP COLLATE 'MACHINE'

***** Change properties for FLCJTHFP *****
ENDFUNC

FUNCTION MakeTable_FLCLIQUI
***** Table setup for FLCLIQUI *****
CREATE TABLE 'FLCLIQUI.DBF' NAME 'FLCLIQUI' (FCHACT D NOT NULL, ;
                       USUARIO C(10) NOT NULL, ;
                       NROLIQ C(6) NOT NULL, ;
                       CMBDIA N(8, 4) NOT NULL, ;
                       TPOOPC C(2) NOT NULL, ;
                       TPOFCH N(1, 0) NOT NULL, ;
                       FCHINI D NOT NULL, ;
                       FCHFIN D NOT NULL, ;
                       ESTLIQ C(1) NOT NULL, ;
                       FCHDIG D NOT NULL, ;
                       HORDIG C(8) NOT NULL)

***** Create each index for FLCLIQUI *****
INDEX ON DTOS(FCHACT)+USUARIO+NROLIQ TAG LIQU01 COLLATE 'MACHINE'
INDEX ON USUARIO+DTOS(FCHACT)+NROLIQ TAG LIQU02 COLLATE 'MACHINE'

***** Change properties for FLCLIQUI *****
ENDFUNC

FUNCTION MakeTable_PAISES
***** Table setup for PAISES *****
CREATE TABLE 'PAISES.DBF' NAME 'PAISES' (CODPAIS C(3) NOT NULL, ;
                     DESPAIS C(40) NOT NULL, ;
                     CODUSER C(8) NOT NULL, ;
                     FCHHORA T NOT NULL)

***** Create each index for PAISES *****
INDEX ON UPPER(DESPAIS) TAG PAIS02 COLLATE 'MACHINE'
INDEX ON CODPAIS TAG PAIS01 CANDIDATE COLLATE 'MACHINE'

***** Change properties for PAISES *****

***** Load Data
=LoadData_PAISES()
ENDFUNC

FUNCTION MakeTable_SEDES
***** Table setup for SEDES *****
CREATE TABLE 'SEDES.DBF' NAME 'SEDES' (CODIGO C(3) NOT NULL, ;
                    NOMBRE C(20) NOT NULL, ;
                    ACTIVA C(1) NOT NULL, ;
                    LOGO M NOT NULL, ;
                    CENTRAL L NOT NULL, ;
                    TS_DEF C(1) NOT NULL, ;
                    CODUSER C(8) NOT NULL, ;
                    FCHHORA T NOT NULL)

***** Create each index for SEDES *****
INDEX ON UPPER(NOMBRE) TAG SEDE02 COLLATE 'MACHINE'
INDEX ON CODIGO TAG SEDE01 COLLATE 'MACHINE'

***** Change properties for SEDES *****

***** Load Data
=LoadData_SEDES()
ENDFUNC

FUNCTION MakeTable_FLCJANOS
***** Table setup for FLCJANOS *****
CREATE TABLE 'FLCJANOS.DBF' NAME 'FLCJANOS' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       ACCION C(3) NOT NULL, ;
                       PRYNIV C(4) NOT NULL, ;
                       NO_NIV L NOT NULL)

***** Create each index for FLCJANOS *****
INDEX ON CODTT TAG ANUA02 COLLATE 'MACHINE'
INDEX ON NIVEL TAG ANUA03 COLLATE 'MACHINE'
INDEX ON NIVEL2 TAG ANUA04 COLLATE 'MACHINE'

***** Change properties for FLCJANOS *****
ENDFUNC

FUNCTION MakeTable_FLBBSINI
***** Table setup for FLBBSINI *****
CREATE TABLE 'FLBBSINI.DBF' NAME 'FLBBSINI' (PERIODO C(6) NOT NULL, ;
                       FECPED D NOT NULL, ;
                       NROBAN C(2) NOT NULL, ;
                       SDOINI N(14, 2) NOT NULL)

***** Create each index for FLBBSINI *****

***** Change properties for FLBBSINI *****
ENDFUNC

FUNCTION MakeTable_FLCBPROY
***** Table setup for FLCBPROY *****
CREATE TABLE 'FLCBPROY.DBF' NAME 'FLCBPROY' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL)

***** Create each index for FLCBPROY *****

***** Change properties for FLCBPROY *****
ENDFUNC

FUNCTION MakeTable_FLBBDFJR
***** Table setup for FLBBDFJR *****
CREATE TABLE 'FLBBDFJR.DBF' NAME 'FLBBDFJR' (PERIODO C(6) NOT NULL, ;
                       FECPED D NOT NULL, ;
                       NROBAN C(2) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NOMAUX C(30) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       ELIITM C(1) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(8) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(8) NOT NULL, ;
                       NRORUC C(8) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(14) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(15) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       INIAUX C(20) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROVOU C(6) NOT NULL, ;
                       IMPNAC N(12, 2) NOT NULL, ;
                       IMPEXT N(12, 2) NOT NULL, ;
                       VCTORI D NOT NULL, ;
                       GLOORI C(30) NOT NULL, ;
                       IMPORI N(12, 2) NOT NULL, ;
                       FLGCTB L NOT NULL, ;
                       CODDIV C(2) NOT NULL)

***** Create each index for FLBBDFJR *****

***** Change properties for FLBBDFJR *****
ENDFUNC

FUNCTION MakeTable_FLCJANUA
***** Table setup for FLCJANUA *****
CREATE TABLE 'FLCJANUA.DBF' NAME 'FLCJANUA' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL)

***** Create each index for FLCJANUA *****
INDEX ON NIVEL2 TAG ANUA04 COLLATE 'MACHINE'
INDEX ON CODTT TAG ANUA02 COLLATE 'MACHINE'
INDEX ON NIVEL TAG ANUA03 COLLATE 'MACHINE'

***** Change properties for FLCJANUA *****
ENDFUNC

FUNCTION MakeTable_FLCJBBDU
***** Table setup for FLCJBBDU *****
CREATE TABLE 'FLCJBBDU.DBF' NAME 'FLCJBBDU' (CODCTA C(8) NOT NULL, ;
                       NOMCTA C(15) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       NROPOS C(2) NOT NULL, ;
                       SIGLA C(8) NOT NULL)

***** Create each index for FLCJBBDU *****
INDEX ON CODCTA TAG CODCTA COLLATE 'MACHINE'
INDEX ON NROPOS TAG NROPOS COLLATE 'MACHINE'

***** Change properties for FLCJBBDU *****
ENDFUNC

FUNCTION MakeTable_FLCJC_LE
***** Table setup for FLCJC_LE *****
CREATE TABLE 'FLCJC_LE.DBF' NAME 'FLCJC_LE' (PERIODO C(6) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL, ;
                       V23 N(12, 2) NOT NULL)

***** Create each index for FLCJC_LE *****
INDEX ON PERIODO+NIVEL TAG PLET01 COLLATE 'MACHINE'

***** Change properties for FLCJC_LE *****
ENDFUNC

FUNCTION MakeTable_FLCJCAMB
***** Table setup for FLCJCAMB *****
CREATE TABLE 'FLCJCAMB.DBF' NAME 'FLCJCAMB' (ANO C(4) NOT NULL, ;
                       MES C(2) NOT NULL, ;
                       VENTA N(12, 4) NOT NULL, ;
                       COMPRA N(12, 4) NOT NULL)

***** Create each index for FLCJCAMB *****
INDEX ON ANO+MES TAG TCMB01 COLLATE 'MACHINE'

***** Change properties for FLCJCAMB *****
ENDFUNC

FUNCTION MakeTable_FLCJCIER
***** Table setup for FLCJCIER *****
CREATE TABLE 'FLCJCIER.DBF' NAME 'FLCJCIER' (TIPO C(4) NOT NULL, ;
                       PERIODO C(6) NOT NULL, ;
                       CIERRE L NOT NULL)

***** Create each index for FLCJCIER *****
INDEX ON TIPO+PERIODO TAG CIER01 COLLATE 'MACHINE'

***** Change properties for FLCJCIER *****
ENDFUNC

FUNCTION MakeTable_FLCJCONC
***** Table setup for FLCJCONC *****
CREATE TABLE 'FLCJCONC.DBF' NAME 'FLCJCONC' (ANO_FLCJ C(4) NOT NULL, ;
                       MM_FLCJ C(2) NOT NULL, ;
                       DDU_FLCJ C(2) NOT NULL, ;
                       IMPI_FLCJ N(11, 2) NOT NULL, ;
                       IMPE_FLCJ N(11, 2) NOT NULL)

***** Create each index for FLCJCONC *****

***** Change properties for FLCJCONC *****
ENDFUNC

FUNCTION MakeTable_FLCJDANO
***** Table setup for FLCJDANO *****
CREATE TABLE 'FLCJDANO.DBF' NAME 'FLCJDANO' (ANO C(4) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NOMAUX C(30) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(6) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       ELIITM C(1) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(8) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(8) NOT NULL, ;
                       NRORUC C(8) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       INIAUX C(20) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROVOU C(6) NOT NULL, ;
                       IMPNAC N(12, 2) NOT NULL, ;
                       IMPEXT N(12, 2) NOT NULL, ;
                       VCTORI D NOT NULL, ;
                       GLOORI C(30) NOT NULL, ;
                       IMPORI N(12, 2) NOT NULL, ;
                       FCHVTO1 D NOT NULL)

***** Create each index for FLCJDANO *****
INDEX ON ANO+NIVEL+TPOMOV+DTOS(FCHVTO)+CODCTA+CODAUX+NRODOC TAG DFJD01 COLLATE 'MACHINE'
INDEX ON ANO+NIVEL+DTOS(FCHVTO) TAG DFJD02 COLLATE 'MACHINE'
INDEX ON NIVEL+NROMES+CODOPE+NROAST+CODCTA+CODAUX+NRODOC TAG DFJD03 COLLATE 'MACHINE'

***** Change properties for FLCJDANO *****
ENDFUNC

FUNCTION MakeTable_FLCJDFJR
***** Table setup for FLCJDFJR *****
CREATE TABLE 'FLCJDFJR.DBF' NAME 'FLCJDFJR' (PERIODO C(6) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NOMAUX C(30) NOT NULL, ;
                       CODDIV C(2) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       ELIITM C(1) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(8) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(8) NOT NULL, ;
                       NRORUC C(8) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(14) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       INIAUX C(20) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROVOU C(6) NOT NULL, ;
                       IMPNAC N(12, 2) NOT NULL, ;
                       IMPEXT N(12, 2) NOT NULL, ;
                       VCTORI D NOT NULL, ;
                       GLOORI C(30) NOT NULL, ;
                       IMPORI N(12, 2) NOT NULL, ;
                       FCHVTO1 D NOT NULL, ;
                       NROAST1 C(10) NOT NULL, ;
                       NIVADI C(4) NOT NULL, ;
                       CTABAN C(8) NOT NULL, ;
                       DESTINO C(20) NOT NULL, ;
                       NROUNI C(15) NOT NULL, ;
                       DESBCO C(3) NOT NULL)

***** Create each index for FLCJDFJR *****

***** Change properties for FLCJDFJR *****
ENDFUNC

FUNCTION MakeTable_FLCJMANO
***** Table setup for FLCJMANO *****
CREATE TABLE 'FLCJMANO.DBF' NAME 'FLCJMANO' (PERIODO C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       FCHACT D NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       TOTAL3 C(4) NOT NULL, ;
                       RUBROS C(40) NOT NULL, ;
                       LINEA C(1) NOT NULL, ;
                       NIVADI C(4) NOT NULL, ;
                       ACCION C(4) NOT NULL, ;
                       PRYNIV C(4) NOT NULL)

***** Create each index for FLCJMANO *****

***** Change properties for FLCJMANO *****
ENDFUNC

FUNCTION MakeTable_FLCJPAGO
***** Table setup for FLCJPAGO *****
CREATE TABLE 'FLCJPAGO.DBF' NAME 'FLCJPAGO' (CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL)

***** Create each index for FLCJPAGO *****
INDEX ON NIVEL TAG PAGO03 COLLATE 'MACHINE'
INDEX ON CODTT TAG PAGO02 COLLATE 'MACHINE'

***** Change properties for FLCJPAGO *****
ENDFUNC

FUNCTION MakeTable_FLCJPROY
***** Table setup for FLCJPROY *****
CREATE TABLE 'FLCJPROY.DBF' NAME 'FLCJPROY' (PERIODO C(6) NOT NULL, ;
                       CODTT C(3) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NIVEL2 C(4) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       DES1TT C(35) NOT NULL, ;
                       DESTT1 C(20) NOT NULL, ;
                       TOTAL1 C(4) NOT NULL, ;
                       TOTAL2 C(4) NOT NULL, ;
                       NO_TOT L NOT NULL, ;
                       SIGSUM C(1) NOT NULL, ;
                       CODOPE C(14) NOT NULL, ;
                       CODOPEP C(14) NOT NULL, ;
                       DEHA C(1) NOT NULL, ;
                       DEHAP C(1) NOT NULL, ;
                       NCTAS C(40) NOT NULL, ;
                       NCTASP C(40) NOT NULL, ;
                       LOGICA M NOT NULL, ;
                       LOGPRO M NOT NULL, ;
                       PROG C(12) NOT NULL, ;
                       V01 N(12, 2) NOT NULL, ;
                       V02 N(12, 2) NOT NULL, ;
                       V03 N(12, 2) NOT NULL, ;
                       V04 N(12, 2) NOT NULL, ;
                       V05 N(12, 2) NOT NULL, ;
                       V06 N(12, 2) NOT NULL, ;
                       V07 N(12, 2) NOT NULL, ;
                       V08 N(12, 2) NOT NULL, ;
                       V09 N(12, 2) NOT NULL, ;
                       V10 N(12, 2) NOT NULL, ;
                       V11 N(12, 2) NOT NULL, ;
                       V12 N(12, 2) NOT NULL, ;
                       V13 N(12, 2) NOT NULL, ;
                       V14 N(12, 2) NOT NULL, ;
                       V15 N(12, 2) NOT NULL, ;
                       V16 N(12, 2) NOT NULL, ;
                       V17 N(12, 2) NOT NULL, ;
                       V18 N(12, 2) NOT NULL, ;
                       V19 N(12, 2) NOT NULL, ;
                       V20 N(12, 2) NOT NULL, ;
                       V21 N(12, 2) NOT NULL, ;
                       V22 N(12, 2) NOT NULL, ;
                       V23 N(12, 2) NOT NULL, ;
                       TIPDOC C(2) NOT NULL, ;
                       NIVADI C(4) NOT NULL)

***** Create each index for FLCJPROY *****

***** Change properties for FLCJPROY *****
ENDFUNC

FUNCTION MakeTable_FLCJREAL
***** Table setup for FLCJREAL *****
CREATE TABLE 'FLCJREAL.DBF' NAME 'FLCJREAL' (PERIODO C(6) NOT NULL, ;
                       NIVEL C(4) NOT NULL, ;
                       NOMAUX C(30) NOT NULL, ;
                       CODDIV C(2) NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       ELIITM C(1) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(8) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(8) NOT NULL, ;
                       NRORUC C(8) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(14) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(8, 4) NOT NULL, ;
                       IMPUSA N(12, 2) NOT NULL, ;
                       CODBCO C(3) NOT NULL, ;
                       NROCHQ C(10) NOT NULL, ;
                       NROCTA C(20) NOT NULL, ;
                       TIPOC C(1) NOT NULL, ;
                       INIAUX C(20) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROVOU C(6) NOT NULL, ;
                       IMPNAC N(12, 2) NOT NULL, ;
                       IMPEXT N(12, 2) NOT NULL, ;
                       VCTORI D NOT NULL, ;
                       GLOORI C(30) NOT NULL, ;
                       IMPORI N(12, 2) NOT NULL, ;
                       FCHVTO1 D NOT NULL, ;
                       NIVADI C(4) NOT NULL)

***** Create each index for FLCJREAL *****

***** Change properties for FLCJREAL *****
ENDFUNC

FUNCTION MakeTable_FLCJSINI
***** Table setup for FLCJSINI *****
CREATE TABLE 'FLCJSINI.DBF' NAME 'FLCJSINI' (PERIODO C(6) NOT NULL, ;
                       SDOINI N(14, 2) NOT NULL)

***** Create each index for FLCJSINI *****
INDEX ON PERIODO TAG SINI01 COLLATE 'MACHINE'

***** Change properties for FLCJSINI *****
ENDFUNC

FUNCTION MakeTable_VTACRONO
***** Table setup for VTACRONO *****
CREATE TABLE 'VTACRONO.DBF' NAME 'VTACRONO' (NRODOC C(6) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       CANPED N(14, 4) NOT NULL, ;
                       CANDES N(14, 4) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       FCHENT D NOT NULL)

***** Create each index for VTACRONO *****
INDEX ON NRODOC+CODMAT TAG CRON01 COLLATE 'MACHINE'

***** Change properties for VTACRONO *****
ENDFUNC

FUNCTION MakeTable_VTAPTOVT
***** Table setup for VTAPTOVT *****
CREATE TABLE 'VTAPTOVT.DBF' NAME 'VTAPTOVT' (SEDE C(3) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       NOMBRE C(30) NOT NULL)

***** Create each index for VTAPTOVT *****
INDEX ON SEDE+PTOVTA TAG PTOVTA CANDIDATE COLLATE 'MACHINE'

***** Change properties for VTAPTOVT *****
ENDFUNC

FUNCTION MakeTable_VTARFACT
***** Table setup for VTARFACT *****
CREATE TABLE 'VTARFACT.DBF' NAME 'VTARFACT' (SUBALM C(3) NOT NULL, ;
                       TPODOC C(7) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       NROITM N(3, 0) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(10) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       CANDES N(14, 4) NOT NULL, ;
                       PREUNI N(16, 4) NOT NULL, ;
                       PREVTA N(16, 4) NOT NULL, ;
                       IMPLIN N(16, 4) NOT NULL, ;
                       PTRANS N(16, 4) NOT NULL, ;
                       IMPTRA N(16, 4) NOT NULL, ;
                       DESCTO N(6, 2) NOT NULL, ;
                       NROGUI C(6) NOT NULL, ;
                       PRECTO N(16, 4) NOT NULL, ;
                       TPOPRC N(1, 0) NOT NULL, ;
                       DESMAT C(40) NOT NULL)

***** Create each index for VTARFACT *****

***** Change properties for VTARFACT *****
ENDFUNC

FUNCTION MakeTable_VTARITEM
***** Table setup for VTARITEM *****
CREATE TABLE 'VTARITEM.DBF' NAME 'VTARITEM' (TPODOC C(5) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       NROSER C(15) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       PREUNI N(12, 3) NOT NULL, ;
                       CANFAC N(14, 4) NOT NULL, ;
                       PORDTO N(5, 2) NOT NULL, ;
                       IMPLIN N(12, 2) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FACEQU N(14, 4) NOT NULL, ;
                       D1 N(5, 2) NOT NULL, ;
                       D2 N(5, 2) NOT NULL, ;
                       D3 N(5, 2) NOT NULL, ;
                       LOTE C(15) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       NRO_REG I NOT NULL AUTOINC NEXTVALUE 576 STEP 1, ;
                       NROITM I NOT NULL, ;
                       NRO_ITM I NOT NULL)

***** Create each index for VTARITEM *****
INDEX ON CODDOC+NRODOC TAG ITEM01 COLLATE 'MACHINE'
INDEX ON CODMAT+DTOS(FCHDOC) TAG ITEM02 COLLATE 'MACHINE'

***** Change properties for VTARITEM *****
ENDFUNC

FUNCTION MakeTable_VTARPEDI
***** Table setup for VTARPEDI *****
CREATE TABLE 'VTARPEDI.DBF' NAME 'VTARPEDI' (NRODOC C(8) NOT NULL, ;
                       CODMAT C(20) NOT NULL, ;
                       UNDVTA C(3) NOT NULL, ;
                       FACEQU N(10, 4) NOT NULL, ;
                       PREUNI N(12, 3) NOT NULL, ;
                       CANPED N(14, 4) NOT NULL, ;
                       PORDTO N(5, 2) NOT NULL, ;
                       IMPLIN N(12, 2) NOT NULL, ;
                       CANDES N(14, 4) NOT NULL, ;
                       CANFAC N(14, 4) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       FLGFAC C(1) NOT NULL, ;
                       FCHENT D NOT NULL, ;
                       DESMAT C(40) NOT NULL, ;
                       D1 N(5, 2) NOT NULL, ;
                       D2 N(5, 2) NOT NULL, ;
                       D3 N(5, 2) NOT NULL, ;
                       NRO_REG I NOT NULL AUTOINC NEXTVALUE 1 STEP 1)

***** Create each index for VTARPEDI *****
INDEX ON CODMAT+DTOS(FCHENT) TAG RPED04 COLLATE 'MACHINE'
INDEX ON NRODOC TAG RPED01 COLLATE 'MACHINE'
INDEX ON NRODOC+CODMAT+DTOC(FCHENT,1) TAG RPED02 COLLATE 'MACHINE'
INDEX ON FLGEST+NRODOC+CODMAT TAG RPED03 COLLATE 'MACHINE'

***** Change properties for VTARPEDI *****
ENDFUNC

FUNCTION MakeTable_VTATDOCM
***** Table setup for VTATDOCM *****
CREATE TABLE 'VTATDOCM.DBF' NAME 'VTATDOCM' (SEDE C(3) NOT NULL, ;
                       PTOVTA C(3) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       SERIE C(3) NOT NULL, ;
                       NRODOC N(10, 0) NOT NULL, ;
                       TPODOCSN C(2) NOT NULL, ;
                       TPODOC C(5) NOT NULL, ;
                       INTEST L NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       TIPMOV C(1) NOT NULL, ;
                       CODMOV C(15) NOT NULL, ;
                       CAMPO_ID C(20) NOT NULL CHECK len_id(), ;
                       ANT_MES N(1, 0) NOT NULL, ;
                       ANT_SERIE N(1, 0) NOT NULL, ;
                       ANT_PTOVTA N(1, 0) NOT NULL, ;
                       CORR_U L NOT NULL, ;
                       VAR_SUF_ID C(10) NOT NULL, ;
                       EVAL_VALOR_PK M NOT NULL, ;
                       T_DESTINO C(30) NOT NULL, ;
                       LEN_ID N(3, 0) NOT NULL)

***** Create each index for VTATDOCM *****
INDEX ON SEDE+PTOVTA TAG DOCM02 COLLATE 'MACHINE'
ALTER TABLE 'VTATDOCM' ADD PRIMARY KEY SEDE+CODDOC+PTOVTA TAG DOCM01 COLLATE 'MACHINE'

***** Change properties for VTATDOCM *****
DBSETPROP('VTATDOCM.VAR_SUF_ID', 'Field', 'Comment', "Variable que se concatena con el campo (CAMPO_ID) para determinar de donde jalar el correlativo.")
DBSETPROP('VTATDOCM.T_DESTINO', 'Field', 'Comment', "Tabla destino")
*****  Load Data
=LoadData_VTATDOCM()

ENDFUNC

FUNCTION MakeTable_VTAVFACT
***** Table setup for VTAVFACT *****
CREATE TABLE 'VTAVFACT.DBF' NAME 'VTAVFACT' (NRODOC C(6) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(5) NOT NULL, ;
                       NROO_C C(10) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       FMASOL C(25) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       DIAVTO N(3, 0) NOT NULL, ;
                       CNDPGO C(25) NOT NULL, ;
                       CODVEN C(3) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       PORIGV N(5, 2) NOT NULL, ;
                       PORDTO N(5, 2) NOT NULL, ;
                       IMPBRT N(12, 2) NOT NULL, ;
                       IMPDTO N(12, 2) NOT NULL, ;
                       IMPINT N(12, 2) NOT NULL, ;
                       IMPADM N(12, 2) NOT NULL, ;
                       IMPIGV N(12, 2) NOT NULL, ;
                       IMPNET N(12, 2) NOT NULL, ;
                       IMPOTR N(12, 2) NOT NULL, ;
                       GLODOC M NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       NOMCLI C(40) NOT NULL, ;
                       DIRCLI C(40) NOT NULL, ;
                       RUCCLI C(10) NOT NULL)

***** Create each index for VTAVFACT *****

***** Change properties for VTAVFACT *****
ENDFUNC

FUNCTION MakeTable_VTAVGUIA
***** Table setup for VTAVGUIA *****
CREATE TABLE 'VTAVGUIA.DBF' NAME 'VTAVGUIA' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       NROPED C(6) NOT NULL, ;
                       SUBALM C(3) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       GLODOC C(35) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       NOMTRA C(40) NOT NULL, ;
                       DIRTRA C(40) NOT NULL, ;
                       RUCTRA C(8) NOT NULL, ;
                       PLATRA C(10) NOT NULL, ;
                       NOMCHO C(30) NOT NULL, ;
                       NROBRE C(15) NOT NULL, ;
                       NROO_C C(15) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       NOMCLI C(50) NOT NULL, ;
                       DIRCLI C(60) NOT NULL, ;
                       RUCCLI C(10) NOT NULL, ;
                       DIRENT C(60) NOT NULL, ;
                       CODFAC C(4) NOT NULL, ;
                       NROFAC C(10) NOT NULL, ;
                       PEDIDOS C(80) NOT NULL, ;
                       MOTIVO N(1, 0) NOT NULL, ;
                       TPOGUI C(4) NOT NULL, ;
                       CODVEN C(4) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       CNDPGO C(18) NOT NULL)

***** Create each index for VTAVGUIA *****
INDEX ON CODFAC+NROFAC TAG VGUI03 COLLATE 'MACHINE'
INDEX ON CODDOC+NRODOC TAG VGUI01 COLLATE 'MACHINE'
INDEX ON NROPED+CODDOC+FLGEST+NRODOC TAG VGUI02 COLLATE 'MACHINE'
INDEX ON CODDOC+FLGEST+NRODOC TAG VGUI05 COLLATE 'MACHINE'
INDEX ON CODDOC+DTOS(FCHDOC)+NRODOC TAG VGUI06 COLLATE 'MACHINE'
INDEX ON CODCLI+FLGEST+CODDOC+NRODOC TAG VGUI04 COLLATE 'MACHINE'

***** Change properties for VTAVGUIA *****
ENDFUNC

FUNCTION MakeTable_VTAVPEDI
***** Table setup for VTAVPEDI *****
CREATE TABLE 'VTAVPEDI.DBF' NAME 'VTAVPEDI' (TPODOC C(5) NOT NULL, ;
                       CODDOC C(4) NOT NULL, ;
                       NRODOC C(8) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       CODCLI C(11) NOT NULL, ;
                       NROO_C C(10) NOT NULL, ;
                       FCHO_C D NOT NULL, ;
                       FMASOL C(25) NOT NULL, ;
                       FMAPGO N(1, 0) NOT NULL, ;
                       DIAVTO N(3, 0) NOT NULL, ;
                       CNDPGO C(25) NOT NULL, ;
                       CODVEN C(3) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       PORIGV N(5, 2) NOT NULL, ;
                       PORDTO N(5, 2) NOT NULL, ;
                       IMPBTO N(12, 2) NOT NULL, ;
                       IMPDTO N(12, 2) NOT NULL, ;
                       IMPINT N(12, 2) NOT NULL, ;
                       IMPADM N(12, 2) NOT NULL, ;
                       IMPIGV N(12, 2) NOT NULL, ;
                       IMPNET N(12, 2) NOT NULL, ;
                       IMPFLT N(12, 2) NOT NULL, ;
                       GLODOC M NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       FLGFAC C(1) NOT NULL, ;
                       NOMCLI C(50) NOT NULL, ;
                       DIRCLI C(60) NOT NULL, ;
                       RUCCLI C(11) NOT NULL, ;
                       TPOVTA N(1, 0) NOT NULL, ;
                       TABLDEST C(2) NOT NULL, ;
                       DESTINO C(1) NOT NULL, ;
                       TABLVIA C(2) NOT NULL, ;
                       VIA C(1) NOT NULL, ;
                       TABLRUTA C(2) NOT NULL, ;
                       RUTA C(5) NOT NULL, ;
                       CODREF C(4) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FLGUBC C(1) NOT NULL, ;
                       NROPED C(8) NOT NULL)

***** Create each index for VTAVPEDI *****
INDEX ON NRODOC TAG VPED01 COLLATE 'MACHINE'
INDEX ON FLGEST+NRODOC TAG VPED03 COLLATE 'MACHINE'
INDEX ON CODCLI+FLGEST+NRODOC TAG VPED02 COLLATE 'MACHINE'

***** Change properties for VTAVPEDI *****
ENDFUNC

FUNCTION MakeTable_ZONAS
***** Table setup for ZONAS *****
CREATE TABLE 'ZONAS.DBF' NAME 'ZONAS' (CODZONA C(3) NOT NULL, ;
                    DESZONA C(40) NOT NULL, ;
                    FLAGPROV L NOT NULL, ;
                    CODUSER C(8) NOT NULL, ;
                    FCHHORA T NOT NULL)

***** Create each index for ZONAS *****
INDEX ON UPPER(DESZONA) TAG ZONA02 COLLATE 'MACHINE'
INDEX ON CODZONA TAG ZONA01 CANDIDATE COLLATE 'MACHINE'

***** Change properties for ZONAS *****

***** Load Data
=LoadData_ZONAS()

ENDFUNC

FUNCTION MakeTable_CCTCLIEN
***** Table setup for CCTCLIEN *****
CREATE TABLE 'CCTCLIEN.DBF' NAME 'CCTCLIEN' (CLFAUX C(3) NOT NULL, ;
                       CODAUX C(11) NOT NULL, ;
                       CODCLI C(4) NOT NULL, ;
                       NRORUC C(11) NOT NULL, ;
                       RAZSOC C(40) NOT NULL, ;
                       REPRES C(40) NOT NULL, ;
                       ORIGEN N(1, 0) NOT NULL, ;
                       CODDIRE C(3) NOT NULL, ;
                       NROTELF1 C(9) NOT NULL, ;
                       NROTELF2 C(9) NOT NULL, ;
                       NROFAX C(9) NOT NULL, ;
                       NRODNI C(11) NOT NULL, ;
                       MAXCRE N(12, 2) NOT NULL, ;
                       MAXCRED N(12, 2) NOT NULL, ;
                       FMAXCRE T NOT NULL, ;
                       SALFAC N(12, 2) NOT NULL, ;
                       SALFACD N(12, 2) NOT NULL, ;
                       SALLET N(12, 2) NOT NULL, ;
                       SALLETD N(12, 2) NOT NULL, ;
                       SALCRE N(12, 2) NOT NULL, ;
                       SALCRED N(12, 2) NOT NULL, ;
                       SALDEB N(12, 2) NOT NULL, ;
                       SALDEBD N(12, 2) NOT NULL, ;
                       FPRICOM T NOT NULL, ;
                       FULTCOM T NOT NULL, ;
                       NCOMACT N(8, 0) NOT NULL, ;
                       NCOMANT N(8, 0) NOT NULL, ;
                       FACTACT N(12, 2) NOT NULL, ;
                       FACTACTD N(12, 2) NOT NULL, ;
                       FACTANT N(12, 2) NOT NULL, ;
                       FACTANTD N(12, 2) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL, ;
                       FLGINF L NOT NULL, ;
                       RETE L NOT NULL, ;
                       NACCLI N(1, 0) NOT NULL)

***** Create each index for CCTCLIEN *****
INDEX ON NRORUC TAG CLIEN03 UNIQUE COLLATE 'MACHINE'
INDEX ON UPPER(RAZSOC) TAG CLIEN02 COLLATE 'MACHINE'
INDEX ON CODCLI TAG CLIEN01 COLLATE 'MACHINE'

***** Change properties for CCTCLIEN *****
ENDFUNC

FUNCTION MakeTable_CBDPPRES
***** Table setup for CBDPPRES *****
CREATE TABLE 'CBDPPRES.DBF' NAME 'CBDPPRES' (CTAPRE C(15) NOT NULL, ;
                       NOMBRE C(40) NOT NULL, ;
                       AFTMOV C(1) NOT NULL, ;
                       CTADBE1 C(8) NOT NULL, ;
                       CTAHBE1 C(8) NOT NULL, ;
                       CTADBE2 C(8) NOT NULL, ;
                       CTAHBE2 C(8) NOT NULL, ;
                       CTADBE3 C(8) NOT NULL, ;
                       CTAHBE3 C(8) NOT NULL)

***** Create each index for CBDPPRES *****
INDEX ON CTAPRE TAG PPRE01 COLLATE 'MACHINE'
INDEX ON UPPER(NOMBRE) TAG PPRE02 COLLATE 'MACHINE'

***** Change properties for CBDPPRES *****
ENDFUNC

FUNCTION MakeTable_VTAPVTCL
***** Table setup for VTAPVTCL *****
CREATE TABLE 'VTAPVTCL.DBF' NAME 'VTAPVTCL' (CODCLI C(11) NOT NULL, ;
                       CODMAT C(13) NOT NULL, ;
                       PREVE1 N(12, 3) NOT NULL, ;
                       PREVE2 N(12, 3) NOT NULL)

***** Create each index for VTAPVTCL *****

***** Change properties for VTAPVTCL *****
ENDFUNC

FUNCTION MakeTable_CBDRMDLO
***** Table setup for CBDRMDLO *****
CREATE TABLE 'CBDRMDLO.DBF' NAME 'CBDRMDLO' (CODMOD C(2) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       CHKITM N(5, 0) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       CODREF C(5) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       CODAUX C(5) NOT NULL, ;
                       CODDOC C(3) NOT NULL, ;
                       NRODOC C(10) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       GLODOC C(30) NOT NULL, ;
                       TPOMOV C(1) NOT NULL, ;
                       IMPOR1 N(6, 2) NOT NULL, ;
                       IMPOR2 N(6, 2) NOT NULL, ;
                       IMPOR3 N(6, 2) NOT NULL, ;
                       IMPOR4 N(6, 2) NOT NULL)

***** Create each index for CBDRMDLO *****
INDEX ON CODMOD+STR(NROITM,5) TAG RMDL01 COLLATE 'MACHINE'

***** Change properties for CBDRMDLO *****
ENDFUNC

FUNCTION MakeTable_CBDVMDLO
***** Table setup for CBDVMDLO *****
CREATE TABLE 'CBDVMDLO.DBF' NAME 'CBDVMDLO' (CODMOD C(2) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       NOTAST C(40) NOT NULL, ;
                       NROITM N(5, 0) NOT NULL, ;
                       GIMPO1 C(20) NOT NULL, ;
                       GIMPO2 C(20) NOT NULL, ;
                       GIMPO3 C(20) NOT NULL, ;
                       GIMPO4 C(20) NOT NULL)

***** Create each index for CBDVMDLO *****
INDEX ON CODMOD TAG VMDL01 COLLATE 'MACHINE'

***** Change properties for CBDVMDLO *****
ENDFUNC

FUNCTION MakeTable_PLNMTABL
***** Table setup for PLNMTABL *****
CREATE TABLE 'PLNMTABL.DBF' NAME 'PLNMTABL' (TABLA C(2) NOT NULL, ;
                       CODIGO C(12) NOT NULL, ;
                       NOMBRE C(60) NOT NULL, ;
                       DIGITOS N(2, 0) NOT NULL, ;
                       MARCA N(1, 0) NOT NULL, ;
                       CODNEW C(8) NOT NULL, ;
                       CODUSER C(8) NOT NULL, ;
                       FCHHORA T NOT NULL)

***** Create each index for PLNMTABL *****
INDEX ON TABLA+UPPER(NOMBRE) TAG TABL02 COLLATE 'MACHINE'
INDEX ON TABLA+CODIGO+UPPER(NOMBRE) TAG TABL01 COLLATE 'MACHINE'

***** Change properties for PLNMTABL *****

***** Load Data
=LoadData_PLNMTABL()

ENDFUNC

FUNCTION MakeTable_PLNMPCTS
***** Table setup for PLNMPCTS *****
CREATE TABLE 'PLNMPCTS.DBF' NAME 'PLNMPCTS' (FCHINI D NOT NULL, ;
                       FCHFIN D NOT NULL, ;
                       NROPER C(2) NOT NULL, ;
                       NROANO C(4) NOT NULL)

***** Create each index for PLNMPCTS *****
INDEX ON FCHINI TAG PCTS01 COLLATE 'MACHINE'

***** Change properties for PLNMPCTS *****

***** Load Data
=LoadData_PLNMPCTS()
ENDFUNC

FUNCTION MakeTable_CBDORDEN
***** Table setup for CBDORDEN *****
CREATE TABLE 'CBDORDEN.DBF' NAME 'CBDORDEN' (CODIGO C(2) NOT NULL, ;
                       ORDEN C(3) NOT NULL, ;
                       CTAPRI C(2) NOT NULL, ;
                       CUENTAS C(50) NOT NULL, ;
                       QUIEBRE C(1) NOT NULL, ;
                       CONTROL C(1) NOT NULL)

***** Create each index for CBDORDEN *****

***** Change properties for CBDORDEN *****
ENDFUNC

FUNCTION MakeTable_PLNDJTF1
***** Table setup for PLNDJTF1 *****
CREATE TABLE 'PLNDJTF1.DBF' NAME 'PLNDJTF1' (TPODOC_ASEG C(2) NOT NULL, ;
                       NRODOC_ASEG C(15) NOT NULL, ;
                       DIAS_TRAB C(2) NOT NULL, ;
                       REM_IES N(12, 2) NOT NULL, ;
                       REM_PEN N(12, 2) NOT NULL, ;
                       REM_SAL N(12, 2) NOT NULL, ;
                       REM_ART N(12, 2) NOT NULL, ;
                       REM_QUI N(12, 2) NOT NULL, ;
                       TRI_QUI N(12, 2) NOT NULL, ;
                       PEN_20530 N(12, 2) NOT NULL, ;
                       CONT_SOL N(12, 2) NOT NULL)

***** Create each index for PLNDJTF1 *****
INDEX ON TPODOC_ASEG+NRODOC_ASEG TAG DJF101 COLLATE 'MACHINE'

***** Change properties for PLNDJTF1 *****
ENDFUNC

FUNCTION MakeTable_PLNDJTF2
***** Table setup for PLNDJTF2 *****
CREATE TABLE 'PLNDJTF2.DBF' NAME 'PLNDJTF2' (TPODOC_ASEG C(2) NOT NULL, ;
                       NRODOC_ASEG C(15) NOT NULL, ;
                       RUC_CENT C(11) NOT NULL, ;
                       CORR_CENT C(3) NOT NULL, ;
                       TASA N(4, 2) NOT NULL, ;
                       REM_SCTR N(12, 2) NOT NULL)

***** Create each index for PLNDJTF2 *****
INDEX ON TPODOC_ASEG+NRODOC_ASEG TAG DJF201 COLLATE 'MACHINE'

***** Change properties for PLNDJTF2 *****
ENDFUNC

FUNCTION MakeTable_PLNBANCO
***** Table setup for PLNBANCO *****
CREATE TABLE 'PLNBANCO.DBF' NAME 'PLNBANCO' (X1 C(7) NOT NULL, ;
                       X2 C(8) NOT NULL, ;
                       X3 C(20) NOT NULL, ;
                       X4 C(20) NOT NULL, ;
                       X5 C(20) NOT NULL, ;
                       XI C(8) NOT NULL, ;
                       X6 C(12) NOT NULL, ;
                       X7 C(10) NOT NULL, ;
                       X8 C(20) NOT NULL, ;
                       X9 C(3) NOT NULL, ;
                       X10 C(2) NOT NULL, ;
                       X11 C(1) NOT NULL, ;
                       X12 C(34) NOT NULL, ;
                       X13 C(14) NOT NULL)

***** Create each index for PLNBANCO *****
INDEX ON X1 TAG BACO01 COLLATE 'MACHINE'

***** Change properties for PLNBANCO *****
ENDFUNC

FUNCTION MakeTable_PLNBANCR
***** Table setup for PLNBANCR *****
CREATE TABLE 'PLNBANCR.DBF' NAME 'PLNBANCR' (TPO_REG C(1) NOT NULL, ;
                       COD_CLI C(6) NOT NULL, ;
                       COD_SUCRAL C(3) NOT NULL, ;
                       NRO_CTA C(13) NOT NULL, ;
                       NBE_SOL C(36) NOT NULL, ;
                       COD_MONEDA C(2) NOT NULL, ;
                       IMP_CAR C(15) NOT NULL, ;
                       FCH_CR_AB C(4) NOT NULL)

***** Create each index for PLNBANCR *****
INDEX ON TPO_REG+COD_CLI TAG BACR01 COLLATE 'MACHINE'

***** Change properties for PLNBANCR *****
ENDFUNC

FUNCTION MakeTable_PLNCOOPE
***** Table setup for PLNCOOPE *****
CREATE TABLE 'PLNCOOPE.DBF' NAME 'PLNCOOPE' (CODPER1 C(6) NOT NULL, ;
                       CODPER C(6) NOT NULL, ;
                       APEPAT C(20) NOT NULL, ;
                       APEMAT C(20) NOT NULL, ;
                       NOMBRE C(20) NOT NULL, ;
                       FCHING D NOT NULL, ;
                       H1 N(8, 2) NOT NULL, ;
                       D1 N(5, 2) NOT NULL, ;
                       H2 N(6, 2) NOT NULL, ;
                       H3 N(6, 2) NOT NULL, ;
                       H4 N(6, 2) NOT NULL, ;
                       SUELDO N(10, 2) NOT NULL, ;
                       SUELDO_H N(10, 2) NOT NULL, ;
                       BONDOM N(10, 2) NOT NULL, ;
                       DOMINI N(10, 2) NOT NULL, ;
                       MOVILI N(10, 2) NOT NULL, ;
                       ASIFAM N(10, 2) NOT NULL, ;
                       COMISI N(10, 2) NOT NULL, ;
                       AFP1023 N(10, 2) NOT NULL, ;
                       AFP331 N(10, 2) NOT NULL, ;
                       SNP33 N(10, 2) NOT NULL, ;
                       OTRING N(10, 2) NOT NULL, ;
                       FERLAB N(10, 2) NOT NULL, ;
                       TOTING N(10, 2) NOT NULL, ;
                       SNP N(10, 2) NOT NULL, ;
                       AFPFON N(10, 2) NOT NULL, ;
                       AFPSI N(10, 2) NOT NULL, ;
                       AFPCF N(10, 2) NOT NULL, ;
                       AFPCP N(10, 2) NOT NULL, ;
                       QUINTA N(10, 2) NOT NULL, ;
                       QUINCE1 N(10, 2) NOT NULL, ;
                       DESTAR N(10, 2) NOT NULL, ;
                       OTRDCTO N(10, 2) NOT NULL, ;
                       IPSSVIDA N(10, 2) NOT NULL, ;
                       APOCOO N(10, 2) NOT NULL, ;
                       REFRIG N(10, 2) NOT NULL, ;
                       TOTDCTO N(10, 2) NOT NULL, ;
                       REDANT N(10, 2) NOT NULL, ;
                       REDACT N(10, 2) NOT NULL, ;
                       TOTNET N(10, 2) NOT NULL, ;
                       APOIPSS N(10, 2) NOT NULL, ;
                       APOFON N(10, 2) NOT NULL, ;
                       LUGPAG C(2) NOT NULL, ;
                       PRMHEXT N(10, 2) NOT NULL, ;
                       PRMDEST N(10, 2) NOT NULL, ;
                       JORNOCT N(10, 2) NOT NULL, ;
                       REMDEST N(10, 2) NOT NULL, ;
                       INCAFP N(10, 2) NOT NULL, ;
                       PRESTAMOS N(10, 2) NOT NULL, ;
                       DESJUD N(10, 2) NOT NULL)

***** Create each index for PLNCOOPE *****
INDEX ON CODPER TAG COP01 COLLATE 'MACHINE'

***** Change properties for PLNCOOPE *****
ENDFUNC

FUNCTION MakeTable_PLNARAFP
***** Table setup for PLNARAFP *****
CREATE TABLE 'PLNARAFP.DBF' NAME 'PLNARAFP' (A_CODAFP C(3) NOT NULL, ;
                       C_CUSPP C(12) NOT NULL, ;
                       A_APELL1 C(20) NOT NULL, ;
                       A_APELL2 C(20) NOT NULL, ;
                       A_NOMBRE1 C(10) NOT NULL, ;
                       A_NOMBRE2 C(10) NOT NULL, ;
                       M_REMASEG N(13, 2) NOT NULL, ;
                       M_APOVOL N(13, 2) NOT NULL, ;
                       A_APOVOLS N(13, 2) NOT NULL, ;
                       A_APOEMPL N(13, 2) NOT NULL)

***** Create each index for PLNARAFP *****
INDEX ON A_CODAFP+A_APELL1 TAG AAFP01 COLLATE 'MACHINE'

***** Change properties for PLNARAFP *****
ENDFUNC

FUNCTION MakeTable_CJADPROV
***** Table setup for CJADPROV *****
CREATE TABLE 'CJADPROV.DBF' NAME 'CJADPROV' (CODDOC C(4) NOT NULL, ;
                       NRODOC C(14) NOT NULL, ;
                       NROREF C(10) NOT NULL, ;
                       FCHDOC D NOT NULL, ;
                       DIAVTO N(4, 0) NOT NULL, ;
                       FCHVTO D NOT NULL, ;
                       CODAUX C(11) NOT NULL, ;
                       CLFAUX C(3) NOT NULL, ;
                       NOMAUX C(40) NOT NULL, ;
                       RUCAUX C(8) NOT NULL, ;
                       IMPBRT N(12, 2) NOT NULL, ;
                       IMPIGV N(12, 2) NOT NULL, ;
                       IMPORT N(12, 2) NOT NULL, ;
                       CODMON N(1, 0) NOT NULL, ;
                       TPOCMB N(10, 4) NOT NULL, ;
                       FCHREC D NOT NULL, ;
                       NOMREC C(15) NOT NULL, ;
                       NOMENV C(30) NOT NULL, ;
                       FLGEST C(1) NOT NULL, ;
                       SDODOC N(12, 2) NOT NULL, ;
                       OBSERV M NOT NULL, ;
                       FCHCAN D NOT NULL, ;
                       FCHPGO D NOT NULL, ;
                       NOMAPR C(30) NOT NULL, ;
                       NROO_C C(6) NOT NULL, ;
                       NROGUI C(20) NOT NULL, ;
                       NROAST C(8) NOT NULL, ;
                       IMPAPR N(12, 2) NOT NULL, ;
                       FCHAST D NOT NULL, ;
                       NROMES C(2) NOT NULL, ;
                       NROVOU C(9) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       CODCTA C(8) NOT NULL, ;
                       FCHPOL D NOT NULL, ;
                       FCHPED D NOT NULL)

***** Create each index for CJADPROV *****
INDEX ON CODAUX+CODDOC+NRODOC+RUCAUX TAG DPRO01 COLLATE 'MACHINE'
INDEX ON CODAUX+FLGEST+CODDOC+NRODOC TAG DPRO02 COLLATE 'MACHINE'
INDEX ON NROAST TAG DPRO05 COLLATE 'MACHINE'
INDEX ON NROMES+CODOPE+NRODOC TAG DPRO06 COLLATE 'MACHINE'
INDEX ON CODAUX+CODDOC+NROREF TAG DPRO07 COLLATE 'MACHINE'

***** Change properties for CJADPROV *****
ENDFUNC

FUNCTION MakeTable_CBDFLPDT
***** Table setup for CBDFLPDT *****
CREATE TABLE 'CBDFLPDT.DBF' NAME 'CBDFLPDT' (FORMULARIO C(4) NOT NULL, ;
                       NOMBRE C(20) NOT NULL, ;
                       CODOPE C(3) NOT NULL, ;
                       CODCTA C(30) NOT NULL, ;
                       FACTOR N(2, 0) NOT NULL, ;
                       UIT N(16, 2) NOT NULL)

***** Create each index for CBDFLPDT *****
INDEX ON FORMULARIO+NOMBRE TAG FPDT01 COLLATE 'MACHINE'

***** Change properties for CBDFLPDT *****

***** LOAD DATA
=LoadData_CBDFLPDT()

ENDFUNC

FUNCTION MakeTable_PDT3500
***** Table setup for PDT3500 *****
CREATE TABLE 'PDT3500.DBF' NAME 'PDT3500' (CONTADOR C(15) NOT NULL, ;
                      D_TIPODOC C(1) NOT NULL, ;
                      D_NUMDOC C(15) NOT NULL, ;
                      PERIODO C(4) NOT NULL, ;
                      TIPO_PER C(2) NOT NULL, ;
                      TIPO_DOC C(1) NOT NULL, ;
                      NUM_DOC C(15) NOT NULL, ;
                      IMPORTE C(15) NOT NULL, ;
                      AP_PATER C(20) NOT NULL, ;
                      AP_MATER C(20) NOT NULL, ;
                      NOMBRE1 C(20) NOT NULL, ;
                      NOMBRE2 C(20) NOT NULL, ;
                      RAZON_SOC C(40) NOT NULL)

***** Create each index for PDT3500 *****
INDEX ON NUM_DOC TAG PDT01 COLLATE 'MACHINE'

***** Change properties for PDT3500 *****
ENDFUNC

FUNCTION MakeTable_CBDCNFG1
***** Table setup for CBDCNFG1 *****
CREATE TABLE 'CBDCNFG1.DBF' NAME 'CBDCNFG1' (NIVCTA C(1) NOT NULL, ;
                       NRODIG C(2) NOT NULL, ;
                       ULTIMO N(1, 0) NOT NULL)

***** Create each index for CBDCNFG1 *****
INDEX ON NIVCTA TAG NIVCTA COLLATE 'MACHINE'
INDEX ON NRODIG TAG NRODIG COLLATE 'MACHINE'

***** Change properties for CBDCNFG1 *****
***** LOAD DATA
=LoadData_CBDCNFG1()

ENDFUNC

FUNCTION MakeTable_CBDMCTA2
***** Table setup for CBDMCTA2 *****
CREATE TABLE 'CBDMCTA2.DBF' NAME 'CBDMCTA2' (CODCTA C(8) NOT NULL, ;
                       CODAUX C(6) NOT NULL, ;
                       VCTO01 D NOT NULL, ;
                       VCTO02 D NOT NULL, ;
                       VCTO03 D NOT NULL, ;
                       VCTO04 D NOT NULL, ;
                       VCTO05 D NOT NULL, ;
                       VCTO06 D NOT NULL, ;
                       VCTO07 D NOT NULL, ;
                       VCTO08 D NOT NULL, ;
                       VCTO09 D NOT NULL, ;
                       VCTO10 D NOT NULL, ;
                       VCTO11 D NOT NULL, ;
                       VCTO12 D NOT NULL)

***** Create each index for CBDMCTA2 *****
INDEX ON CODCTA TAG CTA201 COLLATE 'MACHINE'

***** Change properties for CBDMCTA2 *****
ENDFUNC

FUNCTION MakeView_V_ACTIVIDADES_X_FASE_PROC
***************** View setup for V_ACTIVIDADES_X_FASE_PROC ***************

CREATE SQL VIEW "V_ACTIVIDADES_X_FASE_PROC" ; 
   AS SELECT Cpiacxpr.codfase, Cpiacxpr.codprocs, Cpiacxpr.codactiv, Cpiactiv.desactiv FROM  cpiactiv  INNER JOIN cpiacxpr  ON  Cpiactiv.codactiv = Cpiacxpr.codactiv

DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'UpdateType', 1)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'WhereType', 3)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'FetchMemo', .T.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'SendUpdates', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'UseMemoSize', 255)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'FetchSize', 100)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'MaxRecords', -1)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'Tables', LsNomcia+'!cpiacxpr,'+LsNomCia+'!cpiactiv')
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'Prepared', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'CompareMemo', .T.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'Comment', "")
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'ShareConnection', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC', 'View', 'AllowSimultaneousFetch', .F.)

*!* Field Level Properties for V_ACTIVIDADES_X_FASE_PROC
* Props for the V_ACTIVIDADES_X_FASE_PROC.codfase field.
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codfase', 'Field', 'KeyField', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codfase', 'Field', 'Updatable', .T.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codfase', 'Field', 'UpdateName', LsNomcia+'!cpiacxpr.codfase')
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codfase', 'Field', 'DataType', "C(3)")
* Props for the V_ACTIVIDADES_X_FASE_PROC.codprocs field.
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codprocs', 'Field', 'KeyField', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codprocs', 'Field', 'Updatable', .T.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codprocs', 'Field', 'UpdateName', LsNomcia+'!cpiacxpr.codprocs')
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codprocs', 'Field', 'DataType', "C(3)")
* Props for the V_ACTIVIDADES_X_FASE_PROC.codactiv field.
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codactiv', 'Field', 'KeyField', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codactiv', 'Field', 'Updatable', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codactiv', 'Field', 'UpdateName', LsNomcia+'!cpiacxpr.codactiv')
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.codactiv', 'Field', 'DataType', "C(3)")
* Props for the V_ACTIVIDADES_X_FASE_PROC.desactiv field.
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.desactiv', 'Field', 'KeyField', .F.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.desactiv', 'Field', 'Updatable', .T.)
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.desactiv', 'Field', 'UpdateName', LsNomcia+'!cpiactiv.desactiv')
DBSetProp('V_ACTIVIDADES_X_FASE_PROC.desactiv', 'Field', 'DataType', "C(30)")
ENDFUNC
 
FUNCTION MakeView_V_UNIDADES_EQUIVALENCIAS
***************** View setup for V_UNIDADES_EQUIVALENCIAS ***************

CREATE SQL VIEW "V_UNIDADES_EQUIVALENCIAS" ; 
   AS SELECT Almequni.undvta, Almequni.desvta, Almequni.facequ, Almequni.undstk, Almtgsis.tabla, Almtgsis.codigo FROM  almtgsis  INNER JOIN almequni  ON  Almtgsis.codigo == Almequni.undstk WHERE  ( Almtgsis.tabla+Almtgsis.codigo ) = ( "UD" )

DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'UpdateType', 1)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'WhereType', 3)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'FetchMemo', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'SendUpdates', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'UseMemoSize', 255)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'FetchSize', 100)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'MaxRecords', -1)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'Tables', LsNomcia+'!almequni,'+LsNomCia+'!almtgsis')
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'Prepared', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'CompareMemo', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'Comment', "")
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'ShareConnection', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS', 'View', 'AllowSimultaneousFetch', .F.)

*!* Field Level Properties for V_UNIDADES_EQUIVALENCIAS
* Props for the V_UNIDADES_EQUIVALENCIAS.undvta field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undvta', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undvta', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undvta', 'Field', 'UpdateName', LsNomcia+'!almequni.undvta')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undvta', 'Field', 'DataType', "C(3)")
* Props for the V_UNIDADES_EQUIVALENCIAS.desvta field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.desvta', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.desvta', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.desvta', 'Field', 'UpdateName', LsNomcia+'!almequni.desvta')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.desvta', 'Field', 'DataType', "C(25)")
* Props for the V_UNIDADES_EQUIVALENCIAS.facequ field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.facequ', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.facequ', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.facequ', 'Field', 'UpdateName', LsNomcia+'!almequni.facequ')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.facequ', 'Field', 'DataType', "N(12,4)")
* Props for the V_UNIDADES_EQUIVALENCIAS.undstk field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undstk', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undstk', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undstk', 'Field', 'UpdateName', LsNomcia+'!almequni.undstk')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.undstk', 'Field', 'DataType', "C(3)")
* Props for the V_UNIDADES_EQUIVALENCIAS.tabla field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.tabla', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.tabla', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.tabla', 'Field', 'UpdateName', LsNomcia+'!almtgsis.tabla')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.tabla', 'Field', 'DataType', "C(2)")
* Props for the V_UNIDADES_EQUIVALENCIAS.codigo field.
DBSetProp('V_UNIDADES_EQUIVALENCIAS.codigo', 'Field', 'KeyField', .F.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.codigo', 'Field', 'Updatable', .T.)
DBSetProp('V_UNIDADES_EQUIVALENCIAS.codigo', 'Field', 'UpdateName', LsNomcia+'!almtgsis.codigo')
DBSetProp('V_UNIDADES_EQUIVALENCIAS.codigo', 'Field', 'DataType', "C(10)")
ENDFUNC
 
FUNCTION MakeView_V_DOCUMENTOS_X_COBRAR
***************** View setup for V_DOCUMENTOS_X_COBRAR ***************

CREATE SQL VIEW "V_DOCUMENTOS_X_COBRAR" ; 
   AS SELECT UPPER(tpodoc) AS tpodoc, Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc, Ccbrgdoc.nomcli, Ccbrgdoc.fchdoc, Ccbrgdoc.imptot, IIF(codmon=1,"S/.",IIF(codmon=2,"US$",SPACE(3))) AS mon, Ccbrgdoc.codcli, Ccbrgdoc.glodoc FROM  ccbrgdoc ORDER BY Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc

DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'UpdateType', 1)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'WhereType', 3)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'FetchMemo', .T.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'SendUpdates', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'UseMemoSize', 255)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'FetchSize', 100)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'MaxRecords', -1)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'Tables', 'ccbrgdoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'Prepared', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'CompareMemo', .T.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'Comment', "")
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'ShareConnection', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR', 'View', 'AllowSimultaneousFetch', .F.)

*!* Field Level Properties for V_DOCUMENTOS_X_COBRAR
* Props for the V_DOCUMENTOS_X_COBRAR.tpodoc field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.tpodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.tpodoc', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.tpodoc', 'Field', 'UpdateName', 'ccbrgdoc.tpodoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR.tpodoc', 'Field', 'DataType', "C(5)")
* Props for the V_DOCUMENTOS_X_COBRAR.coddoc field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.coddoc', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.coddoc', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.coddoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.coddoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR.coddoc', 'Field', 'DataType', "C(4)")
* Props for the V_DOCUMENTOS_X_COBRAR.nrodoc field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.nrodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.nrodoc', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.nrodoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nrodoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR.nrodoc', 'Field', 'DataType', "C(10)")
* Props for the V_DOCUMENTOS_X_COBRAR.nomcli field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.nomcli', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.nomcli', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.nomcli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nomcli')
DBSetProp('V_DOCUMENTOS_X_COBRAR.nomcli', 'Field', 'DataType', "C(50)")
* Props for the V_DOCUMENTOS_X_COBRAR.fchdoc field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.fchdoc', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.fchdoc', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.fchdoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.fchdoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR.fchdoc', 'Field', 'DataType', "D")
* Props for the V_DOCUMENTOS_X_COBRAR.imptot field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.imptot', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.imptot', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.imptot', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.imptot')
DBSetProp('V_DOCUMENTOS_X_COBRAR.imptot', 'Field', 'DataType', "N(14,4)")
* Props for the V_DOCUMENTOS_X_COBRAR.mon field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.mon', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.mon', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.mon', 'Field', 'UpdateName', 'mon')
DBSetProp('V_DOCUMENTOS_X_COBRAR.mon', 'Field', 'DataType', "C(3)")
* Props for the V_DOCUMENTOS_X_COBRAR.codcli field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.codcli', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.codcli', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.codcli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codcli')
DBSetProp('V_DOCUMENTOS_X_COBRAR.codcli', 'Field', 'DataType', "C(11)")
* Props for the V_DOCUMENTOS_X_COBRAR.glodoc field.
DBSetProp('V_DOCUMENTOS_X_COBRAR.glodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.glodoc', 'Field', 'Updatable', .F.)
DBSetProp('V_DOCUMENTOS_X_COBRAR.glodoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glodoc')
DBSetProp('V_DOCUMENTOS_X_COBRAR.glodoc', 'Field', 'DataType', "C(40)")
ENDFUNC
 
FUNCTION MakeView_V_REPORTE_FACT
***************** View setup for V_REPORTE_FACT ***************

CREATE SQL VIEW "V_REPORTE_FACT" ; 
   AS SELECT Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc, Ccbrgdoc.tpodoc, Ccbrgdoc.fchdoc, Ccbrgdoc.codcli, Ccbrgdoc.nomcli, Ccbrgdoc.coddire, Ccbrgdoc.dircli, Ccbrgdoc.cndpgo, Ccbrgdoc.diavto, Ccbrgdoc.ruccli, Ccbrgdoc.codmon, Ccbrgdoc.tpocmb, Ccbrgdoc.impbto, Ccbrgdoc.pordto, Ccbrgdoc.impdto, Ccbrgdoc.impint, Ccbrgdoc.impgas, Ccbrgdoc.impnet, Ccbrgdoc.impadm, Ccbrgdoc.porigv, Ccbrgdoc.impigv, Ccbrgdoc.imptot, Ccbrgdoc.fchvto, Ccbrgdoc.glodoc, Ccbrgdoc.codref, Ccbrgdoc.nroref, Ccbrgdoc.nroped, Ccbrgdoc.glosa1, Ccbrgdoc.glosa2, Ccbrgdoc.glosa3, Ccbrgdoc.glosa4, Ccbrgdoc.codzon, Ccbrgdoc.codven, Vtaritem.codmat, Vtaritem.desmat, Vtaritem.undvta, Vtaritem.preuni, Vtaritem.canfac, Vtaritem.implin, Vtaritem.facequ, Vtaritem.d1, Vtaritem.d2, Vtaritem.d3, Ccbrgdoc.nroo_c, Ccbrgdoc.tpovta, Ccbrgdoc.impflt, Ccbrgdoc.impseg, Ccbrgdoc.destino, Ccbrgdoc.via, Cbdmauxi.nomaux, Cctcdire.desdire FROM  ccbrgdoc  LEFT OUTER JOIN vtaritem  ON  Ccbrgdoc.coddoc = Vtaritem.coddoc AND  Ccbrgdoc.nrodoc = Vtaritem.nrodoc  LEFT OUTER JOIN cbdmauxi  ON  ( Cbdmauxi.clfaux+Cbdmauxi.codaux ) = ( gsclfven+Ccbrgdoc.codven )  LEFT OUTER JOIN cctcdire  ON  ( Cctcdire.clfaux+Cctcdire.codaux ) = ( gsclfcli+Ccbrgdoc.codcli ) WHERE  ( Ccbrgdoc.coddoc+Ccbrgdoc.nrodoc ) = ( ?_Coddoc+?_NroDoc ) ORDER BY Ccbrgdoc.tpodoc, Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc

DBSetProp('V_REPORTE_FACT', 'View', 'UpdateType', 1)
DBSetProp('V_REPORTE_FACT', 'View', 'WhereType', 3)
DBSetProp('V_REPORTE_FACT', 'View', 'FetchMemo', .T.)
DBSetProp('V_REPORTE_FACT', 'View', 'SendUpdates', .F.)
DBSetProp('V_REPORTE_FACT', 'View', 'UseMemoSize', 255)
DBSetProp('V_REPORTE_FACT', 'View', 'FetchSize', 100)
DBSetProp('V_REPORTE_FACT', 'View', 'MaxRecords', -1)
											   	
DBSetProp('V_REPORTE_FACT', 'View', 'Tables', LsNomcia+'!ccbrgdoc,'+LsNomCia+'!vtaritem,'+LsNomCia+'!cbdmauxi')
DBSetProp('V_REPORTE_FACT', 'View', 'Prepared', .F.)
DBSetProp('V_REPORTE_FACT', 'View', 'CompareMemo', .T.)
DBSetProp('V_REPORTE_FACT', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_REPORTE_FACT', 'View', 'Comment', "")
DBSetProp('V_REPORTE_FACT', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_REPORTE_FACT', 'View', 'ShareConnection', .F.)
DBSetProp('V_REPORTE_FACT', 'View', 'AllowSimultaneousFetch', .F.)

*!* Field Level Properties for V_REPORTE_FACT
* Props for the V_REPORTE_FACT.coddoc field.
DBSetProp('V_REPORTE_FACT.coddoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.coddoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.coddoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.coddoc')
DBSetProp('V_REPORTE_FACT.coddoc', 'Field', 'DataType', "C(4)")
* Props for the V_REPORTE_FACT.nrodoc field.
DBSetProp('V_REPORTE_FACT.nrodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nrodoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nrodoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nrodoc')
DBSetProp('V_REPORTE_FACT.nrodoc', 'Field', 'DataType', "C(10)")
* Props for the V_REPORTE_FACT.tpodoc field.
DBSetProp('V_REPORTE_FACT.tpodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.tpodoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.tpodoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.tpodoc')
DBSetProp('V_REPORTE_FACT.tpodoc', 'Field', 'DataType', "C(5)")
* Props for the V_REPORTE_FACT.fchdoc field.
DBSetProp('V_REPORTE_FACT.fchdoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.fchdoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.fchdoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.fchdoc')
DBSetProp('V_REPORTE_FACT.fchdoc', 'Field', 'DataType', "D")
* Props for the V_REPORTE_FACT.codcli field.
DBSetProp('V_REPORTE_FACT.codcli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codcli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codcli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codcli')
DBSetProp('V_REPORTE_FACT.codcli', 'Field', 'DataType', "C(11)")
* Props for the V_REPORTE_FACT.nomcli field.
DBSetProp('V_REPORTE_FACT.nomcli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nomcli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nomcli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nomcli')
DBSetProp('V_REPORTE_FACT.nomcli', 'Field', 'DataType', "C(50)")
* Props for the V_REPORTE_FACT.coddire field.
DBSetProp('V_REPORTE_FACT.coddire', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.coddire', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.coddire', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.coddire')
DBSetProp('V_REPORTE_FACT.coddire', 'Field', 'DataType', "C(3)")
* Props for the V_REPORTE_FACT.dircli field.
DBSetProp('V_REPORTE_FACT.dircli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.dircli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.dircli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.dircli')
DBSetProp('V_REPORTE_FACT.dircli', 'Field', 'DataType', "C(50)")
* Props for the V_REPORTE_FACT.cndpgo field.
DBSetProp('V_REPORTE_FACT.cndpgo', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.cndpgo', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.cndpgo', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.cndpgo')
DBSetProp('V_REPORTE_FACT.cndpgo', 'Field', 'DataType', "C(18)")
* Props for the V_REPORTE_FACT.diavto field.
DBSetProp('V_REPORTE_FACT.diavto', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.diavto', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.diavto', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.diavto')
DBSetProp('V_REPORTE_FACT.diavto', 'Field', 'DataType', "N(3)")
* Props for the V_REPORTE_FACT.ruccli field.
DBSetProp('V_REPORTE_FACT.ruccli', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.ruccli', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.ruccli', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.ruccli')
DBSetProp('V_REPORTE_FACT.ruccli', 'Field', 'DataType', "C(11)")
* Props for the V_REPORTE_FACT.codmon field.
DBSetProp('V_REPORTE_FACT.codmon', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codmon', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codmon', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codmon')
DBSetProp('V_REPORTE_FACT.codmon', 'Field', 'DataType', "N(1)")
* Props for the V_REPORTE_FACT.tpocmb field.
DBSetProp('V_REPORTE_FACT.tpocmb', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.tpocmb', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.tpocmb', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.tpocmb')
DBSetProp('V_REPORTE_FACT.tpocmb', 'Field', 'DataType', "N(10,4)")
* Props for the V_REPORTE_FACT.impbto field.
DBSetProp('V_REPORTE_FACT.impbto', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impbto', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impbto', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impbto')
DBSetProp('V_REPORTE_FACT.impbto', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.pordto field.
DBSetProp('V_REPORTE_FACT.pordto', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.pordto', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.pordto', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.pordto')
DBSetProp('V_REPORTE_FACT.pordto', 'Field', 'DataType', "N(5,2)")
* Props for the V_REPORTE_FACT.impdto field.
DBSetProp('V_REPORTE_FACT.impdto', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impdto', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impdto', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impdto')
DBSetProp('V_REPORTE_FACT.impdto', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.impint field.
DBSetProp('V_REPORTE_FACT.impint', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impint', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impint', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impint')
DBSetProp('V_REPORTE_FACT.impint', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.impgas field.
DBSetProp('V_REPORTE_FACT.impgas', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impgas', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impgas', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impgas')
DBSetProp('V_REPORTE_FACT.impgas', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.impnet field.
DBSetProp('V_REPORTE_FACT.impnet', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impnet', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impnet', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impnet')
DBSetProp('V_REPORTE_FACT.impnet', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.impadm field.
DBSetProp('V_REPORTE_FACT.impadm', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impadm', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impadm', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impadm')
DBSetProp('V_REPORTE_FACT.impadm', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.porigv field.
DBSetProp('V_REPORTE_FACT.porigv', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.porigv', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.porigv', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.porigv')
DBSetProp('V_REPORTE_FACT.porigv', 'Field', 'DataType', "N(5,2)")
* Props for the V_REPORTE_FACT.impigv field.
DBSetProp('V_REPORTE_FACT.impigv', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impigv', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impigv', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impigv')
DBSetProp('V_REPORTE_FACT.impigv', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.imptot field.
DBSetProp('V_REPORTE_FACT.imptot', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.imptot', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.imptot', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.imptot')
DBSetProp('V_REPORTE_FACT.imptot', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.fchvto field.
DBSetProp('V_REPORTE_FACT.fchvto', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.fchvto', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.fchvto', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.fchvto')
DBSetProp('V_REPORTE_FACT.fchvto', 'Field', 'DataType', "D")
* Props for the V_REPORTE_FACT.glodoc field.
DBSetProp('V_REPORTE_FACT.glodoc', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.glodoc', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.glodoc', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glodoc')
DBSetProp('V_REPORTE_FACT.glodoc', 'Field', 'DataType', "C(40)")
* Props for the V_REPORTE_FACT.codref field.
DBSetProp('V_REPORTE_FACT.codref', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codref', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codref', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codref')
DBSetProp('V_REPORTE_FACT.codref', 'Field', 'DataType', "C(4)")
* Props for the V_REPORTE_FACT.nroref field.
DBSetProp('V_REPORTE_FACT.nroref', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nroref', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nroref', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nroref')
DBSetProp('V_REPORTE_FACT.nroref', 'Field', 'DataType', "C(10)")
* Props for the V_REPORTE_FACT.nroped field.
DBSetProp('V_REPORTE_FACT.nroped', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nroped', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nroped', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nroped')
DBSetProp('V_REPORTE_FACT.nroped', 'Field', 'DataType', "C(8)")
* Props for the V_REPORTE_FACT.glosa1 field.
DBSetProp('V_REPORTE_FACT.glosa1', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.glosa1', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.glosa1', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glosa1')
DBSetProp('V_REPORTE_FACT.glosa1', 'Field', 'DataType', "C(80)")
* Props for the V_REPORTE_FACT.glosa2 field.
DBSetProp('V_REPORTE_FACT.glosa2', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.glosa2', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.glosa2', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glosa2')
DBSetProp('V_REPORTE_FACT.glosa2', 'Field', 'DataType', "C(80)")
* Props for the V_REPORTE_FACT.glosa3 field.
DBSetProp('V_REPORTE_FACT.glosa3', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.glosa3', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.glosa3', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glosa3')
DBSetProp('V_REPORTE_FACT.glosa3', 'Field', 'DataType', "C(80)")
* Props for the V_REPORTE_FACT.glosa4 field.
DBSetProp('V_REPORTE_FACT.glosa4', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.glosa4', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.glosa4', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.glosa4')
DBSetProp('V_REPORTE_FACT.glosa4', 'Field', 'DataType', "C(80)")
* Props for the V_REPORTE_FACT.codzon field.
DBSetProp('V_REPORTE_FACT.codzon', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codzon', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codzon', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codzon')
DBSetProp('V_REPORTE_FACT.codzon', 'Field', 'DataType', "C(1)")
* Props for the V_REPORTE_FACT.codven field.
DBSetProp('V_REPORTE_FACT.codven', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codven', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codven', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.codven')
DBSetProp('V_REPORTE_FACT.codven', 'Field', 'DataType', "C(4)")
* Props for the V_REPORTE_FACT.codmat field.
DBSetProp('V_REPORTE_FACT.codmat', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.codmat', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.codmat', 'Field', 'UpdateName', LsNomcia+'!vtaritem.codmat')
DBSetProp('V_REPORTE_FACT.codmat', 'Field', 'DataType', "C(20)")
* Props for the V_REPORTE_FACT.desmat field.
DBSetProp('V_REPORTE_FACT.desmat', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.desmat', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.desmat', 'Field', 'UpdateName', LsNomcia+'!vtaritem.desmat')
DBSetProp('V_REPORTE_FACT.desmat', 'Field', 'DataType', "C(40)")
* Props for the V_REPORTE_FACT.undvta field.
DBSetProp('V_REPORTE_FACT.undvta', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.undvta', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.undvta', 'Field', 'UpdateName', LsNomcia+'!vtaritem.undvta')
DBSetProp('V_REPORTE_FACT.undvta', 'Field', 'DataType', "C(3)")
* Props for the V_REPORTE_FACT.preuni field.
DBSetProp('V_REPORTE_FACT.preuni', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.preuni', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.preuni', 'Field', 'UpdateName', LsNomcia+'!vtaritem.preuni')
DBSetProp('V_REPORTE_FACT.preuni', 'Field', 'DataType', "N(12,3)")
* Props for the V_REPORTE_FACT.canfac field.
DBSetProp('V_REPORTE_FACT.canfac', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.canfac', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.canfac', 'Field', 'UpdateName', LsNomcia+'!vtaritem.canfac')
DBSetProp('V_REPORTE_FACT.canfac', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.implin field.
DBSetProp('V_REPORTE_FACT.implin', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.implin', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.implin', 'Field', 'UpdateName', LsNomcia+'!vtaritem.implin')
DBSetProp('V_REPORTE_FACT.implin', 'Field', 'DataType', "N(12,2)")
* Props for the V_REPORTE_FACT.facequ field.
DBSetProp('V_REPORTE_FACT.facequ', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.facequ', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.facequ', 'Field', 'UpdateName', LsNomcia+'!vtaritem.facequ')
DBSetProp('V_REPORTE_FACT.facequ', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.d1 field.
DBSetProp('V_REPORTE_FACT.d1', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.d1', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.d1', 'Field', 'UpdateName', LsNomcia+'!vtaritem.d1')
DBSetProp('V_REPORTE_FACT.d1', 'Field', 'DataType', "N(5,2)")
* Props for the V_REPORTE_FACT.d2 field.
DBSetProp('V_REPORTE_FACT.d2', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.d2', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.d2', 'Field', 'UpdateName', LsNomcia+'!vtaritem.d2')
DBSetProp('V_REPORTE_FACT.d2', 'Field', 'DataType', "N(5,2)")
* Props for the V_REPORTE_FACT.d3 field.
DBSetProp('V_REPORTE_FACT.d3', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.d3', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.d3', 'Field', 'UpdateName', LsNomcia+'!vtaritem.d3')
DBSetProp('V_REPORTE_FACT.d3', 'Field', 'DataType', "N(5,2)")
* Props for the V_REPORTE_FACT.nroo_c field.
DBSetProp('V_REPORTE_FACT.nroo_c', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nroo_c', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nroo_c', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.nroo_c')
DBSetProp('V_REPORTE_FACT.nroo_c', 'Field', 'DataType', "C(20)")
* Props for the V_REPORTE_FACT.tpovta field.
DBSetProp('V_REPORTE_FACT.tpovta', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.tpovta', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.tpovta', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.tpovta')
DBSetProp('V_REPORTE_FACT.tpovta', 'Field', 'DataType', "N(1)")
* Props for the V_REPORTE_FACT.impflt field.
DBSetProp('V_REPORTE_FACT.impflt', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impflt', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impflt', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impflt')
DBSetProp('V_REPORTE_FACT.impflt', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.impseg field.
DBSetProp('V_REPORTE_FACT.impseg', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.impseg', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.impseg', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.impseg')
DBSetProp('V_REPORTE_FACT.impseg', 'Field', 'DataType', "N(14,4)")
* Props for the V_REPORTE_FACT.destino field.
DBSetProp('V_REPORTE_FACT.destino', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.destino', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.destino', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.destino')
DBSetProp('V_REPORTE_FACT.destino', 'Field', 'DataType', "C(1)")
* Props for the V_REPORTE_FACT.via field.
DBSetProp('V_REPORTE_FACT.via', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.via', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.via', 'Field', 'UpdateName', LsNomcia+'!ccbrgdoc.via')
DBSetProp('V_REPORTE_FACT.via', 'Field', 'DataType', "C(1)")
* Props for the V_REPORTE_FACT.nomaux field.
DBSetProp('V_REPORTE_FACT.nomaux', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.nomaux', 'Field', 'Updatable', .T.)
DBSetProp('V_REPORTE_FACT.nomaux', 'Field', 'UpdateName', LsNomcia+'!cbdmauxi.nomaux')
DBSetProp('V_REPORTE_FACT.nomaux', 'Field', 'DataType', "C(50)")
* Props for the V_REPORTE_FACT.desdire field.
DBSetProp('V_REPORTE_FACT.desdire', 'Field', 'KeyField', .F.)
DBSetProp('V_REPORTE_FACT.desdire', 'Field', 'Updatable', .F.)
DBSetProp('V_REPORTE_FACT.desdire', 'Field', 'UpdateName', LsNomcia+'!cctcdire.desdire')
DBSetProp('V_REPORTE_FACT.desdire', 'Field', 'DataType', "C(60)")
ENDFUNC
 
FUNCTION MakeView_V_CLIENTES
***************** View setup for V_CLIENTES ***************

CREATE SQL VIEW "V_CLIENTES" ; 
   AS SELECT Cctclien.clfaux, Cctclien.codaux, Cctclien.codcli, Cctclien.razsoc, Cctclien.coddire, IIF(ISNULL(Cctcdire.desdire),SPACE(40),Cctcdire.desdire) AS desdire, Cctclien.nroruc, Cctclien.nrotelf1, Cctclien.nrotelf2, Cctclien.nrofax, Cctclien.flginf, Cctclien.repres, Cctclien.fmaxcre, Cctclien.maxcred FROM  cctclien  LEFT OUTER JOIN cctcdire  ON  Cctclien.codcli = Cctcdire.codcli AND  Cctclien.coddire = Cctcdire.coddire

DBSetProp('V_CLIENTES', 'View', 'UpdateType', 1)
DBSetProp('V_CLIENTES', 'View', 'WhereType', 3)
DBSetProp('V_CLIENTES', 'View', 'FetchMemo', .T.)
DBSetProp('V_CLIENTES', 'View', 'SendUpdates', .F.)
DBSetProp('V_CLIENTES', 'View', 'UseMemoSize', 255)
DBSetProp('V_CLIENTES', 'View', 'FetchSize', 100)
DBSetProp('V_CLIENTES', 'View', 'MaxRecords', -1)
DBSetProp('V_CLIENTES', 'View', 'Tables', LsNomcia+'!cctclien')
DBSetProp('V_CLIENTES', 'View', 'Prepared', .F.)
DBSetProp('V_CLIENTES', 'View', 'CompareMemo', .T.)
DBSetProp('V_CLIENTES', 'View', 'FetchAsNeeded', .F.)
DBSetProp('V_CLIENTES', 'View', 'Comment', "")
DBSetProp('V_CLIENTES', 'View', 'BatchUpdateCount', 1)
DBSetProp('V_CLIENTES', 'View', 'ShareConnection', .F.)
DBSetProp('V_CLIENTES', 'View', 'AllowSimultaneousFetch', .F.)

*!* Field Level Properties for V_CLIENTES
* Props for the V_CLIENTES.clfaux field.
DBSetProp('V_CLIENTES.clfaux', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.clfaux', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.clfaux', 'Field', 'UpdateName', LsNomcia+'!cctclien.clfaux')
DBSetProp('V_CLIENTES.clfaux', 'Field', 'DataType', "C(3)")
* Props for the V_CLIENTES.codaux field.
DBSetProp('V_CLIENTES.codaux', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.codaux', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.codaux', 'Field', 'UpdateName', LsNomcia+'!cctclien.codaux')
DBSetProp('V_CLIENTES.codaux', 'Field', 'DataType', "C(11)")
* Props for the V_CLIENTES.codcli field.
DBSetProp('V_CLIENTES.codcli', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.codcli', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.codcli', 'Field', 'UpdateName', LsNomcia+'!cctclien.codcli')
DBSetProp('V_CLIENTES.codcli', 'Field', 'DataType', "C(4)")
* Props for the V_CLIENTES.razsoc field.
DBSetProp('V_CLIENTES.razsoc', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.razsoc', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.razsoc', 'Field', 'UpdateName', LsNomcia+'!cctclien.razsoc')
DBSetProp('V_CLIENTES.razsoc', 'Field', 'DataType', "C(40)")
* Props for the V_CLIENTES.coddire field.
DBSetProp('V_CLIENTES.coddire', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.coddire', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.coddire', 'Field', 'UpdateName', LsNomcia+'!cctclien.coddire')
DBSetProp('V_CLIENTES.coddire', 'Field', 'DataType', "C(3)")
* Props for the V_CLIENTES.desdire field.
DBSetProp('V_CLIENTES.desdire', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.desdire', 'Field', 'Updatable', .F.)
DBSetProp('V_CLIENTES.desdire', 'Field', 'UpdateName', 'Cctclien.nrotelf1*')
DBSetProp('V_CLIENTES.desdire', 'Field', 'DataType', "C(60)")
* Props for the V_CLIENTES.nroruc field.
DBSetProp('V_CLIENTES.nroruc', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.nroruc', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.nroruc', 'Field', 'UpdateName', LsNomcia+'!cctclien.nroruc')
DBSetProp('V_CLIENTES.nroruc', 'Field', 'DataType', "C(11)")
* Props for the V_CLIENTES.nrotelf1 field.
DBSetProp('V_CLIENTES.nrotelf1', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.nrotelf1', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.nrotelf1', 'Field', 'UpdateName', LsNomcia+'!cctclien.nrotelf1')
DBSetProp('V_CLIENTES.nrotelf1', 'Field', 'DataType', "C(9)")
* Props for the V_CLIENTES.nrotelf2 field.
DBSetProp('V_CLIENTES.nrotelf2', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.nrotelf2', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.nrotelf2', 'Field', 'UpdateName', LsNomcia+'!cctclien.nrotelf2')
DBSetProp('V_CLIENTES.nrotelf2', 'Field', 'DataType', "C(9)")
* Props for the V_CLIENTES.nrofax field.
DBSetProp('V_CLIENTES.nrofax', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.nrofax', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.nrofax', 'Field', 'UpdateName', LsNomcia+'!cctclien.nrofax')
DBSetProp('V_CLIENTES.nrofax', 'Field', 'DataType', "C(9)")
* Props for the V_CLIENTES.flginf field.
DBSetProp('V_CLIENTES.flginf', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.flginf', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.flginf', 'Field', 'UpdateName', LsNomcia+'!cctclien.flginf')
DBSetProp('V_CLIENTES.flginf', 'Field', 'DataType', "L")
* Props for the V_CLIENTES.repres field.
DBSetProp('V_CLIENTES.repres', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.repres', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.repres', 'Field', 'UpdateName', LsNomcia+'!cctclien.repres')
DBSetProp('V_CLIENTES.repres', 'Field', 'DataType', "C(40)")
* Props for the V_CLIENTES.fmaxcre field.
DBSetProp('V_CLIENTES.fmaxcre', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.fmaxcre', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.fmaxcre', 'Field', 'UpdateName', LsNomcia+'!cctclien.fmaxcre')
DBSetProp('V_CLIENTES.fmaxcre', 'Field', 'DataType', "T")
* Props for the V_CLIENTES.maxcred field.
DBSetProp('V_CLIENTES.maxcred', 'Field', 'KeyField', .F.)
DBSetProp('V_CLIENTES.maxcred', 'Field', 'Updatable', .T.)
DBSetProp('V_CLIENTES.maxcred', 'Field', 'UpdateName', LsNomcia+'!cctclien.maxcred')
DBSetProp('V_CLIENTES.maxcred', 'Field', 'DataType', "N(12,2)")
ENDFUNC
 

FUNCTION DisplayStatus(lcMessage)
WAIT WINDOW NOWAIT lcMessage
ENDFUNC
****************************
function LoadData_CbdMTabl
****************************
begin transaction
Delete all in cbdmtabl
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','01','CLASIFICACION DE AUXILIARES',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','02','TABLA DE DOCUMENTOS',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','03','CENTROS DE COSTOS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','04','BANCOS ..',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','20NC','AGRUPCIONES DE TIPOS DE GASTOS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','21NC','UNIDADES DE COSTOS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','22NC','PROCESOS DE FORMACION',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','23NC','COLORES Y ETIQUETAS EN DECORADO',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','24NC','AGRUPACION DE CENTROS DE COSTOS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','04','BANCOS',5,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','06','FLUJO DE CAJA',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','05','TIPOS DE GASTO',5,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','03','CENTRO DE COSTOS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','08','INTERCOMPANIAS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','21','PRODUCTOS TERMINADOS',6,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','60','COMPRA MAT.PRIMAS,ENV. Y SUMINISTROS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','70','VENTAS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','01','MATERIA PRIMA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','02','COMBUSTIBLE HORNO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','03','OTROS COMBUSTIBLES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','04','MANTENIMIENTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','05','OTROS VARIABLES (INCL. ENERGIA)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','06','MANO DE OBRA DIRECTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','08','MANO DE OBRA INDIRECTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','09','SERVICIO AL  PERSONAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','10','DEPRECIACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','11','MANTENIMIENTO FIJO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','12','OTROS FIJOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '20','99','OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','01','TON. FUNDIDAS AMBAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','02','TON. FUNDIDAS FLINT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','03','TON. FUNDIDAS VERDE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','04','TON. FUNDIDAS OTRO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','06','TON. FUNDIDAS TOTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','07','TON. EMPACADAS AMBAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','08','TON. EMPACADAS FLINT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','09','TON. EMPACADAS VERDE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','10','TON. EMPACADAS OTRO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','11','TON. EMPACADAS TOTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','12','UNIDADES FABRICADAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','13','UNIDADES EMPACADAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','14','UNIDADES GRCWT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','15','CONS. PANTALLAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','19','UNIDADES DECORADAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','26','H. OPERACION SECCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','27','H. OPERACION CAVIDAD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','30','H.O.M. 6-GS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','31','H.O.M. 6-GD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','32','H.O.M. 8-GD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','41','TOTAL H.O.M.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','42','HRS HOMBRE SELECTORES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','43','H.O.M. DECORADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','46','CAMB. T. DE W CAVID',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','47','CAMB. T. DE W SECCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','48','N° CAMBIOS DE TRABAJOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','49','HORAS CAMBIO DE TRABAJO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','55','MESES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','56','DIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','97','GASTOS OPERACIONALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','98','OTROS GASTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '21','99','TOTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','05','06 GS / S.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','06','06 GS / P.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','07','06 GD / S.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','11','06 GD / P.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','14','08 GD / S.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','15','08 GD / P.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','18','10 GD / S.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '22','19','10 GD / S.S.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '23','01','MF 8213',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '23','02','HM 2200',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '23','03','MF 2282',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '23','04','HM 2201',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','01','MEZCLAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','02','HORNOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','03','FORMACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','04','ARCHAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','05','TALL REP MAQ',0,'2','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','06','TALL REP MOD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','07','PALETIZ/EMPAQ',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','08','SELECCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','09','DECOR Y REQ.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','10','MANTEN.GRAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','11','ADMIN PLANTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '30','01','BALANCE GENERAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','01','ESTADO PERDIDAS Y GANANCIAS (NATURALEZA)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','02','ESTADO DE GANANCIAS Y PERDIDAS (FUNCION)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '32','01','E.P.G. NATURALEZA - PROYECTADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '32','02','E.P.G. FUNCION - PROYECTADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '32','03','SUELDOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','01','MATERIA PRIMA IMPORTADA',0,'00010','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','02','MATERIA PRIMA LOCAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','03','COMBUSTIBLE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','04','E. E. E. E.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','05','MANO DE OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','06','MATERIAL AUXILIAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','07','SERVICIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','08','ASISTENCIA TECNICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','09','GASTOS DIVERSOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','10','I. G. V.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','11','IMPUESTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','12','INVERSIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','13','AMORTIZACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'CJ','REMES','REMESAS A CAJA CHICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','001','DEVOLUCION VIATICOS',0,'38401','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','002','COMISIONES SOBRE COMPRAS',0,'75952','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','003','SUSCRIPCION ACCIONES COMUNES',0,'50101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','004','SUSCRIPCION ACCIONES LABORALES',0,'55103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','005','DEVOLUCION PROVISIONALES',0,'38401','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','006','DEVOLUCION PROVEEDORES',0,'42111','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','CAMB','CAMBIO DE MONEDA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'IC','REME','REMESAS A CAJA CHICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RA','01','Flujo de Caja Real',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RA','02','x bco',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','01','Factura',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','04','Liquidación de compras',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','05','Boleto de aviación',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','06','Carta de porte aereo',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','07','Nota de Credito',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','08','Nota de Debito',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','11','P¢liza bolsa valores',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','12','Ticket m q. registra',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','13','Dcmto. emit. x Banco',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','14','Recibo Servicios Publicos',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','18','Dcmto. emit. A.F.P.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','21','Conocim. de embarque',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','50','PO POLIZA O DECLARACION UNICA DE IMPORT.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','54','LC LIQUIDACION DE COBRANZA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','NO','NO REGISTRA DOCUMENTO DE SUNAT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','IGV','IMPUESTO GENERAL A LAS VENTAS',0,'401101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','IGV','IMPUESTO GENERAL A LAS VENTAS',0,'4011011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','201','DESCUENTO OMITIDO EN FACTURA',0,'7010011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','202','DEVOLUCION DE MERCADERIA',0,'7010011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','203','DIFERENCIA DE PRECIOS',0,'7010011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','204','DESCUENTO ADICIONAL EN FACTURA',0,'7010011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','205','FACTURA MAL EMITIDA',0,'7010011','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','101','GASTOS POR LETRA PROTESTADA',0,'772','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','102','SERV. Y GASTOS X PRES. LETRAS SEC. DSTO.',0,'771','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','103','GASTOS E INTERESES POR LETRA PROTESTADA',0,'772','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','104','INTERESES POR VENCIMIENTO DE LETRA',0,'772','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NC','105','GASTOS DE CHEQUE DEVUELTO',0,'772','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','VEN','VENDEDORES',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'FP','01','CONTADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'FP','02','CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','MN','Monedas del sistema',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','11','ADMIN PLANTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '24','12','GASTOS OPERACIONALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TP','01','PLLA.CBZA EFECTIVO/CHEQUE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TF','001','UNA GUIA',0,'','','G/R',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TF','002','VARIAS GUIAS',0,'','','G/R',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TF','003','UN PEDIDO',0,'','','PEDI',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TF','004','LIBRE',0,'','','FREE',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MN','1','NS/.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MN','2','US$',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','RP','RESPUESTA SI/NO',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RP','S','Si',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RP','N','No',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','TM','Tipo movimiento contable',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TM','D','Debe',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TM','H','Haber',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TM','C','Ambos',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','TC','Tipo de cuenta',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','1','Naturaleza',1,'60','99','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','2','Funcion',2,'60','99','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','3','Naturaleza y Funcion',3,'60','99','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','4','Ninguna',4,'60','99','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','1','Activo corriente',1,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','2','Activo no corriente',2,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','3','Pasivo corriente',3,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','4','Pasivo no corriente',4,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','5','Patrimonio',5,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TC','6','Segun saldo',6,'00','59','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','MM','Meses contables',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','01','01. ENERO',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','02','02. FEBRERO',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','03','03. MARZO',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','04','04. ABRIL',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','05','05. MAYO',5,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','06','06. JUNIO',6,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','07','07. JULIO',7,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','08','08. AGOSTO',8,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','09','09. SETIEMBRE',9,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','10','10. OCTUBRE',10,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','11','11. NOVIEMBRE',11,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','12','12. DICIEMBRE',12,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','RS','OPCIONES - REGENERACION DE SALDOS',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RS','1','1.- Acumulado de todo el Año',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RS','2','2.- SOLO movimientos del mes',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RS','3','3.- Acumulado por cuenta de todo el Año',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'RS','4','4.- SOLO movimientos del mes de una cuen',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'MM','00','00. APERTURA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','ACC','ACCIONISTAS',8,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','CCH','CAJA CHICA',9,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','CFZ','CARTAS FIANZAS',5,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','CT9','CLASE 9',7,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','SN','Tipo de documentos SUNAT',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','09','Gu¡a de Remisión',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TV','1','Bienes',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TV','2','Servicios',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TV','3','Promociones',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','30','BALANCES',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','31','ESTADOS DE GESTION',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','02','Recibo x Honorarios',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','03','Boleta de venta',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','10','Recibo arrendamiento',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','15','Boletos Trans. Urban',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','16','Boleto viaje en pa¡s',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','17','I. Catolica arrendam',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','19','Boletos espectaculos',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','22','Operac.no habituales',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','23','P¢liza de subasta',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','24','Regal¡as PETROPERU',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','26','Recibo agua regad¡o.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','27','RECIBO INGRESOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','30','CHEQUE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','44','IMPORTACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','AFC','Afectación a libros contables',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AF','A','Afecto',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AF','I','Inafecto',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AF','G','Gravado',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AF','N','No gravado',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','TV','Tipo de Ventas',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SB','1','Suma',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SB','2','Resta',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SB','3','Suma (Ajustado)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','TS','Tipo de saldo EE.FF.',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','SB','Signos EE.FF.',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SB','4','Resta (Ajustado)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TS','1','Saldos Activos',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TS','2','Saldos Pasivos',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'TS','3','Saldo Total',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','ANXO','Anexos al balance',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','01','CAJA Y BANCOS (ACTIVO)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','02','CUENTAS POR COBRAR COMERCIALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','03','OTRAS CUENTAS POR COBRAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','07','INMUEBLE MAQUINARIA Y EQUIPO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','09','CUENTAS POR PAGAR COMERCIALE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','04','EXISTENCIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','10','OTRAS CUENTAS POR PAGAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','14','DEUDAS A LARGO PLAZO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','11','TRIBUTOS POR PAGAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','15','BENEFICIOS SOCIALES TRABAJADOR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','06','VALORES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','05','CARGAS DIFERIDAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','08','INVERSIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','12','REMUNERACIONES Y PARTICIPACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','13','OTRAS CUENTAS POR PAGAR DIVERSAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','20','INGRESOS DIVERSOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'AN','21','INGRESOS Y GASTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','LT','Letras',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','REND','RENDICIONES DE CUENTA VARIAS',4,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','LIQ','LIQUIDACION DE ADUANA',10,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','REND','RENDICIONES VARIAS',8,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','03','ESTADO DE GESTION PARA CEVA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','DE','Destino de ventas',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','VI','Vias de trasnporte',1,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','ET','Empresas de transporte',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'DE','N','Nacional',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'DE','E','Exportación',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'VI','A','Aereo',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'VI','M','Maritimo',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'VI','T','Terrestre',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'ET','01','CIP AEROPUERTO VIRU VIRU',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'NA','RET','RETENCION 6%',0,'4011131','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','TARJE','TARJETA DE CREDITO',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','01','FACTURAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','08','NOTAS DE DEBITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','02','RECIBO DE HONORARIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','03','BOLETAS DE VENTA',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','07','NOTAS DE CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','10','RECIBO DE ARRENDAMIENTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','12','TICKET MAQUINA REGISTRADORA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','13','DOC.EMITIDOS POR BANCOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','18','DCTO EMITIDO POR AFP',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','14','RECIBO POR SERVICIOS PUBLICOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','04','LIQUIDACION DE COMPRA',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','05','BOLETA DE COMPRA AVIAC.COMER.',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','06','CARTA PORTE AEREO',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','09','RECIBO DE CAJA',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','11','POLIZAS EMITIDAS X BOLSAS DE VALORES',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','15','BOLETO EMITIDO TRANSP.PUBLICO',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','16','BOLETO DE VIAJE',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','21','DOC.EMITIDO POR SUNAD-ADUANAS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','22','COMPROB.OPERAC.NO HABITUALES',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','23','POLIZA DE REMATE',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','24','CERTIFIC.DE PAGO DE REGALIAS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','31','ORDEN DE COMPRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','32','PROVISIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','34','LIQ.CONT.TRANS.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '04','01','WIESE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '04','02','CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '04','03','CONTINENTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '04','04','SUDAMERICANO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','00','VARIOS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','CH','CHEQUE',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','LT','LETRA',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','CP','COMPROBANTE DE PAGO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','RI','REC. INGRESOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','PLC','PLANILLA COBRANZAS VTAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','40','COMPROBANTE DE PERCEPCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','32','Provisiones',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','31','Orden de Compras',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','40','Comprobante de percepcion',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','00','Varios',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','PLC','Planilla cobranza ventas',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','RI','Recibo de Ingreso',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'SN','CH','Cheque',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'FP','03','CREDITO 15  DIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'FP','04','CREDITO  30 DIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( 'FP','05','CREDITO   7  DIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','DV','DIVISIONARIAS',2,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','04','GASTOS GENERALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','PREST','PRESTAMOS DE TERCEROS',6,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','PERS','PERSONAL',6,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '02','CA','CARTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0000','GASTOS GENERALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','05','CONCEPTOS DE GASTO (EGRESO )',5,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00001','3ERA.CATEGORIA',0,'4010103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00002','A CUENTA UTILIDADES',0,'6250101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00003','ACCESORIOS EQUIPO DE BOMBEO',0,'6030103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00004','ACERO,ALAMBRE,CLAVOS',0,'6040301','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00005','ACERO,ALAMBRES,ETC',0,'6040301','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00006','ACERO,SOLDADURA',0,'6040301','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00007','ADELANTO DE MATERIALES',0,'604','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00008','ADELANTO EN EFECTIVO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00009','ADICIONAL DE VALORIZACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00010','ADICIONAL FONDO DE GARANTIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00011','ADITIVO MEJORADO DE ADHERENCIA',0,'6060306','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00012','AGREGADOS',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00013','AGREGADOS,AFIRMADO',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00014','AGUA',0,'6060308','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00015','ALAMBRE NEGRO-OBRAS CIVILES',0,'6040701','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00016','ALCANTARILLAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00017','ALIMENTACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00018','ALQ.OFICINA CONSORCIO',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00019','ALQ.OFICINA SUPERVISION',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00020','ALQUILER DE EQUIPO',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00021','ALQUILER DE EQUIPO TERCEROS',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00022','ALQUILER EQUIPO',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00023','ALQUILER EQUIPO PROPIO',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00024','ALQUILER EQUIPO UPACA',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00025','ALQUILER EQUIPOS TERCEROS',0,'63501','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00026','AMAKELLA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00027','ANALISIS DE GASTOS GENERALES FIJOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00028','APERTURA DE CUENTAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00029','APOYO POLICIAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00030','ARBOL DE EUCALIPTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00031','ARENA',0,'6040101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00032','ARENA GRUESA-SAND FOR GROUT',0,'6040101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00033','ASESORIAS',0,'6330111','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00034','ASESORIAS Y ROYALTIS',0,'6330111','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00035','ASFALTO',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00036','ASFALTO PEN 120/150',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00037','ASFALTO PEN 85/100',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00038','ASFALTO RC-250',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00039','AVANCE EN CUENTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00040','BANCO CONTINENTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00041','BANCO DE CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00042','BANCO FINANCIERO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00043','BANKBOSTON',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00044','BONIFICACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00045','BONIFICACIONES Y OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00046','BUFETE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00047','CAJA CHICA',0,'1010101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00048','CAJA CHICA Y OTROS GASTOS MENORES',0,'1010101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00049','CAJAMARCA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00050','CAJAS DE REGISTRO',0,'6050101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00051','CAL HIDRATADA',0,'6040106','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00052','CAMACHO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00053','CAMIONCITO',0,'6340202','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00054','CAMIONES TERCEROS',0,'6350104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00055','CAMIONETAS',0,'6340202','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00056','CAMIONETAS Y CAMIONES UPACA',0,'6340202','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00057','CAMPAMENTO',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00058','CAMPAMENTO ALQUILERES',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00059','CAMPAMENTO CONSORCIO',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00060','CAMPAMENTO SUPERVISION',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00061','CAMPAMENTO UPACA',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00062','CAMPAMENTO Y SEGURIDAD',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00063','CAMPAMENTOS',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00064','CARPINTERIA METALICA',0,'6330109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00065','CARRETERA OLMOS',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00066','CARRETERA PISCO',0,'6040105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00067','CARTAS FIANZAS',0,'7790102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00068','CEMENTO',0,'6040201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00069','CEMENTOS MS-CEMENT FOR GROUT',0,'6040201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00070','CHACHAPOYAS',0,'1040113','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00071','CHEQUES EN GARANTIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00072','CHIRA PIURA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00073','CISTERNAS',0,'6340202','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00074','CLAVOS PARA MADERA-OBRAS CIVILES',0,'6040909','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00075','COCRETO PRE-MEZCLADO',0,'6040104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00076','COLISEO EOPNP',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00077','COLOCACION DE PERNOS,BARRAS,ANCLAJE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00078','COMBUSTIBLE',0,'60603','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00079','COMBUSTIBLES  Y LUBRICANTES',0,'60603','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00080','COMISION CARTA DE CREDITO',0,'6780105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00081','COMISION VENTA',0,'6320201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00082','COMISION VENTA GRA¥A',0,'6320201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00083','COMISION VENTA US$236,000+IGV',0,'6320201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00084','COMISION VENTA US$364,000 + IGV',0,'6320201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00085','COMISIONES Y DERECHOS',0,'6320201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00086','COMISIONES,FIANZAS Y OTROS',0,'6780105','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00087','COMPRAS MENORES',0,'6080109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00088','COMPUERTAS',0,'6060309','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00089','COMUNICACIONES',0,'63102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00090','CON EQUIPO PROPIO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00091','CON EQUIPO TERCEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00092','CONCRETO',0,'6040302','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00093','CONCRETO CONVENCIONAL',0,'6040302','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00094','CONCRETO Y CEMENTO',0,'6040302','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00095','CONO NORTE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00096','CONSTRUCTORA OAS-UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00097','CONTINGENCIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00098','CORDE CALLAO',0,'6460102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00099','CORDELICA',0,'6460102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00100','COSTO AMBIENTAL',0,'6460103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00101','DEPOSITOS EN GARANTIA',0,'4670101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00102','DERECHO DE CANTERA',0,'6460103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00103','DERECHOS EDELNOR',0,'6360101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00104','DIRECCION TECNICA',0,'6320103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00105','DIRECTORES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00106','DIRECTORIO',0,'6280101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00107','DISOLVENTE-OBRAS CIVILES',0,'6090101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00108','DIVERSOS',0,'6090101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00109','EDUARDO PICCINI MARTIN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00110','EGRESOS CORRESPONDIENTES A OBRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00111','EGRESOS NO CORRESPONDIENTES A OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00112','ELECTRICIDAD',0,'6360101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00113','EMAPE',0,'6460102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00114','ENVIOS A OBRA',0,'6300301','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00115','EQUIPAMIENTO DE VIV.Y CAMPAMENTO',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00116','EQUIPAMIENTO ELECTRICO',0,'6330112','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00117','EQUIPAMIENTO HIDRAULICO',0,'6510104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00118','EQUIPO BUFETE',0,'1330104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00119','EQUIPO DE SEGURIDAD Y UNIFORMES',0,'6060801','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00120','EQUIPO DE TERCEROS',0,'6330114','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00121','EQUIPO MOVIMIENTO DE TIERRAS',0,'6330104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00122','EQUIPO PARA OBRAS DE ARTE',0,'6510104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00123','EQUIPO PARA PAVIMNETACION',0,'6510104','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00124','EXPLOSIVOS',0,'6090101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00125','EXPLOSIVOS Y ACCESORIOS',0,'6090101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00126','FEE ODEBRECHT-FEE CAMARGO CORREA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00127','FEE UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00128','FERNANDO PICINNI',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00129','FERRETERIA',0,'6060201','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00130','FIERRO CORRUGADO',0,'6040601','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00131','FIERRO CORRUGADO-OBRAS CIVILES',0,'6040601','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00132','FILLER',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00133','FLETE LOCAL Y ALMACENAJE',0,'6300102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00134','FONDO DE GARANTIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00135','FRACCIONAMIENTO TRIBUTARIO',0,'3810103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00136','GAS PROPANO',0,'6060309','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00137','GASTOS ALQUILER EQUIPO',0,'6330115','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00138','GASTOS ALQUILER TERCEROS',0,'6330115','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00139','GASTOS DE FERRETERIA',0,'6080102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00140','GASTOS DE FERRETERIA Y OTROS',0,'6080102','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00141','GASTOS DE LICITACION',0,'6550101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00142','GASTOS DE LICITACION Y CONTRATACION',0,'6550101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00143','GASTOS DE OFICINA CENTRAL',0,'6080103','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00144','GASTOS DE PERSONAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00145','GASTOS DE REPRESENTACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00146','GASTOS DIRECTOS Y CONSUMOS DE OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00147','GASTOS DIRECTOS Y CONSUMOS EN OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00148','GASTOS DIRECTOS Y CONSUMOS OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00149','GASTOS FERRETERIAS(ALAMBRE,CLAVOS,ETC)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00150','GASTOS FIJOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00151','GASTOS FINANCIEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00152','GASTOS GENERALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00153','GASTOS GENERALES FIJOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00154','GASTOS LICITACION Y PRESUPUESTOS',0,'6550101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00155','GASTOS NOTARIALES,REGISTRALES',0,'6320301','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00156','GASTOS OFIC.PRINC.S/.30,000/MES 12',0,'6340109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00157','GASTOS OFIC.PRINC.S/.30,000/MES 18',0,'6340109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00158','GASTOS OFIC.Y CAMPAMENTO ALQ.',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00159','GASTOS PERSONAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00160','GEOTEXTIL PARA SUB-DRENAJE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00161','GUARDIANIA',0,'6380101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00162','HABILITACION DE CAMPAMENTOS',0,'6590110','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00163','HARDFIL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00164','HERRAMIENTAS',0,'6060101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00165','HERRAMIENTAS MANUALES-OBRAS CIVILES',0,'6060101','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00166','HONORARIOS',0,'6320109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00167','HONORARIOS PROFESIONALES',0,'6320109','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00168','I.G.V.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00169','I.G.V. Y OTROS IMPUESTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00170','I.GENERAL A LAS VTAS.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00171','IGV',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00172','IMP.A LA RENTA 3ERA.CATEGORIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00173','IMP.ADICIONAL A LA RENTA DE 3ERA.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00174','IMPLEMENTOS DE SEGURIDAD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00175','IMPREVISTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00176','IMPTOS.EXTRAORDINARIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00177','IMPUESTO A LA RENTA 3RA.CATEG.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00178','IMPUESTO A LA RENTA 3RA.CATEGORIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00179','IMPUESTOS SUNAT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00180','INCREMENTO DE PRECIOS E IMPREVISTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00181','INGRESOS ADICIONALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00182','INGRESOS CORRESPONDIENTES A OBRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00183','INGRESOS NO CORRESPONDIENTES A OBRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00184','INMOBILIARIO OFIC.Y CAMPAMENTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00185','INSPECCION,PRUEBAS Y OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00186','INSTALACIONES PROVISIONALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00187','INTERESES SOBREGIROS Y OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00188','INTERNAMIENTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00189','IPSS,FONAVI Y OTRAS CARGAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00190','JOSE PICCINI',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00191','JOSE PICCINI MARTIN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00192','JULIO PICCINI MARTIN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00193','JUNTAS DISIMETRICAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00194','KEROSENE INDUSTRIAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00195','LA MARINA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00196','LA MOLINA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00197','LACA PARA ENCOFRADO-OBRAS CIVILES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00198','LETREROS DE OBRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00199','LIQUIDACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00200','LOS OLIVOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00201','LUBRICANTES,FILTROS Y OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00202','LUIS PICCINI MARTIN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00203','LUZ',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00204','MADERA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00205','MADERA PARA ENCOFRADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00206','MADERA Y TRIPLAY',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00207','MADERA-OBRAS CIVILES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00208','MAJES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00209','MAJES.AREQUIPA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00210','MANO DE OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00211','MANT.DE ACCESO VEHICULAR Y PEATONAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00212','MAQ.Y EQU.NO INCLUIDOS EN COSTO DIRECTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00213','MAQUINARIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00214','MAQUINARIA UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00215','MAQUINARIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00216','MAQUINARIAS TERCEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00217','MARA¥ON-CHICLAYO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00218','MAT.DE ACERO Y FIERRO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00219','MAT.IMPORT./CAMARA Y EMPALMES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00220','MAT.IMPORT./LINEA DE ALCANTARILLADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00221','MAT.IMPORT./REHAB.DE RESERVORIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00222','MAT.IMPORT/LINEA DE AGUA POTABLE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00223','MAT.IMPORT/LINEA DE CONDUCCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00224','MAT.NAC./CAMARAS Y EMPALMES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00225','MAT.NAC./COLECT.DE ALCANTARILLADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00226','MAT.NAC./LINEA DE AGUA POTABLE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00227','MAT.NAC./LINEA DE ALCANTARILLADO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00228','MAT.NAC./LINEA DE CONDUCCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00229','MAT.NAC./REHAB.DE RESERVORIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00230','MAT.PARA CONCRETO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00231','MATERIAL DE SHORTCRETE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00232','MATERIAL EN CANCHA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00233','MATERIALE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00234','MATERIALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00235','MATERIALES IMPORTADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00236','MATERIALES LOCALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00237','MATERIALES NACIONALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00238','MEDICINAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00239','MEDIDORES DE CAUDAL Y PROFUNDIDAD Y SIST',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00240','MITIGACION DE IMPACTOS AMBIENTALES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00241','MOLLENDO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00242','MOVILIZACION Y DESMOVILIZACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00243','OAS UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00244','OAS-UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00245','OBRAS DE ARTE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00246','ODEBRECHT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00247','ODEBRECHT SEDAPAL II',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00248','ODEBRECHT UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00249','ODEBRECHT-UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00250','ODEBRECHT-UPACA II',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00251','ODEBRECHT-UPACA SEDAPAL 2',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00252','OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00253','OTROS GASTOS GENERALES VAR.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00254','OTROS GASTOS NO PRESUPUESTADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00255','OTROS INGRESOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00256','OTROS NO CLASIFICADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00257','OTROS NO INCLUIDOS EN COSTO DIRECTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00258','OTROS NO PROGRAMADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00259','OTROS PRESTAMOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00260','OTROS(INCLUYE RADIOS Y PC´S)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00261','OTROS(INCLUYE RADIOS,PC´S,Y OTROS)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00262','PAGARE BANCO CONTINENTAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00263','PAGARE BANCO DE CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00264','PAGARE BANCO FINANCIERO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00265','PAGARE BCO.DE CREDITO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00266','PAGARE BCO.FINANCIERO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00267','PAGARES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00268','PAMPLONA ALTA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00269','PERMISOS Y LICENCIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00270','PERSONAL TECNICO ADM.',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00271','PETROLEO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00272','PETROLEO EQUIPO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00273','PETROLEO EQUIPO PROPIO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00274','PETROLEO EQUIPO UPACA Y TERCEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00275','PETROLEO PLANTA DE ASFALTO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00276','POLIZAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00277','POLIZAS CAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00278','PONT A MOUSSON',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00279','PREMIOS DE EFICIENCIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00280','PRESTAMO A SABOGAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00281','PRESTAMO A TALLER',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00282','PRESTAMO A UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00283','PRESTAMO BUFETE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00284','PRESTAMO COMPRA EQUIPO UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00285','PRESTAMO CORDELICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00286','PRESTAMO PUCALLPA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00287','PRESTAMO UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00288','PRESTAMOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00289','PRESTAMOS DE OTRAS OBRAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00290','PRESTAMOS OTORGADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00291','PRONAP',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00292','PRONAP CHICLAYO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00293','PRONAP SULLANA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00294','PROVISIONES E IMPREVISTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00295','PRUEBAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00296','PRUEBAS DE LABORATORIO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00297','PUCALLPA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00298','REAJUSTE DE ADELANTO EN EFECTIVO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00299','REEMPLAZO DE TUB.AGUA POTABLE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00300','REGEVETACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00301','REHAB.CALLAO ODEBRECHT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00302','REHAB.CALLAO UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00303','REHAB.UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00304','REHABILITAC.USO CONJUNTIVO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00305','REHABILITACION CALLAO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00306','REHABILITACION SEDAPAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00307','REHABILITACION SEDAPAL 2',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00308','REINTEGRO DE VALORIZACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00309','RENTA 3RA.CATEGORIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00310','RENTA 4TA.CATEGORIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00311','REPOSICIONES Y OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00312','REPUESTOS Y ACCESORIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00313','REPUESTOS,REPARAC.EQUIPO UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00314','REPUESTOS,REPARACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00315','RESERV.SEDAPAL 2 UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00316','RETENCION 6%',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00317','RETENCION IGV 6%',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00318','RETENCION SUNAT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00319','REUBICACION DE POSTES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00320','ROYALTI BUFETE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00321','RPTOS.REPARAC.EQUIPO PROPIO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00322','SABOGAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00323','SALARIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00324','SALDO ANTERIOR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00325','SALIDAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00326','SAN LUIS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00327','SEDAPAL - LURIN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00328','SEDAPAL-BIRF',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00329','SEDAPAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00330','SEGURO POLIZAR CONTRA TERCEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00331','SEGUROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00332','SEGUROS DE ACC.DE TRABAJO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00333','SEGUROS DE OBRA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00334','SENCICO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00335','SE¥ALIZACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00336','SIKA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00337','SIN OBRA 11',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00338','SIN OBRA 9',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00339','SUB-CONTRATOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00340','SUELDOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00341','SUELDOS EMPLEADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00342','SUMINISTROS ABRAZADERAS,GRIFOS,TAPONES F',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00343','SUMINISTROS DE TUBERIA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00344','SUMINISTROS DE TUBERIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00345','SUMINISTROS TUBERIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00346','TABLESTACADO METALICO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00347','TABLESTACADO Y BOMBEO,PROTEC.ZANJAS E IN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00348','TABLESTACAS Y PERFILES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00349','TALLER',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00350','TAPAS CONCRETO,MARCOS FO.FO MANGUITOS,FO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00351','TELEFONO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00352','TELEFONO Y COMUNICACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00353','TRANSF.DE CUENTAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00354','TRANSFERENCIAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00355','TRANSFERENCIAS BUFETE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00356','TRANSFERENCIAS DE CUENTAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00357','TRANSFERENCIAS UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00358','TRANSPORTE Y ALMACENAJE',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00359','TRIBUTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00360','TRIBUTOS Y SEGURO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00361','TRIBUTOS Y SEGUROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00362','TRIPLAY DE 19ML-OBRAS CIVILES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00363','TUBERIA CORRUGADA DE 48"MM',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00364','TUBERIA DE ACERO CORRUGADO TMC',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00365','TUBERIA DE CONCRETO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00366','TUBERIA PVC',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00367','TUBERIA Y EQUIPAMIENTO HIDRAULICO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00368','TUBERIAS CSN ESPIGA Y CAMPANA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00369','TUBERIAS REMACHADAS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00370','TUBERIAS Y ACCESORIOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00371','TUBERIAS Y ACCESORIOS IMPORTADOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00372','TUBERIAS Y ACCESORIOS PVC',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00373','TUBERIAS Y ACCESORIOS(HFD)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00374','UPACA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00375','UPACA ECOVIDA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00376','UPACA MARA¥ON',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00377','USO CONJUNTIVO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00378','USO CONJUNTIVO II',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00379','UTILES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00380','VALORIZACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00381','VALORIZACIONES DE ROCA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00382','VALVULAS Y MEDIDORES DE CAUDAL',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00383','VARIOS U OTROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00384','VARIOS,TRAMITES E IMPREVISTOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00385','VIGILANCIA PARTICULAR',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00386','VIVIENDAS DE INGENIEROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00387','VOLADURA DE ROCA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00388','VOLQUETES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00389','YANACOCHA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00390','ACCESORIOS PARA  OFICINA',0,'6060701','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '05','00391','ACCESORIOS SANITARIOS',0,'6060203','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','CT2','CLASE 2',7,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','05','REPORTE POR CENTRO DE COSTOS (FUNCION)',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '31','06','IGV - PRESENTACION SUNAT',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','06','CUENTAS DE CAJA',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','101','CAJA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','102','FONDO FIJO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','103','FONDO ROTATORIO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','104','CUENTAS CORRIENTES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','106','DEPOSITOS A PLAZOS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','108','DEPOSITOS DE AHORROS',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '06','109','FONDOS SUJETOS A RESTRICCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '00','29','DIVISIONES',3,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','001','CLIENTES',11,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '01','002','PROVEEDORES',11,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0001','PRODUCCION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0002','ALMACEN',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0003','VENTAS Y FACTURACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0004','GERENCIA TECNICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0005','ADMINISTRACION',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0006','CONTROL DE CALIDAD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0007','MUESTREO Y APLICACIONES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0008','INVESTIGACION Y DESARROLLO',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0009','ASEGURAMIENTO DE LA CALIDAD',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0010','MARKETING',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0011','VIGILANCIA Y LIMPIEZA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0012','DESPACHO Y TRANSPORTES',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0013','LOGISTICA',0,'','','',.F.)
Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig ) values ( '03','0014','CONTABILIDAD',0,'','','',.F.)
End Transaction
**************************
FUNCTION LOadData_cbdnbalc
**************************
begin transaction
Delete all in cbdnbalc
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','10XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','101101','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','02','12','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','03','14','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','04','16','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','05','20','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','06','21','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','07','23','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','08','24','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','09','26','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','10','38','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','12','31','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','02','40','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','03','41','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','04','42','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','05','46','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','06','47','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','07','49','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','08','50','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','09','55','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','10','57','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','11','58','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','12','56','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','13','59','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','60','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','13','33','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','14','34','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','15','36','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','16','39','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104100','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104100','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104200','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104200','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104200','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104200','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104200','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104300','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104400','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104400','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104500','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104600','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104600','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104700','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','01','104800','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','101101','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','101102','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','101201','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','101202','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','103100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','103100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','103100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104100','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104100','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104100','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104200','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104200','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104200','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104200','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104200','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104300','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104400','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104400','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104500','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104600','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104600','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104700','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','104800','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','105100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','105100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','106100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','106100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','108100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','108100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','01','109100','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02','11','28','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','61','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','62','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','63','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','64','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','65','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','66','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','67','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','68','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','69','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','70','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','71','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','72','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','73','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','74','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','75','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','76','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','77','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','78','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','79','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','80','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','81','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','82','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','83','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','84','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','85','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','86','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','88','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','89','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','90','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','92','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','93','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','94','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','95','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','96','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','97','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','98','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '02A','14','99','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '03','01','10','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '03','02','121','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '03','02','12104','2','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '03','03','123','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '03A','01','104','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','04','141XXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','05','142XXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','10','28XXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','11','31XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','12','31','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','14','58','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','15','59','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','13','50','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','07','461XX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','08','469XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','09','49XXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','01','103XXXX','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','01','104XXXX','1','2')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','101XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','102XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','103XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','104XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','106XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','108XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','01','109XXXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','03','14XXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','06','422XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','07','129','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','07','16XXX','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','08','129XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','13','38','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','02','124XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','02','1210101','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','02','123XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','02','129XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','02','1210102','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','14','31','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','15','1210103','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','16','13','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','17','33','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','18','35','1','1')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','19','39','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','02','40','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','03','41','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','06','46','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','10','47','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','05','122XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','05','127XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','04','423XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01A','04','421XXXX','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','09','24','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','09','20','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','09','26','1','3')
Insert into cbdnbalc(Rubro,Nota,Codcta,Signo,Forma ) values ( '01','09','28','1','3')
End Transaction
**************************
FUNCTION LoadData_CBDNPERN
**************************
begin transaction
Delete all in cbdnpern
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','01','70','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','01','74','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','02','71','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','02','69','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','03','604','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','04','605','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','05','606','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','06','614','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','07','615','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','08','616','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','09','63','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','10','62','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','11','64','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','12','65','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','13','68','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','14','75','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','15','77','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','16','76','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','17','67','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '01','18','66','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','01','70','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','02','90','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','03','94','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','04','92','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','05','77','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','06','76','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','01','70701','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','01','70702','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','02','70703','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','03','75401','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','04','75801','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','05','75901','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','76901','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','14','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','15','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','16','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','17','77','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','18','76','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','14','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','15','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '03','16','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','01','70701','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','01','70702','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','02','70703','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','03','75401','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','04','75801','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','05','75901','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','06','902','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','07','903','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','08','906','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','09','904','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','10','905','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','11','91','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','12','97','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '04','13','66','','1','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','02','91','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','02','69','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','04','93','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','07','66','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','08','96','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '02','09','94','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '05','01','70','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '05','02','70','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '05','03','90','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','01','4010101','','2','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','02','4010101','0032','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','03','4010101','0038','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','04','4010101','0075','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','05','4010101','0076','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','05','','','','')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','06','4010101','0077','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','07','4010101','0078','1','3')
Insert into cbdnpern(Rubro,Nota,Codcta,Codref,Signo,Forma ) values ( '06','08','4010107','','2','1')
End Transaction
**************************
FUNCTION LoadData_CBDTANOS
**************************
begin transaction
Delete all in cbdtanos
Insert into cbdtanos(Periodo,Mescont,Mescaja,Mesctoi,Mescost,Cierre,Coduser,Fchhora ) values ( 2004,8,0,0,0,.T.,'',Ctod([]))
Insert into cbdtanos(Periodo,Mescont,Mescaja,Mesctoi,Mescost,Cierre,Coduser,Fchhora ) values ( 2005,12,0,0,0,.T.,'',Ctod([]))
Insert into cbdtanos(Periodo,Mescont,Mescaja,Mesctoi,Mescost,Cierre,Coduser,Fchhora ) values ( 2006,1,0,0,0,.F.,'',Ctod([]))
End Transaction
**************************
FUNCTION LoadData_CBDTANXO
**************************
begin transaction
Delete all in cbdtanxo
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','110',1,'','','','1','','',1,'CAJA Y BANCOS (ACTIVO)',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','111',2,'','101','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','111',3,'','101XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','112',4,'','102','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','112',5,'','102XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','113',1,'','103','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','113',2,'','103XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','114',1,'','104','','1','N','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','118',3,'','108','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','118',4,'','108XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','119',1,'','109','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','119',2,'','109XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','111',1,'','','','1','','',3,'CUENTAS POR COBRAR COMERCIALES',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','111',1,'','121XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','112',1,'','123XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','111',1,'','','','1','','N',3,'PRESTAMOS A SOCIOS Y AL PERSONAL',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','111',2,'','14XXX','','1','S','N',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','212',2,'','161XX','','1','S','N',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','312',2,'','162XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','313',3,'','163XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','314',4,'','164XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','315',5,'','165XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','318',6,'','168XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','131',1,'','19XXX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','110',2,'','20XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','111',3,'','21XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','112',4,'','22XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','113',5,'','23XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','114',6,'','24XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','115',7,'','25XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','116',8,'','26XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','118',9,'','28XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','119',1,'','29XXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '06','111',1,'','31','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '06','111',2,'','311','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '06','111',3,'','311XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','111',1,'','331','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','112',2,'','332XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '05','111',1,'','38','','1','','',3,'CARGAS DIFERIDAS',2)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '05','111',2,'','38XXX','','1','','',3,'',2)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','121',1,'','40','','2','','',3,'TRIBUTOS POR PAGAR',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','121',2,'','401','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','121',3,'','401XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','132',1,'','403','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','132',2,'','403XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','231',1,'','41','','1','','',3,'REMUNERACIONES POR PAGAR',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '09','121',2,'','42XXXX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','231',1,'','411','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','231',2,'','411XX','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','242',1,'','412','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '11','132',3,'','405XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','242',2,'','412XX','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','111',2,'','331XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','114',2,'','104XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','301',1,'','','','1','','',3,'SOBREGIROS',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','304',2,'','104XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','304',1,'','104','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '03','313',1,'','','','1','','',3,'PRESTAMOS A TERCEROS Y DIVERSOS',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','',1,'','','','1','','',0,'INMUEBLES MAQUINARIA Y EQUIPO',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '09','121',1,'','','','1','','',3,'CUENTAS POR PAGAR COMERCIALES',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '04','110',1,'','','','1','','',3,'INVENTARIOS',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '08','001',1,'','34','','','','',3,'INTANGIBLES',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '08','001',2,'','34XXX','','','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','112',1,'','332','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','113',1,'','333','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','113',2,'','333XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','114',2,'','334XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','115',2,'','335XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','116',2,'','336XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','117',2,'','337XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','118',2,'','338XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','119',2,'','339XX','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','114',1,'','334','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','115',1,'','335','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','116',1,'','336','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','117',1,'','337','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','118',1,'','338','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','119',1,'','339','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','211',0,'','','','1','','',3,'AJUSTADO',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','211',1,'','331','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','211',2,'','33001','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','212',1,'','332','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','212',2,'','33002','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','213',1,'','333','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','213',2,'','33003','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','214',1,'','334','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','214',2,'','33004','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','215',1,'','335','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','215',2,'','33005','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','216',1,'','336','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','216',2,'','33006','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','217',1,'','337','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','217',2,'','33007','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','218',1,'','338','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','218',2,'','33008','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','219',1,'','339','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '07','219',2,'','33009','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','115',1,'','105','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','115',1,'','105XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','116',0,'','106','','1','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','116',2,'','106XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','301',1,'','101','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','301',1,'','101XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','302',1,'','102','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','302',1,'','102XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','303',1,'','103','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','303',2,'','103XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','305',1,'','105','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','305',2,'','105XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','306',1,'','106','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','306',2,'','106XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','308',1,'','108','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','308',2,'','108XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','309',2,'','109','','2','','',2,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '01','309',3,'','109XX','','2','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','214',2,'','422XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','214',1,'','','','1','','',3,'ANTICIPOS OTORGADOS A PROVEEDORES',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','243',1,'','413','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','243',2,'','413XX','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','244',1,'','414','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','244',2,'','414XX','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','245',1,'','415','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '12','245',2,'','415XX','N','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','111',1,'','50','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','111',2,'','50XXX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','112',1,'','56','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','112',2,'','56XXX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','113',1,'','58','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','113',2,'','58XXX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','114',1,'','59','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '16','114',2,'','59XXX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '10','111',1,'','','','','','',0,'OTRAS CUENTAS X PAG.COMERCIALES',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '10','111',1,'','469XX','','','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '14','111',1,'','','','2','','',2,'DEUDAS A LARGO PLAZO',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '14','111',2,'','46102','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '14','111',3,'','46402','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '15','111',1,'','471','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '15','111',2,'','471XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '15','112',3,'','472','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '15','112',4,'','472XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','111',1,'','','','1','','',3,'OTRAS CUENTAS POR PAGAR',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','111',2,'','45','','','','',0,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','111',3,'','45XXX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',1,'','46101','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',2,'','462XX','','2','','',3,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',3,'','463XX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',4,'','465XX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',5,'','467XX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',6,'','468XX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '13','112',7,'','469XX','','2','','',3,'',0)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','115',2,'','129XX','','1','','',1,'',1)
Insert into cbdtanxo(Nroaxo,Refaxo,Itmaxo,Nota,Codcta,Menos,Signo,Rayas,Quieb,Modaxo,Gloaxo,Format ) values ( '02','214',1,'','421XX','','1','','',1,'',1)
End Transaction

**************************
FUNCTION LoadData_CBDTBALC
**************************
begin transaction
Delete all in cbdtbalc
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',3,3,'01','CAJAS Y BANCOS (ANEXO 1)',284737,284737,-388783,-388783,66338,66328,-388783,-388783,-388783,-388783,-388783,1287447,380995,0,100036,258618,-388783,-388783,30571,30566,-388783,-388783,-388783,-388783,-388783,601611,178035,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',4,4,'02','CUENTAS POR COBRAR COMERCIALES (ANEXO 2)',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',5,5,'03','CUENTAS POR COBRAR ACC.Y PERSONAL (ANEXO 3)',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',7,7,'07','CUENTAS POR COBRAR DIVERSAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',8,8,'08','CUENTAS DE COBRANZA DUDOSA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',9,9,'09','EXISTENCIAS (ANEXO 4)',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',10,10,'13','CARGAS DIFERIDAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',11,11,'RS','',322451,312836,3626598,3626598,8358035,8358035,3626598,3626598,3626598,3626598,3626598,7176311,7707677,0,89841,123106,3626598,3626598,3850966,3850966,3626598,3626598,3626598,3626598,3626598,3353417,3601718,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',12,12,'L1','TOTAL  ACTIVO  CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',13,13,'RS','',6279,6279,291676,291676,764021,764021,291676,291676,291676,291676,291676,716254,624187,0,0,-1116,291676,291676,352238,352238,291676,291676,291676,291676,291676,334698,291676,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',14,14,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',15,15,'','A C T I V O   N O    C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',16,16,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',17,17,'14','VALORES',0,0,1634,1634,3496,3496,1634,1634,1634,1634,1634,3496,3496,0,0,0,1634,1634,1611,1611,1634,1634,1634,1634,1634,1634,1634,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',18,18,'15','CUENTAS POR COBRAR COMERCIALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',19,19,'16','ASOCIACIONES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',20,20,'17','INMUEBLES, MAQUINARIAS Y EQUIPOS',1803628,1720785,6191302,6191302,14945529,14945529,6191302,6191302,6191302,6191302,6191302,12465908,13249387,0,731854,781067,6191302,6191302,6885573,6885573,6191302,6191302,6191302,6191302,6191302,5825190,6191302,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',21,21,'18','VALORIZACION ADICIONAL',0,0,0,0,-6302045,-6302045,0,0,0,0,0,-5888541,-5971954,0,0,0,0,0,-2903816,-2903816,0,0,0,0,0,-2751655,-2790633,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',22,22,'19','DEPRECIACION Y AMORTIZACION ACUMULADA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',23,23,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',24,24,'L1','TOTAL ACTIVO NO CORRIENTE  ---->',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',25,25,'RS','',151044,162853,0,0,0,0,0,0,0,0,0,0,0,0,42654,56676,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',38,38,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',39,39,'L3','T O T A L      A C T I V O',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',40,40,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',3,3,'01','SOBREGIROS Y PRESTAMOS BANCARIOS (ANEXO 1)',2265,2265,417416,417416,1928822,1928822,417416,417416,417416,417416,417416,685612,1212990,0,0,823,417416,417416,888676,888676,417416,417416,417416,417416,417416,320379,566818,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',4,4,'02','TRIBUTOS POR PAGAR ( ANEXO 11)',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',5,5,'03','REMUNERACIONES Y PARTICIPACIONES',22144,22144,0,0,0,0,0,0,0,0,0,0,0,0,101025,134588,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',6,6,'04','CUENTAS POR PAGAR COMERCIALES',126452,126452,0,0,0,0,0,0,0,0,0,0,0,0,76880,56836,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',8,8,'06','CUENTAS POR PAGAR DIVERSAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',9,9,'10','BENEFICIOS SOCIALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',11,11,'RS','',1722,1722,436604,436604,1059167,1059167,436604,436604,436604,436604,436604,1026745,934331,0,0,-13,436604,436604,488062,488062,436604,436604,436604,436604,436604,479788,436604,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',12,12,'L1','TOTAL  PASIVO  CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',13,13,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',14,14,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',15,15,'','P A S I V O    N O    C O R R I E N T E',672000,672000,690771,690771,1478250,1478250,690771,690771,690771,690771,690771,1628362,1478250,0,0,300000,690771,690771,681221,681221,690771,690771,690771,690771,690771,760917,690771,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',16,16,'','',0,0,881513,881513,1692843,1692843,881513,881513,881513,881513,881513,1254559,1886438,0,0,0,881513,881513,779960,779960,881513,881513,881513,881513,881513,586243,881513,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',17,17,'11','TRIBUTOS POR PAGAR',70,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',18,18,'12','REMUNERACIONES Y PARTICIPACIONES POR PAGAR',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',19,19,'18','CUENTAS POR PAGAR COMERCIALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',20,20,'19','CUENTAS POR PAGAR DIVERSAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',23,23,'RS','',2046253,1957898,1651981,1651981,3535239,3535239,1651981,1651981,1651981,1651981,1651981,3535239,3535239,0,894081,894081,1651981,1651981,1629142,1629142,1651981,1651981,1651981,1651981,1651981,1651981,1651981,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',24,24,'L1','TOTAL PASIVO NO CORRIENTE',0,0,199,199,426,426,199,199,199,199,199,426,426,0,0,0,199,199,196,196,199,199,199,199,199,199,199,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',25,25,'RS','',-7707,0,0,0,-8475856,-8475856,0,0,0,0,0,-8475856,-8475856,0,0,0,0,0,-3905924,-3905924,0,0,0,0,0,-3960680,-3960680,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',29,29,'','P A T R I M O N I O',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',30,30,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',31,31,'13','CAPITAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',32,32,'14','RESERVA LEGAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',33,33,'15','RESULTADOS ACUMULADOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',34,34,'RE','RESULTADOS DEL EJERCICIO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',35,35,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',39,39,'L4','TOTAL PASIVO Y PATRIMONIO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',40,40,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',1,1,'','A C T I V O    C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',1,1,'','P A S I V O    C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',2,2,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',6,6,'06','ANTICIPOS OTORGADOS A  PROVEEDORES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',21,21,'20','BENEFICIOS SOCIALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',26,26,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',38,38,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',36,36,'L1','TOTAL  PATRIMONIO   ---->',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',37,37,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',3,4,'01','* CAJA Y BANCOS',0,0,56220,0,68095,110059,90314,183526,0,448699,448699,0,-177519,0,0,0,0,0,0,0,4858,88304,0,185579,185579,0,102,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',6,12,'04','* CTAS X COBRAR DIVERSAS',0,0,680194,0,237980,173900,182457,241433,0,251202,251202,0,-67641,0,0,0,0,0,0,0,3860,31368,0,35768,35768,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',7,13,'05','* MERCADERIAS',0,0,96679,0,60229,57762,58336,53858,0,58734,58734,0,-48565,0,0,0,0,0,0,0,2260,224,0,5101,5101,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',8,14,'06','* PRODUCTOS TERMINADOS',0,0,1573606,0,513221,569741,441887,461265,335312,461265,461265,0,16326,0,0,0,0,0,0,0,-56824,-48016,335312,-48016,-48016,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',9,15,'07','* PRODUCTOS EN PROCESO',0,0,333116,0,162234,136435,151593,145271,0,145271,145271,0,-8119,0,0,0,0,0,0,0,6737,3863,0,3863,3863,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',10,16,'08','* MATERIAS PRIMAS Y AUXILIARES',0,0,1437859,0,663811,611559,581154,475005,0,724784,833400,0,-168918,0,0,0,0,0,0,0,22122,12342,0,262121,370737,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',14,17,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',15,18,'L1','TOTAL ACTIVO CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',16,19,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',18,20,'12','* VALORES',0,0,0,0,0,0,0,0,22068,0,0,0,0,0,0,0,0,0,0,0,0,0,22068,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',19,21,'13','* INMUEBLE MAQUINARIA Y EQUIPOS',0,0,5635413,0,2570053,2586623,2595328,2604653,20444,2621609,2634607,0,106564,0,0,0,0,0,0,0,7902,12299,20444,28513,41511,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',20,22,'14','* INTANGIBLES',0,0,0,0,0,0,0,0,123541,0,1342,0,0,0,0,0,0,0,0,0,0,0,123541,0,1342,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',21,23,'15','* INMUEBLES MAQUINARIA Y EQUIPO LEY PROMOCION',0,0,1784019,0,892009,892009,892009,892009,0,892009,892009,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',22,24,'16','* DEPRECIACION Y AMORTIZACION',0,0,-5012919,0,-2411353,-2424241,-2437128,-2450016,0,-2462904,-2462904,0,-42816,0,0,0,0,0,0,0,-5728,-11586,0,-18030,-18030,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',23,25,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',24,26,'L1','TOTAL ACTIVO NO CORRIENTE',0,0,3626598,3626598,3626598,3626598,3626598,3626598,3626598,3626598,3626598,0,132268,0,0,0,3626598,3626598,3626598,3626598,3626598,3626598,3626598,3626598,3626598,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',36,45,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',3,3,'01','* SOBREGIRO BANCARIO',0,0,538746,0,316332,401822,539374,346393,417416,469820,469820,0,177519,0,0,0,0,0,0,0,68526,32566,417416,65617,65617,0,-102,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',4,4,'02','* TRIBUTOS POR PAGAR',0,0,114543,0,9982,41671,19807,81703,0,165116,129436,0,-16169,0,0,0,0,0,0,0,-1339,12606,0,95869,60188,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',5,5,'03','* REMUNERACIONES Y PARTICIPACIONES POR PAGAR',0,0,306208,0,179055,168896,167549,143311,0,209855,209855,0,-38623,0,0,0,0,0,0,0,-1548,-16952,0,47087,47087,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',6,6,'04','* PROVEEDORES',0,0,2925522,0,1530716,1090095,1130434,1166590,0,1883677,2122796,0,342344,0,0,0,0,0,0,0,102623,313390,0,1105579,1344697,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',7,7,'05','* CUENTAS POR PAGAR',0,0,709726,0,158579,180073,162792,485618,1116009,483904,483904,0,-12351,0,0,0,0,0,0,0,-8160,138105,1116009,143295,143295,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',8,8,'','',0,0,100542,100542,100542,100542,100542,100542,100542,100542,100542,0,0,0,0,0,100542,100542,100542,100542,100542,100542,100542,100542,100542,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',9,9,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',12,12,'','',45987,3202,0,0,0,0,0,0,0,0,0,0,0,0,21192,1472,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',13,13,'','',45712,13657,100903,100903,100903,100903,100903,100903,100903,100903,100903,0,-38623,0,21065,6233,100903,100903,100903,100903,100903,100903,100903,100903,100903,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',14,14,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',16,16,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',18,17,'06','* BENEFICIOS SOCIALES',0,0,302567,0,160465,163368,163560,164211,436604,171570,171570,0,77630,0,0,0,0,0,0,0,7,303,436604,3984,3984,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',19,18,'07','* GANANCIAS DIFERIDAS',0,0,0,0,0,0,0,0,712414,0,0,0,0,0,0,0,0,0,0,0,0,0,712414,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',20,19,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',24,20,'L1','TOTAL DEL PASIVO NO CORRIENTE ---->',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',27,23,'08','* CAPITAL SOCIAL',0,0,2067552,0,917164,917164,917164,917164,690771,917164,917164,0,0,0,0,0,0,0,0,0,0,0,690771,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',28,24,'09','* ACCIONARIADO LABORAL',0,0,877784,0,389384,389384,389384,389384,881513,389384,389384,0,0,0,0,0,0,0,0,0,0,0,881513,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',29,25,'10','* EXCEDENTE DE REVALUACION',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',30,26,'11','* RESERVAS',0,0,1664,0,738,738,738,738,0,738,738,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',31,27,'12','* CAPITAL ADICIONAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',32,28,'13','* RESULTADOS ACUMULADOS',0,0,164835,0,148787,148787,148787,148787,0,148787,148787,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',33,29,'RE','* RESULTADOS DEL EJERCICIO',0,0,190955,0,16318,32041,-7501,-23423,0,630030,570413,0,0,0,0,0,0,0,0,0,182429,135489,0,830775,771158,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',34,38,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',35,39,'L1','TOTAL PATRIMONIO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',36,40,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',37,41,'TG','TOTAL PASIVO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',1,1,'','A C T I V O    C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',2,2,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',1,1,'','P A S I V O    C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',2,2,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',5,0,'03','* CTAS X COB ACC.SOCIOS Y PERSONAL',0,0,130176,0,64537,64679,70996,71184,0,71461,71461,0,-3807,0,0,0,0,0,0,0,2889,2974,0,2847,2847,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',11,0,'09','* SUMINISTROS DIVERSOS',0,0,80887,0,40170,40438,40962,42659,0,65142,86007,0,-21520,0,0,0,0,0,0,0,2656,6138,0,28620,49486,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',12,0,'10','* CARGAS DIFERIDAS',0,0,82435,0,43577,43421,44571,50231,0,28741,28741,0,6804,0,0,0,0,0,0,0,720,3293,0,-18197,-18197,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',4,0,'02','* CLIENTES',0,0,1176904,0,820732,562197,809608,758854,0,1831548,1831548,0,-65857,0,0,0,0,0,0,0,358698,335629,0,1602792,1602792,0,-102,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',17,0,'','A C T I V O   N O   C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',37,0,'TG','T O T A L   A C T I V O',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',38,0,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',10,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',11,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',25,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',26,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',27,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',28,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',29,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',30,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',31,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',13,0,'11','* EXISTENCIAS POR RECIBIR',0,0,219322,0,102223,109457,110002,290544,0,513030,513030,0,0,0,0,0,0,0,0,0,545,181087,0,403573,403573,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',15,0,'L1','TOTAL PASIVO CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',17,0,'','P A S I V O   N O   C O R R I E N T E',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',21,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',22,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',38,0,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',26,0,'','P A T R I M O N I O',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',25,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02A',23,0,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',32,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',33,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',34,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '02',35,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',2,2,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',1,0,'','ACTIVO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',2,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',3,0,'','ACTIVO CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',4,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',5,0,'01','CAJA BANCOS  (ANEXO 1)',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',6,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',7,0,'R1','CLIENTES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',8,0,'02','FACTURAS POR COBRAR',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',9,0,'03','LETRAS POR COBRAR',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',10,0,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',11,0,'L1','TOTAL CLIENTES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',12,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',13,0,'R1','EXISTENCIAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',16,0,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',17,0,'L1','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',14,0,'04','MATERIA PRIMA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',15,0,'05','MATERIALES AUXILIARES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',18,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',19,0,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',20,0,'L2','TOTAL ACTIVO  CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',21,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',22,0,'R1','ACTIVO NO CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',23,0,'06','INM.MAQ. Y EQUIP.',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',24,0,'07','DEPRECIACION ACUMULADA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',25,0,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',26,0,'L1','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',27,0,'08','INTANGIBLES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',28,0,'L2','TOTAL ACTIVO NO CORRIENTE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',29,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',30,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',31,0,'RD','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03',32,0,'TG','TOTAL ACTIVOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03A',1,0,'','PASIVO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '03A',0,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',7,7,'05','ANTICIPOS RECIBIDOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',10,10,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',22,22,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',26,26,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',27,27,'L2','TOTAL PASIVO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01A',28,28,'RS','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',27,27,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',28,28,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',29,29,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',30,30,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',31,31,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',32,32,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',33,33,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',34,34,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',35,35,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',36,36,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtbalc(Rubro,Nroitm,Chkitm,Nota,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13 ) values ( '01',37,37,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
End Transaction
**************************
FUNCTION LoadData_CBDTCNFG
**************************
begin transaction
Delete all in cbdtcnfg
Insert into cbdtcnfg(Codcfg,Codope,Glocfg,Codcta1,Codcta2,Codcta3,Codcta4,Codaux1,Codaux2,Codaux3,Codaux4,Dif_me,Dif_mn ) values ( '01','029','AJUSTE POR DIFERENCIA DE CAMBIO','97761','77601','7760011','6760011','','','','',0,0)
End Transaction

**************************
FUNCTION LoadData_CBDTPERN
**************************
begin transaction
Delete all in cbdtpern
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',1,1,'01','(70-74)','VENTAS NETAS DE PRODUCTOS',0,0,94142,89548,0,0,0,0,0,0,0,0,0,0,0,0,28869,27467,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',6,4,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',7,7,'','','CONSUMO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',15,16,'09','63','SERVICIOS PRESTADOS POR TERCEROS',0,-8818,-20641,-20697,0,0,0,0,0,0,0,0,0,0,0,-2703,-6335,-6347,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',17,17,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',18,18,'L2','','VALOR AGREGADO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',19,19,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',20,20,'10','62','CARGAS DE PERSONAL',0,-42374,-37,-163,0,0,0,0,0,0,0,0,0,0,0,-13002,-11,-50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',21,21,'11','64','TRIBUTOS',0,0,-260,0,0,0,0,0,0,0,0,0,0,0,0,0,-80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',22,22,'RS','','',123541,0,0,0,0,0,0,0,0,0,0,0,0,0,123541,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',23,23,'L3','','EXCEDENTE BRUTO DE EXPLOTACION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',24,24,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',25,25,'12','65','CARGAS DIVERSAS DE GESTION',0,-850,-2497,-4196,0,0,0,0,0,0,0,0,0,0,0,-260,-766,-1287,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',26,26,'13','68','PROVISIONES DE EJERCICIO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',27,27,'14','75','INGRESOS DIVERSOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',28,28,'RS','','',291676,0,0,0,0,0,0,0,0,0,0,0,0,0,291676,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',29,29,'L4','','RESULTADO DE EXPLOTACION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',30,30,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',31,31,'15','77','INGRESOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',32,32,'16','76','INGRESOS EXCEPCIONALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',33,33,'17','67','CARGAS FINANCIERAS',0,-768,-1499,-856,0,0,0,0,0,0,0,0,0,0,0,-236,-460,-262,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',34,34,'18','66','CARGAS EXCEPCIONALES',0,-66,-264,0,0,0,0,0,0,0,0,0,0,0,0,-20,-81,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',35,37,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',36,38,'L5','','RESULTADO ANTES DE PARTIC. E IMPUE.',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',37,39,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',38,40,'','','DISTRIBUCION LEGAL DE LA RENTA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',39,42,'','','IMPUESTO A LA RENTA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',40,43,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',42,44,'TG','','RESULTADO DEL PERIODO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',43,45,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',2,0,'02','(71-69)','COSTO DE VENTAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',5,0,'L1','','UTILIDAD BRUTA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',3,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',4,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',41,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',1,1,'01','','VENTAS',0,483161,0,0,0,0,0,0,0,0,0,0,0,0,0,147693,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',5,5,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',9,9,'04','','GASTOS DE ADMINISTRACION',0,-8159,0,0,0,0,0,0,0,0,0,0,0,0,0,-2504,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',11,11,'RS','','',0,-13663,-33417,-119528,532053,103737,-157358,939192,-236604,-279321,-293808,0,0,0,0,-6385,-15615,-55854,248623,48475,-73532,438875,-110562,-130524,-137293,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',12,12,'L1','','GASTOS ADMINISTRATIVOS',0,1958,-419,3707,46824,6717,113121,72421,59193,-50873,-45666,111695,0,0,0,915,-196,1732,21881,3139,52860,33842,27660,-23772,-21339,52194,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',13,13,'RS','','',0,1906299,2118561,1907167,1432476,864886,1338015,1073809,1994860,24839,157367,140983,532628,0,0,890794,989982,891199,669381,404152,625241,501780,932178,11607,73536,65880,248891,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',14,14,'L2','','RESULTADO DE OPERACION',0,-426617,-510401,-672572,-571929,-639325,-555672,-581672,-591093,-636916,-602946,-663284,-39618,0,0,-199354,-238505,-314286,-267257,-298750,-259660,-271809,-276212,-297624,-281750,-309946,-18513,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',15,15,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',16,16,'','','OTROS INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',17,17,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',18,18,'05','','INGRESOS FINANCIEROS',0,30957,0,0,0,0,0,0,0,0,0,0,0,0,0,9459,0,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',19,19,'06','','INGRESOS EXCEPCIONALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',22,22,'','','',0,-53175,-38827,-87073,-184408,-218286,-397050,-239207,-171642,0,-147091,20126,-87583,0,0,-24848,-18143,-40688,-86172,-102003,-185537,-111779,-80206,0,-68734,9405,-40927,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',24,24,'07','','GASTOS EXCEPCIONALES',0,-13699,0,0,0,0,0,0,0,0,0,0,0,0,0,-4181,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',25,25,'08','','GASTOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',27,27,'RS','','',291676,291676,291676,291676,291676,291676,291676,291676,291676,291676,291676,716254,0,0,291676,291676,291676,291676,291676,291676,291676,291676,291676,291676,291676,334698,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',28,28,'L3','','UTILIDAD DEL EJERCICIO',0,-426617,-510401,-672572,-571929,-639325,-555672,-581672,-591093,0,0,0,0,0,0,-199354,-238505,-314286,-267257,-298750,-259660,-271809,-276212,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',2,2,'02','','COSTO DE VENTAS',0,-28998,0,0,0,0,0,0,0,0,0,0,0,0,0,-8871,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',4,4,'L1','','UTILIDAD BRUTA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',3,3,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',26,26,'09','','GASTOS DE ASESORIA',0,-27666,0,0,0,0,0,0,0,0,0,0,0,0,0,-8470,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',0,0,'','','INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',5,0,'01','','Ingresos por Valorizaciones',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',1,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',10,0,'02','','Alquileres de Equipo',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',15,0,'03','','Alquileres Diversos',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',20,0,'04','','Honorarios',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',25,0,'05','','Otros Ingresos',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',30,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',31,0,'L1','','TOTAL INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',35,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',40,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',45,0,'','','COSTOS VARIABLES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',50,0,'06','902','MATERIALES DE CONSTRUCCION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',55,0,'07','903','MANO DE OBRA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',60,0,'08','906','COMBUSTIBLES, LUBRICANTES, REP.ETC',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',65,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',70,0,'L1','','TOTAL COSTOS VARIABLES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',75,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',80,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',85,0,'L2','','MARGEN DE CONTRIBUCCION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',90,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',95,0,'','','COSTOS FIJOS',0,557890,617425,667898,953719,797414,684375,1305266,819425,682882,1054460,0,0,0,0,255061,278059,296468,426449,353967,305748,584156,366190,303773,466062,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',100,0,'09','904','GASTOS GENERALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',110,0,'11','91','GASTOS ADMINISTRATIVOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',115,0,'12','97','GASTOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',105,0,'10','905','TRIBUTOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',120,0,'13','66','GASTOS EXTRAORDINARIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',125,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',130,0,'L2','','TOTAL COSTOS FIJOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',135,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',140,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',46,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',82,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',145,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',150,0,'L3','','UTILIDAD BRUTA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',150,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',155,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',160,0,'','','INGRESOS Y GASTOS OPERACIONALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',162,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',164,0,'','91','GASTOS ADMINISTRATIVOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',166,0,'','97','GASTOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',170,0,'','66','GASTOS EXTRAORDINARIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',175,0,'','77','INGRESOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',180,0,'','76','INGRESOS EXTRAORDINARIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',182,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',185,0,'L3','','SUB TOTAL OPERACIONAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',190,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',195,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',200,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',205,0,'L4','','UTILIDAD OPERACIONAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '03',210,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',0,0,'','','INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',1,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',5,0,'01','70701-70702','INGRESOS POR VALORIZACIONES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',10,0,'02','70703','ALQUILERES DE EQUIPO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',15,0,'03','75401','ALQUILERES DIVERSOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',20,0,'04','75801','HONORARIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',25,0,'05','75901','OTROS INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',25,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',25,0,'L1','','TOTAL INGRESOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',25,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',30,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',35,0,'','','COSTOS VARIABLES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',40,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',45,0,'06','902','MATERIALES DE CONSTRUCCION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',50,0,'07','903','MANO DE OBRA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',55,0,'08','906','COMBUSTIBLES, LUBRICANTES, REP. ETC',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',60,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',65,0,'L1','','TOTAL COSTOS VARIABLES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',70,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',71,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',75,0,'L2','','MARGEN DE CONTRIBUCCION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',72,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',80,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',82,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',85,0,'','','COSTOS FIJOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',90,0,'09','904','GASTOS GENERALES',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',95,0,'10','905','TRIBUTOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',100,0,'11','91','GASTOS ADMINISTRATIVOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',105,0,'12','97','GASTOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',110,0,'13','66','GASTOS EXTRAORDINARIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',115,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',120,0,'L2','','TOTAL COSTOS FIJOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',122,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',125,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',130,0,'TG','RE','UTILIDAD BRUTA',0,29079454,28677054,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '04',132,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '01',11,0,'06','97','GASTOS FINANCIEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',20,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '02',21,0,'','','OTROS GASTOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',1,0,'01','','VENTAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',3,0,'02','','70 VENTAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',5,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',7,0,'03','','COSTO DE CONSTRUCCION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',9,0,'04','','60 COMPRAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',11,0,'05','','62 CARGAS DE PERSONAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',13,0,'06','','63 SERVICIOS PRESTADOS POR TERCEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',15,0,'07','','64 TRIBUTOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',17,0,'08','','65 CARGAS DIVERSAS DE GESTION',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',19,0,'09','','68 PROVISIONES DEL EJERCICIO',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',21,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',23,0,'10','','COSTO DE TALLER',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',25,0,'11','','60 COMPRAS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',27,0,'12','','62 CARGAS DE PERSONAL',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '05',29,0,'13','','63 SERVICIOS PRESTADOS POR TERCEROS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',0,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',2,0,'','','OBRA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',4,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',6,0,'01','','GASTOS GENERALES',2763701,176995,-4094,28332,158653,69751,9296,82023,0,0,0,0,0,0,841822,54191,-1289,8689,48605,21382,2881,22125,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',8,0,'02','','TALLER',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',10,0,'03','','RELIMA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',12,0,'04','','ALTO CHICAMA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',14,0,'05','','CHICLAYO CHONGOYAPE',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',16,0,'06','','MINERA BARRICK',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',18,0,'07','','CARRETERA INTER OCEANICA',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',20,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',22,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',24,0,'L1','','TOTAL IGV',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',26,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',28,0,'08','','CERTIFICADOS DE RETENCION',0,0,0,0,-13251,0,0,0,0,0,0,0,0,0,0,0,0,0,-4102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',30,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',32,0,'RS','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',34,0,'L2','','NETO A PAGAR',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',36,0,'','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
Insert into cbdtpern(Rubro,Nroitm,Chkitm,Nota,Glocta,Glosa,Mess00,Mess01,Mess02,Mess03,Mess04,Mess05,Mess06,Mess07,Mess08,Mess09,Mess10,Mess11,Mess12,Mess13,Mesd00,Mesd01,Mesd02,Mesd03,Mesd04,Mesd05,Mesd06,Mesd07,Mesd08,Mesd09,Mesd10,Mesd11,Mesd12,Mesd13,Presol,Predol,Portip,Porama,Pormes,Poracm ) values ( '06',38,0,'RD','','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
End Transaction
**************************
FUNCTION LoadData_cbdcnfg0
**************************
begin transaction
Delete all in cbdcnfg0
Insert into cbdcnfg0(Tipo_empre,Tipo_conso,Max_auxil,C_costo,Masc_corre,Ndig_corre,Ndig_term1,Ndig_term2,Ndig_term3,Ndig_term4,Pos_term1,Pos_term2,Pos_term3,Pos_term4,Dir_sist1,Dir_sist2,Dir_sist3,G_an1cta,G_cc1cta,Cc1cta,G_an2cta,G_cc2cta,Cc2cta,Mon_nac,Mon_ext,Mon_ext2,Genaut_costos,Genaut_existen ) values ( 1,1,2,3,'XX-XX-XXXX',8,2,2,4,0,0,0,0,0,'base','belcsoft','aplica','2. Auxiliar','5. Valor Fijo','79901','2. Auxiliar','5. Valor Fijo','','S/.','US$','','"603","605","606","608","609","62","63","64","65","67","68"','"602","604"')
End Transaction
**************************
FUNCTION LoadData_CJATPROV
**************************
begin transaction
Delete all in cjatprov
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'CANF','A','42101,42102','005','','CANCELACION DE FACTURAS','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'FACT','C','12101,12102','004','','CANCELACION DE FACTURAS CLIENTES','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'CAPE','A','1210011,1210012','','','CANCELAC DE FACTURAS APERTURA','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'REND','A','3840101','002','','RENDICION DE CUENTAS','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'SEGU','A','4210101,4210102','005','','CANCELACION SEGUROS','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( 'TEMP','A','4210101,4210102','006','','TEMPORAL FACTURAS','')
Insert into cjatprov(Tpodoc,Tipo,Codcta,Codope,Girado,Notast,Tipreg ) values ( '02','A','4210101,4210102','007','','CANCELACION DE RECIBOS','')
End Transaction
***************************
FUNCTION LoadData_DISTRITOS
***************************
begin transaction
Delete all in distritos
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '01','Cercado de Lima','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '02','Ancón','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '03','Ate','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '04','Barranco','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '05','Breña','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '06','Carabayllo','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '07','Comas','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '08','Chaclacayo','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '09','Chorrillos','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '10','El Agustino','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '11','Jesús María','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '12','La Molina','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '13','La Victoria','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '14','Lince','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '15','Lurigancho (Chosica)','03','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '16','Lurín','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '17','Magdalena del Mar','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '18','Miraflores','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '19','Pachacamac','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '20','Pucusana','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '21','Pueblo Libre','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '22','Puente Piedra','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '23','Punta Negra','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '24','Punta Hermosa','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '25','Rímac','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '26','San Bartolo','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '27','San Isidro','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '28','Independencia','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '29','San Juan de Miraflores','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '30','San Luis','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '31','San Martin de Porres','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '32','San Miguel','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '33','Santiago de Surco','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '34','Surquillo','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '35','Villa Maria del Triunfo','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '36','San Juan de Lurigancho','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '37','Santa María del Mar','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '38','Santa Rosa','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '39','Los Olivos','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '40','Cieneguilla','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '41','San Borja','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '42','Villa el Salvador','01','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '1','Callao','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '2','Bellavista','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '3','Camen de la Legua','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '4','La Perla','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '5','La Punta','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '6','Ventanilla','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '70','Otros','02','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '50','Huacho','04','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '51','Sayan','04','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '52','Huaura','04','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '61','UCHIZA','05','','')
Insert into distritos(Coddist,Desdist,Codzona,Coduser,Fchhora ) values ( '62','PACASMAYO','06','','')
End Transaction

************************
FUNCTION LoadData_PAISES
************************
begin transaction
Delete all in paises
Insert into paises(Codpais,Despais,Coduser,Fchhora ) values ( '01','Perú','',Ctod([]))
Insert into paises(Codpais,Despais,Coduser,Fchhora ) values ( '02','Estados Unidos','',Ctod([]))
End Transaction

***********************
FUNCTION LoadData_SEDES
***********************
begin transaction
Delete all in sedes
Insert into sedes(Codigo,Nombre,Activa,Logo,Central,Ts_def,Coduser,Fchhora ) values ( '001','SEDE 1','X','',.T.,'','',Ctod([]))
End Transaction

**************************
FUNCTION LoadData_ALMTGSIS
**************************
begin transaction
Delete all in almtgsis
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','UD','Unidades de  medida',3,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GL','Galón',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','KGS','Kilo',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','UND','Unidad',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LT','Litro',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GR','Gramo',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','CM','Codificación del Material',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CM','01','Familia',3,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CM','02','Sub-Familia',5,.F.,'','','',.T.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CM','03','Código Final del Material',20,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','AR','Areas',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'AR','01','ALMACEN CENTRAL',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MTS','Metros',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MIL','Millares',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PZA','Pieza',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','TN','Toneladas',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PQT','Paquetes',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','DOC','Docena',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PLGO','Pliego',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PAR','Pares',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CTO','Ciento',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LB','Libra',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','JGO','Juego',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','TR','Tipo de Referencia',4,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','FV','FV- Facturas Proveedor',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','BV','BV  - Boleta de Venta Proveedor',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','O_T','O_T- Orden de Trabajo',0,.F.,'P','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CJA','Caja',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','FT','Pie',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','FCO','Frasco',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','TM','Tipo de Material',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','10','Insumo - Mat. Prima',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','11','Insumo - Por Transformación',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','20','Producto Terminado',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','30','Producto Intermedio',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','40','Suministro',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CJ','Cojin',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PUN','Puñado',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'PV','001','Tienda 1',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'PV','002','Tienda 2',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'PV','003','Tienda 3',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','PV','Puntos de Venta',3,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','CR','Clase de Requisicion',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CR','01','Requerimiento a logistica',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CR','02','Requerimientos a Centro de servicios',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'CR','03','Requerimientos a almacen',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'LE','001','ALMACEN CENTRAL',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','LE','Lugares de entrega',3,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','PEDI','PEDI- Pedido del cliente',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','G/R','G/R - Guia de remisión clientes',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','FACT','FACT - Factura del cliente',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TR','','No lleva referencia a otro transacc',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','TT','Tipo de transaccion',1,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TT','I','Ingresos',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TT','S','Salidas',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TT','T','Transferencias',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TM','50','Mercaderias',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/E','CONTRA ENTREGA',1,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CONT','CONTADO 10 DIAS',1,.F.,'','','',.F.,'',Ctod([]),10)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/60','LETRA A 60 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/75','LETRA A 75 DIAS',2,.F.,'','','',.F.,'',Ctod([]),75)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/90','LETRA A 90 DIAS',2,.F.,'','','',.F.,'',Ctod([]),90)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/45','LETRA A 45 DIAS',2,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/7','CHEQUE A 7 DIAS',2,.F.,'','','',.F.,'',Ctod([]),7)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/35','LETRA A 35 DIAS',2,.F.,'','','',.F.,'',Ctod([]),35)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/45 Y 60','LETRA 45,60 DIAS',1,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/120','LETRA 120 DIAS',2,.F.,'','','',.F.,'',Ctod([]),120)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/35','CHEQUE A 35 DIAS',2,.F.,'','','',.F.,'',Ctod([]),35)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/15','CHEQUE 15 DIAS',2,.F.,'','','',.F.,'',Ctod([]),15)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/60 Y 90','LETRA 60 Y 90 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','LETRAS','LETRAS',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/30','LETRA A 30 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/45','CHEQUE A 45 DIAS',2,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/57','LETRA 57 DIAS',2,.F.,'','','',.F.,'',Ctod([]),57)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/20','CHEQUE 20 DIAS',2,.F.,'','','',.F.,'',Ctod([]),20)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/40','LETRA A 40 DIAS',2,.F.,'','','',.F.,'',Ctod([]),40)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/39','LETRAS 39 DIAS',2,.F.,'','','',.F.,'',Ctod([]),39)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/47','LETRA 47 DIAS',2,.F.,'','','',.F.,'',Ctod([]),47)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/30','CHEQUE 30 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/27','LETRA 27 DIAS',2,.F.,'','','',.F.,'',Ctod([]),27)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/25','LETRA 25 DIAS',2,.F.,'','','',.F.,'',Ctod([]),25)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/20','LETRA 20 DIAS',2,.F.,'','','',.F.,'',Ctod([]),20)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/30,45','LETRAS 30,45 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/105','LETRA 105 DIAS',2,.F.,'','','',.F.,'',Ctod([]),105)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/41','LETRA 41 DIAS',2,.F.,'','','',.F.,'',Ctod([]),41)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/28','LETRA 28 DIAS',2,.F.,'','','',.F.,'',Ctod([]),28)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/60,75','LETRAS 60,75 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/45/60/75','LETRAS 45,60,75',1,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/3  DIAS','CREDITO 3 DIAS',2,.F.,'','','',.F.,'',Ctod([]),3)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/60','CHEQUE A 60 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/10 DIAS','CREDITO 10 DIAS',2,.F.,'','','',.F.,'',Ctod([]),10)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/10','CHEQUE 10 DIAS',2,.F.,'','','',.F.,'',Ctod([]),10)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','ADELANTADO','ADELANTADO',1,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/45,60,90','LETRA 45, 60, 90',2,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/5 DIAS','CHEQUE A 5 DIAS',2,.F.,'','','',.F.,'',Ctod([]),5)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/30,60','LETRA 30,60 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CONT.50%CH','50% CONT.50% CH',2,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/90,120','LETRAS 90, 120 DIAS',2,.F.,'','','',.F.,'',Ctod([]),90)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L75,90,105','LETRAS 75,90,105',2,.F.,'','','',.F.,'',Ctod([]),75)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/4 DIAS','CREDITO 4 DIAS',2,.F.,'','','',.F.,'',Ctod([]),4)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','50%C.F/20','50%CONT. 50% F/20 DIAS',2,.F.,'','','',.F.,'',Ctod([]),20)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/3 DIAS','CHEQUE 3  DIAS',2,.F.,'','','',.F.,'',Ctod([]),3)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/30,45','CH/30 Y 45 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L60,90,105','LETRA 60,90,105',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/15,30','CH/15  Y 30 DIAS',2,.F.,'','','',.F.,'',Ctod([]),15)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/18','CHEQUE  18  DIAS',2,.F.,'','','',.F.,'',Ctod([]),18)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/21,30','CHEQUE 21 Y 30 DIAS',2,.F.,'','','',.F.,'',Ctod([]),21)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/2 DIAS','CHEQUE 2  DIAS',2,.F.,'','','',.F.,'',Ctod([]),2)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/100 DIAS','LETRA 100  DIAS',2,.F.,'','','',.F.,'',Ctod([]),100)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/60,75,90','LETRA 60,75,90',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/2 DIAS','CREDITO 2 DIAS',2,.F.,'','','',.F.,'',Ctod([]),2)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/20 DIAS','CREDITO 20 DIAS',2,.F.,'','','',.F.,'',Ctod([]),20)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/21 DIAS','CREDITO 21 DIAS',2,.F.,'','','',.F.,'',Ctod([]),21)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/45 DIAS','CREDITO 45 DIAS',2,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/15 DIAS','CREDITO 15 DIAS',2,.F.,'','','',.F.,'',Ctod([]),15)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/5 DIAS','CREDITO 5 DIAS',2,.F.,'','','',.F.,'',Ctod([]),5)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/60 DIAS','CREDITO 60 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/7 DIAS','CREDITO 7 DIAS',2,.F.,'','','',.F.,'',Ctod([]),7)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/30 DIAS','CREDITO 30 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/8 DIAS','CREDITO 8  DIAS',2,.F.,'','','',.F.,'',Ctod([]),8)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/85 DIAS','LETRA  85  DIAS',2,.F.,'','','',.F.,'',Ctod([]),85)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/6 DIAS','CREDITO  6 DIAS',2,.F.,'','','',.F.,'',Ctod([]),6)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','C/90 DIAS','CREDITO 90 DIAS',2,.F.,'','','',.F.,'',Ctod([]),90)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/79','LETRA 79 DIAS',2,.F.,'','','',.F.,'',Ctod([]),79)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/83 DIAS','LETRA 83  DIAS',2,.F.,'','','',.F.,'',Ctod([]),83)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/80 DIAS','LETRA 80 DIAS',2,.F.,'','','',.F.,'',Ctod([]),80)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/77 DIAS','LETRA 77 DIAS',2,.F.,'','','',.F.,'',Ctod([]),77)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/76 DIAS','LETRA 76  DIAS',2,.F.,'','','',.F.,'',Ctod([]),76)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','LETRA','LETRA',0,.F.,'','','',.F.,'',Ctod([]),10)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/45,','CH/ 45  Y 60 DIAS',0,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/48 DIAS','LETRA 48  DIAS',2,.F.,'','','',.F.,'',Ctod([]),48)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH45,60,75','CH/45,60,75',2,.F.,'','','',.F.,'',Ctod([]),45)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/78  DIAS','LETRA 78  DIAS',2,.F.,'','','',.F.,'',Ctod([]),78)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/60,90 D.','LETRA 60,90 DIAS',2,.F.,'','','',.F.,'',Ctod([]),60)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/30,45,60','L/30,45,60 DIAS',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH30,45,60','CH/30,45,60',2,.F.,'','','',.F.,'',Ctod([]),30)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/70 DIAS','LETRA 70 DIAS',2,.F.,'','','',.F.,'',Ctod([]),70)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','CH/23 DIA','CH/23  DIAS',2,.F.,'','','',.F.,'',Ctod([]),23)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/81 DIAS','LETRA 81 DIAS',2,.F.,'','','',.F.,'',Ctod([]),81)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'FP','L/82 DIAS','LETRA 82 DIAS',2,.F.,'','','',.F.,'',Ctod([]),82)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','FP','FORMAS DE PAGO',10,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( '00','TP','TIPO DE PRECIO',1,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TP','1','KILO',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TP','2','ENVASE',0,.F.,'','','',.F.,'',Ctod([]),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'TP','3','GERENCIA',0,.F.,'','','',.F.,'',Ctod([]),0)
End Transaction

**************************
FUNCTION LoadData_VTATDOCM
**************************
begin transaction
Delete all in vtatdocm
Insert into vtatdocm(Sede,Ptovta,Coddoc,Serie,Nrodoc,Tpodocsn,Tpodoc,Intest,Subalm,Tipmov,Codmov,Campo_id,Ant_mes,Ant_serie,Ant_ptovta,Corr_u,Var_suf_id,Eval_valor_pk,T_destino,Len_id ) values ( '001','001','FACT','003',30009678,'01','',.T.,'001','S','Y01','nrodoc',0,1,0,.T.,'','','GDOC',10)
Insert into vtatdocm(Sede,Ptovta,Coddoc,Serie,Nrodoc,Tpodocsn,Tpodoc,Intest,Subalm,Tipmov,Codmov,Campo_id,Ant_mes,Ant_serie,Ant_ptovta,Corr_u,Var_suf_id,Eval_valor_pk,T_destino,Len_id ) values ( '001','001','G/R','001',10004652,'09','',.F.,'001','S','Y01','nrodoc',0,1,0,.T.,'','','GUIA',10)
End Transaction

***********************
FUNCTION LoadData_ZONAS
***********************
begin transaction
Delete all in zonas
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '01','Lima',.F.,'',Ctod([]))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '02','Callao',.F.,'',Ctod([]))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '03','Chosica',.F.,'',Ctod([]))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '04','Huaura',.F.,'',Ctod([]))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '05','SAN MARTIN',.T.,'',Ctod([]))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '06','LA LIBERTAD',.T.,'',Ctod([]))
End Transaction

*************************
FUNCTION LoadData_PLNMTABL
**************************
begin transaction
Delete all in plnmtabl
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','01','CODIGOS DE PLANILLA',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','02','SECCIONES (C. COSTO)',6,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','03','CENTROS DE COSTO',3,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','04','CARGOS',6,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','05','PROGRAMAS',4,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','06','CANAL DE PAGO',5,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','07','GRADO DE INSTRUCCION',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','08','PROFESIONES',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','09','** LIBRE **',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','10','CODIGO DE TRANSACCION',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','11','UBICACION GEOGRAFICA',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','20','MESES DEL AÑO',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','21','VARIABLES DE REGISTRO',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','22','CALCULOS',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '01','1','EMPLEADOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '01','2','OBREROS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '01','4','JUBILADOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '06','10','CAJA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '06','20','BANCO CONTINENTAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '10','FI','FALTAS INJUSTIFICADAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '10','HS','H.EXTRAS SIMPLES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '10','HD','H.EXTRAS DOBLES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '10','TR','TARDANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '10','PP','PARTICULAR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','01','01 ENERO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','02','02 FEBRERO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','03','03 MARZO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','04','04 ABRIL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','05','05 MAYO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','06','06 JUNIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','07','07 JULIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','08','08 AGOSTO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','09','09 SETIEMBRE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','10','10 OCTUBRE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','11','11 NOVIEMBRE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '20','12','12 DICIEMBRE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1581','ING.ZOOTECNISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1582','ALTA DIRECCION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1583','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1584','INDUS.ALIMENTARIAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1585','ING.AGRONOMO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1586','CONTABILIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1587','ING.QUIMICA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1588','IGENIERO ECONOMISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1589','SISTEMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','0094','FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','0092','TALLER SUELDOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','0093','CONTABILIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','00','SIN INSTRUCCION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','00','SIN PROFESION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '06','30','BANCO DE CREDITO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','02','SECUNDARIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','01','PRIMARIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','03','TEC. SUPERIOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','04','SUPERIOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','01','MECANICO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','02','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','23','CODIGOS PARA AFP',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','02','LEY 20530',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','03','PROFUTURO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','04','PRIMA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','05','HORIZONTE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','06','INTEGRA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','01','CERCADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','02','ANCON',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','21','PUEBLO LIBRE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','03','ATE - VITARTE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','04','BARRANCO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','05','BREÑA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','06','CARABAYLLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','07','COMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','08','CHACLACAYO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','09','CHORILLOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','10','EL AGUSTINO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','11','JESUS MARIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','12','LA MOLINA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','13','LA VICTORIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','14','LINCE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','15','LURIGANCHO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','16','LURIN',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','17','MAGDALENA DEL MAR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','18','MIRAFLORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','19','PACHACAMAC',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','20','PUCUSANA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','22','PUENTE PIEDRA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','23','PUNTA NEGRA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','24','PUNTA HERMOSA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','25','RIMAC',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','26','SAN BARTOLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','27','SAN ISIDRO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','28','INDEPENDENCIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','29','SAN JUAN DE MIRAFLORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','30','SAN LUIS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','31','SAN MARTIN DE PORRES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','32','SAN MIGUEL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','33','SANTIAGO DE SURCO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','34','SURQUILLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','35','VILLA MARIA DEL TRIUNFO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','36','SAN JUAN DE LURIGANCHO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','37','SANTA MARIA DEL MAR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','38','SANTA ROSA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','39','VENTANILLA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','40','CIENEGUILLA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','41','SAN BORJA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','42','VILLA EL SALVADOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','51','CALLAO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','52','BELLAVISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','53','CARMEN DE LA LEGUA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','54','LA PERLA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','55','LA PUNTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','56','VENTANILLA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','43','SANTA ANITA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','04','CONTADOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','05','ABOGADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','06','INGENIERO ZOOTECNISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','07','INGENIERO CIVIL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','57','CAÑETE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','58','MONTERRICO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','08','SECRETARIADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','09','SISTEMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1590','SECRETARIADO EJECUTIVO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','0091','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','0095','DPTO DE LICITACIONES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '27','01','SAN BORJA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '27','02','ATE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '27','03','XXX',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1591','ABOGADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','10','ECONOMIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1592','ING.INDUSTRIAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1593','ECONOMISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','07','UNION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','01','GERENTES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','02','SUPERVISORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','03','VENDEDORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','04','CHOFERES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','05','AUXILIARES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','06','IMPULSADORAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','07','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','08','JUNIORS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','09','CARGADORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CV','00','',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1594','CIENCIAS COMUNICACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1595','PSICOLO INDUSTRIAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','11','PSICOLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','001','DIRECTORIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','020','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','030','FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','040','COMERCIALIZACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','050','MARKETING',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','060','PRODUCCION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','070','PROFESIONAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','200','ALMACEN',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','205','CONTABILIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','210','SISTEMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','215','PERSONAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','220','INGIENERIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','300','FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','440','COMERICAL ADMINISTRAT.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','500','MARKETING',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','620','PERSONAL PROFESIONAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','625','PERSONAL OFICINA TECNICA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','630','PERSONAL ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','635','COTROL DE CALIDAD Y SEGURIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','200','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','202','COMPRAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','204','CONTABILIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','206','SISTEMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','208','PERSONAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','210','SECRETARIADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','212','SERVICIOS GENERALES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','214','ALMACEN',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','216','ALMACEN CAMARA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','218','ALMACEN DE JUGOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','220','ALMACEN DE QUESOS Y OTROS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','222','JABAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','224','FLOTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','300','FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','400','SUPERVISORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','402','VENDEDORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','404','VENDEDORES JUNIORS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','408','CHOFERES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','410','AUXILIARES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','406','IMPULSADORAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','500','MARKETING',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','502','DISTRIBUCION Y ESTADISTICA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','504','PROMOCION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','600','RECEPCION Y ENVIO DE LECHE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','602','PROCESO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','604','ENVASADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','606','PROCESO Y ENVASADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','608','TONGOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','610','PROCESAMIENTO DE FRUTAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','612','ETIQUETADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','614','CARGUIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','616','THERMOENCOGIBLE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','618','FABRICACION DE BOTELLAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','700','ORDEÑADORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','702','RACIONADORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','704','TERNEREROS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','706','AREADORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','708','OTROS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','710','FUNDO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','302','TESORERIA Y CAJA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','620','MANTENIMIENTO DE PLANTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','412','CREDITOS Y FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','201','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','625','DIRECCION TECNICA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0011','GERENTE GENERAL',0,0,'0011','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0180','ASISTENTE DE CONTABLE',0,0,'0180','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0342','SECRETARIA',0,0,'0342','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0070','JEFE DE MANTENIMIENTO',0,0,'0070','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0019','GERENTE DE FINANZAS',0,0,'0019','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0130','SUPERVISOR DE VENTAS PROVINCIAS',0,0,'0130','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0076','SUB CONTADOR',0,0,'0076','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0128','SUPERVISOR DE TURNO',0,0,'0128','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0142','SUPERVISOR-TURNO B',0,0,'0142','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0410','GUARDIAN',0,0,'0410','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0082','CADISTA',0,0,'0082','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0384','MECANICO',0,0,'0384','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0112','SUPERVISOR DE AUTOSERVICIOS',0,0,'0112','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0368','COMPUTO',0,0,'0368','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0232','AUXILIAR DE OFICINA',0,0,'0232','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0406','MENSAJERO',0,0,'0406','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0182','ASISTENTE DE SISTEMAS',0,0,'0182','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0118','SUPERVISOR DE MAYORISTAS',0,0,'0118','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0124','SUPERVISOR DE PROVINCIAS',0,0,'0124','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0462','LABORATORISTA',0,0,'0462','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0162','JEFE DE EQUIPO',0,0,'0162','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0054','JEFE DE CRED.Y COBRANZAS',0,0,'0054','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0013','GERENTE ADMINISTRATIVO',0,0,'0013','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0005','DIRECTOR EJECUTIVO',0,0,'0005','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0040','JEFE DE TALLER',0,0,'0040','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0042','JEFE CONTROL DE CALIDAD',0,0,'0042','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0284','CHOFER',0,0,'0284','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0176','AYUDANTE DE TOPOGRAFO',0,0,'0176','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0068','JEFE DE LIQUIDACIONES',0,0,'0068','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0088','ING° CIVIL',0,0,'0088','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0023','GERENTE DE OPERACIONES',0,0,'0023','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0370','SISTEMAS',0,0,'0370','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0102','TECNICO FISCAL',0,0,'0102','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0380','ELECTRICISTA',0,0,'0380','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0416','CONTROLADOR',0,0,'0416','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0072','JEFE DE MARKETING',0,0,'0072','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0056','JEFE DE DISTRIBUCION',0,0,'0056','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0178','NIVELADOR',0,0,'0178','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0144','INGENIERO RESIDENTE',0,0,'0144','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0044','ALMACENERO',0,0,'0044','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0158','ING° DE OBRAS DE ARTES',0,0,'0158','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0048','JEFE DE ALMACEN-TURNO',0,0,'0048','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0060','JEFE DE FINANZAS',0,0,'0060','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0192','ASISTENTE DE FINANZAS',0,0,'0192','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0052','JEFE DE COSTOS',0,0,'0052','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0078','CONTROLADOR DE EQUIPO',0,0,'0078','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0090','BACHILLER EN INGENIERIA CIVIL',0,0,'0090','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0010','DIRECTOR',0,0,'0010','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0074','JEFE DE PERSONAL',0,0,'0074','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0086','TOPOGRAFO',0,0,'0086','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0017','GERENTE DE COMERCIAL',0,0,'0017','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0084','TAREADOR',0,0,'0084','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0170','LLANTERO.',0,0,'0170','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0188','ASISTENTE DE ALMACEN',0,0,'0188','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0148','INGENIERO ASISTENTE',0,0,'0148','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0064','JEFE DE IMPORTACIONES',0,0,'0064','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0344','SECRETARIA DE GERENCIA',0,0,'0344','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0184','ASISTENTE ADMINISTRATIVO',0,0,'0184','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0146','INGENIERO OFICINA TECNICA',0,0,'0146','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0414','VIGILANTE',0,0,'0414','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0214','AUXILIAR DE ALMACEN',0,0,'0214','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0386','SOLDADOR',0,0,'0386','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0080','CONTROLADOR DE MATERIALES',0,0,'0080','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0046','JEFE DE ALMACEN-NOCHE',0,0,'0046','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0154','ING° ESPECIALISTA EXPLANACION',0,0,'0154','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0372','PRACTICANTE',0,0,'0372','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0160','ING° DE CAMPO',0,0,'0160','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0196','ASISTENTE DE PERSONAL',0,0,'0196','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','630','CONTROL DE CALIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','605','ENVASADO - MAQUINISTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','910000','TALLER SALARIOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','920000','ESTABLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','930000','PLANTA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','940000','ADMINISTRACION Y FINANZAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '02','950000','VENTAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '07','10','OKLDLDL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1596','RELACIONADOR INDUSRIAL',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','59','ICA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '11','60','SURCO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0085','JEFE DE RECURSOS HUMANOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','405','PRE-VENDEDORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'GP','UNO','GRUPO UNO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '23','01','ONP',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CT','2','CTA.CTE.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CT','4','CTA.AHO.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( 'CT','6','CTA.MAE.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '01','3','CONSTRUCION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '06','40','BANCO WIESSE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','24','TABLA DE DOCUMENTOS',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','25','TIPO DE TRABAJADOR',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','26','SEXO DE PERSONAL',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '26','1','MASCULINO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '26','2','FEMENINO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','14','ESTADO CIVIL',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '14','1','SOLTERO / A',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '14','2','CASADO / A',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '14','3','VIUDO / A',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '14','4','DIVORCIADO / A',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '14','5','CONVIVIENTE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','40','TIPO DE AFILIACION',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '40','1','A.F.P.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '40','2','O.N.P.',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','01','LIBRETA ELECTORAL / DNI',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','02','CARNE DE FUERZAS POLICIALES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','03','CARNE DE FUERZAS ARMADAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','04','CARNE DE EXTRANJERIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','07','PASAPORTE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','08','DOC. PROVICIONAL DE IDENTIDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '24','13','TRABAJADOR MENOR DE EDAD',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '25','20','OBRERO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '25','21','EMPLEADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '25','22','TRABAJADOR PORTUARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','29','DIVISIONES',3,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','30','AREAS',3,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','28','SECCION',3,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '22','A','VARIABLES GENERALES DE CALCULO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','636','OPERADORES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','071','TECNICO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','001','ADMINISTRACION',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','002','TALLER SUELDOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','003','RELLENO SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','004','CHICLAYO CHONGOYAPE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','005','MINA BARRICK',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '03','006','TALLER SALARIOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','637','LICITACIONES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0006','GERENTE DE EQUIPO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0007','ASISTENTE DE LICITACIONES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0008','OPERADOR DE SISTEMAS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','12','ING° SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '08','13','TECNICO EN EQUIPO PESADO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','0171','TRAMITADOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','072','TALLER',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','073','ALMACEN TALLER',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','711','TALLER',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1597','TALLER',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','638','TALLER',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','074','RELLENO SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','075','CHICLAYO CHONGOYAPE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '29','076','MINERA BARRICK',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','712','RELLENO SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','713','CHICLAYO CHONGOYAPE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '28','714','MINERA BARRICK',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1598','RELLENO SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1599','CHICLAYO CHONGOYAPE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '05','1600','MINERA BARRICK',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','639','RELLENO SANITARIO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','640','CHICLAYO CHONGOYAPE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','641','MINERA BARRICK',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '30','642','TALLER LURIN',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','463','OPERADOR DE CARGADOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','464','OPERADOR DE TRACTOR',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','465','OPERADOR DE RODILLO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','466','OPERADOR DE BOBCAT',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','467','OPERADOR DE RETROEXCAVADORA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','468','CHOFER DE VOLQUETE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '04','469','OPERADOR DE MOTONIVELADORA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','50','S.C.T.R.',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '50','01','ACTIVO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '50','02','INACTIVO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '00','51','CODIGOS DE ESSALUD VIDA',2,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '51','01','ACTIVO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '51','02','INACTIVO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','A','VARIABLES GENERALES DE CALCULO',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','B','VARIABLES GENERALES DE ASISTENCIA',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','C','VARIABLES GENERALES DE INGRESOS Y DESCUENTOS FIJOS',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','D','VARIABLES GENERALES DE INGRESOS Y DESCUENTOS VARIABLES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','J','VARIABLES GENERALES DE JUDICIALES',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','M','VARIABLES GENRALES DE CUENTA CORRIENTE',0,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','S','VARIABLES DE CALCULO DE ADELANTOS',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','V','VARIABLES DE CALCULO DE VACACIONES',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','T','VARIABLES DE CALCULO DE GRATIFICACION',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','R','VARIABLES DE CALCULO DE PLANILLAS',1,0,'','',Ctod([]))
Insert into plnmtabl(Tabla,Codigo,Nombre,Digitos,Marca,Codnew,Coduser,Fchhora ) values ( '21','X','VARIABLES DE CALCULO DE C.T.S.',1,0,'','',Ctod([]))
End Transaction
**************************
FUNCTION LoadData_PLNMPCTS
**************************
begin transaction
Delete all in PLNMPCTS
Insert into plnmpcts(Fchini,Fchfin,Nroper,Nroano ) values ( Ctod( '01/05/2005' ),Ctod( '31/10/2005' ),'10','2005')
Insert into plnmpcts(Fchini,Fchfin,Nroper,Nroano ) values ( Ctod( '01/11/2005' ),Ctod( '30/04/2006' ),'04','2006')
Insert into plnmpcts(Fchini,Fchfin,Nroper,Nroano ) values ( Ctod( '01/11/2004' ),Ctod( '30/04/2005' ),'04','2005')
End Transaction
**************************
FUNCTION LoadData_CBDFLPDT
**************************
begin transaction
Delete all in CBDFLPDT
Insert into cbdflpdt(Formulario,Nombre,Codope,Codcta,Factor,Uit ) values ( '3500','INGRESOS','004','121',2,3300)
Insert into cbdflpdt(Formulario,Nombre,Codope,Codcta,Factor,Uit ) values ( '3500','COSTOS','005','421',2,3300)
End Transaction
**************************
FUNCTION LoadData_CBDCNFG1
**************************
begin transaction
Delete all in CBDCNFG1
Insert into cbdcnfg1(Nivcta,Nrodig,Ultimo ) values ( '1','2',0)
Insert into cbdcnfg1(Nivcta,Nrodig,Ultimo ) values ( '2','3',0)
Insert into cbdcnfg1(Nivcta,Nrodig,Ultimo ) values ( '3','5',1)
End Transaction
