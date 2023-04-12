**************************************************
*-- Class:        interfase_sunat (k:\aplvfp\classgen\vcxs\inerfase_sunat.vcx)
*-- ParentClass:  base_form (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    form
*-- Time Stamp:   09/14/22 04:36:07 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS interfase_sunat AS base_form


	Height = 600
	Width = 1152
	ScrollBars = 2
	DoCreate = .T.
	Caption = "Interfase - Sunat - PLE - Libros Electronicos"
	WindowState = 0
	*-- Variable que sirve para avisar si los parametros de conexion a las conexiones adicionales (2 y 3) han sido capturados correctamente.
	conexion2y3 = .F.
	*-- Ruta (directorio) del repositorio de estructiuras modelo de tablas usadas en la interfase de migracion de datos
	cdirintcia = ([])
	*-- Codigo de libro contable segun SUNAT
	plelibro = ([])
	*-- Alias libro contable
	plealiaslib = ([])
	*-- Periodo proceso PLE
	pleperiod = ([])
	*-- Periodo PLE SUNAT
	pleperpco = ([])
	*-- Ruc de la empresa a porcesar en el PLE
	pleruccia = ([])
	*-- Codigo compañia/empresa para el PLE
	plecodcia = ([])
	*-- Sucursal perteneciente a la compañia / empresa a procesar en el PLE
	plecodsuc = ([])
	*-- Ruta donde se almacenan los archivos generados en el procesamiento del PLE
	pleruta = ([])
	plealiaspre = ([])
	plecurtradestino = ([])
	pletabladestino = ([])
	gencargadorrv = (.F.)
	regenerar_i_rv = .F.
	cargadornombre01 = ([])
	cargadornombre02 = ([])
	cargadornombre03 = ([])
	cargadornombre04 = ([])
	cargadornombre05 = ([])
	cargadornombre06 = ([])
	cargadornombre07 = ([])
	cargadornombre08 = ([])
	cargadornombre09 = ([])
	cargadornombre10 = ([])
	cargadornombre11 = ([])
	cargadornombre12 = ([])
	cargadornombre13 = ([])
	cargadornombre14 = ([])
	cargadornombre15 = ([])
	cargadornombre16 = ([])
	cargadornombre17 = ([])
	cargadornombre18 = ([])
	cargadornombre19 = ([])
	cargadornombre20 = ([])
	cargadorrutaarchivo01 = ([])
	cargadorrutaarchivo02 = ([])
	cargadorrutaarchivo03 = ([])
	cargadorrutaarchivo04 = ([])
	cargadorrutaarchivo05 = ([])
	cargadorrutaarchivo06 = ([])
	cargadorrutaarchivo07 = ([])
	cargadorrutaarchivo08 = ([])
	cargadorrutaarchivo09 = ([])
	cargadorrutaarchivo10 = ([])
	cargadorrutaarchivo11 = ([])
	cargadorrutaarchivo12 = ([])
	cargadorrutaarchivo13 = ([])
	cargadorrutaarchivo14 = ([])
	cargadorrutaarchivo15 = ([])
	cargadorrutaarchivo16 = ([])
	cargadorrutaarchivo17 = ([])
	cargadorrutaarchivo18 = ([])
	cargadorrutaarchivo19 = ([])
	cargadorrutaarchivo20 = ([])
	llregerror1 = (.F.)
	*-- Operación contable / Libro Contable / Sub Diario
	plecodope = ([])
	cargadornombre09_1 = "=[]"
	cargadorrutaarchivo09_1 = "=[]"
	cargadornombre10_1 = "=[]"
	cargadorrutaarchivo10_1 = "=[]"
	cargadornombre11_1 = "=[]"
	cargadorrutaarchivo11_1 = "=[]"
	cargadornombre12_1 = "=[]"
	cargadornombre13_1 = "=[]"
	cargadornombre14_1 = "=[]"
	cargadorrutaarchivo12_1 = "=[]"
	cargadorrutaarchivo13_1 = "=[]"
	cargadorrutaarchivo14_1 = ([])
	*-- Objeto que guarda los campos del registro a grabar en el cargador
	registro_cargador = .NULL.
	*-- Base de datos que guarda la informacion proveniente de sistemas externos o generada para exportar en otros formatos
	bd_interfase = "INTERFACE"
	llregerror2 = .F.
	llregerror3 = .F.
	llregerror4 = .F.
	filelogerror1 = ([])
	filelogerror2 = ([])
	filelogerror3 = ([])
	filelogerror4 = 
	_memberdata = [<VFPData><memberdata name="validar_proceso" type="method" display="Validar_Proceso"/><memberdata name="procesar" type="method" display="Procesar"/><memberdata name="procesa_le_05_01" type="method" display="Procesa_LE_05_01"/><memberdata name="procesa_le_08_01" type="method" display="Procesa_LE_08_01"/><memberdata name="procesa_le_14_01" type="method" display="Procesa_LE_14_01"/><memberdata name="procesa_le_06_01" type="method" display="Procesa_Le_06_01"/><memberdata name="cargar_bd_origen" type="method" display="Cargar_BD_Origen"/><memberdata name="periodolibro" type="method" display="PeriodoLibro"/><memberdata name="conexion2y3" type="property" display="Conexion2y3"/><memberdata name="cdirintcia" type="property" display="cDirIntCia"/><memberdata name="reproceso_txt_ple_2" type="method" display="Reproceso_Txt_PLe_2"/><memberdata name="cargar_bd_sqlserv1" type="method" display="Cargar_BD_SqlServ1"/><memberdata name="formatcursordestino" type="method" display="FormatCursorDestino"/><memberdata name="pa_genera_libro_electronico_14_01_v1_2" type="method" display="PA_GENERA_LIBRO_ELECTRONICO_14_01_V1_2"/><memberdata name="junk2" type="method" display="Junk2"/><memberdata name="plealiaspre" type="method" display="PleAliasPre"/><memberdata name="pletabladestino" type="method" display="PleTablaDestino"/><memberdata name="plecurtradestino" type="method" display="PleCurTraDestino"/><memberdata name="generacargador1" type="method" display="GeneraCargador1"/><memberdata name="generacargadorrv" type="method" display="GeneraCargadorRV"/><memberdata name="gencargadorrv" type="property" display="GenCargadorRV"/><memberdata name="regenerar_i_rv" type="property" display="Regenerar_I_RV"/><memberdata name="cargadornombre01" type="property" display="CargadorNombre01"/><memberdata name="cargadornombre02" type="property" display="CargadorNombre02"/><memberdata name="cargadornombre03" type="property" display="CargadorNombre03"/><memberdata name="cargadornombre04" type="property" display="CargadorNombre04"/><memberdata name="cargadornombre05" type="property" display="CargadorNombre05"/><memberdata name="cargadornombre06" type="property" display="CargadorNombre06"/><memberdata name="cargadornombre07" type="property" display="CargadorNombre07"/><memberdata name="cargadornombre08" type="property" display="CargadorNombre08"/><memberdata name="cargadornombre09" type="property" display="CargadorNombre09"/><memberdata name="cargadornombre10" type="property" display="CargadorNombre10"/><memberdata name="cargadornombre11" type="property" display="CargadorNombre11"/><memberdata name="cargadornombre12" type="property" display="CargadorNombre12"/><memberdata name="cargadornombre13" type="property" display="CargadorNombre13"/><memberdata name="cargadornombre14" type="property" display="CargadorNombre14"/><memberdata name="cargadornombre15" type="property" display="CargadorNombre15"/><memberdata name="cargadornombre16" type="property" display="CargadorNombre16"/><memberdata name="cargadornombre17" type="property" display="CargadorNombre17"/><memberdata name="cargadornombre18" type="property" display="CargadorNombre18"/><memberdata name="cargadornombre19" type="property" display="CargadorNombre19"/><memberdata name="cargadornombre20" type="property" display="CargadorNombre20"/><memberdata name="cargadorrutaarchivo01" type="property" display="CargadorRutaArchivo01"/><memberdata name="cargadorrutaarchivo02" type="property" display="CargadorRutaArchivo02"/><memberdata name="cargadorrutaarchivo03" type="property" display="CargadorRutaArchivo03"/><memberdata name="cargadorrutaarchivo04" type="property" display="CargadorRutaArchivo04"/><memberdata name="cargadorrutaarchivo05" type="property" display="CargadorRutaArchivo05"/><memberdata name="cargadorrutaarchivo06" type="property" display="CargadorRutaArchivo06"/><memberdata name="cargadorrutaarchivo07" type="property" display="CargadorRutaArchivo07"/><memberdata name="cargadorrutaarchivo08" type="property" display="CargadorRutaArchivo08"/><memberdata name="cargadorrutaarchivo09" type="property" display="CargadorRutaArchivo09"/><memberdata name="cargadorrutaarchivo10" type="property" display="CargadorRutaArchivo10"/><memberdata name="cargadorrutaarchivo11" type="property" display="CargadorRutaArchivo11"/><memberdata name="cargadorrutaarchivo12" type="property" display="CargadorRutaArchivo12"/><memberdata name="cargadorrutaarchivo13" type="property" display="CargadorRutaArchivo13"/><memberdata name="cargadorrutaarchivo14" type="property" display="CargadorRutaArchivo14"/><memberdata name="cargadorrutaarchivo15" type="property" display="CargadorRutaArchivo15"/><memberdata name="cargadorrutaarchivo16" type="property" display="CargadorRutaArchivo16"/><memberdata name="cargadorrutaarchivo17" type="property" display="CargadorRutaArchivo17"/><memberdata name="cargadorrutaarchivo18" type="property" display="CargadorRutaArchivo18"/><memberdata name="cargadorrutaarchivo19" type="property" display="CargadorRutaArchivo19"/><memberdata name="cargadorrutaarchivo20" type="property" display="CargadorRutaArchivo20"/><memberdata name="busca_ccosto_cta_cbd" type="method" display="Busca_CCosto_Cta_CBD"/><memberdata name="verificadbfcargador" type="method" display="VerificaDBFCargador"/><memberdata name="llregerror1" type="property" display="LlRegError1"/><memberdata name="busca_cta_cbd" type="method" display="Busca_Cta_CBD"/><memberdata name="generacargadorcargo" type="method" display="GeneraCargadorCargo"/><memberdata name="generacargadorpasajes" type="method" display="GeneraCargadorPasajes"/><memberdata name="generarcargadorcancelacion" type="method" display="GenerarCargadorCancelacion"/><memberdata name="buscarcorrelativocaja" type="method" display="BuscarCorrelativoCaja"/><memberdata name="cscheme" type="property" display="cScheme"/><memberdata name="cargadornombre09_1" type="property" display="CargadorNombre09_1"/><memberdata name="cargadorrutaarchivo09_1" type="property" display="CargadorRutaArchivo09_1"/><memberdata name="cargadornombre10_1" type="property" display="CargadorNombre10_1"/><memberdata name="cargadorrutaarchivo10_1" type="property" display="CargadorRutaArchivo10_1"/><memberdata name="cargadornombre11_1" type="property" display="CargadorNombre11_1"/><memberdata name="cargadorrutaarchivo11_1" type="property" display="CargadorRutaArchivo11_1"/><memberdata name="cargadornombre12_1" type="property" display="CargadorNombre12_1"/><memberdata name="cargadornombre13_1" type="property" display="CargadorNombre13_1"/><memberdata name="cargadornombre14_1" type="property" display="CargadorNombre14_1"/><memberdata name="cargadorrutaarchivo12_1" type="property" display="CargadorRutaArchivo12_1"/><memberdata name="cargadorrutaarchivo13_1" type="property" display="CargadorRutaArchivo13_1"/><memberdata name="cargadorrutaarchivo14_1" type="property" display="CargadorRutaArchivo14_1"/><memberdata name="bd_interfase" type="property" display="Bd_Interfase"/><memberdata name="generacargadoranulados" type="method" display="GeneraCargadorAnulados"/><memberdata name="le_14_01_gen_txt" type="method" display="LE_14_01_GEN_TXT"/><memberdata name="le_08_01_gen_txt_v4" type="method" display="Le_08_01_gen_txt_v4"/><memberdata name="procesa_le_08_02" type="method" display="Procesa_LE_08_02"/><memberdata name="cierra_temporales" type="method" display="Cierra_Temporales"/><memberdata name="ruta_factura_see_sfs" type="method" display="Ruta_Factura_SEE_SFS"/></VFPData>]
	cnromes = ([])
	Name = "PLEGeneracionTxt"
	Tools.Top = 2
	Tools.Left = 7
	Tools.Height = 19
	Tools.Width = 23
	Tools.Name = "Tools"


	ADD OBJECT base_shape2 AS base_shape WITH ;
		Top = 85, ;
		Left = 798, ;
		Height = 220, ;
		Width = 282, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		BackColor = RGB(128,128,255), ;
		BorderColor = RGB(0,0,0), ;
		ZOrderSet = 0, ;
		Name = "Base_shape2"


	ADD OBJECT shpcargadores_exactus AS base_shape WITH ;
		Top = 318, ;
		Left = 4, ;
		Height = 220, ;
		Width = 644, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		BackColor = RGB(255,177,100), ;
		BorderColor = RGB(0,0,0), ;
		ZOrderSet = 1, ;
		Name = "ShpCargadores_Exactus"


	ADD OBJECT shprepro_txt_ple_cuo_2013 AS base_shape WITH ;
		Top = 430, ;
		Left = 661, ;
		Height = 108, ;
		Width = 421, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		BackColor = RGB(150,221,226), ;
		BorderColor = RGB(0,0,0), ;
		ZOrderSet = 2, ;
		Name = "ShpRepro_TXT_PLE_CUO_2013"


	ADD OBJECT shprepro_txt_ple_sunat AS base_shape WITH ;
		Top = 322, ;
		Left = 661, ;
		Height = 100, ;
		Width = 421, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		BackColor = RGB(255,255,128), ;
		BorderColor = RGB(0,0,0), ;
		ZOrderSet = 3, ;
		Name = "ShpRepro_TXT_PLE_SUNAT"


	ADD OBJECT shpcargadatosple1 AS base_shape WITH ;
		Top = 86, ;
		Left = 6, ;
		Height = 220, ;
		Width = 776, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		BackColor = RGB(209,255,193), ;
		BorderColor = RGB(0,0,0), ;
		ZOrderSet = 4, ;
		Name = "ShpCargaDatosPle1"


	ADD OBJECT cmdprocesar1 AS cmdprocesar WITH ;
		Top = 242, ;
		Left = 684, ;
		Height = 48, ;
		Width = 60, ;
		TabIndex = 12, ;
		ToolTipText = "Procesar carga de datos y generar libros electrónicos", ;
		ZOrderSet = 6, ;
		Name = "Cmdprocesar1"


	ADD OBJECT base_label1 AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Escoger Mes", ;
		Height = 17, ;
		Left = 25, ;
		Top = 33, ;
		Width = 76, ;
		TabIndex = 14, ;
		ZOrderSet = 7, ;
		Name = "Base_label1"


	ADD OBJECT cbomes AS base_cbohelp WITH ;
		Anchor = 160, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 106, ;
		TabIndex = 2, ;
		Top = 28, ;
		Width = 96, ;
		ZOrderSet = 8, ;
		cnombreentidad = "cbdmtabl", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "Tabla", ;
		cvaloresfiltro = ('MM'), ;
		caliascursor = "C_meses", ;
		Name = "CboMes"


	ADD OBJECT lblarcrepetidos AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "Registros repetidos", ;
		Height = 16, ;
		Left = 69, ;
		Top = 241, ;
		Width = 113, ;
		TabIndex = 16, ;
		ZOrderSet = 9, ;
		Name = "LblArcRepetidos"


	ADD OBJECT txtarchivorepetidos AS base_textbox WITH ;
		FontSize = 8, ;
		Anchor = 160, ;
		Height = 20, ;
		Left = 207, ;
		TabIndex = 9, ;
		Top = 235, ;
		Width = 350, ;
		ZOrderSet = 10, ;
		Name = "txtArchivoRepetidos"


	ADD OBJECT cmdbuscadestino AS cmdbase WITH ;
		Top = 0, ;
		Left = 564, ;
		Height = 24, ;
		Width = 24, ;
		Anchor = 160, ;
		Caption = "...", ;
		TabIndex = 19, ;
		Visible = .F., ;
		ZOrderSet = 11, ;
		Name = "CmdbuscaDestino"


	ADD OBJECT lblarccorrelativos AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "Secuencia correlativo", ;
		Height = 16, ;
		Left = 57, ;
		Top = 262, ;
		Width = 120, ;
		TabIndex = 18, ;
		ZOrderSet = 12, ;
		Name = "LblArcCorrelativos"


	ADD OBJECT cmdsalir AS cmdsalir WITH ;
		Top = 1, ;
		Left = 955, ;
		Height = 40, ;
		Width = 60, ;
		Anchor = 160, ;
		TabIndex = 13, ;
		ZOrderSet = 13, ;
		Name = "Cmdsalir"


	ADD OBJECT txtarchivocorrelativos AS base_textbox WITH ;
		FontSize = 8, ;
		Anchor = 160, ;
		Height = 20, ;
		Left = 207, ;
		TabIndex = 10, ;
		Top = 256, ;
		Width = 350, ;
		ZOrderSet = 14, ;
		Name = "TxtArchivoCorrelativos"


	ADD OBJECT chkopemes AS base_checkbox WITH ;
		Top = 0, ;
		Left = 24, ;
		Height = 24, ;
		Width = 504, ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "INDICAR MES Y OPERACION CONTABLE QUE AFECTARA EL PROCESO DE INTERFACE", ;
		TabIndex = 1, ;
		ZOrderSet = 15, ;
		Name = "ChkOpeMes"


	ADD OBJECT base_label3 AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Escoger Libro contable a procesar", ;
		Height = 17, ;
		Left = 26, ;
		Top = 54, ;
		Width = 198, ;
		TabIndex = 3, ;
		ZOrderSet = 16, ;
		Name = "Base_label3"


	ADD OBJECT logerrores AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[ Log errores o inconsistencias ]", ;
		Height = 17, ;
		Left = 14, ;
		Top = 215, ;
		Width = 186, ;
		TabIndex = 17, ;
		ForeColor = RGB(255,128,0), ;
		BackColor = RGB(0,0,0), ;
		ZOrderSet = 17, ;
		Name = "LogErrores"


	ADD OBJECT lblarctxtplesunat AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Archivo de texto PLE - SUNAT", ;
		Height = 17, ;
		Left = 15, ;
		Top = 194, ;
		Width = 168, ;
		TabIndex = 17, ;
		ZOrderSet = 17, ;
		Name = "LblArcTXTPLESunat"


	ADD OBJECT txtrutaarchivopletxt AS base_textbox WITH ;
		Anchor = 160, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 207, ;
		TabIndex = 11, ;
		Top = 187, ;
		Width = 350, ;
		ZOrderSet = 18, ;
		Name = "TxtRutaArchivoPLETXT"


	ADD OBJECT txtubicacionarchivos AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 24, ;
		Left = 207, ;
		TabIndex = 7, ;
		Top = 162, ;
		Width = 491, ;
		ZOrderSet = 19, ;
		Name = "TxtUbicacionArchivos"


	ADD OBJECT cmdrecursos1 AS cmdrecursos WITH ;
		Top = 158, ;
		Left = 699, ;
		Height = 28, ;
		Width = 40, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 8, ;
		ToolTipText = "Escoger el archivo de texto (.txt o .csv)  que corresponde a la cabecera. ", ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 20, ;
		Name = "Cmdrecursos1"


	ADD OBJECT lblubicacionarchivos AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Ubicacion de archivo .TXT", ;
		Height = 17, ;
		Left = 35, ;
		Top = 169, ;
		Width = 148, ;
		TabIndex = 15, ;
		ZOrderSet = 21, ;
		Name = "LblUbicacionArchivos"


	ADD OBJECT lblfechad AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Desde la Fecha", ;
		Left = 339, ;
		Top = 351, ;
		Visible = .F., ;
		TabIndex = 7, ;
		ZOrderSet = 22, ;
		Name = "LblFechaD"


	ADD OBJECT txtfchdocd AS base_textbox_fecha WITH ;
		Anchor = 160, ;
		Left = 437, ;
		TabIndex = 8, ;
		Top = 344, ;
		Visible = .F., ;
		ZOrderSet = 23, ;
		Name = "txtFchDocD"


	ADD OBJECT lblfechah AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Hasta la Fecha", ;
		Left = 339, ;
		Top = 372, ;
		Visible = .F., ;
		TabIndex = 9, ;
		ZOrderSet = 24, ;
		Name = "LblFechaH"


	ADD OBJECT txtfchdoch AS base_textbox_fecha WITH ;
		Anchor = 160, ;
		Left = 437, ;
		TabIndex = 10, ;
		Top = 368, ;
		Visible = .F., ;
		ZOrderSet = 25, ;
		Name = "TxtFchDocH"


	ADD OBJECT opglibrosprocesar2 AS base_optiongroup WITH ;
		ButtonCount = 4, ;
		Anchor = 160, ;
		Height = 23, ;
		Left = 288, ;
		Top = 23, ;
		Width = 100, ;
		Visible = .F., ;
		ZOrderSet = 26, ;
		Name = "OpgLibrosProcesar2", ;
		Option1.Caption = "Libro Diario y Mayor", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.TabIndex = 1, ;
		Option1.Top = 6, ;
		Option1.Width = 150, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "Registro de Compras", ;
		Option2.Height = 17, ;
		Option2.Left = 285, ;
		Option2.TabIndex = 3, ;
		Option2.Top = 6, ;
		Option2.Width = 144, ;
		Option2.Name = "Option2", ;
		Option3.BackStyle = 0, ;
		Option3.Caption = "Registro de Ventas", ;
		Option3.Height = 17, ;
		Option3.Left = 453, ;
		Option3.TabIndex = 4, ;
		Option3.Top = 6, ;
		Option3.Width = 144, ;
		Option3.ForeColor = RGB(0,0,255), ;
		Option3.Name = "Option3", ;
		Option4.Caption = "Option4", ;
		Option4.Height = 17, ;
		Option4.Left = 168, ;
		Option4.TabIndex = 2, ;
		Option4.Top = 5, ;
		Option4.Width = 61, ;
		Option4.Name = "Option4"


	ADD OBJECT lblrepetidos AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "0", ;
		Height = 16, ;
		Left = 564, ;
		Top = 242, ;
		Width = 8, ;
		TabIndex = 16, ;
		ZOrderSet = 27, ;
		Name = "LblRepetidos"


	ADD OBJECT lblcorrelativos AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "0", ;
		Height = 16, ;
		Left = 564, ;
		Top = 263, ;
		Width = 8, ;
		TabIndex = 16, ;
		ZOrderSet = 28, ;
		Name = "LblCorrelativos"


	ADD OBJECT chkvalidarinfo AS base_checkbox WITH ;
		Top = 96, ;
		Left = 36, ;
		Height = 24, ;
		Width = 168, ;
		FontBold = .T., ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "NO validar información", ;
		ToolTipText = "Solo genera el archivo de texto en base a registro de ventas grabado en ultimo proceso, no realiza ninguna validacion de datos.", ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 29, ;
		Name = "ChkValidarInfo"


	ADD OBJECT lblarcrucdni AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "Tipo documento - Ruc/Dni", ;
		Height = 16, ;
		Left = 37, ;
		Top = 283, ;
		Width = 142, ;
		TabIndex = 18, ;
		ZOrderSet = 30, ;
		Name = "LblArcRucDni"


	ADD OBJECT txterrorrucdni AS base_textbox WITH ;
		FontSize = 8, ;
		Anchor = 160, ;
		Height = 20, ;
		Left = 207, ;
		TabIndex = 10, ;
		Top = 277, ;
		Width = 350, ;
		ZOrderSet = 31, ;
		Name = "TxtErrorRucDNI"


	ADD OBJECT lblerrorrucdni AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Anchor = 160, ;
		Caption = "0", ;
		Height = 16, ;
		Left = 564, ;
		Top = 282, ;
		Width = 8, ;
		TabIndex = 16, ;
		ZOrderSet = 32, ;
		Name = "LblErrorRucDni"


	ADD OBJECT cmdprocccosto AS cmdprocesar WITH ;
		Top = 206, ;
		Left = 811, ;
		Height = 48, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\analisis1.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		TabIndex = 12, ;
		ToolTipText = "Re-Procesar PLE - XLSx, Diario- Mayor previamente generado para colocar C.COSTO del Exactus", ;
		Visible = .F., ;
		ZOrderSet = 33, ;
		Name = "CmdprocCCOSTO"


	ADD OBJECT cmdprocesar2 AS cmdprocesar WITH ;
		Top = 378, ;
		Left = 680, ;
		Height = 40, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\reprocesa_txt2.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		TabIndex = 12, ;
		ToolTipText = "Re-Procesar archivo de texto PLE , previamente generado", ;
		Visible = .F., ;
		ZOrderSet = 34, ;
		Name = "Cmdprocesar2"


	ADD OBJECT opgreproccosto AS base_optiongroup WITH ;
		Anchor = 160, ;
		Height = 31, ;
		Left = 809, ;
		Top = 95, ;
		Width = 183, ;
		ZOrderSet = 35, ;
		Name = "OpgReproCCosto", ;
		Option1.Caption = "NO", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 70, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "SI", ;
		Option2.Height = 17, ;
		Option2.Left = 62, ;
		Option2.Top = 5, ;
		Option2.Width = 140, ;
		Option2.Name = "Option2"


	ADD OBJECT txtarchivoxls_ple_ccosto AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 64, ;
		Left = 803, ;
		TabIndex = 11, ;
		Top = 124, ;
		Visible = .F., ;
		Width = 217, ;
		ZOrderSet = 36, ;
		Name = "TxtArchivoXLS_PLE_CCosto"


	ADD OBJECT cmddirreproccosto AS cmdrecursos WITH ;
		Top = 138, ;
		Left = 1027, ;
		Height = 28, ;
		Width = 40, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 26, ;
		ToolTipText = "Escoger el archivo de texto (.txt o .csv)  que corresponde a la cabecera. ", ;
		Visible = .F., ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 37, ;
		Name = "CmdDirReproCCosto"


	ADD OBJECT opgreproceso AS base_optiongroup WITH ;
		Anchor = 160, ;
		Height = 31, ;
		Left = 674, ;
		Top = 327, ;
		Width = 183, ;
		ZOrderSet = 38, ;
		Name = "OpgReproceso", ;
		Option1.Caption = "NO", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 70, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "SI", ;
		Option2.Height = 17, ;
		Option2.Left = 62, ;
		Option2.Top = 5, ;
		Option2.Width = 140, ;
		Option2.Name = "Option2"


	ADD OBJECT txtarchivotxtple_r AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 24, ;
		Left = 677, ;
		TabIndex = 11, ;
		Top = 352, ;
		Visible = .F., ;
		Width = 350, ;
		ZOrderSet = 39, ;
		Name = "txtArchivoTXTPLE_r"


	ADD OBJECT cmdrutatxtple_r AS cmdrecursos WITH ;
		Top = 350, ;
		Left = 1036, ;
		Height = 28, ;
		Width = 40, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 26, ;
		ToolTipText = "Escoger el archivo de texto (.txt o .csv)  que corresponde a la cabecera. ", ;
		Visible = .F., ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 40, ;
		Name = "CmdRutaTxtPle_R"


	ADD OBJECT cmdprocesar3 AS cmdprocesar WITH ;
		Top = 378, ;
		Left = 761, ;
		Height = 40, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\reproceso_1.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		TabIndex = 12, ;
		ToolTipText = "Re-Procesar archivo de texto PLE , previamente generado - ANULADOS ENERO-NOVIEMBRE -2015", ;
		Visible = .F., ;
		ZOrderSet = 41, ;
		Name = "Cmdprocesar3"


	ADD OBJECT txtrutaorigendatos AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 24, ;
		Left = 207, ;
		TabIndex = 7, ;
		Top = 136, ;
		Visible = .F., ;
		Width = 491, ;
		ZOrderSet = 42, ;
		Name = "TxtRutaOrigenDatos"


	ADD OBJECT cmdorigendat AS cmdrecursos WITH ;
		Top = 132, ;
		Left = 699, ;
		Height = 28, ;
		Width = 40, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 8, ;
		ToolTipText = "Indicar la ruta de origen de la base de datos a utilizar", ;
		Visible = .F., ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 43, ;
		Name = "CmdOrigenDat"


	ADD OBJECT lblrutaoridat AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Ruta de origen de datos ", ;
		Height = 17, ;
		Left = 44, ;
		Top = 143, ;
		Visible = .F., ;
		Width = 139, ;
		TabIndex = 15, ;
		ZOrderSet = 44, ;
		Name = "LblRutaOriDat"


	ADD OBJECT lbltipooridat AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Tipo de origen de datos ", ;
		Height = 17, ;
		Left = 46, ;
		Top = 121, ;
		Visible = .F., ;
		Width = 137, ;
		TabIndex = 15, ;
		ZOrderSet = 45, ;
		Name = "LblTipoOriDat"


	ADD OBJECT chkregenera_i_rv AS base_checkbox WITH ;
		Top = 330, ;
		Left = 795, ;
		Height = 24, ;
		Width = 168, ;
		FontBold = .T., ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "NO validar información", ;
		ToolTipText = "Solo genera el archivo de texto en base a registro de ventas grabado en ultimo proceso, no realiza ninguna validacion de datos.", ;
		Visible = .F., ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 46, ;
		Name = "ChkRegenera_I_RV"


	ADD OBJECT cbotpooridat AS base_cbohelp WITH ;
		FontSize = 8, ;
		Anchor = 160, ;
		ColumnCount = 2, ;
		ControlSource = "", ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 207, ;
		TabIndex = 17, ;
		Top = 115, ;
		Visible = .F., ;
		Width = 115, ;
		ZOrderSet = 47, ;
		BackColor = RGB(230,255,255), ;
		ReadOnly = .F., ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('OD'), ;
		caliascursor = "c_TpoOriDat", ;
		Name = "cboTpoOriDat"


	ADD OBJECT cmdprocesar4 AS cmdprocesar WITH ;
		Top = 378, ;
		Left = 853, ;
		Height = 40, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		TabIndex = 12, ;
		ToolTipText = "Re-Procesar EXCESOS Y N/Creditos SUBTOTAL = 0 , RUBRO2=SUBTOTAL", ;
		Visible = .F., ;
		ZOrderSet = 48, ;
		Name = "Cmdprocesar4"


	ADD OBJECT cmdtestcargo AS cmdprocesar WITH ;
		Top = 1, ;
		Left = 812, ;
		Height = 40, ;
		Width = 60, ;
		FontName = "Tw Cen MT Condensed Extra Bold", ;
		FontSize = 9, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\1278540399_database_key.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		Caption = "\<Test CARGO", ;
		Enabled = .T., ;
		TabIndex = 12, ;
		ToolTipText = "Probar conexion a BD CARGO", ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 49, ;
		Name = "CmdTestCargo"


	ADD OBJECT cmdtestcnx_fics AS cmdprocesar WITH ;
		Top = 1, ;
		Left = 750, ;
		Height = 40, ;
		Width = 60, ;
		FontName = "Tw Cen MT Condensed Extra Bold", ;
		FontSize = 9, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\1278540399_database_key.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		Caption = "Test \<FICS", ;
		Enabled = .T., ;
		TabIndex = 12, ;
		ToolTipText = "Probar conexion a BD FICS", ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 50, ;
		Name = "CmdTestCNX_FICS"


	ADD OBJECT cmdconfigcctoct AS cmdprocesar WITH ;
		Top = 2, ;
		Left = 893, ;
		Height = 40, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\crystallized\new\office_man_excel.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		Caption = "\<Configuracion", ;
		Enabled = .T., ;
		TabIndex = 12, ;
		ToolTipText = "Configuraciòn Zona / Localidad / Centro Costo / Cuenta Contable / Caja", ;
		Visible = .T., ;
		ZOrderSet = 51, ;
		Name = "CmdConfigCCTOCT"


	ADD OBJECT cmdcargador AS cmdprocesar WITH ;
		Top = 343, ;
		Left = 543, ;
		Height = 48, ;
		Width = 60, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\crystallized\new\office_man_excel.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		Enabled = .T., ;
		TabIndex = 12, ;
		ToolTipText = "Generar cargadores de venta", ;
		Visible = .F., ;
		ZOrderSet = 52, ;
		Name = "CmdCargador"


	ADD OBJECT lblreprocesotxt AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[  Reproceso archivo texto PLE - SUNAT ]", ;
		Height = 17, ;
		Left = 673, ;
		Top = 313, ;
		Width = 232, ;
		TabIndex = 17, ;
		ZOrderSet = 53, ;
		Name = "LblReprocesoTXT"


	ADD OBJECT lblcargadoresexactus AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[  Generar cargadores para EXACTUS  ]", ;
		Height = 17, ;
		Left = 28, ;
		Top = 310, ;
		Width = 223, ;
		TabIndex = 17, ;
		ZOrderSet = 54, ;
		Name = "LblCargadoresExactus"


	ADD OBJECT opgcargadores AS base_optiongroup WITH ;
		Anchor = 160, ;
		Height = 31, ;
		Left = 28, ;
		Top = 322, ;
		Width = 83, ;
		ZOrderSet = 55, ;
		Name = "OpgCargadores", ;
		Option1.Caption = "NO", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 70, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "SI", ;
		Option2.Height = 17, ;
		Option2.Left = 56, ;
		Option2.Top = 5, ;
		Option2.Width = 140, ;
		Option2.Name = "Option2"


	ADD OBJECT txtestadoproceso1 AS base_label WITH ;
		AutoSize = .F., ;
		BackStyle = 1, ;
		Caption = ".", ;
		Height = 17, ;
		Left = 3, ;
		Top = 544, ;
		Visible = .F., ;
		Width = 1077, ;
		ForeColor = RGB(0,255,0), ;
		BackColor = RGB(0,0,0), ;
		ZOrderSet = 56, ;
		Name = "TxtEstadoProceso1"


	ADD OBJECT txtestadoproceso2 AS base_label WITH ;
		AutoSize = .F., ;
		BackStyle = 1, ;
		Caption = ".", ;
		Height = 17, ;
		Left = 3, ;
		Top = 562, ;
		Visible = .F., ;
		Width = 1077, ;
		ForeColor = RGB(0,255,0), ;
		BackColor = RGB(0,0,0), ;
		ZOrderSet = 57, ;
		Name = "TxtEstadoProceso2"


	ADD OBJECT chkpasajes AS base_checkbox WITH ;
		Top = 347, ;
		Left = 30, ;
		Height = 24, ;
		Width = 108, ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "Pasajes", ;
		Visible = .F., ;
		ZOrderSet = 58, ;
		Name = "ChkPasajes"


	ADD OBJECT chkcargo AS base_checkbox WITH ;
		Top = 362, ;
		Left = 30, ;
		Height = 24, ;
		Width = 72, ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "Cargo", ;
		Visible = .F., ;
		ZOrderSet = 59, ;
		Name = "ChkCargo"


	ADD OBJECT chkcancelacion1 AS base_checkbox WITH ;
		Top = 347, ;
		Left = 125, ;
		Height = 24, ;
		Width = 108, ;
		Anchor = 160, ;
		Alignment = 0, ;
		Caption = "Cancelación 1", ;
		Visible = .F., ;
		ZOrderSet = 60, ;
		Name = "ChkCancelacion1"


	ADD OBJECT txtubicacioncargadores AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 24, ;
		Left = 98, ;
		TabIndex = 7, ;
		Top = 403, ;
		Visible = .T., ;
		Width = 447, ;
		ZOrderSet = 61, ;
		Name = "TxtUbicacionCargadores"


	ADD OBJECT lblreproccosto AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[   Reproceso PLE- XLS - Ccosto -Diario - Mayor ]", ;
		Height = 17, ;
		Left = 802, ;
		Top = 76, ;
		Width = 274, ;
		TabIndex = 17, ;
		ZOrderSet = 62, ;
		Name = "LblReproCCosto"


	ADD OBJECT cmdrrutacargador AS cmdrecursos WITH ;
		Top = 444, ;
		Left = 852, ;
		Height = 28, ;
		Width = 38, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 8, ;
		ToolTipText = "Escoger el archivo de texto (.txt o .csv)  que corresponde a la cabecera. ", ;
		Visible = .T., ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 63, ;
		Name = "CmdrRutaCargador"


	ADD OBJECT base_label5 AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 10, ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[ Carga de datos y generación archivo  .TXT ]", ;
		Height = 18, ;
		Left = 28, ;
		Top = 78, ;
		Width = 289, ;
		TabIndex = 17, ;
		ForeColor = RGB(0,0,255), ;
		BackColor = RGB(240,240,240), ;
		ZOrderSet = 64, ;
		Name = "Base_label5"


	ADD OBJECT lblubicargadores AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		Caption = "Ubicacion ", ;
		Height = 17, ;
		Left = 33, ;
		Top = 410, ;
		Visible = .F., ;
		Width = 61, ;
		TabIndex = 15, ;
		ZOrderSet = 65, ;
		Name = "LblUbiCargadores"


	ADD OBJECT cmdrepro_ple_rv2013 AS cmdprocesar WITH ;
		Top = 488, ;
		Left = 676, ;
		Height = 40, ;
		Width = 168, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\database.ico", ;
		DisabledPicture = "..\..\grafgen\iconos\reproceso_txt.ico", ;
		Caption = "\<Reproceso PLE-RV-2013", ;
		TabIndex = 12, ;
		ToolTipText = "Re-proceso  PLE-Registro de ventas 2013  - modificación CUO en base RV Exactus", ;
		Visible = .F., ;
		PicturePosition = 1, ;
		ZOrderSet = 66, ;
		Name = "CmdRepro_Ple_RV2013"


	ADD OBJECT txtarchivo_rv_exactus_csv AS base_textbox WITH ;
		Anchor = 160, ;
		Height = 24, ;
		Left = 677, ;
		TabIndex = 11, ;
		Top = 463, ;
		Visible = .F., ;
		Width = 350, ;
		ZOrderSet = 67, ;
		Name = "TxtArchivo_RV_Exactus_CSV"


	ADD OBJECT cmdruta_rv_exactus_csv AS cmdrecursos WITH ;
		Top = 461, ;
		Left = 1036, ;
		Height = 28, ;
		Width = 40, ;
		Anchor = 160, ;
		Picture = "..\..\grafgen\iconos\folder03.ico", ;
		Caption = "", ;
		TabIndex = 26, ;
		ToolTipText = "Escoger el archivo de texto (.txt o .csv)  que corresponde a la cabecera. ", ;
		Visible = .F., ;
		SpecialEffect = 2, ;
		PicturePosition = 13, ;
		ZOrderSet = 68, ;
		Name = "CmdRuta_RV_Exactus_CSV"


	ADD OBJECT lblrepro_ple_rv_2013 AS base_label WITH ;
		FontBold = .T., ;
		Anchor = 160, ;
		BackStyle = 1, ;
		Caption = "[   Reproceso PLE - Registro de Ventas 2013 - Modificacion CUO  ]", ;
		Height = 17, ;
		Left = 674, ;
		Top = 424, ;
		Width = 371, ;
		TabIndex = 17, ;
		ZOrderSet = 69, ;
		Name = "LblRepro_PLE_RV_2013"


	ADD OBJECT opgrepro_ple_rv_2013 AS base_optiongroup WITH ;
		Anchor = 160, ;
		Height = 31, ;
		Left = 674, ;
		Top = 440, ;
		Width = 120, ;
		ZOrderSet = 70, ;
		Name = "OpgRepro_PLE_RV_2013", ;
		Option1.Caption = "NO", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 70, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "SI", ;
		Option2.Height = 17, ;
		Option2.Left = 62, ;
		Option2.Top = 5, ;
		Option2.Width = 140, ;
		Option2.Name = "Option2"


	ADD OBJECT optborralogerrores AS base_optiongroup WITH ;
		Anchor = 160, ;
		Value = 2, ;
		Height = 31, ;
		Left = 351, ;
		Top = 433, ;
		Width = 88, ;
		Visible = .F., ;
		ZOrderSet = 71, ;
		Name = "OptBorraLogErrores", ;
		Option1.FontBold = .T., ;
		Option1.Caption = "NO", ;
		Option1.Value = 0, ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 70, ;
		Option1.ForeColor = RGB(0,65,0), ;
		Option1.Name = "Option1", ;
		Option2.FontBold = .T., ;
		Option2.Caption = "SI", ;
		Option2.Value = 1, ;
		Option2.Height = 17, ;
		Option2.Left = 56, ;
		Option2.Top = 5, ;
		Option2.Width = 140, ;
		Option2.ForeColor = RGB(0,65,0), ;
		Option2.Name = "Option2"


	ADD OBJECT lblborralogerrores AS base_label WITH ;
		FontBold = .T., ;
		FontUnderline = .T., ;
		Anchor = 160, ;
		Caption = "Borrar registro (log) de errores de procesos anteriores", ;
		Height = 17, ;
		Left = 33, ;
		Top = 438, ;
		Visible = .F., ;
		Width = 314, ;
		TabIndex = 17, ;
		ZOrderSet = 72, ;
		Name = "lblBorraLogErrores"


	ADD OBJECT lstlogerror AS base_listbox WITH ;
		Anchor = 160, ;
		ColumnCount = 2, ;
		ColumnWidths = "320,140", ;
		Height = 60, ;
		Left = 30, ;
		Top = 455, ;
		Visible = .F., ;
		Width = 500, ;
		ZOrderSet = 73, ;
		Name = "LstLogError"


	ADD OBJECT opglibrosprocesar AS base_optiongroup WITH ;
		ButtonCount = 4, ;
		Anchor = 160, ;
		Height = 29, ;
		Left = 240, ;
		Top = 48, ;
		Width = 709, ;
		Name = "OpgLibrosProcesar", ;
		Option1.Caption = "Libro Diario", ;
		Option1.Height = 17, ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Width = 116, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "Libro Mayor", ;
		Option2.Height = 17, ;
		Option2.Left = 166, ;
		Option2.Top = 5, ;
		Option2.Width = 99, ;
		Option2.Name = "Option2", ;
		Option3.BackStyle = 0, ;
		Option3.Caption = "Registro de Compras", ;
		Option3.Height = 17, ;
		Option3.Left = 287, ;
		Option3.Top = 6, ;
		Option3.Width = 134, ;
		Option3.ForeColor = RGB(0,0,255), ;
		Option3.Name = "Option3", ;
		Option4.BackStyle = 0, ;
		Option4.Caption = "Registro de Ventas", ;
		Option4.Height = 17, ;
		Option4.Left = 455, ;
		Option4.Top = 6, ;
		Option4.Width = 134, ;
		Option4.ForeColor = RGB(0,0,255), ;
		Option4.Name = "Option4"


	PROCEDURE validar_proceso
		Modificar  = gosvrcbd.mescerrado(VAL(XsNroMes))
		IF  Modificar
			GsMsgErr = "Mes debe estar cerrado, no puede ejecutar el proceso"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN .f.
		ENDIF
	ENDPROC


	PROCEDURE procesar
		*Genera Libro Diario y Mayor
		thisform.TxtEstadoProceso1.Caption = '....' 
		thisform.TxtEstadoProceso2.Caption = '......' 

		IF thisform.OpgLibrosProcesar.Value = 1
			IF !ThisForm.Procesa_LE_05_01()
				RETURN .F.
			ENDIF 
		ENDIF
		IF thisform.OpgLibrosProcesar.Value = 2
			IF !ThisForm.Procesa_Le_06_01()
				RETURN .F.
			ENDIF 
		ENDIF

		*Genera Libro de Compras
		IF thisform.OpgLibrosProcesar.Value = 3
			IF !ThisForm.Procesa_LE_08_01()
				RETURN .F.
			ENDIF 
		ENDIF

		*Genera Libro de Ventas
		IF thisform.OpgLibrosProcesar.Value = 4
			IF !ThisForm.Procesa_LE_14_01()
				RETURN .F.
			ENDIF 
		ENDIF
	ENDPROC


	PROCEDURE procesa_le_05_01
		WAIT WINDOW "Generando Archivo SUNAT - Libro Diario....!!!" NOWAIT NOCLEAR 
		thisform.Cierra_Temporales
		*** 1. Variables
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '050100' 

		*** 2. Selecciona Datos
		wcad 	= "Select * 					"
		wcad=wcad+"from LBE_0501_DIARIO_LED		"
		wcad=wcad+"where cia_codcia = ?lcodcia	"
		wcad=wcad+"and   periodo    = ?lperpco 	"
		wcad=wcad+"order by asiento				"
		IF Sqlexec(ocnx.conexion,wcad,'DIARIO')<0
			Ocnx.Errormensaje = 'Error al seleccionar datos desde LBE_0501_DIARIO_LED. Consulte con el Tecnico' + CHR(13)+MESSAGE()
		    RETURN .f.
		ENDIF


		*** 3. Define Nombre de la Tabla SUNAT
		wform   = "Libro_Electronico_Diario_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'         +  '1'            + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = curdir()+lruta   
		wdriver = fcreate(wruta+wfile)
		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		WAIT WINDOW "Generando archivo: "+wruta+wfile NOWAIT 

		*** 4. Genera Archivo SUNAT
		SELECT DIARIO
		GO TOP
		SCAN
			wcad = 	"|"+;
					ALLTRIM(diario.periodo)				+"|"+;
					ALLTRIM(diario.asiento)				+"|"+;
					ALLTRIM(diario.T17_CODT17)			+"|"+;
					ALLTRIM(diario.CCT_CODCCT)			+"|"+;
					DTOC(diario.ACA_FECDIA)				+"|"+;
					ALLTRIM(NVL(DIARIO.ADE_GLOADE,''))	+"|"+;
					ALLTRIM(STR(diario.DEBE,15,2))		+"|"+;
					ALLTRIM(STR(diario.HABER,15,2))		+"|"+;
					ALLTRIM(NVL(DIARIO.ESTADO_OPE,'1'))	+"|"+;
					SPACE(200)							+"|"
		    =fput(wdriver,wcad)    
		    SELECT DIARIO
		ENDSCAN
		=fclose(wdriver)
	ENDPROC


	PROCEDURE procesa_le_08_01
		thisform.Cierra_Temporales
		this.TxtEstadoProceso1.Caption	=	[GENERANDO ARCHIVO SUNAT - LIBRO COMPRAS....!!!] 
		this.TxtEstadoProceso2.Caption	=	[] 
		thisform.TxtEstadoProceso1.Refresh 
		thisform.TxtEstadoProceso2.Refresh 

		*** 1. Variables
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '080100' 
		LsAliasLib = 'RC'
		LsAliasPre = 'P_RC'

		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)


		IF THISFORM.ChkValidarInfo.Value = .T.
		 	*** 1. Cargamos Datos del MsAccess a 
			*!*	WAIT WINDOW 'Procesando datos del Registro de ventas en formato MS ACCESS' NOWAIT
		 	THIS.TxtEstadoProceso1.Caption = 'PROCESANDO DATOS PARA GENERAR REGISTRO DE COMPRAS - PLE-SUNAT...'
		 	THIS.TxtEstadoProceso2.Caption = 'Extrayendo registros a procesar desde el origen de datos '+UPPER(THIS.CboTpoOriDat.Value )
			thisform.TxtEstadoProceso1.Refresh 
			thisform.TxtEstadoProceso2.Refresh 
			DO CASE 
				CASE UPPER(GsSigCia)='OLTURSA'


				OTHERWISE 
					** VETT:*** CARGAMOS REGISTRO DE VENTAS DE BASE DE DATOS NATIVA DEL SISTEMA CONTABLE O-NEGOCIOS , RECIEN?? ... SI RECIEN...  2015/04/06 12:01:48 ** 
					SELECT 0
				 	WITH THISFORM
				 		.Cargar_BD_Origen(.CboTpoOriDat.Value, "", .TxtRutaOrigenDatos.Value,'Admin','', ;
												'',Thisform.PleTablaDestino,.T.,'RMOV') 
					ENDWITH
					THIS.TxtEstadoProceso2.Caption = ''
					thisform.TxtEstadoProceso1.Refresh 
					thisform.TxtEstadoProceso2.Refresh 


			ENDCASE

			** 5. Validamos correlativos y registros repetidos segun serie y numero de documento
			** Error de secuencia de numeros correlativo por serie

			** Temporal para errores de Tipo de documento y Longitud del RUC
			SELECT RegCom
			LsArcTmp4= ADDBS(GoEntorno.TmpPath)+SYS(3)
			COPY TO (LsArcTmp4) FOR 1=0 WITH CDX TYPE FOX2X 
			SELECT 0
			USE  (LsArcTmp4) ALIAS ErrRucDni

			this.TxtEstadoProceso2.Caption	=  'Verificando error de secuencia de correlativos x serie y numero documento' 
			SELECT 0
			CREATE TABLE RegComCorr FREE (t10_codT10 C(2),Serie C(4), Desde C(20),Hasta C(20))
			SELECT REGCOM
			SET FILTER TO 
			LOCATE
			SET ORDER TO Serie
			LOCATE
			DO WHILE NOT EOF()
				LsLlave = t10_codT10 + Serie
				IF INLIST(RUC,'20100014395','20479390381','20512780114','20516762111','10078351239','20519330874','20408101701','20502811674','20100027021')
						** Estos ruc estan con roche
		*!*					SET STEP ON 
				ENDIF

				DO  WHILE t10_codT10 + Serie = LsLlave AND !EOF()
					*** Aprovechamos para revisar Anulados y  Marcar los Anulados ***
						IF VAL(Serie)=231 AND INLIST(Numero,'864','871','879','882')
		*!*							SET STEP ON 
						ENDIF
					IF Estado1 = 'A'
						REPLACE Estado_OPE	WITH '2'
						REPLACE FecEmi_Ref	WITH CTOD('01/01/1900')
						IF INLIST(t02_codt02,'6','1')
							REPLACE t02_codt02 WITH '0'
							REPLACE RUC WITH '0'
						ENDIF
						IF t10_codt10='07' && Si la nota de credito esta anulada debe tener referencia en blanco
							replace 	REGCOM.T10_CODREF	WITH '00'
							replace  REGCOM.Serie_ref 		WITH ''
							replace  REGCOM.Numero_ref	WITH ''
						ENDIF
					ENDIF
					*** 
					*** Ahora aprovechamos para verificar los DNI o RUC con error en Tipo de documento ***
					IF t02_codt02='6' AND LEN(TRIM(Ruc))=8
						replace t02_codt02 WITH '1'
						SCATTER MEMVAR 
						m.cte_fecven = NVL(m.cte_fecven ,{})
						INSERT INTO (LsArcTmp4)  FROM MEMVAR
					ENDIF
					IF t02_codt02='1' AND LEN(TRIM(Ruc))=11
						replace t02_codt02 WITH '6'
						SCATTER MEMVAR 
						m.cte_fecven = NVL(m.cte_fecven ,{})
						INSERT INTO (LsArcTmp4) FROM MEMVAR
					ENDIF
					IF INLIST(T10_codt10,'16','01','07') and t02_codt02='0' and  len(TRIM(ruc))=11 
						REPLACE REGCOM.t02_codt02 WITH '6'
					ENDIF

					*** 
					this.TxtEstadoProceso2.Caption	=  'Revisando errores de secuencia en correlativos x serie '+ Serie+ ' '+ Numero 
					LsSerieIni = Serie
					LsNumeroIni = Numero
					SCATTER MEMVAR 
					SKIP
					LsNumeroFin = 	Numero
					LsSerieFin = Serie
					IF LsSerieFin = LsSerieIni AND ABS( VAL(LsNumeroFin)-VAL(LsNumeroIni) ) >1 
						*** Roche con la secuencia del correlativo ***
						SELECT REGCOMCorr
						APPEND BLANK 
						GATHER MEMVAR
						replace Desde	WITH LsNumeroIni
						replace Hasta 	WITH LsNumeroFin
						SELECT REGCOM
						*** 
					ENDIF
				ENDDO
			ENDDO
			SELECT REGCOMCorr
			LOCATE
			LsFileCorrelativos = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.TxtArchivoCorrelativos.Value ) 
			IF !EOF()
				IF FILE(LsFileCorrelativos)
					DELETE FILE (LsFileCorrelativos)
				ENDIF
				thisform.LblCorrelativos.Caption = TRANSFORM( RECCOUNT(),'999,999')
				COPY TO (LsFileCorrelativos) TYPE XLS 
			ENDIF

			*** Copiamos Archivo con Errores DNI y RUC ***
			IF !USED('ErrRucDni')
				SELECT 0
				USE (LsArcTmp4)  ALIAS ErrRucDni
			ELSE
				SELECT ErrRucDni
				LOCATE 
			ENDIF
			LsFileErrRucDni = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.TxtErrorRucDNI.Value ) 
			IF !EOF()
				IF FILE(LsFileErrRucDni)
					DELETE FILE (LsFileErrRucDni)
				ENDIF
				thisform.LblErrorRucDni.Caption = TRANSFORM( RECCOUNT(),'999,999')
				COPY TO (LsFileErrRucDni) TYPE XLS 
			ENDIF

		ELSE
			IF !FILE(ADDBS(goentorno.locpath)+LsAliasLib +Lperiod+'.dbf')
				=MESSAGEBOX('Se debe generar el archivo con los registros validados, ejecute nuevamente con la opción de SI validar información, por lo menos una vez',48,'ATENCION ! ')
				ls_mensaje = 'No se pudo ejecutar por que no se encontro el archivo con los registros procesados del registro de ventas '+Lperiod
				RETURN .F.
			ELSE
				SELECT 0
				USE ADDBS(goentorno.locpath)+LsAliasLib +lPeriod ALIAS REGCOM
			ENDIF
		ENDIF
		*** 3. Define Nombre de la Tabla SUNAT

		*** 4. Genera Archivo SUNAT
		SELECT REGCOM
		SET ORDER TO
		SET FILTER TO 
		LnTotReg = 0
		COUNT FOR INLIST(Estado_OPE,'1','2','6','8','9') AND !INLIST(T10_CODT10,'00','91','97','98') TO LnTotReg 
		LcFlgDat 	= IIF(LnTotReg=0,'0','1')

		wform   = "Libro_Electronico_RegComp_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'    +  LcFlgDat   + '1'    +  '1'     + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = ADDBS(TRIM(This.TxtUbicacionArchivos.Value)) && curdir()+lruta   
		IF !DIRECTORY(wruta)
			MKDIR (wruta)
		ENDIF
		IF FILE(wruta+wfile)
			DELETE FILE (wruta+wfile)
		ENDIF
		wdriver = fcreate(wruta+wfile)
		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		WAIT WINDOW "Generando archivo: "+wruta+wfile NOWAIT 
		LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '

		SELECT REGCOM
		LnRegAct = 0
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','6','8','9')
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
				this.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
			ENDIF
			IF INLIST(T10_CODT10,'00','91','97','98')
				LOOP 
			ENDIF
		*!*		SET STEP ON 
			DO CASE 
		    		CASE INLIST(T10_CODT10,'01','02','03','04','06','07','08','10','22','23','25','34','35','36','46','48','56','89')
					IF LEN(ALLTRIM(REGCOM.SERIE)) < 4
						REPLACE REGCOM.SERIE WITH RIGHT('0000' + ALLTRIM(REGCOM.SERIE),4)
					ELSE
						REPLACE REGCOM.SERIE WITH LEFT(ALLTRIM(REGCOM.SERIE),4)
					ENDIF
			ENDCASE 

			this.Le_08_01_gen_txt_v5 

		    SELECT REGCOM
		ENDSCAN
		=fclose(wdriver)
		IF thisform.ChkValidarInfo.Value = .T.
		*!*		WAIT WINDOW "Haciendo Backup de registros procesados en : "+ADDBS(goentorno.locpath)+LsAliasLib+lperiod+'.dbf' NOWAIT
		*!*		COPY   TO ADDBS(goentorno.locpath)+LsAliasLib+lperiod WITH CDX TYPE FOX2X
		ENDIF
		thisform.Procesa_LE_08_02 

		this.TxtEstadoProceso1.Caption	=  'PROCESO TERMINADO' 
		this.TxtEstadoProceso2.Caption	=  '' 
	ENDPROC


	PROCEDURE procesa_le_14_01
		*!*	LsRutaTxtErr4	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorNC.txt'
		=STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         PROCESADO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)

		thisform.Cierra_Temporales 
		this.TxtEstadoProceso1.Caption	=	[GENERANDO ARCHIVO SUNAT - LIBRO VENTAS....!!!] 
		this.TxtEstadoProceso2.Caption	=	[] 
		thisform.TxtEstadoProceso1.Refresh 
		thisform.TxtEstadoProceso2.Refresh 

		*** 0. Variables
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LsAliasPre = 'P_RV'

		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)


		IF THISFORM.ChkValidarInfo.Value = .T.
		 	*** 1. Cargamos Datos del MsAccess a 
			*!*	WAIT WINDOW 'Procesando datos del Registro de ventas en formato MS ACCESS' NOWAIT
		 	THIS.TxtEstadoProceso1.Caption = 'PROCESANDO DATOS PARA GENERAR REGISTRO DE VENTAS - PLE - SUNAT...'
		 	THIS.TxtEstadoProceso2.Caption = 'Extrayendo registros a procesar desde el origen de datos '+UPPER(THIS.CboTpoOriDat.Value )
			thisform.TxtEstadoProceso1.Refresh 
			thisform.TxtEstadoProceso2.Refresh 
			DO CASE 
				CASE UPPER(GsSigCia)='OLTURSA'
					** VETT:PARA OLTURSA COMENZAMOS EN DICIEMBRE 2012 - 2015/04/06 12:07:36 ** 
				 	WITH THISFORM
				 		.Cargar_BD_Origen(.CboTpoOriDat.Value, "{Microsoft Access Driver (*.mdb, *.accdb)}", .TxtRutaOrigenDatos.Value,'Admin','', ;
												'Select * from INFORME_FINAL',Thisform.PleTablaDestino,.T.,'RV') 
					ENDWITH
					THIS.TxtEstadoProceso2.Caption = ''
					thisform.TxtEstadoProceso1.Refresh 
					thisform.TxtEstadoProceso2.Refresh 
					WITH THISFORM
				 		.Cargar_BD_Origen(.CboTpoOriDat.Value, "{Microsoft Access Driver (*.mdb, *.accdb)}", .TxtRutaOrigenDatos.Value,'Admin','', ;
												'Select * from INFORME_CORPORATIVO','RV_CORP',.T.,'VCORP') 
					ENDWITH
					thisform.TxtEstadoProceso1.Refresh 
					thisform.TxtEstadoProceso2.Refresh 

					WITH THISFORM
				 		.Cargar_BD_Origen(.CboTpoOriDat.Value, "{Microsoft Access Driver (*.mdb, *.accdb)}", .TxtRutaOrigenDatos.Value,'Admin','', ;
												'Select * from RUC_AGENCIA','RV_RAGE',.T.,'RAGEN') 
					ENDWITH
					thisform.TxtEstadoProceso1.Refresh 
					thisform.TxtEstadoProceso2.Refresh 

					THIS.TxtEstadoProceso2.Caption = ''
					*** 2. Selecciona Datos
					SELECT (Thisform.PleTablaDestino ) 
					INDEX on T10_CODT10+SERIE+NUMERO TAG Serie
					INDEX ON DTOS(cte_FecEmi) TAG FecEmi
					SET ORDER TO 
					LOCATE

					** 3. Registros repetidos x Tipo Documento + Serie + Numero
					LcVfp1		=	'SELECT  T10_CODT10,Serie,Numero, COUNT(*) as TotItm FROM RegVen GROUP BY T10_CODT10,Serie,Numero HAVING TotItm>1 INTO  CURSOR RegVenRitem  READWRITE order by t10_codt10,Serie,Numero'
					IF .F.
						LcSqlR2	=	'SELECT  t10_codt10,Serie, Numero, COUNT(*) as TotItm FROM LBE_1401_REGVEN_LEV  ' 
						LcSqlR2	= LcSqlR2 + 'WHERE cia_codcia = ?lcodcia  '
						LcSqlR2	= LcSqlR2 + 'and   periodo    = ?lperpco  '
						LcSqlR2	= LcSqlR2 + 'GROUP BY t10_codt10,Serie,Numero ' 
						LcSqlR2	= LcSqlR2 + 'HAVING COUNT(t10_codt10+serie+numero)>1  order by t10_codt10,Serie,Numero'
						thisform.Ocnx_odbc.csql = LcSqlR2
						Thisform.Ocnx_odbc.cCursor = 'RegVenRitem'
						LnControl = thisform.Ocnx_odbc.Dosql()
						IF LnControl<0
							LsMensaje = 'Error al seleccionar datos desde LBE_1401_REGVEN_LEV. Consultar al area de T.I.' + CHR(13)+MESSAGE()
						    RETURN .f.
						ENDIF
					ENDIF
					&LcVfp1.
					LsFileErrRepetidos = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.txtArchivoRepetidos.Value)  


					SELECT REGVEN 
					SET ORDER TO 
					LOCATE

					** 4. Verificar  registros invalidos
					this.TxtEstadoProceso2.Caption	=  'Verificando  registros invalidos' 

					** 4.1 Borramos los registros que tienen el Numero de documento en blanco
					this.TxtEstadoProceso2.Caption	= 'Borramos los registros que tienen el Numero de documento en blanco' 
					SELECT REGVEN
					REPLACE ALL Estado_OPE WITH 'N' FOR EMPTY(Numero) OR  Numero='0'
					LOCATE 
					** 4.2 Ventas x resumen solo se debe capturar el numero de documento empezando por la derecha del 
					**  campo "Numero"    Ejem: 160007/160026 se debe grabar --> Numero='160007' y  Ult_Numero='160026' ; si NOMBRE = 'EXCESOS'
					this.TxtEstadoProceso2.Caption	=  'Ventas x Resumen, capturando ultimo numero ' 
					SELECT REGVEN
					SET FILTER TO nombre='EXCESOS'
					LOCATE
					SCAN 
						LsNumero = Numero
						LnPos=RAT('/',LsNumero)
						IF LnPos>0
							this.TxtEstadoProceso2.Caption	=  'Ventas x Resumen, capturando ultimo numero '+LsNumero 
							REPLACE Numero WITH SUBSTR(LsNumero,1,LnPos-1)
							REPLACE Ult_Numero WITH SUBSTR(LsNumero,LnPos+1)
						ENDIF
					ENDSCAN 
					** 4.3 Duplicados x error de control de correlativo por 2 entidades en Base Datos diferentes
					this.TxtEstadoProceso2.Caption	=  'Duplicados x error de control de correlativo por 2 entidades diferentes ' 

					THIS.Busca_duplicados('REGVEN','RegVenRitem')
					 
					** 4.5 Canjes,  Numero documento incluye la serie ###-####### y documento origen en numero_ref y eliminar el negativo 
					LsArcTmp3= ADDBS(GoEntorno.TmpPath)+SYS(3)
					SELECT REGVEN
					SET ORDER TO SERIE 
					COPY TO (LsArcTmp3) FOR AT('-', Numero) >0  WITH CDX TYPE FOX2X 
					SELECT 0
					USE (LsArcTmp3) ALIAS Canjes
					SCAN 
						LsT_Ref	= 	T10_CODREF
						LsS_Ref	=	SERIE_REF
						LsN_Ref	=	Numero_Ref
						SCATTER memvar
						*** 1ero. neteamos los importes
						SELECT Regven 
						SEEK LsT_Ref+LsS_Ref+LsN_Ref
						IF FOUND()
							REPLACE VAL_EXPORT	 WITH	VAL_EXPORT	+	m.VAL_EXPORT			 
							REPLACE VAL_AFECTO	 WITH	VAL_AFECTO	+	m.VAL_AFECTO
							REPLACE VAL_EXONER WITH 	VAL_EXONER	+	m.VAL_EXONER
							REPLACE VAL_INAFEC   WITH 	VAL_INAFEC	+	m.VAL_INAFEC
							REPLACE IMP_ISC		WITH	IMP_ISC		+	m.IMP_ISC
							REPLACE IMP_IGV		WITH	IMP_IGV		+	m.IMP_IGV
							REPLACE IMP_TOTAL	WITH	IMP_TOTAL		+	m.IMP_TOTAL
						ENDIF
						*** 2do. Borramos el registro del canje
						SEEK m.T10_CODT10+m.SERIE+m.NUMERO
						IF FOUND()
							REPLACE Estado_OPE	WITH 'C'   && Marcamos el registro del canje
						ENDIF

						SELECT Canjes
					ENDSCAN
					*** Actualizamos fecha referencia de N/Creditos buscando en sistemas de Cargo y FICS
					this.TxtEstadoProceso2.Caption	=  'Cargamos Notas de Credito de PASAJES...' 
		*!*				 SET STEP ON
		*!*				LsStringFICS = "driver={SQL Server};server=192.168.1.5;Database=WF_OLTR;uid=sa;pwd=oltursasa;"
					IF .F.
						LsStringFICS	= Thisform.Ocnx_Odbc.cStringCnx2 
						CnFICS= SQLSTRINGCONNECT(LsStringFICS)
						LsQryFICS = "SELECT ComprobanteNumero AS NumeroNC,FechaEmision AS FechaNC, " 
						LsQryFICS = LsQryFICS +  "T1.FechaOperacion AS Fch_Boleto,T2.Numero AS Boleto  From Pasajes_Comprobantes " 
						LsQryFICS = LsQryFICS +  "inner join PasajesOperaciones T1 ON PasajeID = T1.Pasaje inner join Pasajes T2 ON T2.Id = T1.Pasaje "
						LsQryFICS = LsQryFICS +  "WHERE T1.Operacion in ( 0,13 ) AND year(FechaEmision)=?_Ano and month(FechaEmision)=?LnMes order by FechaNC "
				*!*					LsQryFICS = LsQryFICS +  "WHERE  ComprobanteNumero = '"+LsNumeroNC +"'"
						IF CnFICS<0
								MESSAGEBOX('Error de conexion con base de datos FICS '+SUBSTR(LsStringFICS,1,LEN(LsStringFICS)-21)+' '+MESSAGE(),16,'ATENCION')
							LnControlFics  =		CnFICS
						ELSE
							LnControlFics  = SQLEXEC(CnFICS,LsQryFICS,'NCPasajes')
							=SQLDISCONNECT(CnFICS)
							IF LnControlFics<0
								MESSAGEBOX('Error de conexion con base de datos FICS '+SUBSTR(LsStringFICS,1,LEN(LsStringFICS)-21),16,'ATENCION')
							ELSE
								SELECT NCPasajes
								INDEX on NumeroNC TAG Numero
								SET ORDER TO Numero
							ENDIF
						ENDIF
					ENDIF
					Thisform.Tag='Cursor'
					LnControlFics=Thisform.Query_pasajes() 
					Thisform.Tag=''

					*** Cargamos NCredito de CARGO

					this.TxtEstadoProceso2.Caption	=  'Cargamos Notas de Credito de CARGO...' 
		*!*				LsStringCARGO= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=192.168.1.6;PORT=5444;UID=enterprisedb;PWD=admin;]
					IF .F.
						LsStringCARGO=Thisform.Ocnx_Odbc.cStringCnx3 
						CnCARGO= SQLSTRINGCONNECT(LsStringCARGO)
						LsQryCARGO= [Select FA.co_tipoDocumento,FA.nu_seriedocumento, FA.nu_documento, FA.fe_documento,  ] 
						LsQryCARGO  =  LsQryCARGO  + [NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito ] 
						 LsQryCARGO =  LsQryCARGO  + [from "CAR_FACTURA_CA" FA  ] 
						 LsQryCARGO =  LsQryCARGO  + [INNER JOIN "CAR_NOTACREDITO_MA" NC  ] 
						 LsQryCARGO =  LsQryCARGO  + [ ON FA.co_tipoDocumento=NC.co_TipoDocumento AND ] 
						 LsQryCARGO =  LsQryCARGO  + [ FA.nu_seriedocumento = NC.nu_seriedocumento AND FA.nu_documento = NC.nu_documento ] 
					 	 LsQryCARGO =  LsQryCARGO  + [ where to_char(fe_notacredito,'YYYYMM')=']+lperiod+[']
			*!*				 LsQryCARGO =  LsQryCARGO  + [ where nc.Nu_Serie=']+LsSerie+[' AND NC.Nu_Notacredito=']+LsNumero+[' ]
						IF CnCargo<0
							MESSAGEBOX('Error de conexion con base de datos CARGO '+SUBSTR(LsStringCARGO,1,LEN(LsStringCARGO)-27)+' '+MESSAGE(),16,'ATENCION')
							LnControlCargo = CnCargo
						ELSE
							LnControlCargo  = SQLEXEC(CnCARGO,LsQryCARGO,'NCredito')
							=SQLDISCONNECT(CnCARGO)
							IF LnControlCargo<0
								MESSAGEBOX('Error de conexion con base de datos CARGO '+SUBSTR(LsStringCARGO,1,LEN(LsStringCARGO)-27),16,'ATENCION')
							ELSE
								SELECT NCredito
				*!*					INDEX on Nu_Serie+Nu_NotaCredito TAG Numero
								** VETT  18/03/2013 06:16 PM : Para encontrarlos sin importar los ceros que tengan a la izquierda del campo numero 
								INDEX on Nu_Serie+LTRIM(STR(VAL(Nu_NotaCredito))) TAG Numero
								SET ORDER TO Numero
							ENDIF
						ENDIF
					ENDIF
					LLSetStepON=.F.
					LLSetStepON2=.F.
					Thisform.Tag='Cursor'
					LnControlCargo=Thisform.Query_cargo() 
					Thisform.Tag=''
					IF  (LnControlFICS>0 OR LnControlCargo>0)
						this.TxtEstadoProceso2.Caption	=   'Actualizamos fecha referencia de N/Creditos segun datos de sistemas de CARGO y PASAJES ' 
						SELECT REGVEN
						SET FILTER TO 
						SEEK '07'
						SCAN WHILE T10_CODT10='07'	FOR !INLIST(Estado_ope,'B') 
							** Como se cuando es una nota/credito de CARGO o de FICS **
							LsSerie		=	Serie
							IF LEN(TRIM(Serie))=2
								LsSerie = LEFT('0'+TRIM(Serie),3)
							ENDIF
							LsNumero	=	Numero
							LsNumeroNC=PADR(PADR(LsSerie,4)+'-'+TRIM(Numero),20)
		*!*						IF LsSerie='080'
							IF REGVEN.Tipo_venta='CARGO'
								** CARGO
								IF LsSerie='080' AND INLIST(LsNumero,'1008')
			*!*							SET STEP ON 
								ENDIF
								this.TxtEstadoProceso2.Caption	=  'Buscando fecha documento origen de N/C '+  LsNumeroNC +' en CARGO' 
								IF LnControlCargo<0
								ELSE
									IF LLSetStepON2=.T.
										SET STEP ON 
									ENDIF
									SELECT NCredito
									LsLetras	=RTRIM(chrtran( RegVen.serie, "1234567890", "" ))
									LsSerie		=chrtran( RegVen.SERIE, chrtran( RegVen.SERIE, "1234567890", "" ), "" )
									LnLong		=LEN(LsSerie)
									=SEEK(PADR(LsSerie,LEN(NCredito.Nu_Serie))+TRIM(LsNumero))
									IF FOUND() AND VAL(LsSerie) = VAL(Nu_Serie) AND VAL(LsNumero) = VAL(Nu_NotaCredito)
										LdFchRef	=	IIF(VARTYPE(NCredito.fe_documento)='X',CTOD('01/01/1900'),NCredito.fe_documento)
										LdFchRef	=	IIF(VARTYPE(LdFchRef)='T',TTOD(LdFchRef),LdFchRef)
										REPLACE RegVen.FecEmi_Ref WITH LdFchRef
										IF NCredito.ST_NotaCredito='03'
											** Anulada **
										ELSE
											IF VAL(RegVen.T10_CodRef) = 0
												REPLACE  RegVen.T10_CodRef  WITH NCredito.co_tipoDocumento
											ENDIF
											IF VAL(RegVen.Serie_ref) = 0
												REPLACE  RegVen.serie_ref  WITH NCredito.nu_seriedocumento
											ENDIF
											IF VAL(RegVen.Numero_ref) = 0
												REPLACE  RegVen.Numero_ref  WITH LTRIM(STR(NCredito.nu_documento))
											ENDIF
										ENDIF

										this.TxtEstadoProceso2.Caption	=  'Fecha documento origen de N/C '+  LsNumeroNC +' en CARGO --> ' + DTOC(LdFchRef) + ' '+CHR(251)
									ENDIF
								ENDIF
							ELSE
								** PASAJES
								this.TxtEstadoProceso2.Caption	=  'Buscando fecha documento origen de N/C '+  LsNumeroNC +' en PASAJES' 
								IF LsSerie='110' AND LsNumero='1555'
			*!*							SET STEP ON 
								ENDIF

								IF LnControlFics<0 && Si no hay datos en ninguna fecha no debe pasar por aqui
								ELSE
									IF LLSetStepON=.T.
										SET STEP ON 
									ENDIF
									LsNumeroNC=PADR(REGVEN.SERIE,4)+PADR(LTRIM(REGVEN.NUMERO),10) 
									SELECT NCPasajes
									=SEEK(TRIM(LsNumeroNC))
									IF FOUND()
									    LdFchRef1	=	NCPasajes.Fecha_ref 
										LdFchRef	=	ICASE(VARTYPE(LdFchRef1)='X',CTOD('01/01/1900'),VARTYPE(LdFchRef1)='C',CTOD(LdFchRef1),VARTYPE(LdFchRef1)='T',TTOD(LdFchRef1))
										REPLACE RegVen.FecEmi_Ref WITH LdFchRef
										IF  EMPTY(RegVen.Numero_ref) OR (EMPTY(RegVen.Serie_ref) OR RegVen.Serie_ref=='0') ; 
										   OR (EMPTY(REGVEN.T10_CodRef) OR REGVEN.T10_CodRef=='00' ) && OR EMPTY(RegVen.FecEmi_Ref) 
		*!*										LdFchRef	=	IIF(VARTYPE(LdFchRef)='T',TTOD(LdFchRef),LdFchRef)
											IF !ISNULL(NCPasajes.Numero_Ref)
												LnPos = AT('-',NCPasajes.Numero_Ref)
												LnPos = IIF(LnPos=0,3,LnPos)
												IF VAL(RegVen.T10_CodRef) = 0
														REPLACE  RegVen.T10_CodRef  WITH  TRANSFORM(STR(NCPasajes.tref),'@L 99') && '16'   && Boletos
												ENDIF
												IF VAL(RegVen.Serie_ref) = 0
													REPLACE  RegVen.T10_CodRef  WITH SUBSTR(NCPasajes.Numero_Ref,1,LnPos-1)
												ENDIF
												IF VAL(RegVen.Numero_ref) = 0
													REPLACE  RegVen.Numero_ref  WITH  SUBSTR(NCPasajes.Numero_Ref,LnPos+1)
												ENDIF
											ENDIF
											this.TxtEstadoProceso2.Caption	=  'Fecha documento origen de N/C '+  LsNumeroNC +' en PASAJES --> ' + DTOC(LdFchRef) + ' '+CHR(251)
										ENDIF
										this.TxtEstadoProceso2.Caption	=  'Buscando fecha documento origen de N/C '+  LsNumeroNC +' en PASAJES --> ' + DTOC(LdFchRef) 
									ENDIF
								ENDIF

							ENDIF
				*!*				LsQryFICS = LsQryFICS +  "WHERE year(FechaEmision)=2013 and month(FechaEmision)=1 order by FechaNC"
						ENDSCAN
					ENDIF
					** VETT:ULTIMA ACTUALIZACIONES PARA OLTURSA EN OCTUBRE 2014 - 2015/04/06 12:08:42 ** 
				OTHERWISE 
					** VETT:AQUI TIENES QUE VENIR CUANDO SE GENERA EN BASE A .CboTpoOriDat.Value = '(LOCAL)'      -  2015/08/14 13:04:08 ** 
					** VETT:*** CARGAMOS REGISTRO DE VENTAS DE BASE DE DATOS NATIVA DEL SISTEMA CONTABLE O-NEGOCIOS , RECIEN?? ... SI RECIEN...  2015/04/06 12:01:48 ** 
					SELECT 0
				 	WITH THISFORM
				 		.Cargar_BD_Origen(.CboTpoOriDat.Value, "", .TxtRutaOrigenDatos.Value,'Admin','', ;
												'',Thisform.PleTablaDestino,.T.,'RMOV') 
					ENDWITH
					THIS.TxtEstadoProceso2.Caption = ''
					thisform.TxtEstadoProceso1.Refresh 
					thisform.TxtEstadoProceso2.Refresh 

					** 3. Registros repetidos x Tipo Documento + Serie + Numero
					LcVfp1		=	'SELECT  T10_CODT10,Serie,Numero, COUNT(*) as TotItm FROM RegVen GROUP BY T10_CODT10,Serie,Numero HAVING TotItm>1 INTO  CURSOR RegVenRitem  READWRITE order by t10_codt10,Serie,Numero'
					&LcVfp1.
					LsFileErrRepetidos = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.txtArchivoRepetidos.Value)  

					This.Busca_duplicados('REGVEN','RegVenRitem')


			ENDCASE

			** 5. Validamos correlativos y registros repetidos segun serie y numero de documento
			** Error de secuencia de numeros correlativo por serie

			** Temporal para errores de Tipo de documento y Longitud del RUC
			SELECT RegVen
			LsArcTmp4= ADDBS(GoEntorno.TmpPath)+SYS(3)
			COPY TO (LsArcTmp4) FOR 1=0 WITH CDX TYPE FOX2X 
			SELECT 0
			USE  (LsArcTmp4) ALIAS ErrRucDni

			this.TxtEstadoProceso2.Caption	=  'Verificando error de secuencia de correlativos x serie y numero documento' 
			SELECT 0
			CREATE TABLE RegVenCorr FREE (t10_codT10 C(2),Serie C(4), Desde C(20),Hasta C(20))
			SELECT REGVEN 
			SET FILTER TO 
			LOCATE
			SET ORDER TO Serie
			LOCATE
			DO WHILE NOT EOF()
				LsLlave = t10_codT10 + Serie
				IF INLIST(RUC,'20100014395','20479390381','20512780114','20516762111','10078351239','20519330874','20408101701','20502811674','20100027021')
						** Estos ruc estan con roche
		*!*					SET STEP ON 
				ENDIF

				DO  WHILE t10_codT10 + Serie = LsLlave AND !EOF()
					*** Aprovechamos para revisar Anulados y  Marcar los Anulados ***

					IF VAL_EXPORT + VAL_AFECTO + VAL_EXONER + VAL_INAFEC + IMP_ISC + IMP_IVAP + OTROS_TRIB + IMP_TOTAL = 0
						REPLACE Estado_OPE	WITH '2'
						REPLACE FecEmi_Ref	WITH CTOD('01/01/1900')
						IF INLIST(t02_codt02,'6','1')
							REPLACE t02_codt02 WITH '0'
							REPLACE RUC WITH '0'
						ENDIF
						IF t10_codt10='07' && Si la nota de credito esta anulada debe tener referencia en blanco
							replace 	REGVEN.T10_CODREF	WITH '00'
							replace  REGVEN.Serie_ref 		WITH ''
							replace  REGVEN.Numero_ref	WITH ''
						ENDIF
					ENDIF

					IF Estado1='A'
						REPLACE REGVEN.NomBre WITH ' A N U L A D O '
					ENDIF
					*** 
					*** Ahora aprovechamos para verificar los DNI o RUC con error en Tipo de documento ***
					IF t02_codt02='6' AND LEN(TRIM(Ruc))=8
						replace t02_codt02 WITH '1'
						SCATTER MEMVAR 
						m.cte_fecven = NVL(m.cte_fecven ,{})
						INSERT INTO (LsArcTmp4)  FROM MEMVAR
					ENDIF
					IF t02_codt02='1' AND LEN(TRIM(Ruc))=11
						replace t02_codt02 WITH '6'
						SCATTER MEMVAR 
						m.cte_fecven = NVL(m.cte_fecven ,{})
						INSERT INTO (LsArcTmp4) FROM MEMVAR
					ENDIF
					IF INLIST(T10_codt10,'16','01','07') and t02_codt02='0' and  len(TRIM(ruc))=11 
						REPLACE REGVEN.t02_codt02 WITH '6'
					ENDIF

					*** 
					this.TxtEstadoProceso2.Caption	=  'Revisando errores de secuencia en correlativos x serie '+ Serie+ ' '+ Numero 
					LsSerieIni = Serie
					LsNumeroIni = Numero
					SCATTER MEMVAR 
					SKIP
					LsNumeroFin = 	Numero
					LsSerieFin = Serie
					IF LsSerieFin = LsSerieIni AND ABS( VAL(LsNumeroFin)-VAL(LsNumeroIni) ) >1 
						*** Roche con la secuencia del correlativo ***
						SELECT RegVenCorr
						APPEND BLANK 
						GATHER MEMVAR
						replace Desde	WITH LsNumeroIni
						replace Hasta 	WITH LsNumeroFin
						SELECT REGVEN
						*** 
					ENDIF
				ENDDO
			ENDDO
			SELECT RegVenCorr
			LOCATE
			LsFileCorrelativos = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.TxtArchivoCorrelativos.Value ) 
			IF !EOF()
				IF FILE(LsFileCorrelativos)
					DELETE FILE (LsFileCorrelativos)
				ENDIF
				thisform.LblCorrelativos.Caption = TRANSFORM( RECCOUNT(),'999,999')
				COPY TO (LsFileCorrelativos) TYPE XLS 
			ENDIF

			*** Copiamos Archivo con Errores DNI y RUC ***
			IF !USED('ErrRucDni')
				SELECT 0
				USE (LsArcTmp4)  ALIAS ErrRucDni
			ELSE
				SELECT ErrRucDni
				LOCATE 
			ENDIF
			LsFileErrRucDni = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(this.TxtErrorRucDNI.Value ) 
			IF !EOF()
				IF FILE(LsFileErrRucDni)
					DELETE FILE (LsFileErrRucDni)
				ENDIF
				thisform.LblErrorRucDni.Caption = TRANSFORM( RECCOUNT(),'999,999')
				COPY TO (LsFileErrRucDni) TYPE XLS 
			ENDIF

		ELSE
			IF !FILE(ADDBS(goentorno.locpath)+LsAliasLib +Lperiod+'.dbf')
				=MESSAGEBOX('Se debe generar el archivo con los registros validados, ejecute nuevamente con la opción de SI validar información, por lo menos una vez',48,'ATENCION ! ')
				ls_mensaje = 'No se pudo ejecutar por que no se encontro el archivo con los registros procesados del registro de ventas '+Lperiod
				RETURN .F.
			ELSE
				SELECT 0
				USE ADDBS(goentorno.locpath)+LsAliasLib +lPeriod ALIAS RegVen
			ENDIF
		ENDIF
		THISFORM.GenCargadorRV 	= .f.
		IF THISFORM.GenCargadorRV
			THISFORM.GeneraCargadorRV
		ENDIF
		*** 6. Define Nombre de la Tabla SUNAT
		wform   = "Libro_Electronico_RegVent_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'         +  '1'            + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = ADDBS(TRIM(This.TxtUbicacionArchivos.Value)) && curdir()+lruta   
		IF !DIRECTORY(wruta)
			MKDIR (wruta)
		ENDIF
		IF FILE(wruta+wfile)
			DELETE FILE (wruta+wfile)
		ENDIF

		wdriver = fcreate(wruta+wfile)

		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		this.TxtEstadoProceso2.Caption	=  "Generando archivo de texto: "+wruta+wfile 
		LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '
		*** 7. Genera Archivo SUNAT

		LnAsiento = 0
		SELECT REGVEN
		SET ORDER TO
		SET FILTER TO 
		LnTotReg = 0
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9') TO LnTotReg
		LnRegAct = 0
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9')
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
				this.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
			ENDIF
			IF LEN(ALLTRIM(REGVEN.SERIE)) < 4
		       		REPLACE REGVEN.SERIE WITH RIGHT('0000' + ALLTRIM(REGVEN.SERIE),4)
		    	ENDIF
			IF LEN(ALLTRIM(REGVEN.SERIE_REF)) < 4  AND !ALLTRIM(REGVEN.SERIE_REF)=='0'
		       		REPLACE REGVEN.SERIE_REF WITH RIGHT('0000' + ALLTRIM(REGVEN.SERIE_REF),4)
		    	ENDIF
		    
		    	LnAsiento = LnAsiento + 1
		    	LnLonAst	=	7
		*!*		REPLACE RegVen.Asiento WITH RIGHT(REPLICATE('0',LnLonAst)+ALLTRIM(STR(LnAsiento)),LnLonAst)
			** Tipo Cambio **
			=SEEK(DTOS(REGVEN.cte_fecemi),'TCMB')
			** VETT:Verificación de tipo de cambio de venta si esta vacio y no esta anulado 2020/01/22 12:52:37 ** 
			IF FOUND('TCMB') AND RegVen.CTE_TIPCAM<=0 AND  RegVen.Estado1 = "A"
				IF TCMB.OfiVta>0  
					replace RegVen.CTE_TIPCAM WITH TCMB.OfiVta
				ENDIF
			ENDIF
			IF INLIST(RUC,'20100014395','20479390381','20512780114','20516762111','10078351239','20519330874','20408101701','20502811674','20100027021')
					** Estos ruc estan con roche
		*!*				SET STEP ON 
			ENDIF

			IF REGVEN.T10_CODT10=REGVEN.T10_CODREF
				replace 	REGVEN.T10_CODREF	WITH '00'
				replace  REGVEN.Serie_ref 		WITH ''
				replace  REGVEN.Numero_ref	WITH ''
			ENDIF
			IF T10_codt10='03' and t02_codt02='1' and (len(TRIM(ruc))<>8 or TRIM(ruc)=='0')
				REPLACE REGVEN.t02_codt02 WITH '0'
				IF len(TRIM(ruc))<>8
					REPLACE REGVEN.Ruc WITH '0'
				ENDIF
			ENDIF
			IF T10_codt10='03' and t02_codt02='6' and (len(TRIM(ruc))<>11 or TRIM(ruc)=='0')
				REPLACE REGVEN.t02_codt02 WITH '0'
				IF len(TRIM(ruc))<>11
					REPLACE REGVEN.Ruc WITH '0'
				ENDIF
			ENDIF

			IF T10_codt10='12' and t02_codt02='6' and  len(TRIM(ruc))<>11 
				REPLACE REGVEN.t02_codt02 WITH '0'
				REPLACE REGVEN.Ruc WITH '0'
			ENDIF
			IF T10_codt10='12' and t02_codt02='1' and  len(TRIM(ruc))<>8 
				REPLACE REGVEN.t02_codt02 WITH '0'
				REPLACE REGVEN.Ruc WITH '0'
			ENDIF
			IF T10_codt10='16' and t02_codt02='6' and  len(TRIM(ruc))<>11 
				REPLACE REGVEN.t02_codt02 WITH '0'
				REPLACE REGVEN.Ruc WITH '0'
			ENDIF
			IF T10_codt10='16' and t02_codt02='1' and  len(TRIM(ruc))<>8 
				REPLACE REGVEN.t02_codt02 WITH '0'
				REPLACE REGVEN.Ruc WITH '0'
			ENDIF


			this.le_14_01_gen_txt_v5

		    
		    SELECT REGVEN   
		ENDSCAN
		=fclose(wdriver)
		*!*	OPEN DATABASE Interface 
		*!*	IF verifyvar('RegVen','TABLE','INDBC','Interface')
		*!*		DROP TABLE RegVen
		*!*	ENDIF
		*!*	ADD TABLE ADDBS(goentorno.locpath)+'RegVen'
		*!*	CLOSE DATABASES
		IF thisform.ChkValidarInfo.Value = .T.
		*!*		WAIT WINDOW "Haciendo Backup de registros procesados en : "+ADDBS(goentorno.locpath)+LsAliasLib+lperiod+'.dbf' NOWAIT
		*!*		COPY   TO ADDBS(goentorno.locpath)+LsAliasLib+lperiod WITH CDX TYPE FOX2X
		ENDIF
		** VETT  02/08/2018 01:03 PM : Mejor cerramos no hay certeza que usuario saldra inmediatamente despues del mensaje de Proceso Terminado : IDUPD: _59G0RZLST 
		thisform.tools.closetable ('REGVEN')

		this.TxtEstadoProceso1.Caption	=  'PROCESO TERMINADO' 
		this.TxtEstadoProceso2.Caption	=  '' 
	ENDPROC


	PROCEDURE procesa_le_06_01
		WAIT WINDOW "Generando Archivo SUNAT - Libro Mayor Auxiliar....!!!" NOWAIT NOCLEAR 
		thisform.Cierra_Temporales
		*** 1. Variables
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = GsCodSed
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '060100' 

		*** 2. Selecciona Datos
		wcad 	= "Select * 					"
		wcad=wcad+"from LBE_0601_MAYOR_LEM		"
		wcad=wcad+"where cia_codcia = ?lcodcia	"
		wcad=wcad+"and   periodo    = ?lperpco 	"
		wcad=wcad+"order by asiento				"
		IF Sqlexec(ocnx.conexion,wcad,'mayor')<0
			Ocnx.Errormensaje = 'Error al seleccionar datos desde LBE_0601_MAYOR_LEM. Consulte con el Tecnico' + CHR(13)+MESSAGE()
		    RETURN .f.
		ENDIF


		*** 3. Define Nombre de la Tabla SUNAT
		wform   = "Libro_Electronico_Mayor_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'         +  '1'            + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = ADDBS(TRIM(This.TxtUbicacionArchivos.Value)) && curdir()+lruta   
		wdriver = fcreate(wruta+wfile)
		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		WAIT WINDOW "Generando archivo: "+wruta+wfile NOWAIT 

		*** 4. Genera Archivo SUNAT
		SELECT mayor
		GO TOP
		SCAN
			wcad = 	"|"+;
					ALLTRIM(mayor.periodo)				+"|"+;
					ALLTRIM(mayor.asiento)				+"|"+;
					ALLTRIM(mayor.CCT_CODCCT)			+"|"+;
					DTOC(mayor.ACA_FECDIA)				+"|"+;
					ALLTRIM(NVL(mayor.ADE_GLOADE,''))	+"|"+;
					ALLTRIM(STR(mayor.SALDO_DEU,15,2))	+"|"+;
					ALLTRIM(STR(mayor.SALDO_ACR,15,2))	+"|"+;
					ALLTRIM(NVL(mayor.ESTADO_OPE,'1'))	+"|"+;
					SPACE(200)							+"|"
		    =fput(wdriver,wcad)    
		    SELECT mayor
		ENDSCAN
		=fclose(wdriver)
	ENDPROC


	PROCEDURE cargar_bd_origen
		PARAMETERS PsTpoOriDat,PsDriver,PsRutaArchOrigen,PsUser,PsPwd,PsSqlQuery,PsTblDestino,PlFormatDestino,PcModo
		IF VARTYPE(PcModo)<>'C'
			PcModo = ''
		ENDIF
		IF VARTYPE(PlFormatDestino)<>'L'
			PlFormatDestino	=	.F.
		ENDIF
		PsCurOrigen = PsTblDestino
		this.TxtEstadoProceso2.Caption	=	[CARGANDO REGISTROS DEL ORIGEN DE DATOS: ] + UPPER(this.cboTpoOriDat.DisplayValue  )
		DO CASE
			CASE UPPER(PsTpoOriDat) = 'ACCESS'

				** Cargamos BD Ms Access
				thisform.TxtEstadoProceso1.Refresh 
				thisform.TxtEstadoProceso2.Refresh 

				IF PlFormatDestino 
					DO CASE
						CASE PcModo='RV'
							PsCurOrigen =  THIS.PLEAliasPre+THIS.PLEPeriod
						CASE PcModo='VCORP'
					ENDCASE
				ENDIF
				IF EMPTY(PsDriver)
					PsDriver = "{Microsoft Access Driver (*.mdb, *.accdb)}"
				ENDIF
				LsString= "Driver="+PsDriver + ";"
				LsString= LsString + "Dbq="+PsRutaArchOrigen  + ";" && \\192.168.3.11\General\Ventas 2014\05 MAYO 2014\DATA\05 VENTAS.accdb;Uid=Admin;Pwd=;"
				LsString= LsString + "Uid="+PsUser+";"
				LsString= LsString + "Pwd="+PsPwd+";"
				Ln=SQLSTRINGCONNECT(LsString)
				IF LN<0
					=MESSAGEBOX('Error de conexión. Driver:' + PsDriver + ' Dbq: '+PsRutaArchOrigen ,16,'Atención / Warning')
					RETURN
				ENDIF
				*!*	?ln
				*!*	xn=SQLEXEC(Ln,'Select * from INFORME_FINAL',PsCurDestino)
				xn=SQLEXEC(Ln,PsSqlQuery,PsCurOrigen)
				IF XN<0
					=MESSAGEBOX('Error al ejecutar consulta (query) a base de datos. '+ ' Dbq: '+PsRutaArchOrigen ,16,'Atención / Warning')
					RETURN .F.
				ENDIF
		*!*			SET STEP ON 
				thisform.TxtEstadoProceso1.Refresh 
				thisform.TxtEstadoProceso2.Refresh 
				IF PlFormatDestino 
					Thisform.FormatCursorDestino(PsCurOrigen,PsTblDestino,PcModo)
				ENDIF
			CASE UPPER(PsTpoOriDat) = 'SQLSRV '
				wcad 	= "Select * 					"
				wcad=wcad+"from LBE_1401_REGVEN_LEV	"
				wcad=wcad+"where cia_codcia = ?lcodcia	"
				wcad=wcad+"and   periodo    = ?lperpco 	"
				wcad=wcad+"order by cte_fecemi		"
				thisform.Ocnx_odbc.csql = wcad
				Thisform.Ocnx_odbc.cCursor = PsTblDestino
				LnControl = thisform.Ocnx_odbc.Dosql()
				IF LnControl<0
					LsMensaje = 'Error al seleccionar datos desde LBE_1401_REGVEN_LEV. Consultar al area de T.I.' + CHR(13)+MESSAGE()
				    RETURN .f.
				ENDIF
			CASE UPPER(PsTpoOriDat) = '(LOCAL)'
				DO CASE 
					CASE goentPub.cdefaultbackendconecct='VFPDBC'

						SELECT 0
						IF !USED('RMOV')
							Thisform.oData.AbrirTabla('ABRIR','CBDRMOVM','RMOV','RMOV01','','','',STR(_ANO,4,0))
						ENDIF
						IF !USED('VMOV')
							Thisform.oData.AbrirTabla('ABRIR','CBDVMOVM','VMOV','VMOV01','','','',STR(_ANO,4,0))
						ENDIF
						LsNroMes=SUBSTR(This.Pleperiod ,5,2)
						LsCodOpe	= TRIM(THIS.PlECodOpe) 
						PsCurOrigen = 'TEMPORAL'
		*!*					GoSvrcbd.Odatadm.gencursor(PsCurOrigen,"RMOV",'RMOV01',[NroMes+CodOpe],LsNroMes+LsCodOpe,'','')

						IF PlFormatDestino 
							Thisform.FormatCursorDestino(PsCurOrigen,PsTblDestino,PcModo)
						ENDIF

				ENDCASE 
			OTHERWISE 

		ENDCASE

		*!*	?_tally
		*!*	?RECCOUNT()

		** Cargamos BD Notas de Credito  ** 
		**	 FICS
		**LsString= "Driver={Enterprise };Dbq=D:\o-negocios\Oltursa\local\01 VENTAS.accdb;Uid=Admin;Pwd=;"

		*!*	LsString= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=192.168.1.6;PORT=5444;UID=enterprisedb;PWD=admin;]
		*!*	*!*	LsString= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=LOCALHOST;PORT=5444;UID=enterprisedb;PWD=admin;]
		*!*	Ln=SQLSTRINGCONNECT(LsString)
		*!*	?ln
		*!*	xn=SQLEXEC(Ln,'Select * from "CAR_NOTACREDITO_MA"','NCCargo')
		*!*	?_tally
		*!*	?RECCOUNT()
	ENDPROC


	PROCEDURE periodolibro
		PARAMETERS Pslibro
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod =  STR(_ANO,4,0)+PADR(This.CboMes.value,2) && GoEntorno.GsPeriodo
		lperpco = lperiod + '00'
		lruccia = GsRucCia
		lruta   = ADDBS(TRIM(This.TxtUbicacionArchivos.Value)) &&"LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  =  PsLibro && '140100' 
		LsNomLib = ''
		LsAliasLib =''
		LsAliasPre = ''
		LsTblDest = ''
		LsCodOPe  = ''
		DO CASE
			CASE PsLibro = '140100' 
				LsNomLib= 'RegVen-'
				LsAliasLib = 'RV'
				LsAliasPre = 'P_RV'
				LsTblDest = 'REGVEN'
				LsCodOpe=	GSREGIRV
			CASE PsLibro = '080100' 
			 	LsNomLib= 'RegCmp-'
			 	LsAliasLib = 'RC'
			 	LsAliasPre = 'P_RC'
			 	LsTblDest = 'REGCOM'
			 	LsCodOpe=	GSREGIRC
			CASE PsLibro = '080200' 
			 	LsNomLib= 'RegCmp-'
			 	LsAliasLib = 'RCND'
			 	LsAliasPre = 'P_RCND'
			 	LsTblDest = 'REGCOMND'
			 	LsCodOpe=	GSREGIRC
			CASE PsLibro = '050100' 
				LsNomLib= 'LibDia-'
				LsAliasLib = 'LD'
				LsAliasPre = 'P_LD'
			 	LsTblDest = 'REGDIA'
			CASE PsLibro = '060100' 
				LsNomLib= 'LibMay-'
				LsAliasLib = 'LM'
				LsAliasPre = 'P_LM'
			 	LsTblDest = 'REGMAY'
			 
		ENDCASE
		This.PLELibro		=	PsLibro
		This.PLECodcia		=	lCodcia
		This.PLECodSuc		=	lCodSuc
		This.PLEPeriod 		=	lPeriod
		This.PLEPerPco		=	lPerPco
		This.PLERuta 		=	lRuta
		This.PLERuccia 		=	lRucCia
		This.PLEAliaslib 	=	LsAliasLib
		This.PLEAliasPre 	=	LsAliasPre
		This.PLETablaDestino = 	LsTblDest
		This.PLECodOpe		=	LsCodOpe

		This.TxtArchivoCorrelativos.Value = LsNomLib+LEFT(Mes(VAL(This.CboMes.value),1),3)+STR(_ANO,4,0)+'-Err-Correlativo'
		This.TxtArchivoRepetidos.Value	=  LsNomLib+LEFT(Mes(VAL(This.Cbomes.value),1),3)+STR(_ANO,4,0)+'-Duplicados'
		Thisform.TxtErrorRucDNI.Value	=  LsNomLib+LEFT(Mes(VAL(This.Cbomes.value),1),3)+STR(_ANO,4,0)+'-Err-RucDni'
		This.TxtRutaArchivoPLETXT.Value   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'         +  '1'            + '1'    +  '1'         + '.TXT' 

		THIS.TxtFchDocD.Value  = CTOD('01/'+STR(VAL(This.CboMes.value),2,0)+'/'+STR(_ANO,4,0))
		** VETT  08/01/2016 04:50 PM : Determinamos la fecha hasta (Fecha fin de mes ) 
		LdGdFecha = GdFecha
		*!*	IF VAL(This.CboMes.value)<>MONTH(DATE())
		        IF VAL(This.CboMes.value) < 12
		           LdGdFecha=CTOD("01/"+STR(VAL(This.CboMes.value) +1,2,0)+"/"+STR(_ANO,4,0))-1
		        ELSE
		           LdGdFecha=CTOD("31/12/"+STR(_ANO,4,0))
		        ENDIF
		*!*	    ELSE
		*!*	    	LdGdFecha = DATE()
		*!*	ENDIF    
		** VETT  08/01/2016 04:51 PM : FIN: Determinar fecha fin de mes 
		THIS.TxtFchDocH.Value = IIF(VARTYPE(LdGdFecha)='T',TTOD(LdGdFecha),IIF(VARTYPE(LdGdFecha)='D',LdGdFecha,DATE()))
	ENDPROC


	PROCEDURE reproceso_txt_ple
		PARAMETERS LcRutaTxtPle,LcRutaFileVMOV

		IF USED('REGVEN') 
			USE IN 'REGVEN'
		ENDIF
		this.TxtEstadoProceso1.Caption = 'REPROCESANDO ARCHIVO DE TEXTO PLE - SUNAT '
		this.TxtEstadoProceso2.Caption = 'Cargando archivo de texto PLE....'
		*!*	APPEND FROM (LcRutaTxtPle) TYPE DELIMITED WITH CHARACTER ','
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + 'I_RV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')

		ENDIF

		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LnMes=VAL(thisform.CboMes.Value )


		IF Thisform.ChkRegenera_I_RV.Value 
		 
			IF !FILE(LcRutaFileVMOV)
				SELECT 0
				CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
							      PERIODO C(8), ;
							      ASIENTO  C(15), ;
							      NROITM    C(10), ;
							      CTE_FECEMI    D, ;
							      CTE_FECVEN   D, ;
							      T10_CODT10 C(2),  ;
							      SERIE	 C(15), ;
							      NUMERO C(10), ;
							      ULT_NUMERO C(10), ;
							      T02_CODT02 C(1), ;
							      RUC C(11), ;
							      NOMBRE C(30), ;
							      VAL_EXPORT N(15,2), ;
							      VAL_AFECTO N(15,2), ;
							      VAL_EXONER N(15,2), ;
							      VAL_INAFEC   N(15,2) , ;
							      IMP_ISC N(15,2),  ;
							      IMP_IGV N(15,2) ,  ;
							      BASIMP_IVA N(15,2), ;
							      IMP_IVAP N(15,2) , ;
							      OTROS_TRIB N(15,2), ;
							      IMP_TOTAL N(15,2), ;
							      CTE_TIPCAM	 N(7,3) ,;
							      FECEMI_REF D,;
							      T10_CODREF C(4), ;
							      SERIE_REF C(4),;
							      NUMERO_REF C(10),;
							      VALOR_FOB N(15,2),;
							      ESTADO_OPE C(1)  )
							      
			     USE	(LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE														      
				INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
				INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
												      
			ELSE
				SELECT 0
				USE (LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE

				ZAP
			ENDIF
			APPEND FROM (LcRutaTxtPle) TYPE DELIMITED WITH CHARACTER '|'
			LOCATE
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO


			THIS.TXtEstadoProceso2.Caption = 'Cargando archivo de texto PLE....' 
			 

			THIS.TXtEstadoProceso2.Caption =  'Cargamos Notas de Credito de FICS...' 
			 
			*!*				LsStringFICS = "driver={SQL Server};server=192.168.1.5;Database=WF_OLTR;uid=sa;pwd=oltursasa;"
			LsStringFICS	= Thisform.Ocnx_Odbc.cStringCnx2 
			CnFICS= SQLSTRINGCONNECT(LsStringFICS)
			LsQryFICS = "SELECT ComprobanteNumero AS NumeroNC,FechaEmision AS FechaNC, " 
			LsQryFICS = LsQryFICS +  "T1.FechaOperacion AS Fch_Boleto,T2.Numero AS Boleto  From Pasajes_Comprobantes " 
			LsQryFICS = LsQryFICS +  "inner join PasajesOperaciones T1 ON PasajeID = T1.Id inner join Pasajes T2 ON T2.Id = T1.Id "
			LsQryFICS = LsQryFICS +  "WHERE year(FechaEmision)=?_Ano and month(FechaEmision)=?LnMes order by FechaNC"
			*!*					LsQryFICS = LsQryFICS +  "WHERE  ComprobanteNumero = '"+LsNumeroNC +"'"
			LnControlFics  = SQLEXEC(CnFICS,LsQryFICS,'NCPasajes')
			=SQLDISCONNECT(CnFICS)
			IF LnControlFics<0
				MESSAGEBOX('Error de conexion con base de datos FICS '+SUBSTR(LsStringFICS,1,LEN(LsStringFICS)-21),16,'ATENCION')
			ELSE
				SELECT NCPasajes
				INDEX on NumeroNC TAG Numero
				SET ORDER TO Numero
			ENDIF

			*** Cargamos NCredito de CARGO

			THIS.TXtEstadoProceso2.Caption =  'Cargamos Notas de Credito de CARGO...' 
			*!*				LsStringCARGO= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=192.168.1.6;PORT=5444;UID=enterprisedb;PWD=admin;]
			LsStringCARGO=Thisform.Ocnx_Odbc.cStringCnx3 
			CnCARGO= SQLSTRINGCONNECT(LsStringCARGO)
			LsQryCARGO= [Select FA.co_tipoDocumento,FA.nu_seriedocumento, FA.nu_documento, FA.fe_documento,  ] 
			LsQryCARGO  =  LsQryCARGO  + [NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito ] 
			 LsQryCARGO =  LsQryCARGO  + [from "CAR_FACTURA_CA" FA  ] 
			 LsQryCARGO =  LsQryCARGO  + [INNER JOIN "CAR_NOTACREDITO_MA" NC  ] 
			 LsQryCARGO =  LsQryCARGO  + [ ON FA.co_tipoDocumento=NC.co_TipoDocumento AND ] 
			 LsQryCARGO =  LsQryCARGO  + [ FA.nu_seriedocumento = NC.nu_seriedocumento AND FA.nu_documento = NC.nu_documento ] 
			 LsQryCARGO =  LsQryCARGO  + [ where to_char(fe_notacredito,'YYYYMM')=']+lperiod+[']
			*!*				 LsQryCARGO =  LsQryCARGO  + [ where nc.Nu_Serie=']+LsSerie+[' AND NC.Nu_Notacredito=']+LsNumero+[' ]
			LnControlCargo  = SQLEXEC(CnCARGO,LsQryCARGO,'NCredito')
			=SQLDISCONNECT(CnCARGO)
			IF LnControlCargo<0
				MESSAGEBOX('Error de conexion con base de datos CARGO '+SUBSTR(LsStringCARGO,1,LEN(LsStringCARGO)-27),16,'ATENCION')
			ELSE
				SELECT NCredito
			*!*					INDEX on Nu_Serie+Nu_NotaCredito TAG Numero
				** VETT  18/03/2013 06:16 PM : Para encontrarlos sin importar los ceros que tengan a la izquierda del campo numero 
				INDEX on Nu_Serie+LTRIM(STR(VAL(Nu_NotaCredito))) TAG Numero
				SET ORDER TO Numero
			ENDIF

			SELECT 0
			USE  ADDBS(Goentorno.LocPath) +'RV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99') ALIAS VTACC
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO

			THIS.TXtEstadoProceso2.Caption =   'Actualizamos fecha referencia de N/Creditos segun datos de sistemas de CARGO y FICS ' 
			SELECT REGVEN
			SET FILTER TO 
			SEEK '07'
			SCAN WHILE T10_CODT10='07'	&& FOR !INLIST(Estado_ope,'B')
				** Como se cuando es una nota/credito de CARGO o de FICS **
				TsSerie		= 	RIGHT(Serie,4)
				LsSerie		=	TsSerie && Serie
				IF LEN(TRIM(TsSerie))=2
					LsSerie = LEFT('0'+TRIM(TsSerie),3)
				ENDIF
				LsNumero	=	Numero
				LsNumeroNC=PADR(PADR(LsSerie,4)+'-'+TRIM(Numero),20)

						IF REGVEN.Serie=='0080'	&& Serie de N/C de Cargo
						ELSE
							&& Buscamos en el access
							LsSerie		= REGVEN.Serie
							LsNumero	= REGVEN.Numero
							SELECT VTACC
			*!*					SEEK REGVEN.T10_CODT10+PADR(LsSerie,LEN(VTACC.SERI))+TRIM(LsNumero)
							SEEK REGVEN.T10_CODT10+PADR(LsSerie,LEN(VTACC.SERIE))+TRIM(LsNumero)
							IF FOUND()
			*!*						LnPos = AT('-',VTACC.NDO2)
			*!*						LnPos = IIF(LnPos=0,4,LnPos)

								IF VAL(RegVen.T10_CodRef) = 0
									REPLACE  RegVen.T10_CodRef  WITH '16'
								ENDIF
								IF VAL(RegVen.Serie_ref) = 0
									REPLACE  RegVen.Serie_ref  WITH VTACC.Serie_ref  &&SUBSTR(VTACC.NDO2,1,LnPos-1)
								ENDIF
								IF VAL(RegVen.Numero_ref) = 0
									REPLACE  RegVen.Numero_ref  WITH  VTACC.Numero_ref && SUBSTR(VTACC.NDO2,LnPos+1)
								ENDIF
								IF EMPTY(RegVen.FecEmi_Ref)	OR DTOC(RegVen.Fecemi_Ref)='01/01/0001'
									REPLACE RegVen.FecEmi_Ref WITH  IIF(EMPTY(VTACC.FecEmi_Ref) OR INLIST(DTOC(VTACC.Fecemi_Ref),'01/01/0001','01/01/1900'),VTACC.Cte_FecEmi,VTACC.FecEmi_Ref)  &&VTACC.FEMI
								ENDIF
							ENDIF
						ENDIF
			*!*			ENDIF

			*!*		ENDIF
			*!*				LsQryFICS = LsQryFICS +  "WHERE year(FechaEmision)=2013 and month(FechaEmision)=1 order by FechaNC"
			ENDSCAN
		ELSE

			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS REGVEN 
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO 
		ENDIF
		*** Volvemos a convertirlo en archivo de texto PLE ***
		THIS.TXtEstadoProceso2.Caption = 'REGENERANDO EL ARCHIVO DE TEXTO PLE - SUNAT ...'
		SELECT REGVEN
		LOCATE

		wform   = "Libro_Electronico_RegVent_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '0'         +  '1'            + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = curdir()+lruta   
		IF !DIRECTORY(wruta)
			MKDIR (wruta)
		ENDIF
		IF FILE(wruta+wfile)
			DELETE FILE (wruta+wfile)
		ENDIF

		wdriver = fcreate(wruta+wfile)

		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		THIS.TXtEstadoProceso2.Caption = "Re - Generando archivo de texto: "+wruta+wfile 
		LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '
		*** 7. Genera Archivo SUNAT

		LnAsiento = 0
		SELECT REGVEN
		SET ORDER TO
		SET FILTER TO 
		LnTotReg = 0
		*!*	COUNT FOR INLIST(Estado_OPE,'1','2','8','9') TO LnTotReg
		COUNT  TO LnTotReg
		LnRegAct = 0
		LOCATE
		SCAN &&FOR INLIST(Estado_OPE,'1','2','8','9')
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
				THIS.TXtEstadoProceso2.Caption = LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
			ENDIF


		*!*		LsFecha = IIF(ISNULL(REGVEN.cte_fecven),NVL(REGVEN.cte_fecven, ' '),IIF(EMPTY(REGVEN.cte_fecven),' ',DTOC(REGVEN.cte_fecven) ))
			wcad = ALLTRIM(REGVEN.periodo)				+"|"
			** CUO Codigo unico de operación e.g. Operacion contable, libro contable, sub-diario , paquete
			wcad = wcad + ALLTRIM(ASIENTO)		+"|"
			wcad = wcad + NROITM		+"|"
			wcad = wcad + DTOC(REGVEN.cte_fecemi)		+"|"
			wcad = wcad + DTOC(REGVEN.cte_fecven)		+"|"
			wcad = wcad + RIGHT('0'+ALLTRIM(REGVEN.T10_CODT10),2)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NUMERO)		+"|"
			wcad = wcad + ALLTRIM(REGVEN.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXPORT,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFECTO,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXONER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_INAFEC,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ISC,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.BASIMP_IVA,15,2)) +"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IVAP,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.OTROS_TRIB,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_TOTAL,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.CTE_TIPCAM,7,3))	+"|"
			wcad = wcad + DTOC(REGVEN.FECEMI_REF) +"|"
			wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODREF),2)	+"|"
			wcad = wcad + IIF(empty(serie_ref) or TRIM(serie_ref)=='0' or VAL(serie_ref)=0,'-',ALLTRIM(REGVEN.SERIE_REF))		+"|"
			wcad = wcad + IIF(empty(numero_ref) or TRIM(numero_ref)='0','-',ALLTRIM(REGVEN.NUMERO_REF))	+"|"
			** Valor FOB
			wcad = wcad +  "|"
			wcad = wcad + ALLTRIM(NVL(REGVEN.ESTADO_OPE,'1')) + "|"
			** Campo libre utilizacion , si esta en blanco , no concaternar nada 


		    =fput(wdriver,wcad)    
		    SELECT REGVEN   
		ENDSCAN
		=fclose(wdriver)

		THIS.TXtEstadoProceso1.Caption =		'PROCESO TERMINADO' 
		THIS.TXtEstadoProceso2.Caption = 	'' 
	ENDPROC


	*-- Reposiciona columnas segun archivo de texto presentado en un periodo anterior. Utilizado para subsanar error de Exactus.
	PROCEDURE reproceso_txt_ple_2
		PARAMETERS LcRutaTxtPle,LcRutaFileVMOV

		IF USED('REGVEN') 
			USE IN 'REGVEN'
		ENDIF
		this.TxtEstadoProceso1.Caption = 'REPROCESANDO ARCHIVO DE TEXTO PLE - SUNAT  - ANULADOS MESES ANTERIORES 2015'
		this.TxtEstadoProceso2.Caption = 'Cargando archivo de texto PLE....'
		*!*	APPEND FROM (LcRutaTxtPle) TYPE DELIMITED WITH CHARACTER ','
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + 'A_RV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')

		ENDIF

		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LnMes=VAL(thisform.CboMes.Value )


		IF Thisform.ChkRegenera_I_RV.Value 
		 
			IF !FILE(LcRutaFileVMOV)
				SELECT 0
				CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
							      PERIODO C(8), ;
							      ASIENTO  C(40), ;
							      NROITM    C(20), ;
							      CTE_FECEMI    D, ;
							      CTE_FECVEN   D, ;
							      T10_CODT10 C(2),  ;
							      SERIE	 C(15), ;
							      NUMERO C(10), ;
							      ULT_NUMERO C(10), ;
							      T02_CODT02 C(1), ;
							      RUC C(11), ;
							      NOMBRE C(30), ;
							      VAL_EXPORT N(15,2), ;
							      VAL_AFECTO N(15,2), ;
							      VAL_EXONER N(15,2), ;
							      VAL_INAFEC   N(15,2) , ;
							      IMP_ISC N(15,2),  ;
							      IMP_IGV N(15,2) ,  ;
							      BASIMP_IVA N(15,2), ;
							      IMP_IVAP N(15,2) , ;
							      OTROS_TRIB N(15,2), ;
							      IMP_TOTAL N(15,2), ;
							      CTE_TIPCAM	 N(7,3) ,;
							      FECEMI_REF D,;
							      T10_CODREF C(4), ;
							      SERIE_REF C(4),;
							      NUMERO_REF C(10),;
							      VALOR_FOB N(15,2),;
							      ESTADO_OPE C(1)  )
							      
			     USE	(LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE														      
				INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
				INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
				INDEX ON ESTADO_OPE  TAG ESTADO
			ELSE
				SELECT 0
				USE (LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE

				ZAP
			ENDIF
			APPEND FROM (LcRutaTxtPle) TYPE DELIMITED WITH CHARACTER '|'
			LOCATE
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO
			THIS.TXtEstadoProceso2.Caption = 'Cargando archivo de texto PLE....' 
			 

			THIS.TXtEstadoProceso2.Caption =  '' 
		 

			SELECT 0
			USE  ADDBS(Goentorno.LocPath) +'RV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99') ALIAS VTACC
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO
			LnTotReg = 0
			LnRegAct = 0
			THIS.TXtEstadoProceso2.Caption =   'Actualizando documentos anulados de meses anteriores con fecha documento de origen.' 
			SELECT REGVEN
			SET FILTER TO  
			LnTotReg = RECCOUNT()
			LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
			** VETT  09/01/2016 01:17 PM :  COMENTAR 2 LINEAS SIGUIENTES DESPUES DE PROBAR
		*!*		SET FILTER TO  'VETT'$NOMBRE
		*!*		LOCATE

			SCAN 
				LnRegAct = LnRegAct + 1
				IF LnTotReg>0
		*!*				WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
					THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
				ENDIF

				IF Estado_Ope='2'

					LsSerie		= REGVEN.Serie
					LsNumero	= REGVEN.Numero
					SELECT VTACC	  && REGISTRO DE VENTAS DEL MES DE PROCESO
					SEEK REGVEN.T10_CODT10+PADR(LsSerie,LEN(VTACC.SERIE))+TRIM(LsNumero)
					IF FOUND()
						** PERTENECE AL MES DE PROCESO 
					ELSE
						** PERTENECE A OTRO MES LO BUSCAMOS EN LOS REGISTRO DE VENTAS DE MESES ANTERIORES
						FOR TnMes = 1 TO 11
							SELECT 0
							USE  ADDBS(Goentorno.LocPath) +'RV'+STR(_ANO,4,0)+TRANSFORM(TnMes,'@L 99') ALIAS RVANT
							SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO
							SEEK REGVEN.T10_CODT10+PADR(LsSerie,LEN(VTACC.SERIE))+TRIM(LsNumero)
							IF FOUND()
								REPLACE CTE_FECEMI WITH RVANT.CTE_FECEMI IN REGVEN
								REPLACE Estado_Ope WITH '8' IN REGVEN
								REPLACE PERIODO	WITH STR(_ANO,4,0)+TRANSFORM(MONTH(RVANT.CTE_FECEMI),'@L 99')+'00' IN REGVEN
								EXIT
							ENDIF
		*!*						LnPos = AT('-',VTACC.NDO2)
		*!*						LnPos = IIF(LnPos=0,4,LnPos)
							IF USED('RVANT')
								USE IN RVANT
							ENDIF
						ENDFOR
						IF USED('RVANT')
							USE IN RVANT
						ENDIF
					ENDIF
				ENDIF
				SELECT REGVEN
			ENDSCAN
		ELSE

			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS REGVEN 
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO 
		ENDIF
		*** Volvemos a convertirlo en archivo de texto PLE ***
		THIS.TXtEstadoProceso2.Caption = 'REGENERANDO EL ARCHIVO DE TEXTO PLE - SUNAT ...'
		SELECT REGVEN
		LOCATE

		wform   = "Libro_Electronico_RegVent_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '0'         +  '1'            + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = curdir()+lruta   
		IF !DIRECTORY(wruta)
			MKDIR (wruta)
		ENDIF
		IF FILE(wruta+wfile)
			DELETE FILE (wruta+wfile)
		ENDIF

		wdriver = fcreate(wruta+wfile)

		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		THIS.TXtEstadoProceso2.Caption = "Re - Generando archivo de texto: "+wruta+wfile 
		LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '
		*** 7. Genera Archivo SUNAT

		LnAsiento = 0
		SELECT REGVEN
		SET ORDER TO
		SET FILTER TO 
		LnTotReg = 0
		*!*	COUNT FOR INLIST(Estado_OPE,'1','2','8','9') TO LnTotReg
		COUNT  TO LnTotReg
		LnRegAct = 0
		LOCATE
		SCAN &&FOR INLIST(Estado_OPE,'1','2','8','9')
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
				THIS.TXtEstadoProceso2.Caption = LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
			ENDIF


		*!*		LsFecha = IIF(ISNULL(REGVEN.cte_fecven),NVL(REGVEN.cte_fecven, ' '),IIF(EMPTY(REGVEN.cte_fecven),' ',DTOC(REGVEN.cte_fecven) ))
			wcad = ALLTRIM(REGVEN.periodo)				+"|"
			** CUO Codigo unico de operación e.g. Operacion contable, libro contable, sub-diario , paquete
			wcad = wcad + ALLTRIM(ASIENTO)		+"|"
			wcad = wcad + ALLTRIM(NROITM)		+"|"
			wcad = wcad + DTOC(REGVEN.cte_fecemi)		+"|"
			wcad = wcad + DTOC(REGVEN.cte_fecven)		+"|"
			wcad = wcad + RIGHT('0'+ALLTRIM(REGVEN.T10_CODT10),2)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NUMERO)		+"|"
			wcad = wcad + ALLTRIM(REGVEN.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXPORT,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFECTO,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXONER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_INAFEC,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ISC,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.BASIMP_IVA,15,2)) +"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IVAP,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.OTROS_TRIB,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_TOTAL,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.CTE_TIPCAM,7,3))	+"|"
			wcad = wcad + DTOC(REGVEN.FECEMI_REF) +"|"
			wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODREF),2)	+"|"
			wcad = wcad + IIF(empty(serie_ref) or TRIM(serie_ref)=='0' or VAL(serie_ref)=0,'-',ALLTRIM(REGVEN.SERIE_REF))		+"|"
			wcad = wcad + IIF(empty(numero_ref) or TRIM(numero_ref)='0','-',ALLTRIM(REGVEN.NUMERO_REF))	+"|"
			** Valor FOB
			wcad = wcad +  "|"
			wcad = wcad + ALLTRIM(NVL(REGVEN.ESTADO_OPE,'1')) + "|"
			** Campo libre utilizacion , si esta en blanco , no concaternar nada 


		    =fput(wdriver,wcad)    
		    SELECT REGVEN   
		ENDSCAN
		=fclose(wdriver)

		THIS.TXtEstadoProceso1.Caption =		'PROCESO TERMINADO' 
		THIS.TXtEstadoProceso2.Caption = 	'' 
	ENDPROC


	PROCEDURE cargar_bd_sqlserv1
		 SiFunciona = .F.
		IF SiFunciona
		 	WAIT WINDOW 'Cargando datos Registro de ventas en ACCESS hacia el SQL SERVER ' NOWAIT
			*wcad 	= "EXEC [bd_interfases].[dbo].[ImportDB_Access_2_SqlServer]"

			TEXT TO  wcad TEXTMERGE NOSHOW 
						IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_VENTAS_042014]') AND type in (N'U'))
					DROP TABLE [dbo].[DATA_VENTAS_042014]

					 SELECT * INTO  dbo.DATA_VENTAS_042014 FROM
					OPENROWSET('Microsoft.ACE.OLEDB.12.0',
						  '\\192.168.3.11\General\Ventas 2014\04 ABRIL 2014\DATA\04 VENTAS.accdb';
						  'admin';'',Informe_final);
					                                                    
					delete from dbo.MA_AUXILIAR_VENTAS where YEAR(femi)=2014 and MONTH(femi)=4

					insert into dbo.MA_AUXILIAR_VENTAS
					( PERIODO, LOCA, FEMI, TIDO, TIKE, SERI, NDOC, TCOM, NRUC, RASO, ENCO,OTIN, 
					  PASA,EXCE,IGV, TOTA, TOGE, TID2, NDO2, LOC2,DELO,DETA,OTRO,BOLE,EMBA)
					   (
					  Select '201404' AS PERIODO
							,SUBSTRING([LOCA],1,60) 
							,[FEMI] 
							,[TIDO]
							,SUBSTRING([TIKE],1,30) 
							,SUBSTRING([SERI],1,10) 
							,SUBSTRING([NDOC],1,20) 
							,[TCOM]
							,SUBSTRING([NRUC],1,11)
							,SUBSTRING([RASO],1,60)
							,[ENCO]
							,[OTIN]
							,[PASA]
							,[EXCE]
							,[IGV]
							,[TOTA]
							,[TOGE]
							,[TID2]
							,SUBSTRING([NDO2],1,20)
							,SUBSTRING([LOC2],1,10)
							,SUBSTRING([DELO],1,60)
							,SUBSTRING([DETA],1,10)
							,SUBSTRING([OTRO],1,10)
							,[BOLE]
							,[EMBA]
						FROM dbo.DATA_VENTAS_042014 
						where ( YEAR(femi)=2014 and MONTH(femi)=4 )
						)    

			ENDTEXT

			TEXT TO  wcad2 TEXTMERGE NOSHOW 
					DECLARE	@return_valor04 int

					EXEC	@return_valor04 = [bd_interfases].[dbo].[PA_GENERA_LIBRO_ELECTRONICO_14_01_V1_2]
							@p_codcia = N'01',
							@p_codsuc = N'01',
							@p_codano = N'2014',
							@p_codmes = N'04'

			ENDTEXT
		*!*		wcad=wcad+" @p_codcia = ?lcodcia  ,"
		*!*		wcad=wcad+"@p_codsuc = ?lcodsuc ,"
		*!*		wcad=wcad+"@p_codano = ?LsAno , "
		*!*		wcad=wcad+"@p_codmes = ?LsMes "
			LnControl1 = 0
			thisform.Ocnx_odbc.csql = wcad
			Thisform.Ocnx_odbc.cCursor = ''
			LnControl1 = thisform.Ocnx_odbc.Dosql()
			IF LnControl1<0
				SET STEP ON 
				LsMensaje = 'Error al cargar datos desde base de datos Ms-Acccess. Consultar al area de T.I.' + CHR(13)+MESSAGE()
			    RETURN .f.
			ENDIF
			thisform.Ocnx_odbc.csql = wcad2
			Thisform.Ocnx_odbc.cCursor = ''
			LnControl1 = thisform.Ocnx_odbc.Dosql()
			IF LnControl1<0
				SET STEP ON 
				LsMensaje = 'Error al cargar datos desde base de datos Ms-Acccess. Consultar al area de T.I.' + CHR(13)+MESSAGE()
			    RETURN .f.
			ENDIF
		ENDIF
	ENDPROC


	*-- Formateamos los campos del cursor destino para que se ajuste a la estructura de datos necesaria.
	PROCEDURE formatcursordestino
		PARAMETERS PsCurOrigen,PsTblDestino,PcModo
		IF VARTYPE(PcModo)<>'C'
			PcModo = ''
		ENDIF

		DO CASE 
			CASE PcModo='RV'
				LsRutaFileAcc=ADDBS(Goentorno.LocPath) + 'RV'+'AC'+This.PLEPeriod  && STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
				IF FILE(LsRutaFileAcc+'.dbf')
					DELETE FILE LsRutaFileAcc+'.dbf'
					DELETE FILE LsRutaFileAcc+'.fpt'
					DELETE FILE LsRutaFileAcc+'.cdx'
				ENDIF

				** VETT  26/08/2016 11:30 AM : Nueva estructura segun PLE v5.0 
				** VETT:PLE v5.2 ICBPER 2021/01/15 06:26:55 ** 
				this.struct_140100_v5 

				SELECT (PsTblDestino)
				** VETT  15/07/2014 09:32 AM : Hace tiempo era esta nota  
				LsPeriod=THIS.PlePeriod 
				LnAno 	= VAL(LEFT(THIS.PlePeriod,4)) 
				LnMes	= VAL(RIGHT(THIS.PlePeriod,2))

				** VETT  23/08/2016 12:15 PM : Eliminamos generación del archivo temporal intermedio RVAUXI1 
				**  y backup de datos ACCESS -> JUNK2
				** Cargamos y formateamos la data del ACCESS directamente    
				IF RIGHT(THIS.PlePeriod,2)='12'
					LdFinMes=CTOD('31'+'/'+RIGHT(THIS.PlePeriod,2)+'/'+LEFT(THIS.PlePeriod,4))
				ELSE
					LdFinMes=CTOD('01'+'/'+STR(VAL(RIGHT(THIS.PlePeriod,2))+1)+'/'+LEFT(THIS.PlePeriod,4)) - 1
				ENDIF
				*!*	This.Junk1 
				this.TxtEstadoProceso2.Caption	=	[CARGANDO REGISTROS DEL ORIGEN DE DATOS: ] + UPPER(this.cboTpoOriDat.DisplayValue  )


				THIS.TxtEstadoProceso2.Caption	=	'FORMATEANDO REGISTROS DEL ORIGEN DE DATOS: ' + UPPER(this.cboTpoOriDat.DisplayValue  )

				SELECT   (PsCurOrigen) &&RVAuxi1    
				SCAN
					IF EMPTY(TIDO) AND EMPTY(NDOC) AND EMPTY(SERI) AND EMPTY(LOCA)
						LOOP
					ENDIF
					SCATTER  MEMVAR FIELDS LOCA,LOC2, DELO,DETA,OTRO,BOLE,EMBA,NDO2 MEMO 
					LdFEMI		=NVL(TTOD(FEMI),{})
					LsSERI		=SUBSTR(SERI,1,10)
					LsTIKE		=SUBSTR(TIKE,1,10)
					LsNDOC	=SUBSTR(NDOC,1,20)
					LsNRUC	=SUBSTR(NRUC,1,11)
					LsRASO	=SUBSTR(RASO,1,60)
					LnTIDO		=TIDO
					LnTCOM	=TCOM
					LnPASA		=PASA
					LnENCO	=ENCO
					LnOTIN		=OTIN
					LnEXCE		=EXCE
					LnIGV		=IGV
					LnTOGE	=TOGE
					LnTID2		=TID2
					LnNDO2	=NVL(LEFT(NDO2,30)		,[])
					SELECT (PsTblDestino)
					APPEND BLANK
					REPLACE CIA_CODCIA		WITH	THIS.PLECodCia
					REPLACE PERIODO			WITH	THIS.PLEPerPco
					REPLACE ASIENTO			WITH	SPACE(15)
					REPLACE NROITM			WITH	SPACE(10)
					REPLACE CTE_FECEMI		WITH	LdFEMI
					REPLACE CTE_FECVEN		WITH	{}
					REPLACE T10_CODT10		WITH	TRANSFORM(LnTIDO,'@L 99')
					REPLACE SERIE			WITH	ICASE( NOT ISNULL(LsSERI)   ,  LsSERI   , '0')
					REPLACE NUMERO		WITH	ICASE( NOT ISNULL(LsNDOC), LsNDOC,  '0')
					IF T10_CODT10='12'
						REPLACE NUMERO WITH ALLTRIM(SERIE)+NUMERO
						REPLACE SERIE WITH TRIM(LsTIKE)
					ENDIF
					REPLACE ULT_NUMERO	WITH	'0'
					REPLACE T02_CODT02		WITH	TRANSFORM(LnTCOM,'@L 9')
					REPLACE RUC				WITH	ICASE( NOT ISNULL(LsNRUC) ,LsNRUC, '0' )
					REPLACE NOMBRE			WITH	ICASE( NOT ISNULL(LsRASO ),LsRASO, '0' )
					REPLACE VAL_EXPORT		WITH	0.00
					REPLACE VAL_AFECTO		WITH	ICASE(LnTIDO=1 AND NVL(LnPASA,0) > 0 , NVL(LnPASA,0) , NVL(LnENCO + LnOTIN,0) )
					REPLACE VAL_INAFEC		WITH	0.00
					REPLACE VAL_EXONER		WITH	ICASE(LnTIDO=1 AND NVL(LnPASA,0) > 0 , NVL(LnEXCE,0) , NVL(LnPASA + LnEXCE,0) )
					REPLACE IMP_ISC			WITH	0.00
					REPLACE IMP_IGV			WITH	VAL(TRANSFORM(NVL(LnIGV	,0),'999999999999.99'))
					REPLACE IMP_TOTAL		WITH	VAL(TRANSFORM(NVL(LnTOGE,0),'999999999999.99'))
					=SEEK(DTOS(CTE_FECEMI),'TCMB')
					IF FOUND('TCMB')
						IF TCMB.OfiCmp>0 
							REPLACE CTE_TIPCAM WITH TCMB.OfiCmp
						ENDIF
					ELSE
						REPLACE CTE_TIPCAM		WITH	2.8
					ENDIF

					REPLACE FECEMI_REF		WITH	ICASE(LnTIDO = 7 , {}, CTOD ('01/01/1900') )
					REPLACE T10_CODREF		WITH	ICASE( INLIST(LnTIDO ,7,16),  TRANSFORM(LnTID2, '@L 99'), '00' )
					XnPosGuion= AT('-',LnNDO2)
					LsSerRef    = IIF(XnPosGuion>0,LEFT(LnNDO2,XnPosGuion-1),LEFT(LnNDO2,3))
					LsNroRef    = IIF(XnPosGuion>0,SUBST(LnNDO2,XnPosGuion+1),SUBST(LnNDO2,4))
					REPLACE SERIE_REF	WITH	ICASE( INLIST( LnTIDO,7,16),  LsSerRef , '-' )
					REPLACE NUMERO_REF	WITH	ICASE( INLIST( LnTIDO,7,16),  LsNroRef , '-' )
					REPLACE ESTADO_OPE	WITH	'1'
					** DATOS PARA ENCONTRAR CENTRO DE COSTO Y CUENTA CONTABLE EN CARGADORES **

					m.LOCA	= NVL(LEFT(m.LOCA	,60)	,[])
					m.DETA	= NVL(LEFT(m.DETA	,30)	,[])
					m.LOC2	= NVL(LEFT(m.LOC2	,60)	,[])
					m.DELO	= NVL(LEFT(m.DELO	,60)	,[])
					m.OTRO	= NVL(LEFT(m.OTRO	,30)	,[])
					m.BOLE	= NVL(m.BOLE,0)
					m.EMBA	= NVL(m.EMBA,0)
					m.NDO2  = LnNDO2

					GATHER MEMVAR FIELDS LOCA,LOC2, DELO,DETA,OTRO,BOLE,EMBA,NDO2
					** VETT  18/08/2014 09:41 AM : Separamos y marcamos todos los registros que pertenecen a CARGO  Y PASAJES
					STORE '' TO LsSerie,LsSerieRef
					IF LEN(ALLTRIM(SERIE)) < 4
				       		LsSerie 		= RIGHT('0000' + ALLTRIM(SERIE),4)
		    			ENDIF
					IF LEN(ALLTRIM(SERIE_REF)) < 4  AND !ALLTRIM(SERIE_REF)=='0'
				       		LsSerieRef	= RIGHT('0000' + ALLTRIM(SERIE_REF),4)
				    	ENDIF

					IF INLIST(T10_CODT10,'12')   OR  ( INLIST(T10_CODT10,'01','03','07')  AND   ( INLIST(LsSerie,'0080','0956','0958','F080','F956','F958')  ) OR    (INLIST(T10_CODT10,'01','03','07','12')  AND  (ABS(LnENCO) + ABS(LnOTIN) + ABS(LnEXCE)) > 0 ) )

						REPLACE TIPO_VENTA	WITH	'CARGO'
						DO CASE
							CASE ABS(LnENCO)>0
								REPLACE DETA_VENTA WITH 'ENCOMIENDA'
							CASE ABS(LnOTIN)>0
								REPLACE DETA_VENTA WITH 'OTROSING'
							CASE ABS(LnEXCE)>0
								REPLACE DETA_VENTA WITH 'EXCESOS'
						ENDCASE
					ELSE
						REPLACE TIPO_VENTA	WITH	'PASAJES'
					ENDIF

					SELECT (PsCurOrigen)
				ENDSCAN
				THIS.TxtEstadoProceso2.Caption	= [FORMATO DE REGISTROS DEL ORIGEN DE DATOS ]+ UPPER(this.cboTpoOriDat.DisplayValue  )+ [ TERMINADO.]  
				SELECT (PsTblDestino)
				SET ORDER TO TIPO2
				LOCATE

			CASE PcModo	= 'VCORP'

				THIS.TxtEstadoProceso2.Caption	= [EXTRAYENDO REGISTROS DE VENTAS CORPORATIVA... ]
				SELECT (PsCurOrigen)
				LsRutaFileAcc=ADDBS(Goentorno.LocPath) + PcModo+This.PLEPeriod 
				LsRutaStruc	=	ADDBS(Goentorno.LocPath) + PcModo+'_STRU'
				IF FILE(LsRutaFileAcc+'.dbf')
					DELETE FILE  LsRutaFileAcc+'.dbf'
					DELETE FILE  LsRutaFileAcc+'.fpt'
					DELETE FILE  LsRutaFileAcc+'.cdx'
				ENDIF

				IF !FILE(LsRutaFileAcc+'.dbf')
					CREATE TABLE (LsRutaFileAcc) FREE   	;
						( FEMI T ,;
						 SERI C(4),;
						 LOCA C(30),;
						  PASAJE Double ,;
						  Agencia Double,;
						  PVEA Double,;
						  Corporativ Double,;
						  Exceso Integer,;
						  OtroIng Integer,;
						  Encomi Integer,;
						  LOC2 C(60),;
						  DELO C(40),;
						  NRUC C(11),;
						  RASO C(60),;
						  NDOC C(15),;
						  OTRO C(50),;
		  				 TIDO C(2),;
						  Estado1 C(5))
						  
					USE 	  
				ENDIF
				SELECT 0
				USE (LsRutaFileAcc) ALIAS VCORP EXCL
				INDEX on tido+seri+ndoc TAG serie
				SELECT (PsCurOrigen)
				SCAN 
					SCATTER MEMVAR 
					SELECT VCORP
					APPEND BLANK
					IF m.Corporativo>=0
						m.tido = '16' 
					ENDIF
					IF m.Corporativo<0
						m.tido = '07' 
					ENDIF
					M.SERI		=	NVL(RV_CORP.SERI,'')
					M.NDOC 	=	NVL(RV_CORP.NDOC,'') 
					M.LOCA		=	NVL(RV_CORP.LOCA,'')
					M.LOC2		=	NVL(RV_CORP.LOC2,'')
					M.NRUC	=	NVL(RV_CORP.NRUC,'')
					M.OTRO 	=	NVL(RV_CORP.OTRO ,'')
					M.RASO		=	NVL(RV_CORP.RASO,'')
					m.Corporativ	= NVL(RV_CORP.Corporativo,0)

		*!*				m.Tido		=	RV_CORP.Tido
		*!*				m.Estado1	=      RV_CORP.Estado1

					GATHER MEMVAR
					SELECT (PsCurOrigen)
				ENDSCAN
		*!*			COPY TO  (LsRutaFileAcc) WITH CDX
		*!*			SELECT 0
		*!*			USE (LsRutaFileAcc) EXCLUSIVE ALIAS VCORP
		*!*			ALTER TABLE VCORP ALTER COLUMN SERI C(4)
		*!*			ALTER TABLE VCORP ALTER COLUMN LOCA C(30)
		*!*			ALTER TABLE VCORP ALTER COLUMN NRUC C(11)
		*!*			ALTER TABLE VCORP ALTER COLUMN RASO C(50)
		*!*			ALTER TABLE VCORP ALTER COLUMN NDOC C(15)
		*!*			IF VARTYPE(TIDO)='U'
		*!*				ALTER TABLE VCORP ADD COLUMN TIDO C(2)
		*!*			ELSE
		*!*				ALTER TABLE VCORP ALTER COLUMN TIDO C(2)
		*!*			ENDIF
		*!*			ALTER TABLE VCORP ADD COLUMN ESTADO1 C(5)
		*!*			REPLACE ALL tido WITH '16' FOR  Corporativ>=0
		*!*			REPLACE ALL tido WITH '07' FOR  Corporativ<0
		*!*			INDEX on tido+seri+ndoc TAG serie
				USE IN VCORP
				USE IN (PsCurOrigen)
			CASE PcModo	= 'RAGEN'
				THIS.TxtEstadoProceso2.Caption	= [EXTRAYENDO REGISTROS DE RUC DE AGENCIAS... ]
				SELECT (PsCurOrigen)
				LsRutaFileAcc=ADDBS(Goentorno.LocPath) + PcModo+This.PLEPeriod 
				IF FILE(LsRutaFileAcc+'.dbf')
					DELETE FILE  LsRutaFileAcc+'.dbf'
					DELETE FILE  LsRutaFileAcc+'.fpt'
					DELETE FILE  LsRutaFileAcc+'.cdx'
				ENDIF
				COPY TO  (LsRutaFileAcc) WITH CDX
				SELECT 0
				USE (LsRutaFileAcc) EXCLUSIVE ALIAS RAGEN
				ALTER TABLE RAGEN ALTER COLUMN NRUC C(11)
				ALTER TABLE RAGEN ALTER COLUMN RASO C(60)
				INDEX ON NRUC TAG NRUC
				INDEX ON UPPER(RASO) TAG RASO
				USE IN RAGEN
				USE IN (PsCurOrigen)
			CASE PcModo	= 'RMOV'

				Thisform.oData.AbrirTabla('ABRIR','CBDMCTAS','CTAS','CTAS01','','','',STR(_ANO,4,0))
				Thisform.oData.AbrirTabla('ABRIR','CBDRMOVM','RMOV','RMOV01','','','',STR(_ANO,4,0))
				Thisform.oData.AbrirTabla('ABRIR','CBDRVOVM','VMOV','VMOV01','','','',STR(_ANO,4,0))
				Thisform.oData.Abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','') 
				Thisform.oData.AbrirTabla('ABRIR','CBDTOPER','OPER','OPER01','','','',STR(_ANO,4,0))
				Thisform.oData.Abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','') 
				Thisform.oData.Abrirtabla('ABRIR','ADMTCNFG','CNFG','CNFG01','') 
				Thisform.oData.Abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','') 


				XnCodDiv = 1    && 1+GnDivis
				Store [] TO XsCodDiv

				*
				XsCodDiv=IIF(!GoCfgCbd.TIPO_CONSO=2,'',LEFT(vDivision(XnCodDiv),2))
				*
				IF EMPTY(XsCodDiv) OR !GoCfgCbd.TIPO_CONSO=2
					XsCodDiv = '**' 	&& Consolidado o no se usa divisionaria
					XnCodDiv = 0
				ENDIF
				LnControl = 1
				XiTipo   = 1
				XsNroMes = RIGHT(THIS.PlePeriod,2)
				XsCodOpe = This.PLECodOpe
				CsCodCco = ''
				XiCodMon = 1
				IF XiCodMon= 1
					XsNombre = 'EN SOLES'
				ELSE
					XsNombre = 'EN DOLARES'
				ENDIF
				XcEliItm	= '*'

				DO CASE
					CASE This.Plelibro = '140100' 
							THIS.struct_140100_v5 
							SELE CNFG
							SEEK 'VTA'
							XsVtaOp = CNFG.CodOpe
							XsVta70 = CNFG.CtaBase
							XsVta40 = CNFG.CtaImpu
							XsVta12 = CNFG.CtaTota
		*!*						CD (Thisform.Tag)
							PUBLIC LoDatAdm AS dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
							LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
							SET PROCEDURE TO cbd_report_registro_ventas additive
		*!*						CD(thisform.cDirInterface)
							LsAliasTemp=CreaTemp(PsCurOrigen)
							IF EMPTY(LsAliasTemp)
								MESSAGEBOX('No se pudo crear archivo '+ PsCurOrigen,16,'ATENCION !!!')
								RETURN
							ENDIF

							DO Imprimir 
		*!*						CD (Thisform.Tag)
							SET PROCEDURE TO 
							SET procedure TO JANESOFT,FXGEN_2 ADDITIVE
		*!*						CD(thisform.cDirInterface)

							SELECT (PsTblDestino)
							** VETT  15/07/2014 09:32 AM : Hace tiempo era esta nota  
							LsPeriod=THIS.PlePeriod 
							LnAno 	= VAL(LEFT(THIS.PlePeriod,4)) 
							LnMes	= VAL(RIGHT(THIS.PlePeriod,2))
									LdFinMes=CTOD(IIF(LnMes=2,'28','30')+'/'+RIGHT(THIS.PlePeriod,2)+'/'+LEFT(THIS.PlePeriod,4))
						     
							THIS.TxtEstadoProceso2.Caption	=	'FORMATEANDO REGISTROS DEL ORIGEN DE DATOS: ' + UPPER(this.cboTpoOriDat.DisplayValue  )
							SELECT (PsCurOrigen)
							SCAN
								SELECT (PsTblDestino)
								APPEND BLANK
								REPLACE CIA_CODCIA		WITH	THIS.PLECodCia
								REPLACE PERIODO			WITH	THIS.PLEPerPco
								REPLACE ASIENTO			WITH	&PsCurOrigen..NroAst 	&& SPACE(15)
								REPLACE NROITM			WITH	TRANSFORM(&PsCurOrigen..NroItm,'@L 999999')	&& SPACE(10)
								REPLACE CTE_FECEMI		WITH	&PsCurOrigen..FchDoc
								REPLACE CTE_FECVEN		WITH	&PsCurOrigen..FchVto && {}
								REPLACE T10_CODT10		WITH	&PsCurOrigen..CodDoc

								XsCodAux	= 	&PsCurOrigen..Ruc    && &PsCurOrigen..CodAux
					*!*				XsGloDoc	=	&PsCurOrigen..Concepto
								XsCliente	=	&PsCurOrigen..Cliente
		*!*							XsNroDoc	=	&PsCurOrigen..NroDoc
		*!*							XnPosGuion	=	AT('-',XsNroDoc)
								LsSerie		=	&PsCurOrigen..SerDoc && IIF(XnPosGuion>0,LEFT(XsNroDoc,XnPosGuion-1),LEFT(XsNroDoc,3))
								LsNroDoc	=	&PsCurOrigen..NroDoc && IIF(XnPosGuion>0,SUBST(XsNroDoc,XnPosGuion+1),SUBST(XsNroDoc,4))
								XfSoles		=	&PsCurOrigen..Soles
								XfImpIgv	=	&PsCurOrigen..ImpIgv
								REPLACE SERIE			WITH	ICASE( NOT (ISNULL(LsSerie) or EMPTY(LsSerie) )  , LsSerie , '0')
								REPLACE NUMERO			WITH	ICASE( NOT (ISNULL(LsNroDoc) or EMPTY(LsNroDoc) ), LsNroDoc, '0')
								REPLACE ULT_NUMERO		WITH	'' && '0'
								REPLACE T02_CODT02		WITH	IIF(Len(trim(XsCodAux))=11,'6',iif(Len(trim(XsCodAux))=8,'1','0' ))
								REPLACE RUC				WITH	ICASE( NOT (ISNULL(XsCodAux) OR EMPTY(XsCodAux)),XsCodAux, '0' )
								REPLACE NOMBRE			WITH	ICASE( NOT (ISNULL(XsCliente) OR EMPTY(XsCliente)),XsCliente, '0' )
								REPLACE VAL_EXPORT		WITH	0.00
								REPLACE VAL_AFECTO		WITH	&PsCurOrigen..Afecto
								REPLACE VAL_INAFEC		WITH	&PsCurOrigen..Inafecto
								REPLACE VAL_EXONER		WITH	0
								REPLACE IMP_ISC			WITH	0.00
								REPLACE IMP_IGV			WITH	VAL(TRANSFORM(NVL(XfImpIgv	,0),'999999999999.99'))
								REPLACE IMP_TOTAL		WITH	VAL(TRANSFORM(NVL(XfSoles	,0),'999999999999.99'))
								REPLACE T04_CODT04		WITH	ICASE(&PsCurOrigen..CodMon=1,'PEN',&PsCurOrigen..CodMon=2,'USD','')
								REPLACE CTE_TIPCAM		WITH	&PsCurOrigen..TpoCmb
								REPLACE FECEMI_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08') , &PsCurOrigen..FchRef, CTOD ('01/01/1900') )
								REPLACE T10_CODREF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..TipRef, '00' )
								REPLACE SERIE_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..SerRef, '-' )
								REPLACE NUMERO_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..NroRef, '-' )
								REPLACE ESTADO_OPE		WITH	ICASE(&PsCurOrigen..FlgEst='R','1',&PsCurOrigen..FlgEst='A','2','')
								IF SUBSTR(DTOS(&PsCurOrigen..FchDoc),1,6)<SUBSTR(THIS.PLEPerPco,1,6)
									REPLACE ESTADO_OPE		WITH	'6'
								ENDIF
								REPLACE Estado1			WITH 	&PsCurOrigen..FlgEst
								SELECT (PsCurOrigen)
							ENDSCAN
							THIS.TxtEstadoProceso2.Caption	= [FORMATO DE REGISTROS DEL ORIGEN DE DATOS ]+ UPPER(this.cboTpoOriDat.DisplayValue  )+ [ TERMINADO.]  
							SELECT (PsTblDestino)
							LOCATE


					CASE This.Plelibro = '080100' 
							THIS.struct_080100_v5
							THIS.PeriodoLibro( '080200' ) 
							THIS.struct_080200_v5
							THIS.PeriodoLibro( '080100' ) 
							**
							SELE CNFG
							SEEK 'CMP'
							XsCmpOp  = CNFG.CodOpe
							XsCmp60  = CNFG.CtaBase
							XsCmp40  = CNFG.CtaImpu
							XsCmp42  = CNFG.CtaTota
							XsCmp4ta = IIF(EMPTY(CNFG.Cta4tac),["XX"],CNFG.Cta4tac)
							XscmpDom = IIF(VARTYPE(CtaDom)<>'C' OR EMPTY(CNFG.CtaDom),["XX"],CNFG.CtaDom)
							XsCmpFon = CNFG.CtaFona
							XsCodCco = " "
		*!*						CD (Thisform.Tag)
							PUBLIC LoDatAdm AS dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
							LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
							SET PROCEDURE TO cbd_report_registro_compras additive
		*!*						CD(thisform.cDirInterface)
							LsAliasTemp=CreaTemp(PsCurOrigen)
							IF EMPTY(LsAliasTemp)
								MESSAGEBOX('No se pudo crear archivo '+ PsCurOrigen,16,'ATENCION !!!')
								RETURN
							ENDIF

							DO Imprimir 
		*!*						CD (Thisform.Tag)
							SET PROCEDURE TO 
							SET procedure TO JANESOFT,FXGEN_2 ADDITIVE
		*!*						CD(thisform.cDirInterface)
							SELECT (PsTblDestino)
							** VETT  15/07/2014 09:32 AM : Hace tiempo era esta nota  
							LsPeriod=THIS.PlePeriod 
							LnAno 	= VAL(LEFT(THIS.PlePeriod,4)) 
							LnMes	= VAL(RIGHT(THIS.PlePeriod,2))
									LdFinMes=CTOD(IIF(LnMes=2,'28','30')+'/'+RIGHT(THIS.PlePeriod,2)+'/'+LEFT(THIS.PlePeriod,4))

							THIS.TxtEstadoProceso2.Caption	=	'FORMATEANDO REGISTROS DEL ORIGEN DE DATOS: ' + UPPER(this.cboTpoOriDat.DisplayValue  )
							SELECT (PsCurOrigen)
							SCAN
								SELECT (PsTblDestino)
								APPEND BLANK
								REPLACE CIA_CODCIA		WITH	THIS.PLECodCia
								REPLACE PERIODO			WITH	THIS.PLEPerPco
								REPLACE ASIENTO			WITH	&PsCurOrigen..NroAst 	&& SPACE(15)
								REPLACE NROITM			WITH	TRANSFORM(&PsCurOrigen..NroItm,'@L 999999')	&& SPACE(10)
								REPLACE CTE_FECEMI		WITH	&PsCurOrigen..FchDoc
								REPLACE CTE_FECVEN		WITH	&PsCurOrigen..FchVto && {}
								REPLACE T10_CODT10		WITH	&PsCurOrigen..CodDoc
								XsCodAux	= 	 &PsCurOrigen..CodAux  && &PsCurOrigen..RucAux 
								XsGloDoc	=	&PsCurOrigen..GloDoc
								XsProveedor	=	&PsCurOrigen..Proveedor
								XsDireccion		=	&PsCurOrigen..DirAux
								XsCodPais		=	&PsCurOrigen..CodPais
		*!*							XsNroDoc	=	&PsCurOrigen..NroDoc
		*!*							XnPosGuion	=	AT('-',XsNroDoc)

		*!*							IF Asiento='01000044'
		*!*								SET STEP ON 
		*!*							ENDIF
								LsSerie		=	&PsCurOrigen..SerDoc && IIF(XnPosGuion>0,LEFT(XsNroDoc,XnPosGuion-1),LEFT(XsNroDoc,3))
								LsNroDoc	=	&PsCurOrigen..NroDoc && IIF(XnPosGuion>0,SUBST(XsNroDoc,XnPosGuion+1),SUBST(XsNroDoc,4))
								XfBase		=   &PsCurOrigen..BaseB
								XfBaseNoG	=   &PsCurOrigen..BaseA &&  No Gravado
								XfSoles		=	&PsCurOrigen..Importe
								XfImpIgv	=	&PsCurOrigen..ImpIgvA
								XfImpIsc	=	&PsCurOrigen..ImpISC
								XfOtros		=	&PsCurOrigen..NoGrava
								** VETT  19/06/2017 11:53 AM : Por fin el año de la DUA , demora por estragos de agosto del 2016 
								XsAno_Dua	=	&PsCurOrigen..AAAA_DUA  
								IF   NOT INLIST(T10_CODT10,'00','91','97','98') 

									REPLACE SERIE			WITH	ICASE( NOT (ISNULL(LsSerie) or EMPTY(LsSerie) )  , LsSerie , '0')
									REPLACE ANO_DUA			WITH	XsAno_Dua
									REPLACE NUMERO			WITH	ICASE( NOT (ISNULL(LsNroDoc) or EMPTY(LsNroDoc) ), LsNroDoc, '0')
									REPLACE ULT_NUMERO		WITH	'' && '0'
									REPLACE T02_CODT02		WITH	IIF(Len(trim(XsCodAux))=11,'6',iif(Len(trim(XsCodAux))=8,'1','0' ))
									REPLACE RUC				WITH	ICASE( NOT (ISNULL(XsCodAux) OR EMPTY(XsCodAux)),XsCodAux, '0' )
									REPLACE NOMBRE			WITH	ICASE( NOT (ISNULL(XsProveedor) OR EMPTY(XsProveedor)),XsProveedor, '0' )
									REPLACE BI_GRA_DER		WITH	XfBase
									REPLACE IM_GRA_DER		WITH	XfImpIgv
									REPLACE BI_GRA_MIX		WITH	0.00
									REPLACE IM_GRA_MIX		WITH 	0.00
									REPLACE BI_GRA_SDE		WITH	&PsCurOrigen..BaseC    && Inafecto
									REPLACE IM_GRA_SDE		WITH	&PsCurOrigen..ImpIgvB 
		*!*								IF &PsCurOrigen..CodDoc='03' AND &PsCurOrigen..Afecto='I'
										REPLACE BI_NO_GRAV		WITH	XfBaseNoG
		*!*								ENDIF
									REPLACE IMP_ISC			WITH	XfImpIsc
									REPLACE OTROS_TRIB		WITH 	XfOtros
									REPLACE IMP_TOTAL		WITH	VAL(TRANSFORM(NVL(XfSoles	,0),'999999999999.99'))
									REPLACE T04_CODT04		WITH	ICASE(&PsCurOrigen..CodMon=1,'PEN',&PsCurOrigen..CodMon=2,'USD','')
									REPLACE CTE_TIPCAM		WITH	&PsCurOrigen..TpoCmb
									REPLACE FECEMI_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08') , &PsCurOrigen..FchRef, CTOD ('01/01/1900') )
									REPLACE T10_CODREF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..TipRef, '00' )
									REPLACE SERIE_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..SerRef, '-' )
									REPLACE NUMERO_REF		WITH	ICASE(INLIST(&PsCurOrigen..CodDoc , '07','08'),  &PsCurOrigen..NroRef, '-' )
									REPLACE N_CP_N_DOM		WITH	''
									REPLACE DPP_FECPST  	WITH	IIF(ISNULL(&PsCurOrigen..FchDtr) OR EMPTY(&PsCurOrigen..FchDtr),CTOD ('01/01/1900'),&PsCurOrigen..FchDtr)
									REPLACE DPP_DEPPST		WITH	&PsCurOrigen..NroDtr
									REPLACE DPP_INDDET		WITH	IIF(XfOtros>0,'1','0')
									REPLACE ESTADO_OPE		WITH	ICASE(&PsCurOrigen..FlgEst='R','1',&PsCurOrigen..FlgEst='A','2','')
									IF SUBSTR(DTOS(&PsCurOrigen..FchDoc),1,6)<SUBSTR(THIS.PLEPerPco,1,6)
										REPLACE ESTADO_OPE		WITH	'6'
									ENDIF
									REPLACE Estado1			WITH 	&PsCurOrigen..FlgEst
								ELSE
									** VETT  19/06/2017 04:28 PM :   NO DOMICILIADOS
									SELECT RegComND
									APPEND BLANK
									REPLACE CIA_CODCIA		WITH	THIS.PLECodCia
									REPLACE PERIODO			WITH	THIS.PLEPerPco
									REPLACE ASIENTO			WITH	&PsCurOrigen..NroAst 	&& SPACE(15)
									REPLACE NROITM			WITH	TRANSFORM(&PsCurOrigen..NroItm,'@L 999999')	&& SPACE(10)
									REPLACE CTE_FECEMI			WITH	&PsCurOrigen..FchDoc
									REPLACE CTE_FECVEN		WITH	&PsCurOrigen..FchVto && {}
									REPLACE T10_CODT10		WITH	&PsCurOrigen..CodDoc
									REPLACE SERIE				WITH	ICASE( NOT (ISNULL(LsSerie) or EMPTY(LsSerie) )  , LsSerie , '0')
									REPLACE ANO_DUA			WITH	XsAno_Dua
									REPLACE NUMERO			WITH	ICASE( NOT (ISNULL(LsNroDoc) or EMPTY(LsNroDoc) ), LsNroDoc, '0')
									Replace IMPTOT_ADQ 		WITH 	VAL(TRANSFORM(NVL(XfSoles	,0),'999999999999.99'))
									Replace Ser_Dua	  		WITH 	ICASE( NOT (ISNULL(LsSerie) or EMPTY(LsSerie) )  , LsSerie , '0')
									REPLACE T10_C_SUST 		WITH 	''
									REPLACE T04_CODT04		WITH	ICASE(&PsCurOrigen..CodMon=1,'PEN',&PsCurOrigen..CodMon=2,'USD','')
									REPLACE T35_CODT35 		WITH 	XsCodPais
									REPLACE NOMBRE			WITH 	XsProveedor
									REPLACE Direccion			WITH 	XsDireccion

									REPLACE ESTADO_OPE		WITH	ICASE(&PsCurOrigen..FlgEst='R','1',&PsCurOrigen..FlgEst='A','2','')
									IF SUBSTR(DTOS(&PsCurOrigen..FchDoc),1,6)<SUBSTR(THIS.PLEPerPco,1,6)
										REPLACE ESTADO_OPE		WITH	'6'
									ENDIF
									REPLACE Estado1			WITH 	&PsCurOrigen..FlgEst
								ENDIF
								SELECT (PsCurOrigen)
							ENDSCAN
							THIS.TxtEstadoProceso2.Caption	= [FORMATO DE REGISTROS DEL ORIGEN DE DATOS ]+ UPPER(this.cboTpoOriDat.DisplayValue  )+ [ TERMINADO.]  
							SELECT (PsTblDestino)
							LOCATE
							** 


					CASE This.Plelibro = '050100' 
					CASE This.Plelibro = '060100' 
				ENDCASE
				RELEASE LoDatAdm


		ENDCASE
	ENDPROC


	*-- Sql Script
	PROCEDURE pa_genera_libro_electronico_14_01_v1_2
		TEXT TO  wcad TEXTMERGE NOSHOW 

			USE [bd_interfases2]
			GO

			/****** Object:  StoredProcedure [dbo].[PA_GENERA_LIBRO_ELECTRONICO_14_01_V1_2]    Script Date: 07/15/2014 01:15:40 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO


			-- Batch submitted through debugger: SQL_SP_RV_Oltursa.sql|9|0|D:\610\Documents\SQL Server Management Studio\Projects\SQL_SP_RV_Oltursa.sql

			-- Batch submitted through debugger: SQLQuery11.sql|1032|0|C:\Users\610\AppData\Local\Temp\~vs7EE8.sql
			  
			-- exec [PA_GENERA_LIBRO_ELECTRONICO_14_01_V1] '01','01','2012','01'


			ALTER  procedure [dbo].[PA_GENERA_LIBRO_ELECTRONICO_14_01_V1_2]   
									@p_codcia char(2), @p_codsuc char(2), @p_codano char(4),@p_codmes char(2)
			AS  

			/* Declara Variabless */
			Declare @periodo char(8) --, @p_codano char(4),@p_codmes char(2) 
			Declare @long_serie int, @long_numero int 
			Declare @FinMes char(10) , @Dia Char(2)

			/* Notas VETT: */
			 --CAST ('01/01/1900' AS datetime) AS FECEMI_REF ,

			/* Inicializa Variabless */
			Set @periodo = @p_codano + @p_codmes + '00'
			Set @long_serie = 4
			set @long_numero = 14 - @long_serie
			SET @Dia = case @p_codmes when '02' then  '28' else '30' end
			declare @Fecha datetime
			SET @FinMes = @p_codmes+'/'+@Dia+'/'+@p_codano 
			--set @Fecha = cast(@FinMes AS Datetime)

			/* Limpia Datos Anteriores */
			Delete dbo.LBE_1401_REGVEN_LEV
			where  CIA_CODCIA = @p_codcia
			and    PERIODO    = @periodo

			/* Selecciona Informacion */
			------------------------------  
			insert dbo.LBE_1401_REGVEN_LEV
				 ( CIA_CODCIA, PERIODO, ASIENTO, CTE_FECEMI, CTE_FECVEN, T10_CODT10, 
				   SERIE, 
				   NUMERO, 
				   ULT_NUMERO, 
				   T02_CODT02,
				   RUC, NOMBRE, 
				   VAL_EXPORT ,
				   VAL_AFECTO ,
				   VAL_INAFEC , 
				   VAL_EXONER , IMP_ISC    , IMP_IGV    , 
				   BASIMP_IVA, IMP_IVAP   , OTROS_TRIB ,
				   IMP_TOTAL  , 
				   CTE_TIPCAM , 
				   FECEMI_REF , T10_CODREF , SERIE_REF, NUMERO_REF,
				   ESTADO_OPE )
				(   
			SELECT	'01',
					 PERIODO+'00'  AS PERIODO,
					 ROW_NUMBER() OVER(ORDER BY FEMI ASC ) as asiento,
					 FEMI ,
					 null,
					 TIDO,
					 case  WHEN SERI IS not null then  [SERI]  else ('0')  end  AS SERIE ,
					 case  WHEN NDOC IS not null then  [NDOC]  else ('0')  end  AS NUMERO ,
					 '0' as ULT_NUMERO,
					 TCOM,
					 case  WHEN NRUC IS not null then  [NRUC]  else ('0')  end  AS RUC ,
					 case  WHEN RASO IS not null then  [RASO]  else ('0')  end  AS NOMBRE ,
					 0.00  as VAL_EXPORT,
					 CASE WHEN TIDO=1 AND coalesce(PASA,0) > 0 THEN coalesce(PASA,0) ELSE coalesce(ENCO + OTIN,0) END as VAL_AFECTO,
					 0.00  as VAL_INAFEC,
					 CASE WHEN TIDO=1 AND coalesce(PASA,0) > 0 THEN coalesce(EXCE,0) ELSE  coalesce(PASA + EXCE,0) END as VAL_EXONER,
					 0   as IMP_ISC,
			         coalesce(IGV,0) AS IMP_IGV,			   
					 0 AS BASIMP_IVA,
					 0 AS IMP_IVAP,
					 0 AS OTROS_TRIB ,  
					 coalesce(TOGE,0) AS IMP_TOTAL,
			  		 2.756 AS CTE_TIPCAM ,
			  		 case  TIDO when 7 then  cast(@FinMes as datetime) else CAST ('01/01/1900' AS datetime) end AS FECEMI_REF ,
			  		 case  WHEN tido in (7,16) then  [TID2]  else ('00')  end  AS T10_CODREF,
				     case  WHEN tido in (7,16) then  SUBSTRING( [NDO2] ,1, 3) else '-' end  AS SERIE_REF,
				     case  WHEN tido in (7,16) then  SUBSTRING( [NDO2] ,5,10) else '-' end  AS NUMERO_REF,
					 '1' as ESTADO_OPE		 
			FROM dbo.MA_AUXILIAR_VENTAS AS a 
			 where  PERIODO = @p_codano+@p_codmes 
			 
			        --AND ( TOGE > 0 or TIDO = 7 ) 
			     )   

			/* WHERE   a.cia_codcia = @p_codcia
				and a.suc_codsuc = @p_codsuc
				and a.ANO_CODANO = @p_codano
				and a.MES_CODMES = @p_codmes
				and a.ORI_CODORI in ('050')
				and LEN(ISNULL(d.TDO_CODOFI, '')) > 0
				and a.CTE_CODPAG = 'C'
			*/

			GO

		ENDTEXT
	ENDPROC


	*-- Residuos de programación
	PROCEDURE junk1
		TEXT TO LsStrQry2  TEXTMERGE NOSHOW PRETEXT 15
			INSERT INTO REGVEN 
					 ( CIA_CODCIA, 
					   PERIODO, 
					   ASIENTO, 
					   NROITM, 
					   CTE_FECEMI, 
					   CTE_FECVEN, 
					   T10_CODT10, 
					   SERIE, 
					   NUMERO, 
					   ULT_NUMERO, 
					   T02_CODT02,
					   RUC, 
					   NOMBRE, 
					   VAL_EXPORT ,
					   VAL_AFECTO ,
					   VAL_INAFEC , 
					   VAL_EXONER , 
					   IMP_ISC    , 
					   IMP_IGV    , 
					   BASIMP_IVA, 
					   IMP_IVAP   , 
					   OTROS_TRIB ,
					   IMP_TOTAL  , 
					   CTE_TIPCAM , 
					   FECEMI_REF , 
					   T10_CODREF , 
					   SERIE_REF, 
					   NUMERO_REF,
					   ESTADO_OPE ) 
			 		   SELECT		<<'['+THIS.PLECodCia+']'>>,
						 <<'['+THIS.PLEPerPco+']'>>  AS PERIODO,
						 SPACE(15) as ASIENTO,
						 SPACE(10) AS NROITM ,
						 FEMI ,
						 {},
						 TRANSFORM(TIDO,'@L 99'),
						 ICASE( NOT ISNULL(SERI)  , SERI   ,  '0')  AS SERIE ,
						 ICASE( NOT ISNULL(NDOC), NDOC,  '0')  AS NUMERO ,
						 '0' as ULT_NUMERO,
						 TRANSFORM(TCOM,'@L 9')
						 ICASE( NOT ISNULL(NRUC) ,NRUC, '0' )  AS RUC ,
						 ICASE( NOT ISNULL(RASO ) ,RASO, '0' )  AS NOMBRE ,
						 0.00  as VAL_EXPORT,
						 ICASE(TIDO=1 AND NVL(PASA,0) > 0 , NVL(PASA,0) , NVL(ENCO + OTIN,0) )  as VAL_AFECTO,
						 0.00  as VAL_INAFEC,
						 ICASE(TIDO=1 AND NVL(PASA,0) > 0 , NVL(EXCE,0) , NVL(PASA + EXCE,0) )  as VAL_EXONER,
						 0.00			AS IMP_ISC,
				         	 NVL(IGV,0) 		AS IMP_IGV,			   
						 0.00			AS BASIMP_IVA,
						 0.00			AS IMP_IVAP,
						 0.00			AS OTROS_TRIB ,  
						 NVL(TOGE,0) 	AS IMP_TOTAL,
				  		 2.8	 			AS CTE_TIPCAM ,
				  		 ICASE(TIDO = 7 , LdFinMes, CTOD ('01/01/1900') ) 		AS FECEMI_REF ,
				  		 ICASE( INLIST(TIDO ,7,16),  TRANSFORM(rvauxi1.TID2, '@L 99'), '00' )	AS T10_CODREF,
					     	 ICASE( INLIST( TIDO,7,16),  SUBSTR( NDO2 ,1, 3) , '-' )	AS SERIE_REF,
					     	 ICASE( INLIST( TIDO,7,16),  SUBSTR( NDO2 ,5,10), '-' )  AS NUMERO_REF,
						 '1' as ESTADO_OPE		 
				FROM 	 RVAuxi1 AS a 
				WHERE  PERIODO = <<"["+THIS.PlePeriod+"]">> 
		ENDTEXT
		&LsStrQry2.

		PUBLIC LnConn
		LsStringCnx='DRIVER=SQL Server;SERVER=192.168.3.12;DATABASE=Exactus;UID=DBO_INTERFACE;PWD=interfaces;SCHEME=oltursa;LANGUAGE=Español;TranslationName=Yes;WSID=610-HP;'
		LnConn=SQLSTRINGCONNECT(LsStringCnx)
		LsCadSql ='select * from CUENTA_CONTABLE ORDER BY CUENTA_CONTABLE'
		LnControl  = SQLEXEC(LnConn,LsCadSql,'MCtas')
		BROWSE  

		*!*	*** RUC Servicios Publicos - Perú
		*!*	Reglas:
		*!*	Fecha Documento
		XdFchDoc=iif(inlist(temporal.rucaux,'20100177774','20100152356','20331898008','20106897914','20269985900','20467534026','20100017491'),.f.,.t.)
		*!*	Fecha Vencimiento
		XdFchVto=iif(inlist(temporal.rucaux,'20100177774','20100152356','20331898008','20106897914','20269985900','20467534026','20100017491'),.T.,.F.)
	ENDPROC


	*-- Residuos de programación
	PROCEDURE junk2
				IF .F.
				TEXT TO LsStrQry  TEXTMERGE NOSHOW  PRETEXT 15

				 SELECT <<"["+THIS.PlePeriod+"]">> PERIODO  
				 					,LEFT(LOCA,60)  AS LOCA 
									,FEMI 
									,TIDO 
									,SUBSTR(TIKE,1,30)  AS TIKE 
									,SUBSTR(SERI,1,10)  AS SERI 
									,SUBSTR(NDOC,1,20) AS NDOC 
									,TCOM 
									,SUBSTR(NRUC,1,11) AS NRUC 
									,SUBSTR(RASO,1,60) AS RASO 
									,ENCO 
									,OTIN 
									,PASA 
									,EXCE 
									,IGV 
									,TOTA 
									,TOGE 
									,TID2 
									,LEFT(NDO2,30) 	AS NDO2 
									,LEFT(LOC2,60) 	AS LOC2  
									,LEFT(DELO,60) 	AS DELO 
									,LEFT(DETA,30) AS DETA 
									,LEFT(OTRO,30) AS OTRO 
									,BOLE 
									,EMBA 
								FROM <<PsCurOrigen>> 
								where ( YEAR(femi)=<<LnAno>> and MONTH(femi)=<<LnMes>> ) INTO CURSOR RVAuxi1

				ENDTEXT

				this.TxtEstadoProceso2.Caption	=	[CARGANDO REGISTROS DEL ORIGEN DE DATOS: ] + UPPER(this.cboTpoOriDat.DisplayValue  )


				** Obtenemos el archivo en version DBF , lo indexamos y sacamos backup para su uso posterior.
				&LsStrQry.
				ENDIF

				IF .F.
						LsRutaFileAcc=ADDBS(Goentorno.LocPath) + 'RV'+'AC'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
						this.TxtEstadoProceso2.Caption	=	[REALIZANDO BACKUP DE REGISTROS DEL ORIGEN DE DATOS: ] + UPPER(this.cboTpoOriDat.DisplayValue  ) + [ --> ]+ LsRutaFileAcc
						IF USED(LsRutaFileAcc)
							USE IN (LsRutaFileAcc)
						ENDIF
						COPY TO  (LsRutaFileAcc) WITH CDX
				ENDIF
	ENDPROC


	PROCEDURE generacargadorrv
		LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + 'RV'+STR(_ANO,4,0)+TRANSFORM(VAL(This.CboMes.value),'@L 99')  
		IF !USED('REGVEN')
			SELECT 0
			USE  (LcRutaFileVMOV) ALIAS REGVEN
			SET ORDER TO 
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[REINICIALIZANDO CARGADORES...] 
		this.TxtEstadoProceso1.Refresh
		this.TxtEstadoProceso2.Refresh

		** VETT  09/12/2015 11:18 AM : verificamos si hay que borrar log de errores anteriores 
		IF Thisform.OptBorraLogErrores.Value = 2
			oFS = CreateObject("Scripting.FileSystemObject")

			LsRutaTxtErr	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrCTOCTA.txt'
			IF FILE(LsRutaTxtErr)
		*!*			ERASE FILE LsRutaTxtErr 
				oFS.DeleteFile(LsRutaTxtErr)
			ENDIF
			LsRutaTxtErr1	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorRAGEN.txt'
			IF FILE(LsRutaTxtErr1)
		*!*			ERASE FILE LsRutaTxtErr1
				oFS.DeleteFile(LsRutaTxtErr1)
			ENDIF
			LsRutaTxtErr2	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorVCORP.txt'
			IF FILE(LsRutaTxtErr2)
		*!*			ERASE FILE LsRutaTxtErr2
				oFS.DeleteFile(LsRutaTxtErr2)
			ENDIF

		ENDIF
		SELECT REGVEN
		LOCATE
		IF THIS.ChkPasajes.value	=	.T.
			this.TxtEstadoProceso1.Caption	=	[REINICIALIZANDO CARGADORES DE PASAJES...] 
			REPLACE ALL CodCar WITH '' , Estado1 WITH '' FOR TIPO_VENTA='PASAJES'
			this.TxtEstadoProceso1.Caption	=	[] 
			this.TxtEstadoProceso2.Caption	=	[] 
			THIS.GeneraCargadorPasajes  
		ENDIF
		SELECT REGVEN
		LOCATE
		IF THIS.ChkCargo.value	=	.T.
			this.TxtEstadoProceso1.Caption	=	[REINICIALIZANDO CARGADORES DE CARGO...] 
			REPLACE ALL CodCar WITH '' , Estado1 WITH '' FOR TIPO_VENTA='CARGO'
			this.TxtEstadoProceso1.Caption	=	[] 
			this.TxtEstadoProceso2.Caption	=	[] 

			THIS.GeneraCargadorCargo 
		ENDIF

		SELECT REGVEN
		LOCATE
		IF THIS.ChkCancelacion1.value	=	.T.
			this.TxtEstadoProceso1.Caption	=	[REINICIALIZANDO CARGADORES DE CANCELACION 1...] 
		*!*		REPLACE ALL CodCar WITH '' , Estado1 WITH '' FOR TIPO_VENTA='CARGO'
			this.TxtEstadoProceso1.Caption	=	[] 
			this.TxtEstadoProceso2.Caption	=	[] 

			THIS.GenerarCargadorCancelacion1  

		ENDIF


		this.TxtEstadoProceso1.Caption	=	[GENERACION DE CARGADORES TERMINADO CON EXITO !] 
		this.TxtEstadoProceso2.Caption	=	[] 
		=MESSAGEBOX("PROCESO TERMINO CON EXITO.",64,'ATENCION')
	ENDPROC


	PROCEDURE reproceso_excesos

		SELECT 0
		LOCAL LcRutaFileVMOV
		LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + 'I_RV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
		USE (LcRutaFileVMOV) ALIAS regven
		SET ORDER TO NUMERO2 && TRIM(SERIE)+"-"+NUMERO
		LcRutaFileExce=ADDBS(Goentorno.LocPath) + 'EXRV'+STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
		SELECT 0
		USE  (LcRutaFileExce) ALIAS EXCesos 
		SET ORDER TO Numero && Numero
		LOCATE 
		LfTotExcesos=0
		LfTotExcePro=0
		LfValExoner = 0
		SCAN
			LsTipo=LEFT(Tipo,2)
			LsSerieNumero=TRIM(numero)
			SELECT regven
			SEEK LsTipo+LsSerieNumero
			IF FOUND()
				LfValExoner = LfValExoner + Val_exoner
				IF Val_Afecto>0
					REPLACE Val_Exoner WITH  Val_Afecto
					REPLACE Val_Afecto   WITH 0
					LfTotExcePro = LfTotExcePro + 	Val_Exoner
				ENDIF
			ENDIF
			LfTotExcesos = LfTotExcesos + Excesos.Rubro2
			SELECT EXCesos 
		ENDSCAN

		** VETT  31/07/2014 07:04 PM : Nota: Este proceso tambien se aplica para N/C sin IGV y Boletos de Viaje -> Inlist(T10_CodT10,'07','16' ) 

		WAIT WINDOW "Excesos Exonerado:"+TRIM(STR(LfValExoner,12,2)) + '  Afecto a Exonerado:'+TRIM(STR(LfTotExcePro,12,2)) + '  Total Excesos Rubro2:'+TRIM(STR(LfTotExcesos,12,2))
		WAIT WINDOW 'Proceso terminado.' NOWAIT
	ENDPROC


	*-- Busca el centro de costo y cuenta contable a asignar segun localidad y zona.
	PROCEDURE busca_ccosto_cta_cbd
		PARAMETERS PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4,PcUNegocio5 
		*!*	IF PcUnegocio2='CARGO'
		*!*		SET STEP ON 
		*!*	ENDIF
		IF VARTYPE(PcUnegocio5) <>'C'
			PcUnegocio5	= ''
		ENDIF
		IF VARTYPE(PcUnegocio4) <>'C'
			PcUnegocio4	= ''
		ENDIF
		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO LOCA
		ELSE
			SELECT CCOCT
			SET ORDER TO LOCA
		ENDIF
		LOCAL LsCCTO, LsCodCta
		STORE [] TO LsCCTO, LsCodCta
		LsRutaTxtErr	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrCTOCTA.txt'
		IF this.LlRegError1=.F.
			=STRTOFILE('****  LOG ERRORES  - CENTRO COSTO   -  CUENTA CONTABLE  -    LOCALIDAD      '+' '+TTOC(DATETIME())+' *****  '+CRLF,LsRutaTxtErr,.T.)
			This.LlRegError1 = .T.
		ENDIF


		LsCodLoc=LEFT(PcLoca,3)
		DO CASE
			CASE INLIST(PcUnegocio1,'CORP') AND PcUnegocio2='CARGO'
				SELECT * FROM  CCOCT WHERE CodLoc=LsCodLoc AND Unegocio1=PcUnegocio1 INTO CURSOR UNEG1 
				LlExiste=.F.
				SELECT UNEG1
				LOCATE
				DO CASE
					CASE PcUnegocio2='CARGO'
							IF INLIST(PcUnegocio4,'OTROSING','EXCESOS')
								LsCCTO	=	Pasaje
							ELSE
								LsCCTO	=	Cargo
							ENDIF
					OTHER
						LsCCTO	=	Pasaje
				ENDCASE
				LsCodCta	=		This.Busca_Cta_CBD(PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4 )
				LlExiste = !EMPTY(LsCcto) AND !EMPTY(LsCodCta)
				IF !LlExiste
					IF EMPTY(LsCcto)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CENTRO COSTO '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra centro de costo asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
					IF EMPTY(LsCodCta)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CUENTA CONTABLE '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra cuenta contable asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
				ENDIF
				RETURN LsCCTO+"@"+LsCodCta

			CASE INLIST(PcUnegocio1,'PLAZAVEA')
				SELECT * FROM  CCOCT WHERE CodLoc=LsCodLoc AND Unegocio1=PcUnegocio1 INTO CURSOR UNEG1 
				LlExiste=.F.
				SELECT UNEG1
				LOCATE
				DO CASE
					CASE PcUnegocio2='CARGO'
						IF INLIST(PcUnegocio4,'OTROSING','EXCESOS')
							LsCCTO	=	Pasaje
						ELSE
							LsCCTO	=	Cargo
						ENDIF

					OTHER
						LsCCTO	=	Pasaje
				ENDCASE
				LsCodCta	=		This.Busca_Cta_CBD(PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4 )
				LlExiste = !EMPTY(LsCcto) AND !EMPTY(LsCodCta)
				IF !LlExiste
					IF EMPTY(LsCcto)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CENTRO COSTO '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra centro de costo asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
					IF EMPTY(LsCodCta)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CUENTA CONTABLE '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra cuenta contable asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
				ENDIF
				RETURN LsCCTO+"@"+LsCodCta

			CASE INLIST(PcUnegocio1,'TURISMO')
				SELECT * FROM  CCOCT WHERE (CodLoc=LsCodLoc OR LsCodLoc$Unegocio3 ) AND Unegocio1=PcUnegocio1  INTO CURSOR UNEG1 
				LlExiste=.F.
				SELECT UNEG1
				LOCATE
				DO CASE
					CASE PcUnegocio2='CARGO'
						IF INLIST(PcUnegocio4,'OTROSING','EXCESOS')
							LsCCTO	=	Pasaje
						ELSE
							LsCCTO	=	Cargo
						ENDIF
					OTHER
						LsCCTO	=	Pasaje
				ENDCASE
				LsCodCta	=		This.Busca_Cta_CBD(PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4 )
				LlExiste = !EMPTY(LsCcto) AND !EMPTY(LsCodCta)
				IF !LlExiste
					IF EMPTY(LsCcto)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CENTRO COSTO '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra centro de costo asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
					IF EMPTY(LsCodCta)
						=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CUENTA CONTABLE '+CRLF,LsRutaTxtErr,.T.)
		*!*					=MESSAGEBOX('No se encuentra cuenta contable asignado a '+PcLoca,16,'ATENCION / WARNING')	 
					ENDIF
				ENDIF
				RETURN LsCCTO+"@"+LsCodCta

			OTHERWISE
				SELECT * FROM  CCOCT WHERE Unegocio1=PcUnegocio1 INTO CURSOR UNEG1  && Centro de costo corporativos
				LlExiste=.F.
				SELECT CCOCT
				SEEK TRIM(PcLoca)
				IF FOUND()
					LsZona = Zona
					IF !EOF('UNEG1')
						SELECT UNEG1
						SCAN FOR  Zona=LsZona AND !LlExiste
							DO CASE
								CASE PcUnegocio2='CARGO'
									IF INLIST(PcUnegocio4,'OTROSING','EXCESOS')
										LsCCTO	=	Pasaje
									ELSE
										LsCCTO	=	Cargo
									ENDIF
								OTHER
									LsCCTO	=	Pasaje
							ENDCASE
							LsCodCta	=		This.Busca_Cta_CBD(PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4,PcUnegocio5 )
							LlExiste = .T.
						 ENDSCAN 
					 ELSE
						SELECT CCOCT	 
						DO CASE
							CASE PcUnegocio2='CARGO'
								IF INLIST(PcUnegocio4,'OTROSING','EXCESOS')
									LsCCTO	=	Pasaje
								ELSE
									LsCCTO	=	Cargo
								ENDIF
							OTHER
								LsCCTO	=	Pasaje
						ENDCASE
						LsCodCta	=		This.Busca_Cta_CBD(PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUnegocio4 )
						LlExiste = .T.

					 ENDIF
					 SELECT CCOCT
					 IF LlExiste 
						IF EMPTY(LsCcto)
							=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CENTRO COSTO '+CRLF,LsRutaTxtErr,.T.)
			*!*					=MESSAGEBOX('No se encuentra centro de costo asignado a '+PcLoca,16,'ATENCION / WARNING')	 
						ENDIF
						IF EMPTY(LsCodCta)
							=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +'  SIN CUENTA CONTABLE '+CRLF,LsRutaTxtErr,.T.)
			*!*					=MESSAGEBOX('No se encuentra cuenta contable asignado a '+PcLoca,16,'ATENCION / WARNING')	 
						ENDIF
					 ENDIF
				ELSE
		*!*				=MESSAGEBOX('No se encuentra localidad: '+PcLoca,16,'ATENCION / WARNING')	 
					=STRTOFILE('Documento:' +REGVEN.t10_codt10 + '-'+ TRIM(REGVEN.SERIE) + '-'+  TRIM(REGVEN.NUMERO) +' No se encuentra localidad: '+PcLoca+CRLF,LsRutaTxtErr,.T.)
				ENDIF

				RETURN LsCCTO+"@"+LsCodCta
		ENDCASE
	ENDPROC


	*-- Verifica si se ha creado estructura DBF del cargador y si existe borra datos de proceso anterior.
	PROCEDURE verificadbfcargador
		PARAMETERS PsCargadorRutaArc,PcTipoStruc,PcAliasCurDestino
		IF VARTYPE(PcTipoStruc)<>'C'
			PcTipoStruc		=	''
		ENDIF
		IF EMPTY(PcTipoStruc)
			PcTipoStruc		=	'1'
		ENDIF
		IF VARTYPE(PcAliasCurDestino)<>'C'
			PcAliasCurDestino	=	'Cargador1'
		ENDIF 
		THISFORM.closetable(PcAliasCurDestino)  
		LsFileCargadorRV1 = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(PsCargadorRutaArc) 
		** VETT  02/08/2018 02:00 PM : *** Por ahora mejor eliminamos de la BD logica y fisica para evitar error de table corrupta  : IDUPD: _59G0U09F4 
		IF TRIM(UPPER(PsCargadorRutaArc))='C15_'
		*!*		SET STEP ON 
		ENDIF
		IF FILE(LsFileCargadorRV1+[.DBF])
			IF DBUSED('INTERFACE')
				SET DATABASE TO INTERFACE
			ELSE
				OPEN DATABASE INTERFACE
			ENDIF
			LsTableName=JUSTSTEM(LsFileCargadorRV1)
			REMOVE TABLE (LsTableName)  DELETE

		ENDIF
		** VETT  02/08/2018 02:01 PM : Y la volvemos a reconstruir  : IDUPD: _59G0U09F4  
		IF !FILE(LsFileCargadorRV1+[.DBF])

			IF DBUSED('INTERFACE')
				SET DATABASE TO INTERFACE
			ELSE
				OPEN DATABASE INTERFACE
			ENDIF
		*!*		WAIT WINDOW 'CREANDO CARGADOR DEL PROCESO ANTERIOR ...'+LsFileCargadorRV1 NOWAIT
			THIS.TxtEstadoProceso2.Caption	=	'CREANDO ESTRUCTURA '+LsFileCargadorRV1 +' EN LA BASE DE DATOS INTERFACE'

			SELECT 0
			DO CASE 
				CASE	PcTipoStruc		=	'1' 

					CREATE TABLE  (LsFileCargadorRV1)   ( ;
									CLIENTE C(20) , ;
									ORIGEN   C(20) , ;
									TIPO	C(3) , ;
									DOCUMENTO C(30) ,;
									FECHA_DOCUMENTO C(10),;
									APLICACION C(40),;
									SUBTOTAL	N(16,2),;
									DESCUENTO N(16,2),;
									IMPUESTO1 N(16,2),;
									IMPUESTO2 N(16,2),;
									RUBRO1	N(16,2),;
									RUBRO2	N(16,2),;
									MONTO		N(16,2),;
									SALDO		C(16),;
									MONEDA	C(4),;
									CONDICION_PAGO 	C(4),;
									TASA_INTERES_CORRIENTE N(3),;
									CUENTA_BANCARIA C (20) ,;
									NUM_DOC_CB	C(12),;
									VENDEDOR C(4) ,;
									COBRADOR C(4) ,;
									NOTAS C(30),;
									SUBTIPO C(40),;
									CENTRO_COSTO C(20),;
									CUENTA_CONTABLE C(20),;
									PAQUETE C(4) ,;
									TIPO_REFERENCIA C(3),;
									DOC_REFERENCIA C(20),;
									TIPO_VENTA	C(20) ,;
									TIPO_DE_ASIENTO C(20) DEFAULT 'PV')

							USE	(LsFileCargadorRV1)  ALIAS (PcAliasCurDestino) EXCLUSIVE
							INDEX on IIF(cliente=REPLICATE('0',11),'1','2')+cuenta_bancaria TAG caja1
							SET ORDER TO 


				CASE	PcTipoStruc		=	'2'

					CREATE TABLE  (LsFileCargadorRV1)   ( ;
									PROVEEDOR C(20) , ;
									TIPO	C(3) , ;
									DOCUMENTO C(12) ,;
									FECHA_DOCUMENTO C(10),;
									FECHA_RIGE C(10),;
									APLICACION C(60),;
									SUBTOTAL	N(16,2),;
									DESCUENTO N(16,2),;
									IMPUESTO1 N(16,2),;
									IMPUESTO2 N(16,2),;
									RUBRO1	N(16,2),;
									RUBRO2	N(16,2),;
									MONTO		N(16,2),;
									SALDO		N(16,2),;
									MONEDA	C(4),;
									CONDICION_PAGO 	C(4),;
									CUENTA_BANCARIA C (20) ,;
									NOTAS C(30),;
									SUBTIPO C(40),;
									CENTRO_COSTO C(20),;
									CUENTA_CONTABLE C(20),;
									FECHA_CONTABLE C(10),;
									RUBRO_1_DOC N(16,2),;
									RUBRO_2_DOC N(16,2),;
									RUBRO_3_DOC N(16,2),;
									RUBRO_4_DOC N(16,2),;
									RUBRO_5_DOC N(16,2),;
									RUBRO_6_DOC N(16,2),;
									RUBRO_7_DOC N(16,2),;
									RUBRO_8_DOC N(16,2),;
									RUBRO_9_DOC N(16,2),;
									RUBRO_10_DOC N(16,2),;
									PAQUETE C(4) ,;
									RETENCION N(16,2),;
									EMBARQUE  N(16,2),;
									TIPO_DOC_ASOCIADO C(3),;
									DOC_ASOCIADO C(20)  )

					USE	(LsFileCargadorRV1)  ALIAS (PcAliasCurDestino) EXCLUSIVE

			ENDCASE

		ELSE
			SELECT 0
			USE	(LsFileCargadorRV1)  ALIAS (PcAliasCurDestino) EXCLUSIVE
			ZAP
			DO CASE
				CASE	PcTipoStruc		=	'1'
					INDEX on IIF(cliente=REPLICATE('0',11),'1','2')+cuenta_bancaria TAG caja1
					SET ORDER TO 
				CASE	PcTipoStruc		=	'2'
			ENDCASE
		*!*		WAIT WINDOW 'BORRANDO DATOS DEL CARGADOR ANTERIOR ...'+LsFileCargadorRV1 NOWAIT
				this.TxtEstadoProceso2.Caption =	'BORRANDO DATOS DEL CARGADOR ANTERIOR ...'+LsFileCargadorRV1
		ENDIF
	ENDPROC


	PROCEDURE busca_cta_cbd
		PARAMETERS  PcLoca,PcUnegocio1,PcUnegocio2,PcUnegocio3,PcUNegocio4,PcUnegocio5
		IF VARTYPE(PcUnegocio5) <>'C'
			PcUnegocio5	= ''
		ENDIF
		IF VARTYPE(PcUnegocio4) <>'C'
			PcUnegocio4	= ''
		ENDIF
		LOCAL LsCodCta
		LsCodCta = ''
		IF   NOT  'CANCELACION'$UPPER(PcUnegocio5)  && Cuenta Contable usada en cargadores de  PROVISION
			DO CASE
				CASE PcUnegocio2='PASAJE' AND PcUnegocio3='CRED'
					LsCodCta		=	N_PasCreCt
				CASE PcUnegocio2='PASAJE' AND PcUnegocio3='CONT'
					LsCodCta		=	N_PasConCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CRED'  AND INLIST(PcUNegocio4,'OTROSING')
					LsCodCta		=	N_OtrCreCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CONT'  AND INLIST(PcUNegocio4,'OTROSING')
					LsCodCta		=	N_OtrConCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CRED'  AND INLIST(PcUNegocio4,'EXCESOS')
					LsCodCta		=	N_ExcCreCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CONT' 	AND INLIST(PcUNegocio4,'EXCESOS')
					LsCodCta		=	N_ExcConCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CRED'  AND INLIST(PcUNegocio4,'ENCOMIENDA')
					LsCodCta		=	N_CarCreCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CONT'  AND INLIST(PcUNegocio4,'ENCOMIENDA')
					LsCodCta		=	N_CarConCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CRED'  AND EMPTY(PcUNegocio4)
					LsCodCta		=	N_CarCreCt
				CASE PcUnegocio2='CARGO' AND PcUnegocio3='CONT'  AND EMPTY(PcUNegocio4)
					LsCodCta		=	N_CarConCt

				OTHER
					LsCodCta = ''
			ENDCASE
		ELSE
			DO CASE
				CASE PcUnegocio5='CANCELACION1'
					LsCodCta = CtaCaja
				CASE PcUnegocio5='CANCELACION2'
				OTHERWISE
					LsCodCta = ''
			ENDCASE
		ENDIF
		RETURN LsCodcta
	ENDPROC


	PROCEDURE generacargadorcargo
		**+++++++++++++++++++++++++++++++++++++++++++++**
		**+++++++++++++++++++++++++++++++++++++++++++++**
		**                             C        A        R       G        O
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		**+++++++++++++++++++++++++++++++++++++++++++++**
		m.FchDoc1	=	THIS.TxtFchDocD.Value 
		m.FchDoc2	=	THIS.TxtFchDocH.Value 
		XFOR3	=	'.T.'
		DO CASE
		   CASE EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi<=m.fchdoc2"
		        m.titulo1 = [Emitidos hasta el ]+DTOC(m.FchDoc2)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi>=m.fchdoc1"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "(Cte_FecEmi<=m.fchdoc2 AND Cte_FecEmi>=m.fchdoc1)"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ hasta el ]+DTOC(m.FchDoc2)+[ ]
		   OTHER
		        XFOR3 = ".T."
		        m.titulo1 = []
		ENDCASE
		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 06 CARGO PROVISIÓN ENCOMIENDA CREDITO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre06 		=	'06 CARGO PROVISIÓN ENCOMIENDA CREDITO'
		This.CargadorRutaArchivo06		=	'C06_CARGO_PROV_ENCO_CREDITO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre06  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo06) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    AND ( DETA='CR' OR INLIST(serie,'0080' ,'0956','F080' ,'F956')  )  AND DETA_VENTA = 'ENCOMIENDA' ;
			AND EVALUATE(XFOR3)  ;
			 TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='CARGO'  AND EMPTY(CODCAR)  ; 
				AND ( DETA='CR' OR INLIST(serie,'0080' ,'0956','F080' ,'F956')  )   AND DETA_VENTA = 'ENCOMIENDA' ;
				AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
		*!*		REPLACE CLIENTE				WITH 	 m.RUC  && REPLICATE('0',11) 	&&
			** VETT  01/08/2018 11:43 AM : SI N/C de Factura electronica tambien debe ir RUC origen : IDUPD: _59F0P4IPP 
			REPLACE CLIENTE	WITH IIF((m.t10_codt10='01' AND m.Serie='F') OR (m.t10_codt10='07' AND m.Serie='F'),m.RUC , REPLICATE('0',11) ) 	&&  m.RUC 
			** VETT  01/08/2018 11:43 AM :  : IDUPD: _59F0P4IPP 

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:48 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)

			REPLACE APLICACION			WITH 	m.Nombre

			** VETT  01/08/2018 10:04 AM : Agregar letra a serie referencia de N/C si doc origen es electrónico : IDUPD: _59F0LLDDL 
			IF m.T10_CODT10='07'
				LsLetras_SerRef=RTRIM(chrtran( m.serie_ref, "1234567890", "" ))
				IF INLIST(LsLetras,'F','B')
					IF EMPTY(LsLetras_SerRef)
						m.Serie_Ref = LsLetras+RIGHT(m.Serie_Ref,3)
					ELSE
					 
					ENDIF

				ENDIF
			ELSE
				LsLetras_SerRef=''
			ENDIF
			** VETT  01/08/2018 10:15 AM :  : IDUPD: _59F0LLDDL  

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00						&& CARGADOR 06
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')

					OTHERWISE
						REPLACE APLICACION WITH  'VENTA CARGO CRÉDITO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE

				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 06
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 06
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA
			 IF '956'$m.SERIE AND '10153'$m.NUMERO
		*!*		 	SET STEP ON 
			 ENDIF
			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CREDITO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C06'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre06) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre06 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 


		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 07 CARGO PROVISIÓN OTROS INGRESOS CREDITO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre07 		=	'07 CARGO PROVISIÓN OTROS INGRESOS CREDITO'
		This.CargadorRutaArchivo07		=	'C07_CARGO_PROV_OTROS_INGRE_CREDITO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre07  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo07) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    AND ( DETA='CR' OR INLIST(serie,'0958' )  )  AND DETA_VENTA = 'OTROSING' ;
			AND EVALUATE(XFOR3)  TO LnTotReg
		 
		LnRegAct = 0
		StepON = .F.
		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='CARGO'  AND DETA_VENTA = 'OTROSING'  ;
			AND EMPTY(CODCAR)   AND ( DETA='CR' OR INLIST(serie,'0958' )  )    AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	 m.RUC  && REPLICATE('0',11) 	&&
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:49 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)

			REPLACE APLICACION			WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH  'N/C '+' CREDITO / '  + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00	                      && CARGADOR 07                  
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CREDITO / '  + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					OTHERWISE
						REPLACE APLICACION WITH  'VENTA OTROS ING. CREDITO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE

				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO    && CARGADOR 07
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA
			IF StepON=.T.
				SET STEP ON
			ENDIF 
			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CREDITO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	'OTROS_INGRESOS' && m.TIPO_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'

				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C07'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre07) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre07 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 09 CARGO PROVISIÓN EXCESOS CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre09 		=	'09 CARGO PROVISIÓN EXCESOS CONTADO'
		This.CargadorRutaArchivo09		=	'C09_CARGO_PROV_EXCESOS_CONTADO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre10  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo09) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    AND DETA_VENTA = 'EXCESOS'  AND  !( DETA='CR'  )    AND EVALUATE(XFOR3)  TO LnTotReg
		 
		LnRegAct = 0
		StepON=.F.
		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='CARGO'  AND EMPTY(CODCAR)  ;
				AND DETA_VENTA = 'EXCESOS'  AND  !( DETA='CR'  )   AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			** VETT  01/08/2018 11:43 AM : SI N/C de Factura electronica tambien debe ir RUC origen : IDUPD: _59F0P4IPP 
			REPLACE CLIENTE	WITH IIF((m.t10_codt10='01' AND m.Serie='F') OR (m.t10_codt10='07' AND m.Serie='F'),m.RUC , REPLICATE('0',11) ) 	&&  m.RUC 
			** VETT  01/08/2018 11:43 AM :  : IDUPD: _59F0P4IPP 

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:49 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)

			REPLACE APLICACION			WITH 	m.Nombre

			** VETT  01/08/2018 10:04 AM : Agregar letra a serie referencia de N/C si doc origen es electrónico : IDUPD: _59F0LLDDL 
			IF m.T10_CODT10='07'
				LsLetras_SerRef=RTRIM(chrtran( m.serie_ref, "1234567890", "" ))
				IF INLIST(LsLetras,'F','B')
					IF EMPTY(LsLetras_SerRef)
						m.Serie_Ref = LsLetras+RIGHT(m.Serie_Ref,3)
					ELSE
					 
					ENDIF

				ENDIF
			ELSE
				LsLetras_SerRef=''
			ENDIF
			** VETT  01/08/2018 10:15 AM :  : IDUPD: _59F0LLDDL  

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00						&& CARGADOR 09
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					OTHERWISE
						REPLACE APLICACION WITH  'VENTA EXCESOS CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO    		&& CARGADOR 09
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00								&& CARGADOR 09
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')
			IF EMPTY(subtipo)
				SET STEP ON 
			ENDIF
			LsFiltro3	=	m.TIPO_VENTA
			IF StepON=.T.
				SET STEP ON
			ENDIF 
			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CONTADO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.DETA_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C09'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre09) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre09 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 10 CARGO PROVISIÓN OTROS INGRESOS CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre10 		=	'10 CARGO PROVISIÓN OTROS INGRESOS CONTADO'
		This.CargadorRutaArchivo10		=	'C10_CARGO_PROV_OTROS_INGRE_CONTADO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre10  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo10) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    AND DETA_VENTA = 'OTROSING'  AND  !( DETA='CR' OR INLIST(serie,'0958' ) OR LOCA='LIM-TER-SAN ISIDRO OTROS' ) ;
			AND EVALUATE(XFOR3)   TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='CARGO'  AND EMPTY(CODCAR)   AND  DETA_VENTA = 'OTROSING'  ;
							AND  !( DETA='CR' OR INLIST(serie,'0958' ) OR LOCA='LIM-TER-SAN ISIDRO OTROS' )   AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK

		*!*		REPLACE CLIENTE				WITH 	  REPLICATE('0',11) 	&&  m.RUC 

			** VETT  01/08/2018 11:43 AM : SI N/C de Factura electronica tambien debe ir RUC origen : IDUPD: _59F0P4IPP 
			REPLACE CLIENTE	WITH IIF((m.t10_codt10='01' AND m.Serie='F') OR (m.t10_codt10='07' AND m.Serie='F'),m.RUC , REPLICATE('0',11) ) 	&&  m.RUC 
			** VETT  01/08/2018 11:43 AM :  : IDUPD: _59F0P4IPP 

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 	WITH 	'N/C' 
					m.VAL_AFECTO	=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV		=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 	=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				CASE m.t10_codt10='01'
					REPLACE TIPO 				WITH 	'FAC' 
					REPLACE CLIENTE				WITH 	 m.RUC 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 

			ENDCASE
			** VETT  25/08/2016 04:50 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)

			REPLACE APLICACION			WITH 	m.Nombre

			** VETT  01/08/2018 10:04 AM : Agregar letra a serie referencia de N/C si doc origen es electrónico : IDUPD: _59F0LLDDL 
			IF m.T10_CODT10='07'
				LsLetras_SerRef=RTRIM(chrtran( m.serie_ref, "1234567890", "" ))
				IF INLIST(LsLetras,'F','B')
					IF EMPTY(LsLetras_SerRef)
						m.Serie_Ref = LsLetras+RIGHT(m.Serie_Ref,3)
					ELSE
					 
					ENDIF
				ENDIF
			ELSE
				LsLetras_SerRef=''
			ENDIF
			** VETT  01/08/2018 10:15 AM :  : IDUPD: _59F0LLDDL  

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00								&& CARGADOR 10
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					OTHERWISE
						REPLACE APLICACION WITH  'VENTA OTROS ING. CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE

				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 10
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 10
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO		WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CONTADO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO	WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA		WITH	'OTROS INGRESOS' && 'OTROS_INGRESOS' && m.TIPO_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_REF='F','FAC',m.Serie_REF='B','B/V','FAC') && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH 	TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR 	WITH 	'C10'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre10) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre10 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 


		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 11 CARGO PROVISIÓN ENCOMIENDA CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre11 		=	'11 CARGO PROVISIÓN ENCOMIENDA CONTADO'
		This.CargadorRutaArchivo11		=	'C11_CARGO_PROV_ENCO_CONTADO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre11
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo11) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    AND  DETA_VENTA = 'ENCOMIENDA'  AND  !( DETA='CR' OR INLIST(serie,'0080' ,'0956','F956')  )  ;
			AND EVALUATE(XFOR3)   TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='CARGO'  AND EMPTY(CODCAR)   ;
			AND  DETA_VENTA = 'ENCOMIENDA'  AND  !( DETA='CR' OR INLIST(serie,'0080' ,'0956','F956')  )     AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK

			** VETT  01/08/2018 11:43 AM : SI N/C de Factura electronica tambien debe ir RUC origen : IDUPD: _59F0P4IPP 
			REPLACE CLIENTE	WITH IIF((m.t10_codt10='01' AND m.Serie='F') OR (m.t10_codt10='07' AND m.Serie='F'),m.RUC , REPLICATE('0',11) ) 	&&  m.RUC 
			** VETT  01/08/2018 11:43 AM :  : IDUPD: _59F0P4IPP 

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 		WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER		=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 		WITH 	'B/V' 
				OTHER
					REPLACE TIPO 		WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:50 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			** VETT  01/08/2018 10:04 AM : Agregar letra a serie referencia de N/C si doc origen es electrónico : IDUPD: _59F0LLDDL 
			IF m.T10_CODT10='07'
				LsLetras_SerRef=RTRIM(chrtran( m.serie_ref, "1234567890", "" ))
				IF INLIST(LsLetras,'F','B')
					IF EMPTY(LsLetras_SerRef)
						m.Serie_Ref = LsLetras+RIGHT(m.Serie_Ref,3)
					ELSE
					 
					ENDIF
				ENDIF
			ELSE
				LsLetras_SerRef=''
			ENDIF
			** VETT  01/08/2018 10:15 AM :  : IDUPD: _59F0LLDDL  

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 11
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C  CARGO CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					OTHERWISE
						REPLACE APLICACION WITH 'VENTA CARGO  CONTADO / ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE

				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO			&& CARGADOR 11
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00								&& CARGADOR 11
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO		WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CONTADO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE		WITH	LsCta
			REPLACE PAQUETE				WITH	'CC'
			REPLACE TIPO_VENTA			WITH	'ENCOMIENDAS'	&& m.DETA_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_REF='F','FAC',m.Serie_REF='B','B/V','FAC') && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH 	TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR 	WITH 	'C11'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre11) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre11 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 16 CARGO PROVISIÓN ANULADOS CARGO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre16 		=	'16 CARGO PROVISIÓN ANULADOS'
		This.CargadorRutaArchivo16		=	'C16_CARGO_PROV_ANULADOS_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre16
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo16) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'2')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    	AND EVALUATE(XFOR3)   TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR  INLIST(Estado_OPE,'2')  AND  Tipo_Venta='CARGO' ;
			AND EMPTY(CODCAR)    	AND EVALUATE(XFOR3)

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	 IIF(m.t10_codt10='01',m.RUC , REPLICATE('0',11) ) && m.RUC   	&&
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:51 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			LnLong		=LEN(LsSerie)
			REPLACE DOCUMENTO 		WITH 	LsLetras+RIGHT(REPLICATE('0',LnLong)+LTRIM(STR(VAL(LsSERIE),LnLong,0)),LnLong) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C '+' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 16
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				DO CASE
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C  CARGO  / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref + +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					OTHERWISE
						REPLACE APLICACION WITH 'VENTA CARGO  / ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE

				IF m.IMP_IGV<>0

					REPLACE SUBTOTAL  		WITH 	m.VAL_EXONER + m.VAL_AFECTO			&& CARGADOR 16
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	SUBTOTAL + IMPUESTO1
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO			&& CARGADOR 16
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA
			** VETT  16/12/2015 02:43 PM : ENCOMIENDA 
			m.DETA_VENTA	=	'ENCOMIENDA'
			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXXX',LsFiltro3,'CONTADO',m.DETA_VENTA)

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.DETA_VENTA

			** VETT  13/06/2015 01:51 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C16'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre16) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre16 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 
	ENDPROC


	PROCEDURE generacargadorpasajes
		**+++++++++++++++++++++++++++++++++++++++++++++**
		**+++++++++++++++++++++++++++++++++++++++++++++**
		**                   P        A        S       A        J       E       S                   **
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		**+++++++++++++++++++++++++++++++++++++++++++++**
		m.FchDoc1	=	THIS.TxtFchDocD.Value 
		m.FchDoc2	=	THIS.TxtFchDocH.Value 
		XFOR3	=	'.T.'
		XFOR4	=	'.T.'
		DO CASE
		   CASE EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi<=m.fchdoc2"
		        m.titulo1 = [Emitidos hasta el ]+DTOC(m.FchDoc2)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi>=m.fchdoc1"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "(Cte_FecEmi<=m.fchdoc2 AND Cte_FecEmi>=m.fchdoc1)"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ hasta el ]+DTOC(m.FchDoc2)+[ ]
		   OTHER
		        XFOR3 = ".T."
		        m.titulo1 = []
		ENDCASE

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 01 PROVISION CREDITO BOLETOS CORPORATIVO
		**+++++++++++++++++++++++++++++++++++++++++++++** 

		This.CargadorNombre01		= '01 PASAJES PROVISION CREDITO BOLETOS CORPORATIVO'
		This.CargadorRutaArchivo01	= 'C01_PASAJES_PROV_CRED_BOL_CORP_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre01  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo01) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		*!*	WAIT WINDOW 'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....' NOWAIT

		LnTotReg = 0
		SELECT  REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ; 
			AND DETA='CR' ;
			OR ( 'AUSTRAL'$UPPER(LOC2) OR  'TASA'$UPPER(LOC2)  )  AND EVALUATE(XFOR3) ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='PASAJE' AND ;
				DETA='CR' OR ( 'AUSTRAL'$UPPER(LOC2) OR  'TASA'$UPPER(LOC2) )   AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	m.ruc &&REPLICATE('0',11) 
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			** VETT  25/08/2016 04:41 PM : 
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			DO CASE
				CASE m.T10_CODT10='16'
					REPLACE APLICACION WITH 'VENTA PASAJE CORP CREDITO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
				CASE m.T10_CODT10='07'
					REPLACE APLICACION WITH 'N/C'+ ' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

			ENDCASE

			IF 	m.T10_CODT10='16'  && OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				** VETT  17/06/2015 03:46 PM : Modificaciòn segùn Manuel H. 
				REPLACE SUBTOTAL  		WITH	0 && m.VAL_EXONER + m.VAL_AFECTO     	&& CARGADOR 01
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				REPLACE SUBTOTAL  		WITH 	0 						&& m.VAL_EXONER + m.VAL_AFECTO				&& CARGADOR 01
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1	&& SUBTOTAL + IMPUESTO1
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')


			LsFiltro3	=	m.TIPO_VENTA


			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'CORP',LsFiltro3,'CREDITO')

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA

			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C01'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto
		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre01) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre01 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 02 PROVISION CREDITO PUNTOS
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre02		= '02 PASAJES PROVISION CREDITO PUNTOS'
		This.CargadorRutaArchivo02	= 'C02_PASAJES_PROV_CRED_PUNTOS_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre02  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo02) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND DETA='PT'   AND EVALUATE(XFOR3) ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND DETA='PT'  AND  Tipo_Venta='PASAJE'    AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	m.RUC   &&REPLICATE('0',11) 
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:41 PM :  
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH 'VENTA PASAJE CORP PTOS CRED ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C'+ ' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00
				** VETT  29/08/2014 12:11 PM : Correcion DAVID 
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO      &&- VAL(m.OTRO)  
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				REPLACE SUBTOTAL  		WITH 	0 && m.VAL_EXONER + m.VAL_AFECTO	&& CARGADOR 02
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1					&& SUBTOTAL + IMPUESTO1		&& CARGADOR 02
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

		*!*		LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXX',LsFiltro3,'CREDITO')
			** VETT  17/06/2015 03:56 PM : Modificaciòn segòn Manuel H. 
			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'CORP',LsFiltro3,'CREDITO')
			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA

			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF


			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C02'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre02) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1


		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre02 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 03 PROVISION CREDITO PLAZA VEA
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre03		= '03 PASAJES PROVISION CREDITO PLAZA VEA'
		This.CargadorRutaArchivo03	= 'C03_PASAJES_PROV_CRED_PLAZAVEA_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre03  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo03) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND 'PLAZA'$UPPER(LOC2) AND 'VEA'$UPPER(LOC2)    AND EVALUATE(XFOR3) ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' AND 'PLAZA'$UPPER(LOC2) AND 'VEA'$UPPER(LOC2) ;
					  AND EVALUATE(XFOR3) 
					  
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	'20100070970' && '20100709070'    && '20514383708' &&REPLICATE('0',11) 
			** VETT  31/07/2018 07:15 PM : Ruc del cliente si es Factura Electrónica : IDUPD: _59E159FMN 
			IF m.t10_codt10='01' AND m.SERIE='F'
				REPLACE CLIENTE			WITH m.RUC
			ENDIF
			** VETT  31/07/2018 07:15 PM :  : IDUPD: _59E159FMN

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:42 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION		WITH 	TRIM(m.NDO2)+' '+TRIM(m.LOC2)	&& m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
		*!*					REPLACE APLICACION WITH RIGHT(TRIM(m.SERIE_REF),4)+'-'+TRIM(m.NUMERO_REF) +' VTA.PLAZA VEA CRÉD ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
						REPLACE APLICACION		WITH 	TRIM(m.NDO2)+' '+TRIM(m.LOC2)+IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C'+ ' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 03
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				REPLACE SUBTOTAL  		WITH 	0 			&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 03
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1		&& CARGADOR 03
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOC2),'PLAZAVEA',LsFiltro3,'CREDITO')

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA

			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C03'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre03) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre03 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 04 PROVISION CREDITO AGENCIAS
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre04		= '04 PASAJES PROVISION CREDITO AGENCIAS'
		This.CargadorRutaArchivo04	= 'C04_PASAJES_PROV_CRED_AGENCIAS_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre04  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo04) 

		** Capturamos informacion de ruc de agencias 
		LsRutaFileAcc	=ADDBS(Goentorno.LocPath) + 'RAGEN'+This.PLEPeriod
		LsRutaTxtErr1	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorRAGEN.txt'
		=STRTOFILE('****  LOG ERRORES '+This.CargadorNombre04+' '+TTOC(DATETIME())+' *****  '+CRLF,LsRutaTxtErr1,.T.)
		SELECT 0
		USE (LsRutaFileAcc) ALIAS RAGEN
		SET ORDER TO RASO

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		XFOR4 = [ (t10_codt10='07' AND !INLIST(Serie,'F','B'))  ]
		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND ('AGT'$UPPER(LOC2)  OR SUBSTR(LOCA,5,3)='AGT')  AND EVALUATE(XFOR3) and !EVALUATE(XFOR4)  ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT

		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='PASAJE' AND ('AGT'$UPPER(LOC2)  OR SUBSTR(LOCA,5,3)='AGT') AND EVALUATE(XFOR3) and !EVALUATE(XFOR4) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	m.RUC  &&REPLICATE('0',11) 

			IF '291'$m.Serie AND  '83095'$m.NUMERO
		*!*			SET STEP ON 
			ENDIF
			IF 'FRAXI'$m.Loc2
		*!*			SET STEP ON 
			ENDIF
			LsAgencia= UPPER(RTRIM(m.Loc2))
			LsAgencia=IIF(LEN(LsAgencia)>LEN(RAGEN.RASO),PADR(LsAgencia,LEN(RAGEN.RASO)),LsAgencia)
			IF !SEEK(LsAgencia,'RAGEN','RASO')
				=STRTOFILE('Documento:' +m.t10_codt10 + '-'+  LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO) +  '  NO TIENE RUC ASOCIADO A AGENCIA (LOC2) '+m.LOC2+CRLF,LsRutaTxtErr1,.T.)
			ELSE
		*!*			IF EMPTY(m.Ruc) OR VAL(m.RUC)=0
				** VETT  23/08/2018 02:05 PM : RUC de agencia solo para Boletas : IDUPD: _5A10U729P 
				IF	m.t10_codt10='03'  && Boletas 
					REPLACE CLIENTE WITH RAGEN.NRUC
				ENDIF
		*!*			ENDIF
			ENDIF

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:43 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION		WITH 	TRIM(m.NDO2)+' '+TRIM(m.LOC2)	&& m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  RIGHT(TRIM(m.SERIE_REF),4)+'-'+TRIM(m.NUMERO_REF) +' CRED AGEN ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
		*!*					REPLACE APLICACION WITH 'N/C'+ ' CREDITO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')
						REPLACE APLICACION		WITH 	TRIM(m.NDO2)+' '+TRIM(m.LOC2)+IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00							&& CARGADOR 04
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				REPLACE SUBTOTAL  		WITH 	0 && m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 04
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1		&& CARGADOR 04
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			IF m.DELO='AGV'   && Agencias Virtuales - BUSPORTAL
				LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'BUSPORTAL',LsFiltro3,'CREDITO')
			ELSE
				LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOC2),'TURISMO',LsFiltro3,'CREDITO')
			ENDIF
			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA
			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C04'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre04) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre04 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 12 PROVISIÓN BOLETOS CORPORATIVO
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre12			=	'12 PASAJES PROVISIÓN BOLETOS CORPORATIVO' 
		This.CargadorRutaArchivo12		=	'C12_PASAJES_PROV_BOLE_CORP_CONT_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre12  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo12) 

		this.TxtEstadoProceso2.Caption =  'BUSCANDO EN INFORME CORPORATIVO....'


		** Capturamos informacion de venta corporativa
		LsRutaFileAcc	=ADDBS(Goentorno.LocPath) + 'VCORP'+This.PLEPeriod
		LsRutaTxtErr2	=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorVCORP.txt'
		=STRTOFILE('****  LOG ERRORES '+This.CargadorNombre12+' '+TTOC(DATETIME())+' *****  '+CRLF,LsRutaTxtErr2,.T.)

		SELECT REGVEN
		SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO

		LnTotReg = 0
		LnRegAct = 0
		SELECT 0
		USE (LsRutaFileAcc) ALIAS VCORP
		SET ORDER TO SERIE   && TIDO+SERI+NDOC
		LnTotReg = RECCOUNT()
		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		SELECT VCORP
		SCAN 
			IF '73760'$ndoc
		*!*			SET STEP ON 
			ENDIF
			LsDocVCORP='Documento:' +VCORP.TIDO + '-'+ TRIM(VCORP.SERI) + '-'+  TRIM(VCORP.NDOC) 
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'DOCUMENTO: ' + LsDocVCORP+ ' - '+ TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF
			LsNumeroDoc=TIDO+PADR(RIGHT('00'+TRIM(SERI),4),LEN(REGVEN.Serie))+PADR(NDOC,LEN(REGVEN.NUMERO))
			SELECT  REGVEN
			SEEK LsNumeroDoc
			IF FOUND()
				IF INLIST(DETA,'CR','PT') OR ( 'AUSTRAL'$UPPER(LOC2) OR  'TASA'$UPPER(LOC2)  ) 
				ELSE
					IF  Tipo_Venta='PASAJE'  AND EMPTY(REGVEN.CodCar)

						REPLACE ESTADO1 WITH 'C12'  IN VCORP   && Pertenecen al cargador de 12 PROVISIÓN BOLETOS CORPORATIVO
						REPLACE CODCAR  WITH 'C12'  IN REGVEN 
					ENDIF
				ENDIF
			ELSE

				=STRTOFILE('Documento:' +VCORP.TIDO + '-'+ TRIM(VCORP.SERI) + '-'+  TRIM(VCORP.NDOC) +'  NO ESTA REGISTRADO EN REGISTRO VENTAS  INFORME FINAL '+CRLF,LsRutaTxtErr2,.T.)
			ENDIF
			SELECT VCORP
		ENDSCAN

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		SET ORDER TO TIPO2
		LOCATE
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND CODCAR = 'C12'   AND EVALUATE(XFOR3)  ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE'  AND CODCAR = 'C12'   AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	 REPLICATE('0',11) 	&& m.RUC 

			IF m.t10_codt10='01' AND m.SERIE='F'
				REPLACE CLIENTE			WITH m.RUC
			ENDIF
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER		=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:44 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION		WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CORP CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C'+ ' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				IF m.T10_CODT10='07'
					REPLACE SUBTOTAL  		WITH 	0 	&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 12
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1		&& CARGADOR 12
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ELSE
				REPLACE SUBTOTAL  		WITH 	0	&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 12
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1 	&& CARGADOR 12
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO		WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'CORP',LsFiltro3,'CONTADO')

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE		WITH	LsCta
			REPLACE PAQUETE				WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA
			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(m.CodCar='C12' AND EMPTY(m.ESTADO1),'',IIF(EMPTY(m.CODCAR),'',IIF(EMPTY(TRIM(m.ESTADO1)),'',',')+m.CODCAR) )
			REPLACE CODCAR 	WITH 'C12'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre12) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre12+ [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 


		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 14 PROVISIÓN BOLETOS ONLINE CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre14 		=	'14 PASAJES PROVISIÓN BOLETOS ONLINE CONTADO'
		This.CargadorRutaArchivo14		=	'C14_PASAJES_PROV_BOLE_ONLINE_CONTADO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre14  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo14) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND ( 'VEN'$UPPER(DELO) OR 'APP'$LOCA OR 'TIENDA'$LOCA )   AND EVALUATE(XFOR3) ;
			TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND Tipo_Venta='PASAJE' AND ('VEN'$UPPER(DELO) OR 'APP'$LOCA OR 'TIENDA'$LOCA ) AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	REPLICATE('0',11) 	&& m.RUC 

			IF m.t10_codt10='01' AND m.SERIE='F'
				REPLACE CLIENTE				WITH m.RUC
			ENDIF
			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:46 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  RIGHT(TRIM(m.SERIE_REF),4)+'-'+TRIM(m.NUMERO_REF) +'VTA.PASAJES CONT.ONLINE ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C'+ ' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				REPLACE SUBTOTAL  		WITH	0.00									&& CARGADOR 14
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
			ELSE
				REPLACE SUBTOTAL  		WITH 	0	&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 14
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1 	&& CARGADOR 14
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'ONLINE',LsFiltro3,'CONTADO')

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA			WITH	m.TIPO_VENTA
			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				** VETT  23/08/2018 12:42 PM : Tipo_Referencia segun tipo de documento electrónico : IDUPD: _5A10R8P3J 
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_Ref='F','FAC',m.Serie_Ref='B','B/V','FAC')   && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR WITH 'C14'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre14) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre14 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 13 PROVISIÓN BOLETOS SIN ONLINE CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre13 		=	'13 PASAJES PROVISIÓN BOLETOS CONTADO'
		This.CargadorRutaArchivo13		=	'C13_PASAJES_PROV_BOLE_CONTADO_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre13  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo13) 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  Tipo_Venta='PASAJE' ;
			AND EMPTY(CODCAR)     AND EVALUATE(XFOR3)   TO LnTotReg
		 
		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		SET ORDER TO TIPO2
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9') AND  Tipo_Venta='PASAJE'  AND EMPTY(CODCAR)    AND EVALUATE(XFOR3) 

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE				WITH 	REPLICATE('0',11) 	&& m.RUC  &&

			IF ( m.t10_codt10='01' AND m.SERIE='F' ) AND (m.t10_codt10='07' AND m.SERIE='F' )
				REPLACE CLIENTE				WITH m.RUC
			ENDIF

			REPLACE ORIGEN				WITH	''
			DO CASE
				CASE m.t10_codt10='07'
					REPLACE TIPO 				WITH 	'N/C' 
					m.VAL_AFECTO		=	ABS(m.VAL_AFECTO)
					m.VAL_EXONER	=	ABS(m.VAL_EXONER)
					m.IMP_IGV			=	ABS(m.IMP_IGV)
					m.IMP_TOTAL 		=	ABS(m.IMP_TOTAL )

				CASE m.t10_codt10='03'
					REPLACE TIPO 				WITH 	'B/V' 
				OTHER
					REPLACE TIPO 				WITH 	'FAC' 
			ENDCASE
			** VETT  25/08/2016 04:47 PM : 
			LsLetras	=RTRIM(chrtran( m.serie, "1234567890", "" ))
			LsSerie		=chrtran( m.SERIE, chrtran( m.SERIE, "1234567890", "" ), "" )
			REPLACE DOCUMENTO 		WITH 	LsLetras+LTRIM(STR(VAL(LsSERIE),LEN(LsSERIE),0)) + '-'+LTRIM(m.NUMERO)	&& LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)

			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH 	m.Nombre

			IF 	m.T10_CODT10='16' OR ( m.T10_CODT10='07' AND m.IMP_IGV=0)
				DO CASE
					CASE m.T10_CODT10='16'
						REPLACE APLICACION WITH  'VENTA PASAJES CONTADO ' + MES(VAL(This.CboMes.value),1) +IIF(m.ESTADO_OPE='2',' ANULADO ','')
					CASE m.T10_CODT10='07'
						REPLACE APLICACION WITH 'N/C'+ ' CONTADO / ' + RIGHT(TRIM(m.Serie_Ref),4) + '-'+ m.Numero_Ref +IIF(m.ESTADO_OPE='2',' ANULADO ','')

				ENDCASE
				IF m.T10_CODT10='07'
					REPLACE SUBTOTAL  		WITH 	0	&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 13
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1 	&& CARGADOR 13
				ELSE
					REPLACE SUBTOTAL  		WITH	0.00
					REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
					REPLACE IMPUESTO1		WITH 	m.IMP_IGV
					REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1
				ENDIF
			ELSE
				REPLACE SUBTOTAL  		WITH 	0	&& m.VAL_EXONER + m.VAL_AFECTO		&& CARGADOR 13
				REPLACE RUBRO2			WITH 	m.VAL_EXONER + m.VAL_AFECTO
				REPLACE IMPUESTO1		WITH 	m.IMP_IGV
				REPLACE MONTO			WITH 	RUBRO2 + IMPUESTO1		&& SUBTOTAL + IMPUESTO1 	&& CARGADOR 13
			ENDIF
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'
			REPLACE SUBTIPO				WITH 	m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsFiltro3	=	m.TIPO_VENTA

			LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXX',LsFiltro3,'CONTADO')

			SELECT CARGADOR1

			LsCcto = ''
			LsCta	= ''
			IF	AT('@',LsCctoCta) > 0
				LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
				LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
			ENDIF

			REPLACE CENTRO_COSTO	WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE PAQUETE			WITH	'CC'
			REPLACE TIPO_VENTA		WITH	m.TIPO_VENTA

			** VETT  13/06/2015 01:44 PM :  Solo en caso de N/Credito
			IF m.T10_CODT10='07'
				REPLACE	Tipo_Referencia		WITH	ICASE(m.Serie_REF='F','FAC',m.Serie_REF='B','B/V','FAC') && 'FAC'
				REPLACE	Doc_referencia		WITH	RIGHT(RTRIM(m.Serie_REF),4)+'-'+m.Numero_Ref
			ENDIF

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(ESTADO1) + IIF(EMPTY(m.CODCAR),'',','+m.CODCAR)
			REPLACE CODCAR 	WITH 	'C13'
			REPLACE CODCTA	WITH	LsCta
			REPLACE CENCOS	WITH	LsCcto

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		SELECT CARGADOR1
		IF RECCOUNT()>=65535
			LsExtension	=	'.xlsx'
		ELSE
			LsExtension	=	'.xls'
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre13) +' '+MES(VAL(This.CboMes.value),1) +LsExtension 

		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			IF RECCOUNT()>=65535

				LnRegPro=CopytoExcel(LsFileCargador1,"",'')
				IF LnRegPro<=0
					=MESSAGEBOX('No se pudieron copiar los registros del cargador '+ TRIM(This.CargadorNombre13) + ' al formato excel.' ,16,'! ATENCIÖN / WARNING !')
				ENDIF
			ELSE
				COPY TO (LsFileCargador1) TYPE XLS
			ENDIF
		ENDIF
		USE IN CARGADOR1

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre13 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 
	ENDPROC


	PROCEDURE generarcargadorcancelacion1
		m.FchDoc1	=	THIS.TxtFchDocD.Value 
		m.FchDoc2	=	THIS.TxtFchDocH.Value 
		XFOR3	=	'.T.'
		DO CASE
		   CASE EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi<=m.fchdoc2"
		        m.titulo1 = [Emitidos hasta el ]+DTOC(m.FchDoc2)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. empty(m.FchDoc2)
		        XFOR3 = "Cte_FecEmi>=m.fchdoc1"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ ]
		   CASE !EMPTY(m.FchDoc1).and. !empty(m.FchDoc2)
		        XFOR3 = "(Cte_FecEmi<=m.fchdoc2 AND Cte_FecEmi>=m.fchdoc1)"
		        m.titulo1 = [Emitidos desde el ]+DTOC(m.FchDoc1)+[ hasta el ]+DTOC(m.FchDoc2)+[ ]
		   OTHER
		        XFOR3 = ".T."
		        m.titulo1 = []
		ENDCASE
		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 15 CANCELACION CANJES PUBLICITARIOS
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		This.CargadorNombre15		= '15 CANCELACION CANJES  PUBLICITARIOS'
		This.CargadorRutaArchivo15	= 'C15_CANJES_PUBLICITARIOS_'+THISFORM.PLEPeriod

		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre15  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo15,'2') 

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'

		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO LOCA
		ENDIF

		LnTotReg = 0
		SELECT REGVEN
		COUNT FOR INLIST(Estado_OPE,'1','2','8','9')  AND  INLIST(Tipo_Venta,'PASAJE','CARGO') ;
			AND DETA='CA'   AND EVALUATE(XFOR3) ;
			TO LnTotReg
		 

		LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		SELECT  REGVEN
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','8','9')  AND  INLIST(Tipo_Venta,'PASAJE','CARGO') ;
					AND DETA='CA'   AND EVALUATE(XFOR3)

			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SCATTER MEMVAR
			SELECT Cargador1
			APPEND BLANK
			REPLACE PROVEEDOR			WITH 	m.RUC   &&REPLICATE('0',11) 
			REPLACE TIPO 					WITH 	'TEF' 
			REPLACE DOCUMENTO 		WITH 	''    &&  QUE VA QUI?  && LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)
			REPLACE FECHA_DOCUMENTO WITH 	DTOC(m.cte_fecemi)
			REPLACE APLICACION			WITH	'CJE.PUB.LIQ.'+'F/'+RTRIM(m.OTRO)+' - '+ICASE(m.t10_codt10='16','BOL',m.t10_codt10='12','TICKET',m.t10_codt10='01','FAC',m.t10_codt10='03','BOLE','NA')+'-'+LTRIM(STR(VAL(m.SERIE),LEN(m.SERIE),0)) + '-'+LTRIM(m.NUMERO)
			REPLACE SUBTOTAL			WITH	m.IMP_TOTAL && IIF(m.Tipo_Venta='PASAJE', m.TOTG,TENC)  
			REPLACE MONTO				WITH 	m.IMP_TOTAL && IIF(m.Tipo_Venta='PASAJE', m.TOTG,TENC)    
			REPLACE SALDO				WITH	m.IMP_TOTAL && IIF(m.Tipo_Venta='PASAJE', m.TOTG,TENC)    
			REPLACE MONEDA				WITH 	'SOL'
			REPLACE CONDICION_PAGO	WITH 	'0'

		*!*		LsFiltro3	=	m.TIPO_VENTA

		*!*		LsCctoCta=THIS.Busca_CCosto_Cta_CBD(TRIM(m.LOCA),'XXX',LsFiltro3,'CREDITO','CANCELACION1')
			LsLoca=TRIM(LEFT(m.LOCA,12))
			SELECT CCOCT
			SEEK LsLoca
			SELECT CARGADOR1
			REPLACE CUENTA_BANCARIA	WITH 	CCOCT.Caja
			REPLACE SUBTIPO				WITH 	'0' && m.t10_codt10+IIF(SEEK('SN'+TRIM(m.t10_codt10),'TABL','TABL01' ),TABL.NOMBRE,'')

			LsCcto = '00.00.00.0000'
			LsCta	= ''
		*!*		IF	AT('@',LsCctoCta) > 0
		*!*			LsCcto		=	SUBSTR(LsCctoCta ,1					, AT('@',LsCctoCta)-1)
		*!*			LsCta		=	SUBSTR(LsCctoCta ,AT('@',LsCctoCta)+1					 )
		*!*		ENDIF

			REPLACE CENTRO_COSTO		WITH	LsCcto
			REPLACE CUENTA_CONTABLE	WITH	LsCta
			REPLACE FECHA_CONTABLE	WITH	DTOC(m.cte_fecemi)

		*!*		REPLACE PAQUETE			WITH	''

			SELECT REGVEN
			REPLACE ESTADO1	WITH TRIM(m.ESTADO1) + IIF(EMPTY(m.ESTADO1),'',','+m.ESTADO1) +'C15'

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre15) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		USE IN CARGADOR1


		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre15 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 


		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 09-1 CANCELACION CARGO  EXCESOS CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C09'
		This.CargadorNombre09_1 		= '09-1 CANCELACION CARGO  EXCESOS CONTADO'
		This.CargadorRutaArchivo09_1	= 'C09_1_CARGO_CANCEL_EXCESOS_CONTADO_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C09_CARGO_PROV_EXCESOS_CONTADO_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre09_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo09_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0
		** VETT  22/12/2015 04:49 PM : Correlativo general  
		LnCorrelativo = 0
		** VETT  22/12/2015 04:50 PM : 

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI


		SELECT * FROM CARG_ORI WHERE Subtipo='07' INTO CURSOR CARG_ORI_NC


		** VETT  24/08/2018 09:23 PM : Eliminamos todas las N/C cuyas referencias sean documentos que pertencen al cargador 09: IDUPD: _5A219UJ0F

		SELECT a.tipo,a.subtipo,a.cliente,a.documento,a.doc_referencia,a.centro_costo,a.monto,a.tipo_venta FROM ;
		 carg_ori a LEFT OUTER JOIN carg_ori_nc b ON a.documento=b.doc_referencia ORDER BY a.documento ; 
		 WHERE b.doc_referencia is null INTO cursor CARG_ORI_0 
		** VETT  24/08/2018 09:23 PM : IDUPD: _5A219UJ0F

		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		** VETT  24/08/2018 09:23 PM : Cambiamos el CARG_ORI por CARG_ORI_0 : IDUPD: _5A40Z3WQF 
		 SELECT centro_costo,SUM(Monto) as Monto,Tipo_Venta FROM CARG_ORI_0 ;
		 			WHERE NOT ( (TIPO='FAC' AND Subtipo='01' AND ( LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) ) OR (Tipo='N/C' AND Subtipo='07' ) ) ;
		 							GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 
		SELECT  CARG_ORI2   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION VENTA EXCESOS '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	m.CLIENTE   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION VENTA EXCESOS '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   

		ENDSCAN


		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre09_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre09_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		LnCorrelativo=LnRegAct
		**+++++++++++++++++++++++++++++++++++++++++++++++++++**
		** 10-1 CANCELACION CARGO OTROS INGRESOS CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C10'
		This.CargadorNombre10_1 		= '10-1 CANCELACION CARGO OTROS INGRESOS CONTADO'
		This.CargadorRutaArchivo10_1	= 'C10_1_CARGO_CANCEL_OTROS_INGRE_CONTADO_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C10_CARGO_PROV_OTROS_INGRE_CONTADO_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre10_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo10_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI
		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		** VETT  24/08/2018 09:23 PM : Eliminamos todas las N/C cuyas referencias sean documentos que pertencen al cargador 09: IDUPD: _5A219UJ0F

		SELECT a.tipo,a.subtipo,a.cliente,a.documento,a.doc_referencia,a.centro_costo,a.monto,a.tipo_venta FROM ;
		 carg_ori a LEFT OUTER JOIN carg_ori_nc b ON a.documento=b.doc_referencia ORDER BY a.documento ; 
		 WHERE b.doc_referencia is null INTO cursor CARG_ORI_0 
		** VETT  24/08/2018 09:23 PM : IDUPD: _5A219UJ0F

		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		** VETT  24/08/2018 09:23 PM : Cambiamos el CARG_ORI por CARG_ORI_0 : IDUPD: _5A40Z3WQF 
		 SELECT centro_costo,SUM(Monto) as Monto,Tipo_Venta FROM CARG_ORI_0 ;
		            WHERE NOT ( (TIPO='FAC' AND Subtipo='01' AND ( LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) ) OR (Tipo='N/C' AND Subtipo='07' ) );
		 			GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 
		SELECT  CARG_ORI2   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 
			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION OTROS ING. CONTADO '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	m.CLIENTE   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 
			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION OTROS ING. CONTADO '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   
		ENDSCAN
		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre10_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre10_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**+++++++++++++++++++++++++++++++++++++++++++++**
		** 11-1 CANCELACION CARGO  ENCOMIENDA CONTADO
		**+++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C11'
		This.CargadorNombre11_1 		= '11-1 CANCELACION CARGO  ENCOMIENDA CONTADO'
		This.CargadorRutaArchivo11_1	= 'C11_1_CARGO_CANCEL_ENCO_CONTADO_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C11_CARGO_PROV_ENCO_CONTADO_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre11_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo11_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI
		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		** VETT  24/08/2018 09:23 PM : Eliminamos todas las N/C cuyas referencias sean documentos que pertencen al cargador 09: IDUPD: _5A219UJ0F

		SELECT a.tipo,a.subtipo,a.cliente,a.documento,a.doc_referencia,a.centro_costo,a.monto,a.tipo_venta FROM ;
		 carg_ori a LEFT OUTER JOIN carg_ori_nc b ON a.documento=b.doc_referencia ORDER BY a.documento ; 
		 WHERE b.doc_referencia is null INTO cursor CARG_ORI_0 
		** VETT  24/08/2018 09:23 PM : IDUPD: _5A219UJ0F

		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		** VETT  24/08/2018 09:23 PM : Cambiamos el CARG_ORI por CARG_ORI_0 : IDUPD: _5A40Z3WQF 
		 SELECT centro_costo,SUM(Monto) as Monto,Tipo_Venta FROM CARG_ORI_0 ;
		        WHERE NOT ( (TIPO='FAC' AND Subtipo='01' AND ( LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) ) OR (Tipo='N/C' AND Subtipo='07' ) );
		 		GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 

		SELECT  CARG_ORI2   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION VENTA CARGO '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'CARGO')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	m.CLIENTE   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION VENTA CARGO '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'CARGO')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   
		ENDSCAN
		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre11_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre11_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**++++++++++++++++++++++++++++++++++++++++++++++++++++**
		** 12-1 CANCELACION PASAJES  BOLETOS CORP CONTADO
		**++++++++++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C12'
		This.CargadorNombre12_1 		= '12-1 CANCELACION PASAJES  BOLETOS CORP CONTADO'
		This.CargadorRutaArchivo12_1	= 'C12_1_PASAJES_CANCEL_BOLE_CORP_CONT_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C12_PASAJES_PROV_BOLE_CORP_CONT_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre12_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo12_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0

		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO LOCA
		ELSE
			SELECT CCOCT
			SET ORDER TO LOCA
		ENDIF

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI
		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		*!*	 SELECT centro_costo,SUM(Rubro2-SubTotal) as Monto,Tipo_Venta FROM CARG_ORI WHERE NOT (TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) );
		*!*	 							GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 SELECT * FROM CARG_ORI INTO CURSOR CARG_ORI1 READWRITE

		SELECT REGVEN
		SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO 
		this.TxtEstadoProceso2.Caption	=	[Capturando CAJA segun LOCALIDAD de documento en Reg. Ven. ] 

		SELECT CARG_ORI1
		 SCAN 
		 	LsNroDoc=LEFT(subtipo,2)+PADR('0'+SUBSTR(Documento,1,AT('-',documento)-1),LEN( Regven.serie))+RTRIM(SUBSTR(documento,AT('-',documento)+1))
		 	LsNroDocView=TRIM(Subtipo)+'-'+TRIM(Documento)
		 	SELECT REGVEN
		 	SEEK LsNrodoc
		 	IF FOUND()
				LsLoca=PADR(REGVEN.LOCA,LEN(CCOCT.Localidad))
			ELSE
				LsLoca= 'LOCA no definida... en RV ACCESS'    && LOCA no definida ¿!!?.... jajajajajaja
			    IF !FILE(THISFORM.Filelogerror4)
				    =STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         FECHA PROCESO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)
			    ENDIF
				    =STRTOFILE('**** PASAJES C12  '+ LsNroDocView  + ' No se pudo localizar en el ACCESS '+' - '+TTOC(DATETIME())+' *****  '+CRLF,Thisform.Filelogerror4,.T.)
		 	ENDIF
		 	SELECT CCOCT
		 	SEEK LsLoca
		 	IF FOUND()
		 		LsCaja = CCOCT.CAJA
			ELSE
				LsCaja = 'N/N' 
				IF !FILE(THISFORM.Filelogerror4)
				    =STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         FECHA PROCESO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)
			    ENDIF
				    =STRTOFILE('**** PASAJES C12  '+ LsNroDocView  + ' No se puede identificar centro de costo para CUENTA BANCARIA'+' - '+TTOC(DATETIME())+' *****  '+CRLF,Thisform.Filelogerror4,.T.)
		 	ENDIF
		 	SELECT CARG_ORI1
		 	REPLACE	Cuenta_bancaria WITH LsCaja

		 ENDSCAN
		 
		 SELECT Cuenta_bancaria,SUM(Rubro2-SubTotal) as Monto,Tipo_Venta FROM CARG_ORI1 WHERE NOT (TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) );
		 							GROUP BY  Cuenta_bancaria,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI1 WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 
		SELECT  CARG_ORI2   

		SCAN 

			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH  	m.CUENTA_BANCARIA &&  THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE 	CLIENTE			WITH 	m.CLIENTE   
			REPLACE 	ORIGEN				WITH	''
			REPLACE 	TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA		= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     m.CUENTA_BANCARIA &&  THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   
		ENDSCAN
		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre12_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre12_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**++++++++++++++++++++++++++++++++++++++++++++++++++++**
		** 13-1 CANCELACION PASAJES  BOLETOS CORP CONTADO
		**++++++++++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C13'
		This.CargadorNombre13_1 		= '13-1 CANCELACION PASAJES  BOLETOS CONTADO'
		This.CargadorRutaArchivo13_1	= 'C13_1_PASAJES_CANCEL_BOLE_CONT_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C13_PASAJES_PROV_BOLE_CONTADO_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre13_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo13_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI
		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		 SELECT centro_costo,SUM(Rubro2-SubTotal) as Monto,Tipo_Venta FROM CARG_ORI WHERE NOT (TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) );
		 							GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 
		SELECT  CARG_ORI2   
		SCAN 

			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	m.CLIENTE   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   
		ENDSCAN
		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre13_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre13_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 

		**++++++++++++++++++++++++++++++++++++++++++++++++++++**
		** 14-1 CANCELACION PASAJES  BOLETOS CORP CONTADO
		**++++++++++++++++++++++++++++++++++++++++++++++++++++** 
		LsCodCar='C14'
		This.CargadorNombre14_1 		= '14-1 CANCELACION PASAJES  BOLETOS ONLINE CONTADO'
		This.CargadorRutaArchivo14_1	= 'C14_1_PASAJES_CANCEL_BOLE_ONLINE_CONT_'+THISFORM.PLEPeriod
		LsNombreCargadorOrigen		= TRIM(thisform.Bd_Interfase)+'!'+'C14_PASAJES_PROV_BOLE_ONLINE_CONTADO_'+THISFORM.PLEPeriod
		this.TxtEstadoProceso1.Caption	=	[PROCESANDO CARGADOR:] +This.CargadorNombre14_1  
		this.TxtEstadoProceso2.Caption	=	[] 

		this.VerificaDBFCargador(This.CargadorRutaArchivo14_1) 
		SCATTER NAME THISFORM.registro_cargador

		this.TxtEstadoProceso2.Caption =  'CALCULANDO TOTAL DE REGISTROS A PROCESAR ....'
		LnTotReg = 0

		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO LOCA
		ELSE
			SELECT CCOCT
			SET ORDER TO LOCA
		ENDIF

		SELECT 0
		USE  (LsNombreCargadorOrigen)  ALIAS CARG_ORI
		 ** Preparamos el cursor del cargador ordenado por centro de costo ** 
		*!*	 SELECT centro_costo,SUM(Rubro2-SubTotal) as Monto,Tipo_Venta FROM CARG_ORI WHERE NOT (TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) );
		*!*	 							GROUP BY  Centro_Costo,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 SELECT * FROM CARG_ORI INTO CURSOR CARG_ORI1 READWRITE

		SELECT REGVEN
		SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO 
		this.TxtEstadoProceso2.Caption	=	[Capturando CAJA segun LOCALIDAD de documento en Reg. Ven. ] 

		SELECT CARG_ORI1
		 SCAN 
		 	** VETT  02/08/2018 05:36 PM : Eliminamos el 0 adelante de la Serie por que es remplazado por letra F o B : IDUPD: _59G11QWOD 
		 	LsNroDoc=LEFT(subtipo,2)+PADR(SUBSTR(Documento,1,AT('-',documento)-1),LEN( Regven.serie))+RTRIM(SUBSTR(documento,AT('-',documento)+1))
			** VETT  02/08/2018 05:37 PM :  : IDUPD: _59G11QWOD 

		 	SELECT REGVEN
		 	SEEK LsNrodoc
		 	IF FOUND()
				LsLoca=PADR(REGVEN.LOCA,LEN(CCOCT.Localidad))
				LsCodigoMP  =PADR(DETA,LEN(TABL.Codigo))
			ELSE
				LsLoca= 'LOCA no definida... en RV ACCESS'    && LOCA no definida ¿!!?.... jajajajajaja
				LsCodigoMP	= 'N/N'
				LsLoca= 'LOCA no definida... en RV ACCESS'    && LOCA no definida ¿!!?.... jajajajajaja
			    IF !FILE(THISFORM.Filelogerror4)
				    =STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         FECHA PROCESO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)
			    ENDIF
				    =STRTOFILE('**** PASAJES C14  '+ LsNroDocView  + ' No se pudo localizar en el ACCESS '+' - '+TTOC(DATETIME())+' *****  '+CRLF,Thisform.Filelogerror4,.T.)

		 	ENDIF
		 	IF .T.
		 		SELECT TABL
		 		SEEK 'MP'+LsCodigoMP
				IF FOUND()
					LsCaja = TABL.Nombre
				ELSE
					LsCaja = 'N/N' 
				    IF !FILE(THISFORM.Filelogerror4)
					    =STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         FECHA PROCESO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)
				    ENDIF
					    =STRTOFILE('**** PASAJES C14  '+ LsNroDocView  + ' No se puede identificar medio de pago ACCESS.DETA ='+LsCodigoMP+' - '+TTOC(DATETIME())+' *****  '+CRLF,Thisform.Filelogerror4,.T.)

				ENDIF
		 	ELSE
			 	SELECT CCOCT
			 	SEEK LsLoca
			 	IF FOUND()
			 		LsCaja = CCOCT.CAJA
				ELSE
					LsCaja = 'N/N' 
			 	ENDIF
		 	ENDIF
		 	SELECT CARG_ORI1
		 	REPLACE	Cuenta_bancaria WITH LsCaja

		 ENDSCAN
		 
		 SELECT Cuenta_bancaria,SUM(Rubro2-SubTotal) as Monto,Tipo_Venta FROM CARG_ORI1 WHERE NOT (TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' ) );
		 							GROUP BY  Cuenta_bancaria,Tipo_venta INTO CURSOR CARG_ORI2 READWRITE
		 LnTotReg1 = _TALLY
		 
		 SELECT * FROM CARG_ORI1 WHERE TIPO='FAC' AND Subtipo='01' AND (LEN(ALLTRIM(CLIENTE))=11 AND CLIENTE<>'00000000000' )  ;
		 							INTO CURSOR CARG_ORI3 READWRITE
		 
		 LnTotReg2 = _TALLY
		  LnTotReg  =   LnTotReg1 +  LnTotReg2
		 LnRegAct = 0

		LsUltMsg = 'TOTAL DE REGISTROS A PROCESAR:  '+ TRANSFORM( LnTotReg,"999,999,999") + ' - '
		*!*	WAIT WINDOW LsUltMsg NOWAIT
		THIS.TxtEstadoProceso2.Caption = LsUltMsg
		** VETT  18/12/2015 01:36 PM : 1ero. grabamos el resumen x centro de costo 
		SELECT  CARG_ORI2   

		SCAN 

			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH  	m.CUENTA_BANCARIA &&  THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
		ENDSCAN
		** VETT  18/12/2015 06:34 PM : 2da. parte capturamos los registros con tipo='FAC' y Subtipo='01' , que no se agrupan x C.Costo 
		SELECT  CARG_ORI3   
		SCAN 
			SCATTER MEMVAR
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
		*!*			WAIT WINDOW LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' nowait
				THIS.TxtEstadoProceso2.Caption = LsUltMsg + 'Avance: ' + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %'
			ENDIF

			SELECT Cargador1
			APPEND BLANK
			REPLACE 	CLIENTE			WITH 	m.CLIENTE   
			REPLACE 	ORIGEN				WITH	''
			REPLACE 	TIPO 				WITH 	'DEP' 

			LnCorrelativo = LnCorrelativo + 1
			LsCorrelativo	=	TRANSFORM(LnCorrelativo,'@L 999999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA		= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	DTOC(GdFecha)	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACIÓN VENTA PASAJES CORP '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     m.CUENTA_BANCARIA &&  THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT  CARG_ORI3   
		ENDSCAN
		LsDirCargador=ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') 
		IF !DIRECTORY(LsDirCargador)
			MD(LsDirCargador)
				=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirCargador+ ;
			'  Este directorio se usara para guardar los cargadores en formato .xls necesarios para ingresar datos por volumen al sistema EXACTUS',64,'ATENCION !!' )
		ENDIF
		LsFileCargador1 = ADDBS(ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+'CARGADORES') + TRIM(This.CargadorNombre14_1) +' '+MES(VAL(This.CboMes.value),1) +'.xls' 
		SELECT CARGADOR1
		SET ORDER TO CAJA1   && IIF(CLIENTE=REPLICATE("0",11),"1","2")+CUENTA_BANCARIA 
		LOCATE
		IF !EOF()
			IF FILE(LsFileCargador1)
				DELETE FILE (LsFileCargador1)
			ENDIF
			COPY TO (LsFileCargador1) TYPE XLS
		ENDIF
		IF USED('CARGADOR1')
			USE IN CARGADOR1
		ENDIF
		IF USED('CARG_ORI')
			USE IN CARG_ORI
		ENDIF
		IF USED('CARG_ORI2')
			USE IN CARG_ORI2
		ENDIF 
		IF USED('CARG_ORI3')
			USE IN CARG_ORI3
		ENDIF

		this.TxtEstadoProceso1.Caption	=	[CARGADOR:] +This.CargadorNombre14_1 + [ GENERADO CON EXITO!] 
		this.TxtEstadoProceso2.Caption	=	[] 
	ENDPROC


	*-- Rutina para buscar el correlativo de caja proveniente de otra base de datos.
	PROCEDURE buscarcorrelativocaja
		RETURN ''
	ENDPROC


	*-- Busca registros duplicados segun llave: T10+CODT10+SERIE+NUMERO
	PROCEDURE busca_duplicados
		PARAMETERS PsCurRegTotal,PsCurResumen
		DIMENSION vDuplicado(5)
		SELECT (PsCurRegTotal) && REGVEN 
		SET FILTER TO
		LOCATE
		SET ORDER TO Serie
		nd	= 0
		SELECT (PsCurResumen) && RegVenRitem
		SCAN FOR  TotItm = 2
			Lsllave= T10_CODT10+SERIE+NUMERO
			LnCont = 0
			DIMENSION vReg(2,12)
			SELECT (PsCurRegTotal) && REGVEN 
			=SEEK(LsLlave,'REGVEN','Serie')
			LsRuc=''
			LPrimera = .T.
			LLOk = .F.
			LnCont = 0
			LsArcTmp1= ADDBS(GoEntorno.TmpPath)+SYS(3)
			COPY TO   (LsArcTmp1) WHILE T10_CODT10+SERIE+NUMERO=LsLlave  TYPE FOX2X
			SELECT 0
			USE (LsArcTmp1) ALIAS Tmp2Reg
			SCAN WHILE T10_CODT10+SERIE+NUMERO=LsLlave 
				LnCont = LnCont + 1
				IF LnCont = 2  AND PADR(LsRuc,11) <>PADR(Ruc,11)  
					LLOK = .T.
				ELSE
					LsRuc = Ruc
					SCATTER MEMVAR 
				ENDIF

			ENDSCAN
			LnRegDelRV = 0
			IF LlOK
				LsArcTmp2= ADDBS(GoEntorno.TmpPath)+SYS(3)
				TOTAL TO (LsArcTmp2) ON T10_CODT10+SERIE+NUMERO 
				SELECT 0
				USE (LsArcTmp2) ALIAS TotDupli
				LnCount=0
				SELECT  (PsCurRegTotal) && REGVEN  
				=SEEK(LsLlave,PsCurRegTotal,'Serie')
				SCAN WHILE T10_CODT10+SERIE+NUMERO=LsLlave
					LnCount = LnCount + 1
					IF LnCount = 1
						REPLACE VAL_EXPORT	 WITH 	VAL_EXPORT	+	TotDupli.VAL_EXPORT
						REPLACE VAL_AFECTO	 WITH 	VAL_AFECTO	+	TotDupli.VAL_AFECTO
						REPLACE VAL_EXONER WITH 	VAL_EXONER	+	TotDupli.VAL_EXONER
						REPLACE VAL_INAFEC   WITH 	VAL_INAFEC	+	TotDupli.VAL_INAFEC
						REPLACE IMP_ISC   		WITH	IMP_ISC		+	TotDupli.IMP_ISC
						REPLACE IMP_IGV   		WITH	IMP_IGV		+	TotDupli.IMP_IGV
						REPLACE IMP_TOTAL	WITH	IMP_TOTAL		+	TotDupli.IMP_TOTAL
						this.TxtEstadoProceso2.Caption	=  'Duplicados x error de control de correlativo, agrupando: '+T10_CODT10+'-'+SERIE+'-'+NUMERO 
						REPLACE Estado_OPE	WITH 'X'
						LnRegDelRV = RECNO()
					ENDIF
				ENDSCAN
			ENDIF
			SELECT  (PsCurResumen) && RegVenRitem 


			IF LnRegDelRV>0
				GO LnRegDelRV IN (PsCurRegTotal) && REGVEN
			ENDIF
			IF &PsCurRegTotal..Estado_OPE = 'X'
				nd = nd + 1
				IF ALEN(vDuplicado)<nd
					DIMENSION vDuplicado(nd+5)
				ENDIF
				vDuplicado(nd) = T10_CODT10+SERIE+NUMERO
			ENDIF
			IF USED('TotDupli')
				USE IN TotDupli
			ENDIF
			IF USED('Tmp2Reg')
				USE IN Tmp2Reg
			ENDIF
		ENDSCAN
		IF nd>0
			DIMENSION vDuplicado(nd)
		*** Borramos los registros duplicados que ya fueron procesados **
			FOR  dd=1 TO ALEN(vDuplicado)
				SELECT  (PsCurResumen) && RegVenRitem 
				LOCATE
				SCAN FOR  T10_CODT10+SERIE+NUMERO=vDuplicado(dd)
					this.TxtEstadoProceso2.Caption	=  'Borramos los registros duplicados que ya fueron procesados '+T10_CODT10+'-'+SERIE+'-'+NUMERO 
					DELETE 
				ENDSCAN
			ENDFOR
		ENDIF
		*** Actualizamos archivo de duplicados y grabamos 
		TotDupli=0
		SELECT (PsCurResumen) && RegVenRitem
		COUNT FOR !DELETED() TO TotDupli
		LOCATE
		IF !EOF()
			IF FILE(LsFileErrRepetidos)
				DELETE FILE (LsFileErrRepetidos)
			ENDIF
			thisform.LblRepetidos.Caption = TRANSFORM( TotDupli,'999,999')
			COPY TO (LsFileErrRepetidos) TYPE XLS
		ENDIF
	ENDPROC


	*-- Estructura DBF para libro de ventas v5
	PROCEDURE struct_140100_v5
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + This.PLEAliaslib+This.PLEPeriod  && STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
			** VETT  24/07/2014 06:27 PM : EJ: "D:\o-negocios\oltursa\local\"+"RV" + "2014"+"06"  => "D:\o-negocios\oltursa\local\RV201406"
		ENDIF
		** Borramos tablas para evitar problemas de corrupción de archivos
		IF FILE(LcRutaFileVMOV+'.dbf')
			DELETE FILE LcRutaFileVMOV+'.dbf'
			DELETE FILE LcRutaFileVMOV+'.fpt'
			DELETE FILE LcRutaFileVMOV+'.cdx'
		ENDIF

		IF !FILE(LcRutaFileVMOV+'.dbf')

			this.TxtEstadoProceso2.Caption	=	[CREANDO ESTRUCTURA DE DATOS... ]

			** VETT:Sunat impuesto bolsas plasticas ICBPER PLE 5.2 2021/01/15 14:39:07 ** 
			SELECT 0
			CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
						     CIA_CODCIA C(2),;
						      PERIODO C(8), ;
						      ASIENTO  C(15), ;
						      NROITM    C(10), ;
						      CTE_FECEMI    D, ;
						      CTE_FECVEN   D, ;
						      T10_CODT10 C(2),  ;
						      SERIE	 C(15), ;
						      NUMERO C(10), ;
						      ULT_NUMERO C(10), ;
						      T02_CODT02 C(1), ;
						      RUC C(11), ;
						      NOMBRE C(30), ;
						      VAL_EXPORT N(15,2), ;
						      VAL_AFECTO N(15,2), ;
						      VAL_AFE_DE N(15,2), ;
						      VAL_EXONER N(15,2), ;
						      VAL_INAFEC   N(15,2) , ;
						      IMP_ISC N(15,2),  ;
						      IMP_IGV N(15,2) ,  ;
						      IMP_IGV_DE N(15,2) ,  ;
						      BASIMP_IVA N(15,2), ;
						      IMP_IVAP N(15,2) , ;
						      IMP_ICBPER N(15,2) , ;
						      OTROS_TRIB N(15,2), ;
						      IMP_TOTAL N(15,2), ;
						      T04_CODT04 C(3), ;
						      CTE_TIPCAM	 N(7,3) , ;
						      FECEMI_REF D, ;
						      T10_CODREF C(4), ;
						      SERIE_REF C(4), ;
						      NUMERO_REF C(12), ;
						      VALOR_FOB N(15,2), ;
						      IDE_SOCIRR C(24), ;
						      IND_TCA_IN C(1), ;
						      IND_MEDIOP C(1), ;
						      ESTADO_OPE C(1), ;
						      LOCA C(60) ,;
						      LOC2 C(60) ,;
						      DELO C(60),;
						      DETA C(20),;
						      OTRO C(20),;
						      BOLE  C(10),;
						      EMBA  N(10),;
						      NDO2  C(20),;
						      CODCTA C(12),;
						      CENCOS	 C(14),;
						      CODCAR C(4),;
						      TIPO_VENTA C(10),;
						      DETA_VENTA C(15),;
						      ESTADO1 C(15) )
						      
			USE	(LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE														      
			INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
			INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
			INDEX ON CODCAR+CENCOS TAG CCTO01
			INDEX ON CENCOS TAG CCTO02
			INDEX ON CODCAR+CODCTA TAG CCTA01
			INDEX ON CODCTA TAG CCTA02
			INDEX ON  LOCA TAG LOCA
			** VETT  15/06/2015 04:33 PM : Agregamos indice para posicionar N/Credito T10_CODT10='07' al final de la tabla. Para cargadores 
			INDEX ON IIF(T10_codt10='07','99',T10_codt10)+T10_CODT10+SERIE+NUMERO TAG TIPO2  && Ordena N/C al último
		ELSE
			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE
			ZAP
				** VETT  15/06/2015 04:33 PM : Agregamos indice para posicionar N/Credito T10_CODT10='07' al final de la tabla. Para cargadores 
			IF VERIFYTAG(PsTblDestino,'TIPO2')
				INDEX ON IIF(T10_codt10='07','99',T10_codt10)+T10_CODT10+SERIE+NUMERO TAG TIPO2  && Ordena N/C al último
			ENDIF

		*!*		this.TxtEstadoProceso2.Caption	=	[BORRANDO DATOS DEL PROCESO ANTERIOR ...]
		ENDIF
	ENDPROC


	*-- Estructura DBF para libro de COMPRAS v4
	PROCEDURE struct_080100_v4
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + This.PLEAliaslib+This.PLEPeriod  &&STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')

			** VETT  24/07/2014 06:27 PM : EJ: "D:\o-negocios\oltursa\local\"+"RV" + "2014"+"06"  => "D:\o-negocios\oltursa\local\RV201406"
		ENDIF
		** Borramos tablas para evitar problemas de corrupción de archivos
		IF FILE(LcRutaFileVMOV+'.dbf')
			DELETE FILE LcRutaFileVMOV+'.dbf'
			DELETE FILE LcRutaFileVMOV+'.fpt'
			DELETE FILE LcRutaFileVMOV+'.cdx'
		ENDIF

		IF !FILE(LcRutaFileVMOV+'.dbf')

			this.TxtEstadoProceso2.Caption	=	[CREANDO ESTRUCTURA DE DATOS... ]


			SELECT 0
			CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
						     CIA_CODCIA C(2),;
						      PERIODO C(8), ;
						      ASIENTO  C(15), ;
						      NROITM    C(10), ;
						      CTE_FECEMI    D, ;
						      CTE_FECVEN   D, ;
						      T10_CODT10 C(2),  ;
						      SERIE	 C(20), ;
						      ANO_DUA	C(4), ;
						      NUMERO C(20), ;
						      ULT_NUMERO C(10), ;
						      T02_CODT02 C(1), ;
						      RUC C(11), ;
						      NOMBRE C(30), ;
						      BI_GRA_DER N(15,2),;  
						      IM_GRA_DER N(15,2),;
						      BI_GRA_MIX N(15,2),;
						      IM_GRA_MIX N(15,2),;
						      BI_GRA_SDE N(15,2),;
						      IM_GRA_SDE N(15,2),;
						      BI_NO_GRAV N(15,2),;
						      IMP_ISC    N(15,2),;
						      OTROS_TRIB N(15,2),;
						      IMP_TOTAL  N(15,2),;
						      CTE_TIPCAM N(7,3) ,;
						      FECEMI_REF D,;
						      T10_CODREF C(4),;
						      SERIE_REF  C(4),;
						      CO_DEP_ADU C(3),;
						      NUMERO_REF C(10),;
							  N_CP_N_DOM C(20) ,;
							  DPP_FECPST  D, ;
							  DPP_DEPPST  C(24),;
							  DPP_INDDET  C(1) , ;
						      ESTADO_OPE  C(1),;
						      CODCTA      C(12),;
						      CENCOS	  C(14),;
						      CODCAR      C(4),;
						      TIPO_COMPR C(10),;
						      DETA_COMPR C(15),;
						      ESTADO1     C(15) )
						      
			USE	(LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE														      
			INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
			INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
			INDEX ON CODCAR+CENCOS TAG CCTO01
			INDEX ON CENCOS TAG CCTO02
			INDEX ON CODCAR+CODCTA TAG CCTA01
			INDEX ON CODCTA TAG CCTA02

		ELSE
			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE
			ZAP
			this.TxtEstadoProceso2.Caption	=	[BORRANDO DATOS DEL PROCESO ANTERIOR ...]

		ENDIF
	ENDPROC


	*-- Estructura de registro de ventas generado por Exactus
	PROCEDURE struct_rv_exactus
		PARAMETERS PsCargadorRutaArc,PsAliasDest

		IF VARTYPE(PsAliasDest)<>'C'
			PsAliasDest=''
		ENDIF

		IF EMPTY(PsAliasDest)
			PsAliasDest='RV_Exactus1'
		ENDIF
		Thisform.tools.Closetable(PsAliasDest) 

		LsFileCargadorRV1 = ADDBS(TRIM(This.TxtUbicacionArchivos.Value))+ TRIM(PsCargadorRutaArc) 
		IF !FILE(LsFileCargadorRV1+[.DBF])
			IF DBUSED('INTERFACE')
				SET DATABASE TO INTERFACE
			ELSE
				OPEN DATABASE INTERFACE
			ENDIF
			SELECT 0
			CREATE TABLE  (LsFileCargadorRV1)  ( ;
								      FECHA D, ;
								      ASIENTO  C(15), ;
								      TIPO    C(5), ;
								      DESCRIPCION    C(20), ;
								      SERIE	 C(10), ;
								      DOCUMENTO C(20), ;
								      CLIENTE C(20),;
								      NOMBRE C(80),;
								      CODIGO_CLIENTE C(30), ;
								      CATEGORIA_CLIENTE C(30), ;
								      BASE N(15,2), ;
								      RUBRO1 N(15,2), ;
								      IMPUESTO1 N(15,2), ;
								      IMPUESTO2 N(15,2), ;
								      RUBRO2 N(15,2), ;
								      APLICACION   C(40) , ;
								      LISTA_DOCUMENTOS C(40),  ;
								      MONTO_DOLAR N(15,2) ,  ;
								      TIPO_CAMBIO N(7,4), ;
								      COD_TIPO_DOC C(1) , ;
								      DESC_TIPO_DOC C(32), ;
								      DOC_APLICADO C(10), ;
								      FECHA_DOC_APLICADO D ,;
								      SUBTIPO_DOC_APLICADO C(2),;
								      SUBTOTAL_Origen N(15,2), ;
								      DESCUENTO_Origen N(15,2), ;
								      IMPUESTO1_Origen   N(15,2), ;
								      IMPUESTO2_Origen N(15,2), ;
								      RUBRO1_Origen  N(15,2), ;
								      RUBRO2_Origen  N(15,2), ;
								      MONTO_Origen  N(15,2), ;
								      MONEDA_Origen C(3), ;
								      Tipo_Doc_SUNAT C(2),;
								      Descripción_Tipo_Doc_SUNAT C(30) ,;
								      Tipo_Doc_SUNAT_Referencia C(2),;
								      Descripción_Tipo_Doc_SUNAT_Referencia c(30) ,;
								      id_registro C(20)   )
								      
			USE	(LsFileCargadorRV1)  ALIAS (PsAliasDest) EXCLUSIVE										      
			INDEX ON DTOS(FECHA) TAG FECHA
			INDEX ON TIPO++DOCUMENTO TAG DOCUMENTO
			INDEX ON CODIGO_CLIENTE+DTOS(FECHA)	 TAG CODIGO				      
		ELSE
			SELECT 0
			USE	(LsFileCargadorRV1)  ALIAS (PsAliasDest) EXCLUSIVE
			SET ORDER TO FECHA
			SEEK THISFORM.PLEPeriod
			DELETE REST WHILE DTOS(FECHA)=THISFORM.PLEPeriod
			DELETE ALL FOR EMPTY(FECHA)
		*!*		WAIT WINDOW 'BORRANDO DATOS DEL CARGADOR ANTERIOR ...'+LsFileCargadorRV1 NOWAIT
				this.TxtEstadoProceso2.Caption =	'BORRANDO DATOS COPIA DE RV EXACTUS  PERIODO '+ THISFORM.PLEPeriod+'  '+LsFileCargadorRV1

		ENDIF						      

		LsAlias=ALIAS()

		RETURN LsAlias
	ENDPROC


	*-- Busca la caja correspondiente al centro de costo en la configuracion x localidad , centro costo y cuenta contable
	PROCEDURE busca_caja_x_ccosto
		PARAMETERS PsCCosto,PsColumna
		ASSERT !EMPTY(PsCCosto) MESSAGE 'Debe indicar centro de costo' 

		ASSERT !EMPTY(PsColumna) MESSAGE 'Debe indicar campo en donde buscar'

		IF PARAMETERS()<2
			PsColumna =''
		ENDIF
		IF PARAMETERS()<1
			PsCCosto  =''
		ENDIF
		IF EMPTY(PsCCosto) OR EMPTY(PsColumna)
			=MESSAGEBOX('No ha definido el centro de costo o campo en donde buscar',16,'¡¡ ATENCION / WARNING !!')
			RETURN ""
		ENDIF
		** Solo el cargador 11 es con CCosto de columna CARGO el resto en con  CCosto de coulmna PASAJE
		LSCurAreaAct=SELECT()
		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO LOCA
		ENDIF
		LsCmpCCosto=PsColumna
		LsTagCCosto = 'CC'+PsColumna
		SELECT CCOCT
		SET ORDER TO (LsTagCCosto) 
		SEEK PADR(PsCCosto,LEN(CCOCT.Pasaje))
		IF FOUND() 
			LsReturn = CCOCT.CAJA
		ELSE
			LsReturn = 'N/N'
		ENDIF
		SELECT (LsCurAreaAct)
		RETURN LsReturn
	ENDPROC


	*-- Graba item cargador de registro de ventas
	PROCEDURE graba_item_cargador_rv
		PARAMETERS PsCurOrigen,PsCurDestino,PcCliente,PsOrigen,PsTipo,PsDocumento,PsFecha_Documento


			SELECT Cargador1
			APPEND BLANK
			REPLACE CLIENTE			WITH 	REPLICATE('0',11) 	&& m.RUC   
			REPLACE ORIGEN			WITH	''
			REPLACE TIPO 				WITH 	'DEP' 

			LsCorrelativo	=	TRANSFORM(LnRegAct,'@L 999')       && THIS.BuscarCorrelativoCaja
			LsDDMMAAAA	= 	TRANSFORM(DAY(gdfecha),"@L 99")+transf(MONTH(gdfecha),"@L 99")+TRANSFORM(YEAR(gdfecha),'@L 9999')

			REPLACE 	DOCUMENTO 			WITH 	LsDDMMAAAA+LsCorrelativo
			REPLACE 	FECHA_DOCUMENTO 	WITH 	GdFecha	&& Ultimo dia del mes
			REPLACE	APLICACION			WITH	'CANCELACION VENTA EXCESOS '+ MES(VAL(This.CboMes.value),1) 
			REPLACE	SUBTOTAL				WITH	 m.MONTO
			REPLACE	MONTO					WITH 	 m.MONTO
			REPLACE 	MONEDA				WITH 	'SOL'
			REPLACE 	CONDICION_PAGO		WITH 	'0'
			REPLACE 	SUBTIPO				WITH 	'0'
			REPLACE 	CUENTA_BANCARIA	WITH     THISFORM.Busca_caja_x_ccosto(m.Centro_Costo,'PASAJE')	&& 
			REPLACE 	TIPO_VENTA			WITH 	m.TIPO_VENTA
			REPLACE 	PAQUETE				WITH	'CC'

			SELECT CARG_ORI2
	ENDPROC


	*-- Procedimiento para armar la cadena por cada registro del archivo txt v4
	PROCEDURE le_14_01_gen_txt_v4


			LsFecha = IIF(ISNULL(REGVEN.cte_fecven),NVL(REGVEN.cte_fecven, ' '),IIF(EMPTY(REGVEN.cte_fecven),' ',DTOC(REGVEN.cte_fecven) ))
			wcad = ALLTRIM(REGVEN.periodo)				+"|"
			** CUO Codigo unico de operación e.g. Operacion contable, libro contable, sub-diario , paquete
			DO CASE
				CASE UPPER(GsSigcia) = 'OLTURSA'
					wcad = wcad + 'CC'				+"|"
					wcad = wcad + 'M'+'I'+ALLTRIM(REGVEN.asiento)		+"|"
				OTHERWISE 
					wcad = wcad + ALLTRIM(ASIENTO)	+"|"
					wcad = wcad + 'M'+ALLTRIM(REGVEN.NROITM)		+"|"
			ENDCASE 

			wcad = wcad + DTOC(REGVEN.cte_fecemi)		+"|"
			wcad = wcad + LsFecha							+"|"
			wcad = wcad + RIGHT('0'+ALLTRIM(REGVEN.T10_CODT10),2)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NUMERO)		+"|"
			wcad = wcad + ALLTRIM(REGVEN.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXPORT,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFECTO,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXONER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_INAFEC,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ISC,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.BASIMP_IVA,15,2)) +"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IVAP,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.OTROS_TRIB,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_TOTAL,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.CTE_TIPCAM,7,3))	+"|"
			wcad = wcad + IIF(YEAR(REGVEN.FECEMI_REF)=1900,'01/01/0001',DTOC(REGVEN.FECEMI_REF)) +"|"
			wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODREF),2)	+"|"
			wcad = wcad + IIF(empty(serie_ref) or TRIM(serie_ref)=='0' or VAL(serie_ref)=0,'-',ALLTRIM(REGVEN.SERIE_REF))		+"|"
			wcad = wcad + IIF(empty(numero_ref) or TRIM(numero_ref)=='0','-',ALLTRIM(REGVEN.NUMERO_REF))	+"|"
			** Valor FOB
			wcad = wcad +  "|"
			wcad = wcad + ALLTRIM(NVL(REGVEN.ESTADO_OPE,'1')) + "|"
			** Campo libre utilizacion , si esta en blanco , no concaternar nada 
			=fput(wdriver,wcad)    
	ENDPROC


	*-- Procedimiento para armar la cadena por cada registro del archivo txt v5
	PROCEDURE le_14_01_gen_txt_v5


			LsFecha = IIF(ISNULL(REGVEN.cte_fecven),NVL(REGVEN.cte_fecven, ' '),IIF(EMPTY(REGVEN.cte_fecven),' ',DTOC(REGVEN.cte_fecven) ))
			wcad = ALLTRIM(REGVEN.periodo)				+"|"
			** CUO Codigo unico de operación e.g. Operacion contable, libro contable, sub-diario , paquete
			DO CASE
				CASE UPPER(GsSigcia) = 'OLTURSA'
					wcad = wcad + 'CC'				+"|"
					wcad = wcad + 'M'+'I'+ALLTRIM(REGVEN.asiento)		+"|"
				OTHERWISE 
					wcad = wcad + ALLTRIM(ASIENTO)	+"|"
					wcad = wcad + 'M'+ALLTRIM(REGVEN.NROITM)		+"|"
			ENDCASE 
			** VETT:Control de las series que incluyen letras- Documentos creados en SEE - SOL - SFS 2022/02/18 16:43:41 **
			** QUEDA PENDIENTE AGREGAR ESTA REGLA DE NEGOCIO FUERA DEL CODIGO &&RN001:SERIE 2022/02/18 16:43:41 **
			m.LsSerLet1 = ''
			m.LsSerLet2 = ''
			IF GsSigCia='CAUCHO'
				LsCodDoc	= REGVEN.T10_CODT10
				LsCodRef	= REGVEN.T10_CODREF
				LsSerie		= ALLTRIM(REGVEN.SERIE)
				LsSerie_Ref	= ALLTRIM(REGVEN.SERIE_REF)
				LsSerie_RefA= ALLTRIM(REGVEN.SERIE_REF)
				** VETT:Control de las series que incluyen letras- Documentos creados en SEE - SOL - SFS 2022/02/18 16:43:41 **
				m.lcReturnToMe = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
				m.LcSource  = LsSerie
				m.LsSerLet1	= CHRTRAN(m.lcSource, CHRTRAN(m.lcSource, m.lcReturnToMe, SPACE(0)), SPACE(0))
				m.LcSource  = LsSerie_Ref
				m.LsSerLet2	= CHRTRAN(m.lcSource, CHRTRAN(m.lcSource, m.lcReturnToMe, SPACE(0)), SPACE(0))

				LlNotaFACT	= INLIST(LsCodDoc,'07','08') AND LsCodRef='01'
				LlNotaBOLE	= INLIST(LsCodDoc,'07','08') AND LsCodRef='03'
				LsLetraDOC	= IIF(INLIST(SUBSTR(REGVEN.SERIE,1,1),'F','B'),REGVEN.SERIE,ICASE(LsCodDoc="01",'F',LsCodDoc="03",'B',LlNotaFACT,"F", LlNotaBOLE,"B","") )
				LsLetraRef	= ICASE(LlNotaFACT,'F',LlNotaBOLE,'B',"")
				LsSerie		= IIF(EMPTY(m.LsSerLet1) AND !EMPTY(LsLetraDOC),STUFF(LsSerie,1,1,LsLetraDOC),LsSerie)
				LsSerie_Ref	= IIF((EMPTY(m.LsSerLet2) AND !EMPTY(LsLetraREF)) AND (LlNotaFACT or LlNotaBOLE) ,STUFF(LsSerie_Ref,1,1,LsLetraREF),LsSerie_REF)
		 		** VETT 2022/02/18 16:43:41 **
			ELSE
				LsSerie 	= REGVEN.SERIE
				LsSerie_ref	= REGVEN.SERIE_REF
				LsSerie_RefA= ALLTRIM(REGVEN.SERIE_REF)
			ENDIF
			wcad = wcad + DTOC(REGVEN.cte_fecemi)		+"|"
			wcad = wcad + LsFecha							+"|"
			wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODT10),2)	+"|"
			wcad = wcad + ALLTRIM(LsSerie)				+"|"	&& ALLTRIM(REGVEN.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NUMERO)		+"|"
			wcad = wcad + ALLTRIM(REGVEN.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGVEN.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXPORT,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFECTO,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFE_DE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV_DE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXONER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.VAL_INAFEC,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ISC,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.BASIMP_IVA,15,2))  +"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IVAP,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ICBPER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.OTROS_TRIB,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.IMP_TOTAL,15,2))	+"|"
			wcad = wcad + ALLTRIM(REGVEN.T04_CODT04)			+"|"
			wcad = wcad + ALLTRIM(STR(REGVEN.CTE_TIPCAM,7,3))	+"|"
			wcad = wcad + IIF(YEAR(REGVEN.FECEMI_REF)=1900,'01/01/0001',DTOC(REGVEN.FECEMI_REF)) +"|"
			wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODREF),2)	+"|"
			wcad = wcad + IIF(empty(LsSerie_ref) or TRIM(LsSerie_ref)=='0' or (EMPTY(m.LsSerLet2) AND VAL(LsSerie_refA)=0),'-',ALLTRIM(LsSERIE_REF))	 +"|"  &&RN001 && IIF(empty(serie_ref) or TRIM(serie_ref)=='0' or VAL(serie_ref)=0,'-',ALLTRIM(REGVEN.SERIE_REF))		+"|"
			wcad = wcad + IIF(empty(numero_ref) or TRIM(numero_ref)=='0','-',ALLTRIM(REGVEN.NUMERO_REF))	+"|"
			wcad = wcad + ALLTRIM(REGVEN.IDE_SOCIRR)				+"|"
			wcad = wcad + ALLTRIM(REGVEN.IND_TCA_IN)			+"|"
			wcad = wcad + ALLTRIM(REGVEN.IND_MEDIOP)				+"|"
			wcad = wcad + ALLTRIM(NVL(REGVEN.ESTADO_OPE,'1')) + "|"
			** Campo libre utilizacion , si esta en blanco , no concaternar nada 
			=fput(wdriver,wcad)    
	ENDPROC


	*-- Estructura DBF para libro de ventas v4
	PROCEDURE struct_140100_v4
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + This.PLEAliaslib+This.PLEPeriod  &&STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
			** VETT  24/07/2014 06:27 PM : EJ: "D:\o-negocios\oltursa\local\"+"RV" + "2014"+"06"  => "D:\o-negocios\oltursa\local\RV201406"
		ENDIF
		** Borramos tablas para evitar problemas de corrupción de archivos
		IF FILE(LcRutaFileVMOV+'.dbf')
			DELETE FILE LcRutaFileVMOV+'.dbf'
			DELETE FILE LcRutaFileVMOV+'.fpt'
			DELETE FILE LcRutaFileVMOV+'.cdx'
		ENDIF

		IF !FILE(LcRutaFileVMOV+'.dbf')

			this.TxtEstadoProceso2.Caption	=	[CREANDO ESTRUCTURA DE DATOS... ]


			SELECT 0
			CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
						     CIA_CODCIA C(2),;
						      PERIODO C(8), ;
						      ASIENTO  C(15), ;
						      NROITM    C(10), ;
						      CTE_FECEMI    D, ;
						      CTE_FECVEN   D, ;
						      T10_CODT10 C(2),  ;
						      SERIE	 C(15), ;
						      NUMERO C(10), ;
						      ULT_NUMERO C(10), ;
						      T02_CODT02 C(1), ;
						      RUC C(11), ;
						      NOMBRE C(30), ;
						      VAL_EXPORT N(15,2), ;
						      VAL_AFECTO N(15,2), ;
						      VAL_EXONER N(15,2), ;
						      VAL_INAFEC   N(15,2) , ;
						      IMP_ISC N(15,2),  ;
						      IMP_IGV N(15,2) ,  ;
						      BASIMP_IVA N(15,2), ;
						      IMP_IVAP N(15,2) , ;
						      OTROS_TRIB N(15,2), ;
						      IMP_TOTAL N(15,2), ;
						      CTE_TIPCAM	 N(7,3) ,;
						      FECEMI_REF D,;
						      T10_CODREF C(4), ;
						      SERIE_REF C(4),;
						      NUMERO_REF C(10),;
						      VALOR_FOB N(15,2),;
						      ESTADO_OPE C(1),;
						      LOCA C(60) ,;
						      LOC2 C(60) ,;
						      DELO C(60),;
						      DETA C(20),;
						      OTRO C(20),;
						      BOLE  C(10),;
						      EMBA  N(10),;
						      CODCTA C(12),;
						      CENCOS	 C(14),;
						      CODCAR C(4),;
						      TIPO_VENTA C(10),;
						      DETA_VENTA C(15),;
						      ESTADO1 C(15) )
						      
			USE	(LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE														      
			INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
			INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
			INDEX ON CODCAR+CENCOS TAG CCTO01
			INDEX ON CENCOS TAG CCTO02
			INDEX ON CODCAR+CODCTA TAG CCTA01
			INDEX ON CODCTA TAG CCTA02

		ELSE
			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE
			ZAP
			this.TxtEstadoProceso2.Caption	=	[BORRANDO DATOS DEL PROCESO ANTERIOR ...]

		ENDIF
	ENDPROC


	*-- Estructura DBF para libro de COMPRAS v5
	PROCEDURE struct_080100_v5
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + This.PLEAliaslib+This.PLEPeriod  && STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
			** VETT  24/07/2014 06:27 PM : EJ: "D:\o-negocios\oltursa\local\"+"RV" + "2014"+"06"  => "D:\o-negocios\oltursa\local\RV201406"
		ENDIF
		** Borramos tablas para evitar problemas de corrupción de archivos
		IF FILE(LcRutaFileVMOV+'.dbf')
			DELETE FILE LcRutaFileVMOV+'.dbf'
			DELETE FILE LcRutaFileVMOV+'.fpt'
			DELETE FILE LcRutaFileVMOV+'.cdx'
		ENDIF

		IF !FILE(LcRutaFileVMOV+'.dbf')

			this.TxtEstadoProceso2.Caption	=	[CREANDO ESTRUCTURA DE DATOS... ]
			** VETT:Sunat impuesto bolsas plasticas ICBPER PLE 5.2 2021/01/15 14:39:07 ** 

			SELECT 0
			CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
						     CIA_CODCIA C(2),;
						      PERIODO C(8), ;
						      ASIENTO  C(15), ;
						      NROITM    C(10), ;
						      CTE_FECEMI    D, ;
						      CTE_FECVEN   D, ;
						      T10_CODT10 C(2),  ;
						      SERIE	 C(20), ;
						      ANO_DUA	C(4), ;
						      NUMERO C(20), ;
						      ULT_NUMERO C(10), ;
						      T02_CODT02 C(1), ;
						      RUC C(11), ;
						      NOMBRE C(30), ;
						      BI_GRA_DER N(15,2),;  
						      IM_GRA_DER N(15,2),;
						      BI_GRA_MIX N(15,2),;
						      IM_GRA_MIX N(15,2),;
						      BI_GRA_SDE N(15,2),;
						      IM_GRA_SDE N(15,2),;
						      BI_NO_GRAV N(15,2),;
						      IMP_ISC    N(15,2),;
						      IMP_ICBPER N(15,2),;
						      OTROS_TRIB N(15,2),;
						      IMP_TOTAL  N(15,2),;
						      T04_CODT04 C(3), ;
						      CTE_TIPCAM N(7,3) ,;
						      FECEMI_REF D,;
						      T10_CODREF C(4),;
						      SERIE_REF  C(4),;
						      CO_DUA_DSI C(3),;
						      NUMERO_REF C(10),;
						      DPP_FECPST  D, ;
						      DPP_DEPPST  C(24),;
						      DPP_INDDET  C(1) , ;
						      IRI_CODIRI   C(1) , ;
						      IND_BYS_AD  C(1) , ;
						      IDE_SOCIRR  C(12) , ;
						      IND_TCA_IN C(1) , ;
						      IND_RUC_NH C(1) , ;
						      IND_APEND1 C(1) , ;
						      IND_LIQCOM C(1) , ;
						      IND_MEDIOP  C(1) ,;
						      ESTADO_OPE  C(1),;
						      CODCTA      C(12),;
						      CENCOS	  C(14),;
						      CODCAR      C(4),;
						      TIPO_COMPR C(10),;
						      DETA_COMPR C(15),;
						      N_CP_N_DOM C(20) ,; 
						      ESTADO1     C(15) )
						      
			USE	(LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE														      
			INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
			INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
			INDEX ON CODCAR+CENCOS TAG CCTO01
			INDEX ON CENCOS TAG CCTO02
			INDEX ON CODCAR+CODCTA TAG CCTA01
			INDEX ON CODCTA TAG CCTA02

		ELSE
			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS (PsTblDestino) EXCLUSIVE
			ZAP
			this.TxtEstadoProceso2.Caption	=	[BORRANDO DATOS DEL PROCESO ANTERIOR ...]

		ENDIF
	ENDPROC


	PROCEDURE le_08_01_gen_txt_v4
			LsND = ALLTRIM(REGCOM.NUMERO)
			WAIT WINDOW REGCOM.asiento nowait
			wcad =  ALLTRIM(REGCOM.periodo)		+"|"
			wcad = wcad + ALLTRIM(REGCOM.asiento)		+"|"
			wcad = wcad + 'M'+ALLTRIM(REGCOM.NROITM)	+"|"
			wcad = wcad + DTOC(REGCOM.cte_fecemi)		+"|"
			wcad = wcad + DTOC(REGCOM.cte_fecven)		+"|"
			wcad = wcad + ALLTRIM(REGCOM.T10_CODT10)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.ANO_DUA)		+"|"
			wcad = wcad + ICASE(INLIST(T10_CODT10,'01','03','04','06','07','08','23' ),RIGHT(LsND,7),LsND )		+"|"
			wcad = wcad + ALLTRIM(REGCOM.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_DER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_DER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_MIX,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_MIX,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_SDE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_SDE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_NO_GRAV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IMP_ISC,15,2))			+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.OTROS_TRIB,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IMP_TOTAL,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.CTE_TIPCAM,7,3))		+"|"
			wcad = wcad + IIF(YEAR(REGCOM.FECEMI_REF)=1900,'01/01/0001',DTOC(REGCOM.FECEMI_REF)) +"|"
			wcad = wcad + ALLTRIM(REGCOM.T10_CODREF)	+"|"	    &&26
			wcad = wcad + ALLTRIM(REGCOM.SERIE_REF)		+"|"		&& 27
			wcad = wcad +  	"|"											&& 28
			wcad = wcad + ALLTRIM(REGCOM.NUMERO_REF)	+"|"		&& 29 
			wcad = wcad + ALLTRIM(REGCOM.N_CP_N_DOM)	+"|"	                && 30
			wcad = wcad + IIF(YEAR(REGCOM.DPP_FECPST)=1900,'01/01/0001',DTOC(REGCOM.DPP_FECPST)) +"|"  && 31
			wcad = wcad + ALLTRIM(REGCOM.DPP_DEPPST)	+"|"	 && 32
			wcad = wcad + ALLTRIM(REGCOM.DPP_INDDET)	+"|"	 && 33 
			wcad = wcad + ALLTRIM(NVL(REGCOM.ESTADO_OPE,'1')) + "|" && 34
		    =fput(wdriver,wcad)    
	ENDPROC


	PROCEDURE le_08_01_gen_txt_v5
			LsND = ALLTRIM(REGCOM.NUMERO)
			LsFchVto=iif(inlist(REGCOM.RUC,'20100177774','20100152356','20331898008','20106897914','20269985900','20467534026','20100017491'),DTOC(REGCOM.cte_fecven),'')
			WAIT WINDOW REGCOM.asiento nowait
			wcad =  ALLTRIM(REGCOM.periodo)		+"|"
			wcad = wcad + ALLTRIM(REGCOM.asiento)		+"|"
			wcad = wcad + 'M'+ALLTRIM(REGCOM.NROITM)	+"|"
			wcad = wcad + DTOC(REGCOM.cte_fecemi)		+"|"
			wcad = wcad + LsFchVto						+"|"	&& DTOC(REGCOM.cte_fecven)
			wcad = wcad + ALLTRIM(REGCOM.T10_CODT10)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.SERIE)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.ANO_DUA)		+"|"
			wcad = wcad + ICASE(INLIST(T10_CODT10,'01','03','04','06','07','08','23' ),RIGHT(LsND,7),LsND )		+"|"
			wcad = wcad + ALLTRIM(REGCOM.ULT_NUMERO)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.T02_CODT02)	+"|"
			wcad = wcad + ALLTRIM(REGCOM.RUC)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.NOMBRE)		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_DER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_DER,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_MIX,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_MIX,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_GRA_SDE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IM_GRA_SDE,15,2))	+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.BI_NO_GRAV,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IMP_ISC,15,2))			+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IMP_ICBPER,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.OTROS_TRIB,15,2))		+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.IMP_TOTAL,15,2))		+"|"
			wcad = wcad + ALLTRIM(REGCOM.T04_CODT04)				+"|"
			wcad = wcad + ALLTRIM(STR(REGCOM.CTE_TIPCAM,7,3))		+"|"
			wcad = wcad + IIF(YEAR(REGCOM.FECEMI_REF)=1900,'01/01/0001',DTOC(REGCOM.FECEMI_REF)) +"|"
			wcad = wcad + ALLTRIM(REGCOM.T10_CODREF)		+"|"	    &&26
			wcad = wcad + ALLTRIM(REGCOM.SERIE_REF)		+"|"		&& 27
			wcad = wcad + ALLTRIM(REGCOM.CO_DUA_DSI)		+"|"
			wcad = wcad + ALLTRIM(REGCOM.NUMERO_REF)	+"|"		&& 29 
			wcad = wcad + IIF(YEAR(REGCOM.DPP_FECPST)=1900,'01/01/0001',DTOC(REGCOM.DPP_FECPST)) +"|"  && 31
			wcad = wcad + ALLTRIM(REGCOM.DPP_DEPPST)			+"|"	 && 32
			wcad = wcad + IIF(ALLTRIM(REGCOM.IRI_CODIRI)='0','',ALLTRIM(REGCOM.IRI_CODIRI))		+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_BYS_AD)		+"|"
			wcad = wcad + ALLTRIM(REGCOM.IDE_SOCIRR)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_TCA_IN)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_RUC_NH)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_APEND1)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_LIQCOM)			+"|"
			wcad = wcad + ALLTRIM(REGCOM.IND_MEDIOP)			+"|"
			wcad = wcad + ALLTRIM(NVL(REGCOM.ESTADO_OPE,'1')) + "|" && 34
		    =fput(wdriver,wcad)    
	ENDPROC


	*-- Registro de compras no domiciliados
	PROCEDURE procesa_le_08_02
		thisform.Cierra_Temporales
		this.TxtEstadoProceso1.Caption	=	[GENERANDO ARCHIVO SUNAT - LIBRO COMPRAS NO DOMICILIADOS....!!!] 
		this.TxtEstadoProceso2.Caption	=	[] 
		thisform.TxtEstadoProceso1.Refresh 
		thisform.TxtEstadoProceso2.Refresh 

		*** 1. Variables
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '080200' 
		LsAliasLib = 'RCND'
		LsAliasPre = 'P_RCND'

		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)


		** VETT  19/06/2017 10:19 AM : Verificamos si REGCOM esta abierto sino reabrimos
		IF !USED('REGCOMND')
			SELECT 0
			USE ADDBS(goentorno.locpath)+LsAliasLib +lPeriod ALIAS REGCOMND
		ELSE
			SELECT REGCOMND
		ENDIF
		SET ORDER TO
		SET FILTER TO 
		**** VERIFICA SI EXISTEN REGISTROS
		LnTotReg = 0
		COUNT FOR INLIST(Estado_OPE,'1','2','6','8','9') AND INLIST(T10_CODT10,'00','91','97','98') TO LnTotReg
		LcFlgDat 	= IIF(LnTotReg=0,'0','1')

		*** 3. Define Nombre de la Tabla SUNAT
		wform   = "Libro_Electronico_RegComp_" 
		wfile   = "LE" + lruccia       + lperpco + llibro + '00'      + '1'    + LcFlgDat   + '1'    +  '1'         + '.TXT'
		*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - SITUACION - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
		*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES

		wfile_xls =wform+lperpco
		wruta   = ADDBS(TRIM(This.TxtUbicacionArchivos.Value)) && curdir()+lruta   
		IF !DIRECTORY(wruta)
			MKDIR (wruta)
		ENDIF
		IF FILE(wruta+wfile)
			DELETE FILE (wruta+wfile)
		ENDIF
		wdriver = fcreate(wruta+wfile)
		if wdriver<0
		   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
		   RETURN .f.
		endif
		WAIT WINDOW "Generando archivo: "+wruta+wfile NOWAIT 
		LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '

		*** 4. Genera Archivo SUNAT

		SELECT REGCOMND
		LnRegAct = 0
		LOCATE
		SCAN FOR INLIST(Estado_OPE,'1','2','6','8','9')
			LnRegAct = LnRegAct + 1
			IF LnTotReg>0
				this.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
			ENDIF
			IF NOT INLIST(T10_CODT10,'00','91','97','98') && No domiciliados
				LOOP 
			ENDIF
		    *corrige # de serie
		    IF REGCOMND.ANO_DUA='0' AND LEN(ALLTRIM(REGCOMND.SERIE)) < 4
		       IF !REGCOMND.T10_CODT10 $ '54,91'
			       REPLACE REGCOMND.SERIE WITH RIGHT('0000' + ALLTRIM(REGCOMND.SERIE),4)
			   ENDIF
		    ENDIF

		    *corrige # documento
		    IF VAL(REGCOMND.NUMERO)#0 AND !REGCOMND.T10_CODT10$'50,51,52,53'
		       wnumero = STR(ROUND(VAL(REGCOMND.NUMERO),0),10)
		    ELSE
		       IF !REGCOMND.T10_CODT10$'50,51,52,53'
			       wnumero = REGCOMND.NUMERO
			   ELSE
			       wnumero = SUBSTR(REGCOMND.NUMERO,10,6)
			   ENDIF
		    ENDIF    
		    
		   
		    *corrige numero de serie - BOLETO PASAJE AEREO
		    IF REGCOMND.T10_CODT10 = '05'  && BOLETO PASAJE AEREO
		       wserie = STRTRAN(REGCOMND.SERIE,'0','')
				&& 1 -BOLETO MANUAL
				&& 2 -BOLETO AUTOMATICO
				&& 3 -BOLETO ELECTRONICO
				&& 4 -OTROS
		    ELSE	 
		       wserie = REGCOMND.SERIE
		    ENDIF 
		     
		*!*		WAIT WINDOW REGCOMND.asiento nowait

			wcad = 		  ALLTRIM(REGCOMND.periodo)				+"|"
			wcad = wcad + ALLTRIM(REGCOMND.asiento)				+"|"
			wcad = wcad + ALLTRIM(REGCOMND.NroItm)				+"|"
			wcad = wcad + DTOC(REGCOMND.cte_fecemi)					+"|"
			wcad = wcad + ALLTRIM(REGCOMND.T10_CODT10)				+"|"
			wcad = wcad + ALLTRIM(wserie)									+"|"
			wcad = wcad + ALLTRIM(wNUMERO)							+"|"
			wcad = wcad + ALLTRIM(STR(VALOR_ADQ,15,2))				+"|"
			wcad = wcad + ALLTRIM(STR(IMPOTRNOBI,15,2))			+"|"
			wcad = wcad + ALLTRIM(STR(IMPTOT_ADQ,15,2))			+"|"
			wcad = wcad + IIF(LEN(ALLTRIM(T10_C_SUST))=0,'00',ALLTRIM(T10_C_SUST))	+"|"
			wcad = wcad + IIF(LEN(ALLTRIM(SER_DUA))=0,'-',ALLTRIM(SER_DUA))						+"|"
			wcad = wcad + ALLTRIM(REGCOMND.ANO_DUA)					+"|"
			wcad = wcad + IIF(LEN(ALLTRIM(NUM_DUA))=0,'-',ALLTRIM(NUM_DUA))						+"|"
			wcad = wcad + ALLTRIM(STR(IMPIGV_RET,15,2))			+"|"
			wcad = wcad + ALLTRIM(T04_CODT04)						+"|"
			wcad = wcad + ALLTRIM(STR(REGCOMND.CTE_TIPCAM,7,3))		+"|"
			wcad = wcad + IIF(LEN(ALLTRIM(T35_CODT35))=0,'9589',ALLTRIM(T35_CODT35))			+"|"
			wcad = wcad + ALLTRIM(NOMBRE)							+"|"
			wcad = wcad + ALLTRIM(DIRECCION)						+"|"
			wcad = wcad + ALLTRIM(NUM_IDE)							+"|"
			wcad = wcad + ALLTRIM(NUM_IDE_BE)					+"|"
			wcad = wcad + IIF(LEN(ALLTRIM(NOMBRE_BE))=0,'-',ALLTRIM(NOMBRE_BE))			+"|"
			wcad = wcad + ALLTRIM(T35_COD_BE)					+"|"
			wcad = wcad + ALLTRIM(T27_CODT27)						+"|"
			wcad = wcad + ALLTRIM(STR(RENTA_BRUT,15,2))			+"|"
			wcad = wcad + ALLTRIM(STR(DEDUCCION,15,2))				+"|"
			wcad = wcad + ALLTRIM(STR(RENTA_NETA,15,2))				+"|"
			wcad = wcad + ALLTRIM(STR(TASA_RETEN,6,2))			+"|"
			wcad = wcad + ALLTRIM(STR(IMPU_RETEN,15,2))			+"|"
			wcad = wcad + ALLTRIM(T25_CODT25)						+"|"
			wcad = wcad + ALLTRIM(T33_CODT33)						+"|"
			wcad = wcad + ALLTRIM(T31_CODT31)						+"|"
			wcad = wcad + ALLTRIM(T32_CODT32)						+"|"
			wcad = wcad + ALLTRIM(IND_APLI76)						+"|"
			wcad = wcad + ALLTRIM(REGCOMND.ESTADO_OPE)				+"|"			&&ALLTRIM(REGCOMND.ESTADO_OPE)
			*!*

		    =fput(wdriver,wcad)    
		    SELECT REGCOMND
		ENDSCAN
		=fclose(wdriver)

		RETURN .T.
	ENDPROC


	*-- Estructura registro de compras no domiciliados
	PROCEDURE struct_080200_v5
		IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
			LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + This.PLEAliaslib+This.PLEPeriod  && STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
			** VETT  24/07/2014 06:27 PM : EJ: "D:\o-negocios\oltursa\local\"+"RV" + "2014"+"06"  => "D:\o-negocios\oltursa\local\RV201406"
		ENDIF
		** Borramos tablas para evitar problemas de corrupción de archivos
		IF FILE(LcRutaFileVMOV+'.dbf')
			DELETE FILE LcRutaFileVMOV+'.dbf'
			DELETE FILE LcRutaFileVMOV+'.fpt'
			DELETE FILE LcRutaFileVMOV+'.cdx'
		ENDIF

		IF !FILE(LcRutaFileVMOV+'.dbf')

			this.TxtEstadoProceso2.Caption	=	[CREANDO ESTRUCTURA DE DATOS... ]


			SELECT 0
			CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
						     CIA_CODCIA C(2),;
						      PERIODO C(8), ;
						      ASIENTO  C(15), ;
						      NROITM    C(10), ;
						      CTE_FECEMI    D, ;
						      CTE_FECVEN   D, ;
						      T10_CODT10 C(2),  ;
						      SERIE	 C(20), ;
						      NUMERO C(20), ;
						      VALOR_ADQ N(15,2),;  
						      IMPOTRNOBI N(15,2),;   
						      IMPTOT_ADQ N(15,2),;
						      T10_C_SUST C(2),  ;
						      SER_DUA	C(20), ;
						      ANO_DUA	C(4), ;
						      NUM_DUA	C(24),;	      
						      IMPIGV_RET N(15, 2),;
						      T04_CODT04 C(3), ;
						      CTE_TIPCAM N(7,3) ,;
						      T35_CODT35 C(4) ,;
						      NOMBRE C(100) ,;
						      DIRECCION C(100),;
						      NUM_IDE C(15),;
						      NUM_IDE_BE C(15),;
						      NOMBRE_BE C(100),;
						      T35_COD_BE C(4),;
						      T27_CODT27  C(2) ,;
						      RENTA_BRUT N(15, 2) ,;
						      DEDUCCION N(15, 2),;
						      RENTA_NETA N(15, 2),;
						      TASA_RETEN N(6, 2),;
						      IMPU_RETEN N(15, 2),;
						      T25_CODT25  C(2)	,;
						      T33_CODT33 C(1)	,;
						      T31_CODT31  C(2) ,;
						      T32_CODT32  C(1) ,;
						      IND_APLI76  C(1) , ;
						      ESTADO_OPE  C(1),;
						      CODCTA      C(12),;
						      CENCOS	  C(14),;
						      CODCAR      C(4),;
						      TIPO_COMPR C(10),;
						      DETA_COMPR C(15),;
						      PERIODO2 C(8) ,; 
						      ESTADO1     C(15) )
						      
			USE	(LcRutaFileVMOV)  ALIAS (This.PLETablaDestino) EXCLUSIVE														      
			INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
			INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
			INDEX ON CODCAR+CENCOS TAG CCTO01
			INDEX ON CENCOS TAG CCTO02
			INDEX ON CODCAR+CODCTA TAG CCTA01
			INDEX ON CODCTA TAG CCTA02

		ELSE
			SELECT 0
			USE (LcRutaFileVMOV)  ALIAS (This.PLETablaDestino) EXCLUSIVE
			ZAP
			this.TxtEstadoProceso2.Caption	=	[BORRANDO DATOS DEL PROCESO ANTERIOR ...]

		ENDIF
	ENDPROC


	*-- Cierra cursores temporales de trabajo
	PROCEDURE cierra_temporales
		IF USED(THISFORM.PleTablaDestino)
			USE IN THISFORM.PleTablaDestino
		ENDIF
		IF USED('RegVenRitem')
			USE IN 'RegVenRitem'
		ENDIF
		IF USED('RegVenCorr')
			USE IN 'RegVenCorr'
		ENDIF
		IF USED('RegComCorr')
			USE IN 'RegComCorr'
		ENDIF
		IF USED('ErrRucDni')
			USE IN 'ErrRucDni'
		ENDIF
		IF USED('Temporal')
			USE IN 'Temporal'
		ENDIF
	ENDPROC


	PROCEDURE query_pasajes
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LsAliasPre = 'P_RV'
		thisform.tools.closetable('TMOD')
		IF !USED('TMOD')
			SELECT 0
			USE ADDBS(goentorno.tspathadm)+'tablasmodulo' ORDER PK1 ALIAS TMOD
		ENDIF
		=SEEK('OLT01','TMOD')
		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)

		Ls_Fecha_1='01/'+LsMes+'/'+LsAno
		Ls_fecha_2=DTOC(GdFecha)

		*** Actualizamos fecha referencia de N/Creditos buscando en sistemas de Cargo y FICS
					thisFORM.TxtEstadoProceso2.Caption	=  'Probando acceso a Notas de Credito en BD de Pasajes...' 
					 
		*!*				LsStringFICS = "driver={SQL Server};server=192.168.1.5;Database=WF_OLTR;uid=sa;pwd=oltursasa;"
					LsStringFICS	= Thisform.Ocnx_Odbc.cStringCnx2 
		*!*				CnFICS= SQLSTRINGCONNECT(LsStringFICS)
					LsQryFICS = "SELECT ComprobanteNumero AS NumeroNC,FechaEmision AS FechaNC, " 
					LsQryFICS = LsQryFICS +  "T1.FechaOperacion AS Fch_Boleto,T2.Numero AS Boleto  From Pasajes_Comprobantes " 
					LsQryFICS = LsQryFICS +  "inner join PasajesOperaciones T1 ON PasajeID = T1.Pasaje inner join Pasajes T2 ON T2.Id = T1.Pasaje "
					LsQryFICS = LsQryFICS +  "WHERE T1.Operacion in ( 0,13 ) AND year(FechaEmision)=?_Ano and month(FechaEmision)=?LnMes order by FechaNC "

					LsQryNew	= IIF(!EMPTY(TMOD.CadenaSql2),TMOD.CadenaSql2,LsQryFICS)

			*!*					LsQryFICS = LsQryFICS +  "WHERE  ComprobanteNumero = '"+LsNumeroNC +"'"

					LlPrimera=.F.
					FOR LnDia = 1 TO DAY(GdFecha)

						LsDia = TRANSFORM(LnDia,"@L 99")
						Ls_Fecha_1=LsDia+'/'+LsMes+'/'+LsAno
						Ls_fecha_2=LsDia+'/'+LsMes+'/'+LsAno
						CnFICS= SQLSTRINGCONNECT(LsStringFICS)
						SQLSETPROP(CnFICS,"QueryTimeout",60)
						thisFORM.TxtEstadoProceso2.Caption	= 'Obteniendo documento(s) de referencia del dia '+Ls_Fecha_1
						WAIT WINDOW 'Obteniendo documento(s) de referencia del dia '+Ls_Fecha_1 nowait
						LnControlFics  = SQLEXEC(CnFICS,LsQryNew,'NCTemp')
						IF LnControlFics >0
							IF !USED('NcPasajes')
								SELECT * FROM NCTemp INTO CURSOR NCPasajes READWRITE
								LlPrimera = .T.
							ELSE
								SELECT NCPasajes
								APPEND FROM DBF('NCTemp')
							ENDIF
							thisFORM.TxtEstadoProceso2.Caption	= 'Obteniendo documento(s) de referencia del dia '+Ls_Fecha_1 + ' OK' 
						    WAIT WINDOW 'Obteniendo documento(s) de referencia del dia '+Ls_Fecha_1 + ' OK' nowait
						ELSE 
						    IF !FILE(THISFORM.Filelogerror4)
							    =STRTOFILE('****TIPO VENTA   T.D.  SERIE  NUMERO    FECHA DOC.      DESCRIPCION '+'         FECHA PROCESO'+ TTOC(DATETIME())+' *****  '+CRLF,Thisform.filelogerror4,.T.)
						    ENDIF
							=STRTOFILE('****  PASAJES   SIN ACCESO A NOTAS DE CREDITO DEL DIA:'+Ls_Fecha_1+'   -  '+TTOC(DATETIME())+' *****  '+CRLF,Thisform.Filelogerror4,.T.)
						ENDIF
						=SQLDISCONNECT(CnFICS)
					ENDFOR

					IF !LlPrimera
						MESSAGEBOX('Error de conexion con base de datos PASAJES '+SUBSTR(LsStringFICS,1,LEN(LsStringFICS)-21),16,'ATENCION')
						RETURN LnControlFics
					ELSE
						LnControlFics = 1
					ENDIF
					SELECT NCPasajes
					INDEX on PADR(Serie,4)+PADR(LTRIM(STR(documento)),10) TAG Numero
					SET ORDER TO Numero
					LOCATE
					IF Thisform.Tag = 'Cursor'
		*!*					INDEX on NumeroNC TAG Numero
		*!*					INDEX on PADR(Serie,4)+PADR(LTRIM(STR(documento)),10) TAG Numero
		*!*					SET ORDER TO Numero
						RETURN LnControlFics
					ELSE
						SELECT NCPasajes
		*!*					INDEX on PADR(Serie,4)+PADR(LTRIM(STR(documento)),10) TAG Numero
		*!*					SET ORDER TO Numero
						LOCATE
						BROWSE
						LsCurDBC1 = SET("Database") 
						LsNewTable=ADDBS(thisform.cDirInterface)+'NcPasaje'+lperiod
						IF verifyvar(LsNewTable,"TABLE",'INDBC','Temporal',thisform.cDirInterface)
							SET DATABASE TO Temporal
							REMOVE TABLE (LsNewTable) DELETE
						ENDIF
						COPY TO (LsNewTable) DATABASE ADDBS(thisform.cDirInterface)+'Temporal'
						IF !EMPTY(LsCurDBC1)
							SET DATABASE TO (LsCurDbc1)
						ENDIF
					ENDI
	ENDPROC


	PROCEDURE query_cargo

		thisform.tools.closetable('TMOD')
		IF !USED('TMOD')
			SELECT 0
			USE ADDBS(goentorno.tspathadm)+'tablasmodulo' ORDER PK1 ALIAS TMOD
		ENDIF
		=SEEK('OLT02','TMOD')
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LsAliasPre = 'P_RV'
		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)

			thisForm.TxtEstadoProceso2.Caption	=  'Probando acceso a Notas de Credito de BD de CARGO...' 
		*!*				LsStringCARGO= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=192.168.1.6;PORT=5444;UID=enterprisedb;PWD=admin;]
					LsStringCARGO=Thisform.Ocnx_Odbc.cStringCnx3 
					CnCARGO= SQLSTRINGCONNECT(LsStringCARGO)
					LnClient_encod=SQLEXEC(CnCARGO,[set client_encoding to 'UTF8'])
					LsQryCARGO = ''
		*!*	*!*				LsQryCARGO= [Select FA.co_tipoDocumento,FA.nu_seriedocumento, FA.nu_documento, FA.fe_documento,  ] 
		*!*	*!*				LsQryCARGO  =  LsQryCARGO  + [NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [from "CAR_FACTURA_CA" FA  ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [INNER JOIN "CAR_NOTACREDITO_MA" NC  ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [ ON FA.co_tipoDocumento=NC.co_TipoDocumento AND ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [ FA.nu_seriedocumento = NC.nu_seriedocumento AND FA.nu_documento = NC.nu_documento ] 
		*!*	*!*			 	 LsQryCARGO =  LsQryCARGO  + [ where to_char(fe_notacredito,'YYYYMM')=']+lperiod+[']
					LsQryCARGO=	[Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento,]  +; 
					            [ NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito  ] +;
					  			[FROM  "CAR_NOTACREDITO_MA" Nc, ] + ;
			       				[ "GEN_TERMINALES_MA" Ofi ] + ;
			     				[ , "GEN_PREFIJO_MA" Serie ] + ;
			    				[where to_char(fe_notacredito,'YYYYMM')='] +lperiod+['] + ;
			     				[ and     NC.co_oficina = Ofi.co_terminal ] + ;
			     				[ and    ( NC.co_OFICINA   = Serie.co_terminal ] + ;
				   				[ and      NC.co_estacion  = Serie.co_estacion ] + ;
				   				[ and      '07'            = Serie.co_tipodoc ] + ;
				   				[ and      NC.nu_serie     = Serie.co_prefijo ) ]  

					LsCadenaSql2=STRTRAN(TMOD.cadenasql2,'?lperiod',"'"+lperiod+"'")
				 	LsQryNew	= IIF(!EMPTY(LsCadenaSql2),LsCadenaSql2,LsQryCARGO) 
		*!*				 LsQryCARGO =  LsQryCARGO  + [ where nc.Nu_Serie=']+LsSerie+[' AND NC.Nu_Notacredito=']+LsNumero+[' ]
					LnControlCargo  = SQLEXEC(CnCARGO,LsQryNew,'NCredito')
					=SQLDISCONNECT(CnCARGO)
					IF LnControlCargo<0
						MESSAGEBOX('Error de conexion con base de datos CARGO '+SUBSTR(LsStringCARGO,1,LEN(LsStringCARGO)-27),16,'ATENCION')
						RETURN LnControlCargo
					ENDIF
					SELECT NCredito
					INDEX on Nu_Serie+LTRIM(STR(VAL(Nu_NotaCredito))) TAG Numero
					SET ORDER TO Numero
					IF Thisform.Tag = 'Cursor'

						RETURN LnControlCargo
					ELSE
						SELECT NCredito
		*!*					INDEX on Nu_Serie+Nu_NotaCredito TAG Numero
						** VETT  18/03/2013 06:16 PM : Para encontrarlos sin importar los ceros que tengan a la izquierda del campo numero 
		*!*					INDEX on Nu_Serie+LTRIM(STR(VAL(Nu_NotaCredito))) TAG Numero
		*!*					SET ORDER TO Numero
						LOCATE
						BROWSE
						LsCurDBC1 = SET("Database") 
						LsNewTable=ADDBS(thisform.cDirInterface)+'NcCargo'+lperiod
						IF verifyvar(LsNewTable,"TABLE",'INDBC','Temporal',thisform.cDirInterface)
							SET DATABASE TO Temporal
							REMOVE TABLE (LsNewTable) DELETE
						ENDIF
						COPY TO (LsNewTable) DATABASE ADDBS(thisform.cDirInterface)+'Temporal'
						IF !EMPTY(LsCurDBC1)
							SET DATABASE TO (LsCurDbc1)
						ENDIF

					ENDIF
	ENDPROC


	PROCEDURE Unload
		thisform.closetable('',.t.,['DBFS','ACCESS'])
		DODEFAULT()
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toconexion
		DODEFAULT()
		*** Capturamos parametros de conexion adicionales para el FICS y CARGO  desde el archivo .ini ***
		IF	GoEntorno.SqlEntorno 
			IF 	!Thisform.Ocnx_Odbc.CargaParmsCadCnxArcIni('config.ini')
				MESSAGEBOX('Error en captura de parametros de conexión desde archivo '+LOCFILE('CONFIG.INI'),16)
				Thisform.Conexion2y3	= .F.
			ELSE
				Thisform.Conexion2y3	= .T.
			ENDIF
		ELSE
			Thisform.Conexion2y3	= .F.
		ENDIF
		***
		THISFORM.CboMes.SetFocus()
		 
		thisform.CboMes.Value = XsNroMes
		LsDirIntf = ADDBS(JUSTPATH(JUSTPATH(goentorno.tspathadm)))+'Interface'
		LsDirIntf = IIF(":"$LsDirIntf,LsDirIntf,SYS(5)+LsDirIntf)
		*!*	LsDirIntf = SYS(5)+'\o-Negocios\Interface'
		IF !DIRECTORY(LsDirIntf)
			MD(LsDirIntf)
			=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirIntf+ ;
			'  Este directorio se usara para buscar los archivos de .txt o .csv necesarios para realizar la interface de datos',64,'ATENCION !!' )
		ENDIF
		thisform.tag = SYS(5)+CURDIR()

		this.AddProperty('cDirInterface',LsDirIntf)
		*!*	CD(thisform.cDirInterface)
		thisform.chkOpeMes.Value = .F.
		Thisform.TxtUbicacionArchivos.Value = thisform.cDirInterface
		LsRutaLibros= ADDBS(thisform.cDirInterface)+'libros_electronicos\cia_'+IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  && RIGHT(GsCodCia,2)
		Thisform.TxtUbicacionArchivos.Value = LsRutaLibros
		IF !DIRECTORY(LsRutaLibros)
			MD(LsRutaLibros)
			=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsRutaLibros+ ;
			'  Este directorio se usara para guardar los archivos de .txt o .csv o .xls necesarios para generar los Libros Electronicos',64,'ATENCION !!' )
		ENDIF
		Thisform.TxtArchivoRepetidos.Value 		=  ''
		Thisform.TxtArchivoCorrelativos.Value	=  ''
		Thisform.TxtErrorRucDNI.Value	=  ''
		Thisform.OpgLibrosProcesar.Value = 3
		Thisform.OpgLibrosProcesar.Option3.Click   
		Thisform.OpgCargadores.Visible 			= UPPER(GsSigCia)='OLTURSA'
		Thisform.LblCargadoresExactus.Visible	= UPPER(GsSigCia)='OLTURSA'
		Thisform.LblReprocesoTXT.Visible 		= UPPER(GsSigCia)='OLTURSA'
		Thisform.opgReproceso.Visible			= UPPER(GsSigCia)='OLTURSA'  
		** VETT:Libro Mayor y Libro Diario 2022/02/18 01:33:42 **
		Thisform.LblRepro_PLE_RV_2013.Visible 		= UPPER(GsSigCia)='OLTURSA'  
		Thisform.OpgRepro_PLE_RV_2013.Visible 		= UPPER(GsSigCia)='OLTURSA'  
		Thisform.CmdrRutaCargador.Visible			= UPPER(GsSigCia)='OLTURSA'
		*!*	Thisform.LblUbiCargadores.Visible		= UPPER(GsSigCia)='OLTURSA'   
		Thisform.CboTpoOriDat.Value = '(LOCAL)' 

		Thisform.CmdRepro_Ple_RV2013.Visible =  UPPER(GsSigCia)='OLTURSA'
		thisform.OpgRepro_PLE_RV_2013.Valid
		** VETT  29/08/16 07:37 : Version de 26 Agosto 2016

		thisform.Filelogerror1	= ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrCTOCTA.txt'
		thisform.Filelogerror2  = ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorRAGEN.txt'
		thisform.Filelogerror3  = ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorVCORP.txt'
		thisform.Filelogerror4  = ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorDocumentos.txt'
	ENDPROC


	PROCEDURE Load
		DODEFAULT()
		goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','')
		goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
	ENDPROC


	*-- Genera cargador de registros anulados
	PROCEDURE generacargadoranulados
	ENDPROC


	*-- Ruta para grabar los archivos a ser usados por el FACTURADOR SEE - SFS - SUNAT
	PROCEDURE ruta_factura_see_sfs
	ENDPROC


	PROCEDURE cmdprocesar1.Click
		Thisform.LlRegError1 = .F.
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 
		thisform.TxtEstadoProceso1.Caption = '..' 
		thisform.TxtEstadoProceso2.Caption = '....' 
		 
		LnControl = 1
		*
		XsAno		= STR(_ANO,4,0)
		XsNroMes = TRIM(This.Parent.cbomes.Value)
		*!*	XsCodOpe = TRIM(This.Parent.CntCodOpe.Value)
		CsCodCco =  '' && This.Parent.cntCodCco.Value
		XiCodMon = 1   && this.Parent.opgCodMon.Value  
		IF XiCodMon= 1
			XsNombre = 'EN SOLES' 
		ELSE
			XsNombre = 'EN DOLARES' 
		ENDIF
		XnOrden = 2 && this.Parent.opgOrden.Value

		*!*	Thisform.TxtUbicacionArchivos.Value = thisform.cDirInterface
		LsRutaLibros = Thisform.TxtUbicacionArchivos.Value
		IF !DIRECTORY(LsRutaLibros)
			MD(LsRutaLibros)
			=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsRutaLibros+ ;
			'  Este directorio se usara para guardar los archivos de .txt o .csv o .xls necesarios para generar los Libros Electronicos',64,'ATENCION !!' )
		ENDIF


		*!*	GoEntorno.Sqlentorno = .T.
		*** Validacion y Proceso

		IF !Thisform.Validar_Proceso()
			RETURN
		ENDIF
		IF  MESSAGEBOX("Seguro de ejecutar generación de libros electrónicos contables del periodo: "+STUFF(THISFORM.PLEPeriod,5,0,'-')+" ?",4+32,'ATENCION !')=6


		*!*		IF !thisform.m_log_procesos("1")			&& INSERTA EN LOG DE PROCESOS
		*!*			RETURN .f.
		*!*		ENDIF


		*!*		Ocnx.Modo(2)
			ls_mensaje = ""
			lb_error = .f.
			thisform.TxtEstadoProceso1.Caption = '...' 
			thisform.TxtEstadoProceso2.Caption = '.....' 

			IF !Thisform.Procesar() 
		*!*			ls_mensaje = Ocnx.ErrorMensaje
				lb_error = .t.
		*!*			Ocnx.RollBack()
			ELSE 
		*!*	  	 	Ocnx.Commit()
			ENDIF
		*!*		Ocnx.Modo(1) 


			IF lb_error 
				=MESSAGEBOX(ls_mensaje,16)
			ELSE
		*!*			IF !thisform.m_log_procesos("2")			&& ACTUALIZA FECHA Y HORA DE FINALIZACION DEL PROCESO
		*!*				RETURN .f.
		*!*			ENDIF
				=MESSAGEBOX("PROCESO TERMINO CON EXITO.",64,'ATENCION')

			ENDIF 
		ENDIF
		*!*	GoEntorno.Sqlentorno = .F.

		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE cbomes.Valid
		DO CASE
			CASE This.Parent.OpgLibrosProcesar.Value = 1 
				thisform.PeriodoLibro('050100' )

			CASE This.Parent.OpgLibrosProcesar.Value = 2 
				thisform.PeriodoLibro('080100' )

			CASE This.Parent.OpgLibrosProcesar.Value = 3 
				thisform.PeriodoLibro('140100' )
		ENDCASE
	ENDPROC


	PROCEDURE cmdbuscadestino.Click
		LOCAL LcExtensionDestino,LcArcDestino
		LcExtensionDestino="TXT" 			&& TYPE SDF

		*!*	LcArcDestino=GETFILE(LcExtensionDestino,'Archivo:', 'Aceptar',1,;
		*!*	   'Seleccionar Archivo')
		   
		LcArcDestino=GETFILE(LcExtensionDestino,'Archivo:', 'Aceptar',1,;
		   'Seleccionar Archivo')
		LcArcDestino=GETDIR(LcExtensionDestino,'Archivo:', 'Aceptar',1,;
		   'Seleccionar Archivo')

		  
		THISFORM.TxtArchivoDestino.VALUE=LcArcDestino
	ENDPROC


	PROCEDURE cmdsalir.Click
		thisform.TOOLS.closetable([ACCT])
		CD (Thisform.Tag)
		THISFORM.RELEASE
	ENDPROC


	PROCEDURE chkopemes.Click
		IF THIS.value

			This.Parent.cboMes.Enabled = .T.  
		*!*		This.Parent.CntCodOpe.Enabled = .T. 
		*!*		=MESSAGEBOX('La operacion y mes elegidos afectaran en el respectivo periodo contable',64)
		ELSE
			This.Parent.cboMes.Enabled = .F.  
		*!*		This.Parent.CntCodOpe.Enabled = .F. 
		*!*		=MESSAGEBOX('La operacion y mes elegidos se tomaran de los archivos de interface',64)

		ENDIF
	ENDPROC


	PROCEDURE cmdrecursos1.Valid
		*!*	SELECT 0
		*!*	USE ADDBS(this.Parent.TxtRutaOrig.Value) + 'ADMMCIAS' ALIAS cias_origen
		*!*	this.Parent.cboCiaOrigen.rowsourcetype=6
		*!*	this.Parent.cboCiaOrigen.RowSource='cias_origen.NomCia'
	ENDPROC


	PROCEDURE cmdrecursos1.Click
		*!*	CD(thisform.cDirInterface)

		XsUbi=GETDIR(thisform.cDirInterface)
		IF !EMPTY(XsUbi)
			THISFORM.TxtUbicacionArchivos.VALUE=XsUbi
		ENDIF
	ENDPROC


	PROCEDURE cmdrecursos1.When
		IF UPPER(goentorno.user.groupname)='MASTER'
			RETURN .T.
		ELSE
			MESSAGEBOX('No tiene acceso a modificar ubicacion de archivos',64,'¡Atencion / Warning !')
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE opglibrosprocesar2.Option1.Click
		thisform.PeriodoLibro('050100' )
	ENDPROC


	PROCEDURE opglibrosprocesar2.Option2.Click
		thisform.PeriodoLibro('080100' )
	ENDPROC


	PROCEDURE opglibrosprocesar2.Option3.Click
		thisform.PeriodoLibro('140100' )
	ENDPROC


	PROCEDURE opglibrosprocesar2.Option4.Click
		thisform.PeriodoLibro('060100' )
	ENDPROC


	PROCEDURE chkvalidarinfo.InteractiveChange
		IF this.Value = .T.
			this.ForeColor = RGB(0,64,0)
			this.Caption = 'SI validar información'
			this.ToolTipText = 'Realiza validacion de datos: Ventas resumen (excesos),Neteo de canjes, verificar duplicados,errores de correlativos, borrar registros invalidos sin numero documento y ventas online'
			this.Parent.LblTipoOriDat.Visible = .T.
		*!*		this.Parent.lblRutaOriDat.Visible = .T.
			This.parent.CboTpoOriDat.Visible = .T. 
		*!*		This.Parent.TxtRutaOrigenDatos.Visible= .T.
		*!*		This.Parent.CmdOrigenDat.Visible= .T.
			Thisform.Cmdprocesar1.ToolTipText  = [ Procesar carga de datos y generar libros electrónicos]
		ELSE
			this.ForeColor = RGB(255,0,0)
			this.Caption = 'NO validar información'
			this.ToolTipText = 'Solo genera el archivo de texto en base a registro de ventas grabado en ultimo proceso, no realiza ninguna validacion de datos.'
			this.Parent.LblTipoOriDat.Visible = .F.
			this.Parent.lblRutaOriDat.Visible = .F.
			This.parent.CboTpoOriDat.Visible = .F. 
			This.Parent.TxtRutaOrigenDatos.Visible= .F.
			This.Parent.CmdOrigenDat.Visible= .F.
			Thisform.Cmdprocesar1.ToolTipText  = [ Generar libros electrónicos]
		ENDIF
	ENDPROC


	PROCEDURE cmdprocccosto.Click
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 
		LsRutaDev=SYS(5)+'\aplvfp\bsinfo\progs'
		DO poner_ccosto_ple_exactus WITH TRIM(this.Parent.TxtArchivoXLS_PLE_CCosto.Value  )
		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE cmdprocesar2.Click
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 

		thisform.Reproceso_txt_ple(this.Parent.TxtArchivoTXTPLE_r.Value,'')  

		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE opgreproccosto.Valid
		IF this.Value = 2
			this.Parent.CmdprocCCOsto.Visible = .T. 
			this.Parent.TxtArchivoXLS_PLE_CCosto.Visible = .T. 
			this.parent.CmdDirReproCCosto.Visible= .T.
		ELSE
			this.Parent.CmdprocCCOsto.Visible = .F. 
			this.Parent.TxtArchivoXLS_PLE_CCosto.Visible = .F. 
			this.parent.CmdDirReproCCosto.Visible= .F.
		ENDIF
	ENDPROC


	PROCEDURE cmddirreproccosto.Click
		*!*	CD(thisform.cDirInterface)
		THISFORM.TxtArchivoXLS_PLE_CCosto.VALUE=TRIM(GETFILE())
	ENDPROC


	PROCEDURE opgreproceso.Valid
		IF this.Value = 2
			this.Parent.cmdprocesar2.Visible = .T. 
			this.Parent.txtArchivoTXTPLE_r.Visible = .T. 
			this.parent.CmdRutaTxtPle_R.Visible= .T.
			this.Parent.chkRegenera_I_RV.Visible=.T.

			this.Parent.cmdprocesar3.Visible = .T. 
			this.Parent.cmdprocesar4.Visible = .T. 


		ELSE
			this.Parent.cmdprocesar2.Visible = .F. 
			this.Parent.txtArchivoTXTPLE_r.Visible = .F. 
			this.parent.CmdRutaTxtPle_R.Visible= .F.
			this.Parent.chkRegenera_I_RV.Visible=.F. 
			this.Parent.chkRegenera_I_RV.Value =.F.

			this.Parent.cmdprocesar3.Visible = .F. 
			this.Parent.cmdprocesar4.Visible = .F. 
		ENDIF
	ENDPROC


	PROCEDURE cmdrutatxtple_r.Click
		*!*	CD(thisform.cDirInterface)
		THISFORM.TxtArchivoTXTPLE_r.VALUE=TRIM(GETfile())
	ENDPROC


	PROCEDURE cmdprocesar3.Click
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 

		Thisform.Reproceso_txt_ple_2(this.Parent.TxtArchivoTXTPLE_r.Value,'')  

		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE cmdorigendat.Click
		*!*	CD(thisform.cDirInterface)
		*XsOri=GETDIR(thisform.cDirInterface,'Seleccione directorio','Origen de datos')
		LsTOD=This.Parent.CboTpoOriDat.Value  
		DO CASE
			CASE LsTOD='Access'
				LsCaption= 'Ubicar base de datos MS Access'
				LsText	= 'Origen:'
				LsExt='accdb'
			CASE LsTOD='DBF'
				LsCaption= 'Ubicar archivo dbase .DBF'
				LsText	= 'Origen:'
				LsExt='dbf'
			CASE LsTOD='Excel'
				LsCaption= 'Ubicar archivo MS Excel'
				LsText	= 'Origen:'
				LsExt='XLS*'
			CASE LsTOD='Texto'
				LsCaption=  'Ubicar archivo de texto'
				LsText	= 'Origen:'
				LsExt='txt'
			OTHERWISE 
				LsCaption=  'Ubicar archivo de configuración .INI'
				LsText	= 'Origen:'
				LsExt='ini'
		ENDCASE

		XsOri = TRIM(GETfile(LsExt,'Origen:','',0,LsText))
		IF !EMPTY(XsOri)
			THISFORM.TxtRutaOrigenDatos.VALUE=XsOri
		ENDIF
	ENDPROC


	PROCEDURE chkregenera_i_rv.InteractiveChange
		IF this.Value = .T.
			this.ForeColor = RGB(0,64,0)
			this.Caption = 'SI regenerar datos txt '
			this.ToolTipText = 'Regenera todos los datos provenientes del archivo de texto '
		ELSE
			this.ForeColor = RGB(255,0,0)
			this.Caption = 'NO regenerar datos txt'
			this.ToolTipText = 'No regenera los datos provenientes del archivo de texto solo lee del proceso anterior. '
		ENDIF
	ENDPROC


	PROCEDURE cbotpooridat.InteractiveChange
		This.ProgrammaticChange  
	ENDPROC


	PROCEDURE cbotpooridat.ProgrammaticChange
		IF This.Value = '(LOCAL)'
			this.parent.LblRutaOriDat.Visible = .F.
			This.Parent.TxtRutaOrigenDatos.Visible = .F. 
			This.Parent.CmdOrigenDat.Visible = .F.
			   
		ELSE
			this.parent.LblRutaOriDat.Visible = .T.
			This.Parent.TxtRutaOrigenDatos.Visible = .T. 
			This.Parent.CmdOrigenDat.Visible = .T.
		ENDIF
	ENDPROC


	PROCEDURE cbotpooridat.Valid
		*!*	IF THIS.VaLUE = [01]
		*!*		thisform.PgfCtaAux.page2.cboCndPgo.cvaloresfiltro = [FP]
		*!*		thisform.PgfCtaAux.page2.cboCndPgo.generarcursor() 
		*!*	ELSE
		*!*		thisform.PgfCtaAux.page2.cboCndPgo.cvaloresfiltro = [FI]
		*!*		thisform.PgfCtaAux.page2.cboCndPgo.generarcursor() 
		*!*	ENDIF 
	ENDPROC


	PROCEDURE cmdprocesar4.Click
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 


		Thisform.reproceso_excesos

		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE cmdtestcargo.Click
		thisform.Query_cargo 

		IF .F.
		thisform.tools.closetable('TMOD')
		IF !USED('TMOD')
			SELECT 0
			USE ADDBS(goentorno.tspathadm)+'tablasmodulo' ORDER PK1 ALIAS TMOD
		ENDIF
		=SEEK('OLT02','TMOD')
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LsAliasPre = 'P_RV'
		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)

			thisForm.TxtEstadoProceso2.Caption	=  'Probando acceso a Notas de Credito de BD de CARGO...' 
		*!*				LsStringCARGO= [DRIVER={EnterpriseDB 8.3R2};DATABASE=SGCO;SERVER=192.168.1.6;PORT=5444;UID=enterprisedb;PWD=admin;]
					LsStringCARGO=Thisform.Ocnx_Odbc.cStringCnx3 
					CnCARGO= SQLSTRINGCONNECT(LsStringCARGO)
					LnClient_encod=SQLEXEC(CnCARGO,[set client_encoding to 'UTF8'])
					LsQryCARGO = ''
		*!*	*!*				LsQryCARGO= [Select FA.co_tipoDocumento,FA.nu_seriedocumento, FA.nu_documento, FA.fe_documento,  ] 
		*!*	*!*				LsQryCARGO  =  LsQryCARGO  + [NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [from "CAR_FACTURA_CA" FA  ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [INNER JOIN "CAR_NOTACREDITO_MA" NC  ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [ ON FA.co_tipoDocumento=NC.co_TipoDocumento AND ] 
		*!*	*!*				 LsQryCARGO =  LsQryCARGO  + [ FA.nu_seriedocumento = NC.nu_seriedocumento AND FA.nu_documento = NC.nu_documento ] 
		*!*	*!*			 	 LsQryCARGO =  LsQryCARGO  + [ where to_char(fe_notacredito,'YYYYMM')=']+lperiod+[']
					LsQryCARGO=	[Select co_tipoDocumento,nu_seriedocumento, nu_documento, fe_documento,]  +; 
					            [ NC.Nu_Serie,NC.Nu_NotaCredito, nc.fe_notacredito,nC.nu_ruccliente, nc.de_nombrecliente,nc.im_total ,nc.ST_notacredito  ] +;
					  			[FROM  "CAR_NOTACREDITO_MA" Nc, ] + ;
			       				[ "GEN_TERMINALES_MA" Ofi ] + ;
			     				[ , "GEN_PREFIJO_MA" Serie ] + ;
			    				[where to_char(fe_notacredito,'YYYYMM')='] +lperiod+['] + ;
			     				[ and     NC.co_oficina = Ofi.co_terminal ] + ;
			     				[ and    ( NC.co_OFICINA   = Serie.co_terminal ] + ;
				   				[ and      NC.co_estacion  = Serie.co_estacion ] + ;
				   				[ and      '07'            = Serie.co_tipodoc ] + ;
				   				[ and      NC.nu_serie     = Serie.co_prefijo ) ]  

					LsCadenaSql2=STRTRAN(TMOD.cadenasql2,'?lperiod',"'"+lperiod+"'")
				 	LsQryNew	= IIF(!EMPTY(LsCadenaSql2),LsCadenaSql2,LsQryCARGO) 
		*!*				 LsQryCARGO =  LsQryCARGO  + [ where nc.Nu_Serie=']+LsSerie+[' AND NC.Nu_Notacredito=']+LsNumero+[' ]
					LnControlCargo  = SQLEXEC(CnCARGO,LsQryNew,'NCredito')
					=SQLDISCONNECT(CnCARGO)
					IF LnControlCargo<0
						MESSAGEBOX('Error de conexion con base de datos CARGO '+SUBSTR(LsStringCARGO,1,LEN(LsStringCARGO)-27),16,'ATENCION')
						RETURN LnControlCargo
					ENDIF
					IF Thisform.Tag = 'Cursor'
						RETURN LnControlCargo
					ELSE
						SELECT NCredito
		*!*					INDEX on Nu_Serie+Nu_NotaCredito TAG Numero
						** VETT  18/03/2013 06:16 PM : Para encontrarlos sin importar los ceros que tengan a la izquierda del campo numero 
						INDEX on Nu_Serie+LTRIM(STR(VAL(Nu_NotaCredito))) TAG Numero
						SET ORDER TO Numero
						LOCATE
						BROW
					ENDIF
		ENDIF
	ENDPROC


	PROCEDURE cmdtestcnx_fics.Click

		thisform.Query_pasajes 

		IF .F.
		lcodcia = IIF(GsSigCia='OLTURSA',RIGHT(GsCodCia,2),GsCodCia)  
		lcodsuc = IIF(GsSigCia='OLTURSA',RIGHT(GsCodSed,2),GsCodSed)
		lperiod = GoEntorno.GsPeriodo
		lperpco = GoEntorno.GsPeriodo + '00'
		lruccia = GsRucCia
		lruta   = "LIBROS_ELECTRONICOS\CIA_" + lcodcia+'\'
		llibro  = '140100' 
		LsAliasLib = 'RV'
		LsAliasPre = 'P_RV'
		thisform.tools.closetable('TMOD')
		IF !USED('TMOD')
			SELECT 0
			USE ADDBS(goentorno.tspathadm)+'tablasmodulo' ORDER PK1 ALIAS TMOD
		ENDIF
		=SEEK('OLT01','TMOD')
		**
		LnMes=VAL(thisform.CboMes.Value )
		thisform.PeriodoLibro(llibro)

		LsAno = SUBSTR(lperiod,1,4)
		LsMes = SUBSTR(lperiod,5,2)

		Ls_Fecha_1='01/'+LsMes+'/'+LsAno
		Ls_fecha_2=DTOC(GdFecha)

		*** Actualizamos fecha referencia de N/Creditos buscando en sistemas de Cargo y FICS
					thisFORM.TxtEstadoProceso2.Caption	=  'Probando acceso a Notas de Credito en BD de FICS...' 
					 
		*!*				LsStringFICS = "driver={SQL Server};server=192.168.1.5;Database=WF_OLTR;uid=sa;pwd=oltursasa;"
					LsStringFICS	= Thisform.Ocnx_Odbc.cStringCnx2 
					CnFICS= SQLSTRINGCONNECT(LsStringFICS)
					LsQryFICS = "SELECT ComprobanteNumero AS NumeroNC,FechaEmision AS FechaNC, " 
					LsQryFICS = LsQryFICS +  "T1.FechaOperacion AS Fch_Boleto,T2.Numero AS Boleto  From Pasajes_Comprobantes " 
					LsQryFICS = LsQryFICS +  "inner join PasajesOperaciones T1 ON PasajeID = T1.Pasaje inner join Pasajes T2 ON T2.Id = T1.Pasaje "
					LsQryFICS = LsQryFICS +  "WHERE T1.Operacion in ( 0,13 ) AND year(FechaEmision)=?_Ano and month(FechaEmision)=?LnMes order by FechaNC "

					LsQryNew	= IIF(!EMPTY(TMOD.CadenaSql2),TMOD.CadenaSql2,LsQryFICS)

			*!*					LsQryFICS = LsQryFICS +  "WHERE  ComprobanteNumero = '"+LsNumeroNC +"'"
					LnControlFics  = SQLEXEC(CnFICS,LsQryNew,'NCPasajes')
					=SQLDISCONNECT(CnFICS)
					IF LnControlFics<0
						MESSAGEBOX('Error de conexion con base de datos FICS '+SUBSTR(LsStringFICS,1,LEN(LsStringFICS)-21),16,'ATENCION')
						RETURN LnControlFics
					ENDIF
					IF Thisform.Tag = 'Cursor'
						RETURN LnControlFics
					ELSE
						SELECT NCPasajes
						INDEX on PADR(Serie,4)+PADR(LTRIM(STR(documento)),10) TAG Numero
						SET ORDER TO Numero
						LOCATE
						BROW
					ENDIF
		ENDIF
	ENDPROC


	PROCEDURE cmdconfigcctoct.Click
		DO FORM cbd_ple_cfg_zon_loc_ccto_cta.scx
	ENDPROC


	PROCEDURE cmdcargador.Click
		IF  !MESSAGEBOX("Seguro de ejecutar proceso de generación de cargadores contables del periodo: "+STUFF(THISFORM.PLEPeriod,5,0,'-')+" ?",4+32,'ATENCION !')=6
			RETURN 
		ENDIF
		Thisform.LlRegError1 = .F.
		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 
		*!*	IF .f.
			Thisform.GeneraCargadorRV
		*!*	ENDIF
		*!*	SET STEP ON
		*** REVISAR LOG DE ERRORES *** 
		***----------------------------------------------***
		LnItemLog=0
		WITH THISFORM
			LsRutaTxtErrCCo	=ADDBS(ADDBS(TRIM(.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrCTOCTA.txt'
			IF FILE(LsRutaTxtErrCCo)
				LnItemLog = LnItemLog + 1
			*!*		MODIFY COMMAND LsRutaTxtErrCCo NOEDIT 
				.LstLogError.AddListItem('CENTRO(S) DE COSTO NO ENCONTRADO(S)',LnItemLog,1)  
				.LstLogError.AddListItem(LsRutaTxtErrCCo,LnItemLog,2)  
			ENDIF
			LsRutaTxtErr1	=ADDBS(ADDBS(TRIM(.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorRAGEN.txt'
			IF FILE(LsRutaTxtErr1)
			*!*		MODIFY COMMAND LsRutaTxtErr1 NOEDIT 
				LnItemLog = LnItemLog + 1
				.LstLogError.AddListItem('RUC DE AGENCIA(S) NO IDENTIFICADO(S)',LnItemLog,1)  
				.LstLogError.AddListItem(LsRutaTxtErr1,LnItemLog,2)  
			ENDIF
			LsRutaTxtErr2	=ADDBS(ADDBS(TRIM(.TxtUbicacionArchivos.Value))+'CARGADORES')+'ErrorVCORP.txt'
			IF FILE(LsRutaTxtErr2)
			*!*		MODIFY COMMAND LsRutaTxtErr2 NOEDIT 
				LnItemLog = LnItemLog + 1
				.LstLogError.AddListItem('CARGADOR 12:VENTAS CORPORATIVA NO REGISTRADO',LnItemLog,1)  
				.LstLogError.AddListItem(LsRutaTxtErr2,LnItemLog,2)  
			ENDIF
			IF FILE(thisform.FileLogError4)
				LnItemLog = LnItemLog + 1
				.LstLogError.AddListItem('ERROR DE ACCESO A DOCUMENTOS PASAJES / CARGO ',LnItemLog,1)  
				.LstLogError.AddListItem(thisform.FileLogError4,LnItemLog,2)  
			ENDIF

		ENDWITH
		 
		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE opgcargadores.Valid
		IF this.Value = 2
			this.Parent.CmdCargador.Visible = .T. 
		*!*		this.Parent.txtArchivoTXTPLE_r.Visible = .T. 
		*!*		this.parent.CmdRutaTxtPle_R.Visible= .T.
		*!*		this.Parent.chkRegenera_I_RV.Visible=.T.
		*!*		this.Parent.cmdprocesar4.Visible = .T. 
			this.Parent.ChkPasajes.Visible	= .T.
			this.Parent.ChkCargo.Visible		= .T.
			this.Parent.ChkCancelacion1.Visible	=	.T.
			this.Parent.TxtFchDocD.Visible 	= .T.
			this.Parent.TxtFchDocH.Visible 	= .T.
			This.Parent.LblFechaD.Visible 	= .T.
			This.Parent.LblFechaH.Visible 	= .T.
			this.Parent.LblBorraLogErrores.Visible	= .T.
			This.Parent.OptBorraLogErrores.Visible 	= .T. 
			this.Parent.LstLogError.Visible	= .T. 
		ELSE
			this.Parent.CmdCargador.Visible	= .F. 
			this.Parent.ChkPasajes.Visible	= .F.
			this.Parent.ChkCargo.Visible		= .F.
			this.Parent.ChkCancelacion1.Visible	=	.F.
			this.Parent.TxtFchDocD.Visible 	= .F.
			this.Parent.TxtFchDocH.Visible 	= .F.
			This.Parent.LblFechaD.Visible 	= .F.
			This.Parent.LblFechaH.Visible 	= .F.
			this.Parent.LblBorraLogErrores.Visible	= .F.
			This.Parent.OptBorraLogErrores.Visible 	= .F. 
			this.Parent.LstLogError.Visible	= .F.

			this.Parent.LblUbiCargadores.Visible = .F.  
			this.Parent.TxtUbicacionCargadores.Visible = .F.  
		*!*		this.Parent.txtArchivoTXTPLE_r.Visible = .F. 
		*!*		this.parent.CmdRutaTxtPle_R.Visible= .F.
		*!*		this.Parent.chkRegenera_I_RV.Visible=.F. 
		*!*		this.Parent.cmdprocesar4.Visible = .F. 
		ENDIF
	ENDPROC


	PROCEDURE cmdrrutacargador.When
		IF UPPER(goentorno.user.groupname)='MASTER'
			RETURN .T.
		ELSE
			MESSAGEBOX('No tiene acceso a modificar ubicacion de archivos',64,'¡Atencion / Warning !')
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE cmdrrutacargador.Click
		*!*	CD(thisform.cDirInterface)

		XsUbi=GETDIR(thisform.cDirInterface)
		IF !EMPTY(XsUbi)
			THISFORM.TxtUbicacionArchivos.VALUE=XsUbi
		ENDIF
	ENDPROC


	PROCEDURE cmdrrutacargador.Valid
		*!*	SELECT 0
		*!*	USE ADDBS(this.Parent.TxtRutaOrig.Value) + 'ADMMCIAS' ALIAS cias_origen
		*!*	this.Parent.cboCiaOrigen.rowsourcetype=6
		*!*	this.Parent.cboCiaOrigen.RowSource='cias_origen.NomCia'
	ENDPROC


	PROCEDURE cmdrepro_ple_rv2013.Click
		thisform.Tools.Closetable('RegVen')
		thisform.Tools.Closetable('RegVen2')

		thisform.TXtEstadoProceso1.Visible = .T. 
		thisform.TXtEstadoProceso2.Visible = .T. 

		IF Thisform.ChkRegenera_I_RV.Value 
		 	LcRutaTxtPle=this.Parent.TxtArchivoTXTPLE_r.Value
		 
		 	IF VARTYPE(LcRutaFileVMOV)<>'C' OR EMPTY(LcRutaFileVMOV)
				LcRutaFileVMOV = ADDBS(Goentorno.LocPath) + 'I_RV'+thisform.PLEPeriod  && STR(_ANO,4,0)+TRANSFORM(_MES,'@L 99')
			ENDIF
			IF !FILE(LcRutaFileVMOV)
				** VETT  08/06/2015 08:23 PM : ATENCION : ESTE FORMATO TXT DEL PLE NO TENIA EL CAMPO NROITM Y VALOR FOB 
				SELECT 0
				CREATE TABLE  (LcRutaFileVMOV)  FREE ( ;
							      PERIODO C(8), ;
							      ASIENTO  C(15), ;
							      CTE_FECEMI    D, ;
							      CTE_FECVEN   D, ;
							      T10_CODT10 C(2),  ;
							      SERIE	 C(15), ;
							      NUMERO C(10), ;
							      ULT_NUMERO C(10), ;
							      T02_CODT02 C(1), ;
							      RUC C(11), ;
							      NOMBRE C(30), ;
							      VAL_EXPORT N(15,2), ;
							      VAL_AFECTO N(15,2), ;
							      VAL_EXONER N(15,2), ;
							      VAL_INAFEC   N(15,2) , ;
							      IMP_ISC N(15,2),  ;
							      IMP_IGV N(15,2) ,  ;
							      BASIMP_IVA N(15,2), ;
							      IMP_IVAP N(15,2) , ;
							      OTROS_TRIB N(15,2), ;
							      IMP_TOTAL N(15,2), ;
							      CTE_TIPCAM	 N(7,3) ,;
							      FECEMI_REF D,;
							      T10_CODREF C(4), ;
							      SERIE_REF C(4),;
							      NUMERO_REF C(10),;
							      ESTADO_OPE C(1)  ,;
							      LOCA C(60) ,;
							      LOC2 C(60) ,;
							      DELO C(60),;
							      DETA C(20),;
							      OTRO C(20),;
							      BOLE  C(10),;
							      EMBA  N(10),;
							      CODCTA C(12),;
							      CENCOS	 C(14),;
							      CODCAR C(4),;
							      TIPO_VENTA C(10),;
							      DETA_VENTA C(15),;
							      ESTADO1 C(15) )

							      
			     USE	(LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE														      
				INDEX ON T10_CODT10+SERIE+NUMERO TAG SERIE
				INDEX ON DTOS(CTE_FECEMI) TAG FECEMI
				INDEX ON LOCA TAG LOCA								      
			ELSE
				SELECT 0
				USE (LcRutaFileVMOV)  ALIAS REGVEN EXCLUSIVE

				ZAP
			ENDIF
			APPEND FROM (LcRutaTxtPle) TYPE DELIMITED WITH CHARACTER '|'
			LOCATE
			SET ORDER TO SERIE   && T10_CODT10+SERIE+NUMERO

			IF !FILE(ADDBS(goentorno.locpath)+Thisform.PLEAliaslib  +Thisform.PLEPeriod+'.dbf')
				=MESSAGEBOX('Se debe generar el archivo con los registros validados, ejecute nuevamente con la opción de SI validar información, por lo menos una vez',48,'ATENCION ! ')
				ls_mensaje = 'No se pudo ejecutar por que no se encontro el archivo con los registros procesados del registro de ventas '+Lperiod
				RETURN 
			ELSE
				SELECT 0
				USE ADDBS(goentorno.locpath)+Thisform.PLEAliaslib  +Thisform.PLEPeriod ALIAS RegVen2
				SET ORDER TO  SERIE
			ENDIF
			** Dejamos en blanco campo Asiento y grabamos localidad  (Campo LOCA) que viene  del RV Access
			thisform.TXtEstadoProceso1.Caption	=	'FASE 1: CREDITO - BUSCANDO CUO EN REGISTRO DE VENTAS DEL EXACTUS -  PERIODO:'+Thisform.PlePeriod+'  '
			LnTotReg = RECCOUNT('REGVEN')
			LnRegAct = 0
			LsUltMsg	= 'Inicializando campo ASIENTO y cargando LOCALIDAD del RV ACCESS: '+Thisform.PlePeriod

			SELECT REGVEN
			SCAN  
				LnRegAct = LnRegAct + 1
				IF LnTotReg>0
					thisform.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
				ENDIF
				LsDocumento=T10_CODT10+SERIE+NUMERO
				REPLACE ASIENTO WITH ''
				SELECT REGVEN2
				SEEK  LsDocumento 
				IF FOUND()
					SCATTER memvar
					SELECT REGVEN
					GATHER MEMVAR FIELDS LIKE LOCA,LOC2, DELO,DETA,OTRO,BOLE,EMBA
				ELSE
					SELECT REGVEN
					REPLACE Estado1 WITH 'XX'
				ENDIF
			ENDSCAN


		ELSE

			IF !FILE(ADDBS(goentorno.locpath)+Thisform.PLEAliaslib  +Thisform.PLEPeriod+'.dbf')
				=MESSAGEBOX('Se debe generar el archivo con los registros validados, ejecute nuevamente con la opción de SI validar información, por lo menos una vez',48,'ATENCION ! ')
				ls_mensaje = 'No se pudo ejecutar por que no se encontro el archivo con los registros procesados del registro de ventas '+Lperiod
				RETURN 
			ELSE
				SELECT 0
				USE ADDBS(goentorno.locpath)+Thisform.PLEAliaslib  +Thisform.PLEPeriod ALIAS RegVen
				SET ORDER TO  SERIE
			ENDIF

		ENDIF
		IF !USED('CCOCT')
			SELECT 0
			USE CFGCCOCTA1.DBF ALIAS CCOCT AGAIN 
			SET ORDER TO ID
		ENDIF


		*!*	SET STEP ON 

		** VETT  05/06/2015 10:23 AM : Establecemos filtros segun tipo de cargador 
		** Codigo de cargador de registros del REGVEN que se encuentran resumidos en RV_Exactus
		LsListaCargadorContado=[INLIST(codcar , 'C09','C10','C11','C12','C13','C14')]

		LsFiltroC09=''
		LsFiltroC10=''
		LsFiltroC11=''
		LsFiltroC12=''
		LsFiltroC13=''
		LsFiltroC14=''
		IF messagebox('¿Desea reprocesar el numero CUO en el PLE - Reg. Ventas en base a # de asiento del RV EXACTUS? ',32+4,'ATENCION ! / WARNING !')=6
			** VETT  05/06/2015 10:24 AM : Cargamos RV Exactus
			LsFileExactusCSV= ''

			** Carga de registro de ventas proveniente del Exactus - VETT  05/06/2015 10:50 AM 
			IF EMPTY(thisform.TXtArchivo_RV_Exactus_CSV.Value ) 
				=MESSAGEBOX('Debe seleccionar el archivo en formato CSV con el Registro de Ventas Exactus del mes que se quiere reprocesar',48,'¡ ATENCION / WARNING !')
				RETURN
			ENDIF
			LsRutaRV_Exactus	=	TRIM(Thisform.TXtArchivo_RV_Exactus_CSV.Value)
			*
			Thisform.Struct_RV_Exactus('RV_EXACTUS_'+LEFT(THISFORM.PLEPeriod,4),'RV_Exactus1')
			*
			SELECT RV_Exactus1
			APPEND FROM (LsRutaRV_Exactus) TYPE DELIMITED WITH CHARACTER ','
			** Fin carga de registro de ventas del Exactus - VETT  05/06/2015 10:51 AM 


			**LnTotReg = RECCOUNT('RV_Exactus1')
			LnTotReg = 0
			SELECT RV_Exactus1
			COUNT FOR 'CREDITO'$APLICACION TO LnTotReg
			LnRegAct = 0 
			LsUltMsg	= 'Grabando CUO en PLE Registro Ventas  Periodo:'+Thisform.PlePeriod + '  '
			thisform.TXtEstadoProceso1.Caption	=	'FASE 2: CREDITO - BUSCANDO CUO EN REGISTRO DE VENTAS DEL EXACTUS -  PERIODO:'+Thisform.PlePeriod

			SELECT RV_Exactus1
			SEEK THISFORM.PLEPeriod 
			SCAN  WHILE DTOS(FECHA)=THISFORM.PLEPeriod  FOR !EMPTY(Fecha)
				LsAsiento=Asiento
				IF documento='115-546'
					SET STEP ON 
				ENDIF
				DO CASE
					CASE 'CREDITO'$APLICACION
						LnRegAct = LnRegAct + 1
						IF LnTotReg>0
							thisform.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
						ENDIF

						** Buscamos por Tipo+Serie+Numero en REGVEN
						LnLenSerie	= LEN(REGVEN.Serie)
						LnPosGuion=AT('-',Documento)
						LsTipo	=	LEFT(Tipo_Doc_Sunat,2)
						LsSerie	=	PADR('0'+SUBSTR(Documento,1,LnPosGuion-1),LnLenSerie)
						LsNDoc	=     TRIM(SUBSTR(Documento,LnPosGuion+1))
						LsDocumento= 	LsTipo+LsSerie+LsNDoc
						SELECT REGVEN
						SET ORDER TO SERIE
						SEEK LsDocumento
						IF FOUND()
							IF ASiento<>'CC'
								REPLACE Asiento WITH  LsAsiento
								REPLACE ID_Registro	WITH REGVEN.T10_CODT10+TRIM(REGVEN.SERIE)+'-'+REGVEN.NUMERO IN RV_Exactus1
							ENDIF
						ENDIF
					CASE 'CONTADO'$APLICACION


				ENDCASE
				SELECT RV_Exactus1
			ENDSCAN

			LnTotReg = RECCOUNT('RV_Exactus1')
			LnTotReg = 0
			SELECT RV_Exactus1
			COUNT FOR 'CONTADO'$APLICACION TO LnTotReg

			LnRegAct = 0
			*** CONTADO
			thisform.TXtEstadoProceso1.Caption	=	'FASE 3: CONTADO - BUSCANDO CUO EN REGISTRO DE VENTAS DEL EXACTUS -  PERIODO:'+Thisform.PlePeriod
			SELECT RV_Exactus1
			SEEK THISFORM.PLEPeriod 
			SCAN  WHILE DTOS(FECHA)=THISFORM.PLEPeriod  FOR !EMPTY(Fecha)
				LsAsiento=Asiento
			*!*		IF documento='115-546'
			*!*			SET STEP ON 
			*!*		ENDIF
				DO CASE
					CASE 'CREDITO'$APLICACION
					CASE 'CONTADO'$APLICACION
						LnRegAct = LnRegAct + 1
						IF LnTotReg>0
							thisform.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
						ENDIF
						LsCaja_Alt=TRIM(Codigo_Cliente)
						SELECT CCOCT
						SCAN  FOR Caja_Alt=LsCaja_alt
								LsLocalidad=TRIM(Localidad)
								SELECT REGVEN
								SET ORDER TO LOCA
								SEEK LsLocalidad
								SCAN  WHILE Loca=LsLocalidad
									IF Asiento<>'CC'
										REPLACE Asiento WITH LsAsiento
										REPLACE ID_Registro	WITH LsLocalidad IN RV_Exactus1
									ENDIF
								ENDSCAN
								SELECT CCOCT
						ENDSCAN

				ENDCASE
				SELECT RV_Exactus1
			ENDSCAN
		ENDIF
		** Copiando a Excel
		IF MESSAGEBOX('¿DESEA EXPORTAR EL REG_VENTAS con CUO segun RV_EXACTUS A FORMATO EXCEL?',32+4,'COPIAR A EXCEL')=6
			thisform.TXtEstadoProceso1.Caption	=	'COPIANDO REGISTROS AL EXCEL...'
			thisform.TXtEstadoProceso2.Caption	=      ''

			SELECT REGVEN
			IF RECCOUNT()>=65535
				LsExtension	=	'.xlsx'
			ELSE
				LsExtension	=	'.xls'
			ENDIF
			LsRuta	=  ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'RQ_SUNAT')
			IF !DIRECTORY(LsRuta)
					MKDIR (LsRuta)
			ENDIF

			LsFileReqExcel = ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'RQ_SUNAT') + 'REG_VENTAS'+'_'+Thisform.PlePeriod +LsExtension 
			SELECT REGVEN
			LOCATE
			IF !EOF()
				IF FILE(LsFileReqExcel)
					DELETE FILE (LsFileReqExcel)
				ENDIF
				IF RECCOUNT()>=65535
					LnRegPro=CopytoExcel(LsFileReqExcel,"",'')
					IF !LnRegPro
						=MESSAGEBOX('No se pudo generar el archivo '+ LsFileReqExcel  + ' en formato excel.' ,16,'! ATENCIÖN / WARNING !')
					ENDIF
				ELSE
					COPY TO (LsFileReqExcel) TYPE XLS
				ENDIF
			ENDIF
		ENDIF

		IF MESSAGEBOX('Desea generar archivo de texto',32 + 4,'ATENCION / WARNING !')=6
				thisform.TXtEstadoProceso1.Caption	=	'GENERERANDO ARCHIVO DE TEXTO...'
				thisform.TXtEstadoProceso2.Caption	=      ''

				wform   = "REG_VENTAS_" 
				wfile   = "REG_VENTAS" + Thisform.PLERuccia    + Thisform.PlePeriod+ '.TXT'
				*****            RUC GENERADOR - PERIODO - LIBRO  - OPERACION - OPORTUNIDAD - CON INFORMACION - MONEDA - PLE(FIJO=1)  + TXT
				*** OPORTUNIDAD = 0, SOLO APLICA PARA EL LIBRO DE INVENTARIOS Y BALANCES
				LsRuta = ADDBS(ADDBS(TRIM(Thisform.TxtUbicacionArchivos.Value))+'RQ_SUNAT') 
				wfile_xls =wform+thisform.PLEPerpco 
				wruta   = Lsruta   
				IF !DIRECTORY(wruta)
					MKDIR (wruta)
				ENDIF
				IF FILE(wruta+wfile)
					DELETE FILE (wruta+wfile)
				ENDIF

				wdriver = fcreate(wruta+wfile)

				if wdriver<0
				   =messagebox("Error en la creación de "+wruta+wfile,48,thisform.Caption)
				   RETURN .f.
				endif
				thisform.TxtEstadoProceso2.Caption	=  "Generando archivo de texto: "+wruta+wfile 
				LsUltMsg = "Generando archivo de texto: "+wruta+wfile +' '
				*** 7. Genera Archivo SUNAT

				LnAsiento = 0
				SELECT REGVEN
				SET ORDER TO
				SET FILTER TO 
				LnTotReg = 0
				COUNT FOR INLIST(Estado_OPE,'1','2','8','9') TO LnTotReg
				LnRegAct = 0
				LOCATE
				SCAN FOR INLIST(Estado_OPE,'1','2','8','9')
					LnRegAct = LnRegAct + 1
					IF LnTotReg>0
						thisform.TxtEstadoProceso2.Caption	=  LsUltMsg + TRANSFORM( LnRegAct/LnTotReg * 100, '999.99') + ' %' 
					ENDIF
					IF LEN(ALLTRIM(REGVEN.SERIE)) < 4
				       		REPLACE REGVEN.SERIE WITH RIGHT('0000' + ALLTRIM(REGVEN.SERIE),4)
				    	ENDIF
					IF LEN(ALLTRIM(REGVEN.SERIE_REF)) < 4  AND !ALLTRIM(REGVEN.SERIE_REF)=='0'
				       		REPLACE REGVEN.SERIE_REF WITH RIGHT('0000' + ALLTRIM(REGVEN.SERIE_REF),4)
				    	ENDIF
				    
		*!*			    	LnAsiento = LnAsiento + 1
		*!*			    	LnLonAst	=	7
		*!*				REPLACE RegVen.Asiento WITH RIGHT(REPLICATE('0',LnLonAst)+ALLTRIM(STR(LnAsiento)),LnLonAst)
					** Tipo Cambio **
					=SEEK(DTOS(REGVEN.cte_fecemi),'TCMB')
					IF FOUND('TCMB')
						IF TCMB.OfiCmp>0 
							replace RegVen.CTE_TIPCAM WITH TCMB.OfiCmp
						ENDIF
					ENDIF
					IF INLIST(RUC,'20100014395','20479390381','20512780114','20516762111','10078351239','20519330874','20408101701','20502811674','20100027021')
							** Estos ruc estan con roche
				*!*				SET STEP ON 
					ENDIF

					IF REGVEN.T10_CODT10=REGVEN.T10_CODREF
						replace 	REGVEN.T10_CODREF	WITH '00'
						replace  REGVEN.Serie_ref 		WITH ''
						replace  REGVEN.Numero_ref	WITH ''
					ENDIF
					IF T10_codt10='03' and t02_codt02='1' and (len(TRIM(ruc))<>8 or TRIM(ruc)=='0')
						REPLACE REGVEN.t02_codt02 WITH '0'
						IF len(TRIM(ruc))<>8
							REPLACE REGVEN.Ruc WITH '0'
						ENDIF
					ENDIF
					IF T10_codt10='03' and t02_codt02='6' and (len(TRIM(ruc))<>11 or TRIM(ruc)=='0')
						REPLACE REGVEN.t02_codt02 WITH '0'
						IF len(TRIM(ruc))<>11
							REPLACE REGVEN.Ruc WITH '0'
						ENDIF
					ENDIF

					IF T10_codt10='12' and t02_codt02='6' and  len(TRIM(ruc))<>11 
						REPLACE REGVEN.t02_codt02 WITH '0'
						REPLACE REGVEN.Ruc WITH '0'
					ENDIF
					IF T10_codt10='12' and t02_codt02='1' and  len(TRIM(ruc))<>8 
						REPLACE REGVEN.t02_codt02 WITH '0'
						REPLACE REGVEN.Ruc WITH '0'
					ENDIF
					IF T10_codt10='16' and t02_codt02='6' and  len(TRIM(ruc))<>11 
						REPLACE REGVEN.t02_codt02 WITH '0'
						REPLACE REGVEN.Ruc WITH '0'
					ENDIF
					IF T10_codt10='16' and t02_codt02='1' and  len(TRIM(ruc))<>8 
						REPLACE REGVEN.t02_codt02 WITH '0'
						REPLACE REGVEN.Ruc WITH '0'
					ENDIF


					LsFecha = IIF(ISNULL(REGVEN.cte_fecven),NVL(REGVEN.cte_fecven, ' '),IIF(EMPTY(REGVEN.cte_fecven),DTOC(REGVEN.Cte_FecEmi),DTOC(REGVEN.cte_fecven) ))
					DO CASE
						CASE  INLIST(T10_CodT10,'00')
							LsSerie='-'
						CASE  INLIST(T10_CodT10,'01','03','04','07','08')
							LsSerie =RIGHT(REPLICATE('0',4)+ALLTRIM(REGVEN.Serie),4)
						OTHERWISE
							LsSerie =RIGHT(REPLICATE('0',20)+ALLTRIM(REGVEN.Serie),20)
					ENDCASE
					LsSerieRef=IIF(empty(serie_ref) or TRIM(serie_ref)=='0' or VAL(serie_ref)=0,'',ALLTRIM(REGVEN.SERIE_REF))
					LsSerieRef=RIGHT(REPLICATE('0',4)+LsSerieRef,4)
					IF !INLIST(T10_CodT10,'07','08','87','88','97','98')
						LsSerieRef = '-'
					ENDIF

					LsRUC = REGVEN.Ruc
					IF t02_codt02='4'

						LsRUC=RIGHT(REPLICATE('0',12)+ALLTRIM(LsRuc),12)
					ENDIF

					wcad = ALLTRIM(REGVEN.periodo)				+"|"
								** CUO Codigo unico de operación e.g. Operacion contable, libro contable, sub-diario , paquete
					DO CASE
						CASE UPPER(GsSigcia) = 'OLTURSA'
							wcad = wcad + ALLTRIM(ASIENTO)	+"|"
		*!*						wcad = wcad + 'M'+'I'+ALLTRIM(REGVEN.asiento)		+"|"
						OTHERWISE 
							wcad = wcad + ALLTRIM(ASIENTO)	+"|"
		*!*						wcad = wcad + 'M'+ALLTRIM(REGVEN.NROITM)		+"|"
					ENDCASE 

					wcad = wcad + DTOC(REGVEN.cte_fecemi)		+"|"
					wcad = wcad + LsFecha							+"|"
					wcad = wcad + RIGHT('0'+ALLTRIM(REGVEN.T10_CODT10),2)	+"|"
					wcad = wcad + ALLTRIM(LsSerie)			+"|"
					wcad = wcad + ALLTRIM(REGVEN.NUMERO)		+"|"
					wcad = wcad + ALLTRIM(REGVEN.ULT_NUMERO)	+"|"
					wcad = wcad + ALLTRIM(REGVEN.T02_CODT02)	+"|"
					wcad = wcad + ALLTRIM(LsRUC)			+"|"
					wcad = wcad + ALLTRIM(REGVEN.NOMBRE)		+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXPORT,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.VAL_AFECTO,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.VAL_EXONER,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.VAL_INAFEC,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.IMP_ISC,15,2))		+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IGV,15,2))		+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.BASIMP_IVA,15,2)) +"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.IMP_IVAP,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.OTROS_TRIB,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.IMP_TOTAL,15,2))	+"|"
					wcad = wcad + ALLTRIM(STR(REGVEN.CTE_TIPCAM,7,3))	+"|"
					wcad = wcad + IIF(YEAR(REGVEN.FECEMI_REF)=1900,'01/01/0001',DTOC(REGVEN.FECEMI_REF)) +"|"
					wcad = wcad + RIGHT('00'+ALLTRIM(REGVEN.T10_CODREF),2)	+"|"
					wcad = wcad + LsSerieRef		+"|"
					wcad = wcad + IIF(empty(numero_ref) or TRIM(numero_ref)='0','-',ALLTRIM(REGVEN.NUMERO_REF))	+"|"
					wcad = wcad + ALLTRIM(NVL(REGVEN.ESTADO_OPE,'1')) + "|"
					wcad = wcad + ALLTRIM(ASIENTO) + "|"
					wcad = wcad + SPACE(1)+"|"
					wcad = wcad + ALLTRIM(ASIENTO) + "|"
					** Campo libre utilizacion , si esta en blanco , no concaternar nada 


				    =fput(wdriver,wcad)    
				    SELECT REGVEN   
				ENDSCAN
				=fclose(wdriver)


		ENDIF
		thisform.TxtEstadoProceso1.Caption	=  'PROCESO TERMINADO' 
		thisform.TxtEstadoProceso2.Caption	=  '' 
		=MESSAGEBOX("PROCESO TERMINADO.",64,'ATENCION')
		thisform.TXtEstadoProceso1.Visible = .F. 
		thisform.TXtEstadoProceso2.Visible = .F. 
	ENDPROC


	PROCEDURE cmdruta_rv_exactus_csv.Click
		*!*	CD(thisform.cDirInterface)
		THISFORM.TxtArchivo_RV_Exactus_CSV.VALUE=TRIM(GETfile())
	ENDPROC


	PROCEDURE opgrepro_ple_rv_2013.Valid
		IF this.Value = 2
			this.Parent.CmdRepro_Ple_RV2013.Visible = .T. 
			this.Parent.TxtArchivo_RV_Exactus_CSV.Visible = .T. 
			this.parent.CmdRuta_RV_Exactus_CSV.Visible= .T.
		ELSE
			this.Parent.CmdRepro_Ple_RV2013.Visible = .F. 
			this.Parent.TxtArchivo_RV_Exactus_CSV.Visible = .F. 
			this.parent.CmdRuta_RV_Exactus_CSV.Visible= .F.
		ENDIF
	ENDPROC


	PROCEDURE optborralogerrores.Valid
		IF this.Value = 1
			this.option1.ForeColor =	RGB(255,0,0)
			this.option2.ForeColor =	RGB(255,0,0)
		ELSE
			this.option1.ForeColor =	RGB(0,128,0)
			this.option2.ForeColor =	RGB(0,128,0)
		ENDIF
	ENDPROC


	PROCEDURE lstlogerror.DblClick
		MODIFY FILE this.list(this.ListItemId,2 ) NOEDIT NOWAIT 
	ENDPROC


	PROCEDURE opglibrosprocesar.Option1.Click
		thisform.PeriodoLibro('050100' )
	ENDPROC


	PROCEDURE opglibrosprocesar.Option2.Click
		thisform.PeriodoLibro('060100' )
	ENDPROC


	PROCEDURE opglibrosprocesar.Option3.Click
		thisform.PeriodoLibro('080100' )
	ENDPROC


	PROCEDURE opglibrosprocesar.Option4.Click
		thisform.PeriodoLibro('140100' )
	ENDPROC


ENDDEFINE
*
*-- EndDefine: interfase_sunat
**************************************************
