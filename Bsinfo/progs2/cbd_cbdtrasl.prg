*!*	Para traslado del Almacen a la contabilidad Fondo Fijo *!*
#INCLUDE CONST.H
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')

*!* Ejecutamos Formulario para abrir archivos de Traslado *!*
DO FORM cbd_cbdtrasl

**********************
PROCEDURE x_Genera_ast
**********************