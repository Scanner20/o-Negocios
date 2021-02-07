MODIFY COMMAND k:\aplvfp\sistscr0.prg AS 1252
SET DEFAULT TO k:\aplvfp
DO limpiar.fxp
?SYS(5)
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\check_system_o-n.pjx"
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\dbcevents\dbco-n.prg" AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
CANCEL
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE tablasmodulo
BROWSE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
CANCEL
QUIT
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4400.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4500.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4600.prg
LsCodCli='20417926632'
SELECT 0
USE cctclien
MODIFY STRUCTURE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+LsCodcli
BROWSE
USE cctclien EXCLUSIVE
BROWSE
USE cctclien
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+LsCodcli
BROWSE
USE cctclien EXCLUSIVE
MODIFY STRUCTURE
USE
SELECT 0
USE ccbrgdoc
SET FILTER TO codcli='20417926632' AND flgest='P' AND sdodoc<>0 AND ABS(sdodoc) <=3
BROWSE
SET FILTER TO codcli='20417926632' AND (flgest='P' OR flgest='C') AND sdodoc<>0 AND ABS(sdodoc) <=3
BROWSE
SET FILTER TO
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT 0
USE cctclien
USE cctclien ALIAS clie
clie.deuda_nac
?clie.deuda_nac
?clie.deuda_ext
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
xp='00209313'
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
SELECT 0
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4500.prg
USE
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4500.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4600.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg AS 1252
SELECT 0
USE vtavprof
SET ORDER TO VPRO01   && NRODOC
SEEK xp
BROWSE
DO k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg
RESUME
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4600.prg
SELECT 0
USE cctclien
SET ORDER TO CLIEN01   && CODCLI
SEEK '20109379736'
SEEK GsClfCli+'20109379736'
BROWSE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+'20109379736'
BROWSE
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
BROWSE
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS calculo_credito OF "k:\aplvfp\classgen\vcxs\o-n.vcx"
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
USE o:\o-negocios\IDC\Data\tablasmodulo
BROWSE
USE
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\o-n.prg" AS 1252
SELECT 0
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE tablasmodulo
?DBF()
BROWSE
USE cbdtanos
BROWSE
USE
set
SELECT 1
BROWSE LAST
MODIFY DATABASE
CLOSE DATABASES all
USE o:\o-negocios\IDC\Data\tablasmodulo.dbf
BROWSE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE cia001!cctclien
USE cia001!cctclien EXCLUSIVE
MODIFY STRUCTURE
SET DATABASE TO P0012016
USE p0012016!almcatge
set
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\cctclien.dbf
SELECT 3
USE p0012016!almcatge EXCLUSIVE
MODIFY STRUCTURE
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
CLOSE DATABASES all
DO revisagdoc
BROWSE LAST
SELECT 4
SELECT 5
SELECT 6
SELECT 7
SELECT 8
SELECT 9
SELECT 12
SELECT 13
SELECT 14
SELECT 15
SELECT 16
BROWSE
CLOSE TABLES all
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\classgen\forms\adm_accesos_seguridad.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtar4200.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
Goentorno.User.Login= 'Kbenavides'
GoEntorno.USER.GroupName		= 'Ventas'
GsUsuario = 'Kbenavides'
=BuildAccessCursor()
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY COMMAND _
MODIFY COMMAND ?
MODIFY COMMAND k:\aplvfp\bsinfo\progs\copiarexcel2dbf.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\act_ventas.prg AS 1252
MODIFY COMMAND ?
MODIFY COMMAND k:\aplvfp\bsinfo\progs\poner_ccosto_ple_exactus.prg AS 1252
loExcel=CREATEOBJECT("Excel.application")
loExcel.APPLICATION.VISIBLE=.F.
PsNomFile=GETFILE(".xls;.xlsx","Lista de precios")
?PsNomFile
loExcel.APPLICATION.workbooks.OPEN(PsNomFile)
lnMaxRows = LoExcel.ActiveWorkBook.ActiveSheet.Rows.Count
LnRowAct = 1
LnColumna = 1
?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,LnColumna).Value
?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,2).Value
?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value
?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value + 1
MODIFY COMMAND k:\aplvfp\bsinfo\progs\Cargar_Lista_precios_1.prg
?goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT catg
SET ORDER TO CATG05   && CODEQU
SEEK 'P01'
BROWSE
SET ORDER TO CATG06   && CODREF
SEEK 'P01'
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SET DATABASE TO P0012016
USE p0012016!v_materiales_sin_almacen
BROWSE
set
SELECT catg
?goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
SELECT 0
USE p0012016!v_materiales_sin_almacen
BROWSE
SELECT * FROM p0012016!v_materiales_sin_almacen
BROWSE
CLOSE TABLES all
SELECT 1
BROWSE
SELECT * FROM p0012016!v_materiales_sin_almacen ORDER BY codant alias CATG_ANT
SELECT * FROM p0012016!v_materiales_sin_almacen ORDER BY codant INTO CURSOR CATG_ANT
BROWSE
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2016\almcatge.dbf
SELECT catg
USE o:\o-negocios\IDC\Data\cia001\c2016\almcatge.dbf ALIAS catg AGAIN
SET ORDER TO CATG01   && CODMAT
SEEK catg_ant.codmat
SELECT catg
SET ORDER TO CATG01   && CODMAT
SEEK catg_ant.codmat
BROWSE
SELECT 0
USE cia001!cpicform
SET DATABASE to CIA001
USE cia001!cpicfpro
SET ORDER TO CFPR01   && CODPRO
SEEK CATG.cODMAT
SET ORDER TO CFPR01   && CODPRO
SEEK CATG.cODMAT
SEEK CATG_ANT.cODMAT
BROWSE
SELECT 0
GoEntorno.open_dbf1('ABRIR','v_materiales_sin_almacen','CATG_ANT','','')
INDEX ON CODANT TAG CODANT
SET ORDER TO CODANT   && CODANT
MODIFY COMMAND k:\aplvfp\bsinfo\progs\poner_ccosto_ple_exactus.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cargar_lista_precios_1.prg AS 1252
LlCloseCatg=.F.
LlCloseCatg	=	GoEntorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
LlCloseCatg=.F.
LlCloseCatg	=	GoEntorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
?LlCloseCatg
USE
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cargar_lista_precios_1.prg AS 1252
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\o-n.prg" AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 0
USE ALMTGSIS
SET ORDER TO TABL01   && TABLA+CODIGO
SEEK 'TP'
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT  0
USE almcatge ALIAS catg
USE  o:\o-negocios\IDC\Data\cia001\c2016\almcatge.dbf  ALIAS catg
SET ORDER TO CATG01   && CODMAT
SELECT 0
USE  p:\o-negocios\IDC\Data\cia001\c2016\almcatge.dbf  ALIAS catg2
SET ORDER TO CATG01   && CODMAT
SELECT 4
SET RELATION TO codmat INTO catg2
BROWSE
LOCATE
BROWSE FIELDS codmat,desmat,prevn1,preve1
BROWSE FIELDS codmat,desmat,prevn1,preve1,catg2.prevn1,catg2.preve1
REPLACE ALL Prevn1 WITH CATG2.prevn1, Preve1 WITH catg2.preve1 FOR codmat==CATG2.Codmat
LOCATE
SELECT 3
BROWSE LAST
SELECT 0
USE p:\o-negocios\eholding\Data\cia001\c2016\almcatge.dbf
USE p:\o-negocios\eholding\Data\cia001\c2015\almcatge.dbf
USE p:\o-negocios\eholding\Data\cia001\c2014\almcatge.dbf
MODIFY STRUCTURE
SELECT 0
USE p:\o-negocios\eholding\Data\cia001\almtgsis
SET ORDER TO TABL01   && TABLA+CODIGO
SEEK 'TP'
BROWSE
BROWSE LAST
USE
SELECT 6
CLOSE DATABASES all
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT 26
BROWSE LAST
SELECT 42
RESUME
SELECT 26
BROWSE LAST
CANCEL
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
SELECT 42
RESUME
REPLACE PreVta WITH LfPreUni
RESUME
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
sele 0
USE o:\o-negocios\eholding\Data\cia001\ccbmvtos ALIAS vtos
USE o:\o-negocios\idc\Data\cia001\ccbmvtos ALIAS vtos
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE o:\o-negocios\eholding\Data\cia001\ccbmvtos ALIAS vtos
USE o:\o-negocios\idc\Data\cia001\ccbmvtos ALIAS vtos
SET ORDER TO VTOS01   && CODDOC+NRODOC
SEEK 'I/C0201000024'
BROWSE
SEEK 'I/C 0201000024'
SET ORDER TO VTOS03   && CODREF+NROREF+CODDOC+CODOPE+NROAST
SEEK 'FACT0010032632'
SEEK 'FACT0010032692'
x1='20545890691'
x2='20524072140'
SEEK 'BOLE0010002727'
x3='10097191242'
SEEK 'BOLE0010002728'
x4='01296859'
SEEK 'FACT0010032699'
x5='20399360201'
SEEK 'BOLE0010002729'
x6='42137247'
SEEK 'LETR0100070'
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE vtavpedi
GO bott
BROWSE
SELECT 0
USE vtaritem
SET ORDER TO ITEM01   && CODDOC+NRODOC
GO bott
BROWSE
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
GO bott
BROWSE
SELECT 0
USE  o:\o-negocios\IDC\Data\cia001\vtavpedi.dbf ALIAS rped
GO BOTT
BROWSE
SELECT 5
SELECT 4
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 0
SET DATABASE TO P0012016
USE p0012016!v_materiales_x_almacen_2
BROWSE
SELECT * FROM p0012016!v_materiales_x_almacen_2 INTO CURSOR Matxa2 readwrite
INDEX on codmat+subalm TAG subalm
SELECT 10
BROWSE LAST
SELECT codmat,subalm FROM p0012016!v_materiales_x_almacen_2 GROUP BY codmat,subalm
USE
SELECT codmat,subalm,Tot=COUNT(*) FROM p0012016!v_materiales_x_almacen_2 GROUP BY codmat,subalm HAVING tot > 1
SELECT codmat,subalm,COUNT(*) as tot FROM p0012016!v_materiales_x_almacen_2 GROUP BY codmat,subalm HAVING tot > 1
SELECT codmat,subalm,COUNT(*) as tot FROM p0012016!v_materiales_x_almacen_2 GROUP BY codmat,subalm HAVING tot = 1
USE
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
BROWSE LAST
RESUME
SELECT 13
BROWSE LAST
SELECT 54
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
?gSsUBALM
?gSsUBALM(1,1)
?gAsUBALM(1,1)
?gSsUBALM
?GaSubALm(1,1)
USE "p:\o-negocios\idc\data\cia001\almtalma.dbf" IN 0 SHARED
SELECT 3
BROWSE LAST
USE
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS validadatos OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\o-n.prg" AS 1252
?GsSubAlm
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
?GsSubAlm
sele 0
USE almtalma
SET ORDER TO ALMA01   && SUBALM
BROWSE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
sele 0
USE vtavpedi
GO bott
BROWSE
sele 0
USE vtarpedi
GO bott
BROWSE
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS validadatos OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
x=CAST(SPACE(3) AS Character(3))
?x
?x+'1'
CLEAR
?x
?x+'1'
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
ov=CREATEOBJECT('Dosvr.validadatos')
RESUME
BROWSE LAST
RESUME
SELECT 26
RESUME
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
SELECT 42
BROWSE LAST
SELECT 26
BROWSE LAST
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
XpwdRouter='#B4FC8C@E64D5E*'
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\alm_almkarta.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_cat_materiales.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_cat_materiales.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtar4100.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 21
BROWSE LAST
USE
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
RESUME
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_textbox_ip OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtar4810.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtar4820.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtar4830.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4210.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4200.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4250.scx
DO k:\aplvfp\bsinfo\progs\vta_vtar4250.prg
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4250.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cargar_lista_precios_1.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
RESUME
USE P:\o-negocios\IDC\Data\cia001\c2016\almcatg2 ALIAS PXCLI
USE P:\o-negocios\IDC\Data\cia001\c2016\almcatg2 ALIAS PXCLI exclu
INDEX on codcli+codmat TAG CODCLI
LsRutaCatg = goentorno.remotepathentidad('ALMCATG2')
SELECT dbfs
SEEK 'ALMACEN   ALMCATGE'
BROWSE
SEEK 'ALMACEN   ALMCATGE'
SEEK 'ALMACEN'
?TAG()
SEEK 'ALMCATGE'
BROWSE LAST
SCATTER memvar
APPEND BLANK
GATHER MEMVAR
LsRutaCatg = goentorno.remotepathentidad('ALMCATG2')
?lsRutaCatg
SELECT 7
ZAP
DELETE TAG PRECLI
SET ORDER TO CODCLI   && CODCLI+CODMAT
INDEX ON CODMAT+CODCLI TAG PXCLI01
INDEX ON CODCLI+CODMAT	TAG PXCLI02
SET ORDER TO CODCLI   && CODCLI+CODMAT
DELETE TAG CODCLI
SET ORDER TO PXCLI02   && CODCLI+CODMAT
USE
SELECT 0
USE SISTCDXS ALIAS CDXS ORDER CDXS01
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
BROWSE LAST
SCATTER MEMVAR
APPEND BLANK
GATHER MEMVAR
SCATTER MEMVAR
APPEND BLANK
GATHER MEMVAR
USE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
CANCEL
RESUME
CANCEL
SET DEFAULT TO k:\aplvfp
DO limpiar.prg
CANCEL
RESUME
CANCEL
DO limpiar.fxp
CANCEL
DO limpiar.prg
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
CANCEL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 8
BROWSE LAST
RESUME
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
USE
CANCEL
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY COMMAND x
SELECT 4
SELECT 5
RESUME
MODIFY COMMAND x
RESUME
CANCEL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY form k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 0
USE P:\o-negocios\IDC\Data\cia001\c2016\almcatg2.DBF ALIAS catg2
LsRutaCatg=DBF()
PsCodCli=''
LsWhere='.T.'
SELECT CodMat,Desmat,Preve1,Prevn1, CAST(PsCodCli AS Char(11)) AS CodCli FROM  (LsRutaCatg)
SELECT CodMat,Desmat,Preve1,Prevn1, CAST(PsCodCli AS Char(11)) AS CodCli FROM  (LsRutaCatg) WHERE (LsWhere)
SELECT CodMat,Desmat,Preve1,Prevn1, CAST(PsCodCli AS Char(11)) AS CodCli FROM  (LsRutaCatg) WHERE eval(LsWhere)
SELECT CodMat,Desmat,Preve1,Prevn1, CAST(PsCodCli AS Char(11)) AS CodCli FROM  (LsRutaCatg) WHERE eval(LsWhere) INTO CURSOR C_CATG READWRITE ORDER BY CodMat
LsWhere=[CodCli=']+'20512152733'+[']
?lswhere
SELECT CodMat,Desmat,Preve1,Prevn1, CAST(PsCodCli AS Char(11)) AS CodCli FROM  (LsRutaCatg) WHERE eval(LsWhere) INTO CURSOR C_CATG READWRITE ORDER BY CodMat
BROWSE LAST
USE
SELECT 7
USE
SELECT 3
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 3
USE
SELECT 7
USE
SET DATABASE TO P0012016
ADD TABLE ?
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\crm_seguimiento.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\crm_prospectos.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_cat_materiales.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\crm_prospectos.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_container OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_textbox_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
This.Parent.TxtCodmat.Valid()
CANCEL
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 7
BROWSE LAST
USE
SELECT 14
USE
SELECT 8
USE
SELECT 6
USE
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4210.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtar4510.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY COMMAND k:\aplvfp\classgen\progs\janesoft.prg AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_tipo_de_cambio.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_tipo_de_cambio.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_tipo_de_cambio.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SET DATABASE TO P0012016
ADD TABLE ?
SELECT 1
APPEND FROM p:\o-negocios\idc\data\sistdbfs FOR archivo='ALMCATG2'
BROWSE
SELECT 0
USE SISTCDXS
APPEND FROM p:\o-negocios\idc\data\sistCDXs FOR archivo='ALMCATG2'
BRW
BROWSE
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
BROWSE
USE
SET DATABASE TO ADMIN
CLOSE DATABASES
CLOSE DATABASES ALL
CLEAR ALL
CLOSE ALL
SET LIBRARY TO to
SET LIBRARY to
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
BROWSE LAST
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE vtaritem
SET ORDER TO ITEM01   && CODDOC+NRODOC
SEEK '00126862'
BROWSE
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
SEEK '00126862'
BROWSE
SELECT 0
USE vtavpedi
SET ORDER TO VPED01   && NRODOC
SEEK '00126862'
BROWSE
SEEK '00126862'
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
BROWSE LAST
USE
SELECT 3
USE
SELECT 0
USE CBDMAUXI
SET ORDER TO AUXI01   && CLFAUX+CODAUX
SEEK GSCLFCLI+'20600375581'
BROWSE
SELECT 0
USE CCTCLIEN
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GSCLFCLI+'20600375581'
BROWSE
SELECT 0
USE cia001!cctcdire
SET ORDER TO DIRE02   && CLFAUX+CODAUX+CODDIRE
SEEK GSCLFCLI+'20600375581'
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes1.scx
MODIFY COMMAND
SELECT 8
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 8
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 8
SET ORDER TO DIST01   && CODDIST
SELECT 8
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 12
USE
SELECT 11
USE
SELECT 8
USE
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes1.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT 0
USE almtgsis
SET ORDER TO TABL01   && TABLA+CODIGO
SEEK 'TP'
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
CANCEL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_proveedores.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_proveedores.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
?Gocfgvta.XiCodMOn
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
?Gocfgvta.XnTpoCmb
?Gocfgvta.XfTpoCmb
?Gocfgvta.fTpoCmb
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_dcasa.prg AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY COMMAND k:\aplvfp\classgen\progs\janesoft.prg AS 1252
?SYS(5)
?SYS(2023)
?SYS(2005)
?SYS(2015)
?SYS(3)
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 1
BROWSE LAST
SELECT 8
SET ORDER TO PXCLI01   && CODMAT+CODCLI
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
USE o:\o-negocios\IDC\Data\cia001\cctclien.dbf EXCLUSIVE
MODIFY STRUCTURE
set
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\cbd_diariogeneral.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
SET DEFAULT TO k:\aplvfp
DO limpiar.prg
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
CANCEL
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
BROWSE LAST
CANCEL
SELECT  0
USE almdtran
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SET FILTER tporfb='PEDI' AND nrorfb='00126917'
SET FILTER TO tporfb='PEDI' AND nrorfb='00126917'
BROWSE
SELECT 0
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
SEEK '00126917'
BROWSE
SELECT 3
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 0
USE vtavpedi
SET ORDER TO VPED01   && NRODOC
SEEK '00126917'
BROWSE
SELECT 3
USE
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
SELECT 5
BROWSE LAST
SELECT 0
USE almdtran
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SET FILTER TO tporfb='PEDI' AND nrorfb='00126933'
BROWSE
SELECT 4
SEEK '00126933'
BROWSE
SELECT 3
SET FILTER TO
SEEK 'G/R 0010025600'
BROWSE
USE
SELECT 5
USE
SELECT 4
USE
SELECT 0
USE ccbrgodc
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE cia001!ccbrgdoc
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\form1.scx
DO FORM k:\aplvfp\bsinfo\forms\form1.scx
CANCEL
MODIFY FORM k:\aplvfp\bsinfo\forms\form_fondo.scx
DO FORM k:\aplvfp\bsinfo\forms\form_fondo.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\form_prueba.scx
DO FORM k:\aplvfp\bsinfo\forms\form_prueba.scx
RESUME
DO FORM k:\aplvfp\bsinfo\forms\form_prueba.scx
RESUME
DO FORM k:\aplvfp\bsinfo\forms\form_prueba.scx
SELECT 15
USE
SELECT 4
BROWSE LAST
MODIFY FORM k:\aplvfp\bsinfo\forms\form_fondo.scx
DO FORM k:\aplvfp\bsinfo\forms\form_fondo.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\form_prueba.scx
MODIFY COMMAND config.fpw
MODIFY COMMAND k:\aplvfp\bsinfo\progs\setup_file_date.prg AS 1252
?DATETIME()
?DATE()
?VARTYPE(DATE())
?VARTYPE(DATETIME())
?DTOT(DATE())
?YEAR(DATETIME())
?VARTYPE(YEAR(DATETIME()))
?VARTYPE(month(DATETIME()))
?VARTYPE(day(DATETIME()))
?VARTYPE(hour(DATETIME()))
?VARTYPE(minute(DATETIME()))
?VARTYPE(seconds(DATETIME()))
?VARTYPE(SECONDS(DATETIME()))
?VARTYPE(SECONDS())
?SECONDS()
?MINUTE(DATETIME())
?MINUTE(DATETIME(),1)
?MINUTE(DATETIME())
?TTOC(DATETIME(),1)
?TTOC(DATETIME())
?TTOC(DATETIME(),1)
?TTOC(DATETIME(),2)
?TTOC(DATETIME(),3)
?TTOC(DATETIME())+'1'
?TTOC(DATETIME(),1)
?SUBSTR(TTOC(DATETIME(),1),13,2)
?TTOC(DATETIME(),1)
?SUBSTR(TTOC(DATETIME(),1),13,2)
?SUBSTR(TTOC(DATETIME(),1),4)
?SUBSTR(TTOC(DATETIME(),1),1,4)
LdDateTime=DATETIME()
?VAL('01')
?VAL('00')
=setup_file_date('K:\Aplvfp\GrafGen\Iconos\network_1.ico',DATETIME())
?DATETIME()
?DATETIME()+SECONDS()
ld=DATETIME()
?ld
?ld+SECONDS()
?ld+2
?ld+30
?TTOC(Ld)
?TTOC(Ld,1)
?TTOC(Ld+10,1)
MODIFY COMMAND k:\aplvfp\bsinfo\progs\setup_file_date.prg AS 1252
=setup_file_date('K:\Aplvfp\GrafGen\Iconos\network_1.ico',DATETIME())
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE almctatge
USE o:\o-negocios\IDC\Data\cia001\c2016\almcatge.dbf order catg01
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2016\almcatg2.dbf order catg01
SET RELATION TO codmat INTO almcatge
REPLACE ALL codant WITH almcatge.codant ,codref WITH almcatge.codref FOR codmat==almcatge.codmat
BROWSE LAST
SELECT 3
USE
SELECT 4
USE
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
CLOSE ALL
CLEAR ALL
QUIT
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap1500.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
SELECT 8
USE
SELECT 7
USE
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS validadatos OF k:\aplvfp\classgen\vcxs\dosvr.vcx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4300.prg
SELECT 0
USE ccbrgdoc
SELECT * FROM ccbrgdoc WHERE Flgest='C' AND DTOS(fchdoc)<='2015'
?_tally
SELECT 3
SELECT 0
USE ccbmvtos
BROWSE
SELECT 0
USE vtaritem
SELECT 0
USE vtavprof
MODIFY COMMAND k:\aplvfp\bsinfo\progs\CCb_Depura_CCb
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbr4300.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\copydbc2dbc_0.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\copydbc2dbc.prg AS 1252
?GoCfgVta.oentorno.tspathcia
SELECT 3
COPY TO ADDBS(GoCfgVta.oentorno.tspathcia)+'GDOC_ANT' WITH CDX
SELECT 0
USE vtaritem
set
SELECT 5
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg AS 1252
SELECT 0
USE ccbrrdoc
BROWSE
SELECT 0
USE ccbntasg
SELECT 0
USE ccbrtasg
SELECT 9
SELECT 8
SELECT 7
SELECT 0
USE vtarprof
SELECT 0
USE vtavpedi
GO bott
BROWSE
SELECT 0
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
SELECT 0
USE vtavguia
BROWSE LAST
GO bott
SELECT 0
USE vtatdocm
BROWSE
SELECT 0
USE sistdocs
BROWSE
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 0
SELECT 15
USE
USE sistdocs EXCLUSIVE
USE sistdocs
BROWSE LAST
USE sistdocs EXCLUSIVE
MODIFY STRUCTURE
USE
SELECT 10
SELECT 7
SELECT 12
SELECT 11
SELECT * FROM vtavpedi WHERE INLIST(Flgest,'C','A') AND DTOS(fchdoc)<='2015'
?_tally
SELECT * FROM vtavpedi WHERE DTOS(fchdoc)<='2015'
?_tally
SELECT 12
SELECT 11
SELECT 12
SELECT * FROM vtavguia WHERE DTOS(fchdoc)<='2015'
?_tally
SELECT 11
SELECT * FROM ccbrgdoc WHERE INLIST(Flgest,'C','A') AND DTOS(fchdoc)<='2015'
?_tally
SELECT * FROM ccbrgdoc WHERE !INLIST(Flgest,'C','A') AND DTOS(fchdoc)<='2015'
?_tally
SELECT 0
USE crmprospec
SELECT 0
USE P:\o-Negocios\JAMMING\data\Cia001\CRMCPROSPE
MODIFY STRUCTURE
SELECT 0
USE cctclien
?DBF()
SET DATABASE TO CIA001
CLOSE DATABASES
SET DATABASE TO CIA001
COPY TO ADDBS(GoCfgVta.oentorno.tspathcia)+'CLIE_ANT' WITH CDX FOR 1<0
XdFchCorte1={31/12/2015}
XdFchCorte1=CTOD('31/12/2015')
?XdFchCorte1
?GsCodCia
SET DATABASE TO  P0012016
SET DATABASE TO  (GoCfgVta.oentorno.tspathcia)+'CIA'+GsCodCia
?GoCfgVta.oentorno.tspathadm
SET DATABASE TO  (GoCfgVta.oentorno.tspathadm)+'CIA'+GsCodCia
SET DATABASE TO  addbs(GoCfgVta.oentorno.tspathadm)+'CIA'+GsCodCia
ADD TABLE ADDBS(GoCfgVta.oentorno.tspathcia)+'CLIE_ANT'
REMOVE TABLE ADDBS(GoCfgVta.oentorno.tspathcia)+'CLIE_ANT'
REMOVE TABLE 'CLIE_ANT'
SELECT 0
USE sistdocs
BROWSE
SELECT 1
SCATTER memvar
BROWSE LAST
MODIFY STRUCTURE
BROWSE LAST
SELECT 0
USE cctclien
SELECT 15
BROWSE
SET FILTER TO !EMPTY(coduser)
SET FILTER TO !EMPTY(fpricom)
SET FILTER TO !EMPTY(fultcom)
SET FILTER TO !EMPTY(fpricom) OR !EMPTY(fultcom)
SELECT 3
xd={}
xda=DATE()
?xda<xd
xdb=DATE()+1
?xda<xdb
?xda<xd and !EMPTY(xd)
?xda
?EMPTY(xd)
?xda<xd &&and !EMPTY(xd)
?xda<xd or EMPTY(xd)
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
lo cate
LOCATE
BROWSE
LOCATE
BROWSE
LOCATE
GO top
SET FILTER TO
LOCATE
BROWSE
LOCATE
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
LOCATE
BROWSE
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
LOCATE
BROWSE
GO top
USE
SELECT 0
USE ccbrgdoc
LOCATE
BROWSE
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
BROWSE
LOCATE
SELECT 11
SET ORDER TO VPED04   && DTOS(FCHDOC)+CODVEN+NRODOC
BROWSE
LOCATE
SELECT 3
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
SEEK '2007'
BROWSE LAST
SEEK '2006'
SEEK '2005'
BROWSE LAST
SELECT 0
USE P:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
BROWSE
LOCATE
USE P:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf EXCLUSIVE
REINDEX
SELECT 16
SELECT 3
SELECT 16
PACK
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
SEEK '2015'
BROWSE
LOCATE
BROWSE
USE
SET DATABASE TO CIA001
CLOSE DATABASES
SET DATABASE TO CIA001
SELECT 0
USE cctcdire
SELECT 15
BROWSE LAST
SET FILTER TO
MODIFY FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
SELECT 1
BROWSE LAST
SELECT 11
USE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 1
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
RESUME
BROWSE LAST
RESUME
?ICASE(EMPTY(FPriCom),GDOC.FchDoc,GDOC.FchDoc<ttod(FPriCom),GDOC.FchDoc)
?GDOC.FchDoc<ttod(FPriCom)
?GDOC.FchDoc<FPriCom
DO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
RESUME
SELECT 2
SELECT 12
USE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY COMMAND  k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
DO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
RESUME
SELECT 0
USE clien_ant
USE clie_ant
BROWSE
USE
USE ccbrgdoc EXCLUSIVE
PACK
USE ccbmvtos EXCLUSIVE
PACK
USE vtaritem EXCLUSIVE
PACK
USE vtavpedi EXCLUSIVE
PACK
USE vtaritem EXCLUSIVE
PACK
USE vtavprof EXCLUSIVE
PACK
USE vtarprof EXCLUSIVE
PACK
USE cctclien EXCLUSIVE
PACK
USE vtavguia EXCLUSIVE
PACK
USE
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 0
USE sistdocs
BROWSE
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
USE cctclien
BROWSE
SELECT 0
USE clien_ant
USE clie_ant
SELECT 37
SELECT 3
x=RECCOUNT()
SELECT 37
?RECCOUNT()-x
USE
SELECT 3
USE
SELECT 0
x='20491767597'
SELECT 0
USE cctclien
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
?gsclfcli
SEEK GsClfCli+x
BROWSE
SELECT 0
USE cia001!clie_ant
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+x
BROWSE
SELECT 0
USE gdoc_ant
SET ORDER TO GDOC04   && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
SEEK x
BROWSE
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
SELECT 0
USE ccbrgdoc
SET ORDER TO GDOC04   && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
SEEK x
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SCATTER memvar
SELECT 3
BROWSE LAST
SET DELETED OFF
SET DELETED ON
APPEND BLANK
GATHER memvar
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 5
SELECT 4
SELECT 3
BROWSE LAST
SELECT 4
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
SELECT 0
USE vtavprof
SET ORDER TO VPRO02   && CODCLI+FLGEST+NRODOC
SEEK x
BROWSE LAST
SELECT 6
BROWSE LAST
SET ORDER TO GDOC04   && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
USE
SELECT 7
USE
SELECT 5
BROWSE LAST
USE
SELECT 4
USE
SELECT 3
USE
SELECT 0
USE cia001!clie_ant
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
x='20100833035'
SEEK gsclfcli+x
BROWSE
SCATTER memvar
SELECT 0
USE cctclien
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK gsclfcli+x
BROWSE
APPEND BLANK
GATHER memvar
BROWSE
SELECT 3
BROWSE LAST
SELECT 4
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
SELECT 0
USE gdoc_ant
SET ORDER TO GDOC04   && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
SEEK gsclfcli+x
BROWSE
SEEK x
BROWSE
SET ORDER TO GDOC04  DESCENDING  && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
SEEK x
SET ORDER TO GDOC04  ASCENDING  && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
USE gdoc_ant
USE gdoc_ant EXCLUSIVE
INDEX on Codcli+DTOS(fchdoc) TAG GDOC11
USE
SELECT 4
USE
SELECT 3
USE
SET PROCEDURE TO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg additive
DO Parche_CLIE_ANT IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 3
BROWSE LAST
SET ORDER TO GDOC11  ascending && CODCLI+DTOS(FCHDOC)
SET ORDER TO GDOC11  DESC && CODCLI+DTOS(FCHDOC)
SELECT 4
RESUME
SELECT 3
BROWSE LAST
RESUME
SELECT 5
SELECT 0
SET ORDER TO
GO bott
SELECT 5
SET ORDER TO
GO bott
BROWSE
SELECT 3
SEEK clie.codaux
BROWSE LAST
SELECT 3
SEEK clie.codaux
BROWSE LAST
SET RELATION TO Clie.clfaux+ Clie.codaux INTO Clie_a ADDITIVE
SELECT 4
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 4
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
USE
SELECT 3
USE
SELECT 5
USE
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\classgen\forms\gen2_ayuda_codigo_busqueda.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funvta_vtap1500.scx
x='juan antonio ortiz cacha'
SELECT 0
USE clie_ant
SET ORDER TO CLIEN02   && UPPER(RAZSOC)
SET FILTER TO 'ORTIZ'$razsoc
BROWSE
SELECT 0
USE gdoc_ant
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
y='20536916092'  && ANCO BUS
x='10456605295'
SEEK x
BROWSE
SELECT 3
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SCATTER memvar
SELECT 0
USE cctclien
GO bott
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+x
BROWSE
APPEND BLANK
GATHER memvar
SELECT 3
SEEK GsClfCli+y
BROWSE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+y
BROWSE
SET FILTER TO 'BUS'$razsoc
BROWSE
y='20536916042'  && ANCO BUS
SEEK GsClfCli+y
SET FILTER TO
SEEK GsClfCli+y
SET FILTER TO 'ANCC0'$razsoc
SET FILTER TO
SET FILTER TO 'ANCCO'$UPPER(razsoc)
SELECT 3
BROWSE LAST
SCATTER memvar
SELECT 5
y='20536916092'  && ANCO BUS
SELECT 5
SEEK GsClfCli+y
BROWSE
SELECT 3
SCATTER memvar
SELECT 5
APPEND BLANK
GATHER memvar
BROWSE
SELECT 3
BROWSE LAST
SET FILTER TO
SET FILTER TO 'APAZA'$UPPER(razsoc)
BROWSE LAST
SCATTER memvar
SELECT 5
APPEND BLANK
GATHER memvar
BROWSE LAST
SET FILTER TO 'ANCCO'$UPPER(razsoc)
BROWSE LAST
SET FILTER TO 'ORTIZ'$UPPER(razsoc)
SELECT 5
SET ORDER TO
GO bott
BROWSE
SELECT 5
SELECT 4
SET FILTER TO !EMPTY(fultcom) AND DELETED()
BROWSE
SELECT 3
SET FILTER TO !EMPTY(fultcom) AND DELETED()
BROWSE LAST
SET FILTER TO  DELETED()
BROWSE LAST
SET DELETED OFF
SET FILTER TO !EMPTY(fultcom) AND DELETED()
SET FILTER TO EMPTY(fultcom) AND DELETED()
BROWSE LAST
USE
SELECT 4
USE
SELECT 5
USE
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 0
USE cctclien
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT 0
USE cctclien
x='impportaciones G & R'
SELECT 0
clie_ant
USE clie_ant
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SET FILTER TO 'IMPORTACIONES'$UPPER(razsoc)
BROWSE
SCATTER memvar
SELECT 3
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK clie_ant.clfaux+clie_ant.codaux
BROWSE LAST
APPEND BLANK
GATHER memvar
SELECT 0
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
SELECT 4
BROWSE LAST
USE
SELECT 3
USE
SET PROCEDURE TO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
SET PROCEDURE TO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg additive
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SET PROCEDURE TO k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg additive
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 5
USE
SELECT 3
USE
SELECT 4
USE
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
BROWSE LAST
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 5
SET ORDER TO
GO bott
BROWSE
SELECT 4
SET FILTER TO coduser='VTORRES'
BROWSE
SELECT 3
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
USE
SELECT 5
USE
SELECT 3
USE
RESUME
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
DO Parche_CLIE_ANT2 IN k:\aplvfp\bsinfo\progs\ccb_depura_ccb
RESUME
SELECT 3
SELECT 4
BROWSE LAST
LOCATE
BROWSE LAST
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE clie_ant
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 0
USE cctclien
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 3
SEEK gsclfcli+'20389424928'
BROWSE
SCATTER memvar
SELECT 4
SEEK gsclfcli+'20389424928'
BROWSE LAST
APPEND BLANK
GATHER memvar
BROWSE LAST
SELECT 1
UNLOCK all
SELECT 0
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
CLOSE DATABASES all
SELECT 0
USE almcatge
USE  O:\o-negocios\IDC\Data\cia001\almcatge ORDER catg01
USE  O:\o-negocios\IDC\Data\cia001\c2016\almcatge ORDER catg01
SEEK '02'
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant.dbf
SELECT 2
SET ORDER TO GDOC04   && CODCLI+FLGEST+TPODOC+CODDOC+NRODOC
SET FILTER TO 'LIBRERIA'$UPPER(RAZSOC)
BROWSE
SET FILTER TO 'VIDRIERIA'$UPPER(RAZSOC)
BROWSE
SET FILTER TO 'UNIVERSO'$UPPER(RAZSOC)
BROWSE LAST
SET FILTER TO
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\clie_ant.dbf
SET FILTER TO 'UNIVERSO'$UPPER(RAZSOC)
BROWSE LAST
SCATTER memvar
SELECT 0
USE cctclien
USE O:\o-negocios\IDC\Data\cia001\cctclien.dbf
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
APPEND BLANK
GATHER memvar
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
BROWSE
SELECT 4
BROWSE LAST
SELECT 2
SELECT 0
SELECT 2
SEEK cctclien.codcli
SEEK cctclien.codaux
BROWSE LAST
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
SET ORDER TO GDOC11  desc && CODCLI+DTOS(FCHDOC)
SEEK cctclien.codaux
SELECT 4
BROWSE LAST
SELECT 1
SET FILTER TO codmat='02'
BROWSE
REPLACE preve2 WITH ROUND(preve2,1)
BROWSE FIELDS codmat,desmat,undstk, prevn1,prevn2,prevn3,preve1,preve2,preve3
BROWSE FIELDS codmat,desmat,undstk, prevn1,prevn2,prevn3,preve1,preve2,preve3 FONT "Lucida Console",8
BROWSE FIELDS codmat,desmat:40,undstk, prevn1,prevn2,prevn3,preve1,preve2,preve3 FONT "Lucida Console",8
BROWSE FIELDS codmat,desmat:40,undstk, prevn1:9,prevn2:9,prevn3:9,preve1:9,preve2:9,preve3:9 FONT "Lucida Console",8
BROWSE FIELDS codmat,desmat:50,undstk, prevn1:9,prevn2:9,prevn3:9,preve1:9,preve2:9,preve3:9 FONT "Lucida Console",8
BROWSE FIELDS codmat,desmat:50,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "Lucida Console",8
BROWSE FIELDS codmat,desmat:50,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "Lucida Console",9
BROWSE FIELDS codmat,desmat:50,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "TW CENT MT",9
BROWSE FIELDS codmat,desmat:60,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "TW CENT MT",9
BROWSE FIELDS codmat,desmat:60,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "TW CENT MT",10
BROWSE FIELDS codmat,desmat:50,undstk, prevn1:10,prevn2:10,prevn3:10,preve1:10,preve2:10,preve3:10 FONT "TW CENT MT",10
REPLACE prevn1 WITH ROUND(prevn1,1)
REPLACE prevn2 WITH ROUND(prevn2,1)
REPLACE preve1 WITH ROUND(preve1,1)
REPLACE preve2 WITH ROUND(preve2,1)
REPLACE prevn1 WITH ROUND(prevn1,1)
REPLACE prevn2 WITH ROUND(prevn2,1)
REPLACE preve1 WITH ROUND(preve1,1)
REPLACE preve2 WITH ROUND(preve2,1)
REPLACE ALL prevn1 WITH ROUND(prevn1,1),prevn2 WITH ROUND(prevn2,1),preve1 WITH ROUND(preve1,1),preve2 WITH ROUND(preve2,1) FOR codmat='02'
SET FILTER TO
BROWSE
set
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\clie_ant.dbf
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\clie_ant.dbf
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SET FILTER TO 'REY'$RAZSOC
BROWSE
SCATTER MEMVAR
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\cctclien.dbf
APPEND BLANK
GATHER MEMVAR
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
BROWSE
BROWSE FIELDS CLFAUX,CODAUX,CODCLI,RAZSOC,FPRICOM,FULTCOM
SELECT 0
USE GDOC_ANT
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
SELECT 3
SET FILTER TO 'PAULINA'$RAZSOC
BROWSE
SELECT 5
SET ORDER TO GDOC11  desc && CODCLI+DTOS(FCHDOC)
SEEK CLIE_ANT.codaux
BROWSE
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SET FILTER TO 'PAULINO'$RAZSOC
BROWSE LAST
SET RELATION TO codaux INTO GDOC_ANT
SCATTER memvar
SELECT 4
SCATTER memvar
SELECT 4
APPEND BLANK
GATHER memvar
SET FILTER TO 'LENI'$RAZSOC
SCATTER memvar
SELECT 4
APPEND BLANK
GATHER memvar
BROWSE LAST
SET FILTER TO 'GABY'$RAZSOC
SCATTER memvar
SELECT 4
APPEND BLANK
GATHER memvar
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 3
SET FILTER TO 'TAIPE'$RAZSOC
BROWSE LAST
SET FILTER TO 'TAIPE'$RAZSOC
SELECT 0
USE vtavpedi
SET ORDER TO VPED01   && NRODOC
SEEK '001127030'
BROWSE
SEEK '00127030'
BROWSE
SELECT 3
SEEK Gsclfcli+vtavpedi.codcli
BROWSE
SET FILTER TO
SEEK Gsclfcli+vtavpedi.codcli
BROWSE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK Gsclfcli+vtavpedi.codcli
SELECT 4
SEEK Gsclfcli+vtavpedi.codcli
BROWSE
SELECT 6
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
SELECT 3
SET FILTER TO 'TAIPE'$RAZSOC
BROWSE last
SET FILTER TO 'DAMIAN'$RAZSOC
SELECT 5
BROWSE LAST
SCATTER memvar
SELECT 4
BROWSE LAST
APPEND BLANK
GATHER memvar
SET FILTER TO 'PORRAS'$RAZSOC
SET FILTER TO 'DAMIAN'$RAZSOC
SET FILTER TO 'PORRAS'$RAZSOC
SCATTER memvar
APPEND BLANK
GATHER memvar
SET FILTER TO 'ACCESS'$RAZSOC
SET FILTER TO 'ACCES'$RAZSOC
SCATTER memvar
APPEND BLANK
GATHER memvar
SET FILTER TO 'ISMAEL'$RAZSOC
SCATTER MEMVAR
APPEND BLANK
GATHER memvar
SET FILTER TO 'ALVARADO'$RAZSOC
SET FILTER TO 'JORLUC'$RAZSOC
SET FILTER TO '20481126925'$codaux
SET FILTER TO '2048'$codaux
SET FILTER TO 'JORLUC'$RAZSOC
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant.dbf ALIAS gDOC_a2 AGAIN
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
SET RELATION TO CODAUX INTO GDOC_A2
SELECT
SELECT 0
USE vtarcoti
GO bott
BROWSE
SET FILTER TO 'NERI'$UPPER(RAZSOC)
SET STATUS bar ON
SET FILTER TO 'QUISPE'$UPPER(RAZSOC)
SET FILTER TO 'QUISPE'$UPPER(RAZSOC) AND 'ALVARADO'$UPPER(RAZSOC)
SCATTER memvar
SELECT CCTCLIEN
APPEND BLANK
GATHER memvar
SET FILTER TO
SEEK '10190967404'
SEEK GsClfCli+'10190967404'
SET FILTER TO 'BERJAYA'$UPPER(RAZSOC)
SCATTER memvar
SELECT CCTCLIEN
APPEND BLANK
GATHER memvar
SET FILTER TO 'VEGUZTI'$UPPER(RAZSOC)
SCATTER memvar
SELECT CCTCLIEN
APPEND BLANK
GATHER memvar
SEEK GsClfCli+'20557164554'
SET FILTER TO '20557164554'$UPPER(codaux)
SET FILTER TO '20451756851'$UPPER(codaux)
SET FILTER TO
SET FILTER TO 'RESEMIN'$UPPER(RAZSOC)
SCATTER memvar
SELECT CCTCLIEN
APPEND BLANK
GATHER memvar
SET FILTER TO 'QUINTO'$UPPER(RAZSOC)
SCATTER memvar
SELECT CCTCLIEN
APPEND BLANK
GATHER memvar
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\C2016\ALMCATGE ALIAS CATG
GO BOTT
BROWSE
SET FILTER TO  'NEW'$DESMAT
SET FILTER TO  'NEW'$UPPER(DESMAT)
SET FILTER TO
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant.dbf
SELECT 0
USE gdoc_ant ALIAS GDOC_A
set
SELECT 3
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant.dbf ALIAS GDOC_A
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\clie_ant ALIAS CLIE_A
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\cctclien ALIAS CLIE
SELECT 4
SELECT 3
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC) DESC
SELECT 4
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SET RELATION TO Clie_a.codcli INTO Gdoc_a ADDITIVE
SET RELATION to
SET RELATION TO Clie_a.codaux INTO Gdoc_a ADDITIVE
SET FILTER TO 'RUBER'$UPPER(RAZSOC)
SET FILTER TO 'RUBBER'$UPPER(RAZSOC)
SCATTER memvar
SELECT CLIE
APPEND BLANK
GATHER memvar
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SET FILTER TO 'MURRUGARRA'$UPPER(RAZSOC)
SELECT CLIE
APPEND BLANK
GATHER memvar
SCATTER memvar
SELECT CLIE
APPEND BLANK
GATHER memvar
SET FILTER TO 'TRADISAN'$UPPER(RAZSOC)
SET FILTER TO 'TRADI'$UPPER(RAZSOC)
SET FILTER TO '20455447888'%CODAUX
SET FILTER TO '20455447888'$CODAUX
SCATTER memvar
SELECT CLIE
APPEND BLANK
GATHER memvar
SET FILTER TO '20120550137'$CODAUX
SCATTER memvar
SELECT CLIE
APPEND BLANK
GATHER memvar
SET FILTER TO 
SET FILTER TO '20455447888'$CODAUX
DO FORM k:\aplvfp\classgen\forms\adm_accesos_seguridad.scx
SET FILTER TO 'EXPRESO'$UPPER(RAZSOC)
SET FILTER TO '20136876504'$CODAUX
SET FILTER TO '20505958625'$CODAUX
SET FILTER TO 'MOBILIA'$UPPER(RAZSOC)
SET FILTER TO '20505958625'$CODAUX
SET FILTER TO
SET FILTER TO 'CLAVE'$UPPER(RAZSOC)
SET ORDER TO GDOC11  desc && CODCLI+DTOS(FCHDOC)
SCATTER memvar
SELECT CLIE
APPEND BLANK
GATHER memvar
SELECT 0
USE vtarcoti
GO bott
BROWSE
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 0
USE vtavpedi
SET ORDER TO VPED01   && NRODOC
SEEK '00127101'
BROWSE
SELECT 0
SELECT * FROM gdoc_a WHERE codcli='20523202678' ORDER BY fchdoc
SELECT 0
USE item_ant ALIAS item_a
SET ORDER TO ITEM01   && CODDOC+NRODOC
SELECT * FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY fchdoc desc
SELECT gdoc_a.CodCli,gdoc_a.NomCli,gdoc_a.fchdoc,item_a.nro_itm,item_a.codmat,item_a.desmat,item_a.UndVta,item_a.canfac,item_a.facequ,item_a.Prevta,item_a.preuni,item_a.implin FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY fchdoc desc
SELECT gdoc_a.CodCli,gdoc_a.NomCli,gdoc_a.fchdoc,item_a.nro_itm,item_a.codmat,item_a.desmat,item_a.UndVta,item_a.canfac,item_a.facequ,item_a.Prevta,item_a.preuni,item_a.implin FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY gdoc_a.fchdoc desc
SELECT gdoc_a.CodCli AS RUC_DNI,gdoc_a.NomCli AS RAZON_SOC,gdoc_a.fchdoc AS FECHA,ICASE(gdoc_a.CodMon=1,'S/',gdoc_a.CodMon=2,'US$','NA') AS MONEDA,item_a.codmat AS Producto,item_a.desmat AS Nombre,item_a.UndVta,item_a.canfac,item_a.facequ,item_a.Prevta,item_a.preuni,item_a.implin FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY gdoc_a.fchdoc desc
SELECT gdoc_a.CodCli AS RUC_DNI,LEFT(gdoc_a.NomCli,40) AS RAZON_SOC,gdoc_a.fchdoc AS FECHA,ICASE(gdoc_a.CodMon=1,'S/',gdoc_a.CodMon=2,'US$','NA') AS MONEDA,item_a.codmat AS Producto,item_a.desmat AS Nombre,item_a.UndVta,item_a.canfac,item_a.facequ,item_a.Prevta,item_a.preuni,item_a.implin FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY gdoc_a.fchdoc desc
SELECT gdoc_a.CodCli AS RUC_DNI,LEFT(gdoc_a.NomCli,40) AS RAZON_SOC,gdoc_a.fchdoc AS FECHA,ICASE(gdoc_a.CodMon=1,'S/',gdoc_a.CodMon=2,'US$','NA') AS MONEDA,item_a.codmat AS Producto,item_a.desmat AS Nombre,item_a.UndVta,item_a.canfac as cantidad,item_a.facequ as Factor,item_a.Prevta as Pre_Venta,item_a.preuni as Pre_Unit,item_a.implin as Importe FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE codcli='20523202678' ORDER BY gdoc_a.fchdoc desc
SELECT gdoc_a.CodCli AS RUC_DNI,LEFT(gdoc_a.NomCli,40) AS RAZON_SOC,gdoc_a.fchdoc AS FECHA,ICASE(gdoc_a.CodMon=1,'S/',gdoc_a.CodMon=2,'US$','NA') AS MONEDA,item_a.codmat AS Producto,item_a.desmat AS Nombre,item_a.UndVta,item_a.canfac as cantidad,item_a.facequ as Factor,item_a.Prevta as Pre_Venta,item_a.preuni as Pre_Unit,item_a.implin as Importe FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE Gdoc_a.FlgEst<>'A' ORDER BY gdoc_a.fchdoc desc
SELECT gdoc_a.CodCli AS RUC_DNI,LEFT(gdoc_a.NomCli,40) AS RAZON_SOC,gdoc_a.fchdoc AS FECHA,ICASE(gdoc_a.CodMon=1,'S/',gdoc_a.CodMon=2,'US$','NA') AS MONEDA,item_a.codmat AS Producto,item_a.desmat AS Nombre,item_a.UndVta,item_a.canfac as cantidad,item_a.facequ as Factor,item_a.Prevta as Pre_Venta,item_a.preuni as Pre_Unit,item_a.implin as Importe FROM gdoc_a INNER JOIN item_a ON gdoc_a.coddoc+gdoc_a.nrodoc=item_a.coddoc+item_a.nrodoc WHERE Gdoc_a.FlgEst<>'A' ORDER BY gdoc_a.NomCli,gdoc_a.fchdoc DESC INTO TABLE O:\o-negocios\idc\data\cia001\ventas_old
SELECT 0
USE ventas_old
set
SELECT 0
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
USE O:\o-negocios\IDC\Data\cia001\clie_ant.dbf ALIAS clie_a
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant.dbf ALIAS GDOC_A
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\cctclien.dbf ALIAS CLIE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 4
SET RELATION TO Clie_a.codaux INTO Gdoc_a ADDITIVE
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 3
SET ORDER TO GDOC11 DESC  && CODCLI+DTOS(FCHDOC)
SET FILTER TO 'HUARAL'$UPPER(razsoc)
SCATTER memvar
APPEND BLANK
GATHER memvar
SET FILTER TO 'BARZOLA'$UPPER(razsoc)
SET FILTER TO 'HERMES'$UPPER(razsoc)
SELECT clie
SCATTER memvar
SELECT clie
SELECT clie
APPEND BLANK
GATHER memvar
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg
SET PROCEDURE TO  k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg additive
DO open_CXC_ANT
SET FILTER TO 'PANAMERICANA'$UPPER(razsoc)
SCATTER memvar
SELECT clie
APPEND BLANK
GATHER memvar
REPLACE codaux WITH SYS(3)
REPLACE codaux WITH SYS(2015)
SEEK CLIE_A.clfaux+Clie_A.codaux
SET FILTER TO '10407202487'$UPPER(CodAux)
SCATTER memvar
SELECT clie
APPEND BLANK
GATHER memvar
SET FILTER TO '20544786581'$UPPER(CodAux)
SET FILTER TO
SET STATUS bar ON
SET FILTER TO '20544786581'$UPPER(CodAux)
SET FILTER TO '20544786'$UPPER(CodAux)
SET FILTER TO '20544'$UPPER(CodAux)
SET FILTER TO '205447'$UPPER(CodAux)
SET FILTER TO 'MARGARITA'$UPPER(razsoc)
SET FILTER TO 'FILTRO'$UPPER(razsoc)
SET FILTER TO '10258528277'$UPPER(CodAux)
SET FILTER TO '10258528'$UPPER(CodAux)
SET FILTER TO '102585'$UPPER(CodAux)
SET FILTER TO '102585'$CodAux
SET FILTER TO
SET FILTER TO 'ALVARADO'$UPPER(razsoc)
SCATTER MEMVAR
SELECT clie
APPEND BLANK
GATHER memvar
SET FILTER TO 'CARDENAS'$UPPER(razsoc)
SET FILTER TO '20425386639'$UPPER(CodAux)
SCATTER MEMVAR
SELECT clie
APPEND BLANK
GATHER memvar
SET FILTER TO
SEEK GsClfCli+'20425386639'
SET FILTER TO '20440470638'$UPPER(CodAux)
SET FILTER TO
SET FILTER TO '20458775746'$UPPER(CodAux)
SELECT clie
APPEND BLANK
GATHER memvar
SEEK GsClfCli+'20458775746'
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SEEK GsClfCli+'20458775746'
SET ORDER TO
GO bott
SCATTER memvar
SELECT clie
APPEND BLANK
GATHER memvar
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
MODIFY FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
_cliptext=GsRuccia
SELECT 0
USE ccbrgdoc ALIAS gdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0010033169'
BROWSE
DO revisagdoc
SELECT 1
BROWSE LAST
SELECT 3
BROWSE LAST
SEEK 'ABONON/C '
SELECT 10
BROWSE LAST
SELECT 1
BROWSE LAST
CLOSE TABLES all
DO ?
SELECT 5
BROWSE LAST
x=PROGRAM()
?x
MODIFY COMMAND ?
CLOSE ALL
CLEAR ALL
MODIFY COMMAND O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SET FILTER TO 'FIBERMET'$UPPER(razsoc)
SELECT 3
SET ORDER TO GDOC11   && CODCLI+DTOS(FCHDOC)
SET ORDER TO GDOC11  desc && CODCLI+DTOS(FCHDOC)
SELECT 4
SET RELATION TO CODAUX INTO GDOC_A
SCATTER memvar
APPEND BLANK
GATHER memvar
SET FILTER TO 'ORTIZ'$UPPER(razsoc)
SCATTER memvar
APPEND BLANK
GATHER memvar
MODIFY FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
SELECT 3
USE
SELECT 4
USE
SELECT 5
USE
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\funvta_vtamtabl_detalle.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
RESUME
MODIFY PROJECT "\\servidor2-idc\dev\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY form k:\aplvfp\bsinfo\forms\funcct_cat_clientes.scx
DO "\\servidor2-idc\dev\aplvfp\bsinfo\progs\inicio_idc.prg"
CD k:\aplvfp\bsinfo
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
SELECT 4
SET RELATION TO CODAUX INTO GDOC_a
SELECT 3
SET ORDER TO GDOC11  DESCENDING  && CODCLI+DTOS(FCHDOC)
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SET FILTER TO 'CONTRATISTAS'$UPPER(razsoc)
SCATTER MEMVAR
APPEND BLANK
GATHER memvar
SET FILTER TO 'MORILLO'$UPPER(razsoc)
SCATTER MEMVAR
SELECT Clie
APPEND BLANK
GATHER memvar
SET FILTER TO
SEEK '001'+CLie_a.codaux
SELECT 0
USE cia001!vtavpedi
USE cia001!vtavpedi ALIAS VPED
SELECT 0
USE cia001!vtarpedi ALIAS RPED
SET ORDER TO rped01
set
SELECT 5
SELECT 6
SET RELATION TO Vped.nrodoc INTO Rped ADDITIVE
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT 0
USE empresas
BROWSE LAST
DO ?
SELECT 1
BROWSE LAST
SELECT 0
USE ccbrgdoc ALIAS GDOC2
USE ccbrgdoc ALIAS GDOC2 AGAIN
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SELECT 0
USE vtaritem ALIAS item2 AGAIN
SELECT 5
SELECT 7
SELECT 6
SET RELATION TO Gdoc2.coddoc+ Gdoc2.nrodoc INTO Item2 ADDITIVE
BROWSE LAST
SELECT 7
BROWSE LAST
seek 'CARGOFACT0010033874'
SET DELETED OFF
seek 'CARGOFACT0010033874'
SELECT 7
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\gdoc_ant ALIAS gdoc_a
SET ORDER TO GDOC11 desc  && CODCLI+DTOS(FCHDOC)
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\CLIE_ant.dbf ALIAS CLIE_A
SET ORDER TO CLIEN01   && CODCLI
GO bott
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\cctCLIEn.dbf ALIAS CLIE
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 9
SET RELATION TO CODAUX INTO Gdoc_a
BROWSE LAST
SET DELETED ON
SELECT 8
BROWSE LAST
SELECT 10
BROWSE LAST
SET FILTER TO 'CARROCERIAS HL'$UPPER(razsoc)
SET FILTER TO
SET FILTER TO 'CARROCERIAS HL'$UPPER(razsoc)
SCATTER memvar
SELECT clie_a
APPEND BLANK
GATHER memvar
APPEND BLANK
GATHER memvar
x='131'
importe=507.45
letraimporte1=507.45
xcanje1='131'
xcanje2='127'
letraimporte=2707.16
letraimporte2=2707.16
xcanje3='126'
letraimporte3=3046.11
SELECT 10
SELECT 1
BROWSE LAST
CLOSE DATABASES all
DO revisagdoc
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\ccbntasg ALIAS tasg
SET ORDER TO TASG01   && CODDOC+NRODOC
GO bott
BROWSE
SELECT 17
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\ccbrtasg.dbf
SET DATABASE to CIA001
USE cia001!ccbnrasg ALIAS RASG
SET ORDER TO RASG01   && CODDOC+NRODOC+TPOREF+CODREF+NROREF
SELECT 17
SELECT 18
BROWSE LAST
MODIFY COMMAND revisagdoc
SELECT 17
SELECT 18
BROWSE
SELECT 17
BROWSE LAST
SELECT 18
SET RELATION TO CodDoc+NroDoc INTO TASG
BROWSE LAST
SET RELATION TO Tporef+CodRef+NroRef INTO GDOC additive
SELECT 17
BROWSE LAST
SELECT 1
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 15
BROWSE LAST
SELECT 17
SELECT 18
MODIFY COMMAND o:\o-negocios\IDC\Data\revisagdoc.PRG
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_depura_ccb.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 4
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SET FILTER TO '10089306502'$codaux
SELECT 3
SET ORDER TO  GDOC11 DESC  && CODCLI+DTOS(FCHDOC)
SET RELATION TO Codcli INTO gdoc_a
SET FILTER TO
SET RELATION TO codaux INTO gdoc_a
SET FILTER TO '10089306502'$codaux
SCATTER memvar
APPEND BLANK
GATHER memvar
SET FILTER TO 'GARAY'$UPPER(nomaux)
SET FILTER TO 'GARAY'$UPPER(RAZSOC)
SET FILTER TO
SCATTER memvar
SELECT 5
APPEND BLANK
GATHER memvar
SET FILTER TO
SET FILTER TO '16722964'$codaux
SET FILTER TO 'SOPLA'$UPPER(RAZSOC)
SET FILTER TO '16722964'$codaux
BROWSE last
SET FILTER TO
SET FILTER TO 'SOPLA'$UPPER(RAZSOC)
SCATTER MEMVAR memo
SELECT clie
APPEND BLANK
GATHER memvar
CLOSE DATABASES all
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_compañias.scx
DO FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
DO FORM k:\aplvfp\bsinfo\forms\cbd_cierre_mensual.scx
DO FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
CREATE PROJECT
MODIFY COMMAND ?
REPORT FORM k:\aplvfp\bsinfo\reports\funfun_cat_distritos.frx PREVIEW
MODIFY REPORT k:\aplvfp\bsinfo\reports\funfun_cat_distritos.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funcmp_cat_proveedores.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funcct_cat_clientes.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funcbd_cat_activo_fijo.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_valorizacion_x_almacen.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_valorizacion_general.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_stock_consolidado.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_materiales_x_almacen.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_materiales_stock_cero.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_materiales_bajo_stock_reposicion.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_materiales_bajo_stock_minimo.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_kardex_x_almacen.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_kardex_general.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_ingresos_valorizados.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_existencias_x_almacen_lote.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_existencias_x_almacen.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_existencias_generales_x_serie.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_existencias_generales_x_lote.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_existencias_generales.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_div_familia.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_correlativo_gral_docs.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_correlativo_de_documentos.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_control_de_documentos3.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_control_de_documentos.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_config_salidas.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_config_ingresos.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_chequeo_transacciones.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_cat_materiales.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\funalm_cat_almacenes.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpi_resumeno_t.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpi_formulacion_02.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpi_formulacion_01.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiivpuib.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpi_formulacion_01.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiivpuib.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiivpui.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiistdr.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiivpui.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiistdr.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiicmxm.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiicmd1.frx
MODIFY REPORT k:\aplvfp\bsinfo\reports\cpiistdr.frx
MODIFY PROJECT "\\servidor2-idc\dev\aplvfp\bsinfo\proys\o-nv.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-nv.pjx"
MODIFY PROJECT "\\servidor2-idc\dev\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE cia001!cbdmtabl
SET ORDER TO TABL01   && TABLA+CODIGO
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cjabco.scx
DO k:\aplvfp\bsinfo\progs\cja_cjac2mov.prg
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
SELECT 0
DO ?
SELECT 5
BROWSE LAST
SELECT 2
BROWSE LAST
SET DELETED OFF
SET DELETED ON
SELECT 2
SELECT 0
USE almdtran ALIAS dtra2
USE almdtran ALIAS dtra2 AGAIN
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010027079'
BROWSE LAST
SEEK 'G/R 001002707'
SET FILTER TO nrorfb='00128259'
BROWSE
SELECT 0
BROWSE LAST
USE
SELECT 2
SELECT 5
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 0
USE o:\o-negocios\IDC\data\CIA001\C2016\almCtran.DBF ALIAS ctra2
USE o:\o-negocios\IDC\data\CIA001\C2016\almCtran.DBF ALIAS ctra2 AGAIN
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SEEK '001SY0212'
BROWSE
SET FILTER TO INLIST(nrodoc,'12')
SELECT 5
BROWSE LAST
SELECT 6
BROWSE LAST
SET FILTER TO iNLIST(nrodoc,'12')
SET FILTER TO iNLIST(nrodoc,'120000000')
SET FILTER TO iNLIST(nrodoc,'120000000') AND codmov='Y02'
SELECT 5
BROWSE LAST
SELECT 1
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 1
BROWSE LAST
SELECT 6
BROWSE LAST
SET FILTER TO
SET ORDER TO DTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0)
SELECT 3
BROWSE LAST
SELECT 1
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 5
SELECT 6
BROWSE LAST
SELECT 1
BROWSE LAST
USE
SELECT 7
USE
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 2
USE
SELECT 3
USE
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
CANCEL
MODIFY FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
CD ?
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funalm_transacciones_vta.scx
CLOSE DATABASES all
USE almdtran EXCLUSIVE
USE o:\o-negocios\IDC\data\CIA001\C2016\almCtran.DBF EXCLUSIVE
USE o:\o-negocios\IDC\data\CIA001\C2016\almDtran.DBF EXCLUSIVE
USE o:\o-negocios\IDC\data\CIA001\C2016\almCtran.DBF EXCLUSIVE
USE o:\o-negocios\IDC\data\CIA001\C2016\almDtran.DBF EXCLUSIVE
USE o:\o-negocios\IDC\data\CIA001\C2016\almCtran.DBF EXCLUSIVE
REINDEX
PACK
SELECT 0
USE o:\o-negocios\IDC\data\CIA001\C2016\almdtran.DBF EXCLUSIVE
PACK
REINDEX
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
CLOSE ALL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SET DEFAULT TO "o:\o-negocios\idc\data"
DO revisagdoc.prg
SEEK 'CARGOBOLE0010002898'
SET FILTER TO nroast='11000122' AND DTOS(fchdoc)='2016'
SET FILTER TO
SEEK 'CARGOBOLE0010002898'
CLOSE ALL
QUIT
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY FORM k:\aplvfp\bsinfo\forms\cbd_ple_generar_arc_txt.scx
MODIFY PROJECT "\\servidor2-idc\dev\aplvfp\bsinfo\proys\o-n-vt.pjx"
CD ?
MODIFY COMMAND config.ini
CD ?
MODIFY COMMAND config.fpw
MODIFY COMMAND config2.fpw
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdvmovm
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n-vt.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdvmovm
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdrmovm ALIAS rmov
set
SELECT 3
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST
SEEK '0200202000029'
BROWSE
SELECT rmov
SEEK '0200202000029'
SET ORDER to RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0200202000029'
BROWSE
SEEK '0200202000028'
BROWSE
SET DELETED 0ff
SET DELETED off
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2016\CBDMCTAS.dbf
SET ORDER TO CTAS01   && CODCTA
SEEK '104'
BROWSE
SET DELETED ON
SELECT 4
SEEK '0201102000014'
BROWSE LAST
SEEK '0201102000026'
SET DELETED OFF
SET DELETED ON
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbltrrn.prg AS 1252
SEEK '0201102000021'
SET DELETED OFF
BROWSE
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg AS 1252
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cbd_diariogeneral.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbcjap1.prg AS 1252
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
BROWSE LAST
CANCEL
CLOSE TABLES all
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg AS 1252
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
BROWSE LAST
RESUME
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ctb.prg AS 1252
RESUME
SELECT 17
BROWSE LAST
SELECT 10
BROWSE LAST
RESUME
USE cia001!ccbmvtos
USE cia001!ccbmvtos EXCLUSIVE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE cia001!ccbmvtos EXCLUSIVE
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE cia001!ccbmvtos EXCLUSIVE
PACK
USE cia001!ccbrgdoc EXCLUSIVE
PACK
USE cia001!vtaritem EXCLUSIVE
PACK
USE cia001!vtarpedi EXCLUSIVE
PACK
USE cia001!vtavpedi EXCLUSIVE
PACK
USE cia001!vtavprof
USE cia001!vtavprof EXCLUSIVE
PACK
USE cia001!vtarprof EXCLUSIVE
USE cia001!ccbntasg EXCLUSIVE
PACK
USE cia001!ccbrtasg EXCLUSIVE
USE cia001!ccbnrasg
USE cia001!ccbnrasg EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2017\almctran EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2017\almdtran EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdvmovm EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdrmovm EXCLUSIVE
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdrmovm EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdvmovm EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\almdtran EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\almctran EXCLUSIVE
PACK
CLOSE TABLES all
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbtbdoc.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbtbdoc.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
BROWSE LAST
RESUME
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdrmovm.dbf
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0401104000006'
BROWSE
SET DELETED OFF
SET DELETED ON
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbtbdoc.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbcjlt1.prg
RESUME
APPEND BLANK
RESUME
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdvmovm.dbf
GO top
BROWSE
SET DELETED OFF
BROWSE
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdvmovm.dbf EXCLUSIVE
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdrmovm.dbf EXCLUSIVE
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST
GO top
BROWSE
PACK
BROWSE
DELETE ALL FOR CODOPE='000' AND NROMES='00'
PACK
USE o:\o-negocios\IDC\Data\cia001\c2016\cbdvmovm.dbf EXCLUSIVE
DELETE ALL FOR CODOPE='000' AND NROMES='00'
PACK
CLOSE TABLES ALL
USE o:\o-negocios\IDC\Data\cia001\c2017\cbdvmovm.dbf EXCLUSIVE
BROWSE
USE
MODIFY REPORT ?
MODIFY PROJECT "\\servidor2-idc\dev\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY COMMAND ?
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
?SYS(5)
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CANCEL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY CLASS admnovis
?CURDIR()
?SET('path')
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE sedes
BROWSE
MODIFY MENU k:\aplvfp\bsinfo\menus\funvtam00.mnx
MODIFY MENU k:\aplvfp\bsinfo\menus\funalmm00.mnx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_cat_predios.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_cat_predios.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE cia001!vtaptovt
BROWSE
USE
SELECT 0
USE vtatdocm
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\vta_vtap3200.scx
USE cia001!vtaptovt
BROWSE
BROWSE LAST
USE
SELECT 0
USE p0012017!almcatal
SELECT 0
USE cia001!almtalma
BROWSE
SELECT 3
COPY TO cata001005 TYPE FOX2X FOR INLIST(subalm,'001','005')
?CURDIR()
use cata001005 IN 0 newsub
use cata001005 IN 0 ALIAS newsub
use o:\o-negocios\idc\data\cia001\cata001005 IN 0 ALIAS newsub
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
REPLACE ALL subalm WITH '011' FOR subalm='001'
SELECT 4
BROWSE LAST
REPLACE ALL subalm WITH '012' FOR subalm='005'
SELECT 4
BROWSE LAST
REPLACE ALL codsed WITH '002'
USE
SELECT 4
USE
SELECT 3
USE
use o:\o-negocios\idc\data\cia001\cata001005 IN 0 ALIAS newsub
BROWSE
REPLACE ALL stkini WITH 0, stkact WITH 0
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2017\almcatal.dbf
APPEND FROM o:\o-negocios\idc\data\cia001\cata001005
USE
SELECT 3
USE
USE O:\o-negocios\IDC\data\cia001\c2017\almcftra.dbf
CD ?
USE O:\o-negocios\IDC\data\cia001\c2017\almcftra.dbf ALIAS cftr
brow
SET ORDER TO CFTR01   && TIPMOV+CODMOV
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2017\almcdocm.dbf ALIAS CDOC
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\vtatdocm ALIAS TDOC
BROWSE
SELECT 1
SELECT 3
BROWSE LAST
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO ?
SELECT 5
MODIFY COMMAND ?
DO O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
SELECT 1
BROWSE LAST
SEEK 'CARGOFACT002'
SELECT 6
BROWSE LAST
SELECT 2
BROWSE LAST
SELECT 5
BROWSE LAST
SEEK 'FACTF02'
SELECT 1
BROWSE LAST
SELECT 6
BROWSE LAST
USE vtavguia
set
SELECT 3
BROWSE LAST
SELECT 2
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2017\almctran.dbf ALIAS ctra
GO bott
BROWSE
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
CLOSE ALL
QUIT
DO O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
SELECT 2
SELECT 1
SELECT 0
USE vtavpedi
GO bott
BROWSE
SET ORDER TO VPED01   && NRODOC
SELECT 0
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
GO bott
BROWSE
SELECT 5
BROWSE LAST
SELECT 2
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 1
BROWSE LAST
CLOSE ALL
DO ?
USE O:\o-negocios\IDC\Data\cia001\c2017\almctran.dbf
MODIFY STRUCTURE
USE
CLOSE DATABASES all
USE O:\o-negocios\IDC\Data\cia001\c2017\almctran.dbf EXCLUSIVE
PACK
DELETE TAG all
USE O:\o-negocios\IDC\Data\cia001\c2017\almdtran.dbf EXCLUSIVE IN 0
SELECT 2
DELETE TAG all
USE O:\o-negocios\IDC\Data\cia001\c2017\almcatge.dbf EXCLUSIVE IN 0
SELECT 3
DELETE TAG all
USE O:\o-negocios\IDC\Data\cia001\c2017\almcatal.dbf EXCLUSIVE IN 0
SELECT 4
DELETE TAG all
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2017\almcdocm.dbf EXCLUSIVE IN 0
BROWSE LAST
SET ORDER TO CDOC01   && SUBALM+TIPMOV+CODMOV
BROWSE LAST
SELECT 2
BROWSE LAST
GO bott
SET DELETED OFF
PACK
SELECT 4
PACK
SELECT 3
PACK
SELECT 1
PACK
CLOSE ALL
OPEN DATABASE p:\o-negocios\idc\data\p0012017.dbc EXCLUSIVE
OPEN DATABASE o:\o-negocios\idc\data\p0012017.dbc EXCLUSIVE
VALIDATE database
CLOSE ALL
OPEN DATABASE o:\o-negocios\idc\data\cia001.dbc EXCLUSIVE
VALIDATE database
CLOSE ALL
SELECT 0
USE o:\O-NEGOCIOS\IDC\DATA\cia001\cbdcnfg1
BROWSE
SET DELETED ON
PACK
USE o:\O-NEGOCIOS\IDC\DATA\cia001\cbdcnfg1 EXCLUSIVE
PACK
SELECT 0
USE o:\O-NEGOCIOS\IDC\DATA\sistcdxs ALIAS cdxs
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
SEEK "CONTABIL  CBDCNFG1"
BROWSE
SELECT 1
USE
USE o:\O-NEGOCIOS\IDC\DATA\cia001\cbdcnfg1.dbf
SET ORDER TO NIVCTA   && NIVCTA
SELECT 2
BROWSE LAST
SELECT 1
USE o:\O-NEGOCIOS\IDC\DATA\cia001\cbdcnfg1.dbf EXCLUSIVE
INDEX on nrodig TAG nrodig
SET DATABASE TO CIA001
CLOSE DATABASES
OPEN DATABASE o:\o-negocios\idc\data\cia001.dbc EXCLUSIVE
VALIDATE database
CLOSE ALL
USE o:\O-NEGOCIOS\IDC\DATA\cia001\ccbrgdoc EXCLUSIVE
DELETE TAG all
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtaritem EXCLUSIVE
DELETE TAG all
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtavguia EXCLUSIVE
DELETE TAG all
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtavpedi EXCLUSIVE
DELETE TAG all
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtarpedi EXCLUSIVE
DELETE TAG all
CLOSE ALL
SELECT 0
USE o:\O-NEGOCIOS\IDC\DATA\sistdbfs
SET ORDER TO ARCHIVO   && ARCHIVO
SEEK "VENTAS"
BROWSE
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO
SEEK "VENTAS"
BROWSE
USE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY MENU k:\aplvfp\bsinfo\menus\funalmm00.mnx
do F1_index with 'VENTAS'
USE ccbrgdoc EXCLUSIVE
PACK
CLOSE DATABASES all
OPEN DATABASE o:\o-negocios\idc\data\cia001.dbc EXCLUSIVE
VALIDATE database
do F1_index with 'VENTAS'
SELECT 0
USE sistcdxs
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
BROWSE
SET FILTER TO archivo="VTA"
SELECT 0
USE SISTDBFS
SET FILTER TO archivo="VTA"
BROWSE
SET DELETED ON
USE
SELECT 1
USE
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtavPROF EXCLUSIVE
DELETE TAG ALL
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtarPROF EXCLUSIVE
DELETE TAG ALL
CLOSE ALL
do F1_index with 'VENTAS'
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
do F1_index with 'VENTAS'
USE cia001!vtatdocm EXCLUSIVE
BROWSE
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
SET ORDER TO DOCM02   && SEDE+PTOVTA
DELETE TAG all
do F1_index with 'VENTAS'
SELECT 1
USE
do F1_index with 'VENTAS'
USE vtatdocm EXCLUSIVE
INDEX on SEDE+CODDOC+PTOVTA TAG  DOCM01   && 
INDEX on SEDE+PTOVTA TAG  DOCM02   &&
SELECT 0
USE sistcdxs
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
SEEK "VENTAS"
BROWSE
SEEK "COBRAR"
SET FILTER TO archivo="VTA"
USE
SELECT 1
USE
CLOSE DATABASES ALL
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE ccbrgdoc
GO bott
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT00200000061'
BROWSE
SEEK 'CARGOFACT0020000061'
USE
CLOSE DATABASES all
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf
SET FILTER TO "RIVERA"$NOMCLI
BROWSE
SELECT 0
USE sedes
USE o:\O-NEGOCIOS\IDC\DATA\cia001\sedes.dbf
USE O:\o-negocios\IDC\Data\cia001\sedes.dbf EXCLUSIVE
MODIFY STRUCTURE
USE o:\O-NEGOCIOS\IDC\DATA\cia001\sedes.dbf
MODIFY STRUCTURE
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms\fungen2_principal.scx
SET DEFAULT TO "\\servidor2-idc\dev\aplvfp"
DO limpiar.prg
CLEAR
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\fungen2_principal.scx
SET SYSMENU TO defa
USE O:\o-negocios\IDC\Data\cia001\sedes.dbf EXCLUSIVE
MODIFY STRUCTURE
BROWSE LAST
COPY TO C:\TEMP\XXX TYPE FOX2X
SELECT 0
USE C:\TEMP\XXX 
BROWSE
USE
SELECT 37
BROWSE LAST
USE
COPY TO C:\TEMP\SEDES_BK TYPE FOX2X
USE O:\o-negocios\IDC\Data\cia001\sedes.dbf 
COPY TO C:\TEMP\SEDES_BK TYPE FOX2X
USE
USE sedes
BROWSE
USE
USE O:\o-negocios\IDC\Data\cia001\sedes.dbf 
COPY TO C:\TEMP\SEDES_BK TYPE FOX2X
USE
SELECT 0
USE sedes
BROWSE
SELECT 0
USE ccbrgdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOBOLE002'
BROWSE
SELECT 0
USE cctclien
SET ORDER TO CLIEN01   && CODCLI
SEEK '10421801555'
SET ORDER TO CLIEN03   && NRORUC
SEEK '10421801555'
BROWSE
SELECT 4
BROWSE LAST
SELECT 5
USE
SELECT 4
SELECT 3
USE
SELECT 4
BROWSE LAST
SELECT 0
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0020000065'
SEEK 'CARGOBOLE002'
SEEK 'CARGOFACT0020000065'
SELECT 0
MODIFY COMMAND O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
MODIFY COMMAND O:\o-negocios\IDC\data\vta_enlace_guia_almacen.prg
MODIFY COMMAND ?
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2017\almdtran ALIAS dtra
DO "o:\o-negocios\idc\data\vta_enlace_factura_almacen.prg"
SELECT 1
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 2
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 1
SEEK 'CARGOFACT002'
REPLACE ALL subalm WITH '011' FOR coddoc+nrodoc='FACT002'
SELECT 6
REPLACE ALL subalm WITH '011' FOR coddoc+nrodoc='FACT002'
SELECT 0
USE ALMTALMA ALIAS ALMA
SET ORDER TO ALMA01   && SUBALM
BROWSE
SELECT 1
SEEK 'CARGOBOLE002'
SELECT 1
BROWSE LAST
CLOSE TABLES all
DO ?
SELECT 1
BROWSE LAST
DO ?
MODIFY COMMAND ?
DO "o:\o-negocios\idc\data\revisagdoc2.prg"
SELECT 3
BROWSE LAST
SELECT 10
BROWSE LAST
SELECT 11
BROWSE LAST
SELECT 11
BROWSE LAST
SELECT 12
BROWSE LAST
SEEK 'CARGOFACT00100036231'
SEEK 'CARGOFACT0010036231'
SET DELETED OFF
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs\ccb_ccbr4600.prg
DO k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg AS 1252
DO k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg
CANCEL
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg AS 1252
DO k:\aplvfp\bsinfo\progs\ccb_ccbregen.prg
RESUME
USE ccbrgdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0010036231'
BROWSE
USE
CLOSE DATABASES all
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
USE o:\o-negocios\idc\data\cia001\cbdmauxi
CD ?
USE o:\o-negocios\idc\data\cia001\cbdmauxi
USE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx
SELECT 0
USE  o:\o-negocios\idc\data\cia001\c2018\almctran ALIAS ctra
BROWSE
MODIFY STRUCTURE
USE  o:\o-negocios\idc\data\cia001\c2017\almctran ALIAS ctra
MODIFY PROCEDURE
MODIFY STRUCTURE
USE  o:\o-negocios\idc\data\cia001\c2018\almctran ALIAS ctra EXCLUSIVE
MODIFY PROCEDURE
MODIFY STRUCTURE
MODIFY PROCEDURE
CLOSE TABLES all.
CLOSE DATABASES all
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE o:\o-negocios\idc\data\cia001\c2017\cbdrmovm.dbf
GO bott
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SET ORDER TO RMOV10   && CODOPE+NRODOC
SEEK '007E001-15'
BROWSE
SEEK '007E001'
BROWSE
SET ORDER TO RMOV06   && CODCTA+CODAUX+NRODOC+NROMES+DTOC(FCHDOC,1)+CODOPE+NROAST
MODIFY FORM k:\aplvfp\bsinfo\forms2\cja_cjaccpag1.scx
DO FORM k:\aplvfp\bsinfo\forms2\cja_cjaccpag2.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cja_cjaccpag.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cja_cjaccpag1.scx
DO k:\aplvfp\bsinfo\progs2\cja_cjac2mov.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cja_cjac2mov.prg
RESUME
BROWSE LAST
CLOSE TABLES all
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY PROJECT ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO ?
SELECT 4
SELECT 1
BROWSE LAST
SELECT 6
SELECT 3
BROWSE LAST
SELECT 2
BROWSE LAST
DO ?
SELECT 2
BROWSE LAST
MODIFY COMMAND ?
DO O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
MODIFY COMMAND O:\o-negocios\IDC\data\vta_enlace_guia_factura.prg
DO "o:\o-negocios\idc\data\vta_enlace_guia_factura.prg"
SELECT 5
BROWSE LAST
MODIFY PROCEDURE
SELECT 5
BROWSE LAST
SELECT 2
BROWSE LAST
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
BROWSE LAST
RESUME
USE cbdmauxi
MODIFY STRUCTURE
?LUPDATE()
USE cbdmauxi EXCLUSIVE
CLOSE DATABASES all
USE o:\o-negocios\idc\data\cia001\cbdmauxi.dbf
USE o:\o-negocios\idc\data\cia001\cbdmauxi.dbf EXCLUSIVE
MODIFY STRUCTURE
USE
SELECT 0
USE o:\o-negocios\idc\data\cia001\ccbrgdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0020000266'
BROWSE
SEEK 'CARGOBOLE002'
USE
SELECT 0
USE o:\o-negocios\idc\data\cia001\ccbrgdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0020000266'
BROWSE
USE
CLOSE DATABASES all
USE O:\o-negocios\IDC\Data\cia001\c2018\almctran.dbf
CD ?
USE O:\o-negocios\IDC\Data\cia001\c2018\almctran.dbf
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029633'
BROWSE
USE O:\o-negocios\IDC\Data\cia001\c2018\almdtran.dbf IN 0 ALIAS dtra
SELECT dtra
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029633'
BROWSE
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
DO "\\servidor2-idc\dev2\aplvfp\bsinfo\progs\inicio_idc.prg"
DO FORM "\\servidor2-idc\dev2\aplvfp\bsinfo\forms\funfun_selec_almacen.scx"
DO FORM "\\servidor2-idc\dev2\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx"
DO FORM "\\servidor2-idc\dev2\aplvfp\bsinfo\forms2\funvta_vtacdocm.scx"
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
DO "k:\aplvfp\bsinfo\progs\inicio_idc.prg"
DO FORM "k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx"
DO FORM "k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx"
SELECT 0
USE vtarpedi
SET ORDER TO RPED01   && NRODOC
SEEK '00130481'
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\vtavpedi.dbf
SET ORDER TO VPED04   && DTOS(FCHDOC)+CODVEN+NRODOC
SEEK '00130481'
BROWSE
SET ORDER TO VPED01   && NRODOC
SEEK '00130481'
EDIT
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
RESUME
CD ?
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
USE O:\o-negocios\IDC\Data\cia001\c2018\cbdrmovm.dbf  ALIAS rmov
MODIFY STRUCTURE
USE
USE cia001!cbdmtabl
SET ORDER TO TABL01   && TABLA+CODIGO
SEEK 'NA'
BROWSE
USE
CLOSE ALL
CLEAR ALL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\ccb_ccbnabo1.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\ccb_ccbnabo1.prg
RESUME
SELECT 0
USE ccbrgdoc
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
'ACARGOFACT002'
SEEK 'ACARGOFACT002'
BROWSE
SET ORDER TO
SET FILTER TO flgest='A' AND TPODOC+CODDOC+NRODOC='CARGOFACT002'
BROWSE
USE
SELECT 0
USE ccbrgdoc
GO bott
BROWSE
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,sdodoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'ABONON/C'
SEEK 'ABONORETC'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,sdodoc,codref,nroref
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,sdodoc,codref,nroref FONT 'Lucida Console', 8
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,tpocmb,sdodoc,codref,nroref FONT 'Lucida Console', 8
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SEEK 'ACARGOFACT002'
BROWSE
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,tpocmb,sdodoc,codref,nroref FONT 'Lucida Console', 8
SET FILTER TO flgest='A' AND TPODOC+CODDOC+NRODOC='CARGOFACT002'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:30,fchvto,fchemi,nromes,codope,nroast,flgest,imptot,tpocmb,sdodoc,codref,nroref FONT 'Lucida Console', 8
SET FILTER TO
DO ?
SELECT 5
BROWSE LAST
?DBF()
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
CLOSE ALL
DO ?
USE o:\O-NEGOCIOS\IDC\DATA\cia001\c2018\almctran.dbf  EXCLUSIVE
DELETE TAG all
PACK
USE
USE o:\O-NEGOCIOS\IDC\DATA\cia001\c2018\almdtran.dbf  EXCLUSIVE
DELETE TAG all
PACK
USE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_almacen.scx
DO f1_index WITH  'ALMACEN'
SELECT 0
USE almctran ALIAS ctran
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029740'
BROWSE
SELECT 0
USE vtavguia
USE o:\O-NEGOCIOS\IDC\DATA\cia001\vtavguia.dbf
SET ORDER TO VGUI01   && CODDOC+NRODOC
GO bott
BROWSE
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
USE vtavguia
USE  O:\o-negocios\IDC\Data\cia001\vtavguia.dbf
GO bott
BROWSE
USE
DO k:\aplvfp\bsinfo\progs2\ccb_ccbr4700.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbr4600.prg
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cjabco.scx
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbr4600.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cjabco.scx
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
DO FORM k:\aplvfp\bsinfo\forms2\cja_ingreso_cobranza.scx
SELECT 0
USE ccbmvtos ALIAS vtos
SET ORDER TO VTOS05   && CODCLI+CODREF+NROREF
SET ORDER to VTOS03   && CODREF+NROREF+CODDOC+CODOPE+NROAST
SEEK 'FACT0020000296'
BROWSE
SELECT 0
USE p0012018!cbdrmovm ALIAS rmov
SET ORDER TO RMOV07   && NROMES+CODOPE+NROAST+CODCTA
SEEK '0301003000031'
BROWSE
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
DO FORM k:\aplvfp\bsinfo\forms2\cja_ingreso_cobranza.scx
DO FORM k:\aplvfp\bsinfo\forms2\cbd_cbddfcmb.scx
DO k:\aplvfp\bsinfo\progs2\cbd_cbddfcmb.prg
SELECT 0
USE ?
BROWSE LAST
USE
USE ?
BROWSE LAST
?LUPDATE()
CLOSE DATABASES all
MODIFY REPORT ?
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE sedes
BROWSE
?gscodsed
?gsdirsed
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
CLOSE ALL
CLEAR ALL
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
?GsNomsed
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
?GsNomsed
?GsNomsed(1)
?GsNomsed
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
?gocfgvta.msedes
?gocfgvta.msedes(1)
?gocfgalm.msedes(1)
?gocfgalm.msedes(1,2)
?gocfgalm.msedes(2,2)
=ocfgvta.cargaredes
gocfgvta.cargaredes
gocfgvta.cargasedes
?gocfgvtasedes(2,2)
?gocfgvta.msedes(2,2)
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
SELECT 0
USE sedes
BROWSE
BROWSE LAST
MODIFY FORM k:\aplvfp\bsinfo\forms2\funcct_cat_clientes.scx
?gocfgvta.msedes(2,3)
?gocfgvta.msedes(2,1)
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
?gocfgalm.msedes(2,1)
?gocfgvta.msedes(2,2)
?gocfgalm.msedes(2,2)
?gocfgalm.msedes(2,3)
?gocfgalm.msedes(1,3)
?gocfgalm.msedes(2,4)
?gocfgalm.msedes(2,5)
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
USE SEDES
COUNT TO NSEDES
DIMENSION M.SEDES(NSEDES,5)
COPY TO ARRAY THIS.mSedes FIELDS LIKE C*,N*,A*,Cod_Sunat,Dir_Sunat
COPY TO ARRAY mSedes FIELDS LIKE C*,N*,A*,Cod_Sunat,Dir_Sunat
?ALEN(MSEDES,1)
BROWSE LAST
USE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
?gocfgvta.msedes(2,5)
?gocfgvta.msedes(2,3)
?gocfgvta.msedes(1,3)
?gocfgalm.msedes(1,3)
?gocfgalm.msedes(2,5)
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
?gocfgvta.msedes(2,5)
?gocfgvta.msedes(2,4)
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
USE sedes
BROWSE
USE
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc ORDER gdoc01
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SEEK 'ACARGOFACT002000001'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,codcli,nomcli:20,flgest,sdodoc,impbto,imptot,nroref
SEEK 'ACARGOFACT0010000001'
SEEK 'ACARGOFACT001000001'
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_cbdrc003.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_browse_ctacte_1.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdrc003.prg AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_diario_simplificado.scx
SELECT 0
USE CBDRMOVM ALIAS RMOV ORDER RMOV01
USE O:\o-negocios\IDC\Data\cia001\C2018\CBDRMOVM ALIAS RMOV ORDER RMOV01
SET ORDER TO RMOV05   && CODCTA+NRODOC+CODAUX+NROMES+DTOC(FCHDOC,1)+CODOPE+NROAST
SELECT 0
USE ccbtbdoc
USE O:\o-negocios\IDC\Data\ccbtbdoc
BROWSE
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE vtavguia
SET ORDER TO VGUI01   && CODDOC+NRODOC
SEEK 'G/R 0010029806'
BROWSE
BROWSE FIELDS coddoc,nrodoc,fchdoc,codcli,codref,nroref,codfac,nrofact,flgest
BROWSE FIELDS coddoc,nrodoc,fchdoc,codcli,codref,nroref,codfac,nrofac,flgest
USE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2018\almctran.dbf
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029608'
BROWSE
USE
DO ?
SELECT 0
USE p0012018!cbdmctas
SET ORDER TO CTAS01   && CODCTA
BROWSE
BROWSE field 
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_maestro_de_cuentas.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdmctas.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdrb003.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_report_libro_mayor_auxiliar.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\cbd_report_libro_mayor_auxiliar.prg
SELECT 0
DO  ?
SELECT 2
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 5
BROWSE LAST
BROWSE
SELECT 5
BROWSE LAST
MODIFY COMMAND ?
DO O:\o-negocios\IDC\data\vta_enlace_factura_almacen.prg
SELECT 3
BROWSE
MODIFY COMMAND  O:\o-negocios\IDC\data\vta_enlace_factura_almacen.prg
SELECT 5
SET RELATION TO tporf1+nrorf1 INTO GUIA
DO O:\o-negocios\IDC\data\vta_enlace_factura_almacen.prg
SELECT 5
SELECT 2
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 1
BROWSE LAST
USE
SELECT 2
USE
SELECT 3
USE
SELECT 4
USE
SELECT 5
USE
SELECT 6
USE
DO k:\aplvfp\bsinfo\progs2\cbd_cbdgcons1.prg
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cbd_cbdgcons1.prg
SELECT 0
DO ?
SELECT 1
BROWSE LAST
SELECT 1
SELECT 0
USE ccbrgdoc ALIAS 
USE  p0012015!cbdrmovm ALIAS r2015
CD ?
USE ?
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2015\cbdrmovm.dbf  ALIAS R2015
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0300303000226'
BROWSE
SELECT 0
SELECT 1
USE O:\o-negocios\IDC\data\cia001\c2015\cbdvmovm.dbf  ALIAS V2015
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST
SET RELATION TO nromes+codope+nroast INTO R2015 ADDITIVE
BROWSE LAST
SET RELATION to
SELECT 1
SET RELATION to
SELECT 2
SET RELATION TO nromes+codope+nroast INTO V2015 ADDITIVE
SEEK '0300303000226'
SELECT 1
SELECT 2
BROWSE LAST
SEEK '0300303000226'
SELECT 1
BROWSE LAST
CLOSE TABLES all
CLOSE DATABASES all
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\classgen\forms\gen2_ayuda_codigo_busqueda.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
USE vtatdocm
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE
USE
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
SELECT 10
SELECT * FROM calm WHERE subalm in ('001','002')
CANCEL
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran ALIAS dtra
SET ORDER TO DTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0)
GO bott
BROWSE
SET FILTER TO codsed='002'
BROWSE
SET FILTER TO codsed='002' AND (EMPTY(tipmov) OR EMPTY(codmov))
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almctran.dbf ALIAS ctra
SET FILTER TO codsed='002' AND (EMPTY(tipmov) OR EMPTY(codmov))
BROWSE FONT 'Consolas',9
SELECT 0
USE ccbrgdoc ALIAS gdoc
USE  O:\o-negocios\IDC\data\cia001\ccbrgdoc.dbf  ALIAS gdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SET FILTER TO DTOS(fchdoc)='201805' AND flgest='A'
BROWSE
SET FILTER TO
SEEK 'CARGOFACT0020000422'
SET FILTER TO
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SET FILTER TO
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SELECT 3
BROWSE LAST
SELECT 2
SELECT 3
BROWSE LAST
SELECT 2
BROWSE LAST
SET ORDER to DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'FACT002'
SEEK 'FACTF02'
SELECT 3
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\re_almacen_sede_002.prg
SELECT 3
USE
SELECT 2
USE
SELECT 1
USE
DO k:\aplvfp\bsinfo\re_almacen_sede_002.prg
GO bott
BROWSE
SET FILTER TO codsed='002' AND !INLIST(subalm,'011','012')
BROWSE
USE
USE O:\o-negocios\IDC\data\cia001\c2018\almctran.dbf EXCLUSIVE
REINDEX
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran.dbf EXCLUSIVE
REINDEX
USE O:\o-negocios\IDC\data\cia001\ccbrgdoc EXCLUSIVE
REINDEX
USE O:\o-negocios\IDC\data\cia001\vtaritem EXCLUSIVE
REINDEX
USE
CLOSE DATABASES all
USE vtarpedi
USE O:\o-negocios\IDC\data\cia001\vtarpedi.dbf  ALIAS RPED
SET ORDER TO RPED01   && NRODOC
SELECT 0
USE O:\o-negocios\IDC\data\cia001\vtavpedi.dbf  ALIAS VPED
SET ORDER TO VPED01   && NRODOC
SET RELATION TO nrodoc INTO rped
SEEK '00130796'
BROWSE
SELECT rped
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran ALIAS DTRA
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029994'
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almctran ALIAS DTRA
USE O:\o-negocios\IDC\data\cia001\c2018\almctran ALIAS CTRA
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029994'
BROWSE
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almctran ALIAS CTRA
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029994'
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran ALIAS DTRA
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010029994'
BROWSE
SELECT 0
USE ccbrgdoc
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SEEK 'P'
BROWSE
SEEK 'C'
BROWSE
SET FILTER TO DTOS(fchdoc)='201805'
SEEK 'A'
BROWSE
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
CLOSE DATABASES all
SELECT 0
USE O:\o-negocios\IDC\data\cia001\ccbrgdoc.dbf  ALIAS GDOC
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SET FILTER TO DTOS(fchdoc)='201805'
SEEK 'A'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
USE
CLOSE DATABASES all
USE O:\o-negocios\IDC\data\cia001\ccbrgdoc.dbf  ALIAS GDOC
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20,nromes,codope,nroast FONT 'Lucida Console',9
SEEK 'CARGOFACT0010000140'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20,nromes,codope,nroast FONT 'Lucida Console',9
SELECT 0
USE vtaritem ALIAS item
SET ORDER TO ITEM01   && CODDOC+NRODOC
SELECT 1
SET RELATION TO coddoc+nrodoc INTO item
BROWSE
SELECT 2
BROWSE LAST
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20,nromes,codope,nroast FONT 'Lucida Console',9
SELECT 1
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20,nromes,codope,nroast FONT 'Lucida Console',9
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\cbdrmovm.dbf  ALIAS rmov
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SELECT 1
SET RELATION TO nromes+codope+nroast INTO Rmov ADDITIVE
SELECT 3
BROWSE LAST
SELECT 0
USE almtdivf ALIAS divf
SET ORDER TO DIVF01   && CLFDIV+CODFAM
BROWSE
SELECT 4
BROWSE LAST
SELECT 2
SET RELATION TO '02'+left(codmat,6) INTO Divf ADDITIVE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\almtdivf.dbf ALIAS divf2 AGAIN
SET ORDER TO DIVF01   && CLFDIV+CODFAM
SEEK '02060'
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran.dbf  ALIAS dtra
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almdtran.dbf  ALIAS ctra
USE O:\o-negocios\IDC\data\cia001\c2018\almctran.dbf  ALIAS ctra
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SELECT 6
SELECT 1
SET RELATION coddoc+nrodoc INTO DTRA
SET RELATION TO coddoc+nrodoc INTO DTRA
SELECT 6
BROWSE LAST
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20,nromes,codope,nroast,codref,nroref,nroped FONT 'Lucida Console',9
SELECT 6
BROWSE LAST
SET FILTER TO NroRfb='00130816'
SELECT 7
SELECT 6
SET RELATION TO subalm+tipmov+codmov+nrodoc INTO Ctra ADDITIVE
SELECT 7
BROWSE LAST
SELECT 7
BROWSE LAST
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
SELECT 7
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 6
BROWSE LAST
SET FILTER TO 
SELECT 7
BROWSE LAST

SET RELATION TO
SELECT 6
BROWSE LAST
SELECT 7
BROWSE LAST
SET FILTER TO EMPTY(Subalm)
SET FILTER TO EMPTY(TipMov)
SELECT 6
SET FILTER TO EMPTY(TipMov)
BROWSE LAST
SET FILTER TO
SELECT 0
USE VTATDOCM
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE
SELECT 0
USE O:\o-negocios\IDC\data\cia001\c2018\almcDOCM.dbf ALIAS CDOC
SET ORDER TO CDOC01   && SUBALM+TIPMOV+CODMOV
BROWSE
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
SELECT 1
BROWSE LAST
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
?GOCFGALM.ENTIdadcorrelativo
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
CLOSE TABLES ALL
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
SELECT 7
BROWSE LAST
CANCEL
SELECT 0
USE ccbrgdoc alias gdoc
SET ORDER TO GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SEEK 'A'
SET FILTER TO DTOS(fchdoc)='201805'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
SET FILTER TO DTOS(fchdoc)='201805' AND nrodoc='002'
USE
CLEAR ALL
CLOSE ALL
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
RESUME
SELECT 43
SELECT 30
BROWSE LAST
RESUME
MODIFY CLASS base_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_textbox_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\classgen\forms\gen2_ayuda_codigo_busqueda.scx
MODIFY CLASS base_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\classgen\forms\gen2_ayuda_codigo_busqueda.scx
MODIFY CLASS base_cmdhelp OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\classgen\forms\gen2_ayuda_codigo_busqueda.scx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
DO FORM k:\aplvfp\classgen\forms\gen_gentidades.scx
USE vtatdocm
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE
SELECT 0
USE vtavpedi
MODIFY STRUCTURE
USE vtavprof
MODIFY STRUCTURE
SELECT 3
SELECT 30
USE
SELECT 2
SELECT 3
USE
USE vtavcoti EXCLUSIVE
USE vtarcoti EXCLUSIVE
MODIFY STRUCTURE
USE vtarpedi EXCLUSIVE
MODIFY STRUCTURE
USE
USE vtarprof EXCLUSIVE
MODIFY STRUCTURE
USE
USE vtatdocm
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE LAST
USE
SELECT 0
USE almtdivf
SET ORDER TO DIVF01   && CLFDIV+CODFAM
SEEK '020601'
BROWSE
SELECT 0
USE almtalma ALIAS alma
SET ORDER TO ALMA01   && SUBALM
BROWSE
SELECT 0
USE vtatdocm ALIAS docm
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE
USE
SELECT 5
BROWSE LAST
SELECT 0
USE ccbrgdoc ALIAS GDOC
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SET ORDER to GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SET FILTER TO DTOS(fchdoc)='201805'
BROWSE field
BROWSE
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
SEEK 'A'
SELECT 3
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
USE
SELECT 0
USE ccbrgdoc ALIAS GDOC
SET ORDER to GDOC05   && FLGEST+TPODOC+CODDOC+NRODOC
SET FILTER TO DTOS(fchdoc)='201805'
SEEK 'A'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
SELECT 0
USE ccbrgdoc ALIAS GDOC2
USE ccbrgdoc ALIAS GDOC2 AGAIN
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOBOLE0010000020'
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
SEEK 'CARGOFACT0010000389'
SEEK 'CARGOFACT0020000457'
SELECT 3
BROWSE FIELDS tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli:20 FONT 'Lucida Console',9
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\cbdmauxi.dbf
SET ORDER TO AUXI01   && CLFAUX+CODAUX
SET ORDER TO
GO bott
BROWSE
SELECT 0
USE V:\o-negocios\IDC\Data\cia001\cbdmauxi.dbf  ALIAS AUXI_HBR
CD ?
USE V:\o-negocios\IDC\Data\cia001\cbdmauxi.dbf  ALIAS AUXI_HBR
GO bott
BROWSE
SELECT 7
SELECT 8
SELECT 7
BROWSE LAST
SELECT 7
SELECT clfaux.codaux,COUNT(*) as Tot FROM cbdmauxi  GROUP BY clfaux,codaux having tot>1
SELECT clfaux,codaux,COUNT(*) as Tot FROM cbdmauxi  GROUP BY clfaux,codaux having tot>1
SELECT 7
SELECT 11
SET RELATION clfaux+codaux INTO cbdmauxi
SET RELATION TO clfaux+codaux INTO cbdmauxi
SELECT 7
BROWSE LAST
SELECT clfaux,codaux,COUNT(*) as Tot FROM cbdmauxi  GROUP BY clfaux,codaux having tot>1
SELECT 8
SELECT clfaux,codaux,COUNT(*) as Tot FROM auxi_hbr  GROUP BY clfaux,codaux having tot>1
SELECT 8
BROWSE LAST
SELECT 8
SELECT 11
SET RELATION TO clfaux+codaux INTO auxi_hbr additive
SELECT 11
USE
SELECT 8
SET RELATION TO clfaux+codaux INTO cbdmauxi additive
SELECT 8
SELECT 7
BROWSE LAST
SELECT 8
SET FILTER TO clfaux+codaux<>cbdmauxi.clfaux+cbdmauxi.codaux
BROWSE
SCATTER memvar
SELECT 7
APPEND BLANK
GATHER memvar
BROWSE
SET FILTER TO EMPTY(clfaux)
SELECT 8
USE
SELECT 7
USE
USE O:\o-negocios\IDC\Data\cia001\cbdmauxi.dbf ALIAS auxi
SELECT clfaux,codaux,COUNT(*) as Tot FROM auxi  GROUP BY clfaux,codaux having tot>1
SELECT 3
SET ORDER TO AUXI01   && CLFAUX+CODAUX
SELECT 9
SET RELATION TO clfaux+codaux INTO auxi additive
SELECT 3
BROWSE LAST
USE
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC
CD ?
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC
SELECT  * FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805'
SELECT  tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805'
SELECT  tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli,fchmodi  , fchcrea  ,fchelim  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805'
SELECT DTOS(FCHDOC,6),TPODOC,CODDOC, COUNT(*) FROM gdoc WHERE DTOS(FCHDOC)>='201801' GROUP BY DTOS(FCHDOC,6),TPODOC,CODDOC
SELECT LEFT(DTOS(FCHDOC),6),TPODOC,CODDOC, COUNT(*) FROM gdoc WHERE DTOS(FCHDOC)>='201801' GROUP BY LEFT(DTOS(FCHDOC),6),TPODOC,CODDOC
SELECT nromes,TPODOC,CODDOC, COUNT(*) FROM gdoc WHERE DTOS(FCHDOC)>='201801' GROUP BY nromes,TPODOC,CODDOC
SELECT  tpodoc,coddoc,nrodoc,fchdoc,impbrt,impigv,imptot,sdodoc,flgest,codcli,nomcli FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805'
SELECT 0
USE ?
SELECT 0
SELECT 2
SELECT * FROM Gdoc_ant WHERE CodDOC='PROF' AND DTOS(FCHDOC)='2012' INTO CURSOR PROF2012
BROWSE
SELECT 2
BROWSE LAST
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOPROF'
SELECT 0
USE ?
SELECT * FROM VPRO_ant WHERE CodDOC='PROF' AND DTOS(FCHDOC)='2012' INTO CURSOR PROF2012
BROWSE
SELECT TPODOC,CODDOC,SUM(imptot) FROM Prof2012 GROUP BY TPODOC,CODDOC INTO PROFTOT2012
SELECT TPODOC,CODDOC,SUM(imptot) FROM Prof2012 GROUP BY TPODOC,CODDOC INTO CURSOR PROFTOT2012
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT TpoDoc,CodDoc,NroDoc,FchDoc,IMptot,FlgEst,LEFT(DTOS(FCHDOC),4) AS PERIODO FROM VPRO_ant WHERE CodDOC='PROF' AND DTOS(FCHDOC)='2012' INTO CURSOR PROFTOT
BROWSE LAST
SELECT TpoDoc,CodDoc,NroDoc,FchDoc,IMptot,FlgEst,LEFT(DTOS(FCHDOC),4) AS PERIODO FROM VPRO_ant WHERE CodDOC='PROF' INTO CURSOR PROFTOT
BROWSE LAST
SELECT Periodo,TPODOC,CODDOC,SUM(imptot) FROM ProfTot GROUP BY Periodo,TPODOC,CODDOC INTO CURSOR PROFTOT_2
BROWSE LAST
SELECT 8
BROWSE LAST
SELECT  * FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805' INTO CURSOR ANULADOS
BROWSE LAST
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201805' INTO CURSOR ANULADOS
BROWSE
SELECT 1
BROWSE LAST
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOBOLE002'
QUIT
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
CD ?
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2018\cbdrmovm ALIAS rmov
SET FILTER TO VAL(codcco)>0 AND !EMPTY(codcco) and LEN(TRIM(codcco))<4
REPLACE ALL CodCco WITH RIGHT(REPLICATE('0',4)+AllTRIM(CodCCo),4)
BROWSE LAST
SET FILTER TO
BROWSE
USE
MODIFY DATABASE
OPEN DATABASE ?
MODIFY DATABASE
OPEN DATABASE ?
MODIFY DATABASE
CLOSE DATABASES all
OPEN DATABASE O:\o-negocios\IDC\data\P0012018.DBC
MODIFY DATABASE
USE p0012018!cbdrmovm
USE
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
MODIFY DATABASE
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT 0
USE vtarpedi ALIAS rped
CD ?
USE  O:\o-negocios\IDC\Data\cia001\vtarpedi ALIAS rped 
SET ORDER TO RPED01   && NRODOC
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\vtavpedi.dbf  ALIAS vped
SET ORDER TO VPED01   && NRODOC
SEEK '00131301'
SET RELATION TO nrodoc INTO rped
BROWSE
BROWSE FONT 'Lucida Console',8
BROWSE Nrodoc,Fchdoc,Codcli,CodVen,Nomcli:20,IMptot,CodMon,CndPgo,Flgest,FlgFac FONT 'Lucida Console',8
BROWSE FIELDS Nrodoc,Fchdoc,Codcli,CodVen,Nomcli:20,IMptot,CodMon,CndPgo,Flgest,FlgFac FONT 'Lucida Console',8
BROWSE FIELDS Nrodoc,Fchdoc,Codcli,CodVen,Nomcli:20,IMptot,CodMon,CndPgo:10,Flgest,FlgFac FONT 'Lucida Console',8
SELECT rped
BROWSE
BROWSE FONT 'Lucida Console',8
BROWSE FIELDS Nrodoc,Fchdoc,Codcli,CodVen,Nomcli:20,IMptot,CodMon,CndPgo:10,Flgest,FlgFac FONT 'Lucida Console',8
BROWSE FONT 'Lucida Console',8
SEEK '00131301'
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc
SELECT  TpoDoc,CodDoc,NroDoc,FchDOc,CodCli,NomCli,Flgest,Imptot,SdoDoc,codope,nromes,nroast  FROM GDOC WHERE flgest='A' AND DTOS(FCHDOC)>='201807' INTO CURSOR ANULADOS
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2018\almctran
GO bott
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2018\almdtran
GO bott
BROWSE
SELECT 0
USE cia001!vtavguia
GO bott
BROWSE
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
RESUME
CANCEL
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
RESUME
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
CANCEL
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
CANCEL
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
SELECT almctran
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 0010030374'
BROWSE
SEEK 'G/R 00100307'
USE O:\o-negocios\IDC\Data\cia001\c2018\almctran EXCLUSIVE
PACK
REINDEX
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 00100307'
BROWSE LAST
USE
USE O:\o-negocios\IDC\Data\cia001\c2018\almdtran EXCLUSIVE IN 0
SELECT ALMDTRAN
USE O:\o-negocios\IDC\Data\cia001\c2018\almdtran EXCLUSIV
REINDEX
PACK
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
SEEK 'G/R 00100307'
BROWSE
USE
SELECT VTAVGUIA
USE DBF() EXCLUSIVE
PACK
USE VTAVGUIA
SET ORDER TO VGUI01   && CODDOC+NRODOC
SEEK 'G/R 00100307'
BROWSE
USE VTATDOCM
BROWSE
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC
CD ?
USE O:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS GDOC
SELECT * FROM GDOC WHERE DTOS(fchdoc)>='201810' AND flgest='A' INTO CURSOR ANULADOS
BROWSE LAST
SELECT * FROM GDOC WHERE DTOS(fchdoc)>='201810' AND flgest='A' INTO CURSOR ANULADOS
BROWSE LAST
MODIFY COMMAND ?
MODIFY COMMAND k:\aplvfp\bsinfo\Progs\CCb_Anulados
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,Gdoc.fchcrea,GdOc.usercrea,Gdoc.fchmodi,Gdoc.usermodi,Gdoc.fchelim,Gdoc.userelim
BROWSE LAST
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,Gdoc.fchcrea,GdOc.usercrea,Gdoc.fchmodi,Gdoc.usermodi,Gdoc.fchelim,Gdoc.userelim FONT 'Lucida Console',8
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8
MODIFY COMMAND k:\aplvfp\bsinfo\Progs\CCb_Anulados
SELECT 0
SELECT * FROM gdoc WHERE Tpodoc= 'ABONO' AND CodDoc='N/C' ORDER BY tpodoc,coddoc,nrodoc INTO CURSOR NCredito
BROWSE LAST
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodRef,NroRef,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8
SELECT * FROM gdoc WHERE Tpodoc= 'ABONO' AND CodDoc='N/C' ORDER BY tpodoc,coddoc,nrodoc INTO CURSOR NCredito
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodRef,NroRef,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8
SELECT 0
SELECT 1
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'ABONON/C 000000001'
BROWSE
SET DELETED OFF
SET DELETED on
SELECT 0
USE ccbtbdoc
USE  O:\o-negocios\IDC\Data\ccbtbdoc.dbf ALIAS TDOC
GO bott
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\vtatdocm.dbf ALIAS DOCM
SET ORDER TO DOCM01   && SEDE+CODDOC+PTOVTA
BROWSE
SELECT 2
SELECT 3
BROWSE LAST
SELECT 2
BROWSE LAST
USE
SELECT 3
USE
SELECT 5
BROWSE LAST
SELECT 4
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT * FROM GDOC WHERE DTOS(fchdoc)>='201810' AND flgest='A' INTO CURSOR ANULADOS
BROWSE LAST
SELECT 0
USE ccbmvtos ALIAS vtos
CD ?
USE O:\o-negocios\IDC\Data\cia001\ccbmvtos.dbf ALIAS VTOS IN 0
SELECT vtos
SET ORDER TO vtos03
SET FILTER TO codcli ='99999999999'
BROWSE
SELECT 1
BROWSE last
BROWSE FIELDS TpoDoc,CodDoc,NroDoc,Fchdoc,CodRef,NroRef,CodCli,NomCli:20,ImpTot,SdoDoc,FlgEst,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8
SEEK 'CARGOFACT0010000979'
SEEK 'CARGOFACT0010001020'
SEEK 'CARGOFACT0010001057'
SEEK 'CARGOFACT0010001090'
SELECT 2
SET FILTER TO
SELECT 4
SELECT * FROM GDOC WHERE DTOS(fchdoc)>='201810' AND flgest='A' INTO CURSOR ANULADOS
CD ?
SELECT 1
BROWSE LAST
SELECT 3
USE
SELECT 4
USE
SELECT 6
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
CLOSE ALL
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
?CURDIR()
MODIFY COMMAND k:\aplvfp\bsinfo\progs\inicio_idc.prg AS 1252
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5030.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5040.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5020.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4800.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4520.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4250.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4210.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4200.scx
SELECT 0
USE vtavpedi ALIAS vped
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4200.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_report_registro_retenciones.prg AS 1252
USE vtavpedi ALIAS vped EXCLUSIVE
MODIFY STRUCTURE
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4200.scx
SET ORDER TO VPED04   && DTOS(FCHDOC)+CODVEN+NRODOC
INDEX ON DTOS(FCHDOC)+USERCREA+NRODOC TAG VPED05   &&
USE cia001!ccbrgdoc ALIAS gdoc EXCLUSIVE
INDEX ON DTOS(FCHDOC)+CODVEN+NRODOC TAG GDOC11   &&
INDEX ON DTOS(FCHDOC)+USERCREA+NRODOC TAG GDOC12   &&
USE
SELECT 0
USE  sistcdxs ALIAS cdxs
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO+INDICE
SEEK 'VENTAS    VTAVP'
BROWSE
SCATTER memvar
APPEND BLANK
GATHER memvar
SCATTER memvar
APPEND BLANK
GATHER memvar
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar4200.scx
RESUME
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE p0012019!almcatge
SET ORDER TO CATG01   && CODMAT
BROWSE
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_cat_materiales.scx
DO FORM k:\aplvfp\bsinfo\forms2\funalm_config_salidas.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms2\funalm_config_salidas.scx
SELECT 0
USE p0012019!almcatal
SET ORDER TO CATA01   && SUBALM+CODMAT
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\STOCKxALMA.DBF ALIAS calm2
USE o:\o-negocios\IDC\Data\cia001\STOCKxALMA.DBF ALIAS calm2 EXCLUSIVE
INDEX on codmat+subalm TAG cata01
INDEX on codmat+almacen TAG cata01
SELECT 3
USE DBF() ALIAS CALM
SET ORDER to CATA01   && SUBALM+CODMAT
SET RELATION TO CODMAT+SUBALM INTO CAlm2
BROWSE FIELDS subalm,codmat,calm2.subalm,calm2.codmat,calm2.borrar
BROWSE FIELDS subalm,codmat,calm2.almacen,calm2.codmat,calm2.borrar
SET FILTER TO TO subal+codmat==calm2.almacen+calm2.codmat AND calm2.borrar=1
SET FILTER TO subalm+codmat==calm2.almacen+calm2.codmat AND calm2.borrar=1
DELETE ALL FOR subalm+codmat==calm2.almacen+calm2.codmat AND calm2.borrar=1
SET FILTER TO
BROWSE
SELECT 0
USE cctclien
SELECT 3
SELECT 4
BROWSE LAST
SELECT 3
SET FILTER TO subalm+codmat==calm2.almacen+calm2.codmat AND calm2.borrar=1
BROWSE FIELDS subalm,codmat,calm2.almacen,calm2.codmat,calm2.borrar
SET FILTER TO
SELECT 4
USE
SELECT 3
BROWSE LAST
LOCATE
SELECT 0
USE cctclien
BROWSE
SET FILTER TO !EMPTY(codven)
BROWSE
REPLACE ALL codven WITH ''
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cntpage_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS cnt_cab_ventas OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO ?
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000003.NOT.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000003.DET.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000003.NOT.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000003.DET.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000004.NOT.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000004.DET.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F001-00000207.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00000207.DET
SELECT gdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'ABONON/C 002'
BROWSE
SELECT 0
USE ccbmvtos
USE o:\o-negocios\IDC\Data\cia001\ccbmvtos.dbf ALIAS vtos
SET ORDER TO VTOS01   && CODDOC+NRODOC
SEEK 'N/C 002'
BROWSE
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\ccbrrdoc.dbf ALIAS RDOC IN 0
SELECT rdoc
GO bott
BROWSE
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm ALIAS rmov
SET ORDER to RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0100401000038'
BROWSE
SELECT 1
BROWSE LAST
SEEK '0100401000217'
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs2\ccb_ccbtbdoc.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbnabo1.prg
SELECT 0
USE ccbmvtos ALIAS VTOS
SET ORDER TO VTOS01   && CODDOC+NRODOC
SELECT 0
USE cia001!ccbrgdoc
USE cia001!ccbrgdoc ALIAS gdoc
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'ABONON/C 020000007'
BROWSE
SEEK 'CARGOFACT0010001785'
BROWSE
SELECT VTOS
SEEK 'ABONON/C 020000007'
BROWSE LAST
SEEK 'N/C 020000007'
DO ?
SELECT 0
USE vtavprof
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOPROF'
BROWSE
REPLACE imptot WITH impbto+impigv
SELECT 0
USE almdtran
GO bott
BROWSE
SELECT 5
BROWSE LAST
SELECT 6
BROWSE LAST
SET ORDER TO DTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0)
USE
SELECT 5
USE
SELECT 7
DO ?
SELECT 0
USE vtavguia
SET ORDER TO VGUI01   && CODDOC+NRODOC
GO bott
BROWSE
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 0
USE vtavprof ALIAS 
SELECT 0
USE vtavprof ALIAS vpro
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
USE vtavprof ALIAS vpro
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOPROF00300038'
BROWSE LAST
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2019\almdtran.dbf ORDER dtra03 ALIAS dtra
SEEK 'PROF'
BROWSE
SEEK 'PR'
SEEK 'GR'
SEEK 'G/R'
SET FILTER TO CODMOV='Y03'
SET DELETED OFF
SET DELETED ON
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
GO bott
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
BROWSE LAST
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
SELECT 0
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n-vt.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
SELECT 0
USE gdoc_ant ALIAS gdoc_a
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SELECT 0
USE vtavprof
GO top
BROWSE
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
GO top
BROWSE
SELECT 0
USE vpro_ant
SET ORDER TO GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
LOCATE
BROWSE
SELECT * FROM vpro_ant UNION select * FROM vtavprof INTO CURSOR venta_prof
SELECT coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof
SELECT coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof ORDER BY fchdoc
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT 10
SELECT coddoc,LEFT(fchdoc,4),SUM(imptot) as total    frOM vpro_ant
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof ORDER BY fchdoc
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof ORDER BY fchdoc
BROWSE
SELECT 7
BROWSE LAST
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof ORDER BY fchdoc
SELECT periodo,coddoc,SUM(imptot) as total    frOM vpro_ant GROUP BY periodo,coddoc INTO CURSOR Venta_tot_Prof
SELECT periodo,coddoc,SUM(imptot) as total    frOM venta_pro GROUP BY periodo,coddoc INTO CURSOR Venta_tot_Prof
SELECT periodo,coddoc,SUM(imptot) as total    frOM venta_prof GROUP BY periodo,coddoc INTO CURSOR Venta_tot_Prof
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof ORDER BY fchdoc HAVING CodDoc='PROF'
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof HAVING CodDoc='PROF'ORDER BY fchdoc
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof INTO CURSOR venta_prof where CodDoc='PROF'ORDER BY fchdoc
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant WHERE  CodDoc='PROF' UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof WHERE  CodDoc='PROF' INTO CURSOR venta_prof ORDER BY fchdoc
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant WHERE  CodDoc='PROF' UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof WHERE  CodDoc='PROF' INTO CURSOR venta_prof ORDER BY fchdoc
SELECT 7
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT 11
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT 7
BROWSE LAST
SELECT 5
BROWSE LAST
SELECT LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot    frOM vpro_ant WHERE  CodDoc='PROF' UNION select LEFT(DTOS(fchdoc),4) as PERIODO ,coddoc,nrodoc,fchdoc,imptot FROM vtavprof WHERE  CodDoc='PROF' INTO CURSOR venta_prof ORDER BY fchdoc
SELECT periodo,coddoc,SUM(imptot) as total    frOM venta_prof GROUP BY periodo,coddoc INTO CURSOR Venta_tot_Prof
BROWSE LAST
?DBF()
COPY TO o:\o-negocios\temp\venta_tot_prof TYPE XLS
COPY TO o:\temp\venta_tot_prof TYPE XLS
SELECT 10
SELECT 7
BROWSE LAST
SELECT 5
BROWSE LAST
MODIFY COMMAND
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
USE
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
USE
SELECT 6
USE
DO k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 6
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoRef:5,CodRef:5,NroRef:11,codope:4,nromes,nroast,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8 NOWAIT
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_remunera_ast.prg AS 1252
SELECT 0
USE cbdrmovm ALIAS rmov
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SELECT 0
SELECT 5
SELECT 0
USE cbdVmovm ALIAS Vmov
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST
SELECT 5
SET RELATION TO nromes+codope+nroast INTO VMOV
SELECT gdoc
SET RELATION TO nromes+codope+nroast INTO RMOV
SELECT 5
BROWSE LAST
SELECT 7
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 7
SELECT 9
BROWSE LAST
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 9
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
SELECT 4
BROWSE LAST
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F001-00000014.not.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000014.not.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002546.DET
QUIT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000019.not.txt
CD ?
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000019.not.txt
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\vtaritem.dbf
USE o:\o-negocios\IDC\Data\cia001\vtaritem.dbf ALIAS item ORDER item01
USE o:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc ORDER gdoc01
USE o:\o-negocios\IDC\Data\cia001\vtaritem.dbf ALIAS item ORDER item01 IN 0
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc2 ORDER gdoc01
USE o:\o-negocios\IDC\Data\cia001\ccbrgdoc.dbf ALIAS gdoc2 ORDER gdoc01 AGAIN
SET ORDER TO GDOC03   && TPOREF+CODREF+NROREF+TPODOC+CODDOC+NRODOC
SELECT gdoc
SET RELATION TO tporef+codref+nroref INTO gdoc2
SELECT gdoc
SELECT gdoc2
SET RELATION TO coddoc+nrodoc INTO item
SELECT gdoc
SEEK 'ABONON/C 002'
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
BROWSE FIELDS TpoDoc,CodDoc,NroDoc:11,Fchdoc,CodCli,NomCli:20,ImpBto:11,impIgv:11,ImpTot:11,SdoDoc:11,FlgEst,CodMon:2,TpoRef:5,CodRef:5,NroRef:11,glosa2:40,fchcrea,usercrea,fchmodi,usermodi,fchelim,userelim FONT 'Lucida Console',8 NOWAIT
SEEK 'ABONON/C 0020000019'
SELECT 3
BROWSE LAST
SET ORDER TO GDOC01   && TPOREF+CODREF+NROREF+TPODOC+CODDOC+NRODOC
SELECT 2
BROWSE LAST
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000019.not.txt
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002715.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002832.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002881.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002849.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00002856.DET
CD ?
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
CLOSE DATABASES all
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 0
USE EMPRESAS
BROWSE LAST
SET DELETED OFF
BROWSE
SET DELETED ON
SELECT 0
USE E:\REDIDC-3\o-Negocios\RAUO\data\empresas ALIAS rauo
BROWSE
MODIFY STRUCTURE
SELECT 4
SELECT 5
SELECT 4
USE DBF() EXCLUSIVE
MODIFY STRUCTURE
SELECT 5
SELECT 4
MODIFY FORM k:\aplvfp\bsinfo\forms\adm_empresas.scx
DO FORM k:\aplvfp\bsinfo\forms\adm_empresas.scx
SELECT 5
BROWSE LAST
USE
SET DATABASE TO ADMIN
CLOSE DATABASES
DO FORM k:\aplvfp\bsinfo\forms\adm_empresas.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO FORM k:\aplvfp\bsinfo\forms\adm_empresas.scx
RESUME
CD ?
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf ALIAS rmov
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SET FILTER TO codope='002'
SET FILTER TO codope='002' AND codcta='12'
BROWSE
SELECT
SELECT 0
USE ccbrgdoc ALIAS gdoc ORDER gdoc01
USE  o:\o-negocios\IDC\Data\cia001\ccbrgdoc ALIAS gdoc ORDER gdoc01
SELECT rmov
SET RELATION TO "CARGO"+CodDoc+NroDoc INTO GDOC
BROWSE FIELDS nromes,codope,nroast,codcta,clfaux,codaux,glodoc:10,tpomov:2,codmon,coddoc,nrodoc,import,gdoc.codcli,gdoc.coddoc,gdoc.nrodoc FOR codaux<>gdoc.codcli
BROWSE FIELDS nromes,codope,nroast,codcta,clfaux,codaux,glodoc:10,tpomov:2,codmon,coddoc,nrodoc,import,gdoc.codcli,gdoc.coddoc,gdoc.nrodoc FOR codaux<>gdoc.codcli font 'Consolas',8
SET RELATION to
SET RELATION TO "CARGO"+CodDoc+PADR(NroDoc,15) INTO GDOC
SET DELETED OFF
BROWSE FIELDS nromes,codope,nroast,codcta,clfaux,codaux,glodoc:10,gdoc.codcli,gdoc.nomcli:10,tpomov:2,codmon,coddoc,nrodoc,import,gdoc.coddoc,gdoc.nrodoc FOR codaux<>gdoc.codcli font 'Consolas',8
SET DELETED ON
SET DELETED OFF
SET DELETED ON
SELECT
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\cctclien.dbf ALIAS clie ORDER clie04
SET ORDER TO CLIEN04   && CLFAUX+CODAUX
SELECT 1
SET RELATION TO clfaux+codaux INTO clie additive
SELECT 3
BROWSE LAST
SELECT 3
USE
SELECT 2
USE
SELECT 1
USE
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdtoper.dbf
SET ORDER TO OPER01   && CODOPE
SELECT 1
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf ALIAS rmov ORDER rmov01
SELECT 2
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdtoper.dbf ALIAS oper ORDER oper01
BROWSE
SET FILTER TO movcja=2
BROWSE
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf ALIAS rmov ORDER rmov01 AGAIN
USE o:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf ALIAS rmov2 ORDER rmov01 AGAIN
SELECT 0
USE o:\o-negocios\IDC\Data\cia001\c2018\cbdrmovm.dbf ALIAS rm2018
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0900309000024'
SET DELETED OFF
BROWSE
USE
SELECT 3
USE
SELECT 2
USE
SELECT 1
USE
CLOSE DATABASES all
USE v:\o-negocios\IDC\Data\cia001\c2018\cbdrmovm.dbf ALIAS rmov
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0900309000024'
BROWSE last
BROWSE FIELDS nromes,codope,nroast,nroitm,chkitm,eliitm,fchast,coddiv,codcta,clfaux,codaux,nrodoc,fchdoc,tpomov,import,impusa,codmon,glodoc:20,fchdig,hordig FONT "Consolas",8
SELECT 0
USE v:\o-negocios\IDC\Data\cia001\c2018\cbdVmovm.dbf ALIAS VMOV
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST
SELECT rmov
SET RELATION TO nromes+codope+nroast INTO vmov
BROWSE FIELDS nromes,codope,nroast,nroitm,chkitm,eliitm,fchast,coddiv,codcta,clfaux,codaux,nrodoc,fchdoc,tpomov,import,impusa,codmon,glodoc:20,vmov.digita,fchdig,hordig FONT "Consolas",8
SET DELETED ON
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
SELECT 0
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
USE O:\o-negocios\IDC\Data\cia001\vtavguia.dbf
GO bott
BROWSE
SELECT 0
SET DELETED OFF
SELECT 0
USE p0012019!almctran
GO bott
BROWSE
SET ORDER TO CTRA03   && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
SELECT 0
USE p0012019!almdtran
GO bott
BROWSE
SELECT 5
SET ORDER TO DTRA04   && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
BROWSE LAST
SET DELETED ON
SET FILTER TO codmov='Y01' AND subalm='001' AND flgest = 'A'
SELECT 5
SELECT 4
SET FILTER TO codmov='Y01' AND subalm='001' AND flgest = 'A'
BROWSE
SCATTER MEMVAR memo
APPEND BLANK
GATHER memvar
SELECT 0
USE p0012019!almcdocm
SET ORDER TO CDOC01   && SUBALM+TIPMOV+CODMOV
SEEK '001SY01'
BROWSE
SELECT 0
SELECT 4
SET ORDER TO CTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC
BROWSE LAST
SEEK '001SY011200000076'
BROWSE LAST
SELECT 5
SET ORDER TO DTRA01   && SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0)
SEEK '001SY011200000076'
BROWSE LAST
SEEK '001SY011200000075'
SELECT 4
SEEK '001SY011200000075'
BROWSE LAST
SELECT 3
BROWSE LAST
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_cobrar.scx
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
SELECT 0
USE ccbrrdoc ALIAS rdoc
SET ORDER TO RDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGON/C02'
SEEK 'CARGON/D 02'
SELECT 3
SEEK 'CARGON/D 02'
BROWSE LAST
SET DELETED off
SET DELETED ON
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\ccb_ccbnabo1.prg AS 1252
SELECT 0
USE ccbtbdoc
BROWSE
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
SELECT 5
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
SELECT 7
SET ORDER TO GDOC01   && TPODOC+CODDOC+NRODOC
SEEK 'CARGOFACT0010002461'
BROWSE
SEEK 'CARGOFACT0010003461'
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
RELEASE WINDOWS (WONTOP())
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
XsNroDtr=""
XdFchDtr={}
RESUME
PUBLIC XsNroDtr,XdFchDtr
XsNroDtr=""
XdFchDtr={}
RESUME
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
RESUME
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
SELECT 5
BROWSE LAST
MODIFY COMMAND  k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
SELECT 4
USE
SELECT 5
USE
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbtconc.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbtconc.prg WITH "NC"
DO FORM k:\aplvfp\bsinfo\forms2\ccb_ccbtconc_nc.scx
DO FORM k:\aplvfp\bsinfo\forms2\ccb_ccbtconc_nd.scx
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
USE
SELECT 9
USE
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
DO k:\aplvfp\bsinfo\progs2\cja_cjac2mov.prg
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
SELECT 0
USE cbdmctas
GO bott
BROWSE
SELECT 0
USE cbdrmovm
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '12002'
BROWSE
USE
SELECT 1
USE
SELECT 26
USE
SELECT 25
USE
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 7
USE
SELECT 9
BROWSE LAST
SELECT 0
DO k:\aplvfp\bsinfo\progs2\cbd_cbdmctas.prg
DO k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 6
BROWSE LAST
SEEK '20191230'
BROWSE LAST
SEEK '20191229'
SET ORDER to GDOC08   && DTOS(FCHDOC)+CODCLI+TPODOC+CODDOC+NRODOC
SEEK '20191230'
DO k:\aplvfp\bsinfo\progs2\ccb_ccbncar1.prg
DO k:\aplvfp\bsinfo\progs2\ccb_ccbnabo1.prg
SELECT 6
BROWSE LAST
SELECT 21
USE
SELECT 20
USE
SELECT 3
USE
SELECT 6
USE
SELECT 8
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 1
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 6
BROWSE LAST
SELECT 0
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
USE almctran EXCLUSIVE
MODIFY STRUCTURE
USE
SELECT 0
USE p0012019!cbdrmovm alias rmov19
SET ORDER TO RMOV10   && CODOPE+NRODOC
SEEK '005F001-24632'
BROWSE
SET FILTER TO nrodoc='F001-24632'
SET FILTER TO
DO k:\aplvfp\bsinfo\progs2\cbd_cbdanual.prg
RESUME
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
USE cbdtanos
BROWSE
DO k:\aplvfp\bsinfo\progs2\cbd_cbdanual.prg
SELECT 4
USE
RESUME
USE cbdtanos
BROWSE
USE
CD k:\aplvfp
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY COMMAND "k:\aplvfp\bsinfo\progs2\vta_genera_archivos_see-sfs_v1.prg" AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_cargar_txt_2_asiento.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
SELECT 9
SELECT 7
SELECT 9
SELECT 6
SELECT 9
USE
SELECT 7
USE
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
SELECT 2
DO FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
BROWSE LAST
USE
SELECT 8
USE
SELECT 5
USE
SELECT 7
USE
SELECT 4
USE
SELECT 3
USE
DO FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
BROWSE LAST
RESUME
BROWSE LAST
RESUME
modi FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
DO FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
CLEAR ALL
CLOSE DATABASES all
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
CANCEL
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
DO FORM k:\aplvfp\bsinfo\forms2\funvta_vtar5010.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 1
BROWSE LAST
SELECT 8
BROWSE LAST
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
SELECT 7
USE
SELECT 6
USE
SELECT 5
USE
SELECT 4
USE
SELECT 3
USE
SELECT 1
USE
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
?gocfgvta.xfporisc
?gocfgvta.xfporigv
gocfgvta.inicializavariablescfg
?gocfgvta.xfporisc
?gocfgvta.xfporigv
MODIFY COMMAND "k:\aplvfp\bsinfo\progs2\vta_genera_archivos_see-sfs_v1.prg" AS 1252
*Save
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
SET
set
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY PROJECT "\\servidor2-idc\dev2\aplvfp\bsinfo\proys\o-n.pjx"
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
USE p0012020!cbdrmovm ALIAS  rmov
SET ORDER TO RMOV01   && NROMES+CODOPE+NROAST+STR(NROITM,5)
SEEK '0100401000066'
BROWSE LAST
SET DELETED OFF
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
xs='20427712959-01-F001-00004537.CAB'
MODIFY COMMAND "E:\SFS_v1.3.2\sunat_archivos\sfs\DATA\"+xs
SELECT 3
SEEK 'CARGOFACT00100004374'
BROWSE LAST
SEEK 'CARGOFACT0010004374'
xs='20427712959-01-F001-00004538.CAB'
MODIFY COMMAND "E:\SFS_v1.3.2\sunat_archivos\sfs\DATA\"+xs
xs='20427712959-01-F001-00004539.CAB'
MODIFY COMMAND "E:\SFS_v1.3.2\sunat_archivos\sfs\DATA\"+xs
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO FORM k:\aplvfp\bsinfo\forms2\pln_plnttcmb.scx
MODIFY MENU k:\aplvfp\bsinfo\menus2\funvtam00.mnx
DO FORM k:\aplvfp\bsinfo\forms2\funfun_tipo_de_cambio.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\vta_genera_archivos_see-sfs_v1.prg:\aplvfp\bsinfo\progs\ccb_anulados.prg
CD ?
MODIFY COMMAND k:\aplvfp\bsinfo\progs\ccb_anulados.prg
USE O:\o-negocios\IDC\Data\cia001\c2020\cbdrmovm.dbf
GO bott
BROWSE
?RLOCK()
USE p0012020!cbdvmovm
?DBF()
?CURDIR()
?justpath(DBF())
?ADDBS(justpath(DBF()))+"vmovbk"
?ADDBS(justpath(DBF()))+"vmov_bk"
COPY TO ADDBS(justpath(DBF()))+"vmov_bk" WITH cdx TYPE FOX2x
SELECT 0
x=ADDBS(justpath(DBF()))+"vmov_bk"
USE (x)
?x
USE O:\o-negocios\IDC\Data\cia001\c2020\vmov_bk.dbf
USE O:\o-negocios\IDC\Data\cia001\c2020\vmov_bk.dbf EXCLUSIVE
PACK
SELECT 1
SELECT 2
GO bott
BROWSE
?RLOCK()
BROWSE
SELECT 1
SELECT 2
USE
SELECT 1
USE
REMOVE TABLE cbdvmovm delete
CLOSE DATABASES all
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
?x
OPEN DATABASE O:\o-negocios\IDC\data\P0012019.DBC EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012020 EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012020
OPEN DATABASE O:\o-negocios\IDC\data\P0012020 EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
REMOVE TABLE cbdvmovm delete
USE cbdvmovm EXCLUSIVE
USE p0012020!cbdvmovm
CLOSE TABLES all
USE cbdvmovm EXCLUSIVE
CLOSE TABLES all
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
VALIDATE database
CLOSE ALL
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
CD ?
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
CLOSE DATABASES all
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012019.DBC EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012018.DBC EXCLUSIVE
VALIDATE database
OPEN DATABASE O:\o-negocios\IDC\data\P0012019.DBC EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012018.DBC EXCLUSIVE
OPEN DATABASE O:\o-negocios\IDC\data\P0012020.DBC EXCLUSIVE
CLOSE DATABASES all
USE O:\o-negocios\IDC\Data\cia001\c2020\cbdvmovm.dbf EXCLUSIVE
USE O:\o-negocios\IDC\Data\cia001\c2020\cbdrmovm.dbf EXCLUSIVE
USE O:\o-negocios\IDC\Data\cia001\c2019\cbdrmovm.dbf EXCLUSIVE
USE
CD  k:\aplvfp
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 7
SELECT 10
BROWSE LAST
SELECT 3
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
SELECT 3
BROWSE LAST
SELECT 11
BROWSE LAST
SELECT 3
BROWSE LAST
MODIFY COMMAND o:\o-negocios\interface\cia001\20427712959-07-F002-00000042.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000042.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000042.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004330.DET
MODIFY COMMAND o:\o-negocios\interface\cia001\20427712959-07-F002-00000040.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000040.NOT
MODIFY COMMAND o:\o-negocios\interface\cia001\20427712959-07-F002-00000040.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004347.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000040.DET
BROWSE LAST
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000042.NOT
SELECT 8
BROWSE LAST
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000042.NOT
SELECT 0
USE p0012020!cbdrmovm ALIAS 
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
CANCEL
CLOSE TABLES all
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
CLEAR ALL
CLOSE ALL
CANCEL
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\vta_genera_archivos_see-sfs_v1.prg
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000049.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000050.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000052.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000048.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000047.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000046.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000045.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000044.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000043.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000042.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000041.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000040.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004672.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-B001-00000297.DET O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-B001-00000297.DET TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000297.DET TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000297.DET TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004672.DET TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000301.DET TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000056.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000056.DET
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004672.TRI TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.TRI
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004672.LEY TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.LEY
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-01-F001-00004672.ACA TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000054.ACA
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000297.TRI TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.TRI
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000297.LEY TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.LEY
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000297.ACA TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000055.ACA
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000301.TRI TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000056.TRI
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000301.LEY TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000056.LEY
COPY FILE O:\o-negocios\Interface\facturador\cia_001\20427712959-03-B001-00000301.ACA TO O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000056.ACA
SET FILTER TO CODDOC='N/C'
SET FILTER TO CODDOC='N/C' AND flgest NOT = "A"
SET FILTER TO CODDOC='N/C' AND flgest <> "A"
SET FILTER TO && CODDOC='N/C' AND flgest <> "A"
CD ?
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
do k:\aplvfp\bsinfo\progs\ccb_anulados.prg
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000066.NOT
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000065.NOT
modi comm ?
do ccb_copynotas_see-sfs with  "07","F002-00000067","F001-00004988"
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000067.DET
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000067.LEY
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000067.ACA
MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000067.TRI
