**********************
FUNCTION Public_VarMen
**********************
***  Declaramos variables de memoria publicas   22/12/2015 09:12 PM  ***

Public m.ID
Public m.CODLOC
Public m.ZONA
Public m.LOCALIDAD
Public m.CLIENTE
Public m.LOC
Public m.PASAJE
Public m.CARGO
Public m.CTACAJA
Public m.CAJA
Public m.CAJA_ALT
Public m.N_PASCRECT
Public m.N_PASCONCT
Public m.N_EXCCRECT
Public m.N_EXCCONCT
Public m.N_OTRCRECT
Public m.N_OTRCONCT
Public m.N_CARCRECT
Public m.N_CARCONCT
Public m.UNEGOCIO1
Public m.UNEGOCIO2
Public m.UNEGOCIO3
Public m.UNEGOCIO4
*********************
FUNCTION Carga_VarMen
*********************
***  Variables de Memoria 22/12/2015 09:12 PM  ***
m.ID                    =  C_CCOCT.ID
m.CODLOC                =  C_CCOCT.CODLOC
m.ZONA                  =  C_CCOCT.ZONA
m.LOCALIDAD             =  C_CCOCT.LOCALIDAD
m.CLIENTE               =  C_CCOCT.CLIENTE
m.LOC                   =  C_CCOCT.LOC
m.PASAJE                =  C_CCOCT.PASAJE
m.CARGO                 =  C_CCOCT.CARGO
m.CTACAJA               =  C_CCOCT.CTACAJA
m.CAJA                  =  C_CCOCT.CAJA
m.CAJA_ALT              =  C_CCOCT.CAJA_ALT
m.N_PASCRECT            =  C_CCOCT.N_PASCRECT
m.N_PASCONCT            =  C_CCOCT.N_PASCONCT
m.N_EXCCRECT            =  C_CCOCT.N_EXCCRECT
m.N_EXCCONCT            =  C_CCOCT.N_EXCCONCT
m.N_OTRCRECT            =  C_CCOCT.N_OTRCRECT
m.N_OTRCONCT            =  C_CCOCT.N_OTRCONCT
m.N_CARCRECT            =  C_CCOCT.N_CARCRECT
m.N_CARCONCT            =  C_CCOCT.N_CARCONCT
m.UNEGOCIO1             =  C_CCOCT.UNEGOCIO1
m.UNEGOCIO2             =  C_CCOCT.UNEGOCIO2
m.UNEGOCIO3             =  C_CCOCT.UNEGOCIO3
m.UNEGOCIO4             =  C_CCOCT.UNEGOCIO4
*********************
FUNCTION Release_VarMem
*********************
***  Variables de Memoria 22/12/2015 09:12 PM  ***

RELEASE m.ID
RELEASE m.CODLOC
RELEASE m.ZONA
RELEASE m.LOCALIDAD
RELEASE m.CLIENTE
RELEASE m.LOC
RELEASE m.PASAJE
RELEASE m.CARGO
RELEASE m.CTACAJA
RELEASE m.CAJA
RELEASE m.CAJA_ALT
RELEASE m.N_PASCRECT
RELEASE m.N_PASCONCT
RELEASE m.N_EXCCRECT
RELEASE m.N_EXCCONCT
RELEASE m.N_OTRCRECT
RELEASE m.N_OTRCONCT
RELEASE m.N_CARCRECT
RELEASE m.N_CARCONCT
RELEASE m.UNEGOCIO1
RELEASE m.UNEGOCIO2
RELEASE m.UNEGOCIO3
RELEASE m.UNEGOCIO4
***************************
FUNCTION Sql_VarMem_Upd_Tabla
***************************
***  Generamos Sql Update en base a campos en variables de memoria 22/12/2015 09:12 PM  ***

UPDATE CFGCCOCTA1 SET ;
CODLOC = m.CODLOC, ; 
ZONA = m.ZONA, ; 
LOCALIDAD = m.LOCALIDAD, ; 
CLIENTE = m.CLIENTE, ; 
LOC = m.LOC, ; 
PASAJE = m.PASAJE, ; 
CARGO = m.CARGO, ; 
CTACAJA = m.CTACAJA, ; 
CAJA = m.CAJA, ; 
CAJA_ALT = m.CAJA_ALT, ; 
N_PASCRECT = m.N_PASCRECT, ; 
N_PASCONCT = m.N_PASCONCT, ; 
N_EXCCRECT = m.N_EXCCRECT, ; 
N_EXCCONCT = m.N_EXCCONCT, ; 
N_OTRCRECT = m.N_OTRCRECT, ; 
N_OTRCONCT = m.N_OTRCONCT, ; 
N_CARCRECT = m.N_CARCRECT, ; 
N_CARCONCT = m.N_CARCONCT, ; 
UNEGOCIO1 = m.UNEGOCIO1, ; 
UNEGOCIO2 = m.UNEGOCIO2, ; 
UNEGOCIO3 = m.UNEGOCIO3, ; 
UNEGOCIO4 = m.UNEGOCIO4 ;
 WHERE    ID = m.ID
*** Fin :  Sql_VarMem_Upd_Tabla ***
***************************
FUNCTION Sql_VarMem_Upd_Alias
***************************
***  Generamos Sql Update en base a campos en variables de memoria 22/12/2015 09:12 PM  ***

UPDATE CCOCT SET ;
CODLOC = m.CODLOC, ; 
ZONA = m.ZONA, ; 
LOCALIDAD = m.LOCALIDAD, ; 
CLIENTE = m.CLIENTE, ; 
LOC = m.LOC, ; 
PASAJE = m.PASAJE, ; 
CARGO = m.CARGO, ; 
CTACAJA = m.CTACAJA, ; 
CAJA = m.CAJA, ; 
CAJA_ALT = m.CAJA_ALT, ; 
N_PASCRECT = m.N_PASCRECT, ; 
N_PASCONCT = m.N_PASCONCT, ; 
N_EXCCRECT = m.N_EXCCRECT, ; 
N_EXCCONCT = m.N_EXCCONCT, ; 
N_OTRCRECT = m.N_OTRCRECT, ; 
N_OTRCONCT = m.N_OTRCONCT, ; 
N_CARCRECT = m.N_CARCRECT, ; 
N_CARCONCT = m.N_CARCONCT, ; 
UNEGOCIO1 = m.UNEGOCIO1, ; 
UNEGOCIO2 = m.UNEGOCIO2, ; 
UNEGOCIO3 = m.UNEGOCIO3, ; 
UNEGOCIO4 = m.UNEGOCIO4 ; 
 WHERE  ID = m.ID
*** Fin :  Sql_VarMem_Upd_Alias ***
***************************
FUNCTION Sql_Query_Alias
***************************
***  Generamos Sql Query en base a campos de la tabla o cursor 22/12/2015 09:12 PM  ***

SELECT  ;
ID, ; 
CODLOC, ; 
ZONA, ; 
LOCALIDAD, ; 
CLIENTE, ; 
LOC, ; 
PASAJE, ; 
CARGO, ; 
CTACAJA, ; 
CAJA, ; 
CAJA_ALT, ; 
N_PASCRECT, ; 
N_PASCONCT, ; 
N_EXCCRECT, ; 
N_EXCCONCT, ; 
N_OTRCRECT, ; 
N_OTRCONCT, ; 
N_CARCRECT, ; 
N_CARCONCT, ; 
UNEGOCIO1, ; 
UNEGOCIO2, ; 
UNEGOCIO3 ; 
UNEGOCIO4 FROM CCOCT  
*** Fin :  Sql_VarMem_Upd_Alias ***
