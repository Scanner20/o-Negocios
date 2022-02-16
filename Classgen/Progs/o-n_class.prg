**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\o-n.vcx
**************************************************


**************************************************
*-- Class:        acabecera (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/11/03 03:57:08 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS acabecera AS custom


	Name = "cabecera"


ENDDEFINE
*
*-- EndDefine: acabecera
**************************************************


**************************************************
*-- Class:        adetalle (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/11/03 03:57:11 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS adetalle AS custom


	Name = "detalle"


ENDDEFINE
*
*-- EndDefine: adetalle
**************************************************


**************************************************
*-- Class:        base_transac (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  base_form (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    form
*-- Time Stamp:   07/05/10 10:02:12 AM
*-- Formulario base de transacciones
*
DEFINE CLASS base_transac AS base_form


	Height = 421
	Width = 671
	DoCreate = .T.
	Caption = "Transacciones"
	*-- Indica QUE tipo de transacción se va  a ser.
	que_transaccion = ('')
	*-- Alias del cursor de la cabecera
	ccursor_c = ([])
	*-- Alias del cursor del detalle
	ccursor_d = ([])
	*-- Tabla de la cabecera
	ctabla_c = ([])
	*-- Tabla detalle
	ctabla_d = ([])
	*-- Tabla detalle de la tabla detalle
	ctabla_d2 = ([])
	caliascab = ([])
	caliasdet = ([])
	caliasdet_det = ([])
	*-- Campos de la clave primaria de la tabla cabecera
	ccampos_pk = ([])
	*-- Indice de la clave primaria (PK)
	cindice_pk = ([])
	*-- Valor de la clave primaria
	cvalor_pk = ([])
	*-- TIPO DE DOCUMENTO SEGUN AFECTACION A CUENTA CORRIENTE
	tpodoc = ([])
	xsnroast = ([])
	xscodope = ([])
	xsnromes = ([])
	ccampo_id = ([])
	ccmps_id = ([])
	cvalor_id = ([])
	Name = "base_transac"
	Tools.Top = 360
	Tools.Left = 216
	Tools.Height = 24
	Tools.Width = 24
	Tools.Name = "Tools"
	xfimpvta = .F.


	ADD OBJECT cmdiniciar AS cmdnuevo WITH ;
		Top = 361, ;
		Left = 351, ;
		Height = 40, ;
		Width = 48, ;
		Caption = "\<Iniciar", ;
		TabIndex = 9, ;
		PicturePosition = 7, ;
		ZOrderSet = 2, ;
		codigoboton = ("00001371"), ;
		Name = "cmdIniciar"


	ADD OBJECT pgfdetalle AS base_pageframe WITH ;
		ErasePage = .T., ;
		PageCount = 4, ;
		Top = 1, ;
		Left = 0, ;
		Width = 661, ;
		Height = 347, ;
		TabIndex = 7, ;
		Name = "PgfDetalle", ;
		Page1.Caption = "Datos principales", ;
		Page1.Name = "Page1", ;
		Page2.Caption = "Detalle de items", ;
		Page2.Name = "Page2", ;
		Page3.Caption = "Mantenimiento Detalle", ;
		Page3.Name = "Page3", ;
		Page4.Caption = "Datos adicionales", ;
		Page4.Name = "Page4"


	ADD OBJECT base_transac.pgfdetalle.page1.lblstatus2 AS base_label WITH ;
		FontBold = .F., ;
		FontSize = 20, ;
		Caption = "", ;
		Height = 35, ;
		Left = 334, ;
		Top = 6, ;
		Visible = .T., ;
		Width = 2, ;
		TabIndex = 8, ;
		ForeColor = RGB(255,255,255), ;
		ZOrderSet = 0, ;
		Name = "lblStatus2"


	ADD OBJECT base_transac.pgfdetalle.page1.lblnrodoc AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Nº O/T", ;
		Left = 23, ;
		Top = 21, ;
		TabIndex = 5, ;
		ZOrderSet = 1, ;
		Name = "LblNrodoc"


	ADD OBJECT base_transac.pgfdetalle.page1.lblfchdoc AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha", ;
		Left = 177, ;
		Top = 21, ;
		TabIndex = 6, ;
		ZOrderSet = 2, ;
		Name = "LblFchDoc"


	ADD OBJECT base_transac.pgfdetalle.page1.cmdadicionar AS cmdnuevo WITH ;
		Top = 275, ;
		Left = 503, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 10, ;
		PicturePosition = 7, ;
		ZOrderSet = 3, ;
		codigoboton = ("00001371"), ;
		Name = "cmdAdicionar"


	ADD OBJECT base_transac.pgfdetalle.page1.cmdmodificar AS cmdmodificar WITH ;
		Top = 275, ;
		Left = 551, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 11, ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 4, ;
		codigoboton = ("00001372"), ;
		Name = "Cmdmodificar"


	ADD OBJECT base_transac.pgfdetalle.page1.cmdeliminar AS cmdeliminar WITH ;
		Top = 275, ;
		Left = 599, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 12, ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 5, ;
		codigoboton = ("00001373"), ;
		Name = "Cmdeliminar"


	ADD OBJECT base_transac.pgfdetalle.page1.txtfchdoc AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 212, ;
		TabIndex = 2, ;
		Top = 18, ;
		Width = 65, ;
		ZOrderSet = 6, ;
		Name = "TxtFchDoc"


	ADD OBJECT base_transac.pgfdetalle.page1.txtnrodoc AS base_textbox WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "9999999999", ;
		Left = 64, ;
		MaxLength = 10, ;
		TabIndex = 1, ;
		Top = 19, ;
		Width = 80, ;
		ForeColor = RGB(255,0,0), ;
		DisabledForeColor = RGB(255,0,0), ;
		ZOrderSet = 7, ;
		Name = "TxtNroDoc"


	ADD OBJECT base_transac.pgfdetalle.page1.txtobserv AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 95, ;
		TabIndex = 3, ;
		Top = 283, ;
		Visible = .T., ;
		Width = 315, ;
		ZOrderSet = 8, ;
		Name = "TxtObserv"


	ADD OBJECT base_transac.pgfdetalle.page1.lblobserv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Observaciones", ;
		Left = 6, ;
		Top = 285, ;
		TabIndex = 9, ;
		ZOrderSet = 9, ;
		Name = "LblObserv"


	ADD OBJECT base_transac.pgfdetalle.page1.cmdhelpnrodoc AS base_cmdhelp WITH ;
		Top = 20, ;
		Left = 145, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 4, ;
		ZOrderSet = 10, ;
		cvaloresfiltro = (GsCodCia), ;
		ccamposfiltro = "CodCia", ;
		cnombreentidad = "MTOCRQOC", ;
		ccamporetorno = "Num_OrdReq", ;
		caliascursor = "c_nrodoc", ;
		ccampovisualizacion = "Observac", ;
		Name = "CmdHelpNrodoc"


	ADD OBJECT base_transac.pgfdetalle.page1.lblstatus1 AS base_label WITH ;
		FontBold = .F., ;
		FontSize = 20, ;
		Caption = "", ;
		Height = 35, ;
		Left = 333, ;
		Top = 9, ;
		Visible = .T., ;
		Width = 2, ;
		TabIndex = 7, ;
		ForeColor = RGB(0,0,160), ;
		ZOrderSet = 11, ;
		Name = "lblStatus1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle AS base_grid WITH ;
		ColumnCount = 8, ;
		Height = 30, ;
		Left = 11, ;
		Panel = 1, ;
		TabIndex = 1, ;
		Top = 283, ;
		Visible = .F., ;
		Width = 54, ;
		GridLineColor = RGB(192,192,192), ;
		Name = "grdDetalle", ;
		Column1.ControlSource = "", ;
		Column1.Width = 80, ;
		Column1.Visible = .F., ;
		Column1.Name = "Column3", ;
		Column2.CurrentControl = "Text1", ;
		Column2.Width = 250, ;
		Column2.Visible = .F., ;
		Column2.Name = "Column4", ;
		Column3.Width = 28, ;
		Column3.Visible = .F., ;
		Column3.Name = "Column5", ;
		Column4.Width = 76, ;
		Column4.Visible = .F., ;
		Column4.Name = "Column6", ;
		Column5.Width = 59, ;
		Column5.Visible = .F., ;
		Column5.Name = "Column7", ;
		Column6.Width = 95, ;
		Column6.Visible = .F., ;
		Column6.Name = "Column8", ;
		Column7.Visible = .F., ;
		Column7.Name = "Column1", ;
		Column8.Width = 84, ;
		Column8.Visible = .F., ;
		Column8.Name = "Column2"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column3.header1 AS header WITH ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column3.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column4.header1 AS header WITH ;
		Caption = "Descripción ", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column4.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column5.header1 AS header WITH ;
		Caption = "Und", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column5.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column6.header1 AS header WITH ;
		Caption = "Cantidad", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column6.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column7.header1 AS header WITH ;
		Caption = "Prec.Uni.", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column7.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column8.header1 AS header WITH ;
		Caption = "Importe", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column8.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column1.header1 AS header WITH ;
		Caption = "# Lote", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column2.header1 AS header WITH ;
		Caption = "FchVto", ;
		Name = "Header1"


	ADD OBJECT base_transac.pgfdetalle.page2.grddetalle.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpbrt AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 513, ;
		TabIndex = 2, ;
		Top = 220, ;
		Visible = .F., ;
		Width = 86, ;
		Name = "TxtImpBrt"


	ADD OBJECT base_transac.pgfdetalle.page2.cmdadicionar1 AS cmdnuevo WITH ;
		Top = 283, ;
		Left = 119, ;
		Height = 34, ;
		Enabled = .F., ;
		TabIndex = 12, ;
		PicturePosition = 7, ;
		ZOrderSet = 2, ;
		codigoboton = ("00001809"), ;
		Name = "cmdAdicionar1"


	ADD OBJECT base_transac.pgfdetalle.page2.cmdmodificar1 AS cmdmodificar WITH ;
		Top = 283, ;
		Left = 167, ;
		Height = 34, ;
		Enabled = .F., ;
		TabIndex = 13, ;
		PicturePosition = 7, ;
		ZOrderSet = 3, ;
		codigoboton = ("00001810"), ;
		Name = "Cmdmodificar1"


	ADD OBJECT base_transac.pgfdetalle.page2.cmdeliminar1 AS cmdeliminar WITH ;
		Top = 283, ;
		Left = 215, ;
		Height = 34, ;
		Enabled = .F., ;
		TabIndex = 14, ;
		PicturePosition = 7, ;
		ZOrderSet = 4, ;
		codigoboton = ("00001812"), ;
		Name = "Cmdeliminar1"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 505, ;
		TabIndex = 10, ;
		Top = 263, ;
		Visible = .F., ;
		Width = 96, ;
		Name = "TxtImpIgv"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimptot AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 12, ;
		Enabled = .F., ;
		Height = 26, ;
		InputMask = "999,999.9999", ;
		Left = 505, ;
		TabIndex = 11, ;
		Top = 284, ;
		Visible = .F., ;
		Width = 96, ;
		ForeColor = RGB(255,0,0), ;
		Name = "TxtImpTot"


	ADD OBJECT base_transac.pgfdetalle.page2.txtporigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 10, ;
		ReadOnly = .T., ;
		TabIndex = 5, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 86, ;
		Name = "txtPorIgv"


	ADD OBJECT base_transac.pgfdetalle.page2.lblsubtot AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Importe Bruto", ;
		Height = 16, ;
		Left = 417, ;
		Top = 223, ;
		Visible = .F., ;
		TabIndex = 21, ;
		Name = "LblSubTot"


	ADD OBJECT base_transac.pgfdetalle.page2.lbligv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "I.G.V.", ;
		Height = 16, ;
		Left = 470, ;
		Top = 267, ;
		Visible = .F., ;
		TabIndex = 26, ;
		Name = "LblIgv"


	ADD OBJECT base_transac.pgfdetalle.page2.lbltotal AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 12, ;
		Caption = "TOTAL", ;
		Left = 445, ;
		Top = 290, ;
		Visible = .F., ;
		TabIndex = 28, ;
		ForeColor = RGB(255,0,0), ;
		Name = "LblTotal"


	ADD OBJECT base_transac.pgfdetalle.page2.lblporigv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "% I.G.V.", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 42, ;
		TabIndex = 20, ;
		Name = "LblPorIgv"


	ADD OBJECT base_transac.pgfdetalle.page2.txtnroitm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 59, ;
		MousePointer = 0, ;
		TabIndex = 16, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 44, ;
		Name = "TxtNroItm"


	ADD OBJECT base_transac.pgfdetalle.page2.txtnro_itm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		HelpContextID = 20, ;
		InputMask = "999.99", ;
		Left = 7, ;
		MousePointer = 0, ;
		TabIndex = 15, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 43, ;
		Name = "txtNro_itm"


	ADD OBJECT base_transac.pgfdetalle.page2.base_label5 AS base_label WITH ;
		Caption = "\", ;
		Height = 17, ;
		Left = 52, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 5, ;
		TabIndex = 18, ;
		Name = "Base_label5"


	ADD OBJECT base_transac.pgfdetalle.page2.txtpordto AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 10, ;
		TabIndex = 3, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 86, ;
		Name = "TxtPorDto"


	ADD OBJECT base_transac.pgfdetalle.page2.lblpordto AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "% Dcto.", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 41, ;
		TabIndex = 19, ;
		Name = "LblPorDto"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpdto AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 514, ;
		TabIndex = 4, ;
		Top = 241, ;
		Visible = .F., ;
		Width = 86, ;
		Name = "TxtImpDto"


	ADD OBJECT base_transac.pgfdetalle.page2.lblimpdto AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Descuentos", ;
		Height = 16, ;
		Left = 430, ;
		Top = 247, ;
		Visible = .F., ;
		TabIndex = 22, ;
		Name = "LblImpDto"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpint AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 9, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 84, ;
		Name = "TxtImpInt"


	ADD OBJECT base_transac.pgfdetalle.page2.lblimpint AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Gto. Financiero", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		TabIndex = 27, ;
		Name = "lblImpInt"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpvta AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 17, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 91, ;
		Name = "txtImpVta"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpflt AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 6, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 82, ;
		Name = "TxtImpFlt"


	ADD OBJECT base_transac.pgfdetalle.page2.lblimpflt AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Flete", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		TabIndex = 25, ;
		Name = "LblImpFlt"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpseg AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 7, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 82, ;
		Name = "TxtImpSeg"


	ADD OBJECT base_transac.pgfdetalle.page2.txtimpadm AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 8, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 82, ;
		Name = "TxtImpAdm"


	ADD OBJECT base_transac.pgfdetalle.page2.lblimpseg AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Seguro", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		TabIndex = 24, ;
		Name = "LblImpSeg"


	ADD OBJECT base_transac.pgfdetalle.page2.base_label1 AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		WordWrap = .F., ;
		Caption = "Gto. Administrativo", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 108, ;
		TabIndex = 23, ;
		Name = "Base_label1"


	ADD OBJECT base_transac.pgfdetalle.page2.lblimpadm AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Administracion", ;
		Height = 16, ;
		Left = 18, ;
		Top = 298, ;
		Visible = .F., ;
		TabIndex = 25, ;
		Name = "LblImpAdm"


	ADD OBJECT base_transac.pgfdetalle.page3.cmdaceptar2 AS cmdaceptar WITH ;
		Top = 235, ;
		Left = 503, ;
		Height = 35, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 9, ;
		codigoboton = ("00001813"), ;
		Name = "Cmdaceptar2"


	ADD OBJECT base_transac.pgfdetalle.page3.cmdcancelar2 AS cmdcancelar WITH ;
		Top = 235, ;
		Left = 563, ;
		Height = 35, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 10, ;
		codigoboton = ("00001814"), ;
		Name = "Cmdcancelar2"


	ADD OBJECT base_transac.pgfdetalle.page3.txtcodmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "R!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 1, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtCodmat"


	ADD OBJECT base_transac.pgfdetalle.page3.txtdesmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 0, ;
		TabIndex = 3, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 314, ;
		Name = "TxtDesmat"


	ADD OBJECT base_transac.pgfdetalle.page3.base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Código", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 35, ;
		TabIndex = 11, ;
		Name = "Base_label1"


	ADD OBJECT base_transac.pgfdetalle.page3.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Descripción", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 59, ;
		TabIndex = 12, ;
		Name = "Base_label2"


	ADD OBJECT base_transac.pgfdetalle.page3.lblund AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Und.", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 24, ;
		TabIndex = 13, ;
		Name = "LblUnd"


	ADD OBJECT base_transac.pgfdetalle.page3.lblcantidad AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cantidad", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 44, ;
		TabIndex = 15, ;
		Name = "LblCantidad"


	ADD OBJECT base_transac.pgfdetalle.page3.lblpreuni AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Precio Unitario", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 71, ;
		TabIndex = 16, ;
		Name = "LblPreUni"


	ADD OBJECT base_transac.pgfdetalle.page3.lblimpcto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Importe", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 37, ;
		TabIndex = 17, ;
		Name = "LblImpCto"


	ADD OBJECT base_transac.pgfdetalle.page3.txtundstk AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 10, ;
		TabIndex = 14, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 33, ;
		Name = "TxtUndStk"


	ADD OBJECT base_transac.pgfdetalle.page3.txtcandes AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 4, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtCanDes"


	ADD OBJECT base_transac.pgfdetalle.page3.txtpreuni AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 10, ;
		TabIndex = 5, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 84, ;
		Name = "TxtPreUni"


	ADD OBJECT base_transac.pgfdetalle.page3.txtimpcto AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.99", ;
		Left = 10, ;
		TabIndex = 6, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtImpCto"


	ADD OBJECT base_transac.pgfdetalle.page3.txtfchvto AS base_textbox_fecha WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 10, ;
		TabIndex = 8, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 96, ;
		Name = "TxtFchVto"


	ADD OBJECT base_transac.pgfdetalle.page3.lbllote AS base_label WITH ;
		FontSize = 8, ;
		Caption = "# Lote", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 32, ;
		TabIndex = 19, ;
		Name = "LblLote"


	ADD OBJECT base_transac.pgfdetalle.page3.lblfchvto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha Vcmto.", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 69, ;
		TabIndex = 18, ;
		Name = "LblFchVto"


	ADD OBJECT base_transac.pgfdetalle.page3.txtlote AS base_textbox_texto WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 10, ;
		TabIndex = 7, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 96, ;
		Name = "TxtLote"


	ADD OBJECT base_transac.pgfdetalle.page3.cmdhelplote AS base_cmdhelp WITH ;
		Top = 290, ;
		Left = 10, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		Visible = .F., ;
		ccamposfiltro = "CodMat", ;
		cnombreentidad = "v_materiales_x_lote", ;
		ccamporetorno = "Lote", ;
		caliascursor = "c_MatLote", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpLote"


	ADD OBJECT base_transac.pgfdetalle.page3.cmdhelpcodigo AS base_cmdhelp WITH ;
		Top = 290, ;
		Left = 10, ;
		Height = 20, ;
		Width = 24, ;
		Picture = "..\..\grafgen\iconos\help_dots.bmp", ;
		DisabledPicture = "..\..\grafgen\iconos\buscar16_disable.bmp", ;
		Enabled = .F., ;
		Visible = .F., ;
		DisabledForeColor = RGB(0,128,0), ;
		cvaloresfiltro = ([N/D]), ;
		ccamposfiltro = "Tabla", ;
		cnombreentidad = "cbdmtabl", ;
		ccamporetorno = "Codigo", ;
		caliascursor = "c_Codigo", ;
		ccampovisualizacion = "NomBre", ;
		Name = "CmdHelpCodigo"


	ADD OBJECT base_transac.pgfdetalle.page3.cmdhelpcodmat AS base_cmdhelp WITH ;
		Top = 290, ;
		Left = 10, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		Visible = .F., ;
		cvaloresfiltro = "GoCfgAlm.Subalm", ;
		ccamposfiltro = "SubAlm", ;
		cnombreentidad = "v_materiales_x_almacen_2", ;
		ccamporetorno = "CodMat", ;
		caliascursor = "c_MatAlm", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpCodMat"


	ADD OBJECT base_transac.pgfdetalle.page3.txtcodigo AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "R!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 1, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtCodigo"


	ADD OBJECT base_transac.pgfdetalle.page4.cmdaceptar3 AS cmdaceptar WITH ;
		Top = 206, ;
		Left = 502, ;
		Height = 35, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 14, ;
		Name = "Cmdaceptar3"


	ADD OBJECT base_transac.pgfdetalle.page4.cmdcancelar3 AS cmdcancelar WITH ;
		Top = 205, ;
		Left = 562, ;
		Height = 35, ;
		Width = 48, ;
		FontName = "Verdana", ;
		FontSize = 8, ;
		Enabled = .F., ;
		TabIndex = 15, ;
		Name = "Cmdcancelar3"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Código", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 35, ;
		TabIndex = 2, ;
		Name = "Base_label1"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Razón Social", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 65, ;
		TabIndex = 4, ;
		Name = "Base_label2"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dirección", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 47, ;
		TabIndex = 6, ;
		Name = "Base_label3"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label4 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "R.U.C.", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 32, ;
		TabIndex = 10, ;
		Name = "Base_label4"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label5 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Placa del Vehículo", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 90, ;
		TabIndex = 8, ;
		Name = "Base_label5"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label6 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Brevete", ;
		Height = 16, ;
		Left = 10, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 40, ;
		TabIndex = 12, ;
		Name = "Base_label6"


	ADD OBJECT base_transac.pgfdetalle.page4.base_shape1 AS base_shape WITH ;
		Top = 31, ;
		Left = 22, ;
		Height = 145, ;
		Width = 25, ;
		Name = "Base_shape1"


	ADD OBJECT base_transac.pgfdetalle.page4.base_label_shape1 AS base_label_shape WITH ;
		FontBold = .T., ;
		Caption = "Datos Adicionales", ;
		Height = 17, ;
		Left = 40, ;
		Top = 24, ;
		Width = 142, ;
		TabIndex = 1, ;
		Name = "Base_label_shape1"


	ADD OBJECT base_transac.pgfdetalle.page4.txtnomtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 5, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 236, ;
		Name = "TxtNomtra"


	ADD OBJECT base_transac.pgfdetalle.page4.txtcodtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 3, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtCodTra"


	ADD OBJECT base_transac.pgfdetalle.page4.txtdirtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 7, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 236, ;
		Name = "TxtDirTra"


	ADD OBJECT base_transac.pgfdetalle.page4.txtructra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 11, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtRucTra"


	ADD OBJECT base_transac.pgfdetalle.page4.txtplatra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 9, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtPlaTra"


	ADD OBJECT base_transac.pgfdetalle.page4.txtbrevet AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 23, ;
		Left = 10, ;
		MaxLength = 8, ;
		TabIndex = 13, ;
		Top = 290, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtBreVet"


	ADD OBJECT cmdsalir AS cmdsalir WITH ;
		Top = 362, ;
		Left = 492, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 11, ;
		PicturePosition = 7, ;
		Name = "Cmdsalir"


	ADD OBJECT cmdimprimir AS cmdimprimir WITH ;
		Top = 362, ;
		Left = 435, ;
		Height = 40, ;
		Width = 48, ;
		Caption = "\<Imprimir", ;
		Enabled = .F., ;
		TabIndex = 10, ;
		ToolTipText = "Imprimir ", ;
		PicturePosition = 7, ;
		codigoboton = ("00002313"), ;
		Name = "Cmdimprimir"


	ADD OBJECT cmdgrabar AS cmdgrabar WITH ;
		Top = 360, ;
		Left = 288, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 8, ;
		PicturePosition = 7, ;
		ZOrderSet = 29, ;
		codigoboton = ("00001055"), ;
		Name = "Cmdgrabar"


	ADD OBJECT lblstatus AS base_label WITH ;
		AutoSize = .F., ;
		FontBold = .T., ;
		FontName = "Tahoma", ;
		FontSize = 10, ;
		Alignment = 2, ;
		BackStyle = 1, ;
		Caption = "Mensaje de Status", ;
		Height = 19, ;
		Left = -15, ;
		Top = 399, ;
		Visible = .T., ;
		Width = 676, ;
		TabIndex = 21, ;
		ForeColor = RGB(0,255,0), ;
		BackColor = RGB(0,0,0), ;
		ZOrderSet = 28, ;
		Name = "lblStatus"


	ADD OBJECT lblobserv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Contabilidad", ;
		Left = 19, ;
		Top = 379, ;
		TabIndex = 9, ;
		ZOrderSet = 9, ;
		Name = "LblObserv"


	ADD OBJECT txtestadocontab AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 83, ;
		TabIndex = 3, ;
		Top = 374, ;
		Visible = .T., ;
		Width = 180, ;
		ZOrderSet = 8, ;
		Name = "TxtEstadoContab"


	PROCEDURE iniciar_var
		LnMem = SYS(1104)
		WITH THISFORM
			thisform.lIgnora_id_correlativo = .F.
			.desvincular_controles
			IF VARTYPE(this.objcntcab) = 'O'
				this.objcntcab.iniciar_var()
			    *this.objcntcab.Limpiar_var()
		    ENDIF
			IF VARTYPE(this.objcntpage) = 'O'    
				this.objcntpage.iniciar_var()
			    this.objcntpage.Limpiar_var()
		    ENDIF
		    
			with thisform.pgfdetalle.page1
				.txtNroDoc.ENABLED		= .F. 
				.cmdHelpNroDoc.ENABLED	= .F.
				.txtFchDoc.ENABLED		= .F.
		*!*			.TxtTpoCmb.ENABLED		= .F.
				.TxtObserv.ENABLED		= .F.

		*!*			.CboCodMon.ENABLED 		= .F.

				.LblStatus1.Caption		= ''
				.LblStatus2.Caption		= ''
				.LblNroDoc.Visible 		= .T. AND !INLIST(.txtNroDoc.Tag,'X')
				.LblFchDoc.Visible 		= .T. AND !INLIST(.txtNroDoc.Tag,'X')
				.LblObserv.Visible 		= .T. AND !INLIST(.txtNroDoc.Tag,'X')

				.txtNroDoc.VISIBLE		= .T. AND !INLIST(.txtNroDoc.Tag,'X')
				.txtFchDoc.VISIBLE		= .T. AND !INLIST(.txtNroDoc.Tag,'X')
				.TxtObserv.VISIBLE		= .T. AND !INLIST(.txtNroDoc.Tag,'X')

		*!*			.TxtTpoCmb.VISIBLE		= .T.
		*!*			.CboCodMon.VISIBLE		= .T.


		*!*			.LblCodMon.VISIBLE		= .t.

		*!*			.LblTpoCmb.VISIBLE		= .t.

				.cmdadicionar.ENABLED	= .T.
				.cmdModificar.ENABLED	= .T.
				.cmdEliminar.ENABLED	= .T.

			endwith
		    *

		    
			with thisform.pgfdetalle.page2
				.TxtPorIgv.VISIBLE	= .F.
				.txtImpBrt.VISIBLE	= .F.
				.txtImpIgv.VISIBLE  = .F.
				.txtImpTot.VISIBLE	= .F.
				.txtPorDto.ViSible   = .F.
				.txtImpDto.Visible	= .F.
				.txtImpInt.Visible	= .f.
				.TxtImpFlt.Visible	= .F.
				.TxtImpSeg.Visible	= .f.
				.TxtImpAdm.Visible	= .F.

				**
				.LblPorIgv.VISIBLE	= .f.
				.LblSubTot.VISIBLE	= .f.
				.LblIgv.VISIBLE		= .f.
				.LblTotal.VISIBLE	= .f.
				.LblPorDto.ViSible  = .F.
				.LblImpDto.Visible	= .F.
				.LblImpInt.Visible	= .f.
				.LblImpFlt.Visible	= .F.
				.LblImpSeg.Visible	= .f.
				.LblImpAdm.Visible	= .F.

				**
				.cmdadicionar1.ENABLED	= .F.
				.cmdModificar1.ENABLED	= .F.
				.cmdEliminar1.ENABLED	= .F.
			endwith
			*
			EXTERNAL ARRAY GaLencod
			WITH thisform.PgfDetalle.Page3
				.TxtCodmat.MaxLength = GaLenCod(3) 
				.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod(3)-GnLenDiv)
				.TxtPreuni.VISIBLE = .f.
				.TxtImpCto.VISIBLE = .f.
				.LblPreuni.VISIBLE = .f.
				.LblImpCto.VISIBLE = .f.
			ENDWITH

		    THISFORM.LIMPIAR_VAR()

			.CmdSalir.ENABLED 		= .T.
			.CmdGrabar.ENABLED 		= .F.
			.CmdIniciar.ENABLED		= .F.

		ENDWITH
		IF VARTYPE(THIS.ObjRefTran) = 'O'
			=this.objreftran.inicializavariablesCFG()
			THIS.ObjRefTran.Que_Transaccion = THISFORM.Que_transaccion 
			THIS.objreftran.CodSed		= 	GsCodSed
			this.objreftran.subalm		=	GsSubAlm 
			THIS.ObjRefTran.XsTpoDoc	=	thisform.TpoDoc  
			this.ObjReftran.cCursor_C	=	thisform.ccursor_C 
			this.ObjReftran.cCursor_D	=	thisform.ccursor_D 
			this.ObjReftran.caliascab 	=	thisform.caliascab 
			this.ObjReftran.caliasdet 	=	thisform.caliasdet
		ENDIF
		IF VARTYPE(THIS.objcntcab) = 'O'	AND	VARTYPE(THIS.ObjRefTran) = 'O' 
			THIS.ObjRefTran.EntidadCorrelativo	= thisform.ObjCntCab.EntidadCorrelativo
		ENDIF

		IF VARTYPE(THIS.objcntcab) = 'O'
			THIS.objcntcab.habilita
			WITH thisform.objcntcab 
				.CboCodDoc.Value = THISFORM.ObjRefTran.XsCodDoc
				.CboTipoFact.ListIndex = THISFORM.ObjRefTran.XnTpoFac
				.CboTipoFact.InteractiveChange()
			ENDWITH 
		ENDIF
		thisform.LblStatus.Caption  = 'Listo para realizar transacción'
		thisform.TxtEstadoContab.Value = ''
		DO CASE 
			CASE This.que_transaccion = 'MTTO' 
				thisform.objreftran.EntidadCorrelativo = 'CPICDOCM'

		ENDCASE 
	ENDPROC


	PROCEDURE vincular_controles
		LOCAL LcAlmacen,LcTipMov,LcCodMov,LcNroDoc,LcTabla,LlExiste
		PUBLIC LoDa
		LoDa = CREATEOBJECT('FPDOSVR.DataAdmin') 
		WITH THISFORM

			DO CASE 
				CASE INLIST(thisform.que_transaccion ,'MTTO_O_T','MTTO_ACTI')

					thisform.SetDataSource()
					thisform.capcontrolcab()  
					WITH THISFORM.PgfDetalle.page1
						IF !INLIST(.TxtNroDoc.TAG , 'X')
							.TxtNroDoc.Value = PADR(.TxtNroDoc.Value,LEN(EVALUATE(thisform.cAliasCab+'.'+thisform.cCampo_id )))
							thisform.objreftran.XsNroDoc = .txtnrodoc.value
						ENDIF

						** Preparamos Cursor del Detalle ** 

						WITH thisform
							.cvalor_pk = .Traervalor_pk()
							LoDa.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
						ENDWITH

						IF THISFORM.xReturn = 'I'   		&& Nuevo Registro
							IF !INLIST(.TxtNroDoc.TAG , 'X')
								THISFORM.OBJREFTRAN.CFGVAR_ID(thisform.objreftran.EntidadCorrelativo)
								IF !this.lignora_id_correlativo 
									.txtnrodoc.value=THISFORM.OBJREFTRAN.GEN_id('0') 
								ENDIF
								IF val(.txtnrodoc.value)<=0
									=messagebox('No existe correlativo definido para este documento, verificar maestro de correlativos',16,'Correlativo sin definir')
									RELEASE LoDa
									RETURN .f.
								ENDIF
							ENDIF
							thisform.tools.closetable(this.cCursor_D )
							thisform.objreftran.XsNroDoc = .txtnrodoc.value
							thisform.cvalor_pk = thisform.Traervalor_pk()
							WITH thisform
								LoDa.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
							ENDWITH
						ENDIF
						*
						IF !INLIST(.TxtNroDoc.TAG , 'X')
							IF val(.txtnrodoc.value)=0
								RELEASE LoDa
								RETURN .f.
							ENDIF
						ENDIF

						thisform.objreftran.XsNroDoc = trim(.txtnrodoc.value)
						** Preparamos Cursor de la cabecera ** 

						LoDa.GenCursor(this.cCursor_C ,this.cTabla_C ,this.cindice_pk ,tHIS.ccampos_pk,this.cValor_PK)
						IF INLIST(thisform.xreturn ,'A','E')
							IF THISFORM.Tools.cursor_esta_vacio(this.cCursor_C)	&& No existe Nro. de documento
								=MESSAGEBOX('No existe Nro. de documento',64,'Atención')
								RELEASE LoDa
								RETURN .f.
							ENDIF
						ENDIF
						thisform.Desvincular_Controles()
						thisform.PgfDetalle.Page1.CmdHelpNrodoc.Enabled=.F.
						** Capturamos la configuracion de transacciones para el tipo y codigo de la configuración en ALMCFTRA

						IF THISFORM.xReturn <> 'I'   		&& Nuevo Registro

							.TxtFchDoc.Value 	=	EVALUATE(this.cCursor_C+'.Fech_Ord') && IIF(!INLIST(.TxtFchDoc.TAG , 'X'),'',EVALUATE(this.cCursor_C+'.Fech_Ord') )

							.TxtObserv.VALUE 	=	EVALUATE(this.cCursor_C+'.Observac') &&IIF(!INLIST(.TxtObserv.TAG , 'X'),'',EVALUATE(this.cCursor_C+'.Observac') )

							WITH thisform.objcntpage 

		*!*							DO CASE 

									IF INLIST(thisform.que_transaccion ,'MTTO_O_T','MTTO_ACTI')
										.CboTipAct.Value		= 	EVALUATE(this.cCursor_C+'.CodigoTA')
										.CboTipMaqui.Value		= 	EVALUATE(this.cCursor_C+'.CodigoTM')
										.CboTipMaqui.Valid()
										.CboCodMaq.Value		= 	EVALUATE(this.cCursor_C+'.CodMaq')

										.CboCodMaq.InteractiveChange()
									ENDIF

									IF INLIST(thisform.que_transaccion ,'MTTO_ACTI')


									ENDIF

									IF INLIST(thisform.que_transaccion ,'MTTO_O_T')
										.TxtTpoCmb.VALUE	 	=	EVALUATE(this.cCursor_C+'.TpoCmb')
										.CboCodMon.VALUE	 	=	EVALUATE(this.cCursor_C+'.CodMon')
										.CboCodPro.VALUE	 	=	EVALUATE(this.cCursor_C+'.CodPro')
										.CboCodPro.InteractiveChange()

										.TxtFech_Ent.VALUE		=   EVALUATE(this.cCursor_C+'.Fech_Ent')
										.TxtNro_O_C.VALUE		=	EVALUATE(this.cCursor_C+'.Nro_O_C')
										.CboTip_Man.Value		= 	EVALUATE(this.cCursor_C+'.Tip_Man')
										.TxtImpNac.Value		= 	EVALUATE(this.cCursor_C+'.ImpNac')
										.TxtImpUsa.VALUE		=	EVALUATE(this.cCursor_C+'.ImpUsa')
										.TxtAutorizado.Value	= 	EVALUATE(this.cCursor_C+'.Autorizado')
										.CboParametro.Value	    =   EVALUATE(this.cCursor_C+'.Parametro')
									ENDIF


		*!*							ENDCASE
								** Actualizamos objeto de transacciones ** ¿¿!!! Revisar cuando se haga COM¡¡¡¡???
								THISFORM.Objreftran.XsNroRef = "" &&.TxtNroRef.Value
							ENDWITH
							IF VARTYPE(thisform.objcntcab) = 'O'
								WITH thisform.objcntcab 

								ENDWITH 
							ENDIF

						ELSE
							** Valores por defecto
							WITH thisform.objcntpage 

							ENDWITH

						ENDIF


					ENDWITH
					** Configuración de controles condicionados en pagina de la cabecera
					IF VARTYPE(thisform.objcntcab) = 'O'
						WITH thisform.objcntpage 
								** Si hay algo activar o desencadenar en este contenedor hazlo aqui

						ENDWITH
					ENDIF
					WITH thisform.PgfDetalle.Page2
					ENDWITH

				CASE thisform.que_transaccion = 'VENTAS'
					thisform.SetDataSource()
					thisform.capcontrolcab()  
					WITH THISFORM.PgfDetalle.page1

						.TxtNroDoc.Value = PADR(.TxtNroDoc.Value,LEN(EVALUATE(thisform.cAliasCab+'.'+thisform.cCampo_id )))
						thisform.objreftran.XsNroDoc = .txtnrodoc.value
						** Preparamos Cursor del Detalle ** 

						WITH thisform
							.cvalor_pk = .Traervalor_pk()
							LoDa.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
						ENDWITH

						IF THISFORM.xReturn = 'I'   		&& Nuevo Registro

							**LoDa.correlativo(LcTabla,LcCmps,LcVlrs,LcCmpId,LnLenId,.T.,0,'0')
							THISFORM.OBJREFTRAN.CFGVAR_ID(thisform.objreftran.EntidadCorrelativo)
							IF !this.lignora_id_correlativo 
								.txtnrodoc.value=THISFORM.OBJREFTRAN.GEN_id('0') 
							ENDIF
							IF val(.txtnrodoc.value)<=0
								=messagebox('No existe correlativo definido para este documento, verificar maestro de correlativos',16,'Correlativo sin definir')
								RELEASE LoDa
								RETURN .f.
							ENDIF
							  
							thisform.tools.closetable(this.cCursor_D )
							thisform.objreftran.XsNroDoc = .txtnrodoc.value
							thisform.cvalor_pk = thisform.Traervalor_pk()
							WITH thisform
								LoDa.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
							ENDWITH
						ENDIF
						*
						IF val(.txtnrodoc.value)=0
							RELEASE LoDa
							RETURN .f.
						ENDIF

						thisform.objreftran.XsNroDoc = trim(.txtnrodoc.value)
						** Preparamos Cursor de la cabecera ** 

						LoDa.GenCursor(this.cCursor_C ,this.cTabla_C ,'GDOC01',tHIS.ccampos_pk,this.cValor_PK)
						IF INLIST(thisform.xreturn ,'A','E')
							IF THISFORM.Tools.cursor_esta_vacio(this.cCursor_C)	&& No existe Nro. de documento
								=MESSAGEBOX('No existe Nro. de documento',64,'Atención')
								RELEASE LoDa
								RETURN .f.
							ENDIF
						ENDIF
						thisform.Desvincular_Controles()
						thisform.PgfDetalle.Page1.CmdHelpNrodoc.Enabled=.F.
						** Capturamos la configuracion de transacciones para el tipo y codigo de la configuración en ALMCFTRA

						=thisform.objreftran.CapTipMovAlm(thisform.objreftran.EntidadCorrelativo,THIS.cCmps_Id,THIS.cValor_ID)

						*** Facturacion por diferentes movimientos de almacen enlazados a un solo documento de Ventas
						LOCAL LsCodMov,LnPosComilla
						LnPosComilla= AT('"',thisform.objreftran.sCodMov)   && Parche de emergencia VETT 12/09/2003
						LsCodMov = thisform.objreftran.sCodMov
						LsCodMov = IIF(LnPosComilla>0,SUBSTR(LsCodMov,LnPosComilla+1,3),LsCodMov)
						=thisform.objreftran.Cap_Cfg_Transacciones(thisform.ObjRefTran.cTipMov,LsCodMov)
						thisform.pgfDetalle.page3.cmdHelpCodMat.cvaloresfiltro = thisform.ObjRefTran.SubAlm
						**
						** Contabilidad ***
						THISFORM.XsNroMes = EVALUATE(this.cCursor_C+'.NroMes')
						THISFORM.XsCodOpe = EVALUATE(this.cCursor_C+'.CodOpe')
						THISFORM.Xsnroast = EVALUATE(this.cCursor_C+'.NroAst')
						**
						IF THISFORM.xReturn <> 'I'   		&& Nuevo Registro

							.TxtFchDoc.Value 	=	EVALUATE(this.cCursor_C+'.FchDoc')
							.TxtObserv.VALUE 	=	EVALUATE(this.cCursor_C+'.Glodoc')
							WITH thisform.objcntpage 
								.TxtTpoCmb.VALUE 	=	EVALUATE(this.cCursor_C+'.TpoCmb')
								.CboCodMon.VALUE 	=	EVALUATE(this.cCursor_C+'.CodMon')
								.CboCodCli.VALUE 	=	EVALUATE(this.cCursor_C+'.CodCli')
							*	.TxtDirAux.VALUE	= 	EVALUATE(this.cCursor_C+'.DirCli')
								.CboCodCli.InteractiveChange()
								.CboCodDire.VALUE   = 	EVALUATE(this.cCursor_C+'.CodDire')
								.TxtNroRef.Value	= 	EVALUATE(this.cCursor_C+'.NroRef')

								.TxtRucAux.VALUE	=	EVALUATE(this.cCursor_C+'.RucCli')
								.TxtNroPed.VALUE	=   EVALUATE(this.cCursor_C+'.NroPed')
			*					.TxtFchPed.VALUE	=   EVALUATE(this.cCursor_C+'.FchPed')
								.TxtNroO_C.VALUE	=	EVALUATE(this.cCursor_C+'.NroO_C')
								.TxtFchO_C.VALUE	=	EVALUATE(this.cCursor_C+'.FchO_C')
								.CboFmaPgo.Value	= 	EVALUATE(this.cCursor_C+'.FmaPgo')
								.TxtCndPgo.Value	= 	EVALUATE(this.cCursor_C+'.CndPgo')
								.SpnDiaVto.VALUE	=	EVALUATE(this.cCursor_C+'.DiaVto')
								.CboTpoVta.Value	= 	STR(EVALUATE(this.cCursor_C+'.TpoVta'),1,0)
								.CboDestino.Value   =   EVALUATE(this.cCursor_C+'.Destino')
								.CboVia.Value		=	EVALUATE(this.cCursor_C+'.Via') 

								** Actualizamos objeto de transacciones ** ¿¿!!! Revisar cuando se haga COM¡¡¡¡???
								THISFORM.Objreftran.XsNroRef = .TxtNroRef.Value
							ENDWITH
							IF VARTYPE(thisform.objcntcab) = 'O'
								WITH thisform.objcntcab 
									.cboPtoVTa.value = LEFT(EVALUATE(this.cCursor_C+'.nrodoc'),3)
									.CboCodDoc.Value = EVALUATE(this.cCursor_C+'.CodDoc')
									.CboCodVen.Value = EVALUATE(this.cCursor_C+'.CodVen')
								ENDWITH 
							ENDIF
						ELSE

							WITH thisform.objcntpage 
								.CboTpoVta.Value	= 	STR(THISFORM.ObjRefTran.XnTpoVta,1,0)
								.CboFmaPgo.Value	= 	THISFORM.ObjRefTran.XiFmaPgo
								.CboVia.Value		=   THISFORM.ObjRefTran.XcVia
								.CboDestino.Value	=   THISFORM.ObjRefTran.XcDestino
								.CboCodVia.Value	=	thisform.ObjReftran.XsCodVia
							ENDWITH

						ENDIF


					ENDWITH
					** Configuración de controles condicionados en pagina de la cabecera
					WITH thisform.objcntpage 
						.CboDestino.InteractiveChange()
					ENDWITH

					WITH thisform.PgfDetalle.Page2
						.TxtNroItm.Value	= EVALUATE(THISFORM.cCursor_C+'.NroItm')
						.TxtPorIgv.Value	= EVALUATE(THISFORM.cCursor_C+'.PorIgv')
						.txtImpBrt.Value	= EVALUATE(THISFORM.cCursor_C+'.ImpBto')   && NEW_VETT Falta arreglar 190303
						.txtImpIgv.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpIgv')
						.txtImpTot.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpTot')
						.TxtImpDto.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpDto')
						.TxtPorDto.VALUE	= EVALUATE(THISFORM.cCursor_C+'.PorDto')
						.TxtImpInt.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpInt')
						.TxtImpFlt.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpFlt')
						.TxtImpSeg.Value 	= EVALUATE(THISFORM.cCursor_C+'.ImpSeg')
						.TxtImpAdm.VALUE	= EVALUATE(THISFORM.cCursor_C+'.ImpAdm')
						thisform.ObjReftran.XfPorDto = .TxtPorDto.VALUE
						thisform.Objreftran.XfImpInt = .TxtImpInt.VALUE
						thisform.Objreftran.XfImpFlt = .TxtImpFlt.Value 
						thisform.Objreftran.XfImpSeg = .TxtImpSeg.Value
						thisform.Objreftran.XfImpAdm = .TxtImpAdm.Value

						**
			*			.TxtPorIgv.ENABLED 	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta) AND THISFORM.xReturn <> "E"
						**
						.TxtPorIgv.VISIBLE	= .t.   &&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpBrt.VISIBLE	= .t.   &&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpIgv.VISIBLE	= .T.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpTot.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.TxtImpDto.VISIBLE  = thisform.objreftran.lCtoVta
						.TXtPorDto.VISIBLE  = thisform.objreftran.lCtoVta
						.TxtImpInt.VISIBLE  = thisform.objreftran.lCtoVta
						.TxtImpFlt.VISIBLE  = thisform.objreftran.lCtoVta
						.TxtImpSeg.VISIBLE  = thisform.objreftran.lCtoVta
						.TxtImpAdm.VISIBLE  = thisform.objreftran.lCtoVta
						**
						.LblPorIgv.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblSubTot.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblIgv.VISIBLE		= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblTotal.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblImpDto.VISIBLE  = thisform.objreftran.lCtoVta
						.LblPorDto.VISIBLE  = thisform.objreftran.lCtoVta
						.LblImpInt.VISIBLE  = thisform.objreftran.lCtoVta
						.LblImpFlt.VISIBLE  = thisform.objreftran.lCtoVta
						.LblImpSeg.VISIBLE  = thisform.objreftran.lCtoVta
						.LblImpAdm.VISIBLE  = thisform.objreftran.lCtoVta
						**
						.TxtImpInt.ENABLED  = thisform.objreftran.lCtoVta
						.TXtPorDto.ENABLED  = thisform.objreftran.lCtoVta
						.TxtImpFlt.ENABLED	= thisform.objreftran.lCtoVta
						.TxtImpSeg.ENABLED  = thisform.objreftran.lCtoVta
						.TxtImpAdm.ENABLED  = thisform.objreftran.lCtoVta
						**
					ENDWITH


		ENDCASE


			IF 	THIS.pgfDetalle.PAGES(2).grdDetalle.Visible
				WITH THIS.pgfDetalle.PAGES(2).grdDetalle
					.RECORDSOURCETYPE	= 1
					.RECORDSOURCE		= this.ccursor_d 
					DO CASE 
						CASE thisform.que_transaccion ='ALMACEN'
							.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
							.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
							.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndStk"
							.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
							.ColumnCount = 4

							IF goCfgAlm.lPidPco
								.COLUMNCOUNT   = 8
								.FONTSIZE      = 8
							   *.BACKCOLOR     = "255,255,255"
							   *.GRIDLINECOLOR = "192,192,192"
								*
								.COLUMNS(5).CONTROLSOURCE = "C_DTRA.PreUni"
								.COLUMNS(6).CONTROLSOURCE = "C_DTRA.ImpCto"
								*
								.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
								.COLUMNS(6).HEADER1.CAPTION = "Importe"

								.COLUMNS(7).CONTROLSOURCE = "C_DTRA.Lote"
								.COLUMNS(8).CONTROLSOURCE = "C_DTRA.FchVto"
								.COLUMNS(7).HEADER1.CAPTION = "# Lote"
								.COLUMNS(8).HEADER1.CAPTION = "Fch. Vto."

							ELSE
								.COLUMNCOUNT   = 6
								.COLUMNS(5).HEADER1.CAPTION = "# Lote"
								.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."

								.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Lote"
								.COLUMNS(6).CONTROLSOURCE = "C_DTRA.FchVto"
								*
							ENDIF
						CASE thisform.que_transaccion ='VENTAS'
							.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".CodMat"
							.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".DesMat"
							.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".UndVta"
							.COLUMNS(4).CONTROLSOURCE = THISFORM.cCursor_D+".CanFac"
							.ColumnCount = 4

							IF THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta 
								.COLUMNCOUNT   = 8
								.FONTSIZE      = 8
							   *.BACKCOLOR     = "255,255,255"
							   *.GRIDLINECOLOR = "192,192,192"
								*
								.COLUMNS(5).CONTROLSOURCE = THISFORM.cCursor_D+".PreUni"
								.COLUMNS(6).CONTROLSOURCE = THISFORM.cCursor_D+".ImpLin"
								*
								.COLUMNS(5).HEADER1.CAPTION = "Prec.Uni."
								.COLUMNS(6).HEADER1.CAPTION = "Importe"

								.COLUMNS(7).CONTROLSOURCE = THISFORM.cCursor_D+".Lote"
								.COLUMNS(8).CONTROLSOURCE = THISFORM.cCursor_D+".FchVto"
								.COLUMNS(7).HEADER1.CAPTION = "# Lote"
								.COLUMNS(8).HEADER1.CAPTION = "Fch. Vto."

							ELSE
								DO CASE
									CASE INLIST(ThisForm.ObjRefTran.XsCodDoc,'N/D','N\D','ND')
										.ColumnCount = 3
										.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".Codigo"
										.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".Glosa"
										.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".Import"
										.COLUMNS(3).HEADER1.Caption = 'Importe'
										.Columns(3).WIDTH = 76
									CASE INLIST(ThisForm.ObjRefTran.XsCodDoc,'N/C','N\C','NC')
										.ColumnCount = 3
										.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".Codigo"
										.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".Glosa"
										.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".Import"
										.COLUMNS(3).HEADER1.Caption = 'Importe'
										.Columns(3).WIDTH = 76
									OTHER
										.COLUMNCOUNT   = 6
										.COLUMNS(5).HEADER1.CAPTION = "# Lote"
										.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."

										.COLUMNS(5).CONTROLSOURCE = THISFORM.cCursor_D+".Lote"
										.COLUMNS(6).CONTROLSOURCE = THISFORM.cCursor_D+".FchVto"
								ENDCASE
								*
							ENDIF
					ENDCASE

					.AfterRowColChange()
					.REFRESH()
				ENDWITH
			ENDIF

				WITH thisform.PgfDetalle.Page2
					.cmdAdicionar1.ENABLED	= (THISFORM.XRETURN='I')
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_D)
					.cmdModificar1.ENABLED	= (LlHayRegistros AND THISFORM.XRETURN<>'E')
					.cmdEliminar1.ENABLED	= LlHayRegistros AND (THISFORM.XRETURN<>'E' AND THISFORM.ObjReftran.XsCodRef='FREE')
					IF THISFORM.XRETURN='I'
		**>>				.txtPORIGV.Value  = thisform.ObjrefTran.XfPorIgv
					ELSE
		**>>				.txtPORIGV.Value  = EVALUATE(THISFORM.cCursor_C+'.PorIgv')
					ENDIF
				ENDWITH
				IF .F.
					WITH thisform.PgfDetalle.Page3
						.TxtPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta) 
						.TxtImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta) 
						.LblPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta) 
						.LblImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta) 
						DO CASE 
							CASE INLIST(Thisform.ObjRefTran.XsCodDoc,'N/C','N\C','NC')
							CASE INLIST(Thisform.ObjRefTran.XsCodDoc,'N/D','N\D','ND')
								.TxtCodMat.Visible		=	.F.
								.CmdHelpCodMat.Visible	=	.F.
								.TxtPreUni.Visible		=	.F.
								.LblPreuni.VISIBLE		=	.F.
								.LblUnd.Visible			=	.F.
								.TxtUnd.Visible			=	.F.
								.LblLote.Visible		=	.F.
								.LblFchVto.Visible		=	.F.
								.TxtLote.Visible		=	.F.
								.TxtFchVto.Visible		=	.F.
								.LblCantidad.Visible	=	.F.
								.TxtCandes.Visible		=	.F.
						ENDCASE
					ENDWITH
				ENDIF

			.CmdImprimir.ENABLED  	= LlHayRegistros and Thisform.xreturn<>'E' 
		ENDWITH

		DO CASE 
			CASE thisform.XReturn = 'A'
				thisform.LblStatus.Caption  = 'Actualización de documento'
				THISFORm.TxtEstadoContab.Value  = THIS.XsNroMes+'-'+ THIS.Xscodope  +'-'+ THIS.Xsnroast

			CASE thisform.XReturn = 'E'
				thisform.LblStatus.Caption  = 'Anulación de documento'
				THISFORm.TxtEstadoContab.Value  = THIS.XsNroMes+'-'+ THIS.Xscodope  +'-'+ THIS.Xsnroast
			CASE thisform.XReturn = 'I'
				thisform.LblStatus.Caption  = 'Creando nuevo documento'
				THISFORm.TxtEstadoContab.Value  = THIS.XsNroMes+'-'+ THIS.Xscodope  +'-'+ THIS.Xsnroast
		ENDCASE 


		thisform.PgfDetalle.Page1.LblStatus1.Caption  = thisform.Objreftran.Est_Doc(EVALUATE(this.cCursor_C+'.FlgEst'))
		thisform.PgfDetalle.Page1.LblStatus2.Caption  = thisform.PgfDetalle.Page1.LblStatus1.Caption
		IF THISFORM.xReturn ='I'
			&& Imbecil por defecto es 'P'
		ELSE
			thisform.ObjRefTran.XcFlgEst = EVALUATE(this.cCursor_C+'.FlgEst')
		ENDIF
		RELEASE LoDa
		thisform.capcontrolcab() 

		RETURN .t.
	ENDPROC


	PROCEDURE desvincular_controles
		WITH THIS.pgfDetalle.PAGES(2).grdDetalle
			.ColumnCount = 4
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
			m.CodSed	= thisform.objreftran.CodSed
			m.SubAlm    = thisform.objreftran.SubAlm 
			m.TipMov    = thisform.ObjRefTran.cTipMov
			m.CodMov    = thisform.objreftran.sCodMov
			**
			WITH .pgfDetalle.PAGES(1)
				m.NroDoc  = TRIM(.TxtNroDoc.VALUE)
				m.FchDoc  = .TxtFchDoc.VALUE
				m.Observ  = .TxtObserv.VALUE

				*
				DO CASE
					CASE THISFORM.QUE_transaccion ='MTTO_O_T'
							m.Num_OrdReq	= TRIM(.TxtNroDoc.VALUE)
							m.Fech_Ord		= .TxtFchDoc.Value
							m.Observac		= .TxtObserv.VALUE

						WITH this.ObjCntPage
							goCfgAlm.lPidPco	= .t.
							goCfgAlm.lPidPro	= .t.
							m.CodCia			= GsCodCia
							m.CodigoTA			= .CboTipact.Value
							m.CodigoTM			= .CboTipMaqui.Value
							m.CodMaq			= .CboCodMaq.Value
							m.Tip_Man			= .CboTip_Man.Value
							m.Parametro			= .CboParametro.Value
							m.Fech_Ent			= .TxtFech_Ent.Value
							m.ImpNac			= .TxTImpNac.Value
							m.ImpUsa			= .TxTImpUsa.Value
							m.TpoCmb			= IIF(goCfgAlm.lPidPco,.TxtTpoCmb.VALUE,1)
							m.CodMon			= IIF(goCfgAlm.lPidPco,.CboCodMon.VALUE,1)
							m.CodPro			= IIF(goCfgAlm.lpidPro,.CboCodPro.VALUE,[ ])
							m.Autorizado		= .TxtAutorizado.value
							m.Nro_O_C			= .TxtNro_O_C.Value
						ENDWITH
					CASE THISFORM.QUE_transaccion ='ALMACEN'
						WITH .ObjCntPage 
							m.TpoCmb  = IIF(goCfgAlm.lPidPco,.TxtTpoCmb.VALUE,0)
							m.CodMon  = IIF(goCfgAlm.lPidPco,.CboCodMon.VALUE,0)
							m.NroRf1  = IIF(goCfgAlm.lPidRf1,.TxtNroRf1.VALUE,[ ])
							m.NroRf2  = IIF(goCfgAlm.lPidRf2,.TxtNroRf2.VALUE,[ ])
							m.NroRf3  = IIF(goCfgAlm.lPidRf3,.TxtNroRf3.VALUE,[ ])
							*
							m.CodPro  = IIF(goCfgAlm.lpidPro,.CboCodPro.VALUE,[ ])
							m.CodVen  = IIF(goCfgAlm.lpidVen,.TxtCodVen.VALUE,[ ])
							m.CodCli  = IIF(goCfgAlm.lpidCli,.CboCodCli.VALUE,[ ])
							m.CodPar  = IIF(goCfgAlm.lpidActFijo,.CboCodPar.VALUE,[ ])
							*
							m.AlmOri  = goCfgAlm.AlmOri 
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
						ENDWITH

					CASE THISFORM.QUE_transaccion ='VENTAS'

						WITH thisform.ObjRefTran 
							m.TpoDoc	=	.XsTpoDoc
							m.CodDoc	= 	.XsCodDoc
							m.NroDoc	= 	.XsNroDoc
							m.CodRef	= 	.XsCodRef 
							m.CodVen	=	.XsCodVen
							m.FlgEst	=	.XcFlgEst
							m.FlgUbc	=	.XcFlgUbc

						ENDWITH
						WITH THISFORM.ObjCntPage
							m.CodCli	=	.CboCodCli.Value
							m.NomCli	= 	.CboCodCli.DISPLAYVALUE
							m.CodDire 	= 	.CboCodDire.VAlue
							m.DirCli	=	.CboCodDire.DISPLAYVALUE
							m.RucCli	=	.TxtRucAux.Value 
							m.CodMon	= 	.CboCodMon.Value
							m.TpoCmb	=	.TxtTpoCmb.Value
							m.TpoVta	=   VAL(.CboTpoVta.Value)
							m.NroRef	= 	.TxtNroRef.Value
							m.FmaPgo	=	.CboFmaPgo.Value
							m.CndPgo	=	.TxtCndPgo.Value
							m.DiaVto	=	.SpnDiaVto.Value
							m.NroPed	=	.TxtNroPed.Value
							m.NroO_C	=	.TxtNroO_C.Value
							m.FchO_C	=	.TxtFchO_C.Value
							m.Destino	= 	.CboDestino.VALUE
							m.Via		= 	.CboVia.VALUE
							M.TablDest	=   .CboDestino.cValoresFiltro
							m.TablVia   =   .CboCodVia.cValoresFiltro

						ENDWITH
						WITH thisform.pgfDetalle.PAGES(1)
							m.GloDoc	= 	.TxtObserv.Value
						ENDWITH
				ENDCASE

			ENDWITH
			DO CASE 
				CASE THISFORM.QUE_transaccion ='VENTAS'
					WITH .pgfDetalle.PAGES(2)
						m.ImpBto = .TxtImpBrt.VALUE
						m.ImpBrt = .TxtImpBrt.VALUE
						m.ImpIgv = .TxtImpIgv.VALUE
						m.PorIgv = .TxtPorIgv.VALUE
						m.ImpTot = .TxtImpTot.VALUE
						m.ImpInt = .TxtImpInt.VALUE
						m.ImpVta = .TxtImpVta.VALUE
						m.ImpDto = .TxtImpDto.VALUE
						m.PorDto = .TxtPorDto.VALUE
						m.ImpFlt = .TxtImpFlt.VALUE
						m.ImpSeg = .TxtImpSeg.VALUE
						m.ImpAdm = .TxtImpAdm.VALUE
					ENDWITH
				    **
				  
					WITH .pgfDetalle.PAGES(3)

						m.CodMat	=	.TxtCodMat.VALUE
						m.UndStk	=	.TxtUndStk.VALUE
						m.UndVta	=	.TxtUndStk.VALUE
						m.Candes	=	.TxtCandes.VALUE
						m.CanFac	=	.TxtCandes.VALUE
						m.PreUni	=	.TxtPreUni.VALUE
						m.ImpCto	=	.TxtImpCto.VALUE
						m.ImpLin	=	.TxtImpCto.VALUE
						m.DesMat	=	.TxtDesMat.VALUE
						m.Lote		=	.TxtLote.VALUE
						m.FchVto	=	.TxtFchVto.VAlue
					ENDWITH
					**
					WITH .pgfDetalle.PAGES(4)
						m.NomTra = .TxtNomTra.VALUE
						m.DirTra = .TxtDirTra.VALUE
						m.RucTra = .TxtRucTra.VALUE
						m.PlaTra = .TxtPlaTra.VALUE
						m.Brevet = .TxtBrevet.VALUE
					ENDWITH
			ENDCASE
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
						IF !this.lignora_id_correlativo 
							.txtnrodoc.value=THISFORM.ObjRefTran.Gen_ID('0') 
						ENDIF
						m.NroDoc = TRIM(.txtnrodoc.value)
					ENDWITH
					** Cabecera **
					m.Nro_Itm = 1
					m.NroItm = 1
					** Cursor Local
					SELECT (THISFORM.ccursor_C)  && C_CTRA
					append blank
					gather MEMVAR memo

		*!*				** Detalle **
					** Cursor Local
					sele (THISFORM.ccursor_D)  && C_DTRA
					IF thisform.ObjReftran.XsCodRef = 'FREE'
						append blank
					ENDIF
					gather memvar
				ELSE
					SELECT * FROM (THISFORM.ccursor_C) INTO CURSOR XTMP_DETA
					USE IN XTMP_DETA
					m.NroItm = _TALLY
					** Cursor Local
					sele (THISFORM.ccursor_C)  &&C_CTRA
					gather MEMVAR memo

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
						update (THISFORM.ccursor_C) set NroItm = NroItm + 1 
						  
						m.Nro_Itm = EVALUATE(THISFORM.ccursor_C+'.NroItm')
						sele (THISFORM.ccursor_D)
						append blank
						gather memvar
						THISFORM.ObjRefTran.GiTotItm = THISFORM.ObjRefTran.GiTotItm + 1
					case tcOpcion == "A"	&& Actualizar
						sele (THISFORM.ccursor_D)
						gather memvar 

					case tcOpcion == "E"	&& Eliminar

		*				m.NroItm = C_DTRA.NroItm
						m.NroItm = EVALUATE(THISFORM.ccursor_D+'.NroItm')

		*!*					delete from (THISFORM.ccursor_D)  ;
		*!*					where (thisform.ccampos_pk ) = thisform.cvalor_pk   AND ;
		*!*						  NroItm = m.NroItm
						SELECT (THISFORM.ccursor_D)
						thisform.ObjRefTran.Borra_registro_Local_Detalle
						LnNro_Itm = 0
						SCAN
							LnNro_Itm = LnNro_Itm + 1
							REPLACE Nro_Itm WITH LnNro_Itm
						ENDSCAN
						update (THISFORM.ccursor_C) set nroitm = LnNro_Itm

				endcase
				lnControl = 1

			CASE tnTabla == 4		&& Actualizar el Detalle AlmDtran
				IF THISFORM.Tools.cursor_esta_vacio(THISFORM.ccursor_D)
					LnRpta=MESSAGEBOX('No se ha ingresado datos en el detalle. Desea Continuar?',16+4,'Atención')
					IF LnRpta=7
						RETURN .f.
					ENDIF
				ENDIF
				sele (THISFORM.ccursor_C)
				LOCATE
				IF EOF()
					APPEND BLANK 
				ENDIF

				gather MEMVAR memo
				WITH THIS.PGFDETALLE.PAGES(1)
					IF THISFORM.XRETURN = 'I'
						IF !this.lignora_id_correlativo 
			    		   .txtNroDoc.VALUE = THISFORM.OBJREFTRAN.GEN_id('0')
			    		ENDIF   
					ENDIF
					m.NroDoc = TRIM(.txtnrodoc.value)
				ENDWITH
				*

				DO CASE
					CASE THISFORM.QUE_transaccion = 'ALMACEN'
						THISFORM.OBJREFTRAN.sNroDoc	= m.NroDoc
						*thisform.traervalor_pk() 
						IF Thisform.xreturn = 'E' && Eliminar transaccion
							LnControl = thisform.Objreftran.AnulaR_Transaccion(THISFORM.QUE_transaccion,gocfgalm.CodSed,gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
						ELSE
							LnControl = thisform.objreftran.Ejecuta_transaccion(THISFORM.QUE_transaccion,gocfgalm.CodSed,gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
						ENDIF
								*
					        * TRANFERENCIAS ENTRE ALMACENES INTERNOS
					        *
					        *!* VETT
					        *!* Determinar TpoRef = [TRA]
					        *!* Rutina de proceso para modificar, eliminar cuando es una Transacción  
					        *
							WITH THIS
					             IF LEFT(.cboTipMov.VALUE,1) = [T] AND THISFORM.xReturn = [I]
						            WITH .pgfDetalle.PAGES(1)
					                     GoCfgAlm.cTipMov = [I]		   
					                     GoCfgAlm.AlmOri  = GoCfgAlm.SubAlm
					                     GoCfgAlm.SubAlm  = m.AlmOri
						                 *
					                     SELE C_DTRA
					                     REPLA ALL TipMov WITH GoCfgAlm.cTipMov
					                     REPLA ALL AlmOri WITH GoCfgAlm.AlmOri
					                     REPLA ALL SubAlm WITH GoCfgAlm.SubAlm
					                     GO TOP
						                 *
					                     SELE C_CTRA
					                     REPLA ALL TipMov WITH GoCfgAlm.cTipMov
					                     REPLA ALL AlmOri WITH GoCfgAlm.AlmOri
					                     REPLA ALL SubAlm WITH GoCfgAlm.SubAlm
					                     GO TOP
					      		         GATHER MEMVAR
						                 *
					        	         .TxtNroDoc.VALUE = THISFORM.OBJREFTRAN.GEN_id('0')
							             m.NroDoc = TRIM(.TxtNroDoc.VALUE)
							             LnControl = thisform.objreftran.Ejecuta_transaccion(thisform.Que_transaccion,GoCfgAlm.CodSed,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
							             
							             thisform.PgfDetalle.Page2.TxtNroItm.VALUE = C_CTRA.NroItm
							        ENDWITH     
					             ENDIF
					        ENDWITH

					CASE THISFORM.QUE_transaccion = 'VENTAS'

						THISFORM.OBJREFTRAN.XsNroDoc	= m.NroDoc
						IF Thisform.xreturn = 'E' && Eliminar transaccion
							LnControl	= thisform.Objreftran.AnulaR_Transaccion(thisform.Que_transaccion)

						ELSE
							LnControl = thisform.objreftran.Ejecuta_transaccion(thisform.Que_transaccion,;
																					Thisform.xreturn )
							 
						ENDIF
					CASE THISFORM.QUE_transaccion = 'MTTO_O_T'

						DO CASE 
						CASE Thisform.xreturn = 'E' && Eliminar transaccion

							LcCmdSqlCab="UPDATE "+this.cAliasCab+" WHERE "+THIS.ccampos_pk+"= '"+thisform.cvalor_pk+"' " + " SET FlgEst = 'A' "
							&LcCmdSqlCab

							LcCmdSqlDet="DELETE FROM "+this.cAliasDet+" WHERE "+THIS.ccampos_pk+"= '"+thisform.cvalor_pk+"'" 
							&LcCmdSqlDet

							=Borra_detalle_ot_mtto(this.ccampos_PK,thisform.cvalor_pk)


						OTHER
							DIMENSION laValoresClaveDestino(1)
							STORE '' TO laValoresClaveDestino
							=chrtoarray( THIS.ccampos_pk, "+" , @laValoresClaveDestino )
							LsCmdGather = "GATHER MEMVAR MEMO FIELDS EXCEPT " 

							FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
								LsCmdGather = LsCmdGather + laValoresClaveDestino(LnNumCmp) + IIF(LnNumCmp=ALEN(laValoresClaveDestino),"",",")
							ENDFOR

							SELECT (this.ccursor_c) 
							LOCATE
							IF !EOF()
								SCATTER MEMVAR memo
								SELECT (this.caliascab) 
								SEEK thisform.cvalor_pk
								IF !FOUND()
									APPEND BLANK
									GATHER MEMVAR MEMO 
									this.objreftran.gen_id(this.objreftran.XsNroDoc)
									SELECT (this.caliascab) 
								ENDIF
								&LsCmdGather.
								SELECT (this.ccursor_c) 

								LnControl	= ASC('D')															 
							ENDIF
						ENDCASE 
				ENDCASE

		ENDCASE
		thisform.nResulttrn =	LnControl
		thisform.capcontrolcab() 
		RETURN lnControl>=0
	ENDPROC


	PROCEDURE mantenimiento_detalle
		LPARAMETER tlEnabled
	ENDPROC


	PROCEDURE canciones_pendientes
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
		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.cCursor_d)
		IF LlHayRegistros

			thisform.objreftran.gitotitm = RECCOUNT(thisform.cCursor_d)
			DIMENSION THIS.objRefTran.aDetalle[thisform.objreftran.gitotitm]

		   SELECT(thisform.cCursor_d)
		   LOCATE
		   _RegAct = RECNO()
		   SCAN WHILE !EOF()
		   		DO CASE 
		   			CASE thisform.Que_transaccion ='ALMACEN'
		   				LsCampo = thisform.cCursor_d+'.ImpCto'
				        _ImpBrt = _ImpBrt + EVALUATE(LsCampo)
				    CASE thisform.Que_transaccion ='VENTAS'   
					    LsCampo = thisform.cCursor_d+'.ImpLin'
				        _ImpBrt = _ImpBrt + EVALUATE(LsCampo)
				        SCATTER name THIS.ObjRefTran.aDetalle(RECNO())
				        
		        ENDCASE
		   ENDSCAN
		   LOCATE
		ENDIF
		*

		*!*	IF thisform.ObjRefTran.GiTotItm>0
		*!*		FOR j = 1 TO thisform.ObjRefTran.GiTotItm
		*!*		   thisform.ObjReftran.XfImpBto = thisform.ObjRefTran.XfImpBto + Thisform.ObjReftran.Adetalle(j).ImpLin
		*!*		   
		*!*		ENDFOR
		*!*	ELSE

		*!*	ENDIF


		WITH THISFORM.ObjRefTran
			STORE 0 TO .XfImpBto,.XfImpDto,.XfImpIgv,.XfImpTot


			DO CASE
				CASE .XsCODDOC = [FACT]
					DO CASE 
						CASE  .XcDestino='N'
							.XfImpBto = _ImpBrt
							.XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2) 
							.XfImpVta = .XfImpBto - .XfImpDto  + .XfImpInt  + .XfImpFlt
							.XfImpIgv = ROUND(.XfImpVta*.XfPorIgv/100,2)
							.XfImpTot = .XfImpVta + .XfImpIgv
						CASE  .XcDestino='E'

							.XfImpVta   = _ImpBrt
							.XfImpIgv	= 0 
							.XfImpBto	= .XfImpVta + .XfImpInt  + .XfImpFlt + .XfImpSeg + .XfImpAdm
							.XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2) 
							.XfImpTot = .XfImpBto + .XfImpIgv - .XfImpDto
					ENDCASE
				CASE thisform.ObjReftran.XsCODDOC = [BOLE]
				   .XfImpBto = _ImpBrt
		  		   .XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2)   		   
				   thisform.ObjReftran.XfImpVta = ROUND((thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto)/(1+thisform.ObjReftran.XfporIgv/100),2)
				   thisform.ObjReftran.XfImpIgv = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto - thisform.ObjReftran.XfImpVta
				   thisform.ObjReftran.XfImpTot = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto
				   thisform.ObjReftran.XfImpBto = thisform.ObjReftran.XfImpVta

			ENDCASE
		ENDWITH


		WITH THISFORM.pgfDetalle.PAGE2
			DO CASE 
				CASE thisform.Que_transaccion = 'ALMACEN'
				     .TxtImpBrt.VALUE = _ImpBrt
				     .TxtImpIgv.VALUE = ROUND(_ImpBrt*.txtPorIgv.VALUE/100,2)
				     .TxtIMpTot.VALUE = .TxtImpBrt.VALUE + .TxtImpIgv.VALUE
				CASE thisform.Que_transaccion = 'VENTAS'     

				     .TxtImpBrt.VALUE = thisform.ObjReftran.XfImpBto
		   	         .TxtImpDto.VALUE = thisform.Objreftran.XfImpDto
		   	         .TXtImpVta.VALUE = thisform.Objreftran.XfImpVTA
		  	         .TxtImpIgv.VALUE = thisform.ObjReftran.XfImpIgv

		  	         IF THISFORM.ObjRefTran.XnTpoVta = 3  && Promociones
		  	        	 .TxtImpTot.VALUE = 0 
		  	        	 thisform.ObjReftran.XfImpTot = 0
					 ELSE 
					 	.TxtImpTot.VALUE = thisform.ObjReftran.XfImpTot
					 ENDIF

		    ENDCASE  
			.cmdAdicionar1.ENABLED	= (thisform.xReturn<> 'E' and thisform.objreftran.XsCodRef = 'FREE')
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_D)
			.cmdModificar1.ENABLED	= LlHayRegistros and thisform.xReturn<> 'E'
			.cmdEliminar1.ENABLED	= LlHayRegistros and (thisform.xReturn<> 'E' and thisform.objreftran.XsCodRef = 'FREE')
		*	.txtPORIGV.Value  = thisform.ObjrefTran.XfPorIgv
		ENDWITH
		*
	ENDPROC


	PROCEDURE limpiar_var
		with thisform.pgfdetalle.page1
			.txtNroDoc.VALUE = []
			.txtFchDoc.VALUE = DATE()  
			.TxtObserv.VALUE = []
		endwith

		with thisform.pgfdetalle.page2
		*	.txtPorIgv.VALUE = 0
			.txtImpBrt.VALUE = 0
			.txtImpIgv.VALUE = 0
			.txtImpTot.VALUE = 0
		endwith

	ENDPROC


	PROCEDURE ejecuta_interactivechange
		WITH THISFORM
			IF .xReturn='I'				&& Solo cuando se Inserta un registro
				IF !.Vincular_Controles()
					RETURN .f.
				ENDIF
			ENDIF
			WITH thisform.PgfDetalle.pages(1)
				IF  !INLIST(.TxtFchDoc.Tag,'X')
					.TxtFchDoc.SetFocus()
				ENDIF
				.txtObserv.Enabled = Thisform.xReturn <> 'E' 
				.txtFchdoc.Enabled = Thisform.xReturn <> 'E' 
			ENDWITH
			WITH thisform.PgfDetalle.pages(2)
				.CmdAdicionar1.ENABLED = .T.
			ENDWITH
		ENDWITH
		RETURN .t.
	ENDPROC


	*-- Ocurre cuando se quiere adicionar un regsitro a la cabecera
	PROCEDURE add_cabecera
		this.objcntpage.habilita 
		LlReturn = this.Ejecuta_interactiveChange()

		RETURN LlReturn
	ENDPROC


	*-- Ocurre cuando se quiere modificar un regsitro a la cabecera
	PROCEDURE mod_cabacera
			this.objcntpage.habilita 
			WITH thisform.PgfDetalle.pages(1)
				.txtObserv.Enabled = Thisform.xReturn <> 'E' 
				.txtFchdoc.Enabled = Thisform.xReturn <> 'E' 
			ENDWITH
	ENDPROC


	*-- Ocurre cuando se quiere eliminar un regsitro a la cabecera
	PROCEDURE eli_cabecera
		thisform.Objcntpage.Habilita
		thisform.objcntpage.CntO_t_Activi.habilita()
		WITH thisform.PgfDetalle.pages(1)
			.txtObserv.Enabled = Thisform.xReturn <> 'E' 
			.txtFchdoc.Enabled = Thisform.xReturn <> 'E' 
		ENDWITH
		thisform.Objcntpage.Deshabilita
	ENDPROC


	*-- Crea un objeto de referencia dentro del formulario basado en el objeto recibido como paramentroel objeto recibido como parametro
	PROCEDURE crearrefobj
		LPARAMETERS ToObjRef,TcNomObj
		IF !EMPTY(TcNomObj)
			ToObjRef = eval(TcNomObj) 
		ENDIF
		IF VARTYPE(this.objreftran)=='O'
			ToObjRef = null
		ENDIF
		RETURN ToObjRef
	ENDPROC


	*-- captura los valores de los controles de la cabecera
	PROCEDURE capcontrolcab
		LOCAL LcTipMov,LcCodMov, LcSubAlm,LcCodRef,LcCodCli
		DO CASE 
			CASE thisform.que_transaccion ='ALMACEN'
				LcSubAlm = thisform.objcntcab.cboAlmacen.value
				LcTipMov = thisform.objcntcab.cbotipmov.value
				LcCodMov = thisform.objcntcab.cboCodmov.value 
				GocfgAlm.SubAlm = LcSubAlm
				GoCfgAlm.cTipMov= IIF(LEFT(LcTipMov,1)=[T],[S],LEFT(LcTipMov,1))
				GoCfgAlm.sCodMov= LcCodMov
				goCfgAlm.AlmOri =  IIF(LEFT(THISFORM.CboTipMov.VALUE,1)=[T],.CboAlmOri.VALUE,[ ])
				GoCfgAlm.sNroDoc = trim(this.pgfDetalle.page1.TxtNroDoc.Value)
				WITH thisform.pgfDetalle.page1.cmdHelpNrodoc
					.caliascursor='c_NroDoc'
					.cnombreentidad = 'Almctran'
					.ccamporetorno  = 'NroDoc'
					.Ccampovisualizacion = 'Observ'
					.ccamposfiltro 	= [SubAlm;TipMov;CodMov;NroDoc]
					.cvaloresfiltro = GocfgAlm.SubAlm+";"+GoCfgAlm.cTipMov+";"+GoCfgAlm.sCodMov+";"+GoCfgAlm.sNroDoc
				ENDWITH

			CASE thisform.que_transaccion ='VENTAS'
				THISFORM.ObjRefTran.XsCodDoc =	THISFORM.ObjCntCab.CboCodDoc.Value
				THISFORM.ObjRefTran.XsPtoVta =	THISFORM.ObjCntCab.CboPtoVta.Value
				THISFORM.ObjRefTran.XsCodVen =	THISFORM.ObjCntCab.CboCodVen.Value
				THISFORM.ObjRefTran.XnTpoFac =	THISFORM.ObjCntCab.CboTipoFact.ListIndex
				THISFORM.ObjRefTran.XsCodCli =  THISFORM.ObjCntPage.CboCodCli.Value
				THISFORM.cValor_ID	=	THISFORM.ObjRefTran.CodSed + ; 
										THISFORM.ObjRefTran.XsCodDoc +;
										THISFORM.ObjRefTran.XsPtoVta

				THISFORM.cValor_PK = THISFORM.TraerValor_PK()
				thisform.ObjRefTran.CfgVar_PK(thisform.ctabla_c)

				WITH thisform.pgfDetalle.page1.cmdHelpNrodoc
					.caliascursor='c_NroDoc'
					.cnombreentidad = 'v_Documentos_x_Cobrar'
					** Refrescar la vista osea cerrarla si esta abierta **
					IF USED(.cNombreEntidad)
						USE IN (.cNombreEntidad)
					ENDIF
					.ccamporetorno  = 'NroDoc'
					.Ccampovisualizacion = 'NomCli'
					LcCodDoc = thisform.objreftran.XsCodDoc
					LcCodCli = thisform.objreftran.XsCodCli
					IF !EMPTY(LcCodCli)
						.ccamposfiltro 	= [CodDoc;CodCli]
						.cvaloresfiltro = LcCodDoc+";"+LcCodCli
					ELSE
						.ccamposfiltro 	= [CodDoc]
						.cvaloresfiltro = LcCodDoc
					ENDIF
				ENDWITH
			CASE thisform.que_transaccion ='MTTO_O_T'

				THISFORM.cValor_PK = THISFORM.TraerValor_PK()
				thisform.ObjRefTran.CfgVar_PK(thisform.ctabla_c)
				thisform.Objreftran.CodCia = GsCodCia 
				thisform.Objreftran.XsCodDoc = 'O_T '
				THISFORM.cValor_ID	=	thisform.Objreftran.CodCia

				THIS.Objcntpage.CntO_t_Activi.cCmpkgen		=	thisform.cCampos_PK
				THIS.Objcntpage.CntO_t_Activi.cValkgen		=	thisform.cValor_PK
				THIS.Objcntpage.CntO_t_Activi.cCursor_Local =	thisform.ccursor_c 
				THIS.Objcntpage.CntO_t_Activi.cTabla_det1	=	thisform.caliasdet 
				WITH thisform.pgfDetalle.page1.cmdHelpNrodoc
		*!*				.caliascursor='c_NroDoc'
		*!*				.cnombreentidad = 'v_Documentos_x_Cobrar'
		*!*				** Refrescar la vista osea cerrarla si esta abierta **
		*!*				IF USED(.cNombreEntidad)
		*!*					USE IN (.cNombreEntidad)
		*!*				ENDIF
		*!*				.ccamporetorno  = 'NroDoc'
		*!*				.Ccampovisualizacion = 'NomCli'
		*!*				LcCodDoc = thisform.objreftran.XsCodDoc
		*!*				LcCodCli = thisform.objreftran.XsCodCli
		*!*				IF !EMPTY(LcCodCli)
		*!*					.ccamposfiltro 	= [CodDoc;CodCli]
		*!*					.cvaloresfiltro = LcCodDoc+";"+LcCodCli
		*!*				ELSE
		*!*					.ccamposfiltro 	= [CodDoc]
		*!*					.cvaloresfiltro = LcCodDoc
		*!*				ENDIF
				ENDWITH

		ENDCASE
	ENDPROC


	*-- Trae el valor de la llave primaria de la tabla  padre de la transaccion
	PROCEDURE traervalor_pk
		LOCAL LsValor_PK as String 

		LsValor_PK =''

		DO CASE 
			CASE this.que_transaccion ='ALMACEN'
				LsValor_PK	=	THIS.ObjRefTran.SubAlm + ;
								THIS.ObjRefTran.cTipMov + ;
								THIS.objreftran.sCodMov + ; 
								THIS.objreftran.sNrodoc 

			CASE this.que_transaccion ='VENTAS'

				LsValor_PK	= 	THIS.ObjRefTran.XsTpoDoc + ;
								THIS.ObjRefTran.XsCodDoc + ;
								THIS.ObjRefTran.XsNroDoc  

			CASE this.que_transaccion ='CONTAB'
			CASE this.que_transaccion ='PLANILLA'
			CASE this.que_transaccion ='COMPRAS'
			CASE this.que_transaccion ='MTTO_O_T'
				LsValor_PK = GsCodCia+THIS.ObjRefTran.XsNroDoc  
		ENDCASE 

		RETURN LsValor_PK
	ENDPROC


	*-- Permite capturar el correlativo (ID) de la transaccion
	PROCEDURE id_transaccion
		LPARAMETERS _lUnico,_nMes ,_cValor
		IF PCOUNT()=0
			** Es verdadero si es correlativo unico
			_lUnico	=	.T.		&& si es .F. _nMes debe ser diferente de cero
			** Mes de donde se toma el valor del correlativo
			_nMes	=	0		&& Cero indica que se esta usando un correlativo unico y no mensual
			** Aqui vienen el valor que se esta asignando como nuevo correlativo
			** Este valor es tomado como base para grabar el nuevo correlativo incrementado en la respectiva tabla
			_CValor	=	'0'		&&  Si es cero '0' solo devuelve el valor actual del correlativo	 

		ENDIF
		LOCAL LcTabla,LcCmps,LcVlrs,LcCmpId,LnLenId,LnMes,LlUnico,LcValor
		LcTabla=thisform.objreftran.EntidadCorrelativo
		LcCmps	=	THIS.cCmps_Id
		LcVlrs	=	THIS.cValor_ID
		LcCmpId	=	THIS.ccampo_id 
		LnLenId	=	LEN(EVALUATE(THIS.ccursor_d+'.'+THIS.ccampo_id)) 
		LlUnico	=	_lUnico
		LnMes	=	_nMes
		LcValor	=	_cValor


		RETURN thisform.objreftran.Gen_correlativo(LcTabla,LcCmps,LcVlrs,LcCmpId,LnLenId,LlUnico,LnMes,LcValor)
	ENDPROC


	*-- Habilita o desabilita controles de una pagina
	PROCEDURE habilita_pagina
		parameter lHabilita,nNumPag
		with this.pgfDetalle.Pages(nNumPag)
			IF lHabilita
				for i = 1 to .ControlCount
					.Controls(i).Enabled  = lHabilita AND thisform.xReturn<>'E' && AND !thisform.lnavegando
					IF INLIST(UPPER(.Controls(i).Name),'CNTCODCTA')
						do case 
							case Thisform.xReturn$'A'
								.Controls(i).Enabled  = !lHabilita 
							case Thisform.xReturn$'I'
							case Thisform.xReturn$'E'
						ENDcase

					ENDIF

				endfor
			ELSE
				for i = 1 to .ControlCount
					.Controls(i).Enabled  = lHabilita  && AND thisform.xReturn<>'E'
				endfor
			ENDIF
		endwith
	ENDPROC


	PROCEDURE Load
		DO CASE 
			CASE THISFORM.QUE_Transaccion=[ALMACEN]

				=goCfgAlm.Abrir_dbfs_alm()
		 	CASE THISFORM.QUE_Transaccion=[VENTAS]
		 		=goCfgAlm.Abrir_dbfs_VTA('FACT')
		 	CASE THISFORM.QUE_Transaccion=[CONTABIL]
		 
		 	CASE THISFORM.QUE_Transaccion=[REQUISICION]
		 
		 	CASE THISFORM.QUE_Transaccion=[COMPRAS]
		 
		 	CASE THISFORM.QUE_Transaccion=[PLANILLAS]
		 
		 
		ENDCASE 
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toconexion
		dodefault()


		THISFORM.INICIAR_VAR()
	ENDPROC


	PROCEDURE setdatasource
		** Todo depende del documento 

		DO CASE
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'FACT','BOLE')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'N/C','N/D','N\C','N\D','NC','ND') 
					this.cAliasDet='RDOC'
					this.cCursor_d='C_RDOC' 
					this.cTabla_d ='CCBRRDOC'
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'PEDI')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'N/BC')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'CANJ')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'LETR')
		ENDCASE
	ENDPROC


	*-- Activa los controles de origen de datos segun configuración
	PROCEDURE activar_controles
	ENDPROC


	*-- Ocurre cuando se quiere adicionar un regsitro al  detalle
	PROCEDURE add_detalle
	ENDPROC


	*-- Ocurre cuando se quiere modificar un regsitro del  detalle
	PROCEDURE mod_detalle
	ENDPROC


	*-- Ocurre cuando se quiere eliminar un regsitro del detalle
	PROCEDURE eli_detalle
	ENDPROC


	PROCEDURE borrar_transaccion
	ENDPROC


	PROCEDURE grabar_transaccion
	ENDPROC


	PROCEDURE cmdiniciar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF

		THISFORM.INICIAR_VAR()
	ENDPROC


	PROCEDURE cmdadicionar.Click

		IF !THIS.Activado()
			RETURN
		ENDIF
		*
		WITH THISFORM
		    *
		   	.xReturn	= 'I'	&& Indica Insertar registro ...
			.lNuevo		= .T.
			.lGrabado	= .F.

			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE(.cCursor_C)
			.Tools.CLOSETABLE(.cCursor_D)

		    IF NOT .add_cabecera()
		    	IF VARTYPE(thisform.objcntcab)='O'
			    	thisform.objcntcab.SetFocus
			    ENDIF
		    	RETURN
		    
		    ENDIF 
		   	with thisform.pgfdetalle.page2
				.cmdEliminar1.ENABLED	= .F.
			endwith
		    * 
		    * 
			WAIT WINDOW [Creando Nueva Transacción .....] NOWAIT
			*

			lnControl	= 1
			.cmdIniciar.ENABLED		= .T.
			.cmdImprimir.ENABLED	= .F.
			.cmdSalir.ENABLED		= .F.

			with thisform.pgfdetalle.page1
				.txtNroDoc.ENABLED		= .F.
				.txtFchDoc.ENABLED		= .F.
		*!*			.TxtTpoCmb.ENABLED		= .F.

				.cmdAdicionar.ENABLED	= .F.
				.cmdModificar.ENABLED	= .F.
				.cmdEliminar.ENABLED	= .F.
				.txtNroDoc.ENABLED		= thisform.xReturn <> "E" AND !INLIST(.txtNroDoc.Tag,'X')
				.txtFchDoc.ENABLED		= thisform.xReturn <> "E" AND !INLIST(.txtFchDoc.Tag,'X')
				.txtObserv.ENABLED		= thisform.xReturn <> "E" AND !INLIST(.txtObserv.Tag,'X')
		**		.txtTpoCmb.ENABLED		= thisform.xReturn <> "E"
		**		.cboCodMon.ENABLED		= thisform.xReturn <> "E"
				.cmdHelpNrodoc.enabled	= thisform.xReturn <> "E" AND !thisform.lNuevo AND !INLIST(.txtNroDoc.Tag,'X')
				.txtNroDoc.ENABLED		= thisform.xReturn <> "E" AND !thisform.lNuevo AND !INLIST(.txtNroDoc.Tag,'X')

				.txtFchDoc.VALUE		= DATE()

				IF  !INLIST(.TxtFchDoc.Tag,'X')
					.TxtFchDoc.SetFocus()
				ENDIF
			ENDWITH

			.ObjRefTran.Crear = .lNuevo
			.cmdImprimir.ENABLED = .xReturn <> "E" AND !.lNuevo
			.cmdGrabar.Enabled  = .t.

			WAIT CLEAR

		ENDWITH
	ENDPROC


	PROCEDURE cmdmodificar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF

		WITH THISFORM
			.xReturn	= ""
			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE(.cCursor_C)
			.Tools.CLOSETABLE(.cCursor_D)
			.Capcontrolcab() 

			.cmdIniciar.ENABLED		= .T.
			.cmdImprimir.ENABLED	= .F.
			.cmdSalir.ENABLED		= .F.
			*
		*!*	*!*
		*!*	*!*		.CboAlmacen.ENABLED		= .T.
		*!*	*!*		.CboTipMov.ENABLED		= .T.
		*!*	*!*		.CboCodMOv.ENABLED		= .T.
		*!*	*!*	**	.CboTipMov.VALUE		= ''
		*!*	*!*	**	.CboCodMov.VALUE		= ''
		*!*	*!*		.CboAlmacen.SETFOCUS()
			 
			with thisform.pgfdetalle.page1
				.cmdAdicionar.ENABLED	= .F.
				.cmdModificar.ENABLED	= .F.
				.cmdEliminar.ENABLED	= .F.
				.TxtNroDoc.ENABLED = .T.
				.txtObserv.ENABLED		= thisform.xReturn <> "E"
				.CmdHelpNroDoc.ENABLED = .T.
				.TxtNroDoc.SETFOCUS()
			endwith
			.lNuevo		= .F.
			.lGrabado	= .F.
			.ObjRefTran.Crear = .lNuevo
			.cmdGrabar.Enabled  = .t.
			.xReturn	= "A"
		ENDWITH
	ENDPROC


	PROCEDURE cmdeliminar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		WITH THISFORM
			.Desvincular_Controles()	&& Desvincular todas las Grillas
			.Tools.CLOSETABLE(.cCursor_C)
			.Tools.CLOSETABLE(.cCursor_D)

			.cmdIniciar.ENABLED		= .T.
			.cmdImprimir.ENABLED	= .F.
			.cmdSalir.ENABLED		= .F.
			*
		*!*	*!*		.CboAlmacen.ENABLED		= .T.
		*!*	*!*		.CboTipMov.ENABLED		= .T.
		*!*	*!*		.CboCodMOv.ENABLED		= .T.
		*!*	*!*		.CboAlmacen.SETFOCUS()


			with thisform.pgfdetalle.page1
				.cmdAdicionar.ENABLED	= .F.
				.cmdModificar.ENABLED	= .F.
				.cmdEliminar.ENABLED	= .F.
				.TxtNroDoc.ENABLED	= .T.
				.CmdHelpNroDoc.ENABLED	= .T.
				.TxtNroDoc.SETFOCUS()

			endwith
			.lNuevo		= .F.
			.lGrabado	= .F.
			*.eli_cabecera() 
			.ObjRefTran.Crear = .lNuevo
			.cmdGrabar.Enabled  = .t.
			.xReturn	= "E"

		ENDWITH
	ENDPROC


	PROCEDURE txtfchdoc.Valid
		thisform.objcntpage.txttpoCmb.Value =GoCfgAlm._TipoCambio(this.value,thisform.xReturn,thisform.objcntpage.txttpoCmb.Value )

		thisform.ObjReftran.XdFchDoc = this.Value

		IF Thisform.ObjCntPage.TxtTpoCmb.Value<=0
			LnRpta=MEssagebox('No hay tipo de cambio definido para esta fecha,Desea Continuar?',4+32+256,'Atención')
			IF LnRpta=7
				Thisform.ObjCntPage.Enabled = .F.
			ELSE
				Thisform.ObjCntPage.Enabled = .T.
				thisform.objcntpage.txttpoCmb.Value = 3.5
			ENDI
		ELSE
			Thisform.ObjCntPage.Enabled = .T.
		ENDIF
	ENDPROC


	PROCEDURE txtnrodoc.Valid
		IF !EMPTY(THIS.VALUE)
			IF !thisform.Vincular_Controles()
				MESSAGEBOX('Nro. de documento invalido',16,'Verificar')
				RETURN .f.
			ENDIF
			IF thisform.xReturn='A'
				thisform.mod_cabacera() 
			ENDIF
			IF thisform.xReturn='E'
				thisform.Eli_cabecera() 
			ENDIF
			IF thisform.ObjRefTran.XcFlgEst = 'A'
				thisform.ObjCntPage.Deshabilita
				thisform.hABilita_pagina(.F.,2)
				thisform.hABilita_pagina(.F.,3)
				thisform.hABilita_pagina(.F.,4)
			ELSE
				thisform.hABilita_pagina(.T.,2)
				thisform.hABilita_pagina(.T.,3)
				thisform.hABilita_pagina(.T.,4)
			ENDIF


		ENDIF
	ENDPROC


	PROCEDURE cmdhelpnrodoc.Click

		thisform.capcontrolcab() 
		DODEFAULT()
		this.Parent.TxtNroDoc.Value = this.cvalorvalida 
		this.Parent.TxtNroDoc.SetFocus
		IF !EMPTY(this.Parent.TxtNroDoc.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
		 
	ENDPROC


	PROCEDURE grddetalle.AfterRowColChange
		LPARAMETERS ncolindex
		DODEFAULT()
		WITH THISFORM.PgfDetalle.PAGES(3)
			DO CASE 
				CASE	thisform.que_transaccion ='ALMACEN'

					.TxtCodmat.VALUE	= EVALUATE(THISFORM.cCursor_D+'.CodMat')
					.TxtDesMat.VALUE	= EVALUATE(THISFORM.cCursor_D+'.DesMat')
					.TxtUndStk.VALUE	= EVALUATE(THISFORM.cCursor_D+'.UndStk') 
					.TxtCanDes.VALUE	= EVALUATE(THISFORM.cCursor_D+'.CanDes')
					.TxtPreUni.VALUE	= EVALUATE(THISFORM.cCursor_D+'.PreUni')
					.TxtImpCto.VALUE	= EVALUATE(THISFORM.cCursor_D+'.ImpCto')
					.TxtLote.Value		= EVALUATE(THISFORM.cCursor_D+'.Lote')
					.TxtFchVto.Value	= EVALUATE(THISFORM.cCursor_D+'.FchVto')

				CASE	thisform.que_transaccion ='VENTAS'
					.TxtCodmat.VALUE	= EVALUATE(THISFORM.cCursor_D+'.CodMat')
					.TxtDesMat.VALUE	= EVALUATE(THISFORM.cCursor_D+'.DesMat')
					.TxtUndStk.VALUE	= EVALUATE(THISFORM.cCursor_D+'.UndVta') 
					.TxtCanDes.VALUE	= EVALUATE(THISFORM.cCursor_D+'.CanFac')
					.TxtPreUni.VALUE	= EVALUATE(THISFORM.cCursor_D+'.PreUni')
					.TxtImpCto.VALUE	= EVALUATE(THISFORM.cCursor_D+'.ImpLin')
					.TxtLote.Value		= EVALUATE(THISFORM.cCursor_D+'.Lote')
					.TxtFchVto.Value	= EVALUATE(THISFORM.cCursor_D+'.FchVto')

			ENDCASE

		ENDWITH

		WITH THISFORM.PgfDetalle.PAGES(2)
			.TxtNro_Itm.Value = EVALUATE(THISFORM.cCursor_D+'.Nro_Itm')
		ENDWITH
	ENDPROC


	PROCEDURE cmdadicionar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		THISFORM.PgfDetalle.page2.ENABLED	= .F.
		THISFORM.PgfDetalle.ACTIVEPAGE	= 3
		WITH THIS.PARENT.PARENT.PAGES(1)
			.TxtFchDoc.ENABLED = .F.
			.TxtObserv.ENABLED = .F.
		ENDWITH
		EXTERNAL ARRAY GaLencod
		IF VARTYPE(thisform.objCntCab)='O'
			thisform.objCntCab.Deshabilita
		ENDIF
		IF VARTYPE(thisform.objCntPage)='O'
			thisform.objCntPage.Deshabilita
		ENDIF
		thisform.LcTipOpe = 'I'  				&& Agregar item en el detalle

		WITH THISFORM.PgfDetalle.PAGES(3)
			** Inicializamos Variables
			.TxtCodMat.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.Codmat')))
			.TxtDesMat.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.DesMat')))
			DO CASE 
				CASE thisform.que_transaccion ='ALMACEN'
					.TxtUndStk.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.UndStk')))
				CASE thisform.que_transaccion ='VENTAS'
					.TxtUndStk.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.UndVta')))
			ENDCASE

			.TxtLote.VALUE	 = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.Lote')))
			.TxtFchVto.VALUE= DATE()

			.TxtCanDes.VALUE = 0.00
			.TxtPreUni.VALUE = 0.00
			.TxtImpCto.VALUE = 0.00
			** Habilitamos las variables
			.TxtCodMat.ENABLED = .T.
			.TxtCanDes.ENABLED = .T.
			.TxtPreUni.ENABLED = .T.
			.TxtImpCto.ENABLED = .T.
			.TxtLote.ENABLED	= .t.
			.TxtFchVto.ENABLED	= .t.
			.cmdAceptar2.ENABLED			= .F.
			.cmdCancelar2.ENABLED			= .T.
			.TxtCodmat.MaxLength = GaLenCod(3) 
			.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod(3)-GnLenDiv)
			.CmdHelpCodMat.ENABLED = .T.
			.CmdHelpLote.ENABLED = .T.

			.TxtCodMat.SETFOCUS()
		ENDWITH

		WITH THISFORM.PgfDetalle.PAGES(4)
			** Inicializamos Variables

			.cmdAceptar3.ENABLED			= .T.
			.cmdCancelar3.ENABLED			= .T.
		ENDWITH
	ENDPROC


	PROCEDURE cmdmodificar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		THISFORM.PgfDetalle.Page2.Enabled = .F.
		THISFORM.PgfDetalle.ACTIVEPAGE	= 3

		WITH THISFORM.PgfDetalle.PAGES(3)

			** Habilitamos las variables
			.TxtCodMat.ENABLED	= .T.
			.TxtCandes.ENABLED	= .T.
			.TxtPreUni.ENABLED	= .T.
			.TxtImpCto.ENABLED	= .T.
			.TxtLote.ENABLED	= .T.
			.TxtFchVto.ENABLED	= .T.

			.CmdHelpLote.ENABLED = .T.
			.CmdHelpCodMat.ENABLED = .T.
			.cmdAceptar2.ENABLED			= .T.
			.cmdCancelar2.ENABLED			= .T.

			.TxtCodMat.SETFOCUS()
		ENDWITH

		thisform.LcTipOpe = 'A'  				&& Actualizar item en el detalle
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


		LnControl = 1
		IF lnControl > 0
		*	SELECT (thisform.ccursor_d)
		*	=THISFORM.ObjRefTran.borra_registro_local_detalle()
			THISFORM.Grabar_datos(2,thisform.LcTipOpe)
		*!*		DELETE
		*!*		GO TOP
		**	THISFORM.GenerarLog("0397",THIS.CodigoBoton)
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.ccursor_d)
			* 
		    * CALCULO TOTALES DEL DOCUMENTO
		    *
		    IF (THISFORM.ObjRefTran.lpidpco OR THISFORM.ObjRefTran.lCtoVta)
		       THISFORM.Calcular_Totales
		    ENDIF
		    *
		    WITH THISFORM.PgfDetalle.Page2
				.GrdDetalle.REFRESH()
				.CmdModificar1.ENABLED = LlHayRegistros
				.CmdEliminar1.ENABLED  = LlHayRegistros
			ENDWITH
			THISFORM.CmdIMprimir.ENABLED = LlHayRegistros and Thisform.xreturn<>'E' 
		ENDIF
	ENDPROC


	PROCEDURE txtporigv.LostFocus
		IF thisform.ObjReftran.lpidpco OR thisform.ObjReftran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtpordto.LostFocus
		IF  thisform.ObjReftran.lCtoVta
			thisform.ObjReftran.XfPorDto = this.value
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtimpint.LostFocus
		IF thisform.ObjReftran.lCtoVta
			thisform.ObjReftran.XfImpInt = this.value
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtimpflt.LostFocus
		IF thisform.ObjReftran.lCtoVta
			thisform.ObjReftran.XfImpFlt = this.value
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtimpseg.LostFocus
		IF thisform.ObjReftran.lCtoVta
			thisform.ObjReftran.XfImpSeg  = this.value
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtimpadm.LostFocus
		IF thisform.ObjReftran.lCtoVta
			thisform.ObjReftran.XfImpAdm = this.value
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		M.ERR=THISFORM.VALIDitem() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			this.Parent.txtCanDes.SetFocus()

			RETURN 
		endif
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
		IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
		*
		THIS.PARENT.cmdCancelar2.CLICK()
	ENDPROC


	PROCEDURE cmdcancelar2.Click
		WITH THIS.PARENT.PARENT.PAGES(3)

			*** Deshabilitar Controles
			.CmdHelpCodMat.ENABLED = .F.
			.TxtCodMat.ENABLED = .F.
			.TxtCanDes.ENABLED = .F.
			.TxtPreUni.ENABLED = .F.
			.TxtImpCto.ENABLED = .F.
			.txtLote.ENABLED	= .f.
			.txtFchVto.ENABLED	= .f.
			.cmdAceptar2.ENABLED	= .F.
			.cmdCancelar2.ENABLED	= .F.
			.CmdHelpLote.ENABLED	= .F.
			** Inicializarlos ** 

		ENDWITH

		THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		THIS.ENABLED	= .F.
		WITH THIS.PARENT.PARENT
			.PAGES(2).ENABLED	= .T.
			.ACTIVEPAGE	= 2
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_d)
			.PAGES(2).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(2).cmdEliminar1.ENABLED	= LlHayRegistros
			with thisform
				.cmdImprimir.ENABLED	= LlHayRegistros
			endwith 
			.PAGES(2).grdDetalle.REFRESH()
			.PAGES(2).grdDetalle.SETFOCUS()
		ENDWITH
		IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtcodmat.Valid
		**IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
		   IF EMPTY(this.Value)
		   		RETURN 
		   ENDIF
			M.ERR=THISFORM.VALIDitem() 
			IF m.err<0
				thisform.MensajeErr(m.err)
				RETURN .f.
			endif
		*!*	   IF !SEEK(TRIM(THIS.Value),"CATG","CATG01") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No Existe...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
		*!*	   IF !SEEK(thisform.ObjRefTran.SubAlm+TRIM(THIS.Value),"CALM") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No asignado a este almacen...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
		   THIS.VALUE = c_CodMat.CODMAT
		   THIS.PARENT.TXTDESMAT.VALUE=c_CodMat.DESMAT
		   THIS.PARENT.TXTUNDSTK.VALUE=c_CodMat.UNDSTK
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
		M.ERR=THISFORM.VALIDitem() 
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
		M.ERR=THISFORM.VALIDitem() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			RETURN .f.
		endif
		THIS.VALUE = c_Lote.Lote
		THIS.Parent.TxtFchVto.Value = c_Lote.FchVto
		this.Parent.Cmdaceptar2.Enabled = .t.
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


	PROCEDURE cmdhelpcodigo.Click
		WITH this.Parent.Parent.Parent
		*!*		GocfgAlm.SubAlm = .cboAlmacen.value
		*!*		GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
		*!*		GoCfgAlm.sCodMov=.cboCodmov.value
		endwith


		this.cvaloresfiltro = thisform.ObjRefTran.XsCodDoc
		DODEFAULT()
		this.Parent.TxtCodigo.Value = this.cvalorvalida 
		this.Parent.TxtCodigo.SetFocus
		IF !EMPTY(this.Parent.TxtCodigo.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE cmdhelpcodmat.Click
		WITH this.Parent.Parent.Parent
		*!*		GocfgAlm.SubAlm = .cboAlmacen.value
		*!*		GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
		*!*		GoCfgAlm.sCodMov=.cboCodmov.value
		endwith


		this.cvaloresfiltro = thisform.ObjRefTran.SubAlm
		DODEFAULT()
		this.Parent.TxtCodMat.Value = this.cvalorvalida 
		this.Parent.TxtCodMat.SetFocus
		IF !EMPTY(this.Parent.TxtCodMat.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE txtcodigo.Valid
		**IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
		   IF EMPTY(this.Value)
		   		RETURN 
		   ENDIF
			M.ERR=THISFORM.VALIDitem() 
			IF m.err<0
				thisform.MensajeErr(m.err)
				RETURN .f.
			endif
		*!*	   IF !SEEK(TRIM(THIS.Value),"CATG","CATG01") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No Existe...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
		*!*	   IF !SEEK(thisform.ObjRefTran.SubAlm+TRIM(THIS.Value),"CALM") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No asignado a este almacen...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
		   THIS.VALUE = c_CodMat.CODMAT
		   THIS.PARENT.TXTDESMAT.VALUE=c_CodMat.DESMAT
		   THIS.PARENT.TXTUNDSTK.VALUE=c_CodMat.UNDSTK
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


	PROCEDURE cmdaceptar3.Click
		WITH THIS.PARENT

		    *!* Verifica Actualización de Datos
		    IF THISFORM.xReturn = "I"
				IF EMPTY(.TxtSubAlm.Value) OR ISNULL(.TxtSubAlm.Value)
					=MESSAGEBOX("ERROR : Código de Almacen no puede estar vacío...",48)
					.TxtSubAlm.SetFocus()
					RETURN
				ENDIF
				.TxtSubAlm.VALID()
			ENDIF
			*
			IF EMPTY(.TxtDesSub.Value) OR ISNULL(.TxtDesSub.Value)
				=MESSAGEBOX("ERROR : La Descripción del Almacen no puede estar vacía...",48)
				.TxtDesSub.SetFocus()
				RETURN
			ENDIF
			*
			SELE ALMA 
			m.CodAlm        =  GsCodAlm
			m.SubAlm		= .TxtSubAlm.Value
			m.DesSub		= .TxtDesSub.Value
			m.FchCie        = .TxtFchCie.Value
			*
		ENDWITH
		LnControl = 1
		IF lnControl > 0
			DO CASE

			    *!* Adicionar Registro
				CASE THISFORM.xReturn = "I" 
					INSERT INTO ALMTALMA FROM MEMVAR
					THISFORM.GenerarLog("0395",THIS.PARENT.PARENT.PAGES(1).cmdAdicionar1.CodigoBoton)
					*** Actualizar Cursor Local
					SELE ALMA
					APPEND BLANK
					GATHER MEMVAR

				*!* Modificar Registro
				CASE THISFORM.xReturn = "A"   
					UPDATE ALMTALMA  SET ;
					DesSub   = m.DesSub ,;
					FchCie   = m.FchCie  ;
		    		WHERE CodSed = GsCodSed and SubAlm = m.SubAlm

		   			SELE ALMA 
					GATHER MEMVAR
					THISFORM.GenerarLog("0396",THIS.PARENT.PARENT.PAGES(1).cmdModificar1.CodigoBoton)
			ENDCASE

			THIS.PARENT.cmdCancelar2.CLICK()

		ENDIF
	ENDPROC


	PROCEDURE cmdcancelar3.Click
		WITH THIS.PARENT.PARENT.PAGES(2)

		     ** Deshabilitar Controles
			.TxtSubAlm.ENABLED = .F.     
			.TxtDesSub.ENABLED = .F.
			.TxtFchCie.ENABLED = .F.

			.cmdAceptar2.ENABLED	= .F.
			.cmdCancelar2.ENABLED	= .F.

			** Inicializarlos ** 

		ENDWITH

		THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		THIS.ENABLED	= .F.

		WITH THIS.PARENT.PARENT
			.PAGES(1).ENABLED	= .T.
			.ACTIVEPAGE	= 1
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("ALMA")
			.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdImprimir1.ENABLED	= LlHayRegistros
			.PAGES(1).grdAlmacen.REFRESH()
			.PAGES(1).grdAlmacen.SETFOCUS()
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
		thisform.TOOLS.closetable([DBFS])
		thisform.TOOLS.closetable([DLOTE])
		thisform.tools.closetable([SISTDOCS])
		thisform.tools.closetable([VTAPTOVT])
		thisform.tools.closetable([CBDMTABL])
		thisform.tools.closetable([CBDMAUXI])
		thisform.tools.closetable([TDOC])
		thisform.tools.closetable([UVTA])
		thisform.tools.closetable([DETA])
		thisform.tools.closetable([GDOC])
		thisform.tools.closetable([GUIA])
		thisform.tools.closetable([DOCM])
		thisform.tools.closetable([RPED])
		thisform.tools.closetable([VPED])
		thisform.tools.closetable([CLIE])
		thisform.tools.closetable([C_CORRE])
		thisform.tools.closetable([C_GDOC])
		thisform.tools.closetable([C_DETA])
		thisform.tools.closetable(thisform.objcntpage.c_validcliente)
		thisform.tools.closetable(thisform.objcntpage.c_validNroRef)
		thisform.tools.closetable([C_CODMAT])
		thisform.tools.closetable([V_MATERIALES_X_LOTE])
		thisform.TOOLS.closetable([ALMDLOTE])
		THISFORM.RELEASE
	ENDPROC


	PROCEDURE cmdimprimir.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		LOCAL lcRptTxt , lcRptGraph , lcRptDesc 
		LOCAL LcArcTmp, LcAlias,LnNumReg,LnNumCmp,LlPrimera
		return

		LcArcTmp=GoEntorno.TmpPath+Sys(3)
		**
		LcAlias=ALias()

		THISFORM.Tools.CloseTable("Temporal")

		LnControl = 1
		m.CodigoFamilia=THISFORM.TxtCodigoFamilia.VALUE
		m.CodigoMaterial=CATG.CodMat 
		SELECT Temporal
		SET FILTER TO CodigoCliente=m.CodigoCliente 
		GO TOP
		IF EOF()
			wait window "No existen registros a Listar" NOWAIT
			IF NOT EMPTY(LcAlias)
				SELE (LcAlias)
			ENDIF
			return
		ENDIF


		lcRptTxt	= "ComPr11_GClientes_Asociacion"
		lcRptGraph	= "ComPr11_GClientes_Asociacion"
		lcRptDesc	= "Clientes - Asociaciones"
		IF .f.
			MODI REPORT  ComPr11_GClientes_asociacion
		ENDIF

		DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , THISFORM.DATASESSIONID
		**
		USE IN Temporal
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

		IF THISFORM.xReturn == "E" AND MESSAGEBOX("¿Esta seguro de eliminar la Transaccion ?",32+4+256,"Eliminar Transacción")<>6
			RETURN
		ENDIF

		lControl = THISFORM.Grabar_Datos(4,THISFORM.xReturn)

		IF !EOF(thisform.ccursor_c)                                               
			thisform.objcntpage.CntO_t_Activi.habilita() 
		ELSE
			thisform.objcntpage.CntO_t_Activi.Deshabilita() 
		ENDIF
		IF THISForm.nresulttrn =ASC('D') AND lControl && Nos Vamos al detalle
			thisform.objcntpage.CntO_t_Activi.SetFocus()
			IF thisform.xReturn='I'
				** Una vez grabada cargo los materiales utilizados verificados previamente en almacen
				IF thisform.lignora_id_correlativo 

				ENDIF
				** Ahora agregamos el item para la primera actividad de la O/T 
				thisform.objcntpage.CntO_t_Activi.CmdAdicionar1.Click()
			ENDIF
		ELSE
			IF thisform.xReturn # 'E'
				thisform.Cmdimprimir.Click
			ENDIF
			IF lControl
			   *THISFORM.cmdIniciar.CLICK()
			   THISFORM.INICIAR_VAR()   
			ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_transac
**************************************************


**************************************************
*-- Class:        calculo_credito (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   12/08/21 04:08:13 PM
*
DEFINE CLASS calculo_credito AS custom


	Name = "calculo_credito"

	*-- Arreglo [Array] bi-dimensional para guardas los datos de total facturado, saldos pendientes y linea de credito disponible por cliente.
	DIMENSION aparams[30,2]


	*-- Obtenemos registro de facturacion, linea de credito y saldo disponible del cliente
	PROCEDURE cliente1
		PARAMETERS PsCodCli,PfImporte,PnMoneda,PfTpoCmb,PlDetalle
		IF PARAMETERS()=2
			IF VARTYPE(PfImporte)<>'N'
				PfImporte = 0
			ENDIF
		ENDIF
		IF PARAMETERS()=3
			IF VARTYPE(PnMoneda)<>'N'
				PnMoneda = 0
			ENDIF
			IF !INLIST(PnMoneda,1,2)
				PnMoneda = 1
			ENDIF
		ENDIF
		IF PARAMETERS()=4
			IF VARTYPE(PfTpoCmb)<>'N'
				PfTpoCmb = 0
			ENDIF
			IF PfTpoCmb<0
				PfTpoCmb=0
			ENDIF
		ENDIF

		IF VARTYPE(PSCodCli)<>'C'
			PSCodCli=''
		ENDIF
		IF VARTYPE(PfImporte)<>'N'
			PfImporte  = 0
		ENDIF
		IF VARTYPE(PnMoneda)<>'N'
			PnMoneda = 1
		ENDIF
		IF VARTYPE(PfTpoCmb)<>'N'
			PfTpoCmb = 0
		ENDIF
		IF VARTYPE(PlDetalle)<>'L'
			PlDetalle = .F.
		ENDIF


		IF !USED('CCTCLIEN')
			goentorno.open_dbf1('ABRIR','CCTCLIEN','','CLIEN04','') && ClfAux+CodAux
		ENDIF

		THIS.aParams[1,1]		= 	[CLIENTE: ]+TRIM(CCTCLIEN.RazSoc)
		THIS.aParams[1,2]		= 	PsCodCli
		THIS.aParams[2,1]		=	[Facturación Total S/.    ]
		THIS.aParams[2,2]		=	0
		THIS.aParams[3,1]		=	[Facturación Total US$ ]
		THIS.aParams[3,2]		=	0
		THIS.aParams[4,1]		=	[Linea crédito S/.    ]
		THIS.aParams[4,2]		=	0
		THIS.aParams[5,1]		=	[Linea crédito  US$ ]
		THIS.aParams[5,2]		=	0
		THIS.aParams[6,1]		=	[Saldo Letras  S/.    ]
		THIS.aParams[6,2]		=	0
		THIS.aParams[7,1]		=	[Saldo Letras  US$    ]
		THIS.aParams[7,2]		=	0
		THIS.aParams[8,1]		=	[Saldo Fac/Bol  S/.    ]
		THIS.aParams[8,2]		=	0
		THIS.aParams[9,1]		=	[Saldo Fac/Bol  US$ ]
		THIS.aParams[9,2]		=	0

		THIS.aParams[10,1]		=	[Saldo N/Debito  S/.    ]
		THIS.aParams[10,2]		=	0
		THIS.aParams[11,1]		=	[Saldo N/Debito  US$ ]
		THIS.aParams[11,2]		=	0

		THIS.aParams[12,1]		=	[Saldo N/Crebito  S/.     ]
		THIS.aParams[12,2]		=	0
		THIS.aParams[13,1]		=	[Saldo N/Crebito  US$  ]
		THIS.aParams[13,2]		=	0
		THIS.aParams[14,1]		=	[Saldo Disponible  S/.     ]
		THIS.aParams[14,2]		=	0
		THIS.aParams[15,1]		=	[Saldo Disponible  US$     ]
		THIS.aParams[15,2]		=	0
		THIS.aParams[17,1]		=    'DISPONIBLE EN: '+   IIF(PnMoneda=1,'S/.','US$')
		THIS.aParams[17,2] 		=	0
		This.aParams[17,1]		=	[Deuda Pendiente S/     ]
		This.aParams[17,2]		=	 0
		This.aParams[18,1]		=	[Deuda Pendiente US$ ]
		This.aParams[18,2]		=	 0
		This.aParams[19,1]		=	[Deuda Proforma   S/   ]
		This.aParams[19,2]		=	0
		This.aParams[20,1]		=	[Deuda Proforma US$ ]
		This.aParams[20,2]		=	0
		This.aParams[21,1]		=	[Deuda Total   S/   ]
		This.aParams[21,2]		=	0
		This.aParams[22,1]		=	[Deuda Total US$ ]
		This.aParams[22,2]		=	0
		This.aParams[23,1]		=	[Deuda Consolidada en S/     ]
		This.aParams[23,2]		=	0
		This.aParams[24,1]		=	[Deuda Consolidada en US$ ]
		This.aParams[24,2]		=	0
		This.aParams[25,1]		=	[Tolerancia Deuda  en S/     ]
		This.aParams[25,2]		=	0
		This.aParams[26,1]		=	[Tolerancia Deuda  en US$ ]
		This.aParams[26,2]		=	0


		IF EMPTY(PsCodCli)
			THIS.aParams[16,1]	=	'No existe datos para este codigo de cliente' 
			THIS.aParams[16,2]	=	-1  && No existe datos para ese codigo de cliente
			RETURN @THIS.aParams
		ENDIF
		IF !USED('GDOC')
			goentorno.open_dbf1('ABRIR','CCBRGDOC','GDOC','GDOC01','')
		ENDIF

		IF !USED('VTOS')
			goentorno.open_dbf1('ABRIR','CCBMVTOS','VTOS','VTOS01','')
		ENDIF
		LLCheckPROF = .F.
		IF verifyvar('VTAVPROF','TABLE','INDBC','CIA'+GsCodCia)
			IF !USED('VPRO')
				LLCheckPROF = goentorno.open_dbf1('ABRIR','VTAVPROF','VPRO','GDOC04','')
			ENDIF
		ENDIF

		SELECT CCTCLIEN
		=SEEK(GsClfCli+PsCodCli,'CCTCLIEN','CLIEN04')
		THIS.aParams[1,1]		= 	[CLIENTE: ]+TRIM(CCTCLIEN.RazSoc)
		THIS.aParams[1,2]		= 	PsCodCli

		** VETT  13/01/2016 05:36 PM : Acumulados cuentas por cobrar  
		STORE 0 TO LfCreDis_MN , LfCreDis_ME,LfFactAct1 ,LfFactAct2,LfSalFac1,LfSalFac2,LfSalLet1,LfSalLet2
		STORE 0 TO LfSalDeb1,LfSalDeb2,LfSalCre1,LfSalCre2,LfAbono1,LfAbono2, LfDeuda1,LfDeuda2


		THIS.aParams[16,1]	=	'No existe datos para este codigo de cliente' 
		THIS.aParams[16,2]	=	-1  && No existe datos para ese codigo de cliente
		IF !FOUND()
			RETURN @THIS.aParams
		ENDIF
		LfMaxCre 	=	CCTCLIEN.MaxCre
		LfMaxCreD 	=	CCTCLIEN.MaxCreD
		LfDeuda1	=	CCTCLIEN.Deuda_Nac
		LfDeuda2	=	CCTCLIEN.Deuda_Ext

		DIMENSION vImporte(3)


		SELECT GDOC
		LsOrder=ORDER()
		SET ORDER TO GDOC02
		SEEK PsCodCli
		SCAN WHILE CodCli = PsCodCli FOR INLIST(FlgEst,'C','P')
			WAIT WINDOW 'Procesando cliente: ' + CodCli Nowait
			IF NOT  DATE()>FchVto   && Solo los documentos vencidos a la fecha actual
				LOOP
			ENDIF
			STORE 0 TO vImporte
			THIS.aParams[16,2]		=	0   && Encontro informacion del codigo de cliente
			IF FlgEst='P'
				IF PlDetalle
					LfSdoDoc = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,".T.",@vImporte)
				ELSE
					LfSdoDoc = SdoDoc
				ENDIF       
			ELSE
				LfSdoDoc	= 0
			ENDIF
			       
		*!*				IF LfSdoDoc<>0
		*!*					SET STEP ON 
		*!*				ENDIF

				IF TPODOC='CARGO'
					LfFactAct1 	= LfFactAct1		+ IIF(CodMon=1,ImpTot,0) 
					LfFactAct2   = LfFactAct2		+ IIF(CodMon=2,ImpTot,0) 
					DO CASE
						CASE INLIST(CODDOC,'FACT','BOLE')
							LfSalFac1 	= LfSalFac1		+ IIF(CodMon=1,LfSdoDoc,0) 
							LfSalFac2	= LfSalFac2		+ IIF(CodMon=2,LfSdoDoc,0) 
						CASE	INLIST(CODDOC,'LETR') 
							LfSalLet1 	= LfSalLet1		+ IIF(CodMon=1,LfSdoDoc,0) 
							LfSalLet2	= LfSalLet2		+ IIF(CodMon=2,LfSdoDoc,0) 
						CASE	INLIST(CODDOC,'N/D') 
							LfSalDeb1 	= LfSalDeb1		+ IIF(CodMon=1,LfSdoDoc,0) 
							LfSalDeb2	= LfSalDeb2		+ IIF(CodMon=2,LfSdoDoc,0) 

					ENDCASE
				ELSE
					LfSalCre1 	= LfSalCre1		+ IIF(CodMon=1,LfSdoDoc,0) 
					LfSalCre2	= LfSalCre2		+ IIF(CodMon=2,LfSdoDoc,0) 
				ENDIF

		ENDSCAN
		SELECT GDOC
		SET ORDER TO (LsOrder)

		** VETT  13/01/2016 05:36 PM : Acumulados PROFORMAS 
		STORE 0 TO LfFactProf1 ,LfFactProf2,LfSalProf1,LfSalProf2,LfCreProf1,LfCreProf2,LfAboProf1,LfAboProf2

		IF USED('VPRO')
			SELECT VPRO
			LsOrder=ORDER()
			SET ORDER TO GDOC04
			SEEK PsCodCli
			SCAN WHILE CodCli = PsCodCli FOR INLIST(FlgEst,'C','P')
				WAIT WINDOW 'Procesando cliente: ' + CodCli Nowait

				STORE 0 TO vImporte
			*!*		THIS.aParams[16,1]		=	0   && Encontro informacion del codigo de cliente

				IF FlgEst='P'
					IF PlDetalle
						LfSdoDoc = CCb_Sldo(CodCli,TpoDoc,CodDoc,NroDoc,CodMon,TpoCmb,Imptot,".T.",@vImporte)
					ELSE
						LfSdoDoc = SdoDoc
					ENDIF       
				ELSE
					LfSdoDoc	= 0
				ENDIF
			*!*				IF LfSdoDoc<>0
			*!*					SET STEP ON 
			*!*				ENDIF
				IF TPODOC='CARGO'
					LfFactProf1 	= LfFactProf1	+ IIF(CodMon=1,ImpTot,0) 
					LfFactProf2   	= LfFactProf2	+ IIF(CodMon=2,ImpTot,0) 
					DO CASE
						CASE 	INLIST(CODDOC,'PROF')
							LfSalProf1 	= LfSalProf1		+ IIF(CodMon=1,LfSdoDoc,0) 
							LfSalProf2	= LfSalProf2		+ IIF(CodMon=2,LfSdoDoc,0) 
					ENDCASE
				ELSE
					LfCreProf1 	= LfCreProf1	+ IIF(CodMon=1,LfSdoDoc,0) 
					LfCreProf2	= LfCreProf2	+ IIF(CodMon=2,LfSdoDoc,0) 
				ENDIF
			ENDSCAN
			SELECT VPRO
			SET ORDER TO (LsOrder)
		ENDIF

		** Totales PROFORMA
		LfCarProf1 	= LfSalProf1
		LfCarProf2	= LfSalProf2
		LfAboProf1	= LfCreProf1
		LfAboProf2	= LfCreProf2

		** Totales FACT  BOLE LETR N/D Y N/C
		LfCargo1	= LfSalFac1		+ LFSalDeb1	+ LfSalLet1
		LfCargo2	= LfSalFac2		+ LFSalDeb2	+ LfSalLet2
		LfAbono1	= LfSalCre1
		LfAbono2	= LfSalCre2


		** VETT  16/01/16 01:49 PM :  ** TOTAL SALDOS PENDIENTES  **
		LfSdoCCB1	=	LfCargo1 	- 	LfAbono1  
		LfSdoCCB2	=	LfCargo2 	- 	LfAbono2  


		This.aParams[17,1]		=	[Deuda Pendiente S/  ]
		This.aParams[17,2]		=	 LfSdoCCB1
		This.aParams[18,1]		=	[Deuda Pendiente US$ ]
		This.aParams[18,2]		=	 LfSdoCCB2

		LfSdoProf1	=	LfCarProf1	-	LfAboProf1
		LfSdoProf2	=	LfCarProf2	-	LfAboProf2

		This.aParams[19,1]		=	[Deuda Proforma  S/ ]
		This.aParams[19,2]		=	LfSdoProf1
		This.aParams[20,1]		=	[Deuda Proforma US$ ]
		This.aParams[20,2]		=	LfSdoProf2

		This.aParams[21,1]		=	[Saldo tolerancia  S/ ]
		This.aParams[21,2]		=	LfSdoCCB1 + LfSdoProf1 -   LfDeuda1
		This.aParams[22,1]		=	[Saldo tolerancia US$ ]
		This.aParams[22,2]		=	LfSdoCCB2 + LfSdoProf2 -   LfDeuda2

		** --------------------------------------Tipo de Cambio del dia ---------------------------------------** 
		LfTpoCmb = IIF(PfTpoCmb<=0,GoCfgAlm._TipoCambio(DATE() ) , PfTpoCmb)
		** ------------------------------------------------------------------------------------------------------------------**
		** ----------------------------------- Linea de Credito disponible ----------------------------** 
		LfCreDis_MN =  LfMaxCre	- LfCargo1		+ LfAbono1  - LfSdoProf1
		LfCreDis_ME =  LfMaxCreD	- LfCargo2		+ LfAbono2 -  LfSdoProf2
		** ---------------------------------------------------------------------------------------------------------- **

		This.aParams[23,1]		=	[Deuda total en S/  ]
		This.aParams[23,2]		=	LfSdoCCB1 + LfSdoProf1 	+ ROUND( ( LfSdoCCB2 + LfSdoProf2) * LfTpoCmb,2)
		This.aParams[24,1]		=	[Deuda total en US$ ]
		This.aParams[24,2]		=	LfSdoCCB2 + LfSdoProf2 	+ IIF(LfTpoCmb>0,ROUND( (LfSdoCCB1  + LfSdoProf1) / LfTpoCmb,2) ,0) - LfDeuda2
		*
		This.aParams[25,1]		=	[Tolerancia Deuda  en S/  ]
		This.aParams[25,2]		=	LfDeuda1
		This.aParams[26,1]		=	[Tolerancia Deuda  en US$ ]
		This.aParams[26,2]		=	LfDeuda2


		THIS.aParams[1,1]		= 	[CLIENTE: ]+TRIM(CCTCLIEN.RazSoc)
		THIS.aParams[1,2]		= 	PsCodCli
		THIS.aParams[2,1]		=	[Facturación Total S/     ]
		THIS.aParams[2,2]		=	ROUND(LfFactAct1,2)
		THIS.aParams[3,1]		=	[Facturación Total US$ ]
		THIS.aParams[3,2]		=	ROUND(LfFactAct2,2)
		THIS.aParams[4,1]		=	[Linea crédito S/     ]
		THIS.aParams[4,2]		=	ROUND(LfMaxCre,2)
		THIS.aParams[5,1]		=	[Linea crédito  US$ ]
		THIS.aParams[5,2]		=	ROUND(LfMaxCreD,2)
		THIS.aParams[6,1]		=	[Saldo Letras  S/     ]
		THIS.aParams[6,2]		=	ROUND(LfSalLet1,2)
		THIS.aParams[7,1]		=	[Saldo Letras  US$    ]
		THIS.aParams[7,2]		=	ROUND(LfSalLet2,2)
		THIS.aParams[8,1]		=	[Saldo Fac/Bol  S/     ]
		THIS.aParams[8,2]		=	ROUND(LfSalFac1,2)
		THIS.aParams[9,1]		=	[Saldo Fac/Bol  US$ ]
		THIS.aParams[9,2]		=	ROUND(LfSalFac2,2)

		THIS.aParams[10,1]		=	[Saldo N/Debito  S/     ]
		THIS.aParams[10,2]		=	ROUND(LfSalDeb1,2)
		THIS.aParams[11,1]		=	[Saldo N/Debito  US$ ]
		THIS.aParams[11,2]		=	ROUND(LfSalDeb2,2)

		THIS.aParams[12,1]		=	[Saldo N/Crebito  S/      ]
		THIS.aParams[12,2]		=	ROUND(LfSalCre1,2)
		THIS.aParams[13,1]		=	[Saldo N/Crebito  US$  ]
		THIS.aParams[13,2]		=	ROUND(LfSalCre2,2)
		THIS.aParams[14,1]		=	[Credito Disponible  S/ ]
		THIS.aParams[14,2]		=	ROUND(LfCreDis_MN,2)
		THIS.aParams[15,1]		=	[Credito Disponible  US$ ]
		THIS.aParams[15,2]		=	ROUND(LfCreDis_ME,2)
		THIS.aParams[16,1]		=    	'Listo' 


		DO CASE
			CASE LfCreDis_MN>0 OR LfCreDis_ME>0
					THIS.aParams[16,1]	=    'SALDO DE CREDITO DISPONIBLE CUBRE IMPORTE A FACTURAR ' 
					THIS.aParams[16,2] 	=	2
					LfTotDisp = 0
					IF PnMoneda=1
						LfTotDisp = LfCreDis_MN  +  ROUND(LfCreDis_ME*LfTpoCmb, 2) - PfImporte
						THIS.aParams[14,2]	=	ROUND(LfCreDis_MN,2) - PfImporte
					ELSE
						LfTotDisp = LfCreDis_ME + IIF(LfTpoCmb<>0, ROUND(LfCreDis_MN/LfTpoCmb,2),0) - PfImporte
						THIS.aParams[15,2]	=	ROUND(LfCreDis_ME,2) - PfImporte
					ENDIF
					IF LfTotDisp < 0
						THIS.aParams[16,1]	=    'SALDO DE CREDITO DISPONIBLE INSUFICIENTE'   
						THIS.aParams[16,2] 	=	3
					ENDIF
					THIS.aParams[17,1]	=    'DISPONIBLE EN: '+   IIF(PnMoneda=1,'S/ ','US$')
					THIS.aParams[17,2] 	=	LfTotDisp

			CASE LfCreDis_MN<=0 AND LfCreDis_ME<=0
					THIS.aParams[16,1]	=    'NO CUENTA CON CREDITO DISPONIBLE ' 
					THIS.aParams[16,2]	=    -2
					THIS.aParams[17,1]	=    'DISPONIBLE EN: '+   IIF(PnMoneda=1,'S/ ','US$')
					THIS.aParams[17,2] 	=	0

		ENDCASE

		IF ( This.aParams[21,2]> 0 AND This.aParams[25,2]	<>0 ) OR (This.aParams[22,2]> 0  AND This.aParams[26,2]	<>0 )
			THIS.aParams[16,1]	=    'REGISTRA DEUDAS PENDIENTES ' 
			THIS.aParams[16,2]	=    -3

		ENDIF
		RETURN @THIS.aParams
	ENDPROC


ENDDEFINE
*
*-- EndDefine: calculo_credito
**************************************************


**************************************************
*-- Class:        cntdetalle_detalle_detalle (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   11/19/05 10:20:13 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS cntdetalle_detalle_detalle AS base_container


	Width = 645
	Height = 492
	Enabled = .F.
	ccursor1 = (sys(2015))
	flagedicion = ([])
	*-- Campos de la Clave
	ccmpkey1 = ([])
	*-- Valor de la clave
	cvalkey1 = ([])
	lctipope = ([])
	ctabla_det1 = ([])
	ctabla_det2 = ([])
	ctabla_det3 = ([])
	ccmpkey2 = ([])
	ccmpkey3 = ([])
	cvalkey2 = ([])
	cvalkey3 = ([])
	ccursor2 = (sys(2015))
	ccursor3 = (sys(2015))
	ccmps_id1 = ([])
	ccmps_id2 = ([])
	ccmps_id3 = ([])
	cvalor_id1 = ([])
	cvalor_id2 = ([])
	cvalor_id3 = ([])
	ccmps_id4 = ([])
	cvalor_id4 = ([])
	ccampo_id1 = ([])
	ccampo_id2 = ([])
	ccampo_id3 = ([])
	ccampo_id4 = ([])
	ccmpkey4 = ([])
	cvalkey4 = ([])
	ctabla_det4 = ([])
	ccursor4 = (sys(2015))
	*-- Campos que conforman la llave general que sirve para cargar el grid principal
	ccmpkgen = ([])
	*-- Valor de la llave general que sirve para cargar el grid principal
	cvalkgen = ([])
	*-- Tipo de enlace entre los grid :          1  Cascada , relación  uno a  muchos entre los grids.                    2  Una sola clave ,  todos los grids dependen de una sola clave (cvalkgen)
	ntipoenlace = 1
	*-- Posicion inicial del valor TOP de el boton adicionar
	nbtnadi_top_ini = 32
	*-- Posicion inicial del valor de LEFT del boton adicionar
	nbtnadi_left_ini = 492
	nbtnmod_top_ini = 55
	nbtneli_top_ini = 78
	nbtngrb_top_ini = 102
	nbtncan_top_ini = 125
	*-- Tipo de contenedor:   1 depende de cursor   2  Depende de la cabecera
	ntipo_cnt = 1
	*-- Obtener el foco
	lsetfocus = .T.
	ccursor_local = (sys(2015))
	entidadcorrelativo = ([])
	*-- Valor de llave foranea
	cvalfk1 = ([])
	*-- Valor de llave foranea
	cvalfk2 = ([])
	*-- Valor de llave foranea
	cvalfk3 = ([])
	*-- Valor de llave foranea
	cvalfk4 = ([])
	*-- Campos de la clave foranea
	ccmpfk1 = ([])
	*-- Campos de la clave foranea
	ccmpfk2 = ([])
	*-- Campos de la clave foranea
	ccmpfk3 = ([])
	*-- Campos de la clave foranea
	ccmpfk4 = ([])
	Name = "cntdetalle_detalle_detalle"
	shpBorde.Top = 3
	shpBorde.Left = 5
	shpBorde.Height = 482
	shpBorde.Width = 547
	shpBorde.BackStyle = 0
	shpBorde.BorderStyle = 1
	shpBorde.BorderWidth = 1
	shpBorde.FillStyle = 1
	shpBorde.SpecialEffect = 0
	shpBorde.ColorScheme = 1
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"

	*-- Referencia a grid activo
	ogridactivo = .F.


	ADD OBJECT grddetalle1 AS base_grid WITH ;
		ColumnCount = 3, ;
		FontName = "Arial", ;
		FontSize = 10, ;
		HeaderHeight = 16, ;
		Height = 96, ;
		Left = 18, ;
		MousePointer = 0, ;
		Panel = 1, ;
		RecordSourceType = 4, ;
		RowHeight = 16, ;
		TabIndex = 1, ;
		Top = 24, ;
		Width = 462, ;
		ZOrderSet = 1, ;
		Name = "GrdDetalle1", ;
		Column1.FontName = "Arial", ;
		Column1.FontSize = 10, ;
		Column1.CurrentControl = "Text1", ;
		Column1.Width = 43, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.FontName = "Arial", ;
		Column2.FontSize = 10, ;
		Column2.CurrentControl = "TxtDesSec", ;
		Column2.Width = 275, ;
		Column2.ReadOnly = .T., ;
		Column2.BackColor = RGB(230,255,255), ;
		Column2.Name = "Column2", ;
		Column3.FontName = "Arial", ;
		Column3.FontSize = 10, ;
		Column3.ColumnOrder = 3, ;
		Column3.CurrentControl = "TxtCant_equ", ;
		Column3.Width = 114, ;
		Column3.ReadOnly = .T., ;
		Column3.Sparse = .F., ;
		Column3.BackColor = RGB(255,255,255), ;
		Column3.Name = "Column3"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column1.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column1.txtcodsec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCodSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column1.text1 AS base_textbox WITH ;
		Left = 19, ;
		Top = 23, ;
		Name = "Text1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nombre", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column2.txtdessec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		ControlSource = "", ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtDesSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column3.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Header3", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle1.column3.txtcant_equ AS textbox WITH ;
		FontName = "Arial", ;
		BorderStyle = 0, ;
		Enabled = .T., ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCant_equ"


	ADD OBJECT grddetalle2 AS base_grid WITH ;
		ColumnCount = 3, ;
		FontSize = 10, ;
		HeaderHeight = 16, ;
		Height = 100, ;
		Left = 20, ;
		Panel = 1, ;
		RecordSourceType = 4, ;
		RowHeight = 16, ;
		TabIndex = 2, ;
		Top = 143, ;
		Width = 462, ;
		ZOrderSet = 1, ;
		Name = "GrdDetalle2", ;
		Column1.FontName = "Arial", ;
		Column1.FontSize = 10, ;
		Column1.CurrentControl = "text1", ;
		Column1.Width = 43, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.FontName = "Arial", ;
		Column2.FontSize = 10, ;
		Column2.CurrentControl = "TxtDesSec", ;
		Column2.Width = 275, ;
		Column2.ReadOnly = .T., ;
		Column2.BackColor = RGB(230,255,255), ;
		Column2.Name = "Column2", ;
		Column3.FontName = "Arial", ;
		Column3.FontSize = 10, ;
		Column3.ColumnOrder = 3, ;
		Column3.CurrentControl = "TxtCant_equ", ;
		Column3.Width = 114, ;
		Column3.ReadOnly = .T., ;
		Column3.Sparse = .F., ;
		Column3.BackColor = RGB(255,255,255), ;
		Column3.Name = "Column3"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column1.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column1.txtcodsec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCodSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column1.text1 AS base_textbox WITH ;
		Left = 29, ;
		Top = 24, ;
		Name = "text1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nombre", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column2.txtdessec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		ControlSource = "", ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtDesSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column3.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Header 3", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle2.column3.txtcant_equ AS textbox WITH ;
		BorderStyle = 0, ;
		Enabled = .T., ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCant_equ"


	ADD OBJECT grddetalle3 AS base_grid WITH ;
		ColumnCount = 3, ;
		FontSize = 10, ;
		HeaderHeight = 16, ;
		Height = 92, ;
		Left = 24, ;
		Panel = 1, ;
		RecordSourceType = 4, ;
		RowHeight = 16, ;
		TabIndex = 3, ;
		Top = 264, ;
		Width = 462, ;
		ZOrderSet = 1, ;
		Name = "GrdDetalle3", ;
		Column1.FontName = "Arial", ;
		Column1.FontSize = 10, ;
		Column1.CurrentControl = "Text1", ;
		Column1.Width = 43, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.FontName = "Arial", ;
		Column2.FontSize = 10, ;
		Column2.CurrentControl = "TxtDesSec", ;
		Column2.Width = 275, ;
		Column2.ReadOnly = .T., ;
		Column2.BackColor = RGB(230,255,255), ;
		Column2.Name = "Column2", ;
		Column3.FontName = "Arial", ;
		Column3.FontSize = 10, ;
		Column3.ColumnOrder = 3, ;
		Column3.CurrentControl = "TxtCant_equ", ;
		Column3.Width = 114, ;
		Column3.ReadOnly = .T., ;
		Column3.Sparse = .F., ;
		Column3.BackColor = RGB(255,255,255), ;
		Column3.Name = "Column3"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column1.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column1.txtcodsec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCodSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column1.text1 AS base_textbox WITH ;
		Left = 13, ;
		Top = 23, ;
		Name = "Text1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nombre", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column2.txtdessec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		ControlSource = "", ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtDesSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column3.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Header 3", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle3.column3.txtcant_equ AS textbox WITH ;
		BorderStyle = 0, ;
		Enabled = .T., ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCant_equ"


	ADD OBJECT grddetalle4 AS base_grid WITH ;
		ColumnCount = 3, ;
		FontSize = 10, ;
		HeaderHeight = 16, ;
		Height = 92, ;
		Left = 24, ;
		Panel = 1, ;
		RecordSourceType = 4, ;
		RowHeight = 16, ;
		TabIndex = 3, ;
		Top = 384, ;
		Width = 462, ;
		ZOrderSet = 1, ;
		Name = "GrdDetalle4", ;
		Column1.FontName = "Arial", ;
		Column1.FontSize = 10, ;
		Column1.CurrentControl = "Text1", ;
		Column1.Width = 43, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.FontName = "Arial", ;
		Column2.FontSize = 10, ;
		Column2.CurrentControl = "TxtDesSec", ;
		Column2.Width = 275, ;
		Column2.ReadOnly = .T., ;
		Column2.BackColor = RGB(230,255,255), ;
		Column2.Name = "Column2", ;
		Column3.FontName = "Arial", ;
		Column3.FontSize = 10, ;
		Column3.ColumnOrder = 3, ;
		Column3.CurrentControl = "TxtCant_equ", ;
		Column3.Width = 114, ;
		Column3.ReadOnly = .T., ;
		Column3.Sparse = .F., ;
		Column3.BackColor = RGB(255,255,255), ;
		Column3.Name = "Column3"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column1.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column1.txtcodsec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCodSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column1.text1 AS base_textbox WITH ;
		Left = 13, ;
		Top = 23, ;
		Name = "Text1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nombre", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column2.txtdessec AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		ControlSource = "", ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtDesSec"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column3.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Header 3", ;
		Name = "Header1"


	ADD OBJECT cntdetalle_detalle_detalle.grddetalle4.column3.txtcant_equ AS textbox WITH ;
		BorderStyle = 0, ;
		Enabled = .T., ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtCant_equ"


	ADD OBJECT lbldetalle2 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Detalle 2", ;
		Height = 17, ;
		Left = 21, ;
		Top = 127, ;
		Width = 51, ;
		TabIndex = 21, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 5, ;
		Name = "LblDetalle2"


	ADD OBJECT cmdgrabar1 AS cmdgrabar WITH ;
		Top = 82, ;
		Left = 492, ;
		Height = 24, ;
		Width = 48, ;
		WordWrap = .T., ;
		Caption = "\<Actualiza", ;
		Enabled = .F., ;
		TabIndex = 7, ;
		Visible = .F., ;
		SpecialEffect = 0, ;
		ZOrderSet = 6, ;
		Name = "Cmdgrabar1"


	ADD OBJECT cmdcancelar1 AS cmdcancelar WITH ;
		Top = 106, ;
		Left = 492, ;
		Height = 24, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 8, ;
		Visible = .F., ;
		SpecialEffect = 1, ;
		ZOrderSet = 7, ;
		Name = "Cmdcancelar1"


	ADD OBJECT lbldetalle3 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Detalle 3", ;
		Height = 17, ;
		Left = 22, ;
		Top = 249, ;
		Width = 51, ;
		TabIndex = 22, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 5, ;
		Name = "LblDetalle3"


	ADD OBJECT lbldetalle4 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Detalle 4", ;
		Height = 17, ;
		Left = 23, ;
		Top = 366, ;
		Visible = .F., ;
		Width = 51, ;
		TabIndex = 22, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 5, ;
		Name = "LblDetalle4"


	ADD OBJECT lblgrid AS base_label WITH ;
		Caption = "Observaciones", ;
		Height = 17, ;
		Left = 373, ;
		Top = 3, ;
		Width = 85, ;
		TabIndex = 23, ;
		ZOrderSet = 5, ;
		Name = "LblGrid"


	ADD OBJECT lbldetalle1 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Detalle 1", ;
		Height = 17, ;
		Left = 18, ;
		Top = 7, ;
		Width = 51, ;
		TabIndex = 20, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 5, ;
		Name = "LblDetalle1"


	ADD OBJECT cmdhelpteclas AS base_command WITH ;
		Top = 12, ;
		Left = 588, ;
		Height = 25, ;
		Width = 39, ;
		Picture = "..\..\icons\keybrd01.ico", ;
		Caption = "", ;
		Enabled = .F., ;
		TabIndex = 19, ;
		ToolTipText = "Ver referencia de teclas de edición rapida para detalle del asiento", ;
		Visible = .F., ;
		Name = "CmdHelpTeclas"


	ADD OBJECT cmdadicionar1 AS cmdnuevo WITH ;
		Top = 10, ;
		Left = 492, ;
		Height = 24, ;
		Width = 48, ;
		Picture = "..\..\grafgen\iconos\nuevo.bmp", ;
		Enabled = .T., ;
		Style = 0, ;
		TabIndex = 5, ;
		Visible = .T., ;
		SpecialEffect = 0, ;
		RightToLeft = .F., ;
		Name = "CmdAdicionar1"


	ADD OBJECT cmdmodificar1 AS cmdmodificar WITH ;
		Top = 34, ;
		Left = 492, ;
		Height = 24, ;
		Width = 48, ;
		WordWrap = .T., ;
		Caption = "\<Modificar ", ;
		Enabled = .T., ;
		TabIndex = 4, ;
		Name = "Cmdmodificar1"


	ADD OBJECT cmdeliminar1 AS cmdeliminar WITH ;
		Top = 58, ;
		Left = 492, ;
		Height = 24, ;
		Width = 48, ;
		Enabled = .T., ;
		TabIndex = 6, ;
		Visible = .T., ;
		SpecialEffect = 0, ;
		Name = "Cmdeliminar1"


	ADD OBJECT ctmseccion1 AS base_grid WITH ;
		Top = 60, ;
		Left = 552, ;
		caliascursor = "c_Seccion", ;
		cnombreentidad = "MtoSecMq", ;
		corderby = "CodSec", ;
		Name = "ctmSeccion1"


	ADD OBJECT ctmseccion2 AS base_grid WITH ;
		Top = 180, ;
		Left = 552, ;
		caliascursor = "c_EquSec", ;
		cnombreentidad = "MtoEqSec", ;
		corderby = "CodEqu", ;
		ldinamicgrid = .T., ;
		Name = "ctmSeccion2"


	ADD OBJECT ctmseccion3 AS base_grid WITH ;
		Top = 300, ;
		Left = 552, ;
		caliascursor = "c_ParxEqu", ;
		cnombreentidad = "MtoPxEqu", ;
		corderby = "CodPar", ;
		ldinamicgrid = .T., ;
		Name = "CtmSeccion3"


	ADD OBJECT dataadmin AS dataadmin WITH ;
		Top = 12, ;
		Left = 564, ;
		Height = 17, ;
		Width = 24, ;
		Name = "Dataadmin"


	ADD OBJECT ctmseccion4 AS base_grid WITH ;
		Top = 420, ;
		Left = 552, ;
		caliascursor = "c_Detalle4", ;
		cnombreentidad = "MtoSpect", ;
		corderby = "Cod_Carac", ;
		ldinamicgrid = .T., ;
		Name = "CtmSeccion4"


	PROCEDURE carga_grid
		PARAMETERS LcCursor_D1 ,LcTabla_D1,LcCmpKey,LcValKey,LoGrid
		WITH LoGrid && this.grdDetalle  
			.RECORDSOURCE = ""
			.RECORDSOURCETYPE = 4


		*!*		LsLlave=this.RecordSource+'.Rubro+'+this.RecordSource+'.Nota'
		*!*		LsNota = this.RecordSource+'.Nota'
		*!*		LsNota = EVALUATE(LsNota)
			IF !VARTYPE(LoDa)='O' 
				LOCAL LoDa As dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
				LoDa=CREATEOBJECT('dosvr.DataAdmin') 

			ENDIF
			** ----- **
			THIS.Ccursor_local = LcCursor_D1
			this.cCmpkey = LcCmpKey
			this.cValkey = LcValKey
			** ----- **
			IF USED(LcCursor_D1)
				USE IN (LcCursor_D1)
			ENDIF
			LoDa.GenCursor(LcCursor_D1 ,LcTabla_D1 ,'',LcCmpKey,LcValKey)


			.RECORDSOURCETYPE	= 1
			.RECORDSOURCE		= LcCursor_D1
		*!*		.COLUMNS(1).CONTROLSOURCE	= "LOCAL_Activo_N.Nota"
		*!*		.COLUMNS(2).CONTROLSOURCE	= "LOCAL_Activo_N.CodCta"
		*!*		.COLUMNS(3).CONTROLSOURCE	= "LOCAL_Activo_N.NomCta"
		*!*	 	.COLUMNS(4).CONTROLSOURCE	= "LOCAL_Activo_N.Signo"
		*!*		.COLUMNS(5).CONTROLSOURCE	= "LOCAL_Activo_N.ForMa"


			.Refresh()  

			LlSinRegistros=thisform.tools.cursor_esta_vacio(LcCursor_D1) 
			this.cmdAdicionar2.Enabled = .t.
			this.cmdmodificar2.Enabled = .t.  
			this.cmdEliminar2.Enabled = !LlSinregistros  

		ENDWITH 
	ENDPROC


	PROCEDURE habilita_grid
		PARAMETERS LoGrid,LlHabilita
		THISFORM.LockScreen = .T.
		LOCAL kk ,jj
		WITH LoGrid
			.Readonly = !LlHabilita
			FOR kk = 1 TO .ColumnCount 

				IF UPPER(.columns(kk).Tag) = 'X'	&& Lo Deja como esta
					LOOP
				ENDIF
				.columns(kk).Readonly = !LlHabilita
				FOR jj = 1 TO .columns[kk].controlcount

					IF .columns[kk].controls[jj].baseclass = 'Combobox'
						.columns(kk).controls[jj].Enabled = LlHabilita
					ENDIF
				ENDFOR
			NEXT
			WITH THIS
				.CmdAdicionar1.Enabled 	= !LlHabilita
				.CmdAdicionar1.Visible  = !LlHabilita
				.CmdModificar1.Enabled 	= !LlHabilita
				.CmdModificar1.Visible 	= !LlHabilita
				.Cmdeliminar1.Enabled 	= !LlHabilita
				.Cmdeliminar1.Visible 	= !LlHabilita
				.CmdCancelar1.Visible  	= LlHabilita
				.CmdCancelar1.Enabled 	= LlHabilita
				.Cmdgrabar1.Enabled 	= LlHabilita
				.Cmdgrabar1.Visible 	= LlHabilita
				.LblGrid.Caption		= IIF(LoGrid.ReadOnly,'Consultando','Modificando')
				.CmdHelpTeclas.Visible	= .f. && LlHabilita
				.CmdHelpTeclas.Enabled	= .f. && LlHabilita
			ENDWITH
			IF LlHabilita

				.Column2.SetFocus()
			ELSE
				* this.cmdimprimir.SetFocus
			ENDIF
		ENDWITH
		THISFORM.LockScreen = .F.
	ENDPROC


	PROCEDURE borra_item_blanco_grid
		PARAMETERS LoGrid,LcCmpKey
		WITH LoGrid
			SELECT (.RecordSource)
			IF EMPTY(EVALUATE(LcCmpKey)) OR (this.LcTipOpe = 'I' AND !EMPTY(EVALUATE(LcCmpKey)) )
				DELETE
				IF !EOF()
					GO bott
				ENDIF
				.refresh
				.column2.SetFocus() 
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE agrega_item_grid
		PARAMETERS LoGrid
		this.graba_cmps_key(LoGrid)
		this.graba_datos_adic(LoGrid) 
	ENDPROC


	PROCEDURE graba_detalle
		Parameter LcTipOpe,LcCursor,LcCmpKey,LcValKey,LcTabla 
		***********************
		** Regraba todo cada vez que cambian los datos
		***********************
		DIMENSION laValoresClaveDestino(1)
		STORE '' TO laValoresClaveDestino
		THIS.ctmSeccion1.chrtoarray( LcCmpKey , "+" , @laValoresClaveDestino )
		LsCmdGather = "GATHER MEMVAR FIELDS EXCEPT " 
		FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
			LsCmdGather = LsCmdGather + laValoresClaveDestino(LnNumCmp) + IIF(LnNumCmp=ALEN(laValoresClaveDestino),"",",")
		ENDFOR
		RegVal    = "&LcCmpKey = LcValKey" 
		LnSelect= SELECT()
		SELECT (LcTabla)
		SEEK LcValKey
		*!*	IF FOUND()
		*!*		DELETE REST  WHILE &Regval.
		*!*	ENDIF
		SELECT (LcCursor)
		SCAN WHILE &Regval.
			SCATTER MEMVAR 
			SELECT(LcTabla) 
			SEEK LcValKey
			IF !FOUND()
				APPEND BLANK
				GATHER MEMVAR
			ELSE
				&LsCmdGather.
			ENDIF
			UNLOCK 
			SELECT (LcCursor)
			this.Graba_Detalle_Adicional(LcTipOpe,LcCursor,LcCmpKey,LcValKey,LcTabla )
			SELECT (LcCursor)
		ENDSCAN 
		SELECT (LnSelect)
		RETURN .t.
	ENDPROC


	*-- Valida los componentes de la clave del item que se esta editando
	PROCEDURE validitem
		PARAMETERS loGrid
		LsValCmpCol=EVALUATE(LoGrid.column1.ControlSource)
		IF this.ntipoenlace =2
			*STORE this.ccmpKgen TO this.cCmpKey1,this.cCmpKey2,this.cCmpKey3,this.ccmpkey4
			STORE this.cValKgen TO this.cValKey1,this.cValKey2,this.cValKey3,this.cValkey4
		ENDIF
		WITH this
		DO CASE 
			CASE Logrid.Name = 'GrdDetalle1'
				.cValKey1 = this.concatenavalores(.cCmpKey1,LoGrid.RecordSource,'+') 
				LoGrid.cCmpKey			=	.cCmpKey1
				LoGrid.cValKey			= 	.cValKey1
				LoGrid.cCmps_id			=	.cCmps_id1
				LoGrid.cCampo_Id		= 	.cCampo_id1
				LoGrid.cTabla_Remota	=	.ctabla_det1
		*!*			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
			CASE Logrid.Name = 'GrdDetalle2'
				.cValKey2 = this.concatenavalores(.cCmpKey2,LoGrid.RecordSource,'+') 
				LoGrid.cCmpKey			=	.cCmpKey2
				LoGrid.cValKey			= 	.cValKey2
				LoGrid.cCmps_id			=	.cCmps_id2
				LoGrid.cCampo_Id		= 	.cCampo_id2
				LoGrid.cTabla_Remota	=	.ctabla_det2
		*!*			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
			CASE Logrid.Name = 'GrdDetalle3'
				.cValKey3 = this.concatenavalores(.cCmpKey3,LoGrid.RecordSource,'+') 
				LoGrid.cCmpKey			=	.cCmpKey3
				LoGrid.cValKey			= 	.cValKey3
				LoGrid.cCmps_id			=	.cCmps_id3
				LoGrid.cCampo_Id		= 	.cCampo_id3
				LoGrid.cTabla_Remota	=	.ctabla_det3
		*!*			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
			CASE Logrid.Name = 'GrdDetalle4'
				.cValKey4 = this.concatenavalores(.cCmpKey4,LoGrid.RecordSource,'+') 
				LoGrid.cCmpKey			=	.cCmpKey4
				LoGrid.cValKey			= 	.cValKey4
				LoGrid.cCmps_id			=	.cCmps_id4
				LoGrid.cCampo_Id		= 	.cCampo_id4
				LoGrid.cTabla_Remota	=	.ctabla_det4
		*!*			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
		ENDCASE
		*!*		.cmdModificar1.ENABLED	= LlHayRegistros && and Modificar
		*!*		.cmdEliminar1.ENABLED	= LlHayRegistros && and Modificar
		*!*		.CmdAdicionar1.ENABLED  = .t. && Modificar
		ENDWITH  
	ENDPROC


	*-- Graba  campos de la clave
	PROCEDURE graba_cmps_key
		PARAMETERS LoGrid
		DIMENSION laValoresClaveDestino(1)
		STORE '' TO laValoresClaveDestino

		DO CASE 
			CASE this.ntipoenlace = 1
				DO CASE 
					CASE Logrid.Name = 'GrdDetalle1'
						THIS.ctmSeccion1.chrtoarray( THIS.cCmpKGen , "+" , @laValoresClaveDestino )
						SELECT (LoGrid.Recordsource)
						APPEND BLANK
						FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
							LsCmpEva 	=	This.ccursor_local + '.' + laValoresClaveDestino(LnNumCmp)
							LsCampo		=   LoGrid.RecordSource+ '.' + laValoresClaveDestino(LnNumCmp)
							REPLACE (LsCampo)	WITH  EVALUATE(LsCmpEva)
						ENDFOR
					    LcValKey	=	eval(this.ccmps_id1)
					    LcCmpKey	=	this.ccmps_id1
					    LcCmp_id 	=	this.ccampo_id1
					    REPLACE &LcCmp_id      WITH    this.dataadmin.Cap_nroitm(LcValKey,this.ctabla_Det1,LcCmpKey,LcCmp_id)

					CASE Logrid.Name = 'GrdDetalle2'
						THIS.ctmSeccion1.chrtoarray( LoGrid.ccmps_id , "+" , @laValoresClaveDestino )
						SELECT (LoGrid.Recordsource)
						APPEND BLANK
						FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
							LsCmpEva 	=	This.GrdDetalle1.RecordSource + '.' + laValoresClaveDestino(LnNumCmp)
							LsCampo		=   LoGrid.RecordSource+ '.' + laValoresClaveDestino(LnNumCmp)
							REPLACE (LsCampo)	WITH  EVALUATE(LsCmpEva)
						ENDFOR
					    LcValKey	= eval(this.ccmps_id2)
					    LcCmpKey	= this.ccmps_id2
					    LcCmp_id 	=  this.ccampo_id2
					    REPLACE &LcCmp_id      WITH    this.dataadmin.Cap_NroItm(LcValKey,this.ctabla_Det2,LcCmpKey,LcCmp_id)
					CASE Logrid.Name = 'GrdDetalle3'
						THIS.ctmSeccion1.chrtoarray( LoGrid.ccmps_id , "+" , @laValoresClaveDestino )
						SELECT (LoGrid.Recordsource)
						APPEND BLANK
						FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
							LsCmpEva 	=	This.GrdDetalle2.RecordSource + '.' + laValoresClaveDestino(LnNumCmp)
							LsCampo		=   LoGrid.RecordSource+ '.' + laValoresClaveDestino(LnNumCmp)
							REPLACE (LsCampo)	WITH  EVALUATE(LsCmpEva)
						ENDFOR
					    LcValKey	= eval(this.ccmps_id3)
					    LcCmpKey	= this.ccmps_id3
					    LcCmp_id 	=  this.ccampo_id3
					    REPLACE &LcCmp_id      WITH    this.dataadmin.Cap_NroItm(LcValKey,this.ctabla_Det3,LcCmpKey,LcCmp_id)
					CASE Logrid.Name = 'GrdDetalle4'
						THIS.ctmSeccion1.chrtoarray( LoGrid.ccmps_id , "+" , @laValoresClaveDestino )
						SELECT (LoGrid.Recordsource)
						APPEND BLANK
						FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
							LsCmpEva 	=	This.GrdDetalle3.RecordSource + '.' + laValoresClaveDestino(LnNumCmp)
							LsCampo		=   LoGrid.RecordSource+ '.' + laValoresClaveDestino(LnNumCmp)
							REPLACE (LsCampo)	WITH  EVALUATE(LsCmpEva)
						ENDFOR
					    LcValKey	= eval(this.ccmps_id4)
					    LcCmpKey	= this.ccmps_id4
					    LcCmp_id 	=  this.ccampo_id4
					    REPLACE &LcCmp_id      WITH    this.dataadmin.Cap_NroItm(LcValKey,this.ctabla_Det4,LcCmpKey,LcCmp_id)
					    
				ENDCASE 
			CASE this.ntipoenlace = 2
				THIS.ctmSeccion1.chrtoarray( THIS.cCmpKGen , "+" , @laValoresClaveDestino )
				SELECT (LoGrid.Recordsource)
				APPEND BLANK
				FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
					LsCmpEva 	=	This.ccursor_local + '.' + laValoresClaveDestino(LnNumCmp)
					LsCampo		=   LoGrid.RecordSource+ '.' + laValoresClaveDestino(LnNumCmp)
					REPLACE (LsCampo)	WITH  EVALUATE(LsCmpEva)
				ENDFOR
				IF LoGrid.lGen_id
				    LcValKey	=	eval(THIS.cCmpKGen)
				    LcCmpKey	=	THIS.cCmpKGen
				    LcCmp_id 	=	LoGrid.ccampo_id
				    REPLACE &LcCmp_id      WITH    this.dataadmin.Cap_nroitm(LcValKey,LoGrid.cTabla_Remota,LcCmpKey,LcCmp_id)
				ENDIF
		ENDCASE 
		LoGrid.Refresh 
		LoGrid.column2.SetFocus() 
	ENDPROC


	PROCEDURE borra_item_grid
		PARAMETERS LoGrid

		this.Validitem(LoGrid) 
		this.borra_detalle(thisform.LcTipOpe,LoGrid.Recordsource,LoGrid.ccmpkey,LoGrid.cValKey,LoGrid.ctabla_remota)
		WITH LoGrid && this.Parent.grdDetalle1
			SELECT (.Recordsource)
			DELETE
			.Refresh 
			.column1.SetFocus() 
		ENDWITH

		RETURN .t.
	ENDPROC


	PROCEDURE vincular_controles
		PARAMETERS LoGrid,LsCmpKey,LsValKey
		IF PARAMETERS()<2
			LsCmpKey = ''
			LsValKey = ''

		ENDIF
		IF VARTYPE(LsCmpKey)<>'C'
			LsCmpKey = ''
		ENDIF
		IF VARTYPE(LsValKey)<>'C'
			LsValKey = ''
		ENDIF


		LOCAL LsWhere as String
		IF !EMPTY(LsCmpKey )  && AND !EMPTY(LsValKey)
			LsWhere = " AND "+ LsCmpKey + "= '"+ LsValKey +"'"
		ELSE
			LsWhere = ''
		ENDIF

		WITH THIS 
			LoGrid.RECORDSOURCE = ""
			LoGrid.RECORDSOURCETYPE = 4
			** Codigo por mejorar por ahora lo dejamos asi VETT 2005/06/01
			DO CASE 
				CASE Logrid.Name = 'GrdDetalle1'
					.CtmSeccion1.cWhereSql = LsWhere
					.CtmSeccion1.VINCULARGRID(LoGrid)
					IF !.CtmSeccion1.CONFIGURARGRIDCONSULTA()
						RETURN .F.
					ENDIF
					.CtmSeccion1.GENERARCURSOR()
					THIS.cCursor1 = .ctmSeccion1.caliascursor
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
				CASE Logrid.Name = 'GrdDetalle2'
					this.ctmSeccion2.cwheresql = LsWhere
					.CtmSeccion2.VINCULARGRID(LoGrid)
					IF !.CtmSeccion2.CONFIGURARGRIDCONSULTA()
						RETURN .F.
					ENDIF
					.CtmSeccion2.GENERARCURSOR()
					THIS.cCursor2 = .ctmSeccion2.caliascursor
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)

				CASE Logrid.Name = 'GrdDetalle3'
					THIS.ctmSeccion3.cwheresql = LsWhere
					.CtmSeccion3.VINCULARGRID(LoGrid)
					IF !.CtmSeccion3.CONFIGURARGRIDCONSULTA()
						RETURN .F.
					ENDIF
					.CtmSeccion3.GENERARCURSOR()
					THIS.cCursor3 = .ctmSeccion3.caliascursor
					LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
			ENDCASE 
			IF this.ogridactivo.Name=LoGrid.Name
				.cmdModificar1.ENABLED	= LlHayRegistros && and Modificar
				.cmdEliminar1.ENABLED	= LlHayRegistros && and Modificar
				.CmdAdicionar1.ENABLED  = .t. && Modificar
			ENDIF 
			.LblGrid.Caption = IIF(LoGrid.ReadOnly,'Consultando','Modificando')
		ENDWITH

	ENDPROC


	*-- Borra item de la tabla remota
	PROCEDURE borra_detalle
		Parameter LcTipOpe,LcCursor,LcCmpKey,LcValKey,LcTabla 
		LOCAL LcRegVal AS String
		LcRegVal    = "&LcCmpKey = LcValKey" 
		LnSelect= SELECT()
		SELECT (LcTabla)
		SEEK LcValKey
		IF FOUND()
			DELETE REST  WHILE &LcRegVal.
		ENDIF
		SELECT (LnSelect)
	ENDPROC


	*-- Actualiza el contenido de los grids
	PROCEDURE refrescar
		PARAMETERS LcGrid
		DO CASE 
			CASE This.ntipoenlace = 1
				IF '1'$LcGrid  AND this.GrdDetalle1.Visible 
					*this.cCmpKey1=this.ccmpkgen
					*this.cValKey1=this.cValkgen
					this.Vincular_controles(this.GrdDetalle1,this.ccmpkgen,this.cvalkgen) 
					this.validitem(this.GrdDetalle1) 
				ENDIF
				IF '2'$LcGrid AND this.GrdDetalle2.Visible 
					this.vincular_controles(this.GrdDetalle2,this.GrdDetalle1.ccmpkey,this.GrdDetalle1.cvalkey ) 
					this.validitem(this.GrdDetalle2) 
				ENDIF
				IF '3'$LcGrid AND this.GrdDetalle3.Visible 
					this.vincular_controles(this.GrdDetalle3,this.GrdDetalle2.ccmpkey,this.GrdDetalle2.cvalkey ) 
					this.validitem(this.GrdDetalle3) 
				ENDIF
				IF '4'$LcGrid AND this.GrdDetalle4.Visible 
					this.vincular_controles(this.GrdDetalle4,this.GrdDetalle3.ccmpkey,this.GrdDetalle3.cvalkey ) 
					this.validitem(this.GrdDetalle4) 
				ENDIF
			CASE This.ntipoenlace = 2
				IF '1'$LcGrid AND this.GrdDetalle1.Visible 
					this.Vincular_controles(this.GrdDetalle1,this.ccmpkgen,this.cvalkgen) 
					this.validitem(this.GrdDetalle1) 
				ENDIF
				IF '2'$LcGrid AND this.GrdDetalle2.Visible 
					this.vincular_controles(this.GrdDetalle2,this.ccmpkgen,this.cvalkgen ) 
					this.validitem(this.GrdDetalle2) 
				ENDIF
				IF '3'$LcGrid AND this.GrdDetalle3.Visible 
					this.vincular_controles(this.GrdDetalle3,this.ccmpkgen,this.cvalkgen ) 
					this.validitem(this.GrdDetalle3) 
				ENDIF
				IF '4'$LcGrid AND this.GrdDetalle4.Visible 
					this.vincular_controles(this.GrdDetalle4,this.ccmpkgen,this.cvalkgen ) 
					this.validitem(this.GrdDetalle4) 
				ENDIF

		ENDCASE

		IF VARTYPE(this.oGridActivo)='0'
			IF this.lsetfocus 
				this.oGridActivo.Setfocus()
			ENDIF
		ENDIF
	ENDPROC


	*-- Activa los botones de edicion segun el grid en el que se esta posicionado
	PROCEDURE activar_botones
		IF EMPTY(this.LcTipOpe)
			RETURN
		ENDIF
		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(this.ogridactivo.RecordSource)

		LnLeft			=	This.nBtnAdi_Left_Ini
		LnTopAdi		=	This.nBtnAdi_Top_Ini + this.ogridactivo.r_top 
		this.cmdAdicionar1.Move(Lnleft,LnTopAdi)  
		LnTopMod		=	This.nBtnAdi_Top_Ini + this.CmdAdicionar1.Height + this.ogridactivo.r_top 
		this.CmdModificar1.Move(Lnleft,LnTopMod)  
		LnTopEli		=	This.nBtnAdi_Top_Ini + this.CmdAdicionar1.Height*2 + this.ogridactivo.r_top 
		this.CmdEliminar1.Move(Lnleft,LnTopEli)  
		LnTopGrb		=	This.nBtnAdi_Top_Ini + this.CmdAdicionar1.Height*3 + this.ogridactivo.r_top 
		this.Cmdgrabar1.Move(Lnleft,LnTopGrb)  
		LnTopCnl		=	This.nBtnAdi_Top_Ini + this.CmdAdicionar1.Height*4 + this.ogridactivo.r_top 
		this.Cmdcancelar1.Move(Lnleft,LnTopCnl)  

		THIS.cmdModificar1.ENABLED	= LlHayRegistros && and Modificar
		THIS.cmdEliminar1.ENABLED	= LlHayRegistros && and Modificar
		THIS.CmdAdicionar1.ENABLED  = .t. && Modificar
	ENDPROC


	*-- Graba datos adicionales en el registro activo del grid
	PROCEDURE graba_datos_adic
		PARAMETERS LoGrid
	ENDPROC


	*-- Graba datos adicionales provenientes del cursor a otras tablas distinta al origen de datos del grid
	PROCEDURE graba_detalle_adicional
		Parameters LcTipOpe,LcCursor,LcCmpKey,LcValKey,LcTabla 
	ENDPROC


	*-- Genera una cadena con los valores de los campos que conforman la clave
	PROCEDURE concatenavalores
		PARAMETERS _cCmpKey,_cDataSource,_cSeparador,_cConcatenador
		IF EMPTY(_cCmpKey) 
			RETURN ''
		ENDIF

		IF EMPTY(_cDataSource) 
			RETURN ''
		ENDIF
		IF EMPTY(_cSeparador) OR ISNULL(_cSeparador)
			_cSeparador = ''
		ENDIF
		IF EMPTY(_cConcatenador) OR ISNULL(_cConcatenador)
			_cConcatenador = ''
		ENDIF

		LOCAL LcValKey AS STRING 

		LOCAL ARRAY  laValoresClaveDestino(1)
		STORE '' TO laValoresClaveDestino,lcValKey
		=chrtoarray(_cCmpKey , _cSeparador , @laValoresClaveDestino )
		FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
			LsCmpEva 	=	_cDataSource+'.'+laValoresClaveDestino(LnNumCmp)
			LcValKey	= LcValKey + EVALUATE(LsCmpEva)+IIF(LnNumCmp=ALEN(laValoresClaveDestino),'',_cConcatenador)
		ENDFOR

		RETURN LcValKey
	ENDPROC


	*-- Inicializa grids
	PROCEDURE init_grids
		LOCAL LoGrid,LsCmpKey,LsValKey,K
		LsCmpKey = ''
		LsValKey = CHR(255)
		FOR K = 1 TO  this.ControlCount 

		IF this.Controls(K).BaseClass='Grid'
			LoGrid = this.Controls(K)
			LsCmpKey = LoGrid.cCmps_Id
			LoGrid.Visible = IIF(LOGrid.TAG = 'X',.F.,.T.)
			LOCAL LsWhere as String
			IF !EMPTY(LsCmpKey )  && AND !EMPTY(LsValKey)
				LsWhere = " AND "+ LsCmpKey + "= '"+ LsValKey +"'"
			ELSE
				LsWhere = ''
			ENDIF

			WITH THIS 
				LoGrid.RECORDSOURCE = ""
				LoGrid.RECORDSOURCETYPE = 4
				** Codigo por mejorar por ahora lo dejamos asi VETT 2005/06/01
				DO CASE 
					CASE Logrid.Name = 'GrdDetalle1'  AND LoGrid.Visible
						IF USED(.ctmSeccion1.caliascursor)
							DELETE FROM (.ctmSeccion1.caliascursor)
						ENDIF
		*!*					.CtmSeccion1.cWhereSql = LsWhere
						.CtmSeccion1.VINCULARGRID(LoGrid)
		*!*					IF !.CtmSeccion1.CONFIGURARGRIDCONSULTA()
		*!*						RETURN .F.
		*!*					ENDIF
		*!*					.CtmSeccion1.GENERARCURSOR()
		*!*					THIS.cCursor1 = .ctmSeccion1.caliascursor
						LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
					CASE Logrid.Name = 'GrdDetalle2'	AND LoGrid.Visible 
						IF USED(.ctmSeccion2.caliascursor)
							DELETE FROM (.ctmSeccion2.caliascursor)
						ENDIF
		*!*					this.ctmSeccion2.cwheresql = LsWhere
						.CtmSeccion2.VINCULARGRID(LoGrid)
		*!*					IF !.CtmSeccion2.CONFIGURARGRIDCONSULTA()
		*!*						RETURN .F.
		*!*					ENDIF
		*!*					.CtmSeccion2.GENERARCURSOR()
		*!*					THIS.cCursor2 = .ctmSeccion2.caliascursor
						LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
					CASE Logrid.Name = 'GrdDetalle3'	AND LoGrid.Visible
						IF USED(.ctmSeccion3.caliascursor)
							DELETE FROM (.ctmSeccion3.caliascursor)
						ENDIF
		*!*					THIS.ctmSeccion3.cwheresql = LsWhere
						.CtmSeccion3.VINCULARGRID(LoGrid)
		*!*	 				.CtmSeccion3.GENERARCURSOR()
		*!*					THIS.cCursor3 = .ctmSeccion3.caliascursor
						LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)

					CASE Logrid.Name = 'GrdDetalle4'	AND LoGrid.Visible
						IF USED(.ctmSeccion4.caliascursor)
							DELETE FROM (.ctmSeccion4.caliascursor)
						ENDIF
		*!*					THIS.ctmSeccion4.cwheresql = LsWhere
						.CtmSeccion4.VINCULARGRID(LoGrid)
		*!*					IF !.CtmSeccion4.CONFIGURARGRIDCONSULTA()
		*!*						RETURN .F.
		*!*					ENDIF
		*!*					.CtmSeccion3.GENERARCURSOR()
		*!*					THIS.cCursor4 = .ctmSeccion4.caliascursor
						LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)


				ENDCASE 
		*!*			IF this.ogridactivo.Name=LoGrid.Name
		*!*				.cmdModificar1.ENABLED	= LlHayRegistros && and Modificar
		*!*				.cmdEliminar1.ENABLED	= LlHayRegistros && and Modificar
		*!*				.CmdAdicionar1.ENABLED  = .t. && Modificar
		*!*			ENDIF 
				.LblGrid.Caption = IIF(LoGrid.ReadOnly,'Consultando','Modificando')
			ENDWITH

		ENDIF

		ENDFOR
	ENDPROC


	*-- Activa botones de control del grid
	PROCEDURE activabotones
		PARAMETERS loGrid
		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(LoGrid.Recordsource)
		this.cmdModificar1.ENABLED	= LlHayRegistros && and Modificar
		this.cmdEliminar1.ENABLED	= LlHayRegistros && and Modificar
		this.CmdAdicionar1.ENABLED  = .t. && Modificar
	ENDPROC


	PROCEDURE Destroy
		IF TYPE("THIS.grdDetalle")=="O"
			WITH THIS.grdDetalle
				.RECORDSOURCE		= ""
				.RECORDSOURCETYPE	= 4
				.COLUMNCOUNT		= 5
			ENDWITH
		ENDIF
		IF USED(THIS.cCursor1)
			USE IN (THIS.cCursor1)
		ENDIF
	ENDPROC


	PROCEDURE habilita
		this.Enabled = .t.
		this.lcTipOpe = 'C'
		this.ogridactivo = this.grdDetalle1
		*!*	LlReturn=this.Vincular_controles(this.ogridactivo,this.ccmpkgen,this.cvalkgen) 
		*!*	this.grdDetalle1.setfocus()		&& Obliga a cargar los valores del grid siguiente
		*!*	this.grdDetalle2.setfocus()		&& Obliga a cargar los valores del grid siguiente
		*!*	this.grdDetalle3.setfocus()		&& Obliga a cargar los valores del grid siguiente
		this.refrescar('1234')
		IF this.lsetfocus 
			this.ogridactivo.setfocus()		&& Volvemos al grid principal
		ENDIF
	ENDPROC


	PROCEDURE deshabilita
		this.Enabled = .f.
		this.LcTipOpe = ''
	ENDPROC


	PROCEDURE LostFocus
		**this.lctipope =''
	ENDPROC


	PROCEDURE Init
		This.nBtnAdi_Top_Ini	=	this.cmdAdicionar1.Top
		This.nBtnAdi_Left_Ini	=	this.cmdAdicionar1.Left
		This.nBtnMod_Top_Ini	=	this.cmdModificar1.Top
		This.nBtnEli_Top_Ini	=	this.cmdEliminar1.Top
		This.nBtnGrb_Top_Ini	=	this.cmdGrabar1.Top
		This.nBtnCan_Top_Ini	=	this.cmdCancelar1.Top
		this.grdDetalle1.r_top	=	this.GrdDetalle1.top
	ENDPROC


	*-- Convierte cadena separada por un caracter  especifico en un vector (arreglo )
	PROCEDURE chrtoarray
	ENDPROC


	PROCEDURE modifica_item_grid
	ENDPROC


	PROCEDURE graba_item_grid
	ENDPROC


	PROCEDURE grddetalle1.AfterRowColChange
		LPARAMETERS nColIndex
		*DODEFAULT()
		this.Parent.validitem(this) 
		*this.Parent.vincular_controles(this.Parent.GrdDetalle2,this.ccmpkey,this.cvalkey ) 
		IF this.parent.ntipoenlace  =1
			this.Parent.refrescar('234') 
		ENDIF 
		this.Parent.activabotones(this) 
	ENDPROC


	PROCEDURE grddetalle1.When
		this.Parent.ogridactivo=this
		this.Parent.activar_botones() 
	ENDPROC


	PROCEDURE grddetalle2.When
		this.Parent.ogridactivo=this
		this.Parent.activar_botones() 
	ENDPROC


	PROCEDURE grddetalle2.AfterRowColChange
		LPARAMETERS nColIndex
		*DODEFAULT()
		this.Parent.validitem(this) 
		*this.Parent.vincular_controles(this.Parent.GrdDetalle3,this.ccmpkey,this.cvalkey) 
		IF this.parent.ntipoenlace  =1
			this.Parent.refrescar('34') 
		ENDIF
		this.Parent.activabotones(this) 
	ENDPROC


	PROCEDURE grddetalle3.When
		this.Parent.ogridactivo=this
		this.Parent.activar_botones() 
	ENDPROC


	PROCEDURE grddetalle3.AfterRowColChange
		LPARAMETERS nColIndex
		*DODEFAULT()
		this.Parent.validitem(this) 
		IF this.parent.ntipoenlace  =1
			this.Parent.refrescar('4')
		ENDIF
		this.Parent.activabotones(this) 
	ENDPROC


	PROCEDURE grddetalle4.AfterRowColChange
		LPARAMETERS nColIndex
		*DODEFAULT()
		this.Parent.validitem(this) 
		this.Parent.activabotones(this) 
	ENDPROC


	PROCEDURE grddetalle4.When
		this.Parent.ogridactivo=this
		this.Parent.activar_botones() 
	ENDPROC


	PROCEDURE cmdgrabar1.Click
		IF !INLIST(this.parent.LcTipOpe,'I','A') 
				RETURN 
		ENDIF
		LoGrid = this.Parent.oGridactivo
		this.Parent.validitem(LoGrid) 
		LOCAL LlReturn As Boolean , LsAlias_D AS String 
		LsAlias_D=LoGrid.Recordsource
		*DO MovNedit WITH THISFORM.LcTipOpe,LsAlias_D 
		LsEvalCmpKey = LsAlias_D+'.'+LoGrid.cCampo_Id
		IF EMPTY(&LsEvalCmpKey)
			THIS.Parent.CmdCancelar1.Click     
		ENDIF
		*!*		LnNroItm  = C_RMOV.NroItm
		**=MOVnGrab(THISFORM.LcTipOpe)


		x=CURSORGETPROP("Buffering",LsAlias_D)
		LlReturn = this.Parent.graba_detalle(thisform.LcTipOpe,LsAlias_D,Logrid.ccmpkey,LoGrid.cValKey,LoGrid.ctabla_remota)
		IF LlReturn 
			=TABLEUPDATE(0,.F.,LsAlias_D)  && No debe de fallar ya que es un cursor temporal 
			this.Parent.Habilita_grid(LoGrid,.f.)
			this.parent.LcTipOpe = 'C' 
			SELECT (LsAlias_D)
			*!*		LOCATE FOR NroItm = LnNroItm
			Logrid.SetFocus
		ELSE
			this.Parent.cmdcancelar1.Click()
		ENDIF
	ENDPROC


	PROCEDURE cmdcancelar1.Click
		LOCAL LoGrid as Boolean 

		LoGrid = this.parent.oGridactivo &&  this.Parent.grdDetalle1

		IF !INLIST(this.parent.LcTipOpe,'I','A') 
			RETURN 
		ENDIF
		SELECT (LoGrid.RecordSource) 
		=TABLEREVERT(.f.)
		this.parent.borra_item_blanco_grid(LoGrid,LoGrid.column1.ControlSource) 
		this.Parent.habilita_grid(LoGrid,.f.)
		this.parent.LcTipOpe = 'C' 
		*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*!*	LnNroItm  = C_RMOV.NroItm
		*!*	SELECT C_RMOV
		*!*	LOCATE FOR NroItm = LnNroItm

		LoGrid.SetFocus
		*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*this.Parent.grdDetalle.ActivateCell(LnFilaAct,1)
	ENDPROC


	PROCEDURE cmdhelpteclas.Click
		=MESSAGEBOX('CTRL+F10 o CTRL+W Graba linea del detalle '+CRLF + ;
					'F9 Abandonar cambios en la linea del detalle '+CRLF+ ;
					'F8 o Doble Click dentro de un campo para consultar '+CRLF,0,'Teclas de acceso rapido')


	ENDPROC


	PROCEDURE cmdadicionar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		this.parent.LcTipOpe = 'I'
		LlBufferOk=CURSORSETPROP("Buffering",3,this.Parent.oGridActivo.RecordSource )
		this.Parent.Habilita_grid(this.Parent.oGridActivo,.T.) 
		this.Parent.agrega_item_grid(this.Parent.oGridActivo) 
	ENDPROC


	PROCEDURE cmdmodificar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF

		this.parent.LcTipOpe = 'A'
		this.Parent.Habilita_grid(this.Parent.oGridActivo ,.T.) 
		LlBufferOk=CURSORSETPROP("Buffering",3,this.Parent.oGridActivo.RecordSource )
	ENDPROC


	PROCEDURE cmdeliminar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		IF MESSAGEBOX("¿Desea Eliminar el Registro?",32+4+256,"Eliminar") <> 6
			RETURN
		ENDIF
		this.parent.LcTipOpe  =  'A' &&  Siempre actualiza,  ya no es 'E'
		LlBufferOk=CURSORSETPROP("Buffering",3,this.Parent.oGridActivo.RecordSource )
		IF this.Parent.borra_item_grid(this.Parent.oGridActivo) 
			=TABLEUPDATE(0,.F.,this.Parent.oGridActivo.RecordSource)
		ELSE
			=TABLEREVERT(.f.)
		ENDIF
		this.Parent.oGridActivo.refresh
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntdetalle_detalle_detalle
**************************************************


**************************************************
*-- Class:        precio_venta (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   09/14/15 08:51:01 AM
*
DEFINE CLASS precio_venta AS custom


	_memberdata = [<VFPData><memberdata name="producto" type="method" display="Producto"/><memberdata name="cliente_producto" type="method" display="Cliente_producto"/></VFPData>]
	Name = "precio_venta"


	*-- Precio de venta por producto
	PROCEDURE producto
		PARAMETERS PsCodMat,PsPreUniGrd,PnCodMon


		IF PARAMETERS()<2
			PsPreUniGrd = '1'
			PnCodMon	  = 1
		ENDIF
		IF VARTYPE(PsPreUniGrd)<>'C'
			PsPreUniGrd = '1'
		ENDIF
		IF VARTYPE(PnCodMon)<>'N'
			PnCodMon = 1
		ENDIF

		IF !USED('CATG')
			IF !USED('CATG')
				goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
			ENDIF
		ENDIF

		IF SEEK(TRIM(PsCodMat),'CATG','CATG01') 
			DO CASE
				CASE PsPreUniGrd = "1"
					IF PnCodMon = 2
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVe1
					ELSE
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVn1
					ENDIF
				CASE XsPreUniGrd = "2"
					IF thisform.objcntpage.CboCodMon.Value = 2
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVe2
					ELSE
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVn2
					ENDIF
				CASE XsPreUniGrd = "3"
					IF thisform.objcntpage.CboCodMon.Value = 2
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVe3
					ELSE
						thisform.pgfDetalle.page1.grdDetalle.column7.TxtPreVta.Value = CATG.PreVn3
					ENDIF
			ENDCASE
		ENDIF
	ENDPROC


	*-- Precio de venta por cliente y producto
	PROCEDURE cliente_producto
	ENDPROC


ENDDEFINE
*
*-- EndDefine: precio_venta
**************************************************


**************************************************
*-- Class:        ui (k:\aplvfp\classgen\vcxs\o-n.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   10/10/03 10:07:10 AM
*
DEFINE CLASS ui AS custom


	Name = "ui"

	*-- referencia a objeto formulario
	form = .F.


ENDDEFINE
*
*-- EndDefine: ui
**************************************************
