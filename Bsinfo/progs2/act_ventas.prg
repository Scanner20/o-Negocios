PARAMETERS _QueTipo,_QueHacer
LnParam=PARAMETERS()
IF LnParam=1
	_QueHacer = 2
ENDIF
IF LnParam=0
	_QueTipo  = 2
	_QueHacer = 2
ENDIF

&& _Quetipo = 1 ; Desarrollo a produccion
&& _QueTipo = 2 ; Produccion a Desarrollo  

&& _QueHacer = 1 ; Actualiza estructuras
&& _QueHacer = 2 ; Actualiza datos


XnQueTipo = _QueTipo
XnQueHacer = _QueHacer
LcRutaDBCDev='K:\aplvfp\bsinfo\data\'	&& Desarrollo
LcRutaDBCPrd='H:\apl\data\'				&& Producción

USE ADMIN!SISTDBFS ALIAS DBFS ORDER ARCHIVO
SELECT DBFS
SCAN
	XsNomDbcDEV='CIA001'
	XsNomDbcPrd='CIA001'
	DO interface WITH 'CCBRGDOC',LcRutaDBCDEV,LcRutaDBCPrd
ENDSCAN


******************
FUNCTION Interface
******************
PARAMETERS _Tabla,_RutaTabla1,_RutaTabla2
DO CASE 
	CASE	XnQueTipo= 2
		LcTablaDestino	=	_RutaTabla1+XsNomDbcDEV+'!'+_TABLA
		LcTablaOrigen	=	_RutaTabla2+XsNomDbcPRD+'!'+_TABLA
	CASE	XnQueTipo= 1
		LcTablaDestino	=	_RutaTabla2+XsNomDbcPRD+'!'+_TABLA
		LcTablaOrigen	=	_RutaTabla1+XsNomDbcDEV+'!'+_TABLA
ENDCASE 

DO CASE
	CASE	XnQueHacer = 1 
		LcRutina = "ALTER_"+ SUBSTR(LcTablaDestino,AT("!",LcTablaDestino)+1)
	CASE	XnQueHAcer = 2
		LcRutina = "ACT_"+ SUBSTR(LcTablaDestino,AT("!",LcTablaDestino)+1)
ENDCASE 
TsCodDiv1= '01' 

SELECT 0
USE (LcTablaDestino) ALIAS DESTINO EXCLUSIVE 
SELECT 0
USE (LcTablaOrigen)  ALIAS ORIGEN  EXCLUSIVE 

**DO (LcRutina)
DO CASE
	CASE  XnQueHacer = 1
	CASE  XnQueHacer = 2
		SELECT DESTINO
		ZAP
		APPEND FROM (LcTablaOrigen)
	
ENDCASE
*
IF USED('DESTINO')
	USE IN DESTINO
ENDIF
IF USED('ORIGEN')	
	USE IN ORIGEN
ENDIF

RETURN


*********************
FUNCTION ACT_CcbRgdoc
*********************



