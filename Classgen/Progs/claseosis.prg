**************************************************
*-- Class Library:  k:\aplvfp\libs\claseosis.vcx
**************************************************


**************************************************
*-- Class:        aplicacion (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/08/08 06:14:13 PM
*
DEFINE CLASS aplicacion AS custom


	Height = 15
	Width = 100
	*-- Gurda la ruta donde se encuentran los reportes
	rutareportes = ("")
	rutaosis = ("")
	*-- Se gurardan cadena de filtro desde la pantalla de filtro de reporte
	cadena_reporte = ("")
	osis_01 = ("")
	version = ("9.0.5  Ultima Revisión: EP 2008-05-08")
	Name = "aplicacion"

	*-- Si esta en .T. utiliza las tablas con los nombres cortos y la clase osisv1 ejem: COMP_CIA
	compatibilidad_osisv1 = .F.

	*-- Si es .T. indica que se conecta con ODBC
	conexion_odbc = .F.


	*-- Este Metodo incializa las Vairables
	PROCEDURE inicializa_variables
		PUBLIC ocnx,oentorno,otbr,oentornolocal,otbritem

		SET escape  OFF 
		 
		TRY 
		 		SET MESSAGE TO This.Version 
		 		? This.Version
				=SQLSETPROP(0,"DispLogin",3)  
				private linclud,lset,luse

				oentorno=CreateObject("entorno")
				*!*	If File("c:\path.osi")
				*!*		oentorno.ruta=alltrim(filetostr("c:\path.osi"))
				*!*		If Len(ALLTRIM(oentorno.ruta))>0 
				*!*			oentorno.ruta=LEFT(oentorno.ruta,LEN(oentorno.ruta)-2)
				*!*		EndIf
				*!*
				*!*	Else
				*!*		oentorno.ruta=CURDIR()
				*!*	EndIf

				PRIVATE xp,lr
				oentorno.ruta=curdir()
				*!*	endif

				xp=AT("OSISCLI9",UPPER(oentorno.ruta),1)
				IF xp<=0
					xp=AT("PRODUCTOS",UPPER(oentorno.ruta),1)
				ENDIF

				lr=SUBSTR(UPPER(oentorno.ruta),1,xp-1)

				oentorno.rutaosis=lr+"OSISV9\"


				oentornolocal=CREATEOBJECT("entorno")
				oentorno.rutareporte=oentorno.ruta+"reports\"

				if file(oentorno.ruta+"logocia.jpg")
					_screen.picture = oentorno.ruta+"logocia.jpg"
				endif


				lfffok=.t.

				private lsetdefa


					lsetdefa="Set default to '"+ALLTRIM(oentorno.ruta)+"' "
					&&MESSAGEBOX(lsetdefa)
					&lsetdefa
				*!*	endif
				oentorno.unidad_red	= sys(5)
				&&oentorno.rutaosis	= '\osisv9\'

				SET PATH to  oentorno.rutaosis+"libs" ADDITIVE 
				SET PATH to  oentorno.rutaosis+"FormsSYS" ADDITIVE 
				SET PATH TO  "reports" ADDITIVE  
				SET PATH TO  "forms" ADDITIVE 
				SET PATH TO  "libs" ADDITIVE 


		CATCH TO oErr
				MESSAGEBOX(oErr.message+CHR(13)+MESSAGE(1)+CHR(13)+;
			      			"Error:  "+ STR(oErr.ErrorNo) +CHR(13)+;
		      				"LineNo: "+ STR(oErr.LineNo) +CHR(13)+; 
		      				"Procedure: "+ oErr.Procedure +CHR(13)+;  
		      				"Details: "+ oErr.Details  +CHR(13)+;  
		      				"StackLevel: " + STR(oErr.StackLevel) +;  
		      				"LineContents: " + oErr.LineContents +;  
		      				"UserValue: " + oErr.UserValue,16,This.Name+"."+oErr.procedure) 
		ENDTRY

		if !lfffok
		   messagebox("no se encuentra el archivo de configuracion",16,"configuración")
		   return .f.
		endif

		this.ocultatoolbars()

		luse="use '"+oentorno.ruta+"sys_key' "
		&luse

		if !used("sys_key")
			messagebox("no se puede abrir el archivo de configuración",64,"error")
			return .f.
		endif

		TRY 
				private lcamarre,lcancampos
				lcancampos=afields(lcamarre,"sys_key")

				ocnx=createobject("conexion")
				this.osis_01  				= alltrim(sys_key.osis_01)
				if ascan(lcamarre,upper("tipo_bd"))>0
					ocnx.tipo_bd = sys_key.tipo_bd
				endif
				if ascan(lcamarre,upper("url"))>0
					ocnx.url = sys_key.url
				endif
				if ascan(lcamarre,upper("url_report"))>0
					ocnx.url_reportes = sys_key.url_report
				endif
				if ascan(lcamarre,upper("url_servic"))>0
					ocnx.url_servicios = sys_key.url_servic
				endif
				if ascan(lcamarre,upper("nombre"))>0
					oentorno.nombrecia	= sys_key.nombre
				endif
				if ascan(lcamarre,upper("moneda"))>0
					oentorno.moneda	= sys_key.moneda
				endif
				if ascan(lcamarre,upper("tasa_igv"))>0
					oentorno.tasa_igv	= sys_key.tasa_igv
				endif
				if ascan(lcamarre,upper("compatible"))>0
					oentorno.compatible_osisv1 	= sys_key.compatible
				endif
				if ascan(lcamarre,upper("con_rep"))>0
					oentorno.tipo_conexion_reporte = nvl(sys_key.con_rep,0)
				endif
				if ascan(lcamarre,upper("con_rep"))>0
					ocnx.conexion_odbc = iif(nvl(sys_key.con_rep,0)=0,.t.,.f.)
				endif

				if ascan(lcamarre,upper("odbc"))>0
					ocnx.odbc	= sys_key.odbc
				endif
				if ascan(lcamarre,upper("server"))>0
					ocnx.servidor	= sys_key.server
				endif
				if ascan(lcamarre,upper("database"))>0
					ocnx.basedatos	= sys_key.database
				endif
				if ascan(lcamarre,upper("almacen"))>0
					oentorno.almacen_default = alltrim(nvl(sys_key.almacen,''))
				endif
				if ascan(lcamarre,upper("serie"))>0
					oentorno.serie_default	= alltrim(nvl(sys_key.serie,''))
				endif
				if ascan(lcamarre,upper("tienda"))>0
					oentorno.tienda	= sys_key.tienda
				endif
				if ascan(lcamarre,upper("olap"))>0
					oentorno.basedatos_olap	= sys_key.olap
				endif
				if ascan(lcamarre,upper("proxy"))>0
					ocnx.proxy	= sys_key.proxy
				endif

				if ascan(lcamarre,upper("auten_win"))>0
					ocnx.autentificacion_windows= sys_key.auten_win
				endif
				if ascan(lcamarre,upper("proxy_serv"))>0
					ocnx.servidor_proxy	= alltrim(sys_key.proxy_serv)
				endif
				if ascan(lcamarre,upper("proxy_port"))>0
					ocnx.puerto_proxy	= alltrim(sys_key.proxy_port)
				endif
				if ascan(lcamarre,upper("dominio_wi"))>0
					ocnx.dominio_windows = alltrim(sys_key.dominio_wi)
				endif
				if ascan(lcamarre,upper("ruta_esque"))>0
					ocnx.ruta_esquema_local	= alltrim(sys_key.ruta_esque)
				endif

				if ascan(lcamarre,upper("tns"))>0
					ocnx.tns	= alltrim(sys_key.tns)
				endif

				if ascan(lcamarre,upper("esquema"))>0
					ocnx.esquema = alltrim(sys_key.esquema)
				endif


				if oentorno.compatible_osisv1

				   public gcia,ganop,gmesp,gcod_cia,gcod_suc,gdriver,;
				   		  gfuentedata,gperr,gperi,gsql_user,gsql_pass,;
				   		  gigv,gprograma,guser,gdatos 

				   gcia			= oentorno.nombrecia
				   gfuentedata	= ocnx.odbc
				   gdriver		= ocnx.conexion
				   gigv			= oentorno.tasa_igv
				endif


				use in "sys_key"

				otbr=createobject("barracontrol")
				otbritem=createobject("barraitems")
				otbritem.visible=.F.

				if file(oentorno.rutaosis+"libs\clases.dbf")
				   lused="use '"+oentorno.rutaosis+"libs\clases' in 0 alias clases shared " 
				   &lused
				   select "clases"
				   go top 
				   scan
				   		if file(alltrim(clases.ruta)+".vcx")
						  lsetclass="set class to '"+alltrim(clases.ruta)+"' additive"   
						  &lsetclass
				   		endif
				   		select "clases"
				   endscan
				   
				   use in "clases"
				endif

		CATCH TO oErr
				MESSAGEBOX(oErr.message+CHR(13)+MESSAGE(1)+CHR(13)+;
			      			"Error:  "+ STR(oErr.ErrorNo) +CHR(13)+;
		      				"LineNo: "+ STR(oErr.LineNo) +CHR(13)+; 
		      				"Procedure: "+ oErr.Procedure +CHR(13)+;  
		      				"Details: "+ oErr.Details  +CHR(13)+;  
		      				"StackLevel: " + STR(oErr.StackLevel) +;  
		      				"LineContents: " + oErr.LineContents +;  
		      				"UserValue: " + oErr.UserValue,16,This.Name+"."+oErr.procedure) 
		ENDTRY
	ENDPROC


	*-- Este Metodo se ejecuta para eliminar los ToolBar que vienen en el Visual FoxPro
	PROCEDURE ocultatoolbars
		local i

		luse="use "+oentorno.rutaosis+"libs\barras in 0 alias 'barras' "

		&luse

		select "barras"
		scan
			lcierra=barras.descri
			if wvisible(lcierra)
			   hide window (lcierra)
			endif
		endscan
		if used("barras")
		   use in "barras"
		endif
	ENDPROC


	*-- Muestra errores del Sistema
	PROCEDURE errorformulario
		parameters lp_programa,lp_metodo,lp_comando,lp_mensaje,lp_linea
		if parameters()=5
		   if messagebox("error en programa: "+lp_programa+chr(13)+;
		                 "metodo: "+lp_metodo+chr(13)+;
		                 "sentencia: "+lp_comando+chr(13)+;
		                 "mensaje: "+lp_mensaje+chr(13)+;
		                 "linea: "+str(lp_linea )+chr(13)+;
		                 "¿ desea salir del sistema ? ",4+32,"error")=6
		       this.terminarapido()
		   endif
		endif
		return 
	ENDPROC


	PROCEDURE terminarapido
		If messagebox("¿ seguro que deséa terminar el programa ?",4+32,"Terminar")=7
		   return
		Endif
		if ocnx.nivel<9
		  quit 
		  cancel
		endif


		clear events
		set sysmenu to default
		release all
		cancel

		&&clear all
		&&close all
		&&cancel
	ENDPROC


	*-- Devuelve el Periodo Real
	PROCEDURE periodoreal
		lparameters lcodcia,lcodsuc,lmodulo,lindnom


		private lcad,lcurdir

		lperiodo=""

		lcurdir=select()


		if (ocnx.tipo_bd=1 or ocnx.tipo_bd=4)
			lcad="SELECT ISNULL(ano_codano,'') as ano_codano,"+;
			     "		 ISNULL(mes_codmes,'') as mes_codmes "+;
			     "FROM sys_companias_modulos_s13 "+;
			     "WHERE cia_codcia='"+lcodcia+"' "+;
			     "	AND suc_codsuc='"+lcodsuc+"' "+;
			     "	AND s03_codmod='"+lmodulo+"' "
		endif

		if ocnx.tipo_bd=2
			lcad="select Nvl(ano_codano,'') as ano_codano,"+;
			     "Nvl(mes_codmes,'') as mes_codmes "+;
			     "from "+Ocnx.Esquema+".sys_companias_modulos_s13 "+;
			     "where cia_codcia='"+lcodcia+"' "+;
			     "and   suc_codsuc='"+lcodsuc+"' "+;
			     "and   s03_codmod='"+lmodulo+"' "
		endif

		          
		if ocnx.tipo_bd=3
			lcad="select ifnull(ano_codano,'') as ano_codano,"+;
			     "ifnull(mes_codmes,'') as mes_codmes "+;
			     "from sys_companias_modulos_s13 "+;
			     "where cia_codcia='"+lcodcia+"' "+;
			     "and   suc_codsuc='"+lcodsuc+"' "+;
			     "and   s03_codmod='"+lmodulo+"' "
		endif

		if type("lindnom")=="c" and !empty(alltrim(lindnom))
			if (ocnx.tipo_bd=1 or ocnx.tipo_bd=4)
				lcad="select nvl(ano_codano,'') as ano_codano,"+;
				     "nvl(mes_codmes,'') as mes_codmes "+;
				     "from  periodo_planilla_ppe "+;
				     "where cia_codcia='"+lcodcia+"' "+;
				     "and   suc_codsuc='"+lcodsuc+"' "+;
				     "and   tpl_codtpl='"+alltrim(lindnom)+"' "+;
				     "and   ano_codano+mes_codmes in "+;
				     "(select nvl(max(ano_codano+mes_codmes),'')  "+;
				     " from  periodo_planilla_ppe  "+;
				     " where cia_codcia='"+lcodcia+"' "+;
				     " and   suc_codsuc='"+lcodsuc+"' "+;
				     " and   tpl_codtpl='"+alltrim(lindnom)+"')"
			endif

			if ocnx.tipo_bd=2
				lcad="select Nvl(ano_codano,'') as ano_codano,"+;
				     "Nvl(mes_codmes,'') as mes_codmes "+;
				     "from  "+Ocnx.Esquema+".periodo_planilla_ppe "+;
				     "where cia_codcia='"+lcodcia+"' "+;
				     "and   suc_codsuc='"+lcodsuc+"' "+;
				     "and   tpl_codtpl='"+alltrim(lindnom)+"' "+;
				     "and   ano_codano+mes_codmes in "+;
				     "(select Nvl(max(ano_codano+mes_codmes),'')  "+;
				     " from  "+Ocnx.Esquema+".periodo_planilla_ppe  "+;
				     " where cia_codcia='"+lcodcia+"' "+;
				     " and   suc_codsuc='"+lcodsuc+"' "+;
				     " and   tpl_codtpl='"+alltrim(lindnom)+"')"
			endif
			if ocnx.tipo_bd=3
				lcad="select ifnull(ano_codano,'') as ano_codano,"+;
				     "nvl(mes_codmes,'') as mes_codmes "+;
				     "from  periodo_planilla_ppe "+;
				     "where cia_codcia='"+lcodcia+"' "+;
				     "and   suc_codsuc='"+lcodsuc+"' "+;
				     "and   tpl_codtpl='"+alltrim(lindnom)+"' "+;
				     "and   ano_codano+mes_codmes in "+;
				     "(select ifnull(max(ano_codano+mes_codmes),'')  "+;
				     " from  periodo_planilla_ppe  "+;
				     " where cia_codcia='"+lcodcia+"' "+;
				     " and   suc_codsuc='"+lcodsuc+"' "+;
				     " and   tpl_codtpl='"+alltrim(lindnom)+"')"
			endif
					     
		endif


		lperiodo=""     
		if (ocnx.tipo_bd=1 or ocnx.tipo_bd=3 or ocnx.tipo_bd=2)
			if sqlexec(ocnx.conexion,lcad,"tsys_companias_modulos_s13")>0
			   lperiodo=ano_codano+mes_codmes   
			else
			   messagebox("error: "+message(),16,oentorno.nombrecia)
			   select (lcurdir)
			   return .f.
			endif     
		endif
		if ocnx.tipo_bd=4
		   if !ocnx.ms_ejecuta_sql(lcad,"tsys_companias_modulos_s13")>0
		      select (lcurdir)  
		      return .f. 
		   endif
		   lperiodo=ano_codano+mes_codmes   
		endif


		select (lcurdir)

		return lperiodo
		   
	ENDPROC


	*-- Devuelve el Tipo de Cambio enviando como parametros La fecha, Moneda Nacional, Moneda Extranjera, Tipo ('V','C')
	PROCEDURE tipo_cambio
		lparameters lpfecha,lpmonnac,lpmonext,lptipo,lpdatasession

		if parameters()<4
		   messagebox("para devolver el tipo de cambio se requiere 4 parametros",64,"tipo de cambio")
		   return 0
		endif

		private larea,lcad,ltipcam
		ltipcam=0
		larea=select()
		lcfecha=dtoc(lpfecha)

		if ocnx.tipo_bd=4
			lcad="select fx_tipo_cambio('"+lcfecha+"','"+lpmonnac+"','"+lpmonext+"','"+lptipo+"') as tipcam "
		else
			lcad="select fx_tipo_cambio(?lpfecha,'"+lpmonnac+"','"+lpmonext+"','"+lptipo+"') as tipcam "
		endif

		if ocnx.tipo_bd=1
			if sqlexec(ocnx.conexion,lcad,"ttipcam")<0
			   messagebox("error: "+message(),16,"tipo de cambio")
			   return 0
			endif 
		endif
		if ocnx.tipo_bd=4
			if !ocnx.ms_ejecuta_sql(lcad,"ttipcam",lpdatasession)>0
			   messagebox("error: "+message(),16,"tipo de cambio")
			   return 0
			endif 
		endif


		if !eof()
		   ltipcam=nvl(ttipcam.tipcam,0)
		else
		   ltipcam=0
		endif 
		if used("ttipcam")
		   use in "ttipcam"
		endif

		select (larea)

		return ltipcam
	ENDPROC


	PROCEDURE onshutdown
		  *-- custom message called via the on shutdown command to indicate
		  *-- that the user must exit tastrade before exiting visual foxpro.
		=messagebox('para salir del sistema haga click en el icono salir',64,'osis')
	ENDPROC


	PROCEDURE Destroy
		on shutdown 
	ENDPROC


	PROCEDURE Init
		this.addproperty("mes[12]")
		this.mes[1]="enero"
		this.mes[2]="febrero"
		this.mes[3]="marzo"
		this.mes[4]="abril"
		this.mes[5]="mayo"
		this.mes[6]="junio"
		this.mes[7]="julio"
		this.mes[8]="agosto"
		this.mes[9]="septiembre"
		this.mes[10]="octubre"
		this.mes[11]="noviembre"
		this.mes[12]="diciembre"
	ENDPROC


	*-- Devuelve el Periodo Activo
	PROCEDURE periodoactivo
	ENDPROC


ENDDEFINE
*
*-- EndDefine: aplicacion
**************************************************


**************************************************
*-- Class:        barracontrol (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   12/04/07 06:10:05 PM
*
DEFINE CLASS barracontrol AS toolbar


	Caption = "Barra de Control"
	Enabled = .T.
	Height = 29
	Left = 176
	Top = 30
	Width = 620
	ControlBox = .F.
	ShowWindow = 1
	*-- Se ejecuta para determinar la ventana a la cual se le hace el control
	ventana = ("")
	tipo = "BARR"
	*-- Almacena el Nombre del Objeto Dato que se esta controlando como detalle
	datositem = ("")
	Name = "barracontrol"
	grid = .F.


	ADD OBJECT btnprimero AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 5, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wztop.bmp", ;
		Caption = "", ;
		ToolTipText = "Ir a Primer Registro", ;
		Name = "BtnPrimero"


	ADD OBJECT btnanterior AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 30, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzback.bmp", ;
		Caption = "", ;
		ToolTipText = "Ir al Registro Anterior (Ctrl + Flecha_Izquierda)", ;
		Name = "BtnAnterior"


	ADD OBJECT btnsiguiente AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 55, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wznext.bmp", ;
		Caption = "", ;
		ToolTipText = "Ir al siguiente registro (Ctrl + Flecha_Derecha)", ;
		Name = "BtnSiguiente"


	ADD OBJECT btnultimo AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 80, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzend.bmp", ;
		Caption = "", ;
		ToolTipText = "Ir al ultimo registro", ;
		Name = "BtnUltimo"


	ADD OBJECT separator1 AS separator WITH ;
		Top = 3, ;
		Left = 112, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator1"


	ADD OBJECT btnnuevo AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 112, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wznew.bmp", ;
		Caption = "", ;
		ToolTipText = "Nuevo Registro", ;
		Name = "BtnNuevo"


	ADD OBJECT btngraba AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 137, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzsave.bmp", ;
		Caption = "", ;
		ToolTipText = "Grabar Registros", ;
		Name = "BtnGraba"


	ADD OBJECT btnbusca AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 162, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzlocate.bmp", ;
		Caption = "", ;
		ToolTipText = "Buscar Registros", ;
		Name = "BtnBusca"


	ADD OBJECT separator2 AS separator WITH ;
		Top = 3, ;
		Left = 194, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator2"


	ADD OBJECT btnelimina AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 194, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzdelete.bmp", ;
		Caption = "", ;
		ToolTipText = "Eliminar Registros", ;
		Name = "BtnElimina"


	ADD OBJECT separator3 AS separator WITH ;
		Top = 3, ;
		Left = 226, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator3"


	ADD OBJECT btndeshacer AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 226, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzundo.bmp", ;
		Caption = "", ;
		ToolTipText = "Deshacer Ultimos Movimientos", ;
		Name = "BtnDeshacer"


	ADD OBJECT btnreporte AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 251, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wreports.bmp", ;
		Caption = "", ;
		ToolTipText = "Imprime Reporte ó Informe de los Registros", ;
		Name = "BtnReporte"


	ADD OBJECT separator7 AS separator WITH ;
		Top = 3, ;
		Left = 283, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator7"


	ADD OBJECT btnanular AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 283, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\anular.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Anular Documento", ;
		Name = "BtnAnular"


	ADD OBJECT separator5 AS separator WITH ;
		Top = 3, ;
		Left = 315, ;
		Height = 0, ;
		Width = 0, ;
		Style = 0, ;
		Name = "Separator5"


	ADD OBJECT btnformatoimpresora AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 315, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzprint.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Imprime Formato en Impresora", ;
		Name = "BtnFormatoImpresora"


	ADD OBJECT btnformatoprevio AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 340, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\preview.bmp", ;
		Caption = "", ;
		ToolTipText = "Visualisa el Formato antes de Imprimir", ;
		Name = "BtnFormatoPrevio"


	ADD OBJECT separator9 AS separator WITH ;
		Top = 3, ;
		Left = 372, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator9"


	ADD OBJECT separator6 AS separator WITH ;
		Top = 3, ;
		Left = 380, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator6"


	ADD OBJECT btnconfiguraprinter AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 380, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wconfigprinter.bmp", ;
		Caption = "", ;
		ToolTipText = "Configura Impresora", ;
		Name = "BtnConfiguraPrinter"


	ADD OBJECT separator10 AS separator WITH ;
		Top = 3, ;
		Left = 412, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator10"


	ADD OBJECT btnperiodo AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 412, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wperiodo.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Cambia de Periodo", ;
		Name = "BtnPeriodo"


	ADD OBJECT btncompania AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 437, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wcompania.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Selecciona Compañia", ;
		Name = "BtnCompania"


	ADD OBJECT btntreeview AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 462, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wopciones.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Activa Ventana de Menus", ;
		Name = "BtnTreeView"


	ADD OBJECT separator4 AS separator WITH ;
		Top = 3, ;
		Left = 494, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator4"


	ADD OBJECT btnactualiza AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 494, ;
		Height = 23, ;
		Width = 25, ;
		FontBold = .T., ;
		Picture = "..\imag\wactualiza.bmp", ;
		Enabled = .T., ;
		ToolTipText = "Actualiza Datos del Formulario", ;
		Name = "BtnActualiza"


	ADD OBJECT separator12 AS separator WITH ;
		Top = 3, ;
		Left = 526, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator12"


	ADD OBJECT btnpassword AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 526, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wkey.bmp", ;
		Caption = "", ;
		Enabled = .T., ;
		ToolTipText = "Cambio de Password", ;
		Name = "BtnPassword"


	ADD OBJECT separator11 AS separator WITH ;
		Top = 3, ;
		Left = 558, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator11"


	ADD OBJECT btnmensaje AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 558, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wmensajes.bmp", ;
		Caption = "", ;
		ToolTipText = "Activa la Ventana de Mensajes", ;
		Name = "BtnMensaje"


	ADD OBJECT separator14 AS separator WITH ;
		Top = 3, ;
		Left = 590, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator14"


	ADD OBJECT btncerrar AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 590, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wexit.bmp", ;
		Caption = "", ;
		ToolTipText = "Cerrar Ventana", ;
		Name = "BtnCerrar"


	*-- Devuelve el Nro de Formulario que esta activo para la propiedad _screen.forms[n].property
	PROCEDURE nroformulario
		FOR ln=1 TO _Screen.FormCount
		    lname=_Screen.Forms[ln].Name
		    IF UPPER(lname)==UPPER(This.Ventana)
		       RETURN ln
		    ENDIF
		ENDFOR
		RETURN 0
	ENDPROC


	*-- Este metodo actualiza sus opciones segun el formulario y segun el tipo de formulario
	PROCEDURE actualizaopciones
		lnro=This.NroFormulario()
		IF lnro=0
		   RETURN
		EndIf
		ltipo=_Screen.Forms[lnro].Tipo
		lclas=_Screen.Forms[lnro].Class

		IF !EMPTY(Oentorno.Unidad_Red)
			PRIVATE lsetd 
			IF LEFT(Oentorno.Ruta,2)<>Oentorno.Unidad_Red AND LEFT(LEFT(Oentorno.Ruta,2),2)<>"\\"
				lsetd=Oentorno.Unidad_Red+Oentorno.Ruta
			ELSE
				lsetd=Oentorno.Ruta
			ENDIF
			lsetd="Set Default to '"+lsetd+"'"
			&lsetd
		ENDIF


		IF ltipo=="FORM"
		   This.BtnDeshacer.Enabled=.T. 
		   This.BtnCompania.Enabled=.F.
		   This.BtnPeriodo.Enabled=.F.
		   This.BtnCerrar.Picture=Oentorno.RutaOsis+"Imag\wzclose.bmp" 
		   This.BtnCerrar.ToolTipText="Cerrar Ventana"
		   IF This.Visible = .F. 
		      This.Visible = .t.
		   ENDIF
		   This.Show
		   IF _Screen.Forms[lnro].Estado<>1 then
			   This.BtnPrimero.Enabled=.t.
			   This.BtnAnterior.Enabled=.t.
			   This.BtnSiguiente.Enabled=.t.
			   This.BtnUltimo.Enabled=.t.
			   This.BtnBusca.Enabled = .T.
			   
			   This.BtnNuevo.Enabled=_Screen.Forms[lnro].Habilita_Nuevo
			   This.BtnGraba.Enabled=_Screen.Forms[lnro].Habilita_Grabar
			   This.BtnElimina.Enabled=_Screen.Forms[lnro].Habilita_Elimina
			   This.BtnReporte.Enabled=_Screen.Forms[lnro].Habilita_Reporte
			   This.BtnFormatoImpresora.Enabled =_Screen.Forms[lnro].Habilita_Formato
			   This.BtnFormatoPrevio.Enabled  =_Screen.Forms[lnro].Habilita_Formato
			   This.BtnAnular.Enabled=_Screen.Forms[lnro].Habilita_Anular
		  
		   ELSE
			   This.BtnPrimero.Enabled=.f.
			   This.BtnAnterior.Enabled=.f.
			   This.BtnSiguiente.Enabled=.f.
			   This.BtnUltimo.Enabled=.f.
			   This.BtnBusca.Enabled = .F.

			   
			   This.BtnNuevo.Enabled=.f.
			   This.BtnGraba.Enabled=.t.
			   This.BtnElimina.Enabled=.f.
			   This.BtnReporte.Enabled=.f.
			   This.BtnFormatoImpresora.Enabled =.f.
			   This.BtnFormatoPrevio.Enabled  =.f.

			   This.BtnAnular.Enabled=.f.


		   ENDIF
		   	   
		ELSE
		   This.BtnCompania.Enabled=.T.
		   This.BtnPeriodo.Enabled=.T.
		   This.BtnCerrar.Picture=Oentorno.RutaOsis+"Imag\WExit.bmp" 
		   This.BtnCerrar.ToolTipText="Salir del Sistema"
		   This.BtnPrimero.Enabled=.f.
		   This.BtnAnterior.Enabled=.f.
		   This.BtnSiguiente.Enabled=.f.
		   This.BtnUltimo.Enabled=.f.
		   This.BtnReporte.Enabled=.f.
		   This.BtnFormatoImpresora.Enabled =.f.
		   This.BtnFormatoPrevio.Enabled  =.f.
		   This.BtnDeshacer.Enabled=.F. 
		   This.BtnAnular.Enabled=.f.


		   This.BtnNuevo.Enabled=.f.
		   This.BtnGraba.Enabled=.f.
		   This.BtnElimina.Enabled=.f.
		ENDIF

		IF ltipo$"PROC,CIER"
		   This.BtnCompania.Enabled=.F.
		   This.BtnPeriodo.Enabled=.F.
		   This.BtnCerrar.Enabled=.F.
		   This.BtnReporte.Enabled=_Screen.Forms[lnro].Habilita_Reporte
		ELSE
		   This.BtnCompania.Enabled=.T.
		   This.BtnPeriodo.Enabled=.T.
		   This.BtnCerrar.Enabled=.T.
		ENDIF
		IF !(ltipo=="FORM")
			This.BtnBusca.Enabled=UPPER(lclas)<>"BUSCAR"
			&&This.BtnItemBusca.Enabled=UPPER(lclas)<>"BUSCAR"
		ENDIF


		This.Refresh()
	ENDPROC


	*-- Activa o Desactiva las Opciones de Items
	PROCEDURE actualizaopcionesitems
		*!*	LPARAMETERS ldato,lgrid

		*!*	IF !EMPTY(ldato)
		*!*	   This.DatosItem=ldato
		*!*	ELSE
		*!*	   This.DatosItem=""
		*!*	ENDIF

		*!*	IF !EMPTY(lgrid)
		*!*	   This.Grid=ldato
		*!*	ELSE
		*!*	   This.Grid=""
		*!*	ENDIF

		*!*	This.Refresh()
		*!*	   
	ENDPROC


	PROCEDURE aceptar
		PRIVATE lnro
		IF _Screen.FormCount>0
			lnro=This.Nroformulario()
			IF lnro>0 
				Obj=_Screen.Forms[lnro]
		&&		WAIT WINDOW "BOTON ACEPTAR" NOWAIT
			    Obj.BotonGrupo.Cmb_Aceptar.Click()
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE acerca
		PRIVATE lnro

		IF _Screen.FormCount>0
			lnro=This.Nroformulario()
			IF lnro>0 
				Obj=_Screen.Forms[lnro]
			    Obj.Abrir("acerca","",Oentorno.rutaosis)
			ENDIF
		ENDIF
			    
			    
	ENDPROC


	PROCEDURE osis_web
		PRIVATE lxxweb
		lxxweb=CREATEOBJECT("Hyperlink")
		lxxweb.NavigateTo("www.osisonline.com")
		RELEASE lxxweb
	ENDPROC


	PROCEDURE menu_opciones
		SET SYSMENU TO _MEDIT, _MWINDOW
		SET SYSMENU AUTOMATIC

		DEFINE PAD _1oe0yvyjx OF _MSYSMENU PROMPT IIF(ocnx.idioma==oentorno.idioma_ingles,"\<File","\<Archivo") COLOR SCHEME 3 ;
			KEY ALT+A, "" BEFORE _MEDIT
		DEFINE PAD _1oe0yvyjy OF _MSYSMENU PROMPT IIF(ocnx.idioma==oentorno.idioma_ingles,"\<Tools","\<Herramientas") COLOR SCHEME 3 ;
			KEY ALT+H, "" BEFORE _MWINDOW
		DEFINE PAD _1oe0yvyjz OF _MSYSMENU PROMPT IIF(ocnx.idioma==oentorno.idioma_ingles,"\<Help","Ay\<uda") COLOR SCHEME 3 ;
			KEY ALT+U, ""
		ON PAD _1oe0yvyjx OF _MSYSMENU ACTIVATE POPUP archivo
		ON PAD _1oe0yvyjy OF _MSYSMENU ACTIVATE POPUP herramient
		ON PAD _1oe0yvyjz OF _MSYSMENU ACTIVATE POPUP ayuda

		DEFINE POPUP archivo MARGIN RELATIVE SHADOW COLOR SCHEME 4
		DEFINE BAR 1 OF archivo PROMPT "Nuevo" ;
			KEY CTRL+N, "CTRL+N" ;
			SKIP FOR !Otbr.BtnNuevo.Enabled ;
			PICTRES _mfi_new
		DEFINE BAR 2 OF archivo PROMPT "Grabar" ;
			KEY CTRL+S, "CTRL+S" ;
			SKIP FOR !Otbr.BtnGraba.Enabled ;
			PICTRES _mfi_save
		DEFINE BAR 3 OF archivo PROMPT "\-"
		DEFINE BAR 4 OF archivo PROMPT "Eliminar" ;
			SKIP FOR !Otbr.BtnElimina.Enabled ;
			PICTRES _mwi_clear
		DEFINE BAR 5 OF archivo PROMPT "\-"
		DEFINE BAR 6 OF archivo PROMPT "Ir al Primer Registro" ;
			SKIP FOR !Otbr.BtnPrimero.Enabled
		DEFINE BAR 7 OF archivo PROMPT "Ir al Registro Anterior" ;
			KEY CTRL+LEFTARROW, "CTRL+LEFTARROW" ;
			SKIP FOR !Otbr.BtnAnterior.Enabled
		DEFINE BAR 8 OF archivo PROMPT "Ir al Siguiente Registro" ;
			KEY CTRL+RIGHTARROW, "CTRL+RIGHTARROW" ;
			SKIP FOR !Otbr.BtnSiguiente.Enabled
		DEFINE BAR 9 OF archivo PROMPT "Ir al Ultimo Registro" ;
			SKIP FOR !Otbr.BtnUltimo.Enabled
		DEFINE BAR 10 OF archivo PROMPT "\-"
		DEFINE BAR 11 OF archivo PROMPT "\<Salir" ;
			KEY CTRL+X, "CTRL+X" ;
			SKIP FOR !otbr.btncerrar.enabled ;
			PICTRES _mfi_quit
		ON SELECTION BAR 1 OF archivo Otbr.BtnNuevo.Click()
		ON SELECTION BAR 2 OF archivo Otbr.BtnGraba.Click()
		ON SELECTION BAR 4 OF archivo Otbr.BtnElimina.Click()
		ON SELECTION BAR 6 OF archivo Otbr.BtnPrimero.Click()
		ON SELECTION BAR 7 OF archivo Otbr.BtnAnterior.Click()
		ON SELECTION BAR 8 OF archivo Otbr.BtnSiguiente.Click()
		ON SELECTION BAR 9 OF archivo Otbr.BtnUltimo.Click()
		ON SELECTION BAR 11 OF archivo otbr.btncerrar.Click()

		DEFINE POPUP herramient MARGIN RELATIVE SHADOW COLOR SCHEME 4
		DEFINE BAR 1 OF herramient PROMPT "\<Buscar..." ;
			SKIP FOR !Otbr.BtnBusca.Enabled ;
			PICTRES _med_find
		DEFINE BAR 2 OF herramient PROMPT "\<Deshacer" ;
			SKIP FOR !Otbr.BtnDeshacer.Enabled ;
			PICTRES _med_undo
		DEFINE BAR 3 OF herramient PROMPT "\-"
		DEFINE BAR 4 OF herramient PROMPT "Selecciona \<Periodo" ;
			SKIP FOR !Otbr.BtnPeriodo.Enabled
		DEFINE BAR 5 OF herramient PROMPT "Selecciona \<Compañia" ;
			SKIP FOR !Otbr.BtnCompania.Enabled ;
			PICTRES _mwz_database
		DEFINE BAR 6 OF herramient PROMPT "\-"
		DEFINE BAR 7 OF herramient PROMPT "Opciones del Sistema" ;
			SKIP FOR !Otbr.BtnTreeView.Enabled 
		DEFINE BAR 8 OF herramient PROMPT "\-"
		*!*	DEFINE BAR 9 OF herramient PROMPT "Ver Barra de Control" ;
		*!*		SKIP FOR !Otbr.Visible 

		ON SELECTION BAR 1 OF herramient Otbr.BtnBusca.Click()
		ON SELECTION BAR 2 OF herramient Otbr.BtnDeshacer.Click()
		ON SELECTION BAR 4 OF herramient Otbr.BtnPeriodo.Click()
		ON SELECTION BAR 5 OF herramient Otbr.BtnCompania.Click()
		ON SELECTION BAR 7 OF herramient Otbr.BtnTreeView.Click()
		*!*	ON SELECTION BAR 9 OF herramient Otbr.Visible=.T.

		DEFINE POPUP ayuda MARGIN RELATIVE SHADOW COLOR SCHEME 4
		DEFINE BAR 1 OF ayuda PROMPT "Ay\<uda del Sistema" ;
			PICTRES _mst_hpsch
		DEFINE BAR 2 OF ayuda PROMPT "OSIS en la Web" ;
			PICTRES _mwz_webservices
		DEFINE BAR 3 OF ayuda PROMPT "\-"
		DEFINE BAR 4 OF ayuda PROMPT "Acerca del Sistema" ;
			PICTRES _mst_about
		ON SELECTION BAR 1 OF ayuda Otbr.Ayuda()
		ON SELECTION BAR 2 OF ayuda Otbr.Osis_Web()
		ON SELECTION BAR 4 OF ayuda Otbr.Acerca()
	ENDPROC


	PROCEDURE Init
		This.Dock(0)
		This.Menu_opciones() 
	ENDPROC


	PROCEDURE Activate
		This.ActualizaOpciones()
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE MouseMove
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		DODEFAULT(nButton, nShift, nXCoord, nYCoord)
		This.BtnTreeView.Refresh()  
	ENDPROC


	PROCEDURE ayuda
	ENDPROC


	PROCEDURE btnprimero.Click
		PRIVATE lnro
		IF This.Enabled 
			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					_Screen.Forms[lnro].Ir_Al_Primer_Registro()
				ENDIF
			ENDIF
		ENDIF


	ENDPROC


	PROCEDURE btnanterior.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					_Screen.Forms[lnro].Ir_Al_Anterior_Registro()
			    ENDIF
			ENDIF

		ENDIF

		    
	ENDPROC


	PROCEDURE btnsiguiente.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					_Screen.Forms[lnro].Ir_Al_Siguiente_Registro()
				ENDIF
			ENDIF

		ENDIF


	ENDPROC


	PROCEDURE btnultimo.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					_Screen.Forms[lnro].Ir_Al_Ultimo_Registro()
				ENDIF
			ENDIF
		ENDIF


	ENDPROC


	PROCEDURE btnnuevo.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Nuevo()
				ENDIF
			ENDIF
			    
		ENDIF
			    
	ENDPROC


	PROCEDURE btngraba.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.NroFormulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Grabar()
				ENDIF
			ENDIF

		ENDIF
	ENDPROC


	PROCEDURE btnbusca.Click
		IF UPPER(_Screen.Forms[This.Parent.Nroformulario()].Class)=="OPCIONES"
			This.Enabled=.F.
		ELSE
			This.Enabled=.T. 
		ENDIF


		IF This.Enabled 
			IF This.Parent.Nroformulario()>0
				_Screen.Forms[This.Parent.Nroformulario()].Busca()
			EndIf

		ENDIF
	ENDPROC


	PROCEDURE btnelimina.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Elimina()
				ENDIF
			ENDIF
			    
		ENDIF
			    
	ENDPROC


	PROCEDURE btndeshacer.Click
		IF This.Enabled=.T. 
			_Screen.Forms[This.Parent.Nroformulario()].Deshacer()
		ENDIF
	ENDPROC


	PROCEDURE btnreporte.Click
		PRIVATE lnro
		IF This.Enabled=.T. 
			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Imprime()
				ENDIF
			ENDIF
		ENDIF

			    
	ENDPROC


	PROCEDURE btnanular.Click
		IF This.Enabled 
			_Screen.Forms[This.Parent.Nroformulario()].Anular()
		ENDIF
	ENDPROC


	PROCEDURE btnformatoimpresora.Click
		PRIVATE lnro
		IF This.Enabled 
			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Formato(1)
				ENDIF
			ENDIF
		ENDIF

			    
	ENDPROC


	PROCEDURE btnformatoprevio.Click
		PRIVATE lnro
		IF This.Enabled
			IF _Screen.FormCount>0
				lnro=This.Parent.Nroformulario()
				IF lnro>0 
					Obj=_Screen.Forms[lnro]
				    Obj.Formato(2)
				ENDIF
			ENDIF
		ENDIF

			    
			    
	ENDPROC


	PROCEDURE btnconfiguraprinter.Click
		IF !This.Enabled
		   RETU
		ENDIF
		IF This.Parent.Nroformulario()>0
			_Screen.Forms[This.Parent.Nroformulario()].Entorno.Configura_Impresora()
		EndIf
	ENDPROC


	PROCEDURE btnperiodo.Click
		IF !This.Enabled
		   RETU
		ENDIF
		IF This.Parent.Nroformulario()>0
			_Screen.Forms[This.Parent.NroFormulario()].Periodo()
		Endif
	ENDPROC


	PROCEDURE btncompania.Click
		IF !This.Enabled
		   RETU
		ENDIF
		IF This.Parent.Nroformulario()>0
			_Screen.Forms[This.Parent.NroFormulario()].Compania()
		Endif
	ENDPROC


	PROCEDURE btncompania.Refresh
		PRIVATE ln,lexis

		lexis=.T.
		IF _Screen.FormCount>0
			&&WAIT WINDOW "Entro" NOWAIT 
			FOR ln=1 TO _Screen.FormCount
			    IF UPPER(_Screen.Forms[ln].Class)=="CIAS" AND _Screen.Forms[ln].Visible=.T.
			       lexis=.F.
			       EXIT 
			    ENDIF
			ENDFOR
		ENDIF

		This.Enabled=lexis
		 
	ENDPROC


	PROCEDURE btntreeview.Refresh
		PRIVATE ln,lexis

		lexis=.T.
		IF _Screen.FormCount>0
			&&WAIT WINDOW "Entro" NOWAIT 
			FOR ln=1 TO _Screen.FormCount
			    IF UPPER(_Screen.Forms[ln].Class)=="OPCIONES" AND _Screen.Forms[ln].Visible=.T.
			       lexis=.F.
			       EXIT 
			    ENDIF
			ENDFOR
		ENDIF

		This.Enabled=lexis
		 
	ENDPROC


	PROCEDURE btntreeview.Click
		PRIVATE ln,lexis

		IF !This.Enabled
		   RETU
		ENDIF


		IF _Screen.FormCount>0
		    lexis=.F.
			FOR ln=1 TO _Screen.FormCount
			    IF UPPER(_Screen.Forms[ln].Class)=="OPCIONES"
			       lexis=.T.
			       EXIT 
			    ENDIF
			ENDFOR
		    IF !lexis
				DO FORM Oentorno.rutaosis+"Forms\Sistemas"
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE btnactualiza.Click
		PRIVATE lnro
		IF This.Enabled 

			IF _Screen.FormCount>0
				lnro=This.Parent.NroFormulario()
				IF lnro>0 
					_Screen.Forms[lnro].Actualiza_Datos()
				ENDIF
			ENDIF
		ENDIF


	ENDPROC


	PROCEDURE btnpassword.Click
		IF !This.Enabled
		   RETU
		ENDIF
		IF This.Parent.Nroformulario()>0
			_Screen.Forms[This.Parent.NroFormulario()].Password()
		Endif
	ENDPROC


	PROCEDURE btnmensaje.Click
		IF !This.Enabled
		   RETU
		ENDIF
		IF This.Parent.Nroformulario()>0
			_Screen.Forms[This.Parent.NroFormulario()].Mensaje()
		Endif
	ENDPROC


	PROCEDURE btncerrar.Click
		PRIVATE lnro,lsalir

		IF !This.Enabled
		   RETU
		ENDIF

		lsalir=.F.
		IF _Screen.FormCount>0
			lnro=This.Parent.Nroformulario()
			IF lnro>0 
				IF This.Enabled=.t.
					_Screen.Forms[lnro].Cerrar()
				ENDIF
			ELSE
		  	    lsalir=.T.
			ENDIF
		ELSE
		    lsalir=.T.
		ENDIF
		IF !lsalir
		   RETURN
		ENDIF

		IF MESSAGEBOX("¿ Desea Salir del Sistema ?",4+32,Oentorno.nombrecia)=7
		   RETURN 
		ENDIF
		CLEAR EVENT
		SET SYSMENU TO DEFAULT


	ENDPROC


ENDDEFINE
*
*-- EndDefine: barracontrol
**************************************************


**************************************************
*-- Class:        barraitems (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   11/14/06 04:14:00 PM
*
DEFINE CLASS barraitems AS toolbar


	Caption = "Detalle"
	Height = 29
	Left = 0
	Top = 0
	Width = 135
	ControlBox = .F.
	datositem = .F.
	grid = .F.
	ventana = ("")
	Name = "barraitems"


	ADD OBJECT btnagrega AS boton WITH ;
		Top = 3, ;
		Left = 5, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzagregaitem.bmp", ;
		Caption = "", ;
		ToolTipText = "Agrega Item (Tecla F2)", ;
		Name = "BtnAgrega"


	ADD OBJECT btninserta AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 30, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzinsertaitem.bmp", ;
		Caption = "", ;
		ToolTipText = "Inserta Item  (Tecla F4)", ;
		Name = "BtnInserta"


	ADD OBJECT btnelimina AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 55, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzelimiaitem.bmp", ;
		Caption = "", ;
		ToolTipText = "Elimina Item (Tecla F3)", ;
		Name = "BtnElimina"


	ADD OBJECT btnmueveitem AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 80, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wmueveitem.bmp", ;
		Caption = "", ;
		ToolTipText = "Mueve posción de un item", ;
		Name = "BtnMueveItem"


	ADD OBJECT btnitembusca AS boton WITH ;
		AutoSize = .F., ;
		Top = 3, ;
		Left = 105, ;
		Height = 23, ;
		Width = 25, ;
		Picture = "..\imag\wzbuscaitem.bmp", ;
		Caption = "", ;
		ToolTipText = "Deshacer Ultimos Movimientos", ;
		Name = "BtnItemBusca"


	PROCEDURE actualizaopcionesitems
		LPARAMETERS ldato,lgrid

		IF !EMPTY(ldato)
		   This.DatosItem=ldato
		ELSE
		   This.DatosItem=""
		ENDIF

		IF !EMPTY(lgrid)
		   This.Grid=ldato
		ELSE
		   This.Grid=""
		ENDIF

		This.Refresh()
		   
	ENDPROC


	PROCEDURE nroformulario
		FOR ln=1 TO _Screen.FormCount
		    lname=_Screen.Forms[ln].Name
		    IF UPPER(lname)==UPPER(This.Ventana)
		       RETURN ln
		    ENDIF
		ENDFOR
		RETURN 0
	ENDPROC


	PROCEDURE Init
		This.Dock(2)
	ENDPROC


	PROCEDURE btnagrega.Click
		IF !This.Enabled
		   RETU
		ENDIF
		WAIT WINDOW This.Parent.DatosItem NOWAIT 

		IF EMPTY(This.Parent.DatosItem)
		   MESSAGEBOX("REFERENCIA AL OBJETO DATO ESTA VACIO",64,"ERROR")
		   RETURN 
		ENDIF

		_Screen.Forms[This.Parent.Nroformulario()].DatosAccion(1,This.Parent.DatosItem)
	ENDPROC


	PROCEDURE btninserta.Click
		IF !This.Enabled
		   RETU
		ENDIF

		_Screen.Forms[This.Parent.Nroformulario()].DatosAccion(3,This.Parent.DatosItem)
	ENDPROC


	PROCEDURE btnelimina.Click
		IF !This.Enabled
		   RETU
		ENDIF

		_Screen.Forms[This.Parent.Nroformulario()].DatosAccion(2,This.Parent.DatosItem)
	ENDPROC


	PROCEDURE btnmueveitem.Click
		IF !This.Enabled
		   RETU
		ENDIF

		_Screen.Forms[This.Parent.Nroformulario()].DatosAccion(7,This.Parent.DatosItem)
	ENDPROC


	PROCEDURE btnitembusca.Click
		IF !This.Enabled
		   RETU
		ENDIF
		*!*	IF TYPE("This.Parent.Grid")=="O"
		*!*		This.Parent.Grid.Busca_Dato(This.parent.Grid.Campo_Busqueda)
		*!*	ENDIF

		_Screen.Forms[This.Parent.Nroformulario()].DatosAccion(4,This.Parent.DatosItem)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: barraitems
**************************************************


**************************************************
*-- Class:        boton (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/14/06 11:58:03 AM
*
DEFINE CLASS boton AS commandbutton


	Height = 27
	Width = 84
	FontName = "MS Sans Serif"
	Caption = ""
	Style = 0
	SpecialEffect = 2
	Name = "boton"


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: boton
**************************************************


**************************************************
*-- Class:        botongrupo (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  commandgroup
*-- BaseClass:    commandgroup
*-- Time Stamp:   09/09/06 12:36:12 PM
*
DEFINE CLASS botongrupo AS commandgroup


	AutoSize = .T.
	ButtonCount = 3
	Value = 1
	Height = 149
	Width = 89
	Name = "botongrupo"
	Command1.AutoSize = .F.
	Command1.Top = 5
	Command1.Left = 5
	Command1.Height = 24
	Command1.Width = 79
	Command1.FontName = "MS Sans Serif"
	Command1.Picture = "..\imag\aceptar1.bmp"
	Command1.Caption = "\<Aceptar"
	Command1.Default = .T.
	Command1.SpecialEffect = 0
	Command1.PicturePosition = 1
	Command1.ForeColor = RGB(0,0,0)
	Command1.Name = "Cmb_Aceptar"
	Command2.AutoSize = .F.
	Command2.Top = 60
	Command2.Left = 5
	Command2.Height = 24
	Command2.Width = 79
	Command2.FontName = "MS Sans Serif"
	Command2.Picture = "..\imag\ayuda1.bmp"
	Command2.Caption = "Ay\<uda"
	Command2.SpecialEffect = 0
	Command2.PicturePosition = 1
	Command2.ForeColor = RGB(0,0,0)
	Command2.Name = "Cmb_Ayuda"
	Command3.AutoSize = .F.
	Command3.Top = 120
	Command3.Left = 5
	Command3.Height = 24
	Command3.Width = 79
	Command3.FontName = "MS Sans Serif"
	Command3.Picture = "..\imag\cancelar1.bmp"
	Command3.Cancel = .T.
	Command3.Caption = "\<Cancelar"
	Command3.SpecialEffect = 0
	Command3.PicturePosition = 1
	Command3.ForeColor = RGB(0,0,0)
	Command3.Name = "Cmb_Cancelar"


	PROCEDURE ordena_horizontal
		This.Cmb_Ayuda.Left = 0
		This.Cmb_Aceptar.Left = INT(This.Width/2) - INT(This.Cmb_Aceptar.Width/2)  
		This.Cmb_Cancelar.Left = This.Width - This.Cmb_Cancelar.Width - 2

		 
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Cmb_Aceptar.Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Cmb_Ayuda.Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Cmb_Cancelar.Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Cmb_Cancelar.Click
		ThisForm.Cerrar()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botongrupo
**************************************************


**************************************************
*-- Class:        check (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   05/08/07 05:39:11 PM
*
DEFINE CLASS check AS checkbox


	Height = 15
	Width = 49
	FontName = "MS Sans Serif"
	FontSize = 8
	AutoSize = .T.
	Alignment = 0
	BackStyle = 0
	Caption = "Check"
	*-- Si esta en .T. en  actualizará el campo por 1 o 0
	indicador_1_0 = .T.
	*-- Si indicador 1 y 0 esta en .T. tiene que idicar el campo al que esta asociado el control
	campo = ("")
	datoobjeto = ("")
	Name = "check"
	utilizanombre = .F.


	PROCEDURE asociatabla
		PARAMETERS ldata

		IF !EMPTY(ldata)
		    Wcamp=""
		    IF UPPER(This.Class)="CHECK" or This.UtilizaNombre
		       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
		    ELSE       
		      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
			EndIf    
		    &Wcomm
		    Wtype="Type('"+Wcamp+"')=='N'"
		    
		    IF &Wtype
				Wthis="This.ControlSource='"+Wcamp+"'"
			ELSE
			    IF This.Indicador_1_0=.T.  
			    	Wthis="This.Campo='"+Wcamp+"'"
			    ENDIF
			    
			ENDIf
			&Wthis
		EndIF
	ENDPROC


	PROCEDURE Refresh
		PRIVATE lcurdir,lvalue
		TRY 
			lcurdir=SELECT()
			IF !EMPTY(This.DatoObjeto) AND !EMPTY(This.Campo) AND This.Indicador_1_0=.T. 
			    lvalue="This.Value=VAL(NVL("+ALLTRIM(This.Campo)+",'0')) "
			    &lvalue
			ENDIF
			SELECT (lcurdir)
		CATCH TO oErr
			MESSAGEBOX(oErr.message+CHR(13)+MESSAGE(1)+CHR(13)+CHR(13)+lvalue,16,This.Name+"."+oErr.procedure) 
		ENDTRY

	ENDPROC


	PROCEDURE Click
		PRIVATE lcurdir,lsele,lrepla

		lcurdir=SELECT()
		IF !EMPTY(This.DatoObjeto) AND !EMPTY(This.Campo) AND (This.Indicador_1_0=.T.)
			lsele="SELECT (ThisForm."+ALLTRIM(This.DatoObjeto)+".Area)"
			&lsele
		    lrepla="REPLACE "+This.Campo+" WITH STR(NVL(This.Value,0),1) "
		    &lrepla
		    This.Refresh()
		ENDIF
		SELECT (lcurdir)
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Init
		This.AsociaTabla(This.DatoObjeto)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: check
**************************************************


**************************************************
*-- Class:        check_busca (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  check (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   08/14/06 12:00:14 PM
*
DEFINE CLASS check_busca AS check


	Alignment = 0
	Caption = ""
	Name = "check_busca"


	PROCEDURE Click
		DODEFAULT()
		IF TYPE("ThisForm.Secuencia_Seleccion")=="N"
			SELECT (ThisForm.DatosLista.Area)
			IF This.Value = 0
				ThisForm.Secuencia_Seleccion=ThisForm.Secuencia_Seleccion-1
				REPLACE O WITH 0
			ELSE
				ThisForm.Secuencia_Seleccion=ThisForm.Secuencia_Seleccion+1
				REPLACE O WITH ThisForm.Secuencia_Seleccion
			ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: check_busca
**************************************************


**************************************************
*-- Class:        combo (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  combobox
*-- BaseClass:    combobox
*-- Time Stamp:   10/31/05 04:30:03 PM
*
DEFINE CLASS combo AS combobox


	FontName = "MS Sans Serif"
	FontSize = 8
	Height = 24
	Style = 2
	Width = 100
	DisabledBackColor = RGB(255,255,255)
	DisabledForeColor = RGB(0,0,160)
	*-- Escribe el nombre del objeto Dato que se va asociar a este contro Ejm: Datos1
	datoobjeto = ("")
	nombreadicional = ("")
	*-- Si esta en .T. elimina el dato con la tecla DELETE
	tecla_delete_borra_dato = (.T.)
	Name = "combo"

	*-- Si esta en .T. siempre usara la propiedad Name para asociarlo al Control Source
	utilizanombre = .F.
	valor_anterior = .F.


	PROCEDURE asociatabla
		PARAMETERS ldata

		IF !EMPTY(ldata)
		    Wcamp=""
		    IF EMPTY(This.NombreAdicional) 
			    IF UPPER(This.Class)=="COMBO" or This.UtilizaNombre
			       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
			    ELSE       
			      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
				EndIf    
			    &Wcomm
				Wthis="This.ControlSource='"+Wcamp+"'"
				&Wthis
			ELSE
			   Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.NombreAdicional"
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Init
		This.AsociaTabla(This.datoobjeto)
	ENDPROC


	PROCEDURE GotFocus
		DODEFAULT()
		This.Valor_Anterior=This.Value 
	ENDPROC


	PROCEDURE KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl
		IF nKeyCode=7 AND This.Style = 2 AND This.Tecla_delete_borra_dato 
			This.Value =""
			This.Refresh() 
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: combo
**************************************************


**************************************************
*-- Class:        conexion (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/08/08 04:51:10 PM
*
DEFINE CLASS conexion AS custom


	Height = 26
	Width = 40
	*-- Nombre del OBDC de la Conexio
	odbc = ("")
	conexion = (-1)
	*-- Tipo de Conexion : Asynchronous,Transactions
	configuracion = "Asynchronous"
	*-- Parametro de Conexion:  Si Congiguracion=Asynchronous => .f., Configuracion=Transactions => 2
	parametro = .F.
	*-- Indica si al Momento que se libera el Objeto y si existe una conexión se va desconectar automaticamente
	desconectar_salir = .T.
	*-- Usuario que se conecta a la Base de Datos
	usuario = ("")
	*-- El Paswword que tiene el usuario para conectarse
	password = ("")
	*-- Guarda el Nivel que tiene el Usuario en el Sistema
	nivel = ("0")
	*-- Guarda los Mensajes del Error a Actualizar la Base de Datos
	errormensaje = ("")
	*-- Guarda el Nombre de la Base de Datos a la Cual se esta conectado
	basedatos = ("")
	*-- Si esta en .T. verifica que el usuario este en el Sistema
	usuario_osis = .T.
	*-- Verifica que a la hora de grabar la conexion este en tipo Transactions
	commit_transactions = .T.
	*-- Idioma predeterminado del usuario
	idioma = ("")
	*-- Tipo de Conexion a la Base de Datos
	tipo_bd = (4)
	*-- Servidor
	servidor = ("")
	session = (0)
	flag_xml = (0)
	codigo_vendedor = ("")
	url = ("")
	componenteweb = ("ClsProxyCOM_v4.SQLService_v4")
	url_reportes = ("")
	url_servicios = ("")
	servidor_proxy = ("")
	puerto_proxy = ("")
	dominio_windows = ("")
	usuario_windows = ("OSIS")
	password_windows = ("rriosis")
	almacen_default = ("")
	serie_default = ("")
	tienda_default = ("")
	usuario_perfil = ("")
	driver = ("SQL Server")
	*-- Para Oracle -Se configura en el archivo tnsnames.ora
	tns = ("")
	propietario = ("")
	esquema = ("")
	cadenaconexion = ("")
	Name = "conexion"
	sqlwebservice = .F.

	*-- Si esta en .T. indica que se conecta a Internet a travez de un servidor proxy
	proxy = .F.

	*-- Si esta en .T. indica la conexión de Confianza
	confianza = .F.

	*-- Es el codigo que utiliza en usuario el la tablas SYS_PASS del sistema en DBF
	usuario_dbf = .F.
	autentificacion_windows = .F.
	ruta_esquema_local = .F.
	conexion_odbc = .F.
	DIMENSION parametros_sql[1]
	DIMENSION secuencia_xml[20,3]
	DIMENSION parametro_devuelto[1]


	*-- Ejecute este Metodo para Conectarse a una Base de Datos
	PROCEDURE conectar
		IF This.Tipo_bd = 4
		   This.Conexion = 1
		   Gdriver = 1
		   IF !This.Verifica_usuario() 
		      RETURN .F.
		   ENDIF
		   
		ENDIF

		PRIVATE lcDSNLess
		lcDSNLess=""

		IF This.Tipo_bd < 4
			&&IF !EMPTY(This.odbc)
			    &&This.Conexion=SqlConnec(ALLTRIM(This.odbc),This.usuario,This.Password)   
			    IF !This.Confianza 

		    		ldriver=ALLTRIM(NVL(This.Driver,""))
			    
		*!*		    	IF This.Tipo_bd = 1 && Sql Server
		*!*		    		ldriver="SQL Server"
		*!*		    	ENDIF
		*!*			    IF This.Tipo_bd = 3 && MySQL
		*!*		    		ldriver="MySQL ODBC 3.51 Driver;option=1"
		*!*		    	ENDIF

		&&	    	SUSP
				    lcDSNLess="driver="+ldriver+";server="+ALLTRIM(This.Servidor)+;
				    		  ";database="+ALLTRIM(This.BaseDatos)+";uid="+ALLTRIM(This.Usuario)+;
				    		  ";pwd="+ALLTRIM(This.Password)
				    		  
				    IF This.Tipo_bd =2
		*!*				    lcDSNLess="DRIVER="+ldriver+";DBQ="+ALLTRIM(This.Tns)+";UID="+ALLTRIM(This.Usuario)+;
		*!*				    		  ";PWD="+ALLTRIM(This.Password)+";EXC=T"
					    lcDSNLess="DRIVER="+ldriver+";DBQ="+ALLTRIM(This.Tns)+";UID="+ALLTRIM(This.Usuario)+;
					    		  ";PWD="+ALLTRIM(This.Password)+";EXC=T;NUM=MS"

				    ENDIF
				     		  
			     ELSE
				    lcDSNLess="driver=SQL Server;server="+ALTRIM(This.Servidor)+;
				    		  ";database="+ALLTRIM(This.BaseDatos)
			     ENDIF
			    		  
			   	&&MESSAGEBOX(IIF(This.Conexion_odbc,'SI','NO'))  		  

				This.Cadenaconexion = lcDSNLess
				   
			   	IF !This.Conexion_odbc  		  
				    This.Conexion=SQLSTRINGCONNECT(m.lcDSNLess)
				ELSE
					This.Conexion=SQLCONNECT(ALLTRIM(This.odbc),This.usuario,This.Password)   
				ENDIF
				    
			    IF This.Conexion>0
				    IF Oentorno.Compatible_OSISV1
				     	Gdriver		=	This.Conexion
				     	Gsql_user	=	This.usuario 
				     	Gsql_pass	=	This.Password 
				     	Guser		=	This.Usuario 
				    ENDIF
			    ENDIF
			    
				IF This.Conexion>0

		  		   &&This.Usuario=SQLGETPROP(This.Conexion,"UserId")
		  		   PRIVATE luser, ldata, lexe
		  		   
		  		   
			    	IF This.Tipo_bd = 1 && Sql Server
		   	  		   lexe="SET DATEFORMAT dmy"
			  		   luser="Select Suser_Sname() as usuario "
			  		   ldata="Select Db_Name() as data "
			  		ENDIF
			    	IF This.Tipo_bd = 3 
			  		   luser="Select user() as usuario "
			  		   ldata=""
			  		ENDIF
			    	IF This.Tipo_bd = 2 
			  		   luser="Select user as usuario From dual "
			  		   ldata=""
			  		ENDIF
			  		   
		  		   
		  		   IF (This.Tipo_bd =1 OR This.Tipo_bd =3 OR This.Tipo_bd=2 )
		  		   		IF This.Tipo_bd <>2
			  		   		IF SQLEXEC(This.Conexion,lexe) <0
			  		   			MESSAGEBOX(MESSAGE(),16,"Conexión")
			  		   			RETURN .F.
			  		   		ENDIF
						ENDIF

		  		   		IF SQLEXEC(This.Conexion,luser,"Tuserx") <0
		  		   			MESSAGEBOX(MESSAGE(),16,"Conexión")
		  		   			RETURN .F.
		  		   		ENDIF
		  		   		This.usuario =ALLTRIM(Tuserx.usuario)

						IF This.Tipo_bd<>2 
			  		   		IF SQLEXEC(This.Conexion,ldata,"Tdatax") <0
			  		   			MESSAGEBOX(MESSAGE(),16,"Conexión")
			  		   			RETURN .F.
			  		   		ENDIF
							This.Basedatos = ALLTRIM(Tdatax.data)
						ENDIF

		  		   		IF This.Tipo_bd =3
		  		   			This.usuario = LEFT(This.usuario,AT("@",This.usuario)-1) 
		  		   		ENDIF
		  		   
		  		   ENDIF
		  		   

		  		   
				   SET Message to   "CONEXION REALIZADA CON EXITO"
				   
				   IF !This.Configura()
				      This.Desconectar() 
				      RETURN .f.    
				   ENDIF
				   IF !This.Verifica_Usuario()
				      This.Desconectar() 
				      RETURN .f.    
				   ENDIF
				ELSE
				    MESSAGEBOX(MESSAGE(),16,"ERROR EN CONEXION - NO SE PUDO CONECTAR") 
				    RETURN .F.
				ENDIF
		*!*		ELSE
		*!*		   MESSAGEBOX("NO SE HA INDICADO EL ODBC QUE SE VA UTILIZAR PARA LA CONEXION",64,"ERROR ODBC")
		*!*		ENDIF
		ENDIF

		IF (This.Tipo_BD=4 AND Oentorno.Compatible_OSISV1)
			PRIVATE lexe
			lexe =	"Select s10_passwo "+;
					"From SYS_TABLA_USUARIOS_S10 "+;
					"Where UPPER(s10_usuario)='"+UPPER(NVL(This.Usuario,""))+"' "

			IF This.Ms_ejecuta_sql(lexe,"Tuser")<0
				RETURN .F.
			ENDIF
			IF UPPER(ALLTRIM(NVL(Tuser.s10_passwo,"")))<>UPPER(ALLTRIM(This.Password))
				MESSAGEBOX("Usuario o Clave Errada",16,"OSIS")
				RETURN .F.
			ENDIF

		ENDIF
		 

		RETURN .T.
	ENDPROC


	*-- Ejecute este Metodo para Desconectarse a una Base de Datos
	PROCEDURE desconectar
		IF This.Tipo_bd=4
		   RETURN 
		ENDIF
		 
		IF This.Conexion>0
		   IF SQLDISCONNECT(This.Conexion)<0
		      MESSAGEBOX(MESSAGE(),16,"ERROR AL DESCONECTAR") 
		      RETURN .f.
		   ENDIF
		   WAIT WINDOW "AHORA ESTA DESCONECTADO" NOWAIT
		   This.Conexion= -1
		Endif
	ENDPROC


	*-- Actualiza la Base de Datos Cuando la Propiedad Configuracion es de tipo Transacction
	PROCEDURE commit
		IF This.Commit_transactions 
			IF UPPER(This.Configuracion)=="TRANSACTIONS"
			   IF SQLCOMMIT(This.Conexion)<0
			      MESSAGEBOX(MESSAGE(),"ERROR AL ACTUALIZAR BASE DE DATOS")
			      RETURN .F.
			   EndIf
			ELSE
			   MESSAGEBOX("La Configuración No Esta en Tipo TRANSACTION",16,"ERROR DE CONEXION")
			   RETURN .F.
			ENDIF
		ELSE
		   IF SQLCOMMIT(This.Conexion)<0
		      MESSAGEBOX(MESSAGE(),"ERROR AL ACTUALIZAR BASE DE DATOS")
		      RETURN .F.
		   ENDIF
		ENDIF

		RETURN .T.
	ENDPROC


	*-- Cancela una trasaccion cuando la propiedad Configuración es de tipo Transacction
	PROCEDURE rollback
		IF This.Commit_transactions 
			IF UPPER(This.Configuracion)=="TRANSACTIONS"
			   IF SQLROLLBACK(This.Conexion)<0
			      MESSAGEBOX(MESSAGE(),"ERROR AL ACTUALIZAR BASE DE DATOS")
			      RETURN .F.
			   EndIf
			ELSE
			   MESSAGEBOX("La Configuración No Esta en Tipo TRANSACTION",16,"ERROR DE CONEXION-ROLLBACK")
			   RETURN .F.
			ENDIF
		ELSE
			   IF SQLROLLBACK(This.Conexion)<0
			      MESSAGEBOX(MESSAGE(),"ERROR AL ACTUALIZAR BASE DE DATOS")
			      RETURN .F.
			   EndIf
		ENDIF

		RETURN .T.
	ENDPROC


	*-- Ejecute este Metodo Para Configrar la Conexión de acuerdo a los parametros obtenidos en la propiedad Configuracion y Parametro
	PROCEDURE configura
		IF This.Tipo_bd=4
		   Return
		ENDIF
		 
		IF This.Conexion>0 AND !EMPTY(This.Configuracion)
		   IF SQLSETPROP(This.Conexion,This.Configuracion,This.Parametro)<0
		      MESSAGEBOX(MESSAGE(),16,"ERROR AL CONFIGURAR")
		      RETURN .f. 
		   EndIf
		ELSE
		    MESSAGEBOX("NO SE HA INDICADO LA CONFIGURACION DE CONEXION",16,"ERROR AL CONFIGURAR")
			RETURN .f.
		Endif
	ENDPROC


	PROCEDURE verifica_usuario
		IF This.Usuario_Osis 
			IF This.Conexion>0 AND !EMPTY(This.usuario)
			   WAIT WINDOW "Verificando Usuario en el Sistema..." NoWait
		*!*		   lcad="Select s10_nivusu,s19_codidi,ISNULL(s10_coddbf,'') as 's10_coddbf' "+;
		*!*			    "From dbo.SYS_TABLA_USUARIOS_S10 "+;
		*!*			    "Where Upper(s10_usuario)=Upper('"+ALLTRIM(This.Usuario)+"') "

				IF Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4
					lcad="Exec dbo.PA_DATOS_USUARIO @usuario='"+ALLTRIM(This.Usuario)+"'"
				ENDIF
				IF Ocnx.Tipo_BD=3  
					lcad="Select s10_nivusu as nivel,"+;
					     "  IfNull(s19_codidi,'') as idioma,"+;
					     "  IfNULL(s10_coddbf,'') as coddbf,"+;
					     "  IfNULL(s10_perfil,'') as perfil "+;
						 "	From SYS_TABLA_USUARIOS_S10 "+;
						" Where Upper(s10_usuario)=Upper('"+Ocnx.Usuario+"')"
				ENDIF
				IF Ocnx.Tipo_BD=2  
					lcad="Select s10_nivusu as nivel,"+;
					     "  Nvl(s19_codidi,'') as idioma,"+;
					     "  Nvl(s10_coddbf,'') as coddbf,"+;
					     "  Nvl(s10_perfil,'') as perfil "+;
						 "	From "+Ocnx.Esquema+".SYS_TABLA_USUARIOS_S10 "+;
						" Where Upper(s10_usuario)=Upper('"+Ocnx.Usuario+"')"
				ENDIF


			    IF This.Tipo_bd = 1 OR This.Tipo_bd = 3 OR Ocnx.Tipo_BD=2  
					IF SQLEXEC(This.Conexion,lcad,"Tnivel")<0
					   MESSAGEBOX(MESSAGE()+CHR(13)+lcad,16,"Verifica Usuario")
					   RETURN .F.
					EndIf    
				ENDIF

			    IF This.Tipo_bd = 4
			    
			    	IF This.Ms_ejecuta_sql(lcad,"Tnivel")<0 
					   &&IF !This.Ejecuta_uniflex(lcad,"Tnivel",0,"1") 
				   	   RETURN .F.
				   ENDIF
				   
				ENDIF

			    IF EOF()
					MessageBox("Usuario Existe en la Base de Datos "+;
							   "pero No a sido Registrado en el Sistema",64,"Verifica Usuario")
					RETURN .f.		   
				ELSE
				=AFIELDS(lcamarre,"Tnivel")   


				IF TYPE("Oentorno")=="O"
					lcad="Select MIN(s19_codidi) as s19_codidi "+;
						 "From SYS_TABLA_IDIOMAS_S19 "+;
						 "Where s19_nomidi like '%INGLES%' "
						 
					    IF This.Tipo_bd = 1 OR This.Tipo_bd = 3 OR Ocnx.Tipo_BD=2  
							IF SQLEXEC(This.Conexion,lcad,"Tidiing")<0
							   MESSAGEBOX(MESSAGE()+CHR(13)+lcad,16,"Verifica Usuario")
							   RETURN .F.
							EndIf    
						ENDIF

					    IF This.Tipo_bd = 4
					    
					    	IF This.Ms_ejecuta_sql(lcad,"Tidiing")<0 
							   &&IF !This.Ejecuta_uniflex(lcad,"Tnivel",0,"1") 
						   	   RETURN .F.
						   ENDIF
						   
						ENDIF

						IF USED("Tidiing")
							Oentorno.Idioma_Ingles=NVL(Tidiing.s19_codidi,"")  
							USE IN "Tidiing"
						ENDIF

				ENDIF

				    
			   This.Nivel       = Tnivel.nivel
			   This.Idioma      = Tnivel.idioma
			   This.Usuario_dbf = Tnivel.coddbf
			   IF ASCAN(lcamarre,UPPER("perfil"))>0
					This.usuario_perfil = NVL(Tnivel.perfil,"")
			   ENDIF

			   
			   IF ASCAN(lcamarre,UPPER("codalm"))>0
					This.almacen_default = NVL(Tnivel.codalm,"")
			   ENDIF
			   IF ASCAN(lcamarre,UPPER("codtie"))>0
					This.tienda_default = NVL(Tnivel.codtie,"")
			   ENDIF
			   IF ASCAN(lcamarre,UPPER("codser"))>0
					This.serie_default = NVL(Tnivel.codser,"")
			   ENDIF

				EndIf 
				IF USED("Tnivel")
				   USE IN "Tnivel"
				ENDIF
				WAIT Clea
				IF This.Idioma<>"CA" 
					Otbr.menu_opciones()
				ENDIF

			ELSE
			   MESSAGEBOX("FALTA ALGUN DATO PARA VERIFICAR AL USUARIO",64,"Conexion")
			   RETURN .f.
			EndIf
		ENDIF
	ENDPROC


	*-- Si esta envia como parametro 1 pondra la conexion de Modo Asincrono (pretederminado), 2  Modo Transaction
	PROCEDURE modo
		LPARAMETERS lmodo

		IF PARAMETERS()=0 OR !TYPE("lmodo")=="N" OR !BETWEEN(lmodo,1,2)
		    MESSAGEBOX("El Metodo Modo tiene que enviarsele el Parametro 1 o 2",64,"MODO")
		    RETURN .f.
		ENDIF

		IF lmodo=1
		*!*	   IF UPPER(ALLTRIM(This.Configuracion))=="TRANSACTIONS"  AND This.Parametro=2
		*!*		  This.Parametro=1
		*!*		  This.Configura() 
		*!*	   ENDIF
		   This.Configuracion="Transactions"  
		   This.Parametro=1
		ENDIF

		IF lmodo=2
		   This.Configuracion="Transactions" 
		   This.Parametro=2
		ENDIF
		This.Configura() 
	ENDPROC


	*-- Este metodo devuelve la fecha y la hora del Servidos GETDATE()
	PROCEDURE fecha_hora
		PRIVATE lcnxarea,lcnxcad,lcnxfechahora


		lcnxarea=SELECT()

		lcnxcad="Select Getdate() as Fecha_Hora "

		IF This.tipo_bd = 2
			lcnxcad="Select sysdate as Fecha_Hora From dual "
		ENDIF

		IF This.Tipo_BD=1 OR This.tipo_bd=2
			IF SQLEXEC(This.Conexion,lcnxcad,"TfechaHora")<0
			   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+CHR(13)+lcnxcad,16,"Fecha Hora")
			   RETURN DATETIME()
			ENDIF
		ENDIF
		PRIVATE ldatasession
		ldatasession=SET("Datasession") 

		IF This.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lcnxcad,"TfechaHora",ldatasession)<0
			   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+CHR(13)+lcnxcad,16,"Fecha Hora")
			   RETURN DATETIME()
			ENDIF
		ENDIF

		lcnxfechahora=TfechaHora.Fecha_Hora

		IF USED("TfechaHora")
		   USE IN "TfechaHora"
		ENDIF

		SELECT (lcnxarea)

		RETURN lcnxfechahora
	ENDPROC


	PROCEDURE ejecuta_uniflex
		*!*	LPARAMETERS lp_cad,lp_alias,lp_datasession,lp_crea 

		*!*	IF PARAMETERS()=0
		*!*	   MESSAGEBOX("FALTAN PARAMETROS ADICIONALES")
		*!*	   RETURN .F.
		*!*	ENDIF
		*!*	IF TYPE("lp_alias")<>"C"
		*!*		MESSAGEBOX("EL PARAMETRO ENVIADO TIENE QUE SER DE TIPO CADENA")
		*!*		RETURN 
		*!*	ENDIF


		*!*	IF !EMPTY(lp_datasession) AND TYPE("lp_datasession")=="N" AND lp_datasession>0
		*!*	   SET DATASESSION TO lp_datasession
		*!*	ENDIF

		*!*	PRIVATE loapp,loxml,lsele

		*!*	IF PARAMETERS()=4
		*!*		&&This.SqlWebService = CREATEOBJECT("SQLWebService.SQLEXEC")
		*!*		lcontinua=.T.
		*!*		&&TRY
		*!*			This.SqlWebService = CREATEOBJECT("ProxySQLWebService.SQLEXEC")
		*!*			This.SqlWebService.Proxy =This.Proxy 
		*!*		&&CATCH TO lerro
		*!*		&&	lcontinua=.F.
		*!*		&&	MESSAGEBOX(lerro.message)
		*!*		&&ENDTRY
		*!*		IF !lcontinua
		*!*			RETURN .F.
		*!*		ENDIF
		*!*	ENDIF


		*!*	&&loxml=loapp.Ejecutar(lp_cad)
		*!*	SET MESSAGE TO "Ejecutando XML..."+lp_alias
		*!*	loxml=""
		*!*	lcontinua=.T.
		*!*	&&TRY
		*!*		loxml=This.SqlWebService.Ejecutar(lp_cad,This.Usuario,This.Password)
		*!*	&&CATCH TO lerro
		*!*	&&	MESSAGEBOX(lerro.message,16,"Error en XML")
		*!*	&&	lcontinua=.F.
		*!*	&&ENDTRY
		*!*	WAIT Clea
		*!*	IF !lcontinua
		*!*		RETURN .F.
		*!*	ENDIF


		*!*	IF LEN(loxml)=0
		*!*	   MESSAGEBOX("NO DEVUELVE DATOS XML: "+CHR(13)+lp_cad,16,"XML")
		*!*	   RETURN .F.
		*!*	ENDIF

		*!*	XMLTOCURSOR(loxml,lp_alias,This.Flag_xml )

		*!*	This.Flag_xml=0
		*!*	IF USED(lp_alias)
		*!*	   lsele="Select '"+lp_alias+"'"
		*!*	   &lsele
		*!*	ENDIF


		*!*	RELEASE loapp
		*!*	RETURN 
	ENDPROC


	PROCEDURE insert_uniflex
		*!*	LPARAMETERS lp_cad as Character ,lp_esquema as Character,lp_nodo as Character,lp_exec as Character


		*!*	RETURN LRETU
	ENDPROC


	PROCEDURE ms_ejecuta_sql
		LPARAMETERS lp_cadena as String ,lp_alias as String ,lp_datasession as Integer, lp_varios as Boolean  

		PRIVATE lrsession


		lrsession=SET("Datasession")

		IF PARAMETERS()=3 AND TYPE("lp_datasession")=="N"
		   SET DATASESSION TO  lp_datasession
		ENDIF

		IF PARAMETERS()<3 AND This.Tipo_bd = 4
			lp_datasession=SET("Datasession")
			IF lp_datasession>0
				SET DATASESSION TO  lp_datasession
			ENDIF
		ENDIF


		IF (This.Tipo_bd = 1 OR This.Tipo_bd = 3 OR This.Tipo_bd = 2)
			IF SQLEXEC(This.Conexion,lp_cadena,lp_alias)<0
				This.ErrorMensaje=MESSAGE()
				IF  lrsession>0
					SET DATASESSION TO  lrsession
				ENDIF

				RETURN -1
			ENDIF
		ENDIF

		IF This.Tipo_bd = 4
		   ldori=lp_datasession
		   &&IF !This.Ejecuta_uniflex(lp_cadena,lp_alias,lp_datasession)
		   IF !This.SQLexecxml(lp_cadena,lp_alias,lp_datasession,lp_varios)
			   This.ErrorMensaje=MESSAGE() 
			   IF lrsession>0
			   	  SET DATASESSION TO  lrsession
			   ENDIF
			   
			   RETURN -1
		   ENDIF
		   SET DATASESSION TO  ldori
		ENDIF 

		*!*	TRY 
		*!*		IF lrsession>0
		*!*			SET DATASESSION TO  lrsession
		*!*		ENDIF
		*!*	CATCH TO lerro
		*!*		MESSAGEBOX(lerro.message+CHR(13)+'Session: '+STR(lrsession,16),16,"Session")
		*!*	ENDTRY 

		RETURN 1
	ENDPROC


	PROCEDURE arma_xml
		LPARAMETERS lused as String,lnoentra as String,labierta as Boolean,lregistro as int,lsession as Number 


		IF EMPTY(lsession) AND TYPE("lsession")=="N"
			This.Session = lsession
		ENDIF

		SET DATASESSION TO This.Session

		IF PARAMETERS()=0
			MESSAGEBOX("Falta Parametros","Arma_XML")
			RETURN .F.
		ENDIF

		IF EMPTY(lnoentra)
			lnoentra=""
		ENDIF

		IF EMPTY(lregistro)
			lregistro=0
		ENDIF


		IF TYPE("lused")<>"C"
			MESSAGEBOX("Tiene que Enviar como parametro el nombre de la Tabla",16,"Arma_XML")
			RETURN ""
		ENDIF

		IF !USED(lused)
			SET MESSAGE TO "Cursor o Tabla "+lused+" No Esta Abierto o No Existe"
			RETURN ""
		ENDIF


		PRIVATE lsele,lrecno,larean,lcxml,lnucam,lArray,lcampo,ldato
		lcxml=""
		larean=SELECT()
		lsele="Select '"+lused+"'"
		&lsele

		IF lregistro<>0
		   SET FILTER TO RECNO()=lregistro
		ENDIF
		COUNT TO lx
		GO top 

		IF lx=0
		   RETURN ""
		ENDIF
		   
		IF lregistro<>0
			SCAN
				IF RECNO()=lregistro
					EXIT
				ENDIF
			ENDSCAN
		ENDIF


		IF LEN(ALLTRIM(lnoentra))>0
			SET FIELDS ON 
			&lsele
			SET FIELDS TO ALL EXCEPT &lnoentra
		ENDIF

		   

		lxmlData = ""
		lxmlDataCursor = ""
		CURSORTOXML(ALIAS(), "lxmlDataCursor", 3, 0)

		IF lregistro<>0
			SCAN
				IF RECNO()=lregistro
					EXIT
				ENDIF
			ENDSCAN
		ENDIF


		SET FIELDS Off
		SET FILTER TO 


		lxmlDataCursor=STRTRAN(lxmlDataCursor,'<?xml version = "1.0" encoding="Windows-1252" standalone="yes"?>','')
		lxmlDataCursor=STRTRAN(lxmlDataCursor,'<VFPData>','')
		lxmlDataCursor=STRTRAN(lxmlDataCursor,'</VFPData>','')
		lxmlDataCursor=ALLTRIM(lxmlDataCursor)
		lxmlDataCursor=ALLTRIM(STRTRAN(lxmlDataCursor,"<row ","<"+ALIAS()+" "))
		lcxml=ALLTRIM(lxmlDataCursor)
				&&This.Crea_archivo(lxmlDataCursor) 

		*!*			FOR ln=1 TO lx
		*!*				lcxml = STREXTRACT(lxmlDataCursor,"<","/>",ln)
		*!*				lcxml = RIGHT(lcxml,LEN(lcxml)-3)
		*!*				lTagFin=""
		*!*				IF !labierta
		*!*					lTagFin = IIF(ALLTRIM(this.Name)<>'CABECERA','/>','>') 
		*!*				ELSE
		*!*					lTagFin = '>'
		*!*				ENDIF
		*!*				lxmlData = lxmlData + '<'+UPPER(ALLTRIM(ALIAS()))+' '+lcxml+lTagFin 
		*!*			ENDFOR 

					lTagFin=""
					IF labierta
						lcxml=STRTRAN(lcxml,'/>','>')
					ENDIF


		*!*	lnucam=AFIELDS(lArray,lused)  
		*!*	lrecno=RECNO()
		*!*	GO top
		*!*	lcondi=" 1=1 "

		*!*	IF lregistro
		*!*	   lcondi=" Recno()=lrecno "
		*!*	ENDIF


		*!*	SCAN FOR &lcondi
		*!*		lcxml=lcxml+SPACE(5)+'<'+lused+'>'+CHR(13)
		*!*		FOR ln=1 TO lnucam
		*!*			ldato=""
		*!*			lcampo=lArray[ln,1]
		*!*			&&IF !EMPTY(NVL(&lcampo,''))
		*!*				DO Case
		*!*				   CASE TYPE(lcampo)=="C"
		*!*						ldato =  NVL(&lcampo,"") 
		*!*				   CASE TYPE(lcampo)=="N"
		*!*				        ldato =  STR( NVL(&lcampo,0) ,lArray[ln,3],lArray[ln,4])
		*!*				   CASE TYPE(lcampo)=="T"
		*!*				        ldato =  NVL(TTOC( &lcampo ),"")
		*!*				   CASE TYPE(lcampo)=="D"
		*!*				        ldato =  NVL(DTOC( &lcampo ),"")
		*!*				ENDCASE
		*!*				ldato=NVL(ldato,"")
		*!*				IF !UPPER(lcampo)$UPPER(lnoentra)
		*!*					lcxml=lcxml+SPACE(15)+"<"+LOWER(lcampo+">")+ALLTRIM(ldato)+LOWER("</"+lcampo+">")+CHR(13)
		*!*				ENDIF
		*!*			&&ENDIF
		*!*		ENDFOR
		*!*		IF !labierta
		*!*			lcxml=lcxml+SPACE(5)+'</'+lused+'>'+CHR(13)
		*!*		ENDIF
		*!*		&lsele
		*!*	ENDSCAN


		*!*	GO top
		*!*	SCAN
		*!*		IF RECNO()=	lrecno
		*!*			Exit
		*!*		ENDIF
		*!*	ENDSCAN
		*!*	SELECT(larean)

		RETURN lcxml
	ENDPROC


	PROCEDURE inicializa_secuencia
		PRIVATE ln

		FOR ln=1 TO 10
			This.Secuencia_xml[ln,1]="" 
			This.Secuencia_xml[ln,2]=-1
			This.Secuencia_xml[ln,3]=""
		ENDFOR
	ENDPROC


	PROCEDURE mensaje
		LPARAMETERS lcadmen as Character ,lboton as Number,licon as Number

		lnumpar=PARAMETERS()

		PRIVATE ltxtodbc,lretnum

		ltxtodbc="[Microsoft][ODBC SQL Server Driver][SQL Server]"

		lcadmen=STRTRAN(lcadmen,ltxtodbc,"")

		IF lnumpar=1
			lretnum=MESSAGEBOX(lcadmen)
		ENDIF
		IF lnumpar=2
			lretnum=MESSAGEBOX(lcadmen,lboton)
		ENDIF
		IF lnumpar=3
			lretnum=MESSAGEBOX(lcadmen,lboton,licon)
		ENDIF


		RETURN lretnum
	ENDPROC


	PROCEDURE inserta_xml
		LPARAMETERS lp_cad as Character,lp_esquema as Character, lp_nodo as Character,lp_exec as Character   
		IF PARAMETERS()<3
		   MESSAGEBOX("FALTAN PARAMETROS ADICIONALES",16,"Inserta XML")
		   RETURN .F.
		ENDIF

		IF EMPTY(lp_exec)
			lp_exec=""
		ENDIF

		PRIVATE lretu,xobj 

		lretu=.T.

		&&TRY 
			xobj  = CREATEOBJECT("ProxySQLWebService.SQLEXEC")
			xobj.Proxy =This.Proxy 
			lretorno=xobj.InsertarXML(lp_cad,lp_esquema,lp_nodo,lp_exec,This.Usuario,This.Password)
		&&CATCH TO lerro
		&&	lretu=.F.
		&&	This.Mensaje(lerro.message+lretorno,"Inserta XML")
		&&FINALLY
		&&ENDTRY

		RETURN lretu
	ENDPROC


	PROCEDURE crea_archivo
		LPARAMETERS lpcad as String

		PRIVATE larcfile,lrutafile


		lrutafile=GETFILE()

		larcfile=FCREATE(lrutafile)

		IF larcfile>0
			=FPUTS(larcfile,lpcad)
			=FCLOSE(larcfile)
		ENDIF
	ENDPROC


	PROCEDURE sqlexecxml
		LPARAMETERS lp_cadena as String ,lp_alias as String ,lp_dataset as Integer, lp_varios as Boolean 

		IF EMPTY(lp_alias)
			lp_alias=""
		ENDIF
		SET MESSAGE TO "Ejecutando XML del Cursor "+lp_alias+"..."

		lxpara=PARAMETERS()

		PRIVATE lo,lxml,lsele 

		lsele="Select '"+lp_alias+"'"


		lo=CREATEOBJECT(This.Componenteweb)
		lo.UserName = ALLTRIM(This.Usuario) 
		lo.Password = ALLTRIM(This.Password) 
		lo.BaseDatos = ALLTRIM(This.Basedatos) 
		lo.Server = ALLTRIM(This.Servidor) 
		lo.Url_WebService = ALLTRIM(This.Url)
		lo.Use_ForXMLRAWSQL = .T.

		IF This.Proxy 
		  lo.UseProxy = This.Proxy
		  lo.UseAutenticationWin = This.Autentificacion_Windows 
		  lo.ServerProxy = This.Servidor_proxy 
		  lo.UserNameWin = This.usuario_windows 
		  lo.UserName = This.usuario_windows 
		  lo.PortProxy = This.Puerto_proxy 
		  lo.DomainWin = This.Dominio_windows 
		  lo.Password = This.Password_windows 
		  lo.PasswordWin = This.Password_windows 
		ENDIF 

		IF lp_varios
			lnumindex=0
			lo.UseStoreProcedures = .F.
			lo.UseSelectBatch = .T.
			IF ALEN(This.Secuencia_xml)>0
				FOR ln=1 TO 20
					IF 	TYPE("This.Secuencia_xml[ln,1]")=="C" AND TYPE("This.Secuencia_xml[ln,2]")=="C" AND ;
						!EMPTY(This.Secuencia_xml[ln,1])
						lo.Agrega_Querys(This.Secuencia_xml[ln,1],This.Secuencia_xml[ln,2],"0")
						lnumindex=lnumindex+1
					ENDIF
				ENDFOR 
			ENDIF
			If lo.SQLQueryBatch()
				FOR ln=1 TO 20
					IF 	TYPE("This.Secuencia_xml[ln,1]")=="C" AND TYPE("This.Secuencia_xml[ln,2]")=="C" AND ;
						!EMPTY(This.Secuencia_xml[ln,1])

						lxml = lo.CursorXML(ln-1)
						XMLTOCURSOR(lxml,This.Secuencia_xml[ln,2],1)
					ENDIF
				ENDFOR 
			ELSE
				MESSAGEBOX(lo.MensajeError,16,lp_alias)
				RETURN .F.
			ENDIF
			FOR ln=1 TO 20
				This.Secuencia_xml[ln,1]=""
				This.Secuencia_xml[ln,2]=""
			ENDFOR 


		ENDIF

		IF !lp_varios
			lxml=""
			lxml = lo.SqlQuery(lp_cadena,lp_alias,"0")

			IF lo.ExistsError
				MESSAGEBOX(lo.MensajeError+CHR(13)+lp_cadena,16,lp_alias)
				RETURN .F.
			ENDIF


			IF LEN(lxml)=0
				Ocnx.ErrorMensaje="Error en la Sentencia SQL para el XML"
				RETURN .F.
			ENDIF
		ENDIF

		IF lxpara>2
			SET DATASESSION TO lp_dataset
		ENDIF
		XMLTOCURSOR(lxml,lp_alias,1)
		&lsele
		SET MESSAGE TO 
		RELEASE lo
	ENDPROC


	PROCEDURE ms_inserta_sql
		LPARAMETERS lp_alias as String, lp_xml as String, lp_schemas as String, lp_storeprocedure as String 

		o = CREATEOBJECT(This.Componenteweb)
		o.UserName = This.Usuario 
		o.Password = This.Password 
		o.BaseDatos = This.Basedatos 
		o.Server = This.Servidor 
		o.Url_WebService = This.Url 
		lurl=STRTRAN(This.Url ,"Service_sql.asmx","")
		o.Use_ForXMLRAWSQL = .T.
		o.NameSchema = ALLTRIM(lurl)+"Schemas/"+lp_schemas+".xml"
		o.UseStoreProcedures = .T.

		IF This.Proxy 
		  o.UseProxy = This.Proxy
		  o.UseAutenticationWin = This.Autentificacion_Windows 
		  o.ServerProxy = This.Servidor_proxy 
		  o.UserNameWin = This.usuario_windows 
		  o.UserName = This.usuario_windows 
		  o.PortProxy = This.Puerto_proxy 
		  o.DomainWin = This.Dominio_windows 
		  o.Password = This.Password_windows 
		  o.PasswordWin = This.Password_windows 
		ENDIF 

		IF This.Proxy 
			o.NameSchema= ALLTRIM(This.Ruta_esquema_local)+lp_schemas+".xml" 
		ENDIF


		lp_xml = '<ROOT xmlns:updg="urn:schemas-microsoft-com:xml-updategram">'+;
				 '<updg:sync mapping-schema="'+o.NameSchema+'" >'+;
				 '<updg:before>'+;
				 '</updg:before>'+;
		    	 '<updg:after>'+;
		    	 lp_xml+;
		    	 '</updg:after>'+;
				 '</updg:sync>'+;
				 '</ROOT>'

		&&This.Crea_archivo(lp_xml) 

		o.Agrega_SP(lp_storeprocedure)
		lb_graba=.F.
		o.InsertXML(lp_xml,"")
		IF o.ExistsError = .T.
			MESSAGEBOX(o.MensajeError)
			RELEASE o
			RETURN -1
		ELSE
			RELEASE o
			&&MESSAGEBOX("Actualizacion termino con Exito..!")
			RETURN 1
		ENDIF
	ENDPROC


	PROCEDURE ms_inserta_parametro_sql
		LPARAMETERS lp_alias as String, lp_xml as String, lp_schemas as String, lp_storeprocedure as String , ;
					lp_nameprocedure as String 

		o = CREATEOBJECT(This.Componenteweb)
		o.UserName = This.Usuario 
		o.Password = This.Password 
		o.BaseDatos = This.Basedatos 
		o.Server = This.Servidor 
		o.Url_WebService = This.Url 
		lurl=STRTRAN(This.Url ,"Service_sql.asmx","")
		o.Use_ForXMLRAWSQL = .T.
		o.NameSchema = ALLTRIM(lurl)+"Schemas/"+lp_schemas+".xml"

		IF This.Proxy 
		  o.UseProxy = This.Proxy
		  o.UseAutenticationWin = This.Autentificacion_Windows 
		  o.ServerProxy = This.Servidor_proxy 
		  o.UserNameWin = This.usuario_windows 
		  o.UserName = This.usuario_windows 
		  o.PortProxy = This.Puerto_proxy 
		  o.DomainWin = This.Dominio_windows 
		  o.Password = This.Password_windows 
		  o.PasswordWin = This.Password_windows 
		ENDIF 

		IF This.Proxy 
			o.NameSchema= ALLTRIM(This.Ruta_esquema_local)+lp_schemas+".xml" 
		ENDIF


		o.UseStoreProcedures = .T.
		o.UseSP_Parametros = .T.


		lp_xml = '<ROOT xmlns:updg="urn:schemas-microsoft-com:xml-updategram">'+;
				 '<updg:sync mapping-schema="'+o.NameSchema+'" >'+;
				 '<updg:before>'+;
				 '</updg:before>'+;
		    	 '<updg:after>'+;
		    	 lp_xml+;
		    	 '</updg:after>'+;
				 '</updg:sync>'+;
				 '</ROOT>'


		o.Agrega_SP(lp_storeprocedure)

		o.Agrega_NameSP(lp_nameprocedure)

		lb_graba=.F.

		o.Agrega_Parametros_SP(ls_SP,"@dato","12",0,0,10)
		o.Agrega_Parametros_SP(ls_SP,"@dato2","",2,0,10)

		ls_SP = "PA_Prueba_SP2"
		o.Agrega_NameSP(ls_SP)
		o.Agrega_Parametros_SP(ls_SP,"@dato3","12",0,0,10)
		o.Agrega_Parametros_SP(ls_SP,"@dato4","",2,0,10)


		lb_result = .F.
		lb_result = o.InsertXML_SP_Parametros(lcadClie2,"")

		IF o.ExistsError = .T.
			MESSAGEBOX(o.MensajeError)
			ls_cad = o.DatoParametroCadena(0)
			MESSAGEBOX(ls_cad)
			ls_cad = o.DatoParametroCadena(1)
			MESSAGEBOX(ls_cad)
			RELEASE o
		ELSE
			&&XMLTOCURSOR(lxml,'TCur',1)
			MESSAGEBOX("Actualizacion termino con Exito..!")
			FOR ln_i=1 TO o.NumeroParametros
				ls_cad = o.DatoParametroCadena(ln_i-1)
				MESSAGEBOX(ls_cad)
			ENDFOR 


			RELEASE o
		ENDIF
		RELEASE o
		RETURN
	ENDPROC


	PROCEDURE ms_sentencia_sql
		LPARAMETERS lp_alias as String, lp_exec as String, lp_schemas as String, lp_xml as String 

		o = CREATEOBJECT(This.ComponenteWeb)
		o.UserName = This.Usuario 
		o.Password = This.Password 
		o.BaseDatos = This.Basedatos 
		o.Server = This.Servidor 
		o.Url_WebService = This.Url 
		lurl=STRTRAN(This.Url ,"Service_sql.asmx","")
		o.Use_ForXMLRAWSQL = .T.
		loksc=.T.

		IF This.Proxy 
		  o.UseProxy = This.Proxy
		  o.UseAutenticationWin = This.Autentificacion_Windows 
		  o.ServerProxy = This.Servidor_proxy 
		  o.UserNameWin = This.usuario_windows 
		  o.UserName = This.usuario_windows 
		  o.PortProxy = This.Puerto_proxy 
		  o.DomainWin = This.Dominio_windows 
		  o.Password = This.Password_windows 
		  o.PasswordWin = This.Password_windows 
		ENDIF 

		IF !EMPTY(lp_schemas)
			o.NameSchema = ALLTRIM(lurl)+"Schemas/"+lp_schemas+".xml"
			IF This.Proxy 
				o.NameSchema= ALLTRIM(This.Ruta_esquema_local)+lp_schemas+".xml" 
			ENDIF

		ELSE
			loksc=.F.
			lp_schemas=""
		ENDIF

		IF EMPTY(lp_xml)
			lp_xml=""
		ELSE
			IF TYPE("lp_xml")=="C"
				lp_xml = '<ROOT xmlns:updg="urn:schemas-microsoft-com:xml-updategram">'+;
				 '<updg:sync mapping-schema="'+o.NameSchema+'" >'+;
				 '<updg:before>'+;
				 '</updg:before>'+;
		    	 '<updg:after>'+;
		    	 lp_xml+;
		    	 '</updg:after>'+;
				 '</updg:sync>'+;
				 '</ROOT>'

			ENDIF

		ENDIF

		o.UseStoreProcedures = .T.


		&&Agrega SP a ejecutar despues del insert en tablas
		o.Agrega_SP(lp_exec)

		lb_result = .F.
		lb_result = o.ExecuteSQL_And_InsertXML(lp_xml,"",loksc)
		lb_graba=.F.
		IF o.ExistsError = .T.
			MESSAGEBOX(o.MensajeError+CHR(13)+lp_exec,16,"Sentencia SQL (WEB)")
			RELEASE o
			RETURN -1
		ELSE
			WAIT wind "Actualizacion termino con Exito..!" NoWait
			IF o.NumeroParametros>0
				DIMENSION This.Parametro_devuelto[o.NumeroParametros] 
				FOR ln_i=1 TO o.NumeroParametros
					This.Parametro_devuelto[ln_i]  = o.DatoParametroCadena(ln_i-1)
				ENDFOR 
			ENDIF
		ENDIF
		RELEASE o
		RETURN 1
	ENDPROC


	PROCEDURE ejecutacmdoracle
		LPARAMETERS sSQL as String 
		lcontinua=.F.

		*!*	ldriver=ALLTRIM(NVL(This.Driver,""))
		*!*	This.CadenaConexion="DRIVER="+ldriver+";DBQ="+ALLTRIM(This.Tns)+";UID=cpalaco"+;
		*!*				    		  ";PWD=carpal"+";EXC=T;NUM=MS"
					    		  
			IF LEN(This.CadenaConexion)>0 then
			    ncnx = SQLSTRINGCONNECT(This.CadenaConexion)
			ELSE
				ncnx = SQLCONNECT(ALLTRIM(This.odbc),This.usuario,This.Password)
			ENDIF
			IF SQLSETPROP(ncnx,"Transactions",2)>0
				&&MESSAGEBOX(sSQL)
				IF SQLEXEC(ncnx,sSQL)<0
					This.ErrorMensaje=MESSAGE()+CHR(13)+sSQL 
					=SQLROLLBACK(ncnx)
					=SQLDISCONNECT(ncnx)
					lcontinua=.F.
				ELSE
					=SQLCOMMIT(ncnx)
					lcontinua=.T.
				ENDIF
			ELSE
				This.ErrorMensaje=MESSAGE()
				=SQLDISCONNECT(ncnx)
				lcontinua=.F.
			ENDIF
			IF lcontinua
				=SQLSETPROP(ncnx,"Transactions",1) 
				=SQLDISCONNECT(ncnx)
				lcontinua=.T.
			ENDIF 

		ncnx=null
		RETURN lcontinua


		*!*		&&TRY
		*!*			This.SqlWebService = CREATEOBJECT("ProxySQLWebService.SQLEXEC")
		*!*			This.SqlWebService.Proxy =This.Proxy 
		*!*		&&CATCH TO lerro
		*!*		&&	lcontinua=.F.
		*!*		&&	MESSAGEBOX(lerro.message)
		*!*		&&ENDTRY
		*!*		IF !lcontinua
		*!*			RETURN .F.
		*!*		ENDIF
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Destroy
		IF This.Desconectar_Salir AND This.Conexion>0
		   This.desconectar()
		EndIf
	ENDPROC


	PROCEDURE ordena_secuencia_xml
	ENDPROC


ENDDEFINE
*
*-- EndDefine: conexion
**************************************************


**************************************************
*-- Class:        contenedor (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   08/14/06 12:00:12 PM
*
DEFINE CLASS contenedor AS container


	Width = 321
	Height = 28
	BackStyle = 0
	BorderWidth = 0
	datoobjeto = ("")
	Name = "contenedor"


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: contenedor
**************************************************


**************************************************
*-- Class:        cuadricula (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Time Stamp:   11/14/06 03:32:14 PM
*
DEFINE CLASS cuadricula AS grid


	FontName = "MS Sans Serif"
	FontSize = 8
	DeleteMark = .F.
	RowHeight = 16
	Width = 320
	GridLineColor = RGB(192,192,192)
	HighlightBackColor = RGB(187,255,187)
	HighlightForeColor = RGB(0,0,0)
	*-- En esta propiedad indique las columnas que Ud. quiere que aparescan en la Cuadricula
	campos = ("")
	*-- Se guarda el color el cual estara pintado el Registro cuando la propiedad PintarRegistro=.T.
	colorregistroseleccionado = (16777088)
	*-- Guarda el Numero de Registro en el cual se encuentra seleccionado
	registro = (0)
	*-- En esta propiedad Ingrese el Objeto de Tipo Dato que esta asociado a esta cuadricula
	datoobjeto = ("")
	*-- Almacena la ruta donde se encuentra la cuadricula = "Pageframe1.Page1."
	ruta = ("")
	*-- Si es .T. y el cursor esta vacio se creara automaticamente el Primer Item
	iniciar_primera_fila = .T.
	*-- Si esta en .T. podra Ingresar Nuevos Items
	habilita_nuevo_item = .T.
	*-- Si esta en .T. podrá eliminar items
	habilita_elimina_item = .T.
	*-- Si esta en .T. podrá insertar items
	habilita_inserta_item = .T.
	campo_busqueda = ("")
	Name = "cuadricula"

	*-- Si esta en .T. Pinta de un color al registro que se encuentra posicionado
	pintaregistro = .F.

	*-- Si la propiedad esta en .T. indica que se desea que al presionar la tecla ENTER la cuadricula pierda el foco
	enter_lostfocus = .F.

	*-- Indica si la propiedades ya se ajustaron
	indcadorajuste = .F.
	ajusteautomatico = .F.
	header = .F.

	*-- Si es .T. crea un indice por cada columna
	crea_indices_columnas = .F.
	orden_inicio = .F.

	*-- Matriz para definir el titulo de las columnas en Ingles, eso se define en el Metodo  Caption_Idioma
	DIMENSION caption_in[1]


	*-- Este Metodo Sirve para asociar una Tabla a un grid. Envie como parametro el objeto que control el cursor Eje: datos1
	PROCEDURE asociatabla
		LPARAMETERS lodata

		PRIVATE lcol,ln,lini,lpos,lfin,lo,lxcontinua
		lxcontinua=.T.
		IF Type("lodata")<>"O"
		   MESSAGEBOX("En este Metodo se Espera como Parametro El Objeto 'Datos' Asociado",16,"Error")
		   RETURN .F.
		Endif

		ThisForm.LockScreen=.T.
		TRY 
			This.RecordSource=SPACE(0)
			IF !EMPTY(lodata.alias)
			   IF !USED(lodata.alias)
			      lodata.Init()
			   ENDIF
			   IF !USED(lodata.alias)
			      ThisForm.LockScreen=.f.
			      lxcontinua=.F.
			      &&RETURN 
			   ENDIF
			   IF lxcontinua		   
					   lcsele="Select '"+lodata.alias+"'"
					   &lcsele
					   IF !EMPTY(This.Campos) 
						   SET FIELDS ON 
						   lsetfield="Set Fields to "+This.campos
						   &lsetfield
					   ENDIF
					   This.RecordSource=lodata.alias
					   
					   IF !EMPTY(This.Campos) AND This.ColumnCount>0  
					      lini=1
					   	  lpos=0
					   	  If ","$This.Campos
						      lcol=1
						      FOR ln=1 TO 30
					    		  lpos=ATC(",",This.Campos,ln)
					    	  	  IF lpos>0 
					    	  	     lfin=(lpos) - lini
					    	  	     FOR lo=1 TO This.ColumnCount
								    	 IF This.Columns[lo].ColumnOrder=lcol
								    	 	This.Columns[lo].ControlSource=ALLTRIM(lodata.alias)+"."+SUBSTR(This.Campos,lini,lfin)
								    	 	Exit
								    	 ENDIF
								     ENDFOR
							    	 lini=lpos + 1
							    	 lcol=lcol+1
							    	 IF lcol>This.ColumnCount
							    	    Exit
							    	 ENDIF
					    		  ELSE
					    		     FOR lo=1 TO This.ColumnCount
					    		         IF This.Columns[lo].ColumnOrder=lcol
							    		    This.Columns[lo].ControlSource=ALLTRIM(lodata.alias)+"."+SUBSTR(This.Campos,lini,LEN(ALLTRIM(This.Campos)))
							    		    Exit
							    		 ENDIF
						    		 ENDFOR
						         	 Exit  
						      	  EndIf
							  ENDFOR
					   	  ELSE
					   	     This.Columns[1].ControlSource=ALLTRIM(lodata.alias)+"."+Allt(This.Campos)
					   	  ENDIF
					   ENDIF
					   
					   IF This.AjusteAutomatico
						   This.AjustaPropiedades() 
						   This.AutoFit() 
					   ENDIF
					   lcsele="Select '"+lodata.alias+"'"
					   &lcsele
					   SET FIELDS TO 
					   SET FIELDS OFF
					   IF This.Crea_indices_columnas 
					   	  PRIVATE liord,lsetindx
					   	  SELECT (lodata.Area)
					   	  liord=tag()
					   	  This.Cambia_Header()  
					   	  IF !This.Orden_inicio
					   	  	  SELECT (lodata.Area)
					   	  	  SET ORDER TO &liord	 
					   	  	  This.Orden_inicio=.T.
					   	  ENDIF
					   	  	  
					   ENDIF

						&&&&&&&&&&&&&&&&&& Cambia titulo de los Headers a Ingles 
						IF This.ColumnCount>0 AND Ocnx.idioma<>Oentorno.Idioma_Castellano
							IF TYPE("Ocnx")=="O"
							   DIMENSION This.Caption_In[This.ColumnCount] 
							   This.Caption_Idioma() 
						   	   PRIVATE lcc,lc2
						   	   FOR lcc=1 TO This.ColumnCount 
						   	       FOR lc2=1 TO This.ColumnCount 
						   	       	   IF This.Columns[lc2].ColumnOrder=lcc
									      IF Ocnx.idioma=Oentorno.Idioma_Ingles AND !EMPTY(NVL(This.Caption_in[lcc],"")) && Ingles 
									      	 IF TYPE("This.Columns[lc2].Header1")=="O"
										         This.Columns[lc2].Header1.Caption=This.Caption_in[lcc]
										         EXIT
									         ENDIF
									      ENDIF
									   ENDIF
								   ENDFOR
							   ENDFOR
							ENDIF
						ENDIF
				ENDIF
				&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			   
			ENDIF
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+CHR(13)+MESSAGE(1),16,This.Name) 
		ENDTRY

		ThisForm.LockScreen=.f.
		This.Refresh()

	ENDPROC


	*-- En este metodo se ajusta las propieadades Deacuerdo al la tabla es decir: El Ancho de la Columnas , Tipo de Letra Default
	PROCEDURE ajustapropiedades
		PRIVATE lcurdir,lsetfield,lsele

		lcurdir=SELECT()
		IF !This.IndcadorAjuste 
		   IF !EMPTY(This.Campos) 
		       lsele="SELECT '"+This.RecordSource+"'"
		       &lsele
			   lsetfield="Set Fields to "+This.campos
			   &lsetfield
		   ENDIF
		   This.ColumnCount=AFIELDS(larre,This.RecordSource )
		   FOR ln=1 TO This.ColumnCount
		       This.Columns[ln].ControlSource=ALLTRIM(This.RecordSource)+"."+ALLTRIM(larre[ln,1])
		       This.Columns[ln].FontName=This.FontName
		       &&This.Columns[ln].FontSize=This.FontSize
		*!*	       IF !TYPE(larre[ln,1])$"D,T"
		*!*		       llar=larre[ln,3]*8
		*!*		   ELSE
		*!*		       llar=larre[ln,3]*9
		*!*		   ENDIF
		*!*		       
		*!*	       llar=llar - Int(15*llar/100)
		*!*	       This.Columns[ln].Width=llar
		       IF This.ReadOnly
		          This.Columns(ln).ReadOnly=This.ReadOnly
		       ENDIF
		       This.Columns(ln).Header1.Caption=larre[ln,1]
		       This.Columns(ln).Header1.FontName=This.FontName
		       This.Columns(ln).Header1.FontSize=This.FontSize
		   ENDFOR
		   &&This.AutoFit() 
		   This.IndcadorAjuste=.t.
		   IF  !EMPTY(This.RecordSource) AND USED(This.RecordSource)
		       lsele="SELECT '"+This.RecordSource+"'"
		       &lsele
		   ENDIF
		   SET FIELDS OFF
		EndIf   
		SELECT (lcurdir)
	ENDPROC


	PROCEDURE nuevoitem
		IF !EMPTY(This.DatoObjeto) 
		    lcoma="ThisForm."+ALLTRIM(This.DatoObjeto)+".Nuevo()"
		    &lcoma
		    This.SetFocus()
		    This.Refresh()
		ENDIF
	ENDPROC


	PROCEDURE eliminaitem
		IF !EMPTY(This.DatoObjeto) 
		    lcoma="ThisForm."+ALLTRIM(This.DatoObjeto)+".Elimina()"
		    &lcoma
		    This.Refresh()
		ENDIF
	ENDPROC


	PROCEDURE insertaitem
		IF !EMPTY(This.DatoObjeto) 
		    lcoma="ThisForm."+ALLTRIM(This.DatoObjeto)+".Inserta()"
		    &lcoma
		    This.Refresh()
		ENDIF
	ENDPROC


	*-- Este Metodo se ejecuta para Armar la Ruta en que esta posicionada la Cuadricula y lo guarda el la Propiedad Ruta
	PROCEDURE armaruta
		PRIVATE lform,lname

		lobjeto=""
		lencontro=0
		DO WHILE lencontro=0
		   lcoma=""
		   IF EMPTY(lobjeto)
		      lobjeto="ThisForm"
		   ENDIF
		   
		   
		ENDDO
	ENDPROC


	*-- Agrega un Item si se esta en la ultima fila
	PROCEDURE item_automatico
		LPARAMETERS lpcol,ldesp

		IF EMPTY(lpcol)
		   lpcol=1
		ENDIF
		IF EMPTY(ldesp)
		   ldesp=3
		ENDIF


		PRIVATE larea,lselearea,lvercol,laccion,lrec,lcondi,lcontinuaitem
		lcontinuaitem=.T.
		larea=SELECT()
		IF !EMPTY(This.DatoObjeto)
		   
		   &&lcondi="TYPE('ThisForm."+ALLTRIM(This.DatoObjeto)+"')=='O'"
		   IF TYPE("ThisForm."+ALLTRIM(This.DatoObjeto))=="O" &&&lcondi
		       &&------------------------------------------------------------&&   
		       lused="ThisForm."+ALLTRIM(This.DatoObjeto)+".Alias"
		       PRIVATE laliasx
		       TRY 
			       laliasx="ThisForm."+ALLTRIM(This.DatoObjeto)+".Alias"
			       laliasx=&laliasx
			   CATCH TO lerror
			   		MESSAGEBOX(lerror.message+CHR(13)+lerror.details+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
			   		lcontinuaitem=.F.
			   ENDTRY
			       
		       IF !lcontinuaitem
		       	  RETURN 
		       ENDIF
		       IF EMPTY(NVL(laliasx,"")) OR !USED(&lused)
		       	   RETURN 
		       ENDIF
		       TRY 
				   lselearea="Select (ThisForm."+ALLTRIM(This.DatoObjeto)+".Area)"
				   &lselearea
				   IF !EOF() AND !BOF()
				      lrec=RECNO() 
				      SKIP 1
				      IF EOF() OR BOF()
				         SKIP -1
				         laccion="ThisForm."+ALLTRIM(This.DatoObjeto)+".Nuevo()"
				         &laccion
				         FOR lvercol=1 TO This.ColumnCount
				             IF This.Columns[lvercol].ColumnOrder=lpcol
				                This.Columns[lvercol].SetFocus()
				             ENDIF
				         ENDFOR  
				         This.DoScroll(ldesp)
				         This.Teclas_Botones() 
				         This.Refresh()
				      ENDIF
				   ENDIF
			   CATCH TO lerror
			   		MESSAGEBOX(lerror.message+CHR(13)+lerror.details,16,This.Name+"."+lerror.procedure) 
			   		lcontinuaitem=.F.
			   ENDTRY
		       &&------------------------------------------------------------&&   
		   ENDIF
		ENDIF
		SELECT (larea)
	ENDPROC


	*-- Este metodo activa los botones y las teclas para controlar los items
	PROCEDURE teclas_botones
		OtbrItem.BtnAgrega.Enabled=.f.
		OtbrItem.BtnElimina.Enabled=.f.
		OtbrItem.BtnInserta.Enabled=.f.

		ON KEY LABEL F2
		ON KEY LABEL F3
		ON KEY LABEL F4
		OtbrItem.DatosItem=""

		OtbrItem.BtnItemBusca.Enabled=.T.
		IF !This.ReadOnly
			OtbrItem.BtnAgrega.Enabled=This.Habilita_nuevo_item 
			OtbrItem.BtnElimina.Enabled=This.Habilita_elimina_item 
			OtbrItem.BtnInserta.Enabled=This.Habilita_inserta_item 

			IF  This.Habilita_nuevo_item 
				ON KEY LABEL F2 OtbrItem.BtnAgrega.Click()
			ENDIF
			IF 	This.Habilita_elimina_item 
				ON KEY LABEL F3 OtbrItem.BtnElimina.Click()
			ENDIF
			IF 	This.Habilita_inserta_item 
				ON KEY LABEL F4 OtbrItem.BtnInserta.Click()
			ENDIF
			OtbrItem.DatosItem=This.DatoObjeto
			OtbrItem.Grid=This
		ENDIF

		IF OtbrItem.BtnAgrega.Enabled OR OtbrItem.BtnElimina.Enabled OR OtbrItem.BtnInserta.Enabled
			OtbrItem.BtnMueveItem.Enabled=.T.
		ELSE
			OtbrItem.BtnMueveItem.Enabled=.F.
		ENDIF
	ENDPROC


	PROCEDURE reordena_columnas
		IF !EMPTY(This.RecordSource) AND This.ColumnCount > 0 AND !EMPTY(This.Campos) 
			PRIVATE lnc,lc2,lle,lcampo,lpos
			This.Campos=""
			FOR lnc=1 TO This.ColumnCount && Orden 
				FOR lc2=1 TO This.ColumnCount && Columnas
					IF This.Columns[lc2].ColumnOrder=lnc
						lle=LEN(This.Columns[lc2].ControlSource)
						lcampo=This.Columns[lc2].ControlSource
						lpos=AT(".",lcampo)
						lcampo=ALLTRIM(SUBSTR(lcampo,lpos + 1,lle))
						This.Campos=This.Campos+lcampo+","
					ENDIF
				ENDFOR
			ENDFOR
			IF LEN(This.Campos)>0
				This.Campos=LEFT(This.Campos,LEN(This.Campos)-1)
			ENDIF

		ENDIF
	ENDPROC


	PROCEDURE copia_excel
		IF !EMPTY(This.RecordSource) AND USED(This.RecordSource)
			PRIVATE lsele,lfile,lcopy,larea
			larea=SELECT()
			lsele="Select '"+ALLTRIM(This.RecordSource)+"'" 
			&lsele
			lfile=UPPER(GETFILE("XLS"))
			lfile=STRTRAN(lfile,".XLS","")
			IF !EMPTY(This.Campos)
				lset="SET FIELDS TO "+ALLTRIM(This.Campos)
				&lset
			ENDIF

			lcopy="Copy to '"+lfile+"' type xls"
			&lcopy
			SET FIELDS TO 
			SET FIELDS OFF
			SELECT (larea)
		ENDIF
	ENDPROC


	PROCEDURE ordena
		Lparameters pColumna, pCampo
		Local cCaption,cFont,lWordWrap,cPicture
		PRIVATE lnxx,lcanarr,lcomando,lname,lveri
		TRY 
			lname=""
			lcanarr=AMEMBERS(larremember,pColumna,1)
			FOR lnxx=1 TO lcanarr
				IF UPPER(larremember[lnxx,2])=="OBJECT"
		 			lveri=" Upper(pColumna."+ALLTRIM(larremember[lnxx,1])+".Class)=='HEADER'"
					IF &lveri
						lcomando="pColumna."+ALLTRIM(larremember[lnxx,1])+".Name"
						lname=ALLTRIM(&lcomando)
						EXIT
					ENDIF
				ENDIF
			ENDFOR

			IF !EMPTY(lname)
				lcomando = "pColumna."+lname+".Caption"
				cCaption = &lcomando
				lcomando = "pColumna."+lname+".FontName"
				cFont	 = &lcomando
				lcomando = "pColumna."+lname+".WordWrap"
				lWordWrap= &lcomando
				lcomando = "pColumna."+lname+".Picture"
				cPicture = &lcomando
				pColumna.RemoveObject(lname)
		*!*			IF TYPE("pColumna."+lname)=="O"
		*!*			   lcomando="pColumna."+lname+".Visible=.F."
		*!*			   &lcomando
		*!*			ENDIF
				&&'grdHeader'
				private lindice
				lindice=This.GetIndiceColumna(pColumna.Name)
				IF TYPE("pColumna")=="O"
					pColumna.AddObject('Header1', 'HeadOrden', pCampo, lindice)
					pColumna.Header1.Caption  = cCaption
					pColumna.Header1.FontName = cFont
					pColumna.Header1.WordWrap = lWordWrap
					pColumna.Header1.Picture  = cPicture
				ENDIF
			ENDIF
		CATCH TO lerror 
			MESSAGEBOX(lerror.message+CHR(13)+CHR(13)+MESSAGE(1),16,This.Name)
		ENDTRY
	ENDPROC


	PROCEDURE getindicecolumna
		Parameters pNombre
		Local nI, nInd
		nInd = 0
		TRY 
			For nI = 1 To This.ColumnCount
			   If Alltrim(Upper(pNombre)) == Alltrim(Upper(This.Columns[nI].Name))
			      nInd = nI
			      Exit
			   EndIf
			Endfor
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+CHR(13)+MESSAGE(1),16,This.Name) 
		ENDTRY


		Return nInd
	ENDPROC


	PROCEDURE cambia_header
		PRIVATE lset,lnc,lcam,lcal

		IF This.ColumnCount<=0
			RETURN 
		ENDIF
		 
		lset="Set Procedure To '"+Oentorno.RutaOsis+"progs\cls_header.fxp' addi"
		&lset


		lcal=UPPER(ALLTRIM(This.RecordSource))+'.' 

		FOR lnc=1 TO This.ColumnCount
		 	lcam=UPPER(This.Columns[lnc].ControlSource) 
			lcam=STRTRAN(lcam,lcal,'')
			This.Ordena(This.Columns[lnc],lcam) 
		ENDFOR
	ENDPROC


	PROCEDURE busca_dato
		LPARAMETERS lcampo_buscar as String 

		IF PARAMETERS()=0 OR EMPTY(lcampo_buscar)
			MESSAGEBOX("Tiene que Enviar como Parametro en que Columna va a Buscar",64,"Busca en los items")
			Return
		ENDIF

		IF !EMPTY(This.RecordSource) AND USED(This.RecordSource) 
			PRIVATE lselect,lc_area,lc_rec,lp_dato,lp_encontro,ldato_campo
			lc_area=SELECT()
			lselect="Select '"+ALLTRIM(This.RecordSource)+"' "
			&lselect
			lp_encontro=.F.
			IF !EOF() AND !BOF()
				lc_rec=RECNO()
				lp_dato=""
				lp_dato=INPUTBOX("Buscar:")
				IF !EMPTY(lp_dato)
					GO top
					SCAN
						ldato_campo = UPPER( &lcampo_buscar )
						IF UPPER(ALLTRIM(lp_dato)) $ &lcampo_buscar
							lp_encontro=.T.
							Exit
						ENDIF
					ENDSCAN
					IF !lp_encontro

						SCAN
							IF lc_rec=RECNO()
								Exit
							ENDIF
						ENDSCAN

					ENDIF
				ENDIF
			ENDIF
			SELECT (lc_area)
			This.Refresh()
		ENDIF
	ENDPROC


	PROCEDURE MouseMove
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
	ENDPROC


	PROCEDURE Valid
		OtbrItem.BtnAgrega.Enabled=.F.
		OtbrItem.BtnElimina.Enabled=.F.
		OtbrItem.BtnInserta.Enabled=.F.
		OtbrItem.DatosItem=""

		ON KEY LABEL F2
		ON KEY LABEL F3
		ON KEY LABEL F4
	ENDPROC


	PROCEDURE AfterRowColChange
		LPARAMETERS nColIndex

		PRIVATE lfila,lsele,lcurdir,larea

		lcurdir=SELECT()
		IF !EMPTY(This.RecordSource) 
		   lsele="SELECT '"+This.RecordSource+"'"
		   &lsele
		   larea=SELECT()
		   IF !EOF(larea) AND !BOF(larea)
		      lfila=RECNO()
		      This.CalculaItem()
		      SELECT (larea)
		      GO TOP
		      This.Calcula()
		      SELECT (larea)
		      GO top
		      SCAN
		         IF lfila=RECNO()
		            EXIT
		         ENDIF
		      ENDSCAN
		   ENDIF
		ENDIF
		This.Teclas_botones() 

		SELECT (lcurdir)

		This.Refresh()
	ENDPROC


	PROCEDURE Refresh
		*!*	*!*	lsele=SELECT()
		*!*	*!*	IF This.Pintaregistro AND !EMPTY(This.RecordSource)
		*!*	*!*	   lsel="Select '"+Alltrim(This.RecordSource)+"'"
		*!*	*!*	   &lsel
		*!*	*!*	   IF !EOF() AND !BOF()
		*!*	*!*		   This.Registro=RECNO()
		*!*	*!*		   This.SetAll("DynamicBackColor","Iif(RECNO()=This.Registro,This.ColorRegistroSeleccionado,Rgb(255,255,255))","Column")
		*!*	*!*	   EndIf
		*!*	*!*	ENDIF

		*!*	SELECT (lsele)

		IF OtbrItem.Visible=.F.
			OtbrItem.Visible=.T.
			OtbrItem.Show()
		ENDIF
	ENDPROC


	PROCEDURE Init
		ThisForm.LockScreen=.T.
		This.RecordSource=SPACE(0)
		ThisForm.LockScreen=.F.

		IF !EMPTY(This.DatoObjeto)
		   PRIVATE lcoma
		   lcoma="ThisForm."+ALLTRIM(This.DatoObjeto)
		   This.AsociaTabla( &lcoma )
		ENDIF

		IF This.PintaRegistro 
			This.HighlightStyle = 2
		ENDIF
	ENDPROC


	PROCEDURE When
		IF EMPTY(This.DatoObjeto)
		   RETURN 
		ENDIF

		IF !EMPTY(This.RecordSource) AND This.Iniciar_Primera_Fila=.T. and !This.ReadOnly 
			PRIVATE lcurdirx,lcselect,lcomand
			lcurdirx=SELECT()
			lcselect="SELECT '"+This.RecordSource+"'"
			&lcselect
			IF EOF() 
			   lcomand="ThisForm."+ALLTRIM(This.DatoObjeto)+".Cuadricula_SetFocus=.F."
			   &lcomand
			   lcomand="ThisForm."+ALLTRIM(This.DatoObjeto)+".Nuevo()"
			   &lcomand
			   lcomand="ThisForm."+ALLTRIM(This.DatoObjeto)+".Cuadricula_SetFocus=.T."
			   &lcomand
		    ENDIF
			SELECT (lcurdirx)
		ENDIF

		This.Teclas_botones() 
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,'Error: '+ALLTRIM(STR(nError))+CHR(13)+MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Click
		This.When()
	ENDPROC


	PROCEDURE Destroy
		&&Otbr.Grid=.F.
		OtbrItem.Grid=.F.
		OtbrItem.Visible=.F.
	ENDPROC


	PROCEDURE ActivateCell
		LPARAMETERS nRow, nCol
		DODEFAULT(nRow, nCol)
		OtbrItem.Show()
	ENDPROC


	*-- En este Metodo puede ingresar una Sentencia Tipo SUM,COUNT
	PROCEDURE calcula
	ENDPROC


	*-- En este metodo puede ingresar calculos que representen a un item
	PROCEDURE calculaitem
	ENDPROC


	PROCEDURE caption_idioma
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cuadricula
**************************************************


**************************************************
*-- Class:        datos (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   03/06/08 08:22:01 PM
*
DEFINE CLASS datos AS custom


	Height = 18
	Width = 86
	*-- El Alias de la Tabla a Seleccionar
	alias = ("")
	*-- Area de la Tabla a Actualizar
	area = 0
	*-- Sentencia SQL Para seleccionar la Información
	sqlselect = ("")
	*-- Ingrese Aquí el nombre de la tabla fisica que se va actualizar
	nombretabla = ("")
	*-- Si la propiedad esta en (.T.)  al ejecutar las Sentencias SQL le antepondra a las tablas "dbo."
	indicar_dbo = .T.
	*-- Cuarga la Cantidad del Columnas que tiene la Tabla
	columnas = 0
	*-- En esta Propiedad se guarda el SQL Insert que se ejecutara
	sqlinsert = ("")
	*-- En Esta propiedad se gurada el La Sentencia SQL Update que se ejecutara
	sqlupdate = ("")
	*-- En Esta propiedad se gurada el La Sentencia SQL Delete que se ejecutara
	sqldelete = ("")
	*-- 1.- Delete y Insert, 2.- Update
	tipoactualizacion = 2
	*-- 1.- El Datos Cargar una Imagen al Realizar la selección de información, 2.- Se compara cada registro directamente con al base de datos
	tipoverificacion = 1
	*-- Guarda la llave con que va comparar al atualizar la tabla Imagen
	llave = ("")
	*-- Gurda la cantidad de Campos que conforman la llave Primaria
	nrollave = 0
	*-- En este metodo ponga los parametros que son necesarios para el SQL-Select separadao por comas (,)  Eje: ThisForm.Entorno.CodigoCia,ThisForm.Entorno.CodigoSuc. No funciona si el usuario a definido su propia Senticia SQL-SELECT
	parametros = ("")
	*-- Coloque separado por campos los campos que quiere incluir en la Sentecia SQL-SELECT. Eje: cia_ccdcia,suc_codsuc,tdo_codtdo. Esto no funciona si ha definido su propia Sentencia SQL-SELECT
	campos = "*"
	*-- En esta propiedad se guarda el nombre del campo que se servira como Item
	item = ("")
	*-- Gurda el Area donde se encuntra la Tabla Imagen
	areaimagen = 0
	*-- En esta propiedad se guarda el la Sentecia SQL Where para la Sentecia SQL-Select. Esto solo funciona si la Propiedad SqlDefineSelect NO se ha utilizaado
	sqlwhere = ("")
	*-- Si esta en .T. crea Automaticamente un indice con la Llave de la Tabla
	crearindicellave = .T.
	*-- Indica el orden en que se va ejecutar el Metodo Grabar en Un Formulario. Esto solo se utiliza cuando este objeto se encuentra en FORMULARIO
	secuenciagrabacion = 0
	*-- Ingresa el Objeto GRID (Cuadricula) asociada si es que tuviese, con la ruta completa. Ejem: ="ThisForm.Detalle". Esto es para que la propiedades de Este control grid no se desconfiguren
	cuadriculaasociada = ("")
	*-- Se guarda el comando Replace con el que van a ser remplazados los campos llaves. Esto solo funciona si tiene la Propiedad Parametros y la Sentencia SQL-Select NO ha sido definida por el usuario.
	replace = ("")
	*-- Si esta en .T. al momento de ejecutarse el Metodo Destroy se cierra la tabla que controla este objeto
	cerrartabla = .T.
	*-- Si esta en .T. y esta asociada a la cuadricula , Entregara el Foco Despues de un Nuevo Registro
	cuadricula_setfocus = .T.
	*-- En esta propiedad indique separado por comas (,) los campos que si pertenecen a la tabla pero no quiere que se actiualizen. Ejem: ppd_candes,ppd_canfac
	campos_no_grabar = ("")
	*-- Si esta en 0 actualiza Registros Activos y Deleteados si es en 1 solo Activos y si esta en 2 Solo Deleteados
	registro_grabar = 0
	llave_original = ("")
	iniciar_vacio = .F.
	*-- Si esta en .T. le agrega la sentencia ReadPast del SQL al Query. Esto no funciona si se ha definido el Select en el metodo DefineSQLSelect
	readpast = .F.
	esquema = ("")
	Name = "datos"

	*-- Guarda la cantidad de Columnas que tiene la tabla que se va actualizar
	columnastabla = .F.

	*-- Esta propiedad indica si algunos metodos ya se ejecutaro . NO UTILIZAR
	indicadoractivado = .F.

	*-- Si esta en .T.  Insertara un registro en Blanco cuando se quiera ingresar un nuevo registro en un Formulario
	indicadorcabecera = .F.

	*-- Si esta en .T. y la propiedad Item tiene dato entonces le agregara ceros al valor del Item
	ceros = .F.

	*-- Estado del Etorno de Datos
	estado = .F.

	*-- Si esta en .T. Indica que va realizar un Select desde un Store Procedure
	selectstoreprocedure = .F.

	*-- Si esta en .T. al Ejecutar SQL-Select se ubicará siempre en el ultimo registro
	inicia_ultimo_registro = .F.

	*-- Si esta en .T. verifica que los campos de la tabla comiencen los 3 utimos caracteres de la tabla usada Eje: CCT -> cuenta_contable_CCT el campo CCT_codcct
	indicador_tabla_osis = .F.

	*-- NO USAR ESTA PROPIEDAD
	identifica_tabla = .F.

	*-- Si esta en .T. actualizara automaticamente la fecha y el usuario al grabar el registro. Solo funciona si la propiedad Indicador_Tabla_Osis esta en .T.
	actualiza_fecha_usuario = .F.

	*-- Si esta en .T. y la Propiedad Indicador_Tabla_Osis esta en .T. reemplazara con .NULL. a los campos que este vacios y que no pertenescan a la tabla
	indicador_foraneos = .F.

	*-- Si esta en .T. No arma senetencia ni se ejecuta el metodo grabación solo funciona el Metodo SQLSelect
	indicador_consulta = .F.

	*-- Si esta en .T. significa que para INSERT,UPDATE y DELETE va utilizar STORE PROCEDURE
	indicador_storeprocedure = .F.

	*-- Si esta en .T. quiere decir que al grabar retorno verdadero  si retorno .F.
	grabar_retorno = .F.

	*-- Esto Funciona si se encuentra en un Formulario y si esta en .T.
	elimina_anular = .F.

	*-- Si esta en .T. no ejecutara la consulta en el Init
	no_selecciona_inicio = .F.
	indicador_indice = .F.

	*-- En esta propiedad puede Asignar los Inidices que quiere que esta tabla tenga ademas del que esta por defecto
	DIMENSION indice[10,2]
	DIMENSION llaves_anteriores[1,2]


	*-- Este metodo Guarda en un Arreglo la Estructura de la tabla que se va actualizar
	PROCEDURE almacenaestructura
		IF This.Indicador_Consulta 
		   RETURN
		ENDIF

		IF EMPTY(This.NombreTabla) or Ocnx.conexion<0 
		   MESSAGEBOX("La Propiedad NombreTabla No tiene Dato o No hay Conexion",48,"Error")
		   RETURN .f.
		ENDIF
		IF This.SelectStoreProcedure
		   RETURN
		EndIf

		IF This.Nrollave>0
		   RETURN
		ENDIF


		larea=SELECT()


		IF EMPTY(This.Alias)
		   This.Alias=This.NombreTabla
		EndIf

		SET MESSAGE to "Almacenado Estructura para la tabla "+This.Nombretabla+"..."
		IF Ocnx.Tipo_Bd=1
			This.Tag="Exec dbo.PA_estructura_tabla @nombre_tabla='"+Allt(This.Nombretabla)+"'"
		ENDIF
		IF Ocnx.Tipo_Bd=3 
			This.Tag="DESCRIBE "+Allt(This.Nombretabla)
		ENDIF

		IF 	Ocnx.Tipo_Bd=2 
		*!*		This.Tag=""+;
		*!*					 "Select  b.position,"+;
		*!*					 "        a.column_name,"+;
		*!*					 "        a.data_type,"+;
		*!*					 "        a.data_length,"+;
		*!*					 "        a.data_precision,"+;
		*!*					 "        a.data_scale,"+;
		*!*					 "        a.nullable,"+;
		*!*					 "        a.column_id "+;
		*!*					 "From USER_TAB_COLUMNS a "+; 
		*!*					 "Left Join ALL_CONS_COLUMNS b "+;
		*!*					 "On (b.TABLE_NAME=a.TABLE_NAME "+;
		*!*					 "and b.column_name=a.column_name "+;
		*!*					 "and b.position<>0) "+;
		*!*					 "Where UPPER(a.TABLE_NAME)='"+UPPER(Allt(This.Nombretabla))+"' "+;
		*!*					 "Order By b.position,a.column_id "				 
			This.Tag=" Select * from "+Ocnx.Esquema+".SYS_USER_TAB_COLUMNS	"+;
					 " Where UPPER(TRIM(TABLE_NAME))='"+UPPER(Alltrim(This.Nombretabla))+"' "+;
					 " Order By position,column_id				"
		ENDIF


		IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_Bd=3 OR Ocnx.Tipo_Bd=2)
			IF SQLEXEC(Ocnx.conexion,This.Tag,"Tstruc1")<0
			   MESSAGEBOX(MESSAGE()+CHR(13)+This.Tag,48,"Error")
			   RETURN .f.
			ENDIF
		ENDIF

		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(This.Tag,"Tstruc1",ThisForm.DataSessionId)<0
				RETURN .F.
			ENDIF

		ENDIF


		IF !USED("Tstruc1")
		   MESSAGEBOX("No se a Creado la Tabla de Structura",16,"Error") 
		   RETURN .f.
		ELSE
			IF USED("Tstruc1")   
				IF EOF()
					RETURN 
				ENDIF

			ENDIF

		ENDIF


		SELECT "Tstruc1"
		IF Ocnx.Tipo_BD=1
			COUNT TO This.Nrollave FOR llave=1
		ENDIF
		IF Ocnx.Tipo_BD=2
			COUNT TO This.Nrollave FOR NVL(position,0)<>0
		ENDIF

		IF Ocnx.Tipo_BD=3
			COUNT TO This.Nrollave FOR key=='PRI'
		ENDIF

		GO TOP 

		xv=RECCOUNT()

		IF xv=0
		   This.Indicador_consulta = .T.
		   RETURN 
		ENDIF
		 

		This.Columnas=xv


		This.AddProperty("Estructura["+ALLTRIM(STR(xv))+",2]")

		&&&&&&&&&&&&&&&&&&&&&&&&

		IF This.Nrollave>0
			This.AddProperty("LLavePrimaria["+ALLTRIM(STR(This.NroLlave))+"]")
		ENDIF


		&&&&&&&&&&&&&&&&&&&&&&&&


		SELECT "Tstruc1"
		GO top
		xi="1"
		xn=1
		xl=1
		lpos=0 
		SCAN 

			&&& SQL &&&&
			IF Ocnx.Tipo_BD=1
				IF Tstruc1.llave=1
					This.LLavePrimaria[xl]=UPPER(Tstruc1.name)
					xl=xl+1
				ENDIF
			ENDIF
			&&& ORACLE &&&
			IF Ocnx.Tipo_BD=2
				IF NVL(position,0)<>0
					This.LLavePrimaria[xl]=UPPER(Tstruc1.column_name)
					xl=xl+1
				ENDIF
			ENDIF

			&&&&&&&&&&&&&& 
			IF Ocnx.Tipo_BD=3
				IF Tstruc1.key=='PRI'
					This.LLavePrimaria[xl]=UPPER(Tstruc1.field)
					xl=xl+1
				ENDIF
			ENDIF

		*!*		IF Ocnx.Tipo_BD=1
		*!*	    	lpos=ASCAN(This.LlavePrimaria,UPPER(ALLTRIM(Tstruc1.column_name))) 
		*!*	    ENDIF
		*!*	    IF Ocnx.Tipo_BD=4
				IF This.Nrollave>0
					IF Ocnx.Tipo_BD=1
		    			lpos=ASCAN(This.LlavePrimaria,UPPER(ALLTRIM(Tstruc1.name))) 
		    		ENDIF
					IF Ocnx.Tipo_BD=2
						lpos=ASCAN(This.LlavePrimaria,UPPER(ALLTRIM(Tstruc1.column_name))) 
					ENDIF
		 			IF Ocnx.Tipo_BD=3
		    			lpos=ASCAN(This.LlavePrimaria,UPPER(ALLTRIM(Tstruc1.field))) 
		    		ENDIF
		   
		    	ENDIF
		    
		*!*	    ENDIF
		    IF !lpos=0 
		    	xi=0
		    ELSE
		    	xi=1
		    ENDIF
		    IF Ocnx.Tipo_BD=1
			   	This.Estructura[xn,1]=UPPER(Tstruc1.name)
			ENDIF
		    IF Ocnx.Tipo_BD=2
			   	This.Estructura[xn,1]=UPPER(Tstruc1.column_name)
			ENDIF
			   
		     IF Ocnx.Tipo_BD=3
			   	This.Estructura[xn,1]=UPPER(Tstruc1.field)
			ENDIF
		   
		    This.Estructura[xn,2]=xi
		    
		    
		    xn=xn+1
			SELECT "Tstruc1"
		ENDSCAN

		FOR ln=1 TO 1
			lused="USED('Tstruc"+ALLTRIM(STR(ln))+"')"
			lcier="USE IN 'Tstruc"+ALLTRIM(STR(ln))+"'"
			IF &lused
			   &lcier
			ENDIF
		ENDFOR

		IF This.Indicador_Tabla_Osis 
		   This.Identifica_Tabla=RIGHT(ALLTRIM(This.NombreTabla),3)  
		ENDIF

		SELECT (larea)
		SET MESSAGE TO "" 
	ENDPROC


	*-- Este metodo Utilizelo para que se tome acciones con la tabla que se controla de acuredo a la Propiedad Estado del Formulario enviadolo como parametro. Esto es util si esta en una Pantalla de Tipo Formulario
	PROCEDURE activa
		*!*	LPARAMETERS lpestado && Toma los estados del Formulario

		*!*	IF EMPTY(lpestado)
		*!*	   lpestado=2
		*!*	ENDIF
		*!*	This.Estado=lpestado

		*!*	IF This.IndicadorCabecera  && Si es la cabecera de Algún Formulario
		*!*	   IF This.Estado=1
		*!*		   IF !This.Nuevo()
		*!*		       RETURN .f.
		*!*		   ENDIF
		*!*	   ENDIF
		*!*	   IF This.Estado=4
		*!*		   IF !This.Elimina()
		*!*		       RETURN .f.
		*!*		   ENDIF
		*!*	   ENDIF
		*!*	Else   
		*!*	   && Si es un Detalle de Algún Formulario
		*!*	   IF ThisForm.Estado=4 OR ThisForm.Estado=6  && Eliminación o Anulación
		*!*		   IF !This.EliminaTodos()
		*!*			   RETURN .f.
		*!*		   ENDIF
		*!*	   ENDIF
		*!*	   IF ThisForm.Estado=2 OR ThisForm.Estado=1 && Nuevo o Modificación
		*!*		   IF !This.EliminaTodos()
		*!*			   RETURN .f.
		*!*		   ENDIF
		*!*	   ENDIF
		*!*	EndIF
	ENDPROC


	*-- Este Metodo Ejecuta la Sentencia SQL Select para traer la información que uno quiere
	PROCEDURE selecciona
		PRIVATE lwheadi,lfin,lrefre,lsetfo,lcalcula,lsqlcad,leje,lcondic,lxcontinua

		lxcontinua=.T.
		IF !This.IndicadorActivado
		    RETURN
		ENDIF

		IF !EMPTY(NVL(ALLTRIM(This.CuadriculaAsociada),'')) 
			leje=ALLTRIM(This.CuadriculaAsociada)+".Reordena_Columnas()"
			&leje
		ENDIF


		This.NombreTabla=ALLTRIM(This.NombreTabla) 

		IF EMPTY(This.Alias)
		   This.Alias=This.Nombretabla
		EndIf

		This.Alias=ALLTRIM(This.Alias)

		lcuad=.f.

		lacci1=" l1=1 "
		lacci2=" l1=1 "
		lacci3=" l1=1 "
		lacci4=" l1=1 "
		lacci5=" l1=1 "

		IF !EMPTY(This.CuadriculaAsociada )
		    lacci1=" ThisForm.LockScreen=.T. "
		    lacci2=" ThisForm.LockScreen=.F. "
		    lacci3=ALLTRIM(This.CuadriculaAsociada)+".RecordSource=SPACE(0)"
		    lacci4=ALLTRIM(This.CuadriculaAsociada)+".AsociaTabla(This)"
		    lacci5="TYPE('"+ALLTRIM(This.CuadriculaAsociada)+"')=='O'"
		ENDIF

		&lacci1
		&lacci3
		IF Ocnx.conexion<0 AND !EMPTY(This.NombreTabla)
		   MESSAGEBOX("No hay Conexion or No Tiene",48,"Error")
		   RETURN .f.
		ENDIF

		*!*	IF Ocnx.Tipo_BD=4 AND UPPER(ALLTRIM(This.Alias))<>"TCUR"
		*!*		   This.SqlSelect = ""
		*!*	ENDIF 

		This.DefineSelect() 
		If EMPTY(This.SqlSelect)
		   wdbo=""
		   IF This.indicar_dbo AND (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
		      wdbo="dbo."
		   ENDIF
		   IF Ocnx.Tipo_BD=2
		   	  wdbo=Ocnx.Esquema+"."
		   ENDIF 
		   
		   lwhe="" 
		   lrep=""
		   IF !EMPTY(This.Parametros)
		      lini=1
		      lpos=0
		      If ","$This.Parametros
		      	  TRY 
					      FOR ln=1 TO 20
					    	  lpos=ATC(",",This.Parametros,ln)
					    	  lfin=lpos-lini
					    	  IF lpos>0 
					    	  	 IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
						    	 	lwhe=lwhe+ALLTRIM(This.LlavePrimaria[ln])+"=?"+SUBSTR(This.Parametros,lini,lfin)+" AND "
						    	 ENDIF
						    	 IF Ocnx.Tipo_BD=4
						    	 	 ldato=SUBSTR(This.Parametros,lini,lfin)
							    	 lwhe=lwhe+ALLTRIM(This.LlavePrimaria[ln])+"="+This.Devuelve_cadena(ldato)+" AND "
						    	 ENDIF
					    	 	 lrep=lrep+ALLTRIM(This.LlavePrimaria[ln])+" WITH "+SUBSTR(This.Parametros,lini,lfin)+","
						    	 lini=lpos + 1
					    	  ELSE
					    	  	IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
					    	    	lwhe=lwhe+ALLTRIM(This.LlavePrimaria[ln])+"=?"+SUBSTR(This.Parametros,lini,LEN(ALLTRIM(This.Parametros)))+" AND "
					    	    ENDIF
					    	    IF Ocnx.Tipo_Bd=4
						    	 	ldcampo=SUBSTR(This.Parametros,lini,LEN(ALLTRIM(This.Parametros)))
					    	    	lwhe=lwhe+ALLTRIM(This.LlavePrimaria[ln])+"="+This.Devuelve_cadena(ldcampo)+" AND "
					    	    ENDIF
					    	    
					    	    Exit  
					    	  EndIf
					   	  ENDFOR
					CATCH TO lerror
						MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
						lxcontinua=.F.						   	  
					ENDTRY
					IF !lxcontinua
						RETURN .F.
					ENDIF

						   	  
		   	  ELSE
		   	  	 TRY 
			         IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)   	  
			   	     	lwhe=lwhe+ALLTRIM(This.LlavePrimaria[1,1])+"=?"+Allt(This.Parametros)+" AND "
			   	     ENDIF
			   	     IF Ocnx.Tipo_BD=4
			   	     	lpdato=Allt(This.Parametros)
			   	        lwhe=lwhe+ALLTRIM(This.LlavePrimaria[1,1])+"="+This.Devuelve_cadena(lpdato) +" AND "
			   	     ENDIF
			   	     
			   	     lrep=lrep+ALLTRIM(This.LlavePrimaria[1,1])+" WITH "+ALLT(This.Parametros)+","
				CATCH TO lerror
					MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
					lxcontinua=.F.						   	  
				ENDTRY
				IF !lxcontinua
					RETURN .F.
				ENDIF
			   	     
			   	     
		   	  ENDIF
		 	  TRY 
			      IF !EMPTY(lwhe)   
			      	 lwhe=LEFT(lwhe,LEN(lwhe) - 5) 
			      	 lwhe=" WHERE "+lwhe
			      	 lrep=LEFT(lrep,LEN(lrep) - 1) 
			      	 This.Replace=" REPLACE "+lrep
			   	  ENDIF
			   	  IF !EMPTY(This.SqlWhere)
			   	     IF EMPTY(lwhe)   
			   	        lwhe=" WHERE "+This.SqlWhere
			   	     ELSE
			   	        lwhe=lwhe+" AND "+This.SqlWhere
			   	     ENDIF
			   	  ENDIF
				CATCH TO lerror
					MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
					lxcontinua=.F.						   	  
				ENDTRY
				IF !lxcontinua
					RETURN .F.
				ENDIF
		   	  
		   ENDIF
		   TRY 
			   lwheadi=""
			   IF !EMPTY(This.SqlWhere)
			       IF !EMPTY(lwhe)
			           lwheadi=" AND "+This.SqlWhere
			       ELSE
			           lwheadi=" WHERE "+This.SqlWhere
			       ENDIF
			       
			   ENDIF

			   IF ALLTRIM(This.Campos)=="*" AND !This.Indicador_consulta AND TYPE("This.Estructura[1,1]")=="C"
					PRIVATE lcolums
					lcolums=This.Columnas_select() 
					IF LEN(lcolums)>0
						This.Campos=lcolums
					ENDIF
			   ENDIF
			   PRIVATE lreadpast
			   lreadpast=""
			   IF Ocnx.Tipo_BD=1 AND THis.Readpast 
				   lreadpast=" With (READPAST) "
			   Endif
			   
			   This.SqlSelect="Select "+This.Campos+" From "+wdbo+ALLTRIM(This.NombreTabla)+lreadpast+lwhe+lwheadi
			   
			   
			CATCH TO lerror
				MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
				lxcontinua=.F.						   	  
			ENDTRY
			IF !lxcontinua
				RETURN .F.
			ENDIF

		EndIf
		IF USED(This.Alias)
		   PRIVATE ltag_anterior,lcount_tag,lnxtag,larratag,lxfil,lxcol
		   DIMENSION This.Llaves_anteriores[1,1] 
		   This.Llaves_anteriores[1,1]=.F.
		   lsele="Select '"+This.Alias+"'"
		   &lsele
		   IF TAGCOUNT()>0
			  lcount_tag=TAGCOUNT()
			  ATAGINFO(larratag)
			  
			  lxfil=ALEN(larratag,1)
			  lxcol=ALEN(larratag,2)
		   	  DIMENSION This.Llaves_anteriores[lxfil,lxcol] 
			  FOR lnxtag=1 TO lxfil
			  		FOR lnxtagcol=1 TO lxcol
				  		This.Llaves_anteriores[lnxtag,lnxtagcol] = larratag[lnxtag,lnxtagcol]
				  	ENDFOR
			  ENDFOR
			  
		   ENDIF
		   
		   
		   
		   
		   IF CURSORGETPROP("Buffering",ALLTRIM(This.Alias))<>1
		      =TABLEREVERT(.t.) 
		   ENDIF
		ENDIF

		SET MESSAGE to "Ejecutando Consulta....."+This.Alias+"...."

		lsqlcad=This.SqlSelect

		IF (Ocnx.Tipo_BD=1 or Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
			IF SQLEXEC(Ocnx.Conexion,lsqlcad,This.Alias)<0
			   &lacci2
			   MESSAGEBOX(MESSAGE()+CHR(13)+lsqlcad,16,"Error")
			   RETURN .f.
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4
		   IF Ocnx.MS_Ejecuta_SQL(lsqlcad,This.Alias,ThisForm.DataSessionId)<0
		      &lacci2
		      RETURN .F.
		   ENDIF
		ENDIF


		This.Area=SELECT()


		&& Carga Imagen
		IF !This.Indicador_Consulta &&AND This.TipoVerificacion=1 
		    IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
				IF SQLEXEC(Ocnx.Conexion,This.SqlSelect,ALLTRIM(This.Alias)+"_Imagen")<0
				   &lacci2
				   MESSAGEBOX(MESSAGE()+CHR(13)+This.SqlSelect,16,"Error Imagen")
				   RETURN .f.
				ENDIF
			ENDIF
		    IF Ocnx.Tipo_BD=4
				IF Ocnx.MS_Ejecuta_SQL(This.SqlSelect,ALLTRIM(This.Alias)+"_Imagen",ThisForm.DataSessionId)<0
				   &lacci2
				   RETURN .f.
				ENDIF
			ENDIF

			This.AreaImagen=SELECT()

			lindex=""
			lcampo=""
			FOR ln=1 TO This.Columnas
		    	IF This.Estructura[ln,2]=0
		    	   lcoman="ltipo=TYPE('"+ALLTRIM(This.Alias)+"_Imagen."+ALLTRIM(This.Estructura[ln,1])+"')"
		    	   &lcoman
		    	   IF ltipo=="C"
		    	      lcampo=ALLTRIM(This.Estructura[ln,1])
		    	   EndIf
		    	   IF ltipo=="N"
		    	      lcampo="STR("+ALLTRIM(This.Estructura[ln,1])+")"
		    	   EndIf
		    	   IF ltipo$"DT"
		    	      lcampo="DTOS("+ALLTRIM(This.Estructura[ln,1])+")"
		    	   ENDIF
		    	   IF !EMPTY(lcampo)
			       	  lindex=lindex+lcampo+"+"
			       ENDIF
			    EndIf
			ENDFOR
			SELECT (This.Area)
		ENDIF
		IF !EMPTY(This.LLave_Original)
		   lindex=UPPER(ALLTRIM(This.LLave_Original))+" "
		ENDIF

		TRY 
				&&IF EMPTY(This.Llave)
				   IF !This.Indicador_Consulta 
						IF This.CrearIndiceLlave 
						   IF !EMPTY(lindex) or !EMPTY(This.Llave) 
							   This.Llave_Original=LEFT(lindex,LEN(lindex)-1)  
							   IF EMPTY(This.LLave) 
								  This.Llave=This.Llave_Original
							   EndIf	   
							   lcreind="INDEX ON "+This.Llave_Original+" TAG PRINCIPAL" 
							   &lcreind
							   lcreind="INDEX ON "+This.Llave+" TAG LLAVE " 
							   &lcreind
						   ENDIF
						   IF This.AreaImagen<>0 &&AND This.TipoVerificacion=1
							  SELECT (This.AreaImagen)
							  IF !EMPTY(lindex) 
								  This.Llave_Original=LEFT(lindex,LEN(lindex)-1)  
								  lcreind="INDEX ON "+This.Llave_Original+" TAG PRINCIPAL" 
								  &lcreind
							  ENDIF
						   ENDIF
						ENDIF
				   ENDIF
				   IF This.Indicador_consulta AND !EMPTY(This.LLave) 
				   	  SELECT (This.Area) 
					  lcreind="INDEX ON "+This.Llave+" TAG LLAVE " 
					  &lcreind
				   ENDIF
				   

				IF !EMPTY(This.CuadriculaAsociada )
				    lcalcula=ALLTRIM(This.CuadriculaAsociada)+".Calcula()"
				    &lcalcula
				ENDIF

				IF ALEN(This.Llaves_anteriores,1)>0 AND  !EMPTY(This.Llaves_anteriores[1,1])
				   PRIVATE lcanarre	, lna, laccion, ltag
				   lcanarre=ALEN(This.Llaves_anteriores,1)
				   SELECT (This.Area) 
				   ltag=TAG()
				   FOR lna=1 TO lcanarre
				   		IF This.Llaves_anteriores[lna,1]<>'LLAVE'
				   			&&SET MESSAGE TO laccion
					  		laccion="Index On "+This.Llaves_anteriores[lna,3]+" Tag "+This.Llaves_anteriores[lna,1]+" "+This.Llaves_anteriores[lna,5]
					  		&laccion
				  		ENDIF
				  
				   ENDFOR
				   IF !EMPTY(ltag)
				      SELECT (This.Area)
					  SET ORDER TO &ltag
				   ENDIF  
				ENDIF
				   	  


				SELECT (This.Area)
				IF This.Inicia_Ultimo_Registro 
				   GO BOTTOM
				Else   
				   GO TOP
				ENDIF


				&lacci2
				IF &lacci5
				   &lacci4
				ENDIf
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
		ENDTRY

		SET MESSAGE TO ""
	ENDPROC


	PROCEDURE armasentencias
		PRIVATE lxcontinua,ldbo
		lxcontinua=.T.
		ldbo=""

		IF Ocnx.Tipo_BD=1
			ldbo="dbo."
		ENDIF

		IF !EMPTY(This.Esquema) 
			ldbo=This.Esquema+"."
		ENDIF


		IF This.Indicador_Consulta 
		   RETURN 
		ENDIF

		IF This.Indicador_StoreProcedure 
		   RETURN 
		EndIf
		********** Define el Insert ************
		IF !USED(This.Alias)
			RETURN 
		ENDIF

		lregi=AFIELDS(larre,This.Alias)

		SET MESSAGE to "Armando Sentencias para la tabla "+This.Nombretabla+"...."

		lcadinto=""
		lcadvalu=""
		IF !TYPE("This.Estructura[1]")=="C"
			RETURN 
		ENDIF

		TRY 
				FOR ln=1 TO lregi
				    lpos=ASCAN(This.Estructura, UPPER(larre[ln,1]))
				    IF lpos !=0 AND !UPPER(ALLTRIM(larre[ln,1]))$UPPER(This.Campos_no_grabar) 
					    lcadinto=lcadinto+ALLTRIM(UPPER(larre[ln,1]))+","
				    	lcadvalu=lcadvalu+"?"+UPPER(ALLTRIM(This.Alias))+"."+UPPER(ALLTRIM(larre[ln,1]))+","
				    ENDIF
				ENDFOR

				IF LEN(lcadinto)>0
				   lcadinto=LEFT(lcadinto,LEN(lcadinto)-1)
				   lcadvalu=LEFT(lcadvalu,LEN(lcadvalu)-1)

				   This.SqlInsert=UPPER("Insert Into "+IIF(This.indicar_dbo,ldbo,"")+;
				                  Alltrim(This.nombretabla)+" ("+lcadinto+") Values ("+lcadvalu+")")
				   
				ENDIF

				********** Define el Update ************
				lcadwher=""
				lcadupda=""


				FOR ln=1 TO lregi
				    lpos=ASCAN(This.Estructura, UPPER(larre[ln,1])) 
				    IF lpos !=0 
				        lpos=(lpos + 1)/2 
					    IF This.Estructura[lpos,2]=0
					       lcadwher=lcadwher+ALLTRIM(larre[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+" AND "
					    ELSE
					       IF !UPPER(ALLTRIM(larre[ln,1]))$UPPER(This.Campos_No_Grabar) 
					       	   lcadupda=lcadupda+ALLTRIM(larre[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
					       ENDIF
					    ENDIF
				    ENDIF
				ENDFOR

				IF LEN(lcadupda)>0
				   IF !EMPTY(lcadwher)
					   lcadwher=" WHERE "+LEFT(lcadwher,LEN(lcadwher)-5)
				   EndIf
				   lcadupda=LEFT(lcadupda,LEN(lcadupda)-1)

				   This.SqlUpdate=UPPER("Update "+Iif(This.indicar_dbo,ldbo,"")+;
				                  ALLTRIM(This.nombretabla)+" Set "+lcadupda+lcadwher)
				                  
				   
				ENDIF


				********** Define el Delete ************

				This.SqlDelete=UPPER("Delete "+IIF(This.indicar_dbo,ldbo,"")+;
				                         ALLTRIM(This.nombretabla)+" "+lcadwher)

		CATCH TO lerror
			lxcontinua=.F.
			MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
		ENDTRY

		SET MESSAGE to
		IF !lxcontinua
			RETURN .F.
		ENDIF
	ENDPROC


	*-- Este Eveneto se ejeuta para actualizar la base de datos
	PROCEDURE grabar
		PRIVATE lmessa,lcad,lda1,lda2,ldbo


		ldbo=""

		IF Ocnx.Tipo_BD=1
			ldbo="dbo."
		ENDIF

		IF !EMPTY(This.Esquema) 
			ldbo=This.Esquema+"."
		ENDIF

		This.Grabar_Retorno=.T. 
		IF This.Indicador_Consulta 
		   RETURN  
		ENDIF

		IF This.Indicador_Storeprocedure 
		   IF !("CALL"$UPPER(This.SQLUpdate) OR "EXEC"$UPPER(This.SQLUpdate))
		      Ocnx.ErrorMensaje="EN LA PROPIEDAD SQLUPDATE NO SE ENCUENTRA LA SENTECIA EXEC O CALL. AVISE A SISTEMAS"
		   	  RETURN .F.
		   ENDIF
		ENDIF


		PRIVATE ln,lwhere,lcurdir,lsele,lregi,lwher,xrec,lrep,lseek,lcompar,xrec,;
		        lcadwher,lcadupda,lcadinse,lcadvalu,lpos,lSqlInsert,lSqlUpdate,lrep2,;
		        larr2,lco2,lf,lwheim,lSqlDelete,lcompar,lsimb,lotda,lbcondregis,lregllave,lfechahora
		        


		DO 	Case
			CASE This.Registro_Grabar=0  
				 lbcondregis=" 1=1 "
			CASE This.Registro_Grabar=1
				 lbcondregis=" !DELETED() "
			CASE This.Registro_Grabar=2
				 lbcondregis=" DELETED() "
			OTHERWISE 	 
			     lbcondregis=" 1=1 "
		EndCase

		Ocnx.ErrorMensaje=""
		lcurdir=SELECT()
		lsele="Select '"+Alltrim(This.Alias)+"'"
		&lsele
		lregi=AFIELDS(larre,This.Alias)

		lwhere=""
		lverif=""
		FOR ln=1 TO This.Columnas
		    IF This.Estructura[ln,2]=0
		       lwhere=lwhere+ALLTRIM(This.Estructura[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Estructura[ln,1])+" AND "
		    EndIf
		ENDFOR
		IF LEN(lwhere)>0
		   lwhere=LEFT(lwhere,LEN(lwhere)-5)
		   lverif="Select * From "+ldbo+ALLTRIM(This.NombreTabla)+" Where "+lwhere
		ENDIF


		lwher=""
		lwheim=""
		FOR ln=1 TO This.Nrollave
		    lwher=lwher+ALLTRIM(This.LlavePrimaria[ln])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.LlavePrimaria[ln])+" AND "
			lwheim=lwheim+ALLTRIM(This.Estructura[ln,1])+"=?"+ALLTRIM(This.Alias)+"_Imagen."+ALLTRIM(This.Estructura[ln,1])+" AND "
		ENDFOR
		IF !EMPTY(lwher)
		   lwher=" WHERE "+LEFT(lwher,LEN(lwher)-5) 
		   lwheim=" WHERE "+LEFT(lwheim,LEN(lwheim)-5) 
		ENDIF

		IF This.Registro_Grabar<2  
			IF !This.Antes_De_Grabar() 
			    This.Grabar_Retorno=.F. 
			    RETURN This.Grabar_Retorno
			ENDIF
		ENDIF


		SELECT (This.Area)
		xrec=RECNO()
		SET DELETED OFF
		GO TOP
		IF !EMPTY(This.Replace) AND !EMPTY(This.CuadriculaAsociada) 
		   lrep=This.Replace+" ALL"
		   &lrep
		   GO top
		ENDIF

		SCAN
		    lregllave=This.Llave_original
		    lregllave=&lregllave 
		    IF &lbcondregis
		        IF This.Registro_Grabar<2  
				    IF !This.Antes_Grabar_Registro()
				        SET DELETED ON
				        This.Grabar_Retorno=.F. 
				        RETURN This.Grabar_Retorno
				    EndIf 
			    ENDIF
			    SELECT (This.Area)
			    IF This.Indicador_Foraneos 
			       lco2=AFIELDS(larr2,This.Area)
			       IF lco2>0
			          FOR lf=1 TO lco2
			              IF larr2[lf,5]
				              lpos=ASCAN(This.Estructura, larr2[lf,1]) 
				              IF !lpos=0
					              lcom="Empty(NVL("+larr2[lf,1]+",''))"
				    	          IF &lcom
				    	             SELECT (This.Area)
				    	             lrep2="REPLACE "+larr2[lf,1]+" WITH  NULL " 
				    	             &lrep2
				    	          ENDIF
				    	      ENDIF
			    	      ENDIF
			         ENDFOR
			       ENDIF
			    ENDIF
			    
				IF This.TipoVerificacion=1
				  ********** Compara con la Imagen *******************
				  lseek="Seek("+This.Llave_Original +",'"+ALLTRIM(This.Alias)+"_Imagen')"
				  
				  IF &lseek and !DELETED(This.AreaImagen)
					 IF DELETED() 
					 	IF SQLEXEC(Ocnx.conexion,This.SqlDelete)<0
					 	   IF !TYPE("ThisForm.Entorno")=="O"
					 	   	  lmessa=MESSAGE()
					 	   ELSE
					 	   	  lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
					 	   ENDIF
					 	   Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+CHR(13)+This.SqlDelete 
		  		           This.Grabar_Retorno=.F. 
						   SET DELETED ON
			               RETURN This.Grabar_Retorno
					 	ENDIF
					 ELSE
					    *********** Compara si han habidado modificaciones ****
					    lcadwher=""
					    lcadupda=""
					    lcadinse=""
					    lcadvalu=""
					    FOR ln=1 TO lregi
					        lpos=ASCAN(This.Estructura, larre[ln,1]) 
					        IF lpos !=0 AND !UPPER(larre[ln,1])$UPPER(ALLTRIM(This.Campos_no_grabar)) 
			 		            lpos=(lpos + 1)/2
			 		            IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="C" OR ;
			 		               TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="M"
			 		               lotda="''"
			 		               lsimb="=="
			 		            ELSE
			 		               lsimb="="
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="N"
			 		                  lotda="0"
			 		               ENDIF
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="D"
			 		                  lotda="{}"
			 		               ENDIF
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="T"
			 		                  lotda="{}"
			 		               ENDIF
			 		            ENDIF
						        lcompar=" ! (NVL("+ALLTRIM(This.Alias)+"."+larre[ln,1]+","+lotda+")"+lsimb+"NVL("+ALLTRIM(This.Alias)+"_Imagen."+larre[ln,1]+","+lotda+")) "
						        &&WAIT WINDOW lcompar NOWait
						        IF &lcompar
								    IF !This.Estructura[lpos,2]=0
									   lcadupda=lcadupda+ALLTRIM(larre[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
								    ENDIF
							    ENDIF


							    lnoesfechahora=.F.
							    IF This.Indicador_tabla_osis AND This.Actualiza_fecha_usuario 
								   IF UPPER(ALLTRIM(larre[ln,1]))==UPPER(ALLTRIM(This.Identifica_Tabla)+"_FECACT")
								   	  lnoesfechahora=.T. 
					  	              lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
					  	              IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
										  lcadvalu=lcadvalu+"Getdate(),"
									  ENDIF
					  	              IF (Ocnx.Tipo_BD=2)
										  lcadvalu=lcadvalu+"SYSDATE,"
									  ENDIF

					  	              IF (Ocnx.Tipo_BD=3)
										  lcadvalu=lcadvalu+"Now(),"
									  ENDIF
									  	  
								   ENDIF
								   IF UPPER(ALLTRIM(larre[ln,1]))==UPPER(ALLTRIM(This.Identifica_Tabla)+"_CODUSU")
									  lnoesfechahora=.T.
						  	          lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
						  	          IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
									  	 lcadvalu=lcadvalu+"Suser_Sname(),"
									  ENDIF
					  	              IF (Ocnx.Tipo_BD=2)
					  	                 lcadvalu=lcadvalu+"User,"
									  ENDIF

					  	              IF (Ocnx.Tipo_BD=3)
					  	                 lcadvalu=lcadvalu+"User(),"
									  ENDIF
									  							  
								   ENDIF
								ENDIF
													    
							    IF !lnoesfechahora
					  	            lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
									lcadvalu=lcadvalu+"?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
								ENDIF

						    ENDIF
					    ENDFOR
					    lcadwher=lwher
					    IF This.TipoActualizacion=2
						    *********** Update ***************
						    IF LEN(lcadupda)>0
							   lcadupda=LEFT(lcadupda,LEN(lcadupda)-1)
				               IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
				                  SELECT (This.Area)
				                  lrep2="REPLACE "+;
				                        ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			 	                        ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			 	                  &lrep2
			 	                  IF !UPPER(ALLTRIM(This.Identifica_Tabla)+"_FECACT")$UPPER(lcadupda) AND ;
			 	                     !UPPER(ALLTRIM(This.Identifica_Tabla)+"_CODUSU")$UPPER(lcadupda)
			 	                      IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
					 	                  lcadupda=lcadupda+","+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=Getdate(),"+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=Suser_Sname()"
				 	                  ENDIF
			 	                      IF (Ocnx.Tipo_BD=2)
					 	                  lcadupda=lcadupda+","+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=SYSDATE,"+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=USER"
				 	                  ENDIF

			 	                      IF (Ocnx.Tipo_BD=3)
					 	                  lcadupda=lcadupda+","+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=Now(),"+;
					 	                           ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=User()"
				 	                  ENDIF
				 	                           
		                               		 	                           
				 	              ENDIF
				               ENDIF
				               IF !This.Indicador_StoreProcedure 
								   lSqlUpdate=UPPER("Update "+Iif(This.indicar_dbo,ldbo,"")+;
					            		         ALLTRIM(This.nombretabla)+" Set "+lcadupda+lcadwher)
			                   ELSE
			                       lSqlUpdate=This.SqlUpdate 
			                   ENDIF
			                   &&SUSP
				               IF SQLEXEC(Ocnx.conexion,lSqlUpdate)<0
				               
				               	  IF !TYPE("ThisForm.Entorno")=="O"
					 	   	  		 lmessa=MESSAGE()
							 	  ELSE
								 	 lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
					 	   		  ENDIF
							 	  Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lSqlUpdate 
						 	   	  &&Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+MESSAGE()+CHR(13)+CHR(13)+lSqlUpdate 
				  			      SET DELETED ON
					              This.Grabar_Retorno=.F. 
			                      RETURN This.Grabar_Retorno
						 	   ENDIF
						    ENDIF
					    ELSE
					    	*********** Delete Insert ***************
					    	IF LEN(lcadinse)>0
							   lcadinse=LEFT(lcadinse,LEN(lcadinse)-1)
							   lcadvalu=LEFT(lcadvalu,LEN(lcadvalu)-1)
							   lSqlInsert="Insert Into "+Iif(This.indicar_dbo,ldbo,"")+ALLTRIM(This.nombretabla)+" ("+;
							           lcadinse+") Values ("+lcadvalu+")"    
				               IF SQLEXEC(Ocnx.conexion,This.SqlDelete)<0
				               	  IF !TYPE("ThisForm.Entorno")=="O"
					 	   	  		 lmessa=MESSAGE()
							 	  ELSE
								 	 lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
					 	   		  ENDIF
						 	   	  Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+This.SqlDelete
				  			      SET DELETED ON
				                  This.Grabar_Retorno=.F. 
			                      RETURN This.Grabar_Retorno
						 	   ENDIF
				               IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
				                  SELECT (This.Area)
				                  lrep2="REPLACE "+;
				                        ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			 	                        ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			 	                  &lrep2       
				               ENDIF
				               IF This.Indicador_StoreProcedure 
				                  lSqlInsert=This.SqlInsert 
				               ENDIF
				               
				               IF SQLEXEC(Ocnx.conexion,lSqlInsert)<0
				               	  IF !TYPE("ThisForm.Entorno")=="O"
					 	   	  		 lmessa=MESSAGE()
							 	  ELSE
								 	 lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
					 	   		  ENDIF
						 	   	  Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lSqlInsert
						          SET DELETED ON
				                  This.Grabar_Retorno=.F. 
			                      RETURN This.Grabar_Retorno
						 	   ENDIF
					    	ENDIF
					    ENDIF
					    
					    **********************************
					 ENDIF
				  ELSE
				  	 SELECT (This.Area)
				     IF !DELETED()
			            IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
			               SELECT (This.Area)
			               lrep2="REPLACE "+;
			                     ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			                     ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			               &lrep2       
			               &&&&& Usuario Fecha y Hora del Servidor &&&&&
						   This.SqlInsert=UPPER(This.SqlInsert)
						   IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"Getdate()")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"Suser_Sname()")
						   ENDIF
						   IF (Ocnx.Tipo_BD=2)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"SYSDATE")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"USER")
						   ENDIF
						   IF (Ocnx.Tipo_BD=3)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"Now()")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"User()")
						   ENDIF
						   	   
			               &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			            ENDIF

					 	IF SQLEXEC(Ocnx.conexion,This.SqlInsert)<0
		               	   IF !TYPE("ThisForm.Entorno")=="O"
					 	   	   lmessa=MESSAGE()
						   ELSE
							   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
					 	   ENDIF
					 	   Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+This.SqlInsert
			   			   SET DELETED ON
				           This.Grabar_Retorno=.F. 
			               RETURN This.Grabar_Retorno
					 	ENDIF
				     ENDIF
				  ENDIF
				ELSE
				********** Compara con la Base de Datos ************
				 	IF SQLEXEC(Ocnx.conexion,lverif,"Toriginal")<0
		           	   IF !TYPE("ThisForm.Entorno")=="O"
				 	   	   lmessa=MESSAGE()
					   ELSE
						   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
				 	   ENDIF
			 		   Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lverif 
			           This.Grabar_Retorno=.F. 
			           RETURN This.Grabar_Retorno
				 	ENDIF	  
				    IF EOF()
				       SELECT (This.Area)
			   		   IF !DELETED(This.Area)
			              IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
			                 SELECT (This.Area)
			                 lrep2="REPLACE "+;
			                       ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			                       ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			                 &lrep2       
				           &&&&& Usuario Fecha y Hora del Servidor &&&&&
						   This.SqlInsert=UPPER(This.SqlInsert)
						   IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"Getdate()")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"Suser_Sname()")
						   ENDIF
						   IF (Ocnx.Tipo_BD=2)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"SYSDATE")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"USER")
						   ENDIF
						    	   
						   IF (Ocnx.Tipo_BD=3)
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_FECACT"),"Now()")
							   This.SqlInsert=STRTRAN(This.SqlInsert,UPPER("?"+ALLTRIM(This.Alias)+"."+ALLTRIM(This.Identifica_Tabla)+"_CODUSU"),"User()")
						   ENDIF
			               &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			              ENDIF
					 	  IF SQLEXEC(Ocnx.conexion,This.SqlInsert)<0
				           	 IF !TYPE("ThisForm.Entorno")=="O"
						 	   	lmessa=MESSAGE()
							 ELSE
								lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
						 	 ENDIF
					 	     Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+This.SqlInsert 
			   			     SET DELETED ON
				             This.Grabar_Retorno=.F. 
			                 RETURN This.Grabar_Retorno
					 	  ENDIF
				       ENDIF
				    ELSE
				       SELECT (This.Area)
				       IF DELETED(This.Area)
						  IF SQLEXEC(Ocnx.conexion,This.SqlDelete)<0
				           	 IF !TYPE("ThisForm.Entorno")=="O"
						 	   	lmessa=MESSAGE()
							 ELSE
								lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
						 	 ENDIF
					 	     Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+This.SqlDelete 
			   			     SET DELETED ON
				             This.Grabar_Retorno=.F. 
			                 RETURN This.Grabar_Retorno
					 	  ENDIF
					   ELSE
				          lcadinse=""
						  lcadvalu=""
					      lcadupda=""
					      FOR ln=1 TO lregi
					          lpos=ASCAN(This.Estructura, larre[ln,1]) 
					          IF lpos !=0 AND !UPPER(larre[ln,1])$UPPER(ALLTRIM(This.Campos_no_grabar)) 
			    		         lpos=(lpos + 1)/2
			 		             IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="C" OR ;
			 		                TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="M"
			 		                lotda="''"
			 		                lsimb="=="
			 		             ELSE
			 		                lsimb="="
			 		                IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="N"
			 		                   lotda="0"
			 		                ENDIF
			 		                IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="D"
			 		                   lotda="{}"
			 		                ENDIF
			 		                IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="T"
			 		                   lotda="{}"
			 		                ENDIF
			 		             ENDIF
					             lcompar="!NVL("+ALLTRIM(This.Alias)+"."+larre[ln,1]+","+lotda+")"+lsimb+"NVL(Toriginal."+larre[ln,1]+","+lotda+")"
					             IF &lcompar
								    IF This.Estructura[lpos,2]<>0
									   lcadupda=lcadupda+ALLTRIM(larre[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
								    ENDIF
							        lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
							        lcadvalu=lcadvalu+"?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
					             ENDIF
			                  ENDIF
					      ENDFOR
			              IF This.TipoActualizacion=2
				              *************** Update *****************
							  IF LEN(lcadupda)>0
							     lcadwher=lwher 
							     lcadupda=LEFT(lcadupda,LEN(lcadupda)-1)
			              
				                 IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
				                    SELECT (This.Area)
				                    lrep2="REPLACE "+;
				                          ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			 	                          ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			 	                    &lrep2
			 	                    IF !UPPER(ALLTRIM(This.Identifica_Tabla)+"_FECACT")$UPPER(lcadupda) AND ;
			 	                       !UPPER(ALLTRIM(This.Identifica_Tabla)+"_CODUSU")$UPPER(lcadupda)
			 	                       
			 	                       	IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
					   	                    lcadupda=lcadupda+","+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=Getdate(),"+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=Suser_Sname()"
					 	                ENDIF
			 	                       	IF (Ocnx.Tipo_BD=2)
					   	                    lcadupda=lcadupda+","+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=SYSDATE,"+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=USER"
					 	                ENDIF
					 	                    
			 	                       	IF (Ocnx.Tipo_BD=3)
					   	                    lcadupda=lcadupda+","+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_FECACT"+"=Now(),"+;
					 	                    ALLTRIM(This.Identifica_Tabla)+"_CODUSU"+"=User()"
					 	                ENDIF
				 	                    
			 	                    ENDIF
			 	                    
				                 ENDIF
								 
								 IF !This.Indicador_storeprocedure 
								     lSqlUpdate=UPPER("Update "+Iif(This.indicar_dbo,ldbo,"")+;
					            		        ALLTRIM(This.nombretabla)+" Set "+lcadupda+lcadwher)
				            	 ELSE
								     lSqlUpdate=This.SqlUpdate 
				            	 ENDIF
				            	 	        
				                 IF SQLEXEC(Ocnx.conexion,lSqlUpdate)<0
						           	IF !TYPE("ThisForm.Entorno")=="O"
								 	   lmessa=MESSAGE()
									ELSE
									   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
								 	ENDIF
						 	   	    Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lSqlUpdate 
						 	   	    SET DELETED ON
				                    This.Grabar_Retorno=.F. 
			                        RETURN This.Grabar_Retorno
						 	     ENDIF
						      ENDIF
					      ELSE
				              *************** Delete Insert *****************
							  IF LEN(lcadinse)>0
							     lcadinse=LEFT(lcadinse,LEN(lcadinse)-1)
							     lcadvalu=LEFT(lcadinse,LEN(lcadvalu)-1) && Agregado el 16/09/2003 5:37pm
							     lSqlInsert=UPPER("Insert Into "+Iif(This.indicar_dbo,ldbo,"")+;
				            		        ALLTRIM(This.nombretabla)+" ("+lcadinse+") Values ("+lcadvalu+")")
				              
				                 IF SQLEXEC(Ocnx.conexion,This.SqlDelete)<0
					               	IF !TYPE("ThisForm.Entorno")=="O"
						 	   	  	   lmessa=MESSAGE()
								 	ELSE
									   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
						 	   		ENDIF
						 	   	    Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+This.SqlDelete 
						 	   	    SET DELETED ON
			  	                    This.Grabar_Retorno=.F. 
			                        RETURN This.Grabar_Retorno
						 	     ENDIF
				                 IF This.Indicador_Tabla_osis  AND This.Actualiza_Fecha_Usuario 
				                    SELECT (This.Area)
				                    lrep2="REPLACE "+;
				                          ALLTRIM(This.Identifica_Tabla)+"_FECACT WITH DATETIME(),"+;
			 	                          ALLTRIM(This.Identifica_Tabla)+"_CODUSU WITH Ocnx.usuario "
			 	                    &lrep2       
				                 ENDIF
				                 IF This.Indicador_StoreProcedure 
				                    lSqlInsert=This.SqlInsert  
				                 ENDIF
				                 
				                 IF SQLEXEC(Ocnx.conexion,lSqlInsert)<0
					               	IF !TYPE("ThisForm.Entorno")=="O"
						 	   	  	   lmessa=MESSAGE()
								 	ELSE
									   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
						 	   		ENDIF
						 	   	    Ocnx.ErrorMensaje=This.Name+' LLave: '+lregllave+' Delete/Insert '+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lSqlInsert 
						 	   	    SET DELETED ON
			       	                This.Grabar_Retorno=.F. 
			                        RETURN This.Grabar_Retorno
						 	     ENDIF
						 	     
						      ENDIF
					      
					      ENDIF
					      
			              ****************************************		      
				       ENDIF
				    ENDIF
				    
				ENDIF
				IF This.Registro_Grabar<2  
				    IF !This.Despues_Grabar_Registro() 
				        SET DELETED ON
				        This.Grabar_Retorno=.F. 
				        RETURN This.Grabar_Retorno
				    EndIf 
			    ENDIF
		    ENDIF
			SELECT (This.Area)
		ENDSCAN

		&&SUSP 
		IF This.Registro_grabar<2 
		&&	IF This.TipoVerificacion=1	   
			   lcad="DELETE "+ldbo+ALLTRIM(This.NombreTabla)+lwheim	   
			   SELECT (This.AreaImagen) 
			   SET ORDER TO PRINCIPAL
			   lkey=KEY()
			   SELECT (This.Area)
			   ltag=TAG()
			   INDEX ON &lkey TAG TBUSCPRIM
			   SELECT (This.AreaImagen) 
			   GO TOP
			   SCAN
			      STORE 0 TO ldele,lnodele
			      IF !DELETED(This.AreaImagen)
		   	          ldato = This.Llave_Original 
		              ldato = &ldato
			          SELECT (This.Area) 
			          lseke="SET KEY TO '"+ldato+"'"
			          &lseke
			          GO TOP
				      COUNT FOR DELETED(This.Area) TO ldele
			          COUNT FOR !DELETED(This.Area) TO lnodele
			          SET KEY TO 
			          GO TOP
			          IF ( ldele>0 AND lnodele=0 )  OR (!SEEK(ldato,This.Area,"TBUSCPRIM"))
				   	     IF This.Indicador_StoreProcedure 
				   		    lcad=This.SqlDelete
				   		    lcad=UPPER(lcad)
				   		    lda1=UPPER("?"+ALLTRIM(This.Alias)+".") 
				   		    lda2=UPPER("?"+ALLTRIM(This.Alias)+"_IMAGEN.")
				   		    lcad=STRTRAN(lcad,lda1,lda2)
				   	     ENDIF
				   	     IF SQLEXEC(Ocnx.Conexion,lcad)<0
				   	        SELECT (This.Area)
					        SET ORDER TO &ltag
			               	IF !TYPE("ThisForm.Entorno")=="O"
				 	   	  	   lmessa=MESSAGE()
						 	ELSE
							   lmessa=ThisForm.Entorno.Limpia_Mensaje(MESSAGE())	  
				 	   		ENDIF
				            Ocnx.ErrorMensaje=This.Name+' '+ldato+CHR(13)+CHR(13)+lmessa+CHR(13)+CHR(13)+lcad
							SET DELETED ON
			   	            This.Grabar_Retorno=.F. 
			                RETURN This.Grabar_Retorno
				         ENDIF
			          ENDIF
			   	  ENDIF
			   	  SELECT (This.AreaImagen) 
			   ENDSCAN
			   SELECT (This.Area)
			   SET ORDER TO &ltag
		&&	ENDIF
		ENDIF

		SELECT (This.Area)
		GO top
		SCAN
		  IF xrec=RECNO()
		     Exit 
		  ENDIF
		ENDSCAN

		SET DELETED ON
		SELECT (lcurdir)

		IF This.Registro_Grabar<2  
			IF !This.Despues_Grabar() 
			   This.Grabar_Retorno=.F. 
			   RETURN This.Grabar_Retorno
			ENDIF
		ENDIF

		RETURN This.Grabar_Retorno
	ENDPROC


	PROCEDURE armallaves
		IF This.Indicador_Consulta  
		   RETURN
		ENDIF

		IF EMPTY(This.NombreTabla) or Ocnx.conexion<0 

		   MESSAGEBOX("La Propiedad NombreTabla No tiene Dato o No hay Conexion",48,"Error")
		   RETURN .f.
		ENDIF
		IF This.SelectStoreProcedure
		   RETURN
		EndIf

		SET MESSAGE to "Armando las Llaves para la tabla "+This.Nombretabla+"....."

		larea=SELECT()

		IF EMPTY(This.Alias)
		   This.Alias=This.Nombretabla
		EndIf

		IF Ocnx.Tipo_BD=1
			This.Tag="Sp_Statistics '"+Allt(This.Nombretabla)+"'"
		ENDIF

		IF Ocnx.Tipo_BD=2
		*!*		This.Tag="Select columns_name  "+; 
		*!*				 "From all_cons_columns "+;   
		*!*				 "Where TABLE_NAME='"+Allt(This.Nombretabla)+"' "+;
		*!*				 "and   length(position)>0 "
					 
			This.Tag="Select column_name  "+; 
					 "From  "+Ocnx.Esquema+".SYS_ALL_CONS_COLUMNS   "+;   
					 "Where TABLE_NAME='"+Allt(This.Nombretabla)+"' "+;
					 "and   length(position)>0 "			 
		ENDIF

		IF Ocnx.Tipo_BD=3
			This.Tag="Describe "+Allt(This.Nombretabla)
		ENDIF


		IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
			IF SQLEXEC(Ocnx.conexion,This.Tag,"Tllaves")<0
			   MESSAGEBOX(MESSAGE()+CHR(13)+This.Tag,48,"Error")
			   RETURN .f.
			ENDIF
		ENDIF

		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(This.Tag,"Tllaves",SET("Datasession"))<0
			   RETURN .f.
			ENDIF
		ENDIF

		IF !USED("Tllaves")
			WAIT WINDOW "Tllaves no se creo" NoWait
		ENDIF

		IF RECCOUNT()=0
		   This.Indicador_Consulta=.T. 
		   &&MESSAGEBOX("LA TABLA DE LLAVES ESTA VACIA",16,"ERROR")
		   RETURN 
		ENDIF


		This.NroLlave=0

		lnroreg=RECCOUNT() - 1

		SELECT "Tllaves"
		&&brow
		IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
			COUNT FOR non_unique=0 TO This.NroLlave   
		ENDIF
		IF (Ocnx.Tipo_BD=3)
			COUNT FOR key=="PRI" TO This.NroLlave   
		ENDIF
		IF (Ocnx.Tipo_BD=2)
			COUNT TO This.NroLlave   
		ENDIF

		GO top

		This.AddProperty("LLavePrimaria["+ALLTRIM(STR(This.NroLlave))+"]")


		SELECT "Tllaves"
		GO top
		xi=1
		xn=1
		SCAN 
		    IF xi>1 
		       IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4)
			       IF non_unique=0    
			  	      This.LLavePrimaria[xn]=UPPER(Tllaves.Column_Name)
			          xn=xn+1
				   EndIF 
			   ENDIF
		       IF (Ocnx.Tipo_BD=2)
		  	      This.LLavePrimaria[xn]=UPPER(Tllaves.Column_Name)
		          xn=xn+1
			   ENDIF

			   IF (Ocnx.Tipo_BD=3)
			       IF key=="PRI"
			  	      This.LLavePrimaria[xn]=UPPER(Tllaves.field)
			          xn=xn+1
				   EndIF 
			   ENDIF
			   
		    ENDIF
		    xi=xi+1
		ENDSCAN
		IF USED("Tllaves")
		    USE IN "Tllaves"
		ENDIF

		SELECT (larea)
		SET MESSAGE to
	ENDPROC


	*-- Ingresa un nuevo Registro
	PROCEDURE nuevo
		PRIVATE lcoma,lreg,lval,lrep,lcurdir
		lcurdir=SELECT()
		IF EMPTY(This.Item) 
			APPEND BLANK IN (This.Area)
			lreg=RECNO(This.Area)
			This.ReemplazaCampos() 
		    SELECT (This.Area)
			SCAN
			   IF RECNO()=lreg
			      Exit
			   ENDIF
			ENDSCAN
		ELSE
		    SELECT (This.Area)
		    lcoma=ALLTRIM(This.Alias)+"."+ALLTRIM(This.Item)
		    lreg=RECNO(This.Area)
		    GO BOTTOM
		    litem=&lcoma
		    lval=VAL(litem)+1
			APPEND BLANK IN (This.Area)
			lreg=RECNO(This.Area)
			This.ReemplazaCampos() 
			SELECT (This.Area)
			llen=LEN(litem)
			IF !This.Ceros 
				lrep="REPLACE "+lcoma+" WITH STR(lval,"+ALLTRIM(STR(llen))+")"
			ELSE
				lrep="REPLACE "+lcoma+" WITH STRTRAN(STR(lval,"+ALLTRIM(STR(llen))+"),' ','0')"
			ENDIF
			GO TOP IN (This.Area)
			&lrep
			SCAN
			   IF RECNO()=lreg
			      Exit
			   ENDIF
			ENDSCAN
		ENDIF
		IF !EMPTY(This.CuadriculaAsociada)
		    lrefre=ALLTRIM(This.CuadriculaAsociada)+".Refresh()"
		    &lrefre
		    IF This.Cuadricula_SetFocus
			    lsetfo=ALLTRIM(This.CuadriculaAsociada)+".SetFocus()"
		    	&lsetfo
		    ENDIF
		    IF !EMPTY(This.Item) 
			    lrefre=ALLTRIM(This.CuadriculaAsociada)+".DoScroll(3)"
			    &lrefre
		    ENDIF
		    
		    lrefre=ALLTRIM(This.CuadriculaAsociada)+".Teclas_Botones()"
		    &lrefre
		ENDIF

		SELECT (lcurdir)
	ENDPROC


	*-- Ubica al cursor en el Siguiente Registro
	PROCEDURE siguiente
		IF This.Area<>0
			PRIVATE ldcarea
			ldcarea=SELECT()
			SELECT (This.Area)
			IF !EOF(This.Area) or !BOF(This.Area)
			   SKIP 1 IN (This.Area)
			   IF EOF(This.Area) or BOF(This.Area)
			       GO Bottom IN (This.Area) 
			   EndIf    
		    ENDIF
		    SELECT (ldcarea)
		EndIF
	ENDPROC


	*-- Ubica el cursor  en el Registro Anterior
	PROCEDURE anterior
		IF This.Area<>0
			PRIVATE ldcarea
			ldcarea=SELECT()
			SELECT (This.Area)
			IF !EOF(This.Area) or !BOF(This.Area)
			   SKIP -1 IN (This.Area)
			   IF EOF(This.Area) or BOF(This.Area)
			       GO Top IN (This.Area) 
			   EndIf    
		    ENDIF
		    SELECT (ldcarea)
		EndIF
	ENDPROC


	*-- Ubica el cursor en el Primer Registro
	PROCEDURE primero
		IF This.Area<>0
		    PRIVATE ldcarea
		    ldcarea=SELECT()
		    SELECT (This.Area)
			IF !EOF(This.Area) AND !BOF(This.Area)
		       GO TOP IN (This.Area) 
		    ENDIF
		    SELECT (ldcarea)
		EndIF
	ENDPROC


	*-- Ubica el Cursor en el Ultimo Registro
	PROCEDURE ultimo
		IF This.Area<>0
		    PRIVATE ldcarea
		    ldcarea=SELECT()
		    SELECT (This.Area)
			IF !EOF(This.Area) AND !BOF(This.Area)
		       GO bottom IN (This.Area) 
		    ENDIF
		    SELECT (ldcarea)
		EndIF
	ENDPROC


	*-- Inserta un Registro
	PROCEDURE inserta
		PRIVATE lcoma,lreg,lval,lrep,lcurdir
		lcurdir=SELECT()
		IF EMPTY(This.Item) 
			This.Nuevo() 
		ELSE
		    lcoma=ALLTRIM(This.Alias)+"."+ALLTRIM(This.Item)
		    lreg=RECNO(This.Area)
		    litem=&lcoma
		    lval=VAL(litem)
			llen=LEN(litem)

			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			SELECT (THis.Area) 
			GO BOTTOM in (This.Area)
			IF !EOF() AND !BOF()
				DO WHILE RECNO()<>lreg AND (!EOF() OR !BOF())
				    IF !This.Ceros
					    lrep="REPLACE "+lcoma+" WITH STR(Val("+lcoma+")+3,"++ALLTRIM(STR(llen))+") "
					ELSE
					    lrep="REPLACE "+lcoma+" WITH STRTRAN(STR(Val("+lcoma+")+3,"++ALLTRIM(STR(llen))+"),' ','0') "
					ENDIF
					&lrep
					SKIP -1 
				ENDDO
				IF 	RECNO()=lreg
				    IF !This.Ceros
					    lrep="REPLACE "+lcoma+" WITH STR(Val("+lcoma+")+2,"++ALLTRIM(STR(llen))+") "
					ELSE
					    lrep="REPLACE "+lcoma+" WITH STRTRAN(STR(Val("+lcoma+")+2,"++ALLTRIM(STR(llen))+"),' ','0') "
					ENDIF
				ENDIF
				&lrep
			ENDIF

			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

		*!*		SELECT (This.Area)
		*!*	    IF !This.Ceros
		*!*		    lrep="REPLACE "+lcoma+" WITH STR(Val("+lcoma+")+1,"++ALLTRIM(STR(llen))+") REST "
		*!*		ELSE
		*!*		    lrep="REPLACE "+lcoma+" WITH STRTRAN(STR(Val("+lcoma+")+1,"++ALLTRIM(STR(llen))+"),' ','0') REST "
		*!*		ENDIF
		*!*		&lrep
		*!*		SCAN
		*!*		   IF RECNO()=lreg
		*!*		      EXIT
		*!*		   ENDIF
		*!*		ENDSCAN
		    APPEND BLANK IN (This.Area)
		    lreg=RECNO(This.Area)
		    lrep="REPLACE "+lcoma+" WITH litem "
		    &lrep
		    This.ReemplazaCampos() 
		    This.Remumera() 
			SCAN
			   IF RECNO()=lreg
			      EXIT
			   ENDIF
			ENDSCAN
		ENDIF
		SELECT (lcurdir)
	ENDPROC


	*-- Elimina un registro
	PROCEDURE elimina
		lcurdir=SELECT()
		IF This.Area<>0 AND !EOF(This.Area) AND !BOF(This.Area)
		   DELETE in (This.Area)
		   Skip -1 in (This.Area)
		   IF EOF(This.Area) or BOF(This.Area)
			  GO TOP in (This.Area)
		      GO BOTTOM in (This.Area)
		   ENDIF
		   
		   IF !EOF(This.Area) or !BOF(This.Area)
		      lreg=RECNO(This.Area)
		      SELECT (This.Area)
		      IF !EMPTY(This.Item)
		      	This.Renumera() 
		      ENDIF
			  SCAN
			    IF RECNO(This.Area)=lreg
			       EXIT
			    ENDIF
			  ENDSCAN
		   ENDIF
		   IF !EMPTY(This.CuadriculaAsociada)
		      lrefre=ALLTRIM(This.CuadriculaAsociada)+".Refresh()"
		      &lrefre
		      IF This.Cuadricula_SetFocus
			     lsetfo=ALLTRIM(This.CuadriculaAsociada)+".SetFocus()"
		    	 &lsetfo
			     lsetfo=ALLTRIM(This.CuadriculaAsociada)+".When()"
		    	 &lsetfo
		      ENDIF
		ENDIF
		EndIf
		SELECT (lcurdir)
	ENDPROC


	*-- Este Metodo Elimina Todos los Registros de la Tabla  que Control. Puede enviar una condición para que elmine los datos pasandole en un parametro Caracter. Ejem: " mes_codmes<'03' "
	PROCEDURE eliminatodos
		LPARAMETERS lpcondicion

		IF This.Area>0
			IF EMPTY(lpcondicion)
			   lpcondicion=" 1=1 "
			ENDIF
			DELETE FOR &lpcondicion IN (This.Area)
		ENDIF
	ENDPROC


	*-- EsteMetodo solo sirve siempre y cuando tenga el Item la propiedad Item con algun valor
	PROCEDURE remumera
		PRIVATE lcurdir,lreg,lcuen,lcoma,litem,llen,lrepl

		lcurdir=SELECT()
		IF !EOF(This.Area) AND !BOF(This.Area) AND !EMPTY(This.Item)
		    lreg=RECNO(This.Area)
		    SELECT (This.Area)
		    GO top
		    COUNT TO lcuen
		    
		    lcoma=ALLTRIM(This.Alias)+"."+ALLTRIM(This.Item)
		    litem=&lcoma
		    llen=len(litem) 
		    IF This.Ceros
		    	lrepl="REPLACE "+ALLTRIM(This.Item)+" WITH STRTRAN(STR(lcuen,"+ALLTRIM(STR(llen))+"),' ','0')"
		    ELSE 
		    	lrepl="REPLACE "+ALLTRIM(This.Item)+" WITH STR(lcuen,"+ALLTRIM(STR(llen))+")"
		    ENDIF 
		    
		    lcamb="REPLAC "+ALLTRIM(This.Item)+" WITH STR(VAL("+ALLTRIM(This.Item)+"),"+ALLTRIM(STR(llen))+") ALL "
		    &lcamb  

		    GO BOTTOM 
		    DO WHILE lcuen>=1
			    &lrepl
		    	SKIP -1
		    	lcuen=lcuen -1
		    ENDDO
		    
		    
		*!*	    lcuen=1
		*!*	    SCAN
		*!*	       &lrepl
		*!*	       lcuen=lcuen+1
		*!*	    ENDSCAN
		    GO TOP
		    SCAN
		       IF RECNO()=lreg
		          EXIT
		       ENDIF
		    ENDSCAN
		ENDIF
		SELECT (lcurdir)
	ENDPROC


	PROCEDURE renumera
		This.Remumera()
	ENDPROC


	*-- Ejecuta la sentencia SET FILTER TO Y SET KEY TO
	PROCEDURE desagrupa
		SELECT (This.Area)
		SET FILTER TO
		SET KEY TO 
		GO TOP
	ENDPROC


	*-- Devuelve el Valor  del campo que se envia como parametro
	PROCEDURE campo_valor
		LPARAMETERS lcampo

		PRIVATE lsent,lretur 


		IF USED(This.Alias)
			lsent="lretur="+ALLTRIM(This.Alias)+"."+ALLTRIM(lcampo)
			&lsent
		ELSE
			lretur=null
		ENDIF

		RETURN lretur
	ENDPROC


	*-- Esta Metodo sirve para enviar un campo que lo devolvera como cadena para utilizarlo en una Sentencia Select - SQL
	PROCEDURE devuelve_cadena
		LPARAMETERS lp_campo as Character 


		PRIVATE ldvalor
		ldvalor="''"

		IF PARAMETERS()>0
		 	 IF Type(lp_campo)=="C" 
		 	 	ldvalor="'"+ &lp_campo +"'"
		 	 ENDIF
		 	 IF Type(lp_campo)=="T" 
		 	 	ldvalor="'"+ TTOC( &lp_campo ) +"'"
		 	 ENDIF
		 	 IF Type(lp_campo)=="D"
		 	 	ldvalor="'"+ DTOC( &lp_campo ) +"'"
		 	 ENDIF
		 	 IF Type(lp_campo)=="N"
		 	 	ldvalor="'"+ ALLTRIM(STR( &lp_campo )) +"'"
		 	 ENDIF

		ELSE 
			SET MESSAGE TO  "Tiene que Enviar el Parametro..."
		ENDIF
		RETURN ldvalor
	ENDPROC


	PROCEDURE verifica_registros
		PRIVATE ldele,lexi,lstate,lrec,ldare,lseek,lpos,lregi
		SELECT(This.Area) 
		lregi=AFIELDS(larre,This.Alias)
		lrec=RECNO()
		ldele=SET("Deleted")
		SET DELETED OFF 
		GO Top
		lexi=.F.
		SCAN
			&&&&&&&&&& Verifica Modificaciones &&&&&&&&&&&&
					  ********** Compara con la Imagen *******************
				  lseek="Seek("+This.Llave_Original +",'"+ALLTRIM(This.Alias)+"_Imagen')"
				  
				  IF &lseek and !DELETED(This.AreaImagen)
					    *********** Compara si han habidado modificaciones ****
					    FOR ln=1 TO lregi
					        lpos=ASCAN(This.Estructura, larre[ln,1]) 
					        IF lpos !=0 AND !UPPER(larre[ln,1])$UPPER(ALLTRIM(This.Campos_no_grabar)) 
			 		            lpos=(lpos + 1)/2
			 		            IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="C" OR ;
			 		               TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="M"
			 		               lotda="''"
			 		               lsimb="=="
			 		            ELSE
			 		               lsimb="="
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="N"
			 		                  lotda="0"
			 		               ENDIF
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="D"
			 		                  lotda="{}"
			 		               ENDIF
			 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="T"
			 		                  lotda="{}"
			 		               ENDIF
			 		            ENDIF
						        lcompar=" ! (NVL("+ALLTRIM(This.Alias)+"."+larre[ln,1]+","+lotda+")"+lsimb+"NVL("+ALLTRIM(This.Alias)+"_Imagen."+larre[ln,1]+","+lotda+")) "
						        &&WAIT WINDOW lcompar NOWait
						        IF &lcompar
						        	lexi=.T.
						        	Exit
							    ENDIF
				  	            lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
								lcadvalu=lcadvalu+"?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
						    ENDIF
					    ENDFOR
				ENDIF
			&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			IF  lexi
				EXIT
			ENDIF
			SELECT(This.Area) 
		ENDSCAN
		ldele="SET DELETED "+ldele
		&ldele
		GO top
		SCAN
			IF RECNO()=lrec
				EXIT
			ENDIF
		ENDSCAN
		RETURN lexi 
	ENDPROC


	PROCEDURE arma_xml
		IF !USED(This.Alias)
			SET MESSAGE TO "Cursor o Tabla "+lused+" No Esta Abierto o No Existe"
			RETURN ""
		ENDIF

		PRIVATE lcxml, ln, lregi, lpos
		lcxml=""

		SELECT (This.Area) 
		GO top
		SCAN
		    FOR ln=1 TO lregi
		        lpos=ASCAN(This.Estructura, larre[ln,1]) 
		        IF lpos !=0 AND !UPPER(larre[ln,1])$UPPER(ALLTRIM(This.Campos_no_grabar)) 
		 		            lpos=(lpos + 1)/2
		 		            IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="C" OR ;
		 		               TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="M"
		 		               lotda="''"
		 		               lsimb="=="
		 		            ELSE
		 		               lsimb="="
		 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="N"
		 		                  lotda="0"
		 		               ENDIF
		 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="D"
		 		                  lotda="{}"
		 		               ENDIF
		 		               IF TYPE(ALLTRIM(This.Alias)+"."+larre[ln,1])=="T"
		 		                  lotda="{}"
		 		               ENDIF
		 		            ENDIF
			        lcompar=" ! (NVL("+ALLTRIM(This.Alias)+"."+larre[ln,1]+","+lotda+")"+lsimb+"NVL("+ALLTRIM(This.Alias)+"_Imagen."+larre[ln,1]+","+lotda+")) "
			        &&WAIT WINDOW lcompar NOWait
			        IF &lcompar
					    IF !This.Estructura[lpos,2]=0
						   lcadupda=lcadupda+ALLTRIM(larre[ln,1])+"=?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
					    ENDIF
				    ENDIF
		  	            lcadinse=lcadinse+ALLTRIM(larre[ln,1])+","
					lcadvalu=lcadvalu+"?"+ALLTRIM(This.Alias)+"."+ALLTRIM(larre[ln,1])+","
			    ENDIF
		    ENDFOR
			SELECT (This.Area) 
		ENDSCAN


		CURSORTOXML(This.Alias,"lcxml",1,0)
		lcxml=STRTRAN(lcxml,'<?xml version ="1.0" encoding="Windows-1252"','')
		lcxml=STRTRAN(lcxml,'standlone="yes"?','')
		lcxml=STRTRAN(lcxml,'<VFPData>','')
		lcxml=STRTRAN(lcxml,'</VFPData>','')

		RETURN lcxml
	ENDPROC


	PROCEDURE orden_original
		PRIVATE lcddarea,lindex

		IF !EMPTY(This.Llave)
			lcddarea=SELECT()

			SELECT (This.Area) 
			lindex="Index On "+This.Llave+" TAG LLAVE " 
			&lindex

			SELECT (lcddarea)
		ENDIF
	ENDPROC


	*-- Devuelve los campos de la tabla separado por comas. Puede enviar un parametro para que lo devuelva con alias
	PROCEDURE columnas_select
		LPARAMETERS lp_alias as String 

		PRIVATE lcalias, lreturn ,lne, ltota
		lreturn=""
		lcalias=""
		IF TYPE("This.Estructura[1,1]")=="C"
			IF PARAMETERS()>0
				lcalias=ALLTRIM(lp_alias)+"."
			ENDIF
			ltota=ALEN(This.Estructura,1)
			IF ltota>0
				FOR lne=1 TO ltota
					lreturn=lreturn+lcalias+ALLTRIM(This.Estructura[lne,1])+","
				ENDFOR
			ENDIF

			IF LEN(lreturn)>0
				lreturn=LEFT(lreturn,LEN(lreturn)-1)
			ENDIF

		ENDIF

		RETURN lreturn 
	ENDPROC


	PROCEDURE mueve_item
		IF !EMPTY(NVL(This.Item,"")) AND TYPE("This.Item")=="C"

			PRIVATE litem,lxarea,lxreg,lrepla,llen,lcondi,lvalitem,lvalitemproc,lvalorigen,lcontinua
			lcontinua=.T.

			TRY 
				lxarea=SELECT()


				SELECT (This.Area) 
				lxreg=RECNO()
				litem=This.Item
				litem=&litem
				lvalorigen=VAL(litem)
				llen=LEN(ALLTRIM(litem))
				Oentorno.ItemOrigen=litem
				Oentorno.ItemDestino=litem


				xmueve=CREATEOBJECT("mueve_item",litem)
				xmueve.Visible=.T.
				xmueve.Show(1)

				RELEASE xmueve
			CATCH
				MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
			ENDTRY 

			IF !lcontinua
				RETURN 
			ENDIF


			IF !EMPTY(Oentorno.ItemDestino) AND TYPE("Oentorno.ItemDestino")=="C"
				IF Oentorno.ItemOrigen==Oentorno.ItemDestino
					RETURN 
				ENDIF
				TRY 
						lrepla="Replace "+This.Item+" With STR(VAL("+This.Item+"),"+ALLTRIM(STR(llen))+") For "+This.Item+"<>'"+litem+"' "
						&lrepla
						GO top
						SCAN
							IF RECNO()=lxreg
								EXIT 
							ENDIF
						ENDSCAN
						lvalitem=VAL(Oentorno.ItemDestino)
						lrepla="Replace "+This.Item+" WITH '"+Oentorno.ItemDestino+"' "
						&lrepla
						IF Oentorno.ItemOrigen>Oentorno.ItemDestino
							GO BOTTOM 
						ELSE
							GO TOP 
						ENDIF

						DO WHILE !EOF() AND !BOF()
							lcondi=ALLTRIM(This.Item)+"<>'"+Oentorno.ItemDestino+"' "
							IF &lcondi
								IF Oentorno.ItemOrigen>Oentorno.ItemDestino
									lrepla="lvalitemproc=VAL("+ALLTRIM(This.Item)+") "
									&lrepla
									IF lvalitemproc>=lvalitem AND lvalitemproc<lvalorigen
										lrepla="Replace "+ALLTRIM(This.Item)+" With STR(VAL("+ALLTRIM(This.Item)+")+1,"+ALLTRIM(STR(llen))+")" 
										&lrepla
									ENDIF
								ELSE
									lrepla="lvalitemproc=VAL("+ALLTRIM(This.Item)+") "
									&lrepla
									IF lvalitemproc<=lvalitem AND lvalitemproc>lvalorigen
										lrepla="Replace "+ALLTRIM(This.Item)+" With STR(VAL("+ALLTRIM(This.Item)+")-1,"+ALLTRIM(STR(llen))+")" 
										&lrepla
									ENDIF
								ENDIF

							ENDIF
							SELECT (This.Area)
							IF Oentorno.ItemOrigen>Oentorno.ItemDestino
								SKIP -1
							ELSE
								SKIP 1
							ENDIF
						ENDDO 
						GO TOP 
						lrepla="Replace "+ALLTRIM(This.Item)+" With STRTRAN(STR(VAL("+ALLTRIM(This.Item)+"),"+ALLTRIM(STR(llen))+"),' ','0') ALL " 
						&lrepla
						GO TOP 
						SCAN
							IF RECNO()=lxreg
								EXIT 
							ENDIF
						ENDSCAN

						IF !EMPTY(This.CuadriculaAsociada)
						    lrefre=ALLTRIM(This.CuadriculaAsociada)+".Refresh()"
						    &lrefre
						ENDIF
				CATCH TO lerror
					MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
				ENDTRY

			ENDIF

			SELECT (lxarea)


		ENDIF
	ENDPROC


	PROCEDURE encuentra_item
		IF !EMPTY(NVL(This.CuadriculaAsociada,"")) 
			PRIVATE lxcreate,lobject,lbusca,lcomma,lxreg
			Oentorno.Parametros[3,1]=""
			lxcreate="CreateObject('encuentra_item',"+ALLTRIM(This.CuadriculaAsociada)+")"
			lobject = &lxcreate
			lobject.Visible=.T.
			lobject.Show(1)
			RELEASE lobject
			IF !EMPTY(Oentorno.Parametros[3,1])
				lbusca="LOCATE FOR "+Oentorno.Parametros[3,1]+" ALL "
				SELECT (This.Area) 
				lxreg=RECNO()
				&lbusca
				IF EOF() OR BOF()
					WAIT WINDOW "No se encontro coincidencias" NOWAIT 
					GO BOTTOM 
				ENDIF
				lcomma=ALLTRIM(This.CuadriculaAsociada)+".Refresh()"
				&lcomma
				&&SET MESSAGE TO lbusca
			ENDIF


		ENDIF
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Init
		DIMENSION This.Llaves_anteriores[1,2] 
		IF !EMPTY(ALLTRIM(NVL(This.Campos_no_grabar,""))) 
			This.Campos_no_grabar=This.Campos_no_grabar+",MSREPL_TRAN_VERSION"
		ELSE
			This.Campos_no_grabar="MSREPL_TRAN_VERSION"
		ENDIF

		This.Llaves_anteriores[1,1]=.F.
		IF !EMPTY(This.NombreTabla ) AND !This.IndicadorActivado
			IF !EMPTY(This.Parametros)
			   This.Parametros=UPPER(STRTRAN(ALLTRIM(This.Parametros)," ",""))
			EndIF
			IF !EMPTY(This.Campos)
			   This.Campos=UPPER(STRTRAN(ALLTRIM(This.Campos)," ",""))
			EndIF
		*!*		IF !This.ArmaLlaves()
		*!*		   RETURN .f.
		*!*		EndIf
			IF !This.Antes_Armar_Estructura()
			   RETURN .f.
			EndIf
			IF !This.AlmacenaEstructura()
			   RETURN .f.
			ENDIF
			This.IndicadorActivado=.T.
			IF !This.No_Selecciona_Inicio 
				IF !This.Selecciona()
				    RETURN .f.
				ENDIF
				IF !This.ArmaSentencias()
				    RETURN .F.
				ENDIF
				This.No_selecciona_inicio = .F.
			ENDIF

		ENDIF
	ENDPROC


	PROCEDURE Destroy
		IF This.CerrarTabla
		   USE IN (This.Area)
		EndIf
	ENDPROC


	*-- En este Metodo puede Definir la Sentencia SQL_Select
	PROCEDURE defineselect
	ENDPROC


	PROCEDURE antes_armar_estructura
	ENDPROC


	*-- Este metodo se ejecuta Antes de Grabar de Acutualizar en la Base de Datos
	PROCEDURE antes_de_grabar
	ENDPROC


	*-- Este Metodo se ejecuta despues de Grabar en la Base de Datos
	PROCEDURE despues_grabar
	ENDPROC


	*-- Este Metodo se ejecuta ante de Grabar UN registro de la tabla que controla este Objeto
	PROCEDURE antes_grabar_registro
	ENDPROC


	*-- Este Metodo se ejecuta Despues de Grabar UN registro en la Base de Datos
	PROCEDURE despues_grabar_registro
	ENDPROC


	*-- Se ejecuta despues de Abrir un Registro
	PROCEDURE reemplazacampos
	ENDPROC


	*-- Devuelve los datos del Cursor en Forma de XML
	PROCEDURE cursor_xml
	ENDPROC


	*-- Retorna el Indice a la llave definida por el usuario
	PROCEDURE orden_llave
	ENDPROC


ENDDEFINE
*
*-- EndDefine: datos
**************************************************


**************************************************
*-- Class:        edicion (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  editbox
*-- BaseClass:    editbox
*-- Time Stamp:   08/14/06 11:58:11 AM
*
DEFINE CLASS edicion AS editbox


	FontName = "MS Sans Serif"
	FontSize = 8
	Height = 53
	Width = 100
	*-- nombre del OBJETO DATOS
	datoobjeto = ("")
	*-- .T. = indica que se asocia el nombre al controlsource,    .F.=no se asocia
	utilizanombre = .F.
	Name = "edicion"


	*-- Este metodo indica a que la tabla esta asociado a este objeto
	PROCEDURE asociatabla
		PARAMETERS ldata

		IF !EMPTY(ldata)
		    Wcamp=""
		    IF UPPER(This.Class)="EDICION" or This.UtilizaNombre
		       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
		    ELSE       
		      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
			EndIf    
		    &Wcomm
			Wthis="This.ControlSource='"+Wcamp+"'"
			&Wthis
		ENDIF
	ENDPROC


	PROCEDURE Init
		This.AsociaTabla(This.DatoObjeto)
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: edicion
**************************************************


**************************************************
*-- Class:        entorno (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/08/08 04:59:12 PM
*
DEFINE CLASS entorno AS custom


	*-- Año del Periodo
	ano = ("")
	*-- Mes del Periodo
	mes = ("")
	*-- Periodo
	periodo = ("")
	*-- Codigo de Compañia
	codigocia = ("")
	*-- Codigo de Sucursal
	codigosuc = ("")
	*-- Nombre de Compañia
	nombrecia = ("")
	*-- Nombre de Sucursal
	nombresuc = ("")
	*-- Codigo de Programa Activo
	programa = ("")
	*-- Titulo del Programa
	titulo = ("")
	*-- Periodo Real
	periodoreal = ("")
	*-- Carpeta donde se encuentra el Programa CURDIR()
	ruta = ("")
	*-- En esta propiedad swe gurda el Modulo Donde se encuntra al Activar el Menu
	modulo = ("")
	*-- La descripcion del Modulo que esta activo en un determinado momento
	nombremodulo = ("")
	*-- Gurda la Ruta del Carpeta del Sistema
	rutaosis = ("")
	rutareporte = ("")
	*-- Guarda la Tasa de Impuesto General a las Ventas
	tasa_igv = 0
	*-- Gurda el Código de la Moneda Nacional
	moneda = ("")
	*-- Guarda el Titulo de la Opcion en el Menu
	titulo_menu = ("")
	*-- En esta variable se gurda el R.U.C. de la Compañia
	ruccia = ("")
	tipo_bd = 1
	idioma_ingles = ("")
	*-- Guarda el Codigo del Almacén por Default
	almacen_default = ("")
	*-- Guarda el Numero de Serie de Facturación por Default
	serie_default = ("")
	*-- 0 - ODBC, 1 - SQL Server
	tipo_conexion_reporte = (0)
	nomina = ("")
	secuencia = ("")
	periodoplanilla = ("")
	nombrenomina = ("")
	unidad_red = ("")
	tienda = ("")
	programa_filtro = ("")
	basedatos_olap = ("")
	idioma_castellano = ("CA")
	itemorigen = ("")
	itemdestino = ("")
	*-- Que la carpeta osiscli es llamada de otra manera
	producto = .F.
	nombrecarpeta = ("Producto")
	Name = "entorno"

	*-- E
	compatible_osisv1 = .F.

	*-- En este metodo es puede guardar diferentes datos Ejem: Parametro[1,1]="LIMA", Parametro[1,2]="01"
	DIMENSION parametros[20,2]


	*-- Devuelve el tipo de Cambio
	PROCEDURE tipo_cambio
		LPARAMETERS lpfecha,lpmonnac,lpmonext,lptipo

		IF PARAMETERS()>=4
		   IF !TYPE("lpfecha")$"D,T"
		   	   WAIT WINDOW "Tipo Cambio =>Parametro Enviado no es de tipo Fecha" NoWait
		   	   RETURN 0
		   ENDIF
		   
			   
		   PRIVATE ltipcam,larea,lcad,ltipcam
		   
		   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


			&&PRIVATE larea,lcad,ltipcam
			ltipcam=0
			larea=SELECT()
			lcfecha=DTOC(lpfecha)

			IF Ocnx.Tipo_BD=4
				lcad="Select dbo.fx_tipo_cambio('"+lcfecha+"','"+lpmonnac+"','"+lpmonext+"','"+lptipo+"') as tipcam "
			ELSE
				lcad="Select dbo.fx_tipo_cambio(?lpfecha,'"+lpmonnac+"','"+lpmonext+"','"+lptipo+"') as tipcam "
			ENDIF

			IF Ocnx.Tipo_BD=1
				IF SQLEXEC(Ocnx.Conexion,lcad,"Ttipcam")<0
				   MESSAGEBOX("Error: "+MESSAGE(),16,"Tipo de Cambio")
				   RETURN 0
				ENDIF 
			ENDIF
			IF Ocnx.Tipo_BD=4
				IF !Ocnx.Ms_Ejecuta_SQL(lcad,"Ttipcam",ThisForm.DataSessionId)>0
				   MESSAGEBOX("Error: "+MESSAGE(),16,"Tipo de Cambio")
				   RETURN 0
				ENDIF 
			ENDIF


			IF !EOF()
			   ltipcam=NVL(Ttipcam.tipcam,0)
			ELSE
			   ltipcam=0
			ENDIF 
			IF USED("Ttipcam")
			   USE IN "Ttipcam"
			ENDIF

			SELECT (larea)

			RETURN ltipcam   
		   
		   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		   
		*!*	   ltipcam=Oapp.tipo_cambio(lpfecha,lpmonnac,lpmonext,lptipo,lpdatasession)
		*!*	   RETURN NVL(ltipcam,0)
		ELSE
		  MESSAGEBOX("Se esperan 4 parametros",64,"Tipo Cambio")
		  RETURN 0
		ENDIF 
	ENDPROC


	*-- Devuelve el IGV segun la fecha que UD. Envie
	PROCEDURE tasa_igv_fecha
		LPARAMETERS lpfecha

		IF PARAMETERS()=0
			lpfecha=DATE()
		ENDIF

		lcfecha=""
		IF TYPE("lpfecha")=="D"
			lcfecha=DTOC(lpfecha)
		ENDIF

		IF TYPE("lpfecha")=="T"
			lcfecha=DTOC(TTOD(lpfecha))
		ENDIF

		PRIVATE lsigv,ltigv

		lsigv="Select dbo.fx_porcen_impuesto('IGV','"+lcfecha+"') as tasigv "

		IF Ocnx.Tipo_BD=1
			IF SQLEXEC(Ocnx.Conexion,lsigv,"Ttasaigv")<0
			   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lsigv,16,"ERROR EN IGV")
			   RETURN 0
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lsigv,"Ttasaigv",ThisForm.DataSessionId)<0
			   MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lsigv,16,"ERROR EN IGV")
			   RETURN 0
			ENDIF
		ENDIF

		ltigv=NVL(Ttasaigv.tasigv,0)

		IF USED("Ttasaigv")
		   USE IN "Ttasaigv"
		ENDIF

		RETURN ltigv
	ENDPROC


	*-- Devuelve el Periodo Siguiente a un Periodo que se envia como parametro. Puede enviar un parametro numerico 1 para indicar que se tome en cuenta el Periodo Cierre y Apertura
	PROCEDURE periodo_siguiente
		LPARAMETERS lp_periodo as Character , lp_indica_cierre_apertura as Number 

		PRIVATE lperiodo_devuelto ,lpfin,lpini

		IF PARAMETERS()=0
		   MESSAGEBOX("Se espera como Minimo Un Parametro [Periodo]",64,"Periodo Siguiente")
		   RETURN ''
		ENDIF


		IF PARAMETERS()=1
		    lpfin='12'
		    lpini='01'
		ENDIF
		 
		IF PARAMETERS()=2
		    lpfin='13'
		    lpini='00'
		ENDIF

		lperiodo_devuelto=IIF(Right(lp_periodo,2)=lpfin,;
		                      STR(VAL(LEFT(lp_periodo,4))+1,4)+lpini,;
		                      LEFT(lp_periodo,4)+ STRTRAN(STR(VAL(Right(lp_periodo,2))+1,2),' ','0');
		                     )
		RETURN lperiodo_devuelto 
	ENDPROC


	*-- Devuelve el Periodo Anterior a un periodo enviando como parametro el periodo , puede enviar un parametro numerico 1 para indicar que se tome en cuenta el Periodo Cierre y Apertura
	PROCEDURE periodo_anterior
		LPARAMETERS lp_periodo as Character , lp_indica_cierre_apertura as Number 

		PRIVATE lperiodo_devuelto ,lpfin,lpini

		IF PARAMETERS()=0
		   MESSAGEBOX("Se espera como Minimo Un Parametro [Periodo]",64,"Periodo Siguiente")
		   RETURN ''
		ENDIF


		IF PARAMETERS()=1
		    lpfin='12'
		    lpini='01'
		ENDIF
		 
		IF PARAMETERS()=2
		    lpfin='13'
		    lpini='00'
		ENDIF

		lperiodo_devuelto=IIF(Right(lp_periodo,2)=lpini,;
		                      STR(VAL(LEFT(lp_periodo,4))-1,4)+lpfin,;
		                      LEFT(lp_periodo,4)+ STRTRAN(STR(VAL(Right(lp_periodo,2))-1,2),' ','0');
		                     )
		RETURN lperiodo_devuelto 
	ENDPROC


	PROCEDURE configura_impresora
		PRIVATE  lcOldError
		lcOldError = ON("ERROR")
		ON ERROR *
		=SYS(1037)
		ON ERROR &lcOldError
		retu
	ENDPROC


	PROCEDURE info_server
		LPARAMETERS p_tipo
		LOCAL ls_cad , ln_area
		ln_area = SELECT()
		IF p_tipo='FECHA'
			LOCAL lt_fecact
			lt_fecact = DATETIME()
			ls_cad = "Select Getdate() as fecha "
			IF SQLEXEC(ocnx.conexion,ls_cad,'cur_Info_server')>0
				IF !EOF()
					lt_fecact = cur_Info_server.fecha
				ENDIF 
			ELSE
				=MESSAGEBOX("Error al obtener Fecha de Servidor: "+MESSAGE(),16) 
			ENDIF
			SELECT (ln_area)
			RETURN  lt_fecact
		ENDIF 

		IF p_tipo='USUARIO'
			LOCAL ls_usuario
			ls_usuario= ""
			ls_cad = "Select Suser_sname() as usuario "
			IF SQLEXEC(ocnx.conexion,ls_cad,'cur_Info_server')>0
				IF !EOF()
					ls_usuario = cur_Info_server.usuario 
				ENDIF 
			ELSE
				=MESSAGEBOX("Error al obtener Usuario de Servidor: "+MESSAGE(),16) 
			ENDIF
			SELECT (ln_area)
			RETURN  ls_usuario
		ENDIF 

		SELECT (ln_area)
		RETURN 

	ENDPROC


	PROCEDURE limpia_mensaje
		LPARAMETERS lp_cadena as String 

		IF PARAMETERS()=0
			RETURN ""
		ENDIF

		PRIVATE lr_cadena

		lr_cadena=STRTRAN(lp_cadena,"Error de conectividad: [Microsoft][ODBC SQL Server Driver][SQL Server]","")
		lr_cadena=STRTRAN(lp_cadena,"Connectivity error: [Microsoft][ODBC SQL Server Driver][SQL Server]","")
		lr_cadena=STRTRAN(lp_cadena,"Connectivity error: [Microsoft][SQL Native Client][SQL Server]","")
		&&lr_cadena=STRTRAN(lp_cadena,"Connectivity error: [Microsoft][ODBC SQL Server Driver][SQL Server]","")
		RETURN lr_cadena
	ENDPROC


	PROCEDURE diferencia_horas
		LPARAMETERS lp_horini as Decimal , lp_horfin as Decimal,lp_turno  as Character 

		SET MESSAGE TO ''


		PRIVATE lreturn,ln,lhorfin,ldecimal,lhorini,ldecima1


		IF PARAMETERS()<3
			MESSAGEBOX("Falta Parametors (Hora Inicio Decmimal , Hora Fin Decima)",16,"Parametro Hora")
			RETURN 0
		ENDIF

		lreturn=0

		IF lp_horfin>24 OR lp_horini>24
			MESSAGEBOX("Hora No Puede ser Mayor 24",16,"Horas")
			RETURN 0
		ENDIF

		IF lp_horfin<13 AND lp_horini<13
		   IF  lp_horfin<lp_horini
		   		WAIT WINDOW "Diferencia de Horas Negativa..." NoWait
		   		RETURN 0
		   ENDIF
		ENDIF

		IF lp_horfin>=13 AND lp_horini>=13
		   IF  lp_horfin<lp_horini
		   		WAIT WINDOW "Diferencia de Horas Negativa..." NoWait
		   		RETURN 0
		   ENDIF
		ENDIF

		IF lp_turno=="N"
			IF (lp_horfin<=12 AND lp_horini>=13)
				lp_horfin=24 + lp_horfin
				SET MESSAGE TO 'Tomando Horas del Dia Siguiente'
			ENDIF
		ENDIF


		&&& Ajustando Hora Inicial &&&&

		lhorini=INT(lp_horini)


		ldecima1=lp_horini-INT(lp_horini)

		IF ldecima1>0
			IF ldecima1>=.15 AND ldecima1<.30
			   	  ldecima1 = .25
			Else	  
				IF ldecima1>=.30 AND ldecima1<.45
				   ldecima1 = .50
				ELSE
				   IF ldecima1>=.45	AND ldecima1<.60
					   ldecima1 = .75
				   ENDIF
				ENDIF
			ENDIF
		ENDIF


		lp_horini=lhorini + ldecima1
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


		&&& Ajustando Hora Final &&&&
		lhorfin=INT(lp_horfin)


		IF (lp_horfin<13 AND lp_horini>lp_horfin) AND !(lp_horfin<=12 AND lp_horini>=13) AND INT(lp_horini)<>INT(lp_horfin) 
			FOR ln=1 TO 12
				IF INT(lp_horfin)=ln
				   lhorfin=INT(lp_horfin) + 12 
				ENDIF
			ENDFOR

		ENDIF


		ldecimal=lp_horfin - INT(lp_horfin)

		IF ldecimal>0
		   IF ldecimal<=.15  
		      ldecimal = .25
		   Else	  
			   IF ldecimal<=.30
				  ldecimal = .50
			   Else 
			   	  IF ldecimal <= .45	  
				      ldecimal = .75
				  ELSE
				  	  ldecimal = 1
				  ENDIF
				      
			   ENDIF
		   EndIf
		ENDIF

		lp_horfin=lhorfin + ldecimal
		&&&&&&&&&&&&&&&&&&&&&&&


		lreturn = lp_horfin -  lp_horini

		SET MESSAGE TO "HORA DEVULETA: "+TRANSFORM(lreturn,"99999.99")+" "+;
					   "HORA INICIAL: "+TRANSFORM(lp_horini,"99999.99")+" "+;
				       "HORA FINAL: "+TRANSFORM(lp_horfin,"99999.99")+" "+;
				       "TURNO: "+lp_turno
		RETURN lreturn 
	ENDPROC


	PROCEDURE estructura_tabla
		LPARAMETERS lp_tabla as String , lp_alias as String, lp_datasession as Session 

		IF PARAMETERS()>=2
			PRIVATE lexe
			lexe="Exec dbo.PA_ESTRUCTURA_TABLA  '"+lp_tabla+"'"

			IF 	Ocnx.Tipo_BD=2 
		*!*				lexe=""+;
		*!*							 "Select  b.position,"+;
		*!*							 "        a.column_name,"+;
		*!*							 "        a.data_type,"+;
		*!*							 "        a.data_length,"+;
		*!*							 "        a.data_precision,"+;
		*!*							 "        a.data_scale,"+;
		*!*							 "        a.nullable,"+;
		*!*							 "        a.column_id "+;
		*!*							 "From USER_TAB_COLUMNS a "+; 
		*!*							 "Left Join ALL_CONS_COLUMNS b "+;
		*!*							 "On (b.TABLE_NAME=a.TABLE_NAME "+;
		*!*							 "and b.column_name=a.column_name "+;
		*!*							 "and b.position<>0) "+;
		*!*							 "Where UPPER(a.TABLE_NAME)='"+lp_tabla+"' "						 
				lexe="Select * from rehu.SYS_USER_TAB_COLUMNS 		"+;
					 "Where UPPER(a.TABLE_NAME)='"+lp_tabla+"'      "						 
			ENDIF

			IF PARAMETERS()=3
				SET DATASESSION TO lp_datasession
			ENDIF
			IF SQLEXEC(Ocnx.Conexion,lexe,lp_alias)<0
				MESSAGEBOX(This.Limpia_mensaje(MESSAGE())+CHR(13)+CHR(13)+lexe,16,"Estructura")
				RETURN .F.
			ENDIF
		ELSE
			MESSAGEBOX("Falta Enviar Parametros",16,"Estructura")
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE Init
		IF TYPE("Oentorno")=="O"
			ln=AMEMBERS(larr,Oentorno,3,"G")
			Wnocambia="PARENT,CONTROLCOUNT,CONTROLS,OBJECTS,PARENTCLASS,PICTURE,BASECLASS,CLASSLIBRARY"
			FOR li=1 TO ln 
			    IF UPPER(larr[li,2])=="PROPERTY" AND !ALLTRIM(UPPER(larr[li,1]))$Wnocambia
			       Wcond="Empty(This."+ALLTRIM(larr[li,1])+")"
			       IF TYPE("This."+ALLTRIM(larr[li,1]))<>"U"
				       IF &Wcond
					       Wcom="This."+ALLTRIM(larr[li,1])+"=Oentorno."+ALLTRIM(larr[li,1])
					       &Wcom
					   EndIf    
				   ENDIF
				   
			    ENDIF
			ENDFOR
		ENDIF

		 
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: entorno
**************************************************


**************************************************
*-- Class:        etiqueta (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   07/08/06 09:18:09 AM
*
DEFINE CLASS etiqueta AS label


	AutoSize = .T.
	FontName = "MS Sans Serif"
	FontSize = 8
	BackStyle = 0
	Caption = "Etiqueta"
	Width = 41
	*-- Escriba el dato de la propiedad Caption pero en Ingles
	caption_in = ("")
	Name = "etiqueta"


	PROCEDURE Init
		IF TYPE("Ocnx")=="O"
		   IF Ocnx.idioma==Oentorno.Idioma_Ingles
		      IF !EMPTY(NVL(This.Caption_in,"")) && Ingles 
		         This.Caption=This.Caption_in 
		      ENDIF
		   ENDIF
		EndIf
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: etiqueta
**************************************************


**************************************************
*-- Class:        indices (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/14/06 11:58:14 AM
*
DEFINE CLASS indices AS custom


	*-- Indique el Nro de Indice que Aparecera por defecto
	indicedefault = 0
	Name = "indices"

	*-- En esta propiedad arreglo [expresion,titulo] guarde los indices que quiere utilizar para un tabla. Eje: This.indices[1,1]="cco_codcco" , This.indices[1,2]=""CODIGO"
	DIMENSION indice[10,2]


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: indices
**************************************************


**************************************************
*-- Class:        lista (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Time Stamp:   08/14/06 11:59:08 AM
*
DEFINE CLASS lista AS listbox


	FontName = "MS Sans Serif"
	Height = 170
	Width = 167
	Name = "lista"


ENDDEFINE
*
*-- EndDefine: lista
**************************************************


**************************************************
*-- Class:        maestro (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   05/08/08 05:57:06 PM
*
DEFINE CLASS maestro AS form


	Height = 324
	Width = 375
	DoCreate = .T.
	ShowTips = .T.
	AutoCenter = .T.
	Caption = "Form"
	FontName = "MS Sans Serif"
	*-- Indica que tipo de formulario esta activo:FORM,MENU,PROC. Este dato es importatnte para saber como se comportan las opciones de menu
	tipo = ("")
	*-- Si esta en .T. permite ingresar nuevos registros
	habilita_nuevo = .T.
	*-- Si esta en .T. permite ingresar modificar los cambios
	habilita_grabar = .T.
	*-- 1.- Nuevo , 2.- Modificacion, 4.- Elimina , 6.- Anula
	estado = 2
	*-- En esta propiedad uno puede definir a que ventana llamar para la busqueda
	buscaformulario = ("")
	*-- Programa que controla el formato
	formatoprograma = ("")
	*-- Si es 1 Cristal Report , 2 Es de la Plataforma OSIS
	formatotipo = 1
	*-- Si esta en .T. cuando se habra la ventana de Busqueda el Foco se hirá de frente al dato que busca
	buscar_datos_buscar_foco = .T.
	*-- Si esta en .T. al activarse la busqueda se y se encuntre en el Campo a Buscar. Buscara mientras este digitando los datos
	buscar_presiona_tecla = .T.
	Name = "maestro"

	*-- Si esta en .T. permite eliminar registros
	habilita_elimina = .F.

	*-- Si esta en .T. permite anular registro
	habilita_anular = .F.

	*-- Si Esta en .T. Activa un cursor que servira de guia en la pantallas de tipo Formulario. Utilizelo solo en Formularios
	activacursor = .F.
	habilita_reporte = .F.

	*-- Se envira como parametro al formulario de reportes
	reportedatosfijos = .F.
	habilita_formato = .F.

	*-- Verifica si los registros has sufrido algúna modificación
	verifica_modificacion = .F.
	habilita_otros = .F.
	buscar_particion = .F.


	ADD OBJECT entorno AS entorno WITH ;
		Top = 12, ;
		Left = 24, ;
		Height = 17, ;
		Width = 48, ;
		Name = "entorno"


	ADD OBJECT statusbar AS olecontrol WITH ;
		Top = 301, ;
		Left = 0, ;
		Height = 23, ;
		Width = 375, ;
		Anchor = 14, ;
		Align = 2, ;
		Name = "StatusBar"


	ADD OBJECT cristal AS cristal WITH ;
		Top = 12, ;
		Left = 301, ;
		Name = "Cristal"


	*-- Imprime Formato del Documento
	PROCEDURE formato
		LPARAMETERS ldestino
	ENDPROC


	*-- Imprime Información
	PROCEDURE imprime
		LPARAMETERS lprograma

		IF PARAMETERS()=0

			PRIVATE lcad
			lcad="Select s07_reppro "+;
			     "From SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+NVL(ThisFOrm.Entorno.Programa,"")+"' "

			IF Ocnx.Tipo_BD = 2
				lcad="Select s07_reppro "+;
				     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
				     "Where s07_codopc='"+NVL(ThisFOrm.Entorno.Programa,"")+"' "
			ENDIF 

			IF Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=2
				IF SQLEXEC(Ocnx.Conexion,lcad,"Trepor")<0
				   MESSAGEBOX("Error: "+MESSAGE(),16,Error)
				   RETURN .F.
				ENDIF
			ENDIF

			IF Ocnx.Tipo_BD=4
				IF Ocnx.Ms_Ejecuta_SQL(lcad,"Trepor",This.DataSessionId)<0
				   MESSAGEBOX("Error: "+MESSAGE(),16,Error)
				   RETURN .F.
				ENDIF
			ENDIF

			IF !EMPTY(NVL(s07_reppro,''))
			   lprograma=Trepor.s07_reppro
			   IF USED("Trepor")
			      USE IN "Trepor"
			   ENDIF
			ENDIF
			IF USED("Trepor")
			   USE IN "Trepor"
			ENDIF
		   
		   IF EMPTY(NVL(lprograma,''))
			  MESSAGEBOX("SE ESPERABA UN PARAMETRO",16,"REPORTE")
			  RETURN .F.
		   ENDIF
		   
		ENDIF

		PRIVATE lcad,lventana


		lcad="Select "+;
			 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, "+;
			 "S07_PASSWO, S07_REPPRO, S07_FORPRO, S22_CODS22, "+;
			 "S07_FILTRO, S10_CODS10, S07_ACTOPC, S07_OBSPRO, "+;
			 "S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU "+;
		     "From SYS_TABLA_OPCIONES_S07 "+;
		     "Where s07_codopc='"+NVL(lprograma,"")+"' "
		     
		IF Ocnx.Tipo_BD = 2
			lcad="Select "+;
				 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, "+;
				 "S07_PASSWO, S07_REPPRO, S07_FORPRO, S22_CODS22, "+;
				 "S07_FILTRO, S10_CODS10, S07_ACTOPC, S07_OBSPRO, "+;
				 "S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU "+;
			     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+NVL(lprograma,"")+"' "
		ENDIF      

		IF Ocnx.Tipo_BD=1    OR Ocnx.Tipo_BD=2
			IF SQLEXEC(Ocnx.Conexion,lcad,"Topcrep")<0
			   MESSAGEBOX("ERROR: "+MESSAGE(),16,Gcia)
			   RETURN .F.
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4     
			IF Ocnx.ms_ejecuta_Sql(lcad,"Topcrep",This.DataSessionId)<0
			   MESSAGEBOX("ERROR: "+MESSAGE(),16,Gcia)
			   RETURN .F.
			ENDIF
		ENDIF


		Oentorno.Titulo=Topcrep.s07_noms07
		IF !Topcrep.s09_tipopc$"INFO,INVF"
		   MESSAGEBOX("EL PROGRAMA: "+lprograma+" NO ESTA INDENTIFICADO COMO REPORTE",64,"REPORTE")
		   RETURN .F.
		ENDIF

		lventana=ThisForm.Entorno.Rutaosis+"FORMS\REPORTES"

		Oentorno.Programa_Filtro=""
		IF !EMPTY(NVL(Topcrep.s07_filtro,''))
			Oentorno.Programa_Filtro=ALLTRIM(Topcrep.s07_filtro)
		    lventana=ThisForm.Entorno.Ruta+"FORMS\"+ALLTRIM(Topcrep.s07_filtro)
		ENDIF
		lventana=ALLTRIM(UPPER(lventana))

		IF 	LEFT(lventana,2)<>SYS(5)
			lventana=SYS(5)+lventana
		ENDIF


		IF !FILE(lventana+".SCT")
		   MESSAGEBOX("EL FORMULARIO: "+lventana+".SCT NO EXISTE",16,"ERROR")
		   RETURN .F. 
		ENDIF

		OEntorno.Codigocia=ThisForm.Entorno.Codigocia
		OEntorno.Codigosuc=ThisForm.Entorno.Codigosuc
		OEntorno.Ano=ThisForm.Entorno.Ano
		OEntorno.Mes=ThisForm.Entorno.Mes
		OEntorno.Periodo=ThisForm.Entorno.Periodo
		OEntorno.PeriodoReal=ThisForm.Entorno.PeriodoReal
		OEntorno.Modulo=ThisForm.Entorno.Modulo
		OEntorno.Programa=lprograma
		OEntorno.modulo=ThisForm.Entorno.modulo
		OEntorno.NombreModulo=ThisForm.Entorno.NombreModulo

		IF Topcrep.s09_tipopc="INFO"
		   ltiprep="2"
		ENDIF

		IF Topcrep.s09_tipopc="INVF"
		   ltiprep="1"
		ENDIF


		IF USED("Topcrep")
		   USE IN "Topcrep"
		ENDIF


		ldo="DO FORM "+lventana+" WITH This.ReporteDatosFijos "
		&ldo
		     
	ENDPROC


	*-- Abre una Ventana (Formulario) que reciba como parametro el Objeto Entorno
	PROCEDURE abrir
		LPARAMETERS lventana,lretorno,lruta,lparametro

		private lcad,lnumpar

		lnumpar=PARAMETERS()

		lentorno=ThisForm.Entorno

		IF EMPTY(lruta)
		   lruta=Oentorno.ruta
		   IF LEFT(lruta,3)<>SYS(5)
		      lruta=SYS(5)+lruta
		   ENDIF
		ENDIF


		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		&&&&&&&& Verificamos si ya esta abierta la ventana &&&&&&&&&&&&&&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		PRIVATE lexiste , lnfor,lnumventana

		lexisteventana=.F.
		lnumventana=0

		IF _Screen.FormCount>0
			FOR lnfor=1 TO _Screen.FormCount
				IF TYPE("_Screen.Forms["+ALLTRIM(STR(lnfor))+"].Entorno")=="O"
					IF ALLTRIM(UPPER(_Screen.Forms[lnfor].Entorno.Programa))==ALLTRIM(UPPER(lventana))
						lnumventana=lnfor
						lexisteventana=.T.
						EXIT 
					ENDIF
				ENDIF
			ENDFOR
		ENDIF
		 
		IF lexisteventana AND lnumventana>0
			SET MESSAGE TO "Muestra Programa: "+ALLTRIM(lventana)
			IF 	_Screen.Forms[lnumventana].WindowState=1
				_Screen.Forms[lnumventana].WindowState=0
			ENDIF
			_Screen.Forms[lnumventana].Show()
			RETURN 
		ENDIF


		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

		lruta1=This.Entorno.Rutaosis
		lforms="forms"

		IF !FILE(lruta1+"FormSYS\"+ALLTRIM(lventana)+".SCT") && Primero Verifico en FormSYS
			IF !FILE(UPPER(lruta+"forms\"+ALLTRIM(lventana)+".SCT"))
			   MESSAGEBOX("El Formulario: "+UPPER(lruta+"forms\"+ALLTRIM(lventana)+".SCT")+" NO EXISTE",64,"Error")
			   RETURN .f.
			ENDIF
		ELSE
			lruta=lruta1
			lforms="FormSYS"
		ENDIF


		IF Ocnx.Tipo_BD=1 
			lcad="Select "+;
				 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, "+;
				 "S07_PASSWO, S07_REPPRO, S07_FORPRO, S22_CODS22, "+;
				 "S07_FILTRO, S10_CODS10, S07_ACTOPC, S07_OBSPRO, "+;
				 "S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU, "+;
				 "S07_noming "+;
			     "From SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+lventana+"' "
		ENDIF


		IF Ocnx.Tipo_BD=2
			lcad="Select "+;
				 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, "+;
				 "S07_PASSWO, S07_REPPRO, S07_FORPRO, S22_CODS22, "+;
				 "S07_FILTRO, S10_CODS10, S07_ACTOPC, S07_OBSPRO, "+;
				 "S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU, "+;
				 "S07_noming "+;
			     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+lventana+"' "
		ENDIF 
		          
		          
		IF Ocnx.Tipo_BD=3
			lcad="Select "+;
				 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, "+;
				 "S07_PASSWO, S07_REPPRO, S07_FORPRO, S22_CODS22, "+;
				 "S07_FILTRO, S10_CODS10, S07_ACTOPC, S07_OBSPRO, "+;
				 "S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU, "+;
				 "S07_noming "+;
			     "From SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+lventana+"' "
		ENDIF

		IF Ocnx.Ms_Ejecuta_SQL(lcad,"Topcion",This.DataSessionId)<0
		   RETURN .F.
		ENDIF

		     
		IF !EOF()
		    Oentorno.titulo=Topcion.s07_noms07
		    Oentorno.programa=Topcion.s07_codopc
		    IF This.Entorno.Idioma_ingles == Ocnx.idioma AND !EMPTY(NVL(Topcion.s07_noming,""))
			    Oentorno.titulo=NVL(Topcion.s07_noming,"")
		    ENDIF
		     
		ENDIF

		IF USED("Topcion")
		   USE in "Topcion" 
		ENDIF
		    
		lprr=IIF(!EMPTY(lparametro)," WITH lparametro ","")
		SET messa to 'Abriendo la Ventana: '+ALLTRIM(lventana)+'....'
		IF lnumpar<2
		   ldo="Do Form '"+lruta+lforms+"\"+ALLTRIM(lventana)+"' "+lprr
		   lrt="Return"
		ELSE
			ldo="Do Form '"+lruta+lforms+"\"+ALLTRIM(lventana)+"' "+lprr+" to lretorno "
			lrt="Return lretorno"
		EndiF

		&ldo
		&lrt
	ENDPROC


	*-- Este Evento se ejecuta para cerrar la Ventana Activa
	PROCEDURE cerrar
		&&Otbr.Grid=.F.
		OtbrItem.Grid=.F.
		This.Hide()
		ThisForm.Release()
	ENDPROC


	*-- Este Metodo llama a un formualario donde se muestran las Tablas del Sistema
	PROCEDURE tablas
		DO FORM Tablas
	ENDPROC


	*-- Devuelve el Nro de Formulario que tiene dentro del Objeto _Screen
	PROCEDURE formulario_numero
		FOR ln=1 TO _Screen.FormCount
		    lname=_Screen.Forms[ln].Name
		    IF UPPER(lname)==UPPER(This.Name)
		       RETURN ln
		    ENDIF
		ENDFOR
		RETURN 0
	ENDPROC


	*-- Se utiliza para controlar Objetos datos
	PROCEDURE datosaccion
		LPARAMETERS laccion,ldato

		IF PARAMETERS()<2
		   MESSAGEBOX("AQUI SE ESPERABA 2 PARAMETROS",64,"ERROR")
		   RETURN .f.
		EndIf

		IF EMPTY(ldato)
		   MESSAGEBOX("Parametro no define un Objeto tipo Dato",64,"Error")
		   RETURN 
		ENDIF

		IF !TYPE("This."+ALLTRIM(ldato))=="O"
			SET message TO 'No Existe el Objeto Datos: '+ALLTRIM(ldato)
			RETURN 
		ENDIF


		IF laccion=1 && Nuevo Item
		   lejecuta="This."+ALLTRIM(ldato)+".Nuevo()"
		ENDIF

		IF laccion=2 && Elimina Item
		   lejecuta="This."+ALLTRIM(ldato)+".Elimina()"
		ENDIF

		IF laccion=3 && Inserta Item
		   lejecuta="This."+ALLTRIM(ldato)+".Inserta()"
		ENDIF

		IF laccion=4 && Inserta Item
		   lejecuta="This."+ALLTRIM(ldato)+".Encuentra_Item()"
		ENDIF

		IF laccion=7 && Inserta Item
		   lejecuta="This."+ALLTRIM(ldato)+".Mueve_item()"
		ENDIF


		&lejecuta
	ENDPROC


	*-- En este metodo se copian las porpiedades del Objeto ENTORNO a la variable publica OENTORNO
	PROCEDURE copia_entorno
		IF TYPE("Oentorno")=="O"
			ln=AMEMBERS(larr,This.Entorno,3,"G")
			Wnocambia="PARENT,CONTROLCOUNT,CONTROLS,OBJECTS,PARENTCLASS,PICTURE,BASECLASS,CLASSLIBRARY"
			FOR li=1 TO ln 
			    IF UPPER(larr[li,2])="PROPERTY" AND !ALLTRIM(UPPER(larr[li,1]))$Wnocambia
			       Wcom="Oentorno."+ALLTRIM(larr[li,1])+"=This.Entorno."+ALLTRIM(larr[li,1])
			       &Wcom
			    ENDIF
			ENDFOR
		ENDIF
	ENDPROC


	*-- Verifica que la fecha Eviada Pertenesca al Periodo del Entorno
	PROCEDURE verifica_fecha_periodo
		LPARAMETERS lpfecha

		IF PARAMETERS()=0 OR !(TYPE("lpfecha")=="D" OR TYPE("lpfecha")=="T")
		   MESSAGEBOX("TIENE QUE MANDAR UN PARAMETRO DE TIPO FECHA",64,"VERIFICA FECHA")
		   RETURN .F.
		ENDIF

		IF LEFT(DTOS(lpfecha),6)<>This.Entorno.Periodo
		   MESSAGEBOX("LA FECHA NO PERTENECE AL PERIODO",64,"PERIODO")
		   RETURN .F.
		ENDIF
		RETURN .T.
	ENDPROC


	PROCEDURE password
		This.Abrir("cambia_password","",This.Entorno.Rutaosis,Ocnx.Usuario)
		&&DO FORM This.Entorno.Rutaosis+"Forms\cambia_password"  
	ENDPROC


	PROCEDURE actualiza_session
		Ocnx.Session=This.DataSessionId 
	ENDPROC


	PROCEDURE periodo_planilla
		LPARAMETERS lp_ano as String ,lp_mes as String, lp_nomina as String 

		IF PARAMETERS()<3
			MESSAGEBOX("Faltan Parametros Para el Periodo de la Planilla",64,This.Caption)
			RETURN ""
		ENDIF

		PRIVATE lcse,lcarea,lcalias,lcretu

		lcretu=""
		lcarea=SELECT()

		IF Ocnx.Tipo_BD=1
			lcse="Select ISNULL(MAX(ppe_corppe),'') as ppe_corppe "+;
				 "From dbo.PERIODO_PLANILLA_PPE "+;
				 "Where cia_codcia='"+Oentorno.CodigoCia+"' "+;
				 "and   suc_codsuc='"+Oentorno.CodigoSuc+"'	"+;
				 "and   ano_codano='"+lp_ano+"' "+;
				 "and   mes_codmes='"+lp_mes+"' "+;
				 "and   tpl_codtpl='"+lp_nomina+"' "
		ENDIF
			 
		IF Ocnx.Tipo_BD=2
			lcse="Select Nvl(MAX(ppe_corppe),'') as ppe_corppe "+;
				 "From "+Ocnx.Esquema+".PERIODO_PLANILLA_PPE "+;
				 "Where cia_codcia='"+Oentorno.CodigoCia+"' "+;
				 "and   suc_codsuc='"+Oentorno.CodigoSuc+"'	"+;
				 "and   ano_codano='"+lp_ano+"' "+;
				 "and   mes_codmes='"+lp_mes+"' "+;
				 "and   tpl_codtpl='"+lp_nomina+"' "
		ENDIF


		lcalias=SYS(2015)

		IF SQLEXEC(Ocnx.Conexion,lcse,lcalias)<0
			MESSAGEBOX(MESSAGE()+CHR(13)+lcse,16,This.Caption)
			RETURN ""
		ENDIF

		lcretu=lp_ano+lp_mes+lp_nomina+ppe_corppe

		IF USED(lcalias)
			lused="Use in '"+lcalias+"'"
			&lused
		ENDIF

		SELECT (lcarea)


		RETURN lcretu
	ENDPROC


	PROCEDURE formulario_filtro
		LPARAMETERS lprograma

		IF PARAMETERS()=0

			PRIVATE lcad
			lcad="Select s07_reppro "+;
			     "From SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+ThisFOrm.Entorno.Programa+"' "

			IF Ocnx.Tipo_BD = 2
				lcad="Select s07_reppro "+;
				     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
				     "Where s07_codopc='"+ThisFOrm.Entorno.Programa+"' "
			ENDIF 


			IF Ocnx.Tipo_BD=1
				IF SQLEXEC(Ocnx.Conexion,lcad,"Trepor")<0
				   MESSAGEBOX("Error: "+MESSAGE(),16,Error)
				   RETURN .F.
				ENDIF
			ENDIF
			IF Ocnx.Tipo_BD=4
				IF Ocnx.Ms_Ejecuta_SQL(lcad,"Trepor",This.DataSessionId)<0
				   MESSAGEBOX("Error: "+MESSAGE(),16,Error)
				   RETURN .F.
				ENDIF
			ENDIF

			IF !EMPTY(NVL(s07_reppro,''))
			   lprograma=Trepor.s07_reppro
			   IF USED("Trepor")
			      USE IN "Trepor"
			   ENDIF
			ENDIF
			IF USED("Trepor")
			   USE IN "Trepor"
			ENDIF
		   
		   IF EMPTY(NVL(lprograma,''))
			  MESSAGEBOX("SE ESPERABA UN PARAMETRO",16,"FORMULARIO FILTRO")
			  RETURN .F.
		   ENDIF
		   
		ENDIF

		PRIVATE lcad,lventana


		lcad="Select "+;
			 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, S07_PASSWO, "+;
			 "S07_REPPRO, S07_FORPRO, S22_CODS22, S07_FILTRO, S10_CODS10, "+;
			 "S07_ACTOPC, S07_OBSPRO, S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU "+;
		     "From SYS_TABLA_OPCIONES_S07 "+;
		     "Where s07_codopc='"+lprograma+"' "
		  
		IF Ocnx.Tipo_BD =2
			lcad="Select "+;
				 "S07_CODOPC, S07_NOMS07, S09_TIPOPC, S05_CODTRA, S07_PASSWO, "+;
				 "S07_REPPRO, S07_FORPRO, S22_CODS22, S07_FILTRO, S10_CODS10, "+;
				 "S07_ACTOPC, S07_OBSPRO, S07_INDEST, S07_FECACT, S07_CODUSU, S07_MAQUSU "+;
			     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc='"+lprograma+"' "
		ENDIF      

		IF Ocnx.Tipo_BD=1   OR Ocnx.Tipo_BD=2  
			IF SQLEXEC(Ocnx.Conexion,lcad,"Topcrep")<0
			   MESSAGEBOX("ERROR: "+MESSAGE(),16,Gcia)
			   RETURN .F.
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4     
			IF Ocnx.Ms_Ejecuta_SQL(lcad,"Topcrep",This.DataSessionId)<0
			   MESSAGEBOX("ERROR: "+MESSAGE(),16,Gcia)
			   RETURN .F.
			ENDIF
		ENDIF


		Oentorno.Titulo=Topcrep.s07_noms07
		IF !Topcrep.s09_tipopc$"FXML"
		   MESSAGEBOX("EL PROGRAMA: "+lprograma+" NO ESTA INDENTIFICADO COMO FILTRO",64,"REPORTE")
		   RETURN .F.
		ENDIF

		lventana=""


		IF !EMPTY(NVL(Topcrep.s07_filtro,''))
		   lventana=ThisForm.Entorno.Ruta+"FORMS\"+ALLTRIM(Topcrep.s07_filtro)
		ENDIF
		lventana=ALLTRIM(UPPER(lventana))


		IF 	LEFT(lventana,2)<>SYS(5)
			lventana=SYS(5)+lventana
		ENDIF


		IF !FILE(lventana+".SCT")
		   MESSAGEBOX("EL FORMULARIO: "+lventana+".SCT NO EXISTE",16,"ERROR")
		   RETURN .F. 
		ENDIF

		OEntorno.Codigocia=ThisForm.Entorno.Codigocia
		OEntorno.Codigosuc=ThisForm.Entorno.Codigosuc
		OEntorno.Ano=ThisForm.Entorno.Ano
		OEntorno.Mes=ThisForm.Entorno.Mes
		OEntorno.Periodo=ThisForm.Entorno.Periodo
		OEntorno.PeriodoReal=ThisForm.Entorno.PeriodoReal
		OEntorno.Modulo=ThisForm.Entorno.Modulo
		OEntorno.Programa=lprograma
		OEntorno.modulo=ThisForm.Entorno.modulo
		OEntorno.NombreModulo=ThisForm.Entorno.NombreModulo


		ldo="DO FORM '"+lventana+"' "
		&ldo
	ENDPROC


	PROCEDURE mensaje
		PRIVATE labierto 
		labierto = .F.
		FOR ln=1 To _Screen.FormCount 
			IF UPPER(_Screen.Forms[ln].Class)=="MENSAJES"
				labierto = .T.
				EXIT
			ENDIF
		ENDFOR


		IF !labierto
			ldoForm="DO FORM '"+This.Entorno.Rutaosis+"Forms\mensajes'"
			&ldoForm
		ENDIF
	ENDPROC


	PROCEDURE Init
		SET DELETED ON 
		SET CENTURY ON
		SET EXCLUSIVE OFF
		SET SAFETY OFF
		SET DATE TO DMY
		SET TALK OFF 
		DODEFAULT()
		PUSH KEY CLEAR 
		ON KEY LABEL CTRL+X Otbr.BtnCerrar.Click()
		This.Resize()
		This.Refresh() 
	ENDPROC


	PROCEDURE Resize
		This.StatusBar.Panels[1].AutoSize=1
		This.StatusBar.Panels[2].AutoSize=1
		This.StatusBar.Top=This.Height-This.StatusBar.Height
		This.StatusBar.Align=2 
		This.StatusBar.Refresh 
	ENDPROC


	PROCEDURE Deactivate
		Otbr.Ventana=This.Name
		Otbr.ActualizaOpciones()

		OtbrItem.Ventana=This.Name
		OtbrItem.ActualizaOpcionesItems()
	ENDPROC


	PROCEDURE Activate
		Otbr.Ventana=This.Name
		Otbr.ActualizaOpciones()
		OtbrItem.Ventana=This.Name
		OtbrItem.ActualizaOpcionesItems()
		This.Actualiza_session()
	ENDPROC


	PROCEDURE Destroy
		Otbr.ActualizaOpciones()
		&&Otbr.Grid=.F.
		OtbrItem.Grid=.F.
		POP KEY 
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Entorno.Programa,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	*-- Graba Información
	PROCEDURE grabar
	ENDPROC


	*-- Deshace las ultimas modificaciones
	PROCEDURE deshacer
	ENDPROC


	*-- Elmina el Registro actual
	PROCEDURE elimina
	ENDPROC


	*-- Nuevo Registro
	PROCEDURE nuevo
	ENDPROC


	*-- Abre un Ventana donde podra ubicar un registro
	PROCEDURE busca
	ENDPROC


	PROCEDURE ir_al_primer_registro
	ENDPROC


	PROCEDURE ir_al_siguiente_registro
	ENDPROC


	PROCEDURE ir_al_anterior_registro
	ENDPROC


	PROCEDURE ir_al_ultimo_registro
	ENDPROC


	*-- Se ejecuta cuando se esta en una cuadricula
	PROCEDURE eliminaitem
	ENDPROC


	*-- Se ejecuta cuando se esta en una cuadricula
	PROCEDURE insertaitem
	ENDPROC


	*-- En este metodo se configuran las teclas de Función para la pantalla
	PROCEDURE teclas
	ENDPROC


	*-- Llama a la Ventana de Periodo
	PROCEDURE periodo
	ENDPROC


	*-- Devuelve los Datos de la Compañia
	PROCEDURE compania
	ENDPROC


	*-- Se ejecuta al Mometo de Anular un Registro
	PROCEDURE anular
	ENDPROC


	PROCEDURE actualiza_datos
	ENDPROC


	PROCEDURE verifica_registros
	ENDPROC


	*-- Este Metodo se ejecuta para cargar las tablas que esta ascociadas al cursor
	PROCEDURE cargatablas
	ENDPROC


	PROCEDURE entorno.Init
		DODEFAULT()
		This.Parent.Caption=IIF(!EMPTY(This.Titulo),This.Titulo, This.Parent.Caption)
	ENDPROC


	PROCEDURE statusbar.DblClick
		*** Evento ActiveX Control ***
		This.Parent.Resize  
	ENDPROC


	PROCEDURE statusbar.Init
		PRIVATE ln
		FOR ln=1 TO 3
			This.Panels[ln].AutoSize=1
		EndFor
	ENDPROC


ENDDEFINE
*
*-- EndDefine: maestro
**************************************************


**************************************************
*-- Class:        consulta (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  maestro (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   03/18/04 04:42:04 PM
*
DEFINE CLASS consulta AS maestro


	Height = 523
	Width = 630
	DoCreate = .T.
	sql_datosconsulta = ("")
	Name = "consulta"
	entorno.Name = "entorno"
	StatusBar.Top = 500
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 630
	StatusBar.Name = "StatusBar"
	CRISTAL.Ole_reporte.Top = 0
	CRISTAL.Ole_reporte.Left = 0
	CRISTAL.Ole_reporte.Height = 100
	CRISTAL.Ole_reporte.Width = 100
	CRISTAL.Ole_reporte.Name = "Ole_reporte"
	CRISTAL.Name = "CRISTAL"


	ADD OBJECT datosconsulta AS datos WITH ;
		Top = 12, ;
		Left = 492, ;
		cuadriculaasociada = "ThisForm.Pg.P1.Detalle", ;
		indicador_consulta = .T., ;
		Name = "DatosConsulta"


	ADD OBJECT pg AS pagina WITH ;
		ErasePage = .T., ;
		Top = 0, ;
		Left = 0, ;
		Width = 624, ;
		Height = 420, ;
		Name = "PG", ;
		P1.Caption = "Consulta", ;
		P1.Name = "P1", ;
		P2.Caption = "Configurar la Consulta", ;
		P2.Name = "P2"


	ADD OBJECT consulta.pg.p1.detalle AS cuadricula WITH ;
		Height = 200, ;
		Left = -1, ;
		Top = 24, ;
		Width = 620, ;
		datoobjeto = "DatosConsulta", ;
		Name = "Detalle"


	ADD OBJECT consulta.pg.p2.filtro AS cuadricula WITH ;
		ColumnCount = 4, ;
		FontName = "MS Sans Serif", ;
		Height = 252, ;
		Left = 0, ;
		Panel = 1, ;
		Top = 2, ;
		Width = 619, ;
		datoobjeto = "DatosFiltro", ;
		campos = "campos,operador,valor,condicion", ;
		Name = "Filtro", ;
		Column1.FontName = "MS Sans Serif", ;
		Column1.Width = 160, ;
		Column1.Name = "Column1", ;
		Column2.FontName = "MS Sans Serif", ;
		Column2.Width = 162, ;
		Column2.Sparse = .F., ;
		Column2.Name = "Column2", ;
		Column3.FontName = "MS Sans Serif", ;
		Column3.Width = 197, ;
		Column3.Name = "Column3", ;
		Column4.FontName = "MS Sans Serif", ;
		Column4.Width = 65, ;
		Column4.Name = "Column4"


	ADD OBJECT consulta.pg.p2.filtro.column1.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Campos", ;
		Name = "Header1"


	ADD OBJECT consulta.pg.p2.filtro.column1.text1 AS textbox WITH ;
		FontName = "MS Sans Serif", ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT consulta.pg.p2.filtro.column2.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Operador", ;
		Name = "Header1"


	ADD OBJECT consulta.pg.p2.filtro.column2.combo AS combo WITH ;
		Left = 8, ;
		Top = 23, ;
		BorderStyle = 0, ;
		Name = "Combo"


	ADD OBJECT consulta.pg.p2.filtro.column3.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Valor", ;
		Name = "Header1"


	ADD OBJECT consulta.pg.p2.filtro.column3.text1 AS textbox WITH ;
		FontName = "MS Sans Serif", ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT consulta.pg.p2.filtro.column4.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Cóndición", ;
		Name = "Header1"


	ADD OBJECT consulta.pg.p2.filtro.column4.text1 AS textbox WITH ;
		FontName = "MS Sans Serif", ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT datosfiltro AS datos WITH ;
		Top = 468, ;
		Left = 480, ;
		nombretabla = "SYS_TABLA_OPCIONES_S07", ;
		cuadriculaasociada = "ThisForm.Pg.P2.Filtro", ;
		indicador_consulta = .T., ;
		Name = "DatosFiltro"


	ADD OBJECT boton1 AS boton WITH ;
		Top = 444, ;
		Left = 24, ;
		Name = "Boton1"


	PROCEDURE Init
		LPARAMETERS lp_cadena as Character ,lp_nombretabla as Character,lp_indice as Character  
		IF PARAMETERS()<3
		   MESSAGEBOX("Faltan Parametros Algún Parametro: (Cadena - SQL, Nombre Tabla, Indice)")
		   RETURN .F.
		ENDIF

		This.DatosConsulta.Indicadoractivado = .T.
		This.Sql_datosconsulta 			= lp_cadena
		This.DatosConsulta.Nombretabla 	= lp_nombretabla  
		This.DatosConsulta.Llave 		= lp_indice
		DODEFAULT()
	ENDPROC


	PROCEDURE datosconsulta.defineselect
		This.SqlSelect = ThisForm.SQL_DatosConsulta 
	ENDPROC


	PROCEDURE combo.Init
		CREATE CURSOR "Topera" (descri c(60),codigo c(30))
		INSERT INTO "Topera" VALUES ("Igual que (=)","=")
		INSERT INTO "Topera" VALUES ("Diferente de (<>)","<>")
		INSERT INTO "Topera" VALUES ("Mayor que (>)",">")
		INSERT INTO "Topera" VALUES ("Mayor o Igual que (>=)",">")
		INSERT INTO "Topera" VALUES ("Menor que (<)","<")
		INSERT INTO "Topera" VALUES ("Menor o Igual que (<=)","<=")
		INSERT INTO "Topera" VALUES ("Sea uno de (In)","IN")
		INSERT INTO "Topera" VALUES ("No Sea uno de (Not In)","NOT IN")
		INSERT INTO "Topera" VALUES ("Este Entre (Between)","BETWEEN")
		INSERT INTO "Topera" VALUES ("No Este Entre (Not Between)","NOT BETWEEN")
		INSERT INTO "Topera" VALUES ("Que contega (Like)","LIKE")
		INSERT INTO "Topera" VALUES ("Que NO contega (Not Like)","NOT LIKE")
		This.BoundColumn = 2
		This.RowSource="Topera"
		This.RowSourceType = 2
		This.Requery() 
		DODEFAULT()
	ENDPROC


	PROCEDURE datosfiltro.defineselect
		This.SqlSelect="Select "+;
					   "SPACE(100) as campos,"+;
					   "SPACE(30) as operador,"+;
					   "SPACE(100) as valor,"+;
					   "SPACE(10) as condicion "
					   
	ENDPROC


	PROCEDURE boton1.Click
		&&SUSP
		ThisForm.DatosConsulta.Selecciona()  
		SELECT (ThisForm.DatosConsulta.Area) 
		lindex="Index On "+ThisForm.DatosConsulta.Llave+" Tag I " 
		&lindex
		ThisForm.Pg.P1.Refresh() 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: consulta
**************************************************


**************************************************
*-- Class:        formulario (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  maestro (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   02/19/08 12:00:01 PM
*
DEFINE CLASS formulario AS maestro OLEPUBLIC


	DataSession = 2
	Height = 406
	Width = 440
	DoCreate = .T.
	Icon = "..\imag\note17.ico"
	*-- Al momento que se llame a la Busqueda de Registros Ud. Puede Definir los campos que quiere Seleccionar en la tabla de Busqueda
	camposbusqueda = "*"
	*-- Al momento que se llame a la Busqueda de Registros Ud. Puede Definir los campos que quiere MOSTRAR en la tabla de Busqueda
	camposmuestrabusqueda = ("")
	*-- En esta propiedad se guarda el Nro de Indice que tendra por defecto la tabla de Busqueda de Registro
	buscartagdefault = 1
	*-- En esta propiedad se guarda los controles que conforman la llave del Objeto Cursor
	llavecontroles = ("")
	*-- Si esta en .T. se ejecutara el Metodo GrabacionSecuencia para actualizar los tablas en la Base de Datos
	indicadorsecuencia = .T.
	buscar_condicion_pinta_letra = ("")
	*-- NO USAR ESTA PROPIEDAD
	inicio_formulario = .T.
	*-- En esta propiedad se Indica la cantidad Objetos Datos que se va utilizar para la secuencia de grabacion
	maximo_tablas = (15)
	tipo = "FORM"
	reportedatosfijos = .T.
	habilita_anular = .T.
	Name = "formulario"
	entorno.Top = 360
	entorno.Left = 372
	entorno.Height = 17
	entorno.Width = 19
	entorno.Name = "entorno"
	StatusBar.Top = 383
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 440
	StatusBar.Name = "StatusBar"
	cristal.Top = 348
	cristal.Left = 132
	cristal.Name = "cristal"

	*-- En esta propiedad Ud. puede definir una Sentencia SQL-Select para la busqueda de Registros. EN ESTA SENTENCIA SIEMPRE DEBE INCLUIR LOS CAMPOS QUE PERTENECEN A LA LLAVE
	definesqlselectbusqueda = .F.
	grabacion_secuencia_estado = .F.
	buscar_traslado = .F.

	*-- En esta propiedad defina la indices que va a tener la Tabla de Busqueda
	DIMENSION buscarindice[10,2]

	*-- En esta propiedad debe ingresar la secuencia en la cual se van a ejecutar los objetos Datos. Ejem: ThisForm.SecuenciaGrabacion[1]="cabecera"
	DIMENSION secuenciagrabacion[10]


	ADD OBJECT cabecera AS datos WITH ;
		Top = 360, ;
		Left = 348, ;
		Height = 18, ;
		Width = 21, ;
		secuenciagrabacion = 1, ;
		Name = "Cabecera"


	ADD OBJECT cursor AS datos WITH ;
		Top = 360, ;
		Left = 396, ;
		Height = 18, ;
		Width = 19, ;
		alias = "Tcur", ;
		indicador_consulta = .F., ;
		iniciar_vacio = .T., ;
		readpast = .T., ;
		Name = "Cursor"


	*-- Actualiza la llave del cursor guia con la llave de la tabla cabecera
	PROCEDURE actualizallavecursor
		lcurdir=SELECT()
		lrepl=""
		FOR ln=1 TO This.Cursor.Nrollave  
		    lrepl=lrepl+ALLTRIM(This.Cursor.LLavePrimaria[ln])+" WITH "+ALLTRIM(This.Cabecera.Alias)+"."+ALLTRIM(This.Cursor.LLavePrimaria[ln])+","
		ENDFOR
		lrepl="REPLACE "+LEFT(lrepl,LEN(lrepl)-1)
		SELECT (This.Cursor.Area) 
		&lrepl
		SELECT (lcurdir)
	ENDPROC


	*-- Este metodo se ejecuta para Armar la Secuencia de grabación de una tabla
	PROCEDURE armasecuencia
		lnro=AMEMBERS(larre,This,2)
		FOR ln=1 TO lnro
		    lcoma="This."+ALLTRIM(larre[ln])+".Class"
		    lclas=&lcoma
		    IF UPPER(lclas)=="DATOS"
		       lcoma="This."+ALLTRIM(larre[ln])+".SecuenciaGrabacion"
		       lsecu=&lcoma
		       IF lsecu>0
			       This.SecuenciaGrabacion[lsecu]=ALLTRIM(larre[ln])
			   ENDIF
		    ENDIF
		ENDFOR
	ENDPROC


	*-- Este Metodo se ejecuta si es que se ha definido la forma de Grabación con la propiedad SecuenciaGrabación
	PROCEDURE grabacionsecuencia
		PRIVATE lretosec,lejec,lgsa,lgsc,lgsn,lrecall,lsgre,lforma

		lgsc=0
		FOR lgsn=1 TO This.Maximo_tablas 
		    IF !EMPTY(This.SecuenciaGrabacion[lgsn]) 
		        lgsc=lgsc+1
		    ENDIF
		ENDFOR

		IF lgsc=0
		   MESSAGEBOX("NO SE HA DEFINIDO NINGUNA SECUENCIA DE GRACION",16,"ERROR")
		   RETURN .f.
		ENDIF


		&&lretosec=.T.

		IF This.Estado<4 && INGRESO MODIFICACION
			FOR lsgre=1 TO 2
			    lforma=IIF(lsgre=1,2,1)
				FOR lgsn=1 TO lgsc
				    IF lsgre=1
			  	       lgsa=(lgsc+1)-lgsn
				    ELSE
				       lgsa=lgsn
				    ENDIF
					&& SUSP 
				    IF !EMPTY(This.SecuenciaGrabacion[lgsa])
					       lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".DesAgrupa()"
					       &lejec
					       lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Registro_Grabar="+STR(lforma,1)
					       &lejec
					       lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Grabar() "        
					       &lejec
					       lejec="!This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Grabar_Retorno "
					       IF &lejec
					           This.Grabacion_secuencia_estado=.F.
					           RETURN .F.
					       ENDIF
				    ENDIF
				ENDFOR
			ENDFOR
		ELSE && ANULA O ELMINACION
				FOR lgsn=1 TO lgsc
		       	    lgsa=(lgsc+1)-lgsn
					lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".DesAgrupa()"
			        &lejec
				    lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Registro_Grabar=0 "
		            &lejec 
		 	        IF This.Estado=6
					   lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Elimina_Anular = .T. "        
					   IF &lejec
					      lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".EliminaTodos() " 
					      &lejec
					   ENDIF
					ENDIF
		 	        IF This.Estado=4
					   lejec="Upper(This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Name)<> 'CABECERA' "        
					   IF &lejec
					      lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".EliminaTodos() " 
					      &lejec
					   ENDIF
					ENDIF

			        lejec="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Grabar() "        
			        &lejec
			        lejec="!This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Grabar_Retorno "
			        IF &lejec
			          IF UPPER(ALLTRIM(This.SecuenciaGrabacion[lgsa]))<>"CABECERA"
			             lselectTabla="This."+ALLTRIM(This.SecuenciaGrabacion[lgsa])+".Selecciona() "
			             &lselectTabla
			          ELSE
			             *This.CargaTablas() 
			          ENDIF
			          RETURN .F.
			        ENDIF
				ENDFOR
		ENDIF

		IF This.Estado=1
		   This.ActualizaLlaveCursor() 
		ENDIF
	ENDPROC


	PROCEDURE Deactivate
		DODEFAULT()
		POP KEY 
	ENDPROC


	PROCEDURE Activate
		DODEFAULT()
		PUSH KEY 
		ON KEY LABEL CTRL+N Otbr.BtnNuevo.Click()
		ON KEY LABEL CTRL+S Otbr.BtnGraba.Click()
		ON KEY LABEL CTRL+LEFTARROW Otbr.BtnAnterior.Click()
		ON KEY LABEL CTRL+RIGHTARROW Otbr.BtnSiguiente.Click()
	ENDPROC


	PROCEDURE Release
		IF This.Verifica_modificacion
			This.Verifica_Registros() 
		ENDIF
		DODEFAULT()
	ENDPROC


	PROCEDURE formato
		LPARAMETERS ldestino

		IF EMPTY(This.FormatoPrograma )
		   MESSAGEBOX("NO EXISTE PROGRAMA ASOCIADO",16,This.Caption)
		   RETURN .F.
		EndIf

		&&SUSP
		PRIVATE lsen 
		lsen="Select foa_codigo,FOA_CONFOA,FOA_TIPFOA "+;
		     "From SYS_FORMATOS_ASOCIADOS_FOA "+;
		     "Where s07_codopc='"+NVL(This.Entorno.Programa,"")+"' "

		IF Ocnx.Tipo_BD=2
			lsen="Select foa_codigo,FOA_CONFOA,FOA_TIPFOA "+;
			     "From "+Ocnx.Esquema+".SYS_FORMATOS_ASOCIADOS_FOA "+;
			     "Where s07_codopc='"+NVL(This.Entorno.Programa,"")+"' "
		ENDIF 
		  
		 IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
			 IF SQLEXEC(Ocnx.Conexion,lsen,"Tasocia")<0
			    MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lsen,16,"Formatos Asociados")
			    RETURN .F.
			 ENDIF
		 ENDIF
		 
		 IF Ocnx.Tipo_BD=4
			 IF Ocnx.Ms_Ejecuta_SQL(lsen,"Tasocia",This.DataSessionId)<0
			    MESSAGEBOX("Error: "+MESSAGE()+CHR(13)+lsen,16,"Formatos Asociados")
			    RETURN .F.
			 ENDIF
		 ENDIF
		 
		 SELECT "Tasocia"
		 GO top
		 IF !EOF()
		     SCAN
		        lcondi=IIF(!EMPTY(NVL(FOA_CONFOA,'')),FOA_CONFOA,"1=2")
		     	SELECT (ThisForm.CABECERA.Area) 
		     	IF &lcondi
		     	   This.FormatoPrograma=Tasocia.foa_codigo
		     	   This.Formatotipo=VAL(NVL(Tasocia.FOA_TIPFOA,'1'))
		     	ENDIF
		     	SELECT "Tasocia"
		     ENDSCAN
		 ENDIF
		 
		 USE IN "Tasocia"  
		  
		  
		IF This.Formatotipo=1
		   This.Cristal.Tituloreporte = "Formato: ["+This.FormatoPrograma+"] "+ALLTRIM(This.Caption)    
		   This.Cristal.Programa=This.FormatoPrograma  
		   This.Cristal.Destination=IIF(ldestino=1,1,0) 
		   This.Cristal.ActivaReporte()  
		EndIf 
		IF This.FormatoTipo=2

		    lcad="Select s07_noms07 "+;
		         "From SYS_TABLA_OPCIONES_S07 "+;
		         "Where s07_codopc='"+NVL(This.FormatoPrograma,"")+"'   "
		     
			IF Ocnx.Tipo_BD=2
			    lcad="Select s07_noms07 "+;
			         "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			         "Where s07_codopc='"+NVL(This.FormatoPrograma,"")+"'   "
			ENDIF 

		    IF Ocnx.Tipo_BD=1  OR Ocnx.Tipo_BD=2
			    IF SQLEXEC(Ocnx.Conexion,lcad,"Tts07")<0
			       MESSAGEBOX("Error: "+MESSAGE(),16,Gcia)
			       RETURN .F.     
			    ENDIF
		    ENDIF
		    
		    IF Ocnx.Tipo_BD=4
			    IF Ocnx.Ms_Ejecuta_SQL(lcad,"Tts07",This.DataSessionId)<0
			       MESSAGEBOX("Error: "+MESSAGE(),16,Gcia)
			       RETURN .F.     
			    ENDIF
		    ENDIF
		    
		    IF EOF()  
		       MESSAGEBOX("EL PROGRAMA: "+This.FormatoPrograma+" NO EXISTE")
		       RETURN .F. 
		    ENDIF
		    ltitulo=NVL(Tts07.s07_noms07,'')
		     
		    
		    IF USED("tts07")
		       USE IN "tts07" 
		    ENDIF

		    SELECT (This.Cursor.Area) 
		    lllave=This.Cursor.Llave_Original    &&KEY()
		    lllave= &lllave
		   
		       
			SET CLASSLIB TO ALLTRIM(ThisForm.entorno.rutaosis) + "LIBS/LIB_REPORTE.VCX" ADDI
			PUBLIC OFormato
			OFormato = CREATEOBJECT("Cls_SetupFormato")
			OFormato.ps_indicador       = "2"                       && ejecuta el formato
			OFormato.ps_opcion          = IIF(ldestino=1,"I","P")   &&"P"                       && pantalla -    I=impresora
			OFormato.ps_codigo_programa = ALLTRIM(NVL(This.FormatoPrograma,''))
			OFormato.ps_nombre_programa = ALLTRIM(ltitulo)
			OFormato.ps_cadena_llave    = lllave
			DO FORM ALLTRIM(ThisForm.entorno.rutaosis) + "FORMS/FORMATO.SCX"
			ERASE OFormato


		ENDIF
	ENDPROC


	PROCEDURE Init

		DODEFAULT()

		PRIVATE lxusurio

		lxusurio=ALLTRIM(Ocnx.usuario)
		IF !EMPTY(NVL(Ocnx.usuario_perfil,''))
			lxusurio=Ocnx.usuario_perfil
		ENDIF


		This.CargaTablas()

		&&IF Ocnx.Nivel<9
		   PRIVATE ls10
		   ls10="Select "+;
		   		"S07_CODOPC, S10_USUARIO, S12_SITREG, S12_INDEST, "+;
		   		"S12_FECACT, S12_CODUSU, S12_INDNUE, S12_INDMOD, "+;
		   		"S12_INDELI, S12_INDBUS, S12_INDANU, S12_INDIMP, "+;
		   		"S12_INDFOR, S12_INDXLS, S12_INDOPC, S12_INDEJE "+;
		   		"From SYS_OPCIONES_USUARIOS_S12 "+;
		   		"Where s07_codopc='"+ALLTRIM(ThisForm.Entorno.Programa)+"' "+;
		   		"and   UPPER(s10_usuario)=UPPER('"+ALLTRIM(lxusurio)+"') "

		   IF Ocnx.Tipo_BD=2
			   ls10="Select "+;
			   		"S07_CODOPC, S10_USUARIO, S12_SITREG, S12_INDEST, "+;
			   		"S12_FECACT, S12_CODUSU, S12_INDNUE, S12_INDMOD, "+;
			   		"S12_INDELI, S12_INDBUS, S12_INDANU, S12_INDIMP, "+;
			   		"S12_INDFOR, S12_INDXLS, S12_INDOPC, S12_INDEJE "+;
			   		"From "+Ocnx.Esquema+".SYS_OPCIONES_USUARIOS_S12 "+;
			   		"Where s07_codopc='"+ALLTRIM(ThisForm.Entorno.Programa)+"' "+;
			   		"and   UPPER(s10_usuario)=UPPER('"+ALLTRIM(lxusurio)+"') "   
		   ENDIF 

		   
		   IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3 OR Ocnx.Tipo_BD=2)
			   IF SQLEXEC(Ocnx.Conexion,ls10,"Ts10")<0
			      MESSAGEBOX("Error: "+MESSAGE(),16,This.Caption)
			      RETURN
			   ENDIF
		   ENDIF
		   IF Ocnx.Tipo_BD=4
		   	   IF Ocnx.Ms_Ejecuta_SQL(ls10,"Ts10",ThisForm.DataSessionId)<0
			      RETURN
			   ENDIF
		   ENDIF  
		   	   
		   IF !EOF("Ts10")
		      This.Habilita_Anular	=	IIF(NVL(Ts10.s12_indanu,'0')='1',.T.,.F.)
		      This.Habilita_Elimina	=	IIF(NVL(Ts10.s12_indeli,'0')='1',.T.,.F.) 
		      This.Habilita_Grabar	= 	IIF(NVL(Ts10.s12_indmod,'0')='1',.T.,.F.)
		      This.Habilita_Nuevo	=  	IIF(NVL(Ts10.s12_indnue,'0')='1',.T.,.F.)
		      This.Habilita_otros   =   IIF(NVL(Ts10.s12_indopc,'0')='1',.T.,.F.)
		   ENDIF
		   
		   IF USED("Ts10")
		      USE IN "Ts10"
		   ENDIF
		*!*	IF This.WindowType<> 1 
		*!*		This.ShowWindow = 2 
		*!*	ENDIF

		&&ENDIF
	ENDPROC


	PROCEDURE elimina
		This.Estado=4
		This.Grabar() 
	ENDPROC


	PROCEDURE deshacer
		lcurdir=SELECT()
		SELECT (This.Cursor.Area)
		IF CURSORGETPROP("Buffering")<>1
			=TABLEREVERT(.t.)
		ENDIF

		IF This.Estado=1
			GO BOTTOM
		ENDIF

		This.Estado=2
		This.Cabecera.Selecciona() 
		This.CargaTablas()
		Otbr.ActualizaOpciones()
		This.Refresh()
		SELECT (lcurdir)
		This.StatusBar.Refresh()  
	ENDPROC


	PROCEDURE grabar
		PRIVATE lmensaje,ltitulo
		lmensaje="Seguro de Actualizar"+STR(This.Estado)
		DO Case
		   CASE This.Estado=6
		   	    lmensaje="Seguro de Anular Registro"
		   	    ltitulo="ANULACION"
		   CASE This.Estado=2
		   	    lmensaje="Seguro de Actualizar Registro"
		   	    ltitulo="ACTUALIZACION"
		   CASE This.Estado=4
		   	    lmensaje="Seguro de Eliminar Registro"
		   	    ltitulo="ELIMINACION"
		   CASE This.Estado=1
		   	    lmensaje="Seguro de Ingresar Registro"
		   	    ltitulo="INGRESO"
		ENDCASE
		This.StatusBar.Refresh()  
		IF !This.Antes_De_Grabar() 
		   IF This.Estado = 6
		   	  This.Estado = 2
		   EndIf 
		   RETURN .f.
		ENDIF

		lgrabar=.T.

		IF MESSAGEBOX("¿ "+lmensaje+" ? ",4+32,ltitulo)=6
		   Ocnx.Modo(2)
		   IF This.Estado=1
		      This.ActualizaLlaveCursor() 
		   ENDIF
		   IF !Ocnx.Configura()
		       RETURN .f.
		   ENDIF
		 
		   IF This.Estado=4
		      SELECT (ThisForm.CABECERA.Area) 
		      ThisForm.CABECERA.Elimina()  
		   EndIf
		   This.Grabacion_secuencia_estado=.T. 
		     
		   lcondi=IIF(This.IndicadorSecuencia,"This.GrabacionSecuencia()","This.GrabacionRemota()") 

		   IF &lcondi AND  This.Grabacion_secuencia_estado=.T. 
		      Ocnx.Commit()
			  Ocnx.Modo(1)
		      SELECT (This.Cursor.Area) 
		      IF This.Estado=4
		         DELETE 
		         GO BOTTOM 
		      EndIf
		      =TABLEUPDATE(.t.)
		      SELECT (This.CABECERA.Area)
		      This.Estado=2
		      Otbr.ActualizaOpciones()
		      This.Cabecera.Selecciona()
		      This.CargaTablas() 
		      This.Refresh()
		      lgrabar=.T.
		   ELSE
		      lmensaje=""
		      Ocnx.Rollback()
		      MESSAGEBOX(Ocnx.ErrorMensaje,16,"Error")
			  IF This.Estado=6 OR This.Estado=4
			     This.Deshacer() 
			     This.Estado=2
			  ENDIF
		      Ocnx.Parametro=1
		      IF !Ocnx.Configura()
			     RETURN .f.
		      EndIf
			  Ocnx.Modo(1)
		      IF !Ocnx.Configura()
			     RETURN .F.
		      EndIf
		      lgrabar=.F.
		   ENDIF
		ELSE
		   IF This.Estado=6
		      This.Estado=2
		   ENDIF
		   lgrabar=.F.
		ENDIF
		This.StatusBar.Refresh()
		 
		RETURN lgrabar
	ENDPROC


	PROCEDURE ir_al_primer_registro

		This.Cursor.Primero()
		ThisForm.LockScreen=.t.
		This.Cabecera.Selecciona()  
		This.CargaTablas()
		ThisForm.LockScreen=.f.
		This.Refresh()
	ENDPROC


	PROCEDURE ir_al_ultimo_registro
		This.Cursor.Ultimo()
		ThisForm.LockScreen=.t.
		This.Cabecera.Selecciona()  
		This.CargaTablas()
		ThisForm.LockScreen=.f.
		This.Refresh()
	ENDPROC


	PROCEDURE ir_al_siguiente_registro
		This.Cursor.Siguiente()
		ThisForm.LockScreen=.t.
		This.Cabecera.Selecciona()  
		This.CargaTablas()
		ThisForm.LockScreen=.f.
		This.Refresh()
	ENDPROC


	PROCEDURE ir_al_anterior_registro
		This.Cursor.Anterior()
		ThisForm.LockScreen=.t.
		This.Cabecera.Selecciona()  
		This.CargaTablas()
		ThisForm.LockScreen=.f.
		This.Refresh()
	ENDPROC


	PROCEDURE nuevo
		lcurdir=SELECT()
		This.Estado=1
		Otbr.ActualizaOpciones()
		SELECT (This.Cursor.Area)
		APPEND BLANK
		This.Cabecera.Selecciona() 
		This.Cabecera.Nuevo() 
		This.CargaTablas()
		This.Refresh()
		SELECT(lcurdir)
	ENDPROC


	PROCEDURE busca
		PRIVATE lsqlsele,lpos,lwhe,lexis,lvaloractual
		Oindices=CREATEOBJECT("Indices")

		lexis=.F.
		FOR ln=1 TO 10
		    lexis=.f.
		    IF !EMPTY(This.BuscarIndice[ln,1])
		        lexis=.T.
		    ENDIF
		    Oindices.indice[ln,1]=This.BuscarIndice[ln,1] 
		    Oindices.indice[ln,2]=This.BuscarIndice[ln,2] 
		ENDFOR

		IF !lexis
		    SELECT (This.Cursor.Area)
		    Oindices.indice[1,1]=KEY()
		    Oindices.indice[1,2]=TAG()
		    &&This.BuscarTagDefault=1
		ENDIF


		Oindices.IndiceDefault=This.BuscarTagDefault

		This.Buscar_traslado  = CREATEOBJECT("Traslado")
		DIMENSION This.Buscar_traslado.Parametros[1]

		This.BuscarPropiedades() 
		Otraslado=CREATEOBJECT("Traslado")


		PRIVATE lxf,lxc,lfil,lcol
		lfil=ALEN(This.Buscar_traslado.Parametros,1)
		lcol=ALEN(This.Buscar_traslado.Parametros,2)
		IF lcol<>0
			DIMENSION Otraslado.Parametros[lfil,lcol]
			FOR lxf=1 TO lfil
				FOR lxc=1 TO lcol
					Otraslado.Parametros[lxf,lxc]=This.Buscar_traslado.Parametros[lxf,lxc]
				ENDFOR
			ENDFOR

		ELSE
			DIMENSION Otraslado.Parametros[lfil]
			FOR lxf=1 TO lfil
				Otraslado.Parametros[lxf]=This.Buscar_traslado.Parametros[lxf]
			ENDFOR
		ENDIF


		IF EMPTY(This.DefinesqlSelectBusqueda)
		   lcampos=""
		   IF EMPTY(This.CamposBusqueda) 
		      FOR ln=1 TO This.Cabecera.Columnas
		          lcampos=This.Cabecera.Estructura[ln]+","        
		      ENDFOR
		      IF !EMPTY(lcampos)
		         lcampos=LEFT(lcampos,LEN(lcampos)-1)
		      ENDIF
		   ELSE
		      lcampos=This.CamposBusqueda
		   ENDIF
		   IF !EMPTY(lcampos)
		       lwhe=""
		       lsqlsele=UPPER(This.Cursor.SqlSelect)
		       lpos=AT("WHERE",lsqlsele)
		       IF lpos>0
		          lwhe=SUBSTR(lsqlsele,lpos+5,LEN(ALLTRIM(lsqlsele)))   
		          lwhe=" WHERE "+lwhe
		       ENDIf
		       
		              
		   	   This.DefinesqlSelectBusqueda="SELECT "+lcampos+" From "+IIF(This.Cursor.Indicar_dbo and Ocnx.Tipo_BD=1,"dbo.","")+;
									    	 ALLTRIM(This.Cursor.NombreTabla)+lwhe
									    
		       IF Ocnx.Tipo_BD=2
			   	   This.DefinesqlSelectBusqueda="SELECT "+lcampos+" From "+Ocnx.Esquema+"."+ALLTRIM(This.Cursor.NombreTabla)+lwhe       
		       ENDIF 
								    	 
			   This.DefinesqlSelectBusqueda=UPPER(This.DefinesqlSelectBusqueda)						    	 
		   ENDIF
		ENDIF
		Oentorno.codigocia=This.Entorno.codigocia
		Oentorno.codigosuc=This.Entorno.codigosuc
		Oentorno.titulo=This.Entorno.Titulo
		Oentorno.periodo=This.Entorno.Periodo 
		Oentorno.ano=This.Entorno.Ano
		Oentorno.mes=This.Entorno.Mes
		Oentorno.periodoreal=This.Entorno.Periodoreal 

		ldato=This.LlaveControles 
		lvaloractual=&ldato

		IF EMPTY(This.BuscaFormulario )
		   lruta=This.Entorno.Rutaosis+"Forms\Buscar"
		ELSE
		   lruta=ALLTRIM(UPPER(This.Entorno.Ruta+"Forms\"+This.BuscaFormulario))
		   IF !FILE(lruta+".SCT")
		      MESSAGEBOX("EL FORMULARIO DEFINIDO PARA BUSQUEDA "+lruta+" NO EXISTE")
		      RETURN .F. 
		   ENDIF
		   
		ENDIF

		IF SYS(5)<>LEFT(lruta,3)
		   lruta=SYS(5)+lruta
		ENDIF

		IF RECCOUNT(This.Cursor.Area)=0
		   This.Cursor.Selecciona()  
		ENDIF

		lvalor=Null

		DO FORM &lruta WITH This.Cabecera.Nombretabla,;
		                    ALLTRIM(This.Cabecera.Nombretabla)+"_Busca",;     
		                    This.Camposbusqueda,;
		                    This.CamposMuestraBusqueda,;
		                    This.Cursor.Llave,;
		                    This.DefineSQLSelectBusqueda ,;
		                    Oindices,;
		                    .F.,;
		                    '',;
		                    lvaloractual,;
		                    .F.,;
		                    .T.,;
		                    This.Buscar_condicion_pinta_letra,;  
		                    .F.,;
		                    .F.,;
		                    This.Buscar_particion ,;
		                    Otraslado ;
		                    TO lvalor
		                    
		                    
		&&lpnombretabla,lalias,lpcampos,lcamposmuestra,ldevuelve,lpsqlselect,lpindices,lpunavez,lnroindice,lvaloractual
		                    
		IF !ISNULL(lvalor)
		    IF SEEK(lvalor,This.Cursor.Area)
		       This.Cabecera.Selecciona() 
		       ThisForm.CargaTablas()
		       ThisForm.Refresh() 
		    ENDIF
		EndIf
	ENDPROC


	PROCEDURE insertaitem
		LPARAMETERS ldata
	ENDPROC


	PROCEDURE eliminaitem
		LPARAMETERS ldata
	ENDPROC


	PROCEDURE KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl
	ENDPROC


	PROCEDURE anular
		This.Estado=6
		IF !This.Grabar() 
		   RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE imprime
		LPARAMETERS lprograma

		PRIVATE lcad
		lcad="Select s07_reppro "+;
		     "From SYS_TABLA_OPCIONES_S07 "+;
		     "Where s07_codopc=?ThisFOrm.Entorno.Programa "

		IF Ocnx.Tipo_BD=2
			lcad="Select s07_reppro "+;
			     "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			     "Where s07_codopc=?ThisFOrm.Entorno.Programa "
		ENDIF 

		IF SQLEXEC(Ocnx.Conexion,lcad,"Trepor")<0
		   MESSAGEBOX("Error: "+MESSAGE(),16,Error)
		   RETURN .F.
		ENDIF

		IF !EMPTY(NVL(s07_reppro,''))
		   lprograma=Trepor.s07_reppro
		   IF USED("Trepor")
		      USE IN "Trepor"
		   ENDIF
		   DODEFAULT(lprograma)
		ENDIF
		IF USED("Trepor")
		   USE IN "Trepor"
		ENDIF
	ENDPROC


	PROCEDURE Scrolled
		LPARAMETERS nDirection

		This.Resize() 
	ENDPROC


	PROCEDURE actualiza_datos
		This.Cursor.Nombretabla=""  
		This.CABECERA.IndicadorActivado=.T.
		This.Cursor.Selecciona()  
		This.CABECERA.Selecciona()  
		ThisForm.Refresh() 
		This.CargaTablas() 
	ENDPROC


	PROCEDURE verifica_registros
		PRIVATE lsec,lfo,lth,lgr
		   lsec=ALEN(This.SecuenciaGrabacion)
		   lgr=.F.
		   lth=.F.
		FOR lfo=1 TO lsec
		   IF TYPE("ALLTRIM(ThisForm.SecuenciaGrabacion[lfo])")=="C"  AND ;
		   	      !EMPTY(ThisForm.SecuenciaGrabacion[lfo])
		   	  lth="ThisForm."+ALLTRIM(ThisForm.SecuenciaGrabacion[lfo])+".Verifica_Registros()" 	   
		   ENDIF
		   IF &lth
		   	  lgr=.T.
		   	  EXIT 
		   ENDIF
		ENDFOR
		IF lgr
		   	   	  IF MESSAGEBOX("Se han producido modificaciones."+;
		   	  			   "¿Desea Grabar?",4+32,ThisForm.Caption)=6
			   	  	 This.Grabar()  
		   		  ENDIF
		   	  
		ENDIF
	ENDPROC


	PROCEDURE entorno.Init
		DIMENSION ThisForm.Secuenciagrabacion[This.Parent.maximo_tablas] 

		DODEFAULT()
		SET DELETED ON
		SET EXCLUSIVE OFF
		SET SAFETY OFF
		SET TALK OFF
		SET CENTURY ON
		SET DATE TO DMY

		ON KEY LABEL CTRL+N Otbr.BtnNuevo.Click()
		ON KEY LABEL CTRL+S Otbr.BtnGraba.Click()
		ON KEY LABEL CTRL+Z Otbr.BtnDeshacer.Click()
		ON KEY LABEL CTRL+E Otbr.BtnElimina.Click()

		ThisForm.Caption=This.titulo
		ThisForm.ArmaSecuencia() 

		PRIVATE lcadrep

		IF Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4
			lcadrep="Select s07_reppro,s07_forpro "+;
			        "From SYS_TABLA_OPCIONES_S07 "+;
			        "Where s07_codopc='"+This.Programa+"' "
		ENDIF
		        
		IF Ocnx.Tipo_BD=2
			lcadrep="Select s07_reppro,s07_forpro "+;
			        "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
			        "Where s07_codopc='"+This.Programa+"' "
		ENDIF         
		        
		IF Ocnx.Tipo_BD=3
			lcadrep="Select s07_reppro,s07_forpro "+;
			        "From SYS_TABLA_OPCIONES_S07 "+;
			        "Where s07_codopc='"+This.Programa+"' "
		ENDIF

		IF (Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=3OR Ocnx.Tipo_BD=2)
			IF SQLEXEC(Ocnx.Conexion,lcadrep,"Trepor")<0
			   MESSAGEBOX("Error: "+MESSAGE(),16,"Error")
			   RETURN .F.
			ENDIF
		ENDIF
		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lcadrep,"Trepor",ThisForm.DataSessionId)<0
			   RETURN .F.
			ENDIF
		ENDIF


		IF !EMPTY(NVL(s07_reppro,''))
		   ThisForm.Habilita_reporte=.T. 
		ENDIF
		IF !EMPTY(NVL(s07_forpro,''))
		   ThisForm.Habilita_Formato=.T. 
		   ThisForm.FormatoPrograma=s07_forpro 
		ENDIF

		IF USED("Trepor")
		   USE IN "Trepor"
		ENDIF

		ThisForm.StatusBar.Panels[2].Text=ALLTRIM(This.Nombrecia)+" -> "+TRANSFORM(This.Periodo,"@r 9999-99")    
	ENDPROC


	PROCEDURE entorno.Destroy
		POP KEY
	ENDPROC


	PROCEDURE StatusBar.Refresh
		*** ActiveX Control Method ***
		DODEFAULT()
		PRIVATE lcase
		DO Case
		   CASE ThisForm.Estado=1
		        lcase="INGRESO"
		   CASE ThisForm.Estado=2
		        lcase="EDICION"
		   CASE ThisForm.Estado=4 
		        lcase="ELIMINACION"
		   CASE ThisForm.Estado=6
		     	lcase="ANULACION"
		ENDCASE
		This.Panels[3].Text=lcase 
	ENDPROC


	PROCEDURE grabacionremota
	ENDPROC


	*-- Este Metodo se ejecuta antes de Grabar Encabezado
	PROCEDURE antes_grabar_encabezado
	ENDPROC


	*-- Antes de Grabar
	PROCEDURE antes_de_grabar
	ENDPROC


	*-- Puede definir el SQL-SELECT en la propiedad  en la propiedad DefineSQLSelectBusqueda
	PROCEDURE buscarpropiedades
	ENDPROC


	PROCEDURE cabecera.Init
		IF EMPTY(ThisForm.Entorno.Codigocia) 
		   ThisForm.Entorno.Init()  
		EndIf 
		IF !EMPTY(This.NombreTabla)
		   ThisForm.Cursor.NombreTabla=This.NombreTabla
		   ThisForm.Cursor.Init() 
		ENDIF

		DODEFAULT()
	ENDPROC


	PROCEDURE cabecera.antes_armar_estructura
		IF !This.Almacenaestructura() 
			RETURN 
		ENDIF

		lcad=""
		FOR ln=1 TO This.NroLlave
		    lcad=lcad+"Tcur."+ALLTRIM(This.LLavePrimaria[ln])+","
		ENDFOR
		lcad=LEFT(lcad,LEN(lcad)-1)
		This.Parametros=lcad 
	ENDPROC


	PROCEDURE cabecera.selecciona
		DODEFAULT()

		IF USED(ThisForm.Cursor.Alias) 
			ThisForm.StatusBar.Panels[1].Text="Registro: "+ALLTRIM(STR(RECNO(ThisForm.Cursor.Area)))+" de "+ALLTRIM(STR(RECCOUNT(ThisForm.Cursor.Area)))  
		ENDIF
	ENDPROC


	PROCEDURE cursor.antes_armar_estructura
		PRIVATE lcad,lcon,ln,lwhe

		lcad=""
		lcon=""
		This.Almacenaestructura() 
		FOR ln=1 TO This.NroLlave
		    lcad=lcad+ALLTRIM(This.LLavePrimaria[ln])+","
		    IF TYPE("ThisForm."+ALLTRIM(This.LLavePrimaria[ln])+"1")=="O"
			    lcon=lcon+"ThisForm."+ALLTRIM(This.LLavePrimaria[ln])+"1.Value+"
			ENDIF
		    IF TYPE("ThisForm."+ALLTRIM(This.LLavePrimaria[ln]))=="O"
			    lcon=lcon+"ThisForm."+ALLTRIM(This.LLavePrimaria[ln])+".Value+"
			ENDIF
		ENDFOR
		lcad=LEFT(lcad,LEN(lcad)-1)
		lcon=LEFT(lcon,LEN(lcon)-1)
		lwhe=""
		This.Campos=lcad 
		IF EMPTY(ThisForm.LlaveControles)
		   ThisForm.LlaveControles=UPPER(lcon)
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: formulario
**************************************************


**************************************************
*-- Class:        responde (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  maestro (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   08/14/06 12:00:03 PM
*
DEFINE CLASS responde AS maestro


	Height = 229
	Width = 433
	DoCreate = .T.
	Icon = "..\imag\lighton.ico"
	WindowType = 1
	Name = "responde"
	entorno.Top = 168
	entorno.Left = 24
	entorno.Name = "entorno"
	StatusBar.Top = 206
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 433
	StatusBar.Name = "StatusBar"
	cristal.Top = 120
	cristal.Left = 192
	cristal.Name = "cristal"


	ADD OBJECT botongrupo AS botongrupo WITH ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		Height = 149, ;
		Left = 346, ;
		Top = 22, ;
		Name = "BotonGrupo", ;
		Cmb_Aceptar.Top = 5, ;
		Cmb_Aceptar.Left = 5, ;
		Cmb_Aceptar.Name = "Cmb_Aceptar", ;
		Cmb_Ayuda.Top = 60, ;
		Cmb_Ayuda.Left = 5, ;
		Cmb_Ayuda.Name = "Cmb_Ayuda", ;
		Cmb_Cancelar.Top = 120, ;
		Cmb_Cancelar.Left = 5, ;
		Cmb_Cancelar.Name = "Cmb_Cancelar"


ENDDEFINE
*
*-- EndDefine: responde
**************************************************


**************************************************
*-- Class:        buscar (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   05/08/08 06:10:01 PM
*
DEFINE CLASS buscar AS responde


	Top = 23
	Left = 1
	Height = 440
	Width = 720
	DoCreate = .T.
	AutoCenter = .F.
	Caption = "Buscar Registro"
	Icon = "..\imag\binoculr.ico"
	*-- Si esta en .T. ajusta la cuadricula de la consulta a la tabla
	ajustarcuadricula = .T.
	condicion_pinta_letra = ("")
	indicador_cambia_campos = .T.
	secuencia_seleccion = (0)
	Name = "buscar"
	entorno.Top = 204
	entorno.Left = 492
	entorno.Name = "entorno"
	StatusBar.Top = 417
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 720
	StatusBar.Name = "StatusBar"
	cristal.Top = 144
	cristal.Left = 612
	cristal.Name = "cristal"
	botongrupo.AutoSize = .F.
	botongrupo.Cmb_Aceptar.AutoSize = .F.
	botongrupo.Cmb_Aceptar.Top = 2
	botongrupo.Cmb_Aceptar.Left = 285
	botongrupo.Cmb_Aceptar.SpecialEffect = 2
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.AutoSize = .F.
	botongrupo.Cmb_Ayuda.Top = 2
	botongrupo.Cmb_Ayuda.Left = 3
	botongrupo.Cmb_Ayuda.SpecialEffect = 2
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.AutoSize = .F.
	botongrupo.Cmb_Cancelar.Top = 2
	botongrupo.Cmb_Cancelar.Left = 636
	botongrupo.Cmb_Cancelar.SpecialEffect = 2
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Height = 28
	botongrupo.Left = 0
	botongrupo.Top = 390
	botongrupo.Width = 720
	botongrupo.Name = "botongrupo"

	*-- En esta propiedad escriba se guarda el valor que resulta de la proiedad DatoDevuelto
	valordevuelto = .F.

	*-- En esta propiedad escriba el valor que va devolver el formulario: Eje: tdo_codtdo+cte_numdoc
	datodevuelto = .F.

	*-- Si esta en .T. Verifica que si la Tabla ya Existe ya no se Ejecute la Sentencia SQL-Select
	unavez = .F.
	no_enter = .F.
	buscar_presionar_tecla = .F.
	indicadorlista = .F.
	traslado = .F.
	camposadicionales = .F.


	ADD OBJECT datoslista AS datos WITH ;
		Top = 276, ;
		Left = 516, ;
		cuadriculaasociada = "ThisForm.Listado", ;
		indicador_consulta = .T., ;
		Name = "DatosLista"


	ADD OBJECT listado AS cuadricula WITH ;
		Height = 325, ;
		Left = 0, ;
		ReadOnly = .T., ;
		Top = 59, ;
		Width = 718, ;
		datoobjeto = "DatosLista", ;
		iniciar_primera_fila = .F., ;
		enter_lostfocus = .T., ;
		habilita_elimina_item = .F., ;
		habilita_inserta_item = .F., ;
		habilita_nuevo_item = .F., ;
		pintaregistro = .T., ;
		Name = "Listado"


	ADD OBJECT contenedor AS contenedor WITH ;
		Top = 1, ;
		Left = -1, ;
		Width = 720, ;
		Height = 57, ;
		BorderWidth = 1, ;
		SpecialEffect = 0, ;
		Name = "Contenedor"


	ADD OBJECT buscar.contenedor.txt_busca AS texto WITH ;
		Format = "", ;
		Height = 23, ;
		Left = 78, ;
		Top = 5, ;
		Width = 408, ;
		Name = "txt_busca"


	ADD OBJECT buscar.contenedor.btn_ir AS boton WITH ;
		Top = 5, ;
		Left = 486, ;
		Height = 23, ;
		Width = 26, ;
		Picture = "..\imag\locate.bmp", ;
		Caption = "", ;
		TabStop = .F., ;
		ToolTipText = "Localiza el Dato", ;
		SpecialEffect = 2, ;
		Name = "Btn_ir"


	ADD OBJECT buscar.contenedor.etiqueta_busca AS etiqueta WITH ;
		Caption = "Buscar", ;
		Left = 4, ;
		Top = 9, ;
		caption_in = ("Find"), ;
		Name = "Etiqueta_Busca"


	ADD OBJECT buscar.contenedor.cmb_orden AS combo WITH ;
		Height = 24, ;
		Left = 78, ;
		TabStop = .F., ;
		Top = 30, ;
		Width = 180, ;
		Name = "Cmb_Orden"


	ADD OBJECT buscar.contenedor.etiqueta_combo AS etiqueta WITH ;
		Caption = "Ordenado Por", ;
		Left = 4, ;
		Top = 35, ;
		caption_in = ("Order By"), ;
		Name = "Etiqueta_Combo"


	ADD OBJECT buscar.contenedor.check_cadena AS check WITH ;
		Top = 6, ;
		Left = 560, ;
		Alignment = 0, ;
		Caption = "Buscar en la Cadena", ;
		TabStop = .F., ;
		Visible = .F., ;
		Name = "Check_Cadena"


	ADD OBJECT buscar.contenedor.key AS etiqueta WITH ;
		Caption = "...", ;
		Left = 320, ;
		Top = 35, ;
		Visible = .F., ;
		ForeColor = RGB(0,0,255), ;
		Name = "Key"


	ADD OBJECT buscar.contenedor.check_presiona AS check WITH ;
		Top = 35, ;
		Left = 560, ;
		Alignment = 0, ;
		Caption = "Buscar al Presionar Tecla", ;
		TabStop = .F., ;
		ForeColor = RGB(0,0,255), ;
		Name = "Check_Presiona"


	ADD OBJECT buscar.contenedor.btnexcel AS boton WITH ;
		Top = 30, ;
		Left = 484, ;
		Height = 25, ;
		Width = 29, ;
		Picture = "..\imag\xls.bmp", ;
		TabStop = .F., ;
		ToolTipText = "Envia Información a Excel", ;
		SpecialEffect = 2, ;
		Name = "BtnExcel"


	ADD OBJECT buscar.contenedor.btnmarca AS boton WITH ;
		Top = 30, ;
		Left = 372, ;
		Height = 25, ;
		Width = 29, ;
		FontName = "Wingdings 2", ;
		FontSize = 10, ;
		Picture = "..\imag\marcados.bmp", ;
		TabStop = .F., ;
		ToolTipText = "Marca Todos los Registro como Seleccionados", ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,160), ;
		Name = "BtnMarca"


	ADD OBJECT buscar.contenedor.btndesmarca AS boton WITH ;
		Top = 30, ;
		Left = 425, ;
		Height = 25, ;
		Width = 29, ;
		FontName = "Wingdings 2", ;
		FontSize = 13, ;
		Picture = "..\imag\desmarcados.bmp", ;
		TabStop = .F., ;
		ToolTipText = "Desmarca Todos los Registro Seleccionados", ;
		SpecialEffect = 2, ;
		ForeColor = RGB(0,0,160), ;
		Name = "BtnDesmarca"


	PROCEDURE cambia_campos
		PRIVATE lset,lnc,lcam,lcal

		IF This.Listado.ColumnCount<=0
			RETURN 
		ENDIF

		This.LockScreen =.T.  

		lcal=UPPER(ALLTRIM(This.Listado.RecordSource))+'.' 

		FOR lnc=1 TO This.Listado.ColumnCount
		 	lcam=UPPER(This.Listado.Columns[lnc].ControlSource) 
			lcam=STRTRAN(lcam,lcal,'')
			This.Listado.Columns[lnc].RemoveObject('Text1')
			This.Listado.Columns[lnc].AddObject('Text1', 'Texto_Busca')
			This.Listado.Columns[lnc].Text1.Visible=.T.
			This.Listado.Columns[lnc].CurrentControl='Text1'  
		ENDFOR

		This.LockScreen =.F.
		This.Listado.Refresh() 

		*!*	Lparameters pColumna, pCampo
		*!*	Local cCaption,cFont

		*!*	cCaption = pColumna.Header1.Caption
		*!*	cFont	 = pColumna.Header1.FontName
		*!*	pColumna.RemoveObject('Header1')
		*!*	&&'grdHeader'
		*!*	pColumna.AddObject('Header1', 'HeadOrden', pCampo, This.GetIndiceColumna(pColumna.Name))
		*!*	pColumna.Header1.Caption  = cCaption
		*!*	pColumna.Header1.FontName = cFont
	ENDPROC


	PROCEDURE Unload
		&&<ON KEY LABEL ENTER 
		IF !This.Indicadorlista 
			RETURN This.ValorDevuelto
		ELSE
			RETURN This.Traslado 
		ENDIF
	ENDPROC


	PROCEDURE Resize
		DODEFAULT()
		This.Contenedor.Top=0
		This.Contenedor.Left =0
		This.Contenedor.Width = This.Width - 2
		&&& Botones
		This.Botongrupo.Top=This.StatusBar.Top - This.Botongrupo.Height - 2 
		This.Botongrupo.Left =0
		This.Botongrupo.Width = This.Width - 2
		This.Botongrupo.Cmb_Ayuda.Left=1 
		This.Botongrupo.Cmb_Cancelar.Left = This.Botongrupo.Width   - This.Botongrupo.Cmb_Cancelar.Width -2
		This.Botongrupo.Cmb_Aceptar.Left = INT(This.Botongrupo.Width/2)-INT(This.Botongrupo.Cmb_Ayuda.Width/2)
		&&&& Cuadricula
		This.Listado.Top=This.Contenedor.Top + This.Contenedor.Height + 2
		This.Listado.Left =0
		This.Listado.Width=This.Width -2 
		This.Listado.Height = This.Height - This.Contenedor.Height - This.StatusBar.Height -  This.Botongrupo.Height  - 2


		ThisForm.Refresh()
	ENDPROC


	PROCEDURE Init
		LPARAMETERS lpnombretabla,lalias,lpcampos,lcamposmuestra,ldevuelve,lpsqlselect,lpindices,;
		            lpunavez,lnroindice,lvaloractual,ltxt_busca_focus,ltxt_buscar_tecla,lcondi_pinta,;
		            lplista,lpcamposadicionales,lparticion,lptraslado as Custom 

		&&Otbr.visible=.F.


		This.Indicadorlista = lplista
		This.CamposAdicionales = lpcamposadicionales

		IF lparticion
			This.Listado.Partition = INT(This.Listado.Width /2)+50
			This.Listado.Panel = 0
			This.Listado.View = 1 
		ENDIF


		ThisForm.LockScreen=.t.
		This.Buscar_Presionar_tecla=ltxt_buscar_tecla 
		IF This.Buscar_Presionar_tecla
		   This.Contenedor.Check_Presiona.Value=1 
		EndIf
		This.Valordevuelto=Null
		This.Unavez=lpunavez
		IF This.Unavez
		   This.DatosLista.Cerrartabla=.F.  
		EndIf 
		IF !EMPTY(lpnombretabla) AND TYPE("lpnombretabla")=="C"
		    This.DatosLista.Nombretabla=UPPER(lpnombretabla)
		    This.DatosLista.Alias=UPPER(lalias) 
		ENDIF
		IF !EMPTY(lpcampos) AND TYPE("lpcampos")=="C" 
		    lpcampos=UPPER(STRTRAN(ALLTRIM(lpcampos)," ",""))
		    This.DatosLista.Campos=lpcampos 
		ENDIF
		IF !EMPTY(lcamposmuestra) AND TYPE("lcamposmuestra")=="C" 
		    lcamposmuestra=UPPER(STRTRAN(ALLTRIM(lcamposmuestra)," ",""))
		    This.Listado.Campos=lcamposmuestra
		ENDIF
		IF !EMPTY(ldevuelve) AND TYPE("ldevuelve")=="C"
		    This.DatoDevuelto=ldevuelve
		ENDIF
		IF !EMPTY(lcondi_pinta) AND TYPE("lcondi_pinta")=="C"
		    This.Condicion_pinta_letra=lcondi_pinta
		ENDIF


		IF !EMPTY(This.DatosLista.Nombretabla)
		    IF !EMPTY(lpsqlselect) AND TYPE("ldevuelve")=="C"
		       IF This.Indicadorlista
		       	  lpsqlselect=UPPER(lpsqlselect)       	  
		       	  IF Ocnx.Tipo_BD = 2
		       	  	lpsqlselect=STRTRAN(lpsqlselect,"SELECT","SELECT 0 as indsel,100-100 as O,")
		       	  ELSE
		       	  	lpsqlselect=STRTRAN(lpsqlselect,"SELECT","SELECT 0 as 'indsel',100-100 as O,")       	  
		       	  ENDIF 
		       ENDIF
		       
		*!*	       IF UPPER(Ocnx.Usuario)=='EPALOMINO'
		*!*	       	SUSP
		*!*	       ENDIF
		       
		       This.DatosLista.SQLSelect=lpsqlselect 
		    ENDIF
		    IF !This.UnaVez OR !USED(This.DatosLista.Alias)
				This.DatosLista.Init() 
			ENDIF


			IF !USED(NVL(This.DatosLista.Alias,""))
				MESSAGEBOX("NO SE PUEDE CONTINUAR CON LA AYUDA YA QUE NO EXISTE LA TABLA ASOCIADA",16,"BUSCAR")
				RETURN .F.
			ENDIF

			This.Listado.AsociaTabla(ThisForm.DatosLista)
			IF This.AjustarCuadricula 
				This.Listado.AjustaPropiedades() 
			EndIf
			IF This.Indicador_cambia_campos
				This.Cambia_campos() 
			ENDIF
			 
			IF This.Indicadorlista
				This.Listado.Columns[1].RemoveObject("Text1")
			    This.Listado.Columns[1].AddObject("IndSel","Check_Busca")
			    This.Listado.Columns[1].Sparse=.F.
			    This.Listado.Columns[1].IndSel.Caption=""
			    This.Listado.Columns[1].IndSel.Visible=.T.
			    This.Listado.Columns[1].IndSel.ReadOnly=.F.
			    This.Listado.Columns[1].ReadOnly=.F.
			    This.Listado.Columns[1].Header1.Caption="R"
			    This.Listado.Columns[1].Header1.FontName="Wingdings 2"
			    This.Listado.Columns[1].Header1.FontSize=10
			    This.Listado.Columns[2].Width=0
			ENDIF

			This.Contenedor.Cmb_Orden.RemoveItem(1)  
			IF TYPE("lpindices")=="O"
			   SELECT (This.DatosLista.Area)
		       FOR ln=1 TO 10
		           IF !EMPTY(lpindices.indice[ln,1])
		              lindex="Index On "+lpindices.indice[ln,1]+" Tag "+LEFT(lpindices.indice[ln,2],10)   
		              &lindex
		              IF !EMPTY(ALLTRIM(UPPER(LEFT(lpindices.indice[ln,2],10))))
			              This.Contenedor.Cmb_Orden.AddItem(UPPER(LEFT(lpindices.indice[ln,2],10)))
			              This.Contenedor.Cmb_Orden.Value=LEFT(lpindices.indice[ln,2],10)
		              ENDIF
		              
		           ENDIF
		       ENDFOR

		       This.Listado.Cambia_Header()  

		*!*		    IF UPPER(OCnx.Usuario)=="EPALOMINO"
		*!*		    	SUSP
		*!*		    ENDIF
			    
			   lir_al_primero=.T.
			    
		       IF !EMPTY(TAG()) AND !EMPTY(NVL(lvaloractual,''))
			       lir_al_primero=.F.
		          SET ORDER TO 1
		          &&SET NEAR ON 
		          DO CASE
		          	 CASE TYPE("lvaloractual")=="C"
		          	      lbusca=lvaloractual
		          	 CASE TYPE("lvaloractual")=="D" OR TYPE("lvaloractual")=="T"
		          	  	  lbusca=DTOS(lvaloractual) 
		          	 CASE TYPE("lvaloractual")=="N"
		          	  	  lbusca=STR(lvaloractual) 
		          ENDCASE
		          IF !SEEK(lbusca)
			        lir_al_primero=.T.
		          ENDIF
		          
		          &&SET NEAR OFF         
		       ENDIF
		       IF lpindices.IndiceDefault>0
		          ltag=lpindices.indice[lpindices.IndiceDefault,2]
		          SET ORDER TO &ltag
		       ENDIF
		       If  lir_al_primero
		       		GO TOP 
		       ENDIF
		       

		       This.Contenedor.Cmb_Orden.Value=TAG()
		       This.Contenedor.Cmb_Orden.InteractiveChange() 
			ENDIF
			This.Listado.AutoFit() 
			IF This.Indicadorlista
				This.Listado.Columns[2].Width=0
			ENDIF


			&&This.Listado.AllowAutoColumnFit=
		    ThisForm.Refresh()
		ENDIF
		ThisForm.LockScreen=.f.
		This.Resize() 
		This.Listado.When() 
		IF ltxt_busca_focus
		   This.Contenedor.Txt_Busca.SetFocus() 
		ENDIF 
		This.Caption="Buscar: "+ALLTRIM(This.Caption ) 
		IF This.Indicadorlista
		    This.Listado.Columns[2].RemoveObject("Header1")
		ENDIF
		This.Listado.AutoFit() 
		IF This.Indicadorlista
			This.Listado.Columns[2].Visible=.F.
		ENDIF

		This.Listado.Refresh()  
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE actualiza_datos
		This.DatosLista.Selecciona()  
	ENDPROC


	PROCEDURE Destroy
		DODEFAULT()
		&&Otbr.visible=.T.
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		&&susp
		IF !EMPTY(ThisForm.DatoDevuelto)
		    PRIVATE lsele,lsela,lxse,lxco,lxcl,lpos
		    lsele=SELECT()
		    IF !ThisForm.Indicadorlista 
			    ldato=ThisForm.DatoDevuelto
			    SELECT (ThisForm.DatosLista.Area) 
			    ThisForm.ValorDevuelto=&ldato
		    ELSE
				IF !EMPTY(ThisForm.Listado.RecordSource) AND USED(ThisForm.Listado.RecordSource)
					ThisForm.Traslado=CREATEOBJECT("Traslado") 
					SELECT (ThisForm.DatosLista.Area) 
					GO TOP
					COUNT TO lxco FOR indsel=1
					GO TOP
					ThisForm.Traslado.Items=lxco

				    ldato=ThisForm.DatoDevuelto

					IF ThisForm.Traslado.Items>0
					   lvez=0
						IF !EMPTY(ThisForm.CamposAdicionales)
						    &&& Verifica Cuantas Columnas va a devolver &&&
							ThisForm.CamposAdicionales=ALLTRIM(ThisForm.CamposAdicionales)
							ThisForm.CamposAdicionales=STRTRAN(ThisForm.CamposAdicionales," ","")
							IF ","$ThisForm.CamposAdicionales
							   
							   lvez=OCCURS(',',ThisForm.CamposAdicionales)
							   DIMENSION lotrcam[lvez+1]
							   lcampoAdicionales=ThisForm.CamposAdicionales
							   
							   lpos=1
							   lvez=1
							   DO WHILE lpos>0 
			   					   lpos				 = AT(",",lcampoAdicionales) 
			   					   IF lpos>0
									   lcolsel			 = LEFT(lcampoAdicionales,lpos-1)
									   lotrcam[lvez]	 = lcolsel
									   lcampoAdicionales = SUBSTR(lcampoAdicionales,lpos+1,LEN(lcampoAdicionales))
									   lvez=lvez+1
								   ENDIF
							   ENDDO
							   lotrcam[lvez] = lcampoAdicionales
												   
							ELSE
								DIMENSION lotrcam[1]
								lotrcam[1]=ThisForm.CamposAdicionales
								lxcl=2
							ENDIF

							&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
						ENDIF
						DIMENSION ThisForm.Traslado.ItemsLista[ThisForm.Traslado.Items,lvez+1]
						lxse=1
						SELECT (ThisForm.DatosLista.Area) 
						ltagx=TAG() 
						INDEX ON STR(O,2) TAG Ord_Sel
						SET KEY TO RANGE "  1","999"
						GO TOP 
						SCAN
							IF indsel=1
							   ThisForm.Traslado.ItemsLista[lxse,1]=&ldato 
							   IF lvez>0
								   FOR lpos=1 TO lvez
									   	lcolsel=lotrcam[lpos]
										ThisForm.Traslado.ItemsLista[lxse,lpos+1]=&lcolsel	   
								   ENDFOR
							   ENDIF
							   
							   lxse=lxse + 1
							Endif
							SELECT (ThisForm.DatosLista.Area) 
						ENDSCAN
						SET ORDER TO &ltagx
					ELSE
						MESSAGEBOX("NO A SELECCIONADO NINGUN REGISTRO",64,ThisForm.Caption)
						RETURN .F.
					ENDIF

				ENDIF
		    ENDIF
		    SELECT (lsele)
		    ThisForm.Release()
		EndIf
	ENDPROC


	PROCEDURE ordena
	ENDPROC


	PROCEDURE datoslista.selecciona
		DODEFAULT()
		IF USED(This.Alias)  
			ThisForm.StatusBar.Panels[1].Text="Total: "+ALLTRIM(STR(RECCOUNT(This.Area)))  
		ENDIF
	ENDPROC


	PROCEDURE listado.Refresh
		DODEFAULT()
		IF !EMPTY(NVL(ThisForm.Condicion_pinta_letra,''))
		   This.SetAll("DynamicForeColor","Iif("+ThisForm.Condicion_pinta_letra+",RGB(255,0,0),Rgb(0,0,0))","Column")
		ENDIF

		IF !EMPTY(This.RecordSource) AND USED(This.RecordSource)
			IF ThisForm.IndicadorLista 
				This.SetAll("DynamicForeColor","Iif("+ALLTRIM(This.RecordSource)+".indsel=1,RGB(0,0,255),Rgb(0,0,0))","Column")
			ENDIF
		ENDIF

		SELECT (ThisForm.DatosLista.Area) 
		ltag=TAG() 
		lexi=.F.
		FOR lx=1 TO ThisForm.Contenedor.Cmb_Orden.ListCount 
			IF ThisForm.Contenedor.Cmb_Orden.List[lx]=ltag
				lexi=.T.
			ENDIF
		ENDFOR

		IF !lexi AND EMPTY(ALLTRIM(ltag))
			ThisForm.Contenedor.Cmb_Orden.AddItem(ltag)
			ThisForm.Contenedor.Cmb_Orden.Value = ltag
		    ThisForm.Contenedor.Cmb_Orden.Refresh() 
		ENDIF

		  
	ENDPROC


	PROCEDURE listado.Valid
		*!*	ON KEY LABEL ENTER
		POP KEY
	ENDPROC


	PROCEDURE listado.AfterRowColChange
		LPARAMETERS nColIndex
		IF !ThisForm.No_Enter 
			This.When()
		ENDIF
		IF ThisForm.IndicadorLista 
			This.Refresh() 
		ENDIF
		DODEFAULT(nColIndex)
	ENDPROC


	PROCEDURE listado.When
		DODEFAULT()
		PUSH KEY CLEAR 
		*!*	ON KEY LABEL ENTER 
		*!*	ON KEY LABEL ENTER Otbr.Aceptar()
		ThisFOrm.No_Enter=.F. 
	ENDPROC


	PROCEDURE listado.DblClick
		DODEFAULT()
		This.Parent.BotonGrupo.Cmb_Aceptar.Click()   
	ENDPROC


	PROCEDURE txt_busca.InteractiveChange
		IF ThisForm.Contenedor.Check_Presiona.Value=1 AND ThisForm.Contenedor.Check_Cadena.Value=0
		   ThisForm.Contenedor.Btn_Ir.SetFocus()
		   ThisForm.Contenedor.Btn_Ir.Click() 
		   This.SetFocus()  
		EndIf 
	ENDPROC


	PROCEDURE txt_busca.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl
		 
	ENDPROC


	PROCEDURE txt_busca.LostFocus
		dode()
		ThisForm.Listado.SetFocus()  
	ENDPROC


	PROCEDURE btn_ir.Click
		PRIVATE lllave,lfilter
		TRY 
			SELECT (ThisForm.DatosLista.Area)
			lllave=KEY()
			&&WAIT WINDOW ThisForm.Txt_Busca.Value NOWAIT 
			IF !EMPTY(ALLTRIM(ThisForm.Contenedor.Txt_Busca.Value))
				IF TYPE(lllave)=="C"
					lfilter="SET FILTER TO '"+UPPER(ALLTRIM(ThisForm.Contenedor.Txt_Busca.Value))+"'$UPPER("+lllave+")"
					&lfilter
				ELSE
					SET FILTER TO
				ENDIF

			ELSE
				SET FILTER TO
			ENDIF
		*!*		IF ThisForm.Contenedor.Check_Cadena.Value=1
		*!*		   IF !EOF(ThisForm.DatosLista.Area) AND !BOF(ThisForm.DatosLista.Area)
		*!*		      SKIP IN (ThisForm.DatosLista.Area) 
		*!*		      IF !EOF(ThisForm.DatosLista.Area) AND !BOF(ThisForm.DatosLista.Area)
		*!*		          DO WHILE !EOF(ThisForm.DatosLista.Area)
		*!*		             IF UPPER(ALLTRIM(ThisForm.Contenedor.Txt_Busca.Value))$UPPER(&lllave)
		*!*		                Exit
		*!*		             ENDIF
		*!*		             SKIP 1 
		*!*		          ENDDO
		*!*		          IF EOF(ThisForm.DatosLista.Area)
		*!*		             WAIT WINDOW "Final de la Busqueda..." NOWAIT
		*!*		             GO top
		*!*		          ENDIF
		*!*		      ENDIF
		*!*		   ELSE
		*!*		      GO TOP
		*!*		   ENDIF
		*!*		ELSE
		*!*		   SET NEAR ON
		*!*		   =SEEK(ALLTRIM(ThisForm.Contenedor.Txt_Busca.Value),ThisForm.DatosLista.Area)
		*!*		   SET NEAR OFF
		*!*		ENDIF
			GO TOP 
			ThisForm.Listado.SetFocus() 
			ThisForm.Listado.Refresh()
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+lerror.details+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure)
		ENDTRY

	ENDPROC


	PROCEDURE cmb_orden.InteractiveChange
		ltag=This.Value
		lcurdir=SELECT()
		SELECT (ThisForm.DatosLista.Area)
		SET ORDER TO &ltag
		ThisForm.Listado.SetFocus()
		ThisForm.Contenedor.key.Caption=KEY()
		ThisForm.Refresh()
		SELECT (lcurdir)
	ENDPROC


	PROCEDURE check_cadena.Click
		IF This.Value = 1
			This.Parent.Check_Presiona.Value = 0
			This.Parent.Check_Presiona.Refresh() 
		EndIf
	ENDPROC


	PROCEDURE btnexcel.Click
		ThisForm.Listado.Copia_excel() 
	ENDPROC


	PROCEDURE btnmarca.Click
		IF !EMPTY(ThisForm.Listado.RecordSource) AND USED(ThisForm.Listado.RecordSource) 
			PRIVATE lselec,lrecg
			lselec="Select '"+ALLTRIM(ThisForm.Listado.RecordSource)+"'"
			&lselec
			lrecg=RECNO()
			REPLACE indsel WITH 1 ALL
			GO top
			SCAN
				IF RECNO()=lrecg
					EXIT
				ENDIF
			ENDSCAN
			ThisForm.Listado.Refresh()  
		ENDIF
	ENDPROC


	PROCEDURE btnmarca.Refresh
		This.Visible=(ThisForm.IndicadorLista)
	ENDPROC


	PROCEDURE btndesmarca.Click
		IF !EMPTY(ThisForm.Listado.RecordSource) AND USED(ThisForm.Listado.RecordSource) 
			PRIVATE lselec,lrecg
			lselec="Select '"+ALLTRIM(ThisForm.Listado.RecordSource)+"'"
			&lselec
			lrecg=RECNO()
			REPLACE indsel WITH 0 ALL
			GO top
			SCAN
				IF RECNO()=lrecg
					EXIT
				ENDIF
			ENDSCAN
			ThisForm.Listado.Refresh()  
		ENDIF
	ENDPROC


	PROCEDURE btndesmarca.Refresh
		This.Visible=(ThisForm.IndicadorLista)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: buscar
**************************************************


**************************************************
*-- Class:        buscar_fecha (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   05/11/06 04:59:00 PM
*-- Calendario de Fechas
*
DEFINE CLASS buscar_fecha AS responde


	DataSession = 2
	Height = 266
	Width = 466
	DoCreate = .T.
	Name = "buscar_fecha"
	entorno.Name = "entorno"
	StatusBar.Top = 243
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 466
	StatusBar.Name = "StatusBar"
	CRISTAL.Name = "CRISTAL"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Left = 375
	botongrupo.Top = 44
	botongrupo.Name = "botongrupo"
	devuelve = .F.


	ADD OBJECT olefecha AS olecontrol WITH ;
		Top = 0, ;
		Left = 0, ;
		Height = 240, ;
		Width = 372, ;
		Name = "OleFecha"


	PROCEDURE Init
		LPARAMETERS lp_fecha as Date 


		IF PARAMETERS()>0 AND (TYPE("lp_fecha")=="T" OR TYPE("lp_fecha")=="D") AND !EMPTY(NVL(lp_fecha,""))
			This.OleFecha.OBJECT.Value =  lp_fecha
		ELSE
			This.OleFecha.OBJECT.Value = DATE() 
		ENDIF

		DODEFAULT()

		This.Caption ="Calendario"
	ENDPROC


	PROCEDURE Unload
		RETURN This.Devuelve 
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		ThisForm.Devuelve=ThisForm.OleFecha.OBJECT.Value 
		ThisForm.Cerrar()    
	ENDPROC


ENDDEFINE
*
*-- EndDefine: buscar_fecha
**************************************************


**************************************************
*-- Class:        encuentra_item (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   12/05/06 12:52:02 PM
*
DEFINE CLASS encuentra_item AS responde


	Height = 331
	Width = 656
	DoCreate = .T.
	Name = "encuentra_item"
	entorno.Name = "entorno"
	StatusBar.Top = 308
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 656
	StatusBar.Name = "StatusBar"
	cristal.Name = "cristal"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Left = 552
	botongrupo.Top = 12
	botongrupo.Name = "botongrupo"


	ADD OBJECT detalle AS grid WITH ;
		ColumnCount = 2, ;
		FontName = "MS Sans Serif", ;
		DeleteMark = .F., ;
		Height = 308, ;
		Left = 1, ;
		Panel = 1, ;
		Top = 1, ;
		Width = 531, ;
		GridLineColor = RGB(192,192,192), ;
		Name = "Detalle", ;
		Column1.FontName = "MS Sans Serif", ;
		Column1.Enabled = .F., ;
		Column1.Width = 260, ;
		Column1.ForeColor = RGB(255,255,128), ;
		Column1.BackColor = RGB(0,64,128), ;
		Column1.Name = "Column1", ;
		Column2.FontName = "MS Sans Serif", ;
		Column2.Width = 237, ;
		Column2.Name = "Column2"


	ADD OBJECT encuentra_item.detalle.column1.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Columna", ;
		Name = "Header1"


	ADD OBJECT encuentra_item.detalle.column1.text1 AS textbox WITH ;
		FontName = "MS Sans Serif", ;
		BorderStyle = 0, ;
		Enabled = .F., ;
		Margin = 0, ;
		ForeColor = RGB(255,255,128), ;
		BackColor = RGB(0,64,128), ;
		Name = "Text1"


	ADD OBJECT encuentra_item.detalle.column2.header1 AS header WITH ;
		FontName = "MS Sans Serif", ;
		Caption = "Que contenga el Dato", ;
		Name = "Header1"


	ADD OBJECT encuentra_item.detalle.column2.text1 AS textbox WITH ;
		FontName = "MS Sans Serif", ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	PROCEDURE Init
		LPARAMETERS lp_grid as Grid 

		IF PARAMETERS()=0
			MESSAGEBOX("Tiene que Enviar como parametro una Cuadrícula",16,"Busca Item")
			RETURN .F.
		ENDIF

		This.Caption = "Busca datos en la Cuadricula"
		PRIVATE larre,ln,lx,lcaption,li,lcampos,lalias
		DIMENSION larre[lp_grid.ColumnCount,3]

		FOR ln=1 TO lp_grid.ColumnCount
			larre[1,1]=""
		ENDFOR

		lcampos=""

		FOR ln=1 TO  lp_grid.ColumnCount
			FOR lx=1 TO lp_grid.ColumnCount
				IF lp_grid.Columns[lx].ColumnOrder=ln 
					lcaption=""

					&&&&&&&&&&&&&&&&&&&&
					lna=AMEMBERS(larr,lp_grid.Columns[lx],3,"G")
					FOR li=1 TO lna 
						IF TYPE("lp_grid.Columns["+ALLTRIM(STR(lx))+"]."+ALLTRIM(larr[li,1])+".Class")=="C"
							IF TYPE("lp_grid.Columns["+ALLTRIM(STR(lx))+"]."+ALLTRIM(larr[li,1])+".Caption")=="C"
								lobj="lp_grid.Columns["+ALLTRIM(STR(lx))+"]."+ALLTRIM(larr[li,1])+".Caption"
								lcaption = &lobj
								EXIT 
							ENDIF
						ENDIF
					ENDFOR

					&&&&&&&&&&&&&&&&&&&&
					IF 	LEN(lcaption)>0
						larre[ln,1]=lp_grid.Columns[lx].Header1.Caption
						larre[ln,2]=TYPE(ALLTRIM(lp_grid.Columns[lx].ControlSource))
						larre[ln,3]=lp_grid.Columns[lx].ControlSource
					ENDIF
				ENDIF
			ENDFOR
		ENDFOR

		lalias=SYS(2015)

		CREATE CURSOR &lalias (descri c(200) , tipo c(1), valor c(100), campo c(100))

		This.LockScreen =.T.
		This.Detalle.RecordSource = SPACE(0)
		This.Detalle.RecordSource = lalias
		This.Detalle.Column1.ControlSource =  lalias+".descri"
		This.Detalle.Column2.ControlSource =  lalias+".valor"
		This.LockScreen =.F.

		FOR li =1 TO lp_grid.ColumnCount
			IF !EMPTY(larre[li,1])
				SELECT &lalias
				APPEND BLANK
				REPLACE descri 	WITH larre[li,1] ,;
						tipo	WITH larre[li,2] ,;
						valor   WITH '' ,;
						campo	WITH larre[li,3]
			ENDIF
		ENDFOR
		GO TOP IN &lalias
		This.Detalle.Refresh()  

		 
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		PRIVATE lalias,lcadena
		lalias=ThisForm.Detalle.RecordSource

		lcadena="1=1"
		&&SUSP
		SELECT &lalias
		GO top
		SCAN
			IF !EMPTY(NVL(valor,''))
				IF tipo=="C"
					lcadena=lcadena+" and UPPER('"+ALLTRIM(valor)+"')$UPPER("+ALLTRIM(campo)+")"
				ENDIF

				IF tipo$"TD"
					lcadena=lcadena+" and '"+ALLTRIM(valor)+"'$DTOS("+ALLTRIM(campo)+")"
				ENDIF

				IF tipo$"N"
					lcadena=lcadena+" and "+ALLTRIM(campo)+"="+ALLTRIM(valor)
				ENDIF
			ENDIF

			SELECT &lalias
		ENDSCAN
		Oentorno.Parametros[3,1]=lcadena
		  
		ThisForm.Cerrar() 
	ENDPROC


	PROCEDURE detalle.Init
		ThisForm.LockScreen = .T.
		This.RecordSource = SPACE(0)
		ThisForm.LockScreen = .F.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: encuentra_item
**************************************************


**************************************************
*-- Class:        mueve_item (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   11/14/06 03:26:03 PM
*
DEFINE CLASS mueve_item AS responde


	Height = 229
	Width = 373
	DoCreate = .T.
	Name = "mueve_item"
	entorno.Name = "entorno"
	StatusBar.Top = 206
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 373
	StatusBar.Name = "StatusBar"
	CRISTAL.Top = 192
	CRISTAL.Left = 360
	CRISTAL.Name = "CRISTAL"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Left = 264
	botongrupo.Top = 24
	botongrupo.Name = "botongrupo"


	ADD OBJECT txt_item_origen AS texto WITH ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 127, ;
		Top = 46, ;
		Width = 53, ;
		Name = "txt_item_origen"


	ADD OBJECT txt_item_destino AS texto WITH ;
		Height = 23, ;
		Left = 127, ;
		Top = 106, ;
		Width = 53, ;
		Name = "txt_item_destino"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Origen", ;
		Left = 60, ;
		Top = 48, ;
		Name = "Etiqueta1"


	ADD OBJECT etiqueta2 AS etiqueta WITH ;
		Caption = "Destino", ;
		Left = 60, ;
		Top = 108, ;
		Name = "Etiqueta2"


	PROCEDURE Init
		LPARAMETERS lp_origen as String 
		IF PARAMETERS()=0
			MESSAGEBOX("No se a enviado el Item a Mover",16,"Mueve Item")
			RETURN .F.
		ENDIF
		This.Caption = "Mueve Items"
		llen=LEN(ALLTRIM(lp_origen))


		This.txt_item_origen.MaxLength =  llen
		This.txt_item_origen.Format = REPLICATE("9",llen)
		This.txt_item_origen.Value =  lp_origen

		This.txt_item_destino.MaxLength  = This.txt_item_origen.MaxLength
		This.txt_item_destino.Format  = This.txt_item_origen.Format
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		IF TYPE("Oentorno.ItemOrigen")=="C" AND TYPE("Oentorno.ItemDestino")=="C"
			Oentorno.ItemOrigen  = ThisForm.Txt_item_origen.Value 
			Oentorno.ItemDestino = ThisForm.Txt_item_destino.Value  
		ENDIF
		ThisForm.Cerrar() 
	ENDPROC


	PROCEDURE txt_item_destino.Valid
		This.Value = STRTRAN(STR(VAL(ALLTRIM(This.Value)),This.MaxLength)," ","0")  
	ENDPROC


ENDDEFINE
*
*-- EndDefine: mueve_item
**************************************************


**************************************************
*-- Class:        ordena_cuadricula (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   11/14/06 03:39:10 PM
*
DEFINE CLASS ordena_cuadricula AS responde


	Height = 264
	Width = 457
	DoCreate = .T.
	Name = "ordena_cuadricula"
	entorno.Name = "entorno"
	StatusBar.Top = 241
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 457
	StatusBar.Name = "StatusBar"
	cristal.Name = "cristal"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 69
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 138
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Left = 370
	botongrupo.Top = 0
	botongrupo.Name = "botongrupo"
	detalle = .F.
	confi_dele = .F.


	ADD OBJECT lista1 AS lista WITH ;
		Height = 189, ;
		Left = 0, ;
		Top = 24, ;
		Width = 167, ;
		Name = "Lista1"


	ADD OBJECT lista2 AS lista WITH ;
		Height = 188, ;
		Left = 207, ;
		Top = 24, ;
		Width = 161, ;
		Name = "Lista2"


	ADD OBJECT btnagregar AS boton WITH ;
		Top = 52, ;
		Left = 170, ;
		Height = 27, ;
		Width = 35, ;
		FontBold = .T., ;
		Caption = ">", ;
		ToolTipText = "Selecciona Columna", ;
		ForeColor = RGB(0,0,255), ;
		Name = "BtnAgregar"


	ADD OBJECT btnagregar_todos AS boton WITH ;
		Top = 81, ;
		Left = 170, ;
		Height = 27, ;
		Width = 35, ;
		FontBold = .T., ;
		Caption = ">>", ;
		ToolTipText = "Selecciona Todas las Columna", ;
		ForeColor = RGB(0,0,255), ;
		Name = "BtnAgregar_Todos"


	ADD OBJECT btnquitar AS boton WITH ;
		Top = 115, ;
		Left = 170, ;
		Height = 27, ;
		Width = 35, ;
		FontBold = .T., ;
		Caption = "<", ;
		ToolTipText = "Quita Columna seleccionada", ;
		ForeColor = RGB(0,0,255), ;
		Name = "BtnQuitar"


	ADD OBJECT btnquitar_todos AS boton WITH ;
		Top = 144, ;
		Left = 170, ;
		Height = 27, ;
		Width = 35, ;
		FontBold = .T., ;
		Caption = "<<", ;
		ToolTipText = "Quita todas las columnas seleccionadas", ;
		ForeColor = RGB(0,0,255), ;
		Name = "BtnQuitar_Todos"


	ADD OBJECT etiqueta1 AS etiqueta WITH ;
		Caption = "Columas", ;
		Left = 0, ;
		Top = 6, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Etiqueta1"


	ADD OBJECT etiqueta2 AS etiqueta WITH ;
		Caption = "Columas Seleccionadas", ;
		Left = 208, ;
		Top = 6, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Etiqueta2"


	ADD OBJECT opc_indasc AS opciones WITH ;
		Height = 25, ;
		Left = 0, ;
		Top = 215, ;
		Width = 204, ;
		Name = "Opc_IndAsc", ;
		Option1.Caption = "Ascendente", ;
		Option1.Left = 5, ;
		Option1.Top = 5, ;
		Option1.Name = "Option1", ;
		Option2.Caption = "Descendente", ;
		Option2.Left = 108, ;
		Option2.Top = 5, ;
		Option2.Name = "Option2"


	PROCEDURE carga_datos_del_grid
		PRIVATE lf,lo,ltitul,lcampo

		IF This.Detalle.ColumnCount>0
		   FOR lf=1	TO	This.Detalle.ColumnCount
		   		FOR	lo=1 TO	This.Detalle.ColumnCount
		   		    IF This.Detalle.Columns[lo].ColumnOrder=lf AND !"+"$This.Detalle.Columns[lo].ControlSource
		   		       ltitul=This.Detalle.Columns[lo].Header1.Caption
		   		       lcampo=This.Detalle.Columns[lo].ControlSource
		   		       INSERT INTO  "Tlista1" VALUES  (ltitul,lcampo)   
		   		    ENDIF
				ENDFOR 
		   ENDFOR
		ENDIF
		This.lista1.Requery 
		This.lista1.Refresh
	ENDPROC


	PROCEDURE Init
		LPARAMETERS lcuadricula
		IF PARAMETERS()=0 OR !TYPE('lcuadricula')=='O'
		   MESSAGEBOX("SE ESPERABA UN PARAMETRO TIPO CUADRICULA",64,"Ordena")
		   RETURN .F.
		ENDIF
		This.Caption="Ordena en: "+ALLTRIM(This.Caption)
		This.Confi_dele=SET("Deleted")
		SET DELETED ON
		This.Detalle=lcuadricula 
		This.Carga_datos_del_grid()
	ENDPROC


	PROCEDURE Unload
		ldele=This.Confi_Dele 
		SET DELETED &ldele
		IF USED("Tlista1")
		   USE IN "Tlista1"
		ENDIF
		IF USED("Tlista2")
		   USE IN "Tlista2"
		ENDIF
		   
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		lalias=ThisForm.Detalle.RecordSource
		lcad=""
		SELECT "Tlista2"
		GO TOP
		IF !EOF("Tlista2")
		    Scan 
		        ldat=ALLTRIM(Tlista2.campo)
		        lpos=ATC(".",ldat,1)
		        ldat=ALLTRIM(SUBSTR(ldat,lpos+1,LEN(ldat)))
		        lver="Type('"+ALLTRIM(Tlista2.campo)+"')=='C'"
		        IF &lver
			        ldat=ALLTRIM(ldat)
		        ENDIF
		        lver="Type('"+ALLTRIM(Tlista2.campo)+"')=='N'"
		        IF &lver
			        ldat="STR("+ldat+")"
		        ENDIF
		        lver="Type('"+ALLTRIM(Tlista2.campo)+"')=='D'"
		        IF &lver
			        ldat="DTOS("+ldat+")"
		        ENDIF
		        lver="Type('"+ALLTRIM(Tlista2.campo)+"')=='T'"
		        IF &lver
			        ldat="DTOS("+ldat+")"
		        ENDIF
			    lcad=lcad+ldat+"+"
			EndScan    
		ENDIF

		IF !EMPTY(lcad)
		    lcad=LEFT(lcad,LEN(lcad)-1)
		    lsele="Select '"+lalias+"'"
		    &lsele
		    ldat=&lcad
		    IF LEN(ldat)>240
		       MESSAGEBOX("LA SUMA DE LOS CARACATERES DE LAS COLUMNAS QUE CONFORMAN "+;
		                  "EL INDICE NO PUEDE SER MAYOR 240",64,ThisForm.Caption)
		       RETURN 
		    ENDIF
		    
		    lindex="Index ON "+LCAD+" TAG "+SYS(2015)+" "+IIF(ThisForm.Opc_IndAsc.Value=2,"DESC","")
		    &lindex
		    WAIT WINDOW lcad NOWAIT 
		    
		ENDIF
		ThisForm.Cerrar()

		 
	ENDPROC


	PROCEDURE lista1.Init
		CREATE CURSOR Tlista1 (descri CHR(80),campo char(50))
		INDEX ON descri TAG D
		SET ORDER TO
		This.RowSource="Tlista1"
		This.RowSourceType= 2
		This.Requery() 
		DODEFAULT()
	ENDPROC


	PROCEDURE lista2.Init
		CREATE CURSOR Tlista2 (descri CHR(80),campo char(50))
		INDEX ON descri TAG D
		SET ORDER TO
		This.RowSource="Tlista2"
		This.RowSourceType= 2
		This.Requery() 
		DODEFAULT()
	ENDPROC


	PROCEDURE btnagregar.Click
		IF SEEK(ThisForm.Lista1.Value,"Tlista1","D")
		    IF !SEEK(ThisForm.Lista1.Value,"Tlista2","D")
		       INSERT INTO Tlista2 VALUES (Tlista1.descri,Tlista1.campo)
		       SELECT "Tlista1" 
		       DELETE 
		    ENDIF
			ThisForm.Lista1.Requery 
			ThisForm.Lista1.Refresh 
			ThisForm.Lista2.Requery 
			ThisForm.Lista2.Refresh 
		ENDIF
	ENDPROC


	PROCEDURE btnagregar_todos.Click
		SELECT "Tlista1"
		GO top
		SCAN
		    
			IF SEEK(tlista1.descri,"Tlista1","D")
			    IF !SEEK(tlista1.descri,"Tlista2","D")
			       INSERT INTO Tlista2 VALUES (Tlista1.descri,Tlista1.campo)
			       SELECT "Tlista1" 
			       DELETE 
			    ENDIF
			ENDIF
			SELECT "Tlista1"
		ENDSCAN
		ThisForm.Lista1.Requery 
		ThisForm.Lista1.Refresh 
		ThisForm.Lista2.Requery 
		ThisForm.Lista2.Refresh 
	ENDPROC


	PROCEDURE btnquitar.Click
		IF SEEK(ThisForm.Lista2.Value,"Tlista2","D")
		    IF !SEEK(ThisForm.Lista2.Value,"Tlista1","D")
		      INSERT INTO Tlista1 VALUES (Tlista2.descri,Tlista2.campo)
		      SELECT "Tlista2" 
		      DELETE 
		    ENDIF
			ThisForm.Lista2.Requery 
			ThisForm.Lista2.Refresh 
			ThisForm.Lista1.Requery 
			ThisForm.Lista1.Refresh 
		ENDIF
	ENDPROC


	PROCEDURE btnquitar_todos.Click
		SELECT "Tlista2"
		GO top
		SCAN
			IF SEEK(Tlista2.descri,"Tlista2","D")
			    IF !SEEK(Tlista2.descri,"Tlista1","D")
			      INSERT INTO Tlista1 VALUES (Tlista2.descri,Tlista2.campo)
			      SELECT "Tlista2" 
			      DELETE 
			    ENDIF
			ENDIF
			SELECT "Tlista2"
		ENDSCAN
		ThisForm.Lista2.Requery 
		ThisForm.Lista2.Refresh 
		ThisForm.Lista1.Requery 
		ThisForm.Lista1.Refresh 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ordena_cuadricula
**************************************************


**************************************************
*-- Class:        procesos (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   08/20/04 12:06:13 PM
*
DEFINE CLASS procesos AS responde


	DoCreate = .T.
	Caption = "Proceso"
	tipo = "PROC"
	Name = "procesos"
	entorno.Name = "entorno"
	StatusBar.Top = 206
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 433
	StatusBar.Name = "StatusBar"
	cristal.Top = 0
	cristal.Left = 12
	cristal.Name = "cristal"
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Name = "botongrupo"


ENDDEFINE
*
*-- EndDefine: procesos
**************************************************


**************************************************
*-- Class:        consulta_xml (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  procesos (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   04/14/05 10:31:03 AM
*
DEFINE CLASS consulta_xml AS procesos


	DataSession = 2
	Height = 469
	Width = 719
	DoCreate = .T.
	*-- Indique que formulario se va abrir desde esta ventana
	formulario_asociado = ("")
	tipo = "FORM"
	Name = "consulta_xml"
	entorno.Top = 108
	entorno.Left = 660
	entorno.Height = 17
	entorno.Width = 24
	entorno.Name = "entorno"
	StatusBar.Top = 446
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 719
	StatusBar.Name = "StatusBar"
	cristal.Top = 12
	cristal.Left = 660
	cristal.Name = "cristal"
	botongrupo.AutoSize = .F.
	botongrupo.Cmb_Aceptar.Top = 2
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Height = 24
	botongrupo.Cmb_Aceptar.Width = 79
	botongrupo.Cmb_Aceptar.Caption = "\<Actualizar"
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 35
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Height = 24
	botongrupo.Cmb_Ayuda.Width = 79
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 72
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Height = 24
	botongrupo.Cmb_Cancelar.Width = 79
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Height = 100
	botongrupo.Left = 624
	botongrupo.Top = 0
	botongrupo.Width = 90
	botongrupo.Name = "botongrupo"


	ADD OBJECT traslado AS traslado WITH ;
		Top = 108, ;
		Left = 612, ;
		Height = 17, ;
		Width = 24, ;
		Name = "Traslado"


	ADD OBJECT datos AS datos WITH ;
		Top = 108, ;
		Left = 564, ;
		Height = 18, ;
		Width = 24, ;
		cuadriculaasociada = "ThisForm.Detalle", ;
		no_selecciona_inicio = .T., ;
		indicador_consulta = .T., ;
		Name = "Datos"


	ADD OBJECT detalle AS cuadricula WITH ;
		Height = 312, ;
		Left = 5, ;
		ReadOnly = .T., ;
		Top = 132, ;
		Width = 713, ;
		datoobjeto = ("Datos"), ;
		pintaregistro = .T., ;
		crea_indices_columnas = .T., ;
		Name = "Detalle"


	ADD OBJECT ctnfec AS contenedor WITH ;
		Top = 12, ;
		Left = 516, ;
		Width = 96, ;
		Height = 84, ;
		Name = "CtnFec"


	ADD OBJECT consulta_xml.ctnfec.olefecini AS olecontrol WITH ;
		Top = 24, ;
		Left = 4, ;
		Height = 23, ;
		Width = 86, ;
		Name = "OleFecIni"


	ADD OBJECT consulta_xml.ctnfec.olefecfin AS olecontrol WITH ;
		Top = 48, ;
		Left = 4, ;
		Height = 23, ;
		Width = 86, ;
		Name = "OleFecFin"


	ADD OBJECT consulta_xml.ctnfec.indran AS check WITH ;
		Top = 3, ;
		Left = 5, ;
		Caption = "Rango Fecha", ;
		Name = "IndRan"


	ADD OBJECT ctn AS contenedor WITH ;
		Top = 2, ;
		Left = 4, ;
		Width = 488, ;
		Height = 129, ;
		BorderWidth = 1, ;
		SpecialEffect = 0, ;
		Name = "Ctn"


	ADD OBJECT consulta_xml.ctn.etiqueta1 AS etiqueta WITH ;
		Caption = "Criterio 1", ;
		Left = 5, ;
		Top = 6, ;
		Name = "Etiqueta1"


	ADD OBJECT consulta_xml.ctn.etiqueta2 AS etiqueta WITH ;
		Caption = "Criterio 1", ;
		Left = 5, ;
		Top = 31, ;
		Name = "Etiqueta2"


	ADD OBJECT consulta_xml.ctn.etiqueta3 AS etiqueta WITH ;
		Caption = "Criterio 1", ;
		Left = 5, ;
		Top = 56, ;
		Name = "Etiqueta3"


	ADD OBJECT consulta_xml.ctn.etiqueta4 AS etiqueta WITH ;
		Caption = "Criterio 1", ;
		Left = 5, ;
		Top = 81, ;
		Name = "Etiqueta4"


	ADD OBJECT consulta_xml.ctn.txt_c1 AS texto WITH ;
		Height = 23, ;
		Left = 61, ;
		Top = 2, ;
		Width = 412, ;
		Name = "txt_c1"


	ADD OBJECT consulta_xml.ctn.txt_c2 AS texto WITH ;
		Height = 23, ;
		Left = 61, ;
		Top = 27, ;
		Width = 412, ;
		Name = "txt_c2"


	ADD OBJECT consulta_xml.ctn.txt_c3 AS texto WITH ;
		Height = 23, ;
		Left = 61, ;
		Top = 52, ;
		Width = 412, ;
		Name = "txt_c3"


	ADD OBJECT consulta_xml.ctn.txt_c4 AS texto WITH ;
		Height = 23, ;
		Left = 61, ;
		Top = 77, ;
		Width = 412, ;
		Name = "txt_c4"


	ADD OBJECT consulta_xml.ctn.txt_busca AS texto WITH ;
		Height = 23, ;
		Left = 61, ;
		Top = 102, ;
		Width = 288, ;
		Name = "txt_busca"


	ADD OBJECT consulta_xml.ctn.etiqueta5 AS etiqueta WITH ;
		Caption = "Buscar", ;
		Left = 10, ;
		Top = 106, ;
		Name = "Etiqueta5"


	PROCEDURE abrir_formulario

		PRIVATE lcad

		This.Carga_traslado() 

		lcad="Do Form '"+This.Entorno.Ruta+"Forms\"+This.Formulario_asociado+"' With This.Traslado "

		&lcad
	ENDPROC


	PROCEDURE grabar
		This.Traslado.Estado=0 
		IF EMPTY(ThisForm.Formulario_asociado) 
		   MESSAGEBOX("NO HAY FORMULARIO ASOCIADO",64,ThisForm.Caption)
		   RETURN 
		ENDIF
		IF !USED(ThisForm.Datos.Alias) 
			MESSAGEBOX("NO HA SELECCIONADO REGISTROS",16,This.Caption )
			RETURN 
		ENDIF
		SELECT (ThisForm.Datos.Area) 
		IF EOF() 
			MESSAGEBOX("NO HA SELECCIONADO REGISTROS",16,This.Caption)
			RETURN 
		ENDIF
		This.Abrir_formulario() 
	ENDPROC


	PROCEDURE nuevo
		This.Traslado.Estado = 1 
		ThisForm.Abrir_Formulario() 
	ENDPROC


	PROCEDURE actualiza_datos
		This.CargaTablas() 
	ENDPROC


	PROCEDURE cargatablas
		This.Datos.Selecciona()  
	ENDPROC


	PROCEDURE Resize
		DODEFAULT()
		This.Ctn.Top = 0
		This.Ctn.Left= 0

		This.Botongrupo.Top	 = 0

		This.Detalle.Top	 = This.Ctn.Top + This.Ctn.Height + 2
		This.Detalle.Left 	 = 0
		This.Detalle.Height	 = This.Height - This.Ctn.Height - This.StatusBar.Height    
		This.Detalle.Width 	 = This.Width - 2

		 
	ENDPROC


	PROCEDURE entorno.Init
		DODEFAULT()
		ThisForm.Caption= ALLTRIM(ThisForm.Caption) + "(Selecciona Registro)"
		ThisForm.Formulario_asociado = This.Programa  
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		ThisForm.Cargatablas() 
	ENDPROC


	PROCEDURE carga_traslado
	ENDPROC


	PROCEDURE olefecini.Refresh
		*** ActiveX Control Method ***
		This.Object.Enabled = (This.Parent.IndRan.Value = 1)  
	ENDPROC


	PROCEDURE olefecini.Init
		This.OBJECT.Value = DATE() 
	ENDPROC


	PROCEDURE olefecfin.Refresh
		*** ActiveX Control Method ***
		This.Object.Enabled = (This.Parent.IndRan.Value = 1)  
	ENDPROC


	PROCEDURE olefecfin.Init
		This.OBJECT.Value = DATE() 
	ENDPROC


	PROCEDURE indran.Click
		This.Parent.OlefecIni.Refresh()
		This.Parent.OlefecFin.Refresh()
	ENDPROC


	PROCEDURE txt_busca.InteractiveChange
		SELECT (ThisForm.Datos.Area) 
		=SEEK(ALLTRIM(This.Value)) 
		ThisForm.Detalle.Refresh()  
	ENDPROC


ENDDEFINE
*
*-- EndDefine: consulta_xml
**************************************************


**************************************************
*-- Class:        reporte (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  responde (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    form
*-- Time Stamp:   02/19/08 04:30:04 PM
*
DEFINE CLASS reporte AS responde


	Height = 229
	Width = 506
	DoCreate = .T.
	Icon = "..\imag\labels.ico"
	WindowState = 0
	*-- 1.- Es Reporte del Visual Fox Pro,  2. Es Reporte del Cristal Report
	tipo_reporte = 2
	datosfijos = .F.
	*-- 1 Arreiba , 2 Abajo
	otros_reportes_posicion = 1
	*-- Si esta en .T. y existe mas de un reporte que utiliza este filtro se muestra la opcion de Reportes Asociados
	mostras_otros_reportes = .T.
	Name = "reporte"
	entorno.Top = 204
	entorno.Left = 216
	entorno.Name = "entorno"
	StatusBar.Top = 206
	StatusBar.Left = 0
	StatusBar.Height = 23
	StatusBar.Width = 506
	StatusBar.ZOrderSet = 0
	StatusBar.Name = "StatusBar"
	cristal.Top = 12
	cristal.Left = 12
	cristal.ZOrderSet = 2
	cristal.Name = "cristal"
	botongrupo.AutoSize = .T.
	botongrupo.Cmb_Aceptar.Top = 5
	botongrupo.Cmb_Aceptar.Left = 5
	botongrupo.Cmb_Aceptar.Picture = "..\imag\wzprint.bmp"
	botongrupo.Cmb_Aceptar.Caption = "\<Imprime"
	botongrupo.Cmb_Aceptar.Name = "Cmb_Aceptar"
	botongrupo.Cmb_Ayuda.Top = 60
	botongrupo.Cmb_Ayuda.Left = 5
	botongrupo.Cmb_Ayuda.Name = "Cmb_Ayuda"
	botongrupo.Cmb_Cancelar.Top = 120
	botongrupo.Cmb_Cancelar.Left = 5
	botongrupo.Cmb_Cancelar.Name = "Cmb_Cancelar"
	botongrupo.Left = 396
	botongrupo.Top = 36
	botongrupo.ZOrderSet = 3
	botongrupo.Name = "botongrupo"


	ADD OBJECT ctnotroreportes AS contenedor WITH ;
		Anchor = 3, ;
		Top = 0, ;
		Left = 0, ;
		Width = 413, ;
		Height = 28, ;
		BorderWidth = 1, ;
		SpecialEffect = 0, ;
		Name = "CtnOtroReportes"


	ADD OBJECT reporte.ctnotroreportes.etiqueta1 AS etiqueta WITH ;
		Caption = "Reportes asociados", ;
		Height = 15, ;
		Left = 4, ;
		Top = 6, ;
		Width = 96, ;
		Name = "Etiqueta1"


	ADD OBJECT reporte.ctnotroreportes.cmbotrosreportes AS combo WITH ;
		ColumnCount = 2, ;
		ColumnWidths = "350", ;
		Height = 24, ;
		Left = 103, ;
		Sorted = .T., ;
		Top = 1, ;
		Width = 305, ;
		Name = "CmbOtrosReportes"


	PROCEDURE armadatosfijos
		IF ThisForm.DatosFijos 
			This.Cristal.Parametro[1,1]="ps_cia"
			This.Cristal.Parametro[1,2]=ThisForm.Entorno.CodigoCia
			This.Cristal.Parametro[2,1]="ps_nombrecia"
			This.Cristal.Parametro[2,2]=ThisForm.Entorno.NombreCia
			This.Cristal.Parametro[3,1]="ps_suc"
			This.Cristal.Parametro[3,2]=This.Entorno.CodigoSuc
			This.Cristal.Parametro[4,1]="ps_ano"
			This.Cristal.Parametro[4,2]=This.Entorno.Ano
			This.Cristal.Parametro[5,1]="ps_mes"
			This.Cristal.Parametro[5,2]=This.Entorno.Mes
			This.Cristal.Parametro[6,1]="ps_peri"
			This.Cristal.Parametro[6,2]=This.Entorno.Periodo
			This.Cristal.Parametro[7,1]="ps_programa"
			This.Cristal.Parametro[7,2]=This.Entorno.Programa
			This.Cristal.Parametro[8,1]="ps_tituloprograma"
			This.Cristal.Parametro[8,2]=This.Entorno.Titulo 
			This.Cristal.Parametro[9,1]="ps_usuario"
			This.Cristal.Parametro[9,2]=Ocnx.Usuario
		ENDIF

	ENDPROC


	PROCEDURE Resize
		DODEFAULT()
		IF This.Otros_reportes_posicion = 1
			This.CtnOtroReportes.Top = 0
		Else
			This.CtnOtroReportes.Top = This.StatusBar.Top - This.CtnOtroReportes.Height - 1  
		ENDIF
	ENDPROC


	PROCEDURE Init
		LPARAMETERS ldatosfijos
		This.DatosFijos = ldatosfijos
		IF This.DatosFijos
		   This.StatusBar.Panels[1].text="Datos Fijos: ps_cia,ps_nombrecia,ps_suc,ps_ano,ps_mes,ps_peri,ps_programa,ps_tituloprograma,ps_usuario" 
		ENDIF

		DODEFAULT()
	ENDPROC


	PROCEDURE entorno.Init
		DODEFAULT()
		ThisForm.Cristal.Programa=This.Programa  
		ThisForm.Cristal.TituloReporte =This.Titulo
		IF !EMPTY(This.Programa_filtro)
			ThisForm.StatusBar.Panels[2].Text="Filtro: "+This.Programa_filtro 
		ENDIF

	ENDPROC


	PROCEDURE cristal.arma_parametros
		ThisForm.Armadatosfijos 
	ENDPROC


	PROCEDURE botongrupo.Cmb_Aceptar.Click
		&&&&&&&&&&&&&&&&&&&&&&&&&& Visual Fox Pro
		IF TYPE("Otbr")=="O"
			Otbr.ActualizaOpciones()
		ENDIF

		PRIVATE lcatip

		DO CASE 
			CASE Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=4
				lcatip="Select ISNULL(s09_tipopc,'') as s09_tipopc "+;
					   "From SYS_TABLA_OPCIONES_S07 "+;
					   "Where s07_codopc='"+UPPER(ALLTRIM(ThisForm.Cristal.Programa))+"' "
			CASE Ocnx.Tipo_BD=2
				lcatip="Select NVL(s09_tipopc,'') as s09_tipopc "+;
					   "From "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
					   "Where s07_codopc='"+UPPER(ALLTRIM(ThisForm.Cristal.Programa))+"' "
		ENDCASE			   
		IF Ocnx.Tipo_BD=1 OR Ocnx.Tipo_BD=2
			IF SQLEXEC(Ocnx.Conexion,lcatip,"Ttipo")<0
			   MESSAGEBOX(MESSAGE()+chr(13)+lcatip,16,ThisForm.Caption)
			   RETURN 
			ENDIF
		ENDIF

		IF Ocnx.Tipo_BD=4
			IF Ocnx.Ms_Ejecuta_SQL(lcatip,"Ttipo",ThisForm.DataSessionId)<0
			   MESSAGEBOX(MESSAGE()+chr(13)+lcatip,16,ThisForm.Caption)
			   RETURN 
			ENDIF
		ENDIF


		IF Ttipo.s09_tipopc="INFO"
		   ThisForm.Tipo_Reporte=2
		ENDIF

		IF Ttipo.s09_tipopc="INVF"
		   ThisForm.Tipo_Reporte=1
		ENDIF

		IF USED("Ttipo")
		   USE IN "Ttipo"
		ENDIF


		IF ThisForm.Tipo_Reporte=1

		   IF !EMPTY(NVL(ThisForm.Cristal.Filtro,''))
		       Oapp.Cadena_Reporte=ThisForm.Cristal.Filtro   
		   ENDIF
		   

		   IF !FILE(UPPER(CURDIR()+"Reports\"+ALLTRIM(ThisForm.Cristal.Programa)+".FRT") )
		      MESSAGEBOX("NO EXISTE EL REPORTE: "+UPPER(CURDIR()+"Reports\"+ALLTRIM(ThisForm.Cristal.Programa)+".FRT"),16,ThisForm.Caption)
		      RETURN 
		   ENDIF
		   
		   lrep="Reporte Form "+CURDIR()+"Reports\"+ALLTRIM(ThisForm.Cristal.Programa)+" Preview Environment NoConsole "
		   &lrep
		   
		ENDIF
		&&&&&&&&&&&&&&&&&&&&&&&&&& Cristal Reporte
		IF ThisForm.Tipo_Reporte=2 
		   ThisForm.Cristal.ActivaReporte() 
		ENDIF
		Otbr.ActualizaOpciones() 
	ENDPROC


	PROCEDURE cargadatosfijos
	ENDPROC


	PROCEDURE ctnotroreportes.Refresh
		IF ThisForm.Mostras_otros_reportes 
			This.Visible = ( This.CmbOtrosReportes.ListCount>1 )
		ELSE
			This.Visible = .F.
		ENDIF

	ENDPROC


	PROCEDURE cmbotrosreportes.InteractiveChange
		ThisForm.Entorno.Programa = This.Value  
		ThisForm.Entorno.Titulo   = ALLTRIM(This.List[This.ListIndex,1])  
		ThisForm.CrISTAL.Tituloreporte = ThisForm.Entorno.Titulo  
		ThisForm.CrISTAL.Programa = ThisForm.Entorno.Programa 
		ThisForm.Caption = ThisForm.Entorno.Titulo
	ENDPROC


	PROCEDURE cmbotrosreportes.Init
		DODEFAULT()
		PRIVATE lexe,lalias
		DO CASE 
			CASE (ocnx.tipo_bd=1 OR ocnx.tipo_bd=4)
				lexe="SELECT s07_noms07,s07_codopc "+;
					 "FROM SYS_TABLA_OPCIONES_S07 "+;
					 "WHERE ISNULL(s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "	AND s07_codopc in ("+;
					 "		SELECT x.s07_codopc "+;
					 "		FROM SYS_MENU_MODULOS_S08 x "+;
					 "			INNER JOIN SYS_TABLA_OPCIONES_S07 y "+;
					 "			ON (y.s07_codopc=x.s07_codopc) "+;
					 "		WHERE LEN(ISNULL(x.s07_codopc,''))>0 "+;
					 "			AND x.s08_indest='1' "+;
					 "			AND Y.S09_TIPOPC in ('INFO','INFV') "+;
					 "			AND y.s07_indest='1' "+;
					 "			AND ISNULL(y.s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "UNION ALL "+;
					 "SELECT s07_codopc "+;
					 "FROM SYS_TABLA_OPCIONES_S07 "+;
					 "WHERE S09_TIPOPC in ('INFO','INFV') "+;
					 "	AND s07_indest='1' "+;
					 "	AND ISNULL(s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "	AND   s07_codopc not in "+; 
					 "		(SELECT x.s07_codopc "+;
					 " 		 FROM SYS_MENU_MODULOS_S08 x "+;
					 " 			INNER JOIN SYS_TABLA_OPCIONES_S07 y "+;
					 " 			ON (y.s07_codopc=x.s07_codopc) "+;
					 " 		 WHERE LEN(ISNULL(x.s07_codopc,''))>0 "+;
					 " 			AND x.s08_indest='1' "+;
					 " 			AND Y.S09_TIPOPC in ('INFO','INFV') "+;
				 	 " 			AND ISNULL(y.s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 " 			AND y.s07_indest='1') "+;
					 ") Order By 2 "
			CASE ocnx.tipo_bd=2
				lexe="SELECT s07_noms07,s07_codopc "+;
					 "FROM "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
					 "WHERE nvl(s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "	AND s07_codopc in ("+;
					 "		SELECT x.s07_codopc "+;
					 "		FROM "+Ocnx.Esquema+".SYS_MENU_MODULOS_S08 x "+;
					 "			INNER JOIN "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 y "+;
					 "			ON (y.s07_codopc=x.s07_codopc) "+;
					 "		WHERE Length(nvl(x.s07_codopc,''))>0 "+;
					 "			AND x.s08_indest='1' "+;
					 "			AND Y.S09_TIPOPC in ('INFO','INFV') "+;
					 "			AND y.s07_indest='1' "+;
					 "			AND NVL(y.s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "UNION ALL "+;
					 "SELECT s07_codopc "+;
					 "FROM "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 "+;
					 "WHERE S09_TIPOPC in ('INFO','INFV') "+;
					 "	AND s07_indest='1' "+;
					 "	AND NVL(s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 "	AND   s07_codopc not in "+; 
					 "		(SELECT x.s07_codopc "+;
					 " 		 FROM "+Ocnx.Esquema+".SYS_MENU_MODULOS_S08 x "+;
					 " 			INNER JOIN "+Ocnx.Esquema+".SYS_TABLA_OPCIONES_S07 y "+;
					 " 			ON (y.s07_codopc=x.s07_codopc) "+;
					 " 		 WHERE Length(nvl(x.s07_codopc,''))>0 "+;
					 " 			AND x.s08_indest='1' "+;
					 " 			AND Y.S09_TIPOPC in ('INFO','INFV') "+;
				 	 " 			AND NVL(y.s07_filtro,'')='"+NVL(ThisForm.Entorno.Programa_filtro,SPACE(13))+"' "+;
					 " 			AND y.s07_indest='1') "+;
					 ") Order By 2 "
			CASE ocnx.tipo_bd=3
		ENDCASE 
			 
		lalias=SYS(2015)
		IF SQLEXEC(Ocnx.Conexion,lexe,lalias)<0
			MESSAGEBOX(MESSAGE()+CHR(13)+CHR(13)+lexe,16,This.Name)
			RETURN .F.
		ENDIF
		This.RowSource = lalias
		This.BoundColumn = 2
		This.RowSourceType = 2
		This.Requery()
		This.Value = ThisForm.Entorno.Programa  
		This.Parent.Refresh()  
	ENDPROC


	PROCEDURE cmbotrosreportes.Destroy
		DODEFAULT()
		IF This.RowSourceType = 2 and USED(This.RowSource)
			PRIVATE lused
			IF USED(This.RowSource)
				lused="Use in '"+This.RowSource+"'"
				&lused
			ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: reporte
**************************************************


**************************************************
*-- Class:        marco (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Time Stamp:   08/14/06 11:59:09 AM
*
DEFINE CLASS marco AS shape


	Height = 75
	Width = 257
	BackStyle = 0
	BorderWidth = 1
	SpecialEffect = 0
	Name = "marco"


ENDDEFINE
*
*-- EndDefine: marco
**************************************************


**************************************************
*-- Class:        numerico (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Time Stamp:   08/14/06 11:59:10 AM
*
DEFINE CLASS numerico AS spinner


	FontName = "MS Sans Serif"
	FontSize = 9
	Height = 23
	Width = 121
	*-- .t. = utiliza en nombre del control para asociarlo al controlsource
	utilizanombre = .F.
	*-- nombre del objeto control de datos
	datoobjeto = ("")
	valor_anterior = 0
	Name = "numerico"


	*-- asocia la tabla al control (origen de datos. controlsource)
	PROCEDURE asociatabla
		PARAMETERS ldata

		IF !EMPTY(ldata)
		    Wcamp=""
		    IF UPPER(This.Class)="COMBO" or This.UtilizaNombre
		       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
		    ELSE       
		      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
			EndIf    
		    &Wcomm
			Wthis="This.ControlSource='"+Wcamp+"'"
			&Wthis
		ENDIF
	ENDPROC


	PROCEDURE LostFocus
		This.Valor_Anterior=This.Value
	ENDPROC


	PROCEDURE GotFocus
		This.Valor_Anterior=This.Value
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Init
		This.AsociaTabla(This.datoobjeto)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: numerico
**************************************************


**************************************************
*-- Class:        opciones (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  optiongroup
*-- BaseClass:    optiongroup
*-- Time Stamp:   12/15/06 10:48:13 AM
*
DEFINE CLASS opciones AS optiongroup


	ButtonCount = 2
	BackStyle = 0
	Value = 1
	Height = 46
	Width = 71
	nombreadicional = ("")
	utilizanombre = .F.
	almacenadato = ("")
	datoobjeto = ("")
	Name = "opciones"
	Option1.FontName = "MS Sans Serif"
	Option1.Caption = "Option1"
	Option1.Value = 1
	Option1.Height = 15
	Option1.Left = 5
	Option1.Top = 5
	Option1.Width = 55
	Option1.AutoSize = .T.
	Option1.Name = "Option1"
	Option2.FontName = "MS Sans Serif"
	Option2.Caption = "Option2"
	Option2.Height = 15
	Option2.Left = 5
	Option2.Top = 24
	Option2.Width = 55
	Option2.AutoSize = .T.
	Option2.Name = "Option2"


	*-- Asocia una Objeto Datos al este objeto
	PROCEDURE asociatabla
		PARAMETERS ldata

		PRIVATE lcarea,lcom
		IF !EMPTY(ldata) 
		    Wcamp=""
		    lcarea=SELECT()
		    lcom="!USED(ThisForm."+ALLTRIM(ldata)+".Alias)"
		    IF &lcom
		       lcom="ThisForm."+ALLTRIM(ldata)+".Init()"
		       &lcom
		    EndIf
		    SELECT (lcarea)
		    IF EMPTY(This.NombreAdicional) 
			    IF UPPER(This.Class)=="OPCIONES" or This.UtilizaNombre
			       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
			    ELSE       
			      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
				ENDIF
			ELSE
			   Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.NombreAdicional"
			ENDIF
			    
		    &Wcomm
			Wthis="This.ControlSource='"+Wcamp+"'"
			&Wthis
		EndIF
	ENDPROC


	PROCEDURE Init
		This.AsociaTabla(This.DatoObjeto)
		IF !EMPTY(This.ControlSource)
		   This.AlmacenaDato=This.ControlSource
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: opciones
**************************************************


**************************************************
*-- Class:        pagina (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  pageframe
*-- BaseClass:    pageframe
*-- Time Stamp:   12/17/07 03:51:00 PM
*
DEFINE CLASS pagina AS pageframe


	ErasePage = .T.
	PageCount = 2
	Width = 241
	Height = 169
	Name = "pagina"
	Page1.FontName = "MS Sans Serif"
	Page1.FontSize = 8
	Page1.Caption = "Generales"
	Page1.Name = "P1"
	Page2.FontName = "MS Sans Serif"
	Page2.FontSize = 8
	Page2.Caption = "Detalle"
	Page2.Name = "P2"
	DIMENSION caption_in[1]


	*-- En este metodo indique el titulo por idioma de cada pagina Ejem. Caption_In[2]="Detail"
	PROCEDURE configura_caption_idiomas
		IF TYPE("Ocnx")=="O"
		   IF !Ocnx.Idioma$"ES,CA"
		      IF EMPTY(This.Caption_In[1])
		         This.Caption_In[1]="Generals"
		      ENDIF
		     
		      IF EMPTY(This.Caption_In[2])
		         This.Caption_In[2]="Details"
		      ENDIF
		       
		   EndIf

		EndIf
	ENDPROC


	PROCEDURE Init
		This.AddProperty("Caption_In["+ALLTRIM(STR(This.PageCount))+"]")

		FOR lpag=1 TO This.PageCount
		    This.Caption_In[lpag]="" 
		ENDFor

		This.Configura_caption_idiomas() 

		PRIVATE lsen
		IF TYPE("Ocnx")=="O" AND ALLTRIM(UPPER(Ocnx.Idioma))<>ALLTRIM(UPPER(Oentorno.Idioma_Castellano))
			FOR lpag=1 TO This.PageCount
			    IF !EMPTY(This.Caption_In[lpag])
			       lsen="This.Pages["+ALLTRIM(STR(lpag))+"].Caption='"+This.Caption_In[lpag]+"'" 
			       &lsen
			    ENDIF
			ENDFOR
		ENDIF
	ENDPROC


	PROCEDURE P1.Activate
		This.Refresh()
	ENDPROC


	PROCEDURE P2.Activate
		This.Refresh()
	ENDPROC


	PROCEDURE caption_idioma
	ENDPROC


ENDDEFINE
*
*-- EndDefine: pagina
**************************************************


**************************************************
*-- Class:        texto (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   02/19/08 05:47:05 PM
*
DEFINE CLASS texto AS textbox


	FontName = "MS Sans Serif"
	FontSize = 8
	Format = "!"
	Height = 23
	Width = 100
	DisabledBackColor = RGB(255,255,255)
	DisabledForeColor = RGB(0,0,128)
	NullDisplay = (" ")
	*-- Escribe el nombre del objeto Dato que se va asociar a este contro Ejm: Datos1
	datoobjeto = ("")
	*-- Si el campo tuviese otro nombre lo escribe en  esta propiedad: Ejem: cct_codnac
	nombreadicional = ("")
	*-- En esta propiedad se almacena la Sentencia SQLSelect que se va a ejecutar para para buscar un registro. Si quiere definir la Sentencia Escribala en el Metodo AyudaPropiedades. Ejem. This.AyudaSQLSelect="Select ....
	ayudasqlselect = ("")
	*-- El Alias de la Tabla que tendra la tabla de Ayuda
	ayudaalias = ("")
	*-- Esta propiedad Muestra los campos que quiere Seleccionar para la ayuda.Eje: cli_codcli,cli_nomcli.  Esto fuciona si NO a utilizado la prodiedad AyudaSQLSelect
	ayudacampos = "*"
	*-- En esta propiedad escriba el Where que tendra la Tabla de Ayuda. Esto NO funciona si a utilizado la propiedad AyudaSQLSelect
	ayudawhere = ("")
	*-- En esta propiedad indique el Valor que la Ayuda tiene que devolver
	ayudavalor = ("")
	*-- Este Campo gurda el dato al cual Esta Asociado Este Control = ControlSource
	almacenadato = ("")
	programa = ("")
	ayudaindicedefault = 1
	*-- Define el Nombre del Formulario que quiere que aparesca para realizar la busqueda para la ayuda
	ayudaformulario = ("")
	*-- Si esta en .T. en la Ayuda de pondra en el dato Buscar el Dato segun lo vaya escribiendo
	ayuda_presiona_tecla = .T.
	*-- En esta variable puedes indicar que datos adicionales desea selecionar del la tabla de Ayuda Ejem: descri,precio,peso
	ayudalistacamposadicionales = ("")
	valor_retorno = ""
	Name = "texto"

	*-- Si es .T. significa que el campo pertenece a la Llave
	indicadorllave = .F.

	*-- Si esta en .T. significa que el campo pertenece a llave y es el final
	indicadorfinllave = .F.

	*-- Si esta en .T. obliga a que el campo tenga un valor en el Metodo Valid
	datoobligatorio = .F.

	*-- Si esta en .T. siempre usara la propiedad Name para asociarlo al Control Source
	utilizanombre = .F.

	*-- El Nombre de la Tabla en Base Datos que se utilizara para la Ayuda. Esto funciona si es que NO a utilizado la propiedad AyudaSQLSelect
	ayudanombretabla = .F.

	*-- Si esta .T. la Sentencia SQL Select solo se ejecutara una vez si ya Existe la tabla de Ayuda
	ayudaunavez = .F.

	*-- Si esta en .T. quiere decir que la Ayuda esta Activa
	ayudaactiva = .F.

	*-- Cuando Recibe el Foco Guarda el Valor del Que tenia Iniciamente
	valor_anterior = .F.

	*-- Si esta en .T. devolvera una Lista de Datos Seleccionados en la Propiedad AyudaValorLista
	ayudaindicadorlista = .F.

	*-- Guardara los Valores Devueltos cuando la propiedad AyudaIndicadorLista esta .T. (Verdadero)
	ayudavalorlista = .F.

	*-- Utilizar Matriz: This.AyudaTraslado.Parametros[n,n]
	ayudatraslado = .F.
	ayuda_valor_devuelto = .F.

	*-- Indices de la tabla de Ayuda
	DIMENSION ayudaindice[10,2]
	DIMENSION menu_popup[1,2]


	*-- Este metodo indica a que tabla esta asociado este objeto
	PROCEDURE asociatabla
		PARAMETERS ldata

		PRIVATE lcarea,lcom
		TRY
			IF !EMPTY(ldata) 
			    Wcamp=""
			    lcarea=SELECT()
			    lcom="!USED(ThisForm."+ALLTRIM(ldata)+".Alias)"
			    IF &lcom
			       lcom="ThisForm."+ALLTRIM(ldata)+".Init()"
			       &lcom
			    EndIf
			    SELECT (lcarea)
			    IF EMPTY(This.NombreAdicional) 
				    IF UPPER(This.Class)="TEXTO" or This.UtilizaNombre
				       Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Name"
				    ELSE       
				      Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.Class"
					ENDIF
				ELSE
				   Wcomm="Wcamp=ThisForm."+ALLTRIM(ldata)+".Alias+'.'+This.NombreAdicional"
				ENDIF
				    
			    &Wcomm
				Wthis="This.ControlSource='"+Wcamp+"'"
				&Wthis
			ENDIF
		CATCH TO lerror
				MESSAGEBOX(lerror.message+CHR(13)+MESSAGE(1),16,This.Name+"."+lerror.procedure) 
		ENDTRY

	ENDPROC


	PROCEDURE ayuda
		PRIVATE lvaloractual,lvaloranterior,lvayudacontinua
		lvayudacontinua=.T.
		TRY 
			IF TYPE("Otbr")=="O"
				Otbr.ActualizaOpciones()
			ENDIF

			This.Valor_Retorno = ""

			IF EMPTY(This.AyudaAlias) AND !TYPE(This.ControlSource)$"D,T" 
			   This.StatusBarText="Este Campo no tiene Ayuda"
			   lvayudacontinua=.F.
			ENDIF
			IF EMPTY(This.AyudaValor) AND !TYPE(This.ControlSource)$"D,T" 
			   This.StatusBarText="No se ha definido el Valor que va a devolver la Ayuda - Propiedad Ayuda Valor "
		 	   lvayudacontinua=.F.

			ENDIF

			IF lvayudacontinua
					This.Ayudatraslado = CREATEOBJECT("Traslado")

					Oindices=CREATEOBJECT("Indices")

					DIMENSION This.Ayudatraslado.Parametros[1]

					This.AyudaPropiedades() 
					Otraslado=CREATEOBJECT("Traslado")

					PRIVATE lxf,lxc,lfil,lcol
					lfil=ALEN(This.Ayudatraslado.Parametros,1)
					lcol=ALEN(This.Ayudatraslado.Parametros,2)
					IF lcol<>0
						DIMENSION Otraslado.Parametros[lfil,lcol]
						FOR lxf=1 TO lfil
							FOR lxc=1 TO lcol
								Otraslado.Parametros[lxf,lxc]=This.Ayudatraslado.Parametros[lxf,lxc]
							ENDFOR
						ENDFOR

					ELSE
						DIMENSION Otraslado.Parametros[lfil]
						FOR lxf=1 TO lfil
							Otraslado.Parametros[lxf]=This.Ayudatraslado.Parametros[lxf]
						ENDFOR
					ENDIF


					FOR ln=1 TO 10
						Oindices.Indice[ln,1]=This.AyudaIndice[ln,1]
						Oindices.Indice[ln,2]=This.AyudaIndice[ln,2]
					ENDFOR
					IF This.AyudaIndiceDefault>0 
					    Oindices.IndiceDefault=This.AyudaIndiceDefault 
					ENDIF


					IF EMPTY(This.AyudaNombreTabla)
					    This.AyudaNombreTabla=This.AyudaAlias
					ENDIF

					IF EMPTY(This.AyudaSqlSelect)
					   This.AyudaSqlSelect="Select "+ALLTRIM(This.Ayudacampos)+;
					                       " From "+ALLTRIM(This.AyudaNombreTabla)+;
					                       IIF(!EMPTY(This.Ayudawhere)," WHERE "+ALLTRIM(This.AyudaWhere),"")
					ENDIF

					This.AyudaActiva=.T.

					lvaloractual=This.Value
					lvaloranterior=This.Valor_Anterior 

					IF EMPTY(This.AyudaFormulario  )
						IF !TYPE(This.ControlSource)$"D,T" 
						   lruta=ThisForm.Entorno.Rutaosis+"Forms\Buscar"
						ELSE
						   lruta=ThisForm.Entorno.Rutaosis+"Forms\Calendario"
						ENDIF
					ELSE
					   lruta=ALLTRIM(UPPER(ThisForm.Entorno.Ruta+"Forms\"+This.AyudaFormulario))
					   IF !FILE(lruta+".SCT")
					      MESSAGEBOX("EL FORMULARIO DEFINIDO PARA LA AYUDA "+lruta+" NO EXISTE")
					      lvayudacontinua=.F.
					      &&RETURN .F. 
					   ENDIF
					   
					ENDIF
					IF lvayudacontinua
						lbusca_campo=IIF(EMPTY(NVL(lvaloractual,'')),.T.,.F.)

						lvalor=Null

						This.AyudaValorLista=.F.

						lindicadorlista=This.Ayudaindicadorlista 

						IF This.Ayudaindicadorlista 
							lindicadorlista=This.Ayudaindicadorlista 
							DEFINE POPUP xpopup SHORTCUT MARGIN FONT "Arial",12
							DEFINE BAR 1 OF xpopup  PROMPT '\<Un solo Registro'
							DEFINE BAR 2 OF xpopup  PROMPT '\<Varios Registros'

							ON SELECTION BAR 1 OF xpopup lindicadorlista=.F.
							ON SELECTION BAR 2 OF xpopup lindicadorlista=.T.

							ACTIVATE POPUP xpopup AT MROW() ,MCOL()
						ENDIF
					ENDIF
			ENDIF
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+lerror.details,16,This.Name+"."+lerror.procedure) 
			lvayudacontinua=.F.
		ENDTRY 

		IF !lvayudacontinua
			RETURN 
		ENDIF


		IF !TYPE(This.ControlSource)$"D,T" or !EMPTY(This.AyudaAlias)
		*!*	LPARAMETERS lpnombretabla,lalias,lpcampos,lcamposmuestra,ldevuelve,lpsqlselect,lpindices,;
		*!*	            lpunavez,lnroindice,lvaloractual,ltxt_busca_focus,ltxt_buscar_tecla,lcondi_pinta,;
		*!*	            lplista,lpcamposadicionales,lparticion,lptraslado as Custom 

			TRY 
				DO FORM &lruta WITH This.AyudaNombreTabla,;
				                    This.AyudaAlias,;
				                    This.Ayudacampos,;
				                    "",;
				                    This.AyudaValor ,;
				                    This.AyudaSqlSelect ,;
				                    Oindices,This.AyudaUnaVez,;
				                    '',;
				                    lvaloractual,;
				                    lbusca_campo,;
				                    This.Ayuda_Presiona_tecla,;
				                    .T.,  ;  
				                    lindicadorlista,;
				                    This.AyudaListaCamposAdicionales, ;
				                    .F.,;
				                    Otraslado ;
				                    TO lvalor
			 CATCH TO lerror
				MESSAGEBOX(lerror.message+CHR(13)+lerror.details,16,This.Name+"."+lerror.procedure) 
				lvayudacontinua=.F.
			 ENDTRY
			 IF !lvayudacontinua
			 	RETURN 
			 ENDIF
			 
		ELSE
			DO FORM &lruta WITH This.Value TO lvalor 
			IF EMPTY(lvalor) OR !TYPE("lvalor")$"T,D"
				RETURN 
			ENDIF

		ENDIF

		TRY 
			This.Valor_Anterior=lvaloranterior

			This.AyudaActiva=.F.

			IF !lindicadorlista
				This.Ayuda_valor_devuelto = lvalor    
				IF !ISNULL(lvalor) AND !This.ReadOnly
				    This.Value=lvalor    
				    This.Valid()
				ENDIF
			ELSE
				This.AyudaValorLista=lvalor
			ENDIF
			IF TYPE("This.AyudaValorLista")=="O" or !EMPTY(lvalor)
				This.Valor_Retorno = lvalor
				This.DepuesAyuda(This.AyudaValorLista)
			ENDIF
			This.Valor_Retorno = ""
		 CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+lerror.details,16,This.Name+"."+lerror.procedure) 
			lvayudacontinua=.F.
		 ENDTRY
	ENDPROC


	*-- Se ejecuta despues que selecciona el Valor o los Valores de la Ayuda
	PROCEDURE depuesayuda
		LPARAMETERS lp_obj
	ENDPROC


	PROCEDURE agrega_menu_popup
		LPARAMETERS lp_descripcion as String , lp_comando as String 

		IF PARAMETERS()<>0 AND TYPE("lp_descripcion")=="C" AND ;
			TYPE("lp_comando")=="C"

			PRIVATE lnumfil,lagrega
			lagrega=.F.
			lnumfil=ALEN(This.menu_popup,1) 

			IF lnumfil=1 
				IF !EMPTY(This.menu_popup[1,1])
					lagrega=.T.
				ENDIF
			ELSE
				lagrega=.T.
			ENDIF
			IF lagrega
				lnumfil=lnumfil+1
				DIMENSION This.menu_popup[lnumfil,2]
			ENDIF
			This.menu_popup[lnumfil,1]=lp_descripcion
			This.menu_popup[lnumfil,2]=lp_comando 
		ENDIF
	ENDPROC


	PROCEDURE RightClick
		PRIVATE lokayuda,lokarreglo,lobjeto
		lokayuda=.F.
		lokarreglo=.F.
		IF (!EMPTY(This.Ayudavalor)) OR TYPE(This.ControlSource)$"D,T" 
			lokayuda=.T.
		ENDIF
		PRIVATE lopmenu	,ldefbar ,lcol, ln

		ldefbar=""
		lobjeto=This    

		DIMENSION This.menu_popup[1,2]
		This.menu_popup[1,1]=""
		This.menu_popup[1,2]=""

		IF !This.Menu_popup_usuario() 
			RETURN 
		ENDIF

		IF !EMPTY(This.Menu_popup[1,1]) 
			lokarreglo=.T.
		ENDIF

		TRY 
			DIMENSION larray[2,4]
			larray[1,1]="\<Copiar"
			larray[1,2]=" _CLIPTEXT = lobjeto.SelText "
			larray[1,3]="ctrl+c"
			larray[1,4]="!lobjeto.SelLength>0 "
			larray[2,1]="Peg\<ar"
			larray[2,2]="SYS(1500, '_MED_PASTE', '_MEDIT')"
			larray[2,3]="ctrl+v"
			larray[2,4]=""

			IF lokayuda OR lokarreglo


				IF lokayuda
					lcol=ALEN(larray,1)
					lcol=lcol+2
					DIMENSION larray[lcol,4]
				    larray[lcol-1,1]="\-"
				    larray[lcol-1,2]=""
				    larray[lcol-1,3]=""
			   	    larray[lcol-1,4]=""
			    	    
				    larray[lcol,1]="\<Listado [F1]"
				    larray[lcol,2]="lobjeto.Ayuda()"
				    larray[lcol,3]=""
			   	    larray[lcol,4]=""
			    ENDIF
			    IF lokarreglo
					lcol=ALEN(larray,1)
					lcolant=lcol
					lcola=ALEN(This.Menu_popup,1)
					lcol=lcol+lcola+1

					DIMENSION larray[lcol,4]

				    larray[lcolant+1,1]="\-"
				    larray[lcolant+1,2]=""
				    larray[lcolant+1,3]=""
			   	    larray[lcolant+1,4]=""

					lcolarr=ALEN(This.Menu_popup,1)

					FOR ln=1 TO lcola
					    larray[lcolant+ln+1,1]=This.Menu_popup[ln,1]
					    larray[lcolant+ln+1,2]=This.Menu_popup[ln,2]
					    larray[lcolant+ln+1,3]=""
				   	    larray[lcolant+ln+1,3]=""
					ENDFOR 
			    ENDIF
			    
			    
			ENDIF

			lcol=ALEN(larray,1)
			IF lcol>0
				DEFINE POPUP TmenuCampo  SHORTCUT    MARGIN   FONT "Ms Sans Serif",9 
				FOR ln=1 TO lcol
					ldefbar="DEFINE BAR "+ALLTRIM(STR(ln))+" OF TmenuCampo PROMPT '"+larray[ln,1]+"' "+;
					IIF(!EMPTY(larray[ln,3]),"KEY '"+larray[ln,3]+"'","")+" "+;
					IIF(!EMPTY(larray[ln,4]),"SKIP FOR "+larray[ln,4],"")+" "

					&ldefbar
				ENDFOR
				FOR ln=1 TO lcol
					IF !EMPTY(larray[ln,2])
						ldefbar="ON SELECTION BAR "+ALLTRIM(STR(ln))+" OF TmenuCampo "+larray[ln,2]
					Endif
					&ldefbar
				ENDFOR
				ACTIVATE POPUP TmenuCampo AT MROW() ,MCOL()
			ENDIF
		CATCH TO lerror
			MESSAGEBOX(lerror.message+CHR(13)+lerror.details+CHR(13)+MESSAGE(1)+CHR(13)+ldefbar,16,This.Name+"."+lerror.procedure) 
		ENDTRY
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		Oapp.ErrorFormulario(This.Name,cMethod,MESSAGE(1),MESSAGE(),nLine)
	ENDPROC


	PROCEDURE Valid
		IF !This.AyudaActiva
			IF This.IndicadorLlave and This.IndicadorFinllave 
			   lcurdir=SELECT()
			   SELECT (ThisForm.Cursor.Area)
			   ldat = KEY()
		       lcon=ThisForm.LlaveControles
		       IF &lcon <> &ldat 
				   IF ThisForm.Estado<>1  
					   IF !EOF(ThisForm.Cursor.Area) AND !BOF(ThisForm.Cursor.Area)
						   lrec=RECNO(ThisForm.Cursor.Area)
						   IF !SEEK(&lcon,ThisForm.Cursor.Area)  
						   		L_CON=&lcon
						   		IF VARTYPE(l_con)='C'
						   			ls_con=L_CON
						   		ELSE
						   			ls_con= STR(L_CON,10)
						   		ENDIF 
						       	MESSAGEBOX("LLAVE "+NVL(ls_con ,"")+" NO HA SIDO ENCONTRADA ",16,"Busca LLave")   
						       	GO (lrec) IN (ThisForm.Cursor.Area)
						   ENDIF
					   ENDIF
					   ThisForm.Cabecera.Selecciona()
					   ThisForm.CargaTablas()
				   ELSE
					   IF !EOF(ThisForm.Cursor.Area) AND !BOF(ThisForm.Cursor.Area)
						   lrec=RECNO(ThisForm.Cursor.Area)
						   IF  SEEK(&lcon,ThisForm.Cursor.Area)  
						       GO (lrec) IN (ThisForm.Cursor.Area)
						       MESSAGEBOX("LLAVE "+NVL( &lcon ,"")+" YA EXISTE ",16,"Busca LLave")   
						       RETURN .F.
						   ENDIF
					       GO (lrec) IN (ThisForm.Cursor.Area)
					   ENDIF
				   ENDIF
			   ENDIF
			   SELECT (lcurdir)
		       ThisForm.Refresh()
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE LostFocus
		ON KEY LABEL ENTER
		SET HELP ON
		IF This.IndicadorLlave AND ThisForm.Estado<>1 
		   IF !EMPTY(This.AlmacenaDato)
			  This.ControlSource=This.AlmacenaDato
		      This.Refresh()
		   ENDIF
		EndIf  

		IF This.IndicadorLlave AND ThisForm.Estado=1 
		   IF EMPTY(This.ControlSource) AND !EMPTY(This.AlmacenaDato)
			  This.ControlSource=This.AlmacenaDato
		      This.Refresh()
		   ENDIF
		EndIf  
	ENDPROC


	PROCEDURE GotFocus
		IF !This.AyudaActiva 
			This.Valor_Anterior=This.Value 
		ENDIF

		IF !EMPTY(This.ControlSource)
			This.AlmacenaDato=This.ControlSource 
		ENDIF


		IF This.IndicadorLlave AND ThisForm.Estado<>1
		   IF !EMPTY(This.ControlSource)
			  lxcam=This.ControlSource
			  lxval=&lxcam
		      This.ControlSource="" 
		      This.Value=lxval
		   ENDIF
		EndIf  

		IF !EMPTY(This.AyudaAlias) OR TYPE(This.ControlSource)$"D,T" 
		   SET HELP OFF
		ENDIF
		 
		IF EMPTY(This.ControlSource) AND !EMPTY(This.AlmacenaDato) AND ThisForm.Estado<>1
		   This.ControlSource=This.AlmacenaDato 
		ENDIF
	ENDPROC


	PROCEDURE DblClick
		This.Ayuda()
	ENDPROC


	PROCEDURE Refresh
		IF This.Indicadorllave
		   IF ThisForm.Estado=1
		      This.ForeColor=128
		   ELSE
		   	  This.ForeColor=16711680
		   ENDIF
		   IF !EMPTY(This.AlmacenaDato) AND EMPTY(This.ControlSource) 
			   lalm=This.AlmacenaDato 
			   This.Value=&lalm
		   ENDIF
		EndIf

		IF ThisForm.Estado=1 AND EMPTY(This.ControlSource) AND !EMPTY(This.AlmacenaDato)
		   This.ControlSource=This.AlmacenaDato
		ENDIF
	ENDPROC


	PROCEDURE Init
		IF This.Indicadorllave
		   This.Format=ALLTRIM(This.Format)+"K"
		EndIf
		This.AsociaTabla(This.DatoObjeto)
		IF !EMPTY(This.ControlSource)
		   This.AlmacenaDato=This.ControlSource
		ENDIF
		*!*	IF !This.Enabled
		*!*	    This.FontUnderline = .F.
		*!*	    This.BackStyle = 1
		*!*	    This.BorderStyle = 1
		*!*	EndIf 
	ENDPROC


	PROCEDURE KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl
		If nKeyCode=28 
		&&   WAIT WINDOW STR(nKeyCode) NoWait
		   This.DblClick()
		Endif
	ENDPROC


	*-- En esta propiedad defina las propiedades AyudaSQLSelect y AyudaIndice
	PROCEDURE ayudapropiedades
	ENDPROC


	PROCEDURE menu_popup_usuario
	ENDPROC


ENDDEFINE
*
*-- EndDefine: texto
**************************************************


**************************************************
*-- Class:        texto_busca (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  texto (k:\aplvfp\libs\claseosis.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/04/07 11:39:10 AM
*
DEFINE CLASS texto_busca AS texto


	BorderStyle = 0
	Format = ""
	Margin = 0
	Name = "texto_busca"


	PROCEDURE KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl

		IF nKeyCode=13
			This.DblClick() 
		ENDIF
	ENDPROC


	PROCEDURE DblClick
		ThisForm.BotonGrupo.Cmb_Aceptar.Click()   
	ENDPROC


ENDDEFINE
*
*-- EndDefine: texto_busca
**************************************************


**************************************************
*-- Class:        traslado (k:\aplvfp\libs\claseosis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/20/04 12:37:12 PM
*
DEFINE CLASS traslado AS custom


	*-- Cantidad de Items que Exiten en el Arreglo
	items = 0
	estado = 0
	Name = "traslado"

	*-- Arreglo donde se almacenan los Valores trasladados
	DIMENSION itemslista[1]
	DIMENSION parametros[10]


ENDDEFINE
*
*-- EndDefine: traslado
**************************************************
