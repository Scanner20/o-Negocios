PARAMETERS _CodCia
PUBLIC GsCodCia
GsCodCia = _CodCia
PathDef = SYS(5)+SYS(2003)

LsRutaUpdate = PathDef +'\UPDATE\'
LsRutaUpdStr = PathDef +'\UPDATE\STRUC\'
LsRutaTabla  = PATHDEF+'\DATA\'

y=ADIR(aProced,LsRutaUpdate+'*.PRO')
x=ADIR(aTablas,LsRutaUpdate+'*.TAB')
IF X>0 OR Y>0
	IF MESSAGEBOX('Existen actualización pendiente del sistema, es necesario que nadie mas este usando el sistema. Desea Continuar',1+32,'ACTUALIZACION DE SISTEMA') = 2
		RETURN
	ENDIF
ELSE
	RETURN
ENDIF


LcPath_Ini = SET('PATH')
LcPath_NEW = LsRutaTabla+';'+LsRutaUpdStr+';'+LsRutaUpdate

SET PATH TO  (LcPath_INI) + ';' + (LcPath_NEW)



SET CLASSLIB TO fpdosvr IN mtto.exe
PUBLIC LoDax as dataadmin OF fpDosvr
LoDax = CREATEOBJECT('FpDosvr.DataAdmin')

LsRutaLocal  = LoDax.oEntorno.Locpath
LsRutaTemp   = LoDax.oEntorno.Tmppath



*y=ADIR(aProced,LsRutaUpdate+'*.PRO')

IF y>0
	FOR K = 1 TO ALEN(aProced,1)
		LnResult=act_proced(LsRutaLocal,JUSTSTEM(aProced(K,1)),PATHDEF+'\DATA\',SUBSTR(JUSTSTEM(aProced(K,1)),4) )
		IF LnResult=1
			DELETE FILE (LsRutaUpdate+aProced(K,1))
		ENDIF
	ENDFOR
ENDIF
*x=ADIR(aTablas,LsRutaUpdate+'*.TAB')
IF x>0
	FOR J = 1 TO ALEN(aTablas,1)
		LnResult=Act_Tabla(JUSTSTEM(aTablas(J,1)),'CIA'+LoDax.Oentorno.Gscodcia,LsRutaTabla )
		IF LnResult=1
			DELETE FILE (LsRutaUpdate+aTablas(J,1))
		ENDIF
	ENDFOR
ENDIF
RELEASE LoDax
*!*	LsRutaUpdate = SYS(5)+SYS(2003)+'\UPDATE\'
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'SP_CIA001'+'.PRO' )
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'MTOTARRE'+'.TAB' )
*!*	=STRTOFILE('Actualizacion:'+dtoc(DATE()),LsRutaUpdate+'SP_P0012004'+'.PRO' )
*******************
FUNCTION act_proced
*******************
PARAMETERS _ruta_Arc,_archivo,_Ruta_BD,_BaseDatos
LOCAL LnReturn AS Integer 
LnReturn = -1
IF FILE(_ruta_Arc+_archivo+'.PRG') AND FILE(_Ruta_BD+_BaseDatos+'.DBC')
	OPEN DATABASE (_Ruta_BD+_BaseDatos) EXCLUSIVE
	APPEND PROCEDURES FROM (_ruta_Arc+_archivo+'.PRG') OVERWRITE 
	CLOSE DATABASES
	LnReturn = 1
ENDIF
RETURN LnReturn
******************
FUNCTION Act_Tabla
******************
PARAMETERS _Tabla,_BD,_Ruta
LOCAL LnReturn AS Integer 
LnReturn = -1

IF !FILE(LsRutaUpdStr+_Tabla+'.STR')
	RETURN LnReturn
ENDIF
OPEN DATABASE (_Ruta+_BD) EXCLUSIVE 
LsArc_Str = LsRutaUpdStr+_Tabla+'.STR'
SELECT 0
USE LsRutaLocal+'Gentidades' ALIAS entidad
SET FILTER TO TRIM(UPPER(NombreEntidad)) == TRIM(upper(_Tabla))
LOCATE
IF !EOF()
	SELECT 0
	USE LsRutaLocal+'gentidades_detalle' ALIAS detalle
	SET FILTER TO CodigoEntidad == Entidad.CodigoEntidad AND !FlagotraTabla
	LOCATE
	IF !EOF()
		LsTabla=_BD+"!"+_Tabla
		=MESSAGEBOX(SET("Path" ))
		SELECT 0
		USE (LsTabla) EXCLUSIVE ALIAS TABLA
		LsNomArc = SYS(2023)+'\'+SYS(3) 
		COPY STRUCTURE extended TO (LsNomArc)
		SELECT 0
		USE (LsNomArc) ALIAS str_arc EXCLU
		SELECT str_arc
		INDEX ON UPPER(field_Name) TAG pk1
		LsCadenaUpd=''
		LlUpdate = .f.	
		LlInsert = .f.	
		SELECT Detalle
		IF VARTYPE(Decimales)<>'N'
			=STRTOFILE('No tiene la version correcta de Gentidades_Detalle',LsRutaLocal+'errUpd.txt',1)
			RETURN -1
		ENDIF
		SCAN 
			LlUpdate = .f.	
			LlInsert = .f.	

			IF SEEK(TRIM(UPPER(nombrecampo)),'str_arc','PK1')
				IF LongitudDato<>str_arc.Field_len				
					LlUpdate = .t.	
				ENDIF
				IF TipoDatoCampo<>str_arc.Field_Type		
					LlUpdate = .t.	
				ENDIF
				IF Decimales<>str_arc.Field_Dec
					LlUpdate = .t.	
				ENDIF
			ELSE
				LlInsert = .T.	
				LoDax.mod_str_tabla(LsTabla,'AGREGAR',TRIM(UPPER(nombrecampo)),TipoDatoCampo,LongitudDato,Decimales) 									
			ENDIF
			IF LlUpdate
				LoDax.mod_str_tabla(LsTabla,'MODIFICA',TRIM(UPPER(nombrecampo)),TipoDatoCampo,LongitudDato,Decimales) 									
			ENDIF
			SELECT detalle
		ENDSCAN 
	ENDIF
ENDIF
USE IN Tabla
USE IN STR_ARC
USE IN Detalle
USE IN Entidad

CLOSE DATABASES 
LnReturn = 1
RETURN LnReturn


*********************
FUNCTION UPDATE_INDEX
*********************
SELECT 0
USE CIA001!MTOMPERS


