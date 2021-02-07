**************************************************
*-- Class:        act_maq (d:\aplvfp\bsinfo\vcxs\mttogrid_1am.vcx)
*-- ParentClass:  base_form (d:\aplvfp\classgen\vcxs\fpadmvrs.vcx)
*-- BaseClass:    form
*-- Time Stamp:   10/18/05 07:53:08 AM
*
#INCLUDE "d:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS act_maq AS base_form


	Height = 520
	Width = 780
	DoCreate = .T.
	Caption = "Activos maquinas"
	ctabla_remota = "MtoActMq"
	ccursor_local = "C_ActMq"
	corder_tr = ""
	ctag_tr = "xif36mtoac"
	ccmpkey = "CodCia+CodigoTA+CodigoTM+CodMaq"
	nomobjcnt_ref = "thisform.PgfCtaAux.Page3.Cntdetalle_detalle_detalle1"
	ccmps_id = "CodCia+CodigoTA+CodigoTM"
	ccampo_id = "CodMaq"
	Name = "FrmActivosMaquina"
	Tools.Top = 0
	Tools.Left = 0
	Tools.Name = "Tools"
	rutatabl = .F.


	ADD OBJECT pgfctaaux AS base_pageframe WITH ;
		ErasePage = .T., ;
		PageCount = 4, ;
		Top = 24, ;
		Left = 12, ;
		Width = 766, ;
		Height = 495, ;
		TabIndex = 3, ;
		Name = "pgfCtaAux", ;
		Page1.Caption = "Maquinas", ;
		Page1.Name = "Page1", ;
		Page2.Caption = "Mantenimiento Maquinas", ;
		Page2.Name = "Page2", ;
		Page3.Caption = "Detalle Maquina", ;
		Page3.Name = "Page3", ;
		Page4.Caption = "Datos Adicionales", ;
		Page4.Name = "Page4"


	ADD OBJECT act_maq.pgfctaaux.page1.cmdadicionar1 AS cmdnuevo WITH ;
		Top = 359, ;
		Left = 11, ;
		Enabled = .F., ;
		TabIndex = 2, ;
		Name = "CmdAdicionar1"


	ADD OBJECT act_maq.pgfctaaux.page1.cmdmodificar1 AS cmdmodificar WITH ;
		Top = 359, ;
		Left = 59, ;
		Enabled = .F., ;
		TabIndex = 3, ;
		Name = "Cmdmodificar1"


	ADD OBJECT act_maq.pgfctaaux.page1.cmdeliminar1 AS cmdeliminar WITH ;
		Top = 359, ;
		Left = 107, ;
		Enabled = .F., ;
		TabIndex = 4, ;
		Name = "Cmdeliminar1"


	ADD OBJECT act_maq.pgfctaaux.page1.cmdimprimir1 AS cmdimprimir WITH ;
		Top = 359, ;
		Left = 531, ;
		Enabled = .F., ;
		TabIndex = 5, ;
		ToolTipText = "Imprimir Relación de Cultivos x Predio", ;
		Visible = .T., ;
		PicturePosition = 7, ;
		Name = "Cmdimprimir1"


	ADD OBJECT act_maq.pgfctaaux.page1.cmdsalir1 AS cmdsalir WITH ;
		Top = 359, ;
		Left = 589, ;
		TabIndex = 6, ;
		Name = "Cmdsalir1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux AS base_grid WITH ;
		ColumnCount = 9, ;
		HeaderHeight = 30, ;
		Height = 332, ;
		Left = 8, ;
		Panel = 1, ;
		TabIndex = 1, ;
		Top = 15, ;
		Width = 737, ;
		Name = "grdCtaAux", ;
		Column1.ColumnOrder = 1, ;
		Column1.Width = 74, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.ColumnOrder = 3, ;
		Column2.Width = 147, ;
		Column2.ReadOnly = .T., ;
		Column2.Name = "Column2", ;
		Column3.ColumnOrder = 2, ;
		Column3.Width = 219, ;
		Column3.ReadOnly = .T., ;
		Column3.Name = "Column3", ;
		Column4.Width = 140, ;
		Column4.ReadOnly = .T., ;
		Column4.Name = "Column4", ;
		Column5.ReadOnly = .T., ;
		Column5.Name = "Column5", ;
		Column6.ReadOnly = .T., ;
		Column6.Name = "Column6", ;
		Column7.Name = "Column7", ;
		Column8.Name = "Column8", ;
		Column9.Name = "Column9"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column1.header1 AS header WITH ;
		Caption = "Código", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column2.header1 AS header WITH ;
		Caption = "Ubicación", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column3.header1 AS header WITH ;
		Caption = "Descripcion Máquina", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column3.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column4.header1 AS header WITH ;
		Caption = "Responsable", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column4.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column5.header1 AS header WITH ;
		Caption = "Marca", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column5.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column6.header1 AS header WITH ;
		Caption = "Modelo", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column6.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column7.header1 AS header WITH ;
		Caption = "Numero de Serie", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column7.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column8.header1 AS header WITH ;
		Caption = "Contometro", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column8.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column9.header1 AS header WITH ;
		Caption = "Dias de avance", ;
		WordWrap = .T., ;
		Name = "Header1"


	ADD OBJECT act_maq.pgfctaaux.page1.grdctaaux.column9.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT act_maq.pgfctaaux.page2.edtcomentar AS base_editbox WITH ;
		Enabled = .F., ;
		Height = 48, ;
		Left = 187, ;
		MaxLength = 254, ;
		TabIndex = 10, ;
		Top = 237, ;
		Width = 544, ;
		ZOrderSet = 0, ;
		Name = "EdtComentar"


	ADD OBJECT act_maq.pgfctaaux.page2.cmdaceptar2 AS cmdaceptar WITH ;
		Top = 359, ;
		Left = 628, ;
		Enabled = .F., ;
		TabIndex = 17, ;
		ZOrderSet = 1, ;
		Name = "Cmdaceptar2"


	ADD OBJECT act_maq.pgfctaaux.page2.cmdcancelar2 AS cmdcancelar WITH ;
		Top = 359, ;
		Left = 694, ;
		Enabled = .F., ;
		TabIndex = 18, ;
		ZOrderSet = 2, ;
		Name = "Cmdcancelar2"


	ADD OBJECT act_maq.pgfctaaux.page2.lblnombre AS base_label WITH ;
		Caption = "Descripción", ;
		Left = 112, ;
		Top = 41, ;
		TabIndex = 21, ;
		ZOrderSet = 3, ;
		Name = "LblNombre"


	ADD OBJECT act_maq.pgfctaaux.page2.txtdesmaq AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 187, ;
		MaxLength = 40, ;
		TabIndex = 2, ;
		Top = 38, ;
		Width = 377, ;
		ZOrderSet = 4, ;
		Name = "TxtDesMaq"


	ADD OBJECT act_maq.pgfctaaux.page2.lblprom_avan1 AS base_label WITH ;
		Caption = "Promedio avance horas", ;
		Left = 48, ;
		Top = 381, ;
		Visible = .F., ;
		TabIndex = 30, ;
		ZOrderSet = 5, ;
		Name = "LblProm_avan1"


	ADD OBJECT act_maq.pgfctaaux.page2.lblcodmaq AS base_label WITH ;
		Caption = "Código", ;
		Left = 138, ;
		Top = 16, ;
		TabIndex = 23, ;
		ZOrderSet = 6, ;
		Name = "LblCodMaq"


	ADD OBJECT act_maq.pgfctaaux.page2.lblconto_actu AS base_label WITH ;
		FontSize = 9, ;
		Caption = "Contometro actual", ;
		Height = 17, ;
		Left = 283, ;
		Top = 414, ;
		Visible = .F., ;
		Width = 103, ;
		TabIndex = 34, ;
		ZOrderSet = 7, ;
		Name = "LblConto_actu"


	ADD OBJECT act_maq.pgfctaaux.page2.cmdhelpcodmat AS base_cmdhelp WITH ;
		Top = 12, ;
		Left = 293, ;
		Height = 26, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 19, ;
		Visible = .F., ;
		ZOrderSet = 8, ;
		cvaloresfiltro = "", ;
		ccamposfiltro = "", ;
		cnombreentidad = "mtoactmq", ;
		ccamporetorno = "CodMaq", ;
		caliascursor = "c_Maquinas", ;
		ccampovisualizacion = "Desmaq", ;
		Name = "CmdHelpCodMat"


	ADD OBJECT act_maq.pgfctaaux.page2.lblsubsistema AS base_label WITH ;
		Caption = "Subsistema", ;
		Left = 111, ;
		Top = 325, ;
		Visible = .F., ;
		TabIndex = 31, ;
		ZOrderSet = 9, ;
		Name = "LblSubsistema"


	ADD OBJECT act_maq.pgfctaaux.page2.cbosubsistema AS base_cbohelp WITH ;
		FontBold = .F., ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 188, ;
		TabIndex = 9, ;
		Top = 319, ;
		Visible = .F., ;
		Width = 179, ;
		ZOrderSet = 10, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "MtoSubsi", ;
		ccamporetorno = "CodSub", ;
		ccampovisualizacion = "DesSub", ;
		ccamposfiltro = "CodSis", ;
		caliascursor = "c_Subsis", ;
		Name = "CboSubSistema"


	ADD OBJECT act_maq.pgfctaaux.page2.lblubicacion AS base_label WITH ;
		Caption = "Ubicación", ;
		Left = 123, ;
		Top = 149, ;
		TabIndex = 20, ;
		ZOrderSet = 11, ;
		Name = "LblUbicacion"


	ADD OBJECT act_maq.pgfctaaux.page2.txtubic_actua AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 379, ;
		MaxLength = 30, ;
		TabIndex = 6, ;
		Top = 146, ;
		Width = 64, ;
		ZOrderSet = 12, ;
		Name = "TxtUbic_Actua"


	ADD OBJECT act_maq.pgfctaaux.page2.lblrespon AS base_label WITH ;
		WordWrap = .T., ;
		Caption = "Responsable / Especialidad", ;
		Height = 32, ;
		Left = 103, ;
		Top = 202, ;
		Width = 83, ;
		TabIndex = 22, ;
		ZOrderSet = 13, ;
		Name = "LblRespon"


	ADD OBJECT act_maq.pgfctaaux.page2.txtrespon AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 379, ;
		MaxLength = 30, ;
		TabIndex = 7, ;
		Top = 204, ;
		Width = 65, ;
		ZOrderSet = 14, ;
		Name = "TxtRespon"


	ADD OBJECT act_maq.pgfctaaux.page2.lblprom_avan2 AS base_label WITH ;
		Caption = "Promedio avance minutos", ;
		Left = 38, ;
		Top = 407, ;
		Visible = .F., ;
		TabIndex = 32, ;
		ZOrderSet = 15, ;
		Name = "LblProm_avan2"


	ADD OBJECT act_maq.pgfctaaux.page2.lblprom_avan3 AS base_label WITH ;
		Caption = "Promedio avance segundos", ;
		Left = 25, ;
		Top = 435, ;
		Visible = .F., ;
		TabIndex = 25, ;
		ZOrderSet = 16, ;
		Name = "LblProm_avan3"


	ADD OBJECT act_maq.pgfctaaux.page2.cntunid_avanc AS base_textbox_cmdhelp WITH ;
		Top = 350, ;
		Left = 82, ;
		Width = 396, ;
		Height = 25, ;
		Enabled = .F., ;
		Visible = .F., ;
		TabIndex = 11, ;
		ZOrderSet = 17, ;
		cetiqueta = ("Unidad de avance"), ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ctituloayuda = "Unidades de avance", ;
		ccamposfiltro = "Tabla", ;
		cvaloresfiltro = ("UA"), ;
		Name = "CntUnid_avanc", ;
		txtCodigo.Height = 24, ;
		txtCodigo.Left = 106, ;
		txtCodigo.Top = 0, ;
		txtCodigo.Width = 47, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdHelp.Top = 1, ;
		cmdHelp.Left = 164, ;
		cmdHelp.Name = "cmdHelp", ;
		txtDescripcion.Height = 24, ;
		txtDescripcion.Left = 195, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 193, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.Caption = "Unidad de avance", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT act_maq.pgfctaaux.page2.spnconto_actu AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999", ;
		Left = 395, ;
		TabIndex = 16, ;
		Top = 409, ;
		Visible = .F., ;
		Width = 93, ;
		ZOrderSet = 18, ;
		Name = "SpnConto_actu"


	ADD OBJECT act_maq.pgfctaaux.page2.spndias_avanc AS base_spinner_numero WITH ;
		Enabled = .F., ;
		InputMask = "999", ;
		Left = 395, ;
		TabIndex = 15, ;
		Top = 380, ;
		Visible = .F., ;
		Width = 62, ;
		ZOrderSet = 19, ;
		Name = "SpnDias_avanc"


	ADD OBJECT act_maq.pgfctaaux.page2.lbldias_avanc AS base_label WITH ;
		Caption = "Dias de avance", ;
		Height = 17, ;
		Left = 298, ;
		Top = 387, ;
		Visible = .F., ;
		Width = 87, ;
		TabIndex = 24, ;
		ZOrderSet = 20, ;
		Name = "LblDias_avanc"


	ADD OBJECT act_maq.pgfctaaux.page2.lblsistema AS base_label WITH ;
		Caption = "Sistema", ;
		Left = 133, ;
		Top = 296, ;
		Visible = .F., ;
		TabIndex = 29, ;
		ZOrderSet = 21, ;
		Name = "LblSistema"


	ADD OBJECT act_maq.pgfctaaux.page2.cbosistema AS base_cbohelp WITH ;
		FontBold = .F., ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 188, ;
		TabIndex = 8, ;
		Top = 291, ;
		Visible = .F., ;
		Width = 179, ;
		ZOrderSet = 22, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "Mtosiste", ;
		ccamporetorno = "COdSis", ;
		ccampovisualizacion = "DesSis", ;
		ccamposfiltro = "", ;
		cvaloresfiltro = "", ;
		caliascursor = "c_Sistema", ;
		Name = "CboSistema"


	ADD OBJECT act_maq.pgfctaaux.page2.spnprm_ava_horas AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999", ;
		Left = 189, ;
		TabIndex = 12, ;
		Top = 378, ;
		Visible = .F., ;
		Width = 64, ;
		ZOrderSet = 23, ;
		Name = "SpnPrm_ava_Horas"


	ADD OBJECT act_maq.pgfctaaux.page2.spnprm_ava_minutos AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999", ;
		Left = 189, ;
		TabIndex = 13, ;
		Top = 403, ;
		Visible = .F., ;
		Width = 64, ;
		ZOrderSet = 24, ;
		Name = "SpnPrm_ava_minutos"


	ADD OBJECT act_maq.pgfctaaux.page2.spnprm_ava_segundos AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999", ;
		Left = 189, ;
		TabIndex = 14, ;
		Top = 429, ;
		Visible = .F., ;
		Width = 64, ;
		ZOrderSet = 25, ;
		Name = "SpnPrm_Ava_Segundos"


	ADD OBJECT act_maq.pgfctaaux.page2.lblcomentarios AS base_label WITH ;
		FontSize = 9, ;
		Caption = "Comentarios", ;
		Height = 17, ;
		Left = 107, ;
		Top = 240, ;
		Width = 74, ;
		TabIndex = 33, ;
		ZOrderSet = 26, ;
		Name = "LblComentarios"


	ADD OBJECT act_maq.pgfctaaux.page2.txtcodmaq AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "L", ;
		Height = 23, ;
		InputMask = "XXXXXXXXXX", ;
		Left = 188, ;
		TabIndex = 1, ;
		Top = 14, ;
		Width = 90, ;
		ZOrderSet = 27, ;
		Name = "TxtCodMaq"


	ADD OBJECT act_maq.pgfctaaux.page2.txtmarca AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 187, ;
		MaxLength = 20, ;
		TabIndex = 3, ;
		Top = 65, ;
		Width = 172, ;
		ZOrderSet = 28, ;
		Name = "TxtMarca"


	ADD OBJECT act_maq.pgfctaaux.page2.lblmarca AS base_label WITH ;
		Caption = "Marca", ;
		Left = 144, ;
		Top = 70, ;
		TabIndex = 26, ;
		ZOrderSet = 29, ;
		Name = "LblMarca"


	ADD OBJECT act_maq.pgfctaaux.page2.txtmodelo AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 188, ;
		MaxLength = 20, ;
		TabIndex = 4, ;
		Top = 93, ;
		Width = 172, ;
		ZOrderSet = 30, ;
		Name = "TxtModelo"


	ADD OBJECT act_maq.pgfctaaux.page2.lblmodelo AS base_label WITH ;
		Caption = "Modelo", ;
		Left = 137, ;
		Top = 98, ;
		TabIndex = 28, ;
		ZOrderSet = 31, ;
		Name = "LblModelo"


	ADD OBJECT act_maq.pgfctaaux.page2.txtnoserie AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 188, ;
		MaxLength = 20, ;
		TabIndex = 5, ;
		Top = 119, ;
		Width = 172, ;
		ZOrderSet = 32, ;
		Name = "TxtNoSerie"


	ADD OBJECT act_maq.pgfctaaux.page2.lblnroserie AS base_label WITH ;
		Caption = "Nro. Serie", ;
		Left = 123, ;
		Top = 124, ;
		TabIndex = 27, ;
		ZOrderSet = 33, ;
		Name = "LblNroSerie"


	ADD OBJECT act_maq.pgfctaaux.page2.cboubicacion AS base_cbohelp WITH ;
		FontBold = .F., ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 187, ;
		TabIndex = 8, ;
		Top = 145, ;
		Width = 179, ;
		ZOrderSet = 22, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ([UB]), ;
		caliascursor = "c_Ubicacion", ;
		Name = "CboUbicacion"


	ADD OBJECT act_maq.pgfctaaux.page2.cboarea AS base_cbohelp WITH ;
		FontBold = .F., ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 187, ;
		TabIndex = 8, ;
		Top = 172, ;
		Width = 179, ;
		ZOrderSet = 22, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "Almtgsis", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "Tabla", ;
		cvaloresfiltro = ([AR]), ;
		caliascursor = "c_Area", ;
		Name = "CboArea"


	ADD OBJECT act_maq.pgfctaaux.page2.lblarea AS base_label WITH ;
		Caption = "Area", ;
		Left = 152, ;
		Top = 178, ;
		TabIndex = 20, ;
		ZOrderSet = 11, ;
		Name = "LblArea"


	ADD OBJECT act_maq.pgfctaaux.page2.cboespecialidad AS base_cbohelp WITH ;
		FontBold = .F., ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 188, ;
		TabIndex = 8, ;
		Top = 205, ;
		Width = 179, ;
		ZOrderSet = 22, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "mtoespec", ;
		ccamporetorno = "Cod_Espec", ;
		ccampovisualizacion = "desc_espe", ;
		ccamposfiltro = "", ;
		cvaloresfiltro = "", ;
		caliascursor = "c_Especial", ;
		Name = "CboEspecialidad"


	ADD OBJECT act_maq.pgfctaaux.page2.base_checkbox1 AS base_checkbox WITH ;
		Top = 291, ;
		Left = 7, ;
		Height = 24, ;
		Width = 96, ;
		Alignment = 0, ;
		Caption = "Ver detalle", ;
		Enabled = .F., ;
		Name = "Base_checkbox1"


	ADD OBJECT act_maq.pgfctaaux.page3.cntdetalle_detalle_detalle1 AS cntdetalle_detalle_detalle WITH ;
		Top = 32, ;
		Left = 3, ;
		Width = 647, ;
		Height = 378, ;
		ctabla_det1 = "MtoSecMq", ;
		ctabla_det2 = "MtoEqSec", ;
		ctabla_det3 = "MtoPxequ", ;
		ccmpkey1 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC", ;
		ccmpkey2 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC+CODEQU", ;
		ccmpkey3 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC+CODEQU+CODPAR", ;
		ccmps_id1 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ", ;
		ccmps_id2 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC", ;
		ccmps_id3 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC+CODEQU", ;
		ccampo_id1 = "CODSEC", ;
		ccampo_id2 = "CODEQU", ;
		ccampo_id3 = "CODPAR", ;
		ctabla_det4 = "MtoSpect", ;
		ccmpkey4 = "CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC+CODEQU+CODPAR+COD_CARAC", ;
		ccmps_id4 = "", ;
		ccampo_id4 = "COD_CARAC", ;
		lsetfocus = .F., ;
		Name = "Cntdetalle_detalle_detalle1", ;
		shpBorde.Top = 3, ;
		shpBorde.Left = 5, ;
		shpBorde.Height = 360, ;
		shpBorde.Width = 630, ;
		shpBorde.Name = "shpBorde", ;
		GrdDetalle1.Column1.Header1.Name = "Header1", ;
		GrdDetalle1.Column1.TxtCodSec.Name = "TxtCodSec", ;
		GrdDetalle1.Column1.Text1.Name = "Text1", ;
		GrdDetalle1.Column1.Name = "Column1", ;
		GrdDetalle1.Column2.Header1.Name = "Header1", ;
		GrdDetalle1.Column2.TxtDesSec.Name = "TxtDesSec", ;
		GrdDetalle1.Column2.Name = "Column2", ;
		GrdDetalle1.Column3.Header1.Name = "Header1", ;
		GrdDetalle1.Column3.TxtCant_equ.Name = "TxtCant_equ", ;
		GrdDetalle1.Column3.Name = "Column3", ;
		GrdDetalle1.Left = 18, ;
		GrdDetalle1.Top = 24, ;
		GrdDetalle1.Name = "GrdDetalle1", ;
		GrdDetalle2.Column1.Header1.Name = "Header1", ;
		GrdDetalle2.Column1.TxtCodSec.Name = "TxtCodSec", ;
		GrdDetalle2.Column1.Text1.Name = "Text1", ;
		GrdDetalle2.Column1.Name = "Column1", ;
		GrdDetalle2.Column2.Header1.Name = "Header1", ;
		GrdDetalle2.Column2.TxtDesSec.Name = "TxtDesSec", ;
		GrdDetalle2.Column2.Name = "Column2", ;
		GrdDetalle2.Column3.Header1.Name = "Header1", ;
		GrdDetalle2.Column3.TxtCant_equ.Name = "TxtCant_equ", ;
		GrdDetalle2.Column3.Name = "Column3", ;
		GrdDetalle2.Name = "GrdDetalle2", ;
		GrdDetalle3.Column1.Header1.Name = "Header1", ;
		GrdDetalle3.Column1.TxtCodSec.Name = "TxtCodSec", ;
		GrdDetalle3.Column1.Text1.Name = "Text1", ;
		GrdDetalle3.Column1.Name = "Column1", ;
		GrdDetalle3.Column2.Header1.Name = "Header1", ;
		GrdDetalle3.Column2.TxtDesSec.Name = "TxtDesSec", ;
		GrdDetalle3.Column2.Name = "Column2", ;
		GrdDetalle3.Column3.Header1.Name = "Header1", ;
		GrdDetalle3.Column3.TxtCant_equ.Name = "TxtCant_equ", ;
		GrdDetalle3.Column3.Name = "Column3", ;
		GrdDetalle3.Name = "GrdDetalle3", ;
		GrdDetalle4.Column1.Header1.Name = "Header1", ;
		GrdDetalle4.Column1.TxtCodSec.Name = "TxtCodSec", ;
		GrdDetalle4.Column1.Text1.Name = "Text1", ;
		GrdDetalle4.Column1.Name = "Column1", ;
		GrdDetalle4.Column2.Header1.Name = "Header1", ;
		GrdDetalle4.Column2.TxtDesSec.Name = "TxtDesSec", ;
		GrdDetalle4.Column2.Name = "Column2", ;
		GrdDetalle4.Column3.Header1.Name = "Header1", ;
		GrdDetalle4.Column3.TxtCant_equ.Name = "TxtCant_equ", ;
		GrdDetalle4.Column3.Name = "Column3", ;
		GrdDetalle4.Name = "GrdDetalle4", ;
		LblDetalle1.Name = "LblDetalle1", ;
		Cmdgrabar1.Name = "Cmdgrabar1", ;
		Cmdcancelar1.Name = "Cmdcancelar1", ;
		LblDetalle2.Name = "LblDetalle2", ;
		LblDetalle3.Name = "LblDetalle3", ;
		LblDetalle4.Name = "LblDetalle4", ;
		LblGrid.Name = "LblGrid", ;
		CmdHelpTeclas.Name = "CmdHelpTeclas", ;
		CmdAdicionar1.Name = "CmdAdicionar1", ;
		Cmdmodificar1.Name = "Cmdmodificar1", ;
		Cmdeliminar1.Name = "Cmdeliminar1", ;
		ctmSeccion1.caliascursor = ([c_Seccion]), ;
		ctmSeccion1.cnombreentidad = ([MtoSecMq]), ;
		ctmSeccion1.corderby = ([CodSec]), ;
		ctmSeccion1.ldinamicgrid = .T., ;
		ctmSeccion1.Name = "ctmSeccion1", ;
		ctmSeccion2.caliascursor = ([c_EquSec]), ;
		ctmSeccion2.cnombreentidad = ([MtoEqSec]), ;
		ctmSeccion2.corderby = ([CodEqu]), ;
		ctmSeccion2.Name = "ctmSeccion2", ;
		CtmSeccion3.caliascursor = ([c_ParxEqu]), ;
		CtmSeccion3.cnombreentidad = ([MtoPxEqu]), ;
		CtmSeccion3.corderby = ([CodPar]), ;
		CtmSeccion3.Name = "CtmSeccion3", ;
		dataadmin.Name = "dataadmin", ;
		CtmSeccion4.cnombreentidad = ([MtoSpect]), ;
		CtmSeccion4.corderby = ([Cod_Carac]), ;
		CtmSeccion4.caliascursor = ([c_Caract]), ;
		CtmSeccion4.Name = "CtmSeccion4"


	ADD OBJECT act_maq.pgfctaaux.page3.lblfecha AS base_label WITH ;
		Caption = "Código", ;
		Left = 15, ;
		Top = 10, ;
		TabIndex = 23, ;
		ZOrderSet = 6, ;
		Name = "LblFecha"


	ADD OBJECT act_maq.pgfctaaux.page3.lblnombre AS base_label WITH ;
		Caption = "Descripción", ;
		Left = 167, ;
		Top = 10, ;
		TabIndex = 21, ;
		ZOrderSet = 3, ;
		Name = "LblNombre"


	ADD OBJECT act_maq.pgfctaaux.page3.txtcodmaq AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "L", ;
		Height = 23, ;
		InputMask = "XXXXXXXXXX", ;
		Left = 63, ;
		TabIndex = 1, ;
		Top = 5, ;
		Width = 90, ;
		ZOrderSet = 27, ;
		Name = "TxtCodMaq"


	ADD OBJECT act_maq.pgfctaaux.page3.txtdesmaq AS base_textbox WITH ;
		Enabled = .F., ;
		Format = "K", ;
		Height = 24, ;
		Left = 240, ;
		MaxLength = 30, ;
		TabIndex = 2, ;
		Top = 4, ;
		Width = 377, ;
		ZOrderSet = 4, ;
		Name = "TxtDesMaq"


	ADD OBJECT base_label2 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Tipo Maquina", ;
		Left = 414, ;
		Top = 5, ;
		TabIndex = 4, ;
		Name = "Base_label2"


	ADD OBJECT cbotipmaqui AS base_cbohelp WITH ;
		FontBold = .T., ;
		ColumnCount = 2, ;
		Height = 20, ;
		Left = 501, ;
		TabIndex = 1, ;
		Top = 1, ;
		Width = 266, ;
		ZOrderSet = 32, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "MtoTpMaq", ;
		ccamporetorno = "CodigoTM", ;
		ccampovisualizacion = "NombreTm", ;
		ccamposfiltro = "", ;
		caliascursor = "c_tpomaq", ;
		Name = "CboTipMaqui"


	ADD OBJECT base_label3 AS base_label WITH ;
		FontBold = .T., ;
		Caption = "Tipo Activo", ;
		Left = 24, ;
		Top = 6, ;
		TabIndex = 5, ;
		Name = "Base_label3"


	ADD OBJECT cbotipact AS base_cbohelp WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		ColumnCount = 2, ;
		Height = 20, ;
		Left = 95, ;
		TabIndex = 2, ;
		Top = 1, ;
		Width = 266, ;
		ZOrderSet = 32, ;
		ForeColor = RGB(0,0,160), ;
		BackColor = RGB(230,255,255), ;
		ItemForeColor = RGB(0,0,160), ;
		DisabledForeColor = RGB(0,0,160), ;
		cnombreentidad = "MtoTpAct", ;
		ccamporetorno = "CodigoTA", ;
		ccampovisualizacion = "NombreTA", ;
		ccamposfiltro = "", ;
		caliascursor = "c_tpoact", ;
		Name = "CboTipAct"


	PROCEDURE Init
		LPARAMETERS toconexion
		dodefault()

		PUBLIC LoDa as dataadmin OF "k:\aplvfp\classgen\vcxs\Fpdosvr.vcx" 
		LoDa=CREATEOBJECT('FpDosvr.DataAdmin')
		LoDa.abrirtabla('ABRIR','MTOSECMQ','MTOSECMQ','XPKMTOSECM','')
		LoDa.abrirtabla('ABRIR','MTOEQSEC','MTOEQSEC','XPKMTOEQSE','')
		LoDa.abrirtabla('ABRIR','MTOPXEQU','MTOPXEQU','XPKMTOPXEQ','')
		LoDa.abrirtabla('ABRIR','MTOSPECT','MTOSPECT','XPKMTOSPEC','')
		*!*	LoDa.abrirtabla('ABRIR','ALMDTRAN','DTRA','DTRA01','')
		*!*	LoDa.abrirtabla('ABRIR','VTACOMPE','COMPE','COMP01','')
		*!*	LoDa.abrirtabla('ABRIR','EMPRESAS','EMPRESA','EMPR01','')
		*!*	LoDa.abrirtabla('ABRIR','ALMCFTRA','CFTR','CFTR01','')
		*!*	LoDa.abrirtabla('ABRIR','ALMTDIVF','DIVF','DIVF01','')
		*!*	RELEASE LoDa
		thisform.ccursor_local = 'C_ACTMQ'
		thisform.cTabla_Remota = 'MTOACTMQ'
		this.cboTipMaqui.Value = '' 
	ENDPROC


	PROCEDURE validitem
		*!*	LsCodMat=PADR(this.pgfCtaAux.page2.TxtCodMat.Value,LEN(CATG.CodMat))
		*!*	=SEEK(LsCodMat,'CATG','CATG01') 
		*!*	IF !FOUND('CATG')
		*!*		RETURN ITEM_NO_EXISTE
		*!*	ELSE
		*!*		RETURN S_OK
		*!*	ENDIF

		thisform.cValKey = this.cValor_ID+EVALUATE(this.ccursor_local+'.'+thisform.ccampo_id )
		thisform.objcntref.cCmpkgen = thisform.ccmpkey
		thisform.objcntref.cValkgen = thisform.cValkey
	ENDPROC


	PROCEDURE pgfctaaux.Page1.Activate
		thisform.LockScreen = .t.
		this.grdCtaAux.SetFocus()
		thisform.LockScreen = .F.  
	ENDPROC


	PROCEDURE pgfctaaux.Page3.Activate

		** Este codigo normalmente va en el metodo AfterRowColChange del Grid, pero por
		** cuestiones de rendimiento lo colocamos aqui.
		thisform.LockScreen = .T. 
		WITH THIS
			.TxtCodMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".CodMaq")
			.TxtDesMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".DesMaq")
		ENDWITH

		THISFORM.Objcntref.cCursor_Local =  thisform.ccursor_local 
		IF !EOF(THISFORM.cCursor_local)
			THISFORM.objcntref.habilita() 
		ELSE
			THISFORM.objcntref.Deshabilita() 
		ENDIF

		thisform.LockScreen = .F. 
	ENDPROC


	PROCEDURE cmdadicionar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		THIS.PARENT.ENABLED	= .F.
		THIS.PARENT.PARENT.ACTIVEPAGE	= 2


		THISFORM.xReturn	= "I"

		WITH THIS.PARENT.PARENT.PAGES(2)

			** Inicializamos Variables
			FOR LnControl = 1 TO .ControlCount

				DO CASE 
					CASE .Controls(LnControl).Class=='Base_label'
					CASE .Controls(LnControl).Class=='Base_textbox_fecha'
						.Controls(LnControl).Value = {}
					CASE .Controls(LnControl).Class=='Base_textbox_numero' 
						.Controls(LnControl).Value = 0.00
					CASE .Controls(LnControl).Class=='Base_textbox'
						.Controls(LnControl).Value = SPACE(.Controls(LnControl).MaxLength)
					CASE .Controls(LnControl).Class=='Base_spinner_numero' 
						.Controls(LnControl).Value = 0.00
					CASE .Controls(LnControl).Class=='Base_editbox'
						.Controls(LnControl).Value = SPACE(.Controls(LnControl).MaxLength)

				ENDCASE
				.Controls(LnControl).Enabled = .T.
				 
			ENDFOR 
			SELECT (thisform.Ccursor_local) 

			.TxtCOdMaq.when()
			.TxtCOdMaq.enabled = .f.
			.TxtDesMaq.Setfocus()
			** Habilitamos las variables


			.cmdAceptar2.ENABLED			= .T.
			.cmdCancelar2.ENABLED			= .T.

		ENDWITH

		*** Aqui colocamos codigo si queremos Jalar valores por defecto de otro sitio

		WITH THISFORM
			.lNuevo   						= .T.
			.lGrabado 						= .F. 
			LnControl = 1
			IF .lNuevo
				IF lnControl > 0
					WITH THIS.PARENT.PARENT.PAGES(2)
					ENDWITH
				ENDIF
			ENDIF
		ENDWITH


		thisform.CboTipAct.Enabled		= .F.
		thisform.CboTipMaqui.Enabled	= .F.

		  
	ENDPROC


	PROCEDURE cmdmodificar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		THIS.PARENT.ENABLED	= .F.
		THIS.PARENT.PARENT.ACTIVEPAGE	= 2

		WITH THIS.PARENT.PARENT.PAGES(2)

			** Habilitamos los controles
			FOR LnControl = 1 TO .ControlCount
				.Controls(LnControl).Enabled = .T.
			ENDFOR 
			.TxtCodMaq.Enabled = .F.

			.cmdAceptar2.ENABLED			= .T.
			.cmdCancelar2.ENABLED			= .T.
		ENDWITH
		THISFORM.xReturn	= "A"
		thisform.CbotipMaqui.Enabled = .F.
		thisform.CboTipAct.Enabled = .F.
		**
		THISFORM.lNuevo = .F.
		THISFORM.lGrabado = .T.
	ENDPROC


	PROCEDURE cmdeliminar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		IF MESSAGEBOX("¿Desea Eliminar el Registro?",32+4+256,"Eliminar") <> 6
			RETURN
		ENDIF
		WITH THIS.PARENT
			m.CodCIa		= GsCOdCia
			m.CodigoTA		= thisform.CboTipAct.Value
			m.CodigoTA		= thisform.cboTipMaqui.Value 
			m.CodMaq		= EVALUATE(thisform.cCursor_local+'.CodMaq')
			m.Usuario		= goEntorno.USER.Login
			m.Estacion		= goEntorno.USER.Estacion
		ENDWITH
		LsCmpKey = thisform.ccmpkey 
		LsValKey = thisform.cValkey 
		LcCmdSql="DELETE FROM "+THISFORM.Ctabla_remota+" WHERE "+Lscmpkey+"= '"+LsValkey+"'"

		&LcCmdSql
		LnControl = 1
		IF lnControl > 0
			SELECT (thisform.cCursor_local)
			DELETE
			LOCATE
			THIS.PARENT.grdCtaAux.REFRESH()
		**	THISFORM.GenerarLog("0397",THIS.CodigoBoton)
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.cCursor_local)
			THIS.PARENT.CmdModificar1.ENABLED = LlHayRegistros
			THIS.PARENT.CmdEliminar1.ENABLED  = LlHayRegistros
			THIS.Parent.CmdIMprimir1.ENABLED = LlHayRegistros
		ENDIF
	ENDPROC


	PROCEDURE cmdimprimir1.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		*
		THISFORM.Tools.CloseTable('TEMPO')
		LOCAL lcRptTxt,lcRptGraph,lcRptDesc 
		LOCAL LcArcTmp,LcAlias,LnNumReg,LnNumCmp,LlPrimera
		*
		LcArcTmp=GoEntorno.TmpPath+Sys(3)
		*
		LcAlias  = ALias()
		*
		LnControl = 1
		*** 

		SELECT (Thisform.ccursor_local) 
		LOCATE

		IF EOF()
			wait window "No existen registros a Listar" NOWAIT
			IF NOT EMPTY(LcAlias)
				SELE (LcAlias)
			ENDIF
			RETURN
		ENDIF
		LoTipRep = ''
		*
		lcRptTxt	= "mto_Activo_maquinas"
		lcRptGraph	= "mto_Activo_maquinas"
		lcRptDesc	= thisform.cboTipMaqui.DisplayValue 
		*

		IF .f.
		   MODI REPORT  mto_Activo_maquinas
		ENDIF
		*
		DO FORM Gen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , THISFORM.DATASESSIONID
		*!*	STORE [] TO xFOR,xWHILE
		*!*	Largo  = 66       && Largo de pagina
		*!*	IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
		*!*	sNomRep = "mto_Activo_maquinas"
		*!*	DO Gen_F0print WITH "REPORTS"

		*
		IF NOT EMPTY(LcAlias)
			SELECT (LcAlias)
		ENDIF
		*
		RELEASE  LcArcTmp, LcAlias,LnNumReg
		*
		RETURN
	ENDPROC


	PROCEDURE cmdsalir1.Click
		thisform.TOOLS.closetable(THISFORM.Ccursor_local)

		thisform.TOOLS.closetable(THISFORM.CTAbla_remota)
		thisform.TOOLS.closetable([MTOTPACT])
		thisform.TOOLS.closetable([MTOTPMAQ])
		thisform.TOOLS.closetable([MTOSISTE])
		thisform.TOOLS.closetable([MTOSUBSI])
		thisform.TOOLS.closetable([ALMTGSIS])

		thisform.TOOLS.closetable([MTOSPECT])
		thisform.TOOLS.closetable([MTOPXEQU])
		thisform.TOOLS.closetable([MTOEQSEC])
		thisform.TOOLS.closetable([MTOSECMQ])
		thisform.TOOLS.closetable([MTOPTCMQ])
		thisform.TOOLS.closetable([MTOACTIV])
		thisform.TOOLS.closetable([MTOTAREA])
		thisform.TOOLS.closetable([CBDMTABL])
		thisform.TOOLS.Closetable([C_PARXEQU])
		thisform.TOOLS.Closetable([C_EQUSEC])
		THISFORM.RELEASE
	ENDPROC


	PROCEDURE grdctaaux.AfterRowColChange
		LPARAMETERS ncolindex
		**DODEFAULT()
		WITH THIS.PARENT.PARENT.PAGES(2)
			.TxtCodMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".CodMaq")
			.TxtDesMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".DesMaq")
			.TxtUbic_actua.Value		=	EVALUATE(thisform.cCursor_local+".Ubic_actua")
			.CboUbicacion.Value			= 	EVALUATE(thisform.cCursor_local+".Cod_Ubic")
			.CboArea.Value				= 	EVALUATE(thisform.cCursor_local+".Cod_Area")
			.CboEspecialidad.Value		= 	EVALUATE(thisform.cCursor_local+".Cod_espec")
			.TxtRespon.Value			=	EVALUATE(thisform.cCursor_local+".Respon")
			.SpnConto_actu.Value		=	EVALUATE(thisform.cCursor_local+".Conto_Actu")
			.SpnDias_Avanc.Value		=	EVALUATE(thisform.cCursor_local+".Dias_Avanc")
			.CntUnid_avanc.Value 		=	EVALUATE(thisform.cCursor_local+".Unid_Avanc")  
			.SpnPrm_ava_Horas.Value 	=	EVALUATE(thisform.cCursor_local+".Prom_Avan1")   
			.SpnPrm_ava_Minutos.Value	=	EVALUATE(thisform.cCursor_local+".Prom_Avan2")   
			.SpnPrm_ava_segundos.Value	=	EVALUATE(thisform.cCursor_local+".Prom_Avan3")   
			.EdtComentar.Value			=   EVALUATE(thisform.cCursor_local+".Comentar")   
			.Cbosistema.Value			=	EVALUATE(thisform.cCursor_local+".CodSis")    
			.CboSubsistema.Value		=	EVALUATE(thisform.cCursor_local+".CodSub")    
			.TxtMarca.Value				=   EVALUATE(thisform.cCursor_local+".Marca")   
			.TxtModelo.Value			=	EVALUATE(thisform.cCursor_local+".Modelo")    
			.TxtNoSerie.Value			=	EVALUATE(thisform.cCursor_local+".NoSerie")    

		ENDWITH

		*!*	WITH THIS.PARENT.PARENT.PAGES(3)
		*!*		.TxtCodMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".CodMaq")
		*!*		.TxtDesMaq.VALUE			=	EVALUATE(thisform.cCursor_local+".DesMaq")
		*!*	ENDWITH

		thisform.validitem() 
		*!*	THISFORM.Objcntref.cCursor_Local =  thisform.ccursor_local 
		*!*	IF !EOF(THISFORM.cCursor_local)
		*!*		THISFORM.objcntref.habilita() 
		*!*	ELSE
		*!*		THISFORM.objcntref.Deshabilita() 
		*!*	ENDIF
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		WITH THIS.PARENT
		    *!* Verifica Actualización de Datos
		    IF THISFORM.xReturn = "I"
				IF EMPTY(.TxtCodMaq.Value)
					=MESSAGEBOX("ERROR : Código no puede estar vacío...",48)
					.TxtCodMaq.SetFocus()
					RETURN
				ENDIF
				IF EMPTY(.TxtCodMaq.Value)
					=MESSAGEBOX("ERROR : Código no puede estar vacío...",48)
					.TxtCodMaq.SetFocus()
					RETURN
				ENDIF
			ENDIF
			*
			IF EMPTY(.TxtDesMaq.Value) OR ISNULL(.TxtDesMaq.Value)
				=MESSAGEBOX("ERROR : La Descripción no puede estar vacía...",48)
				.TxtDesMaq.SetFocus()
				RETURN
			ENDIF
			*
			SELECT(thisform.cCursor_Local)
			m.CodCia  		=	GsCodCia
			m.CodigoTA		=   thisform.CboTipAct.Value
			m.CodigoTM		=   thisform.cbotipMaqui.Value 
			m.CodMaq  		=	.TxtCodMaq.Value
			m.DesMaq		=   .TxtDesMaq.Value
			m.CodSis  		=	.CboSistema.Value
			m.CodSub		=	.CboSubSistema.Value
			m.Ubic_Actua	=	.TxtUbic_Actua.Value 
			m.Cod_Ubic		=   .CboUbicacion.Value 
			m.Cod_Area		=   .CboArea.Value 
			m.Cod_Espec		=   .CboEspecialidad.Value 
			m.Respon		=	.TxtRespon.Value
			m.Conto_actu	=	.SpnConto_actu.Value
			m.Dias_Avanc	=	.SpnDias_Avanc.Value
			m.Unid_avanc	=	.CntUnid_avanc.Value 
			m.Prom_Avan1	=	.SpnPrm_ava_Horas.Value 
			m.Prom_Avan2	=	.SpnPrm_ava_Minutos.Value
			m.Prom_Avan3	=	.SpnPrm_ava_segundos.Value
			m.Comentar		=	.EdtComentar.Value
			m.Marca 		= 	.TxtMarca.Value
			m.Modelo		=	.TxtModelo.Value
			m.NoSerie		= 	.TxtNoSerie.Value
		ENDWITH

		LnControl = 1


		IF lnControl > 0
			DO CASE

			    *!* Adicionar Registro
				CASE THISFORM.xReturn = "I" 
					INSERT INTO (thisform.ctabla_remota) FROM MEMVAR
					THISFORM.GenerarLog("0395",THIS.PARENT.PARENT.PAGES(1).cmdAdicionar1.CodigoBoton)
					*** Actualizar Cursor Local
					SELECT(thisform.CCursor_local) 
					APPEND BLANK
					GATHER MEMVAR

				*!* Modificar Registro
				CASE THISFORM.xReturn = "A"   
					UPDATE (thisform.ctabla_remota) SET ;
					DesMaq			=	m.DesMaq		,;
					CodSis  		=	m.CodSis		,;
					CodSub			=	m.CodSub		,;
					Ubic_Actua		=	m.Ubic_Actua	,;
					Respon			=	m.Respon		,;
					Conto_actu		=	m.Conto_actu	,;
					Dias_Avanc		=	m.Dias_Avanc	,;
					Unid_avanc		=	m.Unid_avanc	,; 
					Prom_Avan1		=	m.Prom_Avan1	,; 
					Prom_Avan2		=	m.Prom_Avan2	,;
					Prom_Avan3		=	m.Prom_Avan3	,;
					Comentar		=	m.Comentar ,;
					Marca			=	m.Marca		,;
					Modelo			=	m.Modelo	,;
					NoSerie			=	m.NoSerie	;
		    		WHERE eval(thisform.cCmpKey) = (thisform.cvalkey)

					SELECT(thisform.CCursor_local) 
					GATHER MEMVAR
					THISFORM.GenerarLog("0396",THIS.PARENT.PARENT.PAGES(1).cmdModificar1.CodigoBoton)
			ENDCASE
			this.Parent.Parent.Parent.lgrabado =.t.
			THIS.PARENT.cmdCancelar2.CLICK()

		ENDIF
	ENDPROC


	PROCEDURE cmdcancelar2.Click
		WITH THIS.PARENT.PARENT.PAGES(2)

			** Deshabilitar Controles
		*!*	    .CntCodigo.ENABLED = .F.
		*!*		.TxtNombre.ENABLED = .F.
		*!*		.TxtDigitos.ENABLED = .F.
			FOR LnControl = 1 TO .ControlCount
				.Controls(LnControl).Enabled = .F.
			ENDFOR
			.cmdAceptar2.ENABLED	= .F.
			.cmdCancelar2.ENABLED	= .F.

			** Inicializarlos ** 

		ENDWITH

		THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		THIS.ENABLED	= .F.

		WITH THIS.PARENT.PARENT
			.PAGES(1).ENABLED	= .T.
			.ACTIVEPAGE	= 1
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.cCursor_local)
			.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdImprimir1.ENABLED	= LlHayRegistros
			.PAGES(1).grdCtaAux.REFRESH()
			.PAGES(1).grdCtaAux.SETFOCUS()
		ENDWITH
		thisform.CbotipMaqui.Enabled = .T. 
		thisform.CbotipAct.Enabled = .T. 
	ENDPROC


	PROCEDURE cmdhelpcodmat.Click
		DODEFAULT()
		this.Parent.TxtCodMat.Value = this.cvalorvalida 
		this.Parent.TxtCodMat.SetFocus
		IF !EMPTY(this.Parent.TxtCodMat.Value)
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF
	ENDPROC


	PROCEDURE cbosistema.InteractiveChange
		this.Valid()
	ENDPROC


	PROCEDURE cbosistema.Valid
		this.Parent.cbosubsistema.cvaloresfiltro = this.value
		this.Parent.cboSubSistema.generarcursor()  
	ENDPROC


	PROCEDURE txtcodmaq.Valid
		IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
		   IF SEEK(THIS.Value,thisform.ctabla_remota,thisform.ctag_tr)
			  =MESSAGEBOX("ERROR : Código ya Existe...",48)
			  RETURN .F.
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE txtcodmaq.When
		WITH THISFORM
			IF .xreturn='I'
				this.Value=LoDa.Cap_NroItm(.cValor_id,.ctabla_remota,.cCmps_ID,.ccampo_id )
			ENDIF
		ENDWITH 
	ENDPROC


	PROCEDURE base_checkbox1.InteractiveChange
		IF this.Value
			this.Caption = "Ocultar detalle"
		ELSE
			this.Caption = "Ver detalle"
		ENDIF

		this.Parent.lblSistema.Visible			=	this.Value  
		this.Parent.lblsubsistema.Visible		=	this.Value  
		this.Parent.LblProm_avan1.Visible		=	this.Value  
		this.Parent.LblProm_avan2.Visible		=	this.Value  
		this.Parent.LblProm_avan3.Visible		=	this.Value  
		this.Parent.LblDias_avanc.Visible		=	this.Value  
		this.Parent.LblConto_actu.Visible		=	this.Value  

		this.Parent.cntUnid_avanc.Visible		=	this.Value  
		this.Parent.cboSistema.Visible			=	this.Value  
		this.Parent.cboSubSistema.Visible		=	this.Value  
		this.Parent.spnConto_actu.Visible		=	this.Value  
		this.Parent.spnDias_avanc.Visible		=	this.Value  
		this.Parent.SpnPrm_ava_Horas.Visible 	=	this.Value  
		this.Parent.SpnPrm_ava_minutos.Visible	=	this.Value  
		this.Parent.SpnPrm_Ava_Segundos.Visible =	this.Value  
	ENDPROC


	PROCEDURE cntdetalle_detalle_detalle1.graba_cmps_key
		PARAMETERS LoGrid
		DODEFAULT(LoGrid)
		*!*	LOCAL LoDa  AS DataAdmin OF k:\AplVfp\ClassGen\vcxs\FpDoSvr.vcx
		*!*	LoDa = CREATEOBJECT("FpDoSvr.DataAdmin")

		*!*	WITH LoGrid && this.grdDetalle 
		*!*		SELECT (.Recordsource)
		*!*		APPEND BLANK
		*!*		DO CASE 
		*!*			CASE Logrid.Name = 'GrdDetalle1'
		*!*	*!*				Replace CodCia		WITH	GsCodCia
		*!*	*!*				REPLACE CodigoTA	WITH	thisform.cbotipact.Value
		*!*	*!*				REPLACE CodigoTM	WITH	thisform.CbotipMaqui.Value
		*!*	*!*			    REPLACE CodMaq 		WITH    EVALUATE(thisform.cCursor_local+".CodMaq")

		*!*			    LcValKey	= eval(this.ccmps_id1)
		*!*			    LcCmpKey	= this.ccmps_id1
		*!*			    LcCmp_id 	=  this.ccampo_id1
		*!*			    REPLACE &LcCmp_id      WITH    Loda.Cap_NroItm(LcValKey,this.ctabla_Det1,LcCmpKey,LcCmp_id)

		*!*			CASE Logrid.Name = 'GrdDetalle2'
		*!*			    LcValKey	= eval(this.ccmps_id2)
		*!*			    LcCmpKey	= this.ccmps_id2
		*!*			    LcCmp_id 	=  this.ccampo_id2
		*!*			    REPLACE &LcCmp_id      WITH    Loda.Cap_NroItm(LcValKey,this.ctabla_Det2,LcCmpKey,LcCmp_id)
		*!*			CASE Logrid.Name = 'GrdDetalle3'
		*!*			    LcValKey	= eval(this.ccmps_id3)
		*!*			    LcCmpKey	= this.ccmps_id3
		*!*			    LcCmp_id 	=  this.ccampo_id3
		*!*			    REPLACE &LcCmp_id      WITH    Loda.Cap_NroItm(LcValKey,this.ctabla_Det3,LcCmpKey,LcCmp_id)
		*!*		ENDCASE 
		*!*		.Refresh 
		*!*		.column2.SetFocus() 
		*!*	ENDWITH

		*!*	RELEASE LoDa
	ENDPROC


	PROCEDURE txtcodmaq.When
		WITH THISFORM
			IF .xreturn='I'
				this.Value=LoDa.Cap_NroItm(.cValor_id,.ctabla_remota,.cCmps_ID,.ccampo_id )
			ENDIF
		ENDWITH 
	ENDPROC


	PROCEDURE txtcodmaq.Valid
		IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
		   IF SEEK(THIS.Value,thisform.ctabla_remota,thisform.ctag_tr)
			  =MESSAGEBOX("ERROR : Código ya Existe...",48)
			  RETURN .F.
		   ENDIF
		ENDIF
	ENDPROC


	PROCEDURE cbotipmaqui.Valid
		WITH THISFORM.pgfCtaAux.PAGES(1)
			.grdCtaAux.RECORDSOURCE		= ""
			.grdCtaAux.RECORDSOURCETYPE	= 4
			.cmdAdicionar1.ENABLED	    = .F.
			.cmdModificar1.ENABLED   	= .F.
			.cmdEliminar1.ENABLED   	= .F.
			.CmdImprimir1.ENABLED       = .F.
		ENDWITH

		WITH THISFORM
			.Tools.CloseTable(thisform.cCursor_local)

			.cValor_id = GsCodCia+.cboTipAct.value +.CboTipMaqui.Value 
			LoDa.abrirtabla('ABRIR',.ctabla_remota,.ctabla_remota,.CTAg_tr,'')
		  
			LoDa.genCursor(.Ccursor_Local,.ctabla_remota,.CTAg_tr,.cCmps_ID,.cValor_id,'',.CORder_cl)

			lnControl = 1
			IF lnControl < 0
				RETURN
			ENDIF
			WITH .pgfCtaAux.PAGES(1)
		         .grdCtaAux.RECORDSOURCETYPE	= 1
				 .grdCtaAux.RECORDSOURCE		= thisform.cCursor_local
				 .grdCtaAux.COLUMNS(1).CONTROLSOURCE	= thisform.cCursor_local+".CodMaq"
				 .grdCtaAux.COLUMNS(3).CONTROLSOURCE	= thisform.cCursor_local+".DesMaq"
				 .grdCtaAux.COLUMNS(2).CONTROLSOURCE	= thisform.cCursor_local+".Ubic_actua"
		 		 .grdCtaAux.COLUMNS(4).CONTROLSOURCE	= thisform.cCursor_local+".Respon"
				 .grdCtaAux.COLUMNS(5).CONTROLSOURCE	= thisform.cCursor_local+".Marca"
		 		 .grdCtaAux.COLUMNS(6).CONTROLSOURCE	= thisform.cCursor_local+".Modelo"
		  		 .grdCtaAux.COLUMNS(7).CONTROLSOURCE	= thisform.cCursor_local+".NoSerie"
				 .grdCtaAux.COLUMNS(8).CONTROLSOURCE	= thisform.cCursor_local+".Conto_Actu"
		 		 .grdCtaAux.COLUMNS(9).CONTROLSOURCE	= thisform.cCursor_local+".Dias_Avanc"

		 
				 .cmdAdicionar1.ENABLED	= .T.
				  LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.cCursor_local)
				 .cmdModificar1.ENABLED	= LlHayRegistros
				 .cmdEliminar1.ENABLED	= LlHayRegistros
				 .CmdImprimir1.ENABLED  = LlHayRegistros
				 .grdCtaAux.AfterRowColChange()
				 THIS.CLICK()
			ENDWITH
			WITH .pgfCtaAux.PAGES(2)

			ENDWITH

		ENDWITH
	ENDPROC


	PROCEDURE cbotipact.InteractiveChange
		this.Parent.cboTipMaqui.cvaloresfiltro = this.Value
		this.Parent.cboTipMaqui.Generarcursor() 
	ENDPROC


	PROCEDURE cbotipact.Valid
		this.InteractiveChange()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: act_maq
**************************************************
