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



