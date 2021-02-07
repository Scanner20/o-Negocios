**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\admgral.vcx
**************************************************


**************************************************
*-- Class:        cmdaceptar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:50:01 AM
*
DEFINE CLASS cmdaceptar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\aceptar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\aceptar_disable.bmp"
	Caption = "\<Aceptar"
	Name = "cmdaceptar"


ENDDEFINE
*
*-- EndDefine: cmdaceptar
**************************************************


**************************************************
*-- Class:        cmdanalisis (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:50:03 AM
*
DEFINE CLASS cmdanalisis AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\analisis.bmp"
	DisabledPicture = "..\..\grafgen\iconos\anular_disable.bmp"
	Caption = "\<Análisis"
	ToolTipText = "Asociar Imagen"
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
*-- Time Stamp:   12/12/05 07:50:05 AM
*
DEFINE CLASS cmdanular AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\anular.bmp"
	DisabledPicture = "..\..\grafgen\iconos\anular_disable.bmp"
	Caption = "\<Anular"
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
*-- Time Stamp:   12/12/05 07:50:07 AM
*
DEFINE CLASS cmdasociar AS base_command


	Height = 40
	Width = 48
	Picture = "..\..\grafgen\iconos\imagen.bmp"
	DisabledPicture = "..\..\..\grafgen\iconos\imagen_disable.bmp"
	Caption = "\<Asociar"
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
*-- Time Stamp:   12/12/05 07:50:10 AM
*
DEFINE CLASS cmdatributos AS cmdbase


	Height = 40
	Width = 47
	Picture = "..\..\grafgen\iconos\atributos.bmp"
	DisabledPicture = "..\..\grafgen\iconos\atributos_disable.bmp"
	Caption = "Atributos"
	Name = "cmdatributos"


ENDDEFINE
*
*-- EndDefine: cmdatributos
**************************************************


**************************************************
*-- Class:        cmdavance (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:50:11 AM
*
DEFINE CLASS cmdavance AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\avance.bmp"
	DisabledPicture = "..\..\grafgen\iconos\avance_disable.bmp"
	Caption = "\<Avance"
	Name = "cmdavance"


ENDDEFINE
*
*-- EndDefine: cmdavance
**************************************************


**************************************************
*-- Class:        cmdbuscar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:50:13 AM
*-- buscar elemento de cabecera
*
DEFINE CLASS cmdbuscar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\buscar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\buscar_disable.bmp"
	Caption = "\<Buscar"
	ToolTipText = "Buscar elemento"
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
*-- Time Stamp:   12/12/05 07:51:00 AM
*-- cancelar cambios efectuados
*
DEFINE CLASS cmdcancelar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\cancelar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\cancelar_disable.bmp"
	Caption = "\<Cancelar"
	ToolTipText = "Ignorar cambios"
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
*-- Time Stamp:   12/12/05 07:51:02 AM
*
DEFINE CLASS cmdcomentarios AS cmdbase


	Height = 40
	FontSize = 7
	Picture = "..\..\grafgen\iconos\comentarios.bmp"
	DisabledPicture = "..\..\grafgen\iconos\comentarios_disable.bmp"
	Caption = "Comentarios"
	ToolTipText = "Comentarios"
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
*-- Time Stamp:   12/12/05 07:51:05 AM
*
DEFINE CLASS cmdcostos AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\costeo.bmp"
	DisabledPicture = "..\..\grafgen\iconos\costeo_disable.bmp"
	Caption = "\<Costeo"
	Enabled = .T.
	Name = "cmdcostos"


ENDDEFINE
*
*-- EndDefine: cmdcostos
**************************************************


**************************************************
*-- Class:        cmddetalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:51:07 AM
*
DEFINE CLASS cmddetalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\detalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\detalle_disable.bmp"
	Caption = "\<Detalle"
	ToolTipText = ""
	Name = "cmddetalle"


ENDDEFINE
*
*-- EndDefine: cmddetalle
**************************************************


**************************************************
*-- Class:        cmdeliminar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:51:09 AM
*-- eliminar elemento de cabecera
*
DEFINE CLASS cmdeliminar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\eliminar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\eliminar_disable.bmp"
	Caption = "\<Eliminar"
	ToolTipText = "Eliminar elemento"
	Name = "cmdeliminar"


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
*-- Time Stamp:   12/12/05 07:51:11 AM
*-- eliminar elemento de detalle
*
DEFINE CLASS cmdeliminar_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\eliminardetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\eliminardetalle_disable.bmp"
	Caption = "\<Eliminar"
	Name = "cmdeliminar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdeliminar_detalle
**************************************************


**************************************************
*-- Class:        cmdft (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:51:14 AM
*
DEFINE CLASS cmdft AS cmdbase


	Height = 40
	Width = 84
	Picture = "..\..\grafgen\iconos\reports.bmp"
	Caption = "Ficha Técnica"
	Name = "cmdft"


ENDDEFINE
*
*-- EndDefine: cmdft
**************************************************


**************************************************
*-- Class:        cmdgrabar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/10/03 11:56:10 PM
*-- guardar cambios efectuados
*
DEFINE CLASS cmdgrabar AS cmdbase


	Height = 46
	Width = 46
	Picture = "..\..\grafgen\iconos\motif\alien floppy drive (3.5)16x16.bmp"
	DisabledPicture = "..\..\grafgen\iconos\grabar_disable.bmp"
	Caption = "\<Grabar"
	ToolTipText = "Grabar cambios"
	Name = "cmdgrabar"


ENDDEFINE
*
*-- EndDefine: cmdgrabar
**************************************************


**************************************************
*-- Class:        cmdimagen (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:52:03 AM
*
DEFINE CLASS cmdimagen AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\imagen.bmp"
	DisabledPicture = "..\..\grafgen\iconos\imagen_disable.bmp"
	Caption = "\<Imagen"
	WhatsThisHelpID = 0
	ToolTipText = "Ver imagen"
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
*-- Time Stamp:   12/12/05 07:52:05 AM
*
DEFINE CLASS cmdimportar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\importar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\importar_disable.bmp"
	Caption = "\<Importar"
	Name = "cmdimportar"


ENDDEFINE
*
*-- EndDefine: cmdimportar
**************************************************


**************************************************
*-- Class:        cmdimprimir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:52:07 AM
*-- imprimir reportes, etiquetas etc.
*
DEFINE CLASS cmdimprimir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\imprimir.bmp"
	DisabledPicture = "..\..\grafgen\iconos\imprimir_disable.bmp"
	Caption = "\<Imprimir"
	Name = "cmdimprimir"


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdimprimir
**************************************************


**************************************************
*-- Class:        cmdmail (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:52:09 AM
*
DEFINE CLASS cmdmail AS cmdbase


	Height = 40
	WordWrap = .T.
	Picture = "..\..\grafgen\iconos\mail.bmp"
	DisabledPicture = "..\..\grafgen\iconos\mail_disable.bmp"
	Caption = "Enviar"
	Enabled = .T.
	Name = "cmdmail"


ENDDEFINE
*
*-- EndDefine: cmdmail
**************************************************


**************************************************
*-- Class:        cmdmodificar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:52:11 AM
*-- modificar elementos de cabecera
*
DEFINE CLASS cmdmodificar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\modificar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\modificar_disable.bmp"
	Caption = "\<Modificar"
	ToolTipText = "Modificar elemento"
	Name = "cmdmodificar"


	PROCEDURE Click
		*thisform.lcTipOpe = this.name
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdmodificar
**************************************************


**************************************************
*-- Class:        cmdmodificar_detalle (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:52:13 AM
*-- modificar elemento de detalle
*
DEFINE CLASS cmdmodificar_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\modificardetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\modificardetalle_disable.bmp"
	Caption = "Modificar"
	Name = "cmdmodificar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdmodificar_detalle
**************************************************


**************************************************
*-- Class:        cmdnuevo (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:00 AM
*-- nuevo elemento de cabecera
*
DEFINE CLASS cmdnuevo AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\nuevo.bmp"
	DisabledPicture = "..\..\grafgen\iconos\nuevo_disable.bmp"
	Caption = "\<Adicionar"
	ToolTipText = "Añadir nuevo elemento"
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
*-- Time Stamp:   12/12/05 07:53:01 AM
*-- nuevo elemento de detalle
*
DEFINE CLASS cmdnuevo_detalle AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\nuevodetalle.bmp"
	DisabledPicture = "..\..\grafgen\iconos\nuevodetalle_disable.bmp"
	Caption = "\<Adicionar"
	Name = "cmdnuevo_detalle"


ENDDEFINE
*
*-- EndDefine: cmdnuevo_detalle
**************************************************


**************************************************
*-- Class:        cmdpreview (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:03 AM
*
DEFINE CLASS cmdpreview AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\preview.bmp"
	Caption = "\<Pantalla"
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
*-- Time Stamp:   03/27/03 05:09:09 PM
*
DEFINE CLASS cmdprocesar AS cmdbase


	Height = 57
	Width = 55
	Picture = "..\..\grafgen\iconos\proceso2.ico"
	DisabledPicture = "..\..\grafgen\iconos\proceso2.ico"
	Caption = "\<Procesar"
	Name = "cmdprocesar"


ENDDEFINE
*
*-- EndDefine: cmdprocesar
**************************************************


**************************************************
*-- Class:        cmdrecursos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   05/08/00 10:29:12 AM
*
DEFINE CLASS cmdrecursos AS cmdbase


	Height = 48
	Width = 56
	Caption = "Recursos "
	Name = "cmdrecursos"


ENDDEFINE
*
*-- EndDefine: cmdrecursos
**************************************************


**************************************************
*-- Class:        cmdrefrescar (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:07 AM
*
DEFINE CLASS cmdrefrescar AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\refrescar.bmp"
	DisabledPicture = "..\..\grafgen\iconos\refrescar_disable.bmp"
	Caption = "Refrescar"
	Name = "cmdrefrescar"


ENDDEFINE
*
*-- EndDefine: cmdrefrescar
**************************************************


**************************************************
*-- Class:        cmdreqinsumos (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:09 AM
*
DEFINE CLASS cmdreqinsumos AS cmdbase


	Height = 40
	Width = 82
	Picture = "..\..\grafgen\fondos\library.bmp"
	Caption = "\<Req. de Insumos"
	Name = "cmdreqinsumos"


ENDDEFINE
*
*-- EndDefine: cmdreqinsumos
**************************************************


**************************************************
*-- Class:        cmdrevertir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:12 AM
*
DEFINE CLASS cmdrevertir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\revertir.bmp"
	DisabledPicture = "..\..\grafgen\iconos\revertir_disable.bmp"
	Caption = "\<Revertir"
	Name = "cmdrevertir"


ENDDEFINE
*
*-- EndDefine: cmdrevertir
**************************************************


**************************************************
*-- Class:        cmdsalir (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:53:14 AM
*
DEFINE CLASS cmdsalir AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\close.bmp"
	DisabledPicture = "..\..\..\grafgen\iconos\close_disable.bmp"
	Caption = "\<Salir"
	ToolTipText = "Salir"
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
*-- Time Stamp:   12/12/05 07:54:01 AM
*
DEFINE CLASS cmdtallacolor AS cmdbase


	Height = 40
	FontSize = 7
	Picture = "..\..\grafgen\iconos\tallacolor.bmp"
	DisabledPicture = "..\..\grafgen\iconos\tallacolor_disable.bmp"
	Caption = "\<Talla Color"
	Name = "cmdtallacolor"


ENDDEFINE
*
*-- EndDefine: cmdtallacolor
**************************************************


**************************************************
*-- Class:        cmdusuarios (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- ParentClass:  cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/12/05 07:54:03 AM
*
DEFINE CLASS cmdusuarios AS cmdbase


	Height = 40
	Picture = "..\..\grafgen\iconos\login.bmp"
	DisabledPicture = "..\..\grafgen\iconos\login_disable.bmp"
	Caption = "Usuarios"
	Enabled = .T.
	Name = "cmdusuarios"


ENDDEFINE
*
*-- EndDefine: cmdusuarios
**************************************************
