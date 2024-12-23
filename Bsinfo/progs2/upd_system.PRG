PARAMETERS _CodCia
PUBLIC GsCodCia
GsCodCia = _CodCia
PathDef = SYS(5)+SYS(2003)
LOCAL LoDa as dataadmin OF K:\aplvfp\classgen\vcxs\fpDosvr.vcx
LoDa = CREATEOBJECT('FpDosvr.DataAdmin')


LsRutaLocal  = LoDa.oEntorno.Locpath
LsRutaTemp   = LoDa.oEntorno.Tmppath

LsRutaUpdate = SYS(5)+SYS(2003)+'\UPDATE\'
LsRutaUpdStr = SYS(5)+SYS(2003)+'\UPDATE\STRUC\'

ADIR(aTablas,LsRutaUpdate+'*.TAB')
ADIR(aProced,LsRutaUpdate+'*.PRO')


FOR K = 1 TO ALEN(aProced,1)
	LnResult=act_proced(LsRutaLocal,JUSTSTEM(aProced(K,1)),PATHDEF+'\DATA\',SUBSTR(JUSTSTEM(aProced(K,1)),4) )
	IF LnResult=1
		DELETE FILE (LsRutaUpdate+aProced(K,1))
	ENDIF
ENDFOR
FOR J = 1 TO ALEN(aTablas,1)
	LnResult=Act_Tabla(JUSTSTEM(aTablas(J,1)),'CIA'+LoDa.Oentorno.Gscodcia )
	IF LnResult=1
		DELETE FILE (LsRutaUpdate+aTablas(J,1))
	ENDIF
ENDFOR
*!*	LsRutaUpdate = SYS(5)+SYS(2003)+'\UPDATE\'
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'SP_P0012004'+'.PRO' )
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'SP_CIA001'+'.PRO' )
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'MTOTARRE'+'.TAB' )
*******************
FUNCTION act_proced
*******************
PARAMETERS _ruta_Arc,_archivo,_Ruta_BD,_BaseDatos
LOCAL LnReturn AS Integer 
LnReturn = -1
IF FILE(_ruta_Arc+_archivo) AND FILE(_Ruta_BD+_BaseDatos)
	OPEN DATABASE (_Ruta_BD+_BaseDatos) EXCLUSIVE
	APPEND PROCEDURES FROM (_ruta_Arc+_archivo) OVERWRITE 
	CLOSE DATABASES
	LnReturn = 1
ENDIF
RETURN LnReturn
******************
FUNCTION Act_Tabla
******************
PARAMETERS _Tabla,_BD
LOCAL LnReturn AS Integer 
LnReturn = -1

IF !FILE(LsRutaUpdStr+_Tabla+'.STR')
	RETURN LnReturn
ENDIF
LsArc_Str = LsRutaUpdStr+_Tabla+'.STR'
SELECT 0
USE tdvdb!gentidades ALIAS entidad
SET FILTER TO TRIM(UPPER(NombreEntidad)) == TRIM(upper(_Tabla))
LOCATE
IF !EOF()
	SELECT 0
	USE tdvdb!gentidades_detalle ALIAS detalle
	SET FILTER TO CodigoEntidad == Entidad.CodigoEntidad AND !FlagotraTabla
	LOCATE
	IF !EOF()
		LsTabla=_BD+"!"+_Tabla
*!*			USE (LsTabla) EXCLUSIVE
*!*			LsNomArc = SYS(2023)+'\'+SYS(3) 
*!*			COPY STRUCTURE extended TO (LsNomArc)
		SELECT 0
		USE (LsArc_Str) ALIAS str_arc
		SELECT str_arc
		INDEX ON UPPER(field_Name) TAG pk1
		LsCadenaUpd=''
		LlUpdate = .f.	
		LlInsert = .f.	
		SELECT Detalle
		SCAN 
			IF SEEK(TRIM(UPPER(nombrecampo)),'str_arc','PK1')
				IF LongitudDato<>Field_len				
					LlUpdate = .t.	
				ENDIF
				IF TipoDatoCampo<>Field_Type		
					LlUpdate = .t.	
				ENDIF
				IF Decimales<>Field_Dec
					LlUpdate = .t.	
				ENDIF
			ELSE
				LlInsert = .T.	
				LoDa.mod_str_tabla(_Tabla,'AGREGA',str_arc.Field_Name,str_arc.Field_Type,str_arc.Field_len,str_arc.Field_Dec) 									
			ENDIF
			IF lUpdate
				LoDa.mod_str_tabla(_Tabla,'MODIFICA',str_arc.Field_Name,str_arc.Field_Type,str_arc.Field_len,str_arc.Field_Dec) 									
			ENDIF
			SELECT detalle
		ENDSCAN 
	ENDIF
ENDIF
	DO CASE 
		CASE _Tabla
	ENDCASE 
LnReturn = 1
RETURN LnReturn


FUNCTION LogUsuario
SELECT 0
USE CCBRGDOC ALIAS GDOC EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
SELECT 0
USE VTAVPEDI ALIAS VPED EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
SELECT 0
USE VTAVPROF ALIAS VPRO EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
SELECT 0
USE VTARPRO ALIAS RPRO EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T


** VETT:campos Log de usuario 2022 2022/02/16 03:41:08 ** 

USE almctran ALIAS ctra EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE almdtran ALIAS Dtra EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T

USE almcatge ALIAS catg EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T

USE almcatal ALIAS calm EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE vtaritem ALIAS item EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE ccbmvtos ALIAS vtos EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cctclien ALIAS clie EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdmauxi ALIAS AUXI EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdmtabl ALIAS tabl EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE almcftra ALIAS CFTR EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE almtalma ALIAS alma EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdrmovm ALIAS rmov EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdvmovm ALIAS vmov EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdmctas ALIAS ctas EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE ccbrrdoc ALIAS RDOC EXCLUSIVE 
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE vtatdocm ALIAS DOCM EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE almcdocm ALIAS CDOC EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE cbdtoper ALIAS oper EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE ccbtbdoc ALIAS BDOC EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T
USE VTAVGUIA ALIAS GUIA EXCLUSIVE
ALTER table ALIAS() add  COLUMN usercrea C(10)
ALTER table ALIAS() add  COLUMN fchcrea T
ALTER table ALIAS() add  COLUMN usermodi C(10)
ALTER table ALIAS() add  COLUMN fchmodi T
ALTER table ALIAS() add  COLUMN userelim C(10)
ALTER table ALIAS() add  COLUMN fchelim T


USE

******************
PROCEDURE VTARCUOT  && CUOTAS
******************
PARAMETERS PsNomDBCia
IF VARTYPE(PsNomDBCia)<>"C"
	PsNomDBCia = "CIA"+GsCodCia
ENDIF
IF !DBUSED(PsNomDBCia)
	OPEN DATABASE (PsNomDBCia)
ENDIF
SET DATABASE TO (PsNomDBCia)
LsCurPath=SYS(5)+CURDIR()
IF verifyvar('VTARCUOT',"TABLE",'INDBC','CIA'+GsCodCia)
	REMOVE TABLE 'VTARCUOT' DELETE
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"VTARCUOT.dbf")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"VTARCUOT.dbf"
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"VTARCUOT.cdx")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"VTARCUOT.cdx"
ENDIF
SET DEFAULT TO ADDBS(goentorno.Tspathcia)
DO MakeTable_VTARCUOT IN k:\aplvfp\bsinfo\progs\CIA001.PRG
SET DEFAULT TO ADDBS(LsCurPath)


IF !USED("DBFS")
	SELECT 0
	USE ADMIN!SISTDBFS ALIAS DBFS
	SET ORDER TO ARCHIVO	&& ARCHIVO
ENDIF
SELECT DBFS
IF !SEEK("VTARCUOT","DBFS","ARCHIVO")
	INSERT INTO DBFS (Sistema,Archivo,Concepto,ALIAS,Trans_str,Ubicacion,Basedatos,servidor,connect) VALUES ("VENTAS",'VTARCUOT','Tabla de cuotas CXC','RCUO',.T.,'CIA','','(Local)','FOXPRO.DBC')
ENDIF
IF !USED("CDXS")
	SELECT 0
	USE ADMIN!SISTCDXS ALIAS CDXS
	SET ORDER TO SISTEMA	 && SISTEMA+ARCHIVO+INDICE
ENDIF
SELECT CDXS
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"FACT"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','FACT','TPOREF+CODREF+NROREF','X',.F.,.F.,.F.)
ENDIF
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"FCHCOB"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','FCHCOB','DTOS(FCHCOB)+NRODOC','X',.F.,.F.,.F.)
ENDIF
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"FCHFAC"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','FCHFAC','DTOS(FCHFAC)+NRODOC','X',.F.,.F.,.F.)
ENDIF
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"RCUO01"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','RCUO01','NRODOC+NROCTA','X',.F.,.F.,.F.)
ENDIF
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"RCUO02"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','RCUO02','NRODOC+NROCTA+DTOC(FCHENT,1)','X',.F.,.F.,.F.)
ENDIF
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTARCUOT",LEN(ARCHIVO))+"RCUO03"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTARCUOT','RCUO03','FLGEST+NRODOC+NROCTA','X',.F.,.F.,.F.)
ENDIF

RETURN
***************
PROCEDURE ZONAS  && Departamentos
***************
PARAMETERS PsNomDBCia
IF VARTYPE(PsNomDBCia)<>"C"
	PsNomDBCia = "CIA"+GsCodCia
ENDIF
IF !DBUSED(PsNomDBCia)
	OPEN DATABASE (PsNomDBCia)
ENDIF
SET DATABASE TO (PsNomDBCia)
IF verifyvar('ZONAS',"TABLE",'INDBC','CIA'+GsCodCia)
	REMOVE TABLE 'ZONAS' DELETE
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"ZONAS.dbf")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"ZONAS.dbf"
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"ZONAS.cdx")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"ZONAS.cdx"
ENDIF
Create Table ADDBS(goentorno.Tspathcia)+"ZONAS" (Codzona C(2),Deszona C(40),Flagprov L,Coduser C(8),Fchhora T)
INDEX ON CODZONA TAG ZONA01 
INDEX ON UPPER(DESZONA)  TAG ZONA02

Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '01','AMAZONAS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '02','ANCASH',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '03','APURIMAC',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '04','AREQUIPA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '05','AYACUCHO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '06','CAJAMARCA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '07','CALLAO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '08','CUSCO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '09','HUANCAVELICA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '10','HUANUCO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '11','ICA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '12','JUNIN',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '13','LA LIBERTAD',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '14','LAMBAYEQUE',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '15','LIMA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '16','LORETO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '17','MADRE DE DIOS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '18','MOQUEGUA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '19','PASCO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '20','PIURA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '21','PUNO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '22','SAN MARTIN',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '23','TACNA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '24','TUMBES',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '25','UCAYALI',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '26','ACRE',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '27','ALAGOAS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '28','AMAPA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '29','AMAZONAS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '30','BAHIA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '31','CEARA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '32','DISTRITO FEDERAL',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '33','ESPIRITO SANTO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '34','GOIAS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '35','MARANHAO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '36','MATO GROSSO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '37','MATO GROSSO DO SUL',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '38','MINAS GERAIS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '39','PARA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '40','PARAIBA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '41','PARANA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '42','PERNAMBUCO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '43','JUJUY',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '44','SALTA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '45','TUCUMAN',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '46','FORMOSA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '47','CHACO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '48','SANTIAGO DEL ESTERO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '49','CATAMARCA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '50','CORRIENTES',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '51','MISIONES',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '52','LA RIOJA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '53','SAN JUAN',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '54','CORDOBA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '55','SANTA FE',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '56','ENTRE RIOS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '57','SAN LUIS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '58','MENDOZA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '59','BUENOS AIRES',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '60','LA PAMPA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '61','NEUQUEN',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '62','RIO NEGRO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '63','CHUBUT',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '64','SANTA CRUZ',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '65','TIERRA DEL FUEGO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '66','SAO PAULO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '67','RIO DE JANEIRO',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '68','RIO GRANDE DO SUL',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '69','SANTA CATARINA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '70','PIAUI',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '71','RIO GRANDE DO NORTE',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '72','SERGIPE',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '73','RONDONIA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '74','TOCANTINS',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '75','RORAIMA',.T.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
Insert into zonas(Codzona,Deszona,Flagprov,Coduser,Fchhora ) values ( '76','JOHANNESBURG',.F.,'Victor',Ctot( [02/01/2024 03:50:53 AM] ))
USE IN ZONAS

********************
PROCEDURE Provincias
********************
PARAMETERS PsNomDBCia
IF VARTYPE(PsNomDBCia)<>"C"
	PsNomDBCia = "CIA"+GsCodCia
ENDIF
IF !DBUSED(PsNomDBCia)
	OPEN DATABASE (PsNomDBCia)
ENDIF
SET DATABASE TO (PsNomDBCia)
IF verifyvar('Provincias',"TABLE",'INDBC','CIA'+GsCodCia)
	REMOVE TABLE 'Provincias' DELETE
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"Provincias.dbf")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"Provincias.dbf"
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"Provincias.cdx")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"Provincias.cdx"
ENDIF

CREATE TABLE ADDBS(goentorno.Tspathcia)+"Provincias" ;
(codProvin c(4) NOT NULL, Desprovin c(45) NOT NULL, Codzona c(2) NOT NULL, coduser C(8), fchhora T)
INDEX ON CODPROVIN TAG PROV01
INDEX ON UPPER(DESPROVIN)  TAG PROV02
INDEX ON CODZONA+CODPROVIN TAG PROV03

INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0101', 'Chachapoyas', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0102', 'Bagua', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0103', 'Bongará', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0104', 'Condorcanqui', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0105', 'Luya', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0106', 'Rodríguez de Mendoza', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0107', 'Utcubamba', '01')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0201', 'Huaraz', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0202', 'Aija', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0203', 'Antonio Raymondi', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0204', 'Asunción', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0205', 'Bolognesi', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0206', 'Carhuaz', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0207', 'Carlos Fermín Fitzcarrald', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0208', 'Casma', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0209', 'Corongo', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0210', 'Huari', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0211', 'Huarmey', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0212', 'Huaylas', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0213', 'Mariscal Luzuriaga', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0214', 'Ocros', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0215', 'Pallasca', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0216', 'Pomabamba', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0217', 'Recuay', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0218', 'Santa', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0219', 'Sihuas', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0220', 'Yungay', '02')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0301', 'Abancay', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0302', 'Andahuaylas', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0303', 'Antabamba', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0304', 'Aymaraes', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0305', 'Cotabambas', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0306', 'Chincheros', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0307', 'Grau', '03')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0401', 'Arequipa', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0402', 'Camaná', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0403', 'Caravelí', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0404', 'Castilla', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0405', 'Caylloma', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0406', 'Condesuyos', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0407', 'Islay', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0408', 'La Uniòn', '04')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0501', 'Huamanga', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0502', 'Cangallo', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0503', 'Huanca Sancos', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0504', 'Huanta', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0505', 'La Mar', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0506', 'Lucanas', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0507', 'Parinacochas', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0508', 'Pàucar del Sara Sara', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0509', 'Sucre', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0510', 'Víctor Fajardo', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0511', 'Vilcas Huamán', '05')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0601', 'Cajamarca', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0602', 'Cajabamba', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0603', 'Celendín', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0604', 'Chota', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0605', 'Contumazá', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0606', 'Cutervo', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0607', 'Hualgayoc', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0608', 'Jaén', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0609', 'San Ignacio', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0610', 'San Marcos', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0611', 'San Miguel', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0612', 'San Pablo', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0613', 'Santa Cruz', '06')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0701', 'Prov. Const. del Callao', '07')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0801', 'Cusco', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0802', 'Acomayo', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0803', 'Anta', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0804', 'Calca', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0805', 'Canas', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0806', 'Canchis', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0807', 'Chumbivilcas', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0808', 'Espinar', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0809', 'La Convención', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0810', 'Paruro', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0811', 'Paucartambo', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0812', 'Quispicanchi', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0813', 'Urubamba', '08')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0901', 'Huancavelica', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0902', 'Acobamba', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0903', 'Angaraes', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0904', 'Castrovirreyna', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0905', 'Churcampa', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0906', 'Huaytará', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('0907', 'Tayacaja', '09')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1001', 'Huánuco', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1002', 'Ambo', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1003', 'Dos de Mayo', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1004', 'Huacaybamba', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1005', 'Huamalíes', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1006', 'Leoncio Prado', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1007', 'Marañón', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1008', 'Pachitea', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1009', 'Puerto Inca', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1010', 'Lauricocha ', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1011', 'Yarowilca ', '10')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1101', 'Ica ', '11')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1102', 'Chincha ', '11')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1103', 'Nasca ', '11')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1104', 'Palpa ', '11')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1105', 'Pisco ', '11')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1201', 'Huancayo ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1202', 'Concepción ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1203', 'Chanchamayo ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1204', 'Jauja ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1205', 'Junín ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1206', 'Satipo ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1207', 'Tarma ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1208', 'Yauli ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1209', 'Chupaca ', '12')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1301', 'Trujillo ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1302', 'Ascope ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1303', 'Bolívar ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1304', 'Chepén ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1305', 'Julcán ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1306', 'Otuzco ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1307', 'Pacasmayo ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1308', 'Pataz ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1309', 'Sánchez Carrión ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1310', 'Santiago de Chuco ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1311', 'Gran Chimú ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1312', 'Virú ', '13')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1401', 'Chiclayo ', '14')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1402', 'Ferreñafe ', '14')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1403', 'Lambayeque ', '14')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1501', 'Lima ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1502', 'Barranca ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1503', 'Cajatambo ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1504', 'Canta ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1505', 'Cañete ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1506', 'Huaral ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1507', 'Huarochirí ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1508', 'Huaura ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1509', 'Oyón ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1510', 'Yauyos ', '15')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1601', 'Maynas ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1602', 'Alto Amazonas ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1603', 'Loreto ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1604', 'Mariscal Ramón Castilla ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1605', 'Requena ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1606', 'Ucayali ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1607', 'Datem del Marañón ', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1608', 'Putumayo', '16')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1701', 'Tambopata ', '17')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1702', 'Manu ', '17')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1703', 'Tahuamanu ', '17')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1801', 'Mariscal Nieto ', '18')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1802', 'General Sánchez Cerro ', '18')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1803', 'Ilo ', '18')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1901', 'Pasco ', '19')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1902', 'Daniel Alcides Carrión ', '19')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('1903', 'Oxapampa ', '19')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2001', 'Piura ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2002', 'Ayabaca ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2003', 'Huancabamba ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2004', 'Morropón ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2005', 'Paita ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2006', 'Sullana ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2007', 'Talara ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2008', 'Sechura ', '20')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2101', 'Puno ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2102', 'Azángaro ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2103', 'Carabaya ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2104', 'Chucuito ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2105', 'El Collao ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2106', 'Huancané ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2107', 'Lampa ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2108', 'Melgar ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2109', 'Moho ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2110', 'San Antonio de Putina ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2111', 'San Román ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2112', 'Sandia ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2113', 'Yunguyo ', '21')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2201', 'Moyobamba ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2202', 'Bellavista ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2203', 'El Dorado ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2204', 'Huallaga ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2205', 'Lamas ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2206', 'Mariscal Cáceres ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2207', 'Picota ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2208', 'Rioja ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2209', 'San Martín ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2210', 'Tocache ', '22')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2301', 'Tacna ', '23')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2302', 'Candarave ', '23')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2303', 'Jorge Basadre ', '23')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2304', 'Tarata ', '23')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2401', 'Tumbes ', '24')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2402', 'Contralmirante Villar ', '24')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2403', 'Zarumilla ', '24')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2501', 'Coronel Portillo ', '25')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2502', 'Atalaya ', '25')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2503', 'Padre Abad ', '25')
INSERT INTO Provincias (codProvin, Desprovin, Codzona) VALUES ('2504', 'Purús', '25')
USE IN Provincias
IF !USED("DBFS")
	SELECT 0
	USE ADMIN!SISTDBFS ALIAS DBFS
	SET ORDER TO ARCHIVO
ENDIF
SELECT DBFS
IF !SEEK("PROVINCIAS","DBFS")
	INSERT INTO DBFS (Sistema,Archivo,Concepto,ALIAS,Trans_str,Ubicacion,Basedatos,servidor,connect) VALUES ("VENTAS",'PROVINCIAS','Tabla de provincias','PROVI',.F.,'CIA','','(Local)','FOXPRO.DBC')
ENDIF
RETURN

********************
PROCEDURE Distritos
********************
PARAMETERS PsNomDBCia
IF VARTYPE(PsNomDBCia)<>"C"
	PsNomDBCia = "CIA"+GsCodCia
ENDIF
IF !DBUSED(PsNomDBCia)
	OPEN DATABASE (PsNomDBCia)
ENDIF
SET DATABASE TO (PsNomDBCia)
IF verifyvar('Distritos',"TABLE",'INDBC','CIA'+GsCodCia)
	REMOVE TABLE 'Distritos' DELETE
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"Distritos.dbf")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"Distritos.dbf"
ENDIF
IF FILE(ADDBS(goentorno.Tspathcia)+"Distritos.cdx")
	DELETE FILE ADDBS(goentorno.Tspathcia)+"Distritos.cdx"
ENDIF

CREATE TABLE ADDBS(goentorno.Tspathcia)+"Distritos"  ;
(coddist c(6) NOT NULL, desdist c(45) NOT NULL,codProvin c(4) NOT NULL, Codzona c(3) NOT NULL, coduser C(8), fchhora T)
INDEX ON CODDIST TAG DIST01
INDEX ON UPPER(DESDIST) TAG DIST02
INDEX ON CODZONA TAG DIST03 
INDEX ON CODZONA+CODPROVIN+CODDIST TAG DIST04

INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010101', 'Chachapoyas', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010102', 'Asunción', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010103', 'Balsas', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010104', 'Cheto', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010105', 'Chiliquin', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010106', 'Chuquibamba', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010107', 'Granada', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010108', 'Huancas', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010109', 'La Jalca', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010110', 'Leimebamba', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010111', 'Levanto', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010112', 'Magdalena', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010113', 'Mariscal Castilla', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010114', 'Molinopampa', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010115', 'Montevideo', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010116', 'Olleros', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010117', 'Quinjalca', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010118', 'San Francisco de Daguas', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010119', 'San Isidro de Maino', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010120', 'Soloco', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010121', 'Sonche', '0101', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010201', 'Bagua', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010202', 'Aramango', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010203', 'Copallin', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010204', 'El Parco', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010205', 'Imaza', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010206', 'La Peca', '0102', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010301', 'Jumbilla', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010302', 'Chisquilla', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010303', 'Churuja', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010304', 'Corosha', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010305', 'Cuispes', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010306', 'Florida', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010307', 'Jazan', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010308', 'Recta', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010309', 'San Carlos', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010310', 'Shipasbamba', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010311', 'Valera', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010312', 'Yambrasbamba', '0103', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010401', 'Nieva', '0104', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010402', 'El Cenepa', '0104', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010403', 'Río Santiago', '0104', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010501', 'Lamud', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010502', 'Camporredondo', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010503', 'Cocabamba', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010504', 'Colcamar', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010505', 'Conila', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010506', 'Inguilpata', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010507', 'Longuita', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010508', 'Lonya Chico', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010509', 'Luya', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010510', 'Luya Viejo', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010511', 'María', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010512', 'Ocalli', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010513', 'Ocumal', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010514', 'Pisuquia', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010515', 'Providencia', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010516', 'San Cristóbal', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010517', 'San Francisco de Yeso', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010518', 'San Jerónimo', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010519', 'San Juan de Lopecancha', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010520', 'Santa Catalina', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010521', 'Santo Tomas', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010522', 'Tingo', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010523', 'Trita', '0105', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010601', 'San Nicolás', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010602', 'Chirimoto', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010603', 'Cochamal', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010604', 'Huambo', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010605', 'Limabamba', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010606', 'Longar', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010607', 'Mariscal Benavides', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010608', 'Milpuc', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010609', 'Omia', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010610', 'Santa Rosa', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010611', 'Totora', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010612', 'Vista Alegre', '0106', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010701', 'Bagua Grande', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010702', 'Cajaruro', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010703', 'Cumba', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010704', 'El Milagro', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010705', 'Jamalca', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010706', 'Lonya Grande', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('010707', 'Yamon', '0107', '01')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020101', 'Huaraz', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020102', 'Cochabamba', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020103', 'Colcabamba', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020104', 'Huanchay', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020105', 'Independencia', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020106', 'Jangas', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020107', 'La Libertad', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020108', 'Olleros', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020109', 'Pampas Grande', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020110', 'Pariacoto', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020111', 'Pira', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020112', 'Tarica', '0201', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020201', 'Aija', '0202', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020202', 'Coris', '0202', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020203', 'Huacllan', '0202', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020204', 'La Merced', '0202', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020205', 'Succha', '0202', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020301', 'Llamellin', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020302', 'Aczo', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020303', 'Chaccho', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020304', 'Chingas', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020305', 'Mirgas', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020306', 'San Juan de Rontoy', '0203', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020401', 'Chacas', '0204', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020402', 'Acochaca', '0204', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020501', 'Chiquian', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020502', 'Abelardo Pardo Lezameta', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020503', 'Antonio Raymondi', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020504', 'Aquia', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020505', 'Cajacay', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020506', 'Canis', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020507', 'Colquioc', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020508', 'Huallanca', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020509', 'Huasta', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020510', 'Huayllacayan', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020511', 'La Primavera', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020512', 'Mangas', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020513', 'Pacllon', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020514', 'San Miguel de Corpanqui', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020515', 'Ticllos', '0205', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020601', 'Carhuaz', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020602', 'Acopampa', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020603', 'Amashca', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020604', 'Anta', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020605', 'Ataquero', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020606', 'Marcara', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020607', 'Pariahuanca', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020608', 'San Miguel de Aco', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020609', 'Shilla', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020610', 'Tinco', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020611', 'Yungar', '0206', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020701', 'San Luis', '0207', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020702', 'San Nicolás', '0207', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020703', 'Yauya', '0207', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020801', 'Casma', '0208', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020802', 'Buena Vista Alta', '0208', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020803', 'Comandante Noel', '0208', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020804', 'Yautan', '0208', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020901', 'Corongo', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020902', 'Aco', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020903', 'Bambas', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020904', 'Cusca', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020905', 'La Pampa', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020906', 'Yanac', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('020907', 'Yupan', '0209', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021001', 'Huari', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021002', 'Anra', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021003', 'Cajay', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021004', 'Chavin de Huantar', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021005', 'Huacachi', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021006', 'Huacchis', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021007', 'Huachis', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021008', 'Huantar', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021009', 'Masin', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021010', 'Paucas', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021011', 'Ponto', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021012', 'Rahuapampa', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021013', 'Rapayan', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021014', 'San Marcos', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021015', 'San Pedro de Chana', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021016', 'Uco', '0210', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021101', 'Huarmey', '0211', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021102', 'Cochapeti', '0211', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021103', 'Culebras', '0211', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021104', 'Huayan', '0211', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021105', 'Malvas', '0211', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021201', 'Caraz', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021202', 'Huallanca', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021203', 'Huata', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021204', 'Huaylas', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021205', 'Mato', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021206', 'Pamparomas', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021207', 'Pueblo Libre', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021208', 'Santa Cruz', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021209', 'Santo Toribio', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021210', 'Yuracmarca', '0212', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021301', 'Piscobamba', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021302', 'Casca', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021303', 'Eleazar Guzmán Barron', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021304', 'Fidel Olivas Escudero', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021305', 'Llama', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021306', 'Llumpa', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021307', 'Lucma', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021308', 'Musga', '0213', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021401', 'Ocros', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021402', 'Acas', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021403', 'Cajamarquilla', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021404', 'Carhuapampa', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021405', 'Cochas', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021406', 'Congas', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021407', 'Llipa', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021408', 'San Cristóbal de Rajan', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021409', 'San Pedro', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021410', 'Santiago de Chilcas', '0214', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021501', 'Cabana', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021502', 'Bolognesi', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021503', 'Conchucos', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021504', 'Huacaschuque', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021505', 'Huandoval', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021506', 'Lacabamba', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021507', 'Llapo', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021508', 'Pallasca', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021509', 'Pampas', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021510', 'Santa Rosa', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021511', 'Tauca', '0215', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021601', 'Pomabamba', '0216', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021602', 'Huayllan', '0216', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021603', 'Parobamba', '0216', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021604', 'Quinuabamba', '0216', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021701', 'Recuay', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021702', 'Catac', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021703', 'Cotaparaco', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021704', 'Huayllapampa', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021705', 'Llacllin', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021706', 'Marca', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021707', 'Pampas Chico', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021708', 'Pararin', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021709', 'Tapacocha', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021710', 'Ticapampa', '0217', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021801', 'Chimbote', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021802', 'Cáceres del Perú', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021803', 'Coishco', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021804', 'Macate', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021805', 'Moro', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021806', 'Nepeña', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021807', 'Samanco', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021808', 'Santa', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021809', 'Nuevo Chimbote', '0218', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021901', 'Sihuas', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021902', 'Acobamba', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021903', 'Alfonso Ugarte', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021904', 'Cashapampa', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021905', 'Chingalpo', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021906', 'Huayllabamba', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021907', 'Quiches', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021908', 'Ragash', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021909', 'San Juan', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('021910', 'Sicsibamba', '0219', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022001', 'Yungay', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022002', 'Cascapara', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022003', 'Mancos', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022004', 'Matacoto', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022005', 'Quillo', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022006', 'Ranrahirca', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022007', 'Shupluy', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('022008', 'Yanama', '0220', '02')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030101', 'Abancay', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030102', 'Chacoche', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030103', 'Circa', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030104', 'Curahuasi', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030105', 'Huanipaca', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030106', 'Lambrama', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030107', 'Pichirhua', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030108', 'San Pedro de Cachora', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030109', 'Tamburco', '0301', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030201', 'Andahuaylas', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030202', 'Andarapa', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030203', 'Chiara', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030204', 'Huancarama', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030205', 'Huancaray', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030206', 'Huayana', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030207', 'Kishuara', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030208', 'Pacobamba', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030209', 'Pacucha', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030210', 'Pampachiri', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030211', 'Pomacocha', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030212', 'San Antonio de Cachi', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030213', 'San Jerónimo', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030214', 'San Miguel de Chaccrampa', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030215', 'Santa María de Chicmo', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030216', 'Talavera', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030217', 'Tumay Huaraca', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030218', 'Turpo', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030219', 'Kaquiabamba', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030220', 'José María Arguedas', '0302', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030301', 'Antabamba', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030302', 'El Oro', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030303', 'Huaquirca', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030304', 'Juan Espinoza Medrano', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030305', 'Oropesa', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030306', 'Pachaconas', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030307', 'Sabaino', '0303', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030401', 'Chalhuanca', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030402', 'Capaya', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030403', 'Caraybamba', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030404', 'Chapimarca', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030405', 'Colcabamba', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030406', 'Cotaruse', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030407', 'Ihuayllo', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030408', 'Justo Apu Sahuaraura', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030409', 'Lucre', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030410', 'Pocohuanca', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030411', 'San Juan de Chacña', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030412', 'Sañayca', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030413', 'Soraya', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030414', 'Tapairihua', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030415', 'Tintay', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030416', 'Toraya', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030417', 'Yanaca', '0304', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030501', 'Tambobamba', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030502', 'Cotabambas', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030503', 'Coyllurqui', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030504', 'Haquira', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030505', 'Mara', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030506', 'Challhuahuacho', '0305', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030601', 'Chincheros', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030602', 'Anco_Huallo', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030603', 'Cocharcas', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030604', 'Huaccana', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030605', 'Ocobamba', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030606', 'Ongoy', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030607', 'Uranmarca', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030608', 'Ranracancha', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030609', 'Rocchacc', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030610', 'El Porvenir', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030611', 'Los Chankas', '0306', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030701', 'Chuquibambilla', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030702', 'Curpahuasi', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030703', 'Gamarra', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030704', 'Huayllati', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030705', 'Mamara', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030706', 'Micaela Bastidas', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030707', 'Pataypampa', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030708', 'Progreso', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030709', 'San Antonio', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030710', 'Santa Rosa', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030711', 'Turpay', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030712', 'Vilcabamba', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030713', 'Virundo', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('030714', 'Curasco', '0307', '03')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040101', 'Arequipa', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040102', 'Alto Selva Alegre', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040103', 'Cayma', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040104', 'Cerro Colorado', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040105', 'Characato', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040106', 'Chiguata', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040107', 'Jacobo Hunter', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040108', 'La Joya', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040109', 'Mariano Melgar', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040110', 'Miraflores', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040111', 'Mollebaya', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040112', 'Paucarpata', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040113', 'Pocsi', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040114', 'Polobaya', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040115', 'Quequeña', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040116', 'Sabandia', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040117', 'Sachaca', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040118', 'San Juan de Siguas', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040119', 'San Juan de Tarucani', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040120', 'Santa Isabel de Siguas', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040121', 'Santa Rita de Siguas', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040122', 'Socabaya', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040123', 'Tiabaya', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040124', 'Uchumayo', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040125', 'Vitor', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040126', 'Yanahuara', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040127', 'Yarabamba', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040128', 'Yura', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040129', 'José Luis Bustamante Y Rivero', '0401', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040201', 'Camaná', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040202', 'José María Quimper', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040203', 'Mariano Nicolás Valcárcel', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040204', 'Mariscal Cáceres', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040205', 'Nicolás de Pierola', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040206', 'Ocoña', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040207', 'Quilca', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040208', 'Samuel Pastor', '0402', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040301', 'Caravelí', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040302', 'Acarí', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040303', 'Atico', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040304', 'Atiquipa', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040305', 'Bella Unión', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040306', 'Cahuacho', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040307', 'Chala', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040308', 'Chaparra', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040309', 'Huanuhuanu', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040310', 'Jaqui', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040311', 'Lomas', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040312', 'Quicacha', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040313', 'Yauca', '0403', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040401', 'Aplao', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040402', 'Andagua', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040403', 'Ayo', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040404', 'Chachas', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040405', 'Chilcaymarca', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040406', 'Choco', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040407', 'Huancarqui', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040408', 'Machaguay', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040409', 'Orcopampa', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040410', 'Pampacolca', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040411', 'Tipan', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040412', 'Uñon', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040413', 'Uraca', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040414', 'Viraco', '0404', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040501', 'Chivay', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040502', 'Achoma', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040503', 'Cabanaconde', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040504', 'Callalli', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040505', 'Caylloma', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040506', 'Coporaque', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040507', 'Huambo', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040508', 'Huanca', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040509', 'Ichupampa', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040510', 'Lari', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040511', 'Lluta', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040512', 'Maca', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040513', 'Madrigal', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040514', 'San Antonio de Chuca', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040515', 'Sibayo', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040516', 'Tapay', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040517', 'Tisco', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040518', 'Tuti', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040519', 'Yanque', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040520', 'Majes', '0405', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040601', 'Chuquibamba', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040602', 'Andaray', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040603', 'Cayarani', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040604', 'Chichas', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040605', 'Iray', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040606', 'Río Grande', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040607', 'Salamanca', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040608', 'Yanaquihua', '0406', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040701', 'Mollendo', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040702', 'Cocachacra', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040703', 'Dean Valdivia', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040704', 'Islay', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040705', 'Mejia', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040706', 'Punta de Bombón', '0407', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040801', 'Cotahuasi', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040802', 'Alca', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040803', 'Charcana', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040804', 'Huaynacotas', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040805', 'Pampamarca', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040806', 'Puyca', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040807', 'Quechualla', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040808', 'Sayla', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040809', 'Tauria', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040810', 'Tomepampa', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('040811', 'Toro', '0408', '04')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050101', 'Ayacucho', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050102', 'Acocro', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050103', 'Acos Vinchos', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050104', 'Carmen Alto', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050105', 'Chiara', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050106', 'Ocros', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050107', 'Pacaycasa', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050108', 'Quinua', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050109', 'San José de Ticllas', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050110', 'San Juan Bautista', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050111', 'Santiago de Pischa', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050112', 'Socos', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050113', 'Tambillo', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050114', 'Vinchos', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050115', 'Jesús Nazareno', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050116', 'Andrés Avelino Cáceres Dorregaray', '0501', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050201', 'Cangallo', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050202', 'Chuschi', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050203', 'Los Morochucos', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050204', 'María Parado de Bellido', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050205', 'Paras', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050206', 'Totos', '0502', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050301', 'Sancos', '0503', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050302', 'Carapo', '0503', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050303', 'Sacsamarca', '0503', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050304', 'Santiago de Lucanamarca', '0503', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050401', 'Huanta', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050402', 'Ayahuanco', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050403', 'Huamanguilla', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050404', 'Iguain', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050405', 'Luricocha', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050406', 'Santillana', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050407', 'Sivia', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050408', 'Llochegua', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050409', 'Canayre', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050410', 'Uchuraccay', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050411', 'Pucacolpa', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050412', 'Chaca', '0504', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050501', 'San Miguel', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050502', 'Anco', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050503', 'Ayna', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050504', 'Chilcas', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050505', 'Chungui', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050506', 'Luis Carranza', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050507', 'Santa Rosa', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050508', 'Tambo', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050509', 'Samugari', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050510', 'Anchihuay', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050511', 'Oronccoy', '0505', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050601', 'Puquio', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050602', 'Aucara', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050603', 'Cabana', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050604', 'Carmen Salcedo', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050605', 'Chaviña', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050606', 'Chipao', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050607', 'Huac-Huas', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050608', 'Laramate', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050609', 'Leoncio Prado', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050610', 'Llauta', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050611', 'Lucanas', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050612', 'Ocaña', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050613', 'Otoca', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050614', 'Saisa', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050615', 'San Cristóbal', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050616', 'San Juan', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050617', 'San Pedro', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050618', 'San Pedro de Palco', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050619', 'Sancos', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050620', 'Santa Ana de Huaycahuacho', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050621', 'Santa Lucia', '0506', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050701', 'Coracora', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050702', 'Chumpi', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050703', 'Coronel Castañeda', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050704', 'Pacapausa', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050705', 'Pullo', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050706', 'Puyusca', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050707', 'San Francisco de Ravacayco', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050708', 'Upahuacho', '0507', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050801', 'Pausa', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050802', 'Colta', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050803', 'Corculla', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050804', 'Lampa', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050805', 'Marcabamba', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050806', 'Oyolo', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050807', 'Pararca', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050808', 'San Javier de Alpabamba', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050809', 'San José de Ushua', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050810', 'Sara Sara', '0508', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050901', 'Querobamba', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050902', 'Belén', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050903', 'Chalcos', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050904', 'Chilcayoc', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050905', 'Huacaña', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050906', 'Morcolla', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050907', 'Paico', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050908', 'San Pedro de Larcay', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050909', 'San Salvador de Quije', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050910', 'Santiago de Paucaray', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('050911', 'Soras', '0509', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051001', 'Huancapi', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051002', 'Alcamenca', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051003', 'Apongo', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051004', 'Asquipata', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051005', 'Canaria', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051006', 'Cayara', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051007', 'Colca', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051008', 'Huamanquiquia', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051009', 'Huancaraylla', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051010', 'Hualla', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051011', 'Sarhua', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051012', 'Vilcanchos', '0510', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051101', 'Vilcas Huaman', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051102', 'Accomarca', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051103', 'Carhuanca', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051104', 'Concepción', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051105', 'Huambalpa', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051106', 'Independencia', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051107', 'Saurama', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('051108', 'Vischongo', '0511', '05')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060101', 'Cajamarca', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060102', 'Asunción', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060103', 'Chetilla', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060104', 'Cospan', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060105', 'Encañada', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060106', 'Jesús', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060107', 'Llacanora', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060108', 'Los Baños del Inca', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060109', 'Magdalena', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060110', 'Matara', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060111', 'Namora', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060112', 'San Juan', '0601', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060201', 'Cajabamba', '0602', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060202', 'Cachachi', '0602', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060203', 'Condebamba', '0602', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060204', 'Sitacocha', '0602', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060301', 'Celendín', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060302', 'Chumuch', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060303', 'Cortegana', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060304', 'Huasmin', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060305', 'Jorge Chávez', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060306', 'José Gálvez', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060307', 'Miguel Iglesias', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060308', 'Oxamarca', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060309', 'Sorochuco', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060310', 'Sucre', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060311', 'Utco', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060312', 'La Libertad de Pallan', '0603', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060401', 'Chota', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060402', 'Anguia', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060403', 'Chadin', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060404', 'Chiguirip', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060405', 'Chimban', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060406', 'Choropampa', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060407', 'Cochabamba', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060408', 'Conchan', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060409', 'Huambos', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060410', 'Lajas', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060411', 'Llama', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060412', 'Miracosta', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060413', 'Paccha', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060414', 'Pion', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060415', 'Querocoto', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060416', 'San Juan de Licupis', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060417', 'Tacabamba', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060418', 'Tocmoche', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060419', 'Chalamarca', '0604', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060501', 'Contumaza', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060502', 'Chilete', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060503', 'Cupisnique', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060504', 'Guzmango', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060505', 'San Benito', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060506', 'Santa Cruz de Toledo', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060507', 'Tantarica', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060508', 'Yonan', '0605', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060601', 'Cutervo', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060602', 'Callayuc', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060603', 'Choros', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060604', 'Cujillo', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060605', 'La Ramada', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060606', 'Pimpingos', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060607', 'Querocotillo', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060608', 'San Andrés de Cutervo', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060609', 'San Juan de Cutervo', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060610', 'San Luis de Lucma', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060611', 'Santa Cruz', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060612', 'Santo Domingo de la Capilla', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060613', 'Santo Tomas', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060614', 'Socota', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060615', 'Toribio Casanova', '0606', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060701', 'Bambamarca', '0607', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060702', 'Chugur', '0607', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060703', 'Hualgayoc', '0607', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060801', 'Jaén', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060802', 'Bellavista', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060803', 'Chontali', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060804', 'Colasay', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060805', 'Huabal', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060806', 'Las Pirias', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060807', 'Pomahuaca', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060808', 'Pucara', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060809', 'Sallique', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060810', 'San Felipe', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060811', 'San José del Alto', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060812', 'Santa Rosa', '0608', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060901', 'San Ignacio', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060902', 'Chirinos', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060903', 'Huarango', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060904', 'La Coipa', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060905', 'Namballe', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060906', 'San José de Lourdes', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('060907', 'Tabaconas', '0609', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061001', 'Pedro Gálvez', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061002', 'Chancay', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061003', 'Eduardo Villanueva', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061004', 'Gregorio Pita', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061005', 'Ichocan', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061006', 'José Manuel Quiroz', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061007', 'José Sabogal', '0610', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061101', 'San Miguel', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061102', 'Bolívar', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061103', 'Calquis', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061104', 'Catilluc', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061105', 'El Prado', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061106', 'La Florida', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061107', 'Llapa', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061108', 'Nanchoc', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061109', 'Niepos', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061110', 'San Gregorio', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061111', 'San Silvestre de Cochan', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061112', 'Tongod', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061113', 'Unión Agua Blanca', '0611', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061201', 'San Pablo', '0612', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061202', 'San Bernardino', '0612', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061203', 'San Luis', '0612', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061204', 'Tumbaden', '0612', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061301', 'Santa Cruz', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061302', 'Andabamba', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061303', 'Catache', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061304', 'Chancaybaños', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061305', 'La Esperanza', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061306', 'Ninabamba', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061307', 'Pulan', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061308', 'Saucepampa', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061309', 'Sexi', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061310', 'Uticyacu', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('061311', 'Yauyucan', '0613', '06')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070101', 'Callao', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070102', 'Bellavista', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070103', 'Carmen de la Legua Reynoso', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070104', 'La Perla', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070105', 'La Punta', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070106', 'Ventanilla', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('070107', 'Mi Perú', '0701', '07')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080101', 'Cusco', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080102', 'Ccorca', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080103', 'Poroy', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080104', 'San Jerónimo', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080105', 'San Sebastian', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080106', 'Santiago', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080107', 'Saylla', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080108', 'Wanchaq', '0801', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080201', 'Acomayo', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080202', 'Acopia', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080203', 'Acos', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080204', 'Mosoc Llacta', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080205', 'Pomacanchi', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080206', 'Rondocan', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080207', 'Sangarara', '0802', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080301', 'Anta', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080302', 'Ancahuasi', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080303', 'Cachimayo', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080304', 'Chinchaypujio', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080305', 'Huarocondo', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080306', 'Limatambo', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080307', 'Mollepata', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080308', 'Pucyura', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080309', 'Zurite', '0803', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080401', 'Calca', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080402', 'Coya', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080403', 'Lamay', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080404', 'Lares', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080405', 'Pisac', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080406', 'San Salvador', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080407', 'Taray', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080408', 'Yanatile', '0804', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080501', 'Yanaoca', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080502', 'Checca', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080503', 'Kunturkanki', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080504', 'Langui', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080505', 'Layo', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080506', 'Pampamarca', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080507', 'Quehue', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080508', 'Tupac Amaru', '0805', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080601', 'Sicuani', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080602', 'Checacupe', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080603', 'Combapata', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080604', 'Marangani', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080605', 'Pitumarca', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080606', 'San Pablo', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080607', 'San Pedro', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080608', 'Tinta', '0806', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080701', 'Santo Tomas', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080702', 'Capacmarca', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080703', 'Chamaca', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080704', 'Colquemarca', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080705', 'Livitaca', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080706', 'Llusco', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080707', 'Quiñota', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080708', 'Velille', '0807', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080801', 'Espinar', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080802', 'Condoroma', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080803', 'Coporaque', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080804', 'Ocoruro', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080805', 'Pallpata', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080806', 'Pichigua', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080807', 'Suyckutambo', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080808', 'Alto Pichigua', '0808', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080901', 'Santa Ana', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080902', 'Echarate', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080903', 'Huayopata', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080904', 'Maranura', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080905', 'Ocobamba', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080906', 'Quellouno', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080907', 'Kimbiri', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080908', 'Santa Teresa', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080909', 'Vilcabamba', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080910', 'Pichari', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080911', 'Inkawasi', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080912', 'Villa Virgen', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080913', 'Villa Kintiarina', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('080914', 'Megantoni', '0809', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081001', 'Paruro', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081002', 'Accha', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081003', 'Ccapi', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081004', 'Colcha', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081005', 'Huanoquite', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081006', 'Omachaç', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081007', 'Paccaritambo', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081008', 'Pillpinto', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081009', 'Yaurisque', '0810', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081101', 'Paucartambo', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081102', 'Caicay', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081103', 'Challabamba', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081104', 'Colquepata', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081105', 'Huancarani', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081106', 'Kosñipata', '0811', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081201', 'Urcos', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081202', 'Andahuaylillas', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081203', 'Camanti', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081204', 'Ccarhuayo', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081205', 'Ccatca', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081206', 'Cusipata', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081207', 'Huaro', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081208', 'Lucre', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081209', 'Marcapata', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081210', 'Ocongate', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081211', 'Oropesa', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081212', 'Quiquijana', '0812', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081301', 'Urubamba', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081302', 'Chinchero', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081303', 'Huayllabamba', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081304', 'Machupicchu', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081305', 'Maras', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081306', 'Ollantaytambo', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('081307', 'Yucay', '0813', '08')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090101', 'Huancavelica', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090102', 'Acobambilla', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090103', 'Acoria', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090104', 'Conayca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090105', 'Cuenca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090106', 'Huachocolpa', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090107', 'Huayllahuara', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090108', 'Izcuchaca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090109', 'Laria', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090110', 'Manta', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090111', 'Mariscal Cáceres', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090112', 'Moya', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090113', 'Nuevo Occoro', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090114', 'Palca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090115', 'Pilchaca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090116', 'Vilca', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090117', 'Yauli', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090118', 'Ascensión', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090119', 'Huando', '0901', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090201', 'Acobamba', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090202', 'Andabamba', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090203', 'Anta', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090204', 'Caja', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090205', 'Marcas', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090206', 'Paucara', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090207', 'Pomacocha', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090208', 'Rosario', '0902', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090301', 'Lircay', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090302', 'Anchonga', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090303', 'Callanmarca', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090304', 'Ccochaccasa', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090305', 'Chincho', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090306', 'Congalla', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090307', 'Huanca-Huanca', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090308', 'Huayllay Grande', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090309', 'Julcamarca', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090310', 'San Antonio de Antaparco', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090311', 'Santo Tomas de Pata', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090312', 'Secclla', '0903', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090401', 'Castrovirreyna', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090402', 'Arma', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090403', 'Aurahua', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090404', 'Capillas', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090405', 'Chupamarca', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090406', 'Cocas', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090407', 'Huachos', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090408', 'Huamatambo', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090409', 'Mollepampa', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090410', 'San Juan', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090411', 'Santa Ana', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090412', 'Tantara', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090413', 'Ticrapo', '0904', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090501', 'Churcampa', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090502', 'Anco', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090503', 'Chinchihuasi', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090504', 'El Carmen', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090505', 'La Merced', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090506', 'Locroja', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090507', 'Paucarbamba', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090508', 'San Miguel de Mayocc', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090509', 'San Pedro de Coris', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090510', 'Pachamarca', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090511', 'Cosme', '0905', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090601', 'Huaytara', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090602', 'Ayavi', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090603', 'Córdova', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090604', 'Huayacundo Arma', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090605', 'Laramarca', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090606', 'Ocoyo', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090607', 'Pilpichaca', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090608', 'Querco', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090609', 'Quito-Arma', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090610', 'San Antonio de Cusicancha', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090611', 'San Francisco de Sangayaico', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090612', 'San Isidro', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090613', 'Santiago de Chocorvos', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090614', 'Santiago de Quirahuara', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090615', 'Santo Domingo de Capillas', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090616', 'Tambo', '0906', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090701', 'Pampas', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090702', 'Acostambo', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090703', 'Acraquia', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090704', 'Ahuaycha', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090705', 'Colcabamba', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090706', 'Daniel Hernández', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090707', 'Huachocolpa', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090709', 'Huaribamba', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090710', 'Ñahuimpuquio', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090711', 'Pazos', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090713', 'Quishuar', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090714', 'Salcabamba', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090715', 'Salcahuasi', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090716', 'San Marcos de Rocchac', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090717', 'Surcubamba', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090718', 'Tintay Puncu', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090719', 'Quichuas', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090720', 'Andaymarca', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090721', 'Roble', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090722', 'Pichos', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('090723', 'Santiago de Tucuma', '0907', '09')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100101', 'Huanuco', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100102', 'Amarilis', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100103', 'Chinchao', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100104', 'Churubamba', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100105', 'Margos', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100106', 'Quisqui (Kichki)', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100107', 'San Francisco de Cayran', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100108', 'San Pedro de Chaulan', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100109', 'Santa María del Valle', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100110', 'Yarumayo', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100111', 'Pillco Marca', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100112', 'Yacus', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100113', 'San Pablo de Pillao', '1001', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100201', 'Ambo', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100202', 'Cayna', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100203', 'Colpas', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100204', 'Conchamarca', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100205', 'Huacar', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100206', 'San Francisco', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100207', 'San Rafael', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100208', 'Tomay Kichwa', '1002', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100301', 'La Unión', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100307', 'Chuquis', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100311', 'Marías', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100313', 'Pachas', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100316', 'Quivilla', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100317', 'Ripan', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100321', 'Shunqui', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100322', 'Sillapata', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100323', 'Yanas', '1003', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100401', 'Huacaybamba', '1004', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100402', 'Canchabamba', '1004', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100403', 'Cochabamba', '1004', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100404', 'Pinra', '1004', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100501', 'Llata', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100502', 'Arancay', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100503', 'Chavín de Pariarca', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100504', 'Jacas Grande', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100505', 'Jircan', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100506', 'Miraflores', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100507', 'Monzón', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100508', 'Punchao', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100509', 'Puños', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100510', 'Singa', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100511', 'Tantamayo', '1005', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100601', 'Rupa-Rupa', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100602', 'Daniel Alomía Robles', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100603', 'Hermílio Valdizan', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100604', 'José Crespo y Castillo', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100605', 'Luyando', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100606', 'Mariano Damaso Beraun', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100607', 'Pucayacu', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100608', 'Castillo Grande', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100609', 'Pueblo Nuevo', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100610', 'Santo Domingo de Anda', '1006', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100701', 'Huacrachuco', '1007', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100702', 'Cholon', '1007', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100703', 'San Buenaventura', '1007', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100704', 'La Morada', '1007', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100705', 'Santa Rosa de Alto Yanajanca', '1007', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100801', 'Panao', '1008', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100802', 'Chaglla', '1008', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100803', 'Molino', '1008', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100804', 'Umari', '1008', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100901', 'Puerto Inca', '1009', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100902', 'Codo del Pozuzo', '1009', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100903', 'Honoria', '1009', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100904', 'Tournavista', '1009', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('100905', 'Yuyapichis', '1009', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101001', 'Jesús', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101002', 'Baños', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101003', 'Jivia', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101004', 'Queropalca', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101005', 'Rondos', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101006', 'San Francisco de Asís', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101007', 'San Miguel de Cauri', '1010', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101101', 'Chavinillo', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101102', 'Cahuac', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101103', 'Chacabamba', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101104', 'Aparicio Pomares', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101105', 'Jacas Chico', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101106', 'Obas', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101107', 'Pampamarca', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('101108', 'Choras', '1011', '10')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110101', 'Ica', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110102', 'La Tinguiña', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110103', 'Los Aquijes', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110104', 'Ocucaje', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110105', 'Pachacutec', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110106', 'Parcona', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110107', 'Pueblo Nuevo', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110108', 'Salas', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110109', 'San José de Los Molinos', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110110', 'San Juan Bautista', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110111', 'Santiago', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110112', 'Subtanjalla', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110113', 'Tate', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110114', 'Yauca del Rosario', '1101', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110201', 'Chincha Alta', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110202', 'Alto Laran', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110203', 'Chavin', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110204', 'Chincha Baja', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110205', 'El Carmen', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110206', 'Grocio Prado', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110207', 'Pueblo Nuevo', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110208', 'San Juan de Yanac', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110209', 'San Pedro de Huacarpana', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110210', 'Sunampe', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110211', 'Tambo de Mora', '1102', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110301', 'Nasca', '1103', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110302', 'Changuillo', '1103', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110303', 'El Ingenio', '1103', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110304', 'Marcona', '1103', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110305', 'Vista Alegre', '1103', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110401', 'Palpa', '1104', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110402', 'Llipata', '1104', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110403', 'Río Grande', '1104', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110404', 'Santa Cruz', '1104', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110405', 'Tibillo', '1104', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110501', 'Pisco', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110502', 'Huancano', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110503', 'Humay', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110504', 'Independencia', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110505', 'Paracas', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110506', 'San Andrés', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110507', 'San Clemente', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('110508', 'Tupac Amaru Inca', '1105', '11')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120101', 'Huancayo', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120104', 'Carhuacallanga', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120105', 'Chacapampa', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120106', 'Chicche', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120107', 'Chilca', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120108', 'Chongos Alto', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120111', 'Chupuro', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120112', 'Colca', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120113', 'Cullhuas', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120114', 'El Tambo', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120116', 'Huacrapuquio', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120117', 'Hualhuas', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120119', 'Huancan', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120120', 'Huasicancha', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120121', 'Huayucachi', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120122', 'Ingenio', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120124', 'Pariahuanca', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120125', 'Pilcomayo', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120126', 'Pucara', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120127', 'Quichuay', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120128', 'Quilcas', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120129', 'San Agustín', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120130', 'San Jerónimo de Tunan', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120132', 'Saño', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120133', 'Sapallanga', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120134', 'Sicaya', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120135', 'Santo Domingo de Acobamba', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120136', 'Viques', '1201', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120201', 'Concepción', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120202', 'Aco', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120203', 'Andamarca', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120204', 'Chambara', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120205', 'Cochas', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120206', 'Comas', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120207', 'Heroínas Toledo', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120208', 'Manzanares', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120209', 'Mariscal Castilla', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120210', 'Matahuasi', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120211', 'Mito', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120212', 'Nueve de Julio', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120213', 'Orcotuna', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120214', 'San José de Quero', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120215', 'Santa Rosa de Ocopa', '1202', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120301', 'Chanchamayo', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120302', 'Perene', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120303', 'Pichanaqui', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120304', 'San Luis de Shuaro', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120305', 'San Ramón', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120306', 'Vitoc', '1203', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120401', 'Jauja', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120402', 'Acolla', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120403', 'Apata', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120404', 'Ataura', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120405', 'Canchayllo', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120406', 'Curicaca', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120407', 'El Mantaro', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120408', 'Huamali', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120409', 'Huaripampa', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120410', 'Huertas', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120411', 'Janjaillo', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120412', 'Julcán', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120413', 'Leonor Ordóñez', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120414', 'Llocllapampa', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120415', 'Marco', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120416', 'Masma', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120417', 'Masma Chicche', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120418', 'Molinos', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120419', 'Monobamba', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120420', 'Muqui', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120421', 'Muquiyauyo', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120422', 'Paca', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120423', 'Paccha', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120424', 'Pancan', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120425', 'Parco', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120426', 'Pomacancha', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120427', 'Ricran', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120428', 'San Lorenzo', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120429', 'San Pedro de Chunan', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120430', 'Sausa', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120431', 'Sincos', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120432', 'Tunan Marca', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120433', 'Yauli', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120434', 'Yauyos', '1204', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120501', 'Junin', '1205', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120502', 'Carhuamayo', '1205', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120503', 'Ondores', '1205', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120504', 'Ulcumayo', '1205', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120601', 'Satipo', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120602', 'Coviriali', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120603', 'Llaylla', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120604', 'Mazamari', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120605', 'Pampa Hermosa', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120606', 'Pangoa', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120607', 'Río Negro', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120608', 'Río Tambo', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120609', 'Vizcatan del Ene', '1206', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120701', 'Tarma', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120702', 'Acobamba', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120703', 'Huaricolca', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120704', 'Huasahuasi', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120705', 'La Unión', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120706', 'Palca', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120707', 'Palcamayo', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120708', 'San Pedro de Cajas', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120709', 'Tapo', '1207', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120801', 'La Oroya', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120802', 'Chacapalpa', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120803', 'Huay-Huay', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120804', 'Marcapomacocha', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120805', 'Morococha', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120806', 'Paccha', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120807', 'Santa Bárbara de Carhuacayan', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120808', 'Santa Rosa de Sacco', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120809', 'Suitucancha', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120810', 'Yauli', '1208', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120901', 'Chupaca', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120902', 'Ahuac', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120903', 'Chongos Bajo', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120904', 'Huachac', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120905', 'Huamancaca Chico', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120906', 'San Juan de Iscos', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120907', 'San Juan de Jarpa', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120908', 'Tres de Diciembre', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('120909', 'Yanacancha', '1209', '12')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130101', 'Trujillo', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130102', 'El Porvenir', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130103', 'Florencia de Mora', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130104', 'Huanchaco', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130105', 'La Esperanza', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130106', 'Laredo', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130107', 'Moche', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130108', 'Poroto', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130109', 'Salaverry', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130110', 'Simbal', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130111', 'Victor Larco Herrera', '1301', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130201', 'Ascope', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130202', 'Chicama', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130203', 'Chocope', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130204', 'Magdalena de Cao', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130205', 'Paijan', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130206', 'Rázuri', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130207', 'Santiago de Cao', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130208', 'Casa Grande', '1302', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130301', 'Bolívar', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130302', 'Bambamarca', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130303', 'Condormarca', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130304', 'Longotea', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130305', 'Uchumarca', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130306', 'Ucuncha', '1303', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130401', 'Chepen', '1304', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130402', 'Pacanga', '1304', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130403', 'Pueblo Nuevo', '1304', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130501', 'Julcan', '1305', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130502', 'Calamarca', '1305', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130503', 'Carabamba', '1305', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130504', 'Huaso', '1305', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130601', 'Otuzco', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130602', 'Agallpampa', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130604', 'Charat', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130605', 'Huaranchal', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130606', 'La Cuesta', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130608', 'Mache', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130610', 'Paranday', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130611', 'Salpo', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130613', 'Sinsicap', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130614', 'Usquil', '1306', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130701', 'San Pedro de Lloc', '1307', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130702', 'Guadalupe', '1307', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130703', 'Jequetepeque', '1307', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130704', 'Pacasmayo', '1307', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130705', 'San José', '1307', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130801', 'Tayabamba', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130802', 'Buldibuyo', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130803', 'Chillia', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130804', 'Huancaspata', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130805', 'Huaylillas', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130806', 'Huayo', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130807', 'Ongon', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130808', 'Parcoy', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130809', 'Pataz', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130810', 'Pias', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130811', 'Santiago de Challas', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130812', 'Taurija', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130813', 'Urpay', '1308', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130901', 'Huamachuco', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130902', 'Chugay', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130903', 'Cochorco', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130904', 'Curgos', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130905', 'Marcabal', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130906', 'Sanagoran', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130907', 'Sarin', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('130908', 'Sartimbamba', '1309', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131001', 'Santiago de Chuco', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131002', 'Angasmarca', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131003', 'Cachicadan', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131004', 'Mollebamba', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131005', 'Mollepata', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131006', 'Quiruvilca', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131007', 'Santa Cruz de Chuca', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131008', 'Sitabamba', '1310', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131101', 'Cascas', '1311', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131102', 'Lucma', '1311', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131103', 'Marmot', '1311', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131104', 'Sayapullo', '1311', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131201', 'Viru', '1312', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131202', 'Chao', '1312', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('131203', 'Guadalupito', '1312', '13')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140101', 'Chiclayo', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140102', 'Chongoyape', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140103', 'Eten', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140104', 'Eten Puerto', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140105', 'José Leonardo Ortiz', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140106', 'La Victoria', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140107', 'Lagunas', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140108', 'Monsefu', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140109', 'Nueva Arica', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140110', 'Oyotun', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140111', 'Picsi', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140112', 'Pimentel', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140113', 'Reque', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140114', 'Santa Rosa', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140115', 'Saña', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140116', 'Cayalti', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140117', 'Patapo', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140118', 'Pomalca', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140119', 'Pucala', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140120', 'Tuman', '1401', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140201', 'Ferreñafe', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140202', 'Cañaris', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140203', 'Incahuasi', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140204', 'Manuel Antonio Mesones Muro', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140205', 'Pitipo', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140206', 'Pueblo Nuevo', '1402', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140301', 'Lambayeque', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140302', 'Chochope', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140303', 'Illimo', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140304', 'Jayanca', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140305', 'Mochumi', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140306', 'Morrope', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140307', 'Motupe', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140308', 'Olmos', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140309', 'Pacora', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140310', 'Salas', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140311', 'San José', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('140312', 'Tucume', '1403', '14')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150101', 'Lima', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150102', 'Ancón', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150103', 'Ate', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150104', 'Barranco', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150105', 'Breña', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150106', 'Carabayllo', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150107', 'Chaclacayo', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150108', 'Chorrillos', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150109', 'Cieneguilla', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150110', 'Comas', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150111', 'El Agustino', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150112', 'Independencia', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150113', 'Jesús María', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150114', 'La Molina', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150115', 'La Victoria', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150116', 'Lince', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150117', 'Los Olivos', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150118', 'Lurigancho', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150119', 'Lurin', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150120', 'Magdalena del Mar', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150121', 'Pueblo Libre', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150122', 'Miraflores', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150123', 'Pachacamac', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150124', 'Pucusana', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150125', 'Puente Piedra', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150126', 'Punta Hermosa', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150127', 'Punta Negra', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150128', 'Rímac', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150129', 'San Bartolo', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150130', 'San Borja', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150131', 'San Isidro', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150132', 'San Juan de Lurigancho', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150133', 'San Juan de Miraflores', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150134', 'San Luis', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150135', 'San Martín de Porres', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150136', 'San Miguel', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150137', 'Santa Anita', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150138', 'Santa María del Mar', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150139', 'Santa Rosa', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150140', 'Santiago de Surco', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150141', 'Surquillo', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150142', 'Villa El Salvador', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150143', 'Villa María del Triunfo', '1501', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150201', 'Barranca', '1502', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150202', 'Paramonga', '1502', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150203', 'Pativilca', '1502', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150204', 'Supe', '1502', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150205', 'Supe Puerto', '1502', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150301', 'Cajatambo', '1503', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150302', 'Copa', '1503', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150303', 'Gorgor', '1503', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150304', 'Huancapon', '1503', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150305', 'Manas', '1503', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150401', 'Canta', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150402', 'Arahuay', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150403', 'Huamantanga', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150404', 'Huaros', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150405', 'Lachaqui', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150406', 'San Buenaventura', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150407', 'Santa Rosa de Quives', '1504', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150501', 'San Vicente de Cañete', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150502', 'Asia', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150503', 'Calango', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150504', 'Cerro Azul', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150505', 'Chilca', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150506', 'Coayllo', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150507', 'Imperial', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150508', 'Lunahuana', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150509', 'Mala', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150510', 'Nuevo Imperial', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150511', 'Pacaran', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150512', 'Quilmana', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150513', 'San Antonio', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150514', 'San Luis', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150515', 'Santa Cruz de Flores', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150516', 'Zúñiga', '1505', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150601', 'Huaral', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150602', 'Atavillos Alto', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150603', 'Atavillos Bajo', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150604', 'Aucallama', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150605', 'Chancay', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150606', 'Ihuari', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150607', 'Lampian', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150608', 'Pacaraos', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150609', 'San Miguel de Acos', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150610', 'Santa Cruz de Andamarca', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150611', 'Sumbilca', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150612', 'Veintisiete de Noviembre', '1506', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150701', 'Matucana', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150702', 'Antioquia', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150703', 'Callahuanca', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150704', 'Carampoma', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150705', 'Chicla', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150706', 'Cuenca', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150707', 'Huachupampa', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150708', 'Huanza', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150709', 'Huarochiri', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150710', 'Lahuaytambo', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150711', 'Langa', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150712', 'Laraos', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150713', 'Mariatana', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150714', 'Ricardo Palma', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150715', 'San Andrés de Tupicocha', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150716', 'San Antonio', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150717', 'San Bartolomé', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150718', 'San Damian', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150719', 'San Juan de Iris', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150720', 'San Juan de Tantaranche', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150721', 'San Lorenzo de Quinti', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150722', 'San Mateo', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150723', 'San Mateo de Otao', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150724', 'San Pedro de Casta', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150725', 'San Pedro de Huancayre', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150726', 'Sangallaya', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150727', 'Santa Cruz de Cocachacra', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150728', 'Santa Eulalia', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150729', 'Santiago de Anchucaya', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150730', 'Santiago de Tuna', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150731', 'Santo Domingo de Los Olleros', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150732', 'Surco', '1507', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150801', 'Huacho', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150802', 'Ambar', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150803', 'Caleta de Carquin', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150804', 'Checras', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150805', 'Hualmay', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150806', 'Huaura', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150807', 'Leoncio Prado', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150808', 'Paccho', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150809', 'Santa Leonor', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150810', 'Santa María', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150811', 'Sayan', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150812', 'Vegueta', '1508', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150901', 'Oyon', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150902', 'Andajes', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150903', 'Caujul', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150904', 'Cochamarca', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150905', 'Navan', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('150906', 'Pachangara', '1509', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151001', 'Yauyos', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151002', 'Alis', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151003', 'Allauca', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151004', 'Ayaviri', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151005', 'Azángaro', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151006', 'Cacra', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151007', 'Carania', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151008', 'Catahuasi', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151009', 'Chocos', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151010', 'Cochas', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151011', 'Colonia', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151012', 'Hongos', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151013', 'Huampara', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151014', 'Huancaya', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151015', 'Huangascar', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151016', 'Huantan', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151017', 'Huañec', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151018', 'Laraos', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151019', 'Lincha', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151020', 'Madean', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151021', 'Miraflores', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151022', 'Omas', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151023', 'Putinza', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151024', 'Quinches', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151025', 'Quinocay', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151026', 'San Joaquín', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151027', 'San Pedro de Pilas', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151028', 'Tanta', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151029', 'Tauripampa', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151030', 'Tomas', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151031', 'Tupe', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151032', 'Viñac', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('151033', 'Vitis', '1510', '15')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160101', 'Iquitos', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160102', 'Alto Nanay', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160103', 'Fernando Lores', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160104', 'Indiana', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160105', 'Las Amazonas', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160106', 'Mazan', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160107', 'Napo', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160108', 'Punchana', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160110', 'Torres Causana', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160112', 'Belén', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160113', 'San Juan Bautista', '1601', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160201', 'Yurimaguas', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160202', 'Balsapuerto', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160205', 'Jeberos', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160206', 'Lagunas', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160210', 'Santa Cruz', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160211', 'Teniente Cesar López Rojas', '1602', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160301', 'Nauta', '1603', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160302', 'Parinari', '1603', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160303', 'Tigre', '1603', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160304', 'Trompeteros', '1603', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160305', 'Urarinas', '1603', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160401', 'Ramón Castilla', '1604', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160402', 'Pebas', '1604', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160403', 'Yavari', '1604', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160404', 'San Pablo', '1604', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160501', 'Requena', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160502', 'Alto Tapiche', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160503', 'Capelo', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160504', 'Emilio San Martín', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160505', 'Maquia', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160506', 'Puinahua', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160507', 'Saquena', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160508', 'Soplin', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160509', 'Tapiche', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160510', 'Jenaro Herrera', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160511', 'Yaquerana', '1605', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160601', 'Contamana', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160602', 'Inahuaya', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160603', 'Padre Márquez', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160604', 'Pampa Hermosa', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160605', 'Sarayacu', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160606', 'Vargas Guerra', '1606', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160701', 'Barranca', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160702', 'Cahuapanas', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160703', 'Manseriche', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160704', 'Morona', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160705', 'Pastaza', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160706', 'Andoas', '1607', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160801', 'Putumayo', '1608', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160802', 'Rosa Panduro', '1608', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160803', 'Teniente Manuel Clavero', '1608', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('160804', 'Yaguas', '1608', '16')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170101', 'Tambopata', '1701', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170102', 'Inambari', '1701', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170103', 'Las Piedras', '1701', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170104', 'Laberinto', '1701', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170201', 'Manu', '1702', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170202', 'Fitzcarrald', '1702', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170203', 'Madre de Dios', '1702', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170204', 'Huepetuhe', '1702', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170301', 'Iñapari', '1703', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170302', 'Iberia', '1703', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('170303', 'Tahuamanu', '1703', '17')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180101', 'Moquegua', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180102', 'Carumas', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180103', 'Cuchumbaya', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180104', 'Samegua', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180105', 'San Cristóbal', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180106', 'Torata', '1801', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180201', 'Omate', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180202', 'Chojata', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180203', 'Coalaque', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180204', 'Ichuña', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180205', 'La Capilla', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180206', 'Lloque', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180207', 'Matalaque', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180208', 'Puquina', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180209', 'Quinistaquillas', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180210', 'Ubinas', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180211', 'Yunga', '1802', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180301', 'Ilo', '1803', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180302', 'El Algarrobal', '1803', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('180303', 'Pacocha', '1803', '18')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190101', 'Chaupimarca', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190102', 'Huachon', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190103', 'Huariaca', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190104', 'Huayllay', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190105', 'Ninacaca', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190106', 'Pallanchacra', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190107', 'Paucartambo', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190108', 'San Francisco de Asís de Yarusyacan', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190109', 'Simon Bolívar', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190110', 'Ticlacayan', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190111', 'Tinyahuarco', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190112', 'Vicco', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190113', 'Yanacancha', '1901', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190201', 'Yanahuanca', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190202', 'Chacayan', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190203', 'Goyllarisquizga', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190204', 'Paucar', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190205', 'San Pedro de Pillao', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190206', 'Santa Ana de Tusi', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190207', 'Tapuc', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190208', 'Vilcabamba', '1902', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190301', 'Oxapampa', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190302', 'Chontabamba', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190303', 'Huancabamba', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190304', 'Palcazu', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190305', 'Pozuzo', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190306', 'Puerto Bermúdez', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190307', 'Villa Rica', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('190308', 'Constitución', '1903', '19')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200101', 'Piura', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200104', 'Castilla', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200105', 'Catacaos', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200107', 'Cura Mori', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200108', 'El Tallan', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200109', 'La Arena', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200110', 'La Unión', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200111', 'Las Lomas', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200114', 'Tambo Grande', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200115', 'Veintiseis de Octubre', '2001', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200201', 'Ayabaca', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200202', 'Frias', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200203', 'Jilili', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200204', 'Lagunas', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200205', 'Montero', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200206', 'Pacaipampa', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200207', 'Paimas', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200208', 'Sapillica', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200209', 'Sicchez', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200210', 'Suyo', '2002', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200301', 'Huancabamba', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200302', 'Canchaque', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200303', 'El Carmen de la Frontera', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200304', 'Huarmaca', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200305', 'Lalaquiz', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200306', 'San Miguel de El Faique', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200307', 'Sondor', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200308', 'Sondorillo', '2003', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200401', 'Chulucanas', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200402', 'Buenos Aires', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200403', 'Chalaco', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200404', 'La Matanza', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200405', 'Morropon', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200406', 'Salitral', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200407', 'San Juan de Bigote', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200408', 'Santa Catalina de Mossa', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200409', 'Santo Domingo', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200410', 'Yamango', '2004', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200501', 'Paita', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200502', 'Amotape', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200503', 'Arenal', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200504', 'Colan', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200505', 'La Huaca', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200506', 'Tamarindo', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200507', 'Vichayal', '2005', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200601', 'Sullana', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200602', 'Bellavista', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200603', 'Ignacio Escudero', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200604', 'Lancones', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200605', 'Marcavelica', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200606', 'Miguel Checa', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200607', 'Querecotillo', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200608', 'Salitral', '2006', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200701', 'Pariñas', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200702', 'El Alto', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200703', 'La Brea', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200704', 'Lobitos', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200705', 'Los Organos', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200706', 'Mancora', '2007', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200801', 'Sechura', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200802', 'Bellavista de la Unión', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200803', 'Bernal', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200804', 'Cristo Nos Valga', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200805', 'Vice', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('200806', 'Rinconada Llicuar', '2008', '20')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210101', 'Puno', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210102', 'Acora', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210103', 'Amantani', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210104', 'Atuncolla', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210105', 'Capachica', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210106', 'Chucuito', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210107', 'Coata', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210108', 'Huata', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210109', 'Mañazo', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210110', 'Paucarcolla', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210111', 'Pichacani', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210112', 'Plateria', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210113', 'San Antonio', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210114', 'Tiquillaca', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210115', 'Vilque', '2101', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210201', 'Azángaro', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210202', 'Achaya', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210203', 'Arapa', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210204', 'Asillo', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210205', 'Caminaca', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210206', 'Chupa', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210207', 'José Domingo Choquehuanca', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210208', 'Muñani', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210209', 'Potoni', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210210', 'Saman', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210211', 'San Anton', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210212', 'San José', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210213', 'San Juan de Salinas', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210214', 'Santiago de Pupuja', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210215', 'Tirapata', '2102', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210301', 'Macusani', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210302', 'Ajoyani', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210303', 'Ayapata', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210304', 'Coasa', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210305', 'Corani', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210306', 'Crucero', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210307', 'Ituata', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210308', 'Ollachea', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210309', 'San Gaban', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210310', 'Usicayos', '2103', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210401', 'Juli', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210402', 'Desaguadero', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210403', 'Huacullani', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210404', 'Kelluyo', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210405', 'Pisacoma', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210406', 'Pomata', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210407', 'Zepita', '2104', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210501', 'Ilave', '2105', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210502', 'Capazo', '2105', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210503', 'Pilcuyo', '2105', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210504', 'Santa Rosa', '2105', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210505', 'Conduriri', '2105', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210601', 'Huancane', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210602', 'Cojata', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210603', 'Huatasani', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210604', 'Inchupalla', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210605', 'Pusi', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210606', 'Rosaspata', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210607', 'Taraco', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210608', 'Vilque Chico', '2106', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210701', 'Lampa', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210702', 'Cabanilla', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210703', 'Calapuja', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210704', 'Nicasio', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210705', 'Ocuviri', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210706', 'Palca', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210707', 'Paratia', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210708', 'Pucara', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210709', 'Santa Lucia', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210710', 'Vilavila', '2107', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210801', 'Ayaviri', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210802', 'Antauta', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210803', 'Cupi', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210804', 'Llalli', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210805', 'Macari', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210806', 'Nuñoa', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210807', 'Orurillo', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210808', 'Santa Rosa', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210809', 'Umachiri', '2108', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210901', 'Moho', '2109', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210902', 'Conima', '2109', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210903', 'Huayrapata', '2109', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('210904', 'Tilali', '2109', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211001', 'Putina', '2110', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211002', 'Ananea', '2110', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211003', 'Pedro Vilca Apaza', '2110', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211004', 'Quilcapuncu', '2110', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211005', 'Sina', '2110', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211101', 'Juliaca', '2111', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211102', 'Cabana', '2111', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211103', 'Cabanillas', '2111', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211104', 'Caracoto', '2111', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211105', 'San Miguel', '2111', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211201', 'Sandia', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211202', 'Cuyocuyo', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211203', 'Limbani', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211204', 'Patambuco', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211205', 'Phara', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211206', 'Quiaca', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211207', 'San Juan del Oro', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211208', 'Yanahuaya', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211209', 'Alto Inambari', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211210', 'San Pedro de Putina Punco', '2112', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211301', 'Yunguyo', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211302', 'Anapia', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211303', 'Copani', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211304', 'Cuturapi', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211305', 'Ollaraya', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211306', 'Tinicachi', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('211307', 'Unicachi', '2113', '21')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220101', 'Moyobamba', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220102', 'Calzada', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220103', 'Habana', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220104', 'Jepelacio', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220105', 'Soritor', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220106', 'Yantalo', '2201', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220201', 'Bellavista', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220202', 'Alto Biavo', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220203', 'Bajo Biavo', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220204', 'Huallaga', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220205', 'San Pablo', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220206', 'San Rafael', '2202', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220301', 'San José de Sisa', '2203', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220302', 'Agua Blanca', '2203', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220303', 'San Martín', '2203', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220304', 'Santa Rosa', '2203', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220305', 'Shatoja', '2203', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220401', 'Saposoa', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220402', 'Alto Saposoa', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220403', 'El Eslabón', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220404', 'Piscoyacu', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220405', 'Sacanche', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220406', 'Tingo de Saposoa', '2204', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220501', 'Lamas', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220502', 'Alonso de Alvarado', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220503', 'Barranquita', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220504', 'Caynarachi', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220505', 'Cuñumbuqui', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220506', 'Pinto Recodo', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220507', 'Rumisapa', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220508', 'San Roque de Cumbaza', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220509', 'Shanao', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220510', 'Tabalosos', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220511', 'Zapatero', '2205', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220601', 'Juanjuí', '2206', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220602', 'Campanilla', '2206', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220603', 'Huicungo', '2206', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220604', 'Pachiza', '2206', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220605', 'Pajarillo', '2206', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220701', 'Picota', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220702', 'Buenos Aires', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220703', 'Caspisapa', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220704', 'Pilluana', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220705', 'Pucacaca', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220706', 'San Cristóbal', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220707', 'San Hilarión', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220708', 'Shamboyacu', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220709', 'Tingo de Ponasa', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220710', 'Tres Unidos', '2207', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220801', 'Rioja', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220802', 'Awajun', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220803', 'Elías Soplin Vargas', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220804', 'Nueva Cajamarca', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220805', 'Pardo Miguel', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220806', 'Posic', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220807', 'San Fernando', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220808', 'Yorongos', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220809', 'Yuracyacu', '2208', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220901', 'Tarapoto', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220902', 'Alberto Leveau', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220903', 'Cacatachi', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220904', 'Chazuta', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220905', 'Chipurana', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220906', 'El Porvenir', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220907', 'Huimbayoc', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220908', 'Juan Guerra', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220909', 'La Banda de Shilcayo', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220910', 'Morales', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220911', 'Papaplaya', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220912', 'San Antonio', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220913', 'Sauce', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('220914', 'Shapaja', '2209', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('221001', 'Tocache', '2210', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('221002', 'Nuevo Progreso', '2210', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('221003', 'Polvora', '2210', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('221004', 'Shunte', '2210', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('221005', 'Uchiza', '2210', '22')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230101', 'Tacna', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230102', 'Alto de la Alianza', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230103', 'Calana', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230104', 'Ciudad Nueva', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230105', 'Inclan', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230106', 'Pachia', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230107', 'Palca', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230108', 'Pocollay', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230109', 'Sama', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230110', 'Coronel Gregorio Albarracín Lanchipa', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230111', 'La Yarada los Palos', '2301', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230201', 'Candarave', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230202', 'Cairani', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230203', 'Camilaca', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230204', 'Curibaya', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230205', 'Huanuara', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230206', 'Quilahuani', '2302', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230301', 'Locumba', '2303', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230302', 'Ilabaya', '2303', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230303', 'Ite', '2303', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230401', 'Tarata', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230402', 'Héroes Albarracín', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230403', 'Estique', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230404', 'Estique-Pampa', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230405', 'Sitajara', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230406', 'Susapaya', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230407', 'Tarucachi', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('230408', 'Ticaco', '2304', '23')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240101', 'Tumbes', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240102', 'Corrales', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240103', 'La Cruz', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240104', 'Pampas de Hospital', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240105', 'San Jacinto', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240106', 'San Juan de la Virgen', '2401', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240201', 'Zorritos', '2402', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240202', 'Casitas', '2402', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240203', 'Canoas de Punta Sal', '2402', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240301', 'Zarumilla', '2403', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240302', 'Aguas Verdes', '2403', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240303', 'Matapalo', '2403', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('240304', 'Papayal', '2403', '24')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250101', 'Calleria', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250102', 'Campoverde', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250103', 'Iparia', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250104', 'Masisea', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250105', 'Yarinacocha', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250106', 'Nueva Requena', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250107', 'Manantay', '2501', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250201', 'Raymondi', '2502', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250202', 'Sepahua', '2502', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250203', 'Tahuania', '2502', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250204', 'Yurua', '2502', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250301', 'Padre Abad', '2503', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250302', 'Irazola', '2503', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250303', 'Curimana', '2503', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250304', 'Neshuya', '2503', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250305', 'Alexander Von Humboldt', '2503', '25')
INSERT INTO distritos (coddist, desdist, codprovin, codzona) VALUES ('250401', 'Purus', '2504', '25')
USE IN DISTRITOS

********************
FUNCTION Tabla_Cat06
********************
IF !USED("TABL")
	GoCfgVta.odatadm.abrirtabla("ABRIR","CBDMTABL","TABL","TABL01")
ENDIF

DIMENSION aDBFTBL(13,4)
STORE "" TO aDBFTBL


FOR K = 1 TO ALEN(aDBFTBL,1) - 1
	aDBFTBL(K ,1)="TD"
ENDFOR

aDBFTBL(1 ,2)="0"
aDBFTBL(1 ,3)= "DOC.TRIB.NO.DOM.SIN.RUC"
aDBFTBL(2 ,2)="1"
aDBFTBL(2 ,3)= "Documento Nacional de Identidad"
aDBFTBL(3 ,2)="4"
aDBFTBL(3 ,3)= "Carnet de extranjería"
aDBFTBL(4 ,2)="6"
aDBFTBL(4 ,3)= "Registro Unico de Contributentes"
aDBFTBL(5 ,2)="7"
aDBFTBL(5 ,3)= "Pasaporte"
aDBFTBL(6 ,2)="A"
aDBFTBL(6 ,3)= "Cédula Diplomática de identidad"
aDBFTBL(7 ,2)="B"
aDBFTBL(7 ,3)= "DOC.IDENT.PAIS.RESIDENCIA-NO.D"
aDBFTBL(8 ,2)="C"
aDBFTBL(8 ,3)= "Tax Identification Number - TIN – Doc Trib PP.NN"
aDBFTBL(9 ,2)="D"
aDBFTBL(9 ,3)= "Identification Number - IN – Doc Trib PP. JJ"
aDBFTBL(10,2)="E"
aDBFTBL(10,3)= "TAM- Tarjeta Andina de Migración"
aDBFTBL(11,2)="F"
aDBFTBL(11,3)= "Permiso Temporal de Permanencia - PTP"
aDBFTBL(12,2)="G"
aDBFTBL(12,3)= "Salvoconducto"

FOR K = 1 TO ALEN(aDBFTBL,1) - 1
	aDBFTBL(K ,4)= 0
ENDFOR


aDBFTBL(13,1)=	"00"
aDBFTBL(13,2)=	"TD"
aDBFTBL(13,3)=	"Tipo documento identificación"
aDBFTBL(13,4)=	1

SELECT TABL
APPEND FROM ARRAY aDbfTbl
** VETT: INSERT INTO FILENAME FROM ARRAY se usa cuando la no esta abierta pero se debe tener 
** la ruta completa y/o su ubicacion debe estar en el SET PATH  IDUPD:334937240-23/01/2024 06:34 PM 
*!*	EJEMPLO: INSERT INTO cbdmtabl FROM ARRAY aDBFTBL



IF USED("TABL")
	USE IN TABL
ENDIF

** VETT: NUEVA GRE-SUNAT IDUPD:145172128-05/02/2024 11:04 AM 
**********************************************************************************************************
** 1. ACTUALIZAR ESTRUCTURAS Y PROCEDIMIENTO ALMACENADOS RELACIONADOS CON GRE - SUNAT 2023					**
** EN LA VENTANA DE COMANDOS:																			**
** Para ejecutar este programa primero se debe ejecutar el Inicio_NOmcia correspondiente				**
** en modo developer(desarrollo) desde el proyecto														**	
** Supongamos que la base de datos a actualizar es P0042024 en la compañia oniblom						**
** En la ventana de comandos:																			**	
** Ejecutamos DO k:\aplvfp\bsinfo\progs2\inicio_oniblom													**
** Ejecutamos DO FORM k:\aplvfp\bsinfo\forms\funfun_selec_ventas.scx 									**
** Para asegurarnos que todos los path necesarios esten en memoria										**			
** Luego ejecutar: DO UpdDB_GRE_2024 WITH "CIA004","P0042024" IN k:\aplvfp\bsinfo\progs2\upd_system.prg **
**********************************************************************************************************
**********************************************************************************************************
** 2. Esta función debe ir en la base de datos PXXXAAAA IDUPD:3602053256-01/02/2024 08:49 PM 
** Ejem: con la BD -> P0012024.DBC 
** OPEN DATABASE P0012024
** modify procedure
** Si ya existe la function UPD_GUIA sustituir por el codigo que esta entre TEXT ... ENDTEXT 
********************
FUNCTION UPDATE_PROC
********************
PARAMETERS PsNomCia, PsNomBdAno
TEXT TO LcTxt
*********************
FUNCTION Num_Registro
*********************
m.Nreg =  RECNO()
IF EMPTY(nroreg_1)
	replace nroreg_1 WITH m.Nreg
ENDIF

RETURN .t.
*****************
FUNCTION ADD_GUIA
*****************
*!*	SCATTER MEMVAR MEMO <
*!*	LsTabla=RUTATABLA('RUTA','VTAVGUIA','','','')
*!*	m.GloDoc 	= m.Observ	
*!*	m.CodDoc	= m.TpoRf1	
*!*	m.NroDoc	= m.NroRf1	
*!*	INSERT INTO (LsTabla) FROM MEMVAR 

*----------------*
FUNCTION UPD_GUIA   && este procedimiento debe ir en la base de datos PXXXAAAA Ejem: P0012024.DBC
*----------------*
SCATTER MEMVAR MEMO 

IF !(M.TPORF1='G/R'	AND M.TIPMOV='S' )
	RETURN .T.
ENDIF
IF EMPTY(M.TPORF1) OR EMPTY(M.NRORF1)
	RETURN .T.
ENDIF
lCerrarTabla= .f.	
IF !USED('GUIA')
	LsTabla=RUTATABLA('ABRIR','VTAVGUIA','GUIA','VGUI01','')
	IF !USED('GUIA')
		RETURN .T. 
	ENDIF
	lCerrarTabla= .T.
ENDIF

LOCAL LsDirecc ,LlOpenDirec
LlOpenDirec = .F.
IF !USED('CDIRE1')
	LsDirecc = RUTATABLA('ABRIR','CCTCDIRE','CDIRE1','DIRE01','')
	IF !USED('CDIRE1')
		RETURN .T. 
	ENDIF
	LlOpenDirec = .T.
ENDIF

LlOpenClie = .F.
IF !USED('CCTCLIEN')
	LsDirecc = RUTATABLA('ABRIR','CCTCLIEN','CCTCLIEN','CLIEN04','')
	IF !USED('CCTCLIEN')
		RETURN .T. 
	ENDIF
	LlOpenClie = .T.
ENDIF
SELECT CCTCLIEN
IF SEEK(GSClfCli+m.CodCli,"CCTCLIEN","CLIEN04")
	m.NomCli	= CCTCLIEN.RazSoc
ELSE
	m.NomCli	= "ERROR:Revisar datos del cliente"	
ENDIF

** VETT: Completamos datos de destino y/o punto de llegada IDUPD:1761301869-04/01/2024 02:33 PM 
m.DesDire = ''
SELECT CDIRE1
*!*	IF !LlOpenDirec   && El cursor ya fue creado y solo contiene direcciones del cliente  
*!*		LOCATE FOR codDire = m.CodDire
*!*	ELSE  && Tenemos que seleccionar segun la llave 
	LsLLave = GSClfCli+m.CodCli
	LOCATE FOR ClfAux+CodAux = LsLlave AND codDire = m.CodDire
*!*	ENDIF
IF FOUND()
	m.DesDire		=	DesDire
	m.DirEnt		=	DesDire
	m.UbiPlleg		=	UbiGeo
	m.CodEstLleg	=	CodEstb
	m.EmailDest		=	EmailD
ENDIF

lCerrarAUXI2= .f.	
IF !USED('AUXI2')
	LsTabla=RUTATABLA('ABRIR','CBDMAUXI','AUXI2','AUXI01','')
	IF !USED('AUXI2')
		RETURN .T. 
	ENDIF
	lCerrarAuxi2= .T.
ENDIF
lCerrarSEDE= .f.	
IF !USED('SEDES')
	LsTabla=RUTATABLA('ABRIR','SEDES','SEDES','SEDE01','')
	IF !USED('SEDES')
		RETURN .T. 
	ENDIF
	lCerrarSEDE= .T.
ENDIF

** VETT: Completamos datos del establecimiento emisor (remitente) IDUPD:3552534242-04/01/2024 02:32 PM 
IF VARTYPE("GsClfEst")<>"C"
	GsClfEst = []
ENDIF
IF VARTYPE("m.PtoVta")<>"C"
	m.PtoVta = []
ENDIF
IF !EMPTY(m.PtoVta) AND !EMPTY(m.CodEstPart)
	SELECT AUXI2
	Locate FOR Sede+PtoVta+CodEstb=m.CodSed+m.PtoVta+m.CodEstPart
	IF FOUND()
		m.UbiPpart = AUXI2.Ubigeo
		m.DirRemit = AUXI2.NomAUx
		m.UrbRemit = AUXI2.NomUrban
	ENDIF
ELSE
	SELECT SEDES	
	SEEK GoCfGAlm.CodSed
	IF FOUND()
		m.UbiPpart		= SEDES.Ubigeo
		m.DirRemit		= SEDES.Nombre
		m.CodEstPart	= SEDES.CodEstb
		m.UrbRemit		= SEDES.NomUrban
	ENDIF	
ENDIF

** VETT: Completamos datos del transportista y conductor IDUPD:181878888-04/01/2024 02:32 PM

SELECT AUXI2
SEEK GsClfTra+m.CodTra
IF FOUND()
	IF !EMPTY(m.DNICond) AND m.DniCond<>TRIM(AUXI2.DNICond)
		=RLOCK()
		replace DniCond		WITH	m.DNICond ,; 			
		TPDCond		WITH	m.TPDCond ,; 			
		NomCond		WITH	m.NomCond ,; 			
		ApeCond		WITH	m.ApeCond ,; 			
		BreVet		WITH	m.Brevet
		
		FLUSH IN AUXI2
		UNLOCK IN AUXI2
	ELSE
		m.DniCond	= DNICond 			
		m.TPDCond	= TPDCond 			
		m.NomCond	= NomCond 			
		m.ApeCond	= ApeCond 			
		m.Brevet	= Brevet	
	ENDIF
	m.nroregmtc = nroregmtc
	m.nroautesp = nroautesp
ENDIF

SELECT guia

lExiste=SEEK(m.TpoRf1+m.NroRf1,'GUIA')
IF !lExiste
	APPEND BLANK 
ELSE
	=RLOCK()
ENDIF

m.Desmotivo = IIF(VARTYPE(GoCfgVta.cDesmotivo)='C' AND !ISNULL(GoCfgVta.cDesmotivo) AND !EMPTY(GoCfgVta.cDesmotivo),GoCfgVta.cDesmotivo,"")

m.NroRegMTC = IIF(VARTYPE(GoCfgVta.cNroRegMTC)='C' AND !ISNULL(GoCfgVta.cNroRegMTC) AND !EMPTY(GoCfgVta.cNroRegMTC),GoCfgVta.cNroRegMTC,m.NroRegMTC)
m.NroAutESP = IIF(VARTYPE(GoCfgVta.cNroAutESP)='C' AND !ISNULL(GoCfgVta.cNroAutESP) AND !EMPTY(GoCfgVta.cNroAutESP),GoCfgVta.cNroAutESP,m.NroAutESP)
replace CodDoc		WITH	m.TpoRf1	,;
		NroDoc		WITH	m.NroRf1	,;
		CodCli		WITH	m.CodCli	,;
		NomCli		WITH	m.NomCli	,;
		FchDoc		WITH	m.FchDoc	,;
		GloDoc 		WITH	m.Observ	,;
		Motivo		WITH	m.Motivo	,;
		CodVen		WITH	m.CodVen 	,;
		CodMon		WITH	m.CodMon	,;						
		NomTra		WITH	m.NomTra	,;
		DirTra		WITH	m.DirTra	,;
		RucTra		WITH	m.RucTra	,;
		PlaTra		WITH	m.PlaTra	,;
		DirCLi  	WITH	m.DesDire	,;  
		CodTra		WITH	m.CodTra	,;
		UbiPpart	WITH	m.UbiPpart ,;
		CodEstPart	WITH	m.CodEstPart,;
		DirRemit	WITH	m.DirRemit	,;	
		DirEnt		WITH	m.DirEnt ,;
		UrbRemit	WITH	m.UrbRemit ,;
		UbiPlleg	WITH	m.UbiPlleg ,;
		CodEstLleg	WITH	m.CodEstLleg ,;
		EmailDest	WITH	m.EmailDest ,;
		PesoBruto	WITH	m.PesoBruto ,;
		ModTra		WITH	m.ModTra ,;
		UndMed		WITH	m.UndMed ,;
		FiniTras	WITH	m.FiniTras ,;
		NomTra		WITH	m.NomTra ,;
		RucTra		WITH	m.RucTra ,;
		DniCond		WITH	m.DNICond ,; 			
		TPDCond		WITH	m.TPDCond ,; 			
		NomCond		WITH	m.NomCond ,; 			
		ApeCond		WITH	m.ApeCond ,; 			
		Brevet		WITH	m.Brevet , ;
		nroregmtc   WITH	m.nroregmtc ,;
		nroautesp   WITH    m.nroautesp,; 
		DesMotivo	WITH	m.Desmotivo			
		
		
** Grabamos la direccion segun codDire de almctran		
		
IF lExiste 		
	** No tocamos el flag	
*  	REPLACE FlgEst	WITH m.FlgEst
*!*		IF m.FlgEst='A'
*!*			REPLACE FlgEst	WITH 'A'
*!*		ENDIF
ELSE
	REPLACE FlgEst	WITH 'E'
ENDIF		
FLUSH IN GUIA				
UNLOCK IN GUIA

IF lCerrarTabla
	USE IN GUIA
ENDIF
IF LlOpenDirec
	USE IN CDIRE1
ENDIF
IF lCerrarSEDE
	USE IN SEDES
ENDIF
IF lCerrarAUXI2
	USE IN AUXI2
ENDIF
IF LlOpenClie
	USE IN CCTCLIEN
ENDIF
** VETT: [FIN] IDUPD:3602053256-01/02/2024 08:49 PM 
RETURN .T.						
*****************
FUNCTION DEL_GUIA
*****************
LsTabla=RUTATABLA('RUTA','VTAVGUIA','','','')
SCATTER MEMVAR
DELETE FROM (LsTabla) WHERE	CodDoc	= m.TpoRf1	;
									AND NroDoc	= m.NroRf1	
******************
FUNCTION RUTATABLA
******************
LPARAMETERS cAccion as String ,cArchivo as String ,cAlias as String ,cTag as String ,cExclu as String ,cPk as String as Boolean
LOCAL LsRutaTabla,LsArea_Act,LcArcTmp
IF PARAMETERS()<2
	RETURN -1
ENDIF
LsArea_Act=SELECT()

IF UPPER(cAccion) ='TEMP'
	DO CASE 
		CASE UPPER(cAccion) ='TEMP_STR'
			IF EMPTY(cArchivo) or ISNULL(cArchivo)
				RETURN .f.
			ENDIF
			IF !USED(cArchivo)
				RETURN .f.
			ENDIF
			
			LcArcTmp = this.tmppath +SYS(3)
			SELECT (cArchivo)
			COPY STRUCTURE TO (LcArcTmp) with cdx
			SELECT 0
			use (LcArcTmp) ALIAS (cAlias) EXCLU  
		CASE UPPER(cAccion) ='TEMP_SQL'
			IF EMPTY(cArchivo) or ISNULL(cArchivo)
				RETURN .f.
			ENDIF
			IF !USED(cArchivo)
				RETURN .f.
			ENDIF
			LcArcTmp = this.tmppath +SYS(3)
			IF VERSION(5) < 700    
				select * from (cArchivo) where 0>1 into Cursor temporal
				SELE Temporal
				COPY TO (LcArcTmp)
				USE IN TEMPORAL
				SELE 0
				USE (LcArcTmp) ALIAS (cAlias) EXCLUSIVE
			ELSE
				SELECT * from (cArchivo) where 0>1 into cursor (cAlias) readwrite 	
			ENDIF
					
	ENDCASE
	IF !EMPTY(LsArea_act)
		SELE (LsArea_Act)
	ENDIF
	RETURN .t.	
ENDIF


	IF USED('DBFS')
		SELECT DBFS
	ELSE
		SELECT 0
		use admin!sistdbfs ORDER archivo ALIAS dbfs
	ENDIF
	**SEEK PADR(UPPER(cSistema),LEN(DBFS.SISTEMA))+UPPER(cArchivo)
	SEEK TRIM(UPPER(cArchivo))
	IF !FOUND()
		this.serror = 'No esta definida la tabla '+cArchivo+ ' en el registro de entidades SISTDBFS'
		RETURN ''
	ENDIF
	*** Ubico la base de datos a la que pertenece la tabla ***
	DO CASE
		CASE dbfs.connect = 'FOXPRO.DBC'
			DO CASE	
				CASE 	!(EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos))	 
					LsRutaTabla=TRIM(Basedatos)+'!'+cArchivo 
				CASE	EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos)
					DO CASE
						CASE DBFS.Ubicacion='INI'
							LsRutaTabla='ADMIN!'+cArchivo 	
						CASE DBFS.Ubicacion='CIA'
							LsRutaTabla=TRIM(DBFS.Ubicacion)+GsCodCia+'!'+cArchivo	
						CASE DBFS.Ubicacion='PER'
							LsRutaTabla=LEFT(TRIM(DBFS.Ubicacion),1)+GsCodCia+LEFT(GsPeriodo,4)+'!'+cArchivo
					ENDCASE
			ENDCASE		
		CASE dbfs.CONNECT = 'FOXPRO'				
					LsRutaTabla=PATH_001+cArchivo
	ENDCASE
	***
	IF UPPER(cAccion)='RUTA' 
		IF !EMPTY(LsArea_act)
			SELE (LsArea_Act)
		ENDIF
		RETURN TRIM(LsRutaTabla)	 
	ENDIF

	SELE 0
	DO CASE
		CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND !EMPTY(cExclu)
			USE (LsRutaTabla) ALIAS (cAlias) EXCLU
		CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND EMPTY(cExclu)
			IF !USED(cAlias)
				USE (LsRutaTabla) ALIAS (cAlias) SHARED AGAIN
			ELSE
				SELECT  (cAlias)
			ENDIF

		CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND !EMPTY(cExclu)
			USE (LsRutaTabla) EXCLU
		CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND EMPTY(cExclu)
			USE (LsRutaTabla) SHARED AGAIN
			
		OTHER 		
			IF !EMPTY(LsArea_act)
				SELE (LsArea_Act)
			ENDIF
			RETURN .F.
	ENDCASE
	IF !USED()
		IF !EMPTY(LsArea_act)
			SELE (LsArea_Act)
		ENDIF
		RETURN .F.
	ENDIF
	IF !EMPTY(cTag)
		SET ORDER TO (cTag)
	ENDIF
	
RETURN .t.

FUNCTION Grb_Nombres
m.NomBre = Nombres
IF _triggerlevel =1
endif
replace Nombre WITH m.Nombre
RETURN .t.
					
ENDTEXT
LcFileProc=ADDBS(GoEntorno.TmpPath)+"ProgAAAA.TXT"
STRTOFILE(LcTxt,LcFileProc) 
IF !DBUSED(PsNomBdAno)
	OPEN DATABASE (PsNomBdAno)
ENDIF
SET DATABASE TO (PsNomBdAno)
APPEND PROCEDURES FROM (LcFileProc) OVERWRITE
RETURN
***********************
FUNCTION UpdDB_GRE_2024
* Ejemplo de ejecucion desde ventana de comandos:
* DO UpdDB_GRE_2024 WITH "CIA001","P0012024" IN k:\aplvfp\bsinfo\progs2\upd_system.prg
***********************
PARAMETERS PsNomCia, PsNomBdAno,PnMes
IF VARTYPE(PnMes)<>'N'
	PnMes = 1
ENDIF
WAIT WINDOW "Inicializando... " NOWAIT 
#include const.h 
GsCodCia			=	SUBSTR(PsNomCia,4,3)
Goentorno.GsCodCia	=	GsCodCia
GoEntpub.GsCodCia	=	GsCodCia
Goentorno.TsPathCia	=	Goentorno.pathdatacia(GsCodCia)
GoEntPub.TsPathCia	=	Goentpub.Pathdatacia(GsCodCia)

GsAnoMes	=	SUBSTR(PsNomBdAno,5,4)+TRAN(PnMes,[@L 99])     
GOENTORNO.GsPeriodo	= GsAnoMes
GoEntpub.GsPeriodo	= GsAnoMes     
GoEntpub.pathdatacia_ano 
GoEntorno.pathdatacia_ano
IF EMPTY(VERSION(2))
	goentpub.setpath('','RESET')
ENDIF
goentpub.setpath(goentpub.tspathcia)
goentpub.setpath(GoEntpub.TsPathcia_ano)

** Estas entidades (ZONAS,Provincias,Distritos) se deben actualizar para obtener el UBIGEO 
** Del remitente (Punto partida) Cliente (Punto de llegada) y establecimientos anexos (SUNAT)
WAIT WINDOW "Actualizando ZONAS.... " NOWAIT 
DO ZONAS		WITH PsNomCia	&& Departamentos
WAIT WINDOW "Actualizando Provincias.... " NOWAIT 
DO Provincias	WITH PsNomCia
WAIT WINDOW "Actualizando Distritos.... " NOWAIT 
DO Distritos	WITH PsNomCia
WAIT WINDOW "Actualizando Cuotas.... " NOWAIT 
DO VTARCUOT		WITH PsNomCia   && DO vtarcuot WITH "CIA001" IN k:\aplvfp\bsinfo\progs2\upd_system.prg


IF !DBUSED(PsNomBdAno)
	OPEN DATABASE (PsNomBdAno)
ENDIF
SET DATABASE TO (PsNomBdAno)
LsCurPath=SYS(5)+CURDIR()
WAIT WINDOW "Actualizando vistas en "+PsNomBdAno+"..... " NOWAIT 
SET DEFAULT TO ADDBS(GoEntpub.TsPathcia_ano)
IF FILE(ADDBS(GoEntpub.TsPathcia_ano)+"CPICULTI.dbf")
	DELETE FILE ADDBS(GoEntpub.TsPathcia_ano)+"CPICULTI.dbf"
ENDIF
IF FILE(ADDBS(GoEntpub.TsPathcia_ano)+"CPICULTI.cdx")
	DELETE FILE ADDBS(GoEntpub.TsPathcia_ano)+"CPICULTI.cdx"
ENDIF
IF !INDBC('CPICULTI','TABLE')
	DO MakeTable_CPICULTI IN k:\aplvfp\bsinfo\progs\p0012017.PRG
ENDIF
**
IF FILE(ADDBS(GoEntpub.TsPathcia_ano)+"CPICUXLT.dbf")
	DELETE FILE ADDBS(GoEntpub.TsPathcia_ano)+"CPICUXLT.dbf"
ENDIF
IF FILE(ADDBS(GoEntpub.TsPathcia_ano)+"CPICUXLT.cdx")
	DELETE FILE ADDBS(GoEntpub.TsPathcia_ano)+"CPICUXLT.cdx"
ENDIF
IF !INDBC('CPICUXLT','TABLE')
	DO MakeTable_CPICUXLT IN k:\aplvfp\bsinfo\progs\p0012017.PRG
ENDIF

** OJO: La vista no se creara si no encuentra las tablas que la componen:
IF !INDBC('V_CULTIVOS_X_LOTE','VIEW')
	DO MakeView_V_CULTIVOS_X_LOTE WITH PsNomCia,PsNomBdAno IN k:\aplvfp\bsinfo\progs\p0012017.PRG
ENDIF
IF USED("CPICUXLT")
	USE IN CPICUXLT
ENDIF
IF USED("CPICULTI")
	USE IN CPICULTI
ENDIF
SET DEFAULT TO ADDBS(LsCurPath)
WAIT WINDOW "Actualizando procedimientos almacenados en "+PsNomBdAno+"..... " NOWAIT 
** Actualizamos procedimientos almacenados **
DO UPDATE_PROC WITH PsNomCia, PsNomBdAno
**-----------------------------------------**
WAIT WINDOW "Actualizando configuración de variables en "+"ADMTCNFG"+"...... " NOWAIT 
** ADMTCNFG **
** Registros
SELECT 0
USE ADMTCNFG
LOCATE FOR CodCfg='CFG' AND UPPER(Variable)='GSMODTRA'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux) VALUES ('CFG', 'MODALIDAD DE TRASLADO (GRE)', 'GsModTra', 'MT')
ENDIF
LOCATE FOR CodCfg='CFG' AND UPPER(Variable)='GSCIAS'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux) VALUES ('CFG', 'EMPRESAS (COMPAÑIAS)', 'GsCias', 'CIA')
ENDIF
LOCATE FOR CodCfg='CFG' AND UPPER(Variable)='GSCLFEST'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux) VALUES ('CFG', 'ESTABLECIMIENTO PTO. PARTIDA X SEDE Y PUNTO VENTA', 'GsClfEst', 'EST')
ENDIF
LOCATE FOR CodCfg='CFG' AND UPPER(Variable)='GSMOTIVO'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux) VALUES ('CFG', 'Motivos de traslado GRE', 'GsMotivo', 'MG')
ENDIF
LOCATE FOR CodCfg='CFG' AND UPPER(Variable)='GSCLFSEE'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux,CodAux1,CodAux2,CodAux3,CodAux4) VALUES ('CFG', 'Sistema de emisión electrónica 1', 'GsClfSEE', 'SEE','OSE','EFACT','CSV'	,'v1.0')
ENDIF
LOCATE FOR CodCfg='CF2' AND UPPER(Variable)='GSCLFSEE'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux,CodAux1,CodAux2,CodAux3,CodAux4) VALUES ('CF2', 'Sistema de emisión electrónica 2', 'GsClfSEE', 'SEE','PSE','SENDA','CSV'	,'v1.0')
ENDIF
LOCATE FOR CodCfg='CF3' AND UPPER(Variable)='GSCLFSEE'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux,CodAux1,CodAux2,CodAux3,CodAux4) VALUES ('CF3', 'Sistema de emisión electrónica 3', 'GsClfSEE', 'SEE','SFS','SUNAT','TXT'	,'v2.0')
ENDIF
LOCATE FOR CodCfg='CF4' AND UPPER(Variable)='GSCLFSEE'
IF !FOUND()
	INSERT INTO ADMTCNFG (codcfg, glocfg, variable, clfaux,CodAux1,CodAux2,CodAux3,CodAux4) VALUES ('CF4', 'Sistema de emisión electrónica 4', 'GsClfSEE', 'SEE','OWN','XML'  ,'vO-N696','v2.0')
ENDIF
USE IN ADMTCNFG

WAIT WINDOW "Actualizando tablas detalle en Almacen "+"ALMTGSIS"+"...... " NOWAIT 
** ALMTGSIS **
** Registros
SELECT 0
USE ADDBS(goentorno.tspathcia)+"ALMTGSIS"
LOCATE FOR Tabla='00' AND UPPER(CODIGO)='MT'
IF !FOUND()
	INSERT INTO ALMTGSIS (Tabla,Codigo,Nombre,Digitos) VALUES ('00','MT','MODALIDAD DE TRASLADO (GRE)',2)
ENDIF
LOCATE FOR Tabla='MT' AND UPPER(CODIGO)='01'
IF !FOUND()
	INSERT INTO ALMTGSIS (Tabla,Codigo,Nombre,Digitos) VALUES ('MT','01','TRANSPORTE PUBLICO',0  )
ENDIF
LOCATE FOR Tabla='MT' AND UPPER(CODIGO)='02'
IF !FOUND()
	INSERT INTO ALMTGSIS (Tabla,Codigo,Nombre,Digitos) VALUES ('MT','02','TRANSPORTE PRIVADO',0  )
ENDIF
** Unidades de medida hologada con catalogo Sunat GRE
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','4A','BOBINAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BJ','BALDE',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BLL','BARRILES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BG','BOLSA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BO','BOTELLAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BX','CAJA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CT','CARTONES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CEN','CIENTO DE UNIDADES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CY','CILINDRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CJ','CONOS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','DZN','DOCENA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','DZP','DOCENA POR 10**6',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','BE','FARDO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GLI','GALON INGLES (4,545956L)',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GRM','GRAMO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GRO','GRUESA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','HLT','HECTOLITRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LEF','HOJA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','SET','JUEGO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','KGM','KILOGRAMO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','KWH','KILOVATIO HORA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','KT','KIT',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','CA','LATAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LBR','LIBRAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LTR','LITRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MWH','MEGAWATT HORA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MTR','METRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MTK','METRO CUADRADO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MTQ','METRO CUBICO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MGM','MILIGRAMOS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MLT','MILILITRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MMT','MILIMETRO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MMK','MILIMETRO CUADRADO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MMQ','MILIMETRO CUBICO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','MLL','MILLARES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','UM','MILLON DE UNIDADES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','ONZ','ONZAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PF','PALETAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PK','PAQUETES',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PR','PAR',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','C62','PIEZAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','PG','PLACAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','ST','PLIEGO',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','INH','PULGADAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','RM','RESMA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','DR','TAMBOR',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','STN','TONELADA CORTA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','LTN','TONELADA LARGA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','TNE','TONELADAS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','TU','TUBOS',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','NIU','UNIDAD (BIENES)',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','ZZ','UNIDAD (SERVICIOS)',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','GLL','US GALON (3,7843 L)',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','YRD','YARDA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)
Insert into almtgsis(Tabla,Codigo,Nombre,Digitos,Selec,Respon,Coding,Codsal,Defecto,Coduser,Fchhora,Diavto ) values ( 'UD','YDK','YARDA CUADRADA',0,.F.,'','','',.F.,"Victor",DATETIME(),0)

USE IN ALMTGSIS

WAIT WINDOW "Actualizando tablas detalle en contabilidad "+"CBDMTABL"+"....... " NOWAIT 
** CBDMTABL **
** Registros
SELECT 0
USE ADDBS(goentorno.tspathcia)+"cbdmtabl"
LOCATE FOR Tabla='00' AND UPPER(CODIGO)='MG'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( '00','MG','Motivo de traslado GRE',2,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='01'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','01','01 - Ventas',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='02'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','02','02 - Compra',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='03'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','03','03 - Venta con entrega a terceros',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='04'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','04','04 - Traslado entre establecimientos de la misma empresa',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG'  AND UPPER(CODIGO)='05'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','05','05 - Consignación',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='06'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','06','06 - Devolución',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='07'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','07','07 - Recojo de bienes transformados',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='08'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','08','08 - Importación',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='09'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','09','09 - Exportación',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='13'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','13','13 - Otros',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='14'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','14','14 - Venta sujeta a confirmación del comprador',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='17'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','17','17 - Traslado de bienes para transformación',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='MG' AND UPPER(CODIGO)='18'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'MG','18','18 - Traslado emisor itinerante CP',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='01' AND UPPER(CODIGO)='EST'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( '01','EST','ESTABLECIMIENTO PTO. PARTIDA X SEDE Y PUNTO VENTA',4,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='00' AND UPPER(CODIGO)='ES'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( '00','ES','ESTABLECIMIENTOS ANEXOS SUNAT',4,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0000'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0000','DIRECCION PRINCIPAL REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0001'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0001','DIRECCION ESTABLECIMIENTO 0001 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0002'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0002','DIRECCION ESTABLECIMIENTO 0002 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0003'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0003','DIRECCION ESTABLECIMIENTO 0003 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0004'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0004','DIRECCION ESTABLECIMIENTO 0004 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0005'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0005','DIRECCION ESTABLECIMIENTO 0005 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0006'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0006','DIRECCION ESTABLECIMIENTO 0006 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='ES' AND UPPER(CODIGO)='0007'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'ES','0007','DIRECCION ESTABLECIMIENTO 0007 REGISTRADA EN SUNAT',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='0'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','0','DOC.TRIB.NO.DOM.SIN.RUC',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='1'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','1','Documento Nacional de Identidad',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='4'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','4','Carnet de extranjería',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='6'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','6','Registro Unico de Contributentes',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='7'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','7','Pasaporte',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='A'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','A','Cédula Diplomática de identidad',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='B'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','B','DOC.IDENT.PAIS.RESIDENCIA-NO.D',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='C'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','C','Tax Identification Number - TIN – Doc Trib PP.NN',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='D'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','D','Identification Number - IN – Doc Trib PP. JJ',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='E'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','E','TAM- Tarjeta Andina de Migración',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='F'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','F','Permiso Temporal de Permanencia - PTP',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='TD' AND UPPER(CODIGO)='G'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( 'TD','G','Salvoconducto',0,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
LOCATE FOR Tabla='00' AND UPPER(CODIGO)='TD'
IF !FOUND()
	Insert into cbdmtabl(Tabla,Codigo,Nombre,Digitos,Codcta,Codadd,Codref,Piddig,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim ) values ( '00','TD','Tipo documento identificación',1,'','','',.F.,"Victor",DATETIME(),'',Ctod([]),'',Ctod([]))
ENDIF
USE IN CBDMTABL

WAIT WINDOW "Actualizando clasificacion de auxiliares en contabilidad "+"CBDMAUXI"+"........ " NOWAIT 
** CBDMAUXI ** 
** Estructura
SELECT 0
USE ADDBS(goentorno.tspathcia)+"CBDMAUXI" EXCLUSIVE ALIAS AUXI
ALTER TABLE ALIAS() ADD COLUMN PlaTra C(10)
ALTER TABLE ALIAS() ADD COLUMN Brevet C(20)
ALTER TABLE ALIAS() ADD COLUMN NroRegMTC C(20)
ALTER TABLE ALIAS() ADD COLUMN NroAutESP C(50)
ALTER TABLE ALIAS() ADD COLUMN codestb C(4)
ALTER TABLE ALIAS() ALTER COLUMN Codzona C(2)
ALTER TABLE ALIAS() ADD COLUMN Codprovin C(4)
ALTER TABLE ALIAS() ALTER COLUMN Coddist C(6)
ALTER TABLE ALIAS() ADD COLUMN Nomurban C(30)
ALTER TABLE ALIAS() ADD COLUMN Ubigeo C(10)
ALTER TABLE ALIAS() ADD COLUMN Tpdcond C(1)
ALTER TABLE ALIAS() ADD COLUMN Dnicond C(15)
ALTER TABLE ALIAS() ADD COLUMN Nomcond C(40)
ALTER TABLE ALIAS() ADD COLUMN Apecond C(40)
ALTER TABLE ALIAS() ADD COLUMN Sede C(3)
ALTER TABLE ALIAS() ADD COLUMN Ptovta C(3)
** Registros 
Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0000','DIRECCION PRINCIPAL SEGUN REGISTRO SUNAT','','','','','','','','',Ctod([]),'','','11','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','15','1501','150121','','150121','0000','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'001','020')
Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0001','DIRECCION ESTABLECIMIENTO 0001 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod([]),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','11','1109','110109','','110109','0002','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'002','010')
*!*	Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0003','DIRECCION ESTABLECIMIENTO 0003 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod([]),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','11','1109','110109','','110109','0003','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'002','05')
*!*	Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0004','DIRECCION ESTABLECIMIENTO 0004 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod([]),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','11','1102','110102','','110102','0004','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'002','05')
*!*	Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0005','DIRECCION ESTABLECIMIENTO 0005 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod(´´),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','11','1102','110102','','110102','0005','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'002','06')
*!*	Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0006','DIRECCION ESTABLECIMIENTO 0006 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod([]),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','15','1503','150123','','150123','0006','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'001','02')
*!*	Insert into cbdmauxi(Clfaux,Codaux,Nomaux,Diraux,Disaux,Rucaux,Nivcom,Libaux,Tpoaux,Locaux,Tlfaux,Fching,Flgsit,Coddep,Coddis,Finanz,Indust,Moroso,Iniaux,Codpos,Nomc_v,Calaux,Flging,Vto_inic,Monto_min,Mon_letra,Inter_letr,Monto_letr,Codfam,Tasa_int,Ubiaux,Tngaux,Coduser,Fchhora,Ap_pater,Ap_mater,Nombre1,Nombre2,Email,Cndpgo,Codpais,Codzona,Codprovin,Coddist,Nomurban,Ubigeo,Codestb,Nroregmtc,Nroautesp,Tpdcond,Dnicond,Nomcond,Apecond,Platra,Brevet,Transport,Usercrea,Fchcrea,Usermodi,Fchmodi,Userelim,Fchelim,Sede,Ptovta ) values ( 'EST','0007','DIRECCION ESTABLECIMIENTO 0007 - SI EXISTE, SINO BORRAR REGISTRO','','','','','','','','',Ctod([]),'','','','','','','','','','','',0,0,0,0,0,'',0,'','','',Ctod([]),'','','','','miemail@hotmail.com; miemail@yahoo.com','','51','11','1108','110108','','110108','0007','','','','','','','','','','Victor',Ctot( [04/01/2024 07:57:03 AM] ),'',Ctod([]),'',Ctod([]),'002','04')
USE IN AUXI

WAIT WINDOW "Actualizando maestro de clientes en ventas "+"CCTCLIEN"+"......... " NOWAIT 
** CCTCLIEN **
** Estructura **
SELECT 0
USE ADDBS(goentorno.tspathcia)+"CCTCLIEN" EXCLUSIVE ALIAS CLIE
ALTER TABLE ALIAS() ADD COLUMN EMAIL VARCHAR(200)
USE IN CLIE

WAIT WINDOW "Actualizando maestro de direcciones por cliente en ventas "+"CCTCDIRE"+".......... " NOWAIT 
** CCTCDIRE **
** Estructura **
SELECT 0
USE ADDBS(goentorno.tspathcia)+"CCTCDIRE" EXCLUSIVE ALIAS CDIRE
ALTER TABLE ALIAS() ALTER COLUMN Codzona C(2)
ALTER TABLE ALIAS() ADD COLUMN Codprovin C(4)
ALTER TABLE ALIAS() ALTER COLUMN Coddist C(6)
ALTER TABLE ALIAS() ADD COLUMN Nomurban Varchar(60)
ALTER TABLE ALIAS() ADD COLUMN Ubigeo C(10)
ALTER TABLE ALIAS() ADD COLUMN Codestb C(4)
ALTER TABLE ALIAS() ADD COLUMN Emaild Varchar(200)
ALTER TABLE ALIAS() ADD COLUMN Longitud Float(13,9)
ALTER TABLE ALIAS() ADD COLUMN Latitud Float(13,9)
USE IN CDIRE

WAIT WINDOW "Actualizando cabecera de GUIAS en ventas "+"VTAVGUIA"+"........... " NOWAIT 
SELECT 0
** VTAVGUIA **
IF USED("VTAVGUIA")
	USE IN VTAVGUIA
ENDIF
IF USED("GUIA")
	USE IN GUIA
ENDIF
** Estructura **
USE ADDBS(goentorno.tspathcia)+"VTAVGUIA" EXCLUSIVE ALIAS GUIA
ALTER TABLE ALIAS() ALTER COLUMN 	Motivo		N(2)
ALTER TABLE ALIAS() ALTER COLUMN 	DirEnt		Varchar(200)
ALTER TABLE ALIAS() ADD COLUMN		UbiPpart	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		UbiPlleg	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		ubitransp	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		CodEstPart	char(4)
ALTER TABLE ALIAS() ADD COLUMN		CodEstLleg	char(4)
ALTER TABLE ALIAS() ADD COLUMN		DirRemit	Varchar(200)
ALTER TABLE ALIAS() ADD COLUMN		UrbRemit	Char(30)
ALTER TABLE ALIAS() ADD COLUMN		EmailDest	Varchar(40)
ALTER TABLE ALIAS() ADD COLUMN		PesoBruto	N(10,4)
ALTER TABLE ALIAS() ADD COLUMN		ModTra		C(2)
ALTER TABLE ALIAS() ADD COLUMN		UndMed		C(4)
ALTER TABLE ALIAS() ADD COLUMN		FiniTras	Datetime
ALTER TABLE ALIAS() ADD COLUMN		DniCond		C(15) 			
ALTER TABLE ALIAS() ADD COLUMN		TPDCond		C(1)		
ALTER TABLE ALIAS() ADD COLUMN		NomCond		Char(40)			
ALTER TABLE ALIAS() ADD COLUMN		ApeCond		Char(40) 			
ALTER TABLE ALIAS() ADD COLUMN		Brevet		Char(10) 
ALTER TABLE ALIAS() ADD COLUMN		nroregmtc   Char(20) 
ALTER TABLE ALIAS() ADD COLUMN		nroautesp   VarChar(50) 
ALTER TABLE ALIAS() ADD COLUMN		DesMotivo	VarChar(60)
ALTER TABLE ALIAS() ADD COLUMN		CodTra		Char(3)

 		
USE IN GUIA

WAIT WINDOW "Actualizando maestro de correlativos en ventas "+"VTATDOCM"+"............ " NOWAIT 
SELECT 0
** VTATDOCM **
** Estructura **
USE ADDBS(goentorno.tspathcia)+"VTATDOCM" EXCLUSIVE ALIAS TDOC
ALTER TABLE ALIAS() ALTER COLUMN 	NroDoc		N(15)
ALTER TABLE ALIAS() ALTER COLUMN 	Serie		C(4)
** VETT: Activa/Desactiva envios a sunat 	IDUPD:3020348537-05/11/2024 01:54 PM
ALTER TABLE ALIAS() ADD		COLUMN	infsunat	L
** VETT:  									IDUPD:3020348537-05/11/2024 01:54 PM

** VETT: Agregando la serie al indice DOCM01 y actualizamos DBFS y CDXS IDUPD:4157984881-11/09/2024 03:59 PM 
DELETE TAG DOCM01
INDEX ON SEDE+CODDOC+PTOVTA+SERIE TAG DOCM01
** Actualizamos en maestro de tablas (DBFS)
IF !USED("DBFS")
	SELECT 0
	USE ADMIN!SISTDBFS ALIAS DBFS
	SET ORDER TO ARCHIVO
ENDIF
SELECT DBFS
IF !SEEK("VTATDOCM","DBFS","ARCHIVO")
	INSERT INTO DBFS (Sistema,Archivo,Concepto,ALIAS,GRUPO,Trans_str,Ubicacion,Basedatos,servidor,connect) VALUES ("VENTAS",'VTATDOCM','Correlativo de documentos de ventas','DOCM',"TR_VTA",.F.,'CIA','','(Local)','FOXPRO.DBC')
ENDIF
UPDATE DBFS SET eval_valor_pk = "THIS.CodSed +THIS.XsCodDoc +THIS.XsPtoVta +THIS.XsSerie",eval_campo_id = "NRODOC" WHERE ARCHIVO="VTATDOCM"

** Actualizamos en maestro de indices (CDXS)
IF !USED("CDXS")
	SELECT 0
	USE ADMIN!SISTCDXS ALIAS CDXS
	SET ORDER TO SISTEMA	&& SISTEMA+ARCHIVO+INDICE
ENDIF
SELECT CDXS
SEEK PADR('VENTAS',LEN(sistema))+PADR("VTATDOCM",LEN(ARCHIVO))+"DOCM01"
IF !FOUND()
	Insert into sistcdxs(Sistema,Archivo,Indice,Llave,Marca,Descend,Primary,Candidato ) values ( 'VENTAS','VTATDOCM','DOCM01','SEDE+CODDOC+PTOVTA','X',.F.,.F.,.F.)
ENDIF
UPDATE CDXS SET LLAVE="SEDE+CODDOC+PTOVTA+SERIE" WHERE ARCHIVO="VTATDOCM" AND INDICE = "DOCM01"

** VETT: [FIN] IDUPD:4157984881-11/09/2024 03:59 PM
USE IN TDOC

SELECT 0
** CCBRGDOC **
** Estructura **
USE ADDBS(goentorno.tspathcia)+"CCBRGDOC" EXCLUSIVE ALIAS GDOC
ALTER TABLE ALIAS() ADD COLUMN 	N_CUOTAS   N(3)
ALTER TABLE ALIAS() ADD COLUMN 	PORDETR    N(5,2)
ALTER TABLE ALIAS() ADD COLUMN 	impdetr    N(14,4)
ALTER TABLE ALIAS() ADD COLUMN 	cat54detr  C(3)
USE IN GDOC


WAIT WINDOW "Actualizando cabecera de transacciones de almacen "+"ALMCTRAN"+"............. " NOWAIT 
SELECT 0
** ALMCTRAN **
** Estructura **
USE ADDBS(goentorno.tspathcia_ano)+"ALMCTRAN" EXCLUSIVE ALIAS CTRA
DELETE TAG ALL
*ALTER TABLE ALIAS() ALTER COLUMN 	NroDoc		C(15)   && Esto NO va ** VETT:  IDUPD:3007946141-05/04/2024 11:34 AM
ALTER TABLE ALIAS() ALTER COLUMN 	NroRf1		C(15)
ALTER TABLE ALIAS() ALTER COLUMN 	NroRf2		C(15)
ALTER TABLE ALIAS() ALTER COLUMN 	NroRf3		C(15)
ALTER TABLE ALIAS() ALTER COLUMN 	NroRfb		C(15)
ALTER TABLE ALIAS() ALTER COLUMN 	Motivo		N(2)
ALTER TABLE ALIAS() ALTER COLUMN	Brevet		Char(10) 
ALTER TABLE ALIAS() ALTER COLUMN	Observ		VarChar(200) 
ALTER TABLE ALIAS() ADD COLUMN		PtoVta		Char(3) 	
ALTER TABLE ALIAS() ADD COLUMN		UbiPpart	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		UbiPlleg	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		ubitransp	Char(10)
ALTER TABLE ALIAS() ADD COLUMN		CodEstPart	char(4)
ALTER TABLE ALIAS() ADD COLUMN		CodEstLleg	char(4)
ALTER TABLE ALIAS() ADD COLUMN		PesoBruto	N(10,4)
ALTER TABLE ALIAS() ADD COLUMN		ModTra		C(2)
ALTER TABLE ALIAS() ADD COLUMN		UndMed		C(4)
ALTER TABLE ALIAS() ADD COLUMN		FiniTras	Datetime
ALTER TABLE ALIAS() ADD COLUMN		Fentrans	Datetime
ALTER TABLE ALIAS() ADD COLUMN		DniCond		C(15) 			
ALTER TABLE ALIAS() ADD COLUMN		TPDCond		C(1)		
ALTER TABLE ALIAS() ADD COLUMN		NomCond		Char(40)			
ALTER TABLE ALIAS() ADD COLUMN		ApeCond		Char(40) 			

INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA01
INDEX ON NROODT+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA02
INDEX ON TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA03
INDEX ON CODPRO+DTOS(FCHDOC)+NRORF1+FLGFAC TAG CTRA04
INDEX ON DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG CTRA05
INDEX ON TPORF1+NRORF1+ALMORI+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA06
INDEX ON TPORFB+NRORFB+SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA07
*!*	***** Change properties for ALMCTRAN *****
*!*	CREATE TRIGGER ON 'ALMCTRAN' FOR DELETE AS del_guia()
*!*	CREATE TRIGGER ON 'ALMCTRAN' FOR INSERT AS add_guia()
*!*	CREATE TRIGGER ON 'ALMCTRAN' FOR UPDATE AS upd_guia()

USE IN CTRA 

** VETT: Campos adicionales para homologar correlativo de almacenes con Gen_ID IDUPD:3446567357-02/04/2024 10:04 AM
WAIT WINDOW "Actualizando cabecera de transacciones de almacen "+"ALMDTRAN"+"............. " NOWAIT 
SELECT 0
** ALMDTRAN **
** Estructura **
USE ADDBS(goentorno.tspathcia_ano)+"ALMDTRAN" EXCLUSIVE ALIAS DTRA
DELETE TAG ALL
*ALTER TABLE ALIAS() ALTER COLUMN 	NroDoc		C(15)
INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC+STR(NROITM,3,0) TAG DTRA01
INDEX ON SUBALM+CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA02
INDEX ON CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA03
INDEX ON TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC TAG DTRA04
INDEX ON SUBALM+TIPMOV+CODMOV+CODMAT+NRODOC+DTOS(FCHDOC) TAG DTRA05
INDEX ON TIPMOV+CODMOV+CODMAT+DTOS(FCHDOC) TAG DTRA06
INDEX ON ALMORI+SUBALM+TIPMOV+CODMOV+NRODOC+CODMAT TAG DTRA07
INDEX ON CODOPE+NROAST+ANOAST+TPORFB+NRORFB+TPOREF+NROREF+CODMAT TAG DTRA08
INDEX ON CODSED+CODMAT+DTOS(FCHDOC)+TIPMOV+CODMOV+NRODOC TAG DTRA09
INDEX ON DTOS(FCHDOC)+CODMAT+TIPMOV+CODMOV+NRODOC TAG DTRA10
INDEX ON CODPRD TAG DTRA11
USE IN DTRA 

WAIT WINDOW "Actualizando cabecera de transacciones de almacen "+"ALMCDOCM"+"............. " NOWAIT 
SELECT 0
** ALMCDOCM **
** Estructura **
USE ADDBS(goentorno.tspathcia_ano)+"ALMCDOCM" EXCLUSIVE ALIAS DOCM
ALTER TABLE ALMCDOCM ADD COLUMN LEN_ID N(3)
ALTER TABLE ALMCDOCM ADD COLUMN CORR_U L
REPLACE ALL Len_ID WITH 10
REPLACE ALL ant_mes WITH 1
REPLACE ALL corr_u WITH .T.
REPLACE ALL Campo_ID WITH "NRODOC"
REPLACE ALL T_DESTINO WITH "CTRA"
USE IN DOCM

WAIT WINDOW "Actualizando vista de impresion FACT/BOLE/GRE "+"FACT_BOL"+".............. " NOWAIT 
SELECT 0		
USE ADDBS(goentorno.locpath)+"FACT_BOL" EXCLUSIVE ALIAS FBOL
ALTER TABLE ALIAS() ALTER COLUMN	NRODOC		Char(15) 
USE IN FBOL

WAIT WINDOW "Actualizando archivo de configuración "+"CONFIG.INI"+"............... " NOWAIT 
=ADD_CONFIG()
LcLineas = ""
WAIT WINDOW "Proceso terminado, revisar tareas pendientes" NOWAIT 
TEXT TO LcLineas 
	PROCESO TERMINADO
	======= =========
	
	Tareas pendientes:
	
	1.	Remover la regla (Rule) "len_id()" del campo "campo_id" en la tabla CIAXXX!VTATDOCM.
  		XXX es el codigo de la compañia (empresa) EJEM: 
  		USE CIA001!VTATDOCM EXCL
  		MODIFY STRUCTURE 
  		** Posicionarse en el campo CAMPO_ID
  		** En el lado derecho en el recuadro Field validation:
  		** Dejar en blanco la casilla RULE y click en OK para grabar.
	
	2.  Volver a ejecutar Inicio_Nomcia para probar GRE en ventana de comandos, 
		EJEM: Do Inicio_oniblom 
			  DO form Funfun_selec_ventas	
			  DO Form funalm_transacciones_vta.scx WITH 'S','',gssubalm,[G/R],.t.	 
		 	
ENDTEXT
STRTOFILE(LcLineas,ADDBS(goentorno.Tmppath)+"TODO.TXT") 
MODIFY COMMAND ADDBS(goentorno.Tmppath)+"TODO.TXT"
*******************
FUNCTION ADD_CONFIG
*******************
#DEFINE CRLF 			CHR(13)+CHR(10)
LcFileINI=ADDBS(JUSTPATH(goentorno.tspathadm))+"CONFIG.INI"
*!*	Leer el Archivo .INI
LcStringINI	= UPPER( FILETOSTR(LcFileINI) )
oIniVal=NEWOBJECT("oldinireg","registry.vcx")
LcValue =''
oIniVal.getinientry(@lcvalue,'Ruta Interfaces','Path PLE',LcFileIni) 
IF EMPTY(LcValue)
	LcLineas=""+CRLF
	STRTOFILE(LcLineas,LcFileINI,.T.)
	TEXT TO LcLineas   PRETEXT 7
	[Ruta Interfaces]
	Path PLE =\o-negocios\Interface
	Path SFS =\o-negocios\Interface
	Path OSE GRE  =D:\POS_Efact\POS_Efact\documents\in\guia-remision
	Path OSE FACT =D:\POS_Efact\POS_Efact\documents\in\invoice
	Path OSE CSV  =D:\POS_Efact\POS_Efact\documents\csv
	ENDTEXT

	STRTOFILE(LcLineas,LcFileINI,.T.) 
ENDIF
RELEASE oIniVal