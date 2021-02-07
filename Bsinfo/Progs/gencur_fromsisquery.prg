CREATE 
PARAMETERS pNombre_query 
LOCAL LcSqlCmp,LcSqlWhere,LcSqlFrom,LcSql 

IF !USED('QRYS')
	SELECT 0
	use admin!sisquery ALIAS QRYS
ENDIF

LcSqlCmp = 'SELECT '
LcSqlWhere = ''
LcSqlFrom  = 'FROM '
LcSqlGroup = ''
LcSqlOrder = ''
SELECT qrys
SCAN   for Nombre = pNombre_query
	do CASE 
		CASE !EMPTY(Campo)
			LcSqlCmp = LcSqlCmp + TRIM(Entidad)+'.'+TRIM(Campo)+ ','
		CASE !EMPTY(From)
				IF EMPTY(JOIN)
					LcSqlFrom = LcSqlFrom + TRIM(GoEntorno.RemotePathEntidad(from)) + ' ' 
					
		 		ELSE
					LcSqlFrom = LcSqlFrom + TRIM(Join)+' JOIN '+ TRIM(GoEntorno.RemotePathEntidad(from)) + ' ON '+TRIM(CAMPO1)+' = '+TRIM(CAMPO2) 
		 		
		 		ENDIF
		 CASE !EMPTY(Order)
		 		IF EMPTY(LcSqlOrder)
			 		LcSqlOrder = ' Order By ' + TRIM(order)		
			 	ELSE
			 		LcSqlOrder = LcSqlOrder + TRIM(order) + ' '		
			 	ENDIF
		endcase
ENDSCAN
LcSqlCmp=TRIM(LcSqlCmp)
IF RIGHT(TRIM(LcSqlCmp),1)=','
	LcSqlCmp = LEFT(lcSqlCmp,LEN(LCSqlCmp)-1)+' '
ENDIF

LcSql = LcSqlCmp + LcSqlFrom + LcSqlWhere + LcSqlGroup + LcSqlOrder

RETURN  LcSql
