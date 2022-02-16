**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\admgral.vcx
**************************************************


**************************************************
*-- Class:        cmdaceptar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/15/09 12:07:03 AM
*
DEFINE CLASS cmdaceptar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\button_ok.bmp"
	DisabledPicture = "..\..\grafgen\iconos\aceptar_disable.bmp"
	Caption = "\<Aceptar"
	Enabled = .T.
	Style = 0
	ToolTipText = "Aceptar"
	SpecialEffect = 0
	PicturePosition = 14
	Name = "cmdaceptar"


ENDDEFINE
*
*-- EndDefine: cmdaceptar
**************************************************


**************************************************
*-- Class:        cmdanalisis (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:50:11 PM
*
DEFINE CLASS cmdanalisis AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\analisis.bmp"
	DisabledPicture = "..\..\grafgen\iconos\anular_disable.bmp"
	Caption = "\<Análisis"
	ToolTipText = "Asociar Imagen"
	PicturePosition = 7
	Name = "cmdanalisis"


	PROCEDURE Click
		thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdanalisis
**************************************************


**************************************************
*-- Class:        cmdanular (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 01:07:14 PM
*
DEFINE CLASS cmdanular AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\anular.ico"
	DisabledPicture = "..\..\grafgen\iconos\anular_disable.bmp"
	Caption = "\<Anular"
	Enabled = .T.
	ToolTipText = "Anular registro"
	PicturePosition = 14
	Name = "cmdanular"


	PROCEDURE Click
		thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdanular
**************************************************


**************************************************
*-- Class:        cmdasociar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:51:07 PM
*
DEFINE CLASS cmdasociar AS base_command


	Height = 40
	Width = 48
	Picture = "..\..\grafgen\iconos\imagen.bmp"
	DisabledPicture = "..\..\..\grafgen\iconos\imagen_disable.bmp"
	Caption = "\<Asociar"
	PicturePosition = 7
	*-- Almacena el Nombre de la Columna a donde se dirigira la imagen
	cnombrecolumna = ""
	*-- Almacena el nombre de la Entidad a la cual se asociará la imagen, trabaja conjuntamente con la propiedad cNombreColumna
	cnombreentidad = ""
	*-- Cadena que contiene los campos que identifican la clave primaria de cNombreEntidad
	ccamposfiltro = ""
	*-- Cadena que almacena los valores de cCamposFiltro 1 a 1.
	cvaloresfiltro = ""
	codigoboton = ('00002604')
	Name = "cmdasociar"


	PROCEDURE Click
		DO FORM admgen3_grabarimagenusuario.scx WITH THIS
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdasociar
**************************************************


**************************************************
*-- Class:        cmdatributos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:51:10 PM
*
DEFINE CLASS cmdatributos AS cmdbase


	Height = 40
	Width = 47
	Picture = "..\..\grafgen\iconos\atributos.bmp"
	DisabledPicture = "..\..\grafgen\iconos\atributos_disable.bmp"
	Caption = "Atributos"
	PicturePosition = 7
	Name = "cmdatributos"


ENDDEFINE
*
*-- EndDefine: cmdatributos
**************************************************


**************************************************
*-- Class:        cmdavance (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:52:00 PM
*
DEFINE CLASS cmdavance AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\avance.bmp"
	DisabledPicture = "..\..\grafgen\iconos\avance_disable.bmp"
	Caption = "\<Avance"
	PicturePosition = 7
	Name = "cmdavance"


ENDDEFINE
*
*-- EndDefine: cmdavance
**************************************************


**************************************************
*-- Class:        cmdbuscar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   07/05/10 10:02:01 AM
*-- buscar elemento de cabecera
*
DEFINE CLASS cmdbuscar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\find.bmp"
	DisabledPicture = "..\..\grafgen\iconos\buscar_disable.bmp"
	Caption = "\<Buscar"
	Enabled = .T.
	ToolTipText = "Buscar elemento"
	PicturePosition = 14
	Name = "cmdbuscar"
	xreturn = .F.


	PROCEDURE Click
		thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdbuscar
**************************************************


**************************************************
*-- Class:        cmdcancelar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/15/09 12:05:13 AM
*-- cancelar cambios efectuados
*
DEFINE CLASS cmdcancelar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\button_cancel.bmp"
	DisabledPicture = "..\..\grafgen\iconos\button_cancel_disable.bmp"
	Caption = "\<Cancelar"
	Enabled = .T.
	ToolTipText = "Ignorar cambios"
	SpecialEffect = 0
	PicturePosition = 14
	Name = "cmdcancelar"


	PROCEDURE Init
		NODEFAULT
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdcancelar
**************************************************


**************************************************
*-- Class:        cmdcomentarios (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 12:57:06 PM
*
DEFINE CLASS cmdcomentarios AS cmdbase


	Height = 40
	FontSize = 7
	Picture = "..\..\grafgen\iconos\comentarios.ico"
	DisabledPicture = "..\..\grafgen\iconos\comentarios_disable.bmp"
	Caption = "Comentarios"
	ToolTipText = "Comentarios"
	PicturePosition = 14
	*-- Es el ID de la tabla MComentarios
	idcomentario = ("")
	Name = "cmdcomentarios"


	PROCEDURE Click
		LOCAL lcAlias
		lcAlias = ALIAS()

		DO FORM ClaGen2_MComentarios WITH THIS.IDComentario 

		IF !EMPTY(lcAlias)
			SELECT(lcAlias)
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdcomentarios
**************************************************


**************************************************
*-- Class:        cmdcostos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:53:04 PM
*
DEFINE CLASS cmdcostos AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\costeo.bmp"
	DisabledPicture = "..\..\grafgen\iconos\costeo_disable.bmp"
	Caption = "\<Costeo"
	Enabled = .T.
	PicturePosition = 7
	Name = "cmdcostos"


ENDDEFINE
*
*-- EndDefine: cmdcostos
**************************************************


**************************************************
*-- Class:        cmddetalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:53:10 PM
*
DEFINE CLASS cmddetalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\detalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\detalle_disable.bmp"
	Caption = "\<Detalle"
	ToolTipText = ""
	PicturePosition = 7
	Name = "cmddetalle"


ENDDEFINE
*
*-- EndDefine: cmddetalle
**************************************************


**************************************************
*-- Class:        cmdeliminar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 03:41:07 PM
*-- eliminar elemento de cabecera
*
DEFINE CLASS cmdeliminar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\eliminar.ico"
	DisabledPicture = "..\..\grafgen\iconos\eliminar_disable.bmp"
	Caption = "\<Eliminar"
	ToolTipText = "Eliminar registro"
	PicturePosition = 14
	Name = "cmdeliminar"


	PROCEDURE activado
		LsProceso=thisform.Name+'_Eliminar'
		IF HasAccess(LsProceso)
			RETURN .T.
		ELSE
			MESSAGEBOX('Acceso denegado / Access denied',0+16,'ATENCION!!! / WARNING !!!')
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdeliminar
**************************************************


**************************************************
*-- Class:        cmdeliminar_detalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:54:02 PM
*-- eliminar elemento de detalle
*
DEFINE CLASS cmdeliminar_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\eliminardetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\eliminardetalle_disable.bmp"
	Caption = "\<Eliminar"
	PicturePosition = 7
	Name = "cmdeliminar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdeliminar_detalle
**************************************************


**************************************************
*-- Class:        cmdft (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:54:05 PM
*
DEFINE CLASS cmdft AS cmdbase


	Height = 40
	Width = 84
	Picture = "..\..\grafgen\iconos\reports.bmp"
	Caption = "Ficha Técnica"
	PicturePosition = 7
	Name = "cmdft"


ENDDEFINE
*
*-- EndDefine: cmdft
**************************************************


**************************************************
*-- Class:        cmdgrabar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 01:31:03 PM
*-- guardar cambios efectuados
*
DEFINE CLASS cmdgrabar AS cmdbase


	Height = 46
	Width = 46
	Picture = "..\..\grafgen\iconos\grabar.ico"
	DisabledPicture = "..\..\grafgen\iconos\vista\common\ico\24x24\save_green_24_d.ico"
	Caption = "\<Grabar"
	Enabled = .T.
	ToolTipText = "Grabar cambios"
	PicturePosition = 14
	Name = "cmdgrabar"


	PROCEDURE activado
		DO CASE
			CASE Thisform.xReturn='A'
				LsProceso=thisform.Name+'_Modificar'
			CASE Thisform.xReturn='I'
				LsProceso=thisform.Name+'_Adicionar'
			CASE Thisform.xReturn='E'
				LsProceso=thisform.Name+'_Eliminar'
		ENDCASE
		IF HasAccess(LsProceso)
			** Pide Password ** 
			IF INLIST(Thisform.xReturn,'A','E') AND HasAccess('PideClaveTransaccion') AND UPPER(TRIM(goentorno.user.groupname))<>'MASTER'
				LsPassOK = .f.
				DO FORM adm_PideClaveTransaccion TO LsPassOK
				IF !LsPassOK
					MESSAGEBOX('Clave de acceso a transaccion errada / Wrong access transaction password',0+16,'ATENCION!!! / WARNING !!!')
					RETURN .F.
				ENDIF
			ENDIF
			RETURN .T.
		ELSE
			MESSAGEBOX('Acceso denegado / Access denied',0+16,'ATENCION!!! / WARNING !!!')
			RETURN .F.
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdgrabar
**************************************************


**************************************************
*-- Class:        cmdimagen (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:54:13 PM
*
DEFINE CLASS cmdimagen AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\imagen.bmp"
	DisabledPicture = "..\..\grafgen\iconos\imagen_disable.bmp"
	Caption = "\<Imagen"
	WhatsThisHelpID = 0
	ToolTipText = "Ver imagen"
	PicturePosition = 7
	cnombrecolumna = ""
	cnombreentidad = ""
	ccamposfiltro = ""
	codigoboton = ('00002603')
	Name = "cmdimagen"
	cvaloresfiltro = .F.


	PROCEDURE Click
		DO FORM admgen3_consultarimagen.scx WITH THIS
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdimagen
**************************************************


**************************************************
*-- Class:        cmdimportar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 01:56:10 PM
*
DEFINE CLASS cmdimportar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\importar.ico"
	DisabledPicture = "..\..\grafgen\iconos\importar_disable.bmp"
	Caption = "\<Importar"
	ToolTipText = "Importar"
	PicturePosition = 14
	Name = "cmdimportar"


ENDDEFINE
*
*-- EndDefine: cmdimportar
**************************************************


**************************************************
*-- Class:        cmdimprimir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/18 10:24:12 AM
*-- imprimir reportes, etiquetas etc.
*
DEFINE CLASS cmdimprimir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\printer1.bmp"
	DisabledPicture = "..\..\grafgen\iconos\printer_off.bmp"
	Caption = "\<Imprimir"
	Enabled = .T.
	Style = 0
	ToolTipText = "Imprimir, ver en pantalla, exportar a otros formatos (excel, pdf, txt, csv)"
	SpecialEffect = 0
	PicturePosition = 14
	ColorSource = 4
	Name = "cmdimprimir"


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdimprimir
**************************************************


**************************************************
*-- Class:        cmdinicio (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/25/10 02:58:14 AM
*
DEFINE CLASS cmdinicio AS cmdbase


	Picture = "..\..\grafgen\iconos\crystallized\home.ico"
	DisabledPicture = "..\..\grafgen\iconos\crystallized\home_disable.ico"
	Caption = "Inicio"
	ToolTipText = "Comenzar de nuevo"
	PicturePosition = 14
	Name = "cmdinicio"


ENDDEFINE
*
*-- EndDefine: cmdinicio
**************************************************


**************************************************
*-- Class:        cmdmail (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:55:11 PM
*
DEFINE CLASS cmdmail AS cmdbase


	Height = 40
	WordWrap = .T.
	Picture = "..\..\grafgen\iconos\mail.bmp"
	DisabledPicture = "..\..\grafgen\iconos\mail_disable.bmp"
	Caption = "Enviar"
	Enabled = .T.
	PicturePosition = 7
	Name = "cmdmail"


ENDDEFINE
*
*-- EndDefine: cmdmail
**************************************************


**************************************************
*-- Class:        cmdmodificar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/20/16 09:38:01 AM
*-- modificar elementos de cabecera
*
DEFINE CLASS cmdmodificar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\modificar.ico"
	DisabledPicture = "..\..\grafgen\iconos\modificar_disable.bmp"
	Caption = "\<Modificar"
	Enabled = .T.
	ToolTipText = "Modificar registro"
	PicturePosition = 14
	Name = "cmdmodificar"


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


	PROCEDURE activado
		LsProceso1=thisform.Name+'_Modificar'
		LsProceso2=thisform.Name+'_Consultar'
		IF HasAccess(LsProceso1) && OR HasAccess(LsProceso2)
			RETURN .T.
		ELSE
			MESSAGEBOX('Acceso denegado / Access denied',0+16,'ATENCION!!! / WARNING !!!')
			RETURN .F.
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdmodificar
**************************************************


**************************************************
*-- Class:        cmdmodificar_detalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 02:21:02 PM
*-- modificar elemento de detalle
*
DEFINE CLASS cmdmodificar_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\modificardetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\modificardetalle_disable.bmp"
	Caption = "Modificar"
	ToolTipText = "Modificar registro del detalle"
	PicturePosition = 14
	Name = "cmdmodificar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdmodificar_detalle
**************************************************


**************************************************
*-- Class:        cmdnuevo (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 03:46:06 PM
*-- nuevo elemento de cabecera
*
DEFINE CLASS cmdnuevo AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\nuevo.ico"
	DisabledPicture = "..\..\grafgen\iconos\nuevo_disable.bmp"
	Caption = "\<Adicionar"
	ToolTipText = "Añadir nuevo registro"
	PicturePosition = 14
	Name = "cmdnuevo"


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdnuevo
**************************************************


**************************************************
*-- Class:        cmdnuevo_detalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 07:56:12 PM
*-- nuevo elemento de detalle
*
DEFINE CLASS cmdnuevo_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\nuevodetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\nuevodetalle_disable.bmp"
	Caption = "\<Adicionar"
	PicturePosition = 7
	Name = "cmdnuevo_detalle"


ENDDEFINE
*
*-- EndDefine: cmdnuevo_detalle
**************************************************


**************************************************
*-- Class:        cmdpreview (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/22/09 02:18:05 PM
*
DEFINE CLASS cmdpreview AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\lcd-monitor.bmp"
	Caption = "\<Pantalla"
	ToolTipText = "Vista previa"
	PicturePosition = 14
	Name = "cmdpreview"


	PROCEDURE Init
		NODEFAULT
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdpreview
**************************************************


**************************************************
*-- Class:        cmdprocesar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 04:21:05 PM
*
DEFINE CLASS cmdprocesar AS cmdbase


	Height = 57
	Width = 55
	Picture = "..\..\grafgen\iconos\proceso3.ico"
	DisabledPicture = "..\..\grafgen\iconos\proceso2.ico"
	Caption = "\<Procesar"
	ToolTipText = "Procesar"
	PicturePosition = 14
	Name = "cmdprocesar"


ENDDEFINE
*
*-- EndDefine: cmdprocesar
**************************************************


**************************************************
*-- Class:        cmdrecursos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 04:25:03 PM
*
DEFINE CLASS cmdrecursos AS cmdbase


	Height = 48
	Width = 56
	Picture = "..\..\grafgen\iconos\libreria.ico"
	Caption = "Recursos "
	ToolTipText = "Recursos"
	PicturePosition = 14
	Name = "cmdrecursos"


ENDDEFINE
*
*-- EndDefine: cmdrecursos
**************************************************


**************************************************
*-- Class:        cmdrefrescar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 04:29:13 PM
*
DEFINE CLASS cmdrefrescar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\refrescar.ico"
	DisabledPicture = "..\..\grafgen\iconos\refrescar_disable.bmp"
	Caption = "Refrescar"
	ToolTipText = "Refrescar"
	PicturePosition = 14
	Name = "cmdrefrescar"


ENDDEFINE
*
*-- EndDefine: cmdrefrescar
**************************************************


**************************************************
*-- Class:        cmdreqinsumos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 04:32:08 PM
*
DEFINE CLASS cmdreqinsumos AS cmdbase


	Height = 40
	Width = 82
	Picture = "..\..\grafgen\fondos\library.bmp"
	Caption = "\<Req. de Insumos"
	ToolTipText = "Requisicion de insumos"
	PicturePosition = 14
	Name = "cmdreqinsumos"


ENDDEFINE
*
*-- EndDefine: cmdreqinsumos
**************************************************


**************************************************
*-- Class:        cmdrevertir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 08:13:13 PM
*
DEFINE CLASS cmdrevertir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\revertir.bmp"
	DisabledPicture = "..\..\grafgen\iconos\revertir_disable.bmp"
	Caption = "\<Revertir"
	PicturePosition = 7
	Name = "cmdrevertir"


ENDDEFINE
*
*-- EndDefine: cmdrevertir
**************************************************


**************************************************
*-- Class:        cmdsalir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/10 04:47:04 PM
*
DEFINE CLASS cmdsalir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\salir.ico"
	DisabledPicture = "..\..\..\grafgen\iconos\close_disable.bmp"
	Caption = "\<Salir"
	Enabled = .T.
	ToolTipText = "Salir"
	PicturePosition = 14
	Name = "cmdsalir"


	PROCEDURE Click
		THISFORM.RELEASE()
	ENDPROC


	PROCEDURE Init
		NODEFAULT
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdsalir
**************************************************


**************************************************
*-- Class:        cmdtallacolor (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 08:14:10 PM
*
DEFINE CLASS cmdtallacolor AS cmdbase


	Height = 40
	FontSize = 7
	Picture = "..\..\grafgen\iconos\tallacolor.bmp"
	DisabledPicture = "..\..\grafgen\iconos\tallacolor_disable.bmp"
	Caption = "\<Talla Color"
	PicturePosition = 7
	Name = "cmdtallacolor"


ENDDEFINE
*
*-- EndDefine: cmdtallacolor
**************************************************


**************************************************
*-- Class:        cmdusuarios (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/27/06 08:14:13 PM
*
DEFINE CLASS cmdusuarios AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\login.bmp"
	DisabledPicture = "..\..\grafgen\iconos\login_disable.bmp"
	Caption = "Usuarios"
	Enabled = .T.
	PicturePosition = 7
	Name = "cmdusuarios"


ENDDEFINE
*
*-- EndDefine: cmdusuarios
**************************************************
