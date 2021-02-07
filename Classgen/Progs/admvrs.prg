**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\admvrs.vcx
**************************************************


**************************************************
*-- Class:        base_checkbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   06/09/00 08:54:06 PM
*
DEFINE CLASS base_checkbox AS checkbox


	Height = 24
	Width = 60
	BackStyle = 0
	Caption = "Check1"
	Value = .F.
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,255)
	DisabledBackColor = RGB(255,255,255)
	Name = "base_checkbox"


ENDDEFINE
*
*-- EndDefine: base_checkbox
**************************************************


**************************************************
*-- Class:        base_checkbox_multiselect (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_checkbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   03/20/07 11:25:01 PM
*
DEFINE CLASS base_checkbox_multiselect AS base_checkbox


	Height = 24
	Width = 22
	Alignment = 0
	Caption = ""
	Name = "base_checkbox_multiselect"


	PROCEDURE Click
		LOCAL lcAlias
		lcAlias = ALIAS()
		IF !EMPTY(lcAlias) AND USED(lcAlias)
			IF CURSORGETPROP("Buffering",lcAlias) > 1
				=TABLEUPDATE(.F.,.T.,lcAlias)
			ENDIF
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_checkbox_multiselect
**************************************************


**************************************************
*-- Class:        base_checkbox_serie (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   12/08/06 10:10:01 PM
*
DEFINE CLASS base_checkbox_serie AS checkbox


	Height = 22
	Width = 16
	Alignment = 0
	Caption = ""
	Name = "base_checkbox_serie"


	PROCEDURE When
		RETURN .t.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_checkbox_serie
**************************************************


**************************************************
*-- Class:        base_combobox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  combobox
*-- BaseClass:    combobox
*-- Time Stamp:   06/02/00 02:49:14 PM
*
DEFINE CLASS base_combobox AS combobox


	Enabled = .T.
	Height = 24
	ColumnLines = .F.
	Style = 2
	Width = 100
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_combobox"


ENDDEFINE
*
*-- EndDefine: base_combobox
**************************************************


**************************************************
*-- Class:        base_cbohelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_combobox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   06/19/03 08:57:14 PM
*
DEFINE CLASS base_cbohelp AS base_combobox


	Height = 23
	Width = 189
	caliascursor = (SYS(2015))
	cnombreentidad = ""
	ccamporetorno = ""
	ccampovisualizacion = ""
	cremotepathentidad = ""
	ccamposfiltro = ""
	cvaloresfiltro = ""
	csql = ""
	cwhere = ""
	cwheresql = ("")
	corderby = ""
	Name = "base_cbohelp"

	*-- Define si trae información desde el Servidor o de modo Local
	lservidor = .F.

	*-- Genera cursor actualizable.
	lupdatecursor = .F.
	DIMENSION acamposfiltro[1,1]
	DIMENSION avaloresfiltro[1,1]


	PROCEDURE generarsql
		IF THIS.lServidor
			cSQL =	" SELECT " + THIS.cCampoRetorno + ;
				IIF( EMPTY(THIS.cCampoVisualizacion) , "" , " , " + THIS.cCampoVisualizacion ) + ;
				" FROM " + THIS.cRemotePathEntidad + ;
				" WHERE " + " FlagEliminado=0"
		ELSE

			IF GoEntorno.SqlEntorno
				cSQL =	" SELECT " + THIS.cCampoRetorno + ;
					IIF( EMPTY(THIS.cCampoVisualizacion) , "" , " , " + THIS.cCampoVisualizacion ) + ;
					" FROM " + (goEntorno.LocPath + THIS.cNombreEntidad) + ;
					" WHERE " + " !FlagEliminado"
			ELSE
		**		LsRutaEntidad = goentorno.open_dbf1('',THIS.cNombreEntidad,'','ComboBox','')
				cSQL =	" SELECT " + THIS.cCampoRetorno + ;
					IIF( EMPTY(THIS.cCampoVisualizacion) , "" , " , " + THIS.cCampoVisualizacion ) + ;
					" FROM " + THIS.cRemotePathEntidad + ;
					" WHERE " + " !Deleted()"
			ENDIF

		ENDIF

		THIS.cSQL = cSQL
		RETURN cSQL
	ENDPROC


	PROCEDURE generarwhere
		LOCAL lcWhere , lcCampo , lcValor
		lcWhere = ""

		IF	!EMPTY( THIS.cCamposFiltro ) AND !EMPTY( THIS.cValoresFiltro )
			FOR i = 1 TO ALEN(THIS.aCamposFiltro)
				lcCampo	= IIF( TYPE("THIS.aCamposFiltro[I]")=="C" , ALLTRIM(THIS.aCamposFiltro[I]) , "" )
				lcValor	= IIF( TYPE("THIS.aValoresFiltro[I]")=="C", ALLTRIM(THIS.aValoresFiltro[I]), "" )
				IF !EMPTY(lcCampo) AND !EMPTY(lcValor)
					lcWhere = lcWhere + lcCampo+ " = '" + lcValor + "' AND "
				ENDIF
			ENDFOR
			THIS.cWhere = LEFT(lcWhere, LEN(lcWhere) - 5 )
		ELSE
			THIS.cWhere = ""
		ENDIF
		RETURN lcWhere
	ENDPROC


	PROCEDURE generarcursor
		LOCAL lReturn , lnDataSessionID , cSQL

		THIS.ROWSOURCE     = ""
		THIS.ROWSOURCETYPE = 0
		THIS.BOUNDCOLUMN   = 1

		DO CASE
		CASE TYPE("THISFORM") == "O"
			lnDataSessionID = THISFORM.DataSessionId 
		CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
			lnDataSessionID = _SCREEN.ACTIVEFORM.DataSessionId 
		OTHERWISE
			lnDataSessionID	= 1
		ENDCASE

		THIS.GenerarSQL()
		THIS.GenerarWHERE()

		cSQL = THIS.cSQL + IIF(!EMPTY(THIS.cWhere)," AND " + THIS.cWhere , "") + " " + ;
			THIS.cWhereSQL + " ORDER BY " + IIF(ISNULL(THIS.cOrderBy) OR EMPTY(THIS.cOrderBy),"2",THIS.cOrderBy)


		*=MESSAGEBOX(cSQl)
		lReturn = .T.

		IF THIS.lServidor
			goConexion.cSQL = cSQL
			goConexion.cCursor = THIS.cAliasCursor
			lReturn = ( goConexion.DoSQL(lnDataSessionID) > 0 )
		ELSE
			IF THIS.lUpdateCursor
				cSQL = cSQL + " INTO TABLE " + THIS.cAliasCursor
			ELSE
				cSQL = cSQL + " INTO CURSOR " + THIS.cAliasCursor
			ENDIF
			&cSQL
		ENDIF

		IF lReturn AND USED(THIS.cAliasCursor)

			lnCamposVisualiazion = OCCURS(',',THIS.cCampoVisualizacion) + 1

			THIS.ROWSOURCE		= THIS.cAliasCursor + "." + THIS.cCampoVisualizacion + ", " + THIS.cCampoRetorno
			THIS.ROWSOURCETYPE	= 6
			THIS.BOUNDCOLUMN	= lnCamposVisualiazion + 1
			THIS.VALUE			= EVAL(THIS.cCampoRetorno)	&& VSJ 26/08/00
		*	THIS.VALUE=	ALLTRIM( SUBSTR(THIS.cCampoRetorno,AT('#',THIS.cCampoRetorno)+1) )&& VSJ 26/08/00

		ENDIF

		IF USED("GTablas_Detalle")
			USE IN GTablas_Detalle
		ENDIF

		RETURN lReturn
	ENDPROC


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


	HIDDEN PROCEDURE cvaloresfiltro_assign
		LPARAMETERS tcValoresFiltro

		tcValoresFiltro		= IIF( VARTYPE(tcValoresFiltro)<>"C" , "" , ALLTRIM(tcValoresFiltro) )
		THIS.cValoresFiltro	= tcValoresFiltro

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cValoresFiltro )
			THIS.ChrToArray( THIS.cValoresFiltro, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aValoresFiltro )
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ccamposfiltro_assign
		LPARAMETERS tcCamposFiltro

		tcCamposFiltro		= IIF( VARTYPE(tcCamposFiltro)<>"C" , "" , ALLTRIM(tcCamposFiltro) )
		THIS.cCamposFiltro	= tcCamposFiltro

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cCamposFiltro )
			THIS.ChrToArray( THIS.cCamposFiltro, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aCamposFiltro )
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE cnombreentidad_assign
		LPARAMETERS tcNombreEntidad
		IF VARTYPE(tcNombreEntidad) <> "C"
			tcNombreEntidad	= ""
		ENDIF

		THIS.cNombreEntidad = ALLTRIM(tcNombreEntidad)

		IF !EMPTY( THIS.cNombreEntidad )
			THIS.cRemotePathEntidad	= goEntorno.RemotePathEntidad( THIS.cNombreEntidad )
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ccamporetorno_assign
		LPARAMETERS tcCampoRetorno
		IF VARTYPE(tcCampoRetorno)<>"C"
			tcCampoRetorno	=	""
		ENDIF
		THIS.cCampoRetorno = ALLTRIM(tcCampoRetorno)
	ENDPROC


	HIDDEN PROCEDURE ccampovisualizacion_assign
		LPARAMETERS tcCampoVisualizacion
		IF VARTYPE(tcCampoVisualizacion)<>"C"
			tcCampoVisualizacion	=	""
		ENDIF
		THIS.cCampoVisualizacion	= ALLTRIM(tcCampoVisualizacion)
		THIS.cCampoVisualizacion	= STRTRAN(THIS.cCampoVisualizacion,';',',')
		THIS.cCampoVisualizacion	= STRTRAN(THIS.cCampoVisualizacion,' ','')
	ENDPROC


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		tcWhereSQL	= IIF( VARTYPE(tcWhereSQL)<>"C" , "" , ALLTRIM(tcWhereSQL) )
		THIS.cWhereSQL = tcWhereSQL
	ENDPROC


	PROCEDURE Destroy
		THIS.ROWSOURCETYPE	= 0
		THIS.ROWSOURCE    	= ""
		THIS.BOUNDCOLUMN   	= 1

		IF USED(THIS.cAliasCursor)
			USE IN (THIS.cAliasCursor)
		ENDIF
	ENDPROC


	PROCEDURE Init
		THIS.COLUMNWIDTHS	= ALLTRIM(STR(THIS.WIDTH-10))+',0'
		THIS.LISTINDEX	= 1

		*!*	Forzar los Métodos ASSIGN
		THIS.cNombreEntidad		= THIS.cNombreEntidad
		THIS.cCampoRetorno		= THIS.cCampoRetorno
		THIS.cCampoVisualizacion= THIS.cCampoVisualizacion
		THIS.cCamposFiltro		= THIS.cCamposFiltro
		THIS.cValoresFiltro		= THIS.cValoresFiltro
		THIS.cWhereSQL 			= THIS.cWhereSQL

		IF !EMPTY(THIS.cAliasCursor) AND !ISNULL(THIS.cAliasCursor) AND USED(THIS.cAliasCursor)
			USE IN (THIS.cAliasCursor)
			THIS.cAliasCursor = ""
		ENDIF

		IF EMPTY(THIS.cAliasCursor) OR ISNULL(THIS.cAliasCursor)
			THIS.cAliasCursor = SYS(2015)
		ENDIF

		IF	EMPTY(THIS.cNombreEntidad) OR EMPTY(THIS.cCampoRetorno) OR EMPTY(THIS.cCampoVisualizacion) 
				&&OR (!EMPTY(THIS.cCamposFiltro) AND EMPTY(THIS.cValoresFiltro)) OR (EMPTY(THIS.cCamposFiltro) AND !EMPTY(THIS.cValoresFiltro))
			RETURN .F.
		ENDIF

		THIS.GenerarCursor()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cbohelp
**************************************************


**************************************************
*-- Class:        base_cbohelp_gtablas (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_cbohelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   09/08/00 03:20:01 PM
*
DEFINE CLASS base_cbohelp_gtablas AS base_cbohelp


	cnombreentidad = "GTablas_Detalle"
	ccamposfiltro = "CodigoTabla"
	ccamporetorno = "ElementoTabla"
	ccampovisualizacion = "DescripcionLargaArgumento"
	lservidor = .F.
	Name = "base_cbohelp_gtablas"


	PROCEDURE generarsql
		cSQL =	" SELECT " + THIS.cCampoRetorno + ;
			IIF( EMPTY(THIS.cCampoVisualizacion) , "" , " , " + THIS.cCampoVisualizacion ) + ;
			",FlagDefault FROM " + (goEntorno.LocPath + THIS.cNombreEntidad) + ;
			" WHERE " + " !FlagEliminado"

		THIS.cSQL = cSQL
		RETURN cSQL
	ENDPROC


	PROCEDURE generarcursor
		DODEFAULT()
		IF USED(THIS.cAliasCursor)
			SELECT(THIS.cAliasCursor)
			LOCATE ALL FOR FlagDefault
			THIS.VALUE	= EVAL(THIS.cCampoRetorno)
		ENDIF

		RETURN .T.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cbohelp_gtablas
**************************************************


**************************************************
*-- Class:        base_cbohelp_serie (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_cbohelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   12/09/06 04:43:10 AM
*
DEFINE CLASS base_cbohelp_serie AS base_cbohelp


	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="serietoarray" type="property" display="Serietoarray"/><memberdata name="cseries" type="property" display="cSeries"/><memberdata name="aseriestru" type="property" display="aSerieStru"/><memberdata name="ntotseriesleidas" type="property" display="ntotSeriesLeidas"/></VFPData>]
	*-- Contiene las series concatenadas
	cseries = ([])
	ntotseriesleidas = 0
	Name = "base_cbohelp_serie"

	*-- Arreglo que contiene las series
	DIMENSION aserie[1,1]
	DIMENSION aseriestru[1,1]


	*-- Convertimos las series concatenadas en un cursor
	PROCEDURE serietocursor
		PARAMETERS cSerie,cCursor,cCodMat
		this.chrtoarray(cSerie,',',this.aSerie) 
		DECLARE aSerieStru[1,1]
		=AFIELDS(aSerieStru,this.cnombreentidad) 
		ACOPY(aSerieStru,this.aSerieStru)
		CREATE CURSOR (cCursor) FROM ARRAY this.aSerieStru
		LOCAL K AS Integer 
		FOR K = 1 TO ALEN(aSeries)
			m.CodMat = cCodMat
			m.Serie  = aSerie(K)
			INSERT INTO (cCursor) FROM MEMVAR
		ENDFOR
		this.ntotSeriesLeidas = RECCOUNT() && o Igual K 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cbohelp_serie
**************************************************


**************************************************
*-- Class:        base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/00 03:41:05 AM
*
DEFINE CLASS base_command AS commandbutton


	Height = 26
	Width = 84
	FontSize = 8
	Caption = "\<Command1"
	ForeColor = RGB(0,0,160)
	*-- Indica el Codigo del Boton asignado en la Tabla GBotones
	codigoboton = ""
	Name = "base_command"

	*-- Propiedad usada por la clase "boton", indica si el boton esta disponible para el usuario. Ver propiedad ACTIVADO
	HIDDEN lactivado


	*-- Retorna un Valor .T. si el usuario tiene derechos para usar este boton
	PROCEDURE activado
		RETURN .T.
		IF !THIS.lActivado
			=MESSAGEBOX("Usted no tiene derechos para usar este Botón",64,"Perfil de Usuario")
		ENDIF
		RETURN THIS.lActivado
	ENDPROC


	PROCEDURE Init
		THIS.lActivado = .F.
		IF NOT goEntorno.SqlEntorno
			THIS.lActivado = .T.
		ELSE
			IF ISNULL(THIS.CodigoBoton)
				THIS.CodigoBoton = SPACE(0)
			ENDIF

			LOCAL lcCodigoFormulario , lcLoginUsuario , lcPerfil_Boton , lcAlias
			LOCAL laBoton
			DECLARE laBoton(1)
			lcAlias	= "Perfil_Botones"
			IF TYPE("THIS.CodigoBoton")=="C" AND !EMPTY(THIS.CodigoBoton) AND TYPE("THISFORM.CodigoFormulario")=="C"
				lcCodigoFormulario	= THISFORM.CodigoFormulario
				lcCodigoBoton		= THIS.CodigoBoton
				IF TYPE("goEntorno")=="O"
					lcLoginUsuario	= goEntorno.User.Login
					lcPerfil_Boton	= goEntorno.LocPath + lcAlias
				ELSE
					lcLoginUsuario	= ""
					lcPerfil_Boton	= ""
				ENDIF
				IF !EMPTY(lcPerfil_Boton)
					SELECT ;
						CodigoBoton ;
					FROM ;
						(lcPerfil_Boton) ;
					WHERE ;
						CodigoBoton == lcCodigoBoton AND ;
						CodigoFormulario == lcCodigoFormulario AND ;
						LoginUsuario == lcLoginUsuario ;
					INTO ARRAY laBoton

					THIS.lActivado	= _TALLY > 0

					IF USED(lcAlias)
						USE IN (lcAlias)
					ENDIF
				ENDIF
			ENDIF

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_command
**************************************************


**************************************************
*-- Class:        base_cmdhelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   07/12/07 12:14:09 PM
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
	corderby = ""
	*-- Objeto para capturar registros seleccionados en la consulta
	odata = .NULL.
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="odata" type="property" display="oData"/><memberdata name="lhaving" type="property" display="lHaving"/><memberdata name="chavingsql" type="property" display="cHavingSql"/><memberdata name="ccampobusqueda" type="property" display="cCampoBusqueda"/></VFPData>]
	*-- utiliza la clausula having
	lhaving = .F.
	*-- Contiene expresion sql para la clausula HAVING
	chavingsql = ([])
	*-- Campo de busqueda, si esta en blanco se busca en la segunda columna del cursor
	ccampobusqueda = ([])
	*-- Crear un nuevo registro en la entidad
	lcrearregistroentidad = .F.
	*-- Modifica un registro de la entidad
	lmodificaregistroentidad = .F.
	Name = "base_cmdhelp"

	*-- Especifica si deja pasar valores en Blanco en un control Texto asociado al boton ayuda
	lvalidadato = .F.

	*-- Indica que tipo de Formulario se mostrará para la ayuda, con criterios o sin criterios
	lflagbusqueda = .F.
	lsolo2columnas = .F.
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

		LOCAL lnDataSessionID

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
		IF GOENTORNO.SqlEntorno
			THIS.cSQL = THIS.cSQL + ;
				" WHERE LTRIM(RTRIM(T000." + THIS.cCampoRetorno + ")) = '" + THIS.cValorValida + "'" + ;
				" AND T000.FlagEliminado = 0 " + ;
				IIF(!EMPTY(THIS.cWhere)," AND " + THIS.cWhere , "")  + " " + THIS.cWhereSQL
		ELSE
			THIS.cSQL = THIS.cSQL + ;
				" WHERE LTRIM(RTRIM(T000." + THIS.cCampoRetorno + ")) = '" + THIS.cValorValida + "'" + ;
				" AND !DELETED() " + ;
				IIF(!EMPTY(THIS.cWhere)," AND " + THIS.cWhere , "")  + " " + THIS.cWhereSQL
		ENDIF
		*=messagebox(THIS.cSQL )
		IF GoEntorno.SqlEntorno
			goConexion.cSQL = THIS.cSQL
			goConexion.cCursor = THIS.cAliasCursor
			lReturn = ( goConexion.DoSQL(lnDataSessionID) > 0 )
		ELSE
			cSQL = this.cSQL + " INTO CURSOR " + THIS.cAliasCursor
			&cSQL
			lReturn = (_TALLY > 0)
		ENDIF
		IF lReturn
			SELECT( THIS.cAliasCursor )
			cCampoRetorno = THIS.cCampoRetorno
			cCampoVisualizacion = THIS.cCampoVisualizacion
			IF VARTYPE(cCampoRetorno) = 'N'
				LOCATE FOR &cCampoRetorno == THIS.cValorValida
			ELSE
				LOCATE FOR ALLTRIM(&cCampoRetorno) == THIS.cValorValida
			ENDIF
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

		LOCAL lFlagBusqueda,lCursorLocal,LcCursorLocal
		lCursorLocal = .F.

		LcCursorLocal	=	[]
		THIS.cNombreEntidad = ALLTRIM(tcNombreEntidad)
		LnPos = AT(';',this.cNombreEntidad)
		IF LnPos>0 AND LEFT(UPPER(this.cNombreEntidad),LnPos - 1) = [LOCAL]
			lCursorLocal = .t.
			LcCursorLocal = SUBSTR(this.cNombreEntidad,LnPos + 1)
		ENDIF
		IF !EMPTY( THIS.cNombreEntidad )
			THIS.cRemotePathEntidad	= IIF(lCursorLocal,LcCursorLocal,goEntorno.RemotePathEntidad( THIS.cNombreEntidad ,, @lFlagBusqueda ) )
			*THIS.cnombreentidad = THIS.cRemotePathEntidad
			THIS.lFlagBusqueda		= lFlagBusqueda
		ENDIF
	ENDPROC


	*-- Convierte los codigo de la secuencia de atributos a nombres de campos validos para la sentencia SQL
	PROCEDURE generarsecuenciacampos
		LOCAL cAtributo , cAlias
		LOCAL laSecuencia
		DIMENSION laSecuencia[1]
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


	PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		IF VARTYPE(tcWhereSQL)<>"C"
			tcWhereSQL = ""
		ELSE
			tcWhereSQL = ALLTRIM(tcWhereSQL)
		ENDIF
		THIS.cWhereSQL= tcWhereSQL
	ENDPROC


	PROCEDURE ccamposfiltro_assign
		LPARAMETERS tcCamposFiltro

		tcCamposFiltro	= IIF( VARTYPE(tcCamposFiltro)<>"C" , "" , ALLTRIM(tcCamposFiltro) )
		THIS.cCamposFiltro	= tcCamposFiltro

		DIMENSION aCampos[1]
		STORE "" TO aCampos
		IF !EMPTY( THIS.cCamposFiltro )
			THIS.ChrToArray( THIS.cCamposFiltro, ";" , @aCampos )
		ENDIF
		nLen = ALEN(aCampos)
		DIMENSION THIS.aCamposFiltro(nLen)
		=ACOPY(aCampos, THIS.aCamposFiltro )
		RETURN .T.
	ENDPROC


	PROCEDURE cvaloresfiltro_assign
		LPARAMETERS tcValoresFiltro

		tcValoresFiltro	= IIF( VARTYPE(tcValoresFiltro)<>"C" , "" , ALLTRIM(tcValoresFiltro) )
		THIS.cValoresFiltro	= tcValoresFiltro

		DIMENSION aCampos[1]
		STORE "" TO aCampos
		IF !EMPTY( THIS.cValoresFiltro )
			THIS.ChrToArray( THIS.cValoresFiltro, ";" , @aCampos )
		ENDIF
		nLen = ALEN(aCampos)
		DIMENSION THIS.aValoresFiltro(nLen)
		=ACOPY(aCampos, THIS.aValoresFiltro )
		RETURN .T.
	ENDPROC


	PROCEDURE Click
		LOCAL loBoton
		SET TALK OFF

		THIS.GenerarWHERE()

		DO CASE
			CASE THIS.cModoObtenerDatos = "V"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS)
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS)
				ENDIF
			CASE THIS.cModoObtenerDatos = "L"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS)
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS)
				ENDIF
			CASE THIS.cModoObtenerDatos = "R"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS)
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS)
				ENDIF
		ENDCASE
	ENDPROC


	PROCEDURE Init
		NODEFAULT
		THIS.cCamposFiltro	= THIS.cCamposFiltro
		THIS.cValoresFiltro	= THIS.cValoresFiltro
	ENDPROC


	PROCEDURE RightClick
		IF NOT (this.lCrearRegistroEntidad OR this.lModificaRegistroEntidad)
			return
		ENDIF
	ENDPROC


	PROCEDURE validarparametros
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cmdhelp
**************************************************


**************************************************
*-- Class:        cmd_base (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/11/00 12:19:10 PM
*
DEFINE CLASS cmd_base AS base_command


	Height = 24
	Width = 24
	Caption = ""
	Name = "cmd_base"


ENDDEFINE
*
*-- EndDefine: cmd_base
**************************************************


**************************************************
*-- Class:        cmdbase (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_command (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/11/00 12:20:02 PM
*
DEFINE CLASS cmdbase AS base_command


	Height = 38
	Width = 48
	FontBold = .F.
	FontSize = 8
	Caption = "Caption"
	Enabled = .T.
	ForeColor = RGB(0,0,160)
	DisabledForeColor = RGB(100,100,100)
	Name = "cmdbase"


ENDDEFINE
*
*-- EndDefine: cmdbase
**************************************************


**************************************************
*-- Class:        base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   05/23/05 02:34:03 AM
*
DEFINE CLASS base_container AS container


	Width = 326
	Height = 120
	BorderWidth = 0
	BackColor = RGB(223,223,223)
	Name = "base_container"
	entidadcorrelativo = .F.

	*-- Cursor local en donde se almacenan los datos a modificar o seleccionar
	ccursor_local = .F.


	ADD OBJECT shpborde AS base_shape WITH ;
		Top = 0, ;
		Left = 0, ;
		Height = 120, ;
		Width = 324, ;
		Name = "shpBorde"


	PROCEDURE visible_assign
		LPARAMETERS tlVisible

		IF tlVisible
			THIS.VISIBLE = tlVisible
		ELSE
			THIS.VISIBLE = tlVisible
		ENDIF

		*!*	IF TYPE("THISFORM")<>'O'
		*!*		RETURN
		*!*	ENDIF

		*!*	lnTotal = THISFORM.CONTROLCOUNT

		*!*	FOR I=1 TO lnTotal
		*!*		IF THISFORM.CONTROLS(I).NAME == THIS.NAME OR THISFORM.CONTROLS(I).BASECLASS == "Label"
		*!*			LOOP
		*!*		ENDIF
		*!*		IF TYPE("THISFORM.CONTROLS(I).ENABLED")<>"L"
		*!*			LOOP
		*!*		ENDIF
		*!*		IF !THISFORM.CONTROLS(I).ENABLED AND tlVisible
		*!*			THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
		*!*		ENDIF
		*!*		IF ! TRANSFORM(I,'@JL 99') $ THIS.TAG
		*!*			THISFORM.CONTROLS(I).ENABLED = !tlVisible
		*!*		ENDIF
		*!*	ENDFOR

		*!*	IF THIS.PARENT.NAME	<> THISFORM.NAME	&& El contenedor de esta clase no es el formulario
		&& No entiendo para que es esto VETT 23-05-2005
		*!*	*!*		IF TYPE("THIS.PARENT.CONTROLCOUNT") == "N"	&& Si es un contenedor
		*!*	*!*			FOR I=1 TO THIS.PARENT.CONTROLCOUNT
		*!*	*!*				IF THIS.PARENT.CONTROLS(I).NAME == THIS.NAME OR THIS.PARENT.CONTROLS(I).BASECLASS = "Label"
		*!*	*!*					LOOP
		*!*	*!*				ENDIF
		*!*	*!*				IF TYPE("THIS.PARENT.CONTROLS(I).ENABLED")<>"L"
		*!*	*!*					LOOP
		*!*	*!*				ENDIF
		*!*	*!*				IF !THIS.PARENT.CONTROLS(I).ENABLED AND tlVisible
		*!*	*!*					*THIS.TAG = THIS.TAG + TRANSFORM(lnTotal+I,'@JL 99') + ","
		*!*	*!*					THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
		*!*	*!*				ENDIF
		*!*	*!*				*IF ! TRANSFORM(lnTotal+I,'@JL 99') $ THIS.TAG
		*!*	*!*				IF ! TRANSFORM(I,'@JL 99') $ THIS.TAG
		*!*	*!*					THIS.PARENT.CONTROLS(I).ENABLED = !tlVisible
		*!*	*!*				ENDIF
		*!*	*!*			ENDFOR
		*!*	*!*		ENDIF
		*!*	ENDIF
		THIS.Activar_Contenedor()
		THIS.SETFOCUS()
	ENDPROC


	*-- Activa el objeto que contiene esta clase
	HIDDEN PROCEDURE activar_contenedor
		*!*	Verificar que el Objeto que contiene esta clase no este Desactivado 
		*!*	cuando se haga visible
		loParent= THIS
		llSalir	= .F.
		DO WHILE ! llSalir
			IF TYPE("loParent.PARENT") == "O"
				IF loParent.PARENT.NAME <> THISFORM.NAME
					loParent	= loParent.PARENT
				ELSE
					llSalir	= .T.
				ENDIF
			ELSE
				llSalir	= .T.
			ENDIF
		ENDDO
		IF TYPE("loParent.ENABLED")=="L" AND !loParent.ENABLED
			loParent.ENABLED = .T.
		ENDIF
	ENDPROC


	*-- Establece los valores de las propiedades y/o controles que contiene el contenedor
	PROCEDURE configuracontroles
		PARAMETERS xreturn,lNuevo,lGrabado,Que_Transaccion
	ENDPROC


	*-- Hablita los controles del  contenendor
	PROCEDURE habilita
		WITH THIS
			LOCAL i
			FOR i = 1 to .ControlCount
				.Controls(i).Enabled  = .T.
				.Controls(i).Visible  = .T.
			NEXT 
		ENDWITH
	ENDPROC


	*-- Deshabilita los controles del contenedor
	PROCEDURE deshabilita
		WITH THIS
			LOCAL i
			FOR i = 1 to .ControlCount
				.Controls(i).Enabled  = .F.
		*		.Controls(i).Visible  = .F.
			NEXT 
		ENDWITH
	ENDPROC


	PROCEDURE Init
		*THIS.VISIBLE = THIS.VISIBLE
		THIS.shpBorde.LEFT	= 0
		THIS.shpBorde.TOP	= 0
		THIS.shpBorde.HEIGHT= THIS.HEIGHT
		THIS.shpBorde.WIDTH	= THIS.WIDTH

		*!*	IF THIS.PARENT.NAME	<> THISFORM.NAME	&& El contenedor de esta clase no es el formulario
			IF TYPE("THIS.PARENT.CONTROLCOUNT") == "N"	&& Si es un contenedor
				FOR I=1 TO THIS.PARENT.CONTROLCOUNT
					IF THIS.PARENT.CONTROLS(I).NAME == THIS.NAME OR THIS.PARENT.CONTROLS(I).BASECLASS == "Label"
						LOOP
					ENDIF
					IF TYPE("THIS.PARENT.CONTROLS(I).ENABLED")<>"L"
						LOOP
					ENDIF
					IF !THIS.PARENT.CONTROLS(I).ENABLED
						THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
					ENDIF
				ENDFOR
			ENDIF
		*!*	ENDIF
	ENDPROC


	*-- Inicializa los controles del contenedor
	PROCEDURE iniciar_var
	ENDPROC


	*-- Restablece los valores de los controles a nulo o vacio
	PROCEDURE limpiar_var
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_container
**************************************************


**************************************************
*-- Class:        base_criterios_seleccion (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   10/16/00 10:15:03 AM
*
DEFINE CLASS base_criterios_seleccion AS base_container


	Width = 386
	Height = 387
	Visible = .F.
	BackColor = RGB(223,223,223)
	*-- Propiedad que permite retornar la sentencia Where
	cwheresql = ("")
	*-- Recibe el nombre de entidad y se la pasa a la clase base_grid para procesar el criterio de busqueda
	cnombreentidad = ("")
	Name = "base_criterios_seleccion"
	shpBorde.Top = 0
	shpBorde.Left = 0
	shpBorde.Height = 389
	shpBorde.Width = 396
	shpBorde.Visible = .T.
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"
	cliteralcriterios = .F.


	ADD OBJECT cmdaceptar AS cmdaceptar WITH ;
		Top = 340, ;
		Left = 121, ;
		ZOrderSet = 1, ;
		Name = "cmdAceptar"


	ADD OBJECT cmdcancelar AS cmdcancelar WITH ;
		Top = 340, ;
		Left = 217, ;
		ZOrderSet = 2, ;
		Name = "cmdCancelar"


	ADD OBJECT grdcriterios AS base_grid_atributos WITH ;
		Height = 310, ;
		Left = 13, ;
		Panel = 1, ;
		ScrollBars = 2, ;
		Top = 16, ;
		Width = 360, ;
		ZOrderSet = 3, ;
		lbusqueda = .T., ;
		Name = "grdCriterios", ;
		Column1.Header1.Name = "Header1", ;
		Column1.Text1.Name = "Text1", ;
		Column1.Width = 155, ;
		Column1.Name = "Column1", ;
		Column2.Header1.Name = "Header1", ;
		Column2.Text1.Name = "Text1", ;
		Column2.Tag = "_ValorAtributo", ;
		Column2.Width = 155, ;
		Column2.Name = "Column2", ;
		Column3.Header1.Name = "Header1", ;
		Column3.txtHelp.Name = "txtHelp", ;
		Column3.cmdHelp.Tag = "ValorAtributo", ;
		Column3.cmdHelp.Name = "cmdHelp", ;
		Column3.Width = 18, ;
		Column3.Name = "Column3"


	ADD OBJECT ctmcriterios AS base_grid WITH ;
		Top = 340, ;
		Left = 349, ;
		caliasatributos = "Criterios", ;
		caliascursor = "", ;
		caliascolumnas = "Criterios", ;
		cnombreentidad = "", ;
		Name = "ctmCriterios"


	PROTECTED PROCEDURE cnombreentidad_assign
		LPARAMETERS tcNombreEntidad
		*To do: Modify this routine for the Assign method

		THIS.ctmCriterios.cNombreEntidad = tcNombreEntidad

		IF !EMPTY(tcNombreEntidad) AND THIS.cNombreEntidad <> tcNombreEntidad
			THIS.cNombreEntidad = tcNombreEntidad
			THIS.ctmCriterios.ConfigurarGridCriterios()
		ENDIF
		IF !EMPTY(THIS.ctmCriterios.cAliasColumnas) AND USED(THIS.ctmCriterios.cAliasColumnas)
			SELECT(THIS.ctmCriterios.cAliasColumnas)
			GO TOP
			THIS.cmdAceptar.ENABLED = RECCOUNT(THIS.ctmCriterios.cAliasColumnas)>0
		ENDIF
	ENDPROC


	PROCEDURE visible_assign
		LPARAMETERS tlVisible

		IF tlVisible
			THIS.Visible = tlVisible
			THIS.grdCriterios.SETFOCUS()
		ELSE
			THIS.Visible = tlVisible
		ENDIF

		*!*	IF TYPE("THISFORM")<>'O'
		*!*		RETURN
		*!*	ENDIF

		*!*	FOR I=1 TO THISFORM.CONTROLCOUNT
		*!*		IF THISFORM.CONTROLS(I).NAME <> THIS.NAME
		*!*			IF TYPE("THISFORM.CONTROLS(I).ENABLED")="L"
		*!*				IF !THISFORM.CONTROLS(I).ENABLED AND tlVisible
		*!*					THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
		*!*				ENDIF
		*!*				IF ! TRANSFORM(I,'@JL 99') $ THIS.TAG
		*!*					THISFORM.CONTROLS(I).ENABLED = !tlVisible
		*!*				ENDIF
		*!*			ENDIF
		*!*		ENDIF
		*!*	ENDFOR

		IF TYPE("THIS.PARENT.CONTROLCOUNT") == "N"	&& Si es un contenedor
			FOR I=1 TO THIS.PARENT.CONTROLCOUNT
				IF THIS.PARENT.CONTROLS(I).NAME == THIS.NAME OR THIS.PARENT.CONTROLS(I).BASECLASS = "Label"
					LOOP
				ENDIF
				IF TYPE("THIS.PARENT.CONTROLS(I).ENABLED")<>"L"
					LOOP
				ENDIF
				IF !THIS.PARENT.CONTROLS(I).ENABLED AND tlVisible
					*THIS.TAG = THIS.TAG + TRANSFORM(lnTotal+I,'@JL 99') + ","
					THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
				ENDIF
				*IF ! TRANSFORM(lnTotal+I,'@JL 99') $ THIS.TAG
				IF ! TRANSFORM(I,'@JL 99') $ THIS.TAG
					THIS.PARENT.CONTROLS(I).ENABLED = !tlVisible
				ENDIF
			ENDFOR
		ENDIF
	ENDPROC


	PROCEDURE Init
		LOCAL lnMaxHeight , lnMaxWidth
		WITH THIS
			DODEFAULT()
			THIS.TAG = SPACE(0)
			.grdCriterios.INIT()
			.grdCriterios.RECORDSOURCE = ""
			.grdCriterios.RECORDSOURCETYPE = 4

			lnMaxHeight	= IIF(THISFORM.HEIGHT-6<387,THISFORM.HEIGHT-6,387)
			lnMaxWidth	= IIF(THISFORM.WIDTH-6<386,THISFORM.WIDTH-6,386)


			.TOP	= INT((THISFORM.HEIGHT-lnMaxHeight)/2)
			.LEFT	= INT((THISFORM.WIDTH-lnMaxWidth)/2)
			.HEIGHT = lnMaxHeight
			.WIDTH	= lnMaxWidth
		*	.VISIBLE = .VISIBLE
			.ctmCriterios.VincularGrid(.grdCriterios)
			.cNombreEntidad = .cNombreEntidad
			IF !EMPTY(.cNombreEntidad) AND !ISNULL(.cNombreEntidad)
				.ctmCriterios.ConfigurarGridCriterios()
			ENDIF
		ENDWITH
	ENDPROC


	PROCEDURE cmdaceptar.Click
		THIS.PARENT.cWhereSQL = THIS.PARENT.ctmCriterios.GenerarWhereSQLCriterios()
		THIS.PARENT.cLiteralCriterios = THIS.PARENT.ctmCriterios.cLiteralCriterios
		THIS.PARENT.VISIBLE = .f.
	ENDPROC


	PROCEDURE cmdcancelar.Click
		THIS.PARENT.VISIBLE = .f.
	ENDPROC


	PROCEDURE grdcriterios.Column1.Text1.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl

		DO CASE
		CASE nKeyCode == 13	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Enter
			THIS.PARENT.PARENT.Column3.cmdHelp.CLICK()
		CASE nKeyCode == 7	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Suprimir
			THIS.PARENT.PARENT.Column3.cmdHelp.RIGHTCLICK()
		ENDCASE
	ENDPROC


	PROCEDURE grdcriterios.Column2.Text1.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl

		DO CASE
		CASE nKeyCode == 13	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Enter
			THIS.PARENT.PARENT.Column3.cmdHelp.CLICK()
		CASE nKeyCode == 7	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Suprimir
			THIS.PARENT.PARENT.Column3.cmdHelp.RIGHTCLICK()
		ENDCASE
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_criterios_seleccion
**************************************************


**************************************************
*-- Class:        base_rango_codigos (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   05/15/07 01:52:11 AM
*
DEFINE CLASS base_rango_codigos AS base_container


	Width = 493
	Height = 105
	*-- Cursor que se genera con los registros de donde se extrae el  rango inicial
	ccursordesde = ('C_Desde')
	*-- Cursor que se genera con los registros de donde se extrae el  rango final
	ccursorhasta = ('C_hasta')
	cdescripciondesde = ('Desde')
	cdescripcionhasta = ('Hasta')
	*-- Nombre de la entidad de donde se extrae el rango de codigos
	centidad_desdehasta = ('')
	ccamporetorno = ('')
	ccampovisualizacion = ('')
	cvaloresfiltro = ('')
	ccamposfiltro = ('')
	corderby_desde = ([])
	corderby_hasta = ([])
	*-- Campo de busqueda, por defecto es el campo de la segunda columna del cursor
	ccampobusqueda = "=[]"
	_memberdata = [<VFPData><memberdata name="ccampobusqueda" type="property" display="cCampoBusqueda"/></VFPData>]
	Name = "base_rango_codigos"
	shpBorde.Top = 3
	shpBorde.Left = 0
	shpBorde.Height = 81
	shpBorde.Width = 444
	shpBorde.BackStyle = 1
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"


	ADD OBJECT txtdesde AS base_textbox_cmdhelp WITH ;
		Top = 28, ;
		Left = 12, ;
		Width = 456, ;
		Height = 24, ;
		ZOrderSet = 1, ;
		cetiqueta = ("Desde"), ;
		Name = "txtDesde", ;
		txtCodigo.FontSize = 8, ;
		txtCodigo.Left = 41, ;
		txtCodigo.ToolTipText = "Dejarlo vacío implica todos", ;
		txtCodigo.Top = 0, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdHelp.Top = 0, ;
		cmdHelp.Left = 128, ;
		cmdHelp.ToolTipText = "Haga click aqui para obtener una lista de ayuda", ;
		cmdHelp.Name = "cmdHelp", ;
		txtDescripcion.FontSize = 8, ;
		txtDescripcion.Height = 24, ;
		txtDescripcion.Left = 154, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 264, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.FontBold = .T., ;
		lblCaption.Caption = "Desde", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT txthasta AS base_textbox_cmdhelp WITH ;
		Top = 52, ;
		Left = 12, ;
		Width = 456, ;
		Height = 24, ;
		ZOrderSet = 2, ;
		cetiqueta = ("Hasta"), ;
		Name = "TxtHasta", ;
		txtCodigo.FontSize = 8, ;
		txtCodigo.Left = 41, ;
		txtCodigo.ToolTipText = "Dejarlo vacío implica todos", ;
		txtCodigo.Top = 0, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdHelp.Top = 0, ;
		cmdHelp.Left = 128, ;
		cmdHelp.ToolTipText = "Haga click aqui para obtener una lista de ayuda", ;
		cmdHelp.Name = "cmdHelp", ;
		txtDescripcion.FontSize = 8, ;
		txtDescripcion.Height = 24, ;
		txtDescripcion.Left = 155, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 264, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.FontBold = .T., ;
		lblCaption.Caption = "Hasta", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT lbldescripcion AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 10, ;
		FontCondense = .F., ;
		Caption = "Rango de codigos", ;
		Height = 18, ;
		Left = 10, ;
		Top = 2, ;
		Width = 116, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 3, ;
		Name = "LblDescripcion"


	PROCEDURE Init
		this.txtDesde.cnombreentidad = this.centidad_desdehasta 
		this.txtHasta.cnombreentidad = this.centidad_desdehasta 

		This.txtDesde.caliascursor = this.ccursordesde
		this.txtdesde.ccamporetorno = this.ccamporetorno 
		this.txtdesde.cetiqueta = this.cdescripciondesde 
		this.txtDesde.ccampovisualizacion = this.ccampovisualizacion 
		this.txtDesde.ccamposfiltro = this.ccamposfiltro 
		this.txtDesde.cvaloresfiltro = this.cvaloresfiltro 
		THIS.TxtDesde.cOrderBy= this.cOrderBy_Desde 
		this.TxtDesde.cCampoBusqueda = this.cCampoBusqueda 

		This.txtHasta.caliascursor = this.ccursorhasta
		this.txtHasta.ccamporetorno = this.ccamporetorno 
		this.txtHasta.cetiqueta = this.cdescripciondesde 
		this.txtHasta.ccampovisualizacion = this.ccampovisualizacion 
		this.txtHasta.ccamposfiltro = this.ccamposfiltro 
		this.txtHasta.cvaloresfiltro = this.cvaloresfiltro 
		THIS.TxtHasta.cOrderBy= this.cOrderBy_Hasta
		this.TxtHasta.cCampoBusqueda = this.cCampoBusqueda 
	ENDPROC


	PROCEDURE GotFocus
		this.Init 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_rango_codigos
**************************************************


**************************************************
*-- Class:        base_textbox_cmdhelp_contenedor (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   06/01/00 03:30:06 PM
*
DEFINE CLASS base_textbox_cmdhelp_contenedor AS base_container


	Width = 409
	Height = 84
	BorderWidth = 0
	SpecialEffect = 2
	BackColor = RGB(223,223,223)
	Name = "base_textbox_cmdhelp_contenedor"
	shpBorde.Name = "shpBorde"

	*-- Es una sentencia en lenguwaje SQL que se le añade a la Sentencia WHERE que genera la clase interna
	cwheresql = .F.


	ADD OBJECT base_shape1 AS base_shape WITH ;
		Top = 1, ;
		Left = 1, ;
		Height = 83, ;
		Width = 408, ;
		Name = "Base_shape1"


	ADD OBJECT cnt_codigo AS base_textbox_cmdhelp WITH ;
		Top = 12, ;
		Left = 12, ;
		Width = 384, ;
		Height = 24, ;
		Name = "cnt_Codigo", ;
		txtCodigo.Height = 24, ;
		txtCodigo.Left = 60, ;
		txtCodigo.Top = 0, ;
		txtCodigo.Width = 60, ;
		txtCodigo.Name = "txtCodigo", ;
		cmdHelp.Top = 0, ;
		cmdHelp.Left = 132, ;
		cmdHelp.Name = "cmdHelp", ;
		txtDescripcion.Left = 168, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT cmdaceptar AS cmdaceptar WITH ;
		Top = 48, ;
		Left = 168, ;
		Default = .T., ;
		Name = "cmdAceptar"


	ADD OBJECT cmdcancelar AS cmdcancelar WITH ;
		Top = 48, ;
		Left = 216, ;
		Cancel = .T., ;
		Name = "cmdCancelar"


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		THIS.cWhereSQL = tcWhereSQL
		THIS.cnt_Codigo.cWhereSQL = tcWhereSQL
	ENDPROC


	PROCEDURE visible_assign
		LPARAMETERS tlVisible
		THIS.Visible = tlVisible
		THIS.cnt_Codigo.VISIBLE = tlVisible
		IF tlVisible
			THIS.cnt_Codigo.VALUE = ""
			THIS.cnt_Codigo.SETFOCUS()
		ELSE
			THIS.cnt_Codigo.LOSTFOCUS()
		ENDIF

		IF TYPE("THISFORM")<>'O'
			RETURN
		ENDIF

		FOR I=1 TO THISFORM.CONTROLCOUNT
			IF THISFORM.CONTROLS(I).NAME <> THIS.NAME
				IF TYPE("THISFORM.CONTROLS(I).ENABLED")="L"
					IF !THISFORM.CONTROLS(I).ENABLED AND tlVisible
						THIS.TAG = THIS.TAG + TRANSFORM(I,'@JL 99') + ","
					ENDIF
					IF ! TRANSFORM(I,'@JL 99') $ THIS.TAG
						THISFORM.CONTROLS(I).ENABLED = !tlVisible
					ENDIF
				ENDIF
			ENDIF
		ENDFOR
	ENDPROC


	PROCEDURE Init
		*!*	Forzar el método Assign de la Propiedad
		THIS.cWhereSQL = THIS.cWhereSQL
	ENDPROC


	PROCEDURE cmdaceptar.Click
		THIS.PARENT.VISIBLE = .F.
	ENDPROC


	PROCEDURE cmdcancelar.Click
		THIS.PARENT.VISIBLE = .F.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox_cmdhelp_contenedor
**************************************************


**************************************************
*-- Class:        cnt_cab_almacen (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   03/18/03 10:18:11 PM
*
DEFINE CLASS cnt_cab_almacen AS base_container


	Width = 635
	Height = 56
	entidadcorrelativo = "ALMCDOCM"
	Name = "cnt_cab_almacen"
	shpBorde.Top = 11
	shpBorde.Left = 0
	shpBorde.Height = 44
	shpBorde.Width = 636
	shpBorde.Name = "shpBorde"


	ADD OBJECT cbotipmov AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "\<Ingreso      ,\<Salida        ,\<Transferencia", ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 213, ;
		SpecialEffect = 0, ;
		TabIndex = 5, ;
		Top = 24, ;
		Width = 142, ;
		BackColor = RGB(230,255,255), ;
		Name = "CboTipMov"


	ADD OBJECT base_label_shape1 AS base_label_shape WITH ;
		Caption = "Almacen", ;
		Height = 17, ;
		Left = 10, ;
		Top = 8, ;
		Width = 60, ;
		TabIndex = 1, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Base_label_shape1"


	ADD OBJECT base_label_shape2 AS base_label_shape WITH ;
		Caption = "Tipo", ;
		Left = 208, ;
		Top = 8, ;
		TabIndex = 2, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Base_label_shape2"


	ADD OBJECT base_label_shape3 AS base_label_shape WITH ;
		Caption = "Transacción", ;
		Height = 17, ;
		Left = 357, ;
		Top = 8, ;
		Width = 72, ;
		TabIndex = 3, ;
		ForeColor = RGB(0,0,255), ;
		Name = "Base_label_shape3"


	ADD OBJECT cboalmacen AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 24, ;
		Left = 3, ;
		TabIndex = 4, ;
		Top = 24, ;
		Width = 207, ;
		ZOrderSet = 32, ;
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
		Left = 358, ;
		TabIndex = 6, ;
		Top = 24, ;
		Width = 271, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almcftra", ;
		ccamporetorno = "CodMov", ;
		ccampovisualizacion = "DesMov", ;
		ccamposfiltro = "Tipmov", ;
		cwheresql = "", ;
		caliascursor = "c_Movi", ;
		Name = "CboCodMov"


	PROCEDURE configuracontroles
		PARAMETERS xreturn,lNuevo,lGrabado,Que_Transaccion


		WITH THIS
			.CboAlmacen.ENABLED		= .T.
			.cboTipMov.ENABLED		= xReturn <> "E"  && .T.
			.cboCodMov.ENABLED		= xReturn <> "E"  && .T.
			.cboTipMov.ENABLED		= lNuevo
			.cboCodMov.ENABLED		= lNuevo
			.CboTipMov.VALUE		= ''
			.CboCodMov.VALUE		= ''
			.CboAlmacen.VALUE		= GsSubAlm
		ENDWITH
	ENDPROC


	PROCEDURE iniciar_var
		WITH this
			.CboAlmacen.ENABLED		= .F.
			.CboTipMov.ENABLED		= .F.
			.CboCodMov.ENABLED		= .F.
			.CboAlmacen.VALUE 		= gsSubAlm 
			.CboTipMov.Listindex  	= 1
		ENDWITH
	ENDPROC


	PROCEDURE cbotipmov.InteractiveChange
		IF LEFT(THIS.VALUE,1)=[T]
			THIS.PARENT.cboCodMov.cValoresFiltro = [S]
			THIS.PARENT.cboCodMov.cWhereSql       = [ AND TRANSF]
		ELSE
			THIS.PARENT.cboCodMov.cValoresFiltro = LEFT(THIS.VALUE,1)
			THIS.PARENT.cboCodMov.cWhereSql = ''
		ENDIF
		this.parent.cboCodMov.GenerarCursor()
		This.Parent.CboCodMov.VALUE = ''
	ENDPROC


	PROCEDURE cboalmacen.ProgrammaticChange
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		=seek(This.Value,"alma","alma01")

		goCfgAlm.CodSed = alma.CodSed
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
	ENDPROC


	PROCEDURE cbocodmov.InteractiveChange
		WITH THISFORM
			IF .xReturn='I'				&& Solo cuando se Inserta un registro
				.Vincular_Controles()
			ENDIF
			WITH thisform.PgfDetalle.pages(1)
				.TxtFchDoc.SetFocus
			ENDWITH
			WITH thisform.PgfDetalle.pages(2)
				.CmdAdicionar1.ENABLED = .T.
			ENDWITH
		ENDWITH
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cnt_cab_almacen
**************************************************


**************************************************
*-- Class:        cnt_cab_ventas (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   07/26/06 12:27:12 AM
*
DEFINE CLASS cnt_cab_ventas AS base_container


	Width = 651
	Height = 51
	entidadcorrelativo = "VTATDOCM"
	Name = "cnt_cab_ventas"
	shpBorde.Top = 1
	shpBorde.Left = 3
	shpBorde.Height = 50
	shpBorde.Width = 645
	shpBorde.Name = "shpBorde"


	ADD OBJECT base_label_shape1 AS base_label_shape WITH ;
		Caption = "Punto de venta", ;
		Height = 17, ;
		Left = 5, ;
		Top = 28, ;
		Width = 84, ;
		TabIndex = 6, ;
		ForeColor = RGB(0,0,255), ;
		DisabledForeColor = RGB(0,0,153), ;
		Name = "Base_label_shape1"


	ADD OBJECT cboptovta AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 91, ;
		TabIndex = 2, ;
		Top = 24, ;
		Width = 156, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "vtaptovt", ;
		ccamporetorno = "ptovta", ;
		ccampovisualizacion = "nombre", ;
		ccamposfiltro = "sede", ;
		cvaloresfiltro = ('001'), ;
		cwheresql = "", ;
		caliascursor = "c_ptovta", ;
		Name = "CboPtoVta"


	ADD OBJECT cmdcostos1 AS cmdcostos WITH ;
		Top = 5, ;
		Left = 545, ;
		Height = 40, ;
		Width = 96, ;
		Caption = "\<Lista de precios", ;
		TabIndex = 5, ;
		PicturePosition = 7, ;
		Name = "Cmdcostos1"


	ADD OBJECT cbocodven AS base_cbohelp WITH ;
		FontSize = 9, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 321, ;
		TabIndex = 3, ;
		Top = 5, ;
		Width = 120, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfVen), ;
		cwheresql = "", ;
		caliascursor = "C_vend", ;
		Name = "CboCodVen"


	ADD OBJECT lblcodven AS base_label WITH ;
		FontSize = 9, ;
		Caption = "Vendedor", ;
		Height = 17, ;
		Left = 261, ;
		Top = 7, ;
		Width = 55, ;
		TabIndex = 9, ;
		DisabledForeColor = RGB(0,0,153), ;
		Name = "LblCodVen"


	ADD OBJECT cbotipofact AS base_cbohelp WITH ;
		FontSize = 9, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 320, ;
		TabIndex = 4, ;
		Top = 25, ;
		Width = 156, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "cbdmtabl", ;
		ccamporetorno = "CodRef", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "Tabla", ;
		cvaloresfiltro = ("TF"), ;
		cwheresql = "", ;
		caliascursor = "c_tipoFact", ;
		Name = "CboTipoFact"


	ADD OBJECT base_label1 AS base_label WITH ;
		FontSize = 9, ;
		Caption = "En base a", ;
		Height = 17, ;
		Left = 259, ;
		Top = 28, ;
		Width = 58, ;
		TabIndex = 8, ;
		DisabledForeColor = RGB(0,0,153), ;
		Name = "Base_label1"


	ADD OBJECT base_label_shape2 AS base_label_shape WITH ;
		Caption = "Documento", ;
		Height = 17, ;
		Left = 13, ;
		Top = 7, ;
		Width = 75, ;
		TabIndex = 7, ;
		ForeColor = RGB(0,0,255), ;
		DisabledForeColor = RGB(0,0,153), ;
		Name = "Base_label_shape2"


	ADD OBJECT cbocoddoc AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 91, ;
		TabIndex = 1, ;
		Top = 5, ;
		Width = 156, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "sistdocs", ;
		ccamporetorno = "coddoc", ;
		ccampovisualizacion = "desdoc", ;
		ccamposfiltro = "", ;
		cwheresql = ("and ventas = .t."), ;
		caliascursor = "c_coddoc", ;
		Name = "CboCodDoc"


	PROCEDURE iniciar_var
		WITH THIS
			LOCAL i
			FOR i = 1 to .ControlCount
				.Controls(i).Enabled  = .F.
		*		.Controls(i).Visible  = .F.
			NEXT 
		ENDWITH
	ENDPROC


	PROCEDURE limpiar_var
		WITH THIS
			LOCAL i
			FOR i = 1 to .ControlCount
				IF INLIST(UPPER(.Controls(i).Class),'BASE_CBOHELP')
					.Controls(i).Value = SPACE(LEN(EVALUATE(.CONTROLS(I).CALIASCURSOR+'.'+.CONTROLS(I).CCAMPORETORNO)))
				ENDIF

		*		.Controls(i).Visible  = .F.
			NEXT 
		ENDWITH
	ENDPROC


	PROCEDURE cboptovta.Valid
		thisform.ObjReftran.XsPtoVta = THIS.VAlue
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


	PROCEDURE cboptovta.ProgrammaticChange
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cvaloresfiltro = GsCodSed
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.cWhereSql = ' AND subalm <> GoCfgAlm.SubAlm'
		*!*	Thisform.pgfdetalle.page1.cboAlmOri.generarcursor()

		*!*	=seek(This.Value,"alma","alma01")

		*!*	goCfgAlm.CodSed = alma.CodSed
	ENDPROC


	PROCEDURE cmdcostos1.Click
		DO FORM funVta_vtap1500
	ENDPROC


	PROCEDURE cbocodven.Valid
		thisform.objreftran.XsCodVen = This.value
	ENDPROC


	PROCEDURE cbotipofact.InteractiveChange
		*!*	GoGfgVta.XsCodRef=this.Value
		this.Parent.Parent.ObjRefTran.XsCodRef = this.value 
		this.Parent.Parent.ObjRefTran.XnTpoFac = this.ListIndex 
		*!*	IF VARTYPE(THISFORM.CmdDespacho)='O'
		*!*		thisform.CmdDespacho.Visible = INLIST(This.Value,'FREE','G/R')
		*!*	ENDIF
	ENDPROC


	PROCEDURE cbocoddoc.InteractiveChange
		=goCfgVta.Abrir_Dbfs_Vta(this.value)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cnt_cab_ventas
**************************************************


**************************************************
*-- Class:        cntdoc_ref (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   12/03/06 11:31:12 PM
*
DEFINE CLASS cntdoc_ref AS base_container


	Width = 435
	Height = 198
	*-- Cursor en donde se guardan los documentos de referencia.
	ccursor_ref = ([])
	*-- Valor de clave de referencia para  accesar la tabla.
	cvalpk_ref = ([])
	*-- Campos que conforma la clave de referencia
	ccmppk_ref = ([])
	*-- Tabla de donde se extraen los documentos de referencia.
	ctabla_ref = ([])
	*-- Numero de documentos de referencia seleccionados
	cnrodocs_ref = ("")
	Name = "cntdoc_ref"
	shpBorde.Top = 4
	shpBorde.Left = 6
	shpBorde.Height = 191
	shpBorde.Width = 426
	shpBorde.BorderWidth = 2
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"


	ADD OBJECT grid1 AS base_grid WITH ;
		ColumnCount = 4, ;
		Height = 153, ;
		Left = 23, ;
		Panel = 1, ;
		RecordSource = "", ;
		RecordSourceType = 0, ;
		Top = 35, ;
		Width = 303, ;
		Name = "grid1", ;
		Column1.ControlSource = "", ;
		Column1.Width = 61, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.ControlSource = "", ;
		Column2.CurrentControl = "Text1", ;
		Column2.Width = 93, ;
		Column2.ReadOnly = .T., ;
		Column2.Sparse = .F., ;
		Column2.Name = "Column2", ;
		Column3.CurrentControl = "Base_textbox_fecha1", ;
		Column3.Width = 96, ;
		Column3.ReadOnly = .T., ;
		Column3.Name = "Column3", ;
		Column4.CurrentControl = "Base_checkbox1", ;
		Column4.Width = 23, ;
		Column4.Sparse = .F., ;
		Column4.Name = "Column4"


	ADD OBJECT cntdoc_ref.grid1.column1.header1 AS header WITH ;
		Caption = "Ti`po doc.", ;
		Name = "Header1"


	ADD OBJECT cntdoc_ref.grid1.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntdoc_ref.grid1.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		Caption = "Numero", ;
		Name = "Header1"


	ADD OBJECT cntdoc_ref.grid1.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntdoc_ref.grid1.column3.header1 AS header WITH ;
		Caption = "Fecha", ;
		Name = "Header1"


	ADD OBJECT cntdoc_ref.grid1.column3.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntdoc_ref.grid1.column3.base_textbox_fecha1 AS base_textbox_fecha WITH ;
		Left = 18, ;
		ReadOnly = .T., ;
		Top = 32, ;
		Name = "Base_textbox_fecha1"


	ADD OBJECT cntdoc_ref.grid1.column4.header1 AS header WITH ;
		FontName = "Marlett", ;
		Caption = "a", ;
		Name = "Header1"


	ADD OBJECT cntdoc_ref.grid1.column4.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntdoc_ref.grid1.column4.base_checkbox1 AS base_checkbox WITH ;
		Top = 20, ;
		Left = 36, ;
		Alignment = 0, ;
		Caption = "", ;
		Name = "Base_checkbox1"


	ADD OBJECT lbltitulo AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 12, ;
		Caption = "Guias   por   cliente", ;
		Height = 22, ;
		Left = 120, ;
		Top = 12, ;
		Width = 146, ;
		ForeColor = RGB(255,0,0), ;
		Name = "LblTitulo"


	ADD OBJECT cmdaceptar2 AS cmdprocesar WITH ;
		Top = 131, ;
		Left = 332, ;
		Height = 55, ;
		Width = 48, ;
		Picture = "..\..\grafgen\iconos\volver.ico", ;
		Caption = "\<Volver", ;
		ZOrderSet = 5, ;
		Name = "CmdAceptar2"


	ADD OBJECT cmdprocesar1 AS cmdprocesar WITH ;
		Top = 84, ;
		Left = 330, ;
		Height = 24, ;
		Width = 96, ;
		Picture = "..\..\bsinfo\", ;
		Caption = "\<Desmarcar Todos", ;
		ZOrderSet = 5, ;
		Name = "Cmdprocesar1"


	ADD OBJECT cmdprocesar3 AS cmdprocesar WITH ;
		Top = 53, ;
		Left = 330, ;
		Height = 24, ;
		Width = 96, ;
		Picture = "..\..\bsinfo\", ;
		Caption = "\<Invertir Selección", ;
		ZOrderSet = 5, ;
		Name = "Cmdprocesar3"


	PROCEDURE iniciar_var

		this.grid1.RECORDSOURCETYPE	= 1
		this.grid1.RECORDSOURCE		= this.ccursor_local  && "AUXI"

		this.grid1.COLUMNS(1).CONTROLSOURCE	= this.ccursor_local+'.CODDOC'
		this.grid1.COLUMNS(2).CONTROLSOURCE	= this.ccursor_local+'.NRODOC'
		this.grid1.COLUMNS(3).CONTROLSOURCE	= this.ccursor_local+'.FCHDOC'
		this.grid1.COLUMNS(4).CONTROLSOURCE	= this.ccursor_local+'.SELEC'
		this.grid1.refresh
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		this.Parent.cnrodocs_ref = ''
		SELECT (this.Parent.ccursor_local) 
		SCAN 
			IF selec 
				replace FlgEst	WITH '*'
				this.Parent.cnrodocs_ref = this.Parent.cnrodocs_ref + NroDoc+','
			ELSE
				replace Flgest WITH ''
			ENDIF

		ENDSCAN
		LOCATE
		LnPos = RAT(',',this.Parent.cnrodocs_ref)
		this.Parent.cnrodocs_ref = IIF(LnPos>0,LEFT(this.Parent.cnrodocs_ref,LnPos-1),this.Parent.cnrodocs_ref)
		*thisform.ObjCntPage.TxtNroRef.Valid()

		*thisform.LockScreen = .T.
		this.Parent.Visible = .F.
		thisform.Refresh

		thisform.PgfDetalle.Activepage=2
		thisform.PgfDetalle.Activepage=1
		IF !EMPTY(this.Parent.cnrodocs_ref)
			DO CASE 
				CASE UPPER(Thisform.Name) = 'TRANSACCIONVENTA'
					thisform.PgfDetalle.PAGES(1).TxtGlosa2.Value = this.Parent.cnrodocs_ref
		 		CASE UPPER(Thisform.Name) = 'GUIAREMISION'
					thisform.PgfDetalle.PAGES(1).TxtObserv.Value = this.Parent.cnrodocs_ref
			ENDCASE 
			IF VARTYPE(thisform.ObjCntPage) = 'O'
				thisform.ObjCntPage.TxtNroRef.SetFocus()
				KEYBOARD '{END}'+'{ENTER}'
			ELSE

			ENDIF
		ENDIF}

		*thisform.LockScreen = .f.
	ENDPROC


	PROCEDURE cmdprocesar1.Click
		IF This.Caption="\<Desmarcar Todos"
			replace all selec with .f.
			GO TOP
			This.Caption="\<Marcar Todos"
			THIS.PARENT.GRID1.REFRESH
		ELSE
			replace all selec with .T.
			GO TOP
			This.Caption="\<Desmarcar Todos"
			THIS.PARENT.GRID1.REFRESH
		ENDIF
	ENDPROC


	PROCEDURE cmdprocesar3.Click
		SCAN
			IF selec
				replace selec with .f. 
			ELSE
				replace selec with .T. 
			ENDIF
		ENDSCAN
		GO TOP
		THIS.PARENT.GRID1.REFRESH
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntdoc_ref
**************************************************


**************************************************
*-- Class:        cntnotaseeff (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   03/26/04 10:37:14 PM
*
DEFINE CLASS cntnotaseeff AS base_container


	Width = 661
	Height = 206
	Name = "cntnotaseeff"
	shpBorde.Top = 1
	shpBorde.Left = 1
	shpBorde.Height = 204
	shpBorde.Width = 647
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"
	ccursor = .F.
	flagedicion = .F.

	*-- Campos de la Clave
	ccmpkey = .F.

	*-- Valor de la clave
	cvalkey = .F.


	ADD OBJECT grddetalle AS base_grid WITH ;
		ColumnCount = 5, ;
		FontSize = 10, ;
		Height = 150, ;
		Left = 12, ;
		Panel = 1, ;
		RecordSourceType = 4, ;
		RowHeight = 19, ;
		Top = 6, ;
		Width = 552, ;
		ZOrderSet = 1, ;
		Name = "GrdDetalle", ;
		Column1.FontName = "Arial", ;
		Column1.FontSize = 10, ;
		Column1.Width = 33, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.FontName = "Arial", ;
		Column2.FontSize = 10, ;
		Column2.CurrentControl = "TxtCodCta", ;
		Column2.Width = 97, ;
		Column2.ReadOnly = .T., ;
		Column2.BackColor = RGB(230,255,255), ;
		Column2.Name = "Column2", ;
		Column3.FontName = "Arial", ;
		Column3.FontSize = 10, ;
		Column3.ColumnOrder = 4, ;
		Column3.CurrentControl = "CboSigno", ;
		Column3.Enabled = .F., ;
		Column3.Width = 101, ;
		Column3.ReadOnly = .T., ;
		Column3.Sparse = .F., ;
		Column3.BackColor = RGB(230,255,255), ;
		Column3.Name = "Column4", ;
		Column4.FontName = "Arial", ;
		Column4.FontSize = 10, ;
		Column4.ColumnOrder = 5, ;
		Column4.CurrentControl = "CboTipoSaldo", ;
		Column4.Enabled = .F., ;
		Column4.Width = 109, ;
		Column4.ReadOnly = .T., ;
		Column4.Sparse = .F., ;
		Column4.Name = "Column5", ;
		Column5.FontName = "Arial", ;
		Column5.FontSize = 10, ;
		Column5.ColumnOrder = 3, ;
		Column5.Width = 183, ;
		Column5.ReadOnly = .T., ;
		Column5.Name = "Column3"


	ADD OBJECT cntnotaseeff.grddetalle.column1.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nota", ;
		Name = "Header1"


	ADD OBJECT cntnotaseeff.grddetalle.column1.txtnota AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtNota"


	ADD OBJECT cntnotaseeff.grddetalle.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Cuenta", ;
		Name = "Header1"


	ADD OBJECT cntnotaseeff.grddetalle.column2.txtcodcta AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		ControlSource = "", ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtCodCta"


	ADD OBJECT cntnotaseeff.grddetalle.column4.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Signo", ;
		Name = "Header1"


	ADD OBJECT cntnotaseeff.grddetalle.column4.txtsigno AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(230,255,255), ;
		Name = "TxtSigno"


	ADD OBJECT cntnotaseeff.grddetalle.column4.cbosigno AS base_cbohelp WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Enabled = .T., ;
		Left = 29, ;
		SpecialEffect = 1, ;
		Style = 2, ;
		Top = 23, ;
		cnombreentidad = "cbdmtabl", ;
		ccamporetorno = "Codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "tabla", ;
		cvaloresfiltro = ([SB]), ;
		caliascursor = "C_Signo", ;
		Name = "CboSigno"


	ADD OBJECT cntnotaseeff.grddetalle.column5.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Tipo saldo", ;
		Name = "Header1"


	ADD OBJECT cntnotaseeff.grddetalle.column5.txttiposaldo AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		SpecialEffect = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtTipoSaldo"


	ADD OBJECT cntnotaseeff.grddetalle.column5.cbotiposaldo AS base_cbohelp WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Enabled = .T., ;
		Left = 37, ;
		SpecialEffect = 1, ;
		Style = 2, ;
		Top = 23, ;
		cnombreentidad = "cbdmtabl", ;
		ccamporetorno = "codigo", ;
		ccampovisualizacion = "Nombre", ;
		ccamposfiltro = "tabla", ;
		cvaloresfiltro = ([TS]), ;
		caliascursor = "c_TSaldo", ;
		Name = "CboTipoSaldo"


	ADD OBJECT cntnotaseeff.grddetalle.column3.header1 AS header WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		Caption = "Nombre", ;
		Name = "Header1"


	ADD OBJECT cntnotaseeff.grddetalle.column3.txtnomcta AS textbox WITH ;
		FontName = "Arial", ;
		FontSize = 10, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "TxtNomCta"


	ADD OBJECT cmdadicionar2 AS cmdnuevo WITH ;
		Top = 72, ;
		Left = 588, ;
		Height = 24, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 2, ;
		Visible = .F., ;
		Name = "CmdAdicionar2"


	ADD OBJECT cmdmodificar2 AS cmdmodificar WITH ;
		Top = 12, ;
		Left = 588, ;
		Height = 36, ;
		Width = 48, ;
		WordWrap = .T., ;
		Caption = "\<Modificar Detalle", ;
		Enabled = .F., ;
		TabIndex = 3, ;
		Name = "Cmdmodificar2"


	ADD OBJECT cmdeliminar2 AS cmdeliminar WITH ;
		Top = 108, ;
		Left = 588, ;
		Height = 24, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 4, ;
		Visible = .F., ;
		Name = "Cmdeliminar2"


	ADD OBJECT lblgrid AS base_label WITH ;
		Caption = "Observaciones", ;
		Height = 17, ;
		Left = 16, ;
		Top = 180, ;
		Width = 85, ;
		TabIndex = 14, ;
		ZOrderSet = 5, ;
		Name = "LblGrid"


	ADD OBJECT cmdgrabar2 AS cmdgrabar WITH ;
		Top = 159, ;
		Left = 460, ;
		Height = 38, ;
		Width = 48, ;
		WordWrap = .T., ;
		Caption = "\<Actualiza", ;
		Enabled = .F., ;
		TabIndex = 12, ;
		Visible = .F., ;
		SpecialEffect = 0, ;
		ZOrderSet = 6, ;
		Name = "Cmdgrabar2"


	ADD OBJECT cmdhelpteclas AS base_command WITH ;
		Top = 160, ;
		Left = 402, ;
		Height = 36, ;
		Width = 36, ;
		Picture = "..\..\icons\key04.ico", ;
		Caption = "", ;
		Enabled = .F., ;
		ToolTipText = "Ver referencia de teclas de edición rapida para detalle del asiento", ;
		Visible = .F., ;
		Name = "CmdHelpTeclas"


	ADD OBJECT cmdcancelar2 AS cmdcancelar WITH ;
		Top = 159, ;
		Left = 512, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 18, ;
		Visible = .F., ;
		SpecialEffect = 0, ;
		ZOrderSet = 7, ;
		Name = "Cmdcancelar2"


	PROCEDURE carga_grid
		PARAMETERS LcCursor_D1 ,LcTabla_D1,LcCmpKey,LcValKey
		WITH this.grdDetalle  
			.RECORDSOURCE = ""
			.RECORDSOURCETYPE = 4


		*!*		LsLlave=this.RecordSource+'.Rubro+'+this.RecordSource+'.Nota'
		*!*		LsNota = this.RecordSource+'.Nota'
		*!*		LsNota = EVALUATE(LsNota)
			IF !VARTYPE(LoDatAdm)='O' 
				LOCAL LoDatadm As dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
				LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin') 

			ENDIF
			** ----- **
			THIS.Ccursor_local = LcCursor_D1
			this.cCmpkey = LcCmpKey
			this.cValkey = LcValKey
			** ----- **
			IF USED(LcCursor_D1)
				USE IN (LcCursor_D1)
			ENDIF
			LoDatAdm.GenCursor(LcCursor_D1 ,LcTabla_D1 ,'',LcCmpKey,LcValKey)


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
		PARAMETERS LlHabilita
		THISFORM.LockScreen = .T.
		LOCAL kk ,jj
		WITH THIS.GrdDetalle 
			.Readonly = !LlHabilita
			FOR kk = 1 TO .ColumnCount 

				IF kk = 1	&& EliItm  Siempre lectura
					LOOP
				ENDIF
				.columns(kk).Readonly = !LlHabilita
				FOR jj = 1 TO .columns[kk].controlcount

					IF .columns[kk].controls[jj].baseclass = 'Combobox'
						.columns(kk).Enabled = LlHabilita
					ENDIF
				ENDFOR
			NEXT
			WITH THIS
				.CmdModificar2.Enabled 	= !LlHabilita
				.CmdAdicionar2.Enabled 	= LlHabilita
				.CmdAdicionar2.Visible  = LlHabilita
				.Cmdeliminar2.Enabled 	= LlHabilita
				.Cmdeliminar2.Visible 	= LlHabilita
				.Cmdgrabar2.Enabled 	= LlHabilita
				.CmdCancelar2.Enabled 	= LlHabilita
				.Cmdgrabar2.Visible 	= LlHabilita
				.CmdCancelar2.Visible  	= LlHabilita
				.LblGrid.Caption = IIF(.grdDetalle.ReadOnly,'Consultando','Modificando')
				.CmdHelpTeclas.Visible=LlHabilita
				.CmdHelpTeclas.Enabled=LlHabilita
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
		WITH this.grdDetalle 
			SELECT (.RecordSource)
			IF EMPTY(.column2.txtCodCta.Value) OR (thisform.LcTipOpe = 'I' AND !EMPTY(.column2.txtCodCta.Value))
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
		WITH this.grdDetalle 
			SELECT (.Recordsource)
			APPEND BLANK
			REPLACE Rubro WITH XsRubro
			replace Nota  WITH XsNota
			.Refresh 
			.column2.txtCodCta.SetFocus 
		ENDWITH
	ENDPROC


	PROCEDURE Destroy
		IF TYPE("THIS.grdDetalle")=="O"
			WITH THIS.grdDetalle
				.RECORDSOURCE		= ""
				.RECORDSOURCETYPE	= 4
				.COLUMNCOUNT		= 5
			ENDWITH
		ENDIF
		IF USED(THIS.cCursor)
			USE IN (THIS.cCursor)
		ENDIF
	ENDPROC


	PROCEDURE Init
		THIS.cCursor	= ALLTRIM(IIF(EMPTY(THIS.cCursor) OR ISNULL(THIS.cCursor) , "c_GrdDetalle",THIS.cCursor))
	ENDPROC


	PROCEDURE grddetalle.AfterRowColChange
		LPARAMETERS nColIndex
		DODEFAULT()
	ENDPROC


	PROCEDURE cmdadicionar2.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		thisform.LcTipOpe = 'I'
		this.Parent.Habilita_grid(.T.) 
		this.Parent.agrega_item_grid() 
	ENDPROC


	PROCEDURE cmdmodificar2.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		thisform.LcTipOpe = 'A'
		this.Parent.Habilita_grid(.T.) 
	ENDPROC


	PROCEDURE cmdeliminar2.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		IF MESSAGEBOX("¿Desea Eliminar el Registro?",32+4+256,"Eliminar") <> 6
			RETURN
		ENDIF

		thisform.LcTipOpe =  'A' &&  Siempre actualiza,  ya no es 'E'
		WITH this.Parent.grdDetalle 
			SELECT (.Recordsource)
			DELETE
			.Refresh 
			.column2.txtCodCta.SetFocus 
		ENDWITH
	ENDPROC


	PROCEDURE cmdgrabar2.Click

		IF !INLIST(thisform.LcTipOpe,'I','A') 
				RETURN 
		ENDIF
		LsAlias_D=this.Parent.ccursor_local  
		*DO MovNedit WITH THISFORM.LcTipOpe,LsAlias_D 
		IF EMPTY(&LsAlias_D..CodCta)
			THIS.Parent.CmdCancelar2.Click
		ENDIF
		*!*		LnNroItm  = C_RMOV.NroItm
		**=MOVnGrab(THISFORM.LcTipOpe)
		=graba_detalle(thisform.LcTipOpe,LsAlias_D,this.Parent.ccmpkey,This.Parent.cValKey,'NBAL')
		this.Parent.Habilita_grid(.f.)
		thisform.LcTipOpe = 'C' 
		SELECT (LsAlias_D)
		*!*		LOCATE FOR NroItm = LnNroItm
		this.Parent.grdDetalle.SetFocus
	ENDPROC


	PROCEDURE cmdhelpteclas.Click
		=MESSAGEBOX('CTRL+F10 o CTRL+W Graba linea del detalle '+CRLF + ;
					'F9 Abandonar cambios en la linea del detalle '+CRLF+ ;
					'F8 o Doble Click dentro de un campo para consultar '+CRLF,0,'Teclas de acceso rapido')


	ENDPROC


	PROCEDURE cmdcancelar2.Click
		IF !INLIST(thisform.LcTipOpe,'I','A') 
			RETURN 
		ENDIF
		this.parent.borra_item_blanco_grid() 
		this.Parent.habilita_grid(.f.)
		thisform.LcTipOpe = 'C' 
		*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*!*	LnNroItm  = C_RMOV.NroItm
		*!*	SELECT C_RMOV
		*!*	LOCATE FOR NroItm = LnNroItm

		this.Parent.grdDetalle.SetFocus
		*LnFilaAct = this.Parent.grdDetalle.ActiveRow 
		*this.Parent.grdDetalle.ActivateCell(LnFilaAct,1)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntnotaseeff
**************************************************


**************************************************
*-- Class:        cntpage_almacen (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   04/12/06 11:03:14 AM
*
DEFINE CLASS cntpage_almacen AS base_container


	Width = 649
	Height = 191
	Name = "cntpage_almacen"
	shpBorde.Top = 0
	shpBorde.Left = 0
	shpBorde.Height = 192
	shpBorde.Width = 648
	shpBorde.Name = "shpBorde"


	ADD OBJECT lblglorf1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "LblGloRf1", ;
		Height = 16, ;
		Left = 8, ;
		Top = 35, ;
		Visible = .F., ;
		Width = 49, ;
		TabIndex = 11, ;
		Name = "LblGloRf1"


	ADD OBJECT lblglorf2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "LblGloRf2", ;
		Height = 16, ;
		Left = 8, ;
		Top = 59, ;
		Visible = .F., ;
		Width = 49, ;
		TabIndex = 13, ;
		Name = "LblGlorf2"


	ADD OBJECT lblglorf3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "LblGloRf3", ;
		Height = 16, ;
		Left = 8, ;
		Top = 82, ;
		Visible = .F., ;
		Width = 49, ;
		TabIndex = 15, ;
		Name = "LblGloRf3"


	ADD OBJECT txtnrorf1 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		MaxLength = 10, ;
		TabIndex = 12, ;
		Top = 31, ;
		Visible = .F., ;
		Width = 81, ;
		Name = "TxtNroRf1"


	ADD OBJECT txtnrorf2 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		MaxLength = 10, ;
		TabIndex = 14, ;
		Top = 55, ;
		Visible = .F., ;
		Width = 81, ;
		Name = "TxtNroRf2"


	ADD OBJECT txtnrorf3 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 59, ;
		MaxLength = 10, ;
		TabIndex = 16, ;
		Top = 79, ;
		Visible = .F., ;
		Width = 82, ;
		Name = "TxtNroRf3"


	ADD OBJECT txtnroodt AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 340, ;
		TabIndex = 18, ;
		Top = 6, ;
		Visible = .F., ;
		Width = 61, ;
		Name = "TxtNroOdt"


	ADD OBJECT lblnroodt AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Parte Diario", ;
		Height = 16, ;
		Left = 279, ;
		Top = 8, ;
		Visible = .F., ;
		Width = 57, ;
		TabIndex = 17, ;
		Name = "LblNroOdt"


	ADD OBJECT lblcodprd AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Producto", ;
		Height = 16, ;
		Left = 294, ;
		Top = 79, ;
		Visible = .F., ;
		Width = 45, ;
		TabIndex = 23, ;
		Name = "LblCodPrd"


	ADD OBJECT lblmotivo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Motivo", ;
		Left = 155, ;
		Top = 79, ;
		Visible = .F., ;
		TabIndex = 9, ;
		Name = "LblMotivo"


	ADD OBJECT cbomotivo AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "1,2,3,4", ;
		Value = 1, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 191, ;
		TabIndex = 10, ;
		Top = 77, ;
		Visible = .F., ;
		Width = 96, ;
		Name = "CboMotivo"


	ADD OBJECT lblcodfase AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fase", ;
		Height = 16, ;
		Left = 499, ;
		Top = 9, ;
		Visible = .F., ;
		Width = 26, ;
		TabIndex = 25, ;
		Name = "lblCodFase"


	ADD OBJECT lblcodprocs AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Proceso", ;
		Height = 16, ;
		Left = 483, ;
		Top = 34, ;
		Visible = .F., ;
		Width = 42, ;
		TabIndex = 27, ;
		Name = "lblCodProcs"


	ADD OBJECT lbllotes AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Lote", ;
		Height = 16, ;
		Left = 316, ;
		Top = 29, ;
		Visible = .F., ;
		Width = 23, ;
		TabIndex = 19, ;
		Name = "LblLotes"


	ADD OBJECT lblcultivo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cultivo", ;
		Height = 16, ;
		Left = 304, ;
		Top = 55, ;
		Visible = .F., ;
		Width = 34, ;
		TabIndex = 21, ;
		Name = "LblCultivo"


	ADD OBJECT lblcodactiv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Actividad", ;
		Height = 16, ;
		Left = 479, ;
		Top = 56, ;
		Visible = .F., ;
		Width = 47, ;
		TabIndex = 29, ;
		Name = "lblCodActiv"


	ADD OBJECT cbocodprd AS base_cbohelp WITH ;
		FontSize = 8, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 342, ;
		TabIndex = 24, ;
		Top = 77, ;
		Width = 127, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almcatge", ;
		ccamporetorno = "Codmat", ;
		ccampovisualizacion = "Desmat", ;
		ccamposfiltro = "Tipmat", ;
		cvaloresfiltro = "20;", ;
		caliascursor = "GCodPrd", ;
		Name = "CboCodPrd"


	ADD OBJECT lblcodpar AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Maquinaria", ;
		Height = 16, ;
		Left = 5, ;
		Top = 102, ;
		Visible = .F., ;
		Width = 54, ;
		TabIndex = 31, ;
		Name = "lblCodPar"


	ADD OBJECT lblalmori AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Almacen Destino", ;
		Height = 16, ;
		Left = 12, ;
		Top = 72, ;
		Visible = .F., ;
		Width = 83, ;
		TabIndex = 23, ;
		Name = "lblAlmOri"


	ADD OBJECT lblcodven AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Vendedor", ;
		Height = 16, ;
		Left = 8, ;
		Top = 142, ;
		Visible = .F., ;
		Width = 50, ;
		TabIndex = 33, ;
		Name = "LblCodVen"


	ADD OBJECT lblcodpro AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Proveedor", ;
		Height = 16, ;
		Left = 6, ;
		Top = 122, ;
		Visible = .F., ;
		Width = 52, ;
		TabIndex = 31, ;
		Name = "LblCodPro"


	ADD OBJECT lblcodcli AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cliente", ;
		Height = 16, ;
		Left = 24, ;
		Top = 164, ;
		Visible = .F., ;
		Width = 34, ;
		TabIndex = 35, ;
		Name = "LblCodCli"


	ADD OBJECT cbocodprocs AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 529, ;
		TabIndex = 28, ;
		Top = 31, ;
		Width = 108, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "Cpiprocs", ;
		ccamporetorno = "CodProcs", ;
		ccampovisualizacion = "DesProCs", ;
		caliascursor = "GProcesos", ;
		Name = "CboCodProcs"


	ADD OBJECT cbolotes AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 342, ;
		TabIndex = 20, ;
		Top = 28, ;
		Width = 48, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CpiLotes", ;
		ccamporetorno = "Codlote", ;
		ccampovisualizacion = "Deslote", ;
		ccamposfiltro = "CodSed", ;
		cwheresql = "", ;
		caliascursor = "GLotes", ;
		Name = "CboLotes"


	ADD OBJECT cbocodpar AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 59, ;
		TabIndex = 32, ;
		Top = 99, ;
		Width = 289, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "cbdmpart", ;
		ccamporetorno = "codpar", ;
		ccampovisualizacion = "nompar", ;
		cwheresql = "", ;
		caliascursor = "GCodPar", ;
		Name = "CboCodPar"


	ADD OBJECT cbocodactiv AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 529, ;
		TabIndex = 30, ;
		Top = 54, ;
		Width = 108, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "v_actividades_x_fase_proc", ;
		ccamporetorno = "CodActiv", ;
		ccampovisualizacion = "DesActiv", ;
		ccamposfiltro = "CodFase;CodProcs", ;
		caliascursor = "GActividades", ;
		Name = "cboCodActiv"


	ADD OBJECT cbocodfase AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 528, ;
		TabIndex = 26, ;
		Top = 7, ;
		Width = 109, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CpiFases", ;
		ccamporetorno = "CodFase", ;
		ccampovisualizacion = "DesFase", ;
		caliascursor = "GFases", ;
		Name = "CboCodFase"


	ADD OBJECT cbocultivo AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 341, ;
		TabIndex = 22, ;
		Top = 52, ;
		Width = 127, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "v_cultivos_x_lote", ;
		ccamporetorno = "CodCult", ;
		ccampovisualizacion = "DesCult", ;
		ccamposfiltro = "CodSed;CodLote", ;
		cwheresql = "", ;
		caliascursor = "GCultivos", ;
		Name = "CboCultivo"


	ADD OBJECT cboalmori AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .T., ;
		Height = 20, ;
		Left = 100, ;
		TabIndex = 22, ;
		Top = 68, ;
		Width = 204, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "almtalma", ;
		ccamporetorno = "SubAlm", ;
		ccampovisualizacion = "DesSub", ;
		ccamposfiltro = "codsed", ;
		cvaloresfiltro = "gscodsed", ;
		cwheresql = "", ;
		caliascursor = "c_alma_dest", ;
		Name = "CboAlmOri"


	ADD OBJECT cbocodcli AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		TabIndex = 5, ;
		Top = 160, ;
		Width = 287, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfCli), ;
		cwheresql = "", ;
		caliascursor = "C_Cliente", ;
		Name = "CboCodCli"


	ADD OBJECT cbocodpro AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		TabIndex = 5, ;
		Top = 120, ;
		Width = 288, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfPro), ;
		cwheresql = "", ;
		caliascursor = "C_Proveedor", ;
		Name = "CboCodPro"


	ADD OBJECT cbocodven AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		TabIndex = 5, ;
		Top = 140, ;
		Width = 288, ;
		ZOrderSet = 32, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CbdmAuxi", ;
		ccamporetorno = "codAux", ;
		ccampovisualizacion = "NomAux", ;
		ccamposfiltro = "ClfAux", ;
		cvaloresfiltro = (GsClfVen), ;
		cwheresql = "", ;
		caliascursor = "C_Vendedor", ;
		Name = "CboCodVen"


	ADD OBJECT lbltpocmb AS base_label WITH ;
		FontSize = 8, ;
		Caption = "T/C.", ;
		Left = 114, ;
		Top = 9, ;
		Visible = .F., ;
		TabIndex = 5, ;
		Name = "LblTpoCmb"


	ADD OBJECT txttpocmb AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "99.9999", ;
		Left = 137, ;
		TabIndex = 6, ;
		Top = 5, ;
		Width = 54, ;
		Name = "TxtTpoCmb"


	ADD OBJECT lblcodmon AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Moneda", ;
		Left = 16, ;
		Top = 8, ;
		Visible = .F., ;
		TabIndex = 7, ;
		Name = "LblCodMon"


	ADD OBJECT cbocodmon AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "S/.,US$", ;
		Value = 1, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 59, ;
		TabIndex = 8, ;
		Top = 6, ;
		Width = 49, ;
		Name = "CboCodMon"


	ADD OBJECT chkretencion AS base_checkbox WITH ;
		Top = 156, ;
		Left = 372, ;
		Height = 24, ;
		Width = 155, ;
		Alignment = 0, ;
		Caption = "Agente Retención", ;
		Name = "ChkRetencion"


	PROCEDURE iniciar_var
			with this
				.TxtNroRf1.ENABLED		= .F.
				.TxtNroRf2.ENABLED		= .F.
				.TxtNroRf3.ENABLED		= .F.
				.TxtNroOdt.ENABLED		= .F.
				.CboCodPrd.ENABLED		= .F.
				.CboCodPro.ENABLED		= .F.
				.CboCodVen.ENABLED		= .F.
				.CboCodCli.ENABLED		= .F.
				.CboCodPar.ENABLED		= .F.

				.CboLotes.ENABLED		= .F.
				.CboCodProcs.ENABLED	= .F.
				.CboCodActiv.ENABLED	= .F.
				.CboCodFase.ENABLED		= .F.
				.CboCultivo.ENABLED		= .F.
				.CboMotivo.EnableD		= .F.

				.CboAlmOri.EnableD	    = .F.

				.TxtNroRf1.VISIBLE		= .F.
				.TxtNroRf2.VISIBLE		= .F.
				.TxtNroRf3.VISIBLE		= .F.
				.TxtNroOdt.VISIBLE		= .F.
				.CboCodPrd.VISIBLE		= .F.
				.CboCodPro.VISIBLE		= .F.
				.CboCodVen.VISIBLE		= .F.
				.CboCodCli.VISIBLE		= .F.
				.CboCodPar.VISIBLE		= .F.

				.CboLotes.VISIBLE		= .F.
				.CboCodProcs.VISIBLE	= .F.
				.CboCodActiv.VISIBLE	= .F.
				.CboCodFase.VISIBLE		= .F.
				.CboCultivo.VISIBLE		= .F.
				.CboMotivo.VISIBLE		= .F.

				.CboAlmOri.VISIBLE	    = .F.

				.LblLotes.VISIBLE		= .F.
				.LblCodProcs.VISIBLE	= .F.
				.LblCodActiv.VISIBLE	= .F.
				.LblCodFase.VISIBLE		= .F.
				.LblCultivo.VISIBLE		= .F.
				.LblMotivo.VISIBLE		= .F.
				.LblAlmOri.VISIBLE	    = .F.

				.LblGloRf1.VISIBLE		= .F.
				.LblGloRf2.VISIBLE		= .F.
				.LblGloRf3.VISIBLE		= .F.
				.LblNroOdt.VISIBLE		= .F.
				.LblCodPrd.VISIBLE		= .F.
				.LblCodPro.VISIBLE		= .F.
				.LblCodVen.VISIBLE		= .F.
				.LblCodCli.VISIBLE		= .F.
				.LblCodPar.VISIBLE		= .F.
		endwith
	ENDPROC


	PROCEDURE cbocodprocs.InteractiveChange

		THIS.PARENT.cboCodActiv.cValoresFiltro=this.parent.CboCodFase.Value+";"+THIS.VALUE
		THIS.PARENT.cboCodActiv.GenerarCursor()
		THIS.PARENT.cboCodActiv.VALID()
	ENDPROC


	PROCEDURE cbolotes.InteractiveChange
		THIS.PARENT.cboCultivo.cValoresFiltro=GsCodSed+";"+THIS.VALUE
		THIS.PARENT.cboCultivo.GenerarCursor()
	ENDPROC


	PROCEDURE chkretencion.Valid
		thisform.ObjRefTran.XlRete	= this.Value
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntpage_almacen
**************************************************


**************************************************
*-- Class:        cntpage_ventas (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_container (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   10/24/07 08:55:13 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS cntpage_ventas AS base_container


	Width = 699
	Height = 147
	*-- Cursor con datos de validacion del cliente
	c_validcliente = (SYS(2015))
	*-- Cursor de validacion del documento de referencia
	c_validnroref = (SYS(2015))
	*-- Cursor de validacion del pedido
	c_validpedido = (SYS(2015))
	Name = "cntpage_ventas"
	shpBorde.Top = 2
	shpBorde.Left = 2
	shpBorde.Height = 146
	shpBorde.Width = 696
	shpBorde.BorderStyle = 1
	shpBorde.BorderWidth = 1
	shpBorde.FillStyle = 1
	shpBorde.BackColor = RGB(255,255,128)
	shpBorde.BorderColor = RGB(0,0,0)
	shpBorde.ZOrderSet = 0
	shpBorde.Name = "shpBorde"


	ADD OBJECT cbofmapgo AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 415, ;
		TabIndex = 5, ;
		Top = 27, ;
		Width = 123, ;
		ZOrderSet = 1, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('FP'), ;
		cwheresql = "", ;
		caliascursor = "c_FmaPgo", ;
		Name = "CboFmaPgo"


	ADD OBJECT lblnroped AS base_label WITH ;
		FontSize = 8, ;
		Caption = "PEDIDO", ;
		Height = 16, ;
		Left = 13, ;
		Top = 100, ;
		Visible = .F., ;
		Width = 38, ;
		TabIndex = 17, ;
		ZOrderSet = 2, ;
		Name = "LblNroPed"


	ADD OBJECT lblfchped AS base_label WITH ;
		FontSize = 8, ;
		Caption = "FECHA PED.", ;
		Height = 16, ;
		Left = 13, ;
		Top = 120, ;
		Visible = .F., ;
		Width = 61, ;
		TabIndex = 18, ;
		ZOrderSet = 3, ;
		Name = "LblFchPed"


	ADD OBJECT lblnroo_c AS base_label WITH ;
		FontSize = 8, ;
		Caption = "O/COMPRA", ;
		Height = 16, ;
		Left = 551, ;
		Top = 100, ;
		Visible = .F., ;
		Width = 57, ;
		TabIndex = 20, ;
		ZOrderSet = 4, ;
		Name = "LblNroO_C"


	ADD OBJECT txtnroped AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 60, ;
		MaxLength = 10, ;
		TabIndex = 10, ;
		Top = 96, ;
		Visible = .F., ;
		Width = 92, ;
		ZOrderSet = 5, ;
		Name = "TxtNroPed"


	ADD OBJECT txtnroo_c AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 609, ;
		MaxLength = 20, ;
		TabIndex = 8, ;
		Top = 96, ;
		Visible = .F., ;
		Width = 81, ;
		ZOrderSet = 6, ;
		Name = "TxtNroO_C"


	ADD OBJECT txtcndpgo AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 671, ;
		MaxLength = 10, ;
		TabIndex = 6, ;
		Top = 148, ;
		Visible = .F., ;
		Width = 13, ;
		ZOrderSet = 7, ;
		Name = "TxtCndPgo"


	ADD OBJECT lbldiavto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "DIAS", ;
		Height = 16, ;
		Left = 481, ;
		Top = 51, ;
		Visible = .F., ;
		Width = 26, ;
		TabIndex = 21, ;
		ZOrderSet = 8, ;
		Name = "LblDiaVto"


	ADD OBJECT txtfchped AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 86, ;
		TabIndex = 11, ;
		Top = 118, ;
		Width = 65, ;
		ZOrderSet = 9, ;
		Name = "TxtFchPed"


	ADD OBJECT txtfcho_c AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 610, ;
		TabIndex = 9, ;
		Top = 116, ;
		Width = 65, ;
		ZOrderSet = 10, ;
		Name = "TxtFchO_C"


	ADD OBJECT lblfcho_c AS base_label WITH ;
		FontSize = 8, ;
		Caption = "FECHA O/C ", ;
		Height = 16, ;
		Left = 551, ;
		Top = 118, ;
		Visible = .F., ;
		Width = 60, ;
		TabIndex = 19, ;
		ZOrderSet = 11, ;
		Name = "LblFchO_C"


	ADD OBJECT lblfmapgo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "F/ PAGO", ;
		Height = 16, ;
		Left = 366, ;
		Top = 30, ;
		Visible = .F., ;
		Width = 44, ;
		TabIndex = 24, ;
		ZOrderSet = 12, ;
		Name = "LblFmaPgo"


	ADD OBJECT lblcndpgo AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Condiciones de pago", ;
		Height = 16, ;
		Left = 564, ;
		Top = 153, ;
		Visible = .F., ;
		Width = 103, ;
		TabIndex = 28, ;
		ZOrderSet = 13, ;
		Name = "LblCndPgo"


	ADD OBJECT spndiavto AS base_spinner_numero WITH ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999", ;
		Left = 416, ;
		TabIndex = 7, ;
		Top = 48, ;
		Width = 60, ;
		ZOrderSet = 14, ;
		Name = "SpnDiaVto"


	ADD OBJECT lblrucaux AS base_label WITH ;
		FontSize = 8, ;
		Caption = "RUC ", ;
		Height = 16, ;
		Left = 24, ;
		Top = 49, ;
		Visible = .F., ;
		Width = 26, ;
		TabIndex = 23, ;
		ZOrderSet = 15, ;
		Name = "LblRucAux"


	ADD OBJECT txtrucaux AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 48, ;
		TabIndex = 13, ;
		Top = 46, ;
		Visible = .F., ;
		Width = 86, ;
		ZOrderSet = 16, ;
		Name = "TxtRucAux"


	ADD OBJECT lbldiraux AS base_label WITH ;
		FontSize = 8, ;
		Caption = "DIREC.", ;
		Height = 16, ;
		Left = 15, ;
		Top = 30, ;
		Visible = .F., ;
		Width = 34, ;
		TabIndex = 27, ;
		ZOrderSet = 17, ;
		Name = "LblDirAux"


	ADD OBJECT txtnroref AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 50, ;
		TabIndex = 2, ;
		Top = 67, ;
		Visible = .F., ;
		Width = 95, ;
		ZOrderSet = 18, ;
		Name = "TxtNroref"


	ADD OBJECT lblnroref AS base_label WITH ;
		FontSize = 8, ;
		Caption = "G/R", ;
		Height = 16, ;
		Left = 24, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 20, ;
		TabIndex = 22, ;
		ZOrderSet = 19, ;
		Name = "LblNroRef"


	ADD OBJECT lbltpocmb AS base_label WITH ;
		FontSize = 8, ;
		Caption = "T/C.", ;
		Left = 394, ;
		Top = 7, ;
		Visible = .F., ;
		TabIndex = 15, ;
		ZOrderSet = 20, ;
		Name = "LblTpoCmb"


	ADD OBJECT txttpocmb AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "99.9999", ;
		Left = 415, ;
		TabIndex = 4, ;
		Top = 4, ;
		Width = 52, ;
		ZOrderSet = 21, ;
		Name = "TxtTpoCmb"


	ADD OBJECT lblcodmon AS base_label WITH ;
		FontSize = 8, ;
		Caption = "MON.", ;
		Left = 472, ;
		Top = 7, ;
		Visible = .F., ;
		TabIndex = 16, ;
		ZOrderSet = 22, ;
		Name = "LblCodMon"


	ADD OBJECT cbocodmon AS base_combobox WITH ;
		FontSize = 8, ;
		RowSourceType = 1, ;
		RowSource = "S/.,US$", ;
		Value = 1, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 500, ;
		TabIndex = 3, ;
		Top = 5, ;
		Width = 49, ;
		ZOrderSet = 23, ;
		Name = "CboCodMon"


	ADD OBJECT lbltpovta AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Tipo", ;
		Height = 16, ;
		Left = 583, ;
		Top = 8, ;
		Visible = .F., ;
		Width = 22, ;
		TabIndex = 25, ;
		ZOrderSet = 24, ;
		Name = "LblTpoVta"


	ADD OBJECT cmdhelpnroref AS base_cmdhelp WITH ;
		Top = 67, ;
		Left = 146, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 29, ;
		ZOrderSet = 25, ;
		cvaloresfiltro = (GoCfgVta.XcFlgEst_Ref), ;
		ccamposfiltro = "FlgEst", ;
		cnombreentidad = "vtavguia", ;
		ccamporetorno = "nrodoc", ;
		caliascursor = "c_Guias", ;
		ccampovisualizacion = "GLoDoc", ;
		Name = "CmdHelpNroRef"


	ADD OBJECT lbldestino AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Destino", ;
		Height = 16, ;
		Left = 567, ;
		Top = 29, ;
		Visible = .F., ;
		Width = 38, ;
		TabIndex = 25, ;
		ZOrderSet = 26, ;
		Name = "LblDestino"


	ADD OBJECT cbotpovta AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 605, ;
		TabIndex = 14, ;
		Top = 5, ;
		Width = 90, ;
		ZOrderSet = 27, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CBDMTABL", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('TV'), ;
		cwheresql = "", ;
		caliascursor = "c_TpoVta", ;
		Name = "CboTpoVTa"


	ADD OBJECT cbodestino AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 605, ;
		TabIndex = 5, ;
		Top = 26, ;
		Width = 90, ;
		ZOrderSet = 28, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CBDMTABL", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('DE'), ;
		cwheresql = "", ;
		caliascursor = "c_Destino", ;
		Name = "CboDestino"


	ADD OBJECT cbovia AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 605, ;
		TabIndex = 5, ;
		Top = 47, ;
		Visible = .F., ;
		Width = 90, ;
		ZOrderSet = 29, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CBDMTABL", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('VI'), ;
		cwheresql = "", ;
		caliascursor = "c_Via", ;
		Name = "CboVia"


	ADD OBJECT cbocodvia AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 605, ;
		TabIndex = 5, ;
		Top = 67, ;
		Visible = .F., ;
		Width = 90, ;
		ZOrderSet = 30, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "CBDMTABL", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('ET'), ;
		cwheresql = "", ;
		caliascursor = "c_CodVia", ;
		Name = "CboCodVia"


	ADD OBJECT cboruta AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 415, ;
		TabIndex = 5, ;
		Top = 70, ;
		Visible = .F., ;
		Width = 125, ;
		ZOrderSet = 31, ;
		BackColor = RGB(230,255,255), ;
		cnombreentidad = "ALMTGSIS", ;
		ccamporetorno = "CODIGO", ;
		ccampovisualizacion = "NOMBRE", ;
		ccamposfiltro = "TABLA", ;
		cvaloresfiltro = ('RT'), ;
		cwheresql = "", ;
		caliascursor = "c_CodRuta", ;
		Name = "CboRuta"


	ADD OBJECT cbocoddire AS base_cbohelp WITH ;
		FontSize = 8, ;
		ColumnCount = 2, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 48, ;
		TabIndex = 12, ;
		Top = 26, ;
		Width = 246, ;
		ZOrderSet = 32, ;
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


	ADD OBJECT lblvia AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Via", ;
		Height = 16, ;
		Left = 587, ;
		Top = 51, ;
		Visible = .F., ;
		Width = 18, ;
		TabIndex = 25, ;
		ZOrderSet = 33, ;
		Name = "LblVia"


	ADD OBJECT chkretencion AS base_checkbox WITH ;
		Top = 44, ;
		Left = 152, ;
		Height = 24, ;
		Width = 119, ;
		Alignment = 0, ;
		Caption = "Agente Retención", ;
		ZOrderSet = 34, ;
		Name = "ChkRetencion"


	ADD OBJECT lblcodvia AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Transporte", ;
		Height = 16, ;
		Left = 550, ;
		Top = 69, ;
		Visible = .F., ;
		Width = 55, ;
		TabIndex = 25, ;
		ZOrderSet = 35, ;
		Name = "LblCodVia"


	ADD OBJECT lblruta AS base_label WITH ;
		FontSize = 8, ;
		Caption = "RUTA", ;
		Height = 16, ;
		Left = 381, ;
		Top = 73, ;
		Visible = .F., ;
		Width = 30, ;
		TabIndex = 23, ;
		ZOrderSet = 36, ;
		Name = "LblRuta"


	ADD OBJECT cmdfmapgo AS base_cmdhelp WITH ;
		Top = 27, ;
		Left = 516, ;
		Height = 21, ;
		Width = 28, ;
		Enabled = .F., ;
		TabIndex = 38, ;
		Visible = .F., ;
		ZOrderSet = 37, ;
		cvaloresfiltro = ('FP'), ;
		ccamposfiltro = "tabla", ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "codigo", ;
		caliascursor = "c_FormaPago2", ;
		ccampovisualizacion = "Nombre", ;
		Name = "CmdFmaPgo"


	ADD OBJECT cntcodcli AS base_textbox_cmdhelp WITH ;
		Top = 5, ;
		Left = 0, ;
		Width = 372, ;
		Height = 20, ;
		ZOrderSet = 38, ;
		cetiqueta = ("CLIENTE"), ;
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
		cmdhelp.Top = 0, ;
		cmdhelp.Left = 149, ;
		cmdhelp.Height = 20, ;
		cmdhelp.Name = "cmdhelp", ;
		txtDescripcion.Height = 20, ;
		txtDescripcion.Left = 173, ;
		txtDescripcion.Top = 0, ;
		txtDescripcion.Width = 200, ;
		txtDescripcion.Name = "txtDescripcion", ;
		lblCaption.FontSize = 8, ;
		lblCaption.Caption = "CLIENTE", ;
		lblCaption.Left = 6, ;
		lblCaption.Top = 3, ;
		lblCaption.Name = "lblCaption"


	ADD OBJECT base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "VCTO.", ;
		Height = 16, ;
		Left = 380, ;
		Top = 50, ;
		Visible = .F., ;
		Width = 34, ;
		TabIndex = 21, ;
		ZOrderSet = 8, ;
		Name = "Base_label1"


	ADD OBJECT cmdhelpnroped AS base_cmdhelp WITH ;
		Top = 96, ;
		Left = 155, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 29, ;
		ZOrderSet = 25, ;
		cvaloresfiltro = (GoCfgVta.XcFlgEst_Ref), ;
		ccamposfiltro = "FlgEst", ;
		cnombreentidad = "vtavpedi", ;
		ccamporetorno = "nrodoc", ;
		caliascursor = "c_Pedido", ;
		ccampovisualizacion = "NomCli", ;
		Name = "CmdHelpNroPed"


	ADD OBJECT chkcertificado AS base_checkbox WITH ;
		Top = 96, ;
		Left = 188, ;
		Height = 12, ;
		Width = 79, ;
		Alignment = 0, ;
		Caption = "Certificado", ;
		Name = "ChkCertificado"


	ADD OBJECT chkdesarrollo AS base_checkbox WITH ;
		Top = 111, ;
		Left = 188, ;
		Height = 12, ;
		Width = 79, ;
		Alignment = 0, ;
		Caption = "Desarrollo", ;
		Name = "ChkDesarrollo"


	ADD OBJECT chkinfotec AS base_checkbox WITH ;
		Top = 121, ;
		Left = 187, ;
		Height = 24, ;
		Width = 72, ;
		Alignment = 0, ;
		Caption = "Info.Tec.", ;
		Name = "CHkInfoTec"


	ADD OBJECT chkmuestra AS base_checkbox WITH ;
		Top = 91, ;
		Left = 291, ;
		Alignment = 0, ;
		Caption = "Muestra", ;
		Name = "ChkMuestra"


	ADD OBJECT chkaplicacion AS base_checkbox WITH ;
		Top = 111, ;
		Left = 291, ;
		Height = 12, ;
		Width = 84, ;
		Alignment = 0, ;
		Caption = "Aplicacion", ;
		Name = "ChkAplicacion"


	ADD OBJECT chkproduccion AS base_checkbox WITH ;
		Top = 126, ;
		Left = 291, ;
		Height = 12, ;
		Width = 96, ;
		Alignment = 0, ;
		Caption = "Produccion", ;
		Name = "ChkProduccion"


	ADD OBJECT chkvobo1 AS base_checkbox WITH ;
		Top = 97, ;
		Left = 381, ;
		Height = 12, ;
		Width = 123, ;
		Alignment = 0, ;
		Caption = "Vo Bo Ventas", ;
		Name = "ChkVobo1"


	ADD OBJECT chkvobo2 AS base_checkbox WITH ;
		Top = 111, ;
		Left = 381, ;
		Height = 12, ;
		Width = 147, ;
		Alignment = 0, ;
		Caption = "Vo Bo Ger. Tecnica", ;
		Name = "ChkVoBo2"


	PROCEDURE habilita
		DODEFAULT()
		DO CASE
			CASE INLIST(thisform.ObjRefTran.XsCodRef,'FREE')  && Libre
				this.TxtNroRef.Visible = .F.
				this.CmdHelpNroRef.Visible = .F.
				this.LblNroRef.Visible = .F.
			CASE INLIST(thisform.ObjRefTran.XsCodRef,'PEDI')  && Libre
				this.TxtNroRef.Visible = .F.
				this.CmdHelpNroRef.Visible = .F.
				this.LblNroRef.Visible = .F.
			CASE INLIST(thisform.ObjRefTran.XsCodRef,'PROF')  && Libre
				this.TxtNroRef.Visible = .F.
				this.CmdHelpNroRef.Visible = .F.
				this.LblNroRef.Visible = .F.
		ENDCASE

		DO CASE
			CASE INLIST(thisform.ObjRefTran.XsCodDoc,'F','B')  && Nota de credito
				This.TxtRucAux.Enabled		= .F.
				This.ChkRetencion.Enabled	= .F.
				this.CboFmaPgo.Enabled		= .F.
				this.Cboruta.Enabled = IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				this.CboRuta.Visible = .F.  &&& hasta nuevo aviso VETT 14-12-2006  IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				This.Lblruta.Visible = .F.  &&& hasta nuevo aviso VETT 14-12-2006  IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.) 
				this.LblFchPed.Caption  = 'FECHA PED.'
				this.ChkAplicacion.Visible = .F.
				this.ChkCertificado.Visible = .F. 
				this.chkDesarrollo.Visible = .F.
				this.chkInfoTec.Visible = .F. 
				this.chkMuestra.Visible = .F.
				this.chkproduccion.Visible = .F.
				this.chkretencion.Visible = .F.
				this.chkvobo1.Visible = .F.
				this.chkvoBo2.Visible = .F.
		*!*			this.CmdHelpNroPed.Visible = .F.
		*!*			this.LblNroPed.Visible = .F.
		*!*			this.TxtNroPed.Visible = .F.
		*!*			this.LblFchPed.Visible = .F.
		*!*			this.TxtFchPed.Visible = .F.
			CASE INLIST(thisform.ObjRefTran.XsCodDoc,'N/C','N\C','NC')  && Nota de credito

			CASE INLIST(thisform.ObjRefTran.XsCodDoc,'N/D','N\D','ND')  && Nota de debito
				This.CboTpoVta.Enabled		= .F.
				this.cbovia.Enabled			= .F.
				this.CboDestino.Enabled		= .F.
				This.CboCodVia.Enabled		= .F.
				this.CmdHelpNroRef.Enabled	= .F.
				this.CmdHelpNroPed.Enabled	= .F.
				this.TxtNroped.Enabled		= .F.
				this.TxtFchPed.Enabled		= .F.
				this.TxtFchO_C.Enabled		= .F.
				this.txtNroO_C.Enabled		= .F.

				this.CboTpoVta.Visible		= .F.
				this.CboDestino.Visible 	= .F.
				this.cbovia.Visible			= .F.
				This.CboCodVia.Visible 		= .F.
				this.TxtNroRef.Visible		= .F.
				this.CmdHelpNroRef.Visible	= .F.
				this.TxtNroped.Visible 		= .F.
				this.TxtFchPed.Visible 		= .F.
				this.TxtFchO_C.Visible 		= .F.
				this.txtNroO_C.Visible 		= .F.


				this.LblNroRef.Visible 	= .F.
				this.LblTpoVta.Visible	= .F.
				this.LblVia.Visible 	= .F.
				this.LblCodVia.Visible 	= .F.
				this.LblDestino.Visible = .F.
				this.LblFchO_C.Visible 	= .F.
				this.LblFchPed.Visible	= .F.
				this.LblNroO_C.Visible 	= .F.
				this.LblNroPed.Visible 	= .F.
				this.ChkAplicacion.Visible = .f. 
				this.ChkCertificado.Visible = .F. 
				this.chkDesarrollo.Visible = .F.
				this.chkInfoTec.Visible = .F. 
				this.chkMuestra.Visible = .F.
				this.chkproduccion.Visible = .F.
				this.chkretencion.Visible = .F.
				this.chkvobo1.Visible = .F.
				this.chkvoBo2.Visible = .F.
				      
			CASE INLIST(thisform.ObjRefTran.XsCodDoc,'P') OR INLIST(thisform.ObjRefTran.XsCodDoc,'PROF')  && Pedido o Proforma
				This.CboTpoVta.Enabled		= .F.
				this.cbovia.Enabled			= .F.
				this.CboDestino.Enabled		= .F.
				This.CboCodVia.Enabled		= .F.
				this.CmdHelpNroRef.Enabled	= .F.
				this.CmdHelpNroPed.Enabled	= .F.
				this.TxtNroped.Enabled		= .F.
				this.TxtFchPed.Enabled		= .F.
				THIS.TxtNroO_C.Enabled		= .F. 
				THIS.TxtFchO_C.Enabled		= .F. 

				this.CboTpoVta.Visible		= .F.
				this.CboDestino.Visible 	= .F.
				this.cbovia.Visible			= .F.
				This.CboCodVia.Visible 		= .F.
				this.TxtNroRef.Visible		= .F.
				this.CmdHelpNroRef.Visible	= .F.
				this.CmdHelpNroPed.Visible	= .F.
				this.LblNroped.Visible 		= .F.
				this.TxtNroped.Visible 		= .F.
				this.LblFchPed.Visible 		= .F.
				this.TxtFchPed.Visible 		= .F.
				THIS.TxtNroO_C.Visible		= .F. 
				THIS.TxtFchO_C.Visible		= .F. 

				this.LblNroRef.Visible 	= .F.
				this.LblTpoVta.Visible	= .F.
				this.LblVia.Visible 	= .F.
				this.LblCodVia.Visible 	= .F.
				this.LblDestino.Visible = .F.
				this.LblFchO_C.Visible 	= .F.
				this.LblFchPed.Visible	= .F.
				this.LblNroO_C.Visible 	= .F.
				this.LblNroPed.Visible 	= .F.		 
			 
		 		this.Cboruta.Enabled = IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				this.CboRuta.Visible = .F.  &&& hasta nuevo aviso VETT 14-12-2006 IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.)
				This.Lblruta.Visible = .F.  &&& hasta nuevo aviso VETT 14-12-2006 IIF(INLIST(GsSigCia,'AROMAS','QUIMICA'),.F.,.T.) 
				** Flojera: Usemos estas para la fecha de entrega ** 
				this.TxtFchPed.Visible	= .T.
				this.TxtFchPed.Enabled	= .T.
				this.LblFchPed.Visible	= .T.
				this.LblFchPed.Caption  = 'FEC.ENTREGA'

				this.ChkAplicacion.Visible = .T. 
				this.ChkCertificado.Visible = .T. 
				this.chkDesarrollo.Visible = .T.
				this.chkInfoTec.Visible = .T. 
				this.chkMuestra.Visible = .T.
				this.chkproduccion.Visible = .T.
				this.chkretencion.Visible = .T.
				this.chkvobo1.Visible = .T.
				this.chkvoBo2.Visible = .T.

		ENDCASE
	ENDPROC


	PROCEDURE iniciar_var
		WITH THIS
			LOCAL i
			FOR i = 1 to .ControlCount
				.Controls(i).Enabled  = .F.
				.Controls(i).Visible  = .F.
			NEXT 
		ENDWITH
	ENDPROC


	PROCEDURE limpiar_var
		WITH this
			LOCAL i
			FOR i = 1 to .ControlCount
				DO CASE 
					CASE AT('FECHA',UPPER(.Controls(i).Class))>0
						.Controls(i).Value = {}
					CASE AT('NUMERO',UPPER(.Controls(i).Class))>0
						.Controls(i).Value = 0
					CASE AT('MONEDA',UPPER(.Controls(i).Class))>0
						.Controls(i).Value = 0.00
					CASE AT('TEXTBOX',UPPER(.Controls(i).Class))>0
						.Controls(i).Value = []
					CASE AT('CBOHELP',UPPER(.Controls(i).Class))>0
						.Controls(i).Value = []

				ENDCASE

			NEXT 
		ENDWITH
	ENDPROC


	PROCEDURE cbofmapgo.Valid
		LsValorCampo = EVALUATE(this.caliascursor+'.'+this.ccamporetorno)
		LnOk= thisform.ObjRefTran.odatadm.gencursor('C_FMAPGO_ACT',this.cnombreentidad,'',this.ccamposfiltro+'+'+this.ccamporetorno ,this.cvaloresfiltro+LsValorCampo  )
		IF LnOk>0
			LsDiaVTo = 'C_FMAPGO_ACT'+'.DiaVto'
			LsCodigo = 'C_FMAPGO_ACT'+'.Codigo'
			this.Parent.TxtCndPgo.Value =   EVALUATE(LsCodigo)
			this.Parent.SpnDiaVto.Value =   EVALUATE(LsDiaVTo)
		ENDIF
	ENDPROC


	PROCEDURE txtnroped.Valid
		thisform.Objreftran.XsNroPed = this.value
		DO CASE
			CASE thisform.ObjRefTran.XnTpofac = 2
				thisform.objRefTran.traer_items_ped()
				thisform.ObjRefTran.cargar_guia_detalle_enbasea_docs('PEDI','VPED','RPED','VPED01','RPED01')
			CASE thisform.ObjRefTran.XnTpofac = 3
				IF EMPTY(this.Value)
					RETURN
				ENDIF
				M.ERR=THISFORM.VALIDNroRef()
				IF m.err<0
					thisform.MensajeErr(m.err)
					RETURN .F.
				ENDIF
				thisform.objRefTran.traer_items_g_r()
			CASE thisform.ObjRefTran.XnTpofac = 4
				thisform.objRefTran.traer_items_guias()
		ENDCASE
		IF EMPTY(this.Parent.cntCodCli.Value)
			this.Parent.cntCodCli.Value = THISform.ObjRefTran.XsCodCli
			this.Parent.CntCodCli.TxtCodigo.InteractiveChange()
		ENDIF
		IF !EMPTY(THISFORM.ObjRefTran.XsCndPgo)
			this.Parent.CboFmaPgo.Value = THISFORM.ObjRefTran.XsCndPgo
			this.parent.CboFmaPgo.Valid()
		ENDIF
		thisform.pgfDetalle.page1.grdDetalle.Refresh
		*!*	thisform.PgfDetalle.Page1.GrdDetalle.SetFocus()
		thisform.Calcular_totales()
	ENDPROC


	PROCEDURE txtnroped.When
		IF thisform.xreturn = 'I' AND EMPTY(this.Parent.CntCodCli.Value)
			this.ToolTipText = 'Ingrese el cliente para poder buscar los Pedidos que le corresponden'
		ELSE
			this.ToolTipText = ''
		ENDIF
		RETURN thisform.xreturn = 'I' AND !EMPTY(this.Parent.CntCodCli.Value)
	ENDPROC


	PROCEDURE txtnroref.Valid
		thisform.Objreftran.XsNroRef = this.value
		DO CASE 
			CASE	thisform.ObjRefTran.XnTpofac = 3  && UNA GUIA
				IF EMPTY(this.Value)
					RETURN 
				ENDIF
				M.ERR=THISFORM.VALIDNroRef() 
				IF m.err<0
					thisform.MensajeErr(m.err)
					RETURN .f.
				ENDIF
				thisform.objRefTran.traer_items_g_r()

			CASE	thisform.ObjRefTran.XnTpofac = 4  && VARIAS GUIA 
				thisform.objRefTran.traer_items_guias()  

		ENDCASE
		IF EMPTY(this.Parent.cntCodCli.Value) 
			this.Parent.cntCodCli.Value = THISform.ObjRefTran.XsCodCli
			this.Parent.CntCodCli.TxtCodigo.InteractiveChange()
		ENDIf
		IF !EMPTY(THISFORM.ObjRefTran.XsCndPgo)
			this.Parent.CboFmaPgo.Value = THISFORM.ObjRefTran.XsCndPgo
			this.parent.CboFmaPgo.Valid()
		ENDIf


		thisform.pgfDetalle.page1.grdDetalle.Refresh
		*thisform.PgfDetalle.Page1.GrdDetalle.SetFocus
		thisform.Calcular_totales()
	ENDPROC


	PROCEDURE txtnroref.When
		IF thisform.xreturn = 'I' AND EMPTY(this.Parent.CntCodCli.Value) 
			this.ToolTipText = 'Ingrese el cliente para poder buscar las guias que le corresponden'
		ELSE
			this.ToolTipText = ''
		ENDIF
		RETURN thisform.xreturn = 'I' AND !EMPTY(this.Parent.CntCodCli.Value) 
	ENDPROC


	PROCEDURE cmdhelpnroref.When
		IF thisform.xreturn = 'I' AND EMPTY(this.Parent.CntCodCli.Value) 
			this.ToolTipText = 'Ingrese el cliente para poder buscar las guias que le corresponden'
		ELSE
			this.ToolTipText = ''
		ENDIF

		RETURN thisform.xreturn = 'I' AND !EMPTY(this.Parent.CntCodCli.Value) 
	ENDPROC


	PROCEDURE cmdhelpnroref.Click
		DO CASE 
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'N/C','NC','N\C')
				thisform.ObjRefTran.Traer_Items_G_R_CLI('GUIA', ; 
														'CodCli+FlgEst', ;
														thisform.objreftran.xscodcli+'F',;
														'VGUI04',;
														'CodFac',;
														'FACT',;
														'AUXI')
				THISFORM.ObjCntRef.Iniciar_var()
				thisform.ObjCntRef.Visible = .t.
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'FAC','BOL','N\D','N/D','ND')
				DO CASE 

					CASE thisform.ObjrefTran.XnTpoFac = 4		&& Varias Guias
						thisform.ObjRefTran.Traer_Items_G_R_CLI()
						THISFORM.ObjCntRef.Iniciar_var()
						thisform.ObjCntRef.Visible = .t.
				*		this.Parent.TxtNroRef.Value= thisform.ObjCntRef.cnrodocs_ref
				*!*			this.Parent.TxtNroRef.SetFocus
				*!*			IF !EMPTY(this.Parent.TxtNroRef.Value)
				*!*				KEYBOARD '{END}'+'{ENTER}'
				*!*			ENDIF

					CASE thisform.ObjrefTran.XnTpoFac = 3		&& Una Guia
						DODEFAULT()
						this.Parent.TxtNroRef.Value = this.cvalorvalida 
						this.Parent.TxtNroRef.SetFocus
						IF !EMPTY(this.Parent.TxtNroRef.Value)
							KEYBOARD '{END}'+'{ENTER}'
						ENDIF
					CASE thisform.ObjrefTran.XnTpoFac = 2		&& Un Pedido
						thisform.ObjRefTran.Traer_Items_G_R_CLI()
						THISFORM.ObjCntRef.Iniciar_var()
						thisform.ObjCntRef.Visible = .t.

				 ENDCASE 
				 
		 ENDCASE
	ENDPROC


	PROCEDURE cbotpovta.Valid
		thisform.ObjRefTran.XnTpoVta = VAL(THIS.Value)
		thisform.Calcular_Totales()
	ENDPROC


	PROCEDURE cbodestino.InteractiveChange
		IF this.Value='E'
			this.Parent.CboVia.Visible		= .T.
			this.Parent.CboCodVia.Visible	= .T.
			this.Parent.LblVia.Visible		= .T.
			This.Parent.LblCodVia.Visible	= .T.
		ELSE
			this.Parent.CboVia.Visible		= .F.
			this.Parent.CboCodVia.Visible	= .F.
			this.Parent.LblVia.Visible		= .F.
			This.Parent.LblCodVia.Visible	= .F.
		ENDIF
		thisform.Objreftran.XcDestino	= This.Value
		thisform.Calcular_Totales()
	ENDPROC


	PROCEDURE cbodestino.LostFocus
		this.InteractiveChange() 
	ENDPROC


	PROCEDURE chkretencion.Valid
		thisform.ObjRefTran.XlRete	= this.Value
	ENDPROC


	PROCEDURE cmdfmapgo.Click
		DODEFAULT()
		this.parent.CboFmaPgo.Value  = this.cvalorvalida
		this.parent.CboFmaPgo.Valid()
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl
		IF nKeyCode = ENTER AND EMPTY(this.value)
			this.Parent.cmdhelp.Click
		ENDIF
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.Valid

		DODEFAULT()
		IF EMPTY(this.Value)
			RETURN 
		ENDIF

		M.ERR=thisform.ValidCliente()

		IF m.err<0
			thisform.MensajeErr(m.err)
			RETURN .f.
		ENDIF
		thisform.ObjRefTran.XsCodCli = this.Value 
		thisform.ObjRefTran.XlRete	 = 	EVALUATE(this.PARENT.parent.C_validCliente+'.Rete')
		*this.parent.txtdirAux.value=EVALUATE(this.PARENT.c_validCliente+'.DesDire')
		this.PARENT.parent.txtrucAux.Value=EVALUATE(this.PARENT.parent.C_validCliente+'.NroRuc')
		this.PARENT.parent.ChkRetencion.Value=EVALUATE(this.PARENT.parent.C_validCliente+'.Rete')
		this.PARENT.Parent.cmdHELPNROREF.ccamposfiltro  = [FlgEst;CodCli]
		this.PARENT.Parent.cmDHELPNROREF.cvaloresfiltro = thisform.ObjRefTran.XcFlgEst_Ref+';'+thisform.objreftran.XsCodCli

		this.InteractiveChange() 
	ENDPROC


	PROCEDURE cntcodcli.TxtCodigo.InteractiveChange
		IF !USED(this.PARENT.Cnombreentidad)
			USE (this.PARENT.Cnombreentidad) again IN 0
		ENDIF
		LOCAL lExisteClie
		SELECT (this.PARENT.Cnombreentidad)
		LOCATE FOR CodAux=THIS.VAlue
		**lExisteClie=SEEK(THIS.Value,this.PARENT.Cnombreentidad,'CLIEN01')
		LsCmpCodVen=This.Parent.cNombreentidad+'.CoDVen'
		WITH thisform.objcntcab 
			.CboCodVen.Value = EVALUATE(LsCmpCodVen)
			.CboCodVen.Valid
		ENDWITH 

		lExisteClie = FOUND()
		IF lExisteClie
			LsValorFiltro=This.Parent.cNombreentidad+'.CoDcli' 
			this.Parent.Parent.cboCodDire.cValoresfiltro = EVALUATE(LsValorFiltro)
			this.Parent.Parent.CboCodDire.generarcursor() 
		ELSE

		ENDIF
	ENDPROC


	PROCEDURE cmdhelpnroped.Click
		DO CASE 
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'N/C','NC','N\C')
				thisform.ObjRefTran.Traer_Items_G_R_CLI('GUIA', ; 
														'CodCli+FlgEst', ;
														thisform.objreftran.xscodcli+'F',;
														'VGUI04',;
														'CodFac',;
														'FACT',;
														'AUXI')
				THISFORM.ObjCntRef.Iniciar_var()
				thisform.ObjCntRef.Visible = .t.
			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'FAC','BOL','N\D','N/D','ND')
				DO CASE 
					CASE thisform.ObjrefTran.XnTpoFac = 4		&& Varias Guias
						thisform.ObjRefTran.Traer_Items_G_R_CLI()
						THISFORM.ObjCntRef.Iniciar_var()
						thisform.ObjCntRef.Visible = .t.
					CASE thisform.ObjrefTran.XnTpoFac = 3		&& Una Guia
						DODEFAULT()
						this.Parent.TxtNroRef.Value = this.cvalorvalida 
						this.Parent.TxtNroRef.SetFocus
						IF !EMPTY(this.Parent.TxtNroRef.Value)
							KEYBOARD '{END}'+'{ENTER}'
						ENDIF
					CASE thisform.ObjrefTran.XnTpoFac = 2		&& Un Pedido
						DODEFAULT()
						this.Parent.TxtNroPed.Value = this.cvalorvalida 
						this.Parent.TxtNroPed.SetFocus
						IF !EMPTY(this.Parent.TxtNroPed.Value)
							KEYBOARD '{END}'+'{ENTER}'
						ENDIF
		*!*					thisform.ObjRefTran.Traer_Items_G_R_CLI()
		*!*					THISFORM.ObjCntRef.Iniciar_var()
		*!*					thisform.ObjCntRef.Visible = .t.
				 ENDCASE 
		 ENDCASE
	ENDPROC


	PROCEDURE cmdhelpnroped.When
		IF thisform.xreturn = 'I' AND EMPTY(this.Parent.CntCodCli.Value)
			this.ToolTipText = 'Ingrese el cliente para poder buscar los pedidos que le corresponden'
		ELSE
			this.ToolTipText = ''
		ENDIF
		RETURN thisform.xreturn = 'I' AND !EMPTY(this.Parent.CntCodCli.Value)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntpage_ventas
**************************************************


**************************************************
*-- Class:        base_control (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  control
*-- BaseClass:    control
*-- Time Stamp:   04/27/00 09:54:11 AM
*
DEFINE CLASS base_control AS control


	BorderWidth = 0
	SpecialEffect = 2
	BackColor = RGB(223,223,223)
	Name = "base_control"


ENDDEFINE
*
*-- EndDefine: base_control
**************************************************


**************************************************
*-- Class:        base_control_labelshadow (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_control (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    control
*-- Time Stamp:   04/11/00 12:07:07 PM
*
DEFINE CLASS base_control_labelshadow AS base_control


	Width = 334
	Height = 40
	BackStyle = 0
	BorderWidth = 0
	*-- Describe la etiqueta
	caption = ("")
	Name = "base_control_labelshadow"


	ADD OBJECT lblsombra AS base_label WITH ;
		FontBold = .T., ;
		FontItalic = .T., ;
		FontShadow = .T., ;
		FontSize = 20, ;
		Alignment = 2, ;
		Caption = "Descripción del Sistema", ;
		Height = 35, ;
		Left = 14, ;
		Top = 3, ;
		Width = 312, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,223), ;
		Name = "lblSombra"


	ADD OBJECT lblnormal AS base_label WITH ;
		FontBold = .T., ;
		FontItalic = .T., ;
		FontShadow = .T., ;
		FontSize = 20, ;
		Alignment = 2, ;
		Caption = "Descripción del Sistema", ;
		Height = 35, ;
		Left = 12, ;
		Top = 0, ;
		Width = 312, ;
		ForeColor = RGB(255,255,255), ;
		BackColor = RGB(255,255,223), ;
		Name = "lblNormal"


	PROCEDURE Refresh
		THIS.lblSombra = THIS.Caption
		THIS.lblNormal = THIS.Caption
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_control_labelshadow
**************************************************


**************************************************
*-- Class:        base_editbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  editbox
*-- BaseClass:    editbox
*-- Time Stamp:   04/11/00 12:09:07 PM
*
DEFINE CLASS base_editbox AS editbox


	Height = 53
	Width = 100
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_editbox"


ENDDEFINE
*
*-- EndDefine: base_editbox
**************************************************


**************************************************
*-- Class:        base_form (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   10/11/07 06:58:08 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS base_form AS form


	DataSession = 1
	Height = 189
	Width = 284
	DoCreate = .T.
	ShowTips = .T.
	BufferMode = 2
	AutoCenter = .T.
	Caption = "Caption"
	ControlBox = .F.
	Closable = .F.
	MaxButton = .F.
	MinButton = .F.
	MaxHeight = 600
	MaxWidth = 780
	WindowType = 1
	BackColor = RGB(223,223,223)
	*-- Controla la conexion ODBC
	ocnx_odbc = ""
	*-- Valor de retorno del formulario
	xreturn = ""
	*-- Controla actualización del detalle
	lctipope = ("")
	*-- Codigo del Formulario actual
	codigoformulario = ("")
	*-- Tipo de acceso que tiene el cliente, Consulta, Modificación, Inserción, Todo.
	ctipoacceso = ('')
	*-- Estado de navegacion, Viendo los datos (Solo navegando)  o modificando ( Update, Insert o Delete)
	lnavegando = .T.
	*-- Propiedad utilizada para referenciar un objeto que controle las transacciones
	objreftran = .NULL.
	*-- Propiedad que referencia a un objeto que contiene los datos de la transacción
	objreftrandata = .NULL.
	*-- Nombre del objeto de negocios que se  va a vincular al formulario
	nombreobjref = ""
	*-- Nombre del objeto de datos que se va a vincular al formulario
	nombreobjrefdata = ""
	*-- Objeto contenedor para controles de la cabecera
	objcntcab = .NULL.
	*-- Objeto contenedor de los controles de la pagina principal del formulario
	objcntpage = .NULL.
	nomobjcntcab = ""
	nomobjcntpage = ""
	*-- Cursor que contiene los datos validados del item
	c_validitem = (SYS(2015))
	*-- Nombre de contenedor de documentos de referencia
	nomobjcnt_ref = ""
	*-- Objeto contenedor de documentos de referencia
	objcntref = .NULL.
	*-- Cursor local para seleccion de datos
	ccursor_local = ([])
	*-- Tabla de donde se extraen los registros del cursor local
	ctabla_remota = ([])
	*-- Indice de la tabla remota
	ctag_tr = ([])
	*-- Orden de la tabla remota
	corder_tr = ([])
	*-- Orden del cursor local
	corder_cl = ([])
	*-- Condicion de filtro para generar el cursor local
	cwheresql = ([])
	*-- Campos de la clave primaria de la tabla remota
	ccmpkey = ([])
	*-- Campos que conforman la llave del correlativo de la tabla remota
	ccmps_id = ([])
	*-- Valores de la clave primaria
	cvalkey = ([])
	*-- Valor del campo que contiene el Id del correlativo de la tabla remota
	cvalor_id = ([])
	*-- resultado de la transaccion
	nresulttrn = 0
	*-- Campo que es correlativo
	ccampo_id = ([])
	*-- Longitud que se tomara del cCampo_id para formar el correlativo cuando cCmps_id esta contenido en el.
	nlen_id = 0
	*-- 1 ->  en una sola pestaña (tab),  2 - > En una pestaña (tab) separada.
	modo_edit_detalle = 1
	*-- Cursor que contiene los lotes validos de un item de almacen
	c_validitemlote = (SYS(2015))
	*-- Cursor que contiene los documentos por referencia validos
	c_validnroref = (SYS(2015))
	*-- Cursor que contiene el cliente valido para la transaccion
	c_validcliente = (SYS(2015))
	Name = "base_form"

	*-- Indica si el formulario ya fue cargado o no, esta propiedad la actualiza en el evento INIT
	lcargado = .F.

	*-- Indica si el formulario fue o no cargado, ver LCARGADO
	HIDDEN lload

	*-- Indica que si el registro que se esta editando es nuevo o ya existia en la tabla
	lnuevo = .F.

	*-- Indica si el  registro editado ya fue grabado en la base de datos.
	lgrabado = .F.

	*-- Propiedad usada para determinar si estamos en ambiente Cliente/Servidor o de tablas libres
	sqlentorno = .F.

	*-- Comando sql a ejecutar para generar el cursor local
	ccmdsql_cl = .F.
	ccmdupdsql_tr = .F.
	ccmdinssql_tr = .F.
	ccmdsqldel_tr = .F.

	*-- Arreglo que contiene las rutas de las tablas que se usarán en el formulario
	DIMENSION aruta_tablas[1]
	HIDDEN arutalog[1]


	ADD OBJECT tools AS util WITH ;
		Top = 12, ;
		Left = 12, ;
		Name = "tools"


	PROCEDURE tabla
		LPARAMETER tcNombreEntidad , tnTipo
		tnTipo = IIF(VARTYPE(tnTipo)=="N",tnTipo,1)

		LOCAL lcRemotePathEntidad
		lcRemotePathEntidad = ALLTRIM(tcNombreEntidad)

		SELECT ;
			CodigoEntidad  , ;
			NombreServidor , ;
			NombreBaseDatos  ;
		FROM ;
			goEntorno.LocPath + "GEntidades" ;
		WHERE ;
			UPPER(ALLTRIM(NombreEntidad))==UPPER(ALLTRIM(tcNombreEntidad)) ;
		INTO ARRAY Entidad

		IF _TALLY > 0

			DO CASE
				*!*	El servidor por defecto es diferente al que se obtuvo
				CASE UPPER(ALLTRIM(goConexion.Servidor)) <> UPPER(ALLTRIM(Entidad[1,2]))
					*!*	Retorna	: Servidor.BaseDatos.dbo.Tabla
					lcRemotePathEntidad = ALLTRIM(Entidad[1,2])+"."+ALLTRIM(Entidad[1,3])+".dbo."+ALLTRIM(tcNombreEntidad)
					*!*	El servidor por defecto es igual al que se obtuvo, pero la Base de Datos es Diferente
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Entidad[1,2])) AND ;
						UPPER(ALLTRIM(goConexion.BaseDatos))<> UPPER(ALLTRIM(Entidad[1,3]))
					*!*	Retorna	: BaseDatos.dbo.Tabla
					lcRemotePathEntidad = ALLTRIM(Entidad[1,3])+".dbo."+ALLTRIM(tcNombreEntidad)
					*!*	El servidor por defecto es igual al que se obtuvo, y la Base de Datos tambien
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Entidad[1,2])) AND ;
						UPPER(ALLTRIM(goConexion.BaseDatos))== UPPER(ALLTRIM(Entidad[1,3]))
					*!*	Retorna	: Tabla
					lcRemotePathEntidad = ALLTRIM(tcNombreEntidad)
			ENDCASE
			tcCodigoEntidad = Entidad[1,1]
		ELSE
			tcCodigoEntidad = ""
		ENDIF

		IF USED("GEntidades")
			USE IN GEntidades
		ENDIF

		DO CASE
		CASE tnTipo == 1
			RETURN lcRemotePathEntidad
		CASE tnTipo == 2
			RETURN tcCodigoEntidad
		CASE tnTipo == 3
			RETURN tcCodigoEntidad
		ENDCASE
	ENDPROC


	HIDDEN PROCEDURE lcargado_assign
		LPARAMETERS tlCargado
		THIS.lcargado = tlCargado
	ENDPROC


	HIDDEN PROCEDURE lcargado_access
		RETURN THIS.lLoad
	ENDPROC


	PROCEDURE generarlog
		LPARAMETERS tcCodigoTransaccion,tcCodigoBoton,cError
		IF GoEntorno.SqlEntorno 
		   goEntorno.GenerarLog(tcCodigoTransaccion,tcCodigoBoton,cError)
		ENDIF
	ENDPROC


	PROCEDURE envia
		LPARAMETER lctransaccion , lcsubject , lccuerpo
		lcmtransaccion	= lctransaccion
		lcmusuario		= goentorno.USER.login
		LcArcTmp		= goentorno.TmpPath + SYS(3) + ".tmp"
		*!*	CREATE TABLE (LcArcTmp) ( textomail m )
		*!*	APPEN BLANK
		*!*	REPLACE textomail WITH lccuerpo
		*!*	COPY MEMO textomail TO (LcArcTmp)
		*!*	USE
		*!*	LcArcTmp=LcArcTmp+".txt"

		lcsubject	= IIF( ISNULL(lcsubject), "" , lcsubject)
		lccuerpo	= IIF( ISNULL(lccuerpo) , "" , lccuerpo )
		=STRTOFILE(lccuerpo , lcArcTmp)

		THISFORM.oCnx_ODBC.cSQL		= "EXEC DDPADM1_USUARIOSXTRANSACCION @pCodigotransaccion=?lcmtransaccion,@ploginusuario=?lcmusuario"
		THISFORM.oCnx_ODBC.cCursor	= "cmail"
		Control_SQL	= THISFORM.oCnx_ODBC.DoSQL(THISFORM.DATASESSION)

		IF Control_SQL>0 AND RECCOUNT("cMail")>0
			SELECT cMail
			*DO WHILE NOT EOF()
			SCAN
				WAIT WINDOW "Enviando E-Mail de aviso de transacción" NOWAIT
				lcusuario1	= cmail.usuario
				lccopia		= cmail.ccopia
				lSubJect	= ALLTRIM(cmail.descripciontransaccion) + " " + ALLTRIM(lcsubject)
				** Linea de comandos del Pegasus Mail **
				**run /n P:winpm-32.exe -T &LsUsuario. -S LsSubject -F &LcArctmp.
				IF ISNULL(lccopia) OR EMPTY(lccopia)
					LcComando= [RUN /n P:winpm-32.exe -T ] + (lcusuario1)+ [ -S "] + lSubJect + [" -F ]+ (LcArcTmp) +' -I ' + (lcmusuario)
				ELSE
					LcComando= [RUN /n P:winpm-32.exe -T ] + (lcusuario1)+ "-c " + (lccopia)  + [ -S "]+lSubJect+[" -F ]+ (LcArcTmp)+ ' -I ' + (lcmusuario)
				ENDIF
				&LcComando.
				WAIT CLEAR
				SELECT cMail
				*SKIP
			*ENDDO
			ENDSCAN
			THISFORM.TOOLS.CLOSETABLE('CMAIL')
		ENDIF
	ENDPROC


	*-- Muestra el error segun tabla de errores
	PROCEDURE mensajeerr
		PARAMETERS TnId_Error
		IF TnId_error = 0
			RETURN 0
		ENDIF
		SELECT * from admin!sistlerr WHERE id_err = TnId_error INTO ARRAY aMensaje
		IF _TALLY>0
			RETURN MESSAGEBOX(amensaje(1,2),amensaje(1,4)+amensaje(1,5),aMensaje(1,6))
		ELSE
			RETURN MESSAGEBOX('Se ha producido un error no identificado',0+16,'Atención!!/Atention!!')
		ENDIF


		 
	ENDPROC


	PROCEDURE validitem
		LOCAL LcCodMat,LcSubAlm,LfCandes,LdFecha ,LcCursor,LcTipMov,LlStkNeg,LcLote, LnError

		LcCodMat	=	THISform.PGfDetalle.PAge3.TXtCodmat.Value
		LcSubAlm	=	thisform.objreftran.SubAlm
		LdFecha		=	THISform.PGfDetalle.PAge1.txtFchDoc.Value
		LfCandes	=	THISform.PGfDetalle.PAge3.TxtCandes.Value
		LcLote		=	THISform.PGfDetalle.PAGE3.TxtLote.Value
		LcTipMov	=	thisform.objreftran.cTipMov
		LlStkNeg	=	thisform.objreftran.lStkNeg
		LcCursor	=	IIF(EMPTY(thisform.c_validitem),'C_CodMat',thisform.c_validitem)

		IF thisform.objreftran.Transf AND LcTipMov='S' 
			IF !SEEK(thisform.objreftran.AlmTrf+LcCodMat,'CALM','CATA01')
				RETURN ITEM_NO_ESTA_ALM_DESTINO
			ENDIF
		ENDIF

		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validacodigoalmacen(LcCodMat,LcSubAlm,GsCodSed,LcTipMov,LlStkNeg,LcLote,LfCandes,LdFecha,LcCursor)

		RELEASE ov
		RETURN LnError
	ENDPROC


	*-- Valida el cliente
	PROCEDURE validcliente
		LOCAL LcCodCli ,LcCursor,LfImpTot, LnError

		LcCodCli	=	THISform.ObjCntPage.CntCodCli.Value
		LcCodRef	= 	thisform.objreftran.XsCodRef
		LfImpTot	=	THISform.PGfDetalle.PAge1.TxtImpTot.Value
		LcCursor	=	THISform.ObjCntPage.c_ValidCliente

		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validacliente(LcCodCli,LcCodRef,LfIMptot,LcCursor)

		RELEASE ov
		RETURN LnError
	ENDPROC


	*-- Valida documento de referencia
	PROCEDURE validnroref
		LOCAL LcCodRef,LcNroRef,LcCodCli,LcCursor,LnError

		LcCodRef	=	thisform.objreftran.XsCodRef
		LcNroRef	=	THISform.ObjCntPage.txtNroRef.Value
		LcCodCli	=	THISform.ObjCntPage.CntCodCli.Value
		LcCursor	=	THISform.ObjCntPage.c_ValidNroRef

		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validNroRef(LcCodRef,LcNroRef,LcCodCli,LcCursor)

		RELEASE ov
		RETURN LnError
	ENDPROC


	*-- Validar campo de una tabla o cursor utilizado dentro del formulario.
	PROCEDURE validacampotabla
		PARAMETERS LcTabla,LcCampo,LcTipo,LnLong,LnDec

		IF PARAMETERS()<5
			LnDec = null 
		ENDIF

		IF PARAMETERS()<4
			LnLong = null 
		ENDIF

		IF PARAMETERS()<3
			LcTipo = null 
		ENDIF

		ovc=CREATEOBJECT('Dosvr.validadatos')
		LnIsOK=ovc.validacampotabla(LcTabla,LcCampo,LcTipo,LnLong,LnDec)

		RELEASE ovc
		RETURN LnIsOK
	ENDPROC


	PROCEDURE validitemlote
		LOCAL LcCodMat,LcSubAlm,LfCandes,LdFecha ,LcCursor, LnError, LcLote

		LcCodMat=THIS.PGfDetalle.PAge3.TXtCodmat.Value
		LcLote  =THIS.PGfDetalle.PAge3.TxtLote.Value
		LcSubAlm=gocfgalm.SubAlm
		LdFecha	=THIS.PGfDetalle.PAge1.txtFchDoc.Value
		LfCandes=THIS.PGfDetalle.PAge3.TxtCandes.Value
		LcTipMov= this.Objreftran.cTipMov
		LlStkNeg= this.ObjRefTran.lStkNeg 
		LcCursor=IIF(EMPTY(this.c_validItemLote),'C_Lote',this.c_ValidItemLote)
		_SubAlm = LcSubAlm
		_CodMat = LcCodMat
		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validacodigoalmacenlote(LcCodMat,LcSubAlm,GsCodSed,LcTipMov,LlStkNeg,LcLote,LfCandes,LdFecha,LcCursor)
		RELEASE ov,_SubAlm,_CodMat
		RETURN LnError
	ENDPROC


	*-- Cierra tablas
	PROCEDURE closetable
		LPARAMETERS lcTable,LlAll,LcExcept
		IF PARAMETERS() <3
			LcExcept = ['_NO_HAY_EXCEPCION_']
		ENDIF
		IF PARAMETERS() <2
			LlAll = .f.
		ENDIF
		IF LlAll
			FOR TnTbl=1 TO AUSED(aTables)
				IF !INLIST(aTables(TnTbl,1),&LcExcept)
					IF !EMPTY(aTables(TnTbl,1))
						USE IN aTables(TnTbl,1)
					ENDIF
				ENDIF
			ENDFOR
		ELSE
			IF USED(lcTable)
				USE IN (lcTable)
			ENDIF
		ENDIF
	ENDPROC


	PROCEDURE Destroy
		IF TYPE("goEntorno")=="O" AND THIS.TAG <> "BIENVENIDA"
			goEntorno.GenerarLog("0004",NULL,NULL)
		ENDIF
	ENDPROC


	PROCEDURE Unload
		LOCAL lxReturn
		lxReturn= THIS.xReturn
		RETURN lxReturn
	ENDPROC


	PROCEDURE Load
		IF TYPE("goConexion")<>"O" and GoEntorno.SqlEntorno
			=MESSAGEBOX("No se creó la variable de entorno del sistema...",64,"Variable de Entorno")
			RETURN .F.
		ENDIF
		SET TALK OFF
		SET DELETED ON
		SET DATE TO DMY
		SET CENTURY ON
		SET NOTIFY OFF
		SET EXACT OFF
		SET NEAR OFF
		SET EXCLUSIVE OFF
		SET MULTILOCKS ON
		SET STATUS BAR OFF
		SET SAFETY OFF
		SET NULLDISPLAY TO ''

		IF !USED('Access') && Si no esta el cursor de accesos lo generamos
			=BuildAccessCursor()
		ENDIF
		IF NOT HasAccess ( THISFORM.Name )
			#DEFINE ERRLOGACCESS	"c:\temp\NoAcceso.txt"
			#DEFINE CRLF 			CHR(13)+CHR(10)

			IF UPPER(GsSigCia)='PREZCOM'
		  		MESSAGEBOX( "En proceso de implementación", 64, "We are working about this issue",2000 )
			ELSE
				MESSAGEBOX( "Acceso denegado", 64, "Access denied", 2000 )
			ENDIF
		 	STRTOFILE(TTOC(DATETIME()) +","+PROGRAM(1)+","+PROGRAM(2)+","+PROGRAM(3)+","+PROGRAM(4)+","+"Proceso: "+THISFORM.Name+CRLF,ERRLOGACCESS,.T.)
		   RETURN .F.
		ENDIF


		LOCAL aFormulario
		LOCAL lcPerfil , lcAlias
		DECLARE aFormulario[1]

		lcAlias		= "Perfil_Usuario"
		lcPerfil	= goEntorno.locPath + lcAlias + ".dbf"

		IF FILE(lcPerfil)
			SELECT ;
					CodigoFormulario ;
				FROM ;
					(lcPerfil) ;
				WHERE ;
					ALLTRIM(UPPER(NombreFormulario)) == ALLTRIM(UPPER(THIS.NAME)) ;
					INTO ARRAY aFormulario
			IF _TALLY > 0
				*THIS.CodigoFormulario	= IIF(TYPE("aFormulario[1]")=="C",aFormulario[1],"")
			ELSE
			*	THIS.CodigoFormulario	= ""
			ENDIF
			IF USED(lcAlias)
				USE IN (lcAlias)
			ENDIF
		ELSE
			*THIS.CodigoFormulario	= ""
		ENDIF
	ENDPROC


	PROCEDURE Init
		LPARAMETER toConexion

		IF !USED('Access') && Si no esta el cursor de accesos lo generamos
			=BuildAccessCursor()
		ENDIF
		THISFORM.SetAll ( [Visible], HasAccess ( [MoneyField] ), [MoneyField] )

		IF goEntorno.SqlEntorno
			THIS.oCnx_ODBC = goConexion
		ENDIF
		THIS.HEIGHT	= IIF(THIS.HEIGHT > thisform.MaxHeight, thisform.MaxHeight,THIS.HEIGHT)
		THIS.WIDTH	= IIF(THIS.WIDTH  > thisform.MaxWidth, thisform.MaxWidth,THIS.WIDTH)

		THIS.lLoad = .T.

		IF THIS.TAG <> "BIENVENIDA"
			goEntorno.GenerarLog("0003",NULL,NULL,THISFORM.CodigoFormulario)
		ENDIF

		IF !EMPTY(this.nombreobjref)
			this.objreftran = eval(this.nombreobjref) 
		ENDIF
		IF !EMPTY(this.nombreobjrefdata)
			this.objreftranData = eval(this.nombreobjrefdata) 
		ENDIF

		IF !EMPTY(this.nomobjcntcab)
			LsObjeto='THIS.'+this.nomobjcntcab
			this.objcntcab  = eval(LsObjeto) 

		ENDIF

		IF !EMPTY(this.nomobjcntpage)
			LsObjeto='THIS.pgfdetalle.page1.'+this.nomobjcntpage
			this.objcntPage  = eval(LsObjeto) 
		ENDIF

		IF !EMPTY(this.nomobjcnt_ref)
			LsObjeto='THIS.'+this.NomObjCnt_Ref
			this.ObjCntRef = eval(LsObjeto) 
		ENDIF


		RETURN .T.
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF !EMPTY(VERSION(2)) 

			LnRpta=MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')


			DO CASE
				CASE  LnRpta =3
					SUSPEND 
				CASE  LnRpta =4 
					SET STEP ON 
				CASE  LnRpta =5
					retry
			ENDCASE
			RETURN CONTEXT_E_ABORTED
		ELSE

			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error :"+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
				STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
				RETURN CONTEXT_E_ABORTED
		ENDIF

	ENDPROC


	PROCEDURE cargar_cursor
	ENDPROC


	PROCEDURE cargar_cursor_detalle
	ENDPROC


	*-- Aqui direccionamos las tablas que se usan como origen de datos para el la cabecera y el detalle de la transacción
	PROCEDURE setdatasource
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_form
**************************************************


**************************************************
*-- Class:        base_form_transac (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_form (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    form
*-- Time Stamp:   08/06/08 01:38:11 PM
*-- Formulario base de transacciones
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS base_form_transac AS base_form


	Height = 550
	Width = 760
	DoCreate = .T.
	Caption = "Transacciones"
	HalfHeightCaption = .F.
	WindowState = 0
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
	*-- Objeto que captura un registro del detalle (GRID)
	oitem = .NULL.
	ccampo_id = ([])
	ccmps_id = ([])
	cvalor_id = ([])
	Name = "base_form_transac"
	Tools.Top = 360
	Tools.Left = 216
	Tools.Height = 24
	Tools.Width = 24
	Tools.Name = "Tools"
	xfimpvta = .F.


	ADD OBJECT cmdiniciar AS cmdnuevo WITH ;
		Top = 360, ;
		Left = 708, ;
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
		TabStyle = 1, ;
		Top = 48, ;
		Left = 0, ;
		Width = 708, ;
		Height = 482, ;
		Tabs = .T., ;
		TabIndex = 7, ;
		Name = "PgfDetalle", ;
		Page1.Caption = "Datos principales", ;
		Page1.PageOrder = 1, ;
		Page1.Name = "Page1", ;
		Page2.Caption = "Otros datos", ;
		Page2.PageOrder = 4, ;
		Page2.Name = "Page2", ;
		Page3.Caption = "Detalle de items", ;
		Page3.PageOrder = 2, ;
		Page3.Name = "Page3", ;
		Page4.Caption = "Transportista", ;
		Page4.PageOrder = 3, ;
		Page4.Name = "Page4"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtnroitm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 65, ;
		MousePointer = 0, ;
		TabIndex = 25, ;
		Top = 311, ;
		Width = 44, ;
		ZOrderSet = 0, ;
		Name = "TxtNroItm"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtnro_itm AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		HelpContextID = 20, ;
		InputMask = "999.99", ;
		Left = 13, ;
		MousePointer = 0, ;
		TabIndex = 24, ;
		Top = 311, ;
		Width = 43, ;
		ZOrderSet = 1, ;
		Name = "txtNro_itm"


	ADD OBJECT base_form_transac.pgfdetalle.page1.base_label5 AS base_label WITH ;
		Caption = "\", ;
		Height = 17, ;
		Left = 58, ;
		Top = 312, ;
		Width = 5, ;
		TabIndex = 27, ;
		ZOrderSet = 2, ;
		Name = "Base_label5"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpvta AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 173, ;
		TabIndex = 26, ;
		Top = 312, ;
		Visible = .F., ;
		Width = 91, ;
		ZOrderSet = 3, ;
		Name = "txtImpVta"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblstatus2 AS base_label WITH ;
		FontBold = .F., ;
		FontSize = 20, ;
		Caption = "", ;
		Height = 35, ;
		Left = 334, ;
		Top = 6, ;
		Visible = .T., ;
		Width = 2, ;
		TabIndex = 22, ;
		ForeColor = RGB(255,255,255), ;
		ZOrderSet = 4, ;
		Name = "lblStatus2"


	ADD OBJECT base_form_transac.pgfdetalle.page1.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Nº Doc.", ;
		Left = 23, ;
		Top = 9, ;
		TabIndex = 19, ;
		ZOrderSet = 5, ;
		Name = "Base_label2"


	ADD OBJECT base_form_transac.pgfdetalle.page1.base_label3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha", ;
		Left = 177, ;
		Top = 9, ;
		TabIndex = 20, ;
		ZOrderSet = 6, ;
		Name = "Base_label3"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtfchdoc AS base_textbox_fecha WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 212, ;
		TabIndex = 2, ;
		Top = 6, ;
		Width = 65, ;
		ZOrderSet = 7, ;
		Name = "TxtFchDoc"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblguias AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Guia(s)", ;
		Left = 413, ;
		Top = 185, ;
		TabIndex = 23, ;
		ZOrderSet = 8, ;
		Name = "LblGuias"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblobserv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Observaciones", ;
		Left = 287, ;
		Top = 8, ;
		TabIndex = 23, ;
		ZOrderSet = 8, ;
		Name = "LblObserv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtnrodoc AS base_textbox WITH ;
		FontBold = .T., ;
		FontSize = 9, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "9999999999", ;
		Left = 64, ;
		MaxLength = 10, ;
		TabIndex = 1, ;
		Top = 7, ;
		Width = 80, ;
		ForeColor = RGB(255,0,0), ;
		DisabledForeColor = RGB(255,0,0), ;
		ZOrderSet = 9, ;
		Name = "TxtNroDoc"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdhelpnrodoc AS base_cmdhelp WITH ;
		Top = 8, ;
		Left = 145, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 16, ;
		ZOrderSet = 10, ;
		cvaloresfiltro = "GoCfgAlm.Subalm;GoCfgAlm.TipMov;GoCfgAlm.CodMOv;GoCfgAlm.NroDoc", ;
		ccamposfiltro = "SubAlm;TipMov;CodMov;NroDoc", ;
		cnombreentidad = "almctran", ;
		ccamporetorno = "nrodoc", ;
		caliascursor = "c_nrodoc", ;
		ccampovisualizacion = "Observ", ;
		Name = "CmdHelpNrodoc"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblstatus1 AS base_label WITH ;
		FontBold = .F., ;
		FontSize = 20, ;
		Caption = "", ;
		Height = 35, ;
		Left = 333, ;
		Top = 9, ;
		Visible = .T., ;
		Width = 2, ;
		TabIndex = 21, ;
		ForeColor = RGB(0,0,160), ;
		ZOrderSet = 11, ;
		Name = "lblStatus1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtglosa2 AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 25, ;
		Left = 455, ;
		TabIndex = 3, ;
		Top = 179, ;
		Visible = .T., ;
		Width = 241, ;
		ZOrderSet = 12, ;
		Name = "TxtGlosa2"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtobserv AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 371, ;
		TabIndex = 3, ;
		Top = 8, ;
		Visible = .T., ;
		Width = 315, ;
		ZOrderSet = 12, ;
		Name = "TxtObserv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpbrt AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 22, ;
		InputMask = "999,999.9999", ;
		Left = 541, ;
		TabIndex = 15, ;
		Top = 361, ;
		Visible = .F., ;
		Width = 88, ;
		ZOrderSet = 14, ;
		Name = "TxtImpBrt"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdadicionar1 AS cmdnuevo WITH ;
		Top = 360, ;
		Left = 671, ;
		Height = 24, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 5, ;
		PicturePosition = 14, ;
		ZOrderSet = 15, ;
		codigoboton = ("00001809"), ;
		Name = "cmdAdicionar1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdmodificar1 AS cmdmodificar WITH ;
		Top = 385, ;
		Left = 671, ;
		Height = 24, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 6, ;
		PicturePosition = 14, ;
		ZOrderSet = 16, ;
		codigoboton = ("00001810"), ;
		Name = "Cmdmodificar1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdeliminar1 AS cmdeliminar WITH ;
		Top = 408, ;
		Left = 671, ;
		Height = 24, ;
		Width = 24, ;
		Enabled = .F., ;
		TabIndex = 7, ;
		PicturePosition = 14, ;
		ZOrderSet = 17, ;
		codigoboton = ("00001812"), ;
		Name = "Cmdeliminar1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 22, ;
		InputMask = "999,999.9999", ;
		Left = 541, ;
		TabIndex = 13, ;
		Top = 382, ;
		Visible = .F., ;
		Width = 88, ;
		ZOrderSet = 18, ;
		Name = "TxtImpIgv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimptot AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 10, ;
		Enabled = .F., ;
		Height = 22, ;
		InputMask = "999,999.9999", ;
		Left = 541, ;
		TabIndex = 14, ;
		Top = 403, ;
		Visible = .F., ;
		Width = 88, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 19, ;
		Name = "TxtImpTot"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtporigv AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 79, ;
		ReadOnly = .T., ;
		TabIndex = 18, ;
		Top = 423, ;
		Visible = .F., ;
		Width = 86, ;
		ZOrderSet = 20, ;
		Name = "txtPorIgv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblsubtot AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Importe Bruto", ;
		Height = 16, ;
		Left = 456, ;
		Top = 365, ;
		Visible = .F., ;
		TabIndex = 30, ;
		ZOrderSet = 21, ;
		Name = "LblSubTot"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lbligv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "I.G.V.", ;
		Height = 16, ;
		Left = 499, ;
		Top = 386, ;
		Visible = .F., ;
		TabIndex = 35, ;
		ZOrderSet = 22, ;
		Name = "LblIgv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lbltotal AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 12, ;
		Caption = "TOTAL", ;
		Left = 480, ;
		Top = 408, ;
		Visible = .F., ;
		TabIndex = 37, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 23, ;
		Name = "LblTotal"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblporigv AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "% I.G.V.", ;
		Height = 16, ;
		Left = 32, ;
		Top = 429, ;
		Visible = .F., ;
		Width = 42, ;
		TabIndex = 29, ;
		ZOrderSet = 24, ;
		Name = "LblPorIgv"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtpordto AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999.99", ;
		Left = 79, ;
		TabIndex = 8, ;
		Top = 383, ;
		Visible = .F., ;
		Width = 86, ;
		ZOrderSet = 25, ;
		Name = "TxtPorDto"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblpordto AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "% Dcto.", ;
		Height = 16, ;
		Left = 35, ;
		Top = 387, ;
		Visible = .F., ;
		Width = 41, ;
		TabIndex = 28, ;
		ZOrderSet = 26, ;
		Name = "LblPorDto"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpdto AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 79, ;
		TabIndex = 17, ;
		Top = 403, ;
		Visible = .F., ;
		Width = 86, ;
		ZOrderSet = 27, ;
		Name = "TxtImpDto"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblimpdto AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Descuentos", ;
		Height = 16, ;
		Left = 8, ;
		Top = 410, ;
		Visible = .F., ;
		TabIndex = 31, ;
		ZOrderSet = 28, ;
		Name = "LblImpDto"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpint AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 284, ;
		TabIndex = 12, ;
		Top = 424, ;
		Visible = .F., ;
		Width = 84, ;
		ZOrderSet = 29, ;
		Name = "TxtImpInt"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblimpint AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Gto. Financiero", ;
		Height = 16, ;
		Left = 196, ;
		Top = 428, ;
		Visible = .F., ;
		TabIndex = 36, ;
		ZOrderSet = 30, ;
		Name = "lblImpInt"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpflt AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 284, ;
		TabIndex = 9, ;
		Top = 361, ;
		Visible = .F., ;
		Width = 82, ;
		ZOrderSet = 31, ;
		Name = "TxtImpFlt"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblimpflt AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Flete", ;
		Height = 16, ;
		Left = 253, ;
		Top = 366, ;
		Visible = .F., ;
		TabIndex = 34, ;
		ZOrderSet = 32, ;
		Name = "LblImpFlt"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpseg AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 285, ;
		TabIndex = 10, ;
		Top = 381, ;
		Visible = .F., ;
		Width = 82, ;
		ZOrderSet = 33, ;
		Name = "TxtImpSeg"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtimpadm AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 285, ;
		TabIndex = 11, ;
		Top = 403, ;
		Visible = .F., ;
		Width = 82, ;
		ZOrderSet = 34, ;
		Name = "TxtImpAdm"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblimpseg AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Seguro", ;
		Height = 16, ;
		Left = 241, ;
		Top = 387, ;
		Visible = .F., ;
		TabIndex = 33, ;
		ZOrderSet = 35, ;
		Name = "LblImpSeg"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblimpadm AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		WordWrap = .F., ;
		Caption = "Gto. Administrativo", ;
		Height = 16, ;
		Left = 174, ;
		Top = 408, ;
		Visible = .T., ;
		Width = 108, ;
		TabIndex = 32, ;
		ZOrderSet = 36, ;
		Name = "LblImpAdm"


	ADD OBJECT base_form_transac.pgfdetalle.page1.txtreten AS base_textbox_numero WITH ;
		FontBold = .T., ;
		FontSize = 10, ;
		Enabled = .F., ;
		Height = 22, ;
		InputMask = "999,999.9999", ;
		Left = 541, ;
		TabIndex = 14, ;
		Top = 425, ;
		Visible = .F., ;
		Width = 88, ;
		ForeColor = RGB(255,0,0), ;
		ZOrderSet = 19, ;
		Name = "TxtReten"


	ADD OBJECT base_form_transac.pgfdetalle.page1.lblretencion AS base_label WITH ;
		FontBold = .T., ;
		FontSize = 8, ;
		Caption = "Retención", ;
		Height = 16, ;
		Left = 476, ;
		Top = 430, ;
		Visible = .F., ;
		TabIndex = 35, ;
		ZOrderSet = 22, ;
		Name = "LblRetencion"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdaceptar1 AS cmdaceptar WITH ;
		Top = 361, ;
		Left = 645, ;
		Height = 24, ;
		Width = 24, ;
		Enabled = .T., ;
		TabIndex = 9, ;
		Visible = .F., ;
		PicturePosition = 14, ;
		codigoboton = ("00001813"), ;
		Name = "Cmdaceptar1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdcancelar1 AS cmdcancelar WITH ;
		Top = 386, ;
		Left = 645, ;
		Height = 24, ;
		Width = 24, ;
		Picture = "..\..\grafgen\iconos\cancelar.bmp", ;
		Enabled = .T., ;
		TabIndex = 10, ;
		Visible = .F., ;
		PicturePosition = 14, ;
		codigoboton = ("00001814"), ;
		Name = "Cmdcancelar1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdterminar AS cmdcancelar WITH ;
		Top = 434, ;
		Left = 671, ;
		Height = 16, ;
		Width = 26, ;
		Enabled = .F., ;
		TabIndex = 10, ;
		Visible = .F., ;
		codigoboton = ("00001814"), ;
		Name = "CmdTerminar"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle AS base_grid WITH ;
		ColumnCount = 10, ;
		Height = 155, ;
		Left = 5, ;
		Panel = 1, ;
		Top = 204, ;
		Width = 693, ;
		AllowCellSelection = .F., ;
		Name = "GrdDetalle", ;
		Column1.CurrentControl = "TxtCodmat", ;
		Column1.Width = 91, ;
		Column1.Name = "Column1", ;
		Column2.CurrentControl = "TxtDesmat", ;
		Column2.Width = 245, ;
		Column2.Name = "Column2", ;
		Column3.ColumnOrder = 3, ;
		Column3.CurrentControl = "TxtUndVta", ;
		Column3.Width = 29, ;
		Column3.Name = "Column3", ;
		Column4.ColumnOrder = 4, ;
		Column4.CurrentControl = "TxtCantidad", ;
		Column4.Name = "Column4", ;
		Column5.ColumnOrder = 5, ;
		Column5.CurrentControl = "TxtFacEqu", ;
		Column5.Width = 61, ;
		Column5.Name = "Column5", ;
		Column6.ColumnOrder = 6, ;
		Column6.CurrentControl = "TxtTotal", ;
		Column6.Width = 91, ;
		Column6.Name = "Column6", ;
		Column7.CurrentControl = "TxtPreUni", ;
		Column7.Name = "Column7", ;
		Column8.CurrentControl = "TxtImpLin", ;
		Column8.Name = "Column8", ;
		Column9.CurrentControl = "TxtLote", ;
		Column9.Name = "Column9", ;
		Column10.CurrentControl = "TxtFchVto", ;
		Column10.Name = "Column10"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column1.header1 AS header WITH ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column1.txtcodmat AS base_textbox_texto WITH ;
		Left = 31, ;
		Top = 43, ;
		Name = "TxtCodmat"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column2.header1 AS header WITH ;
		Caption = "Descripción", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column2.txtdesmat AS base_textbox_texto WITH ;
		Left = 128, ;
		Top = 31, ;
		Name = "TxtDesmat"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column3.header1 AS header WITH ;
		Caption = "Und", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column3.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column3.txtundvta AS base_textbox_texto WITH ;
		Left = 14, ;
		Top = 43, ;
		Name = "TxtUndVta"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column4.header1 AS header WITH ;
		Caption = "Cantidad", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column4.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column4.txtcantidad AS base_textbox_numero WITH ;
		InputMask = "999,999,999.999", ;
		Left = 32, ;
		Top = 43, ;
		Name = "TxtCantidad"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column5.header1 AS header WITH ;
		Caption = "Factor", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column5.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column5.txtfacequ AS base_textbox_numero WITH ;
		Left = 28, ;
		Top = 31, ;
		Name = "TxtFacEqu"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column6.header1 AS header WITH ;
		Caption = "Total", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column6.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column6.txttotal AS base_textbox_numero WITH ;
		Left = 38, ;
		Top = 43, ;
		Name = "TxtTotal"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column7.header1 AS header WITH ;
		Caption = "Prec. Unit.", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column7.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column7.txtpreuni AS base_textbox_numero WITH ;
		Left = 35, ;
		Top = 55, ;
		Name = "TxtPreUni"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column8.header1 AS header WITH ;
		Caption = "Importe", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column8.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column8.txtimplin AS base_textbox_numero WITH ;
		Left = 31, ;
		Top = 55, ;
		Name = "TxtImpLin"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column9.header1 AS header WITH ;
		Caption = "Lote", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column9.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column9.txtlote AS base_textbox_texto WITH ;
		Left = 39, ;
		Top = 43, ;
		Name = "TxtLote"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column10.header1 AS header WITH ;
		Caption = "Fch. Vto.", ;
		Name = "Header1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column10.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_form_transac.pgfdetalle.page1.grddetalle.column10.txtfchvto AS base_textbox_fecha WITH ;
		Left = 23, ;
		Top = 55, ;
		Name = "TxtFchVto"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdhelp_preuni AS base_cmdhelp WITH ;
		Top = 363, ;
		Left = 8, ;
		Height = 21, ;
		Width = 23, ;
		Enabled = .F., ;
		TabIndex = 38, ;
		Visible = .F., ;
		ccamposfiltro = "tabla", ;
		cnombreentidad = "almtgsis", ;
		ccamporetorno = "codigo", ;
		caliascursor = "c_PreUniGrd", ;
		ccampovisualizacion = "Nombre", ;
		Name = "cmdHelp_PreUni"


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdhelpundvta AS base_cmdhelp WITH ;
		Top = 363, ;
		Left = 36, ;
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


	ADD OBJECT base_form_transac.pgfdetalle.page1.cmdduplicaitem AS base_command WITH ;
		Top = 402, ;
		Left = 406, ;
		Height = 24, ;
		Width = 24, ;
		Picture = "..\..\grafgen\iconos\copy.bmp", ;
		Caption = "", ;
		Enabled = .F., ;
		ToolTipText = "Ver referencia de teclas de edición rapida para detalle del asiento", ;
		Visible = .F., ;
		Name = "CmdDuplicaItem"


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdaceptar2 AS cmdaceptar WITH ;
		Top = 172, ;
		Left = 491, ;
		Height = 38, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 9, ;
		PicturePosition = 7, ;
		codigoboton = ("00001813"), ;
		Name = "Cmdaceptar2"


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdcancelar2 AS cmdcancelar WITH ;
		Top = 172, ;
		Left = 551, ;
		Height = 38, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 10, ;
		PicturePosition = 7, ;
		codigoboton = ("00001814"), ;
		Name = "Cmdcancelar2"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtcodmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "R!", ;
		Height = 20, ;
		Left = 120, ;
		MaxLength = 8, ;
		TabIndex = 1, ;
		Top = 39, ;
		Width = 100, ;
		Name = "TxtCodmat"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtdesmat AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 120, ;
		MaxLength = 0, ;
		TabIndex = 3, ;
		Top = 65, ;
		Width = 314, ;
		Name = "TxtDesmat"


	ADD OBJECT base_form_transac.pgfdetalle.page3.base_label1 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Código", ;
		Height = 16, ;
		Left = 81, ;
		Top = 42, ;
		Width = 35, ;
		TabIndex = 11, ;
		Name = "Base_label1"


	ADD OBJECT base_form_transac.pgfdetalle.page3.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Descripción", ;
		Height = 16, ;
		Left = 56, ;
		Top = 66, ;
		Width = 59, ;
		TabIndex = 12, ;
		Name = "Base_label2"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lblund AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Und.", ;
		Height = 16, ;
		Left = 457, ;
		Top = 67, ;
		Width = 24, ;
		TabIndex = 13, ;
		Name = "LblUnd"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lblcantidad AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Cantidad", ;
		Height = 16, ;
		Left = 70, ;
		Top = 93, ;
		Width = 44, ;
		TabIndex = 15, ;
		Name = "LblCantidad"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lblpreuni AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Precio Unitario", ;
		Height = 16, ;
		Left = 44, ;
		Top = 118, ;
		Visible = .F., ;
		Width = 71, ;
		TabIndex = 16, ;
		Name = "LblPreUni"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lblimpcto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Importe", ;
		Height = 16, ;
		Left = 75, ;
		Top = 141, ;
		Visible = .F., ;
		Width = 37, ;
		TabIndex = 17, ;
		Name = "LblImpCto"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtundstk AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 23, ;
		Left = 489, ;
		TabIndex = 14, ;
		Top = 62, ;
		Width = 33, ;
		Name = "TxtUndStk"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtcandes AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 119, ;
		TabIndex = 4, ;
		Top = 91, ;
		Width = 85, ;
		Name = "TxtCanDes"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtpreuni AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.9999", ;
		Left = 120, ;
		TabIndex = 5, ;
		Top = 116, ;
		Visible = .F., ;
		Width = 84, ;
		Name = "TxtPreUni"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtimpcto AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.99", ;
		Left = 119, ;
		TabIndex = 6, ;
		Top = 140, ;
		Visible = .F., ;
		Width = 85, ;
		Name = "TxtImpCto"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtfchvto AS base_textbox_fecha WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 119, ;
		TabIndex = 8, ;
		Top = 188, ;
		Visible = .T., ;
		Width = 96, ;
		Name = "TxtFchVto"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lbllote AS base_label WITH ;
		FontSize = 8, ;
		Caption = "# Lote", ;
		Height = 16, ;
		Left = 78, ;
		Top = 169, ;
		Visible = .T., ;
		Width = 32, ;
		TabIndex = 19, ;
		Name = "LblLote"


	ADD OBJECT base_form_transac.pgfdetalle.page3.lblfchvto AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Fecha Vcmto.", ;
		Height = 16, ;
		Left = 44, ;
		Top = 192, ;
		Visible = .T., ;
		Width = 69, ;
		TabIndex = 18, ;
		Name = "LblFchVto"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtlote AS base_textbox_texto WITH ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 119, ;
		TabIndex = 7, ;
		Top = 164, ;
		Visible = .T., ;
		Width = 96, ;
		Name = "TxtLote"


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdhelplote AS base_cmdhelp WITH ;
		Top = 165, ;
		Left = 225, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		ccamposfiltro = "CodMat", ;
		cnombreentidad = "v_materiales_x_lote", ;
		ccamporetorno = "Lote", ;
		caliascursor = "c_MatLote", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpLote"


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdhelpcodigo AS base_cmdhelp WITH ;
		Top = 39, ;
		Left = 359, ;
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


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdhelpcodmat AS base_cmdhelp WITH ;
		Top = 40, ;
		Left = 224, ;
		Height = 20, ;
		Width = 24, ;
		Enabled = .F., ;
		cvaloresfiltro = "GoCfgAlm.Subalm", ;
		ccamposfiltro = "SubAlm", ;
		cnombreentidad = "v_materiales_x_almacen_2", ;
		ccamporetorno = "CodMat", ;
		caliascursor = "c_MatAlm", ;
		ccampovisualizacion = "Desmat", ;
		Name = "CmdHelpCodMat"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtcodigo AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "R!", ;
		Height = 20, ;
		Left = 256, ;
		MaxLength = 8, ;
		TabIndex = 1, ;
		Top = 39, ;
		Visible = .F., ;
		Width = 100, ;
		Name = "TxtCodigo"


	ADD OBJECT base_form_transac.pgfdetalle.page3.cmdterminar AS cmdcancelar WITH ;
		Top = 236, ;
		Left = 587, ;
		Height = 36, ;
		Width = 56, ;
		Enabled = .F., ;
		TabIndex = 10, ;
		Visible = .F., ;
		codigoboton = ("00001814"), ;
		Name = "CmdTerminar"


	ADD OBJECT base_form_transac.pgfdetalle.page3.txtfacequ AS base_textbox_numero WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		InputMask = "999,999.99", ;
		Left = 545, ;
		TabIndex = 5, ;
		Top = 63, ;
		Visible = .F., ;
		Width = 84, ;
		Name = "TxtFacEqu"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_shape1 AS base_shape WITH ;
		Top = 32, ;
		Left = 23, ;
		Height = 145, ;
		Width = 596, ;
		Name = "Base_shape1"


	ADD OBJECT base_form_transac.pgfdetalle.page4.cmdaceptar3 AS cmdaceptar WITH ;
		Top = 206, ;
		Left = 502, ;
		Height = 40, ;
		Width = 48, ;
		Enabled = .F., ;
		TabIndex = 14, ;
		Visible = .F., ;
		PicturePosition = 7, ;
		Name = "Cmdaceptar3"


	ADD OBJECT base_form_transac.pgfdetalle.page4.cmdcancelar3 AS cmdcancelar WITH ;
		Top = 205, ;
		Left = 562, ;
		Height = 40, ;
		Width = 48, ;
		FontName = "Verdana", ;
		FontSize = 8, ;
		Enabled = .F., ;
		TabIndex = 15, ;
		Visible = .F., ;
		PicturePosition = 7, ;
		Name = "Cmdcancelar3"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label2 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Razón Social", ;
		Height = 16, ;
		Left = 71, ;
		Top = 80, ;
		Width = 65, ;
		TabIndex = 4, ;
		Name = "Base_label2"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label3 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Dirección", ;
		Height = 16, ;
		Left = 88, ;
		Top = 104, ;
		Width = 47, ;
		TabIndex = 6, ;
		Name = "Base_label3"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label4 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "R.U.C.", ;
		Height = 16, ;
		Left = 427, ;
		Top = 59, ;
		Width = 32, ;
		TabIndex = 10, ;
		Name = "Base_label4"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label5 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Placa del Vehículo", ;
		Height = 16, ;
		Left = 43, ;
		Top = 128, ;
		Width = 90, ;
		TabIndex = 8, ;
		Name = "Base_label5"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label6 AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Brevete", ;
		Height = 16, ;
		Left = 421, ;
		Top = 85, ;
		Width = 40, ;
		TabIndex = 12, ;
		Name = "Base_label6"


	ADD OBJECT base_form_transac.pgfdetalle.page4.base_label_shape1 AS base_label_shape WITH ;
		FontBold = .T., ;
		Caption = "Datos del Transportistas", ;
		Height = 17, ;
		Left = 40, ;
		Top = 24, ;
		Width = 142, ;
		TabIndex = 1, ;
		Name = "Base_label_shape1"


	ADD OBJECT base_form_transac.pgfdetalle.page4.txtnomtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 8, ;
		TabIndex = 5, ;
		Top = 77, ;
		Width = 236, ;
		Name = "TxtNomtra"


	ADD OBJECT base_form_transac.pgfdetalle.page4.txtdirtra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 8, ;
		TabIndex = 7, ;
		Top = 102, ;
		Width = 236, ;
		Name = "TxtDirTra"


	ADD OBJECT base_form_transac.pgfdetalle.page4.txtructra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 467, ;
		MaxLength = 8, ;
		TabIndex = 11, ;
		Top = 56, ;
		Width = 100, ;
		Name = "TxtRucTra"


	ADD OBJECT base_form_transac.pgfdetalle.page4.txtplatra AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 20, ;
		Left = 142, ;
		MaxLength = 8, ;
		TabIndex = 9, ;
		Top = 126, ;
		Width = 100, ;
		Name = "TxtPlaTra"


	ADD OBJECT base_form_transac.pgfdetalle.page4.txtbrevet AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Format = "K!", ;
		Height = 23, ;
		Left = 467, ;
		MaxLength = 8, ;
		TabIndex = 13, ;
		Top = 82, ;
		Width = 100, ;
		Name = "TxtBreVet"


	ADD OBJECT base_form_transac.pgfdetalle.page4.cntcodtra AS base_textbox_cmdhelp WITH ;
		Top = 44, ;
		Left = 95, ;
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


	ADD OBJECT cmdadicionar AS cmdnuevo WITH ;
		Top = 72, ;
		Left = 708, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 10, ;
		PicturePosition = 7, ;
		ZOrderSet = 3, ;
		codigoboton = ("00001371"), ;
		Name = "cmdAdicionar"


	ADD OBJECT cmdmodificar AS cmdmodificar WITH ;
		Top = 120, ;
		Left = 708, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 11, ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 4, ;
		codigoboton = ("00001372"), ;
		Name = "Cmdmodificar"


	ADD OBJECT cmdeliminar AS cmdeliminar WITH ;
		Top = 168, ;
		Left = 708, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 12, ;
		Visible = .T., ;
		PicturePosition = 7, ;
		ZOrderSet = 5, ;
		codigoboton = ("00001373"), ;
		Name = "Cmdeliminar"


	ADD OBJECT cmdsalir AS cmdsalir WITH ;
		Top = 456, ;
		Left = 708, ;
		Height = 40, ;
		Width = 48, ;
		TabIndex = 11, ;
		PicturePosition = 7, ;
		Name = "Cmdsalir"


	ADD OBJECT cmdimprimir AS cmdimprimir WITH ;
		Top = 408, ;
		Left = 708, ;
		Height = 40, ;
		Width = 48, ;
		Caption = "\<Imprimir", ;
		Enabled = .F., ;
		TabIndex = 10, ;
		ToolTipText = "Imprimir ", ;
		PicturePosition = 7, ;
		codigoboton = ("00002313"), ;
		Name = "Cmdimprimir"


	ADD OBJECT txtestadocontab AS base_textbox WITH ;
		FontSize = 8, ;
		Enabled = .F., ;
		Height = 20, ;
		Left = 72, ;
		TabIndex = 3, ;
		Top = 530, ;
		Visible = .T., ;
		Width = 180, ;
		ZOrderSet = 8, ;
		Name = "TxtEstadoContab"


	ADD OBJECT lblobserv AS base_label WITH ;
		FontSize = 8, ;
		Caption = "Contabilidad", ;
		Left = 6, ;
		Top = 535, ;
		TabIndex = 9, ;
		ZOrderSet = 9, ;
		Name = "LblObserv"


	ADD OBJECT cmdgrabar AS cmdgrabar WITH ;
		Top = 312, ;
		Left = 708, ;
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
		Left = 273, ;
		Top = 530, ;
		Visible = .T., ;
		Width = 420, ;
		TabIndex = 21, ;
		ForeColor = RGB(0,255,0), ;
		BackColor = RGB(0,0,0), ;
		ZOrderSet = 28, ;
		Name = "lblStatus"


	PROCEDURE iniciar_var
		WITH THISFORM
			.desvincular_controles
		    thisform.objcntcab.Enabled = .T.
			this.objcntcab.iniciar_var()
		    *this.objcntcab.Limpiar_var()
		    
			this.objcntpage.iniciar_var()
		    this.objcntpage.Limpiar_var()
		    
			with thisform.pgfdetalle.page1
				.txtNroDoc.ENABLED		= .F.
				.cmdHelpNroDoc.ENABLED	= .F.
				.txtFchDoc.ENABLED		= .F.
		*!*			.TxtTpoCmb.ENABLED		= .F.
				.TxtObserv.ENABLED		= .F.
				.TxtGlosa2.ENABLED		= .F.
		*!*			.CboCodMon.ENABLED 		= .F.

				.LblStatus1.Caption		= ''
				.LblStatus2.Caption		= ''
				.txtNroDoc.VISIBLE		= .T.
				.txtFchDoc.VISIBLE		= .T.
				.TxtObserv.VISIBLE		= .T.
				.TxtGlosa2.VISIBLE		= .F.
		*!*			.TxtTpoCmb.VISIBLE		= .T.
		*!*			.CboCodMon.VISIBLE		= .T.


		*!*			.LblCodMon.VISIBLE		= .t.

		*!*			.LblTpoCmb.VISIBLE		= .t.


			endwith
			.cmdadicionar.ENABLED	= .T.
			.cmdModificar.ENABLED	= .T.
			.cmdEliminar.ENABLED	= .T.

		    *

		    
			with thisform.pgfdetalle.page1
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
				.TxtCodmat.MaxLength = GaLenCod[3] 
				.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod[3]-GnLenDiv)
				.TxtPreuni.VISIBLE = .f.
				.TxtImpCto.VISIBLE = .f.
				.LblPreuni.VISIBLE = .f.
				.LblImpCto.VISIBLE = .f.
				.TxtFacEqu.Value = 0

			ENDWITH

		    THISFORM.LIMPIAR_VAR()

			.CmdSalir.ENABLED 		= .T.
			.CmdGrabar.ENABLED 		= .F.
			.CmdIniciar.ENABLED		= .F.

		ENDWITH
		=this.objreftran.inicializavariablesCFG()
		 
		THIS.ObjRefTran.Que_Transaccion = THISFORM.Que_transaccion 
		THIS.objreftran.CodSed		= 	GsCodSed
		this.objreftran.subalm		=	GsSubAlm 
		THIS.ObjRefTran.XsTpoDoc	=	thisform.TpoDoc  
		this.ObjReftran.cCursor_C	=	thisform.ccursor_C 
		this.ObjReftran.cCursor_D	=	thisform.ccursor_D 
		this.ObjReftran.caliascab 	=	thisform.caliascab 
		this.ObjReftran.caliasdet 	=	thisform.caliasdet
		THIS.ObjRefTran.EntidadCorrelativo	= thisform.ObjCntCab.EntidadCorrelativo
		this.objcntcab.habilita
		WITH thisform.objcntcab 
			.CboCodDoc.Value = THISFORM.ObjRefTran.XsCodDoc
			.CboCodDoc.InteractiveChange()
			.CboCodDoc.valid()

			.CboTipoFact.ListIndex = THISFORM.ObjRefTran.XnTpoFac
			.CboTipoFact.InteractiveChange()
		ENDWITH 
		thisform.LblStatus.Caption  = 'Listo para realizar transacción'
		thisform.TxtEstadoContab.Value = '' 
		Thisform.Cmdgrabar.Caption = '\<Grabar'
		Thisform.Cmdgrabar.ToolTipText  = 'Grabar cambios'
		IF VARTYPE(THISFORM.CmdDespacho)='O'
			THISFORM.CmdDespacho.Visible = .F.
		ENDIF
	ENDPROC


	PROCEDURE vincular_controles
		LOCAL LcAlmacen,LcTipMov,LcCodMov,LcNroDoc,LcTabla,LlExiste
		PUBLIC LoDatAdm
		LoDatAdm = CREATEOBJECT('DOSVR.DataAdmin') 

		WITH THISFORM

			DO CASE 
				CASE thisform.que_transaccion ='ALMACEN'
					gocfgAlm.SubAlm = .cboAlmacen.value
					GoCfgAlm.cTipMov= IIF(LEFT(.cbotipmov.value,1)=[T],[S],LEFT(.cbotipmov.value,1))
					GoCfgAlm.sCodMov=.cboCodmov.value
					WITH THISFORM.PgfDetalle.page1

						.TxtNroDoc.Value = PADR(.TxtNroDoc.Value,LEN(DTRA.nrodoc))

						GoCfgAlm.sNroDoc = .txtnrodoc.value
						** Preparamos Cursor del Detalle ** 
						=Cap_Almdtran([C_DTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)

						IF THISFORM.xReturn = 'I'   		&& Nuevo Registro
							.txtnrodoc.value=correlativo_alm(GOCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,gocfgalm.SubAlm,'0')  
							thisform.tools.closetable('C_DTRA')
							GoCfgAlm.sNroDoc = .txtnrodoc.value
					 		=Cap_Almdtran([C_DTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
						ENDIF

						LlExiste=SEEK(gocfgalm.SubAlm+GoCfgAlm.cTipMov+GoCfgAlm.sCodMov+GoCfgAlm.sNroDoc,'DTRA','DTRA01')


						IF val(.txtnrodoc.value)=0
							RETURN .f.
						ENDIF

						LcNroDoc = trim(.txtnrodoc.value)
						** Preparamos Cursor de la cabecera ** 
						=Cap_Almctran([C_CTRA],gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
						IF INLIST(thisform.xreturn ,'A','E')
							IF THISFORM.Tools.cursor_esta_vacio("C_CTRA")	&& No existe Nro. de documento
								RELEASE LoDatAdm
								RETURN .f.
							ENDIF
						ENDIF
						thisform.Desvincular_Controles()
						thisform.PgfDetalle.Page1.CmdHelpNrodoc.Enabled=.F.
						** Capturamos la configuracion de transacciones para el tipo y codigo de la configuración en ALMCFTRA
						=gocfgalm.Cap_Cfg_Transacciones(GoCfgAlm.cTipMov,GoCfgAlm.sCodMov)
						IF THISFORM.xReturn <> 'I'   		&& Nuevo Registro
							.TxtFchDoc.Value 	=	C_CTRA.FchDoc
							.TxtTpoCmb.VALUE 	=	C_CTRA.TpoCmb
							.CboCodMon.VALUE 	=	C_CTRA.CodMon
							.TxtNroRf1.VAlue 	=	C_CTRA.NroRf1
							.TxtNroRf2.VALUE 	=	C_CTRA.NroRf2
							.TxtNroRf3.VALUE 	=	C_CTRA.NroRf3
							.CboCodPro.VALUE 	=	C_CTRA.CodPro
							.TxtCodVen.VALUE 	=	C_CTRA.CodVen
							.CntCodCli.VALUE 	=	C_CTRA.CodCli
							.CboCodPar.VALUE 	=	C_CTRA.CodPar
							.TxtObserv.VALUE 	=	C_CTRA.Observ
							.TxtNroOdt.VALUE 	=	C_CTRA.NroODt
							.CboCodPrd.VALUE 	=	C_CTRA.CodPrd
							.CboLotes.VALUE		=	C_CTRA.CodLote
							.CboCodProcs.VALUE	=	C_CTRA.CodProcs
							.CboCodActiv.VALUE	=	C_CTRA.CodActiv
							.CboCultivo.VALUE	=	C_CTRA.CodCult
							.CboCodFase.VALUE	=	C_CTRA.CodFase
							*
							.CboAlmOri.VALUE    =   C_CTRA.AlmOri
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

						.TxtNroOdt.ENABLED 		=	goCfgAlm.lPidOdt AND THISFORM.xReturn <> "E"
						.CboCodPrd.ENABLED 		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						.CboLotes.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						.CboCodProcs.ENABLED	=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						.CboCodActiv.ENABLED	=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						.CboCultivo.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						.CboCodFase.ENABLED		=	goCfgAlm.lModCsm AND THISFORM.xReturn <> "E"
						 **
						.LblNroOdt.VISIBLE 		=	goCfgAlm.lPidOdt
						.LblCodPrd.VISIBLE 		=	goCfgAlm.lModCsm
						.LblLotes.VISIBLE		=	goCfgAlm.lModCsm
						.LblCodProcs.VISIBLE	=	goCfgAlm.lModCsm
						.LblCodActiv.VISIBLE	=	goCfgAlm.lModCsm
						.LblCultivo.VISIBLE		=	goCfgAlm.lModCsm
						.LblCodFase.VISIBLE		=	goCfgAlm.lModCsm
						IF goCfgAlm.lModCsm AND THISFORM.xReturn = "I"
						    * Muestra los Lotes que corresponde al Predio Seleccionado
				            .CboLotes.cValoresFiltro=gsCodSed
				            .CboLotes.GenerarCursor()
				            *
							.CboLotes.interactivechange()	            
							.CboCodProcs.interactivechange()
						ENDIF
						**
						.TxtTpoCmb.VISIBLE 		=	goCfgAlm.lPidPco
						.CboCodMon.VISIBLE 		=	goCfgAlm.lPidPco
						.TxtNroRf1.VISIBLE 		=	goCfgAlm.lPidRf1
						.TxtNroRf2.VISIBLE 		=	goCfgAlm.lPidRf2
						.TxtNroRf3.VISIBLE 		=	goCfgAlm.lPidRf3
						.CboCodPro.VISIBLE 		=	goCfgAlm.lPidPro
						.TxtCodVen.VISIBLE 		=	goCfgAlm.lPidVen
						.CntCodCli.VISIBLE 		=	goCfgAlm.lPidCli
						.CboCodPar.VISIBLE 		=	goCfgAlm.lPidActFijo
						*
						.CboAlmOri.VISIBLE 	    =	IIF(LEFT(THISFORM.CboTipMov.VALUE,1)='T',.T.,.F.)
						*
						.TxtTpoCmb.ENABLED 		=	goCfgAlm.lPidPco AND THISFORM.xReturn <> "E"
						.CboCodMon.ENABLED 		=	goCfgAlm.lPidPco AND THISFORM.xReturn <> "E"
						.TxtNroRf1.ENABLED 		=	goCfgAlm.lPidRf1 AND THISFORM.xReturn <> "E"
						.TxtNroRf2.ENABLED 		=	goCfgAlm.lPidRf2 AND THISFORM.xReturn <> "E"
						.TxtNroRf3.ENABLED 		=	goCfgAlm.lPidRf3 AND THISFORM.xReturn <> "E"
						.CboCodPro.ENABLED 		=	goCfgAlm.lPidPro AND THISFORM.xReturn <> "E"
						.TxtCodVen.ENABLED 		=	goCfgAlm.lPidVen AND THISFORM.xReturn <> "E"
						.CntCodCli.ENABLED 		=	goCfgAlm.lPidCli AND THISFORM.xReturn <> "E"
						.CboCodPar.ENABLED 		=	goCfgAlm.lPidActFijo AND THISFORM.xReturn <> "E"
						.CboAlmOri.ENABLED 	    =	IIF(LEFT(THISFORM.CboTipMov.VALUE,1)='T',.T.,.F.) AND THISFORM.xReturn <> "E"
						*
						.LblTpoCmb.VISIBLE 		=	goCfgAlm.lPidPco
						.LblCodMon.VISIBLE 		=	goCfgAlm.lPidPco
						.LblGloRf1.VISIBLE 		=	goCfgAlm.lPidRf1
						.LblGloRf2.VISIBLE 		=	goCfgAlm.lPidRf2
						.LblGloRf3.VISIBLE 		=	goCfgAlm.lPidRf3
						.LblCodPro.VISIBLE 		=	goCfgAlm.lPidPro
						.LblCodVen.VISIBLE 		=	goCfgAlm.lPidVen
						.LblCodCli.VISIBLE 		=	goCfgAlm.lPidCli
						.LblCodPar.VISIBLE 		=	goCfgAlm.lPidActFijo
						**
						.LblAlmOri.VISIBLE 	    =	IIF(LEFT(THISFORM.CboTipMov.VALUE,1)='T',.T.,.F.)
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
						.TxtNroDoc.ENABLED 		= .F.


					ENDWITH
					WITH thisform.PgfDetalle.Page1

						.TxtNroItm.Value	= EVALUATE(THISFORM.cCursor_C+'.'+NroItm)
						.TxtPorIgv.Value	= EVALUATE(THISFORM.cCursor_C+'.'+PorIgv)
						.txtImpBrt.Value	= EVALUATE(THISFORM.cCursor_C+'.'+ImpBrt)
						.txtImpIgv.VALUE	= EVALUATE(THISFORM.cCursor_C+'.'+ImpIgv)
						.txtImpTot.VALUE	= EVALUATE(THISFORM.cCursor_C+'.'+ImpTot)
						**
		*				.TxtPorIgv.ENABLED 	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta) AND THISFORM.xReturn <> "E"
						**
						.TxtPorIgv.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpBrt.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpIgv.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.txtImpTot.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						**
						.LblPorIgv.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblSubTot.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblIgv.VISIBLE		= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
						.LblTotal.VISIBLE	= (thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)

						**
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
						.ObjRefTran.CfgVar_PK(thisform.ctabla_c) && Vett 2006/07/04
						LlOkC1=LoDatAdm.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
					ENDWITH

					IF THISFORM.xReturn = 'I'   		&& Nuevo Registro

						**LoDatAdm.correlativo(LcTabla,LcCmps,LcVlrs,LcCmpId,LnLenId,.T.,0,'0')
						THISFORM.OBJREFTRAN.CFGVAR_ID(thisform.objreftran.EntidadCorrelativo)
						.txtnrodoc.value=THISFORM.OBJREFTRAN.GEN_id('0') 
						IF val(.txtnrodoc.value)<=0
							=messagebox('No existe correlativo definido para este documento, verificar maestro de correlativos',16,'Correlativo sin definir')
							RELEASE LoDatAdm
							RETURN .f.
						ENDIF
						*** Ini: Chequeamos si ya existe el documento && Vett 2007/09/08
						thisform.objreftran.XsNroDoc = .txtnrodoc.value
						WITH thisform

							.cvalor_pk = .Traervalor_pk()
							*.ObjRefTran.CfgVar_PK(thisform.ctabla_c)
							.ObjRefTran.cValor_PK = .ObjRefTran.cValor_PK
						ENDWITH

						WITH THISFORM.OBJREFTRAN
							IF SEEK(.cValor_PK ,.cAliasCab,.cIndice_PK)
								RELEASE LoDatAdm
								thisform.MensajeErr(REGISTRO_YA_EXISTE)
							    RETURN .F.
							ENDIF
		  				ENDWITH
		  				*** Fin:
		  
						thisform.tools.closetable(this.cCursor_D )
						thisform.objreftran.XsNroDoc = .txtnrodoc.value
						thisform.cvalor_pk = thisform.Traervalor_pk()
						WITH thisform
							LoDatAdm.GenCursor(this.cCursor_D ,this.cTabla_D ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
						ENDWITH
					ENDIF
					*
					IF val(.txtnrodoc.value)=0
						RELEASE LoDatAdm
						RETURN .f.
					ENDIF

					thisform.objreftran.XsNroDoc = trim(.txtnrodoc.value)
					** Preparamos Cursor de la cabecera ** 

					LoDatAdm.GenCursor(this.cCursor_C ,this.cTabla_C ,this.cindice_pk,tHIS.ccampos_pk,this.cValor_PK)
					IF INLIST(thisform.xreturn ,'A','E')
						IF THISFORM.Tools.cursor_esta_vacio(this.cCursor_C)	&& No existe Nro. de documento
							=MESSAGEBOX('No existe Nro. de documento',64,'Atención')
							RELEASE LoDatAdm
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
					IF Thisform.ObjReftran.XsCodDoc = 'PEDI' .or. Thisform.ObjReftran.XsCodDoc = 'PROF'

					ELSE
						THISFORM.XsNroMes = EVALUATE(this.cCursor_C+'.NroMes')
						THISFORM.XsCodOpe = EVALUATE(this.cCursor_C+'.CodOpe')
						THISFORM.Xsnroast = EVALUATE(this.cCursor_C+'.NroAst')
					ENDIF
					**

					IF THISFORM.xReturn <> 'I'   		&& Nuevo Registro

						.TxtFchDoc.Value 	=	EVALUATE(this.cCursor_C+'.FchDoc')
						.TxtObserv.VALUE 	=	EVALUATE(this.cCursor_C+'.Glodoc')
						.TxtGlosa2.VALUE 	=	EVALUATE(this.cCursor_C+'.Glosa2')

						WITH thisform.objcntpage 
							.TxtTpoCmb.VALUE 	=	EVALUATE(this.cCursor_C+'.TpoCmb')
							.CboCodMon.VALUE 	=	EVALUATE(this.cCursor_C+'.CodMon')
							.CntCodCli.VALUE 	=	EVALUATE(this.cCursor_C+'.CodCli')
						*	.TxtDirAux.VALUE	= 	EVALUATE(this.cCursor_C+'.DirCli')
							.CntCodCli.TxtCodigo.InteractiveChange()
							.CboCodDire.VALUE   = 	EVALUATE(this.cCursor_C+'.CodDire')
							.TxtNroRef.Value	= 	EVALUATE(this.cCursor_C+'.NroRef')

							.TxtRucAux.VALUE	=	EVALUATE(this.cCursor_C+'.RucCli')
							.TxtNroPed.VALUE	=   EVALUATE(this.cCursor_C+'.NroPed')
							IF thisform.ObjRefTran.XsCodDoc='PEDI' OR Thisform.ObjReftran.XsCodDoc = 'PROF'
								.TxtFchPed.VALUE	=   EVALUATE(this.cCursor_C+'.FchVto')
							ELSE

							ENDIF
							.TxtNroO_C.VALUE	=	EVALUATE(this.cCursor_C+'.NroO_C')
							.TxtFchO_C.VALUE	=	EVALUATE(this.cCursor_C+'.FchO_C')
							.CboFmaPgo.Value	= 	PADR(EVALUATE(this.cCursor_C+'.CndPgo'),LEN(TABL.Codigo))
							.TxtCndPgo.Value	= 	EVALUATE(this.cCursor_C+'.CndPgo')
							.SpnDiaVto.VALUE	=	EVALUATE(this.cCursor_C+'.DiaVto')
							.CboTpoVta.Value	= 	STR(EVALUATE(this.cCursor_C+'.TpoVta'),1,0)
							.CboDestino.Value   =   EVALUATE(this.cCursor_C+'.Destino')
							.CboDestino.InteractiveChange()
							.CboVia.Value		=	EVALUATE(this.cCursor_C+'.Via') 
							.CboRuta.VAlue		=   EVALUATE(this.cCursor_C+'.Ruta') 
							LsAgente=EVALUATE(this.cCursor_C+'.Agente')
							.ChkRetencion.Value = (LsAgente = 'S' ) 
							** Actualizamos objeto de transacciones ** ¿¿!!! Revisar cuando se haga COM¡¡¡¡???
							THISFORM.Objreftran.XsNroRef = .TxtNroRef.Value

						ENDWITH

						WITH thisform.objcntcab 
							.cboPtoVTa.value = EVALUATE(this.cCursor_C+'.PtoVta') && LEFT(EVALUATE(this.cCursor_C+'.nrodoc'),3)
							.CboCodDoc.Value = EVALUATE(this.cCursor_C+'.CodDoc')
							.CboCodVen.Value = EVALUATE(this.cCursor_C+'.CodVen')
							.CboTipoFact.Value = EVALUATE(this.cCursor_C+'.CodRef')
							IF INLIST(.CboCodDoc.Value,'PEDI','PROF')
								.CboTipoFact.ListIndex = 0		&& No hay que dejarlo en 0
							ELSE
								.CboTipoFact.InteractiveChange()
							ENDIF
						ENDWITH 

					ELSE

						WITH thisform.objcntpage 
							.CboTpoVta.Value	= 	STR(THISFORM.ObjRefTran.XnTpoVta,1,0)
							.CboFmaPgo.Value	= 	IIF(SEEK('FP','TABL','TABL01'),TABL.Codigo,SPACE(LEN(TABL.Codigo)))    && THISFORM.ObjRefTran.XiFmaPgo
							.CboVia.Value		=   THISFORM.ObjRefTran.XcVia
							.CboDestino.Value	=   THISFORM.ObjRefTran.XcDestino
							.CboCodVia.Value	=	thisform.ObjReftran.XsCodVia
							.CboRuta.Value		=	thisform.ObjReftran.XsRuta
							IF thisform.xReturn='I'
								.CboCodMon.Value = 2 && 
								.CboFmaPgo.Value = PADR('C/E',LEN(TABL.Codigo)) && Contra Entrega

							ENDIF
						ENDWITH

					ENDIF


				ENDWITH
				** Configuración de controles condicionados en pagina de la cabecera
				WITH thisform.objcntpage 
					.CboDestino.InteractiveChange()
				ENDWITH

				WITH thisform.PgfDetalle.Page1
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
					.TxtImpDto.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TXtPorDto.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpInt.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpFlt.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpSeg.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpAdm.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					**
					.LblPorIgv.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
					.LblSubTot.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
					.LblIgv.VISIBLE		= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
					.LblTotal.VISIBLE	= .t.	&&(thisform.objreftran.lPidPco or thisform.objreftran.lCtoVta)
					.LblImpDto.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.LblPorDto.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.LblImpInt.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.LblImpFlt.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.LblImpSeg.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.LblImpAdm.VISIBLE  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					**
					.TxtImpInt.ENABLED  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TXtPorDto.ENABLED  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpFlt.ENABLED	= thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpSeg.ENABLED  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtImpAdm.ENABLED  = thisform.objreftran.lCtoVta AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
					.TxtGlosa2.VISIBLE 	= .t.
					**
				ENDWITH
				IF VARTYPE(THISFORM.CmdDespacho)='O'
					thisform.CmdDespacho.Visible = INLIST(thisform.objreftran.XsCodRef,'FREE','G/R') and thisform.xreturn='A'
				ENDIF

		ENDCASE

		thisform.Vincular_detalle 

			WITH THIS.pgfDetalle.PAGES(1).grdDetalle
				.RECORDSOURCETYPE	= 1
				.RECORDSOURCE		= this.ccursor_d 
				DO CASE 
					CASE thisform.que_transaccion ='ALMACEN'

						IF goCfgAlm.lPidPco

							.COLUMNCOUNT   = 8
							.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
							.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
							.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndStk"
							.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
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
							.COLUMNS(1).CONTROLSOURCE = "C_DTRA.CodMat"
							.COLUMNS(2).CONTROLSOURCE = "C_DTRA.DesMat"
							.COLUMNS(3).CONTROLSOURCE = "C_DTRA.UndStk"
							.COLUMNS(4).CONTROLSOURCE = "C_DTRA.CanDes"
							.COLUMNS(5).HEADER1.CAPTION = "# Lote"
							.COLUMNS(6).HEADER1.CAPTION = "Fch. Vto."

							.COLUMNS(5).CONTROLSOURCE = "C_DTRA.Lote"
							.COLUMNS(6).CONTROLSOURCE = "C_DTRA.FchVto"
							*
						ENDIF
					CASE thisform.que_transaccion ='VENTAS'

						LsCmpCnt=IIF(!INLIST(thisform.objreftran.XsCodDoc,'PEDI','PROF'),'CanFac','CanPed')
						IF (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta ) AND !INLIST(thisform.objreftran.XsCodDoc,'PEDI','PROF')
		*!*						.COLUMNCOUNT   = 8
							.FONTSIZE      = 8
						   *.BACKCOLOR     = "255,255,255"
						   *.GRIDLINECOLOR = "192,192,192"
							*
							.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".CodMat"
							.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".DesMat"
							.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".UndVta"
							.COLUMNS(4).CONTROLSOURCE = IIF(!INLIST(thisform.objreftran.XsCodDoc,'PEDI','PROF'),THISFORM.cCursor_D+".CanFac",THISFORM.cCursor_D+".CanPed")
							.COLUMNS(5).CONTROLSOURCE = THISFORM.cCursor_D+".FacEqu"
							.COLUMNS(6).CONTROLSOURCE = "ROUND("+THISFORM.cCursor_D+".FacEqu"+"*"+THISFORM.cCursor_D+"."+LsCmpCnt+",2)"
							.COLUMNS(5).HEADER1.CAPTION = "Factor Unidad  Venta"
							.COLUMNS(5).HEADER1.WORDWRAP = .T.
							.COLUMNS(6).HEADER1.CAPTION = "Total"
							.COLUMNS(5).WIDTH = 0
							.COLUMNS(6).WIDTH = 0
							.COLUMNS(5).Readonly = .T.
							.COLUMNS(6).Readonly = .T.

							.COLUMNS(7).WIDTH = thisform.Width_Col7
							.COLUMNS(8).WIDTH = thisform.Width_Col8
							.COLUMNS(7).CONTROLSOURCE = THISFORM.cCursor_D+".PreUni"
							.COLUMNS(8).CONTROLSOURCE = THISFORM.cCursor_D+".ImpLin"
							.COLUMNS(7).HEADER1.CAPTION = "Prec.Uni."
							.COLUMNS(8).HEADER1.CAPTION = "Importe"
							.COLUMNS(9).CONTROLSOURCE = THISFORM.cCursor_D+".Lote"
							.COLUMNS(10).CONTROLSOURCE = THISFORM.cCursor_D+".FchVto"
							.COLUMNS(9).HEADER1.CAPTION = "# Lote"
							.COLUMNS(10).HEADER1.CAPTION = "Fch. Vto."
							.COLUMNS(1).Resizable = .T.
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
								OTHERWISE

									DO CASE
										CASE GsSigCia='CAUCHO'	&& Por ahora lo controlamos asi, despues debe de venir en la configuracion, que seria 

		*									.COLUMNCOUNT   = 8
											.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".CodMat"
											.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".DesMat"
											.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".UndVta"
											.COLUMNS(4).CONTROLSOURCE = THISFORM.cCursor_D+"."+LsCmpCnt
											.COLUMNS(5).WIDTH = thisform.Width_Col5
											.COLUMNS(6).WIDTH = thisform.Width_Col6
											.COLUMNS(5).CONTROLSOURCE = THISFORM.cCursor_D+".FacEqu" &&THISFORM.cCursor_D+".PreUni"
				 							.COLUMNS(6).CONTROLSOURCE = "ROUND("+THISFORM.cCursor_D+".FacEqu"+"*"+THISFORM.cCursor_D+"."+LsCmpCnt+",2)"
											.COLUMNS(5).HEADER1.CAPTION = "Factor Unidad  Venta"
											.COLUMNS(5).HEADER1.WORDWRAP = .T.
											.COLUMNS(6).HEADER1.CAPTION = "Total"
											.COLUMNS(7).CONTROLSOURCE = THISFORM.cCursor_D+".Preuni"
											.COLUMNS(8).CONTROLSOURCE = THISFORM.cCursor_D+".ImpLin"
											.COLUMNS(9).CONTROLSOURCE = THISFORM.cCursor_D+".Lote"
											.COLUMNS(10).CONTROLSOURCE = THISFORM.cCursor_D+".FchVto"
											.COLUMNS(9).HEADER1.CAPTION = "# Lote"
											.COLUMNS(10).HEADER1.CAPTION = "Fch. Vto."
											.COLUMNS(9).WIDTH = 0
											.COLUMNS(10).WIDTH = 0

										OTHERWISE
		*									.COLUMNCOUNT   = 8
											.COLUMNS(1).CONTROLSOURCE = THISFORM.cCursor_D+".CodMat"
											.COLUMNS(2).CONTROLSOURCE = THISFORM.cCursor_D+".DesMat"
											.COLUMNS(3).CONTROLSOURCE = THISFORM.cCursor_D+".UndVta"
											.COLUMNS(4).CONTROLSOURCE = THISFORM.cCursor_D+"."+LsCmpCnt
											.COLUMNS(5).CONTROLSOURCE = THISFORM.cCursor_D+".FacEqu" &&THISFORM.cCursor_D+".PreUni"
				 							.COLUMNS(6).CONTROLSOURCE = "ROUND("+THISFORM.cCursor_D+".FacEqu"+"*"+THISFORM.cCursor_D+"."+LsCmpCnt+",2)"
											.COLUMNS(5).HEADER1.CAPTION = "Factor Unidad  Venta"
											.COLUMNS(5).HEADER1.WORDWRAP = .T.
											.COLUMNS(6).HEADER1.CAPTION = "Total"
											.COLUMNS(5).WIDTH = 0
											.COLUMNS(6).WIDTH = 0
											.COLUMNS(7).WIDTH = thisform.Width_Col7
											.COLUMNS(8).WIDTH = thisform.Width_Col8
											.COLUMNS(7).CONTROLSOURCE = THISFORM.cCursor_D+".PreUni"
											.COLUMNS(8).CONTROLSOURCE = THISFORM.cCursor_D+".ImpLin"
											.COLUMNS(9).WIDTH = thisform.Width_Col9
											.COLUMNS(10).WIDTH = thisform.Width_Col10
											.COLUMNS(9).CONTROLSOURCE = THISFORM.cCursor_D+".Lote"
											.COLUMNS(10).CONTROLSOURCE = THISFORM.cCursor_D+".FchVto"
											.COLUMNS(9).HEADER1.CAPTION = "# Lote"
											.COLUMNS(10).HEADER1.CAPTION = "Fch. Vto."

									ENDCASE
							ENDCASE
							*
							.COLUMNS(1).Resizable = .T.
						ENDIF
				ENDCASE

				.AfterRowColChange()
				.REFRESH()
			ENDWITH
			WITH thisform.PgfDetalle.Page1
				.cmdAdicionar1.ENABLED	= (thisform.xReturn<> 'E' AND (thisform.objreftran.XsCodRef = 'FREE' or thisform.objreftran.XsCodDoc = 'PEDI' or thisform.objreftran.XsCodDoc = 'PROF' ))
				LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_D)
				.cmdModificar1.ENABLED	= (LlHayRegistros AND THISFORM.XRETURN<>'E')
				.cmdEliminar1.ENABLED	= LlHayRegistros AND (THISFORM.XRETURN<>'E' AND (THISFORM.ObjReftran.XsCodRef='FREE' or THISFORM.ObjReftran.XsCodDoc='PEDI' OR THISFORM.ObjReftran.XsCodDoc='PROF') )
				IF THISFORM.XRETURN='I'
					.txtPORIGV.Value  = thisform.ObjrefTran.XfPorIgv
				ELSE
					.txtPORIGV.Value  = EVALUATE(THISFORM.cCursor_C+'.PorIgv')
				ENDIF
			ENDWITH

			WITH thisform.PgfDetalle.Page3
				thisform.vincular_detalle()  && Sera ??
				.TxtPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
				.TxtImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
				.LblPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
				.LblImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !thisform.objreftran.XsCodDoc='PEDI' AND !thisform.objreftran.XsCodDoc='PROF'
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


			.CmdImprimir.ENABLED  	= LlHayRegistros
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
		RELEASE LoDatAdm


		RETURN .t.
	ENDPROC


	PROCEDURE desvincular_controles
		WITH THIS.pgfDetalle.PAGES(1).grdDetalle
			.ColumnCount = 10
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

				m.Glosa2  = IIF(!EMPTY(Thisform.ObjRefTran.XsGlosa2),Thisform.ObjRefTran.XsGlosa2,.TxtGlosa2.Value)
				*
				DO CASE
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
							m.CodCli  = IIF(goCfgAlm.lpidCli,.CntCodCli.VALUE,[ ])
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
							m.PtoVta	=   .XsPtoVta
							m.NroDoc	= 	.XsNroDoc
							m.CodRef	= 	.XsCodRef 
							m.CodVen	=	.XsCodVen
							m.FlgEst	=	.XcFlgEst
							m.FlgUbc	=	.XcFlgUbc

						ENDWITH
						WITH THISFORM.ObjCntPage
							m.CodCli	=	.CntCodCli.Value
							m.NomCli	= 	.CntCodCli.TxtDescripcion.Value
							m.CodDire 	= 	.CboCodDire.VAlue
							m.DirCli	=	.CboCodDire.DISPLAYVALUE
							m.RucCli	=	.TxtRucAux.Value 
							m.CodMon	= 	.CboCodMon.Value
							m.TpoCmb	=	.TxtTpoCmb.Value
							m.TpoVta	=   VAL(.CboTpoVta.Value)
							m.NroRef	= 	.TxtNroRef.Value
							m.FmaPgo	=	.CboFmaPgo.ListIndex
							m.CndPgo	=	.CboFmaPgo.Value && .TxtCndPgo.Value  && 
							m.DiaVto	=	.SpnDiaVto.Value
							m.NroPed	=	.TxtNroPed.Value
							IF !thisform.ObjReftran.XsCodDoc='PEDI' AND !thisform.ObjReftran.XsCodDoc='PROF'
								m.FchPed	=	.TxtFchPed.Value
							ELSE
								m.FchVto	=	.TxtFchPed.Value
							ENDIF
							m.NroO_C	=	.TxtNroO_C.Value
							m.FchO_C	=	.TxtFchO_C.Value
							m.Destino	= 	.CboDestino.VALUE
							m.Via		= 	.CboVia.VALUE
							M.TablDest	=   .CboDestino.cValoresFiltro
							m.TablVia   =   .CboCodVia.cValoresFiltro
							m.Ruta		=   .CboRuta.Value
							m.TablRuta  =   .CboRuta.cValoresFiltro
						ENDWITH
						WITH thisform.pgfDetalle.PAGES(1)
							m.GloDoc	= 	.TxtObserv.Value
						ENDWITH
				ENDCASE

			ENDWITH
			**
			WITH .pgfDetalle.PAGES(1)
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
				*** La renteción  *** VETT 2006-02-11
				IF INLIST(THISFORM.ObJRefTran.XsCodDoc,'FACT','BOLE')
					RfTotMinMN	=	IIF(m.Codmon=1,m.ImpTot,ROUND(m.ImpTot*m.TpoCmb,2))
					m.Agente	=   IIF(THISFORM.ObjCntPage.ChkRetencion.Value and RfMontoMin>700,'S','') 
					m.Reten		=   IIF(m.agente='S',round(m.ImpTot*.06,2),0)
				ELSE
					m.Agente	= ''
					m.Reten		= 0
				ENDIF
			ENDWITH
		    **
		  
			WITH .pgfDetalle.PAGES(3)

				m.CodMat	=	.TxtCodMat.VALUE
				m.UndStk	=	.TxtUndStk.VALUE
				m.UndVta	=	.TxtUndStk.VALUE
				IF !INLIST(thisform.Objreftran.XsCodDoc,'PEDI') AND !INLIST(thisform.Objreftran.XsCodDoc,'PROF')
					m.Candes	=	.TxtCandes.VALUE
					m.CanFac	=	.TxtCandes.VALUE
				ELSE
					m.Candes	=	0
					m.CanFac	=	0
					m.CanPed	= 	.TxtCandes.VALUE
				ENDIF
				m.PreUni	=	.TxtPreUni.VALUE
				m.ImpCto	=	.TxtImpCto.VALUE
				m.ImpLin	=	.TxtImpCto.VALUE
				m.DesMat	=	.TxtDesMat.VALUE
				m.Lote		=	.TxtLote.VALUE
		*		m.FchVto	=	.TxtFchVto.VAlue
			ENDWITH
			**
			WITH .pgfDetalle.PAGES(4)
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
						.txtnrodoc.value=THISFORM.ObjRefTran.Gen_ID('0') 
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
					IF thisform.ObjReftran.XsCodRef = 'FREE' OR thisform.ObjReftran.XsCodDoc='P' OR thisform.ObjReftran.XsCodDoc='PROF'
		*				append blank
					ENDIF
					IF !EMPTY(SubAlm) && Ya viene el Subalm en el cursor
						gather MEMVAR FIELDS EXCEPT SubAlm
					ELSE
						gather memvar
					ENDIF
					IF TABLEUPDATE()
						SCATTER NAME thisform.oitem  
					ENDIF
				ELSE
					SELECT * FROM (THISFORM.ccursor_C) INTO CURSOR XTMP_DETA
					USE IN XTMP_DETA
					m.NroItm = _TALLY
					** Cursor Local
					sele (THISFORM.ccursor_C)  &&C_CTRA
					gather MEMVAR memo
					SCATTER NAME thisform.oitem  
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
		*				append blank
						IF !EMPTY(SubAlm) && Ya viene el Subalm en el cursor
							gather MEMVAR FIELDS EXCEPT SubAlm
						ELSE
							gather memvar
						ENDIF
						IF TABLEUPDATE()
							SCATTER NAME thisform.oitem  
						ENDIF
						*THISFORM.ObjRefTran.GiTotItm = THISFORM.ObjRefTran.GiTotItm + 1

					case tcOpcion == "A"	&& Actualizar
						sele (THISFORM.ccursor_D)
						IF !EMPTY(SubAlm) && Ya viene el Subalm en el cursor
							gather MEMVAR FIELDS EXCEPT SubAlm
						ELSE
							gather memvar
						ENDIF
						IF TABLEUPDATE()
							SCATTER NAME thisform.oitem  
						ENDIF
					case tcOpcion == "E"	&& Eliminar

		*				m.NroItm = C_DTRA.NroItm
						m.NroItm = EVALUATE(THISFORM.ccursor_D+'.Nro_Itm')

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
						=TABLEUPDATE()
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
		    		   .txtNroDoc.VALUE = THISFORM.OBJREFTRAN.GEN_id('0')
					ENDIF
					m.NroDoc = TRIM(.txtnrodoc.value)
				ENDWITH
				*

				DO CASE
					CASE THISFORM.QUE_transaccion = 'ALMACEN'
						THISFORM.OBJREFTRAN.sNroDoc	= m.NroDoc
						*thisform.traervalor_pk() 
						IF Thisform.xreturn = 'E' && Eliminar transaccion
							LnControl = Borrar_transaccion_Alm(gocfgalm.CodSed,gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
						ELSE
							LnControl = Grabar_transaccion_Alm(gocfgalm.CodSed,gocfgalm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
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
					        	         .TxtNroDoc.VALUE = Correlativo_Alm(GoCfgAlm.EntidadCorrelativo,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,goCfgAlm.SubAlm,[0])
							             m.NroDoc = TRIM(.TxtNroDoc.VALUE)
							             LnControl = Grabar_transaccion_Alm(GoCfgAlm.CodSed,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,m.NroDoc)
							             thisform.PgfDetalle.Page1.TxtNroItm.VALUE = C_CTRA.NroItm
							        ENDWITH     
					             ENDIF
					        ENDWITH

					CASE THISFORM.QUE_transaccion = 'VENTAS'

						THISFORM.OBJREFTRAN.XsNroDoc	= m.NroDoc
						IF Thisform.xreturn = 'E' && Eliminar transaccion
							LnControl	= thisform.Objreftran.AnulaR_Transaccion(thisform.Que_transaccion)
							IF LnControl<0
								thisform.MensajeErr(LnControl)
							ENDIF

						ELSE
							LnControl = thisform.objreftran.Ejecuta_transaccion(thisform.Que_transaccion,;
																					Thisform.xreturn )
							IF LnControl<0
								thisform.MensajeErr(LnControl)
							ENDIF
						ENDIF


				ENDCASE

		ENDCASE

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
		IF LlHayRegistros   && Cuando los items del detalle se carga de un documento previo

			thisform.objreftran.gitotitm = RECCOUNT(thisform.cCursor_d)
			DIMENSION THIS.objRefTran.aDetalle[thisform.objreftran.gitotitm]

		   SELECT(thisform.cCursor_d)
		   IF  EOF() 
		   	  GO BOTT 
		   ENDIF
		   IF  BOF() 
		   	  GO TOP
		   ENDIF
		   _RegAct = RECNO()   
		   LOCATE
		   SCAN 
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
		   IF _RegAct>0
			   GO _RegAct
		   ENDIF 
		   
		ELSE
		*
			IF thisform.ObjRefTran.GiTotItm>0
				FOR j = 1 TO thisform.ObjRefTran.GiTotItm
					Thisform.ObjReftran.Adetalle(j).ImpLin	=	ROUND(Thisform.ObjReftran.Adetalle(j).Preuni * Thisform.ObjReftran.Adetalle(j).CanFac,4)
					thisform.ObjReftran.XfImpBto = thisform.ObjRefTran.XfImpBto + Thisform.ObjReftran.Adetalle(j).ImpLin
				   
				ENDFOR
			ENDIF
		ENDIF


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
					IF INLIST(GsSigCia,'AROMAS','QUIMICA','RQU')
						DO CASE 
							CASE .XcDestino='N'
								.XfImpBto = _ImpBrt
								.XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2) 
								.XfImpVta = .XfImpBto - .XfImpDto  + .XfImpInt  + .XfImpFlt
								.XfImpIgv = ROUND(.XfImpVta*.XfPorIgv/100,2)
								.XfImpTot = .XfImpVta + .XfImpIgv
							CASE .XcDestino='E'
								.XfImpVta   = _ImpBrt
								.XfImpIgv	= 0 
								.XfImpBto	= .XfImpVta + .XfImpInt  + .XfImpFlt + .XfImpSeg + .XfImpAdm
								.XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2) 
								.XfImpTot = .XfImpBto + .XfImpIgv - .XfImpDto
						ENDCASE
					ELSE
					   .XfImpBto = _ImpBrt
			  		   .XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2)   		   
					   thisform.ObjReftran.XfImpVta = ROUND((thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto)/(1+thisform.ObjReftran.XfporIgv/100),2)
					   thisform.ObjReftran.XfImpIgv = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto - thisform.ObjReftran.XfImpVta
					   thisform.ObjReftran.XfImpTot = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto
					   thisform.ObjReftran.XfImpBto = thisform.ObjReftran.XfImpVta
				   ENDIF


				   
				CASE thisform.ObjReftran.XsCODDOC = [PEDI]
				   .XfImpBto = _ImpBrt
		  		   .XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2)   		   
				   thisform.ObjReftran.XfImpVta = ROUND((thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto)/(1+thisform.ObjReftran.XfporIgv/100),2)
				   thisform.ObjReftran.XfImpIgv = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto - thisform.ObjReftran.XfImpVta
				   thisform.ObjReftran.XfImpTot = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto
				   thisform.ObjReftran.XfImpBto = thisform.ObjReftran.XfImpVta
				   
				CASE thisform.ObjReftran.XsCODDOC = [PROF]
				   .XfImpBto = _ImpBrt
		  		   .XfImpDto = ROUND(.XfImpBto*.XfPorDto/100,2)   		   
				   thisform.ObjReftran.XfImpVta = ROUND((thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto)/(1+thisform.ObjReftran.XfporIgv/100),2)
				   thisform.ObjReftran.XfImpIgv = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto - thisform.ObjReftran.XfImpVta
				   thisform.ObjReftran.XfImpTot = thisform.ObjReftran.XfImpBto - thisform.ObjReftran.XfImpDto
				   thisform.ObjReftran.XfImpBto = thisform.ObjReftran.XfImpVta

			ENDCASE
		ENDWITH


		WITH THISFORM.pgfDetalle.PAGE1
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
			.cmdAdicionar1.ENABLED	= (thisform.xReturn<> 'E' AND (thisform.objreftran.XsCodRef = 'FREE' or thisform.objreftran.XsCodDoc = 'PEDI' OR thisform.objreftran.XsCodDoc = 'PROF'))
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_D)
			.cmdModificar1.ENABLED	= LlHayRegistros and thisform.xReturn<> 'E'
			.cmdEliminar1.ENABLED	= LlHayRegistros and ((thisform.xReturn<> 'E' and thisform.objreftran.XsCodRef = 'FREE')  or thisform.objreftran.XsCodDoc = 'PEDI' OR thisform.objreftran.XsCodDoc = 'PROF')
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

		with thisform.pgfdetalle.page1
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
				.TxtFchDoc.SetFocus
			ENDWITH
			WITH thisform.PgfDetalle.pages(1)
				.cmdAdicionar1.ENABLED	= (thisform.xReturn<> 'E' AND (thisform.objreftran.XsCodRef = 'FREE' or thisform.objreftran.XsCodDoc = 'PEDI' OR thisform.objreftran.XsCodDoc = 'PROF'))
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
	ENDPROC


	*-- Ocurre cuando se quiere eliminar un regsitro a la cabecera
	PROCEDURE eli_cabecera
		thisform.Objcntpage.Habilita
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

		THIS.ObjRefTran.XsTpoDoc	=	thisform.TpoDoc  
		this.ObjReftran.cCursor_C	=	thisform.ccursor_C 
		this.ObjReftran.cCursor_D	=	thisform.ccursor_D 
		this.ObjReftran.caliascab 	=	thisform.caliascab 
		this.ObjReftran.caliasdet 	=	thisform.caliasdet

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

				DO CASE
					CASE INLIST(THISFORM.ObjCntCab.CboCodDoc.Value,'F','B','N')
						THISFORM.ObjRefTran.XsTpoRef = IIF(INLIST(THISFORM.ObjCntCab.CboCodDoc.Value,'F','B'),THISFORM.ObjCntCab.CboTipoFact.Value,'')
						THISFORM.ObjRefTran.XsCodDoc =	THISFORM.ObjCntCab.CboCodDoc.Value
						THISFORM.ObjRefTran.XsPtoVta =	THISFORM.ObjCntCab.CboPtoVta.Value
						THISFORM.ObjRefTran.XsCodVen =	THISFORM.ObjCntCab.CboCodVen.Value
						THISFORM.ObjRefTran.XnTpoFac =	THISFORM.ObjCntCab.CboTipoFact.ListIndex
						THISFORM.ObjRefTran.XsCodCli =  THISFORM.ObjCntPage.CntCodCli.Value
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
					CASE INLIST(THISFORM.ObjCntCab.CboCodDoc.Value,'PROF')

						THISFORM.ObjRefTran.XsCodDoc =	THISFORM.ObjCntCab.CboCodDoc.Value
						THISFORM.ObjRefTran.XsPtoVta =	THISFORM.ObjCntCab.CboPtoVta.Value
						THISFORM.ObjRefTran.XsCodVen =	THISFORM.ObjCntCab.CboCodVen.Value
						THISFORM.ObjRefTran.XnTpoFac =	THISFORM.ObjCntCab.CboTipoFact.ListIndex
						THISFORM.ObjRefTran.XsCodCli =  THISFORM.ObjCntPage.CntCodCli.Value
						THISFORM.cValor_ID	=	THISFORM.ObjRefTran.CodSed + ; 
												THISFORM.ObjRefTran.XsCodDoc +;
												THISFORM.ObjRefTran.XsPtoVta

						THISFORM.cValor_PK = THISFORM.TraerValor_PK()
						thisform.ObjRefTran.CfgVar_PK(thisform.ctabla_c)

						WITH thisform.pgfDetalle.page1.cmdHelpNrodoc
							.caliascursor='c_NroDoc'
							.cnombreentidad = 'VTAVPROF'
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
					CASE INLIST(THISFORM.ObjCntCab.CboCodDoc.Value,'P')

						THISFORM.ObjRefTran.XsCodDoc =	THISFORM.ObjCntCab.CboCodDoc.Value
						THISFORM.ObjRefTran.XsPtoVta =	THISFORM.ObjCntCab.CboPtoVta.Value
						THISFORM.ObjRefTran.XsCodVen =	THISFORM.ObjCntCab.CboCodVen.Value
						THISFORM.ObjRefTran.XnTpoFac =	THISFORM.ObjCntCab.CboTipoFact.ListIndex
						THISFORM.ObjRefTran.XsCodCli =  THISFORM.ObjCntPage.CntCodCli.Value
						THISFORM.cValor_ID	=	THISFORM.ObjRefTran.CodSed + ; 
												THISFORM.ObjRefTran.XsCodDoc +;
												THISFORM.ObjRefTran.XsPtoVta

						THISFORM.cValor_PK = THISFORM.TraerValor_PK()
						thisform.ObjRefTran.CfgVar_PK(thisform.ctabla_c)

						WITH thisform.pgfDetalle.page1.cmdHelpNrodoc
							.caliascursor='c_NroDoc'
							.cnombreentidad = 'VTAVPEDI'
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
				ENDCASE
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

				DO CASE 
					CASE INLIST(THIS.ObjRefTran.XsCodDoc,'F','B','N')
						LsValor_PK	= 	THIS.ObjRefTran.XsTpoDoc + ;
										THIS.ObjRefTran.XsCodDoc + ;
										THIS.ObjRefTran.XsNroDoc  
					CASE INLIST(THIS.ObjRefTran.XsCodDoc,'PROF') 	&& Proformas
						LsValor_PK	= 	THIS.ObjRefTran.XsNroDoc  
					CASE INLIST(THIS.ObjRefTran.XsCodDoc,'P') 	&& Pedidos
						LsValor_PK	= 	THIS.ObjRefTran.XsNroDoc  


				ENDCASE
			CASE this.que_transaccion ='CONTAB'
			CASE this.que_transaccion ='PLANILLA'
			CASE this.que_transaccion ='COMPRAS'
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


	*-- Establecer el Control Source de los campos a editar en el detalle  (ccursor_d)
	PROCEDURE vincular_detalle
		IF USED(thisform.cCursor_D)
			LlBufferOk=CURSORSETPROP("Buffering",5,this.cCursor_D )
		ENDIF
		IF thisform.xreturn = 'I' && Si estamos creando por defecto agregamos registro en blanco
		*!*		APPEND BLANK IN (THISFORM.cCursor_D)
		*!*		thisform.confirma_trn_detalle(THISFORM.cCursor_D) 
		ENDIF
		*** Agregamos campos 
		WITH thisform.pgfDetalle.page3
			DO CASE 
				CASE	thisform.que_transaccion ='ALMACEN'

		*!*				.TxtCodmat.ControlSource	= THISFORM.cCursor_D+'.CodMat'
		*!*				.TxtDesMat.ControlSource	= THISFORM.cCursor_D+'.DesMat'
		*!*				.TxtUndStk.ControlSource	= THISFORM.cCursor_D+'.UndStk' 
		*!*				.TxtCanDes.ControlSource	= THISFORM.cCursor_D+'.CanDes'
		*!*				.TxtPreUni.ControlSource	= THISFORM.cCursor_D+'.PreUni'
		*!*				.TxtImpCto.ControlSource	= THISFORM.cCursor_D+'.ImpCto'
		*!*				.TxtLote.ControlSource		= THISFORM.cCursor_D+'.Lote'
		*!*				.TxtFchVto.ControlSource	= THISFORM.cCursor_D+'.FchVto'

				CASE	thisform.que_transaccion ='VENTAS'
		*!*				.TxtCodmat.ControlSource	= THISFORM.cCursor_D+'.CodMat'
		*!*				.TxtDesMat.ControlSource	= THISFORM.cCursor_D+'.DesMat'
		*!*				.TxtUndStk.ControlSource	= THISFORM.cCursor_D+'.UndVta' 
		*!*				.TxtCanDes.ControlSource	= THISFORM.cCursor_D+'.CanFac'
		*!*				.TxtPreUni.ControlSource	= THISFORM.cCursor_D+'.PreUni'
		*!*				.TxtImpCto.ControlSource	= THISFORM.cCursor_D+'.ImpLin'
		*!*				.TxtLote.ControlSource		= THISFORM.cCursor_D+'.Lote'
		*!*				.TxtFchVto.ControlSource	= THISFORM.cCursor_D+'.FchVto'

			ENDCASE
		ENDWITH
	ENDPROC


	*-- Cancelar transaccion en el detalle
	PROCEDURE cancelar_trn_detalle
		PARAMETERS LsAlias
		IF !USED(LsAlias)
			RETURN .f.
		ENDIF
		LOCAL LlOk
		LlOk=TABLEREVERT(.T.,LsAlias)
		RETURN LlOk
	ENDPROC


	PROCEDURE confirma_trn_detalle
		PARAMETERS LsAlias
		IF !USED(LsAlias)
			RETURN .f.
		ENDIF
		LOCAL LlOk
		LlOk=TABLEUPDATE(0,.F.,LsAlias)
		RETURN LlOk
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

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'PROF')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'N/BC')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'CANJ')

			CASE INLIST(THISFORM.ObjRefTran.XsCodDoc,'LETR')
		ENDCASE
	ENDPROC


	PROCEDURE Init
		LPARAMETERS toconexion
		dodefault()
		*thisform.pgfDetalle.Tabs = .F.
		thisform.pgfDetalle.Page2.Enabled = .f. 
		thisform.pgfDetalle.Page3.Enabled = .f. 
		THISFORM.INICIAR_VAR()
		thisform.AddProperty('Width_Col1',thisform.pgfDetalle.page1.grdDetalle.column1.width) 
		thisform.AddProperty('Width_Col2',thisform.pgfDetalle.page1.grdDetalle.column2.width) 
		thisform.AddProperty('Width_Col3',thisform.pgfDetalle.page1.grdDetalle.column3.width) 
		thisform.AddProperty('Width_Col4',thisform.pgfDetalle.page1.grdDetalle.column4.width) 
		thisform.AddProperty('Width_Col5',thisform.pgfDetalle.page1.grdDetalle.column5.width) 
		thisform.AddProperty('Width_Col6',thisform.pgfDetalle.page1.grdDetalle.column6.width) 
		thisform.AddProperty('Width_Col7',thisform.pgfDetalle.page1.grdDetalle.column7.width) 
		thisform.AddProperty('Width_Col8',thisform.pgfDetalle.page1.grdDetalle.column8.width) 
		thisform.AddProperty('Width_Col9',thisform.pgfDetalle.page1.grdDetalle.column9.width) 
		thisform.AddProperty('Width_Col10',thisform.pgfDetalle.page1.grdDetalle.column10.width) 
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


	PROCEDURE validitem
			LOCAL LcCodMat,LcSubAlm,LfCandes,LdFecha ,LcCursor,LcTipMov,LlStkNeg,LcLote, LnError

				LcCodMat	=	THISform.PGfDetalle.PAge3.TXtCodmat.Value
				LcSubAlm	=	IIF(!EMPTY(thisform.PgfDetalle.Page3.CmdHelpCodMat.cValoresfiltro),thisform.objreftran.SubAlm,'')
				LdFecha		=	THISform.PGfDetalle.PAge1.txtFchDoc.Value
				LfCandes	=	THISform.PGfDetalle.PAge3.TxtCandes.Value
				LcLote		=	IIF(!INLIST(thisform.objreftran.XsCodDoc,'PEDI','PROF'),THISform.PGfDetalle.PAGE3.TxtLote.Value,'')
				LcTipMov	=	thisform.objreftran.cTipMov
				LlStkNeg	=	thisform.objreftran.lStkNeg
				LcCursor	=	IIF(EMPTY(this.c_validitem),'C_CodMat',this.c_validitem)

				IF thisform.objreftran.Transf AND LcTipMov='S' 
					IF !SEEK(thisform.objreftran.AlmTrf+LcCodMat,'CALM','CATA01')
						RETURN ITEM_NO_ESTA_ALM_DESTINO
					ENDIF
				ENDIF

				ov=CREATEOBJECT('Dosvr.validadatos')
				LnError=ov.validacodigoalmacen(LcCodMat,LcSubAlm,GsCodSed,LcTipMov,LlStkNeg,LcLote,LfCandes,LdFecha,LcCursor)

				RELEASE ov
				RETURN LnError
	ENDPROC


	PROCEDURE validcliente
		LOCAL LcCodCli ,LcCursor,LfImpTot, LnError

		LcCodCli	=	THISform.ObjCntPage.CntCodCli.Value
		LcCodRef	= 	thisform.objreftran.XsCodRef
		LfImpTot	=	THISform.PGfDetalle.PAge1.TxtImpTot.Value
		LcCursor	=	THISform.ObjCntPage.c_ValidCliente

		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validacliente(LcCodCli,LcCodRef,LfIMptot,LcCursor)

		RELEASE ov
		RETURN LnError
	ENDPROC


	PROCEDURE validnroref
		LOCAL LcCodRef,LcNroRef,LcCodCli,LcCursor,LnError

		LcCodRef	=	thisform.objreftran.XsCodRef
		LcNroRef	=	THISform.ObjCntPage.txtNroRef.Value
		LcCodCli	=	THISform.ObjCntPage.CntCodCli.Value
		LcCursor	=	THISform.ObjCntPage.c_ValidNroRef

		ov=CREATEOBJECT('Dosvr.validadatos')
		LnError=ov.validNroRef(LcCodRef,LcNroRef,LcCodCli,LcCursor)

		RELEASE ov
		RETURN LnError
	ENDPROC


	PROCEDURE Unload
		FOR TnTbl=1 TO AUSED(aTables)
			IF !INLIST(aTables(TnTbl,1),'ACCESS','DBFS')
				IF !EMPTY(aTables(TnTbl,1))
					USE IN aTables(TnTbl,1)
				ENDIF
			ENDIF
		ENDFOR
		DODEFAULT()
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


	PROCEDURE cmdiniciar.Click
		IF !THIS.Activado()
			RETURN
		ENDIF
		THISFORM.INICIAR_VAR()
	ENDPROC


	PROCEDURE txtfchdoc.Valid
		thisform.objcntpage.txttpoCmb.Value =GoCfgAlm._TipoCambio(this.value,thisform.xReturn,thisform.objcntpage.txttpoCmb.Value )

		thisform.ObjReftran.XdFchDoc = this.Value

		IF Thisform.ObjCntPage.TxtTpoCmb.Value<=0
			=MEssagebox('No hay tipo de cambio definido para esta fecha,actualizar tabla de tipos de cambio',0+16,'Atención')
			Thisform.ObjCntPage.Enabled = .F.
		ELSE
			Thisform.ObjCntPage.Enabled = .T.
		ENDIF
	ENDPROC


	PROCEDURE txtnrodoc.Valid
		IF !EMPTY(THIS.VALUE)
			thisform.LockScreen = .T.
			thisform.desvincular_controles()
			IF thisform.xReturn='A'
				thisform.mod_cabacera() 
			ENDIF
			IF thisform.xReturn='E'
				thisform.Eli_cabecera() 
			ENDIF

			IF !thisform.Vincular_Controles()
				thisform.LockScreen = .F.
				MESSAGEBOX('Nro. de documento invalido',16,'Verificar')
				RETURN .f.
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
			thisform.LockScreen = .F.

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


	PROCEDURE cmdadicionar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		WITH THIS.PARENT.PARENT.PAGES(1)
			.TxtFchDoc.ENABLED = .F.
			.TxtObserv.ENABLED = .F.
		ENDWITH
		EXTERNAL ARRAY GaLencod
		thisform.objCntCab.Deshabilita
		thisform.objCntPage.Deshabilita
		thisform.LcTipOpe = 'I'  				&& Agregar item en el detalle

		*thisform.BindControls = .F.

		SELECT (thisform.ccursor_d)
		*!*	LOCATE FOR EMPTY(CodMat)
		*!*	IF EOF() 
			APPEND BLANK
			thisform.confirma_trn_detalle(thisform.ccursor_d) 
			replace TpoDoc WITH thisform.objreftran.XsCodRef
			replace CodDoc WITH thisform.objreftran.XsCodDoc
			replace NroDoc WITH thisform.objreftran.XsNroDoc
		*!*	ENDIF
		thisform.objreftran.NumEle = RECNO()  && Sera ??

		IF INLIST(thisform.objreftran.XsCodRef , 'FREE' ,'PEDI','PROF')
			thisform.objreftran.GiTotItm = thisform.objreftran.GiTotItm + 1
			DIMENSION thisform.objreftran.aDetalle[thisform.objreftran.GiTotItm]
			thisform.objreftran.aDetalle[thisform.objreftran.GiTotItm] = CREATEOBJECT('dosvr.lineadetalle')
		ENDIF
		*thisform.BindControls = .T.
		IF thisform.modo_edit_detalle = 1
			WITH THISFORM.PgfDetalle.page1 
				.GrdDetalle.ReadOnly = .F. 
				.GrdDetalle.AllowCellSelection = .T.
				.CmdAdicionar1.Visible = .F.
				.CmdModificar1.Visible = .F.
				.CmdEliminar1.Visible = .F.
				.CmdCancelar1.Visible = .T.
				.CmdAceptar1.Visible = .T.
			ENDWITH 
		ELSE
			THISFORM.PgfDetalle.page1.ENABLED	= .F.
			THISFORM.PgfDetalle.ACTIVEPAGE	= 3
			WITH THISFORM.PgfDetalle.PAGES(3)

				** Inicializamos Variables
			*!*	*!*		.TxtCodMat.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.Codmat')))
			*!*	*!*		.TxtDesMat.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.DesMat')))
			*!*	*!*		DO CASE 
			*!*	*!*			CASE thisform.que_transaccion ='ALMACEN'
			*!*	*!*				.TxtUndStk.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.UndStk')))
			*!*	*!*			CASE thisform.que_transaccion ='VENTAS'
			*!*	*!*				.TxtUndStk.VALUE = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.UndVta')))
			*!*	*!*		ENDCASE

			*!*	*!*		.TxtLote.VALUE	 = SPACE(LEN(EVALUATE(thisform.cCursor_D+'.Lote')))
			*!*	*!*		.TxtFchVto.VALUE= CTOD('  \  \    ')
			*!*	*!*		.TxtCanDes.VALUE = 0.00
			*!*	*!*		.TxtPreUni.VALUE = 0.00
			*!*	*!*		.TxtImpCto.VALUE = 0.00
				** Habilitamos las variables
				.TxtCodMat.ENABLED = .T.
				.TxtCanDes.ENABLED = .T.
				.TxtPreUni.ENABLED = .T.
				.TxtImpCto.ENABLED = .T.
				.TxtLote.ENABLED	= .t.
				.TxtFchVto.ENABLED	= .t.
				.cmdAceptar2.ENABLED			= .F.
				.cmdCancelar2.ENABLED			= .T.
				.TxtCodmat.MaxLength = GaLenCod[3] 
				.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod[3]-GnLenDiv)
				.CmdHelpCodMat.ENABLED = .T.
				.CmdHelpLote.ENABLED = .T.
				.REFRESH
				.TxtCodMat.SETFOCUS()
			ENDWITH
		ENDIF

		WITH THISFORM.PgfDetalle.PAGES(4)
			** Inicializamos Variables

			.cmdAceptar3.ENABLED			= .T.
			.cmdCancelar3.ENABLED			= .T.
		ENDWITH

		*thisform.vincular_detalle() 
	ENDPROC


	PROCEDURE cmdmodificar1.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		WITH THISFORM.PgfDetalle.page1 
			.TxtFchDoc.ENABLED = .F.
			.TxtObserv.ENABLED = .F.
		ENDWITH
		IF thisform.modo_edit_detalle = 1
			WITH THISFORM.PgfDetalle.page1 
				.GrdDetalle.ReadOnly = .F. 
				.GrdDetalle.AllowCellSelection = .T.
				.CmdAdicionar1.Visible = .F.
				.CmdModificar1.Visible = .F.
				.CmdEliminar1.Visible = .F.
				.CmdCancelar1.Visible = .T.
				.CmdAceptar1.Visible = .T.
			ENDWITH 
		else
			THISFORM.PgfDetalle.Page1.Enabled = .F.
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
		ENDIF

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
			THISFORM.Grabar_datos(2,thisform.LcTipOpe)
			IF INLIST(thisform.objreftran.XsCodRef , 'FREE' ,'PEDI','PROF')
				thisform.objreftran.GiTotItm = thisform.objreftran.GiTotItm - 1
			ENDIF
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.ccursor_d)
			* 
		    * CALCULO TOTALES DEL DOCUMENTO
		    *
		    IF (THISFORM.ObjRefTran.lpidpco OR THISFORM.ObjRefTran.lCtoVta)
		       THISFORM.Calcular_Totales
		    ENDIF
		    *
		    WITH THISFORM.PgfDetalle.Page1
				.GrdDetalle.REFRESH()
				.CmdModificar1.ENABLED = LlHayRegistros
				.CmdEliminar1.ENABLED  = LlHayRegistros
			ENDWITH
			THISFORM.CmdIMprimir.ENABLED = LlHayRegistros
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


	PROCEDURE cmdaceptar1.Click
		*!*	*!*	M.ERR=THISFORM.VALIDitem() 
		*!*	*!*	IF m.err<0
		*!*	*!*		thisform.MensajeErr(m.err)
		*!*	*!*		this.Parent.txtCanDes.SetFocus()
		*!*	*!*
		*!*	*!*		RETURN 
		*!*	*!*	ENDIF
		*!*	*!*	*
		*!*	*!*	* CALCULO TOTALES DEL DOCUMENTO
		*!*	*!*	*
		*!*	*!*	IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		*!*	*!*	   THISFORM.Calcular_Totales
		*!*	*!*	ENDIF
		*!*	*!*	m.err = thisform.validcliente() 
		*!*	*!*	IF m.err<0
		*!*	*!*		thisform.MensajeErr(m.err)
		*!*	*!*		this.Parent.txtCanDes.SetFocus()
		*!*	*!*		RETURN 
		*!*	*!*	ENDIF


		*!*	*!*	IF THISFORM.lNuevo AND !THISFORM.lGrabado
		*!*	*!*		lnOk = MESSAGEBOX("Para proseguir con esta opción deberá grabar el Documento " + CHR(13) + ;
		*!*	*!*			"¿ Desea grabar en este momento y proseguir ?" , 4+32+256 , "¿ Grabar Datos ?" )
		*!*	*!*		IF lnOk <> 6
		*!*	*!*			RETURN
		*!*	*!*		ENDIF

		*!*	*!*		WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
		*!*	*!*		THISFORM.lGrabado	= THISFORM.Grabar_Datos(1,'I')
		*!*	*!*		WAIT CLEAR

		*!*	*!*		IF !THISFORM.lGrabado
		*!*	*!*			=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
		*!*	*!*			RETURN
		*!*	*!*		ENDIF

		*!*	*!*		THISFORM.lNuevo	= .F.
		*!*	*!*		WAIT CLEAR
		*!*	*!*	ELSE
		*!*	*!*		WAIT WINDOW "Actualizando Datos .... espere" NOWAIT
		*!*	*!*		IF !THISFORM.Grabar_Datos(2,THISFORM.LcTipOpe)
		*!*	*!*			=MESSAGEBOX("¡ No se grabaron correctamente los datos !",64,"Error en Grabación")
		*!*	*!*			RETURN
		*!*	*!*		ENDIF
		*!*	*!*		WAIT CLEAR
		*!*	*!*	ENDIF
		**
		*!*	IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		*!*	   THISFORM.Calcular_Totales
		*!*	ENDIF
		thisform.confirma_trn_detalle(thisform.ccursor_d) 
		thisform.cmdGrabar.Enabled  = .t.
		*
		THIS.PARENT.Cmdterminar.Click 
	ENDPROC


	PROCEDURE cmdcancelar1.Click
		thisform.Cancelar_trn_detalle(thisform.ccursor_d)  
		THIS.PARENT.Cmdterminar.Click

		*!*	WITH THIS.PARENT.PARENT.PAGES(3)
		*!*
		*!*		*** Deshabilitar Controles
		*!*		.CmdHelpCodMat.ENABLED = .F.
		*!*		.TxtCodMat.ENABLED = .F.
		*!*		.TxtCanDes.ENABLED = .F.
		*!*		.TxtPreUni.ENABLED = .F.
		*!*		.TxtImpCto.ENABLED = .F.
		*!*		.txtLote.ENABLED	= .f.
		*!*		.txtFchVto.ENABLED	= .f.
		*!*		.cmdAceptar2.ENABLED	= .F.
		*!*		.cmdCancelar2.ENABLED	= .F.
		*!*		.CmdHelpLote.ENABLED	= .F.
		*!*		** Inicializarlos ** 

		*!*	ENDWITH

		*!*	THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		*!*	THIS.ENABLED	= .F.
		*!*	WITH THIS.PARENT.PARENT
		*!*		.PAGES(1).ENABLED	= .T.
		*!*		.ACTIVEPAGE	= 1
		*!*		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_d)
		*!*		.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
		*!*		.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
		*!*		with thisform
		*!*			.cmdImprimir.ENABLED	= LlHayRegistros
		*!*		endwith 
		*!*		.PAGES(1).grdDetalle.REFRESH()
		*!*		.PAGES(1).grdDetalle.SETFOCUS()
		*!*	ENDWITH
		*!*	IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		*!*	   THISFORM.Calcular_Totales
		*!*	ENDIF
	ENDPROC


	PROCEDURE cmdterminar.Click
		thisform.LockScreen = .T. 
		THIS.PARENT.cmdAceptar1.Visible	= .F.
		THIS.PARENT.cmdCancelar1.Visible = .F.

		WITH THIS.PARENT.PARENT
		*!*	*!*		.PAGES(1).ENABLED	= .T.
		*!*	*!*		.ACTIVEPAGE	= 1
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_d)
			.PAGES(1).cmdAdicionar1.Visible	= .t.
			.PAGES(1).cmdModificar1.Visible	= .t.
			.PAGES(1).cmdEliminar1.Visible	= .t.

			.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
			with thisform
				.cmdImprimir.ENABLED	= LlHayRegistros
			endwith 
			.PAGES(1).GrdDetalle.ReadOnly = .T. 
			.PAGES(1).GrdDetalle.AllowCellSelection = .F.
			.PAGES(1).grdDetalle.REFRESH()
			.PAGES(1).grdDetalle.SETFOCUS()
		ENDWITH
		IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
		*thisform.objCntCab.habilita
		WITH THIS.PARENT.PARENT.PAGES(1)
			.TxtFchDoc.ENABLED = .F.
			.TxtObserv.ENABLED = .F.
		ENDWITH
		thisform.objCntPage.habilita
		thisform.objCntPage.CboDestino.InteractiveChange()
		thisform.LockScreen = .F.  
	ENDPROC


	PROCEDURE grddetalle.AfterRowColChange
		LPARAMETERS ncolindex
		DODEFAULT()
		LcCursor = this.RecordSource 
		SELECT (LcCursor)
		SCATTER NAME thisform.oitem  
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

		WITH THISFORM.PgfDetalle.PAGES(1)
			.TxtNro_Itm.Value = EVALUATE(THISFORM.cCursor_D+'.Nro_Itm')
		ENDWITH
	ENDPROC


	PROCEDURE txtcodmat.DblClick
		KEYBOARD '{F8}' 
	ENDPROC


	PROCEDURE txtcodmat.Valid
		thisform.pgfDetalle.page3.txtCodmat.Value = THIS.Value
		LLOkItem = thisform.pgfDetalle.page3.txtCodmat.Valid() 
		RETURN LlOkitem
	ENDPROC


	PROCEDURE txtcodmat.KeyPress
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
			CASE INLIST(TnKeyCode , Enter )
		*!*	   		WAIT WINDOW 'Presiono Enter'
				UltTecla = TnKeyCode

				IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMat.Value)
		*			LsVCodMat=EVALUATE(this.Parent.Parent.RecordSource+'.CodMat')
					LsVCodMat=thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMat.Value
					LsOldVal=OLDVAL('CODMAT',this.Parent.Parent.RecordSource)
					LsVDesMat=EVALUATE(this.Parent.Parent.RecordSource+'.Desmat') 
					=SEEK(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMat.Value,"CATG")
					Thisform.pgfDetalle.page1.grdDetalle.column2.txtDesMat.Value = ;
					IIF(EMPTY(LsVDesMat) OR (LsOldVal<>LsVCodMat),CATG.DesMat,LsVDesMat)
					Thisform.pgfDetalle.page1.grdDetalle.column3.txtUndvTA.Value = CATG.UndStk
					KEYBOARD '{TAB}{TAB}{TAB}'

		*!*			ELSE
		*!*				KEYBOARD '{ENTER}'
				ELSE
					thisform.pgfDetalle.page3.CmdHelpCodMat.Click()
					KEYBOARD '{TAB}{TAB}{TAB}'
				ENDIF
			CASE TnKeyCode  = F8
		*   		WAIT WINDOW 'Presiono F8'
				UltTecla = TnKeyCode
				thisform.pgfDetalle.page3.CmdHelpCodMat.Click()
				KEYBOARD '{TAB}{TAB}{TAB}'
		   OTHERWISE
		      * Some other key, just do the default actions
		      This.SelLength = LENC(This.cSearchString)
		      RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtdesmat.When
		*RETURN .f.
	ENDPROC


	PROCEDURE txtundvta.When
		RETURN thisform.objreftran.lUndVta OR thisform.objreftran.lUndCmp
	ENDPROC


	PROCEDURE txtundvta.DblClick
		KEYBOARD '{F8}'
	ENDPROC


	PROCEDURE txtundvta.KeyPress
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
				thisform.pgfDetalle.Page1.CmdHelpUndVta.Click
					IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndVta.Value)
						LsUndVta=thisform.pgfDetalle.page1.grdDetalle.column3.TxtUndVta.Value
						*** se supone que aqui ya tengo el 
		***				thisform.c_validitem  
						LsCmpCodMat=this.Parent.Parent.RecordSource+'.CodMat'
						=SEEK(PADR(&LsCmpCodMat.,LEN(Catg.CodMat)),'CATG','CATG01')
						IF CATG.UndStk=LsUndVta
							REPLACE FacEqu WITH 1 IN this.Parent.Parent.RecordSource
						ELSE
							IF SEEK(CATG.UndStk+LsUndVta,'UVTA','EQUN01')
								REPLACE FacEqu WITH EQUN.FacEqu IN this.Parent.Parent.RecordSource
							ELSE
								REPLACE FacEqu WITH 1 IN this.Parent.Parent.RecordSource
							ENDIF
						ENDIF
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


	PROCEDURE txtundvta.Valid
		LsUndVta=THIS.Value

		IF LASTKEY()=F8
			RETURN .F.
		ELSE

			LsCmpCodMat=this.Parent.Parent.RecordSource+'.CodMat'
			=SEEK(PADR(&LsCmpCodMat.,LEN(CATG.CodMat)),'CATG','CATG01')
			IF !SEEK('UD'+PADR(THIS.Value,LEN(TABL.Codigo)),'TABL','TABL01')
				=MESSAGEBOX('Unidad de venta invalida',48,'Atencion !')
				RETURN .f.
			ENDIF
			LsOldUndVta=OLDVAL('UndVta',thisform.cCursor_d)
			LnOldFacEqu=OLDVAL('FacEqu',thisform.cCursor_d)

			IF THIS.Value <> LsOldUndVta OR THIS.Parent.Parent.cOLUMN5.TxtFacEqu.Value<=0 
				IF CATG.UndStk=LsUndVta
			*		REPLACE FacEqu WITH 1 IN this.Parent.Parent.RecordSource
					THIS.Parent.Parent.cOLUMN5.TxtFacEqu.Value = 1
				ELSE
					IF SEEK(CATG.UndStk+LsUndVta,'UVTA','EQUN01')
			*			REPLACE FacEqu WITH EQUN.FacEqu IN this.Parent.Parent.RecordSource
						THIS.Parent.Parent.cOLUMN5.TxtFacEqu.Value = EQUN.FacEqu
					ELSE
			*			REPLACE FacEqu WITH 1 IN this.Parent.Parent.RecordSource  && No puede ser cero
						THIS.Parent.Parent.cOLUMN5.TxtFacEqu.Value = 1
					ENDIF
				ENDIF
			ENDIF
			RETURN .t.

		ENDIF
	ENDPROC


	PROCEDURE txtcantidad.Valid
		LOCAL LlOkItem as Boolean ,LfImpCto as Number 
		WITH THISFORM.PgfDetalle.PAGE3  
			.TxtFacEqu.Value = IIF(Thisform.LcTipOpe='I',this.Parent.Parent.COLUMN5.TxtFacEqu.Value,EVALUATE(this.Parent.Parent.COLUMN5.TxtFacEqu.Controlsource))
			.TxtCandes.Value = this.value
		    LlOkItem=  .TXtCanDes.Valid()
		    IF !LlOkItem
		    	RETURN LlOkItem
		    ENDIF
		    LfImpCto = .txtImpCto.value 
		ENDWITH
		IF LlOkItem
			WITH this.Parent.Parent
				.column8.txtImpLin.Value =  LfImpCto
			ENDWITH 
		ENDIF
	ENDPROC


	PROCEDURE txtfacequ.ProgrammaticChange
		*
		THIS.Parent.Parent.Parent.Parent.Page3.TxtFacEqu.Value = This.Value
	ENDPROC


	PROCEDURE txtfacequ.Valid
		LOCAL LlOkItem as Boolean ,LfPreUni as Number ,LfImpCto as Number ,LfFacEqu As Number ,LfCantidad As Number ,LfImpLin As Number 
		IF This.Value>0
			THIS.Parent.Parent.Parent.Parent.Page3.TxtFacEqu.Value = This.Value
			LfPreUni = 	IIF(Thisform.LcTipOpe='I',this.Parent.Parent.column7.TxtPreUni.Value,EVALUATE(this.Parent.Parent.column7.TxtPreUni.Controlsource))
			LfCantidad= IIF(Thisform.LcTipOpe='I',this.Parent.Parent.Column4.txtCantidad.Value,EVALUATE(this.Parent.Parent.Column4.txtCantidad.Controlsource))
			LfImpLin=ROUND(LfPreUni*LfCantidad*This.Value,2)  
			This.Parent.Parent.column8.TxtImpLin.Value = LfImpLin 
		ENDIF
	ENDPROC


	PROCEDURE txtfacequ.When
		LOCAL LsCursor,LsCmpUStk,LscmpUVta
		LsCursor=this.Parent.Parent.RecordSource
		LsCurVal=thisform.c_validitem 
		LsExpEval = LsCurVal+ '.UndStk<>'+LsCursor+'.UndVta'

		LsCmpCodMat=this.Parent.Parent.RecordSource+'.CodMat'
		=SEEK(PADR(&LsCmpCodMat.,LEN(CATG.CodMat)),'CATG','CATG01')
		IF !USED(LsCurVal)
			LsExpEval =  'CATG.UndStk<>'+LsCursor+'.UndVta'
		ENDIF
		IF EVAL(LsExpEval)
			RETURN .t.
		else
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE txtfacequ.KeyPress
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

			OTHERWISE
				* Some other key, just do the default actions
				This.SelLength = LENC(This.cSearchString)
				RETURN
		ENDCASE
	ENDPROC


	PROCEDURE txtfacequ.DblClick
		KEYBOARD '{F8}'
	ENDPROC


	PROCEDURE txttotal.LostFocus
		LlColPreUniOk=(this.Parent.Parent.column7.Width = 0) or (this.Parent.Parent.column7.ReadOnly)
		LlColImpLinOk=(this.Parent.Parent.column8.Width = 0) or (this.Parent.Parent.column8.ReadOnly)
		IF INLIST(this.Parent.Parent.column3.TxtUndVta.Value,'TR','ROL') AND (LlColPreUniOk AND LlColImpLinOk) AND THISFORM.LcTipOpe='I'
			this.Parent.Parent.Parent.Cmdaceptar1.Click 
			this.Parent.Parent.Parent.CmdDuplicaItem.Click 
		ENDIF
	ENDPROC


	PROCEDURE txttotal.Valid
	ENDPROC


	PROCEDURE txttotal.When
		LOCAL LsCursor,LsCmpUStk,LscmpUVta
		LsCursor=this.Parent.Parent.RecordSource
		LsCurVal=thisform.c_validitem 
		LsExpEval = LsCurVal+ '.UndStk<>'+LsCursor+'.UndVta'

		LsCmpCodMat=this.Parent.Parent.RecordSource+'.CodMat'
		=SEEK(PADR(&LsCmpCodMat.,LEN(CATG.CodMat)),'CATG','CATG01')
		IF !USED(LsCurVal)
			LsExpEval =  'CATG.UndStk<>'+LsCursor+'.UndVta'
		ENDIF
		IF EVAL(LsExpEval)
			RETURN .t.
		else
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE txtpreuni.KeyPress
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


	PROCEDURE txtpreuni.DblClick
		KEYBOARD '{F8}'
	ENDPROC


	PROCEDURE txtpreuni.Valid
		LOCAL LlOkItem as Boolean ,LfPreUni as Number ,LfImpCto as Number ,LfFacEqu As Number ,LfCantidad As Number 
		WITH THISFORM.PgfDetalle.PAGE3   

			LfFacEqu  = IIF(Thisform.LcTipOpe='I',this.Parent.Parent.COLUMN5.TxtFacEqu.Value,EVALUATE(this.Parent.Parent.COLUMN5.TxtFacEqu.Controlsource))
			LfCantidad= IIF(Thisform.LcTipOpe='I',this.Parent.Parent.Column4.txtCantidad.Value,EVALUATE(this.Parent.Parent.Column4.txtCantidad.Controlsource))
			.TxtFacEqu.Value = LfFacEqu
			.TxtCandes.Value = LfCantidad
			.TxtPreuni.Value = this.value
		    LlOkItem=  .TXtPreuni.Valid()
		    LfPreuni = .txtPreuni.value 
		    LfImpCto = .TxtImpCto.Value
		ENDWITH
		IF LlOkItem
			WITH this.Parent.Parent
				.Column7.TxtPreuni.Value =  LfPreuni
				.column8.txtImpLin.Value =  LfImpCto
			ENDWITH 
		ENDIF
	ENDPROC


	PROCEDURE txtimplin.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl


		DO CASE
			CASE nKeyCode=k_enter
				DO CASE 
					CASE INLIST(this.Parent.Parent.column3.TxtUndVta.Value,'TR','ROL')  AND THISFORM.LcTipOpe='I'
						this.Parent.Parent.Parent.Cmdaceptar1.Click 
						this.Parent.Parent.Parent.CmdDuplicaItem.Click 
					OTHERWISE 
						this.Parent.Parent.Parent.Cmdaceptar1.Click 
				ENDCASE
			CASE nKeyCode= K_F10
				this.Parent.Parent.Parent.Cmdaceptar1.Click 

		ENDCASE
	ENDPROC


	PROCEDURE txtimplin.Valid
		LOCAL LlOkItem as Boolean ,LfPreUni as Number ,LfImpCto as Number 
		WITH THISFORM.PgfDetalle.PAGE3  
			.TxtCandes.Value = this.Parent.Parent.COLUMN4.TxtCantidad.Value 
			.TxtPreuni.Value = this.Parent.Parent.COLUMN7.TxtPreUni.Value 
			.TxtImpCto.Value = this.Parent.Parent.COLUMN8.TxtImpLin.Value 
		    LlOkItem=  .TXtImpCto.Valid()
		    LfPreuni = .txtPreuni.value 
		    LfImpCto = .txtImpCto.value 
		ENDWITH
		IF LlOkItem
			WITH this.Parent.Parent
				.Column7.TxtPreuni.Value =  LfPreuni
				.column8.txtImpLin.Value =  LfImpCto
			ENDWITH 
		ENDIF
	ENDPROC


	PROCEDURE cmdhelp_preuni.Click
		DODEFAULT()
		WITH this.Parent.Parent.Parent
		ENDWITH

		XsPreUniGrd = this.cvalorvalida
		IF SEEK(TRIM(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodmat.Value),'CATG','CATG01') 
		DO CASE
			CASE XsPreUniGrd = "1"
				IF thisform.objcntpage.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVe1
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVn1
				ENDIF
			CASE XsPreUniGrd = "2"
				IF thisform.objcntpage.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVe2
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVn2
				ENDIF
			CASE XsPreUniGrd = "3"
				IF thisform.objcntpage.CboCodMon.Value = 2
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVe3
				ELSE
					thisform.pgfDetalle.page1.grdDetalle.column7.txtPreUni.Value = CATG.PreVn3
				ENDIF
		ENDCASE
		ENDIF
	ENDPROC


	PROCEDURE cmdhelpundvta.Click
		DODEFAULT()
		WITH this.Parent.GrdDetalle.Column3.TxtUndVta 
			.Value = this.cvalorvalida
		ENDWITH
		KEYBOARD '{TAB}' 
	ENDPROC


	PROCEDURE cmdduplicaitem.Click
		IF !THIS.ACTIVADO()
			RETURN
		ENDIF
		WITH THIS.PARENT.PARENT.PAGES(1)
			.TxtFchDoc.ENABLED = .F.
			.TxtObserv.ENABLED = .F.
		ENDWITH
		EXTERNAL ARRAY GaLencod
		thisform.objCntCab.Deshabilita
		thisform.objCntPage.Deshabilita
		thisform.LcTipOpe = 'I'  				&& Agregar item en el detalle


		SELECT (thisform.ccursor_d)
			APPEND BLANK
			thisform.confirma_trn_detalle(thisform.ccursor_d) 

			replace TpoDoc WITH thisform.objreftran.XsCodRef
			replace CodDoc WITH thisform.objreftran.XsCodDoc
			replace NroDoc WITH thisform.objreftran.XsNroDoc
			replace CodMat WITH Thisform.oitem.CodMat
			replace DesMat WITH Thisform.oitem.DesMat
			replace UndVta WITH Thisform.oitem.UndVta
			replace Candes WITH 0
			replace Facequ WITH 0
			replace PreUni WITH 0

		thisform.objreftran.NumEle = RECNO()  && Sera ??

		IF INLIST(thisform.objreftran.XsCodRef , 'FREE' ,'PEDI','PROF')
			thisform.objreftran.GiTotItm = thisform.objreftran.GiTotItm + 1
			DIMENSION thisform.objreftran.aDetalle[thisform.objreftran.GiTotItm]
			thisform.objreftran.aDetalle[thisform.objreftran.GiTotItm] = CREATEOBJECT('dosvr.lineadetalle')
		ENDIF

		IF thisform.modo_edit_detalle = 1
			WITH THISFORM.PgfDetalle.page1 
				.GrdDetalle.ReadOnly = .F. 
				.GrdDetalle.AllowCellSelection = .T.
				.CmdAdicionar1.Visible = .F.
				.CmdModificar1.Visible = .F.
				.CmdEliminar1.Visible = .F.
				.CmdCancelar1.Visible = .T.
				.CmdAceptar1.Visible = .T.
				WITH thisform.pgfDetalle.page1.grdDetalle  
					.refresh
					.Column4.txtCantidad.SetFocus 
				ENDWITH
			ENDWITH 


		ELSE
			THISFORM.PgfDetalle.page1.ENABLED	= .F.
			THISFORM.PgfDetalle.ACTIVEPAGE	= 3
			WITH THISFORM.PgfDetalle.PAGES(3)

				** Habilitamos las variables
				.TxtCodMat.ENABLED = .T.
				.TxtCanDes.ENABLED = .T.
				.TxtPreUni.ENABLED = .T.
				.TxtImpCto.ENABLED = .T.
				.TxtLote.ENABLED	= .t.
				.TxtFchVto.ENABLED	= .t.
				.cmdAceptar2.ENABLED			= .F.
				.cmdCancelar2.ENABLED			= .T.
				.TxtCodmat.MaxLength = GaLenCod[3] 
				.TxtCodMat.InputMask = REPLICATE('X',GnLenDiv)+'-'+REPLICATE('X',GaLencod[3]-GnLenDiv)
				.CmdHelpCodMat.ENABLED = .T.
				.CmdHelpLote.ENABLED = .T.
				.REFRESH
				.TxtCodMat.SETFOCUS()
			ENDWITH
		ENDIF

		WITH THISFORM.PgfDetalle.PAGES(4)
			** Inicializamos Variables

			.cmdAceptar3.ENABLED			= .T.
			.cmdCancelar3.ENABLED			= .T.
		ENDWITH


	ENDPROC


	PROCEDURE cmdaceptar2.Click
		M.ERR=THISFORM.VALIDitem() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			this.Parent.txtCanDes.SetFocus()

			RETURN 
		ENDIF
		*
		* CALCULO TOTALES DEL DOCUMENTO
		*
		IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
		m.err = thisform.validcliente() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			this.Parent.txtCanDes.SetFocus()
			RETURN 
		ENDIF


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
		**
		*!*	IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		*!*	   THISFORM.Calcular_Totales
		*!*	ENDIF
		thisform	.cmdGrabar.Enabled  = .t.
		*
		THIS.PARENT.Cmdterminar.Click 
	ENDPROC


	PROCEDURE cmdcancelar2.Click
		thisform.Cancelar_trn_detalle(thisform.ccursor_d)  
		THIS.PARENT.Cmdterminar.Click

		*!*	WITH THIS.PARENT.PARENT.PAGES(3)
		*!*
		*!*		*** Deshabilitar Controles
		*!*		.CmdHelpCodMat.ENABLED = .F.
		*!*		.TxtCodMat.ENABLED = .F.
		*!*		.TxtCanDes.ENABLED = .F.
		*!*		.TxtPreUni.ENABLED = .F.
		*!*		.TxtImpCto.ENABLED = .F.
		*!*		.txtLote.ENABLED	= .f.
		*!*		.txtFchVto.ENABLED	= .f.
		*!*		.cmdAceptar2.ENABLED	= .F.
		*!*		.cmdCancelar2.ENABLED	= .F.
		*!*		.CmdHelpLote.ENABLED	= .F.
		*!*		** Inicializarlos ** 

		*!*	ENDWITH

		*!*	THIS.PARENT.cmdAceptar2.ENABLED	= .F.
		*!*	THIS.ENABLED	= .F.
		*!*	WITH THIS.PARENT.PARENT
		*!*		.PAGES(1).ENABLED	= .T.
		*!*		.ACTIVEPAGE	= 1
		*!*		LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_d)
		*!*		.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
		*!*		.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
		*!*		with thisform
		*!*			.cmdImprimir.ENABLED	= LlHayRegistros
		*!*		endwith 
		*!*		.PAGES(1).grdDetalle.REFRESH()
		*!*		.PAGES(1).grdDetalle.SETFOCUS()
		*!*	ENDWITH
		*!*	IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		*!*	   THISFORM.Calcular_Totales
		*!*	ENDIF
	ENDPROC


	PROCEDURE txtcodmat.Valid
		**IF THISFORM.xReturn = "I"
		   *!* Verifica que el Código No Exista
		*!*		IF thisform.objreftran.numele =2
		*!*	*!*			SET STEP ON 
		*!*		ENDIF


		   IF EMPTY(this.Value)
		   		RETURN 
		   ENDIF
		   IF GsSigCia='AROMAS'
				this.Parent.CmdHelpCodMat.cvaloresfiltro = ''
			ELSE
				this.Parent.CmdHelpCodMat.cvaloresfiltro = thisform.ObjRefTran.SubAlm
			ENDIF
			IF SET("Development")='ON' 
				LfHoraIni = SECONDS()
				SET CLOCK TO 03,02
			ENDIF
			M.ERR=THISFORM.VALIDitem() 

			IF m.err<0
				thisform.MensajeErr(m.err)
				RETURN .f.
			ENDIF
			IF SET("Development")='ON' 
				LfHoraFin = SECONDS()
				LsHora    = TotHoras(LfHoraIni,LfHoraFin)
				WAIT WINDOW LsHora
				LfHoraIni = SECONDS()
			ENDIF
		*!*	   IF !SEEK(TRIM(THIS.Value),"CATG","CATG01") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No Existe...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
		*!*	   IF !SEEK(thisform.ObjRefTran.SubAlm+TRIM(THIS.Value),"CALM") AND !EMPTY(this.Value)
		*!*		  =MESSAGEBOX("ERROR : Código de Material No asignado a este almacen...",48)
		*!*		  RETURN .F.
		*!*	   ENDIF
			THIS.VALUE = CURVAL('CODMAT',thisform.c_validitem )
			THIS.PARENT.TXTDESMAT.VALUE=CURVAL('DESMAT',thisform.c_validitem )
			THIS.PARENT.TXTUNDSTK.VALUE=CURVAL('UNDSTK',thisform.c_validitem )
			IF thisform.modo_edit_detalle = 1
		*!*		LsVCodMat=EVALUATE(thisform.cCursor_d+'.CodMat')
				LsVCodMat=THIS.VALUE
				LsOldVal=OLDVAL('CODMAT',thisform.cCursor_d)
				LsVDesMat=EVALUATE(thisform.cCursor_d+'.Desmat') 

				Thisform.pgfDetalle.page1.grdDetalle.column2.txtDesMat.Value = ;
				IIF(EMPTY(LsVDesMat) OR (LsOldVal<>LsVCodMat),THIS.PARENT.TXTDESMAT.VALUE,LsVDesMat)
			  *	thisform.pgfDetalle.page1.grdDetalle.Column2.txtDesmat.Value=c_CodMat.DESMAT
				thisform.pgfDetalle.page1.grdDetalle.Column3.txtUndVta.Value=CURVAL('UNDSTK',thisform.c_validitem )
				IF thisform.pgfDetalle.page1.grdDetalle.Column4.TxtCantidad.Value=0 AND CURVAL('Stk_Alm',thisform.c_validitem)>0
					thisform.pgfDetalle.page1.grdDetalle.Column4.TxtCantidad.Value=CURVAL('Stk_Alm',thisform.c_validitem)
				ENDIF
				IF LsOldVal<>LsVCodMat 
					THIS.Parent.TxtFacEqu.Value = 1 
				ENDIF

			ENDIF
		  	xAreaAct=SELECT()
			SELECT (thisform.cCursor_d)
			IF VARTYPE(SUBALM)='C'
				replace subalm WITH CURVAL('SUBALM',thisform.c_validitem) IN (thisform.cCursor_d)  
			ENDIF
			SELECT (xAreaAct)
		 	IF SET("Development")='ON' 
				LfHoraFin = SECONDS()
				LsHora    = TotHoras(LfHoraIni,LfHoraFin)
				WAIT WINDOW LsHora
			ENDIF
		   this.Parent.Cmdaceptar2.Enabled = .t.
		  
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
		IF this.Parent.TxtFacEqu.Value<=0
			This.parent.TxtImpCto.VALUE=ROUND(THIS.VALUE*this.parent.TxtPreUni.VALUE,2)
		ELSE
			This.parent.TxtImpCto.VALUE=ROUND(THIS.VALUE*this.parent.TxtPreUni.VALUE*this.Parent.TxtFacEqu.Value,2)  
		ENDIF
		*!*	IF !INLIST(thisform.Objreftran.XsCodDoc,'PEDI')
		*!*			REPLACE Candes WITH THIS.VALUE	IN (THISFORM.ccursor_d) 
		*!*			REPLACE CanFac WITH THIS.VALUE	IN (THISFORM.ccursor_d) 
		*!*	ELSE
		*!*			REPLACE CanPed WITH THIS.VALUE	IN (THISFORM.ccursor_d) 
		*!*	ENDIF

		*!*	DO CASE 
		*!*		CASE THISFORM.Que_transaccion = 'VENTAS'
		*!*			REPLACE ImpLin WITH This.parent.TxtImpCto.VALUE IN (THISFORM.ccursor_d) 
		*!*		CASE THISFORM.Que_transaccion = 'ALMACEN'
		*!*			REPLACE ImpCto WITH This.parent.TxtImpCto.VALUE IN (THISFORM.ccursor_d) 
		*!*	ENDCASE
	ENDPROC


	PROCEDURE txtpreuni.Valid
		IF this.Parent.TxtFacEqu.Value<=0
			This.parent.TxtImpCto.VALUE=round(THIS.VALUE*this.parent.TxtCandes.VALUE,2)
		ELSE
			This.parent.TxtImpCto.VALUE=ROUND(THIS.VALUE*this.parent.TxtCandes.VALUE*this.Parent.TxtFacEqu.Value,2)  
		ENDIF
		*!*	IF !EOF(THISFORM.ccursor_d)
		*!*		DO CASE
		*!*			CASE Thisform.Que_transaccion = 'ALMACEN' 
		*!*				replace PreUni WITH THIS.Value IN THISFORM.ccursor_d 
		*!*				replace ImpCto WITH This.parent.TxtImpCto.VALUE IN THISFORM.ccursor_d
		*!*			CASE Thisform.Que_transaccion = 'VENTAS' 
		*!*				replace PreUni WITH THIS.Value IN THISFORM.ccursor_d 
		*!*				replace Implin WITH This.parent.TxtImpCto.VALUE IN THISFORM.ccursor_d
		*!*
		*!*		ENDCASE
		*!*	ENDIF
	ENDPROC


	PROCEDURE txtimpcto.Valid
		IF this.parent.TxtCanDes.VALUE = 0
			This.parent.TxtPreUni.VALUE = 0
		else
			This.parent.TxtPreUni.VALUE = round(THIS.VALUE/this.parent.TxtCanDes.VALUE,4)
		ENDIF

		*!*	IF !EOF(THISFORM.ccursor_d)
		*!*		DO CASE
		*!*			CASE Thisform.Que_transaccion = 'ALMACEN' 
		*!*				replace PreUni WITH This.parent.TxtPreUni.VALUE IN THISFORM.ccursor_d
		*!*				replace ImpCto WITH THIS.Value IN THISFORM.ccursor_d
		*!*			CASE Thisform.Que_transaccion = 'VENTAS' 
		*!*				replace PreUni WITH This.parent.TxtPreUni.VALUE IN THISFORM.ccursor_d
		*!*				replace Implin WITH This.Value IN THISFORM.ccursor_d
		*!*
		*!*		ENDCASE
		*!*	ENDIF
	ENDPROC


	PROCEDURE txtlote.Valid
		IF EMPTY(this.Value)
		   RETURN 
		ENDIF

		M.ERR=thisform.validitemlote() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			IF INLIST(GsSigCia,'AROMAS','QUIMICA')
			ELSE
				RETURN .f.
			ENDIF
		ENDIF
		IF USED('C_LOTE') AND !EOF('C_LOTE') && AND m.Err>=0
			THIS.VALUE = c_Lote.Lote
			THIS.Parent.TxtFchVto.Value = c_Lote.FchVto
		ENDIF
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

		IF GsSigCia='AROMAS'
			this.cvaloresfiltro = ''
		ELSE
			this.cvaloresfiltro = thisform.ObjRefTran.SubAlm
		ENDIF

		DODEFAULT()
		IF thisform.modo_edit_detalle = 1
			thisform.pgfDetalle.page1.grdDetalle.column1.txtCodmat.Value = this.cvalorvalida   
		ELSE
			this.Parent.TxtCodMat.Value = this.cvalorvalida 
			this.Parent.TxtCodMat.SetFocus
			IF !EMPTY(this.Parent.TxtCodMat.Value)
				KEYBOARD '{END}'+'{ENTER}'
			ENDIF
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
		   THIS.VALUE = CURVAL('CODMAT',thisform.c_validitem)
		   THIS.PARENT.TXTDESMAT.VALUE=CURVAL('DESMAT',thisform.c_validitem)
		   THIS.PARENT.TXTUNDSTK.VALUE=CURVAL('UNDSTK',thisform.c_validitem)
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


	PROCEDURE cmdterminar.Click
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
			.PAGES(1).ENABLED	= .T.
			.ACTIVEPAGE	= 1
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_d)
			.PAGES(1).cmdModificar1.ENABLED	= LlHayRegistros
			.PAGES(1).cmdEliminar1.ENABLED	= LlHayRegistros
			with thisform
				.cmdImprimir.ENABLED	= LlHayRegistros
			endwith 
			.PAGES(1).grdDetalle.REFRESH()
			.PAGES(1).grdDetalle.SETFOCUS()
		ENDWITH
		IF thisform.ObjRefTran.lpidpco OR thisform.ObjRefTran.lCtoVta
		   THISFORM.Calcular_Totales
		ENDIF
	ENDPROC


	PROCEDURE txtfacequ.Valid
		This.parent.TxtImpCto.VALUE=round(THIS.VALUE*this.parent.TxtCandes.VALUE,4)

		*!*	IF !EOF(THISFORM.ccursor_d)
		*!*		DO CASE
		*!*			CASE Thisform.Que_transaccion = 'ALMACEN' 
		*!*				replace PreUni WITH THIS.Value IN THISFORM.ccursor_d 
		*!*				replace ImpCto WITH This.parent.TxtImpCto.VALUE IN THISFORM.ccursor_d
		*!*			CASE Thisform.Que_transaccion = 'VENTAS' 
		*!*				replace PreUni WITH THIS.Value IN THISFORM.ccursor_d 
		*!*				replace Implin WITH This.parent.TxtImpCto.VALUE IN THISFORM.ccursor_d
		*!*
		*!*		ENDCASE
		*!*	ENDIF
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


	PROCEDURE cntcodtra.txtCodigo.InteractiveChange
		this.Parent.Parent.cboCodTra.InteractiveChange()  
	ENDPROC


	PROCEDURE cntcodtra.txtCodigo.Valid
		DODEFAULT()
		IF EMPTY(this.value)
			return
		ENDIF
		this.Parent.Parent.txtNomtra.Value = this.Parent.TxtDescripcion.Value
		=SEEK(GsClfTra+this.Value,'CBDMAUXI','AUXI01')
		this.Parent.Parent.TxtNomTra.Value = CBDMAUXI.NomAux
		this.Parent.Parent.TxtDirTra.Value = CBDMAUXI.DirAux
		this.Parent.Parent.TxtRucTra.Value = CBDMAUXI.RucAux
		this.Parent.Parent.TxtPlaTra.Value = SUBSTR(CBDMAUXI.Transport,1,15)
		*!*	this.Parent.TxtMarca.Value 	= SUBSTR(CBDMAUXI.Transport,16,15)
		this.Parent.Parent.TxtBrevet.Value = SUBSTR(CBDMAUXI.Transport,32,15)
		*!*	this.Parent.TxtCertif.Value = SUBSTR(CBDMAUXI.Transport,48,15)
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
		    	thisform.objcntcab.SetFocus
		    	RETURN
		    
		    ENDIF 
		    thisform.objcntcab.Enabled = .F.
		   	with thisform.pgfdetalle.page1
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

				.txtNroDoc.ENABLED		= thisform.xReturn <> "E"
				.txtFchDoc.ENABLED		= thisform.xReturn <> "E"
				.txtObserv.ENABLED		= thisform.xReturn <> "E"
		**		.txtTpoCmb.ENABLED		= thisform.xReturn <> "E"
		**		.cboCodMon.ENABLED		= thisform.xReturn <> "E"
				.cmdHelpNrodoc.enabled	= thisform.xReturn <> "E" AND !thisform.lNuevo
				.txtNroDoc.ENABLED		= thisform.xReturn <> "E" AND !thisform.lNuevo

				.txtFchDoc.VALUE		= DATE()
				.TxtFchDoc.SetFocus()
			ENDWITH
			.cmdAdicionar.ENABLED	= .F.
			.cmdModificar.ENABLED	= .F.
			.cmdEliminar.ENABLED	= .F.

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


			.cmdIniciar.ENABLED		= .T.
			.cmdImprimir.ENABLED	= .F.
			.cmdSalir.ENABLED		= .F.
			*
		    thisform.objcntcab.Enabled = .F. 
			with thisform.pgfdetalle.page1
				.TxtNroDoc.ENABLED = .T.
				.txtObserv.ENABLED		= thisform.xReturn <> "E"
				.CmdHelpNroDoc.ENABLED = .T.
				.TxtNroDoc.SETFOCUS()
			ENDWITH
			.cmdAdicionar.ENABLED	= .F.
			.cmdModificar.ENABLED	= .F.
			.cmdEliminar.ENABLED	= .F.
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

		    thisform.objcntcab.Enabled = .F.
			with thisform.pgfdetalle.page1
				.TxtNroDoc.ENABLED	= .T.
				.CmdHelpNroDoc.ENABLED	= .T.
				.TxtNroDoc.SETFOCUS()

			ENDWITH
			.cmdAdicionar.ENABLED	= .F.
			.cmdModificar.ENABLED	= .F.
			.cmdEliminar.ENABLED	= .F.

			.lNuevo		= .F.
			.lGrabado	= .F.
			*.eli_cabecera() 
			.ObjRefTran.Crear = .lNuevo
			.cmdGrabar.Enabled  = .t.
			.cmdGrabar.Caption  = 'Eliminar'
			.cmdGrabar.Tooltiptext  = 'Eliminar transacción'
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
		thisform.tools.closetable([RPRO])
		thisform.tools.closetable([VPED])
		thisform.tools.closetable([VPRO])
		thisform.tools.closetable([CLIE])
		thisform.tools.closetable([C_CORRE])
		thisform.tools.closetable([C_GDOC])
		thisform.tools.closetable([C_DETA])
		thisform.tools.closetable(thisform.objcntpage.c_validcliente)
		thisform.tools.closetable(thisform.objcntpage.c_validNroRef)
		thisform.tools.closetable([C_CODMAT])
		thisform.tools.closetable(thisform.c_validitem)
		thisform.tools.closetable([V_MATERIALES_X_LOTE])
		thisform.TOOLS.closetable([ALMDLOTE])
		thisform.TOOLS.Closetable(thisform.caliascab)  
		thisform.TOOLS.Closetable(thisform.caliasdet)  
		thisform.TOOLS.Closetable(thisform.ctabla_c)  
		thisform.TOOLS.Closetable(thisform.ctabla_d)  
		thisform.TOOLS.Closetable(thisform.ctabla_d2)  
		thisform.tools.closetable([v_materiales_x_almacen])
		thisform.tools.closetable([v_materiales_x_almacen_2])
		thisform.tools.closetable([v_materiales_x_almacen_3])
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
		IF THISFORM.xReturn == "I" 
			IF EMPTY(thisform.objcntpage.CntCodCli.VALUE )
				MESSAGEBOX("No ha registrado el Cliente",48,"ATENCION !!")
				RETURN
			ENDIF
		ENDIF

		m.err = thisform.validcliente() 
		IF m.err<0
			thisform.MensajeErr(m.err)
			thisform.PgfDetalle.Page1.SetFocus  
			RETURN 
		ENDIF

		lControl = THISFORM.Grabar_Datos(4,THISFORM.xReturn)

		IF thisform.xReturn # 'E'
			thisform.Cmdimprimir.Click
		ENDIF
		IF VARTYPE(THISFORM.CmdDespacho)='O' AND INLIST(Thisform.ObjReftran.XsCodDoc,'FACT','BOLE')
		*	thisform.CmdDespacho.Visible = INLIST(thisform.objreftran.XsCodRef,'FREE','G/R') and thisform.xreturn#'E'
			IF MESSAGEBOX("Imprimir Orden de despacho de almacen",4+32,'Atencion !!')=6
				thisform.CmdDespacho.Click
			ENDIF
		ENDIF


		IF lControl
		   *THISFORM.cmdIniciar.CLICK()
		   THISFORM.INICIAR_VAR()   
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_form_transac
**************************************************


**************************************************
*-- Class:        base_grid (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Time Stamp:   06/13/07 02:30:08 AM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS base_grid AS grid


	ColumnCount = 0
	FontSize = 8
	AllowHeaderSizing = .F.
	AllowRowSizing = .F.
	DeleteMark = .F.
	Height = 171
	HighlightRowLineWidth = 3
	Panel = 1
	ReadOnly = .T.
	RecordMark = .T.
	RecordSourceType = 4
	RowHeight = 17
	Width = 320
	GridLineColor = RGB(192,192,192)
	HighlightBackColor = RGB(155,213,217)
	HighlightForeColor = RGB(0,0,0)
	HighlightStyle = 2
	registro = 0
	*-- Campo correlativo que pertenece a ccmps_id
	ccampo_id = ([])
	*-- Campos que conforman la clave de la tabla asociada al grid
	ccmpkey = ([])
	*-- Campos que conforman la clave para generar el campo correlativo unico de la llave primaria de la tabla asociada al grid
	ccmps_id = ([])
	*-- Tabla remota asociada al grid
	ctabla_remota = ([])
	*-- Valor de la clave principal de la tabla asociada al grid
	cvalkey = ([])
	*-- Genera el correlativo del ccampo_id
	lgen_id = .T.
	*-- Posicion relativa de desplazamiento respecto al valor de la propiedad LEFT
	r_left = 0
	*-- Posicion relativa de desplazamiento respecto al valor de la propiedad TOP
	r_top = 0
	*-- Referencia a objeto que controla la generacion de un grid dinamico
	odinamico = .F.
	*-- Contiene el nombre del campo a totalizar
	cfieldtosum = ([])
	*-- Almacena el resultado de sumar el valor del campo contenido en cFieldToSum
	ncolumnsum = 0
	Name = "base_grid"

	*-- Indica si cambio de Fila
	lrowchange = .F.


	*-- Calcula el total de la columna  segun el campo cFieldtosum
	PROCEDURE sumcolumn
		IF EMPTY(this.cFieldToSum)
		  RETURN
		ENDIF

		LOCAL lnOldArea, ;
		    lnOldRecNo, ;
		    luKey, ;
		    lcFieldToSum, ;
		    lcOrder

		lnOldArea = SELECT()
		this.nColumnSum = 0
		lcFieldToSum = ""

		IF EMPTY(this.RecordSource)
		  RETURN
		ENDIF

		*-- Select the alias specified in the grid's RecordSource property
		SELECT (this.RecordSource)

		lcOrder = ORDER()
		*-- Use the string returned by ORDER() as the parameter
		*-- to the EVAL() function to retrive the value of the 
		*-- current ID, which we use later to SEEK() into the table.
		luKey = IIF(!EMPTY(lcOrder), EVAL(lcOrder), "")
		lnOldRecNo = IIF(EOF(), 0, RECNO())
		lcFieldToSum = this.cFieldToSum

		*-- Total up the column and store the result 
		*-- in the nColumnSum property
		IF !EMPTY(lcOrder) AND SEEK(luKey)
		  SUM &lcFieldToSum. ;
		    WHILE luKey = EVAL(lcOrder) ;
		    TO this.nColumnSum
		ELSE
		  IF CURSORGETPROP("SOURCETYPE") = DB_SRCLOCALVIEW OR ;
		      CURSORGETPROP("SOURCETYPE") = DB_SRCREMOTEVIEW OR ;
		      CURSORGETPROP("SOURCETYPE") = DB_SRCTABLE
		      
		    *-- Grid is bound to a view
		    SUM &lcFieldToSum. ;
		      TO this.nColumnSum
		  ENDIF
		ENDIF
		  
		IF lnOldRecNo <> 0
		  GO lnOldRecNo
		ENDIF

		SELECT (lnOldArea)
	ENDPROC


	PROCEDURE Init
		*!*	-------------------------------------------------------------------------------
		*!*	Titulo			:
		*!*	Propósito		:	Configurar el Grid de acuerdo al Estandar de Diseño Interno
		*!*
		*!*	PARÁMETROS		:	<Ninguno>
		*!*	Valor de retorno:	<Ninguno>
		*!*	LLAMADAS		:	<Ninguno>
		*!*	CLASES HEREDADAS
		*!*	Comentarios 	:
		*!*
		*!*	CREACIÓN
		*!*		Fecha  		:	29-Oct-1999
		*!*		Autor		:	Giuliano Gonzales Zeballos
		*!*		Comentario	:
		*!*
		*!*	ULTIMA MODIFICACIÓN
		*!*		Fecha		:
		*!*		Autor		:
		*!*		Comentario	:
		*!*	-------------------------------------------------------------------------------
		LOCAL m.lnCount1 , m.lnCount2

		*!*	Recorrer todos las columnas del Grid
		THIS.GRIDLINECOLOR		= RGB(192,192,192)	&& Gris Oscuro en rejilla de Grid
		THIS.ALLOWHEADERSIZING	= .F.				&& No puede alterar altura de cabecera
		THIS.ALLOWROWSIZING		= .F.				&& No puede alterar altura de la fila
		FOR m.lnCount1 = 1 TO THIS.COLUMNCOUNT
			*!*	Recorrer todos los objetos de cada columna del Grid
			THIS.COLUMNS(m.lnCount1).RESIZABLE	= .F.	&& No podra alterar el ancho de columna
			THIS.COLUMNS(m.lnCount1).FONTSIZE	= THIS.FONTSIZE
			THIS.COLUMNS(m.lnCount1).MOVABLE	= .F.	&& Para que no pueda mover las columnas
			FOR m.lnCount2 = 1 TO THIS.COLUMNS(m.lnCount1).CONTROLCOUNT
				*!*	Configurar solo las Cabeceras (Header)
				IF THIS.COLUMNS(m.lnCount1).CONTROLS(m.lnCount2).BASECLASS == 'Header'
					WITH THIS.COLUMNS(m.lnCount1).CONTROLS(m.lnCount2)
						IF LEN(.CAPTION) > 1
							.FONTBOLD	= .F.
							*.FONTSIZE	= 8
						ENDIF
						.FORECOLOR	= RGB(128,0,128)	&& Rojo Oscuro
						.BACKCOLOR	= RGB(223,223,223)	&& Gris Claro
						.ALIGNMENT	= 2					&& Centrado
					ENDWITH
				ENDIF
			ENDFOR
		ENDFOR
		THIS.RECORDSOURCE = ""
		THIS.RECORDSOURCETYPE = 4
		IF VERSION(5)<700
			THIS.SETALL("DynamicBackColor", "IIF( !EMPTY(ALIAS()) AND RECNO()= THIS.Registro , RGB(0,128,192), RGB(255,255,255))" , "Column")
			THIS.SETALL("DynamicForeColor", "IIF( !EMPTY(ALIAS()) AND RECNO()= THIS.Registro , RGB(255,255,255), RGB(0,0,0))" , "Column")
		ENDIF
		THIS.REFRESH()
	ENDPROC


	PROCEDURE AfterRowColChange
		LPARAMETERS nColIndex
		THIS.lRowChange	= THIS.Registro	<> RECNO()
		THIS.Registro	= RECNO()
		IF VERSION(5)<700
			THISFORM.REFRESH()
		ENDIF
	ENDPROC


	PROCEDURE Refresh
		*-- Recalc column totals each time grid is refreshed
		this.SumColumn()
	ENDPROC


	PROCEDURE configurarfilas
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_grid
**************************************************


**************************************************
*-- Class:        base_grid_atributos (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_grid (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    grid
*-- Time Stamp:   10/17/00 03:34:05 PM
*
DEFINE CLASS base_grid_atributos AS base_grid


	ColumnCount = 3
	Height = 171
	Panel = 1
	Partition = 0
	ReadOnly = .T.
	ScrollBars = 2
	Width = 360
	*-- Indica si permite editar atributos relevantes
	editarrelevantes = .T.
	Name = "base_grid_atributos"
	Column1.Width = 154
	Column1.ReadOnly = .T.
	Column1.Name = "Column1"
	Column2.Tag = "_ValorEspecifico"
	Column2.Alignment = 3
	Column2.Width = 154
	Column2.ReadOnly = .T.
	Column2.Name = "Column2"
	Column3.CurrentControl = "cmdHelp"
	Column3.Width = 22
	Column3.ReadOnly = .T.
	Column3.Sparse = .F.
	Column3.Name = "Column3"

	*-- Esta propiedad indica que los atributos se usan para efectuar una busqueda y no un mantenimiento de ATRIBUTO-VALOR
	lbusqueda = .F.


	ADD OBJECT base_grid_atributos.column1.header1 AS header WITH ;
		Caption = "Atributo", ;
		Name = "Header1"


	ADD OBJECT base_grid_atributos.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_grid_atributos.column2.header1 AS header WITH ;
		Caption = "Valor", ;
		Name = "Header1"


	ADD OBJECT base_grid_atributos.column2.text1 AS textbox WITH ;
		Alignment = 3, ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT base_grid_atributos.column3.header1 AS header WITH ;
		FontName = "Marlett", ;
		Caption = "s", ;
		Name = "Header1"


	ADD OBJECT base_grid_atributos.column3.txthelp AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "txtHelp"


	ADD OBJECT base_grid_atributos.column3.cmdhelp AS base_cmdhelp WITH ;
		Tag = "ValorEspecifico", ;
		Top = 35, ;
		Left = 3, ;
		Height = 24, ;
		Width = 12, ;
		Name = "cmdHelp"


	HIDDEN PROCEDURE lbusqueda_assign
		LPARAMETERS tlBusqueda
		tlBusqueda = IIF(VARTYPE(tlBusqueda)=='L',tlBusqueda,.F.)
		THIS.lBusqueda = tlBusqueda
	ENDPROC


	PROCEDURE Init
		*!*	Forzar el metodo assign
		THIS.lBusqueda = THIS.lBusqueda
		DODEFAULT()
	ENDPROC


	PROCEDURE Destroy
		DODEFAULT()
		IF !EMPTY(THIS.RECORDSOURCE) AND USED(THIS.RECORDSOURCE)
			USE IN (THIS.RECORDSOURCE)
		ENDIF
	ENDPROC


	PROCEDURE AfterRowColChange
		LPARAMETERS nColIndex

		*!*	Verificar si se permite editar los atributos relevantes
		IF TYPE("IndicaSiAtributoRelevante") == "L"  AND IndicaSiAtributoRelevante AND !THIS.EditarRelevantes
			THIS.COLUMNS(3).cmdHelp.ENABLED = .F.
		ELSE
			*!*	Verificar si se incluyeron valores por defecto para la Grilla
			IF TYPE("FlagDefault")=="L" AND FlagDefault
				THIS.COLUMNS(3).cmdHelp.ENABLED = .F.
			ELSE
				*!*	Configurar el boton para que muestre la ayuda adecuada
				THIS.COLUMNS(3).cmdHelp.ENABLED = .T.
				THIS.COLUMNS(3).cmdHelp.ConfigurarParametros(;
						ValorAtributo,;
						SUBSTR(NombreEntidadCampo,RAT('.',NombreEntidadCampo)+1),;
						CampoRetorno,;
						CampoVisualizacion,;
						.t.,"","",ModoObtenerDatos,SecuenciaCampos)
				THIS.COLUMNS(3).cmdHelp.GenerarSecuenciaCampos()
			ENDIF
		ENDIF

		THISFORM.REFRESH()
	ENDPROC


	PROCEDURE text1.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl


		DO CASE
		CASE nKeyCode == 13	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Enter
			THIS.PARENT.PARENT.Column3.cmdHelp.CLICK()
		CASE nKeyCode == 7	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Suprimir
			THIS.PARENT.PARENT.Column3.cmdHelp.RIGHTCLICK()
		ENDCASE
	ENDPROC


	PROCEDURE text1.KeyPress
		LPARAMETERS nKeyCode, nShiftAltCtrl

		DO CASE
		CASE nKeyCode == 13	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Enter
			THIS.PARENT.PARENT.Column3.cmdHelp.CLICK()
		CASE nKeyCode == 7	AND ;
				TYPE("THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED")== "L" AND ;
				THIS.PARENT.PARENT.Column3.cmdHelp.ENABLED && Presionó Suprimir
			THIS.PARENT.PARENT.Column3.cmdHelp.RIGHTCLICK()
		ENDCASE
	ENDPROC


	PROCEDURE cmdhelp.Click
		LOCAL lcCampoRetorno , lcCampoVisualizacion , lcAlias
		LOCAL lcCampoValor1 , lcCampoValor2 , lcValorRetorno

		lcAlias = ALIAS()
		lcCampoValor1		= THIS.TAG
		lcCampoValor2		= "_"+THIS.TAG
		llFlagBusqueda		= FlagBusqueda

		lcCampoRetorno		= ""
		lcCampoVisualizacion= ""

		DO CASE
		CASE !ISNULL(CodigoTabla) AND !EMPTY(CodigoTabla)	&& Tiene código de Tabla de Tablas
			THIS.cCamposFiltro = "CodigoTabla"
			THIS.cValoresFiltro = CodigoTabla
			*THIS.GenerarArreglo()
			THIS.GenerarWHERE()
			DO FORM gen2_Ayuda_Codigo_Busqueda ;
				WITH THIS.cWhere, (THIS) , (THIS.PARENT.PARENT.lBusqueda AND ModoObtenerDatos=='L')

			* Indica si esta en modo de Busqueda y que la modalidad de obtener datos es LISTA
			* THIS.PARENT.PARENT.lBusqueda AND ModoObtenerDatos=='L'
			IF !EMPTY(THIS.cValorValida)
				lcCampoRetorno 			= THIS.cValorValida
				lcCampoVisualizacion	= THIS.cValorDescripcion
			ENDIF
			THIS.cValorValida		= ""
			THIS.cValorDescripcion	= ""
			*!*	Se valida en otra tabla	y se seleccionó que no se muestre la ayuda
		CASE !ISNULL(CodigoEntidadCampo) AND !EMPTY(CodigoEntidadCampo)	AND ModoObtenerDatos<>"E"
			*THIS.GenerarArreglo()
			THIS.GenerarWHERE()
			IF llFlagBusqueda
				DO FORM gen2_Ayuda_Codigo_Criterio ;
					WITH THIS.cWhere, (THIS)
			ELSE
				DO FORM gen2_Ayuda_Codigo_Busqueda ;
					WITH THIS.cWhere, (THIS) , (THIS.PARENT.PARENT.lBusqueda AND ModoObtenerDatos=='L')
			ENDIF
			IF !EMPTY(THIS.cValorValida)
				lcCampoRetorno 			= THIS.cValorValida
				lcCampoVisualizacion	= THIS.cValorDescripcion
			ENDIF
			THIS.cValorValida		= ""
			THIS.cValorDescripcion	= ""
		OTHERWISE
			lcTipoDato	= TipoDatoCampo
			DO FORM GEN3_Atributos_Edt WITH ;
				DescripcionCampo,TipoDatoCampo,LongitudDato,;
				IIF(THIS.PARENT.PARENT.lBusqueda,ModoObtenerDatos,'V'),;
				MascaraDato,&lcCampoValor1 ;
				TO lcValorRetorno
			IF !ISNULL(lcValorRetorno)
				lcCampoRetorno		= IIF(lcTipoDato == 'L' , IIF(ALLTRIM(lcValorRetorno)='SI','1','0'),lcValorRetorno)
				lcCampoVisualizacion= lcValorRetorno
			ENDIF
		ENDCASE


		SELECT(lcAlias)
		IF !EMPTY(lcCampoRetorno)
			IF !EMPTY(lcCampoRetorno)
				lcComando	= "REPLACE " + lcCampoValor2 + " WITH '" + ALLTRIM(lcCampoVisualizacion)+ ;
							  "' , " + lcCampoValor1	+ " WITH '" + ALLTRIM(lcCampoRetorno) + ;
							  "' , FlagOrigenRemoto WITH " + IIF(FlagOrigenRemoto==0,"2",STR(FlagOrigenRemoto,1))
				*=MESSAGEBOX(lcComando)
				&lcComando
		*!*			REPLACE &lcCampoValor2	 WITH ALLTRIM(lcCampoVisualizacion),;
		*!*					&lcCampoValor1	 WITH ALLTRIM(lcCampoRetorno) ,;
		*!*					FlagOrigenRemoto WITH IIF(FlagOrigenRemoto=0,2,FlagOrigenRemoto)
			ENDIF
		ENDIF
		THIS.PARENT.PARENT.REFRESH()
	ENDPROC


	PROCEDURE cmdhelp.RightClick
		LOCAL lcCampoValor1 , lcCampoValor2
		lcCampoValor1		= THIS.TAG
		lcCampoValor2		= "_"+THIS.TAG

		IF !EMPTY(&lcCampoValor2) AND ;
			MESSAGEBOX("¿ Desea Eliminar el Valor del Atributo ?",4+32+256,"Eliminar Valor") == 6
			REPLACE &lcCampoValor2	 WITH "",;
					&lcCampoValor1	 WITH "",;
					FlagOrigenRemoto WITH IIF(FlagOrigenRemoto=0,2,FlagOrigenRemoto)
		ENDIF
		THIS.PARENT.PARENT.REFRESH()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_grid_atributos
**************************************************


**************************************************
*-- Class:        base_gridheader (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   06/01/00 01:48:00 PM
*
DEFINE CLASS base_gridheader AS container


	Width = 52
	Height = 20
	SpecialEffect = 0
	BackColor = RGB(223,223,223)
	Name = "base_gridheader"


	ADD OBJECT label1 AS label WITH ;
		FontBold = .F., ;
		FontSize = 8, ;
		Alignment = 2, ;
		BackStyle = 0, ;
		Caption = "Label1", ;
		Height = 16, ;
		Left = 6, ;
		Top = 2, ;
		Width = 40, ;
		ForeColor = RGB(128,0,128), ;
		Name = "Label1"


ENDDEFINE
*
*-- EndDefine: base_gridheader
**************************************************


**************************************************
*-- Class:        base_img (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  image
*-- BaseClass:    image
*-- Time Stamp:   09/01/00 04:28:07 PM
*
DEFINE CLASS base_img AS image


	Stretch = 2
	BorderStyle = 1
	Height = 91
	Width = 100
	Name = "base_img"


ENDDEFINE
*
*-- EndDefine: base_img
**************************************************


**************************************************
*-- Class:        base_img_desarrollo_version (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_img (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    image
*-- Time Stamp:   07/03/00 03:19:09 PM
*
DEFINE CLASS base_img_desarrollo_version AS base_img


	Stretch = 1
	Visible = .F.
	*-- Indica cual image se mostrará 1=Imagen Frontal (Default) 2=Imagen de Espalda
	ntipoimagen = 1
	*-- Es la ruta del Archivo de lmagen de Frente
	cpathimagenespalda = ""
	*-- Es la ruta del Archivo de lmagen de Espalda
	cpathimagenfrente = ""
	*-- Es el nombre de la Entidad desde la cual se obtendrá la ruta de la imagen
	centidadorigen = "MDesarrolloTelas_Detalle"
	*-- Nombre del campo desde donde se extraera la ruta de la imagen de Frente
	ccampoimagenfrente = "PathImagenFrente"
	*-- Nombre del Campo desde donde se extraera la imagen de Espalda
	ccampoimagenespalda = "PathImagenEspalda"
	*-- Contiene los nombres de los campo clave de tabla desde la que se extraerá las rutas de las imagenes
	ccamposclaveorigen = "CodigoProducto;CodigoFamilia;CodigoDesarrollo;VersionCodigoDesarrollo"
	Name = "base_img_desarrollo_version"

	*-- Indica si los metodos Assign se ejecutarán
	HIDDEN lexec_assign

	*-- Contiene los Valores de los campo clave de tabla desde la que se extraerá las rutas de las imagenes
	cvaloresclaveorigen = .F.
	HIDDEN cremotepathentidad

	*-- Matriz de los campos clave origen
	HIDDEN acamposclaveorigen[1]

	*-- matriz de valores de las claves
	HIDDEN avaloresclaveorigen[1]


	HIDDEN PROCEDURE ntipoimagen_assign
		LPARAMETERS tnTipoImagen

		IF BETWEEN(tnTipoImagen,1,2)
			THIS.nTipoImagen = tnTipoImagen
		ENDIF

		THIS.MostrarImagen()
	ENDPROC


	HIDDEN PROCEDURE centidadorigen_assign
		LPARAMETERS tcEntidadOrigen
		IF VARTYPE(tcEntidadOrigen) <> "C"
			tcEntidadOrigen	= ""
		ENDIF

		THIS.cEntidadOrigen = ALLTRIM(tcEntidadOrigen)

		IF !EMPTY( THIS.cEntidadOrigen )
			THIS.cRemotePathEntidad	= goEntorno.RemotePathEntidad(THIS.cEntidadOrigen)
		ELSE
			THIS.cRemotePathEntidad	= ""
		ENDIF
	ENDPROC


	*-- Obtiene las rutas de las imagenes de Frente y Espalda segun CodigoDesarrollo y VersionCodigoDesarrollo
	PROCEDURE obtenerimagen
		LOCAL lcCampo , lcValor 
		IF	EMPTY(THIS.cEntidadOrigen) OR EMPTY(THIS.cCamposClaveOrigen) OR ;
			EMPTY(THIS.cValoresClaveOrigen) OR ;
			(EMPTY(THIS.cCampoImagenFrente) AND EMPTY(THIS.cCampoImagenEspalda))
			THIS.VISIBLE = .F.
			RETURN .F.
		ENDIF

		DO CASE
		CASE !EMPTY(THIS.cCampoImagenFrente) AND !EMPTY(THIS.cCampoImagenEspalda)
			lcSQL_SELECT = "SELECT " + THIS.cCampoImagenFrente + "," + THIS.cCampoImagenEspalda
		CASE !EMPTY(THIS.cCampoImagenFrente)
			lcSQL_SELECT = "SELECT " + THIS.cCampoImagenFrente
		CASE !EMPTY(THIS.cCampoImagenEspalda)
			lcSQL_SELECT = "SELECT " + THIS.cCampoImagenEspalda
		ENDCASE

		lcSQL_SELECT = lcSQL_SELECT + " FROM " + THIS.cRemotePathEntidad+ ;
						" WHERE " 

		FOR I=1 TO ALEN(THIS.aCamposClaveOrigen)
			lcCampo	= IIF( TYPE( "THIS.aCamposClaveOrigen[I]" ) == "C" , THIS.aCamposClaveOrigen[I] , "" )
			lcValor = IIF( TYPE( "THIS.aValoresClaveOrigen[I]") == "C" , THIS.aValoresClaveOrigen[I], "" )

			IF !EMPTY(lcCampo) AND !EMPTY(lcValor)
				lcSQL_SELECT = lcSQL_SELECT + lcCampo + "='" + lcValor + "' AND "
			ENDIF
		ENDFOR

		lcSQL_SELECT = LEFT(lcSQL_SELECT,LEN(lcSQL_SELECT)-5)

		IF EMPTY(lcSQL_SELECT)
			RETURN .F.
		ENDIF

		goConexion.cSQL = lcSQL_SELECT
		goConexion.cCursor = ""
		goConexion.DoSQL()

		SELECT(goConexion.cCursor)
		DO CASE
		CASE !EMPTY(THIS.cCampoImagenFrente) AND !EMPTY(THIS.cCampoImagenEspalda)
			THIS.cPathImagenFrente	= EVAL(FIELD(1))
			THIS.cPathImagenEspalda	= EVAL(FIELD(2))
		CASE !EMPTY(THIS.cCampoImagenFrente)
			THIS.cPathImagenFrente	= EVAL(FIELD(1))
		CASE !EMPTY(THIS.cCampoImagenEspalda)
			THIS.cPathImagenEspalda	= EVAL(FIELD(2))
		ENDCASE
		goCOnexion.CloseCursor()
		THIS.MostrarImagen()
	ENDPROC


	HIDDEN PROCEDURE cpathimagenespalda_assign
		LPARAMETERS tcPathImagenEspalda

		IF VARTYPE(tcPathImagenEspalda)="C"
			THIS.cPathImagenEspalda= ALLTRIM(tcPathImagenEspalda)
		ELSE
			THIS.cPathImagenEspalda= ""
		ENDIF

		THIS.MostrarImagen()
	ENDPROC


	HIDDEN PROCEDURE cpathimagenfrente_assign
		LPARAMETERS tcPathImagenFrente
		IF VARTYPE(tcPathImagenFrente)=="C"
			THIS.cPathImagenFrente= tcPathImagenFrente
		ELSE
			THIS.cPathImagenFrente= ""
		ENDIF
		THIS.MostrarImagen()
	ENDPROC


	*-- Muestra la imagen segun nTipoImagen
	HIDDEN PROCEDURE mostrarimagen
		DO CASE
		CASE THIS.nTipoImagen == 1
			IF VARTYPE(THIS.cPathImagenFrente)=="C" AND FILE(THIS.cPathImagenFrente)
				THIS.PICTURE = THIS.cPathImagenFrente
				THIS.VISIBLE = .T.
			ELSE
				THIS.VISIBLE = .F.
				THIS.PICTURE = ""
			ENDIF
		CASE THIS.nTipoImagen == 2
			IF VARTYPE(THIS.cPathImagenEspalda)=="C" AND FILE(THIS.cPathImagenEspalda)
				THIS.PICTURE = THIS.cPathImagenEspalda
				THIS.VISIBLE = .T.
			ELSE
				THIS.VISIBLE = .F.
				THIS.PICTURE = ""
			ENDIF
		ENDCASE
	ENDPROC


	*-- Convierte una cadena delimitada por caracteres a una matriz
	HIDDEN PROCEDURE chrtoarray
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


	HIDDEN PROCEDURE cvaloresclaveorigen_assign
		LPARAMETERS tcValoresClaveOrigen

		tcValoresClaveOrigen		= IIF( VARTYPE(tcValoresClaveOrigen)<>"C" , "" , ALLTRIM(tcValoresClaveOrigen) )
		THIS.cValoresClaveOrigen	= tcValoresClaveOrigen

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cValoresClaveOrigen )
			THIS.ChrToArray( THIS.cValoresClaveOrigen, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aValoresClaveOrigen )
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ccamposclaveorigen_assign
		LPARAMETERS tcCamposClaveOrigen

		tcCamposClaveOrigen		= IIF( VARTYPE(tcCamposClaveOrigen)<>"C" , "" , ALLTRIM(tcCamposClaveOrigen) )
		THIS.cCamposClaveOrigen	= tcCamposClaveOrigen

		DIMENSION aCampos[1]
		IF !EMPTY( THIS.cCamposClaveOrigen )
			THIS.ChrToArray( THIS.cCamposClaveOrigen, ";" , @aCampos )
			=ACOPY(aCampos, THIS.aCamposClaveOrigen )
		ENDIF
	ENDPROC


	PROCEDURE configurar_rutas
		LPARAMETER tcPathImagenFrente , tcPathImagenEspalda
		THIS.cPathImagenFrente	= ALLTRIM(tcPathImagenFrente)
		THIS.cPathImagenEspalda	= ALLTRIM(tcPathImagenEspalda)
	ENDPROC


	PROCEDURE Init
		LOCAL tcEntidadOrigen , tcCamposClaveOrigen	, tcValoresClaveOrigen , tcCampoImagenFrente , tcCampoImagenEspalda , tnTipoImagen

		*!*	Si los parámetros no son pasados correctamente, entonces asumir los valores de la clase
		tcCampoImagenFrente	= IIF(VARTYPE(tcCampoImagenFrente)=='C',tcCampoImagenFrente,THIS.cCampoImagenFrente)
		tcCampoImagenEspalda= IIF(VARTYPE(tcCampoImagenEspalda)=='C',tcCampoImagenEspalda,THIS.cCampoImagenEspalda)

		*!*	Revisar si los parámetros están correctamente
		tcEntidadOrigen		= IIF(VARTYPE(THIS.cEntidadOrigen)=='C',THIS.cEntidadOrigen,'')
		tcCamposClaveOrigen	= IIF(VARTYPE(THIS.cCamposClaveOrigen)=='C',THIS.cCamposClaveOrigen,'')
		tcValoresClaveOrigen= IIF(VARTYPE(THIS.cValoresClaveOrigen)=='C',THIS.cValoresClaveOrigen,'')
		tcCampoImagenFrente	= IIF(VARTYPE(THIS.cCampoImagenFrente)=='C',THIS.cCampoImagenFrente,'')
		tcCampoImagenEspalda= IIF(VARTYPE(THIS.cCampoImagenEspalda)=='C',THIS.cCampoImagenEspalda,'')
		tnTipoImagen		= IIF(VARTYPE(THIS.nTipoImagen)=='N' AND BETWEEN(THIS.nTipoImagen,1,2),THIS.nTipoImagen,1)

		THIS.cEntidadOrigen		= tcEntidadOrigen
		THIS.cCamposClaveOrigen	= tcCamposClaveOrigen
		THIS.cValoresClaveOrigen= tcValoresClaveOrigen
		THIS.cCampoImagenFrente	= tcCampoImagenFrente
		THIS.cCampoImagenEspalda= tcCampoImagenEspalda
		THIS.nTipoImagen		= tnTipoImagen
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_img_desarrollo_version
**************************************************


**************************************************
*-- Class:        base_label (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   04/11/00 12:11:12 PM
*
DEFINE CLASS base_label AS label


	AutoSize = .T.
	BackStyle = 0
	Caption = "Label1"
	Height = 17
	Width = 40
	ForeColor = RGB(0,0,255)
	Name = "base_label"


ENDDEFINE
*
*-- EndDefine: base_label
**************************************************


**************************************************
*-- Class:        base_label_shape (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_label (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/11/00 12:12:05 PM
*
DEFINE CLASS base_label_shape AS base_label


	AutoSize = .F.
	Alignment = 2
	BackStyle = 1
	ForeColor = RGB(255,0,0)
	BackColor = RGB(223,223,223)
	Name = "base_label_shape"


ENDDEFINE
*
*-- EndDefine: base_label_shape
**************************************************


**************************************************
*-- Class:        base_listbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Time Stamp:   06/01/00 02:25:14 PM
*
DEFINE CLASS base_listbox AS listbox


	Height = 170
	Width = 100
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_listbox"


	PROCEDURE Init
		THIS.LISTINDEX	= 1
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_listbox
**************************************************


**************************************************
*-- Class:        base_optiongroup (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  optiongroup
*-- BaseClass:    optiongroup
*-- Time Stamp:   04/11/00 12:23:13 PM
*
DEFINE CLASS base_optiongroup AS optiongroup


	AutoSize = .F.
	ButtonCount = 2
	BackStyle = 0
	BorderStyle = 0
	Value = 1
	Height = 27
	Width = 143
	Name = "base_optiongroup"
	Option1.BackStyle = 0
	Option1.Caption = "Option1"
	Option1.Value = 1
	Option1.Enabled = .T.
	Option1.Height = 17
	Option1.Left = 5
	Option1.Top = 5
	Option1.Width = 61
	Option1.ForeColor = RGB(0,0,255)
	Option1.DisabledForeColor = RGB(0,0,0)
	Option1.Name = "Option1"
	Option2.BackStyle = 0
	Option2.Caption = "Option2"
	Option2.Enabled = .T.
	Option2.Height = 17
	Option2.Left = 77
	Option2.Top = 5
	Option2.Width = 61
	Option2.ForeColor = RGB(0,0,255)
	Option2.DisabledForeColor = RGB(0,0,0)
	Option2.Name = "Option2"


ENDDEFINE
*
*-- EndDefine: base_optiongroup
**************************************************


**************************************************
*-- Class:        base_pageframe (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  pageframe
*-- BaseClass:    pageframe
*-- Time Stamp:   08/25/00 02:12:09 PM
*
DEFINE CLASS base_pageframe AS pageframe


	ErasePage = .T.
	PageCount = 2
	Width = 241
	Height = 169
	Name = "base_pageframe"
	Page1.Caption = "Page1"
	Page1.Name = "Page1"
	Page2.Caption = "Page2"
	Page2.Name = "Page2"


	PROCEDURE Refresh
			LOCAL m.lnCount1
		*	Recorrer todos las Páginas del PageFrame
			FOR m.lnCount1 = 1 TO THIS.PAGECOUNT
				THIS.PAGES(m.lnCount1).FONTBOLD	= m.lnCount1 == THIS.ACTIVEPAGE
			ENDFOR
	ENDPROC


	PROCEDURE Init
		*!*	-------------------------------------------------------------------------------
		*!*	Titulo			:
		*!*	Propósito		:	Configurar el PageFrame de acuerdo al Estandar
		*!*
		*!*	PARÁMETROS		:	<Ninguno>
		*!*	Valor de retorno:	<Ninguno>
		*!*	LLAMADAS		:	<Ninguno>
		*!*	CLASES HEREDADAS
		*!*	Comentarios 	:
		*!*
		*!*	CREACIÓN
		*!*		Fecha  		:	29-Oct-1999
		*!*		Autor		:	Giuliano Gonzales Zeballos
		*!*		Comentario	:
		*!*
		*!*	ULTIMA MODIFICACIÓN
		*!*		Fecha		:
		*!*		Autor		:
		*!*		Comentario	:
		*!*	-------------------------------------------------------------------------------
		LOCAL m.lnCount1

		*!*	Recorrer todos las Páginas del PageFrame
		FOR m.lnCount1 = 1 TO THIS.PAGECOUNT
			WITH THIS.PAGES(m.lnCount1)
				.FONTSIZE	= 9
				.FORECOLOR	= RGB(255,0,0)		&& Rojo Oscuro
				.BACKCOLOR	= RGB(223,223,223)	&& Gris Claro
			ENDWITH
		ENDFOR
		*THIS.CLICK()
		THIS.PAGES(1).FONTBOLD	= .T.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_pageframe
**************************************************


**************************************************
*-- Class:        base_shape (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Time Stamp:   04/11/00 12:23:08 PM
*
DEFINE CLASS base_shape AS shape


	Height = 17
	Width = 100
	BackStyle = 0
	SpecialEffect = 0
	Name = "base_shape"


ENDDEFINE
*
*-- EndDefine: base_shape
**************************************************


**************************************************
*-- Class:        base_spinner_moneda (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Time Stamp:   04/11/00 12:23:06 PM
*
DEFINE CLASS base_spinner_moneda AS spinner


	Height = 24
	InputMask = "999,999,999.99"
	Width = 120
	Format = "$KR"
	ForeColor = RGB(0,0,255)
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Value = "$0.0000"
	Name = "base_spinner_moneda"


	PROCEDURE InteractiveChange
		THIS.ForeColor = IIF(THIS.Value<0,RGB(255,0,0),RGB(0,0,255))
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_spinner_moneda
**************************************************


**************************************************
*-- Class:        base_spinner_numero (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Time Stamp:   04/11/00 12:22:14 PM
*
DEFINE CLASS base_spinner_numero AS spinner


	Height = 24
	InputMask = "999,999.99"
	KeyboardHighValue = 999999
	KeyboardLowValue = 0
	SpinnerHighValue = 999999.99
	SpinnerLowValue =   0.00
	Width = 120
	Format = "KR"
	ForeColor = RGB(0,0,255)
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_spinner_numero"


	PROCEDURE InteractiveChange
		THIS.ForeColor = IIF(THIS.Value<0,RGB(255,0,0),RGB(0,0,255))
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_spinner_numero
**************************************************


**************************************************
*-- Class:        base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   07/22/03 10:49:03 PM
*
DEFINE CLASS base_textbox AS textbox


	Height = 23
	Width = 100
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	*-- Cadena para buqueda incremental
	csearchstring = ""
	Name = "base_textbox"


	*-- Busqueda de texto digitado
	PROCEDURE search
		*
		* Search for the requested text
		*
		* Parameters:
		*  None
		*
		LOCAL lcField, lcValue, lnLength, llOk, lcOldFilter, lcOldExact
		lcOldExact  = SET('Exact')
		lcField     = This.ControlSource
		lcValue     = This.cSearchString
		lnLength    = LENC(lcValue)
		llOk        = .F.

		*
		* Set exact off for the locate
		*
		SET EXACT OFF

		IF TYPE(lcField) = 'C'
		   *
		   * We only search in text fields
		   *
		   IF lnLength = 0
		      lcCommand = 'SET FILTER TO'
		   ELSE
		      lcCommand = 'SET FILTER TO ' + lcField + ' = "' + lcValue + '"'
		   ENDIF
		   &lcCommand

		   LOCATE
		   llOk = FOUND()

		   IF llOk
		      *
		      * Found some data
		      *
		      lcSearchString = This.cSearchString
		      THIS.Parent.Parent.Refresh()
		      This.cSearchString = lcSearchString
		   ENDIF
		ENDIF

		*
		* Reset exact to the old state
		*
		SET EXACT &lcOldExact

		RETURN llOk
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox
**************************************************


**************************************************
*-- Class:        base_textbox_fecha (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   02/16/00 04:42:01 PM
*
DEFINE CLASS base_textbox_fecha AS base_textbox


	DateFormat = 11
	DateMark = "/"
	Alignment = 3
	Value = ({})
	Format = "KD"
	Name = "base_textbox_fecha"


ENDDEFINE
*
*-- EndDefine: base_textbox_fecha
**************************************************


**************************************************
*-- Class:        base_textbox_label (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   02/18/00 02:18:01 PM
*
DEFINE CLASS base_textbox_label AS base_textbox


	DisabledForeColor = RGB(0,0,255)
	Name = "base_textbox_label"


ENDDEFINE
*
*-- EndDefine: base_textbox_label
**************************************************


**************************************************
*-- Class:        base_textbox_moneda (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/11/00 12:22:00 PM
*
DEFINE CLASS base_textbox_moneda AS base_textbox


	Alignment = 3
	Value = "$0.0000"
	Format = "$KR"
	Height = 23
	InputMask = "999,999,999.99"
	Width = 100
	ForeColor = RGB(0,0,255)
	DisabledBackColor = RGB(223,223,223)
	Name = "base_textbox_moneda"


	PROCEDURE InteractiveChange
		THIS.ForeColor = IIF(THIS.Value<0,RGB(255,0,0),RGB(0,0,255))
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox_moneda
**************************************************


**************************************************
*-- Class:        base_textbox_numero (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   04/11/00 12:21:12 PM
*
DEFINE CLASS base_textbox_numero AS base_textbox


	Alignment = 3
	Value = 0
	Format = "KR"
	Height = 23
	InputMask = "999,999,999.99"
	Width = 100
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_textbox_numero"


	PROCEDURE InteractiveChange
		THIS.ForeColor = IIF(THIS.Value<0,RGB(255,0,0),RGB(0,0,255))
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox_numero
**************************************************


**************************************************
*-- Class:        base_textbox_texto (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   06/01/00 02:31:08 PM
*
DEFINE CLASS base_textbox_texto AS base_textbox


	Value = ("")
	Format = "K"
	Height = 23
	Width = 100
	ForeColor = RGB(0,0,0)
	DisabledBackColor = RGB(223,223,223)
	DisabledForeColor = RGB(0,0,0)
	Name = "base_textbox_texto"


ENDDEFINE
*
*-- EndDefine: base_textbox_texto
**************************************************


**************************************************
*-- Class:        base_textbox_serie (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox_texto (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   12/13/06 06:23:04 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS base_textbox_serie AS base_textbox_texto


	MaxLength = 254
	*-- Series separadas por delimitador
	cseries = ([])
	Name = "base_textbox_serie"

	*-- arreglo que almacena las series
	DIMENSION aseries[1,1]


	*-- Cadena separado por delimitador a un arreglo
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


	PROCEDURE KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		LOCAL lcOldSearchString, lnLength
		IF VARTYPE(THIS.PARENT.PARENT.COLUMNS(3))='O'
			IF THIS.PARENT.PARENT.COLUMNS(3).READONLY
				RETURN
			ENDIF
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
		*!*			IF !EMPTY(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value)
		*!*				=SEEK(thisform.pgfDetalle.page1.grdDetalle.column1.txtCodMatGrd.Value,"CATG")
		*!*				Thisform.pgfDetalle.page1.grdDetalle.column2.txtDesMatGrd.Value = IIF(EMPTY(C_DTRA.Desmat) OR (C_DTRA.CodMat2<>C_DTRA.CodMat),CATG.DesMat,C_DTRA.Desmat)
		*!*				Thisform.pgfDetalle.page1.grdDetalle.column3.txtUndStkGrd.Value = CATG.UndStk

		*!*				KEYBOARD '{TAB}{TAB}'
		*!*			ENDIF
		*!*			IF EMPTY(this.Value) OR TnKeyCode=F8
		*!*				thisform.pgfDetalle.page1.cmdHelp_CodMat.Click()
		*!*				KEYBOARD '{TAB}{TAB}'
		*!*			ENDIF

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


	PROCEDURE Valid
		IF EMPTY(this.Value)
			RETURN .f.
		ENDIF 
		LOCAL LsCodMat as String,LdFchDoc as Date , LnCanDes as Number 

		LsCodMat = EVALUATE(this.Parent.Parent.Recordsource+'.CodMat')
		LnCanDes = EVALUATE(this.Parent.Parent.Recordsource+'.CanDes')

		LsOrderSeri	= ''
		LsOrderDO_C	= ''
		LlCierraSeri = .F.
		LlCierraDO_C = .F.
		LnSelectAct=SELECT()
		*** Comprobamos que esten abiertas los alias / tablas que vamos a actualizar
		IF !USED('DSER')
			IF !VARTYPE(Lodatadm)=='O'
				LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
				LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
			ENDIF
			LsCierraSeri=LoDatAdm.abrirtabla('ABRIR','ALMDSERI',"DSER",'DSER05','')
		ELSE
			LsOrderSeri=ORDER('DSER')
		ENDIF
		*!*	IF !USED('DO_C')
		*!*		IF !VARTYPE(Lodatadm)=='O'
		*!*			LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		*!*			LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		*!*		ENDIF
		*!*		LlCierraDO_C=LoDatAdm.abrirtabla('ABRIR','CMPDO_CG',"DO_C",'DO_C01','')

		*!*	ELSE
		*!*		LsOrderDO_C=ORDER('DSER')
		*!*	ENDIF
		THIS.cSeries	=	THIS.Value 
		THIS.cSeries	=	IIF( VARTYPE(THIS.cSeries)<>"C" , "" , ALLTRIM(THIS.cSeries) )

		DIMENSION aCampos[1]
		DIMENSION THIS.aSeries[1,1] 
		IF !EMPTY( THIS.cSeries )
			THIS.ChrToArray( THIS.cSeries, "," , @aCampos )
			=ACOPY(aCampos, THIS.aseries  )
		ENDIF
		LdFchDoc = this.Parent.Parent.Parent.txtFchDoc.value
		LdFchDoc = IIF(VARTYPE(LdFchDoc)='T',TTOD(LdFchDoc),LdFchDoc)
		LnTotSer = ALEN(this.aSeries)
		IF LnTotSer<>LnCandes
			IF LnCandes>LnTotser
				=MESSAGEBOX('El numero de items leidos es menor ',16,'Verificar !!') 
			ELSE
				=MESSAGEBOX('El numero de items leidos es mayor ',16,'Verificar !!') 
			ENDIF
			RETURN .f.
		ENDIF
		SELECT dser
		SET ORDER TO DSERI05   && CODMAT+SERIE 
		LsSerie=PADR(THIS.aSeries[1],LEN(DSER.Serie))
		SEEK LsCodMat+LsSerie
		IF FOUND()
			**TmpEnt  + IIF(UniGar='A',365*Garantia,IIF(UniGar='M',30*Garantia,Garantia))
			this.Parent.Parent.Column8.Controls(2).Value = LdFchDoc + TmpEnt + ;
			IIF(UniGar='A',365*Garantia,IIF(UniGar='M',30*Garantia,Garantia))
		ELSE
			=MESSAGEBOX('Verificar numero de serie',16) 
			RELEASE LoDatAdm
			RETURN .f.
		ENDIF


		RELEASE LoDatAdm
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox_serie
**************************************************


**************************************************
*-- Class:        base_textbox_cmdhelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   05/15/07 01:48:06 AM
*
DEFINE CLASS base_textbox_cmdhelp AS container


	Width = 408
	Height = 25
	BackStyle = 0
	BorderWidth = 0
	*-- Describe la etiqueta del control Label contenido en el Conteiner
	cetiqueta = ("Codigo")
	*-- Propiedad definida por el Usuario
	value = ("")
	caliascursor = (SYS(2015))
	cnombreentidad = ("")
	ccamporetorno = ("")
	ccampovisualizacion = ("")
	cmodoobtenerdatos = "V"
	ctituloayuda = "Ayuda de Codigos"
	ccamposfiltro = ("")
	*-- Asigna los valores de filtro correspondientes para cada campo de filtro (cCamposFiltro)
	cvaloresfiltro = ("")
	lvalidadato = .T.
	corderby = ""
	*-- Utiliza sentencia having para extraer datos del cursor generado por la consulta
	lhaving = .F.
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="lhaving" type="property" display="lHaving"/><memberdata name="chavingsql" type="property" display="cHavingSql"/><memberdata name="ccampobusqueda" type="property" display="cCampoBusqueda"/></VFPData>]
	*-- Expresion para la clausula having
	chavingsql = ([])
	*-- Campo de busqueda , por defecto es el campo que ocupa la segunda posicion en el cursor de consulta
	ccampobusqueda = ([])
	Name = "base_textbox_cmdhelp"

	*-- Se ingresa sentencia para la Clausua WHERE en lenguaje SQL (incluir operador AND,OR)
	cwheresql = .F.

	*-- Especifica el origen de datos al que está vinculado un objeto.
	controlsource = .F.
	lsolo2columnas = .F.


	ADD OBJECT txtcodigo AS base_textbox_texto WITH ;
		Format = "K!", ;
		Height = 24, ;
		InputMask = "", ;
		Left = 60, ;
		Top = 0, ;
		Width = 84, ;
		Name = "txtCodigo"


	ADD OBJECT cmdhelp AS base_cmdhelp WITH ;
		Top = 0, ;
		Left = 156, ;
		TabStop = .F., ;
		lvalidadato = .F., ;
		Name = "cmdHelp"


	ADD OBJECT txtdescripcion AS base_textbox WITH ;
		Enabled = .F., ;
		Height = 24, ;
		Left = 192, ;
		Top = 0, ;
		Width = 216, ;
		Name = "txtDescripcion"


	ADD OBJECT lblcaption AS base_label WITH ;
		Caption = "Etiqueta", ;
		Height = 17, ;
		Left = 0, ;
		Top = 3, ;
		Width = 47, ;
		Name = "lblCaption"


	PROCEDURE value_assign
		LPARAMETERS tcCodigo
		THIS.VALUE = tcCodigo
		IF VARTYPE(tcCodigo)=='C'
			IF EMPTY(tcCodigo)
				THIS.txtCodigo.VALUE		= ""
				THIS.txtDescripcion.VALUE	= SPACE(30)
				RETURN
			ENDIF
			*IF THIS.txtCodigo.VALUE	<> tcCodigo
				THIS.txtCodigo.VALUE	= tcCodigo
				IF THIS.lValidaDato
					THIS.txtCodigo.VALID()
				ENDIF
			*ENDIF
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE enabled_assign
		LPARAMETERS tlEnabled
		THIS.Enabled = tlEnabled
		THIS.txtCodigo.ENABLED	= tlEnabled
		THIS.cmdHelp.ENABLED	= tlEnabled
	ENDPROC


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		IF VARTYPE(tcWhereSQL)<>"C"
			tcWhereSQL = ""
		ELSE
			tcWhereSQL = ALLTRIM(tcWhereSQL)
		ENDIF
		THIS.cWhereSQL= tcWhereSQL
		THIS.cmdHelp.cWhereSQL = tcWhereSQL
	ENDPROC


	PROCEDURE controlsource_assign
		LPARAMETERS tcControlSOurce
		tcControlSource	= IIF(VARTYPE(tcControlSOurce)=='C',ALLTRIM(tcControlSOurce),'')
		THIS.CONTROLSOURCE = tcControlSource
		THIS.txtCodigo.CONTROLSOURCE = THIS.CONTROLSOURCE
		THIS.txtCodigo.VALID()
	ENDPROC


	PROCEDURE cmodoobtenerdatos_assign
		LPARAMETERS tcModoObtenerDatos
		IF !EMPTY(tcModoObtenerDatos)
			THIS.cModoObtenerdatos = tcModoObtenerDatos
			This.cmdHelp.cModoObtenerDatos = tcModoObtenerDatos
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE cetiqueta_assign
		LPARAMETERS tcEtiqueta
		THIS.cEtiqueta = tcEtiqueta
		THIS.lblCaption.Caption = tcEtiqueta
	ENDPROC


	HIDDEN PROCEDURE cnombreentidad_assign
		LPARAMETERS tcNombreEntidad
		THIS.cnombreentidad = tcNombreEntidad

		IF THIS.cmdHelp.ConfigurarParametros(THIS.VALUE,;
			THIS.cNombreEntidad, THIS.cCampoRetorno, THIS.cCampoVisualizacion,;
			THIS.lValidaDato, THIS.cCamposFiltro, THIS.cValoresFiltro)
			THIS.cWhereSQL			= THIS.cWhereSQL
			THIS.cModoObtenerdatos	= THIS.cModoObtenerdatos
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE cvaloresfiltro_assign
		LPARAMETERS tcValoresFiltro
		THIS.cValoresFiltro = tcValoresFiltro
		THIS.cmdHelp.cValoresFiltro = tcValoresFiltro
	ENDPROC


	HIDDEN PROCEDURE caliascursor_assign
		LPARAMETERS tcAliasCursor
		IF !ISNULL(tcAliasCursor) AND !EMPTY(tcAliasCursor)
			THIS.cAliasCursor = tcAliasCursor
			This.cmdHelp.cAliasCursor = tcAliasCursor
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ccamporetorno_assign
		LPARAMETERS tcCampoRetorno
		THIS.cCampoRetorno = tcCampoRetorno
		THIS.cmdHelp.cCampoRetorno = tcCampoRetorno
	ENDPROC


	HIDDEN PROCEDURE ccamposfiltro_assign
		LPARAMETERS tcCamposFiltro
		THIS.cCamposFiltro = tcCamposFiltro
		THIS.cmdHelp.cCamposFiltro = tcCamposFiltro
	ENDPROC


	HIDDEN PROCEDURE ccampovisualizacion_assign
		LPARAMETERS tcCamposVisualizacion
		THIS.cCampoVisualizacion = tcCamposVisualizacion
		THIS.cmdHelp.cCampoVisualizacion = tcCamposVisualizacion
	ENDPROC


	HIDDEN PROCEDURE ctituloayuda_assign
		LPARAMETERS tcTituloAyuda
		THIS.cTituloAyuda = tcTituloAyuda
		THIS.cmdHelp.cTituloAyuda = tcTituloAyuda
	ENDPROC


	HIDDEN PROCEDURE lvalidadato_assign
		LPARAMETERS tlValidaDato
		THIS.lValidaDato = tlValidaDato
		THIS.cmdHelp.lValidaDato = tlValidaDato
	ENDPROC


	HIDDEN PROCEDURE lsolo2columnas_assign
		LPARAMETERS TlSolo2Columnas
		THIS.lsolo2columnas = TlSolo2Columnas
		this.cmdhelp.lsolo2columnas = TlSolo2Columnas
	ENDPROC


	PROCEDURE corderby_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		THIS.corderby = m.vNewVal
		this.cmdhelp.corderby = m.vNewVal
	ENDPROC


	PROCEDURE lhaving_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		THIS.lHaving = m.vNewVal
		this.cmdhelp.lHaving = m.vNewVal
	ENDPROC


	PROCEDURE chavingsql_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		IF VARTYPE(m.vNewVal)<>"C"
			m.vNewVal = ""
		ELSE
			m.vNewVal = ALLTRIM(m.vNewVal)
		ENDIF
		THIS.cHavingSql = m.vNewVal
		this.cmdhelp.cHavingSql =  m.vNewVal
	ENDPROC


	PROCEDURE Init
		THIS.lblCaption.Caption = THIS.cEtiqueta 
		THIS.ControlSource		= THIS.ControlSource
		THIS.ENABLED			= THIS.ENABLED
		THIS.cAliasCursor		= THIS.cAliasCursor
		THIS.cTituloAyuda		= THIS.cTituloAyuda
		this.lSolo2columnas		= this.lsolo2columnas
		this.cOrderBy			= this.cOrderBy 
		this.lHaving 			= this.lhaving
		this.cHavingSql 		= this.cHavingSql 
		this.cCampoBusqueda 	= this.cCampoBusqueda 

		IF THIS.cmdHelp.ConfigurarParametros(THIS.VALUE,;
			THIS.cNombreEntidad, THIS.cCampoRetorno, THIS.cCampoVisualizacion,;
			THIS.lValidaDato, THIS.cCamposFiltro, THIS.cValoresFiltro)

			THIS.cWhereSQL			= THIS.cWhereSQL
			THIS.cModoObtenerdatos	= THIS.cModoObtenerdatos
		ENDIF
	ENDPROC


	PROCEDURE SetFocus
		THIS.txtCodigo.SETFOCUS()
	ENDPROC


	PROCEDURE ccampobusqueda_assign
		LPARAMETERS LcCampoBusqueda
		*To do: Modify this routine for the Assign method
		LcCampoBusqueda = IIF(VARTYPE(LcCampoBusqueda)='C',LcCampoBusqueda,'')
		THIS.cCampoBusqueda = LcCampoBusqueda
		this.cmdhelp.cCampoBusqueda =  LcCampoBusqueda
	ENDPROC


	*-- Actualizar otros controles segun el valor del control
	PROCEDURE actualizarcontroles
	ENDPROC


	PROCEDURE txtcodigo.Valid
		IF TYPE("THISFORM")=="O"
			IF !THISFORM.lCargado
				RETURN .T.
			ENDIF
		ENDIF

		IF EMPTY(THIS.VALUE)
			THIS.PARENT.VALUE = ""
			RETURN .T.
		ENDIF

		IF THIS.PARENT.lValidaDato
			IF THIS.PARENT.cmdHelp.ValidarDato(THIS.VALUE)
				IF !EMPTY(THIS.PARENT.cmdHelp.cValorValida)
					THIS.VALUE = THIS.PARENT.cmdHelp.cValorValida
					THIS.PARENT.VALUE = THIS.PARENT.cmdHelp.cValorValida
					THIS.PARENT.txtDescripcion.VALUE = THIS.PARENT.cmdHelp.cValorDescripcion
				ENDIF
			ELSE
				THIS.PARENT.VALUE = ""
				THIS.VALUE = ""
				THIS.PARENT.txtDescripcion.VALUE = ""
				RETURN 0
			ENDIF
		ENDIF

		THIS.PARENT.cmdHelp.cValorValida		= SPACE(0)
		THIS.PARENT.cmdHelp.cValorDescripcion	= SPACE(0)

		IF	!EMPTY(THIS.PARENT.cmdHelp.cAliasCursor) AND ;
				!ISNULL(THIS.PARENT.cmdHelp.cAliasCursor) AND ;
				USED(THIS.PARENT.cmdHelp.cAliasCursor)
			USE IN THIS.PARENT.cmdHelp.cAliasCursor
		ENDIF
	ENDPROC


	PROCEDURE cmdhelp.Click
		Base_cmdHelp::CLICK()

		IF !EMPTY(THIS.cValorValida)
			THIS.PARENT.txtCodigo.VALUE 		= THIS.cValorValida
			THIS.PARENT.txtDescripcion.VALUE 	= THIS.cValorDescripcion
			THIS.PARENT.VALUE 					= THIS.cValorValida
			THIS.PARENT.txtCodigo.VALID()
			*SETFOCUS()
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_textbox_cmdhelp
**************************************************


**************************************************
*-- Class:        cntcodcta (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  base_textbox_cmdhelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    container
*-- Time Stamp:   07/19/03 03:11:01 PM
*
DEFINE CLASS cntcodcta AS base_textbox_cmdhelp


	Width = 74
	Height = 24
	Name = "cntcodcta"
	txtCodigo.FontSize = 8
	txtCodigo.Height = 20
	txtCodigo.Left = 0
	txtCodigo.Top = 0
	txtCodigo.Width = 60
	txtCodigo.ZOrderSet = 1
	txtCodigo.Name = "txtCodigo"
	cmdHelp.Top = -1
	cmdHelp.Left = 63
	cmdHelp.Height = 24
	cmdHelp.Width = 12
	cmdHelp.ZOrderSet = 2
	cmdHelp.Name = "cmdHelp"
	txtDescripcion.Height = 24
	txtDescripcion.Left = 96
	txtDescripcion.Top = 0
	txtDescripcion.Width = 13
	txtDescripcion.ZOrderSet = 3
	txtDescripcion.Name = "txtDescripcion"
	lblCaption.Caption = ""
	lblCaption.Left = 0
	lblCaption.Top = 0
	lblCaption.ZOrderSet = 0
	lblCaption.Name = "lblCaption"


ENDDEFINE
*
*-- EndDefine: cntcodcta
**************************************************


**************************************************
*-- Class:        cntlookup (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   11/13/03 12:57:10 PM
*
DEFINE CLASS cntlookup AS container


	Width = 429
	Height = 175
	Name = "cntlookup"


	ADD OBJECT grid1 AS base_grid WITH ;
		ColumnCount = 4, ;
		Height = 153, ;
		Left = 21, ;
		Panel = 1, ;
		RecordSource = "", ;
		RecordSourceType = 0, ;
		Top = 9, ;
		Width = 303, ;
		Name = "grid1", ;
		Column1.ControlSource = "", ;
		Column1.Width = 61, ;
		Column1.ReadOnly = .T., ;
		Column1.Name = "Column1", ;
		Column2.ControlSource = "", ;
		Column2.CurrentControl = "Text1", ;
		Column2.Width = 93, ;
		Column2.ReadOnly = .T., ;
		Column2.Sparse = .F., ;
		Column2.Name = "Column2", ;
		Column3.CurrentControl = "Base_textbox_fecha1", ;
		Column3.Width = 96, ;
		Column3.ReadOnly = .T., ;
		Column3.Name = "Column3", ;
		Column4.CurrentControl = "Base_checkbox1", ;
		Column4.Width = 23, ;
		Column4.Sparse = .F., ;
		Column4.Name = "Column4"


	ADD OBJECT cntlookup.grid1.column1.header1 AS header WITH ;
		Caption = "Codigo", ;
		Name = "Header1"


	ADD OBJECT cntlookup.grid1.column1.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntlookup.grid1.column2.header1 AS header WITH ;
		FontName = "Arial", ;
		Caption = "Descripción", ;
		Name = "Header1"


	ADD OBJECT cntlookup.grid1.column2.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ReadOnly = .T., ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntlookup.grid1.column3.header1 AS header WITH ;
		Caption = "Otro dato", ;
		Name = "Header1"


	ADD OBJECT cntlookup.grid1.column3.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntlookup.grid1.column3.base_textbox_fecha1 AS base_textbox_fecha WITH ;
		Left = 18, ;
		ReadOnly = .T., ;
		Top = 32, ;
		Name = "Base_textbox_fecha1"


	ADD OBJECT cntlookup.grid1.column4.header1 AS header WITH ;
		FontName = "Marlett", ;
		Caption = "a", ;
		Name = "Header1"


	ADD OBJECT cntlookup.grid1.column4.text1 AS textbox WITH ;
		BorderStyle = 0, ;
		Margin = 0, ;
		ForeColor = RGB(0,0,0), ;
		BackColor = RGB(255,255,255), ;
		Name = "Text1"


	ADD OBJECT cntlookup.grid1.column4.base_checkbox1 AS base_checkbox WITH ;
		Top = 20, ;
		Left = 36, ;
		Caption = "", ;
		Name = "Base_checkbox1"


	ADD OBJECT cmdaceptar2 AS cmdprocesar WITH ;
		Top = 102, ;
		Left = 332, ;
		Height = 55, ;
		Width = 48, ;
		Picture = "..\..\grafgen\iconos\volver.ico", ;
		Caption = "\<Volver", ;
		ZOrderSet = 5, ;
		Name = "CmdAceptar2"


	ADD OBJECT cmdprocesar1 AS cmdprocesar WITH ;
		Top = 55, ;
		Left = 330, ;
		Height = 24, ;
		Width = 96, ;
		Picture = "..\..\..\tdv\graficosgenerales\iconos\procesar.bmp", ;
		Caption = "\<Desmarcar Todos", ;
		ZOrderSet = 5, ;
		Name = "Cmdprocesar1"


	ADD OBJECT cmdprocesar3 AS cmdprocesar WITH ;
		Top = 24, ;
		Left = 330, ;
		Height = 24, ;
		Width = 96, ;
		Picture = "..\..\..\tdv\graficosgenerales\iconos\procesar.bmp", ;
		Caption = "\<Invertir Selección", ;
		ZOrderSet = 5, ;
		Name = "Cmdprocesar3"


	PROCEDURE iniciar_var
		this.grid1.RECORDSOURCETYPE	= 1
		this.grid1.RECORDSOURCE		= ''

		this.grid1.COLUMNS(1).CONTROLSOURCE	= 'AUXI.CODDOC'
		this.grid1.COLUMNS(2).CONTROLSOURCE	= 'AUXI.NRODOC'
		this.grid1.COLUMNS(3).CONTROLSOURCE	= 'AUXI.FCHDOC'
		this.grid1.COLUMNS(4).CONTROLSOURCE	= 'AUXI.selec'
		this.grid1.refresh
	ENDPROC


	PROCEDURE cmdaceptar2.Click
		this.Parent.cnrodocs_ref = ''
		SELECT AUXI
		SCAN 
			IF selec 
				replace FlgEst	WITH '*'
				this.Parent.cnrodocs_ref = this.Parent.cnrodocs_ref + NroDoc+','
			ELSE
				replace Flgest WITH ''
			ENDIF

		ENDSCAN
		LOCATE
		LnPos = RAT(',',this.Parent.cnrodocs_ref)
		this.Parent.cnrodocs_ref = IIF(LnPos>0,LEFT(this.Parent.cnrodocs_ref,LnPos-1),this.Parent.cnrodocs_ref)
		*thisform.ObjCntPage.TxtNroRef.Valid()

		*thisform.LockScreen = .T.
		this.Parent.Visible = .F.
		thisform.Refresh

		thisform.PgfDetalle.Activepage=2
		thisform.PgfDetalle.Activepage=1
		IF !EMPTY(this.Parent.cnrodocs_ref)
			thisform.PgfDetalle.PAGES(1).TxtObserv.Value = this.Parent.cnrodocs_ref
			thisform.ObjCntPage.TxtNroRef.SetFocus()
			KEYBOARD '{END}'+'{ENTER}'
		ENDIF

		*thisform.LockScreen = .f.
	ENDPROC


	PROCEDURE cmdprocesar1.Click
		IF This.Caption="\<Desmarcar Todos"
			replace all selec with .f.
			GO TOP
			This.Caption="\<Marcar Todos"
			THIS.PARENT.GRID1.REFRESH
		ELSE
			replace all selec with .T.
			GO TOP
			This.Caption="\<Desmarcar Todos"
			THIS.PARENT.GRID1.REFRESH
		ENDIF
	ENDPROC


	PROCEDURE cmdprocesar3.Click
		SCAN
			IF selec
				replace selec with .f. 
			ELSE
				replace selec with .T. 
			ENDIF
		ENDSCAN
		GO TOP
		THIS.PARENT.GRID1.REFRESH
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cntlookup
**************************************************
