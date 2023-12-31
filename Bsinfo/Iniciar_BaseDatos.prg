
Local LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

XsCodSed='001'
LoDatAdm.gencursor("Temporal","VTAPTOVT",'',[Sede],XsCodSed,'','')




RETURN 

SELECT * FROM rmov2 WHERE "TELE"$UPPER(glodoc)
SELECT * FROM rmov2 WHERE "CELU"$UPPER(glodoc)
USE
SELECT 7
USE p0012019!cbdrmovm ALIAS rmov2
SELECT * FROM rmov2 WHERE "CELU"$UPPER(glodoc)
USE
SELECT 7
USE
USE p0012020!cbdrmovm ALIAS rmov2
SELECT * FROM rmov2 WHERE "CELU"$UPPER(glodoc)
USE p0012021!cbdrmovm ALIAS rmov2
SELECT 7
USE p0012021!cbdrmovm ALIAS rmov2
SELECT * FROM rmov2 WHERE "CELU"$UPPER(glodoc)
DO FORM k:\aplvfp\bsinfo\forms\funfun_compañias.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cbd_cbdrc003.prg
USE gusuarios IN 0
SELECT 3
SELECT 6
USE
SELECT 7
USE
SELECT 4
USE
SELECT 3
BROWSE FIELDS LoginUsuario,x=decrypt(TRIM(claveacceso), 1024)
BROWSE
BROWSE FIELDS LoginUsuario,x=decrypt(TRIM(claveacceso), 1024)
BROWSE LAST
?decrypt(TRIM(claveacceso), 1024)
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
USE gusuarios IN 0
SELECT 3
BROWSE FIELDS LoginUsuario,x=decrypt(TRIM(claveacceso), 1024)
BROWSE FIELDS LoginUsuario,x=decrypt(loginusuario,TRIM(claveacceso), 1024)
BROWSE FIELDS LoginUsuario,x=decrypt(claveacceso,TRIM(loginusuario), 1024)
MODIFY COMMAND k:\aplvfp\classgen\progs\gridextrasprocs.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\excelxml.prg AS 1252
?gsruccia
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\inicio_conexsur.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\inicio_conexsur.prg
SELECT 0
USE GSUARIOS
USE GuSUARIOS
BROWSE FIELDS LoginUsuario,x=decrypt(TRIM(claveacceso), 1024)
BROWSE FIELDS LoginUsuario,x=decrypt(claveacceso,TRIM(loginusuario), 1024)
SELECT LoginUsuario,pwd as decrypt(claveacceso,TRIM(loginusuario), 1024) FROM Gusuarios
SELECT LoginUsuario,decrypt(claveacceso,TRIM(loginusuario), 1024) as pwd FROM Gusuarios
COPY TO O:\o-Negocios\Update\Usuarios.xls TYPE xls
SELECT 0
USE cbdrmovm ALIAS rmov
USE O:\o-negocios\ConexSur\Data\cia001\c2022\cbdvmovm.dbf ALIAS vmov
SELECT Nromes,Codope,vmov.digita FROM vmov GROUP BY Nromes,Codope,vmov.digita
USE O:\o-negocios\ConexSur\Data\cia001\c2021\cbdvmovm.dbf ALIAS vmov2
SELECT Nromes,Codope,vmov.digita FROM vmov GROUP BY Nromes,Codope,digita
USE
SELECT 4
USE
SELECT 8
SELECT Nromes,Codope,vmov.digita FROM vmov GROUP BY Nromes,Codope,digita
SELECT Nromes,Codope,vmov.digita FROM vmov2 GROUP BY Nromes,Codope,digita
SELECT Nromes,Codope,digita FROM vmov2 GROUP BY Nromes,Codope,digita
SELECT 8
USE O:\o-negocios\ConexSur\Data\cia001\c2020\cbdvmovm.dbf ALIAS vmov2
USE O:\o-negocios\ConexSur\Data\cia001\c2019\cbdvmovm.dbf ALIAS vmov2
BROWSE LAST
SELECT Nromes,Codope,digita FROM vmov2 GROUP BY Nromes,Codope,digita
USE O:\o-negocios\ConexSur\Data\cia001\c2018\cbdvmovm.dbf ALIAS vmov2
SELECT 8
USE O:\o-negocios\ConexSur\Data\cia001\c2018\cbdvmovm.dbf ALIAS vmov2
BROWSE LAST
SELECT Nromes,Codope,digita FROM vmov2 GROUP BY Nromes,Codope,digita
SELECT 8
USE O:\o-negocios\ConexSur\Data\cia001\c2017\cbdvmovm.dbf ALIAS vmov2
BROWSE LAST
SELECT Nromes,Codope,digita FROM vmov2 GROUP BY Nromes,Codope,digita
USE
SELECT 8
USE O:\o-negocios\ConexSur\Data\cia001\c2016\cbdvmovm.dbf ALIAS vmov2
SELECT Nromes,Codope,digita FROM vmov2 GROUP BY Nromes,Codope,digita
USE
SELECT 8
USE
SELECT 3
USE
CLOSE DATABASES all
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_compañias.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_compañias.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_contab.scx
DO k:\aplvfp\bsinfo\progs2\cbd_report_registro_ventas.prg
DO k:\aplvfp\bsinfo\progs2\cbd_report_registro_compras.prg
DO k:\aplvfp\bsinfo\progs2\cbd_report_registro_ventas.prg
DO k:\aplvfp\bsinfo\progs2\cbd_report_registro_compras.prg
SET DATABASE TO P0012022
USE CBDRMOVM ALIAS RMOV
SET ORDER TO RMOV01
SEEK '08005'
BROWSE
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_report_registro_compras.prg AS 1252
SEEK '08004'
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_report_registro_ventas.prg AS 1252
BROWSE LAST
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_report_registro_compras.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\cbd_report_registro_compras.prg
DO FORM k:\aplvfp\classgen\forms\adm_accesos_seguridad.scx
MODIFY COMMAND ?
CLEAR ALL
MODIFY COMMAND K:\AplVfp\Bsinfo\progs2/v_facturacion.prg
MODIFY COMMAND K:\AplVfp\Classgen/Progs/interfase_sunat.prg
CLEAR ALL
CHR(251)
?CHR(251)
_cliptext = CHR(251)
ALEN(arreglo,1)
dim arreglo(6,2)
dime arreglo(6,2)
ALEN(arreglo,1)
CLEAR
?ALEN(arreglo,1)
?ALEN(arreglo,2)
?arreglo(0)
?arreglo(1)
MODIFY COMMAND sistscr0
?CURDIR()
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdactct.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdactec.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdbusca.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdcfpdt.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdcnfg0.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdmmovm.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\ccbbusca.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cmpbusca.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdmauxi.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdrb001.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_cbdrb002.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbd_diariogeneral.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\almpival.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdbusca.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdcfpdt.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdactct.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdcarga_mctas.prg AS 1252
MODIFY COMMAND cbdconfg
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdconfg.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\archivos_borrar.txt AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdplibf.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdconfg.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdraux.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdmrepo.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRLOO1.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRL001.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRV001.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRV002.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdselec.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cja_cjac1mov.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cjas2mov.spr AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cjabusca.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cia001.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\p0012017.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\janesoft.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\fxgen_2.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\cia001.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\archivos_borrar.txt AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdactct.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdactec.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\adm_admtcnfg.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDCHK2.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\fxgen_2.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\gridextrasprocs.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\hasaccess.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cbdselec.prg AS 1252
MODIFY COMMAND ?
MODIFY FILE k:\aplvfp\.gitignore
*Save
MODIFY COMMAND k:\aplvfp\Bsinfo/progs2/CBDCONLI.PRG AS 1252
MODIFY COMMAND k:/aplvfp/Bsinfo/progs2/CBDCONLI.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDCONLI.PRG AS 1252
MODIFY COMMAND ?
MODIFY COMMAND k:\aplvfp\Bsinfo/progs2/admnovis.prg  AS 1252
MODIFY COMMAND k:\aplvfp\Bsinfo/progs/admnovis.prg  AS 1252
MODIFY COMMAND k:/aplvfp/Bsinfo/progs/admnovis.prg  AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDCONLI.PRG AS 1252
MODIFY FILE k:\aplvfp\.gitignore
MODIFY COMMAND
MODIFY FILE k:\aplvfp\.gitignore
MODIFY FILE k:\aplvfp\bsinfo\archivos_borrar.txt
MODIFY COMMAND c:\users\scanner2023\desktop\gitignore.prg
MODIFY FILE k:\aplvfp\.gitignore
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDLCONI.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRCC03.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRCCo3.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRC003.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRLC08.PRG AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\CBDRLCO8.PRG AS 1252
MODIFY COMMAND k:\aplvfp\Bsinfo/progs2/cbd_cbdconst.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\setup_file_date.prg AS 1252
MODIFY COMMAND k:\aplvfp\sistscr0.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\poner_ccosto_ple_exactus.prg AS 1252
MODIFY COMMAND k:\aplvfp\bsinfo\progs\udf_ghost.prg AS 1252
MODIFY COMMAND cbd_cbdconst.prg
MODIFY COMMAND .gitignore
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\o-n.prg" AS 1252
MODIFY COMMAND
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
CLEAR
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
?LEN(x)-2048
x=_cliptext
?LEN(x)
?LEN(x)-2048
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
MODIFY FORM k:\aplvfp\classgen\forms\f0print_.scx
MODIFY COMMAND k:\aplvfp\classgen\progs\fxgen_2.prg AS 1252
MODIFY COMMAND k:\aplvfp\classgen\progs\janesoft.prg AS 1252
MODIFY COMMAND c:\users\scanner2023\desktop\program2.prg
MODIFY CLASS contabilidad OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS interfase_sunat OF k:\aplvfp\classgen\vcxs\inerfase_sunat.vcx
x=_cliptext
?LEN(x)
x=_cliptext
?LEN(x)
MODIFY COMMAND "k:\aplvfp\bsinfo\progs\o-n.prg" AS 1252
?VERSION(2)
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg AS 1252
DO k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_produccion.scx
MODIFY FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_produccion.scx
?gdfecha
DO k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_selecimpo_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\alm_control_de_situacion.scx
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiistdr.scx
DO k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiistdr_browse.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\alm_almimdacbrowse.scx
DO k:\aplvfp\bsinfo\progs2\cpi_cpiistdr.prg
MODIFY FORM k:\aplvfp\bsinfo\forms2\alm_almimdacbrowse.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiistdr_browse.scx
DO k:\aplvfp\bsinfo\progs2\cpi_cpiicmdf.prg
MODIFY COMMAND k:\aplvfp\bsinfo\progs2\cpi_cpiicmdf.prg AS 1252
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiicmdf.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiistdr_browse.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_selecimpo_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiistdr.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiicmdf.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpipform.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiicmxm.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiivpui.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpipgo_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpipgo_t2.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpiproce.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_cpipro_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_formulacion_01.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_formulacion_02.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_frmdesamuestra1.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_resumenmovo_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_resumeno_t.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cpi_selecimpo_t.scx
MODIFY PROJECT "\\hp-prodesk-600-g2mini-l18\dev\aplvfp\bsinfo\proys\o-n.pjx"
CD ?
MODIFY COMMAND ?
?SYS(0)
?_cliptext=SYS(0)
_cliptext=SYS(0)
?INLIST(SYS(0),"HP-PRODESK-600-") 
MODIFY PROJECT "k:\aplvfp\bsinfo\proys\o-n.pjx"
SET STATUS bar ON
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY MENU k:\aplvfp\bsinfo\menus2\funvtam00.mnx
Do vta_vtar4250
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
Do vta_vtar4250
Do form funvta_vtar4100
SELECT 0
USE processes
GO bott
BROWSE
USE
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
SELECT 0
USE O:\o-negocios\topsport\Data\cia001\c2014\almcftra.dbf
BROWSE
SELECT 0
USE O:\o-negocios\topsport\Data\cia001\c2014\almcdocm.dbf
BROWSE LAST
SELECT 3
BROWSE LAST
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
CLOSE DATABASES all
DO k:\aplvfp\bsinfo\progs\inicio_idc.prg
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY MENU k:\aplvfp\bsinfo\menus2\funvtam00.mnx
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
CANCEL
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
SELECT 61
BROWSE LAST
SELECT 63
BROWSE LAST
SELECT 20
BROWSE LAST
SELECT 0
USE O:\o-negocios\topsport\Data\cia001\c2014\almcftra.dbf ALIAS CFTRTOP
GO bott
BROWSE
SELECT 20
BROWSE LAST
SELECT 63
BROWSE LAST
SELECT 0
USE O:\o-negocios\topsport\Data\cia001\vtatdocm ALIAS docmTop
SELECT 65
BROWSE LAST
SELECT 65
BROWSE LAST
USE
SELECT 57
USE
CANCEL
SET STATUS bar ON
?DBUSED()
?DBUSED('CIA001')
CLOSE DATABASES
SET DATABASE TO CIA001
SET DATABASE TO P0012014
CLOSE DATABASES
DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
MODIFY COMMAND k:\aplvfp\classgen\progs\janesoft.prg AS 1252
DO FORM k:\aplvfp\bsinfo\forms2\funalm_config_salidas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms2\funalm_config_salidas.scx
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
SELECT 0
USE _foxcode
USE ?
BROWSE LAST
SCATTER MEMVAR memo
SELECT 0
USE "c:\program files (x86)\microsoft visual foxpro 9\foxcode.dbf" ALIAS FC
BROWSE
GO bott
APPEND BLANK
GATHER FROM memvar memo
GATHER FROM memvar
GATHER FROM memvar memo
SELECT 3
BROWSE LAST
SCATTER MEMVAR memo
SELECT 4
BROWSE LAST
GATHER MEMVAR memo
USE
SELECT 3
USE
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
DO FORM k:\aplvfp\bsinfo\forms2\funalm_config_salidas.scx
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
RESUME
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
DO FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
DO FORM k:\aplvfp\bsinfo\forms2\funalm_transacciones_vta.scx
DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS base_form_transac OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
SELECT 0
USE O:\o-negocios\IDC\Data\cia001\c2022\cbdrmovm.dbf ALIAS rmov
GO bott
BROWSE
USE O:\o-negocios\IDC\Data\cia001\c2023\cbdrmovm.dbf ALIAS rmov
SELECT 0
USE processes
GO bott
BROWSE
USE gusuarios
BROWSE
SELECT 0
users
USE users
BROWSE
SELECT 3
BROWSE LAST
BROWSE FIELDS LoginUsuario,x=decrypt(TRIM(claveacceso), 1024)
BROWSE FIELDS LoginUsuario,x=decrypt(claveacceso,TRIM(loginusuario), 1024)
SELECT users
BROWSE
MODIFY COMMAND "k:\aplvfp\bsinfo\progs2\vta_genera_archivos_see-sfs_v1.prg" AS 1252
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS contabilidad OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS onegocios OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS dataadmin OF k:\aplvfp\classgen\vcxs\dosvr.vcx
MODIFY CLASS formulario_factura OF k:\aplvfp\libs\cristal.vcx
MODIFY CLASS cristal OF k:\aplvfp\libs\cristal.vcx
MODIFY CLASS interfase_sunat OF k:\aplvfp\classgen\vcxs\inerfase_sunat.vcx
USE
SELECT 3
USE
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_cargar_txt_2_asiento.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
MODIFY MENU k:\aplvfp\bsinfo\menus2\funcbdm00.mnx
MODIFY FORM k:\aplvfp\bsinfo\forms2\cbd_ple_generar_arc_txt.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
CREATE FORM
MODIFY FORM k:\aplvfp\bsinfo\forms2\pln_frmcon03.scx
CREATE FORM
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY CLASS base_form OF k:\aplvfp\classgen\vcxs\admvrs.vcx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200_old.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtap3200.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_vtar5050.scx
MODIFY CLASS util OF k:\aplvfp\classgen\vcxs\admnovis.vcx
DO FORM k:\aplvfp\bsinfo\forms\adm_empresas.scx
MODIFY FORM k:\aplvfp\classgen\forms\adm_cambioclave.scx
MODIFY FORM k:\aplvfp\classgen\forms\adm_pideclavetransaccion.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\adm_sistemas.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\alm_almconfg.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\alm_almptsal.scx
SELECT 0
CD ?
USE empresas
BROWSE
SELECT 0
USE o:\o-negocios\queirolo\data\cia001\ccbrgdoc
USE o:\o-negocios\queirolo\data\cia001\ccbrgdoc EXCLUSIVE
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\ccbmvtos.dbf EXCLUSIVE
SET STATUS bar ON
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavpedi.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtarpedi.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavprof.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtarprof.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtaritem.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavguia.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\almestcm.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\cctclien.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\cctcdire.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\almtalam.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\almtalma.dbf EXCLUSIVE
BROWSE
PACK
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\cbdmauxi.dbf EXCLUSIVE
BROWSE
SET ORDER TO AUXI01   && CLFAUX+CODAUX
DELETE ALL FOR INLIST(clfaux,'001','002')
PACK
BROWSE
DELETE ALL FOR INLIST(clfaux,'001','002','003')
PACK
BROWSE
DELETE ALL FOR INLIST(clfaux,'001','002','003','004')
PACK
BROWSE
DELETE ALL FOR INLIST(clfaux,'001','002','003','004','PRE')
PACK
BROWSE
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\ccbsaldo.dbf EXCLUSIVE
BROWSE
ZAP
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\vtatdocm.dbf EXCLUSIVE
BROWSE
USE O:\o-Negocios\Queirolo\data\cia001\vtavpvta.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\vtatpvta.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\vtaptovt.dbf EXCLUSIVE
BROWSE
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\vtarcoti.dbf EXCLUSIVE
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavcoti.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavpedi.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\cmpco_cg.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\cmpdo_cg.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vpro_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\rpro_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\gdoc_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtos_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\item_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vped_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\rped_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\guia_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\clie_ant.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavguia.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\ccbntasg.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\ccbrtasg.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\ccbnrasg.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\ccbrrdoc.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\ventas_old.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\segui_det.dbf EXCLUSIVE
MODIFY STRUCTURE
USE O:\o-Negocios\Queirolo\data\cia001\segui.dbf EXCLUSIVE
BROWSE
ZAP
MODIFY FORM k:\aplvfp\bsinfo\forms2\ccb_liquidacion.scx
USE documentos
USE O:\o-Negocios\Queirolo\data\cia001\documentos.dbf EXCLUSIVE
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\liq_cob.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\liq_det.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\liq_ventas.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\liqui_ventas.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\liqui_det.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\liqui_cab.dbf EXCLUSIVE
ZAP
dir O:\o-Negocios\Queirolo\data\cia001\liq*.* 
MODIFY FORM k:\aplvfp\bsinfo\forms2\ccb_liquidacion.scx
MODIFY FORM k:\aplvfp\bsinfo\forms2\vta_liquidacion.scx
USE O:\o-Negocios\Queirolo\data\cia001\desarrollo.dbf EXCLUSIVE
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\pedidos.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\deta_pedidos.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\distritos.dbf EXCLUSIVE
BROWSE
USE O:\o-Negocios\Queirolo\data\cia001\crmsegpap.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\crmcsegpap.dbf EXCLUSIVE
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\crmcsegui.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\crmdsegui.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\crmccampa.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\cmpcrequ.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\vtavpedi.dbf EXCLUSIVE
ZAP
PACK
USE O:\o-Negocios\Queirolo\data\cia001\cmptmovq.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\cmptmovg.dbf EXCLUSIVE
BROWSE
USE O:\o-Negocios\Queirolo\data\cia001\plnmpers.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\plndmovt.dbf EXCLUSIVE
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almcatge.dbf EXCLUSIVE
BROWSE
SET ORDER TO CATG01   && CODMAT
DELETE ALL
SET DELETED OFF
PACK
SELECT 0
USE  O:\o-Negocios\Queirolo\data\cia001\c2023\almcatal.dbf EXCLUSIVE
SET ORDER to CATA02   && CODMAT+SUBALM
SET RELATION TO Codmat=almcatge.codmat
SET RELATION inTO Codmat=almcatge.codmat
SET RELATION TO Codmat=almcatge.codmat INTO almcatge
BROWSE FIELDS almcatal.codsed subalm,codmat,almc
BROWSE FIELDS almcatal.codsed,subalm,codmat,almcatge.codmat
SET FILTER TO codmat=almcatge.codmat
SET FILTER TO !codmat=almcatge.codmat
BROWSE FIELDS almcatal.codsed,subalm,codmat,almcatge.codmat
SELECT 6
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almcatge.dbf ALIAS catg AGAIN
BROWSE LAST
SET ORDER TO CATG01   && CODMAT
SELECT 7
SELECT 6
SELECT 7
SET RELATION to
SET RELATION TO codmat INTO almcatge
BROWSE FIELDS almcatal.codsed,subalm,codmat,almcatge.codmat
SELECT 8
BROWSE LAST
SELECT 7
BROWSE LAST
SET FILTER TO !codmat=almcatge.codmat
DELETE ALL
SET FILTER TO codmat=almcatge.codmat
ZAP
SELECT 6
ZAP
SELECT 8
USE
SELECT 7
ZAP
SELECT 6
ZAP
SELECT 0
USE almtdivf ALIAS divf
USE O:\o-Negocios\Queirolo\data\cia001\almtdivf ALIAS divf
SET ORDER TO DIVF01   && CLFDIV+CODFAM
BROWSE
SET DELETED on
PACK
USE O:\o-Negocios\Queirolo\data\cia001\almtdivf ALIAS divf EXCLUSIVE
PACK
SET ORDER TO DIVF01   && CLFDIV+CODFAM
BROWSE
DELETE ALL FOR clfdiv='02' and codfam ='03' AND LEN(TRIM(codfam))>=6
DELETE ALL FOR clfdiv='02' and AND codfam='05' AND codfam >='0507' && AND LEN(TRIM(codfam))>=6
DELETE ALL FOR clfdiv='02' and codfam='05' AND codfam >='0507' && AND LEN(TRIM(codfam))>=6
DELETE REST
PACK
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\c2023\cbdrmovm.dbf
USE O:\o-Negocios\Queirolo\data\cia001\c2023\cbdrmovm.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\cbdvmovm.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\cbdacmct.dbf EXCLUSIVE
ZAP
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almcatg2.dbf excl
BROWSE
MODIFY STRUCTURE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\plnmpers.dbf excl
BROWSE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\plnmpers.dbf excl
BROWSE
SELECT 0
USE sistdbfs
SET ORDER TO ARCHIVO   && ARCHIVO
SEEK 'PLNMPERS'
BROWSE
USE O:\o-Negocios\Queirolo\data\cia001\cpicform.dbf excl
USE O:\o-Negocios\Queirolo\data\cia001\cpicfpro.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\cpidfpro.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\CBDMCTAS_PCGR.dbf excl
BROWSE LAST
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\c2023\cbdtoper.dbf excl
BROWSE
REPLACE ALL ndoc00 WITH 1
REPLACE ALL ndoc01 WITH 1
REPLACE ALL ndoc02 WITH 1
REPLACE ALL ndoc03 WITH 1
REPLACE ALL ndoc04 WITH 1
REPLACE ALL ndoc05 WITH 1
REPLACE ALL ndoc06 WITH 1
REPLACE ALL ndoc07 WITH 1
REPLACE ALL ndoc08 WITH 1
REPLACE ALL ndoc09 WITH 1
REPLACE ALL ndoc10 WITH 1
REPLACE ALL ndoc11 WITH 1
REPLACE ALL ndoc12 WITH 1
REPLACE ALL ndoc13 WITH 1
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almcdocm.dbf excl
BROWSE
USE O:\o-Negocios\Queirolo\data\cia001\c2022\cbdrmovm.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\cbdvmovm.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\cbdacmct.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almcatge.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almcatal.dbf EXCLUSIVE
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almcatg2.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\cbdtoper.dbf excl
REPLACE ALL ndoc00 WITH 1
REPLACE ALL ndoc01 WITH 1
REPLACE ALL ndoc02 WITH 1
REPLACE ALL ndoc03 WITH 1
REPLACE ALL ndoc04 WITH 1
REPLACE ALL ndoc05 WITH 1
REPLACE ALL ndoc06 WITH 1
REPLACE ALL ndoc07 WITH 1
REPLACE ALL ndoc08 WITH 1
REPLACE ALL ndoc09 WITH 1
REPLACE ALL ndoc10 WITH 1
REPLACE ALL ndoc11 WITH 1
REPLACE ALL ndoc12 WITH 1
REPLACE ALL ndoc13 WITH 1
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almcdocm.dbf excl
REPLACE ALL ndoc00 WITH 1
REPLACE ALL ndoc01 WITH 1
REPLACE ALL ndoc02 WITH 1
REPLACE ALL ndoc03 WITH 1
REPLACE ALL ndoc04 WITH 1
REPLACE ALL ndoc05 WITH 1
REPLACE ALL ndoc06 WITH 1
REPLACE ALL ndoc07 WITH 1
REPLACE ALL ndoc08 WITH 1
REPLACE ALL ndoc09 WITH 1
REPLACE ALL ndoc10 WITH 1
REPLACE ALL ndoc11 WITH 1
REPLACE ALL ndoc12 WITH 1
REPLACE ALL ndoc13 WITH 1
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almdlote.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almdlote.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almdtran.dbf excl
USE O:\o-Negocios\Queirolo\data\cia001\c2023\almctran.dbf excl
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almdtran.dbf excl
ZAP
USE O:\o-Negocios\Queirolo\data\cia001\c2022\almctran.dbf excl
ZAP
CLOSE TABLES all
SELECT 0
USE O:\o-Negocios\Queirolo\data\cia001\sedes
BROWSE
SELECT 0
USE O:\o-Negocios\IDC\data\cia001\sedes ALIAS SEDEIDC
brow
MODIFY MENU k:\aplvfp\bsinfo\menus2\funvtam00.mnx
MODIFY MENU k:\aplvfp\bsinfo\menus2\funalmm00.mnx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funfun_cat_predios.scx
MODIFY MENU k:\aplvfp\bsinfo\menus\mnucfg00.mnx
MODIFY FORM k:\aplvfp\bsinfo\forms2\funfun_selec_config.scx
BROWSE LAST
SELECT 1
BROWSE LAST
SELECT 2
USE
SELECT 1
USE
CD ?
DIR *_CAUCHO.FR*
RENAME file *_CAUCHO.FR* TO *_QUEIROLO.FR*
RENAME *_CAUCHO.FR* TO  *_QUEIROLO.FR*
DIR *_queirolo.FR*
CLOSE DATABASES all