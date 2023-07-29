#INCLUDE "H:\TDV\ClasesGenerales\Programacion01\Programacion\Textos\TDV_RUTAS.H"
#INCLUDE "H:\TDV\ClasesGenerales\Programacion01\Programacion\Textos\REGISTRY.H"

*!*	Mensajes del Sistema
#DEFINE	_MSG_ARCHIVO			"Ingrese Nombre de Archivo"
#DEFINE	_MSG_TIPODEDATO			"Tipo de Dato incorrecto"
#DEFINE	_MSG_ERROR_PARAMS		"El número de parámetros no son los correctos o los tipos no coinciden"
#DEFINE	_MSG_FILE_NOT_FOUND		"¡¡¡ El Archivo especificado no existe !!!"
#DEFINE	_MSG_INTERVALO			"Intervalo Inicial Debe ser menor o igual"
#DEFINE	_MSG_NO_REG_FORMAT		"¡¡¡ Error de registro de Aplicación !!!"
#DEFINE	_MSG_TABLACURSOR		"Tabla o Cursor no existe"
#DEFINE	_MSG_ERROR_CONEXION		"No se pudo establecer la conexión con el Servidor"
#DEFINE	_MSG_ERROR_CODDISTRIB	"No existe Código de Distribución"
#DEFINE _MSG_ERROR_DESCRIPCION	"No Existe Descripción o Detalle"
#DEFINE	_MSG_ERROR_DIRECTORIO	"El directorio especificado no existe"
#DEFINE	_MSG_ERROR_LOGIN		"El usuario especificado no se encontró en el registro del sistema"
#DEFINE	_MSG_ERROR_CLAVE		"La clave no corresponde"
#DEFINE _MSG_DATOS_VACIOS		"Existen Datos Relevantes VACIOS"
#DEFINE _MSG_DATOS_NOEXISTE		"No Existe Código o Número Ingresado"
#DEFINE _MSG_ELIMINAR_REGISTRO	"¿ Esta seguró de eliminar el registro ?"
#DEFINE	_MSG_DATOS_EXISTE		"Los datos suministrados ya existen, no se pueden sobreescribir"
#DEFINE _MSG_DATOS_CANCELA		"¿ Seguro de Cancelar Proceso de Edición ?"
#DEFINE _MSG_ERROR_NOOPERA		" Tipo de Operacion no Definido"


#DEFINE	_MSG_INPUT_NOTFOUND		"El dato suministrado no se pudo encontrar"
#DEFINE	_MSG_USER_RIGHT			"No tiene derechos suficientes para esta opción"

#DEFINE _MSG_ERROR_SERVIDOR		"Seleccione Servidor"
#DEFINE _MSG_ERROR_BASEDATOS	"Seleccione Base de Datos"
#DEFINE _MSG_ERROR_OBJETO		"Seleccione Tipo de Objeto"
#DEFINE _MSG_PROC_DATOS			"¡ No se puede alterar datos ya procesados !"

#DEFINE _MSG_ERROR_SISTEMA		"Seleccione Sistema"
#DEFINE _MSG_ERROR_MODULO		"Seleccione Módulo"

#DEFINE _MSG_ERROR_SINDATOS		"No Existen Datos para procesar"

*!*	TÝtulos de Cuadros de Dialogo
#DEFINE _TIT_ELIMINAR_REGISTRO	"Eliminar"
#DEFINE	_TIT_ERR_INTERVALO		"Error en Intervalo"
#DEFINE	_TIT_ERROR_ARCHIVO		"Error en Archivo"
#DEFINE	_TIT_ERROR_ODBC			"Error ODBC"
#DEFINE	_TIT_ERROR_PARAMS		"Error en parámetros"
#DEFINE	_TIT_FILE_NOT_FOUND		"Archivo no encontrado"
#DEFINE	_TIT_NO_REG_FORMAT		"Error en registro"
#DEFINE	_TIT_ERROR_CONEXION		"Error de Conexión"
#DEFINE _TIT_ERROR_EDICION		"Error en Edición"
#DEFINE _TIT_CUIDADO			"Cuidado con Operación"
#DEFINE	_TIT_ERROR_DIRECTORIO	"Error en directorio"
#DEFINE	_TIT_ERROR_LOGIN		"Error de Login"
#DEFINE	_TIT_ERROR_CLAVE		"Error de clave"
#DEFINE	_TIT_SISTEMA_ADM		"Sistema de Administración TDV"
#DEFINE	_TIT_INPUT_NOTFOUND		"Error en ingreso de datos"
#DEFINE	_TIT_USER_RIGHT			"Error de derechos"
#DEFINE _TIT_PROC_DATOS			"Datos procesados"
#DEFINE	_TIT_INPUT_TFOUND		"Datos ya existen"


*!*	Tipos de datos de VFP
#DEFINE	_TYPE_CHAR				"C"
#DEFINE	_TYPE_NULL				"U"
#DEFINE	_TYPE_OBJECT			"O"

*!* Codigos de acceso en Tabla de Tablas :
#DEFINE	_CODIGO_TEMPORADA			"03000"
#DEFINE	_CODIGO_MONEDA				"04000"
#DEFINE	_CODIGO_MERCADO				"05000"
#DEFINE	_CODIGO_CLASEEDAD			"06000"
#DEFINE	_CODIGO_GENERO				"07000"
#DEFINE	_CODIGO_FINALIDADMUESTRA	"00016"
#DEFINE	_CODIGO_TIPOCONTRAMUESTRA	"00017"
#DEFINE	_CODIGO_CALIFICACION    	"00023"
#DEFINE _OPERACION_CALIFICACION 	"00023"

*!* Estados de Tablas de SPYM :
#DEFINE _ESTADOXAPROBAR_SPYM   "014" 
#DEFINE _ESTADOAPROBADO_SPYM   "015"
#DEFINE _ESTADORECHAZADO_SPYM  "016"

*-- Toolbar names
#DEFINE TB_FORMDESIGNER_LOC  "Diseñador de formularios"
#DEFINE TB_STANDARD_LOC      "Estándar"
#DEFINE TB_LAYOUT_LOC        "Diseño"
#DEFINE TB_QUERY_LOC		 "Diseñador de consultas"
#DEFINE TB_VIEWDESIGNER_LOC  "Diseñador de vistas"
#DEFINE TB_COLORPALETTE_LOC  "Paleta de colores"
#DEFINE TB_FORMCONTROLS_LOC  "Controles de formularios"
#DEFINE TB_DATADESIGNER_LOC  "Diseñador de bases de datos"
#DEFINE TB_REPODESIGNER_LOC  "Diseñador de informes"
#DEFINE TB_REPOCONTROLS_LOC  "Controles de informes"
#DEFINE TB_PRINTPREVIEW_LOC  "Vista preliminar"
#DEFINE WIN_COMMAND_LOC		 "Comandos"			&& Ventana Comandos