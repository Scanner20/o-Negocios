**************************************************
*-- Class Library:  k:\aplvfp\libs\cristal.vcx
**************************************************


**************************************************
*-- Class:        cristal (k:\aplvfp\libs\cristal.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   12/26/07 12:20:01 PM
*
DEFINE CLASS cristal AS container


	Width = 38
	Height = 33
	BorderWidth = 0
	Visible = .F.
	programa = ("")
	usuarioosis = (.t.)
	tituloreporte = ("")
	usuario = ("")
	odbc = ("")
	password = ("")
	basedatos = ("")
	ruta = (Curdir()+"reports\")
	filtro = ("")
	showgrouptree = .T.
	showcancelbtn = .T.
	showclosebtn = .T.
	shownavigationctls = .T.
	showsearchbtn = .T.
	showzommctl = .T.
	showprinsetupbtn = .T.
	pagezoom = 100
	*-- Especifica si una ventana de un formulario se minimiza o maximiza en tiempo de ejecución.
	windowstate = 2
	*-- Destino donde va el reporte si es 1 a Impresora si es 0 es a Vista Preliminar
	destination = 0
	objetoclase = ("Crystal.CrystalReport")
	*-- Si es 0.- ODBC, 1.- Conexion SQL ,
	conexion = (1)
	*-- Si esta en .T. la conexón depende de la variable Oentorno.Conexion_Reporte (0 ODBC, 1 SQL), si esta en .F. la conexion depende de la propiedad Conexión
	conexion_entorno = .T.
	limpiar_filtro = .F.
	Name = "cristal"
	olecrystal = .F.

	*-- Parametro que se le envia al cristal report
	DIMENSION parametro[20,2]


	*-- Este Metodo almacena con datos Fijos las Variables que necesita el Cristal Report
	PROCEDURE cargadatosfijos
		PRIVATE lexe,lalias,ltipver,lused,lhaspar

		IF This.Limpiar_filtro 
			This.Filtro =""
		ENDIF

		IF TYPE("Otbr")=="O"
			Otbr.ActualizaOpciones()
		ENDIF


		DIMENSION This.Parametro[30,2] 
		This.Arma_Parametros() 

		lexe="Select ISNULL(s27_codver,'') as s27_codver "+;
			 "From dbo.sys_tabla_opciones_s07 "+;
			 "Where UPPER(s07_codopc)='"+ALLTRIM(UPPER(This.programa))+"' "

		lalias=SYS(2015)

		IF SQLEXEC(Ocnx.Conexion,lexe,lalias)<0
			MESSAGEBOX("Se Produjo un Error al Consultar la Versión del Reporte: "+CHR(13)+;
					   MESSAGE(),16,ThisForm.Caption) 
			RETURN .F.
		ENDIF
		ltipver=NVL(s27_codver,'')

		IF USED(lalias)
			lused="Use in '"+lalias+"'"
			&lused
		ENDIF

		IF EMPTY(ltipver)
			MESSAGEBOX("El Reporte con Codigo de Programa: "+ALLTRIM(This.programa)+;
					   " No Indica la Versión que utiliza"+CHR(13)+;
					   "Comuniquese con el personal de Sistemas",64,ThisForm.Caption)
			RETURN .F.
		ENDIF

		ls_file=UPPER(ALLTRIM(This.Ruta+trim(This.programa)+".RPT"))

		If !File(ls_file)
		 	MessageBox("El Archivo: "+ls_file+". NO SE ENCUENTRA",64,"Informe") 
			Return .f.
		EndIf


		IF ltipver=='03'
			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			TRY 
				SET MESSAGE TO 'Abriendo componente para impresión......'
				This.Olecrystal = CREATEOBJECT("ViewerCrystalReport_v11_2.ClsReport")
				SET MESSAGE TO ''
				lhaspar=ALEN(This.Parametro,1)
				For ll_n=1 to lhaspar
					IF TYPE("This.Parametro[ll_n,1]")<>"L"
						This.Olecrystal.SetValue_ParamReport(This.Parametro[ll_n,1],This.Parametro[ll_n,2])
					ENDIF
				EndFor
				********* Arma cadena para filtros **
				This.Filtros()
				*************************************
				If len(This.Filtro)>0
				   This.Olecrystal.FormulaSelection=This.Filtro
				EndIf


		*!*			This.Olecrystal.SetValue_ParamReport("ps_cia",Thisform.entorno.codigocia)
		*!*			oReport.SetValue_ParamReport("ps_suc",Thisform.entorno.codigosuc)
		*!*			oReport.SetValue_ParamReport("ps_ano",Thisform.entorno.ano)
		*!*			oReport.SetValue_ParamReport("ps_mes",Thisform.entorno.mes)
		*!*			oReport.SetValue_ParamReport("ps_nombrecia",Thisform.entorno.nombrecia)
		*!*			oReport.SetValue_ParamReport("ps_programa",Thisform.entorno.programa)
		*!*			oReport.SetValue_ParamReport("ps_tituloprograma",Thisform.entorno.titulo)
		*!*			oReport.SetValue_ParamReport("ps_usuario",Ocnx.Usuario)
		*!*			oReport.SetValue_ParamReport("ps_rango_periodo",Thisform.ps_titulo_rango_periodo)
		*!*			oReport.SetValue_ParamReport("ps_indicador_kilos",ps_indicador_kilos)
		*!*			oReport.SetValue_ParamReport("ps_indicador_stock",ps_indicador_stock)

		*!*			ls_file=UPPER(ALLTRIM(ThisForm.Cristal.Ruta+trim(ThisForm.cristal.programa)+".RPT"))

		*!*			If !File(ls_file)
		*!*			 	MessageBox("El Archivo: "+ls_file+". NO SE ENCUENTRA",64,"Informe") 
		*!*				Return .f.
		*!*			EndIf

				WITH This.Olecrystal
					.Destino  = This.Destination 
					.Text 	  = This.TituloReporte
					.DataBase 	= Ocnx.BaseDatos
					.DataSource = ALLTRIM(Ocnx.Servidor)
					.UserName 	= ALLTRIM(Ocnx.Usuario)
					.Password 	= ALLTRIM(Ocnx.Password)
					.ReportDocument = ls_file
					.PrintReport()
				ENDWITH 
				IF This.Destination = 0
					This.Olecrystal.Show()
				ENDIF

			CATCH TO lerror
				MESSAGEBOX(lerror.message+CHR(13)+CHR(13)+ALLTRIM(MESSAGE(1)),16,This.Name) 
			ENDTRY

			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			RETURN 

		ENDIF


		&&susp
		This.Olecrystal=CREATEOBJECT(This.ObjetoClase)
		This.Olecrystal.Reset()
		This.Olecrystal.WindowTitle				 = This.TituloReporte
		This.Olecrystal.WindowState				 = This.WindowState 
		This.Olecrystal.WindowShowGroupTree		 = This.ShowGroupTree 
		This.Olecrystal.WindowShowCancelBtn		 = This.ShowCancelBtn 
		This.Olecrystal.WindowShowCloseBtn 		 = This.ShowClosebtn 
		This.Olecrystal.WindowShowNavigationCtls = This.ShowNavigationCtls 
		This.Olecrystal.WindowShowSearchBtn 	 = This.ShowSearchBtn 
		This.Olecrystal.WindowShowZoomCtl 		 = This.ShowZommCtl 
		This.Olecrystal.Destination				 = This.Destination 
		This.Olecrystal.PageZoom(This.PageZoom)

		***--- Para seleccionar la impresora
		This.Olecrystal.WindowShowPrintSetupBtn = This.ShowPrinSetupBtn 

		IF This.Conexion_entorno 
			This.Conexion = Oentorno.Tipo_Conexion_Reporte
		ENDIF

		IF ltipver=='01'
			This.Conexion=0
		ENDIF

		IF ltipver=='02'
			This.Conexion=1
		ENDIF

		IF This.Conexion=0	 && Nombre del ODBC
			ls_connect= "DSN = "+Ocnx.Odbc+";UID = " +Ocnx.Usuario+ ";PWD = " +Ocnx.Password+ ";DSQ= "+Ocnx.BaseDatos
		EndIf
		IF This.Conexion=1 && SQL Server -- Este es que debemos utilizar siempre
			ls_connect= "DSN = "+ALLTRIM(Ocnx.Servidor)+";UID = " +ALLTRIM(Ocnx.Usuario)+ ";PWD = " +ALLTRIM(Ocnx.Password)+ ";DSQ= "+ALLTRIM(Ocnx.BaseDatos)
		EndIf
		&&SET MESSAGE TO ls_connect

		*!*	  ls_connect="driver=SQL Server;server="+ALLTRIM(Ocnx.Servidor)+;
		*!*		    		  ";database="+ALLTRIM(Ocnx.BaseDatos)+";uid="+ALLTRIM(Ocnx.Usuario)+;
		*!*		    		  ";pwd="+ALLTRIM(Ocnx.Password)


		This.Olecrystal.Connect			= ls_connect

		ls_file=UPPER(ALLTRIM(This.Ruta+trim(This.programa)+".RPT"))

		*!*	If !File(ls_file)
		*!*	 	MessageBox("El Archivo: "+ls_file+". NO SE ENCUENTRA",64,"Informe") 
		*!*		Return .f.
		*!*	EndIf

		This.Olecrystal.ReportFileName = ls_file
		This.Olecrystal.windowShowGroupTree=This.ShowGroupTree


		For ll_n=1 to 30
			 If !Empty(This.Parametro[ll_n,1]) then
			 	 IF TYPE("This.Parametro[ll_n,2]")=="C"
			 	 	lparametro2=This.Parametro[ll_n,2]
			 	 ENDIF
			 	 IF TYPE("This.Parametro[ll_n,2]")=="N"
				 	 lparametro2=STR(This.Parametro[ll_n,2])
			 	 ENDIF
			     This.Olecrystal.ParameterFields[ll_n - 1] = This.Parametro[ll_n,1]+";"+lparametro2+";true"
			 EndIf
		EndFor
		********* Arma cadena para filtros **
		This.Filtros()
		*************************************
		If len(This.Filtro)>0
		   This.Olecrystal.SelectionFormula=This.Filtro
		EndIf

		This.Olecrystal.Action=1
	ENDPROC


	PROCEDURE cargadatososis
		*!*	If This.UsuarioOSIS
		*!*	   xcxc=Sele()
		*!*	   Wuse="Use "+Curdir()+"sis\sys_prog in 0 shared order i "
		*!*	   &Wuse
		*!*	   If !Seek(This.Programa,"Sys_prog","I")
		*!*	      MessageBox("No Esta Registrado el Programa "+This.Programa,64,Gcia)
		*!*	      Retu .f.
		*!*	   EndIf
		*!*	   
		*!*	   This.TituloReporte=sys_prog.descrip
		*!*	      
		*!*	   Use in "sys_prog"
		*!*	   Sele (xcxc)
		*!*	EndIf

		PRIVATE lcad,larea

		lcad="Select s07_noms07 "+;
		     "From dbo.SYS_TABLA_OPCIONES_S07 "+;
		     "Where s07_codopc=?This.Programa "

		larea=SELECT()
		IF SQLEXEC(Ocnx.conexion,lcad,"Topciones")<0
		   MESSAGEBOX("Error: "+MESSAGE())
		   RETURN .F.
		ENDIF
		IF !EOF()
		    This.TituloReporte=NVL(Topciones.s07_noms07,'.NULL.')
		ELSE 
		   MESSAGEBOX("PROGRAMA: "+This.Programa+" NO HA SIDO REGISTRADO",64,ThisForm.Entorno.Codigocia)
		   SELECT (larea)
		   RETURN .f.
		ENDIF
		SELECT (larea)
		Retu .t.
	ENDPROC


	PROCEDURE activareporte
		This.CargaDatosFijos()
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine

		MessageBox("Error: "+Mess()+chr(13)+;
		           "Metodo: "+cMethod+chr(13)+;
		           "Codigo: "+Mess(1),16,"Informe")
	ENDPROC


	PROCEDURE Init
		This.Ruta=ThisForm.Entorno.Ruta+"Reports\" 
	ENDPROC


	PROCEDURE arma_parametros
	ENDPROC


	PROCEDURE filtros
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cristal
**************************************************


**************************************************
*-- Class:        formulario_factura (k:\aplvfp\libs\cristal.vcx)
*-- ParentClass:  formulario (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   04/12/05 06:10:09 PM
*
DEFINE CLASS formulario_factura AS formulario


	Height = 519
	Width = 791
	DoCreate = .T.
	WindowState = 2
	serie = ("001")
	no_pide_serie = (.f.)
	indicador_facbve_ncrndb = (1)
	llavecontroles = "ThisForm.Frm_Facturas.ctn_tdo_codtdo.tdo_codtdo.Value+ThisForm.Frm_Facturas.Cte_NumDoc.Value"
	formatotipo = 2
	habilita_anular = .F.
	habilita_nuevo = .F.
	habilita_grabar = .F.
	Name = "formulario_factura"
	entorno.Name = "entorno"
	StatusBar.Top = 496
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 791
	StatusBar.TabIndex = 4
	StatusBar.Name = "StatusBar"
	cristal.TabIndex = 5
	cristal.Name = "cristal"
	CABECERA.nombretabla = "Cuenta_Corriente_Cte"
	CABECERA.indicador_storeprocedure = .T.
	CABECERA.indicador_tabla_osis = .T.
	CABECERA.indicador_foraneos = .T.
	CABECERA.tipoverificacion = 2
	CABECERA.Name = "CABECERA"
	Cursor.llave = "tdo_codtdo+cte_numdoc"
	Cursor.parametros = "ThisForm.Entorno.CodigoCia,ThisForm.Entorno.CodigoSuc"
	Cursor.sqlwhere = "cte_codpag='C' and tdo_codtdo in ('FAC','BVE','NCR','NDB')"
	Cursor.Name = "Cursor"


	ADD OBJECT frm_facturas AS frm_facturas WITH ;
		Top = 0, ;
		Left = 0, ;
		Width = 786, ;
		Height = 251, ;
		BorderWidth = 0, ;
		SpecialEffect = 0, ;
		TabIndex = 1, ;
		Name = "Frm_facturas", ;
		ctn_tdo_codtdo.tdo_codtdo.Name = "tdo_codtdo", ;
		ctn_tdo_codtdo.Etiqueta1.Name = "Etiqueta1", ;
		ctn_tdo_codtdo.txt_descri.Name = "txt_descri", ;
		ctn_tdo_codtdo.Name = "ctn_tdo_codtdo", ;
		cte_numdoc.Name = "cte_numdoc", ;
		Etiqueta1.Name = "Etiqueta1", ;
		ctn_aux_codaux.aux_codaux.Name = "aux_codaux", ;
		ctn_aux_codaux.Etiqueta1.Name = "Etiqueta1", ;
		ctn_aux_codaux.txt_descri.Name = "txt_descri", ;
		ctn_aux_codaux.Name = "ctn_aux_codaux", ;
		cte_fecemi.Name = "cte_fecemi", ;
		Etiqueta2.Name = "Etiqueta2", ;
		ctn_cpa_codcpa.cpa_codcpa.Name = "cpa_codcpa", ;
		ctn_cpa_codcpa.Etiqueta1.Name = "Etiqueta1", ;
		ctn_cpa_codcpa.txt_descri.Name = "txt_descri", ;
		ctn_cpa_codcpa.Name = "ctn_cpa_codcpa", ;
		cte_fecven.Name = "cte_fecven", ;
		Etiqueta3.Name = "Etiqueta3", ;
		tmo_codtmo.Name = "tmo_codtmo", ;
		Etiqueta4.Name = "Etiqueta4", ;
		cte_tasigv.Name = "cte_tasigv", ;
		Etiqueta5.Name = "Etiqueta5", ;
		cte_tipcam.Name = "cte_tipcam", ;
		Etiqueta6.Name = "Etiqueta6", ;
		ctn_tcc_codtra.tcc_codtra.origenes = ('050'), ;
		ctn_tcc_codtra.tcc_codtra.Name = "tcc_codtra", ;
		ctn_tcc_codtra.Etiqueta1.Name = "Etiqueta1", ;
		ctn_tcc_codtra.txt_descri.Name = "txt_descri", ;
		ctn_tcc_codtra.Name = "ctn_tcc_codtra", ;
		cte_codcte.Name = "cte_codcte", ;
		Etiqueta7.Top = 227, ;
		Etiqueta7.Name = "Etiqueta7", ;
		Tdo_docref.Name = "Tdo_docref", ;
		cte_numref.Name = "cte_numref", ;
		cte_fecref.Name = "cte_fecref", ;
		Etiqueta8.Name = "Etiqueta8", ;
		CIA_CODCIA.Name = "CIA_CODCIA", ;
		SUC_CODSUC.Name = "SUC_CODSUC", ;
		cte_glocte.Top = 198, ;
		cte_glocte.Width = 329, ;
		cte_glocte.Name = "cte_glocte", ;
		Etiqueta9.Name = "Etiqueta9", ;
		cte_impdoc.Name = "cte_impdoc", ;
		cte_impina.Name = "cte_impina", ;
		cte_impafe.Name = "cte_impafe", ;
		ctn_vde_codvde.vde_codvde.Name = "vde_codvde", ;
		ctn_vde_codvde.Etiqueta1.Name = "Etiqueta1", ;
		ctn_vde_codvde.txt_descri.Name = "txt_descri", ;
		ctn_vde_codvde.Name = "ctn_vde_codvde", ;
		dpc_impdes.Name = "dpc_impdes", ;
		txt_descri_situacion.Name = "txt_descri_situacion", ;
		Etiqueta10.Name = "Etiqueta10", ;
		edo_codedo.Name = "edo_codedo", ;
		ctn_zve_codzve.zve_codzve.Name = "zve_codzve", ;
		ctn_zve_codzve.Etiqueta1.Name = "Etiqueta1", ;
		ctn_zve_codzve.txt_descri.Name = "txt_descri", ;
		ctn_zve_codzve.Name = "ctn_zve_codzve", ;
		dpc_indexp.Name = "dpc_indexp", ;
		DPC_INDTEX.Name = "DPC_INDTEX", ;
		dpc_ordcom.Top = 49, ;
		dpc_ordcom.Name = "dpc_ordcom", ;
		Etiqueta11.Top = 53, ;
		Etiqueta11.Name = "Etiqueta11", ;
		dpc_impfle.Name = "dpc_impfle", ;
		dpc_impseg.Name = "dpc_impseg", ;
		ctn_lde_codlde.lde_codlde.Name = "lde_codlde", ;
		ctn_lde_codlde.Etiqueta1.Name = "Etiqueta1", ;
		ctn_lde_codlde.aux_direccion.Name = "aux_direccion", ;
		ctn_lde_codlde.Name = "ctn_lde_codlde", ;
		cco_codcco.Name = "cco_codcco", ;
		dpc_indcal.Name = "dpc_indcal", ;
		Etiqueta12.Name = "Etiqueta12", ;
		ori_codori.Name = "ori_codori", ;
		tlp_codtlp.Name = "tlp_codtlp", ;
		lpc_codlpc.Name = "lpc_codlpc", ;
		Etiqueta13.Name = "Etiqueta13", ;
		dpc_indtca.Name = "dpc_indtca", ;
		dpc_numcuo.Name = "dpc_numcuo", ;
		BtnCuota.Name = "BtnCuota", ;
		sfa_numsfa.Name = "sfa_numsfa", ;
		Etiqueta14.Name = "Etiqueta14", ;
		BtnAsiento.Name = "BtnAsiento", ;
		ctn_tie_codtie.Etiqueta1.Name = "Etiqueta1", ;
		ctn_tie_codtie.tie_codtie.Name = "tie_codtie", ;
		ctn_tie_codtie.txt_descri.Name = "txt_descri", ;
		ctn_tie_codtie.Name = "ctn_tie_codtie"


	ADD OBJECT detalle_factura AS detalle_factura WITH ;
		Height = 159, ;
		Left = 0, ;
		TabIndex = 2, ;
		Top = 254, ;
		Width = 791, ;
		datoobjeto = "Datos_Detalle", ;
		Name = "Detalle_factura", ;
		Column1.Header1.Name = "Header1", ;
		Column1.Text1.ForeColor = RGB(128,128,128), ;
		Column1.Text1.Name = "Text1", ;
		Column1.ForeColor = RGB(128,128,128), ;
		Column1.Name = "Column1", ;
		Column2.Header1.Name = "Header1", ;
		Column2.prd_codprd.ayudaindicedefault = 2, ;
		Column2.prd_codprd.Name = "prd_codprd", ;
		Column2.Name = "Column2", ;
		Column3.Header1.Name = "Header1", ;
		Column3.prd_desesp.Name = "prd_desesp", ;
		Column3.Name = "Column3", ;
		Column4.Header1.Name = "Header1", ;
		Column4.Text1.Name = "Text1", ;
		Column4.Name = "Column4", ;
		Column5.Header1.Name = "Header1", ;
		Column5.Text1.Name = "Text1", ;
		Column5.Name = "Column5", ;
		Column6.Header1.Name = "Header1", ;
		Column6.Text1.Name = "Text1", ;
		Column6.Name = "Column6", ;
		Column7.Header1.Name = "Header1", ;
		Column7.Text1.Name = "Text1", ;
		Column7.Name = "Column7", ;
		Column8.Header1.Name = "Header1", ;
		Column8.Text1.Name = "Text1", ;
		Column8.Name = "Column8", ;
		Column9.Header1.Name = "Header1", ;
		Column9.Text1.Name = "Text1", ;
		Column9.Name = "Column9", ;
		Column10.Header1.Name = "Header1", ;
		Column10.Text1.Name = "Text1", ;
		Column10.Name = "Column10", ;
		Column11.Header1.Name = "Header1", ;
		Column11.Text1.Name = "Text1", ;
		Column11.Name = "Column11", ;
		Column14.Header1.Name = "Header1", ;
		Column14.Text1.Name = "Text1", ;
		Column14.Name = "Column14", ;
		Column15.Header1.Name = "Header1", ;
		Column15.Text1.Name = "Text1", ;
		Column15.Name = "Column15", ;
		Column16.Header1.Name = "Header1", ;
		Column16.Text1.Name = "Text1", ;
		Column16.Name = "Column16", ;
		Column17.Header1.Name = "Header1", ;
		Column17.Text1.Name = "Text1", ;
		Column17.Name = "Column17", ;
		Column18.Header1.Name = "Header1", ;
		Column18.Text1.ForeColor = RGB(128,128,128), ;
		Column18.Text1.Name = "Text1", ;
		Column18.ForeColor = RGB(128,128,128), ;
		Column18.Name = "Column18", ;
		Column12.Header1.Name = "Header1", ;
		Column12.Text1.ForeColor = RGB(0,0,160), ;
		Column12.Text1.Name = "Text1", ;
		Column12.ForeColor = RGB(0,0,160), ;
		Column12.Name = "Column12"


	ADD OBJECT ctn_total AS contenedor WITH ;
		Top = 416, ;
		Left = 0, ;
		Width = 785, ;
		Height = 79, ;
		BorderWidth = 1, ;
		SpecialEffect = 0, ;
		TabIndex = 3, ;
		Name = "Ctn_total"


	ADD OBJECT formulario_factura.ctn_total.dpc_impbru AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		InputMask = "99,999,999.99", ;
		Left = 490, ;
		Top = 25, ;
		NullDisplay = "0", ;
		datoobjeto = "cabecera", ;
		Name = "dpc_impbru"


	ADD OBJECT formulario_factura.ctn_total.dpc_impdes AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		InputMask = "99,999,999.99", ;
		Left = 490, ;
		Top = 50, ;
		NullDisplay = "0", ;
		datoobjeto = "cabecera", ;
		Name = "dpc_impdes"


	ADD OBJECT formulario_factura.ctn_total.cte_valvta AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		InputMask = "99,999,999.99", ;
		Left = 679, ;
		Top = 1, ;
		NullDisplay = "0", ;
		datoobjeto = "cabecera", ;
		Name = "cte_valvta"


	ADD OBJECT formulario_factura.ctn_total.cte_impigv AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999,999.99", ;
		Left = 679, ;
		Top = 24, ;
		Width = 100, ;
		NullDisplay = "0", ;
		datoobjeto = "cabecera", ;
		Name = "cte_impigv"


	ADD OBJECT formulario_factura.ctn_total.cte_impdoc AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		Height = 24, ;
		InputMask = "99,999,999.99", ;
		Left = 679, ;
		Top = 49, ;
		Width = 100, ;
		NullDisplay = "0", ;
		datoobjeto = "cabecera", ;
		Name = "cte_impdoc"


	ADD OBJECT formulario_factura.ctn_total.dpc_impseg AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		InputMask = "99,999,999.99", ;
		Left = 314, ;
		Top = 25, ;
		datoobjeto = "cabecera", ;
		Name = "dpc_impseg"


	ADD OBJECT formulario_factura.ctn_total.dpc_impfle AS texto WITH ;
		Alignment = 3, ;
		Value = 0, ;
		Enabled = .F., ;
		InputMask = "99,999,999.99", ;
		Left = 314, ;
		Top = 50, ;
		datoobjeto = "cabecera", ;
		Name = "dpc_impfle"


	ADD OBJECT formulario_factura.ctn_total.etiqueta1 AS etiqueta WITH ;
		Caption = "Importe Total", ;
		Left = 612, ;
		Top = 54, ;
		Name = "Etiqueta1"


	ADD OBJECT formulario_factura.ctn_total.etiqueta2 AS etiqueta WITH ;
		Caption = "Importe IGV", ;
		Left = 618, ;
		Top = 29, ;
		Name = "Etiqueta2"


	ADD OBJECT formulario_factura.ctn_total.etiqueta3 AS etiqueta WITH ;
		Caption = "Valor Vta", ;
		Left = 631, ;
		Top = 5, ;
		Name = "Etiqueta3"


	ADD OBJECT formulario_factura.ctn_total.etiqueta4 AS etiqueta WITH ;
		Caption = "Descuento", ;
		Left = 433, ;
		Top = 54, ;
		Name = "Etiqueta4"


	ADD OBJECT formulario_factura.ctn_total.etiqueta5 AS etiqueta WITH ;
		Caption = "Importe Bruto", ;
		Left = 422, ;
		Top = 29, ;
		Name = "Etiqueta5"


	ADD OBJECT formulario_factura.ctn_total.etiqueta6 AS etiqueta WITH ;
		Caption = "Seguro", ;
		Left = 273, ;
		Top = 29, ;
		Name = "Etiqueta6"


	ADD OBJECT formulario_factura.ctn_total.etiqueta7 AS etiqueta WITH ;
		Caption = "Flete", ;
		Height = 15, ;
		Left = 284, ;
		Top = 54, ;
		Width = 25, ;
		Name = "Etiqueta7"


	ADD OBJECT formulario_factura.ctn_total.chk_correlativo AS check WITH ;
		Top = 60, ;
		Left = 5, ;
		Caption = "Correlativo Automático", ;
		Value = 1, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Chk_Correlativo"


	ADD OBJECT formulario_factura.ctn_total.texto1 AS texto WITH ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 4, ;
		Top = 1, ;
		Width = 236, ;
		Name = "Texto1"


	ADD OBJECT formulario_factura.ctn_total.texto2 AS texto WITH ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 5, ;
		Top = 19, ;
		Width = 120, ;
		Name = "Texto2"


	ADD OBJECT formulario_factura.ctn_total.texto3 AS texto WITH ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 240, ;
		Top = 1, ;
		Width = 348, ;
		Name = "Texto3"


	ADD OBJECT formulario_factura.ctn_total.texto4 AS texto WITH ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 5, ;
		Top = 38, ;
		Width = 265, ;
		Name = "Texto4"


	ADD OBJECT datos_detalle AS datos WITH ;
		Top = 444, ;
		Left = 144, ;
		nombretabla = "CUENTAS_COBRAR_DCD", ;
		item = "DCD_CORDCD", ;
		llave = "DCD_CORDCD", ;
		cuadriculaasociada = "ThisForm.Detalle_Factura", ;
		ceros = .T., ;
		secuenciagrabacion = 2, ;
		elimina_anular = .T., ;
		tipoverificacion = 2, ;
		Name = "Datos_Detalle"


	ADD OBJECT datos_cuota AS datos WITH ;
		Top = 444, ;
		Left = 204, ;
		Height = 18, ;
		Width = 36, ;
		nombretabla = "CUENTAS_COBCUOTAS_CCU", ;
		llave = "cte_codcte", ;
		parametros = "tcur.cia_codcia,tcur.suc_codsuc,tcur.cte_codcte", ;
		secuenciagrabacion = 3, ;
		tipoverificacion = 2, ;
		Name = "Datos_Cuota"


	ADD OBJECT datos_descuento_detalle AS datos WITH ;
		Top = 456, ;
		Left = 84, ;
		Height = 18, ;
		Width = 36, ;
		nombretabla = "CUENTAS_COBDETALLE_DDD", ;
		llave = "prd_codprd+dcd_secdcd+dco_coddco", ;
		parametros = "Tcur.cia_codcia,Tcur.suc_codsuc,Tcur.cte_codcte", ;
		secuenciagrabacion = 4, ;
		actualiza_fecha_usuario = .T., ;
		indicador_tabla_osis = .T., ;
		elimina_anular = .T., ;
		tipoverificacion = 2, ;
		Name = "Datos_Descuento_Detalle"


	ADD OBJECT ventas AS ventas WITH ;
		Top = 468, ;
		Left = 156, ;
		Name = "Ventas"


	ADD OBJECT datos_solicitud_atendida AS datos WITH ;
		Top = 420, ;
		Left = 324, ;
		Height = 12, ;
		secuenciagrabacion = 5, ;
		tipoverificacion = 2, ;
		nombretabla = "SOLICITUD_FACTURAATENDIDA_SFA", ;
		parametros = "Tcur.cia_codcia,Tcur.suc_codsuc,Tcur.cte_codcte", ;
		llave = "prd_codprd+ppd_secppd", ;
		actualiza_fecha_usuario = .T., ;
		elimina_anular = .T., ;
		indicador_tabla_osis = .T., ;
		Name = "Datos_Solicitud_Atendida"


	ADD OBJECT dcm_coddcm AS dcm_coddcm WITH ;
		Height = 23, ;
		Left = 696, ;
		Top = 192, ;
		Visible = .F., ;
		Width = 13, ;
		datoobjeto = "Datos_Detalle", ;
		Name = "Dcm_coddcm"


	ADD OBJECT datos_kardex AS datos WITH ;
		Top = 420, ;
		Left = 444, ;
		Height = 12, ;
		secuenciagrabacion = 6, ;
		tipoverificacion = 2, ;
		nombretabla = "FACTURA_KARDEX_FAK", ;
		parametros = "Tcur.cia_codcia,Tcur.suc_codsuc,Tcur.cte_codcte", ;
		llave = "cte_codcte", ;
		actualiza_fecha_usuario = .T., ;
		elimina_anular = .T., ;
		indicador_tabla_osis = .T., ;
		Name = "Datos_Kardex"


	PROCEDURE selecciona_precio
		Store 0 to lprecio,lpreigv,lpredol,lvtadol


		lcodprd=CUENTAS_COBRAR_DCD.prd_codprd
		lobsppd=''
		PRIVATE lpre,larea

		larea=SELECT()
		&& Verifica en la lista de Precio

		ltcl="Select tlp_codtlp "+;
		     "From dbo.CLIENTES_CIA_CLC "+;
		     "Where cia_codcia=?ThisFOrm.Entorno.CodigoCia "+;
		     "and   aux_codaux=?ThisForm.Frm_facturas.Ctn_aux_codaux.aux_codaux.Value "

		IF SQLEXEC(Ocnx.Conexion,ltcl,"Ttcli")<0
		   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+ltcl,16,ThisForm.Entorno.Nombrecia)
		   SELECT (larea)
		   RETURN
		ENDIF


		lpre="Select b.* "+;
		     "From dbo.lista_precio_lpc a "+;
		     "inner join dbo.lista_precio_lpd b "+;
		     "On (b.cia_codcia=a.cia_codcia "+;
		     "and b.lpc_codlpc=a.lpc_codlpc) "+;
		     "Where a.cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and   a.tlp_codtlp=?Ttcli.tlp_codtlp "+;
		     "and   a.lpc_codlpc=?ThisForm.Frm_facturas.Lpc_codlpc.Value "+;
		     "and   a.lpc_indest='1' "+;
		     "and   b.prd_codprd=?lcodprd "
		     
		IF SQLEXEC(Ocnx.Conexion,lpre,"Tprecio")<0
		   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+ltcl,16,ThisForm.Entorno.Nombrecia)
		   SELECT (larea)
		   RETURN 
		ENDIF

		     
		lprecio=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,lpd_prenac,lpd_predol )
		lpreigv=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,lpd_vtanac,lpd_vtadol )
		lpredol=lpd_predol
		lvtadol=lpd_vtadol
		lcodtcl='01'


		&& Verifica Precio Especial 
		lpre="Select a.* "+;
		     "From dbo.PRECIOS_CLIENTE_PCL a "+;
		     "Where a.cia_codcia=?ThisForm.Entorno.Codigocia "+;
		     "and   a.aux_codaux=?ThisForm.Frm_facturas.Ctn_aux_codaux.aux_codaux.Value "+;
		     "and   a.pcl_indest='1' "+;
		     "and   a.prd_codprd=?lcodprd "
		     
		IF SQLEXEC(Ocnx.Conexion,lpre,"Tprecio")<0
		   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lpre,16,ThisForm.Entorno.Nombrecia)
		   SELECT (larea)
		   RETURN
		ENDIF

		IF !EOF() 
			lprecio=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,pcl_prenac,pcl_predol )
			lpreigv=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,pcl_vtanac,pcl_vtadol )
			lcodtcl='02'
			lobsppd='PRECIO ESPECIAL'
			lpredol=pcl_predol
			lvtadol=pcl_vtadol

		ENDIF


		&& Verifica Oferta


		lpre="Select a.* "+;
		     "From dbo.LISTA_OFERTA_LOD a "+;
		     "Inner Join dbo.LISTA_OFERTA_LOC b "+;
		     "On (b.cia_codcia=a.cia_codcia "+;
		     "and b.loc_codloc=a.loc_codloc) "+;
		     "Where a.cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		     "and  '"+DTOS(ThisForm.Frm_facturas.cte_fecemi.Value)+"' Between LEFT(Convert(char,b.loc_fecini,112),8) "+;
		     "and  LEFT(Convert(char,b.loc_fecfin,112),8) "+;
		     "and  a.prd_codprd=?lcodprd "+;
		     "and  b.loc_indest='1' "

		IF SQLEXEC(Ocnx.Conexion,lpre,"Tprecio")<0
		   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lpre,16,ThisForm.Entorno.Nombrecia)
		   SELECT (larea)
		   RETURN
		ENDIF

		IF !EOF()
			lprecio=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,lod_prenac,lod_predol )
			lpreigv=IIF(ThisForm.frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda,lod_vtanac,lod_vtadol )
			lcodtcl='03'
			lobsppd='PRECIO OFERTA '+loc_codloc
		    lpredol=lod_predol
		    lvtadol=lod_vtadol
		ENDIF
		IF ThisForm.Frm_facturas.dpc_indtca.Value=1  
		   IF ThisForm.Frm_facturas.tmo_codtmo.Value=ThisForm.Entorno.Moneda 
			  lprecio=ROUND(lpredol*ThisForm.Frm_facturas.Cte_tipcam.Value,4) 
			  lpreigv=ROUND(lvtadol*ThisForm.Frm_facturas.Cte_tipcam.Value,3)
		   ENDIF
		ENDIF

		This.Detalle_Factura.Column7.Text1.Value=lpreigv
		This.Detalle_Factura.Column7.Text1.Refresh()
		This.Detalle_Factura.Column6.Text1.Value=lprecio
		This.Detalle_Factura.Refresh()

		SELECT (larea)
	ENDPROC


	PROCEDURE verifica_factura_kardex
		PRIVATE lok,lcarea,lexe
		lok=.F.

		lcarea=SELECT()

		lexe="Select count(*) as canti "+;
			 "From dbo.FACTURA_KARDEX_FAK "+;
			 "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
			 "and   suc_codsuc=?ThisForm.Entorno.CodigoSuc "+;
			 "and   cte_codcte=?This.frm_facturas.cte_codcte.Value "
			 
		IF SQLEXEC(Ocnx.Conexion,lexe,"Tfak")>0
		   IF  Tfak.canti>0
		       lok=.T.
		   ENDIF
		ELSE
		   WAIT WINDOW "Error: "+MESSAGE() NoWait
		ENDIF

		IF USED("Tfak")
		   USE IN "Tfak"
		ENDIF

		SELECT (lcarea)
		RETURN lok
	ENDPROC


	PROCEDURE secuencia_producto
		LPARAMETERS lpant
		PRIVATE lcarea,lrec,lprd,lsec
		lcarea=SELECT()
		SELECT (This.Datos_Detalle.Area)  
		IF !EOF() AND (EMPTY(NVL(dcd_secdcd,'')) OR prd_codprd<>NVL(lpant,''))
			lprd=NVL(prd_codprd,'')
			IF !EMPTY(lprd)
				IF prd_codprd<>NVL(lpant,'')
					This.Detalle_factura.Column18.text1.Value =  ''
					This.Detalle_factura.Column18.Refresh() 
				ENDIF
				lrec=RECNO()
				ltag=TAG()
				INDEX ON prd_codprd+dcd_secdcd TAG cod_sec
				SET KEY TO lprd
				GO bottom
				IF EOF()
					lsec = '01'
				ELSE
					lsec = STRTRAN(STR(VAL(dcd_secdcd) + 1,2),' ','0')
				ENDIF
				SET KEY TO
				SET ORDER TO &ltag
				GO top
				SCAN
					IF RECNO()=lrec
						Exit
					ENDIF
				ENDSCAN
				This.Detalle_factura.Column18.text1.Value =  lsec
			    This.Detalle_factura.Column18.text1.Refresh() 

			ENDIF
			 
		ENDIF
		SELECT (lcarea)
	ENDPROC


	PROCEDURE elimina_codigos_distintos
		SELECT (This.Datos_Detalle.Area)  
		ltag=TAG()
		INDEX ON prd_codprd+dcd_secdcd TAG P
		SELECT (This.Datos_Descuento_Detalle.Area) 
		SET KEY TO
		SET FILTER TO 
		GO TOP
		DELETE FOR !SEEK(CUENTAS_COBDETALLE_DDD.prd_codprd+CUENTAS_COBDETALLE_DDD.dcd_secdcd,This.Datos_Detalle.Area,"P")
		SELECT (This.Datos_Detalle.Area)
		SET ORDER TO &ltag
	ENDPROC


	PROCEDURE verifica_solicitud
		PRIVATE lok,lcarea,lexe
		lok=.F.

		lcarea=SELECT()

		lexe="Select count(*) as canti "+;
			 "From dbo.SOLICITUD_FACTURAATENDIDA_SFA "+;
			 "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
			 "and   suc_codsuc=?ThisForm.Entorno.CodigoSuc "+;
			 "and   cte_codcte=?This.frm_facturas.cte_codcte.Value "
			 
		IF SQLEXEC(Ocnx.Conexion,lexe,"Tfak")>0
		   IF  Tfak.canti>0
		       lok=.T.
		   ENDIF
		ELSE
		   WAIT WINDOW "Error: "+MESSAGE() NoWait
		ENDIF

		IF USED("Tfak")
		   USE IN "Tfak"
		ENDIF

		SELECT (lcarea)
		RETURN lok
	ENDPROC


	PROCEDURE Init
		LPARAMETERS lp_codcte

		IF PARAMETERS()=1
		   This.CaBECERA.IndicadorActivado =.F. 
		   This.Cursor.IndicadorActivado=.F.  
		   This.Cursor.Nombretabla=""  
		   This.Cursor.SqlSelect=""  
		   This.Cursor.SqlWhere="cte_codcte='"+lp_codcte+"' " 
		   This.Cabecera.Init()  
		ENDIF


		DODEFAULT()
	ENDPROC


	PROCEDURE Activate
		DODEFAULT()
		This.Resize()
	ENDPROC


	PROCEDURE Resize
		DODEFAULT()
		This.Frm_facturas.Left=0
		This.Frm_facturas.Top=0
		This.Detalle_Factura.Left=0
		This.Detalle_Factura.Width=This.Width-2
		This.Frm_facturas.Width=This.Detalle_Factura.Width     
		This.Ctn_total.Width=This.Width-2
		This.Ctn_Total.Top=This.Height-This.StatusBar.Height-This.Ctn_total.Height   
		ltama=This.Height-This.StatusBar.Height-This.Ctn_total.Height-This.Frm_facturas.Height  - 5  
		ltama=IIF(ltama<0,20,ltama)
		This.Detalle_Factura.Height=ltama
	ENDPROC


	PROCEDURE nuevo
		DODEFAULT()
		This.Frm_facturas.ori_codori.Value='050'  
		This.Frm_facturas.ctn_tie_codtie.tie_codtie.Value = This.Entorno.Tienda     
		This.Frm_facturas.dpc_indcal.Value='1'  
		This.Frm_facturas.cte_fecemi.Value=DATE()  
		This.Frm_facturas.dpc_indexp.Value=0
		This.Frm_facturas.dpc_indexp.Click() 
		This.Frm_facturas.dpc_INDTEX.Value=0
		This.Frm_facturas.dpc_INDTEX.Click() 
		This.Frm_facturas.cte_tasigv.Value=ThisForm.Entorno.tasa_igv_fecha(This.Frm_facturas.cte_fecemi.Value)  
		This.Frm_facturas.CIA_CODCIA.Value=ThisForm.Entorno.CodigoCia
		This.Frm_facturas.SUC_CODSUC.Value=ThisForm.Entorno.CodigoSuc        
		This.Frm_facturas.tmo_codtmo.Value='DO'  
		This.Frm_facturas.Ctn_tdo_codtdo.tdo_codtdo.SetFocus()
		This.Frm_facturas.Ctn_tdo_codtdo.Refresh() 
		   
	ENDPROC


	PROCEDURE cargatablas
		This.Datos_Detalle.Selecciona()  
		This.Datos_Cuota.Selecciona()  
		This.Frm_facturas.ctn_lde_codlde.Refresh 
		This.Frm_facturas.cte_tasigv.Refresh()   
		This.Frm_facturas.cte_tipcam.Refresh()    
		&&This.Datos_Descuento.Selecciona()  
		This.Datos_Descuento_Detalle.Selecciona()  
		This.Datos_Solicitud_Atendida.Selecciona()  
		This.Datos_Kardex.Selecciona() 
		This.Detalle_factura.AfterRowColChange() 
	ENDPROC


	PROCEDURE busca
		This.Buscarindice[2,1]="aux_nomaux+tdo_codtdo+cte_numdoc"
		This.Buscarindice[2,2]="CLIENTE"

		This.DefineSqlSelectBusqueda="Select a.tdo_codtdo,a.cte_numdoc,a.cte_fecemi,a.aux_codaux,b.aux_nomaux,"+;
		                             "a.cia_codcia,a.suc_codsuc,a.cte_codcte "+;
		                             "From dbo.cuenta_corriente_cte a "+;
		                             "Inner Join dbo.auxiliares_aux b "+; 
		                             "On (b.cia_codcia=a.cia_codcia "+; 
		                             "and b.aux_codaux=a.aux_codaux) "+; 
		                             "Where a.cia_codcia=?ThisForm.Entorno.CodigoCia "+; 
		                             "and   a.suc_codsuc=?ThisForm.Entorno.CodigoSuc "+; 
		                             "and   "+This.Cursor.SqlWhere 
		DODEFAULT()
	ENDPROC


	PROCEDURE antes_de_grabar
		IF This.Entorno.Periodo<This.Entorno.Periodoreal  
		   MESSAGEBOX("PERIODO "+TRANSFORM(This.Entorno.Periodo,"@R 9999-99")+" YA ESTA CERRADO NO SE PUEDE INGRESAR NI MODIFICAR",64,This.Caption)
		   RETURN .F.
		ENDIF
		 
		This.Frm_facturas.cte_glocte.Value=Ocnx.Usuario+" "+TTOC(DATETIME())
		This.frm_facturas.ctn_aux_codaux.aux_codaux.SetFocus()  

		SELECT (This.Datos_Detalle.Area) 
		GO top
		DELETE For EMPTY(NVL(prd_codprd,'')) AND EMPTY(NVL(dcd_glodcd,''))
		This.Datos_Detalle.Renumera()  
		GO top
		SCAN
			This.Detalle_Factura.AfterRowColChange() 
			SELECT (This.Datos_Detalle.Area) 
		ENDSCAN

		This.Elimina_codigos_distintos() 


		IF Left(DTOS(This.Frm_facturas.Cte_fecemi.Value),6)<>This.Entorno.Periodo
		   MESSAGEBOX("LA FECHA NO PERTENECE AL PERIODO")
		   RETURN .F.
		EndIf    

		IF This.Estado<>1
		  	IF LEFT(DTOS(This.Frm_facturas.Cte_fecemi.Value),6)<>LEFT(This.Frm_facturas.Cte_codcte.Value,6)
			   MESSAGEBOX("DOCUMENTO YA ESTA GRABADO EN EL PERIODO: "+LEFT(This.Frm_facturas.Cte_codcte.Value,6)+CHR(13)+;
			              "ESTO NO SE PUEDE MODIFICAR",64,This.Caption)   
			   RETURN .F. 
			ENDIF
		ENDIF

		IF This.Frm_facturas.edo_codedo.Value='A' 
		   MESSAGEBOX("DOCUMENTO YA ESTA ANULADO NO SE PUEDE MODIFICAR",64,This.Caption)
		   RETURN .F.
		ENDIF

		IF This.Frm_facturas.ctn_tdo_codtdo.tdo_codtdo.Value$'NCR,NDB'
		   IF EMPTY(NVL(This.Frm_facturas.Cte_numref.Value,''))
		      MESSAGEBOX("TIENE QUE INGRESAR EL DOCUMENTO DE REFERENCIA",64,This.Caption )
		      RETURN .F.      
		   ENDIF
		ENDIF
		     
		IF EMPTY(NVL(This.Frm_facturas.ctn_aux_codaux.aux_codaux.Value,''))     
		   MESSAGEBOX("TIENE QUE INGRESAR EL CLIENTE",64,This.Caption )
		   RETURN .F.
		ENDIF
		IF EMPTY(NVL(This.Frm_facturas.CTN_TCC_CODTRA.Tcc_codtra.VALUE,''))     
		   MESSAGEBOX("TIENE QUE INGRESAR EL MOTIVO DEL DOCUMENTO",64,This.Caption )
		   RETURN .F.
		ENDIF
		IF EMPTY(NVL(This.Frm_facturas.CTN_cpa_codcpa.CPA_codcpa.Value,''))     
		   MESSAGEBOX("TIENE QUE INGRESAR LA CONDICION DE PAGO DEL DOCUMENTO",64,This.Caption )
		   RETURN .F.
		ENDIF
		IF EMPTY(NVL(This.frm_facturas.cte_glocte.Value ,''))     
		   MESSAGEBOX("INGRESE ALGUNA OBSERVACION CON RESPECTO A LA FACTURA",64,This.Caption )
		   RETURN .F.
		ENDIF

		*!*	lexe="Select cte_impdoc "+;
		*!*		 "From dbo.CUENTA_CORRIENTE_CTE "+;
		*!*		 "Where cia_codcia=?ThisForm.Entorno.CodigoCia "+;
		*!*		 "and   suc_codsuc=?ThisForm.Entorno.CodigoSuc "+;
		*!*		 "and   cte_codcte=?This.Frm_facturas.cte_codcte.Value "


		*!*	IF 
		   

		SELECT (This.CABECERA.Area) 
		IF NVL(cte_impabo,0)<>0
		   MESSAGEBOX("DOCUMENTO YA NO SE PUEDE MODIFICAR POR QUE YA TIENE ABONOS",64,This.Caption) 
		   *RETURN .F. 
		ENDIF


		     
	ENDPROC


	PROCEDURE grabacionsecuencia
		IF DODEFAULT()
			lexec="Exec dbo.PA_GENERA_ASIENTO_VENTAS "+;
			      "@codcia=?ThisForm.Entorno.CodigoCia,"+;
			      "@codsuc=?ThisForm.Entorno.CodigoSuc,"+;
			      "@codtdo=?ThisForm.Frm_facturas.ctn_tdo_codtdo.tdo_codtdo.Value,"+;
			      "@numdoc=?ThisForm.Frm_facturas.cte_numdoc.Value,"+;
			      "@indmot='2'"
			      
			IF SQLEXEC(Ocnx.Conexion,lexec)<0
			   Ocnx.ErrorMensaje=MESSAGE()+CHR(13)+CHR(13)+lexec
			   RETURN .F.
			ENDIF
		ELSE
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE entorno.Init
		DODEFAULT()

		ThisForm.No_pide_serie = This.Parametros[1,1] 
	ENDPROC


	PROCEDURE CABECERA.defineselect
		This.SqlSelect="Select "+;
		               "a.CIA_CODCIA,a.SUC_CODSUC,a.CTE_CODCTE,a.AUX_CODAUX,"+;
					   "a.AUX_CODDOC,a.TDO_CODTDO,a.CTE_NUMDOC,a.CTE_GLOCTE,"+;
					   "a.CTE_FECEMI,a.CTE_FECVEN,a.TMO_CODTMO,a.CTE_IMPDOC,"+;
					   "a.CTE_IMPIGV,a.CTE_TASIGV,a.CTE_IMPINA,a.CTE_IMPAFE,"+;
					   "a.CTE_TIPCAM,a.TCC_CODTRA,a.CPA_CODCPA,a.TDO_DOCREF,"+;
					   "a.CTE_NUMREF,b.VDE_CODVDE,b.LDE_CODLDE,b.DPC_IMPDES,"+;
					   "b.DPC_SITDPC,b.DPC_ORDCOM,b.DPC_INDTEX,b.DPC_IMPSEG,"+;
					   "b.DPC_IMPFLE,b.DPC_INDEXP,b.ZVE_CODZVE,b.EDO_CODEDO,"+;
					   "a.ori_codori,b.cco_codcco,b.dpc_indcal,b.DPC_IMPSEG,"+;
					   "b.DPC_IMPFLE,(a.CTE_IMPINA+a.CTE_IMPAFE) as 'cte_valvta',"+;
					   "c.cte_fecemi as 'cte_fecref',b.tlp_codtlp,b.lpc_codlpc,b.dpc_indtca,"+;
					   "b.dpc_numcuo,b.egv_numegv,a.cte_impabo,b.dpc_impbru,b.tie_codtie "+;
					   "From dbo.cuenta_corriente_cte a "+;
					   "Inner Join dbo.CUENTAS_COBRAR_DPC b "+;
					   "On (b.cia_codcia=a.cia_codcia "+;
					   "and b.suc_codsuc=a.suc_codsuc "+;
					   "and b.cte_codcte=a.cte_codcte) "+;
					   "left Outer Join dbo.cuenta_corriente_cte c "+;
					   "On (c.cia_codcia=a.cia_codcia "+;
					   "and c.tdo_codtdo=a.tdo_docref "+;
					   "and c.cte_numdoc=a.cte_numref "+;
					   "and c.CTE_CODPAG='C') "+;
					   "Where a.cia_codcia=?tcur.cia_codcia "+;
					   "and   a.suc_codsuc=?tcur.suc_codsuc "+;
					   "and   a.cte_codcte=?tcur.cte_codcte "
					   
		This.SqlInsert="Exec dbo.PA_GRABA_FACTURAS "+;
		               "@codcia=?cuenta_corriente_cte.cia_codcia,"+;
		               "@codsuc=?cuenta_corriente_cte.suc_codsuc,"+;
		               "@codori=?cuenta_corriente_cte.ori_codori,"+;
		               "@codtdo=?cuenta_corriente_cte.tdo_codtdo,"+;
		               "@numdoc=?cuenta_corriente_cte.cte_numdoc,"+;
		               "@fecemi=?cuenta_corriente_cte.cte_fecemi,"+;
		               "@prefac=Null,"+;
		               "@codaux=?cuenta_corriente_cte.aux_codaux,"+;
		               "@ordcom=?cuenta_corriente_cte.dpc_ordcom,"+;
		               "@codcpa=?cuenta_corriente_cte.cpa_codcpa,"+; 
		               "@codtra=?cuenta_corriente_cte.tcc_codtra,"+;
		               "@tasigv=?cuenta_corriente_cte.cte_tasigv,"+; 
		               "@tipcam=?cuenta_corriente_cte.cte_tipcam,"+;
		               "@docref=?cuenta_corriente_cte.tdo_docref,"+; 
		               "@numref=?cuenta_corriente_cte.cte_numref,"+;
		               "@codtmo=?cuenta_corriente_cte.tmo_codtmo,"+; 
		               "@glocte=?cuenta_corriente_cte.cte_glocte,"+;
		               "@codedo=?cuenta_corriente_cte.edo_codedo,"+; 
		               "@fecven=?cuenta_corriente_cte.cte_fecven,"+;
		               "@impbru=?cuenta_corriente_cte.dpc_impbru,"+; 
		               "@valvta=?cuenta_corriente_cte.cte_valvta,"+; 
		               "@impigv=?cuenta_corriente_cte.cte_impigv,"+;
		               "@impdoc=?cuenta_corriente_cte.cte_impdoc,"+; 
		               "@codcco=?cuenta_corriente_cte.cco_codcco,"+;
		               "@codtlp=?cuenta_corriente_cte.tlp_codtlp,"+;
		               "@codlpc=?cuenta_corriente_cte.lpc_codlpc,"+;
		               "@indcal=?cuenta_corriente_cte.dpc_indcal,"+;
		               "@indtca=?cuenta_corriente_cte.dpc_indtca,"+;
		               "@indtex=?cuenta_corriente_cte.dpc_indtex,"+;
		               "@indexp=?cuenta_corriente_cte.dpc_indexp,"+;
		               "@codzve=?cuenta_corriente_cte.zve_codzve,"+;
		               "@impseg=?cuenta_corriente_cte.dpc_impseg,"+;
					   "@impfle=?cuenta_corriente_cte.dpc_impfle,"+; 
					   "@impdes=?cuenta_corriente_cte.dpc_impdes,"+; 
					   "@coddoc=?ThisForm.Entorno.RucCia,"+;
					   "@codlde=?cuenta_corriente_cte.lde_codlde,"+;
					   "@numcuo=?cuenta_corriente_cte.dpc_numcuo,"+;
					   "@numegg=?cuenta_corriente_cte.egv_numegv,"+;
					   "@codvde=?cuenta_corriente_cte.vde_codvde,"+;
					   "@codtie=?cuenta_corriente_cte.tie_codtie,"+;
		               "@codcte=?@ThisForm.Frm_facturas.cte_codcte.Value "		   

		This.SqlUpdate=This.SqlInsert                 
	ENDPROC


	PROCEDURE CABECERA.antes_de_grabar
		SELECT (This.Area) 
		REPLACE egv_numegv WITH IIF(EMPTY(NVL(egv_numegv,'')),Null,egv_numegv)
		IF ThisForm.Estado=1 
		    IF ThisForm.Ctn_total.Chk_Correlativo.Value=1 
				ThisForm.Frm_facturas.Cte_numdoc.Value=ThisForm.Frm_facturas.Correlativo(ThisForm.FRm_facturas.Sfa_numsfa.Value) 
				ThisForm.Frm_facturas.Cte_numdoc.Refresh()
		    ENDIF
			SELECT (ThisForm.Cursor.Area) 
			REPLACE tdo_codtdo WITH ThisForm.Frm_facturas.Ctn_tdo_codtdo.tdo_codtdo.Value ,;
			        cte_numdoc WITH ThisForm.Frm_facturas.Cte_numdoc.Value
			 
		ENDIF 
		IF ThisForm.Estado=6
		  
		*!*	   PRIVATE lsen
		*!*	   lsen="Exec dbo.PA_ANULA_FACTURA_GUIA "+;
		*!*	   	    "@codcia=?ThisForm.Entorno.COdigoCia,"+;
		*!*	   	    "@codsuc=?ThisForm.Entorno.COdigoSuc,"+;
		*!*	   	    "@codcte=?cuenta_corriente_cte.cte_codcte"
		*!*	   	    
		*!*	   IF SQLEXEC(Ocnx.Conexion,lsen)<0
		*!*	      Ocnx.ErrorMensaje=MESSAGE()+CHR(13)+CHR(13)+lsen
		*!*	      RETURN .F. 
		*!*	   ENDIF


			&&& Si fuese Consignación restaura la liquidación para poder facturarla &&&&
			PRIVATE lupx

			lupx="Update dbo.LIQUIDACION_CONSIGNACION_LCC Set "+;
				 "lcc_indest='1',"+;
				 "cte_codcte=Null "+;
				 "Where cia_codcia=?CUENTA_CORRIENTE_CTE.cia_codcia "+;
				 "and   suc_codsuc=?CUENTA_CORRIENTE_CTE.suc_codsuc "+;
				 "and   cte_codcte=?CUENTA_CORRIENTE_CTE.cte_codcte "
				 
		   IF SQLEXEC(Ocnx.Conexion,lupx)<0
		      Ocnx.ErrorMensaje=MESSAGE()+CHR(13)+CHR(13)+lupx
		      RETURN .F. 
		   ENDIF
				 
				 
		   
		   SELECT (This.Area)
		   REPLACE edo_codedo WITH 'A' 
		   ThisForm.Frm_facturas.cte_glocte.Value='ANULADO X '+Ocnx.usuario+' EL '+TTOC(DATETIME())
		ENDIF
	ENDPROC


	PROCEDURE Cursor.antes_armar_estructura
		DODEFAULT()
		This.Campos=This.Campos+",tdo_codtdo,cte_numdoc " 
		ltdoser=""
		IF !ThisForm.No_pide_serie
			DO FORM Forms\frm_pide_serie_fac WITH ;
			ThisForm.Indicador_facbve_ncrndb  TO ltdoser
			This.SqlWhere= This.SqlWhere+" and tdo_codtdo='"+LEFT(ltdoser,3)+"' and LEFT(cte_numdoc,3)='"+RIGHT(ltdoser,3)+"' "
		ENDIF
	ENDPROC


	PROCEDURE Cursor.Init
		dODEFAULT()
	ENDPROC


	PROCEDURE frm_facturas.cte_numdoc.Refresh
		DODEFAULT()

		IF ThisForm.Ctn_Total.Chk_Correlativo.Value=0 
		   This.Enabled=.T.
		ELSE
		   IF ThisForm.Estado=1
		      This.Enabled=.F.
		   ELSE
		      This.Enabled=.T.
		   ENDIF
		ENDIF


		   
	ENDPROC


	PROCEDURE frm_facturas.ctn_cpa_codcpa.txt_descri.Refresh
		DODEFAULT()
		   ldias=""
		   SELECT (ThisForm.Datos_Cuota.Area)  
		   GO top
		   SCAN
			   ldias=ldias+ALLTRIM(STR(ccu_candia))+","
		   ENDSCAN
		   IF !EMPTY(ldias)
		       ldias=LEFT(ldias,LEN(ldias)-1)+" dias "
		   ENDIF
		   This.Value=ALLTRIM(This.Value)+" "+ldias
	ENDPROC


	PROCEDURE frm_facturas.dpc_numcuo.Valid
		IF This.Value<>THis.Valor_anterior
		   This.Parent.BtnCuota.Click()  
		EndIf 
	ENDPROC


	PROCEDURE frm_facturas.BtnCuota.Click
		ThisForm.Copia_Entorno()
		OEntorno.Titulo="Canje con Lentras/Cuotas"  
		SELECT (ThisForm.Datos_Cuota.Area) 

		COUNT TO lxc

		ldif=lxc-This.Parent.dpc_numcuo.Value  
		IF ldif<>0
		   IF ldif<0
		      FOR lf=1 TO ABS(ldif)
			   	  SELECT (ThisForm.Datos_Cuota.Area)
			   	  APPEND BLANK
			   	  REPLACE cia_codcia WITH ThisForm.Entorno.CodigoCia ,;
			   	          suc_codsuc WITH ThisForm.Entorno.CodigoSuc ,;     
			   	          ccu_indest WITH '1'
			  ENDFOR
			ELSE
		       FOR lf=1 TO ABS(ldif)
		 	   	   SELECT (ThisForm.Datos_Cuota.Area)
		 	   	   GO BOTTOM  
			   	   DELETE 
			   ENDFOR
			ENDIF
		ENDIF
		GO TOP IN (ThisForm.Datos_Cuota.Area)
		DO FORM CURDIR()+"Forms\frm_cuota_factu" WITH ThisForm.Datos_Cuota 
		This.Parent.Ctn_cpa_codcpa.Refresh 
	ENDPROC


	PROCEDURE frm_facturas.sfa_numsfa.Refresh
		DODEFAULT()

		IF ThisForm.Estado<>1
		   This.Value=LEFT(This.Parent.cte_numdoc.Value,3)   
		ENDIF
	ENDPROC


	PROCEDURE detalle_factura.When
		DODEFAULT()
		This.Column3.Enabled = IIF(ThisForm.Frm_facturas.dpc_INDTEX.Value=0,.F.,.T.) 
		This.Column5.Enabled = IIF(ThisForm.Frm_facturas.dpc_indexp.Value=0,.F.,.T.)  
		This.Column6.Enabled = IIF(ThisForm.Frm_facturas.dpc_indcal.Value='0',.T.,.F.)  
		This.Column7.Enabled = IIF(ThisForm.Frm_facturas.dpc_indcal.Value<>'0',.T.,.F.)  
		This.Column16.ReadOnly = IIF(ThisForm.Frm_facturas.dpc_indcal.Value='2',.F.,.T.)  
	ENDPROC


	PROCEDURE detalle_factura.calcula
		PRIVATE larea
		larea=SELECT()
		SELECT (ThisForm.Datos_Detalle.Area)

		SUM dcd_impbru,dcd_impde1,dcd_impde2,dcd_valvta,dcd_impigv,dcd_imptot ;
		TO limpbru,limpde1,limpde2,lvalvta,limpigv,limptot


		IF ThisForm.Frm_facturas.Dpc_indcal.Value=='0'
		   lvalvta=limpbru-limpde1-limpde2
		   limpigv=ROUND(lvalvta*(ThisForm.Frm_facturas.cte_tasigv.Value/100),2)
		   limptot=lvalvta + limpigv
		ELSE
		   lvalvta=ROUND(limptot/(1+(ThisForm.Frm_facturas.cte_tasigv.Value/100)),2)
		   limpigv=limptot - lvalvta 
		   limptot=lvalvta + limpigv
		   limpde1=limpbru - lvalvta 
		ENDIF


		&&susp
		*!*	IF ThisForm.Frm_facturas.Dpc_indcal.Value > '0'
		*!*	   lvalvta=ROUND(limptot/(1+(NVL(ThisForm.Frm_facturas.cte_tasigv.Value,0)/100)),2)
		*!*	   limpigv=limptot-lvalvta
		*!*	   limpbru=lvalvta+(limpde1+limpde2)
		*!*	ENDIF
		 

		SELECT (ThisForm.CABECERA.Area)
		REPLACE dpc_impbru WITH limpbru ,;
		 	    dpc_impdes WITH limpde1+limpde2 ,;
		   		cte_valvta WITH lvalvta ,;
		 	    cte_impigv WITH limpigv ,;
		 	    cte_impdoc WITH limptot

		*!*	IF USED(ThisForm.Datos_Descuento.Alias) 
		*!*		IF !EOF()
		*!*			ldrecno=RECNO()
		*!*		ENDIF
		*!*
		*!*		SELECT (ThisForm.Datos_Descuento.Area) 
		*!*		ltag=TAG() 
		*!*		INDEX ON dco_coddco TAG "des"
		*!*		SET ORDER TO  &ltag
		*!*		REPLACE ccd_impdes WITH 0 all
		*!*		GO top
		*!*	ENDIF


		*!*	IF USED(ThisForm.Datos_Descuento_Detalle.Alias) 
		*!*		SELECT (ThisForm.Datos_Descuento_Detalle.Area) 
		*!*		SET KEY TO 
		*!*		GO TOP 
		*!*		SCAN
		*!*			lcoddco=dco_coddco
		*!*			limpdes=ddd_impdes
		*!*			SELECT (ThisForm.Datos_Descuento.Area) 
		*!*			IF SEEK(lcoddco,ThisForm.Datos_Descuento.Area,"des")
		*!*				ThisForm.Frm_facturas.Detalle_Descuento.Column4.Text1.Value =  ccd_impdes + limpdes  
		*!*			ENDIF
		*!*			SELECT (ThisForm.Datos_Descuento_Detalle.Area) 
		*!*		ENDSCAN
		*!*	   && ThisForm.Detalle_Dscto.Refresh() 

		*!*	ENDIF

		*!*	IF USED(ThisForm.Datos_Descuento.Alias)
		*!*		SELECT (ThisForm.Datos_Descuento.Alias)
		*!*		GO top
		*!*		ldesacu=0
		*!*		SCAN
		*!*			IF dco_inddco=='2'
		*!*				ThisForm.Frm_facturas.Detalle_Descuento.Column3.Text1.Value =  IIF((limpbru-ldesacu)<>0,ROUND(ccd_impdes*100/(limpbru-ldesacu),2),0)  
		*!*				&&ThisForm.Detalle_Dscto.Column3.Text1.Refresh() 
		*!*			ENDIF
		*!*
		*!*			ldesacu=ldesacu+ccd_impdes
		*!*			SELECT (ThisForm.Datos_Descuento.Alias)
		*!*		ENDSCAN
		*!*
		*!*		GO top
		*!*		IF !EOF()
		*!*			SCAN
		*!*				IF RECNO()=ldrecno
		*!*					Exit
		*!*				ENDIF
		*!*				SELECT (ThisForm.Datos_Descuento.Area) 
		*!*			ENDSCAN
		*!*		ENDIF

		*!*
		*!*	ENDIF


		ThisForm.Ctn_Total.Refresh()  	    
		SELECT (larea)
	ENDPROC


	PROCEDURE detalle_factura.calculaitem
		PRIVATE ldrecno,ltag,lconti,lpordes,lcoddco,lnumdde,linddco

		STORE 0 TO lpreuni,lpruigv,limpbru,limpde1,limpde2,lvalvta,limpigv,limptot

		ltasigv=NVL(ThisForm.Frm_facturas.cte_tasigv.Value,0)
		&&SUSP

		&&& Verifica Descuentos que Existen &&&&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		*!*	SELECT (ThisForm.Datos_Descuento.Area) 
		*!*	ldrecno=RECNO()
		*!*	ltag=TAG() 
		*!*	INDEX ON dco_coddco TAG "D"
		*!*	SELECT (ThisForm.Datos_Descuento_Detalle.Area) 
		*!*	SET KEY TO  CUENTAS_COBRAR_DCD.prd_codprd+CUENTAS_COBRAR_DCD.dcd_secdcd
		*!*	GO TOP
		*!*	DELETE FOR !SEEK(CUENTAS_COBDETALLE_DDD.dco_coddco,ThisForm.Datos_Descuento.Area,"D")  
		*!*	SET KEY TO 
		*!*	SELECT (ThisForm.Datos_Descuento.Area) 
		*!*	SET ORDER TO &ltag

		*!*	SELECT (ThisForm.Datos_Descuento.Area) 
		*!*	GO top
		*!*	IF !EOF()
		*!*		SCAN
		*!*			IF RECNO()=ldrecno
		*!*				Exit
		*!*			ENDIF
		*!*			SELECT (ThisForm.Datos_Descuento.Area) 
		*!*		ENDSCAN
		*!*	ENDIF
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		&&-- Actualiza Descuentos -- &&
		   &&--Aplicacion Descuento -- &&
		   
		*!*	SELECT (ThisForm.Datos_Descuento.Area) 
		*!*	GO top
		*!*	SCAN
		*!*		lcorccd=ccd_corccd
		*!*		lconti=.T.
		*!*		lpordes=ccd_pordes
		*!*	   	lcoddco=dco_coddco
		*!*	   	lnumdde=NVL(dde_numdde,'')
		*!*	   	linddco=dco_inddco
		*!*		IF  dco_inddco=='1'
		*!*			lconti=.T.
		*!*		ELSE
		*!*	   		lpordes=ThisForm.Ventas.descuento_producto_detalle(lcoddco,lnumdde,CUENTAS_COBRAR_DCD.prd_codprd)
		*!*			IF lpordes>0
		*!*			   lconti=.T.
		*!*			ELSE
		*!*	 		       lconti=.F.
		*!*			ENDIF
		*!*		EndIf
		*!*
		*!*		IF lconti
		*!*			SELECT (ThisForm.Datos_Descuento_Detalle.Area)  
		*!*			IF !SEEK(CUENTAS_COBRAR_DCD.prd_codprd+CUENTAS_COBRAR_DCD.dcd_secdcd+lcoddco,ThisForm.Datos_Descuento_Detalle.Area)
		*!*				APPEND BLANK
		*!*				REPLACE prd_codprd WITH CUENTAS_COBRAR_DCD.prd_codprd ,;
		*!*						dcd_secdcd WITH CUENTAS_COBRAR_DCD.dcd_secdcd ,;
		*!*						dco_coddco WITH lcoddco 
		*!*			ENDIF
		*!*			REPLACE ddd_pordes WITH IIF(ddd_pordes=0,lpordes,ddd_pordes) ,;
		*!*					ddd_corddd WITH lcorccd
		*!*		ENDIF
		*!*
		*!*		SELECT (ThisForm.Datos_Descuento.Area) 
		*!*	ENDSCAN
		&&--Fin -- &&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


		IF (ThisForm.Frm_facturas.Dpc_indcal.Value=='0') && Desde el Precio Unitario SIN IGV
		   lpreuni=CUENTAS_COBRAR_DCD.DCD_PREUNI
		   lpruigv=ROUND(lpreuni*(1+(ltasigv/100)),3)
		   limpbru=ROUND(lpreuni*CUENTAS_COBRAR_DCD.DCD_CANDCD,2)
		   
		   &&&&&&&&&&&&&
		   limpdes=0
		   SELECT (ThisForm.Datos_Descuento_Detalle.Area)
		   ltag=TAG()
		   INDEX ON prd_codprd+dcd_secdcd+ddd_corddd TAG "T"  
		   SET KEY TO  CUENTAS_COBRAR_DCD.prd_codprd+CUENTAS_COBRAR_DCD.dcd_secdcd
		   GO top
		   ldesdes=""  
		   SCAN
		   	   lpordes=ddd_pordes
		   	   REPLACE ddd_impdes WITH ROUND((limpbru-limpdes)*ddd_pordes/100,2)  
		   	   limpdes=limpdes+ddd_impdes
		   	   ldesdes=ldesdes+ALLTRIM(TRANSFORM(ddd_pordes,"99.99%"))+" + "  
			   SELECT (ThisForm.Datos_Descuento_Detalle.Area)  
		   ENDSCAN
		   
		   IF LEN(ldesdes)>0
			   ldesdes=LEFT(ldesdes,LEN(ldesdes)-3)
		   ENDIF
		 	  
		   GO top
		   SUM ddd_impdes + ddd_impaju TO  limpde1  
		   SET ORDER TO &ltag

		   SELECT (ThisForm.Datos_Detalle.Area) 
		   
		   REPLACE dcd_porde1 WITH IIF(limpbru<>0,ROUND(limpde1*100/limpbru,2),0)
		   This.Column12.Text1.Value = ldesdes
		   This.Column12.Text1.Refresh()  
		   &&&&&&&&&&&&&
		   
		   
		   &&limpde1=ROUND(limpbru*CUENTAS_COBRAR_DCD.DCD_PORDE1/100,2)
		   &&limpde2=ROUND((limpbru-limpde1)*CUENTAS_COBRAR_DCD.DCD_PORDE2/100,2)
		   lvalvta=limpbru-limpde1-limpde2
		   limpigv=ROUND(lvalvta*(ltasigv/100),2)
		   limptot=lvalvta+limpigv

		ENDIF
		IF ThisForm.Frm_facturas.Dpc_indcal.Value='1' && Desde el Precio Unitario INC IGV

		   lpruigv=CUENTAS_COBRAR_DCD.dcd_pruigv
		   lpreuni=ROUND(CUENTAS_COBRAR_DCD.dcd_pruigv/(1+(ltasigv/100)),2)
		   limpbru=ROUND(lpreuni*CUENTAS_COBRAR_DCD.DCD_CANDCD,2)
		   
		   limpdes=0
		   SELECT (ThisForm.Datos_Descuento_Detalle.Area)  
		   ltag=TAG()
		   INDEX ON prd_codprd+dcd_secdcd+ddd_corddd TAG "T" 
		   SET KEY TO CUENTAS_COBRAR_DCD.prd_codprd+CUENTAS_COBRAR_DCD.dcd_secdcd
		   GO top
		   ldesdes=""  
		   SCAN
		   	   lpordes=ddd_pordes
		   	   REPLACE ddd_impdes WITH ROUND((limpbru-limpdes)*ddd_pordes/100,2)  
		   	   limpdes=limpdes+ddd_impdes
		   	   ldesdes=ldesdes+ALLTRIM(TRANSFORM(ddd_pordes,"99.99%"))+" + "  
			   SELECT (ThisForm.Datos_Descuento_Detalle.Area)  
		   ENDSCAN
		   IF LEN(ldesdes)>0
			   ldesdes=LEFT(ldesdes,LEN(ldesdes)-3)
		   ENDIF
		   
		   GO top
		   SUM ddd_impdes + ddd_impaju TO  limpde1  
		   SET ORDER TO &ltag
		   SELECT (ThisForm.Datos_Detalle.Area) 
		   
		   REPLACE dcd_porde1 WITH IIF(limpbru<>0,ROUND(limpde1*100/limpbru,2),0)
		   This.Column12.Text1.Value = ldesdes
		   This.Column12.Text1.Refresh()  
		   
		   &&------------------------- &&
		   lvalvta=limpbru-limpde1
		   limpigv=ROUND(lvalvta*(ltasigv/100),2)
		   limptot=lvalvta+limpigv

		ENDIF
		IF ThisForm.Frm_facturas.Dpc_indcal.Value='2' && Desde el Importe Total
		  
		   lpruigv=ROUND(CUENTAS_COBRAR_DCD.DCD_IMPTOT/CUENTAS_COBRAR_DCD.DCD_CANDCD,3)
		   lpreuni=ROUND(lpruigv/(1+(ltasigv/100)),4)
		   
		   limptot=CUENTAS_COBRAR_DCD.DCD_IMPTOT
		   limpde1=0
		   limpde2=0
		   This.Column8.Text1.Value=0
		   This.Column10.Text1.Value=0
		   limpbru=ROUND(lpreuni*CUENTAS_COBRAR_DCD.DCD_CANDCD,2)
		   lvalvta=ROUND(limptot/(1+(ltasigv/100)),2)
		   limpigv=Round(limptot-lvalvta,2)

		  
		   
		ENDIF
		This.Column6.Text1.Value = lpreuni
		This.Column7.Text1.Value = lpruigv
		This.Column9.Text1.Value = limpbru
		This.Column11.Text1.Value = limpde1
		&&This.Column13.Text1.Value = limpde2
		This.Column14.Text1.Value = lvalvta
		This.Column15.Text1.Value = limpigv
		This.Column16.Text1.Value = limptot


		 
	ENDPROC


	PROCEDURE detalle_factura.Column2.prd_codprd.When
		DODEFAULT()

		This.Parent.ReadOnly=ThisForm.Verifica_factura_kardex()  
	ENDPROC


	PROCEDURE detalle_factura.Column2.prd_codprd.valid_campos
		DODEFAULT()
		lcoddcm=dcm_coddcm

		IF ALLTRIM(This.Value) <> ALLTRIM(This.Valor_Anterior)
			ThisForm.dcm_coddcm.Value = lcoddcm 
		   ThisForm.Selecciona_precio() 
		EndIf
	ENDPROC


	PROCEDURE detalle_factura.Column2.prd_codprd.ayudapropiedades
		DODEFAULT()
		IF ThisForm.Frm_facturas.dpc_indtEX.Value=1
		   This.AyudaWhere=This.AyudaWhere+" and tin_codtin='99' " 
		ENDIF
		  
	ENDPROC


	PROCEDURE detalle_factura.Column2.prd_codprd.GotFocus
		DODEFAULT()

		this.valor_anterior = this.Value
	ENDPROC


	PROCEDURE detalle_factura.Column6.Text1.When
		DODEFAULT()

		This.Parent.ReadOnly=ThisForm.Verifica_factura_kardex()  
	ENDPROC


	PROCEDURE detalle_factura.Column7.Text1.When
		DODEFAULT()

		This.Parent.ReadOnly=ThisForm.Verifica_factura_kardex()  
	ENDPROC


	PROCEDURE detalle_factura.Column8.Text1.When
		DODEFAULT()

		This.Parent.ReadOnly=ThisForm.Verifica_factura_kardex()  
	ENDPROC


	PROCEDURE detalle_factura.Column11.Text1.DblClick
		SELECT (ThisForm.Datos_Detalle.Area)  
		lckey=prd_codprd+dcd_secdcd
		DO FORM CURDIR()+"Forms\frm_factura_descuento" WITH lckey,ThisForm.Datos_Descuento_Detalle,;
				dcd_cordcd,prd_codprd,dcd_secdcd,prd_desesp,dcd_candcd,dcm_coddcm

		&&lckey,lodata,lp_corppd,lp_codprd,lp_secppd,lp_desesp,lp_cansol ,lp_coddcm
	ENDPROC


	PROCEDURE chk_correlativo.Refresh
		This.Enabled=IIF(ThisForm.Estado=1,.T.,.F.)
	ENDPROC


	PROCEDURE chk_correlativo.Click
		ThisForm.frm_facturas.cte_numdoc.Refresh 
	ENDPROC


	PROCEDURE texto1.Refresh
		PRIVATE lsen
		ThisFOrm.Frm_facturas.Cte_codcte.Refresh 
		lsen="Select dbo.fx_guias_de_facturas(?ThisForm.Entorno.CodigoCia,?ThisForm.Entorno.CodigoSuc,?ThisFOrm.Frm_facturas.Cte_codcte.Value) as datos"

		IF SQLEXEC(Ocnx.Conexion,lsen,"Tguias")<0
		   WAIT WINDOW MESSAGE() NowAit
		   RETURN
		ENDIF

		This.Value="Guias: "+Tguias.datos
	ENDPROC


	PROCEDURE texto2.Refresh
		PRIVATE lsen
		ThisFOrm.Frm_facturas.Cte_codcte.Refresh 
		lsen="Select dbo.fx_facturas_datos_pedidos(?ThisForm.Entorno.CodigoCia,?ThisForm.Entorno.CodigoSuc,?ThisFOrm.Frm_facturas.Cte_codcte.Value,1) as datos"

		IF SQLEXEC(Ocnx.Conexion,lsen,"Tpedidos")<0
		   WAIT WINDOW MESSAGE() NowAit
		   RETURN
		ENDIF

		This.Value="Pedido: "+Tpedidos.datos


		IF USED("Tpedidos")
		   USE IN "Tpedidos"
		ENDIF
	ENDPROC


	PROCEDURE texto3.Refresh
		PRIVATE lsen
		ThisFOrm.Frm_facturas.Cte_codcte.Refresh 
		lsen="Select dbo.fx_facturas_pto_partida(?ThisForm.Entorno.CodigoCia,?ThisForm.Entorno.CodigoSuc,?ThisFOrm.Frm_facturas.Cte_codcte.Value) as datos"

		IF SQLEXEC(Ocnx.Conexion,lsen,"Tpedidos")<0
		   WAIT WINDOW MESSAGE() NowAit
		   RETURN
		ENDIF

		This.Value="Pto.Partida: "+Tpedidos.datos


		IF USED("Tpedidos")
		   USE IN "Tpedidos"
		ENDIF
	ENDPROC


	PROCEDURE texto4.Refresh
		PRIVATE lsen
		ThisFOrm.Frm_facturas.Cte_codcte.Refresh 
		lsen="Select dbo.fx_facturas_datos_guia"+;
			 "(?ThisForm.Entorno.CodigoCia,?ThisForm.Entorno.CodigoSuc,?cuenta_corriente_cte.cte_codcte,1) as datos"

		IF SQLEXEC(Ocnx.Conexion,lsen,"Todccom")<0
		   WAIT WINDOW MESSAGE() NowAit
		   RETURN
		ENDIF

		This.Value="O/Compra: "+Todccom.datos


		IF USED("Todccom")
		   USE IN "Todccom"
		ENDIF
	ENDPROC


	PROCEDURE datos_detalle.defineselect
		This.SqlSelect="Select a.*,"+;
		               "(Case c.dpc_indtex When '1' then a.dcd_glodcd else b.prd_desesp end) as prd_desesp,"+;
		               "b.ume_codume "+;
		               "From dbo.CUENTAS_COBRAR_DCD a "+;
		               "Inner Join dbo.productos_prd b "+;
		               "On (b.cia_codcia=a.cia_codcia "+;
		               "and b.prd_codprd=a.prd_codprd) "+;
		               "Inner Join dbo.CUENTAS_COBRAR_DPC c "+;
		               "On (c.cia_codcia=a.cia_codcia "+;
		               "and c.suc_codsuc=a.suc_codsuc "+;
		               "and c.cte_codcte=a.cte_codcte) "+;
		               "Where a.cia_codcia=?tcur.cia_codcia "+;
		               "and   a.suc_codsuc=?tcur.suc_codsuc "+;
		               "and   a.cte_codcte=?tcur.cte_codcte "
	ENDPROC


	PROCEDURE datos_detalle.antes_de_grabar
		SELECT (This.Area)
		REPLACE cia_codcia WITH ThisForm.Entorno.CodigoCia ,;
		        suc_codsuc WITH ThisForm.Entorno.CodigoSuc ,;
		        cte_codcte WITH ThisForm.Frm_Facturas.Cte_codcte.Value,;
		        dcd_glodcd WITH IIF(ThisForm.Frm_facturas.dpc_indtEX.Value=1,prd_desesp,dcd_glodcd) ,;
		        dcd_indest WITH '1' ,;
		        dcd_codusu WITH Ocnx.usuario ,;
		        dcd_fecact WITH DATETIME()   ALL
		        
	ENDPROC


	PROCEDURE datos_detalle.nuevo
		IF ThisForm.Verifica_factura_kardex()  
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE AGREGAR ITEMS POR QUE HA SIDO GENERADA DESDE GUIAS DE REMISION",64,ThisForm.Caption)
		   RETURN 
		ENDIF
		IF ThisForm.Verifica_solicitud() 
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE AGREGAR ITEMS POR QUE HA SIDO GENERADA DESDE UNA SOLICITUD",64,ThisForm.Caption)
		   RETURN 
		ENDIF


		DODEFAULT()
	ENDPROC


	PROCEDURE datos_detalle.elimina
		IF ThisForm.Verifica_factura_kardex()  
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE ELIMINAR ITEMS POR QUE HA SIDO GENERADA DESDE GUIAS DE REMISION",64,ThisForm.Caption)
		   RETURN 
		ENDIF

		IF ThisForm.Verifica_solicitud() 
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE ELIMINAR ITEMS POR QUE HA SIDO GENERADA DESDE UNA SOLICITUD",64,ThisForm.Caption)
		   RETURN 
		ENDIF


		DODEFAULT()
	ENDPROC


	PROCEDURE datos_detalle.inserta
		IF ThisForm.Verifica_factura_kardex()  
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE INSERTAR ITEMS POR QUE HA SIDO GENERADA DESDE GUIAS DE REMISION",64,ThisForm.Caption)
		   RETURN 
		ENDIF
		IF ThisForm.Verifica_solicitud() 
		   MESSAGEBOX("A ESTA FACTURA NO SE LE PUEDE INSERTAR ITEMS POR QUE HA SIDO GENERADA DESDE UNA SOLICITUD",64,ThisForm.Caption)
		   RETURN 
		ENDIF


		DODEFAULT()
	ENDPROC


	PROCEDURE datos_cuota.antes_de_grabar
		SELECT (This.Area)
		REPLACE cia_codcia WITH ThisForm.Entorno.CodigoCia ,;
		        suc_codsuc WITH ThisForm.Entorno.CodigoSuc ,;
		        cte_codcte WITH ThisForm.Frm_Facturas.Cte_codcte.Value,;
		        ccu_indest WITH '1' ,;
		        ccu_codusu WITH Ocnx.usuario ,;
		        ccu_fecact WITH DATETIME()   ALL
	ENDPROC


	PROCEDURE datos_descuento_detalle.reemplazacampos
		SELECT (This.Area) 
		REPLACE cia_codcia WITH ThisForm.Entorno.Codigocia ,;
				suc_codsuc WITH ThisForm.Entorno.Codigosuc ,;
				cte_codcte WITH ThisForm.Frm_facturas.cte_codcte.Value   
	ENDPROC


	PROCEDURE datos_descuento_detalle.antes_de_grabar
		SELECT (This.Area)
		REPLACE cia_codcia WITH ThisForm.Entorno.CodigoCia ,;
		        suc_codsuc WITH ThisForm.Entorno.CodigoSuc ,;
		        cte_codcte WITH ThisForm.Frm_Facturas.Cte_codcte.Value ALL
	ENDPROC


	PROCEDURE datos_descuento_detalle.defineselect
		This.SqlSelect = "Select a.*,b.dco_desdco,b.dco_inddco "+;
						 "From dbo.CUENTAS_COBDETALLE_DDD a "+;
						 "Inner Join dbo.DESCUENTO_CONCEPTO_DCO b "+;
						 "On (b.cia_codcia=a.cia_codcia "+;
						 "and b.dco_coddco=a.dco_coddco) "+;
						 "Where a.cia_codcia=?Tcur.cia_codcia "+;
						 "and   a.suc_Codsuc=?Tcur.suc_codsuc "+;
						 "and   a.cte_codcte=?Tcur.cte_codcte "
	ENDPROC


	PROCEDURE datos_solicitud_atendida.antes_de_grabar
		SELECT (This.Area) 
		IF ThisForm.Estado = 6
			SET KEY TO 
			DELETE ALL

		ENDIF
	ENDPROC


	PROCEDURE datos_kardex.antes_de_grabar
		SELECT (This.Area) 
		IF ThisForm.Estado = 6
			SET KEY TO 
			DELETE ALL

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: formulario_factura
**************************************************
