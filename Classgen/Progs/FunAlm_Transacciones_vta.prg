**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\formtrans.vcx
**************************************************


**************************************************
*-- Class:        funalm_transacciones_vta (k:\aplvfp\classgen\vcxs\formtrans.vcx)
*-- ParentClass:  base_form (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    form
*-- Time Stamp:   11/02/07 01:55:13 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS funalm_transacciones_vta AS base_form


	Height = 530
	Width = 758
	DoCreate = .T.
	Caption = "Guia de remisión"
	WindowState = 0
	que_transaccion = "[ALMACEN]
	*-- Usar  cuando se pasa ptovta como parametro
	lptovta = .F.
	nombreobjref = "GoCfgAlm"
	nomobjcnt_ref = "Cntdoc_ref1"
	c_validitem = "c_codmat"
	Name = "GuiaRemision"
	Tools.Top = 360
	Tools.Left = 63
	Tools.Height = 24
	Tools.Width = 24
	Tools.Name = "Tools"

	*-- Cuando se pasa como parametro el tipo de movimiento
	ltipmov = .F.

	*-- Cuando se pasa como parametro el codigo de movimiento
	lcodmov = .F.

	*-- Cuando se pasa como parametro el almacen
	lsubalm = .F.

	*-- Filtro para codigos de movimiento segun tporf1
	lfiltro_mov = .F.


	ADD OBJECT cmdiniciar AS cmdnuevo WITH ;
		Top = 288, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		Picture = "..\..\grafgen\iconos\cancelar.bmp", ;
		DisabledPicture = "..\..\grafgen\iconos\cancelar_disable.bmp", ;
		Caption = "\<Cancelar", ;
		Style = 0, ;
		TabIndex = 13, ;
		ToolTipText = "Cancelar el actual ingreso y/o modificación de datos", ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 1, ;
		codigoboton = ("00001371"), ;
		Name = "cmdIniciar"


	ADD OBJECT pgfdetalle AS base_pageframe WITH ;
		ErasePage = .T., ;
		PageCount = 4, ;
		Top = 42, ;
		Left = 3, ;
		Width = 705, ;
		Height = 490, ;
		Tabs = .F., ;
		TabIndex = 18, ;
		ZOrderSet = 2, ;
		Name = "PgfDetalle", ;
		Page1.Caption = "Datos principales", ;
		Page1.BackColor = RGB(225,225,225), ;
		Page1.Name = "Page1", ;
		Page2.Caption = "Detalle de items", ;
		Page2.Name = "Page2", ;
		Page3.Caption = "Mantenimiento Detalle", ;
		Page3.Name = "Page3", ;
		Page4.Caption = "Datos adicionales", ;
		Page4.Name = "Page4"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.shpcliente AS base_shape WITH ;
		Top = 37, ;
		Left = 329, ;
		Height = 130, ;
		Width = 370, ;
		ZOrderSet = 0, ;
		Name = "ShpCliente"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.shptransportista AS base_shape WITH ;
		Top = 60, ;
		Left = 4, ;
		Height = 101, ;
		Width = 324, ;
		ZOrderSet = 1, ;
		Name = "ShpTransportista"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbomotivo AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "1 Venta, 2 Compra, 3 Transformacion, 4 Consignacion, 5 Devolución, 6 Trasl. entre establec. de una misma empresa, 7 Trasl. Por emisor itinerante de comprob. de pago, 8 Otros, 9 Exportación", ;
		Value = 1, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 590, ;
		TabIndex = 9, ;
		Top = 3, ;
		Visible = .F., ;
		Width = 96, ;
		ZOrderSet = 2, ;
		Name = "CboMotivo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblnrodoc AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Nº Doc. ", ;
		Left = 10, ;
		Top = 27, ;
		Visible = .F., ;
		TabIndex = 16, ;
		ZOrderSet = 3, ;
		Name = "LblNroDoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblfchvto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fch. Vto.", ;
		Left = 582, ;
		Top = 138, ;
		Visible = .F., ;
		TabIndex = 22, ;
		ZOrderSet = 4, ;
		Name = "LblFchVto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblfchdoc AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha", ;
		Left = 189, ;
		Top = 6, ;
		Visible = .F., ;
		TabIndex = 23, ;
		ZOrderSet = 5, ;
		Name = "LblFchDoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdadicionar1 AS cmdnuevo WITH ;
		Top = 419, ;
		Left = 8, ;
		Height = 35, ;
		Enabled = .F., ;
		TabIndex = 11, ;
		Visible = .F., ;
		PicturePosition = 7, ;
		ZOrderSet = 6, ;
		codigoboton = ("00001809"), ;
		Name = "cmdAdicionar1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdmodificar1 AS cmdmodificar WITH ;
		Top = 419, ;
		Left = 56, ;
		Height = 35, ;
		Enabled = .F., ;
		TabIndex = 12, ;
		Visible = .F., ;
		PicturePosition = 7, ;
		ZOrderSet = 7, ;
		codigoboton = ("00001810"), ;
		Name = "Cmdmodificar1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdeliminar1 AS cmdeliminar WITH ;
		Top = 419, ;
		Left = 104, ;
		Height = 35, ;
		Enabled = .F., ;
		TabIndex = 13, ;
		Visible = .F., ;
		PicturePosition = 7, ;
		ZOrderSet = 8, ;
		codigoboton = ("00001812"), ;
		Name = "Cmdeliminar1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtcndpgo AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 295, ;
		MaxLength = 10, ;
		TabIndex = 28, ;
		Top = 460, ;
		Visible = .F., ;
		Width = 13, ;
		ZOrderSet = 9, ;
		Name = "TxtCndPgo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbltpocmb AS base_label WITH ;
		FontSize = 8, ;
		Caption = "T/C.", ;
		Left = 304, ;
		Top = 6, ;
		Visible = .F., ;
		TabIndex = 53, ;
		ZOrderSet = 10, ;
		Name = "LblTpoCmb"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtfchvto AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 629, ;
		TabIndex = 26, ;
		Top = 136, ;
		Visible = .F., ;
		Width = 65, ;
		ZOrderSet = 11, ;
		Name = "TxtFchVto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txttpocmb AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "99.9999", ;
		Left = 332, ;
		TabIndex = 3, ;
		Top = 4, ;
		Width = 52, ;
		ZOrderSet = 12, ;
		Name = "TxtTpoCmb"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtfchdoc AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 225, ;
		TabIndex = 2, ;
		Top = 4, ;
		Visible = .F., ;
		Width = 65, ;
		ZOrderSet = 13, ;
		Name = "TxtFchDoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblglorf1 AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "LblGloRf1", ;
		Height = 16, ;
		Left = 4, ;
		Top = 7, ;
		Visible = .F., ;
		Width = 54, ;
		TabIndex = 27, ;
		ZOrderSet = 14, ;
		Name = "LblGloRf1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblglorf2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "LblGloRf2", ;
		Height = 16, ;
		Left = 471, ;
		Top = 171, ;
		Visible = .T., ;
		Width = 49, ;
		TabIndex = 84, ;
		ZOrderSet = 15, ;
		Name = "LblGlorf2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblglorf3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "LblGloRf3", ;
		Height = 16, ;
		Left = 134, ;
		Top = 394, ;
		Visible = .F., ;
		Width = 49, ;
		TabIndex = 85, ;
		ZOrderSet = 16, ;
		Name = "LblGloRf3"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcndpgo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cnd pgo.", ;
		Height = 16, ;
		Left = 235, ;
		Top = 460, ;
		Visible = .F., ;
		Width = 45, ;
		TabIndex = 58, ;
		ZOrderSet = 17, ;
		Name = "LblCndPgo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtdirent AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 396, ;
		TabIndex = 44, ;
		Top = 113, ;
		Visible = .F., ;
		Width = 281, ;
		ZOrderSet = 18, ;
		Name = "TxtDirEnt"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbldirent AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dir.Entrega", ;
		Height = 16, ;
		Left = 334, ;
		Top = 116, ;
		Visible = .F., ;
		Width = 55, ;
		TabIndex = 48, ;
		ZOrderSet = 19, ;
		Name = "LblDirEnt"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnrorf1 AS base_textbox WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 71, ;
		MaxLength = 10, ;
		TabIndex = 1, ;
		Top = 4, ;
		Visible = .F., ;
		Width = 86, ;
		ForeColor = RGB(255,0,0), ;
		DisabledForeColor = RGB(255,0,0), ;
		ZOrderSet = 20, ;
		Name = "TxtNroRf1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnrorf2 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 521, ;
		MaxLength = 10, ;
		TabIndex = 72, ;
		Top = 168, ;
		Visible = .T., ;
		Width = 84, ;
		ZOrderSet = 21, ;
		Name = "TxtNroRf2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.spndiavto AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999", ;
		Left = 283, ;
		TabIndex = 30, ;
		Top = 460, ;
		Visible = .F., ;
		Width = 14, ;
		ZOrderSet = 22, ;
		Name = "SpnDiaVto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnrorf3 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 152, ;
		MaxLength = 10, ;
		TabIndex = 73, ;
		Top = 390, ;
		Visible = .F., ;
		Width = 24, ;
		ZOrderSet = 23, ;
		Name = "TxtNroRf3"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblrucaux AS base_label WITH ;
		FontSize = 8, ;
		Caption = "RUC ", ;
		Height = 16, ;
		Left = 365, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 26, ;
		TabIndex = 43, ;
		ZOrderSet = 24, ;
		Name = "LblRucAux"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtrucaux AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 395, ;
		TabIndex = 45, ;
		Top = 67, ;
		Visible = .F., ;
		Width = 86, ;
		ZOrderSet = 25, ;
		Name = "TxtRucAux"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodven AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Vendedor", ;
		Height = 16, ;
		Left = 627, ;
		Top = 69, ;
		Visible = .F., ;
		Width = 50, ;
		TabIndex = 32, ;
		ZOrderSet = 26, ;
		Name = "LblCodVen"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodpro AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Proveedor", ;
		Height = 16, ;
		Left = 134, ;
		Top = 394, ;
		Visible = .F., ;
		Width = 52, ;
		TabIndex = 94, ;
		ZOrderSet = 27, ;
		Name = "LblCodPro"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbldirecc AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dirección", ;
		Height = 16, ;
		Left = 341, ;
		Top = 93, ;
		Visible = .F., ;
		Width = 47, ;
		TabIndex = 47, ;
		ZOrderSet = 28, ;
		Name = "LblDirecc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbldiavto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Días de Vcto.", ;
		Height = 16, ;
		Left = 627, ;
		Top = 69, ;
		Visible = .F., ;
		Width = 67, ;
		TabIndex = 51, ;
		ZOrderSet = 29, ;
		Name = "LblDiaVto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnroodt AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 677, ;
		TabIndex = 77, ;
		Top = 68, ;
		Visible = .F., ;
		Width = 15, ;
		ZOrderSet = 30, ;
		Name = "TxtNroOdt"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodmon AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Moneda", ;
		Left = 394, ;
		Top = 6, ;
		Visible = .F., ;
		TabIndex = 50, ;
		ZOrderSet = 31, ;
		Name = "LblCodMon"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodmon AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "S/.,US$", ;
		Value = 1, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 446, ;
		TabIndex = 52, ;
		Top = 4, ;
		Width = 86, ;
		ZOrderSet = 32, ;
		Name = "CboCodMon"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnrodoc AS base_textbox WITH ;
		FontBold = .F., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "9999999999", ;
		Left = 71, ;
		MaxLength = 10, ;
		TabIndex = 17, ;
		Top = 25, ;
		Visible = .F., ;
		Width = 80, ;
		ZOrderSet = 33, ;
		Name = "TxtNroDoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodprd AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Producto", ;
		Height = 16, ;
		Left = 628, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 45, ;
		TabIndex = 89, ;
		ZOrderSet = 34, ;
		Name = "LblCodPrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblfmapgo AS base_label WITH ;
		FontSize = 8, ;
		WordWrap = .T., ;
		Caption = "Forma de Pago", ;
		Height = 30, ;
		Left = 344, ;
		Top = 135, ;
		Visible = .F., ;
		Width = 47, ;
		TabIndex = 55, ;
		ZOrderSet = 35, ;
		Name = "lblFmaPgo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblmotivo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Motivo", ;
		Left = 553, ;
		Top = 5, ;
		Visible = .F., ;
		TabIndex = 31, ;
		ZOrderSet = 36, ;
		Name = "LblMotivo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbofmapgo AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 397, ;
		TabIndex = 25, ;
		Top = 136, ;
		Visible = .F., ;
		Width = 175, ;
		ZOrderSet = 37, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('FP'), ;
		cwheresql = "", ;
		caliascursor = "c_FmaPgo", ;
		Name = "CboFmaPgo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtobserv AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 29, ;
		Left = 63, ;
		TabIndex = 6, ;
		Top = 163, ;
		Visible = .T., ;
		Width = 263, ;
		Style = 0, ;
		ZOrderSet = 38, ;
		Name = "TxtObserv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblobserv AS base_label WITH ;
		FontSize = 8, ;
		WordWrap = .T., ;
		Caption = "Observa ciones", ;
		Height = 30, ;
		Left = 16, ;
		Top = 163, ;
		Visible = .F., ;
		Width = 44, ;
		TabIndex = 46, ;
		ZOrderSet = 39, ;
		Name = "LblObserv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodfase AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fase", ;
		Height = 16, ;
		Left = 642, ;
		Top = 71, ;
		Visible = .F., ;
		Width = 26, ;
		TabIndex = 91, ;
		ZOrderSet = 40, ;
		Name = "lblCodFase"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblenbasea AS base_label WITH ;
		FontSize = 8, ;
		WordWrap = .F., ;
		Caption = "En Base a", ;
		Height = 16, ;
		Left = 331, ;
		Top = 172, ;
		Visible = .F., ;
		Width = 51, ;
		TabIndex = 54, ;
		ZOrderSet = 41, ;
		Name = "LblEnbaseA"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodprocs AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 672, ;
		TabIndex = 82, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 17, ;
		ZOrderSet = 42, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "Cpiprocs", ;
		ccamporetorno = "CodProcs", ;
		ccampovisualizacion = "DesProCs", ;
		caliascursor = "GProcesos", ;
		Name = "CboCodProcs"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodpar AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 158, ;
		TabIndex = 74, ;
		Top = 394, ;
		Visible = .F., ;
		Width = 25, ;
		ZOrderSet = 43, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "cbdmpart", ;
		ccamporetorno = "codpar", ;
		ccampovisualizacion = "nompar", ;
		cwheresql = "", ;
		caliascursor = "GCodPar", ;
		Name = "CboCodPar"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodactiv AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 672, ;
		TabIndex = 83, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 17, ;
		ZOrderSet = 44, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "v_actividades_x_fase_proc", ;
		ccamporetorno = "CodActiv", ;
		ccampovisualizacion = "DesActiv", ;
		ccamposfiltro = "CodFase;CodProcs", ;
		caliascursor = "GActividades", ;
		Name = "cboCodActiv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodven AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 668, ;
		TabIndex = 35, ;
		Top = 68, ;
		Visible = .F., ;
		Width = 27, ;
		ZOrderSet = 45, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfVen), ;
		cwheresql = "", ;
		caliascursor = "C_Vendedor", ;
		Name = "CboCodVen"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodpro AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 146, ;
		TabIndex = 75, ;
		Top = 394, ;
		Visible = .F., ;
		Width = 25, ;
		ZOrderSet = 46, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfPro), ;
		cwheresql = "", ;
		caliascursor = "C_Proveedor", ;
		Name = "CboCodPro"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocoddire AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 396, ;
		TabIndex = 49, ;
		Top = 90, ;
		Visible = .F., ;
		Width = 281, ;
		ZOrderSet = 47, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CCtcDire", ;
		ccamporetorno = "CodDire", ;
		ccampovisualizacion = "DesDire", ;
		ccamposfiltro = "CodCli", ;
		cvaloresfiltro = (""), ;
		cwheresql = "", ;
		caliascursor = "C_Direc", ;
		corderby = ('1'), ;
		Name = "CboCodDire"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cboalmori AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 669, ;
		TabIndex = 76, ;
		Top = 68, ;
		Visible = .F., ;
		Width = 25, ;
		ZOrderSet = 48, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almtalma", ;
		ccamporetorno = "SubAlm", ;
		ccampovisualizacion = "DesSub", ;
		ccamposfiltro = "codsed", ;
		cvaloresfiltro = "gscodsed", ;
		cwheresql = "", ;
		caliascursor = "c_alma_dest", ;
		Name = "CboAlmOri"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocoddoc AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 386, ;
		SpecialEffect = 2, ;
		TabIndex = 56, ;
		Top = 169, ;
		Visible = .F., ;
		Width = 75, ;
		ZOrderSet = 49, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "sistdocs", ;
		ccamporetorno = "coddoc", ;
		ccampovisualizacion = "desdoc", ;
		ccamposfiltro = "", ;
		cwheresql = ("and ventas = .t."), ;
		caliascursor = "c_coddoc", ;
		Name = "CboCodDoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodfase AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 671, ;
		TabIndex = 81, ;
		Top = 68, ;
		Visible = .F., ;
		Width = 18, ;
		ZOrderSet = 50, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CpiFases", ;
		ccamporetorno = "CodFase", ;
		ccampovisualizacion = "DesFase", ;
		caliascursor = "GFases", ;
		Name = "CboCodFase"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cntcodcli AS base_textbox_cmdhelp WITH ;
		Top = 46, ;
		Left = 347, ;
		Width = 348, ;
		Height = 20, ;
		Visible = .F., ;
		TabIndex = 4, ;
		ZOrderSet = 51, ;
		cetiqueta = ("Codigo"), ;
		caliascursor = "C_Cliente", ;
		cnombreentidad = "cctclien", ;
		ccamporetorno = "CodAux", ;
		ccampovisualizacion = "Razsoc", ;
		Name = "CntCodCli", ;
		TxtCodigo.Height = 20, ;
		TxtCodigo.Left = 48, ;
		TxtCodigo.Top = 0, ;
		TxtCodigo.Width = 101, ;
		TxtCodigo.Name = "TxtCodigo", ;
		cmdHelp.Top = 0, ;
		cmdHelp.Left = 150, ;
		cmdHelp.Height = 20, ;
		cmdHelp.Name = "cmdHelp", ;
		txtDescripcion.Height = 20, ;
		txtDescripcion.Left = 175, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.Caption = "Codigo", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodprocs AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Proceso", ;
		Height = 16, ;
		Left = 646, ;
		Top = 71, ;
		Visible = .F., ;
		Width = 42, ;
		TabIndex = 92, ;
		ZOrderSet = 52, ;
		Name = "lblCodProcs"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbllotes AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Lote", ;
		Height = 16, ;
		Left = 647, ;
		Top = 68, ;
		Visible = .F., ;
		Width = 23, ;
		TabIndex = 87, ;
		ZOrderSet = 53, ;
		Name = "LblLotes"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcultivo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cultivo", ;
		Height = 16, ;
		Left = 235, ;
		Top = 460, ;
		Visible = .F., ;
		Width = 34, ;
		TabIndex = 88, ;
		ZOrderSet = 54, ;
		Name = "LblCultivo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodactiv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Actividad", ;
		Height = 16, ;
		Left = 642, ;
		Top = 73, ;
		Visible = .F., ;
		Width = 47, ;
		TabIndex = 93, ;
		ZOrderSet = 55, ;
		Name = "lblCodActiv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodprd AS base_cbohelp WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 671, ;
		TabIndex = 80, ;
		Top = 69, ;
		Visible = .F., ;
		Width = 18, ;
		ZOrderSet = 56, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almcatge", ;
		ccamporetorno = "Codmat", ;
		ccampovisualizacion = "Desmat", ;
		ccamposfiltro = "Tipmat", ;
		cvaloresfiltro = "20;", ;
		caliascursor = "GCodPrd", ;
		Name = "CboCodPrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcodpar AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Maquinaria", ;
		Height = 16, ;
		Left = 146, ;
		Top = 394, ;
		Visible = .F., ;
		Width = 54, ;
		TabIndex = 95, ;
		ZOrderSet = 57, ;
		Name = "lblCodPar"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblalmori AS base_label WITH ;
		FontSize = 8, ;
		WordWrap = .T., ;
		Caption = "Almacen Destino", ;
		Height = 30, ;
		Left = 630, ;
		Top = 63, ;
		Visible = .F., ;
		Width = 44, ;
		TabIndex = 90, ;
		ZOrderSet = 58, ;
		Name = "lblAlmOri"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdhelpnrodoc AS base_cmdhelp WITH ;
		Top = 4, ;
		Left = 157, ;
		Height = 20, ;
		Width = 24, ;
		Picture = "..\..\grafgen\iconos\help_dots.bmp", ;
		Enabled = .F., ;
		TabIndex = 19, ;
		ToolTipText = "Escoger de una lista", ;
		Visible = .F., ;
		SpecialEffect = 2, ;
		ZOrderSet = 59, ;
		cvaloresfiltro = "GoCfgAlm.Subalm;GoCfgAlm.TipMov;GoCfgAlm.CodMOv", ;
		ccamposfiltro = "SubAlm;TipMov;CodMov", ;
		cnombreentidad = "almctran", ;
		cwheresql = ("  AND DTOS(fchdoc) = '"+STR(_ANO,4)+trans(_MES,'@L 99')+"'"), ;
		ccamporetorno = "nrodoc", ;
		caliascursor = "c_nrodoc", ;
		ccampovisualizacion = "Observ", ;
		corderby = ('3 desc '), ;
		Name = "CmdHelpNrodoc"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocultivo AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 18, ;
		Left = 677, ;
		TabIndex = 79, ;
		Top = 69, ;
		Visible = .F., ;
		Width = 15, ;
		ZOrderSet = 60, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "v_cultivos_x_lote", ;
		ccamporetorno = "CodCult", ;
		ccampovisualizacion = "DesCult", ;
		ccamposfiltro = "CodSed;CodLote", ;
		cwheresql = "", ;
		caliascursor = "GCultivos", ;
		Name = "CboCultivo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cboruta AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 70, ;
		SpecialEffect = 2, ;
		TabIndex = 40, ;
		Top = 196, ;
		Visible = .F., ;
		Width = 227, ;
		ZOrderSet = 61, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('RT'), ;
		cwheresql = "", ;
		caliascursor = "c_CodRuta", ;
		Name = "CboRuta"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbolotes AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 677, ;
		TabIndex = 78, ;
		Top = 67, ;
		Visible = .F., ;
		Width = 15, ;
		ZOrderSet = 62, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CpiLotes", ;
		ccamporetorno = "Codlote", ;
		ccampovisualizacion = "Deslote", ;
		ccamposfiltro = "CodSed", ;
		cwheresql = "", ;
		caliascursor = "GLotes", ;
		Name = "CboLotes"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblnroodt AS base_label WITH ;
		FontSize = 8, ;
		Caption = "O/T", ;
		Height = 16, ;
		Left = 649, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 19, ;
		TabIndex = 86, ;
		ZOrderSet = 63, ;
		Name = "LblNroOdt"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblruta AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Zona/Ruta", ;
		Height = 16, ;
		Left = 6, ;
		Top = 196, ;
		Visible = .F., ;
		Width = 52, ;
		TabIndex = 38, ;
		ZOrderSet = 64, ;
		Name = "LblRuta"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdprocesar1 AS cmdprocesar WITH ;
		Top = 168, ;
		Left = 646, ;
		Height = 22, ;
		Width = 50, ;
		Picture = "..\..\bsinfo", ;
		DisabledPicture = "..\..\bsinfo", ;
		TabIndex = 57, ;
		ToolTipText = "Cargar documentos que generan la guia", ;
		Visible = .T., ;
		SpecialEffect = 2, ;
		ZOrderSet = 65, ;
		Name = "Cmdprocesar1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnroitm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 69, ;
		MousePointer = 0, ;
		TabIndex = 61, ;
		Top = 393, ;
		Visible = .F., ;
		Width = 44, ;
		ZOrderSet = 66, ;
		Name = "TxtNroItm"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnro_itm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		HelpContextID = 20, ;
		InputMask = "999.99", ;
		Left = 8, ;
		MousePointer = 0, ;
		TabIndex = 59, ;
		Top = 392, ;
		Visible = .F., ;
		Width = 43, ;
		ZOrderSet = 67, ;
		Name = "txtNro_itm"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.base_label5 AS base_label WITH ;
		Caption = "\", ;
		Height = 17, ;
		Left = 58, ;
		Top = 393, ;
		Visible = .F., ;
		Width = 5, ;
		TabIndex = 60, ;
		ZOrderSet = 68, ;
		Name = "Base_label5"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtimpbrt AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 543, ;
		TabIndex = 67, ;
		Top = 395, ;
		Visible = .F., ;
		Width = 116, ;
		ZOrderSet = 69, ;
		Name = "TxtImpBrt"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtimpigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 543, ;
		TabIndex = 69, ;
		Top = 416, ;
		Visible = .F., ;
		Width = 116, ;
		ZOrderSet = 70, ;
		Name = "TxtImpIgv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtimptot AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 543, ;
		TabIndex = 71, ;
		Top = 437, ;
		Visible = .F., ;
		Width = 116, ;
		ZOrderSet = 71, ;
		Name = "TxtImpTot"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtporigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 23, ;
		InputMask = "999.99", ;
		Left = 386, ;
		TabIndex = 65, ;
		Top = 413, ;
		Visible = .F., ;
		Width = 68, ;
		ZOrderSet = 72, ;
		Name = "txtPorIgv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblsubtot AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Sub - Total", ;
		Height = 16, ;
		Left = 477, ;
		Top = 400, ;
		Visible = .F., ;
		TabIndex = 66, ;
		ZOrderSet = 73, ;
		Name = "LblSubTot"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbligv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "I.G.V.", ;
		Height = 16, ;
		Left = 507, ;
		Top = 420, ;
		Visible = .F., ;
		TabIndex = 68, ;
		ZOrderSet = 74, ;
		Name = "LblIgv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbltotal AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Total", ;
		Left = 509, ;
		Top = 441, ;
		Visible = .F., ;
		TabIndex = 70, ;
		ZOrderSet = 75, ;
		Name = "LblTotal"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblporigv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "% I.G.V.", ;
		Height = 16, ;
		Left = 341, ;
		Top = 417, ;
		Visible = .F., ;
		Width = 42, ;
		TabIndex = 64, ;
		ZOrderSet = 76, ;
		Name = "LblPorIgv"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdhelp_codmat AS base_cmdhelp WITH ;
		Top = 417, ;
		Left = 152, ;
		Height = 21, ;
		Width = 23, ;
		Enabled = .F., ;
		TabIndex = 63, ;
		Visible = .F., ;
		ZOrderSet = 77, ;
		cvaloresfiltro = "GoCfgAlm.Subalm", ;
		ccamposfiltro = "SubAlm", ;
		cnombreentidad = "v_materiales_x_almacen_2", ;
		ccamporetorno = "CodMat", ;
		caliascursor = "c_MatAlmGrd", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelp_CodMat"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdaceptar2 AS cmdaceptar WITH ;
		Top = 398, ;
		Left = 233, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 14, ;
		Visible = .F., ;
		SpecialEffect = 0, ;
		PicturePosition = 7, ;
		ZOrderSet = 78, ;
		codigoboton = ("00001813"), ;
		Name = "Cmdaceptar2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdcancelar2 AS cmdcancelar WITH ;
		Top = 398, ;
		Left = 283, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 15, ;
		Visible = .F., ;
		SpecialEffect = 0, ;
		PicturePosition = 7, ;
		ZOrderSet = 79, ;
		codigoboton = ("00001814"), ;
		Name = "Cmdcancelar2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle AS base_grid WITH ;
		ColumnCount = 8, ;
		Height = 201, ;
		Left = 3, ;
		Panel = 1, ;
		TabIndex = 10, ;
		Top = 193, ;
		Width = 696, ;
		ZOrderSet = 80, ;
		AllowCellSelection = .F., ;
		Name = "grdDetalle", ;
		Column1.Width = 79, ;
		Column1.Name = "Column1", ;
		Column2.Width = 249, ;
		Column2.Name = "Column2", ;
		Column3.ColumnOrder = 4, ;
		Column3.CurrentControl = "TxtUndStkGrd", ;
		Column3.Width = 30, ;
		Column3.Name = "Column3", ;
		Column4.ColumnOrder = 3, ;
		Column4.Name = "Column4", ;
		Column5.Width = 59, ;
		Column5.Name = "Column5", ;
		Column6.Width = 96, ;
		Column6.Name = "Column6", ;
		Column7.Name = "Column7", ;
		Column8.Width = 82, ;
		Column8.Name = "Column8"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column1.header1 AS header WITH ;
		Caption = "Código", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column1.txtcodmatgrd AS base_textbox WITH ;
		Left = 17, ;
		Top = 33, ;
		Name = "txtCodMatGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column2.header1 AS header WITH ;
		Caption = "Descripción", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column2.txtdesmatgrd AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtDesMatGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column3.header1 AS header WITH ;
		Caption = "Und.", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column3.txtundstkgrd_ant AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtUndStkGrd_Ant"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column3.txtundstkgrd AS base_textbox WITH ;
		Left = 7, ;
		Top = 50, ;
		Name = "TxtUndStkGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column4.header1 AS header WITH ;
		Caption = "Cantidad", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column4.txtcandesgrd AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtCanDesGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column5.header1 AS header WITH ;
		Caption = "Prec.Uni.", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column5.txtpreunigrd AS base_textbox_texto WITH ;
		Left = 6, ;
		Top = 30, ;
		Name = "txtPreUniGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column6.header1 AS header WITH ;
		Caption = "Importe", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column6.txtimpctogrd AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtImpCtoGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column7.header1 AS header WITH ;
		Caption = "Lote", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column7.txtnrolotgrd AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtNroLotGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column7.txtserie AS base_textbox_serie WITH ;
		Left = 47, ;
		Top = 50, ;
		Name = "TxtSerie"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column8.header1 AS header WITH ;
		Caption = "Vencimiento", ;
		Name = "Header1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.grddetalle.column8.txtfchlotgrd AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtFchLotGrd"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdhelp_preuni AS base_cmdhelp WITH ;
		Top = 438, ;
		Left = 152, ;
		Height = 21, ;
		Width = 23, ;
		Enabled = .F., ;
		TabIndex = 62, ;
		Visible = .F., ;
		ZOrderSet = 81, ;
		ccamposfiltro = "tabla", ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "codigo", ;
		caliascursor = "c_PreUniGrd", ;
		ccampovisualizacion = "Nombre", ;
		Name = "cmdHelp_PreUni"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.chkretencion AS base_checkbox WITH ;
		Top = 65, ;
		Left = 494, ;
		Height = 24, ;
		Width = 123, ;
		Alignment = 0, ;
		Caption = "Agente Retención", ;
		TabIndex = 96, ;
		ZOrderSet = 82, ;
		Name = "ChkRetencion"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdfmapgo AS base_cmdhelp WITH ;
		Top = 135, ;
		Left = 543, ;
		Height = 22, ;
		Width = 30, ;
		Enabled = .F., ;
		TabIndex = 8, ;
		Visible = .F., ;
		ZOrderSet = 83, ;
		cvaloresfiltro = ('FP'), ;
		ccamposfiltro = "tabla", ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "codigo", ;
		caliascursor = "c_FormaPago2", ;
		ccampovisualizacion = "Nombre", ;
		Name = "CmdFmaPgo"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblnomtra AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Razon Social", ;
		Height = 16, ;
		Left = 7, ;
		Top = 91, ;
		Width = 65, ;
		TabIndex = 33, ;
		ZOrderSet = 84, ;
		Name = "LblNomTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbldirtra AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dirección", ;
		Height = 16, ;
		Left = 26, ;
		Top = 110, ;
		Width = 47, ;
		TabIndex = 37, ;
		ZOrderSet = 85, ;
		Name = "LblDirTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnomtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 74, ;
		MaxLength = 0, ;
		TabIndex = 18, ;
		Top = 89, ;
		Width = 246, ;
		ZOrderSet = 86, ;
		Name = "TxtNomtra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtdirtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 73, ;
		MaxLength = 0, ;
		TabIndex = 20, ;
		Top = 110, ;
		Width = 247, ;
		ZOrderSet = 87, ;
		Name = "TxtDirTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cntcodtra AS base_textbox_cmdhelp WITH ;
		Top = 65, ;
		Left = 25, ;
		Width = 130, ;
		Height = 24, ;
		TabIndex = 5, ;
		ZOrderSet = 88, ;
		cnombreentidad = "cbdmauxi", ;
		ccamporetorno = "CodAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfTra), ;
		Name = "CntCodTra", ;
		txtCodigo.Height = 20, ;
		txtCodigo.Left = 49, ;
		txtCodigo.Top = 2, ;
		txtCodigo.Width = 48, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdhelp.Top = 0, ;
		cmdhelp.Left = 99, ;
		cmdhelp.Height = 24, ;
		cmdhelp.Width = 28, ;
		cmdhelp.corderby = ('1'), ;
		cmdhelp.Name = "cmdhelp", ;
		txtDescripcion.Height = 24, ;
		txtDescripcion.Left = 129, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 180, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.FontSize = 8, ;
		lblCaption.Caption = "Codigo", ;
		lblCaption.Left = 0, ;
		lblCaption.Top = 4, ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblructra AS base_label WITH ;
		FontSize = 8, ;
		Caption = "R.U.C.", ;
		Height = 16, ;
		Left = 166, ;
		Top = 70, ;
		Width = 32, ;
		TabIndex = 41, ;
		ZOrderSet = 89, ;
		Name = "LblRucTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtnroref AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 127, ;
		TabIndex = 21, ;
		Top = 460, ;
		Visible = .F., ;
		Width = 84, ;
		ZOrderSet = 90, ;
		Name = "TxtNroRef"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtructra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 205, ;
		MaxLength = 11, ;
		TabIndex = 21, ;
		Top = 67, ;
		Width = 100, ;
		ZOrderSet = 90, ;
		Name = "TxtRucTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblplatra AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Nro. Placa ", ;
		Height = 16, ;
		Left = 19, ;
		Top = 132, ;
		Width = 54, ;
		TabIndex = 39, ;
		ZOrderSet = 91, ;
		Name = "LblPlaTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtplatra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 74, ;
		MaxLength = 8, ;
		TabIndex = 29, ;
		Top = 131, ;
		Width = 100, ;
		ZOrderSet = 92, ;
		Name = "TxtPlaTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblbrevet AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Brevete", ;
		Height = 16, ;
		Left = 186, ;
		Top = 133, ;
		Width = 40, ;
		TabIndex = 42, ;
		ZOrderSet = 93, ;
		Name = "LblBrevet"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.txtbrevet AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 230, ;
		MaxLength = 8, ;
		TabIndex = 24, ;
		Top = 131, ;
		Width = 88, ;
		ZOrderSet = 94, ;
		Name = "TxtBreVet"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lbltransportista AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		BackStyle = 1, ;
		Caption = "Datos del transportista", ;
		Height = 17, ;
		Left = 11, ;
		Top = 49, ;
		Width = 132, ;
		TabIndex = 36, ;
		BackColor = RGB(223,223,223), ;
		ZOrderSet = 95, ;
		Name = "LblTransportista"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.lblcliente AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		BackStyle = 1, ;
		Caption = "Datos del cliente", ;
		Height = 17, ;
		Left = 334, ;
		Top = 27, ;
		Width = 96, ;
		TabIndex = 34, ;
		BackColor = RGB(223,223,223), ;
		ZOrderSet = 96, ;
		Name = "LblCliente"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdhelpundvta AS base_cmdhelp WITH ;
		Top = 420, ;
		Left = 175, ;
		Height = 21, ;
		Width = 23, ;
		Enabled = .F., ;
		TabIndex = 62, ;
		Visible = .F., ;
		ZOrderSet = 81, ;
		cvaloresfiltro = ("UD"), ;
		ccamposfiltro = "Tabla", ;
		cnombreentidad = "Almtgsis", ;
		ccamporetorno = "Codigo", ;
		caliascursor = "c_UndVta", ;
		ccampovisualizacion = "Nombre", ;
		Name = "CmdHelpUndVta"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cbocodtra AS base_cbohelp WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 12, ;
		TabIndex = 7, ;
		Top = 65, ;
		Visible = .F., ;
		Width = 12, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "cbdmauxi", ;
		ccamporetorno = "CodAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfTra), ;
		caliascursor = "C_Trans", ;
		Name = "CboCodTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page1.cmdhelpnroref_multi AS base_cmdhelp_multiselect WITH ;
		Top = 166, ;
		Left = 609, ;
		Height = 24, ;
		Width = 24, ;
		Enabled = .F., ;
		cvaloresfiltro = (GoCfgAlm.XcFlgEst_Ref), ;
		ccamposfiltro = "FlgEst", ;
		cnombreentidad = "ALMCTRAN", ;
		caliascursor = "GuiaDespachoMulti", ;
		ccamporetorno = "Nrodoc", ;
		ccampovisualizacion = "Glosa", ;
		Name = "CmdHelpNroRef_Multi"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.cmdaceptar2 AS cmdaceptar WITH ;
		Top = 172, ;
		Left = 491, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 10, ;
		SpecialEffect = 0, ;
		PicturePosition = 7, ;
		codigoboton = ("00001813"), ;
		Name = "Cmdaceptar2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.cmdcancelar2 AS cmdcancelar WITH ;
		Top = 172, ;
		Left = 551, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 11, ;
		SpecialEffect = 0, ;
		PicturePosition = 7, ;
		codigoboton = ("00001814"), ;
		Name = "Cmdcancelar2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtdesmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 119, ;
		MaxLength = 0, ;
		TabIndex = 2, ;
		Top = 65, ;
		Width = 314, ;
		Name = "TxtDesmat"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Código", ;
		Height = 16, ;
		Left = 81, ;
		Top = 42, ;
		Width = 35, ;
		TabIndex = 12, ;
		Name = "Base_label1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Descripción", ;
		Height = 16, ;
		Left = 57, ;
		Top = 67, ;
		Width = 59, ;
		TabIndex = 13, ;
		Name = "Base_label2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Und.", ;
		Height = 16, ;
		Left = 457, ;
		Top = 67, ;
		Width = 24, ;
		TabIndex = 14, ;
		Name = "Base_label3"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label4 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cantidad", ;
		Height = 16, ;
		Left = 72, ;
		Top = 92, ;
		Width = 44, ;
		TabIndex = 16, ;
		Name = "Base_label4"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.lblpreuni AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Precio Unitario", ;
		Height = 16, ;
		Left = 45, ;
		Top = 117, ;
		Visible = .F., ;
		Width = 71, ;
		TabIndex = 17, ;
		Name = "LblPreUni"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.lblimpcto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Importe", ;
		Height = 16, ;
		Left = 79, ;
		Top = 141, ;
		Visible = .F., ;
		Width = 37, ;
		TabIndex = 18, ;
		Name = "LblImpCto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtundstk AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 489, ;
		TabIndex = 15, ;
		Top = 62, ;
		Width = 33, ;
		Name = "TxtUndStk"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtpreuni AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 119, ;
		TabIndex = 6, ;
		Top = 114, ;
		Visible = .F., ;
		Width = 84, ;
		Name = "TxtPreUni"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtimpcto AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.99", ;
		Left = 119, ;
		TabIndex = 7, ;
		Top = 139, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtImpCto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtfchvto AS base_textbox_fecha WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 119, ;
		TabIndex = 9, ;
		Top = 188, ;
		Visible = .T., ;
		Width = 96, ;
		Name = "TxtFchVto"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtlote AS base_textbox_texto WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 119, ;
		TabIndex = 8, ;
		Top = 163, ;
		Visible = .T., ;
		Width = 96, ;
		Name = "TxtLote"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label5 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "# Lote", ;
		Height = 16, ;
		Left = 84, ;
		Top = 167, ;
		Visible = .T., ;
		Width = 32, ;
		TabIndex = 22, ;
		Name = "Base_label5"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.base_label6 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha Vcmto.", ;
		Height = 16, ;
		Left = 47, ;
		Top = 192, ;
		Visible = .T., ;
		Width = 69, ;
		TabIndex = 21, ;
		Name = "Base_label6"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.cmdhelpcodmat AS base_cmdhelp WITH ;
		Top = 40, ;
		Left = 229, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 23, ;
		cvaloresfiltro = "GoCfgAlm.Subalm", ;
		ccamposfiltro = "SubAlm", ;
		cnombreentidad = "v_materiales_x_almacen_2", ;
		ccamporetorno = "CodMat", ;
		caliascursor = "c_MatAlm", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpCodMat"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtcodmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "R!", ;
		Height = 20, ;
		Left = 119, ;
		MaxLength = 8, ;
		TabIndex = 1, ;
		Top = 40, ;
		Width = 100, ;
		Name = "TxtCodmat"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtcandes AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 119, ;
		TabIndex = 3, ;
		Top = 89, ;
		Width = 85, ;
		Name = "TxtCanDes"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.cmdhelplote AS base_cmdhelp WITH ;
		Top = 164, ;
		Left = 225, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 24, ;
		ccamposfiltro = "CodMat", ;
		cnombreentidad = "v_materiales_x_lote", ;
		ccamporetorno = "Lote", ;
		caliascursor = "c_MatLote", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpLote"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtprec_cif AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.999", ;
		Left = 351, ;
		TabIndex = 4, ;
		Top = 117, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtPrec_Cif"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.lblprec_cif AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Precio FOB US$", ;
		Height = 16, ;
		Left = 266, ;
		Top = 121, ;
		Visible = .F., ;
		Width = 79, ;
		TabIndex = 19, ;
		Name = "LblPrec_Cif"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.txtfact_imp AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "9,999.9999", ;
		Left = 486, ;
		TabIndex = 5, ;
		ToolTipText = "Valor utilizado para calcular el precio de ingreso a almacen Precio Unitario = Precio Cif * Factor", ;
		Top = 117, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtFact_Imp"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page3.lblfact_imp AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Factor", ;
		Height = 16, ;
		Left = 450, ;
		Top = 121, ;
		Visible = .F., ;
		Width = 33, ;
		TabIndex = 20, ;
		Name = "LblFact_Imp"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_shape1 AS base_shape WITH ;
		Top = 31, ;
		Left = 11, ;
		Height = 168, ;
		Width = 607, ;
		Name = "Base_shape1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Código", ;
		Height = 16, ;
		Left = 15, ;
		Top = 246, ;
		Visible = .F., ;
		Width = 35, ;
		TabIndex = 10, ;
		Name = "Base_label1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Razón Social", ;
		Height = 16, ;
		Left = 71, ;
		Top = 80, ;
		Width = 65, ;
		TabIndex = 11, ;
		Name = "Base_label2"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dirección", ;
		Height = 16, ;
		Left = 88, ;
		Top = 104, ;
		Width = 47, ;
		TabIndex = 12, ;
		Name = "Base_label3"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label4 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "R.U.C.", ;
		Height = 16, ;
		Left = 453, ;
		Top = 59, ;
		Width = 32, ;
		TabIndex = 14, ;
		Name = "Base_label4"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label5 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Placa del Vehículo", ;
		Height = 16, ;
		Left = 43, ;
		Top = 128, ;
		Width = 90, ;
		TabIndex = 13, ;
		Name = "Base_label5"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label6 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Brevete", ;
		Height = 16, ;
		Left = 447, ;
		Top = 85, ;
		Width = 40, ;
		TabIndex = 15, ;
		Name = "Base_label6"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label_shape1 AS base_label_shape WITH ;
		FontBold = .T., ;
		Caption = "Datos del Transportistas", ;
		Height = 17, ;
		Left = 40, ;
		Top = 24, ;
		Width = 142, ;
		TabIndex = 9, ;
		Name = "Base_label_shape1"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtnomtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 0, ;
		TabIndex = 2, ;
		Top = 77, ;
		Width = 236, ;
		Name = "TxtNomtra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtdirtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 0, ;
		TabIndex = 3, ;
		Top = 102, ;
		Width = 236, ;
		Name = "TxtDirTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtructra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 495, ;
		MaxLength = 11, ;
		TabIndex = 4, ;
		Top = 56, ;
		Width = 100, ;
		Name = "TxtRucTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtplatra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 8, ;
		TabIndex = 7, ;
		Top = 129, ;
		Width = 100, ;
		Name = "TxtPlaTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtbrevet AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 495, ;
		MaxLength = 8, ;
		TabIndex = 5, ;
		Top = 82, ;
		Width = 100, ;
		Name = "TxtBreVet"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.cbocodtra AS base_cbohelp WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 56, ;
		TabIndex = 1, ;
		Top = 244, ;
		Visible = .F., ;
		Width = 96, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "cbdmauxi", ;
		ccamporetorno = "CodAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfTra), ;
		caliascursor = "C_Trans2", ;
		Name = "CboCodTra"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label7 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Marca", ;
		Height = 16, ;
		Left = 451, ;
		Top = 112, ;
		Width = 32, ;
		TabIndex = 17, ;
		Name = "Base_label7"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtmarca AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 494, ;
		MaxLength = 8, ;
		TabIndex = 6, ;
		Top = 109, ;
		Width = 100, ;
		Name = "TxtMarca"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.base_label8 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Certificado Inscripción", ;
		Height = 16, ;
		Left = 22, ;
		Top = 163, ;
		Width = 109, ;
		TabIndex = 16, ;
		Name = "Base_label8"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.txtcertif AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 8, ;
		TabIndex = 8, ;
		Top = 158, ;
		Width = 100, ;
		Name = "TxtCertif"


	ADD OBJECT funalm_transacciones_vta.pgfdetalle.page4.cntcodtra AS base_textbox_cmdhelp WITH ;
		Top = 50, ;
		Left = 81, ;
		Width = 156, ;
		Height = 24, ;
		cnombreentidad = "cbdmauxi", ;
		ccamporetorno = "CodAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfTra), ;
		Name = "CntCodTra", ;
		txtCodigo.Height = 24, ;
		txtCodigo.Left = 60, ;
		txtCodigo.Top = 0, ;
		txtCodigo.Width = 60, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdhelp.Top = 0, ;
		cmdhelp.Left = 126, ;
		cmdhelp.corderby = ('1'), ;
		cmdhelp.Name = "cmdhelp", ;
		txtDescripcion.Height = 24, ;
		txtDescripcion.Left = 156, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 252, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT cmdadicionar AS cmdnuevo WITH ;
		Top = 84, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		Picture = "..\..\grafgen\iconos\nuevo.bmp", ;
		TabIndex = 7, ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 3, ;
		codigoboton = ("00001371"), ;
		Name = "cmdAdicionar"


	ADD OBJECT cmdmodificar AS cmdmodificar WITH ;
		Top = 126, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		TabIndex = 8, ;
		Visible = .T., ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 4, ;
		codigoboton = ("00001372"), ;
		Name = "Cmdmodificar"


	ADD OBJECT cmdeliminar AS cmdeliminar WITH ;
		Top = 168, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		TabIndex = 9, ;
		Visible = .T., ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 5, ;
		codigoboton = ("00001373"), ;
		Name = "Cmdeliminar"


	ADD OBJECT cmdsalir AS cmdsalir WITH ;
		Top = 468, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		TabIndex = 16, ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 3, ;
		Name = "Cmdsalir"


	ADD OBJECT cmdimprimir AS cmdimprimir WITH ;
		Top = 348, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		Caption = "\<Imprimir", ;
		Enabled = .F., ;
		TabIndex = 14, ;
		ToolTipText = "Imprimir ", ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 4, ;
		codigoboton = ("00002313"), ;
		Name = "Cmdimprimir"


	ADD OBJECT base_shape1 AS base_shape WITH ;
		Top = 6, ;
		Left = 3, ;
		Height = 38, ;
		Width = 597, ;
		BackStyle = 1, ;
		BorderStyle = 1, ;
		BorderWidth = 2, ;
		SpecialEffect = 0, ;
		BackColor = RGB(106,155,227), ;
		ZOrderSet = 5, ;
		Style = 0, ;
		Name = "Base_shape1"


	ADD OBJECT lblalmacen AS base_label_shape WITH ;
		Caption = "Almacen", ;
		Height = 17, ;
		Left = 16, ;
		Top = -1, ;
		Width = 60, ;
		TabIndex = 1, ;
		ForeColor = RGB(0,0,0), ;
		ZOrderSet = 6, ;
		Name = "LblAlmacen"


	ADD OBJECT lbltipomov AS base_label_shape WITH ;
		Caption = "Tipo", ;
		Left = 192, ;
		Top = -1, ;
		TabIndex = 3, ;
		ForeColor = RGB(0,0,0), ;
		ZOrderSet = 7, ;
		Name = "LblTipoMov"


	ADD OBJECT lbltransaccion AS base_label_shape WITH ;
		Caption = "Transacción", ;
		Height = 17, ;
		Left = 309, ;
		Top = -1, ;
		Width = 72, ;
		TabIndex = 5, ;
		ForeColor = RGB(0,0,0), ;
		ZOrderSet = 8, ;
		Name = "LblTransaccion"


	ADD OBJECT cmdgrabar AS cmdgrabar WITH ;
		Top = 240, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		Enabled = .F., ;
		TabIndex = 12, ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 9, ;
		codigoboton = ("00001055"), ;
		Name = "Cmdgrabar"


	ADD OBJECT cboalmacen AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 11, ;
		TabIndex = 2, ;
		Top = 15, ;
		Width = 145, ;
		ZOrderSet = 10, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almtalma", ;
		ccamporetorno = "SubAlm", ;
		ccampovisualizacion = "DesSub", ;
		ccamposfiltro = "", ;
		cwheresql = "", ;
		caliascursor = "c_alma", ;
		Name = "CboAlmacen"


	ADD OBJECT cbocodmov AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 279, ;
		TabIndex = 6, ;
		Top = 15, ;
		Width = 201, ;
		ZOrderSet = 11, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almcftra", ;
		ccamporetorno = "CodMov", ;
		ccampovisualizacion = "DesMov", ;
		ccamposfiltro = "Tipmov", ;
		cwheresql = "", ;
		caliascursor = "c_Movi", ;
		Name = "CboCodMov"


	ADD OBJECT cmdprintguia AS cmdimprimir WITH ;
		Top = 396, ;
		Left = 708, ;
		Height = 40, ;
		Width = 50, ;
		WordWrap = .T., ;
		Caption = "\<G/R", ;
		Enabled = .F., ;
		TabIndex = 15, ;
		ToolTipText = "Imprimir  guía de remisión", ;
		SpecialEffect = 2, ;
		PicturePosition = 7, ;
		ZOrderSet = 12, ;
		codigoboton = ("00002313"), ;
		Name = "CmdPrintGuia"


	ADD OBJECT cbotipmov AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 163, ;
		TabIndex = 4, ;
		Top = 15, ;
		Width = 111, ;
		ZOrderSet = 13, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "Tabla", ;
		cvaloresfiltro = ("TT"), ;
		cwheresql = "", ;
		caliascursor = "c_TipoTrans", ;
		Name = "CboTipMov"


	ADD OBJECT cboptovta AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 488, ;
		TabIndex = 11, ;
		Top = 15, ;
		Width = 102, ;
		ZOrderSet = 14, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "vtaptovt", ;
		ccamporetorno = "ptovta", ;
		ccampovisualizacion = "nombre", ;
		ccamposfiltro = "sede", ;
		cvaloresfiltro = ('001'), ;
		cwheresql = "", ;
		caliascursor = "c_ptovta", ;
		Name = "CboPtoVta"


	ADD OBJECT lblptovta AS base_label_shape WITH ;
		Caption = "Punto de venta", ;
		Height = 17, ;
		Left = 489, ;
		Top = -2, ;
		Width = 82, ;
		TabIndex = 10, ;
		ForeColor = RGB(0,0,0), ;
		DisabledForeColor = RGB(0,0,153), ;
		ZOrderSet = 15, ;
		Name = "LblPtoVta"


	ADD OBJECT cntdoc_ref1 AS cntdoc_ref WITH ;
		Top = 491, ;
		Left = 336, ;
		Width = 120, ;
		Height = 31, ;
		Enabled = .T., ;
		Visible = .F., ;
		TabIndex = 17, ;
		ZOrderSet = 16, ;
		ccursor_local = "AUXI", ;
		ctabla_ref = ([CCBRGDOC]), ;
		ccmppk_ref = ([TpoDoc+CodDoc+Codcli]), ;
		Name = "Cntdoc_ref1", ;
		shpBorde.Top = 2, ;
		shpBorde.Left = 6, ;
		shpBorde.Height = 212, ;
		shpBorde.Width = 371, ;
		shpBorde.Name = "shpBorde", ;
		grid1.Column1.Header1.Name = "Header1", ;
		grid1.Column1.Text1.Name = "Text1", ;
		grid1.Column1.Name = "Column1", ;
		grid1.Column2.Header1.Name = "Header1", ;
		grid1.Column2.Text1.Name = "Text1", ;
		grid1.Column2.Name = "Column2", ;
		grid1.Column3.Header1.Name = "Header1", ;
		grid1.Column3.Text1.Name = "Text1", ;
		grid1.Column3.Base_textbox_fecha1.Name = "Base_textbox_fecha1", ;
		grid1.Column3.Name = "Column3", ;
		grid1.Column4.Header1.Name = "Header1", ;
		grid1.Column4.Text1.Name = "Text1", ;
		grid1.Column4.Base_checkbox1.Alignment = 0, ;
		grid1.Column4.Base_checkbox1.Name = "Base_checkbox1", ;
		grid1.Column4.Name = "Column4", ;
		grid1.Height = 180, ;
		grid1.Left = 10, ;
		grid1.Top = 28, ;
		grid1.Width = 303, ;
		grid1.Name = "grid1", ;
		LblTitulo.Left = 81, ;
		LblTitulo.Top = 8, ;
		LblTitulo.Name = "LblTitulo", ;
		CmdAceptar2.Top = 148, ;
		CmdAceptar2.Left = 314, ;
		CmdAceptar2.Height = 36, ;
		CmdAceptar2.Width = 60, ;
		CmdAceptar2.Picture = "..\..\bsinfo", ;
		CmdAceptar2.Caption = "\<Actualizar", ;
		CmdAceptar2.Name = "CmdAceptar2", ;
		Cmdprocesar1.Top = 89, ;
		Cmdprocesar1.Left = 314, ;
		Cmdprocesar1.Height = 36, ;
		Cmdprocesar1.Width = 60, ;
		Cmdprocesar1.WordWrap = .T., ;
		Cmdprocesar1.Picture = "..\..\bsinfo", ;
		Cmdprocesar1.Name = "Cmdprocesar1", ;
		Cmdprocesar3.Top = 38, ;
		Cmdprocesar3.Left = 314, ;
		Cmdprocesar3.Height = 36, ;
		Cmdprocesar3.Width = 60, ;
		Cmdprocesar3.WordWrap = .T., ;
		Cmdprocesar3.Picture = "..\..\bsinfo", ;
		Cmdprocesar3.Name = "Cmdprocesar3"


	ADD OBJECT lblestado AS base_label WITH ;
		FontBold = .T., ;
		FontName = "Tahoma", ;
		FontSize = 18, ;
		Caption = "ANULADO", ;
		Height = 31, ;
		Left = 628, ;
		Top = 8, ;
		Visible = .F., ;
		Width = 121, ;
		TabIndex = 19, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 10, ;
		Name = "LblEstado"


	PROCEDURE iniciar_var
		thisform.cmdadicionar.ENABLED	= .T.
		thisform.cmdModificar.ENABLED	= .T.
		thisform.cmdEliminar.ENABLED	= .T.

		thisform.cmdAdicionar.VISIBLE	= .T.
		thisform.cmdModificar.VISIBLE	= .T.
		thisform.cmdEliminar.VISIBLE	= .T.

		thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Enabled = .F.
		WITH THISFORM
			.desvincular_controles
			.CboAlmacen.ENABLED		=  .t. &&   (.T. 	AND !.lSubAlm )
			.CboTipMov.ENABLED		= (.T.	AND !.lTipMov )
			.CboCodMov.ENABLED		= (.T.	AnD !.lCodMov )
			.CboPtoVta.ENABLED		= (.T.	AnD .lPtoVta )
			.CboPtoVta.Visible		= (.T.	AnD .lPtoVta )
			.LblPtoVta.Visible		= (.T.	AnD .lPtoVta )
			.LblEstado.Visible 		= .F.
		*    .CboAlmacen.VALUE 		= gsSubAlm 
		*    .CboTipMov.Listindex  	= 1
		    .CmdImprimir.Enabled	= .f.
		    .CmdPrintGuia.Enabled	= .f.
		    
		    .CmdImprimir.Visible	= .f.
		    .CmdPrintGuia.Visible	= .f.
		    
			with thisform.pgfdetalle.page1
				.txtNroDoc.ENABLED		= .F.
				.cmdHelpNroDoc.ENABLED	= .F.
				.txtFchDoc.ENABLED		= .F.
				.TxtTpoCmb.ENABLED		= .F.
				.TxtObserv.ENABLED		= .F.
				.TxtNroRf1.ENABLED		= .F.
				.TxtNroRf2.ENABLED		= .F.
				.TxtNroRf3.ENABLED		= .F.
				.TxtNroOdt.ENABLED		= .F.
				.CboCodPrd.ENABLED		= .F.
				.CboCodPro.ENABLED		= .F.
				.CboCodVen.ENABLED		= .F.
				.CboFmaPgo.ENABLED		= .F.
				.CmdFmaPgo.Enabled		= .F.
				.cntCodCli.ENABLED		= .F.
				.CboCodPar.ENABLED		= .F.

				.CboCodMon.ENABLED 		= .F.
				.CboLotes.ENABLED		= .F.
				.CboCodProcs.ENABLED	= .F.
				.CboCodActiv.ENABLED	= .F.
				.CboCodFase.ENABLED		= .F.
				.CboCultivo.ENABLED		= .F.
				.CboMotivo.EnableD		= .F.
				.cmdAceptar2.ENABLED	= .F.
				.cmdCancelar2.ENABLED	= .F.

				.CboAlmOri.EnableD	    = .F.

				.txtNroDoc.VISIBLE		= .F.
				.txtFchDoc.VISIBLE		= .F.
				.TxtObserv.VISIBLE		= .F.
				.TxtTpoCmb.VISIBLE		= .F.
				.TxtNroRf1.VISIBLE		= IIF(Thisform.ObjRefTran.XsTpoRef='G/R',.T.,.F.)
				.TxtNroRf2.VISIBLE		= .F.
				.TxtNroRf3.VISIBLE		= .F.
				.TxtNroOdt.VISIBLE		= .F.
				.CboCodPrd.VISIBLE		= .F.
				.CboCodPro.VISIBLE		= .F.
				.CboCodVen.VISIBLE		= .F.
				.cntCodCli.VISIBLE		= .F.
				.CboCodDire.VISIBLE		= .F.
				.TxtDirEnt.Visible		= .F.
				.ChkRetencion.Visible	= .F.
				.CboCodPar.VISIBLE		= .F.
				.grdDetalle.VISIBLE		= .F.
				.cmdAdicionar1.VISIBLE	= .F.
				.cmdModificar1.VISIBLE	= .F.
				.cmdEliminar1.VISIBLE	= .F.
				.cntCodCli.Visible      = .F.
				.lblRucAux.Visible      = .F.
				.lblFmaPgo.Visible      = .F.
				.txtRucAux.Visible      = .F.
				.grdDetalle.Visible     = .F.
				.LblFchvto.Visible		= .F.
				.TxtFchvto.Visible		= .F.
				.CboCodMon.VISIBLE		= .F.
				.CboLotes.VISIBLE		= .F.
				.CboCodProcs.VISIBLE	= .F.
				.CboCodActiv.VISIBLE	= .F.
				.CboCodFase.VISIBLE		= .F.

				.CboCultivo.VISIBLE		= .F.
				.cboFmaPgo.VISIBLE      = .F.
				.CmdFmaPgo.VISIBLE      = .F.
				.CboMotivo.VISIBLE		= .F.
				.cmdAceptar2.VISIBLE	= .F.
				.cmdCancelar2.VISIBLE	= .F.

				.CboAlmOri.VISIBLE	    = .F.

				.CboRuta.Visible		= .F.
		*!*			.Cntdoc_ref1.Visible	= .F.

				.LblObserv.Visible		= .F.
				.LblNrodoc.Visible		= .F.
				.LblFchDoc.Visible		= .F.
				.LblCodMon.VISIBLE		= .F.
				.LblLotes.VISIBLE		= .F.
				.LblCodProcs.VISIBLE	= .F.
				.LblCodActiv.VISIBLE	= .F.
				.LblCodFase.VISIBLE		= .F.
				.LblCultivo.VISIBLE		= .F.
				.LblMotivo.VISIBLE		= .F.
				.LblAlmOri.VISIBLE	    = .F.

				.LblRuta.Visible		= .F.

				.LblTpoCmb.VISIBLE		= .F.
				.LblGloRf1.VISIBLE		= IIF(Thisform.ObjRefTran.XsTpoRef='G/R',.T.,.F.)
				.LblGloRf2.VISIBLE		= .F.
				.LblGloRf3.VISIBLE		= .F.
				.LblNroOdt.VISIBLE		= .F.
				.LblCodPrd.VISIBLE		= .F.
				.LblCodPro.VISIBLE		= .F.
				.LblCodVen.VISIBLE		= .F.
		*!*			.LblCodCli.VISIBLE		= .F.
				.LblDirecc.VISIBLE		= .F.
				.LblDirEnt.VISIBLE		= .F.
				.LblCodPar.VISIBLE		= .F.
				*** Controles para capturar items en base documentos 
				.LblEnbaseA.Visible		= .F.
				.CmdProcesar1.Visible	= .F.
				.CboCodDoc.Visible		= .F.
				.CmdHelpNroRef_Multi.Visible = .F.

				*** 
			endwith
		    *
			with thisform.pgfdetalle.page1
				.TxtPorIgv.VISIBLE	= .F.
				.txtImpBrt.VISIBLE	= .F.
				.txtImpIgv.VISIBLE  = .F.
				.txtImpTot.VISIBLE	= .F.
				**
				.LblPorIgv.VISIBLE	= .f.
				.LblSubTot.VISIBLE	= .f.
				.LblIgv.VISIBLE		= .f.
				.LblTotal.VISIBLE	= .f.
				**
				.cmdadicionar1.ENABLED	= .F.
				.cmdModificar1.ENABLED	= .F.
				.cmdEliminar1.ENABLED	= .F.
			endwith
			*
			WITH thisform.PgfDetalle.Page3
				.TxtCodmat.MaxLength = GaLenCod(3) 
				.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod(3)-GnLenDiv)
				.TxtPreuni.VISIBLE = .f.
				.TxtImpCto.VISIBLE = .f.
				.LblPreuni.VISIBLE = .f.
				.LblImpCto.VISIBLE = .f.
			ENDWITH
			WITH THISFORM.PgfDetalle.PAGES(1)
			** Inicializamos Variables
			*!*		.CboCodTra.VALUE = SPACE(LEN(C_CTRA.CodTra))
			*!*		.TxtNomTra.VALUE = SPACE(LEN(C_CTRA.NomTra))
			*!*		.TxtDirTra.VALUE = SPACE(LEN(C_CTRA.DirTra))
			*!*		.TxtRucTra.VALUE = SPACE(LEN(C_CTRA.RucTra))
			*!*		.TxtPlaTra.VALUE = SPACE(LEN(C_CTRA.PlaTra))
			*!*		.TxtBreVet.VALUE = SPACE(LEN(C_CTRA.BreVet))
				.ShpCliente.Visible		=   .F.
				.LblCliente.Visible		=	.F.
				.ShpTransportista.Visible = .F.
				.LblTransportista.Visible = .F.

				.LblNomTra.Visible = .f.
				.LblDirTra.Visible = .f.
				.LblRucTra.Visible = .f.
				.LblPlaTra.Visible = .f.
				.LblBreVet.Visible = .f.


				.CntCodTra.Visible = .f.
				.TxtNomTra.Visible = .f.
				.TxtDirTra.Visible = .f.
				.TxtRucTra.Visible = .f.
				.TxtPlaTra.Visible = .f.
				.TxtBreVet.Visible = .f.
		*!*			.TxtMarca.Enabled = .F.
		*!*			.TxtCertif.Enabled = .F.

				.CboCodTra.ENABLED = .f.
				.CntCodTra.ENABLED = .f.
				.TxtNomTra.ENABLED = .f.
				.TxtDirTra.ENABLED = .f.
				.TxtRucTra.ENABLED = .f.
				.TxtPlaTra.ENABLED = .f.
				.TxtBreVet.ENABLED = .f.

		*!*			.TxtMarca.Enabled = .F.
		*!*			.TxtCertif.Enabled = .F.


			*	.CboCodTra.SETFOCUS()
			ENDWITH


		    THISFORM.LIMPIAR_VAR()

			.CmdSalir.ENABLED 		= .T.
			.CmdSalir.Visible 		= .T.

			.CmdGrabar.Caption 		= '\<Grabar'
			.CmdGrabar.Visible 		= .F.
			.CmdGrabar.ENABLED 		= .F.

			.CmdIniciar.ENABLED		= .F.
			.CmdIniciar.Visible		= .F.

		ENDWITH
		=gocfgalm.inicializavariablesCFG()
		IF !thisform.lsubalm 
			gocfgalm.subalm = gsSubAlm 
		ENDIF
		** Inicializar headers del GRID Detalle **
		DO CASE 
			CASE GsSigCia='PREZCOM'
				WITH THIS.pgfDetalle.PAGES(1).grdDetalle
					IF goCfgAlm.lPidPco OR gocfgalm.lctovta
						.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
						.COLUMNS(6).HEADER1.CAPTION = "Importe"
						.COLUMNS(5).WIDTH = 0
						.COLUMNS(6).WIDTH = 0
						.COLUMNS(7).HEADER1.CAPTION = "# Serie"
						.COLUMNS(8).HEADER1.CAPTION = "Garantia"
						.COLUMNS(7).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(8).WIDTH = .COLUMNS(4).WIDTH
					ELSE
						.COLUMNS(5).HEADER1.CAPTION = "# Serie"
						.COLUMNS(6).HEADER1.CAPTION = "Garantia"

						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						*
					ENDIF
				ENDWITH
			CASE GsSigCia='CAUCHO'
				WITH THIS.pgfDetalle.PAGES(1).grdDetalle
		*			IF goCfgAlm.lPidPco OR gocfgalm.lctovta
						.HEADERHEIGHT = 38
						.COLUMNS(3).HEADER1.WORDWRAP = .T.
						.COLUMNS(3).HEADER1.CAPTION = "Und Vta"
						.COLUMNS(3).HEADER1.WORDWRAP = .T.
						.COLUMNS(5).HEADER1.CAPTION = "Factor Unidad  Venta"
						.COLUMNS(6).HEADER1.CAPTION = "Total"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(7).HEADER1.CAPTION = ""
						.COLUMNS(8).HEADER1.CAPTION = ""
						.COLUMNS(7).WIDTH = 0
						.COLUMNS(8).WIDTH = 0
		*!*				ELSE
		*!*					.COLUMNS(5).HEADER1.CAPTION = "# Serie"
		*!*					.COLUMNS(6).HEADER1.CAPTION = "Garantia"

		*!*					.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
		*!*					.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
		*!*					*
		*!*				ENDIF
				ENDWITH
			OTHER
				WITH THIS.pgfDetalle.PAGES(1).grdDetalle
					IF goCfgAlm.lPidPco OR gocfgalm.lctovta
						.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
						.COLUMNS(6).HEADER1.CAPTION = "Importe"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(7).HEADER1.CAPTION = "# Lote"
						.COLUMNS(8).HEADER1.CAPTION = "Fch. Vto."
						.COLUMNS(7).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(8).WIDTH = .COLUMNS(4).WIDTH
					ELSE
						.COLUMNS(5).HEADER1.CAPTION = "# Lote"
						.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						*
					ENDIF
				ENDWITH
		ENDCASE
	ENDPROC


	PROCEDURE vincular_controles
		LOCAL LcAlmacen,LcTipMov,LcCodMov,LcNroDoc,LcTabla,LlExiste
		WITH THISFORM
			.LockScreen = .T.
		*!*		SET STEP ON 
			gocfgAlm.SubAlm = .cboAlmacen.value
			GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
			GoCfgAlm.sCodMov=.cboCodmov.value
			GoCfgalm.xsptovta = .CboPtoVta.Value
			WITH THISFORM.PgfDetalle.page1

				.TxtNroDoc.Value = PADR(.TxtNroDoc.Value,LEN(DTRA.nrodoc))

				GoCfgAlm.sNroDoc = .txtnrodoc.value
				thisform.ObjRefTran.CfgVar_PK('ALMCTRAN')
				** Preparamos Cursor del Detalle ** 
				thisform.tools.closetable('C_DTRA')	 
				IF thisform.ObjRefTran.XsTpoRef='G/R' AND thisform.xReturn<>'I'
					=Cap_Almdtran([C_DTRA],thisform.ObjRefTran.XsTpoRef,Thisform.PgfDetalle.Page1.TxtNroRf1.Value)
				ELSE
					=Cap_Almdtran([C_DTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
				ENDIF

				IF THISFORM.xReturn = 'I'   && Nuevo Registro

					.txtnrodoc.value=correlativo_alm(GOCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,gocfgalm.SubAlm,'0')  
					thisform.tools.closetable('C_DTRA')
					GoCfgAlm.sNroDoc = .txtnrodoc.value
			 		=Cap_Almdtran([C_DTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
				ENDIF

				LlExiste=SEEK(gocfgalm.SubAlm+GoCfgAlm.cTipMov+GoCfgAlm.sCodMov+GoCfgAlm.sNroDoc,'DTRA','DTRA01')


				IF thisform.Objreftran.XsTpoRef='G/R' 
					IF val(.txtNroRf1.value)=0 AND thisform.xReturn<>'I'
					    thisform.LockScreen = .F.
						RETURN .f.
					ENDIF

				ELSE
					IF val(.txtnrodoc.value)=0
						thisform.LockScreen = .F.
						RETURN .f.
					ENDIF
				ENDIF
				LcNroDoc = trim(.txtnrodoc.value)
				** Preparamos Cursor de la cabecera ** 
				IF thisform.Objreftran.XsTpoRef='G/R'  AND thisform.xReturn<>'I'
					IF SEEK(PADR(THISFORM.ObjRefTran.XsTpoRef,LEN(CTRA.TpoRf1))+PADR(.TxtNroRf1.Value,LEN(CTRA.NroRf1)),'CTRA','CTRA03')
						.TxtNroDoc.Value = CTRA.NroDoc
						GoCfgAlm.sNroDoc = CTRA.NroDoc
						GoCfgAlm.SubAlm  = CTRA.SubAlm
						THISFORM.CboAlmacen.Value = CTRA.SubAlm
						THISFORM.CboAlmacen.InteractiveChange 
					ENDIF
				ENDIF
				** Preparamos Cursor de la Cabecera ** 
				thisform.tools.closetable('C_CTRA')
		*!*			lCreaTmp=goentorno.open_dbf1('TEMP_STR','CTRA','C_CTRA','','')
				=Cap_Almctran([C_CTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
				IF INLIST(thisform.xreturn ,'A','E')
					IF THISFORM.Tools.cursor_esta_vacio("C_CTRA")	&& No existe Nro. de documento
						.LockScreen = .F.
						RETURN .f.
					ENDIF
				ENDIF
				thisform.Desvincular_Controles()
				thisform.PgfDetalle.Page1.CmdHelpNrodoc.Enabled=.F.
				** Capturamos la configuracion de transacciones para el tipo y codigo de la configuración en ALMCFTRA

				** VETT 2005/11/29
				IF thisform.ObjRefTran.XsTpoRef = 'G/R' AND thisform.xreturn='I' 
					thisform.LblPtoVta.Visible = .T.
					thisform.cboPtoVta.Visible = .T.				 
					thisform.cboPtoVta.Enabled = .T.
					thisform.PgfDetalle.Page1.CboFmaPgo.Value = 	PADR('C/E',LEN(TABL.Codigo)) && Contra Entrega
					thisform.PgfDetalle.Page1.CboCodMon.Value = 2 
					 
									 
				ENDIF
				**
				IF THISFORM.xReturn <> 'I'   		&& Nuevo Registro
					IF thisform.ObjRefTran.XsTpoRef = 'G/R'
						thisform.LblPtoVta.Visible = .T.
						thisform.cboPtoVta.Visible = .T.				 
						thisform.cboPtoVta.Enabled = .F.				 
					ENDIF

					.TxtFchDoc.Value = C_CTRA.FchDoc
					.TxtTpoCmb.VALUE = C_CTRA.TpoCmb
					.CboCodMon.VALUE = C_CTRA.CodMon
					.TxtNroRf1.VAlue = C_CTRA.NroRf1
					.TxtNroRf2.VALUE = C_CTRA.NroRf2
					.TxtNroRf3.VALUE = C_CTRA.NroRf3
					.CboCodPro.VALUE = C_CTRA.CodPro
					.CboCodVen.VALUE = C_CTRA.CodVen
					.cntCodCli.VALUE = C_CTRA.CodCli
		*!*				.txtRucAux.VALUE = C_CTRA.RucCli
					.CntCodCli.TxtCodigo.InteractiveChange()
		*!*				=SEEK(.cntCodCli.VALUE,.cntCodCli.Cnombreentidad,'CLIEN03')
		*!*				LsValorFiltro	=	.cntCodCli.Cnombreentidad+'.CoDcli' 
		*!*				.cboCodDire.cValoresfiltro = EVALUATE(LsValorFiltro)
		*!*				.cboCodDire.generarcursor() 
					.CboCodDire.VALUE 	=	C_CTRA.CodDire

					.CboCodPar.VALUE 	=	C_CTRA.CodPar
					.TxtObserv.VALUE 	=	C_CTRA.Observ
					.TxtNroOdt.VALUE 	=	C_CTRA.NroODt
					.CboCodPrd.VALUE 	=	C_CTRA.CodPrd
					.CboLotes.VALUE		=	C_CTRA.CodLote
					.CboCodProcs.VALUE	=	C_CTRA.CodProcs
					.CboCodActiv.VALUE	=	C_CTRA.CodActiv
					.CboCultivo.VALUE	=	C_CTRA.CodCult
					.CboCodFase.VALUE	=	C_CTRA.CodFase
					.cboFmaPgo.VALUE	=	PADR(C_CTRA.CndPgo,LEN(TABL.Codigo)) && C_CTRA.FmaPgo 
					.CboFmaPgo.Valid()
					*

				    * Muestra los almacenes internos que corresponden a ese Predio 
		            .CboAlmOri.cValoresFiltro = gsCodSed
		            .cboAlmOri.cWhereSql      = ' AND SubAlm <> GoCfgAlm.SubAlm'            
		            .CboAlmOri.GenerarCursor()

					.CboAlmOri.VALUE    =   IIF(GoCfgAlm.Transf AND GoCfgAlm.cTipMov='S',C_CTRA.AlmTrf,;
											IIF(GoCfgAlm.Transf AND GoCfgAlm.cTipMov='I',C_CTRA.AlmOri,''))

					.CboAlmOri.interactivechange()	            


					.CboMotivo.VALUE	= 	C_CTRA.Motivo
					THISFORM.LblEstado.Visible	=   IIF(C_CTRA.FlgEst='A',.T.,.F.)

					*
				ENDIF


				.TxtObserv.Enabled 		=	THISFORM.xReturn <> "E"
				.TxtFchDoc.Enabled		=   THISFORM.xReturn <> "E"
				 **	Se Habilitan controles segun configuracion del Tipo y Codigo de Movimiento
				.TxtNroOdt.VISIBLE 		=	goCfgAlm.lPidOdt
				.CboCodPrd.VISIBLE 		=	goCfgAlm.lModCsm
				.CboLotes.VISIBLE		=	goCfgAlm.lModCsm
				.CboCodProcs.VISIBLE	=	goCfgAlm.lModCsm
				.CboCodActiv.VISIBLE	=	goCfgAlm.lModCsm
				.CboCultivo.VISIBLE		=	goCfgAlm.lModCsm
				.CboCodFase.VISIBLE		=	goCfgAlm.lModCsm
				.CboMotivo.VISIBLE		=	goCfgAlm.lPidMot

				.TxtNroOdt.ENABLED 		=	goCfgAlm.lPidOdt AND THISFORM.xReturn <> "E"
				.CboCodPrd.ENABLED 		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboLotes.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboCodProcs.ENABLED	=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboCodActiv.ENABLED	=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboCultivo.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboCodFase.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
				.CboMotivo.ENABLED		=   goCfgAlm.lPidMot AND THISFORM.xReturn <> "E" 
				 **
				 
				.LblNroOdt.VISIBLE 		=	goCfgAlm.lPidOdt
				.LblCodPrd.VISIBLE 		=	goCfgAlm.lModCsm
				.LblLotes.VISIBLE		=	goCfgAlm.lModCsm
				.LblCodProcs.VISIBLE	=	goCfgAlm.lModCsm
				.LblCodActiv.VISIBLE	=	goCfgAlm.lModCsm
				.LblCultivo.VISIBLE		=	goCfgAlm.lModCsm
				.LblCodFase.VISIBLE		=	goCfgAlm.lModCsm
				.lblmotivo.VISIBLE		=	goCfgAlm.lPidMot

				IF goCfgAlm.lModCsm AND THISFORM.xReturn = "I"
				    * Muestra los Lotes que corresponde al Predio Seleccionado
		            .CboLotes.cValoresFiltro=gsCodSed
		            .CboLotes.GenerarCursor()
		            *
					.CboLotes.interactivechange()	            
					.CboCodProcs.interactivechange()
				ENDIF
				**
				.TxtTpoCmb.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.CboCodMon.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.CboFmaPgo.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.CmdFmaPgo.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.TxtFchVto.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.txtRucAux.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.TxtNroRf1.VISIBLE 		=	goCfgAlm.lPidRf1
				.TxtNroRf2.VISIBLE 		=	goCfgAlm.lPidRf2 
				.TxtNroRf3.VISIBLE 		=	goCfgAlm.lPidRf3
				.CboCodPro.VISIBLE 		=	goCfgAlm.lPidPro
				.CboCodVen.VISIBLE 		=	goCfgAlm.lPidVen
				.cntCodCli.VISIBLE 		=	goCfgAlm.lPidCli
				.TxtDirEnt.VISIBLE		=	goCfgAlm.lPidCli
				.ChkRetencion.VISIBLE	=   goCfgAlm.lPidCli
				.CboCodDire.VISIBLE 	=	goCfgAlm.lPidCli
				.CboCodPar.VISIBLE 		=	goCfgAlm.lPidActFijo
				.ShpCliente.Visible		=   goCfgAlm.lPidCli
				.LblCliente.Visible		=	goCfgAlm.lPidCli
				.ShpTransportista.Visible = goCfgAlm.lPidCli
				.LblTransportista.Visible = goCfgAlm.lPidCli

				*
				.CboAlmOri.VISIBLE 	    =	IIF(INLIST(LEFT(THISFORM.CboTipMov.VALUE,1),'T','S') and GoCfgAlm.Transf,.T.,.F.)
				.CboCodDoc.VISIBLE		= .f. &&.T. && .T.
				.LblEnBaseA.Visible		= .f. &&.T.

				.CboRuta.Visible		= IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				*
				.TxtTpoCmb.ENABLED 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta AND THISFORM.xReturn <> "E"
				.CboCodMon.ENABLED 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta AND THISFORM.xReturn <> "E"
		*!*			.CboFmaPgo.ENABLED 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta AND THISFORM.xReturn <> "E"
				.CmdFmaPgo.ENABLED 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta AND THISFORM.xReturn <> "E"
				.TxtNroRf1.ENABLED 		=	goCfgAlm.lPidRf1 AND THISFORM.xReturn <> "E"
				.TxtNroRf2.ENABLED 		=	goCfgAlm.lPidRf2 AND THISFORM.xReturn <> "E" AND goCfgAlm.lEdtRf2
				.TxtNroRf3.ENABLED 		=	goCfgAlm.lPidRf3 AND THISFORM.xReturn <> "E"
				.CboCodPro.ENABLED 		=	goCfgAlm.lPidPro AND THISFORM.xReturn <> "E"
				.CboCodVen.ENABLED 		=	goCfgAlm.lPidVen AND THISFORM.xReturn <> "E"
				.cntCodCli.ENABLED 		=	goCfgAlm.lPidCli AND THISFORM.xReturn <> "E"
				.CboCodDire.ENABLED 	=	goCfgAlm.lPidCli AND THISFORM.xReturn <> "E"
				.ChkRetencion.ENABLED	=	.F. &&   goCfgAlm.lPidCli AND THISFORM.xReturn <> "E"
				.CboCodPar.ENABLED 		=	goCfgAlm.lPidActFijo AND THISFORM.xReturn <> "E"
				.CboAlmOri.ENABLED 	    =	IIF(LEFT(THISFORM.CboTipMov.VALUE,1)='T',.T.,.F.) AND THISFORM.xReturn <> "E"

				.LblTpoCmb.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblCodMon.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblRucAux.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblFmaPgo.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblFchVto.VISIBLE 		=	goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblGloRf1.VISIBLE 		=	goCfgAlm.lPidRf1
				.LblGloRf2.VISIBLE 		=	goCfgAlm.lPidRf2
				.LblGloRf3.VISIBLE 		=	goCfgAlm.lPidRf3
				.LblCodPro.VISIBLE 		=	goCfgAlm.lPidPro
				.LblCodVen.VISIBLE 		=	goCfgAlm.lPidVen
		*!*			.LblCodCli.VISIBLE 		=	goCfgAlm.lPidCli
				.LblDirecc.VISIBLE 		=	goCfgAlm.lPidCli
				.LblDirEnt.VISIBLE		=	goCfgAlm.lPidCli
				.LblCodPar.VISIBLE 		=	goCfgAlm.lPidActFijo
				**
				.LblAlmOri.Caption    =   IIF(GoCfgAlm.Transf AND GoCfgAlm.cTipMov='S',[Almacen destino],;
											IIF(GoCfgAlm.Transf AND GoCfgAlm.cTipMov='I',[Almacen origen],''))

				.LblAlmOri.VISIBLE 	    =	IIF(INLIST(LEFT(THISFORM.CboTipMov.VALUE,1),'T','S') and GoCfgAlm.Transf,.T.,.F.)

				**
				IF LEFT(THISFORM.CboTipMov.VALUE,1) = "T" AND THISFORM.xReturn = "I"
				    * Muestra los almacenes internos que corresponden a ese Predio 
		            .CboAlmOri.cValoresFiltro = gsCodSed
		            .cboAlmOri.cWhereSql      = ' AND SubAlm <> GoCfgAlm.SubAlm'            
		            .CboAlmOri.GenerarCursor()
					.CboAlmOri.interactivechange()	            
				ENDIF
				**
				.LblGloRf1.CAPTION 		=	goCfgAlm.GloRf1
				.LblGloRf2.CAPTION 		=	goCfgAlm.GloRf2
				.LblGloRf3.CAPTION 		=	goCfgAlm.GloRf3
				**

				.LblRuta.Visible		= IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				.CboRuta.ENABLED		= IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)

				.LblEnbaseA.Visible		= thisform.xReturn ='I'
				.CboCodDoc.VISIBLE		= thisform.xReturn ='I'
				.CboCodDoc.ENABLED		= .CboCodDoc.VISIBLE
				.TxtNroRf2.VISIBLE		= thisform.xReturn ='I'
				.TxtNroRf2.ENABLED		= .TxtNroRf2.VISIBLE

				.CmdHelpNroRef_Multi.Visible    = thisform.xReturn ='I'
				.CmdHelpNroRef_Multi.Enabled    = .CmdHelpNroRef_Multi.Visible

				.TxtNroDoc.ENABLED 		= .F.
			ENDWITH

			WITH thisform.PgfDetalle.Page1
				.TxtNroItm.Value	= C_CTRA.NroItm
				.TxtPorIgv.Value	= C_CTRA.PorIgv
				.txtImpBrt.Value	= C_CTRA.ImpBrt
				.txtImpIgv.VALUE	= C_CTRA.ImpIgv
				.txtImpTot.VALUE	= C_CTRA.ImpTot
				**
				.TxtPorIgv.ENABLED 	= goCfgAlm.lPidPco AND THISFORM.xReturn <> "E"
				**
				.TxtPorIgv.VISIBLE	= goCfgAlm.lPidPco
				.txtImpBrt.VISIBLE	= goCfgAlm.lPidPco
				.txtImpIgv.VISIBLE	= goCfgAlm.lPidPco
				.txtImpTot.VISIBLE	= goCfgAlm.lPidPco
				**
				.LblPorIgv.VISIBLE	= goCfgAlm.lPidPco
				.LblSubTot.VISIBLE	= goCfgAlm.lPidPco
				.LblIgv.VISIBLE		= goCfgAlm.lPidPco
				.LblTotal.VISIBLE	= goCfgAlm.lPidPco
				**
			ENDWITH

			thisform.Vincular_controles_detalle() 


			WITH thisform.PgfDetalle.Page3
				.TxtPreuni.VISIBLE = goCfgAlm.lPidPco OR gocfgalm.lctovta
				.TxtImpCto.VISIBLE = goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblPreuni.VISIBLE = goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblImpCto.VISIBLE = goCfgAlm.lPidPco OR gocfgalm.lctovta
				.LblFact_Imp.VISIBLE = goCfgAlm.lPidPco AND GoCfgAlm.Es_imp 
				.LblPrec_Cif.VISIBLE = goCfgAlm.lPidPco AND GoCfgAlm.Es_imp 
				.TxtFact_Imp.VISIBLE = goCfgAlm.lPidPco AND GoCfgAlm.Es_imp 
				.TxtPrec_Cif.VISIBLE = goCfgAlm.lPidPco AND GoCfgAlm.Es_imp 
			ENDWITH
			WITH THISFORM.PgfDetalle.PAGES(1)
				.LblNomTra.Visible = .T.
				.LblDirTra.Visible = .T.
				.LblRucTra.Visible = .T.
				.LblPlaTra.Visible = .T.
				.LblBreVet.Visible = .T.

				.CntCodTra.Visible = .T.
				.TxtNomTra.Visible = .T.
				.TxtDirTra.Visible = .T.
				.TxtRucTra.Visible = .T.
				.TxtPlaTra.Visible = .T.
				.TxtBreVet.Visible = .T.

		*!*		.TxtCertif.ENABLED = .T.
		*!*		.TxtMarca.ENABLED = .T.
				.CntCodTra.ENABLED = .T.
				.CboCodTra.ENABLED = .T.
				.TxtNomTra.ENABLED = .T.
				.TxtDirTra.ENABLED = .T.
				.TxtRucTra.ENABLED = .T.
				.TxtPlaTra.ENABLED = .T.
				.TxtBreVet.ENABLED = .T.
				.TxtPlaTra.MaxLength = LEN(C_CTRA.PlaTra)
				.TxtBrevet.MaxLength = LEN(C_CTRA.Brevet)

				.CboCodTra.VALUE = C_CTRA.CodTra
				.CntCodTra.VALUE = C_CTRA.CodTra
		*		.CntCodTra.TxtCodigo.InteractiveChange()
				.TxtNomTra.VALUE = C_CTRA.NomTra
				.TxtDirTra.VALUE = C_CTRA.DirTra
				.TxtRucTra.VALUE = C_CTRA.RucTra
				.TxtPlaTra.VALUE = C_CTRA.PlaTra
				.TxtBreVet.VALUE = C_CTRA.BreVet
			ENDWITH

			.CmdImprimir.ENABLED  	= (.xReturn <> "E" AND !.lNuevo AND !GoCfgAlm.lPidMot )
			.CmdPrintGuia.ENABLED	= (.xReturn <> "E" AND !.lNuevo AND  GoCfgAlm.lPidMot )

			.cmdImprimir.Visible  = .cmdImprimir.ENABLED
			.CmdPrintGuia.Visible = .CmdPrintGuia.ENABLED
			IF thisform.ObjRefTran.XsTpoRef = 'G/R' AND ThisForm.xReturn = 'I' AND thisform.ObjRefTran.cTipMov='S'
				thisform.ObjRefTran.XsCodDoc = thisform.ObjRefTran.XsTpoRef
				LsEntidadCorrelativo_act = thisform.ObjRefTran.EntiDadCorrelativo

				thisform.ObjRefTran.CfgVar_ID('VTATDOCM')
				LsValor = thisform.ObjRefTran.Gen_Id('0','VTATDOCM')
				LsCmpRef = 'thisform.PgfDETALLE.PaGE1.Txt'+thisform.ObjRefTran.VarRef+'.Value'
				LsEnabled = 'thisform.PgfDETALLE.PaGE1.Txt'+thisform.ObjRefTran.VarRef+'.Enabled'
				&LsCmpRef = LsValor
				&LsEnabled = .F.
				thisform.ObjRefTran.EntiDadCorrelativo = LsEntidadCorrelativo_act
			ENDIF
			.LockScreen = .F.
		ENDWITH

		RETURN .t.
	ENDPROC


	PROCEDURE desvincular_controles
		WITH THIS.pgfDetalle.PAGES(1).grdDetalle
			.ColumnCount = 8
			.RECORDSOURCE		= ""
			.RECORDSOURCETYPE	= 4
			.REFRESH()
		ENDWITH
	ENDPROC


	PROCEDURE grabar_datos
		LPARAMETER tnTabla , tcOpcion

		LOCAL lnControl
		LnControl = 0
		WITH THIS
			m.Usuario	= goEntorno.USER.Login
			m.Estacion	= goEntorno.USER.Estacion
			m.CodSed	= GoCfgAlm.CodSed
			m.SubAlm    = .CboAlmacen.VALUE
			m.TipMov    = IIF(LEFT(.cboTipMov.VALUE,1)=[T],[S],LEFT(.cboTipMov.VALUE,1))
			m.CodMov    = .CboCodMov.VALUE
			**
			WITH .pgfDetalle.PAGES(1)
				m.NroDoc  = TRIM(.TxtNroDoc.VALUE)
				m.FchDoc  = .TxtFchDoc.VALUE
				*
				m.TpoCmb  = IIF(goCfgAlm.lPidPco OR gocfgalm.lctovta,.TxtTpoCmb.VALUE,0)
				m.CodMon  = IIF(goCfgAlm.lPidPco OR gocfgalm.lctovta,.CboCodMon.VALUE,0)
				m.FmaPgo  = IIF(goCfgAlm.lPidPco OR gocfgalm.lctovta,.CboFmaPgo.ListIndex,0)
				m.CndPgo  = IIF(goCfgAlm.lPidPco OR gocfgalm.lctovta,.CboFmaPgo.Value,'')
				m.NroRf1  = IIF(goCfgAlm.lPidRf1,.TxtNroRf1.VALUE,[ ])
				m.NroRf2  = IIF(goCfgAlm.lPidRf2,.TxtNroRf2.VALUE,[ ])
				m.NroRf3  = IIF(goCfgAlm.lPidRf3,.TxtNroRf3.VALUE,[ ])
				*
				m.CodPro  = IIF(goCfgAlm.lpidPro,.CboCodPro.VALUE,[ ])
				m.CodVen  = IIF(goCfgAlm.lpidVen,.CboCodVen.VALUE,[ ])
				m.CodCli  = IIF(goCfgAlm.lpidCli,.cntCodCli.VALUE,[ ])
				m.CodDire = IIF(goCfgAlm.lpidCli,.CboCodDire.VALUE,[ ])
				m.CodPar  = IIF(goCfgAlm.lpidActFijo,.CboCodPar.VALUE,[ ])
				*

				m.AlmTrf  = IIF(INLIST(LEFT(THISFORM.CboTipMov.VALUE,1),[T],[S]) AND goCfgAlm.Transf ,.CboAlmOri.VALUE,[ ])

				m.AlmOri  = IIF(LEFT(THISFORM.CboTipMov.VALUE,1)=[I] and goCfgAlm.Transf,C_CTRA.AlmOri,[ ])

				goCfgAlm.AlmTrf = m.AlmTrf
				goCfgAlm.AlmOri = m.AlmOri
				*
				m.NroOdt  = IIF(goCfgAlm.lpidOdt,.TxtNroOdt.VALUE,[ ])
				*
				m.CodLote = IIF(goCfgAlm.lModCsm,.CboLotes.VALUE,[ ])
				m.CodCult = IIF(goCfgAlm.lModCsm,.CboCultivo.VALUE,[ ])
				m.CodFase = IIF(goCfgAlm.lModCsm,.CboCodFase.VALUE,[ ])
				m.CodProcs= IIF(goCfgAlm.lModCsm,.CboCodProcs.VALUE,[ ])
				m.CodActiv= IIF(goCfgAlm.lModCsm,.CboCodActiv.VALUE,[ ])
				m.CodPrd  = IIF(goCfgAlm.lModCsm,.CboCodPrd.VALUE,[ ])
				*
				m.Motivo = .CboMotivo.VALUE
				m.Observ  = .TxtObserv.VALUE
			ENDWITH
			**
			WITH .pgfDetalle.PAGES(1)
				m.ImpBrt = .TxtImpBrt.VALUE
				m.ImpIgv = .TxtImpIgv.VALUE
				m.PorIgv = .TxtPorIgv.VALUE
				m.ImpTot = .TxtImpTot.VALUE
			ENDWITH
		    **
			WITH .pgfDetalle.PAGES(3)
				m.CodMat = .TxtCodMat.VALUE
				m.UndStk = .TxtUndStk.VALUE
				m.Candes = .TxtCandes.VALUE
				m.PreUni = .TxtPreUni.VALUE
				m.ImpCto = .TxtImpCto.VALUE
				m.DesMat = .TxtDesMat.VALUE
				m.Lote	 = .TxtLote.VALUE
				m.FchVto = .TxtFchVto.VAlue
				m.Prec_Cif=.TxtPrec_Cif.VAlue
				m.Fact_Imp=.TxtFact_Imp.VAlue
			ENDWITH
			**
			WITH .pgfDetalle.PAGES(1)
				m.CodTra = .CntCodTra.VALUE
				m.NomTra = .TxtNomTra.VALUE
				m.DirTra = .TxtDirTra.VALUE
				m.RucTra = .TxtRucTra.VALUE
				m.PlaTra = .TxtPlaTra.VALUE
				m.Brevet = .TxtBrevet.VALUE
			ENDWITH
		ENDWITH
		*!*	LcTabla = GOCfgAlm.EntidadCorrelativo
		*!*	LcTipMov=this.cbotipmov.value
		*!*	LcCodMov=this.cboCodmov.value
		*!*	LcAlmacen=this.cboAlmacen.value
		 m.TipoOperacion = THISFORM.XRETURN
		DO CASE
			CASE tnTabla == 1		&& Actualizar la Cabecera AlmCtran
				IF THIS.lNuevo   AND  !THIS.lGrabado	    && Es nuevo y no esta grabado
					*** Verificamos Numero Correlativo ***
					WITH THIS.PGFDETALLE.PAGES(1)
						.txtnrodoc.value=correlativo_alm(GOCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,gocfgalm.SubAlm,'0')  
						m.NroDoc = TRIM(.txtnrodoc.value)
					ENDWITH
					** Cabecera **
					m.Nro_Itm = 1
					m.NroItm = 1
					** Cursor Local
					sele C_CTRA
					append blank
					gather MEMVAR MEMO

		*!*				** Detalle **
					** Cursor Local
					sele C_DTRA
		*!*				append blank
					gather memvar
				ELSE
					SELECT * FROM C_DTRA INTO CURSOR XTMP_DETA
					USE IN XTMP_DETA
					m.NroItm = _TALLY
					** Cursor Local
					sele C_CTRA
					gather MEMVAR MEMO

				ENDIF

				*!*	Enviar los datos al Servidor
				lnControl = 1

				*!*	Verificar si se ejecutó correctamente
				IF lnControl > 0
					*!*	generar el LOG para Auditabilidad
					IF m.TipoOperacion == "I"
		*!*					THISFORM.txtNroDoc.VALUE = m.NroDoc
		*!*					THISFORM.GenerarLog("0165",THISFORM.cmdAdicionar.CodigoBoton)
						*!*	En caso de haber generado el PedidoTDV, Generar el LOG, y actualizar controles
						*!*	con el numero de pedido generado, enviar un mensaje con el numero de pedido generado
					ELSE
						IF m.TipoOperacion = "A" AND !THISFORM.lNuevo
		**					THISFORM.GenerarLog("0166",THISFORM.cmdModificar.CodigoBoton)
						ENDIF
						IF m.TipoOperacion = "E"
		**					THISFORM.GenerarLog("0167",THISFORM.cmdEliminar.CodigoBoton)
						ENDIF
					ENDIF
				ENDIF

			CASE tnTabla == 2		&& Actualizar el Detalle AlmDtran
				m.TipoOperacion		= tcOpcion
				do case
					case tcOpcion == "I"	&& Insertar
						** Actualizamos Cursor Local
						update C_CTRA set NroItm = NroItm + 1 
						  
						m.Nro_Itm = C_CTRA.NroItm
						sele C_DTRA
						gather memvar
		*!*					append blank

					case tcOpcion == "A"	&& Actualizar
						sele C_DTRA
						gather memvar 

					case tcOpcion == "E"	&& Eliminar
						m.NroItm = C_DTRA.NroItm
						delete from C_DTRA  ;
						where SubAlm = m.SubAlm AND ;
							  TipMov = m.TipMov AND ;
							  CodMov = m.Codmov AND ;
							  NroDoc = m.NroDoc	AND ;
							  NroItm = m.NroItm
							  
						LnNro_Itm = 0
						SELE C_DTRA
						SCAN
							LnNro_Itm = LnNro_Itm + 1
							REPLACE Nro_Itm WITH LnNro_Itm
						ENDSCAN
						update C_CTRA set nroitm = LnNro_Itm
				endcase
				lnControl = 1

			CASE tnTabla == 4		&& Actualizar el Detalle AlmDtran
				IF THISFORM.Tools.cursor_esta_vacio("C_DTRA")
					LnRpta=MESSAGEBOX('No se ha ingresado datos en el detalle. Desea Continuar?',16+4,'Atención')
					IF LnRpta=7
						RETURN .f.
					ELSE

						THISFORM.PGFDETALLE.PAGES(1).CmdAdicionar1.click
					ENDIF

				ENDIF
				sele C_CTRA
				IF EOF()
					APPEND BLANK
				ENDIF

				gather MEMVAR MEMO
				WITH THIS.PGFDETALLE.PAGES(1)
					IF THISFORM.XRETURN = 'I'
		    			.txtNroDoc.VALUE = correlativo_alm(GoCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.SubAlm,'0')
					ENDIF
					m.NroDoc = TRIM(.txtnrodoc.value)
				ENDWITH
				thisform.objreftran.ccursor_c='C_CTRA' 
				thisform.objreftran.ccursor_d='C_DTRA' 
				IF Thisform.xreturn = 'E' && Eliminar transaccion
					LnControl = Borrar_Transaccion_Alm_X_ALM('A')
				ELSE
		*!*				LnControl = Grabar_transaccion_Alm(gocfgalm.CodSed,gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
					*SET STEP ON 
					LnConTrol =	Grabar_Transaccion_Alm_X_ALM(thisform.objreftran.ccursor_d,thisform.ObjRefTran.XsTpoRef)

					IF thisform.ObjRefTran.XsTpoRef = 'G/R' AND ThisForm.xReturn = 'I' AND thisform.ObjRefTran.cTipMov='S'
						LsValor = 'thisform.PgfDETALLE.PaGE1.Txt'+thisform.ObjRefTran.VarRef+'.Value'
						 thisform.ObjRefTran.Gen_Id(&LsValor.,'VTATDOCM')
					ENDIF
				ENDIF
				* TRANFERENCIAS ENTRE ALMACENES INTERNOS
				*!* VETT
				*!* Determinar TpoRef = [TRA]
				*!* Rutina de proceso para modificar, eliminar cuando es una Transacción  
				WITH THIS
					IF (LEFT(.cboTipMov.VALUE,1) = [T] OR (LEFT(.cboTipMov.VALUE,1) = [S] AND GoCfgAlm.Transf))  AND INLIST(THISFORM.xReturn, [I],[A])
						WITH .pgfDetalle.PAGES(1)
							GoCfgAlm.cTipMov = [I]		   
							GoCfgAlm.AlmOri  = GoCfgAlm.SubAlm
							GoCfgAlm.SubAlm  = GoCfgAlm.AlmTrf
							SELE C_DTRA
							REPLA ALL TipMov WITH GoCfgAlm.cTipMov,AlmOri WITH GoCfgAlm.AlmOri, SubAlm WITH GoCfgAlm.SubAlm, ;
		                     			AlmTrf WITH ''
		                     
							LOCATE
							SELE C_CTRA
							REPLA ALL TipMov WITH GoCfgAlm.cTipMov,AlmOri WITH GoCfgAlm.AlmOri, SubAlm WITH GoCfgAlm.SubAlm , ;
		                    			AlmTrf WITH ''
		                    
							LOCATE
							DO CASE
								CASE THISFORM.xReturn = 'A'
									IF !SEEK(C_CTRA.SubAlm+GoCfgAlm.cTipMov+C_CTRA.CodMov+C_CTRA.NroDoc,'CTRA','CTRA01')
										m.NroDoc =	C_CTRA.NroDoc				 
									ENDIF
									IF !SEEK(C_CTRA.SubAlm+GoCfgAlm.cTipMov+C_CTRA.CodMov+C_CTRA.NroDoc,'DTRA','DTRA01')
										m.NroDoc =	C_CTRA.NroDoc				 
										SELE C_DTRA
										REPLA ALL NroReg WITH 0
										GoCfgAlm.Crear = .T.
									ELSE
										m.NroDoc =	C_CTRA.NroDoc				 
										GoCfgAlm.Crear = .F.
									ENDIF
								CASE THISFORM.xReturn = 'I'
									IF SEEK(C_CTRA.SubAlm+GoCfgAlm.cTipMov+C_CTRA.CodMov+C_CTRA.NroDoc,'CTRA','CTRA01')
										LsNroDocTrf = Correlativo_Alm(GoCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,goCfgAlm.SubAlm,[0])
										m.NroDoc = TRIM(LsNroDocTrf)
									ELSE
										m.NroDoc =	C_CTRA.NroDoc				 
									ENDIF
							ENDCASE 
							LnControl = Grabar_transaccion_Alm(GoCfgAlm.CodSed,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
						ENDWITH     
					ENDIF
				ENDWITH
		ENDCASE
		thisform.PgfDetalle.Page1.TxtNroItm.VALUE = C_CTRA.NroItm
		RETURN lnControl>0
	ENDPROC


	PROCEDURE mantenimiento_detalle
		LPARAMETER tlEnabled
	ENDPROC


	PROCEDURE canciones_pendientes
		&& 'ColdPlay'
		&& 'The scientist'
		&& Eddie Brickell - Good Times
		&& I Try - 

		&& THE CORRS , ONE NIGHT
		&& Se te olvida , Ana Belen
		&& I am falling in love with you ,
		&& ,Donna Summer
		&& I love more than i can say , Leo Sayer
		&& When you remember me, if you remember me,  my love goes with you 
		&& 			, You are my lady
		&& Areta Franklin,  I say a little pray for you
		&& Dr. Hoo , Sharing the night 
		&& ???	   , I just want to dance around you, every day and night , all of my life, 
		&& ??????  , Aquella nube que pasa por el cielo soy yo
		&& aquel barco que pasa mar afuera soy yo
		** aquella hoja que vaga por las calles soy yo buscandote a ti
		** lo que deseo ser es el sol que te quema es la ropa que cubre tu cuerpo
		** es el viento que te posee , es la dalma con que te bañas tu,
		** solo asi podria acercarme a ti , sin poder contestar lo que debo esconder , 
		** por si es que no hay derecho de hacer todo eso y tu sin saber
	ENDPROC


	PROCEDURE calcular_totales
		PRIVATE _ImpBrt, _RegAct
		_ImpBrt = 0
		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
		IF LlHayRegistros
		   SELE c_dtra
		   _RegAct = RECNO()
		   GO TOP
		   SCAN WHILE !EOF()
		        _ImpBrt = _ImpBrt + c_dtra.ImpCto
		   ENDSCAN
		   GO _RegAct
		ENDIF
		*
		WITH THISFORM.pgfDetalle.PAGE1
		     .TxtImpBrt.VALUE = _ImpBrt
		     .TxtImpIgv.VALUE = ROUND(_ImpBrt*.txtPorIgv.VALUE/100,2)
		     .TxtIMpTot.VALUE = .TxtImpBrt.VALUE + .TxtImpIgv.VALUE
		ENDWITH
		*
	ENDPROC


	PROCEDURE limpiar_var
		with thisform.pgfdetalle.page1
			.txtNroDoc.VALUE = []
			.txtFchDoc.VALUE = DATE()  
			.TxtTpoCmb.VALUE = 0
			.TxtObserv.VALUE = []
			.TxtNroRf1.VALUE = []
			.TxtNroRf2.VALUE = []
			.TxtNroRf3.VALUE = []
			.TxtNroOdt.VALUE = []

		    .CboCodPrd.VALUE = []
			.CboCodPro.VALUE = []
		*!*			.TxtCodVen.VALUE = []
			.CboCodVen.Value = []
			.cntCodCli.VALUE = []
			.CboCodDire.VALUE = []
			.CboCodDoc.VALUE  = []
			.CboRuta.Value	= []
		*!*		.CboCodMon.VALUE = 1

		*!*			.CboLotes.VALUE = []
		*!*			.CboCodProcs.VALUE = []
		*!*			.CboCodActiv.VALUE = []
		*!*			.CboCodFase.VALUE = []
		*!*			.CboCultivo.VALUE = []
		*!*			.CboMotivo.VALUE = []
		endwith

		with thisform.pgfdetalle.page1
			.txtPorIgv.VALUE = 0
			.txtImpBrt.VALUE = 0
			.txtImpIgv.VALUE = 0
			.txtImpTot.VALUE = 0
		endwith

		WITH THISFORM.PgfDetalle.PAGES(1)
			** Inicializamos Variables
			.CntCodTra.VALUE = []
			.CboCodTra.VALUE = []
			.TxtNomTra.VALUE = []
			.TxtDirTra.VALUE = []
			.TxtRucTra.VALUE = []
			.TxtPlaTra.VALUE = []
			.TxtBreVet.VALUE = []
		*!*		.TxtMarca.Value	= []
		*!*		.TxtCertif.VALUE= []
		ENDWITH
	ENDPROC


	PROCEDURE habilita_grid
		PARAMETERS LlHabilita
		THISFORM.LockScreen = .T.
		LOCAL kk ,jj
		WITH THISFORM.PgfDetalle.Page1.GrdDetalle
			.Readonly = !LlHabilita
			.AllowCellSelection = LlHabilita
			FOR kk = 1 TO .ColumnCount 
		*!*			IF kk = 1	&& EliItm  Siempre lectura
		*!*				LOOP
		*!*			ENDIF
		*!*			IF kk=2 and !(GoCfgCbd.Tipo_Conso=2  OR GoCfgCbd.Tipo_EMPRE=3  OR GOCFGCBD.C_COSTO=3)
		*!*				LOOP
		*!*			ENDIF
				IF KK=7
					**SET STEP ON 
				ENDIF
				.columns(kk).Readonly = !LlHabilita

				FOR jj = 1 TO .columns[kk].controlcount
		*!*				IF .columns[kk].controls[jj].baseclass = 'Combobox'
						.columns(kk).Enabled = LlHabilita
		*!*				ENDIF
				ENDFOR


		*!*			IF kk = 4  && Help de cuenta
		*!*				.columns(kk).CmdHelpCuenta.Enabled = LlHabilita
		*!*			ENDIF
		*!*			IF kk = 6  && Help de cuenta auxiliar
		*!*				.columns(kk).CmdHelpAuxi.Enabled = LlHabilita
		*!*			ENDIF
		*!*			IF kk = 8  && Help de cuenta auxiliar
		*!*				.columns(kk).CmdHelpAuxi.Enabled = LlHabilita
		*!*			ENDIF


			NEXT
		*!*		WITH THIS.PgfDetalle.Page1
		*!*			.CmdAdicionar1.Enabled = .t. and modificar
		*!*			.CmdModificar1.Enabled = !LlHabilita
		*!*			.Cmdeliminar1.Enabled = !LlHabilita
		*!*			.Cmdgrabar1.Enabled =LlHabilita
		*!*			.CmdCancelar1.Enabled =LlHabilita
		*!*			.Cmdgrabar1.Visible =LlHabilita
		*!*			.CmdCancelar1.Visible  =LlHabilita
		*!*			.LblGrid.Caption = IIF(.grdDetalle.ReadOnly,'Consultando','Modificando')
		*!*			.CmdHelpTeclas.Visible=LlHabilita
		*!*			.CmdHelpTeclas.Enabled=LlHabilita
		*!*	*!*		.CmdDatAdi.Visible=LlHabilita
		*!*		ENDWITH
		*!*		IF LlHabilita
		*!*			.Column3.SetFocus()
		*!*		ELSE
		*!*			this.cmdimprimir.SetFocus
		*!*		ENDIF
		ENDWITH
		THISFORM.LockScreen = .F.
	ENDPROC


	PROCEDURE agrega_item_grid
		WITH thisform.pgfDetalle.page1.grdDetalle
			SELECT (.RecordSource)
			APPEND BLANK
		*!*		REPLACE NroMes WITH XsNroMes
		*!*		replace CodOPe WITH XsCodOpe
		*!*		replace NroAst WITH XsNroAst
		*!*		replace CodMon WITH XiCodMon
		*!*		replace TpoCmb WITH XfTpoCmb
		*!*		REPLACE Glodoc WITH XsGloDoc
		*!*		replace Afecto WITH XcAfecto
		*!*		replace NroItm WITH goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
		*!*		.refresh
			.Column1.txtCodMatGrd.SetFocus()
		ENDWITH
	ENDPROC


	*-- Vicular los campos del detalle
	PROCEDURE vincular_controles_detalle
		DO CASE 
			CASE GsSigCia='PREZCOM'
				WITH THIS.pgfDetalle.PAGES(1).grdDetalle
					IF goCfgAlm.lPidPco OR gocfgalm.lctovta
						.HEADERHEIGHT		= 19
						.RECORDSOURCETYPE	= 1
						.RECORDSOURCE		= "C_DTRA"
						.COLUMNCOUNT   = 8
						.FONTSIZE      = 8


						.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
						.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
						.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndStk"
						.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.PreUni"
						.COLUMNS(6).CONTROLSOURCE = "C_DTRA.ImpCto"
						.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
						.COLUMNS(6).HEADER1.CAPTION = "Importe"
						.COLUMNS(5).WIDTH = 0 && .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = 0 && .COLUMNS(4).WIDTH
						.COLUMNS(7).CONTROLSOURCE = "C_DTRA.Serie"
						.COLUMNS(8).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(7).HEADER1.CAPTION = "# Serie"
						.COLUMNS(8).HEADER1.CAPTION = "Garantia"
						.COLUMNS(7).WIDTH = 100
						.COLUMNS(8).WIDTH = .COLUMNS(4).WIDTH

						IF VARTYPE(.column7.txtserie)='O'
							.COLUMNS(7).Currentcontrol = 'TxtSerie'
						ELSE
							.COLUMNS(7).ADDOBJECT('TxtSerie','Base_Textbox_Serie')
							.COLUMNS(7).Currentcontrol = 'TxtSerie'
							.COLUMNS(7).Enabled			= .T.
							.COLUMNS(7).ReadOnly		= .F.
							.COLUMNS(7).Controls(3).Enabled			= .T.
							.COLUMNS(7).Controls(3).ReadOnly		= .F.

						ENDIF
						.COLUMNS(7).Controls(3).Refresh
						.COLUMNS(7).CONTROLSOURCE = "C_DTRA.Serie"

						*!*				.COLUMNS(9).CONTROLSOURCE = "C_DTRA.Prec_Cif"
						*!*				.COLUMNS(10).CONTROLSOURCE = "C_DTRA.Fact_Imp"
						*!*				.COLUMNS(9).HEADER1.CAPTION = "Precio Cif"
						*!*				.COLUMNS(10).HEADER1.CAPTION = "Fact. Import"
						*!*				.COLUMNS(9).WIDTH = .COLUMNS(4).WIDTH
						*!*				.COLUMNS(10).WIDTH = .COLUMNS(4).WIDTH
					ELSE
						.COLUMNCOUNT   = 6
						.COLUMNS(5).HEADER1.CAPTION = "# Serie"
						.COLUMNS(6).HEADER1.CAPTION = "Garantia"

						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Serie"
						.COLUMNS(6).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						*

					ENDIF
					.AfterRowColChange()
					.REFRESH()
				ENDWITH
			CASE GsSigCia='CAUCHO'
					WITH THIS.pgfDetalle.PAGES(1).grdDetalle
					IF goCfgAlm.lPidPco OR gocfgalm.lctovta

						.RECORDSOURCETYPE	= 1
						.RECORDSOURCE		= "C_DTRA"
						.COLUMNCOUNT   = 8
						.FONTSIZE      = 8
						.HEADERHEIGHT		= 42
						.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
						.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
						.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndVta"
						.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Factor"
						.COLUMNS(6).CONTROLSOURCE = "round(C_DTRA.CanDes*C_DTRA.Factor,2)"  &&"C_DTRA.T_Tramo"
						.COLUMNS(5).HEADER1.CAPTION = "Factor Unidad  Venta"
						.COLUMNS(5).HEADER1.WORDWRAP = .T.
						.COLUMNS(6).HEADER1.CAPTION = "Total"
						.COLUMNS(5).WIDTH = .COLUMNS(5).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(7).CONTROLSOURCE = "C_DTRA.Lote"
						.COLUMNS(8).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(7).HEADER1.CAPTION = "# Lote"
						.COLUMNS(8).HEADER1.CAPTION = "Fch. Vto."
						.COLUMNS(7).WIDTH = 0
						.COLUMNS(8).WIDTH = 0


						*!*				.COLUMNS(9).CONTROLSOURCE = "C_DTRA.Prec_Cif"
						*!*				.COLUMNS(10).CONTROLSOURCE = "C_DTRA.Fact_Imp"
						*!*				.COLUMNS(9).HEADER1.CAPTION = "Precio Cif"
						*!*				.COLUMNS(10).HEADER1.CAPTION = "Fact. Import"
						*!*				.COLUMNS(9).WIDTH = .COLUMNS(4).WIDTH
						*!*				.COLUMNS(10).WIDTH = .COLUMNS(4).WIDTH
					ELSE
						.COLUMNCOUNT   = 6
						.COLUMNS(5).HEADER1.CAPTION = "# Lote"
						.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."

						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Lote"
						.COLUMNS(6).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						*
					ENDIF
					.AfterRowColChange()
					.REFRESH()
				ENDWITH


			OTHER
				WITH THIS.pgfDetalle.PAGES(1).grdDetalle
					IF goCfgAlm.lPidPco OR gocfgalm.lctovta
						.HEADERHEIGHT		= 19
						.RECORDSOURCETYPE	= 1
						.RECORDSOURCE		= "C_DTRA"
						.COLUMNCOUNT   = 8
						.FONTSIZE      = 8
						.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
						.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
						.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndVta"
						.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.PreUni"
						.COLUMNS(6).CONTROLSOURCE = "C_DTRA.ImpCto"
						.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
						.COLUMNS(6).HEADER1.CAPTION = "Importe"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(7).CONTROLSOURCE = "C_DTRA.Lote"
						.COLUMNS(8).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(7).HEADER1.CAPTION = "# Lote"
						.COLUMNS(8).HEADER1.CAPTION = "Fch. Vto."
						.COLUMNS(7).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(8).WIDTH = .COLUMNS(4).WIDTH


						*!*				.COLUMNS(9).CONTROLSOURCE = "C_DTRA.Prec_Cif"
						*!*				.COLUMNS(10).CONTROLSOURCE = "C_DTRA.Fact_Imp"
						*!*				.COLUMNS(9).HEADER1.CAPTION = "Precio Cif"
						*!*				.COLUMNS(10).HEADER1.CAPTION = "Fact. Import"
						*!*				.COLUMNS(9).WIDTH = .COLUMNS(4).WIDTH
						*!*				.COLUMNS(10).WIDTH = .COLUMNS(4).WIDTH
					ELSE
						.COLUMNCOUNT   = 6
						.COLUMNS(5).HEADER1.CAPTION = "# Lote"
						.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."

						.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Lote"
						.COLUMNS(6).CONTROLSOURCE = "C_DTRA.FchVto"
						.COLUMNS(5).WIDTH = .COLUMNS(4).WIDTH
						.COLUMNS(6).WIDTH = .COLUMNS(4).WIDTH
						*
					ENDIF
					.AfterRowColChange()
					.REFRESH()
				ENDWITH
		ENDCASE
		WITH thisform.PgfDetalle.Page1
			.cmdAdicionar1.ENABLED	= .T.
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
			.cmdModificar1.ENABLED	= LlHayRegistros
			.cmdEliminar1.ENABLED	= LlHayRegistros
		ENDWITH
	ENDPROC


	PROCEDURE validitemlote
		LOCAL LcCodMat,LcSubAlm,LfCandes,LdFecha ,LcCursor, LnError, LcLote

		LcCodMat=THIS.PGfDetalle.PAge3.TXtCodmat.Value
		LcLote  =THIS.PGfDetalle.PAge3.TxtLote.Value
		LcSubAlm=gocfgalm.SubAlm
		LdFecha	=THIS.PGfDetalle.PAge1.txtFchDoc.Value
		LfCandes=THIS.PGfDetalle.PAge3.TxtCandes.Value
		LcCursor='C_Lote' 
		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validacodigoalmacenlote(LcCodMat,LcSubAlm,GsCodSed,LfCandes,LdFecha,LcCursor,LcLote)
		RELEASE ov
		RETURN LnError
	ENDPROC


	PROCEDURE Init
		LPARAMETERS Pc_Tipmov,Pc_CodMOv,Pc_SubAlm,Pc_Filtro_Mov,Pl_SelAlm
		DODEFAULT()
		LnParms=PARAMETERS()
		IF VARTYPE(Pc_Filtro_Mov)='C'
			this.CboCodMov.cWhereSql = " AND TpoRf1='"+Pc_Filtro_Mov+"'"
			this.lfiltro_Mov = .T.
		ELSE
			Pc_Filtro_Mov = ''
		ENDIF
		IF VARTYPE(Pc_Tipmov)='C'
			THIS.OBJREFTRAN.cTipMov	=	Pc_Tipmov
			THIS.CBOTipMov.Value 	=	Pc_Tipmov
			THIS.lTipMov 			=	IIF(!EMPTY(Pc_Tipmov),.T.,.F.)
			this.CboTipMov.InteractiveChange() 
		ELSE
			thisform.CboTipMov.InteractiveChange() 
		ENDIF
		IF VARTYPE(Pc_Codmov)='C'
			IF !EMPTY(Pc_CodMov)
				THIS.OBJREFTRAN.sCodMov	=	Pc_CodMov
				this.CboCodMov.Value	=	Pc_CodMov
			ENDIF
			THIS.lCodMov 			=	IIF(!EMPTY(Pc_CodMov) AND EMPTY(Pc_Filtro_Mov),.T.,.F.)
		ENDIF
		IF VARTYPE(Pc_SubAlm)='C'
			THIS.OBJREFTRAN.SubAlm	=	Pc_SubAlm
			this.CboAlmacen.Value	=	Pc_SubAlm
			THIS.lSubAlm			=	IIF(!EMPTY(Pc_SubAlm),.T.,.F.)
		ELSE
			THIS.CboAlmacen.Value = GsSubAlm 
		ENDIF
		this.Caption = This.Caption + " - "+Mes(_Mes,3)+" "+TRANS(_ANO,"9999 ")

		thisform.AddProperty('LlSelAlm',Pl_SelAlm) 

		THISFORM.INICIAR_VAR()
	ENDPROC


	PROCEDURE Load
		DODEFAULT()
		=goCfgAlm.Abrir_dbfs_alm()
	ENDPROC


	*-- Activa los controles de origen de datos segun configuración
	PROCEDURE activar_controles
	ENDPROC


	PROCEDURE cmdiniciar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		THISFORM.INICIAR_VAR()
	ENDPROC


	PROCEDURE cmdadicionar1.Click
		thisform.CmdGrabar.Visible = .f.
		thisform.pgfDetalle.page1.cmdAdicionar1.Visible  = .F.
		thisform.pgfDetalle.page1.cmdmodificar1.Visible = .F.
		thisform.pgfDetalle.page1.cmdEliminar1.Visible = .F.
		thisform.pgfDetalle.page1.cmdaceptar2.Visible  = .T.
		thisform.pgfDetalle.page1.cmdcancelar2.Visible = .T.
		thisform.pgfDetalle.page1.cmdaceptar2.Enabled  = .T.
		thisform.pgfDetalle.page1.cmdcancelar2.Enabled = .T.
		thisform.LcTipOpe = 'I'  
		thisform.CboAlmacen.Enabled =   thisform.LlSelAlm && 

		thisform.habilita_grid(.T.)
		thisform.agrega_item_grid() 
		*!*	IF !THIS.ACTIVADO()
		*!*		RETURN
		*!*	ENDIF
		*!*	THISFORM.PgfDetalle.page2.ENABLED	= .F.
		*!*	THISFORM.PgfDetalle.ACTIVEPAGE	= 3
		*!*	WITH THIS.PARENT.PARENT.PAGES(1)
		*!*		.TxtFchDoc.ENABLED = .F.
		*!*		.TxtTpoCmb.ENABLED = .F.
		*!*		.CboCodMon.ENABLED = .F.
		*!*	ENDWITH
		*!*	thisform.CboAlmacen.ENABLED = .F.
		*!*	thisform.CboTipMov.ENABLED = .F.
		*!*	thisform.CboCodMov.ENABLED = .F.

		*!*	WITH THISFORM.PgfDetalle.PAGES(3)
		*!*		** Inicializamos Variables
		*!*		.TxtCodMat.VALUE = SPACE(LEN(C_DTRA.Codmat))
		*!*		.TxtDesMat.VALUE = SPACE(LEN(C_DTRA.DesMat))
		*!*		.TxtUndStk.VALUE = SPACE(LEN(C_DTRA.UndStk))
		*!*		.TxtLote.VALUE		= SPACE(LEN(C_DTRA.Lote))
		*!*		.TxtFchVto.VALUE	= DATE()
		*!*
		*!*		.TxtCanDes.VALUE = 0.00
		*!*		.TxtPreUni.VALUE = 0.00
		*!*		.TxtImpCto.VALUE = 0.00
		*!*		** Habilitamos las variables
		*!*		.TxtCodMat.ENABLED = .T.
		*!*		.TxtCanDes.ENABLED = .T.
		*!*		.TxtPreUni.ENABLED = .T.
		*!*		.TxtImpCto.ENABLED = .T.
		*!*		.TxtLote.ENABLED	= .t.
		*!*		.TxtFchVto.ENABLED	= .t.
		*!*		.TxtPrec_Cif.ENABLED = .T.
		*!*		.TxtFact_Imp.ENABLED = .T.

		*!*		.cmdAceptar2.ENABLED			= .F.
		*!*		.cmdCancelar2.ENABLED			= .T.
		*!*		.TxtCodmat.MaxLength = GaLenCod(3) 
		*!*		.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod(3)-GnLenDiv)
		*!*		.CmdHelpCodMat.ENABLED = .T.
		*!*		.CmdHelpLote.ENABLED = .T.
		*!*		.TxtCodMat.SETFOCUS()
		*!*	ENDWITH
	ENDPROC


	PROCEDURE cmdmodificar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		thisform.CmdGrabar.Visible = .f.
		thisform.pgfDetalle.page1.cmdAdicionar1.Visible  = .F.
		thisform.pgfDetalle.page1.cmdmodificar1.Visible = .F.
		thisform.pgfDetalle.page1.cmdEliminar1.Visible = .F.
		thisform.pgfDetalle.page1.cmdaceptar2.Visible  = .T.
		thisform.pgfDetalle.page1.cmdcancelar2.Visible = .T.
		thisform.pgfDetalle.page1.cmdaceptar2.Enabled  = .T.
		thisform.pgfDetalle.page1.cmdcancelar2.Enabled = .T.
		thisform.CboAlmacen.Enabled =   thisform.LlSelAlm && 

		thisform.habilita_grid(.T.)
		thisform.LcTipOpe = 'A'  				&& Actualizar item en el detalle
		IF thisform.Modo_edit_detalle = 1
		ELSE
			THISFORM.PgfDetalle.Page2.Enabled = .F.
			THISFORM.PgfDetalle.ACTIVEPAGE	= 3
			WITH THISFORM.PgfDetalle.PAGES(3)

				** Habilitamos las variables
				.TxtCodMat.ENABLED = .T.
				.TxtCandes.ENABLED = .T.
				.TxtPreUni.ENABLED = .T.
				.TxtImpCto.ENABLED = .T.
				.TxtLote.ENABLED = .T.
				.TxtFchVto.ENABLED	= .T.
				.TxtPrec_Cif.ENABLED = .T.
				.TxtFact_Imp.ENABLED = .T.


				.cmdAceptar2.ENABLED			= .T.
				.cmdCancelar2.ENABLED			= .T.

				.TxtCodMat.SETFOCUS()
			ENDWITH
		ENDIF


		**
	ENDPROC


	PROCEDURE cmdeliminar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		IF MESSAGEBOX("¿Desea Eliminar el item del detalle?",32+4+256,"Eliminar") <> 6
			RETURN
		ENDIF
		m.Usuario			= goEntorno.USER.Login
		m.Estacion			= goEntorno.USER.Estacion
		thisform.LcTipOpe = 'E'  				&& Agregar item en el detalle

		*!*	THISFORM.ocnx_ODBC.cSQl = "EXEC " + THISFORM.Tabla("funalm_almdtran") + " " + ;
		*!*		"@CodigoCliente = ?m.CodigoCliente , " + ;
		*!*		"@CodigoAsociacion = ?m.CodigoAsociacion , " + ;
		*!*		"@Usuario = ?m.Usuario , " + ;
		*!*		"@Estacion = ?m.Estacion , " + ;
		*!*		"@TipoOperacion = 'E'"
		*!*	THISFORM.ocnx_ODBC.cCursor = ""
		*!*lnControl = THISFORM.ocnx_ODBC.DoSQL()
		*!*	DELETE FROM ALMDTRAN WHERE  ;
		*!*				SubAlm=m.SubAlm AND ;
		*!*				TipMov=m.TipMov AND ;
		*!*				CodMov=m.CodMov AND ;
		*!*				NroDoc=m.NroDoc AND ;
		*!*				NroItm=m.NroItm

		LnControl = 1
		IF lnControl > 0
			SELECT C_DTRA
			=gocfgalm.borra_registro_local_detalle()
		*!*		DELETE
		*!*		GO TOP
		**	THISFORM.GenerarLog("0397",THIS.CodigoBoton)
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
			* 
		    * CALCULO TOTALES DEL DOCUMENTO
		    *
		    IF goCfgAlm.lpidpco
		       THISFORM.Calcular_Totales
		    ENDIF
		    *
		*!*	    WITH THISFORM.PgfDetalle.Page2
		    WITH THISFORM.PgfDetalle.Page1
				.GrdDetalle.REFRESH()
				.CmdModificar1.ENABLED = LlHayRegistros
				.CmdEliminar1.ENABLED  = LlHayRegistros
			ENDWITH
			THISFORM.CmdIMprimir.ENABLED = LlHayRegistros
			THISFORM.CmdPrintGuia.ENABLED = (LlHayRegistros and GoCfgAlm.lPidMot)
		ENDIF
	ENDPROC


	PROCEDURE txtfchvto.Valid
		IF !EMPTY(this.Value)  AND MONTH(this.Value)<> _mes  
			=MESSAGEBOX('La fecha no corresponde al mes de proceso seleccionado',16,'¡Atencion!' )  
			RETURN .F.
		ENDIF
		IF (GoCfgAlm.lPidPco or GoCfgAlm.lCtoVta) AND GoCfgAlm.crear  
			THIS.PARENT.TxtTpoCmb.Value=gocfgalm.oentorno._tipocambio(this.value,this.Parent.TxtTpoCmb.value,thisform.xReturn)
		ENDIF
	ENDPROC


	PROCEDURE txtfchdoc.Valid
		IF !EMPTY(this.Value)  AND MONTH(this.Value)<> _mes  
			=MESSAGEBOX('La fecha no corresponde al mes de proceso seleccionado',16,'¡Atencion!' )  
			RETURN .F.
		ENDIF
		IF (GoCfgAlm.lPidPco or GoCfgAlm.lCtoVta) AND GoCfgAlm.crear  
			THIS.PARENT.TxtTpoCmb.Value=gocfgalm.oentorno._tipocambio(this.value,this.Parent.TxtTpoCmb.value,thisform.xReturn)
		ENDIF
	ENDPROC


	PROCEDURE txtnrorf1.Valid
		IF !EMPTY(THIS.VALUE)
			IF !thisform.Vincular_Controles()
				MESSAGEBOX('Nro. de documento invalido',16,'Verificar')
				RETURN .f.
			endif
		ENDIF
	ENDPROC


	PROCEDURE txtnrorf2.Valid
		IF EMPTY(this.Value)
			RETURN 
		ENDIF
		DO CASE 
			CASE this.Parent.cboCodDoc.Value = 'FACT' AND thisform.xreturn="I"
				*!*	Colocar Código si Viene de Factura
			CASE this.Parent.CboCodDoc.Value = 'PEDI' AND thisform.xreturn="I"

				LOCAL LsCodDoc AS String , LsNroO_C AS String, LsCmpRef As String

				thisform.ObjRefTran.XsTpoRfb = this.Parent.CboCodDoc.Value
				thisform.ObjRefTran.XsNroRfb = THIS.Value

				LsCodDoc    = thisform.ObjRefTran.XsTpoRfb
				LsValorPK	= thisform.ObjRefTran.XsNroRfb && Llave de la tabla CodDoc+NroDoc
				LsCursor	= thisform.pgfDetalle.page1.GrdDetalle.RecordSource 
				LsCursorSeleccionados = this.Parent.cmdHelpNroRef_Multi.caliasCursorSeleccionados
				LsCursorSeleccionados = IIF(USED(LsCursorSeleccionados) AND !EOF(LsCursorSeleccionados), LsCursorSeleccionados ,'')
				LsValorPkSeleccionados = '' && LsCodDoc
				LsCampoCursorSeleccionados = THIS.parent.cmdHelpNroRef_Multi.ccamporetorno
				thisform.Objreftran.cCursor_D = LsCursor
				thisform.Objreftran.pCargaG_D('RPED',;
											'VTARPEDI',;
											'NRODOC',;
											LsValorPK,;
											'RPED01',;
											'',;
											'',;
											LsCursor,;
											'',;
											thisform.DataSessionId,;
											'VPED',;
											'VTAVPEDI',;
											'VPED01',; 
											LsCursorSeleccionados,;
											'NRODOC',;
											LsValorPkSeleccionados,;
											LsCampoCursorSeleccionados)
				**
				lcurarea = ALIAS()
				SELECT (lsCursor)
				GO TOP 
				SCAN 
					IF !SEEK(SubAlm+CODMAT,[CALM],[CATA01])
						DELETE 
					ENDIF 
				endscan 
				GO TOP 
				SELECT (lcurarea)
				**
		*!*			IF EMPTY(this.Parent.CboCodPro.Value) 
		*!*				this.Parent.CboCodPro.Value = THISform.ObjRefTran.sCodPro
		*!*				this.Parent.CboCodPro.TxtCodigo.InteractiveChange()
		*!*			ENDIf

		*!*			THIS.Parent.TxtTpoCmb.Value =  THISform.ObjRefTran.fTpoCmb
		*!*			THIS.Parent.CboCodMon.Value =  THISform.ObjRefTran.nCodMon
		*!*			This.Parent.CboCodFre.Value =  THISFORM.Objreftran.sCodFre  

		*!*			IF !EMPTY(THISFORM.ObjRefTran.XsCndPgo)
		*!*				this.Parent.CboFmaPgo.Value = THISFORM.ObjRefTran.XsCndPgo
		*!*				this.parent.CboFmaPgo.Valid()
		*!*			ENDIf

		*		thisform.PgfDetalle.Page2.GrdDetalle.SetFocus
				thisform.Calcular_totales()
				WITH thisform.pgfDetalle.Page1
					GO TOP IN (.grdDetalle.RecordSource)
					.grdDetalle.Refresh
					.grdDetalle.AfterRowColChange()
					.cmdAdicionar1.ENABLED	= .F.
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(.grdDetalle.RecordSource)
					.cmdModificar1.ENABLED	= LlHayRegistros
					.cmdEliminar1.ENABLED	= .F. && LlHayRegistros

				ENDWITH 
				thisform.LNuevo = .F.

		ENDCASE 
	ENDPROC


	PROCEDURE txtnrodoc.Valid
		IF !EMPTY(THIS.VALUE)
			IF !thisform.Vincular_Controles()
				MESSAGEBOX('Nro. de documento invalido',16,'Verificar')
				RETURN .f.
			endif
		ENDIF
	ENDPROC


	PROCEDURE cbofmapgo.Valid
		LsValorCampo = EVALUATE(this.caliascursor+'.'+this.ccamporetorno)
		LnOk= thisform.ObjRefTran.odatadm.gencursor('C_FMAPGO_ACT',this.cnombreentidad,'',this.ccamposfiltro+'+'+this.ccamporetorno ,this.cvaloresfiltro+LsValorCampo  )
		IF LnOk>0
			LsDiaVTo = 'C_FMAPGO_ACT'+'.DiaVto'
			LsCodigo = 'C_FMAPGO_ACT'+'.Codigo'
			this.Parent.TxtCndPgo.Value =   EVALUATE(LsCodigo)
			this.Parent.SpnDiaVto.Value =   EVALUATE(LsDiaVTo)
			LdFchDoc = IIF(VARTYPE(this.Parent.txtFchDoc.Value)='T',TTOD(this.Parent.txtFchDoc.Value),this.Parent.txtFchDoc.Value)
			this.Parent.TxtFchVto.Value = 	LdFchDoc + this.Parent.SpnDiaVto.Value
			    
		ENDIF
	ENDPROC


	PROCEDURE cbocodprocs.InteractiveChange

		THIS.PARENT.cboCodActiv.cValoresFiltro=this.parent.CboCodFase.Value+";"+THIS.VALUE
		THIS.PARENT.cboCodActiv.GenerarCursor()
		THIS.PARENT.cboCodActiv.VALID()
	ENDPROC


	PROCEDURE cboalmori.InteractiveChange
		thisform.ObjRefTran.AlmTrf=THIS.Value
	ENDPROC


	PROCEDURE cbocoddoc.InteractiveChange
		**=goCfgVta.Abrir_Dbfs_Vta(this.value)
		IF !EMPTY(this.Value)
			this.Parent.CmdHelpNroRef_Multi.Visible = .T. 
		ENDIF
	ENDPROC


	PROCEDURE cbocoddoc.Valid
		*** Capturamos el tipo de movimiento de almacen segun sea FACT/BOLE *** 
		*** Para efectos de configuracion de almacen las salidas x FACTura/BOLEta son indenticas ***
		IF !EMPTY(THIS.Value) AND INLIST(THIS.VALUE,'FACT','BOLE')
			LOCAL LlCerrarCDOC As Boolean ,LsOrderCDOC AS String 
			LlCerrarCDOC = .F.
			IF !USED('CDOC')
				THISFORM.ObjReftran.oDatAdm.AbrirTabla('ABRIR','ALMCDOCM','CDOC','CDOC02','')
			ELSE
				LsOrderCDOC	= ORDER('CDOC')
				SELECT CDOC
				SET ORDER TO CDOC02
				SEEK trim(this.Value)
				IF FOUND()
					thisform.CboCodMov.Value = CDOC.CodMov 
					thisform.CboCodMov.Valid()
				ENDIf
			ENDIF

		ENDIF
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.When
		IF !USED(this.PARENT.Cnombreentidad)
			USE (this.PARENT.Cnombreentidad) again IN 0
		ENDIF
		IF EMPTY(this.Value)
			RETURN .t.
		ENDIF
		LOCAL lExisteClie
		SELECT (this.PARENT.Cnombreentidad)
		LOCATE FOR CodAux=THIS.VAlue
		this.Parent.Parent.txtRucAux.Value = NroRuc
		this.Parent.Parent.chkRetencion.Value = Rete 
		lExisteClie = FOUND()
		IF lExisteClie
			LsValorFiltro=This.Parent.cNombreentidad+'.CoDcli' 
			this.Parent.Parent.cboCodDire.cValoresfiltro = EVALUATE(LsValorFiltro)
			this.Parent.Parent.CboCodDire.generarcursor() 
		ENDIF
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.Valid

		DODEFAULT()
		IF EMPTY(this.Value)
			RETURN 
		ENDIF

		*!*	M.ERR=thisform.ValidCliente()

		*!*	IF m.err<0
		*!*		thisform.MensajeErr(m.err)
		*!*		RETURN .f.
		*!*	ENDIF
		thisform.ObjRefTran.XsCodCli = this.Value 
		*this.parent.txtdirAux.value=EVALUATE(this.PARENT.c_validCliente+'.DesDire')

		*!*	this.PARENT.parent.txtrucAux.Value=EVALUATE(this.PARENT.parent.C_validCliente+'.CodAux')
		*!*	this.PARENT.Parent.cmdHELPNROREF.ccamposfiltro  = [FlgEst;CodCli]
		*!*	this.PARENT.Parent.cmDHELPNROREF.cvaloresfiltro = thisform.ObjRefTran.XcFlgEst_Ref+';'+thisform.objreftran.XsCodCli
		this.InteractiveChange() 
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.InteractiveChange
		IF !USED(this.PARENT.Cnombreentidad)
			USE (this.PARENT.Cnombreentidad) again IN 0
		ENDIF
		LOCAL lExisteClie
		SELECT (this.PARENT.Cnombreentidad)
		LOCATE FOR CodAux=THIS.VAlue
		this.Parent.Parent.txtRucAux.Value = NroRuc
		this.Parent.Parent.chkRetencion.Value = Rete 
		**lExisteClie=SEEK(THIS.Value,this.PARENT.Cnombreentidad,'CLIEN01')
		LsCmpCodVen=This.Parent.cNombreentidad+'.CoDVen'
		this.Parent.Parent.CboCodVen.Value = EVALUATE(LsCmpCodVen)

		lExisteClie = FOUND()
		IF lExisteClie
			LsValorFiltro=This.Parent.cNombreentidad+'.CoDcli' 
			this.Parent.Parent.cboCodDire.cValoresfiltro = EVALUATE(LsValorFiltro)
			this.Parent.Parent.CboCodDire.generarcursor() 
			this.Parent.Parent.TxtDirEnt.Value =  IIF(SEEK(EVALUATE(LsValorFiltro)+'002','CCTCDIRE','DIRE01'),CCtCdire.DesDire,SPACE(LEN(CCtCdire.DesDire)))
		ELSE

		ENDIF
	ENDPROC


	PROCEDURE cmdhelpnrodoc.Click
		WITH this.Parent.Parent.Parent
			GocfgAlm.SubAlm = .cboAlmacen.value
			GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
			GoCfgAlm.sCodMov=.cboCodmov.value
		endwith
		IF THISFORM.ObjRefTran.XsTpoRef='G/R'
			GoCfgAlm.XsTpoRef = PADR(THISFORM.ObjRefTran.XsTpoRef,LEN(CTRA.TpoRf1))
			GoCfgAlm.sNroRf1 = trim(this.Parent.TxtNroRf1.Value)
			this.ccamposfiltro  = [TpoRf1;NroRf1]
			this.cvaloresfiltro = GoCfgAlm.XsTpoRef+";"+GoCfgAlm.sNroRf1
		    this.ccamporetorno  = [NroRf1]
		    this.cWheresql = this.cWhereSql + " AND TIPMOV+CodMov='"+GoCfgAlm.cTipMov+GoCfgAlm.sCodMov+"'"
			DODEFAULT()
			this.Parent.TxtNroRf1.Value = this.cvalorvalida 
			this.Parent.TxtNroRf1.SetFocus
			IF !EMPTY(this.Parent.TxtNroRf1.Value)
				KEYBOARD '{END}'+'{ENTER}'
			ENDIF
		ELSE
			GoCfgAlm.sNroDoc = trim(this.Parent.TxtNroDoc.Value)
			this.cvaloresfiltro = GocfgAlm.SubAlm+";"+GoCfgAlm.cTipMov+";"+GoCfgAlm.sCodMov+";"+GoCfgAlm.sNroDoc
		    this.ccamporetorno  = [NroDoc]
			DODEFAULT()
			this.Parent.TxtNroDoc.Value = this.cvalorvalida 
			this.Parent.TxtNroDoc.SetFocus
			IF !EMPTY(this.Parent.TxtNroDoc.Value)
				KEYBOARD '{END}'+'{ENTER}'
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE cbolotes.InteractiveChange
		THIS.PARENT.cboCultivo.cValoresFiltro=GsCodSed+";"+THIS.VALUE
		THIS.PARENT.cboCultivo.GenerarCursor()
	ENDPROC


	PROCEDURE cmdprocesar1.Click
		THIS.parent.cntCodCli.value = IIF(THIS.parent.cntCodCli.value='N/A','',THIS.parent.CntCodCli.value)
		THIS.parent.CboCodVen.value = IIF(THIS.parent.CboCodVen.value='N/A','',THIS.parent.CboCodVen.value)
		THIS.parent.CboRuta.value 	= IIF(THIS.parent.CboRuta.value='N/A','',THIS.parent.CboRuta.value)
		LsCodDoc	=	THIS.Parent.CboCodDoc.Value
		LsTpoDoc	=	IIF(SEEK(this.Parent.CboCodDoc.Value,'SISTDOCS','DOC01'),SISTDOCS.TpoDoc,'')
		LsTituloDoc	=	this.Parent.CboCodDoc.DisplayValue 

		LsCamposFiltro =''
		LsValoresFiltro = ''

		*!*	IF !EMPTY(thisform.ObjRefTran.XsTpoRef)
		*!*		LsCamposFiltro = LsCamposFiltro +  'TpoRef' +	'+'
		*!*		LsValoresFiltro = LsValoresFiltro + thisform.ObjRefTran.XsTpoRef + '+'
		*!*	ENDIF
		IF !EMPTY(THIS.parent.cntCodCli.value )
			LsCamposFiltro = LsCamposFiltro +  'CodCli' +	'+'
			LsValoresFiltro = LsValoresFiltro + THIS.parent.cntCodCli.value + '+'
		ENDIF
		IF !EMPTY(THIS.parent.CboCodVen.value )
			LsCamposFiltro = LsCamposFiltro +  'CodVen' + '+'
			LsValoresFiltro = LsValoresFiltro + THIS.parent.CboCodVen.value + '+'
		ENDIF
		IF !EMPTY(THIS.parent.CboRuta.value )
			LsCamposFiltro = LsCamposFiltro +	'Ruta'	+	'+' 
			LsValoresFiltro = LsValoresFiltro + THIS.parent.CboRuta.value + '+'
		ENDIF
		IF !EMPTY(ThisForm.Objreftran.Xcflgest_ref )
			LsCamposFiltro = LsCamposFiltro +	'FlgEst'	+	'+' 
			LsValoresFiltro = LsValoresFiltro + ThisForm.Objreftran.Xcflgest_ref  + '+'
		ENDIF
		 

		LnPosCmp	= RAT('+',LsCamposFiltro)
		LnLenCmp	= LEN(LsCamposFiltro)
		LnPosVal	= RAT('+',LsValoresFiltro)
		LnLenVal	= LEN(LsValoresFiltro)
		LlSigCmp	= (LnPosCmp=LnLenCmp AND LnPosCmp>0)
		LlSigVal	= (LnPosVal=LnLenVal AND LnPosVal>0)

		LsCamposFiltro = IIF(LLSigCmp ,SUBSTR(LsCamposFiltro,1,LnLenCmp-1),LsCamposFiltro)
		LsValoresFiltro = IIF(LLSigVal,SUBSTR(LsValoresFiltro,1,LnLenVal-1),LsValoresFiltro)

		DO CASE 
			CASE INLIST(LsCodDoc , 'FACT','BOLE') 


				LsCamposPK	= 'CODDOC+NRODOC'
				LsValorPK	= LsCodDoc
				*** INI:VETT 2006-12-19
				*** Cambiamos los parametros para mostras todas las FACT y BOLE Pendientes de generar G/R
				LsCamposPK	=	'FLGEST'
				LsValorPK	=	ThisForm.ObjReftran.XcFlgEst_ref
				LsIndicePK	= 	'VFAC07'	  && FLGEST+CODCLI+CODDOC+NRODOC
				LsCamposFiltro = ''
				LsValoresFiltro = ''
				LsTituloDoc	=	'Documentos sin guia remision'
				*** FIN:VETT 2006-12-19
				thisform.ObjRefTran.cargar_guia_enbasea_docs('VFAC','VTAVFACT', ; 
									LsCamposPK, ;
									LsValorPK,;
									LsIndicePK,;
									LsCamposFiltro,;
		  							LsValoresFiltro,;
										'AUXI')

				THISFORM.ObjCntRef.LblTitulo.Caption = LsTituloDoc
				THISFORM.ObjCntRef.Iniciar_var()
				THISFORM.ObjCntRef.Visible = .t.
				THISFORM.ObjCntRef.Enabled = .t.

		*		thisform.ObjRefTran.cargar_guia_detalle_enbasea_docs(LsCodDoc,'VFAC','ITEM','VFAC01','ITEM01')  

			CASE INLIST(LsCodDoc , 'PEDI','PROF')

		ENDCASE 
	ENDPROC


	PROCEDURE txtporigv.LostFocus
		IF goCfgAlm.lpidpco
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE cmdhelp_codmat.Click
		WITH this.Parent.Parent.Parent
		*!*		GocfgAlm.SubAlm = .cboAlmacen.value
		*!*		GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
		*!*		GoCfgAlm.sCodMov=.cboCodmov.value
		ENDWITH

		this.cvaloresfiltro = GocfgAlm.SubAlm
		DODEFAULT()
		thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value = this.cvalorvalida
		IF EMPTY(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		IF THISFORM.lNuevo AND !THISFORM.lGrabado
			lnOk = MESSAGEBOX("Para proseguir con esta opción deberá grabar el Documento " + CHR(13) + ;
				"¿ Desea grabar en este momento y proseguir ?" , 4+32+256 , "¿ Grabar Datos ?" )
			IF lnOk <> 6
				RETURN
			ENDIF
			WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
			THISFORM.lGrabado	= THISFORM.Grabar_Datos(1,'I')
			WAIT CLEAR

			IF !THISFORM.lGrabado
				=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
				RETURN
			ENDIF

			THISFORM.lNuevo	= .F.
			WAIT CLEAR
		ELSE
			WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
			IF !THISFORM.Grabar_Datos(2,THISFORM.LcTipOpe)
				=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
				RETURN
			ENDIF
			WAIT CLEAR
		ENDIF

		thisform	.cmdGrabar.Enabled  = .t.
		IF EMPTY(C_DTRA.CodMat)
			this.Parent.CmdCancelar2.Click 
		ENDIF

		*
		* CALCULO TOTALES DEL DOCUMENTO
		*
		IF goCfgAlm.lpidpco
			THISFORM.Calcular_Totales
		ENDIF
		*

		this.Parent.CmdCancelar2.Visible = .f.
		this.Visible = .f. 
		thisform.CmdGrabar.Visible = .T.
		THIS.PARENT.cmdCancelar2.CLICK()
	ENDPROC


	PROCEDURE cmdcancelar2.Click
		WITH thisform.pgfDetalle.page1.grdDetalle 
			SELECT (.RecordSource)
			IF EMPTY(.Column1.TxtCodMatGrd.Value) &&OR (thisform.LcTipOpe = 'I' AND !EMPTY(.Column1.TxtCodMatGrd.Value))
				DELETE
				IF !EOF()
					GO bott
				ENDIF
				.refresh
				.Column1.SetFocus() 
			ENDIF
		ENDWITH


				WITH THIS.PARENT.PARENT
				*!*	*!*		.PAGES(1).ENABLED	= .T.
				*!*	*!*		.ACTIVEPAGE	= 1
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio('C_DTRA')
					.PAGES(1).cmdAdicionar1.Visible	= .t. and !INLIST(thisform.ObjRefTran.XsTpoRfb,'FACT','BOLE')
					.PAGES(1).cmdModificar1.Visible	= .t.
					.PAGES(1).cmdEliminar1.Visible	= .t. 

					.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros 
					.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros and !INLIST(thisform.ObjRefTran.XsTpoRfb,'FACT','BOLE')
					with thisform
						.cmdImprimir.ENABLED	= LlHayRegistros
						.CmdPrintGuia.ENABLED = (LlHayRegistros and GoCfgAlm.lPidMot)
					endwith 

					.PAGES(1).GrdDetalle.ReadOnly = .T. 
					.PAGES(1).GrdDetalle.AllowCellSelection = .F.
					.PAGES(1).grdDetalle.REFRESH()
					.PAGES(1).grdDetalle.SETFOCUS()
				ENDWITH
				IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
				   THISFORM.Calcular_Totales
				ENDIF
		this.Parent.Cmdaceptar2.Visible = .f.
		this.Visible = .f. 
		thisform.CmdGrabar.Visible = .T.
		*!*	*!*	WITH THIS.PARENT.PARENT.PAGES(3)
		*!*	*!*		*** Deshabilitar Controles
		*!*	*!*		.CmdHelpCodMat.ENABLED = .F.
		*!*	*!*		.CmdHelpLote.ENABLED = .F.
		*!*	*!*		.TxtCodMat.ENABLED = .F.
		*!*	*!*		.TxtCanDes.ENABLED = .F.
		*!*	*!*		.TxtPreUni.ENABLED = .F.
		*!*	*!*		.TxtImpCto.ENABLED = .F.
		*!*	*!*		.txtLote.ENABLED	= .f.
		*!*	*!*		.txtFchVto.ENABLED	= .f.
		*!*	*!*		.TxtPrec_Cif.ENABLED = .F.
		*!*	*!*		.TxtFact_Imp.ENABLED = .F.
		*!*	*!*
		*!*	*!*		.cmdAceptar2.ENABLED	= .F.
		*!*	*!*		.cmdCancelar2.ENABLED	= .F.
		*!*	*!*		** Inicializarlos ** 
		*!*	*!*	ENDWITH

		*!*	*!*	THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		*!*	*!*	THIS.ENABLED	= .F.
		*!*	*!*	WITH THIS.PARENT.PARENT
		*!*	*!*		.PAGES(1).ENABLED	= .T.
		*!*	*!*		.ACTIVEPAGE	= 1
		*!*	*!*		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
		*!*	*!*		.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
		*!*	*!*		.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
		*!*	*!*		with thisform
		*!*	*!*			.cmdImprimir.ENABLED	= LlHayRegistros
		*!*	*!*			.CmdPrintGuia.ENABLED = (LlHayRegistros and GoCfgAlm.lPidMot)
		*!*	*!*		endwith 
		*!*	*!*		.PAGES(1).grdDetalle.REFRESH()
		*!*	*!*		.PAGES(1).grdDetalle.SETFOCUS()
		*!*	*!*	ENDWITH
		*!*	IF !INLIST(thisform.LcTipOpe,'I','A') 
		*!*		RETURN 
		*!*	ENDIF
		*!*	*!*	thisform.pgfDetalle.page1.cmdeliminar1.Click
		*!*	thisform.borra_item_blanco_grid() 
		*!*	this.Parent.Parent.Parent.habilita_grid(.f.)

		*!*	thisform.LcTipOpe = 'C' 
		*!*	*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*!*	LnNroItm  = C_RMOV.NroItm

		*!*	DO MovPinta
		*!*	thisform.calcular_totales() 
		*!*	SELECT C_RMOV
		*!*	LOCATE FOR NroItm = LnNroItm
		*!*	this.Parent.grdDetalle.SetFocus
		*!*	*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*!*	*this.Parent.grdDetalle.ActivateCell(LnFilaAct,1)
		*!*	RELEASE oSn,oSn2
	ENDPROC


	PROCEDURE grddetalle.AfterRowColChange
		LPARAMETERS nColIndex
		DODEFAULT()
		WITH THISFORM.PgfDetalle.PAGES(3)
			.TxtCodmat.VALUE = C_DTRA.CodMat
			.TxtDesMat.VALUE = C_DTRA.DesMat
			.TxtUndStk.VALUE = C_DTRA.UndStk
			DO CASE 
				CASE GsSigcia='CAUCHO'
					.TxtCanDes.VALUE = C_DTRA.CanDes
					.TxtPreUni.VALUE = C_DTRA.PreUni
					.TxtImpCto.VALUE = C_DTRA.CanDes*C_DTRA.PreUni
					this.column6.txtIMPCTOGRD.Value = C_DTRA.CanDes*C_DTRA.Factor
				OTHERWISE 
					.TxtCanDes.VALUE = C_DTRA.CanDes
					.TxtPreUni.VALUE = C_DTRA.PreUni
					.TxtImpCto.VALUE = C_DTRA.CanDes*C_DTRA.PreUni
					this.column6.txtIMPCTOGRD.Value = C_DTRA.CanDes*C_DTRA.PreUni
			ENDCASE

			.TxtLote.VALUE   = C_DTRA.Lote
			.TxtFchVto.Value = C_DTRA.FchVto
			.TxtPrec_Cif.VAlue = C_DTRA.Prec_Cif
			.TxtFact_Imp.VAlue = C_DTRA.Fact_Imp
			IF !EMPTY(C_DTRA.SubAlm)
				ThisForm.CboAlmacen.Value =C_DTRA.SubAlm

			ENDIF
		ENDWITH

		WITH THISFORM.PgfDetalle.PAGES(1)
			.TxtNro_Itm.Value = C_DTRA.Nro_Itm
		ENDWITH
	ENDPROC


	PROCEDURE grddetalle.Column7.AddObject
		LPARAMETERS cName, cClass
	ENDPROC


	PROCEDURE txtcodmatgrd.KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		LOCAL lcOldSearchString, lnLength
		IF THIS.PARENT.PARENT.COLUMNS(3).READONLY
			RETURN
		ENDIF

		lcOldSearchString = This.cSearchString
		DO CASE
			CASE (TnKeyCode  = CTRLW OR TnKeyCode  = 103) AND  TnShiftAltCtrl = 2
				UltTecla = TnKeyCode
				IF this.Valid()
		*!*				thisform.pgfDetalle.page1.Cmdgrabar1.Click() 
				ENDIF
			CASE TnKeyCode  = F9  
				UltTecla = TnKeyCode
		*		IF this.Valid()
		*!*				thisform.pgfDetalle.page1.CmdCancelar1.Click() 
		*		ENDIF
			CASE tnKeyCode >= 32 AND tnKeyCode <= 126
		      *
		      * Add the character to the current search string
		      *
		*!*	      this.cSearchString = this.cSearchString + CHR(tnKeyCode)

			CASE tnKeyCode = 127 && Backspace
		      *
		      * Delete the last character from the search string
		      *
				lnLength = LENC(This.cSearchString) - 1

				IF lnLength > 0
					This.cSearchString = SUBSTR(This.cSearchString, 1, lnLength)
				ELSE
					This.cSearchString = ''
				ENDIF
			CASE INLIST(TnKeyCode , Enter ,F8)
				UltTecla = TnKeyCode
				IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value)

		*			thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value = thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value
					=SEEK(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value,"CATG")
					Thisform.pgfDetalle.page1.grdDetalle.column2.txtDesMatGrd.Value = IIF(EMPTY(C_DTRA.Desmat) OR (C_DTRA.CodMat2<>C_DTRA.CodMat),CATG.DesMat,C_DTRA.Desmat)
					Thisform.pgfDetalle.page1.grdDetalle.column3.txtUndStkGrd.Value = CATG.UndStk

					KEYBOARD '{TAB}{TAB}'
		*!*			ELSE
		*!*				KEYBOARD '{ENTER}'
				ENDIF
				IF EMPTY(this.Value) OR TnKeyCode=F8
					thisform.pgfDetalle.page1.cmdHelp_CodMat.Click()
					KEYBOARD '{TAB}{TAB}'
		*!*			ELSE
		*!*				=SEEK(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value,"CATG")
		*!*				Thisform.pgfDetalle.page1.grdDetalle.column2.txtDesMatGrd.Value = CATG.DesMat
		*!*				Thisform.pgfDetalle.page1.grdDetalle.column3.txtUndStkGrd.Value = CATG.UndStk
				ENDIF

			CASE TnKeyCode  = F8
		*   		WAIT WINDOW 'Presiono F8'
				UltTecla = TnKeyCode
		*!*			this.Parent.parent.Column4.CmdHelpCuenta.Click()
		   OTHERWISE
		      * Some other key, just do the default actions
		      This.SelLength = LENC(This.cSearchString)
		      RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtcodmatgrd.DblClick
		KEYBOARD '{ENTER}'
	ENDPROC


	PROCEDURE txtcodmatgrd.Valid
		thisform.pgfDetalle.page3.txtCodmat.Value=this.Value
		LLOkItem = thisform.pgfDetalle.page3.txtCodmat.Valid() 
		RETURN LlOkitem
	ENDPROC


	PROCEDURE txtdesmatgrd.When
		**RETURN .F.
	ENDPROC


	PROCEDURE txtundstkgrd_ant.When
		*RETURN .F.
	ENDPROC


	PROCEDURE txtundstkgrd_ant.KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		DODEFAULT()
		LOCAL lcOldSearchString, lnLength
		IF THIS.PARENT.PARENT.COLUMNS(3).READONLY
			RETURN
		ENDIF

		lcOldSearchString = This.cSearchString
		DO CASE
			CASE (TnKeyCode  = CTRLW OR TnKeyCode  = 103) AND  TnShiftAltCtrl = 2
				UltTecla = TnKeyCode
				IF this.Valid()
		*!*				thisform.pgfDetalle.page1.Cmdgrabar1.Click() 
				ENDIF
			CASE TnKeyCode  = F9  
				UltTecla = TnKeyCode
		*		IF this.Valid()
		*!*				thisform.pgfDetalle.page1.CmdCancelar1.Click() 
		*		ENDIF
			CASE tnKeyCode >= 32 AND tnKeyCode <= 126
		      *
		      * Add the character to the current search string
		      *
		*!*	      this.cSearchString = this.cSearchString + CHR(tnKeyCode)

			CASE tnKeyCode = 127 && Backspace
		      *
		      * Delete the last character from the search string
		      *
				lnLength = LENC(This.cSearchString) - 1

				IF lnLength > 0
					This.cSearchString = SUBSTR(This.cSearchString, 1, lnLength)
				ELSE
					This.cSearchString = ''
				ENDIF
			CASE TnKeyCode  = F8
				UltTecla = TnKeyCode
				*thisform.pgfDetalle.page1.CmdHelpUndVta.cvaloresfiltro = ''
				thisform.pgfDetalle.page1.CmdHelpUndVta.Click

					IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndStkGrd.Value)
						LsUndVta=thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndStkGrd.Value
						=SEEK(C_DTRA.UndStk+LsUndVta,'EQUN','EQUN01')
						REPLACE C_DTRA.Factor WITH EQUN.FacEqu
						KEYBOARD '{TAB}'
					ELSE
		*!*				KEYBOARD '{F8}'
					ENDIF
			OTHERWISE
				* Some other key, just do the default actions
				This.SelLength = LENC(This.cSearchString)
				RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtundstkgrd_ant.Valid
		IF SEEK(C_DTRA.UNDSTK+THIS.Value,'EQUN','EQUN01')
			RETURN .T.
		ELSE
			=MESSAGEBOX('Unidad de venta invalida',48,'Atencion !')
			RETURN .f.
		ENDIF
	ENDPROC


	PROCEDURE txtundstkgrd.Valid
		IF C_DTRA.UndStk<>THIS.Value
		*!*		IF SEEK(C_DTRA.UNDSTK+THIS.Value,'EQUN','EQUN01')
			IF SEEK('UD'+THIS.Value,'TABL','TABL01')
				RETURN .T.
			ELSE
				=MESSAGEBOX('Unidad de venta invalida',48,'Atencion !')
				RETURN .f.
			ENDIF
		ELSE
			RETURN
		ENDIF
	ENDPROC


	PROCEDURE txtundstkgrd.KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		DODEFAULT()
		LOCAL lcOldSearchString, lnLength
		IF THIS.PARENT.PARENT.COLUMNS(3).READONLY
			RETURN
		ENDIF

		lcOldSearchString = This.cSearchString
		DO CASE
			CASE (TnKeyCode  = CTRLW OR TnKeyCode  = 103) AND  TnShiftAltCtrl = 2
				UltTecla = TnKeyCode
				IF this.Valid()
		*!*				thisform.pgfDetalle.page1.Cmdgrabar1.Click() 
				ENDIF
			CASE TnKeyCode  = F9  
				UltTecla = TnKeyCode
		*		IF this.Valid()
		*!*				thisform.pgfDetalle.page1.CmdCancelar1.Click() 
		*		ENDIF
			CASE tnKeyCode >= 32 AND tnKeyCode <= 126
		      *
		      * Add the character to the current search string
		      *
		*!*	      this.cSearchString = this.cSearchString + CHR(tnKeyCode)

			CASE tnKeyCode = 127 && Backspace
		      *
		      * Delete the last character from the search string
		      *
				lnLength = LENC(This.cSearchString) - 1

				IF lnLength > 0
					This.cSearchString = SUBSTR(This.cSearchString, 1, lnLength)
				ELSE
					This.cSearchString = ''
				ENDIF
			CASE TnKeyCode  = F8
				UltTecla = TnKeyCode
				*thisform.pgfDetalle.page1.CmdHelpUndVta.cvaloresfiltro = ''
				thisform.pgfDetalle.page1.CmdHelpUndVta.Click
					IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndStkGrd.Value)
						LsUndVta=thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndStkGrd.Value
						=SEEK(C_DTRA.UndStk+LsUndVta,'EQUN','EQUN01')
						REPLACE Factor WITH EQUN.FacEqu IN C_DTRA
						KEYBOARD '{TAB}'
					ELSE
		*!*				KEYBOARD '{F8}'
					ENDIF
			OTHERWISE
				* Some other key, just do the default actions
				This.SelLength = LENC(This.cSearchString)
				RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtcandesgrd.Valid
		IF EMPTY(This.Value)
			RETURN
		ENDIF
		LOCAL LlOkItem as Boolean ,LfImpCto as Number 

		DO CASE 
			CASE GsSigCia='CAUCHO'

			OTHERWISE 
				WITH THISFORM.PgfDetalle.PAGE3  
					.TxtCandes.Value = this.value
				    LlOkItem=  .TXtCanDes.Valid()
				    IF !LlOkItem
				    	RETURN LlOkItem
				    ENDIF
				    LfImpCto = .txtImpCto.value 
				ENDWITH
				IF LlOkItem
					WITH this.Parent.Parent 
						.Column6.txtImpCtoGrd.Value =  LfImpCto
					ENDWITH 
				ENDIF
		ENDCASE 
	ENDPROC


	PROCEDURE txtpreunigrd.DblClick
		KEYBOARD '{F8}'
	ENDPROC


	PROCEDURE txtpreunigrd.KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		DODEFAULT()
		LOCAL lcOldSearchString, lnLength
		IF THIS.PARENT.PARENT.COLUMNS(3).READONLY
			RETURN
		ENDIF

		lcOldSearchString = This.cSearchString
		DO CASE
			CASE (TnKeyCode  = CTRLW OR TnKeyCode  = 103) AND  TnShiftAltCtrl = 2
				UltTecla = TnKeyCode
				IF this.Valid()
		*!*				thisform.pgfDetalle.page1.Cmdgrabar1.Click() 
				ENDIF
			CASE TnKeyCode  = F9  
				UltTecla = TnKeyCode
		*		IF this.Valid()
		*!*				thisform.pgfDetalle.page1.CmdCancelar1.Click() 
		*		ENDIF
			CASE tnKeyCode >= 32 AND tnKeyCode <= 126
		      *
		      * Add the character to the current search string
		      *
		*!*	      this.cSearchString = this.cSearchString + CHR(tnKeyCode)

			CASE tnKeyCode = 127 && Backspace
		      *
		      * Delete the last character from the search string
		      *
				lnLength = LENC(This.cSearchString) - 1

				IF lnLength > 0
					This.cSearchString = SUBSTR(This.cSearchString, 1, lnLength)
				ELSE
					This.cSearchString = ''
				ENDIF
			CASE TnKeyCode  = F8
				UltTecla = TnKeyCode
				thisform.pgfDetalle.page1.cmdHelp_PreUni.cvaloresfiltro = TRIM(GsClfPre)
				thisform.pgfDetalle.page1.cmdHelp_PreUni.Click

		*!*			IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value)
		*!*				KEYBOARD '{TAB}'
		*!*			ELSE
		*!*				KEYBOARD '{F8}'
		*!*			ENDIF
			OTHERWISE
				* Some other key, just do the default actions
				This.SelLength = LENC(This.cSearchString)
				RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtpreunigrd.Valid
		LOCAL LlOkItem as Boolean ,LfPreUni as Number ,LfImpCto as Number 

		DO CASE
			CASE GsSigCia='CAUCHO'


			OTHERWISE 
				WITH THISFORM.PgfDetalle.PAGE3  
					.TxtCandes.Value = this.Parent.Parent.COLUMN4.TxtCanDesGrd.Value 
					.TxtPreuni.Value = this.value
				    LlOkItem=  .TXtPreuni.Valid()
				    LfPreuni = .txtPreuni.value 
				    LfImpCto = .TxtImpCto.Value
				ENDWITH
				IF LlOkItem
					WITH this.Parent.Parent
						.Column5.TxtPreuniGrd.Value =  LfPreuni
						.column6.TxtImpCtoGrd.Value =  LfImpCto
					ENDWITH 
				ENDIF
		ENDCASE
	ENDPROC


	PROCEDURE txtimpctogrd.Valid
		LOCAL LlOkItem as Boolean ,LfPreUni as Number ,LfImpCto as Number 
		RETURN .t. && Por ahora evitamos el recalculo de precio en base importe VETT 2006/06/30

		WITH THISFORM.PgfDetalle.PAGE3  
			.TxtCandes.Value = this.Parent.Parent.COLUMN4.TxtCanDesGrd.Value 
			.TxtPreuni.Value = this.Parent.Parent.COLUMN5.TxtPreUniGrd.Value 
			.TxtImpCto.Value = this.Parent.Parent.COLUMN6.TxtImpCtoGrd.Value 
		    LlOkItem=  .TXtImpCto.Valid()
		    LfPreuni = .txtPreuni.value 
		    LfImpCto = .txtImpCto.value 
		ENDWITH
		IF LlOkItem
			WITH this.Parent.Parent
				.Column5.TxtPreUniGrd.Value =  LfPreuni
				.column6.TxtImpCtoGrd.Value =  LfImpCto
			ENDWITH 
		ENDIF
	ENDPROC


	PROCEDURE txtfchlotgrd.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl 
		DO CASE
			CASE nKeyCode  = Enter 
				UltTecla = nKeyCode
				thisform.pgfDetalle.page1.cmdaceptar2.Click
				thisform.pgfDetalle.page1.cmdAdicionar1.Click
				SKIP
		ENDCASE
	ENDPROC


	PROCEDURE cmdhelp_preuni.Click
		DODEFAULT()
		WITH this.Parent.Parent.Parent
		ENDWITH
		XsPreUniGrd = this.cvalorvalida
		IF SEEK(TRIM(thisform.pgfDetalle.page1.grdDetalle.COLUMN1.txtCodMatGrd.Value),'CATG','CATG01')
		DO CASE
			CASE XsPreUniGrd = "1"
				IF thisform.pgfDetalle.page1.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVe1
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVn1
				ENDIF
			CASE XsPreUniGrd = "2"
				IF thisform.pgfDetalle.page1.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVe2
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVn2
				ENDIF
			CASE XsPreUniGrd = "3"
				IF thisform.pgfDetalle.page1.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVe3
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column5.txtPreUniGrd.Value = CATG.PreVn3
				ENDIF
		ENDCASE
		ENDIF
	ENDPROC


	PROCEDURE chkretencion.Valid
		thisform.ObjRefTran.XlRete	= this.Value
	ENDPROC


	PROCEDURE cmdfmapgo.Click
		DODEFAULT()
		this.parent.CboFmaPgo.Value  = this.cvalorvalida
		this.parent.CboFmaPgo.Valid()
	ENDPROC


	PROCEDURE cntcodtra.txtCodigo.Valid
		DODEFAULT()
		this.Parent.Parent.cboCodTra.Value=this.value 
	ENDPROC


	PROCEDURE cntcodtra.txtCodigo.InteractiveChange
		this.Parent.Parent.cboCodTra.InteractiveChange()  
	ENDPROC


	PROCEDURE txtnroref.Valid
		IF EMPTY(this.Value)
			RETURN 
		ENDIF
		DO CASE 
			CASE thisform.ObjRefTran.XsTpoRef = 'PECO' AND thisform.xreturn="I"
			*!*	Ojo este formulario usa el GoCfgCpi para la parte de produccion 
			*!*	Aqui estamos usando el ObjReftran vinculado al GoCfGAlm Para asignar datos al momento de llamar
			*!*	al metodo pCargaG_D 
				thisform.ObjRefTran.dFchDoc  =	goCfgCpi.dFchDoc  
				thisform.ObjRefTran.sNroOdt	 =	gocfgcpi.NroO_T
				ThisForm.ObJRefTran.XsNroRfb =  thisform.ObjRefTran.sNroOdt
				LOCAL LsCodDoc AS String , LsNroO_C AS String, LsCmpRef As String

				thisform.ObjRefTran.XsNroRef = THIS.Value
				LsCodDoc	=  thisform.ObjRefTran.XsTpoRef
				LsCmpRef	= 'thisform.Txt'+thisform.ObjRefTran.VarRef+'.Value'
				LsNroG_D	= &LsCmpRef.

				LsValorPK = Thisform.ObjRefTran.subalm+Thisform.ObjRefTran.cTipMov+Thisform.ObjRefTran.sCodMov+LEFT(THIS.VALUE,LEN(DTRA.NroDoc))
				LsCursor	= thisform.PgfOrdenTrabajo.page1.GrdDetalle.RecordSource 
				LsCursorSeleccionados = this.Parent.cmdHelpNroRef_Multi.caliasCursorSeleccionados
				LsCursorSeleccionados = IIF(USED(LsCursorSeleccionados) AND !EOF(LsCursorSeleccionados), LsCursorSeleccionados ,'')
				LsValorPkSeleccionados = Thisform.ObjRefTran.subalm+Thisform.ObjRefTran.cTipMov+Thisform.ObjRefTran.sCodMov
				LsCampoCursorSeleccionados = THIS.parent.cmdHelpNroRef_Multi.ccamporetorno
				thisform.Objreftran.cCursor_D = LsCursor  
				thisform.Objreftran.pCargaG_D('DTRA',;
											'ALMDTRAN',;
											'SUBALM+TIPMOV+CODMOV+NRODOC',;
											LsValorPK,;
											'DTRA01',;
											'',;
											'',;
											LsCursor,;
											'',;
											thisform.DataSessionId,;
											'CTRA',;
											'ALMCTRAN',;
											'CTRA01',; 
											LsCursorSeleccionados,;
											'SUBALM+TIPMOV+CODMOV+NRODOC',;
											LsValorPkSeleccionados,;
											LsCampoCursorSeleccionados)
				**
				lcurarea = ALIAS()
				SELECT (lsCursor)
				GO TOP 
				SCAN 
					IF !SEEK(SubAlm+CODMAT,[CALM],[CATA01])
						DELETE 
					ENDIF 
				endscan 
				GO TOP 
				SELECT (lcurarea)
				**
		*!*			IF EMPTY(this.Parent.CboCodPro.Value) 
		*!*				this.Parent.CboCodPro.Value = THISform.ObjRefTran.sCodPro
		*!*				this.Parent.CboCodPro.TxtCodigo.InteractiveChange()
		*!*			ENDIf

		*!*			THIS.Parent.TxtTpoCmb.Value =  THISform.ObjRefTran.fTpoCmb
		*!*			THIS.Parent.CboCodMon.Value =  THISform.ObjRefTran.nCodMon
		*!*			This.Parent.CboCodFre.Value =  THISFORM.Objreftran.sCodFre  

		*!*			IF !EMPTY(THISFORM.ObjRefTran.XsCndPgo)
		*!*				this.Parent.CboFmaPgo.Value = THISFORM.ObjRefTran.XsCndPgo
		*!*				this.parent.CboFmaPgo.Valid()
		*!*			ENDIf

		*		thisform.PgfDetalle.Page2.GrdDetalle.SetFocus
				thisform.Calcular_totales()
				WITH thisform.pgfOrdenTrabajo.Page1
					GO TOP IN (.grdDetalle.RecordSource)
					.grdDetalle.Refresh
					.grdDetalle.AfterRowColChange()
					.cmdAdicionar1.ENABLED	= .F.
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(.grdDetalle.RecordSource)
					.cmdModificar1.ENABLED	= LlHayRegistros
					.cmdEliminar1.ENABLED	= .F. && LlHayRegistros

				ENDWITH 
				thisform.LNuevo = .F.

		ENDCASE 
	ENDPROC


	PROCEDURE txtnroref.Message
		*!*	RETURN [Persona encargada de realizar la orden de trabajo]
	ENDPROC


	PROCEDURE cmdhelpundvta.Click
		DODEFAULT()
		WITH this.Parent.GrdDetalle.Column3.TxtUndStkGrd
			.Value = this.cvalorvalida
		ENDWITH
		KEYBOARD '{TAB}' 
	ENDPROC


	PROCEDURE cbocodtra.ProgrammaticChange
		this.InteractiveChange 
	ENDPROC


	PROCEDURE cbocodtra.InteractiveChange
		this.Parent.txtNomtra.Value = this.DisplayValue
		=SEEK(GsClfTra+this.Value,'CBDMAUXI','AUXI01')
		this.Parent.TxtNomTra.Value = CBDMAUXI.NomAux
		this.Parent.TxtDirTra.Value = CBDMAUXI.DirAux
		this.Parent.TxtRucTra.Value = CBDMAUXI.RucAux
		this.Parent.TxtPlaTra.Value = SUBSTR(CBDMAUXI.Transport,1,15)
		*!*	this.Parent.TxtMarca.Value 	= SUBSTR(CBDMAUXI.Transport,16,15)
		this.Parent.TxtBrevet.Value = SUBSTR(CBDMAUXI.Transport,32,15)
		*!*	this.Parent.TxtCertif.Value = SUBSTR(CBDMAUXI.Transport,48,15)
	ENDPROC


	PROCEDURE cmdhelpnroref_multi.Click
		THIS.parent.cntCodCli.value = IIF(THIS.parent.cntCodCli.value='N/A','',THIS.parent.CntCodCli.value)
		THIS.parent.CboCodVen.value = IIF(THIS.parent.CboCodVen.value='N/A','',THIS.parent.CboCodVen.value)
		THIS.parent.CboRuta.value 	= IIF(THIS.parent.CboRuta.value='N/A','',THIS.parent.CboRuta.value)
		LsCodDoc	=	THIS.Parent.CboCodDoc.Value
		LsTpoDoc	=	IIF(SEEK(this.Parent.CboCodDoc.Value,'SISTDOCS','DOC01'),SISTDOCS.TpoDoc,'')
		LsTituloDoc	=	this.Parent.CboCodDoc.DisplayValue 

		LsCamposFiltro =''
		LsValoresFiltro = ''

		*!*	IF !EMPTY(thisform.ObjRefTran.XsTpoRef)
		*!*		LsCamposFiltro = LsCamposFiltro +  'TpoRef' +	'+'
		*!*		LsValoresFiltro = LsValoresFiltro + thisform.ObjRefTran.XsTpoRef + '+'
		*!*	ENDIF
		IF !EMPTY(THIS.parent.cntCodCli.value )
			LsCamposFiltro = LsCamposFiltro +  'CodCli' +	'+'
			LsValoresFiltro = LsValoresFiltro + THIS.parent.cntCodCli.value + '+'
		ENDIF
		IF !EMPTY(THIS.parent.CboCodVen.value )
			LsCamposFiltro = LsCamposFiltro +  'CodVen' + '+'
			LsValoresFiltro = LsValoresFiltro + THIS.parent.CboCodVen.value + '+'
		ENDIF
		IF !EMPTY(THIS.parent.CboRuta.value )
			LsCamposFiltro = LsCamposFiltro +	'Ruta'	+	'+' 
			LsValoresFiltro = LsValoresFiltro + THIS.parent.CboRuta.value + '+'
		ENDIF
		IF !EMPTY(ThisForm.Objreftran.Xcflgest_ref )
			LsCamposFiltro = LsCamposFiltro +	'FlgEst'	+	'+' 
			LsValoresFiltro = LsValoresFiltro + ThisForm.Objreftran.Xcflgest_ref  + '+'
		ENDIF
		 

		LnPosCmp	= RAT('+',LsCamposFiltro)
		LnLenCmp	= LEN(LsCamposFiltro)
		LnPosVal	= RAT('+',LsValoresFiltro)
		LnLenVal	= LEN(LsValoresFiltro)
		LlSigCmp	= (LnPosCmp=LnLenCmp AND LnPosCmp>0)
		LlSigVal	= (LnPosVal=LnLenVal AND LnPosVal>0)

		LsCamposFiltro = IIF(LLSigCmp ,SUBSTR(LsCamposFiltro,1,LnLenCmp-1),LsCamposFiltro)
		LsValoresFiltro = IIF(LLSigVal,SUBSTR(LsValoresFiltro,1,LnLenVal-1),LsValoresFiltro)

		DO CASE 
			CASE INLIST(THIS.Parent.CboCodDoc.Value,'FACT','BOLE')
				LsCamposPK	= 'CODDOC+NRODOC'
				LsValorPK	= LsCodDoc
				LsTituloDoc	=	'Documentos sin guia remision'

				this.caliascursor = "c_NroFacBol"
				this.ccamposfiltro = 'CODDOC'
				this.cvaloresfiltro = LsCodDoc
				this.cnombreentidad = 'VTAVFACT'
				this.cWheresql 		= [ AND FlgEst = 'P' ]	&& cualquier filtro adicional
				DODEFAULT()
				this.Parent.TxtNroRf2.Value = this.cvalorvalida 
				this.Parent.TxtNroRf2.SetFocus
				IF !EMPTY(this.Parent.TxtNroRf2.Value)
					KEYBOARD '{END}'+'{ENTER}'
				ENDIF


				**** 
			CASE INLIST(THIS.Parent.CboCodDoc.Value,'PEDI')
				this.caliascursor = "c_NroPedidos"
				this.ccamposfiltro = ''
				this.cvaloresfiltro = ''
				this.cnombreentidad = 'VTAVPEDI'
				this.cWheresql 		= [ AND FlgEst = 'E' ]	&& cualquier filtro adicional
				DODEFAULT()
				this.Parent.TxtNroRf2.Value = this.cvalorvalida 
				this.Parent.TxtNroRf2.SetFocus
				IF !EMPTY(this.Parent.TxtNroRf2.Value)
					KEYBOARD '{END}'+'{ENTER}'
				ENDIF

			OTHERWISE 

		ENDCASE 
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		IF THISFORM.lNuevo AND !THISFORM.lGrabado
			lnOk = MESSAGEBOX("Para proseguir con esta opción deberá grabar el Documento " + CHR(13) + ;
				"¿ Desea grabar en este momento y proseguir ?" , 4+32+256 , "¿ Grabar Datos ?" )
			IF lnOk <> 6
				RETURN
			ENDIF

			WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
			THISFORM.lGrabado	= THISFORM.Grabar_Datos(1,'I')
			WAIT CLEAR

			IF !THISFORM.lGrabado
				=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
				RETURN
			ENDIF

			THISFORM.lNuevo	= .F.
			WAIT CLEAR
		ELSE
			WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
			IF !THISFORM.Grabar_Datos(2,THISFORM.LcTipOpe)
				=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
				RETURN
			ENDIF
			WAIT CLEAR
		ENDIF
		thisform	.cmdGrabar.Enabled  = .t.
		*
		* CALCULO TOTALES DEL DOCUMENTO
		*
		IF goCfgAlm.lpidpco
		   THISFORM.Calcular_Totales
		ENDIF
		*
		THIS.PARENT.cmdCancelar2.CLICK()
	ENDPROC


	PROCEDURE cmdcancelar2.Click
		WITH THIS.PARENT.PARENT.PAGES(3)

			*** Deshabilitar Controles
			.CmdHelpCodMat.ENABLED = .F.
			.CmdHelpLote.ENABLED = .F.
			.TxtCodMat.ENABLED = .F.
			.TxtCanDes.ENABLED = .F.
			.TxtPreUni.ENABLED = .F.
			.TxtImpCto.ENABLED = .F.
			.txtLote.ENABLED	= .f.
			.txtFchVto.ENABLED	= .f.
			.TxtPrec_Cif.ENABLED = .F.
			.TxtFact_Imp.ENABLED = .F.


			.cmdAceptar2.ENABLED	= .F.
			.cmdCancelar2.ENABLED	= .F.

			** Inicializarlos ** 

		ENDWITH

		THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		THIS.ENABLED	= .F.
		WITH THIS.PARENT.PARENT
			.PAGES(1).ENABLED	= .T.
			.ACTIVEPAGE	= 1
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
			.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
			with thisform
				.cmdImprimir.ENABLED	= LlHayRegistros
				.CmdPrintGuia.ENABLED = (LlHayRegistros and GoCfgAlm.lPidMot)
			endwith 
			.PAGES(1).grdDetalle.REFRESH()
			.PAGES(1).grdDetalle.SETFOCUS()
		ENDWITH
	ENDPROC


	PROCEDURE txtpreuni.Valid
		This.parent.TxtImpCto.VALUE=round(THIS.VALUE*this.parent.TxtCandes.VALUE,4)
	ENDPROC


	PROCEDURE txtimpcto.Valid
		IF this.parent.TxtCanDes.VALUE = 0
			This.parent.TxtPreUni.VALUE = 0
		else
			This.parent.TxtPreUni.VALUE = round(THIS.VALUE/this.parent.TxtCanDes.VALUE,4)
		endif
	ENDPROC


	PROCEDURE txtlote.Valid
		IF EMPTY(this.Value)
		   RETURN 
		ENDIF

		M.ERR=thisform.VALIDitem() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			RETURN .f.
		ENDIF
		IF THISFORM.OBJREFTRAN.cTipMov = 'I' AND EOF('C_LOTE') && Nro. de lote no existe

		ELSE
			THIS.VALUE = c_Lote.Lote
			THIS.Parent.TxtFchVto.Value = c_Lote.FchVto
		ENDIF

		this.Parent.Cmdaceptar2.Enabled = .t.
	ENDPROC


	PROCEDURE cmdhelpcodmat.Click
		WITH this.Parent.Parent.Parent
		*!*		GocfgAlm.SubAlm = .cboAlmacen.value
		*!*		GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
		*!*		GoCfgAlm.sCodMov=.cboCodmov.value
		endwith


		this.cvaloresfiltro = GocfgAlm.SubAlm
		DODEFAULT()
		this.Parent.TxtCodMat.Value = this.cvalorvalida 
		this.Parent.TxtCodMat.SetFocus
		IF !EMPTY(this.Parent.TxtCodMat.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE txtcodmat.Valid
		**IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
			IF EMPTY(this.Value)
		   		RETURN 
			ENDIF
			M.ERR=Thisform.VALIDitem() 
			IF m.err<0
				thisform.MensajeErr(m.err)
			endif

		    THIS.VALUE = c_CodMat.CODMAT
		    THIS.PARENT.TXTDESMAT.VALUE=IIF(EMPTY(c_dtra.DesMat) OR  (C_DTRA.CodMat2<>C_DTRA.CodMat),c_CodMat.DESMAT,C_DTRA.DesMat) && c_CodMat.DESMAT
		    THIS.PARENT.TXTUNDSTK.VALUE=c_CodMat.UNDSTK
		    Replace c_dtra.UndStk WITH IIF(EMPTY(C_DTRA.UndStk),c_CodMat.UndStk,C_DTRA.UndStk)
			IF thisform.modo_edit_detalle = 1
			  	thisform.pgfDetalle.page1.grdDetalle.Column2.txtDesmatGrd.Value=IIF(EMPTY(c_dtra.DesMat) OR (C_DTRA.CodMat2<>C_DTRA.CodMat),c_CodMat.DESMAT,C_DTRA.DesMat)
				thisform.pgfDetalle.page1.grdDetalle.Column3.txtUndStkGrd.Value=IIF(EMPTY(C_DTRA.UndVta) OR ISNULL(C_DTRA.UndVta),c_CodMat.UNDSTK,C_DTRA.UndVta)
				IF thisform.pgfDetalle.page1.grdDetalle.Column4.TxtCanDesGrd.Value<=0 ;
						AND c_CodMat.Stk_Alm>0
					thisform.pgfDetalle.page1.grdDetalle.Column4.TxtCanDesGrd.Value=c_CodMat.Stk_Alm
				endif
			ENDIF

		   this.Parent.Cmdaceptar2.Enabled = .t.
		   
		   *
		*!*	   IF goCfgAlm.lPidPco AND THISFORM.CboCodMov.VALUE = [010]
		*!*	      jcSede = GsCodSed
		*!*	      WITH THIS.PARENT.PARENT.PAGE1
		*!*			   IF goCfgAlm.lPidRf2 AND !EMPTY(.TxtNroRf2.VALUE)
		*!*			      .TxtNroRf2.VALUE = PADL(ALLTRIM(.TxtNroRf2.VALUE),3,[0])
		*!*			      IF SEEK(.TxtNroRf2.VALUE,"ALMA","ALMA01")
		*!*			         jcSede = ALMA.CodSed
		*!*			      ENDIF
		*!*			   ENDIF       
		*!*	       	   =StockxItem(THIS.VALUE,THIS.VALUE,.TxtFchDoc.Value,jcSede)
		*!*		  ENDWITH
		*!*		  *
		*!*		  this.parent.TxtPreUni.value = Gocfgalm.CtoUni
		*!*		  this.parent.TxtPreuni.valid()
		*!*	   ENDIF  
		**ENDIF
	ENDPROC


	PROCEDURE txtcandes.Valid
		IF EMPTY(This.Parent.TxtCodmat.Value)
			RETURN
		ENDIF

		M.ERR=Thisform.VALIDitem() 
		LOCAL nResp
		IF m.err<0
			nResp=thisform.MensajeErr(m.err)
			RETURN .f.
		ELSE
			nResp=thisform.MensajeErr(m.err)
			IF INLIST(nResp,2,7)
				RETURN .f.
			ENDIF
		endif

		This.parent.TxtImpCto.VALUE=round(THIS.VALUE*this.parent.TxtPreuni.VALUE,4)
	ENDPROC


	PROCEDURE cmdhelplote.Click
		WITH this.Parent.Parent.Parent
		*!*		GocfgAlm.SubAlm = .cboAlmacen.value
		*!*		GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
		*!*		GoCfgAlm.sCodMov=.cboCodmov.value
		endwith

		this.cvaloresfiltro = This.Parent.TxtCodMat.Value
		DODEFAULT()
		this.Parent.TxtLote.Value = this.cvalorvalida 
		this.Parent.TxtLote.SetFocus
		IF !EMPTY(this.Parent.TxtLote.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE txtprec_cif.Valid
		RETURN this.Value>=0
	ENDPROC


	PROCEDURE txtfact_imp.Valid
		IF THIS.Value>0
			LfPreUni	=	This.parent.TxtPreUni.VALUE
			LfTpoCmb	=	thisform.pgfdetalle.page1.TxtTpoCmb.Value
			LnCodMon	=	thisform.pgfdetalle.page1.CboCodMon.Value
			LfValAlmEXT	=	this.Value*This.Parent.TxtPrec_CIF.Value 
			IF This.parent.TxtPreUni.VALUE = 0
				This.parent.TxtPreUni.VALUE = IIF(LnCodMon=2,LfValAlmEXT,LfValAlmEXT*LfTpoCmb)
			ELSE
				IF MESSAGEBOX('Desea remplazar el valor de almacen anterior '+STR(LfPreUni,14,4),32+4,'Aviso importante') = 7
				else
					This.parent.TxtPreUni.VALUE = IIF(LnCodMon=2,LfValAlmEXT,LfValAlmEXT*LfTpoCmb)
				ENDIF
			ENDIF
		ENDIF
		RETURN this.Value>=0
	ENDPROC


	PROCEDURE cbocodtra.InteractiveChange
		this.Parent.txtNomtra.Value = this.DisplayValue
		=SEEK(GsClfTra+this.Value,'CBDMAUXI','AUXI01')
		this.Parent.TxtNomTra.Value = CBDMAUXI.NomAux
		this.Parent.TxtDirTra.Value = CBDMAUXI.DirAux
		this.Parent.TxtRucTra.Value = CBDMAUXI.RucAux
		this.Parent.TxtPlaTra.Value = SUBSTR(CBDMAUXI.Transport,1,15)
		this.Parent.TxtMarca.Value 	= SUBSTR(CBDMAUXI.Transport,16,15)
		this.Parent.TxtBrevet.Value = SUBSTR(CBDMAUXI.Transport,32,15)
		this.Parent.TxtCertif.Value = SUBSTR(CBDMAUXI.Transport,48,15)
	ENDPROC


	PROCEDURE cbocodtra.ProgrammaticChange
		this.InteractiveChange 
	ENDPROC


	PROCEDURE cntcodtra.txtCodigo.InteractiveChange
		this.Parent.Parent.cboCodTra.InteractiveChange()  
	ENDPROC


	PROCEDURE cntcodtra.txtCodigo.Valid
		DODEFAULT()
		this.Parent.Parent.cboCodTra.Value=this.value 
	ENDPROC


	PROCEDURE cmdadicionar.Click

		IF !THIS.Activado()
			RETURN
		ENDIF
		*
		WITH THISFORM
			.CboCodMov.Valid()
		   	with thisform.pgfdetalle.page1
				.cmdEliminar1.ENABLED	= .F.
			endwith
		    * 
			.xReturn	= 'I'	&& Indica Insertar registro ...
			.lNuevo		= .T.
			.lGrabado	= .F.
		    * 
			WAIT WINDOW [Creando Nueva Transacción .....] NOWAIT
			*
			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE("C_CTRA")
			.Tools.CLOSETABLE("C_DTRA")

			lnControl	= 1
			.cmdIniciar.ENABLED		= .T.
			.cmdSalir.ENABLED		= .F.

			.cmdIniciar.Visible		= .T.
			.cmdSalir.Visible		= .F.

			.cmdImprimir.ENABLED	= .F.
			.CmdPrintGuia.ENABLED	= .F.


			.CboAlmacen.ENABLED		= .F.
			.CboTipMov.ENABLED		= .F.
			.CboCodMov.ENABLED		= .F.
			.CboPtoVta.ENABLED		= .F.
		**	.cboTipMov.ENABLED		= .xReturn <> "E"  && .T.
		**	.cboCodMov.ENABLED		= .xReturn <> "E"  && .T.
		**	.cboTipMov.ENABLED		= .lNuevo
		**	.cboCodMov.ENABLED		= .lNuevo
		*	.CboTipMov.VALUE		= ''
		*	.CboCodMov.VALUE		= ''
		**	.CboAlmacen.VALUE		= GsSubAlm

			with thisform.pgfdetalle.page1

				.LblNrodoc.Visible		= .T.
				.LblFchDoc.Visible		= .T.
				.LblObserv.Visible		= .T.
				.LblFmaPgo.Visible		= .T.
				.TxtNrodoc.Visible		= .T.
				.TxtFchDoc.Visible		= .T.
				.TxtObserv.Visible		= .T.
				.txtNroDoc.ENABLED		= .F.
				.txtFchDoc.ENABLED		= .F.
				.TxtTpoCmb.ENABLED		= .F.
				.grdDetalle.Visible     = .T.
				.cmdAdicionar1.Visible  = .T.
				.cmdModificar1.Visible  = .T.
				.cmdeliminar1.Visible   = .T.
				.cntCodCli.Visible      = .T.
				.lblRucAux.Visible      = .T.
				.txtRucAux.Visible      = .T.

				thisform.cmdAdicionar.ENABLED	= .F.
				thisform.cmdModificar.ENABLED	= .F.
				thisform.cmdEliminar.ENABLED	= .F.

				thisform.cmdAdicionar.VISIBLE	= .F.
				thisform.cmdModificar.VISIBLE	= .F.
				thisform.cmdEliminar.VISIBLE	= .F.

		**		.txtNroDoc.ENABLED		= thisform.xReturn <> "E"
		**		.txtFchDoc.ENABLED		= thisform.xReturn <> "E"
		**		.txtTpoCmb.ENABLED		= thisform.xReturn <> "E"
		**		.cboCodMon.ENABLED		= thisform.xReturn <> "E"
				.TxtFchDoc.TabIndex		= 2
				.TxtObserv.TabIndex		= 6

				IF thisform.ObjReftran.XsTpoRef='G/R'
					.LblGloRf1.Visible = .T.
					.TxtNroRf1.ENABLED = .F.
					.TxtNroRf1.Visible = .T.
					.CmdHelpNroDoc.ENABLED = .F.
					.txtFchDoc.VALUE		= GdFecha
					.txtFchDoc.Setfocus() 

				ELSE
					.txtNroDoc.ENABLED		= thisform.xReturn <> "E" AND !thisform.lNuevo
					.txtFchDoc.VALUE		= GdFecha
					.txtFchDoc.Setfocus() 

				ENDIF

			endwith
			GoCfgAlm.Crear = .lNuevo
			.cmdImprimir.ENABLED = .xReturn <> "E" AND !.lNuevo
			.CmdPrintGuia.ENABLED = (.xReturn <> "E" AND !.lNuevo and GoCfgAlm.lPidMot)

			.cmdImprimir.Visible  = .F.
			.CmdPrintGuia.Visible = .F.

			.cmdGrabar.Enabled  = .t.
			.cmdGrabar.Visible  = .t.

			WAIT CLEAR
			IF .xReturn='I'				&& Solo cuando se Inserta un registro
				.Vincular_Controles()
			ENDIF
		ENDWITH

		WITH THISFORM.PgfDetalle.PAGES(1)
		*	.CboCodTra.SETFOCUS()
		ENDWITH
		with thisform.pgfdetalle.page1
			.txtFchDoc.Setfocus() 
		endwith
	ENDPROC


	PROCEDURE cmdmodificar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		WITH THISFORM
			.xReturn	= ""
			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE("C_CTRA")
			.Tools.CLOSETABLE("C_DTRA")

			.cmdIniciar.ENABLED		= .T.
			.cmdSalir.ENABLED		= .F.

			.cmdIniciar.Visible		= .T.
			.cmdSalir.Visible		= .F.

			.cmdImprimir.ENABLED	= .F.
			.cmdprintguia.Enabled = .F.

			.cmdImprimir.Visible  = .F.
			.CmdPrintGuia.Visible = .F.

			.CboAlmacen.ENABLED		= .F.
			.CboTipMov.ENABLED		= .F.
			.CboCodMOv.ENABLED		= .F.
			.CboPtoVta.ENABLED		= .F.

		**	.CboTipMov.VALUE		= ''
		**	.CboCodMov.VALUE		= ''
		**	.CboAlmacen.SETFOCUS()
			.CboCodMov.Valid()
			WITH thisform.pgfdetalle.page1
				.LblNrodoc.Visible		= .T.
				.LblFchDoc.Visible		= .T.
				.LblObserv.Visible		= .T.
				.TxtNrodoc.Visible		= .T.
				.TxtFchDoc.Visible		= .T.
				.TxtObserv.Visible		= .T.
				.cmdAdicionar1.Visible  = .T.
				.cmdModificar1.Visible  = .T.
				.cmdeliminar1.Visible   = .T.
				.CmdHelpNroDoc.VISIBLE  = .T.
				.grdDetalle.Visible		= .T.

				thisform.cmdAdicionar.ENABLED	= .F.
				thisform.cmdModificar.ENABLED	= .F.
				thisform.cmdEliminar.ENABLED	= .F.

				thisform.cmdAdicionar.VISIBLE	= .F.
				thisform.cmdModificar.VISIBLE	= .F.
				thisform.cmdEliminar.VISIBLE	= .F.

				.TxtFchDoc.TabIndex		= 6
				.CntCodCli.TabIndex		= 5
				.TxtObserv.TabIndex		= 2

				IF thisform.ObjReftran.XsTpoRef='G/R'
					.LblGloRf1.Visible = .T.
					.TxtNroRf1.ENABLED = .T.
					.TxtNroRf1.Visible = .T.
					.CmdHelpNroDoc.ENABLED = .T.
					.TxtNroRf1.SETFOCUS()

				ELSE
					.TxtNroDoc.ENABLED = .f.
					.CmdHelpNroDoc.ENABLED = .T.
					.TxtNroDoc.SETFOCUS()
				ENDIF
			ENDWITH
			.lNuevo		= .F.
			.lGrabado	= .F.
			GoCfgAlm.Crear = .lNuevo
			.cmdGrabar.Enabled  = .t.
			.cmdGrabar.Visible  = .t.
			.xReturn	= "A"
		ENDWITH

		WITH THISFORM.PgfDetalle.PAGES(1)
			** Inicializamos Variables
		*	.CboCodTra.SETFOCUS()
		ENDWITH
	ENDPROC


	PROCEDURE cmdeliminar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		WITH THISFORM
			.CboCodMov.Valid()
			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE("C_CTRA")
			.Tools.CLOSETABLE("C_DTRA")


			.cmdIniciar.ENABLED		= .T.
			.cmdSalir.ENABLED		= .F.
			*
			.cmdIniciar.Visible		= .T.
			.cmdSalir.Visible		= .F.

			.cmdImprimir.ENABLED	= .F.
			.cmdPrintGuia.ENABLED	= .F.

			.cmdImprimir.Visible  = .F.
			.CmdPrintGuia.Visible = .F.


			.CboAlmacen.ENABLED		= .F.
			.CboTipMov.ENABLED		= .F.
			.CboCodMOv.ENABLED		= .F.
			.CboPtoVta.ENABLED		= .F.
		**	.CboAlmacen.SETFOCUS()

			with thisform.pgfdetalle.page1
				.LblNrodoc.Visible		= .T.
				.LblFchDoc.Visible		= .T.
				.LblObserv.Visible		= .T.

				.TxtNrodoc.Visible		= .T.
				.TxtFchDoc.Visible		= .T.
				.TxtObserv.Visible		= .T.
				.CmdHelpNroDoc.VISIBLE  = .T.
				.grdDetalle.Visible		= .T.
				thisform.cmdAdicionar.ENABLED	= .F.
				thisform.cmdModificar.ENABLED	= .F.
				thisform.cmdEliminar.ENABLED	= .F.

				thisform.cmdAdicionar.VISIBLE	= .F.
				thisform.cmdModificar.VISIBLE	= .F.
				thisform.cmdEliminar.VISIBLE	= .F.

				IF thisform.ObjReftran.XsTpoRef='G/R'
					.LblGloRf1.Visible = .T.
					.TxtNroRf1.ENABLED = .T.
					.TxtNroRf1.Visible = .T.
					.CmdHelpNroDoc.ENABLED = .T.
					.TxtNroRf1.SETFOCUS()

				ELSE
					.TxtNroDoc.ENABLED = .f.
					.CmdHelpNroDoc.ENABLED = .T.
					.TxtNroDoc.SETFOCUS()
				ENDIF
			endwith
			.lNuevo		= .F.
			.lGrabado	= .F.
			GoCfgAlm.Crear = .lNuevo
			.cmdGrabar.Enabled  = .t.
			.cmdGrabar.Visible  = .t.
			.cmdGrabar.Caption  = 'Eliminar'

			.xReturn	= "E"
		ENDWITH
	ENDPROC


	PROCEDURE cmdsalir.Click
		thisform.TOOLS.closetable([C_CTRA])
		thisform.TOOLS.closetable([C_DTRA])
		thisform.TOOLS.closetable([C_CDOC])
		thisform.TOOLS.closetable([C_CFTR])
		thisform.TOOLS.closetable([CDOC])
		thisform.TOOLS.closetable([CFTR])
		thisform.TOOLS.closetable([CTRA])
		thisform.TOOLS.closetable([DTRA])
		thisform.TOOLS.closetable([ALMA])
		thisform.TOOLS.closetable([CATG])
		thisform.TOOLS.closetable([CALM])
		thisform.TOOLS.closetable([ESTA])
		thisform.TOOLS.closetable([ESTR])
		thisform.TOOLS.closetable([TCMB])
		thisform.TOOLS.closetable([EQUN])
		thisform.TOOLS.closetable([TABL])
		thisform.TOOLS.closetable([AUXI])
		thisform.TOOLS.closetable([DIVF])
		thisform.TOOLS.closetable([TEMP])
		thisform.TOOLS.closetable([DFPRO])
		thisform.TOOLS.closetable([GUIA])
		thisform.TOOLS.closetable([DSER])
		thisform.TOOLS.closetable([CORR])
		thisform.TOOLS.closetable([VFAC])
		thisform.TOOLS.closetable([DO_C])

		thisform.TOOLS.closetable([ALMTALMA])
		thisform.TOOLS.closetable([CPILOTES])
		thisform.TOOLS.closetable([CPIFASES])
		thisform.TOOLS.closetable([CPICULTI])
		thisform.TOOLS.closetable([CPIPROCS])
		thisform.TOOLS.closetable([CPIACTIV])
		thisform.TOOLS.closetable([CCTCLIEN])
		thisform.TOOLS.closetable([CCTCDIRE])
		thisform.TOOLS.closetable([CMPPROV])
		thisform.TOOLS.closetable([V_CULTIVOS_X_LOTE])
		thisform.TOOLS.closetable([V_ACTIVIDADES_X_FASE_PROC])
		thisform.TOOLS.closetable([CPICUXLT])
		thisform.TOOLS.closetable([CPIACXPR])
		thisform.TOOLS.closetable([CBDMPART])
		thisform.TOOLS.closetable([CBDMAUXI])
		thisform.TOOLS.closetable([DLOTE])
		thisform.TOOLS.closetable([C_LOTE])
		thisform.TOOLS.closetable([C_CODMAT])
		thisform.TOOLS.closetable([V_MATERIALES_X_ALMACEN])
		thisform.TOOLS.closetable([V_MATERIALES_X_ALMACEN_2])
		thisform.TOOLS.closetable([V_MATERIALES_X_ALMACEN_3])
		thisform.TOOLS.closetable([SISTLERR])
		thisform.TOOLS.closetable([V_MATERIALES_X_LOTE])
		thisform.TOOLS.closetable([VTATDOCM])
		thisform.TOOLS.closetable([SISTCDXS])
		thisform.TOOLS.closetable([SISTDOCS])
		thisform.TOOLS.closetable([VTAPTOVT])
		thisform.tools.closetable(thisform.pgfDetalle.page1.CmdHelpNroRef_Multi.caliasCursorSeleccionados )
		thisform.tools.closetable('CO_C')
		thisform.tools.closetable('CREQ')
		thisform.tools.closetable('RPED')
		thisform.tools.closetable('VTAVPEDI')
		thisform.tools.closetable('ALMEQUNI')
		THISFORM.RELEASE
	ENDPROC


	PROCEDURE cmdimprimir.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		LOCAL lcRptTxt , lcRptGraph , lcRptDesc 
		LOCAL LcArcTmp, LcAlias,LnNumReg,LnNumCmp,LlPrimera

		LcArcTmp=GoEntorno.TmpPath+Sys(3)
		**
		LcAlias=ALias()
		SELECT c_dtra
		LOCATE
		IF EOF()
			wait window "No existen registros a Listar" NOWAIT
			IF NOT EMPTY(LcAlias)
				SELE (LcAlias)
			ENDIF
			return
		ENDIF

		DO CASE
			CASE thisform.CboTipMov.VALUE="I"
				lcRptTxt	= "repalm_ingresos"
				lcRptGraph	= "repalm_ingresos"
				lcRptDesc	= "Ingresos"
			CASE thisform.CboTipMov.VALUE="S"
		*		lcRptTxt	= "repvta_guia_de_remision1"
		*		lcRptGraph	= "repvta_guia_de_remision1"
				lcRptTxt	= "repalm_salidas"
				lcRptGraph	= "repalm_salidas"
				lcRptDesc	= "Salidas"
			CASE thisform.CboTipMov.VALUE="T"
				lcRptTxt	= "repalm_transferencia"
				lcRptGraph	= "repalm_transferencia"
				lcRptDesc	= "Transferencia"
		ENDCASE
		IF .F.
			DO CASE
				CASE thisform.CboTipMov.VALUE="I"
					MODI REPORT  repalm_ingresos
				CASE thisform.CboTipMov.VALUE="S"
					MODI REPORT  repalm_salidas
				CASE thisform.CboTipMov.VALUE="T"
					MODI REPORT  repalm_transferencia
			ENDCASE
		ENDIF

		DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , THISFORM.DATASESSIONID
		**
		*USE IN Temporal
		IF NOT EMPTY(LcAlias)
			SELECT (LcAlias)
		ENDIF
		*
		RELEASE	 lcCategoria , lcTemporada , lcNombreColecion , lcDescripcionLargaProducto , lcNombreRazonSocial
		RELEASE	 lcCodigoCliente , ldFHObjComercial
		RELEASE  LcArcTmp, LcAlias,LnNumReg,LnNumCmp,LlPrimera,LcNomRep
	ENDPROC


	PROCEDURE cmdgrabar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		IF EMPTY(Thisform.PgfDetalle.Page1.TxtFchDoc.Value)
			MESSAGEBOX("Por favor ingrese la fecha de la transacción",16,'ATENCION !!!')
			Thisform.PgfDetalle.Page1.TxtFchDoc.SetFocus 
			return
		ENDIF

		IF THISFORM.xReturn == "E" AND MESSAGEBOX("¿Esta seguro de eliminar la Transaccion ?",32+4+256,"Eliminar Transacción")<>6
			RETURN
		ENDIF
		lControl = THISFORM.Grabar_Datos(4,THISFORM.xReturn)
		IF thisform.xReturn # 'E' 
			IF thisform.ObjRefTran.XsTpoRef='G/R'
				thisform.CmdPrintGuia.Click
			ELSE
				thisform.Cmdimprimir.Click
			ENDIF
		ENDIF

		IF lControl
		   *THISFORM.cmdIniciar.CLICK()
		   THISFORM.INICIAR_VAR()   
		ENDIF
	ENDPROC


	PROCEDURE cboalmacen.ProgrammaticChange
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		=seek(This.Value,"alma","alma01")

		goCfgAlm.CodSed = alma.CodSed
		goCfgAlm.SubAlm = THIS.Value 
	ENDPROC


	PROCEDURE cboalmacen.InteractiveChange
		*!*	VETT : Este procedimiento esta en Vincular Controles como en el de Lotes
		*!*	       pero si cambian de Almacen como sería  ????
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		=seek(This.Value,"alma","alma01")

		goCfgAlm.CodSed		=	alma.CodSed
		goCfgAlm.GdFchCie	=	alma.FchCie
		goCfgAlm.SubAlm		=   this.Value
		GsSubAlm=This.Value
		GsNomSub=THIS.DisplayValue 
	ENDPROC


	PROCEDURE cbocodmov.InteractiveChange
		WITH THISFORM
		*!*		IF .xReturn='I'				&& Solo cuando se Inserta un registro
		*!*			.Vincular_Controles()
		*!*		ENDIF
		*!*		WITH thisform.PgfDetalle.pages(1)
		*!*			.TxtFchDoc.SetFocus
		*!*		ENDWITH
			WITH thisform.pgfDetalle.page1
				.CmdAdicionar1.ENABLED = .T.
			ENDWITH
		ENDWITH
	ENDPROC


	PROCEDURE cbocodmov.Valid
		GoCfgAlm.cTipMov=IIF(LEFT(Thisform.cbotipmov.value,1)=[T],[S],LEFT(thisform.cbotipmov.value,1))
		GoCfgAlm.sCodMov=THIS.VAlue 

		gocfgalm.Cap_Cfg_Transacciones(GoCfgAlm.cTipMov,GoCfgAlm.sCodMov)
		thisform.PgfDetalle.Page1.LblGloRf1.CAPTION 		=	goCfgAlm.GloRf1
		thisform.PgfDetalle.Page1.LblGloRf2.CAPTION 		=	goCfgAlm.GloRf2
		thisform.PgfDetalle.Page1.LblGloRf3.CAPTION 		=	goCfgAlm.GloRf3
	ENDPROC


	PROCEDURE cmdprintguia.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		LOCAL lcRptTxt , lcRptGraph , lcRptDesc 
		LOCAL LcArcTmp, LcAlias,LnNumReg,LnNumCmp,LlPrimera

		LcArcTmp=GoEntorno.TmpPath+Sys(3)
		**
		LcAlias=ALias()
		SELECT CTRA
		LsOrderAct=ORDER()
		IF thisform.Objreftran.XsTpoRef='G/R'
			SET ORDER TO CTRA03
			LsNroGui = 'thisform.PgfDETALLE.PaGE1.Txt'+thisform.ObjRefTran.VarRef+'.Value'
			LsLLaveGuia=PADR(thisform.Objreftran.XsTpoRef,LEN(CTRA.TpoRf1))+&LsNroGui.
			SEEK LsLLaveGuia
		ELSE 
			=SEEK(thisform.objreftran.cValor_PK)
		ENDIF
		SELECT cbdmauxi
		LOCATE FOR clfaux+codaux = GsClfCli+thisform.pgfDetalle.page1.cntCodCli.VAlue
		IF !USED('cctcdire')
			goentorno.open_dbf1('ABRIR','CCTCDIRE','','DIRE02','')
		ENDIF
		SELECT cctcdire
		LOCATE FOR clfaux+codaux = GsClfCli+thisform.pgfDetalle.page1.cntCodCli.VAlue AND ;
					 CodDire=thisform.pgfDetalle.page1.cboCodDire.VAlue

		SELECT CodCli,CodDire,DesDire FROM CCTCDIRE WHERE clfaux+codaux = GsClfCli+thisform.pgfDetalle.page1.cntCodCli.VAlue AND ;
					 CodDire='002' INTO CURSOR c_DirEnt

		SELECT c_dtra
		LOCATE
		IF EOF()
			wait window "No existen registros a Listar" NOWAIT
			IF NOT EMPTY(LcAlias)
				SELE (LcAlias)
			ENDIF
			IF MESSAGEBOX("Guía no tiene detalle de todas maneras desea imprimir",4+16+256,'Atención!!') = 7
				RETURN
			ELSE
				SELECT c_CTRA
			ENDIF
		ENDIF

			lcRptTxt	= "repvta_guia_de_remision1"+"_"+GsSigCia
			lcRptGraph	= "repvta_guia_de_remision1"+"_"+GsSigCia
			lcRptDesc	= "Guia de remisión"
		IF .f.
			MODI REPORT  (lcRptTxt)
		ENDIF

		DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , THISFORM.DATASESSIONID
		**
		*USE IN Temporal
		SELECT CTRA
		SET ORDER TO (LsOrderAct)
		IF NOT EMPTY(LcAlias)
			SELECT (LcAlias)
		ENDIF
		*
		RELEASE	 lcCategoria , lcTemporada , lcNombreColecion , lcDescripcionLargaProducto , lcNombreRazonSocial
		RELEASE	 lcCodigoCliente , ldFHObjComercial
		RELEASE  LcArcTmp, LcAlias,LnNumReg,LnNumCmp,LlPrimera,LcNomRep
		USE IN c_dirEnt
	ENDPROC


	PROCEDURE cbotipmov.InteractiveChange
		*!*	IF thisform.xreturn ='I'
		*!*			SET STEP ON 
		*!*	ENDIF

		IF LEFT(THIS.VALUE,1)=[T]
			THIS.PARENT.cboCodMov.cValoresFiltro = [S]
			THIS.PARENT.cboCodMov.cWhereSql       = [ AND TRANSF]
		ELSE
			THIS.PARENT.cboCodMov.cValoresFiltro = LEFT(THIS.VALUE,1)
			IF !THIS.PARENT.lfiltro_mov
				THIS.PARENT.cboCodMov.cWhereSql = ''
			ENDIF
		ENDIF
		this.parent.cboCodMov.GenerarCursor()

		IF !this.Parent.lcodmov AND !this.Parent.lfiltro_mov 
		*!*		This.Parent.CboCodMov.VALUE = ''
		ENDIF
	ENDPROC


	PROCEDURE cboptovta.ProgrammaticChange
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		*!*	=seek(This.Value,"alma","alma01")

		*!*	goCfgAlm.CodSed = alma.CodSed
	ENDPROC


	PROCEDURE cboptovta.InteractiveChange
		*!*	VETT : Este procedimiento esta en Vincular Controles como en el de Lotes
		*!*	       pero si cambian de Almacen como sería  ????
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		*!*	=seek(This.Value,"alma","alma01")

		*!*	goCfgAlm.CodSed		=	alma.CodSed
		*!*	goCfgAlm.GdFchCie	=	alma.FchCie
	ENDPROC


	PROCEDURE cboptovta.Valid
		thisform.ObjReftran.XsPtoVta = THIS.VAlue
	ENDPROC


	PROCEDURE cntdoc_ref1.iniciar_var
		*!*	this.grid1.RecordSource = ''
		*!*	this.grid1.RecordSourceType = 4

		*!*	LcSql = "SELECT CodDoc,NroDoc,FchDoc, .f. as Selec From "+This.ctabla_ref +" where " + this.ccmppk_ref +" = "+this.cvalpk_ref + "HAVING "+This.cFiltro+ " readwrite into cursor " + this.ccursor_local 
		DODEFAULT()
	ENDPROC


	PROCEDURE cntdoc_ref1.Init
		DODEFAULT()
		this.AddProperty("cFiltro",'',1) 
		*!*	this.grid1.RecordSource = ''
		*!*	this.grid1.RecordSourceType = 4
	ENDPROC


	PROCEDURE cntdoc_ref1.CmdAceptar2.Click
		thisform.LockScreen = .T.
		DODEFAULT()
		this.Parent.Enabled =.F.
		thisform.pgFDETALLE.page1.cmdprocesar1.SetFocus  
		LsCodDoc	=	thisform.PgfDetalle.Page1.CboCodDoc.Value
		thisform.ObjRefTran.ccursor_d='C_DTRA'
		thisform.ObjRefTran.ccursor_C='C_CTRA'
		thisform.ObjRefTran.cargar_guia_detalle_enbasea_docs(LsCodDoc,'VFAC','ITEM','VFAC01','ITEM01')  
		*** Por Adecuar segun la configuracion del almcftra 
		ThisForm.ObjReftran.TpoRf2  = thisform.ObjReftran.XsTpoRfb
		ThisForm.ObjReftran.sNroRf2 = thisform.ObjReftran.XsNroRfb
		thisform.PgfDetalle.Page1.TxtNroRf2.Value = thisform.ObjReftran.XsNroRfb 

		WITH THISFORM.PgfDetalle.Page1 
			IF EMPTY(.cntCodCli.Value) 
				.cntCodCli.Value = THISform.ObjRefTran.XsCodCli
				.CntCodCli.TxtCodigo.InteractiveChange()
			ENDIF
			IF !EMPTY(THISFORM.ObjRefTran.XsCndPgo)
				.CboFmaPgo.Value = THISFORM.ObjRefTran.XsCndPgo
				.CboFmaPgo.Valid()
			ENDIF
			.CboCodMon.Value =   thisform.ObjRefTran.XnCodMon
			.TxtTpoCmb.Value =   thisform.ObjRefTran.XfTpoCmb
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.ObjRefTran.ccursor_d)
			.cmdModificar1.ENABLED	= .F.
			.cmdModificar1.ENABLED	= LlHayRegistros
			.cmdEliminar1.ENABLED	= .F.
		ENDWITH
		thisform.lgrabado = .t.
		thisform.pgfDetalle.page1.grdDetalle.refresh  
		thisform.LockScreen = .F.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: funalm_transacciones_vta
**************************************************
