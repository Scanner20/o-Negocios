**********************
FUNCTION Public_VarMen
**********************
***  Declaramos variables de memoria publicas   08/01/2014 06:18 PM  ***

Public m.FECHA
Public m.ACTIVIDAD
Public m.AREA
Public m.ENTREGABLE
Public m.FECH_PROX
Public m.OBSERVACIO
Public m.STATUS_COM
Public m.STATUS_ACA
Public m.COMENTARIO
Public m.RUTA_ARCH
Public m.TIPDOC
Public m.NRODOC
Public m.ID_ACTIVID
Public m.FCH_REQUER
Public m.FCH_ACUERD
Public m.FCH_ENTREG
Public m.SEMAFORO
Public m.ID_SEGUI
PUBLIC m.DIAS_REAL
Public m.ID
*********************
FUNCTION Carga_VarMen
*********************
***  Variables de Memoria 08/01/2014 06:18 PM  ***

m.FECHA                 =  CDSEG1.FECHA
m.ACTIVIDAD             =  CDSEG1.ACTIVIDAD
m.AREA                  =  CDSEG1.AREA
m.ENTREGABLE            =  CDSEG1.ENTREGABLE
m.FECH_PROX             =  CDSEG1.FECH_PROX
m.OBSERVACIO            =  CDSEG1.OBSERVACIO
m.STATUS_COM            =  CDSEG1.STATUS_COM
m.STATUS_ACA            =  CDSEG1.STATUS_ACA
m.COMENTARIO            =  CDSEG1.COMENTARIO
m.RUTA_ARCH             =  CDSEG1.RUTA_ARCH
m.TIPDOC                =  CDSEG1.TIPDOC
m.NRODOC                =  CDSEG1.NRODOC
m.ID_ACTIVID            =  CDSEG1.ID_ACTIVID
m.FCH_REQUER           =  CDSEG1.FCH_REQUER
m.FCH_ACUERD           =  CDSEG1.FCH_ACUERD
m.FCH_ENTREG            =  CDSEG1.FCH_ENTREG
m.SEMAFORO              =  CDSEG1.SEMAFORO
m.ID_SEGUI              =  CDSEG1.ID_SEGUI
m.DIAS_REAL 		=	CDSEG1.DIAS_REAL
m.ID                    =  CDSEG1.ID
*********************
FUNCTION Release_VarMem
*********************
***  Variables de Memoria 08/01/2014 06:18 PM  ***

RELEASE m.FECHA
RELEASE m.ACTIVIDAD
RELEASE m.AREA
RELEASE m.ENTREGABLE
RELEASE m.FECH_PROX
RELEASE m.OBSERVACIO
RELEASE m.STATUS_COM
RELEASE m.STATUS_ACA
RELEASE m.COMENTARIO
RELEASE m.RUTA_ARCH
RELEASE m.TIPDOC
RELEASE m.NRODOC
RELEASE m.ID_ACTIVID
RELEASE m.FCH_REQUER
RELEASE m.FCH_ACUERD
RELEASE m.FCH_ENTREG
RELEASE m.SEMAFORO
RELEASE m.ID_SEGUI
RELEASE m.DIAS_REAL 	
RELEASE m.ID
***************************
FUNCTION Sql_VarMem_Upd_Tabla
***************************
***  Generamos Sql Update en base a campos en variables de memoria 08/01/2014 06:18 PM  ***

UPDATE CRMDSEGUI SET ;
FECHA = m.FECHA, ; 
ACTIVIDAD = m.ACTIVIDAD, ; 
AREA = m.AREA, ; 
ENTREGABLE = m.ENTREGABLE, ; 
FECH_PROX = m.FECH_PROX, ; 
OBSERVACIO = m.OBSERVACIO, ; 
STATUS_COM = m.STATUS_COM, ; 
STATUS_ACA = m.STATUS_ACA, ; 
COMENTARIO = m.COMENTARIO, ; 
RUTA_ARCH = m.RUTA_ARCH, ; 
TIPDOC = m.TIPDOC, ; 
NRODOC = m.NRODOC, ; 
ID_ACTIVID = m.ID_ACTIVID, ; 
FCH_REQUER = m.FCH_REQUER, ; 
FCH_ACUERD = m.FCH_ACUERD, ; 
FCH_ENTREG = m.FCH_ENTREG, ; 
SEMAFORO = m.SEMAFORO, ; 
DIAS_REAL =	m.DIAS_REAL , ;
ID_SEGUI = m.ID_SEGUI ; 
 WHERE  ID = m.ID  AND ID_SEGUI = m.ID_SEGUI 
*** Fin :  Sql_VarMem_Upd_Tabla ***
***************************
FUNCTION Sql_VarMem_Upd_Alias
***************************
***  Generamos Sql Update en base a campos en variables de memoria 08/01/2014 06:18 PM  ***

UPDATE DSEG SET ;
FECHA = m.FECHA, ; 
ACTIVIDAD = m.ACTIVIDAD, ; 
AREA = m.AREA, ; 
ENTREGABLE = m.ENTREGABLE, ; 
FECH_PROX = m.FECH_PROX, ; 
OBSERVACIO = m.OBSERVACIO, ; 
STATUS_COM = m.STATUS_COM, ; 
STATUS_ACA = m.STATUS_ACA, ; 
COMENTARIO = m.COMENTARIO, ; 
RUTA_ARCH = m.RUTA_ARCH, ; 
TIPDOC = m.TIPDOC, ; 
NRODOC = m.NRODOC, ; 
ID_ACTIVID = m.ID_ACTIVID, ; 
FCH_REQUER = m.FCH_REQUER, ; 
FCH_ACUERD = m.FCH_ACUERD, ; 
FCH_ENTREG = m.FCH_ENTREG, ; 
DIAS_REAL =	m.DIAS_REAL , ;
SEMAFORO = m.SEMAFORO ; 
 WHERE  ID = m.ID  AND ID_SEGUI = m.ID_SEGUI 
 *** Fin :  Sql_VarMem_Upd_Alias ***
