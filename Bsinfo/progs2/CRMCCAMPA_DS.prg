**********************
FUNCTION Public_VarMen
**********************
***  Declaramos variables de memoria publicas   20/06/2014 02:55 AM  ***

Public m.ID
Public m.PROGRAMA
Public m.NOMBRE
Public m.PERIODO
Public m.FECHA_INI
Public m.FECHA_FIN
Public m.META
Public m.MONEDA
Public m.PRECIO
Public m.ACTIVO
*********************
FUNCTION Carga_VarMen
*********************
***  Variables de Memoria 20/06/2014 02:55 AM  ***

m.ID                    =  CCAMP1.ID
m.PROGRAMA              =  CCAMP1.PROGRAMA
m.NOMBRE                =  CCAMP1.NOMBRE
m.PERIODO               =  CCAMP1.PERIODO
m.FECHA_INI             =  CCAMP1.FECHA_INI
m.FECHA_FIN             =  CCAMP1.FECHA_FIN
m.META                  =  CCAMP1.META
m.MONEDA                =  CCAMP1.MONEDA
m.PRECIO                =  CCAMP1.PRECIO
m.ACTIVO		=	CCAMP1.ACTIVO
*********************
FUNCTION Release_VarMem
*********************
***  Variables de Memoria 20/06/2014 02:55 AM  ***

RELEASE m.ID
RELEASE m.PROGRAMA
RELEASE m.NOMBRE
RELEASE m.PERIODO
RELEASE m.FECHA_INI
RELEASE m.FECHA_FIN
RELEASE m.META
RELEASE m.MONEDA
RELEASE m.PRECIO
RELEASE m.ACTIVO
***************************
FUNCTION Sql_VarMem_Upd_Tabla
***************************
***  Generamos Sql Update en base a campos en variables de memoria 20/06/2014 02:55 AM  ***

UPDATE CRMCCAMPA SET ;
PROGRAMA = m.PROGRAMA, ; 
NOMBRE = m.NOMBRE, ; 
PERIODO = m.PERIODO, ; 
FECHA_INI = m.FECHA_INI, ; 
FECHA_FIN = m.FECHA_FIN, ; 
META = m.META, ; 
MONEDA = m.MONEDA , ; 
PRECIO = m.PRECIO   , ; 
ACTIVO = m.ACTIVO   ; 
 WHERE  ID = m.ID 
*** Fin :  Sql_VarMem_Upd_Tabla ***
***************************
FUNCTION Sql_VarMem_Upd_Alias
***************************
***  Generamos Sql Update en base a campos en variables de memoria 20/06/2014 02:55 AM  ***

UPDATE CAMP SET ;
PROGRAMA = m.PROGRAMA, ; 
NOMBRE = m.NOMBRE, ; 
PERIODO = m.PERIODO, ; 
FECHA_INI = m.FECHA_INI, ; 
FECHA_FIN = m.FECHA_FIN, ; 
META = m.META, ; 
MONEDA = m.MONEDA, ; 
PRECIO = m.PRECIO   , ; 
ACTIVO = m.ACTIVO   ; 
 WHERE  ID = m.ID 
*** Fin :  Sql_VarMem_Upd_Alias ***
