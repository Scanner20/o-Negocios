**********************
FUNCTION Public_VarMen
**********************
***  Declaramos variables de memoria publicas   31/01/2014 02:01 PM  ***

Public m.FCHREG
Public m.SERV_PROG
Public m.CAMPANA
Public m.NOMAUX
Public m.DNI
Public m.TELEFONOS
Public m.EMAIL1
Public m.EMAIL2
Public m.DIRECCION
Public m.EMPRESA
Public m.RUC_EMPR
Public m.RUBRO_EMPR
Public m.CARGO
Public m.NOTAS
Public m.CONTACTO
Public m.NOMBRE
Public m.MATERNO
Public m.PATERNO
Public m.TIPO_ARCH
Public m.RUTA_FICHA
Public m.IMPBRT
Public m.IMPIGV
Public m.IMPTOT
Public m.CUOTAS
Public m.ID
*********************
FUNCTION Carga_VarMen
*********************
***  Variables de Memoria 31/01/2014 02:01 PM  ***

m.FCHREG                =  CPROS1.FCHREG
m.SERV_PROG             =  CPROS1.SERV_PROG
m.CAMPANA               =  CPROS1.CAMPANA
m.NOMAUX                =  CPROS1.NOMAUX
m.DNI                   =  CPROS1.DNI
m.TELEFONOS             =  CPROS1.TELEFONOS
m.EMAIL1                =  CPROS1.EMAIL1
m.EMAIL2                =  CPROS1.EMAIL2
m.DIRECCION             =  CPROS1.DIRECCION
m.EMPRESA               =  CPROS1.EMPRESA
m.RUC_EMPR              =  CPROS1.RUC_EMPR
m.RUBRO_EMPR            =  CPROS1.RUBRO_EMPR
m.CARGO                 =  CPROS1.CARGO
m.NOTAS                 =  CPROS1.NOTAS
m.CONTACTO              =  CPROS1.CONTACTO
m.NOMBRE                =  CPROS1.NOMBRE
m.MATERNO               =  CPROS1.MATERNO
m.PATERNO               =  CPROS1.PATERNO
m.TIPO_ARCH             =  CPROS1.TIPO_ARCH
m.RUTA_FICHA            =  CPROS1.RUTA_FICHA
m.IMPBRT                =  CPROS1.IMPBRT
m.IMPIGV                =  CPROS1.IMPIGV
m.IMPTOT                =  CPROS1.IMPTOT
m.CUOTAS                =  CPROS1.CUOTAS
m.ID                    =  CPROS1.ID
*********************
FUNCTION Release_VarMem
*********************
***  Variables de Memoria 31/01/2014 02:01 PM  ***

RELEASE m.FCHREG
RELEASE m.SERV_PROG
RELEASE m.CAMPANA
RELEASE m.NOMAUX
RELEASE m.DNI
RELEASE m.TELEFONOS
RELEASE m.EMAIL1
RELEASE m.EMAIL2
RELEASE m.DIRECCION
RELEASE m.EMPRESA
RELEASE m.RUC_EMPR
RELEASE m.RUBRO_EMPR
RELEASE m.CARGO
RELEASE m.NOTAS
RELEASE m.CONTACTO
RELEASE m.NOMBRE
RELEASE m.MATERNO
RELEASE m.PATERNO
RELEASE m.TIPO_ARCH
RELEASE m.RUTA_FICHA
RELEASE m.IMPBRT
RELEASE m.IMPIGV
RELEASE m.IMPTOT
RELEASE m.CUOTAS
RELEASE m.ID
***************************
FUNCTION Sql_VarMem_Upd_Tabla
***************************
***  Generamos Sql Update en base a campos en variables de memoria 31/01/2014 02:01 PM  ***

UPDATE CRMCPROSPE SET ;
FCHREG = m.FCHREG, ; 
SERV_PROG = m.SERV_PROG, ; 
CAMPANA = m.CAMPANA, ; 
NOMAUX = m.NOMAUX, ; 
DNI = m.DNI, ; 
TELEFONOS = m.TELEFONOS, ; 
EMAIL1 = m.EMAIL1, ; 
EMAIL2 = m.EMAIL2, ; 
DIRECCION = m.DIRECCION, ; 
EMPRESA = m.EMPRESA, ; 
RUC_EMPR = m.RUC_EMPR, ; 
RUBRO_EMPR = m.RUBRO_EMPR, ; 
CARGO = m.CARGO, ; 
NOTAS = m.NOTAS, ; 
CONTACTO = m.CONTACTO, ; 
NOMBRE = m.NOMBRE, ; 
MATERNO = m.MATERNO, ; 
PATERNO = m.PATERNO, ; 
TIPO_ARCH = m.TIPO_ARCH, ; 
RUTA_FICHA = m.RUTA_FICHA, ; 
IMPBRT = m.IMPBRT, ; 
IMPIGV = m.IMPIGV, ; 
IMPTOT = m.IMPTOT, ; 
CUOTAS = m.CUOTAS ; 
 WHERE  ID = m.ID  
*** Fin :  Sql_VarMem_Upd_Tabla ***
***************************
FUNCTION Sql_VarMem_Upd_Alias
***************************
***  Generamos Sql Update en base a campos en variables de memoria 31/01/2014 02:01 PM  ***

UPDATE CPROS SET ;
FCHREG = m.FCHREG, ; 
SERV_PROG = m.SERV_PROG, ; 
CAMPANA = m.CAMPANA, ; 
NOMAUX = m.NOMAUX, ; 
DNI = m.DNI, ; 
TELEFONOS = m.TELEFONOS, ; 
EMAIL1 = m.EMAIL1, ; 
EMAIL2 = m.EMAIL2, ; 
DIRECCION = m.DIRECCION, ; 
EMPRESA = m.EMPRESA, ; 
RUC_EMPR = m.RUC_EMPR, ; 
RUBRO_EMPR = m.RUBRO_EMPR, ; 
CARGO = m.CARGO, ; 
NOTAS = m.NOTAS, ; 
CONTACTO = m.CONTACTO, ; 
NOMBRE = m.NOMBRE, ; 
MATERNO = m.MATERNO, ; 
PATERNO = m.PATERNO, ; 
TIPO_ARCH = m.TIPO_ARCH, ; 
RUTA_FICHA = m.RUTA_FICHA, ; 
IMPBRT = m.IMPBRT, ; 
IMPIGV = m.IMPIGV, ; 
IMPTOT = m.IMPTOT, ; 
CUOTAS = m.CUOTAS ; 
 WHERE  ID = m.ID  
*** Fin :  Sql_VarMem_Upd_Alias ***
