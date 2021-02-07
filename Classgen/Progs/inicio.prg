*!*	Poner aqui el directorio en el que esta el TDV.INI
*!*	SET DEFA TO H:\TDV\Comercial\ProgramacionGGonzales\Programacion
*SET DEFA TO \\H:\TDV\InterfasesIng&Costos\ProgramacionOscarG\Programacion

*!*	Activar los Paths para sus formularios personales.... (xUsuario)

*!*	SET PATH TO H:\TDV\Logistica\Programacionccarrera\Programacion\Formularios , ; 
*!*				H:\TDV\Logistica\Programacionccarrera\Programacion\Programas , ;
*!*				H:\TDV\Logistica\Programacionccarrera\Programacion\Reportes , ;
*!*				H:\TDV\Comercial\ProgramacionGGonzales\Programacion\Reportes , ;
*!*				H:\TDV\Logistica\Programacionccarrera\Programacion\Menus , ;
*!*				H:\TDV\Logistica\Programacion01\Programacion\Clases ,  ;
*!*				H:\tdv\ClasesGenerales\Programacion01\Programacion\Clases , ;
*!*				H:\tdv\ClasesGenerales\Programacion01\Programacion\Formularios , ;
*!*				H:\TDV\DesarrolloDeProducto\Programacion01\Programacion\Formularios, ;
*!*				H:\TDV\AdministracionDBA\Programacion01\Programacion\Formularios, ;
*!*				h:\aplicativos\tdv

	SET PATH TO H:\tdv\ClasesGenerales\Programacion01\Programacion\Clases , ;
				H:\tdv\ClasesGenerales\Programacion01\Programacion\Formularios , ;
				H:\TDV\DesarrolloDeProducto\Programacion01\Programacion\Formularios, ;
				H:\TDV\AdministracionDBA\Programacion01\Programacion\Formularios, ;
				h:\aplicativos\tdv



*!*	Las 2 lineas anteriores, apuntan hacia las clases generales

*!*	Activar las Librerias de clases generales
SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL

CLOSE DATABASES ALL


PUBLIC goEntorno , goConexion
goConexion	= CREATEOBJECT('cnxgen_ODBC')

IF !goConexion.Conectar()
	=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
	RELEASE goConexion , goEntorno
	RETURN
ENDIF

goEntorno	= CREATEOBJECT("Entorno")

*!*	Colocar aqui el Sistema y Módulo que trabajarán
*!*	goEntorno.Sistema = "COM"
*!*	goEntorno.Modulo  = "PR1"

goEntorno.Sistema = "LOG"
goEntorno.Modulo  = "DES"

goEntorno.GenerarPerfilUsuario()
goEntorno.GenerarTablasLocales()