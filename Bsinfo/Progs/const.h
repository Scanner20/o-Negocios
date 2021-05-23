# DEFINE k_home 1
# DEFINE k_end  6
# DEFINE k_pgup 18
# DEFINE k_pgdn  3
# DEFINE k_del  7
# DEFINE k_ins         22
# DEFINE k_f_izq       19
# DEFINE k_f_der       4
# DEFINE k_f_arr       5
# DEFINE k_f_aba       24
# DEFINE k_tab         9
# DEFINE k_backtab     15
# DEFINE k_backspace   127
# DEFINE k_enter       13
# DEFINE k_f1          28
# DEFINE k_f2          -1
# DEFINE k_f3          -2
# DEFINE k_f4          -3
# DEFINE k_f5          -4
# DEFINE k_f6          -5
# DEFINE k_f7          -6
# DEFINE k_f8          -7
# DEFINE k_f9          -8
# DEFINE k_f10         -9
# DEFINE k_sf1         84
# DEFINE k_sf2         85
# DEFINE k_sf3         86
# DEFINE k_sf4         87
# DEFINE k_sf5         88
# DEFINE k_sf6         89
# DEFINE k_sf7         90
# DEFINE k_sf8         91
# DEFINE k_sf9         92
# DEFINE k_ctrlw       23
# DEFINE k_lookup      -7
# DEFINE k_borrar      -8
# DEFINE k_esc         27

# DEFINE home        1
# DEFINE end_         6
# DEFINE end         6
# DEFINE pgup        18
# DEFINE pgdn        3
# DEFINE del         7
# DEFINE ins         22
# DEFINE f_izq       19
# DEFINE Izquierda   19
# DEFINE f_der       4
# DEFINE Derecha     4
# DEFINE Arriba      5
# DEFINE f_arr       5
# DEFINE f_aba       24
# DEFINE Abajo       24
# DEFINE tab         9
# DEFINE backtab     15
# DEFINE backspace   127
# DEFINE enter       13
# DEFINE f1          28
# DEFINE f2          -1
# DEFINE f3          -2
# DEFINE f4          -3
# DEFINE f5          -4
# DEFINE f6          -5
# DEFINE f7          -6
# DEFINE f8          -7
# DEFINE f9          -8
# DEFINE f10         -9
# DEFINE sf1         84
# DEFINE sf2         85
# DEFINE sf3         86
# DEFINE sf4         87
# DEFINE sf5         88
# DEFINE sf6         89
# DEFINE sf7         90
# DEFINE sf8         91
# DEFINE sf9         92
# DEFINE ctrlw       23
# DEFINE lookup      -7
# DEFINE borrar      -8
# DEFINE escape_      27

#DEFINE ERRLOGACCESS	"c:\temp\NoAcceso.txt"
#DEFINE ERRLOGFILE	"c:\temp\Errores.txt"
#DEFINE DBCFILE		"c:\vfp\COM+\Transactions\testdata"

#DEFINE CRLF 			CHR(13)+CHR(10)
#DEFINE S_OK			0

#DEFINE MTX_CLASS	"MTXAS.APPSERVER.1"
#DEFINE ORDER_CLASS	"foxviper.order"
#DEFINE PROD_CLASS	"foxviper.prod"
#DEFINE CUST_CLASS	"foxviper.cust"
#DEFINE MSMQ_CLASS	"foxviper.msmqmsg"
#DEFINE MSMQ_QUEUE	"FoxViperQueue"


#DEFINE CONTEXT_E_ABORTED	-1
#DEFINE NONE_PROCESSED		-2
#DEFINE CUST_NOT_FOUND		-3
#DEFINE LIMIT_EXCEEDED		-4
#DEFINE ITEM_SIN_STOCK		-5
#DEFINE ITEM_NO_EXISTE		-6
#DEFINE SIN_ACCESO_TABLA	-7
#DEFINE ITEM_NO_ASIGNADO	-8
#DEFINE REGISTRO_YA_EXISTE	-9
#DEFINE SIN_CONFIGURAR_PK	-10
#DEFINE SIN_DEFINIR_ENTIDAD -11
#DEFINE	TRANSAC_SIN_CORRE	-12
#DEFINE	ERROR_GEN_CURSOR	-13 
#DEFINE ITEM_SIN_STOCK_LOTE		-14
#DEFINE ITEM_NO_EXISTE_LOTE		-15
#DEFINE CLIENTE_EN_INFOCORD		-16
#DEFINE GUIA_NO_EXISTE			-17
#DEFINE DOCUMENTO_NO_EXISTE		-17
#DEFINE GUIA_ANULADA			-18	
#DEFINE GUIA_NO_ES_DE_VENTAS	-19	
#DEFINE GUIA_FACTURADA			-20
#DEFINE GUIA_DE_OTRO_CLIENTE	-21
#DEFINE INVALIDO_REGISTRO		-22
#DEFINE TIENE_AMORTIZACIONES	-23
#DEFINE MES_CERRADO				-24
#DEFINE REGISTRO_BLOQUEADO		-25
#DEFINE AST_TIPO_NO_EXISTE		-26
#DEFINE AST_CABECERA_NO_GRABO	-27
#DEFINE AST_DETALLE_NO_GRABO	-28
#DEFINE AST_DETALLE_NO_GRABO_PARM	-29
#DEFINE AST_OPERACION_NO_EXISTE  -30
#DEFINE ITEM_NO_ESTA_ALM_DESTINO  -31
#DEFINE PROVEEDOR_NO_EXISTE		  -32
#DEFINE INDICE_PK_NO_EXISTE		  -33
#DEFINE DOCUMENTO_CON_FACTURA		  -34

#DEFINE ITEM_SIN_STOCK_NEG		1
#DEFINE ITEM_SIN_STOCK_NEG_LOTE	2
#DEFINE NO_GEN_CTA_AUTOMATICA	3
#DEFINE PIDE_CTA_AUTOMATICA		4
#DEFINE GEN_NO_CTA_CTO_EXI_AFRC	5
#DEFINE COSTO_UNIT_ALMACEN     101 
#DEFINE VALOR_ALMACEN	102 
#DEFINE STOCK_ALMACEN	103 
#DEFINE COSTO_ULTIMA_COMPRA	104 

#DEFINE MIN_AMOUNT	5000

#DEFINE TRANSFAIL1_LOC "Error en la transacción. El cliente no tiene suficiente cantidad máxima por pedido para este pedido. El saldo mínimo para una cuenta de cliente es de 5000 dólares."
#DEFINE NOORDERS_LOC "No hay pedidos para procesar."
#DEFINE TRANSFAIL2_LOC "Error en la transacción. Compruebe si faltan cantidades en existencias."
#DEFINE TRANSFAIL3_LOC "Error en la transacción. Posible error al obtener acceso a los datos de SQL Server."
#DEFINE TRANSFAIL4_LOC "Error en la transacción. No se encuentra el cliente."
#DEFINE TRANSFAIL5_LOC "Error en la transacción. No se encuentra el elemento."
#DEFINE TRANSGOOD_LOC "Transacción completada correctamente."

#DEFINE NOQTY_LOC	"Indique una cantidad."
#DEFINE C_ORDERS_LOC  "Tiene un pedido pendiente de procesamiento para este cliente Confirme que desea anular la transacción actual e iniciar un nuevo pedido de cliente."
#DEFINE C_ORDERS2_LOC "Tiene un pedido pendiente de procesamiento para este cliente. Confirme que desea anular la transacción actual y salir."
#DEFINE CHECKGOOD_LOC "Pedidos válidos."
#DEFINE ERR_CUSTNOTFOUND_LOC "Error en cliente: no se encuentra el Id. de cliente."
#DEFINE ERR_PRODNOTFOUND_LOC "Error en producto: no se encuentra el Id. de producto."

*-- Source Types for CursorGetProp()
#DEFINE DB_SRCLOCALVIEW         1
#DEFINE DB_SRCREMOTEVIEW        2
#DEFINE DB_SRCTABLE             3

** VETT:nuevas definiciones de error 2021/05/19 23:18:43 ** 
#DEFINE NO_DEFINIDA_CONFIG_FAM_MAT		  -35
#DEFINE NO_EXISTE_CUENTA_CONTABLE		  -36
