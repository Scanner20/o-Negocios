** VETT  29/03/12 06:17 AM :  
** Creamos un temporal con la estructura de la tabla RMOV en un cursor C_RMOV
** La tabla RMOV debe estar previamente abierta.
lreturnok=open_dbf1('TEMP_STR','RMOV','C_RMOV','','')
** Le agregamos otros campos al cursor C_RMOV que no vienen en la estructura inicial
=modificatabla('C_RMOV','Agregar','NroReg','N',10,0)
=modificatabla('C_RMOV','Agregar','NomAux','C',30,0)
=modificatabla('C_RMOV','Agregar','NomCta','C',30,0)
=modificatabla('C_RMOV','Agregar','Desdoc','C',20,0)

NomArch="c:\temp\"+SYS(3)
CREATE TABLE &NomArch FREE  ( campo1 c(1),campo2 n(2,1), Flag L , campo3 c(10)  )
USE (NomArch) && Use &NomArch



****************
FUNCTION open_Dbf1
****************
PARAMETER cAccion,cArchivo,cAlias,cTag,cExclu
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
******************
FUNCTION modificatabla
******************
PARAMETERS _cAliasNombre,_cAccion,_cCampo,_cTipo,_nLongitud,_nPrecision

** Por mejorar para todos los casos de modificacion de estrucuturas de tablas por ahora solo Agrega campos
** Tipo C,N ,L,D,T


IF PCOUNT()<4
	RETURN -1
ENDIF
IF EMPTY(_cAliasNombre) OR ISNULL(_cAliasNombre)
	IF !EMPTY(ALIAS())
		_CAliasNombre = ALIAS()
	ELSE
		_CAliasNombre = ''	
	ENDIF
ENDIF

IF EMPTY(_cAliasNombre)
	RETURN -1
ENDIF
_cAccion = UPPER(_cAccion)
LOCAL LsTipoLonPrec
DO CASE
	CASE _cTipo='C'
		LsTipoLonPrec=' C('+TRANSFORM(_nLongitud,"@L 99")+')'
	CASE INLIST(_cTipo,'N','F')
		IF _nPrecision<=0
			LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+')'
		ELSE
			LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+','+TRANSFORM(_nPrecision,"@L 99")+')'		
		ENDIF	
	CASE _cTipo='L'
		LsTipoLonPrec=' L '
	CASE INLIST(_cTipo,'D','T')
		LsTipoLonPrec=' '+_cTipo+' '
	OTHERWISE
	
ENDCASE

DO CASE
	CASE	_cAccion = 'AGREGAR' 
		ALTER TABLE (_cAliasNombre) ADD COLUMN &_cCampo &LsTipoLonPrec
	CASE	_cAccion = 'BORRAR'
	
	CASE	_cAccion = 'MODIFICA'
ENDCASE

RETURN 1