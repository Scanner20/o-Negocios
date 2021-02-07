**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\admtbar.vcx
**************************************************


**************************************************
*-- Class:        admgen_toolbar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   02/19/01 12:55:01 AM
*
DEFINE CLASS admgen_toolbar AS toolbar


	Caption = "Estándar_"
	Height = 33
	Left = 0
	Top = 0
	Width = 63
	Name = "admgen_toolbar"


	ADD OBJECT cmdimprimir AS cmdimprimir WITH ;
		Top = 5, ;
		Left = 5, ;
		Name = "cmdImprimir"


	ADD OBJECT separator1 AS separator WITH ;
		Top = 5, ;
		Left = 34, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator1"


	ADD OBJECT cmdsalir AS cmdsalir WITH ;
		Top = 5, ;
		Left = 34, ;
		Name = "cmdSalir"


	PROCEDURE cmdsalir.Click
		CLEAR EVENTS
	ENDPROC


ENDDEFINE
*
*-- EndDefine: admgen_toolbar
**************************************************


**************************************************
*-- Class:        base_cmdhelp (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   05/27/03 12:00:03 PM
*
DEFINE CLASS base_cmdhelp AS base_command


	Height = 24
	Width = 24
	Picture = "..\..\grafgen\iconos\help_dots.bmp"
	Caption = ""
	cvaloresfiltro = ("")
	*-- Cadena que contiene los campos de Filtro
	ccamposfiltro = ("")
	cnombreentidad = ("")
	ccamporetorno = ("")
	ccampovisualizacion = ("")
	cvalorvalida = ("")
	*-- Retorna la descripcion del registro escogido
	cvalordescripcion = ("")
	*-- Contiene la sentencia SQL generada por la clase
	csql = ("")
	*-- Contiene la sentencia WHERE generada por la clase
	cwhere = ("")
	ctituloayuda = "Ayuda de Códigos"
	caliascursor = (SYS(2015))
	cremotepathentidad = ("")
	*-- Indica si permite seleccionar multiples valores, un solo valor o un rango de valores
	cmodoobtenerdatos = "V"
	*-- Contiene la secuencia de codigos de los atributos
	csecuenciaatributos = ("")
	*-- Se ingresa sentencia para la Clausua WHERE en lenguaje SQL (incluir operador AND,OR)
	cwheresql = ("")
	Name = "base_cmdhelp"

	*-- Especifica si deja pasar valores en Blanco en un control Texto asociado al boton ayuda
	lvalidadato = .F.

	*-- Indica que tipo de Formulario se mostrará para la ayuda, con criterios o sin criterios
	lflagbusqueda = .F.
	DIMENSION acamposfiltro[1,1]
	DIMENSION avaloresfiltro[1,1]


	PROCEDURE chrtoarray
		*!*	Convertir una cadena en una matriz según sus separadores.
		LPARAMETERS  cCadena , cDelimitador , aMatrizSalida
		LOCAL N , aArray
		DIMENSION aArray[1]
		STORE SPACE(0) TO aArray
		EXTERNAL ARRAY aMatrizSalida

		cDelimitador  	= IIF( TYPE("cDelimitador")=="L" , "," , cDelimitador )
		cCadena 		= IIF( TYPE("cCadena")=="L", "", cCadena )
		cCadena 		= cCadena + cDelimitador

		DO WHILE .T.
			IF EMPTY( cCadena )
				EXIT
			ENDIF
			N = AT( cDelimitador, cCadena )
			IF N=1
				nLen = ALEN( aArray )
				DIMENSION aArray[nLen+1]
				aArray[nLen+1] = ""
			ELSE
				nLen = ALEN( aArray )
				DIMENSION aArray[nLen+1]
				aArray[nLen+1] = ALLTRIM(UPPER(LEFT( cCadena, N - 1 )))
			ENDIF
			cCadena = ALLTRIM(RIGHT( cCadena, LEN(cCadena) - N ))
		ENDDO
		IF ALEN(aArray)>1
			=ADEL(aArray,1)
			DIMENSION aArray( ALEN(aArray)-1 )
			DIMENSION aMatrizSalida( ALEN(aArray) )
			=ACOPY( aArray, aMatrizSalida )
		ENDIF
		RETURN
	ENDPROC


	PROCEDURE configurarparametros
		LPARAMETERS tcValorValida, tcNombreEntidad, tcCampoRetorno, tcCampoVisualizacion, ;
					tlValidaDato, tcCamposFiltro, tcValoresFiltro , tcModoObtenerDatos , ;
					tcSecuenciaAtributos
		LOCAL llReturn
		llReturn = .t.

		tcValorValida	= IIF(VARTYPE(tcValorValida)<>"C","",tcValorValida)

		IF ISNULL(tcModoObtenerDatos) OR EMPTY(tcModoObtenerDatos)
			tcModoObtenerDatos = "V"
		ENDIF
		IF ISNULL(tcSecuenciaAtributos) OR EMPTY(tcSecuenciaAtributos)
			tcSecuenciaAtributos= ""
		ENDIF

		IF ISNULL(tcValorValida) OR EMPTY(tcValorValida)
			tcValorValida = ""
		ENDIF

		IF ISNULL(tcNombreEntidad) OR EMPTY(tcNombreEntidad)
			tcNombreEntidad = ""
			llReturn = .f.
		ENDIF

		IF ISNULL(tcCampoRetorno) OR EMPTY(tcCampoRetorno)
			tcCampoRetorno = ""
			llReturn = .f.
		ENDIF

		IF ISNULL(tcCampoVisualizacion) OR EMPTY(tcCampoVisualizacion)
			tcCampoVisualizacion = ""
		ENDIF

		IF ISNULL(tlValidadato) OR EMPTY(tlValidaDato)
			tlValidaDato = .t.
		ENDIF
		IF ISNULL(tcCamposFiltro) OR EMPTY(tcCamposFiltro)
			tcCamposFiltro = ""
		ENDIF
		IF ISNULL(tcValoresFiltro) OR EMPTY(tcValoresFiltro)
			tcValoresFiltro = ""
		ENDIF


		WITH THIS
			IF !EMPTY(.cAliasCursor) AND USED(.cAliasCursor)
				USE IN (.cAliasCursor)
				THIS.cAliasCursor = ""
			ENDIF
			.cValorValida			= ALLTRIM(tcValorValida)
			.cValorDescripcion		= ""
			.cNombreEntidad 		= ALLTRIM(tcNombreEntidad)
			.cCampoRetorno			= ALLTRIM(tcCampoRetorno)
			.cCampoVisualizacion	= ALLTRIM(tcCampoVisualizacion)
			.lValidaDato 			= tlValidaDato
			.cCamposFiltro 			= ALLTRIM(tcCamposFiltro)
			.cValoresFiltro 		= ALLTRIM(tcValoresFiltro)
			.cModoObtenerDatos 		= tcModoObtenerDatos
			.cSecuenciaAtributos 	= tcSecuenciaAtributos
			IF EMPTY(.cAliasCursor)
				.cAliasCursor = SYS(2015)
			ENDIF
		*!*		.GenerarSQL()
		*!*		.GenerarWHERE()
		ENDWITH
		RETURN llReturn
	ENDPROC


	*-- Este metodo se encarga de validar el dato ingresado en un control text o una cualquier otro control
	PROCEDURE validardato
		LPARAMETERS tcValorValida, tlValidaDato

		tcValorValida = IIF(VARTYPE(tcValorValida)=='C',tcValorValida,'')

		LOCAL lnDataSessioID

		DO CASE
		CASE TYPE("THISFORM") == "O"
			lnDataSessionID = THISFORM.DataSessionId 
		CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
			lnDataSessionID = _SCREEN.ACTIVEFORM.DataSessionId 
		OTHERWISE
			lnDataSessionID	= 1
		ENDCASE


		IF LASTKEY() = 27 OR ( EMPTY(tcValorValida) AND !tlValidaDato )
			RETURN .T.
		ENDIF

		IF EMPTY(THIS.cAliasCursor)
			THIS.cAliasCursor = SYS(2015)
		ENDIF

		THIS.GenerarSQL()
		THIS.GenerarWHERE()

		THIS.cValorValida = ALLTRIM(tcValorValida)

		THIS.cSQL = THIS.cSQL + ;
			" WHERE LTRIM(RTRIM(T000." + THIS.cCampoRetorno + ")) = '" + THIS.cValorValida + "'" + ;
			" AND T000.FlagEliminado = 0 " + ;
			IIF(!EMPTY(THIS.cWhere)," AND " + THIS.cWhere , "")  + " " + THIS.cWhereSQL

		*=messagebox(THIS.cSQL )
		goConexion.cSQL = THIS.cSQL
		goConexion.cCursor = THIS.cAliasCursor
		lReturn = ( goConexion.DoSQL(lDataSessioId) > 0 )

		IF lReturn
			SELECT( THIS.cAliasCursor )
			cCampoRetorno = THIS.cCampoRetorno
			cCampoVisualizacion = THIS.cCampoVisualizacion
			LOCATE FOR ALLTRIM(&cCampoRetorno) == THIS.cValorValida
			IF FOUND() AND !EMPTY(cCampoVisualizacion)
				THIS.cValorDescripcion = EVAL(cCampoVisualizacion)
			ENDIF
			RETURN FOUND()
		ENDIF
		RETURN .F.
	ENDPROC


	*-- Genera cadena de sentencia SQL
	PROCEDURE generarsql
		LOCAL lFlagBusqueda

		cSQL	= ""

		IF !ISNULL(THIS.cRemotePathEntidad) OR !EMPTY(THIS.cRemotePathEntidad)
			Tn	 = " T000"
			cSQL =	" SELECT " + THIS.cCampoRetorno + ;
				IIF(EMPTY(THIS.cCampoVisualizacion),""," , " + THIS.cCampoVisualizacion ) + ;
				" FROM " + THIS.cRemotePathEntidad + Tn
		ENDIF

		THIS.cSQL = cSQL
		RETURN cSQL
	ENDPROC


	*-- Genera cadena de sentencia WHERE
	PROCEDURE generarwhere
		LOCAL lcCampo , lcValor
		SET STEP ON 
		IF !EMPTY( THIS.cCamposFiltro )
			cWhere = ""
			FOR i = 1 TO ALEN(THIS.aCamposFiltro)
				lcCampo = IIF(TYPE("THIS.aCamposFiltro[I]")=="C" ,THIS.aCamposFiltro[I] ,"")
				lcValor = IIF(TYPE("THIS.aValoresFiltro[I]")=="C",THIS.aValoresFiltro[I],"")
				IF !EMPTY(lcCampo) AND !EMPTY(lcValor)
					cWhere = cWhere + " T000." + lcCampo + " = '" + lcValor + "' AND "
				ENDIF
			ENDFOR
			THIS.cWhere = LEFT(cWhere, LEN(cWhere) - 5 )
		ELSE
			THIS.cWhere = ""
		ENDIF
		RETURN THIS.cWhere
	ENDPROC


	PROCEDURE cnombreentidad_assign
		LPARAMETERS tcNombreEntidad
		IF VARTYPE(tcNombreEntidad) <> "C"
			tcNombreEntidad	= ""
		ENDIF

		THIS.cNombreEntidad = ALLTRIM(tcNombreEntidad)

		IF !EMPTY( THIS.cNombreEntidad )
			THIS.cRemotePathEntidad	= goEntorno.RemotePathEntidad( THIS.cNombreEntidad ,, lFlagBusqueda )
			THIS.lFlagBusqueda		= lFlagBusqueda
		ENDIF
	ENDPROC


	*-- Convierte los codigo de la secuencia de atributos a nombres de campos validos para la sentencia SQL
	PROCEDURE generarsecuenciacampos
		LOCAL cAtributo , cAlias
		LOCAL laSecuencia
		DECLARE laSecuencia[1]
		cAlias = ALIAS()

		lcCamposFiltro = ""
		lcValoresFiltro = ""

		DIMENSION aCampos[1],aValores[1],aAtributos[1]
		IF !EMPTY(THIS.cSecuenciaAtributos)
			THIS.ChrToArray( THIS.cSecuenciaAtributos, ";" , @aAtributos)
			FOR I=1 TO ALEN(aAtributos)
				cAtributo = ALLTRIM(ALLTRIM(aAtributos[I]))
				SELECT(cAlias)
				lnRecno = RECNO()
				lcCampoValor = THIS.TAG
				LOCATE FOR CodigoAtributo == cAtributo
				lcNombreCampo= ALLTRIM(NombreCampo)
				lcValorCampo = EVAL(lcCampoValor)
				IF !EMPTY(lnRecno)
					GO lnRecno
				ENDIF
				IF FOUND()
					lcCamposFiltro	= lcCamposFiltro + lcNombreCampo + ";"
					lcValoresFiltro = lcValoresFiltro  + lcValorCampo + ";"
				ENDIF
			ENDFOR
		ENDIF

		THIS.cCamposFiltro = LEFT(lcCamposFiltro,LEN(lcCamposFiltro)-1)
		THIS.cValoresFiltro = LEFT(lcValoresFiltro,LEN(lcValoresFiltro)-1)
		SELECT(cAlias)
		RETURN .T.
	ENDPROC


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		IF VARTYPE(tcWhereSQL)<>"C"
			tcWhereSQL = ""
		ELSE
			tcWhereSQL = ALLTRIM(tcWhereSQL)
		ENDIF
		THIS.cWhereSQL= tcWhereSQL
	ENDPROC


	HIDDEN PROCEDURE ccamposfiltro_assign
		LPARAMETERS tcCamposFiltro

		tcCamposFiltro	= IIF( VARTYPE(tcCamposFiltro)<>"C" , "" , ALLTRIM(tcCamposFiltro) )
		THIS.cCamposFiltro	= tcCamposFiltro

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cCamposFiltro )
			THIS.ChrToArray( THIS.cCamposFiltro, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aCamposFiltro )
		ENDIF
		RETURN .T.
	ENDPROC


	HIDDEN PROCEDURE cvaloresfiltro_assign
		LPARAMETERS tcValoresFiltro

		tcValoresFiltro	= IIF( VARTYPE(tcValoresFiltro)<>"C" , "" , ALLTRIM(tcValoresFiltro) )
		THIS.cValoresFiltro	= tcValoresFiltro

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cValoresFiltro )
			THIS.ChrToArray( THIS.cValoresFiltro, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aValoresFiltro )
		ENDIF
		RETURN .T.
	ENDPROC


	PROCEDURE Click
		LOCAL loBoton
		loBoton	= THIS
		THIS.GenerarWHERE()
		DO CASE
			CASE THIS.cModoObtenerDatos = "V"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, loBoton
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, loBoton
				ENDIF
			CASE THIS.cModoObtenerDatos = "L"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, loBoton
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, loBoton
				ENDIF
			CASE THIS.cModoObtenerDatos = "R"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, loBoton
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, loBoton
				ENDIF
		ENDCASE
	ENDPROC


	PROCEDURE Init
		THIS.cCamposFiltro	= THIS.cCamposFiltro
		THIS.cValoresFiltro	= THIS.cValoresFiltro
	ENDPROC


	PROCEDURE validarparametros
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cmdhelp
**************************************************


**************************************************
*-- Class:        cmd_refresh (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/22/00 12:41:07 AM
*
DEFINE CLASS cmd_refresh AS cmd_base


	Picture = "..\..\..\..\graficosgenerales\iconos\refrescar.bmp"
	DisabledPicture = "h:\tdv\graficosgenerales\iconos\refrescar_disable.bmp"
	ToolTipText = "Refrescar"
	Name = "cmd_refresh"


ENDDEFINE
*
*-- EndDefine: cmd_refresh
**************************************************


**************************************************
*-- Class:        cmdaceptar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:33:02 PM
*
DEFINE CLASS cmdaceptar AS cmd_base


	Picture = "..\..\grafgen\iconos\aceptar.bmp"
	Name = "cmdaceptar"


	PROCEDURE Init
		NODEFAULT
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdaceptar
**************************************************


**************************************************
*-- Class:        cmdanalisis (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:34:13 PM
*
DEFINE CLASS cmdanalisis AS cmd_base


	Picture = "..\..\grafgen\iconos\analisis.bmp"
	DisabledPicture = "h:\tdv\graficosgenerales\iconos\analisis_disable.bmp"
	ToolTipText = "Análisis"
	Name = "cmdanalisis"


ENDDEFINE
*
*-- EndDefine: cmdanalisis
**************************************************


**************************************************
*-- Class:        cmdanular (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:36:04 PM
*
DEFINE CLASS cmdanular AS cmd_base


	Picture = "..\..\grafgen\iconos\anular.bmp"
	Name = "cmdanular"


ENDDEFINE
*
*-- EndDefine: cmdanular
**************************************************


**************************************************
*-- Class:        cmdavance (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:37:10 PM
*
DEFINE CLASS cmdavance AS cmd_base


	Picture = "..\..\grafgen\iconos\avance.bmp"
	Name = "cmdavance"


ENDDEFINE
*
*-- EndDefine: cmdavance
**************************************************


**************************************************
*-- Class:        cmdbuscar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:38:13 PM
*-- Buscar elemento de cabecera
*
DEFINE CLASS cmdbuscar AS cmd_base


	Picture = "..\..\grafgen\iconos\buscar.bmp"
	DisabledPicture = "..\..\..\"
	ToolTipText = "Buscar elemento"
	Name = "cmdbuscar"


ENDDEFINE
*
*-- EndDefine: cmdbuscar
**************************************************


**************************************************
*-- Class:        cmdcancelar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:39:14 PM
*-- cancelar cambios
*
DEFINE CLASS cmdcancelar AS cmd_base


	Picture = "..\..\grafgen\iconos\cancelar.bmp"
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
*-- Class:        cmdcomentarios (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmdcomentarios (k:\aplvfp\classgen\vcxs\admgral.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:40:13 PM
*
DEFINE CLASS cmdcomentarios AS cmdcomentarios


	Height = 24
	Width = 24
	Picture = "..\..\grafgen\iconos\comentarios.bmp"
	DisabledPicture = "h:\tdv\graficosgenerales\iconos\comentarios_disable.bmp"
	Caption = ""
	Name = "cmdcomentarios"


ENDDEFINE
*
*-- EndDefine: cmdcomentarios
**************************************************


**************************************************
*-- Class:        cmdcostos (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:41:12 PM
*
DEFINE CLASS cmdcostos AS cmd_base


	Picture = "..\..\grafgen\iconos\costeo.bmp"
	DisabledPicture = "..\..\..\"
	ToolTipText = "Costeo"
	Name = "cmdcostos"


ENDDEFINE
*
*-- EndDefine: cmdcostos
**************************************************


**************************************************
*-- Class:        cmddetalle (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:43:00 PM
*
DEFINE CLASS cmddetalle AS cmd_base


	Picture = "..\..\grafgen\iconos\detalle.bmp"
	Name = "cmddetalle"


ENDDEFINE
*
*-- EndDefine: cmddetalle
**************************************************


**************************************************
*-- Class:        cmdeliminar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:44:14 PM
*-- eliminar elemento de cabecera
*
DEFINE CLASS cmdeliminar AS cmd_base


	Picture = "..\..\grafgen\iconos\eliminar.bmp"
	ToolTipText = "Eliminar elemento"
	Name = "cmdeliminar"


ENDDEFINE
*
*-- EndDefine: cmdeliminar
**************************************************


**************************************************
*-- Class:        cmdeliminar_detalle (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:45:11 PM
*-- eliminar elemento de detalle
*
DEFINE CLASS cmdeliminar_detalle AS cmd_base


	Picture = "..\..\grafgen\iconos\eliminardetalle.bmp"
	ToolTipText = "Eliminar detalle"
	Name = "cmdeliminar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdeliminar_detalle
**************************************************


**************************************************
*-- Class:        cmdfind (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:47:04 PM
*-- boton busqueda rapida (binoculares)
*
DEFINE CLASS cmdfind AS cmd_base


	Picture = "..\..\grafgen\iconos\buscar16.bmp"
	ToolTipText = "Buscar"
	Name = "cmdfind"


ENDDEFINE
*
*-- EndDefine: cmdfind
**************************************************


**************************************************
*-- Class:        cmdgrabar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:48:10 PM
*-- grabar cambios
*
DEFINE CLASS cmdgrabar AS cmd_base


	Picture = "..\..\grafgen\iconos\grabar.bmp"
	ToolTipText = "Grabar cambios"
	Name = "cmdgrabar"


ENDDEFINE
*
*-- EndDefine: cmdgrabar
**************************************************


**************************************************
*-- Class:        cmdhelp (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:49:08 PM
*
DEFINE CLASS cmdhelp AS cmd_base


	Picture = "..\..\grafgen\iconos\help.bmp"
	DisabledPicture = "..\..\..\graficosgenerales\iconos\help_disable.bmp"
	ToolTipText = "Ayuda en Línea"
	Name = "cmdhelp"


	PROCEDURE Click
		LOCAL lcCodigoSistema , lcCodigoModulo , lcCodigoFormulario , lcFileHelp1 , lcFileHelp2

		lcCodigoSistema	= goEntorno.Sistema
		lcCodigoModulo	= goEntorno.Modulo
		lcCodigoFormulario	= ""

		IF TYPE("_SCREEN.ACTIVEFORM") == "O" AND TYPE("_SCREEN.ACTIVEFORM.CodigoFormulario")=="C"
			lcCodigoFormulario	= _SCREEN.ACTIVEFORM.CodigoFormulario
		ENDIF

		lcFileHelp1	= "H:\TDV\Ayudas\" + lcCodigoSistema + lcCodigoModulo + ".CHM" 
		lcFileHelp2	= "H:\TDV\Ayudas\" + lcCodigoSistema + ".CHM" 

		*=MESSAGEBOX("Archivo de Ayuda : " + lcFileHelp + CHR(13) + "Formulario : " + lcCodigoFormulario)

		SET HELP ON
		IF FILE(lcFileHelp1)
			SET HELP TO &lcFileHelp1
		ELSE
			IF FILE(lcFileHelp2)
				SET HELP TO &lcFileHelp2
			ELSE
				=MESSAGEBOX("No se puede hallar el archivo de ayuda para este Sistema")
				RETURN
			ENDIF
		ENDIF
		HELP
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdhelp
**************************************************


**************************************************
*-- Class:        cmdimagen (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:50:04 PM
*
DEFINE CLASS cmdimagen AS cmd_base


	Picture = "..\..\grafgen\iconos\imagen.bmp"
	ToolTipText = "Ver Imagen"
	Name = "cmdimagen"


ENDDEFINE
*
*-- EndDefine: cmdimagen
**************************************************


**************************************************
*-- Class:        cmdimprimir (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:50:13 PM
*-- imprimir reportes, etiquetas etc.
*
DEFINE CLASS cmdimprimir AS cmd_base


	Picture = "..\..\grafgen\iconos\imprimir.bmp"
	ToolTipText = "Imiprimir"
	Name = "cmdimprimir"


ENDDEFINE
*
*-- EndDefine: cmdimprimir
**************************************************


**************************************************
*-- Class:        cmdmodificar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:51:07 PM
*-- modificar elemento de cabecera
*
DEFINE CLASS cmdmodificar AS cmd_base


	Picture = "..\..\grafgen\iconos\modificar.bmp"
	ToolTipText = "Modificar elemento"
	Name = "cmdmodificar"


ENDDEFINE
*
*-- EndDefine: cmdmodificar
**************************************************


**************************************************
*-- Class:        cmdmodificar_detalle (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:52:05 PM
*-- modificar elemento de detalle
*
DEFINE CLASS cmdmodificar_detalle AS cmd_base


	Picture = "..\..\grafgen\iconos\modificardetalle.bmp"
	ToolTipText = "Modificar detalle"
	Name = "cmdmodificar_detalle"


ENDDEFINE
*
*-- EndDefine: cmdmodificar_detalle
**************************************************


**************************************************
*-- Class:        cmdnuevo (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:52:13 PM
*-- añadir nuevo elemento en cabecera
*
DEFINE CLASS cmdnuevo AS cmd_base


	Picture = "..\..\grafgen\iconos\nuevo.bmp"
	ToolTipText = "Nuevo elemento"
	Name = "cmdnuevo"


ENDDEFINE
*
*-- EndDefine: cmdnuevo
**************************************************


**************************************************
*-- Class:        cmdnuevo_detalle (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:53:12 PM
*-- añadir nuevo elemento en detalle
*
DEFINE CLASS cmdnuevo_detalle AS cmd_base


	Picture = "..\..\grafgen\iconos\nuevodetalle.bmp"
	ToolTipText = "Añadir detalle"
	Name = "cmdnuevo_detalle"


ENDDEFINE
*
*-- EndDefine: cmdnuevo_detalle
**************************************************


**************************************************
*-- Class:        cmdprocesar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/01/03 06:56:00 PM
*
DEFINE CLASS cmdprocesar AS cmd_base


	Picture = "..\..\grafgen\iconos\procesar.ico"
	Name = "cmdprocesar"


ENDDEFINE
*
*-- EndDefine: cmdprocesar
**************************************************


**************************************************
*-- Class:        cmdpuntos (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/22/00 12:38:08 AM
*
DEFINE CLASS cmdpuntos AS cmd_base


	Picture = "..\..\..\..\graficosgenerales\iconos\help_dots.bmp"
	Name = "cmdpuntos"


ENDDEFINE
*
*-- EndDefine: cmdpuntos
**************************************************


**************************************************
*-- Class:        cmdrevertir (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/22/00 12:39:06 AM
*
DEFINE CLASS cmdrevertir AS cmd_base


	Picture = "..\..\..\..\graficosgenerales\iconos\revertir.bmp"
	Name = "cmdrevertir"


ENDDEFINE
*
*-- EndDefine: cmdrevertir
**************************************************


**************************************************
*-- Class:        cmdsalir (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   06/09/00 06:07:03 PM
*
DEFINE CLASS cmdsalir AS cmd_base


	Picture = "..\..\..\..\graficosgenerales\iconos\close.bmp"
	Name = "cmdsalir"


	PROCEDURE Init
		NODEFAULT
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdsalir
**************************************************


**************************************************
*-- Class:        cmdtallacolor (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/22/00 12:40:13 AM
*
DEFINE CLASS cmdtallacolor AS cmd_base


	Picture = "..\..\..\..\graficosgenerales\iconos\tallacolor.bmp"
	DisabledPicture = "..\..\..\..\"
	ToolTipText = "Talla - Color"
	Name = "cmdtallacolor"


ENDDEFINE
*
*-- EndDefine: cmdtallacolor
**************************************************


**************************************************
*-- Class:        ddp_acceso (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   07/15/00 09:17:12 AM
*
DEFINE CLASS ddp_acceso AS toolbar


	Caption = "Toolbar1"
	Height = 36
	Left = 0
	Movable = .F.
	Top = 0
	Width = 269
	Name = "ddp_acceso"


	ADD OBJECT cmdhelp1 AS cmdhelp WITH ;
		Top = 5, ;
		Left = 5, ;
		Height = 27, ;
		Width = 27, ;
		Name = "Cmdhelp1"


	ADD OBJECT separator5 AS separator WITH ;
		Top = 5, ;
		Left = 37, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator5"


	ADD OBJECT separator4 AS separator WITH ;
		Top = 5, ;
		Left = 43, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator4"


	ADD OBJECT command1 AS commandbutton WITH ;
		Top = 5, ;
		Left = 43, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\preview.bmp", ;
		Caption = "", ;
		StatusBarText = "", ;
		ToolTipText = "", ;
		Name = "Command1"


	ADD OBJECT command2 AS commandbutton WITH ;
		Top = 5, ;
		Left = 69, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\attach.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command2"


	ADD OBJECT separator2 AS separator WITH ;
		Top = 5, ;
		Left = 101, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator2"


	ADD OBJECT command4 AS commandbutton WITH ;
		Top = 5, ;
		Left = 101, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\maxtable.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command4"


	ADD OBJECT command3 AS commandbutton WITH ;
		Top = 5, ;
		Left = 127, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\queries.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command3"


	ADD OBJECT command9 AS commandbutton WITH ;
		Top = 5, ;
		Left = 153, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\modiftbl.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command9"


	ADD OBJECT command10 AS commandbutton WITH ;
		Top = 5, ;
		Left = 179, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\reports.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command10"


	ADD OBJECT command11 AS commandbutton WITH ;
		Top = 5, ;
		Left = 205, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\view.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command11"


	ADD OBJECT separator3 AS separator WITH ;
		Top = 5, ;
		Left = 237, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator3"


	ADD OBJECT command5 AS commandbutton WITH ;
		Top = 5, ;
		Left = 237, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\close.bmp", ;
		Caption = "", ;
		Name = "Command5"


	PROCEDURE command1.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_1_1
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command1.Init
		DO CASE
		   CASE THIS.Parent.Comment = 'ADMI'
				This.ToolTipText="Definicion de Planes de Desarrollo"
		ENDCASE                
	ENDPROC


	PROCEDURE command2.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_1_2
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command4.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_121
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command3.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_122
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command9.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_2_1
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command10.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Add0100
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command11.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Add0300
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command5.Click
		if MESSAGEBOX("¿Desea Salir del Módulo?",4+32+256,"Salir...")=6
		   clear events
		   set sysmenu to
		endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ddp_acceso
**************************************************


**************************************************
*-- Class:        ddp_interfaces (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   07/26/00 12:35:07 PM
*
DEFINE CLASS ddp_interfaces AS toolbar


	Caption = "Toolbar1"
	Height = 34
	Left = 0
	Top = 0
	Width = 257
	Name = "ddp_interfaces"


	ADD OBJECT command1 AS commandbutton WITH ;
		Top = 5, ;
		Left = 5, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\leaf.bmp", ;
		Caption = "", ;
		TabIndex = 1, ;
		ToolTipText = "Hoja de Pedido", ;
		Name = "Command1"


	ADD OBJECT command2 AS commandbutton WITH ;
		Top = 5, ;
		Left = 29, ;
		Height = 25, ;
		Width = 25, ;
		FontSize = 9, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\libro_ft.bmp", ;
		Caption = "", ;
		TabIndex = 2, ;
		ToolTipText = "Ficha Técnica", ;
		Name = "Command2"


	ADD OBJECT command4 AS commandbutton WITH ;
		Top = 5, ;
		Left = 53, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\clock.bmp", ;
		Caption = "", ;
		TabIndex = 3, ;
		ToolTipText = "Asistencia del Personal", ;
		Name = "Command4"


	ADD OBJECT command5 AS commandbutton WITH ;
		Top = 5, ;
		Left = 77, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\login_s.bmp", ;
		Caption = "", ;
		TabIndex = 4, ;
		ToolTipText = "Personal por Area", ;
		Name = "Command5"


	ADD OBJECT separator1 AS separator WITH ;
		Top = 5, ;
		Left = 107, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator1"


	ADD OBJECT command9 AS commandbutton WITH ;
		Top = 5, ;
		Left = 107, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\wzbook.bmp", ;
		Caption = "", ;
		ToolTipText = "Dicionario de Términos", ;
		Name = "Command9"


	ADD OBJECT command10 AS commandbutton WITH ;
		Top = 5, ;
		Left = 131, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\library.bmp", ;
		Caption = "", ;
		ToolTipText = "Manuales de Sistema", ;
		Name = "Command10"


	ADD OBJECT command11 AS commandbutton WITH ;
		Top = 5, ;
		Left = 155, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\frmatwiz.bmp", ;
		Caption = "", ;
		ToolTipText = "Interface con Planeamiento", ;
		Name = "Command11"


	ADD OBJECT command7 AS commandbutton WITH ;
		Top = 5, ;
		Left = 179, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\addtable.bmp", ;
		Caption = "", ;
		TabIndex = 5, ;
		ToolTipText = "Mantenimiento de Tablas", ;
		Name = "Command7"


	ADD OBJECT command3 AS commandbutton WITH ;
		Top = 5, ;
		Left = 203, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\appwizrd.bmp", ;
		Caption = "", ;
		TabIndex = 6, ;
		ToolTipText = "Utilitarios del Sistema", ;
		Name = "Command3"


	ADD OBJECT command8 AS commandbutton WITH ;
		Top = 5, ;
		Left = 227, ;
		Height = 25, ;
		Width = 25, ;
		Picture = "..\..\..\..\graficosgenerales\fondos\wzplan.bmp", ;
		Caption = "", ;
		TabIndex = 8, ;
		ToolTipText = "Consulta del LOG", ;
		Name = "Command8"


	ADD OBJECT separator2 AS separator WITH ;
		Top = 5, ;
		Left = 251, ;
		Height = 0, ;
		Width = 0, ;
		Name = "Separator2"


	PROCEDURE command11.Click
	ENDPROC


	PROCEDURE command8.Click
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ddp_interfaces
**************************************************


**************************************************
*-- Class:        fun_acceso (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   11/29/05 08:09:07 AM
*
DEFINE CLASS fun_acceso AS toolbar


	Caption = "Toolbar1"
	Height = 33
	Left = 0
	Top = 0
	Width = 245
	Name = "fun_acceso"


	ADD OBJECT cmdhelp1 AS cmdhelp WITH ;
		Top = 3, ;
		Left = 5, ;
		Height = 27, ;
		Width = 27, ;
		Name = "Cmdhelp1"


	ADD OBJECT command1 AS commandbutton WITH ;
		Top = 3, ;
		Left = 31, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\preview.bmp", ;
		Caption = "", ;
		StatusBarText = "", ;
		ToolTipText = "", ;
		Name = "Command1"


	ADD OBJECT command2 AS commandbutton WITH ;
		Top = 3, ;
		Left = 57, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\attach.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command2"


	ADD OBJECT command4 AS commandbutton WITH ;
		Top = 3, ;
		Left = 83, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\maxtable.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command4"


	ADD OBJECT command3 AS commandbutton WITH ;
		Top = 3, ;
		Left = 109, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\queries.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command3"


	ADD OBJECT command9 AS commandbutton WITH ;
		Top = 3, ;
		Left = 135, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\modiftbl.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command9"


	ADD OBJECT command10 AS commandbutton WITH ;
		Top = 3, ;
		Left = 161, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\reports.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command10"


	ADD OBJECT command11 AS commandbutton WITH ;
		Top = 3, ;
		Left = 187, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\view.bmp", ;
		Caption = "", ;
		ToolTipText = "", ;
		Name = "Command11"


	ADD OBJECT command5 AS commandbutton WITH ;
		Top = 3, ;
		Left = 213, ;
		Height = 27, ;
		Width = 27, ;
		Picture = "..\..\grafgen\fondos\close.bmp", ;
		Caption = "", ;
		Name = "Command5"


	PROCEDURE command1.Init
		DO CASE
		   CASE THIS.Parent.Comment = 'ADMI'
				This.ToolTipText="Definicion de Planes de Desarrollo"
		ENDCASE                
	ENDPROC


	PROCEDURE command1.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_1_1
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command2.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_1_2
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command4.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_121
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command3.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_122
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command9.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Pr_A_2_1
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command10.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Add0100
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command11.Click
		*!*	DO CASE
		*!*	   CASE THIS.Parent.Comment = 'ADMI'
		*!*	        DO FORM Add0300
		*!*	ENDCASE                
	ENDPROC


	PROCEDURE command5.Click
		if MESSAGEBOX("¿Desea Salir del Módulo?",4+32+256,"Salir...")=6
		   clear events
		   set sysmenu to
		endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: fun_acceso
**************************************************


**************************************************
*-- Class:        statusbar (k:\aplvfp\classgen\vcxs\admtbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Time Stamp:   05/19/03 04:43:09 AM
*
DEFINE CLASS statusbar AS toolbar


	Caption = "StatusBar"
	Enabled = .T.
	Height = 26
	Left = 0
	Movable = .F.
	Sizable = .F.
	Top = 0
	Width = 619
	BackColor = RGB(223,223,223)
	usuario = ("")
	servidor = ("")
	fecha = ("")
	Name = "statusbar"


	ADD OBJECT cntusuario AS base_gridheader WITH ;
		Top = 3, ;
		Left = 5, ;
		Width = 96, ;
		Height = 20, ;
		SpecialEffect = 1, ;
		Name = "cntUsuario", ;
		Label1.Alignment = 0, ;
		Label1.Caption = "Usuario", ;
		Label1.Height = 16, ;
		Label1.Left = 6, ;
		Label1.Top = 2, ;
		Label1.Width = 83, ;
		Label1.ForeColor = RGB(0,0,128), ;
		Label1.Name = "Label1"


	ADD OBJECT cntservidor AS base_gridheader WITH ;
		Top = 3, ;
		Left = 100, ;
		Width = 341, ;
		Height = 20, ;
		SpecialEffect = 1, ;
		Name = "cntServidor", ;
		Label1.Alignment = 0, ;
		Label1.Caption = "Servidor", ;
		Label1.Height = 16, ;
		Label1.Left = 7, ;
		Label1.Top = 2, ;
		Label1.Width = 327, ;
		Label1.ForeColor = RGB(0,0,128), ;
		Label1.Name = "Label1"


	ADD OBJECT cntfecha AS base_gridheader WITH ;
		Top = 3, ;
		Left = 440, ;
		Width = 174, ;
		Height = 20, ;
		SpecialEffect = 1, ;
		Name = "cntFecha", ;
		Label1.Alignment = 0, ;
		Label1.Caption = "Fecha", ;
		Label1.Height = 16, ;
		Label1.Left = 6, ;
		Label1.Top = 2, ;
		Label1.Width = 162, ;
		Label1.ForeColor = RGB(0,0,128), ;
		Label1.Name = "Label1"


	HIDDEN PROCEDURE usuario_assign
		LPARAMETERS tcUsuario
		THIS.Usuario = tcUsuario
		THIS.cntUsuario.Label1.Caption	= tcUsuario
	ENDPROC


	HIDDEN PROCEDURE servidor_assign
		LPARAMETERS tcServidor
		THIS.Servidor = tcServidor
		THIS.cntServidor.Label1.Caption	= tcServidor
	ENDPROC


	HIDDEN PROCEDURE fecha_assign
		LPARAMETERS tcFecha
		THIS.Fecha = tcFecha
		THIS.cntFecha.Label1.Caption = tcFecha
	ENDPROC


	PROCEDURE Dock
		LPARAMETERS nLocation

		LOCAL m.lnWidthTB , m.lnWidthTxt1 , m.lnWidthTxt2 , m.lnWidthTxt3

		m.lnWidthTxt1	= THIS.cntUsuario.Width/THIS.Width
		m.lnWidthTxt2	= THIS.cntServidor.Width/THIS.Width
		m.lnWidthTxt3	= THIS.cntFecha.Width/THIS.Width

		*THIS.Width		= SYSMETRIC(1)-14
		THIS.Width		= _Screen.Width 

		THIS.cntUsuario.Width	= THIS.Width*m.lnWidthTxt1
		THIS.cntServidor.Width	= THIS.Width*m.lnWidthTxt2
		THIS.cntFecha.Width	= THIS.Width*m.lnWidthTxt3


		DODEFAULT(nLocation)
	ENDPROC


	PROCEDURE DblClick
		nodefault
	ENDPROC


	PROCEDURE cntusuario.DblClick
		DO FORM ClaGen2_Informacion_Login
	ENDPROC


	PROCEDURE cntusuario.Label1.DblClick
		THIS.PARENT.DBLCLICK()
	ENDPROC


	PROCEDURE cntusuario.Label1.Click
	ENDPROC


	PROCEDURE cntservidor.DblClick
		WAIT WINDOW "Mostrar información del Servidor" NOWAIT
	ENDPROC


	PROCEDURE cntservidor.Label1.DblClick
		THIS.PARENT.DBLCLICK()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: statusbar
**************************************************
