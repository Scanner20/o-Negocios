*********************
FUNCTION Cp_Entidades
*********************
PARAMETERS cNombreEntidad,cCodEntOrigen,cCodEntDestino,cPathOrigen,cPathDestino
cPathOrigen_Detalle = cPathOrigen+'_Detalle'
cPathDestino_Detalle = cPathDestino+'_Detalle'
SELECT 0
USE (cPathOrigen) ALIAS GORI ORDER ENTIDAD  AGAIN 
IF !EMPTY(cNombreEntidad) AND VARTYPE(cNombreEntidad)='C'
	SET ORDER TO NOMBRE
	SEEK UPPER(cNombreEntidad)
	IF FOUND()
		cCodEntOrigen = CodigoEntidad
		cCodEntDestino = CodigoEntidad
	ENDIF 	
	SET ORDER TO ENTIDAD
ENDIF
IF EMPTY(cCodEntOrigen) AND EMPTY(cCodEntDestino)
	
ELSE
	SELECT 0
	USE (cPathDestino) ALIAS GDES ORDER ENTIDAD AGAIN  

	SELECT 0
	USE (cPathOrigen_Detalle) ALIAS GORI_D ORDER ENTATRY  AGAIN 

	SELECT 0
	USE (cPathDestino_Detalle) ALIAS GDES_D ORDER ENTATRY AGAIN  

	LsCodEntNew = ''
	SELECT GORI
	SEEK cCodEntOrigen
	IF !FOUND()
		RETURN 
	ENDIF
	SCATTER MEMVAR MEMO 
	SELECT GDES
	SEEK cCodEntDestino
	IF !FOUND()
		APPEND BLANK
	ELSE
		IF TRIM(UPPER(GORI.NombreEntidad))==TRIM(UPPER(GDES.NombreEntidad))
		ELSE
			GO bott
			LsCodEntNew=tran(VAL(codigoentidad)+1,'@L 9999')
			m.CodigoEntidad = lsCodEntNew
			APPEND BLANK
		ENDIF
	ENDIF	
	GATHER MEMVAR MEMO
	** Detalle
	SELECT GORI_D
	SEEK cCodEntOrigen
	IF !FOUND()
		RETURN
	ENDIF
	SCAN WHILE CodigoEntidad=cCodEntOrigen
		SCATTER MEMVAR memo
		SELECT GDES_D
		IF !EMPTY(LsCodEntNew)
			m.CodigoEntidad = LsCodEntNew 	
		ENDIF
		SEEK m.CodigoEntidad+m.CodigoAtributo
		IF !FOUND()
			APPEND BLANK
		ENDIF
		GATHER MEMVAR MEMO
		SELECT GORI_D
	ENDSCAN
ENDIF
=Close_Tables_1()
cPathOrigen=ADDBS(JUSTPATH(STRTRAN(cpathorigen,"local","data",1,1,1)))
cPathDestino=ADDBS(JUSTPATH(STRTRAN(cpathDestino,"local","data",1,1,1)))
=cp_SistDBFS(cNombreEntidad,cNombreEntidad,cPathOrigen+'SISTDBFS',cPathDestino+'SISTDBFS')
=Close_Tables_1()
********************
FUNCTION Cp_SISTDBFS
********************
PARAMETERS cCodEntOrigen,cCodEntDestino,cPathOrigen,cPathDestino
cPathOrigen_Detalle = ADDBS(JUSTPATH(cPathOrigen))+'SISTCDXS'
cPathDestino_Detalle = ADDBS(JUSTPATH(cPathDestino))+'SISTCDXS'

SELECT 0
USE (cPathOrigen) ALIAS GORI ORDER ARCHIVO  AGAIN 

SELECT 0
USE (cPathDestino) ALIAS GDES ORDER ARCHIVO AGAIN  

SELECT 0
USE (cPathOrigen_Detalle) ALIAS GORI_D ORDER SISTEMA  AGAIN 

SELECT 0
USE (cPathDestino_Detalle) ALIAS GDES_D ORDER SISTEMA AGAIN  


SELECT GORI
SEEK cCodEntOrigen
IF !FOUND()
	RETURN 
ENDIF
SCATTER MEMVAR memo 
LsSistema=m.Sistema
LsArchivo=m.Archivo

SELECT GDES
SEEK cCodEntDestino
IF !FOUND()
	APPEND BLANK
ENDIF
GATHER MEMVAR MEMO

** Detalle
SELECT GORI_D
SEEK LsSistema+LsArchivo
IF !FOUND()
	RETURN
ENDIF
SCAN WHILE Sistema+Archivo=LsSistema+LsArchivo
	SCATTER MEMVAR memo
	SELECT GDES_D
	SEEK m.Sistema+m.Archivo+m.Indice
	IF !FOUND()
		APPEND BLANK
	ENDIF
	GATHER MEMVAR MEMO
	SELECT GORI_D
ENDSCAN
=Close_Tables_1()
**********************
FUNCTION Close_Tables_1
**********************
IF USED('GORI_D')
	USE IN GORI_D
ENDIF
IF USED('GDES_D')
	USE IN GDES_D
ENDIF
IF USED('GORI')
	USE IN GORI
ENDIF
IF USED('GDES')
	USE IN GDES
ENDIF